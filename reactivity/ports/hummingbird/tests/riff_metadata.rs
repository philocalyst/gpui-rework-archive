//! The vendored correction retains already-parsed metadata. Codec admission,
//! unknown-chunk handling and packet payloads continue through the real reader.
use std::{io::Cursor, sync::Arc};
use symphonia::core::{
    errors::Error,
    formats::{FormatOptions, FormatReader, probe::Hint},
    io::MediaSourceStream,
    meta::{
        METADATA_ID_NULL, MetadataBuilder, MetadataInfo, MetadataLog, MetadataOptions, RawTag,
        StandardTag, Tag,
    },
};
fn chunk(id: &[u8; 4], payload: &[u8]) -> Vec<u8> {
    let mut out = id.to_vec();
    out.extend_from_slice(&u32::try_from(payload.len()).unwrap().to_le_bytes());
    out.extend_from_slice(payload);
    if !payload.len().is_multiple_of(2) {
        out.push(0);
    }
    out
}
fn info(id: &[u8; 4], value: &[u8]) -> Vec<u8> {
    let mut out = b"INFO".to_vec();
    out.extend(chunk(id, value));
    chunk(b"LIST", &out)
}
fn wave(chunks: &[u8]) -> Vec<u8> {
    let base = include_bytes!("../assets/audio/stereo.wav");
    let mut out = base[..36].to_vec();
    out.extend_from_slice(chunks);
    out.extend_from_slice(&base[36..]);
    let size = u32::try_from(out.len() - 8).unwrap();
    out[4..8].copy_from_slice(&size.to_le_bytes());
    out
}
fn reader(bytes: Vec<u8>, options: FormatOptions) -> Result<Box<dyn FormatReader>, Error> {
    let mut hint = Hint::new();
    hint.with_extension("wav");
    symphonia::default::get_probe().probe(
        &hint,
        MediaSourceStream::new(Box::new(Cursor::new(bytes)), Default::default()),
        options,
        MetadataOptions::default(),
    )
}
fn packets(reader: &mut dyn FormatReader) -> Vec<u8> {
    let mut out = Vec::new();
    while let Some(packet) = reader.next_packet().unwrap() {
        out.extend_from_slice(&packet.data);
    }
    out
}
#[test]
fn external_then_multiple_info_revisions_survive_unknown_chunks_with_exact_pcm_payload() {
    let mut external = MetadataLog::default();
    let mut builder = MetadataBuilder::new(MetadataInfo {
        metadata: METADATA_ID_NULL,
        short_name: "test",
        long_name: "external fixture",
    });
    builder.add_tag(Tag::new_std(
        RawTag::new("title", "external"),
        StandardTag::TrackTitle(Arc::new("external".into())),
    ));
    external.push(builder.build());
    let mut options = FormatOptions::default();
    options.external_data.metadata = Some(external);
    let mut chunks = chunk(b"JUNK", b"odd");
    chunks.extend(info(b"INAM", b"local title\0"));
    chunks.extend(info(b"IART", b"local artist\0"));
    let mut tagged = reader(wave(&chunks), options).unwrap();
    let mut revisions = Vec::new();
    let mut metadata = tagged.metadata();
    loop {
        let Some(revision) = metadata.current() else {
            break;
        };
        revisions.push(
            revision
                .media
                .tags
                .iter()
                .filter_map(|tag| match &tag.std {
                    Some(StandardTag::TrackTitle(value)) => Some(("title", value.to_string())),
                    Some(StandardTag::Artist(value)) => Some(("artist", value.to_string())),
                    _ => None,
                })
                .collect::<Vec<_>>(),
        );
        if metadata.pop().is_none() {
            break;
        }
    }
    assert_eq!(
        revisions,
        [
            vec![("title", "external".into())],
            vec![("title", "local title\0".into())],
            vec![("artist", "local artist\0".into())]
        ]
    );
    let mut plain = reader(
        include_bytes!("../assets/audio/stereo.wav").to_vec(),
        FormatOptions::default(),
    )
    .unwrap();
    assert_eq!(
        format!("{:?}", tagged.tracks()),
        format!("{:?}", plain.tracks())
    );
    assert_eq!(packets(&mut *tagged), packets(&mut *plain));
}
#[test]
fn malformed_or_truncated_wave_headers_still_fail_before_a_reader_is_returned() {
    let mut truncated = wave(&info(b"INAM", b"title\0"));
    truncated.truncate(43);
    let mut wrong_form = wave(&[]);
    wrong_form[8..12].copy_from_slice(b"NOPE");
    let mut missing_format = wave(&[]);
    missing_format.drain(12..36);
    let size = u32::try_from(missing_format.len() - 8).unwrap();
    missing_format[4..8].copy_from_slice(&size.to_le_bytes());
    for bytes in [truncated, wrong_form, missing_format] {
        assert!(reader(bytes, FormatOptions::default()).is_err());
    }
}
