//! Syntax sketch of `crates/gpui/examples/legacy/uniform_list.rs`.
//!
//! `uniform_list("id", n, cx.processor(|_, range, ...| { for ix in range { div().id(ix)... }}))`
//! is a range closure with synthetic ids. The ladder: a `List` (or a virtualized window over
//! one) and a row function. Identity is the slot. Click handlers route to the row or the owner.
//! `virtual_list` preserves slots, so a row that scrolls off and back keeps its focus and edit
//! state (07 §11). The row borrows its `Entry` for the frame. One scroll vocabulary:
//! `.scroll(Axis::Y)`, never `.pan(…)` (12 §8). The root fills the window by default, so no
//! `.size_full()` (12 §4b).

use gpui::prelude::*;

struct UniformListExample {
    entries: List<Entry>,
}

struct Entry {
    n: usize,
}

impl UniformListExample {
    fn clicked(&mut self, slot: Slot<Entry>) {
        // Slot is identity, not an index; a deleted row is `None`, never a panic (07 §8).
        let Some(e) = self.entries.get(slot) else { return };
        eprintln!("clicked Item {}", e.n);
    }
}

impl View for Entry {
    fn view(&self) -> El<'_> {
        div()
            .px_2()
            .cursor_pointer()
            .on_click(UniformListExample::clicked) // Slot<Entry> is validated site context
            .child(text(format!("Item {}", self.n)))
    }
}

impl View for UniformListExample {
    fn view(&self) -> El<'_> {
        div()
            .bg(Color::White)
            .child(virtual_list(&self.entries).scroll(Axis::Y).h_full()) // Entry: View — no row fn
    }
}

fn main() {
    Application::run(Window::document(UniformListExample {
        entries: (1..=50).map(|n| Entry { n }).collect(),
    }));
}
