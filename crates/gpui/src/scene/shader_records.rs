//! Binary snapshots reuse GPUI's existing fixed-size shader records. Human
//! snapshots keep their named fields. Enum discriminants are checked before a
//! received record can become a Rust value; geometry validation follows capture
//! decoding, before any renderer consumes it.
use super::*;
use serde::{Deserialize, Serialize};
use std::mem::{align_of, offset_of, size_of};
use crate::{BackgroundTag, ColorSpace, LinearColorStop};

// Check each field's type, offset, and width, including nested records. A new
// field, a changed field type, or implicit padding must fail compilation rather
// than silently changing the byte-copy contract.
macro_rules! words {
    ($ty:ty; $($field:tt: $field_ty:ty),+ $(,)?) => {
        const _: () = {
            let mut offset = 0;
            $(
                let _: fn(&$ty) -> &$field_ty = |record| &record.$field;
                assert!(offset_of!($ty, $field) == offset);
                assert!(align_of::<$field_ty>() == 4);
                offset += size_of::<$field_ty>();
            )+
            assert!(size_of::<$ty>() == offset && align_of::<$ty>() == 4);
        };
    };
}
words!(ScaledPixels; 0: f32);
words!(DevicePixels; 0: i32);
words!(TileId; 0: u32);
words!(Point<ScaledPixels>; x: ScaledPixels, y: ScaledPixels);
words!(Point<DevicePixels>; x: DevicePixels, y: DevicePixels);
words!(Size<ScaledPixels>; width: ScaledPixels, height: ScaledPixels);
words!(Size<DevicePixels>; width: DevicePixels, height: DevicePixels);
words!(Bounds<ScaledPixels>; origin: Point<ScaledPixels>, size: Size<ScaledPixels>);
words!(Bounds<DevicePixels>; origin: Point<DevicePixels>, size: Size<DevicePixels>);
words!(Edges<ScaledPixels>; top: ScaledPixels, right: ScaledPixels, bottom: ScaledPixels, left: ScaledPixels);
words!(Corners<ScaledPixels>; top_left: ScaledPixels, top_right: ScaledPixels, bottom_right: ScaledPixels, bottom_left: ScaledPixels);
words!(ContentMask<ScaledPixels>; bounds: Bounds<ScaledPixels>, fade_out: Edges<ScaledPixels>);
words!(SceneHsla; h: f32, s: f32, l: f32, a: f32);
words!(LinearColorStop; color: SceneHsla, percentage: f32);
words!(Background; tag: BackgroundTag, color_space: ColorSpace, solid: SceneHsla,
    gradient_angle_or_pattern_height: f32, colors: [LinearColorStop; 2], padding: u32);
words!(AtlasTextureId; index: u32, kind: AtlasTextureKind);
words!(AtlasTile; texture_id: AtlasTextureId, tile_id: TileId, padding: u32, bounds: Bounds<DevicePixels>);
words!(TransformationMatrix; rotation_scale: [[f32; 2]; 2], translation: [f32; 2]);
words!(Quad; order: DrawOrder, border_style: BorderStyle, border_dashed_length: f32,
    border_dashed_gap: f32, bounds: Bounds<ScaledPixels>, content_mask: ContentMask<ScaledPixels>,
    background: Background, border_color: Background, corner_radii: Corners<ScaledPixels>,
    border_widths: Edges<ScaledPixels>, corner_smoothing: f32, padding: u32);
words!(Shadow; order: DrawOrder, blur_radius: ScaledPixels, bounds: Bounds<ScaledPixels>,
    corner_radii: Corners<ScaledPixels>, content_mask: ContentMask<ScaledPixels>, color: Background,
    element_bounds: Bounds<ScaledPixels>, element_corner_radii: Corners<ScaledPixels>,
    inset: ShaderBool, corner_smoothing: f32);
words!(Underline; order: DrawOrder, padding: u32, bounds: Bounds<ScaledPixels>,
    content_mask: ContentMask<ScaledPixels>, color: SceneHsla, thickness: ScaledPixels, wavy: ShaderBool);
words!(MonochromeSprite; order: DrawOrder, padding: u32, bounds: Bounds<ScaledPixels>,
    content_mask: ContentMask<ScaledPixels>, color: SceneHsla, tile: AtlasTile, transformation: TransformationMatrix);
words!(SubpixelSprite; order: DrawOrder, padding: u32, bounds: Bounds<ScaledPixels>,
    content_mask: ContentMask<ScaledPixels>, color: SceneHsla, tile: AtlasTile, transformation: TransformationMatrix);
words!(PolychromeSprite; order: DrawOrder, grayscale: ShaderBool, opacity: f32, corner_smoothing: f32,
    bounds: Bounds<ScaledPixels>, content_mask: ContentMask<ScaledPixels>,
    corner_radii: Corners<ScaledPixels>, tile: AtlasTile);

// SAFETY: implementations are closed to this module. These repr(C) records are
// entirely 4-byte f32/u32/i32 words, including explicitly initialized padding.
// The asserted sizes equal the sum of their fields, so there is no implicit
// padding. Every restricted bit pattern is checked before reading a value.
pub(super) unsafe trait Record: Copy + Serialize + for<'de> Deserialize<'de> {
    fn valid(bytes: &[u8]) -> bool;
}
fn word(bytes: &[u8], offset: usize) -> u32 {
    u32::from_le_bytes(bytes[offset..offset + 4].try_into().unwrap())
}
fn background(bytes: &[u8], offset: usize) -> bool {
    word(bytes, offset + offset_of!(Background, tag)) <= 3
        && word(bytes, offset + offset_of!(Background, color_space)) <= 1
}
fn tile(bytes: &[u8], offset: usize) -> bool {
    word(
        bytes,
        offset + offset_of!(AtlasTile, texture_id) + offset_of!(AtlasTextureId, kind),
    ) <= 2
}
macro_rules! record {
    ($ty:ty,$size:expr,$valid:expr) => {
        const _: () = assert!(size_of::<$ty>() == $size && align_of::<$ty>() == 4);
        // SAFETY: field layout is audited above; the validator checks all enums.
        unsafe impl Record for $ty {
            fn valid(bytes: &[u8]) -> bool {
                ($valid)(bytes)
            }
        }
    };
}
record!(Quad, 248, |b: &[u8]| word(
    b,
    offset_of!(Quad, border_style)
) <= 1
    && background(b, offset_of!(Quad, background))
    && background(b, offset_of!(Quad, border_color)));
record!(Shadow, 184, |b: &[u8]| background(
    b,
    offset_of!(Shadow, color)
) && word(
    b,
    offset_of!(Shadow, inset)
) <= 1);
record!(Underline, 80, |b: &[u8]| word(
    b,
    offset_of!(Underline, wavy)
) <= 1);
record!(MonochromeSprite, 128, |b: &[u8]| tile(
    b,
    offset_of!(MonochromeSprite, tile)
));
record!(SubpixelSprite, 128, |b: &[u8]| tile(
    b,
    offset_of!(SubpixelSprite, tile)
));
record!(PolychromeSprite, 112, |b: &[u8]| tile(
    b,
    offset_of!(PolychromeSprite, tile)
) && word(
    b,
    offset_of!(PolychromeSprite, grayscale)
) <= 1);

pub(super) fn serialize<T: Record, S: serde::Serializer>(
    records: &Vec<T>,
    serializer: S,
) -> Result<S::Ok, S::Error> {
    if serializer.is_human_readable() {
        return records.serialize(serializer);
    }
    // SAFETY: Record guarantees every byte is initialized. The borrow has the
    // same lifetime as records; serialization never changes their memory.
    let bytes = unsafe {
        std::slice::from_raw_parts(
            records.as_ptr().cast::<u8>(),
            std::mem::size_of_val(records.as_slice()),
        )
    };
    #[cfg(target_endian = "little")]
    {
        serializer.serialize_bytes(bytes)
    }
    #[cfg(target_endian = "big")]
    {
        let bytes = bytes
            .chunks_exact(4)
            .flat_map(|word| word.iter().rev().copied())
            .collect::<Vec<_>>();
        serializer.serialize_bytes(&bytes)
    }
}
pub(super) fn deserialize<'de, T: Record, D: serde::Deserializer<'de>>(
    deserializer: D,
) -> Result<Vec<T>, D::Error> {
    if deserializer.is_human_readable() {
        return Vec::<T>::deserialize(deserializer);
    }
    let bytes = serde_bytes::ByteBuf::deserialize(deserializer)?;
    if bytes.len() % size_of::<T>() != 0 {
        return Err(serde::de::Error::custom("truncated shader record"));
    }
    let mut records = Vec::with_capacity(bytes.len() / size_of::<T>());
    for bytes in bytes.chunks_exact(size_of::<T>()) {
        if !T::valid(bytes) {
            return Err(serde::de::Error::custom(
                "invalid shader record discriminant",
            ));
        }
        #[cfg(target_endian = "big")]
        let native = bytes
            .chunks_exact(4)
            .flat_map(|word| word.iter().rev().copied())
            .collect::<Vec<_>>();
        #[cfg(target_endian = "big")]
        let bytes = native.as_slice();
        // SAFETY: the complete record has the correct size; its enum values were
        // checked and every other field accepts all bit patterns. ByteBuf has no
        // alignment guarantee, so use read_unaligned. T is Copy and owns no data.
        records.push(unsafe { std::ptr::read_unaligned(bytes.as_ptr().cast::<T>()) });
    }
    Ok(records)
}

#[cfg(test)]
mod tests {
    use super::*;
    #[derive(Serialize, Deserialize)]
    #[serde(bound(serialize = "T: Record", deserialize = "T: Record"))]
    struct Records<T> {
        #[serde(with = "super")]
        records: Vec<T>,
    }
    fn exercise<T: Record + PartialEq + std::fmt::Debug>(record: T, enums: &[usize]) {
        let value = Records { records: vec![record, record] };
        let bytes = bincode::serialize(&value).unwrap();
        assert_eq!(bytes.len(), 8 + 2 * size_of::<T>());
        let decoded: Records<T> = bincode::deserialize(&bytes).unwrap();
        assert_eq!(value.records, decoded.records);
        // The payload need not be aligned even though renderer structs are.
        let mut unaligned = vec![0u8];
        unaligned.extend_from_slice(&bytes);
        let decoded: Records<T> = bincode::deserialize(&unaligned[1..]).unwrap();
        assert_eq!(value.records, decoded.records);
        let json = serde_json::to_value(&value).unwrap();
        assert!(json["records"][0].is_object());
        let decoded: Records<T> = serde_json::from_value(json).unwrap();
        assert_eq!(value.records, decoded.records);
        for offset in enums {
            let mut invalid = bytes.clone();
            invalid[8 + offset..12 + offset].copy_from_slice(&u32::MAX.to_le_bytes());
            assert!(bincode::deserialize::<Records<T>>(&invalid).is_err());
        }
        // A correct byte-string envelope containing a partial record must be
        // rejected before read_unaligned can construct a value.
        let truncated = bincode::serialize(&serde_bytes::Bytes::new(&bytes[8..bytes.len() - 1])).unwrap();
        assert!(bincode::deserialize::<Records<T>>(&truncated).is_err());
    }
    #[test]
    fn all_shader_records_preserve_fields_and_reject_invalid_discriminants() {
        let bounds = Bounds::new(point(ScaledPixels(1.), ScaledPixels(2.)), crate::size(ScaledPixels(12.), ScaledPixels(14.)));
        let mask = ContentMask { bounds, ..Default::default() };
        let background_enums = [offset_of!(Background, tag), offset_of!(Background, color_space)];
        let mut quad_enums = vec![offset_of!(Quad, border_style)];
        for base in [offset_of!(Quad, background), offset_of!(Quad, border_color)] {
            quad_enums.extend(background_enums.map(|offset| base + offset));
        }
        exercise(Quad { bounds, content_mask: mask, background: crate::rgb(0xff0088).into(), ..Default::default() }, &quad_enums);
        exercise(Shadow {
            order: 1, blur_radius: ScaledPixels(2.), bounds, corner_radii: Default::default(),
            content_mask: mask, color: crate::rgb(0x123456).into(), element_bounds: bounds,
            element_corner_radii: Default::default(), inset: true.into(), corner_smoothing: 0.5,
        }, &[offset_of!(Shadow, inset), offset_of!(Shadow, color) + background_enums[0], offset_of!(Shadow, color) + background_enums[1]]);
        exercise(Underline { order: 2, padding: 0, bounds, content_mask: mask,
            color: SceneHsla::default(), thickness: ScaledPixels(1.), wavy: true.into(),
        }, &[offset_of!(Underline, wavy)]);
        let tile = |kind| AtlasTile { texture_id: AtlasTextureId { index: 3, kind }, tile_id: TileId(7), padding: 1,
            bounds: Bounds::new(point(DevicePixels(1), DevicePixels(2)), crate::size(DevicePixels(4), DevicePixels(5))) };
        let tile_kind = offset_of!(AtlasTile, texture_id) + offset_of!(AtlasTextureId, kind);
        exercise(MonochromeSprite { order: 2, padding: 0, bounds, content_mask: mask,
            color: SceneHsla::default(), tile: tile(AtlasTextureKind::Monochrome), transformation: TransformationMatrix::unit(),
        }, &[offset_of!(MonochromeSprite, tile) + tile_kind]);
        exercise(SubpixelSprite { order: 2, padding: 0, bounds, content_mask: mask,
            color: SceneHsla::default(), tile: tile(AtlasTextureKind::Subpixel), transformation: TransformationMatrix::unit(),
        }, &[offset_of!(SubpixelSprite, tile) + tile_kind]);
        exercise(PolychromeSprite { order: 2, grayscale: false.into(), opacity: 0.4,
            corner_smoothing: 0.6, bounds, content_mask: mask, corner_radii: Default::default(), tile: tile(AtlasTextureKind::Polychrome),
        }, &[offset_of!(PolychromeSprite, grayscale), offset_of!(PolychromeSprite, tile) + tile_kind]);
    }
}
