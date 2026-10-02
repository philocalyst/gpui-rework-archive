//! A compact shader gallery for element backgrounds, layered paints and glass.
//!
//! ```sh
//! cargo run -p gpui_ce_wgpu --example shader_gallery --features test-support -- \
//!   --output /tmp/shader-gallery.png --time 1.8 --size 1280 800
//! ```
//!
//! All materials below are ordinary functions over `Pixel` and typed fields.
//! The colorful scene is a normal element background; the glass card samples
//! that actual backdrop and refracts it behind its own rounded geometry.

use gpui::prelude::FluentBuilder;
use gpui::{
    AppContext, Context, FontWeight, HeadlessAppContext, IntoElement, ParentElement, Pixels,
    Render, Size, Styled, Window, div, px, rgb,
    shader::{Field, Paint, backdrop, color, constant, rgba, shader, vec2},
    size,
};
use gpui_ce_wgpu::{CosmicTextSystem, WgpuHeadlessRenderer};
use std::{path::PathBuf, sync::Arc};

fn environment(time: f32) -> Paint {
    shader(move |pixel| {
        let uv = pixel.uv();
        let phase: Field<f32> = time.into();
        let aspect = pixel.size().x() / pixel.size().y();
        let p = vec2((uv.x() - 0.5) * aspect, uv.y() - 0.5);

        let sky = color(rgb(0x09142d)).mix(color(rgb(0x332354)), uv.y());
        let sunset = (1.0
            - (&p - constant([-0.19, 0.05]))
                .length()
                .smoothstep(0.06, 0.78))
        .clamp(0.0, 1.0);
        let cyan = (1.0
            - (&p - constant([0.31, -0.11]))
                .length()
                .smoothstep(0.04, 0.70))
        .clamp(0.0, 1.0);
        let magenta = (1.0
            - (&p - constant([0.04, 0.31]))
                .length()
                .smoothstep(0.02, 0.48))
        .clamp(0.0, 1.0);
        let tide = (uv.x() * 10.0 + uv.y() * 6.0 + &phase * 0.18).sin();
        let horizon = 0.56 + tide * 0.045;
        let horizon_glow = (1.0 - (uv.y() - horizon).abs().smoothstep(0.0, 0.19))
            * (uv.x() * 8.0 + &phase * 0.14).sin().abs();
        // One quiet orbit catches light around the glass. Retained scene rules
        // below provide the finer geometry for refraction.
        let orbit = (&p - constant([0.34, 0.015])).length();
        let orbit_line =
            (1.0 - (orbit - 0.39).abs().smoothstep(0.0025, 0.010)) * uv.x().smoothstep(0.54, 0.62);

        color(rgb(0xf47f55))
            .opacity(sunset * 0.93)
            .over(color(rgb(0x4bdbdf)).opacity(cyan * 0.78))
            .over(color(rgb(0xb654e8)).opacity(magenta * 0.50))
            .over(color(rgb(0xffd99a)).opacity(horizon_glow * 0.24))
            .over(color(rgb(0xffc9f1)).opacity(orbit_line * 0.30))
            .over(sky)
    })
}

fn aurora_material(time: f32) -> Paint {
    shader(move |pixel| {
        let uv = pixel.uv();
        let phase: Field<f32> = time.into();
        let curve = 0.48 + (uv.x() * 7.5 + &phase * 0.7).sin() * 0.17;
        let fold = (uv.x() * 13.0 - uv.y() * 5.0 + &phase).sin();
        let ribbon = (1.0 - (uv.y() - curve).abs().smoothstep(0.025, 0.24)).clamp(0.0, 1.0);
        let glow = (fold * 0.5 + 0.5) * ribbon;
        color(rgb(0x65e5ef))
            .mix(color(rgb(0xb55be8)), uv.x())
            .opacity(glow * 0.92)
            .over(color(rgb(0x101b35)))
    })
}

fn liquid_ink(time: f32) -> Paint {
    shader(move |pixel| {
        let uv = pixel.uv();
        let phase: Field<f32> = time.into();
        let grain = (uv.x() * 8.0 + (uv.y() * 13.0 + &phase).sin() * 2.4).sin();
        let band = (grain * 0.5 + 0.5).smoothstep(0.16, 0.92);
        let pool = (1.0
            - (&uv - constant([0.52, 0.47]))
                .length()
                .smoothstep(0.18, 0.77))
        .clamp(0.0, 1.0);
        color(rgb(0x11152b))
            .mix(color(rgb(0xff6e85)), band * 0.88)
            .mix(color(rgb(0xffc875)), pool * 0.48)
    })
}

/// A thin spectral outline: the element still owns its border width, corners,
/// and clipping; the paint only supplies the color at each border fragment.
fn spectral_edge(time: f32) -> Paint {
    shader(move |pixel| {
        let phase: Field<f32> = time.into();
        let uv = pixel.uv();
        let shimmer = (uv.x() * 5.6 + uv.y() * 2.2 + &phase * 0.55).sin() * 0.5 + 0.5;
        color(rgb(0x77eff2))
            .mix(color(rgb(0xffbb92)), shimmer)
            .opacity(0.88)
    })
}

fn liquid_glass(time: f32) -> Paint {
    shader(move |pixel| {
        let uv = pixel.uv();
        let size = pixel.size();
        let phase: Field<f32> = time.into();
        let wave_x = (uv.y() * 23.0 + uv.x() * 9.0 + &phase * 0.35).sin() * 4.2;
        let wave_y = (uv.x() * 18.0 - uv.y() * 11.0 - &phase * 0.24).sin() * 5.8;
        let bend = vec2(wave_x / size.x(), wave_y / size.y());
        let source = backdrop();
        let edge_distance = uv.x().min(1.0 - uv.x()).min(uv.y().min(1.0 - uv.y()));
        let edge_light = 1.0 - edge_distance.smoothstep(0.008, 0.12);
        let dispersion = 0.18 + &edge_light * 0.45;

        // Independent offset samples split the spectrum at the rim while the
        // middle channel stays close to the surface normal.
        let red = source.sample(&uv + &bend * &dispersion).red();
        let green = source.sample(&uv + &bend * 0.08).green();
        let blue = source.sample(&uv - &bend * (&dispersion * 0.78)).blue();
        let transmitted = rgba(red, green, blue, 0.94);

        let upper_reflection = (1.0
            - (uv.y() - (0.085 + (uv.x() * 5.1 + &phase).sin() * 0.016))
                .abs()
                .smoothstep(0.002, 0.028))
            * (1.0 - uv.x().smoothstep(0.56, 0.98));
        let veil = color(rgb(0xc8faff)).opacity(0.16 + &edge_light * 0.10);
        let glint = color(rgb(0xffffff)).opacity(upper_reflection * 0.76);

        glint.over(veil).over(transmitted)
    })
}

fn swatch_card(
    title: &'static str,
    note: &'static str,
    paint: Paint,
    edge: Paint,
) -> impl IntoElement {
    div()
        .w(px(158.0))
        .h(px(134.0))
        .relative()
        .overflow_hidden()
        .rounded(px(19.0))
        .border_1()
        .border_color(edge)
        .bg(paint)
        .child(
            div()
                .absolute()
                .left(px(15.0))
                .bottom(px(14.0))
                .flex()
                .flex_col()
                .gap(px(3.0))
                .text_color(rgb(0xffffff))
                .child(
                    div()
                        .text_size(px(12.0))
                        .font_weight(FontWeight::MEDIUM)
                        .child(title),
                )
                .child(
                    div()
                        .text_size(px(10.0))
                        .text_color(rgb(0xc1c5d4))
                        .child(note),
                ),
        )
}

/// A crisp piece of ordinary interface geometry placed behind the refractive
/// card. The card samples this retained content along with the shader scene.
fn scene_chart(left: f32, top: f32, width: f32, height: f32, time: f32) -> impl IntoElement {
    let rows = (0..4).map(move |index| {
        let y = 10.0 + index as f32 * (height - 20.0) / 3.0;
        let (tone, opacity, thickness) = if index % 4 == 0 {
            (rgb(0xa1f7ff), 0.72, 2.0)
        } else if index % 4 == 2 {
            (rgb(0xffb7eb), 0.56, 1.0)
        } else {
            (rgb(0xe1e9ff), 0.26, 1.0)
        };
        let length = width * (0.38 + ((index as f32 * 0.71 + time * 0.1).sin() * 0.5 + 0.5) * 0.62);
        div()
            .absolute()
            .left(px(0.0))
            .top(px(y))
            .w(px(length))
            .h(px(thickness))
            .bg(color(tone).opacity(opacity))
    });
    let chart = div()
        .absolute()
        .left(px(left))
        .top(px(top))
        .w(px(width))
        .h(px(height))
        .overflow_hidden()
        .children(rows);
    chart.when(height > 200.0, |this| {
        this.child(
            div()
                .absolute()
                .left(px(22.0))
                .top(px(150.0))
                .text_size(px(11.0))
                .font_weight(FontWeight::MEDIUM)
                .text_color(rgb(0xe8faff))
                .child("REFRACTION FIELD  /  08.42"),
        )
        .child(
            div()
                .absolute()
                .left(px(22.0))
                .top(px(170.0))
                .text_size(px(9.0))
                .text_color(rgb(0xe2eaff))
                .child("CHROMA OFFSET   +05.8 PX"),
        )
    })
}

struct Gallery {
    time: f32,
}
impl Render for Gallery {
    fn render(&mut self, window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        let width = f32::from(window.viewport_size().width);
        let height = f32::from(window.viewport_size().height);
        let compact = width < 1000.0;
        let tiny = width < 760.0 || height < 620.0;
        let time = self.time;
        let glass_width = if compact { width - 48.0 } else { 540.0 };
        let glass_left = if compact {
            24.0
        } else {
            width - glass_width - 58.0
        };
        let glass_top = if tiny {
            height - 200.0
        } else if compact {
            370.0
        } else {
            188.0
        };
        let glass_height = if tiny {
            150.0
        } else if compact {
            310.0
        } else {
            420.0
        };

        div()
            .relative()
            .size_full()
            .overflow_hidden()
            .bg(environment(time))
            .font_family("sans-serif")
            .text_color(rgb(0xffffff))
            .child(
                div()
                    .absolute()
                    .left(px(48.0))
                    .top(px(30.0))
                    .flex()
                    .items_center()
                    .gap(px(11.0))
                    .child(
                        div()
                            .size(px(29.0))
                            .rounded(px(9.0))
                            .bg(color(rgb(0xeffbff)).opacity(0.18))
                            .text_size(px(15.0))
                            .flex()
                            .items_center()
                            .justify_center()
                            .child("✳"),
                    )
                    .child(div().text_size(px(13.0)).child("GPUI / Shader studies"))
                    .child(
                        div()
                            .ml(px(4.0))
                            .px(px(9.0))
                            .py(px(5.0))
                            .rounded_full()
                            .bg(color(rgb(0xffffff)).opacity(0.10))
                            .text_size(px(10.0))
                            .text_color(rgb(0xe3eaf7))
                            .child("01 — 03"),
                    ),
            )
            .child(
                div()
                    .absolute()
                    .left(px(68.0))
                    .top(px(if tiny {
                        82.0
                    } else if compact {
                        112.0
                    } else {
                        184.0
                    }))
                    .w(px(if compact { width - 48.0 } else { 430.0 }))
                    .flex()
                    .flex_col()
                    .gap(px(18.0))
                    .child(
                        div()
                            .text_size(px(11.0))
                            .text_color(rgb(0xb6d6e2))
                            .child("MATERIALS / VOL. 01"),
                    )
                    .child(
                        div()
                            .flex()
                            .flex_col()
                            .text_size(px(if tiny {
                                39.0
                            } else if compact {
                                47.0
                            } else {
                                66.0
                            }))
                            .line_height(px(if tiny {
                                42.0
                            } else if compact {
                                51.0
                            } else {
                                69.0
                            }))
                            .font_weight(FontWeight::SEMIBOLD)
                            .child("Light,")
                            .child("composed."),
                    )
                    .when(!tiny, |this| {
                        this.child(
                            div()
                                .w(px(350.0))
                                .text_size(px(14.0))
                                .line_height(px(23.0))
                                .text_color(rgb(0xd1d8e8))
                                .child(
                                    "Small typed recipes, layered into native interface materials.",
                                ),
                        )
                    })
                    .when(!tiny, |this| {
                        this.child(
                            div()
                                .mt(px(5.0))
                                .flex()
                                .items_center()
                                .gap(px(10.0))
                                .child(
                                    div()
                                        .px(px(13.0))
                                        .py(px(8.0))
                                        .rounded_full()
                                        .bg(color(rgb(0xffffff)).opacity(0.93))
                                        .text_color(rgb(0x101524))
                                        .text_size(px(11.0))
                                        .child("Explore the layers  ↗"),
                                )
                                .child(
                                    div()
                                        .text_size(px(11.0))
                                        .text_color(rgb(0xe1d6ee))
                                        .child("Built from Paint"),
                                ),
                        )
                    }),
            )
            .child(scene_chart(
                glass_left,
                glass_top - 18.0,
                glass_width,
                glass_height + 36.0,
                time,
            ))
            .child(
                div()
                    .absolute()
                    .left(px(glass_left))
                    .top(px(glass_top))
                    .w(px(glass_width))
                    .h(px(glass_height))
                    .relative()
                    .overflow_hidden()
                    .rounded(px(30.0))
                    .border_1()
                    .border_color(spectral_edge(time))
                    .bg(liquid_glass(time))
                    .child(
                        div()
                            .absolute()
                            .left(px(29.0))
                            .top(px(26.0))
                            .right(px(29.0))
                            .flex()
                            .items_center()
                            .justify_between()
                            .text_size(px(11.0))
                            .child("OPTICAL STUDY   /   07")
                            .child(
                                div()
                                    .px(px(9.0))
                                    .py(px(5.0))
                                    .rounded_full()
                                    .bg(color(rgb(0xffffff)).opacity(0.20))
                                    .child("LIVE SURFACE"),
                            ),
                    )
                    .child(
                        div()
                            .absolute()
                            .left(px(30.0))
                            .bottom(px(28.0))
                            .right(px(30.0))
                            .flex()
                            .items_end()
                            .justify_between()
                            .child(
                                div()
                                    .flex()
                                    .flex_col()
                                    .gap(px(8.0))
                                    .child(
                                        div()
                                            .text_size(px(27.0))
                                            .font_weight(FontWeight::MEDIUM)
                                            .child("Liquid glass"),
                                    )
                                    .child(
                                        div()
                                            .text_size(px(12.0))
                                            .text_color(rgb(0xf0f4ff))
                                            .child("Chromatic refraction  ·  soft reflection"),
                                    ),
                            )
                            .child(
                                div()
                                    .size(px(38.0))
                                    .rounded_full()
                                    .border_1()
                                    .border_color(color(rgb(0xffffff)).opacity(0.68))
                                    .flex()
                                    .items_center()
                                    .justify_center()
                                    .text_size(px(16.0))
                                    .child("↗"),
                            ),
                    ),
            )
            .when(!compact, |this| {
                this.child(
                    div()
                        .absolute()
                        .left(px(68.0))
                        .top(px(560.0))
                        .flex()
                        .gap(px(12.0))
                        .children([
                            swatch_card(
                                "Aurora",
                                "field + mix",
                                aurora_material(time),
                                spectral_edge(time),
                            ),
                            swatch_card(
                                "Liquid ink",
                                "over + mask",
                                liquid_ink(time),
                                spectral_edge(time + 1.2),
                            ),
                        ]),
                )
            })
            .child(
                div()
                    .absolute()
                    .left(px(48.0))
                    .right(px(48.0))
                    .bottom(px(24.0))
                    .flex()
                    .justify_between()
                    .text_size(px(10.0))
                    .text_color(rgb(0xc6cde0))
                    .child("GPUI  /  Composable shader paints")
                    .child("BACKDROP · BORDER · LAYERS"),
            )
    }
}

struct Options {
    output: PathBuf,
    time: f32,
    viewport: Size<Pixels>,
}
impl Options {
    fn parse() -> anyhow::Result<Self> {
        let mut options = Self {
            output: "/tmp/gpui-shader-gallery.png".into(),
            time: 0.0,
            viewport: size(px(1280.0), px(800.0)),
        };
        let mut args = std::env::args().skip(1);
        while let Some(arg) = args.next() {
            match arg.as_str() {
                "--output" => {
                    options.output = args
                        .next()
                        .ok_or_else(|| anyhow::anyhow!("missing output path"))?
                        .into()
                }
                "--time" => {
                    options.time = args
                        .next()
                        .ok_or_else(|| anyhow::anyhow!("missing time"))?
                        .parse()?
                }
                "--size" => {
                    options.viewport = size(
                        px(args
                            .next()
                            .ok_or_else(|| anyhow::anyhow!("missing width"))?
                            .parse()?),
                        px(args
                            .next()
                            .ok_or_else(|| anyhow::anyhow!("missing height"))?
                            .parse()?),
                    )
                }
                _ => anyhow::bail!("unknown argument: {arg}"),
            }
        }
        anyhow::ensure!(
            options.time.is_finite()
                && f32::from(options.viewport.width).is_finite()
                && f32::from(options.viewport.height).is_finite(),
            "time and viewport must be finite"
        );
        anyhow::ensure!(
            f32::from(options.viewport.width) >= 640.0
                && f32::from(options.viewport.height) >= 480.0,
            "viewport must be at least 640 × 480"
        );
        Ok(options)
    }
}

fn main() -> anyhow::Result<()> {
    let options = Options::parse()?;
    let mut cx = HeadlessAppContext::with_platform(
        Arc::new(CosmicTextSystem::new("sans-serif")),
        Arc::new(()),
        || Some(Box::new(WgpuHeadlessRenderer::new().expect("GPU renderer"))),
    );
    let window = cx.open_window(options.viewport, |_, cx| {
        cx.new(|_| Gallery { time: options.time })
    })?;
    cx.update_window(window.into(), |_, window, cx| {
        window.draw(cx).clear(cx);
    })?;
    cx.capture_screenshot(window.into())?
        .save(&options.output)?;
    println!("Saved {}", options.output.display());
    Ok(())
}
