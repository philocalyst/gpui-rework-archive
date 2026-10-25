//! A native port using the same view and source model as `tests/ports.rs`.
#[path = "support/todos.rs"]
mod todos;
#[path = "support/renderer.rs"]
mod renderer;
use gpui::{Application, Window};

fn main() -> Result<(), gpui::NativeError> {
    Application::run_window(
        Window::document(todos::Todos::default())
            .title("GPUI — Todos")
            .size(540, 620).renderer(renderer::policy()),
    )
}
