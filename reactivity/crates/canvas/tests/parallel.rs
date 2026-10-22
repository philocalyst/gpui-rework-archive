#![cfg(feature = "parallel")]
use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, OutputProfile, PixelFormat, Point, Rect, RenderPool,
    SdrMapping, TextSystem,
};

fn scene(canvas: &mut Canvas, text: &mut TextSystem) {
    let clip = Rect::new(
        0.3,
        0.7,
        (canvas.width() as f32 - 1.1).max(0.2),
        (canvas.height() as f32 - 1.4).max(0.2),
    );
    canvas.clear(Color::rgba(40, 80, 110, 133));
    let mut seed = 0x12abcdefu32;
    for i in 0..65 {
        let mut random = || {
            seed ^= seed << 13;
            seed ^= seed >> 17;
            seed ^= seed << 5;
            seed
        };
        let x = (random() % 140) as f32 - 25.3;
        let y = (random() % 90) as f32 - 15.7;
        let r = (random() % 230) as u8;
        canvas
            .fill_rect(
                Rect::new(-1.2, -0.7, 34.6, 18.8),
                Affine {
                    a: if i % 2 == 0 { -1.0 } else { 1.1 },
                    b: 0.21,
                    c: -0.36,
                    d: 0.83,
                    tx: x,
                    ty: y,
                },
                clip,
                Color::rgba(r, 170, 240 - r, if i % 3 == 0 { 255 } else { 107 }),
            )
            .unwrap();
    }
    let layout = text.shape("office café", 15.3, None).unwrap();
    canvas
        .draw_text(
            text,
            &layout,
            Point { x: 3.2, y: 9.7 },
            Affine {
                a: 0.9,
                b: 0.13,
                c: 0.21,
                d: 1.05,
                tx: 0.4,
                ty: 0.3,
            },
            clip,
            Color::rgba(250, 70, 30, 210),
        )
        .unwrap();
}
#[test]
fn serial_and_scoped_disjoint_bands_are_byte_identical() {
    let mut text = TextSystem::bundled().unwrap();
    for profile in [OutputProfile::Srgb, OutputProfile::DisplayP3] {
        for (format, mapping) in [
            (PixelFormat::Rgba8Premultiplied, SdrMapping::Clip),
            (
                PixelFormat::Rgba8Premultiplied,
                SdrMapping::ReinhardPerChannel { exposure: 1.3 },
            ),
            (PixelFormat::Rgba16Float, SdrMapping::Clip),
        ] {
            let config = ColorConfig {
                profile,
                format,
                mapping,
                ..Default::default()
            };
            for (width, height) in [(1, 1), (1, 37), (113, 79), (64, 32)] {
                for proofs in [false, true] {
                    let mut serial = Canvas::recording(width, height, config).unwrap();
                    serial.set_tile_proofs(proofs);
                    scene(&mut serial, &mut text);
                    let expected = serial.pixels().to_vec();
                    let counts = serial.stats();
                    for workers in [1, 2, 4, 8] {
                        let pool = RenderPool::new(workers).unwrap().with_min_work(0);
                        let mut parallel = Canvas::recording(width, height, config).unwrap();
                        parallel.set_tile_proofs(proofs);
                        scene(&mut parallel, &mut text);
                        assert_eq!(parallel.output_bytes(), 0);
                        assert_eq!(
                            parallel.try_pixels_with(&pool).unwrap(),
                            expected,
                            "{profile:?} {format:?} {mapping:?} {width}x{height}, workers={workers},proofs={proofs}"
                        );
                        let stats = parallel.stats();
                        assert_eq!(
                            (
                                stats.sample_tests,
                                stats.boundary_pixels,
                                stats.full_rect_tiles,
                                stats.skipped_command_tiles
                            ),
                            (
                                counts.sample_tests,
                                counts.boundary_pixels,
                                counts.full_rect_tiles,
                                counts.skipped_command_tiles
                            )
                        );
                        assert_eq!(stats.output_bands, (height as usize).div_ceil(16));
                        assert_eq!(stats.parallel, height > 16);
                        let pointer = parallel.pixels_with(&pool).as_ptr();
                        assert_eq!(parallel.pixels_with(&pool).as_ptr(), pointer);
                        assert_eq!(parallel.stats().render_count, 1);
                    }
                }
            }
        }
    }
}
#[test]
fn threshold_and_invalid_worker_counts_are_explicit() {
    assert!(RenderPool::new(0).is_err());
    assert!(RenderPool::new(65).is_err());
    let pool = RenderPool::new(2).unwrap().with_min_work(usize::MAX);
    assert_eq!(pool.workers(), 2);
    let mut canvas = Canvas::new(53, 31).unwrap();
    canvas.clear(Color::WHITE);
    assert_eq!(canvas.pixels_with(&pool).len(), 53 * 31 * 4);
    assert!(!canvas.stats().parallel);
}

#[test]
#[ignore = "process RSS/thread measurement; run separately with GPUI_RENDER_WORKERS=1,2,4,8"]
fn pool_memory_measurement() {
    fn status() -> String {
        std::fs::read_to_string("/proc/self/status")
            .unwrap()
            .lines()
            .filter(|line| {
                ["VmRSS:", "VmSize:", "Threads:"]
                    .iter()
                    .any(|key| line.starts_with(key))
            })
            .collect::<Vec<_>>()
            .join("; ")
    }
    let workers: usize = std::env::var("GPUI_RENDER_WORKERS")
        .unwrap_or_else(|_| "4".into())
        .parse()
        .unwrap();
    println!("before_pool={}", status());
    let start = std::time::Instant::now();
    let pool = RenderPool::new(workers).unwrap().with_min_work(0);
    println!(
        "workers={workers},init_us={},after_pool={}",
        start.elapsed().as_micros(),
        status()
    );
    let mut canvas = Canvas::new(640, 480).unwrap();
    canvas.clear(Color::rgba(100, 120, 140, 210));
    let clip = Rect::new(0., 0., 640., 480.);
    canvas
        .fill_rect(
            Rect::new(0., 0., 640., 480.),
            Affine::rotation(0.01),
            clip,
            Color::rgba(80, 60, 30, 130),
        )
        .unwrap();
    std::hint::black_box(canvas.pixels_with(&pool));
    println!(
        "after_frame={},output_bytes={},scratch_upper_bound={},requested_stack_bytes={}",
        status(),
        canvas.output_bytes(),
        workers * 65536,
        workers * 512 * 1024
    );
    drop(pool);
    println!("immediate_after_drop={}", status());
}

#[test]
fn tallest_admitted_canvas_keeps_sample_storage_on_leaf_worker_stacks() {
    let pool = RenderPool::new(2).unwrap().with_min_work(0);
    let mut serial = Canvas::recording(1, 16384, ColorConfig::default()).unwrap();
    let mut parallel = Canvas::recording(1, 16384, ColorConfig::default()).unwrap();
    for canvas in [&mut serial, &mut parallel] {
        canvas.clear(Color::WHITE);
        canvas
            .fill_rect(
                Rect::new(0.0, 0.0, 1.0, 16384.0),
                Affine::IDENTITY,
                Rect::new(0.0, 0.0, 1.0, 16384.0),
                Color::rgba(30, 80, 120, 128),
            )
            .unwrap();
    }
    assert_eq!(parallel.pixels_with(&pool), serial.pixels());
    assert_eq!(parallel.stats().output_bands, 1024);
    assert_eq!(
        parallel.stats().tile_references,
        serial.stats().tile_references
    );
    assert_eq!(parallel.stats().sample_tests, serial.stats().sample_tests);
}
