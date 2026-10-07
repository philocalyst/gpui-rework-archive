//! Keyboard-layout information and mapping used by keybinding dispatch and display.
//!
//! A [`Keystroke`] carries GPUI's matching representation. A backend mapper may produce a
//! [`KeybindingKeystroke`] that preserves that representation while supplying platform-specific
//! equivalents or shortcut labels. Keep matching data and display data together in that wrapper;
//! do not rewrite a keystroke merely to change how a shortcut is shown.

use collections::HashMap;

use crate::{KeybindingKeystroke, Keystroke};

/// Provides the identity and display name of a platform keyboard layout.
pub trait PlatformKeyboardLayout {
    /// Returns an identifier unique to this layout.
    fn id(&self) -> &str;
    /// Returns the localized display name of this layout.
    fn name(&self) -> &str;
}

/// Maps a GPUI keystroke for keybinding matching and shortcut presentation.
///
/// Implementations account for the active keyboard layout. When `use_key_equivalents` is true,
/// a platform may use equivalent characters so a binding keeps its intended meaning across
/// layouts. The returned wrapper retains the dispatch keystroke even when its displayed key
/// differs.
pub trait PlatformKeyboardMapper {
    /// Maps a keystroke, optionally applying the layout's key equivalents.
    fn map_key_equivalent(
        &self,
        keystroke: Keystroke,
        use_key_equivalents: bool,
    ) -> KeybindingKeystroke;
    /// Returns the layout's character-to-equivalent mapping when available.
    ///
    /// `None` means the backend does not expose a mapping; keybinding behavior can still use
    /// [`Self::map_key_equivalent`].
    fn get_key_equivalents(&self) -> Option<&HashMap<char, char>>;
}

/// Mapper that preserves the input keystroke and exposes no key-equivalent table.
pub struct DummyKeyboardMapper;

impl PlatformKeyboardMapper for DummyKeyboardMapper {
    fn map_key_equivalent(
        &self,
        keystroke: Keystroke,
        _use_key_equivalents: bool,
    ) -> KeybindingKeystroke {
        KeybindingKeystroke::from_keystroke(keystroke)
    }

    fn get_key_equivalents(&self) -> Option<&HashMap<char, char>> {
        None
    }
}
