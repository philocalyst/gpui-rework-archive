//! The sink is the sole replaceable boundary; decoding and orchestration are real.
use super::{AudioError, Format};
use std::sync::{
    Arc,
    atomic::{AtomicBool, AtomicU64, Ordering},
};

#[derive(Clone)]
pub struct PlaybackGate(pub(super) Arc<Gate>);
pub(super) struct Gate {
    pub epoch: AtomicU64,
    pub playing: AtomicBool,
    pub closed: AtomicBool,
}
impl PlaybackGate {
    pub fn allows(&self, epoch: u64) -> bool {
        !self.0.closed.load(Ordering::Acquire)
            && self.0.playing.load(Ordering::Relaxed)
            && self.0.epoch.load(Ordering::Acquire) == epoch
    }
}
pub trait OutputStream {
    fn format(&self) -> Format;
    /// Whole frames accepted immediately. Zero consumes no input.
    fn submit(&mut self, interleaved: &[f64]) -> Result<usize, AudioError>;
    /// Application PCM queue only, excluding the backend/hardware queue.
    fn queued_frames(&self) -> usize;
    fn set_playing(&mut self, playing: bool) -> Result<(), AudioError>;
    fn poll(&mut self) -> Result<(), AudioError> {
        Ok(())
    }
}
pub trait OutputProvider: Send + 'static {
    type Stream: OutputStream;
    /// Called on the control owner. Returned stream need not be Send.
    fn open(
        &mut self,
        source: Format,
        gate: PlaybackGate,
        epoch: u64,
    ) -> Result<Self::Stream, AudioError>;
}
