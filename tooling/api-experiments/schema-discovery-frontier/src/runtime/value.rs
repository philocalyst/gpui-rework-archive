//! Borrowed structural access to values with a safe, typed schema.
//!
//! Schemas contain function pointers generated from ordinary Rust field accesses. They never store
//! element instances or compute field offsets. Dynamic lookups borrow a child from the current
//! `ValueMut`; the schema itself retains no references to that child.

#[path = "value/method.rs"]
mod method;
#[path = "value/path.rs"]
mod path;
pub use method::*;
pub use path::*;
#[cfg(test)]
#[path = "value/tests.rs"]
mod tests;

/// Provides native field handles independently of a value's runtime schema.
/// Generated for structs by [`gpui::reflect`]. Borrowed types are supported.
pub trait HasFields {
    /// The record containing this type's field handles.
    type Fields;
    /// Returns the typed field handles.
    fn fields() -> Self::Fields;
}

/// Provides native method handles without reserving an inherent method name.
pub trait HasMethods {
    /// The record containing this type's method handles.
    type Methods;
    /// Returns the typed method handles.
    fn methods() -> Self::Methods;
}

/// Provides variant-qualified enum field handles.
pub trait HasVariantFields {
    /// The record containing the field handles for each variant.
    type VariantFields;
    /// Returns the variant-qualified field handles.
    fn variant_fields() -> Self::VariantFields;
}

/// Returns a type's native field handles, including when it has its own `fields` method.
pub fn fields<T: HasFields>() -> T::Fields {
    T::fields()
}

/// Returns a type's native method handles, including when it has its own `methods` method.
pub fn methods<T: HasMethods>() -> T::Methods {
    T::methods()
}

/// Returns variant-qualified handles, including when `variant_fields` is already in use.
pub fn variant_fields<T: HasVariantFields>() -> T::VariantFields {
    T::variant_fields()
}

#[path = "value/borrowed.rs"]
mod borrowed;
#[path = "value/schema.rs"]
mod schema;
pub use borrowed::*;
pub use schema::*;
