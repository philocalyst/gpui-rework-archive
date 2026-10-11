# 8. Testing

You've been checking the app by running it and clicking around. In this last
chapter you write tests that do the same thing, without a window, in a fraction of
a second, so you can change the app with confidence.

## Let tests set up the app

Tests need the same key bindings as the app. Move them out of `main` into a
function that both can call:

```standalone_crate
# use gpui::{App, KeyBinding, actions};
# use gpui_ce_elements::editable_text::actions::{DEFAULT_INPUT_CONTEXT, default_bindings};
# actions!(todos, [AddTodo]);
/// The text field's editing keys, and Enter to add a todo.
fn bind_keys(cx: &mut App) {
    cx.bind_keys(default_bindings().as_keybindings(Some(DEFAULT_INPUT_CONTEXT)));
    cx.bind_keys([KeyBinding::new("enter", AddTodo, Some("Todos"))]);
}
```

and call `bind_keys(cx)` at the start of the closure in `main`.

GPUI's testing tools are behind its `test-support` feature, so enable it for
tests only:

```toml
[dev-dependencies]
gpui = { package = "gpui-ce", git = "https://github.com/gpui-ce/gpui-ce", features = ["test-support"] }
```

## Test typing a todo

Add a test module at the bottom of `src/main.rs`:

```standalone_crate,no_run
# use gpui::{App, Context, Entity, Focusable, KeyBinding, SharedString, Window, actions, div, prelude::*};
# use gpui_ce_elements::editable_text::{EditableTextState, StringStorage, actions::{DEFAULT_INPUT_CONTEXT, default_bindings}, text_input};
# actions!(todos, [AddTodo]);
# struct Todo { title: SharedString }
# struct Todos { todos: Vec<Todo>, input: Entity<EditableTextState> }
# impl Todos {
#     fn new(window: &mut Window, cx: &mut Context<Self>) -> Self {
#         let input = cx.new(|cx| EditableTextState::new(StringStorage::default(), cx));
#         window.focus(&input.focus_handle(cx), cx);
#         Self { todos: Vec::new(), input }
#     }
#     fn add(&mut self, _: &AddTodo, _: &mut Window, cx: &mut Context<Self>) {
#         let title = self.input.read(cx).as_str().trim().to_string();
#         self.todos.push(Todo { title: title.into() });
#         self.input.update(cx, |input, cx| input.emplace("", cx));
#     }
# }
# impl Render for Todos {
#     fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
#         div().key_context("Todos").on_action(cx.listener(Self::add)).child(text_input("new-todo").state(self.input.downgrade()))
#     }
# }
# fn bind_keys(cx: &mut App) {
#     cx.bind_keys(default_bindings().as_keybindings(Some(DEFAULT_INPUT_CONTEXT)));
#     cx.bind_keys([KeyBinding::new("enter", AddTodo, Some("Todos"))]);
# }
# fn main() {}
#[cfg(test)]
mod tests {
    use super::*;
    use gpui::TestApp;

    #[test]
    fn enter_adds_a_todo_and_clears_the_field() {
        let mut app = TestApp::new();
        app.update(bind_keys);
        let mut window = app.open_window(Todos::new);

        window.simulate_input("Milk");
        window.simulate_keystrokes("enter");

        window.read(|todos, cx| {
            assert_eq!(todos.todos.len(), 1);
            assert_eq!(todos.todos[0].title, "Milk");
            assert_eq!(todos.input.read(cx).as_str(), "");
        });
    }
}
```

Run it with `cargo test`.

[`TestApp`] is a complete GPUI app with a pretend platform: windows exist, render
and lay out, but nothing is drawn to a screen. [`open_window`](TestApp::open_window)
builds your view the same way `main` does. The window it returns can simulate
input, like typing characters and pressing keys, and can read or update the view.

The test goes through the same path as a real keystroke: the field has focus,
the characters go to it, Enter matches your binding in the `Todos` context, and
`add` runs. If any of those pieces breaks, so does the test.

## Test the undo timeout

Tasks and timers are testable too. In tests GPUI runs on a simulated clock that
only moves when you tell it to, so a four-second timeout takes no time at all:

```standalone_crate,no_run
# use std::time::Duration;
# use gpui::{Context, SharedString, Task, Window, div, prelude::*};
# struct Todo { id: usize, title: SharedString, done: bool }
# struct Todos { todos: Vec<Todo>, deleted: Option<(usize, Todo)>, undo_timeout: Task<()> }
# impl Todos {
#     fn new(_: &mut Window, _: &mut Context<Self>) -> Self { Self { todos: Vec::new(), deleted: None, undo_timeout: Task::ready(()) } }
#     fn delete(&mut self, id: usize, cx: &mut Context<Self>) {
#         let Some(index) = self.todos.iter().position(|todo| todo.id == id) else { return };
#         self.deleted = Some((index, self.todos.remove(index)));
#         self.undo_timeout = cx.spawn(async move |todos, cx| {
#             cx.background_executor().timer(Duration::from_secs(4)).await;
#             todos.update(cx, |todos, cx| { todos.deleted = None; cx.notify(); }).ok();
#         });
#     }
#     fn undo(&mut self, _: &mut Context<Self>) {
#         if let Some((index, todo)) = self.deleted.take() { self.todos.insert(index, todo); }
#     }
# }
# impl Render for Todos {
#     fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement { div() }
# }
# fn main() {}
# #[cfg(test)]
# mod tests {
#     use super::*;
#     use gpui::TestApp;
#[test]
fn a_deleted_todo_can_be_restored_until_the_offer_expires() {
    let mut app = TestApp::new();
    let mut window = app.open_window(Todos::new);
    window.update(|todos, _, cx| {
        todos.todos.push(Todo { id: 0, title: "Bread".into(), done: false });
        todos.delete(0, cx);
        todos.undo(cx);
    });
    window.read(|todos, _| assert_eq!(todos.todos.len(), 1));

    window.update(|todos, _, cx| todos.delete(0, cx));
    app.advance_clock(Duration::from_secs(5));
    window.read(|todos, _| assert!(todos.deleted.is_none()));
}
# }
```

[`advance_clock`](TestApp::advance_clock) moves the simulated time forward and
runs everything that became ready, including the task waiting on the timer.
Tests like this are fast, and they never flake: the same steps always produce the
same result.

## Where to go next

You've built a complete GPUI app. The [finished
program](crate::_documentation::examples::todos) is the `todos` example, and
from here:

* The [guides](crate::_documentation::guides) solve specific problems, from
  [long lists](crate::_documentation::guides::lists_and_scrolling) to [custom
  drawing](crate::_documentation::guides::custom_drawing).
* The [concepts](crate::_documentation::concepts) explain what's underneath,
  starting with [ownership and data flow](crate::_documentation::concepts::ownership).
* The [examples](crate::_documentation::examples) show each part of GPUI in a
  complete program.
* The [testing guide](crate::_documentation::guides::testing) covers
  `#[gpui::test]` for async tests, randomized scheduling, and more.
