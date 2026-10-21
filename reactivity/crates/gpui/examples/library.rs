//! A real virtual library surface, not a port of Hummingbird's audio engine.
#[path = "support/library.rs"]
mod library;
#[path = "support/search_library.rs"]
mod search_library;

fn main() -> Result<(), gpui::NativeError> {
    let mut renderer = gpui::RendererPolicy::Auto;
    let mut search = false;
    let mut startup = false;
    for argument in std::env::args().skip(1) {
        match argument.as_str() {
            "--auto" => renderer = gpui::RendererPolicy::Auto,
            "--cpu" => renderer = gpui::RendererPolicy::ReferenceCpu,
            "--gpu" => renderer = gpui::RendererPolicy::Gpu,
            "--search" => search = true,
            "--startup" => startup = true,
            _ => panic!("expected --auto, --cpu, --gpu, --search or --startup"),
        }
    }
    if !search {
        return gpui::Application::run_window(observe_startup(
            gpui::Window::document(library::Library::new(250_000))
                .title("GPUI — virtual library")
                .size(760, 600)
                .renderer(renderer),
            startup,
        ));
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
    gpui::Application::run_window(observe_startup(
        gpui::Window::document(search_library::SearchLibrary::new(count, results))
            .questions(questions)
            .title("GPUI — virtual library")
            .size(760, 600)
            .renderer(renderer),
        startup,
    ))
}

// Same post-submit/ack marker used by the ordinary renderer examples. Install
// no observer for normal interactive runs, including --search.
fn observe_startup<V: gpui::View + 'static, L: gpui::LaneSet<V>>(
    window: gpui::Window<V, L>,
    enabled: bool,
) -> gpui::Window<V, L> {
    if !enabled {
        return window;
    }
    let started = std::time::Instant::now();
    let mut reported = None;
    window.on_presented(move |frame| {
        if reported != Some(frame.renderer) {
            reported = Some(frame.renderer);
            eprintln!(
                "GPUI_PRESENT,{:?},{},{},{}",
                frame.renderer,
                frame.source_epoch,
                frame.presentation_epoch,
                started.elapsed().as_micros()
            );
        }
    })
}
