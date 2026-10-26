//! Syntax sketch of `crates/gpui/examples/learn/creating_components.rs`.
//!
//! Current GPUI teaches three ways to hold a counter (`use_state`, `RenderOnce` + boxed
//! callbacks, `Entity<Render>`). The ladder has one view spelling. The *struct* is the
//! price list: `i32` → `Signal<i32>` → `Entity<Counter>` without rewriting `view`.
//!
//! `&self.local` is a child — you do not call `.view()`.
//!
//! With the borrowed frame (07 §2.1) a helper that reads `&i32`/`&Signal<i32>` simply returns
//! `El<'_>`: the element borrows that value for one description and is diffed at commit. No
//! `IntoWire` interning trick is needed to "avoid the lifetime" — the lifetime IS the frame, and
//! two borrowed inputs just share one `'a`. `Prop<i32>` (12 §9's rename of `IntoProperty`) still
//! unifies `42`, `&n`, and `&signal` into one property sink (07 §4); it no longer has to allocate
//! to erase a borrow. Labels are `&str` at the boundary, `String` in structs — no `SharedString`
//! in application code (12 §3).

use gpui::prelude::*;

// --- App-internal helper. Two borrowed inputs → one shared frame lifetime `'a`. Under the old
//     owned-Element draft this was the awkward E0106 case; the borrowed frame makes it ordinary.
//     `counter_face` is the whole body of a view (Counter::view returns it directly), so it seals
//     as `El<'a>` rather than staying open to restyling. ---

fn counter_face<'a>(label: &'a str, count: &'a i32) -> El<'a> {
    column((
        text(label).text_sm().text_muted(),
        text(count).text_2xl(),
        row((
            button("−").on_click(Counter::decrement),
            button("+").on_click(Counter::increment),
        ))
        .gap_2(),
    ))
    .gap_2()
    .p_4()
    .rounded_lg()
    .bg(theme.container)
}

// --- Library helper: one signature at every rung. `Prop<T>` accepts the constant `42`, the
//     borrow `&n`, `&signal`, or a projection; the returned element borrows for the frame, so the
//     lifetime is honest rather than hidden. A reusable chip takes its click routes as `impl
//     Route` params (07 §6.2) instead of hard-coding a receiver; elided here for the storage
//     story. It is also a whole self-contained widget, so it seals as `El<'a>`. ---

pub fn counter_chip<'a>(label: &'a str, count: impl Prop<i32> + 'a) -> El<'a> {
    column((
        text(label).text_sm().text_muted(),
        text(count).text_2xl(),
        row((
            button("−").on_click(Host::decrement),
            button("+").on_click(Host::increment),
        ))
        .gap_2(),
    ))
    .gap_2()
    .p_4()
    .rounded_lg()
    .bg(theme.container)
}

#[derive(Default)]
struct Counter {
    count: i32,
}

impl Counter {
    fn increment(&mut self) {
        self.count += 1;
    }
    fn decrement(&mut self) {
        self.count -= 1;
    }
}

impl View for Counter {
    fn view(&self) -> El<'_> {
        counter_face("Counter", &self.count)
        // After promotion to Signal<i32>, this helper still compiles (it borrows for the frame),
        // and text(&self.count) becomes a direct port. The *view structure* does not change.
    }
}

struct Playground {
    local: Counter,
    hot: Signal<i32>,
    pocket: Entity<Counter>,
}

impl Playground {
    fn bump_hot(&mut self) {
        *self.hot += 1; // DerefMut: the star is the publish
    }
}

impl View for Playground {
    fn view(&self) -> El<'_> {
        column((
            &self.local,
            row((
                text(&self.hot).text_2xl(), // direct signal port
                button("+ hot").on_click(Playground::bump_hot),
            ))
            .gap_2(),
            // Library helper: same chip at every rung; it borrows `&self.hot` for the frame.
            counter_chip("Hot chip", &self.hot),
            self.pocket.recover(|_| banner("This panel crashed")),
        ))
        .gap_4()
    }
}

fn main() {
    Application::run(Window::document(Playground::default()).title("Components"));
}
