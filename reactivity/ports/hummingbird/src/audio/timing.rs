//! Adapted from pinned Hummingbird playback/thread/submission_timing.rs.
use super::Token;
use std::collections::VecDeque;

struct Span {
    frames: usize,
    position_ms: f64,
    ms_per_frame: f64,
    starts_track: Option<Token>,
}

/// Maps accepted device frames back to source time. Decoding alone never advances position.
pub(super) struct SubmissionTiming {
    spans: VecDeque<Span>,
    capacity: usize,
    remainder: f64,
    pub position: Option<u64>,
    started: Option<Token>,
    position_track: Option<Token>,
    pending_start: Option<(Token, f64)>,
}

impl SubmissionTiming {
    pub fn new(capacity: usize) -> Self {
        Self {
            // Growth is on the control owner, bounded by input-frame
            // admission. Ordinary packet spans merge; do not reserve one per
            // possible one-frame source boundary before any such workload.
            spans: VecDeque::with_capacity(capacity.min(8)),
            capacity,
            remainder: 0.0,
            position: None,
            started: None,
            position_track: None,
            pending_start: None,
        }
    }

    pub fn position_for(&self, track: Token) -> Option<u64> {
        if self.position_track == Some(track) {
            self.position
        } else {
            None
        }
    }

    pub fn input(
        &mut self,
        frames: usize,
        source_rate: u32,
        target_rate: u32,
        position: Option<f64>,
        discontinuity: bool,
        starts_track: Option<Token>,
    ) -> Result<(), &'static str> {
        let count = frames as f64 * target_rate as f64 / source_rate as f64 + self.remainder;
        let frames = count.floor() as usize;
        self.remainder = count - frames as f64;
        let starts_track = starts_track.or(self.pending_start.take().map(|pending| pending.0));
        let step = 1000.0 / target_rate as f64;
        let position = position.unwrap_or_else(|| {
            self.spans
                .back()
                .map_or(self.position.unwrap_or(0) as f64, |s| {
                    s.position_ms + s.frames as f64 * s.ms_per_frame
                })
        });
        if frames == 0 {
            // A tiny downsampled source can contribute less than one output
            // frame. Carry its latest boundary to the next real output frame.
            self.pending_start = starts_track.map(|token| (token, position));
            return Ok(());
        }
        // block timestamps are whole milliseconds, so allow their rounding without adding a gap
        if !discontinuity
            && starts_track.is_none()
            && let Some(last) = self.spans.back_mut()
            && last.ms_per_frame == step
            && (last.position_ms + last.frames as f64 * step - position).abs() <= 1.01
        {
            last.frames += frames;
            return Ok(());
        }
        if self.spans.len() >= self.capacity {
            return Err("too many buffered audio time boundaries");
        }
        self.spans.push_back(Span {
            frames,
            position_ms: position,
            ms_per_frame: step,
            starts_track,
        });
        Ok(())
    }

    pub fn delay(
        &mut self,
        frames: usize,
        position: f64,
        starts_track: Option<Token>,
    ) -> Result<(), &'static str> {
        if frames > 0 {
            if self.spans.len() >= self.capacity {
                return Err("too many buffered audio time boundaries");
            }
            self.spans.push_back(Span {
                frames,
                position_ms: position,
                ms_per_frame: 0.0,
                starts_track,
            });
        }
        Ok(())
    }

    pub fn accept(&mut self, mut frames: usize) {
        while frames > 0 {
            let Some(span) = self.spans.front_mut() else {
                break;
            };
            if let Some(track) = span.starts_track.take() {
                self.position_track = Some(track);
                self.started = Some(track);
            }
            let accepted = frames.min(span.frames);
            span.position_ms += accepted as f64 * span.ms_per_frame;
            span.frames -= accepted;
            frames -= accepted;
            self.position = Some(span.position_ms.max(0.0) as u64);
            if span.frames == 0 {
                self.spans.pop_front();
            }
        }
    }

    pub fn finish_resampler(&mut self) -> Result<(), &'static str> {
        // a flushed resampler rounds the final fractional output frame up
        let frames = usize::from(self.remainder > 1e-8);
        self.remainder = 0.0;
        let position = self
            .spans
            .back()
            .map_or(self.position.unwrap_or(0) as f64, |span| {
                span.position_ms + span.frames as f64 * span.ms_per_frame
            });
        let (position, starts_track) = self
            .pending_start
            .take()
            .map_or((position, None), |(token, position)| {
                (position, Some(token))
            });
        self.delay(frames, position, starts_track)
    }

    pub fn take_started(&mut self) -> Option<Token> {
        self.started.take()
    }
    #[cfg(test)]
    pub fn capacities(&self) -> (usize, usize) {
        (self.spans.capacity(), self.capacity)
    }
    #[cfg(test)]
    pub fn span_bytes() -> usize {
        std::mem::size_of::<Span>()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        queue::{Track, TrackRef},
        queue_playback::PlaybackQueue,
    };
    fn tokens() -> (Token, Token) {
        let mut queue = PlaybackQueue::new().unwrap();
        queue
            .append(
                vec![TrackRef::new(Track {
                    path: "unused".into(),
                    title: "timing".into(),
                    track_id: None,
                    album_id: None,
                    available_when_prepared: true,
                })],
                &|_| true,
                &mut |_| 0,
            )
            .unwrap();
        let stamp = queue.plan().unwrap().stamp();
        (Token { stamp, revision: 1 }, Token { stamp, revision: 2 })
    }
    #[test]
    fn submission_waits_for_accept_and_latest_fractional_source_boundary_survives() {
        let (first, next) = tokens();
        let mut timing = SubmissionTiming::new(1000);
        assert_eq!(timing.spans.capacity(), 8);
        timing.delay(2, 1000., Some(first)).unwrap();
        timing
            .input(1, 192000, 44100, Some(0.), false, Some(next))
            .unwrap();
        assert_eq!(timing.position_for(first), None);
        assert_eq!(timing.take_started(), None);
        timing.finish_resampler().unwrap();
        timing.accept(2);
        assert_eq!(timing.take_started(), Some(first));
        assert_eq!(timing.position_for(first), Some(1000));
        assert_eq!(timing.position_for(next), None);
        timing.accept(1);
        assert_eq!(timing.take_started(), Some(next));
        assert_eq!(timing.position_for(first), None);
        assert_eq!(timing.position_for(next), Some(0));
        assert!(timing.spans.is_empty());
    }
    #[test]
    fn fractional_input_boundary_can_move_to_following_accepted_source() {
        let (first, next) = tokens();
        let mut timing = SubmissionTiming::new(10);
        timing.input(1, 8, 1, Some(0.), false, Some(first)).unwrap();
        timing.input(7, 8, 1, Some(0.), false, Some(next)).unwrap();
        timing.accept(1);
        assert_eq!(timing.take_started(), Some(next));
        assert_eq!(timing.position_for(first), None);
    }
}
