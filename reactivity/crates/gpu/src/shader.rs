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
    storage!(group(0), binding(1), WORDS: RuntimeArray<Vec4u>);
    storage!(group(0), binding(2), TILES: RuntimeArray<Vec2u>);
    storage!(group(0), binding(3), INDICES: RuntimeArray<u32>);
    texture!(group(0), binding(4), MASKS: Texture2D<f32>);
    storage!(group(0), binding(5), CORRECTIONS: RuntimeArray<Correction>);

    // Typed host writers publish only validated private word addresses. The
    // inline tag preserves singleton storage; compact records share common state.
    pub fn load_color(word: Vec4u, correction: u32) -> Vec4f {
        if (correction & 0x80000000) != 0 {
            return bitcast_vec4f(get!(WORDS)[word.x as usize]);
        }
        bitcast_vec4f(word)
    }
    pub fn load_draw(address: u32) -> Draw {
        let base = (address & 0x7fffffff) as usize;
        if (address & 0x80000000) != 0 {
            return Draw {
                local: bitcast_vec4f(get!(WORDS)[base]),
                inverse_x: bitcast_vec4f(get!(WORDS)[base + 1]),
                inverse_y: bitcast_vec4f(get!(WORDS)[base + 2]),
                clip: bitcast_vec4f(get!(WORDS)[base + 3]),
                color: bitcast_vec4f(get!(WORDS)[base + 4]),
                atlas: get!(WORDS)[base + 5],
            };
        }
        let atlas = get!(WORDS)[base + 1];
        let state_base = atlas.w as usize;
        let correction = get!(WORDS)[state_base + 4].x;
        Draw {
            local: bitcast_vec4f(get!(WORDS)[base]),
            inverse_x: bitcast_vec4f(get!(WORDS)[state_base]),
            inverse_y: bitcast_vec4f(get!(WORDS)[state_base + 1]),
            clip: bitcast_vec4f(get!(WORDS)[state_base + 2]),
            color: bitcast_vec4f(get!(WORDS)[state_base + 3]),
            atlas: vec4u(atlas.x, atlas.y, atlas.z, correction),
        }
    }

    pub fn load_banked_draw(address: u32) -> Draw {
        let base = (address & 0x7fffffff) as usize;
        if (address & 0x80000000) != 0 {
            let atlas = get!(WORDS)[base + 5];
            return Draw {
                local: bitcast_vec4f(get!(WORDS)[base]),
                inverse_x: bitcast_vec4f(get!(WORDS)[base + 1]),
                inverse_y: bitcast_vec4f(get!(WORDS)[base + 2]),
                clip: bitcast_vec4f(get!(WORDS)[base + 3]),
                color: load_color(get!(WORDS)[base + 4], atlas.w),
                atlas: vec4u(atlas.x, atlas.y, atlas.z, atlas.w & 0x7fffffff),
            };
        }
        let atlas = get!(WORDS)[base + 1];
        let state_base = atlas.w as usize;
        let correction = get!(WORDS)[state_base + 4].x;
        Draw {
            local: bitcast_vec4f(get!(WORDS)[base]),
            inverse_x: bitcast_vec4f(get!(WORDS)[state_base]),
            inverse_y: bitcast_vec4f(get!(WORDS)[state_base + 1]),
            clip: bitcast_vec4f(get!(WORDS)[state_base + 2]),
            color: load_color(get!(WORDS)[state_base + 3], correction),
            atlas: vec4u(atlas.x, atlas.y, atlas.z, correction & 0x7fffffff),
        }
    }

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

    pub fn pair_square(value: Vec2f) -> Vec2f {
        pair_add(
            pair_product(value.x, value.x),
            pair_add(
                pair_product(2.0 * value.x, value.y),
                pair_product(value.y, value.y),
            ),
        )
    }

    pub fn corner_distance(position: Vec2f, extent: f32, radius: f32) -> Vec2f {
        let left = pair_add(vec2f(radius, 0.0), -position);
        let right = pair_add(position, -pair_sum(extent, -radius));
        let mut distance = vec2f(0.0, 0.0);
        if pair_negative(-left) {
            distance = left;
        }
        if pair_negative(pair_add(distance, -right)) {
            distance = right;
        }
        distance
    }

    pub fn rounded_contains(draw: Draw, point: Vec2f, radius: f32, scale: f32) -> bool {
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
            return false;
        }
        let dx = pair_scale(corner_distance(x, draw.local.z, radius), scale);
        let dy = pair_scale(corner_distance(y, draw.local.w, radius), scale);
        let r = radius * scale;
        let residual = pair_add(
            pair_add(pair_square(dx), pair_square(dy)),
            -pair_product(r, r),
        );
        !pair_negative(-residual)
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

    pub fn decode_image_channel(value: f32) -> f32 {
        if value <= 0.04045 {
            return value / 12.92;
        }
        pow((value + 0.055) / 1.055, 2.4)
    }
    pub fn image_texel(draw: Draw, cell: Vec2f, dimensions: Vec2f) -> Vec4f {
        let cell = clamp(cell, vec2f(0.0, 0.0), dimensions - vec2f(1.0, 1.0));
        let index = cell.y as u32 * dimensions.x as u32 + cell.x as u32;
        let base = draw.atlas.x & 0x7fffffff;
        if (draw.atlas.y & 8) != 0 {
            return bitcast_vec4f(get!(WORDS)[(base + index) as usize]);
        }
        let word = get!(WORDS)[(base + index / 4) as usize];
        let packed = word[(index & 3) as usize];
        let value = vec4f(
            (packed & 255) as f32,
            ((packed >> 8) & 255) as f32,
            ((packed >> 16) & 255) as f32,
            (packed >> 24) as f32,
        ) / 255.0;
        if value.w == 0.0 {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        let mut rgb = value.xyz();
        if (draw.atlas.y & 2) != 0 {
            rgb /= value.w;
        }
        rgb = vec3f(
            decode_image_channel(rgb.x),
            decode_image_channel(rgb.y),
            decode_image_channel(rgb.z),
        );
        if (draw.atlas.y & 4) != 0 {
            let xyz = vec3f(
                dot(
                    vec3f(
                        608311.0 / 1250200.0,
                        189793.0 / 714400.0,
                        198249.0 / 1000160.0,
                    ),
                    rgb,
                ),
                dot(
                    vec3f(
                        35783.0 / 156275.0,
                        247089.0 / 357200.0,
                        198249.0 / 2500400.0,
                    ),
                    rgb,
                ),
                dot(vec3f(0.0, 32229.0 / 714400.0, 5220557.0 / 5000800.0), rgb),
            );
            rgb = vec3f(
                dot(
                    vec3f(12831.0 / 3959.0, -329.0 / 214.0, -1974.0 / 3959.0),
                    xyz,
                ),
                dot(
                    vec3f(
                        -851781.0 / 878810.0,
                        1648619.0 / 878810.0,
                        36519.0 / 878810.0,
                    ),
                    xyz,
                ),
                dot(
                    vec3f(705.0 / 12673.0, -2585.0 / 12673.0, 705.0 / 667.0),
                    xyz,
                ),
            );
        }
        rgb *= value.w;
        vec4f(rgb.x, rgb.y, rgb.z, value.w)
    }

    // Same validated parameter/interval word schema as Canvas GradientView.
    // Material is independent of rounded/rectangular coverage and never takes
    // uniform-solid tile certificates, even when every stop has alpha one.
    pub fn gradient_color(base: u32, point: Vec2f) -> Vec4f {
        let header = get!(WORDS)[base as usize];
        let geometry = bitcast_vec4f(get!(WORDS)[(base + 2) as usize]);
        let p = point - geometry.xy();
        let mut t = p.x * geometry.z + p.y * geometry.w;
        if header.x == 1 {
            let q = p * geometry.zw();
            t = sqrt(q.x * q.x + q.y * q.y);
        } else if header.x == 2 {
            t = 0.0;
            if p.x != 0.0 || p.y != 0.0 {
                t = atan2(p.x, -p.y) / bitcast_f32(0x40c90fdb);
            }
            t -= geometry.z;
            t -= floor(t);
        }
        let count = header.z;
        let first = bitcast_f32(get!(WORDS)[(base + 3) as usize].x);
        let last = bitcast_f32(get!(WORDS)[(base + 3 + (count - 1) * 4) as usize].x);
        let span = last - first;
        if header.y == 1 {
            let x = t - first;
            t = x - floor(x / span) * span + first;
        } else if header.y == 2 {
            let period = span * 2.0;
            let x = t - first;
            let u = x - floor(x / period) * period;
            t = first + select(u, period - u, u > span);
        }
        let mut low = 0_u32;
        let mut high = count;
        while low < high {
            let mid = (low + high) / 2;
            if bitcast_f32(get!(WORDS)[(base + 3 + mid * 4) as usize].x) <= t {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        let mut index = 0_u32;
        if low > 0 {
            index = low - 1;
        }
        let word = base + 3 + index * 4;
        let interval = bitcast_vec4f(get!(WORDS)[word as usize]);
        let color = bitcast_vec4f(get!(WORDS)[(word + 1) as usize]);
        if low == 0 || index + 1 == count {
            return color;
        }
        let u = clamp((t - interval.x) * interval.y, 0.0, 1.0);
        return color + u * bitcast_vec4f(get!(WORDS)[(word + 2) as usize]);
    }

    pub fn sample_draw(draw: Draw, point: Vec2f) -> Vec4f {
        // Host-only certificate: this solid's quarter-grid bounds already
        // include canonical inverse coverage, clip and viewport membership.
        // Eighth-grid samples and both endpoint sums are exact in f32.
        if (draw.atlas.w & 0x40000000) != 0 {
            if point.x < draw.local.x
                || point.y < draw.local.y
                || point.x >= draw.local.x + draw.local.z
                || point.y >= draw.local.y + draw.local.w
            {
                return vec4f(0.0, 0.0, 0.0, 0.0);
            }
            return draw.color;
        }
        if point.x < draw.clip.x
            || point.y < draw.clip.y
            || outside_clip_max(point.x, draw.clip.x, draw.clip.z, draw.atlas.w, false)
            || outside_clip_max(point.y, draw.clip.y, draw.clip.w, draw.atlas.w, true)
        {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        if (draw.atlas.x & 0x20000000) != 0 && (draw.atlas.x & 0x80000000) == 0 {
            if !rounded_contains(
                draw,
                point,
                bitcast_f32(draw.atlas.y),
                bitcast_f32(draw.atlas.z),
            ) {
                return vec4f(0.0, 0.0, 0.0, 0.0);
            }
            let h = vec3f(point.x, point.y, 1.0);
            let local = vec2f(dot(draw.inverse_x.xyz(), h), dot(draw.inverse_y.xyz(), h));
            return gradient_color(
                draw.atlas.x & 0x1fffffff,
                (local - draw.local.xy()) / draw.local.zw(),
            );
        }
        if (draw.atlas.x & 0x40000000) != 0 && (draw.atlas.x & 0x80000000) == 0 {
            if rounded_contains(
                draw,
                point,
                bitcast_f32(draw.atlas.y),
                bitcast_f32(draw.atlas.z),
            ) {
                return draw.color;
            }
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        let h = vec3f(point.x, point.y, 1.0);
        let local = vec2f(dot(draw.inverse_x.xyz(), h), dot(draw.inverse_y.xyz(), h));
        let position = local - draw.local.xy();
        let error = vec2f(draw.inverse_x.w, draw.inverse_y.w);
        let edges = min(abs(position), abs(position - draw.local.zw()));
        let dimensions = vec2f((draw.atlas.z & 65535) as f32, (draw.atlas.z >> 16) as f32);
        let is_image = (draw.atlas.x & 0x80000000) != 0;
        let linear = is_image && (draw.atlas.y & 1) != 0;
        let mut mapped = position * dimensions / draw.local.zw();
        if linear {
            mapped -= vec2f(0.5, 0.5);
        }
        let mut fraction = fract(mapped);
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
                let mut nx = pair_divide(pair_scale(x, dimensions.x), draw.local.z);
                let mut ny = pair_divide(pair_scale(y, dimensions.y), draw.local.w);
                if linear {
                    nx = pair_add(nx, vec2f(-0.5, 0.0));
                    ny = pair_add(ny, vec2f(-0.5, 0.0));
                }
                cell = vec2f(pair_floor(nx), pair_floor(ny));
                fraction = clamp(
                    vec2f((nx.x - cell.x) + nx.y, (ny.x - cell.y) + ny.y),
                    vec2f(0.0, 0.0),
                    vec2f(1.0, 1.0),
                );
            }
        } else if position.x < 0.0
            || position.y < 0.0
            || position.x >= draw.local.z
            || position.y >= draw.local.w
        {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        if is_image {
            if (draw.atlas.y & 16) != 0
                && !rounded_contains(draw, point, draw.color.x, draw.color.y)
            {
                return vec4f(0.0, 0.0, 0.0, 0.0);
            }
            if linear {
                let a = image_texel(draw, cell, dimensions);
                let b = image_texel(draw, cell + vec2f(1.0, 0.0), dimensions);
                let c = image_texel(draw, cell + vec2f(0.0, 1.0), dimensions);
                let d = image_texel(draw, cell + vec2f(1.0, 1.0), dimensions);
                let upper = a * (1.0 - fraction.x) + b * fraction.x;
                let lower = c * (1.0 - fraction.x) + d * fraction.x;
                return upper * (1.0 - fraction.y) + lower * fraction.y;
            }
            return image_texel(draw, cell, dimensions);
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

    // Banked scenes decode a draw and its working paint once before the
    // sixteen sample operations. This deliberately trades sixteen local colors
    // for the ordinary sample-major path's repeated record/bank loads; it is
    // not a claim of lower register pressure or universally faster shading.
    pub fn banked_fragment(position: Vec2f, range: Vec2u, clear: Vec4f) -> Vec4f {
        let mut colors: [Vec4f; 16] = [
            clear, clear, clear, clear, clear, clear, clear, clear, clear, clear, clear, clear,
            clear, clear, clear, clear,
        ];
        #[wgsl_allow(non_literal_loop_bounds)]
        for cursor in range.x..range.y {
            let draw = load_banked_draw(get!(INDICES)[cursor as usize]);
            for y in 0..4 {
                for x in 0..4 {
                    let point = position
                        + vec2f((x as f32 + 0.5) * 0.25 - 0.5, (y as f32 + 0.5) * 0.25 - 0.5);
                    let source = sample_draw(draw, point);
                    let index = (y * 4 + x) as usize;
                    colors[index] = source + colors[index] * (1.0 - source.w);
                }
            }
        }
        let anchor = colors[0];
        let mut delta = vec4f(0.0, 0.0, 0.0, 0.0);
        for index in 0..16 {
            delta += (colors[index as usize] - anchor) * 0.0625;
        }
        output(anchor + delta)
    }

    #[fragment]
    pub fn fragment(#[builtin(position)] position: Vec4f) -> Vec4f {
        let globals = get!(GLOBALS);
        let tile = position.x as u32 / 16 + position.y as u32 / 16 * globals.viewport.z;
        let range = get!(TILES)[tile as usize];
        if (range.y & 0x80000000) != 0 {
            if (globals.viewport.w & 8) != 0 {
                return output(load_banked_draw(range.x).color);
            }
            return output(load_draw(range.x).color);
        }
        if range.x == range.y {
            return output(globals.clear);
        }
        if (globals.viewport.w & 8) != 0 {
            return banked_fragment(position.xy(), range, globals.clear);
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
                    let source = sample_draw(load_draw(index), point);
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
