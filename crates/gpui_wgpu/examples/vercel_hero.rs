//! A retained GPUI hero composed from an ordinary element background.
//!
//! ```sh
//! cargo run -p gpui_ce_wgpu --example vercel_hero --features test-support -- \
//!   --headless --output /tmp/hero.png --time 3 --pointer 720 350 --size 1280 720
//! ```
//!
//! The material is a reusable Rust function over typed fragment values. The
//! element supplies its bounds, coverage and paint order; there is no canvas or
//! shader root to create or retain.

#[cfg(any(target_os = "linux", target_os = "freebsd"))]
use gpui::Bounds;
use gpui::{
    AppContext, Context, FontWeight, HeadlessAppContext, InteractiveElement, IntoElement,
    ParentElement, Pixels, Render, Size, StatefulInteractiveElement, Styled, Window, div, px, rgb,
    shader::{Field, Paint, color, constant, shader, vec2},
    size,
};
use gpui_ce_wgpu::{CosmicTextSystem, WgpuHeadlessRenderer};
use std::{path::PathBuf, sync::Arc, time::Instant};

/// Distance to a finite line segment, with its endpoints expressed in the
/// triangle's local coordinate system.
fn segment_distance(point: &Field<[f32; 2]>, start: [f32; 2], end: [f32; 2]) -> Field<f32> {
    let a = constant(start);
    let edge = constant([end[0] - start[0], end[1] - start[1]]);
    let offset = point - &a;
    let projection = (offset.dot(&edge) / edge.dot(&edge)).clamp(0.0, 1.0);
    (&offset - &edge * projection).length()
}

/// An equilateral neon triangle with a moving specular light and soft floor.
/// Ordinary Rust values become uniforms when they meet a symbolic field, so
/// time, pointer and intensity can change without changing the recipe.
fn triangle_material(
    time: f32,
    pointer: [f32; 2],
    intensity: f32,
    center: [f32; 2],
    scale: f32,
) -> Paint {
    shader(move |pixel| {
        let p = (pixel.position() - center) / scale;
        let a = [0.0, -110.0];
        let b = [-95.2628, 55.0];
        let c = [95.2628, 55.0];
        let edge_distance = segment_distance(&p, a, b)
            .min(segment_distance(&p, b, c))
            .min(segment_distance(&p, c, a));

        // The two half-planes of an upright equilateral triangle determine
        // whether the closest edge distance is inside or outside.
        let horizontal = p.x().abs() * 0.866_025_4 - p.y() * 0.5 - 55.0;
        let vertical = p.y() - 55.0;
        let outside = horizontal.max(vertical).gt(0.0);
        let distance = outside.select(&edge_distance, -&edge_distance);
        let edge = distance.abs();
        let edge_width = distance.fwidth().max(0.75);
        let body_coverage = 1.0 - distance.smoothstep(-&edge_width, &edge_width);

        let phase: Field<f32> = time.into();
        let pointer: Field<[f32; 2]> = pointer.into();
        let pointer = pointer / scale;
        let intensity: Field<f32> = intensity.into();
        let light = vec2(
            phase.sin() * 21.0 - 62.0 + pointer.x() * 0.14,
            phase.cos() * 15.0 - 48.0 + pointer.y() * 0.14,
        );
        let light_distance = (&p - &light).length() / 96.0;
        let falloff = &light_distance * &light_distance + 1.0;
        let illumination = 1.0 / falloff;
        let rim_coverage = 1.0 - edge.smoothstep(0.0, 2.2);
        let body = color(rgb(0x090d17)).mask(body_coverage);
        let rim = color(rgb(0x668dff))
            .mix(color(rgb(0xf0fcff)), &illumination)
            .opacity(&rim_coverage * &illumination * &intensity);
        let halo = color(rgb(0x8acbff))
            .opacity((1.0 - edge.smoothstep(2.0, 46.0)) * &illumination * &intensity * 0.62);
        let floor = color(rgb(0x76aaff)).opacity(
            (1.0 - (p.y() - 58.0).abs().smoothstep(0.0, 2.0))
                * (1.0 - (p.x().abs() / 132.0).smoothstep(0.0, 1.0))
                * &illumination
                * &intensity
                * 0.48,
        );
        let mist = color(rgb(0x789cff)).opacity(
            (1.0 - (&p - constant([-35.0, 42.0]))
                .length()
                .smoothstep(0.0, 115.0))
                * &intensity
                * 0.055,
        );

        rim.over(body)
            .over(floor)
            .over(mist)
            .over(halo)
            .over(color(rgb(0x05070c)))
    })
}

struct Hero {
    started: Instant,
    time: f32,
    pointer: [f32; 2],
    animate: bool,
    bright: bool,
}
impl Hero {
    fn new(options: &Options, animate: bool) -> Self {
        Self {
            started: Instant::now(),
            time: options.time,
            pointer: options.pointer,
            animate,
            bright: true,
        }
    }
}
impl Render for Hero {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let viewport = window.viewport_size();
        if self.animate {
            window.request_animation_frame();
        }
        let time = self.time
            + if self.animate {
                self.started.elapsed().as_secs_f32() * 0.35
            } else {
                0.0
            };
        let width = f32::from(viewport.width);
        let height = f32::from(viewport.height);
        let compact = width < 1000.0;
        let center = if compact {
            [width * 0.72, height * 0.61]
        } else {
            [width * 0.73, height * 0.58 + 20.0]
        };
        let scale = (width * 0.45 / 190.5)
            .min(height * 0.64 / 165.0)
            .clamp(1.1, 1.9);
        let intensity = if self.bright { 1.0 } else { 0.3 };
        let pointer = [
            self.pointer[0] - (center[0] - width * 0.5),
            self.pointer[1] - (center[1] - height * 0.5),
        ];
        let paint = triangle_material(time, pointer, intensity, center, scale);
        let headline_size = if compact { 40.0 } else { 66.0 };
        let headline_left = if compact { 24.0 } else { width * 0.10 };

        div()
            .relative()
            .size_full()
            .bg(paint)
            .text_color(rgb(0xffffff))
            .font_family("sans-serif")
            .on_mouse_move(
                cx.listener(move |this, event: &gpui::MouseMoveEvent, _, cx| {
                    this.pointer = [
                        f32::from(event.position.x) - width * 0.5,
                        f32::from(event.position.y) - height * 0.5,
                    ];
                    cx.notify();
                }),
            )
            .child(
                div()
                    .absolute()
                    .left(px(24.0))
                    .top(px(20.0))
                    .text_size(px(25.0))
                    .child("▲"),
            )
            .child(
                div()
                    .absolute()
                    .left(px(72.0))
                    .top(px(25.0))
                    .flex()
                    .gap(px(28.0))
                    .text_size(px(14.0))
                    .child("GPUI  /  Graphics laboratory"),
            )
            .child(
                div()
                    .absolute()
                    .right(px(24.0))
                    .top(px(25.0))
                    .text_size(px(14.0))
                    .child(if compact {
                        "01 / Hero"
                    } else {
                        "01 / Interactive material study"
                    }),
            )
            .child(
                div()
                    .absolute()
                    .left(px(24.0))
                    .top(px(if compact { 70.0 } else { 115.0 }))
                    .text_size(px(13.0))
                    .text_color(rgb(0xa1a1a1))
                    .child("GPUI + WebGPU  /  Composable by design"),
            )
            .child(
                div()
                    .absolute()
                    .left(px(headline_left))
                    .top(px(height * 0.5 - if compact { 140.0 } else { 125.0 }))
                    .flex()
                    .flex_col()
                    .text_size(px(headline_size))
                    .line_height(px(headline_size))
                    .font_weight(FontWeight::SEMIBOLD)
                    .child("Composable")
                    .child("Graphics")
                    .child(
                        div()
                            .mt(px(27.0))
                            .flex()
                            .gap(px(12.0))
                            .text_size(px(14.0))
                            .line_height(px(20.0))
                            .child(
                                div()
                                    .id("light")
                                    .px(px(24.0))
                                    .py(px(12.0))
                                    .rounded_full()
                                    .bg(rgb(0xffffff))
                                    .text_color(rgb(0x000000))
                                    .cursor_pointer()
                                    .on_click(cx.listener(|this, _, _, cx| {
                                        this.bright = !this.bright;
                                        cx.notify();
                                    }))
                                    .child(if self.bright {
                                        "Dim light"
                                    } else {
                                        "Brighten light"
                                    }),
                            )
                            .child(
                                div()
                                    .id("motion")
                                    .px(px(24.0))
                                    .py(px(12.0))
                                    .rounded_full()
                                    .border_1()
                                    .border_color(rgb(0x383838))
                                    .cursor_pointer()
                                    .on_click(cx.listener(|this, _, _, cx| {
                                        if this.animate {
                                            this.time +=
                                                this.started.elapsed().as_secs_f32() * 0.35;
                                        }
                                        this.started = Instant::now();
                                        this.animate = !this.animate;
                                        cx.notify();
                                    }))
                                    .child(if self.animate {
                                        "Pause motion"
                                    } else {
                                        "Resume motion"
                                    }),
                            ),
                    ),
            )
            .child(
                div()
                    .absolute()
                    .left(px(headline_left))
                    .top(px(height * if compact { 0.81 } else { 0.80 }))
                    .flex()
                    .flex_col()
                    .gap(px(8.0))
                    .text_size(px(if compact { 16.0 } else { 18.0 }))
                    .line_height(px(25.0))
                    .children(["Typed recipes.", "Native elements.", "Shared primitives."]),
            )
    }
}

struct Options {
    output: PathBuf,
    time: f32,
    pointer: [f32; 2],
    viewport: Size<Pixels>,
    headless: bool,
}
impl Options {
    fn parse() -> anyhow::Result<Self> {
        let mut options = Self {
            output: "/tmp/gpui-vercel-hero.png".into(),
            time: 0.0,
            pointer: [0.0, 0.0],
            viewport: size(px(1280.0), px(720.0)),
            headless: false,
        };
        let mut pointer = None;
        let mut args = std::env::args().skip(1);
        while let Some(arg) = args.next() {
            match arg.as_str() {
                "--headless" => options.headless = true,
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
                "--pointer" => {
                    pointer = Some([
                        args.next()
                            .ok_or_else(|| anyhow::anyhow!("missing pointer x"))?
                            .parse::<f32>()?,
                        args.next()
                            .ok_or_else(|| anyhow::anyhow!("missing pointer y"))?
                            .parse::<f32>()?,
                    ]);
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
        if let Some([x, y]) = pointer {
            options.pointer = [
                x - f32::from(options.viewport.width) * 0.5,
                y - f32::from(options.viewport.height) * 0.5,
            ];
        }
        anyhow::ensure!(
            f32::from(options.viewport.width).is_finite()
                && f32::from(options.viewport.height).is_finite(),
            "viewport must be finite"
        );
        anyhow::ensure!(
            options.time.is_finite() && options.pointer.into_iter().all(f32::is_finite),
            "parameters must be finite"
        );
        anyhow::ensure!(
            f32::from(options.viewport.width) >= 640.0
                && f32::from(options.viewport.height) >= 480.0,
            "viewport must be at least 640 × 480"
        );
        Ok(options)
    }
}
fn headless(options: &Options) -> anyhow::Result<()> {
    let mut cx = HeadlessAppContext::with_platform(
        Arc::new(CosmicTextSystem::new("sans-serif")),
        Arc::new(()),
        || Some(Box::new(WgpuHeadlessRenderer::new().expect("GPU renderer"))),
    );
    let window = cx.open_window(options.viewport, |_, cx| {
        cx.new(|_| Hero::new(options, false))
    })?;
    cx.update_window(window.into(), |_, window, cx| {
        window.draw(cx).clear(cx);
    })?;
    cx.capture_screenshot(window.into())?
        .save(&options.output)?;
    println!("Saved {}", options.output.display());
    Ok(())
}
#[cfg(any(target_os = "linux", target_os = "freebsd"))]
fn native(options: Options) {
    gpui_platform::application().run(move |cx: &mut gpui::App| {
        cx.open_window(
            gpui::WindowOptions {
                window_bounds: Some(gpui::WindowBounds::Windowed(Bounds::centered(
                    None,
                    options.viewport,
                    cx,
                ))),
                ..Default::default()
            },
            |_, cx| cx.new(|_| Hero::new(&options, true)),
        )
        .expect("hero window");
        cx.activate(true);
    });
}
fn main() -> anyhow::Result<()> {
    let options = Options::parse()?;
    #[cfg(any(target_os = "linux", target_os = "freebsd"))]
    if !options.headless {
        native(options);
        return Ok(());
    }
    headless(&options)
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui::{Modifiers, MouseButton, MouseDownEvent, MouseUpEvent, PlatformInput, point};

    #[test]
    fn retained_hero_tracks_pointer_and_responds_to_controls() -> anyhow::Result<()> {
        let mut cx = HeadlessAppContext::with_platform(
            Arc::new(CosmicTextSystem::new("sans-serif")),
            Arc::new(()),
            || Some(Box::new(WgpuHeadlessRenderer::new().expect("GPU renderer"))),
        );
        let viewport = size(px(1280.0), px(720.0));
        let window = cx.open_window(viewport, |_, cx| {
            cx.new(|_| Hero {
                started: Instant::now(),
                time: 0.0,
                pointer: [0.0, 0.0],
                animate: true,
                bright: true,
            })
        })?;
        cx.update_window(window.into(), |_, window, cx| {
            window.draw(cx).clear(cx);
        })?;
        cx.run_until_parked();
        let hero = window.root(&mut cx)?;

        cx.update_window(window.into(), |_, window, cx| {
            window.simulate_mouse_move(point(px(900.0), px(400.0)), cx);
        })?;
        cx.run_until_parked();
        let pointer = cx.update(|cx| hero.read(cx).pointer);
        assert_eq!(pointer, [260.0, 40.0]);

        let click = |cx: &mut HeadlessAppContext, position| {
            cx.update_window(window.into(), |_, window, cx| {
                window.dispatch_event(
                    PlatformInput::MouseDown(MouseDownEvent {
                        position,
                        modifiers: Modifiers::none(),
                        button: MouseButton::Left,
                        click_count: 1,
                        first_mouse: false,
                    }),
                    cx,
                );
                window.dispatch_event(
                    PlatformInput::MouseUp(MouseUpEvent {
                        position,
                        modifiers: Modifiers::none(),
                        button: MouseButton::Left,
                        click_count: 1,
                    }),
                    cx,
                );
            })?;
            cx.run_until_parked();
            Ok::<_, anyhow::Error>(())
        };

        click(&mut cx, point(px(180.0), px(416.0)))?;
        assert!(!cx.update(|cx| hero.read(cx).bright));
        click(&mut cx, point(px(310.0), px(416.0)))?;
        assert!(!cx.update(|cx| hero.read(cx).animate));

        Ok(())
    }
}
