//! Headless snapshot corpus for the `examples/learn`, `examples/legacy`, and
//! `examples/bench` example UIs.
//!
//! The examples are `main()` programs that open a window and render a root view.
//! We never run those mains. Instead this harness draws a *mirrored* copy of each
//! example's root element tree on a headless window and snapshots the finished
//! [`crate::SceneArchive`] (quantized canonical JSON). Each case uses its example's
//! own window bounds (from its `main()`); for scrollable pages the frame is made tall
//! enough to fit the *whole* mirrored tree, so every mirrored section is pinned — this
//! is a deliberate snapshot-corpus choice (the example scrolls; a tall frame captures
//! the full mirror in one deterministic frame). The mirror is table driven — one
//! `impl IntoElement` builder per example — and each `example_*` case carries a
//! comment naming the `examples/.../*.rs` file it mirrors so drift can be audited.
//!
//! Determinism: the test platform uses [`crate::NoopTextSystem`] by default (no system
//! fonts), the window size is a fixed constant per case, the clock never advances
//! (animations/transitions are pinned at their initial state), and there is no GPU.
//! Snapshots are therefore hermetic: regenerate with `INSTA_UPDATE=always cargo test
//! -p gpui-ce --lib learn_snapshots` and verify with `INSTA_UPDATE=no cargo test -p
//! gpui-ce --lib learn_snapshots` (zero `.snap.new` files).
//!
//! Text honesty: [`crate::NoopTextSystem`] emits **no glyphs or atlas textures**, so every
//! text child paints as an empty layer. A text snapshot therefore pins the quad/underlay
//! structure around the text (sizes, weights, alignment boxes, decorations, overflow
//! clamping, line-height blocks) and the text's *absence* of glyphs — never the glyph
//! shapes themselves. The same applies to the `img`/`svg` children of the legacy cases:
//! the hermetic asset source returns `None`, so images decode to nothing.
//!
//! Bench honesty: the `examples/bench/*` examples are benchmark loops (2000 identical
//! paths, 10000 random quotes). The mirrors replicate each bench's *scene-building
//! pattern* at small scale — a handful of paths, a short deterministic table — never
//! the full benchmark loop. `bench_data_table` replaces the random quotes with fixed
//! per-row values so the snapshot is hermetic, and mirrors the example's *full*
//! 24-column FIELDS on a widened frame that pins every column (the real example clips
//! at its 1280-wide window); `bench_shadow` pins the whole `overflow_y_scroll` table
//! on a tall frame; `bench_paths` keeps the exact star geometry from the loop body but
//! draws five copies instead of 2000.
//!
//! Interactive-event honesty: `on_click`/`on_action`/`on_mouse_*` handlers are inert in
//! a static headless frame and are omitted from the mirrors; style refinements (hover,
//! focus, active, opacity) are kept because they pin the initial-state styles. The
//! legacy window-management mirrors (`focus_visible`, `tab_stop`) render their initial
//! focus state — focus sits on the app container, so no button shows a focus ring — and
//! `window_shadow` runs under `Decorations::Server`, so its client-decoration shadow
//! branch never paints headlessly.
//!
//! # Honest skips (OS services; would hang or panic headlessly)
//!
//! The following examples are intentionally *not* mirrored, with the service that
//! makes them non-hermetic:
//!
//! - `examples/learn/keyring.rs` — gh-keyring: OS keychain/secret service (libsecret,
//!   Keychain). No keyring in CI.
//! - `examples/learn/haptic_feedback.rs` — gh-haptics: OS haptic engine (NSHapticFeedback
//!   / HapticFeedbackManager). No haptics device headlessly.
//! - `examples/legacy/layer_shell.rs` — gh-layer-shell: Wayland layer-shell compositor
//!   protocol. No Wayland display in tests.
//! - `examples/legacy/window_positioning.rs`, `examples/window_movable.rs` — gh-window-mgmt:
//!   OS window manager operations (move/resize/focus/level). Headless test windows have no WM.
//! - `examples/system_notifications.rs` — gh-notifications: OS notification center.
//! - `examples/learn/async_tasks.rs` — gh-async: timer/executor timing. The scene would race
//!   with parked futures, so no single deterministic frame exists.
//! - `examples/legacy/gif_viewer.rs`, `examples/legacy/image_loading.rs`, and the image
//!   + svg examples under `examples/legacy/image/` and `examples/legacy/svg/` — gh-assets:
//!   image/SVG decoding from disk and URLs. The hermetic asset source returns `None`, so
//!   the mirror would only capture an empty placeholder rectangle — skipping avoids a
//!   misleading snapshot.
//! - `examples/legacy/on_window_close_quit.rs` — gh-window-mgmt: window close/quit
//!   lifecycle driven by OS window events.
//! - `examples/legacy/shadow.rs` — does not exist; the shadow-elevations table lives at
//!   `examples/bench/shadow.rs` and is mirrored there as `bench_shadow`.
//!
//! Seg1 covered the learn examples plus `legacy/opacity` and `legacy/gradient` (already
//! in this file). Seg2 adds the remaining static legacy mirrors (`hello_world`,
//! `scrollable`, `tree`, `uniform_list`, `focus_visible`, `tab_stop`, `window`,
//! `window_shadow`) and small-scale bench mirrors (`bench_shadow`, `bench_pattern`,
//! `bench_paths`, `bench_data_table`).

use std::time::Duration;

use palette::{IntoColor, WithAlpha};

use crate::colors::Colors;
use crate::util::FluentBuilder as _;
use crate::{
    Animation, AnimationExt as _, AnyElement, App, AppContext, Background, Bounds, BoxShadow,
    Canvas, ColorExt, ColorSpace, Context, CursorStyle, Decorations, Div, DurationWithEasing,
    ElementId, FocusHandle, FontStyle, FontWeight, Half, Hsla, IntoElement, Lerp, Path,
    PathBuilder, Pixels, Point, Render, Rgba, SceneArchive, Size, Stateful, StyledText,
    TestAppContext, Transformation, Window, black, blue, bounce, canvas, deferred, div,
    ease_in_out, fill, green, hsla, linear, linear_color_stop, linear_gradient, pattern_slash,
    percentage, point, prelude::*, px, red, relative, rgb, rgba, size, svg, transparent_black,
    uniform_list, white, yellow,
};

/// SVG glyph used by the animation example; won't decode with the hermetic asset source.
const ARROW_CIRCLE_SVG: &str = concat!(
    env!("CARGO_MANIFEST_DIR"),
    "/examples/legacy/image/arrow_circle.svg"
);

/// A view that renders an arbitrary root element on the headless window.
struct ExampleView {
    build: Box<dyn Fn(&mut Window, &mut App) -> AnyElement>,
}

impl Render for ExampleView {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        (self.build)(window, cx)
    }
}

/// Draws the mirrored root on a fresh headless window and snapshots the finished scene.
fn snapshot_case(
    cx: &mut TestAppContext,
    name: &'static str,
    window_size: Size<Pixels>,
    build: Box<dyn Fn(&mut Window, &mut App) -> AnyElement>,
) {
    let window: crate::AnyWindowHandle = cx
        .open_window(window_size, move |_, _| ExampleView { build })
        .into();
    cx.update_window(window, |_, window, cx| window.draw(cx).clear(cx))
        .unwrap();
    let archive = cx
        .update_window(window, |_, window, _cx| {
            SceneArchive::from_scene(&window.rendered_frame.scene)
        })
        .unwrap();
    assert!(
        !archive.commands.is_empty(),
        "{name}: mirrored example rendered an empty scene"
    );
    insta::assert_snapshot!(name, archive.to_canonical_json());
}

// Shared page-chrome helper mirrored verbatim from every learn example's header block.
fn title_block(colors: &Colors, title: &'static str, subtitle: &'static str) -> Div {
    div()
        .flex()
        .flex_col()
        .gap_1()
        .child(
            div()
                .text_xl()
                .font_weight(FontWeight::BOLD)
                .text_color(colors.text)
                .child(title),
        )
        .child(div().text_sm().text_color(colors.disabled).child(subtitle))
}

// ============================================================================
// example_interactive_elements — mirrors examples/learn/interactive_elements.rs
// Four demo cards (click, hover, mouse, drag-drop) in their initial static state
// (counts 0, not hovered, empty event log, no dropped item).
// ============================================================================

fn demo_card(
    colors: &Colors,
    title: &'static str,
    hint: &'static str,
    body: impl IntoElement,
) -> Div {
    div()
        .flex()
        .flex_col()
        .gap_3()
        .p_4()
        .rounded_lg()
        .bg(colors.container)
        .child(
            div()
                .text_sm()
                .font_weight(FontWeight::SEMIBOLD)
                .text_color(colors.text)
                .child(title),
        )
        .child(div().text_xs().text_color(colors.disabled).child(hint))
        .child(body)
}

fn click_demo(colors: &Colors) -> Div {
    let selected = colors.selected;
    let selected_text = colors.selected_text;
    let disabled = colors.disabled;
    demo_card(
        colors,
        "Click Events",
        "Single click, double click, or triple click the button",
        div()
            .flex()
            .flex_col()
            .gap_3()
            .child(
                div()
                    .id("click-target")
                    .px_4()
                    .py_2()
                    .rounded_md()
                    .bg(selected)
                    .text_color(selected_text)
                    .text_sm()
                    .cursor_pointer()
                    .hover(move |s| s.bg(selected))
                    .active(move |s| s.bg(selected))
                    .child("Click Me!"),
            )
            .child(
                div()
                    .text_xs()
                    .text_color(disabled)
                    .child("Total clicks: 0"),
            )
            .child(div().text_xs().text_color(disabled).child("Last: None")),
    )
}

fn hover_demo(colors: &Colors) -> Div {
    let selected = colors.selected;
    let border = colors.border;
    let text = colors.text;
    let disabled = colors.disabled;
    demo_card(
        colors,
        "Hover Events",
        "Move your mouse in and out of the target",
        div()
            .flex()
            .flex_col()
            .gap_3()
            .child(
                div()
                    .id("hover-target")
                    .px_4()
                    .py_3()
                    .rounded_md()
                    .border_2()
                    .border_color(border)
                    .bg(selected)
                    .text_color(text)
                    .text_sm()
                    .cursor_pointer()
                    .child("Hover Over Me"),
            )
            .child(
                div()
                    .text_xs()
                    .text_color(disabled)
                    .mt_2()
                    .child("Times hovered: 0"),
            ),
    )
}

fn mouse_events_demo(colors: &Colors) -> Div {
    let selected = colors.selected;
    let border = colors.border;
    let text = colors.text;
    demo_card(
        colors,
        "Mouse Events",
        "Move and click within the target area",
        div()
            .id("mouse-events-target")
            .h_20()
            .rounded_md()
            .border_2()
            .border_color(border)
            .bg(selected)
            .flex()
            .items_center()
            .justify_center()
            .text_sm()
            .text_color(text)
            .child("Position: —"),
    )
}

fn drag_drop_demo(colors: &Colors) -> Div {
    let border = colors.border;
    let disabled = colors.disabled;
    demo_card(
        colors,
        "Drag and Drop",
        "Drag items to the drop zone below",
        div()
            .flex()
            .flex_col()
            .gap_3()
            .child(div().flex().gap_2().children((0..3).map(|index| {
                let color = [rgb(0xd32f2f), rgb(0x388e3c), rgb(0xf9a825)][index];
                div()
                    .id(("drag-item", index))
                    .px_3()
                    .py_2()
                    .rounded_md()
                    .border_2()
                    .border_color(color)
                    .text_color(color)
                    .text_xs()
                    .cursor_grab()
                    .hover(move |s| {
                        let c: Hsla = color.into_color();
                        s.bg(c.opacity(0.1))
                    })
                    .child(format!("Item {}", index + 1))
            })))
            .child(
                div()
                    .id("drop-target")
                    .mt_2()
                    .h_16()
                    .rounded_md()
                    .border_2()
                    .border_dashed()
                    .border_color(border)
                    .flex()
                    .items_center()
                    .justify_center()
                    .text_xs()
                    .text_color(disabled)
                    .child("Drop Zone"),
            ),
    )
}

fn example_interactive_elements(window: &mut Window, _cx: &mut App) -> impl IntoElement {
    let colors = Colors::for_appearance(window);
    div()
        .id("main")
        .size_full()
        .p_6()
        .bg(colors.background)
        .overflow_scroll()
        .child(
            div()
                .flex()
                .flex_col()
                .gap_6()
                .max_w(px(800.))
                .child(title_block(
                    &colors,
                    "Interactive Elements",
                    "Click, hover, mouse events, and drag-and-drop in GPUI",
                ))
                .child(
                    div()
                        .grid()
                        .grid_cols(2)
                        .gap_4()
                        .child(click_demo(&colors))
                        .child(hover_demo(&colors))
                        .child(mouse_events_demo(&colors))
                        .child(drag_drop_demo(&colors)),
                ),
        )
}

// ============================================================================
// example_creating_components — mirrors examples/learn/creating_components.rs
// Three stateful-counter approaches side by side, each at count 0. The state
// hooks (use_state / entity) are represented by their initial static value.
// ============================================================================

fn counter_card(
    colors: &Colors,
    id: &'static str,
    label: &'static str,
    decrement_id: &'static str,
    increment_id: &'static str,
) -> impl IntoElement {
    let container = colors.container;
    let text = colors.text;
    let disabled = colors.disabled;
    let selected_text = colors.selected_text;
    div()
        .id(id)
        .flex()
        .flex_col()
        .gap_2()
        .p_4()
        .rounded_lg()
        .bg(container)
        .child(div().text_sm().text_color(disabled).child(label))
        .child(div().text_2xl().text_color(text).child("0"))
        .child(
            div()
                .flex()
                .gap_2()
                .child(
                    div()
                        .id(decrement_id)
                        .px_3()
                        .py_1()
                        .rounded_md()
                        .bg(rgb(0xd32f2f))
                        .text_color(selected_text)
                        .cursor_pointer()
                        .hover(|s| s.bg(rgb(0xe04545)))
                        .child("−"),
                )
                .child(
                    div()
                        .id(increment_id)
                        .px_3()
                        .py_1()
                        .rounded_md()
                        .bg(rgb(0x388e3c))
                        .text_color(selected_text)
                        .cursor_pointer()
                        .hover(|s| s.bg(rgb(0x43a047)))
                        .child("+"),
                ),
        )
}

fn example_creating_components(window: &mut Window, _cx: &mut App) -> impl IntoElement {
    let colors = Colors::for_appearance(window);
    div()
        .id("main")
        .size_full()
        .flex()
        .flex_col()
        .gap_6()
        .p_8()
        .bg(colors.background)
        .overflow_scroll()
        .child(title_block(
            &colors,
            "Creating Components",
            "Three approaches to stateful components in GPUI",
        ))
        .child(
            div()
                .flex()
                .flex_row()
                .gap_4()
                .child(counter_card(
                    &colors,
                    "use-state-counter",
                    "use_state Counter",
                    "use-state-decrement",
                    "use-state-increment",
                ))
                .child(counter_card(
                    &colors,
                    "render-once-counter",
                    "RenderOnce Counter",
                    "render-once-decrement",
                    "render-once-increment",
                ))
                .child(counter_card(
                    &colors,
                    "render-counter",
                    "Render Counter",
                    "render-decrement",
                    "render-increment",
                )),
        )
}

// ============================================================================
// example_layout — mirrors examples/learn/layout.rs
// All nine sections mirrored: Flexbox Row/Column/Justify/Grow, Grid Basic/Spans,
// and the App Shell/Centering/Stack patterns.
// ============================================================================

fn block(label: &'static str, color: Hsla, text_color: Rgba) -> Div {
    div()
        .flex()
        .items_center()
        .justify_center()
        .bg(color)
        .border_1()
        .border_color(white().with_alpha(0.3))
        .rounded_md()
        .text_xs()
        .text_color(text_color)
        .child(label)
}

fn layout_section(
    colors: &Colors,
    title: &'static str,
    content: impl IntoElement,
) -> impl IntoElement {
    let surface: Hsla = colors.container.into_color();
    div()
        .flex()
        .flex_col()
        .gap_2()
        .p_3()
        .bg(surface.opacity(0.5))
        .rounded_lg()
        .child(
            div()
                .text_sm()
                .font_weight(FontWeight::SEMIBOLD)
                .text_color(colors.text)
                .child(title),
        )
        .child(content)
}

fn app_shell(colors: &Colors) -> Div {
    let border = colors.border;
    let surface = colors.container;
    let surface_hover = colors.selected;
    let text = colors.text;
    let text_muted = colors.disabled;
    let background = colors.background;
    div()
        .h_32()
        .flex()
        .flex_col()
        .border_1()
        .border_color(border)
        .rounded_md()
        .overflow_hidden()
        .child(
            div()
                .h_6()
                .flex()
                .items_center()
                .px_2()
                .bg(surface_hover)
                .text_xs()
                .text_color(text)
                .child("Header"),
        )
        .child(
            div()
                .flex_1()
                .flex()
                .child(
                    div()
                        .w_16()
                        .bg(surface)
                        .flex()
                        .items_center()
                        .justify_center()
                        .text_xs()
                        .text_color(text_muted)
                        .child("Side"),
                )
                .child(
                    div()
                        .flex_1()
                        .bg(background)
                        .flex()
                        .items_center()
                        .justify_center()
                        .text_xs()
                        .text_color(text_muted)
                        .child("Content"),
                ),
        )
}

fn stack(colors: &Colors) -> Div {
    let surface = colors.container;
    div()
        .h_20()
        .relative()
        .bg(surface)
        .rounded_md()
        .child(
            div()
                .absolute()
                .top_2()
                .left_2()
                .size_10()
                .bg(red().with_alpha(0.7))
                .rounded_md(),
        )
        .child(
            div()
                .absolute()
                .top_4()
                .left_4()
                .size_10()
                .bg(green().with_alpha(0.7))
                .rounded_md(),
        )
        .child(
            div()
                .absolute()
                .top_6()
                .left_6()
                .size_10()
                .bg(blue().with_alpha(0.7))
                .rounded_md(),
        )
}

fn flexbox_column(colors: &Colors) -> impl IntoElement {
    let text_muted = colors.disabled;
    let text = colors.selected_text;
    div()
        .flex()
        .flex_col()
        .gap_2()
        .child(
            div()
                .text_xs()
                .text_color(text_muted)
                .child("flex().flex_col().gap_2()"),
        )
        .child(
            div()
                .h_24()
                .flex()
                .flex_col()
                .gap_2()
                .child(block("A", red(), text).h_6())
                .child(block("B", green(), text).h_6())
                .child(block("C", blue(), text).h_6()),
        )
}

fn flexbox_justify(colors: &Colors) -> impl IntoElement {
    let text_muted = colors.disabled;
    let text = colors.selected_text;
    let surface = colors.container;
    div()
        .flex()
        .flex_col()
        .gap_2()
        .child(
            div()
                .text_xs()
                .text_color(text_muted)
                .child("justify_between / justify_center / justify_end"),
        )
        .child(
            div()
                .flex()
                .flex_col()
                .gap_1()
                .child(
                    div()
                        .flex()
                        .justify_between()
                        .p_1()
                        .bg(surface)
                        .rounded_sm()
                        .child(block("Start", red(), text).px_2().py_1())
                        .child(block("End", blue(), text).px_2().py_1()),
                )
                .child(
                    div()
                        .flex()
                        .justify_center()
                        .p_1()
                        .bg(surface)
                        .rounded_sm()
                        .child(block("Center", green(), text).px_2().py_1()),
                )
                .child(
                    div()
                        .flex()
                        .justify_end()
                        .p_1()
                        .bg(surface)
                        .rounded_sm()
                        .child(block("End", yellow(), text).px_2().py_1()),
                ),
        )
}

fn flexbox_grow(colors: &Colors) -> impl IntoElement {
    let text_muted = colors.disabled;
    let text = colors.selected_text;
    div()
        .flex()
        .flex_col()
        .gap_2()
        .child(
            div()
                .text_xs()
                .text_color(text_muted)
                .child("flex_1 (grow) vs flex_none (fixed)"),
        )
        .child(
            div()
                .flex()
                .gap_2()
                .child(block("fixed", red(), text).flex_none().w_16().h_8())
                .child(block("flex_1 (grows)", green(), text).flex_1().h_8())
                .child(block("fixed", blue(), text).flex_none().w_16().h_8()),
        )
}

fn grid_spans(colors: &Colors) -> impl IntoElement {
    let text_muted = colors.disabled;
    let text = colors.selected_text;
    div()
        .flex()
        .flex_col()
        .gap_2()
        .child(
            div()
                .text_xs()
                .text_color(text_muted)
                .child("col_span / row_span"),
        )
        .child(
            div()
                .grid()
                .grid_cols(4)
                .grid_rows(3)
                .gap_1()
                .child(
                    block("Header (col_span_full)", red(), text)
                        .col_span_full()
                        .h_6(),
                )
                .child(
                    block("Side", green(), text)
                        .col_span(1)
                        .row_span(2)
                        .h_full(),
                )
                .child(
                    block("Content (col_span 3)", blue(), text)
                        .col_span(3)
                        .row_span(2)
                        .h_full(),
                ),
        )
}

fn centered_pattern(colors: &Colors) -> impl IntoElement {
    let text_muted = colors.disabled;
    let text = colors.selected_text;
    let surface = colors.container;
    let accent = colors.selected;
    div()
        .flex()
        .flex_col()
        .gap_2()
        .child(
            div()
                .text_xs()
                .text_color(text_muted)
                .child("Centering: items_center + justify_center"),
        )
        .child(
            div()
                .h_20()
                .flex()
                .items_center()
                .justify_center()
                .bg(surface)
                .rounded_md()
                .child(
                    div()
                        .px_4()
                        .py_2()
                        .bg(accent)
                        .rounded_md()
                        .text_xs()
                        .text_color(text)
                        .child("Perfectly Centered"),
                ),
        )
}

fn example_layout(window: &mut Window, _cx: &mut App) -> impl IntoElement {
    let colors = Colors::for_appearance(window);
    let text = colors.selected_text;
    div()
        .id("main")
        .size_full()
        .p_4()
        .bg(colors.background)
        .overflow_scroll()
        .child(
            div()
                .flex()
                .flex_col()
                .gap_4()
                .max_w(px(600.))
                .child(title_block(
                    &colors,
                    "Layout Patterns",
                    "Flexbox, Grid, and common layout patterns in GPUI",
                ))
                .child(layout_section(
                    &colors,
                    "Flexbox: Row",
                    div()
                        .flex()
                        .flex_row()
                        .gap_2()
                        .child(block("A", red(), text).size_8())
                        .child(block("B", green(), text).size_8())
                        .child(block("C", blue(), text).size_8()),
                ))
                .child(layout_section(
                    &colors,
                    "Flexbox: Column",
                    flexbox_column(&colors),
                ))
                .child(layout_section(
                    &colors,
                    "Flexbox: Justify Content",
                    flexbox_justify(&colors),
                ))
                .child(layout_section(
                    &colors,
                    "Flexbox: Grow/Shrink",
                    flexbox_grow(&colors),
                ))
                .child(layout_section(
                    &colors,
                    "Grid: Basic",
                    div()
                        .grid()
                        .grid_cols(3)
                        .gap_1()
                        .child(block("1", red(), text).h_8())
                        .child(block("2", green(), text).h_8())
                        .child(block("3", blue(), text).h_8())
                        .child(block("4", yellow(), text).h_8()),
                ))
                .child(layout_section(&colors, "Grid: Spans", grid_spans(&colors)))
                .child(layout_section(
                    &colors,
                    "Pattern: App Shell",
                    app_shell(&colors),
                ))
                .child(layout_section(
                    &colors,
                    "Pattern: Centering",
                    centered_pattern(&colors),
                ))
                .child(layout_section(&colors, "Pattern: Stack", stack(&colors))),
        )
}

// ============================================================================
// example_styling — mirrors examples/learn/styling.rs
// All five sections mirrored: Interactive States, Focus States, Conditional
// Styling, Group Hover, and the Default Colors swatches. Focus buttons are drawn
// unfocused (the example starts with focus on the app container), so the
// focus()/focus_visible() refinements render at their base state.
// ============================================================================

fn interactive_button(id: &'static str, label: &'static str, colors: &Colors) -> impl IntoElement {
    let accent = colors.selected;
    let text = colors.selected_text;
    div()
        .id(id)
        .px_4()
        .py_2()
        .rounded_md()
        .cursor_pointer()
        .bg(accent)
        .text_color(text)
        .text_sm()
        .hover(move |s| s.bg(accent))
        .active(move |s| s.bg(accent))
        .child(label)
}

fn focus_button(
    id: &'static str,
    label: &'static str,
    focus_handle: &crate::FocusHandle,
    colors: &Colors,
) -> impl IntoElement {
    let surface = colors.container;
    let surface_hover = colors.selected;
    let text = colors.text;
    let accent = colors.selected;
    let focus_ring: Rgba = rgb(0x60a5fa);
    div()
        .id(id)
        .track_focus(focus_handle)
        .px_4()
        .py_2()
        .rounded_md()
        .cursor_pointer()
        .bg(surface)
        .text_color(text)
        .text_sm()
        .border_2()
        .border_color(transparent_black())
        .hover(move |s| s.bg(surface_hover))
        .focus(move |s| s.border_color(accent))
        .focus_visible(move |s| s.border_color(focus_ring).shadow_sm())
        .child(label)
}

fn color_swatch(colors: &Colors, name: &'static str, color: Rgba) -> impl IntoElement {
    let text_muted = colors.disabled;
    div()
        .flex()
        .flex_col()
        .items_center()
        .gap_1()
        .child(
            div()
                .size_8()
                .rounded_md()
                .bg(color)
                .border_1()
                .border_color(white().with_alpha(0.2)),
        )
        .child(div().text_xs().text_color(text_muted).child(name))
}

fn list_item(
    id: &'static str,
    label: &'static str,
    is_selected: bool,
    is_disabled: bool,
    colors: &Colors,
) -> impl IntoElement {
    let surface = colors.container;
    let surface_hover = colors.selected;
    let text = colors.text;
    let text_muted = colors.disabled;
    let accent = colors.selected;
    div()
        .id(id)
        .px_3()
        .py_2()
        .rounded_md()
        .text_sm()
        .cursor_pointer()
        .border_1()
        .border_color(transparent_black())
        .when(is_disabled, move |el| {
            el.opacity(0.5)
                .cursor_not_allowed()
                .bg(surface)
                .text_color(text_muted)
        })
        .when(!is_disabled && is_selected, move |el| {
            let accent_bg: Hsla = accent.into_color();
            el.bg(accent_bg.opacity(0.2))
                .border_color(accent)
                .text_color(text)
        })
        .when(!is_disabled && !is_selected, move |el| {
            el.bg(surface)
                .text_color(text)
                .hover(move |s| s.bg(surface_hover))
        })
        .child(label)
}

fn status_badge(status: &'static str, bg: Rgba, text: Rgba) -> Div {
    div()
        .px_2()
        .py_0p5()
        .rounded_full()
        .text_xs()
        .bg(bg)
        .text_color(text)
        .child(status)
}

fn group_card(colors: &Colors, title: &'static str, description: &'static str) -> Div {
    let surface = colors.container;
    let border = colors.border;
    let accent = colors.selected;
    let text = colors.text;
    let text_muted = colors.disabled;
    div()
        .group("card")
        .p_4()
        .rounded_lg()
        .bg(surface)
        .border_1()
        .border_color(border)
        .cursor_pointer()
        .hover(move |s| s.border_color(accent))
        .child(
            div()
                .flex()
                .justify_between()
                .items_center()
                .child(
                    div()
                        .text_sm()
                        .font_weight(FontWeight::SEMIBOLD)
                        .text_color(text)
                        .child(title),
                )
                .child(
                    div()
                        .text_xs()
                        .text_color(text_muted)
                        .opacity(0.)
                        .group_hover("card", |s| s.opacity(1.))
                        .child("→"),
                ),
        )
        .child(
            div()
                .mt_1()
                .text_xs()
                .text_color(text_muted)
                .child(description),
        )
}

fn styling_section(
    colors: &Colors,
    title: &'static str,
    content: impl IntoElement,
) -> impl IntoElement {
    let surface: Hsla = colors.container.into_color();
    let border: Hsla = colors.border.into_color();
    div()
        .flex()
        .flex_col()
        .gap_3()
        .p_4()
        .bg(surface.opacity(0.3))
        .rounded_lg()
        .border_1()
        .border_color(border.opacity(0.5))
        .child(
            div()
                .text_sm()
                .font_weight(FontWeight::SEMIBOLD)
                .text_color(colors.text)
                .child(title),
        )
        .child(content)
}

fn example_styling(window: &mut Window, cx: &mut App) -> impl IntoElement {
    let colors = Colors::for_appearance(window);
    let focus_1 = cx.focus_handle();
    let focus_2 = cx.focus_handle();
    let focus_3 = cx.focus_handle();
    div()
        .id("app")
        .size_full()
        .p_6()
        .bg(colors.background)
        .overflow_scroll()
        .child(
            div()
                .flex()
                .flex_col()
                .gap_6()
                .max_w(px(500.))
                .child(title_block(
                    &colors,
                    "Styling Patterns",
                    "Interactive states, conditional styling, and theming",
                ))
                .child(styling_section(
                    &colors,
                    "Interactive States",
                    div().flex().flex_col().gap_3().child(
                        div()
                            .flex()
                            .gap_2()
                            .child(interactive_button("btn-1", "Hover me", &colors))
                            .child(interactive_button("btn-2", "Click me", &colors)),
                    ),
                ))
                .child(styling_section(
                    &colors,
                    "Focus States (Tab to navigate)",
                    div().flex().flex_col().gap_3().child(
                        div()
                            .flex()
                            .gap_2()
                            .child(focus_button("focus-1", "Button 1", &focus_1, &colors))
                            .child(focus_button("focus-2", "Button 2", &focus_2, &colors))
                            .child(focus_button("focus-3", "Button 3", &focus_3, &colors)),
                    ),
                ))
                .child(styling_section(
                    &colors,
                    "Conditional Styling",
                    div()
                        .flex()
                        .flex_col()
                        .gap_3()
                        .child(
                            div()
                                .flex()
                                .flex_col()
                                .gap_1()
                                .child(list_item("item-1", "Normal item", false, false, &colors))
                                .child(list_item("item-2", "Selected item", true, false, &colors))
                                .child(list_item("item-3", "Disabled item", false, true, &colors)),
                        )
                        .child(
                            div()
                                .flex()
                                .gap_2()
                                .child(status_badge("Success", rgb(0x388e3c), colors.selected_text))
                                .child(status_badge("Warning", rgb(0xf9a825), rgb(0x000000)))
                                .child(status_badge("Error", rgb(0xd32f2f), colors.selected_text))
                                .child(status_badge("Neutral", colors.container, colors.text)),
                        ),
                ))
                .child(styling_section(
                    &colors,
                    "Group Hover",
                    div()
                        .flex()
                        .flex_col()
                        .gap_2()
                        .child(group_card(
                            &colors,
                            "Documents",
                            "View and manage your documents",
                        ))
                        .child(group_card(
                            &colors,
                            "Settings",
                            "Configure application settings",
                        )),
                ))
                .child(styling_section(
                    &colors,
                    "Default Colors",
                    div().flex().flex_col().gap_2().child(
                        div()
                            .flex()
                            .flex_wrap()
                            .gap_2()
                            .child(color_swatch(&colors, "background", colors.background))
                            .child(color_swatch(&colors, "container", colors.container))
                            .child(color_swatch(&colors, "selected", colors.selected))
                            .child(color_swatch(&colors, "success", rgb(0x388e3c)))
                            .child(color_swatch(&colors, "warning", rgb(0xf9a825)))
                            .child(color_swatch(&colors, "error", rgb(0xd32f2f)))
                            .child(color_swatch(&colors, "border", colors.border)),
                    ),
                )),
        )
}

// ============================================================================
// example_text — mirrors examples/learn/text.rs
// All eight sections mirrored (sizes, weights, alignment, decoration, line
// height, styled text, overflow, character grid). NoopTextSystem emits no
// glyphs/textures, so the snapshot pins the quad/underlay structure only.
// ============================================================================

const LONG_TEXT: &str = "The quick brown fox jumps over the lazy dog. This is a long sentence that will overflow its container.";

/// The full 70-character grid from the example: Latin, numbers, Greek, Cyrillic,
/// CJK, symbols, and emoji. Under NoopTextSystem the emoji (and every other) glyph
/// paints as an empty layer — they still pin the grid's layout structure.
const CHARACTERS: [&str; 70] = [
    // Latin
    "A", "B", "C", "D", "E", "a", "b", "c", "d", "e", // Numbers
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", // Greek
    "α", "β", "γ", "δ", "ε", "θ", "λ", "π", "σ", "ω", // Cyrillic
    "Д", "Ж", "И", "Л", "Ф", "Ц", "Ш", "Щ", "Ы", "Я", // CJK
    "你", "好", "世", "界", "日", "本", "語", "中", "文", "字", // Symbols
    "→", "←", "↑", "↓", "•", "★", "♠", "♥", "♦", "♣", // Emoji
    "😀", "🎉", "🚀", "💡", "🔥", "✨", "🎨", "📚", "🎵", "❤️",
];

fn text_section(
    colors: &Colors,
    title: &'static str,
    content: impl IntoElement,
) -> impl IntoElement {
    let surface: Hsla = colors.container.into_color();
    div()
        .flex()
        .flex_col()
        .gap_2()
        .p_3()
        .bg(surface.opacity(0.5))
        .rounded_lg()
        .child(
            div()
                .text_sm()
                .font_weight(FontWeight::SEMIBOLD)
                .text_color(colors.text)
                .child(title),
        )
        .child(content)
}

fn example_text(window: &mut Window, _cx: &mut App) -> impl IntoElement {
    let colors = Colors::for_appearance(window);
    div()
        .id("main")
        .size_full()
        .p_4()
        .bg(colors.background)
        .overflow_scroll()
        .child(
            div()
                .flex()
                .flex_col()
                .gap_4()
                .max_w(px(600.))
                .child(title_block(
                    &colors,
                    "Text & Typography",
                    "Font styling, alignment, overflow, and unicode support",
                ))
                .child(text_section(
                    &colors,
                    "Font Sizes",
                    div()
                        .flex()
                        .flex_col()
                        .gap_1()
                        .child(
                            div()
                                .text_xs()
                                .text_color(colors.disabled)
                                .child("Font sizes: text_xs, text_sm, text_base, text_lg, text_xl"),
                        )
                        .child(
                            div()
                                .flex()
                                .flex_wrap()
                                .items_baseline()
                                .gap_3()
                                .child(div().text_xs().text_color(colors.text).child("Extra Small"))
                                .child(div().text_sm().text_color(colors.text).child("Small"))
                                .child(div().text_base().text_color(colors.text).child("Base"))
                                .child(div().text_lg().text_color(colors.text).child("Large"))
                                .child(
                                    div().text_xl().text_color(colors.text).child("Extra Large"),
                                ),
                        ),
                ))
                .child(text_section(
                    &colors,
                    "Font Weights",
                    div()
                        .flex()
                        .flex_col()
                        .gap_1()
                        .child(
                            div()
                                .text_xs()
                                .text_color(colors.disabled)
                                .child("Font weights: THIN through BLACK"),
                        )
                        .child(
                            div()
                                .flex()
                                .flex_wrap()
                                .gap_3()
                                .child(
                                    div()
                                        .text_color(colors.text)
                                        .font_weight(FontWeight::THIN)
                                        .child("Thin"),
                                )
                                .child(
                                    div()
                                        .text_color(colors.text)
                                        .font_weight(FontWeight::LIGHT)
                                        .child("Light"),
                                )
                                .child(
                                    div()
                                        .text_color(colors.text)
                                        .font_weight(FontWeight::NORMAL)
                                        .child("Normal"),
                                )
                                .child(
                                    div()
                                        .text_color(colors.text)
                                        .font_weight(FontWeight::MEDIUM)
                                        .child("Medium"),
                                )
                                .child(
                                    div()
                                        .text_color(colors.text)
                                        .font_weight(FontWeight::SEMIBOLD)
                                        .child("Semibold"),
                                )
                                .child(
                                    div()
                                        .text_color(colors.text)
                                        .font_weight(FontWeight::BOLD)
                                        .child("Bold"),
                                )
                                .child(
                                    div()
                                        .text_color(colors.text)
                                        .font_weight(FontWeight::BLACK)
                                        .child("Black"),
                                ),
                        ),
                ))
                .child(text_section(
                    &colors,
                    "Text Alignment",
                    div()
                        .flex()
                        .flex_col()
                        .gap_1()
                        .child(
                            div()
                                .p_2()
                                .bg(colors.container)
                                .rounded_sm()
                                .text_color(colors.text)
                                .child("Left aligned (default)"),
                        )
                        .child(
                            div()
                                .p_2()
                                .bg(colors.container)
                                .rounded_sm()
                                .text_center()
                                .text_color(colors.text)
                                .child("Center aligned"),
                        )
                        .child(
                            div()
                                .p_2()
                                .bg(colors.container)
                                .rounded_sm()
                                .text_right()
                                .text_color(colors.text)
                                .child("Right aligned"),
                        ),
                ))
                .child(text_section(
                    &colors,
                    "Text Decoration",
                    div()
                        .flex()
                        .flex_wrap()
                        .gap_4()
                        .child(
                            div()
                                .text_color(colors.text)
                                .text_decoration_1()
                                .text_decoration_color(colors.selected)
                                .child("Underlined text"),
                        )
                        .child(
                            div()
                                .text_color(colors.text)
                                .line_through()
                                .text_decoration_color(rgb(0xd32f2f))
                                .child("Strikethrough text"),
                        )
                        .child(div().text_color(colors.text).italic().child("Italic text")),
                ))
                .child(text_section(
                    &colors,
                    "Line Height",
                    div()
                        .flex()
                        .gap_3()
                        .child(
                            div()
                                .flex_1()
                                .p_2()
                                .bg(colors.container)
                                .rounded_sm()
                                .text_color(colors.text)
                                .text_sm()
                                .line_height(relative(1.0))
                                .child("Tight\nline\nheight"),
                        )
                        .child(
                            div()
                                .flex_1()
                                .p_2()
                                .bg(colors.container)
                                .rounded_sm()
                                .text_color(colors.text)
                                .text_sm()
                                .line_height(relative(1.5))
                                .child("Normal\nline\nheight"),
                        )
                        .child(
                            div()
                                .flex_1()
                                .p_2()
                                .bg(colors.container)
                                .rounded_sm()
                                .text_color(colors.text)
                                .text_sm()
                                .line_height(relative(2.0))
                                .child("Loose\nline\nheight"),
                        ),
                ))
                .child(text_section(
                    &colors,
                    "Styled Text",
                    div().text_lg().text_color(colors.text).child(
                        StyledText::new("Bold Italic Normal Semibold").with_highlights([
                            (0..4, FontWeight::BOLD.into()),
                            (5..11, FontStyle::Italic.into()),
                            (19..27, FontWeight::SEMIBOLD.into()),
                        ]),
                    ),
                ))
                .child(text_section(
                    &colors,
                    "Text Overflow",
                    div()
                        .flex()
                        .flex_col()
                        .gap_2()
                        .child(
                            div()
                                .p_2()
                                .bg(colors.container)
                                .border_1()
                                .border_color(colors.border)
                                .rounded_sm()
                                .text_color(colors.text)
                                .overflow_hidden()
                                .text_ellipsis()
                                .child(LONG_TEXT),
                        )
                        .child(
                            div()
                                .p_2()
                                .bg(colors.container)
                                .border_1()
                                .border_color(colors.border)
                                .rounded_sm()
                                .text_color(colors.text)
                                .overflow_hidden()
                                .text_ellipsis()
                                .line_clamp(2)
                                .child(LONG_TEXT),
                        ),
                ))
                .child(text_section(
                    &colors,
                    "Character Grid",
                    div()
                        .flex()
                        .flex_col()
                        .gap_2()
                        .child(
                            div()
                                .text_xs()
                                .text_color(colors.disabled)
                                .child("Unicode and emoji support"),
                        )
                        .child(
                            div()
                                .p_2()
                                .bg(colors.container)
                                .border_1()
                                .border_color(colors.border)
                                .rounded_md()
                                .child(div().grid().grid_cols(10).gap_1().children(
                                    CHARACTERS.iter().map(|c| {
                                        div()
                                            .flex()
                                            .items_center()
                                            .justify_center()
                                            .size_8()
                                            .text_lg()
                                            .text_color(colors.text)
                                            .line_height(relative(1.0))
                                            .child(*c)
                                    }),
                                )),
                        ),
                )),
        )
}

// ============================================================================
// example_transitions — mirrors examples/learn/transitions.rs
// The bounce button pinned at its resting state. We drive the *real*
// `window.use_keyed_transition` (bounce/ease_in_out, keyed by ("btn", "bounce"))
// exactly like the example's `Button::render`, then assert the evaluated
// progress is 0 (no clock advance) before drawing the resting rect.
// ============================================================================

const BUTTON_WIDTH: f32 = 120.;
const BUTTON_HEIGHT: f32 = 44.;
const BOUNCE_HEIGHT: f32 = 120.;
const BOUNCE_DURATION: Duration = Duration::from_millis(1200);

fn example_transitions(window: &mut Window, cx: &mut App) -> impl IntoElement {
    let viewport = window.viewport_size();
    let left = px(((f32::from(viewport.width) - BUTTON_WIDTH) / 2.).max(0.));
    let resting_top = px(((f32::from(viewport.height) - BUTTON_HEIGHT) / 2.).max(0.));
    let key: ElementId = "btn".into();
    let bounce_transition = window
        .use_keyed_transition((key, "bounce"), cx, BOUNCE_DURATION, |_window, _cx| 0.)
        .with_easing(bounce(ease_in_out));
    let progress = *bounce_transition.evaluate(window, cx);
    assert_eq!(progress, 0.0, "resting transition must stay at progress 0");
    div()
        .relative()
        .size_full()
        .overflow_hidden()
        .bg(rgb(0x110F15))
        .child(
            div()
                .id("btn")
                .absolute()
                .left(left)
                .top(resting_top - px(BOUNCE_HEIGHT * progress))
                .w(px(BUTTON_WIDTH))
                .h(px(BUTTON_HEIGHT))
                .flex()
                .items_center()
                .justify_center()
                .cursor_pointer()
                .rounded(px(100.))
                .bg(rgb(0x663399))
                .text_color(rgb(0xffffff))
                .child("Bounce!"),
        )
}

// ============================================================================
// example_style_transitions — mirrors examples/learn/style_transitions.rs
// The declarative style-transition button at its base state, including the
// verbatim hover/active color lerps and the bg transition declaration.
// ============================================================================

fn example_style_transitions(_window: &mut Window, _cx: &mut App) -> impl IntoElement {
    const HOVER_STRENGTH: f32 = 0.2;
    const ACTIVE_STRENGTH: f32 = 0.3;
    let base_color: Rgba = rgb(0x663399);
    let hover_color = base_color.lerp(&rgb(0x000000), HOVER_STRENGTH);
    let active_color = base_color.lerp(&rgb(0x000000), ACTIVE_STRENGTH);
    div()
        .size_full()
        .flex()
        .justify_center()
        .items_center()
        .absolute()
        .bg(rgb(0x110F15))
        .gap(px(20.))
        .p(px(100.))
        .child(
            div()
                .id("btn")
                .cursor_pointer()
                .rounded(px(99999.))
                .pl(px(14.))
                .pr(px(14.))
                .pt(px(10.))
                .pb(px(10.))
                .bg(base_color)
                .text_color(rgb(0x110F15))
                .child("Click me!")
                .transitions(|transitions| {
                    transitions.bg(Duration::from_millis(200).with_easing(ease_in_out))
                })
                .hover(move |refinement| refinement.bg(hover_color))
                .active(move |refinement| refinement.bg(active_color)),
        )
}

// ============================================================================
// example_blur — mirrors examples/learn/blur.rs
// Every element of the example is mirrored 1:1 in the example's own 1060x760
// window with its original coordinates: busy_background, frosted_panel,
// content_blurred, content_blurred_rich (6px chip row), nested_content_blurred,
// adjacent_per_block_blur, adjacent_group_blur, the three caption pills, and the
// deferred backdrop-blur popover. The only deviation is that busy_background is
// condensed from the example's 9x8 tile grid to 4x6 so the snapshot stays
// reviewable (same palette, same per-tile structure).
// ============================================================================

fn busy_background() -> Div {
    let palette = [
        0xef4444, 0xf97316, 0xeab308, 0x22c55e, 0x06b6d4, 0x3b82f6, 0x8b5cf6, 0xec4899,
    ];
    let mut next = 0usize;
    div()
        .absolute()
        .inset_0()
        .flex()
        .flex_col()
        .children((0..4).map(|_| {
            div().flex().flex_1().children(
                (0..6)
                    .map(|_| {
                        let hex = palette[next % palette.len()];
                        next += 1;
                        div()
                            .flex_1()
                            .h_full()
                            .bg(rgb(hex))
                            .flex()
                            .items_center()
                            .justify_center()
                            .text_color(rgb(0xffffff))
                            .text_xl()
                            .child("◆")
                    })
                    .collect::<Vec<_>>(),
            )
        }))
}

fn frosted_panel() -> Div {
    div()
        .absolute()
        .left(px(60.))
        .top(px(120.))
        .w(px(360.))
        .h(px(200.))
        .rounded_xl()
        .bg(rgba(0xffffff30))
        .backdrop_blur(px(24.))
        .border_1()
        .border_color(rgba(0xffffff60))
        .flex()
        .items_center()
        .justify_center()
        .text_color(rgb(0x111111))
        .text_2xl()
        .child("backdrop_blur(24px)")
}

fn content_blurred() -> Div {
    div()
        .absolute()
        .left(px(120.))
        .top(px(420.))
        .w(px(280.))
        .h(px(120.))
        .blur(px(5.))
        .bg(rgb(0x0f172a))
        .rounded_lg()
        .flex()
        .items_center()
        .justify_center()
        .text_color(rgb(0xfacc15))
        .text_3xl()
        .child("blur(5px) content")
}

fn content_blurred_rich() -> Div {
    div()
        .absolute()
        .left(px(120.))
        .top(px(580.))
        .w(px(280.))
        .h(px(120.))
        .blur(px(6.))
        .bg(rgb(0x1e293b))
        .rounded_lg()
        .flex()
        .items_center()
        .justify_center()
        .gap_3()
        .children(
            [0xef4444, 0x22c55e, 0x3b82f6]
                .into_iter()
                .map(|hex| div().w(px(48.)).h(px(48.)).rounded_md().bg(rgb(hex))),
        )
}

fn nested_content_blurred() -> Div {
    div()
        .absolute()
        .left(px(740.))
        .top(px(80.))
        .w(px(290.))
        .h(px(220.))
        .blur(px(3.))
        .bg(rgb(0x1e293b))
        .rounded_xl()
        .flex()
        .flex_col()
        .items_center()
        .justify_center()
        .gap_4()
        .text_color(rgb(0xe2e8f0))
        .text_xl()
        .child("outer blur(3px)")
        .child(
            div()
                .w(px(190.))
                .h(px(100.))
                .blur(px(8.))
                .bg(rgb(0xf59e0b))
                .rounded_lg()
                .flex()
                .items_center()
                .justify_center()
                .text_color(rgb(0x111111))
                .text_2xl()
                .child("inner blur(8px)"),
        )
}

const SEAM_COLORS: [u32; 4] = [0xef4444, 0x22c55e, 0x3b82f6, 0xeab308];

fn seam_block(i: usize, hex: u32, blur_each: bool) -> Div {
    let block = div().flex_1().h_full();
    let block = if blur_each { block.blur(px(5.)) } else { block };
    block
        .bg(rgb(hex))
        .flex()
        .items_center()
        .justify_center()
        .text_color(rgb(0xffffff))
        .text_2xl()
        .child(format!("{}", i + 1))
}

fn adjacent_per_block_blur() -> Div {
    div()
        .absolute()
        .left(px(740.))
        .top(px(350.))
        .w(px(290.))
        .h(px(110.))
        .bg(rgb(0x050505))
        .flex()
        .children(
            SEAM_COLORS
                .into_iter()
                .enumerate()
                .map(|(i, hex)| seam_block(i, hex, true)),
        )
}

fn adjacent_group_blur() -> Div {
    div()
        .absolute()
        .left(px(740.))
        .top(px(510.))
        .w(px(290.))
        .h(px(110.))
        .bg(rgb(0x050505))
        .blur(px(5.))
        .flex()
        .children(
            SEAM_COLORS
                .into_iter()
                .enumerate()
                .map(|(i, hex)| seam_block(i, hex, false)),
        )
}

fn deferred_popover() -> impl IntoElement {
    deferred(
        div()
            .absolute()
            .left(px(260.))
            .top(px(260.))
            .w(px(300.))
            .h(px(150.))
            .rounded_lg()
            .bg(rgba(0x1e293b66))
            .backdrop_blur(px(12.))
            .border_1()
            .border_color(rgba(0xffffffaa))
            .flex()
            .items_center()
            .justify_center()
            .text_color(rgb(0xffffff))
            .text_xl()
            .child("deferred + backdrop_blur"),
    )
}

/// A small dark pill label identifying each blur test section over the busy background.
fn caption(text: &'static str, left: f32, top: f32) -> Div {
    div()
        .absolute()
        .left(px(left))
        .top(px(top))
        .px_2()
        .py_1()
        .rounded_md()
        .bg(rgba(0x000000cc))
        .text_color(rgb(0xffffff))
        .text_sm()
        .child(text)
}

fn example_blur(_window: &mut Window, _cx: &mut App) -> impl IntoElement {
    div()
        .relative()
        .size_full()
        .bg(rgb(0x000000))
        .child(busy_background())
        .child(frosted_panel())
        .child(content_blurred())
        .child(content_blurred_rich())
        .child(nested_content_blurred())
        .child(adjacent_per_block_blur())
        .child(adjacent_group_blur())
        .child(caption("nested content blur", 740., 50.))
        .child(caption(
            "adjacent — blur each block (seams, = CSS)",
            740.,
            322.,
        ))
        .child(caption(
            "adjacent — blur the parent (one group, clean)",
            740.,
            482.,
        ))
        .child(deferred_popover())
}

// ============================================================================
// example_custom_drawing — mirrors examples/learn/custom_drawing.rs
// All three sections mirrored: paint_quad rectangles, PathBuilder star/triangle/
// arrow, and the interactive drawing canvas. The interactive canvas is drawn at
// rest (no lines), so only its drawing-area chrome and clear button paint; the
// example's mouse/click event handlers are omitted because they carry no paint.
// ============================================================================

fn canvas_section(
    colors: &Colors,
    title: &'static str,
    description: &'static str,
    content: impl IntoElement,
    height: Pixels,
) -> impl IntoElement {
    let surface: Hsla = colors.container.into_color();
    div()
        .flex()
        .flex_col()
        .gap_3()
        .p_4()
        .rounded_lg()
        .bg(surface.opacity(0.5))
        .border_1()
        .border_color(colors.border)
        .child(
            div()
                .flex()
                .flex_col()
                .gap_1()
                .child(
                    div()
                        .text_sm()
                        .font_weight(FontWeight::SEMIBOLD)
                        .text_color(colors.text)
                        .child(title),
                )
                .child(
                    div()
                        .text_xs()
                        .text_color(colors.disabled)
                        .child(description),
                ),
        )
        .child(div().h(height).child(content))
}

fn basic_shapes_canvas(colors: &Colors) -> Canvas<()> {
    let error = rgb(0xd32f2f);
    let success = rgb(0x388e3c);
    let accent = colors.selected;
    canvas(
        move |_bounds, _window, _cx| {},
        move |bounds, _prepaint, window, _cx| {
            window.paint_quad(fill(
                Bounds {
                    origin: point(bounds.origin.x + px(10.), bounds.origin.y + px(10.)),
                    size: size(px(60.), px(40.)),
                },
                error,
            ));
            window.paint_quad(fill(
                Bounds {
                    origin: point(bounds.origin.x + px(80.), bounds.origin.y + px(10.)),
                    size: size(px(60.), px(40.)),
                },
                success,
            ));
            window.paint_quad(fill(
                Bounds {
                    origin: point(bounds.origin.x + px(150.), bounds.origin.y + px(10.)),
                    size: size(px(60.), px(40.)),
                },
                accent,
            ));
        },
    )
    .size_full()
}

fn create_star(center: Point<Pixels>, outer_radius: f32, inner_radius: f32) -> Path<Pixels> {
    let mut builder = PathBuilder::fill();
    let points = 5;
    for i in 0..points * 2 {
        let angle =
            std::f32::consts::PI / 2.0 - (i as f32) * std::f32::consts::PI / (points as f32);
        let radius = if i % 2 == 0 {
            outer_radius
        } else {
            inner_radius
        };
        let x = center.x + px(angle.cos() * radius);
        let y = center.y - px(angle.sin() * radius);
        if i == 0 {
            builder.move_to(point(x, y));
        } else {
            builder.line_to(point(x, y));
        }
    }
    builder.close();
    builder.build().unwrap()
}

fn create_triangle(p1: Point<Pixels>, p2: Point<Pixels>, p3: Point<Pixels>) -> Path<Pixels> {
    let mut builder = PathBuilder::fill();
    builder.move_to(p1);
    builder.line_to(p2);
    builder.line_to(p3);
    builder.close();
    builder.build().unwrap()
}

fn custom_paths_canvas(colors: &Colors) -> Canvas<()> {
    let warning = rgb(0xf9a825);
    let accent = colors.selected;
    canvas(
        move |_bounds, _window, _cx| {},
        move |bounds, _prepaint, window, _cx| {
            let center_y = bounds.origin.y + bounds.size.height / 2.0;
            let star = create_star(point(bounds.origin.x + px(50.), center_y), 30., 15.);
            window.paint_path(star, warning);
            let tri_base_x = bounds.origin.x + px(120.);
            let triangle = create_triangle(
                point(tri_base_x + px(30.), center_y - px(25.)),
                point(tri_base_x, center_y + px(25.)),
                point(tri_base_x + px(60.), center_y + px(25.)),
            );
            window.paint_path(triangle, rgb(0x8b5cf6));
            let arrow_x = bounds.origin.x + px(200.);
            let mut arrow_builder = PathBuilder::fill();
            arrow_builder.move_to(point(arrow_x, center_y));
            arrow_builder.line_to(point(arrow_x + px(20.), center_y - px(20.)));
            arrow_builder.line_to(point(arrow_x + px(20.), center_y - px(10.)));
            arrow_builder.line_to(point(arrow_x + px(50.), center_y - px(10.)));
            arrow_builder.line_to(point(arrow_x + px(50.), center_y + px(10.)));
            arrow_builder.line_to(point(arrow_x + px(20.), center_y + px(10.)));
            arrow_builder.line_to(point(arrow_x + px(20.), center_y + px(20.)));
            arrow_builder.close();
            window.paint_path(arrow_builder.build().unwrap(), accent);
        },
    )
    .size_full()
}

fn interactive_drawing_canvas(colors: &Colors) -> impl IntoElement {
    let surface = colors.container;
    let border = colors.border;
    let error = rgb(0xd32f2f);
    let error_hover = rgb(0xe04545);
    let text = colors.selected_text;
    let text_muted = colors.disabled;
    div()
        .flex()
        .flex_col()
        .gap_2()
        .child(
            div()
                .id("drawing-area")
                .h_48()
                .rounded_lg()
                .bg(surface)
                .border_1()
                .border_color(border)
                .cursor_crosshair()
                .overflow_hidden()
                .child(
                    canvas(
                        move |_, _, _| {},
                        move |_bounds, _, _window, _cx| {
                            // At rest there are no drawn lines; the example only paints
                            // strokes while the user drags.
                        },
                    )
                    .size_full(),
                ),
        )
        .child(
            div()
                .flex()
                .gap_2()
                .child(
                    div()
                        .id("clear-btn")
                        .px_3()
                        .py_1()
                        .rounded_md()
                        .bg(error)
                        .text_sm()
                        .text_color(text)
                        .cursor_pointer()
                        .hover(move |s| s.bg(error_hover))
                        .child("Clear"),
                )
                .child(
                    div()
                        .text_xs()
                        .text_color(text_muted)
                        .child("Click and drag to draw"),
                ),
        )
}

fn example_custom_drawing(window: &mut Window, _cx: &mut App) -> impl IntoElement {
    let colors = Colors::for_appearance(window);
    div()
        .id("main")
        .size_full()
        .p_6()
        .bg(colors.background)
        .overflow_scroll()
        .child(
            div()
                .flex()
                .flex_col()
                .gap_6()
                .max_w(px(500.))
                .child(title_block(
                    &colors,
                    "Custom Drawing",
                    "Canvas element, paths, and interactive painting",
                ))
                .child(canvas_section(
                    &colors,
                    "1. Basic Shapes (paint_quad)",
                    "Use window.paint_quad() to draw filled rectangles",
                    basic_shapes_canvas(&colors),
                    px(70.),
                ))
                .child(canvas_section(
                    &colors,
                    "2. Custom Paths (PathBuilder)",
                    "Create complex shapes with PathBuilder and paint_path()",
                    custom_paths_canvas(&colors),
                    px(80.),
                ))
                .child(canvas_section(
                    &colors,
                    "3. Interactive Drawing",
                    "Combine canvas with mouse events for drawing",
                    interactive_drawing_canvas(&colors),
                    px(240.),
                )),
        )
}

// ============================================================================
// example_animation — mirrors examples/learn/animation.rs
// First frame only (t = 0, no clock advance): all four sections mirrored —
// Rotation, Bounce Easing, Scale, and Combined — each with_animation wrapping an
// svg at delta 0. The svg glyphs cannot decode through the hermetic asset source,
// and text labels paint as empty layers (NoopTextSystem emits no glyphs), so the
// snapshot pins the deterministic page structure and section chrome around them.
// ============================================================================

fn animation_section(
    colors: &Colors,
    title: &'static str,
    content: impl IntoElement,
) -> impl IntoElement {
    let surface: Hsla = colors.container.into_color();
    div()
        .flex()
        .flex_col()
        .gap_2()
        .p_4()
        .bg(surface.opacity(0.5))
        .rounded_lg()
        .child(
            div()
                .text_sm()
                .font_weight(FontWeight::SEMIBOLD)
                .text_color(colors.text)
                .child(title),
        )
        .child(content)
}

fn example_animation(window: &mut Window, _cx: &mut App) -> impl IntoElement {
    let colors = Colors::for_appearance(window);
    let selected = colors.selected;
    div()
        .id("main")
        .size_full()
        .p_6()
        .bg(colors.background)
        .overflow_scroll()
        .child(
            div()
                .flex()
                .flex_col()
                .gap_6()
                .max_w(px(600.))
                .child(title_block(
                    &colors,
                    "Animation Patterns",
                    "Animations, easing, and transformations in GPUI",
                ))
                .child(animation_section(
                    &colors,
                    "Rotation Animation",
                    div().flex().items_center().justify_center().h_24().child(
                        svg()
                            .size_16()
                            .overflow_hidden()
                            .path(ARROW_CIRCLE_SVG)
                            .text_color(selected)
                            .with_animation(
                                "rotation",
                                Animation::new(Duration::from_secs(2))
                                    .repeat()
                                    .with_easing(ease_in_out),
                                |svg, delta| {
                                    svg.with_transformation(Transformation::rotate(percentage(
                                        delta,
                                    )))
                                },
                            ),
                    ),
                ))
                .child(animation_section(
                    &colors,
                    "Bounce Easing",
                    div().flex().items_center().justify_center().h_24().child(
                        svg()
                            .size_16()
                            .overflow_hidden()
                            .path(ARROW_CIRCLE_SVG)
                            .text_color(rgb(0x388e3c))
                            .with_animation(
                                "bounce_rotation",
                                Animation::new(Duration::from_secs(2))
                                    .repeat()
                                    .with_easing(bounce(ease_in_out)),
                                |svg, delta| {
                                    svg.with_transformation(Transformation::rotate(percentage(
                                        delta,
                                    )))
                                },
                            ),
                    ),
                ))
                .child(animation_section(
                    &colors,
                    "Scale Animation",
                    div().flex().items_center().justify_center().h_24().child(
                        svg()
                            .size_16()
                            .overflow_hidden()
                            .path(ARROW_CIRCLE_SVG)
                            .text_color(rgb(0xf9a825))
                            .with_animation(
                                "scale",
                                Animation::new(Duration::from_millis(1500))
                                    .repeat()
                                    .with_easing(bounce(linear)),
                                |svg, delta| {
                                    let scale = 0.8 + (delta * 0.4);
                                    svg.with_transformation(Transformation::scale(size(
                                        scale, scale,
                                    )))
                                },
                            ),
                    ),
                ))
                .child(animation_section(
                    &colors,
                    "Combined Animations",
                    div().flex().items_center().justify_center().h_24().child(
                        svg()
                            .size_16()
                            .overflow_hidden()
                            .path(ARROW_CIRCLE_SVG)
                            .text_color(rgb(0xd32f2f))
                            .with_animation(
                                "combined",
                                Animation::new(Duration::from_secs(3))
                                    .repeat()
                                    .with_easing(ease_in_out),
                                |svg, delta| {
                                    let scale = 0.7 + (delta * 0.6);
                                    svg.with_transformation(
                                        Transformation::rotate(percentage(delta))
                                            .with_scaling(size(scale, scale)),
                                    )
                                },
                            ),
                    ),
                )),
        )
}

// ============================================================================
// example_opacity — mirrors examples/legacy/opacity.rs (initial opacity 0.5)
// The opacity panel shows up in the scene as 50%-alpha colors. Its text, img and
// svg children paint nothing: NoopTextSystem emits no glyphs, and the hermetic
// asset source returns `None` for images.
// ============================================================================

fn example_opacity(_window: &mut Window, _cx: &mut App) -> impl IntoElement {
    div()
        .flex()
        .flex_row()
        .size_full()
        .bg(rgb(0xe0e0e0))
        .text_xl()
        .child(
            div()
                .flex()
                .size_full()
                .justify_center()
                .items_center()
                .border_1()
                .text_color(blue())
                .child(div().child("This is background text.")),
        )
        .child(
            div()
                .id("panel")
                .absolute()
                .top_8()
                .left_8()
                .right_8()
                .bottom_8()
                .opacity(0.5)
                .flex()
                .justify_center()
                .items_center()
                .bg(white())
                .border_3()
                .border_color(red())
                .text_color(yellow())
                .child(
                    div()
                        .flex()
                        .flex_col()
                        .gap_2()
                        .justify_center()
                        .items_center()
                        .size(px(300.))
                        .bg(blue())
                        .border_3()
                        .border_color(black())
                        .shadow(vec![
                            BoxShadow::new(px(10.0), px(10.0), hsla(0.0, 0.0, 0.0, 0.5))
                                .blur_radius(px(1.0))
                                .spread_radius(px(5.0)),
                        ])
                        .child("Opacity Panel (Click to test)")
                        .child(
                            div()
                                .id("deep-level-text")
                                .flex()
                                .justify_center()
                                .items_center()
                                .p_4()
                                .bg(black())
                                .text_color(white())
                                .text_decoration_2()
                                .text_decoration_wavy()
                                .text_decoration_color(red())
                                .child(format!("opacity: {:.1}", 0.5)),
                        )
                        .child(
                            div()
                                .flex()
                                .children(["🎊", "✈️", "🎉", "🎈", "🎁", "🎂"].map(|emoji| {
                                    div().child(emoji.to_string()).hover(|s| s.opacity(0.5))
                                })),
                        ),
                ),
        )
}

// ============================================================================
// example_gradient — mirrors examples/legacy/gradient.rs (default Oklab color space)
// Solid rows plus linear-gradient quads and a canvas-painted gradient path.
// ============================================================================

fn example_gradient(_window: &mut Window, _cx: &mut App) -> impl IntoElement {
    let color_space = ColorSpace::default();
    div()
        .bg(white())
        .size_full()
        .p_4()
        .flex()
        .flex_col()
        .gap_3()
        .child(
            div()
                .flex()
                .gap_2()
                .justify_between()
                .items_center()
                .child("Gradient Examples")
                .child(
                    div().flex().gap_2().items_center().child(
                        div()
                            .id("method")
                            .flex()
                            .px_3()
                            .py_1()
                            .text_sm()
                            .bg(black())
                            .text_color(white())
                            .child(format!("{}", color_space))
                            .active(|s| s.opacity(0.8)),
                    ),
                ),
        )
        .child(
            div()
                .flex()
                .flex_1()
                .gap_3()
                .child(
                    div()
                        .size_full()
                        .rounded_xl()
                        .flex()
                        .items_center()
                        .justify_center()
                        .bg(red())
                        .text_color(white())
                        .child("Solid Color"),
                )
                .child(
                    div()
                        .size_full()
                        .rounded_xl()
                        .flex()
                        .items_center()
                        .justify_center()
                        .bg(blue())
                        .text_color(white())
                        .child("Solid Color"),
                ),
        )
        .child(
            div()
                .flex()
                .flex_1()
                .gap_3()
                .h_24()
                .text_color(white())
                .child(
                    div().flex_1().rounded_xl().bg(linear_gradient(
                        45.,
                        linear_color_stop(red(), 0.),
                        linear_color_stop(blue(), 1.),
                    )
                    .color_space(color_space)),
                )
                .child(
                    div().flex_1().rounded_xl().bg(linear_gradient(
                        135.,
                        linear_color_stop(red(), 0.),
                        linear_color_stop(green(), 1.),
                    )
                    .color_space(color_space)),
                ),
        )
        .child(
            div().flex().flex_1().rounded_xl().bg(linear_gradient(
                0.,
                linear_color_stop(green(), 0.05),
                linear_color_stop(yellow(), 0.95),
            )
            .color_space(color_space)),
        )
        .child(div().h_24().child(canvas(
            move |_, _, _| {},
            move |bounds, _, window, _| {
                let size = size(bounds.size.width * 0.8, px(80.));
                let square_bounds = Bounds {
                    origin: point(
                        bounds.size.width.half() - size.width.half(),
                        bounds.origin.y,
                    ),
                    size,
                };
                let height = square_bounds.size.height;
                let horizontal_offset = height;
                let vertical_offset = px(30.);
                let mut builder = PathBuilder::fill();
                builder.move_to(square_bounds.bottom_left());
                builder.line_to(square_bounds.origin + point(horizontal_offset, vertical_offset));
                builder.line_to(
                    square_bounds.top_right() + point(-horizontal_offset, vertical_offset),
                );
                builder.line_to(square_bounds.bottom_right());
                builder.line_to(square_bounds.bottom_left());
                let path = builder.build().unwrap();
                window.paint_path(
                    path,
                    linear_gradient(
                        180.,
                        linear_color_stop(red(), 0.),
                        linear_color_stop(blue(), 1.),
                    )
                    .color_space(color_space),
                );
            },
        )))
}

// ============================================================================
// example_hello_world — mirrors examples/legacy/hello_world.rs
// Centered text block on a grey 500×500 card with a blue border and a row of
// six 8×8 dashed color swatches (the example's `self.text` is "World").
// ============================================================================

fn example_hello_world(_window: &mut Window, _cx: &mut App) -> impl IntoElement {
    let swatches = [
        (red(), white()),
        (green(), white()),
        (blue(), white()),
        (yellow(), white()),
        (black(), white()),
        (white(), black()),
    ];
    div()
        .flex()
        .flex_col()
        .gap_3()
        .bg(rgb(0x505050))
        .size(px(500.0))
        .justify_center()
        .items_center()
        .shadow_lg()
        .border_1()
        .border_color(rgb(0x0000ff))
        .text_xl()
        .text_color(rgb(0xffffff))
        .child("Hello, World!") // mirrors `Hello, {}!` with `self.text == "World"`
        .child(
            div()
                .flex()
                .gap_2()
                .children(swatches.map(|(color, border_color)| {
                    // The example repeats `.rounded_md()` on the black swatch
                    // (hello_world.rs:73); applying it once here is idempotent.
                    div()
                        .size_8()
                        .bg(color)
                        .border_1()
                        .border_dashed()
                        .rounded_md()
                        .border_color(border_color)
                })),
        )
}

// ============================================================================
// example_scrollable — mirrors examples/legacy/scrollable.rs
// The mirror uses a wide+tall frame (2070×5100) so the whole 2000×150 horizontal
// strip and the 5000-tall vertical column fit without clipping; the example
// itself scrolls at 500×500 with initial offset 0.
// ============================================================================

fn example_scrollable(_window: &mut Window, _cx: &mut App) -> impl IntoElement {
    div()
        .size_full()
        .id("vertical")
        .p_4()
        .overflow_scroll()
        .bg(white())
        .child("Example for test 2 way scroll in nested layout")
        .child(
            div()
                .h(px(5000.))
                .border_1()
                .border_color(blue())
                .bg(blue().with_alpha(0.05))
                .p_4()
                .child(
                    div()
                        .mb_5()
                        .w_full()
                        .id("horizontal")
                        .overflow_scroll()
                        .child(
                            div()
                                .w(px(2000.))
                                .h(px(150.))
                                .bg(green().with_alpha(0.1))
                                .hover(|this| this.bg(green().with_alpha(0.2)))
                                .border_1()
                                .border_color(green())
                                .p_4()
                                .child("Scroll Horizontal"),
                        ),
                )
                .child("Scroll Vertical"),
        )
}

// ============================================================================
// example_tree — mirrors examples/legacy/tree.rs
// 50 nested divs (the GPUI_TREE_DEPTH default), each padded 2px and cycling
// red/blue/green/yellow, innermost first.
// ============================================================================

fn example_tree(_window: &mut Window, _cx: &mut App) -> impl IntoElement {
    const DEPTH: u64 = 50; // GPUI_TREE_DEPTH default
    static COLORS: [Hsla; 4] = [red(), blue(), green(), yellow()];
    let mut colors = COLORS.iter().cycle().copied();
    let mut next_div = || div().p_0p5().bg(colors.next().unwrap());
    let mut innermost = next_div();
    for _ in 0..DEPTH {
        innermost = next_div().child(innermost);
    }
    innermost
}

// ============================================================================
// example_uniform_list — mirrors examples/legacy/uniform_list.rs
// 50 lazily-rendered list rows; the headless first frame pins the first
// viewport of rows at their initial offset 0.
// ============================================================================

fn example_uniform_list(_window: &mut Window, _cx: &mut App) -> impl IntoElement {
    div().size_full().bg(rgb(0xffffff)).child(
        uniform_list("entries", 50, |range, _window, _cx| {
            range
                .map(|ix| {
                    div()
                        .id(ix)
                        .px_2()
                        .cursor_pointer()
                        .child(format!("Item {}", ix + 1))
                })
                .collect::<Vec<_>>()
        })
        .h_full(),
    )
}

// ============================================================================
// example_focus_visible — mirrors examples/legacy/focus_visible.rs
// Initial focus state: focus sits on the app container (window.focus in `new()`),
// so none of the three buttons shows its focus()/focus_visible() border — the
// snapshot pins the base blue buttons.
// ============================================================================

fn focus_visible_base(
    id: &'static str,
    label: &'static str,
    handle: &FocusHandle,
) -> Stateful<Div> {
    div()
        .id(id)
        .h_16()
        .w_full()
        .flex()
        .justify_center()
        .items_center()
        .bg(rgb(0x2563eb))
        .text_color(white())
        .rounded_md()
        .cursor_pointer()
        .hover(|style| style.bg(rgb(0x1d4ed8)))
        .track_focus(handle)
        .child(label)
}

fn focus_section(label: &'static str, button: impl IntoElement) -> Div {
    div()
        .flex()
        .flex_col()
        .gap_2()
        .child(
            div()
                .text_sm()
                .font_weight(FontWeight::BOLD)
                .text_color(rgb(0x374151))
                .child(label),
        )
        .child(button)
}

fn example_focus_visible(window: &mut Window, cx: &mut App) -> impl IntoElement {
    let root = cx.focus_handle();
    window.focus(&root, cx); // example focuses the app container in `new()`
    let items = [
        (
            cx.focus_handle().tab_index(1).tab_stop(true),
            "Button with .focus() - always shows border when focused",
        ),
        (
            cx.focus_handle().tab_index(2).tab_stop(true),
            "Button with .focus_visible() - only shows border with keyboard",
        ),
        (
            cx.focus_handle().tab_index(3).tab_stop(true),
            "Button with both .focus() and .focus_visible()",
        ),
    ];
    div()
        .id("app")
        .track_focus(&root)
        .size_full()
        .flex()
        .flex_col()
        .p_8()
        .gap_6()
        .bg(rgb(0xf3f4f6))
        .child(
            div()
                .text_2xl()
                .font_weight(FontWeight::BOLD)
                .text_color(rgb(0x111827))
                .child("CSS focus-visible Demo"),
        )
        .child(
            div()
                .p_4()
                .rounded_md()
                .bg(rgb(0xdbeafe))
                .text_color(rgb(0x1e3a8a))
                .child("Try clicking vs tabbing! Click shows no border, Tab shows border."),
        )
        .child(
            div()
                .flex()
                .flex_col()
                .gap_4()
                .child(focus_section(
                    "1. Regular .focus() - always visible:",
                    focus_visible_base("button1", items[0].1, &items[0].0)
                        .focus(|s| s.border_4().border_color(rgb(0xfbbf24))),
                ))
                .child(focus_section(
                    "2. New .focus_visible() - only keyboard:",
                    focus_visible_base("button2", items[1].1, &items[1].0)
                        .focus_visible(|s| s.border_4().border_color(rgb(0x10b981))),
                ))
                .child(focus_section(
                    "3. Both .focus() (yellow) and .focus_visible() (green):",
                    focus_visible_base("button3", items[2].1, &items[2].0)
                        .focus(|s| s.border_4().border_color(rgb(0xfbbf24)))
                        .focus_visible(|s| s.border_4().border_color(rgb(0x10b981))),
                )),
        )
}

// ============================================================================
// example_tab_stop — mirrors examples/legacy/tab_stop.rs
// Five focus rows (tab_index 1/2/3, no tab-stop, tab_index 2) plus two buttons.
// Initial focus is on the app container, so the `tab_stop && is_focused` blue
// border is never applied in the first frame.
// ============================================================================

fn tab_stop_style<T: Styled>(this: T) -> T {
    this.border_3().border_color(blue())
}

fn tab_stop_button(id: &'static str, tab_index: isize, label: &'static str) -> Stateful<Div> {
    div()
        .id(id)
        .h_10()
        .flex_1()
        .flex()
        .justify_center()
        .items_center()
        .border_1()
        .border_color(black())
        .bg(black())
        .text_color(white())
        .focus(tab_stop_style)
        .shadow_sm()
        .tab_index(tab_index)
        .child(label)
}

fn example_tab_stop(window: &mut Window, cx: &mut App) -> impl IntoElement {
    let root = cx.focus_handle();
    window.focus(&root, cx); // example focuses the app container in `new()`
    let items = [
        cx.focus_handle().tab_index(1).tab_stop(true),
        cx.focus_handle().tab_index(2).tab_stop(true),
        cx.focus_handle().tab_index(3).tab_stop(true),
        cx.focus_handle(),
        cx.focus_handle().tab_index(2).tab_stop(true),
    ];
    div()
        .id("app")
        .track_focus(&root)
        .size_full()
        .flex()
        .flex_col()
        .p_4()
        .gap_3()
        .bg(white())
        .text_color(black())
        .child("Press `Tab`, `Shift-Tab` to switch focus.")
        .children(items.iter().enumerate().map(|(ix, item_handle)| {
            div()
                .id(("item", ix))
                .track_focus(item_handle)
                .h_10()
                .w_full()
                .flex()
                .justify_center()
                .items_center()
                .border_1()
                .border_color(black())
                .when(
                    item_handle.tab_stop && item_handle.is_focused(window),
                    tab_stop_style,
                )
                .map(|this| match item_handle.tab_stop {
                    true => this
                        .hover(|this| this.bg(black().with_alpha(0.1)))
                        .child(format!("tab_index: {}", item_handle.tab_index)),
                    false => this.opacity(0.4).child("tab_stop: false"),
                })
        }))
        .child(
            div()
                .flex()
                .flex_row()
                .gap_3()
                .items_center()
                .child(tab_stop_button("el1", 4, "Button 1"))
                .child(tab_stop_button("el2", 5, "Button 2")),
        )
}

// ============================================================================
// example_window — mirrors examples/legacy/window.rs (window chrome)
// The main window is a button grid; every button opens/inspects a sub-window on
// click, which is inert headlessly, so the mirror pins the chrome button grid
// in its initial static state.
// ============================================================================

fn window_button(label: &'static str) -> Stateful<Div> {
    div()
        .id(label)
        .flex_none()
        .px_2()
        .bg(rgb(0xf7f7f7))
        .active(|this| this.opacity(0.85))
        .border_1()
        .border_color(rgb(0xe0e0e0))
        .rounded_sm()
        .cursor_pointer()
        .child(label)
}

fn example_window(_window: &mut Window, _cx: &mut App) -> impl IntoElement {
    div()
        .p_4()
        .flex()
        .flex_wrap()
        .bg(rgb(0xffffff))
        .size_full()
        .justify_center()
        .content_center()
        .gap_2()
        .children(
            [
                "Normal",
                "Popup",
                "Custom Titlebar",
                "Invisible",
                "Unmovable",
                "Unresizable",
                "Unminimizable",
                "Hide Application",
                "Resize",
                "Prompt",
                "Prompt (non-English)",
            ]
            .map(window_button),
        )
}

// ============================================================================
// example_window_shadow — mirrors examples/legacy/window_shadow.rs
// The headless test platform reports `Decorations::Server`, so the client-side
// backdrop/canvas/border/shadow branch never paints; the mirror keeps the match
// so the snapshot honestly reflects the Server-decorated content (the 0xCCCCFF
// page, the white shadow_lg card, and the green 200×100 shadow box).
// ============================================================================

fn example_window_shadow(window: &mut Window, _cx: &mut App) -> impl IntoElement {
    let decorations = window.window_decorations();
    let rounding = px(10.0);
    let shadow_size = px(10.0);
    let border_size = px(1.0);
    let grey = rgb(0x808080);
    window.set_client_inset(shadow_size);
    div()
        .id("window-backdrop")
        .bg(transparent_black())
        .map(|div| match decorations {
            Decorations::Server => div,
            Decorations::Client { tiling, .. } => div
                .bg(transparent_black())
                // The example's client-branch canvas only registers hitbox + cursor-style
                // mouse handlers (it paints nothing), so it is stubbed to empty closures
                // here; the branch itself never renders headlessly (Decorations::Server).
                .child(canvas(|_, _, _| {}, |_, _, _, _| {}).size_full().absolute())
                .when(!(tiling.top || tiling.right), |div| {
                    div.rounded_tr(rounding)
                })
                .when(!(tiling.top || tiling.left), |div| div.rounded_tl(rounding))
                .when(!tiling.top, |div| div.pt(shadow_size))
                .when(!tiling.bottom, |div| div.pb(shadow_size))
                .when(!tiling.left, |div| div.pl(shadow_size))
                .when(!tiling.right, |div| div.pr(shadow_size)),
        })
        .size_full()
        .child(
            div()
                .cursor(CursorStyle::Arrow)
                .map(|div| match decorations {
                    Decorations::Server => div,
                    Decorations::Client { tiling } => div
                        .border_color(grey)
                        .when(!(tiling.top || tiling.right), |div| {
                            div.rounded_tr(rounding)
                        })
                        .when(!(tiling.top || tiling.left), |div| div.rounded_tl(rounding))
                        .when(!tiling.top, |div| div.border_t(border_size))
                        .when(!tiling.bottom, |div| div.border_b(border_size))
                        .when(!tiling.left, |div| div.border_l(border_size))
                        .when(!tiling.right, |div| div.border_r(border_size))
                        .when(!tiling.is_tiled(), |div| {
                            div.shadow(vec![
                                BoxShadow::new(px(0.), px(0.), Hsla::new(0., 0., 0., 0.4))
                                    .blur_radius(shadow_size / 2.),
                            ])
                        }),
                })
                .bg(rgb(0xCCCCFF))
                .size_full()
                .flex()
                .flex_col()
                .justify_around()
                .child(
                    div().w_full().flex().flex_row().justify_around().child(
                        div()
                            .flex()
                            .bg(white())
                            .size(px(300.0))
                            .justify_center()
                            .items_center()
                            .shadow_lg()
                            .border_1()
                            .border_color(rgb(0x0000ff))
                            .text_xl()
                            .text_color(white())
                            .child(
                                div()
                                    .id("hello")
                                    .w(px(200.0))
                                    .h(px(100.0))
                                    .bg(green())
                                    .shadow(vec![
                                        BoxShadow::new(px(0.), px(0.), Hsla::new(0., 0., 0., 1.))
                                            .blur_radius(px(20.)),
                                    ])
                                    .map(|div| match decorations {
                                        Decorations::Server => div,
                                        Decorations::Client { .. } => div
                                            .text_color(black())
                                            .child("this is the custom titlebar"),
                                    }),
                            ),
                    ),
                ),
        )
}

// ============================================================================
// example_bench_shadow — mirrors examples/bench/shadow.rs
// The full shadow-elevations table (12 rows × cells) mirrored verbatim: shape
// drop-shadows, the elevation presets, blur/spread sweeps, directional shadows,
// multiple shadows, insets, and the combined drop+inset. This case is larger
// than the 30-line target because the table is inherently wide; the shared
// `shadow_swatch`/`shadow_cell`/`shadow_row` helpers keep every row to a line.
// A tall frame (1000×2600) pins the whole `overflow_y_scroll` table in one frame.
// ============================================================================

#[derive(Clone, Copy)]
enum ShadowShape {
    Circle,
    Square,
    Rounded4,
    Rounded8,
    Rounded12,
}

fn shadow_swatch(shape: ShadowShape) -> Div {
    let base = match shape {
        ShadowShape::Circle => div().size_16().bg(rgb(0xffffff)).rounded_full(),
        ShadowShape::Square => div().size_16().bg(rgb(0xffffff)),
        ShadowShape::Rounded4 => div().size_16().bg(rgb(0xffffff)).rounded(px(4.)),
        ShadowShape::Rounded8 => div().size_16().bg(rgb(0xffffff)).rounded(px(8.)),
        ShadowShape::Rounded12 => div().size_16().bg(rgb(0xffffff)).rounded(px(12.)),
    };
    base.border_1().border_color(hsla(0.0, 0.0, 0.0, 0.1))
}

fn shadow_cell(label: &'static str, swatch: Div) -> Div {
    div()
        .flex()
        .flex_col()
        .justify_center()
        .items_center()
        .w(relative(1. / 6.))
        .border_r_1()
        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
        .child(
            div()
                .flex()
                .items_center()
                .justify_center()
                .flex_1()
                .py_12()
                .child(swatch),
        )
        .child(
            div()
                .w_full()
                .border_t_1()
                .border_color(hsla(0.0, 0.0, 0.0, 1.0))
                .p_1()
                .flex()
                .items_center()
                .child(label),
        )
}

fn shadow_row(cells: impl IntoIterator<Item = Div>) -> Div {
    div()
        .border_b_1()
        .border_color(hsla(0.0, 0.0, 0.0, 1.0))
        .flex()
        // The example sets `.w_full()` only on the elevation/inset/drop+inset rows
        // (bench/shadow.rs:141,523,571); under the parent flex-col's default
        // align-items:stretch every row already spans the full width, so applying it
        // uniformly here does not change the layout.
        .w_full()
        .children(cells)
}

fn multiple_shadow() -> Vec<BoxShadow> {
    vec![
        BoxShadow::new(px(0.), px(-12.), hsla(0.0 / 360., 1.0, 0.5, 0.3))
            .blur_radius(px(8.))
            .spread_radius(px(2.)),
        BoxShadow::new(px(12.), px(0.), hsla(60.0 / 360., 1.0, 0.5, 0.3))
            .blur_radius(px(8.))
            .spread_radius(px(2.)),
        BoxShadow::new(px(0.), px(12.), hsla(120.0 / 360., 1.0, 0.5, 0.3))
            .blur_radius(px(8.))
            .spread_radius(px(2.)),
        BoxShadow::new(px(-12.), px(0.), hsla(240.0 / 360., 1.0, 0.5, 0.3))
            .blur_radius(px(8.))
            .spread_radius(px(2.)),
    ]
}

fn inset_shadow(x: f32, y: f32, blur: f32, spread: f32, alpha: f32) -> BoxShadow {
    BoxShadow::new(px(x), px(y), hsla(0.0, 0.0, 0.0, alpha))
        .blur_radius(px(blur))
        .spread_radius(px(spread))
        .inset()
}

fn example_bench_shadow(_window: &mut Window, _cx: &mut App) -> impl IntoElement {
    let pink = |x: f32, y: f32, blur: f32| {
        BoxShadow::new(px(x), px(y), hsla(0.0, 0.5, 0.5, 0.3)).blur_radius(px(blur))
    };
    let ink = |x: f32, y: f32, blur: f32, spread: f32| {
        BoxShadow::new(px(x), px(y), hsla(0.0, 0.0, 0.0, 0.3))
            .blur_radius(px(blur))
            .spread_radius(px(spread))
    };
    div()
        .id("shadow-example")
        .overflow_y_scroll()
        .bg(rgb(0xffffff))
        .size_full()
        .text_xs()
        .child(div().flex().flex_col().w_full().children(vec![
                shadow_row([
                    shadow_cell(
                        "Square",
                        shadow_swatch(ShadowShape::Square).shadow(vec![pink(0., 8., 8.)]),
                    ),
                    shadow_cell(
                        "Rounded 4",
                        shadow_swatch(ShadowShape::Rounded4).shadow(vec![pink(0., 8., 8.)]),
                    ),
                    shadow_cell(
                        "Rounded 8",
                        shadow_swatch(ShadowShape::Rounded8).shadow(vec![pink(0., 8., 8.)]),
                    ),
                    shadow_cell(
                        "Rounded 16",
                        shadow_swatch(ShadowShape::Rounded12).shadow(vec![pink(0., 8., 8.)]),
                    ),
                    shadow_cell(
                        "Circle",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![pink(0., 8., 8.)]),
                    ),
                ]),
                shadow_row([
                    shadow_cell("None", shadow_swatch(ShadowShape::Circle)),
                    shadow_cell("2X Small", shadow_swatch(ShadowShape::Circle).shadow_2xs()),
                    shadow_cell(
                        "Extra Small",
                        shadow_swatch(ShadowShape::Circle).shadow_xs(),
                    ),
                    shadow_cell("Small", shadow_swatch(ShadowShape::Circle).shadow_sm()),
                    shadow_cell("Medium", shadow_swatch(ShadowShape::Circle).shadow_md()),
                    shadow_cell("Large", shadow_swatch(ShadowShape::Circle).shadow_lg()),
                    shadow_cell(
                        "Extra Large",
                        shadow_swatch(ShadowShape::Circle).shadow_xl(),
                    ),
                    shadow_cell("2X Large", shadow_swatch(ShadowShape::Circle).shadow_2xl()),
                ]),
                shadow_row([
                    shadow_cell(
                        "Blur 0",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![ink(0., 8., 0., 0.)]),
                    ),
                    shadow_cell(
                        "Blur 2",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![ink(0., 8., 2., 0.)]),
                    ),
                    shadow_cell(
                        "Blur 4",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![ink(0., 8., 4., 0.)]),
                    ),
                    shadow_cell(
                        "Blur 8",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![ink(0., 8., 8., 0.)]),
                    ),
                    shadow_cell(
                        "Blur 16",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![ink(0., 8., 16., 0.)]),
                    ),
                ]),
                shadow_row([
                    shadow_cell(
                        "Spread 0",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![ink(0., 8., 8., 0.)]),
                    ),
                    shadow_cell(
                        "Spread 2",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![ink(0., 8., 8., 2.)]),
                    ),
                    shadow_cell(
                        "Spread 4",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![ink(0., 8., 8., 4.)]),
                    ),
                    shadow_cell(
                        "Spread 8",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![ink(0., 8., 8., 8.)]),
                    ),
                    shadow_cell(
                        "Spread 16",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![ink(0., 8., 8., 16.)]),
                    ),
                ]),
                shadow_row([
                    shadow_cell(
                        "Square Spread 0",
                        shadow_swatch(ShadowShape::Square).shadow(vec![ink(0., 8., 8., 0.)]),
                    ),
                    shadow_cell(
                        "Square Spread 8",
                        shadow_swatch(ShadowShape::Square).shadow(vec![ink(0., 8., 8., 8.)]),
                    ),
                    shadow_cell(
                        "Square Spread 16",
                        shadow_swatch(ShadowShape::Square).shadow(vec![ink(0., 8., 8., 16.)]),
                    ),
                ]),
                shadow_row([
                    shadow_cell(
                        "Rounded Large Spread 0",
                        shadow_swatch(ShadowShape::Rounded12).shadow(vec![ink(0., 8., 8., 0.)]),
                    ),
                    shadow_cell(
                        "Rounded Large Spread 8",
                        shadow_swatch(ShadowShape::Rounded12).shadow(vec![ink(0., 8., 8., 8.)]),
                    ),
                    shadow_cell(
                        "Rounded Large Spread 16",
                        shadow_swatch(ShadowShape::Rounded12).shadow(vec![ink(0., 8., 8., 16.)]),
                    ),
                ]),
                shadow_row([
                    shadow_cell(
                        "Left",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![pink(-8., 0., 8.)]),
                    ),
                    shadow_cell(
                        "Right",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![pink(8., 0., 8.)]),
                    ),
                    shadow_cell(
                        "Top",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![pink(0., -8., 8.)]),
                    ),
                    shadow_cell(
                        "Bottom",
                        shadow_swatch(ShadowShape::Circle).shadow(vec![pink(0., 8., 8.)]),
                    ),
                ]),
                shadow_row([
                    shadow_cell(
                        "Square Left",
                        shadow_swatch(ShadowShape::Square).shadow(vec![pink(-8., 0., 8.)]),
                    ),
                    shadow_cell(
                        "Square Right",
                        shadow_swatch(ShadowShape::Square).shadow(vec![pink(8., 0., 8.)]),
                    ),
                    shadow_cell(
                        "Square Top",
                        shadow_swatch(ShadowShape::Square).shadow(vec![pink(0., -8., 8.)]),
                    ),
                    shadow_cell(
                        "Square Bottom",
                        shadow_swatch(ShadowShape::Square).shadow(vec![pink(0., 8., 8.)]),
                    ),
                ]),
                shadow_row([
                    shadow_cell(
                        "Rounded Large Left",
                        shadow_swatch(ShadowShape::Rounded12).shadow(vec![pink(-8., 0., 8.)]),
                    ),
                    shadow_cell(
                        "Rounded Large Right",
                        shadow_swatch(ShadowShape::Rounded12).shadow(vec![pink(8., 0., 8.)]),
                    ),
                    shadow_cell(
                        "Rounded Large Top",
                        shadow_swatch(ShadowShape::Rounded12).shadow(vec![pink(0., -8., 8.)]),
                    ),
                    shadow_cell(
                        "Rounded Large Bottom",
                        shadow_swatch(ShadowShape::Rounded12).shadow(vec![pink(0., 8., 8.)]),
                    ),
                ]),
                shadow_row([
                    shadow_cell(
                        "Circle Multiple",
                        shadow_swatch(ShadowShape::Circle).shadow(multiple_shadow()),
                    ),
                    shadow_cell(
                        "Square Multiple",
                        shadow_swatch(ShadowShape::Square).shadow(multiple_shadow()),
                    ),
                    shadow_cell(
                        "Rounded Large Multiple",
                        shadow_swatch(ShadowShape::Rounded12).shadow(multiple_shadow()),
                    ),
                ]),
                shadow_row([
                    shadow_cell(
                        "Inset basic",
                        shadow_swatch(ShadowShape::Circle)
                            .shadow(vec![inset_shadow(0., 0., 12., 0., 0.5)]),
                    ),
                    shadow_cell(
                        "Inset offset",
                        shadow_swatch(ShadowShape::Circle)
                            .shadow(vec![inset_shadow(6., 6., 8., 0., 0.5)]),
                    ),
                    shadow_cell(
                        "Inset spread",
                        shadow_swatch(ShadowShape::Circle)
                            .shadow(vec![inset_shadow(0., 0., 4., 8., 0.5)]),
                    ),
                    shadow_cell(
                        "Inset rounded",
                        shadow_swatch(ShadowShape::Rounded12)
                            .shadow(vec![inset_shadow(0., 4., 10., 2., 0.5)]),
                    ),
                    shadow_cell(
                        "Inset sharp",
                        shadow_swatch(ShadowShape::Square)
                            .shadow(vec![inset_shadow(0., 0., 0., 6., 0.6)]),
                    ),
                ]),
                shadow_row([shadow_cell(
                    "Drop + Inset",
                    shadow_swatch(ShadowShape::Rounded8).shadow(vec![
                        BoxShadow::new(px(0.), px(8.), hsla(0.0, 0.0, 0.0, 0.25))
                            .blur_radius(px(12.)),
                        BoxShadow::new(px(0.), px(2.), hsla(0.0, 0.0, 0.0, 0.4))
                            .blur_radius(px(4.))
                            .inset(),
                    ]),
                )]),
            ]))
}

// ============================================================================
// example_bench_pattern — mirrors examples/bench/pattern.rs
// The full (already-small) example: a label, two blue-bordered pattern-strip
// columns, and solid/gradient control blocks.
// ============================================================================

fn pattern_strip(w: f32, h: f32, color: Hsla, width: f32, interval: f32) -> Div {
    div()
        .w(px(w))
        .h(px(h))
        .bg(pattern_slash(color, width, interval))
}

fn example_bench_pattern(_window: &mut Window, _cx: &mut App) -> impl IntoElement {
    div()
        .flex()
        .flex_col()
        .gap_3()
        .bg(white())
        .size(px(600.0))
        .justify_center()
        .items_center()
        .shadow_lg()
        .text_xl()
        .text_color(black())
        .child("Pattern Example")
        .child(
            div()
                .flex()
                .flex_col()
                .border_1()
                .border_color(blue())
                .child(pattern_strip(54.0, 18.0, red(), 18.0 / 4.0, 18.0 / 4.0))
                .child(pattern_strip(54.0, 18.0, red(), 18.0 / 4.0, 18.0 / 4.0))
                .child(pattern_strip(54.0, 18.0, red(), 18.0 / 4.0, 18.0 / 4.0))
                .child(pattern_strip(54.0, 18.0, red(), 18.0 / 4.0, 18.0 / 2.0)),
        )
        .child(
            div()
                .flex()
                .flex_col()
                .border_1()
                .border_color(blue())
                .bg(green().with_alpha(0.16))
                .child("Elements the same height should align")
                .child(pattern_strip(256.0, 56.0, red(), 56.0 / 6.0, 56.0 / 6.0))
                .child(pattern_strip(256.0, 56.0, green(), 56.0 / 6.0, 56.0 / 6.0))
                .child(pattern_strip(256.0, 56.0, blue(), 56.0 / 6.0, 56.0 / 6.0))
                .child(pattern_strip(256.0, 26.0, yellow(), 56.0 / 6.0, 56.0 / 6.0)),
        )
        .child(
            div()
                .border_1()
                .border_color(blue())
                .w(px(240.0))
                .h(px(40.0))
                .bg(red()),
        )
        .child(
            div()
                .border_1()
                .border_color(blue())
                .w(px(240.0))
                .h(px(40.0))
                .bg(linear_gradient(
                    45.,
                    linear_color_stop(red(), 0.),
                    linear_color_stop(blue(), 1.),
                )),
        )
}

// ============================================================================
// example_paths_bench — mirrors examples/bench/paths_bench.rs
// The bench builds 2000 identical lightning-bolt paths; the mirror keeps the
// exact star geometry from the loop body but draws five translated copies so the
// snapshot pins the path tessellation + Oklab gradient at small scale.
// ============================================================================

fn star_path(offset_x: f32, offset_y: f32) -> Path<Pixels> {
    let mut builder = PathBuilder::fill();
    builder.move_to(point(px(350. + offset_x), px(100. + offset_y)));
    builder.line_to(point(px(370. + offset_x), px(160. + offset_y)));
    builder.line_to(point(px(430. + offset_x), px(160. + offset_y)));
    builder.line_to(point(px(380. + offset_x), px(200. + offset_y)));
    builder.line_to(point(px(400. + offset_x), px(260. + offset_y)));
    builder.line_to(point(px(350. + offset_x), px(220. + offset_y)));
    builder.line_to(point(px(300. + offset_x), px(260. + offset_y)));
    builder.line_to(point(px(320. + offset_x), px(200. + offset_y)));
    builder.line_to(point(px(270. + offset_x), px(160. + offset_y)));
    builder.line_to(point(px(330. + offset_x), px(160. + offset_y)));
    builder.line_to(point(px(350. + offset_x), px(100. + offset_y)));
    builder.build().unwrap()
}

fn example_paths_bench(_window: &mut Window, _cx: &mut App) -> impl IntoElement {
    // The example calls `window.request_animation_frame()` every render to keep the
    // bench redrawing; a static mirror omits it (it only schedules a next frame, so
    // it is inert for a single pinned frame).
    let lines: Vec<(Path<Pixels>, Background)> =
        [(0., 0.), (150., 0.), (0., 180.), (150., 180.), (75., 360.)]
            .map(|(ox, oy)| {
                (
                    star_path(ox, oy),
                    linear_gradient(
                        180.,
                        linear_color_stop(rgb(0xFACC15), 0.7),
                        linear_color_stop(rgb(0xD56D0C), 1.),
                    )
                    .color_space(ColorSpace::Oklab),
                )
            })
            .to_vec();
    div().size_full().child(
        canvas(
            move |_, _, _| {},
            move |_, _, window, _| {
                for (path, color) in lines {
                    window.paint_path(path, color);
                }
            },
        )
        .size_full(),
    )
}

// ============================================================================
// example_data_table — mirrors examples/bench/data_table.rs
// The bench generates 10000 random quotes; the mirror keeps the header +
// zebra-striped uniform_list + first-frame scrollbar structure with 20
// deterministic rows and the example's *full* 24-column FIELDS. The visible-range
// header is the example's first-frame "0..0" value (set by the list's processor
// during layout).
// ============================================================================

const TABLE_FIELDS: [(&str, f32); 24] = [
    ("id", 64.),
    ("symbol", 64.),
    ("name", 180.),
    ("last_done", 80.),
    ("prev_close", 80.),
    ("open", 80.),
    ("low", 80.),
    ("high", 80.),
    ("ttm", 50.),
    ("market_cap", 96.),
    ("float_cap", 96.),
    ("turnover", 120.),
    ("volume", 100.),
    ("turnover_ratio", 96.),
    ("pe", 64.),
    ("pb", 64.),
    ("eps", 64.),
    ("shares", 96.),
    ("dividend", 64.),
    ("yield", 64.),
    ("dividend_per_share", 64.),
    ("dividend_date", 96.),
    ("dividend_payment", 64.),
    ("timestamp", 120.),
];

fn table_cell(key: &str, width: f32, ix: usize, color: Hsla) -> Div {
    // `render_cell` colors exactly the market-data cells; the rest keep the default
    // text color. Values are deterministic stand-ins for the bench's random quotes.
    let (value, colored) = match key {
        "id" => (format!("{ix}"), false),
        "symbol" => (format!("TICK{ix:03}"), false),
        "name" => (format!("Quote #{ix:05}"), false),
        "last_done" => (format!("{:.3}", 100.0 + ix as f64), true),
        "prev_close" => (format!("{:.3}", 100.0), true),
        "open" => (format!("{:.2}", 101.0 + ix as f64), true),
        "low" => (format!("{:.2}", 99.0 + ix as f64), true),
        "high" => (format!("{:.2}", 103.0 + ix as f64), true),
        "ttm" => (format!("{:.2}", ix as f64 * 0.5), false),
        "market_cap" => (format!("{:.2} M", 2.0 + ix as f64 * 0.1), false),
        "float_cap" => (format!("{:.2} M", 2.05 + ix as f64 * 0.1), false),
        "turnover" => (format!("{:.2} M", 4.0 + ix as f64 * 0.2), false),
        "volume" => (format!("{:.2} M", 1.0 + ix as f64 * 0.1), false),
        "turnover_ratio" => {
            let volume = 1.0 + ix as f64 * 0.1;
            let turnover = 4.0 + ix as f64 * 0.2;
            (format!("{:.2}%", volume / turnover * 100.0), false)
        }
        "pe" => (format!("{:.2}", 12.0 + ix as f64 * 0.25), false),
        "pb" => (format!("{:.2}", 1.5 + ix as f64 * 0.05), false),
        "eps" => (format!("{:.2}", 8.0 + ix as f64 * 0.1), false),
        "shares" => (format!("{:.2}", 500.0 + ix as f64 * 10.0), false),
        "dividend" => (format!("{:.2}", 0.5 + ix as f64 * 0.05), false),
        "yield" => (format!("{:.2}%", 1.0 + ix as f64 * 0.1), false),
        "dividend_per_share" => (format!("{:.2}", 0.25 + ix as f64 * 0.05), false),
        "dividend_date" => (
            format!(
                "{}-{:02}-{:02}",
                2020 + ix % 3,
                (ix % 12) + 1,
                (ix % 27) + 1
            ),
            false,
        ),
        "dividend_payment" => (format!("{:.2}", 0.3 + ix as f64 * 0.03), false),
        "timestamp" => (format!("{}", ix * 60), true),
        _ => ("--".to_string(), false),
    };
    let text = if colored {
        div().text_color(color).child(value)
    } else {
        div().child(value)
    };
    div()
        .whitespace_nowrap()
        .truncate()
        .w(px(width))
        .px_1()
        .child(text)
}

fn table_row(ix: usize) -> Div {
    // `change_color()` is green when change > 0, else red; change == ix here.
    let color = if ix > 0 { green() } else { red() };
    div()
        .flex()
        .flex_row()
        .border_b_1()
        .border_color(rgb(0xE0E0E0))
        .bg(if ix.is_multiple_of(2) {
            rgb(0xFFFFFF)
        } else {
            rgb(0xFAFAFA)
        })
        .py_0p5()
        .px_2()
        .children(TABLE_FIELDS.map(|(key, width)| table_cell(key, width, ix, color)))
}

fn example_data_table(_window: &mut Window, _cx: &mut App) -> impl IntoElement {
    const TOTAL_ITEMS: usize = 20; // the bench generates 10000 random quotes
    div()
        .bg(white())
        .text_sm()
        .size_full()
        .p_4()
        .gap_2()
        .flex()
        .flex_col()
        .child(format!("Total {TOTAL_ITEMS} items, visible range: 0..0"))
        .child(
            div()
                .flex()
                .flex_col()
                .flex_1()
                .overflow_hidden()
                .border_1()
                .border_color(rgb(0xE0E0E0))
                .rounded_sm()
                .child(
                    div()
                        .flex()
                        .flex_row()
                        .w_full()
                        .overflow_hidden()
                        .border_b_1()
                        .border_color(rgb(0xE0E0E0))
                        .text_color(rgb(0x555555))
                        .bg(rgb(0xF0F0F0))
                        .py_1()
                        .px_2()
                        .text_xs()
                        .children(TABLE_FIELDS.map(|(key, width)| {
                            div()
                                .whitespace_nowrap()
                                .flex_shrink_0()
                                .truncate()
                                .px_1()
                                .w(px(width))
                                .child(key.replace("_", " ").to_uppercase())
                        })),
                )
                .child(
                    div()
                        .relative()
                        .size_full()
                        .child(
                            uniform_list("items", TOTAL_ITEMS, |range, _window, _cx| {
                                range.map(table_row).collect::<Vec<_>>()
                            })
                            .size_full(),
                        )
                        // First frame: scroll metrics aren't laid out yet, so the example's
                        // render_scrollbar returns the empty `div().id("scrollbar")` placeholder.
                        .child(div().id("scrollbar")),
                ),
        )
}

/// Renders every statically-mirrorable learn/legacy/bench example on the harness
/// window and snapshots its finished scene archive.
#[test]
fn learn_example_scenes_match_snapshots() {
    let mut cx = TestAppContext::single();
    let cases: Vec<(
        &'static str,
        Size<Pixels>,
        Box<dyn Fn(&mut Window, &mut App) -> AnyElement>,
    )> = vec![
        (
            "interactive_elements", // examples/learn/interactive_elements.rs
            size(px(700.), px(850.)),
            Box::new(|window, cx| example_interactive_elements(window, cx).into_any_element()),
        ),
        (
            "creating_components", // examples/learn/creating_components.rs
            size(px(700.), px(500.)),
            Box::new(|window, cx| example_creating_components(window, cx).into_any_element()),
        ),
        (
            "layout", // examples/learn/layout.rs
            size(px(650.), px(1700.)),
            Box::new(|window, cx| example_layout(window, cx).into_any_element()),
        ),
        (
            "styling", // examples/learn/styling.rs
            size(px(550.), px(1300.)),
            Box::new(|window, cx| example_styling(window, cx).into_any_element()),
        ),
        (
            "text", // examples/learn/text.rs
            size(px(650.), px(1850.)),
            Box::new(|window, cx| example_text(window, cx).into_any_element()),
        ),
        (
            "transitions", // examples/learn/transitions.rs
            size(px(500.), px(650.)),
            Box::new(|window, cx| example_transitions(window, cx).into_any_element()),
        ),
        (
            "style_transitions", // examples/learn/style_transitions.rs
            size(px(500.), px(650.)),
            Box::new(|window, cx| example_style_transitions(window, cx).into_any_element()),
        ),
        (
            "blur", // examples/learn/blur.rs
            size(px(1060.), px(760.)),
            Box::new(|window, cx| example_blur(window, cx).into_any_element()),
        ),
        (
            "custom_drawing", // examples/learn/custom_drawing.rs
            size(px(550.), px(1250.)),
            Box::new(|window, cx| example_custom_drawing(window, cx).into_any_element()),
        ),
        (
            "animation", // examples/learn/animation.rs
            size(px(500.), px(1100.)),
            Box::new(|window, cx| example_animation(window, cx).into_any_element()),
        ),
        (
            "opacity", // examples/legacy/opacity.rs (already covered by Seg1)
            size(px(500.), px(500.)),
            Box::new(|window, cx| example_opacity(window, cx).into_any_element()),
        ),
        (
            "gradient", // examples/legacy/gradient.rs (already covered by Seg1)
            size(px(800.), px(800.)),
            Box::new(|window, cx| example_gradient(window, cx).into_any_element()),
        ),
        (
            "hello_world", // examples/legacy/hello_world.rs
            size(px(500.), px(500.)),
            Box::new(|window, cx| example_hello_world(window, cx).into_any_element()),
        ),
        (
            "scrollable", // examples/legacy/scrollable.rs (wide+tall frame pins the whole mirrored tree)
            size(px(2070.), px(5100.)),
            Box::new(|window, cx| example_scrollable(window, cx).into_any_element()),
        ),
        (
            "tree", // examples/legacy/tree.rs
            size(px(300.), px(300.)),
            Box::new(|window, cx| example_tree(window, cx).into_any_element()),
        ),
        (
            "uniform_list", // examples/legacy/uniform_list.rs
            size(px(300.), px(300.)),
            Box::new(|window, cx| example_uniform_list(window, cx).into_any_element()),
        ),
        (
            "focus_visible", // examples/legacy/focus_visible.rs (initial focus: no rings)
            size(px(800.), px(600.)),
            Box::new(|window, cx| example_focus_visible(window, cx).into_any_element()),
        ),
        (
            "tab_stop", // examples/legacy/tab_stop.rs (initial focus: no rings)
            size(px(800.), px(600.)),
            Box::new(|window, cx| example_tab_stop(window, cx).into_any_element()),
        ),
        (
            "window", // examples/legacy/window.rs (chrome: sub-windows open on click, inert headlessly)
            size(px(800.), px(600.)),
            Box::new(|window, cx| example_window(window, cx).into_any_element()),
        ),
        (
            "window_shadow", // examples/legacy/window_shadow.rs (Decorations::Server headlessly)
            size(px(600.), px(600.)),
            Box::new(|window, cx| example_window_shadow(window, cx).into_any_element()),
        ),
        (
            "bench_shadow", // examples/bench/shadow.rs (shadow elevations table; tall frame pins whole overflow_y_scroll table)
            size(px(1000.), px(2600.)),
            Box::new(|window, cx| example_bench_shadow(window, cx).into_any_element()),
        ),
        (
            "bench_pattern", // examples/bench/pattern.rs
            size(px(600.), px(600.)),
            Box::new(|window, cx| example_bench_pattern(window, cx).into_any_element()),
        ),
        (
            "bench_paths", // examples/bench/paths_bench.rs (small scale: 5 stars, not 2000)
            size(px(1024.), px(768.)),
            Box::new(|window, cx| example_paths_bench(window, cx).into_any_element()),
        ),
        (
            "bench_data_table", // examples/bench/data_table.rs (20 deterministic rows, not 10000 random; full 24-column FIELDS on a widened frame)
            size(px(2070.), px(1000.)),
            Box::new(|window, cx| example_data_table(window, cx).into_any_element()),
        ),
    ];
    for (name, window_size, build) in cases {
        snapshot_case(&mut cx, name, window_size, build);
    }
}
