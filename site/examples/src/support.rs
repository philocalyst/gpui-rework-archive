//! Platform setup shared by the walkthroughs; each downloaded main.rs includes it.
use gpui::{App, Entity, Render, Window, WindowOptions};

pub fn run<V: Render>(build: impl FnOnce(&mut Window, &mut App) -> Entity<V> + 'static) {
    #[cfg(not(target_family = "wasm"))]
    gpui_platform::application().run(move |cx| {
        cx.on_window_closed(|cx, _| {
            if cx.windows().is_empty() {
                cx.quit();
            }
        })
        .detach();
        open(build, cx);
    });

    #[cfg(target_family = "wasm")]
    {
        use gpui::{Application, ApplicationHandle};
        use std::{cell::RefCell, rc::Rc, sync::Arc};
        thread_local! {
            static APPLICATION: RefCell<Option<ApplicationHandle>> = const { RefCell::new(None) };
        }
        gpui_web::init_logging();
        let platform = Rc::new(gpui_web::WebPlatform::new(false));
        let client = Arc::new(platform.fetch_http_client());
        let handle = Application::with_platform(platform)
            .with_http_client(client)
            .run_embedded(move |cx| {
                use std::borrow::Cow;
                cx.text_system()
                    .add_fonts(vec![Cow::Borrowed(include_bytes!(
                        "../../../assets/fonts/ibm-plex-sans/IBMPlexSans-Regular.ttf"
                    ) as &[u8])])
                    .expect("load the preview font");
                open(build, cx);
            });
        APPLICATION.with(|slot| *slot.borrow_mut() = Some(handle));
        if let Some(window) = web_sys::window() {
            if let Ok(Some(parent)) = window.parent() {
                let _ = parent
                    .post_message(&wasm_bindgen::JsValue::from_str("gpui-preview-ready"), "*");
            }
        }
    }
}

fn open<V: Render>(build: impl FnOnce(&mut Window, &mut App) -> Entity<V> + 'static, cx: &mut App) {
    cx.open_window(WindowOptions::default(), build)
        .expect("open the example window");
    cx.activate(true);
}
