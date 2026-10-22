// Copyright 2023 The AccessKit Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0 (found in
// the LICENSE-APACHE file) or the MIT license (found in
// the LICENSE-MIT file), at your option.

use accesskit::{ActivationHandler, DeactivationHandler};
use accesskit_atspi_common::{Adapter as AdapterImpl, AppContext, Event};
#[cfg(not(feature = "tokio"))]
use async_channel::{Receiver, Sender};
use atspi::proxy::bus::StatusProxy;
#[cfg(not(feature = "tokio"))]
use futures_util::{FutureExt, StreamExt, pin_mut as pin, select};
use std::{
    sync::{Arc, Mutex, OnceLock, RwLock},
    thread,
};
#[cfg(feature = "tokio")]
use tokio::{
    pin, select,
    sync::mpsc::{UnboundedReceiver as Receiver, UnboundedSender as Sender},
};
#[cfg(feature = "tokio")]
use tokio_stream::{StreamExt, wrappers::UnboundedReceiverStream};
use zbus::{
    Connection,
    connection::Builder,
    fdo::DBusProxy,
    names::OwnedUniqueName,
    proxy::{PropertyChanged, PropertyStream},
};

use crate::{
    adapter::{AdapterState, Callback, Message},
    atspi::{Bus, map_or_ignoring_recoverable_error, zbus_error_is_unrecoverable},
    executor::Executor,
    util::block_on,
};

static APP_CONTEXT: OnceLock<Arc<RwLock<AppContext>>> = OnceLock::new();
static MESSAGES: OnceLock<Sender<Message>> = OnceLock::new();

fn app_name() -> Option<String> {
    std::env::current_exe().ok().and_then(|path| {
        path.file_name()
            .map(|name| name.to_string_lossy().to_string())
    })
}

pub(crate) fn get_or_init_app_context<'a>() -> &'a Arc<RwLock<AppContext>> {
    APP_CONTEXT.get_or_init(|| AppContext::new(app_name()))
}

pub(crate) fn get_or_init_messages() -> Sender<Message> {
    MESSAGES
        .get_or_init(|| {
            #[cfg(not(feature = "tokio"))]
            let (tx, rx) = async_channel::unbounded();
            #[cfg(feature = "tokio")]
            let (tx, rx) = tokio::sync::mpsc::unbounded_channel();

            thread::spawn(|| {
                let executor = Executor::new();
                block_on(executor.run(async {
                    if let Ok(session_bus) = Builder::session() {
                        if let Ok(session_bus) = session_bus.internal_executor(false).build().await
                        {
                            if let Err(error) = run_event_loop(&executor, session_bus, rx).await {
                                if zbus_error_is_unrecoverable(&error) {
                                    panic!("Accessibility event loop failed: {error}");
                                }
                            }
                        }
                    }
                }))
            });

            tx
        })
        .clone()
}

struct AdapterEntry {
    id: usize,
    activation_handler: Box<dyn ActivationHandler>,
    deactivation_handler: Box<dyn DeactivationHandler>,
    state: Arc<Mutex<AdapterState>>,
}

fn activate_adapter(entry: &mut AdapterEntry) {
    let mut state = entry.state.lock().unwrap();
    if let AdapterState::Inactive {
        is_window_focused,
        root_window_bounds,
        action_handler,
    } = &*state
    {
        *state = match entry.activation_handler.request_initial_tree() {
            Some(initial_state) => {
                let r#impl = AdapterImpl::with_wrapped_action_handler(
                    entry.id,
                    get_or_init_app_context(),
                    Callback::new(),
                    initial_state,
                    *is_window_focused,
                    *root_window_bounds,
                    Arc::clone(action_handler),
                );
                AdapterState::Active(r#impl)
            }
            None => AdapterState::Pending {
                is_window_focused: *is_window_focused,
                root_window_bounds: *root_window_bounds,
                action_handler: Arc::clone(action_handler),
            },
        };
    }
}

// Returns whether there was an active or pending generation to retire. All
// callback sends, including AdapterImpl::drop, finish under this same mutex.
fn deactivate_adapter_state(state: &Mutex<AdapterState>) -> bool {
    let mut state = state.lock().unwrap();
    match &*state {
        AdapterState::Inactive { .. } => false,
        AdapterState::Pending {
            is_window_focused,
            root_window_bounds,
            action_handler,
        } => {
            *state = AdapterState::Inactive {
                is_window_focused: *is_window_focused,
                root_window_bounds: *root_window_bounds,
                action_handler: Arc::clone(action_handler),
            };
            true
        }
        AdapterState::Active(r#impl) => {
            *state = AdapterState::Inactive {
                is_window_focused: r#impl.is_window_focused(),
                root_window_bounds: r#impl.root_window_bounds(),
                action_handler: r#impl.wrapped_action_handler(),
            };
            true
        }
    }
}

fn deactivate_adapter(entry: &mut AdapterEntry) {
    if deactivate_adapter_state(&entry.state) {
        entry.deactivation_handler.deactivate_accessibility();
    }
}

// Keep the original total order between control and tree messages. There is no
// event epoch or second generation channel. Retiring under each state mutex
// waits for every old synchronous Callback send before the worker appends Fence.
async fn retire_bus<S>(
    atspi_bus: &mut Option<Bus>,
    adapters: &mut Vec<AdapterEntry>,
    sender: &Sender<Message>,
    messages: &mut S,
) -> zbus::Result<()>
where
    S: futures_lite::Stream<Item = Message> + Unpin,
{
    *atspi_bus = None;
    sync_adapters(adapters, atspi_bus);
    #[cfg(not(feature = "tokio"))]
    let sent = sender.try_send(Message::Fence).is_ok();
    #[cfg(feature = "tokio")]
    let sent = sender.send(Message::Fence).is_ok();
    assert!(sent, "the accessibility worker owns the live receiver");
    while let Some(message) = futures_lite::StreamExt::next(messages).await {
        match message {
            Message::Fence => return Ok(()),
            // Add/Remove remain ordered; the absent Bus drops obsolete tree,
            // interface and cache payloads. New adapters stay inactive here.
            message => process_adapter_message(atspi_bus, adapters, message).await?,
        }
    }
    unreachable!("the worker's own fence must be in its live FIFO")
}

const STATUS_SERVICE: &str = "org.a11y.Bus";

async fn status_owner(dbus: &DBusProxy<'_>) -> zbus::Result<Option<OwnedUniqueName>> {
    match dbus
        .get_name_owner(STATUS_SERVICE.try_into().unwrap())
        .await
    {
        Ok(owner) => Ok(Some(owner)),
        Err(zbus::fdo::Error::NameHasNoOwner(_)) => Ok(None),
        Err(error) => Err(error.into()),
    }
}

async fn status_changes(
    session_bus: &Connection,
    owner: &Option<OwnedUniqueName>,
) -> zbus::Result<Option<PropertyStream<'static, bool>>> {
    let Some(owner) = owner else { return Ok(None) };
    // A well-known-name proxy can retain the previous owner's property cache.
    // Keep both properties and GetAddress bound to this exact unique owner.
    let status = map_or_ignoring_recoverable_error(
        StatusProxy::builder(session_bus)
            .destination(owner.clone())?
            .build()
            .await,
        None,
        Some,
    )?;
    match status {
        Some(status) => Ok(Some(status.receive_is_enabled_changed().await)),
        None => Ok(None),
    }
}

async fn next_status_change(
    changes: &mut Option<PropertyStream<'static, bool>>,
) -> Option<PropertyChanged<'static, bool>> {
    let change = match changes {
        Some(changes) => futures_lite::StreamExt::next(changes).await,
        None => std::future::pending().await,
    };
    if change.is_none() {
        // An ended stream must retire once, then leave the name monitor and
        // controls to wake us. Re-polling it would repeatedly enqueue Fence.
        *changes = None;
    }
    change
}

fn sync_adapters(adapters: &mut [AdapterEntry], atspi_bus: &Option<Bus>) {
    let active = atspi_bus.is_some();
    for entry in adapters {
        if active {
            activate_adapter(entry);
        } else {
            deactivate_adapter(entry);
        }
    }
}

async fn run_event_loop(
    executor: &Executor<'_>,
    session_bus: Connection,
    rx: Receiver<Message>,
) -> zbus::Result<()> {
    let session_bus_copy = session_bus.clone();
    let _session_bus_task = executor.spawn(
        async move {
            loop {
                session_bus_copy.executor().tick().await;
            }
        },
        "accesskit_session_bus_task",
    );

    let dbus = DBusProxy::new(&session_bus).await?;
    // Subscribe before the snapshot: a late service must not fall between them.
    let owners = dbus
        .receive_name_owner_changed_with_args(&[(0, STATUS_SERVICE)])
        .await?
        .fuse();
    pin!(owners);
    let mut owner = status_owner(&dbus).await?;
    let mut changes = status_changes(&session_bus, &owner).await?;

    #[cfg(not(feature = "tokio"))]
    let messages = rx.fuse();
    #[cfg(feature = "tokio")]
    let messages = UnboundedReceiverStream::new(rx).fuse();
    pin!(messages);

    let mut atspi_bus = None;
    let mut adapters: Vec<AdapterEntry> = Vec::new();

    enum Wake {
        OwnerChanged {
            old: Option<String>,
            new: Option<String>,
        },
        Status(zbus::Result<bool>),
        Message(Option<Message>),
        Closed,
    }

    loop {
        // End this borrow before changing the current owner's property stream.
        let wake = {
            let change = next_status_change(&mut changes);
            #[cfg(not(feature = "tokio"))]
            let change = change.fuse();
            pin!(change);
            select! {
                signal = owners.next() => {
                    match signal {
                        Some(signal) => {
                            let args = signal.args()?;
                            Wake::OwnerChanged {
                                old: args.old_owner().as_ref().map(|name| name.as_str().to_owned()),
                                new: args.new_owner().as_ref().map(|name| name.as_str().to_owned()),
                            }
                        }
                        None => Wake::Closed,
                    }
                }
                change = change => {
                    Wake::Status(match change {
                        Some(change) => change.get().await,
                        None => Ok(false),
                    })
                }
                message = messages.next() => Wake::Message(message),
            }
        };
        match wake {
            Wake::OwnerChanged { old, new } => {
                // The subscription and initial snapshot overlap. Always reconcile
                // queued signals with the bus, rather than replaying a stale owner.
                let next_owner = status_owner(&dbus).await?;
                // A->B->A can leave the snapshot unchanged while the worker
                // was busy. The old/current owner still lost a generation;
                // reconstruct once rather than retaining its former Bus/tree.
                let current = owner.as_ref().map(|name| name.as_str());
                let lost_current = old.as_deref() == current && new.as_deref() != current;
                if next_owner != owner || lost_current {
                    // Retire the old property observer before creating another
                    // owner's proxy/cache; no queued old property is reused.
                    drop(changes.take());
                    retire_bus(
                        &mut atspi_bus,
                        &mut adapters,
                        &get_or_init_messages(),
                        &mut messages,
                    )
                    .await?;
                    owner = next_owner;
                    changes = status_changes(&session_bus, &owner).await?;
                }
            }
            Wake::Status(enabled) => {
                let enabled = match enabled {
                    Ok(enabled) => enabled,
                    Err(error) if zbus_error_is_unrecoverable(&error) => return Err(error),
                    Err(_) => {
                        // The unique owner can disappear while its GetAll is
                        // in flight. Retire its status stream, but keep the name
                        // monitor/worker alive for the queued replacement.
                        changes = None;
                        false
                    }
                };
                if enabled {
                    if atspi_bus.is_none() {
                        if let Some(owner) = &owner {
                            atspi_bus = map_or_ignoring_recoverable_error(
                                Bus::new(&session_bus, owner, executor).await,
                                None,
                                Some,
                            )?;
                            sync_adapters(&mut adapters, &atspi_bus);
                        }
                    }
                } else {
                    retire_bus(
                        &mut atspi_bus,
                        &mut adapters,
                        &get_or_init_messages(),
                        &mut messages,
                    )
                    .await?;
                }
            }
            Wake::Message(Some(message)) => {
                process_adapter_message(&atspi_bus, &mut adapters, message).await?;
            }
            Wake::Message(None) | Wake::Closed => return Ok(()),
        }
    }
}

async fn process_adapter_message(
    atspi_bus: &Option<Bus>,
    adapters: &mut Vec<AdapterEntry>,
    message: Message,
) -> zbus::Result<()> {
    match message {
        Message::Fence => unreachable!("only retire_bus consumes a worker fence"),
        Message::AddAdapter {
            id,
            activation_handler,
            deactivation_handler,
            state,
        } => {
            adapters.push(AdapterEntry {
                id,
                activation_handler,
                deactivation_handler,
                state,
            });
            if atspi_bus.is_some() {
                let entry = adapters.last_mut().unwrap();
                activate_adapter(entry);
            }
        }
        Message::RemoveAdapter { id } => {
            // IDs are allocated before AddAdapter is enqueued. Concurrent
            // callers can enqueue them in a different order; retain FIFO child
            // order and find the requested adapter without a sorted-ID premise.
            if let Some(index) = adapters.iter().position(|entry| entry.id == id) {
                let entry = adapters.remove(index);
                // Adapter::drop can still own the final state Arc when its
                // RemoveAdapter reaches us. Retire now, so that delayed Arc drop
                // cannot produce an old callback behind a subsequent fence.
                // Destroy, as upstream, does not call the deactivation handler.
                deactivate_adapter_state(&entry.state);
            }
        }
        Message::RegisterInterfaces { node, interfaces } => {
            if let Some(bus) = atspi_bus {
                bus.register_interfaces(node, interfaces).await?
            }
        }
        Message::UnregisterInterfaces {
            adapter_id,
            node_id,
            interfaces,
        } => {
            if let Some(bus) = atspi_bus {
                bus.unregister_interfaces(adapter_id, node_id, interfaces)
                    .await?
            }
        }
        Message::EmitEvent {
            adapter_id,
            event: Event::Object { target, event },
        } => {
            if let Some(bus) = atspi_bus {
                bus.emit_object_event(adapter_id, target, event).await?
            }
        }
        Message::EmitEvent {
            adapter_id,
            event:
                Event::Window {
                    target,
                    name,
                    event,
                },
        } => {
            if let Some(bus) = atspi_bus {
                bus.emit_window_event(adapter_id, target, name, event)
                    .await?;
            }
        }
        Message::EmitEvent {
            adapter_id,
            event: Event::Document { target, event },
        } => {
            if let Some(bus) = atspi_bus {
                bus.emit_document_event(adapter_id, target, event).await?;
            }
        }
        Message::EmitEvent {
            event: Event::Cache(_),
            ..
        } => unreachable!("cache events are sent as EmitCacheAdd/EmitCacheRemove"),
        Message::EmitCacheAdd { node } => {
            if let Some(bus) = atspi_bus {
                bus.emit_cache_add(node).await?;
            }
        }
        Message::EmitCacheRemove {
            adapter_id,
            node_id,
        } => {
            if let Some(bus) = atspi_bus {
                bus.emit_cache_remove(adapter_id, node_id).await?;
            }
        }
    }

    Ok(())
}

#[cfg(test)]
#[test]
fn lifecycle_type_layout() {
    println!(
        "lifecycle bytes: Message={} AdapterState={} Callback={} AdapterEntry={}",
        std::mem::size_of::<Message>(),
        std::mem::size_of::<AdapterState>(),
        std::mem::size_of::<Callback>(),
        std::mem::size_of::<AdapterEntry>(),
    );
}

#[cfg(all(test, not(feature = "tokio")))]
#[path = "context_tests.rs"]
mod tests;
