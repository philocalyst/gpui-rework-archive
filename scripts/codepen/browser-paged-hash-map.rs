//! Read the pinned ODHT v2 definition table by immutable byte range.
//!
//! ODHT's ordinary reader borrows one contiguous allocation. A browser cannot
//! mmap that allocation, and copying it eagerly faults tens of MiB of metadata.
//! Keep the exact serialized table and probe sequence, fetching only the header,
//! control groups and candidate entries. This is read-only; encoding stays ODHT.
use std::marker::PhantomData;
use odht::{Config, HashFn};
use crate::browser_paged_metadata::Bytes;

const HEADER: usize = 32;
const GROUP: usize = 16;
const ENTRY: usize = 12;

pub(crate) struct PagedHashTable<C: Config<EncodedKey = [u8; 8], EncodedValue = [u8; 4]>> {
    bytes: Bytes,
    start: usize,
    slots: usize,
    controls: usize,
    config: PhantomData<C>,
}

impl<C: Config<EncodedKey = [u8; 8], EncodedValue = [u8; 4]>> PagedHashTable<C> {
    pub(crate) fn new(bytes: Bytes, start: usize, length: usize) -> Result<Self, &'static str> {
        if length < HEADER || start.checked_add(length).is_none_or(|end| end > bytes.len()) {
            return Err("definition table exceeds metadata");
        }
        let header = bytes.range(start, HEADER);
        if &header[..4] != b"ODHT" || header[4..8] != [1, 8, 4, HEADER as u8]
            || header[24..28] != [0, 0, 0, 2] {
            return Err("definition table encoding differs from pinned ODHT v2");
        }
        let slots = usize::try_from(u64::from_le_bytes(header[16..24].try_into().unwrap()))
            .map_err(|_| "definition table exceeds address space")?;
        let expected = slots.checked_mul(ENTRY + 1).and_then(|size| size.checked_add(HEADER + GROUP));
        if !slots.is_power_of_two() || expected != Some(length) {
            return Err("definition table slot count or length is invalid");
        }
        let result = Self { bytes: bytes.clone(), start, slots, controls: start + HEADER + slots * ENTRY,
            config: PhantomData };
        // Match ODHT::from_raw_bytes' hash-function/empty-slot validation.
        for slot in 0..slots.min(10) {
            let control = result.bytes.range(result.controls + slot, 1)[0];
            let entry = result.bytes.range(result.start + HEADER + slot * ENTRY, ENTRY);
            if control & 0x80 != 0 {
                if entry.iter().any(|byte| *byte != 0) { return Err("nonzero empty definition slot"); }
            } else if control != (C::H::hash(&entry[..8]) >> 25) as u8 {
                return Err("definition table hash function differs");
            }
        }
        Ok(result)
    }

    pub(crate) fn get(&self, key: &C::Key) -> Option<C::Value> {
        let key = C::encode_key(key);
        let hash = C::H::hash(&key);
        let tag = (hash >> 25) as u8;
        let mask = self.slots - 1;
        let mut index = hash as usize & mask;
        let mut stride = 0;
        // ODHT mirrors its first 16 controls after the last slot. Its triangular
        // 16-slot probe sequence is independent of the reader's SIMD width.
        for _ in 0..self.slots.div_ceil(GROUP) {
            let controls = self.bytes.range(self.controls + index, GROUP);
            for (offset, control) in controls.iter().enumerate() {
                if *control == tag {
                    let slot = (index + offset) & mask;
                    let entry = self.bytes.range(self.start + HEADER + slot * ENTRY, ENTRY);
                    if entry[..8] == key {
                        return Some(C::decode_value(entry[8..].try_into().unwrap()));
                    }
                }
            }
            if controls.iter().any(|control| control & 0x80 != 0) { return None; }
            stride += GROUP;
            index = index.wrapping_add(stride) & mask;
        }
        panic!("corrupt definition table has no empty slot");
    }
}
