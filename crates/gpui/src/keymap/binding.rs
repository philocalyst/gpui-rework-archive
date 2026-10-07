use std::rc::Rc;

use crate::{
    Action, AsKeystroke, DummyKeyboardMapper, InvalidKeystrokeError, KeyBindingContextPredicate,
    KeybindingKeystroke, Keystroke, PlatformKeyboardMapper, SharedString,
};
use smallvec::SmallVec;

/// A keybinding and its associated metadata, from the keymap.
// docs:examples:begin
#[doc = include_str!("../docs/examples/gpui-KeyBinding-12b9082b.md")]
// docs:examples:end
pub struct KeyBinding {
    pub(crate) action: Box<dyn Action>,
    pub(crate) keystrokes: SmallVec<[KeybindingKeystroke; 2]>,
    pub(crate) context_predicate: Option<Rc<KeyBindingContextPredicate>>,
    pub(crate) meta: Option<KeyBindingMetaIndex>,
    /// The json input string used when building the keybinding, if any
    pub(crate) action_input: Option<SharedString>,
}

impl Clone for KeyBinding {
    fn clone(&self) -> Self {
        KeyBinding {
            action: self.action.boxed_clone(),
            keystrokes: self.keystrokes.clone(),
            context_predicate: self.context_predicate.clone(),
            meta: self.meta,
            action_input: self.action_input.clone(),
        }
    }
}

impl KeyBinding {
    /// Construct a key binding from keystrokes, action, and an optional context predicate.
    ///
    /// Separate strokes with whitespace to create a chord, such as `cmd-k left`. This convenience
    /// constructor parses the context and keystrokes using the dummy keyboard mapper and panics if
    /// either string is invalid. Use [`Self::load`] to supply platform mapping and handle invalid
    /// keystrokes as an error.
    pub fn new<A: Action>(keystrokes: &str, action: A, context: Option<&str>) -> Self {
        let context_predicate =
            context.map(|context| KeyBindingContextPredicate::parse(context).unwrap().into());
        Self::load(
            keystrokes,
            Box::new(action),
            context_predicate,
            false,
            None,
            &DummyKeyboardMapper,
        )
        .unwrap()
    }

    /// Parse a key binding using an explicit keyboard mapper and optional metadata.
    ///
    /// `keystrokes` is a whitespace-separated sequence. `context_predicate` should be parsed
    /// separately with [`KeyBindingContextPredicate::parse`]; malformed keystrokes return
    /// [`InvalidKeystrokeError`]. An empty string creates a binding with no strokes, which cannot
    /// match a key event. The optional `action_input` retains the original JSON payload text when a
    /// binding was loaded from configuration. `use_key_equivalents` lets the platform mapper apply
    /// equivalent characters so a binding can keep its intended meaning across layouts.
    pub fn load(
        keystrokes: &str,
        action: Box<dyn Action>,
        context_predicate: Option<Rc<KeyBindingContextPredicate>>,
        use_key_equivalents: bool,
        action_input: Option<SharedString>,
        keyboard_mapper: &dyn PlatformKeyboardMapper,
    ) -> std::result::Result<Self, InvalidKeystrokeError> {
        let keystrokes: SmallVec<[KeybindingKeystroke; 2]> = keystrokes
            .split_whitespace()
            .map(|source| {
                let keystroke = Keystroke::parse(source)?;
                Ok(KeybindingKeystroke::new_with_mapper(
                    keystroke,
                    use_key_equivalents,
                    keyboard_mapper,
                ))
            })
            .collect::<std::result::Result<_, _>>()?;

        Ok(Self {
            keystrokes,
            action,
            context_predicate,
            meta: None,
            action_input,
        })
    }

    /// Set the opaque metadata index associated with this binding and return it.
    pub fn with_meta(mut self, meta: KeyBindingMetaIndex) -> Self {
        self.meta = Some(meta);
        self
    }

    /// Replace this binding's opaque metadata index.
    pub fn set_meta(&mut self, meta: KeyBindingMetaIndex) {
        self.meta = Some(meta);
    }

    /// Match a typed prefix against this binding's sequence.
    ///
    /// Returns `None` if the strokes differ or the input is longer than the binding, `Some(true)`
    /// if all typed strokes match but more strokes are required, and `Some(false)` for a complete
    /// match. Context and keymap precedence are not checked here.
    pub fn match_keystrokes(&self, typed: &[impl AsKeystroke]) -> Option<bool> {
        if self.keystrokes.len() < typed.len() {
            return None;
        }

        for (target, typed) in self.keystrokes.iter().zip(typed.iter()) {
            if !typed.as_keystroke().should_match(target) {
                return None;
            }
        }

        Some(self.keystrokes.len() > typed.len())
    }

    /// Return the parsed keystrokes in sequence order.
    pub fn keystrokes(&self) -> &[KeybindingKeystroke] {
        self.keystrokes.as_slice()
    }

    /// Return the action invoked by this binding.
    pub fn action(&self) -> &dyn Action {
        self.action.as_ref()
    }

    /// Clone the optional context predicate used to enable this binding.
    pub fn predicate(&self) -> Option<Rc<KeyBindingContextPredicate>> {
        self.context_predicate.as_ref().map(|rc| rc.clone())
    }

    /// Return the optional user-defined metadata index.
    pub fn meta(&self) -> Option<KeyBindingMetaIndex> {
        self.meta
    }

    /// Clone the original JSON payload text, if this binding was loaded with one.
    pub fn action_input(&self) -> Option<SharedString> {
        self.action_input.clone()
    }
}

impl std::fmt::Debug for KeyBinding {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("KeyBinding")
            .field("keystrokes", &self.keystrokes)
            .field("context_predicate", &self.context_predicate)
            .field("action", &self.action.name())
            .finish()
    }
}

/// A unique identifier for retrieval of metadata associated with a key binding.
/// Intended to be used as an index or key into a user-defined store of metadata
/// associated with the binding, such as the source of the binding.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct KeyBindingMetaIndex(pub u32);
