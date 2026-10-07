//! Embed the Miri branch's existing editor and GPUI scene renderer.
#[path = "support.rs"]
mod support;

use gpui::{AppContext, KeyBinding};
use gpui_ce_codepen::{Codepen, codepen::Run};
use gpui_ce_elements::editable_text::actions::{DEFAULT_INPUT_CONTEXT, default_bindings};
use std::borrow::Cow;

pub fn run(slug: &str) {
    let source = super::components::source(slug).expect("registered walkthrough component");
    support::run(move |_window, cx| {
        cx.text_system()
            .add_fonts(vec![Cow::Borrowed(include_bytes!(
                "../../../assets/fonts/lilex/Lilex-Regular.ttf"
            ) as &[u8])])
            .expect("load the workbench font");
        cx.bind_keys(default_bindings().as_keybindings(Some(DEFAULT_INPUT_CONTEXT)));
        cx.bind_keys([
            KeyBinding::new("cmd-enter", Run, None),
            KeyBinding::new("ctrl-enter", Run, None),
        ]);
        let editor = cx.new(|cx| Codepen::new(source, cx));
        editor.update(cx, |editor, cx| editor.run(cx));
        editor
    });
}
