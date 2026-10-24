//! A cold closed union keeps the ordinary mapped Vec's existing stride.
use super::{MapBinding, Sink, boolean::Record};
#[derive(Default)]
pub(crate) enum MapBindings<'a> {
    #[default]
    Empty,
    Maps(Vec<MapBinding<'a>>),
    Boolean(Vec<Record<'a>>),
    Mixed(Box<Mixed<'a>>),
}
pub(crate) struct Mixed<'a> {
    maps: Vec<MapBinding<'a>>,
    boolean: Vec<Record<'a>>,
}
fn push<T>(values: &mut Vec<T>, value: T) {
    if values.len() == values.capacity() {
        values.reserve_exact(values.capacity().max(1));
    }
    values.push(value);
}
impl<'a> MapBindings<'a> {
    pub fn is_empty(&self) -> bool {
        match self {
            Self::Empty => true,
            Self::Maps(v) => v.is_empty(),
            Self::Boolean(v) => v.is_empty(),
            Self::Mixed(v) => v.maps.is_empty() && v.boolean.is_empty(),
        }
    }
    fn maps(&self) -> &[MapBinding<'a>] {
        match self {
            Self::Maps(v) => v,
            Self::Mixed(v) => &v.maps,
            _ => &[],
        }
    }
    fn boolean(&self) -> &[Record<'a>] {
        match self {
            Self::Boolean(v) => v,
            Self::Mixed(v) => &v.boolean,
            _ => &[],
        }
    }
    pub fn contains(&self, sink: Sink) -> bool {
        self.maps().iter().any(|binding| binding.sink == sink)
            || self
                .boolean()
                .iter()
                .any(|record| record.sink() == Some(sink))
    }
    pub fn mapped_mut(&mut self, sink: Sink) -> Option<&mut MapBinding<'a>> {
        match self {
            Self::Maps(v) => v,
            Self::Mixed(v) => &mut v.maps,
            _ => return None,
        }
        .iter_mut()
        .find(|binding| binding.sink == sink)
    }
    pub fn push_map(&mut self, binding: MapBinding<'a>) {
        match self {
            Self::Empty => {
                let mut v = Vec::new();
                push(&mut v, binding);
                *self = Self::Maps(v);
            }
            Self::Maps(v) => push(v, binding),
            Self::Mixed(v) => push(&mut v.maps, binding),
            Self::Boolean(v) => {
                let boolean = std::mem::take(v);
                let mut maps = Vec::new();
                push(&mut maps, binding);
                *self = Self::Mixed(Box::new(Mixed { maps, boolean }));
            }
        }
    }
    pub fn push_boolean(&mut self, record: Record<'a>) {
        match self {
            Self::Empty => {
                let mut v = Vec::new();
                push(&mut v, record);
                *self = Self::Boolean(v);
            }
            Self::Boolean(v) => push(v, record),
            Self::Mixed(v) => push(&mut v.boolean, record),
            Self::Maps(v) => {
                let maps = std::mem::take(v);
                let mut boolean = Vec::new();
                push(&mut boolean, record);
                *self = Self::Mixed(Box::new(Mixed { maps, boolean }));
            }
        }
    }
    pub fn unbind(&mut self, sink: Sink) {
        match self {
            Self::Empty => {}
            Self::Maps(v) => v.retain(|binding| binding.sink != sink),
            Self::Boolean(v) => v.retain(|record| record.sink() != Some(sink)),
            Self::Mixed(v) => {
                v.maps.retain(|binding| binding.sink != sink);
                v.boolean.retain(|record| record.sink() != Some(sink));
                if v.maps.is_empty() {
                    *self = Self::Boolean(std::mem::take(&mut v.boolean));
                } else if v.boolean.is_empty() {
                    *self = Self::Maps(std::mem::take(&mut v.maps));
                }
            }
        }
        if self.is_empty() {
            *self = Self::Empty;
        }
    }
    pub fn into_parts(self) -> (Vec<MapBinding<'a>>, Vec<Record<'a>>) {
        match self {
            Self::Empty => (Vec::new(), Vec::new()),
            Self::Maps(v) => (v, Vec::new()),
            Self::Boolean(v) => (Vec::new(), v),
            Self::Mixed(v) => (v.maps, v.boolean),
        }
    }
}
