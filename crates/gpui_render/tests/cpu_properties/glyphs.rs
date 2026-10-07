//! Glyphs rendering contracts.
use super::*;

#[test]
fn font_gamma_correction_preserves_neutral_and_corrects_half_coverage() {
    use gpui::{
        AtlasTextureId, AtlasTextureKind, AtlasTile, CapturedBitmap, MonochromeSprite, TileId,
    };
    use gpui_ce_render::{
        cpu::CpuRenderer,
        font::{FontRasterizationSettings, SubpixelOrder},
    };

    let tile = AtlasTile {
        texture_id: AtlasTextureId {
            index: 0,
            kind: AtlasTextureKind::Monochrome,
        },
        tile_id: TileId(0),
        padding: 0,
        bounds: Bounds {
            origin: point(DevicePixels(0), DevicePixels(0)),
            size: Size {
                width: DevicePixels(1),
                height: DevicePixels(1),
            },
        },
    };
    let bitmap = CapturedBitmap {
        kind: AtlasTextureKind::Monochrome,
        width: 1,
        height: 1,
        bytes: vec![128],
    };
    let mut scene = Scene::default();
    scene.insert_primitive(MonochromeSprite {
        order: 0,
        padding: 0,
        bounds: rect(0.0, 0.0, 1.0, 1.0),
        content_mask: ContentMask {
            bounds: rect(0.0, 0.0, 1.0, 1.0),
            ..Default::default()
        },
        color: Hsla::new(0.0, 0.0, 1.0, 1.0).into(),
        tile,
        transformation: Default::default(),
    });
    scene.finish();
    let size = Size {
        width: DevicePixels(1),
        height: DevicePixels(1),
    };
    let bitmaps = [bitmap];
    let neutral = FontRasterizationSettings::new(1.0, 0.0, 0.0, SubpixelOrder::RedGreenBlue);
    let mut renderer = CpuRenderer::from_captured_bitmaps(&bitmaps)
        .unwrap()
        .with_font_rasterization(neutral);
    assert_eq!(
        renderer
            .render_scene_to_image(&scene, size)
            .unwrap()
            .get_pixel(0, 0)
            .0,
        [255, 255, 255, 128],
        "neutral settings retain the captured 128/255 glyph coverage"
    );

    let corrected = FontRasterizationSettings::new(2.2, 0.0, 0.0, SubpixelOrder::RedGreenBlue);
    let mut renderer = CpuRenderer::from_captured_bitmaps(&bitmaps)
        .unwrap()
        .with_font_rasterization(corrected);
    let actual = renderer
        .render_scene_to_image(&scene, size)
        .unwrap()
        .get_pixel(0, 0)
        .0[3];
    assert!(
        (i16::from(actual) - 196).abs() <= 1,
        "gamma 2.2 should map half coverage to about 0.769 alpha (196/255), got {actual}"
    );
}

#[test]
fn subpixel_order_reverses_red_and_blue_coverage_channels() {
    use gpui::{
        AtlasTextureId, AtlasTextureKind, AtlasTile, CapturedBitmap, SubpixelSprite, TileId,
    };
    use gpui_ce_render::{
        cpu::CpuRenderer,
        font::{FontRasterizationSettings, SubpixelOrder},
    };

    let tile = AtlasTile {
        texture_id: AtlasTextureId {
            index: 0,
            kind: AtlasTextureKind::Subpixel,
        },
        tile_id: TileId(0),
        padding: 0,
        bounds: Bounds {
            origin: point(DevicePixels(0), DevicePixels(0)),
            size: Size {
                width: DevicePixels(1),
                height: DevicePixels(1),
            },
        },
    };
    let bitmap = CapturedBitmap {
        kind: AtlasTextureKind::Subpixel,
        width: 1,
        height: 1,
        // Captured subpixel tiles retain the native BGRA mask lane order, so this byte
        // sequence represents full red coverage and no blue coverage.
        bytes: vec![0, 0, 255, 255],
    };
    let mut scene = Scene::default();
    scene.insert_primitive(SubpixelSprite {
        order: 0,
        padding: 0,
        bounds: rect(0.0, 0.0, 1.0, 1.0),
        content_mask: ContentMask {
            bounds: rect(0.0, 0.0, 1.0, 1.0),
            ..Default::default()
        },
        color: Hsla::new(0.0, 0.0, 1.0, 1.0).into(),
        tile,
        transformation: Default::default(),
    });
    scene.finish();
    let bitmaps = [bitmap];
    let size = Size {
        width: DevicePixels(1),
        height: DevicePixels(1),
    };
    let render = |order| {
        let settings = FontRasterizationSettings::new(1.0, 0.0, 0.0, order);
        let mut renderer = CpuRenderer::from_captured_bitmaps(&bitmaps)
            .unwrap()
            .with_font_rasterization(settings);
        renderer
            .render_scene_to_image(&scene, size)
            .unwrap()
            .get_pixel(0, 0)
            .0
    };

    assert_eq!(
        render(SubpixelOrder::RedGreenBlue),
        [255, 0, 0, 255],
        "RGB panel order maps the first coverage lane to red"
    );
    assert_eq!(
        render(SubpixelOrder::BlueGreenRed),
        [0, 0, 255, 255],
        "BGR panel order reverses red and blue coverage lanes"
    );
}

#[test]
fn monochrome_glyph_samples_at_transformed_destination_coordinates() {
    use gpui::{
        AtlasTextureId, AtlasTextureKind, AtlasTile, CapturedBitmap, MonochromeSprite, TileId,
        TransformationMatrix,
    };
    use gpui_ce_render::cpu::{CpuAtlas, CpuRenderer};

    let bitmap = CapturedBitmap {
        kind: AtlasTextureKind::Monochrome,
        width: 2,
        height: 2,
        bytes: vec![255; 4],
    };
    let atlas = CpuAtlas::new();
    let tile = AtlasTile {
        texture_id: AtlasTextureId {
            index: 0,
            kind: AtlasTextureKind::Monochrome,
        },
        tile_id: TileId(0),
        padding: 0,
        bounds: Bounds {
            origin: point(DevicePixels(0), DevicePixels(0)),
            size: Size {
                width: DevicePixels(2),
                height: DevicePixels(2),
            },
        },
    };
    atlas.insert_captured(tile.texture_id, bitmap).unwrap();
    let glyph_bounds = rect(0.0, 0.0, 2.0, 2.0);
    let mut scene = Scene::default();
    scene.insert_primitive(MonochromeSprite {
        order: 0,
        padding: 0,
        bounds: glyph_bounds,
        content_mask: ContentMask {
            bounds: rect(0.0, 0.0, 4.0, 2.0),
            ..Default::default()
        },
        color: Hsla::new(0.0, 1.0, 0.5, 1.0).into(),
        tile,
        transformation: TransformationMatrix {
            rotation_scale: [[1.0, 0.0], [0.0, 1.0]],
            translation: [1.0, 0.0],
        },
    });
    scene.finish();
    let mut renderer = CpuRenderer::from_atlas(atlas.into());
    let image = renderer
        .render_scene_to_image(
            &scene,
            Size {
                width: DevicePixels(4),
                height: DevicePixels(2),
            },
        )
        .unwrap();
    assert_eq!(
        image.get_pixel(0, 0).0,
        [0, 0, 0, 0],
        "untransformed origin must remain clear"
    );
    assert_eq!(
        image.get_pixel(1, 0).0,
        [255, 0, 0, 255],
        "transformed glyph starts one pixel right"
    );
    assert_eq!(
        image.get_pixel(2, 1).0,
        [255, 0, 0, 255],
        "all glyph coverage follows the transform"
    );
    assert_eq!(
        image.get_pixel(3, 0).0,
        [0, 0, 0, 0],
        "glyph must not extend beyond transformed bounds"
    );
}
