use std::rc::Rc;

use crate::{
    Action, AsKeystroke, DummyKeyboardMapper, InvalidKeystrokeError, KeyBindingContextPredicate,
    KeybindingKeystroke, Keystroke, PlatformKeyboardMapper, SharedString,
};
use smallvec::SmallVec;

/// A key sequence, the action it requests, and an optional context predicate.
///
/// Add it to the app with [`App::bind_keys`](crate::App::bind_keys). A binding
/// selects a command; an action listener must still handle it. Element handlers
/// follow the focused path, with [`App::on_action`](crate::App::on_action)
/// providing an app-wide fallback. Use [`new`](Self::new) for fixed strings in application
/// code, or [`load`](Self::load) for fallible configuration and platform mapping.
///
/// A sequence such as `ctrl-k left` is a two-stroke shortcut, also called a
/// chord. [`Keymap::bindings_for_input`](crate::Keymap::bindings_for_input)
/// resolves complete matches and pending prefixes. The window buffers those
/// prefixes and dispatches the selected action; see
/// [pending chords](crate::_documentation::input#wait-for-a-pending-chord).
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
    /// Separate strokes with whitespace to create a chord, such as `cmd-k left`.
    /// Each stroke follows [`Keystroke::parse`]. The context follows
    /// [`KeyBindingContextPredicate::parse`]; `None` leaves it unconditional.
    /// This convenience constructor uses [`DummyKeyboardMapper`], preserving
    /// the parsed key without layout-specific equivalents. Use [`Self::load`] to
    /// supply platform mapping and report invalid configuration as an error.
    ///
    /// # Panics
    ///
    /// Panics if a keystroke or the context predicate cannot be parsed.
    /// An empty keystroke string is accepted, but cannot match a key event.
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

    /// Parse a sequence and map its strokes for a keyboard layout.
    ///
    /// `keystrokes` is a whitespace-separated sequence. `context_predicate` should be parsed
    /// separately with [`KeyBindingContextPredicate::parse`]. The supplied
    /// `action` is already constructed. `action_input` stores its original JSON
    /// payload for later inspection; this method does not parse that payload.
    /// [`Self::with_meta`] can record which configuration source supplied the binding.
    ///
    /// Each stroke is parsed with [`Keystroke::parse`], then passed to
    /// [`PlatformKeyboardMapper::map_key_equivalent`] with `use_key_equivalents`.
    /// The mapper controls the matching key and its display label. GPUI keeps
    /// those together in a [`KeybindingKeystroke`].
    ///
    /// # Errors
    ///
    /// A malformed stroke returns [`InvalidKeystrokeError`], which contains
    /// that stroke rather than the whole sequence. An empty sequence succeeds
    /// but cannot match a key event. Context errors come from the separate
    /// predicate parse.
    ///
    /// # Example
    ///
    /// A configuration loader can report both parsing errors instead of
    /// panicking. This example deliberately uses an unmapped keyboard:
    ///
    /// ```rust
    /// use gpui::{DummyKeyboardMapper, KeyBinding, KeyBindingContextPredicate, actions};
    ///
    /// actions!(documentation_binding_load, [MoveLeft]);
    /// let context = KeyBindingContextPredicate::parse("Editor && mode == normal")?;
    /// let binding = KeyBinding::load(
    ///     "ctrl-k left", Box::new(MoveLeft), Some(context.into()),
    ///     false, None, &DummyKeyboardMapper,
    /// )?;
    /// assert_eq!(binding.keystrokes().len(), 2);
    ///
    /// let invalid = KeyBinding::load(
    ///     "ctrl-k ctrl-a-b", Box::new(MoveLeft), None,
    ///     false, None, &DummyKeyboardMapper,
    /// );
    /// assert_eq!(invalid.unwrap_err().keystroke, "ctrl-a-b");
    /// # Ok::<(), anyhow::Error>(())
    /// ```
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

    /// Sets the source metadata index and returns the binding.
    ///
    /// The index also controls source precedence for [`NoAction`](crate::NoAction)
    /// removals; see [`KeyBindingMetaIndex`].
    pub fn with_meta(mut self, meta: KeyBindingMetaIndex) -> Self {
        self.meta = Some(meta);
        self
    }

    /// Replaces this binding's source metadata index.
    ///
    /// This has the same removal-precedence effect as [`Self::with_meta`].
    pub fn set_meta(&mut self, meta: KeyBindingMetaIndex) {
        self.meta = Some(meta);
    }

    /// Match a typed prefix against this binding's sequence.
    ///
    /// Returns `None` if the strokes differ or the input is longer than the binding, `Some(true)`
    /// if all typed strokes match but more strokes are required, and `Some(false)` for a complete
    /// match. Context and keymap precedence are not checked here.
    /// Matching uses [`Keystroke::should_match`], including its produced-text
    /// rules, rather than comparing shortcut display labels.
    ///
    /// ```rust
    /// use gpui::{KeyBinding, Keystroke, actions};
    ///
    /// actions!(documentation_binding_prefix, [MoveLeft]);
    /// let binding = KeyBinding::new("ctrl-k left", MoveLeft, Some("Editor"));
    /// let prefix = [Keystroke::parse("ctrl-k")?];
    /// assert_eq!(binding.match_keystrokes(&prefix), Some(true));
    ///
    /// let complete = [prefix[0].clone(), Keystroke::parse("left")?];
    /// assert_eq!(binding.match_keystrokes(&complete), Some(false));
    /// let wrong = [prefix[0].clone(), Keystroke::parse("right")?];
    /// assert_eq!(binding.match_keystrokes(&wrong), None);
    /// # Ok::<(), gpui::InvalidKeystrokeError>(())
    /// ```
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

    /// Returns the optional source metadata index.
    ///
    /// Absence is treated as source zero during [`crate::NoAction`] removal.
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

/// An index into application-owned key-binding source metadata.
///
/// For example, a configuration loader can use this to find the file that
/// supplied a shortcut. The numeric value also affects [`NoAction`](crate::NoAction)
/// suppression in [`Keymap`](crate::Keymap): smaller values represent stronger
/// sources, and an absent index is treated as `0`. Assign user bindings stronger
/// precedence than base-map removals when those removals should preserve user
/// overrides.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct KeyBindingMetaIndex(pub u32);
