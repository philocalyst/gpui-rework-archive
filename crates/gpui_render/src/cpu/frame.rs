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
        shape: crate::shaders::host::RoundedRectShader,
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
    pub(super) fn resize_and_clear(&mut self, width: u32, height: u32) {
        self.width = width;
        self.height = height;
        self.pixels
            .resize(width as usize * height as usize, [0.; 4]);
        self.pixels.fill([0.; 4]);
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
    fn masked_pixel_range(
        &self,
        bounds: Bounds<ScaledPixels>,
        mask: ContentMask<ScaledPixels>,
    ) -> (i32, i32, i32, i32) {
        intersect_pixel_ranges(self.pixel_range(bounds), self.pixel_range(mask.bounds))
    }
}

mod filters;
mod primitives;

fn intersect_pixel_ranges(
    (x0, y0, x1, y1): (i32, i32, i32, i32),
    (mx0, my0, mx1, my1): (i32, i32, i32, i32),
) -> (i32, i32, i32, i32) {
    (x0.max(mx0), y0.max(my0), x1.min(mx1), y1.min(my1))
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
    use crate::shaders::common::TransformationMatrix;
    use wgsl_rs::std::{mat2x2f, vec2f};

    // The shader transposes GPUI's row-major bytes when applying the matrix.
    let rows = transform.rotation_scale;
    let position = TransformationMatrix::transform_position(
        TransformationMatrix {
            rotation_scale: mat2x2f(vec2f(rows[0][0], rows[0][1]), vec2f(rows[1][0], rows[1][1])),
            translation: vec2f(transform.translation[0], transform.translation[1]),
        },
        vec2f(p[0], p[1]),
    );
    [position.x, position.y]
}
fn inverse_transform(transform: gpui::TransformationMatrix, p: [f32; 2]) -> [f32; 2] {
    let m = transform.rotation_scale;
    let tx = p[0] - transform.translation[0];
    let ty = p[1] - transform.translation[1];
    let a = m[0][0];
    let b = m[0][1];
    let c = m[1][0];
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

#[cfg(test)]
mod transform_tests {
    use super::{inverse_transform, transform_position};
    use gpui::{TransformationMatrix, point, px};

    #[test]
    fn transformed_position_matches_the_scene_matrix_law() {
        // Deterministic generated affine transforms exercise rotation, shear, scale,
        // translation, and non-symmetric matrices without a property-test dependency.
        for index in 0..128 {
            let seed = index as f32 * 0.173;
            let transform = TransformationMatrix {
                rotation_scale: [
                    [seed.sin() * 2.0, (seed + 0.7).cos()],
                    [(seed + 1.1).sin(), (seed + 0.3).cos() * 1.5],
                ],
                translation: [seed * 0.25 - 3.0, 2.0 - seed * 0.125],
            };
            let determinant = transform.rotation_scale[0][0] * transform.rotation_scale[1][1]
                - transform.rotation_scale[0][1] * transform.rotation_scale[1][0];
            if determinant.abs() < 0.05 {
                continue;
            }
            let position = [seed * 1.7 - 4.0, (seed + 2.0).cos() * 5.0];
            let expected = transform.apply(point(px(position[0]), px(position[1])));
            let actual = transform_position(transform, position);
            assert!((actual[0] - f32::from(expected.x)).abs() < 1e-5);
            assert!((actual[1] - f32::from(expected.y)).abs() < 1e-5);

            let round_trip = inverse_transform(transform, actual);
            assert!((round_trip[0] - position[0]).abs() < 1e-4);
            assert!((round_trip[1] - position[1]).abs() < 1e-4);
        }
    }
}
