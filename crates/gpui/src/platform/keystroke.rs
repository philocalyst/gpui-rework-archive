use schemars::JsonSchema;
use serde::{Deserialize, Serialize};
use std::{
    error::Error,
    fmt::{Display, Write},
};

use crate::PlatformKeyboardMapper;

/// Provides the GPUI matching representation for a keystroke or its display wrapper.
pub trait AsKeystroke {
    /// Returns the GPUI representation of the keystroke.
    fn as_keystroke(&self) -> &Keystroke;
}

/// A keymap matching key, its modifiers, and the text it could produce.
///
/// `key` identifies the key used for matching bindings; `key_char` is the optional character
/// produced by the platform's keyboard layout or IME. They can differ for AltGr, dead keys, and
/// non-US layouts. `key` is a logical name, not a hardware scan code. Use
/// [`crate::KeyBinding`] to bind it to an action and [`crate::InputHandler`]
/// for text replacement and composition.
#[derive(Clone, Debug, Eq, PartialEq, Default, Serialize, Deserialize, Hash)]
pub struct Keystroke {
    /// Modifier state captured with this keystroke.
    pub modifiers: Modifiers,

    /// Logical key name used for keymap matching, such as `"s"` or `"enter"`.
    ///
    /// A backend can supply an ASCII equivalent for a non-ASCII keyboard layout;
    /// the produced text belongs in [`Self::key_char`].
    pub key: String,

    /// Text that the keystroke would insert, when supplied by the platform.
    ///
    /// On a US macOS layout, Option-S can have `key = "s"` and
    /// `key_char = Some("ß")`. A shortcut such as Command-S usually has no text.
    /// `None` alone does not establish that an IME composition is active.
    pub key_char: Option<String>,
}

/// A keystroke with platform-specific display metadata.
///
/// Use this type for keymap presentation and matching. Construct it with
/// [`KeybindingKeystroke::new_with_mapper`] or [`KeybindingKeystroke::from_keystroke`] rather than
/// relying on the private display fields.
#[derive(Debug, Clone, Eq, PartialEq, Hash)]
pub struct KeybindingKeystroke {
    /// The GPUI representation of the keystroke.
    inner: Keystroke,
    /// The modifiers to display.
    #[cfg(target_os = "windows")]
    display_modifiers: Modifiers,
    /// The key to display.
    #[cfg(target_os = "windows")]
    display_key: String,
}

/// A keymap string that [`Keystroke::parse`] could not separate into one key and modifiers.
#[derive(Debug)]
pub struct InvalidKeystrokeError {
    /// The invalid keystroke.
    pub keystroke: String,
}

impl Error for InvalidKeystrokeError {}

impl Display for InvalidKeystrokeError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "Invalid keystroke \"{}\". {}",
            self.keystroke, KEYSTROKE_PARSE_EXPECTED_MESSAGE
        )
    }
}

/// Syntax guidance included in an [`InvalidKeystrokeError`]'s display text.
pub const KEYSTROKE_PARSE_EXPECTED_MESSAGE: &str = "Expected a sequence of modifiers \
    (`ctrl`, `alt`, `shift`, `fn`, `cmd`, `super`, or `win`) \
    followed by a key, separated by `-`.";

impl Keystroke {
    /// Whether this input keystroke matches a mapped key binding.
    ///
    /// An exact key-and-modifier match succeeds. When `key_char` differs from
    /// `key`, GPUI also tries that produced text: on Windows it matches an
    /// unmodified binding; elsewhere it retains Control and the platform
    /// modifier while ignoring Alt, Shift, and Fn used to produce the text.
    /// This permits bindings to characters reached through another key or an
    /// input method. It does not compare the binding's display label.
    pub fn should_match(&self, target: &KeybindingKeystroke) -> bool {
        #[cfg(not(target_os = "windows"))]
        if let Some(key_char) = self
            .key_char
            .as_ref()
            .filter(|key_char| key_char != &&self.key)
        {
            let ime_modifiers = Modifiers {
                control: self.modifiers.control,
                platform: self.modifiers.platform,
                ..Default::default()
            };

            if &target.inner.key == key_char && target.inner.modifiers == ime_modifiers {
                return true;
            }
        }

        #[cfg(target_os = "windows")]
        if let Some(key_char) = self
            .key_char
            .as_ref()
            .filter(|key_char| key_char != &&self.key)
        {
            // On Windows, if key_char is set, then the typed keystroke produced the key_char
            if &target.inner.key == key_char && target.inner.modifiers == Modifiers::none() {
                return true;
            }
        }

        target.inner.modifiers == self.modifiers && target.inner.key == self.key
    }

    /// Parses a keymap string such as `secondary-shift-p` or `ctrl-alt-delete`.
    ///
    /// Separate modifiers from the key with `-`. Modifier names are
    /// case-insensitive. `secondary` selects Command on a macOS build and
    /// Control on other targets; `cmd`, `super`, and `win` all select the
    /// platform modifier. A single uppercase ASCII key implies Shift.
    /// Use `ctrl--` for Control with the hyphen key.
    ///
    /// The parser checks the string's structure, not whether a keyboard can
    /// produce the named key. A modifier can itself be the key: `shift` means
    /// pressing Shift with no other modifiers. Whitespace is not trimmed.
    ///
    /// An optional `->text` suffix sets [`Self::key_char`] for simulated input.
    /// [`Self::unparse`] omits that text. For application text input, use the
    /// platform's input handler rather than constructing these strings.
    ///
    /// ```
    /// use gpui::Keystroke;
    ///
    /// assert_eq!(Keystroke::parse("P")?, Keystroke::parse("shift-p")?);
    /// assert_eq!(Keystroke::parse("ctrl--")?.key, "-");
    /// assert_eq!(Keystroke::parse("alt-s->ß")?.key_char.as_deref(), Some("ß"));
    /// assert!(Keystroke::parse("ctrl-a-b").is_err());
    /// # Ok::<(), gpui::InvalidKeystrokeError>(())
    /// ```
    pub fn parse(source: &str) -> std::result::Result<Self, InvalidKeystrokeError> {
        let mut modifiers = Modifiers::none();
        let mut key = None;
        let mut key_char = None;

        let mut components = source.split('-').peekable();
        while let Some(component) = components.next() {
            if component.eq_ignore_ascii_case("ctrl") {
                modifiers.control = true;
                continue;
            }
            if component.eq_ignore_ascii_case("alt") {
                modifiers.alt = true;
                continue;
            }
            if component.eq_ignore_ascii_case("shift") {
                modifiers.shift = true;
                continue;
            }
            if component.eq_ignore_ascii_case("fn") {
                modifiers.function = true;
                continue;
            }
            if component.eq_ignore_ascii_case("secondary") {
                if cfg!(target_os = "macos") {
                    modifiers.platform = true;
                } else {
                    modifiers.control = true;
                };
                continue;
            }

            let is_platform = component.eq_ignore_ascii_case("cmd")
                || component.eq_ignore_ascii_case("super")
                || component.eq_ignore_ascii_case("win");

            if is_platform {
                modifiers.platform = true;
                continue;
            }

            let mut key_str = component.to_string();

            if let Some(next) = components.peek() {
                if next.is_empty() && source.ends_with('-') {
                    key = Some(String::from("-"));
                    break;
                } else if next.len() > 1 && next.starts_with('>') {
                    key = Some(key_str);
                    key_char = Some(String::from(&next[1..]));
                    components.next();
                } else {
                    return Err(InvalidKeystrokeError {
                        keystroke: source.to_owned(),
                    });
                }
                continue;
            }

            if component.len() == 1 && component.as_bytes()[0].is_ascii_uppercase() {
                // Convert to shift + lowercase char
                modifiers.shift = true;
                key_str.make_ascii_lowercase();
            } else {
                // convert ascii chars to lowercase so that named keys like "tab" and "enter"
                // are accepted case insensitively and stored how we expect so they are matched properly
                key_str.make_ascii_lowercase()
            }
            key = Some(key_str);
        }

        // Allow for the user to specify a keystroke modifier as the key itself
        // This sets the `key` to the modifier, and disables the modifier
        key = key.or_else(|| {
            use std::mem;
            // std::mem::take clears bool incase its true
            if mem::take(&mut modifiers.shift) {
                Some("shift".to_string())
            } else if mem::take(&mut modifiers.control) {
                Some("control".to_string())
            } else if mem::take(&mut modifiers.alt) {
                Some("alt".to_string())
            } else if mem::take(&mut modifiers.platform) {
                Some("platform".to_string())
            } else if mem::take(&mut modifiers.function) {
                Some("function".to_string())
            } else {
                None
            }
        });

        let key = key.ok_or_else(|| InvalidKeystrokeError {
            keystroke: source.to_owned(),
        })?;

        Ok(Keystroke {
            modifiers,
            key,
            key_char,
        })
    }

    /// Formats the modifiers and key as a string accepted by [`Self::parse`].
    ///
    /// Platform-modifier aliases become `cmd` on macOS, `win` on Windows, and
    /// `super` elsewhere. The optional [`Self::key_char`] is omitted, so this
    /// preserves the shortcut rather than all data from a text-input event.
    ///
    /// ```
    /// use gpui::Keystroke;
    ///
    /// let shortcut = Keystroke::parse("super-shift-p")?;
    /// assert_eq!(Keystroke::parse(&shortcut.unparse())?, shortcut);
    /// # Ok::<(), gpui::InvalidKeystrokeError>(())
    /// ```
    pub fn unparse(&self) -> String {
        unparse(&self.modifiers, &self.key)
    }

    /// Whether this event may be waiting for text from an input method.
    ///
    /// This is a routing heuristic: no `key_char`, a printable or empty key,
    /// and no modifier other than Shift. It does not query the input method's
    /// actual composition state. See [`crate::InputHandler::marked_text_range`].
    pub fn is_ime_in_progress(&self) -> bool {
        self.key_char.is_none()
            && (is_printable_key(&self.key) || self.key.is_empty())
            && !(self.modifiers.platform
                || self.modifiers.control
                || self.modifiers.function
                || self.modifiers.alt)
    }

    /// Supply text for a simulated printable key when no text was already supplied.
    ///
    /// Control, Alt, Fn, or the platform modifier suppress this fallback.
    /// Space, Tab, and Enter become `" "`, `"\t"`, and `"\n"`; other printable
    /// keys use their name, uppercased when Shift is held. This does not model
    /// keyboard layouts, dead keys, or multi-event composition.
    pub fn with_simulated_ime(mut self) -> Self {
        if self.key_char.is_none()
            && !self.modifiers.platform
            && !self.modifiers.control
            && !self.modifiers.function
            && !self.modifiers.alt
        {
            self.key_char = match self.key.as_str() {
                "space" => Some(" ".into()),
                "tab" => Some("\t".into()),
                "enter" => Some("\n".into()),
                key if !is_printable_key(key) || key.is_empty() => None,
                key => {
                    if self.modifiers.shift {
                        Some(key.to_uppercase())
                    } else {
                        Some(key.into())
                    }
                }
            }
        }
        self
    }
}

impl KeybindingKeystroke {
    #[cfg(target_os = "windows")]
    /// Pair a dispatch keystroke with the modifiers and key label shown in Windows shortcuts.
    /// Display labels do not change which keystroke matches a binding.
    pub fn new(inner: Keystroke, display_modifiers: Modifiers, display_key: String) -> Self {
        KeybindingKeystroke {
            inner,
            display_modifiers,
            display_key,
        }
    }

    /// Create a display and matching wrapper using the platform keyboard mapper.
    ///
    /// Use this when the current layout may change the key equivalent or shortcut label. For a
    /// raw keystroke with no platform mapping, use [`Self::from_keystroke`].
    pub fn new_with_mapper(
        inner: Keystroke,
        use_key_equivalents: bool,
        keyboard_mapper: &dyn PlatformKeyboardMapper,
    ) -> Self {
        keyboard_mapper.map_key_equivalent(inner, use_key_equivalents)
    }

    /// Wrap a keystroke without applying platform-specific mapping.
    ///
    /// Prefer [`Self::new_with_mapper`] when constructing keybinding data for the active layout.
    pub fn from_keystroke(keystroke: Keystroke) -> Self {
        #[cfg(target_os = "windows")]
        {
            let key = keystroke.key.clone();
            let modifiers = keystroke.modifiers;
            KeybindingKeystroke {
                inner: keystroke,
                display_modifiers: modifiers,
                display_key: key,
            }
        }
        #[cfg(not(target_os = "windows"))]
        {
            KeybindingKeystroke { inner: keystroke }
        }
    }

    /// Returns the GPUI representation of the keystroke.
    pub fn inner(&self) -> &Keystroke {
        &self.inner
    }

    /// Modifiers to show in a shortcut label.
    ///
    /// On Windows, these can include Shift needed to produce the matching key:
    /// Control-@ can be displayed as Control-Shift-2 on a US layout. Other
    /// targets use the matching modifiers. Use [`Self::inner`] for dispatch.
    pub fn modifiers(&self) -> &Modifiers {
        #[cfg(target_os = "windows")]
        {
            &self.display_modifiers
        }
        #[cfg(not(target_os = "windows"))]
        {
            &self.inner.modifiers
        }
    }

    /// Key label to show in a shortcut.
    ///
    /// On Windows, this can name the unshifted key while the matching key names
    /// its produced character, such as `2` for `@` on a US layout. Other targets
    /// use the matching key. Use [`Self::inner`] for dispatch.
    pub fn key(&self) -> &str {
        #[cfg(target_os = "windows")]
        {
            &self.display_key
        }
        #[cfg(not(target_os = "windows"))]
        {
            &self.inner.key
        }
    }

    /// Sets the matching modifiers and, on Windows, the displayed modifiers too.
    pub fn set_modifiers(&mut self, modifiers: Modifiers) {
        self.inner.modifiers = modifiers;
        #[cfg(target_os = "windows")]
        {
            self.display_modifiers = modifiers;
        }
    }

    /// Sets the matching key and, on Windows, the displayed key too.
    pub fn set_key(&mut self, key: String) {
        #[cfg(target_os = "windows")]
        {
            self.display_key = key.clone();
        }
        self.inner.key = key;
    }

    /// Serialize the displayed shortcut in keymap syntax.
    ///
    /// On Windows this uses the display modifiers and key. To serialize the
    /// matching representation, use `self.inner().unparse()` instead.
    pub fn unparse(&self) -> String {
        #[cfg(target_os = "windows")]
        {
            unparse(&self.display_modifiers, &self.display_key)
        }
        #[cfg(not(target_os = "windows"))]
        {
            unparse(&self.inner.modifiers, &self.inner.key)
        }
    }

    /// Remove produced text from the matching keystroke.
    pub fn remove_key_char(&mut self) {
        self.inner.key_char = None;
    }
}

fn is_printable_key(key: &str) -> bool {
    !matches!(
        key,
        "f1" | "f2"
            | "f3"
            | "f4"
            | "f5"
            | "f6"
            | "f7"
            | "f8"
            | "f9"
            | "f10"
            | "f11"
            | "f12"
            | "f13"
            | "f14"
            | "f15"
            | "f16"
            | "f17"
            | "f18"
            | "f19"
            | "f20"
            | "f21"
            | "f22"
            | "f23"
            | "f24"
            | "f25"
            | "f26"
            | "f27"
            | "f28"
            | "f29"
            | "f30"
            | "f31"
            | "f32"
            | "f33"
            | "f34"
            | "f35"
            | "backspace"
            | "delete"
            | "left"
            | "right"
            | "up"
            | "down"
            | "pageup"
            | "pagedown"
            | "insert"
            | "home"
            | "end"
            | "back"
            | "forward"
            | "escape"
    )
}

impl std::fmt::Display for Keystroke {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        display_modifiers(&self.modifiers, f)?;
        display_key(&self.key, f)
    }
}

impl std::fmt::Display for KeybindingKeystroke {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        display_modifiers(self.modifiers(), f)?;
        display_key(self.key(), f)
    }
}

/// The state of modifier keys at one point in time.
///
/// `platform` represents Command on macOS, Super on Linux, and Windows on Windows. Use
/// [`Self::secondary`] when the intent is the conventional platform-independent shortcut key.
#[derive(Copy, Clone, Debug, Eq, PartialEq, Default, Serialize, Deserialize, Hash, JsonSchema)]
pub struct Modifiers {
    /// The control key
    #[serde(default)]
    pub control: bool,

    /// The alt key
    /// Sometimes also known as the 'meta' key
    #[serde(default)]
    pub alt: bool,

    /// The shift key
    #[serde(default)]
    pub shift: bool,

    /// The command key, on macos
    /// the windows key, on windows
    /// the super key, on linux
    #[serde(default)]
    pub platform: bool,

    /// The function key
    #[serde(default)]
    pub function: bool,
}

impl Modifiers {
    /// Returns `true` when at least one modifier is pressed.
    pub fn modified(&self) -> bool {
        self.control || self.alt || self.shift || self.platform || self.function
    }

    /// Whether the semantically 'secondary' modifier key is pressed.
    ///
    /// On macOS, this is the command key.
    /// On Linux and Windows, this is the control key.
    pub fn secondary(&self) -> bool {
        #[cfg(target_os = "macos")]
        {
            self.platform
        }

        #[cfg(not(target_os = "macos"))]
        {
            self.control
        }
    }

    /// Returns how many modifier keys are pressed.
    pub fn number_of_modifiers(&self) -> u8 {
        self.control as u8
            + self.alt as u8
            + self.shift as u8
            + self.platform as u8
            + self.function as u8
    }

    /// Returns [`Modifiers`] with no modifiers.
    pub fn none() -> Modifiers {
        Default::default()
    }

    /// Returns [`Modifiers`] with the platform modifier pressed.
    ///
    /// This is Command on macOS, Super on Linux, and the Windows key on Windows. Use
    /// [`Self::secondary_key`] for Command on macOS and Control on other platforms.
    pub fn command() -> Modifiers {
        Modifiers {
            platform: true,
            ..Default::default()
        }
    }

    /// Return Command on a macOS build and Control on other targets.
    pub fn secondary_key() -> Modifiers {
        #[cfg(target_os = "macos")]
        {
            Modifiers {
                platform: true,
                ..Default::default()
            }
        }

        #[cfg(not(target_os = "macos"))]
        {
            Modifiers {
                control: true,
                ..Default::default()
            }
        }
    }

    /// Returns [`Modifiers`] with the platform modifier pressed (Windows key on Windows).
    pub fn windows() -> Modifiers {
        Modifiers {
            platform: true,
            ..Default::default()
        }
    }

    /// Returns [`Modifiers`] with the platform modifier pressed (Super on Linux).
    pub fn super_key() -> Modifiers {
        Modifiers {
            platform: true,
            ..Default::default()
        }
    }

    /// Returns [`Modifiers`] with just control.
    pub fn control() -> Modifiers {
        Modifiers {
            control: true,
            ..Default::default()
        }
    }

    /// Returns [`Modifiers`] with just alt.
    pub fn alt() -> Modifiers {
        Modifiers {
            alt: true,
            ..Default::default()
        }
    }

    /// Returns [`Modifiers`] with just shift.
    pub fn shift() -> Modifiers {
        Modifiers {
            shift: true,
            ..Default::default()
        }
    }

    /// Returns [`Modifiers`] with just function.
    pub fn function() -> Modifiers {
        Modifiers {
            function: true,
            ..Default::default()
        }
    }

    /// Returns the platform modifier plus Shift.
    pub fn command_shift() -> Modifiers {
        Modifiers {
            shift: true,
            platform: true,
            ..Default::default()
        }
    }

    /// Returns [`Modifiers`] with Control and Shift pressed.
    pub fn control_shift() -> Modifiers {
        Modifiers {
            shift: true,
            control: true,
            ..Default::default()
        }
    }

    /// Returns `true` when every modifier set in `self` is also set in `other`.
    pub fn is_subset_of(&self, other: &Modifiers) -> bool {
        (*other & *self) == *self
    }
}

impl std::ops::BitOr for Modifiers {
    type Output = Self;

    fn bitor(mut self, other: Self) -> Self::Output {
        self |= other;
        self
    }
}

impl std::ops::BitOrAssign for Modifiers {
    fn bitor_assign(&mut self, other: Self) {
        self.control |= other.control;
        self.alt |= other.alt;
        self.shift |= other.shift;
        self.platform |= other.platform;
        self.function |= other.function;
    }
}

impl std::ops::BitXor for Modifiers {
    type Output = Self;
    fn bitxor(mut self, rhs: Self) -> Self::Output {
        self ^= rhs;
        self
    }
}

impl std::ops::BitXorAssign for Modifiers {
    fn bitxor_assign(&mut self, other: Self) {
        self.control ^= other.control;
        self.alt ^= other.alt;
        self.shift ^= other.shift;
        self.platform ^= other.platform;
        self.function ^= other.function;
    }
}

impl std::ops::BitAnd for Modifiers {
    type Output = Self;
    fn bitand(mut self, rhs: Self) -> Self::Output {
        self &= rhs;
        self
    }
}

impl std::ops::BitAndAssign for Modifiers {
    fn bitand_assign(&mut self, other: Self) {
        self.control &= other.control;
        self.alt &= other.alt;
        self.shift &= other.shift;
        self.platform &= other.platform;
        self.function &= other.function;
    }
}

/// The state of the capslock key at some point in time
#[derive(Copy, Clone, Debug, Eq, PartialEq, Default, Serialize, Deserialize, Hash, JsonSchema)]
pub struct Capslock {
    /// The capslock key is on
    #[serde(default)]
    pub on: bool,
}

impl AsKeystroke for Keystroke {
    fn as_keystroke(&self) -> &Keystroke {
        self
    }
}

impl AsKeystroke for KeybindingKeystroke {
    fn as_keystroke(&self) -> &Keystroke {
        &self.inner
    }
}

fn display_modifiers(modifiers: &Modifiers, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
    if modifiers.control {
        #[cfg(target_os = "macos")]
        f.write_char('^')?;

        #[cfg(not(target_os = "macos"))]
        write!(f, "ctrl-")?;
    }
    if modifiers.alt {
        #[cfg(target_os = "macos")]
        f.write_char('⌥')?;

        #[cfg(not(target_os = "macos"))]
        write!(f, "alt-")?;
    }
    if modifiers.platform {
        #[cfg(target_os = "macos")]
        f.write_char('⌘')?;

        #[cfg(not(any(target_os = "macos", target_os = "windows")))]
        f.write_char('❖')?;

        #[cfg(target_os = "windows")]
        f.write_char('⊞')?;
    }
    if modifiers.shift {
        #[cfg(target_os = "macos")]
        f.write_char('⇧')?;

        #[cfg(not(target_os = "macos"))]
        write!(f, "shift-")?;
    }
    Ok(())
}

fn display_key(key: &str, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
    let key = match key {
        #[cfg(target_os = "macos")]
        "backspace" => '⌫',
        #[cfg(target_os = "macos")]
        "up" => '↑',
        #[cfg(target_os = "macos")]
        "down" => '↓',
        #[cfg(target_os = "macos")]
        "left" => '←',
        #[cfg(target_os = "macos")]
        "right" => '→',
        #[cfg(target_os = "macos")]
        "tab" => '⇥',
        #[cfg(target_os = "macos")]
        "escape" => '⎋',
        #[cfg(target_os = "macos")]
        "shift" => '⇧',
        #[cfg(target_os = "macos")]
        "control" => '⌃',
        #[cfg(target_os = "macos")]
        "alt" => '⌥',
        #[cfg(target_os = "macos")]
        "platform" => '⌘',

        key if key.len() == 1 => key.chars().next().unwrap().to_ascii_uppercase(),
        key => return f.write_str(key),
    };
    f.write_char(key)
}

#[inline]
fn unparse(modifiers: &Modifiers, key: &str) -> String {
    let mut result = String::new();
    if modifiers.function {
        result.push_str("fn-");
    }
    if modifiers.control {
        result.push_str("ctrl-");
    }
    if modifiers.alt {
        result.push_str("alt-");
    }
    if modifiers.platform {
        #[cfg(target_os = "macos")]
        result.push_str("cmd-");

        #[cfg(not(any(target_os = "macos", target_os = "windows")))]
        result.push_str("super-");

        #[cfg(target_os = "windows")]
        result.push_str("win-");
    }
    if modifiers.shift {
        result.push_str("shift-");
    }
    result.push_str(&key);
    result
}
