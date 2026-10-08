//! Cheaply cloned, immutable strings for GPUI's public APIs.
//!
//! [`SharedString`] accepts the common string forms through `From` and keeps an
//! value independent of the source borrow, suitable for elements and
//! asynchronous work. Use [`SharedString::new_static`] for a literal and
//! [`SharedString::new`] for text borrowed from a local value. Use
//! [`SharedString::as_str`] when the recipient only needs a borrow.

use std::{
    borrow::{Borrow, Cow},
    iter,
    sync::Arc,
};

use schemars::JsonSchema;
use serde::{Deserialize, Serialize};
use smol_str::SmolStr;

/// An immutable UTF-8 string with constant-time cloning.
///
/// Short strings fit inline, longer strings share reference-counted storage,
/// and [`new_static`](Self::new_static) retains a static string directly. The
/// representation is backed by [`SmolStr`]; callers should not depend on its
/// inline capacity. Equality, ordering, and hashing compare string contents.
///
/// Converting a borrowed `&str` copies its contents into this representation;
/// it does not retain a borrow of the source. Converting a `String` can also
/// copy and allocate. To edit text, keep a `String` in the model and construct
/// a new `SharedString` when presenting the changed text. Cloning does not
/// create a mutable string or a redraw subscription.
///
/// ```
/// # extern crate gpui_ce_shared_string as gpui;
/// use gpui::SharedString;
///
/// const LABEL: SharedString = SharedString::new_static("Save");
/// let source = String::from("Report");
/// let title = SharedString::new(&source);
/// drop(source);
/// let same_title = title.clone();
/// assert_eq!(same_title.as_str(), "Report");
/// assert_eq!(LABEL.as_str(), "Save");
/// ```
#[derive(Eq, PartialEq, PartialOrd, Ord, Hash, Clone)]
pub struct SharedString(SmolStr);

impl std::ops::Deref for SharedString {
    type Target = str;

    fn deref(&self) -> &Self::Target {
        self.0.as_str()
    }
}

impl SharedString {
    /// Retains a static string without copying or allocating.
    ///
    /// This is a `const` constructor, suitable for labels and other literals.
    /// Use [`Self::new`] when the source has a shorter lifetime.
    pub const fn new_static(str: &'static str) -> Self {
        Self(SmolStr::new_static(str))
    }

    /// Copies text into inline or shared storage, allocating when necessary.
    ///
    /// The result does not borrow `str`. Passing an owned `String` does not
    /// promise to reuse that string's allocation; this method reads it through
    /// [`AsRef<str>`].
    pub fn new(str: impl AsRef<str>) -> Self {
        SharedString(SmolStr::new(str))
    }

    /// Borrows the UTF-8 contents without allocating.
    ///
    /// The borrow lasts no longer than this value. Dereferencing a
    /// `SharedString` provides the same `str` access, including byte length
    /// and string slicing; indices must still be UTF-8 boundaries.
    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl JsonSchema for SharedString {
    fn inline_schema() -> bool {
        String::inline_schema()
    }

    fn schema_name() -> Cow<'static, str> {
        String::schema_name()
    }

    fn json_schema(generator: &mut schemars::SchemaGenerator) -> schemars::Schema {
        String::json_schema(generator)
    }
}

impl Default for SharedString {
    fn default() -> Self {
        Self::new_static("")
    }
}

impl AsRef<str> for SharedString {
    fn as_ref(&self) -> &str {
        &self.0
    }
}

impl Borrow<str> for SharedString {
    fn borrow(&self) -> &str {
        self.as_ref()
    }
}

impl std::fmt::Debug for SharedString {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.0.fmt(f)
    }
}

impl std::fmt::Display for SharedString {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0.as_str())
    }
}

impl PartialEq<String> for SharedString {
    fn eq(&self, other: &String) -> bool {
        self.as_ref() == other
    }
}

impl PartialEq<SharedString> for String {
    fn eq(&self, other: &SharedString) -> bool {
        self == other.as_ref()
    }
}

impl PartialEq<str> for SharedString {
    fn eq(&self, other: &str) -> bool {
        self.as_ref() == other
    }
}

impl<'a> PartialEq<&'a str> for SharedString {
    fn eq(&self, other: &&'a str) -> bool {
        self.as_ref() == *other
    }
}

impl From<&SharedString> for SharedString {
    #[inline]
    fn from(s: &SharedString) -> SharedString {
        s.clone()
    }
}

impl From<&str> for SharedString {
    #[inline]
    fn from(s: &str) -> SharedString {
        SharedString(SmolStr::from(s))
    }
}

impl From<char> for SharedString {
    #[inline]
    fn from(c: char) -> SharedString {
        SharedString(SmolStr::from_iter(iter::once(c)))
    }
}

impl From<&mut str> for SharedString {
    #[inline]
    fn from(s: &mut str) -> SharedString {
        SharedString(SmolStr::from(s))
    }
}

impl From<&String> for SharedString {
    #[inline]
    fn from(s: &String) -> SharedString {
        SharedString(SmolStr::from(s))
    }
}

impl From<String> for SharedString {
    #[inline(always)]
    fn from(text: String) -> Self {
        SharedString(SmolStr::from(text))
    }
}

impl From<Box<str>> for SharedString {
    #[inline]
    fn from(s: Box<str>) -> SharedString {
        SharedString(SmolStr::from(s))
    }
}

impl From<Arc<str>> for SharedString {
    #[inline]
    fn from(s: Arc<str>) -> SharedString {
        SharedString(SmolStr::from(s))
    }
}

impl From<&Arc<str>> for SharedString {
    #[inline]
    fn from(s: &Arc<str>) -> SharedString {
        SharedString(SmolStr::from(s.clone()))
    }
}

impl<'a> From<Cow<'a, str>> for SharedString {
    #[inline]
    fn from(s: Cow<'a, str>) -> SharedString {
        SharedString(SmolStr::from(s))
    }
}

impl From<SharedString> for Arc<str> {
    #[inline(always)]
    fn from(text: SharedString) -> Self {
        text.0.into()
    }
}

impl From<SharedString> for String {
    #[inline(always)]
    fn from(text: SharedString) -> Self {
        text.0.into()
    }
}

impl Serialize for SharedString {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        serializer.serialize_str(self.as_ref())
    }
}

impl<'de> Deserialize<'de> for SharedString {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        let s = String::deserialize(deserializer)?;
        Ok(SharedString::new(&s))
    }
}
