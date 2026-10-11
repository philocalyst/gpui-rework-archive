# 3. Layout and style

In this chapter you turn the list into something that looks like an app: a
centered column, rows with checkboxes, and a count of what's left to do.

## Center a column

Most interfaces are boxes inside boxes, arranged with *flexbox*: a container lays
out its children in a row or a column, and you control how they share the space.
Here the window centers a column that is at most 480 pixels wide:

```
# use gpui::{IntoElement, div, prelude::*, px};
# fn page() -> impl IntoElement {
div()
    .size_full()
    .flex()
    .justify_center()
    .p_8()
    .child(
        div()
            .w_full()
            .max_w(px(480.))
            .flex()
            .flex_col()
            .gap_4()
            .child("Todos"),
    )
# }
```

[`flex`](Styled::flex) makes the outer box a flex container, and
[`justify_center`](Styled::justify_center) centers its children along its main
axis, horizontally. The inner box asks for the full width with
[`w_full`](Styled::w_full) but caps it with [`max_w`](Styled::max_w), so it is
480 pixels wide in a large window and shrinks with a small one.
[`flex_col`](Styled::flex_col) stacks its own children vertically, and
[`gap_4`](Styled::gap_2) puts a rem of space between them.

[`px`] is a length in logical pixels. GPUI scales it to the display for you, so
480 logical pixels look the same size on a regular and a high-resolution screen.

## Style the rows

Each row is a small flex row of its own: a round checkbox, then the title, which
takes up the remaining width with [`flex_1`](Styled::flex_1).

```
# use gpui::{Context, SharedString, Window, colors::Colors, div, prelude::*};
# struct Todo { title: SharedString, done: bool }
# struct Todos { todos: Vec<Todo> }
# impl Todos {
fn row(&self, index: usize, todo: &Todo, colors: &Colors, cx: &mut Context<Self>) -> impl IntoElement + use<> {
    div()
        .id(index)
        .flex()
        .items_center()
        .gap_3()
        .px_2()
        .py_2()
        .rounded_md()
        .cursor_pointer()
        .hover(|style| style.bg(colors.container))
        .child(
            div()
                .size_5()
                .rounded_full()
                .border_1()
                .border_color(colors.border)
                .when(todo.done, |checkbox| checkbox.bg(colors.selected)),
        )
        .child(
            div()
                .flex_1()
                .when(todo.done, |title| title.line_through().text_color(colors.disabled))
                .child(todo.title.clone()),
        )
        .on_click(cx.listener(move |todos, _event, _window, cx| {
            let todo = &mut todos.todos[index];
            todo.done = !todo.done;
            cx.notify();
        }))
}
# }
```

Moving the row into a method keeps `render` readable. A method that returns
`impl IntoElement` is the simplest way to split up a view; you'll meet the other
ways in [chapter 5](crate::_documentation::tutorial::ch5_components).

The `+ use<>` after the return type says that the element the method returns
doesn't borrow any of its arguments: it owns everything it needs. Without it,
Rust assumes the element might still borrow `cx`, and won't let you call `row`
for each todo inside the closure you pass to `map`.

[`hover`](InteractiveElement::hover) takes the style changes to apply while the
pointer is over the row. GPUI tracks the hover state and redraws the row for
you; there's nothing to notify.

## Count what's left

Finish `render` with a title, the rows, and a footer:

```
# use gpui::{Context, FontWeight, SharedString, Window, colors::Colors, div, prelude::*, px};
# struct Todo { title: SharedString, done: bool }
# struct Todos { todos: Vec<Todo> }
# impl Todos {
#     fn row(&self, _: usize, _: &Todo, _: &Colors, _: &mut Context<Self>) -> impl IntoElement + use<> { div() }
# }
impl Render for Todos {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let colors = Colors::for_appearance(window);
        let left = self.todos.iter().filter(|todo| !todo.done).count();

        div()
            .size_full()
            .flex()
            .justify_center()
            .p_8()
            .bg(colors.background)
            .text_color(colors.text)
            .child(
                div()
                    .w_full()
                    .max_w(px(480.))
                    .flex()
                    .flex_col()
                    .gap_4()
                    .child(div().text_3xl().font_weight(FontWeight::SEMIBOLD).child("Todos"))
                    .child(
                        div().flex().flex_col().children(
                            self.todos
                                .iter()
                                .enumerate()
                                .map(|(index, todo)| self.row(index, todo, &colors, cx)),
                        ),
                    )
                    .child(div().text_sm().text_color(colors.disabled).child(format!("{left} left"))),
            )
    }
}
```

The count is computed from the state on every render, rather than stored in a
field and kept up to date by hand. Because `render` runs whenever the view
changes, anything you can derive from your state is best derived there.

## The program so far

<details>
<summary>src/main.rs</summary>

```no_run
use gpui::{
    App, Context, FontWeight, QuitMode, SharedString, Window, WindowOptions, colors::Colors,
    div, prelude::*, px,
};

struct Todo {
    title: SharedString,
    done: bool,
}

struct Todos {
    todos: Vec<Todo>,
}

impl Todos {
    fn new() -> Self {
        Self {
            todos: vec![
                Todo { title: "Buy milk".into(), done: false },
                Todo { title: "Water the plants".into(), done: true },
                Todo { title: "Call Sam".into(), done: false },
            ],
        }
    }

    fn row(&self, index: usize, todo: &Todo, colors: &Colors, cx: &mut Context<Self>) -> impl IntoElement + use<> {
        div()
            .id(index)
            .flex()
            .items_center()
            .gap_3()
            .px_2()
            .py_2()
            .rounded_md()
            .cursor_pointer()
            .hover(|style| style.bg(colors.container))
            .child(
                div()
                    .size_5()
                    .rounded_full()
                    .border_1()
                    .border_color(colors.border)
                    .when(todo.done, |checkbox| checkbox.bg(colors.selected)),
            )
            .child(
                div()
                    .flex_1()
                    .when(todo.done, |title| title.line_through().text_color(colors.disabled))
                    .child(todo.title.clone()),
            )
            .on_click(cx.listener(move |todos, _event, _window, cx| {
                let todo = &mut todos.todos[index];
                todo.done = !todo.done;
                cx.notify();
            }))
    }
}

impl Render for Todos {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let colors = Colors::for_appearance(window);
        let left = self.todos.iter().filter(|todo| !todo.done).count();

        div()
            .size_full()
            .flex()
            .justify_center()
            .p_8()
            .bg(colors.background)
            .text_color(colors.text)
            .child(
                div()
                    .w_full()
                    .max_w(px(480.))
                    .flex()
                    .flex_col()
                    .gap_4()
                    .child(div().text_3xl().font_weight(FontWeight::SEMIBOLD).child("Todos"))
                    .child(
                        div().flex().flex_col().children(
                            self.todos
                                .iter()
                                .enumerate()
                                .map(|(index, todo)| self.row(index, todo, &colors, cx)),
                        ),
                    )
                    .child(div().text_sm().text_color(colors.disabled).child(format!("{left} left"))),
            )
    }
}

fn main() {
    gpui_platform::application()
        .with_quit_mode(QuitMode::LastWindowClosed)
        .run(|cx: &mut App| {
            cx.open_window(WindowOptions::default(), |_window, cx| cx.new(|_cx| Todos::new()))
                .unwrap();
            cx.activate(true);
        });
}
```

</details>

Next, [chapter 4](crate::_documentation::tutorial::ch4_text_input) adds a text
field so you can add your own todos.
