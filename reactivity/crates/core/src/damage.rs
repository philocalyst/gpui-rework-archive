use crate::{MappedBounds, Rect, TreeError};

const TILE: u32 = 64;
const MAX_TILES: usize = 1 << 20;

/// Conservative 64px tile damage, bounded by the viewport, not mutation count.
/// Repeated invalidation sets the same bit. No per-mutation rectangles are retained.
pub struct Damage {
    width: u32,
    height: u32,
    columns: u32,
    rows: u32,
    words: Vec<u64>,
    touched: Vec<usize>,
    count: usize,
}
impl Damage {
    pub fn new(width: u32, height: u32) -> Result<Self, TreeError> {
        let columns = width.div_ceil(TILE);
        let rows = height.div_ceil(TILE);
        let tiles = (columns as usize)
            .checked_mul(rows as usize)
            .ok_or(TreeError::Capacity)?;
        if tiles > MAX_TILES {
            return Err(TreeError::Capacity);
        }
        let words = vec![0; tiles.div_ceil(64)];
        Ok(Self {
            width,
            height,
            columns,
            rows,
            touched: Vec::new(),
            words,
            count: 0,
        })
    }
    pub fn is_empty(&self) -> bool {
        self.count == 0
    }
    pub fn tile_count(&self) -> usize {
        self.count
    }
    pub fn add(&mut self, rect: Rect) {
        if !rect.is_valid() {
            self.full();
            return;
        }
        let rect = rect.intersection(Rect::new(0.0, 0.0, self.width as f32, self.height as f32));
        if rect.is_empty() {
            return;
        }
        let x0 = (rect.x / TILE as f32).floor() as u32;
        let y0 = (rect.y / TILE as f32).floor() as u32;
        let x1 = ((rect.x + rect.width) / TILE as f32).ceil() as u32;
        let y1 = ((rect.y + rect.height) / TILE as f32).ceil() as u32;
        for y in y0..y1.min(self.rows) {
            for x in x0..x1.min(self.columns) {
                self.set((y * self.columns + x) as usize);
            }
        }
    }
    pub fn add_mapped(&mut self, bounds: MappedBounds) {
        match bounds {
            MappedBounds::Empty => {}
            MappedBounds::Finite(rect) => self.add(rect),
            MappedBounds::Unbounded => self.full(),
        }
    }
    pub fn full(&mut self) {
        for tile in 0..self.columns as usize * self.rows as usize {
            self.set(tile);
        }
    }
    fn set(&mut self, tile: usize) {
        let word = tile / 64;
        let bit = 1u64 << (tile % 64);
        if self.words[word] & bit != 0 {
            return;
        }
        if self.words[word] == 0 {
            self.touched.push(word);
        }
        self.words[word] |= bit;
        self.count += 1;
    }
    /// Sparse work: only words touched since the previous clear are visited.
    pub fn clear(&mut self) {
        for word in self.touched.drain(..) {
            self.words[word] = 0;
        }
        self.count = 0;
    }
    /// Tile rectangles; order is unspecified. Edge tiles are cropped to viewport.
    pub fn tiles(&self) -> impl Iterator<Item = Rect> + '_ {
        self.touched.iter().flat_map(move |&index| {
            let bits = self.words[index];
            (0..64).filter_map(move |bit| {
                if bits & (1 << bit) == 0 {
                    return None;
                }
                let tile = index * 64 + bit;
                let x = (tile as u32 % self.columns) * TILE;
                let y = (tile as u32 / self.columns) * TILE;
                Some(Rect::new(
                    x as f32,
                    y as f32,
                    TILE.min(self.width - x) as f32,
                    TILE.min(self.height - y) as f32,
                ))
            })
        })
    }
    pub fn allocated_bytes(&self) -> usize {
        self.words.capacity() * std::mem::size_of::<u64>()
            + self.touched.capacity() * std::mem::size_of::<usize>()
    }
}
