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

fn checkpoint(win: &mut TodoWindow, phase: &str) -> Result<(), Error> {
    println!(
        "TODO_RECORDING_STATE,{}",
        serde_json::json!({
            "phase": phase,
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
    checkpoint(&mut win, "mounted")?;
    let input = win.input();
    win.reset_counters()?;
    measure("type", || {
        win.type_text(input, "bench-000")?;
        Ok(())
    })?;
    measure("type_ack", || acknowledge(&mut win))?;
    checkpoint(&mut win, "typed")?;
    for (phase, label) in [
        ("add", "Add"),
        ("complete", "Complete"),
        ("active", "Active"),
        ("done", "Done"),
        ("all", "All"),
        ("delete", "Delete"),
        ("undo", "Undo"),
    ] {
        let target = first_button(&win, label)?;
        win.reset_counters()?;
        measure(phase, || {
            win.click(target)?;
            Ok(())
        })?;
        measure("ack", || acknowledge(&mut win))?;
        checkpoint(&mut win, phase)?;
    }
    let state = serde_json::from_str::<serde_json::Value>(&win.source_json()?)?;
    let mut expected_rows = (0..rows)
        .map(|index| {
            serde_json::json!({
                "id": index,
                "title": format!("Task {:04}", index + 1),
                "done": index == 0 || index % 3 == 1,
            })
        })
        .collect::<Vec<_>>();
    expected_rows.push(serde_json::json!({
        "id": rows,
        "title": "bench-000",
        "done": rows == 0,
    }));
    assert_eq!(
        state,
        serde_json::json!({
            "todos": expected_rows,
            "filter": "All",
            "draft": "",
            "next_id": rows + 1,
            "deleted": null,
        })
    );
    println!("TODO_RECORDING_VALIDATED,rows={},operations=8", rows + 1);
    measure("close", || {
        win.close();
        Ok(())
    })?;
    Ok(())
}
