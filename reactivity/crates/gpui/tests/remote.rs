use gpui::{
    DeliveryError, El, Error, FieldId, Remote, SendError, Signal, Source, Sources, View, Win,
    button, column, div, text, text_input,
};
use std::sync::mpsc;

#[derive(Default)]
struct Catalogue {
    title: Signal<String>,
    rows: Vec<u32>,
    unregistered: Signal<String>,
    bad_schema: bool,
}
enum ResultMessage {
    Row(u32),
    Title(String),
    Schema(bool),
    Panic,
}
impl Catalogue {
    const TITLE: Source<Self, String> =
        Source::new(FieldId::new(1), "title", |m| &m.title, |m| &mut m.title);
    fn receive(&mut self, message: ResultMessage) {
        match message {
            ResultMessage::Row(row) => self.rows.push(row),
            ResultMessage::Title(title) => *self.title = title,
            ResultMessage::Schema(bad) => self.bad_schema = bad,
            ResultMessage::Panic => panic!("worker result handler fault"),
        }
    }
}
impl View for Catalogue {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::TITLE)
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(if self.bad_schema {
                &self.unregistered
            } else {
                &self.title
            })
            .w(140)
            .h(24),
            text(format!("{} rows", self.rows.len())),
            button("clear").on_click(|m: &mut Self| m.rows.clear()),
        ))
    }
}
#[test]
fn real_worker_completion_is_inert_until_the_same_owner_barrier_accepts_a_frozen_batch() {
    let (remote, inbox) = Remote::bounded(8);
    let mut win = Win::demo(Catalogue::default())
        .with_inbox(inbox, Catalogue::receive)
        .unwrap();
    let worker = std::thread::spawn(move || {
        remote.try_send(ResultMessage::Row(7)).unwrap();
        remote.try_send(ResultMessage::Row(9)).unwrap();
        remote
            .try_send(ResultMessage::Title("loaded".into()))
            .unwrap();
    });
    worker.join().unwrap();
    assert!(win.root().unwrap().rows.is_empty());
    let input = win.input();
    win.focus(input).unwrap();
    win.reset_counters().unwrap();
    let delivered = win.deliver_ready(8).unwrap();
    assert_eq!((delivered.received, delivered.applied), (3, 3));
    assert_eq!(delivered.commit.source_epoch, 1);
    assert_eq!(win.root().unwrap().rows, [7, 9]);
    assert!(win.contains_text("loaded").unwrap());
    assert_eq!(win.counters().source_operations, 1);
    assert_eq!(win.counters().owner_reruns, 1);
    assert_eq!(win.counters().paint_passes, 1);
    assert_eq!(win.focused().unwrap(), Some(input));
    win.key(gpui::Key::Text("!")).unwrap();
    assert_eq!(win.root().unwrap().title.as_str(), "loaded!");
    win.activate(win.button("clear")).unwrap();
    assert!(win.root().unwrap().rows.is_empty());
}

#[test]
fn full_and_closed_return_the_same_non_clone_non_debug_payload() {
    struct Payload(Box<[u8; 32]>);
    let (remote, inbox) = Remote::bounded(1);
    remote.try_send(Payload(Box::new([1; 32]))).unwrap();
    let value = Payload(Box::new([2; 32]));
    let address = value.0.as_ptr();
    let value = match remote.try_send(value) {
        Err(SendError::Full(value)) => value,
        _ => panic!("full"),
    };
    assert_eq!(value.0.as_ptr(), address);
    drop(inbox);
    let value = match remote.try_send(value) {
        Err(SendError::Closed(value)) => value,
        _ => panic!("closed"),
    };
    assert_eq!(value.0.as_ptr(), address);
    let (zero, inbox) = Remote::bounded(0);
    assert!(matches!(zero.try_send(value), Err(SendError::Full(_))));
    drop(inbox);
}

#[test]
fn pre_mount_messages_are_bounded_and_zero_budget_is_idle() {
    let (remote, inbox) = Remote::bounded(3);
    remote.try_send(ResultMessage::Row(1)).unwrap();
    remote.try_send(ResultMessage::Row(2)).unwrap();
    let mut win = Win::demo(Catalogue::default())
        .with_inbox(inbox, Catalogue::receive)
        .unwrap();
    win.reset_counters().unwrap();
    assert_eq!(win.deliver_ready(0).unwrap().received, 0);
    assert!(win.root().unwrap().rows.is_empty());
    assert_eq!(win.counters(), gpui::Counters::default());
    assert_eq!(win.deliver_ready(1).unwrap().applied, 1);
    assert_eq!(win.root().unwrap().rows, [1]);
    assert_eq!(win.deliver_ready(1).unwrap().applied, 1);
    assert_eq!(win.root().unwrap().rows, [1, 2]);
    win.reset_counters().unwrap();
    assert_eq!(win.deliver_ready(5).unwrap().applied, 0);
    assert_eq!(win.counters(), gpui::Counters::default());
}

#[test]
fn messages_enqueued_by_a_callback_wait_for_the_following_turn() {
    let (remote, inbox) = Remote::bounded(4);
    let next = remote.clone();
    let mut win = Win::demo(Catalogue::default())
        .with_inbox(inbox, move |model: &mut Catalogue, row: u32| {
            model.rows.push(row);
            if row == 1 {
                next.try_send(2).unwrap();
            }
        })
        .unwrap();
    remote.try_send(1).unwrap();
    assert_eq!(win.deliver_ready(4).unwrap().applied, 1);
    assert_eq!(win.root().unwrap().rows, [1]);
    assert_eq!(win.deliver_ready(4).unwrap().applied, 1);
    assert_eq!(win.root().unwrap().rows, [1, 2]);
}

#[test]
fn small_budgets_rotate_across_static_lanes_without_losing_per_lane_fifo() {
    let (left, lin) = Remote::bounded(4);
    let (right, rin) = Remote::bounded(4);
    let mut win = Win::demo(Catalogue::default())
        .with_inbox(lin, |m: &mut Catalogue, v: u32| m.rows.push(v))
        .unwrap()
        .with_inbox(rin, |m: &mut Catalogue, v: u64| m.rows.push(v as u32))
        .unwrap();
    for row in 0..4 {
        left.try_send(row).unwrap();
        right.try_send(100 + u64::from(row)).unwrap();
    }
    for _ in 0..8 {
        assert_eq!(win.deliver_ready(1).unwrap().applied, 1);
    }
    assert_eq!(win.root().unwrap().rows, [100, 0, 101, 1, 102, 2, 103, 3]);
}

#[test]
fn status_lanes_deliver_buffered_fifo_then_one_terminal_and_rotate_saturated_turns() {
    let (left, lin) = Remote::bounded(130);
    let (right, rin) = Remote::bounded(130);
    for row in 0..130 {
        left.try_send(row).unwrap();
        right.try_send(1000 + row).unwrap();
    }
    drop(left);
    drop(right);
    let mut win = Win::demo(Catalogue::default())
        .with_inbox_status(lin, |m: &mut Catalogue, v: Option<u32>| {
            m.rows.push(v.unwrap_or(999))
        })
        .unwrap()
        .with_inbox_status(rin, |m: &mut Catalogue, v: Option<u32>| {
            m.rows.push(v.unwrap_or(1999))
        })
        .unwrap();
    assert_eq!(win.deliver_ready(0).unwrap().received, 0);
    // A budget of one proves the round-robin cursor independently of the
    // callback application order in larger frozen batches.
    for row in 0..130 {
        let delivery = win.deliver_ready(1).unwrap();
        assert!(delivery.more);
        assert_eq!((delivery.received, delivery.applied), (1, 1));
        assert_eq!(win.root().unwrap().rows.last(), Some(&(1000 + row)));
        assert!(win.deliver_ready(1).unwrap().more);
        assert_eq!(win.root().unwrap().rows.last(), Some(&row));
    }
    let terminal = win.deliver_ready(64).unwrap();
    assert_eq!(
        (terminal.received, terminal.applied, terminal.more),
        (2, 2, false)
    );
    assert_eq!(&win.root().unwrap().rows[260..], [1999, 999]);
    assert_eq!(win.deliver_ready(64).unwrap().applied, 0);
}

#[test]
fn status_close_waits_for_every_clone_and_owner_close_revokes_it() {
    let (remote, inbox) = Remote::bounded(4);
    let retained = remote.clone();
    remote.try_send(7).unwrap();
    drop(remote);
    let mut win = Win::demo(Catalogue::default())
        .with_inbox_status(inbox, |m: &mut Catalogue, value: Option<u32>| {
            m.rows.push(value.unwrap_or(99));
        })
        .unwrap();
    assert_eq!(win.deliver_ready(8).unwrap().applied, 1);
    assert_eq!(win.root().unwrap().rows, [7]);
    assert_eq!(win.deliver_ready(8).unwrap().applied, 0);
    drop(retained);
    assert_eq!(win.deliver_ready(8).unwrap().applied, 1);
    assert_eq!(win.root().unwrap().rows, [7, 99]);
    assert_eq!(win.deliver_ready(8).unwrap().applied, 0);

    let (remote, inbox) = Remote::<u32>::bounded(0);
    let rejected = Win::demo(Catalogue::default())
        .with_inbox_status(inbox, |_: &mut Catalogue, _: Option<u32>| {});
    assert!(matches!(rejected, Err(Error::ZeroInboxCapacity)));
    assert!(matches!(remote.try_send(1), Err(SendError::Closed(1))));
    let (remote, inbox) = Remote::<u32>::bounded(1);
    let mut win = Win::demo(Catalogue::default())
        .with_inbox_status(inbox, |_: &mut Catalogue, _: Option<u32>| {
            panic!("closed owner must not apply")
        })
        .unwrap();
    remote.try_send(1).unwrap();
    win.close();
    drop(remote);
    assert!(matches!(
        win.deliver_ready(8),
        Err(DeliveryError {
            error: Error::Closed,
            ..
        })
    ));
}

fn failed_batch(error: DeliveryError) -> gpui::Delivery {
    error.delivery.unwrap()
}
#[test]
fn presentation_and_description_failures_keep_later_queued_repairs_and_never_replay_applied_values()
{
    let (remote, inbox) = Remote::bounded(4);
    let mut win = Win::demo(Catalogue::default())
        .with_inbox(inbox, Catalogue::receive)
        .unwrap();
    let input = win.input();
    win.focus(input).unwrap();
    remote.try_send(ResultMessage::Title("漢".into())).unwrap();
    remote
        .try_send(ResultMessage::Title("recovered".into()))
        .unwrap();
    let error = win.deliver_ready(1).unwrap_err();
    assert!(matches!(error.error, Error::Canvas(_)));
    let delivery = failed_batch(error);
    assert_eq!((delivery.received, delivery.applied), (1, 1));
    assert_eq!(
        (
            delivery.commit.source_epoch,
            delivery.commit.presentation_epoch
        ),
        (1, 0)
    );
    assert_eq!(win.focused().unwrap(), Some(input));
    win.deliver_ready(1).unwrap();
    assert_eq!(win.root().unwrap().title.as_str(), "recovered");
    remote.try_send(ResultMessage::Schema(true)).unwrap();
    remote.try_send(ResultMessage::Schema(false)).unwrap();
    let error = win.deliver_ready(1).unwrap_err();
    assert!(matches!(error.error, Error::UnregisteredInput { .. }));
    assert_eq!(error.delivery.unwrap().applied, 1);
    assert_eq!(win.focused().unwrap(), None);
    win.deliver_ready(1).unwrap();
    assert_eq!(win.deliver_ready(4).unwrap().received, 0);
    assert_eq!(win.snapshot().unwrap().source_epoch, 4);
    assert_ne!(win.input(), input);
}

#[test]
fn quarantine_revokes_existing_remotes_and_cancels_the_remaining_queue() {
    let (remote, inbox) = Remote::bounded(4);
    let mut win = Win::demo(Catalogue::default())
        .with_inbox(inbox, Catalogue::receive)
        .unwrap();
    remote.try_send(ResultMessage::Row(1)).unwrap();
    remote.try_send(ResultMessage::Panic).unwrap();
    remote.try_send(ResultMessage::Row(2)).unwrap();
    let error = win.deliver_ready(4).unwrap_err();
    assert_eq!(error.error, Error::OwnerPanicked);
    let report = error.delivery.unwrap();
    assert_eq!((report.received, report.applied), (3, 1));
    assert_eq!(report.commit.source_epoch, 0);
    assert!(win.snapshot().unwrap().poisoned);
    assert!(matches!(
        remote.try_send(ResultMessage::Row(3)),
        Err(SendError::Closed(_))
    ));
    assert_eq!(win.deliver_ready(1).unwrap_err().error, Error::Poisoned);
}

struct DropOwner {
    remote: gpui::Remote<u32>,
    observed: mpsc::Sender<bool>,
}
impl View for DropOwner {
    fn view(&self) -> El<'_> {
        div()
    }
}
impl Drop for DropOwner {
    fn drop(&mut self) {
        self.observed
            .send(matches!(self.remote.try_send(7), Err(SendError::Closed(7))))
            .unwrap();
    }
}
#[test]
fn close_and_drop_close_receivers_before_a_model_held_sender_can_run_its_destructor() {
    for explicit in [false, true] {
        let (remote, inbox) = Remote::bounded(4);
        let (observe, result) = mpsc::channel();
        let model = DropOwner {
            remote: remote.clone(),
            observed: observe,
        };
        let mut win = Win::demo(model)
            .with_inbox(inbox, |_: &mut DropOwner, _: u32| {})
            .unwrap();
        if explicit {
            win.close();
        } else {
            drop(win);
        }
        assert!(result.recv().unwrap());
        assert!(matches!(remote.try_send(11), Err(SendError::Closed(11))));
    }
}

#[test]
fn owner_fault_outside_delivery_also_closes_worker_admission_immediately() {
    let (remote, inbox) = Remote::bounded(4);
    let mut win = Win::demo(Catalogue::default())
        .with_inbox(inbox, Catalogue::receive)
        .unwrap();
    assert_eq!(
        win.update(|_| panic!("owner fault")),
        Err(Error::OwnerPanicked)
    );
    assert!(matches!(
        remote.try_send(ResultMessage::Row(1)),
        Err(SendError::Closed(_))
    ));
}

#[test]
fn preallocated_transport_and_idle_turns_do_not_allocate() {
    struct Accumulator {
        total: u64,
    }
    impl View for Accumulator {
        fn view(&self) -> El<'_> {
            div()
        }
    }
    let (remote, inbox) = Remote::bounded(16);
    let mut win = Win::demo(Accumulator { total: 0 })
        .with_inbox(inbox, |m: &mut Accumulator, n: u64| m.total += n)
        .unwrap();
    let transport = allocation_counter::measure(|| {
        for _ in 0..16 {
            remote.try_send(1).unwrap();
        }
    });
    assert_eq!(transport.count_total, 0);
    win.deliver_ready(16).unwrap();
    assert_eq!(win.root().unwrap().total, 16);
    let idle = allocation_counter::measure(|| {
        for _ in 0..1000 {
            assert_eq!(win.deliver_ready(16).unwrap().received, 0);
        }
    });
    assert_eq!(idle.count_total, 0);
}

#[test]
fn queued_staged_and_applied_payloads_are_dropped_exactly_once_after_quarantine() {
    struct Payload {
        id: u32,
        dropped: mpsc::Sender<u32>,
    }
    impl Drop for Payload {
        fn drop(&mut self) {
            self.dropped.send(self.id).unwrap();
        }
    }
    struct Owner {
        applied: Vec<Payload>,
    }
    impl View for Owner {
        fn view(&self) -> El<'_> {
            div()
        }
    }
    let (dropped, observe) = mpsc::channel();
    let (remote, inbox) = Remote::bounded(4);
    let mut win = Win::demo(Owner {
        applied: Vec::new(),
    })
    .with_inbox(inbox, |m: &mut Owner, payload: Payload| {
        if payload.id == 2 {
            panic!("callback fault");
        }
        m.applied.push(payload);
    })
    .unwrap();
    for id in 1..=4 {
        remote
            .try_send(Payload {
                id,
                dropped: dropped.clone(),
            })
            .unwrap();
    }
    let error = win.deliver_ready(3).unwrap_err();
    assert_eq!(error.error, Error::OwnerPanicked);
    assert_eq!(error.delivery.unwrap().applied, 1);
    win.close();
    drop(dropped);
    let mut observed = observe.into_iter().collect::<Vec<_>>();
    observed.sort_unstable();
    assert_eq!(observed, [1, 2, 3, 4]);
}

#[cfg(feature = "native")]
#[test]
fn an_unopened_native_builder_closes_its_inboxes_before_dropping_the_model() {
    let (remote, inbox) = Remote::bounded(4);
    let (observe, result) = mpsc::channel();
    let model = DropOwner {
        remote: remote.clone(),
        observed: observe,
    };
    let window = gpui::Window::document(model).with_inbox(inbox, |_: &mut DropOwner, _: u32| {});
    drop(window);
    assert!(result.recv().unwrap());
}

#[test]
fn outside_owner_fault_releases_queued_payloads_before_returning_to_the_caller() {
    struct Payload(mpsc::Sender<()>);
    impl Drop for Payload {
        fn drop(&mut self) {
            self.0.send(()).unwrap();
        }
    }
    let (released, observe) = mpsc::channel();
    let (remote, inbox) = Remote::bounded(4);
    let mut win = Win::demo(Catalogue::default())
        .with_inbox(inbox, |_: &mut Catalogue, _: Payload| {})
        .unwrap();
    remote.try_send(Payload(released.clone())).unwrap();
    assert_eq!(
        win.update(|_| panic!("owner fault")),
        Err(Error::OwnerPanicked)
    );
    assert_eq!(observe.try_recv(), Ok(()));
    assert!(matches!(
        remote.try_send(Payload(released)),
        Err(SendError::Closed(_))
    ));
}
