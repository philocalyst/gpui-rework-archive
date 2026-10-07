//! The same counter UI with three owners: element state, parent props, and a child entity.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::{App, Context, Entity, IntoElement, RenderOnce, Window, div, prelude::*, px, rgb, size};
use std::rc::Rc;

// RenderOnce consumes props. The component has no state or subscriptions of its own.
#[derive(IntoElement)]
struct CounterCard {
    label: &'static str,
    id: &'static str,
    count: i32,
    on_change: Rc<dyn Fn(i32, &mut App)>,
}

impl CounterCard {
    fn new(
        label: &'static str,
        id: &'static str,
        count: i32,
        on_change: impl Fn(i32, &mut App) + 'static,
    ) -> Self {
        Self {
            label,
            id,
            count,
            on_change: Rc::new(on_change),
        }
    }
}

impl RenderOnce for CounterCard {
    fn render(self, _window: &mut Window, _cx: &mut App) -> impl IntoElement {
        div()
            .id(self.id)
            .p_4()
            .flex_1()
            .min_w(px(180.))
            .rounded_md()
            .bg(rgb(0xffffff))
            .child(self.label)
            .child(div().text_2xl().child(self.count.to_string()))
            .child(
                div().flex().gap_2().children(
                    [(-1, "decrement", "−"), (1, "increment", "+")]
                        .into_iter()
                        .map(|(delta, id, label)| {
                            let owner = self.id;
                            let on_change = self.on_change.clone();
                            div()
                                .id(id)
                                .debug_selector(move || format!("{owner}-{id}"))
                                .px_3()
                                .py_1()
                                .rounded_md()
                                .bg(rgb(0x3478c8))
                                .text_color(rgb(0xffffff))
                                .cursor_pointer()
                                .child(label)
                                .on_click(move |_, _, cx| on_change(delta, cx))
                        }),
                ),
            )
    }
}

fn element_counter(window: &mut Window, cx: &mut App) -> CounterCard {
    // GPUI associates use_state with this position in the element tree. Stable identity matters.
    let state = window.use_state(cx, |_, _| 0i32);
    let count = *state.read(cx);
    CounterCard::new(
        "Element-local: use_state",
        "element",
        count,
        move |delta, cx| {
            state.update(cx, |count, cx| {
                *count += delta;
                cx.notify();
            });
        },
    )
}

#[derive(Default)]
struct EntityCounter {
    count: i32,
}

impl Render for EntityCounter {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        // A child entity can update independently. A weak handle avoids retaining itself.
        let entity = cx.entity().downgrade();
        CounterCard::new(
            "Child entity: Render",
            "entity",
            self.count,
            move |delta, cx| {
                let _ = entity.update(cx, |this, cx| {
                    this.count += delta;
                    cx.notify();
                });
            },
        )
    }
}

struct CreatingComponents {
    prop_count: i32,
    entity_counter: Entity<EntityCounter>,
    #[cfg(test)]
    rendered_element_count: i32,
}

impl CreatingComponents {
    fn new(cx: &mut Context<Self>) -> Self {
        Self {
            prop_count: 0,
            entity_counter: cx.new(|_| EntityCounter::default()),
            #[cfg(test)]
            rendered_element_count: 0,
        }
    }
}

impl Render for CreatingComponents {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let element = element_counter(window, cx);
        #[cfg(test)]
        {
            self.rendered_element_count = element.count;
        }

        // Updating these props notifies the parent, which renders a fresh stateless CounterCard.
        let parent = cx.entity().downgrade();
        let props = CounterCard::new(
            "Parent props: RenderOnce",
            "props",
            self.prop_count,
            move |delta, cx| {
                let _ = parent.update(cx, |this, cx| {
                    this.prop_count += delta;
                    cx.notify();
                });
            },
        );
        div()
            .id("component-state")
            .size_full()
            .p_4()
            .bg(rgb(0xf1f3f6))
            .flex()
            .flex_col()
            .gap_3()
            .child("Click each counter. Changing one owner must leave the other two alone.")
            .child(
                div()
                    .flex()
                    .flex_wrap()
                    .gap_3()
                    .child(element)
                    .child(props)
                    .child(self.entity_counter.clone()),
            )
    }
}

fn main() {
    example_prelude::run_example("Component state", size(px(760.), px(240.)), |_, cx| {
        cx.new(CreatingComponents::new)
    });
}

#[cfg(all(test, feature = "test-support"))]
#[path = "creating_components/tests.rs"]
mod tests;
