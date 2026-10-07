#[path = "bin/first-window.rs"] mod first_window;
#[path = "bin/counter.rs"] mod counter;
#[path = "bin/layout.rs"] mod layout;
#[path = "bin/actions.rs"] mod actions;
#[path = "bin/lists.rs"] mod lists;
#[path = "bin/drawing.rs"] mod drawing;
#[path = "bin/animation.rs"] mod animation;
#[path = "bin/async-task.rs"] mod async_task;
#[path = "bin/subscriptions.rs"] mod subscriptions;
#[path = "bin/text.rs"] mod text;

fn main() {
    #[cfg(target_family = "wasm")]
    let example = web_sys::window().and_then(|window| window.location().hash().ok())
        .unwrap_or_default();
    #[cfg(not(target_family = "wasm"))]
    let example = std::env::args().nth(1).unwrap_or_default();
    match example.trim_start_matches('#') {
        "counter" => counter::main(),
        "layout" => layout::main(),
        "actions" => actions::main(),
        "lists" => lists::main(),
        "drawing" => drawing::main(),
        "animation" => animation::main(),
        "async-task" => async_task::main(),
        "subscriptions" => subscriptions::main(),
        "text" => text::main(),
        _ => first_window::main(),
    }
}
