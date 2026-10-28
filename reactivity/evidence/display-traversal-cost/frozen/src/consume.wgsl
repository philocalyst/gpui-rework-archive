// Fixed two-level 32-way directory. Each compressed block contains 32 records.
// All addressing is in u32 words. Every field decodes in at most two data loads.
@group(0) @binding(0) var<storage, read> arena: array<u32>;
@group(0) @binding(1) var<storage, read> descriptor: array<u32>;
@group(0) @binding(2) var<storage, read_write> pixels: array<u32>;
@group(0) @binding(3) var<storage, read_write> decoded: array<u32>;
fn field(slot: u32, col: u32) -> u32 {
    let block = slot >> 5u;
    let leaf = arena[descriptor[0] + (block >> 5u)];
    let base = arena[leaf + (block & 31u)];
    let row = slot & 31u;
    if arena[base] == 0u { return arena[base + 1u + row * 12u + col]; }
    let h = base + 1u + col * 3u;
    let origin = arena[h];
    let bits = arena[h + 1u];
    if bits == 0u { return origin; }
    let bit = row * bits;
    let start = base + arena[h + 2u] + bit / 32u;
    let shift = bit & 31u;
    var value = arena[start] >> shift;
    if shift + bits > 32u { value |= arena[start + 1u] << (32u - shift); }
    if bits < 32u { value &= (1u << bits) - 1u; }
    return origin + value;
}
@compute @workgroup_size(64)
fn decode(@builtin(global_invocation_id) tid: vec3<u32>) {
    let i = tid.x;
    if i < descriptor[4] * 12u { decoded[i] = field(i / 12u, i % 12u); }
}
@compute @workgroup_size(64)
fn render(@builtin(global_invocation_id) tid: vec3<u32>) {
    let i = tid.x;
    if i >= 4096u || descriptor[5] != descriptor[6] { return; }
    let x = i & 63u;
    let y = i >> 6u;
    if x < descriptor[8] || y < descriptor[9] || x >= descriptor[10] || y >= descriptor[11] { return; }
    var color = descriptor[12];
    var slot = descriptor[1];
    for (var n = 0u; n < descriptor[2]; n++) {
        if field(slot, 10u) != 0u && x >= field(slot, 5u) && y >= field(slot, 6u) && x < field(slot, 7u) && y < field(slot, 8u) {
            let paint = field(slot, 9u);
            if (paint >> 24u) == 255u { color = paint; }
        }
        if descriptor[3] == 0u { slot += 1u; } else { slot = field(slot, 3u); }
    }
    pixels[i] = color;
}
