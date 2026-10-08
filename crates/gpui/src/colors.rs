//! A small semantic palette shared through application state.
//!
//! [`Colors`](crate::colors::Colors) names roles such as text, selection, and
//! border. Its values are sRGB [`crate::Rgba`] colors. Use
//! [`Colors::light`](crate::colors::Colors::light) or
//! [`Colors::dark`](crate::colors::Colors::dark) as a starting point, then
//! install the palette as [`GlobalColors`](crate::colors::GlobalColors):
//!
//! ```rust
//! use gpui::{App, colors::{Colors, GlobalColors}, rgb};
//! use std::sync::Arc;
//!
//! fn install_dark_palette(cx: &mut App) {
//!     let mut palette = Colors::dark();
//!     palette.selected = rgb(0x315a46);
//!     cx.set_global(GlobalColors(Arc::new(palette)));
//! }
//! ```
//!
//! Import [`DefaultColors`](crate::colors::DefaultColors) to read the palette with
//! `cx.default_colors()`. Reading it does not subscribe a view to changes.
//! Views that should redraw after a replacement can retain a
//! [`Context::observe_global`](crate::Context::observe_global) subscription
//! whose callback calls [`Context::notify`](crate::Context::notify).
//!
//! [`Colors::for_appearance`](crate::colors::Colors::for_appearance) takes a
//! snapshot of one window's appearance; it
//! does not install colors or watch for changes. Follow appearance changes
//! with [`Window::observe_window_appearance`] when that is the application's
//! theme policy. The global palette is shared by all windows, so choose which
//! window or user preference governs it. Applications needing independent
//! window themes can keep their palettes on each window's root entity.

use crate::{App, Global, Window, WindowAppearance, rgb};
use palette::rgb::Rgba;
use std::ops::Deref;
use std::sync::Arc;

/// Colors for common interface roles, independent of layout and interaction.
///
/// `Default` returns the light palette. Construction neither installs a
/// global nor applies colors to elements; a component chooses which role to
/// pass to its text, background, or border style.
#[derive(Clone, Debug)]
pub struct Colors {
    /// Primary text color.
    pub text: Rgba,
    /// Text drawn over a selected background.
    pub selected_text: Rgba,
    /// Window or page background.
    pub background: Rgba,
    /// Disabled controls and labels.
    pub disabled: Rgba,
    /// Selection and active-control background.
    pub selected: Rgba,
    /// Borders around controls and containers.
    pub border: Rgba,
    /// Separators between adjacent items.
    pub separator: Rgba,
    /// Raised or nested container background.
    pub container: Rgba,
}

impl Default for Colors {
    fn default() -> Self {
        Self::light()
    }
}

impl Colors {
    /// Builds the light or dark palette for the window's current appearance.
    ///
    /// Vibrant appearances select the corresponding light or dark palette.
    /// This is a snapshot, with no subscription or change to [`GlobalColors`].
    pub fn for_appearance(window: &Window) -> Self {
        match window.appearance() {
            WindowAppearance::Light | WindowAppearance::VibrantLight => Self::light(),
            WindowAppearance::Dark | WindowAppearance::VibrantDark => Self::dark(),
        }
    }

    /// Returns the default dark colors.
    pub fn dark() -> Self {
        Self {
            text: rgb(0xffffff),
            selected_text: rgb(0xffffff),
            disabled: rgb(0x565656),
            selected: rgb(0x2457ca),
            background: rgb(0x222222),
            border: rgb(0x000000),
            separator: rgb(0xd9d9d9),
            container: rgb(0x262626),
        }
    }

    /// Returns the default light colors.
    pub fn light() -> Self {
        Self {
            text: rgb(0x252525),
            selected_text: rgb(0xffffff),
            background: rgb(0xffffff),
            disabled: rgb(0xb0b0b0),
            selected: rgb(0x2a63d9),
            border: rgb(0xd9d9d9),
            separator: rgb(0xe6e6e6),
            container: rgb(0xf4f5f5),
        }
    }

    /// Borrows the palette installed in this app.
    ///
    /// [`App::init_colors`] installs the light defaults. Use [`App::set_global`]
    /// to install a customized [`GlobalColors`] instead.
    ///
    /// # Panics
    ///
    /// Panics if `GlobalColors` has not been installed or is temporarily leased
    /// by a global update. Use [`App::try_global`] when absence is expected.
    pub fn get_global(cx: &App) -> &Arc<Colors> {
        &cx.global::<GlobalColors>().0
    }
}

/// The application's shared palette, installed with [`App::set_global`].
///
/// Cloning this wrapper retains the same immutable palette. Replacing the
/// app's global schedules global observers; previously cloned `Arc`s keep
/// their old palette. Re-read the global when a consumer needs current colors.
#[derive(Clone, Debug)]
pub struct GlobalColors(
    /// Shared semantic palette.
    pub Arc<Colors>,
);

impl Deref for GlobalColors {
    type Target = Arc<Colors>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl Global for GlobalColors {}

/// Method syntax for borrowing an app's installed [`GlobalColors`].
///
/// Import this trait to call `cx.default_colors()` on [`App`] or a context that
/// dereferences to it. The lookup has the same initialization requirements as
/// [`Colors::get_global`].
pub trait DefaultColors {
    /// Borrows the installed palette without observing future replacements.
    ///
    /// The [`App`] implementation panics when [`GlobalColors`] is absent or leased.
    fn default_colors(&self) -> &Arc<Colors>;
}

impl DefaultColors for App {
    fn default_colors(&self) -> &Arc<Colors> {
        &self.global::<GlobalColors>().0
    }
}

/// A light/dark classification of [`WindowAppearance`].
///
/// Conversion folds vibrant variants into their corresponding light or dark
/// value. The enum does not observe the platform or install a palette.
#[derive(Debug, Default, Clone, Copy, PartialEq, Eq)]
pub enum DefaultAppearance {
    /// Use the set of colors for light appearances.
    #[default]
    Light,
    /// Use the set of colors for dark appearances.
    Dark,
}

impl From<WindowAppearance> for DefaultAppearance {
    fn from(appearance: WindowAppearance) -> Self {
        match appearance {
            WindowAppearance::Light | WindowAppearance::VibrantLight => Self::Light,
            WindowAppearance::Dark | WindowAppearance::VibrantDark => Self::Dark,
        }
    }
}
