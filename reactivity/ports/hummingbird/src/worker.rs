//! One explicit, bounded application service; no UI/runtime/entity executor.
use crate::{
    browser::{Input, Page, PlayRequest, PreparedListing},
    database::Database,
    indexing,
    query::tracks,
    queue::{Track, TrackRef},
    search::{Searcher, SourceError, Version},
};
use gpui::{Completion, Inbox, Remote, StartError};
use std::{
    sync::{Arc, Mutex, Weak, mpsc},
    thread,
};

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
#[derive(Debug)]
pub enum LibraryEvent {
    Indexed {
        request: indexing::Request,
        version: Version,
        result: Result<indexing::Outcome, SourceError>,
    },
    ListingPrepared {
        request: PlayRequest,
        result: Result<PreparedListing, SourceError>,
    },
    Prepared {
        selection: Selection,
        result: Result<TrackRef, SourceError>,
    },
    Imported {
        id: i64,
        version: Version,
    },
    Replaced {
        version: Version,
    },
}
enum Command {
    Index(indexing::Request, indexing::Command),
    Browse(triomphe::Arc<Input>, Completion<Page, SourceError>),
    PrepareListing(PlayRequest),
    Prepare(Selection),
    PrepareAndPlay(Selection),
    Prepend(mpsc::SyncSender<Result<Version, SourceError>>),
    Replace(Database, mpsc::SyncSender<Result<Version, SourceError>>),
    Checkpoint(mpsc::SyncSender<()>),
    Stop,
}

#[derive(Clone)]
pub struct WorkerHandle {
    shared: Arc<Producer>,
}
struct Producer {
    sender: mpsc::SyncSender<Command>,
    version: Mutex<Version>,
}
// MAX is already excluded from every live source generation. Reserve it for
// terminal publication rather than growing the retained Version with a flag.
struct SourceLife(Weak<Producer>);
impl Drop for SourceLife {
    fn drop(&mut self) {
        if let Some(shared) = self.0.upgrade() {
            shared
                .version
                .lock()
                .unwrap_or_else(std::sync::PoisonError::into_inner)
                .generation = u64::MAX;
        }
    }
}
impl WorkerHandle {
    fn enqueue(&self, command: Command) -> Result<(), StartError> {
        self.shared
            .sender
            .try_send(command)
            .map_err(|error| match error {
                mpsc::TrySendError::Full(_) => StartError::Busy,
                mpsc::TrySendError::Disconnected(_) => StartError::Closed,
            })
    }
    /// Validate the worker's published source version across an application
    /// edit. This grants no access to its SQLite connection. Do not re-enter
    /// this handle from commit. The app takes Source before Audio authority;
    /// queue scans/allocation may scale and are not a hard latency bound.
    pub fn with_current_version<R>(
        &self,
        expected: Version,
        commit: impl FnOnce() -> R,
    ) -> Result<Option<R>, SourceError> {
        self.with_version(|version| version == expected, commit)
    }
    /// Existing prepared track leases survive same-source imports. This
    /// capability rejects source replacement and terminal worker retirement.
    pub fn with_current_source<R>(
        &self,
        generation: u64,
        commit: impl FnOnce() -> R,
    ) -> Result<Option<R>, SourceError> {
        self.with_version(|version| version.generation == generation, commit)
    }
    fn with_version<R>(
        &self,
        accepts: impl FnOnce(Version) -> bool,
        commit: impl FnOnce() -> R,
    ) -> Result<Option<R>, SourceError> {
        let version = self
            .shared
            .version
            .lock()
            .map_err(|_| SourceError::SourceAuthorityUnavailable)?;
        if version.generation == u64::MAX {
            return Err(SourceError::SourceClosed);
        }
        if !accepts(*version) {
            return Ok(None);
        }
        let result = commit();
        drop(version);
        Ok(Some(result))
    }
    /// Nonblocking explicit acquisition command on the existing library worker.
    /// Cancel is observed between filesystem/media units; it does not interrupt
    /// an operating-system call or a transaction already being committed.
    pub fn index(
        &self,
        request: indexing::Request,
        command: indexing::Command,
    ) -> Result<(), StartError> {
        self.enqueue(Command::Index(request, command))
    }
    pub fn browse(
        &self,
        input: triomphe::Arc<Input>,
        completion: Completion<Page, SourceError>,
    ) -> Result<(), StartError> {
        self.enqueue(Command::Browse(input, completion))
    }
    pub fn prepare_listing(&self, request: PlayRequest) -> Result<(), StartError> {
        self.enqueue(Command::PrepareListing(request))
    }
    /// Prepare data only. Playback authority belongs to the receiving owner.
    pub fn prepare(&self, selection: Selection) -> Result<(), StartError> {
        self.enqueue(Command::Prepare(selection))
    }
    /// Explicit one-shot continuation, admitted only by the owner's matching
    /// pending Selection and unchanged audio Receipt. The worker never plays.
    pub fn prepare_and_play(&self, selection: Selection) -> Result<(), StartError> {
        self.enqueue(Command::PrepareAndPlay(selection))
    }
}

pub struct Worker {
    handle: WorkerHandle,
    thread: thread::JoinHandle<()>,
}
impl Worker {
    pub fn new(mut database: Database) -> std::io::Result<(Self, Inbox<LibraryEvent>)> {
        if !database.connection().is_autocommit() {
            return Err(std::io::Error::new(
                std::io::ErrorKind::InvalidInput,
                SourceError::SourceNotCommitted,
            ));
        }
        database.initialize_index().map_err(std::io::Error::other)?;
        let (sender, commands) = mpsc::sync_channel(4);
        let (updates, inbox) = Remote::bounded(8);
        let shared = Arc::new(Producer {
            sender,
            version: Mutex::new(Version::default()),
        });
        let producer = Arc::downgrade(&shared);
        let thread = thread::Builder::new()
            .name("hummingbird-library".into())
            .spawn(move || {
                // Local drops before the closure's captured updates Remote,
                // publishing terminal source authority before disconnect wake.
                let source = SourceLife(producer);
                let mut searcher = Searcher::default();
                let mut file_domain = 3_u64;
                let mut scan: Option<indexing::Scan> = None;
                loop {
                    let command = if scan.is_some() {
                        match commands.try_recv() {
                            Ok(command) => Some(command),
                            Err(mpsc::TryRecvError::Empty) => None,
                            Err(mpsc::TryRecvError::Disconnected) => break,
                        }
                    } else {
                        match commands.recv() {
                            Ok(command) => Some(command),
                            Err(_) => break,
                        }
                    };
                    // This turn's sender drops before the next blocking recv.
                    // Keeping only Weak between turns preserves final-handle
                    // disconnection; the worker cannot own its waiting sender.
                    let Some(shared) = source.0.upgrade() else {
                        break;
                    };
                    let version = match shared.version.lock() {
                        Ok(version) => *version,
                        Err(_) => break,
                    };
                    if let Some(command) = command {
                        match command {
                            Command::Index(request, command) => {
                                let result = if request.version != version {
                                    Err(SourceError::OutdatedSource)
                                } else {
                                    if cancel_scan(&mut scan, &database, &updates, version).is_err()
                                    {
                                        break;
                                    }
                                    match command {
                                        indexing::Command::Scan => {
                                            match indexing::Scan::new(&database, request) {
                                                Ok(active) => {
                                                    scan = Some(active);
                                                    continue;
                                                }
                                                Err(error) => {
                                                    if indexing::clear(&database).is_err() {
                                                        break;
                                                    }
                                                    Err(error)
                                                }
                                            }
                                        }
                                        indexing::Command::Cancel => {
                                            Ok((version, indexing::Outcome::Canceled))
                                        }
                                        indexing::Command::AddRoot(path) => {
                                            indexing::add_root(&database, &path, version)
                                                .map(|next| (next, indexing::Outcome::RootsChanged))
                                        }
                                        indexing::Command::RemoveRoot {
                                            id,
                                            delete_recordings,
                                        } => indexing::remove_root(
                                            &database,
                                            id,
                                            delete_recordings,
                                            version,
                                        )
                                        .map(|next| (next, indexing::Outcome::RootsChanged)),
                                    }
                                };
                                let (published, result) = match result {
                                    Ok((next, outcome)) => {
                                        let Ok(mut authority) = shared.version.lock() else {
                                            break;
                                        };
                                        *authority = next;
                                        (next, Ok(outcome))
                                    }
                                    Err(error) => (version, Err(error)),
                                };
                                if updates
                                    .try_send(LibraryEvent::Indexed {
                                        request,
                                        version: published,
                                        result,
                                    })
                                    .is_err()
                                {
                                    break;
                                }
                            }
                            Command::Browse(input, completion) => {
                                let _ = completion.run_cancellable(input, |input, cancellation| {
                                    if input.version != version {
                                        return Some(Err(SourceError::OutdatedSource));
                                    }
                                    if matches!(
                                        input.route,
                                        crate::browser::Route::Files
                                            | crate::browser::Route::Directory(_)
                                    ) {
                                        let Some(next) =
                                            file_domain.checked_add(4).filter(|n| *n < u64::MAX)
                                        else {
                                            return Some(Err(SourceError::IndexExhausted));
                                        };
                                        file_domain = next;
                                        return crate::files::page(
                                            &database,
                                            &mut searcher,
                                            input,
                                            file_domain,
                                            || cancellation.is_cancelled(),
                                        );
                                    }
                                    crate::collection_query::page(
                                        &database,
                                        &mut searcher,
                                        input,
                                        || cancellation.is_cancelled(),
                                    )
                                });
                            }
                            Command::PrepareListing(request) => {
                                let result = if request.input().version != version {
                                    Err(SourceError::OutdatedSource)
                                } else {
                                    crate::collection_query::prepare(
                                        &database,
                                        &mut searcher,
                                        &request,
                                    )
                                };
                                if updates
                                    .try_send(LibraryEvent::ListingPrepared { request, result })
                                    .is_err()
                                {
                                    break;
                                }
                            }
                            Command::Prepare(selection) | Command::PrepareAndPlay(selection) => {
                                let result = prepare(&database, version, selection);
                                if updates
                                    .try_send(LibraryEvent::Prepared { selection, result })
                                    .is_err()
                                {
                                    // The status-aware lane reports final producer close after
                                    // its buffered events. No accepted owner intent stays Pending.
                                    break;
                                }
                            }
                            Command::Prepend(reply) => {
                                if cancel_scan(&mut scan, &database, &updates, version).is_err() {
                                    break;
                                }
                                let result =
                                    next_revision(version).and_then(|next| {
                                        let row = database.prepend_fixture_track()?;
                                        // SQL is committed before Version publication. The
                                        // single worker cannot start a new read before it.
                                        *shared.version.lock().map_err(|_| {
                                            SourceError::SourceAuthorityUnavailable
                                        })? = next;
                                        updates
                                            .try_send(LibraryEvent::Imported {
                                                id: row.id,
                                                version: next,
                                            })
                                            .map_err(|_| SourceError::NotificationsUnavailable)?;
                                        Ok(next)
                                    });
                                let failed_delivery =
                                    matches!(result, Err(SourceError::NotificationsUnavailable));
                                let _ = reply.try_send(result);
                                if failed_delivery {
                                    break;
                                }
                            }
                            Command::Replace(replacement, reply) => {
                                if cancel_scan(&mut scan, &database, &updates, version).is_err() {
                                    break;
                                }
                                let result =
                                    version.advance(true).and_then(|next| {
                                        if !replacement.connection().is_autocommit() {
                                            return Err(SourceError::SourceNotCommitted);
                                        }
                                        replacement.initialize_index()?;
                                        database = replacement;
                                        // SQL is committed before Version publication. The
                                        // single worker cannot start a new read before it.
                                        *shared.version.lock().map_err(|_| {
                                            SourceError::SourceAuthorityUnavailable
                                        })? = next;
                                        updates
                                            .try_send(LibraryEvent::Replaced { version: next })
                                            .map_err(|_| SourceError::NotificationsUnavailable)?;
                                        Ok(next)
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
                    if let Some(active) = scan.as_mut() {
                        let result = active.step(&database);
                        if matches!(result, Ok(false)) {
                            continue;
                        }
                        let active = scan.take().expect("completed scan");
                        let request = active.request;
                        let result = result.and_then(|_| active.finish(&database));
                        let (published, result) = match result {
                            Ok((next, report)) => {
                                let Ok(mut authority) = shared.version.lock() else {
                                    break;
                                };
                                *authority = next;
                                (next, Ok(indexing::Outcome::Indexed(report)))
                            }
                            Err(error) => {
                                if indexing::clear(&database).is_err() {
                                    break;
                                }
                                (version, Err(error))
                            }
                        };
                        if updates
                            .try_send(LibraryEvent::Indexed {
                                request,
                                version: published,
                                result,
                            })
                            .is_err()
                        {
                            break;
                        }
                        continue;
                    }
                }
            })?;
        Ok((
            Self {
                handle: WorkerHandle { shared },
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
        let _ = self.handle.shared.sender.send(Command::Stop);
        drop(self.handle);
        self.thread.join()
    }
}
/// Interruption resolves the accepted task on the existing bounded lane. If
/// terminal delivery fails, the caller closes the producer and native owners
/// observe that close instead of retaining an impossible Pending task.
fn cancel_scan(
    scan: &mut Option<indexing::Scan>,
    database: &Database,
    updates: &Remote<LibraryEvent>,
    version: Version,
) -> Result<(), SourceError> {
    if let Some(active) = scan.take() {
        indexing::clear(database)?;
        updates
            .try_send(LibraryEvent::Indexed {
                request: active.request,
                version,
                result: Ok(indexing::Outcome::Canceled),
            })
            .map_err(|_| SourceError::NotificationsUnavailable)?;
    }
    Ok(())
}
fn next_revision(version: Version) -> Result<Version, SourceError> {
    version.advance(false)
}

fn prepare(
    database: &Database,
    version: Version,
    selection: Selection,
) -> Result<TrackRef, SourceError> {
    if selection.generation != version.generation {
        return Err(SourceError::OutdatedSource);
    }
    let id = selection.id.ok_or(SourceError::NoSelection)?;
    let row = tracks()
        .by_id(id)
        .for_queue()
        .fetch_rows(database.connection())?
        .pop()
        .ok_or(SourceError::MissingTrack(id))?;
    Ok(TrackRef::new(Track {
        available_when_prepared: row.location.exists(),
        path: row.location,
        track_id: Some(row.id),
        album_id: row.album_id,
        title: row.title,
    }))
}

#[cfg(test)]
mod authority_tests {
    use super::*;
    use std::{
        cell::Cell,
        sync::Barrier,
        time::{Duration, Instant},
    };
    #[test]
    fn source_guard_serializes_publication_and_rejects_closed_or_stale_callbacks() {
        let (worker, _inbox) = Worker::new(Database::fixture().unwrap()).unwrap();
        let handle = worker.handle();
        let entered = Arc::new(Barrier::new(2));
        let release = Arc::new(Barrier::new(2));
        let publishing = {
            let handle = handle.clone();
            let entered = entered.clone();
            let release = release.clone();
            thread::spawn(move || {
                handle.with_current_source(0, || {
                    entered.wait();
                    release.wait();
                })
            })
        };
        entered.wait();
        let replacement = worker
            .replace_database(Database::fixture().unwrap())
            .unwrap();
        let until = Instant::now() + Duration::from_secs(5);
        // Worker, this handle and the callback thread already own three strong
        // refs; the fourth proves the worker has entered the replacement turn.
        while Arc::strong_count(&handle.shared) < 4 {
            assert!(Instant::now() < until);
            thread::yield_now();
        }
        assert!(matches!(
            replacement.try_recv(),
            Err(mpsc::TryRecvError::Empty)
        ));
        release.wait();
        assert!(publishing.join().unwrap().unwrap().is_some());
        let version = replacement
            .recv_timeout(Duration::from_secs(5))
            .unwrap()
            .unwrap();
        assert_eq!(version.generation, 1);
        let called = Cell::new(false);
        assert!(
            handle
                .with_current_source(0, || called.set(true))
                .unwrap()
                .is_none()
        );
        assert!(!called.get());
        assert!(
            handle
                .with_current_version(version, || ())
                .unwrap()
                .is_some()
        );
        worker.finish().unwrap();
        assert!(matches!(
            handle.with_current_source(1, || called.set(true)),
            Err(SourceError::SourceClosed)
        ));
        assert!(matches!(
            handle.with_current_source(u64::MAX, || called.set(true)),
            Err(SourceError::SourceClosed)
        ));
        assert!(!called.get());
    }
    #[test]
    fn capability_is_allocation_free_and_callback_panic_retires_poisoned_authority() {
        use std::panic::{AssertUnwindSafe, catch_unwind};
        let (worker, _inbox) = Worker::new(Database::fixture().unwrap()).unwrap();
        let handle = worker.handle();
        let requests = allocation_counter::measure(|| {
            assert!(handle.with_current_source(0, || ()).unwrap().is_some());
            assert!(
                handle
                    .with_current_version(Version::default(), || ())
                    .unwrap()
                    .is_some()
            );
        });
        assert_eq!(requests.count_total, 0);
        assert!(
            catch_unwind(AssertUnwindSafe(
                || handle.with_current_source(0, || panic!("owner callback fault"))
            ))
            .is_err()
        );
        let called = Cell::new(false);
        assert!(matches!(
            handle.with_current_source(0, || called.set(true)),
            Err(SourceError::SourceAuthorityUnavailable)
        ));
        assert!(!called.get());
        worker.finish().unwrap();
    }
    #[test]
    fn final_producer_drop_disconnects_waiting_worker_and_weak_does_not_keep_sender_alive() {
        let (worker, _inbox) = Worker::new(Database::fixture().unwrap()).unwrap();
        let Worker { handle, thread } = worker;
        let weak = Arc::downgrade(&handle.shared);
        drop(handle);
        let until = Instant::now() + Duration::from_secs(5);
        while !thread.is_finished() {
            assert!(Instant::now() < until);
            thread::yield_now();
        }
        thread.join().unwrap();
        assert!(weak.upgrade().is_none());
    }
    #[test]
    fn failed_import_does_not_publish_a_new_version_and_header_bill_is_explicit() {
        let database = Database::fixture().unwrap();
        database
            .insert_track(5000, "Already here", None, None, 1, None)
            .unwrap();
        let (worker, _inbox) = Worker::new(database).unwrap();
        assert!(
            worker
                .prepend_fixture_track()
                .unwrap()
                .recv_timeout(Duration::from_secs(5))
                .unwrap()
                .is_err()
        );
        assert!(
            worker
                .handle()
                .with_current_version(Version::default(), || ())
                .unwrap()
                .is_some()
        );
        println!(
            "SOURCE_HEADERS handle={} producer={} producer_arc_allocation={} version={}",
            size_of::<WorkerHandle>(),
            size_of::<Producer>(),
            size_of::<Producer>() + 2 * size_of::<usize>(),
            size_of::<Version>()
        );
        worker.finish().unwrap();
    }
}
