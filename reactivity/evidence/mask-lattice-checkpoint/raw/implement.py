from pathlib import Path
r=Path('/home/user/gpui-mask-lattice-lab/reactivity/crates/gpu/src')
p=r/'renderer.rs';s=p.read_text();anchor='const LOWERED_SOLID: u32 = 1 << 30;';assert s.count(anchor)==1
s=s.replace(anchor,anchor+'''
// Mask atlas x coordinates occupy low bits; source bits 29..31 name other
// materials. Bit 28 certifies sample-address lowering for this placement only.
const LOWERED_MASK: u32 = 1 << 28;
mod mask_lattice;
use mask_lattice::lowered_mask_rect;
''')
old='''                    let r = if lower_solid {
                        sampled_solid_rect(&draw, [scene.width, scene.height])?
                    } else {
                        draw.local_rect
                    };'''
new='''                    let mask_rect = lowered_mask_rect(&draw);
                    let r = if lower_solid {
                        sampled_solid_rect(&draw, [scene.width, scene.height])?
                    } else {
                        mask_rect.unwrap_or(draw.local_rect)
                    };'''
assert s.count(old)==1;s=s.replace(old,new)
s=s.replace('[0, 0, 0, common],','[u32::from(mask_rect.is_some()) * LOWERED_MASK, 0, 0, common],')
old='''                    let mut packet_draw = draw;
                    if lower_solid {''';new='''                    let mut packet_draw = draw;
                    let mask_rect = lowered_mask_rect(&draw);
                    if let Some(rect) = mask_rect {
                        packet_draw.local_rect = rect;
                    }
                    if lower_solid {''';assert s.count(old)==1;s=s.replace(old,new)
old='''                    let mut words = inline_words(packet_draw, error, correction);
                    if let Some(chain)''';new='''                    let mut words = inline_words(packet_draw, error, correction);
                    words[5][0] = u32::from(mask_rect.is_some()) * LOWERED_MASK;
                    if let Some(chain)''';assert s.count(old)==1;s=s.replace(old,new)
s=s.replace('''                let atlas = if let Some((gradient, radius)) = source.gradient() {''','''                let mut atlas = if let Some((gradient, radius)) = source.gradient() {''')
old='''                self.records[word + if compact { 1 } else { 5 }][..3].copy_from_slice(&atlas);'''
new='''                let material = &mut self.records[word + if compact { 1 } else { 5 }];
                atlas[0] |= material[0] & LOWERED_MASK;
                material[..3].copy_from_slice(&atlas);''';assert s.count(old)==1;s=s.replace(old,new)
p.write_text(s)
p=r/'renderer/mask_lattice.rs';assert not p.exists();p.write_text('''//! Address-equivalent lowering on the fixed 4x4 lattice; canonical geometry
//! stays in the scene for admission, clipping, binning and publication.
use gpui_canvas::{PreparedDraw, Rect};

pub(super) fn lowered_mask_rect(draw: &PreparedDraw<'_>) -> Option<Rect> {
    let mask = draw.source.mask()?;
    if draw.inverse[..4] != [1.0, 0.0, 0.0, 1.0]
        || draw.local_rect.width as f64 != mask.width as f64
        || draw.local_rect.height as f64 != mask.height as f64
    {
        return None;
    }
    let mut rect = draw.local_rect;
    for (origin, translation) in [(&mut rect.x, draw.inverse[4]), (&mut rect.y, draw.inverse[5])] {
        // Scaling by 2^32 leaves integral operands below 2^49. Including the
        // viewport point and subtracting the other operand stays below 2^51:
        // every canonical f64 map/subtraction is exact, including sample ties.
        if [f64::from(*origin), translation].into_iter().any(|v| {
            !v.is_finite() || v.abs() > 131_072.0 || (v * 4_294_967_296.0).fract() != 0.0
        }) {
            return None;
        }
        let device_origin = f64::from(*origin) - translation;
        // At odd-eighth sample points this quarter boundary gives the same
        // floor(point-origin). Integer extents preserve the half-open edges.
        // The bounded quarter origin and their f32 differences are exact.
        *origin = (((device_origin - 0.125) * 4.0).ceil() * 0.25) as f32;
    }
    Some(rect)
}
''')
p=r/'shader.rs';s=p.read_text();anchor='''        if (draw.atlas.x & 0x20000000) != 0 && (draw.atlas.x & 0x80000000) == 0 {''';assert s.count(anchor)==1
s=s.replace(anchor,'''        // The host certified this placement's exact sample-to-texel mapping.
        // Clip/correction handling above remains the canonical generic path.
        if (draw.atlas.x & 0x10000000) != 0 {
            let position = point - draw.local.xy();
            if position.x < 0.0 || position.y < 0.0
                || position.x >= draw.local.z || position.y >= draw.local.w
            {
                return vec4f(0.0, 0.0, 0.0, 0.0);
            }
            let texel = vec2i(
                (draw.atlas.x & 0x0fffffff) as i32 + floor(position.x) as i32,
                draw.atlas.y as i32 + floor(position.y) as i32,
            );
            return draw.color * texture_load(MASKS, texel, 0).x;
        }
'''+anchor);p.write_text(s)
