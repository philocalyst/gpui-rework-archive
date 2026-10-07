//! Fixed-schema binary transport. Floats retain their exact IEEE representation;
//! serde field names and enum names do not travel through the interpreter.
use crate::{Frame, MAX_FRAME_BYTES};
use bincode::Options;
use serde::{Serialize, de::DeserializeOwned};

fn options() -> impl Options {
    bincode::DefaultOptions::new()
        .with_fixint_encoding()
        .with_little_endian()
        .reject_trailing_bytes()
}
pub fn encode_value(value: &impl Serialize) -> Result<Vec<u8>, String> {
    struct Bounded(Vec<u8>);
    impl std::io::Write for Bounded {
        fn write(&mut self, bytes: &[u8]) -> std::io::Result<usize> {
            if bytes.len() > MAX_FRAME_BYTES.saturating_sub(self.0.len()) {
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
    let mut out = Bounded(Vec::with_capacity(1024));
    // No sizing pass: the bounded writer enforces the limit during the single
    // serialization walk. A preflight sizing pass doubles interpreted work.
    options()
        .serialize_into(&mut out, value)
        .map_err(|error| error.to_string())?;
    Ok(out.0)
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
pub fn decode(bytes: &[u8]) -> Result<Frame, String> {
    let frame: Frame = decode_value(bytes)?;
    frame.validate()?;
    Ok(frame)
}

#[cfg(test)]
mod tests {
    use super::*;
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
