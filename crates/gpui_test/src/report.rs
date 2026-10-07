//! Portable report schema, streaming writer, comparison, and artifact IO.
mod views;
use views::{write_html, write_markdown, write_svg};

use crate::image_diff::{
    DiffMode, MotionDifference, compare_images, compare_transition_images, compare_transitions,
};
use crate::{
    ImageDifference, NativeReplayInfo, NativeReplayMetrics, RenderedCheckpoint, RenderedScenario,
    RenderedSuite, ScenarioMetrics, Viewport, validate_id,
};
use anyhow::{Context, Result, ensure};
use flate2::{Compression, GzBuilder, read::MultiGzDecoder};
use serde::{Deserialize, Serialize};
use std::{
    collections::{BTreeMap, BTreeSet, HashSet},
    fs,
    io::{Read, Write},
    path::{Component, Path, PathBuf},
};
use tempfile::TempDir;

const MAX_COMPRESSED_SCENE_BYTES: u64 = 12 * 1024 * 1024;
const MAX_DECOMPRESSED_SCENE_BYTES: usize = 12 * 1024 * 1024;
const MAX_MANIFEST_BYTES: u64 = 12 * 1024 * 1024;

mod comparison;
mod manifest;
mod reader;
mod storage;
mod writer;

use comparison::compare_manifests;
pub use comparison::{compare_reports, compare_reports_selected, diff_images};
pub use manifest::*;
pub use reader::{collect_reports, read_manifest, read_report};
use reader::{
    identical_stored_scenarios, merge_optional_report_value, read_scenario, scenarios_equal,
};
use storage::*;
pub use writer::{ReportWriter, write_report};

#[cfg(test)]
mod tests {
    use super::diff_images;
    use image::{Rgba, RgbaImage};

    #[test]
    fn exact_diff_keeps_context_and_marks_transparent_resize_regions() {
        let before = RgbaImage::from_pixel(2, 1, Rgba([90, 120, 150, 255]));
        let mut current = RgbaImage::new(3, 1);
        current.put_pixel(0, 0, before[(0, 0)]);
        current.put_pixel(1, 0, Rgba([91, 120, 150, 255]));
        let diff = diff_images(&before, &current);
        assert_eq!(diff[(0, 0)], before[(0, 0)], "unchanged context");
        assert_eq!(diff[(1, 0)], Rgba([255, 32, 32, 255]), "one-channel change");
        assert_eq!(
            diff[(2, 0)],
            Rgba([255, 32, 32, 255]),
            "new transparent area"
        );
        assert_eq!(
            diff_images(&current, &before)[(2, 0)],
            diff[(2, 0)],
            "removed transparent area"
        );
    }
}
