//! The real bounded Library question, with deterministic owned completion timing.
#[path = "../examples/support/library.rs"]
#[allow(dead_code)]
mod library;
#[path = "../examples/support/search_library.rs"]
#[allow(dead_code)]
mod search_library;
use gpui::{Completion, QuestionStatus, Questions, Role, StartError, Win, WindowOptions};
use search_library::{PAGE_LIMIT, SearchError, SearchInput, SearchLibrary, SearchPage};
use std::{sync::mpsc, time::Duration};

fn open() -> (
    Win<SearchLibrary, impl gpui::LaneSet<SearchLibrary>>,
    mpsc::Receiver<usize>,
) {
    type Job = (SearchInput, Completion<SearchPage, SearchError>);
    let (send, jobs) = mpsc::sync_channel::<Job>(1);
    let (done, finished) = mpsc::channel();
    std::thread::spawn(move || {
        while let Ok((input, completion)) = jobs.recv() {
            let page = search_library::search(input);
            let count = page.as_ref().map_or(0, |page| page.scanned);
            let _ = completion.complete(page);
            if done.send(count).is_err() {
                break;
            }
        }
    });
    let (questions, results) = Questions::new()
        .question(
            SearchLibrary::QUERY,
            |value| search_library::freeze(value, 250_000),
            move |input, completion| {
                send.try_send((input, completion))
                    .map_err(|error| match error {
                        mpsc::TrySendError::Full(_) => StartError::Busy,
                        mpsc::TrySendError::Disconnected(_) => StartError::Closed,
                    })
            },
        )
        .unwrap();
    let win = Win::with_questions(
        SearchLibrary::new(250_000, results),
        questions,
        WindowOptions {
            size: [760, 600],
            ..Default::default()
        },
    )
    .unwrap();
    (win, finished)
}
fn finish<L: gpui::LaneSet<SearchLibrary>>(
    win: &mut Win<SearchLibrary, L>,
    done: &mpsc::Receiver<usize>,
) -> usize {
    let scanned = done
        .recv_timeout(Duration::from_secs(5))
        .expect("bounded worker completes");
    win.deliver_ready(8).unwrap();
    scanned
}
#[test]
fn quarter_million_search_has_bounded_results_virtual_rows_and_exact_play_actions() {
    let (mut win, done) = open();
    assert_eq!(finish(&mut win, &done), 250_000);
    let reader = win.root().unwrap().results;
    assert_eq!(
        win.with_ready(reader, |page| page.ids.len()).unwrap(),
        Some(PAGE_LIMIT)
    );
    assert!(win.inspect().unwrap().nodes.len() < 100);
    let input = win
        .role(Role::TextInput)
        .name("Search recordings")
        .one()
        .unwrap();
    let old_play = win
        .role(Role::Button)
        .name("Play Track 000000 — Library recording")
        .one()
        .unwrap();
    win.type_text(input, "Track 000042").unwrap();
    assert_eq!(win.question_status(reader), Ok(QuestionStatus::Pending));
    assert!(win.contains_text("Updating").unwrap());
    // The retained rows still carry their own OLD frozen query, never the new
    // input relabeled as a current answer.
    assert!(win.contains_text("250000 matches for ‘’").unwrap());
    assert_eq!(
        win.role(Role::Button)
            .name("Play Track 000000 — Library recording")
            .one()
            .unwrap(),
        old_play
    );
    win.click(old_play).unwrap();
    assert_eq!(*win.root().unwrap().selected, 0);
    finish(&mut win, &done);
    let actual = win
        .with_ready(reader, |page| {
            page.ids.iter().map(|id| id.0).collect::<Vec<_>>()
        })
        .unwrap()
        .unwrap();
    assert_eq!(actual, [42]);
    let play = win
        .role(Role::Button)
        .name("Play Track 000042 — Library recording")
        .one()
        .unwrap();
    let before = win.question_info(reader).unwrap();
    win.click(play).unwrap();
    assert_eq!(*win.root().unwrap().selected, 42);
    assert_eq!(
        win.question_info(reader).unwrap().stats.dispatched,
        before.stats.dispatched
    );
    assert!(done.try_recv().is_err());
    assert!(win.contains_text("1 matches for ‘Track 000042’").unwrap());
}
#[test]
fn worker_matches_an_independent_full_scan_and_bounds_utf8_input_and_result_pages() {
    for query in ["", "TRACK 000042", "99", "recording", "none such", "é"] {
        let page = search_library::search(search_library::freeze(query, 250_000)).unwrap();
        let lower = query.to_ascii_lowercase();
        let all = (0..250_000)
            .filter(|id| {
                format!("Track {id:06} — Library recording")
                    .to_ascii_lowercase()
                    .contains(&lower)
            })
            .collect::<Vec<_>>();
        assert_eq!(page.matches, all.len());
        assert_eq!(page.scanned, 250_000);
        assert_eq!(
            page.ids.iter().map(|id| id.0 as usize).collect::<Vec<_>>(),
            all[..all.len().min(PAGE_LIMIT)]
        );
    }
    assert!(search_library::search(search_library::freeze(&"é".repeat(128), 1)).is_ok());
    assert!(matches!(
        search_library::search(search_library::freeze(&"é".repeat(129), 1)),
        Err(SearchError::QueryTooLong)
    ));
}

#[test]
fn bounded_library_snapshot_and_page_allocation_ledger() {
    let mut input = None;
    let frozen =
        allocation_counter::measure(|| input = Some(search_library::freeze("Track", 250_000)));
    assert_eq!(frozen.count_total, 0);
    let mut page = None;
    let work = allocation_counter::measure(|| {
        page = Some(search_library::search(input.take().unwrap()).unwrap())
    });
    assert_eq!(
        (work.count_total, work.bytes_total),
        (1, PAGE_LIMIT as u64 * 8)
    );
    let page = page.unwrap();
    assert_eq!(page.ids.capacity(), PAGE_LIMIT);
    println!(
        "library_query={},input={},page={},result_capacity={},worker_stack_reserved={},freeze_allocations={},search_allocations={},search_requested={}",
        size_of::<search_library::Query>(),
        size_of::<SearchInput>(),
        size_of::<SearchPage>(),
        page.ids.capacity() * size_of::<library::catalogue::TrackId>(),
        256 * 1024,
        frozen.count_total,
        work.count_total,
        work.bytes_total
    );
}

#[test]
fn library_domain_restore_remints_readers_and_targets_and_rejects_old_work() {
    type Job = (SearchInput, Completion<SearchPage, SearchError>);
    let (send, jobs) = mpsc::channel::<Job>();
    let (questions, old_reader) = Questions::new()
        .question(
            SearchLibrary::QUERY,
            |value| search_library::freeze(value, 250_000),
            move |input, cap| {
                send.send((input, cap)).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let mut original = Win::with_questions(
        SearchLibrary::new(250_000, old_reader),
        questions,
        WindowOptions::default(),
    )
    .unwrap();
    let old_input = original.input();
    let (_, old_cap) = jobs.recv().unwrap();
    original
        .set(SearchLibrary::QUERY, "Track 000042".into())
        .unwrap();
    original.set(SearchLibrary::SELECTED, 42).unwrap();
    let json = serde_json::to_string(&original.root().unwrap().save()).unwrap();
    assert_eq!(
        serde_json::from_str::<serde_json::Value>(&json)
            .unwrap()
            .as_object()
            .unwrap()
            .len(),
        3
    );
    drop(original);
    assert!(old_cap.is_cancelled());
    assert!(matches!(
        old_cap.complete(search_library::search(search_library::freeze(
            "obsolete", 250_000
        ))),
        Err(gpui::CompleteError::Closed(_))
    ));
    let (send, jobs) = mpsc::channel::<Job>();
    let (questions, reader) = Questions::new()
        .question(
            SearchLibrary::QUERY,
            |value| search_library::freeze(value, 250_000),
            move |input, cap| {
                send.send((input, cap)).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let model = SearchLibrary::restore(serde_json::from_str(&json).unwrap(), reader);
    let mut restored = Win::with_questions(model, questions, WindowOptions::default()).unwrap();
    assert_eq!(*restored.root().unwrap().selected, 42);
    assert_eq!(
        restored.question_status(old_reader),
        Err(gpui::Error::Question(gpui::QuestionFault::Revoked))
    );
    assert_eq!(restored.activate(old_input), Err(gpui::Error::StaleTarget));
    let (input, cap) = jobs.recv().unwrap();
    cap.complete(search_library::search(input)).unwrap();
    restored.deliver_ready(8).unwrap();
    assert_eq!(
        restored.with_ready(reader, |page| page.ids[0].0).unwrap(),
        Some(42)
    );
}
