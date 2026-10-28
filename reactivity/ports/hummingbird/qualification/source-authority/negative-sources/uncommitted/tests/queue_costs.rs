//! Requested Rust allocation controls and actual public list realization. These
//! are not timings, allocator/RSS measurements or a legacy application baseline.
use hummingbird_gpui_port::{
    queue::{Queue, Track, TrackRef},
    queue_view::QueueScreen,
};
fn track(id: usize) -> TrackRef {
    TrackRef::new(Track {
        path: format!("/prepared/{id}.flac").into(),
        track_id: Some(id as i64),
        album_id: Some(1),
        title: format!("Prepared {id}"),
        available_when_prepared: true,
    })
}
fn draw(_: usize) -> usize {
    0
}
fn report(label: &str, count: usize, shared: bool, info: allocation_counter::AllocationInfo) {
    println!("QUEUE_ALLOC {label} count={count} shared={shared} {info:?}");
}
#[test]
fn large_queue_inverse_edits_and_history_retirement_have_explicit_allocation_costs() {
    for count in [4096, 4097, 100_000] {
        for shared in [true, false] {
            let shared_track = track(0);
            let mut queue = Queue::default();
            let mount = allocation_counter::measure(|| {
                let tracks = (0..count)
                    .map(|id| {
                        if shared {
                            shared_track.clone()
                        } else {
                            track(id)
                        }
                    })
                    .collect();
                queue.append(tracks, &mut draw).unwrap();
            });
            report("construct", count, shared, mount);
            assert_eq!(queue.len(), count);
            let original = (0..count)
                .map(|index| queue.at(index).unwrap().key)
                .collect::<Vec<_>>();
            let mut selected = original.iter().step_by(2).copied().collect::<Vec<_>>();
            selected.reverse();
            selected.extend_from_slice(&original[..2]);
            let moved = allocation_counter::measure(|| {
                assert!(queue.move_entries(&selected, count));
            });
            report("move_arbitrary", count, shared, moved);
            let undo = allocation_counter::measure(|| {
                assert!(queue.undo());
            });
            report("undo_move", count, shared, undo);
            assert_eq!(
                (0..count)
                    .map(|index| queue.at(index).unwrap().key)
                    .collect::<Vec<_>>(),
                original
            );
            let removed = allocation_counter::measure(|| {
                assert!(queue.remove(&selected));
            });
            report("remove_arbitrary", count, shared, removed);
            let undo = allocation_counter::measure(|| {
                assert!(queue.undo());
            });
            report("undo_remove", count, shared, undo);
            assert_eq!(
                (0..count)
                    .map(|index| queue.at(index).unwrap().key)
                    .collect::<Vec<_>>(),
                original
            );
            let destruction = allocation_counter::measure(|| drop(queue));
            report(
                "drop_current_and_remaining_history_on_ui_thread",
                count,
                shared,
                destruction,
            );
            // A replacement retains its entire old sheet for undo. After29
            // small replacements it is the oldest remaining record, including
            // the strict4096 case whose older Inserted record was just evicted.
            let mut queue = Queue::default();
            queue
                .append(
                    (0..count)
                        .map(|id| {
                            if shared {
                                shared_track.clone()
                            } else {
                                track(id)
                            }
                        })
                        .collect(),
                    &mut draw,
                )
                .unwrap();
            queue.replace(vec![track(count)], &mut draw).unwrap();
            for id in 0..29 {
                queue
                    .replace(vec![track(count + id + 1)], &mut draw)
                    .unwrap();
            }
            assert_eq!(queue.history_len(), 30);
            let retirement = allocation_counter::measure(|| {
                queue.replace(vec![track(count + 31)], &mut draw).unwrap();
            });
            report(
                "retire_large_history_on_ui_thread",
                count,
                shared,
                retirement,
            );
            assert_eq!(queue.len(), 1);
        }
    }
}
#[test]
fn one_hundred_thousand_prepared_entries_keep_public_view_realization_bounded() {
    let shared = track(1);
    let mut screen = QueueScreen::new(gpui::ListId::new(900_000)).unwrap();
    screen.enqueue_many((0..100_000).map(|_| shared.clone()).collect());
    let metadata_owners = TrackRef::strong_count(&shared);
    let list_id = screen.list_id();
    let mut owner = None;
    let mount = allocation_counter::measure(|| {
        owner = Some(gpui::Win::with_size(screen, 720, 420).unwrap());
    });
    report(
        "public_view_incremental_mount_given_prepared_model",
        100_000,
        true,
        mount,
    );
    let mut owner = owner.unwrap();
    assert_eq!(TrackRef::strong_count(&shared), metadata_owners);
    let list = owner.list(list_id).unwrap();
    assert_eq!(owner.list_state(list).unwrap().realized_rows, 4);
    let last = owner
        .with_model(|screen| screen.playback().queue().at(99_999).unwrap().key)
        .unwrap();
    owner
        .scroll_to_key(list, gpui::ItemKey::new(last.get()))
        .unwrap();
    assert_eq!(owner.list_state(list).unwrap().realized_rows, 4);
    assert!(owner.inspect().unwrap().nodes.len() < 100);
    assert_eq!(TrackRef::strong_count(&shared), metadata_owners);
    println!(
        "QUEUE_VIEW_LAYOUT screen={} window={} realized=4",
        size_of::<QueueScreen>(),
        size_of::<gpui::Win<QueueScreen>>()
    );
    println!(
        "QUEUE_APP_LAYOUT library={} element={}",
        size_of::<hummingbird_gpui_port::app::Library>(),
        size_of::<gpui::El<'_>>()
    );
    #[cfg(feature = "native")]
    println!(
        "QUEUE_NATIVE_LAYOUT document={} option_document={}",
        size_of::<gpui::Window<hummingbird_gpui_port::app::Library>>(),
        size_of::<Option<gpui::Window<hummingbird_gpui_port::app::Library>>>()
    );
}
