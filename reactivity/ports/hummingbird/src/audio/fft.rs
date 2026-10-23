//! One exact f64 FFT unit, adapted from Rubato 5.0.1's FftResampler,
//! sinc::make_sincs and windows::calculate_cutoff (MIT, copyright 2020 Henrik
//! Enquist; full notice in licenses/rubato-MIT.txt). The filter and overlap-add
//! arithmetic are retained. Packet staging belongs to Pipeline, so this has no
//! fixed-side FIFO, channel mask or audioadapter boundary.
use realfft::{ComplexToReal, RealFftPlanner, RealToComplex, num_complex::Complex};
use std::sync::Arc;
use windowfunctions::{Symmetry, WindowFunction, window};

pub(super) struct FftUnit {
    forward: Arc<dyn RealToComplex<f64>>,
    inverse: Arc<dyn ComplexToReal<f64>>,
    filter: Vec<Complex<f64>>,
    spectrum: Vec<Complex<f64>>,
    scratch: Vec<Complex<f64>>,
    output: Vec<f64>,
    overlaps: Vec<Vec<f64>>,
}

#[cfg(test)]
mod tests {
    use super::*;
    use audioadapter_buffers::direct::SequentialSliceOfVecs;
    use rubato::{Fft, FixedSync, Resampler};

    #[test]
    fn borrowed_unit_matches_independent_pinned_rubato_across_channels_and_tails() {
        for (source, target) in [
            (8000, 48000),
            (11025, 44100),
            (44100, 11025),
            (44100, 48000),
            (48000, 44100),
            (192000, 44100),
            (768000, 44100),
            (81920, 78750),
            (44100, 768000),
        ] {
            let (input_frames, output_frames) =
                super::super::pipeline::fft_geometry(source, target).unwrap();
            for channels in 1..=2 {
                let mut reference = Fft::<f64>::new(
                    source as usize,
                    target as usize,
                    input_frames,
                    channels,
                    FixedSync::Both,
                )
                .unwrap();
                let mut actual = FftUnit::new(input_frames, output_frames, channels);
                let mut input: Vec<_> = (0..channels)
                    .map(|_| Vec::with_capacity(2 * input_frames))
                    .collect();
                let mut expected = vec![vec![0.0; output_frames]; channels];
                let mut pending = Vec::with_capacity(output_frames * channels);
                // Distinct impulse channels, nonperiodic signal, short partial
                // input and two zero units exercise independent filter history.
                for unit in 0..7 {
                    let length = match unit {
                        4 => input_frames.saturating_sub(1).min(17),
                        5.. => 0,
                        _ => input_frames,
                    };
                    for (channel, input) in input.iter_mut().enumerate() {
                        input.clear();
                        input.extend((0..length).map(|frame| match unit {
                            0 => f64::from(frame == channel),
                            _ => {
                                let index = unit * input_frames + frame;
                                ((index * (channel + 3) * 37 % 509) as f64 - 254.0) / 512.0
                            }
                        }));
                    }
                    let adapter = SequentialSliceOfVecs::new(&input, channels, length).unwrap();
                    let mut output =
                        SequentialSliceOfVecs::new_mut(&mut expected, channels, output_frames)
                            .unwrap();
                    let indexing = rubato::Indexing {
                        input_offset: 0,
                        output_offset: 0,
                        active_channels_mask: None,
                        partial_len: Some(length),
                    };
                    let (_, written) = reference
                        .process_into_buffer(&adapter, &mut output, Some(&indexing))
                        .unwrap();
                    assert_eq!(written, output_frames);
                    for plane in &mut input {
                        plane.resize(2 * input_frames, 0.0);
                    }
                    let allocations = allocation_counter::measure(|| {
                        actual.process(&mut input, length, &mut pending);
                    });
                    assert_eq!(allocations.count_total, 0, "{allocations:?}");
                    assert_eq!(allocations.count_current, 0, "{allocations:?}");
                    for frame in 0..output_frames {
                        for channel in 0..channels {
                            assert_eq!(
                                pending[frame * channels + channel],
                                expected[channel][frame],
                                "{source}->{target} channels={channels} unit={unit} frame={frame} channel={channel}"
                            );
                        }
                    }
                }
            }
        }
    }
}

impl FftUnit {
    pub fn new(input: usize, output: usize, channels: usize) -> Self {
        // Preserve Rubato's f32 cutoff calculation, including its rounding.
        let length = input.min(output) as f32;
        let cutoff = 1.0_f32
            / (13.745202940783823_f32 / length
                + 121.73532586374934_f32 / (length * length)
                + 5964.163279612051_f32 / (length * length * length)
                + 1.0);
        let cutoff = if input > output {
            cutoff * output as f32 / input as f32
        } else {
            cutoff
        };
        let mut filter_time = vec![0.0; 2 * input];
        let mut sum = 0.0;
        for (index, value) in
            window::<f64>(input, WindowFunction::BlackmanHarris, Symmetry::Periodic).enumerate()
        {
            let x = (index as f64 - (input / 2) as f64) * f64::from(cutoff);
            let sinc = if x == 0.0 {
                1.0
            } else {
                (x * std::f64::consts::PI).sin() / (x * std::f64::consts::PI)
            };
            let value = value * value * sinc;
            filter_time[index] = value;
            sum += value;
        }
        for value in &mut filter_time[..input] {
            *value = (*value / sum) / (2 * input) as f64;
        }
        let mut planner = RealFftPlanner::<f64>::new();
        let forward = planner.plan_fft_forward(2 * input);
        let inverse = planner.plan_fft_inverse(2 * output);
        // Plans retain their own implementation. Retire construction caches
        // before allocating persistent processing storage.
        drop(planner);
        let mut filter = forward.make_output_vec();
        let mut scratch =
            vec![Complex::default(); forward.get_scratch_len().max(inverse.get_scratch_len())];
        forward
            .process_with_scratch(&mut filter_time, &mut filter, &mut scratch)
            .expect("admitted filter FFT buffers");
        drop(filter_time);
        Self {
            forward,
            inverse,
            filter,
            spectrum: vec![Complex::default(); input.max(output) + 1],
            scratch,
            output: vec![0.0; 2 * output],
            overlaps: (0..channels).map(|_| vec![0.0; output]).collect(),
        }
    }

    pub fn input_frames(&self) -> usize {
        self.forward.len() / 2
    }

    pub fn output_frames(&self) -> usize {
        self.output.len() / 2
    }

    /// Borrow and transform Pipeline's padded input, then write interleaved PCM
    /// directly. All storage is reserved at construction; only FFT plans dispatch
    /// through RealFFT's implementation boundary.
    pub fn process(&mut self, input: &mut [Vec<f64>], frames: usize, pending: &mut Vec<f64>) {
        let input_frames = self.input_frames();
        let output_frames = self.output_frames();
        let channels = input.len();
        pending.resize(output_frames * channels, 0.0);
        for (channel, (input, overlap)) in input.iter_mut().zip(&mut self.overlaps).enumerate() {
            input[frames..].fill(0.0);
            self.forward
                .process_with_scratch(
                    input,
                    &mut self.spectrum[..input_frames + 1],
                    &mut self.scratch,
                )
                .expect("admitted input FFT buffers");
            let filtered = if input_frames < output_frames {
                input_frames + 1
            } else {
                output_frames
            };
            for (sample, filter) in self.spectrum[..filtered].iter_mut().zip(&self.filter) {
                *sample *= filter;
            }
            self.spectrum[filtered..output_frames + 1].fill(Complex::default());
            self.inverse
                .process_with_scratch(
                    &mut self.spectrum[..output_frames + 1],
                    &mut self.output,
                    &mut self.scratch,
                )
                .expect("admitted output FFT buffers");
            for frame in 0..output_frames {
                pending[frame * channels + channel] = self.output[frame] + overlap[frame];
            }
            overlap.copy_from_slice(&self.output[output_frames..]);
        }
    }
}
