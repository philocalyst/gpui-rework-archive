use crate::ResultExt;
use anyhow::{Result, bail};
use async_fs as fs;
use futures_lite::StreamExt;
use std::path::{Path, PathBuf};

/// Removes matching direct children of `dir`.
///
/// The predicate is called on each entry's path. Matching files are removed;
/// matching directories are removed recursively. Read and removal failures are logged
/// and skipped; metadata failures are skipped. This function does not report whether every
/// requested removal succeeded.
pub async fn remove_matching<F>(dir: &Path, predicate: F)
where
    F: Fn(&Path) -> bool,
{
    if let Some(mut entries) = fs::read_dir(dir).await.log_err() {
        while let Some(entry) = entries.next().await {
            if let Some(entry) = entry.log_err() {
                let entry_path = entry.path();
                if predicate(entry_path.as_path())
                    && let Ok(metadata) = fs::metadata(&entry_path).await
                {
                    if metadata.is_file() {
                        fs::remove_file(&entry_path).await.log_err();
                    } else {
                        fs::remove_dir_all(&entry_path).await.log_err();
                    }
                }
            }
        }
    }
}

/// Collects matching direct children of `dir`.
///
/// The predicate is called on each entry's path. Read-directory and per-entry
/// errors are logged and skipped; an empty vector therefore does not
/// distinguish an empty directory from a read failure.
pub async fn collect_matching<F>(dir: &Path, predicate: F) -> Vec<PathBuf>
where
    F: Fn(&Path) -> bool,
{
    let mut matching = vec![];

    if let Some(mut entries) = fs::read_dir(dir).await.log_err() {
        while let Some(entry) = entries.next().await {
            if let Some(entry) = entry.log_err()
                && predicate(entry.path().as_path())
            {
                matching.push(entry.path());
            }
        }
    }

    matching
}

/// Finds the first direct child whose filename satisfies `predicate`.
///
/// Directory iteration order is filesystem-defined. Non-UTF-8 file names are
/// passed to the predicate using their lossy string representation. Read
/// errors are logged and treated like no match.
pub async fn find_file_name_in_dir<F>(dir: &Path, predicate: F) -> Option<PathBuf>
where
    F: Fn(&str) -> bool,
{
    if let Some(mut entries) = fs::read_dir(dir).await.log_err() {
        while let Some(entry) = entries.next().await {
            if let Some(entry) = entry.log_err() {
                let entry_path = entry.path();

                if let Some(file_name) = entry_path
                    .file_name()
                    .map(|file_name| file_name.to_string_lossy())
                    && predicate(&file_name)
                {
                    return Some(entry_path);
                }
            }
        }
    }

    None
}

/// Moves each direct child of `source_path` into an existing target directory.
///
/// The target directory must already exist. Each move uses filesystem rename,
/// so crossing filesystems can fail; failures return immediately and may leave
/// earlier entries moved. On success, the now-empty source directory is
/// removed. Existing target entries may be replaced according to the platform's
/// rename behavior.
pub async fn move_folder_files_to_folder<P: AsRef<Path>>(
    source_path: P,
    target_path: P,
) -> Result<()> {
    if !target_path.as_ref().is_dir() {
        bail!("Folder not found or is not a directory");
    }

    let mut entries = fs::read_dir(source_path.as_ref()).await?;
    while let Some(entry) = entries.next().await {
        let entry = entry?;
        let old_path = entry.path();
        let new_path = target_path.as_ref().join(entry.file_name());

        fs::rename(&old_path, &new_path).await?;
    }

    fs::remove_dir(source_path).await?;

    Ok(())
}

#[cfg(unix)]
/// Sets the file mode to `0o755` on Unix, replacing its existing permission bits.
///
pub async fn make_file_executable(path: &Path) -> std::io::Result<()> {
    fs::set_permissions(
        path,
        <fs::Permissions as fs::unix::PermissionsExt>::from_mode(0o755),
    )
    .await
}

#[cfg(not(unix))]
#[allow(clippy::unused_async)]
/// Does nothing on non-Unix targets and returns success.
pub async fn make_file_executable(_path: &Path) -> std::io::Result<()> {
    Ok(())
}
