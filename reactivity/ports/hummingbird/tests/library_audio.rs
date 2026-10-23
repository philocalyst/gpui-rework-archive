#![cfg(feature = "audio")]
//! Complete Library/Sources -> SQLite worker -> queue -> real audio service.
use gpui::{Error, LaneSet, Remote, Role, Target, Win, WindowOptions};
use hummingbird_gpui_port::{
    app::{Library, connect, recordings, track_key},
    audio::{
        AudioError, AudioService, Event, Format, Token,
        output::{OutputProvider, OutputStream, PlaybackGate},
    },
    database::Database,
    queue_view::AudioState,
    transcript::settle,
    worker::Worker,
};
use std::{
    collections::VecDeque,
    path::{Path, PathBuf},
    sync::{Arc, Mutex},
    time::{Duration, Instant},
};

#[derive(Default)]
struct Capture {
    capacity: usize,
    queue: VecDeque<f64>,
    playing: bool,
    gate: Option<(PlaybackGate, u64)>,
    streams: Vec<Vec<f64>>,
    opened: Vec<Token>,
    adopted: usize,
    drops: usize,
}
impl Capture {
    fn drain(&mut self) {
        if self.playing
            && self
                .gate
                .as_ref()
                .is_some_and(|(gate, epoch)| gate.allows(*epoch))
        {
            self.streams
                .last_mut()
                .unwrap()
                .extend(self.queue.drain(..));
        }
    }
}
struct Provider(Arc<Mutex<Capture>>);
struct Sink {
    capture: Arc<Mutex<Capture>>,
    format: Format,
    gate: PlaybackGate,
    epoch: u64,
}
impl OutputProvider for Provider {
    type Stream = Sink;
    fn open(&mut self, format: Format, gate: PlaybackGate, epoch: u64) -> Result<Sink, AudioError> {
        let mut capture = self.0.lock().unwrap();
        assert!(capture.queue.is_empty(), "replacement must retire old PCM");
        capture.streams.push(Vec::new());
        capture.gate = Some((gate.clone(), epoch));
        drop(capture);
        Ok(Sink {
            capture: self.0.clone(),
            format,
            gate,
            epoch,
        })
    }
}
impl OutputStream for Sink {
    fn format(&self) -> Format {
        self.format
    }
    fn submit(&mut self, samples: &[f64]) -> Result<usize, AudioError> {
        if !self.gate.allows(self.epoch) {
            return Ok(0);
        }
        let mut capture = self.capture.lock().unwrap();
        let channels = self.format.channels as usize;
        let available = capture
            .capacity
            .saturating_sub(capture.queue.len() / channels);
        let frames = available.min(samples.len() / channels);
        capture
            .queue
            .extend(samples[..frames * channels].iter().copied());
        assert!(capture.queue.len() <= capture.capacity * channels);
        Ok(frames)
    }
    fn queued_frames(&self) -> usize {
        self.capture.lock().unwrap().queue.len() / self.format.channels as usize
    }
    fn set_playing(&mut self, playing: bool) -> Result<(), AudioError> {
        self.capture.lock().unwrap().playing = playing;
        Ok(())
    }
}
impl Drop for Sink {
    fn drop(&mut self) {
        let mut capture = self.capture.lock().unwrap();
        capture.queue.clear();
        capture.playing = false;
        capture.drops += 1;
    }
}
fn fixture(extension: &str) -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR")).join(format!("assets/audio/stereo.{extension}"))
}
fn database() -> Database {
    let database = Database::fixture().unwrap();
    for (id, extension) in [(44, "wav"), (90, "flac")] {
        database
            .connection()
            .execute(
                "UPDATE track SET location = ?1 WHERE id = ?2",
                rusqlite::params![fixture(extension).to_str().unwrap(), id],
            )
            .unwrap();
    }
    database
}
type Owners<L> = (
    Worker,
    AudioService,
    Arc<Mutex<Capture>>,
    Remote<Event>,
    Win<Library, L>,
);
fn owner() -> Owners<impl LaneSet<Library>> {
    let (worker, inbox) = Worker::new(database()).unwrap();
    let (mut model, questions) = connect(worker.handle()).unwrap();
    let capture = Arc::new(Mutex::new(Capture::default()));
    let (audio, audio_inbox) = AudioService::with_output(Provider(capture.clone())).unwrap();
    model.queue.attach_audio(audio.handle()).unwrap();
    let observed = capture.clone();
    let (inject, injected) = Remote::bounded(8);
    let mut win = Win::with_questions(
        model,
        questions,
        WindowOptions {
            size: [720, 1100],
            ..Default::default()
        },
    )
    .unwrap()
    .with_inbox(inbox, Library::receive)
    .unwrap()
    .with_inbox(audio_inbox, move |model: &mut Library, event: Event| {
        if let Event::Opened { token, .. } = &event {
            observed.lock().unwrap().opened.push(*token);
        }
        if matches!(event, Event::Adopted { .. }) {
            observed.lock().unwrap().adopted += 1;
        }
        model.receive_audio(event);
    })
    .unwrap()
    .with_inbox(injected, Library::receive_audio)
    .unwrap();
    settle(&mut win, &worker).unwrap();
    until(&mut win, &capture, false, |_, sink| sink.adopted > 0);
    (worker, audio, capture, inject, win)
}
fn row_play<L: LaneSet<Library>>(win: &mut Win<Library, L>, id: i64) -> Target {
    let domain = win.with_model(|model| recordings(*model.version)).unwrap();
    let list = win.list(domain).unwrap();
    win.scroll_to_key(list, track_key(id)).unwrap();
    let row = win.list_item(list, track_key(id)).unwrap();
    win.role(Role::Button).within(row).one().unwrap()
}
fn prepare<L: LaneSet<Library>>(win: &mut Win<Library, L>, worker: &Worker, id: i64) {
    let target = row_play(win, id);
    win.activate(target).unwrap();
    settle(win, worker).unwrap();
    let reader = win.with_model(|model| model.playback).unwrap();
    assert_eq!(
        win.with_ready(reader, |request| {
            request.track.as_ref().unwrap().track_id.unwrap()
        })
        .unwrap(),
        Some(id)
    );
}
#[track_caller]
fn until<L: LaneSet<Library>>(
    win: &mut Win<Library, L>,
    capture: &Arc<Mutex<Capture>>,
    drain: bool,
    done: impl Fn(&Library, &Capture) -> bool,
) {
    let deadline = Instant::now() + Duration::from_secs(15);
    loop {
        win.deliver_ready(32).unwrap();
        if drain {
            capture.lock().unwrap().drain();
        }
        if win
            .with_model(|model| done(model, &capture.lock().unwrap()))
            .unwrap()
        {
            return;
        }
        if Instant::now() >= deadline {
            let status = win.with_model(|model| model.queue.audio_status()).unwrap();
            let sink = capture.lock().unwrap();
            panic!(
                "Library/audio barrier: {status:?}, streams={:?}, opened={}, drops={}, queued_samples={}, playing={}, allowed={}",
                sink.streams.iter().map(Vec::len).collect::<Vec<_>>(),
                sink.opened.len(),
                sink.drops,
                sink.queue.len(),
                sink.playing,
                sink.gate
                    .as_ref()
                    .is_some_and(|(gate, epoch)| gate.allows(*epoch))
            );
        }
        std::thread::sleep(Duration::from_millis(1));
    }
}
fn close<L: LaneSet<Library>>(win: Win<Library, L>, audio: AudioService, worker: Worker) {
    drop(win);
    assert!(audio.finish(Duration::from_secs(1)));
    worker.finish().unwrap();
}
fn expected() -> Vec<f64> {
    let wave = std::fs::read(fixture("wav")).unwrap();
    assert_eq!(&wave[36..40], b"data");
    wave[44..]
        .chunks_exact(2)
        .map(|bytes| f64::from(i16::from_le_bytes(bytes.try_into().unwrap())) / 32768.)
        .collect()
}

#[test]
fn prepared_library_play_now_runs_real_pcm_pause_seek_and_latest_queued_successor() {
    let (worker, audio, capture, inject, mut win) = owner();
    prepare(&mut win, &worker, 44);
    let reader = win.with_model(|model| model.playback).unwrap();
    win.retry(reader).unwrap();
    settle(&mut win, &worker).unwrap();
    assert!(
        capture.lock().unwrap().streams.is_empty(),
        "prepare/retry cannot play"
    );
    win.activate(
        win.role(Role::Button)
            .name("Play Καλημέρα now")
            .one()
            .unwrap(),
    )
    .unwrap();
    until(&mut win, &capture, false, |model, sink| {
        sink.opened.len() == 1 && model.queue.audio_status().unwrap().duration_ms.is_some()
    });
    let old_plan = win
        .with_model(|model| model.queue.playback().plan().unwrap().clone())
        .unwrap();
    let old_token = capture.lock().unwrap().opened[0];
    assert!(
        capture.lock().unwrap().queue.is_empty(),
        "zero output credit is respected"
    );
    assert_eq!(
        win.with_model(|model| model.queue.audio_status().unwrap().state)
            .unwrap(),
        AudioState::Opening
    );
    capture.lock().unwrap().capacity = 257;
    until(&mut win, &capture, false, |model, sink| {
        sink.queue.len() == 514 && model.queue.audio_status().unwrap().state == AudioState::Playing
    });
    assert_eq!(
        capture
            .lock()
            .unwrap()
            .queue
            .iter()
            .copied()
            .collect::<Vec<_>>(),
        expected()[..514]
    );
    win.activate(win.button("Pause")).unwrap();
    until(&mut win, &capture, false, |_, sink| !sink.playing);
    let retained = capture.lock().unwrap().queue.clone();
    capture.lock().unwrap().drain();
    assert_eq!(capture.lock().unwrap().queue, retained);
    win.activate(win.button("Back 10 seconds")).unwrap();
    until(&mut win, &capture, false, |model, sink| {
        sink.streams.len() == 2 && model.queue.audio_status().unwrap().state == AudioState::Paused
    });
    assert!(capture.lock().unwrap().queue.is_empty());
    for event in [
        Event::SourceEof {
            token: old_token,
            end: old_plan.end_of_stream(),
        },
        Event::Started { token: old_token },
        Event::Failed {
            token: old_token,
            error: AudioError::DeviceUnavailable,
        },
    ] {
        inject.try_send(event).unwrap();
    }
    win.deliver_ready(32).unwrap();
    assert_eq!(
        win.with_model(|model| model.queue.audio_status().unwrap().state)
            .unwrap(),
        AudioState::Paused
    );
    assert_eq!(
        win.with_model(|model| model.queue.playback().plan().unwrap().stamp())
            .unwrap(),
        old_plan.stamp()
    );
    win.activate(win.button("Resume")).unwrap();
    until(&mut win, &capture, false, |_, sink| sink.queue.len() == 514);
    prepare(&mut win, &worker, 90);
    win.activate(win.button("Add prepared recording 90 to queue"))
        .unwrap();
    assert_eq!(
        win.with_model(|model| {
            let plan = model.queue.playback().plan().unwrap();
            (
                plan.stamp(),
                plan.lookahead.as_ref().unwrap().track.track_id,
            )
        })
        .unwrap(),
        (old_plan.stamp(), Some(90))
    );
    // Partial/zero acceptance was checked above. Use an ordinary device-sized
    // queue for the full-song lifecycle; UI repaint speed is not its clock.
    capture.lock().unwrap().capacity = 4096;
    until(&mut win, &capture, true, |model, _| {
        model.queue.audio_status().unwrap().state == AudioState::Finished
    });
    let sink = capture.lock().unwrap();
    assert_eq!(
        sink.streams.len(),
        2,
        "compatible natural successor retains the stream"
    );
    let mut pcm = expected();
    pcm.extend(expected());
    assert_eq!(
        sink.streams[1], pcm,
        "WAV and FLAC join preserve every sample and partial tail"
    );
    assert!(sink.queue.is_empty());
    drop(sink);
    close(win, audio, worker);
}

#[test]
fn explicit_play_now_keeps_queue_and_rejects_retired_selection_occurrence_and_close_work() {
    let (worker, audio, capture, inject, mut win) = owner();
    prepare(&mut win, &worker, 44);
    win.activate(
        win.role(Role::Button)
            .name("Play Καλημέρα now")
            .one()
            .unwrap(),
    )
    .unwrap();
    until(&mut win, &capture, false, |_, sink| sink.opened.len() == 1);
    let old_token = capture.lock().unwrap().opened[0];
    let old_plan = win
        .with_model(|model| model.queue.playback().plan().unwrap().clone())
        .unwrap();
    prepare(&mut win, &worker, 90);
    assert_eq!(
        capture.lock().unwrap().streams.len(),
        1,
        "preparation must not restart active audio"
    );
    win.activate(
        win.role(Role::Button)
            .name("Play Untitled now")
            .one()
            .unwrap(),
    )
    .unwrap();
    until(&mut win, &capture, false, |_, sink| sink.opened.len() == 2);
    let current = win
        .with_model(|model| {
            let playback = model.queue.playback();
            assert_eq!(playback.queue().len(), 2);
            assert_eq!(playback.queue().at(0).unwrap().track.track_id, Some(44));
            assert_eq!(playback.plan().unwrap().current.track.track_id, Some(90));
            playback.plan().unwrap().stamp()
        })
        .unwrap();
    assert_ne!(current, old_plan.stamp());
    for event in [
        Event::SourceEof {
            token: old_token,
            end: old_plan.end_of_stream(),
        },
        Event::Started { token: old_token },
        Event::Failed {
            token: old_token,
            error: AudioError::DeviceUnavailable,
        },
    ] {
        inject.try_send(event).unwrap();
    }
    win.deliver_ready(32).unwrap();
    assert_eq!(
        win.with_model(|model| model.queue.playback().plan().unwrap().stamp())
            .unwrap(),
        current
    );
    assert_eq!(
        win.with_model(|model| model.queue.audio_status().unwrap().state)
            .unwrap(),
        AudioState::Opening
    );

    let retained = win
        .role(Role::Button)
        .name("Play Untitled now")
        .one()
        .unwrap();
    let select = row_play(&mut win, 44);
    win.activate(select).unwrap();
    worker
        .checkpoint()
        .unwrap()
        .recv_timeout(Duration::from_secs(5))
        .unwrap();
    win.activate(retained).unwrap();
    assert!(
        win.contains_text("This prepared recording is no longer the current selection")
            .unwrap()
    );
    assert_eq!(
        win.with_model(|model| model.queue.playback().queue().len())
            .unwrap(),
        2
    );
    assert_eq!(capture.lock().unwrap().streams.len(), 2);
    settle(&mut win, &worker).unwrap();
    capture.lock().unwrap().capacity = 257;
    until(&mut win, &capture, false, |_, sink| sink.queue.len() == 514);
    win.activate(win.button("Stop")).unwrap();
    capture.lock().unwrap().drain();
    assert!(
        capture.lock().unwrap().streams.iter().all(Vec::is_empty),
        "Stop revokes consumption immediately"
    );
    until(&mut win, &capture, false, |model, sink| {
        sink.drops == 2 && model.queue.audio_status().unwrap().state == AudioState::Stopped
    });
    capture.lock().unwrap().capacity = 0;
    win.activate(
        win.role(Role::Button)
            .name("Play Καλημέρα now")
            .one()
            .unwrap(),
    )
    .unwrap();
    until(&mut win, &capture, false, |_, sink| sink.opened.len() == 3);
    let reader = win.with_model(|model| model.playback).unwrap();
    win.retry(reader).unwrap();
    let handle = audio.handle();
    close(win, audio, worker);
    assert!(matches!(handle.set_playing(true), Err(AudioError::Closed)));
    let sink = capture.lock().unwrap();
    assert_eq!(sink.drops, 3);
    assert!(sink.queue.is_empty());
    assert!(sink.streams.iter().all(Vec::is_empty));
}

#[test]
fn source_replacement_rejects_prepared_play_and_old_row_then_plays_revalidated_path() {
    let (worker, audio, capture, _, mut win) = owner();
    prepare(&mut win, &worker, 44);
    let old_play = win
        .role(Role::Button)
        .name("Play Καλημέρα now")
        .one()
        .unwrap();
    let old_row = row_play(&mut win, 44);
    let replacement = database();
    replacement
        .connection()
        .execute(
            "UPDATE track SET location = ?1 WHERE id = 90",
            [fixture("mp3").to_str().unwrap()],
        )
        .unwrap();
    replacement
        .connection()
        .execute(
            "UPDATE track SET location = ?1 WHERE id = 44",
            [fixture("flac").to_str().unwrap()],
        )
        .unwrap();
    worker
        .replace_database(replacement)
        .unwrap()
        .recv_timeout(Duration::from_secs(5))
        .unwrap()
        .unwrap();
    win.deliver_ready(1).unwrap();
    assert_eq!(win.with_model(|model| model.version.generation).unwrap(), 1);
    win.activate(old_play).unwrap();
    assert!(
        win.contains_text("This prepared recording belongs to the previous library source")
            .unwrap()
    );
    assert_eq!(
        win.with_model(|model| model.queue.playback().queue().len())
            .unwrap(),
        0
    );
    assert!(capture.lock().unwrap().streams.is_empty());
    settle(&mut win, &worker).unwrap();
    assert_eq!(win.activate(old_row), Err(Error::StaleTarget));
    prepare(&mut win, &worker, 44);
    let reader = win.with_model(|model| model.playback).unwrap();
    assert_eq!(
        win.with_ready(reader, |request| request
            .track
            .as_ref()
            .unwrap()
            .path
            .clone())
            .unwrap(),
        Some(fixture("flac"))
    );
    capture.lock().unwrap().capacity = 4096;
    win.activate(
        win.role(Role::Button)
            .name("Play Καλημέρα now")
            .one()
            .unwrap(),
    )
    .unwrap();
    until(&mut win, &capture, true, |model, _| {
        model.queue.audio_status().unwrap().state == AudioState::Finished
    });
    assert_eq!(capture.lock().unwrap().streams[0], expected());
    close(win, audio, worker);
}
