use std::collections::{VecDeque, vec_deque};

/// Admission failed; the producer still owns the undelivered value.
#[derive(Debug, PartialEq, Eq)]
pub struct Full<T>(pub T);

/// Explicit turn-end diagnostic data. Inspecting does not consume an occurrence.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Unconsumed {
    pub pending: usize,
    pub capacity: usize,
}

/// Bounded, FIFO, consume-once occurrence storage.
///
/// A successful `give` transfers ownership into this field; `take` acknowledges
/// exactly one occurrence. A full queue returns ownership without overwriting or
/// dropping earlier occurrences. Nothing runs synchronously on give or take.
/// This container is not a cross-thread ingress or a persistence mechanism.
///
/// ```
/// use gpui_reactivity_state::{Handoff, Full};
/// let mut picked = Handoff::bounded(1);
/// picked.give("first").unwrap();
/// assert_eq!(picked.give("retry later"), Err(Full("retry later")));
/// assert_eq!(picked.take(), Some("first"));
/// assert_eq!(picked.take(), None);
/// ```
#[derive(Debug)]
pub struct Handoff<T> {
    values: VecDeque<T>,
    capacity: usize,
}

impl<T> Handoff<T> {
    /// The default admission bound, not an eagerly allocated buffer size.
    pub const DEFAULT_CAPACITY: usize = 64;

    pub fn new() -> Self {
        Self::bounded(Self::DEFAULT_CAPACITY)
    }

    /// Select the admission bound; zero means all gives return `Full`.
    /// Allocation grows as values are admitted. This bounds occurrence count;
    /// `VecDeque` may round its allocated storage capacity above the bound.
    pub fn bounded(capacity: usize) -> Self {
        Self {
            values: VecDeque::new(),
            capacity,
        }
    }

    pub fn give(&mut self, value: T) -> Result<(), Full<T>> {
        if self.values.len() == self.capacity {
            return Err(Full(value));
        }
        self.values.push_back(value);
        Ok(())
    }

    pub fn take(&mut self) -> Option<T> {
        self.values.pop_front()
    }

    /// Remove the queued batch, yielding it in FIFO order. Dropping the iterator
    /// drops any remaining values, as with `VecDeque::drain`.
    pub fn drain(&mut self) -> vec_deque::Drain<'_, T> {
        self.values.drain(..)
    }

    pub fn len(&self) -> usize {
        self.values.len()
    }

    pub fn is_empty(&self) -> bool {
        self.values.is_empty()
    }

    pub fn capacity(&self) -> usize {
        self.capacity
    }

    /// The caller can attach owner/source locations when reporting this record.
    /// No implicit logging or panic occurs during drop.
    pub fn unconsumed(&self) -> Option<Unconsumed> {
        (!self.is_empty()).then_some(Unconsumed {
            pending: self.len(),
            capacity: self.capacity,
        })
    }
}

impl<T> Default for Handoff<T> {
    fn default() -> Self {
        Self::new()
    }
}
