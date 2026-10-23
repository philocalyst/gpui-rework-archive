//! Display projections adapted from upstream album/artist/playlist SQL. The
//! existing TrackQuery supplies credited-artist UNION and release ordering.
use crate::{
    browser::{
        CollectionRow, Collections, Input, Page, PlayRequest, PreparedListing, Route, TrackRows,
    },
    database::Database,
    query::{TrackColumn, TrackQuery, TrackSearchRow, tracks},
    search::{Searcher, Sort, SourceError},
};
use nucleo_matcher::pattern::{CaseMatching, Normalization, Pattern};
use rusqlite::types::Value;
use triomphe::Arc;

pub(crate) fn page(
    database: &Database,
    searcher: &mut Searcher,
    input: Arc<Input>,
    cancelled: impl FnMut() -> bool,
) -> Option<Result<Page, SourceError>> {
    let _snapshot = match database.connection().unchecked_transaction() {
        Ok(snapshot) => snapshot,
        Err(error) => return Some(Err(error.into())),
    };
    read_page(database, searcher, input, cancelled)
}
fn read_page(
    database: &Database,
    searcher: &mut Searcher,
    input: Arc<Input>,
    mut cancelled: impl FnMut() -> bool,
) -> Option<Result<Page, SourceError>> {
    if input.query.len() > crate::search::MAX_QUERY_BYTES {
        return Some(Err(SourceError::QueryTooLong));
    }
    if cancelled() {
        return None;
    }
    let result = (|| {
        let connection = database.connection();
        let title = match input.route {
            Route::Album(id) => connection
                .query_row("SELECT title FROM album WHERE id=?", [id], |row| row.get(0))
                .optional()?,
            Route::Artist(id) => connection
                .query_row("SELECT name FROM artist WHERE id=?", [id], |row| row.get(0))
                .optional()?,
            Route::Playlist(id) => connection
                .query_row("SELECT name FROM playlist WHERE id=?", [id], |row| {
                    row.get(0)
                })
                .optional()?,
            route => Some(route.label().to_owned()),
        }
        .ok_or(SourceError::MissingCollection)?;
        let Some(rows) = read_tracks(database, searcher, input.clone(), &mut cancelled) else {
            return Ok(None);
        };
        let rows = rows?;
        let mut collections = Collections {
            input: input.clone(),
            rows: Vec::new(),
        };
        let collection_query = match input.route {
            Route::Albums | Route::Artist(_) => Some((
                "SELECT album.id,album.title,COALESCE(NULLIF(album.artist_display_override,''),(SELECT GROUP_CONCAT(artist.name, ', ') FROM album_artist JOIN artist ON artist.id=album_artist.artist_id WHERE album_artist.album_id=album.id),'Unknown artist') FROM album",
                "album.title_sortable COLLATE NOCASE ASC,album.id ASC",
                0,
            )),
            Route::Artists => Some((
                "SELECT artist.id,artist.name,CAST((SELECT COUNT(*) FROM album_artist WHERE album_artist.artist_id=artist.id) AS TEXT)||' albums' FROM artist WHERE EXISTS(SELECT 1 FROM album_artist WHERE album_artist.artist_id=artist.id) OR EXISTS(SELECT 1 FROM track_artist WHERE track_artist.artist_id=artist.id)",
                "artist.name_sortable COLLATE NOCASE ASC,artist.id ASC",
                1,
            )),
            Route::Playlists => Some((
                "SELECT playlist.id,playlist.name,CAST(COUNT(playlist_item.id) AS TEXT)||' tracks' FROM playlist LEFT JOIN playlist_item ON playlist_item.playlist_id=playlist.id",
                "playlist.position ASC,playlist.id ASC",
                2,
            )),
            _ => None,
        };
        if let Some((sql, order, kind)) = collection_query {
            let mut sql = sql.to_owned();
            let mut values = Vec::<Value>::new();
            if let Route::Artist(id) = input.route {
                sql.push_str(" WHERE EXISTS(SELECT 1 FROM album_artist WHERE album_artist.album_id=album.id AND album_artist.artist_id=?)");
                values.push(id.into());
            }
            if kind == 2 {
                sql.push_str(" GROUP BY playlist.id");
            }
            sql.push_str(" ORDER BY ");
            sql.push_str(order);
            let pattern = Pattern::parse(&input.query, CaseMatching::Smart, Normalization::Smart);
            let mut statement = connection.prepare(&sql)?;
            let mut cursor = statement.query(rusqlite::params_from_iter(values))?;
            while let Some(row) = cursor.next()? {
                if cancelled() {
                    return Ok(None);
                }
                let title = row.get_ref(1)?.as_str().map_err(text_error)?;
                let detail = row.get_ref(2)?.as_str().map_err(text_error)?;
                if searcher.matches(&pattern, title, Some(detail)) {
                    let id = row.get(0)?;
                    collections.rows.push(CollectionRow {
                        route: match kind {
                            0 => Route::Album(id),
                            1 => Route::Artist(id),
                            _ => Route::Playlist(id),
                        },
                        id,
                        title: title.to_owned(),
                        detail: detail.to_owned(),
                    });
                }
            }
        }
        Ok(Some(Page {
            input,
            title,
            rows,
            collections,
        }))
    })();
    if cancelled() {
        None
    } else {
        match result {
            Ok(None) => None,
            Ok(Some(page)) => Some(Ok(page)),
            Err(error) => Some(Err(error)),
        }
    }
}
use rusqlite::OptionalExtension;
fn read_tracks(
    database: &Database,
    searcher: &mut Searcher,
    input: Arc<Input>,
    mut cancelled: impl FnMut() -> bool,
) -> Option<Result<TrackRows, SourceError>> {
    if input.query.len() > crate::search::MAX_QUERY_BYTES {
        return Some(Err(SourceError::QueryTooLong));
    }
    if cancelled() {
        return None;
    }
    let result = (|| {
        let connection = database.connection();
        let mut rows = TrackRows {
            input: input.clone(),
            rows: Vec::new(),
            playlist_items: Vec::new(),
        };
        match input.route {
            Route::Tracks | Route::Album(_) | Route::Artist(_) => {
                let base = match input.route {
                    Route::Album(id) => tracks().from_album(id),
                    Route::Artist(id) => tracks().from_artist(id),
                    _ => tracks(),
                };
                let query = ordered(base, &input);
                let Some(page) =
                    searcher.search_rows(database, &input.search, query, &mut cancelled)
                else {
                    return Ok(None);
                };
                rows.rows = page?;
            }
            Route::Playlist(id) => {
                let order = match input.sort {
                    Sort::Title => "playlist_item.position ASC, playlist_item.id ASC",
                    Sort::Artist => {
                        "COALESCE(album.artist_sort, track.artist_sort, track.artist_names) COLLATE NOCASE ASC, track.title_sortable ASC, playlist_item.id ASC"
                    }
                    Sort::Longest => {
                        "track.duration DESC, track.title_sortable COLLATE NOCASE ASC, playlist_item.id ASC"
                    }
                };
                let sql = format!(
                    "SELECT track.id,track.title,track.artist_names,track.album_id,playlist_item.id FROM playlist_item JOIN track ON track.id=playlist_item.track_id LEFT JOIN album ON album.id=track.album_id WHERE playlist_item.playlist_id=? ORDER BY {order}"
                );
                let pattern =
                    Pattern::parse(&input.query, CaseMatching::Smart, Normalization::Smart);
                let mut statement = connection.prepare(&sql)?;
                let mut cursor = statement.query([id])?;
                while let Some(row) = cursor.next()? {
                    if cancelled() {
                        return Ok(None);
                    }
                    let title = row.get_ref(1)?.as_str().map_err(text_error)?;
                    let artist = row.get_ref(2)?.as_str_or_null().map_err(text_error)?;
                    if searcher.matches(&pattern, title, artist) {
                        rows.rows.push(TrackSearchRow {
                            id: row.get(0)?,
                            title: title.to_owned(),
                            artist_names: artist.map(str::to_owned),
                            album_id: row.get(3)?,
                        });
                        rows.playlist_items.push(row.get(4)?);
                    }
                }
            }
            _ => {}
        }
        Ok(Some(rows))
    })();
    if cancelled() {
        None
    } else {
        result.transpose()
    }
}
fn ordered(query: TrackQuery, input: &Input) -> TrackQuery {
    match input.sort {
        Sort::Title if matches!(input.route, Route::Album(_)) => {
            query.sort_asc(TrackColumn::TrackNumber)
        }
        Sort::Title => query.sort_asc(TrackColumn::Title),
        Sort::Artist => query.sort_asc(TrackColumn::Artist),
        Sort::Longest => query.sort_desc(TrackColumn::Length),
    }
}
/// Materialize queue metadata only after an explicit action. The page query is
/// shared with display, so filter/order and selected occurrence cannot drift.
pub(crate) fn prepare(
    database: &Database,
    searcher: &mut Searcher,
    request: &PlayRequest,
) -> Result<PreparedListing, SourceError> {
    let _snapshot = database.connection().unchecked_transaction()?;
    let rows = read_tracks(database, searcher, request.input.clone(), || false)
        .expect("uncancelled listing")?;
    let start = match request.start {
        Some(key) => (0..rows.len())
            .find(|i| rows.identity(*i) == key)
            .ok_or(SourceError::MissingCollection)?,
        None => 0,
    };
    if rows.is_empty() {
        return Err(SourceError::NoSelection);
    }
    let mut prepared = Vec::with_capacity(rows.len());
    let mut statement = database
        .connection()
        .prepare("SELECT location FROM track WHERE id=?")?;
    for row in rows.rows {
        let path: String = statement
            .query_row([row.id], |result| result.get(0))
            .optional()?
            .ok_or(SourceError::MissingTrack(row.id))?;
        let path = std::path::PathBuf::from(path);
        prepared.push(crate::queue::TrackRef::new(crate::queue::Track {
            available_when_prepared: path.exists(),
            path,
            track_id: Some(row.id),
            album_id: row.album_id,
            title: row.title,
        }));
    }
    if !prepared[start].available_when_prepared {
        return Err(SourceError::MissingTrack(prepared[start].track_id.unwrap()));
    }
    Ok(PreparedListing {
        tracks: prepared,
        start,
    })
}

fn text_error(error: rusqlite::types::FromSqlError) -> SourceError {
    rusqlite::Error::FromSqlConversionFailure(0, rusqlite::types::Type::Text, Box::new(error))
        .into()
}
