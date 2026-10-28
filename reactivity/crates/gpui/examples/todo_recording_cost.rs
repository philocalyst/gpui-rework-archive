//! Ordinary five-app Todo workload through the public recording interface.
//! Recording timings exclude the OS, framebuffer rasterization and scanout.
#[path = "support/todo_five.rs"]
#[expect(
    dead_code,
    reason = "This fixture profiles Todo edits; the native fixture exercises animation ticks."
)]
mod todos;

use gpui::{Error, Role, Target, Win, WindowOptions};
use std::{hint::black_box, time::Instant};

type TodoWindow = Win<todos::Todos>;

#[derive(Clone, Copy)]
enum Action {
    Add,
    Complete,
    Active,
    Done,
    All,
    Delete,
    Undo,
}
impl Action {
    fn labels(self) -> (&'static str, &'static str) {
        match self {
            Self::Add => ("add", "Add"),
            Self::Complete => ("complete", "Complete"),
            Self::Active => ("active", "Active"),
            Self::Done => ("done", "Done"),
            Self::All => ("all", "All"),
            Self::Delete => ("delete", "Delete"),
            Self::Undo => ("undo", "Undo"),
        }
    }
}
#[derive(serde::Serialize)]
struct ExpectedTodo {
    id: usize,
    title: String,
    done: bool,
}
#[derive(serde::Serialize)]
struct Expected {
    todos: Vec<ExpectedTodo>,
    filter: &'static str,
    draft: String,
    next_id: usize,
    deleted: Option<(usize, ExpectedTodo)>,
}
impl Expected {
    fn seeded(rows: usize) -> Self {
        Self {
            todos: (0..rows)
                .map(|index| ExpectedTodo {
                    id: index,
                    title: format!("Task {:04}", index + 1),
                    done: index % 3 == 1,
                })
                .collect(),
            filter: "All",
            draft: String::new(),
            next_id: rows,
            deleted: None,
        }
    }
    fn apply(&mut self, action: Action) {
        match action {
            Action::Add => {
                self.todos.push(ExpectedTodo {
                    id: self.next_id,
                    title: std::mem::take(&mut self.draft),
                    done: false,
                });
                self.next_id += 1;
            }
            Action::Complete => {
                let todo = self.todos.first_mut().expect("Add supplies the first row");
                todo.done = !todo.done;
            }
            Action::Active => self.filter = "Active",
            Action::Done => self.filter = "Done",
            Action::All => self.filter = "All",
            Action::Delete => self.deleted = Some((0, self.todos.remove(0))),
            Action::Undo => {
                let (index, todo) = self.deleted.take().expect("Delete supplies Undo");
                self.todos.insert(index, todo);
            }
        }
    }
}

fn measure<T>(phase: &str, operation: impl FnOnce() -> Result<T, Error>) -> Result<T, Error> {
    let mut result = None;
    let started = Instant::now();
    let cost = allocation_counter::measure(|| result = Some(operation()));
    let elapsed = started.elapsed().as_nanos();
    let result = result.unwrap();
    println!(
        "TODO_RECORDING_COST,{}",
        serde_json::json!({
            "phase": phase,
            "wall_ns": elapsed,
            "allocations": cost.count_total,
            "requested_bytes": cost.bytes_total,
            "retained_delta_bytes": cost.bytes_current,
            "peak_extra_bytes": cost.bytes_max,
            "success": result.is_ok(),
        })
    );
    result
}

fn acknowledge(win: &mut TodoWindow) -> Result<(), Error> {
    let token = win.with_scene(|scene, token| {
        black_box(scene);
        token
    })?;
    win.presented(token)?;
    Ok(())
}

fn first_button(win: &TodoWindow, label: &str) -> Result<Target, Error> {
    let mut target = None;
    win.visit(|part| {
        if target.is_none() && part.role() == Role::Button && part.text() == Some(label) {
            target = Some(part.target());
        }
    })?;
    target.ok_or(Error::MissingElement)
}

fn checkpoint(win: &mut TodoWindow, phase: &str, expected: &Expected) -> Result<(), Error> {
    // Validate outside each measured edit and ACK. A later inverse operation
    // must not conceal a wrong intermediate model or an ignored filter.
    let state = serde_json::from_str::<serde_json::Value>(&win.source_json()?)
        .expect("ordinary source serialization produces JSON");
    assert_eq!(
        state,
        serde_json::to_value(expected).expect("fixture expectations serialize"),
        "canonical source after {phase}",
    );
    println!(
        "TODO_RECORDING_STATE,{}",
        serde_json::json!({
            "phase": phase,
            "full_model_validated": true,
            "scene_digest": win.scene_digest()?,
            "counters": win.counters(),
        })
    );
    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let rows = std::env::args()
        .nth(1)
        .map_or(Ok(10_000), |value| value.parse::<usize>())?;
    let model = measure("seed", || Ok(todos::Todos::seeded(rows, false)))?;
    let mut win = measure("mount", || {
        Win::recording(
            model,
            WindowOptions {
                size: [540, 620],
                ..Default::default()
            },
        )
    })?;
    measure("initial_ack", || acknowledge(&mut win))?;
    let mut expected = Expected::seeded(rows);
    checkpoint(&mut win, "mounted", &expected)?;
    let input = win.input();
    win.reset_counters()?;
    measure("type", || {
        win.type_text(input, "bench-000")?;
        Ok(())
    })?;
    measure("type_ack", || acknowledge(&mut win))?;
    expected.draft = "bench-000".into();
    checkpoint(&mut win, "typed", &expected)?;
    for action in [
        Action::Add,
        Action::Complete,
        Action::Active,
        Action::Done,
        Action::All,
        Action::Delete,
        Action::Undo,
    ] {
        let (phase, label) = action.labels();
        let target = first_button(&win, label)?;
        win.reset_counters()?;
        measure(phase, || {
            win.click(target)?;
            Ok(())
        })?;
        measure("ack", || acknowledge(&mut win))?;
        expected.apply(action);
        checkpoint(&mut win, phase, &expected)?;
    }
    println!("TODO_RECORDING_VALIDATED,rows={},operations=8", rows + 1);
    measure("close", || {
        win.close();
        Ok(())
    })?;
    Ok(())
}
