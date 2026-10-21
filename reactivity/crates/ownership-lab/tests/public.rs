#![cfg(not(feature = "loom"))]
use gpui_reactivity_ownership_lab::*;
use std::{
    num::NonZeroUsize,
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    },
};
fn capacity(n: usize) -> NonZeroUsize {
    NonZeroUsize::new(n).unwrap()
}
#[test]
fn serial_and_scoped_pages_match_exactly_including_extreme_coordinates_and_damage() {
    let template = [
        LocalRect {
            x: -2,
            y: 3,
            width: 60,
            height: 70,
        },
        LocalRect {
            x: i32::MAX,
            y: i32::MIN,
            width: u32::MAX,
            height: u32::MAX,
        },
    ];
    let placements = [
        Placement { x: 1, y: 4 },
        Placement { x: 64, y: 0 },
        Placement {
            x: i32::MAX,
            y: i32::MIN,
        },
        Placement { x: 400, y: 400 },
        Placement { x: -500, y: -500 },
    ];
    let mut serial: Vec<_> = (0..placements.len())
        .map(|_| OutputPage::new(template.len()))
        .collect();
    let mut parallel: Vec<_> = (0..placements.len())
        .map(|_| OutputPage::new(template.len()))
        .collect();
    let a = BorrowedPhase::new(&template, &placements, &mut serial)
        .unwrap()
        .run(Execution::Serial);
    let b = BorrowedPhase::new(&template, &placements, &mut parallel)
        .unwrap()
        .run(Execution::Scoped {
            workers: capacity(4),
        });
    assert_eq!(a.primitives, b.primitives);
    assert_eq!(a.damage, b.damage);
    assert_eq!(b.jobs, 3);
    for (a, b) in serial.iter().zip(&parallel) {
        assert_eq!(a.geometry(), b.geometry());
        assert_eq!(a.damage(), b.damage());
    }
    let mut invalid = [OutputPage::new(1)];
    assert!(matches!(
        BorrowedPhase::new(&template, &placements[..1], &mut invalid),
        Err(PhaseError::Shape)
    ));
    assert_eq!(invalid[0].geometry(), &[PlacedRect::default()]);
    let empty = BorrowedPhase::new(&template, &[], &mut [])
        .unwrap()
        .run(Execution::Scoped {
            workers: capacity(8),
        });
    assert_eq!(empty.jobs, 0);
}
#[test]
fn full_and_partial_drains_preserve_owned_payload_fifo_and_rearm() {
    let (mut producer, mut consumer) = page_lane(capacity(2));
    let a = OwnedPage::new(1, vec![7u64; 64].into_boxed_slice());
    let a_addr = a.data().as_ptr();
    let b = OwnedPage::new(2, vec![8u64; 64].into_boxed_slice());
    let b_addr = b.data().as_ptr();
    assert!(producer.publish(a).unwrap().wake);
    assert!(!producer.publish(b).unwrap().wake);
    let c = OwnedPage::new(3, vec![9u64; 64].into_boxed_slice());
    let c_addr = c.data().as_ptr();
    let SendError::Full(c) = producer.publish(c).unwrap_err() else {
        panic!("unexpected closure")
    };
    assert_eq!(c.data().as_ptr(), c_addr);
    assert_eq!(c.sequence(), 3);
    let mut slots = [None];
    let first = consumer.drain(&mut slots).unwrap();
    assert_eq!(first.received, 1);
    assert!(first.wake, "budget leaves work; explicit rearm required");
    let first = slots[0].take().unwrap();
    assert_eq!(first.sequence(), 1);
    assert_eq!(first.data().as_ptr(), a_addr);
    assert_eq!(first.data(), &[7; 64]);
    let _ = consumer.recycle(first.complete()).unwrap();
    let _ = producer.publish(c).unwrap();
    let _ = consumer.drain(&mut slots).unwrap();
    let second = slots[0].take().unwrap();
    assert_eq!(second.sequence(), 2);
    assert_eq!(second.data().as_ptr(), b_addr);
    let _ = consumer.recycle(second.complete()).unwrap();
    let _ = consumer.drain(&mut slots).unwrap();
    let third = slots[0].take().unwrap();
    assert_eq!(third.sequence(), 3);
    assert_eq!(third.data().as_ptr(), c_addr);
    // Return ring full: completion retains the exact owned Box, not a duplicate.
    let SendError::Full(third) = consumer.recycle(third.complete()).unwrap_err() else {
        panic!("unexpected closure")
    };
    let mut returned = [None];
    let report = producer.reclaim(&mut returned).unwrap();
    assert!(report.wake);
    let mut a = returned[0].take().unwrap();
    assert_eq!(a.data().as_ptr(), a_addr);
    a.data_mut()[0] = 99;
    let _ = consumer.recycle(third).unwrap();
    let _ = producer.reclaim(&mut returned).unwrap();
    assert_eq!(returned[0].take().unwrap().sequence(), 2);
    let _ = producer.reclaim(&mut returned).unwrap();
    assert_eq!(returned[0].take().unwrap().data().as_ptr(), c_addr);
}
#[test]
fn real_cross_thread_roundtrip_reuses_one_box_for_all_frames() {
    let (mut producer, mut consumer) = page_lane(capacity(1));
    let page = OwnedPage::new(0, vec![0u64; 128].into_boxed_slice());
    let address = page.data().as_ptr() as usize;
    let page = std::thread::scope(|scope| {
        scope.spawn(move || {
            let mut slots = [None];
            for sequence in 0..2000 {
                loop {
                    let _ = consumer.drain(&mut slots).unwrap();
                    if let Some(lease) = slots[0].take() {
                        assert_eq!(lease.sequence(), sequence);
                        assert_eq!(lease.data()[0], sequence);
                        assert_eq!(lease.data().as_ptr() as usize, address);
                        let _ = consumer.recycle(lease.complete()).unwrap();
                        break;
                    }
                    std::thread::yield_now();
                }
            }
        });
        let mut page = page;
        let mut returned = [None];
        for sequence in 0..2000 {
            page.set_sequence(sequence);
            page.data_mut()[0] = sequence;
            let _ = producer.publish(page).unwrap();
            page = loop {
                let _ = producer.reclaim(&mut returned).unwrap();
                if let Some(page) = returned[0].take() {
                    break page;
                }
                std::thread::yield_now();
            };
        }
        page
    });
    assert_eq!(page.data().as_ptr() as usize, address);
    assert_eq!(page.sequence(), 1999);
}
#[derive(Debug)]
struct NoClone(Arc<AtomicUsize>);
impl Drop for NoClone {
    fn drop(&mut self) {
        self.0.fetch_add(1, Ordering::Relaxed);
    }
}
#[test]
fn endpoint_shutdown_or_live_read_lease_drops_each_payload_exactly_once() {
    let drops = Arc::new(AtomicUsize::new(0));
    let (mut p, mut c) = page_lane(capacity(1));
    let page = OwnedPage::new(0, vec![NoClone(drops.clone())].into_boxed_slice());
    let _ = p.publish(page).unwrap();
    let mut slots = [None];
    let _ = c.drain(&mut slots).unwrap();
    let lease = slots[0].take().unwrap();
    drop(p);
    drop(c);
    assert_eq!(
        drops.load(Ordering::Relaxed),
        0,
        "lease itself owns the Box beyond endpoints"
    );
    assert_eq!(lease.data().len(), 1);
    drop(lease);
    assert_eq!(drops.load(Ordering::Relaxed), 1);
    let (mut p, c) = page_lane(capacity(1));
    let _ = p
        .publish(OwnedPage::new(
            0,
            vec![NoClone(drops.clone())].into_boxed_slice(),
        ))
        .unwrap();
    drop(c);
    drop(p);
    assert_eq!(drops.load(Ordering::Relaxed), 2);
}
#[test]
fn invalid_drain_budget_never_overwrites_an_outstanding_read_lease() {
    let (mut p, mut c) = page_lane(capacity(1));
    let _ = p
        .publish(OwnedPage::new(0, vec![1u8].into_boxed_slice()))
        .unwrap();
    assert_eq!(c.drain(&mut []), Err(DrainError::EmptyBudget));
    let mut slots = [None];
    let _ = c.drain(&mut slots).unwrap();
    assert_eq!(c.drain(&mut slots), Err(DrainError::OccupiedSlot));
    assert_eq!(slots[0].as_ref().unwrap().data(), &[1]);
}

#[test]
fn observed_receiver_shutdown_returns_the_owned_page_instead_of_admitting_it() {
    let (mut producer, consumer) = page_lane(capacity(1));
    drop(consumer);
    let page = OwnedPage::new(7, vec![42u64; 16].into_boxed_slice());
    let address = page.data().as_ptr();
    let SendError::Closed(mut page) = producer.publish(page).unwrap_err() else {
        panic!("expected closed receiver")
    };
    assert_eq!(page.data().as_ptr(), address);
    page.data_mut()[0] = 99;
    assert_eq!(page.sequence(), 7);
    assert_eq!(page.data()[0], 99);
}
