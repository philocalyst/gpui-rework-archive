// Copyright 2026 The AccessKit Authors. All rights reserved.
// Licensed under Apache-2.0 OR MIT.
// Private coordinated AccessKit/consumer extension; see GPUI_PATCHES.md.
use super::{Node, PropertyId, PropertyValue};
use alloc::{boxed::Box, vec::Vec};
use core::slice;

#[derive(Clone, Debug, PartialEq)]
#[cfg_attr(feature = "serde", derive(serde::Serialize, serde::Deserialize))]
#[cfg_attr(feature = "schemars", derive(schemars::JsonSchema))]
#[cfg_attr(feature = "serde", serde(deny_unknown_fields))]
pub(super) struct ExtendedCharacterLengths {
    pub units: usize,
    pub data: Box<[u8]>,
}
impl ExtendedCharacterLengths {
    pub fn lengths(&self) -> &[u8] {
        self.data.get(..self.units).unwrap_or_default()
    }
}

#[cfg(feature = "serde")]
#[derive(serde::Deserialize)]
#[cfg_attr(feature = "schemars", derive(schemars::JsonSchema))]
#[serde(untagged)]
pub(super) enum SerializedCharacterLengths {
    Ordinary(Vec<u8>),
    Extended(ExtendedCharacterLengths),
}
#[cfg(feature = "serde")]
impl SerializedCharacterLengths {
    pub fn into_property(self) -> PropertyValue {
        match self {
            Self::Ordinary(value) => PropertyValue::LengthVec(value),
            Self::Extended(value) => PropertyValue::ExtendedCharacterLengths(value),
        }
    }
}

/// Borrowed, validated selectable-unit byte lengths. Raw character indices and
/// optional geometry arrays retain one entry per unit, including escaped units.
#[derive(Clone, Debug)]
pub struct DecodedCharacterLengths<'a> {
    lengths: slice::Iter<'a, u8>,
    overflows: &'a [u8],
}
impl<'a> DecodedCharacterLengths<'a> {
    fn new(value: &str, lengths: &'a [u8], overflows: &'a [u8]) -> Option<Self> {
        if overflows.len() % 4 != 0 {
            return None;
        }
        let result = Self {
            lengths: lengths.iter(),
            overflows,
        };
        let mut overflow = overflows;
        let mut byte = 0usize;
        for &length in lengths {
            let length = if length == 0 {
                let (encoded, rest) = overflow.split_first_chunk::<4>()?;
                overflow = rest;
                let length = u32::from_le_bytes(*encoded);
                if length <= u8::MAX.into() {
                    return None;
                }
                usize::try_from(length).ok()?
            } else {
                usize::from(length)
            };
            byte = byte.checked_add(length)?;
            if !value.is_char_boundary(byte) {
                return None;
            }
        }
        (byte == value.len() && overflow.is_empty()).then_some(result)
    }
}
impl Iterator for DecodedCharacterLengths<'_> {
    type Item = usize;
    fn next(&mut self) -> Option<Self::Item> {
        match self.lengths.next()? {
            0 => {
                let (encoded, rest) = self.overflows.split_first_chunk::<4>()?;
                self.overflows = rest;
                usize::try_from(u32::from_le_bytes(*encoded)).ok()
            }
            &n => Some(usize::from(n)),
        }
    }
    fn size_hint(&self) -> (usize, Option<usize>) {
        self.lengths.size_hint()
    }
}
impl ExactSizeIterator for DecodedCharacterLengths<'_> {}
impl core::iter::FusedIterator for DecodedCharacterLengths<'_> {}

impl Node {
    /// Decode and validate the private compact selectable-unit encoding.
    /// Returns None for malformed lengths, noncanonical escapes, excess or
    /// missing overflows, non-UTF-8 boundaries, and a mismatched value length.
    /// This also validates nodes deserialized from an untrusted snapshot.
    pub fn decoded_character_lengths(&self) -> Option<DecodedCharacterLengths<'_>> {
        let overflows = match self
            .properties
            .indices
            .get(&self.properties.values, PropertyId::CharacterLengths)
        {
            PropertyValue::ExtendedCharacterLengths(value) => {
                let overflows = value.data.get(value.units..)?;
                if overflows.is_empty() {
                    return None;
                }
                overflows
            }
            _ => &[],
        };
        DecodedCharacterLengths::new(self.value()?, self.character_lengths(), overflows)
    }

    /// Set whole selectable-unit byte lengths without truncating long units.
    /// The value must already be set. Invalid input leaves this node unchanged.
    /// Ordinary runs retain the original Vec<u8> representation; only escaped
    /// runs allocate the immutable overflow payload. This is a private schema
    /// extension and requires the matching AccessKit consumer fork.
    pub fn set_text_character_lengths(&mut self, lengths: impl IntoIterator<Item = u32>) -> bool {
        let mut bytes = Vec::new();
        let mut overflows = Vec::new();
        for length in lengths {
            if length == 0 {
                return false;
            }
            if let Ok(length) = u8::try_from(length) {
                bytes.push(length);
            } else {
                bytes.push(0);
                overflows.extend_from_slice(&length.to_le_bytes());
            }
        }
        if self
            .value()
            .and_then(|value| DecodedCharacterLengths::new(value, &bytes, &overflows))
            .is_none()
        {
            return false;
        }
        let value = if overflows.is_empty() {
            PropertyValue::LengthVec(bytes)
        } else {
            let units = bytes.len();
            // Append once, after the prefix is complete; never shift it at an
            // escape. Free the construction scratch after freezing one payload.
            bytes.extend_from_slice(&overflows);
            PropertyValue::ExtendedCharacterLengths(ExtendedCharacterLengths {
                units,
                data: bytes.into_boxed_slice(),
            })
        };
        self.properties.set(PropertyId::CharacterLengths, value);
        true
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::Role;
    use alloc::{format, string::ToString, vec};

    #[test]
    fn compact_boundaries_and_no_new_hot_header() {
        let a = format!("a{}", "\u{301}".repeat(127));
        let b = format!("é{}", "\u{301}".repeat(127));
        assert_eq!((a.len(), b.len()), (255, 256));
        let value = format!("x{a}y{b}\r\n");
        let mut node = Node::new(Role::TextRun);
        node.set_value(value);
        assert!(node.set_text_character_lengths([1, 255, 1, 256, 2]));
        assert_eq!(node.character_lengths(), &[1, 255, 1, 0, 2]);
        assert_eq!(
            node.decoded_character_lengths()
                .unwrap()
                .collect::<Vec<_>>(),
            [1, 255, 1, 256, 2]
        );
        let PropertyValue::ExtendedCharacterLengths(extended) = node
            .properties
            .indices
            .get(&node.properties.values, PropertyId::CharacterLengths)
        else {
            panic!()
        };
        assert_eq!(&extended.data[extended.units..], &256u32.to_le_bytes());
        assert_eq!(size_of::<ExtendedCharacterLengths>(), 24);
        // These variants use no more storage than the original largest value.
        assert!(size_of::<ExtendedCharacterLengths>() <= size_of::<crate::Rect>());
        std::println!(
            "codec_sizes Node={} PropertyValue={} Properties={} indices={} exception={}",
            size_of::<Node>(),
            size_of::<PropertyValue>(),
            size_of::<super::super::Properties>(),
            size_of::<super::super::PropertyIndices>(),
            size_of::<ExtendedCharacterLengths>()
        );
    }

    #[test]
    fn huge_unit_and_empty_terminal_run() {
        let value = format!("a{}", "\u{301}".repeat(4096));
        let mut node = Node::new(Role::TextRun);
        node.set_value(value.clone());
        assert!(node.set_text_character_lengths([value.len() as u32]));
        assert_eq!(node.character_lengths(), &[0]);
        assert_eq!(
            node.decoded_character_lengths()
                .unwrap()
                .collect::<Vec<_>>(),
            [8193]
        );
        assert!(!node.set_text_character_lengths([0]));
        assert_eq!(
            node.decoded_character_lengths()
                .unwrap()
                .collect::<Vec<_>>(),
            [8193]
        );
        node.set_value("");
        assert!(node.set_text_character_lengths([]));
        assert_eq!(node.decoded_character_lengths().unwrap().len(), 0);
    }

    #[test]
    fn malformed_encoding_is_rejected_without_panics() {
        let a = "a".repeat(256);
        for (value, bytes, overflows) in [
            (a.as_str(), vec![0], vec![]),
            (a.as_str(), vec![0], vec![255]),
            (a.as_str(), vec![0], vec![256, 256]),
            (a.as_str(), vec![255], vec![256]),
            ("é", vec![1, 1], vec![]),
            ("a", vec![2], vec![]),
            ("", vec![0], vec![u32::MAX]),
        ] {
            let tail = overflows
                .into_iter()
                .flat_map(u32::to_le_bytes)
                .collect::<Vec<_>>();
            assert!(DecodedCharacterLengths::new(value, &bytes, &tail).is_none());
        }
        let mut node = Node::new(Role::TextRun);
        node.set_value(a);
        for (units, data) in [
            (usize::MAX, vec![0, 0, 1, 0, 0]),
            (1, vec![0, 0, 1, 0]),
            (1, vec![0, 0, 1, 0, 0, 0]),
            (1, vec![0, 0, 1, 0, 0, 0, 1, 0, 0]),
            (0, vec![0, 1, 0, 0]),
            (1, vec![255]),
        ] {
            node.properties.set(
                PropertyId::CharacterLengths,
                PropertyValue::ExtendedCharacterLengths(ExtendedCharacterLengths {
                    units,
                    data: data.into_boxed_slice(),
                }),
            );
            assert!(node.decoded_character_lengths().is_none());
        }
    }

    #[cfg(feature = "schemars")]
    #[test]
    fn ordinary_wire_is_unchanged_and_extended_wire_roundtrips() {
        let mut ordinary = Node::new(Role::TextRun);
        ordinary.set_value("aé\r\n");
        ordinary.set_character_lengths([1, 2, 2]);
        let legacy = serde_json::to_string(&ordinary).unwrap();
        let mut encoded = Node::new(Role::TextRun);
        encoded.set_value("aé\r\n");
        assert!(encoded.set_text_character_lengths([1, 2, 2]));
        assert_eq!(serde_json::to_string(&encoded).unwrap(), legacy);
        assert!(legacy.contains("\"characterLengths\":[1,2,2]"));
        encoded.set_value("a".repeat(256));
        assert!(encoded.set_text_character_lengths([256]));
        let wire = serde_json::to_string(&encoded).unwrap();
        assert!(wire.contains("\"characterLengths\":{\"units\":1,\"data\":[0,0,1,0,0]}"));
        let decoded: Node = serde_json::from_str(&wire).unwrap();
        assert_eq!(decoded, encoded);
        let invalid: Node =
            serde_json::from_str(&wire.replace("[0,0,1,0,0]", "[0,255,0,0,0]")).unwrap();
        assert!(invalid.decoded_character_lengths().is_none());
        assert!(
            schemars::schema_for!(Node)
                .to_value()
                .to_string()
                .contains("units")
        );
    }
}
