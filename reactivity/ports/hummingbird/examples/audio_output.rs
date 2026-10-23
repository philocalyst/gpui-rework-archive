//! Opt-in real CPAL device smoke. Queue drain excludes OS/hardware latency.
use gpui::{ListId, Win};
use hummingbird_gpui_port::{
    audio::{AudioService, Event},
    queue::{Track, TrackRef},
    queue_view::{AudioState, QueueScreen},
};
use std::{
    path::PathBuf,
    time::{Duration, Instant},
};
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let path = std::env::args_os()
        .nth(1)
        .map(PathBuf::from)
        .unwrap_or_else(|| {
            PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("assets/audio/stereo.flac")
        });
    let (service, inbox) = AudioService::new()?;
    let mut model =
        QueueScreen::new(ListId::new(9000)).map_err(|error| format!("queue: {error:?}"))?;
    model.enqueue(TrackRef::new(Track {
        path,
        title: "Real CPAL smoke".into(),
        track_id: None,
        album_id: None,
        available_when_prepared: true,
    }));
    model.attach_audio(service.handle())?;
    let mut owner =
        Win::with_size(model, 720, 700)?.with_inbox(inbox, |model: &mut QueueScreen, event| {
            if let Event::Failed { error, .. } = &event {
                println!("CPAL_OUTPUT_UNAVAILABLE_OR_FAILED {error:?}: {error}");
            }
            model.receive_audio(event);
        })?;
    let deadline = Instant::now() + Duration::from_secs(15);
    loop {
        owner.deliver_ready(32)?;
        let status = owner.with_model(|model| model.audio_status().unwrap())?;
        if matches!(status.state, AudioState::Finished | AudioState::Failed) {
            println!(
                "CPAL_OUTPUT_STATE {status:?}; application queue only, hardware latency unmeasured"
            );
            break;
        }
        if Instant::now() >= deadline {
            return Err("CPAL output smoke did not terminate within 15 seconds".into());
        }
        std::thread::sleep(Duration::from_millis(2));
    }
    drop(owner);
    if !service.finish(Duration::from_secs(1)) {
        return Err("audio control owner did not finish".into());
    }
    Ok(())
}
