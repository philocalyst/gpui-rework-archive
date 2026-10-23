//! Functional native qualification: real app/service, bounded output, no device.
//! Stdin commands belong to the external test client, never the product UI.
use hummingbird_gpui_port::{
    application,
    audio::{
        AudioError, Format,
        output::{OutputProvider, OutputStream, PlaybackGate},
    },
    database::Database,
    worker::Selection,
};
use std::{
    io::{BufRead, Write},
    sync::{Arc, Mutex},
    time::Duration,
};

#[derive(Default)]
struct Capture {
    credit: bool,
    opens: usize,
    frames: usize,
    queued: usize,
    drops: usize,
    gate: Option<(PlaybackGate, u64)>,
}
struct Provider(Arc<Mutex<Capture>>);
struct Sink {
    capture: Arc<Mutex<Capture>>,
    format: Format,
}
impl OutputProvider for Provider {
    type Stream = Sink;
    fn open(&mut self, format: Format, gate: PlaybackGate, epoch: u64) -> Result<Sink, AudioError> {
        let mut capture = self.0.lock().unwrap();
        assert_eq!(
            capture.queued, 0,
            "old output must retire before replacement"
        );
        capture.opens += 1;
        capture.gate = Some((gate, epoch));
        Ok(Sink {
            capture: self.0.clone(),
            format,
        })
    }
}
impl OutputStream for Sink {
    fn format(&self) -> Format {
        self.format
    }
    fn submit(&mut self, samples: &[f64]) -> Result<usize, AudioError> {
        let mut capture = self.capture.lock().unwrap();
        if !capture.credit
            || !capture
                .gate
                .as_ref()
                .unwrap()
                .0
                .allows(capture.gate.as_ref().unwrap().1)
        {
            return Ok(0);
        }
        let frames = (64 - capture.queued).min(samples.len() / self.format.channels as usize);
        assert!(
            samples[..frames * self.format.channels as usize]
                .iter()
                .all(|s| s.is_finite())
        );
        capture.queued += frames;
        capture.frames += frames;
        assert!(capture.queued <= 64);
        Ok(frames)
    }
    fn queued_frames(&self) -> usize {
        self.capture.lock().unwrap().queued
    }
    fn set_playing(&mut self, _: bool) -> Result<(), AudioError> {
        Ok(())
    }
}
impl Drop for Sink {
    fn drop(&mut self) {
        let mut capture = self.capture.lock().unwrap();
        capture.queued = 0;
        capture.drops += 1;
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let database = Database::fixture()?;
    let fixture = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("assets/audio/stereo.wav");
    database.connection().execute(
        "UPDATE track SET location = ?1 WHERE id IN (44, 90)",
        [fixture.to_str().unwrap()],
    )?;
    let capture = Arc::new(Mutex::new(Capture::default()));
    let (services, window) = application::window(database, Provider(capture.clone()))?;
    // A harness-only command reader owns the existing SQL service; the app
    // receives all effects through its normal Questions and bounded inbox.
    let commands = std::thread::spawn(move || {
        let mut library = Some(services.library);
        for line in std::io::stdin().lock().lines() {
            let command = line.unwrap();
            match command.as_str() {
                "import" => {
                    library
                        .as_ref()
                        .unwrap()
                        .prepend_fixture_track()
                        .unwrap()
                        .recv_timeout(Duration::from_secs(5))
                        .unwrap()
                        .unwrap();
                }
                "collision" => {
                    library
                        .as_ref()
                        .unwrap()
                        .handle()
                        .prepare_and_play(Selection {
                            id: Some(90),
                            sequence: 1,
                            generation: 0,
                        })
                        .unwrap();
                    library
                        .as_ref()
                        .unwrap()
                        .checkpoint()
                        .unwrap()
                        .recv_timeout(Duration::from_secs(5))
                        .unwrap();
                }
                "credit" => capture.lock().unwrap().credit = true,
                "disconnect" => library.take().unwrap().finish().unwrap(),
                "stats" => {
                    let state = capture.lock().unwrap();
                    let allowed = state
                        .gate
                        .as_ref()
                        .is_some_and(|(gate, epoch)| gate.allows(*epoch));
                    println!(
                        "STATS,{},{},{},{},{}",
                        state.opens, state.frames, state.queued, state.drops, allowed
                    );
                }
                _ => panic!("unknown qualification command"),
            }
            println!("ACK,{command}");
            std::io::stdout().flush().unwrap();
        }
        if let Some(library) = library {
            library.finish().unwrap();
        }
    });
    let result = gpui::Application::run_window(
        window
            .renderer(gpui::RendererPolicy::ReferenceCpu)
            .on_presented(|frame| {
                eprintln!(
                    "HUMMINGBIRD_PRESENT,{:?},{},{}",
                    frame.renderer, frame.source_epoch, frame.presentation_epoch
                );
            }),
    );
    assert!(
        services.audio.finish(Duration::from_secs(2)),
        "audio owner did not retire"
    );
    commands.join().unwrap();
    result?;
    eprintln!("HUMMINGBIRD_NATIVE_CLOSED");
    Ok(())
}
