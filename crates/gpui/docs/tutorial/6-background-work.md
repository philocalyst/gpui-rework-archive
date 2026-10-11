# 6. Background work

In this chapter you make deleting forgiving. When you delete a todo, a message
offers to bring it back, and the offer disappears on its own after four
seconds. Waiting four seconds without freezing the window means running code
*asynchronously*, and that means meeting GPUI's tasks.

## Remember what was deleted

To undo a delete you need the todo and where it was. Store both, and change
`delete` to remove by position:

```
# use gpui::{Context, SharedString};
# struct Todo { id: usize, title: SharedString, done: bool }
struct Todos {
    todos: Vec<Todo>,
    /// The most recently deleted todo and its position, while it can be undone.
    deleted: Option<(usize, Todo)>,
    // ...the other fields, as before
}

impl Todos {
    fn delete(&mut self, id: usize, cx: &mut Context<Self>) {
        let Some(index) = self.todos.iter().position(|todo| todo.id == id) else {
            return;
        };
        self.deleted = Some((index, self.todos.remove(index)));
        cx.notify();
    }

    fn undo(&mut self, cx: &mut Context<Self>) {
        if let Some((index, todo)) = self.deleted.take() {
            self.todos.insert(index.min(self.todos.len()), todo);
            cx.notify();
        }
    }
}
```

`index.min(self.todos.len())` guards against the list having shrunk in the
meantime.

Show the offer below the list while there is something to undo:

```
# use gpui::{Context, IntoElement, SharedString, colors::Colors, div, prelude::*};
# struct Todo { title: SharedString }
# struct Todos { deleted: Option<(usize, Todo)> }
# impl Todos { fn undo(&mut self, _: &mut Context<Self>) {} }
# fn column(todos: &Todos, colors: &Colors, cx: &mut Context<Todos>) -> impl IntoElement {
div()
    // ...the title, field, list and footer, as before
    .when_some(todos.deleted.as_ref(), |column, (_, todo)| {
        column.child(
            div()
                .id("undo")
                .px_3()
                .py_2()
                .rounded_lg()
                .bg(colors.container)
                .text_sm()
                .cursor_pointer()
                .child(format!("Deleted “{}”. Click to undo.", todo.title))
                .on_click(cx.listener(|todos, _, _, cx| todos.undo(cx))),
        )
    })
# }
```

[`when_some`](prelude::FluentBuilder::when_some) is like `when`, for an
`Option`: it adds the message only if there's a deleted todo, and gives you the
value inside.

## Expire the offer with a task

Now the timeout. You can't sleep in a GPUI handler: the handler runs on the main
thread, and while it sleeps the window can't draw or respond. Instead, start a
*task*: an async block that GPUI runs alongside everything else, which can
`.await` without blocking anything.

```
# use std::time::Duration;
# use gpui::{Context, Task};
# struct Todo;
# struct Todos { deleted: Option<(usize, Todo)>, undo_timeout: Task<()> }
# impl Todos {
#     fn delete(&mut self, cx: &mut Context<Self>) {
self.undo_timeout = cx.spawn(async move |todos, cx| {
    cx.background_executor().timer(Duration::from_secs(4)).await;
    todos
        .update(cx, |todos, cx| {
            todos.deleted = None;
            cx.notify();
        })
        .ok();
});
#     }
# }
```

Put that in `delete`, after the todo is removed, and add an
`undo_timeout: Task<()>` field to `Todos`, starting as `Task::ready(())`, a task
that has already finished.

A lot happens in these few lines:

* [`Context::spawn`] starts the async block on the main thread. The block runs
  until it reaches an `.await`, then steps aside so the app keeps running, and
  continues when what it's waiting for is ready.
* [`timer`](BackgroundExecutor::timer) completes after four seconds.
* The block can't hold `&mut Todos` across an `.await`, because the rest of the
  app needs to use the view in the meantime. Instead, `spawn` gives it `todos`,
  a [`WeakEntity`] handle to the view, and `cx`, an [`AsyncApp`]. `update`
  borrows the view just for the duration of the closure.
* The handle is weak, so the task doesn't keep the view alive. If the window
  closes before the four seconds are up, `update` returns an error, and `.ok()`
  ignores it: there's nothing left to update.

## Owning the task

`spawn` returns a [`Task`], and **dropping a task cancels it**. That's why the
task is stored in a field rather than thrown away, and it makes cancelling easy.
Delete a second todo before the first offer expires, and the new task replaces
the old one in `undo_timeout`; dropping the old task cancels its timer. The
offer for the newest delete then gets its full four seconds.

If you forget to keep a task, it is dropped at the end of the statement and
never runs. When you really want work to finish regardless, call
[`detach`](Task::detach) on the task instead.

Here everything happens on the main thread, which is right for a timer. For
heavy work like parsing a large file, use
[`background_spawn`](AppContext::background_spawn) to run it on another thread
and await its result in a task like this one. [Executors and
tasks](crate::_documentation::concepts::executors) explains both, and the [async
work guide](crate::_documentation::guides::async_work) shows the patterns.

## The program so far

Here are the parts of `src/main.rs` that changed. The [finished
program](crate::_documentation::examples::todos) has the whole file.

```standalone_crate,no_run
use std::time::Duration;

use gpui::{Context, Entity, Focusable, SharedString, Task, Window, actions, prelude::*};
use gpui_ce_elements::editable_text::{EditableTextState, StringStorage};

# actions!(todos, [AddTodo]);
struct Todo {
    id: usize,
    title: SharedString,
    done: bool,
}

# #[derive(Clone, Copy, PartialEq)]
# enum Filter { All, Active, Done }
struct Todos {
    todos: Vec<Todo>,
    next_id: usize,
    filter: Filter,
    input: Entity<EditableTextState>,
    /// The most recently deleted todo and its position, while it can be undone.
    deleted: Option<(usize, Todo)>,
    undo_timeout: Task<()>,
}

impl Todos {
    fn new(window: &mut Window, cx: &mut Context<Self>) -> Self {
        let input = cx.new(|cx| EditableTextState::new(StringStorage::default(), cx));
        window.focus(&input.focus_handle(cx), cx);
        Self {
            todos: Vec::new(),
            next_id: 0,
            filter: Filter::All,
            input,
            deleted: None,
            undo_timeout: Task::ready(()),
        }
    }

    fn delete(&mut self, id: usize, cx: &mut Context<Self>) {
        let Some(index) = self.todos.iter().position(|todo| todo.id == id) else {
            return;
        };
        self.deleted = Some((index, self.todos.remove(index)));
        // Offer to undo for a few seconds. Assigning a new task drops, and so
        // cancels, the previous one.
        self.undo_timeout = cx.spawn(async move |todos, cx| {
            cx.background_executor().timer(Duration::from_secs(4)).await;
            todos
                .update(cx, |todos, cx| {
                    todos.deleted = None;
                    cx.notify();
                })
                .ok();
        });
        cx.notify();
    }

    fn undo(&mut self, cx: &mut Context<Self>) {
        if let Some((index, todo)) = self.deleted.take() {
            self.todos.insert(index.min(self.todos.len()), todo);
            cx.notify();
        }
    }
}
# fn main() {}
```

In the [next chapter](crate::_documentation::tutorial::ch7_polish) you add the
finishing touches: a little motion, and support for screen readers.
