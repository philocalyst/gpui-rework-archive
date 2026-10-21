//! Port of the GPUI-CE tutorial's list, filtering, delete and undo behavior.
//! The same model runs in a native window and in the public test harness.
use gpui::prelude::*;
use serde::{Deserialize, Serialize};

#[derive(Clone, Copy, Default, PartialEq, Eq, Serialize, Deserialize)]
enum Filter {
    #[default]
    All,
    Active,
    Done,
}

#[derive(Serialize, Deserialize)]
struct Todo {
    id: u64,
    title: String,
    done: bool,
}

#[derive(Default, Serialize, Deserialize)]
pub struct Todos {
    draft: Signal<String>,
    filter: Signal<Filter>,
    todos: Vec<Todo>,
    next_id: u64,
    deleted: Option<(usize, Todo)>,
}
impl Todos {
    const DRAFT: Source<Self, String> =
        Source::new(FieldId::new(1), "draft", |m| &m.draft, |m| &mut m.draft);
    const FILTER: Source<Self, Filter> =
        Source::new(FieldId::new(2), "filter", |m| &m.filter, |m| &mut m.filter);
    fn add(&mut self) {
        if self.draft.trim().is_empty() {
            return;
        }
        let Some(next_id) = self.next_id.checked_add(1) else {
            return;
        };
        let title = self.draft.trim().to_owned();
        self.draft.clear();
        self.todos.push(Todo {
            id: self.next_id,
            title,
            done: false,
        });
        self.next_id = next_id;
    }
    fn toggle(&mut self, id: u64) {
        if let Some(todo) = self.todos.iter_mut().find(|todo| todo.id == id) {
            todo.done = !todo.done;
        }
    }
    fn delete(&mut self, id: u64) {
        if let Some(index) = self.todos.iter().position(|todo| todo.id == id) {
            self.deleted = Some((index, self.todos.remove(index)));
        }
    }
    fn undo(&mut self) {
        if let Some((index, todo)) = self.deleted.take() {
            self.todos.insert(index.min(self.todos.len()), todo);
        }
    }
    fn filter_button(&self, label: &'static str, filter: Filter) -> El<'_> {
        button(label)
            .p(8)
            .bg(if *self.filter == filter {
                rgb(0xc7d2fe)
            } else {
                rgb(0xe2e8f0)
            })
            .on_click(Self::FILTER.update(move |value| *value = filter))
    }
}
impl View for Todos {
    fn sources() -> Sources<Self> {
        // Draft is read only by the input port. The filter drives ordinary Rust
        // branches, so its default registration invalidates this owner.
        Sources::new().direct(Self::DRAFT).field(Self::FILTER)
    }
    fn view(&self) -> El<'_> {
        column((
            text("Todos").font_size(28).fg(rgb(0x172554)),
            row((
                text_input(&self.draft).w(280).p(10).bg(rgb(0xf1f5f9)),
                button("Add").p(10).bg(rgb(0xc7d2fe)).on_click(Self::add),
            ))
            .gap(8),
            column(
                self.todos
                    .iter()
                    .filter(|todo| match *self.filter {
                        Filter::All => true,
                        Filter::Active => !todo.done,
                        Filter::Done => todo.done,
                    })
                    .map(|todo| {
                        let id = todo.id;
                        row((
                            button(if todo.done { "Reopen" } else { "Complete" })
                                .w(100)
                                .p(8)
                                .bg(rgb(0xe2e8f0))
                                .on_click(move |m: &mut Self| m.toggle(id)),
                            text(todo.title.as_str()).w(220).p(8).fg(if todo.done {
                                rgb(0x64748b)
                            } else {
                                rgb(0x0f172a)
                            }),
                            button("Delete")
                                .p(8)
                                .bg(rgb(0xfee2e2))
                                .on_click(move |m: &mut Self| m.delete(id)),
                        ))
                        .gap(8)
                    }),
            )
            .gap(6),
            text(format!(
                "{} left",
                self.todos.iter().filter(|todo| !todo.done).count()
            ))
            .text_sm(),
            row((
                self.filter_button("All", Filter::All),
                self.filter_button("Active", Filter::Active),
                self.filter_button("Done", Filter::Done),
            ))
            .gap(6),
            self.deleted.as_ref().map(|(_, todo)| {
                row((
                    text(format!("Deleted {}", todo.title)),
                    button("Undo").p(8).bg(rgb(0xfef3c7)).on_click(Self::undo),
                ))
                .gap(8)
            }),
        ))
        .p(24)
        .gap(12)
        .fg(rgb(0x0f172a))
    }
}
