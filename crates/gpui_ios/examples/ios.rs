//! Native iOS smoke application for GPUI.
//!
//! This uses the same platform-neutral application entry point as desktop GPUI apps. The visible
//! Unicode line and one-time diagnostics exercise the installed iOS CoreText/Parley fallback and
//! glyph-raster paths.

#[cfg(target_os = "ios")]
use gpui::{
    Context, GlyphRenderMode, PreparedRasterStyle, RenderGlyphParams, TextRun, Window,
    WindowOptions, div, point, prelude::*, px, rgb,
};

#[cfg(target_os = "ios")]
const FONT_PROBE: &str = "漢字かなカナ 한글 • 🙂 👩🏽‍💻";

#[cfg(target_os = "ios")]
struct IosExample {
    tap_count: usize,
    font_probe_recorded: bool,
}

#[cfg(target_os = "ios")]
impl Render for IosExample {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        if !self.font_probe_recorded {
            self.font_probe_recorded = true;
            record_native_font_probe(window);
        }

        div()
            .size_full()
            .flex()
            .flex_col()
            .items_center()
            .justify_center()
            .gap_6()
            .bg(rgb(0x101622))
            .text_color(rgb(0xf5f7ff))
            .child(div().text_3xl().child("GPUI on iOS"))
            .child(
                div()
                    .id("tap-counter")
                    .px_6()
                    .py_3()
                    .rounded_lg()
                    .bg(rgb(0x246bfd))
                    .text_xl()
                    .on_click(cx.listener(|this, _, _, cx| {
                        this.tap_count += 1;
                        cx.notify();
                    }))
                    .child(format!("Taps: {}", self.tap_count)),
            )
            .child(
                div()
                    .max_w(px(320.))
                    .text_center()
                    .child("Rust app, native UIKit loop, GPUI rendering"),
            )
            .child(div().max_w(px(340.)).text_center().child(FONT_PROBE))
    }
}

#[cfg(target_os = "ios")]
fn record_native_font_probe(window: &Window) {
    let text_system = window.text_system();
    let runs = [TextRun {
        len: FONT_PROBE.len(),
        ..Default::default()
    }];
    let layout = text_system.layout_line(FONT_PROBE, px(24.), &runs);
    let installed_families = text_system.all_font_names();
    eprintln!(
        "[ios-font-probe] backend=WindowTextSystem/Parley-CoreText text={FONT_PROBE:?} fragments={}",
        layout.paint_fragments.len()
    );

    for fragment in &layout.paint_fragments {
        let families: Vec<_> = installed_families
            .iter()
            .filter(|family| {
                text_system.resolve_font(&gpui::font((*family).clone())) == fragment.font_id
            })
            .map(String::as_str)
            .collect();

        for (index, glyph) in fragment.glyphs.iter().enumerate() {
            let source_range = fragment
                .glyph_source_ranges
                .as_ref()
                .and_then(|ranges| ranges.get(index))
                .cloned();
            let source = source_range
                .as_ref()
                .and_then(|range| FONT_PROBE.get(range.clone()))
                .unwrap_or("");
            let mode = if glyph.is_emoji {
                GlyphRenderMode::Color
            } else {
                GlyphRenderMode::Grayscale
            };
            let raster = text_system.rasterize_glyph(&RenderGlyphParams {
                font_id: fragment.font_id,
                glyph_id: glyph.id,
                font_size: px(24.),
                subpixel_variant: point(0, 0),
                scale_factor: window.scale_factor(),
                raster_style: PreparedRasterStyle::independent(mode),
            });

            match raster {
                Ok(raster) => {
                    let nonempty_pixels = if glyph.is_emoji {
                        raster
                            .pixels
                            .chunks_exact(4)
                            .filter(|pixel| pixel[3] != 0)
                            .count()
                    } else {
                        raster.pixels.iter().filter(|pixel| **pixel != 0).count()
                    };
                    eprintln!(
                        "[ios-font-probe] source={source:?} range={source_range:?} font_id={:?} families={families:?} glyph_id={} emoji={} raster={:?} size={:?} nonempty_pixels={nonempty_pixels}",
                        fragment.font_id, glyph.id.0, glyph.is_emoji, raster.format, raster.size,
                    );
                }
                Err(error) => eprintln!(
                    "[ios-font-probe] raster_failed source={source:?} font_id={:?} glyph_id={} emoji={}: {error:#}",
                    fragment.font_id, glyph.id.0, glyph.is_emoji,
                ),
            }
        }
    }
}

#[cfg(target_os = "ios")]
fn main() {
    gpui_platform::application().run(|cx| {
        gpui_ios::ios::set_status_bar_style(gpui_ios::StatusBarContentStyle::Light);
        cx.open_window(WindowOptions::default(), |_, cx| {
            cx.new(|_| IosExample {
                tap_count: 0,
                font_probe_recorded: false,
            })
        })
        .unwrap();
        cx.activate(true);
    });
}

#[cfg(not(target_os = "ios"))]
fn main() {
    eprintln!("Build this example for an iOS target and package it with build-simulator.sh.");
}
