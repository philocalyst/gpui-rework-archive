use super::*;
use crate::migrations::MIGRATIONS;
use rusqlite::{
    hooks::{AuthAction, AuthContext, Authorization},
    types::Value,
};
use std::sync::{
    Arc, Barrier,
    atomic::{AtomicBool, AtomicU64, Ordering},
};

type Rows = Vec<Vec<Value>>;
fn rows(connection: &Connection, sql: &str) -> Rows {
    let mut statement = connection.prepare(sql).unwrap();
    let columns = statement.column_count();
    statement
        .query_map([], |row| (0..columns).map(|index| row.get(index)).collect())
        .unwrap()
        .collect::<Result<_>>()
        .unwrap()
}
fn quoted(name: &str) -> String {
    format!("\"{}\"", name.replace('"', "\"\""))
}
fn objects(connection: &Connection) -> Rows {
    rows(
        connection,
        "SELECT type,name,tbl_name,sql FROM sqlite_schema WHERE name!='_gpui_library' ORDER BY type,name",
    )
}
fn tables(connection: &Connection) -> Vec<String> {
    connection.prepare("SELECT name FROM sqlite_schema WHERE type='table' AND name!='_gpui_library' ORDER BY name")
        .unwrap().query_map([], |row| row.get(0)).unwrap().collect::<Result<_>>().unwrap()
}
fn contract(connection: &Connection) -> Vec<(String, Rows, Rows)> {
    let mut result = Vec::new();
    for table in tables(connection) {
        result.push((
            format!("columns {table}"),
            rows(
                connection,
                &format!("PRAGMA table_xinfo({})", quoted(&table)),
            ),
            rows(
                connection,
                &format!("PRAGMA foreign_key_list({})", quoted(&table)),
            ),
        ));
        let indices = rows(
            connection,
            &format!("PRAGMA index_list({})", quoted(&table)),
        );
        for index in indices {
            let Value::Text(name) = &index[1] else {
                panic!("index name")
            };
            result.push((
                format!("index {name}"),
                rows(connection, &format!("PRAGMA index_xinfo({})", quoted(name))),
                vec![index[1..].to_vec()],
            ));
        }
    }
    result.sort_by(|a, b| a.0.cmp(&b.0));
    result
}
fn migrated() -> Database {
    let connection = Connection::open_in_memory().unwrap();
    connection
        .pragma_update(None, "foreign_keys", true)
        .unwrap();
    for (_, sql) in MIGRATIONS {
        connection.execute_batch(sql).unwrap();
    }
    Database { connection }
}
fn data(connection: &Connection, earliest: i64) -> Vec<(String, Rows)> {
    let latest: i64 = connection
        .query_row("SELECT unixepoch('now')", [], |row| row.get(0))
        .unwrap();
    tables(connection).into_iter().map(|table| {
        let defaults = rows(connection, &format!("PRAGMA table_xinfo({})", quoted(&table)));
        let mut values = rows(connection, &format!("SELECT * FROM {} ORDER BY rowid", quoted(&table)));
        for row in &mut values {
            for column in &defaults {
                let Value::Integer(index) = column[0] else { panic!("column index") };
                if matches!(&column[4], Value::Text(default) if default.eq_ignore_ascii_case("CURRENT_TIMESTAMP")) {
                    let Value::Text(timestamp) = &row[index as usize] else { panic!("timestamp default") };
                    let time: i64 = connection.query_row("SELECT unixepoch(?)", [timestamp], |r| r.get(0)).unwrap();
                    assert!((earliest..=latest).contains(&time), "seed must evaluate its default clock");
                    row[index as usize] = Value::Text("<CURRENT_TIMESTAMP>".into());
                }
            }
        }
        (table, values)
    }).collect()
}
#[test]
fn fresh_schema_and_fixture_match_independent_pinned_migrations() {
    let clock = Connection::open_in_memory().unwrap();
    let earliest: i64 = clock
        .query_row("SELECT unixepoch('now')", [], |row| row.get(0))
        .unwrap();
    let mut oracle = migrated();
    let mut connection = Connection::open_in_memory().unwrap();
    connection
        .pragma_update(None, "foreign_keys", true)
        .unwrap();
    Database::initialize_library(&mut connection).unwrap();
    assert_eq!(objects(&connection), objects(&oracle.connection));
    assert_eq!(contract(&connection), contract(&oracle.connection));
    assert_eq!(
        data(&connection, earliest),
        data(&oracle.connection, earliest)
    );
    assert_eq!(
        rows(
            &connection,
            "SELECT name FROM sqlite_schema WHERE type='trigger' ORDER BY rowid"
        ),
        rows(
            &oracle.connection,
            "SELECT name FROM sqlite_schema WHERE type='trigger' ORDER BY rowid"
        )
    );
    oracle.seed().unwrap();
    let fresh = Database::fixture().unwrap();
    assert_eq!(objects(&fresh.connection), objects(&oracle.connection));
    assert_eq!(contract(&fresh.connection), contract(&oracle.connection));
    assert_eq!(
        data(&fresh.connection, earliest),
        data(&oracle.connection, earliest)
    );
    assert!(rows(&fresh.connection, "PRAGMA foreign_key_check").is_empty());
}
#[test]
fn acquisition_autoincrement_state_and_behavior_remain_sqlite_owned() {
    let oracle = migrated();
    let mut connection = Connection::open_in_memory().unwrap();
    connection
        .pragma_update(None, "foreign_keys", true)
        .unwrap();
    Database::initialize_library(&mut connection).unwrap();
    let fresh = Database { connection };
    for database in [&oracle, &fresh] {
        database.initialize_index().unwrap();
    }
    assert_eq!(objects(&fresh.connection), objects(&oracle.connection));
    assert_eq!(contract(&fresh.connection), contract(&oracle.connection));
    let operations = [
        "INSERT INTO _gpui_root(path) VALUES('first')",
        "DELETE FROM _gpui_root",
        "INSERT INTO _gpui_root(path) VALUES('second')",
        "INSERT INTO _gpui_root(id,path) VALUES(50,'explicit')",
        "DELETE FROM _gpui_root WHERE id=50",
        "INSERT INTO _gpui_root(path) VALUES('after explicit')",
    ];
    for operation in operations {
        oracle.connection.execute(operation, []).unwrap();
        fresh.connection.execute(operation, []).unwrap();
        assert_eq!(
            rows(&fresh.connection, "SELECT * FROM _gpui_root ORDER BY id"),
            rows(&oracle.connection, "SELECT * FROM _gpui_root ORDER BY id")
        );
        assert_eq!(
            rows(
                &fresh.connection,
                "SELECT * FROM sqlite_sequence ORDER BY name"
            ),
            rows(
                &oracle.connection,
                "SELECT * FROM sqlite_sequence ORDER BY name"
            )
        );
    }
    assert_eq!(fresh.connection.last_insert_rowid(), 51);
}
#[test]
fn late_creation_failure_rolls_back_schema_seed_and_marker_then_reopen_does_no_ddl() {
    let mut connection = Connection::open_in_memory().unwrap();
    connection
        .pragma_update(None, "foreign_keys", true)
        .unwrap();
    let denied = Arc::new(AtomicBool::new(false));
    let observed = denied.clone();
    connection
        .authorizer(Some(move |context: AuthContext<'_>| {
            if matches!(
                context.action,
                AuthAction::CreateTable {
                    table_name: "_gpui_library"
                }
            ) {
                observed.store(true, Ordering::Relaxed);
                Authorization::Deny
            } else {
                Authorization::Allow
            }
        }))
        .unwrap();
    assert!(Database::initialize_library(&mut connection).is_err());
    assert!(denied.load(Ordering::Relaxed));
    assert!(connection.is_autocommit());
    assert!(objects(&connection).is_empty());
    connection
        .authorizer(None::<fn(AuthContext<'_>) -> Authorization>)
        .unwrap();
    Database::initialize_library(&mut connection).unwrap();
    let before = objects(&connection);
    connection
        .authorizer(Some(|context: AuthContext<'_>| match context.action {
            AuthAction::CreateTable { .. }
            | AuthAction::CreateIndex { .. }
            | AuthAction::CreateTrigger { .. }
            | AuthAction::Insert { .. }
            | AuthAction::Update { .. }
            | AuthAction::Delete { .. } => Authorization::Deny,
            _ => Authorization::Allow,
        }))
        .unwrap();
    Database::initialize_library(&mut connection).unwrap();
    assert_eq!(objects(&connection), before);
    assert_eq!(
        rows(&connection, "SELECT COUNT(*) FROM playlist"),
        vec![vec![Value::Integer(1)]]
    );
}
struct Folder(std::path::PathBuf);
impl Folder {
    fn new() -> Self {
        static NEXT: AtomicU64 = AtomicU64::new(0);
        let path = std::env::temp_dir().join(format!(
            "gpui-fresh-schema-{}-{}",
            std::process::id(),
            NEXT.fetch_add(1, Ordering::Relaxed)
        ));
        std::fs::create_dir(&path).unwrap();
        Self(path)
    }
}
impl Drop for Folder {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.0);
    }
}
#[test]
fn public_creators_serialize_and_unknown_or_future_libraries_stay_unchanged() {
    let folder = Folder::new();
    let path = folder.0.join("new.sqlite");
    let barrier = Arc::new(Barrier::new(3));
    let threads: Vec<_> = (0..2)
        .map(|_| {
            let path = path.clone();
            let barrier = barrier.clone();
            std::thread::spawn(move || {
                barrier.wait();
                Database::open_library(&path).unwrap()
            })
        })
        .collect();
    barrier.wait();
    for thread in threads {
        let database = thread.join().unwrap();
        assert_eq!(
            rows(database.connection(), "SELECT version FROM _gpui_library"),
            vec![vec![Value::Integer(1)]]
        );
        assert_eq!(
            rows(database.connection(), "SELECT COUNT(*) FROM playlist"),
            vec![vec![Value::Integer(1)]]
        );
    }
    let database = Database::open_library(&path).unwrap();
    database
        .connection
        .execute("UPDATE _gpui_library SET version=2", [])
        .unwrap();
    drop(database);
    let before = std::fs::read(&path).unwrap();
    assert!(matches!(
        Database::open_library(&path),
        Err(crate::search::SourceError::UnknownLibrarySchema)
    ));
    assert_eq!(std::fs::read(&path).unwrap(), before);
    let unknown = folder.0.join("unknown.sqlite");
    let connection = Connection::open(&unknown).unwrap();
    connection
        .execute_batch("CREATE TABLE unrelated(value TEXT); INSERT INTO unrelated VALUES('keep')")
        .unwrap();
    drop(connection);
    let before = std::fs::read(&unknown).unwrap();
    assert!(matches!(
        Database::open_library(&unknown),
        Err(crate::search::SourceError::UnknownLibrarySchema)
    ));
    assert_eq!(std::fs::read(&unknown).unwrap(), before);
}
