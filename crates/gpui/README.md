# GPUI Community Edition

GPUI is a Rust UI framework. A view holds application state and implements
[`Render`]. Its render method returns elements; GPUI lays out those elements,
dispatches input through them, and paints the result into a window.

This crate contains the framework's state, element, input, and rendering
contracts. `gpui_ce_platform` selects a native platform;
`gpui_ce_web` supplies the browser platform. The package is named `gpui-ce`,
but its Rust library is imported as `gpui`.

Start with the [first window walkthrough](https://gpui-ce.github.io/examples/first-window/).
It includes the complete program, a browser preview, and an editor download.
For a particular operation, use the [task guides](https://gpui-ce.github.io/guides/).
The [GPUI Book](https://gpui-ce.github.io/book/) collects the conceptual chapters
from this API reference into a reading path with search and code copying.

## A view with state

This view stores a count, displays it, and changes it on a click.
[`Context::listener`] gives the callback access to the view. [`Context::notify`]
requests a redraw after the value changes.

```no_run
use gpui::{Context, IntoElement, Render, Role, Window, div, prelude::*, rgb, text};

struct Counter { count: u32 }

impl Render for Counter {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div().flex().items_center().gap_4()
            .child(text!(format!("Count: {}", self.count)))
            .child(
                div().id("increment").p_4()
                    .role(Role::Button)
                    .aria_label("Increment")
                    .tab_index(0)
                    .focus_visible(|style| style.ring_2().ring_color(rgb(0x3478c8)))
                    .child("Increment")
                    .on_click(cx.listener(|this, _event, _window, cx| {
                        this.count = this.count.saturating_add(1);
                        cx.notify();
                    })),
            )
    }
}
```

The [counter walkthrough](https://gpui-ce.github.io/examples/counter/) supplies
the window and explains each step. The ID keeps the element's interaction
state attached to the same identity across frames.
The text macro exposes the count to accessibility clients. The button is named,
reachable by Tab, and activatable with Enter or Space through the same listener.

## Choose an entry point

| You need to… | Start here |
| --- | --- |
| Store or share state | [`Entity`], [`Context`], and [`_ownership_and_data_flow`] |
| Return an element tree | [`Render`], [`RenderOnce`], [`div`], and [`Styled`] |
| Understand a frame | [`_documentation::rendering`] and [`Element`] |
| Size and place elements | [`_documentation::layout`], [`Styled`], and [`Bounds`] |
| Display and measure text | [`_documentation::text`], [`Text`], and [`WindowTextSystem`] |
| Animate a changing value | [`_documentation::animation`], [`Animated`], and [`AnimationExt`] |
| Handle keys and clicks | [`_documentation::input`], [`InteractiveElement`], and [`FocusHandle`] |
| Run work without blocking input | [`_documentation::scheduling`], [`Task`], and [`BackgroundExecutor`] |
| Draw a custom region | [`_documentation::drawing`], [`canvas`], and [`PathBuilder`] |
| Load or retry an image | [`_documentation::assets`], [`ImageSource`], and [`ImageCache`] |
| Display a large collection | [`_documentation::lists`], [`uniform_list`] for equal-height rows, [`list`] for measured rows |
| Test state and input | `TestApp` and `TestAppContext` (enable `test-support`) |
| Expose accessible controls | [`_accessibility`] |

`Application` configures the platform and starts its run loop. The `App`
passed to launch and event callbacks is the live synchronous context. An
`Entity<T>` is a strong handle to one stored value; pass it an app context to
read or update that value. `Context<T>` is supplied while constructing or
updating one entity and adds entity-specific operations such as `notify`,
`emit`, and callback registration. Use `AsyncApp` or `AsyncWindowContext` in a
foreground task that crosses an `.await`; their methods reacquire app access
for each callback. See [`_ownership_and_data_flow`] for ownership and effect
timing behind these choices.

## Before choosing GPUI

GPUI uses a GPU-backed drawing model, rather than a native widget for every
control. Layout and styling resemble the web, but elements are Rust values,
not DOM nodes. The browser backend runs GPUI itself through WebAssembly and
currently supports one window per document.

The current checkout and a published release can differ. See the
[version guide](https://gpui-ce.github.io/reference/versions/) before combining
code from a walkthrough with a crates.io dependency. Platform requirements,
feature flags, and the renderer split are documented in
[`_documentation::platforms`].

Public APIs document their behavior here. Complete applications live in the
walkthroughs so a short reference example does not have to conceal its setup.
