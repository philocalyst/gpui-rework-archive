//! Ordinary trees use the same retained scroll operations as native wheel/AT.
use gpui::{Application, Window};
#[path = "support/panes.rs"]
mod panes;
#[path = "support/renderer.rs"]
mod renderer;
fn main() -> Result<(), gpui::NativeError> {
    Application::run_window(renderer::configure(
        Window::document(panes::Panes { selected: None }).size(320, 240),
    ))
}
