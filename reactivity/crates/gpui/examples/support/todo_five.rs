//! Benchmark copy of the ordinary Todo example. Domain operations are retained;
//! a fixed viewport, deterministic seed and animation port normalize the comparison.
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
    #[serde(skip)]
    translation: Signal<Affine>,
    #[serde(skip)]
    callbacks: u64,
    #[serde(skip)]
    actions: Vec<String>,
    #[serde(skip)]
    ticks: u64,
    #[serde(skip)]
    report: bool,
}
impl Todos {
    const TRANSLATION: Source<Self, Affine> = Source::new(
        FieldId::new(3),
        "translation",
        |m| &m.translation,
        |m| &mut m.translation,
    );
    pub fn seeded(rows: usize, report: bool) -> Self {
        assert!(
            rows <= 10_000,
            "comparison admits at most 10,000 retained rows"
        );
        Self {
            draft: Signal::default(),
            filter: Signal::default(),
            todos: (0..rows)
                .map(|index| Todo {
                    id: index as u64,
                    title: format!("Task {:04}", index + 1),
                    done: index % 3 == 1,
                })
                .collect(),
            next_id: rows as u64,
            deleted: None,
            translation: Signal::default(),
            callbacks: 0,
            actions: Vec::new(),
            ticks: 0,
            report,
        }
    }
    pub fn tick(&mut self, index: u64, hz: u32) {
        *self.translation = Affine::translation(
            0.,
            12. * (index as f32 / hz as f32 * std::f32::consts::TAU).sin(),
        );
        self.ticks += 1;
    }
    fn filter(&mut self, filter: Filter) {
        *self.filter = Filter::All;
        self.action(match filter {
            Filter::All => "all",
            Filter::Active => "active",
            Filter::Done => "done",
        });
    }
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
        self.action("add");
    }
    fn toggle(&mut self, id: u64) {
        if let Some(todo) = self.todos.iter_mut().find(|todo| todo.id == id) {
            todo.done = !todo.done;
            self.action("complete");
        }
    }
    fn delete(&mut self, id: u64) {
        if let Some(index) = self.todos.iter().position(|todo| todo.id == id) {
            self.deleted = Some((index, self.todos.remove(index)));
            self.action("delete");
        }
    }
    fn undo(&mut self) {
        if let Some((index, todo)) = self.deleted.take() {
            self.todos.insert(index.min(self.todos.len()), todo);
            self.action("undo");
        }
    }
    fn action(&mut self, kind: &str) {
        self.callbacks += 1;
        self.actions.push(kind.to_owned());
        eprintln!(
            "TODO_ACTION,{}",
            serde_json::json!({"action":kind,"callbacks":self.callbacks})
        );
    }
    fn revision_marker(&self) -> El<'_> {
        let payload = ((self.callbacks + self.ticks) & 0x7fff_ffff) as u32;
        let encoded = payload | ((payload.count_ones() & 1) << 31);
        column((0..4).map(|y| {
            row((0..8).map(|x| {
                let bit = y * 8 + x;
                div().w(5).h(5).bg(if (encoded >> bit) & 1 != 0 {
                    rgb(0xffffff)
                } else {
                    rgb(0x000000)
                })
            }))
            .gap(2)
            .w(56)
            .h(5)
        }))
        .gap(2)
        .w(56)
        .h(28)
    }
    fn filter_button(&self, label: &'static str, filter: Filter) -> El<'_> {
        button(label)
            .p(8)
            .bg(if *self.filter == filter {
                rgb(0xc7d2fe)
            } else {
                rgb(0xe2e8f0)
            })
            .on_click(move |model: &mut Self| model.filter(filter))
    }
}
impl View for Todos {
    fn sources() -> Sources<Self> {
        // Draft is read only by the input port. The filter drives ordinary Rust
        // branches, so its default registration invalidates this owner.
        Sources::new()
            .direct(Self::DRAFT)
            .field(Self::FILTER)
            .direct(Self::TRANSLATION)
    }
    fn view(&self) -> El<'_> {
        column((
            row((
                text("Todos").w(452).font_size(28).fg(rgb(0x172554)),
                div()
                    .w(0)
                    .h(0)
                    .child(self.revision_marker())
                    .transform(Affine::translation(0., -6.)),
            ))
            .h(38.136)
            .align(Align::Start),
            row((
                text_input(&self.draft)
                    .name("New task")
                    .description("Type a task, then choose Add")
                    .w(280)
                    .p(10)
                    .bg(rgb(0xf1f5f9)),
                button("Add")
                    .w(56)
                    .p(10)
                    .bg(rgb(0xc7d2fe))
                    .on_click(Self::add),
            ))
            .layout(Flex::row().align(Align::Center))
            .gap(8),
            column((column(
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
            .gap(6)
            .transform(&self.translation),))
            .h(360)
            .scroll(Axis::Y),
            row((
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
                .layout(Flex::row().wrap(true).gap(6)),
            ))
            .layout(Flex::row().align(Align::Center).gap(12)),
            self.deleted.as_ref().map(|(_, todo)| {
                row((
                    text(format!("Deleted {}", todo.title)),
                    button("Undo").p(8).bg(rgb(0xfef3c7)).on_click(Self::undo),
                ))
                .layout(Flex::row().align(Align::Center).wrap(true))
                .gap(8)
            }),
        ))
        .w(540)
        .h(620)
        .p(24)
        .bg(rgb(0xf8fafc))
        .gap(12)
        .fg(rgb(0x0f172a))
    }
}

impl Drop for Todos {
    fn drop(&mut self) {
        if self.report {
            eprintln!(
                "TODO_MODEL,{}",
                serde_json::json!({
                    "framework": "gpui", "rows": self.todos.len(),
                    "done": self.todos.iter().filter(|todo| todo.done).count(),
                    "callbacks": self.callbacks, "actions":self.actions, "animation_ticks": self.ticks,
                    "marker_revision": self.callbacks + self.ticks,
                    "draft": &*self.draft,
                    "deleted": self.deleted.as_ref().map(|(_, todo)| todo.id),
                "filter": &*self.filter,
                "next_id": self.next_id,
                "first_task": self.todos.first(),
                "last_task": self.todos.last(),
                })
            );
            eprintln!(
                "TODO_STATE,{}",
                serde_json::json!({"rows":self.todos,"filter":match *self.filter {Filter::All=>"all",Filter::Active=>"active",Filter::Done=>"done"},"next_id":self.next_id,"draft":&*self.draft,"deleted":self.deleted.as_ref().map(|(_,todo)|todo.id)})
            );
        }
    }
}
