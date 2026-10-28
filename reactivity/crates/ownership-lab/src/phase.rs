use std::num::NonZeroUsize;

#[derive(Clone, Copy, Debug)]
pub struct LocalRect {
    pub x: i32,
    pub y: i32,
    pub width: u32,
    pub height: u32,
}
#[derive(Clone, Copy, Debug)]
pub struct Placement {
    pub x: i32,
    pub y: i32,
}
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct PlacedRect {
    pub x: i64,
    pub y: i64,
    pub width: u32,
    pub height: u32,
}

/// One exclusive output page per instance; geometry allocation happens at setup.
/// Damage is a fixed 8x8 bitset of 64px tiles over a 512x512 demonstration viewport.
#[derive(Debug)]
pub struct OutputPage {
    geometry: Box<[PlacedRect]>,
    damage: u64,
}
impl OutputPage {
    pub fn new(primitives: usize) -> Self {
        Self {
            geometry: vec![PlacedRect::default(); primitives].into_boxed_slice(),
            damage: 0,
        }
    }
    pub fn geometry(&self) -> &[PlacedRect] {
        &self.geometry
    }
    pub fn damage(&self) -> u64 {
        self.damage
    }
}
#[derive(Clone, Copy, Debug)]
pub enum Execution {
    Serial,
    Scoped { workers: NonZeroUsize },
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum PhaseError {
    Shape,
    Capacity,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct PhaseReport {
    pub jobs: usize,
    pub primitives: usize,
    pub damage: u64,
}

/// One immutable-input/exclusive-output phase. Shared template geometry is borrowed
/// once; no per-instance template clone or refcount. Scoped threads MUST join before
/// this borrow ends. A panic joins workers and propagates; outputs are then partial.
/// The caller must discard that unpublished candidate, not claim handler rollback.
pub struct BorrowedPhase<'a> {
    template: &'a [LocalRect],
    placements: &'a [Placement],
    outputs: &'a mut [OutputPage],
    primitives: usize,
}
impl<'a> BorrowedPhase<'a> {
    pub fn new(
        template: &'a [LocalRect],
        placements: &'a [Placement],
        outputs: &'a mut [OutputPage],
    ) -> Result<Self, PhaseError> {
        if placements.len() != outputs.len()
            || outputs.iter().any(|p| p.geometry.len() != template.len())
        {
            return Err(PhaseError::Shape);
        }
        let primitives = template
            .len()
            .checked_mul(placements.len())
            .ok_or(PhaseError::Capacity)?;
        Ok(Self {
            template,
            placements,
            outputs,
            primitives,
        })
    }
    /// Serial and scoped execution use exactly the same concrete page kernel.
    /// Scoped mode starts fresh OS threads per phase; there is no hidden pool.
    pub fn run(self, execution: Execution) -> PhaseReport {
        let jobs = match execution {
            Execution::Serial => {
                kernel(self.template, self.placements, self.outputs);
                usize::from(!self.outputs.is_empty())
            }
            Execution::Scoped { workers } if self.outputs.len() > 1 && workers.get() > 1 => {
                let chunk = self
                    .outputs
                    .len()
                    .div_ceil(workers.get().min(self.outputs.len()));
                let jobs = self.outputs.len().div_ceil(chunk);
                std::thread::scope(|scope| {
                    for (index, outputs) in self.outputs.chunks_mut(chunk).enumerate() {
                        let placements =
                            &self.placements[index * chunk..index * chunk + outputs.len()];
                        let template = self.template;
                        scope.spawn(move || kernel(template, placements, outputs));
                    }
                });
                jobs
            }
            _ => {
                kernel(self.template, self.placements, self.outputs);
                usize::from(!self.outputs.is_empty())
            }
        };
        let damage = self.outputs.iter().fold(0, |bits, page| bits | page.damage);
        PhaseReport {
            jobs,
            primitives: self.primitives,
            damage,
        }
    }
}
fn kernel(template: &[LocalRect], placements: &[Placement], outputs: &mut [OutputPage]) {
    for (placement, page) in placements.iter().zip(outputs) {
        let mut damage = 0;
        for (local, out) in template.iter().zip(page.geometry.iter_mut()) {
            let rect = PlacedRect {
                x: local.x as i64 + placement.x as i64,
                y: local.y as i64 + placement.y as i64,
                width: local.width,
                height: local.height,
            };
            // Source bounds imply every endpoint fits i64, even at i32/u32 extremes.
            let left = rect.x.max(0);
            let top = rect.y.max(0);
            let right = (rect.x + rect.width as i64).min(512);
            let bottom = (rect.y + rect.height as i64).min(512);
            if right > left && bottom > top {
                for y in top / 64..(bottom + 63) / 64 {
                    for x in left / 64..(right + 63) / 64 {
                        damage |= 1u64 << (y * 8 + x);
                    }
                }
            }
            *out = rect;
        }
        page.damage = damage;
    }
}
