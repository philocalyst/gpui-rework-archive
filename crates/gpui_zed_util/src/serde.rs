//! Serde predicates used by configuration defaults.

/// Return `true` for use as a serde default function.
pub const fn default_true() -> bool {
    true
}

/// Return whether `value` equals `T::default()`.
pub fn is_default<T: Default + PartialEq>(value: &T) -> bool {
    *value == T::default()
}
