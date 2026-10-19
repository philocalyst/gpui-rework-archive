//! A retained paragraph must paint exactly what a new window paints for the same state, with real
//! Parley shaping, across re-renders that keep or change its layout.

use gpui::PlatformTextSystem;
use gpui::prelude::*;
use gpui::{
    Bounds, Entity, HeadlessAppContext, LayoutDirection, Pixels, ScaledPixels, Window,
    WindowHandle, div, px, rgb, size,
};
use gpui_fonts::{IBM_PLEX, NOTO_ARABIC, NOTO_HEBREW};
use gpui_parley::{ParleyTextSystem, SystemFonts};
use std::borrow::Cow;

fn ink() -> gpui::Hsla {
    gpui::rgb_to_hsla(rgb(0x243b53))
}

#[derive(Clone)]
struct Panel {
    text: String,
    width: Pixels,
}

impl Render for Panel {
    fn render(&mut self, _: &mut Window, _: &mut gpui::Context<Self>) -> impl IntoElement {
        div()
            .w(self.width)
            .text_size(px(22.))
            .text_color(ink())
            .font_family("IBM Plex Sans")
            .text_start()
            .child(self.text.clone())
    }
}

#[derive(Clone)]
struct Root {
    panel: Entity<Panel>,
    top_gap: Pixels,
    auto_direction: bool,
}

impl Render for Root {
    fn render(&mut self, _: &mut Window, _: &mut gpui::Context<Self>) -> impl IntoElement {
        let root = div()
            .size_full()
            .child(div().w_full().h(self.top_gap).flex_shrink_0())
            .child(self.panel.clone());
        if self.auto_direction {
            root.direction(LayoutDirection::Auto)
        } else {
            root
        }
    }
}

fn open(
    cx: &mut HeadlessAppContext,
    panel: Panel,
    top_gap: Pixels,
    auto: bool,
) -> WindowHandle<Root> {
    let panel = cx.update(|app| app.new(|_| panel));
    let window = cx
        .open_window(size(px(520.), px(250.)), move |_, app| {
            app.new(|_| Root {
                panel,
                top_gap,
                auto_direction: auto,
            })
        })
        .unwrap();
    cx.run_until_parked();
    window
}

/// The painted glyphs' bounds, sorted, since draw order may differ between equal frames.
fn glyphs(cx: &mut HeadlessAppContext, window: WindowHandle<Root>) -> Vec<Bounds<ScaledPixels>> {
    let mut glyphs = cx.glyph_bounds(window.into(), ink()).unwrap();
    glyphs.sort_by(|a, b| {
        (a.origin.y.0, a.origin.x.0, a.size.width.0, a.size.height.0)
            .partial_cmp(&(b.origin.y.0, b.origin.x.0, b.size.width.0, b.size.height.0))
            .unwrap()
    });
    glyphs
}

/// Checks the retained window against a new window with the same state, and returns its glyphs.
fn check(
    cx: &mut HeadlessAppContext,
    retained: WindowHandle<Root>,
    phase: &str,
) -> Vec<Bounds<ScaledPixels>> {
    cx.run_until_parked();
    let (root, panel) = cx.update(|app| {
        let root = retained.read(app).unwrap().clone();
        let panel = root.panel.read(app).clone();
        (root, panel)
    });
    let fresh = open(cx, panel, root.top_gap, root.auto_direction);
    let expected = glyphs(cx, fresh);
    let actual = glyphs(cx, retained);
    cx.update(|app| {
        fresh
            .update(app, |_, window, _| window.remove_window())
            .unwrap()
    });
    assert!(!expected.is_empty(), "{phase}: Parley paints glyphs");
    assert_eq!(
        actual, expected,
        "{phase}: retained output matches a new window"
    );
    actual
}

fn update_root(cx: &mut HeadlessAppContext, window: WindowHandle<Root>, f: impl FnOnce(&mut Root)) {
    cx.update(|app| {
        window
            .update(app, |root, _, cx| {
                f(root);
                cx.notify();
            })
            .unwrap()
    });
}

fn update_panel(
    cx: &mut HeadlessAppContext,
    window: WindowHandle<Root>,
    f: impl FnOnce(&mut Panel),
) {
    cx.update(|app| {
        let panel = window.read(app).unwrap().panel.clone();
        panel.update(app, |panel, cx| {
            f(panel);
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
fn retained_paragraph_matches_a_new_window() {
    let mut cx = HeadlessAppContext::new(std::sync::Arc::new(system()));
    let text = "Retained paragraph shaping starts left to right with IBM Plex; Hebrew שלום and \
                Arabic مرحبا use embedded fallback fonts. This text wraps at several widths.";
    let window = open(
        &mut cx,
        Panel {
            text: text.into(),
            width: px(350.),
        },
        px(0.),
        false,
    );
    let initial = check(&mut cx, window, "first frame");

    // Renders that change nothing keep the paragraph's layout and measurement.
    update_root(&mut cx, window, |_| {});
    assert_eq!(check(&mut cx, window, "parent renders again"), initial);
    update_panel(&mut cx, window, |_| {});
    assert_eq!(check(&mut cx, window, "panel renders again"), initial);

    update_root(&mut cx, window, |root| root.top_gap = px(17.));
    let moved = check(&mut cx, window, "moved");
    assert_ne!(moved, initial);

    update_panel(&mut cx, window, |panel| panel.width = px(205.));
    let narrowed = check(&mut cx, window, "narrower");
    assert_ne!(narrowed, moved);

    update_panel(&mut cx, window, |panel| {
        panel.text = "Changed text: longer, with Hebrew שלום and Arabic مرحبا fallback.".into()
    });
    let changed = check(&mut cx, window, "changed text");
    assert_ne!(changed, narrowed);

    // Hebrew-first text under an inherited left-to-right direction, then an Auto parent, which
    // makes the paragraph right-to-left without changing it.
    update_panel(&mut cx, window, |panel| {
        panel.text = "שלום עולם — inherited direction first; Arabic مرحبا falls back too.".into()
    });
    let inherited = check(&mut cx, window, "Hebrew text, inherited direction");
    update_root(&mut cx, window, |root| root.auto_direction = true);
    let rtl = check(&mut cx, window, "Auto parent");
    assert_ne!(rtl, inherited);

    update_panel(&mut cx, window, |_| {});
    assert_eq!(
        check(&mut cx, window, "right-to-left panel renders again"),
        rtl
    );
}
