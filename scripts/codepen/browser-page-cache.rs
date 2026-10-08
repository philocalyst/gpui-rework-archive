//! Immutable SDK metadata survives compiler sessions as initialized pages.
//! Decoded types, DefIds, query results and MIR still belong to each TyCtxt.
use std::collections::HashMap;
use std::path::{Path, PathBuf};
use std::sync::{Arc, LazyLock, Mutex};

use rustc_data_structures::owned_slice::OwnedSlice;
use crate::browser_paged_metadata::{Bytes, PAGE_SIZE, PagedFile};

static FILES: LazyLock<Mutex<HashMap<PathBuf, Bytes>>> = LazyLock::new(|| Mutex::new(HashMap::new()));
static PROFILE: LazyLock<bool> = LazyLock::new(||
    std::env::var("GPUI_CODEPEN_PROFILE_METADATA").as_deref() == Ok("1"));

pub(crate) fn open(path: &Path) -> std::io::Result<Bytes> {
    assert!(path.starts_with("/deps") || path.starts_with("/sysroot"), "paged metadata must be immutable");
    let mut files = FILES.lock().unwrap();
    if let Some(bytes) = files.get(path) { return Ok(bytes.clone()); }
    let bytes = Bytes::Paged(Arc::new(PagedFile::open(path)?));
    files.insert(path.to_owned(), bytes.clone());
    Ok(bytes)
}

// Mutable compiler outputs retain their ordinary owned backing. Immutable
// .rmeta files enter through MetadataBlob::from_path before this loader.
pub(crate) fn read<E>(_: &Path, load: impl FnOnce() -> Result<OwnedSlice, E>) -> Result<OwnedSlice, E> {
    load()
}

// Page publication now observes actual reads, including headers and table
// lookups. Keep the former cursor instrumentation API without duplicating it.
#[inline]
pub(crate) fn record(_: &Bytes, _: usize, _: usize, _: &'static str) {}

pub(crate) fn report() -> Option<String> {
    if !*PROFILE { return None; }
    use std::fmt::Write;
    let files = FILES.lock().unwrap();
    let mut ordered: Vec<_> = files.iter().collect();
    ordered.sort_by_key(|(path, _)| *path);
    let mut output = String::new();
    for (path, bytes) in ordered {
        let Bytes::Paged(file) = bytes else { continue; };
        let pages: Vec<_> = file.resident_pages().flat_map(|page| {
            let start = page * PAGE_SIZE / 4096;
            let end = ((page + 1) * PAGE_SIZE).min(bytes.len()).div_ceil(4096);
            start..end
        }).collect();
        writeln!(&mut output, "GPUI_METADATA_PAGES\t{}\t{}\t{pages:?}\t[]", path.display(), bytes.len()).unwrap();
    }
    Some(output)
}
