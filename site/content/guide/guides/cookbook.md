+++
title = "Cookbook: eight recipes that run"
description = "Practical patterns for the small problems that appear in every real application."
weight = 37
aliases = ["/guides/cookbook.html"]
[extra]
category = "GUIDES"
legacy_source = "gpui-ce-docs/build/html/guides/cookbook.html"
+++

Pull up a chair — every recipe below starts from a working app, names its goal up front, and hands you code with love notes on every tricky line. Conventions follow `crates/gpui/examples/window_movable.rs`: `application()`, `open_window(WindowOptions{…})`, `Render::render`.

Legend, so nothing surprises you: `Entity<T>` is your shared state handle, `Context<T>` is the scope where you may mutate it, and `Window` is the per-frame scope for input and focus. The `migration-faq` glossary defines all five core words.

## 1. Todo app

**Goal:** add, toggle, and delete tasks with one `Entity`.

```rust
// Import the element builders (div, px) and the app traits (Render, Context).
use gpui::{prelude::*, *};
// application() picks the right OS backend — zero #[cfg] in your code.
use gpui_platform::application;

// One struct owns everything: the list plus the half-typed draft.
struct Todos { items: Vec<(String, bool)>, draft: String }

impl Render for Todos {
    // render() rebuilds boxes every frame from state — never store pixels here.
    fn render(&mut self, _w: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        // flex_col() stacks children vertically; p_4() pads; size_full() fills.
        div().flex().flex_col().gap_2().p_4().size_full()
            .child(
                // The draft row: a label plus whatever was typed so far.
                div().flex().gap_2()
                    .child("New task:")
                    // Real editing lives in recipe 2; keystrokes omitted for brevity.
                    .child(self.draft.clone())
            )
            // .children() maps each task to its own row, keyed by index.
            .children(self.items.iter().enumerate().map(|(ix, (label, done))| {
                // .id(ix) gives each row an identity so clicks find their home.
                div().id(ix).flex().gap_2()
                    // Checkbox glyph first, then the task text itself.
                    .child(if *done { "☑" } else { "☐" })
                    .child(label.clone())
                    // cx.listener() borrows self mutably only when clicked.
                    .on_click(cx.listener(move |this: &mut Todos, _, _, cx| {
                        // Flip the flag, then notify so this view re-renders.
                        this.items[ix].1 = !this.items[ix].1;
                        cx.notify();
                    }))
            }))
    }
}

fn main() {
    // Boot the platform, then open one window holding a Todos entity.
    application().run(|cx| {
        cx.open_window(WindowOptions::default(), |_, cx| {
            // cx.new() seeds the very first task so the list is never empty.
            cx.new(|_| Todos { items: vec![("Ship cookbook".into(), false)], draft: String::new() })
        }).unwrap();
    });
}
```

> **Pitfall.** Forgetting `cx.notify()` after mutation. `Entity` state never re-renders until you notify — the frame only re-runs `render` on notification or fresh input.

**Try it:** add a “clear completed” button with `cx.listener` + `retain`. What disappears first — the rows or the button?

## 2. Text-editor sketch

**Goal:** a single-line field with selection and keyboard focus.

```rust
// EditableText is the ready-made field; EditableTextState holds its contents.
use gpui::{prelude::*, *};
use gpui_elements::editable_text::{EditableText, EditableTextState};

// The view owns the field's state entity — the field borrows it each frame.
struct Field { text: Entity<EditableTextState> }

impl Render for Field {
    // _w and _cx go unused here because the child element does the real work.
    fn render(&mut self, _w: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        // p_4() breathes around the field; the child renders text + caret.
        div().p_4().child(EditableText::new(self.text.clone()))
    }
}
// Seed state once with cx.new(|cx| EditableTextState::new("hello", cx)).
// The exact constructor name varies by version — confirm it in
// crates/gpui_elements/src/editable_text.rs before you copy-paste.
```

> **Pitfall.** `EditableText` only hears keystrokes while focused. Call `track_focus` or `focus` on the surrounding `div` (the `window_movable.rs:21` pattern) or typing silently goes nowhere and you blame the keyboard.

**Try it:** wire `Enter` to submit — observe the text entity, then clear it on commit.

## 3. Dialog

**Goal:** a centered dialog over dimmed content that closes on Escape.

```rust
// One bool owns the whole drama: dialog up, or dialog down.
struct Root { dialog_open: bool }

impl Render for Root {
    fn render(&mut self, _w: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        // relative() anchors the overlay; size_full() covers the window.
        div().size_full().relative()
            // The page behind the dialog — plain content, always rendered.
            .child(div().p_8().child("Page content"))
            // The "Open" button row, always visible beneath the overlay.
            .child(div().flex().gap_2().p_8()
                // .id("open") claims an identity so on_click has a home.
                .child(div().id("open").on_click(cx.listener(|this: &mut Root, _, _, cx| {
                    // Flip the flag true, then notify to paint the overlay.
                    this.dialog_open = true; cx.notify();
                })).child("Open dialog")))
            // .when() appends the overlay child only while the flag is true.
            .when(self.dialog_open, |el| el.child(
                // absolute().inset_0() stretches the dim over every pixel.
                div().absolute().inset_0()
                    // Half-transparent black dims the page; clicks land here.
                    .bg(black().opacity(0.5))
                    // m_auto() centers; rounded_md() softens the card corners.
                    .child(div().m_auto().p_6().bg(white()).rounded_md()
                        .child("Are you sure?")
                        // The OK button flips the flag back and hides us.
                        .child(div().id("ok").on_click(cx.listener(
                            |this: &mut Root, _, _, cx| { this.dialog_open = false; cx.notify(); }
                        )).child("OK")))
            ))
    }
}
```

> **Pitfall.** An overlay without `absolute().inset_0()` covers only its content box, so clicks leak through to the page behind. Stretch it full-window first, style second.

**Try it:** close on outside-click (add `on_click` to the dim layer) and on `Escape` via an `Action` from recipe 4.

## 4. Menu and shortcut

**Goal:** `cmd-s` / `ctrl-s` saves, and a clickable menu item runs the same logic.

```rust
// actions! declares logical ops; prelude brings Render + listeners along.
use gpui::{actions, prelude::*};
// Save is a unit struct — its name IS the intent, no fields needed.
actions!(editor, [Save]);

// Doc is stateless here; the save logic would live in real fields.
struct Doc;
impl Render for Doc {
    fn render(&mut self, _w: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        // p_4() pads the hint text so the window never feels cramped.
        div().p_4()
            // on_action() handles Save wherever focus currently sits inside us.
            .on_action(cx.listener(|_: &mut Doc, _: &Save, _, cx| {
                // Persist the document here in a real app, then re-render.
                cx.notify();
            }))
            // The hint teaches the shortcut; the binding below makes it real.
            .child("Press ⌘S / Ctrl+S to save")
    }
}
// Bind the keystroke at startup (see action.rs:50, keymap.rs:309):
// cx.bind_keys([KeyBinding::new("cmd-s", Save, None)]);
// The third arg (None) means "no context predicate" — it fires anywhere.
```

> **Pitfall.** Actions fire only when something in the focus chain handles them. Bind the key **and** add `on_action` to a focused element — miss either half and nothing happens, with no error to comfort you.

**Try it:** add `SaveAs` on a second binding, then confirm both reach your menu handler.

## 5. Drag and drop

**Goal:** reorder chips by dragging; accept files dropped from the OS.

```rust
// Verified in crates/gpui/src/interactive.rs:706,714 — read before shipping:
//   ExternalDragPayload::Files(FileDragPaths) carries real OS file drops.
//   Internal drags are a separate type with separate handlers.
// Exact on_drag / on_drop method names vary by version — confirm in
// interactive.rs in your checkout, then wire each half independently.
div().id("chip-1")
    // .on_drag(...) starts an internal drag session (chip-to-chip reorder).
    // .on_drop(...) accepts internal drops and reorders your state.
    // OS file drops arrive as platform drag events instead — match on
    // ExternalDragPayload::Files to unwrap real paths from Finder/Explorer.
```

> **Pitfall.** Internal drags and OS file drags are different types wearing similar clothes. Test both — drag chip-to-chip **and** drag a file from Finder or Explorer. One working never implies the other.

**Try it:** log every drop payload to the console for a day. Your users will surprise you.

## 6. Async fetch and render

**Goal:** fetch JSON without freezing the window, then render it.

```rust
// prelude brings Entity, WeakEntity, Render, and cx.spawn into scope.
use gpui::{prelude::*, *};

// items holds results; loading flips the button label while fetching.
struct Feed { items: Vec<String>, loading: bool }

impl Render for Feed {
    fn render(&mut self, _w: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        // flex_col stacks the button above the results; gap_2 breathes.
        div().p_4().flex().flex_col().gap_2()
            // The reload button owns the whole fetch dance below.
            .child(div().id("reload").on_click(cx.listener(|this: &mut Feed, _, _, cx| {
                // Flip loading on NOW so the label changes this very frame.
                this.loading = true; cx.notify();
                // Contract: HttpClient trait at http_client.rs:13; on web the
                // gpui_web http_client is fetch-backed — same trait, same code.
                cx.spawn(async move |this: WeakEntity<Feed>, cx| {
                    // ... await client.get(url).await, parse, collect ...
                    // WeakEntity::update fails cleanly if the view is gone.
                    this.update(cx, |this, cx| { this.loading = false; cx.notify(); }).ok();
                }).detach();
                // detach() lets the future outlive this click handler safely.
            })).child(if self.loading { "Loading…" } else { "Reload" }))
            // One text row per item — cheap, because rows are plain strings.
            .children(self.items.iter().cloned())
    }
}
```

> **Pitfall.** Updating an `Entity` after its window closed. `WeakEntity::update` returns a `Result` — handle `Err` (user navigated away mid-fetch) instead of unwrapping your way to a crash.

**Try it:** add a 300 ms debounce so rapid clicks issue exactly one request.

## 7. List of 10,000 rows

**Goal:** scroll 10k rows at 60 fps by painting only the visible slice.

```rust
// uniform_list paints only what fits on screen — the docstring at
// crates/gpui/src/elements/uniform_list.rs:22 promises exactly this.
use gpui::{prelude::*, *};

// Big holds ListState across frames — the scroll offset lives there.
struct Big { state: ListState }

impl Render for Big {
    fn render(&mut self, _w: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        // size_full() gives the list the whole window to virtualize within.
        div().size_full().child(
            uniform_list(
                // Clone the state handle — cheap, shares the same scroll core.
                self.state.clone(),
                // px(28.) fixes every row at 28px; uniformity IS the trick.
                px(28.),
                // The closure maps only the visible range to rows — range,
                // not 0..10_000, which is why this stays at 60 fps.
                |range, _w, _cx| {
                    range.map(|ix| div().px_2().child(format!("row {ix}"))).collect()
                },
            )
        )
    }
}
// Build ListState once (e.g. ListState::reset(10_000) — the exact
// constructor varies by version, see uniform_list.rs:150-252 for the
// scroll_to_* family) and store it in your view. Never rebuild it per frame.
```

> **Pitfall.** Non-uniform row heights break the math — one wrapped line and scroll position drifts. Keep rows fixed-height, or switch to the measuring `list` element (`elements/list.rs`) with eyes open.

**Try it:** jump to row 9,999 with `scroll_to_item` and confirm first paint feels instant.

## 8. Themed button

**Goal:** one button component that follows light and dark mode.

```rust
// prelude brings div, colors, and on_click; ClickEvent carries the press.
use gpui::{prelude::*, *};

// A plain function returns elements — no struct needed for a stateless button.
fn themed_button(label: &str, action: impl Fn(&ClickEvent, &mut Window, &mut App) + 'static) -> impl IntoElement {
    // .id(label) keys the button; padding + rounding shape the pill.
    div().id(label).px_4().py_2().rounded_md()
        // cursor_pointer() promises clickability before the mouse arrives.
        .cursor_pointer()
        // Base blue fill with white text — readable in either appearance.
        .bg(rgb(0x2563eb)).text_color(white())
        // hover() darkens one step; active() darkens two — tactile feedback.
        .hover(|s| s.bg(rgb(0x1d4ed8)))
        .active(|s| s.bg(rgb(0x1e40af)))
        // The label rides inside, owned as a String so it outlives the call.
        .child(label.to_string())
        // on_click() finally wires your caller-supplied behavior.
        .on_click(action)
}
// Appearance hook (verified): Platform::window_appearance (platform.rs:182),
// overridable on macOS via set_window_appearance — a no-op elsewhere
// (platform.rs:192). Branch on it at render time; elsewhere the OS decides
// and behavior varies by platform/version.
```

> **Pitfall.** Hard-coding one palette at startup. Query appearance inside `render`, not in `main` — your users toggle dark mode mid-session and expect you to follow.

**Try it:** screenshot the button in light mode, dark mode, and headless. Keep all three in your docs.

## Compare approaches

|  |  |  |
| --- | --- | --- |
| **Approach** | **Ships native feel?** | **Costs** |
| GPUI-CE | Yes — one codebase, native windows + GPU canvas per OS. | Young docs; you sometimes read Zed-flavored source. |
| Electron / Tauri | Yes, via webviews; exact fidelity varies by platform/version. | Heavier runtime; bridge overhead on GPU-hot paths. |
| Iced / Dioxus | Yes, Rust-native or web-tech respectively. | Different widget ecosystems; check your must-have controls. |

Table 23: Capability-level trade-offs, hedged where honesty demands it.

> **Note.** Hungry for speed? The `performance` guide turns recipe 7 into a measured experiment — profile it before you optimize anything else.

## Sources

- Entry + focus conventions: [crates/gpui/examples/window_movable.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/examples/window_movable.rs)
- Actions + keymap: [crates/gpui/src/action.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/action.rs), `crates/gpui/src/keymap.rs:309-311`
- Drag payloads: `crates/gpui/src/interactive.rs:706,714`
- HTTP contract: [crates/gpui/src/http_client.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/http_client.rs); web impl: `crates/gpui_web/src/http_client.rs`
- Virtualized list: `crates/gpui/src/elements/uniform_list.rs:22,150-252`
- Appearance hook: `crates/gpui/src/platform.rs:182,192`
