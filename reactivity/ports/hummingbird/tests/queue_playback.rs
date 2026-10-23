use hummingbird_gpui_port::{
    queue::{Entry, EntryKey, Queue, Repeat, Track, TrackRef},
    queue_playback::{Plan, PlanStamp, PlaybackQueue},
};
fn track(id: i64) -> TrackRef {
    TrackRef::new(Track {
        path: format!("/recordings/{id}.flac").into(),
        track_id: Some(id),
        album_id: Some(1),
        title: format!("Recording {id}"),
        available_when_prepared: true,
    })
}
fn available(_: &Track) -> bool {
    true
}
fn draw(_: usize) -> usize {
    0
}
fn playback() -> PlaybackQueue {
    let mut playback = PlaybackQueue::new().unwrap();
    playback
        .append(vec![track(1), track(2), track(3)], &available, &mut draw)
        .unwrap();
    playback
}
#[test]
fn eos_is_qualified_by_session_occurrence_and_current_entry() {
    let mut player = playback();
    let first = player.queue().at(0).unwrap().key;
    let old = player.plan().unwrap().end_of_stream();
    player.play(first, &available).unwrap();
    assert!(!player.end_of_stream(old, &available, &mut draw).unwrap());
    let current = player.plan().unwrap().end_of_stream();
    assert!(
        player
            .end_of_stream(current, &available, &mut draw)
            .unwrap()
    );
    assert_eq!(player.queue().current_position(), Some(1));
    assert!(
        !player
            .end_of_stream(current, &available, &mut draw)
            .unwrap()
    );
    let old_session = player.plan().unwrap().end_of_stream();
    let mut replacement = playback();
    replacement.next(&available, &mut draw).unwrap();
    assert_eq!(replacement.queue().current(), player.queue().current());
    assert!(
        !replacement
            .end_of_stream(old_session, &available, &mut draw)
            .unwrap()
    );
}
#[test]
fn repeat_one_creates_a_new_occurrence_and_manual_next_bypasses_it() {
    let mut player = playback();
    player.set_repeat(Repeat::One, &available).unwrap();
    let before = player.plan().unwrap().clone();
    assert_eq!(before.lookahead.as_ref().unwrap().key, before.current.key);
    assert!(
        player
            .end_of_stream(before.end_of_stream(), &available, &mut draw)
            .unwrap()
    );
    let repeated = player.plan().unwrap();
    assert_eq!(repeated.current.key, before.current.key);
    assert_ne!(repeated.stamp(), before.stamp());
    assert!(
        !player
            .end_of_stream(before.end_of_stream(), &available, &mut draw)
            .unwrap()
    );
    player.next(&available, &mut draw).unwrap();
    assert_eq!(player.queue().current_position(), Some(1));
}
#[test]
fn every_accepted_queue_or_policy_edit_retires_previous_eos_authority() {
    let mut player = playback();
    let mut previous = player.plan().unwrap().end_of_stream();
    player
        .append(vec![track(4)], &available, &mut draw)
        .unwrap();
    assert!(
        !player
            .end_of_stream(previous, &available, &mut draw)
            .unwrap()
    );
    previous = player.plan().unwrap().end_of_stream();
    let last = player.queue().at(3).unwrap().key;
    player.move_entries(&[last], 1, &available).unwrap();
    assert!(
        !player
            .end_of_stream(previous, &available, &mut draw)
            .unwrap()
    );
    assert_eq!(player.plan().unwrap().lookahead.as_ref().unwrap().key, last);
    previous = player.plan().unwrap().end_of_stream();
    player.remove(&[last], &available).unwrap();
    assert!(
        !player
            .end_of_stream(previous, &available, &mut draw)
            .unwrap()
    );
    previous = player.plan().unwrap().end_of_stream();
    player.undo(&available).unwrap();
    assert!(
        !player
            .end_of_stream(previous, &available, &mut draw)
            .unwrap()
    );
    previous = player.plan().unwrap().end_of_stream();
    player.toggle_shuffle(&available, &mut draw).unwrap();
    assert!(
        !player
            .end_of_stream(previous, &available, &mut draw)
            .unwrap()
    );
    previous = player.plan().unwrap().end_of_stream();
    player.set_repeat(Repeat::All, &available).unwrap();
    assert!(
        !player
            .end_of_stream(previous, &available, &mut draw)
            .unwrap()
    );
    previous = player.plan().unwrap().end_of_stream();
    player.availability_changed(&|_| false).unwrap();
    assert!(
        !player
            .end_of_stream(previous, &available, &mut draw)
            .unwrap()
    );
    assert!(player.plan().unwrap().lookahead.is_none());
    previous = player.plan().unwrap().end_of_stream();
    player
        .replace(vec![track(5)], &available, &mut draw)
        .unwrap();
    assert!(
        !player
            .end_of_stream(previous, &available, &mut draw)
            .unwrap()
    );
    previous = player.plan().unwrap().end_of_stream();
    player.clear(true, &available).unwrap();
    assert!(
        !player
            .end_of_stream(previous, &available, &mut draw)
            .unwrap()
    );
    assert!(player.plan().unwrap().lookahead.is_none());
}
#[test]
fn no_op_edits_do_not_create_a_new_plan_and_borrowed_projection_clones_nothing() {
    let mut player = playback();
    let before = player.plan().unwrap().stamp();
    let first = player.queue().at(0).unwrap().key;
    assert!(!player.set_repeat(Repeat::Off, &available).unwrap());
    assert!(!player.move_entries(&[first], 0, &available).unwrap());
    assert!(!player.remove(&[], &available).unwrap());
    assert!(
        player
            .append(vec![], &available, &mut draw)
            .unwrap()
            .is_none()
    );
    for _ in 0..100 {
        let plan = player.plan().unwrap();
        assert_eq!(plan.stamp(), before);
        assert!(TrackRef::ptr_eq(
            &plan.current.track,
            &player.queue().entry(first).unwrap().track
        ));
    }
}
#[test]
fn removing_current_resolves_the_next_live_playable_key_and_old_plan_is_immutable() {
    let mut player = playback();
    let old = player.plan().unwrap().clone();
    let last = player.queue().at(2).unwrap().key;
    let available = |track: &Track| track.track_id != Some(2);
    player.remove(&[old.current.key], &available).unwrap();
    assert_eq!(player.plan().unwrap().current.key, last);
    assert_eq!(old.current.track.track_id, Some(1));
    assert!(
        !player
            .end_of_stream(old.end_of_stream(), &available, &mut draw)
            .unwrap()
    );
    player.remove(&[last], &available).unwrap();
    assert!(player.plan().is_none());
    player.undo(&available).unwrap();
    assert!(
        player.plan().is_none(),
        "undo while stopped must not start playback"
    );
}
#[test]
fn shuffled_wrap_commits_a_new_permutation_before_installing_its_successor() {
    let mut player = playback();
    let last = player.queue().at(2).unwrap().key;
    player.play(last, &available).unwrap();
    player.toggle_shuffle(&available, &mut draw).unwrap();
    player.set_repeat(Repeat::All, &available).unwrap();
    let before = player.plan().unwrap().clone();
    assert!(
        before.lookahead.is_none(),
        "a shuffled wrap is resolved at EOS"
    );
    assert!(
        player
            .end_of_stream(before.end_of_stream(), &available, &mut draw)
            .unwrap()
    );
    assert_eq!(player.queue().current_position(), Some(0));
    assert_ne!(player.plan().unwrap().stamp(), before.stamp());
}
#[test]
fn queue_and_plan_carriers_are_measured_without_claiming_a_stack_peak() {
    println!(
        "QUEUE_LAYOUT key={} option_key={} entry={} queue={} stamp={} plan={} option_plan={} controller={}",
        size_of::<EntryKey>(),
        size_of::<Option<EntryKey>>(),
        size_of::<Entry>(),
        size_of::<Queue>(),
        size_of::<PlanStamp>(),
        size_of::<Plan>(),
        size_of::<Option<Plan>>(),
        size_of::<PlaybackQueue>()
    );
    assert_eq!(size_of::<EntryKey>(), 8);
    assert_eq!(size_of::<Option<EntryKey>>(), 8);
    assert_eq!(size_of::<Entry>(), 16);
    if cfg!(target_pointer_width = "64") {
        assert_eq!(size_of::<PlanStamp>(), 16);
        assert_eq!(size_of::<Plan>(), 48);
        assert_eq!(size_of::<Option<Plan>>(), 48);
    }
}
