#![cfg(feature = "cpu")]

use gpui::{
    AtlasTextureId, AtlasTextureKind, AtlasTile, Bounds, CapturedBitmap, ContentMask, DevicePixels,
    FilterBoundary, Path, Quad, ScaledFilter, ScaledPixels, Scene, SceneCapture, Size, TileId,
    TransformationMatrix, point, px,
};
use serde_json::{Value, json};

#[test]
fn live_capture_and_embedding_preserve_sprite_and_filter_pixels() {
    use gpui::{MonochromeSprite, SceneAtlas, SceneResources, prelude::*, size};
    use gpui_ce_render::cpu::render_scene_to_image;
    use std::sync::Arc;
    let atlas = Arc::new(SceneAtlas::new());
    for (index, bytes) in [(99, vec![128; 16]), (41, vec![255; 16])] {
        atlas
            .insert_captured(
                AtlasTextureId {
                    index,
                    kind: AtlasTextureKind::Monochrome,
                },
                CapturedBitmap {
                    kind: AtlasTextureKind::Monochrome,
                    width: 4,
                    height: 4,
                    bytes,
                },
            )
            .unwrap();
    }
    let clip = ContentMask {
        bounds: Bounds::new(
            point(ScaledPixels(0.), ScaledPixels(0.)),
            size(ScaledPixels(32.), ScaledPixels(16.)),
        ),
        ..Default::default()
    };
    let boundary = |is_start| FilterBoundary {
        order: 0,
        bounds: clip.bounds,
        content_mask: clip,
        corner_radii: Default::default(),
        corner_smoothing: 0.,
        filters: vec![ScaledFilter::Blur(ScaledPixels(0.5))]
            .into_iter()
            .collect(),
        opacity: 0.8,
        is_start,
    };
    let mut scene = Scene::default();
    scene.insert_primitive(boundary(true));
    for (x, index, color) in [(1., 99, 0xff0000), (11., 41, 0x00ff00), (21., 99, 0x0000ff)] {
        scene.insert_primitive(MonochromeSprite {
            order: 0,
            padding: 0,
            bounds: Bounds::new(
                point(ScaledPixels(x), ScaledPixels(4.)),
                size(ScaledPixels(4.), ScaledPixels(4.)),
            ),
            content_mask: clip,
            color: gpui::rgb_to_hsla(gpui::rgb(color)).into(),
            transformation: TransformationMatrix::unit(),
            tile: AtlasTile {
                texture_id: AtlasTextureId {
                    index,
                    kind: AtlasTextureKind::Monochrome,
                },
                tile_id: TileId(0),
                padding: 0,
                bounds: Bounds::new(
                    point(DevicePixels(0), DevicePixels(0)),
                    size(DevicePixels(4), DevicePixels(4)),
                ),
            },
        });
    }
    scene.insert_primitive(boundary(false));
    scene.finish();
    let dimensions = size(DevicePixels(32), DevicePixels(16));
    let original = render_scene_to_image(&scene, dimensions, &atlas).unwrap();
    for capture in [
        SceneCapture::capture_live(&scene, |tile| atlas.resolve(tile)).unwrap(),
        SceneCapture::capture(&scene, |tile| atlas.resolve(tile)).unwrap(),
    ] {
        let replay = capture.to_scene().unwrap();
        let replay_atlas = SceneAtlas::from_captured_bitmaps(capture.bitmaps()).unwrap();
        assert_eq!(
            original,
            render_scene_to_image(&replay, dimensions, &replay_atlas).unwrap()
        );
        struct Replay {
            capture: Arc<SceneCapture>,
            resources: SceneResources,
            imported: Option<Arc<gpui::ImportedScene>>,
        }
        impl gpui::Render for Replay {
            fn render(
                &mut self,
                window: &mut gpui::Window,
                _: &mut gpui::Context<Self>,
            ) -> impl gpui::IntoElement {
                let imported = Arc::new(
                    window
                        .import_scene_capture(&self.capture, &mut self.resources)
                        .unwrap(),
                );
                self.imported = Some(imported.clone());
                gpui::canvas(
                    |_, _, _| (),
                    move |bounds, _, window, _| {
                        window.paint_scene(&imported, bounds, 1.).unwrap();
                    },
                )
                .size_full()
            }
        }
        let host_atlas = Arc::new(SceneAtlas::new());
        let renderer_atlas = host_atlas.clone();
        let mut app = gpui::HeadlessAppContext::with_platform(
            Arc::new(gpui::TestTextSystem),
            Arc::new(()),
            move || {
                Some(Box::new(gpui_ce_render::cpu::CpuRenderer::from_atlas(
                    renderer_atlas.clone(),
                )))
            },
        );
        let window = app
            .open_window_with_scale_factor(size(px(32.), px(16.)), 1., |_, cx| {
                cx.new(|_| Replay {
                    capture: Arc::new(capture),
                    resources: Default::default(),
                    imported: None,
                })
            })
            .unwrap();
        let embedded = app
            .read_scene(window.into(), |scene| {
                render_scene_to_image(scene, dimensions, &host_atlas)
            })
            .unwrap()
            .unwrap();
        assert_eq!(
            original, embedded,
            "embedding must preserve actual renderer output"
        );
    }
}

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
fn rejects_pipeline_flags_and_batch_order_that_disagree_with_primitives() {
    let mut wrong_pipeline = capture_json(&quad_scene(1));
    wrong_pipeline["commands"][0]["Batch"]["Quads"]["smoothed"] = json!(true);
    let error = validate_json(wrong_pipeline).expect_err("pipeline flag must match the quad");
    assert!(error.to_string().contains("command 0"));

    let mut wrong_order = capture_json(&filter_scene());
    wrong_order["commands"].as_array_mut().unwrap().reverse();
    assert!(
        validate_json(wrong_order).is_err(),
        "end cannot precede begin"
    );
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
