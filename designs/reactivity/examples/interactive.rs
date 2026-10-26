//! Syntax sketch of `crates/gpui/examples/learn/interactive_elements.rs`.
//!
//! What changes: hover/press are *style variants*, not stored bools the owner re-describes.
//! Click counts are a cell. Drag is a typed payload, not `cx.listener` clones. `Dropped<T>` is
//! the drop-event payload type — never `Drop<…>`, which shadows `std::ops::Drop` (12 §8).
//! Demos are fields; `&self.click` is a child — no `.view()` at the call site.

use gpui::prelude::*;

struct ClickDemo {
    click_count: usize,
    last: String,
}

impl ClickDemo {
    fn clicked(&mut self, ev: ClickEvent) {
        self.click_count += 1;
        self.last = match ev.click_count() {
            1 => "Single".into(),
            2 => "Double".into(),
            n => format!("{n}×"),
        };
    }
}

impl View for ClickDemo {
    fn view(&self) -> El<'_> {
        column((
            text("Click Events").text_sm().semibold(),
            button("Click Me!").on_click(ClickDemo::clicked),
            text(format_args!("Total: {}", self.click_count))
                .text_xs()
                .text_muted(),
            text(&self.last).text_xs().text_muted(),
        ))
        .gap_3()
        .p_4()
        .bg(theme.container)
    }
}

// Hover: do not store `is_hovered`. The style variant is the interaction.
// A *count* of entries is state; the border color is not.

struct HoverDemo {
    hover_count: usize,
}

impl HoverDemo {
    fn entered(&mut self) {
        self.hover_count += 1;
    }
}

impl View for HoverDemo {
    fn view(&self) -> El<'_> {
        column((
            text("Hover Events").text_sm().semibold(),
            div()
                .px_4()
                .py_3()
                .rounded_md()
                .border_2()
                .border_color(theme.border)
                .hover(|s| s.border_color(theme.selected).bg(theme.selected))
                .child(text("Hover Over Me"))
                .on_hover_enter(HoverDemo::entered), // discrete edge, not pointer-rate view
            text(format_args!("Times hovered: {}", self.hover_count))
                .text_xs()
                .text_muted(),
        ))
        .gap_3()
        .p_4()
        .bg(theme.container)
    }
}

// Pointer-rate position is a machine-rate *port*, not a Vec the owner formats every move.

struct MouseDemo {
    pos: Signal<Point>, // .ephemeral() — not Cmd-Z
    log: Vec<String>,   // discrete downs/ups; owner re-describes on click, not on move
}

impl MouseDemo {
    fn moved(&mut self, p: Point) {
        *self.pos = p; // DerefMut: the star is the publish; patches the text port, no rerun
    }
    fn pressed(&mut self) {
        self.log.push("down".into());
        if self.log.len() > 5 {
            self.log.remove(0);
        }
    }
}

impl View for MouseDemo {
    fn view(&self) -> El<'_> {
        column((
            div()
                .h_20()
                .rounded_md()
                .border_2()
                .on_mouse_move(MouseDemo::moved)
                .on_mouse_down(MouseDemo::pressed)
                .child(text(self.pos.project(|p| format!("({:.0}, {:.0})", p.x, p.y)))),
            // A plain `Vec<String>` was never a `List` customer: an iterator maps in constructor
            // position like any other child (14 §2), not through a deleted `.children(…)` method.
            column(self.log.iter().map(|line| text(line).text_xs())),
        ))
        .gap_3()
        .p_4()
        .bg(theme.container)
    }
}

struct Palette {
    tiles: List<Tile>,
}

struct Tile {
    color: Color,
}

impl View for Palette {
    fn view(&self) -> El<'_> {
        // The children ladder (14 §2 item 3): implicit `&list` when rows ARE views — `Tile`
        // implements `View` with the plain zero-arg `view`, so `&self.tiles` implements
        // `Children` directly and rides the delta wiring invisibly (splice/edit/move-preserving,
        // the 80% spelling); `list.each(f)` stays for a chosen projection (a non-view row, or an
        // alternate method — e.g. `self.tiles.each(Tile::compact)`); a plain iterator is for
        // ordinary data with no `List` identity at all.
        row(&self.tiles).gap_2()
    }
}

impl View for Tile {
    fn view(&self) -> El<'_> {
        div()
            .size_8()
            .bg(self.color)
            .rounded_md()
            .draggable() // payload = Slot<Tile>
            .on_drop(Palette::recolor) // fn(&mut Palette, Dropped<Color, Slot<Tile>>)
    }
}

struct InteractiveExamples {
    click: ClickDemo,
    hover: HoverDemo,
    mouse: MouseDemo,
    palette: Palette,
}

impl View for InteractiveExamples {
    fn view(&self) -> El<'_> {
        column((&self.click, &self.hover, &self.mouse, &self.palette)).gap_6()
    }
}

fn main() {
    Application::run(Window::document(InteractiveExamples::default()).title("Interactive"));
}
