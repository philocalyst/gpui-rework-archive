#[path = "../examples/support/todo_comparison.rs"]
mod todos;

use gpui::{Remote, Win, WindowOptions};

#[test]
fn comparison_preserves_the_tutorial_input_filter_delete_and_undo_contract() {
    let mut win = Win::with_size(todos::Todos::seeded(0, false), 540, 620).unwrap();
    win.type_text(win.input(), "  Port a real app é  ").unwrap();
    win.click(win.button("Add")).unwrap();
    assert!(win.contains_text("Port a real app é").unwrap());
    assert!(win.contains_text("1 left").unwrap());
    win.click(win.button("Complete")).unwrap();
    win.click(win.button("Active")).unwrap();
    assert_eq!(
        win.find_text("Port a real app é"),
        Err(gpui::Error::MissingElement)
    );
    win.click(win.button("Done")).unwrap();
    assert!(win.contains_text("Port a real app é").unwrap());
    win.click(win.button("All")).unwrap();
    win.click(win.button("Delete")).unwrap();
    assert_eq!(
        win.find_text("Port a real app é"),
        Err(gpui::Error::MissingElement)
    );
    win.click(win.button("Undo")).unwrap();
    assert!(win.contains_text("Port a real app é").unwrap());
    let restored = Win::<todos::Todos>::from_json(&win.source_json().unwrap()).unwrap();
    assert!(restored.contains_text("Port a real app é").unwrap());
    assert!(restored.contains_text("0 left").unwrap());
}

#[test]
fn whitespace_does_not_create_a_task_or_consume_an_id() {
    let mut win = Win::with_size(todos::Todos::seeded(0, false), 540, 620).unwrap();
    win.type_text(win.input(), "   ").unwrap();
    win.click(win.button("Add")).unwrap();
    assert!(win.contains_text("0 left").unwrap());
    win.with_model(|model| {
        let value = serde_json::to_value(model).unwrap();
        assert_eq!(value["next_id"], 0);
        assert_eq!(value["todos"].as_array().unwrap().len(), 0);
    })
    .unwrap();
}

#[test]
fn heavy_fixture_really_retains_ten_thousand_rows() {
    let mut win = Win::recording(
        todos::Todos::seeded(10_000, false),
        WindowOptions {
            size: [540, 620],
            ..Default::default()
        },
    )
    .unwrap();
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    assert!(win.contains_text("Task 0001").unwrap());
    assert!(win.contains_text("Task 10000").unwrap());
    assert!(win.contains_text("6667 left").unwrap());
    assert!(win.inspect().unwrap().nodes.len() > 40_000);
}

#[test]
fn animation_uses_the_public_delivery_and_presentation_path() {
    let (remote, inbox) = Remote::<u64>::bounded(1);
    let mut win = Win::recording(
        todos::Todos::seeded(32, false),
        WindowOptions {
            size: [540, 620],
            ..Default::default()
        },
    )
    .unwrap()
    .with_inbox(inbox, |model, tick| model.tick(tick, 60))
    .unwrap();
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    let original = win.scene_digest().unwrap();
    remote.try_send(15).unwrap();
    let delivery = win.deliver_ready(1).unwrap();
    assert_eq!(delivery.applied, 1);
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    assert_ne!(win.scene_digest().unwrap(), original);
    assert!(win.contains_text("Task 0032").unwrap());
}

/// Geometry receipts for the external native input driver, outside measurement.
#[test]
#[ignore]
fn emit_pointer_driver_geometry() {
    fn receipt(win: &Win<todos::Todos>, stage: &str) -> serde_json::Value {
        let snapshot = win.inspect().unwrap();
        let visible = snapshot
            .nodes
            .iter()
            .filter(|node| {
                let [x, y, width, height] = node.bounds;
                width > 0.
                    && height > 0.
                    && x < 540.
                    && y < 620.
                    && x + width > 0.
                    && y + height > 0.
            })
            .collect::<Vec<_>>();
        serde_json::json!({"stage": stage, "nodes": visible})
    }
    let mut busy = Win::with_size(todos::Todos::seeded(0, false), 540, 620).unwrap();
    let mut cases = vec![receipt(&busy, "empty")];
    busy.type_text(busy.input(), "bench-000").unwrap();
    busy.click(busy.button("Add")).unwrap();
    cases.push(receipt(&busy, "busy-one"));
    busy.click(busy.button("Delete")).unwrap();
    cases.push(receipt(&busy, "busy-deleted"));
    for rows in [1, 15, 10_000] {
        let mut win = Win::recording(
            todos::Todos::seeded(rows, false),
            WindowOptions {
                size: [540, 620],
                ..Default::default()
            },
        )
        .unwrap();
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        cases.push(receipt(&win, &format!("seed-{rows}")));
        if rows == 1 {
            win.click(win.button("Delete")).unwrap();
            let token = win.with_scene(|_, token| token).unwrap();
            win.presented(token).unwrap();
            cases.push(receipt(&win, "seed-one-deleted"));
        }
    }
    println!("TODO_GEOMETRY,{}", serde_json::to_string(&cases).unwrap());
}
