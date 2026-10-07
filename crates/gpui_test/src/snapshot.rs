use crate::{RenderedCheckpoint, RenderedScenario};
use anyhow::{Context, Result};
use gpui::SceneCapture;
use serde_json::{Value, json};
use sha2::{Digest, Sha256};

fn sha256(bytes: &[u8]) -> String {
    Sha256::digest(bytes)
        .iter()
        .map(|byte| format!("{byte:02x}"))
        .collect()
}

fn scene_summary(capture: &SceneCapture) -> Result<Value> {
    let mut scene = serde_json::to_value(capture)?;
    let bitmaps = scene["bitmaps"]
        .as_array_mut()
        .context("SceneCapture serializes its bitmap table")?;
    for (serialized, bitmap) in bitmaps.iter_mut().zip(capture.bitmaps()) {
        *serialized = json!({
            "kind": bitmap.kind,
            "width": bitmap.width,
            "height": bitmap.height,
            "byte_len": bitmap.bytes.len(),
            "sha256": sha256(&bitmap.bytes),
        });
    }

    // Fingerprint every field, then show a small named sample of each array. This
    // keeps thousands of repeated glyphs/list rows out of reviews. Per-array hashes
    // identify the affected primitive kind; reports retain the complete scene JSON.
    let mut summary = json!({
        "version": capture.version(),
        "normalized_capture_sha256": sha256(&serde_json::to_vec(&scene)?),
    });
    for (kind, value) in scene.as_object().context("scene capture is an object")? {
        let Some(rows) = value.as_array() else {
            continue;
        };
        let mut sample: Vec<_> = rows.iter().take(3).cloned().collect();
        if rows.len() > 3 {
            sample.push(rows.last().unwrap().clone());
        }
        summary[kind] = json!({
            "count": rows.len(),
            "sha256": sha256(&serde_json::to_vec(rows)?),
            "sample": sample,
        });
    }
    Ok(summary)
}

fn checkpoint_snapshot(
    scenario: &RenderedScenario,
    checkpoint: &RenderedCheckpoint,
) -> Result<String> {
    let mut lines = vec![
        format!(
            "scenario\t{}",
            json!({
                "id": scenario.id,
                "title": scenario.title,
                "viewport": scenario.viewport,
            })
        ),
        format!(
            "checkpoint\t{}",
            json!({
                "id": checkpoint.id,
                "name": checkpoint.name,
                "time_ns": checkpoint.time_ns,
            })
        ),
        format!(
            "image\t{}",
            json!({
                "width": checkpoint.image.width(),
                "height": checkpoint.image.height(),
                "rgba_sha256": sha256(checkpoint.image.as_raw()),
            })
        ),
    ];
    let capture = scene_summary(&checkpoint.capture)?;
    lines.push(format!(
        "capture\tversion={}\tsha256={}",
        capture["version"], capture["normalized_capture_sha256"]
    ));
    for (kind, value) in capture.as_object().unwrap() {
        if value.is_object() {
            lines.push(format!("{kind}\t{value}"));
        }
    }
    Ok(lines.join("\n"))
}

impl RenderedScenario {
    /// Produces one compact Insta-ready snapshot per checkpoint.
    ///
    /// Timing samples are excluded. Every capture field and bitmap byte contributes
    /// to the fingerprints; bounded named samples keep large glyph/list scenes readable.
    /// Complete captures remain available through each checkpoint and report JSON.
    pub fn snapshots(&self) -> Result<Vec<(String, String)>> {
        self.checkpoints
            .iter()
            .map(|checkpoint| {
                Ok((
                    format!("{}-{}", self.id, checkpoint.id),
                    checkpoint_snapshot(self, checkpoint)?,
                ))
            })
            .collect()
    }
}
