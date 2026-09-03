//! GPU-gated end-to-end renderer benchmarks.
//!
//! These benches drive a real wgpu adapter through [`WgpuHeadlessRenderer`] and
//! are intentionally *not* hermetic. T0 / CI never runs them: the bench function
//! self-skips unless `GPUI_BENCH_GPU=1`, so `cargo bench --workspace` (Seg1
//! `bench-smoke`) and T0 stay green with no GPU present.
//!
//! T2 (nightly / manual) run:
//! ```text
//! GPUI_BENCH_GPU=1 cargo bench -p gpui_ce_wgpu --bench renderer --features test-support
//! ```
//! Quick smoke override: append `-- --measurement-time 1` (or `--sample-size 10`).
//!
//! Adapter selection is fixed by `WgpuContext::new_headless`
//! (`wgpu_context.rs:76`): `native_backends()` + `PowerPreference::LowPower`.
//! `native_backends()` is Metal on macOS, DX12|Vulkan|GL on Windows, and
//! Vulkan|GL elsewhere (`wgpu_context.rs:608`).
//!
//! Software-renderer recipes (verified against wgpu 29.0.4 backend names):
//!
//! | Platform | Backends      | Deterministic software adapter                  |
//! |----------|---------------|-------------------------------------------------|
//! | Windows  | DX12 Vulkan GL | DX12 WARP (Basic Render Driver), wgpu default  |
//! | Linux    | Vulkan GL     | Vulkan: Lavapipe; GL: llvmpipe (both Mesa)     |
//! | macOS    | Metal         | none — needs a real Metal device                |
//!
//! wgpu 29 backend names are `vulkan`/`vk`, `dx12`/`d3d12`, `metal`/`mtl`,
//! `gl`/`gles`/`opengl`, `webgpu`, `noop`; there is **no `dx11` backend**.
//! `WGPU_BACKEND`, `WGPU_ADAPTER_NAME`, `WGPU_POWER_PREF` and
//! `WGPU_DX12_COMPILER` are only honored when a crate opts in via
//! `Backends::from_env()` / `initialize_adapter_n_or_default()`; this headless
//! path does not, so they are inert here unless `native_backends()` gains
//! `.with_env()`. `ZED_DEVICE_ID` is parsed only on the surface
//! (`new_with_options`) path, also inert for this bench.

use std::time::Duration;

use criterion::{
    black_box, criterion_group, criterion_main, BenchmarkGroup, Criterion, Throughput,
};
use gpui::{
    solid_background, white, Bounds, ContentMask, DevicePixels, PlatformHeadlessRenderer, Point,
    Quad, ScaledPixels, Scene, ShaderBool, Size, Underline,
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
            content_mask: ContentMask { bounds },
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
            content_mask: ContentMask { bounds },
            background: solid_background(gpui::rgb(0x336699)),
            ..Default::default()
        });
        scene.insert_primitive(Underline {
            order: (index * 2 + 1) as u32,
            padding: 0,
            bounds,
            content_mask: ContentMask { bounds },
            color: white().into(),
            thickness: ScaledPixels(1.0),
            wavy: ShaderBool::Disabled,
        });
    }
    scene
}

fn configure(group: &mut BenchmarkGroup<'_, criterion::measurement::WallTime>) {
    group.measurement_time(Duration::from_secs(3));
    group.sample_size(30);
    group.warm_up_time(Duration::from_secs(1));
}

fn bench_renderer(c: &mut Criterion) {
    if std::env::var("GPUI_BENCH_GPU").as_deref() != Ok("1") {
        eprintln!(
            "SKIP renderer benches: set GPUI_BENCH_GPU=1 to run (needs a GPU or \
             software adapter):\n    GPUI_BENCH_GPU=1 cargo bench -p gpui_ce_wgpu \
             --bench renderer --features test-support"
        );
        return;
    }

    let mut renderer = WgpuHeadlessRenderer::new().expect("headless WGPU renderer must initialize");
    let single_quad = quad_scene(1);
    let dense_quads = quad_scene(512);
    let mut mixed_batches = unplanned_mixed_scene(512);
    mixed_batches.finish();

    let mut group = c.benchmark_group("renderer_end_to_end");
    configure(&mut group);
    group.throughput(Throughput::Elements(1));
    group.bench_function("single_quad", |b| {
        b.iter(|| {
            let image = renderer
                .render_scene_to_image(&single_quad, TARGET_SIZE)
                .expect("single quad render must succeed");
            black_box((image.width(), image.height()));
        })
    });
    group.throughput(Throughput::Elements(512));
    group.bench_function("512_quads", |b| {
        b.iter(|| {
            let image = renderer
                .render_scene_to_image(&dense_quads, TARGET_SIZE)
                .expect("dense quad render must succeed");
            black_box((image.width(), image.height()));
        })
    });
    group.throughput(Throughput::Elements(1));
    group.bench_function("single_quad_wait", |b| {
        b.iter(|| {
            renderer
                .render_scene_and_wait(&single_quad, TARGET_SIZE)
                .expect("single quad render must succeed");
        })
    });
    group.throughput(Throughput::Elements(512));
    group.bench_function("512_quads_wait", |b| {
        b.iter(|| {
            renderer
                .render_scene_and_wait(&dense_quads, TARGET_SIZE)
                .expect("dense quad render must succeed");
        })
    });
    group.throughput(Throughput::Elements(1024));
    group.bench_function("1024_mixed_batches_wait", |b| {
        b.iter(|| {
            renderer
                .render_scene_and_wait(&mixed_batches, TARGET_SIZE)
                .expect("mixed batch render must succeed");
        })
    });
    group.finish();
}

criterion_group!(benches, bench_renderer);
criterion_main!(benches);
