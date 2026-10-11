# 7. Polish

The app works. In this chapter you make it feel finished: new todos fade in
instead of popping into place, and the checkboxes make sense to screen readers.

## Fade in new todos

Any element can animate. [`with_animation`](AnimationExt::with_animation) wraps
an element with an [`Animation`] and a closure that receives the animation's
progress, from `0.0` to `1.0`, and returns the element as it should look at that
moment. Add it at the end of `row`:

```
# use gpui::{Animation, AnimationExt, IntoElement, div, millis, prelude::*};
# fn row(id: usize) -> impl IntoElement {
div()
    .id(("todo", id))
    // ...the row, as before
    .with_animation(("appear", id), Animation::new(millis(200)), |row, delta| {
        row.opacity(delta)
    })
# }
```

Like a click, an animation has state that outlives a frame: when it started.
GPUI keeps that state under the id you give it, so the id decides when the
animation plays. Including the todo's id means each todo fades in once, when its
row first appears, and stays put on every frame after that.

While an animation runs, GPUI draws frames for it; when it ends, GPUI stops, and
the app goes back to using no CPU at all. If your app turns on
[`App::set_reduce_motion`], for example because the user prefers less motion,
GPUI skips the animation and shows the finished state.

## Make the checkbox accessible

People who use a screen reader, or other assistive technology, experience your
app through a description of its interface: what each element is, what it's
called, and what state it's in. Visually, a round outline that fills in reads as
a checkbox. To assistive technology, it is an unnamed box.

Describe it. Give `Checkbox` a label, and declare its role and state:

```
# use gpui::{App, ClickEvent, ElementId, Role, SharedString, Toggled, Window, div, prelude::*};
#[derive(IntoElement)]
struct Checkbox {
    id: ElementId,
    checked: bool,
    /// What the checkbox is for, announced by screen readers.
    label: SharedString,
    on_toggle: Box<dyn Fn(&ClickEvent, &mut Window, &mut App)>,
}

impl RenderOnce for Checkbox {
    fn render(self, _window: &mut Window, _cx: &mut App) -> impl IntoElement {
        div()
            .id(self.id)
            .role(Role::CheckBox)
            .aria_label(self.label)
            .aria_toggled(if self.checked { Toggled::True } else { Toggled::False })
            // ...the styles and click handler, as before
#           .on_click(self.on_toggle)
    }
}
```

and pass `label: todo.title.clone()` in `row`. A screen reader now announces the
first row's checkbox along the lines of "Buy milk, checkbox, not checked", and
lets the user check it.

Because the checkbox is a component, every place that uses it gets this for
free. That is a good reason to build components for the controls you use more
than once.

GPUI builds the accessibility tree from elements that have an id and a role, and
passes it to the operating system through
[AccessKit](https://accesskit.dev). The [accessibility
guide](crate::_documentation::guides::accessibility) covers roles, states, and
keyboard access.

## Going further

Some ideas if you want to keep going:

* Edit a todo by double-clicking it. [`ClickEvent`] tells you how many times the
  user clicked.
* Move between todos with the arrow keys: actions bound in the `Todos` context,
  and a selected index in the view's state.
* Save the list to a file whenever it changes, in a task, with
  [`background_spawn`](AppContext::background_spawn) to write it off the main
  thread.

The last chapter shows how to make sure all of this keeps working: [chapter
8](crate::_documentation::tutorial::ch8_testing) tests the app.
