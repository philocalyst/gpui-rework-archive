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
    uniform!(group(0), binding(0), GLOBALS: Globals);
    storage!(group(0), binding(1), DRAWS: RuntimeArray<Draw>);
    storage!(group(0), binding(2), TILES: RuntimeArray<Vec2u>);
    storage!(group(0), binding(3), INDICES: RuntimeArray<u32>);
    texture!(group(0), binding(4), MASKS: Texture2D<f32>);

    #[vertex]
    pub fn vertex(#[builtin(vertex_index)] index: u32) -> Vec4f {
        const POINTS: [Vec2f; 3] = [vec2f(-1.0, -1.0), vec2f(3.0, -1.0), vec2f(-1.0, 3.0)];
        let point = POINTS[index as usize];
        vec4f(point.x, point.y, 0.0, 1.0)
    }

    pub fn sample_draw(draw: Draw, point: Vec2f) -> Vec4f {
        if point.x < draw.clip.x
            || point.y < draw.clip.y
            || point.x >= draw.clip.z
            || point.y >= draw.clip.w
        {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        let h = vec3f(point.x, point.y, 1.0);
        let local = vec2f(dot(draw.inverse_x.xyz(), h), dot(draw.inverse_y.xyz(), h));
        let position = local - draw.local.xy();
        // Box signed distance plus a half-open boundary convention. Future
        // rounded/path primitives can use the same ordered sample compositor.
        let distance = abs(position - draw.local.zw() * 0.5) - draw.local.zw() * 0.5;
        if max(distance.x, distance.y) > 0.0
            || position.x < 0.0
            || position.y < 0.0
            || position.x >= draw.local.z
            || position.y >= draw.local.w
        {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        if draw.atlas.z > 0 {
            let texel = vec2i(
                draw.atlas.x as i32 + floor(position.x) as i32,
                draw.atlas.y as i32 + floor(position.y) as i32,
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
        let mut rgb = color.xyz() / alpha;
        if (mode & 1) != 0 {
            rgb = vec3f(
                dot(vec3f(0.82246196, 0.17753804, 0.0), rgb),
                dot(vec3f(0.0331942, 0.9668058, 0.0), rgb),
                dot(vec3f(0.01708263, 0.07239744, 0.91051993), rgb),
            );
        }
        if (mode & 4) != 0 {
            let value = clamp(
                rgb * alpha,
                vec3f(-65504.0, -65504.0, -65504.0),
                vec3f(65504.0, 65504.0, 65504.0),
            );
            return vec4f(value.x, value.y, value.z, alpha);
        }
        if (mode & 2) != 0 {
            rgb = max(rgb * globals.mapping.x, vec3f(0.0, 0.0, 0.0));
            rgb = rgb / (vec3f(1.0, 1.0, 1.0) + rgb);
        } else {
            rgb = clamp(rgb, vec3f(0.0, 0.0, 0.0), vec3f(1.0, 1.0, 1.0));
        }
        // sRGB attachments encode once after this shader. SDR surfaces require
        // an opaque clear; float targets preserve arbitrary premultiplied alpha.
        vec4f(rgb.x * alpha, rgb.y * alpha, rgb.z * alpha, alpha)
    }

    #[fragment]
    pub fn fragment(#[builtin(position)] position: Vec4f) -> Vec4f {
        let globals = get!(GLOBALS);
        let tile = position.x as u32 / 16 + position.y as u32 / 16 * globals.viewport.z;
        let range = get!(TILES)[tile as usize];
        if range.x == range.y {
            return output(globals.clear);
        }
        let mut total = vec4f(0.0, 0.0, 0.0, 0.0);
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
                total += color * 0.0625;
            }
        }
        output(total)
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn generated_shader_validates() {
        super::ui::WGSL_SOURCE.validate().unwrap();
    }
}
