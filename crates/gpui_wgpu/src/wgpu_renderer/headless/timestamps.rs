//! Bounded GPU timestamp queries and validated pass envelopes.
use super::*;

pub(super) struct TimestampResources {
    period_ns: f32,
    query_set: wgpu::QuerySet,
    resolve_buffer: wgpu::Buffer,
    readback_buffer: wgpu::Buffer,
    query_capacity: u32,
    next_query: Cell<u32>,
}

impl TimestampResources {
    pub(super) fn new(device: &wgpu::Device, period_ns: f32, query_capacity: u32) -> Self {
        assert!(query_capacity > 0 && query_capacity <= wgpu::QUERY_SET_MAX_QUERIES);
        let buffer_size = u64::from(query_capacity) * 8;
        let query_set = device.create_query_set(&wgpu::QuerySetDescriptor {
            label: Some("gpui_frame_timestamps"),
            ty: wgpu::QueryType::Timestamp,
            count: query_capacity,
        });
        let resolve_buffer = device.create_buffer(&wgpu::BufferDescriptor {
            label: Some("gpui_timestamp_resolve"),
            size: buffer_size,
            usage: wgpu::BufferUsages::QUERY_RESOLVE | wgpu::BufferUsages::COPY_SRC,
            mapped_at_creation: false,
        });
        let readback_buffer = device.create_buffer(&wgpu::BufferDescriptor {
            label: Some("gpui_timestamp_readback"),
            size: buffer_size,
            usage: wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
            mapped_at_creation: false,
        });
        Self {
            period_ns,
            query_set,
            resolve_buffer,
            readback_buffer,
            query_capacity,
            next_query: Cell::new(0),
        }
    }

    pub(super) fn ensure_capacity(
        &mut self,
        device: &wgpu::Device,
        required: u32,
    ) -> anyhow::Result<()> {
        if required <= self.query_capacity {
            return Ok(());
        }
        anyhow::ensure!(
            required <= wgpu::QUERY_SET_MAX_QUERIES,
            "scene needs {required} GPU timestamp queries, exceeding WGPU's limit of {}",
            wgpu::QUERY_SET_MAX_QUERIES
        );
        let buffer_size = u64::from(required) * 8;
        anyhow::ensure!(
            buffer_size <= device.limits().max_buffer_size,
            "scene needs {required} GPU timestamp queries, exceeding the device buffer limit"
        );
        *self = Self::new(device, self.period_ns, required);
        Ok(())
    }

    pub(super) fn reset(&self) {
        self.next_query.set(0);
    }

    pub(super) fn capture(&self) -> super::super::frame::TimestampCapture<'_> {
        super::super::frame::TimestampCapture {
            query_set: &self.query_set,
            resolve_buffer: &self.resolve_buffer,
            readback_buffer: &self.readback_buffer,
            next_query: &self.next_query,
            query_capacity: self.query_capacity,
        }
    }

    pub(super) fn resolution(&self) -> Duration {
        Duration::from_nanos(self.period_ns.ceil() as u64)
    }

    pub(super) fn read_duration(&self, device: &wgpu::Device) -> anyhow::Result<Option<Duration>> {
        let query_count = self.next_query.get();
        anyhow::ensure!(query_count % 2 == 0, "incomplete GPU timestamp pass pair");
        if query_count == 0 {
            return Ok(None);
        }
        let byte_count = u64::from(query_count) * 8;
        let (sender, receiver) = std::sync::mpsc::sync_channel(1);
        self.readback_buffer
            .slice(..byte_count)
            .map_async(wgpu::MapMode::Read, move |result| {
                let _ = sender.send(result);
            });
        device
            .poll(wgpu::PollType::Wait {
                submission_index: None,
                timeout: Some(Duration::from_secs(30)),
            })
            .map_err(|error| anyhow::anyhow!("failed to poll timestamp readback: {error}"))?;
        receiver
            .recv()
            .map_err(|error| anyhow::anyhow!("timestamp readback callback dropped: {error}"))??;
        let mapped = self.readback_buffer.slice(..byte_count).get_mapped_range();
        let samples = mapped.chunks_exact(16).map(|pair| {
            let start = u64::from_ne_bytes(pair[0..8].try_into().expect("timestamp is u64"));
            let end = u64::from_ne_bytes(pair[8..16].try_into().expect("timestamp is u64"));
            (start, end)
        });
        let duration = timestamp_envelope(samples, self.period_ns);
        drop(mapped);
        self.readback_buffer.unmap();
        duration
    }
}

pub(super) fn timestamp_envelope(
    samples: impl IntoIterator<Item = (u64, u64)>,
    period_ns: f32,
) -> anyhow::Result<Option<Duration>> {
    // Passes may overlap, so use their execution envelope rather than submission order.
    let mut envelope: Option<(u64, u64)> = None;
    for (index, (start, end)) in samples.into_iter().enumerate() {
        timestamp_duration(start, end, period_ns)
            .map_err(|error| anyhow::anyhow!("GPU timestamp pass {index}: {error:#}"))?;
        envelope = Some(match envelope {
            Some((first_start, last_end)) => (first_start.min(start), last_end.max(end)),
            None => (start, end),
        });
    }
    let Some((first_start, last_end)) = envelope else {
        return Ok(None);
    };
    timestamp_duration(first_start, last_end, period_ns).map(Some)
}

pub(super) fn timestamp_duration(start: u64, end: u64, period_ns: f32) -> anyhow::Result<Duration> {
    anyhow::ensure!(
        period_ns.is_finite() && period_ns > 0.0,
        "invalid GPU timestamp period"
    );
    let ticks = end
        .checked_sub(start)
        .ok_or_else(|| anyhow::anyhow!("GPU timestamp end ({end}) precedes start ({start})"))?;
    let elapsed_ns = ticks as f64 * f64::from(period_ns);
    anyhow::ensure!(
        elapsed_ns.is_finite() && elapsed_ns >= 0.0 && elapsed_ns.round() < u64::MAX as f64,
        "GPU timestamp interval cannot be represented as a duration: {ticks} ticks at {period_ns} ns/tick"
    );
    Ok(Duration::from_nanos(elapsed_ns.round() as u64))
}
