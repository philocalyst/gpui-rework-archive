use std::{
    borrow::{Borrow, Cow},
    fmt, io,
    ops::Deref,
    path::{Path, PathBuf},
    rc::Rc,
    sync::Arc,
};

use anyhow::Context;

use crate::{PathStyle, rel_path::RelPath};

/// An absolute path on the user's local filesystem.
///
/// Values are guaranteed to be absolute and valid UTF-8. Construct one with [`Self::new`].
#[derive(PartialEq, Eq, Hash, Debug, PartialOrd, Ord)]
#[repr(transparent)]
pub struct AbsPath(Path);

impl AbsPath {
    /// Validates an absolute, UTF-8 path without allocating.
    ///
    /// Returns an error when `path` is relative or contains non-UTF-8 data.
    pub fn new(path: &Path) -> anyhow::Result<&Self> {
        if !path.is_absolute() {
            return Err(anyhow::anyhow!("Path is not absolute: {:?}", path));
        }
        if path.to_str().is_none() {
            return Err(anyhow::anyhow!("Path is not valid utf-8: {:?}", path));
        }
        Ok(Self::new_unchecked(path))
    }

    fn new_unchecked(path: &Path) -> &Self {
        // SAFETY: `AbsPath` is a `repr(transparent)` wrapper around `Path`.
        unsafe { &*(path as *const Path as *const Self) }
    }

    /// Copies this path into an owned absolute path buffer.
    pub fn to_abs_path_buf(&self) -> AbsPathBuf {
        AbsPathBuf(self.0.to_owned())
    }

    /// Appends a single UTF-8 path component or relative fragment.
    pub fn join(&self, name: impl AsRef<str>) -> AbsPathBuf {
        AbsPathBuf(self.0.join(name.as_ref()))
    }

    /// Appends a validated relative path without changing its components.
    pub fn join_rel_path(&self, relative_path: &RelPath) -> AbsPathBuf {
        AbsPathBuf(self.0.join(relative_path.as_std_path()))
    }

    /// Returns the parent directory, if this path has one.
    pub fn parent(&self) -> Option<&AbsPath> {
        let parent = self.0.parent()?;
        Some(AbsPath::new_unchecked(parent))
    }

    /// Returns whether this path begins with `other`'s components.
    pub fn starts_with(&self, other: &AbsPath) -> bool {
        self.0.starts_with(&other.0)
    }

    /// Returns whether this path ends with `other`'s components.
    pub fn ends_with(&self, other: &RelPath) -> bool {
        self.0.ends_with(other.as_std_path())
    }

    /// Returns whether this path is a strict descendant of `ancestor`.
    pub fn is_descendant_of(&self, ancestor: &Self) -> bool {
        if self == ancestor {
            return false;
        }
        self.starts_with(ancestor)
    }

    /// Returns the UTF-8 file name, if present.
    pub fn file_name(&self) -> Option<&str> {
        self.0.file_name()?.to_str()
    }

    /// Formats this path using the host's display conventions.
    pub fn display(&self) -> impl fmt::Display + '_ {
        self.0.display()
    }

    /// Borrows the underlying standard-library path.
    pub fn as_std_path(&self) -> &Path {
        &self.0
    }

    /// Returns the path as UTF-8 text.
    pub fn as_str(&self) -> &str {
        self.0
            .to_str()
            .expect("valid UTF-8 enforced in constructor")
    }

    /// Iterates this path and each parent toward the filesystem root.
    pub fn ancestors(&self) -> impl Iterator<Item = &AbsPath> {
        self.0.ancestors().map(AbsPath::new_unchecked)
    }

    /// Removes an absolute prefix and parses the remainder as a relative path.
    ///
    /// Returns `None` when the prefix does not match or the remainder cannot be normalized.
    pub fn strip_prefix<'a>(&'a self, prefix: &AbsPath) -> Option<Cow<'a, RelPath>> {
        let prefix = self.0.strip_prefix(&prefix.0).ok()?;
        RelPath::new(prefix, PathStyle::local()).ok()
    }
}

impl ToOwned for AbsPath {
    type Owned = AbsPathBuf;

    fn to_owned(&self) -> Self::Owned {
        self.to_abs_path_buf()
    }
}

impl AsRef<Path> for AbsPath {
    fn as_ref(&self) -> &Path {
        &self.0
    }
}

impl AsRef<AbsPath> for AbsPath {
    fn as_ref(&self) -> &AbsPath {
        self
    }
}

impl From<&AbsPath> for Arc<AbsPath> {
    fn from(path: &AbsPath) -> Self {
        let arc: Arc<Path> = Arc::from(&path.0);
        // SAFETY: `AbsPath` is a `repr(transparent)` wrapper around `Path`.
        unsafe { Arc::from_raw(Arc::into_raw(arc) as *const AbsPath) }
    }
}

impl From<&AbsPath> for Rc<AbsPath> {
    fn from(path: &AbsPath) -> Self {
        let arc: Rc<Path> = Rc::from(&path.0);
        // SAFETY: `AbsPath` is a `repr(transparent)` wrapper around `Path`.
        unsafe { Rc::from_raw(Rc::into_raw(arc) as *const AbsPath) }
    }
}

// An absolute path on the user's local filesystem.
#[derive(Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
/// An owned, validated absolute path.
pub struct AbsPathBuf(PathBuf);

impl AbsPathBuf {
    /// Creates an owned absolute path, rejecting relative or non-UTF-8 input.
    pub fn new(path: impl Into<PathBuf>) -> anyhow::Result<Self> {
        let path = path.into();
        AbsPath::new(&path)?;
        Ok(Self(path))
    }

    /// Returns the current user's home directory.
    pub fn home_dir() -> anyhow::Result<Self> {
        let home = std::env::home_dir().context("no home dir available")?;
        Self::new(home)
    }

    /// Resolves `path` to its canonical on-disk spelling: symlinks and `..`
    /// are resolved, relative input is anchored on the current directory, and
    /// on case-insensitive filesystems each component takes the casing stored
    /// on disk. Unlike [`std::fs::canonicalize`], the result never uses
    /// Windows extended-length (`\\?\`) syntax, which chokes tools the path
    /// is later handed to (e.g. `git`).
    ///
    /// Paths act as identity in several places (lock keys, watch-target
    /// comparisons, persisted repository records), so canonicalize a path
    /// where it enters the system whenever it may have been spelled by a user
    /// or an external tool.
    pub fn canonicalize(path: impl AsRef<Path>) -> io::Result<Self> {
        let canonical = dunce::canonicalize(path.as_ref())?;
        Self::new(canonical).map_err(io::Error::other)
    }

    /// Appends one path component.
    pub fn push(&mut self, name: &str) {
        self.0.push(name);
    }

    #[cfg(any(test, feature = "test-support"))]
    pub fn new_test(path: &'static str) -> Self {
        if cfg!(windows) {
            Self::new(format!("C:{path}")).unwrap()
        } else {
            Self::new(path).unwrap()
        }
    }
}

#[cfg(any(test, feature = "test-support"))]
pub fn abs_path(path: &str) -> AbsPathBuf {
    if cfg!(windows) {
        AbsPathBuf::new(format!("C:{path}")).unwrap()
    } else {
        AbsPathBuf::new(path).unwrap()
    }
}

impl Deref for AbsPathBuf {
    type Target = AbsPath;

    fn deref(&self) -> &Self::Target {
        AbsPath::new_unchecked(&self.0)
    }
}

impl Borrow<AbsPath> for AbsPathBuf {
    fn borrow(&self) -> &AbsPath {
        self
    }
}

impl AsRef<Path> for AbsPathBuf {
    fn as_ref(&self) -> &Path {
        self.0.as_ref()
    }
}

impl AsRef<AbsPath> for AbsPathBuf {
    fn as_ref(&self) -> &AbsPath {
        self
    }
}

impl From<AbsPathBuf> for PathBuf {
    fn from(path: AbsPathBuf) -> PathBuf {
        path.0
    }
}

impl fmt::Display for AbsPathBuf {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        self.as_str().fmt(f)
    }
}

impl PartialEq<AbsPath> for AbsPathBuf {
    fn eq(&self, other: &AbsPath) -> bool {
        **self == *other
    }
}

impl PartialEq<AbsPathBuf> for AbsPath {
    fn eq(&self, other: &AbsPathBuf) -> bool {
        *self == **other
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_canonicalize_restores_on_disk_spelling() {
        let temp = tempfile::tempdir().unwrap();
        let root = dunce::canonicalize(temp.path()).unwrap();
        let dir = root.join("CamelCase");
        std::fs::create_dir(&dir).unwrap();

        let canonical = AbsPathBuf::canonicalize(&dir).unwrap();
        assert_eq!(canonical.as_std_path(), dir);
        assert!(
            !canonical.as_str().starts_with(r"\\?\"),
            "canonical paths must not use Windows extended-length syntax: {canonical}"
        );

        // A differently-cased spelling addresses the same directory only on a
        // case-insensitive filesystem; when it does, canonicalization must
        // restore the stored casing.
        let lowercased = root.join("camelcase");
        if std::fs::metadata(&lowercased).is_ok() {
            assert_eq!(
                AbsPathBuf::canonicalize(&lowercased).unwrap().as_std_path(),
                dir,
                "canonicalization should restore the on-disk casing"
            );
        }
    }

    #[test]
    fn test_new_test_normalizes_rooted_paths() {
        if cfg!(windows) {
            assert_eq!(AbsPathBuf::new_test("/").as_str(), "C:/");
            assert_eq!(
                AbsPathBuf::new_test("/test/project").as_str(),
                "C:/test/project"
            );
        } else {
            assert_eq!(AbsPathBuf::new_test("/").as_str(), "/");
            assert_eq!(
                AbsPathBuf::new_test("/test/project").as_str(),
                "/test/project"
            );
        }
    }
}
