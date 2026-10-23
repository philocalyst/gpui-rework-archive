//! One in-flight decoder operation; cancellation invalidates replies, not OS I/O.
//! The affine worker/recovery bound follows pinned Hummingbird media_controller.rs.
use super::{AudioError, MediaInfo, block::AudioBlock, decoder::Decoder};
use crate::queue::TrackRef;
use std::{
    sync::mpsc::{self, Receiver, SyncSender},
    thread::{self, JoinHandle},
    time::{Duration, Instant},
};

pub(super) enum Request {
    Open(TrackRef),
    Decode(AudioBlock),
    Seek(u64),
    Close,
}
pub(super) enum Reply {
    Opened(Result<MediaInfo, AudioError>),
    Decoded(AudioBlock, Result<bool, AudioError>),
    Seeked(Result<(), AudioError>),
    Closed,
}
struct Exit {
    owner: thread::Thread,
}
impl Drop for Exit {
    fn drop(&mut self) {
        self.owner.unpark();
    }
}
struct Worker {
    sender: Option<SyncSender<(u64, Request)>>,
    replies: Receiver<(u64, Reply)>,
    thread: JoinHandle<()>,
}
impl Worker {
    fn new() -> Result<Self, AudioError> {
        let (sender, requests) = mpsc::sync_channel::<(u64, Request)>(1);
        let (output, replies) = mpsc::sync_channel(1);
        let exit = Exit {
            owner: thread::current(),
        };
        let thread = thread::Builder::new()
            .name("hummingbird-decoder".into())
            .spawn(move || {
                let _exit = exit;
                let mut decoder: Option<Decoder> = None;
                while let Ok((generation, request)) = requests.recv() {
                    let reply = match request {
                        Request::Open(track) => {
                            // Old file/format/codec drop happens on this owner before replacement.
                            decoder.take();
                            Reply::Opened(Decoder::open(&track.path).map(|opened| {
                                let info = opened.info;
                                decoder = Some(opened);
                                info
                            }))
                        }
                        Request::Decode(mut block) => {
                            let result = decoder
                                .as_mut()
                                .ok_or(AudioError::WorkerClosed)
                                .and_then(|decoder| decoder.decode(&mut block));
                            Reply::Decoded(block, result)
                        }
                        Request::Seek(time) => Reply::Seeked(
                            decoder
                                .as_mut()
                                .ok_or(AudioError::WorkerClosed)
                                .and_then(|decoder| decoder.seek(time)),
                        ),
                        Request::Close => {
                            decoder.take();
                            Reply::Closed
                        }
                    };
                    if output.send((generation, reply)).is_err() {
                        break;
                    }
                    _exit.owner.unpark();
                }
                // A disconnected reply/request lane never moves decoder destruction to UI.
            })
            .map_err(|error| AudioError::Io(error.kind()))?;
        Ok(Self {
            sender: Some(sender),
            replies,
            thread,
        })
    }
}
pub(super) struct Media {
    worker: Worker,
    retired: Option<Worker>,
    generation: u64,
    busy: bool,
    pending: Option<Request>,
    cancelled: Option<Instant>,
}
impl Media {
    pub fn new() -> Result<Self, AudioError> {
        Ok(Self {
            worker: Worker::new()?,
            retired: None,
            generation: 0,
            busy: false,
            pending: None,
            cancelled: None,
        })
    }
    pub fn replace(&mut self, request: Request) -> Result<(), AudioError> {
        self.generation = self
            .generation
            .checked_add(1)
            .ok_or(AudioError::Exhausted)?;
        self.pending = Some(request);
        if self.busy {
            self.cancelled.get_or_insert_with(Instant::now);
        }
        self.submit();
        Ok(())
    }
    pub fn decode(&mut self, block: AudioBlock) -> Result<(), AudioError> {
        self.decode_request(Request::Decode(block))
    }
    pub fn decode_request(&mut self, request: Request) -> Result<(), AudioError> {
        debug_assert!(!self.busy && self.pending.is_none());
        self.pending = Some(request);
        self.submit();
        Ok(())
    }
    fn submit(&mut self) {
        if !self.busy
            && let Some(request) = self.pending.take()
        {
            match self
                .worker
                .sender
                .as_ref()
                .unwrap()
                .try_send((self.generation, request))
            {
                Ok(()) => self.busy = true,
                Err(_) => {
                    self.busy = false;
                }
            }
        }
    }
    pub fn busy(&self) -> bool {
        self.busy || self.pending.is_some()
    }
    pub fn poll(&mut self) -> Result<Option<Reply>, AudioError> {
        if self
            .retired
            .as_ref()
            .is_some_and(|worker| worker.thread.is_finished())
        {
            let _ = self.retired.take().unwrap().thread.join();
        }
        if self.busy
            && self
                .cancelled
                .is_some_and(|start| start.elapsed() >= Duration::from_millis(100))
            && self.retired.is_none()
        {
            let replacement = Worker::new()?;
            let mut old = std::mem::replace(&mut self.worker, replacement);
            old.sender.take();
            self.retired = Some(old);
            self.busy = false;
            self.cancelled = None;
        }
        let reply = match self.worker.replies.try_recv() {
            Ok((generation, reply)) => {
                self.busy = false;
                self.cancelled = None;
                (generation == self.generation).then_some(reply)
            }
            Err(mpsc::TryRecvError::Empty) => None,
            Err(mpsc::TryRecvError::Disconnected) => return Err(AudioError::WorkerClosed),
        };
        self.submit();
        Ok(reply)
    }
}
impl Drop for Media {
    fn drop(&mut self) {
        self.worker.sender.take();
        // Never join an unfinished codec call. Dropping the reply receivers
        // unblocks its send; the worker then closes/drops its own decoder.
        if let Some(mut retired) = self.retired.take() {
            retired.sender.take();
            if retired.thread.is_finished() {
                let _ = retired.thread.join();
            }
        }
    }
}
