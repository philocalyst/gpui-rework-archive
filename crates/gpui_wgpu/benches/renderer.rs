use criterion::{Criterion, criterion_group, criterion_main};
use gpui::{
    Bounds, ContentMask, DevicePixels, PlatformHeadlessRenderer, Point, Quad, ScaledPixels, Scene,
    Size, solid_background,
};
use gpui_ce_wgpu::WgpuHeadlessRenderer;

const TARGET_SIZE: Size<DevicePixels> = Size {
    width: DevicePixels(1280),
    height: DevicePixels(720),
};

fn quad_scene(count: usize) -> Scene {
    let mut scene = Scene::default();
    for index in 0..count {
        let column = index % 32;
        let row = index / 32;
        let bounds = Bounds {
            origin: Point {
                x: ScaledPixels((column * 40) as f32),
                y: ScaledPixels((row * 40) as f32),
            },
            size: Size {
                width: ScaledPixels(36.0),
                height: ScaledPixels(36.0),
            },
        };
        scene.insert_primitive(Quad {
            order: index as u32,
            bounds,
            content_mask: ContentMask { bounds },
            background: solid_background(gpui::rgb(0x336699)),
            ..Default::default()
        });
    }
    scene.finish();
    scene
}

fn bench_renderer(c: &mut Criterion) {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless WGPU renderer must initialize");
    let single_quad = quad_scene(1);
    let dense_quads = quad_scene(512);

    let mut group = c.benchmark_group("renderer_end_to_end");
    group.bench_function("single_quad", |b| {
        b.iter(|| {
            renderer
                .render_scene_to_image(&single_quad, TARGET_SIZE)
                .expect("single quad render must succeed")
        })
    });
    group.bench_function("512_quads", |b| {
        b.iter(|| {
            renderer
                .render_scene_to_image(&dense_quads, TARGET_SIZE)
                .expect("dense quad render must succeed")
        })
    });
    group.finish();
}

criterion_group!(benches, bench_renderer);
criterion_main!(benches);
