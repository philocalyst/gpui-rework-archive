#![cfg(all(feature = "test-support", not(target_family = "wasm")))]

use anyhow::{Result, bail};
use gpui::{
    AtlasTextureId, AtlasTextureKind, AtlasTile, Bounds, CapturedBitmap, ContentMask, DevicePixels,
    FilterBoundary, MonochromeSprite, PathBuilder, PlatformHeadlessRenderer, PolychromeSprite,
    Quad, ScaledFilter, ScaledPixels, Scene, SceneCapture, ShaderBool, Shadow, Size, TileId, point,
    px, size, solid_background,
};
use gpui_ce_wgpu::{WgpuContext, WgpuHeadlessRenderer};
use gpui_render::cpu::CpuRenderer;

const SIZE: Size<DevicePixels> = size(DevicePixels(16), DevicePixels(14));
const RESIZED: Size<DevicePixels> = size(DevicePixels(19), DevicePixels(9));
const ATLAS_BYTES: u64 = 1024 * 1024 * (1 + 4);
type Probe = (&'static str, u32, u32, [u8; 4]);

fn bounds(x: f32, y: f32, w: f32, h: f32) -> Bounds<ScaledPixels> {
    Bounds::new(
        point(ScaledPixels(x), ScaledPixels(y)),
        size(ScaledPixels(w), ScaledPixels(h)),
    )
}

fn mask(bounds: Bounds<ScaledPixels>) -> ContentMask<ScaledPixels> {
    ContentMask {
        bounds,
        ..Default::default()
    }
}

fn tile(kind: AtlasTextureKind, index: u32, id: u32) -> AtlasTile {
    AtlasTile {
        texture_id: AtlasTextureId { index, kind },
        tile_id: TileId(id),
        padding: 0,
        bounds: Bounds::new(
            point(DevicePixels(0), DevicePixels(0)),
            size(DevicePixels(2), DevicePixels(2)),
        ),
    }
}

fn probe_scene() -> Scene {
    let full = bounds(0.0, 0.0, 16.0, 14.0);
    let mut scene = Scene::default();
    scene.insert_primitive(Quad {
        bounds: bounds(0.0, 0.0, 9.0, 8.0),
        content_mask: mask(bounds(1.0, 1.0, 10.0, 10.0)),
        background: solid_background(gpui::hsla(0.0, 1.0, 0.5, 0.5)),
        ..Default::default()
    });
    scene.insert_primitive(Quad {
        bounds: bounds(4.0, 1.0, 5.0, 7.0),
        content_mask: mask(bounds(5.0, 1.0, 3.0, 7.0)),
        background: solid_background(gpui::hsla(2.0 / 3.0, 1.0, 0.5, 0.5)),
        ..Default::default()
    });
    scene.insert_primitive(MonochromeSprite {
        order: 0,
        padding: 0,
        bounds: bounds(1.0, 10.0, 2.0, 2.0),
        content_mask: mask(full),
        color: gpui::hsla(1.0 / 3.0, 1.0, 0.5, 1.0).into(),
        tile: tile(AtlasTextureKind::Monochrome, 37, 10),
        transformation: Default::default(),
    });
    scene.insert_primitive(PolychromeSprite {
        order: 0,
        grayscale: ShaderBool::Disabled,
        opacity: 1.0,
        corner_smoothing: 0.0,
        bounds: bounds(5.0, 10.0, 2.0, 2.0),
        content_mask: mask(full),
        corner_radii: Default::default(),
        tile: tile(AtlasTextureKind::Polychrome, 91, 20),
    });
    scene.finish();
    scene
}

fn over_capacity_scene() -> Scene {
    let full = bounds(0.0, 0.0, 16.0, 14.0);
    let mut scene = Scene::default();
    for index in 0..2048 {
        let x = (index % 64) as f32 * 0.25;
        let y = (index / 64) as f32 * 0.25;
        let primitive_bounds = bounds(x, y, 0.2, 0.2);
        scene.raise_order_floor();
        if index % 2 == 0 {
            scene.insert_primitive(Quad {
                bounds: primitive_bounds,
                content_mask: mask(full),
                background: solid_background(gpui::hsla(0.0, 0.0, 1.0, 1.0)),
                ..Default::default()
            });
        } else {
            scene.insert_primitive(Shadow {
                order: Default::default(),
                blur_radius: ScaledPixels(0.0),
                bounds: primitive_bounds,
                corner_radii: Default::default(),
                content_mask: mask(full),
                color: solid_background(gpui::hsla(0.0, 0.0, 0.0, 0.5)),
                element_bounds: primitive_bounds,
                element_corner_radii: Default::default(),
                inset: ShaderBool::Disabled,
                corner_smoothing: 0.0,
            });
        }
    }
    scene.finish();
    scene
}

fn capture(scene: &Scene, mono: u8, poly_bgra: [u8; 4]) -> Result<SceneCapture> {
    SceneCapture::capture(scene, |tile| {
        let bytes = match tile.texture_id.kind {
            AtlasTextureKind::Monochrome => vec![mono; 4],
            AtlasTextureKind::Polychrome => poly_bgra.repeat(4),
            AtlasTextureKind::Subpixel => anyhow::bail!("unexpected subpixel tile"),
        };
        Ok(CapturedBitmap {
            kind: tile.texture_id.kind,
            width: 2,
            height: 2,
            bytes,
        })
    })
}

fn cpu_image(capture: &SceneCapture) -> Result<image::RgbaImage> {
    let mut cpu = CpuRenderer::from_captured_bitmaps(capture.bitmaps())?;
    Ok(cpu.render_scene_to_image(&capture.to_scene()?, SIZE)?)
}

fn near_pixel(
    name: &str,
    image: &image::RgbaImage,
    x: u32,
    y: u32,
    expected: [u8; 4],
    tolerance: u8,
) {
    let actual = image.get_pixel(x, y).0;
    for channel in 0..4 {
        assert!(
            actual[channel].abs_diff(expected[channel]) <= tolerance,
            "{name} ({x},{y}) channel {channel}: {actual:?}, expected {expected:?} ±{tolerance}"
        );
    }
}

fn assert_probes(cpu: &image::RgbaImage, gpu: &image::RgbaImage, probes: &[Probe]) {
    for &(name, x, y, expected) in probes {
        near_pixel(&format!("{name} CPU"), cpu, x, y, expected, 1);
        near_pixel(&format!("{name} GPU"), gpu, x, y, expected, 2);
        near_pixel(
            &format!("{name} CPU/GPU parity"),
            gpu,
            x,
            y,
            cpu.get_pixel(x, y).0,
            2,
        );
    }
}

fn assert_memory(renderer: &WgpuHeadlessRenderer, size: Size<DevicePixels>) {
    let usage = renderer.owned_memory_usage();
    let pixels = u64::from(size.width.0 as u32) * u64::from(size.height.0 as u32);
    let target = pixels * 4;
    let readback = u64::from((size.width.0 as u32 * 4).next_multiple_of(256))
        * u64::from(size.height.0 as u32);
    assert_eq!(usage.atlas_backing_textures_bytes, ATLAS_BYTES);
    assert_eq!(usage.headless_target_texture_bytes, target);
    assert_eq!(usage.readback_buffer_bytes, readback);
    assert_eq!(usage.measured_owned_bytes, ATLAS_BYTES + target + readback);
    assert_eq!(
        usage.process_device_memory_bytes.is_some(),
        usage.process_device_memory_source.is_some()
    );
    assert_eq!(
        usage.process_device_memory_bytes.is_some(),
        usage.process_device_memory_unavailable_reason.is_none()
    );
}

fn assert_timestamp_capability(renderer: &WgpuHeadlessRenderer) -> Result<()> {
    let context = WgpuContext::new_headless(None)?;
    let replay = renderer
        .replay_info()
        .expect("measurement adapter metadata");
    if replay.adapter_name == context.adapter.get_info().name
        && replay.backend == format!("{:?}", context.backend())
    {
        let timestamp_features = gpui_ce_wgpu::wgpu::Features::TIMESTAMP_QUERY;
        assert_eq!(
            replay.gpu_timestamps_available,
            context.adapter.features().contains(timestamp_features),
            "measurement renderer should enable timestamp queries when its selected adapter supports them"
        );
    }
    Ok(())
}

fn path_scene() -> Scene {
    let mut builder = PathBuilder::fill();
    builder.move_to(point(px(2.0), px(2.0)));
    builder.line_to(point(px(13.0), px(3.0)));
    builder.line_to(point(px(7.0), px(12.0)));
    builder.close();
    let mut path = builder.build().expect("valid path").scale(1.0);
    path.content_mask = mask(bounds(0.0, 0.0, 16.0, 14.0));
    path.color = solid_background(gpui::white());
    let mut scene = Scene::default();
    scene.insert_primitive(path.clone());
    scene.insert_primitive(Quad {
        bounds: bounds(1.0, 1.0, 14.0, 12.0),
        content_mask: mask(bounds(1.0, 1.0, 14.0, 12.0)),
        background: solid_background(gpui::hsla(2.0 / 3.0, 1.0, 0.5, 0.2)),
        ..Default::default()
    });
    scene.insert_primitive(path);
    scene.finish();
    scene
}

fn isolated_filter_scene() -> Scene {
    let first = bounds(1.0, 1.0, 7.0, 8.0);
    let second = bounds(8.0, 3.0, 7.0, 8.0);
    let boundary = |bounds, is_start| FilterBoundary {
        order: 0,
        bounds,
        content_mask: mask(bounds),
        corner_radii: Default::default(),
        corner_smoothing: 0.0,
        filters: smallvec::smallvec![ScaledFilter::Blur(ScaledPixels(2.0))],
        opacity: 0.9,
        is_start,
    };
    let mut scene = Scene::default();
    scene.insert_primitive(boundary(first, true));
    scene.insert_primitive(Quad {
        bounds: first,
        content_mask: mask(first),
        background: solid_background(gpui::hsla(0.0, 1.0, 0.5, 0.8)),
        ..Default::default()
    });
    scene.insert_primitive(boundary(first, false));
    scene.insert_primitive(boundary(second, true));
    scene.insert_primitive(Quad {
        bounds: second,
        content_mask: mask(second),
        background: solid_background(gpui::hsla(1.0 / 3.0, 1.0, 0.5, 0.8)),
        ..Default::default()
    });
    scene.insert_primitive(boundary(second, false));
    scene.finish();
    scene
}

fn rotated_sprite_capture(content_mask: Bounds<ScaledPixels>) -> Result<SceneCapture> {
    let sprite_bounds = bounds(0.0, 0.0, 3.0, 2.0);
    let mut scene = Scene::default();
    scene.insert_primitive(MonochromeSprite {
        order: 0,
        padding: 0,
        bounds: sprite_bounds,
        content_mask: mask(content_mask),
        color: gpui::hsla(0.0, 1.0, 0.5, 1.0).into(),
        tile: AtlasTile {
            bounds: Bounds::new(
                point(DevicePixels(0), DevicePixels(0)),
                size(DevicePixels(3), DevicePixels(2)),
            ),
            ..tile(AtlasTextureKind::Monochrome, 37, 10)
        },
        transformation: gpui::TransformationMatrix {
            rotation_scale: [[0.0, -1.0], [1.0, 0.0]],
            translation: [5.0, 1.0],
        },
    });
    assert_eq!(
        scene.monochrome_sprites.len(),
        1,
        "rotated sprite fixture must survive transformed screen-space culling"
    );
    scene.finish();
    Ok(SceneCapture::capture(&scene, |_| {
        Ok(CapturedBitmap {
            kind: AtlasTextureKind::Monochrome,
            width: 3,
            height: 2,
            bytes: vec![255, 0, 255, 0, 255, 0],
        })
    })?)
}

#[test]
fn render_pass_timestamps_are_ordered_and_within_wall_time() -> Result<()> {
    if std::env::var("GPUI_REQUIRE_GPU").as_deref() != Ok("1") {
        eprintln!("skipping native timestamp check; set GPUI_REQUIRE_GPU=1 to require a GPU");
        return Ok(());
    }

    let mut empty_scene = Scene::default();
    empty_scene.finish();
    let captures = [
        empty_scene,
        probe_scene(),
        path_scene(),
        isolated_filter_scene(),
    ]
    .iter()
    .map(|scene| capture(scene, 255, [0, 0, 255, 255]))
    .collect::<Result<Vec<_>>>()?;
    let mut renderer = WgpuHeadlessRenderer::new_with_measurements()?;
    let Some(replay) = renderer.replay_info() else {
        bail!("measurement renderer did not expose adapter metadata");
    };
    if !replay.gpu_timestamps_available {
        eprintln!(
            "skipping timestamp assertions: {}",
            replay
                .gpu_timestamps_unavailable_reason
                .as_deref()
                .unwrap_or("adapter did not advertise timestamp queries")
        );
        return Ok(());
    }

    let mut timestamps_disabled_reason = None;
    for sample in 0..20 {
        let scene = renderer.load_capture(&captures[sample % captures.len()])?;
        let measurement = renderer
            .render_scene_measured(&scene, SIZE)
            .map_err(|error| anyhow::anyhow!("timestamp sample {sample}: {error:#}"))?;
        if sample % captures.len() == 0 {
            assert_eq!(
                measurement.gpu_execution, None,
                "clear-only frame must not reuse stale GPU timestamp samples"
            );
            continue;
        }
        if let Some(reason) = &timestamps_disabled_reason {
            assert_eq!(measurement.gpu_execution, None, "{reason}");
            assert_eq!(measurement.gpu_timestamp_resolution, None, "{reason}");
        } else if let Some(gpu) = measurement.gpu_execution {
            let resolution = measurement
                .gpu_timestamp_resolution
                .expect("GPU timing reports its counter resolution");
            assert!(
                gpu <= measurement.encode_submit_completion + resolution,
                "sample {sample} GPU interval {gpu:?} exceeds wall interval {:?} by more than counter resolution {resolution:?}",
                measurement.encode_submit_completion
            );
        } else {
            let replay = renderer
                .replay_info()
                .expect("measurement renderer retains adapter metadata");
            assert!(!replay.gpu_timestamps_available);
            timestamps_disabled_reason = Some(
                replay
                    .gpu_timestamps_unavailable_reason
                    .clone()
                    .expect("disabled timestamps report a reason"),
            );
        }
    }
    Ok(())
}

#[test]
fn timestamp_query_capacity_overflow_disables_only_optional_telemetry() -> Result<()> {
    if std::env::var("GPUI_REQUIRE_GPU").as_deref() != Ok("1") {
        eprintln!("skipping native capacity check; set GPUI_REQUIRE_GPU=1 to require a GPU");
        return Ok(());
    }

    let scene = over_capacity_scene();
    assert!(
        scene.render_commands().len() >= 2048,
        "alternating primitive batches produced only {} commands",
        scene.render_commands().len()
    );
    let mut renderer = WgpuHeadlessRenderer::new_with_measurements()?;
    assert_timestamp_capability(&renderer)?;

    let measurement = renderer.render_scene_measured(&scene, SIZE)?;
    assert!(measurement.encode_submit_completion > std::time::Duration::ZERO);
    assert_eq!(measurement.gpu_execution, None);
    assert_eq!(measurement.gpu_timestamp_resolution, None);
    let replay = renderer
        .replay_info()
        .expect("adapter metadata is retained");
    assert!(!replay.gpu_timestamps_available);
    let reason = replay
        .gpu_timestamps_unavailable_reason
        .as_deref()
        .expect("capacity fallback reports a reason");
    assert!(
        reason.contains("scene exceeds available query capacity"),
        "{reason}"
    );
    assert!(reason.contains("4096"), "{reason}");

    let image = renderer.render_scene_to_image(&scene, SIZE)?;
    assert!(image.pixels().any(|pixel| pixel[3] > 0));
    Ok(())
}

#[test]
fn rotated_monochrome_sprite_uses_row_major_transform_with_screen_mask() -> Result<()> {
    if std::env::var("GPUI_REQUIRE_GPU").as_deref() != Ok("1") {
        eprintln!("skipping native capture parity; set GPUI_REQUIRE_GPU=1 to require a GPU");
        return Ok(());
    }

    let screen_mask = bounds(3.0, 1.0, 1.0, 3.0);
    let capture = rotated_sprite_capture(screen_mask)?;
    let expected = cpu_image(&capture)?;
    let mut renderer = WgpuHeadlessRenderer::new()?;
    let native_scene = renderer.load_capture(&capture)?;
    let actual = renderer.render_scene_to_image(&native_scene, SIZE)?;
    assert_probes(
        &expected,
        &actual,
        &[
            ("rotated mask excludes top", 3, 1, [0, 0, 0, 0]),
            ("rotated mask keeps middle", 3, 2, [255, 0, 0, 255]),
            ("rotated mask excludes bottom", 3, 3, [0, 0, 0, 0]),
            ("screen-space mask clips right", 4, 1, [0, 0, 0, 0]),
        ],
    );

    let unmasked_capture = rotated_sprite_capture(bounds(0.0, 0.0, 16.0, 14.0))?;
    let unmasked_expected = cpu_image(&unmasked_capture)?;
    let unmasked_scene = renderer.load_capture(&unmasked_capture)?;
    let unmasked_actual = renderer.render_scene_to_image(&unmasked_scene, SIZE)?;
    near_pixel(
        "unmasked rotated source pixel CPU",
        &unmasked_expected,
        4,
        1,
        [255, 0, 0, 255],
        1,
    );
    near_pixel(
        "unmasked rotated source pixel GPU",
        &unmasked_actual,
        4,
        1,
        [255, 0, 0, 255],
        2,
    );
    Ok(())
}

#[test]
fn captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles() -> Result<()> {
    if std::env::var("GPUI_REQUIRE_GPU").as_deref() != Ok("1") {
        eprintln!("skipping native capture parity; set GPUI_REQUIRE_GPU=1 to require a GPU");
        return Ok(());
    }

    let scene = probe_scene();
    // BGRA atlas bytes: opaque red first, then half-alpha blue in the same canonical slots.
    let first = capture(&scene, 255, [0, 0, 255, 255])?;
    let second = capture(&scene, 96, [255, 0, 0, 128])?;
    assert_eq!(first.bitmaps().len(), 2);
    assert_eq!(second.bitmaps().len(), 2);
    assert_ne!(first.bitmaps(), second.bitmaps());

    let mut renderer = WgpuHeadlessRenderer::new_with_measurements()?;
    assert_timestamp_capability(&renderer)?;
    let first_scene = renderer.load_capture(&first)?;
    let first_gpu = renderer.render_scene_to_image(&first_scene, SIZE)?;
    let first_cpu = cpu_image(&first)?;
    assert_probes(
        &first_cpu,
        &first_gpu,
        &[
            ("transparent left of mask", 0, 0, [0, 0, 0, 0]),
            ("transparent right of mask", 12, 2, [0, 0, 0, 0]),
            ("half-alpha red", 2, 2, [255, 0, 0, 128]),
            ("mask excludes overlay", 4, 2, [255, 0, 0, 128]),
            ("blue over red", 6, 2, [85, 0, 170, 191]),
            ("monochrome sprite", 1, 10, [0, 255, 0, 255]),
            ("polychrome sprite", 5, 10, [255, 0, 0, 255]),
        ],
    );

    let restored = second.to_scene()?;
    assert_eq!(restored.monochrome_sprites[0].tile.texture_id.index, 0);
    assert_eq!(restored.polychrome_sprites[0].tile.texture_id.index, 1);
    let second_scene = renderer.load_capture(&second)?;
    assert_eq!(second_scene.monochrome_sprites[0].tile.texture_id.index, 0);
    assert_eq!(second_scene.polychrome_sprites[0].tile.texture_id.index, 0);
    let second_gpu = renderer.render_scene_to_image(&second_scene, SIZE)?;
    let second_cpu = cpu_image(&second)?;
    assert_probes(
        &second_cpu,
        &second_gpu,
        &[
            ("reloaded monochrome bytes", 1, 10, [0, 255, 0, 96]),
            ("reloaded polychrome bytes", 5, 10, [0, 0, 255, 128]),
        ],
    );
    assert_ne!(first_gpu.get_pixel(1, 10), second_gpu.get_pixel(1, 10));
    assert_ne!(first_gpu.get_pixel(5, 10), second_gpu.get_pixel(5, 10));

    assert_memory(&renderer, SIZE);
    let resized = renderer.render_scene_to_image(&second_scene, RESIZED)?;
    assert_eq!(resized.dimensions(), (19, 9));
    assert_memory(&renderer, RESIZED);
    Ok(())
}
