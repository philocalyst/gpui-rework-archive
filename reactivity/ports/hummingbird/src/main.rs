use hummingbird_gpui_port::transcript;
#[cfg(feature = "native")]
use hummingbird_gpui_port::{
    app::{Library, connect},
    database::Database,
    worker::Worker,
};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut native = false;
    let mut database = None;
    let mut arguments = std::env::args().skip(1);
    while let Some(argument) = arguments.next() {
        match argument.as_str() {
            "--native" => native = true,
            "--database" => database = Some(arguments.next().ok_or("--database requires a path")?),
            "--headless" => {}
            _ => {
                return Err(
                    "expected --headless, --native or --database <existing library>".into(),
                );
            }
        }
    }
    if !native {
        if database.is_some() {
            return Err(
                "Use --native with --database; headless mode runs the pinned fixture".into(),
            );
        }
        println!("{:#?}", transcript::run()?);
        return Ok(());
    }
    run_native(database)
}

#[cfg(feature = "native")]
fn run_native(path: Option<String>) -> Result<(), Box<dyn std::error::Error>> {
    let database = match path {
        Some(path) => Database::open_read_only(std::path::Path::new(&path))?,
        None => Database::fixture()?,
    };
    let (worker, inbox) = Worker::new(database)?;
    let (model, questions) = connect(worker.handle())?;
    let result = gpui::Application::run_window(
        gpui::Window::document(model)
            .questions(questions)
            .with_inbox(inbox, Library::receive)
            .title("Hummingbird — Library port")
            .size(720, 520)
            .renderer(gpui::RendererPolicy::ReferenceCpu)
            .on_presented(|frame| {
                eprintln!(
                    "HUMMINGBIRD_PRESENT,{:?},{},{}",
                    frame.renderer, frame.source_epoch, frame.presentation_epoch
                )
            }),
    );
    worker.finish().map_err(|_| "library worker panicked")?;
    result?;
    Ok(())
}
#[cfg(not(feature = "native"))]
fn run_native(_: Option<String>) -> Result<(), Box<dyn std::error::Error>> {
    Err("build with --features native to open the application window".into())
}
