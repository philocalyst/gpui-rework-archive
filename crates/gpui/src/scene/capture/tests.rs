use super::*;

fn test_bounds(x: f32) -> Bounds<ScaledPixels> {
    Bounds {
        origin: point(ScaledPixels(x), ScaledPixels(2.0)),
        size: Size {
            width: ScaledPixels(8.0),
            height: ScaledPixels(6.0),
        },
    }
}

#[test]
fn serializes_sorted_scene_arrays_and_preserves_commands() {
    let mut scene = Scene::default();
    let bounds = test_bounds(1.0);
    scene.insert_primitive(Quad {
        bounds,
        content_mask: ContentMask {
            bounds,
            ..Default::default()
        },
        ..Default::default()
    });
    scene.finish();

    let capture = SceneCapture::capture(&scene, |_| anyhow::bail!("unexpected tile"))
        .expect("capture quad scene");
    let json = serde_json::to_string(&capture).expect("serialize capture");
    let decoded: SceneCapture = serde_json::from_str(&json).expect("deserialize capture");
    let restored = decoded.into_scene().expect("restore scene");

    assert_eq!(restored.quads.len(), 1);
    assert_eq!(restored.quads[0].bounds, scene.quads[0].bounds);
    assert_eq!(restored.render_commands(), scene.render_commands());
}

#[test]
fn capture_equality_covers_roundtrip_geometry_commands_and_bitmap_bytes() {
    let bounds = test_bounds(1.0);
    let mut scene = Scene::default();
    scene.insert_primitive(Quad {
        bounds,
        content_mask: ContentMask {
            bounds,
            ..Default::default()
        },
        ..Default::default()
    });
    scene.insert_primitive(MonochromeSprite {
        order: 0,
        padding: 0,
        bounds,
        content_mask: ContentMask {
            bounds,
            ..Default::default()
        },
        color: SceneHsla::default(),
        tile: AtlasTile {
            texture_id: AtlasTextureId {
                index: 17,
                kind: AtlasTextureKind::Monochrome,
            },
            tile_id: TileId(23),
            padding: 0,
            bounds: Bounds {
                origin: point(DevicePixels(0), DevicePixels(0)),
                size: Size {
                    width: DevicePixels(2),
                    height: DevicePixels(2),
                },
            },
        },
        transformation: TransformationMatrix::unit(),
    });
    scene.finish();

    let capture = SceneCapture::capture(&scene, |tile| {
        Ok(CapturedBitmap {
            kind: tile.texture_id.kind,
            width: 2,
            height: 2,
            bytes: vec![255; 4],
        })
    })
    .expect("capture scene");
    let json = serde_json::to_string(&capture).expect("serialize capture");
    let decoded: SceneCapture = serde_json::from_str(&json).expect("deserialize capture");
    assert_eq!(capture, decoded);

    let mut changed_geometry = capture.clone();
    changed_geometry.quads[0].bounds.origin.x.0 += 1.0;
    assert_ne!(capture, changed_geometry);

    let mut changed_commands = capture.clone();
    match &mut changed_commands.commands[0] {
        RenderCommand::Batch(PrimitiveBatch::Quads { smoothed, .. }) => *smoothed = !*smoothed,
        command => panic!("expected first command to be a quad batch, got {command:?}"),
    }
    assert_ne!(capture, changed_commands);

    let mut changed_bitmap = capture.clone();
    changed_bitmap.bitmaps[0].bytes[0] ^= 1;
    assert_ne!(capture, changed_bitmap);
}

#[test]
fn canonicalizes_tile_pixels_and_texture_ids() {
    let source_texture = AtlasTextureId {
        index: 91,
        kind: AtlasTextureKind::Monochrome,
    };
    let source_tile = AtlasTile {
        texture_id: source_texture,
        tile_id: TileId(420),
        padding: 2,
        bounds: Bounds {
            origin: point(DevicePixels(8), DevicePixels(10)),
            size: Size {
                width: DevicePixels(2),
                height: DevicePixels(2),
            },
        },
    };
    let bounds = test_bounds(1.0);
    let sprite = MonochromeSprite {
        order: 0,
        padding: 0,
        bounds,
        content_mask: ContentMask {
            bounds,
            ..Default::default()
        },
        color: SceneHsla::default(),
        tile: source_tile,
        transformation: TransformationMatrix::unit(),
    };
    let mut scene = Scene::default();
    scene.insert_primitive(sprite);
    scene.finish();

    let capture = SceneCapture::capture(&scene, |tile| {
        assert_eq!(tile, source_tile);
        Ok(CapturedBitmap {
            kind: AtlasTextureKind::Monochrome,
            width: 2,
            height: 2,
            bytes: vec![1, 2, 3, 4],
        })
    })
    .expect("capture sprite scene");
    let restored = capture.to_scene().expect("restore sprite scene");
    let tile = restored.monochrome_sprites[0].tile;
    assert_eq!(tile.texture_id.index, 0);
    assert_eq!(tile.tile_id, TileId(0));
    assert_eq!(tile.padding, 0);
    assert_eq!(tile.bounds.origin, point(DevicePixels(0), DevicePixels(0)));
    assert_eq!(capture.bitmaps()[0].bytes, [1, 2, 3, 4]);
}

#[test]
fn rejects_unsupported_versions_invalid_ranges_and_non_finite_values() {
    let mut scene = Scene::default();
    let bounds = test_bounds(1.0);
    scene.insert_primitive(Quad {
        bounds,
        content_mask: ContentMask {
            bounds,
            ..Default::default()
        },
        ..Default::default()
    });
    scene.finish();
    let mut capture = SceneCapture::capture(&scene, |_| anyhow::bail!("unexpected tile"))
        .expect("capture quad scene");

    let mut wrong_version = capture.clone();
    wrong_version.version += 1;
    assert!(
        wrong_version
            .into_scene()
            .err()
            .unwrap()
            .to_string()
            .contains("unsupported scene capture version")
    );

    capture.commands = vec![RenderCommand::Batch(PrimitiveBatch::Shadows {
        range: 0..1,
        smoothed: false,
    })];
    assert!(
        capture
            .into_scene()
            .err()
            .unwrap()
            .to_string()
            .contains("does not match compiled scene")
    );

    let mut invalid_scene = Scene::default();
    let mut invalid_quad = Quad::default();
    invalid_quad.corner_smoothing = f32::NAN;
    invalid_quad.bounds = bounds;
    invalid_quad.content_mask.bounds = bounds;
    invalid_scene.insert_primitive(invalid_quad);
    invalid_scene.finish();
    assert!(
        SceneCapture::capture(&invalid_scene, |_| anyhow::bail!("unexpected tile"))
            .unwrap_err()
            .to_string()
            .contains("non-finite")
    );
}
