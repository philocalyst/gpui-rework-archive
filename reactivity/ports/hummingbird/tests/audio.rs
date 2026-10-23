#![cfg(feature = "audio")]
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
}
struct Sink {
    capture: Arc<Mutex<Capture>>,
    frames: usize,
    format: Format,
    gate: PlaybackGate,
    epoch: u64,
}
impl OutputProvider for Provider {
    fn open(
        &mut self,
        source: Format,
        gate: PlaybackGate,
        epoch: u64,
    ) -> Result<Box<dyn OutputStream>, AudioError> {
        let mut capture = self.capture.lock().unwrap();
        capture.opens += 1;
        capture.queue.clear();
        capture.samples.clear();
        drop(capture);
        Ok(Box::new(Sink {
            capture: self.capture.clone(),
            frames: self.frames,
            format: Format {
                rate: self.rate.unwrap_or(source.rate),
                ..source
            },
            gate,
            epoch,
        }))
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
    let capture = Arc::new(Mutex::new(Capture::default()));
    let (service, inbox) = AudioService::with_output(Provider {
        capture: capture.clone(),
        frames,
        rate,
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
        let samples: Vec<i16> = samples.collect();
        let bytes = (samples.len() * 2) as u32;
        let mut data = Vec::new();
        data.extend_from_slice(b"RIFF");
        data.extend_from_slice(&(bytes + 36).to_le_bytes());
        data.extend_from_slice(b"WAVEfmt ");
        data.extend_from_slice(&16u32.to_le_bytes());
        data.extend_from_slice(&1u16.to_le_bytes());
        data.extend_from_slice(&1u16.to_le_bytes());
        data.extend_from_slice(&rate.to_le_bytes());
        data.extend_from_slice(&(rate * 2).to_le_bytes());
        data.extend_from_slice(&2u16.to_le_bytes());
        data.extend_from_slice(&16u16.to_le_bytes());
        data.extend_from_slice(b"data");
        data.extend_from_slice(&bytes.to_le_bytes());
        for sample in samples {
            data.extend_from_slice(&sample.to_le_bytes());
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
    let source = Wave::new(8000, (0..100_000).map(|index| (index / 1000) as i16));
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
    assert!(capture.lock().unwrap().queue.is_empty());
    win.activate(win.button("Resume")).unwrap();
    until(&mut win, &capture, false, |_| {
        !capture.lock().unwrap().queue.is_empty()
    });
    assert_eq!(
        *capture.lock().unwrap().queue.front().unwrap(),
        80. / 32768.
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
