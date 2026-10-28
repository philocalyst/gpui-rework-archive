use x11rb::{
    connection::Connection,
    protocol::xproto::{AtomEnum, ClientMessageEvent, ConnectionExt, EventMask},
};
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let (x, screen) = x11rb::connect(None)?;
    let root = x.setup().roots[screen].root;
    let protocols = x.intern_atom(false, b"WM_PROTOCOLS")?.reply()?.atom;
    let delete = x.intern_atom(false, b"WM_DELETE_WINDOW")?.reply()?.atom;
    for window in x.query_tree(root)?.reply()?.children {
        let name = x
            .get_property(false, window, AtomEnum::WM_NAME, AtomEnum::ANY, 0, 1024)?
            .reply()?
            .value;
        println!("{window} {:?}", String::from_utf8_lossy(&name));
        if name == b"GPUI canonical text native control" {
            println!(
                "attributes {:?}; protocols {:?}; delete {delete}",
                x.get_window_attributes(window)?.reply()?,
                x.get_property(false, window, protocols, AtomEnum::ANY, 0, 1024)?
                    .reply()?
            );
            x.send_event(
                false,
                window,
                EventMask::NO_EVENT,
                ClientMessageEvent::new(32, window, protocols, [delete, 0, 0, 0, 0]),
            )?
            .check()?;
            x.get_input_focus()?.reply()?;
            println!("checked close request sent");
        }
    }
    Ok(())
}
