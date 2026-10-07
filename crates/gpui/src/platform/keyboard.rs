use collections::HashMap;

use crate::{KeybindingKeystroke, Keystroke};

/// Provides the identity and display name of a platform keyboard layout.
pub trait PlatformKeyboardLayout {
    /// Returns an identifier unique to this layout.
    fn id(&self) -> &str;
    /// Returns the localized display name of this layout.
    fn name(&self) -> &str;
}

/// Maps platform keyboard events into GPUI's logical key representation.
pub trait PlatformKeyboardMapper {
    /// Maps a key equivalent to its platform-specific representation.
    fn map_key_equivalent(
        &self,
        keystroke: Keystroke,
        use_key_equivalents: bool,
    ) -> KeybindingKeystroke;
    /// Returns layout-specific key equivalents, when the platform exposes them.
    fn get_key_equivalents(&self) -> Option<&HashMap<char, char>>;
}

/// Mapper that leaves keystrokes unchanged.
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
