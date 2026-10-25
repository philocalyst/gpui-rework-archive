#![feature(rustc_private)]
extern crate odht;
extern crate rustc_driver;
extern crate rustc_data_structures;
extern crate rustc_serialize;

#[path = "browser-paged-metadata.rs"] mod browser_paged_metadata;
#[path = "browser-paged-hash-map.rs"] mod table;

use browser_paged_metadata::{Bytes, PagedFile, PAGE_SIZE};
use odht::{Config, HashFn, HashTableOwned};
use rustc_data_structures::owned_slice::slice_owned;
use std::{marker::PhantomData, ops::Deref, sync::Arc};

struct TestConfig<H>(PhantomData<H>);
impl<H: HashFn> Config for TestConfig<H> {
    type Key = u64; type Value = u32;
    type EncodedKey = [u8; 8]; type EncodedValue = [u8; 4]; type H = H;
    fn encode_key(key: &u64) -> [u8; 8] { key.to_le_bytes() }
    fn encode_value(value: &u32) -> [u8; 4] { value.to_le_bytes() }
    fn decode_key(key: &[u8; 8]) -> u64 { u64::from_le_bytes(*key) }
    fn decode_value(value: &[u8; 4]) -> u32 { u32::from_le_bytes(*value) }
}
#[derive(Eq, PartialEq)] struct Collisions;
impl HashFn for Collisions { fn hash(_: &[u8]) -> u32 { u32::MAX - 3 } }
fn mix(mut key: u64) -> u64 {
    key = (key ^ key >> 30).wrapping_mul(0xbf58476d1ce4e5b9);
    key = (key ^ key >> 27).wrapping_mul(0x94d049bb133111eb);
    key ^ key >> 31
}
fn parity<H: HashFn>(counts: &[usize]) {
    for &count in counts {
        let mut original = HashTableOwned::<TestConfig<H>>::with_capacity(count, 95);
        for i in 0..count { original.insert(&mix(i as u64), &(i as u32)); }
        for i in (0..count).step_by(7) { original.insert(&mix(i as u64), &(i as u32 + 1)); }
        for prefix in [0, PAGE_SIZE - 17, PAGE_SIZE + 1] {
            let mut data = vec![0xee; prefix]; data.extend_from_slice(original.raw_bytes());
            let bytes = Bytes::Owned(slice_owned(data, Deref::deref));
            let paged = table::PagedHashTable::<TestConfig<H>>::new(bytes, prefix, original.raw_bytes().len()).unwrap();
            for i in 0..count + 500 {
                assert_eq!(paged.get(&mix(i as u64)), original.get(&mix(i as u64)), "count {count}, key {i}, prefix {prefix}");
            }
        }
    }
}
#[test] fn matches_pinned_odht_for_empty_small_dense_and_large_tables() {
    parity::<odht::UnHashFn>(&[0, 1, 8, 20, 300, 5000, 100000]);
    parity::<odht::FxHashFn>(&[0, 1, 20, 300, 5000]);
}
#[test] fn collisions_wraparound_and_multiple_probe_groups_match() {
    parity::<Collisions>(&[1, 20, 300, 1000]);
}
#[test] fn short_tables_match_odht_through_the_mirrored_controls() {
    let template = HashTableOwned::<TestConfig<odht::UnHashFn>>::with_capacity(0, 95);
    for slots in [1usize, 2, 4, 8] {
        let mut data = vec![0; 32 + 12 * slots + slots + 16];
        data[..32].copy_from_slice(&template.raw_bytes()[..32]);
        data[8..16].copy_from_slice(&0u64.to_le_bytes());
        data[16..24].copy_from_slice(&(slots as u64).to_le_bytes());
        data[32 + 12 * slots..].fill(0x80);
        if slots > 1 {
            // Start in the last slot so probes cross the mirrored tail.
            let key = ((slots as u64 - 1) << 32).to_le_bytes();
            let entry = 32 + 12 * (slots - 1);
            data[entry..entry + 8].copy_from_slice(&key);
            data[entry + 8..entry + 12].copy_from_slice(&42u32.to_le_bytes());
            data[8..16].copy_from_slice(&1u64.to_le_bytes());
            for control in 0..slots + 16 {
                if control % slots == slots - 1 { data[32 + 12 * slots + control] = 0; }
            }
        }
        let ordinary = odht::HashTable::<TestConfig<odht::UnHashFn>, _>::from_raw_bytes(data.as_slice()).unwrap();
        let paged = table::PagedHashTable::<TestConfig<odht::UnHashFn>>::new(
            Bytes::Owned(slice_owned(data.clone(), Deref::deref)), 0, data.len()).unwrap();
        for key in [0, (slots as u64 - 1) << 32, u64::MAX] {
            assert_eq!(paged.get(&key), ordinary.get(&key), "slots {slots}, key {key}");
        }
    }
}
#[test] fn a_large_table_reads_a_few_pages_instead_of_copying_it() {
    let mut original = HashTableOwned::<TestConfig<odht::UnHashFn>>::with_capacity(100000, 95);
    for i in 0..100000 { original.insert(&mix(i), &(i as u32)); }
    let path = std::env::temp_dir().join(format!("gpui-odht-{}", std::process::id()));
    std::fs::write(&path, original.raw_bytes()).unwrap();
    let file = Arc::new(PagedFile::open(&path).unwrap());
    let table = table::PagedHashTable::<TestConfig<odht::UnHashFn>>::new(Bytes::Paged(file.clone()), 0, original.raw_bytes().len()).unwrap();
    assert_eq!(table.get(&mix(99999)), Some(99999));
    assert!(file.loaded_pages() < 8, "A lookup should not materialize {} pages", original.raw_bytes().len().div_ceil(PAGE_SIZE));
    std::fs::remove_file(path).unwrap();
}
#[test] fn invalid_header_ranges_and_hashes_are_rejected() {
    let mut original = HashTableOwned::<TestConfig<Collisions>>::with_capacity(20, 95);
    original.insert(&12, &34);
    let source = original.raw_bytes();
    for offset in [0, 4, 5, 6, 7, 16, 24] {
        let mut data = source.to_vec(); data[offset] ^= 0x41;
        assert!(table::PagedHashTable::<TestConfig<Collisions>>::new(Bytes::Owned(slice_owned(data, Deref::deref)), 0, source.len()).is_err());
    }
    let bytes = Bytes::Owned(slice_owned(source.to_vec(), Deref::deref));
    assert!(table::PagedHashTable::<TestConfig<Collisions>>::new(bytes.clone(), 0, 31).is_err());
    assert!(table::PagedHashTable::<TestConfig<Collisions>>::new(bytes.clone(), usize::MAX, source.len()).is_err());
    assert!(table::PagedHashTable::<TestConfig<Collisions>>::new(bytes, 1, source.len()).is_err());
}
