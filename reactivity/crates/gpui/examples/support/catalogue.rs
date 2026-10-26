//! App-owned indexed catalogue. It has no dependency on the UI runtime.
//!
//! This deterministic backend exercises Hummingbird's sorted-ID/row-details
//! protocol. It does not decode audio, scan files, or claim to port the player.

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct TrackId(pub u64);

pub struct Catalogue {
    order: Vec<TrackId>,
    positions: Vec<usize>,
}

impl Catalogue {
    pub fn new(count: usize) -> Self {
        Self {
            order: (0..count).map(|id| TrackId(id as u64)).collect(),
            positions: (0..count).collect(),
        }
    }

    pub fn len(&self) -> usize {
        self.order.len()
    }

    pub fn id(&self, index: usize) -> TrackId {
        self.order[index]
    }

    pub fn index_of(&self, id: TrackId) -> Option<usize> {
        let slot = usize::try_from(id.0).ok()?;
        self.positions.get(slot).copied()
    }

    pub fn reverse(&mut self) {
        self.order.reverse();
        self.reindex();
    }

    pub fn prepend(&mut self) {
        let id = TrackId(self.positions.len() as u64);
        self.order.insert(0, id);
        self.positions.push(0);
        self.reindex();
    }

    fn reindex(&mut self) {
        for (index, id) in self.order.iter().enumerate() {
            self.positions[id.0 as usize] = index;
        }
    }

    pub fn title(&self, id: TrackId) -> String {
        format!("Track {:06} — Library recording", id.0)
    }

    #[allow(dead_code)] // Also used by the retained-list benchmark.
    pub fn storage_bytes(&self) -> usize {
        self.order.capacity() * std::mem::size_of::<TrackId>()
            + self.positions.capacity() * std::mem::size_of::<usize>()
    }
}
