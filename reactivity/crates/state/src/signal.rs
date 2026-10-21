use std::ops::{Deref, DerefMut};

/// A conservative mutation stamp, local to one signal's lifetime. It is not an
/// identity: consumers spanning owner lifetimes also need owner incarnation.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct Revision(u32);

impl Revision {
    pub const fn get(self) -> u32 {
        self.0
    }
}

/// An inline value with exclusive mutation and a conservative mutation stamp.
///
/// A shared borrow reads the value without tracking. Obtaining `&mut T` increments
/// the stamp **before** returning that borrow, even if the caller never changes
/// the value or unwinds. Rust's `DerefMut` returns `&mut T`, not a drop guard.
/// Consequently this is mutation marking, not immediate runtime publication.
/// A caller can observe revisions at a turn boundary and compare destination
/// values to suppress spurious work. Moving the signal does not invalidate any
/// stored pointer: there are no stored pointers.
///
/// Like ordinary Rust data, `T` may itself offer interior mutation. Such mutation
/// cannot be detected here; tracked values must be edited through `&mut Signal`.
///
/// With the optional `serde` feature, only the value is serialized, using `T`'s
/// representation. Deserialization creates a fresh signal at revision zero;
/// local mutation stamps and owner capabilities are never restored from data.
///
/// ```
/// use gpui_reactivity_state::Signal;
/// let mut count = Signal::new(1);
/// let before = count.revision();
/// *count += 0;
/// assert_ne!(count.revision(), before);
/// assert_eq!(*count, 1);
/// ```
///
/// ```compile_fail
/// use gpui_reactivity_state::Signal;
/// struct Counter { count: Signal<u32> }
/// impl Counter {
///     fn view(&self) { *self.count += 1; }
/// }
/// ```
#[derive(Debug)]
pub struct Signal<T> {
    value: T,
    revision: Revision,
}

impl<T> Signal<T> {
    pub const fn new(value: T) -> Self {
        Self {
            value,
            revision: Revision(0),
        }
    }

    pub const fn revision(&self) -> Revision {
        self.revision
    }

    pub fn into_inner(self) -> T {
        self.value
    }
}

impl<T: Default> Default for Signal<T> {
    fn default() -> Self {
        Self::new(T::default())
    }
}

#[cfg(feature = "serde")]
impl<T: serde::Serialize> serde::Serialize for Signal<T> {
    fn serialize<S: serde::Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        self.value.serialize(serializer)
    }
}

#[cfg(feature = "serde")]
impl<'de, T: serde::Deserialize<'de>> serde::Deserialize<'de> for Signal<T> {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        T::deserialize(deserializer).map(Self::new)
    }
}

impl<T> Deref for Signal<T> {
    type Target = T;

    fn deref(&self) -> &T {
        &self.value
    }
}

impl<T> DerefMut for Signal<T> {
    /// Panics on exhaustion before permitting a mutation; revisions never wrap.
    fn deref_mut(&mut self) -> &mut T {
        self.revision.0 = self
            .revision
            .0
            .checked_add(1)
            .expect("signal revision exhausted");
        &mut self.value
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn exhaustion_never_exposes_an_unmarked_mutable_borrow() {
        let mut signal = Signal {
            value: 7,
            revision: Revision(u32::MAX),
        };
        let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| *signal = 9));
        assert!(result.is_err());
        assert_eq!(*signal, 7);
        assert_eq!(signal.revision().get(), u32::MAX);
    }
}
