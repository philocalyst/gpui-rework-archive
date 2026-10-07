//! Example Prelude
//!
//! Common helpers for GPUI examples. Import with:
//!
//! ```ignore
//! #[path = "../shared/prelude.rs"]
//! mod example_prelude;
//! use example_prelude::run_example;
//! ```

// Examples import this file independently and use different subsets of its helpers.
#![allow(dead_code)]

use gpui::{
    App, Bounds, KeyBinding, Menu, MenuItem, Render, SharedString, WindowBounds, WindowOptions,
    actions, px, size,
};
use gpui_test::Scenario;
#[cfg(not(target_family = "wasm"))]
use gpui_test::{Harness, RenderedSuite, ReportOptions, write_report};
use std::sync::Arc;
#[cfg(not(target_family = "wasm"))]
use std::{env, path::PathBuf};

actions!(example, [Quit, CloseWindow]);

/// Adds the standard application menu, fonts, and close behavior to a native lesson.
pub fn init_example(cx: &mut App, name: impl Into<SharedString>) {
    #[cfg(not(target_family = "wasm"))]
    cx.text_system()
        .add_fonts(gpui_test::bundled_fonts())
        .expect("register bundled example fonts");

    cx.activate(true);

    cx.on_action(|_: &Quit, cx| cx.quit());
    cx.bind_keys([KeyBinding::new("cmd-q", Quit, None)]);

    cx.set_menus(vec![Menu {
        name: name.into(),
        items: vec![MenuItem::action("Quit", Quit)],
        disabled: false,
    }]);

    // Quit the app when all windows are closed
    cx.on_window_closed(|cx, _| {
        if cx.windows().is_empty() {
            cx.quit();
        }
    })
    .detach();
}

/// Build the standard centered, windowed options used by most visual examples.
/// Callers that demonstrate native window controls can start from this value and refine it.
pub fn centered_window(width: f32, height: f32, cx: &App) -> WindowOptions {
    let bounds = Bounds::centered(None, size(px(width), px(height)), cx);
    WindowOptions::new().window_bounds(Some(WindowBounds::Windowed(bounds)))
}

/// Runs the same typed view natively by default, or writes a CPU-only visual report with
/// `--capture [--output DIR] [--samples N] [--baseline DIR]`.
pub fn run_example<V: Render + 'static>(scenario: Scenario<V>) -> anyhow::Result<()> {
    run_example_with_assets(scenario, Arc::new(()))
}

/// Runs an example with bundled resources shared by native rendering and headless captures.
pub fn run_example_with_assets<V: Render + 'static>(
    scenario: Scenario<V>,
    assets: Arc<dyn gpui::AssetSource>,
) -> anyhow::Result<()> {
    #[cfg(not(target_family = "wasm"))]
    {
        let _ = env_logger::try_init();
        if let Some(options) = capture_options(&scenario)? {
            let harness = Harness::new()
                .with_asset_source(assets.clone())
                .timing_samples(options.samples)?;
            let rendered = harness.run(&scenario)?;
            let suite = RenderedSuite::new(vec![rendered]);
            let manifest = write_report(
                &suite,
                &options.output,
                ReportOptions {
                    baseline_dir: options.baseline,
                    selected_ids: vec![scenario.id().to_owned()],
                },
            )?;
            println!(
                "captured {}: {}",
                scenario.title(),
                options.output.display()
            );
            if !manifest.changes.is_empty() {
                println!("{} baseline change(s)", manifest.changes.len());
            }
            return Ok(());
        }
    }

    gpui_platform::application()
        .with_assets(assets)
        .run(move |cx: &mut App| {
            let options = WindowOptions::new();
            scenario
                .open_window(cx, options)
                .expect("open example window");
            init_example(cx, scenario.title());
        });
    Ok(())
}

#[cfg(not(target_family = "wasm"))]
struct CaptureOptions {
    output: PathBuf,
    baseline: Option<PathBuf>,
    samples: usize,
}

#[cfg(not(target_family = "wasm"))]
fn capture_options<V: Render + 'static>(
    scenario: &Scenario<V>,
) -> anyhow::Result<Option<CaptureOptions>> {
    let args: Vec<_> = env::args().skip(1).collect();
    if !args.iter().any(|arg| arg == "--capture") {
        return Ok(None);
    }
    let mut output = PathBuf::from(format!("target/gpui-examples/{}", scenario.id()));
    let mut baseline = None;
    let mut samples = 1;
    let mut index = 0;
    while index < args.len() {
        let arg = &args[index];
        if arg == "--capture" {
            index += 1;
            continue;
        }
        index += 1;
        let value = args
            .get(index)
            .ok_or_else(|| anyhow::anyhow!("{arg} requires a value"))?;
        match arg.as_str() {
            "--output" => output = PathBuf::from(value),
            "--baseline" => baseline = Some(PathBuf::from(value)),
            "--samples" => samples = value.parse()?,
            _ => anyhow::bail!("unknown capture option {arg:?}"),
        }
        index += 1;
    }
    anyhow::ensure!(samples > 0, "--samples must be positive");
    Ok(Some(CaptureOptions {
        output,
        baseline,
        samples,
    }))
}
