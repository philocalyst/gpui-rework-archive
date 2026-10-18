use gpui::PlatformTextSystem;
use gpui::prelude::*;
use gpui::{
    Entity, HeadlessAppContext, LayoutDirection, ViewElement, Window, WindowHandle, div, px, rgb,
    size,
};
use gpui_fonts::{IBM_PLEX, NOTO_ARABIC, NOTO_HEBREW};
use gpui_parley::{ParleyTextSystem, SystemFonts};
use std::borrow::Cow;

const WINDOW_SIZE: f32 = 520.;

fn ink() -> gpui::Hsla {
    gpui::rgb_to_hsla(rgb(0x243b53))
}

struct ParagraphPanel {
    text: String,
    width: gpui::Pixels,
}

impl Render for ParagraphPanel {
    fn render(&mut self, _window: &mut Window, _cx: &mut gpui::Context<Self>) -> impl IntoElement {
        div()
            .debug_selector(|| "REAL_PARLEY_PARAGRAPH".into())
            .w(self.width)
            .text_size(px(22.))
            .text_color(ink())
            .font_family("IBM Plex Sans")
            .text_start()
            .child(self.text.clone())
    }
}

struct ParagraphRoot {
    panel: Entity<ParagraphPanel>,
    top_gap: gpui::Pixels,
    auto_direction: bool,
    force_fresh_child: bool,
}

impl Render for ParagraphRoot {
    fn render(&mut self, _window: &mut Window, _cx: &mut gpui::Context<Self>) -> impl IntoElement {
        let panel = if self.force_fresh_child {
            ViewElement::new(self.panel.clone()).into_any_element()
        } else {
            self.panel.clone().into_any_element()
        };
        let mut root = div()
            .size_full()
            .child(div().w_full().h(self.top_gap).flex_shrink_0());
        if self.auto_direction {
            root = root.direction(LayoutDirection::Auto);
        }
        root.child(panel)
    }
}

fn open_pair(
    cx: &mut HeadlessAppContext,
    force_fresh_child: bool,
    text: &str,
) -> (Entity<ParagraphPanel>, WindowHandle<ParagraphRoot>) {
    let panel = cx.update(|app| {
        app.new(|_| ParagraphPanel {
            text: text.to_owned(),
            width: px(350.),
        })
    });
    let window = cx
        .open_window(size(px(WINDOW_SIZE), px(250.)), {
            let panel = panel.clone();
            move |_, app| {
                app.new(|_| ParagraphRoot {
                    panel,
                    top_gap: px(0.),
                    auto_direction: false,
                    force_fresh_child,
                })
            }
        })
        .unwrap();
    (panel, window)
}

fn glyphs(
    cx: &mut HeadlessAppContext,
    window: WindowHandle<ParagraphRoot>,
) -> Vec<gpui::Bounds<gpui::ScaledPixels>> {
    cx.glyph_bounds(window.into(), ink()).unwrap()
}

fn assert_same_real_glyphs(
    cx: &mut HeadlessAppContext,
    retained: WindowHandle<ParagraphRoot>,
    fresh: WindowHandle<ParagraphRoot>,
    phase: &str,
) -> Vec<gpui::Bounds<gpui::ScaledPixels>> {
    let retained_glyphs = glyphs(cx, retained);
    let fresh_glyphs = glyphs(cx, fresh);
    assert!(
        !retained_glyphs.is_empty(),
        "{phase}: Parley must paint real glyph sprites"
    );
    assert!(
        !fresh_glyphs.is_empty(),
        "{phase}: fresh oracle must paint real glyph sprites"
    );
    assert_eq!(
        retained_glyphs, fresh_glyphs,
        "{phase}: retained output must match a forced-fresh render"
    );
    retained_glyphs
}

fn update_root(
    cx: &mut HeadlessAppContext,
    window: WindowHandle<ParagraphRoot>,
    update: impl FnOnce(&mut ParagraphRoot),
) {
    cx.update(|app| {
        window
            .update(app, |root, _window, cx| {
                update(root);
                cx.notify();
            })
            .unwrap();
    });
}

fn update_panel(
    cx: &mut HeadlessAppContext,
    panel: &Entity<ParagraphPanel>,
    update: impl FnOnce(&mut ParagraphPanel),
) {
    cx.update(|app| {
        panel.update(app, |panel, cx| {
            update(panel);
            cx.notify();
        });
    });
}

fn system() -> ParleyTextSystem {
    let system = ParleyTextSystem::new_with_system_font(SystemFonts::Skip, "IBM Plex Sans")
        .with_fallback_families(["IBM Plex Sans", "Noto Sans Hebrew", "Noto Sans Arabic"]);
    system
        .add_fonts(vec![
            Cow::Borrowed(*IBM_PLEX),
            Cow::Borrowed(*NOTO_HEBREW),
            Cow::Borrowed(*NOTO_ARABIC),
        ])
        .unwrap();
    system
}

#[test]
fn retained_default_block_paragraph_matches_real_parley_fresh_layout() {
    let mut cx = HeadlessAppContext::new(std::sync::Arc::new(system()));
    let initial_text = "Retained paragraph shaping starts left to right with IBM Plex; Hebrew שלום and Arabic مرحبا use embedded fallback fonts. This text wraps at several widths.";
    let (retained_panel, retained) = open_pair(&mut cx, false, initial_text);
    let (fresh_panel, fresh) = open_pair(&mut cx, true, initial_text);
    cx.run_until_parked();

    let initial = assert_same_real_glyphs(&mut cx, retained, fresh, "initial LTR paragraph");

    // An unchanged notification gives the retained child a clean cache-hit frame before the
    // origin-only move that should reuse its paragraph shape.
    update_root(&mut cx, retained, |_| {});
    update_root(&mut cx, fresh, |_| {});
    cx.run_until_parked();
    assert_eq!(
        initial,
        assert_same_real_glyphs(&mut cx, retained, fresh, "clean cache hit")
    );

    update_root(&mut cx, retained, |root| root.top_gap = px(17.));
    update_root(&mut cx, fresh, |root| root.top_gap = px(17.));
    cx.run_until_parked();
    let moved = assert_same_real_glyphs(&mut cx, retained, fresh, "origin-only move");
    assert_ne!(
        initial, moved,
        "the real glyph sprites must move with their paragraph origin"
    );

    update_panel(&mut cx, &retained_panel, |panel| panel.width = px(205.));
    update_panel(&mut cx, &fresh_panel, |panel| panel.width = px(205.));
    cx.run_until_parked();
    let narrowed = assert_same_real_glyphs(&mut cx, retained, fresh, "changed width constraints");
    assert_ne!(
        moved, narrowed,
        "narrower constraints should change wrapped glyph geometry"
    );

    let changed_text = "Changed text key: this Latin-first paragraph is longer and includes Hebrew שלום and Arabic مرحبا fallback.";
    update_panel(&mut cx, &retained_panel, |panel| {
        panel.text = changed_text.to_owned()
    });
    update_panel(&mut cx, &fresh_panel, |panel| {
        panel.text = changed_text.to_owned()
    });
    cx.run_until_parked();
    let changed = assert_same_real_glyphs(&mut cx, retained, fresh, "changed text key");
    assert_ne!(
        narrowed, changed,
        "changed content should produce different real glyph geometry"
    );

    // Change to Hebrew-first content while the parent still inherits the default LTR direction.
    // Then enable Auto without changing the paragraph, so the direction transition is isolated.
    let hebrew_text =
        "שלום עולם — inherited LTR paragraph before Auto; Arabic مرحبا uses fallback too.";
    update_panel(&mut cx, &retained_panel, |panel| {
        panel.text = hebrew_text.to_owned()
    });
    update_panel(&mut cx, &fresh_panel, |panel| {
        panel.text = hebrew_text.to_owned()
    });
    cx.run_until_parked();
    let inherited = assert_same_real_glyphs(
        &mut cx,
        retained,
        fresh,
        "Hebrew-first text with inherited LTR",
    );
    assert_ne!(
        changed, inherited,
        "the Hebrew-first text key must be distinct"
    );

    update_root(&mut cx, retained, |root| root.auto_direction = true);
    update_root(&mut cx, fresh, |root| root.auto_direction = true);
    cx.run_until_parked();
    let rtl = assert_same_real_glyphs(&mut cx, retained, fresh, "Auto RTL parent transition");
    assert_ne!(
        inherited, rtl,
        "RTL text-start alignment must change the painted glyph positions"
    );

    update_root(&mut cx, retained, |_| {});
    update_root(&mut cx, fresh, |_| {});
    cx.run_until_parked();
    assert_eq!(
        rtl,
        assert_same_real_glyphs(&mut cx, retained, fresh, "second RTL frame")
    );
}
