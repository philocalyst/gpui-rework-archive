struct Draw {
    local: vec4f,
    inverse_x: vec4f,
    inverse_y: vec4f,
    clip: vec4f,
    color: vec4f,
    atlas: vec4u
}

struct Globals {
    viewport: vec4u,
    clear: vec4f,
    mapping: vec4f
}

struct Correction {
    x: vec4f,
    y: vec4f
}
@group(0) @binding(0) var<uniform> GLOBALS: Globals;
@group(0) @binding(1) var<storage, read> WORDS: array<vec4u>;
@group(0) @binding(2) var<storage, read> TILES: array<vec2u>;
@group(0) @binding(3) var<storage, read> INDICES: array<u32>;
@group(0) @binding(4) var MASKS: texture_2d<f32>;
@group(0) @binding(5) var<storage, read> CORRECTIONS: array<Correction>;

fn load_color(word: vec4u, correction: u32) -> vec4f {
    if ((correction & 2147483648u) != 0u) {
        return bitcast<vec4<f32>>(WORDS[u32(word.x)]);
    }
    return bitcast<vec4<f32>>(word);
}

fn load_draw(address: u32) -> Draw {
    let base = u32((address & 2147483647u));
    if ((address & 2147483648u) != 0u) {
        return Draw(bitcast<vec4<f32>>(WORDS[base]), bitcast<vec4<f32>>(WORDS[(base + 1u)]), bitcast<vec4<f32>>(WORDS[(base + 2u)]), bitcast<vec4<f32>>(WORDS[(base + 3u)]), bitcast<vec4<f32>>(WORDS[(base + 4u)]), WORDS[(base + 5u)]);
    }
    let atlas = WORDS[(base + 1u)];
    let state_base = u32(atlas.w);
    let correction = WORDS[(state_base + 4u)].x;
    return Draw(bitcast<vec4<f32>>(WORDS[base]), bitcast<vec4<f32>>(WORDS[state_base]), bitcast<vec4<f32>>(WORDS[(state_base + 1u)]), bitcast<vec4<f32>>(WORDS[(state_base + 2u)]), bitcast<vec4<f32>>(WORDS[(state_base + 3u)]), vec4u(atlas.x, atlas.y, atlas.z, correction));
}

fn load_banked_draw(address: u32) -> Draw {
    let base = u32((address & 2147483647u));
    if ((address & 2147483648u) != 0u) {
        let atlas = WORDS[(base + 5u)];
        return Draw(bitcast<vec4<f32>>(WORDS[base]), bitcast<vec4<f32>>(WORDS[(base + 1u)]), bitcast<vec4<f32>>(WORDS[(base + 2u)]), bitcast<vec4<f32>>(WORDS[(base + 3u)]), load_color(WORDS[(base + 4u)], atlas.w), vec4u(atlas.x, atlas.y, atlas.z, (atlas.w & 2147483647u)));
    }
    let atlas = WORDS[(base + 1u)];
    let state_base = u32(atlas.w);
    let correction = WORDS[(state_base + 4u)].x;
    return Draw(bitcast<vec4<f32>>(WORDS[base]), bitcast<vec4<f32>>(WORDS[state_base]), bitcast<vec4<f32>>(WORDS[(state_base + 1u)]), bitcast<vec4<f32>>(WORDS[(state_base + 2u)]), load_color(WORDS[(state_base + 3u)], correction), vec4u(atlas.x, atlas.y, atlas.z, (correction & 2147483647u)));
}

@vertex fn vertex(@builtin(vertex_index) index: u32) -> @builtin(position) vec4f {
    const POINTS: array<vec2f, 3> = array(vec2f(-1.0, -1.0), vec2f(3.0, -1.0), vec2f(-1.0, 3.0));
    let point = POINTS[u32(index)];
    return vec4f(point.x, point.y, 0.0, 1.0);
}

fn pair_sum(a: f32, b: f32) -> vec2f {
    let sum = (a + b);
    let part = (sum - a);
    return vec2f(sum, ((a - (sum - part)) + (b - part)));
}

fn pair_add(a: vec2f, b: vec2f) -> vec2f {
    let sum = pair_sum(a.x, b.x);
    return vec2f(sum.x, ((sum.y + a.y) + b.y));
}

fn pair_product(a: f32, b: f32) -> vec2f {
    let product = (a * b);
    let ah = bitcast<f32>((bitcast<u32>(a) & 4294963200));
    let bh = bitcast<f32>((bitcast<u32>(b) & 4294963200));
    let al = (a - ah);
    let bl = (b - bh);
    let error = (((((ah * bh) - product) + (ah * bl)) + (al * bh)) + (al * bl));
    return vec2f(product, error);
}

fn pair_dot(high: vec3f, low: vec3f, point: vec2f) -> vec2f {
    let x = pair_add(pair_product(high.x, point.x), pair_product(low.x, point.x));
    let y = pair_add(pair_product(high.y, point.y), pair_product(low.y, point.y));
    return pair_add(pair_add(x, y), vec2f(high.z, low.z));
}

fn pair_negative(value: vec2f) -> bool {
    return (value.x < -value.y);
}

fn pair_scale(value: vec2f, scale: f32) -> vec2f {
    return pair_add(pair_product(value.x, scale), pair_product(value.y, scale));
}

fn pair_divide(value: vec2f, divisor: f32) -> vec2f {
    let quotient = (value.x / divisor);
    let residual = pair_add(value, -pair_product(quotient, divisor));
    return vec2f(quotient, ((residual.x + residual.y) / divisor));
}

fn pair_floor(value: vec2f) -> f32 {
    let integer = floor(value.x);
    if ((value.x - integer) < -value.y) {
        return (integer - 1.0);
    }
    if ((value.x - integer) >= (1.0 - value.y)) {
        return (integer + 1.0);
    }
    return integer;
}

fn pair_square(value: vec2f) -> vec2f {
    return pair_add(pair_product(value.x, value.x), pair_add(pair_product((2.0 * value.x), value.y), pair_product(value.y, value.y)));
}

fn corner_distance(position: vec2f, extent: f32, radius: f32) -> vec2f {
    let left = pair_add(vec2f(radius, 0.0), -position);
    let right = pair_add(position, -pair_sum(extent, -radius));
    var distance = vec2f(0.0, 0.0);
    if pair_negative(-left) {
        distance = left;
    }
    if pair_negative(pair_add(distance, -right)) {
        distance = right;
    }
    return distance;
}

fn rounded_contains(draw: Draw, point: vec2f, radius: f32, scale: f32) -> bool {
    let correction = CORRECTIONS[u32(draw.atlas.w)];
    let x = pair_add(pair_dot(draw.inverse_x.xyz, correction.x.xyz, point), vec2f(-draw.local.x, 0.0));
    let y = pair_add(pair_dot(draw.inverse_y.xyz, correction.y.xyz, point), vec2f(-draw.local.y, 0.0));
    return rounded_local_contains(draw.local, x, y, radius, scale);
}

fn rounded_local_contains(
    local: vec4f,
    x: vec2f,
    y: vec2f,
    radius: f32,
    scale: f32,
) -> bool {
    if (((pair_negative(x) || pair_negative(y)) || !pair_negative(pair_add(x, vec2f(-local.z, 0.0)))) || !pair_negative(pair_add(y, vec2f(-local.w, 0.0)))) {
        return false;
    }
    if (radius == 0.0) {
        return true;
    }
    let dx = pair_scale(corner_distance(x, local.z, radius), scale);
    let dy = pair_scale(corner_distance(y, local.w, radius), scale);
    let r = (radius * scale);
    let residual = pair_add(pair_add(pair_square(dx), pair_square(dy)), -pair_product(r, r));
    return !pair_negative(-residual);
}

fn outside_clip_max(
    point: f32,
    start: f32,
    extent: f32,
    index: u32,
    vertical: bool,
) -> bool {
    let end = (start + extent);
    if (point != end) {
        return (point > end);
    }
    let correction = CORRECTIONS[u32(index)];
    if vertical {
        return (correction.y.w <= 0.0);
    }
    return (correction.x.w <= 0.0);
}

fn decode_image_channel(value: f32) -> f32 {
    if (value <= 0.04045) {
        return (value / 12.92);
    }
    return pow(((value + 0.055) / 1.055), 2.4);
}

fn image_texel(draw: Draw, cell: vec2f, dimensions: vec2f) -> vec4f {
    let cell_1 = clamp(cell, vec2f(0.0, 0.0), (dimensions - vec2f(1.0, 1.0)));
    let index = ((u32(cell_1.y) * u32(dimensions.x)) + u32(cell_1.x));
    let base = (draw.atlas.x & 2147483647u);
    if ((draw.atlas.y & 8u) != 0u) {
        return bitcast<vec4<f32>>(WORDS[u32((base + index))]);
    }
    let word = WORDS[u32((base + (index / 4u)))];
    let packed = word[u32((index & 3u))];
    let value = (vec4f(f32((packed & 255u)), f32(((packed >> 8u) & 255u)), f32(((packed >> 16u) & 255u)), f32((packed >> 24u))) / 255.0);
    if (value.w == 0.0) {
        return vec4f(0.0, 0.0, 0.0, 0.0);
    }
    var rgb = value.xyz;
    if ((draw.atlas.y & 2u) != 0u) {
        rgb /= value.w;
    }
    rgb = vec3f(decode_image_channel(rgb.x), decode_image_channel(rgb.y), decode_image_channel(rgb.z));
    if ((draw.atlas.y & 4u) != 0u) {
        let xyz = vec3f(dot(vec3f((608311.0 / 1250200.0), (189793.0 / 714400.0), (198249.0 / 1000160.0)), rgb), dot(vec3f((35783.0 / 156275.0), (247089.0 / 357200.0), (198249.0 / 2500400.0)), rgb), dot(vec3f(0.0, (32229.0 / 714400.0), (5220557.0 / 5000800.0)), rgb));
        rgb = vec3f(dot(vec3f((12831.0 / 3959.0), (-329.0 / 214.0), (-1974.0 / 3959.0)), xyz), dot(vec3f((-851781.0 / 878810.0), (1648619.0 / 878810.0), (36519.0 / 878810.0)), xyz), dot(vec3f((705.0 / 12673.0), (-2585.0 / 12673.0), (705.0 / 667.0)), xyz));
    }
    rgb *= value.w;
    return vec4f(rgb.x, rgb.y, rgb.z, value.w);
}

fn clip_chain_contains(address: u32, point: vec2f) -> bool {
    var cursor = address;
    for (var _depth = 0; _depth < 64; _depth++) {
        let base = u32(cursor);
        let local = bitcast<vec4<f32>>(WORDS[base]);
        let high_x = bitcast<vec4<f32>>(WORDS[(base + 1u)]);
        let high_y = bitcast<vec4<f32>>(WORDS[(base + 2u)]);
        let low_x = WORDS[(base + 3u)];
        let low_y = bitcast<vec4<f32>>(WORDS[(base + 4u)]);
        let x = pair_add(pair_dot(high_x.xyz, bitcast<vec4<f32>>(low_x).xyz, point), vec2f(-local.x, 0.0));
        let y = pair_add(pair_dot(high_y.xyz, low_y.xyz, point), vec2f(-local.y, 0.0));
        if !rounded_local_contains(local, x, y, high_x.w, high_y.w) {
            return false;
        }
        cursor = low_x.w;
        if (cursor == 0u) {
            return true;
        }
    }
    return false;
}

fn gradient_color(base: u32, point: vec2f) -> vec4f {
    let header = WORDS[u32(base)];
    let geometry = bitcast<vec4<f32>>(WORDS[u32((base + 2u))]);
    let p = (point - geometry.xy);
    var t = ((p.x * geometry.z) + (p.y * geometry.w));
    if (header.x == 1u) {
        let q = (p * geometry.zw);
        t = sqrt(((q.x * q.x) + (q.y * q.y)));
    } else if (header.x == 2u) {
        t = 0.0;
        if ((p.x != 0.0) || (p.y != 0.0)) {
            t = (atan2(p.x, -p.y) / bitcast<f32>(1086918619));
        }
        t -= geometry.z;
        t -= floor(t);
    }
    let count = header.z;
    let first = bitcast<f32>(WORDS[u32((base + 3u))].x);
    let last = bitcast<f32>(WORDS[u32(((base + 3u) + ((count - 1u) * 4u)))].x);
    let span = (last - first);
    if (header.y == 1u) {
        let x = (t - first);
        t = ((x - (floor((x / span)) * span)) + first);
    } else if (header.y == 2u) {
        let period = (span * 2.0);
        let x = (t - first);
        let u = (x - (floor((x / period)) * period));
        t = (first + select(u, (period - u), (u > span)));
    }
    var low = 0u;
    var high = count;
    while (low < high) {
        let mid = ((low + high) / 2u);
        if (bitcast<f32>(WORDS[u32(((base + 3u) + (mid * 4u)))].x) <= t) {
            low = (mid + 1u);
        } else {
            high = mid;
        }
    }
    var index = 0u;
    if (low > 0u) {
        index = (low - 1u);
    }
    let word = ((base + 3u) + (index * 4u));
    let interval = bitcast<vec4<f32>>(WORDS[u32(word)]);
    let color = bitcast<vec4<f32>>(WORDS[u32((word + 1u))]);
    if ((low == 0u) || ((index + 1u) == count)) {
        return color;
    }
    let u = clamp(((t - interval.x) * interval.y), 0.0, 1.0);
    return (color + (u * bitcast<vec4<f32>>(WORDS[u32((word + 2u))])));
}

fn sample_draw(draw: Draw, point: vec2f) -> vec4f {
    if ((draw.atlas.w & 1073741824u) != 0u) {
        if ((((point.x < draw.local.x) || (point.y < draw.local.y)) || (point.x >= (draw.local.x + draw.local.z))) || (point.y >= (draw.local.y + draw.local.w))) {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        return draw.color;
    }
    if (bitcast<u32>(draw.clip.x) == 2143289347) {
        if !clip_chain_contains(bitcast<u32>(draw.clip.y), point) {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
    } else if ((((point.x < draw.clip.x) || (point.y < draw.clip.y)) || outside_clip_max(point.x, draw.clip.x, draw.clip.z, draw.atlas.w, false)) || outside_clip_max(point.y, draw.clip.y, draw.clip.w, draw.atlas.w, true)) {
        return vec4f(0.0, 0.0, 0.0, 0.0);
    }
    if ((draw.atlas.x & 4026531840u) == 268435456u) {
        let position = (point - draw.local.xy);
        if ((((position.x < 0.0) || (position.y < 0.0)) || (position.x >= draw.local.z)) || (position.y >= draw.local.w)) {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        let texel = vec2i((i32((draw.atlas.x & 268435455u)) + i32(floor(position.x))), (i32(draw.atlas.y) + i32(floor(position.y))));
        return (draw.color * textureLoad(MASKS, texel, 0).x);
    }
    if (((draw.atlas.x & 536870912u) != 0u) && ((draw.atlas.x & 2147483648u) == 0u)) {
        if !rounded_contains(draw, point, bitcast<f32>(draw.atlas.y), bitcast<f32>(draw.atlas.z)) {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        let h = vec3f(point.x, point.y, 1.0);
        let local = vec2f(dot(draw.inverse_x.xyz, h), dot(draw.inverse_y.xyz, h));
        return gradient_color((draw.atlas.x & 536870911u), ((local - draw.local.xy) / draw.local.zw));
    }
    if (((draw.atlas.x & 1073741824u) != 0u) && ((draw.atlas.x & 2147483648u) == 0u)) {
        if rounded_contains(draw, point, bitcast<f32>(draw.atlas.y), bitcast<f32>(draw.atlas.z)) {
            return draw.color;
        }
        return vec4f(0.0, 0.0, 0.0, 0.0);
    }
    let h = vec3f(point.x, point.y, 1.0);
    let local = vec2f(dot(draw.inverse_x.xyz, h), dot(draw.inverse_y.xyz, h));
    let position = (local - draw.local.xy);
    let error = vec2f(draw.inverse_x.w, draw.inverse_y.w);
    let edges = min(abs(position), abs((position - draw.local.zw)));
    let dimensions = vec2f(f32((draw.atlas.z & 65535u)), f32((draw.atlas.z >> 16u)));
    let is_image = ((draw.atlas.x & 2147483648u) != 0u);
    let linear = (is_image && ((draw.atlas.y & 1u) != 0u));
    var mapped = ((position * dimensions) / draw.local.zw);
    if linear {
        mapped -= vec2f(0.5, 0.5);
    }
    var fraction = fract(mapped);
    let texels = min(fraction, (vec2f(1.0, 1.0) - fraction));
    let texel_error = (((error * dimensions) / draw.local.zw) + ((abs(mapped) + vec2f(1.0, 1.0)) * 3.8146973e-6));
    let correct = (((edges.x <= error.x) || (edges.y <= error.y)) || ((draw.atlas.z > 0u) && ((texels.x <= texel_error.x) || (texels.y <= texel_error.y))));
    var cell = floor(mapped);
    if correct {
        let correction = CORRECTIONS[u32(draw.atlas.w)];
        let x = pair_add(pair_dot(draw.inverse_x.xyz, correction.x.xyz, point), vec2f(-draw.local.x, 0.0));
        let y = pair_add(pair_dot(draw.inverse_y.xyz, correction.y.xyz, point), vec2f(-draw.local.y, 0.0));
        if (((pair_negative(x) || pair_negative(y)) || !pair_negative(pair_add(x, vec2f(-draw.local.z, 0.0)))) || !pair_negative(pair_add(y, vec2f(-draw.local.w, 0.0)))) {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        if (draw.atlas.z > 0u) {
            var nx = pair_divide(pair_scale(x, dimensions.x), draw.local.z);
            var ny = pair_divide(pair_scale(y, dimensions.y), draw.local.w);
            if linear {
                nx = pair_add(nx, vec2f(-0.5, 0.0));
                ny = pair_add(ny, vec2f(-0.5, 0.0));
            }
            cell = vec2f(pair_floor(nx), pair_floor(ny));
            fraction = clamp(vec2f(((nx.x - cell.x) + nx.y), ((ny.x - cell.y) + ny.y)), vec2f(0.0, 0.0), vec2f(1.0, 1.0));
        }
    } else if ((((position.x < 0.0) || (position.y < 0.0)) || (position.x >= draw.local.z)) || (position.y >= draw.local.w)) {
        return vec4f(0.0, 0.0, 0.0, 0.0);
    }
    if is_image {
        if (((draw.atlas.y & 16u) != 0u) && !rounded_contains(draw, point, draw.color.x, draw.color.y)) {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        if linear {
            let a = image_texel(draw, cell, dimensions);
            let b = image_texel(draw, (cell + vec2f(1.0, 0.0)), dimensions);
            let c = image_texel(draw, (cell + vec2f(0.0, 1.0)), dimensions);
            let d = image_texel(draw, (cell + vec2f(1.0, 1.0)), dimensions);
            let upper = ((a * (1.0 - fraction.x)) + (b * fraction.x));
            let lower = ((c * (1.0 - fraction.x)) + (d * fraction.x));
            return ((upper * (1.0 - fraction.y)) + (lower * fraction.y));
        }
        return image_texel(draw, cell, dimensions);
    }
    if (draw.atlas.z > 0u) {
        cell = clamp(cell, vec2f(0.0, 0.0), (dimensions - vec2f(1.0, 1.0)));
        let texel = vec2i((i32(draw.atlas.x) + i32(cell.x)), (i32(draw.atlas.y) + i32(cell.y)));
        return (draw.color * textureLoad(MASKS, texel, 0).x);
    }
    return draw.color;
}

fn output(color: vec4f) -> vec4f {
    let globals = GLOBALS;
    let mode = globals.viewport.w;
    let alpha = color.w;
    if (alpha == 0.0) {
        return vec4f(0.0, 0.0, 0.0, 0.0);
    }
    var rgb = color.xyz;
    if ((mode & 1u) != 0u) {
        rgb = vec3f(dot(vec3f(0.82246196, 0.17753804, 0.0), rgb), dot(vec3f(0.0331942, 0.9668058, 0.0), rgb), dot(vec3f(0.01708263, 0.07239744, 0.91051993), rgb));
    }
    if ((mode & 4u) != 0u) {
        let value = clamp(rgb, vec3f(-65504.0, -65504.0, -65504.0), vec3f(65504.0, 65504.0, 65504.0));
        return vec4f(value.x, value.y, value.z, alpha);
    }
    rgb /= alpha;
    if ((mode & 2u) != 0u) {
        rgb = reinhard(rgb, globals.mapping.x);
    } else {
        rgb = clamp(rgb, vec3f(0.0, 0.0, 0.0), vec3f(1.0, 1.0, 1.0));
    }
    return vec4f((rgb.x * alpha), (rgb.y * alpha), (rgb.z * alpha), alpha);
}

fn reinhard(rgb: vec3f, exposure: f32) -> vec3f {
    let exposed = clamp((rgb * exposure), vec3f(0.0, 0.0, 0.0), vec3f(1e30, 1e30, 1e30));
    return (exposed / (vec3f(1.0, 1.0, 1.0) + exposed));
}

fn mask_cell_coverage(draw: Draw, cell: vec2f) -> f32 {
    if ((((cell.x < 0.0) || (cell.y < 0.0)) || (cell.x >= draw.local.z)) || (cell.y >= draw.local.w)) {
        return 0.0;
    }
    return textureLoad(MASKS, vec2i((i32((draw.atlas.x & 268435455u)) + i32(cell.x)), (i32(draw.atlas.y) + i32(cell.y))), 0).x;
}

fn mask_pixel_misses(draw: Draw, position: vec2f) -> bool {
    let first = ((position - vec2f(0.375, 0.375)) - draw.local.xy);
    let last = ((position + vec2f(0.375, 0.375)) - draw.local.xy);
    return ((((last.x < 0.0) || (last.y < 0.0)) || (first.x >= draw.local.z)) || (first.y >= draw.local.w));
}

fn first_missed_sample(draw: Draw, position: vec2f, missed: bool) -> vec4f {
    if missed {
        return sample_draw(draw, (position - vec2f(0.375, 0.375)));
    }
    return vec4f(0.0, 0.0, 0.0, 0.0);
}

fn mask_pixel_inside_clip(draw: Draw, position: vec2f) -> bool {
    if (bitcast<u32>(draw.clip.x) == 2143289347) {
        return false;
    }
    let first = (position - vec2f(0.375, 0.375));
    let last = (position + vec2f(0.375, 0.375));
    return ((((first.x >= draw.clip.x) && (first.y >= draw.clip.y)) && !outside_clip_max(last.x, draw.clip.x, draw.clip.z, draw.atlas.w, false)) && !outside_clip_max(last.y, draw.clip.y, draw.clip.w, draw.atlas.w, true));
}

fn mask_pixel_coverage(draw: Draw, first: vec2f, last: vec2f) -> vec4f {
    let a = mask_cell_coverage(draw, first);
    var b = a;
    var c = a;
    if (last.x != first.x) {
        b = mask_cell_coverage(draw, vec2f(last.x, first.y));
    }
    if (last.y != first.y) {
        c = mask_cell_coverage(draw, vec2f(first.x, last.y));
    }
    var d = c;
    if (last.x != first.x) {
        d = b;
        if (last.y != first.y) {
            d = mask_cell_coverage(draw, last);
        }
    }
    return vec4f(a, b, c, d);
}

fn cached_mask_sample(draw: Draw, point: vec2f, first: vec2f, coverage: vec4f) -> vec4f {
    let cell = floor((point - draw.local.xy));
    if ((((cell.x < 0.0) || (cell.y < 0.0)) || (cell.x >= draw.local.z)) || (cell.y >= draw.local.w)) {
        return vec4f(0.0, 0.0, 0.0, 0.0);
    }
    let offset = (cell - first);
    let index = ((u32(offset.y) * 2u) + u32(offset.x));
    return (draw.color * coverage[u32(index)]);
}

fn sample_cached_or_draw(
    draw: Draw,
    point: vec2f,
    first: vec2f,
    coverage: vec4f,
    cached: bool,
    missed: bool,
    first_source: vec4f,
) -> vec4f {
    if missed {
        return first_source;
    }
    if cached {
        return cached_mask_sample(draw, point, first, coverage);
    }
    return sample_draw(draw, point);
}

fn partition_key(point: f32, origin: f32, extent: f32, mask: bool) -> f32 {
    if mask {
        return floor((point - origin));
    }
    if ((point >= origin) && (point < (origin + extent))) {
        return 1.0;
    }
    return 0.0;
}

fn partition_axis(first: f32, origin: f32, extent: f32, mask: bool) -> u32 {
    var cuts: u32 = 1u;
    var previous = partition_key(first, origin, extent, mask);
    for (var index = 1; index < 4; index++) {
        let key = partition_key((first + (f32(index) * 0.25)), origin, extent, mask);
        if (key != previous) {
            cuts |= (1u << u32(index));
        }
        previous = key;
    }
    return cuts;
}

fn source_partitions(draw: Draw, position: vec2f, missed: bool, cached: bool) -> vec2u {
    if missed {
        return vec2u(1u, 1u);
    }
    let solid = ((draw.atlas.w & 1073741824u) != 0u);
    if (cached || solid) {
        let first = (position - vec2f(0.375, 0.375));
        return vec2u(partition_axis(first.x, draw.local.x, draw.local.z, !solid), partition_axis(first.y, draw.local.y, draw.local.w, !solid));
    }
    return vec2u(15u, 15u);
}

fn ordered_fragment(position: vec2f, range: vec2u, clear: vec4f) -> vec4f {
    var colors: array<vec4f, 16> = array(clear, clear, clear, clear, clear, clear, clear, clear, clear, clear, clear, clear, clear, clear, clear, clear);
    var groups = vec2u(1u, 1u);
    for (var cursor = range.x; cursor < range.y; cursor++) {
        let draw = load_banked_draw(INDICES[u32(cursor)]);
        let lowered = ((draw.atlas.x & 4026531840u) == 268435456u);
        let missed = (lowered && mask_pixel_misses(draw, position));
        let first_source = first_missed_sample(draw, position, missed);
        let cached = ((lowered && !missed) && mask_pixel_inside_clip(draw, position));
        var first = vec2f(0.0, 0.0);
        var coverage = vec4f(0.0, 0.0, 0.0, 0.0);
        if cached {
            first = floor(((position - vec2f(0.375, 0.375)) - draw.local.xy));
            let last = floor(((position + vec2f(0.375, 0.375)) - draw.local.xy));
            coverage = mask_pixel_coverage(draw, first, last);
        }
        if ((groups.x != 15u) || (groups.y != 15u)) {
            let previous = groups;
            let cuts = source_partitions(draw, position, missed, cached);
            groups = vec2u((groups.x | cuts.x), (groups.y | cuts.y));
            if ((groups.x != previous.x) || (groups.y != previous.y)) {
                var old_y: u32 = 0u;
                for (var y = 0; y < 4; y++) {
                    let y_bit = (1u << u32(y));
                    if ((previous.y & y_bit) != 0u) {
                        old_y = u32(y);
                    }
                    var old_x: u32 = 0u;
                    for (var x = 0; x < 4; x++) {
                        let x_bit = (1u << u32(x));
                        if ((previous.x & x_bit) != 0u) {
                            old_x = u32(x);
                        }
                        if ((((groups.x & x_bit) != 0u) && ((groups.y & y_bit) != 0u)) && (((previous.x & x_bit) == 0u) || ((previous.y & y_bit) == 0u))) {
                            colors[u32(((y * 4) + x))] = colors[u32(((old_y * 4u) + old_x))];
                        }
                    }
                }
            }
        }
        for (var y = 0; y < 4; y++) {
            for (var x = 0; x < 4; x++) {
                if (((groups.x & (1u << u32(x))) != 0u) && ((groups.y & (1u << u32(y))) != 0u)) {
                    let point = (position + vec2f((((f32(x) + 0.5) * 0.25) - 0.5), (((f32(y) + 0.5) * 0.25) - 0.5)));
                    let source = sample_cached_or_draw(draw, point, first, coverage, cached, missed, first_source);
                    let index = u32(((y * 4) + x));
                    colors[index] = (source + (colors[index] * (1.0 - source.w)));
                }
            }
        }
    }
    let anchor = colors[0];
    var delta = vec4f(0.0, 0.0, 0.0, 0.0);
    var row: u32 = 0u;
    for (var y = 0; y < 4; y++) {
        if ((groups.y & (1u << u32(y))) != 0u) {
            row = u32(y);
        }
        var column: u32 = 0u;
        for (var x = 0; x < 4; x++) {
            if ((groups.x & (1u << u32(x))) != 0u) {
                column = u32(x);
            }
            delta += ((colors[u32(((row * 4u) + column))] - anchor) * 0.0625);
        }
    }
    return output((anchor + delta));
}

@fragment fn fragment(@builtin(position) position: vec4f) -> @location(0) vec4f {
    let globals = GLOBALS;
    let tile = ((u32(position.x) / 16u) + ((u32(position.y) / 16u) * globals.viewport.z));
    let range = TILES[u32(tile)];
    if ((range.y & 2147483648u) != 0u) {
        if ((globals.viewport.w & 8u) != 0u) {
            return output(load_banked_draw(range.x).color);
        }
        return output(load_draw(range.x).color);
    }
    if (range.x == range.y) {
        return output(globals.clear);
    }
    if (((globals.viewport.w & 8u) != 0u) || ((range.y & 1073741824u) != 0u)) {
        return ordered_fragment(position.xy, vec2u(range.x, (range.y & 1073741823u)), globals.clear);
    }
    var anchor = vec4f(0.0, 0.0, 0.0, 0.0);
    var delta = vec4f(0.0, 0.0, 0.0, 0.0);
    for (var y = 0; y < 4; y++) {
        for (var x = 0; x < 4; x++) {
            let point = (position.xy + vec2f((((f32(x) + 0.5) * 0.25) - 0.5), (((f32(y) + 0.5) * 0.25) - 0.5)));
            var color = globals.clear;
            for (var cursor = range.x; cursor < range.y; cursor++) {
                let index = INDICES[u32(cursor)];
                let source = sample_draw(load_draw(index), point);
                color = (source + (color * (1.0 - source.w)));
            }
            if ((x == 0) && (y == 0)) {
                anchor = color;
            }
            delta += ((color - anchor) * 0.0625);
        }
    }
    return output((anchor + delta));
}
