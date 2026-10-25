//! Bounded artifact IO and atomic directory replacement.
use super::*;

pub(super) fn artifact_path(root: &Path, relative: &str) -> Result<PathBuf> {
    let path = root
        .join(relative)
        .canonicalize()
        .with_context(|| format!("opening report artifact {relative}"))?;
    ensure!(
        path.starts_with(root),
        "report artifact escapes report directory: {relative}"
    );
    Ok(path)
}

pub(super) fn resolved_candidate(path: &Path) -> Result<PathBuf> {
    let absolute = if path.is_absolute() {
        path.to_path_buf()
    } else {
        std::env::current_dir()?.join(path)
    };
    let mut resolved = PathBuf::new();
    for component in absolute.components() {
        match component {
            Component::Prefix(prefix) => resolved.push(prefix.as_os_str()),
            Component::RootDir => resolved.push(component.as_os_str()),
            Component::CurDir => {}
            Component::ParentDir => {
                resolved.pop();
            }
            Component::Normal(part) => {
                let candidate = resolved.join(part);
                resolved = match fs::symlink_metadata(&candidate) {
                    Ok(_) => candidate.canonicalize()?,
                    Err(error) if error.kind() == std::io::ErrorKind::NotFound => candidate,
                    Err(error) => return Err(error.into()),
                };
            }
        }
    }
    Ok(resolved)
}

pub(super) fn publish_report(staged_report: &Path, target: &Path) -> Result<()> {
    let parent = target
        .parent()
        .context("report output must have a parent")?;
    if target.exists() {
        let backup_root = tempfile::Builder::new()
            .prefix(".gpui-report-backup-")
            .tempdir_in(parent)?;
        let backup = backup_root.path().join("previous");
        fs::rename(target, &backup)
            .with_context(|| format!("moving existing report {} aside", target.display()))?;
        if let Err(error) = fs::rename(staged_report, target) {
            let restore = fs::rename(&backup, target);
            if let Err(restore_error) = restore {
                let backup_location = backup.display().to_string();
                let _preserved_tempdir = backup_root.keep();
                anyhow::bail!(
                    "publishing report failed ({error}); restoring previous report also failed ({restore_error}); previous report preserved at {backup_location}"
                );
            }
            return Err(error)
                .with_context(|| format!("publishing report to {}", target.display()));
        }
        drop(backup_root);
    } else {
        fs::rename(staged_report, target)
            .with_context(|| format!("publishing report to {}", target.display()))?;
    }
    Ok(())
}

/// Compares two report directories. Any scenario/checkpoint addition, removal, metadata,
/// serialized-scene, or decoded pixel change is returned as a human-readable entry.
pub(super) fn save_png(path: &Path, image: &image::RgbaImage) -> Result<()> {
    image
        .save_with_format(path, image::ImageFormat::Png)
        .with_context(|| format!("writing {}", path.display()))
}

pub(super) fn read_image(path: &Path) -> Result<image::RgbaImage> {
    const MAX_RGBA_BYTES: u64 = 128 * 1024 * 1024;
    let mut reader = image::ImageReader::open(path)
        .with_context(|| format!("opening report image {}", path.display()))?;
    reader.set_format(image::ImageFormat::Png);
    let mut limits = image::Limits::default();
    limits.max_alloc = Some(MAX_RGBA_BYTES);
    reader.limits(limits);
    let decoded = reader
        .decode()
        .with_context(|| format!("decoding report image {}", path.display()))?;
    let (width, height) = (decoded.width(), decoded.height());
    ensure!(
        u64::from(width) * u64::from(height) * 4 <= MAX_RGBA_BYTES,
        "decoded RGBA image exceeds 128 MiB: {}",
        path.display()
    );
    Ok(decoded.to_rgba8())
}

pub(super) fn read_capture(path: &Path) -> Result<gpui::SceneCapture> {
    let capture: gpui::SceneCapture = serde_json::from_slice(&read_scene_json(path)?)
        .with_context(|| format!("parsing scene capture {}", path.display()))?;
    capture
        .validate()
        .with_context(|| format!("validating scene capture {}", path.display()))?;
    Ok(capture)
}

pub(super) fn gzip_scene_json(bytes: &[u8]) -> Result<Vec<u8>> {
    ensure!(
        bytes.len() <= MAX_DECOMPRESSED_SCENE_BYTES,
        "scene capture exceeds 12 MiB before compression"
    );
    let mut encoder = GzBuilder::new()
        .mtime(0)
        .write(Vec::new(), Compression::fast());
    encoder
        .write_all(bytes)
        .context("compressing scene capture")?;
    let compressed = encoder
        .finish()
        .context("finishing compressed scene capture")?;
    ensure!(
        compressed.len() as u64 <= MAX_COMPRESSED_SCENE_BYTES,
        "compressed scene capture exceeds 12 MiB"
    );
    Ok(compressed)
}

pub(super) fn read_scene_json(path: &Path) -> Result<Vec<u8>> {
    let compressed = path.extension().is_some_and(|extension| extension == "gz");
    let limit = if compressed {
        MAX_COMPRESSED_SCENE_BYTES
    } else {
        MAX_DECOMPRESSED_SCENE_BYTES as u64
    };
    if compressed {
        ensure!(
            path.metadata()?.len() <= limit,
            "compressed scene capture exceeds 12 MiB: {}",
            path.display()
        );
    } else {
        ensure!(
            path.metadata()?.len() <= limit,
            "scene capture exceeds 12 MiB: {}",
            path.display()
        );
    }
    let mut bounded_file = fs::File::open(path)
        .with_context(|| format!("reading {}", path.display()))?
        .take(limit + 1);
    let mut bytes = Vec::new();
    bounded_file
        .read_to_end(&mut bytes)
        .with_context(|| format!("reading {}", path.display()))?;
    ensure!(
        bytes.len() as u64 <= limit,
        "scene artifact exceeds 12 MiB: {}",
        path.display()
    );
    if compressed {
        ensure!(
            bytes.len() as u64 <= MAX_COMPRESSED_SCENE_BYTES,
            "compressed scene capture exceeds 12 MiB: {}",
            path.display()
        );
        let decoder = MultiGzDecoder::new(bytes.as_slice());
        let mut bounded = decoder.take((MAX_DECOMPRESSED_SCENE_BYTES + 1) as u64);
        let mut decoded = Vec::new();
        bounded
            .read_to_end(&mut decoded)
            .with_context(|| format!("decompressing scene capture {}", path.display()))?;
        ensure!(
            decoded.len() <= MAX_DECOMPRESSED_SCENE_BYTES,
            "decompressed scene capture exceeds 12 MiB: {}",
            path.display()
        );
        Ok(decoded)
    } else {
        Ok(bytes)
    }
}

pub(super) fn read_limited_file(path: &Path, max_bytes: u64) -> Result<Vec<u8>> {
    ensure!(
        path.metadata()?.len() <= max_bytes,
        "file exceeds {} MiB: {}",
        max_bytes / (1024 * 1024),
        path.display()
    );
    let mut file = fs::File::open(path)?.take(max_bytes + 1);
    let mut bytes = Vec::new();
    file.read_to_end(&mut bytes)?;
    ensure!(
        bytes.len() as u64 <= max_bytes,
        "file exceeds {} MiB: {}",
        max_bytes / (1024 * 1024),
        path.display()
    );
    Ok(bytes)
}
