use anyhow::{Context, Result};
use gpui::{CapturedBitmap, SceneCapture};
use gpui_test::{Harness, built_in_scenarios};
use serde_json::{Value, json};
use sha2::{Digest, Sha256};

fn sha256(bytes: &[u8]) -> String {
    Sha256::digest(bytes)
        .iter()
        .map(|byte| format!("{byte:02x}"))
        .collect()
}

fn color(value: &Value) -> Value {
    json!([value["h"], value["s"], value["l"], value["a"]])
}

fn rect(value: &Value) -> Value {
    json!([
        value["origin"]["x"],
        value["origin"]["y"],
        value["size"]["width"],
        value["size"]["height"],
    ])
}

fn mask(value: &Value) -> Value {
    json!([
        rect(&value["bounds"]),
        value["fade_out"]["top"],
        value["fade_out"]["right"],
        value["fade_out"]["bottom"],
        value["fade_out"]["left"],
    ])
}

fn paint(value: &Value) -> Value {
    let colors = value["colors"]
        .as_array()
        .into_iter()
        .flatten()
        .map(|stop| json!([color(&stop["color"]), stop["percentage"]]))
        .collect::<Vec<_>>();
    json!([
        value["tag"],
        value["color_space"],
        color(&value["solid"]),
        value["gradient_angle_or_pattern_height"],
        colors,
        value["padding"],
    ])
}

fn sprite(value: &Value) -> Value {
    json!([
        value["order"],
        rect(&value["bounds"]),
        mask(&value["content_mask"]),
        value["padding"],
        color(&value["color"]),
        [
            value["tile"]["texture_id"]["index"],
            value["tile"]["texture_id"]["kind"],
            value["tile"]["tile_id"],
            rect(&value["tile"]["bounds"]),
        ],
        [
            value["transformation"]["rotation_scale"][0][0],
            value["transformation"]["rotation_scale"][0][1],
            value["transformation"]["rotation_scale"][1][0],
            value["transformation"]["rotation_scale"][1][1],
            value["transformation"]["translation"][0],
            value["transformation"]["translation"][1],
        ],
    ])
}

fn bitmap(bitmap: &CapturedBitmap) -> Value {
    json!([
        bitmap.kind,
        bitmap.width,
        bitmap.height,
        bitmap.bytes.len(),
        sha256(&bitmap.bytes),
    ])
}

fn scene_summary(capture: &SceneCapture) -> Result<Value> {
    let raw = serde_json::to_value(capture)?;
    let mut normalized = raw.clone();
    let normalized_bitmaps = normalized["bitmaps"]
        .as_array_mut()
        .context("SceneCapture serializes its bitmap table")?;
    assert_eq!(normalized_bitmaps.len(), capture.bitmaps().len());
    for (serialized, bitmap) in normalized_bitmaps.iter_mut().zip(capture.bitmaps()) {
        *serialized = json!({
            "kind": bitmap.kind,
            "width": bitmap.width,
            "height": bitmap.height,
            "byte_len": bitmap.bytes.len(),
            "sha256": sha256(&bitmap.bytes),
        });
    }
    let normalized_capture_sha256 = sha256(&serde_json::to_vec(&normalized)?);
    let quads = raw["quads"]
        .as_array()
        .into_iter()
        .flatten()
        .map(|quad| {
            json!([
                quad["order"],
                rect(&quad["bounds"]),
                mask(&quad["content_mask"]),
                paint(&quad["background"]),
                paint(&quad["border_color"]),
                [
                    quad["corner_radii"]["top_left"],
                    quad["corner_radii"]["top_right"],
                    quad["corner_radii"]["bottom_right"],
                    quad["corner_radii"]["bottom_left"],
                ],
                [
                    quad["border_widths"]["top"],
                    quad["border_widths"]["right"],
                    quad["border_widths"]["bottom"],
                    quad["border_widths"]["left"],
                ],
                quad["border_style"],
                quad["corner_smoothing"],
            ])
        })
        .collect::<Vec<_>>();
    let paths = raw["paths"]
        .as_array()
        .into_iter()
        .flatten()
        .map(|path| {
            let vertices = path["vertices"]
                .as_array()
                .into_iter()
                .flatten()
                .map(|vertex| {
                    json!([
                        vertex["xy_position"]["x"],
                        vertex["xy_position"]["y"],
                        vertex["st_position"]["x"],
                        vertex["st_position"]["y"],
                    ])
                })
                .collect::<Vec<_>>();
            json!([
                path["id"],
                path["order"],
                rect(&path["bounds"]),
                mask(&path["content_mask"]),
                paint(&path["color"]),
                [path["start"]["x"], path["start"]["y"]],
                [path["current"]["x"], path["current"]["y"]],
                path["contour_count"],
                vertices,
            ])
        })
        .collect::<Vec<_>>();
    let underlines = raw["underlines"]
        .as_array()
        .into_iter()
        .flatten()
        .map(|underline| {
            json!([
                underline["order"],
                rect(&underline["bounds"]),
                mask(&underline["content_mask"]),
                color(&underline["color"]),
                underline["thickness"],
                underline["wavy"],
            ])
        })
        .collect::<Vec<_>>();
    let shadows = raw["shadows"]
        .as_array()
        .into_iter()
        .flatten()
        .map(|shadow| {
            json!([
                shadow["order"],
                shadow["blur_radius"],
                rect(&shadow["bounds"]),
                [
                    shadow["corner_radii"]["top_left"],
                    shadow["corner_radii"]["top_right"],
                    shadow["corner_radii"]["bottom_right"],
                    shadow["corner_radii"]["bottom_left"],
                ],
                mask(&shadow["content_mask"]),
                paint(&shadow["color"]),
                rect(&shadow["element_bounds"]),
                [
                    shadow["element_corner_radii"]["top_left"],
                    shadow["element_corner_radii"]["top_right"],
                    shadow["element_corner_radii"]["bottom_right"],
                    shadow["element_corner_radii"]["bottom_left"],
                ],
                shadow["inset"],
                shadow["corner_smoothing"],
            ])
        })
        .collect::<Vec<_>>();
    let filters = |key: &str| {
        raw[key]
            .as_array()
            .into_iter()
            .flatten()
            .map(|item| {
                json!([
                    item["order"],
                    rect(&item["bounds"]),
                    mask(&item["content_mask"]),
                    [
                        item["corner_radii"]["top_left"],
                        item["corner_radii"]["top_right"],
                        item["corner_radii"]["bottom_right"],
                        item["corner_radii"]["bottom_left"],
                    ],
                    item["corner_smoothing"],
                    item["filters"],
                    item["opacity"],
                    item["is_start"],
                ])
            })
            .collect::<Vec<_>>()
    };
    let sprite_rows = |key: &str| {
        raw[key]
            .as_array()
            .into_iter()
            .flatten()
            .map(sprite)
            .collect::<Vec<_>>()
    };
    Ok(json!({
        "version": raw["version"],
        "normalized_capture_sha256": normalized_capture_sha256,
        "commands": raw["commands"],
        "shadows": shadows,
        "quads": quads,
        "paths": paths,
        "underlines": underlines,
        "monochrome_sprites": sprite_rows("monochrome_sprites"),
        "subpixel_sprites": sprite_rows("subpixel_sprites"),
        "polychrome_sprites": sprite_rows("polychrome_sprites"),
        "backdrop_filters": filters("backdrop_filters"),
        "filter_boundaries": filters("filter_boundaries"),
        "bitmaps": capture.bitmaps().iter().map(bitmap).collect::<Vec<_>>(),
    }))
}

fn checkpoint_snapshots() -> Result<Vec<(String, String)>> {
    let harness = Harness::new();
    let mut snapshots = Vec::new();
    for scenario in built_in_scenarios()? {
        let rendered = scenario.run(&harness)?;
        for checkpoint in rendered.checkpoints {
            let image_size = [checkpoint.image.width(), checkpoint.image.height()];
            let image_fingerprint = sha256(checkpoint.image.as_raw());
            let capture = scene_summary(&checkpoint.capture)?;
            let snapshot = json!({
                "scenario": {
                    "id": rendered.id,
                    "title": rendered.title,
                    "viewport": rendered.viewport,
                },
                "checkpoint": {
                    "id": checkpoint.id,
                    "name": checkpoint.name,
                    "time_ns": checkpoint.time_ns,
                },
                "image": {
                "width": image_size[0],
                "height": image_size[1],
                "rgba_sha256": image_fingerprint,
            },
            "capture": capture,
            });
            snapshots.push((
                format!("{}-{}", rendered.id, checkpoint.id),
                compact_snapshot(&snapshot)?,
            ));
        }
    }
    Ok(snapshots)
}

fn compact_snapshot(snapshot: &Value) -> Result<String> {
    let mut lines = vec![
        format!(
            "scenario\t{}",
            serde_json::to_string(&snapshot["scenario"])?
        ),
        format!(
            "checkpoint\t{}",
            serde_json::to_string(&snapshot["checkpoint"])?
        ),
        format!("image\t{}", serde_json::to_string(&snapshot["image"])?),
    ];
    let capture = &snapshot["capture"];
    lines.push(format!(
        "capture\tversion={}\tsha256={}",
        capture["version"], capture["normalized_capture_sha256"]
    ));
    for kind in [
        "commands",
        "shadows",
        "quads",
        "paths",
        "underlines",
        "monochrome_sprites",
        "subpixel_sprites",
        "polychrome_sprites",
        "backdrop_filters",
        "filter_boundaries",
        "bitmaps",
    ] {
        for row in capture[kind].as_array().into_iter().flatten() {
            lines.push(format!("{kind}\t{}", serde_json::to_string(row)?));
        }
    }
    Ok(lines.join("\n"))
}

#[test]
fn built_in_scenarios_match_reviewed_scene_and_pixel_fingerprints() -> Result<()> {
    for (name, snapshot) in checkpoint_snapshots()? {
        insta::assert_snapshot!(name, snapshot);
    }
    Ok(())
}
