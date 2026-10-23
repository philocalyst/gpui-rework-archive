#![cfg(feature = "audio")]
#[path = "support/audio_clock.rs"]
mod clocked;
use gpui::{ListId, Role, Win};
use hummingbird_gpui_port::{
    audio::{
        AudioError, AudioService, Format,
        output::{OutputProvider, OutputStream, PlaybackGate},
    },
    queue::{Track, TrackRef},
    queue_view::{AudioState, QueueScreen},
};
use std::{
    collections::VecDeque,
    path::{Path, PathBuf},
    sync::{Arc, Mutex},
    time::{Duration, Instant},
};

#[derive(Default)]
struct Capture {
    queue: VecDeque<f64>,
    samples: Vec<f64>,
    playing: bool,
    opens: usize,
    drops: usize,
    output_fault: bool,
}
struct Provider {
    capture: Arc<Mutex<Capture>>,
    frames: usize,
    rate: Option<u32>,
    channels: Option<u16>,
}
struct Sink {
    capture: Arc<Mutex<Capture>>,
    frames: usize,
    format: Format,
    gate: PlaybackGate,
    epoch: u64,
}
impl OutputProvider for Provider {
    type Stream = Sink;
    fn open(&mut self, source: Format, gate: PlaybackGate, epoch: u64) -> Result<Sink, AudioError> {
        let mut capture = self.capture.lock().unwrap();
        capture.opens += 1;
        capture.queue.clear();
        capture.samples.clear();
        drop(capture);
        Ok(Sink {
            capture: self.capture.clone(),
            frames: self.frames,
            format: Format {
                rate: self.rate.unwrap_or(source.rate),
                channels: self.channels.unwrap_or(source.channels),
            },
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
        let count =
            (self.frames * channels - capture.queue.len()).min(samples.len()) / channels * channels;
        capture.queue.extend(samples[..count].iter().copied());
        Ok(count / channels)
    }
    fn queued_frames(&self) -> usize {
        self.capture.lock().unwrap().queue.len() / self.format.channels as usize
    }
    fn set_playing(&mut self, playing: bool) -> Result<(), AudioError> {
        self.capture.lock().unwrap().playing = playing;
        Ok(())
    }
    fn poll(&mut self) -> Result<(), AudioError> {
        if self.capture.lock().unwrap().output_fault {
            Err(AudioError::Output("injected device loss".into()))
        } else {
            Ok(())
        }
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
fn drain(capture: &Arc<Mutex<Capture>>) {
    let mut capture = capture.lock().unwrap();
    if capture.playing {
        while let Some(sample) = capture.queue.pop_front() {
            capture.samples.push(sample);
        }
    }
}
fn track(path: &Path, title: &str) -> TrackRef {
    TrackRef::new(Track {
        path: path.into(),
        title: title.into(),
        track_id: None,
        album_id: None,
        available_when_prepared: true,
    })
}
fn fixture(extension: &str) -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR")).join(format!("assets/audio/fixture.{extension}"))
}
type AudioWin = Win<
    QueueScreen,
    gpui::Lane<
        hummingbird_gpui_port::audio::Event,
        fn(&mut QueueScreen, hummingbird_gpui_port::audio::Event),
        (),
    >,
>;

fn owner(
    tracks: Vec<TrackRef>,
    frames: usize,
    rate: Option<u32>,
) -> (AudioService, Arc<Mutex<Capture>>, AudioWin) {
    owner_format(tracks, frames, rate, None)
}
fn owner_format(
    tracks: Vec<TrackRef>,
    frames: usize,
    rate: Option<u32>,
    channels: Option<u16>,
) -> (AudioService, Arc<Mutex<Capture>>, AudioWin) {
    let capture = Arc::new(Mutex::new(Capture::default()));
    let (service, inbox) = AudioService::with_output(Provider {
        capture: capture.clone(),
        frames,
        rate,
        channels,
    })
    .unwrap();
    let mut screen = QueueScreen::new(ListId::new(5000)).unwrap();
    screen.enqueue_many(tracks);
    screen.attach_audio(service.handle()).unwrap();
    let win = Win::with_size(screen, 720, 700)
        .unwrap()
        .with_inbox(
            inbox,
            QueueScreen::receive_audio as fn(&mut QueueScreen, hummingbird_gpui_port::audio::Event),
        )
        .unwrap();
    (service, capture, win)
}
fn until<L: gpui::LaneSet<QueueScreen>>(
    win: &mut Win<QueueScreen, L>,
    capture: &Arc<Mutex<Capture>>,
    pump: bool,
    predicate: impl Fn(&QueueScreen) -> bool,
) {
    let deadline = Instant::now() + Duration::from_secs(5);
    loop {
        win.deliver_ready(32).unwrap();
        if win.with_model(&predicate).unwrap() {
            return;
        }
        assert!(
            Instant::now() < deadline,
            "audio did not reach its expected public state: {:?}",
            win.with_model(QueueScreen::audio_status).unwrap()
        );
        if pump {
            drain(capture);
        }
        std::thread::sleep(Duration::from_millis(1));
    }
}
fn finish<L: gpui::LaneSet<QueueScreen>>(service: AudioService, win: Win<QueueScreen, L>) {
    drop(win);
    assert!(service.finish(Duration::from_secs(1)));
}

#[test]
fn pinned_codecs_reach_real_public_play_and_drain_with_exact_pcm() {
    for extension in ["wav", "flac", "mp3"] {
        let (service, capture, mut win) =
            owner(vec![track(&fixture(extension), extension)], 32, None);
        let play = win
            .role(Role::Button)
            .name(&format!("Play {extension}"))
            .one()
            .unwrap();
        win.activate(play).unwrap();
        until(&mut win, &capture, true, |model| {
            model.audio_status().unwrap().state == AudioState::Finished
        });
        let observed = capture.lock().unwrap();
        assert_eq!(observed.samples.len(), 1200, "{extension}");
        assert!(
            observed.samples.iter().all(|sample| sample.abs() < 1e-12),
            "{extension}"
        );
        assert!(observed.queue.is_empty());
        drop(observed);
        finish(service, win);
    }
}
#[test]
fn source_eof_is_not_application_output_drain() {
    let (service, capture, mut win) = owner(vec![track(&fixture("wav"), "stalled")], 2048, None);
    until(&mut win, &capture, false, |model| {
        model.playback().plan().is_none()
    });
    assert_eq!(
        win.with_model(|model| model.audio_status().unwrap().state)
            .unwrap(),
        AudioState::Draining
    );
    for _ in 0..20 {
        win.deliver_ready(32).unwrap();
        std::thread::sleep(Duration::from_millis(1));
    }
    assert_eq!(capture.lock().unwrap().queue.len(), 1200);
    assert_ne!(
        win.with_model(|model| model.audio_status().unwrap().state)
            .unwrap(),
        AudioState::Finished
    );
    until(&mut win, &capture, true, |model| {
        model.audio_status().unwrap().state == AudioState::Finished
    });
    assert_eq!(capture.lock().unwrap().samples.len(), 1200);
    finish(service, win);
}
struct Wave(PathBuf);
impl Wave {
    fn new(rate: u32, samples: impl Iterator<Item = i16>) -> Self {
        Self::pcm(rate, 1, 1, 16, samples.flat_map(i16::to_le_bytes).collect())
    }
    fn pcm(rate: u32, channels: u16, codec: u16, bits: u16, samples: Vec<u8>) -> Self {
        let bytes = samples.len() as u32;
        let alignment = channels * bits / 8;
        let mut data = Vec::new();
        data.extend_from_slice(b"RIFF");
        data.extend_from_slice(&(bytes + bytes % 2 + 36).to_le_bytes());
        data.extend_from_slice(b"WAVEfmt ");
        data.extend_from_slice(&16u32.to_le_bytes());
        data.extend_from_slice(&codec.to_le_bytes());
        data.extend_from_slice(&channels.to_le_bytes());
        data.extend_from_slice(&rate.to_le_bytes());
        data.extend_from_slice(&(rate * u32::from(alignment)).to_le_bytes());
        data.extend_from_slice(&alignment.to_le_bytes());
        data.extend_from_slice(&bits.to_le_bytes());
        data.extend_from_slice(b"data");
        data.extend_from_slice(&bytes.to_le_bytes());
        data.extend(samples);
        if !bytes.is_multiple_of(2) {
            data.push(0);
        }
        let path = std::env::temp_dir().join(format!(
            "hummingbird-audio-{}-{}.wav",
            std::process::id(),
            fastrand::u64(..)
        ));
        std::fs::write(&path, data).unwrap();
        Self(path)
    }
}
impl Drop for Wave {
    fn drop(&mut self) {
        let _ = std::fs::remove_file(&self.0);
    }
}
#[test]
fn latest_equal_stamp_lookahead_controls_the_real_next_source() {
    let first = Wave::new(8000, std::iter::repeat_n(4000, 8000));
    let removed = Wave::new(8000, std::iter::repeat_n(-6000, 240));
    let next = Wave::new(8000, std::iter::repeat_n(12000, 400));
    let (service, capture, mut win) = owner(
        vec![
            track(&first.0, "first"),
            track(&removed.0, "removed"),
            track(&next.0, "next"),
        ],
        32,
        None,
    );
    until(&mut win, &capture, false, |model| {
        model.audio_status().unwrap().state == AudioState::Playing
    });
    let stamp = win
        .with_model(|model| model.playback().plan().unwrap().stamp())
        .unwrap();
    win.activate(win.role(Role::CheckBox).name("removed").one().unwrap())
        .unwrap();
    win.activate(win.button("Remove selected")).unwrap();
    assert_eq!(
        win.with_model(|model| model.playback().plan().unwrap().stamp())
            .unwrap(),
        stamp
    );
    until(&mut win, &capture, true, |model| {
        model.audio_status().unwrap().state == AudioState::Finished
    });
    let capture = capture.lock().unwrap();
    assert_eq!(capture.opens, 1);
    assert_eq!(capture.samples.len(), 8400);
    assert!(
        capture.samples[..8000]
            .iter()
            .all(|sample| *sample == 4000. / 32768.)
    );
    assert!(
        capture.samples[8000..]
            .iter()
            .all(|sample| *sample == 12000. / 32768.)
    );
    drop(capture);
    finish(service, win);
}
#[test]
fn paused_seek_and_stop_follow_public_controls() {
    let source = Wave::new(
        8000,
        (0..100_000).map(|index| (index % 30001 - 15000) as i16),
    );
    let (service, capture, mut win) = owner(vec![track(&source.0, "seek")], 32, None);
    until(&mut win, &capture, false, |model| {
        model.audio_status().unwrap().state == AudioState::Playing
    });
    win.activate(win.button("Pause")).unwrap();
    win.activate(win.button("Forward 10 seconds")).unwrap();
    until(&mut win, &capture, false, |model| {
        model.audio_status().unwrap().state == AudioState::Paused
            && model.audio_status().unwrap().position_ms >= 10_000
    });
    let seek_position = win
        .with_model(|model| model.audio_status().unwrap().position_ms)
        .unwrap();
    assert!(capture.lock().unwrap().queue.is_empty());
    win.activate(win.button("Resume")).unwrap();
    until(&mut win, &capture, false, |_| {
        !capture.lock().unwrap().queue.is_empty()
    });
    assert_eq!(
        *capture.lock().unwrap().queue.front().unwrap(),
        ((seek_position * 8 % 30001) as i32 - 15000) as f64 / 32768.
    );
    win.activate(win.button("Stop")).unwrap();
    assert!(
        win.with_model(|model| model.playback().plan().is_none())
            .unwrap()
    );
    assert_eq!(
        win.with_model(|model| model.audio_status().unwrap().state)
            .unwrap(),
        AudioState::Stopped
    );
    finish(service, win);
}

#[test]
fn nonzero_stereo_wav_flac_and_mp3_preserve_samples_channels_and_partial_tail() {
    let base = Path::new(env!("CARGO_MANIFEST_DIR")).join("assets/audio");
    // Canonical WAV emitted by tools/audio-fixtures.py has a 44-byte PCM header.
    let wav = std::fs::read(base.join("stereo.wav")).unwrap();
    assert_eq!(&wav[36..40], b"data");
    let expected: Vec<f64> = wav[44..]
        .chunks_exact(2)
        .map(|bytes| i16::from_le_bytes(bytes.try_into().unwrap()) as f64 / 32768.)
        .collect();
    assert_eq!(expected.len(), 17239 * 2);
    for extension in ["wav", "flac", "mp3"] {
        let (service, capture, mut win) = owner(
            vec![track(&base.join(format!("stereo.{extension}")), extension)],
            257,
            None,
        );
        until(&mut win, &capture, true, |model| {
            model.audio_status().unwrap().state == AudioState::Finished
        });
        let observed = capture.lock().unwrap();
        assert_eq!(
            observed.samples.len(),
            expected.len(),
            "{extension} final partial block"
        );
        if extension != "mp3" {
            assert_eq!(observed.samples, expected, "{extension} exact lossless PCM");
        } else {
            for channel in 0..2 {
                let mse = observed
                    .samples
                    .iter()
                    .skip(channel)
                    .step_by(2)
                    .zip(expected.iter().skip(channel).step_by(2))
                    .map(|(actual, expected)| (actual - expected).powi(2))
                    .sum::<f64>()
                    / 17239.;
                let swapped = observed
                    .samples
                    .iter()
                    .skip(channel)
                    .step_by(2)
                    .zip(expected.iter().skip(1 - channel).step_by(2))
                    .map(|(actual, expected)| (actual - expected).powi(2))
                    .sum::<f64>()
                    / 17239.;
                assert!(
                    mse.sqrt() < 0.015,
                    "MP3 channel {channel} RMSE {}",
                    mse.sqrt()
                );
                assert!(mse * 20. < swapped, "MP3 channel identity {channel}");
                assert!(
                    observed.samples[observed.samples.len() - 512 + channel..]
                        .iter()
                        .step_by(2)
                        .map(|sample| sample.abs())
                        .sum::<f64>()
                        > 10.,
                    "MP3 nonzero tail"
                );
            }
        }
        drop(observed);
        finish(service, win);
    }
}

#[test]
fn resampled_short_and_high_rate_sources_keep_exact_tail_frame_counts() {
    use rubato::{Fft, FixedSync, Resampler};
    for (source_rate, output_rate, frames) in [
        (8000u32, 48000u32, 1usize),
        (8000, 48000, 169),
        (192000, 44100, 23017),
    ] {
        let source = Wave::new(
            source_rate,
            (0..frames).map(|i| if i % 31 < 13 { 12000 } else { -4000 }),
        );
        let (service, capture, mut win) =
            owner(vec![track(&source.0, "resampled")], 31, Some(output_rate));
        until(&mut win, &capture, true, |model| {
            model.audio_status().unwrap().state == AudioState::Finished
        });
        let delay = Fft::<f64>::new(
            source_rate as usize,
            output_rate as usize,
            (source_rate as usize).div_ceil(50),
            1,
            FixedSync::Input,
        )
        .unwrap()
        .output_delay();
        let expected =
            (frames as u64 * output_rate as u64).div_ceil(source_rate as u64) as usize + delay;
        let observed = capture.lock().unwrap();
        assert_eq!(
            observed.samples.len(),
            expected,
            "{source_rate} to {output_rate}, {frames} frames"
        );
        assert!(observed.samples.iter().all(|sample| sample.is_finite()));
        assert!(
            observed.samples.iter().any(|sample| sample.abs() > 0.01),
            "nonzero signal lost"
        );
        drop(observed);
        finish(service, win);
    }
}

#[test]
fn bad_next_source_keeps_preceding_resampled_tail_and_reports_failure() {
    let source = Wave::new(8000, (0..169).map(|i| (i * 53) as i16));
    let (service, capture, mut win) = owner(vec![track(&source.0, "good")], 31, Some(48000));
    until(&mut win, &capture, true, |model| {
        model.audio_status().unwrap().state == AudioState::Finished
    });
    let expected = capture.lock().unwrap().samples.clone();
    finish(service, win);
    let missing = source.0.with_extension("missing");
    let (service, capture, mut win) = owner(
        vec![track(&source.0, "good"), track(&missing, "missing")],
        31,
        Some(48000),
    );
    until(&mut win, &capture, true, |model| {
        model.audio_status().unwrap().state == AudioState::Failed
    });
    until(&mut win, &capture, true, |_| {
        capture.lock().unwrap().samples.len() == expected.len()
    });
    let observed = capture.lock().unwrap();
    assert_eq!(
        observed.samples, expected,
        "failure must preserve every preceding tail sample"
    );
    assert_eq!(observed.opens, 1);
    drop(observed);
    assert_eq!(
        win.with_model(|model| model.audio_status().unwrap().state)
            .unwrap(),
        AudioState::Failed
    );
    finish(service, win);
}

#[test]
fn paused_device_failure_closes_output_and_explicit_replay_can_reopen() {
    let source = Wave::new(8000, (0..100_000).map(|i| (i / 100) as i16));
    let (service, capture, mut win) = owner(vec![track(&source.0, "device")], 31, None);
    until(&mut win, &capture, false, |model| {
        model.audio_status().unwrap().state == AudioState::Playing
    });
    win.activate(win.button("Pause")).unwrap();
    capture.lock().unwrap().output_fault = true;
    until(&mut win, &capture, false, |model| {
        model.audio_status().unwrap().state == AudioState::Failed
    });
    assert!(capture.lock().unwrap().queue.is_empty());
    assert_eq!(capture.lock().unwrap().drops, 1);
    capture.lock().unwrap().output_fault = false;
    win.activate(win.role(Role::Button).name("Play device").one().unwrap())
        .unwrap();
    until(&mut win, &capture, false, |model| {
        model.audio_status().unwrap().state == AudioState::Playing
    });
    assert_eq!(capture.lock().unwrap().opens, 2);
    win.activate(win.button("Stop")).unwrap();
    until(&mut win, &capture, false, |_| {
        capture.lock().unwrap().drops == 2
    });
    assert!(capture.lock().unwrap().queue.is_empty());
    finish(service, win);
}

#[test]
fn old_seek_eof_failure_and_started_events_cannot_revive_stopped_or_new_audio() {
    use hummingbird_gpui_port::audio::{Event, Transition};
    let source = Wave::new(8000, (0..100_000).map(|i| (i / 1000) as i16));
    let (service, capture, win) = owner(vec![track(&source.0, "stale")], 31, None);
    let old_plan = win
        .with_model(|model| model.playback().plan().unwrap().clone())
        .unwrap();
    let old_token = service
        .handle()
        .apply(Some(&old_plan), Transition::Replace)
        .unwrap()
        .token
        .unwrap();
    let (inject, inbox) = gpui::Remote::bounded(8);
    let mut win = win
        .with_inbox(
            inbox,
            QueueScreen::receive_audio as fn(&mut QueueScreen, Event),
        )
        .unwrap();
    until(&mut win, &capture, false, |model| {
        model.audio_status().unwrap().state == AudioState::Playing
    });
    win.activate(win.button("Pause")).unwrap();
    win.activate(win.button("Forward 10 seconds")).unwrap();
    until(&mut win, &capture, false, |model| {
        model.audio_status().unwrap().state == AudioState::Paused
            && model.audio_status().unwrap().position_ms >= 10_000
    });
    let seek_position = win
        .with_model(|model| model.audio_status().unwrap().position_ms)
        .unwrap();
    for event in [
        Event::SourceEof {
            token: old_token,
            end: old_plan.end_of_stream(),
        },
        Event::Failed {
            token: old_token,
            error: AudioError::DeviceUnavailable,
        },
        Event::Started { token: old_token },
        Event::Seeked {
            token: old_token,
            milliseconds: 0,
        },
    ] {
        inject.try_send(event).unwrap();
    }
    win.deliver_ready(32).unwrap();
    assert_eq!(
        win.with_model(|model| model.playback().plan().unwrap().stamp())
            .unwrap(),
        old_plan.stamp()
    );
    assert_eq!(
        win.with_model(|model| model.audio_status().unwrap().position_ms)
            .unwrap(),
        seek_position
    );
    assert_eq!(
        win.with_model(|model| model.audio_status().unwrap().state)
            .unwrap(),
        AudioState::Paused
    );
    win.activate(win.button("Stop")).unwrap();
    inject
        .try_send(Event::Started { token: old_token })
        .unwrap();
    inject
        .try_send(Event::SourceEof {
            token: old_token,
            end: old_plan.end_of_stream(),
        })
        .unwrap();
    win.deliver_ready(32).unwrap();
    assert!(
        win.with_model(|model| model.playback().plan().is_none())
            .unwrap()
    );
    assert_eq!(
        win.with_model(|model| model.audio_status().unwrap().state)
            .unwrap(),
        AudioState::Stopped
    );
    finish(service, win);
}

#[test]
fn concrete_stream_can_be_non_send_and_is_opened_and_dropped_on_control_owner() {
    use std::{
        marker::PhantomData,
        thread::{self, ThreadId},
    };
    type Calls = Arc<Mutex<Vec<(&'static str, ThreadId)>>>;
    struct AffineProvider(Calls);
    struct AffineStream {
        calls: Calls,
        format: Format,
        _not_send: PhantomData<*mut ()>,
    }
    impl OutputProvider for AffineProvider {
        type Stream = AffineStream;
        fn open(
            &mut self,
            format: Format,
            _: PlaybackGate,
            _: u64,
        ) -> Result<AffineStream, AudioError> {
            self.0
                .lock()
                .unwrap()
                .push(("open", thread::current().id()));
            Ok(AffineStream {
                calls: self.0.clone(),
                format,
                _not_send: PhantomData,
            })
        }
    }
    impl OutputStream for AffineStream {
        fn format(&self) -> Format {
            self.format
        }
        fn submit(&mut self, input: &[f64]) -> Result<usize, AudioError> {
            Ok(input.len() / self.format.channels as usize)
        }
        fn queued_frames(&self) -> usize {
            0
        }
        fn set_playing(&mut self, _: bool) -> Result<(), AudioError> {
            Ok(())
        }
    }
    impl Drop for AffineStream {
        fn drop(&mut self) {
            self.calls
                .lock()
                .unwrap()
                .push(("drop", thread::current().id()));
        }
    }
    let calls = Arc::new(Mutex::new(Vec::new()));
    let (service, inbox) = AudioService::with_output(AffineProvider(calls.clone())).unwrap();
    let mut model = QueueScreen::new(ListId::new(6000)).unwrap();
    model.enqueue(track(&fixture("wav"), "affine"));
    model.attach_audio(service.handle()).unwrap();
    let mut win = Win::with_size(model, 720, 700)
        .unwrap()
        .with_inbox(
            inbox,
            QueueScreen::receive_audio as fn(&mut QueueScreen, hummingbird_gpui_port::audio::Event),
        )
        .unwrap();
    let unrelated_capture = Arc::new(Mutex::new(Capture::default()));
    until(&mut win, &unrelated_capture, false, |model| {
        model.audio_status().unwrap().state == AudioState::Finished
    });
    finish(service, win);
    let calls = calls.lock().unwrap();
    assert_eq!(calls.len(), 2);
    assert_eq!(calls[0].0, "open");
    assert_eq!(calls[1].0, "drop");
    assert_eq!(calls[0].1, calls[1].1);
    assert_ne!(calls[0].1, thread::current().id());
}

#[test]
fn cold_service_does_not_open_output_and_explicit_close_finishes_owner() {
    let capture = Arc::new(Mutex::new(Capture::default()));
    let (service, inbox) = AudioService::with_output(Provider {
        capture: capture.clone(),
        frames: 31,
        rate: None,
        channels: None,
    })
    .unwrap();
    // No Plan, stream, device or PCM queue is admitted by service construction.
    drop(inbox);
    assert!(service.finish(Duration::MAX));
    assert_eq!(capture.lock().unwrap().opens, 0);
    assert_eq!(capture.lock().unwrap().drops, 0);
}

#[test]
fn real_pcm_decoder_preserves_unsigned_8_signed_24_32_and_float_precision() {
    let integers: Vec<i32> = (0..514)
        .map(|i| {
            [
                i32::MIN,
                i32::MIN + 1,
                -16777217,
                -8388609,
                -32769,
                -1,
                0,
                1,
                32769,
                8388609,
                16777217,
                i32::MAX - 1,
                i32::MAX,
            ][i % 13]
        })
        .collect();
    let pcm24: Vec<i32> = (0..514)
        .map(|i| {
            [
                -8388608, -8388607, -32769, -1, 0, 1, 32769, 8388606, 8388607,
            ][i % 9]
        })
        .collect();
    let float: Vec<f64> = (0..514)
        .map(|i| {
            [
                -1.,
                -0.75,
                -0.000000000123456789,
                0.,
                0.125,
                0.5,
                0.9999999999999,
            ][i % 7]
        })
        .collect();
    let cases = [
        (
            1,
            8,
            (0..514)
                .map(|i| [0u8, 1, 127, 128, 129, 254, 255][i % 7])
                .collect::<Vec<_>>(),
            (0..514)
                .map(|i| (f64::from([0u8, 1, 127, 128, 129, 254, 255][i % 7]) - 128.) / 128.)
                .collect::<Vec<_>>(),
        ),
        (
            1,
            24,
            pcm24
                .iter()
                .flat_map(|value| value.to_le_bytes()[..3].to_vec())
                .collect(),
            pcm24
                .iter()
                .map(|value| f64::from(*value) / 8388608.)
                .collect(),
        ),
        (
            1,
            32,
            integers
                .iter()
                .flat_map(|value| value.to_le_bytes())
                .collect(),
            integers
                .iter()
                .map(|value| f64::from(*value) / 2147483648.)
                .collect(),
        ),
        (
            3,
            32,
            float
                .iter()
                .flat_map(|value| (*value as f32).to_le_bytes())
                .collect(),
            float.iter().map(|value| f64::from(*value as f32)).collect(),
        ),
        (
            3,
            64,
            float.iter().flat_map(|value| value.to_le_bytes()).collect(),
            float,
        ),
    ];
    for (codec, bits, bytes, expected) in cases {
        let source = Wave::pcm(44100, 2, codec, bits, bytes);
        let (service, capture, mut win) = owner(vec![track(&source.0, "PCM precision")], 31, None);
        until(&mut win, &capture, true, |model| {
            model.audio_status().unwrap().state == AudioState::Finished
        });
        assert_eq!(
            capture.lock().unwrap().samples,
            expected,
            "codec {codec} bits {bits}"
        );
        finish(service, win);
    }
}

#[test]
fn natural_resampled_join_preserves_fft_history_and_rate_change_preserves_both_tails() {
    for next_rate in [8000, 11025] {
        let first_values: Vec<i16> = (0..169).map(|i| (i * 53 - 10000) as i16).collect();
        let next_values: Vec<i16> = (0..257).map(|i| (8000 - i * 31) as i16).collect();
        let first = Wave::new(8000, first_values.iter().copied());
        let next = Wave::new(next_rate, next_values.iter().copied());
        let reference = if next_rate == 8000 {
            let combined = Wave::new(8000, first_values.iter().chain(&next_values).copied());
            let (service, capture, mut win) =
                owner(vec![track(&combined.0, "combined")], 31, Some(44100));
            until(&mut win, &capture, true, |model| {
                model.audio_status().unwrap().state == AudioState::Finished
            });
            let samples = capture.lock().unwrap().samples.clone();
            finish(service, win);
            samples
        } else {
            let mut samples = Vec::new();
            for source in [&first, &next] {
                let (service, capture, mut win) =
                    owner(vec![track(&source.0, "independent")], 31, Some(44100));
                until(&mut win, &capture, true, |model| {
                    model.audio_status().unwrap().state == AudioState::Finished
                });
                samples.extend_from_slice(&capture.lock().unwrap().samples);
                finish(service, win);
            }
            samples
        };
        let (service, capture, mut win) = owner(
            vec![track(&first.0, "first"), track(&next.0, "next")],
            31,
            Some(44100),
        );
        until(&mut win, &capture, true, |model| {
            model.audio_status().unwrap().state == AudioState::Finished
        });
        assert_eq!(
            capture.lock().unwrap().opens,
            1,
            "natural advance preserves output stream"
        );
        assert_eq!(
            capture.lock().unwrap().samples,
            reference,
            "natural {next_rate} Hz successor"
        );
        finish(service, win);
    }
}

#[test]
fn hostile_float_pcm_is_rejected_before_downmix_resampler_or_output_admission() {
    for bits in [32, 64] {
        for value in [
            f64::NAN,
            f64::NEG_INFINITY,
            f64::INFINITY,
            f64::MAX,
            -f64::MAX,
            16.5,
            -16.5,
        ] {
            let bytes = if bits == 32 {
                std::iter::repeat_n(value as f32, 514)
                    .flat_map(f32::to_le_bytes)
                    .collect()
            } else {
                std::iter::repeat_n(value, 514)
                    .flat_map(f64::to_le_bytes)
                    .collect()
            };
            let source = Wave::pcm(8000, 2, 3, bits, bytes);
            let (service, capture, mut win) = owner_format(
                vec![track(&source.0, "hostile float")],
                31,
                Some(48000),
                Some(1),
            );
            until(&mut win, &capture, true, |model| {
                model.audio_status().unwrap().state == AudioState::Failed
            });
            assert!(win.contains_text("decoder: invalid float PCM").unwrap());
            assert!(
                capture.lock().unwrap().samples.is_empty(),
                "{bits}-bit {value:?} reached output"
            );
            assert!(capture.lock().unwrap().queue.is_empty());
            finish(service, win);
        }
    }
    let headroom = [16f64, 16., -2., -2., 0.25, 0.75];
    let source = Wave::pcm(
        8000,
        2,
        3,
        64,
        headroom.into_iter().flat_map(f64::to_le_bytes).collect(),
    );
    let (service, capture, mut win) =
        owner_format(vec![track(&source.0, "valid headroom")], 31, None, Some(1));
    until(&mut win, &capture, true, |model| {
        model.audio_status().unwrap().state == AudioState::Finished
    });
    assert_eq!(
        capture.lock().unwrap().samples,
        [16., -2., 0.5],
        "valid float headroom is preserved before device conversion"
    );
    finish(service, win);
}

#[test]
fn hostile_successor_preserves_only_the_preceding_valid_resampled_tail() {
    let first = Wave::new(8000, (0..169).map(|i| (i * 53 - 10000) as i16));
    let (service, capture, mut win) = owner(vec![track(&first.0, "valid")], 31, Some(48000));
    until(&mut win, &capture, true, |model| {
        model.audio_status().unwrap().state == AudioState::Finished
    });
    let expected = capture.lock().unwrap().samples.clone();
    finish(service, win);
    for bad in [f64::NAN, f64::INFINITY, f64::MAX] {
        let next = Wave::pcm(
            8000,
            1,
            3,
            64,
            std::iter::repeat_n(bad, 257)
                .flat_map(f64::to_le_bytes)
                .collect(),
        );
        let (service, capture, mut win) = owner(
            vec![track(&first.0, "valid"), track(&next.0, "invalid")],
            31,
            Some(48000),
        );
        until(&mut win, &capture, true, |model| {
            model.audio_status().unwrap().state == AudioState::Failed
        });
        until(&mut win, &capture, true, |_| {
            capture.lock().unwrap().samples.len() == expected.len()
        });
        assert_eq!(capture.lock().unwrap().samples, expected);
        assert!(
            capture
                .lock()
                .unwrap()
                .samples
                .iter()
                .all(|sample| sample.is_finite())
        );
        assert!(win.contains_text("decoder: invalid float PCM").unwrap());
        finish(service, win);
    }
}

#[test]
fn unusual_coprime_rates_fail_resource_admission_before_pcm_output() {
    for (source_rate, output_rate) in [(44101, 48000), (767999, 768000)] {
        let source = Wave::new(source_rate, (0..257).map(|i| (i * 7) as i16));
        let (service, capture, mut win) = owner(
            vec![track(&source.0, "unsupported rate pair")],
            31,
            Some(output_rate),
        );
        until(&mut win, &capture, true, |model| {
            model.audio_status().unwrap().state == AudioState::Failed
        });
        assert!(
            win.contains_text("unsupported FFT rate-pair resource limit")
                .unwrap()
        );
        assert!(capture.lock().unwrap().samples.is_empty());
        assert!(capture.lock().unwrap().queue.is_empty());
        finish(service, win);
    }
}
