//! Audio attachment to the ordinary queue view, through typed production Inbox.
use super::QueueScreen;
use crate::audio::{AudioError, AudioHandle, Event, Receipt, Transition};
use gpui::prelude::*;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum State {
    Stopped,
    Opening,
    Playing,
    Paused,
    Draining,
    Finished,
    Failed,
}
#[derive(Clone, Copy, Debug)]
pub struct Status {
    pub state: State,
    pub position_ms: u64,
    pub duration_ms: Option<u64>,
}
pub(super) struct AudioUi {
    handle: AudioHandle,
    receipt: Receipt,
    playing: bool,
    pub status: Status,
}
impl QueueScreen {
    pub fn attach_audio(&mut self, handle: AudioHandle) -> Result<(), AudioError> {
        let receipt = handle.apply(self.playback.plan(), Transition::Replace)?;
        self.audio = Some(AudioUi {
            handle,
            receipt,
            playing: receipt.token.is_some(),
            status: Status {
                state: if receipt.token.is_some() {
                    State::Opening
                } else {
                    State::Stopped
                },
                position_ms: 0,
                duration_ms: None,
            },
        });
        Ok(())
    }
    /// The existing service revision revokes an unconsumed Library intent when
    /// any newer transport command, including Stop on an empty queue, wins.
    pub fn audio_revision(&self) -> Option<u64> {
        self.audio
            .as_ref()?
            .handle
            .receipt()
            .ok()
            .map(|receipt| receipt.revision)
    }
    pub(crate) fn play_now_if(
        &mut self,
        track: &crate::queue::TrackRef,
        revision: u64,
    ) -> Result<bool, AudioError> {
        let Some(audio) = &mut self.audio else {
            return Ok(false);
        };
        let receipt = audio.handle.replace_if(revision, || {
            self.playback
                .play_now(track.clone(), &super::available, &mut super::draw)?;
            Ok(self.playback.plan().unwrap().clone())
        })?;
        let Some(receipt) = receipt else {
            return Ok(false);
        };
        audio.receipt = receipt;
        audio.playing = true;
        audio.status = Status {
            state: State::Opening,
            position_ms: 0,
            duration_ms: None,
        };
        self.selected.clear();
        self.anchor = None;
        self.notice.clear();
        Ok(true)
    }
    pub fn audio_status(&self) -> Option<Status> {
        self.audio.as_ref().map(|audio| audio.status)
    }
    pub(super) fn sync_audio(&mut self, transition: Transition) {
        let Some(audio) = &mut self.audio else {
            return;
        };
        match audio.handle.apply(self.playback.plan(), transition) {
            Ok(receipt) => {
                if receipt.token != audio.receipt.token {
                    audio.status = Status {
                        state: if receipt.token.is_some() {
                            State::Opening
                        } else {
                            State::Stopped
                        },
                        position_ms: 0,
                        duration_ms: None,
                    };
                }
                if transition == Transition::Replace
                    && self.playback.plan().is_some()
                    && receipt.token != audio.receipt.token
                {
                    audio.playing = true;
                }
                if receipt.token.is_none() {
                    audio.playing = false;
                }
                audio.receipt = receipt;
            }
            Err(error) => {
                self.notice = error.to_string();
                audio.status.state = State::Failed;
            }
        }
    }
    pub fn receive_audio(&mut self, event: Event) {
        let Some(audio) = &mut self.audio else {
            return;
        };
        match event {
            Event::Adopted {
                revision,
                token,
                playing,
            } => {
                if audio
                    .handle
                    .receipt()
                    .is_ok_and(|current| revision == current.revision && token == current.token)
                {
                    let changed = token != audio.receipt.token;
                    audio.receipt = Receipt { revision, token };
                    audio.playing = playing;
                    if changed {
                        audio.status = Status {
                            state: if token.is_none() {
                                State::Stopped
                            } else if playing {
                                State::Opening
                            } else {
                                State::Paused
                            },
                            position_ms: 0,
                            duration_ms: None,
                        };
                    } else if !playing && token.is_some() {
                        audio.status.state = State::Paused;
                    } else if playing && audio.status.state == State::Paused {
                        audio.status.state = State::Playing;
                    }
                }
            }
            event if event.token() != audio.receipt.token => {}
            Event::Opened { info, .. } => {
                audio.status.duration_ms = info.duration_ms;
            }
            Event::Started { .. } => {
                audio.status.state = if audio.playing {
                    State::Playing
                } else {
                    State::Paused
                };
            }
            Event::Position { milliseconds, .. } => audio.status.position_ms = milliseconds,
            Event::Seeked { milliseconds, .. } => {
                audio.status.position_ms = milliseconds;
                if !audio.playing {
                    audio.status.state = State::Paused;
                }
            }
            Event::SourceEof { token, end } => {
                if self.playback.plan().map(|plan| plan.end_of_stream()) != Some(end) {
                    return;
                }
                match audio.handle.advance_if(token, || {
                    // The owner alone edits this queue. The matching stamp
                    // cannot change between this check and the accepted edit.
                    self.playback
                        .end_of_stream(end, &super::available, &mut super::draw)?;
                    Ok(self.playback.plan().cloned())
                }) {
                    Ok(Some((receipt, playing))) => {
                        self.selected.clear();
                        self.anchor = None;
                        audio.receipt = receipt;
                        audio.playing = playing;
                        audio.status = Status {
                            state: if !playing {
                                State::Paused
                            } else if self.playback.plan().is_some() {
                                State::Opening
                            } else {
                                State::Draining
                            },
                            position_ms: 0,
                            duration_ms: None,
                        };
                    }
                    Ok(None) => {}
                    Err(error) => {
                        self.notice = error.to_string();
                        audio.status.state = State::Failed;
                    }
                }
            }
            Event::Drained { .. } => {
                audio.status.state = State::Finished;
                audio.playing = false;
            }
            Event::Failed { error, .. } => {
                audio.status.state = State::Failed;
                self.notice = error.to_string();
            }
        }
    }
    fn pause_audio(&mut self) {
        let Some(audio) = &mut self.audio else {
            return;
        };
        match audio.handle.set_playing(!audio.playing) {
            Ok(receipt) => {
                audio.receipt = receipt;
                audio.playing = !audio.playing;
                audio.status.state = if audio.playing {
                    State::Playing
                } else {
                    State::Paused
                };
            }
            Err(error) => self.notice = error.to_string(),
        }
    }
    fn stop_audio(&mut self) {
        self.playback.stop();
        self.sync_audio(Transition::Replace);
    }
    fn seek_audio(&mut self, forward: bool) {
        let Some(audio) = &mut self.audio else {
            return;
        };
        let time = if forward {
            audio.status.position_ms.saturating_add(10_000)
        } else {
            audio.status.position_ms.saturating_sub(10_000)
        };
        let time = audio.status.duration_ms.map_or(time, |end| time.min(end));
        match audio.handle.seek(time) {
            Ok(receipt) => {
                audio.receipt = receipt;
                audio.status.state = State::Opening;
            }
            Err(error) => self.notice = error.to_string(),
        }
    }
    pub(super) fn audio_controls(&self) -> El<'_> {
        let Some(audio) = &self.audio else {
            return text("Decoder plans only; audio output is not attached");
        };
        column((
            row((
                button(if audio.playing { "Pause" } else { "Resume" }).on_click(Self::pause_audio),
                button("Stop").on_click(Self::stop_audio),
                button("Back 10 seconds").on_click(|model: &mut Self| model.seek_audio(false)),
                button("Forward 10 seconds").on_click(|model: &mut Self| model.seek_audio(true)),
            ))
            .gap(8),
            text(format!(
                "{:?} — {:.1}s{}",
                audio.status.state,
                audio.status.position_ms as f64 / 1000.,
                audio
                    .status
                    .duration_ms
                    .map_or(String::new(), |end| format!(
                        " / {:.1}s",
                        end as f64 / 1000.
                    ))
            )),
        ))
        .gap(6)
    }
}
