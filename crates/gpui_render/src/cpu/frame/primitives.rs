//! Primitives on the retained software frame.
use super::*;

impl Frame {
    pub(in crate::cpu) fn draw_quad(&mut self, quad: &gpui::Quad, smoothed: bool) {
        let shader = crate::shaders::host::QuadShader::new(quad, smoothed);
        let (x0, y0, x1, y1) = self.masked_pixel_range(quad.bounds, quad.content_mask);
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
    }
    pub(in crate::cpu) fn draw_shadow(&mut self, shadow: &gpui::Shadow, smoothed: bool) {
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
        let (x0, y0, x1, y1) = self.masked_pixel_range(bounds, shadow.content_mask);
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
    }
    pub(in crate::cpu) fn draw_underline(&mut self, item: &gpui::Underline) {
        let (x0, y0, x1, y1) = self.masked_pixel_range(item.bounds, item.content_mask);
        let color = crate::shaders::host::hsla(item.color.into());
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
    pub(in crate::cpu) fn draw_sprite(
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
        let bitmap = atlas.resolve_shared(tile)?;
        let m = transform;
        let range = if let Some(m) = m {
            transformed_range(self, bounds, m)
        } else {
            self.pixel_range(bounds)
        };
        let (x0, y0, x1, y1) = intersect_pixel_ranges(range, self.pixel_range(mask.bounds));
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
                        shape,
                    } => {
                        let rgb = crate::shaders::host::polychrome_color(sample, grayscale);
                        let coverage = shape.sample(point);
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
    pub(in crate::cpu) fn draw_paths(&mut self, paths: &[gpui::Path<ScaledPixels>]) {
        // Paths rasterize into a cleared target using additive alpha, then their
        // clipped sprites composite into the scene using ordinary source-over.
        let mut rasterized = Frame::new(self.width, self.height);
        for path in paths {
            rasterized.draw_path(path);
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
    }

    fn draw_path(&mut self, path: &gpui::Path<ScaledPixels>) {
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
    }
}
