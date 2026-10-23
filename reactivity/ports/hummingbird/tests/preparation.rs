use gpui::{LaneSet, Role, StartError, Win, WindowOptions};
use hummingbird_gpui_port::{
    app::{Library, PreparationStatus, connect, recordings, track_key},
    database::Database,
    queue::TrackRef,
    transcript::settle,
    worker::{Selection, Worker},
};
use std::{path::PathBuf, sync::mpsc::RecvTimeoutError, time::Duration};

fn open() -> (Worker, Win<Library, impl LaneSet<Library>>) {
    let (worker, inbox) = Worker::new(Database::fixture().unwrap()).unwrap();
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
fn choose<L: LaneSet<Library>>(owner: &mut Win<Library, L>, id: i64) {
    let domain = owner
        .with_model(|model| recordings(*model.version))
        .unwrap();
    let list = owner.list(domain).unwrap();
    owner.scroll_to_key(list, track_key(id)).unwrap();
    let item = owner.list_item(list, track_key(id)).unwrap();
    owner
        .activate(
            owner
                .role(Role::Button)
                .text("Prepare")
                .within(item)
                .one()
                .unwrap(),
        )
        .unwrap();
}
#[test]
fn preparation_is_explicit_and_search_retries_and_import_keep_the_same_prepared_lease() {
    let (worker, mut owner) = open();
    assert_eq!(
        owner
            .with_model(|model| model.preparation_status())
            .unwrap(),
        PreparationStatus::Empty
    );
    let search = owner.with_model(|model| model.results).unwrap();
    owner.retry(search).unwrap();
    settle(&mut owner, &worker).unwrap();
    assert_eq!(
        owner
            .with_model(|model| model.preparation_status())
            .unwrap(),
        PreparationStatus::Empty
    );
    choose(&mut owner, 44);
    settle(&mut owner, &worker).unwrap();
    let prepared = owner
        .with_model(|model| model.prepared().unwrap().1.clone())
        .unwrap();
    owner.retry(search).unwrap();
    settle(&mut owner, &worker).unwrap();
    worker
        .prepend_fixture_track()
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap()
        .unwrap();
    settle(&mut owner, &worker).unwrap();
    assert!(
        owner
            .with_model(|model| TrackRef::ptr_eq(&prepared, model.prepared().unwrap().1))
            .unwrap()
    );
    assert!(
        owner
            .with_model(|model| model.queue.playback().queue().is_empty())
            .unwrap()
    );
    drop(owner);
    worker.finish().unwrap();
}
#[test]
fn full_worker_result_lane_visibly_fails_the_pending_owner_instead_of_losing_completion() {
    let (worker, mut owner) = open();
    for sequence in 100..108 {
        worker
            .handle()
            .prepare(Selection {
                id: Some(44),
                sequence,
                generation: 0,
            })
            .unwrap();
        worker
            .checkpoint()
            .unwrap()
            .recv_timeout(Duration::from_secs(10))
            .unwrap();
    }
    choose(&mut owner, 44);
    assert_eq!(
        owner
            .with_model(|model| model.preparation_status())
            .unwrap(),
        PreparationStatus::Pending
    );
    match worker.checkpoint() {
        Ok(reply) => assert_eq!(
            reply.recv_timeout(Duration::from_secs(10)),
            Err(RecvTimeoutError::Disconnected)
        ),
        Err(error) => assert!(matches!(error.0, StartError::Closed)),
    }
    // First admit the full buffered batch, then the budgeted terminal event.
    for _ in 0..3 {
        owner.deliver_ready(32).unwrap();
    }
    assert_eq!(
        owner
            .with_model(|model| model.preparation_status())
            .unwrap(),
        PreparationStatus::Failed
    );
    assert!(
        owner
            .contains_text("Library worker closed before preparation completed")
            .unwrap()
    );
    assert!(
        owner
            .with_model(|model| model.prepared().is_none())
            .unwrap()
    );
    assert!(
        owner
            .with_model(|model| model.queue.playback().queue().is_empty())
            .unwrap()
    );
    assert_eq!(owner.deliver_ready(32).unwrap().received, 0);
    drop(owner);
    worker.finish().unwrap();
}
#[test]
fn public_selection_and_source_replacement_cannot_reuse_an_issued_reply_authority() {
    let (worker, mut owner) = open();
    choose(&mut owner, 44);
    worker
        .checkpoint()
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap();
    let old = owner.with_model(|model| *model.selected).unwrap();
    let replacement = Database::fixture().unwrap();
    replacement
        .connection()
        .execute(
            "UPDATE track SET location='/fresh/source.flac' WHERE id=44",
            [],
        )
        .unwrap();
    let committed = worker
        .replace_database(replacement)
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap()
        .unwrap();
    // A client may know the committed revision before accepting its buffered
    // notification. Public typed data edits cannot reset private issuance.
    owner.set(Library::VERSION, committed).unwrap();
    owner
        .set(
            Library::SELECTED,
            Selection {
                generation: committed.generation,
                ..Selection::default()
            },
        )
        .unwrap();
    owner
        .update(|model| model.prepare(44, committed.generation))
        .unwrap();
    let current = owner.with_model(|model| *model.selected).unwrap();
    assert!(current.sequence > old.sequence);
    settle(&mut owner, &worker).unwrap();
    assert_eq!(
        owner
            .with_model(|model| model.prepared().unwrap().0)
            .unwrap(),
        current
    );
    assert_eq!(
        owner
            .with_model(|model| model.prepared().unwrap().1.path.clone())
            .unwrap(),
        PathBuf::from("/fresh/source.flac")
    );
    worker.handle().prepare_and_play(old).unwrap();
    settle(&mut owner, &worker).unwrap();
    assert_eq!(
        owner
            .with_model(|model| model.prepared().unwrap().0)
            .unwrap(),
        current
    );
    assert!(
        owner
            .with_model(|model| model.queue.playback().queue().is_empty())
            .unwrap()
    );
    drop(owner);
    worker.finish().unwrap();
}
#[test]
fn public_selection_change_revokes_buffered_preparation_and_closed_commands_fail_immediately() {
    let (worker, mut owner) = open();
    choose(&mut owner, 44);
    worker
        .checkpoint()
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap();
    let old = owner.with_model(|model| *model.selected).unwrap();
    owner
        .set(
            Library::SELECTED,
            Selection {
                id: Some(90),
                ..old
            },
        )
        .unwrap();
    assert_eq!(
        owner
            .with_model(|model| model.preparation_status())
            .unwrap(),
        PreparationStatus::Canceled
    );
    settle(&mut owner, &worker).unwrap();
    assert!(
        owner
            .with_model(|model| model.prepared().is_none())
            .unwrap()
    );
    worker.finish().unwrap();
    owner.update(|model| model.prepare(90, 0)).unwrap();
    assert_eq!(
        owner
            .with_model(|model| model.preparation_status())
            .unwrap(),
        PreparationStatus::Failed
    );
    assert!(owner.contains_text("Library worker is closed").unwrap());
    drop(owner);
}

#[test]
fn failed_preparation_is_retired_by_full_public_selection_and_source_identity() {
    let (worker, mut owner) = open();
    worker.finish().unwrap();
    owner.update(|model| model.prepare(44, 0)).unwrap();
    assert_eq!(
        owner.with_model(Library::preparation_status).unwrap(),
        PreparationStatus::Failed
    );
    assert!(owner.contains_text("Library worker is closed").unwrap());
    let failed = owner.with_model(|model| *model.selected).unwrap();
    for selected in [
        Selection {
            id: Some(90),
            ..failed
        },
        Selection {
            sequence: failed.sequence + 1,
            ..failed
        },
        Selection {
            generation: failed.generation + 1,
            ..failed
        },
    ] {
        owner.set(Library::SELECTED, selected).unwrap();
        assert_eq!(
            owner.with_model(Library::preparation_status).unwrap(),
            PreparationStatus::Canceled
        );
        assert!(
            !owner
                .contains_text("Recording unavailable: Library worker is closed")
                .unwrap()
        );
        owner.set(Library::SELECTED, failed).unwrap();
    }
    owner
        .set(
            Library::VERSION,
            hummingbird_gpui_port::search::Version {
                generation: 1,
                revision: 1,
            },
        )
        .unwrap();
    assert_eq!(
        owner.with_model(Library::preparation_status).unwrap(),
        PreparationStatus::Canceled
    );
}
