// Copyright 2026 The GPUI contributors.
// Licensed under the Apache License, Version 2.0 or MIT, at your option.
use super::*;
use crate::adapter::Adapter;
use accesskit::{ActionHandler, ActionRequest, Node, NodeId, Role, TreeId, TreeInfo, TreeUpdate};
use accesskit_atspi_common::ActionHandlerWrapper;
use std::{
    sync::{
        atomic::{AtomicUsize, Ordering},
        mpsc,
    },
    time::Duration,
};

struct NoAction;
impl ActionHandler for NoAction {
    fn do_action(&mut self, _: ActionRequest) {}
}
struct NoActivation;
impl ActivationHandler for NoActivation {
    fn request_initial_tree(&mut self) -> Option<TreeUpdate> {
        panic!("fence activated an adapter")
    }
}
struct Deactivated(Arc<AtomicUsize>);
impl DeactivationHandler for Deactivated {
    fn deactivate_accessibility(&mut self) {
        self.0.fetch_add(1, Ordering::SeqCst);
    }
}
fn tree(extra: bool) -> TreeUpdate {
    let mut root = Node::new(Role::Window);
    root.set_children(if extra {
        vec![NodeId(2), NodeId(3)]
    } else {
        vec![NodeId(2)]
    });
    let mut button = Node::new(Role::Button);
    button.add_action(accesskit::Action::Click);
    let mut nodes = vec![(NodeId(1), root), (NodeId(2), button)];
    if extra {
        nodes.push((NodeId(3), Node::new(Role::Button)));
    }
    TreeUpdate {
        nodes,
        tree: Some(TreeInfo::new(NodeId(1))),
        tree_id: TreeId::ROOT,
        focus: NodeId(2),
    }
}
fn state(pending: bool) -> Arc<Mutex<AdapterState>> {
    let action_handler = Arc::new(ActionHandlerWrapper::new(NoAction));
    Arc::new(Mutex::new(if pending {
        AdapterState::Pending {
            is_window_focused: false,
            root_window_bounds: Default::default(),
            action_handler,
        }
    } else {
        AdapterState::Inactive {
            is_window_focused: false,
            root_window_bounds: Default::default(),
            action_handler,
        }
    }))
}
fn entry(id: usize, state: Arc<Mutex<AdapterState>>) -> (AdapterEntry, Arc<AtomicUsize>) {
    let deactivated = Arc::new(AtomicUsize::new(0));
    (
        AdapterEntry {
            id,
            state,
            activation_handler: Box::new(NoActivation),
            deactivation_handler: Box::new(Deactivated(deactivated.clone())),
        },
        deactivated,
    )
}
fn active(id: usize, tx: &Sender<Message>) -> (AdapterEntry, Adapter, Arc<AtomicUsize>) {
    let app = AppContext::new(None);
    let r#impl = AdapterImpl::with_wrapped_action_handler(
        id,
        &app,
        Callback::with_messages(tx.clone()),
        tree(false),
        false,
        Default::default(),
        Arc::new(ActionHandlerWrapper::new(NoAction)),
    );
    let state = Arc::new(Mutex::new(AdapterState::Active(r#impl)));
    let adapter = Adapter::with_state_for_test(id, tx.clone(), state.clone());
    let (entry, count) = entry(id, state);
    (entry, adapter, count)
}
fn add(id: usize, state: Arc<Mutex<AdapterState>>) -> Message {
    Message::AddAdapter {
        id,
        state,
        activation_handler: Box::new(NoActivation),
        deactivation_handler: Box::new(Deactivated(Arc::new(AtomicUsize::new(0)))),
    }
}
fn drain(rx: &Receiver<Message>) -> Vec<Message> {
    std::iter::from_fn(|| rx.try_recv().ok()).collect()
}

#[test]
fn fence_drops_real_registration_cache_backlog_and_preserves_fifo_controls() {
    let (tx, rx) = async_channel::unbounded();
    let (old, mut adapter, count) = active(100, &tx);
    drop(drain(&rx));
    adapter.update_if_active(|| tree(true));
    let backlog = drain(&rx);
    assert!(
        backlog
            .iter()
            .any(|message| matches!(message, Message::RegisterInterfaces { .. }))
    );
    assert!(
        backlog
            .iter()
            .any(|message| matches!(message, Message::EmitCacheAdd { .. }))
    );
    for message in backlog {
        assert!(tx.try_send(message).is_ok());
    }
    let added_high = state(false);
    let added_low = state(false);
    assert!(tx.try_send(add(300, added_high.clone())).is_ok());
    assert!(tx.try_send(add(200, added_low.clone())).is_ok());
    assert!(tx.try_send(Message::RemoveAdapter { id: 300 }).is_ok());
    let old_state = old.state.clone();
    let mut adapters = vec![old];
    block_on(retire_bus(
        &mut None,
        &mut adapters,
        &tx,
        &mut Box::pin(rx.clone()),
    ))
    .unwrap();
    assert!(
        rx.is_empty(),
        "old events must be consumed through the fence"
    );
    assert!(matches!(
        *old_state.lock().unwrap(),
        AdapterState::Inactive { .. }
    ));
    assert!(matches!(
        *added_low.lock().unwrap(),
        AdapterState::Inactive { .. }
    ));
    assert_eq!(
        adapters.iter().map(|entry| entry.id).collect::<Vec<_>>(),
        vec![100, 200]
    );
    assert_eq!(count.load(Ordering::SeqCst), 1);
    let mut called = false;
    adapter.update_if_active(|| {
        called = true;
        tree(true)
    });
    assert!(
        !called,
        "retired adapter cannot create a callback after Fence"
    );
    assert!(rx.is_empty());
}

#[test]
fn remove_retires_state_even_when_callers_final_arc_is_delayed() {
    let (tx, rx) = async_channel::unbounded();
    let (old, adapter, count) = active(101, &tx);
    drop(drain(&rx));
    let retained_state = old.state.clone();
    let mut adapters = vec![old];
    block_on(process_adapter_message(
        &None,
        &mut adapters,
        Message::RemoveAdapter { id: 101 },
    ))
    .unwrap();
    assert!(matches!(
        *retained_state.lock().unwrap(),
        AdapterState::Inactive { .. }
    ));
    assert_eq!(
        count.load(Ordering::SeqCst),
        0,
        "destroy preserves upstream notification semantics"
    );
    assert!(
        !rx.is_empty(),
        "actual AdapterImpl destructor emitted its removal"
    );
    block_on(retire_bus(
        &mut None,
        &mut adapters,
        &tx,
        &mut Box::pin(rx.clone()),
    ))
    .unwrap();
    drop(adapter);
    drop(retained_state);
    let trailing = drain(&rx);
    assert_eq!(trailing.len(), 1);
    assert!(
        matches!(trailing[0], Message::RemoveAdapter { id: 101 }),
        "delayed state drop emitted a callback behind Fence"
    );
}

#[test]
fn out_of_order_add_ids_remove_exact_adapter_and_preserve_window_order() {
    let (_, _rx) = async_channel::unbounded::<Message>();
    let mut adapters = Vec::new();
    for id in [9, 3, 7, 1] {
        block_on(process_adapter_message(
            &None,
            &mut adapters,
            add(id, state(false)),
        ))
        .unwrap();
    }
    block_on(process_adapter_message(
        &None,
        &mut adapters,
        Message::RemoveAdapter { id: 9 },
    ))
    .unwrap();
    assert_eq!(
        adapters.iter().map(|entry| entry.id).collect::<Vec<_>>(),
        vec![3, 7, 1]
    );
}

fn update_racing_fence(pending: bool) {
    let (tx, rx) = async_channel::unbounded();
    let (entry, mut adapter, count) = if pending {
        let state = state(true);
        let (entry, count) = entry(102, state.clone());
        (
            entry,
            Adapter::with_state_for_test(102, tx.clone(), state),
            count,
        )
    } else {
        active(103, &tx)
    };
    drop(drain(&rx));
    let state = entry.state.clone();
    let (entered_tx, entered_rx) = mpsc::channel();
    let (release_tx, release_rx) = mpsc::channel();
    let updater = thread::spawn(move || {
        adapter.update_if_active(|| {
            entered_tx.send(()).unwrap();
            release_rx.recv().unwrap();
            tree(true)
        });
        adapter
    });
    entered_rx.recv_timeout(Duration::from_secs(2)).unwrap();
    assert!(
        state.try_lock().is_err(),
        "real Adapter update must hold its state mutex"
    );
    let (started_tx, started_rx) = mpsc::channel();
    let (done_tx, done_rx) = mpsc::channel();
    let id = entry.id;
    drop(entry);
    let retire_state = state.clone();
    let retire_count = count.clone();
    let retire = thread::spawn(move || {
        let mut adapters = vec![AdapterEntry {
            id,
            state: retire_state,
            activation_handler: Box::new(NoActivation),
            deactivation_handler: Box::new(Deactivated(retire_count)),
        }];
        started_tx.send(()).unwrap();
        block_on(retire_bus(
            &mut None,
            &mut adapters,
            &tx,
            &mut Box::pin(rx.clone()),
        ))
        .unwrap();
        done_tx.send(()).unwrap();
        rx
    });
    started_rx.recv_timeout(Duration::from_secs(2)).unwrap();
    assert!(
        done_rx.try_recv().is_err(),
        "retirement cannot finish while old producer holds mutex"
    );
    release_tx.send(()).unwrap();
    let mut adapter = updater.join().unwrap();
    done_rx.recv_timeout(Duration::from_secs(2)).unwrap();
    let rx = retire.join().unwrap();
    assert_eq!(count.load(Ordering::SeqCst), 1);
    assert!(
        rx.is_empty(),
        "old update registration/cache/drop events crossed Fence"
    );
    assert!(matches!(
        *state.lock().unwrap(),
        AdapterState::Inactive { .. }
    ));
    adapter.update_if_active(|| panic!("retired update must remain inactive"));
    assert!(rx.is_empty());
}
#[test]
fn active_update_racing_fence_is_retired_under_state_mutex() {
    update_racing_fence(false);
}
#[test]
fn pending_update_racing_fence_cannot_construct_old_callback_after_fence() {
    update_racing_fence(true);
}

#[test]
fn in_flight_direct_action_is_not_revoked_by_callback_fence() {
    // This exercises the common PlatformNode action path used by the object
    // server. It intentionally demonstrates the fence's authority limitation;
    // this does not assert concurrent scheduling of a blocked D-Bus dispatcher.
    struct GatedAction {
        entered: mpsc::Sender<()>,
        release: mpsc::Receiver<()>,
        completed: Arc<AtomicUsize>,
    }
    impl ActionHandler for GatedAction {
        fn do_action(&mut self, _: ActionRequest) {
            self.entered.send(()).unwrap();
            self.release.recv_timeout(Duration::from_secs(2)).unwrap();
            self.completed.fetch_add(1, Ordering::SeqCst);
        }
    }
    let (tx, rx) = async_channel::unbounded();
    let (entered_tx, entered_rx) = mpsc::channel();
    let (release_tx, release_rx) = mpsc::channel();
    let completed = Arc::new(AtomicUsize::new(0));
    let app = AppContext::new(None);
    let consumer = accesskit_consumer::Tree::new(tree(false), false);
    let button_id = consumer.state().root().children().next().unwrap().id();
    let r#impl = AdapterImpl::with_wrapped_action_handler(
        104,
        &app,
        Callback::with_messages(tx.clone()),
        tree(false),
        false,
        Default::default(),
        Arc::new(ActionHandlerWrapper::new(GatedAction {
            entered: entered_tx,
            release: release_rx,
            completed: completed.clone(),
        })),
    );
    let node = r#impl.platform_node(button_id);
    let state = Arc::new(Mutex::new(AdapterState::Active(r#impl)));
    let (entry, _) = entry(104, state);
    let action = thread::spawn(move || node.do_action(0).unwrap());
    entered_rx.recv_timeout(Duration::from_secs(2)).unwrap();
    let mut adapters = vec![entry];
    block_on(retire_bus(
        &mut None,
        &mut adapters,
        &tx,
        &mut Box::pin(rx.clone()),
    ))
    .unwrap();
    assert!(rx.is_empty());
    assert_eq!(completed.load(Ordering::SeqCst), 0);
    release_tx.send(()).unwrap();
    assert!(action.join().unwrap());
    assert_eq!(
        completed.load(Ordering::SeqCst),
        1,
        "fencing callbacks must not be claimed as cancellation of direct actions"
    );
}

#[test]
fn controls_accepted_after_fence_remain_for_next_worker_pass() {
    use std::{
        pin::Pin,
        task::{Context, Poll},
    };
    struct AfterFence {
        rx: Pin<Box<Receiver<Message>>>,
        tx: Sender<Message>,
    }
    impl futures_lite::Stream for AfterFence {
        type Item = Message;
        fn poll_next(mut self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Option<Message>> {
            let message = self.rx.as_mut().poll_next(cx);
            if matches!(&message, Poll::Ready(Some(Message::Fence))) {
                assert!(self.tx.try_send(Message::RemoveAdapter { id: 105 }).is_ok());
            }
            message
        }
    }
    let (tx, rx) = async_channel::unbounded();
    assert!(tx.try_send(add(105, state(false))).is_ok());
    let mut messages = AfterFence {
        rx: Box::pin(rx.clone()),
        tx: tx.clone(),
    };
    let mut adapters = Vec::new();
    block_on(retire_bus(&mut None, &mut adapters, &tx, &mut messages)).unwrap();
    assert_eq!(
        adapters.iter().map(|entry| entry.id).collect::<Vec<_>>(),
        vec![105]
    );
    assert!(matches!(
        rx.try_recv().unwrap(),
        Message::RemoveAdapter { id: 105 }
    ));
    assert!(rx.is_empty());
}
