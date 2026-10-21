//! Cold, byte-exact RGBA8 checkpoints. Hot render/upload buffers stay decoded.
//!
//! Tiles are 16×16, with packed valid pixels at partial edges. One byte stream
//! owns the header, u32 offset directory and records; no per-tile allocation.
//! Independent checkpoints are parseable, immutable decode roots. A Delta may
//! borrow exactly one Independent, never another Delta. Copy records are
//! in-memory only and reuse a same-position tile after full byte comparison.
//!
//! The opaque format identity must describe the caller's channel/alpha/profile
//! contract. This crate converts no colors and preserves hidden RGB/alpha bits.
//! Release the original raw image to realize checkpoint storage savings. The
//! storage ledger includes a Delta's complete borrowed base and object headers;
//! allocator metadata/rounding and unrelated hot images are not included.
#![forbid(unsafe_code)]

use std::{fmt, mem::size_of};

pub const TILE_SIDE: usize = 16;
pub const MAX_TILE_BYTES: usize = TILE_SIDE * TILE_SIDE * 4;
const MAGIC: &[u8; 8] = b"GPUTILE1";
const HEADER: usize = 36;
const RAW: u8 = 0;
const SOLID: u8 = 1;
const PALETTE_RUNS: u8 = 2;
const COPY: u8 = 3;

/// Equality is an explicit caller contract, not a color-profile validator.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct FormatIdentity(pub [u8; 16]);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Surface {
    pub width: u32,
    pub height: u32,
    pub format: FormatIdentity,
}

/// Checked before allocation/decoding. Dimensions must be nonzero. The byte
/// stream and decoded image are additionally limited to u32::MAX bytes.
#[derive(Clone, Copy, Debug)]
pub struct Limits {
    pub max_pixels: usize,
    pub max_encoded_bytes: usize,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Error {
    Dimensions,
    SizeOverflow,
    LimitExceeded,
    PixelLength,
    Malformed,
    TileIndex,
    OutputLength,
    IdentityMismatch,
    Allocation,
}
impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "tile checkpoint: {self:?}")
    }
}
impl std::error::Error for Error {}

/// Requested allocation bytes, including the byte-stream header and directory.
/// A borrowed base is charged in full, even when another caller also retains it.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Storage {
    pub object_bytes: usize,
    pub stream_bytes: usize,
    pub directory_bytes: usize,
    pub record_bytes: usize,
    pub base_resident_bytes: usize,
    pub total_resident_bytes: usize,
    pub decoded_bytes: usize,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Modes {
    pub raw: usize,
    pub solid: usize,
    pub palette_runs: usize,
    pub copied: usize,
}

/// Self-contained immutable checkpoint; serialized bytes contain no references.
pub struct Independent {
    records: Records,
}

/// A direct immutable base borrow proves reference identity and keeps it alive.
/// No external copy-record parser is exposed: a hash/claimed ID cannot prove
/// the identity of caller-supplied base bytes.
pub struct Delta<'base> {
    records: Records,
    base: &'base Independent,
}

impl Independent {
    pub fn encode(surface: Surface, rgba: &[u8], limits: Limits) -> Result<Self, Error> {
        Ok(Self {
            records: encode(surface, rgba, limits, None)?,
        })
    }
    /// Validate the entire untrusted stream before creating a checkpoint. This
    /// borrows the provided allocation for validation and makes no allocation.
    pub fn parse(bytes: Box<[u8]>, limits: Limits) -> Result<Self, Error> {
        validate(&bytes, limits)?;
        Ok(Self {
            records: Records { bytes },
        })
    }
    pub fn as_bytes(&self) -> &[u8] {
        &self.records.bytes
    }
    pub fn surface(&self) -> Surface {
        self.records.surface()
    }
    pub fn tile_count(&self) -> usize {
        self.records.tile_count()
    }
    pub fn tile_dimensions(&self, index: usize) -> Result<(usize, usize), Error> {
        self.records.tile_dimensions(index)
    }
    /// Output must have exactly the packed valid tile length. Errors leave it
    /// unchanged. Successful decoding uses only caller output and stack scratch.
    pub fn decode_tile(&self, index: usize, output: &mut [u8]) -> Result<(), Error> {
        self.records.check_output(index, output.len())?;
        decode_record(self.records.record(index), output);
        Ok(())
    }
    pub fn delta(&self, surface: Surface, rgba: &[u8], limits: Limits) -> Result<Delta<'_>, Error> {
        if self.surface() != surface {
            return Err(Error::IdentityMismatch);
        }
        Ok(Delta {
            records: encode(surface, rgba, limits, Some(self))?,
            base: self,
        })
    }
    pub fn storage(&self) -> Storage {
        self.records.storage(size_of::<Self>(), 0)
    }
    pub fn modes(&self) -> Modes {
        self.records.modes()
    }
}

impl Delta<'_> {
    pub fn surface(&self) -> Surface {
        self.records.surface()
    }
    pub fn tile_count(&self) -> usize {
        self.records.tile_count()
    }
    pub fn tile_dimensions(&self, index: usize) -> Result<(usize, usize), Error> {
        self.records.tile_dimensions(index)
    }
    pub fn decode_tile(&self, index: usize, output: &mut [u8]) -> Result<(), Error> {
        self.records.check_output(index, output.len())?;
        let record = self.records.record(index);
        if record[0] == COPY {
            self.base.decode_tile(index, output)
        } else {
            decode_record(record, output);
            Ok(())
        }
    }
    pub fn storage(&self) -> Storage {
        self.records
            .storage(size_of::<Self>(), self.base.storage().total_resident_bytes)
    }
    pub fn modes(&self) -> Modes {
        self.records.modes()
    }
}

struct Records {
    bytes: Box<[u8]>,
}
impl Records {
    fn surface(&self) -> Surface {
        Surface {
            width: u32_at(&self.bytes, 8),
            height: u32_at(&self.bytes, 12),
            format: FormatIdentity(self.bytes[16..32].try_into().unwrap()),
        }
    }
    fn tile_count(&self) -> usize {
        u32_at(&self.bytes, 32) as usize
    }
    fn tile_dimensions(&self, index: usize) -> Result<(usize, usize), Error> {
        if index >= self.tile_count() {
            return Err(Error::TileIndex);
        }
        let s = self.surface();
        let columns = (s.width as usize).div_ceil(TILE_SIDE);
        Ok((
            (s.width as usize - index % columns * TILE_SIDE).min(TILE_SIDE),
            (s.height as usize - index / columns * TILE_SIDE).min(TILE_SIDE),
        ))
    }
    fn check_output(&self, index: usize, len: usize) -> Result<(), Error> {
        let (w, h) = self.tile_dimensions(index)?;
        if len == w * h * 4 {
            Ok(())
        } else {
            Err(Error::OutputLength)
        }
    }
    fn record(&self, index: usize) -> &[u8] {
        let start = u32_at(&self.bytes, HEADER + index * 4) as usize;
        let end = u32_at(&self.bytes, HEADER + (index + 1) * 4) as usize;
        &self.bytes[start..end]
    }
    fn storage(&self, object_bytes: usize, base_resident_bytes: usize) -> Storage {
        let directory_bytes = (self.tile_count() + 1) * 4;
        let stream_bytes = self.bytes.len();
        let surface = self.surface();
        Storage {
            object_bytes,
            stream_bytes,
            directory_bytes,
            record_bytes: stream_bytes - HEADER - directory_bytes,
            base_resident_bytes,
            total_resident_bytes: object_bytes + stream_bytes + base_resident_bytes,
            decoded_bytes: surface.width as usize * surface.height as usize * 4,
        }
    }
    fn modes(&self) -> Modes {
        let mut modes = Modes::default();
        for index in 0..self.tile_count() {
            match self.record(index)[0] {
                RAW => modes.raw += 1,
                SOLID => modes.solid += 1,
                PALETTE_RUNS => modes.palette_runs += 1,
                COPY => modes.copied += 1,
                _ => unreachable!("validated or encoder-produced record"),
            }
        }
        modes
    }
}

struct Geometry {
    columns: usize,
    tiles: usize,
    raw_bytes: usize,
    start: usize,
}
fn geometry(surface: Surface, limits: Limits) -> Result<Geometry, Error> {
    let w = surface.width as usize;
    let h = surface.height as usize;
    if w == 0 || h == 0 {
        return Err(Error::Dimensions);
    }
    let pixels = w.checked_mul(h).ok_or(Error::SizeOverflow)?;
    if pixels > limits.max_pixels {
        return Err(Error::LimitExceeded);
    }
    let raw_bytes = pixels.checked_mul(4).ok_or(Error::SizeOverflow)?;
    let columns = w.div_ceil(TILE_SIDE);
    let tiles = columns
        .checked_mul(h.div_ceil(TILE_SIDE))
        .ok_or(Error::SizeOverflow)?;
    let directory = tiles
        .checked_add(1)
        .and_then(|v| v.checked_mul(4))
        .ok_or(Error::SizeOverflow)?;
    let start = HEADER.checked_add(directory).ok_or(Error::SizeOverflow)?;
    let raw_bound = start
        .checked_add(raw_bytes)
        .and_then(|v| v.checked_add(tiles))
        .ok_or(Error::SizeOverflow)?;
    if raw_bytes > u32::MAX as usize || raw_bound > u32::MAX as usize {
        return Err(Error::SizeOverflow);
    }
    if start > limits.max_encoded_bytes {
        return Err(Error::LimitExceeded);
    }
    Ok(Geometry {
        columns,
        tiles,
        raw_bytes,
        start,
    })
}

fn encode(
    surface: Surface,
    rgba: &[u8],
    limits: Limits,
    base: Option<&Independent>,
) -> Result<Records, Error> {
    let geometry = geometry(surface, limits)?;
    if rgba.len() != geometry.raw_bytes {
        return Err(Error::PixelLength);
    }
    let mut scratch = Scratch::default();
    let mut encoded_len = geometry.start;
    for index in 0..geometry.tiles {
        let record = select_record(surface, &geometry, rgba, base, index, &mut scratch)?;
        encoded_len = encoded_len
            .checked_add(record.len())
            .ok_or(Error::SizeOverflow)?;
        if encoded_len > limits.max_encoded_bytes {
            return Err(Error::LimitExceeded);
        }
    }
    // Both passes read the same immutable input and independent base. The
    // selector has no side effects or external callbacks, so its sizes agree.
    let mut bytes = Vec::new();
    bytes
        .try_reserve_exact(encoded_len)
        .map_err(|_| Error::Allocation)?;
    bytes.resize(geometry.start, 0);
    bytes[..8].copy_from_slice(MAGIC);
    bytes[8..12].copy_from_slice(&surface.width.to_le_bytes());
    bytes[12..16].copy_from_slice(&surface.height.to_le_bytes());
    bytes[16..32].copy_from_slice(&surface.format.0);
    bytes[32..36].copy_from_slice(&(geometry.tiles as u32).to_le_bytes());
    for index in 0..geometry.tiles {
        set_offset(&mut bytes, index);
        select_record(surface, &geometry, rgba, base, index, &mut scratch)?.append_to(&mut bytes);
    }
    set_offset(&mut bytes, geometry.tiles);
    debug_assert_eq!(bytes.len(), encoded_len);
    Ok(Records {
        bytes: bytes.into_boxed_slice(),
    })
}

struct Scratch {
    tile: [u8; MAX_TILE_BYTES],
    old: [u8; MAX_TILE_BYTES],
    candidate: [u8; 2 + 16 * 4 + 256 * 2],
}
impl Default for Scratch {
    fn default() -> Self {
        Self {
            tile: [0; MAX_TILE_BYTES],
            old: [0; MAX_TILE_BYTES],
            candidate: [0; 2 + 16 * 4 + 256 * 2],
        }
    }
}
enum Selected<'a> {
    Raw(&'a [u8]),
    Encoded(&'a [u8]),
}
impl Selected<'_> {
    fn len(&self) -> usize {
        match self {
            Self::Raw(tile) => 1 + tile.len(),
            Self::Encoded(record) => record.len(),
        }
    }
    fn append_to(self, bytes: &mut Vec<u8>) {
        match self {
            Self::Raw(tile) => {
                bytes.push(RAW);
                bytes.extend_from_slice(tile);
            }
            Self::Encoded(record) => bytes.extend_from_slice(record),
        }
    }
}

fn select_record<'a>(
    surface: Surface,
    geometry: &Geometry,
    rgba: &[u8],
    base: Option<&Independent>,
    index: usize,
    scratch: &'a mut Scratch,
) -> Result<Selected<'a>, Error> {
    let x = index % geometry.columns * TILE_SIDE;
    let y = index / geometry.columns * TILE_SIDE;
    let w = (surface.width as usize - x).min(TILE_SIDE);
    let h = (surface.height as usize - y).min(TILE_SIDE);
    let length = w * h * 4;
    for row in 0..h {
        let start = ((y + row) * surface.width as usize + x) * 4;
        scratch.tile[row * w * 4..(row + 1) * w * 4].copy_from_slice(&rgba[start..start + w * 4]);
    }
    let tile = &scratch.tile[..length];
    if let Some(base) = base {
        base.decode_tile(index, &mut scratch.old[..length])?;
        if &scratch.old[..length] == tile {
            return Ok(Selected::Encoded(&[COPY]));
        }
    }
    if length == 4 {
        return Ok(Selected::Raw(tile));
    }
    if tile.chunks_exact(4).all(|pixel| pixel == &tile[..4]) {
        scratch.candidate[0] = SOLID;
        scratch.candidate[1..5].copy_from_slice(&tile[..4]);
        return Ok(Selected::Encoded(&scratch.candidate[..5]));
    }
    if let Some(count) = palette_runs(tile, &mut scratch.candidate)
        && count < length + 1
    {
        return Ok(Selected::Encoded(&scratch.candidate[..count]));
    }
    Ok(Selected::Raw(tile))
}

fn set_offset(bytes: &mut [u8], index: usize) {
    let length = (bytes.len() as u32).to_le_bytes();
    bytes[HEADER + index * 4..HEADER + (index + 1) * 4].copy_from_slice(&length);
}

// Bounded linear palette search (at most 16 entries), one candidate on stack.
fn palette_runs(tile: &[u8], output: &mut [u8]) -> Option<usize> {
    let mut palette = [[0u8; 4]; 16];
    let mut colors = 0;
    let mut indices = [0u8; 256];
    for (index, pixel) in tile.chunks_exact(4).enumerate() {
        let color = if let Some(found) = palette[..colors].iter().position(|entry| entry == pixel) {
            found
        } else {
            if colors == 16 {
                return None;
            }
            palette[colors].copy_from_slice(pixel);
            colors += 1;
            colors - 1
        };
        indices[index] = color as u8;
    }
    output[0] = PALETTE_RUNS;
    output[1] = colors as u8;
    let mut written = 2;
    for color in &palette[..colors] {
        output[written..written + 4].copy_from_slice(color);
        written += 4;
    }
    let indices = &indices[..tile.len() / 4];
    let mut cursor = 0;
    while cursor < indices.len() {
        let mut end = cursor + 1;
        while end < indices.len() && indices[end] == indices[cursor] {
            end += 1;
        }
        output[written] = (end - cursor - 1) as u8;
        output[written + 1] = indices[cursor];
        written += 2;
        cursor = end;
    }
    Some(written)
}

fn u32_at(bytes: &[u8], at: usize) -> u32 {
    u32::from_le_bytes(bytes[at..at + 4].try_into().unwrap())
}

fn validate(bytes: &[u8], limits: Limits) -> Result<(), Error> {
    if bytes.len() > limits.max_encoded_bytes {
        return Err(Error::LimitExceeded);
    }
    if bytes.len() < HEADER || &bytes[..8] != MAGIC {
        return Err(Error::Malformed);
    }
    let surface = Surface {
        width: u32_at(bytes, 8),
        height: u32_at(bytes, 12),
        format: FormatIdentity(bytes[16..32].try_into().unwrap()),
    };
    let geometry = geometry(surface, limits)?;
    if geometry.tiles != u32_at(bytes, 32) as usize
        || geometry.start > bytes.len()
        || u32_at(bytes, HEADER) as usize != geometry.start
    {
        return Err(Error::Malformed);
    }
    let records = |index| {
        let start = u32_at(bytes, HEADER + index * 4) as usize;
        let end = u32_at(bytes, HEADER + (index + 1) * 4) as usize;
        bytes.get(start..end).ok_or(Error::Malformed)
    };
    for index in 0..geometry.tiles {
        let record = records(index)?;
        let x = index % geometry.columns * TILE_SIDE;
        let y = index / geometry.columns * TILE_SIDE;
        let pixels = (surface.width as usize - x).min(TILE_SIDE)
            * (surface.height as usize - y).min(TILE_SIDE);
        let Some(&tag) = record.first() else {
            return Err(Error::Malformed);
        };
        match tag {
            RAW if record.len() == 1 + pixels * 4 => {}
            SOLID if record.len() == 5 => {}
            PALETTE_RUNS => {
                let colors = *record.get(1).ok_or(Error::Malformed)? as usize;
                if !(1..=16).contains(&colors) {
                    return Err(Error::Malformed);
                }
                let runs = record.get(2 + colors * 4..).ok_or(Error::Malformed)?;
                if runs.is_empty() || runs.len() % 2 != 0 || runs.len() / 2 > pixels {
                    return Err(Error::Malformed);
                }
                let mut total = 0;
                for run in runs.chunks_exact(2) {
                    if run[1] as usize >= colors {
                        return Err(Error::Malformed);
                    }
                    total += run[0] as usize + 1;
                    if total > pixels {
                        return Err(Error::Malformed);
                    }
                }
                if total != pixels {
                    return Err(Error::Malformed);
                }
            }
            _ => return Err(Error::Malformed),
        }
    }
    if u32_at(bytes, HEADER + geometry.tiles * 4) as usize != bytes.len() {
        return Err(Error::Malformed);
    }
    Ok(())
}

// Only encoder-produced or fully validated records reach this function.
fn decode_record(record: &[u8], output: &mut [u8]) {
    match record[0] {
        RAW => output.copy_from_slice(&record[1..]),
        SOLID => {
            for pixel in output.chunks_exact_mut(4) {
                pixel.copy_from_slice(&record[1..5]);
            }
        }
        PALETTE_RUNS => {
            let colors = record[1] as usize;
            let mut cursor = 0;
            for run in record[2 + colors * 4..].chunks_exact(2) {
                let color = 2 + run[1] as usize * 4;
                let end = cursor + (run[0] as usize + 1) * 4;
                for pixel in output[cursor..end].chunks_exact_mut(4) {
                    pixel.copy_from_slice(&record[color..color + 4]);
                }
                cursor = end;
            }
        }
        _ => unreachable!("validated independent record"),
    }
}
