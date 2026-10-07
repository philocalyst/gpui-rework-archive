use anyhow::Result;
use gpui_test::{Harness, built_in_scenarios};

#[test]
fn built_in_scenarios_match_reviewed_scene_and_pixel_fingerprints() -> Result<()> {
    let harness = Harness::new();
    let suite = harness.run_all(&built_in_scenarios()?)?;
    for scenario in suite.scenarios {
        for (name, snapshot) in scenario.snapshots()? {
            insta::assert_snapshot!(name, snapshot);
        }
    }
    Ok(())
}
