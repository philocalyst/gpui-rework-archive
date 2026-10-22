// Adapted from Hummingbird (Apache-2.0), e15e8ba0, library/db/query/track.rs
// and library/db/direction.rs. Exact upstream file hashes: ../UPSTREAM.json.
// Retains the original search/ID/playback SQL projections and ordering/filter
// clauses; execution uses rusqlite instead of SQLx. Other projections are absent.
use rusqlite::{Connection, Result, params_from_iter, types::Value};
use std::path::{Path, PathBuf};

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum SortDirection {
    #[default]
    Ascending,
    Descending,
}
impl SortDirection {
    const fn sql(self) -> &'static str {
        match self {
            Self::Ascending => " ASC",
            Self::Descending => " DESC",
        }
    }
}
#[derive(Clone, Copy, Debug, Hash, PartialEq, Eq)]
pub enum TrackColumn {
    TrackNumber,
    Title,
    Album,
    Artist,
    Genres,
    Length,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct TrackOrdering {
    key: TrackOrderingKey,
    direction: SortDirection,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum TrackOrderingKey {
    Column(TrackColumn),
    ReleaseDate,
    RecentlyAdded,
}
#[derive(Clone, Copy, Debug)]
enum ArtistFilter {
    Credited(i64),
    Liked(i64),
    Standalone(i64),
}

#[derive(Clone, Debug, Default)]
pub struct TrackQuery {
    id: Option<i64>,
    path: Option<String>,
    locations: Vec<String>,
    album_id: Option<i64>,
    artist_filter: Option<ArtistFilter>,
    ordering: Option<TrackOrdering>,
}
#[derive(Clone, Debug)]
pub struct TrackQueryForSearch {
    query: TrackQuery,
}
#[derive(Clone, Debug)]
pub struct TrackQueryForPlayback {
    query: TrackQuery,
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct TrackSearchRow {
    pub id: i64,
    pub title: String,
    pub artist_names: Option<String>,
    pub album_id: Option<i64>,
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct TrackPlaybackRow {
    pub id: i64,
    pub album_id: Option<i64>,
    pub location: PathBuf,
}

#[derive(Clone, Copy)]
enum TrackProjection {
    Id,
    Search,
    Playback,
}

pub fn tracks() -> TrackQuery {
    TrackQuery::default()
}

impl TrackQuery {
    pub fn by_id(mut self, id: i64) -> Self {
        self.id = Some(id);
        self
    }
    pub fn at_path(mut self, path: &Path) -> Self {
        self.path = Some(path.to_string_lossy().into_owned());
        self
    }
    pub fn at_locations(mut self, locations: impl IntoIterator<Item = String>) -> Self {
        self.locations = locations.into_iter().collect();
        self
    }
    #[allow(clippy::wrong_self_convention)]
    pub fn from_album(mut self, album_id: i64) -> Self {
        self.album_id = Some(album_id);
        self
    }
    #[allow(clippy::wrong_self_convention)]
    pub fn from_artist(mut self, artist_id: i64) -> Self {
        self.artist_filter = Some(ArtistFilter::Credited(artist_id));
        self
    }
    pub fn liked_by_artist(mut self, artist_id: i64) -> Self {
        self.artist_filter = Some(ArtistFilter::Liked(artist_id));
        self
    }
    pub fn standalone_for_artist(mut self, artist_id: i64) -> Self {
        self.artist_filter = Some(ArtistFilter::Standalone(artist_id));
        self
    }
    pub fn sort_asc(self, column: TrackColumn) -> Self {
        self.sort(column, SortDirection::Ascending)
    }
    pub fn sort_desc(self, column: TrackColumn) -> Self {
        self.sort(column, SortDirection::Descending)
    }
    pub fn sort(mut self, column: TrackColumn, direction: SortDirection) -> Self {
        self.ordering = Some(TrackOrdering {
            key: TrackOrderingKey::Column(column),
            direction,
        });
        self
    }
    pub fn sort_release(mut self, direction: SortDirection) -> Self {
        self.ordering = Some(TrackOrdering {
            key: TrackOrderingKey::ReleaseDate,
            direction,
        });
        self
    }
    pub fn sort_recently_added(mut self, direction: SortDirection) -> Self {
        self.ordering = Some(TrackOrdering {
            key: TrackOrderingKey::RecentlyAdded,
            direction,
        });
        self
    }
    /// Projection only, exactly as upstream: matching is performed by Nucleo.
    pub fn for_search(self) -> TrackQueryForSearch {
        TrackQueryForSearch { query: self }
    }
    pub fn for_playback(self) -> TrackQueryForPlayback {
        TrackQueryForPlayback { query: self }
    }
    pub fn fetch_ids(self, connection: &Connection) -> Result<Vec<i64>> {
        let query = self.build(TrackProjection::Id);
        connection
            .prepare(&query.sql)?
            .query_map(params_from_iter(query.bindings), |row| row.get(0))?
            .collect()
    }
    fn build(self, projection: TrackProjection) -> Statement {
        let needs_album = self.ordering.is_some_and(|ordering| {
            matches!(
                ordering.key,
                TrackOrderingKey::Column(TrackColumn::Album | TrackColumn::Artist)
                    | TrackOrderingKey::ReleaseDate
            )
        });
        let needs_genres = self
            .ordering
            .is_some_and(|ordering| ordering.key == TrackOrderingKey::Column(TrackColumn::Genres));
        let mut query = Statement::new("SELECT ");
        query.push(match projection {
            TrackProjection::Id => "track.id",
            TrackProjection::Search => "track.id, track.title, track.artist_names, track.album_id",
            TrackProjection::Playback => "track.id, track.album_id, track.location",
        });
        query.push(" FROM track");
        if needs_album {
            query.push(" LEFT JOIN album ON album.id = track.album_id");
        }
        if needs_genres {
            query.push(
                " LEFT JOIN (
                    SELECT DISTINCT
                        track_genre.track_id,
                        GROUP_CONCAT(genre.normalized_name, CHAR(31)) OVER (
                            PARTITION BY track_genre.track_id
                            ORDER BY track_genre.position
                            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                        ) AS genre_sort
                    FROM track_genre
                    JOIN genre ON genre.id = track_genre.genre_id
                ) AS genres ON genres.track_id = track.id",
            );
        }
        let mut has_filter = false;
        if let Some(id) = self.id {
            push_filter_prefix(&mut query, &mut has_filter);
            query.push("track.id = ").push_bind(id);
        }
        if let Some(path) = self.path {
            push_filter_prefix(&mut query, &mut has_filter);
            query.push("track.location = ").push_bind(path);
        }
        if !self.locations.is_empty() {
            push_filter_prefix(&mut query, &mut has_filter);
            query.push("track.location IN (");
            for (index, location) in self.locations.into_iter().enumerate() {
                if index != 0 {
                    query.push(", ");
                }
                query.push_bind(location);
            }
            query.push(")");
        }
        if let Some(album_id) = self.album_id {
            push_filter_prefix(&mut query, &mut has_filter);
            query.push("track.album_id = ").push_bind(album_id);
        }
        if let Some(artist_filter) = self.artist_filter {
            push_filter_prefix(&mut query, &mut has_filter);
            push_artist_filter(&mut query, artist_filter);
        }
        if let Some(ordering) = self.ordering {
            query.push(" ORDER BY ");
            push_ordering_key(&mut query, ordering, self.artist_filter, true);
            push_tie_breakers(&mut query, ordering, self.artist_filter);
        }
        query
    }
}
impl TrackQueryForSearch {
    pub fn fetch_rows(self, connection: &Connection) -> Result<Vec<TrackSearchRow>> {
        Ok(self
            .fetch_matching(connection, || false, |_, _| true)?
            .expect("uncancelled query completes"))
    }
    /// Match while SQLite owns the row text. Only accepted rows acquire owned
    /// strings; no borrowed SQLite value survives the next statement step.
    pub(crate) fn fetch_matching(
        self,
        connection: &Connection,
        mut cancelled: impl FnMut() -> bool,
        mut matches: impl FnMut(&str, Option<&str>) -> bool,
    ) -> Result<Option<Vec<TrackSearchRow>>> {
        let query = self.query.build(TrackProjection::Search);
        let mut statement = connection.prepare(&query.sql)?;
        let mut rows = statement.query(params_from_iter(query.bindings))?;
        let mut output = Vec::new();
        while let Some(row) = rows.next()? {
            if cancelled() {
                return Ok(None);
            }
            let id = row.get(0)?;
            let title = row.get_ref(1)?.as_str()?;
            let artist_names = row.get_ref(2)?.as_str_or_null()?;
            let album_id = row.get(3)?;
            if matches(title, artist_names) {
                output.push(TrackSearchRow {
                    id,
                    title: title.to_owned(),
                    artist_names: artist_names.map(str::to_owned),
                    album_id,
                });
            }
        }
        Ok((!cancelled()).then_some(output))
    }
}
impl TrackQueryForPlayback {
    pub fn fetch_rows(self, connection: &Connection) -> Result<Vec<TrackPlaybackRow>> {
        let query = self.query.build(TrackProjection::Playback);
        connection
            .prepare(&query.sql)?
            .query_map(params_from_iter(query.bindings), |row| {
                Ok(TrackPlaybackRow {
                    id: row.get(0)?,
                    album_id: row.get(1)?,
                    location: PathBuf::from(row.get::<_, String>(2)?),
                })
            })?
            .collect()
    }
}

// Parameter binding only; all SQL fragments above/below are application source.
struct Statement {
    sql: String,
    bindings: Vec<Value>,
}
impl Statement {
    fn new(sql: &str) -> Self {
        Self {
            sql: sql.into(),
            bindings: Vec::new(),
        }
    }
    fn push(&mut self, sql: &str) -> &mut Self {
        self.sql.push_str(sql);
        self
    }
    fn push_bind(&mut self, value: impl Into<Value>) -> &mut Self {
        self.bindings.push(value.into());
        self.sql.push('?');
        self
    }
}

include!("query_helpers.rs");
