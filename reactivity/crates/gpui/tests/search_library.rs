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
            let mut count = 0;
            let _ = completion.run_cancellable(input, |input, cancellation| {
                search_library::search_cancellable(input, |scanned| {
                    count = scanned;
                    cancellation.is_cancelled()
                })
            });
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
fn a_cancelled_catalogue_scan_releases_credit_at_a_bounded_checkpoint_for_the_latest_query() {
    type Job = (SearchInput, Completion<SearchPage, SearchError>);
    let (send, jobs) = mpsc::channel::<Job>();
    let (questions, results) = Questions::new()
        .question(
            SearchLibrary::QUERY,
            |query| search_library::freeze(query, 250_000),
            move |input, cap| {
                send.send((input, cap)).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let mut win = Win::with_questions(
        SearchLibrary::new(250_000, results),
        questions,
        WindowOptions::default(),
    )
    .unwrap();
    let (input, cap) = jobs.recv().unwrap();
    let (checkpoint, reached) = mpsc::channel();
    let (resume, wait) = mpsc::channel();
    let worker = std::thread::spawn(move || {
        let mut scanned = 0;
        cap.run_cancellable(input, |input, cancellation| {
            search_library::search_cancellable(input, |progress| {
                scanned = progress;
                if progress == search_library::CANCELLATION_BATCH {
                    checkpoint.send(()).unwrap();
                    wait.recv().unwrap();
                }
                cancellation.is_cancelled()
            })
        })
        .unwrap();
        scanned
    });
    reached.recv().unwrap();
    win.set(SearchLibrary::QUERY, "Track 000042".into())
        .unwrap();
    assert!(
        jobs.try_recv().is_err(),
        "old physical work has not stopped yet"
    );
    resume.send(()).unwrap();
    assert_eq!(worker.join().unwrap(), search_library::CANCELLATION_BATCH);
    win.deliver_ready(8).unwrap();
    assert_eq!(win.question_status(results), Ok(QuestionStatus::Pending));
    let (input, cap) = jobs
        .try_recv()
        .expect("latest work starts after the cancellation wake");
    cap.run_cancellable(input, |input, cancellation| {
        search_library::search_cancellable(input, |_| cancellation.is_cancelled())
    })
    .unwrap();
    win.deliver_ready(8).unwrap();
    let answer = win
        .with_ready(results, |page| {
            (
                page.query.as_str().to_owned(),
                page.ids.iter().map(|id| id.0).collect::<Vec<_>>(),
                page.scanned,
            )
        })
        .unwrap()
        .unwrap();
    assert_eq!(answer, ("Track 000042".into(), vec![42], 250_000));
}

#[test]
#[ignore = "manual release cancellation-latency evidence; run alone on a quiet CPU"]
fn paired_real_library_cancellation_cost() {
    fn measure(cooperative: bool, supersede: bool) -> (u128, usize) {
        type Job = (SearchInput, Completion<SearchPage, SearchError>);
        let (send, jobs) = mpsc::channel::<Job>();
        let (questions, results) = Questions::new()
            .question(
                SearchLibrary::QUERY,
                |query| search_library::freeze(query, 250_000),
                move |input, cap| {
                    send.send((input, cap)).unwrap();
                    Ok(())
                },
            )
            .unwrap();
        let mut win = Win::with_questions(
            SearchLibrary::new(250_000, results),
            questions,
            WindowOptions::default(),
        )
        .unwrap();
        let (input, cap) = jobs.recv().unwrap();
        let (checkpoint, reached) = mpsc::channel();
        let (resume, wait) = mpsc::channel();
        let (done, finished) = mpsc::channel();
        let worker = std::thread::spawn(move || {
            let mut scanned = 0;
            cap.run_cancellable(input, |input, cancellation| {
                search_library::search_cancellable(input, |progress| {
                    scanned = progress;
                    if progress == search_library::CANCELLATION_BATCH {
                        checkpoint.send(()).unwrap();
                        wait.recv().unwrap();
                    }
                    cooperative && cancellation.is_cancelled()
                })
            })
            .unwrap();
            done.send(scanned).unwrap();
        });
        reached.recv().unwrap();
        if supersede {
            win.set(SearchLibrary::QUERY, "Track 000042".into())
                .unwrap();
        }
        let started = std::time::Instant::now();
        resume.send(()).unwrap();
        let scanned = finished.recv().unwrap();
        if supersede {
            win.deliver_ready(8).unwrap();
            let (_, next) = jobs.try_recv().expect("newest physical dispatch is ready");
            assert!(!next.is_cancelled());
            drop(next);
        }
        let elapsed = started.elapsed().as_nanos();
        worker.join().unwrap();
        if !supersede {
            assert_eq!(scanned, 250_000);
            win.deliver_ready(8).unwrap();
            assert_eq!(
                win.with_ready(results, |page| page.matches).unwrap(),
                Some(250_000)
            );
        } else {
            assert_eq!(scanned, if cooperative { 128 } else { 250_000 });
        }
        (elapsed, scanned)
    }
    println!("round,kind,cooperative,ns,scanned");
    for round in 0..7 {
        for supersede in [false, true] {
            for cooperative in if round % 2 == 0 {
                [false, true]
            } else {
                [true, false]
            } {
                let (elapsed, scanned) = measure(cooperative, supersede);
                println!(
                    "{round},{},{cooperative},{elapsed},{scanned}",
                    if supersede {
                        "obsolete_to_new_dispatch"
                    } else {
                        "current_remaining_scan"
                    }
                );
            }
        }
    }
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
