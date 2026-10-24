//! Application-owned SQLite source. The UI never borrows this connection.
use crate::query::TrackSearchRow;
use rusqlite::{Connection, OpenFlags, Result, TransactionBehavior, params};
use std::path::Path;

const FRESH_SCHEMA: &str = include_str!("../schema/fresh.sql");

pub struct Database {
    pub(crate) connection: Connection,
}
impl Database {
    pub fn fixture() -> Result<Self> {
        let mut connection = Connection::open_in_memory()?;
        connection.pragma_update(None, "foreign_keys", true)?;
        let transaction = connection.transaction()?;
        transaction.execute_batch(FRESH_SCHEMA)?;
        transaction.commit()?;
        let mut database = Self { connection };
        database.seed()?;
        Ok(database)
    }
    /// Real relational browser fixture, separate from the original nine-track
    /// transcript. Multiple credits, empty collections and tied playlist ranks
    /// deliberately exercise collection identity rather than display indices.
    pub fn collection_fixture() -> Result<Self> {
        let database = Self::fixture()?;
        database.connection.execute_batch("BEGIN IMMEDIATE;
            INSERT INTO artist(id,name,name_sortable) VALUES(30,'Μαρία','Μαρία'),(31,'No recordings','No recordings'),(32,'Guest','Guest');
            INSERT INTO album(id,title,title_sortable,artist_sort,artist_display_override) VALUES(40,'Album Z','Album Z','Guest','Guest');
            INSERT INTO album_artist(album_id,artist_id) VALUES(30,30),(10,2);
            INSERT INTO track_artist(track_id,artist_id) VALUES(44,1),(44,30),(44,32);
            INSERT INTO playlist(id,name,type,position) VALUES(2,'Evening Καφέ',0,2),(3,'Empty playlist',0,3);
            INSERT INTO playlist_item(id,playlist_id,track_id,position) VALUES(701,2,90,10),(702,2,44,0),(703,2,11,10);
        ")?;
        for (id, extension) in [(44, "wav"), (90, "flac"), (11, "mp3")] {
            let path = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
                .join(format!("assets/audio/stereo.{extension}"));
            database.connection.execute(
                "UPDATE track SET location=? WHERE id=?",
                params![path.to_str().unwrap(), id],
            )?;
        }
        database.connection.execute_batch("COMMIT")?;
        Ok(database)
    }
    /// Create or reopen this port's persistent writable library. An unrelated
    /// existing Hummingbird database keeps the separate read-only API; its
    /// schema is never guessed, rewritten or reseeded by this constructor.
    pub fn open_library(path: &Path) -> Result<Self, crate::search::SourceError> {
        let mut connection = Connection::open(path)?;
        connection.pragma_update(None, "foreign_keys", true)?;
        Self::initialize_library(&mut connection)?;
        Ok(Self { connection })
    }
    fn initialize_library(connection: &mut Connection) -> Result<(), crate::search::SourceError> {
        // Serialize creators before checking admission. Schema, seed and marker
        // publish together; a failed creation rolls back to an empty database.
        let transaction = connection.transaction_with_behavior(TransactionBehavior::Immediate)?;
        let marked: bool = transaction.query_row(
            "SELECT EXISTS(SELECT 1 FROM sqlite_schema WHERE type='table' AND name='_gpui_library')",
            [],
            |row| row.get(0),
        )?;
        if !marked {
            let occupied: bool = transaction.query_row(
                "SELECT EXISTS(SELECT 1 FROM sqlite_schema WHERE name NOT GLOB 'sqlite_*')",
                [],
                |row| row.get(0),
            )?;
            if occupied {
                return Err(crate::search::SourceError::UnknownLibrarySchema);
            }
            transaction.execute_batch(FRESH_SCHEMA)?;
            transaction.execute_batch("CREATE TABLE _gpui_library(version INTEGER NOT NULL); INSERT INTO _gpui_library VALUES(1)")?;
        }
        let (markers, version): (i64, Option<i64>) = transaction.query_row(
            "SELECT COUNT(*),MIN(version) FROM _gpui_library",
            [],
            |row| Ok((row.get(0)?, row.get(1)?)),
        )?;
        if markers != 1 || version != Some(1) {
            return Err(crate::search::SourceError::UnknownLibrarySchema);
        }
        transaction.commit()?;
        // Acquisition tables remain at the worker's source-admission boundary.
        Ok(())
    }
    pub(crate) fn initialize_index(&self) -> Result<()> {
        if self.connection.is_readonly("main")? {
            return Ok(());
        }
        let transaction = self.connection.unchecked_transaction()?;
        transaction.execute_batch(
            "CREATE TABLE IF NOT EXISTS _gpui_root(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                path TEXT NOT NULL UNIQUE
            );
            CREATE TABLE IF NOT EXISTS _gpui_index_file(
                location TEXT PRIMARY KEY,
                track_id INTEGER NOT NULL UNIQUE REFERENCES track(id) ON DELETE CASCADE
            );
            CREATE TABLE IF NOT EXISTS _gpui_index_member(
                root_id INTEGER NOT NULL REFERENCES _gpui_root(id) ON DELETE CASCADE,
                location TEXT NOT NULL REFERENCES _gpui_index_file(location) ON DELETE CASCADE,
                PRIMARY KEY(root_id,location)
            );",
        )?;
        transaction.commit()
    }
    /// Existing Hummingbird libraries are read without migrating or seeding them.
    pub fn open_read_only(path: &Path) -> Result<Self> {
        Ok(Self {
            connection: Connection::open_with_flags(path, OpenFlags::SQLITE_OPEN_READ_ONLY)?,
        })
    }
    pub fn connection(&self) -> &Connection {
        &self.connection
    }

    // Adapted verbatim SQL and values from Hummingbird db/tests.rs:9–33,49–75,
    // 598–635. Only the SQLx bind/await transport is replaced; see UPSTREAM.json.
    fn insert_album(&self, id: i64, title: &str, artist_sort: &str) -> Result<()> {
        self.connection.execute(
            "INSERT INTO album (
             id, title, title_sortable, artist_sort, release_date, date_precision, label,
             catalog_number
         ) VALUES ($1, $2, $2, $3, $4, 1, $5, $6)",
            params![
                id,
                title,
                artist_sort,
                Option::<&str>::None,
                Option::<&str>::None,
                Option::<&str>::None
            ],
        )?;
        Ok(())
    }
    pub fn insert_track(
        &self,
        id: i64,
        title: &str,
        album_id: Option<i64>,
        artist: Option<&str>,
        duration: i64,
        number: Option<i32>,
    ) -> Result<()> {
        self.connection.execute(
            "INSERT INTO track (
             id, title, title_sortable, album_id, track_number, disc_number, duration, location,
             artist_names, artist_sort
         ) VALUES ($1, $2, $2, $3, $4, $5, $6, $7, $8, $8)",
            params![
                id,
                title,
                album_id,
                number,
                number.map(|_| 1),
                duration,
                format!("/music/{id}.flac"),
                artist
            ],
        )?;
        Ok(())
    }
    fn seed(&mut self) -> Result<()> {
        self.connection.execute_batch("BEGIN IMMEDIATE")?;
        for (id, name) in [(1, "Alpha Artist"), (2, "Beta Artist")] {
            self.connection.execute(
                "INSERT INTO artist (id, name, name_sortable) VALUES ($1, $2, $2)",
                params![id, name],
            )?;
        }
        self.insert_album(10, "Album", "Alpha Artist")?;
        self.connection.execute(
            "INSERT INTO album_artist (album_id, artist_id) VALUES (10, 1)",
            [],
        )?;
        self.insert_track(1, "Album Track", Some(10), None, 100, Some(1))?;
        self.insert_track(2, "Standalone Track", None, Some("Alpha Artist"), 100, None)?;
        self.insert_track(3, "Other Track", Some(10), None, 100, Some(2))?;
        for id in [1, 2] {
            self.connection.execute(
                "INSERT INTO track_artist (track_id, artist_id) VALUES ($1, 1)",
                [id],
            )?;
        }
        self.connection.execute(
            "INSERT INTO playlist_item (playlist_id, track_id, position) VALUES (1, 2, 0)",
            [],
        )?;

        // Port-specific additions to the original three-row fixture: non-index
        // IDs, tied titles/durations, nullable artist and album, and real UTF-8.
        self.insert_album(20, "Album Z", "Beta Artist")?;
        self.connection.execute(
            "INSERT INTO album_artist (album_id, artist_id) VALUES (20, 2)",
            [],
        )?;
        self.insert_album(30, "Καφέ", "Μαρία")?;
        for (id, title, album, artist, duration) in [
            (11, "Café Étude", Some(20), Some("Zoë"), 240),
            (21, "Café Étude", Some(20), Some("Zoë"), 240),
            (13, "CAFE Étude", Some(20), Some("Zoë"), 260),
            (44, "Καλημέρα", Some(30), Some("Μαρία"), 180),
            (90, "Untitled", None, None, 200),
            (1001, "אבג العربية", None, Some("نور"), 180),
        ] {
            self.insert_track(id, title, album, artist, duration, Some(1))?;
        }
        self.connection.execute(
            "UPDATE track SET location = '/music/z.flac' WHERE id = 21",
            [],
        )?;
        for (id, name) in [(10, "Ambient"), (20, "Classical")] {
            self.connection.execute(
                "INSERT INTO genre (id, name, normalized_name) VALUES ($1, $2, LOWER($2))",
                params![id, name],
            )?;
        }
        for (track, genre) in [(1, 10), (90, 10), (11, 20), (13, 20), (21, 20)] {
            self.connection.execute(
                "INSERT INTO track_genre (track_id, genre_id, position) VALUES ($1, $2, 0)",
                [track, genre],
            )?;
        }
        self.connection.execute_batch("COMMIT")?;
        Ok(())
    }
    pub(crate) fn prepend_fixture_track(&mut self) -> Result<TrackSearchRow> {
        let transaction = self.connection.unchecked_transaction()?;
        self.insert_track(5000, "A New Arrival", None, Some("New Artist"), 220, None)?;
        let row = crate::query::tracks()
            .by_id(5000)
            .for_search()
            .fetch_rows(&self.connection)?
            .remove(0);
        transaction.commit()?;
        Ok(row)
    }
}

#[cfg(test)]
mod tests;
