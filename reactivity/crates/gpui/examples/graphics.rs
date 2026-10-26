#[path = "support/graphics.rs"]
mod graphics;
#[path = "support/renderer.rs"]
mod renderer;
use gpui::{Application, Window};
fn main() -> Result<(), gpui::NativeError> {
    Application::run_window(renderer::configure(
        Window::document(graphics::Graphics::default())
            .title("GPUI — Color and geometry")
            .size(560, 440),
    ))
}
