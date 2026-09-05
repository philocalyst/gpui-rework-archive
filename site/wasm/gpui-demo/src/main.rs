use std::{borrow::Cow, cell::RefCell, rc::Rc, sync::Arc};

use gpui::{
    App, Application, ApplicationHandle, Bounds, Context, Entity, IntoElement, Render, Window,
    WindowBounds, WindowOptions, div, prelude::*, px, rgb, size,
};
use wasm_bindgen::{JsCast, closure::Closure, prelude::JsValue};
use web_sys::MessageEvent;

thread_local! {
    static APPLICATION: RefCell<Option<ApplicationHandle>> = const { RefCell::new(None) };
    static COUNTER: RefCell<Option<Entity<Counter>>> = const { RefCell::new(None) };
}

struct Counter {
    count: i32,
}

impl Render for Counter {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        let graphite = rgb(0x17171f);
        let paper = rgb(0xe4e1ce);
        let acid = rgb(0xb9e450);
        let violet = rgb(0xa76ee8);

        div()
            .size_full()
            .flex()
            .flex_col()
            .bg(graphite)
            .text_color(paper)
            .font_family("IBM Plex Mono")
            .child(
                div()
                    .h(px(35.))
                    .flex()
                    .items_center()
                    .justify_between()
                    .px_3()
                    .border_b_1()
                    .border_color(acid)
                    .text_xs()
                    .text_color(acid)
                    .child("GPUI // LIVE ENTITY")
                    .child("GPU · WASM"),
            )
            .child(
                div()
                    .flex_1()
                    .flex()
                    .items_center()
                    .justify_center()
                    .gap_5()
                    .child(counter_button("decrement", "−", acid, graphite, _cx.listener(
                        |this, _, _, cx| {
                            this.count = this.count.saturating_sub(1).max(-99);
                            notify_parent("count", this.count);
                            cx.notify();
                        },
                    )))
                    .child(
                        div()
                            .min_w(px(118.))
                            .text_center()
                            .text_size(px(78.))
                            .font_weight(gpui::FontWeight::BOLD)
                            .text_color(violet)
                            .child(self.count.to_string()),
                    )
                    .child(counter_button("increment", "+", violet, graphite, _cx.listener(
                        |this, _, _, cx| {
                            this.count = this.count.saturating_add(1).min(99);
                            notify_parent("count", this.count);
                            cx.notify();
                        },
                    ))),
            )
    }
}

fn counter_button(
    id: &'static str,
    label: &'static str,
    color: gpui::Rgba,
    graphite: gpui::Rgba,
    listener: impl Fn(&gpui::ClickEvent, &mut Window, &mut App) + 'static,
) -> impl IntoElement {
    div()
        .id(id)
        .size(px(46.))
        .flex()
        .items_center()
        .justify_center()
        .border_1()
        .border_color(color)
        .text_color(color)
        .text_size(px(24.))
        .cursor_pointer()
        .child(label)
        .hover(move |style| style.bg(color).text_color(graphite))
        .on_click(listener)
}

fn notify_parent(kind: &str, count: i32) {
    let Some(window) = web_sys::window() else { return };
    let Ok(Some(parent)) = window.parent() else { return };
    let _ = parent.post_message(&JsValue::from_str(&format!("gpui-counter:{kind}:{count}")), "*");
}

fn install_counter_bridge() {
    let handler = Closure::<dyn FnMut(MessageEvent)>::new(|event: MessageEvent| {
        let Some(message) = event.data().as_string() else { return };
        if !message.starts_with("gpui-counter:") { return }

        let entity = COUNTER.with(|slot| slot.borrow().clone());
        let Some(entity) = entity else { return };
        let count = APPLICATION.with(|slot| {
            slot.borrow().as_ref().map(|application| {
                application.update(|cx| {
                    entity.update(cx, |counter, cx| {
                        if message == "gpui-counter:reset" {
                            counter.count = 0;
                        } else if let Some(delta) = message
                            .strip_prefix("gpui-counter:delta:")
                            .and_then(|value| value.parse::<i32>().ok())
                        {
                            counter.count = counter.count.saturating_add(delta).clamp(-99, 99);
                        }
                        cx.notify();
                        counter.count
                    })
                })
            })
        });
        if let Some(count) = count { notify_parent("count", count) }
    });

    if let Some(window) = web_sys::window() {
        let _ = window.add_event_listener_with_callback("message", handler.as_ref().unchecked_ref());
        handler.forget();
    }
}

fn main() {
    gpui_web::init_logging();
    install_counter_bridge();

    let platform = Rc::new(gpui_web::WebPlatform::new(false));
    let http_client = Arc::new(platform.fetch_http_client());
    let application = Application::with_platform(platform)
        .with_http_client(http_client)
        .run_embedded(|cx: &mut App| {
            if let Err(error) = cx.text_system().add_fonts(vec![Cow::Borrowed(include_bytes!(
                "../../../static/fonts/ibm-plex-mono-400.ttf"
            ))]) {
                web_sys::console::error_1(&format!("font load failed: {error:#}").into());
            }

            let bounds = Bounds::centered(None, size(px(560.), px(210.)), cx);
            cx.open_window(
                WindowOptions {
                    window_bounds: Some(WindowBounds::Windowed(bounds)),
                    ..Default::default()
                },
                |_, cx| {
                    let counter = cx.new(|_| Counter { count: 0 });
                    COUNTER.with(|slot| *slot.borrow_mut() = Some(counter.clone()));
                    notify_parent("ready", 0);
                    counter
                },
            )
            .expect("failed to open the GPUI counter");
            cx.activate(true);
        });

    APPLICATION.with(|slot| *slot.borrow_mut() = Some(application));
}
