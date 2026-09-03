use criterion::{
    BatchSize, BenchmarkGroup, Criterion, Throughput, black_box, criterion_group, criterion_main,
};
use gpui::{
    Background, Bounds, ContentMask, Point, Quad, Scene, SceneArchive, ScaledPixels, ShaderBool,
    Size, Underline, linear_color_stop, linear_gradient, rgb, solid_background, white,
};
use std::time::Duration;

const GRID_COLUMNS: usize = 32;

// Deterministic corpora: indexes map to a fixed 40px grid, no RNG anywhere.
fn grid_bounds(index: usize) -> Bounds<ScaledPixels> {
    Bounds {
        origin: Point {
            x: ScaledPixels(((index % GRID_COLUMNS) * 40) as f32),
            y: ScaledPixels(((index / GRID_COLUMNS) * 40) as f32),
        },
        size: Size {
            width: ScaledPixels(36.0),
            height: ScaledPixels(36.0),
        },
    }
}

fn solid() -> Background {
    solid_background(rgb(0x336699))
}

fn gradient() -> Background {
    linear_gradient(
        45.0,
        linear_color_stop(rgb(0x336699), 0.0),
        linear_color_stop(rgb(0x99ccff), 1.0),
    )
}

fn quad(bounds: Bounds<ScaledPixels>, background: Background) -> Quad {
    Quad {
        bounds,
        content_mask: ContentMask { bounds },
        background,
        ..Default::default()
    }
}

fn underline(bounds: Bounds<ScaledPixels>) -> Underline {
    Underline {
        order: 0,
        padding: 0,
        bounds,
        content_mask: ContentMask { bounds },
        color: white().into(),
        thickness: ScaledPixels(1.0),
        wavy: ShaderBool::Disabled,
    }
}

fn insert_quads(scene: &mut Scene, count: usize, background: Background) {
    for index in 0..count {
        let bounds = grid_bounds(index);
        scene.insert_primitive(quad(bounds, background));
    }
}

/// Inserts `count / 2` quad + `count / 2` underline pairs (total `count` primitives).
fn insert_mixed(scene: &mut Scene, count: usize) {
    for index in 0..count / 2 {
        let bounds = grid_bounds(index);
        scene.insert_primitive(quad(bounds, solid()));
        scene.insert_primitive(underline(bounds));
    }
}

fn unplanned_mixed(count: usize) -> Scene {
    let mut scene = Scene::default();
    insert_mixed(&mut scene, count);
    scene
}

/// Builds `depth` nested layers, one quad each, then finishes.
fn layered_scene(depth: usize, background: Background) -> Scene {
    let mut scene = Scene::default();
    for index in 0..depth {
        scene.push_layer(grid_bounds(index));
        scene.insert_primitive(quad(grid_bounds(index), background));
    }
    for _ in 0..depth {
        scene.pop_layer();
    }
    scene.finish();
    scene
}

fn configure(group: &mut BenchmarkGroup<'_, criterion::measurement::WallTime>) {
    group.measurement_time(Duration::from_secs(3));
    group.sample_size(30);
    group.warm_up_time(Duration::from_secs(1));
}

fn bench_scene_build(c: &mut Criterion) {
    let background = solid();
    let mut group = c.benchmark_group("scene_build");
    configure(&mut group);

    for count in [1usize, 64, 1024] {
        group.throughput(Throughput::Elements(count as u64));
        group.bench_function(format!("quads_{count}"), |b| {
            b.iter_batched(
                || Scene::default(),
                |mut scene| {
                    insert_quads(&mut scene, count, background);
                    scene.finish();
                    black_box(scene);
                },
                BatchSize::SmallInput,
            )
        });
    }

    group.throughput(Throughput::Elements(1024));
    group.bench_function("mixed_quad_underline_1024", |b| {
        b.iter_batched(
            || Scene::default(),
            |mut scene| {
                insert_mixed(&mut scene, 1024);
                scene.finish();
                black_box(scene);
            },
            BatchSize::SmallInput,
        )
    });

    group.throughput(Throughput::Elements(8)); // Elements = layers
    group.bench_function("layers_depth_8", |b| {
        b.iter(|| black_box(layered_scene(8, background)))
    });
    group.finish();
}

fn bench_scene_plan(c: &mut Criterion) {
    let mut group = c.benchmark_group("scene_plan");
    configure(&mut group);
    group.throughput(Throughput::Elements(1024));

    group.bench_function("compile_1024_mixed", |b| {
        b.iter_batched(
            || unplanned_mixed(1024),
            |mut scene| {
                scene.finish();
                black_box(*scene.render_plan().requirements());
            },
            BatchSize::SmallInput,
        )
    });

    let mut mixed = unplanned_mixed(1024);
    mixed.finish();
    group.bench_function("traverse_1024_mixed", |b| {
        b.iter(|| {
            for command in black_box(&mixed).render_commands() {
                black_box(command);
            }
        })
    });
    group.finish();
}

fn bench_scene_archive(c: &mut Criterion) {
    let mut group = c.benchmark_group("scene_archive");
    configure(&mut group);
    group.throughput(Throughput::Elements(1024));

    group.bench_function("from_scene_1024_mixed", |b| {
        b.iter_batched(
            || unplanned_mixed(1024),
            |mut scene| {
                scene.finish();
                black_box(SceneArchive::from_scene(&scene));
            },
            BatchSize::SmallInput,
        )
    });

    let mut mixed = unplanned_mixed(1024);
    mixed.finish();
    let archive = SceneArchive::from_scene(&mixed);
    group.bench_function("to_canonical_json_1024_mixed", |b| {
        b.iter(|| black_box(archive.to_canonical_json()))
    });
    group.finish();
}

fn bench_background_prepare(c: &mut Criterion) {
    let mut group = c.benchmark_group("background_prepare");
    configure(&mut group);
    group.throughput(Throughput::Elements(1024));

    // baseline: scene_build/quads_1024 (solid)
    group.bench_function("linear_gradient_1024_quads", |b| {
        b.iter_batched(
            || Scene::default(),
            |mut scene| {
                insert_quads(&mut scene, 1024, gradient());
                scene.finish();
                black_box(scene);
            },
            BatchSize::SmallInput,
        )
    });
    group.finish();
}

criterion_group!(
    benches,
    bench_scene_build,
    bench_scene_plan,
    bench_scene_archive,
    bench_background_prepare
);
criterion_main!(benches);
