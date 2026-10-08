//! Share immutable, untyped metadata bytes between browser compiler sessions.
//! Types, DefIds, decoded MIR and query arenas still belong to each fresh TyCtxt.
use std::collections::HashMap;
use std::path::{Path, PathBuf};
use std::sync::{LazyLock, Mutex};

use rustc_data_structures::owned_slice::OwnedSlice;

static FILES: LazyLock<Mutex<HashMap<PathBuf, OwnedSlice>>> =
    LazyLock::new(|| Mutex::new(HashMap::new()));

pub(crate) fn read<E>(path: &Path, load: impl FnOnce() -> Result<OwnedSlice, E>) -> Result<OwnedSlice, E> {
    // Only these two roots are immutable for the entire WASM instance. Edited
    // crates and incremental query files must always read their current bytes.
    let immutable = path.starts_with("/deps") || path.starts_with("/sysroot");
    if immutable && let Some(bytes) = FILES.lock().unwrap().get(path).cloned() {
        return Ok(bytes);
    }
    let bytes = load()?;
    if immutable {
        FILES.lock().unwrap().insert(path.to_owned(), bytes.clone());
    }
    Ok(bytes)
}
