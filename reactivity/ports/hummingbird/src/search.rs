//! Hummingbird track search corpus and actual Nucleo matching, off the UI thread.
// Adapted from upstream search/model.rs and components/palette/finder.rs,
// e15e8ba0 (Apache-2.0); hashes and adaptation scope are in ../UPSTREAM.json.
use crate::{
    database::Database,
    query::{TrackColumn, TrackSearchRow, tracks},
};
use nucleo_matcher::{
    Config, Matcher, Utf32Str,
    pattern::{CaseMatching, Normalization, Pattern},
};
use std::fmt;

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum Sort {
    #[default]
    Title,
    Artist,
    Longest,
}
impl Sort {
    pub fn label(self) -> &'static str {
        match self {
            Self::Title => "Title",
            Self::Artist => "Artist",
            Self::Longest => "Longest first",
        }
    }
}
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Version {
    pub revision: u64,
    pub generation: u64,
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct SearchInput {
    pub query: String,
    pub sort: Sort,
    pub version: Version,
}
pub const MAX_QUERY_BYTES: usize = 1024;
impl SearchInput {
    pub fn freeze(query: &str, sort: Sort, version: Version) -> Result<Self, SourceError> {
        if query.len() > MAX_QUERY_BYTES {
            return Err(SourceError::QueryTooLong);
        }
        Ok(Self {
            query: query.to_owned(),
            sort,
            version,
        })
    }
}
#[derive(Debug)]
pub enum SourceError {
    Sqlite(rusqlite::Error),
    QueryTooLong,
    MissingTrack(i64),
    MissingCollection,
    SourceAuthorityUnavailable,
    SourceClosed,
    SourceNotCommitted,
    NoSelection,
    OutdatedSource,
    VersionExhausted,
    NotificationsUnavailable,
}
impl fmt::Display for SourceError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Sqlite(error) => write!(f, "Library source: {error}"),
            Self::QueryTooLong => f.write_str("Use at most 1,024 UTF-8 bytes in a search"),
            Self::NoSelection => f.write_str("No recording selected"),
            Self::MissingTrack(id) => write!(f, "Recording {id} is no longer available"),
            Self::MissingCollection => {
                f.write_str("This collection or occurrence is no longer available")
            }
            Self::SourceNotCommitted => {
                f.write_str("Commit the source database before attaching it")
            }
            Self::SourceClosed => f.write_str("Library worker is closed"),
            Self::SourceAuthorityUnavailable => {
                f.write_str("Library source authority is unavailable")
            }
            Self::OutdatedSource => f.write_str("The library source changed"),
            Self::VersionExhausted => f.write_str("Library revision space exhausted"),
            Self::NotificationsUnavailable => f.write_str("Library updates are unavailable"),
        }
    }
}
impl std::error::Error for SourceError {}
impl From<rusqlite::Error> for SourceError {
    fn from(value: rusqlite::Error) -> Self {
        Self::Sqlite(value)
    }
}

pub struct SearchPage {
    pub input: SearchInput,
    pub rows: Vec<TrackSearchRow>,
}
impl SearchPage {
    pub fn ids(&self) -> impl Iterator<Item = i64> + '_ {
        self.rows.iter().map(|row| row.id)
    }
}

/// Exclusive worker scratch. Matching uses the same DEFAULT configuration,
/// title+artists corpus, Smart case and Smart normalization as Hummingbird.
/// This sortable library retains SQL order among matches; the upstream command
/// palette separately ranks by score and caps at100, which is not ported here.
pub struct Searcher {
    matcher: Matcher,
    utf32: Vec<char>,
    corpus: String,
}
impl Default for Searcher {
    fn default() -> Self {
        Self {
            matcher: Matcher::new(Config::DEFAULT),
            utf32: Vec::new(),
            corpus: String::new(),
        }
    }
}
impl Searcher {
    /// Cancellation is checked before SQLite, between fetched rows, between
    /// matching candidates, and before publishing. SQLite's internal sort/step
    /// is not preempted; no UI thread executes or waits for that work.
    pub fn search(
        &mut self,
        database: &Database,
        input: SearchInput,
        cancelled: impl FnMut() -> bool,
    ) -> Option<Result<SearchPage, SourceError>> {
        let query = match input.sort {
            Sort::Title => tracks().sort_asc(TrackColumn::Title),
            Sort::Artist => tracks().sort_asc(TrackColumn::Artist),
            Sort::Longest => tracks().sort_desc(TrackColumn::Length),
        };
        self.search_rows(database, &input, query, cancelled)
            .map(|result| result.map(|rows| SearchPage { input, rows }))
    }
    pub(crate) fn search_rows(
        &mut self,
        database: &Database,
        input: &SearchInput,
        query: crate::query::TrackQuery,
        mut cancelled: impl FnMut() -> bool,
    ) -> Option<Result<Vec<TrackSearchRow>, SourceError>> {
        if cancelled() {
            return None;
        }
        if input.query.len() > MAX_QUERY_BYTES {
            return Some(Err(SourceError::QueryTooLong));
        }
        let pattern = Pattern::parse(&input.query, CaseMatching::Smart, Normalization::Smart);
        let rows = match query.for_search().fetch_matching(
            database.connection(),
            &mut cancelled,
            |title, artists| self.matches(&pattern, title, artists),
        ) {
            Ok(Some(rows)) => rows,
            Ok(None) => return None,
            Err(error) => return Some(Err(error.into())),
        };
        Some(Ok(rows))
    }
    pub(crate) fn matches(
        &mut self,
        pattern: &Pattern,
        title: &str,
        artists: Option<&str>,
    ) -> bool {
        self.corpus.clear();
        self.corpus.push_str(title);
        self.corpus.push(' ');
        self.corpus.push_str(artists.unwrap_or_default());
        pattern
            .score(
                Utf32Str::new(&self.corpus, &mut self.utf32),
                &mut self.matcher,
            )
            .is_some()
    }
}
