+++
title = "Tutorial: a counter"
description = "Connect state, rendering, and click handlers in a counter you can understand from end to end."
weight = 5
aliases = ["/getting-started/counter-tutorial.html"]
[extra]
playground = true
category = "GETTING STARTED"
legacy_source = "gpui-ce-docs/build/html/getting-started/counter-tutorial.html"
+++

**Counter-tutorial** is the state-plus-events workout: two buttons around a number, built in four steps. Each step shows complete code, the expected result, and one common mistake. You leave with the interaction pattern every GPUI app repeats.


{{ <playground example="counter" title="Try the counter" label="Interactive companion" /> }}


## Step 1: state

An `Entity` owns the state. Define a plain struct first:

```rust
// Imports for the whole tutorial: app loop, rendering, styling, platform boot.
use gpui::{App, Context, IntoElement, Render, Window, WindowOptions, div, prelude::*, px, rgb};
use gpui_platform::application; // picks the OS backend, no cfg in your code

// Plain struct tonight; it becomes an Entity the moment cx.new owns it.
struct Counter {
    count: i32,
}
```

**Expected result:** code compiles. Nothing runs yet. State lives outside GPUI until `cx.new` owns it.

> **Pitfall.** Storing `Counter` in a local variable and passing references into views. GPUI owns entity state, full stop. Create it with `cx.new` inside `open_window` and share the returned `Entity` instead.

## Step 2: view

Implement `Render`. Read `self`, return elements, change nothing:

```rust
// Render turns current state into boxes; this one reads self.count and stops.
impl Render for Counter {
    // _window and _cx go unused here: no focus, no entity powers needed yet.
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .flex() // flexbox row/column layout for the children
            .flex_col() // stack label (and later buttons) vertically
            .items_center() // center children horizontally in the column
            .justify_center() // center children vertically in the box
            .gap_3() // breathing room between label and button row
            .size(px(400.0)) // fixed 400px square so the layout stays put
            .bg(rgb(0x1e1e1e)) // dark card background
            .text_color(rgb(0xffffff)) // light text that reads on the dark card
            .text_xl() // large type for the count
            .child(format!("Count: {}", self.count)) // rebuilt from state every frame
    }
}
```

**Expected result:** a dark 400px box showing `Count: 0`. No buttons yet.

> **Pitfall.** Mutating `self.count` inside `render`. GPUI calls `render` every frame, so the count would spin out of control. Mutate only in event handlers, where each change answers to one click.

## Step 3: interaction

Add two buttons under the label. Each button needs `.id(...)` before `.on_click(...)`, because clicks only exist on stateful elements ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs), [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)). Each handler mutates state through `cx.listener` and calls `cx.notify()` ([crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs), [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)):

```rust
// Same Render impl, now with a button row. The label lines above stay put.
impl Render for Counter {
    // cx is named now: cx.listener needs it to build the click closures.
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .flex() // outer column, same as step 2
            .flex_col()
            .items_center()
            .justify_center()
            .gap_3()
            .size(px(400.0))
            .bg(rgb(0x1e1e1e))
            .text_color(rgb(0xffffff))
            .text_xl()
            .child(format!("Count: {}", self.count)) // the label you already built
            .child(
                div()
                    .flex() // inner row: the two buttons sit side by side
                    .gap_2() // small gap between - and +
                    .child(
                        div()
                            .id("decrement") // claim identity: stateful, so clicks can land
                            .px_3() // horizontal padding makes a tappable target
                            .py_1() // vertical padding to match
                            .bg(rgb(0xd32f2f)) // red says "down"
                            .rounded_md() // soft corners, friendly button
                            .child("-") // the glyph the user actually taps
                            .on_click(cx.listener(|this, _, _, cx| {
                                this.count -= 1; // mutate the entity inside the handler
                                cx.notify(); // mark dirty, or the screen stays frozen
                            })),
                    )
                    .child(
                        div()
                            .id("increment") // unique id per button: duplicates confuse hit-testing
                            .px_3()
                            .py_1()
                            .bg(rgb(0x388e3c)) // green says "up"
                            .rounded_md()
                            .child("+")
                            .on_click(cx.listener(|this, _, _, cx| {
                                this.count += 1; // same pattern, opposite direction
                                cx.notify(); // every mutation path needs one notify
                            })),
                    ),
            )
    }
}
```

**Expected result:** two buttons, `-` and `+`. Clicks change the number immediately.

> **Pitfall.** Forgetting `cx.notify()`. The field updates, but GPUI never re-renders, so the screen looks frozen. Every mutation path needs one `notify` — or use `Entity::write`, which notifies for you.

> **Note.** Calling `.on_click(...)` on a `div()` with no `.id(...)` fails to compile. Click handling lives on `StatefulInteractiveElement`, and `.id()` is what makes a `div` stateful ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)). Without it, there is simply nothing for the listener to hang onto.

> **Tip.** `cx.listener` quietly swallows the update when its entity is gone: the closure ends in `.ok()`, so a click landing after teardown becomes a silent no-op instead of a panic ([crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)). Lovely in production, sneaky in tests — if your handler never fires, check the entity is still alive.

## Step 4: run

Wire state, view, and interaction together in `main`:

```rust
// Entry point: boot the platform, open one window, install Counter as root.
fn main() {
    // run() fires once at launch; everything session-lived starts inside.
    application().run(|cx: &mut App| {
        // The closure must return Entity<Counter>: cx.new provides exactly that.
        cx.open_window(WindowOptions::default(), |_, cx| {
            cx.new(|_| Counter { count: 0 }) // state starts at zero, owned by GPUI
        })
        .unwrap(); // windows can fail (no display, no GPU): handle the Result
        cx.activate(true); // bring the app forward so clicks land immediately
    });
}
```

Run it with words you already know:

```sh
# Build and launch; click + three times, then - once.
cargo run
```

Click `+` three times. The label shows `Count: 3`. Click `-` once. It shows `Count: 2`.

> **Pitfall.** Returning `Counter { count: 0 }` directly from the `open_window` closure. The closure must return `Entity<Counter>`. Wrap the value with `cx.new` — same rule as first-app, and the compiler enforces it.

## The complete file

Steps 1-4 assemble into this buildable program. Copy it whole when you want a guaranteed win:

```rust
// Complete counter: state + view + interaction + entry point, one file.
use gpui::{App, Context, IntoElement, Render, Window, WindowOptions, div, prelude::*, px, rgb};
use gpui_platform::application; // OS backend without cfg gates

// Owned state; GPUI takes custody inside open_window via cx.new.
struct Counter {
    count: i32,
}

impl Render for Counter {
    // Every frame: read count, rebuild the card and its two buttons.
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .flex() // outer column centers everything
            .flex_col()
            .items_center()
            .justify_center()
            .gap_3()
            .size(px(400.0)) // fixed square keeps the layout steady while counting
            .bg(rgb(0x1e1e1e))
            .text_color(rgb(0xffffff))
            .text_xl()
            .child(format!("Count: {}", self.count)) // the number you watch change
            .child(
                div()
                    .flex() // button row inside the card column
                    .gap_2()
                    .child(
                        div()
                            .id("decrement") // stateful identity first, clicks second
                            .px_3()
                            .py_1()
                            .bg(rgb(0xd32f2f))
                            .rounded_md()
                            .child("-")
                            .on_click(cx.listener(|this, _, _, cx| {
                                this.count -= 1; // one click, one decrement
                                cx.notify(); // without this, the screen naps
                            })),
                    )
                    .child(
                        div()
                            .id("increment") // distinct id keeps hit-testing honest
                            .px_3()
                            .py_1()
                            .bg(rgb(0x388e3c))
                            .rounded_md()
                            .child("+")
                            .on_click(cx.listener(|this, _, _, cx| {
                                this.count += 1; // one click, one increment
                                cx.notify(); // mark dirty every single time
                            })),
                    ),
            )
    }
}

fn main() {
    // Boot, open, install root view, step forward. Same skeleton as first-app.
    application().run(|cx: &mut App| {
        cx.open_window(WindowOptions::default(), |_, cx| {
            cx.new(|_| Counter { count: 0 }) // Entity<Counter>: the closure's required return
        })
        .unwrap();
        cx.activate(true);
    });
}
```

|  |  |
| --- | --- |
| **Symptom** | **Fix** |
| Number changes in code, screen frozen | Add `cx.notify()` to that mutation path. |
| `.on_click` will not compile | Add `.id("unique-name")` before `.on_click`. |
| `open_window` closure rejected | Return `cx.new(...)`, not the bare struct. |
| Clicks do nothing after teardown | Entity dropped: `listener` degrades to no-op by design. |

Table 14: The four counter bugs you will meet first, and the one-line fix for each.

Try one change before moving on: swap `gap_2` for `gap_8` in the button row and re-run. The buttons drift apart, and nothing else moves — gaps only breathe between siblings.

## Sources

- `Render::render`: [crates/gpui/src/element.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/element.rs); `div()`: [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)
- `.id()`: [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs); `on_click` (fluent): [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs); `on_click` (imperative): [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)
- `Context::listener`: [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs); `Context::notify`: [crates/gpui/src/app/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/context.rs)
- `Entity::update`, `Entity::write`: [crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs), [crates/gpui/src/app/entity_map.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/entity_map.rs)
- `AppContext::new` (`cx.new`): [crates/gpui/src/gpui.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/gpui.rs)
- `App::open_window`: [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs); `Application::run`: [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)
- `WindowOptions::default`: [crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs); `App::activate`: [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)
- `gpui_platform::application`: [crates/gpui_platform/src/gpui_platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_platform/src/gpui_platform.rs)
- Styling and button patterns: `crates/gpui/examples/legacy/hello_world.rs:96-114`, `crates/gpui/examples/learn/creating_components.rs:52-80`
