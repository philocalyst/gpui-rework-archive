//! Test-only service/registry transport. NativeAdapter, GPUI owner, projection,
//! Accessible/EditableText/Action methods and acknowledged UI remain real.
use super::*;
use std::sync::{Arc, Mutex};

struct Status {
    is_enabled: bool,
}
#[zbus::interface(name = "org.a11y.Status")]
impl Status {
    #[zbus(property)]
    fn is_enabled(&self) -> bool {
        self.is_enabled
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
struct Socket(Arc<Mutex<Vec<Address>>>);
#[zbus::interface(name = "org.a11y.atspi.Socket")]
impl Socket {
    fn embed(&self, plug: Address, #[zbus(connection)] conn: &zbus::Connection) -> Address {
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

async fn service(address: &str, replace: bool) -> zbus::Result<Connection> {
    Builder::session()
        .allow_name_replacements(true)
        .replace_existing_names(replace)
        .name("org.a11y.Bus")
        .serve_at("/org/a11y/bus", Status { is_enabled: true })
        .serve_at("/org/a11y/bus", BusAddress(address.to_owned()))
        .build()
        .await
}
pub(super) struct Fixture {
    registry: Connection,
    old_service: Connection,
    replacement: Option<Connection>,
    address: String,
}
impl Fixture {
    pub(super) async fn start(session: &Connection) -> zbus::Result<Self> {
        let dbus = Proxy::new(
            session,
            "org.freedesktop.DBus",
            "/org/freedesktop/DBus",
            "org.freedesktop.DBus",
        )
        .await?;
        assert!(
            !dbus
                .call::<_, _, bool>("NameHasOwner", &("org.a11y.Bus",))
                .await?,
            "lifecycle proof requires initially absent org.a11y.Bus"
        );
        let address = std::env::var("DBUS_SESSION_BUS_ADDRESS").unwrap();
        let roots = Arc::new(Mutex::new(Vec::new()));
        let registry = Builder::session()
            .name("org.a11y.atspi.Registry")
            .serve_at("/org/a11y/atspi/accessible/root", Socket(roots.clone()))
            .serve_at("/org/a11y/atspi/accessible/root", Desktop(roots))
            .build()
            .await?;
        // NativeHost has already presented while the status service was absent.
        // Initial true needs no later IsEnabled edge to trigger activation.
        let old_service = service(&address, false).await?;
        eprintln!("GPUI_NATIVE_LIFECYCLE late service initial=true");
        Ok(Self {
            registry,
            old_service,
            replacement: None,
            address,
        })
    }
    pub(super) async fn replace(&mut self) -> zbus::Result<()> {
        self.replacement = Some(service(&self.address, true).await?);
        eprintln!(
            "GPUI_NATIVE_LIFECYCLE replaced enabled owner; old unique owner remains connected"
        );
        Ok(())
    }
    pub(super) async fn close(self) -> zbus::Result<()> {
        if let Some(replacement) = self.replacement {
            replacement.close().await?;
        }
        self.old_service.close().await?;
        self.registry.close().await?;
        Ok(())
    }
    pub(super) async fn stale_old_properties(&self, session: &Connection) -> zbus::Result<()> {
        let proxy = Proxy::new(
            session,
            self.old_service.unique_name().unwrap().as_str(),
            "/org/a11y/bus",
            "org.a11y.Status",
        )
        .await?;
        proxy.set_property("IsEnabled", false).await?;
        proxy.set_property("IsEnabled", true).await?;
        Ok(())
    }
}
