#![cfg(feature = "audio")]
//! Complete Library/Sources -> SQLite worker -> queue -> real audio service.
use gpui::{Error, LaneSet, Remote, Role, Target, Win, WindowOptions};
use hummingbird_gpui_port::{
    app::{Library, PreparationStatus, connect, track_key},
    audio::{
        AudioError, AudioService, Event, Format, Token,
        output::{OutputProvider, OutputStream, PlaybackGate},
    },
    database::Database,
    queue_view::AudioState,
    transcript::settle,
    worker::{Selection, Worker},
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
    owner_with(database())
}
fn owner_with(database: Database) -> Owners<impl LaneSet<Library>> {
    let (worker, inbox) = Worker::new(database).unwrap();
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
    .with_inbox_status(inbox, Library::receive)
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
fn row_prepare<L: LaneSet<Library>>(win: &mut Win<Library, L>, id: i64) -> Target {
    let domain = win.with_model(|model| model.recording_list()).unwrap();
    let list = win.list(domain).unwrap();
    win.scroll_to_key(list, track_key(id)).unwrap();
    let row = win.list_item(list, track_key(id)).unwrap();
    win.role(Role::Button)
        .text("Prepare")
        .within(row)
        .one()
        .unwrap()
}
fn prepare<L: LaneSet<Library>>(win: &mut Win<Library, L>, worker: &Worker, id: i64) {
    let target = row_prepare(win, id);
    win.activate(target).unwrap();
    settle(win, worker).unwrap();
    assert_eq!(
        win.with_model(|model| model.prepared().map(|(_, track)| track.track_id.unwrap()))
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
        .as_chunks::<2>()
        .0
        .iter()
        .map(|&bytes| f64::from(i16::from_le_bytes(bytes)) / 32768.)
        .collect()
}

#[test]
fn library_row_play_now_runs_real_pcm_pause_seek_and_latest_queued_successor() {
    let (worker, audio, capture, inject, mut win) = owner();
    prepare(&mut win, &worker, 44);
    let reader = win.with_model(|model| model.results).unwrap();
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
    let old_selection = win.with_model(|model| *model.selected).unwrap();
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

    // Commands alone cannot mint an owner continuation. Duplicate current
    // and late prior preparation replies must not append another occurrence.
    let current_selection = win.with_model(|model| *model.selected).unwrap();
    for selection in [old_selection, current_selection] {
        worker.handle().prepare_and_play(selection).unwrap();
        worker
            .checkpoint()
            .unwrap()
            .recv_timeout(Duration::from_secs(5))
            .unwrap();
        settle(&mut win, &worker).unwrap();
    }
    assert_eq!(
        win.with_model(|model| model.queue.playback().queue().len())
            .unwrap(),
        2
    );
    assert_eq!(capture.lock().unwrap().streams.len(), 2);

    // Finish the real Play-now query, leave its result buffered, and select a
    // different pure preparation before the owner consumes that old reply.
    row_prepare(&mut win, 44);
    win.activate(
        win.role(Role::Button)
            .name("Play Καλημέρα now")
            .one()
            .unwrap(),
    )
    .unwrap();
    worker
        .checkpoint()
        .unwrap()
        .recv_timeout(Duration::from_secs(5))
        .unwrap();
    let prepare_other = row_prepare(&mut win, 90);
    win.activate(prepare_other).unwrap();
    settle(&mut win, &worker).unwrap();
    assert_eq!(
        win.with_model(|model| model.queue.playback().queue().len())
            .unwrap(),
        2
    );
    assert_eq!(capture.lock().unwrap().streams.len(), 2);
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
    row_prepare(&mut win, 90);
    win.activate(
        win.role(Role::Button)
            .name("Play Untitled now")
            .one()
            .unwrap(),
    )
    .unwrap();
    assert_eq!(
        win.with_model(|model| model.preparation_status()).unwrap(),
        PreparationStatus::Pending
    );
    let handle = audio.handle();
    close(win, audio, worker);
    assert!(matches!(handle.set_playing(true), Err(AudioError::Closed)));
    let sink = capture.lock().unwrap();
    assert_eq!(sink.drops, 3);
    assert!(sink.queue.is_empty());
    assert!(sink.streams.iter().all(Vec::is_empty));
}

#[test]
fn source_replacement_rejects_old_row_then_one_click_plays_revalidated_path() {
    let (worker, audio, capture, _, mut win) = owner();
    prepare(&mut win, &worker, 44);
    let old_play = win
        .role(Role::Button)
        .name("Play Καλημέρα now")
        .one()
        .unwrap();
    let old_row = row_prepare(&mut win, 44);
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
        win.contains_text("This recording belongs to the previous library source")
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
    row_prepare(&mut win, 44);
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
    assert_eq!(
        win.with_model(|model| model.prepared().unwrap().1.path.clone())
            .unwrap(),
        fixture("flac")
    );
    assert_eq!(capture.lock().unwrap().streams[0], expected());
    close(win, audio, worker);
}

#[test]
fn cloned_handle_stop_revokes_buffered_play_without_editing_the_owner_queue() {
    let (worker, audio, capture, _, mut win) = owner();
    row_prepare(&mut win, 44);
    win.activate(
        win.role(Role::Button)
            .name("Play Καλημέρα now")
            .one()
            .unwrap(),
    )
    .unwrap();
    worker
        .checkpoint()
        .unwrap()
        .recv_timeout(Duration::from_secs(5))
        .unwrap();
    assert_eq!(
        win.with_model(Library::preparation_status).unwrap(),
        PreparationStatus::Pending
    );
    // The real worker result is buffered. No Adopted event has updated the UI
    // receipt when the separately owned public clone wins authoritative Stop.
    let stopped = audio.handle().clone().stop().unwrap();
    assert!(stopped.token.is_none());
    settle(&mut win, &worker).unwrap();
    assert_eq!(
        win.with_model(|model| model.queue.playback().queue().len())
            .unwrap(),
        0,
        "retired preparation mutated the queue after cloned Stop"
    );
    assert_eq!(
        win.with_model(Library::preparation_status).unwrap(),
        PreparationStatus::Canceled
    );
    assert!(capture.lock().unwrap().streams.is_empty());
    close(win, audio, worker);
}

#[test]
fn cloned_pause_seek_and_stop_revoke_pending_replacement_and_later_explicit_play_can_win() {
    for control in ["pause", "seek", "stop"] {
        let (worker, audio, capture, _, mut win) = owner();
        row_prepare(&mut win, 44);
        win.activate(
            win.role(Role::Button)
                .name("Play Καλημέρα now")
                .one()
                .unwrap(),
        )
        .unwrap();
        settle(&mut win, &worker).unwrap();
        until(&mut win, &capture, false, |_, sink| !sink.opened.is_empty());
        let original = win
            .with_model(|model| model.queue.playback().plan().unwrap().stamp())
            .unwrap();
        row_prepare(&mut win, 90);
        win.activate(
            win.role(Role::Button)
                .name("Play Untitled now")
                .one()
                .unwrap(),
        )
        .unwrap();
        worker
            .checkpoint()
            .unwrap()
            .recv_timeout(Duration::from_secs(5))
            .unwrap();
        let handle = audio.handle().clone();
        let receipt = match control {
            "pause" => handle.set_playing(false),
            "seek" => handle.seek(0),
            "stop" => handle.stop(),
            _ => unreachable!(),
        }
        .unwrap();
        settle(&mut win, &worker).unwrap();
        assert_eq!(
            win.with_model(|model| model.queue.playback().queue().len())
                .unwrap(),
            1,
            "{control}"
        );
        assert_eq!(
            win.with_model(|model| model.queue.playback().plan().unwrap().stamp())
                .unwrap(),
            original
        );
        assert_eq!(
            win.with_model(Library::preparation_status).unwrap(),
            PreparationStatus::Canceled
        );
        assert_eq!(handle.receipt().unwrap().revision, receipt.revision);
        // A new user click captures authoritative authority rather than the
        // cached UI receipt, so controls do not permanently disable playback.
        win.activate(
            win.role(Role::Button)
                .name("Play Untitled now")
                .one()
                .unwrap(),
        )
        .unwrap();
        settle(&mut win, &worker).unwrap();
        assert_eq!(
            win.with_model(|model| model.queue.playback().queue().len())
                .unwrap(),
            2
        );
        assert_eq!(
            win.with_model(|model| model
                .queue
                .playback()
                .plan()
                .unwrap()
                .current
                .track
                .track_id)
                .unwrap(),
            Some(90)
        );
        assert!(handle.receipt().unwrap().revision > receipt.revision);
        close(win, audio, worker);
    }
}

#[test]
fn unavailable_play_error_leaves_current_queue_plan_and_audio_authority_unchanged() {
    let (worker, audio, capture, _, mut win) = owner();
    row_prepare(&mut win, 44);
    win.activate(
        win.role(Role::Button)
            .name("Play Καλημέρα now")
            .one()
            .unwrap(),
    )
    .unwrap();
    settle(&mut win, &worker).unwrap();
    until(&mut win, &capture, false, |_, sink| !sink.opened.is_empty());
    let plan = win
        .with_model(|model| model.queue.playback().plan().unwrap().stamp())
        .unwrap();
    let receipt = audio.handle().receipt().unwrap();
    row_prepare(&mut win, 1);
    win.activate(
        win.role(Role::Button)
            .name("Play Album Track now")
            .one()
            .unwrap(),
    )
    .unwrap();
    settle(&mut win, &worker).unwrap();
    assert_eq!(
        win.with_model(Library::preparation_status).unwrap(),
        PreparationStatus::Failed
    );
    assert!(win.contains_text("queue rejected: Unavailable").unwrap());
    assert_eq!(
        win.with_model(|model| model.queue.playback().queue().len())
            .unwrap(),
        1
    );
    assert_eq!(
        win.with_model(|model| model.queue.playback().plan().unwrap().stamp())
            .unwrap(),
        plan
    );
    assert_eq!(audio.handle().receipt().unwrap().revision, receipt.revision);
    assert_eq!(audio.handle().receipt().unwrap().token, receipt.token);
    close(win, audio, worker);
}

fn held_transport_owner() -> (Owners<impl LaneSet<Library>>, Arc<Mutex<Vec<Event>>>) {
    let (worker, inbox) = Worker::new(database()).unwrap();
    let (mut model, questions) = connect(worker.handle()).unwrap();
    let capture = Arc::new(Mutex::new(Capture {
        capacity: 4096,
        ..Default::default()
    }));
    let (audio, audio_inbox) = AudioService::with_output(Provider(capture.clone())).unwrap();
    model.queue.attach_audio(audio.handle()).unwrap();
    let held = Arc::new(Mutex::new(Vec::new()));
    let buffered = held.clone();
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
    .with_inbox_status(inbox, Library::receive)
    .unwrap()
    .with_inbox(audio_inbox, move |model: &mut Library, event: Event| {
        if let Event::Opened { token, .. } = &event {
            observed.lock().unwrap().opened.push(*token);
        }
        match event {
            Event::Adopted { .. } | Event::SourceEof { .. } | Event::Seeked { .. } => {
                buffered.lock().unwrap().push(event);
            }
            event => model.receive_audio(event),
        }
    })
    .unwrap()
    .with_inbox(injected, Library::receive_audio)
    .unwrap();
    settle(&mut win, &worker).unwrap();
    for id in [44, 90] {
        prepare(&mut win, &worker, id);
        win.activate(win.button(&format!("Add prepared recording {id} to queue")))
            .unwrap();
    }
    // The real decoder reaches EOF; only its owner delivery is withheld.
    // Zero new credits later prevent Seek from generating a second EOF.
    until(&mut win, &capture, true, |_, _| {
        held.lock()
            .unwrap()
            .iter()
            .any(|event| matches!(event, Event::SourceEof { .. }))
    });
    capture.lock().unwrap().capacity = 0;
    ((worker, audio, capture, inject, win), held)
}

fn take_adopted<L: LaneSet<Library>>(
    win: &mut Win<Library, L>,
    capture: &Arc<Mutex<Capture>>,
    held: &Arc<Mutex<Vec<Event>>>,
    revision: u64,
) -> Event {
    until(win, capture, false, |_, _| {
        held.lock().unwrap().iter().any(
            |event| matches!(event, Event::Adopted { revision: actual, .. } if *actual == revision),
        )
    });
    let mut events = held.lock().unwrap();
    let index = events
        .iter()
        .position(
            |event| matches!(event, Event::Adopted { revision: actual, .. } if *actual == revision),
        )
        .unwrap();
    events.remove(index)
}

fn assert_retired_eof(control: &str, adopted_first: bool) {
    let ((worker, audio, capture, inject, mut win), held) = held_transport_owner();
    let original = win
        .with_model(|model| model.queue.playback().plan().unwrap().clone())
        .unwrap();
    assert_eq!(original.current.track.track_id, Some(44));
    assert_eq!(
        original.lookahead.as_ref().unwrap().track.track_id,
        Some(90)
    );
    let old = audio.handle().receipt().unwrap();
    let token = old.token.unwrap();
    assert_eq!(token.stamp, original.stamp());
    let latest = match control {
        "seek" => audio.handle().clone().seek(0),
        "stop" => audio.handle().clone().stop(),
        _ => unreachable!(),
    }
    .unwrap();
    let mut adopted = Some(take_adopted(&mut win, &capture, &held, latest.revision));
    if adopted_first {
        inject.try_send(adopted.take().unwrap()).unwrap();
        win.deliver_ready(32).unwrap();
    }
    inject
        .try_send(Event::SourceEof {
            token,
            end: original.end_of_stream(),
        })
        .unwrap();
    win.deliver_ready(32).unwrap();
    assert_eq!(
        win.with_model(|model| model.queue.playback().plan().unwrap().stamp())
            .unwrap(),
        original.stamp(),
        "retired {control} EOF edited the queue, adopted_first={adopted_first}"
    );
    assert_eq!(
        win.with_model(|model| model.queue.playback().plan().unwrap().current.key)
            .unwrap(),
        original.current.key
    );
    assert_eq!(audio.handle().receipt().unwrap().revision, latest.revision);
    assert_eq!(audio.handle().receipt().unwrap().token, latest.token);
    if !adopted_first {
        inject.try_send(adopted.take().unwrap()).unwrap();
        win.deliver_ready(32).unwrap();
    }
    let expected = if control == "stop" {
        AudioState::Stopped
    } else {
        AudioState::Opening
    };
    assert_eq!(
        win.with_model(|model| model.queue.audio_status().unwrap().state)
            .unwrap(),
        expected
    );
    inject
        .try_send(Event::Adopted {
            revision: old.revision,
            token: old.token,
            playing: true,
        })
        .unwrap();
    win.deliver_ready(32).unwrap();
    assert_eq!(
        win.with_model(|model| model.queue.audio_status().unwrap().state)
            .unwrap(),
        expected
    );
    close(win, audio, worker);
}

#[test]
fn cloned_seek_before_adopted_rejects_retired_eof_without_queue_edit() {
    assert_retired_eof("seek", false);
}
#[test]
fn cloned_seek_after_adopted_rejects_retired_eof_without_queue_edit() {
    assert_retired_eof("seek", true);
}
#[test]
fn cloned_stop_before_adopted_rejects_retired_eof_without_queue_edit() {
    assert_retired_eof("stop", false);
}
#[test]
fn cloned_stop_after_adopted_rejects_retired_eof_without_queue_edit() {
    assert_retired_eof("stop", true);
}

#[test]
fn cloned_transport_adoption_updates_status_and_accepts_only_new_token_position() {
    let ((worker, audio, capture, inject, mut win), held) = held_transport_owner();
    let original = audio.handle().receipt().unwrap();
    let paused = audio.handle().clone().set_playing(false).unwrap();
    inject
        .try_send(take_adopted(&mut win, &capture, &held, paused.revision))
        .unwrap();
    win.deliver_ready(32).unwrap();
    assert_eq!(
        win.with_model(|model| model.queue.audio_status().unwrap().state)
            .unwrap(),
        AudioState::Paused
    );
    let playing = audio.handle().clone().set_playing(true).unwrap();
    inject
        .try_send(take_adopted(&mut win, &capture, &held, playing.revision))
        .unwrap();
    win.deliver_ready(32).unwrap();
    assert_eq!(
        win.with_model(|model| model.queue.audio_status().unwrap().state)
            .unwrap(),
        AudioState::Playing
    );
    let sought = audio.handle().clone().seek(0).unwrap();
    inject
        .try_send(take_adopted(&mut win, &capture, &held, sought.revision))
        .unwrap();
    inject
        .try_send(Event::Position {
            token: sought.token.unwrap(),
            milliseconds: 1234,
        })
        .unwrap();
    inject
        .try_send(Event::Position {
            token: original.token.unwrap(),
            milliseconds: 9876,
        })
        .unwrap();
    inject
        .try_send(Event::Adopted {
            revision: paused.revision,
            token: paused.token,
            playing: false,
        })
        .unwrap();
    win.deliver_ready(32).unwrap();
    let status = win
        .with_model(|model| model.queue.audio_status().unwrap())
        .unwrap();
    assert_eq!(status.state, AudioState::Opening);
    assert_eq!(status.position_ms, 1234);
    let stopped = audio.handle().clone().stop().unwrap();
    inject
        .try_send(take_adopted(&mut win, &capture, &held, stopped.revision))
        .unwrap();
    win.deliver_ready(32).unwrap();
    assert_eq!(
        win.with_model(|model| model.queue.audio_status().unwrap().state)
            .unwrap(),
        AudioState::Stopped
    );
    close(win, audio, worker);
}

#[test]
fn paused_same_token_eof_advances_once_without_resuming_output() {
    for adopted_first in [false, true] {
        let ((worker, audio, capture, inject, mut win), held) = held_transport_owner();
        let original = win
            .with_model(|model| model.queue.playback().plan().unwrap().clone())
            .unwrap();
        let old = audio.handle().receipt().unwrap();
        let paused = audio.handle().clone().set_playing(false).unwrap();
        assert_eq!(paused.token, old.token);
        let mut adopted = Some(take_adopted(&mut win, &capture, &held, paused.revision));
        if adopted_first {
            inject.try_send(adopted.take().unwrap()).unwrap();
            win.deliver_ready(32).unwrap();
        }
        inject
            .try_send(Event::SourceEof {
                token: old.token.unwrap(),
                end: original.end_of_stream(),
            })
            .unwrap();
        win.deliver_ready(32).unwrap();
        let advanced = win
            .with_model(|model| model.queue.playback().plan().unwrap().clone())
            .unwrap();
        assert_eq!(
            advanced.current.track.track_id,
            Some(90),
            "same-token pause stranded EOF"
        );
        assert_ne!(advanced.stamp(), original.stamp());
        assert_eq!(
            win.with_model(|model| model.queue.audio_status().unwrap().state)
                .unwrap(),
            AudioState::Paused
        );
        if !adopted_first {
            inject.try_send(adopted.take().unwrap()).unwrap();
        }
        inject
            .try_send(Event::SourceEof {
                token: old.token.unwrap(),
                end: original.end_of_stream(),
            })
            .unwrap();
        win.deliver_ready(32).unwrap();
        assert_eq!(
            win.with_model(|model| model.queue.playback().plan().unwrap().stamp())
                .unwrap(),
            advanced.stamp()
        );
        assert_eq!(
            win.with_model(|model| model.queue.audio_status().unwrap().state)
                .unwrap(),
            AudioState::Paused
        );
        assert!(!capture.lock().unwrap().playing);
        close(win, audio, worker);
    }
}

#[test]
fn stop_on_empty_queue_and_active_pause_seek_revoke_play_before_result_consumption() {
    for control in ["Stop", "Pause", "Back 10 seconds"] {
        let (worker, audio, capture, _, mut win) = owner();
        let active = control != "Stop";
        let stamp = if active {
            row_prepare(&mut win, 44);
            win.activate(
                win.role(Role::Button)
                    .name("Play Καλημέρα now")
                    .one()
                    .unwrap(),
            )
            .unwrap();
            until(&mut win, &capture, false, |_, sink| sink.opened.len() == 1);
            Some(
                win.with_model(|model| model.queue.playback().plan().unwrap().stamp())
                    .unwrap(),
            )
        } else {
            None
        };
        row_prepare(&mut win, 90);
        win.activate(
            win.role(Role::Button)
                .name("Play Untitled now")
                .one()
                .unwrap(),
        )
        .unwrap();
        worker
            .checkpoint()
            .unwrap()
            .recv_timeout(Duration::from_secs(10))
            .unwrap();
        assert_eq!(
            win.with_model(|model| model.preparation_status()).unwrap(),
            PreparationStatus::Pending
        );
        let revision = win
            .with_model(|model| model.queue.audio_revision().unwrap())
            .unwrap();
        let adopted = capture.lock().unwrap().adopted;
        win.activate(win.button(control)).unwrap();
        assert!(
            win.with_model(|model| model.queue.audio_revision().unwrap())
                .unwrap()
                > revision
        );
        assert_eq!(
            win.with_model(|model| model.preparation_status()).unwrap(),
            PreparationStatus::Canceled
        );
        settle(&mut win, &worker).unwrap();
        until(&mut win, &capture, false, |_, sink| sink.adopted > adopted);
        assert_eq!(
            win.with_model(|model| model.queue.playback().queue().len())
                .unwrap(),
            usize::from(active)
        );
        assert!(win.with_model(|model| model.prepared().is_none()).unwrap());
        if let Some(stamp) = stamp {
            assert!(
                capture
                    .lock()
                    .unwrap()
                    .opened
                    .iter()
                    .all(|token| token.stamp == stamp)
            );
        } else {
            assert!(capture.lock().unwrap().opened.is_empty());
        }
        assert!(capture.lock().unwrap().streams.iter().all(Vec::is_empty));
        close(win, audio, worker);
    }
}
#[test]
fn audio_feature_without_attached_output_rejects_play_now_and_still_allows_pure_prepare() {
    let (worker, inbox) = Worker::new(database()).unwrap();
    let (model, questions) = connect(worker.handle()).unwrap();
    let mut win = Win::with_questions(
        model,
        questions,
        WindowOptions {
            size: [720, 1100],
            ..Default::default()
        },
    )
    .unwrap()
    .with_inbox_status(inbox, Library::receive)
    .unwrap();
    settle(&mut win, &worker).unwrap();
    row_prepare(&mut win, 44);
    win.activate(
        win.role(Role::Button)
            .name("Play Καλημέρα now")
            .one()
            .unwrap(),
    )
    .unwrap();
    assert!(win.contains_text("Audio output is not attached").unwrap());
    assert_eq!(
        win.with_model(|model| model.preparation_status()).unwrap(),
        PreparationStatus::Empty
    );
    assert!(
        win.with_model(|model| model.queue.playback().queue().is_empty())
            .unwrap()
    );
    prepare(&mut win, &worker, 44);
    assert!(
        win.with_model(|model| model.queue.playback().queue().is_empty())
            .unwrap()
    );
    drop(win);
    worker.finish().unwrap();
}

#[test]
fn public_prepare_and_play_command_cannot_turn_a_pure_owner_prepare_into_playback() {
    let (worker, audio, capture, _, mut win) = owner();
    let selection = hummingbird_gpui_port::worker::Selection {
        id: Some(44),
        sequence: 1,
        generation: 0,
    };
    worker.handle().prepare_and_play(selection).unwrap();
    worker
        .checkpoint()
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap();
    win.update(|model| model.prepare(44, 0)).unwrap();
    settle(&mut win, &worker).unwrap();
    assert_eq!(win.with_model(|model| *model.selected).unwrap(), selection);
    assert_eq!(
        win.with_model(|model| model.prepared().unwrap().1.track_id)
            .unwrap(),
        Some(44)
    );
    assert!(
        win.with_model(|model| model.queue.playback().queue().is_empty())
            .unwrap()
    );
    assert!(capture.lock().unwrap().streams.is_empty());
    close(win, audio, worker);
}

fn playlist<L: LaneSet<Library>>(
    win: &mut Win<Library, L>,
    worker: &Worker,
) -> triomphe::Arc<hummingbird_gpui_port::browser::Input> {
    win.update(|model| model.navigate(hummingbird_gpui_port::browser::Route::Playlist(2)))
        .unwrap();
    settle(win, worker).unwrap();
    let reader = win.with_model(|model| model.results).unwrap();
    win.with_ready(reader, |page| page.input().clone())
        .unwrap()
        .unwrap()
}
#[test]
fn context_play_replaces_full_sql_order_at_selected_occurrence_once_and_obeys_output_credits() {
    use hummingbird_gpui_port::browser::{PlayRequest, RowKey};
    let (worker, audio, capture, _, mut win) = owner_with(Database::collection_fixture().unwrap());
    let input = playlist(&mut win, &worker);
    assert!(capture.lock().unwrap().opened.is_empty());
    win.activate(
        win.role(Role::Button)
            .name("Prepare Καλημέρα")
            .one()
            .unwrap(),
    )
    .unwrap();
    settle(&mut win, &worker).unwrap();
    assert!(capture.lock().unwrap().opened.is_empty());
    let key = RowKey::PlaylistItem {
        item: 701,
        track: 90,
    };
    win.activate(
        win.role(Role::Button)
            .name("Play from Untitled")
            .one()
            .unwrap(),
    )
    .unwrap();
    let sequence = win.with_model(|model| model.selected.sequence).unwrap();
    worker
        .handle()
        .prepare_listing(PlayRequest {
            listing: hummingbird_gpui_port::browser::Listing::Sql(input.clone()),
            start: Some(key),
            sequence,
        })
        .unwrap();
    settle(&mut win, &worker).unwrap();
    until(&mut win, &capture, false, |_, sink| sink.opened.len() == 1);
    let plan = win
        .with_model(|model| model.queue.playback().plan().unwrap().clone())
        .unwrap();
    assert_eq!(plan.current.track.track_id, Some(90));
    assert_eq!(plan.lookahead.as_ref().unwrap().track.track_id, Some(11));
    assert_eq!(
        win.with_model(|model| (0..model.queue.playback().queue().len())
            .map(|i| model
                .queue
                .playback()
                .queue()
                .at(i)
                .unwrap()
                .track
                .track_id
                .unwrap())
            .collect::<Vec<_>>())
            .unwrap(),
        [44, 90, 11]
    );
    assert_eq!(
        win.with_model(|model| model.queue.playback().plan().unwrap().stamp())
            .unwrap(),
        plan.stamp()
    );
    assert!(capture.lock().unwrap().queue.is_empty());
    capture.lock().unwrap().capacity = 64;
    until(&mut win, &capture, false, |_, sink| sink.queue.len() == 128);
    assert_eq!(capture.lock().unwrap().queue.len(), 128);
    win.activate(win.button("Stop")).unwrap();
    until(&mut win, &capture, false, |_, sink| sink.drops == 1);
    close(win, audio, worker);
}
#[test]
fn context_results_reject_route_filter_selection_source_and_cloned_transport_changes_before_queue_mutation()
 {
    use hummingbird_gpui_port::browser::{Browser, Route};
    for control in [
        "route",
        "filter",
        "sort",
        "refresh",
        "selection",
        "source",
        "import",
        "stop",
        "pause",
        "seek",
    ] {
        let (worker, audio, capture, _, mut win) =
            owner_with(Database::collection_fixture().unwrap());
        playlist(&mut win, &worker);
        win.activate(
            win.role(Role::Button)
                .name("Play all Evening Καφέ")
                .one()
                .unwrap(),
        )
        .unwrap();
        settle(&mut win, &worker).unwrap();
        until(&mut win, &capture, false, |_, sink| sink.opened.len() == 1);
        let stamp = win
            .with_model(|model| model.queue.playback().plan().unwrap().stamp())
            .unwrap();
        win.activate(
            win.role(Role::Button)
                .name("Play from Untitled")
                .one()
                .unwrap(),
        )
        .unwrap();
        worker
            .checkpoint()
            .unwrap()
            .recv_timeout(Duration::from_secs(10))
            .unwrap();
        match control {
            "route" => {
                win.update(|model| {
                    model.navigate(Route::Tracks);
                    model.navigate(Route::Playlist(2));
                })
                .unwrap();
            }
            "filter" => {
                win.set(Library::BROWSER.source(&Browser::QUERY), "μαρ".into())
                    .unwrap();
                win.set(Library::BROWSER.source(&Browser::QUERY), String::new())
                    .unwrap();
            }
            "sort" => {
                win.set(
                    Library::BROWSER.source(&Browser::SORT),
                    hummingbird_gpui_port::search::Sort::Longest,
                )
                .unwrap();
                win.set(
                    Library::BROWSER.source(&Browser::SORT),
                    hummingbird_gpui_port::search::Sort::Title,
                )
                .unwrap();
            }
            "refresh" => {
                win.activate(win.button("Refresh")).unwrap();
            }
            "import" => {
                worker
                    .prepend_fixture_track()
                    .unwrap()
                    .recv_timeout(Duration::from_secs(10))
                    .unwrap()
                    .unwrap();
            }
            "selection" => {
                let mut selected = *win.read(Library::SELECTED).unwrap();
                selected.id = Some(11);
                win.set(Library::SELECTED, selected).unwrap();
            }
            "source" => {
                worker
                    .replace_database(Database::collection_fixture().unwrap())
                    .unwrap()
                    .recv_timeout(Duration::from_secs(10))
                    .unwrap()
                    .unwrap();
            }
            "stop" => {
                audio.handle().clone().stop().unwrap();
            }
            "pause" => {
                audio.handle().clone().set_playing(false).unwrap();
            }
            "seek" => {
                audio.handle().clone().seek(0).unwrap();
            }
            _ => unreachable!(),
        }
        settle(&mut win, &worker).unwrap();
        assert_eq!(
            win.with_model(|model| model.queue.playback().plan().unwrap().stamp())
                .unwrap(),
            stamp,
            "{control} edited queue"
        );
        assert_eq!(
            win.with_model(|model| model.queue.playback().queue().len())
                .unwrap(),
            3
        );
        assert_ne!(
            win.with_model(|model| model.preparation_status()).unwrap(),
            PreparationStatus::Pending
        );
        if control == "seek" {
            until(&mut win, &capture, false, |_, sink| sink.opened.len() == 2);
        }
        assert_eq!(
            capture.lock().unwrap().opened.len(),
            if control == "seek" { 2 } else { 1 },
            "{control} output opens"
        );
        close(win, audio, worker);
    }
}

#[test]
fn published_source_replace_rejects_buffered_named_play_before_owner_notification() {
    let (worker, audio, capture, _, mut win) = owner();
    row_prepare(&mut win, 44);
    win.activate(
        win.role(Role::Button)
            .name("Play Καλημέρα now")
            .one()
            .unwrap(),
    )
    .unwrap();
    worker
        .checkpoint()
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap();
    let replacement = worker
        .replace_database(database())
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap()
        .unwrap();
    worker
        .checkpoint()
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap();
    assert_eq!(replacement.generation, 1);
    assert_eq!(win.with_model(|model| model.version.generation).unwrap(), 0);
    settle(&mut win, &worker).unwrap();
    assert_eq!(
        win.with_model(|model| model.queue.playback().queue().len())
            .unwrap(),
        0,
        "buffered old-source preparation edited queue after replacement acknowledgement"
    );
    assert!(capture.lock().unwrap().opened.is_empty());
    close(win, audio, worker);
}

#[test]
fn published_source_replace_rejects_visible_prepared_enqueue_before_owner_notification() {
    let (worker, audio, capture, _, mut win) = owner();
    let prepare = row_prepare(&mut win, 44);
    win.activate(prepare).unwrap();
    worker
        .checkpoint()
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap();
    worker
        .replace_database(database())
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap()
        .unwrap();
    win.deliver_ready(1).unwrap();
    assert!(win.with_model(|model| model.prepared().is_some()).unwrap());
    assert_eq!(win.with_model(|model| model.version.generation).unwrap(), 0);
    win.activate(win.button("Add prepared recording 44 to queue"))
        .unwrap();
    assert_eq!(
        win.with_model(|model| model.queue.playback().queue().len())
            .unwrap(),
        0,
        "visible old-source prepared action edited queue after replacement acknowledgement"
    );
    assert!(capture.lock().unwrap().opened.is_empty());
    close(win, audio, worker);
}

#[test]
fn source_import_keeps_buffered_existing_named_play_authorized_but_finish_retires_it() {
    for finish in [false, true] {
        let (worker, audio, capture, _, mut win) = owner();
        row_prepare(&mut win, 44);
        win.activate(
            win.role(Role::Button)
                .name("Play Καλημέρα now")
                .one()
                .unwrap(),
        )
        .unwrap();
        worker
            .checkpoint()
            .unwrap()
            .recv_timeout(Duration::from_secs(10))
            .unwrap();
        if finish {
            worker.finish().unwrap();
            win.deliver_ready(32).unwrap();
            assert!(
                win.with_model(|model| model.queue.playback().queue().is_empty())
                    .unwrap()
            );
            assert!(capture.lock().unwrap().opened.is_empty());
            drop(win);
            assert!(audio.finish(Duration::from_secs(2)));
        } else {
            worker
                .prepend_fixture_track()
                .unwrap()
                .recv_timeout(Duration::from_secs(10))
                .unwrap()
                .unwrap();
            settle(&mut win, &worker).unwrap();
            until(&mut win, &capture, false, |_, sink| sink.opened.len() == 1);
            assert_eq!(
                win.with_model(|model| model
                    .queue
                    .playback()
                    .plan()
                    .unwrap()
                    .current
                    .track
                    .track_id)
                    .unwrap(),
                Some(44)
            );
            close(win, audio, worker);
        }
    }
}

#[test]
fn context_play_rejects_prequeued_public_wrong_occurrence_input_sequence_and_pure_prepare_replies()
{
    use hummingbird_gpui_port::browser::{PlayRequest, RowKey};
    for collision in ["occurrence", "input", "sequence", "pure"] {
        let (worker, audio, capture, _, mut win) =
            owner_with(Database::collection_fixture().unwrap());
        let input = playlist(&mut win, &worker);
        if collision == "pure" {
            worker
                .handle()
                .prepare(Selection {
                    id: Some(90),
                    generation: 0,
                    sequence: 1,
                })
                .unwrap();
        } else {
            let mut wrong = PlayRequest {
                listing: hummingbird_gpui_port::browser::Listing::Sql(input),
                start: Some(RowKey::PlaylistItem {
                    item: 701,
                    track: 90,
                }),
                sequence: 1,
            };
            match collision {
                "occurrence" => {
                    wrong.start = Some(RowKey::PlaylistItem {
                        item: 703,
                        track: 11,
                    })
                }
                "input" => {
                    let mut input = (**wrong.input()).clone();
                    input.search.sort = hummingbird_gpui_port::search::Sort::Longest;
                    wrong.listing =
                        hummingbird_gpui_port::browser::Listing::Sql(triomphe::Arc::new(input));
                }
                "sequence" => wrong.sequence = 2,
                _ => unreachable!(),
            }
            worker.handle().prepare_listing(wrong).unwrap();
        }
        worker
            .checkpoint()
            .unwrap()
            .recv_timeout(Duration::from_secs(10))
            .unwrap();
        win.activate(
            win.role(Role::Button)
                .name("Play from Untitled")
                .one()
                .unwrap(),
        )
        .unwrap();
        worker
            .checkpoint()
            .unwrap()
            .recv_timeout(Duration::from_secs(10))
            .unwrap();
        win.deliver_ready(1).unwrap();
        assert!(
            win.with_model(|model| model.queue.playback().queue().is_empty())
                .unwrap(),
            "{collision} consumed the intent"
        );
        assert_eq!(
            win.with_model(Library::preparation_status).unwrap(),
            PreparationStatus::Pending
        );
        settle(&mut win, &worker).unwrap();
        until(&mut win, &capture, false, |_, sink| sink.opened.len() == 1);
        assert_eq!(
            win.with_model(|model| model
                .queue
                .playback()
                .plan()
                .unwrap()
                .current
                .track
                .track_id)
                .unwrap(),
            Some(90)
        );
        assert_eq!(
            win.with_model(|model| model.queue.playback().queue().len())
                .unwrap(),
            3
        );
        close(win, audio, worker);
    }
}

#[test]
fn worker_finish_retires_buffered_context_intent_before_terminal_notification() {
    let (worker, audio, capture, _, mut win) = owner_with(Database::collection_fixture().unwrap());
    playlist(&mut win, &worker);
    win.activate(
        win.role(Role::Button)
            .name("Play all Evening Καφέ")
            .one()
            .unwrap(),
    )
    .unwrap();
    worker
        .checkpoint()
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap();
    worker.finish().unwrap();
    win.deliver_ready(32).unwrap();
    assert!(
        win.with_model(|model| model.queue.playback().queue().is_empty())
            .unwrap()
    );
    assert!(capture.lock().unwrap().opened.is_empty());
    assert_eq!(
        win.with_model(Library::preparation_status).unwrap(),
        PreparationStatus::Failed
    );
    assert!(win.contains_text("Library worker closed").unwrap());
    drop(win);
    assert!(audio.finish(Duration::from_secs(2)));
}

#[test]
fn context_prepare_missing_selected_path_does_not_replace_queue_or_open_output() {
    let database = Database::collection_fixture().unwrap();
    database
        .connection()
        .execute(
            "UPDATE track SET location='/missing/context-selected.wav' WHERE id=90",
            [],
        )
        .unwrap();
    let (worker, audio, capture, _, mut win) = owner_with(database);
    playlist(&mut win, &worker);
    win.activate(
        win.role(Role::Button)
            .name("Play from Untitled")
            .one()
            .unwrap(),
    )
    .unwrap();
    settle(&mut win, &worker).unwrap();
    assert_eq!(
        win.with_model(Library::preparation_status).unwrap(),
        PreparationStatus::Failed
    );
    assert!(
        win.with_model(|model| model.queue.playback().queue().is_empty())
            .unwrap()
    );
    assert!(capture.lock().unwrap().opened.is_empty());
    assert!(
        win.contains_text("Recording 90 is no longer available")
            .unwrap()
    );
    close(win, audio, worker);
}

#[path = "support/mod.rs"]
mod index_support;
fn acquisition<L: LaneSet<Library>>(win: &mut Win<Library, L>, worker: &Worker) {
    let deadline = Instant::now() + Duration::from_secs(15);
    while win.with_model(Library::indexing_request).unwrap().is_some() {
        assert!(Instant::now() < deadline, "indexing completion missing");
        worker
            .checkpoint()
            .unwrap()
            .recv_timeout(Duration::from_secs(10))
            .unwrap();
        win.deliver_ready(32).unwrap();
        std::thread::yield_now();
    }
    settle(win, worker).unwrap();
}
fn acquire_fixture<L: LaneSet<Library>>(win: &mut Win<Library, L>, worker: &Worker, root: &Path) {
    win.update(|model| {
        model.request_index(hummingbird_gpui_port::indexing::Command::AddRoot(
            root.into(),
        ))
    })
    .unwrap();
    acquisition(win, worker);
    win.update(|model| model.request_index(hummingbird_gpui_port::indexing::Command::Scan))
        .unwrap();
    acquisition(win, worker);
}
fn indexed_files(folder: &index_support::Folder) -> PathBuf {
    let music = folder.0.join("music");
    std::fs::create_dir(&music).unwrap();
    index_support::wave(&music.join("01.wav"), "Before", "Artist", "Album");
    index_support::flac(&music.join("02.flac"), "Second", "Artist", "Album");
    index_support::mp3(&music.join("03.mp3"), "Third", "Artist", "Album");
    music
}
#[test]
fn metadata_commit_rejects_buffered_named_sql_and_files_play_before_its_notification() {
    use hummingbird_gpui_port::{
        browser::{Page, Route},
        indexing::Command,
    };
    for mode in ["named", "sql", "files"] {
        let folder = index_support::Folder::new();
        let music = indexed_files(&folder);
        let path = folder.0.join("library.sqlite");
        let (worker, audio, capture, _inject, mut win) =
            owner_with(Database::open_library(&path).unwrap());
        acquire_fixture(&mut win, &worker, &music);
        let read = Database::open_read_only(&path).unwrap();
        let id: i64 = read
            .connection()
            .query_row("SELECT id FROM track WHERE title='Before'", [], |row| {
                row.get(0)
            })
            .unwrap();
        if mode == "files" {
            win.update(|model| model.navigate(Route::Directory(music.clone())))
                .unwrap();
            settle(&mut win, &worker).unwrap();
        }
        let results = win.with_model(|model| model.results).unwrap();
        if mode == "named" {
            win.update(|model| model.play_now(id, 0)).unwrap();
        } else if mode == "sql" {
            let input = win
                .with_ready(results, |page| page.input().clone())
                .unwrap()
                .unwrap();
            win.update(move |model| model.play_listing(input, None))
                .unwrap();
        } else {
            win.activate(win.button("Play all files")).unwrap();
        }
        // Prepared is finished and buffered first. Consume neither it nor the
        // later Indexed event until real SQL commits and authority publishes.
        worker
            .checkpoint()
            .unwrap()
            .recv_timeout(Duration::from_secs(10))
            .unwrap();
        index_support::wave(&music.join("01.wav"), "Changed", "Artist", "Album");
        win.update(|model| model.request_index(Command::Scan))
            .unwrap();
        let handle = worker.handle();
        let deadline = Instant::now() + Duration::from_secs(15);
        while handle.with_current_source(1, || ()).unwrap().is_none() {
            assert!(
                Instant::now() < deadline,
                "metadata version was not published"
            );
            worker
                .checkpoint()
                .unwrap()
                .recv_timeout(Duration::from_secs(10))
                .unwrap();
            std::thread::yield_now();
        }
        assert_eq!(win.with_model(|model| model.version.generation).unwrap(), 0);
        win.deliver_ready(1).unwrap();
        assert_eq!(
            win.with_model(|model| model.queue.playback().queue().len())
                .unwrap(),
            0,
            "{mode}"
        );
        assert!(
            win.with_model(|model| model.queue.playback().plan().is_none())
                .unwrap()
        );
        assert!(capture.lock().unwrap().streams.is_empty(), "{mode}");
        acquisition(&mut win, &worker);
        assert_eq!(win.with_model(|model| model.version.generation).unwrap(), 1);
        // A new explicit Files action uses the new database title/IDs and the
        // existing real audio service. Navigation/scanning never opened it.
        win.update(|model| model.navigate(Route::Directory(music.clone())))
            .unwrap();
        settle(&mut win, &worker).unwrap();
        let entries = win
            .with_ready(results, |page| match page {
                Page::Files(files) => files.recording_count(),
                _ => panic!("Files page"),
            })
            .unwrap();
        assert_eq!(entries, Some(3));
        win.activate(win.button("Play all files")).unwrap();
        settle(&mut win, &worker).unwrap();
        until(&mut win, &capture, false, |_, state| {
            state.opened.len() == 1
        });
        assert!(capture.lock().unwrap().queue.is_empty());
        let plan = win
            .with_model(|model| model.queue.playback().plan().unwrap().clone())
            .unwrap();
        assert_eq!(plan.current.track.track_id, Some(id));
        assert_eq!(plan.current.track.title, "Changed");
        capture.lock().unwrap().capacity = 64;
        until(&mut win, &capture, false, |_, state| {
            state.queue.len() == 128
        });
        assert_eq!(
            capture
                .lock()
                .unwrap()
                .queue
                .iter()
                .copied()
                .collect::<Vec<_>>(),
            expected()[..128]
        );
        audio.handle().stop().unwrap();
        drop(read);
        close(win, audio, worker);
    }
}
#[test]
fn cloned_stop_revokes_a_buffered_files_intent_without_editing_the_queue() {
    use hummingbird_gpui_port::browser::Route;
    let folder = index_support::Folder::new();
    let music = indexed_files(&folder);
    let (worker, audio, capture, _inject, mut win) =
        owner_with(Database::open_library(&folder.0.join("library.sqlite")).unwrap());
    acquire_fixture(&mut win, &worker, &music);
    win.update(|model| model.navigate(Route::Directory(music.clone())))
        .unwrap();
    settle(&mut win, &worker).unwrap();
    win.activate(win.button("Play all files")).unwrap();
    worker
        .checkpoint()
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap();
    let clone = audio.handle();
    clone.stop().unwrap();
    settle(&mut win, &worker).unwrap();
    assert_eq!(
        win.with_model(|model| model.queue.playback().queue().len())
            .unwrap(),
        0
    );
    assert_eq!(
        win.with_model(Library::preparation_status).unwrap(),
        PreparationStatus::Canceled
    );
    assert!(capture.lock().unwrap().streams.is_empty());
    close(win, audio, worker);
}
