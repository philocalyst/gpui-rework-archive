//! Typed paths, borrowed value inspection, and native trait views.
//!
//! Use one `#[gpui::reflect]` on an inline module to describe its ordinary Rust declarations.
//! [`fields`], [`methods`], and [`variant_fields`] return native typed handles; [`Value`] and
//! [`ValueMut`] inspect described data through checked borrows. [`Type`] retains a canonical
//! identity even when its structural metadata is discovered later. Native selectors borrow
//! authored components directly and need no reflection attribute for concrete callbacks.
//!
//! The trait-table interface below also supports existing erased-element integrations.
//! Borrowed methods dispatch to concrete implementations; owned builders and
//! `#[reflect(wrapper_default)]` methods use the trait body on [`ReflectedElement`].
//!
//! Standalone generic `Reflect` derives list their traits in `#[reflect(...)]` and forward
//! `Element::reflection` to `<Self as Reflect>::reflection()` with matching trait bounds.
//! The aggregate `Element` derive supplies this hook and its selected builtin traits.
//! Handwritten providers implement `Reflect::build_reflection` and use the same hook.
//! Built-in generic wrappers use empty registrations for traits conditional on their contents.
//!
//! `#[reflect_trait(membership)]` permits associated items and generic methods
//! without granting callable access.
//!
//! Reflection describes the concrete element stored after conversion. A
//! `ViewElement<Icon>` does not inherit traits registered for `Icon` or its rendered
//! root. Animation elements likewise keep their own receiver. `Stateful<E>` is a
//! builder that converts to `E::Element`, so assigning an ID to a `Div` does not
//! give the erased `Div` the `StatefulInteractiveElement` trait.
//! A component can retain custom traits by implementing `Element` on its outer
//! concrete type and delegating directly to a stored element, as in the
//! `trait_reflection` example.

#[doc(hidden)]
pub use gpui_macros::__collect_reflected_traits;
pub use gpui_macros::{Reflect, reflect_trait, trait_set};

mod access;
mod element;
mod metadata;
mod schema;
mod value;

pub use access::*;
pub use element::{ReflectedElement, ReflectionReceiver};
pub use metadata::*;
pub use schema::*;
pub use value::*;

pub mod capability;
pub use capability::Capability;

#[cfg(feature = "bench-support")]
#[doc(hidden)]
pub mod benchmarks;

#[cfg(feature = "bench-support")]
mod value_benchmarks;

#[cfg(test)]
pub(crate) mod test_fixtures;

#[cfg(test)]
mod tests;
