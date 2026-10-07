//! Palette's flattened human-readable representation requires a self-describing
//! serializer. Binary transports use the exact channels, without conversion.
use serde::{Deserialize, Serialize};
macro_rules! channels {
    ($module:ident, $color:ty, $channel:ty, $to:expr, $from:expr) => {
        pub(crate) mod $module {
            use super::*;
            pub fn serialize<S: serde::Serializer>(
                color: &$color,
                serializer: S,
            ) -> Result<S::Ok, S::Error> {
                if serializer.is_human_readable() {
                    color.serialize(serializer)
                } else {
                    let channels: [$channel; 4] = ($to)(*color);
                    channels.serialize(serializer)
                }
            }
            pub fn deserialize<'de, D: serde::Deserializer<'de>>(
                deserializer: D,
            ) -> Result<$color, D::Error> {
                if deserializer.is_human_readable() {
                    <$color>::deserialize(deserializer)
                } else {
                    let channels = <[$channel; 4]>::deserialize(deserializer)?;
                    Ok(($from)(channels))
                }
            }
        }
    };
}
channels!(
    hsla,
    crate::Hsla,
    f32,
    |color: crate::Hsla| [
        color.hue.into_raw_degrees(),
        color.saturation,
        color.lightness,
        color.alpha
    ],
    |v: [f32; 4]| crate::Hsla::new(v[0], v[1], v[2], v[3])
);
channels!(
    rgba,
    crate::Rgba,
    f32,
    |color: crate::Rgba| [color.red, color.green, color.blue, color.alpha],
    |v: [f32; 4]| crate::Rgba::new(v[0], v[1], v[2], v[3])
);
channels!(
    rgba8,
    crate::Rgba8,
    u8,
    |color: crate::Rgba8| [color.red, color.green, color.blue, color.alpha],
    |v: [u8; 4]| crate::Rgba8::new(v[0], v[1], v[2], v[3])
);

pub(crate) mod optional_hsla {
    use super::*;
    #[derive(Serialize, Deserialize)]
    struct Color(#[serde(with = "super::hsla")] crate::Hsla);
    pub fn serialize<S: serde::Serializer>(
        color: &Option<crate::Hsla>,
        serializer: S,
    ) -> Result<S::Ok, S::Error> {
        if serializer.is_human_readable() {
            color.serialize(serializer)
        } else {
            color.map(Color).serialize(serializer)
        }
    }
    pub fn deserialize<'de, D: serde::Deserializer<'de>>(
        deserializer: D,
    ) -> Result<Option<crate::Hsla>, D::Error> {
        if deserializer.is_human_readable() {
            Option::<crate::Hsla>::deserialize(deserializer)
        } else {
            Option::<Color>::deserialize(deserializer).map(|color| color.map(|color| color.0))
        }
    }
}
