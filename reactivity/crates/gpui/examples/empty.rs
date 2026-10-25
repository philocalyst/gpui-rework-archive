//! Isolates native/driver memory from fonts and application content.
use gpui::{Application, El, View, Window, div};
#[path = "support/renderer.rs"]
mod renderer;
struct Empty;
impl View for Empty {
    fn view(&self) -> El<'_> { div() }
}
fn main() -> Result<(), gpui::NativeError> {
    Application::run_window(Window::document(Empty).renderer(renderer::policy()))
}
