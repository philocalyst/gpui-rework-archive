//! Internal explicit lowering storage. The brand belongs to cursors, not public El.
use std::marker::PhantomData;

pub(crate) struct Frame<'id, T> {
    nodes: Vec<T>,
    brand: PhantomData<fn(&'id ()) -> &'id ()>,
}

pub(crate) struct Cursor<'id> {
    start: usize,
    end: usize,
    brand: PhantomData<fn(&'id ()) -> &'id ()>,
}

pub(crate) fn with_frame<T, R>(body: impl for<'id> FnOnce(&mut Frame<'id, T>) -> R) -> R {
    body(&mut Frame {
        nodes: Vec::new(),
        brand: PhantomData,
    })
}

impl<'id, T> Frame<'id, T> {
    pub(crate) fn lower(&mut self, nodes: impl IntoIterator<Item = T>) -> Cursor<'id> {
        let start = self.nodes.len();
        self.nodes.extend(nodes);
        Cursor {
            start,
            end: self.nodes.len(),
            brand: PhantomData,
        }
    }

    pub(crate) fn read(&self, cursor: Cursor<'id>) -> &[T] {
        &self.nodes[cursor.start..cursor.end]
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn independent_nested_frames_keep_their_own_storage() {
        with_frame(|outer| {
            let a = outer.lower([1, 2]);
            with_frame(|inner| {
                let b = inner.lower([3, 4]);
                assert_eq!(outer.read(a), &[1, 2]);
                assert_eq!(inner.read(b), &[3, 4]);
            });
        });
    }
}
