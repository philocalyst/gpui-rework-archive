//! Application-owned SQLite source. The UI never borrows this connection.
use crate::{migrations::MIGRATIONS, query::TrackSearchRow};
use rusqlite::{Connection, OpenFlags, Result, params};
use std::path::Path;

pub struct Database {
    pub(crate) connection: Connection,
}
impl Database {
    pub fn fixture() -> Result<Self> {
        let connection = Connection::open_in_memory()?;
        connection.pragma_update(None, "foreign_keys", true)?;
        for (_, sql) in MIGRATIONS {
            connection.execute_batch(sql)?;
        }
        let mut database = Self { connection };
        database.seed()?;
        Ok(database)
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
