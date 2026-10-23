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
        self.shared
            .gate
            .0
            .epoch
            .store(desired.output_epoch, Ordering::Release);
        self.shared
            .gate
            .0
            .playing
            .store(desired.playing, Ordering::Release);
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
        let deadline = Instant::now() + timeout;
        while !self.thread.as_ref().unwrap().is_finished() && Instant::now() < deadline {
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
    fn prepare(&mut self) -> Result<(), AudioError> {
        let Some(info) = self.pending_info else {
            return Ok(());
        };
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
        }
        if self.natural
            && let Some(pipeline) = &mut self.pipeline
        {
            if pipeline.compatible(info.format) {
                pipeline.next_source(token);
            } else if !pipeline.finish()? {
                return Ok(());
            } else {
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
        Ok(())
    }
    fn cycle(&mut self) -> Result<(), AudioError> {
        if self.phase != Phase::FailedDraining {
            if let Some(reply) = self.media.poll()? {
                self.reply(reply)?;
            }
            self.prepare()?;
        }
        let Some(output) = &mut self.output else {
            return Ok(());
        };
        output.poll()?;
        if !self.intent.playing {
            return Ok(());
        }
        let Some(pipeline) = &mut self.pipeline else {
            return Ok(());
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
            pipeline.accepted(accepted);
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
        if pipeline.empty() {
            if self.phase == Phase::Reading {
                if let Some((block, offset)) = &mut self.ready {
                    pipeline.feed(block, offset)?;
                    if *offset == block.frames {
                        self.free.push(self.ready.take().unwrap().0);
                    }
                } else if !self.media.busy()
                    && let Some(block) = self.free.pop()
                {
                    self.media.decode(block)?;
                }
            } else if matches!(self.phase, Phase::Finishing | Phase::FailedDraining)
                && pipeline.finish()?
                && output.queued_frames() == 0
            {
                self.phase = if self.phase == Phase::FailedDraining {
                    Phase::Failed
                } else {
                    Phase::Finished
                };
                // Leave the stream emitting silence: application queue-empty is
                // not proof the backend/hardware has played its final buffer.
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
        Ok(())
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
            if self.phase == Phase::Failed {
                // Retire a pending affine Close even after output has failed.
                let _ = self.media.poll();
            } else if let Err(error) = self.cycle() {
                self.fail(error);
            }
            if !self.deliver() {
                break;
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
