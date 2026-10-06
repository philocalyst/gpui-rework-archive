#![cfg(feature = "cpu")]

use gpui::{
    AtlasTextureId, AtlasTextureKind, AtlasTile, Bounds, CapturedBitmap, ContentMask, DevicePixels,
    FilterBoundary, Path, Quad, ScaledFilter, ScaledPixels, Scene, SceneCapture, Size, TileId,
    TransformationMatrix, point, px,
};
use serde_json::{Value, json};

fn bounds() -> Bounds<ScaledPixels> {
    Bounds {
        origin: point(ScaledPixels(1.0), ScaledPixels(1.0)),
        size: Size {
            width: ScaledPixels(8.0),
            height: ScaledPixels(6.0),
        },
    }
}

fn quad_scene(count: usize) -> Scene {
    let mut scene = Scene::default();
    let bounds = bounds();
    for _ in 0..count {
        scene.insert_primitive(Quad {
            bounds,
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            ..Default::default()
        });
    }
    scene.finish();
    scene
}

fn filter_scene() -> Scene {
    let bounds = bounds();
    let make_boundary = |is_start| FilterBoundary {
        order: 0,
        bounds,
        content_mask: ContentMask {
            bounds,
            ..Default::default()
        },
        corner_radii: Default::default(),
        corner_smoothing: 0.0,
        filters: vec![ScaledFilter::Blur(ScaledPixels(1.0))]
            .into_iter()
            .collect(),
        opacity: 1.0,
        is_start,
    };
    let mut scene = Scene::default();
    scene.insert_primitive(make_boundary(true));
    scene.insert_primitive(make_boundary(false));
    scene.finish();
    scene
}

fn path_scene() -> Scene {
    let mut path = Path::new(point(px(1.0), px(1.0)));
    path.push_triangle(
        (
            point(px(1.0), px(1.0)),
            point(px(6.0), px(1.0)),
            point(px(1.0), px(6.0)),
        ),
        (point(0.0, 0.0), point(1.0, 0.0), point(0.0, 1.0)),
    );
    path.content_mask.bounds = path.bounds;
    let mut scene = Scene::default();
    scene.insert_primitive(path.scale(1.0));
    scene.finish();
    scene
}

fn capture_json(scene: &Scene) -> Value {
    serde_json::to_value(
        SceneCapture::capture(scene, |_| anyhow::bail!("unexpected atlas tile"))
            .expect("capture scene without sprites"),
    )
    .expect("serialize capture")
}

fn validate_json(value: Value) -> anyhow::Result<()> {
    let capture: SceneCapture = serde_json::from_value(value)?;
    capture.validate()
}

fn quad_command(start: usize, end: usize) -> Value {
    json!({
        "Batch": {
            "Quads": {
                "range": { "start": start, "end": end },
                "smoothed": false
            }
        }
    })
}

#[test]
fn rejects_overlapping_gapped_and_missing_primitive_ranges() {
    let source = capture_json(&quad_scene(2));

    let mut overlapping = source.clone();
    overlapping["commands"] = json!([quad_command(0, 1), quad_command(0, 1)]);
    assert!(validate_json(overlapping).is_err());

    let mut gapped = source.clone();
    gapped["commands"] = json!([quad_command(1, 2)]);
    assert!(validate_json(gapped).is_err());

    let mut missing = source;
    missing["commands"] = json!([]);
    assert!(validate_json(missing).is_err());
}

#[test]
fn rejects_path_vertex_tail_even_when_command_counts_match() {
    let mut capture = capture_json(&path_scene());
    let vertex = capture["paths"][0]["vertices"][0].clone();
    capture["paths"][0]["vertices"]
        .as_array_mut()
        .expect("serialized vertices are an array")
        .push(vertex);

    assert!(validate_json(capture).is_err());
}

#[test]
fn rejects_filter_target_mismatch_and_unnecessary_inline_target() {
    let source = capture_json(&filter_scene());

    let mut inline = source.clone();
    inline["commands"][0]["BeginFilter"]["target"] = json!("Inline");
    assert!(validate_json(inline).is_err());

    let mut mismatched_end = source;
    mismatched_end["commands"][1]["EndFilter"]["target"] = json!("Inline");
    assert!(validate_json(mismatched_end).is_err());
}

#[test]
fn rejects_version_mutation_and_non_finite_filter_encoding() {
    let source = capture_json(&filter_scene());

    let mut unsupported = source.clone();
    unsupported["version"] = json!(gpui::SCENE_CAPTURE_VERSION + 1);
    assert!(validate_json(unsupported).is_err());

    let mut non_finite = source;
    non_finite["filter_boundaries"][0]["opacity"] = Value::Null;
    assert!(serde_json::from_value::<SceneCapture>(non_finite).is_err());
}

#[test]
fn rejects_negative_blur_and_out_of_range_filter_opacity() {
    let source = capture_json(&filter_scene());

    let mut negative_blur = source.clone();
    negative_blur["filter_boundaries"][0]["filters"][0]["Blur"] = json!(-0.25);
    assert!(validate_json(negative_blur).is_err());

    let mut invalid_opacity = source;
    invalid_opacity["filter_boundaries"][0]["opacity"] = json!(1.25);
    assert!(validate_json(invalid_opacity).is_err());
}

#[test]
fn rejects_live_scene_atlas_mutation_after_finish() {
    let bounds = bounds();
    let tile = AtlasTile {
        texture_id: AtlasTextureId {
            index: 7,
            kind: AtlasTextureKind::Monochrome,
        },
        tile_id: TileId(3),
        padding: 0,
        bounds: Bounds {
            origin: point(DevicePixels(0), DevicePixels(0)),
            size: Size {
                width: DevicePixels(1),
                height: DevicePixels(1),
            },
        },
    };
    let mut scene = Scene::default();
    scene.insert_primitive(gpui::MonochromeSprite {
        order: 0,
        padding: 0,
        bounds,
        content_mask: ContentMask {
            bounds,
            ..Default::default()
        },
        color: Default::default(),
        tile,
        transformation: TransformationMatrix::unit(),
    });
    scene.finish();
    scene.monochrome_sprites[0].tile.texture_id.index += 1;

    let error = SceneCapture::capture(&scene, |_| {
        Ok(CapturedBitmap {
            kind: AtlasTextureKind::Monochrome,
            width: 1,
            height: 1,
            bytes: vec![255],
        })
    })
    .expect_err("stale cached command texture must be rejected");
    assert!(error.to_string().contains("texture"));
}
