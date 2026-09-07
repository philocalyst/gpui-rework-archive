//! The small amount of browser plumbing shared by every exhibit.
//!
//! An exhibit is an ordinary GPUI program. `exhibit` boots the web platform,
//! registers the field guide's fonts, opens the single window the browser
//! backend supports, and keeps the application handle alive. `report` posts a
//! `gpui-exhibit:<key>:<value>` message to the embedding page so the guide can
//! mirror state beside the canvas.
use std::{borrow::Cow, cell::RefCell, rc::Rc, sync::Arc};

use gpui::{App, Application, ApplicationHandle, Entity, Render, Window, WindowOptions};
use wasm_bindgen::prelude::JsValue;

thread_local! {
    static APPLICATION: RefCell<Option<ApplicationHandle>> = const { RefCell::new(None) };
}

/// Start GPUI in the browser and show the view returned by `build`.
pub fn exhibit<V: Render>(build: impl FnOnce(&mut Window, &mut App) -> Entity<V> + 'static) {
    gpui_web::init_logging();
    let platform = Rc::new(gpui_web::WebPlatform::new(false));
    let http_client = Arc::new(platform.fetch_http_client());
    let application = Application::with_platform(platform)
        .with_http_client(http_client)
        .run_embedded(move |cx: &mut App| {
            let fonts = vec![
                Cow::Borrowed(include_bytes!("../fonts/monaspace-neon-400.otf") as &[u8]),
                Cow::Borrowed(include_bytes!("../fonts/monaspace-neon-700.otf") as &[u8]),
                Cow::Borrowed(include_bytes!("../fonts/pilowlava.otf") as &[u8]),
            ];
            if let Err(error) = cx.text_system().add_fonts(fonts) {
                web_sys::console::error_1(&format!("font load failed: {error:#}").into());
            }
            cx.open_window(WindowOptions::default(), |window, cx| {
                let view = build(window, cx);
                report("ready", "1");
                view
            })
            .expect("failed to open the exhibit window");
            cx.activate(true);
        });
    APPLICATION.with(|slot| *slot.borrow_mut() = Some(application));
}

/// Tell the page that embeds this exhibit about a change worth showing.
pub fn report(key: &str, value: impl std::fmt::Display) {
    let Some(window) = web_sys::window() else { return };
    let Ok(Some(parent)) = window.parent() else { return };
    let _ = parent.post_message(&JsValue::from_str(&format!("gpui-exhibit:{key}:{value}")), "*");
}
