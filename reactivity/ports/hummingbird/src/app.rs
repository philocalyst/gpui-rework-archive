//! One public GPUI View, shared by the ordinary native and headless owners.
use crate::{
    browser::{Browser, Input, Page, PlayRequest, Route, RowKey},
    queue::TrackRef,
    queue_view::QueueScreen,
    search::Version,
    worker::{LibraryEvent, Selection, WorkerHandle},
};
use gpui::{LaneSet, QuestionFault, Questions, Reader, prelude::*};

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum PreparationStatus {
    Empty,
    Pending,
    Ready,
    Failed,
    Canceled,
}
enum Preparation {
    Empty,
    ListingPending {
        request: PlayRequest,
        edits: [u32; 3],
        revision: u64,
    },
    #[cfg(feature = "audio")]
    ListingPlayed {
        request: PlayRequest,
        edits: [u32; 3],
    },
    ListingFailed {
        request: PlayRequest,
        edits: [u32; 3],
        error: String,
    },
    Pending {
        selection: Selection,
        play_revision: Option<u64>,
        play_edits: Option<[u32; 3]>,
    },
    Ready {
        selection: Selection,
        track: TrackRef,
    },
    Failed {
        selection: Selection,
        error: String,
    },
    Canceled,
}

pub struct Library {
    browser: Browser,
    pub version: Signal<Version>,
    pub selected: Signal<Selection>,
    pub results: Reader<Page>,
    preparation: Preparation,
    worker: WorkerHandle,
    issued: u64,
    pub queue: QueueScreen,
    notice: String,
}
impl Library {
    #[cfg(feature = "audio")]
    pub fn receive_audio(&mut self, event: crate::audio::Event) {
        self.queue.receive_audio(event);
    }
    pub const QUEUE: Component<Self, QueueScreen> = Component::new(
        FieldId::new(5),
        "playback queue",
        |model| &model.queue,
        |model| &mut model.queue,
    );
    pub const BROWSER: Component<Self, Browser> = Component::new(
        FieldId::new(6),
        "collection browser",
        |m| &m.browser,
        |m| &mut m.browser,
    );
    pub fn browser(&self) -> &Browser {
        &self.browser
    }
    pub fn recording_list(&self) -> ListId {
        self.browser.navigation().track_list()
    }
    pub const VERSION: Source<Self, Version> = Source::new(
        FieldId::new(3),
        "library revision",
        |m| &m.version,
        |m| &mut m.version,
    );
    pub const SELECTED: Source<Self, Selection> = Source::new(
        FieldId::new(4),
        "play selection",
        |m| &m.selected,
        |m| &mut m.selected,
    );
    fn current_selection(&self, selection: Selection) -> bool {
        selection == *self.selected && selection.generation == self.version.generation
    }
    fn audio_revision(&self) -> Option<u64> {
        #[cfg(feature = "audio")]
        {
            self.queue.audio_revision()
        }
        #[cfg(not(feature = "audio"))]
        {
            None
        }
    }
    fn current_listing(&self, request: &PlayRequest, edits: [u32; 3]) -> bool {
        let id = request.start.map(|key| match key {
            RowKey::Track(id) | RowKey::PlaylistItem { track: id, .. } => id,
        });
        self.selected.sequence == request.sequence
            && self.selected.id == id
            && self.selected.generation == request.input.version.generation
            && self.browser.revisions() == edits
            && self.browser.matches(&request.input, *self.version)
    }
    pub fn navigate(&mut self, route: Route) {
        self.browser.navigate(route);
    }
    pub fn open_collection(&mut self, input: &Input, route: Route) {
        if self.browser.matches(input, *self.version) {
            self.browser.navigate(route);
        }
    }
    pub fn play_listing(&mut self, input: triomphe::Arc<Input>, start: Option<RowKey>) {
        if !self.browser.matches(&input, *self.version) {
            self.notice = "This listing is no longer current".into();
            return;
        }
        let Some(revision) = self.audio_revision() else {
            self.notice = "Audio output is not attached".into();
            return;
        };
        let Some(sequence) = self.issued.checked_add(1) else {
            self.preparation = Preparation::Failed {
                selection: *self.selected,
                error: "Preparation request space exhausted".into(),
            };
            return;
        };
        self.issued = sequence;
        let request = PlayRequest {
            input,
            start,
            sequence,
        };
        *self.selected = Selection {
            id: start.map(|key| match key {
                RowKey::Track(id) | RowKey::PlaylistItem { track: id, .. } => id,
            }),
            sequence,
            generation: request.input.version.generation,
        };
        let edits = self.browser.revisions();
        self.preparation = Preparation::ListingPending {
            request: request.clone(),
            edits,
            revision,
        };
        if let Err(error) = self.worker.prepare_listing(request.clone()) {
            self.preparation = Preparation::ListingFailed {
                request,
                edits,
                error: crate::worker::QueueError(error).to_string(),
            };
        }
    }
    /// Readiness is distinct from playback permission. A newer selection,
    /// source or transport revision immediately makes pending Play canceled.
    pub fn preparation_status(&self) -> PreparationStatus {
        match &self.preparation {
            Preparation::Empty => PreparationStatus::Empty,
            Preparation::ListingPending {
                request,
                edits,
                revision,
            } if self.current_listing(request, *edits)
                && self.audio_revision() == Some(*revision) =>
            {
                PreparationStatus::Pending
            }
            #[cfg(feature = "audio")]
            Preparation::ListingPlayed { request, edits }
                if self.current_listing(request, *edits) =>
            {
                PreparationStatus::Ready
            }
            Preparation::ListingFailed { request, edits, .. }
                if self.current_listing(request, *edits) =>
            {
                PreparationStatus::Failed
            }
            Preparation::Pending {
                selection,
                play_revision,
                play_edits,
            } if play_edits.is_none_or(|edits| self.browser.revisions() == edits)
                && self.current_selection(*selection)
                && play_revision.is_none_or(|revision| self.audio_revision() == Some(revision)) =>
            {
                PreparationStatus::Pending
            }
            Preparation::Ready { selection, .. } if self.current_selection(*selection) => {
                PreparationStatus::Ready
            }
            Preparation::Failed { selection, .. } if self.current_selection(*selection) => {
                PreparationStatus::Failed
            }
            _ => PreparationStatus::Canceled,
        }
    }
    pub fn prepared(&self) -> Option<(Selection, &TrackRef)> {
        match &self.preparation {
            Preparation::Ready { selection, track } if self.current_selection(*selection) => {
                Some((*selection, track))
            }
            _ => None,
        }
    }
    /// The bounded worker lane reports final producer close after buffered
    /// events, so a failed result delivery cannot leave a live owner Pending.
    pub fn receive(&mut self, event: Option<LibraryEvent>) {
        let Some(event) = event else {
            if self.preparation_status() == PreparationStatus::Pending {
                self.preparation =
                    match std::mem::replace(&mut self.preparation, Preparation::Canceled) {
                        Preparation::ListingPending { request, edits, .. } => {
                            Preparation::ListingFailed {
                                request,
                                edits,
                                error: "Library worker closed before preparation completed".into(),
                            }
                        }
                        _ => Preparation::Failed {
                            selection: *self.selected,
                            error: "Library worker closed before preparation completed".into(),
                        },
                    };
            } else if matches!(self.preparation, Preparation::Pending { .. }) {
                self.preparation = Preparation::Canceled;
            }
            self.notice = "Library worker closed".into();
            return;
        };
        match event {
            LibraryEvent::ListingPrepared { request, result } => {
                let (edits, revision) = match &self.preparation {
                    Preparation::ListingPending {
                        request: pending,
                        edits,
                        revision,
                    } if pending == &request => (*edits, *revision),
                    _ => return,
                };
                if self.preparation_status() != PreparationStatus::Pending {
                    self.preparation = Preparation::Canceled;
                    return;
                }
                self.preparation = Preparation::Canceled;
                match result {
                    Err(error) => {
                        self.preparation = Preparation::ListingFailed {
                            request,
                            edits,
                            error: error.to_string(),
                        }
                    }
                    Ok(listing) => {
                        #[cfg(feature = "audio")]
                        match self.worker.with_current_version(request.input.version, || {
                            self.queue.play_listing_if(listing, revision)
                        }) {
                            Ok(Some(Ok(true))) => {
                                self.preparation = Preparation::ListingPlayed { request, edits }
                            }
                            Ok(Some(Ok(false))) | Ok(None) => {}
                            Ok(Some(Err(error))) => {
                                self.preparation = Preparation::ListingFailed {
                                    request,
                                    edits,
                                    error: error.to_string(),
                                }
                            }
                            Err(error) => {
                                self.preparation = Preparation::ListingFailed {
                                    request,
                                    edits,
                                    error: error.to_string(),
                                }
                            }
                        }
                        #[cfg(not(feature = "audio"))]
                        let _ = (listing, revision);
                    }
                }
            }
            LibraryEvent::Imported { id, version } => {
                if version.revision > self.version.revision {
                    *self.version = version;
                    self.notice = format!("Imported recording {id}");
                }
            }
            LibraryEvent::Replaced { version } => {
                if version.revision > self.version.revision {
                    *self.version = version;
                    *self.selected = Selection {
                        sequence: self.issued,
                        generation: version.generation,
                        ..Selection::default()
                    };
                    self.preparation = Preparation::Empty;
                    self.browser.source_changed();
                    self.notice = "Library source changed".into();
                }
            }
            LibraryEvent::Prepared { selection, result } => {
                // Public worker callers choose their own request numbers.
                // Match the full recording/source identity issued by this owner.
                let (selection, play_revision) = match &self.preparation {
                    Preparation::Pending {
                        selection: pending,
                        play_revision,
                        ..
                    } if *pending == selection => (*pending, *play_revision),
                    _ => return,
                };
                if self.preparation_status() != PreparationStatus::Pending {
                    self.preparation = Preparation::Canceled;
                    return;
                }
                match result {
                    Err(error) => {
                        self.preparation = Preparation::Failed {
                            selection,
                            error: error.to_string(),
                        }
                    }
                    Ok(track) => {
                        // Retire authority before queue/service mutation. Duplicate and
                        // late replies cannot consume this continuation a second time.
                        self.preparation = Preparation::Canceled;
                        #[cfg(feature = "audio")]
                        if let Some(revision) = play_revision {
                            match self.worker.with_current_source(selection.generation, || {
                                self.queue.play_now_if(&track, revision)
                            }) {
                                Ok(Some(Ok(true))) => {}
                                Ok(Some(Ok(false))) | Ok(None) => return,
                                Ok(Some(Err(error))) => {
                                    self.preparation = Preparation::Failed {
                                        selection,
                                        error: error.to_string(),
                                    };
                                    return;
                                }
                                Err(error) => {
                                    self.preparation = Preparation::Failed {
                                        selection,
                                        error: error.to_string(),
                                    };
                                    return;
                                }
                            }
                        }
                        #[cfg(not(feature = "audio"))]
                        let _ = play_revision;
                        self.preparation = Preparation::Ready { selection, track };
                    }
                }
            }
        }
    }
    /// Explicitly prepare one recording; this never grants playback permission.
    pub fn prepare(&mut self, id: i64, generation: u64) {
        self.begin_prepare(id, generation, None);
    }
    #[cfg(feature = "audio")]
    /// Prepare and play once if this owner still holds the same selection,
    /// source and transport revision when the result enters its delivery turn.
    pub fn play_now(&mut self, id: i64, generation: u64) {
        let Some(revision) = self.queue.audio_revision() else {
            self.notice = "Audio output is not attached".into();
            return;
        };
        self.begin_prepare(id, generation, Some(revision));
    }
    fn begin_prepare(&mut self, id: i64, generation: u64, play_revision: Option<u64>) {
        if generation != self.version.generation {
            self.notice = "This recording belongs to the previous library source".into();
            return;
        }
        let Some(sequence) = self.issued.checked_add(1) else {
            self.preparation = Preparation::Failed {
                selection: *self.selected,
                error: "Preparation request space exhausted".into(),
            };
            return;
        };
        self.issued = sequence;
        let selection = Selection {
            id: Some(id),
            sequence,
            generation,
        };
        *self.selected = selection;
        self.preparation = Preparation::Pending {
            selection,
            play_revision,
            play_edits: play_revision.map(|_| self.browser.revisions()),
        };
        let result = if play_revision.is_some() {
            self.worker.prepare_and_play(selection)
        } else {
            self.worker.prepare(selection)
        };
        if let Err(error) = result {
            self.preparation = Preparation::Failed {
                selection,
                error: crate::worker::QueueError(error).to_string(),
            };
        }
    }
    fn enqueue(&mut self, track: TrackRef, selection: Selection) {
        if self.current_selection(selection) {
            match self
                .worker
                .with_current_source(selection.generation, || self.queue.enqueue(track))
            {
                Ok(Some(())) => {}
                Ok(None) => self.notice = "The library source changed".into(),
                Err(error) => self.notice = error.to_string(),
            }
        } else {
            self.notice = "This prepared recording is no longer the current selection".into();
        }
    }
    fn preparation_view(&self) -> El<'_> {
        if self.preparation_status() == PreparationStatus::Canceled {
            return text("Preparation canceled by newer controls");
        }
        match &self.preparation {
            Preparation::Empty => text("No recording selected"),
            Preparation::ListingPending { .. } => text("Preparing collection to play…"),
            #[cfg(feature = "audio")]
            Preparation::ListingPlayed { .. } => text("Collection playback started"),
            Preparation::ListingFailed { error, .. } => {
                text(format!("Collection unavailable: {error}"))
            }
            Preparation::Pending { play_revision, .. } => text(if play_revision.is_some() {
                "Preparing to play…"
            } else {
                "Preparing recording…"
            }),
            Preparation::Failed { error, .. } => text(format!("Recording unavailable: {error}")),
            Preparation::Canceled => text("Preparation canceled by newer controls"),
            Preparation::Ready { selection, track } => {
                let selection = *selection;
                let leased = track.clone();
                column((
                    text(format!(
                        "Prepared request {}: recording {} — {}",
                        selection.sequence,
                        track.track_id.unwrap(),
                        track.path.display()
                    )),
                    button(format!(
                        "Add prepared recording {} to queue",
                        track.track_id.unwrap()
                    ))
                    .on_click(move |model: &mut Library| model.enqueue(leased.clone(), selection)),
                ))
            }
        }
    }
}

pub fn connect(
    handle: WorkerHandle,
) -> Result<(Library, Questions<Library, impl LaneSet<Library>>), QuestionFault> {
    let search = handle.clone();
    let (questions, results) = Questions::new().question(
        (
            (
                Library::BROWSER.source(&Browser::QUERY),
                Library::BROWSER.source(&Browser::SORT),
            ),
            (Library::BROWSER.source(&Browser::NAV), Library::VERSION),
        ),
        |((query, sort), (navigation, version))| Input::freeze(navigation, query, *sort, *version),
        move |input, completion: gpui::Completion<Page, crate::search::SourceError>| match input {
            Ok(input) => search.browse(input, completion),
            Err(error) => {
                let _ = completion.complete(Err(error));
                Ok(())
            }
        },
    )?;
    Ok((
        Library {
            browser: Browser::new(),
            version: Signal::new(Version::default()),
            selected: Signal::new(Selection::default()),
            results,
            preparation: Preparation::Empty,
            worker: handle,
            issued: 0,
            // Navigation domains are nonzero; this stable queue owns zero
            // and survives database replacement.
            queue: QueueScreen::new(ListId::new(0)).map_err(|_| QuestionFault::Exhausted)?,
            notice: String::new(),
        },
        questions,
    ))
}

pub fn track_key(id: i64) -> ItemKey {
    ItemKey::new(id as u64)
}

impl View for Library {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct_component(Self::BROWSER)
            .field(Self::VERSION)
            .field(Self::SELECTED)
            .direct_component(Self::QUEUE)
    }
    fn view(&self) -> El<'_> {
        column((
            text("Hummingbird — Library").font_size(24),
            Self::BROWSER.view(self),
            self.results
                .project(|page| {
                    #[cfg(feature = "audio")]
                    let play_all = {
                        if page.rows.is_empty() {
                            text("")
                        } else {
                            let input = page.input().clone();
                            button("Play all")
                                .name(format!("Play all {}", page.title))
                                .on_click(move |model: &mut Library| {
                                    model.play_listing(input.clone(), None)
                                })
                        }
                    };
                    #[cfg(not(feature = "audio"))]
                    let play_all = text("");
                    let collections = if page.collections.rows.is_empty() {
                        text("")
                    } else {
                        uniform_list(page.collection_list(), &page.collections, 32)
                            .name("Collections")
                            .w(650)
                            .h(96)
                    };
                    let summary = if matches!(
                        page.input().route,
                        Route::Albums | Route::Artists | Route::Playlists
                    ) {
                        format!(
                            "{} {}",
                            page.collections.rows.len(),
                            page.input().route.label().to_lowercase()
                        )
                    } else {
                        format!(
                            "{} recordings for ‘{}’ — {}",
                            page.rows.len(),
                            page.input().query,
                            page.input().sort_label()
                        )
                    };
                    column((
                        text(format!("{} — {}", page.input().route.label(), page.title)),
                        text(summary),
                        play_all,
                        collections,
                        uniform_list(page.track_list(), &page.rows, 32)
                            .name("Library recordings")
                            .w(650)
                            .h(160),
                    ))
                    .gap(6)
                })
                .loading(|| text("Searching recordings…"))
                .failed(|failure| text(format!("Library unavailable: {failure}"))),
            self.preparation_view(),
            text(self.notice.as_str()),
            Self::QUEUE.view(self),
        ))
        .p(12)
        .gap(10)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{database::Database, worker::Worker};
    use std::time::Duration;

    #[test]
    fn exhausted_issuance_revokes_prior_work_and_survives_source_and_public_selection_reset() {
        let (worker, inbox) = Worker::new(Database::fixture().unwrap()).unwrap();
        let (mut model, questions) = connect(worker.handle()).unwrap();
        model.issued = u64::MAX - 1;
        model.prepare(44, 0);
        assert_eq!(model.selected.sequence, u64::MAX);
        model.prepare(90, 0);
        assert_eq!(model.preparation_status(), PreparationStatus::Failed);
        let mut owner = gpui::Win::with_questions(model, questions, gpui::WindowOptions::default())
            .unwrap()
            .with_inbox_status(inbox, Library::receive)
            .unwrap();
        crate::transcript::settle(&mut owner, &worker).unwrap();
        assert!(
            owner
                .with_model(|model| model.prepared().is_none())
                .unwrap()
        );
        worker
            .replace_database(Database::fixture().unwrap())
            .unwrap()
            .recv_timeout(Duration::from_secs(10))
            .unwrap()
            .unwrap();
        crate::transcript::settle(&mut owner, &worker).unwrap();
        owner
            .set(
                Library::SELECTED,
                Selection {
                    generation: 1,
                    ..Selection::default()
                },
            )
            .unwrap();
        owner.update(|model| model.prepare(44, 1)).unwrap();
        assert_eq!(owner.with_model(|model| model.issued).unwrap(), u64::MAX);
        assert_eq!(
            owner
                .with_model(|model| model.preparation_status())
                .unwrap(),
            PreparationStatus::Failed
        );
        assert!(
            owner
                .contains_text("Preparation request space exhausted")
                .unwrap()
        );
        assert!(
            owner
                .with_model(|model| model.prepared().is_none())
                .unwrap()
        );
        drop(owner);
        worker.finish().unwrap();
    }
}
