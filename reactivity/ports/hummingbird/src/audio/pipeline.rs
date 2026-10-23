//! Fixed-size FFT staging and exact final-tail accounting, adapted from pinned
//! Hummingbird devices/resample.rs. The callback never owns these buffers.
use super::{AudioError, Format, Token, block::AudioBlock, fft::FftUnit, timing::SubmissionTiming};

// Choose one exact FFT unit per processing call. The decoder already owns the
// 20 ms packet staging; a second fixed-packet FIFO inside Rubato is unnecessary.
// Both reduced rates and their common multiplier must be 7-smooth, so ordinary
// rates never acquire a prime-sized FFT just because a packet rounds to 221.
// Common rate pairs through 768 kHz include a reduced 147:10240 ratio.
const MAX_FFT_UNIT: usize = 16384;
fn smooth_fft_unit(mut frames: usize) -> bool {
    for factor in [2, 3, 5, 7] {
        while frames.is_multiple_of(factor) && frames > 1 {
            frames /= factor;
        }
    }
    frames == 1
}
pub(super) fn fft_geometry(source: u32, target: u32) -> Result<(usize, usize), AudioError> {
    let limit = || AudioError::Unsupported("FFT rate-pair resource limit");
    if source == 0 || target == 0 {
        return Err(limit());
    }
    let (mut gcd, mut divisor) = (source, target);
    while divisor != 0 {
        (gcd, divisor) = (divisor, gcd % divisor);
    }
    let chunk = (source as usize).div_ceil(50);
    let sub_chunks = (chunk / 256).max(1);
    let minimum_input = (source / gcd) as usize;
    let minimum_output = (target / gcd) as usize;
    if !smooth_fft_unit(minimum_input) || !smooth_fft_unit(minimum_output) {
        return Err(limit());
    }
    let first = (chunk / sub_chunks).div_ceil(minimum_input).max(1);
    // For either rate, units * (rate / gcd) / rate == units / gcd.
    // This bounds both duration (100 ms) and frame count before planning.
    let last = (MAX_FFT_UNIT / minimum_input.max(minimum_output)).min(gcd as usize / 10);
    if last == 0 {
        return Err(limit());
    }
    // Keep already-admitted filter units unchanged. Packet-rounding primes
    // need only a binary multiplier; no planner search or extra FFT stage.
    let units = if first <= last && smooth_fft_unit(first) {
        first
    } else {
        first.next_power_of_two().min(1 << last.ilog2())
    };
    Ok((units * minimum_input, units * minimum_output))
}

pub(super) struct Pipeline {
    pub device: Format,
    source_rate: u32,
    fft: Option<FftUnit>,
    input: Vec<Vec<f64>>,
    input_frames: usize,
    chunk: usize,
    pub pending: Vec<f64>,
    pub offset: usize,
    frames_in: u64,
    frames_out: u64,
    delay: usize,
    finished: bool,
    timing: SubmissionTiming,
    next_mark: Option<Token>,
    tail_announced: bool,
}
impl Pipeline {
    pub fn new(
        source: Format,
        device: Format,
        token: Token,
        position_ms: u64,
    ) -> Result<Self, AudioError> {
        source.checked()?;
        device.checked()?;
        let fft = if source.rate == device.rate {
            None
        } else {
            let (input, output) = fft_geometry(source.rate, device.rate)?;
            Some(FftUnit::new(input, output, device.channels as usize))
        };
        let chunk = fft
            .as_ref()
            .map_or((source.rate as usize).div_ceil(50), |fft| {
                fft.input_frames()
            });
        let maximum = fft.as_ref().map_or(chunk, FftUnit::output_frames);
        let delay = fft.as_ref().map_or(0, |fft| fft.output_frames() / 2);
        // The only source staging is one exact input unit. Delay and a partial
        // unit can retain boundaries until their PCM is accepted.
        let history = 4 * chunk;
        let mut timing = SubmissionTiming::new(history + 4);
        timing
            .delay(delay, position_ms as f64, Some(token))
            .map_err(|error| AudioError::Decode(error.into()))?;
        let input = if fft.is_some() {
            (0..device.channels).map(|_| vec![0.0; 2 * chunk]).collect()
        } else {
            Vec::new()
        };
        let pending = vec![0.0; maximum * device.channels as usize];
        let offset = pending.len();
        Ok(Self {
            device,
            source_rate: source.rate,
            fft,
            input,
            input_frames: 0,
            chunk,
            pending,
            offset,
            frames_in: 0,
            frames_out: 0,
            delay,
            finished: false,
            timing,
            next_mark: (delay == 0).then_some(token),
            tail_announced: false,
        })
    }
    pub fn empty(&self) -> bool {
        self.offset == self.pending.len()
    }
    pub fn compatible(&self, format: Format) -> bool {
        self.source_rate == format.rate
    }
    pub fn next_source(&mut self, token: Token) {
        self.next_mark = Some(token);
    }
    pub fn feed(&mut self, block: &AudioBlock, offset: &mut usize) -> Result<(), AudioError> {
        debug_assert!(self.empty());
        let frames = (block.frames - *offset).min(self.chunk - self.input_frames);
        if self.fft.is_none() {
            let channels = self.device.channels as usize;
            self.pending.resize(frames * channels, 0.0);
            for frame in 0..frames {
                let source_frame = *offset + frame;
                for channel in 0..channels {
                    self.pending[frame * channels + channel] =
                        match (block.format.channels, channels) {
                            (2, 1) => {
                                (block.planes[0][source_frame] + block.planes[1][source_frame])
                                    * 0.5
                            }
                            (1, _) => block.planes[0][source_frame],
                            _ => block.planes[channel][source_frame],
                        };
                }
            }
        } else {
            for output_channel in 0..self.device.channels as usize {
                let target =
                    &mut self.input[output_channel][self.input_frames..self.input_frames + frames];
                match (block.format.channels, self.device.channels) {
                    (2, 1) => {
                        for (frame, target) in target.iter_mut().enumerate() {
                            *target = (block.planes[0][*offset + frame]
                                + block.planes[1][*offset + frame])
                                * 0.5;
                        }
                    }
                    (1, _) => target.copy_from_slice(&block.planes[0][*offset..*offset + frames]),
                    _ => target
                        .copy_from_slice(&block.planes[output_channel][*offset..*offset + frames]),
                }
            }
        }
        // Keep initialized pending storage between FFT units. Mark old PCM as
        // consumed while accumulating input; the next process overwrites it.
        self.offset = self.pending.len();
        self.timing
            .input(
                frames,
                self.source_rate,
                self.device.rate,
                Some(
                    block.position_ms as f64
                        + *offset as f64 * 1000. / f64::from(block.format.rate),
                ),
                false,
                self.next_mark.take(),
            )
            .map_err(|error| AudioError::Decode(error.into()))?;
        self.input_frames += frames;
        self.frames_in += frames as u64;
        *offset += frames;
        if self.input_frames == self.chunk || self.fft.is_none() {
            self.process(false)?;
        }
        Ok(())
    }
    fn process(&mut self, finishing: bool) -> Result<(), AudioError> {
        let channels = self.device.channels as usize;
        let written = if let Some(fft) = &mut self.fft {
            fft.process(&mut self.input, self.input_frames, &mut self.pending);
            fft.output_frames()
        } else {
            self.input_frames
        };
        let expected = (self.frames_in as f64 * f64::from(self.device.rate)
            / f64::from(self.source_rate))
        .ceil() as u64
            + self.delay as u64;
        let keep = if finishing {
            written.min(expected.saturating_sub(self.frames_out) as usize)
        } else {
            written
        };
        self.pending.truncate(keep * channels);
        if self.pending.iter().any(|sample| !sample.is_finite()) {
            return Err(AudioError::Decode("non-finite DSP output".into()));
        }
        self.offset = 0;
        self.frames_out += keep as u64;
        self.input_frames = 0;
        Ok(())
    }
    /// Produces at most one bounded chunk per poll, including a very short tail.
    pub fn finish(&mut self) -> Result<bool, AudioError> {
        if !self.empty() {
            return Ok(false);
        }
        if self.finished {
            return Ok(true);
        }
        if !self.tail_announced {
            self.timing
                .finish_resampler()
                .map_err(|error| AudioError::Decode(error.into()))?;
            self.tail_announced = true;
        }
        let expected = (self.frames_in as f64 * f64::from(self.device.rate)
            / f64::from(self.source_rate))
        .ceil() as u64
            + self.delay as u64;
        if self.fft.is_none() || self.frames_in == 0 || self.frames_out >= expected {
            self.finished = true;
            return Ok(true);
        }
        self.process(true)?;
        if self.pending.is_empty() {
            return Err(AudioError::Decode("resampler made no tail progress".into()));
        }
        Ok(false)
    }
    pub fn accepted(&mut self, frames: usize) {
        self.offset += frames * self.device.channels as usize;
        self.timing.accept(frames);
    }
    pub fn take_started(&mut self) -> Option<Token> {
        self.timing.take_started()
    }
    pub fn position_for(&self, token: Token) -> Option<u64> {
        self.timing.position_for(token)
    }
    #[cfg(test)]
    pub fn print_capacity_bill(&self, label: &str) {
        println!(
            "AUDIO_PIPELINE {label} source_rate={} device={:?} chunk={} delay={} input_caps={:?} pending_cap={} timing_header={} spans_actual_bound={:?}",
            self.source_rate,
            self.device,
            self.chunk,
            self.delay,
            self.input.iter().map(Vec::capacity).collect::<Vec<_>>(),
            self.pending.capacity(),
            std::mem::size_of::<SubmissionTiming>(),
            self.timing.capacities()
        );
    }
}

#[cfg(test)]
mod resource_tests {
    use super::*;
    use rubato::{Fft, FixedSync, Resampler};

    const ORDINARY_RATES: [u32; 17] = [
        8000, 11025, 12000, 16000, 22050, 24000, 32000, 44100, 48000, 64000, 88200, 96000, 176400,
        192000, 352800, 384000, 768000,
    ];

    fn token() -> Token {
        use crate::{
            queue::{Track, TrackRef},
            queue_playback::PlaybackQueue,
        };
        let mut queue = PlaybackQueue::new().unwrap();
        queue
            .append(
                vec![TrackRef::new(Track {
                    path: "unused".into(),
                    title: "resources".into(),
                    track_id: None,
                    album_id: None,
                    available_when_prepared: true,
                })],
                &|_| true,
                &mut |_| 0,
            )
            .unwrap();
        Token {
            stamp: queue.plan().unwrap().stamp(),
            revision: 1,
        }
    }

    // Exactly the prior Pipeline's heap owners. Scalar fields live inline and
    // add no allocations. This is constructor evidence, not an output oracle.
    fn prior_owners(
        source: Format,
        device: Format,
        token: Token,
    ) -> (
        Option<Fft<f64>>,
        Vec<Vec<f64>>,
        Vec<Vec<f64>>,
        Vec<f64>,
        SubmissionTiming,
    ) {
        let chunk = (source.rate as usize).div_ceil(50);
        let fft = (source.rate != device.rate).then(|| {
            Fft::<f64>::new(
                source.rate as usize,
                device.rate as usize,
                chunk,
                device.channels as usize,
                FixedSync::Input,
            )
            .unwrap()
        });
        let maximum = fft.as_ref().map_or(chunk, |fft| fft.output_frames_max());
        let mut timing = SubmissionTiming::new(chunk + 4);
        timing
            .delay(
                fft.as_ref().map_or(0, |fft| fft.output_delay()),
                0.0,
                Some(token),
            )
            .unwrap();
        (
            fft,
            (0..device.channels)
                .map(|_| Vec::with_capacity(chunk))
                .collect(),
            (0..device.channels).map(|_| vec![0.0; maximum]).collect(),
            Vec::with_capacity(maximum * device.channels as usize),
            timing,
        )
    }

    #[test]
    fn whole_pipeline_construction_and_retirement_are_monotonic_against_prior_owners() {
        let token = token();
        let mut cases = 0;
        let rates = ORDINARY_RATES
            .into_iter()
            .flat_map(|source| {
                ORDINARY_RATES
                    .into_iter()
                    .map(move |target| (source, target))
            })
            .chain([(81920, 78750), (78750, 81920)]);
        for (source, target) in rates {
            for channels in 1..=2 {
                let source = Format {
                    rate: source,
                    channels,
                };
                let target = Format {
                    rate: target,
                    channels,
                };
                let mut prior = None;
                let baseline = allocation_counter::measure(|| {
                    prior = Some(prior_owners(source, target, token));
                });
                let retirement = allocation_counter::measure(|| drop(prior.take()));
                assert_eq!(baseline.count_current + retirement.count_current, 0);
                assert_eq!(baseline.bytes_current + retirement.bytes_current, 0);
                let mut pipeline = None;
                let actual = allocation_counter::measure(|| {
                    pipeline = Some(Pipeline::new(source, target, token, 0).unwrap());
                });
                println!(
                    "AUDIO_PIPELINE_MONOTONIC {source:?}->{target:?} prior={baseline:?} actual={actual:?}"
                );
                assert!(
                    actual.bytes_current <= baseline.bytes_current,
                    "retained {source:?}->{target:?}: {actual:?} > {baseline:?}"
                );
                assert!(
                    actual.bytes_max <= baseline.bytes_max,
                    "peak {source:?}->{target:?}: {actual:?} > {baseline:?}"
                );
                let retirement = allocation_counter::measure(|| drop(pipeline.take()));
                assert_eq!(actual.count_current + retirement.count_current, 0);
                assert_eq!(actual.bytes_current + retirement.bytes_current, 0);
                cases += 1;
            }
        }
        assert_eq!(cases, 582);
    }

    #[test]
    fn one_frame_source_boundaries_stay_inside_the_whole_pipeline_lifetime_envelope() {
        let first = token();
        for (source, target) in [
            (8000, 48000),
            (44100, 48000),
            (768000, 44100),
            (81920, 78750),
        ] {
            let source = Format {
                rate: source,
                channels: 2,
            };
            let device = Format {
                rate: target,
                channels: 2,
            };
            let mut block = AudioBlock::new(source).unwrap();
            block.frames = 1;
            for plane in &mut block.planes {
                plane.push(0.25);
            }
            let mut live = None;
            let constructor = allocation_counter::measure(|| {
                live = Some(Pipeline::new(source, device, first, 0).unwrap());
            });
            let pipeline = live.as_mut().unwrap();
            let (initial_capacity, boundary_limit) = pipeline.timing.capacities();
            let maximum_capacity = boundary_limit.next_power_of_two();
            let span_bytes = SubmissionTiming::span_bytes();
            let processing = allocation_counter::measure(|| {
                for revision in 2..(5 * pipeline.chunk + 19) as u64 {
                    pipeline.next_source(Token { revision, ..first });
                    pipeline.feed(&block, &mut 0).unwrap();
                    pipeline.accepted((pipeline.pending.len() - pipeline.offset) / 2);
                    let _ = pipeline.take_started();
                }
                while !pipeline.finish().unwrap() {
                    pipeline.accepted((pipeline.pending.len() - pipeline.offset) / 2);
                    let _ = pipeline.take_started();
                }
            });
            let (final_capacity, _) = pipeline.timing.capacities();
            assert!(final_capacity <= maximum_capacity);
            assert_eq!(
                processing.bytes_current,
                ((final_capacity - initial_capacity) * span_bytes) as i64
            );
            // A VecDeque growth can briefly own its old and new allocation.
            let transient =
                (maximum_capacity + maximum_capacity / 2 - initial_capacity) * span_bytes;
            assert!(processing.bytes_max <= transient as u64);
            println!(
                "AUDIO_BOUNDARY_ENVELOPE {source:?}->{device:?} constructor={constructor:?} processing={processing:?} spans_initial={initial_capacity} spans_final={final_capacity} spans_limit={boundary_limit} span_bytes={span_bytes}"
            );
            let retirement = allocation_counter::measure(|| drop(live.take()));
            assert_eq!(
                constructor.count_current + processing.count_current + retirement.count_current,
                0
            );
            assert_eq!(
                constructor.bytes_current + processing.bytes_current + retirement.bytes_current,
                0
            );
        }
    }

    #[test]
    fn complete_pipeline_matches_rubato_across_packet_splits_join_and_partial_acceptance() {
        for (source_rate, target_rate) in [
            (8000, 48000),
            (11025, 44100),
            (44100, 48000),
            (768000, 44100),
            (81920, 78750),
        ] {
            let (input_unit, _) = fft_geometry(source_rate, target_rate).unwrap();
            assert_pipeline_matches_rubato(source_rate, target_rate, 2 * input_unit + 17);
        }
    }

    #[test]
    fn large_legacy_fft_unit_finishes_the_tail_beyond_a_decoder_packet() {
        // The untouched FixedInput baseline fails at this exact source length:
        // its first zero-padded 1639-frame packet emits no 8192-frame FFT unit.
        // Exact-unit processing must retain the filter history and flush all
        // 3937 delayed frames, not treat that empty packet as a final tail.
        assert_eq!(fft_geometry(81920, 78750).unwrap(), (8192, 7875));
        let packet = 81920usize.div_ceil(50);
        assert!(8192 > 2 * packet);
        assert_pipeline_matches_rubato(81920, 78750, 25 * packet - 1);
    }

    fn assert_pipeline_matches_rubato(source_rate: u32, target_rate: u32, frames: usize) {
        use audioadapter_buffers::direct::SequentialSliceOfVecs;
        let first = token();
        let (input_unit, output_unit) = fft_geometry(source_rate, target_rate).unwrap();
        let join = input_unit + 3;
        for (source_channels, target_channels) in [(1, 1), (1, 2), (2, 1), (2, 2)] {
            let source = Format {
                rate: source_rate,
                channels: source_channels,
            };
            let device = Format {
                rate: target_rate,
                channels: target_channels,
            };
            let samples: Vec<Vec<_>> = (0..source_channels)
                .map(|channel| {
                    (0..frames)
                        .map(|frame| {
                            ((frame * (usize::from(channel) + 3) * 31 % 257) as f64 - 128.0) / 256.0
                        })
                        .collect()
                })
                .collect();
            let mapped: Vec<Vec<_>> = (0..target_channels)
                .map(|channel| {
                    (0..frames)
                        .map(|frame| match (source_channels, target_channels) {
                            (2, 1) => (samples[0][frame] + samples[1][frame]) * 0.5,
                            (1, _) => samples[0][frame],
                            _ => samples[usize::from(channel)][frame],
                        })
                        .collect()
                })
                .collect();
            let channels = target_channels as usize;
            // Integer arithmetic provides an independent final-frame count.
            let expected_frames = (frames as u64 * u64::from(target_rate))
                .div_ceil(u64::from(source_rate)) as usize
                + output_unit / 2;
            let mut reference = Fft::<f64>::new(
                source_rate as usize,
                target_rate as usize,
                input_unit,
                channels,
                FixedSync::Both,
            )
            .unwrap();
            let mut expected = Vec::new();
            let mut reference_output = vec![vec![0.0; output_unit]; channels];
            let mut cursor = 0;
            while expected.len() < expected_frames * channels {
                let length = (frames - cursor).min(input_unit);
                let input: Vec<Vec<_>> = mapped
                    .iter()
                    .map(|plane| plane[cursor..cursor + length].to_vec())
                    .collect();
                let input = SequentialSliceOfVecs::new(&input, channels, length).unwrap();
                let mut output =
                    SequentialSliceOfVecs::new_mut(&mut reference_output, channels, output_unit)
                        .unwrap();
                let indexing = rubato::Indexing {
                    input_offset: 0,
                    output_offset: 0,
                    active_channels_mask: None,
                    partial_len: Some(length),
                };
                reference
                    .process_into_buffer(&input, &mut output, Some(&indexing))
                    .unwrap();
                for frame in 0..output_unit {
                    for plane in &reference_output {
                        expected.push(plane[frame]);
                    }
                }
                cursor += length;
            }
            expected.truncate(expected_frames * channels);
            let mut actual = Vec::new();
            let mut pipeline = Pipeline::new(source, device, first, 0).unwrap();
            let mut block = AudioBlock::new(source).unwrap();
            let mut cursor = 0;
            while cursor < frames {
                if cursor == join {
                    pipeline.next_source(Token {
                        revision: 2,
                        ..first
                    });
                }
                let mut length = (frames - cursor).min(block.capacity());
                if cursor < join {
                    length = length.min(join - cursor);
                }
                block.clear();
                block.frames = length;
                block.position_ms =
                    ((cursor.saturating_sub(if cursor >= join { join } else { 0 })) as u64 * 1000)
                        / u64::from(source_rate);
                for (plane, samples) in block.planes.iter_mut().zip(&samples) {
                    plane.extend_from_slice(&samples[cursor..cursor + length]);
                }
                let mut offset = 0;
                while offset < length {
                    pipeline.feed(&block, &mut offset).unwrap();
                    while !pipeline.empty() {
                        assert!(!pipeline.finish().unwrap(), "backpressure must retain PCM");
                        let count = ((pipeline.pending.len() - pipeline.offset) / channels).min(31);
                        actual.extend_from_slice(
                            &pipeline.pending[pipeline.offset..pipeline.offset + count * channels],
                        );
                        pipeline.accepted(count);
                    }
                }
                cursor += length;
            }
            while !pipeline.finish().unwrap() {
                actual.extend_from_slice(&pipeline.pending[pipeline.offset..]);
                pipeline.accepted((pipeline.pending.len() - pipeline.offset) / channels);
            }
            assert_eq!(actual, expected, "{source:?}->{device:?}");
            assert_eq!(
                pipeline.take_started(),
                Some(Token {
                    revision: 2,
                    ..first
                })
            );
        }
    }
    #[test]
    fn coprime_rate_pairs_are_rejected_without_allocating_fft_plans() {
        for (source, target) in [(44101, 48000), (767999, 768000)] {
            let allocation = allocation_counter::measure(|| {
                assert_eq!(
                    fft_geometry(source, target),
                    Err(AudioError::Unsupported("FFT rate-pair resource limit"))
                );
            });
            assert_eq!(allocation.count_total, 0);
            assert_eq!(allocation.count_current, 0);
        }
    }
    #[test]
    fn admitted_geometry_is_one_exact_bounded_rubato_unit() {
        for (source, target) in [
            (8000, 48000),
            (44100, 48000),
            (192000, 44100),
            (768000, 44100),
            (81920, 78750),
            (11025, 44100),
        ] {
            let expected = fft_geometry(source, target).unwrap();
            let mut fft = None;
            let allocations = allocation_counter::measure(|| {
                fft = Some(
                    Fft::<f64>::new(
                        source as usize,
                        target as usize,
                        expected.0,
                        2,
                        FixedSync::Both,
                    )
                    .unwrap(),
                );
            });
            let fft = fft.as_ref().unwrap();
            assert_eq!((fft.fft_size_in(), fft.fft_size_out()), expected);
            assert_eq!(fft.input_frames_max(), expected.0);
            assert_eq!(fft.output_frames_max(), expected.1);
            assert!(expected.0 <= MAX_FFT_UNIT && expected.1 <= MAX_FFT_UNIT);
            println!(
                "AUDIO_FFT_ADMISSION {source}->{target} fft_units={expected:?} input_max={} output_max={} delay={} {allocations:?}",
                fft.input_frames_max(),
                fft.output_frames_max(),
                fft.output_delay()
            );
        }
    }

    #[test]
    fn ordinary_rate_pairs_do_not_inherit_prime_factors_from_packet_rounding() {
        let allocations = allocation_counter::measure(|| {
            for source in ORDINARY_RATES {
                for target in ORDINARY_RATES {
                    let (input, output) = fft_geometry(source, target)
                        .unwrap_or_else(|error| panic!("{source}->{target}: {error}"));
                    assert_eq!(input as u64 * target as u64, output as u64 * source as u64);
                    assert!(input <= MAX_FFT_UNIT && output <= MAX_FFT_UNIT);
                    assert!(input * 10 <= source as usize && output * 10 <= target as usize);
                    assert!(smooth_fft_unit(input) && smooth_fft_unit(output));
                }
            }
        });
        assert_eq!(allocations.count_total, 0);
        assert_eq!(fft_geometry(11025, 44100).unwrap(), (256, 1024));
    }
}

#[cfg(test)]
mod smooth_plan_bill {
    use super::*;
    use rubato::{Fft, FixedSync};
    #[test]
    fn every_admitted_smooth_unit_has_bounded_actual_constructor_ownership() {
        let mut cases = 0;
        let mut maximum = (0, 0, 0u64, 0i64);
        for unit in 1..=MAX_FFT_UNIT {
            if !smooth_fft_unit(unit) {
                continue;
            }
            for (input, output) in [(unit, 1), (1, unit)] {
                let mut live = None;
                let allocations = allocation_counter::measure(|| {
                    live = Some(
                        Fft::<f64>::new_custom(
                            input,
                            output,
                            input,
                            1,
                            2,
                            rubato::WindowFunction::BlackmanHarris2,
                            FixedSync::Both,
                        )
                        .unwrap(),
                    )
                });
                let fft = live.as_ref().unwrap();
                assert_eq!((fft.fft_size_in(), fft.fft_size_out()), (input, output));
                let retirement = allocation_counter::measure(|| drop(live.take()));
                assert_eq!(allocations.count_current + retirement.count_current, 0);
                assert_eq!(allocations.bytes_current + retirement.bytes_current, 0);
                let mut actual = None;
                let direct = allocation_counter::measure(|| {
                    actual = Some(FftUnit::new(input, output, 2));
                });
                assert!(
                    direct.bytes_max <= allocations.bytes_max,
                    "{input}->{output}: {direct:?} > {allocations:?}"
                );
                assert!(direct.bytes_current <= allocations.bytes_current);
                if direct.bytes_max > maximum.2 {
                    maximum = (input, output, direct.bytes_max, direct.bytes_current);
                }
                println!(
                    "AUDIO_SMOOTH_PLAN {input}->{output} prior={allocations:?} direct={direct:?}"
                );
                let retirement = allocation_counter::measure(|| drop(actual.take()));
                assert_eq!(direct.count_current + retirement.count_current, 0);
                assert_eq!(direct.bytes_current + retirement.bytes_current, 0);
                cases += 1;
            }
        }
        assert_eq!(cases, 800);
        println!(
            "AUDIO_SMOOTH_PLAN_MAX cases={cases} input={} output={} peak={} retained={}",
            maximum.0, maximum.1, maximum.2, maximum.3
        );
    }
}
