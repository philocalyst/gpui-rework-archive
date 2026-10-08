//! Immutable metadata pages and a cursor with rustc's opaque encoding.
//!
//! Pages are published only after initialization and retained for this backing
//! store's lifetime. Cross-page decoder reads borrow its bounded scratch buffer;
//! persistent consumers explicitly take ownership of their exact byte range.
use std::borrow::Cow;
use std::io::{Read, Seek, SeekFrom};
use std::path::Path;
use std::sync::{Arc, Mutex, OnceLock};

use rustc_data_structures::owned_slice::OwnedSlice;
use rustc_serialize::{Decoder, leb128, opaque::{MAGIC_END_BYTES, MemDecoder}};

pub(crate) const PAGE_SIZE: usize = 16 * 1024;

#[derive(Clone)]
pub(crate) enum Bytes {
    Owned(OwnedSlice),
    Paged(Arc<PagedFile>),
}

pub(crate) struct PagedFile {
    // The immutable WASI inode owns a content-addressed Blob. Retain that open
    // handle, so even replacing a pathname cannot mix file generations.
    file: Mutex<std::fs::File>,
    length: usize,
    pages: Box<[OnceLock<Box<[u8]>>]>,
}

impl PagedFile {
    #[cfg(test)]
    pub(crate) fn loaded_pages(&self) -> usize {
        self.pages.iter().filter(|page| page.get().is_some()).count()
    }

    pub(crate) fn resident_pages(&self) -> impl Iterator<Item = usize> + '_ {
        self.pages.iter().enumerate().filter_map(|(index, page)| page.get().map(|_| index))
    }

    pub(crate) fn open(path: &Path) -> std::io::Result<Self> {
        let file = std::fs::File::open(path)?;
        let length = usize::try_from(file.metadata()?.len())
            .map_err(|_| std::io::Error::other("metadata exceeds address space"))?;
        Ok(Self {
            file: Mutex::new(file), length,
            pages: (0..length.div_ceil(PAGE_SIZE)).map(|_| OnceLock::new()).collect(),
        })
    }

    fn page(&self, index: usize) -> &[u8] {
        self.pages[index].get_or_init(|| {
            let start = index * PAGE_SIZE;
            let length = PAGE_SIZE.min(self.length - start);
            // The extra sentinel gives the existing MemDecoder a checked page
            // window. It is never exposed as part of the logical metadata.
            let mut bytes = vec![0; length + MAGIC_END_BYTES.len()];
            let mut file = self.file.lock().unwrap();
            file.seek(SeekFrom::Start(start as u64)).expect("seek immutable metadata page");
            file.read_exact(&mut bytes[..length]).expect("read immutable metadata page");
            bytes[length..].copy_from_slice(MAGIC_END_BYTES);
            bytes.into_boxed_slice()
        })
    }

    fn range(&self, start: usize, length: usize) -> Cow<'_, [u8]> {
        let end = start.checked_add(length).expect("metadata range overflow");
        assert!(end <= self.length, "metadata range exceeds file");
        if length == 0 { return Cow::Borrowed(&[]); }
        let first = start / PAGE_SIZE;
        let last = (end - 1) / PAGE_SIZE;
        if first == last {
            let offset = start % PAGE_SIZE;
            return Cow::Borrowed(&self.page(first)[offset..offset + length]);
        }
        let mut bytes = vec![0; length];
        self.copy_into(start, &mut bytes);
        Cow::Owned(bytes)
    }

    fn copy_into(&self, start: usize, output: &mut [u8]) {
        let end = start.checked_add(output.len()).expect("metadata range overflow");
        assert!(end <= self.length, "metadata range exceeds file");
        if output.is_empty() { return; }
        let mut copied = 0;
        for page in start / PAGE_SIZE..=(end - 1) / PAGE_SIZE {
            let page_start = page * PAGE_SIZE;
            let from = start.saturating_sub(page_start);
            let to = end.min(page_start + PAGE_SIZE) - page_start;
            output[copied..copied + to - from].copy_from_slice(&self.page(page)[from..to]);
            copied += to - from;
        }
    }
}

impl Bytes {
    pub(crate) fn len(&self) -> usize {
        match self { Self::Owned(bytes) => bytes.len(), Self::Paged(file) => file.length }
    }

    pub(crate) fn range(&self, start: usize, length: usize) -> Cow<'_, [u8]> {
        match self {
            Self::Owned(bytes) => Cow::Borrowed(&bytes[start..start.checked_add(length).expect("metadata range overflow")]),
            Self::Paged(file) => file.range(start, length),
        }
    }

    fn copy_into(&self, start: usize, output: &mut [u8]) {
        match self {
            Self::Owned(bytes) => output.copy_from_slice(&bytes[start..start.checked_add(output.len()).expect("metadata range overflow")]),
            Self::Paged(file) => file.copy_into(start, output),
        }
    }

    fn cursor(&self, position: usize, logical_length: usize) -> (usize, MemDecoder<'_>) {
        assert!(position <= logical_length, "metadata cursor exceeds file");
        if position == logical_length {
            return (position, MemDecoder::new(MAGIC_END_BYTES, 0).unwrap());
        }
        match self {
            Self::Owned(bytes) => (0, MemDecoder::new(bytes, position).unwrap()),
            Self::Paged(file) => {
                let start = position / PAGE_SIZE * PAGE_SIZE;
                (start, MemDecoder::new(file.page(position / PAGE_SIZE), position - start).unwrap())
            }
        }
    }
}

pub(crate) struct MetadataDecoder<'a> {
    bytes: &'a Bytes,
    length: usize,
    page_start: usize,
    opaque: MemDecoder<'a>,
    scratch: Vec<u8>,
}

impl<'a> MetadataDecoder<'a> {
    pub(crate) fn new(bytes: &'a Bytes, position: usize) -> Result<Self, ()> {
        let length = bytes.len().checked_sub(MAGIC_END_BYTES.len()).ok_or(())?;
        if bytes.range(length, MAGIC_END_BYTES.len()) != MAGIC_END_BYTES || position > length {
            return Err(());
        }
        let (page_start, opaque) = bytes.cursor(position, length);
        Ok(Self { bytes, length, page_start, opaque, scratch: Vec::new() })
    }

    pub(crate) fn len(&self) -> usize { self.length }
    pub(crate) fn remaining(&self) -> usize { self.length - self.position() }

    pub(crate) fn skip_bytes(&mut self, length: usize) {
        assert!(length <= self.remaining(), "metadata cursor exhausted");
        self.defer_cursor(self.position() + length);
    }

    #[cfg(test)]
    pub(crate) fn scratch_capacity(&self) -> usize { self.scratch.capacity() }

    pub(crate) fn split_at(&self, position: usize) -> Self {
        let (page_start, opaque) = self.bytes.cursor(position, self.length);
        Self { bytes: self.bytes, length: self.length, page_start, opaque, scratch: Vec::new() }
    }

    fn reposition(&mut self, position: usize) {
        (self.page_start, self.opaque) = self.bytes.cursor(position, self.length);
    }

    fn defer_cursor(&mut self, position: usize) {
        self.page_start = position;
        self.opaque = MemDecoder::new(MAGIC_END_BYTES, 0).unwrap();
    }

    pub(crate) fn read_array<const N: usize>(&mut self) -> [u8; N] {
        self.read_raw_bytes(N).try_into().unwrap()
    }

    pub(crate) fn with_position<R>(&mut self, position: usize, f: impl FnOnce(&mut Self) -> R) -> R {
        struct Restore<'a, 'b> { decoder: &'b mut MetadataDecoder<'a>, old: Option<MetadataDecoder<'a>> }
        impl Drop for Restore<'_, '_> {
            fn drop(&mut self) { *self.decoder = self.old.take().unwrap(); }
        }
        assert!(position < self.length, "metadata cursor exhausted");
        let replacement = self.split_at(position);
        let old = std::mem::replace(self, replacement);
        let guard = Restore { decoder: self, old: Some(old) };
        f(guard.decoder)
    }
}

macro_rules! read_leb {
    ($($method:ident, $ty:ty, $read:ident;)*) => {$(
        #[inline]
        fn $method(&mut self) -> $ty {
            let maximum = leb128::max_leb128_len::<$ty>();
            if self.opaque.remaining() >= maximum && self.remaining() >= maximum {
                self.opaque.$method()
            } else {
                // rustc's LEB readers take a MemDecoder. A boundary value is
                // at most 19 bytes, so decode it from a checked stack window.
                let mut window = [0; leb128::max_leb128_len::<u128>() + MAGIC_END_BYTES.len()];
                let mut length = 0;
                loop {
                    assert!(length < maximum, "metadata integer exceeds its encoded width");
                    let byte = self.read_u8();
                    window[length] = byte;
                    length += 1;
                    if byte & 0x80 == 0 { break; }
                }
                window[length..length + MAGIC_END_BYTES.len()].copy_from_slice(MAGIC_END_BYTES);
                let mut decoder = MemDecoder::new(&window[..length + MAGIC_END_BYTES.len()], 0).unwrap();
                leb128::$read(&mut decoder)
            }
        }
    )*};
}

impl<'a> Decoder for MetadataDecoder<'a> {
    read_leb! {
        read_usize, usize, read_usize_leb128; read_u128, u128, read_u128_leb128;
        read_u64, u64, read_u64_leb128; read_u32, u32, read_u32_leb128;
        read_isize, isize, read_isize_leb128; read_i128, i128, read_i128_leb128;
        read_i64, i64, read_i64_leb128; read_i32, i32, read_i32_leb128;
    }
    #[inline]
    fn read_u8(&mut self) -> u8 {
        assert!(self.remaining() != 0, "metadata cursor exhausted");
        if self.opaque.remaining() == 0 { self.reposition(self.position()); }
        self.opaque.read_u8()
    }
    fn read_u16(&mut self) -> u16 { u16::from_le_bytes(self.read_array()) }
    fn read_i16(&mut self) -> i16 { i16::from_le_bytes(self.read_array()) }
    fn read_raw_bytes(&mut self, length: usize) -> &[u8] {
        assert!(length <= self.remaining(), "metadata cursor exhausted");
        if length <= self.opaque.remaining() { return self.opaque.read_raw_bytes(length); }
        let start = self.position();
        self.scratch.resize(length, 0);
        self.bytes.copy_into(start, &mut self.scratch);
        if (start + length) % PAGE_SIZE == 0 { self.defer_cursor(start + length); }
        else { self.reposition(start + length); }
        &self.scratch
    }
    fn peek_byte(&self) -> u8 {
        assert!(self.remaining() != 0, "metadata cursor exhausted");
        if self.opaque.remaining() != 0 { self.opaque.peek_byte() }
        else { self.bytes.range(self.position(), 1)[0] }
    }
    fn position(&self) -> usize { self.page_start + self.opaque.position() }
}
