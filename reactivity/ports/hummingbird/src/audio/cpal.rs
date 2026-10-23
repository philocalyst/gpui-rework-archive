//! Real CPAL sink. Only the data callback has the allocation-free PCM contract;
//! CPAL's exceptional owned Error and backend teardown can allocate/free.
use super::{
    AudioError, Format,
    output::{OutputProvider, OutputStream, PlaybackGate},
};
use cpal::traits::{DeviceTrait, HostTrait, StreamTrait};
use rtrb::{Consumer, Producer, RingBuffer};
use std::sync::{
    Arc,
    atomic::{AtomicU32, AtomicU64, Ordering},
};

pub(super) struct CpalProvider;
fn error(error: cpal::Error) -> AudioError {
    AudioError::Output(error.to_string())
}
impl OutputProvider for CpalProvider {
    fn open(
        &mut self,
        _source: Format,
        gate: PlaybackGate,
        epoch: u64,
    ) -> Result<Box<dyn OutputStream>, AudioError> {
        let device = cpal::default_host()
            .default_output_device()
            .ok_or(AudioError::DeviceUnavailable)?;
        let default = device.default_output_config().map_err(error)?;
        let supported = if default.channels() <= 2 {
            default
        } else {
            device
                .supported_output_configs()
                .map_err(error)?
                .find(|config| config.channels() <= 2)
                .ok_or(AudioError::Unsupported("output channel layout"))?
                .with_max_sample_rate()
        };
        let format = Format {
            rate: supported.sample_rate(),
            channels: supported.channels(),
        }
        .checked()?;
        let config = supported.config();
        macro_rules! open {
            ($sample:ty) => {
                build::<$sample>(&device, config, format, gate, epoch)
            };
        }
        match supported.sample_format() {
            cpal::SampleFormat::F32 => open!(f32),
            cpal::SampleFormat::F64 => open!(f64),
            cpal::SampleFormat::I8 => open!(i8),
            cpal::SampleFormat::I16 => open!(i16),
            cpal::SampleFormat::I24 => open!(cpal::I24),
            cpal::SampleFormat::I32 => open!(i32),
            cpal::SampleFormat::U8 => open!(u8),
            cpal::SampleFormat::U16 => open!(u16),
            cpal::SampleFormat::U24 => open!(cpal::U24),
            cpal::SampleFormat::U32 => open!(u32),
            _ => Err(AudioError::Unsupported("output PCM sample type")),
        }
    }
}
trait OutputSample: cpal::SizedSample + Copy {
    fn pcm(value: f64) -> Self;
}
impl OutputSample for f32 {
    fn pcm(value: f64) -> Self {
        value as f32
    }
}
impl OutputSample for f64 {
    fn pcm(value: f64) -> Self {
        value
    }
}
macro_rules! signed {
    ($ty:ty, $scale:expr) => {
        impl OutputSample for $ty {
            fn pcm(value: f64) -> Self {
                (value * $scale).round() as Self
            }
        }
    };
}
signed!(i8, 128.);
signed!(i16, 32768.);
signed!(i32, 2_147_483_648.);
macro_rules! unsigned {
    ($ty:ty, $signed:ty) => {
        impl OutputSample for $ty {
            fn pcm(value: f64) -> Self {
                (<$signed>::pcm(value) as Self) ^ (<$signed>::MIN as Self)
            }
        }
    };
}
unsigned!(u8, i8);
unsigned!(u16, i16);
unsigned!(u32, i32);
impl OutputSample for cpal::I24 {
    fn pcm(value: f64) -> Self {
        Self::new(((value * 8_388_608.).round() as i32).clamp(-8_388_608, 8_388_607)).unwrap()
    }
}
impl OutputSample for cpal::U24 {
    fn pcm(value: f64) -> Self {
        Self::new(((value * 8_388_608.).round() as i32).clamp(-8_388_608, 8_388_607) + 8_388_608)
            .unwrap()
    }
}
struct Callback {
    samples: Consumer<f64>,
    gate: PlaybackGate,
    epoch: u64,
    channels: usize,
    gain: f64,
    step: f64,
    underruns: Arc<AtomicU64>,
}
impl Callback {
    fn render<T: OutputSample>(&mut self, output: &mut [T]) {
        output.fill(T::pcm(0.));
        if self.gate.0.closed.load(Ordering::Acquire)
            || self.gate.0.epoch.load(Ordering::Acquire) != self.epoch
        {
            self.gain = 0.;
            return;
        }
        let playing = self.gate.0.playing.load(Ordering::Relaxed);
        let maximum = output.len() / self.channels;
        let wanted = if playing {
            maximum
        } else {
            maximum.min((self.gain / self.step).ceil() as usize)
        };
        let read = (self.samples.slots() / self.channels).min(wanted) * self.channels;
        if read < wanted * self.channels {
            let previous = self.underruns.load(Ordering::Relaxed);
            self.underruns
                .store(previous.saturating_add(1), Ordering::Relaxed);
        }
        if let Ok(chunk) = self.samples.read_chunk(read) {
            let (one, two) = chunk.as_slices();
            for (index, sample) in one.iter().chain(two).enumerate() {
                if index % self.channels == 0 {
                    self.gain = if playing {
                        (self.gain + self.step).min(1.)
                    } else {
                        (self.gain - self.step).max(0.)
                    };
                }
                output[index] = T::pcm(*sample * self.gain);
            }
            chunk.commit_all();
        }
    }
}
struct CpalStream {
    // Stream closes before producer/status owners are released. Backend teardown
    // thread/latency behavior is a CPAL contract, not a data-callback guarantee.
    stream: Option<cpal::Stream>,
    samples: Producer<f64>,
    format: Format,
    capacity: usize,
    errors: Consumer<cpal::Error>,
    fault: Arc<AtomicU32>,
    _underruns: Arc<AtomicU64>,
}
fn fatal(error: &cpal::Error) -> bool {
    !matches!(
        error.kind(),
        cpal::ErrorKind::Xrun | cpal::ErrorKind::RealtimeDenied | cpal::ErrorKind::DeviceChanged
    )
}
fn retire_error(errors: &mut Producer<cpal::Error>, fault: &AtomicU32, error: cpal::Error) {
    // Ordinary formatting/reclamation is deferred. A full bounded retirement
    // ring can still free this exceptional owned error; never leak or block.
    if fatal(&error) {
        fault.store(1, Ordering::Release);
    }
    let _ = errors.push(error);
}
fn build<T: OutputSample>(
    device: &cpal::Device,
    config: cpal::StreamConfig,
    format: Format,
    gate: PlaybackGate,
    epoch: u64,
) -> Result<Box<dyn OutputStream>, AudioError> {
    let capacity = (format.rate as usize).div_ceil(10) * format.channels as usize;
    let (producer, consumer) = RingBuffer::new(capacity);
    let fault = Arc::new(AtomicU32::new(0));
    let fault_flag = fault.clone();
    let (mut errors, retired) = RingBuffer::new(4);
    let underruns = Arc::new(AtomicU64::new(0));
    let mut callback = Callback {
        samples: consumer,
        gate,
        epoch,
        channels: format.channels as usize,
        gain: 0.,
        step: 1. / (f64::from(format.rate) * 0.015),
        underruns: underruns.clone(),
    };
    let stream = device
        .build_output_stream(
            config,
            move |data: &mut [T], _| callback.render(data),
            move |error| retire_error(&mut errors, &fault_flag, error),
            None,
        )
        .map_err(error)?;
    Ok(Box::new(CpalStream {
        stream: Some(stream),
        samples: producer,
        format,
        capacity,
        errors: retired,
        fault,
        _underruns: underruns,
    }))
}
impl OutputStream for CpalStream {
    fn format(&self) -> Format {
        self.format
    }
    fn submit(&mut self, input: &[f64]) -> Result<usize, AudioError> {
        let channels = self.format.channels as usize;
        let count = input.len().min(self.samples.slots()) / channels * channels;
        self.samples
            .push_entire_slice(&input[..count])
            .map_err(|_| AudioError::Output("PCM ring capacity invariant".into()))?;
        Ok(count / channels)
    }
    fn queued_frames(&self) -> usize {
        (self.capacity - self.samples.slots()) / self.format.channels as usize
    }
    fn set_playing(&mut self, playing: bool) -> Result<(), AudioError> {
        if playing {
            self.stream.as_ref().unwrap().play()
        } else {
            self.stream.as_ref().unwrap().pause()
        }
        .map_err(error)
    }
    fn poll(&mut self) -> Result<(), AudioError> {
        while let Ok(error) = self.errors.pop() {
            if fatal(&error) {
                return Err(super::AudioError::Output(error.to_string()));
            }
        }
        if self.fault.load(Ordering::Acquire) != 0 {
            Err(AudioError::Output("CPAL stream invalidated".into()))
        } else {
            Ok(())
        }
    }
}
impl Drop for CpalStream {
    fn drop(&mut self) {
        self.stream.take();
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::audio::output::Gate;
    use std::sync::atomic::AtomicBool;

    fn callback(channels: usize, capacity: usize) -> (Producer<f64>, Callback) {
        let (producer, samples) = RingBuffer::new(capacity);
        (
            producer,
            Callback {
                samples,
                gate: PlaybackGate(Arc::new(Gate {
                    epoch: AtomicU64::new(1),
                    playing: AtomicBool::new(true),
                    closed: AtomicBool::new(false),
                })),
                epoch: 1,
                channels,
                gain: 1.,
                step: 0.25,
                underruns: Arc::new(AtomicU64::new(0)),
            },
        )
    }
    fn no_heap(operation: impl FnOnce()) {
        let allocation = allocation_counter::measure(operation);
        assert_eq!(allocation.count_total, 0, "{allocation:?}");
        assert_eq!(
            allocation.count_current, 0,
            "callback freed an owner: {allocation:?}"
        );
        assert_eq!(allocation.bytes_current, 0);
    }
    #[test]
    fn pcm_callback_wrap_empty_partial_pause_and_invalidation_never_allocate_or_free() {
        let (mut producer, mut callback) = callback(2, 8);
        let mut output = [9f64; 6];
        producer
            .push_entire_slice(&[0.1, -0.2, 0.3, -0.4, 0.5, -0.6])
            .unwrap();
        no_heap(|| callback.render(&mut output[..4]));
        assert_eq!(&output[..4], &[0.1, -0.2, 0.3, -0.4]);
        producer.push_entire_slice(&[0.7, -0.8, 0.9, -1.]).unwrap();
        no_heap(|| callback.render(&mut output));
        assert_eq!(output, [0.5, -0.6, 0.7, -0.8, 0.9, -1.]);
        no_heap(|| callback.render(&mut output));
        assert_eq!(output, [0.; 6]);
        assert_eq!(callback.underruns.load(Ordering::Relaxed), 1);
        producer.push_entire_slice(&[0.4, -0.4]).unwrap();
        no_heap(|| callback.render(&mut output));
        assert_eq!(output, [0.4, -0.4, 0., 0., 0., 0.]);
        producer.push_entire_slice(&[1.; 8]).unwrap();
        callback.gate.0.playing.store(false, Ordering::Release);
        let mut fade = [9f64; 10];
        no_heap(|| callback.render(&mut fade));
        assert_eq!(fade, [0.75, 0.75, 0.5, 0.5, 0.25, 0.25, 0., 0., 0., 0.]);
        producer.push_entire_slice(&[1.; 8]).unwrap();
        callback.gate.0.epoch.store(2, Ordering::Release);
        no_heap(|| callback.render(&mut fade));
        assert_eq!(fade, [0.; 10]);
        assert_eq!(
            callback.samples.slots(),
            8,
            "stale epoch must leave PCM untouched"
        );
        callback.gate.0.epoch.store(1, Ordering::Release);
        callback.gate.0.closed.store(true, Ordering::Release);
        no_heap(|| callback.render(&mut fade));
        assert_eq!(callback.samples.slots(), 8);
    }
    #[test]
    fn integer_conversions_are_saturating_total_and_unsigned_silence_is_centered() {
        assert_eq!(i16::pcm(-1.), i16::MIN);
        assert_eq!(i16::pcm(1.), i16::MAX);
        assert_eq!(i16::pcm(0.25), 8192);
        assert_eq!(u16::pcm(0.), 32768);
        assert_eq!(u8::pcm(-1.), 0);
        assert_eq!(u32::pcm(1.), u32::MAX);
        assert_eq!(cpal::I24::pcm(-1.).inner(), -8_388_608);
        assert_eq!(cpal::I24::pcm(1.).inner(), 8_388_607);
        assert_eq!(cpal::U24::pcm(0.).inner(), 8_388_608);
        for value in [f64::NAN, f64::NEG_INFINITY, f64::INFINITY, -1e30, 1e30] {
            let _ = (cpal::I24::pcm(value), cpal::U24::pcm(value));
        }
        let (mut producer, mut callback) = callback(1, 8);
        producer
            .push_entire_slice(&[-1., -0.5, 0., 0.5, 1.])
            .unwrap();
        let mut output = [0u16; 6];
        no_heap(|| callback.render(&mut output));
        assert_eq!(output, [0, 16384, 32768, 49152, 65535, 32768]);
    }
    #[test]
    fn exceptional_owned_error_retirement_is_bounded_and_never_leaks_on_overflow() {
        let (mut producer, mut consumer) = RingBuffer::new(1);
        let fault = AtomicU32::new(0);
        let first = cpal::Error::with_message(cpal::ErrorKind::Xrun, "transient".repeat(20));
        no_heap(|| retire_error(&mut producer, &fault, first));
        assert_eq!(fault.load(Ordering::Acquire), 0);
        let second =
            cpal::Error::with_message(cpal::ErrorKind::DeviceNotAvailable, "lost".repeat(20));
        let allocation =
            allocation_counter::measure(|| retire_error(&mut producer, &fault, second));
        assert_eq!(allocation.count_total, 0);
        assert_eq!(
            allocation.count_current, -1,
            "full ring must reclaim owned Error"
        );
        assert_eq!(fault.load(Ordering::Acquire), 1);
        assert_eq!(consumer.pop().unwrap().kind(), cpal::ErrorKind::Xrun);
        assert!(consumer.pop().is_err());
    }
}
