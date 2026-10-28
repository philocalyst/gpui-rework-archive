//! Two complete stateful application views in one ordinary retained tree.
#[path = "support/graphics.rs"]
mod graphics;
#[path = "support/renderer.rs"]
mod renderer;
#[path = "support/todos.rs"]
mod todos;
#[path = "support/workspace.rs"]
mod workspace;

fn main() -> Result<(), gpui::NativeError> {
    gpui::Application::run_window(renderer::configure(
        gpui::Window::document(workspace::Workspace::default())
            .title("GPUI — composed applications")
            .size(1100, 720),
    ))
}
