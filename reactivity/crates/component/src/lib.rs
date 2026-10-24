//! Styled controls over the ordinary GPUI runtime. Applications own state,
//! behavior and the theme snapshot. No global initialization is needed.
//!
//! Builders consume ordinary borrowed descriptions. `.style` and named-part
//! methods apply immediately; they retain no erased callback or style registry.
//! A later handler replaces the preceding handler. Disabled controls keep their
//! role and value while rejecting focus, activation and editing.
#![forbid(unsafe_code)]

pub mod badge;
pub mod button;
pub mod checkbox;
pub mod form;
pub mod input;
pub mod label;
pub mod layout;
pub mod recipe;
pub mod theme;

pub use badge::{Badge, Tone};
pub use button::{Button, ButtonVariant};
pub use checkbox::{Checkbox, CheckboxParts};
pub use form::Field;
pub use input::{Input, InputParts};
pub use label::Label;
pub use theme::{Size, Space, Theme};

/// Static typing extends through control construction and inspector edits.
///
/// ```compile_fail
/// use gpui::{Signal, El};
/// use gpui_component::{Input, Theme};
/// let value = Signal::new(false);
/// let theme = Theme::default();
/// let input = Input::new(&value, "Name", &theme);
/// ```
///
/// ```compile_fail
/// use gpui::property::{Property, WIDTH};
/// let forged = Property::<f32>(());
/// ```
///
/// ```compile_fail
/// use gpui::{El, View, Win, property::{WIDTH, Contribution}};
/// struct Page;
/// impl View for Page { fn view(&self) -> El<'_> { gpui::button("x") } }
/// let mut win = Win::demo(Page);
/// let target = win.button("x");
/// win.set_property(target, WIDTH, Contribution::Set(true));
/// ```
pub struct TypedContracts;
