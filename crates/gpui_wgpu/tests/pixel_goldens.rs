//! Infrequent GPU-backed pixel goldens for the wgpu renderer.
//!
//! Never part of PR gates: the single test early-returns SKIP unless `GPUI_GOLDEN=1`, and
//! SKIPs again when no GPU adapter is available. `GPUI_GOLDEN_UPDATE=1` regenerates the
//! PNGs under `tests/goldens/default/`. Run on a nightly/manual GPU runner:
//!
//! ```text
//! GPUI_GOLDEN=1 cargo test -p gpui_ce_wgpu --features test-support --test pixel_goldens
//! GPUI_GOLDEN_UPDATE=1 GPUI_GOLDEN=1 cargo test -p gpui_ce_wgpu --features test-support --test pixel_goldens
//! ```
#![cfg(feature = "test-support")]

use std::path::Path;

use gpui::{
    Bounds, ContentMask, DevicePixels, PlatformHeadlessRenderer, Point, Quad, ScaledPixels, Scene,
    ShaderBool, Size, Underline, solid_background, white,
};
use gpui_ce_wgpu::WgpuHeadlessRenderer;
use image::RgbaImage;

const WIDTH: u32 = 256;
const HEIGHT: u32 = 180;
const TARGET_SIZE: Size<DevicePixels> = Size {
    width: DevicePixels(WIDTH as i32),
    height: DevicePixels(HEIGHT as i32),
};
const GOLDEN_DIR: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/tests/goldens/default");

/// Per-channel mean abs-diff must stay <= 1.0. 1-LSB drift between drivers is normal
/// (Slint's lesson); this tolerates it while still catching real misrenders.
const MEAN_TOLERANCE: u64 = 1;
/// Per-channel max abs-diff must stay <= 8.
const MAX_TOLERANCE: u16 = 8;

const CASES: [(&str, fn() -> Scene); 3] = [
    ("single_quad", single_quad_scene),
    ("grid_4x4", grid_scene),
    ("mixed_quad_underline", mixed_scene),
];

#[test]
fn pixel_goldens() -> anyhow::Result<()> {
    if std::env::var("GPUI_GOLDEN").as_deref() != Ok("1") {
        eprintln!(
            "SKIP pixel goldens: set GPUI_GOLDEN=1 to compare, GPUI_GOLDEN_UPDATE=1 to (re)generate"
        );
        return Ok(());
    }
    let mut renderer = match WgpuHeadlessRenderer::new() {
        Ok(renderer) => renderer,
        Err(error) => {
            eprintln!("SKIP pixel goldens: no usable GPU adapter ({error})");
            return Ok(());
        }
    };
    let update = std::env::var("GPUI_GOLDEN_UPDATE").as_deref() == Ok("1");
    let mut failures = Vec::new();
    for (name, build) in CASES {
        let image = renderer.render_scene_to_image(&build(), TARGET_SIZE)?;
        if update {
            write_golden(name, &image)?;
        } else if let Err(message) = compare_to_golden(name, &image) {
            failures.push(message);
        }
    }
    assert!(
        failures.is_empty(),
        "pixel goldens failed:\n{}",
        failures.join("\n")
    );
    Ok(())
}

fn full_bounds() -> Bounds<ScaledPixels> {
    Bounds {
        origin: Point {
            x: ScaledPixels(0.0),
            y: ScaledPixels(0.0),
        },
        size: Size {
            width: ScaledPixels(WIDTH as f32),
            height: ScaledPixels(HEIGHT as f32),
        },
    }
}

fn single_quad_scene() -> Scene {
    let mut scene = Scene::default();
    let bounds = full_bounds();
    scene.insert_primitive(Quad {
        order: 0,
        bounds,
        content_mask: ContentMask { bounds },
        background: solid_background(gpui::rgb(0x336699)),
        ..Default::default()
    });
    scene.finish();
    scene
}

fn grid_scene() -> Scene {
    const PALETTE: [u32; 5] = [0x336699, 0x99cc33, 0xcc3366, 0xeeeeee, 0x553311];
    let cell_width = WIDTH / 4;
    let cell_height = HEIGHT / 4;
    let mut scene = Scene::default();
    for row in 0..4 {
        for column in 0..4 {
            let bounds = Bounds {
                origin: Point {
                    x: ScaledPixels((column * cell_width) as f32),
                    y: ScaledPixels((row * cell_height) as f32),
                },
                size: Size {
                    width: ScaledPixels(cell_width as f32),
                    height: ScaledPixels(cell_height as f32),
                },
            };
            scene.insert_primitive(Quad {
                order: 0,
                bounds,
                content_mask: ContentMask { bounds },
                background: solid_background(gpui::rgb(
                    PALETTE[((row * 4 + column) as usize) % PALETTE.len()],
                )),
                ..Default::default()
            });
        }
    }
    scene.finish();
    scene
}

fn mixed_scene() -> Scene {
    let mut scene = Scene::default();
    let bounds = full_bounds();
    scene.insert_primitive(Quad {
        order: 0,
        bounds,
        content_mask: ContentMask { bounds },
        background: solid_background(gpui::rgb(0x202020)),
        ..Default::default()
    });
    let underline_bounds = Bounds {
        origin: Point {
            x: ScaledPixels(16.0),
            y: ScaledPixels(96.0),
        },
        size: Size {
            width: ScaledPixels(224.0),
            height: ScaledPixels(24.0),
        },
    };
    scene.insert_primitive(Underline {
        order: 0,
        padding: 0,
        bounds: underline_bounds,
        content_mask: ContentMask {
            bounds: underline_bounds,
        },
        color: white().into(),
        thickness: ScaledPixels(4.0),
        wavy: ShaderBool::Disabled,
    });
    scene.finish();
    scene
}

fn write_golden(name: &str, image: &RgbaImage) -> anyhow::Result<()> {
    std::fs::create_dir_all(GOLDEN_DIR)?;
    image.save(Path::new(GOLDEN_DIR).join(format!("{name}.png")))?;
    eprintln!("wrote golden: {GOLDEN_DIR}/{name}.png");
    Ok(())
}

fn compare_to_golden(name: &str, actual: &RgbaImage) -> Result<(), String> {
    let golden_path = Path::new(GOLDEN_DIR).join(format!("{name}.png"));
    let golden = image::open(&golden_path)
        .map_err(|error| {
            format!(
                "no golden at {} ({error}); run with GPUI_GOLDEN_UPDATE=1 to generate it",
                golden_path.display()
            )
        })?
        .to_rgba8();
    let (sums, maxes) = diff_stats(actual, &golden)?;
    let count = u64::from(actual.width()) * u64::from(actual.height());
    if sums.iter().all(|&sum| sum <= count * MEAN_TOLERANCE)
        && maxes.iter().all(|&max| max <= MAX_TOLERANCE)
    {
        eprintln!("ok: {name}");
        Ok(())
    } else {
        let actual_path = Path::new("/tmp").join(format!("gpui-golden-{name}-actual.png"));
        let _ = actual.save(&actual_path);
        Err(format!(
            "{name} exceeds tolerance (mean {sums:?}/{count} > {MEAN_TOLERANCE}, \
             max {maxes:?} > {MAX_TOLERANCE}); actual written to {}; \
             run with GPUI_GOLDEN_UPDATE=1 to regenerate",
            actual_path.display()
        ))
    }
}

fn diff_stats(actual: &RgbaImage, golden: &RgbaImage) -> Result<([u64; 4], [u16; 4]), String> {
    if actual.dimensions() != golden.dimensions() {
        return Err(format!(
            "size mismatch: actual {:?}, golden {:?}",
            actual.dimensions(),
            golden.dimensions()
        ));
    }
    let mut sums = [0u64; 4];
    let mut maxes = [0u16; 4];
    for (a, g) in actual.pixels().zip(golden.pixels()) {
        for channel in 0..4 {
            let diff = u16::from(a[channel].abs_diff(g[channel]));
            sums[channel] += u64::from(diff);
            maxes[channel] = maxes[channel].max(diff);
        }
    }
    Ok((sums, maxes))
}
