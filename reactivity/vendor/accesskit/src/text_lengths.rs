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
    pub lengths: Box<[u8]>,
    pub overflows: Box<[u32]>,
}

#[cfg(feature = "serde")]
#[derive(serde::Deserialize)]
#[cfg_attr(feature = "schemars", derive(schemars::JsonSchema))]
#[serde(untagged)]
pub(super) enum SerializedCharacterLengths {
    Ordinary(Vec<u8>),
    Extended(Box<ExtendedCharacterLengths>),
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
    overflows: slice::Iter<'a, u32>,
}
impl<'a> DecodedCharacterLengths<'a> {
    fn new(value: &str, lengths: &'a [u8], overflows: &'a [u32]) -> Option<Self> {
        let result = Self {
            lengths: lengths.iter(),
            overflows: overflows.iter(),
        };
        let mut overflow = overflows.iter();
        let mut byte = 0usize;
        for &length in lengths {
            let length = if length == 0 {
                let &length = overflow.next()?;
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
        (byte == value.len() && overflow.next().is_none()).then_some(result)
    }
}
impl Iterator for DecodedCharacterLengths<'_> {
    type Item = usize;
    fn next(&mut self) -> Option<Self::Item> {
        match self.lengths.next()? {
            0 => self.overflows.next().and_then(|&n| usize::try_from(n).ok()),
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
            PropertyValue::ExtendedCharacterLengths(value) if !value.overflows.is_empty() => {
                &*value.overflows
            }
            PropertyValue::ExtendedCharacterLengths(_) => return None,
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
                overflows.push(length);
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
            PropertyValue::ExtendedCharacterLengths(Box::new(ExtendedCharacterLengths {
                lengths: bytes.into_boxed_slice(),
                overflows: overflows.into_boxed_slice(),
            }))
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
        assert_eq!(&*extended.overflows, &[256]);
        assert_eq!(size_of::<ExtendedCharacterLengths>(), 32);
        // These variants use no more storage than the original largest value.
        assert!(size_of::<Box<ExtendedCharacterLengths>>() <= size_of::<crate::Rect>());
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
            assert!(DecodedCharacterLengths::new(value, &bytes, &overflows).is_none());
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
        assert!(wire.contains("\"characterLengths\":{\"lengths\":[0],\"overflows\":[256]}"));
        let decoded: Node = serde_json::from_str(&wire).unwrap();
        assert_eq!(decoded, encoded);
        let invalid: Node = serde_json::from_str(&wire.replace("[256]", "[255]")).unwrap();
        assert!(invalid.decoded_character_lengths().is_none());
        assert!(
            schemars::schema_for!(Node)
                .to_value()
                .to_string()
                .contains("overflows")
        );
    }
}
