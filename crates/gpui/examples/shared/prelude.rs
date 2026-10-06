//! Example Prelude
//!
//! Common helpers for GPUI examples. Import with:
//!
//! ```ignore
//! #[path = "../shared/prelude.rs"]
//! mod example_prelude;
//! use example_prelude::init_example;
//! ```

use gpui::{
    App, Bounds, KeyBinding, Menu, MenuItem, SharedString, WindowBounds, WindowOptions, actions,
    px, size,
};

actions!(example, [Quit, CloseWindow]);

/// Sets up common example boilerplate:
/// - Activates the application
/// - Sets up an app menu with the example name and a Quit action (cmd-q)
/// - Configures the app to quit when all windows are closed
pub fn init_example(cx: &mut App, name: impl Into<SharedString>) {
    #[cfg(not(target_family = "wasm"))]
    cx.text_system()
        .add_fonts(gpui_test::bundled_fonts())
        .expect("register bundled example fonts");

    // Bring the example window to the front
    cx.activate(true);

    // Define the quit action...
    cx.on_action(|_: &Quit, cx| cx.quit());
    // ...then bind it to cmd+q
    cx.bind_keys([KeyBinding::new("cmd-q", Quit, None)]);

    // Set up an app menu with the example name and a Quit action (cmd-q)
    cx.set_menus(vec![Menu {
        name: name.into(),
        items: vec![MenuItem::action("Quit", Quit)],
        disabled: false,
    }]);

    // Quit the app when all windows are closed
    cx.on_window_closed(|cx, _| {
        if cx.windows().is_empty() {
            cx.quit();
        }
    })
    .detach();
}

/// Build the standard centered, windowed options used by most visual examples.
/// Callers that demonstrate native window controls can start from this value and refine it.
#[allow(dead_code)]
pub fn centered_window(width: f32, height: f32, cx: &App) -> WindowOptions {
    let bounds = Bounds::centered(None, size(px(width), px(height)), cx);
    WindowOptions::new().window_bounds(Some(WindowBounds::Windowed(bounds)))
}
