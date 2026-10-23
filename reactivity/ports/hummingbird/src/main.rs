use hummingbird_gpui_port::transcript;
#[cfg(feature = "native")]
use hummingbird_gpui_port::{
    app::{Library, connect},
    database::Database,
    worker::Worker,
};

enum Renderer {
    Auto,
    Cpu,
    Gpu,
}
impl Renderer {
    fn parse(value: Option<String>) -> Result<Self, &'static str> {
        match value.as_deref() {
            Some("auto") => Ok(Self::Auto),
            Some("cpu") => Ok(Self::Cpu),
            Some("gpu") => Ok(Self::Gpu),
            _ => Err("--renderer requires auto, cpu or gpu"),
        }
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut native = false;
    let mut database = None;
    let mut renderer = None;
    let mut arguments = std::env::args().skip(1);
    while let Some(argument) = arguments.next() {
        match argument.as_str() {
            "--native" => native = true,
            "--database" => database = Some(arguments.next().ok_or("--database requires a path")?),
            "--renderer" => renderer = Some(Renderer::parse(arguments.next())?),
            "--headless" => {}
            _ => {
                return Err(
                    "expected --headless, --native, --database <path> or --renderer <auto|cpu|gpu>"
                        .into(),
                );
            }
        }
    }
    if !native {
        if database.is_some() || renderer.is_some() {
            return Err(
                "Use --native with --database or --renderer; headless mode runs the pinned fixture"
                    .into(),
            );
        }
        println!("{:#?}", transcript::run()?);
        return Ok(());
    }
    run_native(database, renderer.unwrap_or(Renderer::Auto))
}

#[cfg(feature = "native")]
fn run_native(path: Option<String>, renderer: Renderer) -> Result<(), Box<dyn std::error::Error>> {
    let database = match path {
        Some(path) => Database::open_read_only(std::path::Path::new(&path))?,
        None => Database::fixture()?,
    };
    let (worker, inbox) = Worker::new(database)?;
    let (mut model, questions) = connect(worker.handle())?;
    let (audio, audio_inbox) = hummingbird_gpui_port::audio::AudioService::new()?;
    model.queue.attach_audio(audio.handle())?;
    let result = gpui::Application::run_window(
        gpui::Window::document(model)
            .questions(questions)
            .with_inbox_status(inbox, Library::receive)?
            .with_inbox(audio_inbox, Library::receive_audio)
            .title("Hummingbird — Library port")
            .size(720, 900)
            .renderer(match renderer {
                Renderer::Auto => gpui::RendererPolicy::Auto,
                Renderer::Cpu => gpui::RendererPolicy::ReferenceCpu,
                Renderer::Gpu => gpui::RendererPolicy::Gpu,
            })
            .on_presented(|frame| {
                eprintln!(
                    "HUMMINGBIRD_PRESENT,{:?},{},{}",
                    frame.renderer, frame.source_epoch, frame.presentation_epoch
                )
            }),
    );
    let _ = audio.finish(std::time::Duration::from_millis(100));
    worker.finish().map_err(|_| "library worker panicked")?;
    result?;
    Ok(())
}
#[cfg(not(feature = "native"))]
fn run_native(_: Option<String>, _: Renderer) -> Result<(), Box<dyn std::error::Error>> {
    Err("build with --features native to open the application window".into())
}
