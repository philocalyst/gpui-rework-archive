// Copyright 2026 The GPUI contributors.
// Licensed under the Apache License, Version 2.0 or MIT, at your option.
// Real Unix Adapter + Consumer + private D-Bus protocol fixture. This is not a
// GPUI NativeAdapter/window test and does not require an AT-SPI desktop daemon.
#![cfg(unix)]

use accesskit::{
    Action, ActionHandler, ActionRequest, ActivationHandler, DeactivationHandler, Node, NodeId,
    Role, TreeId, TreeInfo, TreeUpdate,
};
use accesskit_unix::Adapter;
use std::{
    io::{BufRead, BufReader},
    process::{Child, Command, Stdio},
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
        mpsc,
    },
    thread,
    time::{Duration, Instant},
};
use zbus::{
    blocking::{Connection, Proxy, connection::Builder},
    zvariant::OwnedObjectPath,
};

type Address = (String, OwnedObjectPath);
const CACHE: &str = "/org/a11y/atspi/cache";
const ROOT: &str = "/org/a11y/atspi/accessible/root";
const STATUS_PATH: &str = "/org/a11y/bus";

struct Daemon(Child);
impl Daemon {
    // Synchronous test setup owns the private daemon through kill/wait at drop.
    #[allow(clippy::disallowed_methods)]
    fn start() -> (Self, String) {
        let mut child = Command::new("dbus-daemon")
            .args(["--session", "--nofork", "--nopidfile", "--print-address=1"])
            .stdout(Stdio::piped())
            .spawn()
            .unwrap();
        let mut address = String::new();
        BufReader::new(child.stdout.take().unwrap())
            .read_line(&mut address)
            .unwrap();
        (Self(child), address.trim().to_owned())
    }
}
impl Drop for Daemon {
    fn drop(&mut self) {
        let _ = self.0.kill();
        let _ = self.0.wait();
    }
}

struct Status {
    is_enabled: bool,
    failed_reads: Option<Arc<AtomicUsize>>,
}
#[zbus::interface(name = "org.a11y.Status")]
impl Status {
    #[zbus(property)]
    fn is_enabled(&self) -> zbus::fdo::Result<bool> {
        if let Some(count) = &self.failed_reads {
            count.fetch_add(1, Ordering::SeqCst);
            Err(zbus::fdo::Error::Failed(
                "fixture status owner unavailable".to_owned(),
            ))
        } else {
            Ok(self.is_enabled)
        }
    }
    #[zbus(property)]
    fn set_is_enabled(&mut self, value: bool) {
        self.is_enabled = value;
    }
}
struct BusAddress(String);
#[zbus::interface(name = "org.a11y.Bus")]
impl BusAddress {
    fn get_address(&self) -> &str {
        &self.0
    }
}
struct Registry(mpsc::Sender<Address>);
#[zbus::interface(name = "org.a11y.atspi.Socket")]
impl Registry {
    fn embed(&self, plug: Address, #[zbus(connection)] conn: &zbus::Connection) -> Address {
        self.0.send(plug).unwrap();
        (
            conn.unique_name().unwrap().to_string(),
            ROOT.try_into().unwrap(),
        )
    }
}
fn service(address: &str, enabled: bool, replace: bool) -> Connection {
    service_status(address, enabled, replace, None)
}
fn service_status(
    address: &str,
    enabled: bool,
    replace: bool,
    failed_reads: Option<Arc<AtomicUsize>>,
) -> Connection {
    Builder::address(address)
        .unwrap()
        .allow_name_replacements(true)
        .replace_existing_names(replace)
        .name("org.a11y.Bus")
        .unwrap()
        .serve_at(
            STATUS_PATH,
            Status {
                is_enabled: enabled,
                failed_reads,
            },
        )
        .unwrap()
        .serve_at(STATUS_PATH, BusAddress(address.to_owned()))
        .unwrap()
        .build()
        .unwrap()
}
fn set_enabled(client: &Connection, owner: &str, enabled: bool) {
    Proxy::new(client, owner, STATUS_PATH, "org.a11y.Status")
        .unwrap()
        .set_property("IsEnabled", enabled)
        .unwrap();
}
fn tree(generation: usize, label: &str) -> TreeUpdate {
    let mut root = Node::new(Role::Window);
    root.set_label(format!("generation {generation}"));
    root.set_children([NodeId(2)]);
    let mut button = Node::new(Role::Button);
    button.set_label(label);
    button.add_action(Action::Click);
    TreeUpdate {
        nodes: vec![(NodeId(1), root), (NodeId(2), button)],
        tree: Some(TreeInfo::new(NodeId(1))),
        tree_id: TreeId::ROOT,
        focus: NodeId(2),
    }
}
#[derive(Default)]
struct Counts {
    activated: AtomicUsize,
    deactivated: AtomicUsize,
    actions: AtomicUsize,
}
#[derive(Clone)]
struct Handlers(Arc<Counts>);
impl ActivationHandler for Handlers {
    fn request_initial_tree(&mut self) -> Option<TreeUpdate> {
        let generation = self.0.activated.fetch_add(1, Ordering::SeqCst) + 1;
        Some(tree(generation, "press"))
    }
}
impl DeactivationHandler for Handlers {
    fn deactivate_accessibility(&mut self) {
        self.0.deactivated.fetch_add(1, Ordering::SeqCst);
    }
}
impl ActionHandler for Handlers {
    fn do_action(&mut self, action: ActionRequest) {
        assert_eq!(action.target_node, NodeId(2));
        assert_eq!(action.action, Action::Click);
        self.0.actions.fetch_add(1, Ordering::SeqCst);
    }
}
// Blocks the worker in an actual second Adapter's initial-tree callback while
// the first Adapter queues old RegisterInterfaces/EmitCacheAdd payloads.
struct GatedActivation {
    gate: Option<(mpsc::Sender<()>, mpsc::Receiver<()>)>,
    counts: Arc<Counts>,
}
impl ActivationHandler for GatedActivation {
    fn request_initial_tree(&mut self) -> Option<TreeUpdate> {
        self.counts.activated.fetch_add(1, Ordering::SeqCst);
        if let Some((entered, release)) = self.gate.take() {
            entered.send(()).unwrap();
            release.recv_timeout(Duration::from_secs(8)).unwrap();
        }
        None
    }
}

struct TaggedActivation {
    tag: usize,
    counts: Arc<Counts>,
}
impl ActivationHandler for TaggedActivation {
    fn request_initial_tree(&mut self) -> Option<TreeUpdate> {
        self.counts.activated.fetch_add(1, Ordering::SeqCst);
        Some(tree(self.tag, "press"))
    }
}
fn new_pending_adapter() -> (Adapter, Arc<Counts>) {
    let counts = Arc::new(Counts::default());
    let handlers = Handlers(counts.clone());
    let adapter = Adapter::new(
        GatedActivation {
            gate: None,
            counts: counts.clone(),
        },
        handlers.clone(),
        handlers,
    );
    (adapter, counts)
}
fn window_names(client: &Connection, root: &Address) -> Option<Vec<(Address, String)>> {
    children(client, root)
        .ok()?
        .into_iter()
        .map(|node| {
            let name = proxy(client, &node, "org.a11y.atspi.Accessible")
                .get_property::<String>("Name")
                .ok()?;
            Some((node, name))
        })
        .collect()
}
fn assert_windows(client: &Connection, root: &Address, expected: &[String]) {
    let windows = wait_for("exact desktop children", || {
        let windows = window_names(client, root)?;
        let names = windows
            .iter()
            .map(|(_, name)| name.as_str())
            .collect::<Vec<_>>();
        (names == expected.iter().map(String::as_str).collect::<Vec<_>>()).then_some(windows)
    });
    for (index, (node, _)) in windows.iter().enumerate() {
        let actual: i32 = proxy(client, node, "org.a11y.atspi.Accessible")
            .call("GetIndexInParent", &())
            .unwrap();
        assert_eq!(actual, index as i32, "native desktop child ordinal");
    }
}

fn wait_for<T>(label: &str, mut predicate: impl FnMut() -> Option<T>) -> T {
    let deadline = Instant::now() + Duration::from_secs(8);
    loop {
        if let Some(value) = predicate() {
            return value;
        }
        assert!(Instant::now() < deadline, "timed out waiting for {label}");
        thread::sleep(Duration::from_millis(5));
    }
}
fn proxy<'a>(client: &Connection, node: &'a Address, interface: &'a str) -> Proxy<'a> {
    Proxy::new(client, node.0.as_str(), node.1.as_str(), interface).unwrap()
}
fn children(client: &Connection, node: &Address) -> zbus::Result<Vec<Address>> {
    proxy(client, node, "org.a11y.atspi.Accessible").call("GetChildren", &())
}
fn published(
    client: &Connection,
    embeds: &mpsc::Receiver<Address>,
    generation: usize,
) -> (Address, Address) {
    println!("PROVIDER waiting_full_tree activation={generation}");
    let root = embeds
        .recv_timeout(Duration::from_secs(8))
        .expect("application Embed");
    let window = wait_for("full native tree", || {
        let windows = children(client, &root).ok()?;
        let window = windows.into_iter().next()?;
        let name = proxy(client, &window, "org.a11y.atspi.Accessible")
            .get_property::<String>("Name")
            .ok()?;
        (name == format!("generation {generation}")).then_some(window)
    });
    let button = wait_for("button registration", || {
        let button = children(client, &window).ok()?.into_iter().next()?;
        let name = proxy(client, &button, "org.a11y.atspi.Accessible")
            .get_property::<String>("Name")
            .ok()?;
        (name == "press").then_some(button)
    });
    (root, button)
}
fn invoke(client: &Connection, button: &Address, counts: &Counts, expected: usize) {
    assert!(
        proxy(client, button, "org.a11y.atspi.Action")
            .call::<_, _, bool>("DoAction", &(0i32,))
            .unwrap()
    );
    wait_for("actual ActionHandler", || {
        (counts.actions.load(Ordering::SeqCst) == expected).then_some(())
    });
}

// GetItems walks AppContext; introspection independently observes the object
// server. Keep the shared Bus alive through a surviving public Adapter.
fn close_one_window(client: &Connection, root: &Address, survivor: &Address, counts: &Counts) {
    let closed_counts = Arc::new(Counts::default());
    let handlers = Handlers(closed_counts.clone());
    let closed = Adapter::new(
        TaggedActivation {
            tag: 90,
            counts: closed_counts.clone(),
        },
        handlers.clone(),
        handlers,
    );
    let window = wait_for("second window registration", || {
        window_names(client, root)?
            .into_iter()
            .find_map(|(node, name)| (name == "generation 90").then_some(node))
    });
    let button = wait_for("second window button registration", || {
        let button = children(client, &window).ok()?.into_iter().next()?;
        let count = proxy(client, &button, "org.a11y.atspi.Action")
            .get_property::<i32>("NActions")
            .ok()?;
        (count == 1).then_some(button)
    });
    invoke(client, &button, &closed_counts, 1);
    let cache = Proxy::new(client, root.0.as_str(), CACHE, "org.a11y.atspi.Cache").unwrap();
    let snapshot = || {
        cache
            .call::<_, _, Vec<atspi::CacheItem>>("GetItems", &())
            .unwrap()
    };
    let paths = |items: Vec<atspi::CacheItem>| {
        items
            .into_iter()
            .map(|item| item.object.path_as_str().to_owned())
            .collect::<Vec<_>>()
    };
    let before = paths(snapshot());
    assert!(before.contains(&window.1.to_string()));
    assert!(before.contains(&button.1.to_string()));
    assert!(before.contains(&survivor.1.to_string()));
    let removals = cache.receive_signal("RemoveAccessible").unwrap();
    let (removed_tx, removed_rx) = mpsc::channel();
    let listener = thread::spawn(move || {
        for message in removals.take(2) {
            let reference: atspi::ObjectRefOwned = message.body().deserialize().unwrap();
            removed_tx.send(reference.path_as_str().to_owned()).unwrap();
        }
    });
    drop(closed);
    wait_for("closed window leaves desktop", || {
        (children(client, root).ok()?.len() == 1).then_some(())
    });
    let after = paths(snapshot());
    assert!(!after.contains(&window.1.to_string()));
    assert!(!after.contains(&button.1.to_string()));
    assert!(after.contains(&survivor.1.to_string()));
    println!(
        "CLOSE_PROTOCOL cache_before={} cache_after={} survivor_cached=true",
        before.len(),
        after.len()
    );
    for node in [&button, &window] {
        let xml = proxy(client, node, "org.freedesktop.DBus.Introspectable")
            .call::<_, _, String>("Introspect", &());
        println!(
            "CLOSE_PROTOCOL closed_path={} retained_atspi_interfaces={}",
            node.1,
            xml.is_ok_and(|xml| xml.contains("org.a11y.atspi."))
        );
    }
    for node in [&button, &window] {
        wait_for("closed window object interfaces removed", || {
            let xml = proxy(client, node, "org.freedesktop.DBus.Introspectable")
                .call::<_, _, String>("Introspect", &());
            (!xml.is_ok_and(|xml| xml.contains("org.a11y.atspi."))).then_some(())
        });
    }
    let removed = (0..2)
        .map(|_| removed_rx.recv_timeout(Duration::from_secs(8)).unwrap())
        .collect::<Vec<_>>();
    assert_eq!(removed, [button.1.to_string(), window.1.to_string()]);
    listener.join().unwrap();
    assert_eq!(closed_counts.deactivated.load(Ordering::SeqCst), 0);
    invoke(client, survivor, counts, 2);
    println!("CLOSE_PROTOCOL closed_paths=2 cache_remove=2 survivor_action=ok");
}

#[test]
fn late_service_initial_true_disable_reenable_and_live_owner_replacement() {
    // This test binary has one test. Set the process address before starting any
    // worker, then keep it fixed until exit (the provider intentionally is global).
    let (_daemon, address) = Daemon::start();
    unsafe {
        std::env::set_var("DBUS_SESSION_BUS_ADDRESS", &address);
        std::env::remove_var("AT_SPI_BUS_ADDRESS");
    }
    let client = Builder::address(address.as_str())
        .unwrap()
        .method_timeout(Duration::from_secs(2))
        .build()
        .unwrap();
    let (embeds_tx, embeds) = mpsc::channel();
    let _registry = Builder::address(address.as_str())
        .unwrap()
        .name("org.a11y.atspi.Registry")
        .unwrap()
        .serve_at(ROOT, Registry(embeds_tx))
        .unwrap()
        .build()
        .unwrap();
    let counts = Arc::new(Counts::default());
    let handlers = Handlers(counts.clone());
    let mut adapter = Adapter::new(handlers.clone(), handlers.clone(), handlers);
    // Allow the real worker to subscribe with no org.a11y.Bus owner. The later
    // property starts true, so no property edge can accidentally rescue it.
    thread::sleep(Duration::from_millis(200));
    assert_eq!(counts.activated.load(Ordering::SeqCst), 0);
    let old_service = service(&address, true, false);
    let (old_root, old_button) = published(&client, &embeds, 1);
    invoke(&client, &old_button, &counts, 1);
    close_one_window(&client, &old_root, &old_button, &counts);

    // Consumer checks the exact initial update used by the native protocol proof.
    let consumer = accesskit_consumer::Tree::new(tree(1, "press"), false);
    assert_eq!(consumer.state().root().data().label(), Some("generation 1"));

    adapter.update_if_active(|| tree(1, "updated"));
    wait_for("actual adapter update", || {
        (proxy(&client, &old_button, "org.a11y.atspi.Accessible")
            .get_property::<String>("Name")
            .ok()?
            == "updated")
            .then_some(())
    });
    set_enabled(&client, "org.a11y.Bus", false);
    wait_for("deactivation", || {
        (counts.deactivated.load(Ordering::SeqCst) == 1).then_some(())
    });
    set_enabled(&client, "org.a11y.Bus", true);
    let (_second_root, second_button) = published(&client, &embeds, 2);
    invoke(&client, &second_button, &counts, 3);

    let (entered_tx, entered_rx) = mpsc::channel();
    let (release_tx, release_rx) = mpsc::channel();
    let pending_counts = Arc::new(Counts::default());
    let pending_handlers = Handlers(pending_counts.clone());
    let pending_adapter = Adapter::new(
        GatedActivation {
            gate: Some((entered_tx, release_rx)),
            counts: pending_counts.clone(),
        },
        pending_handlers.clone(),
        pending_handlers,
    );
    entered_rx.recv_timeout(Duration::from_secs(8)).unwrap();
    // These obsolete node IDs must have no interface on the replacement Bus.
    // The worker is blocked, so all registrations/cache additions are queued
    // before the owner replacement, rather than merely racing an idle monitor.
    const LAST_OBSOLETE: u64 = 1026;
    adapter.update_if_active(|| {
        let mut update = tree(2, "press");
        update.nodes[0]
            .1
            .set_children((2..=LAST_OBSOLETE).map(NodeId).collect::<Vec<_>>());
        for id in 3..=LAST_OBSOLETE {
            let mut node = Node::new(Role::Button);
            node.set_label(format!("obsolete {id}"));
            update.nodes.push((NodeId(id), node));
        }
        update
    });
    // Controls are queued alongside that backlog while Bus construction cannot
    // progress. The transient adapter must leave no replacement desktop child.
    let transient_handlers = Handlers(Arc::new(Counts::default()));
    let transient = Adapter::new(
        transient_handlers.clone(),
        transient_handlers.clone(),
        transient_handlers,
    );
    drop(transient);
    // Direct true->true replacement while old unique owner stays connected.
    let replacement = service(&address, true, true);
    release_tx.send(()).unwrap();
    let (new_root, new_button) = published(&client, &embeds, 3);
    assert_eq!(children(&client, &new_root).unwrap().len(), 1);
    assert_eq!(pending_counts.activated.load(Ordering::SeqCst), 2);
    assert_eq!(pending_counts.deactivated.load(Ordering::SeqCst), 1);
    let node_prefix = second_button.1.as_str().rsplit_once('/').unwrap().0;
    for id in 3..=LAST_OBSOLETE {
        let stale: Address = (
            new_root.0.clone(),
            format!("{node_prefix}/{}", u128::from(id) << 64)
                .try_into()
                .unwrap(),
        );
        let xml = proxy(&client, &stale, "org.freedesktop.DBus.Introspectable")
            .call::<_, _, String>("Introspect", &());
        assert!(
            !xml.is_ok_and(|xml| xml.contains("org.a11y.atspi.Accessible")),
            "obsolete registration {id} crossed into replacement Bus"
        );
    }
    drop(pending_adapter);
    assert_ne!(
        old_root.0, new_root.0,
        "replacement must own a fresh AT-SPI connection"
    );
    assert_eq!(counts.deactivated.load(Ordering::SeqCst), 2);
    invoke(&client, &new_button, &counts, 4);
    let old_owner = old_service.unique_name().unwrap().to_string();
    set_enabled(&client, &old_owner, false);
    set_enabled(&client, &old_owner, true);
    thread::sleep(Duration::from_millis(100));
    assert_eq!(
        counts.activated.load(Ordering::SeqCst),
        3,
        "stale old-owner properties"
    );
    assert_eq!(
        counts.deactivated.load(Ordering::SeqCst),
        2,
        "stale old-owner properties"
    );
    // Force B->A->B entirely while the worker is blocked. A fresh owner
    // snapshot is still B, but the queued loss of B must retire its generation.
    let (entered_tx, entered_rx) = mpsc::channel();
    let (release_tx, release_rx) = mpsc::channel();
    let gate_counts = Arc::new(Counts::default());
    let gate_handlers = Handlers(gate_counts.clone());
    let gate_adapter = Adapter::new(
        GatedActivation {
            gate: Some((entered_tx, release_rx)),
            counts: gate_counts,
        },
        gate_handlers.clone(),
        gate_handlers,
    );
    entered_rx.recv_timeout(Duration::from_secs(8)).unwrap();
    let flags = zbus::fdo::RequestNameFlags::AllowReplacement
        | zbus::fdo::RequestNameFlags::ReplaceExisting
        | zbus::fdo::RequestNameFlags::DoNotQueue;
    // Use the actual DBus.RequestName call here. zbus's convenience method
    // can return AlreadyOwner from its local cache before NameLost is handled,
    // which would silently fail to create the required B->A->B schedule.
    for service in [&old_service, &replacement] {
        let dbus = Proxy::new(
            service,
            "org.freedesktop.DBus",
            "/org/freedesktop/DBus",
            "org.freedesktop.DBus",
        )
        .unwrap();
        let reply: u32 = dbus
            .call("RequestName", &("org.a11y.Bus", flags.bits()))
            .unwrap();
        assert_eq!(
            reply, 1,
            "fixture must actually replace the well-known owner"
        );
    }
    let actual_owner: String = Proxy::new(
        &client,
        "org.freedesktop.DBus",
        "/org/freedesktop/DBus",
        "org.freedesktop.DBus",
    )
    .unwrap()
    .call("GetNameOwner", &("org.a11y.Bus",))
    .unwrap();
    assert_eq!(actual_owner, replacement.unique_name().unwrap().as_str());
    release_tx.send(()).unwrap();
    let (cycle_root, cycle_button) = published(&client, &embeds, 4);
    assert_ne!(
        cycle_root.0, new_root.0,
        "snapshot-equal owner cycle must reconstruct Bus"
    );
    invoke(&client, &cycle_button, &counts, 5);
    assert_eq!(counts.deactivated.load(Ordering::SeqCst), 3);
    drop(gate_adapter);
    let new_root = cycle_root;
    drop(old_service);
    thread::sleep(Duration::from_millis(100));
    assert_eq!(
        counts.deactivated.load(Ordering::SeqCst),
        3,
        "old unique owner disconnect"
    );

    // A property cache/GetAll failure must not kill the process-global worker.
    // A subsequent unique owner still gets a fresh full tree and real action.
    let failed_reads = Arc::new(AtomicUsize::new(0));
    let _broken = service_status(&address, true, true, Some(failed_reads.clone()));
    wait_for("broken owner's GetAll", || {
        (failed_reads.load(Ordering::SeqCst) > 0).then_some(())
    });
    thread::sleep(Duration::from_millis(100));
    assert_eq!(counts.deactivated.load(Ordering::SeqCst), 4);
    let _restored = service(&address, true, true);
    let (restored_root, restored_button) = published(&client, &embeds, 5);
    assert_ne!(restored_root.0, new_root.0);
    invoke(&client, &restored_button, &counts, 6);

    // Initial tree completion order can differ from creation/Add order even
    // without concurrent construction. Keep actual append/desktop ordinals.
    let (mut low, low_counts) = new_pending_adapter();
    let (mut high, high_counts) = new_pending_adapter();
    wait_for("two Pending activations", || {
        (low_counts.activated.load(Ordering::SeqCst) == 1
            && high_counts.activated.load(Ordering::SeqCst) == 1)
            .then_some(())
    });
    high.update_if_active(|| tree(22, "press"));
    low.update_if_active(|| tree(21, "press"));
    assert_windows(
        &client,
        &restored_root,
        &[
            "generation 5".into(),
            "generation 22".into(),
            "generation 21".into(),
        ],
    );
    set_enabled(&client, "org.a11y.Bus", false);
    wait_for("all Active generations retired", || {
        (counts.deactivated.load(Ordering::SeqCst) == 5
            && low_counts.deactivated.load(Ordering::SeqCst) == 1
            && high_counts.deactivated.load(Ordering::SeqCst) == 1)
            .then_some(())
    });
    set_enabled(&client, "org.a11y.Bus", true);
    let (reactivated_root, reactivated_button) = published(&client, &embeds, 6);
    wait_for("two reactivated Pending states", || {
        (low_counts.activated.load(Ordering::SeqCst) == 2
            && high_counts.activated.load(Ordering::SeqCst) == 2)
            .then_some(())
    });
    high.update_if_active(|| tree(22, "press"));
    low.update_if_active(|| tree(21, "press"));
    assert_windows(
        &client,
        &reactivated_root,
        &[
            "generation 6".into(),
            "generation 22".into(),
            "generation 21".into(),
        ],
    );
    drop(high);
    assert_windows(
        &client,
        &reactivated_root,
        &["generation 6".into(), "generation 21".into()],
    );
    drop(low);
    assert_windows(&client, &reactivated_root, &["generation 6".into()]);

    invoke(&client, &reactivated_button, &counts, 7);

    // Race actual public Adapter creation on four callers, then remove a
    // particular tagged adapter and preserve the remaining desktop-child order.
    let start = Arc::new(std::sync::Barrier::new(5));
    let creators = (0..4)
        .map(|tag| {
            let start = start.clone();
            thread::spawn(move || {
                let counts = Arc::new(Counts::default());
                let handlers = Handlers(counts.clone());
                start.wait();
                let adapter = Adapter::new(
                    TaggedActivation {
                        tag: 100 + tag,
                        counts: counts.clone(),
                    },
                    handlers.clone(),
                    handlers,
                );
                (adapter, counts)
            })
        })
        .collect::<Vec<_>>();
    start.wait();
    let mut concurrent = creators
        .into_iter()
        .map(|creator| creator.join().unwrap())
        .collect::<Vec<_>>();
    wait_for("all concurrent actual adapters active", || {
        concurrent
            .iter()
            .all(|(_, counts)| counts.activated.load(Ordering::SeqCst) == 1)
            .then_some(())
    });
    let order = wait_for("all concurrent native children", || {
        let windows = window_names(&client, &reactivated_root)?;
        (windows.len() == 5).then(|| {
            windows
                .into_iter()
                .map(|(_, name)| name)
                .collect::<Vec<_>>()
        })
    });
    assert_windows(&client, &reactivated_root, &order);
    set_enabled(&client, "org.a11y.Bus", false);
    wait_for("concurrent adapter deactivation", || {
        (counts.deactivated.load(Ordering::SeqCst) == 6
            && concurrent
                .iter()
                .all(|(_, counts)| counts.deactivated.load(Ordering::SeqCst) == 1))
        .then_some(())
    });
    set_enabled(&client, "org.a11y.Bus", true);
    let (reactivated_root, reactivated_button) = published(&client, &embeds, 7);
    wait_for("concurrent adapter reactivation", || {
        concurrent
            .iter()
            .all(|(_, counts)| counts.activated.load(Ordering::SeqCst) == 2)
            .then_some(())
    });
    let order = order
        .into_iter()
        .map(|name| {
            if name == "generation 6" {
                "generation 7".into()
            } else {
                name
            }
        })
        .collect::<Vec<_>>();
    assert_windows(&client, &reactivated_root, &order);
    drop(concurrent.remove(1)); // creator tag101, independently of actual Add order
    let remaining = order
        .into_iter()
        .filter(|name| name != "generation 101")
        .collect::<Vec<_>>();
    assert_eq!(remaining.len(), 4);
    assert_windows(&client, &reactivated_root, &remaining);
    drop(concurrent);
    assert_windows(&client, &reactivated_root, &["generation 7".into()]);
    invoke(&client, &reactivated_button, &counts, 8);
    assert_eq!(counts.activated.load(Ordering::SeqCst), 7);
    assert_eq!(counts.deactivated.load(Ordering::SeqCst), 6);
    drop(adapter);
    wait_for("adapter destroy removes native window", || {
        children(&client, &reactivated_root)
            .ok()?
            .is_empty()
            .then_some(())
    });
    drop(replacement);
    println!(
        "actual Adapter protocol: late initial-true -> action/update -> disable/re-enable -> blocked old registration/cache backlog + Pending + transient Add/Remove -> live true/true replacement -> stale-owner ignored -> blocked B/A/B owner cycle -> failed status owner recovery -> reverse Pending + reactivation + concurrent adapters/desktop ordinals -> destroy"
    );
}
