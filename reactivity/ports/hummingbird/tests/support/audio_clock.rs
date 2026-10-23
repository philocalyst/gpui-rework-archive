//! Scheduled consumption at the public output seam; all other owners are real.
use super::*;

#[derive(Default)]
struct Clock {
    queue: VecDeque<f64>,
    gate: Option<(PlaybackGate, u64)>,
    playing: bool,
    accepted: usize,
    consumed: usize,
    discarded: usize,
    starved: usize,
    opens: usize,
    drops: usize,
}
impl Clock {
    fn advance(&mut self, frames: usize, channels: usize) {
        if !self.playing
            || self
                .gate
                .as_ref()
                .is_none_or(|(gate, epoch)| !gate.allows(*epoch))
        {
            return;
        }
        let available = frames.min(self.queue.len() / channels);
        self.queue.drain(..available * channels);
        self.consumed += available;
        self.starved += frames - available;
        self.check(channels);
    }
    fn check(&self, channels: usize) {
        assert_eq!(self.queue.len() % channels, 0);
        assert_eq!(
            self.accepted,
            self.consumed + self.discarded + self.queue.len() / channels
        );
    }
}
struct ScheduledProvider {
    clock: Arc<Mutex<Clock>>,
    format: Format,
}
struct ScheduledSink {
    clock: Arc<Mutex<Clock>>,
    format: Format,
    gate: PlaybackGate,
    epoch: u64,
}
impl OutputProvider for ScheduledProvider {
    type Stream = ScheduledSink;
    fn open(
        &mut self,
        _: Format,
        gate: PlaybackGate,
        epoch: u64,
    ) -> Result<Self::Stream, AudioError> {
        let mut clock = self.clock.lock().unwrap();
        assert!(clock.queue.is_empty());
        clock.opens += 1;
        clock.gate = Some((gate.clone(), epoch));
        drop(clock);
        Ok(ScheduledSink {
            clock: self.clock.clone(),
            format: self.format,
            gate,
            epoch,
        })
    }
}
impl OutputStream for ScheduledSink {
    fn format(&self) -> Format {
        self.format
    }
    fn submit(&mut self, samples: &[f64]) -> Result<usize, AudioError> {
        if !self.gate.allows(self.epoch) {
            return Ok(0);
        }
        let mut clock = self.clock.lock().unwrap();
        let channels = self.format.channels as usize;
        let capacity = self.format.rate as usize / 10;
        let frames = (capacity - clock.queue.len() / channels).min(samples.len() / channels);
        clock
            .queue
            .extend(samples[..frames * channels].iter().copied());
        clock.accepted += frames;
        clock.check(channels);
        Ok(frames)
    }
    fn queued_frames(&self) -> usize {
        self.clock.lock().unwrap().queue.len() / self.format.channels as usize
    }
    fn set_playing(&mut self, playing: bool) -> Result<(), AudioError> {
        self.clock.lock().unwrap().playing = playing;
        Ok(())
    }
}
impl Drop for ScheduledSink {
    fn drop(&mut self) {
        let mut clock = self.clock.lock().unwrap();
        clock.discarded += clock.queue.len() / self.format.channels as usize;
        clock.queue.clear();
        clock.playing = false;
        clock.drops += 1;
        clock.check(self.format.channels as usize);
    }
}
fn scheduled_owner(path: &Path, target: u32) -> (AudioService, Arc<Mutex<Clock>>, AudioWin) {
    let clock = Arc::new(Mutex::new(Clock::default()));
    let (service, inbox) = AudioService::with_output(ScheduledProvider {
        clock: clock.clone(),
        format: Format {
            rate: target,
            channels: 2,
        },
    })
    .unwrap();
    let mut screen = QueueScreen::new(ListId::new(5001)).unwrap();
    screen.enqueue_many(vec![track(path, "scheduled")]);
    screen.attach_audio(service.handle()).unwrap();
    let win = Win::with_size(screen, 720, 700)
        .unwrap()
        .with_inbox(
            inbox,
            QueueScreen::receive_audio as fn(&mut QueueScreen, hummingbird_gpui_port::audio::Event),
        )
        .unwrap();
    (service, clock, win)
}
fn wait(win: &mut AudioWin, predicate: impl Fn() -> bool) {
    let deadline = Instant::now() + Duration::from_secs(5);
    loop {
        win.deliver_ready(32).unwrap();
        if predicate() {
            return;
        }
        assert!(
            Instant::now() < deadline,
            "scheduled output did not reach its barrier"
        );
        std::thread::sleep(Duration::from_millis(1));
    }
}
fn full(win: &mut AudioWin, clock: &Arc<Mutex<Clock>>, rate: u32) {
    wait(win, || {
        clock.lock().unwrap().queue.len() == rate as usize / 10 * 2
    });
}

#[test]
#[ignore = "requires a quiet host: scheduled public service starvation qualification"]
fn scheduled_public_output_keeps_up_with_fixed_consumption_deadlines() {
    for (source_rate, target_rate) in [
        (768000, 48000),
        (768000, 96000),
        (384000, 48000),
        (48000, 44100),
        (44100, 48000),
        (11025, 44100),
    ] {
        let source = Wave::new(
            source_rate,
            (0..source_rate * 2).map(|frame| (frame % 30001) as i16 - 15000),
        );
        let (service, clock, mut win) = scheduled_owner(&source.0, target_rate);
        full(&mut win, &clock, target_rate);
        let start = Instant::now();
        // A fixed callback schedule, not a sink that drains as fast as the
        // control owner runs. Startup and its 100 ms prebuffer are excluded.
        for tick in 1..=25 {
            let deadline = start + Duration::from_millis(tick * 10);
            std::thread::sleep(deadline.saturating_duration_since(Instant::now()));
            clock.lock().unwrap().advance(target_rate as usize / 100, 2);
            win.deliver_ready(32).unwrap();
        }
        let starved = clock.lock().unwrap().starved;
        finish(service, win);
        assert_eq!(
            starved, 0,
            "{source_rate}->{target_rate}: scheduled callback frames missing"
        );
    }
}

#[test]
fn scheduled_public_pause_seek_stop_and_tail_account_for_every_accepted_frame() {
    let source_rate = 768000;
    let target_rate = 48000;
    let source = Wave::new(
        source_rate,
        (0..source_rate * 51 / 5).map(|frame| (frame % 30001) as i16 - 15000),
    );
    let (service, clock, mut win) = scheduled_owner(&source.0, target_rate);
    full(&mut win, &clock, target_rate);
    // Virtual consumption advances only after a producer-credit barrier. This
    // lifecycle control has no tight OS scheduling deadline.
    for _ in 0..3 {
        clock.lock().unwrap().advance(target_rate as usize / 50, 2);
        full(&mut win, &clock, target_rate);
    }
    win.activate(win.button("Pause")).unwrap();
    wait(&mut win, || !clock.lock().unwrap().playing);
    let retained = clock.lock().unwrap().queue.len();
    for _ in 0..10 {
        clock.lock().unwrap().advance(480, 2);
    }
    assert_eq!(clock.lock().unwrap().queue.len(), retained);
    win.activate(win.button("Forward 10 seconds")).unwrap();
    wait(&mut win, || clock.lock().unwrap().opens == 2);
    assert!(clock.lock().unwrap().queue.is_empty());
    let before = clock.lock().unwrap().accepted;
    win.activate(win.button("Resume")).unwrap();
    let deadline = Instant::now() + Duration::from_secs(5);
    loop {
        win.deliver_ready(32).unwrap();
        clock.lock().unwrap().advance(target_rate as usize / 50, 2);
        if win
            .with_model(|model| model.audio_status().unwrap().state == AudioState::Finished)
            .unwrap()
        {
            break;
        }
        assert!(
            Instant::now() < deadline,
            "scheduled seek tail did not drain"
        );
        std::thread::sleep(Duration::from_millis(1));
    }
    {
        let clock = clock.lock().unwrap();
        clock.check(2);
        assert!(clock.accepted > before);
        assert!(clock.queue.is_empty());
    }
    win.activate(win.role(Role::Button).name("Play scheduled").one().unwrap())
        .unwrap();
    full(&mut win, &clock, target_rate);
    clock.lock().unwrap().advance(target_rate as usize / 10, 2);
    win.activate(win.button("Stop")).unwrap();
    let consumed = clock.lock().unwrap().consumed;
    for _ in 0..10 {
        clock.lock().unwrap().advance(480, 2);
    }
    assert_eq!(
        clock.lock().unwrap().consumed,
        consumed,
        "stop revokes consumption immediately"
    );
    wait(&mut win, || {
        let clock = clock.lock().unwrap();
        clock.drops == clock.opens
    });
    clock.lock().unwrap().check(2);
    finish(service, win);
}
