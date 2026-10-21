//! A real virtual library surface, not a port of Hummingbird's audio engine.
#[path = "support/library.rs"]
mod library;

fn main() -> Result<(), gpui::NativeError> {
    let renderer = match std::env::args().nth(1).as_deref() {
        None | Some("--auto") => gpui::RendererPolicy::Auto,
        Some("--cpu") => gpui::RendererPolicy::ReferenceCpu,
        Some("--gpu") => gpui::RendererPolicy::Gpu,
        _ => panic!("expected --auto, --cpu or --gpu"),
    };
    gpui::Application::run_window(
        gpui::Window::document(library::Library::new(250_000))
            .title("GPUI — virtual library")
            .size(760, 600)
            .renderer(renderer),
    )
}
