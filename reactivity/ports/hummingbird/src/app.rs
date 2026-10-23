//! One public GPUI View, shared by the ordinary native and headless owners.
use crate::{
    queue::TrackRef,
    queue_view::QueueScreen,
    search::{SearchInput, SearchPage, Sort, Version},
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
    Pending {
        selection: Selection,
        play_revision: Option<u64>,
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
    pub query: Signal<String>,
    pub sort: Signal<Sort>,
    pub version: Signal<Version>,
    pub selected: Signal<Selection>,
    pub results: Reader<SearchPage>,
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
    pub const QUERY: Source<Self, String> =
        Source::new(FieldId::new(1), "search", |m| &m.query, |m| &mut m.query);
    pub const SORT: Source<Self, Sort> =
        Source::new(FieldId::new(2), "sort", |m| &m.sort, |m| &mut m.sort);
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
    /// Readiness is distinct from playback permission. A newer selection,
    /// source or transport revision immediately makes pending Play canceled.
    pub fn preparation_status(&self) -> PreparationStatus {
        match &self.preparation {
            Preparation::Empty => PreparationStatus::Empty,
            Preparation::Pending {
                selection,
                play_revision,
            } if self.current_selection(*selection)
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
                self.preparation = Preparation::Failed {
                    selection: *self.selected,
                    error: "Library worker closed before preparation completed".into(),
                };
            } else if matches!(self.preparation, Preparation::Pending { .. }) {
                self.preparation = Preparation::Canceled;
            }
            self.notice = "Library worker closed".into();
            return;
        };
        match event {
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
                            match self.queue.play_now_if(&track, revision) {
                                Ok(true) => {}
                                Ok(false) => return,
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
            self.queue.enqueue(track);
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
        ((Library::QUERY, Library::SORT), Library::VERSION),
        |((query, sort), version)| SearchInput::freeze(query, *sort, *version),
        move |input, completion: gpui::Completion<SearchPage, crate::search::SourceError>| {
            match input {
                Ok(input) => search.search(input, completion),
                Err(error) => {
                    let _ = completion.complete(Err(error));
                    Ok(())
                }
            }
        },
    )?;
    Ok((
        Library {
            query: Signal::new(String::new()),
            sort: Signal::new(Sort::Title),
            version: Signal::new(Version::default()),
            selected: Signal::new(Selection::default()),
            results,
            preparation: Preparation::Empty,
            worker: handle,
            issued: 0,
            // Search generations use generation+1; this one stable queue owns
            // the reserved zero domain and survives database replacement.
            queue: QueueScreen::new(ListId::new(0)).map_err(|_| QuestionFault::Exhausted)?,
            notice: String::new(),
        },
        questions,
    ))
}

pub fn track_key(id: i64) -> ItemKey {
    ItemKey::new(id as u64)
}
pub fn recordings(version: Version) -> ListId {
    ListId::new(version.generation + 1)
}

impl ItemSource for SearchPage {
    fn len(&self) -> usize {
        self.rows.len()
    }
    fn key(&self, index: usize) -> ItemKey {
        track_key(self.rows[index].id)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        self.rows.iter().position(|row| track_key(row.id) == key)
    }
    fn row(&self, index: usize) -> El<'_> {
        let track = &self.rows[index];
        let id = track.id;
        let generation = self.input.version.generation;
        #[cfg(feature = "audio")]
        let play = button("Play now")
            .name(format!("Play {} now", track.title))
            .w(76)
            .h(32)
            .on_click(move |model: &mut Library| model.play_now(id, generation));
        #[cfg(not(feature = "audio"))]
        let play = text("");
        row((
            button("Prepare")
                .name(format!("Prepare {}", track.title))
                .w(64)
                .h(32)
                .on_click(move |model: &mut Library| model.prepare(id, generation)),
            play,
            text(track.title.as_str()).w(240).p(6),
            text(track.artist_names.as_deref().unwrap_or("Unknown artist"))
                .w(170)
                .p(6),
        ))
        .h(32)
        .bg(if index.is_multiple_of(2) {
            rgb(0xf1f5f9)
        } else {
            Color::WHITE
        })
    }
}

impl View for Library {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::QUERY)
            .field(Self::SORT)
            .field(Self::VERSION)
            .field(Self::SELECTED)
            .direct_component(Self::QUEUE)
    }
    fn view(&self) -> El<'_> {
        column((
            text("Hummingbird — Library").font_size(24),
            text_input(&self.query)
                .name("Search recordings")
                .description("Search titles and artists")
                .w(650)
                .h(32),
            row((
                button("Title")
                    .p(8)
                    .on_click(Self::SORT.update(|sort| *sort = Sort::Title)),
                button("Artist")
                    .p(8)
                    .on_click(Self::SORT.update(|sort| *sort = Sort::Artist)),
                button("Longest first")
                    .p(8)
                    .on_click(Self::SORT.update(|sort| *sort = Sort::Longest)),
            ))
            .gap(8),
            self.results
                .project(|page| {
                    column((
                        text(format!(
                            "{} recordings for ‘{}’ — {}",
                            page.rows.len(),
                            page.input.query,
                            page.input.sort.label()
                        )),
                        uniform_list(recordings(page.input.version), page, 32)
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
