# Value query consumer

This standalone consumer keeps the ordinary Rust surface visible: a `RenderOnce`
component is edited by a native callback, a nested typed path infers its leaf,
and a fixed-associated-type role lends a native trait object. The component also
uses a borrowed return and a GAT through its direct callback. A concrete `Div`
query demonstrates the same callback API on an element that survives conversion.

The integration fixture `crates/gpui/tests/value_queries.rs` adds headless
coverage for enum-path and role-schema admission before positional filtering.
