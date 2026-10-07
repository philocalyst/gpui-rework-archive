use gpui_codepen_guest::{Frame, PreviewContext};
use serde::{Deserialize, Serialize};

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum Backend {
    #[default]
    Miri,
}
impl Backend {
    pub fn label(self) -> &'static str {
        match self {
            Self::Miri => "Miri · interpreted Rust",
        }
    }
}

#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Request {
    pub session_id: String,
    pub generation: u64,
    pub source: String,
    pub backend: Backend,
    #[serde(default)]
    pub restart: bool,
    pub input: PreviewContext,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Reply {
    pub generation: u64,
    pub frame: Option<Frame>,
    pub diagnostics: String,
    pub elapsed_ms: u64,
}

/// State transitions are independent of the GPUI view, so stale compiler replies
/// can never replace a newer component or commit state from an older click.
#[derive(Default)]
pub struct Session {
    pub id: String,
    pub generation: u64,
    pub frame: Option<std::sync::Arc<Frame>>,
    pub diagnostics: String,
    pub running: bool,
    pub elapsed_ms: u64,
}
impl Session {
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
    pub fn reset(&mut self) {
        self.frame = None;
        self.diagnostics.clear();
    }
    pub fn accept(&mut self, mut reply: Reply) -> bool {
        if reply.generation != self.generation {
            return false;
        }
        if let Some(frame) = &reply.frame {
            if let Err(error) = frame.validate() {
                reply.frame = None;
                reply.diagnostics = error;
            }
        }
        self.accept_validated(reply)
    }
    /// Worker-side decoding already validated native replies. Keep that traversal
    /// off the UI thread; browser replies still pass through `accept` above.
    pub(crate) fn accept_validated(&mut self, reply: Reply) -> bool {
        if reply.generation != self.generation {
            return false;
        }
        if let Some(frame) = reply.frame {
            self.frame = Some(std::sync::Arc::new(frame));
        }
        self.diagnostics = reply.diagnostics;
        self.elapsed_ms = reply.elapsed_ms;
        self.running = false;
        true
    }
}
