#![feature(rustc_private)]

extern crate rustc_data_structures;
extern crate rustc_driver;
extern crate rustc_serialize;

#[path = "browser-paged-metadata.rs"]
mod paged;

use paged::{Bytes, MetadataDecoder, PAGE_SIZE, PagedFile};
use rustc_data_structures::owned_slice::slice_owned;
use rustc_serialize::{Decoder, Encoder, opaque::{MAGIC_END_BYTES, MemDecoder, mem_encoder::MemEncoder}};
use std::{ops::Deref, path::PathBuf, sync::{Arc, atomic::{AtomicUsize, Ordering}}};

struct Fixture { path: PathBuf, file: Arc<PagedFile>, encoded: Vec<u8> }

impl Fixture {
    fn new(mut encoded: Vec<u8>) -> Self {
        static NEXT: AtomicUsize = AtomicUsize::new(0);
        encoded.extend_from_slice(MAGIC_END_BYTES);
        let path = std::env::temp_dir().join(format!("gpui-rmeta-{}-{}", std::process::id(), NEXT.fetch_add(1, Ordering::Relaxed)));
        std::fs::write(&path, &encoded).unwrap();
        let file = Arc::new(PagedFile::open(&path).unwrap());
        Self { path, file, encoded }
    }
    fn bytes(&self) -> Bytes { Bytes::Paged(Arc::clone(&self.file)) }
}

impl Drop for Fixture {
    fn drop(&mut self) { std::fs::remove_file(&self.path).unwrap(); }
}

#[test]
fn integers_and_strings_match_opaque_at_every_page_boundary_offset() {
    let mut encoder = MemEncoder::new();
    encoder.emit_usize(usize::MAX);
    encoder.emit_u128(u128::MAX);
    encoder.emit_u64(u64::MAX);
    encoder.emit_u32(u32::MAX);
    encoder.emit_u16(0xabcd);
    encoder.emit_u8(0xee);
    encoder.emit_isize(isize::MIN);
    encoder.emit_i128(i128::MIN);
    encoder.emit_i64(i64::MIN);
    encoder.emit_i32(i32::MIN);
    encoder.emit_i16(i16::MIN);
    encoder.emit_str("Rust 🦀 GPUI\0 multibyte UTF-8");
    let sequence = encoder.finish();
    for offset in 0..=sequence.len() {
        let start = PAGE_SIZE - offset;
        let mut encoded = vec![0; start];
        encoded.extend_from_slice(&sequence);
        let fixture = Fixture::new(encoded);
        let bytes = fixture.bytes();
        let mut actual = MetadataDecoder::new(&bytes, start).unwrap();
        let mut expected = MemDecoder::new(&fixture.encoded, start).unwrap();
        macro_rules! equal { ($($method:ident),*) => { $(assert_eq!(actual.$method(), expected.$method(), "offset {offset}: {}", stringify!($method));)* }; }
        equal!(read_usize, read_u128, read_u64, read_u32, read_u16, read_u8,
            read_isize, read_i128, read_i64, read_i32, read_i16, read_str);
        assert_eq!(actual.position(), expected.position());
        assert_eq!(actual.remaining(), 0);
    }
}

#[test]
fn pages_are_loaded_only_when_requested_and_borrowed_spans_remain_stable() {
    let data: Vec<u8> = (0..PAGE_SIZE * 6).map(|i| (i % 251) as u8).collect();
    let fixture = Fixture::new(data.clone());
    assert_eq!(fixture.file.loaded_pages(), 0);
    let bytes = fixture.bytes();
    let mut decoder = MetadataDecoder::new(&bytes, PAGE_SIZE - 8).unwrap();
    assert_eq!(fixture.file.loaded_pages(), 2); // cursor page and final sentinel
    let span = bytes.range(PAGE_SIZE - 8, 32);
    let pointer = span.as_ptr();
    assert_eq!(fixture.file.loaded_pages(), 3);
    assert_eq!(decoder.read_raw_bytes(32), span);
    assert_eq!(bytes.range(PAGE_SIZE - 8, 32), span);
    for page in 2..6 { assert_eq!(bytes.range(page * PAGE_SIZE, 42), &data[page * PAGE_SIZE..page * PAGE_SIZE + 42]); }
    assert_eq!(span, &data[PAGE_SIZE - 8..PAGE_SIZE + 24]);
    assert_eq!(span.as_ptr(), pointer);
    assert_eq!(decoder.position(), PAGE_SIZE + 24);
    assert_eq!(fixture.file.loaded_pages(), 7);
}

#[test]
fn nested_position_changes_restore_the_entire_cursor_even_on_unwind() {
    let fixture = Fixture::new(vec![42; PAGE_SIZE * 3]);
    let bytes = fixture.bytes();
    let mut decoder = MetadataDecoder::new(&bytes, PAGE_SIZE - 1).unwrap();
    let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        decoder.with_position(PAGE_SIZE * 2 + 5, |decoder| {
            assert_eq!(decoder.read_u8(), 42);
            decoder.with_position(17, |decoder| { decoder.read_u8(); });
            assert_eq!(decoder.position(), PAGE_SIZE * 2 + 6);
            panic!("test unwind");
        });
    }));
    assert!(result.is_err());
    assert_eq!(decoder.position(), PAGE_SIZE - 1);
    assert_eq!(decoder.read_u16(), 0x2a2a);
    assert_eq!(decoder.position(), PAGE_SIZE + 1);
}

#[test]
fn empty_and_end_cursors_and_peek_work_without_exposing_sentinels() {
    let fixture = Fixture::new(vec![7; PAGE_SIZE]);
    let bytes = fixture.bytes();
    let mut decoder = MetadataDecoder::new(&bytes, PAGE_SIZE - 1).unwrap();
    assert_eq!(decoder.peek_byte(), 7);
    assert_eq!(decoder.read_u8(), 7);
    assert!(decoder.read_raw_bytes(0).is_empty());
    assert_eq!(decoder.remaining(), 0);
    assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| decoder.read_u8())).is_err());
    assert_eq!(decoder.split_at(PAGE_SIZE).position(), PAGE_SIZE);
    let empty = Fixture::new(vec![]);
    assert_eq!(MetadataDecoder::new(&empty.bytes(), 0).unwrap().remaining(), 0);
}

#[test]
fn owned_bytes_and_paged_bytes_obey_the_same_bounds() {
    let fixture = Fixture::new(vec![37; PAGE_SIZE + 5]);
    let bytes = Bytes::Owned(slice_owned(fixture.encoded.clone(), Deref::deref));
    let mut decoder = MetadataDecoder::new(&bytes, PAGE_SIZE - 1).unwrap();
    assert_eq!(decoder.read_raw_bytes(6), &[37; 6]);
    assert!(MetadataDecoder::new(&bytes, PAGE_SIZE + 6).is_err());
    let invalid = Bytes::Owned(slice_owned(vec![0; 100], Deref::deref));
    assert!(MetadataDecoder::new(&invalid, 0).is_err());
    let short = Bytes::Owned(slice_owned(vec![0; MAGIC_END_BYTES.len() - 1], Deref::deref));
    assert!(MetadataDecoder::new(&short, 0).is_err());
}

#[test]
fn short_leb_values_at_the_boundary_do_not_consume_the_next_page() {
    let fixture = Fixture::new(vec![1; PAGE_SIZE * 3]);
    let bytes = fixture.bytes();
    let mut decoder = MetadataDecoder::new(&bytes, PAGE_SIZE - 1).unwrap();
    assert_eq!(fixture.file.loaded_pages(), 2);
    assert_eq!(decoder.read_u64(), 1);
    assert_eq!(decoder.position(), PAGE_SIZE);
    // The boundary decoder must not fault a page merely to fill the largest
    // possible integer window when the first byte already terminates a value.
    assert_eq!(fixture.file.loaded_pages(), 2);
    assert_eq!(decoder.peek_byte(), 1);
    assert_eq!(decoder.position(), PAGE_SIZE);
    assert_eq!(fixture.file.loaded_pages(), 3);
}

#[test]
fn replacing_a_path_does_not_mix_snapshot_generations() {
    let fixture = Fixture::new(vec![17; PAGE_SIZE * 3]);
    let bytes = fixture.bytes();
    assert_eq!(bytes.range(0, 1)[0], 17);
    let replacement = fixture.path.with_extension("replacement");
    std::fs::write(&replacement, vec![99; fixture.encoded.len()]).unwrap();
    std::fs::rename(&replacement, &fixture.path).unwrap();
    assert_eq!(bytes.range(PAGE_SIZE * 2, 1)[0], 17);
    assert!(MetadataDecoder::new(&bytes, 0).is_ok());
}

#[test]
fn persistent_owned_ranges_advance_without_a_second_copy_or_overfetch() {
    let fixture = Fixture::new(vec![53; PAGE_SIZE * 5]);
    let bytes = fixture.bytes();
    let start = PAGE_SIZE - 4;
    let length = PAGE_SIZE + 4;
    let mut decoder = MetadataDecoder::new(&bytes, start).unwrap();
    let owned = bytes.range(start, length).into_owned();
    assert_eq!(fixture.file.loaded_pages(), 3);
    decoder.skip_bytes(length);
    assert_eq!(decoder.position(), PAGE_SIZE * 2);
    assert_eq!(decoder.scratch_capacity(), 0);
    assert_eq!(fixture.file.loaded_pages(), 3);
    assert_eq!(decoder.peek_byte(), 53);
    assert_eq!(decoder.position(), PAGE_SIZE * 2);
    assert_eq!(fixture.file.loaded_pages(), 4);
    assert!(owned.iter().all(|&byte| byte == 53));
}

#[test]
fn a_cross_page_read_ending_on_a_boundary_defers_the_next_page() {
    let fixture = Fixture::new(vec![29; PAGE_SIZE * 5]);
    let bytes = fixture.bytes();
    let mut decoder = MetadataDecoder::new(&bytes, PAGE_SIZE - 4).unwrap();
    assert_eq!(decoder.read_raw_bytes(PAGE_SIZE + 4).len(), PAGE_SIZE + 4);
    assert_eq!(decoder.position(), PAGE_SIZE * 2);
    assert_eq!(fixture.file.loaded_pages(), 3);
    assert_eq!(decoder.read_u8(), 29);
    assert_eq!(fixture.file.loaded_pages(), 4);
}
