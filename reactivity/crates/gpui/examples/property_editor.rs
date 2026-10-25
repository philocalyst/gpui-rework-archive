//! Public contained inspector composition. Enable Inspect application, then
//! activate the library button to select its root property. Ordinary mode keeps
//! the library's supplied click action. This does not pick arbitrary descendants.
use gpui::{Application, NativeError, Window};
#[path = "support/property_workbench.rs"]
mod property_workbench;
#[path = "support/renderer.rs"]
mod renderer;
fn main() -> Result<(), NativeError> {
    Application::run_window(renderer::configure(
        Window::document(property_workbench::Companion::default())
            .title("Contained property editor")
            .size(800, 400),
    ))
}
