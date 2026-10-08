#[path = "../examples/actions.rs"]
mod actions;
#[path = "../examples/animation.rs"]
mod animation;
#[path = "../examples/async-task.rs"]
mod async_task;
#[path = "../examples/counter.rs"]
mod counter;
#[path = "../examples/custom-element.rs"]
mod custom_element;
#[path = "../examples/drawing.rs"]
mod drawing;
#[path = "../examples/first-window.rs"]
mod first_window;
#[path = "../examples/layout.rs"]
mod layout;
#[path = "../examples/lists.rs"]
mod lists;
#[path = "../examples/subscriptions.rs"]
mod subscriptions;
#[path = "../examples/text.rs"]
mod text;
#[path = "../examples/text-hit-testing.rs"]
mod text_hit_testing;

#[cfg(target_family = "wasm")]
mod components;
#[cfg(target_family = "wasm")]
mod host;
#[cfg(target_family = "wasm")]
mod support;
#[cfg(target_family = "wasm")]
mod workbench;

fn main() {
    #[cfg(target_family = "wasm")]
    let example = web_sys::window()
        .and_then(|window| window.location().hash().ok())
        .unwrap_or_default();
    #[cfg(not(target_family = "wasm"))]
    let example = std::env::args().nth(1).unwrap_or_default();
    #[cfg(target_family = "wasm")]
    if let Some(slug) = example.trim_start_matches('#').strip_prefix("host/") {
        host::run(slug);
        return;
    }
    #[cfg(target_family = "wasm")]
    if let Some(slug) = example.trim_start_matches('#').strip_prefix("edit/") {
        workbench::run(slug);
        return;
    }
    match example.trim_start_matches('#') {
        "counter" => counter::main(),
        "layout" => layout::main(),
        "actions" => actions::main(),
        "lists" => lists::main(),
        "drawing" => drawing::main(),
        "custom-element" => custom_element::main(),
        "animation" => animation::main(),
        "async-task" => async_task::main(),
        "subscriptions" => subscriptions::main(),
        "text" => text::main(),
        "text-hit-testing" => text_hit_testing::main(),
        _ => first_window::main(),
    }
}
