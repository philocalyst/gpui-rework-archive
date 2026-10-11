# Make your app accessible

GPUI reports your UI to screen readers and other assistive technology through
[AccessKit]. You make an element visible to assistive technology by giving it an
[`id`][`InteractiveElement::id`] and a [`role`][`StatefulInteractiveElement::role`],
then describing its label and state. This guide covers that programmatic side,
plus the checks you still do by hand: contrast, motion and focus.

## Give each control a role and a label

An element becomes a node in the accessibility tree only when it has both an
id and a role. Without a role, GPUI doesn't report the element at all. Without
an id, GPUI can't keep the node stable from one frame to the next.

Set the label with [`aria_label`][StatefulInteractiveElement::aria_label]. The
label names the element, so make it what a user would read on the control.

```rust
use gpui::{AnyWindowHandle, Context, Role, TestApp, Window, accesskit, div, prelude::*};

struct SaveButton {
    saves: usize,
}

impl Render for SaveButton {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("save")
            .role(Role::Button)
            .aria_label("Save")
            .on_click(cx.listener(|this, _event, _window, cx| {
                this.saves += 1;
                cx.notify();
            }))
            .child(format!("Saved {} times", self.saves))
    }
}

let mut app = TestApp::new();
let mut window = app.open_window(|_, _| SaveButton { saves: 0 });

// The tree is built only while assistive technology is connected, or when
// it is forced. Forcing it lets a test read the tree.
window.update(|_, window, _| window.set_a11y_forced(true));
window.draw();

let (button, role) = window.update(|_, window, _| {
    let tree = window.a11y_tree().expect("the tree is built while forced");
    let (id, node) = tree
        .nodes
        .iter()
        .find(|(_, node)| node.label() == Some("Save"))
        .expect("the save button is in the tree");
    (*id, node.role())
});
assert_eq!(role, Role::Button);

// Let an assistive technology click the button. This runs the same handler
// as a mouse click. The handler updates the view, so go through the window
// handle, which doesn't hold the view while the closure runs.
let handle: AnyWindowHandle = window.handle().into();
app.update(|cx| {
    handle.update(cx, |_, window, cx| {
        window.perform_a11y_action(button, accesskit::Action::Click, None, cx)
    })
})
.unwrap();
window.read(|button, _| assert_eq!(button.saves, 1));
```

Notice what the example relies on:

- The button has an id, so its node keeps the same identity across frames.
- The label is set on the element itself. The text child doesn't need a role
  to supply the name.
- [`on_click`][StatefulInteractiveElement::on_click] also registers an
  accessibility `Click` action, so the button responds to assistive technology
  without any extra code.

### Stable ids and text

A node's identity comes from its global element id, which combines the ids of
all its ancestors (see [`GlobalElementId`]). If an id changes between frames,
the assistive technology sees one node removed and another added. Users hear
that as a change even when nothing on screen changed.

[`text!`] derives its id from its source location. That is right for fixed
labels, but a `text!` call inside a closure that you map over a list gives every
item the same id. Set an id, or wrap the text in a div that has one:

```rust
use gpui::{Role, div, prelude::*, text};

let todos = vec!["eat lunch", "drink water", "go to gym"];
let items = todos.into_iter().enumerate().map(|(index, todo)| {
    div().id(index).child(text!(todo))
});

let list = div().id("todo-list").role(Role::List).children(items);
```

[`Text::new_inaccessible`] creates text with no id. Use it when a parent
already provides the label and you don't want the text announced twice.

## Describe state

Report state with the `aria_*` methods. Each one maps to a property on the
AccessKit node, and you set it whenever the state changes:

| Method | Use it for |
| --- | --- |
| [`aria_toggled`][StatefulInteractiveElement::aria_toggled] | Checkboxes and toggle buttons, with [`Toggled`] |
| [`aria_selected`][StatefulInteractiveElement::aria_selected] | Selected rows, tabs and options |
| [`aria_expanded`][StatefulInteractiveElement::aria_expanded] | Disclosure widgets, menus and accordions |
| [`aria_disabled`][StatefulInteractiveElement::aria_disabled] | Controls that can't take input |
| [`aria_value`][StatefulInteractiveElement::aria_value] | The string value of a text field or label |
| [`aria_numeric_value`][StatefulInteractiveElement::aria_numeric_value] | Sliders, progress bars and spin buttons |

Numeric values also take [`aria_min_numeric_value`][StatefulInteractiveElement::aria_min_numeric_value],
[`aria_max_numeric_value`][StatefulInteractiveElement::aria_max_numeric_value]
and [`aria_numeric_value_step`][StatefulInteractiveElement::aria_numeric_value_step].

```rust
use gpui::{Role, Toggled, div, prelude::*};

fn bold_toggle(bold: bool) -> impl IntoElement {
    div()
        .id("bold")
        .role(Role::CheckBox)
        .aria_label("Bold")
        .aria_toggled(Toggled::from(bold))
        .child("B")
}

fn volume_slider(volume: f64) -> impl IntoElement {
    div()
        .id("volume")
        .role(Role::Slider)
        .aria_label("Volume")
        .aria_numeric_value(volume)
        .aria_min_numeric_value(0.0)
        .aria_max_numeric_value(100.0)
        .aria_numeric_value_step(1.0)
}
```

[`aria_description`][StatefulInteractiveElement::aria_description] adds
supporting text that is announced after the name, role and value. Use it for a
hint, not for the name. [`aria_placeholder`][StatefulInteractiveElement::aria_placeholder]
gives the hint a text input shows while it is empty.

Other properties cover structure: [`aria_level`][StatefulInteractiveElement::aria_level]
for headings, [`aria_position_in_set`][StatefulInteractiveElement::aria_position_in_set]
and [`aria_size_of_set`][StatefulInteractiveElement::aria_size_of_set] for items in
a list, the `aria_row_*` and `aria_column_*` methods for grids, and
[`aria_orientation`][StatefulInteractiveElement::aria_orientation]. Use
[`aria_modal`][StatefulInteractiveElement::aria_modal] on a dialog that blocks the
rest of the window.

## Announce changes with live regions

When text changes and the user should hear it without moving focus, make the
element a live region. Give it a stable id and set
[`aria_live`][StatefulInteractiveElement::aria_live]:

```rust
use gpui::{Role, accesskit, div, prelude::*};

fn status(message: &str) -> impl IntoElement {
    div()
        .id("status")
        .role(Role::Status)
        .aria_live(accesskit::Live::Polite)
        .child(message.to_string())
}
```

`accesskit::Live::Polite` waits for the user to pause. `Assertive` interrupts,
and `Off` silences the region. Use `Assertive` only for errors the user must
hear now. [`aria_live_atomic`][StatefulInteractiveElement::aria_live_atomic]
makes the assistive technology read the whole region instead of only the part
that changed.

Keep the id the same from frame to frame. A new id makes a new node, and
assistive technology may not announce its contents as a change.

## Respond to actions from assistive technology

Assistive technology sends [`accesskit::Action`]s to a node: `Click`, `Focus`,
`Increment`, `Decrement` and others. In GPUI, these are the same types as
[`AccessibleAction`]. They are unrelated to GPUI's [`Action`] trait, which
handles key bindings and menus.

Clicks and focus are handled for you. For any other action, register a handler
with [`on_a11y_action`][StatefulInteractiveElement::on_a11y_action]. It runs
with the optional [`accesskit::ActionData`] and mutable access to the window
and app:

```rust
use gpui::{Context, Role, Window, accesskit, div, prelude::*};

struct Slider {
    value: i32,
}

impl Render for Slider {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let up = cx.entity();
        let down = up.clone();
        div()
            .id("slider")
            .role(Role::Slider)
            .aria_label("Level")
            .aria_numeric_value(self.value as f64)
            .on_a11y_action(accesskit::Action::Increment, move |_data, _window, cx| {
                up.update(cx, |slider, cx| {
                    slider.value += 1;
                    cx.notify();
                });
            })
            .on_a11y_action(accesskit::Action::Decrement, move |_data, _window, cx| {
                down.update(cx, |slider, cx| {
                    slider.value -= 1;
                    cx.notify();
                });
            })
    }
}
```

Two details matter here:

- GPUI attaches the listener while it paints, and only when assistive
  technology is active. Your handler doesn't run until the next frame has been
  painted with it.
- The handler updates the entity and calls [`Context::notify`], as any other
  event handler does. The new value reaches the tree on the next frame.

Only add the actions your control supports. The node advertises each action
you register, so an action you don't handle would appear to work.

## Expose elements that GPUI doesn't draw as nodes

Some custom elements draw several things that users interact with, such as the
lines of a text editor. Give them child nodes with
[`StatefulInteractiveElement::a11y_synthetic_children`], which runs after the
element is prepainted. That means the closure can use what is on screen, such as
the visible lines. The element needs an id, and either a role or `aria_hidden`.

```rust
use gpui::{Role, accesskit, div, prelude::*};

fn text_field(text: &'static str) -> impl IntoElement {
    div()
        .id("text-field")
        .role(Role::TextInput)
        .a11y_synthetic_children(move |builder| {
            let run_id = builder.synthetic_node_id(0);
            let mut run = accesskit::Node::new(Role::TextRun);
            run.set_value(text);
            builder.push_child(run_id, run);
        })
}
```

For a custom [`Element`], implement [`Element::a11y_synthetic_children`] instead,
and set the parent's properties through
[`A11ySubtreeBuilder::parent_node`].

## Hide decoration

[`aria_hidden`][StatefulInteractiveElement::aria_hidden] removes an element and
everything under it from the accessibility tree. It doesn't change how the
element is drawn or whether it receives input:

```rust
use gpui::{div, prelude::*, text};

let divider = div()
    .id("divider")
    .aria_hidden()
    .child(text!("---"));
```

Don't hide anything a user can focus or interact with. A hidden element keeps
its focus and input handlers, but assistive technology doesn't report it, so
the user can land on a control they can't hear.

## Test the tree

The tree is built only when assistive technology is connected. To inspect it in
a test, use [`Window::set_a11y_forced`] on a [`TestApp`] window, as shown at the
top of this page, or on a real application with
[`Application::with_accessibility_forced`]:

```rust,no_run
fn main() {
    gpui_platform::application()
        .with_accessibility_forced()
        .run(|_cx| {
            // Open windows here. Call `Window::debug_a11y_tree_json` to dump
            // the tree while the app runs.
        });
}
```

[`Window::debug_a11y_tree_json`] returns the last frame's tree as a string, or
`None` if no tree was built. It is useful when a control doesn't show up where you
expected. [`Window::a11y_tree`]
gives you the tree itself, for assertions.

Use [`Application::new_inaccessible`] to turn accessibility off entirely, for
example in a headless benchmark.

## Motion, contrast and focus

Accessibility also depends on things that don't go through the tree.

**Reduced motion.** GPUI doesn't read the operating system's reduced-motion
setting for you. Read it in your platform code and pass it to
[`App::set_reduce_motion`]. Animations then render in a static state, and
[`App::reduce_motion`] tells your own animations to do the same. The
[animation example](crate::_documentation::examples::animation) shows how an
animation checks it.

```rust
use gpui::App;

fn apply_motion_preference(cx: &mut App, prefers_reduced_motion: bool) {
    cx.set_reduce_motion(prefers_reduced_motion);
}
```

**Contrast.** GPUI has no contrast checker. Choose text and background colors
that meet the contrast ratio your product requires, and check them with a tool
or a color picker. Check disabled and placeholder text too.

**Focus.** Focus should always be visible. Give a focusable element a clear
style for when it has focus, with [`InteractiveElement::focus_visible`]. The
element must be focusable, which means it tracks a [`FocusHandle`]:

```rust
use gpui::{FocusHandle, div, prelude::*, rgb};

fn text_button(focus_handle: &FocusHandle) -> impl IntoElement {
    div()
        .id("ok")
        .track_focus(focus_handle)
        .focus_visible(|style| style.border_color(rgb(0x3b82f6)))
        .child("OK")
}
```

Keyboard support comes first. Make every control reachable and operable from
the keyboard, in a sensible order. See the [focus guide](crate::_documentation::guides::focus)
and the [keyboard guide](crate::_documentation::guides::keyboard).

## See also

- [AccessKit] documents the platform model behind the tree.
- The [MDN WAI-ARIA basics][mdn-aria] and the [ARIA Authoring Practices
  Guide][apg] describe the roles, states and widget patterns this page uses.
  GPUI follows their names, but it doesn't always behave like a browser with
  the same attributes.
- The [focus guide](crate::_documentation::guides::focus) and
  [keyboard guide](crate::_documentation::guides::keyboard) cover the keyboard
  path that assistive technology also relies on.
- The [testing guide](crate::_documentation::guides::testing) shows how to run
  views headlessly.

[AccessKit]: https://accesskit.dev/
[mdn-aria]: https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Accessibility/WAI-ARIA_basics
[apg]: https://www.w3.org/WAI/ARIA/apg/
