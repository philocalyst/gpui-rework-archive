//! Fixed-schema binary transport. Floats retain their exact IEEE representation;
//! serde field names and enum names do not travel through the interpreter.
use crate::{Frame, MAX_FRAME_BYTES, MAX_INPUT_BYTES, PreviewContext};
use bincode::Options;
use serde::{Serialize, de::DeserializeOwned};
use std::io::Write;

struct Bounded<'a>(&'a mut Vec<u8>, usize);
impl Write for Bounded<'_> {
    fn write(&mut self, bytes: &[u8]) -> std::io::Result<usize> {
        if bytes.len() > self.1.saturating_sub(self.0.len()) {
            return Err(std::io::Error::other(
                "GPUI message exceeds transport budget",
            ));
        }
        self.0.extend_from_slice(bytes);
        Ok(bytes.len())
    }
    fn flush(&mut self) -> std::io::Result<()> {
        Ok(())
    }
}

fn options() -> impl Options {
    bincode::DefaultOptions::new()
        .with_fixint_encoding()
        .with_little_endian()
        .reject_trailing_bytes()
}
pub fn encode_value(value: &impl Serialize) -> Result<Vec<u8>, String> {
    encode_bounded(value, MAX_FRAME_BYTES)
}
pub fn encode_value_into(value: &impl Serialize, bytes: &mut Vec<u8>) -> Result<(), String> {
    encode_bounded_into(value, MAX_FRAME_BYTES, bytes)
}
pub fn encode_input(input: &PreviewContext) -> Result<Vec<u8>, String> {
    input.validate()?;
    encode_bounded(input, MAX_INPUT_BYTES)
}
fn encode_bounded(value: &impl Serialize, budget: usize) -> Result<Vec<u8>, String> {
    let mut bytes = Vec::with_capacity(1024);
    encode_bounded_into(value, budget, &mut bytes)?;
    Ok(bytes)
}
fn encode_bounded_into(value: &impl Serialize, budget: usize, bytes: &mut Vec<u8>) -> Result<(), String> {
    bytes.clear();
    let mut out = Bounded(bytes, budget);
    // No sizing pass: the bounded writer enforces the limit during the single
    // serialization walk. A preflight sizing pass doubles interpreted work.
    options()
        .serialize_into(&mut out, value)
        .map_err(|error| error.to_string())?;
    Ok(())
}
pub fn decode_value<T: DeserializeOwned>(bytes: &[u8]) -> Result<T, String> {
    if bytes.len() > MAX_FRAME_BYTES {
        return Err("GPUI message exceeds transport budget".into());
    }
    options()
        .with_limit(MAX_FRAME_BYTES as u64)
        .deserialize(bytes)
        .map_err(|error| error.to_string())
}
pub fn encode(frame: &Frame) -> Vec<u8> {
    encode_value(frame).expect("could not encode GPUI scene")
}
// Bincode's fixed-schema struct encoding is its fields in declaration order.
// Keep the expensive scene bytes across inputs that do not redraw GPUI. Every
// reply still contains a complete, ordinary Frame and freshly encoded metadata.
#[cfg(any(feature = "interpreter", test))]
pub(crate) fn encode_cached_scene_into(frame: &Frame, scene_bytes: &[u8], bytes: &mut Vec<u8>) -> Result<(), String> {
    let Frame {
        version,
        viewport,
        scale_factor,
        scene: _,
        cursor,
        text,
        next_frame_ms,
    } = frame;
    bytes.clear();
    bytes.reserve(scene_bytes.len().saturating_add(128).min(MAX_FRAME_BYTES));
    let mut out = Bounded(bytes, MAX_FRAME_BYTES);
    options()
        .serialize_into(&mut out, &(version, viewport, scale_factor))
        .map_err(|error| error.to_string())?;
    out.write_all(scene_bytes)
        .map_err(|error| error.to_string())?;
    options()
        .serialize_into(&mut out, &(next_frame_ms, cursor, text))
        .map_err(|error| error.to_string())?;
    Ok(())
}
pub fn decode(bytes: &[u8]) -> Result<Frame, String> {
    let frame: Frame = decode_value(bytes)?;
    frame.validate()?;
    Ok(frame)
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn cached_scene_is_identical_to_full_frame_encoding_with_fresh_metadata() {
        let mut scene = gpui::Scene::default();
        scene.finish();
        let scene = gpui::SceneCapture::capture(&scene, |_| anyhow::bail!("no tile")).unwrap();
        let mut frame = Frame {
            version: crate::PROTOCOL_VERSION,
            viewport: gpui::size(gpui::px(400.), gpui::px(300.)),
            scale_factor: 1.,
            scene,
            cursor: gpui::CursorStyle::Arrow,
            text: None,
            next_frame_ms: None,
        };
        let scene_bytes = encode_value(&frame.scene).unwrap();
        let mut cached = Vec::new();
        for cursor in [gpui::CursorStyle::Arrow, gpui::CursorStyle::IBeam] {
            frame.cursor = cursor;
            frame.next_frame_ms = Some(16);
            encode_cached_scene_into(&frame, &scene_bytes, &mut cached).unwrap();
            assert_eq!(cached, encode(&frame));
            assert_eq!(decode(&cached).unwrap().cursor, cursor);
        }
        assert!(encode_cached_scene_into(&frame, &vec![0; MAX_FRAME_BYTES], &mut cached).is_err());
        let capacity = cached.capacity();
        encode_cached_scene_into(&frame, &scene_bytes, &mut cached).unwrap();
        assert_eq!(cached, encode(&frame));
        assert_eq!(cached.capacity(), capacity, "Frame scratch capacity must survive reuse");
    }
    #[test]
    fn oversized_text_input_fails_before_entering_the_interpreter() {
        let mut input = PreviewContext::default();
        input
            .events
            .push(crate::InputMessage::Text(crate::TextEdit::Replace {
                range: None,
                text: "x".repeat(MAX_INPUT_BYTES),
            }));
        assert!(encode_input(&input).is_err());
        input.events.clear();
        assert!(encode_input(&input).is_ok());
    }
    #[test]
    fn floats_preserve_width_signed_zero_and_nan_payloads() {
        for value in [
            0.0f32,
            -0.0,
            1.25,
            f32::MAX,
            f32::INFINITY,
            f32::from_bits(0x7fc00123),
        ] {
            let bytes = encode_value(&value).unwrap();
            assert_eq!(bytes.len(), 4);
            let decoded: f32 = decode_value(&bytes).unwrap();
            assert_eq!(decoded.to_bits(), value.to_bits());
        }
        let value = 1.234567890123f64;
        let bytes = encode_value(&value).unwrap();
        assert_eq!(bytes.len(), 8);
        let decoded: f64 = decode_value(&bytes).unwrap();
        assert_eq!(decoded.to_bits(), value.to_bits());
    }
}
