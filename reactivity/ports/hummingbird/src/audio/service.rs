use super::{
    AudioError, Event, MediaInfo, Token,
    block::AudioBlock,
    media::{Media, Reply, Request},
    output::{Gate, OutputProvider, OutputStream, PlaybackGate},
    pipeline::Pipeline,
};
use crate::queue_playback::Plan;
use gpui::{Inbox, Remote, SendError};
use std::{
    collections::VecDeque,
    sync::{
        Arc, Mutex,
        atomic::{AtomicBool, AtomicU64, Ordering},
    },
    thread::{self, JoinHandle},
    time::{Duration, Instant},
};

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Transition {
    Replace,
    Advance { from: Token },
}
#[derive(Clone, Copy, Debug)]
pub struct Receipt {
    pub revision: u64,
    pub token: Option<Token>,
}
#[derive(Clone)]
struct Intent {
    revision: u64,
    plan: Option<Plan>,
    token: Option<Token>,
    playing: bool,
    seek: Option<u64>,
    transition: Transition,
    output_epoch: u64,
}
struct Shared {
    desired: Mutex<Intent>,
    gate: PlaybackGate,
    owner: thread::Thread,
}
#[derive(Clone)]
pub struct AudioHandle {
    shared: Arc<Shared>,
}
impl AudioHandle {
    // Call under desired's lock so control order and final gate order agree.
    fn publish_gate(&self, desired: &Intent) {
        let gate = &self.shared.gate.0;
        gate.epoch.store(desired.output_epoch, Ordering::Release);
        gate.playing.store(desired.playing, Ordering::Release);
    }
    fn change(
        &self,
        change: impl FnOnce(&mut Intent) -> Result<(), AudioError>,
    ) -> Result<Receipt, AudioError> {
        if self.shared.gate.0.closed.load(Ordering::Acquire) {
            return Err(AudioError::Closed);
        }
        let mut desired = self.shared.desired.lock().map_err(|_| AudioError::Closed)?;
        let previous = desired.revision;
        desired.revision = previous.checked_add(1).ok_or(AudioError::Exhausted)?;
        if let Err(error) = change(&mut desired) {
            desired.revision = previous;
            return Err(error);
        }
        self.publish_gate(&desired);
        let receipt = Receipt {
            revision: desired.revision,
            token: desired.token,
        };
        drop(desired);
        self.shared.owner.unpark();
        Ok(receipt)
    }
    /// Latest complete desired state; equal occurrences still refresh lookahead.
    pub fn apply(
        &self,
        plan: Option<&Plan>,
        transition: Transition,
    ) -> Result<Receipt, AudioError> {
        if plan.is_none() && transition == Transition::Replace {
            return self.stop();
        }
        self.change(|state| {
            if matches!(transition, Transition::Advance { from } if state.token != Some(from)) {
                return Err(AudioError::Unsupported("stale source-end transition"));
            }
            let equal = plan.map(Plan::stamp) == state.plan.as_ref().map(Plan::stamp);
            if !equal || plan.is_none() {
                state.seek = None;
                state.transition = transition;
                match (plan, transition) {
                    (Some(plan), _) => {
                        state.token = Some(Token {
                            stamp: plan.stamp(),
                            revision: state.revision,
                        });
                        if transition == Transition::Replace {
                            state.playing = true;
                        }
                        if transition == Transition::Replace {
                            state.output_epoch = state.revision;
                        }
                    }
                    (None, Transition::Advance { from }) => {
                        state.token = Some(from);
                    }
                    (None, Transition::Replace) => {
                        state.token = None;
                        state.playing = false;
                        state.output_epoch = 0;
                    }
                }
            }
            state.plan = plan.cloned();
            Ok(())
        })
    }
    pub fn set_playing(&self, playing: bool) -> Result<Receipt, AudioError> {
        self.change(|state| {
            state.playing = playing && state.token.is_some();
            Ok(())
        })
    }
    pub fn seek(&self, milliseconds: u64) -> Result<Receipt, AudioError> {
        self.change(|state| {
            if state.plan.is_none() {
                return Err(AudioError::Unsupported("seek without a current source"));
            }
            if let Some(token) = &mut state.token {
                token.revision = state.revision;
                state.output_epoch = state.revision;
                state.seek = Some(milliseconds);
                state.transition = Transition::Replace;
            }
            Ok(())
        })
    }
    /// Revocation remains available if the checked identity space is exhausted.
    pub fn stop(&self) -> Result<Receipt, AudioError> {
        self.shared.gate.0.playing.store(false, Ordering::Release);
        self.shared.gate.0.epoch.store(0, Ordering::Release);
        let mut desired = self.shared.desired.lock().map_err(|_| AudioError::Closed)?;
        desired.revision = desired.revision.saturating_add(1);
        desired.plan = None;
        desired.token = None;
        desired.playing = false;
        desired.seek = None;
        desired.output_epoch = 0;
        desired.transition = Transition::Replace;
        // An older control may have republished after the early revocation
        // while Stop waited for this lock. Stop must publish last here too.
        self.publish_gate(&desired);
        let receipt = Receipt {
            revision: desired.revision,
            token: None,
        };
        drop(desired);
        self.shared.owner.unpark();
        Ok(receipt)
    }
}
pub struct AudioService {
    handle: AudioHandle,
    thread: Option<JoinHandle<()>>,
}
impl AudioService {
    #[cfg(feature = "cpal-output")]
    pub fn new() -> Result<(Self, Inbox<Event>), AudioError> {
        Self::with_output(super::cpal::CpalProvider)
    }
    pub fn with_output(provider: impl OutputProvider) -> Result<(Self, Inbox<Event>), AudioError> {
        let (events, inbox) = Remote::bounded(32);
        let initial = Intent {
            revision: 0,
            plan: None,
            token: None,
            playing: false,
            seek: None,
            transition: Transition::Replace,
            output_epoch: 0,
        };
        let gate = PlaybackGate(Arc::new(Gate {
            epoch: AtomicU64::new(0),
            playing: AtomicBool::new(false),
            closed: AtomicBool::new(false),
        }));
        let desired = Arc::new(Mutex::new(None::<Arc<Shared>>));
        let start = desired.clone();
        let thread = thread::Builder::new()
            .name("hummingbird-audio".into())
            .spawn(move || {
                // A one-time rendezvous publishes the control owner without a UI join.
                let shared = loop {
                    if let Some(shared) = start.lock().unwrap().clone() {
                        break shared;
                    }
                    thread::park();
                };
                match Media::new() {
                    Ok(media) => Owner::new(shared, provider, media, events).run(),
                    Err(error) => {
                        shared.gate.0.closed.store(true, Ordering::Release);
                        if let Some(token) = shared.desired.lock().unwrap().token {
                            let _ = events.try_send(Event::Failed { token, error });
                        }
                    }
                }
            })
            .map_err(|error| AudioError::Io(error.kind()))?;
        let shared = Arc::new(Shared {
            desired: Mutex::new(initial),
            gate,
            owner: thread.thread().clone(),
        });
        *desired.lock().unwrap() = Some(shared.clone());
        thread.thread().unpark();
        Ok((
            Self {
                handle: AudioHandle { shared },
                thread: Some(thread),
            },
            inbox,
        ))
    }
    pub fn handle(&self) -> AudioHandle {
        self.handle.clone()
    }
    /// Intended after the window closes. Never waits for an unfinished worker.
    pub fn finish(mut self, timeout: Duration) -> bool {
        self.handle
            .shared
            .gate
            .0
            .closed
            .store(true, Ordering::Release);
        self.handle.shared.owner.unpark();
        let started = Instant::now();
        while !self.thread.as_ref().unwrap().is_finished() && started.elapsed() < timeout {
            thread::sleep(Duration::from_millis(1));
        }
        if self.thread.as_ref().unwrap().is_finished() {
            self.thread.take().unwrap().join().is_ok()
        } else {
            false
        }
    }
}
impl Drop for AudioService {
    fn drop(&mut self) {
        self.handle
            .shared
            .gate
            .0
            .closed
            .store(true, Ordering::Release);
        self.handle.shared.owner.unpark();
    }
}
#[derive(Clone, Copy, PartialEq, Eq)]
enum Phase {
    Idle,
    Opening,
    Seeking,
    Preparing,
    Reading,
    Ended,
    Finishing,
    Finished,
    FailedDraining,
    Failed,
}
struct Owner<P: OutputProvider> {
    shared: Arc<Shared>,
    provider: P,
    media: Media,
    events: Remote<Event>,
    intent: Intent,
    phase: Phase,
    output: Option<P::Stream>,
    pipeline: Option<Pipeline>,
    info: Option<MediaInfo>,
    pending_info: Option<MediaInfo>,
    free: Vec<AudioBlock>,
    ready: Option<(AudioBlock, usize)>,
    natural: bool,
    pending: VecDeque<Event>,
    position_at: Instant,
}
impl<P: OutputProvider> Owner<P> {
    fn new(shared: Arc<Shared>, provider: P, media: Media, events: Remote<Event>) -> Self {
        // Start before the initial state so an already published Play is adopted.
        let intent = Intent {
            revision: 0,
            plan: None,
            token: None,
            playing: false,
            seek: None,
            transition: Transition::Replace,
            output_epoch: 0,
        };
        Self {
            shared,
            provider,
            media,
            events,
            intent,
            phase: Phase::Idle,
            output: None,
            pipeline: None,
            info: None,
            pending_info: None,
            free: Vec::with_capacity(3),
            ready: None,
            natural: false,
            pending: VecDeque::with_capacity(12),
            position_at: Instant::now(),
        }
    }
    fn event(&mut self, event: Event) {
        // One pending value per event kind; position and adopted-intent revisions
        // coalesce, obsolete-token terminals are retired on intent adoption.
        let kind = std::mem::discriminant(&event);
        if let Some(index) = self
            .pending
            .iter()
            .position(|old| std::mem::discriminant(old) == kind)
        {
            self.pending.remove(index);
        }
        debug_assert!(self.pending.len() < 12);
        self.pending.push_back(event);
    }
    fn deliver(&mut self) -> bool {
        while let Some(event) = self.pending.pop_front() {
            match self.events.try_send(event) {
                Ok(()) => {}
                Err(SendError::Full(event)) => {
                    self.pending.push_front(event);
                    break;
                }
                Err(SendError::Closed(_)) => return false,
            }
        }
        true
    }
    fn adopt(&mut self, next: Intent) -> Result<(), AudioError> {
        let old_token = self.intent.token;
        let natural = self.phase == Phase::Ended
            && matches!(next.transition, Transition::Advance { from } if Some(from) == old_token);
        self.pending
            .retain(|event| event.token().is_none() || event.token() == next.token);
        let next = {
            self.intent = next;
            &self.intent
        };
        if next.token != old_token {
            self.ready = None;
            self.info = None;
            self.pending_info = None;
            self.natural = natural;
            if !natural {
                self.output.take();
                self.pipeline.take();
                self.free.clear();
            }
            if let Some(plan) = &next.plan {
                self.media
                    .replace(Request::Open(plan.current.track.clone()))?;
                self.phase = Phase::Opening;
            } else {
                self.media.replace(Request::Close)?;
                self.phase = Phase::Idle;
            }
        } else if next.plan.is_none() && natural {
            self.phase = Phase::Finishing;
        }
        if let Some(output) = &mut self.output {
            output.set_playing(next.playing)?;
        }
        self.event(Event::Adopted {
            revision: self.intent.revision,
            token: self.intent.token,
            playing: self.intent.playing,
        });
        Ok(())
    }
    fn fail(&mut self, error: AudioError) {
        self.phase = if self.phase != Phase::FailedDraining
            && !matches!(error, AudioError::Output(_) | AudioError::DeviceUnavailable)
            && self.pipeline.is_some()
            && self.output.is_some()
        {
            // A bad successor must not strand the preceding valid FFT/PCM tail.
            Phase::FailedDraining
        } else {
            self.output.take();
            self.pipeline.take();
            Phase::Failed
        };
        self.ready = None;
        self.pending_info = None;
        let _ = self.media.replace(Request::Close);
        if let Some(token) = self.intent.token {
            self.event(Event::Failed { token, error });
        }
    }
    fn reply(&mut self, reply: Reply) -> Result<(), AudioError> {
        let Some(token) = self.intent.token else {
            return Ok(());
        };
        match reply {
            Reply::Opened(result) => {
                let info = result?;
                self.info = Some(info);
                self.event(Event::Opened { token, info });
                if let Some(time) = self.intent.seek {
                    self.media.decode_request(Request::Seek(time))?;
                    self.phase = Phase::Seeking;
                } else {
                    self.pending_info = Some(info);
                    self.phase = Phase::Preparing;
                }
            }
            Reply::Seeked(result) => {
                result?;
                self.pending_info = self.info;
                self.phase = Phase::Preparing;
                self.event(Event::Seeked {
                    token,
                    milliseconds: self.intent.seek.unwrap_or(0),
                });
            }
            Reply::Decoded(block, result) => match result? {
                true => self.ready = Some((block, 0)),
                false => {
                    self.free.push(block);
                    self.phase = Phase::Ended;
                    if let Some(plan) = &self.intent.plan {
                        self.event(Event::SourceEof {
                            token,
                            end: plan.end_of_stream(),
                        });
                    }
                }
            },
            Reply::Closed => {}
        }
        Ok(())
    }
    fn prepare(&mut self) -> Result<bool, AudioError> {
        let Some(info) = self.pending_info else {
            return Ok(false);
        };
        let mut progress = false;
        let token = self.intent.token.unwrap();
        if self.output.is_none() {
            let mut output = self.provider.open(
                info.format,
                self.shared.gate.clone(),
                self.intent.output_epoch,
            )?;
            output.format().checked()?;
            output.set_playing(self.intent.playing)?;
            self.output = Some(output);
            progress = true;
        }
        if self.natural
            && let Some(pipeline) = &mut self.pipeline
        {
            if pipeline.compatible(info.format) {
                pipeline.next_source(token);
            } else {
                let was_empty = pipeline.empty();
                if !pipeline.finish()? {
                    return Ok(progress || (was_empty && !pipeline.empty()));
                }
                self.pipeline = None;
            }
        }
        if self.pipeline.is_none() {
            self.pipeline = Some(Pipeline::new(
                info.format,
                self.output.as_ref().unwrap().format(),
                token,
                self.intent.seek.unwrap_or(0),
            )?);
        }
        if self
            .free
            .first()
            .is_none_or(|block| block.format != info.format)
        {
            self.free.clear();
            for _ in 0..3 {
                self.free.push(AudioBlock::new(info.format)?);
            }
        }
        self.pending_info = None;
        self.natural = false;
        self.phase = Phase::Reading;
        Ok(true)
    }
    /// One bounded input/FFT/submission step. Only one-way work earns another
    /// immediate turn; blocked credit or media never spins the owner.
    fn cycle(&mut self) -> Result<bool, AudioError> {
        let mut progress = false;
        if self.phase != Phase::FailedDraining {
            if let Some(reply) = self.media.poll()? {
                self.reply(reply)?;
                progress = true;
            }
            progress |= self.prepare()?;
        }
        let Some(output) = &mut self.output else {
            return Ok(progress);
        };
        output.poll()?;
        if !self.intent.playing {
            return Ok(progress);
        }
        let Some(pipeline) = &mut self.pipeline else {
            return Ok(progress);
        };
        let mut started = None;
        let mut position = None;
        if !pipeline.empty() {
            let accepted = output.submit(&pipeline.pending[pipeline.offset..])?;
            if accepted
                > (pipeline.pending.len() - pipeline.offset) / pipeline.device.channels as usize
            {
                return Err(AudioError::Output(
                    "sink accepted more frames than offered".into(),
                ));
            }
            if accepted > 0 {
                pipeline.accepted(accepted);
                progress = true;
                started = pipeline.take_started();
                if self.position_at.elapsed() >= Duration::from_millis(50) {
                    position = self.intent.token.and_then(|token| {
                        pipeline
                            .position_for(token)
                            .map(|milliseconds| (token, milliseconds))
                    });
                    self.position_at = Instant::now();
                }
            }
        }
        if pipeline.empty() {
            if self.phase == Phase::Reading {
                if let Some((block, offset)) = &mut self.ready {
                    let before = *offset;
                    pipeline.feed(block, offset)?;
                    progress |= *offset != before;
                    if *offset == block.frames {
                        self.free.push(self.ready.take().unwrap().0);
                    }
                } else if !self.media.busy()
                    && let Some(block) = self.free.pop()
                {
                    self.media.decode(block)?;
                    progress = true;
                }
            } else if matches!(self.phase, Phase::Finishing | Phase::FailedDraining) {
                let finished = pipeline.finish()?;
                // The entry condition was empty, so this is newly produced PCM.
                progress |= !pipeline.empty();
                if finished && output.queued_frames() == 0 {
                    self.phase = if self.phase == Phase::FailedDraining {
                        Phase::Failed
                    } else {
                        Phase::Finished
                    };
                    progress = true;
                    // Application queue-empty does not prove backend playback;
                    // leave the stream emitting silence through its final buffer.
                }
            }
        }
        if let Some(token) = started {
            self.event(Event::Started { token });
        }
        if let Some((token, milliseconds)) = position {
            self.event(Event::Position {
                token,
                milliseconds,
            });
        }
        if self.phase == Phase::Finished {
            self.event(Event::Drained {
                token: self.intent.token.unwrap(),
            });
            self.phase = Phase::Idle;
        }
        Ok(progress)
    }
    fn run(mut self) {
        while !self.shared.gate.0.closed.load(Ordering::Acquire) {
            let next = {
                let desired = self.shared.desired.lock().unwrap();
                (desired.revision != self.intent.revision || desired.token != self.intent.token)
                    .then(|| desired.clone())
            };
            if let Some(next) = next
                && let Err(error) = self.adopt(next)
            {
                self.fail(error);
            }
            let progress = if self.phase == Phase::Failed {
                // Retire a pending affine Close even after output has failed.
                let _ = self.media.poll();
                false
            } else {
                match self.cycle() {
                    Ok(progress) => progress,
                    Err(error) => {
                        self.fail(error);
                        true
                    }
                }
            };
            if !self.deliver() {
                break;
            }
            if progress {
                // Recheck close/latest intent and deliver events between units.
                continue;
            }
            if self.output.is_none() && !self.media.busy() && self.pending.is_empty() {
                // Handle, media and explicit close already unpark this owner.
                // Park permits cover publication racing this last check.
                thread::park();
            } else {
                thread::park_timeout(if self.intent.playing || self.media.busy() {
                    Duration::from_millis(2)
                } else {
                    Duration::from_millis(50)
                });
            }
        }
        self.shared.gate.0.closed.store(true, Ordering::Release);
        // Output and decoder ownership are destroyed here, never by Window drop.
    }
}

#[cfg(all(test, feature = "cpal-output"))]
mod tests {
    use super::*;
    use std::mem::size_of;

    struct CreditSink {
        format: super::super::Format,
        capacity: usize,
        queued: usize,
        accepted: usize,
    }
    struct CreditProvider;
    impl OutputProvider for CreditProvider {
        type Stream = CreditSink;
        fn open(
            &mut self,
            _: super::super::Format,
            _: PlaybackGate,
            _: u64,
        ) -> Result<CreditSink, AudioError> {
            Err(AudioError::Unsupported(
                "cycle control installs its prepared sink",
            ))
        }
    }
    impl OutputStream for CreditSink {
        fn format(&self) -> super::super::Format {
            self.format
        }
        fn submit(&mut self, samples: &[f64]) -> Result<usize, AudioError> {
            let frames =
                (samples.len() / self.format.channels as usize).min(self.capacity - self.queued);
            self.queued += frames;
            self.accepted += frames;
            Ok(frames)
        }
        fn queued_frames(&self) -> usize {
            self.queued
        }
        fn set_playing(&mut self, _: bool) -> Result<(), AudioError> {
            Ok(())
        }
    }
    fn work_state(
        owner: &Owner<CreditProvider>,
    ) -> (usize, usize, Option<usize>, usize, usize, u8) {
        let output = owner.output.as_ref().unwrap();
        let pipeline = owner.pipeline.as_ref().unwrap();
        (
            output.queued,
            output.accepted,
            owner.ready.as_ref().map(|(_, offset)| *offset),
            pipeline.offset,
            pipeline.pending.len(),
            owner.phase as u8,
        )
    }
    #[test]
    fn actual_cycle_progress_and_credit_exhaustion_follow_a_virtual_consumption_schedule() {
        use super::super::Format;
        use crate::{
            queue::{Track, TrackRef},
            queue_playback::PlaybackQueue,
        };
        use rubato::Resampler;
        for (source_rate, target_rate) in [
            (768000, 48000),
            (768000, 96000),
            (384000, 48000),
            (44100, 48000),
        ] {
            let source = Format {
                rate: source_rate,
                channels: 2,
            };
            let device = Format {
                rate: target_rate,
                channels: 2,
            };
            let mut queue = PlaybackQueue::new().unwrap();
            queue
                .append(
                    vec![TrackRef::new(Track {
                        path: "unused".into(),
                        title: "virtual credits".into(),
                        track_id: None,
                        album_id: None,
                        available_when_prepared: true,
                    })],
                    &|_| true,
                    &mut |_| 0,
                )
                .unwrap();
            let plan = queue.plan().unwrap();
            let token = Token {
                stamp: plan.stamp(),
                revision: 1,
            };
            let intent = Intent {
                revision: 1,
                plan: Some(plan.clone()),
                token: Some(token),
                playing: true,
                seek: None,
                transition: Transition::Replace,
                output_epoch: 0,
            };
            let shared = Arc::new(Shared {
                desired: Mutex::new(intent.clone()),
                gate: PlaybackGate(Arc::new(Gate {
                    epoch: AtomicU64::new(0),
                    playing: AtomicBool::new(true),
                    closed: AtomicBool::new(false),
                })),
                owner: thread::current(),
            });
            let (events, _inbox) = Remote::bounded(32);
            let mut owner = Owner::new(shared, CreditProvider, Media::new().unwrap(), events);
            owner.intent = intent;
            owner.phase = Phase::Reading;
            owner.info = Some(MediaInfo {
                format: source,
                duration_ms: Some(20),
            });
            owner.output = Some(CreditSink {
                format: device,
                capacity: target_rate as usize / 500,
                queued: 0,
                accepted: 0,
            });
            owner.pipeline = Some(Pipeline::new(source, device, token, 0).unwrap());
            let mut block = AudioBlock::new(source).unwrap();
            block.frames = block.capacity();
            for (channel, plane) in block.planes.iter_mut().enumerate() {
                plane.resize(block.frames, (channel + 1) as f64 * 0.125);
            }
            let source_frames = block.frames;
            owner.ready = Some((block, 0));
            let reference = rubato::Fft::<f64>::new(
                source_rate as usize,
                target_rate as usize,
                source_frames,
                2,
                rubato::FixedSync::Input,
            )
            .unwrap();
            let expected = (source_frames as u64 * u64::from(target_rate))
                .div_ceil(u64::from(source_rate)) as usize
                + reference.output_delay();
            drop(reference);
            let mut work_turns = 0;
            let mut blocked_turns = 0;
            for _ in 0..=expected {
                loop {
                    let before = work_state(&owner);
                    let progress = owner.cycle().unwrap();
                    let after = work_state(&owner);
                    if progress {
                        assert_ne!(after, before, "progress must advance work");
                    }
                    assert!(owner.deliver());
                    if owner.ready.is_none() && owner.phase == Phase::Reading {
                        // Source EOF is already established for this prepared
                        // final block; no synthetic decoder work is requested.
                        owner.phase = Phase::Finishing;
                    }
                    assert!(owner.output.as_ref().unwrap().accepted <= expected);
                    if owner.phase == Phase::Idle {
                        break;
                    }
                    if !progress {
                        let blocked = work_state(&owner);
                        for _ in 0..3 {
                            assert!(
                                !owner.cycle().unwrap(),
                                "zero credit/exhausted work cannot spin"
                            );
                            assert_eq!(work_state(&owner), blocked);
                        }
                        blocked_turns += 1;
                        break;
                    }
                    work_turns += 1;
                    assert!(work_turns <= source_frames + expected + 4);
                }
                if owner.phase == Phase::Idle {
                    break;
                }
                let output = owner.output.as_mut().unwrap();
                assert!(
                    output.queued > 0,
                    "blocked owner has no consumption to await"
                );
                output.queued = output.queued.saturating_sub(target_rate as usize / 1000);
            }
            assert!(owner.phase == Phase::Idle);
            assert_eq!(owner.output.as_ref().unwrap().accepted, expected);
            assert_eq!(owner.output.as_ref().unwrap().queued, 0);
            assert!(work_turns > 0 && blocked_turns > 0);
        }
    }
    #[test]
    fn actual_audio_owner_header_bill() {
        println!(
            "AUDIO_HEADERS service={} handle={} shared={} intent={} token={} receipt={} event={} block={} pipeline={} media={} cpal_stream={} owner_cpal={}",
            size_of::<AudioService>(),
            size_of::<AudioHandle>(),
            size_of::<Shared>(),
            size_of::<Intent>(),
            size_of::<Token>(),
            size_of::<Receipt>(),
            size_of::<Event>(),
            size_of::<AudioBlock>(),
            size_of::<Pipeline>(),
            size_of::<Media>(),
            size_of::<super::super::cpal::CpalStream>(),
            size_of::<Owner<super::super::cpal::CpalProvider>>()
        );
    }
    #[test]
    fn cold_production_constructor_caller_allocation_bill_and_max_timeout() {
        let mut live = None;
        let allocations = allocation_counter::measure(|| live = Some(AudioService::new().unwrap()));
        println!(
            "AUDIO_COLD_CPAL_CONSTRUCTOR_CALLER_THREAD {allocations:?}; excludes control/decoder allocation and OS stacks"
        );
        let (service, inbox) = live.unwrap();
        drop(inbox);
        assert!(service.finish(Duration::MAX));
    }
}

#[cfg(test)]
mod publication_tests {
    use super::*;
    use crate::{
        queue::{Track, TrackRef},
        queue_playback::PlaybackQueue,
    };
    use std::sync::Barrier;

    fn active_handle(revision: u64) -> (AudioHandle, Plan) {
        let mut queue = PlaybackQueue::new().unwrap();
        queue
            .play_now(
                TrackRef::new(Track {
                    path: "publication-only.wav".into(),
                    track_id: None,
                    album_id: None,
                    title: "Gate publication".into(),
                    available_when_prepared: true,
                }),
                &|_| true,
                &mut |_| 0,
            )
            .unwrap();
        let plan = queue.plan().unwrap().clone();
        let intent = Intent {
            revision,
            plan: Some(plan.clone()),
            token: Some(Token {
                stamp: plan.stamp(),
                revision,
            }),
            playing: true,
            seek: None,
            transition: Transition::Replace,
            output_epoch: revision,
        };
        let handle = AudioHandle {
            shared: Arc::new(Shared {
                desired: Mutex::new(intent),
                gate: PlaybackGate(Arc::new(Gate {
                    epoch: AtomicU64::new(revision),
                    playing: AtomicBool::new(true),
                    closed: AtomicBool::new(false),
                })),
                owner: thread::current(),
            }),
        };
        (handle, plan)
    }

    #[test]
    fn stop_winning_the_desired_lock_cannot_leave_an_older_publication_playable() {
        for revision in [1, u64::MAX - 1] {
            let (handle, _) = active_handle(revision);
            let entered = Arc::new(Barrier::new(2));
            let release = Arc::new(Barrier::new(2));
            let publisher = handle.clone();
            let publishing = {
                let entered = entered.clone();
                let release = release.clone();
                thread::spawn(move || {
                    // Use the actual shared change path used by public controls.
                    // The barrier only holds its existing desired-state lock.
                    publisher.change(|state| {
                        state.playing = true;
                        entered.wait();
                        release.wait();
                        Ok(())
                    })
                })
            };
            entered.wait();
            let stopper = handle.clone();
            let stopping = thread::spawn(move || stopper.stop());
            let deadline = Instant::now() + Duration::from_secs(5);
            while handle.shared.gate.0.epoch.load(Ordering::Acquire) != 0
                || handle.shared.gate.0.playing.load(Ordering::Acquire)
            {
                assert!(
                    Instant::now() < deadline,
                    "Stop did not revoke before its lock"
                );
                thread::yield_now();
            }
            // Stop has revoked and cannot acquire the held mutex. The older
            // operation now republishes live permission before Stop wins it.
            release.wait();
            let published = publishing.join().unwrap().unwrap();
            let stopped = stopping.join().unwrap().unwrap();
            assert!(stopped.revision >= published.revision);
            assert!(stopped.token.is_none());
            let desired = handle.shared.desired.lock().unwrap();
            assert!(desired.plan.is_none() && desired.token.is_none());
            assert!(!desired.playing);
            assert_eq!(desired.output_epoch, 0);
            assert!(
                !handle.shared.gate.allows(revision),
                "Stop returned after committing stopped desired state, but old PCM is still permitted"
            );
        }
    }

    #[test]
    fn stale_advance_and_exhaustion_cannot_restore_stopped_permission_through_clones() {
        let (handle, plan) = active_handle(1);
        let stale = handle.shared.desired.lock().unwrap().token.unwrap();
        let stopped = handle.clone().stop().unwrap();
        assert!(matches!(
            handle.apply(Some(&plan), Transition::Advance { from: stale }),
            Err(AudioError::Unsupported("stale source-end transition"))
        ));
        assert_eq!(
            handle.shared.desired.lock().unwrap().revision,
            stopped.revision
        );
        handle.clone().set_playing(true).unwrap();
        assert!(!handle.shared.gate.allows(1));
        assert!(matches!(handle.seek(0), Err(AudioError::Unsupported(_))));
        let resumed = handle
            .apply(Some(&plan), Transition::Replace)
            .unwrap()
            .token
            .unwrap();
        assert!(handle.shared.gate.allows(resumed.revision));
        assert!(
            handle
                .apply(None, Transition::Advance { from: stale })
                .is_err()
        );
        assert!(handle.shared.gate.allows(resumed.revision));

        let (handle, plan) = active_handle(u64::MAX);
        let stopped = handle.clone().stop().unwrap();
        assert_eq!(stopped.revision, u64::MAX);
        assert!(stopped.token.is_none());
        assert_eq!(handle.set_playing(true).unwrap_err(), AudioError::Exhausted);
        assert_eq!(handle.seek(0).unwrap_err(), AudioError::Exhausted);
        assert_eq!(
            handle.apply(Some(&plan), Transition::Replace).unwrap_err(),
            AudioError::Exhausted
        );
        assert!(handle.clone().stop().unwrap().token.is_none());
        assert!(!handle.shared.gate.allows(u64::MAX));
    }

    #[test]
    fn terminal_close_dominates_a_control_already_inside_its_publication_lock() {
        let (handle, _) = active_handle(1);
        let entered = Arc::new(Barrier::new(2));
        let release = Arc::new(Barrier::new(2));
        let publisher = handle.clone();
        let publishing = {
            let entered = entered.clone();
            let release = release.clone();
            thread::spawn(move || {
                publisher.change(|state| {
                    state.playing = true;
                    entered.wait();
                    release.wait();
                    Ok(())
                })
            })
        };
        entered.wait();
        // This is the same monotonic terminal publication used by finish/Drop.
        handle.shared.gate.0.closed.store(true, Ordering::Release);
        release.wait();
        publishing.join().unwrap().unwrap();
        assert!(!handle.shared.gate.allows(1));
        assert_eq!(
            handle.clone().set_playing(true).unwrap_err(),
            AudioError::Closed
        );
        assert_eq!(handle.seek(0).unwrap_err(), AudioError::Closed);
        assert!(handle.clone().stop().unwrap().token.is_none());
        assert!(!handle.shared.gate.allows(1));
    }
}
