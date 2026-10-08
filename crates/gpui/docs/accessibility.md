# Make the interface inspectable and operable

A painted button tells a sighted user where to click. Assistive technology
needs the same control expressed as a node: its role, name, state, and available
actions. GPUI sends that description to platform accessibility APIs through
[AccessKit](https://accesskit.dev/).

This chapter covers that programmatic interface. It complements keyboard
navigation, readable text, contrast, and reduced motion; it does not replace
them. The [input guide](crate::_documentation::input) explains focus and
activation. The [WAI-ARIA Authoring Practices Guide](https://www.w3.org/WAI/ARIA/apg/)
provides widget patterns, including [buttons](https://www.w3.org/WAI/ARIA/apg/patterns/button/).
GPUI uses similar property names, but an ARIA property does not supply browser
behavior automatically.

The supplied native backends connect GPUI's tree to AccessKit adapters. The
browser backend currently paints to a canvas without that adapter or a
corresponding semantic HTML tree. The site preview can exercise keyboard
behavior, but its painted controls do not establish screen-reader support.
Check the native application with the assistive technology you intend to
support; see [platform boundaries](crate::_documentation::platforms#browser-startup).

## Give a control a role, name, and behavior

A `div` needs a stable ID and a role to become an ordinary accessibility node.
Set a name that describes the action, then provide the behavior behind it:

```rust
use gpui::{Context, FocusHandle, Render, Role, Text, Window, div, prelude::*};

struct Counter {
    count: u32,
    focus: FocusHandle,
}

impl Counter {
    fn new(cx: &mut Context<Self>) -> Self {
        Self {
            count: 0,
            focus: cx.focus_handle().tab_stop(true),
        }
    }
}

impl Render for Counter {
    fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("increment")
            .role(Role::Button)
            .aria_label("Increment")
            .track_focus(&self.focus)
            .on_click(cx.listener(|this, _, _, cx| {
                this.count = this.count.saturating_add(1);
                cx.notify();
            }))
            .child(Text::new_inaccessible("Increment".into()))
    }
}
```

The visible text has no separate accessibility node because its parent already
names the control. [`StatefulInteractiveElement::on_click`](crate::StatefulInteractiveElement::on_click)
registers accessible click activation alongside pointer and keyboard
activation. [`InteractiveElement::track_focus`](crate::InteractiveElement::track_focus)
connects the view's handle to this element. Configure that handle with
[`FocusHandle::tab_stop`](crate::FocusHandle::tab_stop) to include it in keyboard
traversal, and keep it on the view between renders.

For a button that needs no programmatic focus handle, use
[`InteractiveElement::tab_index`](crate::InteractiveElement::tab_index) on the
identified element instead. GPUI then retains an internal handle under the
element ID. Element tab setters configure that internal handle; they do not
override a handle supplied through `track_focus`.

Report state when state matters: a checkbox needs its checked state, a progress
indicator needs its value, and an unavailable control needs its disabled state.
The [`StatefulInteractiveElement`](crate::StatefulInteractiveElement) methods
write these properties into AccessKit nodes.

> [!WARNING]
> Properties describe behavior; they do not implement it. `aria_disabled`
> does not prevent a click callback, `aria_placeholder` does not paint text,
> and `aria_modal` does not trap focus. Enforce those rules in the control's
> handlers and focus management, then report the resulting state.

## Keep node identity stable

An [`ElementId`](crate::ElementId) identifies an element within its enclosing
identity path. GPUI combines local IDs into a
[`GlobalElementId`](crate::GlobalElementId), then derives the AccessKit node
ID from that path. An ancestor with no ID contributes no component:

```rust
use gpui::{div, prelude::*};

let tree = div().id("sidebar").child(
    div().child(div().id("save"))
);
```

The inner element's path includes `sidebar` and `save`. Across frames, the same
path identifies the same node even if its text or value changes. Changing a
local ID, or moving the element beneath a different identified ancestor,
changes that node's identity. Use that deliberately for a different logical
control; keep it stable for an updated control.

IDs must be unique within an identity path in each frame. For a list, use an
item's stable key, not its current position when items can move. The same rule
protects retained element state, so an identity mistake can affect interaction
as well as accessibility.

## Choose text identity explicitly in repeated content

[`text!`](crate::text!) creates an accessible [`Text`](crate::Text) with an ID
derived from the macro's source location. Two written invocations have different
IDs; repeated execution of one invocation has the same ID:

```rust
use gpui::{Text, text};

fn status(message: &str) -> Text {
    text!(message)
}

assert_eq!(status("Loading").id(), status("Ready").id());
```

That is useful for a status whose content changes. In a loop, choose explicit
item keys or put each text element beneath an identified item:

```rust
use gpui::{Role, div, prelude::*, text};

let messages = [(41_usize, "Draft saved"), (73, "Upload complete")];
let log = div()
    .id("messages")
    .role(Role::Document)
    .children(messages.into_iter().map(|(key, message)| {
        text!(id = key, message)
    }));
```

Using only `text!(message)` at that one source location would give every child
the same local ID. Duplicate accessibility node IDs panic in debug builds;
release builds discard the duplicate node. For decorative text, use
[`Text::new_inaccessible`](crate::Text::new_inaccessible) only when that text's
meaning is already available elsewhere or needs no announcement.

## Hide decoration without hiding an operation

[`StatefulInteractiveElement::aria_hidden`](crate::StatefulInteractiveElement::aria_hidden)
hides an element and its descendants from assistive technology. It needs an ID,
but it does not need a role. Rendering and input remain active:

```rust
use gpui::{div, prelude::*, text};

let decoration = div()
    .id("ornament")
    .aria_hidden()
    .child(text!("◆"));
```

A descendant cannot opt back into a hidden subtree. Do not hide a control that
still receives keyboard focus, or a container with focusable descendants: the
user could reach an operation that assistive technology cannot describe.

## Connect accessible actions to application state

[`AccessibleAction`](crate::AccessibleAction) is AccessKit's action enum.
It is separate from the GPUI [`Action`](crate::Action) trait used by keymaps.
An accessible action targets a specific node rather than the current key
context.

Use [`StatefulInteractiveElement::on_a11y_action`](crate::StatefulInteractiveElement::on_a11y_action)
for capabilities beyond the click and focus support supplied by ordinary
interaction. The callback receives optional AccessKit action data, a window,
and the app. For an adjustable control, route the action to the same state
transition as its pointer and keyboard handlers, then notify the view:

```rust
use gpui::{AccessibleAction, Context, Render, Role, Window, div, prelude::*};

struct Volume { value: u32 }

impl Render for Volume {
    fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let volume = cx.entity().downgrade();
        div()
            .id("volume")
            .role(Role::Slider)
            .aria_label("Volume")
            .on_a11y_action(AccessibleAction::Increment, move |_, _, cx| {
                let _ = volume.update(cx, |volume, cx| {
                    volume.value = volume.value.saturating_add(1).min(100);
                    cx.notify();
                });
            })
    }
}
```

This snippet demonstrates action routing, not a complete slider. A usable
slider also needs a reported value and range, decrement and value-setting
behavior, focus, and keyboard input. Choose the widget's complete interaction
contract before advertising its role.

## Expose parts of a custom element

A custom [`Element`](crate::Element) may paint several logical parts without
building a separate GPUI element for each one. Implement
[`Element::a11y_synthetic_children`](crate::Element::a11y_synthetic_children)
when assistive technology needs those parts as separate nodes.

GPUI calls this hook after the element's prepaint, while its accessibility node
is still on the builder stack. The hook receives that element's prepaint state
and an [`A11ySubtreeBuilder`](crate::A11ySubtreeBuilder). Derive a stable child
ID with `synthetic_node_id`, insert a leaf with `push_child`, and use
`parent_node` to attach properties such as a text selection referring to those
children. Synthetic keys must stay unique under their parent across frames.
These nodes describe the control; they do not create drawing or input behavior.

## Inspect the tree and test the native result

Tree construction normally activates when the platform adapter requests it.
For inspection, use
[`Application::with_accessibility_forced`](crate::Application::with_accessibility_forced)
or [`Window::set_a11y_forced`](crate::Window::set_a11y_forced), draw a frame,
and inspect [`Window::debug_a11y_tree_json`](crate::Window::debug_a11y_tree_json).
An application created with
[`Application::new_inaccessible`](crate::Application::new_inaccessible)
remains disabled even when forcing is requested.

Check the tree's roles, labels, states, child relationships, and reported focus.
Then use the target platform's assistive technology to check navigation,
announcements, and activation. A correct scene or JSON tree alone cannot prove
what a screen reader announces. The [testing chapter](https://gpui-ce.github.io/book/testing.html)
explains where simulated and platform checks meet.
