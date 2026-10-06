use criterion::{BatchSize, Criterion, black_box, criterion_group, criterion_main};
use gpui::{
    Bounds, ContentMask, Corners, DevicePixels, PlatformHeadlessRenderer, Point, Quad,
    ScaledPixels, Scene, ShaderBool, Size, TransformationMatrix, Underline, point, radians,
    solid_background, white,
};
use gpui_ce_wgpu::WgpuHeadlessRenderer;

const TARGET_SIZE: Size<DevicePixels> = Size {
    width: DevicePixels(1280),
    height: DevicePixels(720),
};

fn quad_scene(count: usize) -> Scene {
    let mut scene = unplanned_quad_scene(count);
    scene.finish();
    scene
}

fn smoothed_quad_scene(count: usize, corner_radii: Corners<ScaledPixels>) -> Scene {
    let mut scene = unplanned_quad_scene(count);
    for quad in &mut scene.quads {
        quad.corner_radii = corner_radii;
        quad.corner_smoothing = 1.0;
    }
    scene.finish();
    scene
}

fn alternating_corner_modes_scene(count: usize) -> Scene {
    let mut scene = unplanned_quad_scene(count);
    for (index, quad) in scene.quads.iter_mut().enumerate() {
        quad.corner_radii = Corners::all(ScaledPixels(8.0));
        quad.corner_smoothing = if index % 2 == 0 { 0.0 } else { 1.0 };
    }
    scene.finish();
    scene
}

fn unplanned_quad_scene(count: usize) -> Scene {
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
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            background: solid_background(gpui::rgb(0x336699)),
            ..Default::default()
        });
    }
    scene
}

fn unplanned_mixed_scene(count: usize) -> Scene {
    let mut scene = Scene::default();
    let bounds = Bounds {
        origin: Point {
            x: ScaledPixels(0.0),
            y: ScaledPixels(0.0),
        },
        size: Size {
            width: ScaledPixels(1.0),
            height: ScaledPixels(1.0),
        },
    };
    for index in 0..count {
        scene.insert_primitive(Quad {
            order: (index * 2) as u32,
            bounds,
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            background: solid_background(gpui::rgb(0x336699)),
            ..Default::default()
        });
        scene.insert_primitive(Underline {
            order: (index * 2 + 1) as u32,
            padding: 0,
            bounds,
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            color: white().into(),
            thickness: ScaledPixels(1.0),
            wavy: ShaderBool::Disabled,
        });
    }
    scene
}

fn transformed_quad_scene(count: usize, transform: TransformationMatrix) -> Scene {
    let mut scene = Scene::default();
    scene.with_transform(transform, |scene| {
        for quad in &unplanned_quad_scene(count).quads {
            scene.insert_primitive(*quad);
        }
    });
    scene.finish();
    scene
}

fn nested_rotated_clip_scene(depth: usize, count: usize) -> Scene {
    fn descend(scene: &mut Scene, level: usize, depth: usize, count: usize) {
        if level == depth {
            let content = unplanned_quad_scene(count);
            for quad in &content.quads {
                scene.insert_primitive(*quad);
            }
            return;
        }

        let transform = TransformationMatrix::unit()
            .rotate(radians(0.035 + level as f32 * 0.002))
            .translate(point(ScaledPixels(2.0), ScaledPixels(1.5)))
            .scale(Size::new(1.002, 0.998));
        let clip = ContentMask {
            bounds: Bounds {
                origin: Point {
                    x: ScaledPixels(-4096.0),
                    y: ScaledPixels(-4096.0),
                },
                size: Size {
                    width: ScaledPixels(8192.0),
                    height: ScaledPixels(8192.0),
                },
            },
            ..Default::default()
        };
        scene.with_transform(transform, |scene| {
            scene.with_clip(clip, |scene| descend(scene, level + 1, depth, count));
        });
    }

    let mut scene = Scene::default();
    descend(&mut scene, 0, depth, count);
    scene.finish();
    scene
}

fn bench_renderer(criterion: &mut Criterion) {
    let mut renderer = WgpuHeadlessRenderer::new().expect("headless WGPU renderer must initialize");
    let single_quad = quad_scene(1);
    let dense_quads = quad_scene(512);
    let compact_smoothed_quads = smoothed_quad_scene(512, Corners::all(ScaledPixels(8.0)));
    let reach_aware_smoothed_quads = smoothed_quad_scene(
        512,
        Corners {
            top_left: ScaledPixels(14.0),
            top_right: ScaledPixels(0.0),
            bottom_right: ScaledPixels(0.0),
            bottom_left: ScaledPixels(0.0),
        },
    );
    let alternating_corner_modes = alternating_corner_modes_scene(512);
    let mut mixed_batches = unplanned_mixed_scene(512);
    mixed_batches.finish();

    let mut group = criterion.benchmark_group("renderer_end_to_end");
    group.bench_function("single_quad", |bencher| {
        bencher.iter(|| {
            renderer
                .render_scene_to_image(&single_quad, TARGET_SIZE)
                .expect("single quad render must succeed")
        })
    });
    group.bench_function("512_quads", |bencher| {
        bencher.iter(|| {
            renderer
                .render_scene_to_image(&dense_quads, TARGET_SIZE)
                .expect("dense quad render must succeed")
        })
    });
    group.bench_function("single_quad_wait", |bencher| {
        bencher.iter(|| {
            renderer
                .render_scene_and_wait(&single_quad, TARGET_SIZE)
                .expect("single quad render must succeed")
        })
    });
    group.bench_function("512_quads_wait", |bencher| {
        bencher.iter(|| {
            renderer
                .render_scene_and_wait(&dense_quads, TARGET_SIZE)
                .expect("dense quad render must succeed")
        })
    });
    group.bench_function("512_compact_smoothed_quads_wait", |bencher| {
        bencher.iter(|| {
            renderer
                .render_scene_and_wait(&compact_smoothed_quads, TARGET_SIZE)
                .expect("compact smoothed quad render must succeed")
        })
    });
    group.bench_function("512_reach_aware_smoothed_quads_wait", |bencher| {
        bencher.iter(|| {
            renderer
                .render_scene_and_wait(&reach_aware_smoothed_quads, TARGET_SIZE)
                .expect("reach-aware smoothed quad render must succeed")
        })
    });
    group.bench_function("512_alternating_corner_modes_wait", |bencher| {
        bencher.iter(|| {
            renderer
                .render_scene_and_wait(&alternating_corner_modes, TARGET_SIZE)
                .expect("alternating corner modes must render successfully")
        })
    });
    group.bench_function("1024_mixed_batches_wait", |bencher| {
        bencher.iter(|| {
            renderer
                .render_scene_and_wait(&mixed_batches, TARGET_SIZE)
                .expect("mixed batch render must succeed")
        })
    });
    group.finish();

    let identity_512 = quad_scene(512);
    let shared_pan_zoom = transformed_quad_scene(
        512,
        TransformationMatrix::unit()
            .translate(point(ScaledPixels(24.0), ScaledPixels(18.0)))
            .rotate(radians(0.08))
            .scale(Size::new(1.25, 1.25)),
    );
    let nested_clip_scenes = [1, 4, 16].map(|depth| (depth, nested_rotated_clip_scene(depth, 512)));
    let mut group = criterion.benchmark_group("coordinate_spaces_render_wait");
    group.sample_size(30);
    group.bench_function("identity_512", |bencher| {
        bencher.iter(|| {
            renderer
                .render_scene_and_wait(black_box(&identity_512), TARGET_SIZE)
                .expect("identity scene render must succeed")
        })
    });
    group.bench_function("shared_pan_zoom_512", |bencher| {
        bencher.iter(|| {
            renderer
                .render_scene_and_wait(black_box(&shared_pan_zoom), TARGET_SIZE)
                .expect("shared pan/zoom scene render must succeed")
        })
    });
    for (depth, scene) in &nested_clip_scenes {
        group.bench_function(
            format!("nested_rotated_clips_depth_{depth}_512"),
            |bencher| {
                bencher.iter(|| {
                    renderer
                        .render_scene_and_wait(black_box(scene), TARGET_SIZE)
                        .expect("nested clip scene render must succeed")
                })
            },
        );
    }
    group.finish();

    let mut group = criterion.benchmark_group("scene_plan");
    group.bench_function("compile_1024_mixed_batches", |bencher| {
        bencher.iter_batched(
            || unplanned_mixed_scene(512),
            |mut scene| {
                scene.finish();
                black_box(*scene.render_plan().requirements())
            },
            BatchSize::SmallInput,
        )
    });
    let mut mixed_scene = unplanned_mixed_scene(512);
    mixed_scene.finish();
    group.bench_function("traverse_1024_mixed_batches", |bencher| {
        bencher.iter(|| {
            for command in mixed_scene.render_commands() {
                black_box(command);
            }
        })
    });
    group.finish();
}

criterion_group!(benches, bench_renderer);
criterion_main!(benches);
