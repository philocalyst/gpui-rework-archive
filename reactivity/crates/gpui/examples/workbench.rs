//! A native port using the same view and source model as `tests/ports.rs`.
#[path = "support/renderer.rs"]
mod renderer;
#[path = "support/todos.rs"]
mod todos;
use gpui::{Application, Window};

fn main() -> Result<(), gpui::NativeError> {
    Application::run_window(renderer::configure(
        Window::document(todos::Todos::default())
            .title("GPUI — Todos")
            .size(540, 620),
    ))
}
