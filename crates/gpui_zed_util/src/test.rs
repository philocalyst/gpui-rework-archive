mod assertions;
mod marked_text;

pub use assertions::*;
pub use marked_text::*;

use std::ffi::OsStr;
use std::path::{Path, PathBuf};
use tempfile::TempDir;

/// A temporary directory tree built from a JSON object and removed on drop.
///
/// Each object key names a child entry; nested objects and `null` create
/// directories, while strings create UTF-8 file contents. Other JSON values and
/// a non-object root panic. A key named `.git` whose value is an object also
/// initializes a Git repository where the platform supports the helper.
pub struct TempTree {
    _temp_dir: TempDir,
    path: PathBuf,
}

impl TempTree {
    /// Create the described tree in a fresh temporary directory.
    ///
    /// Directory creation, file writes, canonicalization, and optional Git
    /// initialization are asserted; failures panic.
    pub fn new(tree: serde_json::Value) -> Self {
        let dir = TempDir::new().unwrap();
        let path = std::fs::canonicalize(dir.path()).unwrap();
        write_tree(path.as_path(), tree);

        Self {
            _temp_dir: dir,
            path,
        }
    }

    /// Return the canonical temporary root. The directory remains alive while
    /// this `TempTree` value is alive.
    pub fn path(&self) -> &Path {
        self.path.as_path()
    }
}

fn write_tree(path: &Path, tree: serde_json::Value) {
    use serde_json::Value;
    use std::fs;

    if let Value::Object(map) = tree {
        for (name, contents) in map {
            let mut path = PathBuf::from(path);
            path.push(name);
            match contents {
                Value::Object(_) => {
                    fs::create_dir(&path).unwrap();

                    #[cfg(not(target_family = "wasm"))]
                    #[allow(clippy::disallowed_methods)]
                    if path.file_name() == Some(OsStr::new(".git")) {
                        let output = std::process::Command::new("git")
                            .args(["init", "-b", "main"])
                            .current_dir(path.parent().unwrap())
                            .env("GIT_CONFIG_GLOBAL", "")
                            .env("GIT_CONFIG_SYSTEM", "")
                            .output()
                            .expect("failed to init git repo");
                        assert!(
                            output.status.success(),
                            "git init failed: {}",
                            String::from_utf8_lossy(&output.stderr)
                        );
                    }

                    write_tree(&path, contents);
                }
                Value::Null => {
                    fs::create_dir(&path).unwrap();
                }
                Value::String(contents) => {
                    fs::write(&path, contents).unwrap();
                }
                _ => {
                    panic!("JSON object must contain only objects, strings, or null");
                }
            }
        }
    } else {
        panic!("You must pass a JSON object to this helper")
    }
}

/// Build `rows` lines, each repeating one character `cols` times, with no final
/// newline. Row `n` uses the scalar value obtained by wrapping
/// `start_char as u32 + n` to one byte and converting that byte to a `char`.
pub fn sample_text(rows: usize, cols: usize, start_char: char) -> String {
    let mut text = String::new();
    for row in 0..rows {
        let c: char = (start_char as u32 + row as u32) as u8 as char;
        let mut line = c.to_string().repeat(cols);
        if row < rows - 1 {
            line.push('\n');
        }
        text += &line;
    }
    text
}
