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
fn open(path: &Path) -> (Worker, Win<Library, impl LaneSet<Library> + use<>>) {
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

#[test]
fn files_use_fresh_row_domains_exact_paths_and_explicit_root_removal_semantics() {
    use gpui::{Error, ItemKey};
    let folder = Folder::new();
    let root = folder.0.join("music");
    fs::create_dir(&root).unwrap();
    let child = root.join("disc");
    fs::create_dir(&child).unwrap();
    wave(&root.join("same.wav"), "Root", "Artist", "Album");
    wave(&child.join("same.wav"), "Child", "Artist", "Album");
    fs::write(root.join("notes.txt"), b"not a recording").unwrap();
    let db = folder.0.join("library.sqlite");
    let (worker, mut win) = open(&db);
    add(&mut win, &worker, &root);
    scan(&mut win, &worker);
    win.activate(win.button(&format!("Open {}", root.display())))
        .unwrap();
    settle(&mut win, &worker).unwrap();
    let result = win.with_model(|m| m.results).unwrap();
    let (list, entries) = win
        .with_ready(result, |page| match page {
            Page::Files(files) => (
                files.list(),
                (0..files.entries.len())
                    .map(|index| files.path(index).unwrap())
                    .collect::<Vec<_>>(),
            ),
            _ => panic!("Files page"),
        })
        .unwrap()
        .unwrap();
    assert_eq!(
        entries,
        [child.clone(), root.join("same.wav"), root.join("notes.txt")]
    );
    let item = win
        .list_item(win.list(list).unwrap(), ItemKey::new(0))
        .unwrap();
    let old = win
        .role(Role::Button)
        .name("Open disc")
        .within(item)
        .one()
        .unwrap();
    win.activate(old).unwrap();
    settle(&mut win, &worker).unwrap();
    assert_eq!(win.activate(old), Err(Error::StaleTarget));
    assert_eq!(
        win.with_ready(result, |page| match page {
            Page::Files(files) => files.path(0).unwrap(),
            _ => panic!("Files page"),
        })
        .unwrap(),
        Some(child.join("same.wav"))
    );
    win.update(|m| m.navigate(Route::Files)).unwrap();
    settle(&mut win, &worker).unwrap();
    win.activate(win.button("Forget root")).unwrap();
    acquired(&mut win, &worker);
    scan(&mut win, &worker);
    let read = Database::open_read_only(&db).unwrap();
    assert_eq!(
        read.connection()
            .query_row("SELECT COUNT(*) FROM track", [], |row| row.get::<_, i64>(0))
            .unwrap(),
        2
    );
    add(&mut win, &worker, &root);
    scan(&mut win, &worker);
    win.activate(win.button("Remove root + recordings"))
        .unwrap();
    acquired(&mut win, &worker);
    assert_eq!(
        read.connection()
            .query_row("SELECT COUNT(*) FROM track", [], |row| row.get::<_, i64>(0))
            .unwrap(),
        0
    );
    drop(read);
    drop(win);
    worker.finish().unwrap();
}

#[test]
fn replacement_resolves_an_accepted_scan_before_its_first_filesystem_unit() {
    use std::sync::{Arc, Barrier};
    let folder = Folder::new();
    let music = folder.0.join("music");
    fs::create_dir(&music).unwrap();
    wave(&music.join("one.wav"), "One", "Artist", "Album");
    let (worker, mut win) = open(&folder.0.join("library.sqlite"));
    add(&mut win, &worker, &music);
    let entered = Arc::new(Barrier::new(2));
    let release = Arc::new(Barrier::new(2));
    let handle = worker.handle();
    let hold = {
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
    win.update(|model| model.request_index(Command::Scan))
        .unwrap();
    let replacement = worker
        .replace_database(Database::fixture().unwrap())
        .unwrap();
    release.wait();
    hold.join().unwrap();
    replacement
        .recv_timeout(Duration::from_secs(10))
        .unwrap()
        .unwrap();
    settle(&mut win, &worker).unwrap();
    assert_eq!(win.with_model(Library::indexing_request).unwrap(), None);
    assert!(win.contains_text("Library source changed").unwrap());
    drop(win);
    worker.finish().unwrap();
}

#[cfg(unix)]
#[test]
fn symlinks_are_not_traversed_and_missing_roots_preserve_committed_recordings() {
    use std::os::unix::fs::symlink;
    let folder = Folder::new();
    let root = folder.0.join("music");
    fs::create_dir(&root).unwrap();
    let outside = folder.0.join("outside");
    fs::create_dir(&outside).unwrap();
    wave(&root.join("inside.wav"), "Inside", "Artist", "Album");
    wave(&outside.join("outside.wav"), "Outside", "Artist", "Album");
    symlink(&outside, root.join("linked-directory")).unwrap();
    symlink(outside.join("outside.wav"), root.join("linked.wav")).unwrap();
    let db = folder.0.join("library.sqlite");
    let (worker, mut win) = open(&db);
    add(&mut win, &worker, &root);
    scan(&mut win, &worker);
    let read = Database::open_read_only(&db).unwrap();
    assert_eq!(
        read.connection()
            .query_row("SELECT COUNT(*) FROM track", [], |row| row.get::<_, i64>(0))
            .unwrap(),
        1
    );
    fs::rename(&root, folder.0.join("temporarily unavailable")).unwrap();
    scan(&mut win, &worker);
    assert_eq!(
        read.connection()
            .query_row("SELECT title FROM track", [], |row| row.get::<_, String>(0))
            .unwrap(),
        "Inside"
    );
    assert!(win.contains_text("failed 1").unwrap());
    drop(read);
    drop(win);
    worker.finish().unwrap();
}

#[cfg(unix)]
#[test]
fn files_keep_distinct_non_utf8_names_and_actions_without_lossy_identity() {
    use gpui::ItemKey;
    use std::{ffi::OsString, os::unix::ffi::OsStringExt};
    let folder = Folder::new();
    let root = folder.0.join("music");
    fs::create_dir(&root).unwrap();
    let first = root.join(OsString::from_vec(b"disc-\x80".to_vec()));
    let second = root.join(OsString::from_vec(b"disc-\x81".to_vec()));
    assert_ne!(first, second);
    assert_eq!(first.to_string_lossy(), second.to_string_lossy());
    fs::create_dir(&first).unwrap();
    fs::create_dir(&second).unwrap();
    wave(&first.join("first.wav"), "First", "Artist", "Album");
    wave(&second.join("second.wav"), "Second", "Artist", "Album");
    let db = folder.0.join("library.sqlite");
    let (worker, mut win) = open(&db);
    add(&mut win, &worker, &root);
    scan(&mut win, &worker);
    assert!(win.contains_text("failed 2").unwrap());
    let read = Database::open_read_only(&db).unwrap();
    assert_eq!(
        read.connection()
            .query_row("SELECT COUNT(*) FROM track", [], |row| row.get::<_, i64>(0))
            .unwrap(),
        0,
        "non-UTF8 paths cannot be silently admitted to TEXT locations"
    );
    win.activate(win.button(&format!("Open {}", root.display())))
        .unwrap();
    settle(&mut win, &worker).unwrap();
    let result = win.with_model(|model| model.results).unwrap();
    let (list, paths) = win
        .with_ready(result, |page| match page {
            Page::Files(files) => (
                files.list(),
                (0..files.entries.len())
                    .map(|index| files.path(index).unwrap())
                    .collect::<Vec<_>>(),
            ),
            _ => panic!("Files page"),
        })
        .unwrap()
        .unwrap();
    assert_eq!(paths, [first, second.clone()]);
    let item = win
        .list_item(win.list(list).unwrap(), ItemKey::new(1))
        .unwrap();
    let action = win
        .role(Role::Button)
        .name("Open disc-�")
        .within(item)
        .one()
        .unwrap();
    win.activate(action).unwrap();
    settle(&mut win, &worker).unwrap();
    assert_eq!(
        win.with_ready(result, |page| match page {
            Page::Files(files) => files.path(0).unwrap(),
            _ => panic!("Files page"),
        })
        .unwrap(),
        Some(second.join("second.wav"))
    );
    drop(read);
    drop(win);
    worker.finish().unwrap();
}
