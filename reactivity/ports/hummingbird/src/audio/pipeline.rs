//! Fixed-size FFT staging and exact final-tail accounting, adapted from pinned
//! Hummingbird devices/resample.rs. The callback never owns these buffers.
use super::{AudioError, Format, Token, block::AudioBlock, timing::SubmissionTiming};
use audioadapter_buffers::direct::SequentialSliceOfVecs;
use rubato::{Fft, FixedSync, Resampler};

pub(super) struct Pipeline {
    pub device: Format,
    source_rate: u32,
    fft: Option<Fft<f64>>,
    input: Vec<Vec<f64>>,
    input_frames: usize,
    chunk: usize,
    output: Vec<Vec<f64>>,
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
            Some(
                Fft::<f64>::new(
                    source.rate as usize,
                    device.rate as usize,
                    (source.rate as usize).div_ceil(50),
                    device.channels as usize,
                    FixedSync::Input,
                )
                .map_err(|error| AudioError::Decode(error.to_string()))?,
            )
        };
        let chunk = fft
            .as_ref()
            .map_or((source.rate as usize).div_ceil(50), |fft| {
                fft.input_frames_next()
            });
        let maximum = fft.as_ref().map_or(chunk, |fft| fft.output_frames_max());
        let delay = fft.as_ref().map_or(0, |fft| fft.output_delay());
        let mut timing = SubmissionTiming::new(chunk + 4);
        timing
            .delay(delay, position_ms as f64, Some(token))
            .map_err(|error| AudioError::Decode(error.into()))?;
        Ok(Self {
            device,
            source_rate: source.rate,
            fft,
            input: (0..device.channels)
                .map(|_| Vec::with_capacity(chunk))
                .collect(),
            input_frames: 0,
            chunk,
            output: (0..device.channels).map(|_| vec![0.; maximum]).collect(),
            pending: Vec::with_capacity(maximum * device.channels as usize),
            offset: 0,
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
        self.pending.clear();
        self.offset = 0;
        let frames = (block.frames - *offset).min(self.chunk - self.input_frames);
        for output_channel in 0..self.device.channels as usize {
            let target = &mut self.input[output_channel];
            match (block.format.channels, self.device.channels) {
                (2, 1) => {
                    target.extend((0..frames).map(|i| {
                        (block.planes[0][*offset + i] + block.planes[1][*offset + i]) * 0.5
                    }))
                }
                (1, _) => target.extend_from_slice(&block.planes[0][*offset..*offset + frames]),
                _ => target
                    .extend_from_slice(&block.planes[output_channel][*offset..*offset + frames]),
            }
        }
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
            self.process(None)?;
        }
        Ok(())
    }
    fn process(&mut self, partial: Option<usize>) -> Result<(), AudioError> {
        let written = if let Some(fft) = &mut self.fft {
            let input = SequentialSliceOfVecs::new(
                &self.input,
                self.device.channels as usize,
                self.input_frames,
            )
            .map_err(|error| AudioError::Decode(error.to_string()))?;
            let maximum = self.output[0].len();
            let mut output = SequentialSliceOfVecs::new_mut(
                &mut self.output,
                self.device.channels as usize,
                maximum,
            )
            .map_err(|error| AudioError::Decode(error.to_string()))?;
            let indexing = rubato::Indexing {
                input_offset: 0,
                output_offset: 0,
                active_channels_mask: None,
                partial_len: partial,
            };
            let (_, written) = fft
                .process_into_buffer(&input, &mut output, partial.map(|_| &indexing))
                .map_err(|error| AudioError::Decode(error.to_string()))?;
            written
        } else {
            for (output, input) in self.output.iter_mut().zip(&self.input) {
                output[..self.input_frames].copy_from_slice(input);
            }
            self.input_frames
        };
        let expected = (self.frames_in as f64 * f64::from(self.device.rate)
            / f64::from(self.source_rate))
        .ceil() as u64
            + self.delay as u64;
        let keep = if partial.is_some() {
            written.min(expected.saturating_sub(self.frames_out) as usize)
        } else {
            written
        };
        self.pending.clear();
        self.offset = 0;
        for frame in 0..keep {
            for channel in &self.output {
                self.pending.push(channel[frame]);
            }
        }
        self.frames_out += keep as u64;
        for plane in &mut self.input {
            plane.clear();
        }
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
        self.process(Some(self.input_frames))?;
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
}
