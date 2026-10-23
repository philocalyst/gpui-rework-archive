//! Timed reusable planar blocks, adapted from pinned Hummingbird media/pipeline.rs.
use super::{AudioError, Format};

#[derive(Debug)]
pub(super) struct AudioBlock {
    pub planes: Vec<Vec<f64>>,
    pub format: Format,
    pub position_ms: u64,
    pub frames: usize,
}
impl AudioBlock {
    pub fn new(format: Format) -> Result<Self, AudioError> {
        format.checked()?;
        let capacity = (format.rate as usize).div_ceil(50);
        Ok(Self {
            planes: (0..format.channels)
                .map(|_| Vec::with_capacity(capacity))
                .collect(),
            format,
            position_ms: 0,
            frames: 0,
        })
    }
    pub fn clear(&mut self) {
        self.frames = 0;
        for plane in &mut self.planes {
            plane.clear();
        }
    }
    pub fn capacity(&self) -> usize {
        (self.format.rate as usize).div_ceil(50)
    }
}
