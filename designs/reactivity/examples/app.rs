//! Open a second window. `Window::utility(..)` names the kind; unset chrome falls through
//! kind defaults, then the `Application` policy for fields the kind does not specialize.
//! Utility does not inherit the document's size (07 §12, §16.1).
//!
//! A handler opens windows by requesting the sealed `Windows` capability as a validated
//! parameter — the same shape as `Clipboard`/`FileDialogs` (07 §16.4). It never threads a
//! `cx`. The typed `Win<Inspector>` it gets back is a generational route, not a borrow of
//! `Application`; a stale handle returns `Closed` rather than dangling (07 §12).

use gpui::prelude::*;

#[derive(Default)]
struct Studio {
    inspector: Option<Win<Inspector>>,
}

struct Inspector;

impl View for Inspector {
    fn view(&self) -> El<'_> {
        // One child, no arrangement — a styled box, not a flow container (14 §2.1): `div()` stays
        // nullary and `.child(x)` is the one child verb; `column()` never takes zero args.
        div().p(12).child(text("Utility window"))
    }
}

impl Studio {
    fn toggle_inspector(&mut self, windows: Windows) {
        match self.inspector.take() {
            // A live handle: close it. A stale one silently drops (typed miss).
            Some(open) => open.close(),
            None => match windows.open(Window::utility(Inspector).title("Inspector")) {
                Ok(win) => self.inspector = Some(win),
                Err(err) => self.announce(Assertive, err),
            },
        }
    }
}

impl View for Studio {
    fn view(&self) -> El<'_> {
        column((
            text("Untitled").text_xl(),
            text("The document lives here. Inspector is a spawned window."),
            button("Inspector").on_click(Studio::toggle_inspector),
        ))
        .p(24)
        .gap(12)
    }
}

fn main() {
    // The document window carries size/centering; a Utility window takes compact chrome.
    Application::run(
        Window::document(Studio::default())
            .title("Studio")
            .size(960, 640)
            .centered(),
    );
}
