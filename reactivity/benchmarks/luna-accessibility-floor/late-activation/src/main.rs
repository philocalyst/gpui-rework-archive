use accesskit::{ActionHandler, ActionRequest, ActivationHandler, DeactivationHandler, TreeUpdate};
use accesskit_unix::Adapter;
use futures_util::StreamExt;
use std::{
    env,
    process::{Child, Command},
    sync::{
        atomic::{AtomicUsize, Ordering},
        Arc,
    },
    thread,
    time::{Duration, Instant},
};
use zbus::{
    blocking::{connection::Builder as BlockingBuilder, Proxy},
    connection::Builder as AsyncBuilder,
    fdo::DBusProxy,
    zvariant::OwnedObjectPath,
};

const SERVICE: &str = "org.a11y.Bus";
const PATH: &str = "/org/a11y/bus";
const STATUS: &str = "org.a11y.Status";

struct Counts(Arc<CountsInner>);
struct CountsInner {
    activated: AtomicUsize,
    deactivated: AtomicUsize,
}
impl ActivationHandler for Counts {
    fn request_initial_tree(&mut self) -> Option<TreeUpdate> {
        self.0.activated.fetch_add(1, Ordering::SeqCst);
        None
    }
}
impl ActionHandler for Counts {
    fn do_action(&mut self, _: ActionRequest) {}
}
impl DeactivationHandler for Counts {
    fn deactivate_accessibility(&mut self) {
        self.0.deactivated.fetch_add(1, Ordering::SeqCst);
    }
}

struct StatusIface {
    is_enabled: bool,
}
#[zbus::interface(name = "org.a11y.Status")]
impl StatusIface {
    #[zbus(property)]
    fn is_enabled(&self) -> bool {
        self.is_enabled
    }
    #[zbus(property)]
    fn set_is_enabled(&mut self, value: bool) {
        self.is_enabled = value;
    }
    #[zbus(property)]
    fn screen_reader_enabled(&self) -> bool {
        self.is_enabled
    }
    #[zbus(property)]
    fn set_screen_reader_enabled(&mut self, value: bool) {
        self.is_enabled = value;
    }
}

struct BusAddress(String);
#[zbus::interface(name = "org.a11y.Bus")]
impl BusAddress {
    fn get_address(&self) -> String {
        self.0.clone()
    }
}

struct Registry;
#[zbus::interface(name = "org.a11y.atspi.Socket")]
impl Registry {
    fn embed(&self, _plug: (String, OwnedObjectPath)) -> (String, OwnedObjectPath) {
        (
            ":1.1".to_string(),
            "/org/a11y/atspi/accessible/root".try_into().unwrap(),
        )
    }
}

async fn serve(initial_enabled: bool, replace_names: bool) -> zbus::Result<()> {
    let address = env::var("DBUS_SESSION_BUS_ADDRESS").expect("session bus address");
    let conn = AsyncBuilder::session()?
        .allow_name_replacements(true)
        .replace_existing_names(replace_names)
        .name(SERVICE)?
        .name("org.a11y.atspi.Registry")?
        .serve_at(
            PATH,
            StatusIface {
                is_enabled: initial_enabled,
            },
        )?
        .serve_at("/org/a11y/atspi/accessible/root", Registry)?
        .serve_at(PATH, BusAddress(address))?
        .build()
        .await?;
    println!("SERVICE_READY unique={:?}", conn.unique_name());
    std::future::pending::<()>().await;
    Ok(())
}

async fn watch_owner_properties(
    session: zbus::Connection,
    owner: String,
    sender: tokio::sync::mpsc::UnboundedSender<(String, bool)>,
) {
    let run = async {
        let proxy = zbus::Proxy::new(&session, owner.as_str(), PATH, STATUS).await?;
        let mut changes = proxy.receive_property_changed::<bool>("IsEnabled").await;
        while let Some(change) = changes.next().await {
            let enabled = change.get().await?;
            sender
                .send((owner.clone(), enabled))
                .map_err(|_| zbus::Error::Failure("state receiver dropped".into()))?;
        }
        Ok::<(), zbus::Error>(())
    };
    if let Err(error) = run.await {
        eprintln!("STATUS_OWNER_WATCH_FAILED owner={owner} error={error}");
    }
}

async fn name_owner_monitor(
    sender: tokio::sync::mpsc::UnboundedSender<Option<bool>>,
) -> zbus::Result<()> {
    let session = zbus::Connection::session().await?;
    let dbus = DBusProxy::new(&session).await?;
    // Install the match before the initial owner query, so a concurrent
    // appearance is either observed by the query or retained as a signal.
    let mut owners = dbus
        .receive_name_owner_changed_with_args(&[(0, SERVICE)])
        .await?;
    let (values_tx, mut values_rx) = tokio::sync::mpsc::unbounded_channel::<(String, bool)>();
    let mut watcher: Option<tokio::task::JoinHandle<()>> = None;
    let well_known_name: zbus::names::BusName<'static> =
        SERVICE.try_into().expect("valid fixed bus name");
    let mut current = match dbus.get_name_owner(well_known_name).await {
        Ok(owner) => Some(owner.to_string()),
        Err(zbus::fdo::Error::NameHasNoOwner(_)) => None,
        Err(error) => return Err(error.into()),
    };
    if let Some(owner) = current.clone() {
        watcher = Some(tokio::spawn(watch_owner_properties(
            session.clone(),
            owner,
            values_tx.clone(),
        )));
    }
    loop {
        tokio::select! {
            signal = owners.next() => {
                let Some(signal) = signal else { return Ok(()); };
                let Ok(args) = signal.args() else { continue; };
                let old_owner = args.old_owner().as_ref().map(|owner| owner.to_string());
                let new_owner = args.new_owner().as_ref().map(|owner| owner.to_string());
                // The initial snapshot and subscription overlap by design.
                // If the queued signal's predecessor is not our current owner,
                // reconcile to a fresh bus snapshot rather than transiently
                // publishing an obsolete owner from that queue.
                let next_owner = if old_owner == current {
                    new_owner
                } else {
                    match dbus.get_name_owner(SERVICE.try_into().expect("valid fixed bus name")).await {
                        Ok(owner) => Some(owner.to_string()),
                        Err(zbus::fdo::Error::NameHasNoOwner(_)) => None,
                        Err(error) => return Err(error.into()),
                    }
                };
                if next_owner == current { continue; }
                if let Some(watcher) = watcher.take() { watcher.abort(); }
                if current.is_some() {
                    let _ = sender.send(None);
                }
                current = next_owner;
                if let Some(owner) = current.clone() {
                    watcher = Some(tokio::spawn(watch_owner_properties(session.clone(), owner, values_tx.clone())));
                }
            }
            value = values_rx.recv() => {
                if let Some((owner, enabled)) = value {
                    // A property event may already be queued when replacement
                    // cancels its task. Never let that old owner's state cross
                    // the ownership boundary.
                    if current.as_deref() == Some(owner.as_str()) {
                        let _ = sender.send(Some(enabled));
                    }
                }
            }
        }
    }
}

async fn expect_state(
    receiver: &mut tokio::sync::mpsc::UnboundedReceiver<Option<bool>>,
    expected: Option<bool>,
) -> Result<(), String> {
    let value = tokio::time::timeout(Duration::from_secs(5), receiver.recv())
        .await
        .map_err(|_| format!("timed out waiting for status {expected:?}"))?
        .ok_or_else(|| "status monitor ended".to_string())?;
    if value != expected {
        return Err(format!(
            "status mismatch: expected {expected:?}, received {value:?}"
        ));
    }
    println!("PROTOTYPE_STATUS {value:?}");
    Ok(())
}

async fn set_enabled(enabled: bool) -> Result<(), String> {
    let session = zbus::Connection::session()
        .await
        .map_err(|e| e.to_string())?;
    let proxy = zbus::Proxy::new(&session, SERVICE, PATH, STATUS)
        .await
        .map_err(|e| e.to_string())?;
    proxy
        .set_property("IsEnabled", &enabled)
        .await
        .map_err(|e| e.to_string())
}

async fn set_enabled_for_owner(owner: &str, enabled: bool) -> Result<(), String> {
    let session = zbus::Connection::session()
        .await
        .map_err(|e| e.to_string())?;
    let proxy = zbus::Proxy::new(&session, owner, PATH, STATUS)
        .await
        .map_err(|e| e.to_string())?;
    proxy
        .set_property("IsEnabled", &enabled)
        .await
        .map_err(|e| e.to_string())
}

async fn run_reconnect_prototype(mode: &str) -> Result<(), String> {
    let late = mode == "prototype-late";
    let late_true = mode == "prototype-late-true";
    let initial_true = mode == "prototype-initial-true";
    let replacement = mode == "prototype-replacement";
    if !(late || late_true || initial_true || replacement || mode == "prototype-control") {
        return Err(format!("unknown prototype mode {mode:?}"));
    }
    let initially_enabled = late_true || initial_true;
    let mut child = None;
    if !(late || late_true) {
        child = Some(
            Command::new(env::current_exe().map_err(|e| e.to_string())?)
                .arg("serve")
                .arg(if initially_enabled { "true" } else { "false" })
                .spawn()
                .map_err(|e| e.to_string())?,
        );
        let session = zbus::Connection::session()
            .await
            .map_err(|e| e.to_string())?;
        let dbus = DBusProxy::new(&session).await.map_err(|e| e.to_string())?;
        tokio::time::timeout(Duration::from_secs(5), async {
            loop {
                if dbus
                    .get_name_owner(SERVICE.try_into().expect("valid fixed bus name"))
                    .await
                    .is_ok()
                {
                    break;
                }
                tokio::time::sleep(Duration::from_millis(10)).await;
            }
        })
        .await
        .map_err(|_| "preexisting service did not start".to_string())?;
    }
    let (sender, mut receiver) = tokio::sync::mpsc::unbounded_channel::<Option<bool>>();
    let monitor = tokio::spawn(name_owner_monitor(sender));
    if late || late_true {
        tokio::time::sleep(Duration::from_secs(2)).await;
        println!("PROTOTYPE_STATUS_ABSENT_FOR_2S");
        child = Some(
            Command::new(env::current_exe().map_err(|e| e.to_string())?)
                .arg("serve")
                .arg(if late_true { "true" } else { "false" })
                .spawn()
                .map_err(|e| e.to_string())?,
        );
    }
    let initial = initially_enabled;
    expect_state(&mut receiver, Some(initial)).await?;
    println!("INITIAL_STATUS_OBSERVED value={initial}");
    if initial {
        set_enabled(false).await?;
        expect_state(&mut receiver, Some(false)).await?;
    }
    set_enabled(true).await?;
    expect_state(&mut receiver, Some(true)).await?;
    set_enabled(false).await?;
    expect_state(&mut receiver, Some(false)).await?;
    set_enabled(true).await?;
    expect_state(&mut receiver, Some(true)).await?;

    if replacement {
        // Replace the active owner while both service processes overlap. The
        // status monitor must retire old-owner state before accepting the new
        // owner's initial property, then ignore messages already queued from
        // the previous unique owner.
        let session = zbus::Connection::session()
            .await
            .map_err(|e| e.to_string())?;
        let dbus = DBusProxy::new(&session).await.map_err(|e| e.to_string())?;
        let old_owner = dbus
            .get_name_owner(SERVICE.try_into().expect("valid fixed bus name"))
            .await
            .map_err(|e| format!("query old owner: {e}"))?
            .to_string();
        let replacer = Command::new(env::current_exe().map_err(|e| e.to_string())?)
            .arg("serve")
            .arg("false")
            .arg("replace")
            .spawn()
            .map_err(|e| e.to_string())?;
        expect_state(&mut receiver, None).await?;
        expect_state(&mut receiver, Some(false)).await?;
        // The old connection remains alive after losing the well-known name.
        // Its unique-name proxy may still emit properties, but those events
        // must not leak into the new owner's state.
        set_enabled_for_owner(&old_owner, true).await?;
        if tokio::time::timeout(Duration::from_millis(250), receiver.recv())
            .await
            .is_ok()
        {
            return Err("old unique owner state crossed replacement boundary".to_string());
        }
        set_enabled(true).await?;
        expect_state(&mut receiver, Some(true)).await?;
        let mut old = child.take().ok_or("missing old service")?;
        old.kill().map_err(|e| e.to_string())?;
        old.wait().map_err(|e| e.to_string())?;
        if tokio::time::timeout(Duration::from_millis(250), receiver.recv())
            .await
            .is_ok()
        {
            return Err("old owner emitted state after replacement".to_string());
        }
        let mut replacer = replacer;
        replacer.kill().map_err(|e| e.to_string())?;
        replacer.wait().map_err(|e| e.to_string())?;
        expect_state(&mut receiver, None).await?;
    } else {
        if let Some(mut child) = child.take() {
            child.kill().map_err(|e| e.to_string())?;
            child.wait().map_err(|e| e.to_string())?;
            expect_state(&mut receiver, None).await?;
        }
        let restarted = Command::new(env::current_exe().map_err(|e| e.to_string())?)
            .arg("serve")
            .arg("false")
            .spawn()
            .map_err(|e| e.to_string())?;
        expect_state(&mut receiver, Some(false)).await?;
        set_enabled(true).await?;
        expect_state(&mut receiver, Some(true)).await?;
        let mut restarted = restarted;
        restarted.kill().map_err(|e| e.to_string())?;
        restarted.wait().map_err(|e| e.to_string())?;
        expect_state(&mut receiver, None).await?;
    }
    monitor.abort();
    println!("PROTOTYPE_RECOVERED mode={mode}");
    Ok(())
}

fn wait_until(
    label: &str,
    timeout: Duration,
    mut ready: impl FnMut() -> bool,
) -> Result<(), String> {
    let until = Instant::now() + timeout;
    while Instant::now() < until {
        if ready() {
            return Ok(());
        }
        thread::sleep(Duration::from_millis(10));
    }
    Err(format!("timed out waiting for {label}"))
}
fn name_has_owner(session: &zbus::blocking::Connection, name: &str) -> zbus::Result<bool> {
    let dbus = Proxy::new(
        session,
        "org.freedesktop.DBus",
        "/org/freedesktop/DBus",
        "org.freedesktop.DBus",
    )?;
    dbus.call("NameHasOwner", &(name,))
}

fn main_probe(mode: &str) -> Result<(), String> {
    let late = mode == "late";
    let failed_connect = mode == "failed-connect";
    if !(late || failed_connect || mode == "control") {
        return Err(format!(
            "unknown mode {mode:?}; use control, late, or failed-connect"
        ));
    }
    let mut child: Option<Child> = None;
    if mode == "control" {
        child = Some(
            Command::new(env::current_exe().map_err(|e| e.to_string())?)
                .arg("serve")
                .spawn()
                .map_err(|e| format!("spawn service: {e}"))?,
        );
        let session = BlockingBuilder::session()
            .map_err(|e| format!("connect session: {e}"))?
            .build()
            .map_err(|e| format!("build session: {e}"))?;
        wait_until("preexisting status service", Duration::from_secs(5), || {
            name_has_owner(&session, SERVICE).is_ok_and(|owner| owner)
        })?;
        println!("SERVICE_PREEXISTED");
    }
    let session = BlockingBuilder::session()
        .map_err(|e| format!("connect session: {e}"))?
        .build()
        .map_err(|e| format!("build session: {e}"))?;
    if late || failed_connect {
        if name_has_owner(&session, SERVICE)
            .map_err(|e| format!("pre-adapter NameHasOwner: {e}"))?
        {
            return Err(
                "late case unexpectedly has org.a11y.Bus before adapter construction".to_string(),
            );
        }
        println!("STATUS_ABSENT_BEFORE_ADAPTER mode={mode}");
    }
    let valid_bus_address = env::var("DBUS_SESSION_BUS_ADDRESS").map_err(|e| e.to_string())?;
    if failed_connect {
        env::set_var(
            "DBUS_SESSION_BUS_ADDRESS",
            "unix:path=/tmp/gpui-no-such-session-bus",
        );
        println!("SESSION_CONNECT_INVALID_BEFORE_ADAPTER");
    }
    let counts = Arc::new(CountsInner {
        activated: AtomicUsize::new(0),
        deactivated: AtomicUsize::new(0),
    });
    let _adapter = Adapter::new(
        Counts(Arc::clone(&counts)),
        Counts(Arc::clone(&counts)),
        Counts(Arc::clone(&counts)),
    );
    println!("ADAPTER_READY mode={mode}");
    if late || failed_connect {
        // Leave time for AccessKit Unix to create its status proxy/cache while
        // the well-known service genuinely has no owner. For failed-connect,
        // the adapter thread also tries (and fails) to connect to the session bus.
        thread::sleep(Duration::from_secs(2));
        if failed_connect {
            env::set_var("DBUS_SESSION_BUS_ADDRESS", &valid_bus_address);
            println!("SESSION_ADDRESS_RESTORED");
        }
        if name_has_owner(&session, SERVICE).map_err(|e| format!("settled NameHasOwner: {e}"))? {
            return Err("late case unexpectedly has org.a11y.Bus before late start".to_string());
        }
        println!("STATUS_STILL_ABSENT_AFTER_2S mode={mode}");
    }
    if late || failed_connect {
        child = Some(
            Command::new(env::current_exe().map_err(|e| e.to_string())?)
                .arg("serve")
                .spawn()
                .map_err(|e| format!("spawn service: {e}"))?,
        );
    }
    wait_until("status service owner", Duration::from_secs(5), || {
        name_has_owner(&session, SERVICE).is_ok_and(|owner| owner)
    })?;
    let status =
        Proxy::new(&session, SERVICE, PATH, STATUS).map_err(|e| format!("status proxy: {e}"))?;
    let initial: bool = status
        .get_property("IsEnabled")
        .map_err(|e| format!("status GetAll/property: {e}"))?;
    if initial {
        return Err("mock status service must start disabled".to_string());
    }
    println!("STATUS_PRESENT mode={mode}");
    status
        .set_property("IsEnabled", true)
        .map_err(|e| format!("enable: {e}"))?;
    match wait_until("activation", Duration::from_secs(5), || {
        counts.activated.load(Ordering::SeqCst) == 1
    }) {
        Ok(()) => println!("ACTIVATED mode={mode}"),
        Err(e) => {
            println!(
                "ACTIVATION_MISSED mode={mode} activated={} deactivated={}",
                counts.activated.load(Ordering::SeqCst),
                counts.deactivated.load(Ordering::SeqCst)
            );
            if let Some(mut child) = child {
                let _ = child.kill();
                let _ = child.wait();
            }
            return Err(e);
        }
    }
    status
        .set_property("IsEnabled", false)
        .map_err(|e| format!("disable: {e}"))?;
    wait_until("deactivation", Duration::from_secs(5), || {
        counts.deactivated.load(Ordering::SeqCst) == 1
    })?;
    println!("DEACTIVATED mode={mode}");
    status
        .set_property("IsEnabled", true)
        .map_err(|e| format!("reenable: {e}"))?;
    wait_until("second activation", Duration::from_secs(5), || {
        counts.activated.load(Ordering::SeqCst) == 2
    })?;
    println!("REACTIVATED mode={mode}");
    if let Some(mut child) = child {
        let _ = child.kill();
        let _ = child.wait();
    }
    Ok(())
}

fn main() {
    let args = env::args().collect::<Vec<_>>();
    if args.get(1).is_some_and(|arg| arg == "serve") {
        let initial_enabled = args.get(2).is_some_and(|arg| arg == "true");
        let replace_names = args.get(3).is_some_and(|arg| arg == "replace");
        tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(serve(initial_enabled, replace_names))
            .unwrap();
        return;
    }
    if args.get(1).is_some_and(|arg| arg.starts_with("prototype-")) {
        let mode = args.get(1).map(String::as_str).unwrap_or_default();
        let result = tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(run_reconnect_prototype(mode));
        if let Err(error) = result {
            eprintln!("PROTOTYPE_FAILED: {error}");
            std::process::exit(2);
        }
        return;
    }
    let mode = args.get(1).map(String::as_str).unwrap_or("control");
    if let Err(error) = main_probe(mode) {
        eprintln!("PROBE_FAILED mode={mode}: {error}");
        std::process::exit(1);
    }
}
