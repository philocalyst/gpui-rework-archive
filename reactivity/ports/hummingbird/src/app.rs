//! One public GPUI View, shared by the ordinary native and headless owners.
use crate::{
    queue::TrackRef,
    queue_view::QueueScreen,
    search::{SearchInput, SearchPage, Sort, Version},
    worker::{LibraryEvent, PlaybackRequest, Selection, WorkerHandle},
};
use gpui::{LaneSet, QuestionFault, Questions, Reader, prelude::*};

pub struct Library {
    pub query: Signal<String>,
    pub sort: Signal<Sort>,
    pub version: Signal<Version>,
    pub selected: Signal<Selection>,
    pub results: Reader<SearchPage>,
    pub playback: Reader<PlaybackRequest>,
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
    pub fn receive(&mut self, event: LibraryEvent) {
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
                        generation: version.generation,
                        ..Selection::default()
                    };
                    self.notice = "Library source changed".into();
                }
            }
        }
    }
    fn play(&mut self, id: i64, generation: u64) {
        if generation == self.version.generation {
            let Some(sequence) = self.selected.sequence.checked_add(1) else {
                self.notice = "Play request space exhausted".into();
                return;
            };
            *self.selected = Selection {
                id: Some(id),
                sequence,
                generation,
            };
        } else {
            self.notice = "This recording belongs to the previous library source".into();
        }
    }
    fn enqueue(&mut self, track: TrackRef, generation: u64) {
        if generation == self.version.generation {
            self.queue.enqueue(track);
        } else {
            self.notice = "This prepared recording belongs to the previous library source".into();
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
    let (questions, playback) = questions.question(
        Library::SELECTED,
        |selection| *selection,
        move |selection, completion| handle.play(selection, completion),
    )?;
    Ok((
        Library {
            query: Signal::new(String::new()),
            sort: Signal::new(Sort::Title),
            version: Signal::new(Version::default()),
            selected: Signal::new(Selection::default()),
            results,
            playback,
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
        row((
            button("Play")
                .name(format!("Play {}", track.title))
                .w(64)
                .h(32)
                .on_click(move |model: &mut Library| model.play(id, generation)),
            text(track.title.as_str()).w(280).p(6),
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
            self.playback
                .project(|request| {
                    if let Some(track) = &request.track {
                        let leased = track.clone();
                        let generation = request.selection.generation;
                        column((
                            text(format!(
                                "Play request {}: recording {} — {}",
                                request.selection.sequence,
                                track.track_id.unwrap(),
                                track.path.display()
                            )),
                            button(format!(
                                "Add prepared recording {} to queue",
                                track.track_id.unwrap()
                            ))
                            .on_click(move |model: &mut Library| {
                                model.enqueue(leased.clone(), generation)
                            }),
                        ))
                    } else {
                        text("No recording selected")
                    }
                })
                .loading(|| text("Preparing playback request…"))
                .failed(|failure| text(format!("Recording unavailable: {failure}"))),
            text(self.notice.as_str()),
            Self::QUEUE.view(self),
        ))
        .p(12)
        .gap(10)
    }
}
