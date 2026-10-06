use anyhow::Result;
use gpui_test::{Harness, built_in_scenarios};

#[test]
fn built_in_scenarios_match_reviewed_scene_and_pixel_fingerprints() -> Result<()> {
    let harness = Harness::new();
    for scenario in built_in_scenarios()? {
        for (name, snapshot) in scenario.run(&harness)?.snapshots()? {
            insta::assert_snapshot!(name, snapshot);
        }
    }
    Ok(())
}
