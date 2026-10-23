#![forbid(unsafe_code)]
#![allow(dead_code, unused_imports)]
use gpui::{FieldId, Signal, Source, Sources};
fn declare<M,T>(r: fn(&M)->&Signal<T>, w: fn(&mut M)->&mut Signal<T>) -> Source<M,T> { Source::new(FieldId::new(0), "value", r, w) }
fn main() {}
