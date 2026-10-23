use gpui::{Win, WindowOptions};
use hummingbird_gpui_port::{
    app::{Library, connect},
    database::Database,
    worker::{Selection, Worker},
};
use std::time::Duration;
fn reject_prequeued(selection: Selection) {
    let (worker, inbox) = Worker::new(Database::fixture().unwrap()).unwrap();
    let (model, questions) = connect(worker.handle()).unwrap();
    let mut owner = Win::with_questions(model, questions, WindowOptions::default())
        .unwrap()
        .with_inbox_status(inbox, Library::receive)
        .unwrap();
    worker.handle().prepare(selection).unwrap();
    worker
        .checkpoint()
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap();
    owner.update(|model| model.prepare(44, 0)).unwrap();
    worker
        .checkpoint()
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap();
    owner.deliver_ready(32).unwrap();
    let prepared = owner
        .with_model(|model| model.prepared().unwrap().1.track_id)
        .unwrap();
    drop(owner);
    worker.finish().unwrap();
    assert_eq!(prepared, Some(44));
}

#[test]
fn prequeued_public_request_cannot_claim_library_issued_authority() {
    reject_prequeued(Selection {
        id: Some(90),
        sequence: 1,
        generation: 0,
    });
}
#[test]
fn prequeued_wrong_generation_cannot_fail_a_current_request_with_the_same_sequence() {
    reject_prequeued(Selection {
        id: Some(44),
        sequence: 1,
        generation: 1,
    });
}
