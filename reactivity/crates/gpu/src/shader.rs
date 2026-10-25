//! A single fullscreen pass composites ordered tile records in linear light.
//! Sample-major evaluation keeps two vec4 accumulators rather than sixteen
//! live sample colors. It needs neither an MSAA image nor a float intermediate.
#[wgsl_rs::wgsl]
pub mod ui {
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct Draw {
        pub local: Vec4f,
        pub inverse_x: Vec4f,
        pub inverse_y: Vec4f,
        pub clip: Vec4f,
        pub color: Vec4f,
        pub atlas: Vec4u,
    }
    #[derive(Clone, Copy, Wgsl)]
    pub struct Globals {
        pub viewport: Vec4u,
        pub clear: Vec4f,
        pub mapping: Vec4f,
    }
    #[derive(Clone, Copy, Wgsl)]
    pub struct Correction {
        pub x: Vec4f,
        pub y: Vec4f,
    }
    uniform!(group(0), binding(0), GLOBALS: Globals);
    storage!(group(0), binding(1), DRAWS: RuntimeArray<Draw>);
    storage!(group(0), binding(2), TILES: RuntimeArray<Vec2u>);
    storage!(group(0), binding(3), INDICES: RuntimeArray<u32>);
    texture!(group(0), binding(4), MASKS: Texture2D<f32>);
    storage!(group(0), binding(5), CORRECTIONS: RuntimeArray<Correction>);

    #[vertex]
    pub fn vertex(#[builtin(vertex_index)] index: u32) -> Vec4f {
        const POINTS: [Vec2f; 3] = [vec2f(-1.0, -1.0), vec2f(3.0, -1.0), vec2f(-1.0, 3.0)];
        let point = POINTS[index as usize];
        vec4f(point.x, point.y, 0.0, 1.0)
    }

    // Two-float arithmetic improves decisions near a sample/texel boundary.
    // Bit splitting avoids relying on WGSL fma being genuinely fused. This is
    // still finite shader arithmetic, not a claim of portable IEEE f64 parity.
    pub fn pair_sum(a: f32, b: f32) -> Vec2f {
        let sum = a + b;
        let part = sum - a;
        vec2f(sum, (a - (sum - part)) + (b - part))
    }
    pub fn pair_add(a: Vec2f, b: Vec2f) -> Vec2f {
        let sum = pair_sum(a.x, b.x);
        vec2f(sum.x, (sum.y + a.y) + b.y)
    }
    pub fn pair_product(a: f32, b: f32) -> Vec2f {
        let product = a * b;
        let ah = bitcast_f32(bitcast_u32(a) & 0xfffff000);
        let bh = bitcast_f32(bitcast_u32(b) & 0xfffff000);
        let al = a - ah;
        let bl = b - bh;
        let error = ((ah * bh - product) + ah * bl + al * bh) + al * bl;
        vec2f(product, error)
    }
    pub fn pair_dot(high: Vec3f, low: Vec3f, point: Vec2f) -> Vec2f {
        let x = pair_add(pair_product(high.x, point.x), pair_product(low.x, point.x));
        let y = pair_add(pair_product(high.y, point.y), pair_product(low.y, point.y));
        pair_add(pair_add(x, y), vec2f(high.z, low.z))
    }
    pub fn pair_negative(value: Vec2f) -> bool {
        value.x < -value.y
    }
    pub fn pair_scale(value: Vec2f, scale: f32) -> Vec2f {
        pair_add(pair_product(value.x, scale), pair_product(value.y, scale))
    }
    pub fn pair_divide(value: Vec2f, divisor: f32) -> Vec2f {
        let quotient = value.x / divisor;
        let residual = pair_add(value, -pair_product(quotient, divisor));
        vec2f(quotient, (residual.x + residual.y) / divisor)
    }
    pub fn pair_floor(value: Vec2f) -> f32 {
        let integer = floor(value.x);
        if value.x - integer < -value.y {
            return integer - 1.0;
        }
        if value.x - integer >= 1.0 - value.y {
            return integer + 1.0;
        }
        integer
    }

    pub fn outside_clip_max(
        point: f32,
        start: f32,
        extent: f32,
        index: u32,
        vertical: bool,
    ) -> bool {
        let end = start + extent;
        if point != end {
            return point > end;
        }
        // Only equality with the rounded endpoint is ambiguous. Preserve the
        // addition's low lane: a positive residual still includes this sample.
        let correction = get!(CORRECTIONS)[index as usize];
        if vertical {
            return correction.y.w <= 0.0;
        }
        correction.x.w <= 0.0
    }

    pub fn sample_draw(draw: Draw, point: Vec2f) -> Vec4f {
        if point.x < draw.clip.x
            || point.y < draw.clip.y
            || outside_clip_max(point.x, draw.clip.x, draw.clip.z, draw.atlas.w, false)
            || outside_clip_max(point.y, draw.clip.y, draw.clip.w, draw.atlas.w, true)
        {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        let h = vec3f(point.x, point.y, 1.0);
        let local = vec2f(dot(draw.inverse_x.xyz(), h), dot(draw.inverse_y.xyz(), h));
        let position = local - draw.local.xy();
        let error = vec2f(draw.inverse_x.w, draw.inverse_y.w);
        let edges = min(abs(position), abs(position - draw.local.zw()));
        let dimensions = vec2f((draw.atlas.z & 65535) as f32, (draw.atlas.z >> 16) as f32);
        let mapped = position * dimensions / draw.local.zw();
        let fraction = fract(mapped);
        let texels = min(fraction, vec2f(1.0, 1.0) - fraction);
        let texel_error =
            error * dimensions / draw.local.zw() + (abs(mapped) + vec2f(1.0, 1.0)) * 3.8146973e-6;
        let correct = edges.x <= error.x
            || edges.y <= error.y
            || (draw.atlas.z > 0 && (texels.x <= texel_error.x || texels.y <= texel_error.y));
        let mut cell = floor(mapped);
        if correct {
            let correction = get!(CORRECTIONS)[draw.atlas.w as usize];
            let x = pair_add(
                pair_dot(draw.inverse_x.xyz(), correction.x.xyz(), point),
                vec2f(-draw.local.x, 0.0),
            );
            let y = pair_add(
                pair_dot(draw.inverse_y.xyz(), correction.y.xyz(), point),
                vec2f(-draw.local.y, 0.0),
            );
            if pair_negative(x)
                || pair_negative(y)
                || !pair_negative(pair_add(x, vec2f(-draw.local.z, 0.0)))
                || !pair_negative(pair_add(y, vec2f(-draw.local.w, 0.0)))
            {
                return vec4f(0.0, 0.0, 0.0, 0.0);
            }
            if draw.atlas.z > 0 {
                cell = vec2f(
                    pair_floor(pair_divide(pair_scale(x, dimensions.x), draw.local.z)),
                    pair_floor(pair_divide(pair_scale(y, dimensions.y), draw.local.w)),
                );
            }
        } else if position.x < 0.0
            || position.y < 0.0
            || position.x >= draw.local.z
            || position.y >= draw.local.w
        {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        if draw.atlas.z > 0 {
            // Domain membership was checked in local coordinates. A rounded
            // normalization of an admitted interior point cannot sample the
            // neighboring atlas glyph.
            cell = clamp(cell, vec2f(0.0, 0.0), dimensions - vec2f(1.0, 1.0));
            let texel = vec2i(
                draw.atlas.x as i32 + cell.x as i32,
                draw.atlas.y as i32 + cell.y as i32,
            );
            return draw.color * texture_load(MASKS, texel, 0).x;
        }
        draw.color
    }

    pub fn output(color: Vec4f) -> Vec4f {
        let globals = get!(GLOBALS);
        let mode = globals.viewport.w;
        let alpha = color.w;
        if alpha == 0.0 {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        let mut rgb = color.xyz();
        if (mode & 1) != 0 {
            rgb = vec3f(
                dot(vec3f(0.82246196, 0.17753804, 0.0), rgb),
                dot(vec3f(0.0331942, 0.9668058, 0.0), rgb),
                dot(vec3f(0.01708263, 0.07239744, 0.91051993), rgb),
            );
        }
        if (mode & 4) != 0 {
            let value = clamp(
                rgb,
                vec3f(-65504.0, -65504.0, -65504.0),
                vec3f(65504.0, 65504.0, 65504.0),
            );
            return vec4f(value.x, value.y, value.z, alpha);
        }
        rgb /= alpha;
        if (mode & 2) != 0 {
            rgb = reinhard(rgb, globals.mapping.x);
        } else {
            rgb = clamp(rgb, vec3f(0.0, 0.0, 0.0), vec3f(1.0, 1.0, 1.0));
        }
        // sRGB attachments encode once after this shader. SDR surfaces require
        // an opaque clear; float targets preserve arbitrary premultiplied alpha.
        vec4f(rgb.x * alpha, rgb.y * alpha, rgb.z * alpha, alpha)
    }
    pub fn reinhard(rgb: Vec3f, exposure: f32) -> Vec3f {
        // The finite limit is indistinguishable from one in f32 output and
        // avoids Inf/Inf even when multiplication overflows defensively.
        let exposed = clamp(
            rgb * exposure,
            vec3f(0.0, 0.0, 0.0),
            vec3f(1e30, 1e30, 1e30),
        );
        exposed / (vec3f(1.0, 1.0, 1.0) + exposed)
    }

    #[fragment]
    pub fn fragment(#[builtin(position)] position: Vec4f) -> Vec4f {
        let globals = get!(GLOBALS);
        let tile = position.x as u32 / 16 + position.y as u32 / 16 * globals.viewport.z;
        let range = get!(TILES)[tile as usize];
        if range.x == range.y {
            return output(globals.clear);
        }
        let mut anchor = vec4f(0.0, 0.0, 0.0, 0.0);
        let mut delta = vec4f(0.0, 0.0, 0.0, 0.0);
        for y in 0..4 {
            for x in 0..4 {
                let point = position.xy()
                    + vec2f((x as f32 + 0.5) * 0.25 - 0.5, (y as f32 + 0.5) * 0.25 - 0.5);
                let mut color = globals.clear;
                // Host-built CSR ranges are monotone and bounded by INDICES.
                #[wgsl_allow(non_literal_loop_bounds)]
                for cursor in range.x..range.y {
                    let index = get!(INDICES)[cursor as usize];
                    let source = sample_draw(get!(DRAWS)[index as usize], point);
                    color = source + color * (1.0 - source.w);
                }
                if x == 0 && y == 0 {
                    anchor = color;
                }
                delta += (color - anchor) * 0.0625;
            }
        }
        output(anchor + delta)
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn generated_shader_validates() {
        super::ui::WGSL_SOURCE.validate().unwrap();
    }
}
