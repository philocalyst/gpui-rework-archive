use super::CpuAtlas;
use anyhow::Result;
use gpui::{
    AtlasTextureKind, AtlasTile, Bounds, CapturedBitmap, ContentMask, ScaledPixels, ShaderBool,
};
use image::{Rgba, RgbaImage};

#[derive(Clone, Copy)]
pub(super) enum SpriteKind {
    Mono,
    Subpixel,
    Poly {
        grayscale: bool,
        opacity: f32,
        corner_radii: gpui::Corners<ScaledPixels>,
        corner_smoothing: f32,
        smoothed: bool,
    },
}
#[derive(Clone)]
pub(super) struct Frame {
    pub(super) width: u32,
    pub(super) height: u32,
    pub(super) pixels: Vec<[f32; 4]>,
}
impl Frame {
    pub(super) fn new(width: u32, height: u32) -> Self {
        Self {
            width,
            height,
            pixels: vec![[0.; 4]; width as usize * height as usize],
        }
    }
    pub(super) fn to_image(&self) -> RgbaImage {
        let mut image = RgbaImage::new(self.width, self.height);
        for (index, px) in self.pixels.iter().enumerate() {
            let alpha = px[3].clamp(0., 1.);
            let unpremul = if alpha > 0. {
                [px[0] / alpha, px[1] / alpha, px[2] / alpha]
            } else {
                [0.; 3]
            };
            image.put_pixel(
                (index % self.width as usize) as u32,
                (index / self.width as usize) as u32,
                Rgba([
                    channel(unpremul[0]),
                    channel(unpremul[1]),
                    channel(unpremul[2]),
                    channel(alpha),
                ]),
            );
        }
        image
    }
    pub(super) fn over_at(&mut self, x: i32, y: i32, color: [f32; 4]) {
        if x < 0 || y < 0 || x >= self.width as i32 || y >= self.height as i32 {
            return;
        }
        let below = &mut self.pixels[y as usize * self.width as usize + x as usize];
        let inverse = 1. - color[3].clamp(0., 1.);
        below[0] = color[0] + below[0] * inverse;
        below[1] = color[1] + below[1] * inverse;
        below[2] = color[2] + below[2] * inverse;
        below[3] = color[3] + below[3] * inverse;
    }
    fn path_over_at(&mut self, x: i32, y: i32, color: [f32; 4]) {
        if x < 0 || y < 0 || x >= self.width as i32 || y >= self.height as i32 {
            return;
        }
        let below = &mut self.pixels[y as usize * self.width as usize + x as usize];
        let inverse = 1. - color[3].clamp(0., 1.);
        below[0] = color[0] + below[0] * inverse;
        below[1] = color[1] + below[1] * inverse;
        below[2] = color[2] + below[2] * inverse;
        // Path pipeline uses additive alpha blending while keeping RGB source-over.
        below[3] = (color[3] + below[3]).clamp(0., 1.);
    }
    fn pixel_range(&self, bounds: Bounds<ScaledPixels>) -> (i32, i32, i32, i32) {
        let x0 = bounds.origin.x.0.floor() as i32;
        let y0 = bounds.origin.y.0.floor() as i32;
        let x1 = (bounds.origin.x.0 + bounds.size.width.0).ceil() as i32;
        let y1 = (bounds.origin.y.0 + bounds.size.height.0).ceil() as i32;
        (
            x0.max(0),
            y0.max(0),
            x1.min(self.width as i32),
            y1.min(self.height as i32),
        )
    }
    pub(super) fn draw_quad(&mut self, quad: &gpui::Quad, smoothed: bool) -> Result<()> {
        let shader = crate::shaders::host::QuadShader::new(quad, smoothed);
        let (x0, y0, x1, y1) = self.pixel_range(quad.bounds);
        for y in y0..y1 {
            for x in x0..x1 {
                let p = wgsl_rs::std::vec2f(x as f32 + 0.5, y as f32 + 0.5);
                if !contains_fragment(quad.bounds, p)
                    || crate::shaders::host::is_clipped(quad.content_mask, p)
                {
                    continue;
                }
                let color = shader.sample(p);
                self.over_at(x, y, color);
            }
        }
        Ok(())
    }
    pub(super) fn draw_shadow(&mut self, shadow: &gpui::Shadow, smoothed: bool) -> Result<()> {
        let shader = crate::shaders::host::ShadowShader::new(shadow, smoothed);
        let shader_bounds = shader.bounds();
        let bounds = Bounds {
            origin: gpui::point(
                gpui::ScaledPixels(shader_bounds.origin.x),
                gpui::ScaledPixels(shader_bounds.origin.y),
            ),
            size: gpui::size(
                gpui::ScaledPixels(shader_bounds.size.x),
                gpui::ScaledPixels(shader_bounds.size.y),
            ),
        };
        let (x0, y0, x1, y1) = self.pixel_range(bounds);
        for y in y0..y1 {
            for x in x0..x1 {
                let p = wgsl_rs::std::vec2f(x as f32 + 0.5, y as f32 + 0.5);
                if !contains_fragment(bounds, p)
                    || crate::shaders::host::is_clipped(shadow.content_mask, p)
                {
                    continue;
                }
                self.over_at(x, y, shader.sample(p));
            }
        }
        Ok(())
    }
    pub(super) fn draw_underline(&mut self, item: &gpui::Underline) {
        let (x0, y0, x1, y1) = self.pixel_range(item.bounds);
        for y in y0..y1 {
            for x in x0..x1 {
                let p = wgsl_rs::std::vec2f(x as f32 + 0.5, y as f32 + 0.5);
                if !contains_fragment(item.bounds, p)
                    || crate::shaders::host::is_clipped(item.content_mask, p)
                {
                    continue;
                }
                let coverage = if item.wavy == ShaderBool::Enabled {
                    crate::shaders::host::wavy_underline_coverage(item, p)
                } else {
                    1.
                };
                let mask = crate::shaders::host::content_alpha(item.content_mask, p);
                let color = crate::shaders::host::hsla(item.color.into());
                self.over_at(
                    x,
                    y,
                    [
                        color[0] * color[3] * coverage * mask,
                        color[1] * color[3] * coverage * mask,
                        color[2] * color[3] * coverage * mask,
                        color[3] * coverage * mask,
                    ],
                );
            }
        }
    }
    pub(super) fn draw_sprite(
        &mut self,
        bounds: Bounds<ScaledPixels>,
        mask: ContentMask<ScaledPixels>,
        color: gpui::Hsla,
        tile: AtlasTile,
        transform: Option<gpui::TransformationMatrix>,
        kind: SpriteKind,
        atlas: &CpuAtlas,
        font: crate::shaders::common::FontRasterizationUniforms,
    ) -> Result<()> {
        let bitmap = atlas.resolve(tile)?;
        let m = transform;
        let (x0, y0, x1, y1) = if let Some(m) = m {
            transformed_range(self, bounds, m)
        } else {
            self.pixel_range(bounds)
        };
        let color = crate::shaders::host::hsla(color);
        for y in y0..y1 {
            for x in x0..x1 {
                let p = [x as f32 + 0.5, y as f32 + 0.5];
                let local = if let Some(m) = m {
                    inverse_transform(m, p)
                } else {
                    p
                };
                let unit = [
                    (local[0] - bounds.origin.x.0) / bounds.size.width.0,
                    (local[1] - bounds.origin.y.0) / bounds.size.height.0,
                ];
                if unit[0] < 0. || unit[1] < 0. || unit[0] >= 1. || unit[1] >= 1. {
                    continue;
                }
                let sample = sample_bitmap(&bitmap, unit[0], unit[1]);
                let point = wgsl_rs::std::vec2f(p[0], p[1]);
                if crate::shaders::host::is_clipped(mask, point) {
                    continue;
                }
                let fade = crate::shaders::host::content_alpha(mask, point);
                match kind {
                    SpriteKind::Mono => {
                        let alpha = crate::shaders::host::monochrome_correction(
                            sample[0],
                            [color[0], color[1], color[2]],
                            font,
                        ) * color[3]
                            * fade;
                        self.over_at(
                            x,
                            y,
                            [color[0] * alpha, color[1] * alpha, color[2] * alpha, alpha],
                        );
                    }
                    SpriteKind::Poly {
                        grayscale,
                        opacity,
                        corner_radii,
                        corner_smoothing,
                        smoothed,
                    } => {
                        let rgb = crate::shaders::host::polychrome_color(sample, grayscale);
                        let coverage = crate::shaders::host::sprite_corner_coverage(
                            bounds,
                            corner_radii,
                            corner_smoothing,
                            point,
                            smoothed,
                        );
                        let alpha = sample[3] * opacity * coverage * fade;
                        self.over_at(
                            x,
                            y,
                            [rgb[0] * alpha, rgb[1] * alpha, rgb[2] * alpha, alpha],
                        );
                    }
                    SpriteKind::Subpixel => {
                        let corrected = crate::shaders::host::subpixel_correction(
                            [sample[0], sample[1], sample[2]],
                            [color[0], color[1], color[2]],
                            font,
                        );
                        let alphas = [
                            corrected[0] * color[3] * fade,
                            corrected[1] * color[3] * fade,
                            corrected[2] * color[3] * fade,
                        ];
                        let index = y as usize * self.width as usize + x as usize;
                        let below = &mut self.pixels[index];
                        below[0] = color[0] * alphas[0] + below[0] * (1. - alphas[0]);
                        below[1] = color[1] * alphas[1] + below[1] * (1. - alphas[1]);
                        below[2] = color[2] * alphas[2] + below[2] * (1. - alphas[2]);
                        // The dual-source pipeline writes primary alpha 1.0 and uses it for
                        // the target alpha blend component, so covered fragments make the
                        // destination alpha opaque even though RGB coverage is per channel.
                        below[3] = 1.0;
                    }
                }
            }
        }
        Ok(())
    }
    pub(super) fn draw_paths(&mut self, paths: &[gpui::Path<ScaledPixels>]) -> Result<()> {
        // Paths rasterize into a cleared target using additive alpha, then their
        // clipped sprites composite into the scene using ordinary source-over.
        let mut rasterized = Frame::new(self.width, self.height);
        for path in paths {
            rasterized.draw_path(path)?;
        }
        for sprite in crate::path_types::sprites(paths) {
            let (x0, y0, x1, y1) = self.pixel_range(sprite.bounds);
            for y in y0..y1 {
                for x in x0..x1 {
                    if !contains_fragment(
                        sprite.bounds,
                        wgsl_rs::std::vec2f(x as f32 + 0.5, y as f32 + 0.5),
                    ) {
                        continue;
                    }
                    let pixel = rasterized.pixels[y as usize * self.width as usize + x as usize];
                    self.over_at(x, y, pixel);
                }
            }
        }
        Ok(())
    }

    fn draw_path(&mut self, path: &gpui::Path<ScaledPixels>) -> Result<()> {
        let bounds = path.clipped_bounds();
        let paint = crate::shaders::host::PaintShader::new(path.color, bounds);
        let (x0, y0, x1, y1) = self.pixel_range(bounds);
        for triangle in path.vertices.chunks_exact(3) {
            let vertices: [&gpui::PathVertex<ScaledPixels>; 3] =
                [&triangle[0], &triangle[1], &triangle[2]];
            let points = vertices.map(|v| [v.xy_position.x.0, v.xy_position.y.0]);
            let st = vertices.map(|v| [v.st_position.x, v.st_position.y]);
            let min_x = points
                .iter()
                .map(|p| p[0])
                .fold(f32::INFINITY, f32::min)
                .floor() as i32;
            let max_x = points
                .iter()
                .map(|p| p[0])
                .fold(f32::NEG_INFINITY, f32::max)
                .ceil() as i32;
            let min_y = points
                .iter()
                .map(|p| p[1])
                .fold(f32::INFINITY, f32::min)
                .floor() as i32;
            let max_y = points
                .iter()
                .map(|p| p[1])
                .fold(f32::NEG_INFINITY, f32::max)
                .ceil() as i32;
            let (tx0, ty0, tx1, ty1) = (min_x.max(x0), min_y.max(y0), max_x.min(x1), max_y.min(y1));
            for y in ty0..ty1 {
                for x in tx0..tx1 {
                    let p = [x as f32 + 0.5, y as f32 + 0.5];
                    if crate::shaders::common::is_clipped(crate::shaders::common::clip_distances(
                        wgsl_rs::std::vec2f(p[0], p[1]),
                        bounds.into(),
                    )) {
                        continue;
                    }
                    let Some((weights, derivatives)) = barycentric(p, points) else {
                        continue;
                    };
                    if !triangle_contains_half_open(points, weights) {
                        continue;
                    }
                    let curve = [
                        weights[0] * st[0][0] + weights[1] * st[1][0] + weights[2] * st[2][0],
                        weights[0] * st[0][1] + weights[1] * st[1][1] + weights[2] * st[2][1],
                    ];
                    let dx =
                        [0, 1].map(|axis| (0..3).map(|i| derivatives[i][axis] * st[i][0]).sum());
                    let dy =
                        [0, 1].map(|axis| (0..3).map(|i| derivatives[i][axis] * st[i][1]).sum());
                    let coverage = if st.iter().all(|v| v[1] == 1.) {
                        1.
                    } else {
                        crate::shaders::host::quadratic_path_coverage(curve, dx, dy)
                    };
                    let color = paint.sample(wgsl_rs::std::vec2f(p[0], p[1]));
                    let alpha = color[3] * coverage;
                    self.path_over_at(
                        x,
                        y,
                        [color[0] * alpha, color[1] * alpha, color[2] * alpha, alpha],
                    );
                }
            }
        }
        Ok(())
    }
    pub(super) fn backdrop_filter(&mut self, filter: &gpui::BackdropFilter) -> Result<()> {
        let mut filtered = self.clone();
        filtered.apply_filters(&filter.filters, filter.bounds);
        let (x0, y0, x1, y1) = self.pixel_range(filter.bounds);
        for y in y0..y1 {
            for x in x0..x1 {
                let p = wgsl_rs::std::vec2f(x as f32 + 0.5, y as f32 + 0.5);
                if !contains_fragment(filter.bounds, p)
                    || crate::shaders::host::is_clipped(filter.content_mask, p)
                {
                    continue;
                }
                let shape = crate::shaders::host::rounded_rect_coverage(
                    filter.bounds,
                    filter.corner_radii,
                    p,
                    filter.corner_smoothing,
                );
                let mask = crate::shaders::host::content_alpha(filter.content_mask, p);
                let factor = shape * mask * filter.opacity;
                let index = y as usize * self.width as usize + x as usize;
                let blur = filtered.pixels[index];
                self.over_at(
                    x,
                    y,
                    [
                        blur[0] * factor,
                        blur[1] * factor,
                        blur[2] * factor,
                        blur[3] * factor,
                    ],
                );
            }
        }
        Ok(())
    }
    pub(super) fn apply_filters(
        &mut self,
        filters: &[gpui::ScaledFilter],
        bounds: Bounds<ScaledPixels>,
    ) {
        // The production filter pass coalesces blur declarations into one maximum radius.
        let radius = filters
            .iter()
            .map(|filter| match filter {
                gpui::ScaledFilter::Blur(radius) => radius.0,
            })
            .fold(0.0, f32::max);
        self.gaussian_blur(radius, bounds);
    }
    pub(super) fn composite_filtered(&mut self, child: Frame, boundary: &gpui::FilterBoundary) {
        let dilation = gpui::ScaledPixels(
            boundary.max_blur_radius() * crate::blur::GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS,
        );
        let composite_bounds = boundary.bounds.dilate(dilation);
        let (x0, y0, x1, y1) = self.pixel_range(composite_bounds);
        for y in y0..y1 {
            for x in x0..x1 {
                let p = wgsl_rs::std::vec2f(x as f32 + 0.5, y as f32 + 0.5);
                if !contains_fragment(composite_bounds, p)
                    || crate::shaders::host::is_clipped(boundary.content_mask, p)
                {
                    continue;
                }
                let mask = crate::shaders::host::content_alpha(boundary.content_mask, p);
                let factor = mask * boundary.opacity;
                let index = y as usize * self.width as usize + x as usize;
                let src = child.pixels[index];
                self.over_at(
                    x,
                    y,
                    [
                        src[0] * factor,
                        src[1] * factor,
                        src[2] * factor,
                        src[3] * factor,
                    ],
                );
            }
        }
    }
    fn gaussian_blur(&mut self, sigma: f32, bounds: Bounds<ScaledPixels>) {
        if self.width == 0 || self.height == 0 {
            return;
        }
        let Some(kernel) = crate::blur::BlurKernel::for_radius(sigma) else {
            return;
        };
        let width = crate::blur::downsampled_dimension(self.width);
        let height = crate::blur::downsampled_dimension(self.height);
        let dilation = gpui::ScaledPixels(crate::blur::GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS * sigma);
        let scissor = crate::blur::ScissorRectangle::for_blurred_bounds(
            bounds,
            dilation.0,
            self.width,
            self.height,
        );
        if scissor.is_empty() {
            return;
        }
        let mut downsampled = Frame::new(width, height);
        for y in scissor.y..(scissor.y + scissor.height).min(height) {
            for x in scissor.x..(scissor.x + scissor.width).min(width) {
                let u = ((x as f32 + 0.5) / width as f32)
                    .min((self.width as f32 - 0.5) / self.width as f32);
                let v = ((y as f32 + 0.5) / height as f32)
                    .min((self.height as f32 - 0.5) / self.height as f32);
                downsampled.pixels[y as usize * width as usize + x as usize] =
                    sample_frame_linear(self, u, v);
            }
        }
        let horizontal = blur_pass(&downsampled, kernel, true, scissor);
        let vertical = blur_pass(&horizontal, kernel, false, scissor);
        let composite_bounds = bounds.dilate(dilation);
        let (x0, y0, x1, y1) = self.pixel_range(composite_bounds);
        let mut output = Frame::new(self.width, self.height);
        for y in y0..y1 {
            for x in x0..x1 {
                output.pixels[y as usize * self.width as usize + x as usize] = sample_frame_linear(
                    &vertical,
                    (x as f32 + 0.5) / self.width as f32,
                    (y as f32 + 0.5) / self.height as f32,
                );
            }
        }
        self.pixels = output.pixels;
    }
}

// Rectangle rasterization and fragment clipping are separate: geometry uses half-open
// edges, while shader clip distances allow a zero distance at the content-mask edge.
fn contains_fragment(bounds: Bounds<ScaledPixels>, point: wgsl_rs::std::Vec2f) -> bool {
    point.x >= bounds.origin.x.0
        && point.y >= bounds.origin.y.0
        && point.x < bounds.origin.x.0 + bounds.size.width.0
        && point.y < bounds.origin.y.0 + bounds.size.height.0
}

fn blur_pass(
    source: &Frame,
    kernel: crate::blur::BlurKernel,
    horizontal: bool,
    scissor: crate::blur::ScissorRectangle,
) -> Frame {
    let mut target = Frame::new(source.width, source.height);
    let weights = (0..=kernel.sample_count)
        .map(|index| {
            crate::shaders::host::gaussian(
                index as f32 * kernel.sample_step,
                kernel.standard_deviation,
            )
        })
        .collect::<Vec<_>>();
    let weight_sum = weights[0] + weights.iter().skip(1).sum::<f32>() * 2.0;
    for y in scissor.y..(scissor.y + scissor.height).min(source.height) {
        for x in scissor.x..(scissor.x + scissor.width).min(source.width) {
            let u = (x as f32 + 0.5) / source.width as f32;
            let v = (y as f32 + 0.5) / source.height as f32;
            let mut color = sample_frame_linear(source, u, v);
            for channel in 0..4 {
                color[channel] *= weights[0];
            }
            for index in 1..=kernel.sample_count {
                let distance = index as f32 * kernel.sample_step;
                let delta = if horizontal {
                    [distance / source.width as f32, 0.0]
                } else {
                    [0.0, distance / source.height as f32]
                };
                let before = sample_frame_linear(source, u - delta[0], v - delta[1]);
                let after = sample_frame_linear(source, u + delta[0], v + delta[1]);
                for channel in 0..4 {
                    color[channel] += (before[channel] + after[channel]) * weights[index as usize];
                }
            }
            for channel in 0..4 {
                color[channel] /= weight_sum.max(0.00001);
            }
            target.pixels[y as usize * source.width as usize + x as usize] = color;
        }
    }
    target
}

fn sample_frame_linear(frame: &Frame, u: f32, v: f32) -> [f32; 4] {
    let x = u * frame.width as f32 - 0.5;
    let y = v * frame.height as f32 - 0.5;
    let x0 = x.floor() as i32;
    let y0 = y.floor() as i32;
    let tx = x - x.floor();
    let ty = y - y.floor();
    let pixel = |x: i32, y: i32| {
        frame.pixels[y.clamp(0, frame.height as i32 - 1) as usize * frame.width as usize
            + x.clamp(0, frame.width as i32 - 1) as usize]
    };
    let a = pixel(x0, y0);
    let b = pixel(x0 + 1, y0);
    let c = pixel(x0, y0 + 1);
    let d = pixel(x0 + 1, y0 + 1);
    let mut result = [0.0; 4];
    for index in 0..4 {
        result[index] = (a[index] * (1.0 - tx) + b[index] * tx) * (1.0 - ty)
            + (c[index] * (1.0 - tx) + d[index] * tx) * ty;
    }
    result
}
fn channel(v: f32) -> u8 {
    (v.clamp(0., 1.) * 255. + 0.5) as u8
}

fn transformed_range(
    frame: &Frame,
    bounds: Bounds<ScaledPixels>,
    transform: gpui::TransformationMatrix,
) -> (i32, i32, i32, i32) {
    let pts = [[0.0, 0.0], [1., 0.], [0., 1.], [1., 1.]].map(|u| {
        transform_position(
            transform,
            [
                bounds.origin.x.0 + u[0] * bounds.size.width.0,
                bounds.origin.y.0 + u[1] * bounds.size.height.0,
            ],
        )
    });
    let x0 = pts
        .iter()
        .map(|p| p[0])
        .fold(f32::INFINITY, f32::min)
        .floor() as i32;
    let x1 = pts
        .iter()
        .map(|p| p[0])
        .fold(f32::NEG_INFINITY, f32::max)
        .ceil() as i32;
    let y0 = pts
        .iter()
        .map(|p| p[1])
        .fold(f32::INFINITY, f32::min)
        .floor() as i32;
    let y1 = pts
        .iter()
        .map(|p| p[1])
        .fold(f32::NEG_INFINITY, f32::max)
        .ceil() as i32;
    (
        x0.max(0),
        y0.max(0),
        x1.min(frame.width as i32),
        y1.min(frame.height as i32),
    )
}
fn transform_position(transform: gpui::TransformationMatrix, p: [f32; 2]) -> [f32; 2] {
    let m = transform.rotation_scale;
    let t = transform.translation;
    [
        m[0][0] * p[0] + m[1][0] * p[1] + t[0],
        m[0][1] * p[0] + m[1][1] * p[1] + t[1],
    ]
}
fn inverse_transform(transform: gpui::TransformationMatrix, p: [f32; 2]) -> [f32; 2] {
    let m = transform.rotation_scale;
    let tx = p[0] - transform.translation[0];
    let ty = p[1] - transform.translation[1];
    let a = m[0][0];
    let b = m[1][0];
    let c = m[0][1];
    let d = m[1][1];
    let det = a * d - b * c;
    if det.abs() < 1e-8 {
        return [f32::NAN, f32::NAN];
    }
    [(d * tx - b * ty) / det, (-c * tx + a * ty) / det]
}
fn barycentric(p: [f32; 2], v: [[f32; 2]; 3]) -> Option<([f32; 3], [[f32; 2]; 3])> {
    let den = (v[1][1] - v[2][1]) * (v[0][0] - v[2][0]) + (v[2][0] - v[1][0]) * (v[0][1] - v[2][1]);
    if den.abs() < 1e-8 {
        return None;
    }
    let l0 =
        ((v[1][1] - v[2][1]) * (p[0] - v[2][0]) + (v[2][0] - v[1][0]) * (p[1] - v[2][1])) / den;
    let l1 =
        ((v[2][1] - v[0][1]) * (p[0] - v[2][0]) + (v[0][0] - v[2][0]) * (p[1] - v[2][1])) / den;
    let l2 = 1. - l0 - l1;
    let dl0 = [(v[1][1] - v[2][1]) / den, (v[2][0] - v[1][0]) / den];
    let dl1 = [(v[2][1] - v[0][1]) / den, (v[0][0] - v[2][0]) / den];
    let deriv = [dl0, dl1, [-dl0[0] - dl1[0], -dl0[1] - dl1[1]]];
    Some(([l0, l1, l2], deriv))
}

fn triangle_contains_half_open(points: [[f32; 2]; 3], weights: [f32; 3]) -> bool {
    const EDGE_EPSILON: f32 = 1e-6;
    if weights.iter().any(|weight| *weight < -EDGE_EPSILON) {
        return false;
    }
    // Adjacent triangles traverse a shared edge in opposite directions. Assign the edge to
    // only one triangle using a stable lexicographic half-open rule.
    let edges = [(1, 2), (2, 0), (0, 1)];
    weights.iter().enumerate().all(|(opposite, weight)| {
        *weight > EDGE_EPSILON || {
            let (a, b) = edges[opposite];
            let a = points[a];
            let b = points[b];
            a[0] < b[0] || (a[0] == b[0] && a[1] < b[1])
        }
    })
}
fn sample_bitmap(bitmap: &CapturedBitmap, u: f32, v: f32) -> [f32; 4] {
    let x = u * bitmap.width as f32 - 0.5;
    let y = v * bitmap.height as f32 - 0.5;
    let x0 = x.floor() as i32;
    let y0 = y.floor() as i32;
    let tx = x - x.floor();
    let ty = y - y.floor();
    let a = bitmap_pixel(bitmap, x0, y0);
    let b = bitmap_pixel(bitmap, x0 + 1, y0);
    let c = bitmap_pixel(bitmap, x0, y0 + 1);
    let d = bitmap_pixel(bitmap, x0 + 1, y0 + 1);
    let mut out = [0.; 4];
    for i in 0..4 {
        out[i] = (a[i] * (1. - tx) + b[i] * tx) * (1. - ty) + (c[i] * (1. - tx) + d[i] * tx) * ty;
    }
    out
}
fn bitmap_pixel(bitmap: &CapturedBitmap, x: i32, y: i32) -> [f32; 4] {
    let x = x.clamp(0, bitmap.width as i32 - 1) as usize;
    let y = y.clamp(0, bitmap.height as i32 - 1) as usize;
    let channels = if bitmap.kind == AtlasTextureKind::Monochrome {
        1
    } else {
        4
    };
    let index = (y * bitmap.width as usize + x) * channels;
    if channels == 1 {
        let alpha = bitmap.bytes[index] as f32 / 255.;
        [alpha, alpha, alpha, alpha]
    } else {
        [
            bitmap.bytes[index + 2] as f32 / 255.,
            bitmap.bytes[index + 1] as f32 / 255.,
            bitmap.bytes[index] as f32 / 255.,
            bitmap.bytes[index + 3] as f32 / 255.,
        ]
    }
}
