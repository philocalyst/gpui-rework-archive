//! A real virtual library surface, not a port of Hummingbird's audio engine.
#[path = "support/library.rs"]
mod library;
#[path = "support/search_library.rs"]
mod search_library;

fn main() -> Result<(), gpui::NativeError> {
    let mut renderer = gpui::RendererPolicy::Auto;
    let mut search = false;
    for argument in std::env::args().skip(1) {
        match argument.as_str() {
            "--auto" => renderer = gpui::RendererPolicy::Auto,
            "--cpu" => renderer = gpui::RendererPolicy::ReferenceCpu,
            "--gpu" => renderer = gpui::RendererPolicy::Gpu,
            "--search" => search = true,
            _ => panic!("expected --auto, --cpu, --gpu or --search"),
        }
    }
    if !search {
        return gpui::Application::run_window(
            gpui::Window::document(library::Library::new(250_000))
                .title("GPUI — virtual library")
                .size(760, 600)
                .renderer(renderer),
        );
    }
    let count = 250_000;
    let mut worker =
        search_library::SearchWorker::new().expect("create the explicitly owned search worker");
    let (questions, results) = gpui::Questions::new()
        .question(
            search_library::SearchLibrary::QUERY,
            move |query| search_library::freeze(query, count),
            move |input, completion| worker.start(input, completion),
        )
        .expect("declare search");
    gpui::Application::run_window(
        gpui::Window::document(search_library::SearchLibrary::new(count, results))
            .questions(questions)
            .title("GPUI — virtual library")
            .size(760, 600)
            .renderer(renderer),
    )
}
