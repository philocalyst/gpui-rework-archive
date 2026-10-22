use gpui::{Error, Key, Role, Win, WindowOptions};
use hummingbird_gpui_port::{
    app::{Library, connect, recordings, track_key},
    database::Database,
    transcript::settle,
    worker::Worker,
};
use std::time::Duration;

#[test]
fn reconstructed_public_queue_has_a_new_list_domain_and_rejects_old_decoder_eos() {
    use hummingbird_gpui_port::{
        queue::{Track, TrackRef},
        queue_view::QueueScreen,
    };
    let track = TrackRef::new(Track {
        path: "/prepared/file.flac".into(),
        track_id: None,
        album_id: None,
        title: "Prepared file".into(),
        available_when_prepared: true,
    });
    let mut screen = QueueScreen::new(gpui::ListId::new(4000)).unwrap();
    screen.enqueue(track.clone());
    let old_eos = screen.playback().plan().unwrap().end_of_stream();
    let (sender, inbox) = gpui::Remote::bounded(2);
    let mut owner = Win::with_size(screen, 720, 420)
        .unwrap()
        .with_inbox(inbox, QueueScreen::receive_end_of_stream)
        .unwrap();
    let old_target = owner.query().name("Select queue entry 1").one().unwrap();
    owner
        .update(|screen| {
            *screen = QueueScreen::new(gpui::ListId::new(4001)).unwrap();
            screen.enqueue(track);
        })
        .unwrap();
    let new_target = owner.query().name("Select queue entry 1").one().unwrap();
    assert_ne!(old_target, new_target);
    assert_eq!(owner.activate(old_target), Err(Error::StaleTarget));
    let stamp = owner
        .with_model(|screen| screen.playback().plan().unwrap().stamp())
        .unwrap();
    sender.try_send(old_eos).unwrap();
    owner.deliver_ready(2).unwrap();
    assert_eq!(
        owner
            .with_model(|screen| screen.playback().plan().unwrap().stamp())
            .unwrap(),
        stamp
    );
    assert_eq!(
        owner
            .with_model(|screen| screen.playback().queue().len())
            .unwrap(),
        1
    );
}

#[test]
fn real_library_preparation_and_public_queue_input_preserve_keys_selection_and_source_admission() {
    let path = std::env::temp_dir().join(format!(
        "hummingbird-queue-{}-{}.flac",
        std::process::id(),
        fastrand::u64(..)
    ));
    std::fs::write(&path, b"availability fixture; no decoder claim").unwrap();
    let database = Database::fixture().unwrap();
    database
        .connection()
        .execute(
            "UPDATE track SET location = ?1 WHERE id = 44",
            [path.to_str().unwrap()],
        )
        .unwrap();
    let (worker, inbox) = Worker::new(database).unwrap();
    let (model, questions) = connect(worker.handle()).unwrap();
    let mut owner = Win::with_questions(
        model,
        questions,
        WindowOptions {
            size: [720, 1000],
            ..Default::default()
        },
    )
    .unwrap()
    .with_inbox(inbox, Library::receive)
    .unwrap();
    settle(&mut owner, &worker).unwrap();
    let list = owner.list(recordings(Default::default())).unwrap();
    owner.scroll_to_key(list, track_key(44)).unwrap();
    let item = owner.list_item(list, track_key(44)).unwrap();
    owner
        .activate(owner.role(Role::Button).within(item).one().unwrap())
        .unwrap();
    settle(&mut owner, &worker).unwrap();
    let add = owner.button("Add prepared recording 44 to queue");
    for _ in 0..3 {
        owner.activate(add).unwrap();
    }
    let (keys, stamp, queue_list) = owner
        .with_model(|model| {
            let queue = model.queue.playback().queue();
            let keys = (0..queue.len())
                .map(|index| queue.at(index).unwrap().key)
                .collect::<Vec<_>>();
            assert!(hummingbird_gpui_port::queue::TrackRef::ptr_eq(
                &queue.at(0).unwrap().track,
                &queue.at(2).unwrap().track
            ));
            assert_eq!(queue.at(0).unwrap().track.title, "Καλημέρα");
            (
                keys,
                model.queue.playback().plan().unwrap().stamp(),
                model.queue.list_id(),
            )
        })
        .unwrap();
    assert_ne!(keys[0], keys[2]);
    let first = owner
        .query()
        .name(&format!("Select queue entry {}", keys[0].get()))
        .one()
        .unwrap();
    owner.focus(first).unwrap();
    owner.key(Key::Space).unwrap();
    assert_eq!(
        owner
            .with_model(|model| model.queue.selected().to_vec())
            .unwrap(),
        vec![keys[0]]
    );
    assert_eq!(
        owner
            .with_model(|model| model.queue.playback().plan().unwrap().stamp())
            .unwrap(),
        stamp
    );
    let mut checked = None;
    owner
        .visit(|part| {
            if part.target() == first {
                checked = part.checked()
            }
        })
        .unwrap();
    assert_eq!(checked, Some(true));
    owner
        .activate(
            owner
                .query()
                .name(&format!("Select range to queue entry {}", keys[2].get()))
                .one()
                .unwrap(),
        )
        .unwrap();
    assert_eq!(
        owner
            .with_model(|model| model.queue.selected().to_vec())
            .unwrap(),
        keys
    );
    owner
        .activate(
            owner
                .query()
                .name(&format!("Select queue entry {}", keys[1].get()))
                .one()
                .unwrap(),
        )
        .unwrap();
    owner.activate(owner.button("Move selected last")).unwrap();
    assert_eq!(
        owner
            .with_model(|model| {
                let queue = model.queue.playback().queue();
                (0..queue.len())
                    .map(|index| queue.at(index).unwrap().key)
                    .collect::<Vec<_>>()
            })
            .unwrap(),
        vec![keys[1], keys[0], keys[2]]
    );
    let live = owner
        .query()
        .name(&format!("Select queue entry {}", keys[0].get()))
        .one()
        .unwrap();
    assert_eq!(
        live, first,
        "reordering keeps the keyed row's public target"
    );
    owner.activate(live).unwrap();
    owner.activate(owner.button("Remove selected")).unwrap();
    assert_eq!(owner.activate(first), Err(Error::StaleTarget));
    owner.activate(owner.button("Undo queue edit")).unwrap();
    let restored = owner
        .query()
        .name(&format!("Select queue entry {}", keys[0].get()))
        .one()
        .unwrap();
    assert_ne!(restored, first, "undo does not revive a retired UI target");
    assert_eq!(owner.activate(first), Err(Error::StaleTarget));
    assert_eq!(
        owner
            .list_state(owner.list(queue_list).unwrap())
            .unwrap()
            .len,
        3
    );

    // Commit a real service replacement, admit just its inbox notification,
    // and leave the new question completions pending. The previous good
    // prepared recording is still labelled honestly and cannot enqueue into
    // the new library generation. Existing owned queue tracks remain valid.
    worker
        .replace_database(Database::fixture().unwrap())
        .unwrap()
        .recv_timeout(Duration::from_secs(10))
        .unwrap()
        .unwrap();
    owner.deliver_ready(1).unwrap();
    assert_eq!(
        owner.with_model(|model| model.version.generation).unwrap(),
        1
    );
    assert!(
        owner
            .contains_text("Add prepared recording 44 to queue")
            .unwrap()
    );
    owner.activate(add).unwrap();
    assert_eq!(
        owner
            .with_model(|model| model.queue.playback().queue().len())
            .unwrap(),
        3
    );
    assert!(
        owner
            .contains_text("This prepared recording belongs to the previous library source")
            .unwrap()
    );
    assert_eq!(
        owner
            .with_model(|model| model
                .queue
                .playback()
                .queue()
                .at(0)
                .unwrap()
                .track
                .path
                .clone())
            .unwrap(),
        path
    );
    settle(&mut owner, &worker).unwrap();
    drop(owner);
    worker.finish().unwrap();
    std::fs::remove_file(path).unwrap();
}
