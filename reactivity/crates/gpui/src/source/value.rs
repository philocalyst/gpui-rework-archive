use gpui_reactivity_state::Signal;

mod representation {
    use super::Signal;

    pub auto trait Leaf {}
    impl<T> !Leaf for Signal<T> {}
    impl<T: ?Sized> !Leaf for std::cell::UnsafeCell<T> {}

    // Reference-count metadata is not canonical value data. Still inspect the
    // pointee: immutable sharing and copy-on-write preserve independent sources.
    impl<T: Leaf + ?Sized> Leaf for std::sync::Arc<T> {}
    impl<T: Leaf + ?Sized> Leaf for triomphe::Arc<T> {}
    // ArcStr's fixed str bytes are immutable; only lease metadata can change.
    impl Leaf for arcstr::ArcStr {}
}

/// A value that can grant an exact source-edit capability.
///
/// This sealed bound excludes nested `Signal` and `UnsafeCell` storage in the
/// value's owned or borrowed representation, including through containers.
/// Standard and Triomphe Arc leases inspect their pointee rather than their
/// reference-count metadata; ArcStr leases contain fixed immutable str bytes.
/// An exact edit cannot mutate another source's
/// canonical data through a shared atomic, lock, Cell or RefCell payload.
/// General nested `Signal` state remains supported through coarse `Win::update`
/// edits; component models can expose their own independent leaf sources.
///
/// Generic source constructors require `T: SourceValue`. Type-erased values
/// must retain this bound, for example `Box<dyn Any + SourceValue>`; plain
/// `Box<dyn Any>` cannot prove that it excludes signals. This alias cannot be
/// implemented manually, and its private underlying trait cannot be named by
/// consumers.
///
/// This representation check does not prove arbitrary closure purity. External
/// state and reference-count observations are outside canonical source data.
/// Models with shared mutable resources can still use coarse owner updates;
/// exact dependencies should declare immutable snapshots or explicit versions.
pub trait SourceValue = representation::Leaf;
