+++
title = "Application"
description = "The application owns the run loop, the windows, and the context where your interface begins."
weight = 6
aliases = ["/fundamentals/application.html"]
[extra]
category = "FUNDAMENTALS"
legacy_source = "gpui-ce-docs/build/html/fundamentals/application.html"
+++

**Application** is the pre-launch handle every GPUI program starts from. You configure it in `main`, then hand control to the platform with `run`. Open your first window inside the launch closure, because nothing after `run` executes until the app quits.

A **platform** is the trait object that talks to the OS. It opens windows, quits the process, and opens URLs. `Application` owns it before launch; `App` borrows it after launch.

```rust
fn main() {
    // application() picks the OS platform for you. No manual cfg needed.
    // with_assets installs fonts, images, and SVG rendering up front.
    // run blocks on the OS event loop, then calls your closure once.
    // Open your first window inside that closure. That is the whole startup.
    let app = gpui_platform::application()
        .with_assets(MyAssets);
    app.run(|cx: &mut App| {
        // WindowOptions::default gives a normal, visible, focused window.
        // build_root_view returns the Entity that owns the window content.
        cx.open_window(WindowOptions::default(), |window, cx| {
            cx.new(|cx| RootView::new(window, cx))
        }).unwrap();
    });
}
```

## Startup and launch

`Application` wraps an `Rc<AppCell>` and exposes builder methods only ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). `run` consumes it and blocks on the platform event loop ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).

- `Application::with_platform(platform)` builds an app from an explicit platform ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).
- `with_assets(source)` installs fonts, images, and SVG rendering ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).
- `with_quit_mode(mode)` sets auto-quit behavior before launch ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).
- `with_http_client(client)` installs the network client ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).
- `with_restart_arguments(args)` passes args through the next `restart` ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).
- `new_inaccessible(platform)` disables AccessKit, so `div().role()` silently no-ops ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).
- `run(on_finish_launching)` starts the loop, then calls your closure once ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).
- `run_embedded(on_finish_launching)` starts without blocking and returns an `ApplicationHandle` ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).

Embedders drive their own run loop, like a Wasm guest or a foreign host. The handle keeps the app alive, so hold it for as long as the app should run.

```rust
// run_embedded returns immediately. The handle owns the app now.
// handle.update re-enters the app whenever the host yields control.
// Never call update re-entrantly: the app is a RefCell and panics.
let handle: ApplicationHandle = app.run_embedded(|cx| {
    // Same launch closure as run. Open your first window here.
    cx.open_window(WindowOptions::default(), build_root).unwrap();
});
// Keep `handle` alive; call `handle.update(|cx| ...)` to re-enter.
```

> **Warning.** Never call `handle.update` from inside an update callback ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). The app state is a `RefCell`, so a double borrow panics. If you already hold `&mut App`, pass it down instead.

## App, contexts, and globals

`App` is the live application state. Every callback receives it as `&mut App` or `&App`. You never construct it directly.

A **global** is app-wide state stored by type. Any type that implements the empty marker trait `Global` can be stored. Only one value exists per type.

```rust
struct Settings { dark: bool } // one struct, one slot in the registry
impl Global for Settings {} // the marker trait unlocks set_global/global
// set_global stores the value and wakes every global observer.
cx.set_global(Settings { dark: true });
// global borrows it back. It panics when absent, so prefer try_global.
let dark = cx.global::<Settings>().dark;
```

|  |  |
| --- | --- |
| **Type** | **Responsibility** |
| `Application` | Pre-launch config and `run`. Owns the platform. |
| `App` | Live state: entities, globals, windows, effects. |
| `AsyncApp` | Weak handle for use across `await` points. |
| `Window` + `App` | Per-window state plus frame callbacks. |

Table 8: Who owns what while your app runs.

## Lifecycle: quit, restart, reopen

Quitting is platform-driven. `App::quit` asks the platform to quit ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). `App::shutdown` runs quit observers and clears windows synchronously ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).

Quit observers registered with `on_app_quit` get `SHUTDOWN_TIMEOUT` (200 ms) to finish on native builds ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). Wasm runs them as best-effort cleanup, because its event thread cannot block. When the OS asks to quit while `App` is already borrowed, the internal `on_quit` handler answers `false` and leaves the decision to the platform.

`QuitMode` controls auto-quit when windows close ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)):

- `Explicit` quits only via `App::quit`.
- `LastWindowClosed` quits when the last window closes.
- `Default` means `Explicit` on macOS and `LastWindowClosed` elsewhere.

```rust
// Pick your quit policy before run. Default splits by OS for you.
app.with_quit_mode(QuitMode::LastWindowClosed)
```

`App::restart` replays restart observers first, then relaunches with the stored path and args ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). Set them with `set_restart_path` ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)) and `with_restart_arguments` ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). `Application::on_reopen` registers the macOS dock-reopen handler ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). It holds the app weakly, so the callback quietly no-ops after the app drops.

> **Tip.** On macOS the OS keeps your app alive after `cmd-Q` is refused or the last window closes. Handle `on_reopen` so a dock click opens a fresh window.

```
launch -> run(closure) -> windows open -> last window closes
  -> QuitMode::Default: macOS stays alive, others quit
  -> App::quit -> shutdown(observers) -> platform quits
```

## Platform services: URLs and identity

`App::open_url(url)` opens a URL in the default browser ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). `App::register_url_scheme(scheme)` claims a scheme like `myapp://` at runtime ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). `Application::on_open_urls(callback)` handles incoming URLs sent by the OS ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).

```rust
// on_open_urls fires when the OS hands your app a link. Register early.
// open_url goes the other way: your app asks the OS to open a browser.
app.on_open_urls(|urls| println!("{urls:?}"));
cx.open_url("https://example.com");
```

`App::set_app_identity(id, name)` sets the OS-visible identity once, early in startup ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). It feeds mechanisms like the Windows AppUserModelID. Call it before opening windows.

## Headless vs GUI

GUI apps come from `gpui_platform::application()`. It picks the OS platform with `current_platform(false)` ([crates/gpui_platform/src/gpui_platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_platform/src/gpui_platform.rs)). Headless apps come from `gpui_platform::headless()`, which passes `true` ([crates/gpui_platform/src/gpui_platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_platform/src/gpui_platform.rs)).

Headless mode still builds a real `App`. It just has no visible windows or event loop. Tests use `HeadlessAppContext::with_platform` with a real text system for shaping. Screenshots need a renderer factory passed to `with_platform`.

```rust
// Headless: deterministic, no OS windows. Made for tests.
// new takes a text system so shaping still measures real glyphs.
// run_until_parked drains effects, like a tiny manual event loop.
let mut cx = HeadlessAppContext::new(text_system);
let window = cx.open_window(size, build_root)?;
cx.run_until_parked();
```

> **Note.** Use headless for text measurement and logic tests. Use GUI mode for anything involving real input, focus, or display.

## Sources

- [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs) (`Application`), `:164` (`ApplicationHandle::update`), `:180` (`with_platform`), `:197` (`new_inaccessible`), `:204` (`with_assets`), `:214` (`with_restart_arguments`), `:220` (`with_http_client`), `:229` (`with_quit_mode`), `:258` (`run`), `:279` (`run_embedded`), `:294` (`on_open_urls`), `:304` (`on_reopen`)
- [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs) (`SHUTDOWN_TIMEOUT`), `:1007` (`shutdown`), `:1061` (`quit`), `:1558` (`open_url`), `:1568` (`register_url_scheme`), `:1578` (`set_app_identity`), `:1677` (`restart`), `:1688` (`set_restart_path`), `:1704` (`set_quit_mode`), `:2076`–`:2124` (globals), `:2410` (`on_app_quit`), `:2431` (`on_app_restart`)
- [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs) (`QuitMode`)
- [crates/gpui/src/global.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/global.rs) (`Global`)
- [crates/gpui_platform/src/gpui_platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_platform/src/gpui_platform.rs) (`application`), `:23` (`headless`), `:57` (`current_platform`)
- [crates/gpui/src/app/headless_app_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/headless_app_context.rs) (`new`), `:65` (`with_platform`), `:104` (`open_window`)
