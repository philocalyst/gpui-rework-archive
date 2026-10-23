//! One explicit, bounded application service; no UI/runtime/entity executor.
use crate::{
    database::Database,
    query::tracks,
    queue::{Track, TrackRef},
    search::{SearchInput, SearchPage, Searcher, SourceError, Version},
};
use gpui::{Completion, Inbox, Remote, StartError};
use std::{sync::mpsc, thread};

#[derive(Debug)]
pub struct QueueError(pub StartError);
impl std::fmt::Display for QueueError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(match self.0 {
            StartError::Busy => "Library worker is busy",
            StartError::Closed => "Library worker is closed",
        })
    }
}
impl std::error::Error for QueueError {}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Selection {
    pub id: Option<i64>,
    pub sequence: u64,
    pub generation: u64,
}
pub struct PlaybackRequest {
    pub selection: Selection,
    pub track: Option<TrackRef>,
}
#[derive(Debug)]
pub enum LibraryEvent {
    Imported { id: i64, version: Version },
    Replaced { version: Version },
}
enum Command {
    Search(SearchInput, Completion<SearchPage, SourceError>),
    Play(Selection, Completion<PlaybackRequest, SourceError>),
    Prepend(mpsc::SyncSender<Result<Version, SourceError>>),
    Replace(Database, mpsc::SyncSender<Result<Version, SourceError>>),
    Checkpoint(mpsc::SyncSender<()>),
    Stop,
}

#[derive(Clone)]
pub struct WorkerHandle {
    sender: mpsc::SyncSender<Command>,
}
impl WorkerHandle {
    fn enqueue(&self, command: Command) -> Result<(), StartError> {
        self.sender.try_send(command).map_err(|error| match error {
            mpsc::TrySendError::Full(_) => StartError::Busy,
            mpsc::TrySendError::Disconnected(_) => StartError::Closed,
        })
    }
    pub fn search(
        &self,
        input: SearchInput,
        completion: Completion<SearchPage, SourceError>,
    ) -> Result<(), StartError> {
        self.enqueue(Command::Search(input, completion))
    }
    pub fn play(
        &self,
        selection: Selection,
        completion: Completion<PlaybackRequest, SourceError>,
    ) -> Result<(), StartError> {
        self.enqueue(Command::Play(selection, completion))
    }
}

pub struct Worker {
    handle: WorkerHandle,
    thread: thread::JoinHandle<()>,
}
impl Worker {
    pub fn new(mut database: Database) -> std::io::Result<(Self, Inbox<LibraryEvent>)> {
        let (sender, commands) = mpsc::sync_channel(4);
        let (updates, inbox) = Remote::bounded(8);
        let thread = thread::Builder::new()
            .name("hummingbird-library".into())
            .spawn(move || {
                let mut searcher = Searcher::default();
                let mut version = Version::default();
                while let Ok(command) = commands.recv() {
                    match command {
                        Command::Search(input, completion) => {
                            let _ = completion.run_cancellable(input, |input, cancellation| {
                                if cancellation.is_cancelled() {
                                    return None;
                                }
                                if input.version != version {
                                    return Some(Err(SourceError::OutdatedSource));
                                }
                                searcher.search(&database, input, || cancellation.is_cancelled())
                            });
                        }
                        Command::Play(selection, completion) => {
                            let _ =
                                completion.run_cancellable(selection, |selection, cancellation| {
                                    if cancellation.is_cancelled() {
                                        return None;
                                    }
                                    if selection.generation != version.generation {
                                        return Some(Err(SourceError::OutdatedSource));
                                    }
                                    let track = match selection.id {
                                        None => Ok(None),
                                        Some(id) => tracks()
                                            .by_id(id)
                                            .for_queue()
                                            .fetch_rows(database.connection())
                                            .map_err(SourceError::from)
                                            .and_then(|mut rows| {
                                                rows.pop()
                                                    .map(Some)
                                                    .ok_or(SourceError::MissingTrack(id))
                                            }),
                                    };
                                    if cancellation.is_cancelled() {
                                        None
                                    } else {
                                        Some(track.map(|track| PlaybackRequest {
                                            selection,
                                            track: track.map(|row| {
                                                let available_when_prepared = row.location.exists();
                                                TrackRef::new(Track {
                                                    path: row.location,
                                                    track_id: Some(row.id),
                                                    album_id: row.album_id,
                                                    title: row.title,
                                                    available_when_prepared,
                                                })
                                            }),
                                        }))
                                    }
                                });
                        }
                        Command::Prepend(reply) => {
                            let result = next_revision(version).and_then(|next| {
                                let row = database.prepend_fixture_track()?;
                                version = next;
                                updates
                                    .try_send(LibraryEvent::Imported {
                                        id: row.id,
                                        version,
                                    })
                                    .map_err(|_| SourceError::NotificationsUnavailable)?;
                                Ok(version)
                            });
                            let failed_delivery =
                                matches!(result, Err(SourceError::NotificationsUnavailable));
                            let _ = reply.try_send(result);
                            if failed_delivery {
                                break;
                            }
                        }
                        Command::Replace(replacement, reply) => {
                            let result = next_revision(version).and_then(|mut next| {
                                next.generation = next
                                    .generation
                                    .checked_add(1)
                                    .filter(|&generation| generation < u64::MAX)
                                    .ok_or(SourceError::VersionExhausted)?;
                                database = replacement;
                                version = next;
                                updates
                                    .try_send(LibraryEvent::Replaced { version })
                                    .map_err(|_| SourceError::NotificationsUnavailable)?;
                                Ok(version)
                            });
                            let failed_delivery =
                                matches!(result, Err(SourceError::NotificationsUnavailable));
                            let _ = reply.try_send(result);
                            if failed_delivery {
                                break;
                            }
                        }
                        Command::Checkpoint(reply) => {
                            let _ = reply.try_send(());
                        }
                        Command::Stop => break,
                    }
                }
            })?;
        Ok((
            Self {
                handle: WorkerHandle { sender },
                thread,
            },
            inbox,
        ))
    }
    pub fn handle(&self) -> WorkerHandle {
        self.handle.clone()
    }
    /// Fixture import stands in for a scanner commit, writing real SQLite and
    /// publishing its revision through the ordinary typed Inbox.
    pub fn prepend_fixture_track(
        &self,
    ) -> Result<mpsc::Receiver<Result<Version, SourceError>>, QueueError> {
        let (send, receive) = mpsc::sync_channel(1);
        self.handle
            .enqueue(Command::Prepend(send))
            .map_err(QueueError)?;
        Ok(receive)
    }
    /// Source replacement is explicit; result keys are qualified by generation.
    pub fn replace_database(
        &self,
        database: Database,
    ) -> Result<mpsc::Receiver<Result<Version, SourceError>>, QueueError> {
        let (send, receive) = mpsc::sync_channel(1);
        self.handle
            .enqueue(Command::Replace(database, send))
            .map_err(QueueError)?;
        Ok(receive)
    }
    /// Nonblocking enqueue; a caller outside a UI turn may await this receiver
    /// to establish that earlier service commands finished. Native callbacks
    /// never wait for it. The headless executable uses this same service API.
    pub fn checkpoint(&self) -> Result<mpsc::Receiver<()>, QueueError> {
        let (send, receive) = mpsc::sync_channel(1);
        self.handle
            .enqueue(Command::Checkpoint(send))
            .map_err(QueueError)?;
        Ok(receive)
    }
    /// Call outside UI turns, normally after dropping the window. Stop also
    /// revokes cloned service handles; their next enqueue returns Closed.
    /// Ordinary Drop detaches the join handle instead of blocking a UI callback.
    pub fn finish(self) -> thread::Result<()> {
        let _ = self.handle.sender.send(Command::Stop);
        drop(self.handle);
        self.thread.join()
    }
}
fn next_revision(version: Version) -> Result<Version, SourceError> {
    Ok(Version {
        revision: version
            .revision
            .checked_add(1)
            .ok_or(SourceError::VersionExhausted)?,
        ..version
    })
}
