use std::borrow::Cow;
use std::sync::Arc;

use schemars::{JsonSchema, json_schema};

/// OpenType feature tags and numeric values applied during shaping.
///
/// Features ask the font to change glyph selection or positioning. For example,
/// [tabular figures](https://learn.microsoft.com/en-us/typography/opentype/spec/features_pt#tag-tnum)
/// give digits equal advances, useful for a changing total. Set features on a
/// [`Font`](crate::Font) request or with [`Styled::font_features`](crate::Styled::font_features):
///
/// ```
/// use std::sync::Arc;
/// use gpui::{FontFeatures, div, prelude::*};
///
/// let digits = FontFeatures(Arc::new(vec![("tnum".into(), 1)]));
/// let total = div().font_features(digits).child("Total: 123.45");
/// ```
///
/// The selected font must implement the requested feature. An empty list preserves backend
/// defaults; it does not disable all features. Usually `0` disables a feature and `1` enables
/// it. Some features use larger values to choose an alternate. The
/// [OpenType registry](https://learn.microsoft.com/en-us/typography/opentype/spec/featurelist)
/// defines each tag's meaning.
///
/// # Input contract
///
/// Use four ASCII alphanumeric characters per tag and values no larger than `u16::MAX` for
/// the Parley backend. The tuple constructor does not validate either. Malformed tags or
/// larger values cause Parley layout to panic, including through
/// [`WindowTextSystem::shape_text`](crate::WindowTextSystem::shape_text); that method's
/// `Result` does not turn a backend invariant failure into an error.
///
/// # Serialization
///
/// Human-readable formats use an object mapping tags to values. Booleans deserialize as
/// `0` and `1`; serialization writes numbers:
///
/// ```
/// use gpui::FontFeatures;
///
/// let features: FontFeatures = serde_json::from_str(r#"{"calt": false, "tnum": true}"#)?;
/// assert_eq!(features.is_calt_enabled(), Some(false));
/// assert_eq!(serde_json::to_value(features)?, serde_json::json!({"calt": 0, "tnum": 1}));
/// # Ok::<(), serde_json::Error>(())
/// ```
///
/// Deserialization logs and skips malformed tags, negative numbers, and fractional numbers;
/// it also skips `null`. Unsupported value types, such as strings, fail deserialization.
/// Accepted integers are cast from `u64` to `u32`, truncating larger values. This parser
/// therefore does not establish the shaping contract above. Non-human-readable formats
/// store the `(String, u32)` sequence directly, without tag validation.
#[derive(Default, Clone, Eq, PartialEq, Hash)]
pub struct FontFeatures(pub Arc<Vec<(String, u32)>>);

impl FontFeatures {
    /// Disable the font's contextual alternates (`calt`).
    ///
    /// Some programming fonts implement their code ligatures with this feature. Despite this
    /// method's name, it does not disable `liga`, `clig`, or `dlig`; other features retain their
    /// backend defaults. To control those features, construct [`FontFeatures`] with the
    /// corresponding tags.
    pub fn disable_ligatures() -> Self {
        Self(Arc::new(vec![("calt".into(), 0)]))
    }

    /// Borrow the configured `(tag, value)` pairs.
    pub fn tag_value_list(&self) -> &[(String, u32)] {
        self.0.as_slice()
    }

    /// Report whether the first configured `calt` value is exactly `1`.
    ///
    /// Returns `None` if the feature is not present. Other numeric values, including values
    /// greater than one, return `Some(false)`. This inspects the request, not the font's
    /// support or the backend's default: `None` does not mean alternates are disabled.
    pub fn is_calt_enabled(&self) -> Option<bool> {
        self.0
            .iter()
            .find(|(feature, _)| feature == "calt")
            .map(|(_, value)| *value == 1)
    }
}

impl std::fmt::Debug for FontFeatures {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut debug = f.debug_struct("FontFeatures");
        for (tag, value) in self.tag_value_list() {
            debug.field(tag, value);
        }

        debug.finish()
    }
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
#[serde(untagged)]
enum FeatureValue {
    Bool(bool),
    Number(serde_json::Number),
}

impl<'de> serde::Deserialize<'de> for FontFeatures {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        if !deserializer.is_human_readable() {
            return <Vec<(String, u32)> as serde::Deserialize>::deserialize(deserializer)
                .map(|features| Self(Arc::new(features)));
        }
        use serde::de::{MapAccess, Visitor};
        use std::fmt;

        struct FontFeaturesVisitor;

        impl<'de> Visitor<'de> for FontFeaturesVisitor {
            type Value = FontFeatures;

            fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
                formatter.write_str("a map of font features")
            }

            fn visit_map<M>(self, mut access: M) -> Result<Self::Value, M::Error>
            where
                M: MapAccess<'de>,
            {
                let mut feature_list = Vec::new();

                while let Some((key, value)) =
                    access.next_entry::<String, Option<FeatureValue>>()?
                {
                    if !is_valid_feature_tag(&key) {
                        log::error!("Incorrect font feature tag: {}", key);
                        continue;
                    }
                    if let Some(value) = value {
                        match value {
                            FeatureValue::Bool(enable) => {
                                if enable {
                                    feature_list.push((key, 1));
                                } else {
                                    feature_list.push((key, 0));
                                }
                            }
                            FeatureValue::Number(value) => {
                                if value.is_u64() {
                                    feature_list.push((key, value.as_u64().unwrap() as u32));
                                } else {
                                    log::error!(
                                        "Incorrect font feature value {} for feature tag {}",
                                        value,
                                        key
                                    );
                                    continue;
                                }
                            }
                        }
                    }
                }

                Ok(FontFeatures(Arc::new(feature_list)))
            }
        }

        let features = deserializer.deserialize_map(FontFeaturesVisitor)?;
        Ok(features)
    }
}

impl serde::Serialize for FontFeatures {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        if !serializer.is_human_readable() {
            return serde::Serialize::serialize(self.tag_value_list(), serializer);
        }
        use serde::ser::SerializeMap;

        let mut map = serializer.serialize_map(Some(self.0.len()))?;

        for (tag, value) in self.tag_value_list() {
            map.serialize_entry(tag, value)?;
        }

        map.end()
    }
}

impl JsonSchema for FontFeatures {
    fn schema_name() -> Cow<'static, str> {
        "FontFeatures".into()
    }

    fn json_schema(_: &mut schemars::SchemaGenerator) -> schemars::Schema {
        json_schema!({
            "type": "object",
            "patternProperties": {
                "[0-9a-zA-Z]{4}$": {
                    "type": ["boolean", "integer"],
                    "minimum": 0,
                    "multipleOf": 1
                }
            },
            "additionalProperties": false
        })
    }
}

fn is_valid_feature_tag(tag: &str) -> bool {
    tag.len() == 4 && tag.chars().all(|c| c.is_ascii_alphanumeric())
}
