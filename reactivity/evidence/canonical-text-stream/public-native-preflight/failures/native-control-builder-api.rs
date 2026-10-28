//! Public application, real Unix provider and X11 close; no private GPUI access.
use gpui::{
    Application, PresentedFrame, Remote, RendererKind, RendererPolicy, SendError, Window,
    prelude::*,
};
use std::{
    collections::VecDeque,
    sync::{Arc, Mutex, mpsc},
    thread,
    time::{Duration, Instant},
};
use x11rb::{
    connection::Connection as _,
    protocol::xproto::{AtomEnum, ClientMessageEvent, ConnectionExt as _, EventMask},
};
use zbus::{Connection, OwnedObjectPath, Proxy, connection::Builder};
use zruntime::{SharedRuntime, mpmc};

const TITLE: &str = "GPUI canonical text native control";
type Address = (String, OwnedObjectPath);
struct Document {
    value: Signal<String>,
    busy: Signal<bool>,
    rows: usize,
}
impl Document {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "document", |m| &m.value, |m| &mut m.value);
    const BUSY: Source<Self, bool> =
        Source::new(FieldId::new(2), "busy", |m| &m.busy, |m| &mut m.busy);
}
impl View for Document {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE).field(Self::BUSY)
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.value).name("document").w(400).h(240),
            column((0..self.rows).map(|_| {
                div().w(400).h(1).bg(if *self.busy {
                    Color::BLACK
                } else {
                    Color::WHITE
                })
            })),
        ))
    }
}

// Same test-only discovery service used by GPUI's existing Linux integration
// proof. All text/geometry/action responses come from the real Unix adapter.
struct Status;
#[zbus::interface(name = "org.a11y.Status")]
impl Status {
    #[zbus(property)]
    fn is_enabled(&self) -> bool {
        true
    }
}
struct BusAddress(String);
#[zbus::interface(name = "org.a11y.Bus")]
impl BusAddress {
    fn get_address(&self) -> &str {
        &self.0
    }
}
struct Socket(Arc<Mutex<Vec<Address>>>);
#[zbus::interface(name = "org.a11y.atspi.Socket")]
impl Socket {
    fn embed(&self, plug: Address, #[zbus(connection)] conn: &Connection) -> Address {
        *self.0.lock().unwrap() = vec![plug];
        (
            conn.unique_name().unwrap().to_string(),
            "/org/a11y/atspi/accessible/root".try_into().unwrap(),
        )
    }
}
struct Desktop(Arc<Mutex<Vec<Address>>>);
#[zbus::interface(name = "org.a11y.atspi.Accessible")]
impl Desktop {
    fn get_children(&self) -> Vec<Address> {
        self.0.lock().unwrap().clone()
    }
}
async fn proxy<'a>(
    bus: &Connection,
    address: &'a Address,
    interface: &'a str,
) -> zbus::Result<Proxy<'a>> {
    Proxy::new(bus, address.0.as_str(), address.1.as_str(), interface).await
}
async fn descendants(bus: &Connection, root: Address) -> zbus::Result<Vec<Address>> {
    let mut queue = VecDeque::from([root]);
    let mut result = Vec::new();
    while let Some(address) = queue.pop_front() {
        assert!(result.len() < 5000);
        let children: Vec<Address> = proxy(bus, &address, "org.a11y.atspi.Accessible")
            .await?
            .call("GetChildren", &())
            .await?;
        queue.extend(children);
        result.push(address);
    }
    Ok(result)
}
async fn find_input(bus: &Connection, desktop: &Address) -> zbus::Result<Option<Address>> {
    for address in descendants(bus, desktop.clone()).await? {
        if &address == desktop {
            continue;
        }
        let interfaces: Vec<String> = proxy(bus, &address, "org.a11y.atspi.Accessible")
            .await?
            .call("GetInterfaces", &())
            .await?;
        if interfaces
            .iter()
            .any(|name| name == "org.a11y.atspi.EditableText")
        {
            return Ok(Some(address));
        }
    }
    Ok(None)
}
fn close_window() -> Result<(), Box<dyn std::error::Error>> {
    let (x, screen) = x11rb::connect(None)?;
    let root = x.setup().roots[screen].root;
    let window = x
        .query_tree(root)?
        .reply()?
        .children
        .into_iter()
        .find(|&window| {
            x.get_property(false, window, AtomEnum::WM_NAME, AtomEnum::ANY, 0, 1024)
                .ok()
                .and_then(|request| request.reply().ok())
                .is_some_and(|property| property.value == TITLE.as_bytes())
        })
        .ok_or("native X11 window missing")?;
    let protocols = x.intern_atom(false, b"WM_PROTOCOLS")?.reply()?.atom;
    let delete = x.intern_atom(false, b"WM_DELETE_WINDOW")?.reply()?.atom;
    x.send_event(
        false,
        window,
        EventMask::NO_EVENT,
        ClientMessageEvent::new(32, window, protocols, [delete, 0, 0, 0, 0]),
    )?;
    x.flush()?;
    Ok(())
}
async fn frame_after(
    frames: &mpmc::Receiver<PresentedFrame>,
    previous: Option<u64>,
    log: &mut Vec<(u64, u64)>,
) -> PresentedFrame {
    loop {
        let frame = frames.recv().await.unwrap();
        assert_eq!(frame.renderer, RendererKind::ReferenceCpu);
        assert_eq!(frame.source_epoch, frame.presentation_epoch);
        log.push((frame.source_epoch, frame.presentation_epoch));
        if previous.is_none_or(|previous| frame.source_epoch > previous) {
            return frame;
        }
    }
}
fn mix(sum: u64, value: u64) -> u64 {
    (sum ^ value).wrapping_mul(0x100000001b3)
}
async fn exercise(
    remote: &Remote<bool>,
    frames: &mpmc::Receiver<PresentedFrame>,
    ready: mpsc::SyncSender<()>,
    source: &str,
    busy: bool,
    count: usize,
    timed: bool,
) -> Result<serde_json::Value, Box<dyn std::error::Error>> {
    let runtime = SharedRuntime::current()?;
    let session = Builder::session()
        .method_timeout(Duration::from_secs(5))
        .build()
        .await?;
    let dbus = Proxy::new(
        &session,
        "org.freedesktop.DBus",
        "/org/freedesktop/DBus",
        "org.freedesktop.DBus",
    )
    .await?;
    assert!(
        !dbus
            .call::<_, _, bool>("NameHasOwner", &("org.a11y.Bus",))
            .await?,
        "requires private initially empty session bus"
    );
    let roots = Arc::new(Mutex::new(Vec::new()));
    let registry = Builder::session()
        .name("org.a11y.atspi.Registry")?
        .serve_at("/org/a11y/atspi/accessible/root", Socket(roots.clone()))?
        .serve_at("/org/a11y/atspi/accessible/root", Desktop(roots))?
        .build()
        .await?;
    let service = Builder::session()
        .name("org.a11y.Bus")?
        .serve_at("/org/a11y/bus", Status)?
        .serve_at(
            "/org/a11y/bus",
            BusAddress(std::env::var("DBUS_SESSION_BUS_ADDRESS")?),
        )?
        .build()
        .await?;
    ready.send(())?;
    let desktop = (
        "org.a11y.atspi.Registry".to_string(),
        "/org/a11y/atspi/accessible/root".try_into()?,
    );
    let mut log = Vec::with_capacity(count * 3 + 32);
    let mut frame = frame_after(frames, None, &mut log).await;
    let input = loop {
        if let Ok(Some(input)) = find_input(&session, &desktop).await {
            break input;
        }
        runtime.sleep(Duration::from_millis(10)).await;
    };
    let text = proxy(&session, &input, "org.a11y.atspi.Text").await?;
    assert_eq!(
        text.call::<_, _, String>("GetText", &(0i32, -1i32)).await?,
        source
    );
    let mut checksum = 1;
    // AT-SPI scalar offsets are externally checked independently of AccessKit's
    // internal source-grapheme indices; test two ordinary initial ASCII units.
    for offset in [0i32, 1] {
        let r: (i32, i32, i32, i32) = text.call("GetCharacterExtents", &(offset, 1u32)).await?;
        assert!(r.2 > 0 && r.3 > 0);
        let hit: i32 = text
            .call("GetOffsetAtPoint", &(r.0 + r.2 / 4, r.1 + r.3 / 2, 1u32))
            .await?;
        assert_eq!(hit, offset);
        for n in [offset, r.0, r.1, r.2, r.3] {
            checksum = mix(checksum, n as u64);
        }
    }
    let mut elapsed = Vec::with_capacity(count);
    for index in 0..count {
        let started = timed.then(Instant::now);
        if busy {
            remote.try_send(index % 2 == 0).unwrap();
            let next = frame_after(frames, Some(frame.source_epoch), &mut log).await;
            assert_eq!(next.source_epoch, frame.source_epoch + 1);
            frame = next;
        }
        let selection = if index % 2 == 0 {
            (0i32, 1i32)
        } else {
            (1i32, 2i32)
        };
        assert!(
            text.call::<_, _, bool>("SetSelection", &(0i32, selection.0, selection.1))
                .await?
        );
        let next = frame_after(frames, Some(frame.source_epoch), &mut log).await;
        assert_eq!(next.source_epoch, frame.source_epoch + 1);
        frame = next;
        // Completion includes the current native projection, beyond the
        // earlier host-submit ACK callback, rather than assuming they coincide.
        loop {
            let range: (i32, i32) = text.call("GetSelection", &(0i32,)).await?;
            if range == selection {
                break;
            }
        }
        if let Some(started) = started {
            elapsed.push(started.elapsed().as_nanos() as u64);
        }
        checksum = mix(mix(checksum, selection.0 as u64), selection.1 as u64);
    }
    assert_eq!(
        text.call::<_, _, String>("GetText", &(0i32, -1i32)).await?,
        source
    );
    // Queue ordinary work at real close; sender closure is checked after native
    // application teardown. Root's common cc74 close prerequisite is in both pins.
    remote.try_send(count % 2 == 0).unwrap();
    close_window()?;
    drop(text);
    drop(service);
    drop(registry);
    Ok(
        serde_json::json!({"busy":busy,"count":count,"checksum":checksum,"ack_epochs":log,"source_epoch_before_close":frame.source_epoch,"provider_completed_cycles":count,"elapsed_ns":elapsed}),
    )
}
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    assert_eq!(
        args.len(),
        4,
        "oracle|measure label|mixed|wrapped32k idle|busy COUNT"
    );
    let timed = match args[0].as_str() {
        "oracle" => false,
        "measure" => true,
        _ => panic!("mode"),
    };
    let value = match args[1].as_str() {
        "label" => "office café a\u{301} אבג".to_string(),
        "mixed" => "office abc אבג العربية\r\n".repeat(64),
        "wrapped32k" => "a".repeat(32768),
        _ => panic!("source"),
    };
    let busy = match args[2].as_str() {
        "idle" => false,
        "busy" => true,
        _ => panic!("load"),
    };
    let count: usize = args[3].parse()?;
    assert!((2..=10000).contains(&count));
    let (remote, inbox) = Remote::<bool>::bounded(1);
    let (send, frames) = mpmc::bounded((count * 3 + 32).try_into().unwrap());
    let (ready, go) = mpsc::sync_channel(1);
    let worker_value = value.clone();
    let late_sender = remote.clone();
    let worker = thread::spawn(move || {
        zbus::block_on(async {
            let runtime = SharedRuntime::current().unwrap();
            runtime
                .timeout_at(
                    Instant::now() + Duration::from_secs(60),
                    exercise(&remote, &frames, ready, &worker_value, busy, count, timed),
                )
                .await
                .unwrap()
                .map_err(|e| e.to_string())
        })
    });
    go.recv_timeout(Duration::from_secs(10))?;
    let app = Application::run_window(
        Window::document(Document {
            value: Signal::new(value),
            busy: Signal::new(false),
            rows: if busy { 256 } else { 0 },
        })
        .title(TITLE)
        .size(420, 260)
        .renderer(RendererPolicy::ReferenceCpu)
        .on_presented(move |frame| send.try_send(frame).unwrap())
        .on_presentation_error(|error| panic!("native presentation failed: {error}"))
        .with_inbox(inbox, |model, alternate| *model.busy = alternate),
    );
    let result = worker.join().map_err(|_| "native client panicked")??;
    app?;
    assert!(matches!(
        late_sender.try_send(true),
        Err(SendError::Closed(_))
    ));
    println!("{result}");
    Ok(())
}
