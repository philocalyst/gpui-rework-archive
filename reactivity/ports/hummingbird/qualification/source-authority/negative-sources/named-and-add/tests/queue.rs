use hummingbird_gpui_port::queue::{
    EntryKey, LARGE_CHANGE, Navigation, Queue, QueueError, Repeat, Track, TrackRef, UNDO_LIMIT,
};

fn track(id: i64) -> TrackRef {
    TrackRef::new(Track {
        path: format!("/recordings/{id}.flac").into(),
        track_id: Some(id),
        album_id: Some(id / 10),
        title: format!("Recording {id}"),
        available_when_prepared: true,
    })
}
fn available(track: &Track) -> bool {
    track.track_id != Some(2)
}
fn draw(_: usize) -> usize {
    0
}
fn queue(ids: &[i64]) -> Queue {
    let mut queue = Queue::default();
    queue
        .append(ids.iter().map(|&id| track(id)).collect(), &mut draw)
        .unwrap();
    queue
}
fn keys(queue: &Queue) -> Vec<EntryKey> {
    (0..queue.len())
        .map(|index| queue.at(index).unwrap().key)
        .collect()
}
fn ids(queue: &Queue) -> Vec<i64> {
    (0..queue.len())
        .map(|index| queue.at(index).unwrap().track.track_id.unwrap())
        .collect()
}
fn snapshot(queue: &Queue) -> (Vec<EntryKey>, Option<EntryKey>, bool) {
    (keys(queue), queue.current(), queue.shuffled())
}

#[test]
fn manual_next_bypasses_repeat_one_and_navigation_skips_unavailable_paths() {
    let mut queue = queue(&[1, 2, 3]);
    let first = queue.at(0).unwrap().key;
    let last = queue.at(2).unwrap().key;
    assert_eq!(
        queue.next(false, &available, &mut draw),
        Navigation::Changed(first)
    );
    queue.set_repeat(Repeat::One);
    assert_eq!(
        queue.next(false, &available, &mut draw),
        Navigation::Repeat(first)
    );
    assert_eq!(
        queue.next(true, &available, &mut draw),
        Navigation::Changed(last)
    );
    assert_eq!(queue.next(true, &available, &mut draw), Navigation::End);
    assert_eq!(
        queue.previous(&available, &mut draw),
        Navigation::Changed(first)
    );
    assert_eq!(queue.previous(&available, &mut draw), Navigation::End);
    queue.set_repeat(Repeat::All);
    assert_eq!(
        queue.previous(&available, &mut draw),
        Navigation::Changed(last)
    );
    assert_eq!(
        queue.next(false, &available, &mut draw),
        Navigation::Changed(first)
    );
    queue.set_always_repeat(true);
    queue.set_repeat(Repeat::Off);
    assert_eq!(queue.repeat(), Repeat::All);
    queue.set_always_repeat(false);
    assert_eq!(queue.repeat(), Repeat::All);
    assert_eq!(queue.next(false, &|_| false, &mut draw), Navigation::End);
}

#[test]
fn duplicate_tracks_share_metadata_but_keep_distinct_entry_and_original_identity() {
    let shared = track(1);
    let mut queue = Queue::default();
    queue
        .append(vec![shared.clone(), track(3), shared.clone()], &mut draw)
        .unwrap();
    let original = keys(&queue);
    assert_ne!(original[0], original[2]);
    assert!(TrackRef::ptr_eq(
        &queue.at(0).unwrap().track,
        &queue.at(2).unwrap().track
    ));
    queue.jump(original[2], &available).unwrap();
    queue.toggle_shuffle(&mut draw);
    queue.toggle_shuffle(&mut draw);
    assert_eq!(queue.current(), Some(original[2]));
    assert_eq!(queue.current_position(), Some(2));
    assert_eq!(keys(&queue), original);
    queue.remove(&[original[0]]);
    assert_eq!(queue.current(), Some(original[2]));
    assert!(queue.entry(original[0]).is_none());
    assert!(queue.undo());
    assert_eq!(keys(&queue), original);
    assert!(TrackRef::ptr_eq(&shared, &queue.at(0).unwrap().track));
}

#[test]
fn no_current_survives_remove_move_shuffle_and_undo() {
    let mut queue = queue(&[1, 3, 4]);
    let first = queue.at(0).unwrap().key;
    assert!(queue.remove(&[first]));
    assert_eq!(queue.current(), None);
    assert!(queue.undo());
    assert_eq!(queue.current(), None);
    assert!(queue.move_entries(&[first], 2));
    assert_eq!(queue.current(), None);
    queue.toggle_shuffle(&mut draw);
    queue.toggle_shuffle(&mut draw);
    assert_eq!(queue.current(), None);
    assert!(queue.undo());
    assert_eq!(queue.current(), None);
}

#[test]
fn inverse_operations_restore_full_order_current_and_original_permutation() {
    let mut queue = queue(&[1, 3, 4, 5, 6]);
    let current = queue.at(3).unwrap().key;
    queue.jump(current, &available).unwrap();
    queue.toggle_shuffle(&mut draw);
    let before = snapshot(&queue);
    let first = queue.at(0).unwrap().key;
    let last = queue.at(4).unwrap().key;
    queue.move_entries(&[last, first, first], 1);
    assert_eq!(queue.current(), Some(current));
    assert!(queue.undo());
    assert_eq!(snapshot(&queue), before);
    queue.insert(99, vec![track(7), track(8)]).unwrap();
    assert!(queue.undo());
    assert_eq!(snapshot(&queue), before);
    queue.remove(&[first, current]);
    assert_eq!(queue.current(), None);
    assert!(queue.undo());
    assert_eq!(snapshot(&queue), before);
    queue.clear(true);
    assert_eq!(keys(&queue), vec![current]);
    assert!(queue.undo());
    assert_eq!(snapshot(&queue), before);
    queue.replace(vec![track(9)], &mut draw).unwrap();
    assert_eq!(queue.current(), None);
    assert!(queue.undo());
    assert_eq!(snapshot(&queue), before);
    queue.toggle_shuffle(&mut draw);
    assert_eq!(ids(&queue), vec![1, 3, 4, 5, 6]);
    assert_eq!(queue.current(), Some(current));
    assert!(queue.undo());
    assert_eq!(snapshot(&queue), before);
}

#[test]
fn moving_a_block_preserves_source_order_and_current_key() {
    let mut queue = queue(&[1, 2, 3, 4, 5, 6]);
    let current = queue.at(3).unwrap().key;
    let selected = [queue.at(4).unwrap().key, queue.at(1).unwrap().key, current];
    queue.jump(current, &available).unwrap();
    assert!(queue.move_entries(&selected, 0));
    assert_eq!(ids(&queue), vec![2, 4, 5, 1, 3, 6]);
    assert_eq!(queue.current_position(), Some(1));
    let before = snapshot(&queue);
    assert!(!queue.move_entries(&selected, 0));
    assert_eq!(snapshot(&queue), before);
    assert!(queue.move_entries(&selected, usize::MAX));
    assert_eq!(ids(&queue), vec![1, 3, 6, 2, 4, 5]);
    assert!(queue.undo());
    assert_eq!(snapshot(&queue), before);
}

#[test]
fn shuffle_only_reorders_future_suffix_then_new_batch_and_preserves_original_append() {
    let mut queue = queue(&[1, 3, 4, 5]);
    let original = keys(&queue);
    queue.jump(original[1], &available).unwrap();
    queue.toggle_shuffle(&mut draw);
    assert_eq!(&keys(&queue)[..2], &original[..2]);
    assert_eq!(ids(&queue), vec![1, 3, 5, 4]);
    queue.append(vec![track(7), track(8)], &mut draw).unwrap();
    assert_eq!(ids(&queue), vec![1, 3, 5, 4, 8, 7]);
    queue.toggle_shuffle(&mut draw);
    assert_eq!(ids(&queue), vec![1, 3, 4, 5, 7, 8]);
    assert_eq!(queue.current(), Some(original[1]));
}

#[test]
fn keys_never_recycle_after_replace_undo_or_history_eviction() {
    let mut queue = queue(&[1]);
    let retired = queue.at(0).unwrap().key;
    queue.replace(vec![track(3)], &mut draw).unwrap();
    let newer = queue.at(0).unwrap().key;
    assert_eq!(queue.jump(retired, &available), Err(QueueError::StaleEntry));
    assert!(queue.undo());
    assert_eq!(queue.at(0).unwrap().key, retired);
    queue.append(vec![track(4)], &mut draw).unwrap();
    assert!(queue.at(1).unwrap().key > newer);
    for id in 0..UNDO_LIMIT + 3 {
        queue.insert(0, vec![track(id as i64)]).unwrap();
    }
    assert_eq!(queue.history_len(), UNDO_LIMIT);
    for _ in 0..UNDO_LIMIT {
        assert!(queue.undo());
    }
    assert!(!queue.undo());
}

#[test]
fn large_history_threshold_is_strict_and_evicts_through_previous_large_only() {
    let mut queue = queue(&[1]);
    queue
        .insert(0, (0..LARGE_CHANGE).map(|id| track(id as i64)).collect())
        .unwrap();
    queue
        .insert(0, (0..=LARGE_CHANGE).map(|id| track(id as i64)).collect())
        .unwrap();
    assert_eq!(queue.history_len(), 3);
    queue.insert(0, vec![track(9)]).unwrap();
    let before = snapshot(&queue);
    queue
        .insert(0, (0..=LARGE_CHANGE).map(|id| track(id as i64)).collect())
        .unwrap();
    assert_eq!(queue.history_len(), 2);
    assert!(queue.undo());
    assert_eq!(snapshot(&queue), before);
    assert!(queue.undo());
    assert!(!queue.undo());
}

#[test]
fn empty_and_invalid_operations_do_not_mint_history() {
    let mut queue = Queue::default();
    assert_eq!(queue.append(vec![], &mut draw).unwrap(), None);
    assert!(!queue.remove(&[]));
    assert!(!queue.move_entries(&[], 0));
    assert_eq!(queue.history_len(), 0);
    assert!(!queue.same_album());
    queue.append(vec![track(1), track(3)], &mut draw).unwrap();
    assert!(queue.same_album());
    let unavailable = queue.insert(0, vec![track(2)]).unwrap().unwrap();
    let before = queue.current();
    assert_eq!(
        queue.jump(unavailable, &available).unwrap(),
        Navigation::End
    );
    assert_eq!(queue.current(), before);
}

#[test]
fn navigation_matches_the_executed_pinned_manager_and_explicit_legacy_bugs_are_corrected() {
    fn navigation(queue: &Queue, result: Navigation) -> String {
        match result {
            Navigation::Changed(key) => format!(
                "changed:{}",
                queue.entry(key).unwrap().track.track_id.unwrap()
            ),
            Navigation::Repeat(key) => format!(
                "repeat:{}",
                queue.entry(key).unwrap().track.track_id.unwrap()
            ),
            Navigation::End => "end".into(),
        }
    }
    let fixture = include_str!("../upstream/queue-navigation.txt");
    let mut queue = queue(&[1, 2, 3]);
    let mut trace = Vec::new();
    let result = queue.next(false, &available, &mut draw);
    trace.push(format!("next={}", navigation(&queue, result)));
    queue.set_repeat(Repeat::One);
    let result = queue.next(false, &available, &mut draw);
    trace.push(format!("repeat_one={}", navigation(&queue, result)));
    let result = queue.next(true, &available, &mut draw);
    trace.push(format!("manual_next={}", navigation(&queue, result)));
    let result = queue.next(true, &available, &mut draw);
    trace.push(format!("manual_end={}", navigation(&queue, result)));
    queue.set_repeat(Repeat::All);
    let result = queue.next(false, &available, &mut draw);
    trace.push(format!("wrap_next={}", navigation(&queue, result)));
    let result = queue.previous(&available, &mut draw);
    trace.push(format!("wrap_previous={}", navigation(&queue, result)));
    let missing = queue.at(1).unwrap().key;
    trace.push(format!(
        "missing_jump={}",
        queue.jump(missing, &available).unwrap() == Navigation::End
    ));
    assert_eq!(trace, fixture.lines().take(7).collect::<Vec<_>>());
    assert_eq!(
        fixture.lines().skip(7).collect::<Vec<_>>(),
        [
            "legacy_remove_without_current=true",
            "legacy_unshuffle_current=Some(0)",
            "legacy_duplicate_current=Some(0)",
        ]
    );
    // The three old outcomes are genuine compatibility negatives, not the
    // replacement's desired behavior; focused tests above prove their fixes.
}
