//! Portable software replay of the compiled GPUI render command stream.
//!
//! This backend is intended for deterministic tests and screenshot capture. Geometry and
//! coverage use the same Rust-authored shader helpers as the GPU backend; atlas uploads remain
//! byte-identical to the glyph and image data supplied by GPUI.

use anyhow::{Context, Result, bail, ensure};
use gpui::{
    CapturedBitmap, DevicePixels, FilterRenderTarget, PlatformAtlas,
    PlatformHeadlessRenderer as PlatformHeadlessRendererTrait, Scene, ShaderBool, Size,
};
use image::RgbaImage;
use std::sync::Arc;

/// A deterministic CPU implementation of GPUI's headless rendering interfaces.
#[derive(Default)]
pub struct CpuRenderer {
    atlas: Arc<CpuAtlas>,
    font: crate::font::FontRasterizationSettings,
    frame: Option<Frame>,
}

mod atlas;
mod frame;
pub use atlas::CpuAtlas;
use frame::{Frame, SpriteKind};

impl CpuRenderer {
    /// Creates a renderer with an empty atlas.
    pub fn new() -> Self {
        Self::default()
    }

    /// Returns the atlas so callers can install captured tile bitmaps before replay.
    pub fn atlas(&self) -> Arc<CpuAtlas> {
        self.atlas.clone()
    }

    /// Creates a renderer backed by an existing atlas handle.
    pub fn from_atlas(atlas: Arc<CpuAtlas>) -> Self {
        Self {
            atlas,
            font: Default::default(),
            frame: None,
        }
    }

    /// Creates an atlas from SceneCapture's canonical bitmap vector.
    pub fn from_captured_bitmaps(bitmaps: &[CapturedBitmap]) -> Result<Self> {
        Ok(Self::from_atlas(Arc::new(CpuAtlas::from_captured_bitmaps(
            bitmaps,
        )?)))
    }

    /// Uses explicit platform text settings instead of neutral portable coverage.
    pub fn with_font_rasterization(
        mut self,
        settings: crate::font::FontRasterizationSettings,
    ) -> Self {
        self.font = settings;
        self
    }

    /// Copies the most recently rendered frame into straight RGBA pixels.
    /// Benchmark callers can keep this conversion outside their replay timings.
    pub fn readback(&self) -> Result<RgbaImage> {
        Ok(self
            .frame
            .as_ref()
            .context("CPU renderer has no completed frame")?
            .to_image())
    }
}

impl PlatformHeadlessRendererTrait for CpuRenderer {
    fn render_scene_to_image(
        &mut self,
        scene: &Scene,
        size: Size<DevicePixels>,
    ) -> Result<RgbaImage> {
        self.render_scene(scene, size)?;
        self.readback()
    }

    fn render_scene(&mut self, scene: &Scene, size: Size<DevicePixels>) -> Result<()> {
        self.frame = Some(replay_frame(
            scene,
            size,
            &self.atlas,
            self.font.uniforms(),
            self.frame.take(),
        )?);
        Ok(())
    }

    fn sprite_atlas(&self) -> Arc<dyn PlatformAtlas> {
        self.atlas.clone()
    }
}

fn replay_frame(
    scene: &Scene,
    size: Size<DevicePixels>,
    atlas: &CpuAtlas,
    font: crate::shaders::common::FontRasterizationUniforms,
    retained: Option<Frame>,
) -> Result<Frame> {
    ensure!(
        size.width.0 >= 0 && size.height.0 >= 0,
        "CPU renderer requires non-negative dimensions"
    );
    let width = size.width.0 as u32;
    let height = size.height.0 as u32;
    let mut target = match retained {
        Some(mut frame) => {
            frame.resize_and_clear(width, height);
            frame
        }
        None => Frame::new(width, height),
    };
    let mut stack = Vec::<Option<FilterFrame>>::new();
    for command in scene.render_commands() {
        match command {
            gpui::RenderCommand::Batch(batch) => match batch {
                gpui::PrimitiveBatch::Shadows { range, smoothed } => {
                    for item in &scene.shadows[range.clone()] {
                        target.draw_shadow(item, *smoothed);
                    }
                }
                gpui::PrimitiveBatch::Quads { range, smoothed } => {
                    for item in &scene.quads[range.clone()] {
                        target.draw_quad(item, *smoothed);
                    }
                }
                gpui::PrimitiveBatch::Underlines(range) => {
                    for item in &scene.underlines[range.clone()] {
                        target.draw_underline(item);
                    }
                }
                gpui::PrimitiveBatch::MonochromeSprites { range, .. } => {
                    for item in &scene.monochrome_sprites[range.clone()] {
                        target.draw_sprite(
                            item.bounds,
                            item.content_mask,
                            item.color.into(),
                            item.tile,
                            Some(item.transformation),
                            SpriteKind::Mono,
                            atlas,
                            font,
                        )?;
                    }
                }
                gpui::PrimitiveBatch::SubpixelSprites { range, .. } => {
                    for item in &scene.subpixel_sprites[range.clone()] {
                        target.draw_sprite(
                            item.bounds,
                            item.content_mask,
                            item.color.into(),
                            item.tile,
                            Some(item.transformation),
                            SpriteKind::Subpixel,
                            atlas,
                            font,
                        )?;
                    }
                }
                gpui::PrimitiveBatch::PolychromeSprites {
                    range, smoothed, ..
                } => {
                    for item in &scene.polychrome_sprites[range.clone()] {
                        target.draw_sprite(
                            item.bounds,
                            item.content_mask,
                            gpui::Hsla::new(0.0, 0.0, 0.0, 0.0),
                            item.tile,
                            None,
                            SpriteKind::Poly {
                                grayscale: item.grayscale == ShaderBool::Enabled,
                                opacity: item.opacity,
                                shape: crate::shaders::host::RoundedRectShader::new(
                                    item.bounds,
                                    item.corner_radii,
                                    item.corner_smoothing,
                                    *smoothed,
                                ),
                            },
                            atlas,
                            font,
                        )?;
                    }
                }
                gpui::PrimitiveBatch::Paths { range, .. } => {
                    target.draw_paths(&scene.paths[range.clone()]);
                }
                gpui::PrimitiveBatch::Surfaces(range) => {
                    if !range.is_empty() {
                        bail!("CPU renderer does not support native surfaces");
                    }
                }
                gpui::PrimitiveBatch::BackdropFilters(range) => {
                    for item in &scene.backdrop_filters[range.clone()] {
                        target.backdrop_filter(item);
                    }
                }
                gpui::PrimitiveBatch::FilterBoundary(_) => {
                    bail!("uncompiled filter boundary in Scene render command stream")
                }
            },
            gpui::RenderCommand::BeginFilter {
                boundary_index,
                target: render_target,
            } => {
                let boundary = &scene.filter_boundaries[*boundary_index];
                if matches!(render_target, FilterRenderTarget::Isolated(_)) {
                    stack.push(Some(FilterFrame {
                        parent: std::mem::replace(&mut target, Frame::new(width, height)),
                        boundary: boundary.clone(),
                        render_target: *render_target,
                    }));
                } else {
                    stack.push(None);
                }
            }
            gpui::RenderCommand::EndFilter {
                target: render_target,
                ..
            } => {
                let Some(frame) = stack.pop().context("unbalanced filter end command")? else {
                    continue;
                };
                ensure!(
                    frame.boundary.is_start && frame.render_target == *render_target,
                    "mismatched CPU filter command stream"
                );
                let mut child = std::mem::replace(&mut target, frame.parent);
                child.apply_filters(&frame.boundary.filters, frame.boundary.bounds);
                target.composite_filtered(child, &frame.boundary);
            }
        }
    }
    ensure!(stack.is_empty(), "unclosed CPU filter group");
    Ok(target)
}

/// Replays a compiled scene into an RGBA image with the supplied CPU atlas.
pub fn render_scene_to_image(
    scene: &Scene,
    size: Size<DevicePixels>,
    atlas: &CpuAtlas,
) -> Result<RgbaImage> {
    Ok(replay_frame(
        scene,
        size,
        atlas,
        crate::font::FontRasterizationSettings::default().uniforms(),
        None,
    )?
    .to_image())
}

struct FilterFrame {
    parent: Frame,
    boundary: gpui::FilterBoundary,
    render_target: FilterRenderTarget,
}

#[cfg(test)]
mod tests;
