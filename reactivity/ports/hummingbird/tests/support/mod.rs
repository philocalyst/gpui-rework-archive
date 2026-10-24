use std::{
    fs,
    path::{Path, PathBuf},
    sync::atomic::{AtomicU64, Ordering},
};
static NEXT: AtomicU64 = AtomicU64::new(0);
pub struct Folder(pub PathBuf);
impl Folder {
    pub fn new() -> Self {
        let path = std::env::temp_dir().join(format!(
            "hummingbird-index-{}-{}",
            std::process::id(),
            NEXT.fetch_add(1, Ordering::Relaxed)
        ));
        fs::create_dir(&path).unwrap();
        Self(path)
    }
}
impl Drop for Folder {
    fn drop(&mut self) {
        fs::remove_dir_all(&self.0).unwrap();
    }
}
fn source(extension: &str) -> Vec<u8> {
    fs::read(Path::new(env!("CARGO_MANIFEST_DIR")).join(format!("assets/audio/stereo.{extension}")))
        .unwrap()
}
pub fn wave(path: &Path, title: &str, artist: &str, album: &str) {
    let source = source("wav");
    assert_eq!(&source[36..40], b"data");
    let mut info = b"INFO".to_vec();
    for (name, value) in [(b"INAM", title), (b"IART", artist), (b"IPRD", album)] {
        info.extend_from_slice(name);
        info.extend_from_slice(&(u32::try_from(value.len() + 1).unwrap()).to_le_bytes());
        info.extend_from_slice(value.as_bytes());
        info.push(0);
        if !info.len().is_multiple_of(2) {
            info.push(0);
        }
    }
    let mut output = source[..36].to_vec();
    output.extend_from_slice(b"LIST");
    output.extend_from_slice(&(u32::try_from(info.len()).unwrap()).to_le_bytes());
    output.extend(info);
    output.extend_from_slice(&source[36..]);
    let size = u32::try_from(output.len() - 8).unwrap();
    output[4..8].copy_from_slice(&size.to_le_bytes());
    fs::write(path, output).unwrap();
}
pub fn flac(path: &Path, title: &str, artist: &str, album: &str) {
    let source = source("flac");
    assert_eq!(&source[..4], b"fLaC");
    let mut cursor = 4;
    let mut output = source[..4].to_vec();
    loop {
        let kind = source[cursor];
        let length = (usize::from(source[cursor + 1]) << 16)
            | (usize::from(source[cursor + 2]) << 8)
            | usize::from(source[cursor + 3]);
        if kind & 0x7f != 4 {
            output.push(kind & 0x7f);
            output.extend_from_slice(&source[cursor + 1..cursor + 4 + length]);
        }
        cursor += 4 + length;
        if kind & 0x80 != 0 {
            break;
        }
    }
    let mut comment = Vec::new();
    comment.extend_from_slice(&4u32.to_le_bytes());
    comment.extend_from_slice(b"GPUI");
    comment.extend_from_slice(&5u32.to_le_bytes());
    for value in [
        format!("TITLE={title}"),
        format!("ARTIST={artist}"),
        format!("ALBUM={album}"),
        "TRACKNUMBER=2".into(),
        "DISCNUMBER=1".into(),
    ] {
        comment.extend_from_slice(&(u32::try_from(value.len()).unwrap()).to_le_bytes());
        comment.extend(value.bytes());
    }
    let length = u32::try_from(comment.len()).unwrap();
    assert!(length < 1 << 24);
    output.push(0x84);
    output.extend_from_slice(&length.to_be_bytes()[1..]);
    output.extend(comment);
    output.extend_from_slice(&source[cursor..]);
    fs::write(path, output).unwrap();
}
fn syncsafe(size: usize) -> [u8; 4] {
    assert!(size < 1 << 28);
    [
        (size >> 21) as u8 & 0x7f,
        (size >> 14) as u8 & 0x7f,
        (size >> 7) as u8 & 0x7f,
        size as u8 & 0x7f,
    ]
}
pub fn mp3(path: &Path, title: &str, artist: &str, album: &str) {
    let source = source("mp3");
    let start = if &source[..3] == b"ID3" {
        10 + (usize::from(source[6]) << 21)
            + (usize::from(source[7]) << 14)
            + (usize::from(source[8]) << 7)
            + usize::from(source[9])
    } else {
        0
    };
    let mut frames = Vec::new();
    for (name, value) in [
        (b"TIT2", title),
        (b"TPE1", artist),
        (b"TALB", album),
        (b"TRCK", "3"),
        (b"TPOS", "1"),
    ] {
        frames.extend_from_slice(name);
        frames.extend_from_slice(&syncsafe(value.len() + 1));
        frames.extend_from_slice(&[0, 0, 3]);
        frames.extend(value.bytes());
    }
    let mut output = b"ID3\x04\0\0".to_vec();
    output.extend_from_slice(&syncsafe(frames.len()));
    output.extend(frames);
    output.extend_from_slice(&source[start..]);
    fs::write(path, output).unwrap();
}
