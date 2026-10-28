from pathlib import Path
r=Path('/home/user/gpui-mask-lattice-lab/reactivity/crates/gpu/src')
p=r/'renderer.rs';s=p.read_text().replace('lowered_mask_rect(&draw);','lowered_mask_rect(&draw, error);');assert s.count('lowered_mask_rect(&draw, error);')==2;p.write_text(s)
p=r/'renderer/mask_lattice.rs';s=p.read_text().replace("pub(super) fn lowered_mask_rect(draw: &PreparedDraw<'_>) -> Option<Rect> {", "pub(super) fn lowered_mask_rect(draw: &PreparedDraw<'_>, error: [f32; 2]) -> Option<Rect> {")
old='''    for (origin, translation) in [
        (&mut rect.x, draw.inverse[4]),
        (&mut rect.y, draw.inverse[5]),
    ] {'''
assert old in s
new='''    for ((origin, translation, extent), error) in [
        (&mut rect.x, draw.inverse[4], rect.width),
        (&mut rect.y, draw.inverse[5], rect.height),
    ].into_iter().zip(error) {''';s=s.replace(old,new)
old='''        let device_origin = f64::from(*origin) - translation;
        // At odd-eighth'''
new='''        let device_origin = f64::from(*origin) - translation;
        // Also preserve the existing GPU sampler, whose two-float correction
        // can differ from the scalar oracle immediately beside a texel tie.
        // CSR visits extend at most one 16px tile beyond these unit bounds.
        // Stay beyond both its position error and normalization/correction
        // envelope, with fourfold headroom; ambiguous phases keep that path.
        let phase = (device_origin - 0.125) * 4.0;
        let distance = (phase - phase.round()).abs() * 0.25;
        let margin = 4.0 * (f64::from(error) + (f64::from(extent) + 32.0) * 3.8146973e-6);
        if distance <= margin {
            return None;
        }
        // At odd-eighth''';assert old in s;s=s.replace(old,new);p.write_text(s)
p=r/'renderer/mask_lattice_tests.rs';s=p.read_text()
s=s.replace('lowered_mask_rect(&draw)', 'lowered_mask_rect(&draw, [0.; 2])').replace('lowered_mask_rect(&original)', 'lowered_mask_rect(&original, [0.; 2])')
s=s.replace('''lowered_mask_rect(&PreparedDraw {
                inverse,
                ..original
            })''','''lowered_mask_rect(&PreparedDraw {
                inverse,
                ..original
            }, [0.; 2])''')
s=s.replace('assert_eq!(admitted, 513 * 2 * 5);','assert!(admitted > 3_000, "exercise a nontrivial admitted domain: {admitted}");')
old='''    for value in [
        0.125_f32.next_down(),
        0.125,
        0.125_f32.next_up(),
        131_072.,
        -131_072.,
    ] {'''
new='''    for value in [0.125_f32.next_down(), 0.125, 0.125_f32.next_up()] {
        let mut draw = original;
        draw.local_rect.x = value;
        assert!(lowered_mask_rect(&draw, [0.; 2]).is_none(), "GPU ambiguous sample phase");
    }
    for value in [0.0625, 0.1875, 131_072., -131_072.] {''';assert old in s;s=s.replace(old,new)
# Mechanism check reads the actual error envelope uploaded with each record.
old='''                    if compact {
                        cursor += 5;
                    }
                    for placement'''
new='''                    let common = cursor;
                    if compact {
                        cursor += 5;
                    }
                    for placement''';assert old in s;s=s.replace(old,new)
old='''                        let lowered = lowered_mask_rect(&draw, [0.; 2]);
                        let tag'''
new='''                        let state = if compact { common } else { cursor + 1 };
                        let error = [gpu.state.records[state][3], gpu.state.records[state + 1][3]].map(f32::from_bits);
                        let lowered = lowered_mask_rect(&draw, error);
                        let tag''';assert old in s;s=s.replace(old,new);p.write_text(s)
p=Path('/home/user/gpui-mask-lattice-lab/reactivity/evidence/mask-lattice/GPU_EQUIVALENCE.md');p.write_text('''# Admission narrowed before any performance observation

The first implementation837a23d44e72d3893cbbcf92e17434b1076b8d1a passes353 GPU/
canvas tests and strict Clippy, and the scalar address oracle passes. Independent
pre-change GPU capture6faae98aa7391ede8f07f9325e63f044f1de9adf nevertheless differs
in12/336 frames: near-boundary origin2.125.next_up(), zero horizontal translation,
all three formats, both paint routes and both record modes.99 SDR pixels/106 HDR
pixels differ. Full bytes, hashes and first mismatch evidence remain external.
No tolerance, pixel subset or performance observation is introduced.

Canonical address equivalence alone does not prove equality with the existing
GPU correction/normalization path at numerically ambiguous texel boundaries.
Narrow eligibility using the actual uploaded per-axis error (shared maximum for
compact groups). Distance of the canonical device origin from the odd-eighth
sample lattice must exceed4*(error+(extent+32)*3.8146973e-6). Unit-scale CSR bins
extend at most one16-pixel tile beyond a glyph's canonical bounds. The extra32
and fourfold factor enclose ordinary position, normalization and correction
threshold errors. Near-tie and exact-tie phases keep the original generic GPU
sampler; admitted samples remain outside its correction branch and retain the
same scalar cell. This is a stricter input certificate, not a changed output
oracle. No canonical geometry or clipping changes; all16 samples remain.

The revised production source and all GPU/numerical/public tests must be frozen
and rerun, including the identical336-frame independent oracle and a new bounded
width mutant on the revised source. All earlier failures stay failed. The native
performance schedule/gates are unchanged and have not begun.
''')
