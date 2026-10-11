# Use platform services

GPUI gives your app the operating system's clipboard, browser, menus, dialogs,
quit behavior and appearance. Each service is a method on [`App`] or [`Window`].
The [`TestApp`] harness fakes some of them, so you can check their behavior in a
test. The rest only run in a real window, and the examples for those are marked
`no_run`.

## Copy and paste with the clipboard

Write a [`ClipboardItem`] with [`App::write_to_clipboard`], and read the
clipboard back with [`App::read_from_clipboard`]. Both work from any handler that
has an `App` or a `Context`:

```rust
# use gpui::{ClipboardItem, TestApp};
# let mut app = TestApp::new();
// Copy text, for example from a "Copy" button handler.
app.update(|cx| cx.write_to_clipboard(ClipboardItem::new_string("Copied text".to_string())));

// Paste: returns `None` when there is no clipboard item to read.
let item = app.read(|cx| cx.read_from_clipboard()).expect("the clipboard has an item");
assert_eq!(item.text().as_deref(), Some("Copied text"));
```

[`ClipboardItem::text`] concatenates the item's string entries, and returns
`None` when the item has no text.

On the web, [`App::read_from_clipboard`] always returns `None`, because browsers
only allow reads that the user permits. Use [`App::read_from_clipboard_async`]
there. It returns a [`Task`] that resolves to the clipboard contents, or to a
[`ClipboardReadError`] when the browser refuses. Writes work on every platform.

## Open a URL in the browser

[`App::open_url`] hands a URL to the platform's default browser:

```rust
# use gpui::TestApp;
# let mut app = TestApp::new();
app.update(|cx| cx.open_url("https://github.com/gpui-ce/gpui-ce"));

assert_eq!(
    app.opened_url().as_deref(),
    Some("https://github.com/gpui-ce/gpui-ce"),
);
```

[`TestApp::opened_url`] records the last URL instead of opening a browser. On
the web, `open_url` opens the URL with the browser's own window APIs.

## Add application menus

[`App::set_menus`] replaces the application's menu bar. Build each [`Menu`] from
[`MenuItem`]s. A [`MenuItem::action`] dispatches its action through [`App`] when
the user picks it, so the same [`App::on_action`] handler runs for the menu item
and for its keyboard shortcut.

```standalone_crate
use gpui::{App, KeyBinding, Menu, MenuItem, TestApp, actions};

actions!(platform_services, [Quit, Undo]);

fn set_up(cx: &mut App) {
    cx.on_action(|_: &Quit, cx| cx.quit());
    cx.on_action(|_: &Undo, _cx| {
        // Undo the last edit here.
    });
    cx.bind_keys([
        KeyBinding::new("cmd-q", Quit, None),
        KeyBinding::new("cmd-z", Undo, None),
    ]);
    cx.set_menus([
        Menu::new("App").items([MenuItem::action("Quit", Quit)]),
        Menu::new("Edit").items([
            MenuItem::action("Undo", Undo),
            MenuItem::separator(),
        ]),
    ]);
}
# TestApp::new().update(set_up);
```

`set_menus` takes the whole menu bar each time, so call it again to change it.
The browser ignores menus, and so does `TestApp`, so a test can't inspect the
menu bar. Test the handler that a menu item calls instead.

## Show an alert

[`Window::prompt`] shows a dialog with a message and one button per answer. It
returns a `oneshot::Receiver` that gets the index of the button the user chose.
The first answer is at index 0.

```rust
# use gpui::{Context, PromptLevel, Render, TestApp, Window, div, prelude::*};
# struct Root;
# impl Render for Root {
#     fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement { div() }
# }
# let mut app = TestApp::new();
let mut window = app.open_window(|_, _| Root);

// Ask before deleting. The answers are the button labels, in order.
let mut answer = window.update(|_root, window, cx| {
    window.prompt(
        PromptLevel::Warning,
        "Delete this file?",
        Some("This cannot be undone."),
        &["Cancel", "Delete"],
        cx,
    )
});

// The test harness answers the prompt by label.
app.simulate_prompt_answer("Delete");
assert_eq!(answer.try_recv().unwrap(), Some(1));
```

[`PromptLevel`] sets the icon and styling: `Info`, `Warning` or `Critical`.
A label of `"OK"` or `"Cancel"` becomes an OK or cancel button, which the
platform styles accordingly. Any other label is a plain button. On the web,
GPUI has no native dialog, so it draws the prompt inside the window.

## Pick files and folders

[`App::prompt_for_paths`] shows an open dialog and [`App::prompt_for_new_path`]
shows a save dialog. Each returns a `oneshot::Receiver` that resolves when the
user picks a path or cancels. Cancelling resolves to `Ok(None)`. An `Err` means
the dialog couldn't open. On Linux that can happen when no file picker is
available, and on the web both dialogs return an error.

```rust,no_run
use std::path::Path;

use gpui::{App, PathPromptOptions};

fn open_and_save(cx: &mut App) {
    let open = cx.prompt_for_paths(PathPromptOptions {
        files: true,
        directories: false,
        multiple: false,
        prompt: Some("Open".into()),
    });
    let save = cx.prompt_for_new_path(Path::new("."), Some("notes.txt"));

    cx.spawn(async move |_cx| {
        if let Ok(Ok(Some(paths))) = open.await {
            println!("Open {paths:?}");
        }
        if let Ok(Ok(Some(path))) = save.await {
            println!("Save to {}", path.display());
        }
    })
    .detach();
}
```

`prompt_for_paths` picks files, folders or both, and can allow several picks.
Set `files`, `directories` and `multiple` on [`PathPromptOptions`] to match.

## Quit the application

[`App::quit`] asks the platform to quit gracefully. Whether closing the last
window also quits depends on the [`QuitMode`] you set on the application:

```rust,no_run
use gpui::{App, QuitMode};

fn main() {
    gpui_platform::application()
        .with_quit_mode(QuitMode::Explicit)
        .run(|cx: &mut App| {
            cx.activate(true);
        });
}

fn on_quit_button(cx: &mut App) {
    cx.quit();
}
```

[`QuitMode::Explicit`] keeps the app running after its last window closes.
[`QuitMode::LastWindowClosed`] quits at that point. [`QuitMode::Default`], the
default, does the first on macOS and the second elsewhere. The browser can't
quit, so `App::quit` only logs a warning there.

## Follow the system appearance

[`Window::appearance`] returns a [`WindowAppearance`]: `Light`, `VibrantLight`,
`Dark` or `VibrantDark`. Use [`colors::Colors::for_appearance`] to pick colors for it.
To react when the user switches between light and dark, register a callback with
[`Window::observe_window_appearance`]. Keep the returned [`Subscription`] in a
field, because dropping it unregisters the callback.

```rust,no_run
use gpui::{Context, Subscription, Window, WindowAppearance, div, prelude::*};

struct Themed {
    appearance: WindowAppearance,
    _observe_appearance: Subscription,
}

impl Themed {
    fn new(window: &mut Window, cx: &mut Context<Self>) -> Self {
        let this = cx.entity();
        Self {
            appearance: window.appearance(),
            _observe_appearance: window.observe_window_appearance(move |window, cx| {
                let appearance = window.appearance();
                this.update(cx, |themed, cx| {
                    themed.appearance = appearance;
                    cx.notify();
                });
            }),
        }
    }
}

impl Render for Themed {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        let text = match self.appearance {
            WindowAppearance::Dark | WindowAppearance::VibrantDark => "Dark",
            WindowAppearance::Light | WindowAppearance::VibrantLight => "Light",
        };
        div().child(format!("System appearance: {text}"))
    }
}
```

The callback runs whenever the platform reports a change, and [`Context::notify`]
redraws the view with the new value. On the web, the appearance follows the
`prefers-color-scheme` media query.

## What the web doesn't provide

The browser is a sandbox, so several services change or do nothing. Plan for
these when you target the web:

| Service | On the web |
| --- | --- |
| Clipboard write | Works. Reading is permission-gated: use `read_from_clipboard_async`. |
| `open_url` | Works, through the browser's window APIs. |
| `set_menus` | Does nothing. |
| `Window::prompt` | Draws a prompt inside the window. |
| `prompt_for_paths`, `prompt_for_new_path` | Returns an error. |
| `App::quit` | Logs a warning and does nothing. |
| `reveal_path`, `open_with_system` | Do nothing. |
| `Window::appearance` | Works, from `prefers-color-scheme`. |

For the browser's own setup, see [run on the web](crate::_documentation::guides::web).

## See also

- [Run work in the background](crate::_documentation::guides::async_work) covers
  the tasks that dialogs and clipboard reads return.
- [Test your app](crate::_documentation::guides::testing) covers [`TestApp`] in
  more depth.
- [Start a project](crate::_documentation::guides::start_a_project) shows how
  the application and its quit mode are set up.
