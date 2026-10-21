//! One bounded question over the Library catalogue protocol. The model stores
//! domain state and an inert Reader; this explicitly owned service holds its
//! worker outside the model. No executor, completion or loading flag is a field.
use gpui::{Completion, Failure, Reader, StartError, prelude::*};
use std::{
    fmt::{self, Write},
    sync::mpsc,
};

use super::library::catalogue::{Catalogue, TrackId};
pub const RESULTS: ListId = ListId::new(1);
pub const PAGE_LIMIT: usize = 128;
pub const QUERY_BYTES: usize = 256;
pub const CANCELLATION_BATCH: usize = 128;

#[derive(Clone)]
pub struct Query {
    bytes: [u8; QUERY_BYTES],
    length: u16,
}
impl Query {
    fn freeze(value: &str) -> Result<Self, SearchError> {
        if value.len() > QUERY_BYTES {
            return Err(SearchError::QueryTooLong);
        }
        let mut query = Self {
            bytes: [0; QUERY_BYTES],
            length: value.len() as u16,
        };
        query.bytes[..value.len()].copy_from_slice(value.as_bytes());
        Ok(query)
    }
    pub fn as_str(&self) -> &str {
        std::str::from_utf8(&self.bytes[..self.length as usize]).expect("copied valid UTF-8")
    }
}
pub struct SearchInput {
    query: Result<Query, SearchError>,
    count: usize,
}
pub fn freeze(value: &str, count: usize) -> SearchInput {
    SearchInput {
        query: Query::freeze(value),
        count,
    }
}
#[derive(Debug, PartialEq, Eq)]
pub enum SearchError {
    QueryTooLong,
}
impl fmt::Display for SearchError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str("Use at most 256 UTF-8 bytes in a search")
    }
}
impl std::error::Error for SearchError {}

pub struct SearchPage {
    pub query: Query,
    pub ids: Vec<TrackId>,
    pub matches: usize,
    #[allow(dead_code)] // Explicit work count consumed by tests and the cost fixture.
    pub scanned: usize,
}
// Generated catalogue titles are immutable definitions. Freeze their count,
// never borrow the live catalogue or copy its mutable ordering into a worker.
struct Title {
    bytes: [u8; 64],
    length: usize,
}
impl Title {
    fn as_bytes(&self) -> &[u8] {
        &self.bytes[..self.length]
    }
}
impl Write for Title {
    fn write_str(&mut self, value: &str) -> fmt::Result {
        let Some(end) = self
            .length
            .checked_add(value.len())
            .filter(|&n| n <= self.bytes.len())
        else {
            return Err(fmt::Error);
        };
        self.bytes[self.length..end].copy_from_slice(value.as_bytes());
        self.length = end;
        Ok(())
    }
}
#[cfg(test)] // The uncancelled oracle and cost fixture share the real scan.
pub fn search(input: SearchInput) -> Result<SearchPage, SearchError> {
    search_cancellable(input, |_| false).expect("uncancelled search completes")
}
/// The callback observes progress at most 128 tracks apart, including before
/// allocation and after the final batch. True discards the partial page. The
/// production worker reads only its borrowed completion cancellation hint.
pub fn search_cancellable(
    input: SearchInput,
    mut cancelled: impl FnMut(usize) -> bool,
) -> Option<Result<SearchPage, SearchError>> {
    if cancelled(0) {
        return None;
    }
    let query = match input.query {
        Ok(query) => query,
        Err(error) => return Some(Err(error)),
    };
    let needle = query.as_str().as_bytes();
    let mut ids = Vec::with_capacity(PAGE_LIMIT);
    let mut matches = 0;
    for index in 0..input.count {
        if index != 0 && index.is_multiple_of(CANCELLATION_BATCH) && cancelled(index) {
            return None;
        }
        let mut title = Title {
            bytes: [0; 64],
            length: 0,
        };
        write!(&mut title, "Track {index:06} — Library recording").unwrap();
        if needle.is_empty()
            || title
                .as_bytes()
                .windows(needle.len())
                .any(|part| part.eq_ignore_ascii_case(needle))
        {
            matches += 1;
            if ids.len() < PAGE_LIMIT {
                ids.push(TrackId(index as u64));
            }
        }
    }
    if cancelled(input.count) {
        return None;
    }
    Some(Ok(SearchPage {
        query,
        ids,
        matches,
        scanned: input.count,
    }))
}
type Job = (SearchInput, Completion<SearchPage, SearchError>);
/// Explicit one-worker service: one queued job, 256 KiB reserved stack, one
/// running job. Dropping its sender closes the loop after owned work returns;
/// the UI never joins a worker or waits for channel space.
pub struct SearchWorker {
    sender: mpsc::SyncSender<Job>,
}
impl SearchWorker {
    pub fn new() -> std::io::Result<Self> {
        let (sender, receiver) = mpsc::sync_channel::<Job>(1);
        std::thread::Builder::new()
            .name("library-search".into())
            .stack_size(256 * 1024)
            .spawn(move || {
                while let Ok((input, completion)) = receiver.recv() {
                    // Stop obsolete work at the next bounded checkpoint. None
                    // abandons only this physical cap and wakes owner admission.
                    let _ = completion.run_cancellable(input, |input, cancellation| {
                        search_cancellable(input, |_| cancellation.is_cancelled())
                    });
                }
            })?;
        Ok(Self { sender })
    }
    pub fn start(
        &mut self,
        input: SearchInput,
        completion: Completion<SearchPage, SearchError>,
    ) -> Result<(), StartError> {
        self.sender
            .try_send((input, completion))
            .map_err(|error| match error {
                mpsc::TrySendError::Full(_) => StartError::Busy,
                mpsc::TrySendError::Disconnected(_) => StartError::Closed,
            })
    }
}

pub struct SearchLibrary {
    pub query: Signal<String>,
    pub results: Reader<SearchPage>,
    pub selected: Signal<u64>,
    catalogue: Catalogue,
}
/// Persist domain inputs, not Reader keys, queued work or executor authority.
#[derive(serde::Serialize, serde::Deserialize)]
pub struct LibraryState {
    query: String,
    selected: u64,
    count: usize,
}
impl SearchLibrary {
    pub const QUERY: Source<Self, String> =
        Source::new(FieldId::new(1), "search", |m| &m.query, |m| &mut m.query);
    pub const SELECTED: Source<Self, u64> = Source::new(
        FieldId::new(2),
        "selected",
        |m| &m.selected,
        |m| &mut m.selected,
    );
    pub fn new(count: usize, results: Reader<SearchPage>) -> Self {
        Self {
            query: Signal::new(String::new()),
            results,
            selected: Signal::new(u64::MAX),
            catalogue: Catalogue::new(count),
        }
    }
    #[allow(dead_code)] // Domain restoration is exercised by the public owner test.
    pub fn save(&self) -> LibraryState {
        LibraryState {
            query: self.query.to_string(),
            selected: *self.selected,
            count: self.catalogue.len(),
        }
    }
    #[allow(dead_code)]
    pub fn restore(state: LibraryState, results: Reader<SearchPage>) -> Self {
        Self {
            query: Signal::new(state.query),
            selected: Signal::new(state.selected),
            results,
            catalogue: Catalogue::new(state.count),
        }
    }
}
impl ItemSource for SearchPage {
    fn len(&self) -> usize {
        self.ids.len()
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(self.ids[index].0)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        self.ids.iter().position(|id| id.0 == key.get())
    }
    fn row(&self, index: usize) -> El<'_> {
        let id = self.ids[index];
        let title = format!("Track {:06} — Library recording", id.0);
        row((
            button("Play")
                .name(format!("Play {title}"))
                .p(6)
                .on_click(SearchLibrary::SELECTED.update(move |selected| *selected = id.0)),
            text(title).p(6),
        ))
        .h(32)
    }
}
fn failed(failure: Failure<'_>) -> El<'_> {
    text(format!("Search unavailable: {failure}"))
}
fn results(reader: Reader<SearchPage>) -> El<'static> {
    reader
        .project(|page| {
            column((
                // The query paired with these rows is part of the frozen answer. A new
                // input value never relabels the preceding rows as its current result.
                text(format!(
                    "{} matches for ‘{}’ — showing at most {PAGE_LIMIT}",
                    page.matches,
                    page.query.as_str()
                )),
                uniform_list(RESULTS, page, 32)
                    .name("Matching recordings")
                    .w(700)
                    .h(400),
            ))
        })
        .loading(|| text("Searching recordings…"))
        .failed(failed)
}
impl View for SearchLibrary {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::QUERY).direct(Self::SELECTED)
    }
    fn view(&self) -> El<'_> {
        column((
            text(format!(
                "Library — {} indexed recordings",
                self.catalogue.len()
            ))
            .font_size(24),
            text_input(&self.query)
                .name("Search recordings")
                .description("Search titles; up to 128 matching rows are returned")
                .w(700)
                .h(32),
            results(self.results),
            row((text("Selected recording ID:"), text(&self.selected))).gap(8),
        ))
        .p(12)
        .gap(8)
    }
}
