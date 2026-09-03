//! Headless snapshot corpus for the `examples/learn` (and two legacy) example UIs.
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
//! - `examples/legacy/gif_viewer.rs`, `examples/legacy/image_loading.rs` — gh-assets: image
//!   decoding from disk. The hermetic asset source returns `None`, so the mirror would only
//!   capture an empty placeholder rectangle — skipping avoids a misleading snapshot.

use std::time::Duration;

use palette::{IntoColor, WithAlpha};

use crate::colors::Colors;
use crate::util::FluentBuilder as _;
use crate::{
    Animation, AnimationExt as _, AnyElement, App, AppContext, Bounds, BoxShadow, Canvas, ColorExt,
    ColorSpace, Context, Div, DurationWithEasing, ElementId, FontStyle, FontWeight, Half, Hsla,
    IntoElement, Lerp, Path, PathBuilder, Pixels, Point, Render, Rgba, SceneArchive, Size,
    StyledText, TestAppContext, Transformation, Window, black, blue, bounce, canvas, deferred, div,
    ease_in_out, fill, green, hsla, linear, linear_color_stop, linear_gradient, percentage, point,
    prelude::*, px, red, relative, rgb, rgba, size, svg, transparent_black, white, yellow,
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

/// Renders every statically-mirrorable learn/legacy example on the harness window
/// and snapshots its finished scene archive.
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
            "opacity", // examples/legacy/opacity.rs
            size(px(500.), px(500.)),
            Box::new(|window, cx| example_opacity(window, cx).into_any_element()),
        ),
        (
            "gradient", // examples/legacy/gradient.rs
            size(px(800.), px(800.)),
            Box::new(|window, cx| example_gradient(window, cx).into_any_element()),
        ),
    ];
    for (name, window_size, build) in cases {
        snapshot_case(&mut cx, name, window_size, build);
    }
}
