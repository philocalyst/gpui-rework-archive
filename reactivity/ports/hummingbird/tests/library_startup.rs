//! Untimed syscall control through the real public persistent constructor.
use hummingbird_gpui_port::database::Database;

#[test]
#[ignore = "explicit fresh disk path and external syscall observer required"]
fn public_fresh_library_syscall_control() {
    let path = std::path::PathBuf::from(std::env::var_os("GPUI_SCHEMA_PROBE_PATH").unwrap());
    assert!(
        !path.exists(),
        "control must create a genuinely new database"
    );
    let database = Database::open_library(&path).unwrap();
    let connection = database.connection();
    let foreign_keys: i64 = connection
        .pragma_query_value(None, "foreign_keys", |r| r.get(0))
        .unwrap();
    let synchronous: i64 = connection
        .pragma_query_value(None, "synchronous", |r| r.get(0))
        .unwrap();
    let journal: String = connection
        .pragma_query_value(None, "journal_mode", |r| r.get(0))
        .unwrap();
    let seed: (i64, String, i64, i64) = connection
        .query_row("SELECT id,name,type,position FROM playlist", [], |r| {
            Ok((r.get(0)?, r.get(1)?, r.get(2)?, r.get(3)?))
        })
        .unwrap();
    assert_eq!(foreign_keys, 1);
    assert_eq!(synchronous, 2);
    assert_eq!(journal, "delete");
    assert_eq!(seed, (1, "Liked Songs".into(), 1, 1));
    assert_eq!(
        connection
            .query_row("SELECT version FROM _gpui_library", [], |r| r
                .get::<_, i64>(0))
            .unwrap(),
        1
    );
    println!(
        "CONTROL foreign_keys={foreign_keys} synchronous={synchronous} journal={journal} seed={seed:?}"
    );
    drop(database);
}

#[test]
#[ignore = "explicit fresh disk path and external syscall observer required"]
fn public_source_admission_syscall_control() {
    let path = std::path::PathBuf::from(std::env::var_os("GPUI_SCHEMA_PROBE_PATH").unwrap());
    assert!(!path.exists());
    let database = Database::open_library(&path).unwrap();
    let (worker, inbox) = hummingbird_gpui_port::worker::Worker::new(database).unwrap();
    drop(inbox);
    worker.finish().unwrap();
    let connection = rusqlite::Connection::open(&path).unwrap();
    let synchronous: i64 = connection
        .pragma_query_value(None, "synchronous", |row| row.get(0))
        .unwrap();
    let journal: String = connection
        .pragma_query_value(None, "journal_mode", |row| row.get(0))
        .unwrap();
    assert_eq!(synchronous, 2);
    assert_eq!(journal, "delete");
    println!("CONTROL source admission synchronous={synchronous} journal={journal}");
}

fn rejects_unknown(sql: &str) {
    static NEXT: std::sync::atomic::AtomicU64 = std::sync::atomic::AtomicU64::new(0);
    let path = std::env::temp_dir().join(format!(
        "hummingbird-admission-{}-{}.sqlite",
        std::process::id(),
        NEXT.fetch_add(1, std::sync::atomic::Ordering::Relaxed)
    ));
    assert!(!path.exists());
    let connection = rusqlite::Connection::open(&path).unwrap();
    connection.execute_batch(sql).unwrap();
    drop(connection);
    let before = std::fs::read(&path).unwrap();
    let rejected = matches!(
        Database::open_library(&path),
        Err(hummingbird_gpui_port::search::SourceError::UnknownLibrarySchema)
    );
    let after = std::fs::read(&path).unwrap();
    std::fs::remove_file(&path).unwrap();
    assert!(rejected, "unowned schema was admitted");
    assert_eq!(after, before, "unowned schema was changed");
}

#[test]
fn rejects_view_only_unknown_database() {
    rejects_unknown("CREATE VIEW unrelated AS SELECT 1 AS value");
}

#[test]
fn rejects_fake_marker_view() {
    rejects_unknown("CREATE VIEW _gpui_library AS SELECT 1 AS version");
}

#[test]
fn rejects_sqlite_wildcard_lookalike_table() {
    rejects_unknown("CREATE TABLE sqlitexyz(value INTEGER)");
}
