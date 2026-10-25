extern crate self as gpui;

#[path = "runtime/value.rs"]
mod value;

pub mod reflection {
    pub use crate::value::*;
}

pub mod private {
    pub use inventory;
}

pub use discovery_macro_audit_macros::reflect;
