use crate::SharedString;
use collections::FxHashSet;
use itertools::Itertools;
use std::{
    collections::VecDeque,
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    },
};

const MAX_REPORTED_MISSING_GLYPHS: usize = 1024;

const MISSING_GLYPH_CHANNEL_CAPACITY: usize = 1024;

/// The spacing behavior required of a fallback font.
#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq)]
pub enum FallbackFontClass {
    /// A proportionally spaced fallback font.
    Proportional,
    /// A fixed-width fallback font.
    Monospace,
}

/// A grapheme cluster that could not be represented by any available font.
#[derive(Clone, Debug, Eq, Hash, PartialEq)]
pub struct MissingGlyph {
    grapheme: SharedString,
    font_class: FallbackFontClass,
}

impl MissingGlyph {
    /// Creates a missing-glyph report.
    pub fn new(grapheme: SharedString, font_class: FallbackFontClass) -> Self {
        Self {
            grapheme,
            font_class,
        }
    }

    /// Returns the unresolved grapheme cluster.
    pub fn grapheme(&self) -> &str {
        &self.grapheme
    }

    /// Returns the spacing behavior required of a fallback font.
    pub fn font_class(&self) -> FallbackFontClass {
        self.font_class
    }
}

/// Accepts missing glyphs detected by a platform text system.
pub trait MissingGlyphSink: Send + Sync {
    /// Reports grapheme clusters that exhausted font fallback.
    fn report(&self, missing_glyphs: Vec<MissingGlyph>);
}

#[derive(Default)]
struct MissingGlyphState {
    reported: FxHashSet<MissingGlyph>,
    reported_order: VecDeque<MissingGlyph>,
    generation: usize,
}

impl MissingGlyphState {
    fn reset(&mut self, generation: usize) {
        self.reported.clear();
        self.reported_order.clear();
        self.generation = generation;
    }
}

struct QueuedMissingGlyph {
    generation: usize,
    missing_glyph: MissingGlyph,
}

/// Collects missing-glyph reports without invoking application code during layout.
pub(super) struct MissingGlyphReporter {
    generation: Arc<AtomicUsize>,
    sender: async_channel::Sender<QueuedMissingGlyph>,
}

impl MissingGlyphSink for MissingGlyphReporter {
    fn report(&self, missing_glyphs: Vec<MissingGlyph>) {
        if self.sender.is_closed() {
            return;
        }

        let generation = self.generation.load(Ordering::Acquire);
        // Repetitions within a line must not fill the queue before its other
        // missing glyphs. Cross-report deduplication belongs to the receiver.
        for missing_glyph in missing_glyphs.into_iter().unique() {
            let queued = QueuedMissingGlyph {
                generation,
                missing_glyph,
            };
            if self.sender.try_send(queued).is_err() {
                break;
            }
        }
    }
}

impl MissingGlyphReporter {
    pub(super) fn reset(&self) {
        self.generation.fetch_add(1, Ordering::AcqRel);
    }
}

/// Receives batches of grapheme clusters that exhausted font fallback.
pub(crate) struct MissingGlyphReceiver {
    state: MissingGlyphState,
    generation: Arc<AtomicUsize>,
    receiver: async_channel::Receiver<QueuedMissingGlyph>,
}

/// Creates the private reporter/receiver pair while keeping queued channel state encapsulated.
pub(super) fn missing_glyph_channel() -> (MissingGlyphReporter, MissingGlyphReceiver) {
    let (sender, receiver) = async_channel::bounded(MISSING_GLYPH_CHANNEL_CAPACITY);
    let generation = Arc::<AtomicUsize>::default();
    (
        MissingGlyphReporter {
            generation: generation.clone(),
            sender,
        },
        MissingGlyphReceiver {
            state: MissingGlyphState::default(),
            generation,
            receiver,
        },
    )
}

impl MissingGlyphReceiver {
    /// Waits until at least one new missing glyph has been observed.
    ///
    /// # Errors
    ///
    /// Returns [`async_channel::RecvError`] if the reporting channel is closed.
    pub(crate) async fn recv(
        &mut self,
    ) -> std::result::Result<Vec<MissingGlyph>, async_channel::RecvError> {
        loop {
            let queued = self.receiver.recv().await?;
            let mut missing_glyphs = Vec::new();
            for queued in std::iter::once(queued)
                .chain(std::iter::from_fn(|| self.receiver.try_recv().ok()))
                .take(MAX_REPORTED_MISSING_GLYPHS)
            {
                let generation = self.generation.load(Ordering::Acquire);
                if self.state.generation != generation {
                    self.state.reset(generation);
                    missing_glyphs.clear();
                }
                if queued.generation != generation
                    || !self.state.reported.insert(queued.missing_glyph.clone())
                {
                    continue;
                }
                self.state
                    .reported_order
                    .push_back(queued.missing_glyph.clone());
                missing_glyphs.push(queued.missing_glyph);
                if self.state.reported.len() > MAX_REPORTED_MISSING_GLYPHS
                    && let Some(expired) = self.state.reported_order.pop_front()
                {
                    self.state.reported.remove(&expired);
                }
            }
            if !missing_glyphs.is_empty() {
                return Ok(missing_glyphs);
            }
            // A producer can keep refilling the queue with already-reported
            // glyphs. Bound work per poll even when every report is filtered out.
            let mut yielded = false;
            std::future::poll_fn(|cx| {
                if std::mem::replace(&mut yielded, true) {
                    std::task::Poll::Ready(())
                } else {
                    cx.waker().wake_by_ref();
                    std::task::Poll::Pending
                }
            })
            .await;
        }
    }
}

impl Drop for MissingGlyphReceiver {
    fn drop(&mut self) {
        self.receiver.close();
        while self.receiver.try_recv().is_ok() {}
    }
}

#[cfg(test)]
mod missing_glyph_tests {
    use super::*;
    use futures::FutureExt as _;

    #[test]
    fn bounds_retained_missing_glyphs() {
        let (reporter, mut receiver) = missing_glyph_channel();
        reporter.report(
            (0..MAX_REPORTED_MISSING_GLYPHS)
                .map(|index| {
                    MissingGlyph::new(index.to_string().into(), FallbackFontClass::Proportional)
                })
                .collect(),
        );
        assert!(receiver.recv().now_or_never().unwrap().is_ok());

        let newest = MissingGlyph::new("newest".into(), FallbackFontClass::Monospace);
        reporter.report(vec![newest.clone()]);
        assert!(receiver.recv().now_or_never().unwrap().is_ok());

        let state = &receiver.state;
        assert_eq!(state.reported.len(), MAX_REPORTED_MISSING_GLYPHS);
        assert_eq!(state.reported_order.len(), MAX_REPORTED_MISSING_GLYPHS);
        assert!(state.reported.contains(&newest));
    }

    #[test]
    fn dropping_receiver_closes_and_clears_reports() {
        let (reporter, receiver) = missing_glyph_channel();
        reporter.report(vec![missing_glyph("missing")]);

        drop(receiver);

        assert!(reporter.sender.is_closed());
        assert!(reporter.sender.is_empty());
    }

    fn missing_glyph_channel() -> (MissingGlyphReporter, MissingGlyphReceiver) {
        let (sender, receiver) = async_channel::bounded(MAX_REPORTED_MISSING_GLYPHS);
        let generation = Arc::<AtomicUsize>::default();
        let reporter = MissingGlyphReporter {
            generation: generation.clone(),
            sender,
        };
        let receiver = MissingGlyphReceiver {
            state: MissingGlyphState::default(),
            generation,
            receiver,
        };
        (reporter, receiver)
    }

    fn missing_glyph(grapheme: &'static str) -> MissingGlyph {
        MissingGlyph::new(grapheme.into(), FallbackFontClass::Proportional)
    }
}
