//! Portable software replay of the compiled GPUI render command stream.
//!
//! This backend is intended for deterministic tests and screenshot capture. Geometry and
//! coverage use the same Rust-authored shader helpers as the GPU backend; atlas uploads remain
//! byte-identical to the glyph and image data supplied by GPUI.

use anyhow::{Context, Result, bail, ensure};
use gpui::{
    AtlasTextureKind, CapturedBitmap, DevicePixels, FilterRenderTarget, PlatformAtlas,
    PlatformHeadlessRenderer as PlatformHeadlessRendererTrait, Scene, ShaderBool, Size,
};
use image::RgbaImage;
use std::sync::Arc;

/// A deterministic CPU implementation of GPUI's headless rendering interfaces.
#[derive(Default)]
pub struct CpuRenderer {
    atlas: Arc<CpuAtlas>,
    font: crate::font::FontRasterizationSettings,
}

mod atlas;
mod frame;
pub use atlas::CpuAtlas;
use frame::{Frame, SpriteKind};

fn channels(kind: AtlasTextureKind) -> usize {
    if kind == AtlasTextureKind::Monochrome {
        1
    } else {
        4
    }
}
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
        }
    }

    /// Creates an atlas from SceneCapture's canonical bitmap vector.
    pub fn from_captured_bitmaps(bitmaps: &[CapturedBitmap]) -> Result<Self> {
        Ok(Self {
            atlas: Arc::new(CpuAtlas::from_captured_bitmaps(bitmaps)?),
            font: Default::default(),
        })
    }

    /// Uses explicit platform text settings instead of neutral portable coverage.
    pub fn with_font_rasterization(
        mut self,
        settings: crate::font::FontRasterizationSettings,
    ) -> Self {
        self.font = settings;
        self
    }
}

impl PlatformHeadlessRendererTrait for CpuRenderer {
    fn render_scene_to_image(
        &mut self,
        scene: &Scene,
        size: Size<DevicePixels>,
    ) -> Result<RgbaImage> {
        render_scene(scene, size, &self.atlas, self.font.uniforms())
    }

    fn render_scene(&mut self, scene: &Scene, size: Size<DevicePixels>) -> Result<()> {
        let _ = render_scene(scene, size, &self.atlas, self.font.uniforms())?;
        Ok(())
    }

    fn sprite_atlas(&self) -> Arc<dyn PlatformAtlas> {
        self.atlas.clone()
    }
}

fn render_scene(
    scene: &Scene,
    size: Size<DevicePixels>,
    atlas: &CpuAtlas,
    font: crate::shaders::common::FontRasterizationUniforms,
) -> Result<RgbaImage> {
    ensure!(
        size.width.0 >= 0 && size.height.0 >= 0,
        "CPU renderer requires non-negative dimensions"
    );
    let width = size.width.0 as u32;
    let height = size.height.0 as u32;
    let mut target = Frame::new(width, height);
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
    Ok(target.to_image())
}

/// Replays a compiled scene into an RGBA image with the supplied CPU atlas.
pub fn render_scene_to_image(
    scene: &Scene,
    size: Size<DevicePixels>,
    atlas: &CpuAtlas,
) -> Result<RgbaImage> {
    render_scene(
        scene,
        size,
        atlas,
        crate::font::FontRasterizationSettings::default().uniforms(),
    )
}

struct FilterFrame {
    parent: Frame,
    boundary: gpui::FilterBoundary,
    render_target: FilterRenderTarget,
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui::{Bounds, ContentMask, Hsla, Point, ScaledPixels};

    fn scene_quad(bounds: Bounds<ScaledPixels>, color: Hsla) -> gpui::Quad {
        gpui::Quad {
            bounds,
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            background: color.into(),
            ..Default::default()
        }
    }
    fn bounds(x: f32, y: f32, w: f32, h: f32) -> Bounds<ScaledPixels> {
        Bounds {
            origin: Point {
                x: ScaledPixels(x),
                y: ScaledPixels(y),
            },
            size: Size {
                width: ScaledPixels(w),
                height: ScaledPixels(h),
            },
        }
    }

    #[test]
    fn shader_quad_pixel_uses_production_coverage_and_premultiplies() {
        let quad = scene_quad(bounds(0., 0., 2., 2.), Hsla::new(0., 1., 0.5, 0.5));
        let color =
            crate::shaders::host::QuadShader::new(&quad, false).sample(wgsl_rs::std::vec2f(1., 1.));
        assert!((color[0] - 0.5).abs() < 0.002);
        assert!(color[1] < 0.002 && color[2] < 0.002);
        assert!((color[3] - 0.5).abs() < 0.002);
    }

    #[test]
    fn source_over_preserves_premultiplied_alpha_order() {
        let mut frame = Frame::new(1, 1);
        frame.over_at(0, 0, [0., 0., 0.5, 0.5]);
        frame.over_at(0, 0, [0.5, 0., 0., 0.5]);
        let pixel = frame.pixels[0];
        assert_eq!(pixel, [0.5, 0., 0.25, 0.75]);
    }

    #[test]
    fn content_mask_clips_quad_pixels_even_without_fade_edges() {
        let mut scene = Scene::default();
        let mut quad = scene_quad(bounds(0., 0., 4., 1.), Hsla::new(0., 1., 0.5, 1.));
        quad.content_mask = ContentMask {
            bounds: bounds(1., 0., 2., 1.),
            ..Default::default()
        };
        scene.insert_primitive(quad);
        scene.finish();
        let image = render_scene_to_image(
            &scene,
            Size {
                width: DevicePixels(4),
                height: DevicePixels(1),
            },
            &CpuAtlas::new(),
        )
        .unwrap();
        assert_eq!(image.get_pixel(0, 0).0[3], 0);
        assert!(image.get_pixel(1, 0).0[3] > 0);
        assert_eq!(image.get_pixel(3, 0).0[3], 0);
    }

    #[test]
    fn nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target() {
        let area = bounds(0., 0., 5., 5.);
        let boundary = |order: u32, is_start: bool| gpui::FilterBoundary {
            order,
            bounds: area,
            content_mask: ContentMask {
                bounds: area,
                ..Default::default()
            },
            corner_radii: gpui::Corners::default(),
            corner_smoothing: 0.,
            filters: smallvec::smallvec![gpui::ScaledFilter::Blur(ScaledPixels(0.5))],
            opacity: 0.5,
            is_start,
        };
        let mut scene = Scene::default();
        scene.filter_boundaries = vec![
            boundary(0, true),
            boundary(1, true),
            boundary(2, true),
            boundary(4, false),
            boundary(5, false),
            boundary(6, false),
        ];
        let mut quad = scene_quad(area, Hsla::new(0., 1., 0.5, 1.));
        quad.order = 3;
        scene.quads.push(quad);
        scene.finish();
        let commands = scene.render_commands();
        let isolated = commands
            .iter()
            .filter(|command| {
                matches!(
                    command,
                    gpui::RenderCommand::BeginFilter {
                        target: FilterRenderTarget::Isolated(_),
                        ..
                    }
                )
            })
            .count();
        let inline = commands
            .iter()
            .filter(|command| {
                matches!(
                    command,
                    gpui::RenderCommand::BeginFilter {
                        target: FilterRenderTarget::Inline,
                        ..
                    }
                )
            })
            .count();
        assert_eq!((isolated, inline), (2, 1));
        let image = render_scene_to_image(
            &scene,
            Size {
                width: DevicePixels(5),
                height: DevicePixels(5),
            },
            &CpuAtlas::new(),
        )
        .unwrap();
        assert_eq!(image.get_pixel(2, 2).0, [255, 0, 0, 64]);
    }

    #[test]
    fn wavy_underline_coverage_changes_along_the_shader_wave() {
        let line = gpui::Underline {
            order: gpui::DrawOrder::default(),
            padding: 0,
            bounds: bounds(0., 0., 40., 4.),
            content_mask: ContentMask {
                bounds: bounds(0., 0., 40., 4.),
                ..Default::default()
            },
            color: Hsla::new(0., 0., 0., 1.).into(),
            thickness: ScaledPixels(1.),
            wavy: ShaderBool::Enabled,
        };
        let coverage = (0..4)
            .map(|x| {
                crate::shaders::host::wavy_underline_coverage(
                    &line,
                    wgsl_rs::std::vec2f(x as f32 * 5.0 + 0.5, 2.0),
                )
            })
            .collect::<Vec<_>>();
        assert!(coverage.iter().any(|value| *value > 0.5));
        assert!(coverage.iter().any(|value| *value < 0.5));
    }
}
