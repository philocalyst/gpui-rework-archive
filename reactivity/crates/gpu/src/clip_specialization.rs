//! Cold compositor specialization of the authoritative typed shader output.
//!
//! Fail closed if its checked sampler or ordinary loop changes. Both outputs
//! subsequently undergo full WGSL validation and the same SPIR-V ABI proof.
fn replace(source: &str, from: &str, to: &str) -> String {
    assert_eq!(
        source.matches(from).count(),
        1,
        "clip specialization anchor"
    );
    source.replacen(from, to, 1)
}

pub fn specialize(source: &str) -> String {
    let source = replace(
        source,
        "fn sample_draw(draw: Draw, point: vec2f) -> vec4f {",
        "fn sample_draw_checked(draw: Draw, point: vec2f, chain_contains: bool) -> vec4f {",
    );
    let source = replace(
        &source,
        "if !clip_chain_contains(bitcast<u32>(draw.clip.y), point) {",
        "if !chain_contains {",
    );
    let source = replace(
        &source,
        "fn output(color: vec4f) -> vec4f {",
        "fn sample_draw(draw: Draw, point: vec2f) -> vec4f {\n    var contains = true;\n    if ((draw.atlas.w & 1073741824u) == 0u) && (bitcast<u32>(draw.clip.x) == 2143289347u) {\n        contains = clip_chain_contains(bitcast<u32>(draw.clip.y), point);\n    }\n    return sample_draw_checked(draw, point, contains);\n}\n\nfn output(color: vec4f) -> vec4f {",
    );
    let source = replace(
        &source,
        "            var color = globals.clear;\n            for (var cursor = range.x; cursor < range.y; cursor++) {",
        "            var color = globals.clear;\n            var cached_clip_address = 4294967295u;\n            var cached_clip_contains = true;\n            for (var cursor = range.x; cursor < range.y; cursor++) {",
    );
    replace(
        &source,
        "                let source = sample_draw(load_draw(index), point);",
        "                let draw = load_draw(index);\n                if (bitcast<u32>(draw.clip.x) == 2143289347u) {\n                    let address = bitcast<u32>(draw.clip.y);\n                    if (cached_clip_address != address) {\n                        cached_clip_contains = clip_chain_contains(address, point);\n                        cached_clip_address = address;\n                    }\n                }\n                let source = sample_draw_checked(draw, point, cached_clip_contains);",
    )
}
