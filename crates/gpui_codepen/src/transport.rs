//! Binary browser replies use the same scene codec as the native interpreter.
//! This envelope is independent of HTTP and checks its version and all lengths.
use crate::session::{FailureKind, Reply};
use gpui_codepen_guest::{MAX_FRAME_BYTES, wire};

pub const CONTENT_TYPE: &str = "application/vnd.gpui.codepen-frame;version=4";
const MAGIC: &[u8; 8] = b"GPUIREP4";
const MAX_DIAGNOSTICS: usize = 64 * 1024;

pub fn encode(reply: &Reply) -> Vec<u8> {
    let frame = reply.frame.as_ref().map(wire::encode).unwrap_or_default();
    let diagnostics = reply.diagnostics.as_bytes();
    let mut out = Vec::with_capacity(32 + diagnostics.len() + frame.len());
    out.extend_from_slice(MAGIC);
    out.extend_from_slice(&reply.generation.to_le_bytes());
    out.extend_from_slice(&reply.elapsed_ms.to_le_bytes());
    let failure = match reply.failure {
        None => 0, Some(FailureKind::Rust) => 1, Some(FailureKind::Unavailable) => 2,
    };
    out.extend_from_slice(&((diagnostics.len() as u32) | (failure << 24)).to_le_bytes());
    out.extend_from_slice(&(frame.len() as u32).to_le_bytes());
    out.extend_from_slice(diagnostics);
    out.extend(frame);
    out
}

/// The embedded scene decoder validates once, before a reply can be committed.
pub fn decode(bytes: &[u8]) -> Result<Reply, String> {
    if bytes.len() < 32 || &bytes[..8] != MAGIC {
        return Err("unsupported browser reply protocol".into());
    }
    let generation = u64::from_le_bytes(bytes[8..16].try_into().unwrap());
    let elapsed_ms = u64::from_le_bytes(bytes[16..24].try_into().unwrap());
    let diagnostics_header = u32::from_le_bytes(bytes[24..28].try_into().unwrap());
    let failure = match diagnostics_header >> 24 {
        0 => None, 1 => Some(FailureKind::Rust), 2 => Some(FailureKind::Unavailable),
        _ => return Err("unsupported browser reply failure kind".into()),
    };
    let diagnostics_len = (diagnostics_header & 0x00ff_ffff) as usize;
    let frame_len = u32::from_le_bytes(bytes[28..32].try_into().unwrap()) as usize;
    if diagnostics_len > MAX_DIAGNOSTICS
        || frame_len > MAX_FRAME_BYTES
        || bytes.len() != 32 + diagnostics_len + frame_len
    {
        return Err("invalid browser reply length".into());
    }
    let diagnostics = std::str::from_utf8(&bytes[32..32 + diagnostics_len])
        .map_err(|e| e.to_string())?
        .to_owned();
    let frame = if frame_len == 0 {
        None
    } else {
        Some(wire::decode(&bytes[32 + diagnostics_len..])?)
    };
    Ok(Reply {
        generation,
        elapsed_ms,
        diagnostics,
        failure,
        frame,
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui_codepen_guest::{Frame, PROTOCOL_VERSION};
    use gpui::{Scene, SceneCapture, px, size};
    #[test]
    fn browser_replies_preserve_frames_errors_and_reject_truncation() {
        for frame in [
            None,
            Some(Frame {
                cursor:Default::default(),text:None,
                next_frame_ms: None,
            version: PROTOCOL_VERSION,
                viewport: size(px(320.),px(240.)),
                scale_factor: 1.,
                scene: {let mut scene=Scene::default();scene.finish();SceneCapture::capture(&scene,|_|unreachable!()).unwrap()},
            }),
        ] {
            let reply = Reply {
                generation: 8,
                elapsed_ms: 23,
                diagnostics: "a diagnostic 🌿".into(),
                failure: Some(FailureKind::Unavailable),
                frame,
            };
            let bytes = encode(&reply);
            let decoded = decode(&bytes).unwrap();
            assert_eq!(decoded.generation, reply.generation);
            assert_eq!(decoded.elapsed_ms, reply.elapsed_ms);
            assert_eq!(decoded.diagnostics, reply.diagnostics);
            assert_eq!(decoded.failure, reply.failure);
            assert_eq!(decoded.frame, reply.frame);
            for length in 0..bytes.len() {
                assert!(decode(&bytes[..length]).is_err());
            }
            let mut trailing = bytes;
            trailing.push(0);
            assert!(decode(&trailing).is_err());
        }
        for failure in [None, Some(FailureKind::Rust), Some(FailureKind::Unavailable)] {
            let bytes = encode(&Reply { generation: 1, elapsed_ms: 0, frame: None,
                diagnostics: "service or source error".into(), failure });
            assert_eq!(decode(&bytes).unwrap().failure, failure);
            let mut invalid = bytes;
            invalid[27] = 3;
            assert!(decode(&invalid).is_err());
        }
    }
}
