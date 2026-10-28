from pathlib import Path
w=Path('/home/user/gpui-damage-suffix-lab')
p=w/'reactivity/crates/canvas/src/canvas.rs';s=p.read_text();old='''        // Zip may consume an unmatched item from its first iterator. Bound the
''';assert s.count(old)==1
s=s.replace(old,'''        // A variable-length edit shifts following painter addresses. Remove
        // only a suffix with exactly equal contributions before pairing the
        // remaining prefix. The first unequal reverse pair was consumed too:
        // both supports must be retained, even if one stream is now empty.
        if previous.len() != next.len() {
            while !previous.len().min(next.len()).eq(&0) {
                let old = previous.next_back().unwrap();
                let new = next.next_back().unwrap();
                if !old.unchanged(new) {
                    damage = damage
                        .union(DamageRegion::checked_canvas_bounds(old.bounds))
                        .union(DamageRegion::checked_canvas_bounds(new.bounds));
                    break;
                }
            }
        }
'''+old).replace('while !previous.len().min(next.len()).eq(&0) {','while previous.len().min(next.len()) != 0 {')
p.write_text(s)
p=w/'reactivity/crates/canvas/tests/damage_suffix.rs';p.write_text('''use gpui_canvas::{Affine, Canvas, Color, DamageRegion, Point, Rect, TextSystem};
const SIZE: [u32; 2] = [192, 120];
const CLIP: Rect = Rect::new(0.25, 0.5, 191.25, 119.);

fn pixels(canvas: &mut Canvas) -> Vec<u32> {
    let mut out = vec![0; (SIZE[0] * SIZE[1]) as usize];
    canvas.render_bgrx(&mut out).unwrap();
    out
}
fn repair(canvas: &mut Canvas, old: &mut [u32], next: &[u32], damage: DamageRegion) {
    for (index, (a, b)) in old.iter().zip(next).enumerate() {
        if a != b {
            let [l, t, r, b] = damage.bounds().expect("changed pixel needs support");
            let x = index as u32 % SIZE[0];
            let y = index as u32 / SIZE[0];
            assert!(x >= l && x < r && y >= t && y < b, "lost reverse mismatch at {x},{y}");
        }
    }
    canvas.render_bgrx_region(old, damage).unwrap();
    assert_eq!(old, next);
}
fn shapes(canvas: &mut Canvas, ids: &[u32]) -> DamageRegion {
    let mut scene = canvas.stage();
    scene.clear(Color::WHITE);
    for &id in ids {
        let (x, y) = if id == 90 { (142., 84.) } else { ((id % 4) as f32 * 9. + 2., (id / 4) as f32 * 7. + 2.) };
        scene.fill_rect(Rect::new(x, y, 22.5, 19.25), Affine::IDENTITY, CLIP,
            Color::linear_display_p3(0.1 * (id % 7) as f32, 0.3, 0.8, 0.6).unwrap()).unwrap();
    }
    scene.commit_with_damage()
}
#[test]
fn unequal_streams_keep_every_changed_pixel_and_exclude_equal_distant_suffix() {
    for proofs in [false, true] {
        let mut canvas = Canvas::recording(SIZE[0], SIZE[1], Default::default()).unwrap();
        canvas.set_tile_proofs(proofs);
        shapes(&mut canvas, &[1, 90]);
        let mut old = pixels(&mut canvas);
        for ids in [vec![1, 2, 3, 90], vec![1, 90], vec![90], vec![1, 2, 90], vec![3, 2, 90], vec![1], vec![], vec![1, 2, 90], vec![2, 1, 90]] {
            let damage = shapes(&mut canvas, &ids);
            let mut fresh = Canvas::recording(SIZE[0], SIZE[1], Default::default()).unwrap();
            shapes(&mut fresh, &ids);
            repair(&mut canvas, &mut old, &pixels(&mut fresh), damage);
        }
        shapes(&mut canvas, &[1, 90]);
        let damage = shapes(&mut canvas, &[1, 2, 90]);
        assert!(damage.bounds().unwrap()[2] < 100, "unchanged suffix inflated damage");
        let damage = shapes(&mut canvas, &[1, 90]);
        assert!(damage.bounds().unwrap()[2] < 100, "removal inflated damage");
    }
}
fn text_scene(canvas: &mut Canvas, text: &mut TextSystem, value: &str, transform: Affine) -> DamageRegion {
    let layout = text.shape(value, 14., None).unwrap();
    let suffix = text.shape("retained 0123456789", 14., None).unwrap();
    let mut scene = canvas.stage();
    scene.clear(Color::rgb(23, 31, 47));
    scene.draw_text_scaled(text, &layout, Point { x: 3.25, y: 2.5 }, transform, CLIP, Color::WHITE, 1.).unwrap();
    scene.draw_text_scaled(text, &suffix, Point { x: 3.25, y: 84.5 }, transform, CLIP, Color::WHITE, 1.).unwrap();
    scene.commit_with_damage()
}
#[test]
fn growing_and_shrinking_glyph_runs_retain_clipped_transformed_suffix() {
    for transform in [Affine::IDENTITY, Affine { a: -1., b: 0., c: 0.1, d: 1., tx: 185., ty: 0.25 }] {
        let mut text = TextSystem::bundled().unwrap();
        let mut canvas = Canvas::recording(SIZE[0], SIZE[1], Default::default()).unwrap();
        text_scene(&mut canvas, &mut text, "", transform);
        let mut old = pixels(&mut canvas);
        for value in ["1", "123456", "1234567890", "12", "", "99", "98"] {
            let damage = text_scene(&mut canvas, &mut text, value, transform);
            let mut fresh = Canvas::recording(SIZE[0], SIZE[1], Default::default()).unwrap();
            text_scene(&mut fresh, &mut text, value, transform);
            repair(&mut canvas, &mut old, &pixels(&mut fresh), damage);
            if let Some([_, _, _, bottom]) = damage.bounds() {
                assert!(bottom < 80, "unchanged glyph suffix inflated damage");
            }
        }
    }
}
''')
p=w/'reactivity/crates/gpui/examples/zgx_native_lab.rs';s=p.read_text();at=s.index('#[cfg(test)]\n#[allow(dead_code)]\npub(crate) struct CostFixture')
s=s[:at]+'''#[cfg(test)]
#[allow(dead_code)]
pub(crate) fn visit_cold_stream_frames(
    mut visit: impl FnMut(&mut gpui::Win<Lab>, &mut gpui::Win<Lab>, bool, usize),
) {
    for owner_route in [false, true] {
        let work = Workload {
            text: String::with_capacity(8256),
            scroll_offset: 0.,
            frames: 0,
            mode: Mode::Stream,
            seconds: 1.,
        };
        let mut window = port_tests::window(&work);
        let (delivered, _received) = std::sync::mpsc::channel();
        let mut driver = Driver { work, received: 0, delivered };
        visit(&mut window, &mut port_tests::window(&driver.work), owner_route, 0);
        for tick in 1..=24 {
            if owner_route {
                window.update(|model| driver.owner(model, false)).unwrap();
            } else {
                let mut value = String::new();
                driver.stream(&mut value, false);
                window.set(Lab::STREAM, value).unwrap();
            }
            visit(&mut window, &mut port_tests::window(&driver.work), owner_route, tick);
        }
    }
}

'''+s[at:];p.write_text(s)
p=w/'reactivity/crates/gpui/src/native/text_repair_tests.rs';s=p.read_text();s=s.replace('    eprintln!("NATIVE_TEXT_REPAIR,', '    cold_stream(gpu);\n    eprintln!("NATIVE_TEXT_REPAIR,');s+='''
fn cold_stream(gpu: &mut GpuSurface) {
    let texture = gpu.renderer.device().create_texture(&wgpu::TextureDescriptor {
        label: Some("native growing stream oracle"),
        size: wgpu::Extent3d { width: 960, height: 720, depth_or_array_layers: 1 },
        mip_level_count: 1,
        sample_count: 1,
        dimension: wgpu::TextureDimension::D2,
        format: gpu.renderer.format(),
        usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
        view_formats: &[],
    });
    let view = texture.create_view(&Default::default());
    let mut full = pollster::block_on(Renderer::new(
        gpu.renderer.device().clone(), gpu.renderer.queue().clone(), gpu.renderer.format(),
    )).unwrap();
    super::workload_port::visit_cold_stream_frames(|owner, fresh, owner_route, tick| {
        let token = owner.with_paint_scene(|scene, token, paint, damage| {
            gpu.render_damaged(scene, token, paint, &view, Some(damage)).unwrap();
            token
        }).unwrap();
        let actual = super::paint_tests::read(gpu, &texture);
        fresh.with_scene(|scene, _| full.render(scene, &view)).unwrap().unwrap();
        assert!(actual == super::paint_tests::read(gpu, &texture),
            "growing stream differs from fresh full scene: owner={owner_route} tick={tick}");
        println!("COLD_STREAM_SUPPORT,{owner_route},{tick},{}", gpu.renderer.retained_stats().composited_pixels);
        // Skip two adjacent ACKs to exercise damage relative to an older P.
        if !matches!(tick, 4 | 5) {
            owner.presented(token).unwrap();
        }
    });
}
''';p.write_text(s)
print('implemented exact suffix and public pixel/owner tests')
