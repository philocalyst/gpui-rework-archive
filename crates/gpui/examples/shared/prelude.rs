//! Minimal shared startup for standalone GPUI examples.

#![allow(dead_code)]

use gpui::{
    App, AssetSource, Bounds, Entity, KeyBinding, Menu, MenuItem, Pixels, Render, SharedString,
    Size, TitlebarOptions, Window, WindowBounds, WindowOptions, actions,
};
use std::sync::Arc;

#[path = "fonts.rs"]
mod fonts;

actions!(example, [Quit]);

/// Adds the shared font fixtures, Quit shortcut, menu, and final-window behavior.
pub fn init_example(cx: &mut App, name: impl Into<SharedString>) {
    assert!(fonts::load_fonts(cx), "register example fonts");
    cx.activate(true);
    cx.on_action(|_: &Quit, cx| cx.quit());
    cx.bind_keys([KeyBinding::new("cmd-q", Quit, None)]);
    cx.set_menus(vec![Menu {
        name: name.into(),
        items: vec![MenuItem::action("Quit", Quit)],
        disabled: false,
    }]);
    cx.on_window_closed(|cx, _| {
        if cx.windows().is_empty() {
            cx.quit();
        }
    })
    .detach();
}

/// Opens one centered native window using the example's view factory.
pub fn run_example<V: Render + 'static>(
    title: impl Into<SharedString>,
    viewport: Size<Pixels>,
    factory: impl Fn(&mut Window, &mut App) -> Entity<V> + 'static,
) {
    run_example_with_assets(title, viewport, Arc::new(()), factory);
}

/// Opens a native example window with its app-specific asset source.
pub fn run_example_with_assets<V: Render + 'static>(
    title: impl Into<SharedString>,
    viewport: Size<Pixels>,
    assets: Arc<dyn AssetSource>,
    factory: impl Fn(&mut Window, &mut App) -> Entity<V> + 'static,
) {
    let title = title.into();
    gpui_platform::application()
        .with_assets(assets)
        .run(move |cx: &mut App| {
            init_example(cx, title.clone());
            let options = centered_window(viewport, cx).titlebar(Some(TitlebarOptions {
                title: Some(title),
                ..Default::default()
            }));
            cx.open_window(options, factory)
                .expect("open example window");
        });
}

/// Builds the standard centered, windowed options used by most examples.
pub fn centered_window(viewport: Size<Pixels>, cx: &App) -> WindowOptions {
    let bounds = Bounds::centered(None, viewport, cx);
    WindowOptions::new().window_bounds(Some(WindowBounds::Windowed(bounds)))
}
