//! Exclusive real playback owners. PCM never travels through the UI inbox.
mod block;
#[cfg(feature = "cpal-output")]
mod cpal;
mod decoder;
mod fft;
mod media;
pub mod output;
mod pipeline;
mod service;
mod timing;

use crate::queue_playback::{EndOfStream, PlanStamp};
pub use service::{AudioHandle, AudioService, Receipt, Transition};
use std::{fmt, io};
pub(super) const MAX_RATE: u32 = 768_000;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Format {
    pub rate: u32,
    pub channels: u16,
}
impl Format {
    fn checked(self) -> Result<Self, AudioError> {
        if self.rate == 0 || self.rate > MAX_RATE || !(1..=2).contains(&self.channels) {
            return Err(AudioError::Unsupported("audio rate or channel layout"));
        }
        Ok(self)
    }
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Token {
    pub stamp: PlanStamp,
    // A checked service revision; seek creates a new token within an occurrence.
    pub revision: u64,
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum AudioError {
    Io(io::ErrorKind),
    Unsupported(&'static str),
    Decode(String),
    Output(String),
    DeviceUnavailable,
    WorkerClosed,
    Closed,
    Exhausted,
}
impl fmt::Display for AudioError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Io(kind) => write!(f, "audio file: {kind}"),
            Self::Unsupported(what) => write!(f, "unsupported {what}"),
            Self::Decode(message) => write!(f, "decoder: {message}"),
            Self::Output(message) => write!(f, "audio output: {message}"),
            Self::DeviceUnavailable => f.write_str("no audio output device is available"),
            Self::WorkerClosed => f.write_str("decoder worker closed"),
            Self::Closed => f.write_str("audio service closed"),
            Self::Exhausted => f.write_str("audio request identity exhausted"),
        }
    }
}
impl std::error::Error for AudioError {}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct MediaInfo {
    pub format: Format,
    pub duration_ms: Option<u64>,
}
#[derive(Debug)]
pub enum Event {
    Adopted {
        revision: u64,
        token: Option<Token>,
        playing: bool,
    },
    Opened {
        token: Token,
        info: MediaInfo,
    },
    /// First frames accepted by the application device queue, not audible time.
    Started {
        token: Token,
    },
    /// Submitted source time, excluding OS/hardware latency.
    Position {
        token: Token,
        milliseconds: u64,
    },
    Seeked {
        token: Token,
        milliseconds: u64,
    },
    SourceEof {
        token: Token,
        end: EndOfStream,
    },
    /// Source/tail/staging and the application device queue are empty.
    Drained {
        token: Token,
    },
    Failed {
        token: Token,
        error: AudioError,
    },
}
impl Event {
    pub fn token(&self) -> Option<Token> {
        match self {
            Self::Adopted { token, .. } => *token,
            Self::Opened { token, .. }
            | Self::Started { token }
            | Self::Position { token, .. }
            | Self::Seeked { token, .. }
            | Self::SourceEof { token, .. }
            | Self::Drained { token }
            | Self::Failed { token, .. } => Some(*token),
        }
    }
}
