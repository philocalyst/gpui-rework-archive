//! Text inputs over a `Signal<String>` and over an `Entity<Editor>`. A cursor readout is a second
//! subscriber to the same editor: it wires into `editor.cursor` through the entity deref (07 §9,
//! §13) and patches on its own, without re-describing the form. `Key::Q.primary()` is a view-level
//! chord. Helpers borrow their inputs for the frame, so they return elements borrowed for `'_`
//! (07 §2.1). Single-source projections are an inherent method — `editor.cursor.project(…)`, never
//! `(&editor.cursor).project(…)` (12 §5).

use gpui::prelude::*;

struct ViewExample {
    name: Signal<String>,
    email: Signal<String>,
    bio: Signal<String>,
    notes: Entity<Editor>,
    owned: Entity<Editor>,
}

impl Default for ViewExample {
    fn default() -> Self {
        Self {
            name: Signal::new(String::new()),
            email: Signal::new("me@example.com".into()),
            bio: Signal::new(String::new()),
            notes: Entity::new(Editor::new("multi\nline")),
            owned: Entity::new(Editor::new("editable")),
        }
    }
}

fn section<'a>(title: &'a str, children: impl IntoChildren + 'a) -> impl Element + 'a {
    column((text(title).text_sm().text_muted(), children)).gap(8)
}

fn cursor_readout(editor: &Entity<Editor>) -> impl Element + '_ {
    text(editor.cursor.project(|c| format!("cursor @ {c}")))
        .text_sm()
        .text_muted()
}

impl View for ViewExample {
    fn view(&self) -> El<'_> {
        column((
            section(
                "Inputs",
                column((
                    text_input(&self.name).w(320),
                    text_input(&self.email).w(320).text_color(0x4d4d4d),
                ))
                .gap(8),
            ),
            section(
                "Input",
                row((text_input(&self.owned).w(320), cursor_readout(&self.owned)))
                    .items_center()
                    .gap(12),
            ),
            section(
                "Text areas",
                column((
                    textarea(&self.bio).rows(3),
                    row((
                        textarea(&self.notes)
                            .rows(3)
                            .text_color(oklch(0.45, 0.12, 250.)),
                        cursor_readout(&self.notes),
                    ))
                    .items_start()
                    .gap(12),
                ))
                .gap(8),
            ),
        ))
        .on_key(Key::Q.primary(), quit)
        .bg(0xf0f0f0)
        .p(24)
        .gap(24)
    }
}

fn main() {
    Application::run(
        Window::document(ViewExample::default())
            .title("Input")
            .size(560, 480)
            .centered(),
    );
}
