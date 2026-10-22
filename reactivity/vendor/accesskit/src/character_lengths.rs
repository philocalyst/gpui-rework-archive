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
        let result = Self { lengths: lengths.iter(), overflows: overflows.iter() };
        let mut overflow = overflows.iter();
        let mut byte = 0usize;
        for &length in lengths {
            let length = if length == 0 {
                let &length = overflow.next()?;
                if length <= u8::MAX.into() { return None; }
                usize::try_from(length).ok()?
            } else {
                usize::from(length)
            };
            byte = byte.checked_add(length)?;
            if !value.is_char_boundary(byte) { return None; }
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
    fn size_hint(&self) -> (usize, Option<usize>) { self.lengths.size_hint() }
}
impl ExactSizeIterator for DecodedCharacterLengths<'_> {}
impl core::iter::FusedIterator for DecodedCharacterLengths<'_> {}

impl Node {
    /// Decode and validate the private compact selectable-unit encoding.
    /// Returns None for malformed lengths, noncanonical escapes, excess or
    /// missing overflows, non-UTF-8 boundaries, and a mismatched value length.
    /// This also validates nodes deserialized from an untrusted snapshot.
    pub fn decoded_character_lengths(&self) -> Option<DecodedCharacterLengths<'_>> {
        let overflows = match self.properties.indices.get(&self.properties.values, PropertyId::CharacterLengths) {
            PropertyValue::ExtendedCharacterLengths(value) => &*value.overflows,
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
            if length == 0 { return false; }
            if let Ok(length) = u8::try_from(length) {
                bytes.push(length);
            } else {
                bytes.push(0);
                overflows.push(length);
            }
        }
        if self.value().and_then(|value| DecodedCharacterLengths::new(value, &bytes, &overflows)).is_none() {
            return false;
        }
        let value = if overflows.is_empty() {
            PropertyValue::LengthVec(bytes)
        } else {
            PropertyValue::ExtendedCharacterLengths(Box::new(ExtendedCharacterLengths {
                lengths: bytes.into_boxed_slice(), overflows: overflows.into_boxed_slice(),
            }))
        };
        self.properties.set(PropertyId::CharacterLengths, value);
        true
    }
}
