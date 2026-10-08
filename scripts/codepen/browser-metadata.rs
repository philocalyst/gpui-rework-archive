//! Share immutable, untyped metadata bytes between browser compiler sessions.
//! Types, DefIds, decoded MIR and query arenas still belong to each fresh TyCtxt.
use std::collections::HashMap;
use std::path::{Path, PathBuf};
use std::sync::{LazyLock, Mutex};

use rustc_data_structures::owned_slice::OwnedSlice;

static FILES: LazyLock<Mutex<HashMap<PathBuf, OwnedSlice>>> =
    LazyLock::new(|| Mutex::new(HashMap::new()));

static PROFILE: LazyLock<bool> = LazyLock::new(||
    std::env::var("GPUI_CODEPEN_PROFILE_METADATA").as_deref() == Ok("1"));
static RANGES: LazyLock<Mutex<HashMap<usize, RangeProfile>>> =
    LazyLock::new(|| Mutex::new(HashMap::new()));
const PAGE: usize = 4096;

struct RangeProfile {
    path: PathBuf,
    length: usize,
    pages: Vec<u64>,
    accesses: HashMap<&'static str, (u64, u64)>,
}
impl RangeProfile {
    fn record(&mut self, start: usize, length: usize, class: &'static str) {
        let end = start.checked_add(length).expect("metadata profile range overflow");
        assert!(end <= self.length, "metadata profile range exceeds file");
        if length == 0 { return; }
        for page in start / PAGE..=(end - 1) / PAGE {
            self.pages[page / 64] |= 1 << (page % 64);
        }
        let counts = self.accesses.entry(class).or_default();
        counts.0 += 1;
        counts.1 += length as u64;
    }
}

fn register(path: &Path, bytes: &[u8]) {
    if !*PROFILE { return; }
    let mut ranges = RANGES.lock().unwrap();
    let profile = ranges.entry(bytes.as_ptr() as usize).or_insert_with(|| RangeProfile {
        path: path.to_owned(), length: bytes.len(),
        pages: vec![0; bytes.len().div_ceil(PAGE).div_ceil(64)],
        accesses: HashMap::new(),
    });
    // Fixed root/version/hash offsets and the end sentinel are outside the
    // ordinary decoder cursor. Conservatively include their complete pages.
    profile.record(0, bytes.len().min(PAGE), "header");
    let sentinel = rustc_serialize::opaque::MAGIC_END_BYTES.len().min(bytes.len());
    profile.record(bytes.len() - sentinel, sentinel, "sentinel");
}

/// Observe completed contiguous decoder runs, never every decoded byte. This
/// leaves the ordinary MemDecoder fast path and its borrowing rules unchanged.
pub(crate) fn record(bytes: &[u8], start: usize, length: usize, class: &'static str) {
    if !*PROFILE { return; }
    if let Some(profile) = RANGES.lock().unwrap().get_mut(&(bytes.as_ptr() as usize)) {
        profile.record(start, length, class);
    }
}

pub(crate) fn report() -> Option<String> {
    if !*PROFILE { return None; }
    use std::fmt::Write;
    let ranges = RANGES.lock().unwrap();
    let mut profiles: Vec<_> = ranges.values().collect();
    profiles.sort_by(|left, right| left.path.cmp(&right.path));
    let mut report = String::new();
    for profile in profiles {
        let pages: Vec<_> = (0..profile.length.div_ceil(PAGE))
            .filter(|&page| profile.pages[page / 64] & (1 << (page % 64)) != 0).collect();
        let mut accesses: Vec<_> = profile.accesses.iter().collect();
        accesses.sort_by_key(|&(class, _)| *class);
        writeln!(&mut report, "GPUI_METADATA_PAGES\t{}\t{}\t{pages:?}\t{accesses:?}",
            profile.path.display(), profile.length).unwrap();
    }
    Some(report)
}

pub(crate) fn read<E>(path: &Path, load: impl FnOnce() -> Result<OwnedSlice, E>) -> Result<OwnedSlice, E> {
    // Only these two roots are immutable for the entire WASM instance. Edited
    // crates and incremental query files must always read their current bytes.
    let immutable = path.starts_with("/deps") || path.starts_with("/sysroot");
    if immutable && let Some(bytes) = FILES.lock().unwrap().get(path).cloned() {
        return Ok(bytes);
    }
    let bytes = load()?;
    if immutable {
        register(path, &bytes);
        FILES.lock().unwrap().insert(path.to_owned(), bytes.clone());
    }
    Ok(bytes)
}
