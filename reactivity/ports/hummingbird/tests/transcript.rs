#[test]
fn real_database_search_list_play_import_stale_completion_and_failure_use_public_owner() {
    let transcript = hummingbird_gpui_port::transcript::run().unwrap();
    assert_eq!(transcript.played_id, 44);
    assert_eq!(transcript.imported_id, 5000);
    assert!(transcript.source_failure_visible);
}

#[test]
fn dropping_the_public_owner_cancels_work_and_service_shutdown_revokes_cloned_handles() {
    use hummingbird_gpui_port::{
        app::{Library, connect},
        database::Database,
        worker::Worker,
    };
    let (worker, inbox) = Worker::new(Database::fixture().unwrap()).unwrap();
    let handle = worker.handle();
    let (model, questions) = connect(handle.clone()).unwrap();
    let owner = gpui::Win::with_questions(model, questions, gpui::WindowOptions::default())
        .unwrap()
        .with_inbox(inbox, Library::receive)
        .unwrap();
    drop(owner);
    worker.finish().unwrap();
    // Retaining an otherwise inert service handle must not prevent shutdown.
    drop(handle);
}

#[test]
fn committed_database_revision_cannot_be_mislabelled_before_its_inbox_notification_is_delivered() {
    use gpui::{QuestionStatus, Win, WindowOptions};
    use hummingbird_gpui_port::{
        app::{Library, connect},
        database::Database,
        transcript::settle,
        worker::Worker,
    };
    use std::time::Duration;
    let (worker, inbox) = Worker::new(Database::fixture().unwrap()).unwrap();
    let (model, questions) = connect(worker.handle()).unwrap();
    let results = model.results;
    // Hold the real Inbox unbound to expose the worker/model revision gap.
    let mut owner = Win::with_questions(model, questions, WindowOptions::default()).unwrap();
    settle(&mut owner, &worker).unwrap();
    let committed = worker
        .prepend_fixture_track()
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap()
        .unwrap();
    assert_eq!(committed.revision, 1);
    assert_eq!(owner.with_model(|model| model.version.revision).unwrap(), 0);
    owner.set(Library::QUERY, "Arrival".into()).unwrap();
    settle(&mut owner, &worker).unwrap();
    assert_eq!(
        owner.question_status(results).unwrap(),
        QuestionStatus::Fault
    );
    assert_eq!(
        owner
            .with_ready(results, |page| page.input.version.revision)
            .unwrap(),
        None
    );
    assert!(
        owner
            .contains_text("Library unavailable: The library source changed")
            .unwrap()
    );
    let mut owner = owner.with_inbox(inbox, Library::receive).unwrap();
    settle(&mut owner, &worker).unwrap();
    assert_eq!(
        owner
            .with_ready(results, |page| (
                page.input.version.revision,
                page.ids().collect::<Vec<_>>()
            ))
            .unwrap(),
        Some((1, vec![5000]))
    );
    drop(owner);
    worker.finish().unwrap();
}
