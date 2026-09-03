use super::*;
use std::mem::{align_of, offset_of, size_of};

fn source_for(label: &str) -> String {
    if label == interface::SUBPIXEL_SPRITES.label {
        subpixel_sprite::WGSL_SOURCE.wgsl_source().unwrap()
    } else {
        base::WGSL_SOURCE.wgsl_source().unwrap()
    }
}

#[test]
fn validates_subpixel_shader() {
    let subpixel = subpixel_sprite::WGSL_SOURCE.wgsl_source().unwrap();
    wgsl_rs::validate_wgsl_source(&format!("enable dual_source_blending;\n{subpixel}")).unwrap();
    // build.rs validates at build time; cargo test re-validates here too.
    wgsl_rs::validate_wgsl_source(&base::WGSL_SOURCE.wgsl_source().unwrap()).unwrap();
    wgsl_rs::validate_wgsl_source(&emoji_rasterization::WGSL_SOURCE.wgsl_source().unwrap())
        .unwrap();
}

#[test]
fn build_generated_shaders_match_rust_sources() {
    assert_eq!(
        base::WGSL_SOURCE.wgsl_source().unwrap(),
        crate::artifacts::BASE_WGSL
    );
    let subpixel = subpixel_sprite::WGSL_SOURCE.wgsl_source().unwrap();
    assert_eq!(
        format!("enable dual_source_blending;\n{subpixel}"),
        crate::artifacts::SUBPIXEL_DUAL_SOURCE_WGSL
    );
}

#[test]
fn shader_interface_matches_generated_sources() {
    assert_eq!(common::GLOBALS.group, interface::GLOBAL_BIND_GROUP);
    assert_eq!(common::GLOBALS.binding, interface::GLOBAL_UNIFORMS_BINDING);
    assert_eq!(
        common::FONT_RASTERIZATION.group,
        interface::GLOBAL_BIND_GROUP
    );
    assert_eq!(
        common::FONT_RASTERIZATION.binding,
        interface::FONT_RASTERIZATION_BINDING
    );
    assert_eq!(quad::QUADS.group(), interface::DATA_BIND_GROUP);
    assert_eq!(quad::QUADS.binding(), interface::DATA_BUFFER_BINDING);
}

// TODO(naga-dep): switch to naga front-end parse to verify entry points once
// naga is promoted from build-dep to dev-dep (Seg5 scope).
#[test]
fn entry_point_coverage_all_and_emoji() {
    for pipeline in interface::ALL {
        let source = source_for(pipeline.label);
        assert!(
            source.contains(&format!("fn {}(", pipeline.vertex_entry)),
            "ALL pipeline missing vertex entry point {} in {}",
            pipeline.vertex_entry,
            pipeline.label,
        );
        assert!(
            source.contains(&format!("fn {}(", pipeline.fragment_entry)),
            "ALL pipeline missing fragment entry point {} in {}",
            pipeline.fragment_entry,
            pipeline.label,
        );
    }
    let emoji_source = emoji_rasterization::WGSL_SOURCE.wgsl_source().unwrap();
    assert!(
        emoji_source.contains(&format!(
            "fn {}(",
            interface::EMOJI_RASTERIZATION.vertex_entry
        )),
        "EMOJI_RASTERIZATION missing vertex entry point {}",
        interface::EMOJI_RASTERIZATION.vertex_entry,
    );
    assert!(
        emoji_source.contains(&format!(
            "fn {}(",
            interface::EMOJI_RASTERIZATION.fragment_entry
        )),
        "EMOJI_RASTERIZATION missing fragment entry point {}",
        interface::EMOJI_RASTERIZATION.fragment_entry,
    );
}

#[test]
fn shader_discriminants_match_scene_types() {
    assert_eq!(common::ShaderBool::Disabled as u32, 0);
    assert_eq!(common::ShaderBool::Enabled as u32, 1);
    assert_eq!(
        common::BackgroundTag::Solid as u32,
        gpui::BackgroundTag::Solid as u32
    );
    assert_eq!(
        common::BackgroundTag::LinearGradient as u32,
        gpui::BackgroundTag::LinearGradient as u32
    );
    assert_eq!(
        common::BackgroundTag::PatternSlash as u32,
        gpui::BackgroundTag::PatternSlash as u32
    );
    assert_eq!(
        common::BackgroundTag::Checkerboard as u32,
        gpui::BackgroundTag::Checkerboard as u32
    );
    assert_eq!(
        common::ColorSpace::Srgb as u32,
        gpui::ColorSpace::Srgb as u32
    );
    assert_eq!(
        common::ColorSpace::Oklab as u32,
        gpui::ColorSpace::Oklab as u32
    );
    assert_eq!(
        common::BorderStyle::Solid as u32,
        gpui::BorderStyle::Solid as u32
    );
    assert_eq!(
        common::BorderStyle::Dashed as u32,
        gpui::BorderStyle::Dashed as u32
    );
}

#[test]
fn repr_u32_enums_have_correct_layout() {
    for &(name, sz, al) in &[
        (
            "ShaderBool",
            size_of::<common::ShaderBool>(),
            align_of::<common::ShaderBool>(),
        ),
        (
            "BorderStyle",
            size_of::<gpui::BorderStyle>(),
            align_of::<gpui::BorderStyle>(),
        ),
        (
            "BackgroundTag",
            size_of::<gpui::BackgroundTag>(),
            align_of::<gpui::BackgroundTag>(),
        ),
        (
            "ColorSpace",
            size_of::<gpui::ColorSpace>(),
            align_of::<gpui::ColorSpace>(),
        ),
    ] {
        assert_eq!(sz, 4, "{name} size must be 4, got {sz}");
        assert_eq!(al, 4, "{name} alignment must be 4, got {al}");
    }
}

#[test]
fn scene_storage_abi_stride_and_alignment() {
    // Hardcoded expected strides — layout drift fails the test loudly.
    const EXPECTED: &[(&str, usize)] = &[
        ("Quad", 160),
        ("Shadow", 112),
        ("Underline", 64),
        ("MonochromeSprite", 112),
        ("SubpixelSprite", 112),
        ("PolychromeSprite", 96),
    ];
    assert_eq!(
        interface::SCENE_STORAGE_ABI.len(),
        EXPECTED.len(),
        "SCENE_STORAGE_ABI length changed"
    );
    for (i, abi) in interface::SCENE_STORAGE_ABI.iter().enumerate() {
        let (name, expected_stride) = EXPECTED[i];
        assert_eq!(
            abi.wgsl_type, name,
            "SCENE_STORAGE_ABI order/name mismatch at index {i}"
        );
        assert_eq!(
            abi.rust_stride, expected_stride,
            "SCENE_STORAGE_ABI stride mismatch for {name}: got {} expected {expected_stride}",
            abi.rust_stride,
        );
        assert_eq!(
            expected_stride % 4,
            0,
            "{name} stride must be 4-byte aligned"
        );
    }
}

macro_rules! check_layout {
    ($rust:ty, $expected_size:expr, $align4:expr, $(($field:ident, $offset:expr)),+ $(,)?) => {
        assert_eq!(size_of::<$rust>(), $expected_size, concat!(stringify!($rust), " size"));
        assert_eq!(align_of::<$rust>(), $align4, concat!(stringify!($rust), " align"));
        $(assert_eq!(offset_of!($rust, $field), $offset, concat!(stringify!($rust), "::", stringify!($field)));)+
    };
}

#[test]
fn no_hidden_padding_in_scene_buffer_data_types() {
    // Each BufferData scene type: no internal padding leaking uninit bytes.
    // Repr(C), all fields 4-byte aligned → align=4 and no padding if size matches layout.
    check_layout!(
        gpui::Quad,
        160,
        4,
        (order, 0),
        (border_style, 4),
        (bounds, 8),
        (content_mask, 24),
        (background, 40),
        (border_color, 112),
        (corner_radii, 128),
        (border_widths, 144),
    );
    check_layout!(
        gpui::Shadow,
        112,
        4,
        (order, 0),
        (blur_radius, 4),
        (bounds, 8),
        (corner_radii, 24),
        (content_mask, 40),
        (color, 56),
        (element_bounds, 72),
        (element_corner_radii, 88),
        (inset, 104),
        (padding, 108),
    );
    check_layout!(
        gpui::Underline,
        64,
        4,
        (order, 0),
        (padding, 4),
        (bounds, 8),
        (content_mask, 24),
        (color, 40),
        (thickness, 56),
        (wavy, 60),
    );
    // MonochromeSprite and SubpixelSprite share the same repr(C) layout.
    check_layout!(
        gpui::MonochromeSprite,
        112,
        4,
        (order, 0),
        (padding, 4),
        (bounds, 8),
        (content_mask, 24),
        (color, 40),
        (tile, 56),
        (transformation, 88),
    );
    check_layout!(
        gpui::SubpixelSprite,
        112,
        4,
        (order, 0),
        (padding, 4),
        (bounds, 8),
        (content_mask, 24),
        (color, 40),
        (tile, 56),
        (transformation, 88),
    );
    check_layout!(
        gpui::PolychromeSprite,
        96,
        4,
        (order, 0),
        (padding, 4),
        (grayscale, 8),
        (opacity, 12),
        (bounds, 16),
        (content_mask, 32),
        (corner_radii, 48),
        (tile, 64),
    );
}

#[test]
fn downlevel_decoder_parses_and_contains_required_functions() {
    let downlevel_source = crate::artifacts::BASE_DOWNLEVEL_WGSL;

    wgsl_rs::validate_wgsl_source(downlevel_source)
        .expect("BASE_DOWNLEVEL_WGSL failed to parse with current Naga");

    assert!(
        downlevel_source.contains("fn dl_scene_word("),
        "downlevel source missing dl_scene_word function"
    );
    assert!(
        downlevel_source.contains("bitcast<f32>"),
        "downlevel source missing bitcast<f32> for float transport"
    );
    assert!(
        downlevel_source.contains("DATA_TEXTURE_WIDTH"),
        "downlevel source missing DATA_TEXTURE_WIDTH constant"
    );
    // DATA_RANGE is emitted at group(1) binding(4) by build.rs (DOWNLEVEL_RANGE_BINDING=4).
    assert!(
        downlevel_source.contains("@group(1) @binding(4) var<uniform> DATA_RANGE"),
        "downlevel source missing DATA_RANGE uniform at @group(1) @binding(4)"
    );

    // Per-type decoders: build.rs emits dl_load_{TYPE}_impl for every storage array element
    // linked into the base shader. The base links quad, shadow, underline, monochrome_sprite,
    // polychrome_sprite, path_rasterization, and path — so their types get decoders.
    // SubpixelSprite lives in a separate shader (dual_source_blending) and is not lowered.
    for type_name in [
        "Quad",
        "Shadow",
        "Underline",
        "MonochromeSprite",
        "PolychromeSprite",
        "PathRasterizationVertex",
        "PathSprite",
    ] {
        assert!(
            downlevel_source.contains(&format!("fn dl_load_{type_name}_impl(")),
            "downlevel source missing dl_load_{type_name}_impl decoder",
        );
    }
    assert!(
        !downlevel_source.contains("dl_load_SubpixelSprite_impl"),
        "SubpixelSprite should NOT have a downlevel decoder (separate shader)"
    );
}

#[test]
fn linear_gradients_preserve_native_dithering() {
    use common::*;
    use wgsl_rs::std::*;

    let color = Hsla {
        h: 0.0,
        s: 0.0,
        l: 0.5,
        a: 0.5,
    };
    let background = Background {
        tag: BackgroundTag::LinearGradient,
        color_space: ColorSpace::Srgb,
        solid: color,
        gradient_angle_or_pattern_height: 90.0,
        colors: [
            LinearColorStop {
                color,
                percentage: 0.0,
            },
            LinearColorStop {
                color,
                percentage: 1.0,
            },
        ],
        padding: 0,
    };
    let bounds = Bounds {
        origin: vec2f(0.0, 0.0),
        size: vec2f(100.0, 100.0),
    };
    let prepared = prepare_background(background);
    let first = background_color(background, vec2f(10.0, 10.0), bounds, prepared);
    let second = background_color(background, vec2f(11.0, 10.0), bounds, prepared);

    assert_ne!(first.w, second.w);
}
