//! Locks for the browser compiler's private, in-memory WASI filesystem.
//!
//! Each Worker owns its files and runs one compiler session at a time. There is
//! no operating-system process sharing this filesystem. Retaining real shared
//! and exclusive guards still matters: rustc's cache collector must not remove
//! an incremental directory while a compiler session is reading or writing it.
use std::collections::{HashMap, hash_map::Entry};
use std::fs::File;
use std::io;
use std::path::{Path, PathBuf};
use std::sync::{LazyLock, Mutex};

enum State {
    Exclusive,
    Shared(usize),
}

static LOCKS: LazyLock<Mutex<HashMap<PathBuf, State>>> =
    LazyLock::new(|| Mutex::new(HashMap::new()));

#[derive(Debug)]
pub struct Lock {
    path: PathBuf,
    _file: File,
}

impl Lock {
    pub fn try_lock(path: &Path, file: File, exclusive: bool) -> io::Result<Self> {
        let mut locks = LOCKS.lock().unwrap();
        match locks.entry(path.to_owned()) {
            Entry::Vacant(entry) => {
                entry.insert(if exclusive { State::Exclusive } else { State::Shared(1) });
            }
            Entry::Occupied(mut entry) => match entry.get_mut() {
                State::Shared(readers) if !exclusive => {
                    *readers = readers.checked_add(1).ok_or(io::ErrorKind::WouldBlock)?;
                }
                _ => return Err(io::ErrorKind::WouldBlock.into()),
            },
        }
        Ok(Self { path: path.to_owned(), _file: file })
    }
}

impl Drop for Lock {
    fn drop(&mut self) {
        let mut locks = LOCKS.lock().unwrap();
        match locks.get_mut(&self.path).expect("live browser file lock") {
            State::Shared(readers) if *readers > 1 => *readers -= 1,
            _ => { locks.remove(&self.path); }
        }
    }
}
