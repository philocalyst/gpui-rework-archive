//! Persistent real files, metadata and public UI/worker authority. No private
//! owner loop, synthetic query result or implicit playback continuation.
mod support;
use gpui::{LaneSet, Role, Win, WindowOptions};
use hummingbird_gpui_port::{
    app::{Library, connect},
    browser::{Page, Route},
    database::Database,
    files::Roots,
    indexing::Command,
    transcript::settle,
    worker::Worker,
};
use std::{
    fs,
    path::Path,
    time::{Duration, Instant},
};
use support::{Folder, flac, mp3, wave};
fn open(path: &Path) -> (Worker, Win<Library, impl LaneSet<Library>>) {
    let (worker, inbox) = Worker::new(Database::open_library(path).unwrap()).unwrap();
    let (model, questions) = connect(worker.handle()).unwrap();
    let mut win = Win::with_questions(
        model,
        questions,
        WindowOptions {
            size: [720, 1100],
            ..Default::default()
        },
    )
    .unwrap()
    .with_inbox_status(inbox, Library::receive)
    .unwrap();
    settle(&mut win, &worker).unwrap();
    (worker, win)
}
fn acquired<L: LaneSet<Library>>(win: &mut Win<Library, L>, worker: &Worker) {
    let deadline = Instant::now() + Duration::from_secs(15);
    while win.with_model(Library::indexing_request).unwrap().is_some() {
        assert!(
            Instant::now() < deadline,
            "library acquisition did not complete"
        );
        worker
            .checkpoint()
            .unwrap()
            .recv_timeout(Duration::from_secs(10))
            .unwrap();
        win.deliver_ready(32).unwrap();
        std::thread::yield_now();
    }
    settle(win, worker).unwrap();
}
fn add<L: LaneSet<Library>>(win: &mut Win<Library, L>, worker: &Worker, path: &Path) {
    win.activate(win.role(Role::Button).name("Files").one().unwrap())
        .unwrap();
    settle(win, worker).unwrap();
    win.set(
        Library::ROOTS.source(&Roots::PATH),
        path.to_str().unwrap().into(),
    )
    .unwrap();
    win.activate(win.button("Add library root")).unwrap();
    acquired(win, worker);
}
fn scan<L: LaneSet<Library>>(win: &mut Win<Library, L>, worker: &Worker) {
    win.update(|m| m.request_index(Command::Scan)).unwrap();
    acquired(win, worker);
}
#[test]
fn roots_index_real_tagged_formats_restart_preserve_ids_and_revoke_replaced_metadata() {
    let folder = Folder::new();
    let music = folder.0.join("Καφέ");
    fs::create_dir(&music).unwrap();
    let nested = music.join("disc");
    fs::create_dir(&nested).unwrap();
    wave(&music.join("01.wav"), "First Καφέ", "Alpha", "Album");
    flac(&nested.join("02.flac"), "Second", "Beta", "Album B");
    mp3(&nested.join("03.mp3"), "Third", "Gamma", "Album C");
    fs::write(nested.join("broken.mp3"), b"invalid media").unwrap();
    let db = folder.0.join("library.sqlite");
    let (worker, mut win) = open(&db);
    add(&mut win, &worker, &music);
    add(&mut win, &worker, &nested);
    let read = Database::open_read_only(&db).unwrap();
    assert_eq!(
        read.connection()
            .query_row("SELECT COUNT(*) FROM track", [], |r| r.get::<_, i64>(0))
            .unwrap(),
        0
    );
    scan(&mut win, &worker);
    let rows = || {
        read.connection()
            .prepare("SELECT id,title,artist_names,location FROM track ORDER BY location")
            .unwrap()
            .query_map([], |r| {
                Ok((
                    r.get::<_, i64>(0)?,
                    r.get::<_, String>(1)?,
                    r.get::<_, String>(2)?,
                    r.get::<_, String>(3)?,
                ))
            })
            .unwrap()
            .collect::<Result<Vec<_>, _>>()
            .unwrap()
    };
    let original = rows();
    assert_eq!(original.len(), 3);
    assert_eq!(
        original.iter().map(|r| r.1.as_str()).collect::<Vec<_>>(),
        ["First Καφέ", "Second", "Third"]
    );
    assert_eq!(
        original.iter().map(|r| r.2.as_str()).collect::<Vec<_>>(),
        ["Alpha", "Beta", "Gamma"]
    );
    let initial = win.with_model(|m| *m.version).unwrap();
    assert_eq!(initial.generation, 0);
    assert!(win.contains_text("failed 1").unwrap());
    scan(&mut win, &worker);
    assert_eq!(rows(), original);
    assert_eq!(win.with_model(|m| m.version.generation).unwrap(), 0);
    wave(&music.join("01.wav"), "Changed", "Alpha", "Album");
    scan(&mut win, &worker);
    let changed = rows();
    assert_eq!(changed[0].0, original[0].0);
    assert_eq!(changed[0].1, "Changed");
    assert_eq!(win.with_model(|m| m.version.generation).unwrap(), 1);
    fs::remove_file(nested.join("02.flac")).unwrap();
    scan(&mut win, &worker);
    assert_eq!(rows().len(), 2);
    assert_eq!(win.with_model(|m| m.version.generation).unwrap(), 2);
    drop(read);
    drop(win);
    worker.finish().unwrap();
    let (worker, mut win) = open(&db);
    win.update(|m| m.navigate(Route::Files)).unwrap();
    settle(&mut win, &worker).unwrap();
    let result = win.with_model(|m| m.results).unwrap();
    assert_eq!(
        win.with_ready(result, |page| match page {
            Page::Files(files) => files.entries.len(),
            _ => panic!("Files route"),
        })
        .unwrap(),
        Some(2)
    );
    drop(win);
    worker.finish().unwrap();
}
#[test]
fn cancellation_between_worker_units_drops_staging_and_close_does_not_retain_sender() {
    use std::sync::{Arc, Barrier};
    let folder = Folder::new();
    let music = folder.0.join("music");
    fs::create_dir(&music).unwrap();
    wave(&music.join("one.wav"), "One", "Artist", "Album");
    let db = folder.0.join("library.sqlite");
    let (worker, mut win) = open(&db);
    add(&mut win, &worker, &music);
    let entered = Arc::new(Barrier::new(2));
    let release = Arc::new(Barrier::new(2));
    let handle = worker.handle();
    let thread = {
        let entered = entered.clone();
        let release = release.clone();
        std::thread::spawn(move || {
            handle
                .with_current_source(0, || {
                    entered.wait();
                    release.wait();
                })
                .unwrap()
        })
    };
    entered.wait();
    win.update(|m| m.request_index(Command::Scan)).unwrap();
    win.update(|m| m.request_index(Command::Cancel)).unwrap();
    release.wait();
    thread.join().unwrap();
    acquired(&mut win, &worker);
    assert!(win.contains_text("Indexing canceled").unwrap());
    let read = Database::open_read_only(&db).unwrap();
    assert_eq!(
        read.connection()
            .query_row("SELECT COUNT(*) FROM track", [], |r| r.get::<_, i64>(0))
            .unwrap(),
        0
    );
    drop(read);
    drop(win);
    worker.finish().unwrap();
}
#[test]
fn an_unrecognized_database_is_rejected_without_migration_or_seeding() {
    let folder = Folder::new();
    let path = folder.0.join("other.sqlite");
    let connection = rusqlite::Connection::open(&path).unwrap();
    connection
        .execute("CREATE TABLE unrelated(value TEXT)", [])
        .unwrap();
    assert!(Database::open_library(&path).is_err());
    assert_eq!(
        connection
            .query_row(
                "SELECT COUNT(*) FROM sqlite_schema WHERE type='table'",
                [],
                |r| r.get::<_, i64>(0)
            )
            .unwrap(),
        1
    );
}
