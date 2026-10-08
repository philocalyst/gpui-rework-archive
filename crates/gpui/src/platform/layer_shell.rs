//! Wayland desktop surfaces for panels, backgrounds, and overlays.
//!
//! Pass [`LayerShellOptions`] through [`crate::WindowKind::LayerShell`]. The
//! compositor must support the
//! [layer-shell protocol](https://gitlab.freedesktop.org/wlroots/wlr-protocols/-/blob/master/unstable/wlr-layer-shell-unstable-v1.xml);
//! otherwise opening the window returns [`LayerShellNotSupportedError`].
//! This is a desktop-shell capability, not an in-window stacking order. Use
//! [`crate::deferred`] or [`crate::anchored`] for content within an ordinary window.

use bitflags::bitflags;
use thiserror::Error;

use crate::{Pixels, util::FluentBuilder};

/// The layer the surface is rendered on. Multiple surfaces can share a layer, and ordering within
/// a single layer is undefined.
#[derive(Copy, Clone, Debug, Default, PartialEq, Eq)]
pub enum Layer {
    /// The background layer, typically used for wallpapers.
    Background,

    /// Below ordinary application windows and above the background layer.
    Bottom,

    /// Above ordinary application windows; fullscreen windows commonly occupy this layer too.
    Top,

    /// Above the top layer. Ordering among overlay surfaces is compositor-defined.
    #[default]
    Overlay,
}

bitflags! {
    /// Output edges used to place a layer-shell surface.
    ///
    /// Combine adjacent edges for a corner, or leave empty for centered placement.
    /// To let the compositor assign a dimension, request zero for that dimension
    /// in [`crate::WindowOptions::window_bounds`] and anchor to both opposite
    /// edges. Opposite anchors alone do not replace a nonzero requested size.
    #[derive(Copy, Clone, Debug, Default, PartialEq, Eq)]
    pub struct Anchor: u32 {
        /// Anchor to the top edge of the screen.
        const TOP = 1;
        /// Anchor to the bottom edge of the screen.
        const BOTTOM = 2;
        /// Anchor to the left edge of the screen.
        const LEFT = 4;
        /// Anchor to the right edge of the screen.
        const RIGHT = 8;
    }
}

/// Keyboard interactivity mode for the layer_shell surfaces.
#[derive(Copy, Clone, Debug, Default, PartialEq, Eq)]
pub enum KeyboardInteractivity {
    /// No keyboard inputs will be delivered to the surface and it won't be able to receive
    /// keyboard focus.
    None,

    /// Request exclusive focus in the top or overlay layer.
    ///
    /// The highest layer with an exclusive surface takes keyboard focus. If
    /// several such surfaces share it, the compositor chooses among them.
    /// Lower layers may use ordinary focus rules.
    Exclusive,

    /// The surface can be focused similarly to a normal window.
    #[default]
    OnDemand,
}

/// Initial placement and input policy for a Wayland layer-shell window.
///
/// Chain setters on [`LayerShellOptions::default`] to configure the surface.
/// Defaults select the overlay layer, centered placement, no exclusive zone or
/// margins, and on-demand keyboard focus. Optional fields left as `None` retain
/// the protocol defaults. All lengths are logical pixels, converted to integers
/// at the protocol boundary.
///
/// ```
/// use gpui::{
///     layer_shell::{Anchor, KeyboardInteractivity, Layer, LayerShellOptions},
///     px,
/// };
///
/// let options = LayerShellOptions::default()
///     .namespace("panel")
///     .layer(Layer::Top)
///     .anchor(Anchor::LEFT | Anchor::RIGHT | Anchor::BOTTOM)
///     .exclusive_zone(px(40.0))
///     .keyboard_interactivity(KeyboardInteractivity::None);
/// ```
#[derive(Clone, Debug, Default, PartialEq, Eq, derive_setters::Setters)]
#[setters(into)]
pub struct LayerShellOptions {
    /// The namespace for the surface, mostly used by compositors to apply rules, can not be
    /// changed after the surface is created.
    pub namespace: String,
    /// The layer the surface is rendered on.
    pub layer: Layer,
    /// The anchor point of the surface.
    pub anchor: Anchor,
    /// Space requested from the compositor at the anchored edge.
    ///
    /// A positive distance asks other surfaces to leave that space available.
    /// Zero avoids other exclusive zones without reserving one; `-1` ignores
    /// those zones. The compositor decides how to honor this request. A positive
    /// zone needs one anchored edge, optionally with both perpendicular edges.
    /// Margins on the exclusive edge count toward the zone.
    pub exclusive_zone: Option<Pixels>,
    /// The anchor point of the exclusive zone, will be determined using the anchor if left
    /// unspecified.
    pub exclusive_edge: Option<Anchor>,
    /// Distances from anchored edges, in `(top, right, bottom, left)` order.
    ///
    /// Values for edges absent from [`Self::anchor`] have no effect.
    pub margin: Option<(Pixels, Pixels, Pixels, Pixels)>,
    /// How keyboard events should be delivered to the surface.
    pub keyboard_interactivity: KeyboardInteractivity,
}

impl FluentBuilder for LayerShellOptions {}

/// An error indicating that an action failed because the compositor doesn't support the required
/// layer_shell protocol.
#[derive(Debug, Error)]
#[error("Compositor doesn't support zwlr_layer_shell_v1")]
pub struct LayerShellNotSupportedError;
