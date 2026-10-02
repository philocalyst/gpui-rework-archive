//! A small direct-WGPU integration probe for the Rust-authored paint recipe.
//!
//! This intentionally bypasses GPUI's renderer so it measures the WGSL module,
//! typed uniform block, and one reusable pipeline without claiming integration
//! with GPUI's scene or material APIs.
#![cfg(feature = "test-support")]

use std::num::NonZeroU64;

use image::{RgbaImage, imageops};
use naga::{TypeInner, proc::Layouter};
use wgsl_rs::std::vec4f;

#[path = "../../gpui_render/tests/fixtures/shader_builder.rs"]
mod shader_builder;
#[path = "../../gpui_render/tests/fixtures/shader_recipes.rs"]
mod shader_recipes;

use shader_recipes::{
    fixtures::{self, Pixel},
    recipe_types::{Fragment, Params, Settings},
};

const WIDTH: u32 = 128;
const HEIGHT: u32 = 128;
const PARAMS_SIZE: usize = 80;
const PIXEL_TOLERANCE: u8 = 3;

#[derive(Clone, Copy)]
struct Variant {
    name: &'static str,
    params: Params,
}

#[derive(Default)]
struct ProbeCounters {
    pipeline_creations: u32,
    render_passes: u32,
    draw_calls: u32,
    uniform_updates: u32,
    submissions: u32,
    readbacks: u32,
}

#[test]
fn recipe_uniform_updates_render_through_one_pipeline_and_match_cpu_pixels() {
    let source = fixtures::full_shader_source();
    let module = naga::front::wgsl::parse_str(&source)
        .unwrap_or_else(|error| panic!("{}", error.emit_to_string(&source)));
    naga::valid::Validator::new(
        naga::valid::ValidationFlags::all(),
        naga::valid::Capabilities::empty(),
    )
    .validate(&module)
    .expect("the complete fixture shader must validate");
    check_uniform_layout(&module);

    let base = fixtures::params();
    let mut wave_update = base;
    wave_update.wave = Settings {
        tint: vec4f(0.12, 0.85, 0.18, 0.82),
        frequency: 10.0,
        phase: 1.1,
        opacity: 0.9,
        padding: 0.0,
    };

    let mut pulse_update = base;
    pulse_update.pulse = Settings {
        tint: vec4f(0.92, 0.72, 0.08, 0.7),
        frequency: 1.5,
        phase: 0.45,
        opacity: 0.8,
        padding: 0.0,
    };

    let mut reverse_order = base;
    reverse_order.reverse_order = 1;

    let mut same_recipe = base;
    same_recipe.same_recipe = 1;
    let mut same_recipe_wave_update = wave_update;
    same_recipe_wave_update.same_recipe = 1;
    let mut same_recipe_pulse_update = pulse_update;
    same_recipe_pulse_update.same_recipe = 1;

    let variants = [
        Variant {
            name: "base",
            params: base,
        },
        Variant {
            name: "wave update",
            params: wave_update,
        },
        Variant {
            name: "pulse update",
            params: pulse_update,
        },
        Variant {
            name: "reverse order",
            params: reverse_order,
        },
        Variant {
            name: "same recipe twice",
            params: same_recipe,
        },
        Variant {
            name: "same recipe first settings update",
            params: same_recipe_wave_update,
        },
        Variant {
            name: "same recipe second settings update",
            params: same_recipe_pulse_update,
        },
    ];

    let packed = variants
        .iter()
        .map(|variant| pack_params(variant.params).to_vec())
        .collect::<Vec<_>>();
    let (rendered, counters) =
        render_program_variants(&source, "vertex_recipe", "fragment_recipe", &packed);
    assert_eq!(counters.pipeline_creations, 1);
    assert_eq!(counters.render_passes, variants.len() as u32);
    assert_eq!(counters.draw_calls, variants.len() as u32);
    assert_eq!(counters.uniform_updates, variants.len() as u32);
    assert_eq!(counters.submissions, variants.len() as u32);
    assert_eq!(counters.readbacks, variants.len() as u32);

    for (variant, actual) in variants.iter().zip(&rendered) {
        compare_all_pixels(variant, actual);
    }

    assert_images_differ(
        &rendered[0],
        &rendered[1],
        "wave settings must update independently",
    );
    assert_images_differ(
        &rendered[0],
        &rendered[2],
        "pulse settings must update independently",
    );
    assert_images_differ(
        &rendered[0],
        &rendered[3],
        "changing layer order must change premultiplied RGB",
    );
    let (overlap_x, overlap_y, wave_alpha, second_alpha) = find_overlapping_sample(base);
    assert!(wave_alpha > 0.05 && second_alpha > 0.05);
    assert!(
        rendered[0].get_pixel(overlap_x, overlap_y)[3]
            .abs_diff(rendered[3].get_pixel(overlap_x, overlap_y)[3])
            <= 1,
        "source-over alpha is invariant when swapping two visible layers at ({overlap_x},{overlap_y})",
    );
    assert!(
        rendered[2].get_pixel(64, 2)[3] > 5,
        "the broadened pulse should reach the soft top-edge mask with visible alpha"
    );
    assert_images_differ(
        &rendered[4],
        &rendered[5],
        "updating the first wave instance must affect the same_recipe variant",
    );
    assert_images_differ(
        &rendered[4],
        &rendered[6],
        "updating the second wave instance must affect the same_recipe variant",
    );

    save_gallery(&rendered);
}

fn create_device() -> (wgpu::Device, wgpu::Queue) {
    pollster::block_on(async {
        let instance = wgpu::Instance::new(wgpu::InstanceDescriptor {
            backends: wgpu::Backends::all(),
            flags: wgpu::InstanceFlags::default(),
            backend_options: wgpu::BackendOptions::default(),
            memory_budget_thresholds: wgpu::MemoryBudgetThresholds::default(),
            display: None,
        });
        let adapter = instance
            .request_adapter(&wgpu::RequestAdapterOptions {
                power_preference: wgpu::PowerPreference::LowPower,
                compatible_surface: None,
                force_fallback_adapter: false,
            })
            .await
            .expect("a working GPU adapter is required for this test");
        adapter
            .request_device(&wgpu::DeviceDescriptor {
                label: Some("shader-recipe-gpu-test-device"),
                required_features: wgpu::Features::empty(),
                required_limits: wgpu::Limits::downlevel_defaults()
                    .using_resolution(adapter.limits())
                    .using_alignment(adapter.limits()),
                memory_hints: wgpu::MemoryHints::MemoryUsage,
                trace: wgpu::Trace::Off,
                experimental_features: wgpu::ExperimentalFeatures::disabled(),
            })
            .await
            .expect("a working GPU device is required for this test")
    })
}

fn check_uniform_layout(module: &naga::Module) {
    let mut layouter = Layouter::default();
    layouter
        .update(module.to_ctx())
        .expect("WGSL types need valid layouts");

    let settings = find_struct(module, "Settings");
    assert_member_offsets(
        settings,
        &[
            ("tint", 0),
            ("frequency", 16),
            ("phase", 20),
            ("opacity", 24),
            ("padding", 28),
        ],
    );
    assert_eq!(layouter[settings.0].size, 32);

    let params = find_struct(module, "Params");
    assert_member_offsets(
        params,
        &[
            ("wave", 0),
            ("pulse", 32),
            ("reverse_order", 64),
            ("same_recipe", 68),
        ],
    );
    assert_eq!(layouter[params.0].size, PARAMS_SIZE as u32);
    assert_eq!(layouter[params.0].alignment, naga::proc::Alignment::SIXTEEN);

    let uniform = module
        .global_variables
        .iter()
        .find(|(_, global)| global.name.as_deref() == Some("PAINT_PARAMS"))
        .map(|(_, global)| global)
        .expect("the named Params uniform must be reflected by Naga");
    assert_eq!(uniform.space, naga::AddressSpace::Uniform);
    assert_eq!(module.types[uniform.ty].name.as_deref(), Some("Params"));
}

fn find_struct<'a>(
    module: &'a naga::Module,
    name: &str,
) -> (naga::Handle<naga::Type>, &'a [naga::StructMember], u32) {
    let (handle, ty) = module
        .types
        .iter()
        .find(|(_, ty)| ty.name.as_deref() == Some(name))
        .unwrap_or_else(|| panic!("WGSL must contain the named `{name}` struct"));
    match &ty.inner {
        TypeInner::Struct { members, span } => (handle, members, *span),
        other => panic!("WGSL type `{name}` was not a struct: {other:?}"),
    }
}

fn assert_member_offsets(
    (handle, members, _span): (naga::Handle<naga::Type>, &[naga::StructMember], u32),
    expected: &[(&str, u32)],
) {
    let actual = members
        .iter()
        .map(|member| (member.name.as_deref().unwrap_or("<unnamed>"), member.offset))
        .collect::<Vec<_>>();
    assert_eq!(
        actual, expected,
        "reflected member offsets differ for type {:?}",
        handle
    );
}

fn pack_params(params: Params) -> [u8; PARAMS_SIZE] {
    let mut bytes = [0; PARAMS_SIZE];
    pack_settings(&mut bytes, 0, params.wave);
    pack_settings(&mut bytes, 32, params.pulse);
    bytes[64..68].copy_from_slice(&params.reverse_order.to_le_bytes());
    bytes[68..72].copy_from_slice(&params.same_recipe.to_le_bytes());
    bytes
}

fn pack_settings(bytes: &mut [u8; PARAMS_SIZE], offset: usize, settings: Settings) {
    for (component, value) in [
        settings.tint.x,
        settings.tint.y,
        settings.tint.z,
        settings.tint.w,
    ]
    .into_iter()
    .enumerate()
    {
        write_f32(bytes, offset + component * 4, value);
    }
    write_f32(bytes, offset + 16, settings.frequency);
    write_f32(bytes, offset + 20, settings.phase);
    write_f32(bytes, offset + 24, settings.opacity);
    write_f32(bytes, offset + 28, settings.padding);
}

fn write_f32(bytes: &mut [u8; PARAMS_SIZE], offset: usize, value: f32) {
    bytes[offset..offset + 4].copy_from_slice(&value.to_le_bytes());
}

fn read_image(
    device: &wgpu::Device,
    buffer: &wgpu::Buffer,
    submission: wgpu::SubmissionIndex,
    padded_bytes_per_row: u32,
) -> RgbaImage {
    let (sender, receiver) = std::sync::mpsc::sync_channel(1);
    buffer
        .slice(..)
        .map_async(wgpu::MapMode::Read, move |result| {
            let _ = sender.send(result);
        });
    device
        .poll(wgpu::PollType::Wait {
            submission_index: Some(submission),
            timeout: None,
        })
        .expect("GPU readback polling must succeed");
    receiver
        .recv()
        .expect("GPU readback callback must run")
        .expect("GPU readback mapping must succeed");

    let mapped = buffer.slice(..).get_mapped_range();
    let mut pixels = Vec::with_capacity((WIDTH * HEIGHT * 4) as usize);
    for row in mapped.chunks_exact(padded_bytes_per_row as usize) {
        pixels.extend_from_slice(&row[..(WIDTH * 4) as usize]);
    }
    drop(mapped);
    buffer.unmap();
    RgbaImage::from_raw(WIDTH, HEIGHT, pixels).expect("readback byte count must match the image")
}

fn compare_all_pixels(variant: &Variant, actual: &RgbaImage) {
    assert!(
        actual.pixels().any(|pixel| pixel.0[3] > 0),
        "{} produced an empty image",
        variant.name
    );
    let mut max_channel_error = 0_u8;
    for y in 0..HEIGHT {
        for x in 0..WIDTH {
            let coordinate = pixel_center_coordinate(x, y);
            let mask_opacity = edge_mask(coordinate);
            let expected = fixtures::cpu_evaluate(
                Fragment {
                    coordinate: wgsl_rs::std::vec2f(coordinate[0], coordinate[1]),
                    mask_opacity,
                },
                variant.params,
            );
            assert_source_over_alpha(variant.params, coordinate, mask_opacity, expected);
            let actual = actual.get_pixel(x, y).0;
            for channel in 0..4 {
                let expected_byte = to_unorm8(expected[channel]);
                let delta = actual[channel].abs_diff(expected_byte);
                max_channel_error = max_channel_error.max(delta);
                assert!(
                    delta <= PIXEL_TOLERANCE,
                    "{} at ({x},{y}) channel {channel}: GPU={} CPU={expected_byte} (float {:.6}, max error {})",
                    variant.name,
                    actual[channel],
                    expected[channel],
                    max_channel_error
                );
            }
        }
    }
}

fn pixel_center_coordinate(x: u32, y: u32) -> [f32; 2] {
    [
        (x as f32 + 0.5) / WIDTH as f32,
        1.0 - (y as f32 + 0.5) / HEIGHT as f32,
    ]
}

fn edge_mask(coordinate: [f32; 2]) -> f32 {
    let edge = coordinate[0]
        .min(1.0 - coordinate[0])
        .min(coordinate[1])
        .min(1.0 - coordinate[1]);
    (edge * 12.0).clamp(0.0, 1.0)
}

fn assert_source_over_alpha(params: Params, coordinate: [f32; 2], mask: f32, result: Pixel) {
    let wave = wave_alpha(coordinate, params.wave);
    let second = if params.same_recipe == 0 {
        pulse_alpha(coordinate, params.pulse)
    } else {
        wave_alpha(coordinate, params.pulse)
    };
    // For premultiplied source-over, alpha is a + b - a*b. The scalar
    // expression here is independent of the CPU fixture's vector helper.
    let expected_alpha = (wave + second - wave * second) * mask.clamp(0.0, 1.0);
    assert!(
        (result[3] - expected_alpha).abs() < 0.00001,
        "CPU evaluator alpha {} differs from independent source-over alpha oracle {expected_alpha}",
        result[3]
    );
}

fn wave_alpha(coordinate: [f32; 2], settings: Settings) -> f32 {
    let angle = coordinate[0] * settings.frequency + settings.phase;
    let stripe_y = 0.5 + 0.2 * angle.sin();
    let coverage = (1.0 - (coordinate[1] - stripe_y).abs() * 10.0).max(0.0);
    settings.tint.w * settings.opacity.clamp(0.0, 1.0) * coverage
}

fn pulse_alpha(coordinate: [f32; 2], settings: Settings) -> f32 {
    let dx = coordinate[0] - 0.5;
    let dy = coordinate[1] - 0.5;
    let radius = (dx * dx + dy * dy).sqrt();
    let ring_radius = 0.18 + 0.04 * settings.phase.sin();
    let coverage = (1.0 - (radius - ring_radius).abs() * settings.frequency).max(0.0);
    settings.tint.w * settings.opacity.clamp(0.0, 1.0) * coverage
}

fn find_overlapping_sample(params: Params) -> (u32, u32, f32, f32) {
    let mut best = None;
    for y in 0..HEIGHT {
        for x in 0..WIDTH {
            let coordinate = pixel_center_coordinate(x, y);
            let wave = wave_alpha(coordinate, params.wave);
            let second = if params.same_recipe == 0 {
                pulse_alpha(coordinate, params.pulse)
            } else {
                wave_alpha(coordinate, params.pulse)
            };
            let score = wave.min(second) * edge_mask(coordinate);
            if best.is_none_or(|(_, _, _, _, previous_score)| score > previous_score) {
                best = Some((x, y, wave, second, score));
            }
        }
    }
    let (x, y, wave, second, _) = best.expect("the image has pixel centers");
    (x, y, wave, second)
}

fn to_unorm8(value: f32) -> u8 {
    (value.clamp(0.0, 1.0) * 255.0).round() as u8
}

fn assert_images_differ(first: &RgbaImage, second: &RgbaImage, message: &str) {
    let differing_pixels = first
        .pixels()
        .zip(second.pixels())
        .filter(|(a, b)| a.0 != b.0)
        .count();
    assert!(
        differing_pixels > 64,
        "{message}; only {differing_pixels} pixels changed"
    );
}

fn save_gallery(images: &[RgbaImage]) {
    const COLUMNS: u32 = 4;
    const ROWS: u32 = 2;
    let mut gallery = RgbaImage::from_pixel(
        WIDTH * COLUMNS,
        HEIGHT * ROWS,
        image::Rgba([24, 26, 32, 255]),
    );
    for (index, image) in images.iter().enumerate() {
        let x = (index as u32 % COLUMNS) * WIDTH;
        let y = (index as u32 / COLUMNS) * HEIGHT;
        let preview = composite_over_dark(image);
        imageops::replace(&mut gallery, &preview, i64::from(x), i64::from(y));
    }
    gallery
        .save("/tmp/gpui-shader-recipes.png")
        .expect("the shader recipe gallery should be saved under /tmp");
}

fn composite_over_dark(image: &RgbaImage) -> RgbaImage {
    let mut preview = RgbaImage::new(image.width(), image.height());
    for (source, target) in image.pixels().zip(preview.pixels_mut()) {
        let alpha = source.0[3] as f32 / 255.0;
        *target = image::Rgba([
            (source.0[0] as f32 + 24.0 * (1.0 - alpha)).round() as u8,
            (source.0[1] as f32 + 26.0 * (1.0 - alpha)).round() as u8,
            (source.0[2] as f32 + 32.0 * (1.0 - alpha)).round() as u8,
            255,
        ]);
    }
    preview
}

#[test]
fn direct_ir_builder_renders_independent_values_and_mapped_clones() {
    use shader_builder::{CompiledShader, bands, shader};

    let red = [0.72, 0.08, 0.07, 0.8];
    let blue = [0.04, 0.17, 0.63, 0.7];
    let two = |front_phase, front_tint, back_phase, back_tint| {
        shader(|pixel| {
            bands(pixel, front_phase, front_tint).over(bands(pixel, back_phase, back_tint))
        })
        .compile()
    };
    let variants: [CompiledShader; 5] = [
        two(0.31, red, 0.31, blue),
        two(0.87, red, 0.31, blue),
        two(0.31, red, 1.2, blue),
        two(0.31, blue, 0.31, red),
        two(0.31, [0.8, 0.1, 0.1, 1.0], 0.31, [0.1, 0.2, 0.8, 1.0]),
    ];
    assert!(
        variants
            .iter()
            .all(|item| item.source == variants[0].source)
    );
    assert_eq!(
        variants[0]
            .uniforms
            .iter()
            .flat_map(|slot| slot.iter())
            .filter(|value| **value == 0.31)
            .count(),
        2,
        "two independent helper calls with equal values need separate bindings"
    );

    let rendered = render_builder_variants(&variants);
    for (index, image) in rendered.iter().enumerate() {
        let (front_phase, front_tint, back_phase, back_tint) = match index {
            0 => (0.31, red, 0.31, blue),
            1 => (0.87, red, 0.31, blue),
            2 => (0.31, red, 1.2, blue),
            3 => (0.31, blue, 0.31, red),
            4 => (0.31, [0.8, 0.1, 0.1, 1.0], 0.31, [0.1, 0.2, 0.8, 1.0]),
            _ => unreachable!(),
        };
        compare_builder_pixels(image, |uv| {
            manual_over(
                manual_band(uv[0], front_phase, front_tint),
                manual_band(uv[0], back_phase, back_tint),
            )
        });
    }
    assert_images_differ(
        &rendered[0],
        &rendered[1],
        "front phase must bind independently",
    );
    assert_images_differ(
        &rendered[0],
        &rendered[2],
        "back phase must bind independently",
    );
    assert_images_differ(&rendered[0], &rendered[3], "source order must change RGB");
    for (forward, reverse) in rendered[0].pixels().zip(rendered[3].pixels()) {
        assert!(
            forward[3].abs_diff(reverse[3]) <= 1,
            "source-over alpha must be order invariant at every pixel"
        );
    }
    let edge_alpha = rendered[4].get_pixel(5, 64)[3];
    assert!(
        (120..=143).contains(&edge_alpha),
        "half-covered opaque layers should have fractional alpha, got {edge_alpha}"
    );

    let shared_tint = [0.25, 0.12, 0.55, 0.6];
    let mapped = shader(|pixel| {
        let base = bands(pixel, 0.47, shared_tint);
        base.clone()
            .shift_x(0.12)
            .over(base.clone().shift_x(-0.08))
            .over(base)
    })
    .compile();
    assert_eq!(mapped.stats.domain_expressions, 2);
    assert_eq!(mapped.source.matches("sin(").count(), 3);
    assert_eq!(
        mapped
            .uniforms
            .iter()
            .flat_map(|slot| slot.iter())
            .filter(|value| **value == 0.47)
            .count(),
        1,
        "mapped clones must retain one phase binding"
    );
    let mapped_image = render_builder_variants(&[mapped]);
    compare_builder_pixels(&mapped_image[0], |uv| {
        let shifted_right = manual_band(uv[0] + 0.12, 0.47, shared_tint);
        let shifted_left = manual_band(uv[0] - 0.08, 0.47, shared_tint);
        let unshifted = manual_band(uv[0], 0.47, shared_tint);
        manual_over(manual_over(shifted_right, shifted_left), unshifted)
    });

    let per_fragment_color = shader(|pixel| {
        shader_builder::rgba(pixel.uv().x(), 0.2, 0.3, 0.7)
            .over(shader_builder::color([0.1, 0.1, 0.1, 1.0]))
    })
    .compile();
    let per_fragment_image = render_builder_variants(&[per_fragment_color]);
    compare_builder_pixels(&per_fragment_image[0], |uv| {
        [uv[0] * 0.7 + 0.03, 0.17, 0.24, 1.0]
    });

    let realistic_states = [
        (
            0.17,
            [0.08, 0.18, 0.72, 0.8],
            0.61,
            [0.75, 0.12, 0.08, 0.9],
            0.7,
        ),
        (
            0.37,
            [0.22, 0.31, 0.64, 0.8],
            0.83,
            [0.6, 0.2, 0.14, 0.9],
            0.4,
        ),
    ];
    let realistic_programs =
        realistic_states.map(|(front_phase, front_tint, back_phase, back_tint, mask)| {
            shader_builder::realistic_recipe(front_phase, front_tint, back_phase, back_tint, mask)
                .compile()
        });
    assert_eq!(realistic_programs[0].source, realistic_programs[1].source);
    assert_ne!(
        realistic_programs[0].uniforms,
        realistic_programs[1].uniforms
    );
    let realistic_images = render_builder_variants(&realistic_programs);
    for (state, image) in realistic_states.iter().zip(&realistic_images) {
        let (front_phase, front_tint, back_phase, back_tint, mask) = *state;
        compare_builder_pixels(image, |uv| {
            let back = manual_scale(manual_band(uv[0] + 0.035, back_phase, back_tint), 0.65);
            let front = manual_band(uv[0], front_phase, front_tint);
            let masked = manual_scale(front, mask);
            let first = manual_over(back, masked);
            let mixed = manual_mix(first, manual_scale(front, 0.55), 0.3);
            manual_over(mixed, masked)
        });
    }
    assert_images_differ(
        &realistic_images[0],
        &realistic_images[1],
        "nested builder values must update without code changes",
    );

    let mut gallery = RgbaImage::from_pixel(WIDTH * 4, HEIGHT * 3, image::Rgba([24, 26, 32, 255]));
    for (index, image) in rendered
        .iter()
        .chain(mapped_image.iter())
        .chain(per_fragment_image.iter())
        .chain(realistic_images.iter())
        .enumerate()
    {
        let preview = composite_over_dark(image);
        imageops::replace(
            &mut gallery,
            &preview,
            i64::from(index as u32 % 4 * WIDTH),
            i64::from(index as u32 / 4 * HEIGHT),
        );
    }
    gallery
        .save("/tmp/gpui-shader-builder.png")
        .expect("builder gallery should save");
}

fn render_builder_variants(programs: &[shader_builder::CompiledShader]) -> Vec<RgbaImage> {
    assert!(!programs.is_empty());
    let count = programs[0].uniforms.len();
    assert!(count > 0);
    assert!(
        programs
            .iter()
            .all(|program| program.source == programs[0].source && program.uniforms.len() == count)
    );
    const ENTRYPOINTS: &str = r#"
struct RasterOut {
    @builtin(position) position: vec4f,
    @location(0) uv: vec2f,
}
@vertex fn builder_vertex(@builtin(vertex_index) index: u32) -> RasterOut {
    let positions = array<vec2f, 3>(vec2f(-1.0, -1.0), vec2f(3.0, -1.0), vec2f(-1.0, 3.0));
    let position = positions[index];
    return RasterOut(vec4f(position, 0.0, 1.0), (position + vec2f(1.0, 1.0)) * 0.5);
}
@fragment fn builder_fragment(input: RasterOut) -> @location(0) vec4f {
    let edge = min(min(input.uv.x, 1.0 - input.uv.x), min(input.uv.y, 1.0 - input.uv.y));
    return shade(Fragment(input.uv, clamp(edge * 12.0, 0.0, 1.0)));
}
"#;
    let source = format!("{}\n{ENTRYPOINTS}", programs[0].source);
    let module = naga::front::wgsl::parse_str(&source).unwrap_or_else(|error| {
        panic!(
            "builder WGSL parse failed:\n{}",
            error.emit_to_string(&source)
        )
    });
    naga::valid::Validator::new(
        naga::valid::ValidationFlags::all(),
        naga::valid::Capabilities::empty(),
    )
    .validate(&module)
    .expect("complete builder shader must validate with portable capabilities");
    let params = find_struct(&module, "Params");
    assert_eq!(params.1[0].name.as_deref(), Some("values"));
    assert_eq!(params.1[0].offset, 0);
    assert_eq!(params.2, (count * 16) as u32);

    let records = programs
        .iter()
        .map(|program| {
            let mut bytes = Vec::with_capacity(count * 16);
            for slot in &program.uniforms {
                for channel in slot {
                    bytes.extend_from_slice(&channel.to_le_bytes());
                }
            }
            bytes
        })
        .collect::<Vec<_>>();
    render_program_variants(&source, "builder_vertex", "builder_fragment", &records).0
}

fn render_program_variants(
    source: &str,
    vertex_entry: &str,
    fragment_entry: &str,
    records: &[Vec<u8>],
) -> (Vec<RgbaImage>, ProbeCounters) {
    assert!(!records.is_empty());
    let uniform_size = records[0].len();
    assert!(uniform_size > 0 && records.iter().all(|record| record.len() == uniform_size));
    let (device, queue) = create_device();
    let shader = device.create_shader_module(wgpu::ShaderModuleDescriptor {
        label: Some("direct-ir-builder-shader"),
        source: wgpu::ShaderSource::Wgsl(source.to_owned().into()),
    });
    let binding_layout = device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor {
        label: Some("direct-ir-builder-layout"),
        entries: &[wgpu::BindGroupLayoutEntry {
            binding: 0,
            visibility: wgpu::ShaderStages::FRAGMENT,
            ty: wgpu::BindingType::Buffer {
                ty: wgpu::BufferBindingType::Uniform,
                has_dynamic_offset: false,
                min_binding_size: NonZeroU64::new((uniform_size) as u64),
            },
            count: None,
        }],
    });
    let buffer = device.create_buffer(&wgpu::BufferDescriptor {
        label: Some("direct-ir-builder-params"),
        size: (uniform_size) as u64,
        usage: wgpu::BufferUsages::UNIFORM | wgpu::BufferUsages::COPY_DST,
        mapped_at_creation: false,
    });
    let bind_group = device.create_bind_group(&wgpu::BindGroupDescriptor {
        label: Some("direct-ir-builder-bind-group"),
        layout: &binding_layout,
        entries: &[wgpu::BindGroupEntry {
            binding: 0,
            resource: buffer.as_entire_binding(),
        }],
    });
    let pipeline_layout = device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
        label: Some("direct-ir-builder-pipeline-layout"),
        bind_group_layouts: &[Some(&binding_layout)],
        immediate_size: 0,
    });
    let pipeline = device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
        label: Some("direct-ir-builder-pipeline"),
        layout: Some(&pipeline_layout),
        vertex: wgpu::VertexState {
            module: &shader,
            entry_point: Some(vertex_entry),
            buffers: &[],
            compilation_options: wgpu::PipelineCompilationOptions::default(),
        },
        fragment: Some(wgpu::FragmentState {
            module: &shader,
            entry_point: Some(fragment_entry),
            compilation_options: wgpu::PipelineCompilationOptions::default(),
            targets: &[Some(wgpu::ColorTargetState {
                format: wgpu::TextureFormat::Rgba8Unorm,
                blend: None,
                write_mask: wgpu::ColorWrites::ALL,
            })],
        }),
        primitive: wgpu::PrimitiveState::default(),
        depth_stencil: None,
        multisample: wgpu::MultisampleState::default(),
        multiview_mask: None,
        cache: None,
    });
    let texture = device.create_texture(&wgpu::TextureDescriptor {
        label: Some("direct-ir-builder-output"),
        size: wgpu::Extent3d {
            width: WIDTH,
            height: HEIGHT,
            depth_or_array_layers: 1,
        },
        mip_level_count: 1,
        sample_count: 1,
        dimension: wgpu::TextureDimension::D2,
        format: wgpu::TextureFormat::Rgba8Unorm,
        usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
        view_formats: &[],
    });
    let view = texture.create_view(&wgpu::TextureViewDescriptor::default());
    let padded_bytes_per_row = (WIDTH * 4).next_multiple_of(wgpu::COPY_BYTES_PER_ROW_ALIGNMENT);
    let readback = device.create_buffer(&wgpu::BufferDescriptor {
        label: Some("direct-ir-builder-readback"),
        size: u64::from(padded_bytes_per_row) * u64::from(HEIGHT),
        usage: wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
        mapped_at_creation: false,
    });
    let mut images = Vec::with_capacity(records.len());
    let mut counters = ProbeCounters {
        pipeline_creations: 1,
        ..Default::default()
    };
    for bytes in records {
        counters.uniform_updates += 1;
        queue.write_buffer(&buffer, 0, bytes);
        let mut encoder = device.create_command_encoder(&wgpu::CommandEncoderDescriptor {
            label: Some("direct-ir-builder-encoder"),
        });
        {
            let mut pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
                label: Some("direct-ir-builder-pass"),
                color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                    view: &view,
                    resolve_target: None,
                    ops: wgpu::Operations {
                        load: wgpu::LoadOp::Clear(wgpu::Color::TRANSPARENT),
                        store: wgpu::StoreOp::Store,
                    },
                    depth_slice: None,
                })],
                depth_stencil_attachment: None,
                ..Default::default()
            });
            pass.set_pipeline(&pipeline);
            pass.set_bind_group(0, &bind_group, &[]);
            pass.draw(0..3, 0..1);
            counters.render_passes += 1;
            counters.draw_calls += 1;
        }
        encoder.copy_texture_to_buffer(
            texture.as_image_copy(),
            wgpu::TexelCopyBufferInfo {
                buffer: &readback,
                layout: wgpu::TexelCopyBufferLayout {
                    offset: 0,
                    bytes_per_row: Some(padded_bytes_per_row),
                    rows_per_image: Some(HEIGHT),
                },
            },
            wgpu::Extent3d {
                width: WIDTH,
                height: HEIGHT,
                depth_or_array_layers: 1,
            },
        );
        let submission = queue.submit([encoder.finish()]);
        counters.submissions += 1;
        images.push(read_image(
            &device,
            &readback,
            submission,
            padded_bytes_per_row,
        ));
        counters.readbacks += 1;
    }
    (images, counters)
}

fn compare_builder_pixels(image: &RgbaImage, paint: impl Fn([f32; 2]) -> [f32; 4]) {
    assert!(image.pixels().any(|pixel| pixel[3] > 0));
    for y in 0..HEIGHT {
        for x in 0..WIDTH {
            let uv = pixel_center_coordinate(x, y);
            let mut expected = paint(uv);
            for channel in &mut expected {
                *channel *= edge_mask(uv);
            }
            let actual = image.get_pixel(x, y).0;
            for channel in 0..4 {
                let expected_byte = to_unorm8(expected[channel]);
                assert!(
                    actual[channel].abs_diff(expected_byte) <= PIXEL_TOLERANCE,
                    "builder pixel ({x},{y}) channel {channel}: GPU={} CPU={expected_byte}",
                    actual[channel]
                );
            }
        }
    }
}

fn manual_band(x: f32, phase: f32, tint: [f32; 4]) -> [f32; 4] {
    let amount = (x * 12.0 + phase).sin() * 0.5 + 0.5;
    let accent = [0.94, 0.28, 0.08, 1.0];
    let alpha = tint[3].clamp(0.0, 1.0);
    let premultiplied = [tint[0] * alpha, tint[1] * alpha, tint[2] * alpha, alpha];
    std::array::from_fn(|index| premultiplied[index] * (1.0 - amount) + accent[index] * amount)
}

fn manual_over(front: [f32; 4], back: [f32; 4]) -> [f32; 4] {
    std::array::from_fn(|index| front[index] + back[index] * (1.0 - front[3]))
}

fn manual_scale(color: [f32; 4], amount: f32) -> [f32; 4] {
    let amount = amount.clamp(0.0, 1.0);
    color.map(|channel| channel * amount)
}

fn manual_mix(first: [f32; 4], second: [f32; 4], amount: f32) -> [f32; 4] {
    std::array::from_fn(|index| first[index] * (1.0 - amount) + second[index] * amount)
}
