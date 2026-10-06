//! Transition Example
//!
//! This example uses a keyed transition to bounce a button upward.
//! Each click resets the transition before starting the same bounce again.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use std::time::Duration;

use gpui::{
    AnyElement, App, AppContext, Context, ElementId, Lerp, MotionDurationExt, Rgba, Window, bounce,
    div, ease_in_out, millis, prelude::*, px, rgb, spring,
};
use smallvec::SmallVec;

const BUTTON_WIDTH: f32 = 120.;
const BUTTON_HEIGHT: f32 = 44.;
const BOUNCE_HEIGHT: f32 = 120.;
const BOUNCE_DURATION: Duration = Duration::from_millis(1200);

#[derive(IntoElement)]
struct Button {
    id: ElementId,
    children: SmallVec<[AnyElement; 2]>,
}

impl Button {
    fn new(id: impl Into<ElementId>) -> Self {
        Self {
            id: id.into(),
            children: SmallVec::new(),
        }
    }
}

impl ParentElement for Button {
    fn extend(&mut self, elements: impl IntoIterator<Item = AnyElement>) {
        self.children.extend(elements);
    }
}

impl RenderOnce for Button {
    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement {
        let bounce_transition = window
            .use_keyed_transition(
                (self.id.clone(), "bounce"),
                cx,
                BOUNCE_DURATION,
                |_window, _cx| 0.,
            )
            .with_easing(bounce(ease_in_out));
        let progress = *bounce_transition.evaluate(window, cx);
        div()
            .id(self.id)
            .absolute()
            .left(px(0.))
            .top(px(BOUNCE_HEIGHT * (1. - progress)))
            .w(px(BUTTON_WIDTH))
            .h(px(BUTTON_HEIGHT))
            .flex()
            .items_center()
            .justify_center()
            .cursor_pointer()
            .rounded(px(100.))
            .bg(rgb(0x663399))
            .text_color(rgb(0xffffff))
            .children(self.children)
            .on_click(move |_, _window, cx| {
                bounce_transition.reset(cx);
                bounce_transition.update(cx, |progress, cx| {
                    *progress = 1.;
                    cx.notify();
                });
            })
    }
}

struct TransitionExample;

impl Render for TransitionExample {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .flex_col()
            .items_center()
            .justify_center()
            .gap_8()
            .p_8()
            .bg(rgb(0x110F15))
            .child(
                div()
                    .flex()
                    .flex_col()
                    .items_center()
                    .gap_2()
                    .child(
                        div()
                            .text_lg()
                            .text_color(rgb(0xffffff))
                            .child("Keyed transition"),
                    )
                    .child(
                        div()
                            .text_sm()
                            .text_color(rgb(0xaaa6b5))
                            .child("Click to restart the bounce"),
                    )
                    .child(
                        div()
                            .relative()
                            .h(px(BOUNCE_HEIGHT + BUTTON_HEIGHT))
                            .w(px(BUTTON_WIDTH))
                            .child(Button::new("btn").child("Bounce!")),
                    ),
            )
            .child(
                div()
                    .flex()
                    .flex_col()
                    .items_center()
                    .gap_2()
                    .child(
                        div()
                            .text_lg()
                            .text_color(rgb(0xffffff))
                            .child("Style transition"),
                    )
                    .child(
                        div()
                            .text_sm()
                            .text_color(rgb(0xaaa6b5))
                            .child("Hover to grow; press to change color"),
                    )
                    .child(StyledButton::new("styled-button").child("Hover me")),
            )
    }
}

/// A compact companion to the keyed example above: style transitions interpolate
/// refinements as pointer state changes, so the initial and active states are useful
/// visual checkpoints even before animation timing is involved.
#[derive(IntoElement)]
struct StyledButton {
    id: ElementId,
    children: SmallVec<[AnyElement; 2]>,
}

impl StyledButton {
    fn new(id: impl Into<ElementId>) -> Self {
        Self {
            id: id.into(),
            children: SmallVec::new(),
        }
    }
}

impl ParentElement for StyledButton {
    fn extend(&mut self, elements: impl IntoIterator<Item = AnyElement>) {
        self.children.extend(elements);
    }
}

impl RenderOnce for StyledButton {
    fn render(self, _window: &mut Window, _cx: &mut App) -> impl IntoElement {
        const HOVER_STRENGTH: f32 = 0.2;
        const ACTIVE_STRENGTH: f32 = 0.3;

        let base_color: Rgba = rgb(0x663399);
        let hover_color = base_color.lerp(&rgb(0x000), HOVER_STRENGTH);
        let active_color = base_color.lerp(&rgb(0x000), ACTIVE_STRENGTH);

        div()
            .id(self.id)
            .cursor_pointer()
            .rounded(px(99999.))
            .px(px(14.))
            .py(px(10.))
            .bg(base_color)
            .text_color(rgb(0xffffff))
            .children(self.children)
            .transitions(|transitions| {
                transitions
                    .bg(millis(200).with_easing(ease_in_out))
                    .p(spring(600.0, 22.0, 1.0))
            })
            .hover(|refinement| refinement.bg(hover_color).p(px(20.)))
            .active(|refinement| refinement.bg(active_color))
    }
}

fn main() {
    gpui_platform::application().run(|cx: &mut App| {
        let options = example_prelude::centered_window(500., 650., cx);
        cx.open_window(options, |_, cx| cx.new(|_| TransitionExample))
            .expect("Failed to open window");

        example_prelude::init_example(cx, "Transitions");
    });
}
