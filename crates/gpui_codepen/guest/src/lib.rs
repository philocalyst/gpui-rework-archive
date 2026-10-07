//! Interpreter transport for the actual GPUI crate. There is no element or style
//! facade: source components use `gpui::Render`, `Window`, `App`, and `Context`.
use gpui::{Pixels, SceneCapture, Size, px, size};
use serde::{Deserialize, Serialize};
pub mod wire;
pub mod input;
pub use input::{InputMessage,TextEdit,TextContext};
pub mod rpc;
#[cfg(feature = "interpreter")]
mod interpreter;
#[cfg(feature = "interpreter")]
pub use interpreter::run;

pub const PROTOCOL_VERSION: u32 = 7;
pub const MAX_SOURCE_BYTES: usize = 64 * 1024;
pub const MAX_FRAME_BYTES: usize = 64 * 1024 * 1024;

#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PreviewContext {
    pub viewport: Size<Pixels>,
    pub scale_factor: f32,
    #[serde(default)]
    pub events: Vec<InputMessage>,
    #[serde(default)]
    pub elapsed_ms: u64,
}
impl Default for PreviewContext {
    fn default() -> Self { Self { viewport: size(px(600.), px(500.)), scale_factor: 1., events: Vec::new(), elapsed_ms: 0 } }
}
impl PreviewContext {
    pub fn validate(&self) -> Result<(), String> {
        if !self.scale_factor.is_finite() || !(0.25..=8.).contains(&self.scale_factor)
            || !f32::from(self.viewport.width).is_finite() || !f32::from(self.viewport.height).is_finite()
            || !(1. ..=8192.).contains(&f32::from(self.viewport.width)) || !(1. ..=8192.).contains(&f32::from(self.viewport.height))
            || self.events.len() > 128 { return Err("invalid preview viewport or event batch".into()); }
        Ok(())
    }
}

#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
pub struct Frame {
    pub version: u32,
    pub viewport: Size<Pixels>,
    pub scale_factor: f32,
    pub scene: SceneCapture,
    pub next_frame_ms: Option<u64>,
    pub cursor:gpui::CursorStyle,
    pub text:Option<TextContext>,
}
impl Frame {
    pub fn validate(&self) -> Result<(), String> {
        if self.version != PROTOCOL_VERSION { return Err("unsupported GPUI interpreter protocol".into()); }
        PreviewContext { viewport: self.viewport, scale_factor: self.scale_factor, ..Default::default() }.validate()?;
        self.scene.validate().map_err(|e| e.to_string())
    }
}
