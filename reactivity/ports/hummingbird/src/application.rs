//! Production native wiring, with the output boundary chosen by the caller.
use crate::{
    app::{Library, connect},
    audio::{AudioService, output::OutputProvider},
    database::Database,
    worker::Worker,
};

pub struct Services {
    pub library: Worker,
    pub audio: AudioService,
}

/// Use the system-device provider with the same application wiring.
pub fn system_window(
    database: Database,
) -> Result<
    (Services, gpui::Window<Library, impl gpui::LaneSet<Library>>),
    Box<dyn std::error::Error>,
> {
    window(database, crate::audio::system_output())
}

/// Construct the real Library, SQL worker, search Questions and audio service.
/// Opening a device remains lazy until an explicit playback command.
pub fn window(
    database: Database,
    output: impl OutputProvider,
) -> Result<
    (Services, gpui::Window<Library, impl gpui::LaneSet<Library>>),
    Box<dyn std::error::Error>,
> {
    let (library, inbox) = Worker::new(database)?;
    let (mut model, questions) = connect(library.handle())?;
    let (audio, audio_inbox) = AudioService::with_output(output)?;
    model.queue.attach_audio(audio.handle())?;
    let window = gpui::Window::document(model)
        .questions(questions)
        .with_inbox_status(inbox, Library::receive)?
        .with_inbox(audio_inbox, Library::receive_audio)
        .title("Hummingbird — Library port")
        .size(720, 900);
    Ok((Services { library, audio }, window))
}
