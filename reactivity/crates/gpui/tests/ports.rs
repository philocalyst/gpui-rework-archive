#[path = "../examples/support/graphics.rs"]
mod graphics;
#[path = "../examples/support/todos.rs"]
mod todos;
#[path = "../examples/support/workspace.rs"]
mod workspace;
use gpui::{Error, Win};

#[test]
fn tutorial_port_uses_the_ordinary_input_and_serialization_interface() {
    let mut win = Win::with_size(todos::Todos::default(), 540, 620).unwrap();
    let input = win.input();
    win.reset_counters().unwrap();
    win.type_text(input, "Port a real app").unwrap();
    assert_eq!(win.counters().owner_reruns, 0);
    win.click(win.button("Add")).unwrap();
    assert!(win.find_text("Port a real app").is_ok());
    assert!(win.find_text("1 left").is_ok());
    win.click(win.button("Complete")).unwrap();
    assert!(win.find_text("0 left").is_ok());
    win.click(win.button("Active")).unwrap();
    assert_eq!(win.find_text("Port a real app"), Err(Error::MissingElement));
    win.click(win.button("All")).unwrap();
    win.click(win.button("Delete")).unwrap();
    assert_eq!(win.find_text("Port a real app"), Err(Error::MissingElement));
    win.click(win.button("Undo")).unwrap();
    assert!(win.find_text("Port a real app").is_ok());
    let restored = Win::<todos::Todos>::from_json(&win.source_json().unwrap()).unwrap();
    assert!(restored.find_text("Port a real app").is_ok());
    assert!(restored.find_text("0 left").is_ok());
    assert_ne!(win.scene_digest().unwrap(), 0);
}

#[test]
fn component_graphics_port_reuses_layout_for_geometry_and_color_updates() {
    let mut win = Win::with_size(graphics::Graphics::default(), 560, 440).unwrap();
    let original = win.scene_digest().unwrap();
    win.reset_counters().unwrap();
    win.click(win.button("Rotate")).unwrap();
    assert_eq!(win.counters().owner_reruns, 1);
    assert_eq!(win.counters().layout_runs, 0);
    assert_ne!(win.scene_digest().unwrap(), original);
    win.click(win.button("Reset")).unwrap();
    assert_eq!(win.scene_digest().unwrap(), original);
    win.reset_counters().unwrap();
    win.click(win.button("Toggle chroma")).unwrap();
    assert_eq!(win.counters().layout_runs, 0);
    assert_ne!(win.scene_digest().unwrap(), original);
}

#[test]
fn complete_application_views_compose_without_rewriting_their_state_or_routes() {
    let mut win = Win::recording(
        workspace::Workspace::default(),
        gpui::WindowOptions {
            size: [1100, 720],
            ..Default::default()
        },
    )
    .unwrap();
    let acknowledge = |win: &mut Win<workspace::Workspace>| {
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
    };
    acknowledge(&mut win);
    let rotate = win.button("Rotate");
    win.reset_counters().unwrap();
    win.type_text(win.input(), "Independent child application")
        .unwrap();
    assert_eq!(win.counters().owner_reruns, 0);
    acknowledge(&mut win);
    win.click(win.button("Add")).unwrap();
    acknowledge(&mut win);
    assert!(win.find_text("Independent child application").is_ok());
    assert_eq!(
        win.button("Rotate"),
        rotate,
        "sibling ownership survives child topology edits"
    );
    let before = win.scene_digest().unwrap();
    win.reset_counters().unwrap();
    win.click(rotate).unwrap();
    acknowledge(&mut win);
    assert_eq!(win.counters().layout_runs, 0);
    assert_ne!(win.scene_digest().unwrap(), before);
    assert!(win.find_text("1 left").is_ok());
}
