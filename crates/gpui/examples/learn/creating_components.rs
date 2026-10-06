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
    id: &'static str,
    count: i32,
    colors: Colors,
    increment: Box<dyn Fn(&mut Window, &mut App) + 'static>,
    decrement: Box<dyn Fn(&mut Window, &mut App) + 'static>,
}

impl CounterCard {
    fn new(
        label: &'static str,
        id: &'static str,
        count: i32,
        colors: Colors,
        increment: impl Fn(&mut Window, &mut App) + 'static,
        decrement: impl Fn(&mut Window, &mut App) + 'static,
    ) -> Self {
        Self {
            label,
            id,
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
        let id = self.id;
        div()
            .id(id)
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
                        id,
                        "decrement",
                        "−",
                        rgb(0xd32f2f),
                        self.decrement,
                    ))
                    .child(counter_button(
                        id,
                        "increment",
                        "+",
                        rgb(0x388e3c),
                        self.increment,
                    )),
            )
    }
}

fn counter_button(
    owner: &'static str,
    id: &'static str,
    label: &'static str,
    color: gpui::Rgba,
    action: impl Fn(&mut Window, &mut App) + 'static,
) -> gpui::Stateful<gpui::Div> {
    div()
        .id(id)
        .debug_selector(|| format!("{owner}-{id}"))
        .px_3()
        .py_1()
        .rounded_md()
        .bg(color)
        .text_color(gpui::white())
        .cursor_pointer()
        .hover(|style| style.opacity(0.8))
        .on_click(move |_, window, cx| action(window, cx))
        .child(label)
}

struct ElementCounter {
    count: i32,
}

fn element_counter(colors: &Colors, window: &mut Window, cx: &mut App) -> CounterCard {
    // The element identity keeps this state alive between renders at this call site.
    let state = window.use_state(cx, |_window, _cx| ElementCounter { count: 0 });
    let count = state.read(cx).count;
    let decrement = state.clone();
    CounterCard::new(
        "use_state: element-local",
        "element",
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
            "entity",
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
    #[cfg(test)]
    rendered_element_count: i32,
}

impl Render for CreatingComponents {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let colors = Colors::for_appearance(window);
        let parent = cx.entity().downgrade();
        let decrement = parent.clone();
        let element_card = element_counter(&colors, window, cx);
        #[cfg(test)]
        {
            self.rendered_element_count = element_card.count;
        }
        div()
            .id("component-state")
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
                    .child(element_card)
                    .child(CounterCard::new(
                        "RenderOnce: parent-owned props",
                        "props",
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

impl CreatingComponents {
    fn new(cx: &mut Context<Self>) -> Self {
        Self {
            entity_counter: cx.new(|_| EntityCounter { count: 0 }),
            prop_count: 0,
            #[cfg(test)]
            rendered_element_count: 0,
        }
    }
}

fn main() {
    gpui_platform::application().run(|cx: &mut App| {
        let options = example_prelude::centered_window(760., 360., cx);
        cx.open_window(options, |_, cx| cx.new(CreatingComponents::new))
            .expect("open component example");
        init_example(cx, "Creating Components");
    });
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui::{px, size};
    use gpui_test::{Harness, Scenario, dispatch_click_on};
    use std::time::Duration;

    fn assert_counts(
        cx: &mut gpui::HeadlessAppContext,
        view: &Entity<CreatingComponents>,
        window: gpui::WindowHandle<CreatingComponents>,
        expected: [i32; 3],
    ) -> anyhow::Result<()> {
        // Observe the local count presented by a fresh render, along with both owned states.
        cx.draw_window(window.into())?;
        let actual = view.read_with(cx, |this, app| {
            [
                this.rendered_element_count,
                this.prop_count,
                this.entity_counter.read(app).count,
            ]
        });
        anyhow::ensure!(
            actual == expected,
            "[element, props, entity] expected {expected:?}, rendered {actual:?}"
        );
        Ok(())
    }

    #[test]
    fn all_counter_models_handle_clicks_and_keep_state_through_redraws() -> anyhow::Result<()> {
        let scenario = Scenario::new(
            "component-state-test",
            "Component state interactions",
            size(px(760.), px(360.)),
            |_, cx: &mut App| cx.new(CreatingComponents::new),
        )?
        .checkpoint("initial", "Initial values", Duration::ZERO)?
        .checkpoint_with(
            "incremented",
            "Increment each state owner",
            Duration::from_millis(1),
            |cx, view, window| {
                dispatch_click_on(cx, window.into(), "element-increment")?;
                dispatch_click_on(cx, window.into(), "props-increment")?;
                dispatch_click_on(cx, window.into(), "entity-increment")?;
                assert_counts(cx, view, window, [1, 1, 1])
            },
        )?
        .checkpoint_with(
            "redrawn",
            "Parent redraw preserves independent state",
            Duration::from_millis(2),
            |cx, view, window| {
                dispatch_click_on(cx, window.into(), "props-increment")?;
                assert_counts(cx, view, window, [1, 2, 1])
            },
        )?
        .checkpoint_with(
            "reset",
            "Decrement each value back to zero",
            Duration::from_millis(3),
            |cx, view, window| {
                dispatch_click_on(cx, window.into(), "element-decrement")?;
                dispatch_click_on(cx, window.into(), "props-decrement")?;
                dispatch_click_on(cx, window.into(), "props-decrement")?;
                dispatch_click_on(cx, window.into(), "entity-decrement")?;
                assert_counts(cx, view, window, [0, 0, 0])
            },
        )?;

        Harness::new().run(&scenario)?;
        Ok(())
    }
}
