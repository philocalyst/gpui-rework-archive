use gpui_reactivity_state::{
    AdmissionError, Full, Handoff, OwnerRegistry, Signal, TwoEpoch, TypedField,
};
use std::{cell::Cell, rc::Rc};

#[test]
fn manual_field_descriptor_provides_typed_reads_overrides_and_impact_metadata() {
    struct Editor {
        title: Signal<String>,
    }
    #[derive(Clone, Copy, Debug, PartialEq)]
    enum Impact {
        Paint,
    }
    const TITLE: TypedField<Editor, Signal<String>, Impact> = TypedField::new(
        "title",
        |model| &model.title,
        |model| &mut model.title,
        Impact::Paint,
    );
    let mut editor = Editor {
        title: Signal::new(String::from("old")),
    };
    // Both Editor and String are non-Copy; descriptors still copy without a
    // spurious generic bound or type erasure.
    let descriptor = TITLE;
    let copied = descriptor;
    assert_eq!(descriptor.name(), "title");
    assert_eq!(copied.impact(), &Impact::Paint);
    let before = copied.get(&editor).revision();
    **copied.get_mut(&mut editor) = String::from("override");
    assert_eq!(&**copied.get(&editor), "override");
    assert_ne!(copied.get(&editor).revision(), before);
}

#[test]
fn ordinary_application_fields_are_inline_and_shared_reads_do_not_mark() {
    struct Counter {
        count: Signal<u32>,
    }
    impl Counter {
        fn increment(&mut self) {
            *self.count += 1;
        }
        fn view(&self) -> u32 {
            *self.count
        }
    }
    let mut counter = Counter {
        count: Signal::new(0),
    };
    let initial = counter.count.revision();
    assert_eq!(counter.view(), 0);
    assert_eq!(counter.count.revision(), initial);
    counter.increment();
    assert_eq!(counter.view(), 1);
    assert!(counter.count.revision() > initial);
    // Move after mutation: no inline address has escaped into a runtime table.
    let moved = [counter];
    assert_eq!(moved[0].view(), 1);
}

#[test]
fn signal_mutation_stamp_has_four_byte_cost_without_a_hidden_wire_slot() {
    assert_eq!(std::mem::size_of::<gpui_reactivity_state::Revision>(), 4);
    assert_eq!(std::mem::size_of::<Signal<u32>>(), 8);
    assert_eq!(std::mem::size_of::<Signal<bool>>(), 8);
}

#[test]
fn spurious_mutable_access_marks_but_destination_comparison_cuts_off_work() {
    let mut signal = Signal::new(String::from("unchanged"));
    let mut observed = signal.revision();
    let mut retained = signal.to_string();
    let mut patches = 0;
    let _exclusive = &mut *signal;
    assert_ne!(signal.revision(), observed);
    // This explicit application-level observer is not an automatic wire.
    if observed != signal.revision() {
        observed = signal.revision();
        if retained != *signal {
            retained.clone_from(&signal);
            patches += 1;
        }
    }
    assert_eq!(patches, 0);
    signal.push('!');
    assert_ne!(observed, signal.revision());
    assert_ne!(retained, *signal);
}

#[test]
fn unwinding_during_a_mutable_edit_still_leaves_a_visible_hint() {
    let mut value = Signal::new(vec![1]);
    let before = value.revision();
    let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        value.push(2);
        panic!("handler failed; arbitrary inline edits are not transactional");
    }));
    assert!(result.is_err());
    assert_ne!(before, value.revision());
    assert_eq!(&*value, &[1, 2]);
}

#[test]
fn handoff_is_fifo_bounded_and_retries_preserve_owned_payloads() {
    let mut handoff = Handoff::bounded(2);
    handoff.give(String::from("first")).unwrap();
    handoff.give(String::from("second")).unwrap();
    let Full(retry) = handoff.give(String::from("third")).unwrap_err();
    assert_eq!(handoff.unconsumed().unwrap().pending, 2);
    assert_eq!(handoff.take().as_deref(), Some("first"));
    handoff.give(retry).unwrap();
    assert_eq!(handoff.drain().collect::<Vec<_>>(), ["second", "third"]);
    assert_eq!(handoff.take(), None);
    assert_eq!(handoff.unconsumed(), None);
    assert_eq!(Handoff::bounded(0).give(42), Err(Full(42)));
}

#[test]
fn payloads_move_once_and_effects_only_run_when_the_application_drains() {
    #[derive(Debug)]
    struct Payload(Rc<Cell<u32>>);
    impl Drop for Payload {
        fn drop(&mut self) {
            self.0.set(self.0.get() + 1);
        }
    }
    let drops = Rc::new(Cell::new(0));
    let mut intents = Handoff::bounded(1);
    let mut effects = 0;
    intents.give(Payload(drops.clone())).unwrap();
    assert_eq!(effects, 0);
    assert_eq!(drops.get(), 0);
    let payload = intents.take().unwrap();
    effects += 1;
    assert!(intents.take().is_none());
    assert_eq!(effects, 1);
    assert_eq!(drops.get(), 0);
    drop(payload);
    assert_eq!(drops.get(), 1);
}

#[test]
fn a_b_a_completions_match_exact_tickets_and_are_accepted_once() {
    let mut registry = OwnerRegistry::new();
    let mut owner = registry.mount().unwrap();
    let mut gate = owner.producer(7).unwrap();
    let first_a = gate.begin().unwrap();
    let b = gate.begin().unwrap();
    let second_a = gate.begin().unwrap();
    assert_eq!(gate.accept(&first_a), Err(AdmissionError::Stale));
    assert_eq!(gate.accept(&b), Err(AdmissionError::Stale));
    assert_eq!(gate.accept(&second_a), Ok(()));
    assert_eq!(gate.accept(&second_a.clone()), Err(AdmissionError::Stale));
    let canceled = gate.begin().unwrap();
    gate.cancel();
    assert_eq!(gate.accept(&canceled), Err(AdmissionError::Stale));
    assert!(gate.begin().is_ok());
}

#[test]
fn worker_completion_carries_owned_stamp_without_a_borrow_into_ui_storage() {
    let mut owner = OwnerRegistry::new().mount().unwrap();
    let mut gate = owner.producer(3).unwrap();
    let stamp = gate.begin().unwrap();
    let completed = std::thread::spawn(move || (stamp, String::from("result")))
        .join()
        .unwrap();
    gate.accept(&completed.0).unwrap();
    let mut values = Handoff::bounded(1);
    values.give(completed.1).unwrap();
    assert_eq!(values.take().as_deref(), Some("result"));
}

#[test]
fn owner_revocation_drop_and_remount_reject_old_work() {
    let mut owner = OwnerRegistry::new().mount().unwrap();
    let mut old_gate = owner.producer(9).unwrap();
    let old_stamp = old_gate.begin().unwrap();
    let previous_incarnation = owner.incarnation();
    owner.remount().unwrap();
    assert!(owner.incarnation() > previous_incarnation);
    assert_eq!(old_gate.accept(&old_stamp), Err(AdmissionError::Revoked));
    let mut new_gate = owner.producer(9).unwrap();
    let new_stamp = new_gate.begin().unwrap();
    assert_eq!(new_stamp.owner(), old_stamp.owner());
    assert_eq!(new_stamp.site(), old_stamp.site());
    assert_eq!(new_stamp.ticket(), old_stamp.ticket());
    assert_eq!(new_gate.accept(&old_stamp), Err(AdmissionError::Stale));
    new_gate.accept(&new_stamp).unwrap();
    let last = new_gate.begin().unwrap();
    drop(owner);
    assert_eq!(new_gate.accept(&last), Err(AdmissionError::Revoked));
    assert!(matches!(new_gate.begin(), Err(AdmissionError::Revoked)));
}

#[test]
fn registry_and_producer_collisions_cannot_alias_delivery() {
    let mut owner_a = OwnerRegistry::new().mount().unwrap();
    let mut owner_b = OwnerRegistry::new().mount().unwrap();
    let mut gate_a = owner_a.producer(1).unwrap();
    let mut gate_b = owner_b.producer(1).unwrap();
    let a = gate_a.begin().unwrap();
    let b = gate_b.begin().unwrap();
    assert_eq!(
        (a.owner(), a.incarnation(), a.site(), a.ticket()),
        (b.owner(), b.incarnation(), b.site(), b.ticket())
    );
    assert_eq!(gate_b.accept(&a), Err(AdmissionError::Stale));
    gate_b.accept(&b).unwrap();
    let mut recreated = owner_a.producer(1).unwrap();
    let current = recreated.begin().unwrap();
    assert_eq!(recreated.accept(&a), Err(AdmissionError::Stale));
    recreated.accept(&current).unwrap();
    gate_a.revoke();
    assert_eq!(gate_a.accept(&a), Err(AdmissionError::Revoked));
    owner_a.revoke();
    assert!(matches!(owner_a.producer(2), Err(AdmissionError::Revoked)));
}

#[test]
fn logical_and_presentation_failures_preserve_their_respective_committed_epochs() {
    #[derive(Debug, PartialEq)]
    struct Frame {
        pixels: u32,
        hit_target: u32,
    }
    let mut epochs = TwoEpoch::new(
        1,
        Frame {
            pixels: 1,
            hit_target: 1,
        },
    );
    let initial = epochs.logical_epoch();
    assert_eq!(
        epochs.commit_logical(|_| Err("compute"), |_| Ok(())),
        Err("compute")
    );
    assert_eq!(
        epochs.commit_logical(|old| Ok(old + 1), |_| Err("validate")),
        Err("validate")
    );
    assert_eq!(*epochs.logical(), 1);
    assert_eq!(epochs.logical_epoch(), initial);
    let logical = epochs
        .commit_logical(|old| Ok::<_, &str>(old + 1), |_| Ok(()))
        .unwrap();
    assert_ne!(logical, initial);
    assert!(!epochs.presentation_is_current());
    assert_eq!(
        epochs.commit_presentation(|_, _| Err("layout"), |_| Ok(())),
        Err("layout")
    );
    assert_eq!(
        epochs.commit_presentation(
            |value, _| Ok(Frame {
                pixels: *value,
                hit_target: 99
            }),
            |frame| if frame.pixels == frame.hit_target {
                Ok(())
            } else {
                Err("torn frame")
            },
        ),
        Err("torn frame")
    );
    assert_eq!(
        epochs.presentation(),
        &Frame {
            pixels: 1,
            hit_target: 1
        }
    );
    assert_eq!(epochs.presentation_epoch(), initial);
    assert_eq!(epochs.logical_epoch(), logical);
    // Recovery presents the newest logical state, skipping intermediate history.
    epochs
        .commit_logical(|old| Ok::<_, &str>(old + 1), |_| Ok(()))
        .unwrap();
    epochs
        .commit_presentation(
            |value, _| {
                Ok::<_, &str>(Frame {
                    pixels: *value,
                    hit_target: *value,
                })
            },
            |_| Ok(()),
        )
        .unwrap();
    assert!(epochs.presentation_is_current());
    assert_eq!(
        epochs.presentation(),
        &Frame {
            pixels: 3,
            hit_target: 3
        }
    );
}

#[test]
fn draft_panics_before_publication_leave_owned_snapshots_unchanged() {
    let mut epochs = TwoEpoch::new(String::from("old"), String::from("old frame"));
    let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        let _: Result<_, ()> =
            epochs.commit_logical(|_| Ok(String::from("draft")), |_| panic!("validator fault"));
    }));
    assert!(result.is_err());
    assert_eq!(epochs.logical(), "old");
    assert!(epochs.presentation_is_current());
    epochs
        .commit_logical(|_| Ok::<_, ()>(String::from("new")), |_| Ok(()))
        .unwrap();
    let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        let _: Result<_, ()> =
            epochs.commit_presentation(|_, _| panic!("layout fault"), |_| Ok(()));
    }));
    assert!(result.is_err());
    assert_eq!(epochs.logical(), "new");
    assert_eq!(epochs.presentation(), "old frame");
    assert!(!epochs.presentation_is_current());
}
