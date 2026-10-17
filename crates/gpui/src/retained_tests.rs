//! Behavioral tests and a manual workload for retained view rendering.
//!
//! These tests deliberately exercise retained output through GPUI's public render paths. The
//! oracle is `Window::refresh`, which redraws the same logical state with retention disabled.

use crate::{
    AnyWindowHandle, App, AppContext as _, Bounds, Context, DevicePixels, Element, ElementId,
    ElementInputHandler, Entity, EntityInputHandler, FocusHandle, Global, GlobalElementId,
    ImageCache, ImageCacheError, InteractiveElement as _, IntoElement, LayoutDirection, LayoutId,
    Modifiers, MouseButton, ParentElement as _, Pixels, Render, RenderImage, Resource,
    StatefulInteractiveElement as _, Style, StyleRefinement, Styled as _, SurfaceSource,
    TestAppContext, TextInputAction, TextInputConfiguration, UTF16Selection, View, ViewElement,
    VisualTestContext, Window, WindowHandle, canvas, deferred, div, fill, img, point, px, rems,
    rgb, size,
};
use std::{
    cell::RefCell,
    ops::Range,
    rc::Rc,
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    },
};

struct OracleImageCache {
    image: Arc<RenderImage>,
    loads: Arc<AtomicUsize>,
}

impl ImageCache for OracleImageCache {
    fn load(
        &mut self,
        _resource: &Resource,
        _window: &mut Window,
        _cx: &mut App,
    ) -> Option<Result<Arc<RenderImage>, ImageCacheError>> {
        self.loads.fetch_add(1, Ordering::Relaxed);
        Some(Ok(self.image.clone()))
    }
}

fn oracle_image(color: [u8; 4]) -> Arc<RenderImage> {
    Arc::new(RenderImage::new([image::Frame::new(
        image::RgbaImage::from_pixel(3, 2, image::Rgba(color)),
    )]))
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct OracleGlobal(u8);

impl Global for OracleGlobal {}

#[derive(Clone, Copy)]
struct Model {
    value: usize,
    measured_width: Pixels,
}

struct OraclePanel {
    index: usize,
    generation: usize,
    render_model: Option<Entity<Model>>,
    paint_model: Option<Entity<Model>>,
    has_cached_image: bool,
    reads_global_presence: bool,
    content_items: usize,
    focus_handle: FocusHandle,
    render_count: Arc<AtomicUsize>,
    event_hits: Rc<RefCell<Vec<(usize, usize, &'static str)>>>,
    input_text: String,
}

impl Render for OraclePanel {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        self.render_count.fetch_add(1, Ordering::Relaxed);

        let render_value = self
            .render_model
            .as_ref()
            .map(|model| model.read(cx).value)
            .unwrap_or(self.generation);
        let global_value = if self.reads_global_presence {
            // The global starts absent. Both APIs must register a dependency so adding and
            // removing the global invalidates this retained view.
            match (
                cx.has_global::<OracleGlobal>(),
                cx.try_global::<OracleGlobal>(),
            ) {
                (true, Some(value)) => format!("global:{}", value.0),
                (false, None) => "global:absent".to_owned(),
                _ => "global:inconsistent".to_owned(),
            }
        } else {
            String::new()
        };

        let index = self.index;
        let generation = self.generation;
        let event_hits = self.event_hits.clone();
        let focus_handle = self.focus_handle.clone();
        let view = cx.entity();
        let paint_model = self.paint_model.clone();

        let mut panel = div()
            .id(format!("oracle-panel-{index}"))
            .debug_selector(move || format!("PANEL-{index}"))
            .size_full()
            .track_focus(&self.focus_handle)
            .opacity(0.94)
            .blur(px(0.6))
            .on_mouse_down(MouseButton::Left, {
                let event_hits = event_hits.clone();
                let focus_handle = focus_handle.clone();
                move |_, window, cx| {
                    event_hits.borrow_mut().push((index, generation, "down"));
                    window.focus(&focus_handle, cx);
                }
            })
            .on_mouse_move({
                let event_hits = event_hits.clone();
                move |_, _, _| event_hits.borrow_mut().push((index, generation, "move"))
            });
        if self.index == 2 {
            // Keep the opacity-bearing surface inside the visible horizontal content range.
            panel = panel.child(
                div()
                    .debug_selector(|| "ORACLE_SURFACE".into())
                    .w(px(8.))
                    .h(px(8.))
                    .opacity(0.35)
                    .child(
                        canvas(
                            |_, _, _| (),
                            |bounds, _, window, _| {
                                window.paint_surface(
                                    bounds,
                                    SurfaceSource::Unsupported(size(
                                        DevicePixels(8),
                                        DevicePixels(8),
                                    )),
                                );
                            },
                        )
                        .w(px(8.))
                        .h(px(8.)),
                    ),
            );
        }
        panel = panel
            .child(format!(
                "panel {index}, generation {generation}, value {render_value}, {global_value}; \
                 retained paragraphs wrap at the window edge. "
            ))
            .child(
                div()
                    .inline()
                    .child("inline text ")
                    .child(
                        div()
                            .inline_flex()
                            .w(px(34.))
                            .h(px(12.))
                            .bg(rgb(0x4f8dd6))
                            .child("Parley"),
                    )
                    .child(" continues on this paragraph."),
            )
            .child(
                canvas(
                    |_, _, _| (),
                    move |bounds, _, window, cx| {
                        // Panel 1 reads the same model as Panel 0, but only from paint. This
                        // catches dependency sets that capture render reads and miss paint reads.
                        let value = paint_model
                            .as_ref()
                            .map(|model| model.read(cx).value)
                            .unwrap_or(generation);
                        let color = if value.is_multiple_of(2) {
                            rgb(0x3d9b70)
                        } else {
                            rgb(0xc45a61)
                        };
                        window.paint_quad(fill(bounds, color));
                        window.handle_input(
                            &focus_handle,
                            ElementInputHandler::new(bounds, view),
                            cx,
                        );
                    },
                )
                .w_full()
                .h(px(5.)),
            );

        let item_count = self.content_items;
        panel = panel.children((0..item_count).map(|item| {
            let event_hits = event_hits.clone();
            div()
                .id(format!("oracle-item-{index}-{item}"))
                .debug_selector(move || format!("ORACLE_ITEM_{index}_{item}"))
                .w_full()
                .h(px(7.))
                .bg(if item % 2 == 0 {
                    rgb(0x426b95)
                } else {
                    rgb(0x88634a)
                })
                .on_mouse_down(MouseButton::Left, move |_, _, _| {
                    event_hits.borrow_mut().push((index, generation, "item"));
                })
                .child(format!("panel {index} item {item}"))
        }));

        if self.index == 2 {
            panel = panel.child(
                div()
                    .debug_selector(|| "REM_PROBE".into())
                    .w(px(64.))
                    .h(rems(1.))
                    .bg(rgb(0x9c4f7d)),
            );
            if self.has_cached_image {
                panel = panel.child(img("retained-image-cache-key").w(px(20.)).h(px(14.)));
            }
        }

        if self.index == 1 {
            // A deferred child must be reattached after repeated reuse of the containing view.
            panel = panel.child(
                deferred(
                    div()
                        .id("oracle-popover")
                        .debug_selector(|| "ORACLE_POPOVER".into())
                        .absolute()
                        .left(px(12.))
                        .top(px(8.))
                        .w(px(24.))
                        .h(px(18.))
                        .bg(rgb(0xefb448)),
                )
                .priority(2),
            );
        }

        panel
    }
}

impl EntityInputHandler for OraclePanel {
    fn text_for_range(
        &mut self,
        _range: Range<usize>,
        _adjusted_range: &mut Option<Range<usize>>,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<String> {
        Some(self.input_text.clone())
    }

    fn selected_text_range(
        &mut self,
        _ignore_disabled_input: bool,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<UTF16Selection> {
        Some(UTF16Selection {
            range: 0..self.input_text.encode_utf16().count(),
            reversed: false,
        })
    }

    fn marked_text_range(
        &self,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<Range<usize>> {
        None
    }

    fn unmark_text(&mut self, _window: &mut Window, _cx: &mut Context<Self>) {}

    fn replace_text_in_range(
        &mut self,
        _range: Option<Range<usize>>,
        text: &str,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) {
        self.input_text.push_str(text);
        cx.notify();
    }

    fn replace_and_mark_text_in_range(
        &mut self,
        _range: Option<Range<usize>>,
        text: &str,
        _selected_range: Option<Range<usize>>,
        window: &mut Window,
        cx: &mut Context<Self>,
    ) {
        self.replace_text_in_range(None, text, window, cx);
    }

    fn bounds_for_range(
        &mut self,
        _range_utf16: Range<usize>,
        element_bounds: Bounds<Pixels>,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<Bounds<Pixels>> {
        Some(element_bounds)
    }

    fn character_index_for_point(
        &mut self,
        _point: crate::Point<Pixels>,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<usize> {
        Some(0)
    }

    fn text_input_configuration(
        &mut self,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> TextInputConfiguration {
        TextInputConfiguration {
            suggestions: self.generation % 2 == 1,
            input_action: if self.generation % 2 == 1 {
                TextInputAction::Send
            } else {
                TextInputAction::Done
            },
            ..Default::default()
        }
    }
}

struct OracleRoot {
    /// Panel 0 is intentionally mounted at two sibling positions with different heights.
    panels: Vec<Entity<OraclePanel>>,
    opacity: f32,
    image_cache: Entity<OracleImageCache>,
}

impl Render for OracleRoot {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("oracle-root")
            .size_full()
            .flex()
            .flex_col()
            .overflow_y_scroll()
            .opacity(self.opacity)
            .children(self.panels.iter().enumerate().map(|(slot, panel)| {
                let height = if slot == 4 { px(118.) } else { px(82.) };
                // These wrappers intentionally have no IDs. The same panel therefore reaches
                // the same explicit element-ID path from two positions in the tree, with distinct
                // containing sizes and masks. The retained view cache must include its mount path.
                div()
                    .w_full()
                    .h(height)
                    .overflow_hidden()
                    .image_cache(self.image_cache.clone())
                    .child(panel.clone())
            }))
    }
}

struct OracleHarness {
    window: WindowHandle<OracleRoot>,
    shared_model: Entity<Model>,
    alternate_image_cache: Entity<OracleImageCache>,
    image_cache_loads: Arc<AtomicUsize>,
    alternate_image_cache_loads: Arc<AtomicUsize>,
    render_counts: Vec<Arc<AtomicUsize>>,
    event_hits: Rc<RefCell<Vec<(usize, usize, &'static str)>>>,
}

fn oracle_harness(cx: &mut TestAppContext) -> OracleHarness {
    let shared_model = cx.new(|_| Model {
        value: 0,
        measured_width: px(42.),
    });
    let image_cache_loads = Arc::new(AtomicUsize::new(0));
    let alternate_image_cache_loads = Arc::new(AtomicUsize::new(0));
    let image_cache = cx.new({
        let loads = image_cache_loads.clone();
        move |_| OracleImageCache {
            image: oracle_image([230, 40, 80, 255]),
            loads,
        }
    });
    let alternate_image_cache = cx.new({
        let loads = alternate_image_cache_loads.clone();
        move |_| OracleImageCache {
            image: oracle_image([45, 190, 130, 255]),
            loads,
        }
    });
    let render_counts = (0..4)
        .map(|_| Arc::new(AtomicUsize::new(0)))
        .collect::<Vec<_>>();
    let event_hits = Rc::new(RefCell::new(Vec::new()));
    let window = cx.open_window(size(px(360.), px(330.)), {
        let shared_model = shared_model.clone();
        let render_counts = render_counts.clone();
        let event_hits = event_hits.clone();
        move |_, cx| {
            let panels = (0..4)
                .map(|index| {
                    let render_model = (index == 0).then(|| shared_model.clone());
                    let paint_model = (index == 1).then(|| shared_model.clone());
                    cx.new(|cx| OraclePanel {
                        index,
                        generation: 0,
                        render_model,
                        paint_model,
                        has_cached_image: index == 2,
                        reads_global_presence: index == 3,
                        content_items: 12,
                        focus_handle: cx.focus_handle(),
                        render_count: render_counts[index].clone(),
                        event_hits: event_hits.clone(),
                        input_text: String::new(),
                    })
                })
                .collect::<Vec<_>>();
            OracleRoot {
                panels: vec![
                    panels[0].clone(),
                    panels[1].clone(),
                    panels[2].clone(),
                    panels[3].clone(),
                    panels[0].clone(),
                ],
                opacity: 1.0,
                image_cache,
            }
        }
    });
    cx.run_until_parked();
    OracleHarness {
        window,
        shared_model,
        alternate_image_cache,
        image_cache_loads,
        alternate_image_cache_loads,
        render_counts,
        event_hits,
    }
}

#[derive(Clone, Debug)]
struct FrameSnapshot {
    primitive_counts: (usize, usize, usize, usize),
    scene_operation_count: usize,
    debug_bounds: collections::FxHashMap<String, Bounds<Pixels>>,
    device_debug_bounds: collections::FxHashMap<String, [f32; 4]>,
    hitboxes: Vec<HitboxSnapshot>,
    mouse_listener_slots: Vec<bool>,
    input_handler_slots: Vec<bool>,
    window_control_hitboxes: Vec<(Bounds<Pixels>, crate::ContentMask<Pixels>)>,
    tooltip_slots: Vec<bool>,
    cursor_style_count: usize,
    scene_dump: String,
    scene_lanes: Vec<(&'static str, Vec<String>)>,
    surface_opacities: Vec<f32>,
    deferred_count: usize,
}

impl PartialEq for FrameSnapshot {
    fn eq(&self, other: &Self) -> bool {
        self.primitive_counts == other.primitive_counts
            && self.scene_operation_count == other.scene_operation_count
            && self.debug_bounds == other.debug_bounds
            && self.hitboxes == other.hitboxes
            && self.mouse_listener_slots == other.mouse_listener_slots
            && self.input_handler_slots == other.input_handler_slots
            && self.window_control_hitboxes == other.window_control_hitboxes
            && self.tooltip_slots == other.tooltip_slots
            && self.cursor_style_count == other.cursor_style_count
            && self.scene_dump == other.scene_dump
            && self.scene_lanes == other.scene_lanes
            && self.surface_opacities == other.surface_opacities
            && self.deferred_count == other.deferred_count
    }
}

#[derive(Clone, Debug, PartialEq)]
struct HitboxSnapshot {
    bounds: Bounds<Pixels>,
    content_mask: crate::ContentMask<Pixels>,
    behavior: crate::HitboxBehavior,
    tags: Vec<String>,
    fragments: Option<Vec<Bounds<Pixels>>>,
}

fn snapshot_window<V: Render>(
    window_handle: &WindowHandle<V>,
    cx: &mut TestAppContext,
) -> FrameSnapshot {
    window_handle
        .update(cx, |_, window, _| {
            let scene = &window.rendered_frame.scene;
            let debug_bounds = window.rendered_frame.debug_bounds.clone();
            let scale_factor = window.scale_factor();
            let device_debug_bounds = debug_bounds
                .iter()
                .map(|(selector, bounds)| {
                    (
                        selector.clone(),
                        [
                            bounds.origin.x.0 * scale_factor,
                            bounds.origin.y.0 * scale_factor,
                            (bounds.origin.x + bounds.size.width).0 * scale_factor,
                            (bounds.origin.y + bounds.size.height).0 * scale_factor,
                        ],
                    )
                })
                .collect();
            FrameSnapshot {
                primitive_counts: window.rendered_primitive_counts(),
                scene_operation_count: scene.len(),
                debug_bounds,
                device_debug_bounds,
                hitboxes: window
                    .rendered_frame
                    .hitboxes
                    .iter()
                    .map(|hitbox| HitboxSnapshot {
                        bounds: hitbox.bounds,
                        content_mask: hitbox.content_mask,
                        behavior: hitbox.behavior,
                        tags: hitbox.tags.iter().map(ToString::to_string).collect(),
                        fragments: hitbox.fragments.as_deref().map(<[_]>::to_vec),
                    })
                    .collect(),
                mouse_listener_slots: window
                    .rendered_frame
                    .mouse_listeners
                    .iter()
                    .map(Option::is_some)
                    .collect(),
                input_handler_slots: window
                    .rendered_frame
                    .input_handlers
                    .iter()
                    .map(Option::is_some)
                    .collect(),
                window_control_hitboxes: window
                    .rendered_frame
                    .window_control_hitboxes
                    .iter()
                    .map(|(_, hitbox)| (hitbox.bounds, hitbox.content_mask))
                    .collect(),
                tooltip_slots: window
                    .rendered_frame
                    .tooltip_requests
                    .iter()
                    .map(Option::is_some)
                    .collect(),
                cursor_style_count: window.rendered_frame.cursor_styles.len(),
                // Scene primitives are plain deterministic values but intentionally do not all
                // implement PartialEq. Debug snapshots include geometry, ordering, masks,
                // filter boundaries, and surfaces for an exact same-process comparison.
                scene_dump: format!(
                    "quad={:?}; path={:?}; underline={:?}; shadow={:?}; mono={:?}; subpixel={:?}; poly={:?}; surface={:?}; backdrop={:?}; filter={:?}",
                    scene.quads,
                    scene.paths,
                    scene.underlines,
                    scene.shadows,
                    scene.monochrome_sprites,
                    scene.subpixel_sprites,
                    scene.polychrome_sprites,
                    scene.surfaces,
                    scene.backdrop_filters,
                    scene.filter_boundaries,
                ),
                scene_lanes: vec![
                    ("quads", scene.quads.iter().map(|item| format!("{item:?}")).collect()),
                    ("paths", scene.paths.iter().map(|item| format!("{item:?}")).collect()),
                    ("underlines", scene.underlines.iter().map(|item| format!("{item:?}")).collect()),
                    ("shadows", scene.shadows.iter().map(|item| format!("{item:?}")).collect()),
                    ("monochrome_sprites", scene.monochrome_sprites.iter().map(|item| format!("{item:?}")).collect()),
                    ("subpixel_sprites", scene.subpixel_sprites.iter().map(|item| format!("{item:?}")).collect()),
                    ("polychrome_sprites", scene.polychrome_sprites.iter().map(|item| format!("{item:?}")).collect()),
                    ("surfaces", scene.surfaces.iter().map(|item| format!("{item:?}")).collect()),
                    ("backdrop_filters", scene.backdrop_filters.iter().map(|item| format!("{item:?}")).collect()),
                    ("filter_boundaries", scene.filter_boundaries.iter().map(|item| format!("{item:?}")).collect()),
                ],
                surface_opacities: scene.surface_opacities().to_vec(),
                deferred_count: window.rendered_frame.deferred_draws.len(),
            }
        })
        .unwrap()
}

fn a11y_tree_snapshot<V: Render>(
    window_handle: &WindowHandle<V>,
    cx: &mut TestAppContext,
) -> serde_json::Value {
    let tree = window_handle
        .update(cx, |_, window, _| {
            window
                .debug_a11y_tree_json()
                .expect("forced accessibility tree is missing")
        })
        .unwrap();
    let mut tree: serde_json::Value = serde_json::from_str(&tree).unwrap();
    if let Some(frame) = tree
        .get_mut("frame")
        .and_then(serde_json::Value::as_object_mut)
    {
        // The debug representation includes the timestamp and monotonically increasing frame
        // number alongside semantic tree metadata. Ignore only those two per-frame fields.
        frame.remove("rendered_at");
        frame.remove("frame_number");
    }
    tree
}

fn snapshot(harness: &OracleHarness, cx: &mut TestAppContext) -> FrameSnapshot {
    snapshot_window(&harness.window, cx)
}

fn scene_difference(retained: &FrameSnapshot, rebuilt: &FrameSnapshot) -> Option<String> {
    for ((retained_lane, retained_items), (rebuilt_lane, rebuilt_items)) in
        retained.scene_lanes.iter().zip(&rebuilt.scene_lanes)
    {
        if retained_lane != rebuilt_lane {
            return Some(format!(
                "scene lane order differs: retained {retained_lane}, full refresh {rebuilt_lane}"
            ));
        }

        for index in 0..retained_items.len().max(rebuilt_items.len()) {
            let retained_item = retained_items.get(index);
            let rebuilt_item = rebuilt_items.get(index);
            if retained_item != rebuilt_item {
                let excerpt = |item: Option<&String>| match item {
                    Some(item) => {
                        let excerpt = item.chars().take(240).collect::<String>();
                        if item.chars().count() > 240 {
                            format!("{excerpt}...")
                        } else {
                            excerpt
                        }
                    }
                    None => "<missing>".to_owned(),
                };
                return Some(format!(
                    "first scene difference {retained_lane}[{index}]: retained {}; full refresh {}",
                    excerpt(retained_item),
                    excerpt(rebuilt_item),
                ));
            }
        }
    }

    None
}

fn first_vec_difference<T: std::fmt::Debug + PartialEq>(
    field: &str,
    retained: &[T],
    rebuilt: &[T],
) -> Option<String> {
    for index in 0..retained.len().max(rebuilt.len()) {
        let retained_item = retained.get(index);
        let rebuilt_item = rebuilt.get(index);
        if retained_item != rebuilt_item {
            return Some(format!(
                "first difference {field}[{index}]: retained {retained_item:?}; full refresh {rebuilt_item:?}"
            ));
        }
    }
    None
}

fn first_snapshot_difference(retained: &FrameSnapshot, rebuilt: &FrameSnapshot) -> String {
    if let Some(difference) = scene_difference(retained, rebuilt) {
        return difference;
    }

    if retained.primitive_counts != rebuilt.primitive_counts {
        return format!(
            "primitive_counts: retained {:?}; full refresh {:?}",
            retained.primitive_counts, rebuilt.primitive_counts
        );
    }
    if retained.scene_operation_count != rebuilt.scene_operation_count {
        return format!(
            "scene_operation_count: retained {}; full refresh {}",
            retained.scene_operation_count, rebuilt.scene_operation_count
        );
    }
    if retained.debug_bounds != rebuilt.debug_bounds {
        let mut keys = retained
            .debug_bounds
            .keys()
            .chain(rebuilt.debug_bounds.keys())
            .collect::<Vec<_>>();
        keys.sort();
        keys.dedup();
        for key in keys {
            let retained_bounds = retained.debug_bounds.get(key);
            let rebuilt_bounds = rebuilt.debug_bounds.get(key);
            if retained_bounds != rebuilt_bounds {
                return format!(
                    "debug_bounds[{key:?}]: retained {retained_bounds:?} (device edges {:?}); full refresh {rebuilt_bounds:?} (device edges {:?})",
                    retained.device_debug_bounds.get(key),
                    rebuilt.device_debug_bounds.get(key),
                );
            }
        }
    }

    macro_rules! check_vec {
        ($field:ident) => {
            if let Some(difference) =
                first_vec_difference(stringify!($field), &retained.$field, &rebuilt.$field)
            {
                return difference;
            }
        };
    }
    check_vec!(hitboxes);
    check_vec!(mouse_listener_slots);
    check_vec!(input_handler_slots);
    check_vec!(window_control_hitboxes);
    check_vec!(tooltip_slots);

    if retained.cursor_style_count != rebuilt.cursor_style_count {
        return format!(
            "cursor_style_count: retained {}; full refresh {}",
            retained.cursor_style_count, rebuilt.cursor_style_count
        );
    }
    if retained.scene_dump != rebuilt.scene_dump {
        return "scene lane values differ although per-element lane snapshots match".to_owned();
    }
    check_vec!(surface_opacities);
    if retained.deferred_count != rebuilt.deferred_count {
        return format!(
            "deferred_count: retained {}; full refresh {}",
            retained.deferred_count, rebuilt.deferred_count
        );
    }

    "snapshot equality differs in an unreported field".to_owned()
}

fn force_refresh_and_compare(harness: &OracleHarness, cx: &mut TestAppContext) {
    static COMPARISON: AtomicUsize = AtomicUsize::new(0);
    let comparison = COMPARISON.fetch_add(1, Ordering::Relaxed) + 1;
    let retained = snapshot(harness, cx);
    let retained_stats = harness
        .window
        .update(cx, |_, window, _| window.retained_view_stats())
        .unwrap();
    harness
        .window
        .update(cx, |_, window, _| window.refresh())
        .unwrap();
    cx.run_until_parked();
    let rebuilt = snapshot(harness, cx);
    if retained != rebuilt {
        let rebuilt_stats = harness
            .window
            .update(cx, |_, window, _| window.retained_view_stats())
            .unwrap();
        let first_difference = first_snapshot_difference(&retained, &rebuilt);
        panic!(
            "retained frame differs from full refresh after comparison #{comparison}: {first_difference}; retained counts={:?}, ops={}, bounds={}, surfaces={}, deferred={}, stats={retained_stats:?}; rebuilt counts={:?}, ops={}, bounds={}, surfaces={}, deferred={}, stats={rebuilt_stats:?}",
            retained.primitive_counts,
            retained.scene_operation_count,
            retained.debug_bounds.len(),
            retained.surface_opacities.len(),
            retained.deferred_count,
            rebuilt.primitive_counts,
            rebuilt.scene_operation_count,
            rebuilt.debug_bounds.len(),
            rebuilt.surface_opacities.len(),
            rebuilt.deferred_count,
        );
    }
}

fn reset_counts(counts: &[Arc<AtomicUsize>]) {
    for count in counts {
        count.store(0, Ordering::Relaxed);
    }
}

fn counts(counts: &[Arc<AtomicUsize>]) -> Vec<usize> {
    counts
        .iter()
        .map(|count| count.load(Ordering::Relaxed))
        .collect()
}

fn update_panel(
    harness: &OracleHarness,
    cx: &mut TestAppContext,
    panel_index: usize,
    update: impl FnOnce(&mut OraclePanel, &mut Context<OraclePanel>),
) {
    harness
        .window
        .update(cx, |root, _, cx| {
            root.panels[panel_index].update(cx, update)
        })
        .unwrap();
    cx.run_until_parked();
}

#[gpui::test]
fn retained_views_match_forced_refresh_through_seeded_history(cx: &mut TestAppContext) {
    let harness = oracle_harness(cx);
    let mut visual = VisualTestContext::from_window(AnyWindowHandle::from(harness.window), cx);

    // Only the root renders after a clean invalidation. Panel 0 occurs twice in the tree.
    reset_counts(&harness.render_counts);
    harness
        .window
        .update(cx, |_root, _, cx| cx.notify())
        .unwrap();
    cx.run_until_parked();
    assert_eq!(counts(&harness.render_counts), vec![0, 0, 0, 0]);
    force_refresh_and_compare(&harness, cx);
    reset_counts(&harness.render_counts);

    // A child notification rebuilds both mounted occurrences and leaves siblings retained.
    update_panel(&harness, cx, 0, |panel, cx| {
        panel.generation += 1;
        cx.notify();
    });
    assert_eq!(counts(&harness.render_counts), vec![2, 0, 0, 0]);
    force_refresh_and_compare(&harness, cx);
    reset_counts(&harness.render_counts);

    // A shared model is read by a sibling in render and in the other sibling's paint callback.
    harness.shared_model.update(cx, |model, cx| {
        model.value += 1;
        cx.notify();
    });
    cx.run_until_parked();
    assert_eq!(counts(&harness.render_counts), vec![2, 1, 0, 0]);
    force_refresh_and_compare(&harness, cx);
    reset_counts(&harness.render_counts);

    // The absent/present/removed global changes invalidate only the view that queried both
    // presence APIs. The separately installed observer checks that clear_globals remains silent.
    let global_observer_calls = Arc::new(AtomicUsize::new(0));
    cx.update({
        let calls = global_observer_calls.clone();
        move |app| {
            app.observe_global::<OracleGlobal>(move |_| {
                calls.fetch_add(1, Ordering::Relaxed);
            })
            .detach();
        }
    });
    cx.run_until_parked();
    assert!(!cx.has_global::<OracleGlobal>());
    cx.update(|app| app.set_global(OracleGlobal(7)));
    cx.run_until_parked();
    assert_eq!(counts(&harness.render_counts), vec![0, 0, 0, 1]);
    force_refresh_and_compare(&harness, cx);
    reset_counts(&harness.render_counts);
    assert_eq!(
        cx.update(|app| app.remove_global::<OracleGlobal>()),
        OracleGlobal(7)
    );
    cx.run_until_parked();
    assert_eq!(counts(&harness.render_counts), vec![0, 0, 0, 1]);
    force_refresh_and_compare(&harness, cx);
    reset_counts(&harness.render_counts);

    // Clearing an existing global intentionally does not call its explicit observer. A root-only
    // notification still has to invalidate the retained reader through the global revision.
    cx.update(|app| app.set_global(OracleGlobal(9)));
    cx.run_until_parked();
    assert_eq!(counts(&harness.render_counts), vec![0, 0, 0, 1]);
    force_refresh_and_compare(&harness, cx);
    reset_counts(&harness.render_counts);
    let observer_calls_before_clear = global_observer_calls.load(Ordering::Relaxed);
    assert!(observer_calls_before_clear > 0);
    cx.update(|app| app.clear_globals());
    assert!(!cx.has_global::<OracleGlobal>());
    assert_eq!(
        global_observer_calls.load(Ordering::Relaxed),
        observer_calls_before_clear,
        "clear_globals must remain silent for explicit global observers"
    );
    harness
        .window
        .update(cx, |_root, _, cx| cx.notify())
        .unwrap();
    cx.run_until_parked();
    assert_eq!(counts(&harness.render_counts), vec![0, 0, 0, 1]);
    assert_eq!(
        global_observer_calls.load(Ordering::Relaxed),
        observer_calls_before_clear,
        "root-only invalidation must not publish a global observer notification"
    );
    force_refresh_and_compare(&harness, cx);
    reset_counts(&harness.render_counts);

    // Ambient rem sizing changes a retained descendant's layout without changing its entity
    // state. The debug bounds make sure this isn't merely two equivalent scene snapshots.
    let rem_bounds_before = snapshot(&harness, cx).debug_bounds["REM_PROBE"];
    harness
        .window
        .update(cx, |_root, window, cx| {
            window.set_rem_size(px(24.));
            cx.notify();
        })
        .unwrap();
    cx.run_until_parked();
    let rem_bounds_after = snapshot(&harness, cx).debug_bounds["REM_PROBE"];
    assert_ne!(
        rem_bounds_before.size.height, rem_bounds_after.size.height,
        "rem-based probe did not change: before={rem_bounds_before:?}, after={rem_bounds_after:?}"
    );
    force_refresh_and_compare(&harness, cx);
    reset_counts(&harness.render_counts);

    // Ancestor opacity is ambient paint context. Rebuilding only the root must still produce the
    // same pixels/scene metadata as refreshing the complete window.
    harness
        .window
        .update(cx, |root, _, cx| {
            root.opacity = 0.68;
            cx.notify();
        })
        .unwrap();
    cx.run_until_parked();
    // TestAppContext records scene operations and metadata but not backend pixels. Opacity
    // changes inherited paint context, so every mounted panel must rebuild even when its own
    // entity state remains clean.
    assert_eq!(counts(&harness.render_counts), vec![2, 1, 1, 1]);
    force_refresh_and_compare(&harness, cx);
    reset_counts(&harness.render_counts);

    // Replacing the image cache around an otherwise-clean child changes the cache identity. The
    // child does not read entity state during render; its image comes from the inherited cache.
    assert!(harness.image_cache_loads.load(Ordering::Relaxed) > 0);
    let alternate_loads_before = harness.alternate_image_cache_loads.load(Ordering::Relaxed);
    let alternate_image_cache = harness.alternate_image_cache.clone();
    harness
        .window
        .update(cx, |root, _, cx| {
            root.image_cache = alternate_image_cache;
            cx.notify();
        })
        .unwrap();
    cx.run_until_parked();
    assert!(
        harness.alternate_image_cache_loads.load(Ordering::Relaxed) > alternate_loads_before,
        "the image under the inherited cache context was not loaded from the replacement cache"
    );
    force_refresh_and_compare(&harness, cx);
    reset_counts(&harness.render_counts);

    // A fixed xorshift seed supplies a varied but repeatable history over both occurrences of
    // Panel 0 and all three other panels. Check the exact invalidation fanout after each action.
    let mut seed = 0x6380_6442_d15c_a11eu64;
    for _ in 0..24 {
        seed ^= seed << 13;
        seed ^= seed >> 7;
        seed ^= seed << 17;
        let slot = (seed as usize) % 5;
        let index = slot % 4;
        reset_counts(&harness.render_counts);
        update_panel(&harness, cx, slot, |panel, cx| {
            panel.generation = panel.generation.wrapping_add(1);
            cx.notify();
        });
        let mut expected = vec![0; 4];
        expected[index] = if index == 0 { 2 } else { 1 };
        assert_eq!(counts(&harness.render_counts), expected, "seed={seed:#x}");
        force_refresh_and_compare(&harness, cx);
    }
    reset_counts(&harness.render_counts);

    // Repeated clean reuse must reattach deferred drawing and preserve painted metadata.
    for _ in 0..4 {
        harness
            .window
            .update(cx, |_root, _, cx| cx.notify())
            .unwrap();
        cx.run_until_parked();
        let frame = snapshot(&harness, cx);
        assert_eq!(frame.deferred_count, 1);
        assert!(frame.debug_bounds.contains_key("ORACLE_POPOVER"));
        force_refresh_and_compare(&harness, cx);
    }
    let deferred_frame = snapshot(&harness, cx);
    assert!(
        deferred_frame.debug_bounds.contains_key("ORACLE_SURFACE"),
        "surface was not laid out; bounds={:?}",
        deferred_frame.debug_bounds.get("ORACLE_SURFACE")
    );
    let surface_opacity = deferred_frame.surface_opacities.first().copied();
    assert_eq!(deferred_frame.surface_opacities.len(), 1);
    assert!(
        (surface_opacity.unwrap() - (0.35 * 0.94 * 0.68)).abs() < 0.001,
        "surface opacity lost an inherited context: bounds={:?}, opacity={surface_opacity:?}",
        deferred_frame.debug_bounds.get("ORACLE_SURFACE"),
    );
    reset_counts(&harness.render_counts);

    // Shrink an early sibling from many text/hitbox primitives to one, then carry the compacted
    // frame through several full-parent replays before invalidating a later child and rebuilding
    // the deferred subtree. This catches stale nested ranges after the source span moves.
    update_panel(&harness, cx, 0, |panel, cx| {
        panel.content_items = 1;
        panel.generation += 1;
        cx.notify();
    });
    assert_eq!(counts(&harness.render_counts), vec![2, 0, 0, 0]);
    force_refresh_and_compare(&harness, cx);
    reset_counts(&harness.render_counts);
    for _ in 0..4 {
        harness
            .window
            .update(cx, |_root, _, cx| cx.notify())
            .unwrap();
        cx.run_until_parked();
        assert_eq!(counts(&harness.render_counts), vec![0, 0, 0, 0]);
        force_refresh_and_compare(&harness, cx);
        reset_counts(&harness.render_counts);
    }
    reset_counts(&harness.render_counts);
    update_panel(&harness, cx, 2, |panel, cx| {
        panel.generation += 1;
        cx.notify();
    });
    assert_eq!(counts(&harness.render_counts), vec![0, 0, 1, 0]);
    force_refresh_and_compare(&harness, cx);
    reset_counts(&harness.render_counts);
    update_panel(&harness, cx, 1, |panel, cx| {
        panel.generation += 1;
        cx.notify();
    });
    assert_eq!(counts(&harness.render_counts), vec![0, 1, 0, 0]);
    let deferred_rebuilt = snapshot(&harness, cx);
    assert_eq!(deferred_rebuilt.deferred_count, 1);
    assert!(deferred_rebuilt.debug_bounds.contains_key("ORACLE_POPOVER"));
    force_refresh_and_compare(&harness, cx);

    // Focus, native text configuration, and retained event closures stay attached to the correct
    // mounted view. A rebuild replaces event closures with the new generation.
    update_panel(&harness, cx, 1, |panel, cx| {
        panel.generation = 0;
        cx.notify();
    });
    force_refresh_and_compare(&harness, cx);
    reset_counts(&harness.render_counts);
    let focus = harness
        .window
        .update(cx, |root, _, cx| {
            root.panels[1].read(cx).focus_handle.clone()
        })
        .unwrap();
    harness
        .window
        .update(cx, |_, window, cx| window.focus(&focus, cx))
        .unwrap();
    cx.run_until_parked();
    assert!(
        harness
            .window
            .update(cx, |_, window, _| focus.is_focused(window))
            .unwrap()
    );

    let test_window = cx.test_window(AnyWindowHandle::from(harness.window));
    let before_configuration_count = test_window.text_input_configurations().len();
    update_panel(&harness, cx, 1, |panel, cx| {
        panel.generation += 1;
        cx.notify();
    });
    assert!(test_window.text_input_configurations().len() > before_configuration_count);
    assert_eq!(
        test_window.text_input_configurations().last(),
        Some(&TextInputConfiguration {
            suggestions: true,
            input_action: TextInputAction::Send,
            ..Default::default()
        })
    );
    visual.simulate_click(point(px(100.), px(110.)), Modifiers::default());
    assert!(harness.event_hits.borrow().contains(&(1, 1, "down")));
    visual.simulate_mouse_move(point(px(101.), px(111.)), None, Modifiers::default());
    assert!(harness.event_hits.borrow().contains(&(1, 1, "move")));
    assert!(
        harness
            .window
            .update(cx, |_, window, _| focus.is_focused(window))
            .unwrap()
    );
    force_refresh_and_compare(&harness, cx);

    // Resize changes cached bounds and paragraph wrapping; scrolling changes the content mask.
    visual.simulate_resize(size(px(260.), px(330.)));
    visual.run_until_parked();
    force_refresh_and_compare(&harness, cx);
    visual.simulate_event(crate::ScrollWheelEvent {
        position: point(px(180.), px(250.)),
        delta: crate::ScrollDelta::Pixels(point(px(0.), px(-245.))),
        ..Default::default()
    });
    force_refresh_and_compare(&harness, cx);
    harness
        .window
        .update(cx, |_, window, _| window.set_scale_factor(1.5))
        .unwrap();
    cx.run_until_parked();
    force_refresh_and_compare(&harness, cx);

    // Reordering and removing mounted siblings must maintain Taffy parentage and prune stale
    // occurrence state; restore the same entity twice in a new order afterwards.
    harness
        .window
        .update(cx, |root, _, cx| {
            root.panels.swap(0, 1);
            root.panels.pop();
            cx.notify();
        })
        .unwrap();
    cx.run_until_parked();
    force_refresh_and_compare(&harness, cx);
    harness
        .window
        .update(cx, |root, _, cx| {
            let repeated = root.panels[1].clone();
            root.panels.insert(2, repeated);
            cx.notify();
        })
        .unwrap();
    cx.run_until_parked();
    force_refresh_and_compare(&harness, cx);

    // Every dirty occurrence is rebuilt once, while the untouched branch remains clean.
    reset_counts(&harness.render_counts);
    for index in 0..harness
        .window
        .update(cx, |root, _, _| root.panels.len())
        .unwrap()
    {
        update_panel(&harness, cx, index, |panel, cx| {
            panel.generation += 1;
            cx.notify();
        });
    }
    // Panel 0 is mounted twice, and both occurrences are rendered after each of its two slot
    // updates in this final reordered tree.
    assert_eq!(counts(&harness.render_counts), vec![4, 1, 1, 1]);
    force_refresh_and_compare(&harness, cx);

    // Establish the clean-frame count, then exercise stable retained bookkeeping for a long
    // history. These per-frame counts stay constant as unrelated frame data is discarded.
    reset_counts(&harness.render_counts);
    harness
        .window
        .update(cx, |_root, _, cx| cx.notify())
        .unwrap();
    cx.run_until_parked();
    let stable_stats = harness
        .window
        .update(cx, |_, window, _| window.retained_view_stats())
        .unwrap();
    // The window's root entity renders for each root notification; all mounted panels are reused.
    assert_eq!(stable_stats.rebuilt_views, 1);
    assert_eq!(stable_stats.reused_views, 5);
    assert!(stable_stats.live_layout_nodes > 0);
    assert!(stable_stats.measured_layouts > 0);
    assert!(stable_stats.retained_element_states > 0);
    for _ in 0..1000 {
        harness
            .window
            .update(cx, |_root, _, cx| cx.notify())
            .unwrap();
        cx.run_until_parked();
        assert_eq!(counts(&harness.render_counts), vec![0, 0, 0, 0]);
        let stats = harness
            .window
            .update(cx, |_, window, _| window.retained_view_stats())
            .unwrap();
        assert_eq!(stats.rebuilt_views, stable_stats.rebuilt_views);
        assert_eq!(stats.reused_views, stable_stats.reused_views);
        assert_eq!(stats.live_layout_nodes, stable_stats.live_layout_nodes);
        assert_eq!(stats.measured_layouts, stable_stats.measured_layouts);
        assert_eq!(
            stats.retained_element_states,
            stable_stats.retained_element_states
        );
    }

    // Removing every mounted panel releases its retained element state and Taffy nodes rather
    // than growing a per-frame history of orphaned layout records.
    harness
        .window
        .update(cx, |root, _, cx| {
            root.panels.clear();
            cx.notify();
        })
        .unwrap();
    cx.run_until_parked();
    force_refresh_and_compare(&harness, cx);
    let unmounted_stats = harness
        .window
        .update(cx, |_, window, _| window.retained_view_stats())
        .unwrap();
    assert!(unmounted_stats.live_layout_nodes < stable_stats.live_layout_nodes);
    assert!(unmounted_stats.measured_layouts < stable_stats.measured_layouts);
    assert!(
        unmounted_stats.retained_element_states < stable_stats.retained_element_states,
        "retained element states survived unmount: before={stable_stats:?}, after={unmounted_stats:?}"
    );
}

/// Reads entity state only in deferred prepaint, and global state only in deferred paint.
/// Neither `Render` nor `request_layout` observes these dependencies.
struct DeferredLateRead {
    model: Entity<Model>,
    prepaint_reads: Arc<AtomicUsize>,
    paint_reads: Arc<AtomicUsize>,
    last_signature: Arc<AtomicUsize>,
}

impl IntoElement for DeferredLateRead {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }
}

impl Element for DeferredLateRead {
    type RequestLayoutState = ();
    type PrepaintState = usize;

    fn id(&self) -> Option<ElementId> {
        Some("deferred-late-read".into())
    }

    fn source_location(&self) -> Option<&'static std::panic::Location<'static>> {
        None
    }

    fn request_layout(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&crate::InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState) {
        let mut style = Style::default();
        style.size.width = px(52.).into();
        style.size.height = px(28.).into();
        (window.request_layout(style, [], cx), ())
    }

    fn prepaint(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&crate::InspectorElementId>,
        _bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        _window: &mut Window,
        cx: &mut App,
    ) -> Self::PrepaintState {
        self.prepaint_reads.fetch_add(1, Ordering::Relaxed);
        self.model.read(cx).value
    }

    fn paint(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&crate::InspectorElementId>,
        bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        prepaint: &mut Self::PrepaintState,
        window: &mut Window,
        cx: &mut App,
    ) {
        self.paint_reads.fetch_add(1, Ordering::Relaxed);
        assert!(
            bounds.size.width > px(0.) && bounds.size.height > px(0.),
            "deferred dependency probe must paint a visible nonzero quad: {bounds:?}"
        );
        let global_value = cx
            .try_global::<OracleGlobal>()
            .map_or(0, |global| usize::from(global.0));
        let color = match (*prepaint + global_value) % 3 {
            0 => rgb(0x315f9a),
            1 => rgb(0xa24c62),
            _ => rgb(0x4d956e),
        };
        self.last_signature
            .store((*prepaint << 8) | global_value, Ordering::Relaxed);
        window.paint_quad(fill(bounds, color));
    }
}

struct DeferredLateReadView {
    model: Entity<Model>,
    prepaint_reads: Arc<AtomicUsize>,
    paint_reads: Arc<AtomicUsize>,
    last_signature: Arc<AtomicUsize>,
    renders: Arc<AtomicUsize>,
}

impl Render for DeferredLateReadView {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        self.renders.fetch_add(1, Ordering::Relaxed);
        div().w(px(100.)).h(px(60.)).child(
            deferred(DeferredLateRead {
                model: self.model.clone(),
                prepaint_reads: self.prepaint_reads.clone(),
                paint_reads: self.paint_reads.clone(),
                last_signature: self.last_signature.clone(),
            })
            .priority(1),
        )
    }
}

struct DeferredLateReadRoot {
    view: Entity<DeferredLateReadView>,
    revision: usize,
    renders: Arc<AtomicUsize>,
}

impl Render for DeferredLateReadRoot {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        self.renders.fetch_add(1, Ordering::Relaxed);
        div()
            .size_full()
            .flex_col()
            .child(format!("late-dependency root revision {}", self.revision))
            .child(self.view.clone())
    }
}

struct DeferredLateFixture {
    window: WindowHandle<DeferredLateReadRoot>,
    model: Entity<Model>,
    root_renders: Arc<AtomicUsize>,
    view_renders: Arc<AtomicUsize>,
    prepaint_reads: Arc<AtomicUsize>,
    paint_reads: Arc<AtomicUsize>,
    last_signature: Arc<AtomicUsize>,
}

fn deferred_late_fixture(cx: &mut TestAppContext) -> DeferredLateFixture {
    let model = cx.new(|_| Model {
        value: 0,
        measured_width: px(10.),
    });
    let prepaint_reads = Arc::new(AtomicUsize::new(0));
    let paint_reads = Arc::new(AtomicUsize::new(0));
    let root_renders = Arc::new(AtomicUsize::new(0));
    let view_renders = Arc::new(AtomicUsize::new(0));
    let last_signature = Arc::new(AtomicUsize::new(usize::MAX));
    let view = cx.new({
        let model = model.clone();
        let prepaint_reads = prepaint_reads.clone();
        let paint_reads = paint_reads.clone();
        let last_signature = last_signature.clone();
        let renders = view_renders.clone();
        move |_| DeferredLateReadView {
            model,
            prepaint_reads,
            paint_reads,
            last_signature,
            renders,
        }
    });
    let window = cx.open_window(size(px(240.), px(120.)), {
        let root_renders = root_renders.clone();
        move |_, _| DeferredLateReadRoot {
            view,
            revision: 0,
            renders: root_renders,
        }
    });
    DeferredLateFixture {
        window,
        model,
        root_renders,
        view_renders,
        prepaint_reads,
        paint_reads,
        last_signature,
    }
}

fn notify_deferred_late_roots(
    target: &DeferredLateFixture,
    reference: &DeferredLateFixture,
    cx: &mut TestAppContext,
) {
    for fixture in [target, reference] {
        fixture
            .window
            .update(cx, |root, _, cx| {
                root.revision += 1;
                cx.notify();
            })
            .unwrap();
    }
    cx.run_until_parked();
}

fn assert_deferred_late_matches_reference(
    target: &DeferredLateFixture,
    reference: &DeferredLateFixture,
    cx: &mut TestAppContext,
) -> FrameSnapshot {
    let retained = snapshot_window(&target.window, cx);
    reference
        .window
        .update(cx, |_, window, _| window.refresh())
        .unwrap();
    cx.run_until_parked();
    let rebuilt = snapshot_window(&reference.window, cx);
    assert_eq!(
        retained, rebuilt,
        "deferred late-read frame differs from independent refresh"
    );
    retained
}

#[gpui::test]
fn deferred_phase_only_entity_and_global_reads_invalidate_retained_ancestor(
    cx: &mut TestAppContext,
) {
    cx.update(|app| app.set_global(OracleGlobal(1)));
    let target = deferred_late_fixture(cx);
    let reference = deferred_late_fixture(cx);
    cx.run_until_parked();
    let initial = snapshot_window(&target.window, cx);
    assert!(
        initial.primitive_counts.0 > 0,
        "deferred dependency probe did not paint a quad: {initial:?}"
    );
    assert!(
        initial.scene_operation_count > 0,
        "deferred dependency fixture did not paint any scene operation"
    );
    assert_eq!(target.view_renders.load(Ordering::Relaxed), 1);
    assert_eq!(target.root_renders.load(Ordering::Relaxed), 1);
    assert_eq!(target.prepaint_reads.load(Ordering::Relaxed), 1);
    assert_eq!(target.paint_reads.load(Ordering::Relaxed), 1);
    assert_eq!(target.last_signature.load(Ordering::Relaxed), 1);

    // Several root-only clean frames retain the view before either phase-only dependency changes.
    for _ in 0..4 {
        let root_before = target.root_renders.load(Ordering::Relaxed);
        let renders_before = target.view_renders.load(Ordering::Relaxed);
        let prepaint_before = target.prepaint_reads.load(Ordering::Relaxed);
        let paint_before = target.paint_reads.load(Ordering::Relaxed);
        notify_deferred_late_roots(&target, &reference, cx);
        assert_deferred_late_matches_reference(&target, &reference, cx);
        assert_eq!(target.root_renders.load(Ordering::Relaxed), root_before + 1);
        assert_eq!(target.view_renders.load(Ordering::Relaxed), renders_before);
        assert_eq!(
            target.prepaint_reads.load(Ordering::Relaxed),
            prepaint_before
        );
        assert_eq!(target.paint_reads.load(Ordering::Relaxed), paint_before);
        assert_eq!(target.last_signature.load(Ordering::Relaxed), 1);
    }

    // Updating the entity alone must invalidate its retained ancestor. The independent reference
    // receives the same logical write and is forced fresh only after the target frame is captured.
    let root_renders_before_model = target.root_renders.load(Ordering::Relaxed);
    let renders_before_model = target.view_renders.load(Ordering::Relaxed);
    let prepaint_before_model = target.prepaint_reads.load(Ordering::Relaxed);
    let paint_before_model = target.paint_reads.load(Ordering::Relaxed);
    for fixture in [&target, &reference] {
        fixture.model.update(cx, |model, cx| {
            model.value = 1;
            cx.notify();
        });
    }
    cx.run_until_parked();
    assert_eq!(target.last_signature.load(Ordering::Relaxed), (1 << 8) | 1);
    assert!(target.root_renders.load(Ordering::Relaxed) > root_renders_before_model);
    assert!(target.view_renders.load(Ordering::Relaxed) > renders_before_model);
    assert!(target.prepaint_reads.load(Ordering::Relaxed) > prepaint_before_model);
    assert!(target.paint_reads.load(Ordering::Relaxed) > paint_before_model);
    assert_deferred_late_matches_reference(&target, &reference, cx);

    // More clean replays ensure the late entity read stays attached to the retained owner rather
    // than being observed only by a recently rebuilt view.
    for _ in 0..4 {
        let root_before = target.root_renders.load(Ordering::Relaxed);
        let renders_before = target.view_renders.load(Ordering::Relaxed);
        let prepaint_before = target.prepaint_reads.load(Ordering::Relaxed);
        let paint_before = target.paint_reads.load(Ordering::Relaxed);
        notify_deferred_late_roots(&target, &reference, cx);
        assert_deferred_late_matches_reference(&target, &reference, cx);
        assert_eq!(target.root_renders.load(Ordering::Relaxed), root_before + 1);
        assert_eq!(target.view_renders.load(Ordering::Relaxed), renders_before);
        assert_eq!(
            target.prepaint_reads.load(Ordering::Relaxed),
            prepaint_before
        );
        assert_eq!(target.paint_reads.load(Ordering::Relaxed), paint_before);
        assert_eq!(target.last_signature.load(Ordering::Relaxed), (1 << 8) | 1);
    }

    // A global write alone must invalidate the deferred paint dependency too.
    let root_renders_before_global = target.root_renders.load(Ordering::Relaxed);
    let renders_before_global = target.view_renders.load(Ordering::Relaxed);
    let prepaint_before_global = target.prepaint_reads.load(Ordering::Relaxed);
    let paint_before_global = target.paint_reads.load(Ordering::Relaxed);
    cx.update(|app| app.set_global(OracleGlobal(2)));
    cx.run_until_parked();
    assert_eq!(target.last_signature.load(Ordering::Relaxed), (1 << 8) | 2);
    assert!(target.root_renders.load(Ordering::Relaxed) > root_renders_before_global);
    assert!(target.view_renders.load(Ordering::Relaxed) > renders_before_global);
    assert!(target.prepaint_reads.load(Ordering::Relaxed) > prepaint_before_global);
    assert!(target.paint_reads.load(Ordering::Relaxed) > paint_before_global);
    assert_deferred_late_matches_reference(&target, &reference, cx);
}

struct DeferredA11yButton {
    hits: Arc<AtomicUsize>,
    renders: Arc<AtomicUsize>,
    label: String,
}

impl Render for DeferredA11yButton {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        self.renders.fetch_add(1, Ordering::Relaxed);
        let hits = self.hits.clone();
        div().child(
            deferred(
                div()
                    .id("deferred-a11y-button")
                    .role(accesskit::Role::Button)
                    .aria_label(self.label.clone())
                    .on_a11y_action(accesskit::Action::Click, move |_, _, _| {
                        hits.fetch_add(1, Ordering::Relaxed);
                    })
                    .w(px(120.))
                    .h(px(32.))
                    .child(self.label.clone()),
            )
            .priority(1),
        )
    }
}

struct DeferredA11yRoot {
    button: Entity<DeferredA11yButton>,
    revision: usize,
}

impl Render for DeferredA11yRoot {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .child(format!("parent revision {}", self.revision))
            .child(self.button.clone())
    }
}

#[gpui::test]
fn retained_deferred_accessibility_tree_and_action_survive_clean_replays(cx: &mut TestAppContext) {
    let hits = Arc::new(AtomicUsize::new(0));
    let renders = Arc::new(AtomicUsize::new(0));
    let button = cx.new({
        let hits = hits.clone();
        let renders = renders.clone();
        move |_| DeferredA11yButton {
            hits,
            renders,
            label: "Deferred retained action".into(),
        }
    });
    let button_entity = button.clone();
    let window = cx.open_window(size(px(240.), px(120.)), move |_, _| DeferredA11yRoot {
        button,
        revision: 0,
    });
    cx.run_until_parked();
    window
        .update(cx, |_, window, _| window.set_a11y_forced(true))
        .unwrap();
    cx.run_until_parked();

    let reference_tree = a11y_tree_snapshot(&window, cx);
    assert!(
        reference_tree
            .to_string()
            .contains("Deferred retained action")
    );
    let button_id = window
        .update(cx, |_, window, _| {
            window
                .a11y_tree()
                .expect("forced accessibility update is missing")
                .nodes
                .iter()
                .find_map(|(node_id, node)| {
                    (node.role() == accesskit::Role::Button
                        && node.supports_action(accesskit::Action::Click))
                    .then_some(*node_id)
                })
                .expect("deferred button is missing from the accessibility tree")
        })
        .unwrap();
    renders.store(0, Ordering::Relaxed);

    for replay in 0..4 {
        window
            .update(cx, |root, _, cx| {
                root.revision += 1;
                cx.notify();
            })
            .unwrap();
        cx.run_until_parked();
        assert_eq!(renders.load(Ordering::Relaxed), 0);

        let retained_tree = a11y_tree_snapshot(&window, cx);
        assert_eq!(retained_tree, reference_tree, "replay={replay}");
        window
            .update(cx, |_, window, cx| {
                window.perform_a11y_action(button_id, accesskit::Action::Click, None, cx);
            })
            .unwrap();
        assert_eq!(hits.load(Ordering::Relaxed), replay * 2 + 1);

        // Compare against a complete rebuild after each cached frame. The next root-only
        // notification must still leave the deferred child view clean.
        window.update(cx, |_, window, _| window.refresh()).unwrap();
        cx.run_until_parked();
        let rebuilt_tree = a11y_tree_snapshot(&window, cx);
        assert_eq!(
            rebuilt_tree, reference_tree,
            "full refresh after replay={replay}"
        );
        window
            .update(cx, |_, window, cx| {
                window.perform_a11y_action(button_id, accesskit::Action::Click, None, cx);
            })
            .unwrap();
        assert_eq!(hits.load(Ordering::Relaxed), (replay + 1) * 2);
        renders.store(0, Ordering::Relaxed);
    }

    // A partial child rebuild replaces both the accessible label and its action listener while
    // keeping the stable element identity. Its retained result must match a fresh tree too.
    button_entity.update(cx, |button, cx| {
        button.label = "Updated deferred action".into();
        cx.notify();
    });
    cx.run_until_parked();
    assert_eq!(renders.load(Ordering::Relaxed), 1);
    let updated_tree = a11y_tree_snapshot(&window, cx);
    assert!(updated_tree.to_string().contains("Updated deferred action"));
    assert!(
        !updated_tree
            .to_string()
            .contains("Deferred retained action")
    );
    let updated_button_id = window
        .update(cx, |_, window, _| {
            window
                .a11y_tree()
                .expect("updated accessibility update is missing")
                .nodes
                .iter()
                .find_map(|(node_id, node)| {
                    (node.role() == accesskit::Role::Button
                        && node.supports_action(accesskit::Action::Click))
                    .then_some(*node_id)
                })
                .expect("updated deferred button is missing from the accessibility tree")
        })
        .unwrap();
    window
        .update(cx, |_, window, cx| {
            window.perform_a11y_action(updated_button_id, accesskit::Action::Click, None, cx);
        })
        .unwrap();
    assert_eq!(hits.load(Ordering::Relaxed), 9);
    window.update(cx, |_, window, _| window.refresh()).unwrap();
    cx.run_until_parked();
    let refreshed_tree = a11y_tree_snapshot(&window, cx);
    assert_eq!(refreshed_tree, updated_tree);
    window
        .update(cx, |_, window, cx| {
            window.perform_a11y_action(updated_button_id, accesskit::Action::Click, None, cx);
        })
        .unwrap();
    assert_eq!(hits.load(Ordering::Relaxed), 10);
}

struct PublicMeasureProbe {
    model: Entity<Model>,
    arena_element: Option<crate::AnyElement>,
    lifetime_tokens: Rc<RefCell<Vec<std::sync::Weak<()>>>>,
    measure_count: Rc<RefCell<usize>>,
    last_width: Rc<RefCell<Pixels>>,
}

impl IntoElement for PublicMeasureProbe {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }
}

impl Element for PublicMeasureProbe {
    type RequestLayoutState = ();
    type PrepaintState = ();

    fn id(&self) -> Option<ElementId> {
        Some("public-measure-probe".into())
    }

    fn source_location(&self) -> Option<&'static std::panic::Location<'static>> {
        None
    }

    fn request_layout(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&crate::InspectorElementId>,
        window: &mut Window,
        _cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState) {
        let model = self.model.clone();
        let arena_element = RefCell::new(self.arena_element.take().unwrap());
        let token = Arc::new(());
        self.lifetime_tokens
            .borrow_mut()
            .push(Arc::downgrade(&token));
        let measure_count = self.measure_count.clone();
        let last_width = self.last_width.clone();
        let layout_id = window.request_measured_layout(Style::default(), move |_, _, _, cx| {
            // The public callback is frame-bound. It may close over an AnyElement allocated in
            // this frame's arena, so forcing the downcast on every measure also catches a stale
            // callback accidentally retained into the next frame.
            assert!(
                arena_element
                    .borrow_mut()
                    .downcast_mut::<crate::Div>()
                    .is_some()
            );
            let _keep_alive_until_callback_drop = &token;
            *measure_count.borrow_mut() += 1;
            let width = model.read(cx).measured_width;
            *last_width.borrow_mut() = width;
            size(width, px(12.))
        });
        (layout_id, ())
    }

    fn prepaint(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&crate::InspectorElementId>,
        _bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        _window: &mut Window,
        _cx: &mut App,
    ) -> Self::PrepaintState {
    }

    fn paint(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&crate::InspectorElementId>,
        bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        _prepaint: &mut Self::PrepaintState,
        window: &mut Window,
        _cx: &mut App,
    ) {
        window.paint_quad(fill(bounds, rgb(0x345c99)));
    }
}

struct PublicMeasureView {
    model: Entity<Model>,
    renders: Rc<RefCell<usize>>,
    lifetime_tokens: Rc<RefCell<Vec<std::sync::Weak<()>>>>,
    measure_count: Rc<RefCell<usize>>,
    last_width: Rc<RefCell<Pixels>>,
}

impl Render for PublicMeasureView {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        *self.renders.borrow_mut() += 1;
        div().size_full().child(PublicMeasureProbe {
            model: self.model.clone(),
            arena_element: Some(div().w(px(19.)).h(px(9.)).into_any_element()),
            lifetime_tokens: self.lifetime_tokens.clone(),
            measure_count: self.measure_count.clone(),
            last_width: self.last_width.clone(),
        })
    }
}

struct PublicMeasureRoot {
    probe: Option<Entity<PublicMeasureView>>,
}

impl Render for PublicMeasureRoot {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        let root = div().size_full();
        if let Some(probe) = self.probe.as_ref() {
            root.child(probe.clone())
        } else {
            root
        }
    }
}

#[gpui::test]
fn public_measure_callbacks_are_frame_bound_and_release_captures(cx: &mut TestAppContext) {
    let model = cx.new(|_| Model {
        value: 0,
        measured_width: px(48.),
    });
    let weak_model = model.downgrade();
    let model_for_update = model.clone();
    let renders = Rc::new(RefCell::new(0));
    let lifetime_tokens = Rc::new(RefCell::new(Vec::new()));
    let measure_count = Rc::new(RefCell::new(0));
    let last_width = Rc::new(RefCell::new(px(0.)));
    let probe = cx.new({
        let model = model.clone();
        let renders = renders.clone();
        let lifetime_tokens = lifetime_tokens.clone();
        let measure_count = measure_count.clone();
        let last_width = last_width.clone();
        move |_| PublicMeasureView {
            model,
            renders,
            lifetime_tokens,
            measure_count,
            last_width,
        }
    });
    drop(model);

    let window = cx.open_window(size(px(180.), px(100.)), move |_, _| PublicMeasureRoot {
        probe: Some(probe),
    });
    cx.run_until_parked();
    assert_eq!(*renders.borrow(), 1);
    assert!(*measure_count.borrow() > 0);
    assert_eq!(*last_width.borrow(), px(48.));
    assert!(
        lifetime_tokens
            .borrow()
            .iter()
            .all(|token| token.upgrade().is_none())
    );
    assert!(weak_model.upgrade().is_some());

    // A measured model notification alone wakes and remeasures the window; no root notify is
    // needed because the measurement callback registered the model dependency with the app.
    let measures_before_model_update = *measure_count.borrow();
    model_for_update.update(cx, |model, cx| {
        model.measured_width = px(77.);
        cx.notify();
    });
    cx.run_until_parked();
    assert_eq!(*renders.borrow(), 2);
    assert!(*measure_count.borrow() > measures_before_model_update);
    assert_eq!(*last_width.borrow(), px(77.));

    // A public arbitrary measure closure cannot be memoized with its frame-arena capture.
    for expected_render in 3..=13 {
        window.update(cx, |_root, _, cx| cx.notify()).unwrap();
        cx.run_until_parked();
        assert_eq!(*renders.borrow(), expected_render);
        assert!(
            lifetime_tokens
                .borrow()
                .iter()
                .all(|token| token.upgrade().is_none())
        );
    }
    drop(model_for_update);

    let removed = window
        .update(cx, |root, _, cx| {
            let removed = root.probe.take();
            cx.notify();
            removed
        })
        .unwrap();
    drop(removed);
    // Entity handles dropped during a window update are released by the next App update.
    cx.update(|_| {});
    cx.run_until_parked();
    assert!(weak_model.upgrade().is_none());
    assert!(
        lifetime_tokens
            .borrow()
            .iter()
            .all(|token| token.upgrade().is_none())
    );
}

struct IntrinsicChild {
    renders: Rc<RefCell<usize>>,
    text: Entity<IntrinsicText>,
}

struct IntrinsicText {
    generation: usize,
    renders: Rc<RefCell<usize>>,
}

impl Render for IntrinsicText {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        *self.renders.borrow_mut() += 1;
        let text =
            "An intrinsic nested entity wraps this deliberately long paragraph as its parent. "
                .repeat(5 + self.generation % 2);
        div()
            .w_full()
            .debug_selector(|| "INTRINSIC_TEXT".into())
            .child(div().w_full().child(text))
    }
}

impl Render for IntrinsicChild {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        *self.renders.borrow_mut() += 1;
        div()
            .flex()
            .flex_col()
            .debug_selector(|| "INTRINSIC_CHILD".into())
            .child(self.text.clone())
    }
}

struct IntrinsicRoot {
    width: Pixels,
    leading_height: Pixels,
    trailing_height: Pixels,
    child: Entity<IntrinsicChild>,
}

impl Render for IntrinsicRoot {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("intrinsic-parent")
            .debug_selector(|| "INTRINSIC_PARENT".into())
            .flex()
            .flex_col()
            .w(self.width)
            .child(
                div()
                    .debug_selector(|| "INTRINSIC_LEADING".into())
                    .w_full()
                    .h(self.leading_height)
                    .bg(rgb(0x416e9c)),
            )
            .child(self.child.clone())
            .child(
                div()
                    .debug_selector(|| "INTRINSIC_TRAILING".into())
                    .w_full()
                    .h(self.trailing_height)
                    .bg(rgb(0xb2743e)),
            )
    }
}

struct IntrinsicFixture {
    window: WindowHandle<IntrinsicRoot>,
    text: Entity<IntrinsicText>,
    child_renders: Rc<RefCell<usize>>,
    text_renders: Rc<RefCell<usize>>,
}

fn intrinsic_fixture(cx: &mut TestAppContext) -> IntrinsicFixture {
    let child_renders = Rc::new(RefCell::new(0));
    let text_renders = Rc::new(RefCell::new(0));
    let text = cx.new({
        let text_renders = text_renders.clone();
        |_| IntrinsicText {
            generation: 0,
            renders: text_renders,
        }
    });
    let child = cx.new({
        let child_renders = child_renders.clone();
        let text = text.clone();
        move |_| IntrinsicChild {
            renders: child_renders,
            text,
        }
    });
    let window = cx.open_window(size(px(520.), px(420.)), move |_, _| IntrinsicRoot {
        width: px(430.),
        leading_height: px(18.),
        trailing_height: px(12.),
        child,
    });
    IntrinsicFixture {
        window,
        text,
        child_renders,
        text_renders,
    }
}

fn assert_intrinsic_matches_reference(
    retained: &IntrinsicFixture,
    reference: &IntrinsicFixture,
    cx: &mut TestAppContext,
) -> FrameSnapshot {
    let retained_frame = snapshot_window(&retained.window, cx);
    // Refresh an independent window so it cannot repair the retained window's Taffy parentage or
    // view ranges before the next retained frame is tested.
    reference
        .window
        .update(cx, |_, window, _| window.refresh())
        .unwrap();
    cx.run_until_parked();
    let reference_frame = snapshot_window(&reference.window, cx);
    assert!(
        retained_frame == reference_frame,
        "retained intrinsic frame differs from independent full refresh: retained bounds={:?} / ops={}, full bounds={:?} / ops={}",
        retained_frame.debug_bounds,
        retained_frame.scene_operation_count,
        reference_frame.debug_bounds,
        reference_frame.scene_operation_count,
    );
    retained_frame
}

fn update_intrinsic_pair(
    retained: &IntrinsicFixture,
    reference: &IntrinsicFixture,
    cx: &mut TestAppContext,
    update: impl Fn(&mut IntrinsicRoot),
) {
    for fixture in [retained, reference] {
        fixture
            .window
            .update(cx, |root, _, cx| {
                update(root);
                cx.notify();
            })
            .unwrap();
    }
    cx.run_until_parked();
}

fn update_intrinsic_text_pair(
    retained: &IntrinsicFixture,
    reference: &IntrinsicFixture,
    cx: &mut TestAppContext,
) {
    for fixture in [retained, reference] {
        fixture.text.update(cx, |text, cx| {
            text.generation += 1;
            cx.notify();
        });
    }
    cx.run_until_parked();
}

fn exercise_intrinsic_replays(
    retained: &IntrinsicFixture,
    reference: &IntrinsicFixture,
    cx: &mut TestAppContext,
) -> FrameSnapshot {
    let child_before = *retained.child_renders.borrow();
    let text_before = *retained.text_renders.borrow();
    let mut child_after_previous_frame = child_before;
    let mut text_after_previous_frame = text_before;
    for replay in 0..4 {
        update_intrinsic_pair(retained, reference, cx, |_| {});
        let child_after = *retained.child_renders.borrow();
        let text_after = *retained.text_renders.borrow();
        if replay == 0 {
            // Assigned-size fallback may repair the retained parent tree on its first subsequent
            // frame. It can rebuild each affected view once, after which clean replays must skip it.
            assert!(child_after <= child_before + 1);
            assert!(text_after <= text_before + 1);
        } else {
            assert_eq!(child_after, child_after_previous_frame);
            assert_eq!(text_after, text_after_previous_frame);
        }
        child_after_previous_frame = child_after;
        text_after_previous_frame = text_after;
        assert_intrinsic_matches_reference(retained, reference, cx);
    }

    // A nested-only update after the clean replays detects a stale or detached Taffy parent.
    let text_before_update = *retained.text_renders.borrow();
    let child_before_update = *retained.child_renders.borrow();
    update_intrinsic_text_pair(retained, reference, cx);
    assert_eq!(*retained.text_renders.borrow(), text_before_update + 1);
    assert!(*retained.child_renders.borrow() <= child_before_update + 1);
    assert_intrinsic_matches_reference(retained, reference, cx)
}

#[gpui::test]
fn retained_intrinsic_view_tracks_parent_width_and_sibling_layout(cx: &mut TestAppContext) {
    let retained = intrinsic_fixture(cx);
    let reference = intrinsic_fixture(cx);
    cx.run_until_parked();
    let wide = assert_intrinsic_matches_reference(&retained, &reference, cx);
    let wide_parent = wide.debug_bounds["INTRINSIC_PARENT"];
    let wide_child = wide.debug_bounds["INTRINSIC_CHILD"];
    assert!(wide.debug_bounds["INTRINSIC_TEXT"].size.height > px(0.));
    assert!(wide_child.size.height > px(0.));

    // The parent width changes without resizing either window or notifying either child entity.
    // The reference is reconstructed independently after every target frame, so it cannot repair
    // the retained target's Taffy parentage between its root-only replay frames.
    update_intrinsic_pair(&retained, &reference, cx, |root| root.width = px(238.25));
    let narrow_first_frame = assert_intrinsic_matches_reference(&retained, &reference, cx);
    let narrow = exercise_intrinsic_replays(&retained, &reference, cx);
    let narrow_parent = narrow.debug_bounds["INTRINSIC_PARENT"];
    let narrow_child = narrow.debug_bounds["INTRINSIC_CHILD"];
    assert_eq!(
        narrow.debug_bounds["INTRINSIC_TEXT"].size.width,
        narrow_parent.size.width
    );
    assert_ne!(wide_parent.size.width, narrow_parent.size.width);
    assert_eq!(narrow_child.size.width, narrow_parent.size.width);
    assert_eq!(
        narrow_first_frame.debug_bounds["INTRINSIC_CHILD"]
            .size
            .width,
        narrow_parent.size.width
    );

    update_intrinsic_pair(&retained, &reference, cx, |root| root.width = px(173.75));
    let narrower_first_frame = assert_intrinsic_matches_reference(&retained, &reference, cx);
    let narrower = exercise_intrinsic_replays(&retained, &reference, cx);
    let narrower_child = narrower.debug_bounds["INTRINSIC_CHILD"];
    assert_eq!(
        narrower.debug_bounds["INTRINSIC_TEXT"].size.width,
        narrower.debug_bounds["INTRINSIC_PARENT"].size.width
    );
    assert_eq!(
        narrower_child.size.width,
        narrower.debug_bounds["INTRINSIC_PARENT"].size.width
    );
    assert_eq!(
        narrower_first_frame.debug_bounds["INTRINSIC_CHILD"]
            .size
            .width,
        narrower.debug_bounds["INTRINSIC_PARENT"].size.width
    );

    update_intrinsic_pair(&retained, &reference, cx, |root| root.width = px(475.));
    let wider_first_frame = assert_intrinsic_matches_reference(&retained, &reference, cx);
    let wider = exercise_intrinsic_replays(&retained, &reference, cx);
    let wider_child = wider.debug_bounds["INTRINSIC_CHILD"];
    assert!(wider_child.size.width > narrower_child.size.width);
    assert_eq!(
        wider_first_frame.debug_bounds["INTRINSIC_CHILD"].size.width,
        wider.debug_bounds["INTRINSIC_PARENT"].size.width
    );

    // Changing both siblings' heights moves the retained child and trailing sibling while the
    // window-constrained parent's height stays fixed.
    update_intrinsic_pair(&retained, &reference, cx, |root| {
        root.leading_height = px(47.);
        root.trailing_height = px(31.);
    });
    let sibling_changed_first_frame = assert_intrinsic_matches_reference(&retained, &reference, cx);
    let sibling_changed = exercise_intrinsic_replays(&retained, &reference, cx);
    assert_eq!(
        sibling_changed.debug_bounds["INTRINSIC_CHILD"].origin.y,
        wider.debug_bounds["INTRINSIC_CHILD"].origin.y + px(29.),
    );
    assert_eq!(
        sibling_changed.debug_bounds["INTRINSIC_TRAILING"].origin.y,
        wider.debug_bounds["INTRINSIC_TRAILING"].origin.y + px(29.),
    );
    assert_eq!(
        sibling_changed.debug_bounds["INTRINSIC_PARENT"].size.height,
        wider.debug_bounds["INTRINSIC_PARENT"].size.height,
    );
    assert_eq!(
        sibling_changed_first_frame.debug_bounds["INTRINSIC_CHILD"]
            .origin
            .y,
        wider.debug_bounds["INTRINSIC_CHILD"].origin.y + px(29.)
    );
}

struct ManualPropsView {
    model: Entity<Model>,
    label: String,
    width: Pixels,
    renders: Arc<AtomicUsize>,
}

impl View for ManualPropsView {
    fn entity_id(&self) -> Option<crate::EntityId> {
        Some(self.model.entity_id())
    }

    fn render(self, _window: &mut Window, cx: &mut App) -> impl IntoElement {
        self.renders.fetch_add(1, Ordering::Relaxed);
        let value = self.model.read(cx).value;
        let label = self.label;
        let selector = label.clone();
        let content = format!("{label}: {value}");
        div()
            .id("manual-props-view")
            .debug_selector(move || format!("MANUAL_VIEW_{selector}"))
            .w(self.width)
            .h(px(28.))
            .child(content)
    }
}

struct ManualPropsRoot {
    model: Entity<Model>,
    label: String,
    width: Pixels,
    view_renders: Arc<AtomicUsize>,
}

impl Render for ManualPropsRoot {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().size_full().child(ViewElement::new(ManualPropsView {
            model: self.model.clone(),
            label: self.label.clone(),
            width: self.width,
            renders: self.view_renders.clone(),
        }))
    }
}

#[gpui::test]
fn manual_identity_view_renders_when_parent_supplied_props_change(cx: &mut TestAppContext) {
    let model = cx.new(|_| Model {
        value: 7,
        measured_width: px(10.),
    });
    let renders = Arc::new(AtomicUsize::new(0));
    let window = cx.open_window(size(px(260.), px(100.)), {
        let renders = renders.clone();
        move |_, _| ManualPropsRoot {
            model,
            label: "first".into(),
            width: px(188.),
            view_renders: renders,
        }
    });
    cx.run_until_parked();
    let initial = snapshot_window(&window, cx);
    assert!(initial.debug_bounds.contains_key("MANUAL_VIEW_first"));
    assert_eq!(renders.load(Ordering::Relaxed), 1);

    // The backing entity is unchanged and unnotified. The custom View has the same identity but
    // receives new props from its parent, so its new wrapper must render rather than replay stale
    // content or width.
    window
        .update(cx, |root, _, cx| {
            root.label = "second".into();
            root.width = px(123.5);
            cx.notify();
        })
        .unwrap();
    cx.run_until_parked();
    let retained = snapshot_window(&window, cx);
    assert!(retained.debug_bounds.contains_key("MANUAL_VIEW_second"));
    assert!(!retained.debug_bounds.contains_key("MANUAL_VIEW_first"));
    assert_ne!(
        retained.debug_bounds["MANUAL_VIEW_second"].size.width,
        initial.debug_bounds["MANUAL_VIEW_first"].size.width
    );
    assert_eq!(renders.load(Ordering::Relaxed), 2);

    window.update(cx, |_, window, _| window.refresh()).unwrap();
    cx.run_until_parked();
    assert_eq!(retained, snapshot_window(&window, cx));
}

struct AutoDirectionPanel {
    text: String,
    renders: Arc<AtomicUsize>,
}

impl Render for AutoDirectionPanel {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        self.renders.fetch_add(1, Ordering::Relaxed);
        div()
            .id("auto-direction-panel")
            .debug_selector(|| "AUTO_DIRECTION_PANEL".to_string())
            .w(px(76.))
            .h(px(30.))
            .child(self.text.clone())
    }
}

struct AutoDirectionRoot {
    panel: Entity<AutoDirectionPanel>,
}

impl Render for AutoDirectionRoot {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .direction(LayoutDirection::Auto)
            .child(
                self.panel
                    .clone()
                    .cached(StyleRefinement::default().w(px(76.)).h(px(30.))),
            )
            .child(
                div()
                    .id("auto-direction-marker")
                    .debug_selector(|| "AUTO_DIRECTION_MARKER".to_string())
                    .w(px(18.))
                    .h(px(30.)),
            )
    }
}

#[gpui::test]
fn cached_view_auto_direction_contribution_survives_replay_and_text_updates(
    cx: &mut TestAppContext,
) {
    let renders = Arc::new(AtomicUsize::new(0));
    let panel = cx.new({
        let renders = renders.clone();
        |_| AutoDirectionPanel {
            text: "שלום".into(),
            renders,
        }
    });
    let window = cx.open_window(size(px(180.), px(45.)), {
        let panel = panel.clone();
        move |_, _| AutoDirectionRoot {
            panel: panel.clone(),
        }
    });
    cx.run_until_parked();

    let rtl = snapshot_window(&window, cx);
    assert_eq!(renders.load(Ordering::Relaxed), 1);
    assert!(
        rtl.debug_bounds["AUTO_DIRECTION_MARKER"].origin.x
            < rtl.debug_bounds["AUTO_DIRECTION_PANEL"].origin.x,
        "automatic direction should follow the cached Hebrew child"
    );

    window.update(cx, |_, _, cx| cx.notify()).unwrap();
    cx.run_until_parked();
    let replay = snapshot_window(&window, cx);
    assert_eq!(renders.load(Ordering::Relaxed), 1);
    assert_eq!(
        rtl, replay,
        "cached auto-direction output should replay unchanged"
    );

    panel.update(cx, |panel, cx| {
        panel.text = "English".into();
        cx.notify();
    });
    cx.run_until_parked();
    let ltr = snapshot_window(&window, cx);
    assert_eq!(renders.load(Ordering::Relaxed), 2);
    assert!(
        ltr.debug_bounds["AUTO_DIRECTION_MARKER"].origin.x
            > ltr.debug_bounds["AUTO_DIRECTION_PANEL"].origin.x,
        "updated automatic direction should follow the cached Latin child"
    );
    window.update(cx, |_, window, _| window.refresh()).unwrap();
    cx.run_until_parked();
    assert_eq!(ltr, snapshot_window(&window, cx));
}

struct NotifyDuringPaintView {
    value: usize,
    notify_on_next_paint: bool,
    rendered_values: Rc<RefCell<Vec<usize>>>,
}

impl Render for NotifyDuringPaintView {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        self.rendered_values.borrow_mut().push(self.value);
        let view = cx.entity();
        let notify_on_next_paint = self.notify_on_next_paint;
        let mut root = div().size_full().child(self.value.to_string());
        if notify_on_next_paint {
            root = root.child(
                canvas(
                    |_, _, _| (),
                    move |_, _, _, cx| {
                        view.update(cx, |view, cx| {
                            if view.notify_on_next_paint {
                                view.notify_on_next_paint = false;
                                view.value = 1;
                                cx.notify();
                            }
                        });
                    },
                )
                .size_full(),
            );
        }
        root
    }
}

struct NotifyDuringPaintRoot {
    view: Entity<NotifyDuringPaintView>,
}

impl Render for NotifyDuringPaintRoot {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().size_full().child(self.view.clone())
    }
}

#[gpui::test]
fn notify_during_paint_schedules_followup_frame(cx: &mut TestAppContext) {
    let rendered_values = Rc::new(RefCell::new(Vec::new()));
    let view = cx.new({
        let rendered_values = rendered_values.clone();
        move |_| NotifyDuringPaintView {
            value: 0,
            notify_on_next_paint: false,
            rendered_values,
        }
    });
    cx.open_window(size(px(120.), px(80.)), {
        let view = view.clone();
        move |_, _| NotifyDuringPaintRoot { view: view.clone() }
    });
    cx.run_until_parked();
    assert_eq!(*rendered_values.borrow(), [0]);

    view.update(cx, |view, cx| {
        view.notify_on_next_paint = true;
        cx.notify();
    });
    cx.run_until_parked();

    assert_eq!(
        *rendered_values.borrow(),
        [0, 0, 1],
        "a notification from a live paint callback must schedule another frame"
    );
}
