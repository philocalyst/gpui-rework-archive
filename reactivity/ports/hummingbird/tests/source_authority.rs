//! SQLite transaction admission is part of source publication, not a UI hint.
use hummingbird_gpui_port::{database::Database, search::Version, worker::Worker};
use std::time::Duration;
fn uncommitted() -> Database {
    let database = Database::fixture().unwrap();
    database
        .connection()
        .execute_batch("BEGIN IMMEDIATE; UPDATE track SET title='Transient' WHERE id=44")
        .unwrap();
    database
}
#[test]
fn initial_uncommitted_database_is_rejected_before_starting_a_worker() {
    assert!(Worker::new(uncommitted()).is_err());
}
#[test]
fn replacement_with_uncommitted_sql_never_publishes_or_consumes_a_version() {
    let (worker, _inbox) = Worker::new(Database::fixture().unwrap()).unwrap();
    let result = worker
        .replace_database(uncommitted())
        .unwrap()
        .recv_timeout(Duration::from_secs(5))
        .unwrap();
    assert!(
        result.is_err(),
        "replacement acknowledged an active SQL transaction"
    );
    assert!(
        worker
            .handle()
            .with_current_version(Version::default(), || ())
            .unwrap()
            .is_some()
    );
    let committed = worker
        .replace_database(Database::fixture().unwrap())
        .unwrap()
        .recv_timeout(Duration::from_secs(5))
        .unwrap()
        .unwrap();
    assert_eq!(
        committed,
        Version {
            revision: 1,
            generation: 1
        }
    );
    worker.finish().unwrap();
}
