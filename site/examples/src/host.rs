//! Connect the documentation's DOM editor to the GPUI preview controller.

use gpui::{App, AppContext, Context, Entity, Render, Subscription, Window};
use gpui_ce_codepen::Codepen;
use serde::Deserialize;
use wasm_bindgen::{JsCast, closure::Closure};

/// The host revision identifies the source displayed by the DOM editor. The
/// controller has its own generation for source, input and animation requests.
#[derive(Deserialize)]
struct Command {
    #[serde(rename = "type")]
    kind: String,
    command: String,
    revision: u64,
    source: Option<String>,
    enabled: Option<bool>,
}

struct Listener {
    window: web_sys::Window,
    callback: Closure<dyn FnMut(web_sys::MessageEvent)>,
}

impl Drop for Listener {
    fn drop(&mut self) {
        let _ = self
            .window
            .remove_event_listener_with_callback("message", self.callback.as_ref().unchecked_ref());
    }
}

struct Host {
    preview: Entity<Codepen>,
    revision: u64,
    edited: bool,
    parent: web_sys::Window,
    origin: String,
    _listener: Listener,
    _changed: Subscription,
}

impl Host {
    fn new(source: &str, cx: &mut Context<Self>) -> Self {
        let browser = web_sys::window().expect("browser preview window");
        let parent = browser
            .parent()
            .expect("preview parent")
            .expect("parent window");
        let origin = browser.location().origin().expect("preview origin");
        let preview = cx.new(|cx| {
            let mut preview = Codepen::preview_only(source, cx);
            preview.set_auto_run(false, cx);
            preview
        });
        let changed = cx.observe(&preview, |host, _, cx| host.send_status(cx));
        let weak = cx.weak_entity();
        let app = cx.to_async();
        let expected_origin = origin.clone();
        let expected_parent = parent.clone();
        let callback = Closure::wrap(Box::new(move |event: web_sys::MessageEvent| {
            if event.origin() != expected_origin
                || event.source().as_ref().map(|value| value.as_ref())
                    != Some(expected_parent.as_ref())
            {
                return;
            }
            let Ok(json) = js_sys::JSON::stringify(&event.data()) else {
                return;
            };
            let Some(json) = json.as_string() else { return };
            if json.len() > 70000 {
                return;
            }
            let Ok(command) = serde_json::from_str::<Command>(&json) else {
                return;
            };
            if command.kind != "gpui-workbench-command" {
                return;
            }
            app.update(|cx| {
                let _ = weak.update(cx, |host, cx| host.receive(command, cx));
            });
        }) as Box<dyn FnMut(web_sys::MessageEvent)>);
        browser
            .add_event_listener_with_callback("message", callback.as_ref().unchecked_ref())
            .expect("listen for workbench commands");
        let ready = serde_json::json!({ "type": "gpui-workbench-ready" });
        post(&parent, &origin, ready);
        Self {
            preview,
            revision: 0,
            edited: false,
            parent,
            origin,
            _listener: Listener {
                window: browser,
                callback,
            },
            _changed: changed,
        }
    }

    fn receive(&mut self, command: Command, cx: &mut Context<Self>) {
        if command.revision < self.revision {
            return;
        }
        match command.command.as_str() {
            "source" => {
                let Some(source) = command.source else { return };
                if source.len() > 65536 {
                    return;
                }
                self.revision = command.revision;
                self.edited = true;
                self.preview
                    .update(cx, |preview, cx| preview.edit_source(&source, cx));
            }
            "run" if command.revision == self.revision => {
                self.edited = false;
                self.preview.update(cx, |preview, cx| preview.run(cx));
            }
            "reset" if command.revision == self.revision => {
                self.edited = false;
                self.preview.update(cx, |preview, cx| preview.reset(cx));
            }
            "auto" => {
                let Some(enabled) = command.enabled else {
                    return;
                };
                self.preview
                    .update(cx, |preview, cx| preview.set_auto_run(enabled, cx));
            }
            _ => return,
        }
        self.send_status(cx);
    }

    fn send_status(&self, cx: &App) {
        let state = self.preview.read(cx).status();
        let phase = if state.running {
            "running"
        } else if self.edited {
            "edited"
        } else if !state.diagnostics.is_empty() {
            "error"
        } else if state.has_preview {
            "live"
        } else {
            "ready"
        };
        post(
            &self.parent,
            &self.origin,
            serde_json::json!({
                "type": "gpui-workbench-status",
                "revision": self.revision,
                "phase": phase,
                "diagnostics": state.diagnostics,
                "elapsed_ms": state.elapsed_ms,
                // The controller currently uses the development companion. Replace
                // this only when the browser Worker actually owns the interpreter.
                "backend": "miri-native",
                "has_frame": state.has_preview,
            }),
        );
    }
}

impl Render for Host {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl gpui::IntoElement {
        self.preview.clone()
    }
}

fn post(parent: &web_sys::Window, origin: &str, message: serde_json::Value) {
    if let Ok(value) = js_sys::JSON::parse(&message.to_string()) {
        let _ = parent.post_message(&value, origin);
    }
}

pub fn run(slug: &str) {
    let Some(source) = super::components::source(slug) else {
        if let Some(window) = web_sys::window() {
            if let Ok(Some(parent)) = window.parent() {
                let origin = window.location().origin().unwrap_or_default();
                post(
                    &parent,
                    &origin,
                    serde_json::json!({
                        "type": "gpui-preview-error",
                        "message": "Unknown walkthrough component.",
                    }),
                );
            }
        }
        return;
    };
    super::support::run(move |_, cx| cx.new(|cx| Host::new(source, cx)));
}
