#![cfg(feature = "serde")]

use gpui_reactivity_state::Signal;
use serde::{Deserialize, Deserializer, Serialize, Serializer};

#[test]
fn persistence_keeps_only_the_value_and_restores_a_fresh_revision() {
    let mut signal = Signal::new(10u32);
    *signal += 1;
    *signal += 2;
    assert_eq!(signal.revision().get(), 2);

    let encoded = serde_json::to_string(&signal).unwrap();
    assert_eq!(encoded, "13");
    let mut restored: Signal<u32> = serde_json::from_str(&encoded).unwrap();
    assert_eq!(*restored, 13);
    assert_eq!(restored.revision().get(), 0);
    *restored += 1;
    assert_eq!(restored.revision().get(), 1);

    // A persisted wrapper cannot inject a supposedly live runtime revision.
    assert!(serde_json::from_str::<Signal<u32>>(r#"{"value":13,"revision":2}"#).is_err());
}

// No Clone/Default/Copy implementations: persistence must not add unrelated
// bounds to the inner value or reconstruct it through a default placeholder.
#[derive(Debug, PartialEq, Eq)]
struct NonClone(String);

impl Serialize for NonClone {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        self.0.serialize(serializer)
    }
}
impl<'de> Deserialize<'de> for NonClone {
    fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        String::deserialize(deserializer).map(Self)
    }
}

#[test]
fn owned_strings_and_nonclone_values_roundtrip_without_runtime_stamps() {
    let mut text = Signal::new("before".to_owned());
    text.push_str(" after");
    let encoded = serde_json::to_string(&text).unwrap();
    assert_eq!(encoded, r#""before after""#);
    let restored: Signal<String> = serde_json::from_str(&encoded).unwrap();
    assert_eq!(&*restored, "before after");
    assert_eq!(restored.revision().get(), 0);

    let mut value = Signal::new(NonClone("original".into()));
    value.0 = "edited".into();
    let encoded = serde_json::to_string(&value).unwrap();
    let restored: Signal<NonClone> = serde_json::from_str(&encoded).unwrap();
    assert_eq!(*restored, NonClone("edited".into()));
    assert_eq!(restored.revision().get(), 0);
}

#[test]
fn deserialization_accepts_inner_values_borrowing_the_input() {
    let encoded = r#""borrowed""#;
    let restored: Signal<&str> = serde_json::from_str(encoded).unwrap();
    assert_eq!(*restored, "borrowed");
    assert_eq!(restored.revision().get(), 0);
    assert_eq!(restored.as_ptr(), encoded[1..].as_ptr());
}

#[test]
fn invalid_values_preserve_the_inner_deserializers_error() {
    let encoded = r#""invalid integer""#;
    let inner = serde_json::from_str::<u32>(encoded).unwrap_err();
    let signal = serde_json::from_str::<Signal<u32>>(encoded).unwrap_err();
    assert_eq!(signal.to_string(), inner.to_string());
    assert_eq!(signal.classify(), inner.classify());
}
