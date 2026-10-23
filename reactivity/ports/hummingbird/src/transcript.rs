//! Executable app transcript using only the ordinary public window/service API.
use crate::{
    app::{Library, connect, recordings, track_key},
    database::Database,
    search::Sort,
    worker::Worker,
};
use gpui::{Error, LaneSet, QuestionStatus, Role, Target, Win, WindowOptions};
use std::{error::Error as StdError, time::Duration};

#[derive(Debug)]
pub struct Transcript {
    pub sqlite_version: String,
    pub initial_ids: Vec<i64>,
    pub sorted_ids: Vec<i64>,
    pub matched_ids: Vec<i64>,
    pub played_id: i64,
    pub imported_id: i64,
    pub stale_completions: u64,
    pub realized_rows: usize,
    pub source_failure_visible: bool,
}

pub fn settle<L: LaneSet<Library>>(
    win: &mut Win<Library, L>,
    worker: &Worker,
) -> Result<(), Box<dyn StdError>> {
    for _ in 0..32 {
        worker.checkpoint()?.recv_timeout(Duration::from_secs(10))?;
        win.deliver_ready(32)?;
        let (results, playback) = win.with_model(|model| (model.results, model.playback))?;
        if [
            win.question_status(results)?,
            win.question_status(playback)?,
        ]
        .into_iter()
        .all(|status| matches!(status, QuestionStatus::Ready | QuestionStatus::Fault))
        {
            return Ok(());
        }
    }
    Err("library service did not settle within 32 owner deliveries".into())
}
fn ids<L: LaneSet<Library>>(win: &Win<Library, L>) -> Vec<i64> {
    let reader = win.with_model(|model| model.results).unwrap();
    win.with_ready(reader, |page| page.ids().collect())
        .unwrap()
        .expect("current query ready")
}
fn play_target<L: LaneSet<Library>>(win: &Win<Library, L>, id: i64) -> Target {
    let list_id = win.with_model(|model| recordings(*model.version)).unwrap();
    let row = win
        .list_item(win.list(list_id).unwrap(), track_key(id))
        .unwrap();
    win.role(Role::Button).within(row).one().unwrap()
}

pub fn run() -> Result<Transcript, Box<dyn StdError>> {
    let sqlite_version = rusqlite::version().to_owned();
    let (worker, inbox) = Worker::new(Database::fixture()?)?;
    let (model, questions) = connect(worker.handle())?;
    let results = model.results;
    let playback = model.playback;
    let mut win = Win::with_questions(
        model,
        questions,
        WindowOptions {
            size: [720, 520],
            ..WindowOptions::default()
        },
    )?
    .with_inbox(inbox, Library::receive)?;
    settle(&mut win, &worker)?;
    let initial_ids = ids(&win);
    assert_eq!(initial_ids, [1, 13, 11, 21, 3, 2, 90, 44, 1001]);
    let list = win.list(recordings(Default::default()))?;
    let realized_rows = win.list_state(list)?.realized_rows;
    assert_eq!(realized_rows, 5);
    assert!(win.inspect()?.nodes.len() < 100);
    win.scroll_to_key(list, track_key(44))?;
    let original_play = play_target(&win, 44);
    win.click(original_play)?;
    settle(&mut win, &worker)?;
    let played_id = win
        .with_ready(playback, |request| {
            request.track.as_ref().unwrap().track_id.unwrap()
        })?
        .unwrap();
    assert_eq!(played_id, 44);
    assert!(win.contains_text("Play request 1: recording 44 — /music/44.flac")?);

    win.click(win.role(Role::Button).text("Longest first").one()?)?;
    settle(&mut win, &worker)?;
    let sorted_ids = ids(&win);
    assert_eq!(sorted_ids, [13, 11, 21, 90, 44, 1001, 1, 3, 2]);
    assert_eq!(play_target(&win, 44), original_play);
    assert_eq!(win.with_model(|model| model.selected.id)?, Some(44));
    worker
        .prepend_fixture_track()?
        .recv_timeout(Duration::from_secs(10))??;
    settle(&mut win, &worker)?;
    assert_eq!(ids(&win), [13, 11, 21, 5000, 90, 44, 1001, 1, 3, 2]);
    assert_eq!(play_target(&win, 44), original_play);
    assert_eq!(
        win.with_ready(playback, |request| request
            .track
            .as_ref()
            .unwrap()
            .track_id
            .unwrap())?,
        Some(44)
    );

    // Actually finish Alpha on the database worker, leave it queued, then edit
    // through the ordinary public input before admitting that old completion.
    win.type_text(win.input(), "Alpha")?;
    worker.checkpoint()?.recv_timeout(Duration::from_secs(10))?;
    win.set(Library::QUERY, "cafe".into())?;
    settle(&mut win, &worker)?;
    let matched_ids = ids(&win);
    assert_eq!(matched_ids, [13, 11, 21]);
    let stale_completions = win.question_info(results)?.stats.stale_results;
    assert!(stale_completions >= 1);
    assert_eq!(win.click(original_play), Err(Error::StaleTarget));
    assert_eq!(win.with_model(|model| model.selected.id)?, Some(44));
    assert!(win.contains_text("3 recordings for ‘cafe’")?);

    let stale_source_row = play_target(&win, 13);
    let path = std::env::temp_dir().join(format!(
        "hummingbird-empty-{}-{}.sqlite",
        std::process::id(),
        std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)?
            .as_nanos()
    ));
    std::fs::OpenOptions::new()
        .write(true)
        .create_new(true)
        .open(&path)?;
    // A genuinely unavailable schema, through the normal read-only source
    // replacement seam, produces SQLite's actual 'no such table' failure.
    worker
        .replace_database(Database::open_read_only(&path)?)?
        .recv_timeout(Duration::from_secs(10))??;
    settle(&mut win, &worker)?;
    assert_eq!(win.question_status(results)?, QuestionStatus::Fault);
    assert_eq!(win.with_ready(results, |page| page.rows.len())?, None);
    let source_failure_visible =
        win.contains_text("Library unavailable: Library source: no such table: track")?;
    assert!(source_failure_visible);
    assert!(
        win.contains_text("3 recordings for ‘cafe’")?,
        "previous good rows remain honestly labelled"
    );
    win.click(stale_source_row)?;
    assert_eq!(
        win.with_model(|model| model.selected.id)?,
        None,
        "old source IDs cannot play from a replacement source"
    );

    worker
        .replace_database(Database::fixture()?)?
        .recv_timeout(Duration::from_secs(10))??;
    win.set(Library::QUERY, String::new())?;
    win.set(Library::SORT, Sort::Title)?;
    settle(&mut win, &worker)?;
    assert_eq!(ids(&win), initial_ids);
    assert_eq!(win.click(stale_source_row), Err(Error::StaleTarget));
    std::fs::remove_file(path)?;
    drop(win);
    worker.finish().map_err(|_| "library worker panicked")?;
    Ok(Transcript {
        sqlite_version,
        initial_ids,
        sorted_ids,
        matched_ids,
        played_id,
        imported_id: 5000,
        stale_completions,
        realized_rows,
        source_failure_visible,
    })
}
