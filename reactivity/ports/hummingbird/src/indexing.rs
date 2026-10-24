//! Explicit library acquisition on the existing SQLite worker. Discovery writes
//! private TEMP staging; public rows change in one final transaction only.
use crate::{
    database::Database,
    metadata,
    search::{SourceError, Version},
};
use rusqlite::{Connection, OptionalExtension, Row, params};
use std::{
    fs,
    path::{Path, PathBuf},
};
use symphonia::core::formats::probe::Probe;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Request {
    pub version: Version,
    pub sequence: u64,
}
#[derive(Debug)]
pub enum Command {
    AddRoot(PathBuf),
    RemoveRoot { id: i64, delete_recordings: bool },
    Scan,
    Cancel,
}
#[derive(Debug, Default)]
pub struct Report {
    pub examined: u64,
    pub indexed: u64,
    pub unchanged: u64,
    pub removed: u64,
    pub failed: u64,
    pub first_error: Option<SourceError>,
}
impl Report {
    fn failure(&mut self, error: SourceError) -> Result<(), SourceError> {
        self.failed = self
            .failed
            .checked_add(1)
            .ok_or(SourceError::IndexExhausted)?;
        self.first_error.get_or_insert(error);
        Ok(())
    }
}
#[derive(Debug)]
pub enum Outcome {
    RootsChanged,
    Indexed(Report),
    Canceled,
}
#[derive(Debug)]
pub struct Root {
    pub id: i64,
    pub path: PathBuf,
}
fn writable(connection: &Connection) -> Result<(), SourceError> {
    if connection.is_readonly("main")? {
        return Err(SourceError::ReadOnlyLibrary);
    }
    Ok(())
}
pub(crate) fn roots(database: &Database) -> Result<Vec<Root>, SourceError> {
    // Read-only upstream libraries have no port root configuration.
    if database.connection().is_readonly("main")? {
        return Err(SourceError::ReadOnlyLibrary);
    }
    let mut statement = database
        .connection()
        .prepare("SELECT id,path FROM _gpui_root ORDER BY path,id")?;
    Ok(statement
        .query_map([], |row| {
            Ok(Root {
                id: row.get(0)?,
                path: PathBuf::from(row.get::<_, String>(1)?),
            })
        })?
        .collect::<Result<Vec<_>, _>>()?)
}
pub(crate) fn add_root(
    database: &Database,
    path: &Path,
    version: Version,
) -> Result<Version, SourceError> {
    let connection = database.connection();
    writable(connection)?;
    let next = version.advance(false)?;
    let path = fs::canonicalize(path).map_err(|error| SourceError::Io {
        path: path.into(),
        error,
    })?;
    if !path.is_dir() {
        return Err(SourceError::NotDirectory(path));
    }
    let value = path
        .to_str()
        .ok_or_else(|| SourceError::UnsupportedPath(path.clone()))?;
    let transaction = connection.unchecked_transaction()?;
    connection.execute(
        "INSERT INTO _gpui_root(path) VALUES(?) ON CONFLICT(path) DO NOTHING",
        [value],
    )?;
    transaction.commit()?;
    Ok(next)
}
pub(crate) fn remove_root(
    database: &Database,
    id: i64,
    delete: bool,
    version: Version,
) -> Result<Version, SourceError> {
    let connection = database.connection();
    writable(connection)?;
    let next = version.advance(false)?;
    let transaction = connection.unchecked_transaction()?;
    let exists: bool = connection.query_row(
        "SELECT EXISTS(SELECT 1 FROM _gpui_root WHERE id=?)",
        [id],
        |row| row.get(0),
    )?;
    if !exists {
        return Err(SourceError::MissingCollection);
    }
    let removed = if delete {
        connection.execute("DELETE FROM track WHERE id IN (
            SELECT file.track_id FROM _gpui_index_file file JOIN _gpui_index_member member ON member.location=file.location
            WHERE member.root_id=? AND NOT EXISTS(SELECT 1 FROM _gpui_index_member other WHERE other.location=file.location AND other.root_id!=?)
        )", [id,id])?
    } else {
        0
    };
    connection.execute("DELETE FROM _gpui_root WHERE id=?", [id])?;
    let next = if removed > 0 {
        version.advance(true)?
    } else {
        next
    };
    transaction.commit()?;
    Ok(next)
}

struct Directory {
    path: PathBuf,
    entries: fs::ReadDir,
}
pub(crate) struct Scan {
    pub request: Request,
    roots: Vec<Root>,
    next_root: usize,
    directories: Vec<Directory>,
    probe: Probe,
    report: Report,
}
impl Scan {
    pub fn new(database: &Database, request: Request) -> Result<Self, SourceError> {
        writable(database.connection())?;
        // Check revision exhaustion before doing discovery or touching staging.
        request.version.advance(false)?;
        clear(database)?;
        database.connection().execute_batch(
            "CREATE TEMP TABLE _gpui_scan_seen(location TEXT PRIMARY KEY);
            CREATE TEMP TABLE _gpui_scan_protected(prefix TEXT PRIMARY KEY);
            CREATE TEMP TABLE _gpui_scan_track(
                location TEXT PRIMARY KEY,title TEXT NOT NULL,title_sort TEXT NOT NULL,
                artist_sort TEXT,album TEXT,album_artist_sort TEXT,
                track_number INTEGER,disc_number INTEGER,duration INTEGER NOT NULL
            );
            CREATE TEMP TABLE _gpui_scan_credit(
                location TEXT NOT NULL,kind INTEGER NOT NULL,position INTEGER NOT NULL,name TEXT NOT NULL,
                PRIMARY KEY(location,kind,position)
            );"
        )?;
        Ok(Self {
            request,
            roots: roots(database)?,
            next_root: 0,
            directories: Vec::new(),
            probe: metadata::probe(),
            report: Report::default(),
        })
    }
    /// True means discovery/staging finished. Each false result consumed one
    /// directory entry or advanced a root/directory state. No retry-only spin.
    pub fn step(&mut self, database: &Database) -> Result<bool, SourceError> {
        if let Some(directory) = self.directories.last_mut() {
            let entry = match directory.entries.next() {
                Some(Ok(entry)) => entry,
                Some(Err(error)) => {
                    let path = directory.path.clone();
                    protect(database, &path)?;
                    self.report.failure(SourceError::Io { path, error })?;
                    self.directories.pop();
                    return Ok(false);
                }
                None => {
                    self.directories.pop();
                    return Ok(false);
                }
            };
            let path = entry.path();
            let kind = match entry.file_type() {
                Ok(kind) => kind,
                Err(error) => {
                    protect(database, &directory.path)?;
                    self.report.failure(SourceError::Io { path, error })?;
                    return Ok(false);
                }
            };
            if kind.is_dir() {
                self.open_directory(database, path)?;
            } else if kind.is_file() && metadata::supported(&path) {
                self.report.examined = self
                    .report
                    .examined
                    .checked_add(1)
                    .ok_or(SourceError::IndexExhausted)?;
                let Some(location) = path.to_str() else {
                    self.report.failure(SourceError::UnsupportedPath(path))?;
                    return Ok(false);
                };
                database.connection().execute(
                    "INSERT OR IGNORE INTO temp._gpui_scan_seen VALUES(?)",
                    [location],
                )?;
                match metadata::read(&self.probe, &path) {
                    Ok(metadata) => stage(database, &path, metadata)?,
                    Err(error) => self.report.failure(error)?,
                }
            }
            return Ok(false);
        }
        if self.next_root == self.roots.len() {
            return Ok(true);
        }
        let index = self.next_root;
        self.next_root += 1;
        let path = &self.roots[index].path;
        // All roots retain membership, but overlapping trees are walked once.
        if self.roots[..index]
            .iter()
            .any(|root| path.starts_with(&root.path))
        {
            return Ok(false);
        }
        self.open_directory(database, path.clone())?;
        Ok(false)
    }
    fn open_directory(&mut self, database: &Database, path: PathBuf) -> Result<(), SourceError> {
        match fs::read_dir(&path) {
            Ok(entries) => self.directories.push(Directory { path, entries }),
            Err(error) => {
                protect(database, &path)?;
                self.report.failure(SourceError::Io { path, error })?;
            }
        }
        Ok(())
    }
    pub fn finish(mut self, database: &Database) -> Result<(Version, Report), SourceError> {
        let connection = database.connection();
        let transaction = connection.unchecked_transaction()?;
        let mut replaced = false;
        {
            let mut statement = connection.prepare("SELECT location,title,title_sort,artist_sort,album,album_artist_sort,track_number,disc_number,duration FROM temp._gpui_scan_track ORDER BY location")?;
            let mut rows = statement.query([])?;
            while let Some(row) = rows.next()? {
                let (id, changed, existing) = apply_track(connection, row)?;
                let location = text(row, 0)?;
                connection.execute("INSERT INTO _gpui_index_file(location,track_id) VALUES(?,?) ON CONFLICT(location) DO UPDATE SET track_id=excluded.track_id", params![location,id])?;
                connection.execute(
                    "DELETE FROM _gpui_index_member WHERE location=?",
                    [location],
                )?;
                for root in &self.roots {
                    if Path::new(location).starts_with(&root.path) {
                        connection.execute(
                            "INSERT INTO _gpui_index_member(root_id,location) VALUES(?,?)",
                            params![root.id, location],
                        )?;
                    }
                }
                if changed {
                    self.report.indexed = self
                        .report
                        .indexed
                        .checked_add(1)
                        .ok_or(SourceError::IndexExhausted)?;
                    replaced |= existing;
                } else {
                    self.report.unchanged = self
                        .report
                        .unchanged
                        .checked_add(1)
                        .ok_or(SourceError::IndexExhausted)?;
                }
            }
        }
        let removed = connection.execute("DELETE FROM track WHERE id IN(
            SELECT track_id FROM _gpui_index_file file
            WHERE EXISTS(SELECT 1 FROM _gpui_index_member member WHERE member.location=file.location)
            AND NOT EXISTS(SELECT 1 FROM temp._gpui_scan_seen seen WHERE seen.location=file.location)
            AND NOT EXISTS(SELECT 1 FROM temp._gpui_scan_protected protected WHERE SUBSTR(file.location,1,LENGTH(protected.prefix))=protected.prefix)
        )", [])?;
        self.report.removed = u64::try_from(removed).map_err(|_| SourceError::IndexExhausted)?;
        // Reconcile only albums whose recordings are all index-managed. Keep
        // unchanged associations (and artist IDs) instead of delete/reinsert.
        connection.execute_batch("DELETE FROM album_artist
            WHERE NOT EXISTS(SELECT 1 FROM track WHERE track.album_id=album_artist.album_id AND NOT EXISTS(SELECT 1 FROM _gpui_index_file file WHERE file.track_id=track.id))
            AND NOT EXISTS(SELECT 1 FROM track JOIN json_each(track.album_artist_keys) credit JOIN artist ON artist.name=credit.value WHERE track.album_id=album_artist.album_id AND artist.id=album_artist.artist_id);
            INSERT OR IGNORE INTO artist(name,name_sortable)
            SELECT DISTINCT credit.value,credit.value FROM track JOIN json_each(track.album_artist_keys) credit
            WHERE EXISTS(SELECT 1 FROM _gpui_index_file file WHERE file.track_id=track.id);
            INSERT OR IGNORE INTO album_artist(album_id,artist_id)
            SELECT track.album_id,artist.id FROM track JOIN json_each(track.album_artist_keys) credit JOIN artist ON artist.name=credit.value
            WHERE track.album_id IS NOT NULL AND EXISTS(SELECT 1 FROM _gpui_index_file file WHERE file.track_id=track.id);")?;
        let next = self.request.version.advance(replaced || removed > 0)?;
        // Staging cleanup is inside this transaction: after commit there is
        // no remaining fallible operation before publishing this Version.
        clear(database)?;
        transaction.commit()?;
        Ok((next, self.report))
    }
}
pub(crate) fn clear(database: &Database) -> Result<(), SourceError> {
    database.connection().execute_batch("DROP TABLE IF EXISTS temp._gpui_scan_seen; DROP TABLE IF EXISTS temp._gpui_scan_protected; DROP TABLE IF EXISTS temp._gpui_scan_track; DROP TABLE IF EXISTS temp._gpui_scan_credit")?;
    Ok(())
}
fn protect(database: &Database, path: &Path) -> Result<(), SourceError> {
    let mut prefix = path
        .to_str()
        .ok_or_else(|| SourceError::UnsupportedPath(path.into()))?
        .to_owned();
    if !prefix.ends_with(std::path::MAIN_SEPARATOR) {
        prefix.push(std::path::MAIN_SEPARATOR);
    }
    database.connection().execute(
        "INSERT OR IGNORE INTO temp._gpui_scan_protected VALUES(?)",
        [prefix],
    )?;
    Ok(())
}
fn stage(
    database: &Database,
    path: &Path,
    metadata: metadata::Metadata,
) -> Result<(), SourceError> {
    let location = path
        .to_str()
        .ok_or_else(|| SourceError::UnsupportedPath(path.into()))?;
    let title = metadata
        .title
        .as_ref()
        .map(|value| value.trim())
        .or_else(|| path.file_stem().and_then(|value| value.to_str()))
        .ok_or_else(|| SourceError::UnsupportedPath(path.into()))?;
    let artist_sort = metadata.artist_sort.as_ref().map(|value| value.trim());
    database.connection().execute(
        "INSERT OR REPLACE INTO temp._gpui_scan_track VALUES(?,?,?,?,?,?,?,?,?)",
        params![
            location,
            title,
            metadata
                .title_sort
                .as_ref()
                .map_or(title, |value| value.trim()),
            artist_sort,
            metadata.album.as_ref().map(|value| value.trim()),
            metadata
                .album_artist_sort
                .as_ref()
                .map(|value| value.trim()),
            metadata.track_number,
            metadata.disc_number,
            metadata.duration_ms
        ],
    )?;
    database.connection().execute(
        "DELETE FROM temp._gpui_scan_credit WHERE location=?",
        [location],
    )?;
    for (kind, credits) in [&metadata.artists, &metadata.album_artists]
        .into_iter()
        .enumerate()
    {
        for (position, name) in credits.iter().enumerate() {
            database.connection().execute(
                "INSERT INTO temp._gpui_scan_credit VALUES(?,?,?,?)",
                params![location, kind as i64, position as i64, name.trim()],
            )?;
        }
    }
    Ok(())
}
fn text<'a>(row: &'a Row<'_>, index: usize) -> rusqlite::Result<&'a str> {
    row.get_ref(index)?.as_str().map_err(|error| {
        rusqlite::Error::FromSqlConversionFailure(
            index,
            rusqlite::types::Type::Text,
            Box::new(error),
        )
    })
}
fn optional_text<'a>(row: &'a Row<'_>, index: usize) -> rusqlite::Result<Option<&'a str>> {
    row.get_ref(index)?.as_str_or_null().map_err(|error| {
        rusqlite::Error::FromSqlConversionFailure(
            index,
            rusqlite::types::Type::Text,
            Box::new(error),
        )
    })
}
fn apply_track(connection: &Connection, row: &Row<'_>) -> Result<(i64, bool, bool), SourceError> {
    let location = text(row, 0)?;
    let title = text(row, 1)?;
    let title_sort = text(row, 2)?;
    let artist_sort = optional_text(row, 3)?;
    let album = optional_text(row, 4)?;
    let album_artist_sort = optional_text(row, 5)?;
    let number: Option<i64> = row.get(6)?;
    let disc: Option<i64> = row.get(7)?;
    let duration: i64 = row.get(8)?;
    let artists: String = connection.query_row("SELECT JSON_GROUP_ARRAY(name) FROM (SELECT name FROM temp._gpui_scan_credit WHERE location=? AND kind=0 ORDER BY position)", [location], |row|row.get(0))?;
    let artist_display: Option<String> = connection.query_row("SELECT GROUP_CONCAT(name,', ') FROM (SELECT name FROM temp._gpui_scan_credit WHERE location=? AND kind=0 ORDER BY position)", [location], |row|row.get(0))?;
    let album_credit_kind: i64 = connection.query_row(
        "SELECT EXISTS(SELECT 1 FROM temp._gpui_scan_credit WHERE location=? AND kind=1)",
        [location],
        |row| row.get(0),
    )?;
    let album_keys: String = connection.query_row("SELECT JSON_GROUP_ARRAY(name) FROM (SELECT name FROM temp._gpui_scan_credit WHERE location=? AND kind=? ORDER BY position)", params![location,album_credit_kind], |row|row.get(0))?;
    let album_display: Option<String> = connection.query_row("SELECT GROUP_CONCAT(name,', ') FROM (SELECT name FROM temp._gpui_scan_credit WHERE location=? AND kind=? ORDER BY position)", params![location,album_credit_kind], |row|row.get(0))?;
    let album_sort = album_artist_sort.or(album_display.as_deref());
    let album_id = if let Some(album) = album {
        let existing = connection
            .query_row(
                "SELECT id FROM album WHERE title=? AND artist_sort IS ? ORDER BY id LIMIT 1",
                params![album, album_sort],
                |row| row.get::<_, i64>(0),
            )
            .optional()?;
        Some(match existing {
            Some(id) => id,
            None => {
                connection.execute("INSERT INTO album(title,title_sortable,artist_sort,artist_display_override) VALUES(?,?,?,?)", params![album,album,album_sort,album_display])?;
                connection.last_insert_rowid()
            }
        })
    } else {
        None
    };
    let old = connection.query_row("SELECT id,NOT(title IS ? AND title_sortable IS ? AND album_id IS ? AND track_number IS ? AND disc_number IS ? AND duration IS ? AND artist_names IS ? AND artist_sort IS ? AND artists IS ? AND album_artist_keys IS ?) FROM track WHERE location=?", params![title,title_sort,album_id,number,disc,duration,artist_display,artist_sort,artists,album_keys,location], |row|Ok((row.get::<_,i64>(0)?,row.get::<_,bool>(1)?))).optional()?;
    let (id, changed, existing) = match old {
        Some((id, changed)) => {
            if changed {
                connection.execute("UPDATE track SET title=?,title_sortable=?,album_id=?,track_number=?,disc_number=?,duration=?,artist_names=?,artist_sort=?,artists=?,album_artist_keys=? WHERE id=?", params![title,title_sort,album_id,number,disc,duration,artist_display,artist_sort,artists,album_keys,id])?;
            }
            (id, changed, true)
        }
        None => {
            connection.execute("INSERT INTO track(location,title,title_sortable,album_id,track_number,disc_number,duration,artist_names,artist_sort,artists,album_artist_keys) VALUES(?,?,?,?,?,?,?,?,?,?,?)", params![location,title,title_sort,album_id,number,disc,duration,artist_display,artist_sort,artists,album_keys])?;
            (connection.last_insert_rowid(), true, false)
        }
    };
    if changed {
        // Only this recording's credits change. Unrelated fixture/library rows
        // and manual album credits are never globally cleaned or reseeded.
        connection.execute(
            "DELETE FROM track_artist WHERE track_id=? AND NOT EXISTS(
            SELECT 1 FROM temp._gpui_scan_credit credit JOIN artist ON artist.name=credit.name
            WHERE credit.location=? AND credit.kind=0 AND artist.id=track_artist.artist_id)",
            params![id, location],
        )?;
        let mut statement = connection.prepare(
            "SELECT kind,name FROM temp._gpui_scan_credit WHERE location=? ORDER BY kind,position",
        )?;
        let mut credits = statement.query([location])?;
        while let Some(credit) = credits.next()? {
            let kind: i64 = credit.get(0)?;
            let name = text(credit, 1)?;
            connection.execute(
                "INSERT INTO artist(name,name_sortable) VALUES(?,?) ON CONFLICT(name) DO NOTHING",
                [name, name],
            )?;
            let artist: i64 =
                connection.query_row("SELECT id FROM artist WHERE name=?", [name], |row| {
                    row.get(0)
                })?;
            if kind == 0 {
                connection.execute(
                    "INSERT OR IGNORE INTO track_artist(track_id,artist_id) VALUES(?,?)",
                    [id, artist],
                )?;
            }
        }
    }
    Ok((id, changed, existing))
}
