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

fn deactivate_adapter(entry: &mut AdapterEntry) {
    let mut state = entry.state.lock().unwrap();
    match &*state {
        AdapterState::Inactive { .. } => (),
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
            drop(state);
            entry.deactivation_handler.deactivate_accessibility();
        }
        AdapterState::Active(r#impl) => {
            *state = AdapterState::Inactive {
                is_window_focused: r#impl.is_window_focused(),
                root_window_bounds: r#impl.root_window_bounds(),
                action_handler: r#impl.wrapped_action_handler(),
            };
            drop(state);
            entry.deactivation_handler.deactivate_accessibility();
        }
    }
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
    let status = StatusProxy::builder(session_bus)
        .destination(owner.clone())?
        .build()
        .await?;
    Ok(Some(status.receive_is_enabled_changed().await))
}

async fn next_status_change(
    changes: &mut Option<PropertyStream<'static, bool>>,
) -> Option<PropertyChanged<'static, bool>> {
    match changes {
        Some(changes) => futures_lite::StreamExt::next(changes).await,
        None => std::future::pending().await,
    }
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
        OwnerChanged,
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
                    if signal.is_some() { Wake::OwnerChanged } else { Wake::Closed }
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
            Wake::OwnerChanged => {
                // The subscription and initial snapshot overlap. Always reconcile
                // queued signals with the bus, rather than replaying a stale owner.
                let next_owner = status_owner(&dbus).await?;
                if next_owner != owner {
                    atspi_bus = None;
                    sync_adapters(&mut adapters, &atspi_bus);
                    owner = next_owner;
                    changes = status_changes(&session_bus, &owner).await?;
                }
            }
            Wake::Status(enabled) => {
                if enabled? {
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
                    atspi_bus = None;
                    sync_adapters(&mut adapters, &atspi_bus);
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
            if let Ok(index) = adapters.binary_search_by(|entry| entry.id.cmp(&id)) {
                adapters.remove(index);
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
