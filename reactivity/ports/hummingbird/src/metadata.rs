//! Library metadata inspection uses the existing Symphonia format registry.
//! No decoder, PCM buffer, artwork processing or playback intent is created.
use crate::search::SourceError;
use std::{fs::File, path::Path, sync::Arc};
use symphonia::core::{
    common::Limit,
    formats::{
        FormatOptions, TrackType,
        probe::{Hint, Probe},
    },
    io::MediaSourceStream,
    meta::{MetadataOptions, StandardTag},
    units::Timestamp,
};

#[derive(Debug, Default, PartialEq, Eq)]
pub(crate) struct Metadata {
    pub title: Option<Arc<String>>,
    pub title_sort: Option<Arc<String>>,
    pub artists: Vec<Arc<String>>,
    pub artist_sort: Option<Arc<String>>,
    pub album: Option<Arc<String>>,
    pub album_artists: Vec<Arc<String>>,
    pub album_artist_sort: Option<Arc<String>>,
    pub track_number: Option<i64>,
    pub disc_number: Option<i64>,
    pub duration_ms: i64,
}

pub(crate) fn supported(path: &Path) -> bool {
    path.extension()
        .and_then(|value| value.to_str())
        .is_some_and(|value| {
            ["wav", "flac", "mp3"]
                .iter()
                .any(|extension| value.eq_ignore_ascii_case(extension))
        })
}

/// One scanner-owned registry, reused for every file. The playback registry's
/// enabled formats and metadata admission stay independent of index-only ID3.
pub(crate) fn probe() -> Probe {
    let mut probe = Probe::default();
    symphonia::default::register_enabled_formats(&mut probe);
    probe.register_metadata::<symphonia_metadata::id3v2::Id3v2Reader<'_>>();
    probe
}

pub(crate) fn read(probe: &Probe, path: &Path) -> Result<Metadata, SourceError> {
    let file = File::open(path).map_err(|error| SourceError::Io {
        path: path.into(),
        error,
    })?;
    let mut hint = Hint::new();
    if let Some(extension) = path.extension().and_then(|value| value.to_str()) {
        hint.with_extension(extension);
    }
    let stream = MediaSourceStream::new(Box::new(file), Default::default());
    let mut format = probe
        .probe(
            &hint,
            stream,
            FormatOptions::default(),
            MetadataOptions::default().limit_visual_bytes(Limit::Maximum(0)),
        )
        .map_err(|error| SourceError::Metadata {
            path: path.into(),
            error,
        })?;
    let track = format
        .first_track_known_codec(TrackType::Audio)
        .ok_or_else(|| SourceError::NoAudioTrack(path.into()))?;
    let track_id = u64::from(track.id);
    let duration = track
        .num_frames
        .zip(track.time_base)
        .and_then(|(frames, base)| {
            i64::try_from(frames)
                .ok()
                .and_then(|frames| base.calc_time(Timestamp::new(frames)))
        })
        .map(|time| time.as_secs_f64() * 1000.);
    let mut result = Metadata {
        duration_ms: duration
            .filter(|time| time.is_finite() && *time >= 0. && *time <= i64::MAX as f64)
            .map_or(0, |time| time as i64),
        ..Metadata::default()
    };
    let mut metadata = format.metadata();
    loop {
        let Some(revision) = metadata.current() else {
            break;
        };
        for tag in revision.media.tags.iter().chain(
            revision
                .per_track
                .iter()
                .filter(|track| track.track_id == track_id)
                .flat_map(|track| &track.metadata.tags),
        ) {
            let Some(tag) = &tag.std else { continue };
            match tag {
                StandardTag::TrackTitle(value) => set_option(&mut result.title, value),
                StandardTag::SortTrackTitle(value) => set_option(&mut result.title_sort, value),
                StandardTag::Artist(value) => append(&mut result.artists, value),
                StandardTag::SortArtist(value) => set_option(&mut result.artist_sort, value),
                StandardTag::Album(value) => set_option(&mut result.album, value),
                StandardTag::AlbumArtist(value) => append(&mut result.album_artists, value),
                StandardTag::SortAlbumArtist(value) => {
                    set_option(&mut result.album_artist_sort, value)
                }
                StandardTag::TrackNumber(number) => {
                    result.track_number = Some(
                        i64::try_from(*number)
                            .map_err(|_| SourceError::InvalidMetadataNumber(path.into()))?,
                    );
                }
                StandardTag::DiscNumber(number) => {
                    result.disc_number = Some(
                        i64::try_from(*number)
                            .map_err(|_| SourceError::InvalidMetadataNumber(path.into()))?,
                    );
                }
                _ => {}
            }
        }
        if metadata.pop().is_none() {
            break;
        }
    }
    Ok(result)
}
// Retain the metadata reader's existing shared strings. No per-tag String or
// Arc allocation is introduced; whitespace is removed when binding SQLite.
fn set_option(output: &mut Option<Arc<String>>, value: &Arc<String>) {
    if !clean(value).is_empty() {
        *output = Some(value.clone());
    }
}
fn append(output: &mut Vec<Arc<String>>, value: &Arc<String>) {
    if !clean(value).is_empty() && !output.iter().any(|current| clean(current) == clean(value)) {
        output.push(value.clone());
    }
}

/// Container padding/terminators are borrowed away at the SQL boundary, while
/// retaining the reader's original Arc. Interior content stays unchanged.
pub(crate) fn clean(value: &str) -> &str {
    value.trim_matches(|character: char| character == '\0' || character.is_whitespace())
}
