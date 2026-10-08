//! Request identity and last-successful-frame retention for one interpreter session.

use gpui_codepen_guest::{Frame, PreviewContext};
use serde::{Deserialize, Serialize};

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
/// The execution backend selected for a request.
pub enum Backend {
    #[default]
    /// Execute the component with the vendored Miri interpreter.
    Miri,
}
impl Backend {
    /// A display label for the selected backend.
    pub fn label(self) -> &'static str {
        match self {
            Self::Miri => "Miri · interpreted Rust",
        }
    }
}

#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
/// One source, input, or animation update sent to the interpreter.
pub struct Request {
    /// Stable session identity; state can be reused only within this session.
    pub session_id: String,
    /// Request generation. Replies for superseded generations are discarded.
    pub generation: u64,
    /// A complete component source, bounded by the runtime's source-byte limit.
    pub source: String,
    /// The requested interpreter backend.
    pub backend: Backend,
    #[serde(default)]
    /// Construct a fresh component even when the source has not changed.
    pub restart: bool,
    /// Viewport, rendering policy, elapsed time, and queued input for this update.
    pub input: PreviewContext,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
/// Distinguishes a program diagnostic from an unavailable execution service.
pub enum FailureKind {
    /// The compiler or interpreter rejected the program.
    Rust,
    /// Execution could not proceed, for example because assets or transport failed.
    Unavailable,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
/// An interpreter result whose identity must match the outstanding request.
pub struct Reply {
    /// The generation echoed from the request.
    pub generation: u64,
    /// The new frame, or `None` when execution produced no replacement.
    pub frame: Option<Frame>,
    /// Compiler, interpreter, transport, or validation diagnostics.
    pub diagnostics: String,
    /// Whether execution failed because of the source or runtime availability.
    #[serde(default)]
    pub failure: Option<FailureKind>,
    /// Execution time in milliseconds, as reported by the backend.
    pub elapsed_ms: u64,
}

/// Reply identity and the last successful frame for one preview.
///
/// Stale replies cannot replace the displayed frame. Rejecting a reply does not
/// roll back mutations already made by the resident interpreter; transport
/// cancellation and input ordering remain the controller's responsibility.
#[derive(Default)]
pub struct Session {
    /// Stable session UUID, allocated by the first [`request`](Self::request).
    pub id: String,
    /// The current generation used to reject stale replies.
    pub generation: u64,
    /// The last accepted frame; an error does not clear it.
    pub frame: Option<std::sync::Arc<Frame>>,
    /// Diagnostics from the latest accepted reply.
    pub diagnostics: String,
    /// The failure category from the latest accepted reply, if it failed.
    pub failure: Option<FailureKind>,
    /// Whether a request is outstanding.
    pub running: bool,
    /// Time reported by the latest accepted reply, in milliseconds.
    pub elapsed_ms: u64,
}
impl Session {
    /// Starts a new generation with default viewport policy and optional input.
    ///
    /// Allocates a session UUID on first use and sets `running`. Callers can
    /// adjust the returned input policy and restart flag before submitting it.
    pub fn request(
        &mut self,
        source: String,
        backend: Backend,
        event: Option<gpui_codepen_guest::InputMessage>,
    ) -> Request {
        self.generation = self.generation.wrapping_add(1);
        self.running = true;
        if self.id.is_empty() {
            self.id = uuid::Uuid::new_v4().to_string();
        }
        Request {
            session_id: self.id.clone(),
            generation: self.generation,
            source,
            backend,
            restart: false,
            input: PreviewContext {
                events: event.into_iter().collect(),
                ..Default::default()
            },
        }
    }
    /// Invalidates outstanding replies and clears the stored result.
    ///
    /// Advances the generation, clears `running`, and removes the frame,
    /// diagnostics, and elapsed time. The interpreter's work is not canceled by
    /// this state change alone; controllers must cancel their transport task too.
    pub fn reset(&mut self) {
        self.generation = self.generation.wrapping_add(1);
        self.running = false;
        self.elapsed_ms = 0;
        self.frame = None;
        self.diagnostics.clear();
        self.failure = None;
    }
    /// Validates and accepts a reply for the current generation.
    ///
    /// A stale reply returns `false` without changing state. An invalid frame
    /// becomes a diagnostic and leaves the previous frame in place. A matching
    /// reply returns `true` and clears `running`, including on failure.
    pub fn accept(&mut self, mut reply: Reply) -> bool {
        if reply.generation != self.generation {
            return false;
        }
        if let Some(frame) = &reply.frame {
            if let Err(error) = frame.validate() {
                reply.frame = None;
                reply.diagnostics = error;
                reply.failure = Some(FailureKind::Unavailable);
            }
        }
        self.accept_validated(reply)
    }
    /// Accepts replies already validated by the transport, avoiding another
    /// frame traversal on the UI thread.
    pub(crate) fn accept_validated(&mut self, reply: Reply) -> bool {
        if reply.generation != self.generation {
            return false;
        }
        if let Some(frame) = reply.frame {
            self.frame = Some(std::sync::Arc::new(frame));
        }
        self.failure = if reply.diagnostics.is_empty() { None }
            else { reply.failure.or(Some(FailureKind::Rust)) };
        self.diagnostics = reply.diagnostics;
        self.elapsed_ms = reply.elapsed_ms;
        self.running = false;
        true
    }
}
