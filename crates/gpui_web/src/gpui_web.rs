#![cfg(target_family = "wasm")]
//! Browser support for GPUI applications.
//!
//! This crate adapts browser event, window, display, keyboard, fetch, and dispatch APIs to GPUI's
//! platform traits. Most applications use the constructors re-exported by `gpui_ce_platform`;
//! the types here are useful when embedding GPUI into an existing browser runtime.
//!
//! The platform appends one canvas to the document body and supports one normal top-level GPUI
//! window. It does not create browser popup, dialog, or floating windows. Graphics setup is
//! asynchronous: open the GPUI window from the `Application::run` launch callback, which runs
//! after the browser has selected a graphics backend. [`WebBackendPreference::Auto`] tries WebGPU
//! first and WebGL2 second; a fixed preference is available when an application needs to choose.
//!
//! ```no_run
//! use gpui::{App, Bounds, WindowBounds, WindowOptions, px, size};
//! use gpui_platform::application;
//!
//! fn main() {
//!     gpui_platform::web_init();
//!     application().run(|cx: &mut App| {
//!         let bounds = Bounds::centered(None, size(px(640.), px(480.)), cx);
//!         cx.open_window(
//!             WindowOptions::new().window_bounds(Some(WindowBounds::Windowed(bounds))),
//!             |_, cx| cx.new(|_| ExampleView),
//!         ).expect("open browser window");
//!     });
//! }
//! # struct ExampleView;
//! # impl gpui::Render for ExampleView {
//! #     fn render(&mut self, _: &mut gpui::Window, _: &mut gpui::Context<Self>) -> impl gpui::IntoElement { gpui::div() }
//! # }
//! ```
//!
//! The browser text system starts without operating-system fonts. Register font bytes with
//! `cx.text_system().add_fonts(...)` before opening a window if the application needs predictable
//! typography. Fetch follows browser origin, CORS, redirect, and secure-context rules. Clipboard
//! reads use the asynchronous Clipboard API; clipboard access may be denied or unavailable by the
//! browser, and paste events can supply text directly during a user gesture.
//!
//! See [`WebPlatform`] for backend selection and the browser's window lifecycle, and
//! [`FetchHttpClient`] for HTTP response and redirect behavior.

mod dispatcher;
mod display;
mod events;
mod http_client;
mod ime_mirror;
mod keyboard;
mod logging;
mod platform;
mod window;

pub use dispatcher::WebDispatcher;
pub use display::WebDisplay;
pub use gpui_wgpu::WebBackendPreference;
pub use http_client::FetchHttpClient;
pub use keyboard::WebKeyboardLayout;
pub use logging::init_logging;
pub use platform::{WebPlatform, WebWindowError};
pub use window::WebWindow;
