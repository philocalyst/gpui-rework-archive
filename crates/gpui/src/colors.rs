//! Theme colors shared by GPUI components.
//!
//! [`crate::colors::Colors`] is a deliberately small semantic palette. Values are sRGB
//! [`crate::Rgba`] colors, and the light/dark constructors are defaults rather
//! than an exhaustive theme system. Install [`crate::colors::GlobalColors`] in
//! application state when views should read the same palette through
//! [`crate::colors::DefaultColors`].

use crate::{App, Global, Window, WindowAppearance, rgb};
use palette::rgb::Rgba;
use std::ops::Deref;
use std::sync::Arc;

/// The default semantic color set for GPUI components.
///
/// These are used for styling base components, examples and more.
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
    /// Returns the default colors for the given window appearance.
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

    /// Returns the application-wide palette.
    pub fn get_global(cx: &App) -> &Arc<Colors> {
        &cx.global::<GlobalColors>().0
    }
}

/// Application-wide palette stored behind an [`Arc`].
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

/// Implement this trait to allow global [Colors] access via `cx.default_colors()`.
pub trait DefaultColors {
    /// Returns the default [`Colors`]
    fn default_colors(&self) -> &Arc<Colors>;
}

impl DefaultColors for App {
    fn default_colors(&self) -> &Arc<Colors> {
        &self.global::<GlobalColors>().0
    }
}

/// The appearance of the base GPUI colors, used to style GPUI elements
///
/// Varies based on the system's current [`WindowAppearance`].
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
