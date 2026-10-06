//! Three ways to give a component state: element-local, parent-owned props, and an entity.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use example_prelude::init_example;
use gpui::colors::Colors;
use gpui::{
    App, Context, Entity, IntoElement, Render, RenderOnce, Window, div, prelude::*, px, rgb,
};

#[derive(IntoElement)]
struct CounterCard {
    label: &'static str,
    count: i32,
    colors: Colors,
    increment: Box<dyn Fn(&mut Window, &mut App) + 'static>,
    decrement: Box<dyn Fn(&mut Window, &mut App) + 'static>,
}

impl CounterCard {
    fn new(
        label: &'static str,
        count: i32,
        colors: Colors,
        increment: impl Fn(&mut Window, &mut App) + 'static,
        decrement: impl Fn(&mut Window, &mut App) + 'static,
    ) -> Self {
        Self {
            label,
            count,
            colors,
            increment: Box::new(increment),
            decrement: Box::new(decrement),
        }
    }
}

impl RenderOnce for CounterCard {
    fn render(self, _window: &mut Window, _cx: &mut App) -> impl IntoElement {
        let colors = self.colors;
        div()
            .flex()
            .flex_col()
            .gap_2()
            .p_4()
            .min_w(px(160.))
            .rounded_lg()
            .bg(colors.container)
            .child(
                div()
                    .text_sm()
                    .text_color(colors.disabled)
                    .child(self.label),
            )
            .child(
                div()
                    .text_2xl()
                    .text_color(colors.text)
                    .child(self.count.to_string()),
            )
            .child(
                div()
                    .flex()
                    .gap_2()
                    .child(counter_button(
                        (self.label, "decrement"),
                        "−",
                        rgb(0xd32f2f),
                        self.decrement,
                    ))
                    .child(counter_button(
                        (self.label, "increment"),
                        "+",
                        rgb(0x388e3c),
                        self.increment,
                    )),
            )
    }
}

fn counter_button(
    id: impl Into<gpui::ElementId>,
    label: &'static str,
    color: gpui::Rgba,
    action: impl Fn(&mut Window, &mut App) + 'static,
) -> impl IntoElement {
    let hover = color;
    div()
        .id(id)
        .px_3()
        .py_1()
        .rounded_md()
        .bg(color)
        .text_color(gpui::white())
        .cursor_pointer()
        .hover(move |style| style.opacity(0.8).bg(hover))
        .on_click(move |_, window, cx| action(window, cx))
        .child(label)
}

struct ElementCounter {
    count: i32,
}

fn element_counter(colors: &Colors, window: &mut Window, cx: &mut App) -> impl IntoElement {
    // The element identity keeps this state alive between renders at this call site.
    let state = window.use_state(cx, |_window, _cx| ElementCounter { count: 0 });
    let count = state.read(cx).count;
    let decrement = state.clone();
    CounterCard::new(
        "use_state: element-local",
        count,
        colors.clone(),
        move |_, cx| {
            state.update(cx, |state, cx| {
                state.count += 1;
                cx.notify();
            });
        },
        move |_, cx| {
            decrement.update(cx, |state, cx| {
                state.count -= 1;
                cx.notify();
            });
        },
    )
}

struct EntityCounter {
    count: i32,
}

impl Render for EntityCounter {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let colors = Colors::for_appearance(window);
        let entity = cx.entity().downgrade();
        let decrement = entity.clone();
        CounterCard::new(
            "Render: entity-owned",
            self.count,
            colors,
            move |_, cx| {
                entity
                    .update(cx, |this, cx| {
                        this.count += 1;
                        cx.notify();
                    })
                    .ok();
            },
            move |_, cx| {
                decrement
                    .update(cx, |this, cx| {
                        this.count -= 1;
                        cx.notify();
                    })
                    .ok();
            },
        )
    }
}

struct CreatingComponents {
    entity_counter: Entity<EntityCounter>,
    prop_count: i32,
}

impl Render for CreatingComponents {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let colors = Colors::for_appearance(window);
        let parent = cx.entity().downgrade();
        let decrement = parent.clone();
        div()
            .size_full()
            .flex()
            .flex_col()
            .gap_4()
            .p_6()
            .bg(colors.background)
            .overflow_scroll()
            .child(
                div()
                    .text_xl()
                    .font_weight(gpui::FontWeight::BOLD)
                    .text_color(colors.text)
                    .child("Component state"),
            )
            .child(
                div()
                    .text_sm()
                    .text_color(colors.disabled)
                    .child("Same counter UI, three ownership models. Click + or − to compare."),
            )
            .child(
                div()
                    .flex()
                    .flex_wrap()
                    .gap_3()
                    .child(element_counter(&colors, window, cx))
                    .child(CounterCard::new(
                        "RenderOnce: parent-owned props",
                        self.prop_count,
                        colors.clone(),
                        move |_, cx| {
                            parent
                                .update(cx, |this, cx| {
                                    this.prop_count += 1;
                                    cx.notify();
                                })
                                .ok();
                        },
                        move |_, cx| {
                            decrement
                                .update(cx, |this, cx| {
                                    this.prop_count -= 1;
                                    cx.notify();
                                })
                                .ok();
                        },
                    ))
                    .child(self.entity_counter.clone()),
            )
    }
}

fn main() {
    gpui_platform::application().run(|cx: &mut App| {
        let options = example_prelude::centered_window(760., 360., cx);
        cx.open_window(options, |_, cx| {
            cx.new(|cx| CreatingComponents {
                entity_counter: cx.new(|_| EntityCounter { count: 0 }),
                prop_count: 0,
            })
        })
        .expect("open component example");
        init_example(cx, "Creating Components");
    });
}
