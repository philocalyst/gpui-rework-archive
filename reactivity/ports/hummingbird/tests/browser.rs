use gpui::{LaneSet, Role, Win, WindowOptions};
use hummingbird_gpui_port::{
    app::{Library, connect},
    browser::{Browser, Route},
    database::Database,
    transcript::settle,
    worker::Worker,
};

fn open() -> (Worker, Win<Library, impl LaneSet<Library>>) {
    let (worker, inbox) = Worker::new(Database::collection_fixture().unwrap()).unwrap();
    let (model, questions) = connect(worker.handle()).unwrap();
    let mut owner = Win::with_questions(
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
    settle(&mut owner, &worker).unwrap();
    (worker, owner)
}
fn route<L: LaneSet<Library>>(win: &mut Win<Library, L>, route: Route) {
    win.update(|model| model.navigate(route)).unwrap();
}
fn ids<L: LaneSet<Library>>(win: &Win<Library, L>) -> Vec<i64> {
    let result = win.with_model(|m| m.results).unwrap();
    win.with_ready(result, |page| page.ids().collect())
        .unwrap()
        .unwrap()
}
#[test]
fn real_collection_sql_and_public_nested_sources_browse_relations_and_history_without_play() {
    let (worker, mut win) = open();
    win.activate(win.role(Role::Button).name("Albums").one().unwrap())
        .unwrap();
    settle(&mut win, &worker).unwrap();
    let result = win.with_model(|m| m.results).unwrap();
    assert_eq!(
        win.with_ready(result, |page| page
            .collections
            .rows
            .iter()
            .map(|r| r.id)
            .collect::<Vec<_>>())
            .unwrap()
            .unwrap(),
        [10, 20, 40, 30]
    );
    win.activate(win.button("Open Album")).unwrap();
    settle(&mut win, &worker).unwrap();
    assert_eq!(ids(&win), [1, 3]);
    win.activate(win.button("Back")).unwrap();
    settle(&mut win, &worker).unwrap();
    win.activate(win.button("Forward")).unwrap();
    settle(&mut win, &worker).unwrap();
    assert_eq!(ids(&win), [1, 3]);
    route(&mut win, Route::Artist(1));
    settle(&mut win, &worker).unwrap();
    assert_eq!(ids(&win), [1, 3, 2, 44]);
    assert_eq!(
        win.with_ready(result, |page| page
            .collections
            .rows
            .iter()
            .map(|r| r.id)
            .collect::<Vec<_>>())
            .unwrap()
            .unwrap(),
        [10]
    );
    route(&mut win, Route::Artists);
    settle(&mut win, &worker).unwrap();
    assert_eq!(
        win.with_ready(result, |page| page
            .collections
            .rows
            .iter()
            .map(|r| r.id)
            .collect::<Vec<_>>())
            .unwrap()
            .unwrap(),
        [1, 2, 32, 30]
    );
    route(&mut win, Route::Playlists);
    settle(&mut win, &worker).unwrap();
    assert!(win.contains_text("Open Evening Καφέ").unwrap());
    win.activate(win.button("Open Evening Καφέ")).unwrap();
    settle(&mut win, &worker).unwrap();
    assert_eq!(ids(&win), [44, 90, 11]);
    assert_eq!(
        win.with_ready(result, |page| page.rows.playlist_items.clone())
            .unwrap()
            .unwrap(),
        [702, 701, 703]
    );
    win.set(Library::BROWSER.source(&Browser::QUERY), "μαρ".into())
        .unwrap();
    settle(&mut win, &worker).unwrap();
    assert_eq!(ids(&win), [44]);
    win.set(Library::BROWSER.source(&Browser::QUERY), String::new())
        .unwrap();
    route(&mut win, Route::Album(40));
    settle(&mut win, &worker).unwrap();
    assert!(ids(&win).is_empty());
    route(&mut win, Route::Playlist(3));
    settle(&mut win, &worker).unwrap();
    assert!(ids(&win).is_empty());
    route(&mut win, Route::Album(999));
    settle(&mut win, &worker).unwrap();
    assert!(
        win.contains_text("This collection or occurrence is no longer available")
            .unwrap()
    );
    assert!(
        win.with_model(|m| m.queue.playback().queue().is_empty())
            .unwrap()
    );
    drop(win);
    worker.finish().unwrap();
}
#[test]
fn navigation_history_is_bounded_and_new_branch_discards_forward_routes() {
    let (worker, mut win) = open();
    for id in 0..105 {
        route(&mut win, Route::Album(id));
    }
    assert_eq!(
        win.with_model(|m| m.browser().navigation().len()).unwrap(),
        100
    );
    win.activate(win.button("Back")).unwrap();
    assert!(
        win.with_model(|m| m.browser().navigation().can_forward())
            .unwrap()
    );
    route(&mut win, Route::Tracks);
    assert!(
        !win.with_model(|m| m.browser().navigation().can_forward())
            .unwrap()
    );
    assert_eq!(
        win.with_model(|m| m.browser().navigation().current())
            .unwrap(),
        Route::Tracks
    );
    drop(win);
    worker.finish().unwrap();
}
