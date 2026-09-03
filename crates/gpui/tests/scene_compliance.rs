//! Renderer compliance matrix for the canonical scene archive.
//!
//! Sudo-rs style: this file pins ONE corpus of tiny scenes and runs the same assertions for every
//! renderer under test, selected by `GPUI_RENDERER_UNDER_TEST` (`wgpu` by default, `software`
//! reserved for a future CPU raster backend). Both values resolve to the same hermetic, CPU-only
//! lowering today, so a passing run proves the scene contract is renderer-independent, not
//! theater. There is no `#[cfg]` gating per backend: the corpus is identical everywhere.
//!
//! Every scene is asserted for:
//!   (a) `SceneArchive::from_scene` succeeds (no panic, no GPU/font/network state),
//!   (b) `to_canonical_json` is byte-stable across two independent builds (determinism),
//!   (c) `Scene::requires_offscreen_rendering` matches the expected flag,
//!   (d) a plan-vs-archive cross-check: per-kind primitive counts derived from the compiled
//!       `ScenePlan` must equal the archive's command stream, including the filter isolation
//!       targets the plan assigned and the requirement totals it reported. The archive is the
//!       *same* source of truth the real renderers consume (`render_commands`), so this keeps
//!       the snapshot path honest rather than self-consistent by construction.
//!
//! `#[ignore = "ghXXXX"]` policy (sudo-rs style): no bare `#[ignore]` is allowed in this file. An
//! ignored test MUST (1) carry the tracked issue id, e.g. `#[ignore = "gh1234"]`, (2) name the
//! blocker it tracks in a comment, and (3) pass on the reference renderer
//! (`GPUI_RENDERER_UNDER_TEST=wgpu`, the default CPU path) before it may be skipped for any other
//! backend.
//!
//! Run under every backend: `GPUI_RENDERER_UNDER_TEST=wgpu` and `=software`; unknown values panic
//! with the supported list.

use std::{any::Any, collections::BTreeMap, panic::catch_unwind};

use gpui::{
    BackdropFilter, Bounds, ContentMask, Corners, FilterBoundary, FilterRenderTarget, Hsla,
    PrimitiveBatch, Quad, RenderCommand, ScaledFilter, ScaledPixels, Scene, SceneArchive,
    SceneHsla, ScenePlan, SerializableCommand, SerializableFilterTarget, ShaderBool, Shadow, Size,
    hsla, point, solid_background,
};
use smallvec::smallvec;

// ── Renderer-under-test selection ───────────────────────────────────────────────────────────────

const RENDERER_UNDER_TEST_ENV: &str = "GPUI_RENDERER_UNDER_TEST";
const SUPPORTED_RENDERERS: &[&str] = &["wgpu", "software"];

/// Returns the renderer this test run is standing in for.
///
/// Reads `GPUI_RENDERER_UNDER_TEST`, defaulting to `"wgpu"` (the reference backend, today a
/// CPU-only archive path) and panicking on any unknown value with the supported list. Both
/// supported values exercise the identical hermetic corpus, so CI runs the same binary under each.
pub fn renderer_under_test() -> &'static str {
    renderer_under_test_from(std::env::var(RENDERER_UNDER_TEST_ENV).ok().as_deref())
}

/// Pure parser for [`renderer_under_test`], kept free of env access so the unknown-value panic
/// can be unit-tested without ever leaving a hostile value in the process environment.
fn renderer_under_test_from(value: Option<&str>) -> &'static str {
    match value {
        None => "wgpu",
        Some("wgpu") => "wgpu",
        Some("software") => "software",
        Some(unknown) => panic!(
            "unsupported {RENDERER_UNDER_TEST_ENV} value {unknown:?}; supported renderers: {}",
            SUPPORTED_RENDERERS.join(", ")
        ),
    }
}

// ── Tiny local scene builders ────────────────────────────────────────────────────────────────────
// These deliberately duplicate the `scene_snapshots` builders instead of importing them, so the
// compliance corpus is independent of the snapshot corpus and can never rot in lockstep with it.

fn sp(value: f32) -> ScaledPixels {
    ScaledPixels(value)
}

fn bounds_at(x: f32, y: f32) -> Bounds<ScaledPixels> {
    Bounds {
        origin: point(sp(x), sp(y)),
        size: Size {
            width: sp(100.0),
            height: sp(100.0),
        },
    }
}

fn mask_at(x: f32, y: f32) -> ContentMask<ScaledPixels> {
    ContentMask {
        bounds: bounds_at(x, y),
    }
}

fn quad_at(x: f32, y: f32) -> Quad {
    Quad {
        bounds: bounds_at(x, y),
        content_mask: mask_at(x, y),
        ..Default::default()
    }
}

fn colored_quad_at(x: f32, y: f32, color: Hsla) -> Quad {
    Quad {
        background: solid_background(color),
        ..quad_at(x, y)
    }
}

fn shadow_at(x: f32, y: f32) -> Shadow {
    Shadow {
        order: 0,
        blur_radius: sp(4.0),
        bounds: bounds_at(x, y),
        corner_radii: Corners::default(),
        content_mask: mask_at(x, y),
        color: SceneHsla::from(hsla(0.0, 0.0, 0.0, 0.4)),
        element_bounds: bounds_at(x, y),
        element_corner_radii: Corners::default(),
        inset: ShaderBool::Disabled,
        padding: 0,
    }
}

fn backdrop_filter() -> BackdropFilter {
    BackdropFilter {
        bounds: bounds_at(0.0, 0.0),
        content_mask: mask_at(0.0, 0.0),
        corner_radii: Corners::default(),
        filters: smallvec![ScaledFilter::Blur(sp(8.0))],
        ..Default::default()
    }
}

fn boundary(is_start: bool) -> FilterBoundary {
    FilterBoundary {
        order: 0,
        bounds: bounds_at(0.0, 0.0),
        content_mask: mask_at(0.0, 0.0),
        corner_radii: Corners::default(),
        filters: smallvec![ScaledFilter::Blur(sp(8.0))],
        opacity: 1.0,
        is_start,
    }
}

fn empty_scene() -> Scene {
    let mut scene = Scene::default();
    scene.finish();
    scene
}

fn single_quad() -> Scene {
    let mut scene = Scene::default();
    scene.insert_primitive(colored_quad_at(10.25, 20.5, hsla(0.55, 0.8, 0.55, 1.0)));
    scene.finish();
    scene
}

fn nested_layers() -> Scene {
    let mut scene = Scene::default();
    scene.push_layer(bounds_at(0.0, 0.0));
    scene.insert_primitive(colored_quad_at(0.0, 0.0, hsla(0.3, 0.7, 0.5, 1.0)));
    scene.push_layer(bounds_at(10.0, 10.0));
    scene.insert_primitive(shadow_at(10.0, 10.0));
    scene.pop_layer();
    scene.pop_layer();
    scene.finish();
    scene
}

fn backdrop_offscreen() -> Scene {
    let mut scene = Scene::default();
    scene.insert_primitive(quad_at(0.0, 0.0));
    scene.insert_primitive(backdrop_filter());
    scene.finish();
    scene
}

fn content_filter_groups() -> Scene {
    let mut scene = Scene::default();
    scene.insert_primitive(boundary(true));
    scene.insert_primitive(colored_quad_at(0.0, 0.0, hsla(0.8, 0.6, 0.5, 1.0)));
    scene.insert_primitive(boundary(true));
    scene.insert_primitive(quad_at(10.0, 10.0));
    scene.insert_primitive(boundary(false));
    scene.insert_primitive(boundary(false));
    scene.finish();
    scene
}

// ── Plan-vs-archive cross-check helpers ──────────────────────────────────────────────────────────

/// Primitive kinds tracked by both the plan's batches and the archive's commands. Layer markers
/// are intentionally excluded — they live only in the archive.
#[derive(Clone, Copy, Debug, Eq, PartialEq, Ord, PartialOrd)]
enum PrimKind {
    BeginFilter,
    Shadow,
    Quad,
    Path,
    Underline,
    Monochrome,
    Subpixel,
    Polychrome,
    Surface,
    Backdrop,
    EndFilter,
    RawBoundary,
}

fn bump(counts: &mut BTreeMap<PrimKind, usize>, kind: PrimKind, amount: usize) {
    *counts.entry(kind).or_default() += amount;
}

/// Per-kind primitive totals from the compiled plan: every batch contributes its range length,
/// every filter marker one command.
fn plan_primitive_kind_counts(plan: &ScenePlan) -> BTreeMap<PrimKind, usize> {
    let mut counts = BTreeMap::new();
    for command in plan.commands() {
        match command {
            RenderCommand::Batch(batch) => match batch {
                PrimitiveBatch::Shadows(range) => bump(&mut counts, PrimKind::Shadow, range.len()),
                PrimitiveBatch::Quads(range) => bump(&mut counts, PrimKind::Quad, range.len()),
                PrimitiveBatch::Paths { range, .. } => {
                    bump(&mut counts, PrimKind::Path, range.len())
                }
                PrimitiveBatch::Underlines(range) => {
                    bump(&mut counts, PrimKind::Underline, range.len())
                }
                PrimitiveBatch::MonochromeSprites { range, .. } => {
                    bump(&mut counts, PrimKind::Monochrome, range.len())
                }
                PrimitiveBatch::SubpixelSprites { range, .. } => {
                    bump(&mut counts, PrimKind::Subpixel, range.len())
                }
                PrimitiveBatch::PolychromeSprites { range, .. } => {
                    bump(&mut counts, PrimKind::Polychrome, range.len())
                }
                PrimitiveBatch::Surfaces(range) => {
                    bump(&mut counts, PrimKind::Surface, range.len())
                }
                PrimitiveBatch::BackdropFilters(range) => {
                    bump(&mut counts, PrimKind::Backdrop, range.len())
                }
                PrimitiveBatch::FilterBoundary(_) => {
                    unreachable!("the plan compiles boundaries into BeginFilter/EndFilter commands")
                }
            },
            RenderCommand::BeginFilter { .. } => bump(&mut counts, PrimKind::BeginFilter, 1),
            RenderCommand::EndFilter { .. } => bump(&mut counts, PrimKind::EndFilter, 1),
        }
    }
    counts
}

/// Per-kind primitive totals from the archive, excluding the layer open/close markers that have
/// no plan equivalent.
fn archive_primitive_kind_counts(archive: &SceneArchive) -> BTreeMap<PrimKind, usize> {
    let mut counts = BTreeMap::new();
    for command in &archive.commands {
        let kind = match command {
            SerializableCommand::StartLayer(_) | SerializableCommand::EndLayer => continue,
            SerializableCommand::Shadow(_) => PrimKind::Shadow,
            SerializableCommand::Quad(_) => PrimKind::Quad,
            SerializableCommand::Path(_) => PrimKind::Path,
            SerializableCommand::Underline(_) => PrimKind::Underline,
            SerializableCommand::MonochromeSprite(_) => PrimKind::Monochrome,
            SerializableCommand::SubpixelSprite(_) => PrimKind::Subpixel,
            SerializableCommand::PolychromeSprite(_) => PrimKind::Polychrome,
            SerializableCommand::Surface(_) => PrimKind::Surface,
            SerializableCommand::BackdropFilter(_) => PrimKind::Backdrop,
            SerializableCommand::FilterBoundary(_) => PrimKind::RawBoundary,
            SerializableCommand::BeginFilter { .. } => PrimKind::BeginFilter,
            SerializableCommand::EndFilter { .. } => PrimKind::EndFilter,
        };
        bump(&mut counts, kind, 1);
    }
    counts
}

/// `(isolated begin, isolated end)` counts from the plan's filter commands.
fn plan_isolated_filter_commands(plan: &ScenePlan) -> (usize, usize) {
    let mut begin = 0;
    let mut end = 0;
    for command in plan.commands() {
        match command {
            RenderCommand::BeginFilter {
                target: FilterRenderTarget::Isolated(_),
                ..
            } => begin += 1,
            RenderCommand::EndFilter {
                target: FilterRenderTarget::Isolated(_),
                ..
            } => end += 1,
            _ => {}
        }
    }
    (begin, end)
}

/// `(isolated begin, isolated end)` counts from the archive's filter commands.
fn archive_isolated_filter_commands(archive: &SceneArchive) -> (usize, usize) {
    let mut begin = 0;
    let mut end = 0;
    for command in &archive.commands {
        match command {
            SerializableCommand::BeginFilter {
                target: SerializableFilterTarget::Isolated(_),
                ..
            } => begin += 1,
            SerializableCommand::EndFilter {
                target: SerializableFilterTarget::Isolated(_),
                ..
            } => end += 1,
            _ => {}
        }
    }
    (begin, end)
}

/// The number of distinct offscreen targets the archive's `BeginFilter` commands reference
/// (one past the highest isolated target index), mirroring `requirements().isolated_target_count`.
fn archive_isolated_target_count(archive: &SceneArchive) -> usize {
    let mut highest: Option<u32> = None;
    for command in &archive.commands {
        if let SerializableCommand::BeginFilter {
            target: SerializableFilterTarget::Isolated(index),
            ..
        } = command
        {
            highest = Some(highest.map_or(*index, |current| current.max(*index)));
        }
    }
    usize::try_from(highest.map_or(0, |index| index + 1)).expect("target index fits usize")
}

// ── Renderer-under-test selection tests ─────────────────────────────────────────────────────────

#[test]
fn renderer_env_parses_with_default_and_rejects_unknown_values() {
    // All env mutation is confined to this single test fn and happens before any other body
    // work. Sibling tests run on other threads, so the variable is never left on a value a
    // parallel reader could trip on: it is removed (→ default "wgpu") or set to a supported
    // renderer, and the unknown-value panic is exercised on the pure parser instead of the
    // process-global env.
    unsafe { std::env::remove_var(RENDERER_UNDER_TEST_ENV) };
    assert_eq!(renderer_under_test(), "wgpu");

    unsafe { std::env::set_var(RENDERER_UNDER_TEST_ENV, "wgpu") };
    assert_eq!(renderer_under_test(), "wgpu");

    unsafe { std::env::set_var(RENDERER_UNDER_TEST_ENV, "software") };
    assert_eq!(renderer_under_test(), "software");

    let panic = match catch_unwind(|| renderer_under_test_from(Some("bogus"))) {
        Err(payload) => payload,
        Ok(_) => panic!("unknown renderer value must panic"),
    };
    let message = panic_message(&panic);
    assert!(
        message.contains(RENDERER_UNDER_TEST_ENV),
        "panic names the env var: {message}"
    );
    assert!(
        message.contains("bogus"),
        "panic names the offending value: {message}"
    );
    for supported in SUPPORTED_RENDERERS {
        assert!(
            message.contains(supported),
            "panic lists supported renderer {supported}: {message}"
        );
    }

    // Restore a valid value so concurrent readers never observe the panic state.
    unsafe { std::env::set_var(RENDERER_UNDER_TEST_ENV, "wgpu") };
    assert_eq!(renderer_under_test(), "wgpu");
}

fn panic_message(panic: &Box<dyn Any + Send>) -> String {
    if let Some(message) = panic.downcast_ref::<String>() {
        message.clone()
    } else if let Some(message) = panic.downcast_ref::<&'static str>() {
        (*message).to_string()
    } else {
        "<non-string panic payload>".to_string()
    }
}

// ── Compliance matrix ────────────────────────────────────────────────────────────────────────────

struct ComplianceCase {
    name: &'static str,
    build: fn() -> Scene,
    requires_offscreen: bool,
}

fn compliance_cases() -> Vec<ComplianceCase> {
    vec![
        ComplianceCase {
            name: "empty_scene",
            build: empty_scene,
            requires_offscreen: false,
        },
        ComplianceCase {
            name: "single_quad",
            build: single_quad,
            requires_offscreen: false,
        },
        ComplianceCase {
            name: "nested_layers",
            build: nested_layers,
            requires_offscreen: false,
        },
        ComplianceCase {
            name: "backdrop_filter_offscreen",
            build: backdrop_offscreen,
            requires_offscreen: true,
        },
        ComplianceCase {
            name: "content_filter_groups",
            build: content_filter_groups,
            requires_offscreen: true,
        },
    ]
}

#[test]
fn archive_plan_and_offscreen_contract_hold_for_every_renderer() {
    let renderer = renderer_under_test();
    for case in compliance_cases() {
        let context = format!(
            "{case} under GPUI_RENDERER_UNDER_TEST={renderer}",
            case = case.name
        );

        let scene = (case.build)();
        let plan = scene.render_plan();
        let requirements = plan.requirements();

        // (a)+(b) `from_scene` succeeds, and the canonical JSON is byte-stable across two
        // independent builds.
        let first = SceneArchive::from_scene(&scene);
        let second = SceneArchive::from_scene(&(case.build)());
        assert_eq!(
            first.to_canonical_json(),
            second.to_canonical_json(),
            "{context}: canonical JSON drifted between independent builds"
        );

        // (c) the offscreen flag matches the plan's own target decision.
        assert_eq!(
            scene.requires_offscreen_rendering(),
            case.requires_offscreen,
            "{context}: offscreen-rendering requirement"
        );
        assert_eq!(
            requirements.uses_offscreen_target, case.requires_offscreen,
            "{context}: plan's uses_offscreen_target"
        );

        // (d) plan-vs-archive cross-check: per-kind primitive counts must agree exactly, so the
        // archive is a faithful projection of the plan the real renderers consume.
        let plan_kinds = plan_primitive_kind_counts(plan);
        let archive_kinds = archive_primitive_kind_counts(&first);
        assert_eq!(
            plan_kinds, archive_kinds,
            "{context}: plan/archive primitive counts diverged"
        );
        assert_eq!(
            requirements.command_count,
            plan.commands().len(),
            "{context}: requirements.command_count"
        );

        // Draw-call totals: every non-empty primitive batch emits one instance batch in the
        // plan's accounting; surface-like batches (surfaces, backdrops) track counts only.
        let draw_batches = plan
            .commands()
            .iter()
            .filter(|command| {
                matches!(
                    command,
                    RenderCommand::Batch(batch)
                        if !matches!(
                            batch,
                            PrimitiveBatch::BackdropFilters(_) | PrimitiveBatch::Surfaces(_)
                        )
                )
            })
            .count();
        assert_eq!(
            requirements.instance_batch_count, draw_batches,
            "{context}: requirements.instance_batch_count"
        );

        // Filter isolation is the plan's decision and must be mirrored 1:1 by the archive.
        let (plan_begin, plan_end) = plan_isolated_filter_commands(plan);
        let (archive_begin, archive_end) = archive_isolated_filter_commands(&first);
        assert_eq!(
            (plan_begin, plan_end),
            (archive_begin, archive_end),
            "{context}: isolated filter targets diverged"
        );
        assert_eq!(
            requirements.isolated_filter_count, plan_end,
            "{context}: requirements.isolated_filter_count"
        );
        assert_eq!(
            requirements.isolated_target_count,
            archive_isolated_target_count(&first),
            "{context}: requirements.isolated_target_count"
        );
    }
}
