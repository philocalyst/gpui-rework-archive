//! The gallery view: one card per way of writing a shader.

use std::{
    f32::consts::TAU,
    sync::LazyLock,
    time::{Duration, Instant},
};

use gpui::{
    AnyElement, Context, IntoElement, ParentElement, Render, Styled, Window, canvas, div, px, rgb,
    shader::{
        self, Function, Input, Paint, Pipeline, Shader, Vec2f, Vec3, color, constant, iterate,
        noise, paint, rgba, shape, vec2, vec2f, vec3, vec3f,
    },
    white,
};

/// A paint from a traditional `.wgsl` file. `Shader` finds its `paint` entry
/// point and checks parameters when the paint compiles.
static PLASMA: LazyLock<Shader> =
    LazyLock::new(|| Shader::wgsl(include_str!("plasma.wgsl")).expect("plasma.wgsl"));

/// Written once, in Rust: `#[wgsl]` transpiles it for the GPU, and the same
/// function runs on the CPU for constant folding and fallbacks.
#[wgsl_rs::wgsl]
#[allow(missing_docs)]
pub mod ripples {
    use wgsl_rs::std::*;

    pub fn ripple(point: Vec2f, time: f32) -> f32 {
        let distance = length(point);
        let wave = sin(distance * 0.2 - time * 4.0) * 0.5 + 0.5;
        wave * exp(-distance * 0.015)
    }
}

static RIPPLE: LazyLock<Function<fn(Vec2f, f32) -> f32>> =
    LazyLock::new(|| gpui::wgsl_fn!(ripples::ripple).expect("ripple"));

/// Custom geometry: each instance is a soft spark. GPUI generates the entry
/// points, clipping, opacity, and blending; positions are logical pixels from
/// the draw's origin.
const SPARKS_WGSL: &str = "
struct Spark { position: vec2<f32>, local: vec2<f32> }

fn vertex(index: u32, center: vec2<f32>, radius: f32, tint: vec4<f32>) -> Spark {
    let corner = vec2<f32>(f32(index & 1u), f32(index >> 1u)) * 2.0 - 1.0;
    return Spark(center + corner * radius, corner);
}

fn fragment(spark: Spark, center: vec2<f32>, radius: f32, tint: vec4<f32>) -> vec4<f32> {
    let glow = exp(-dot(spark.local, spark.local) * 5.0);
    return vec4<f32>(tint.rgb, tint.a * glow);
}
";

static SPARKS: LazyLock<Pipeline> =
    LazyLock::new(|| Pipeline::wgsl(SPARKS_WGSL).expect("the sparks pipeline"));

const CARD: f32 = 200.0;
const INK: u32 = 0x0e1120;

/// Ordinary Rust over typed expressions. Plain numbers become uniforms, so
/// rebuilding this every frame with a new `time` reuses one compiled program.
pub fn waves(time: f32) -> Paint {
    paint(|px| {
        let uv = px.uv();
        let wave = (uv.x() * 9.0 + uv.y() * 4.0 + time * 2.0).sin() * 0.5 + 0.5;
        color(rgb(0x315bff)).mix(color(rgb(0xf48bcb)), wave)
    })
}

/// Signed distance fields compose with plain math, then clip a paint with an
/// antialiased edge.
pub fn orbits(time: f32) -> Paint {
    paint(|px| {
        let p = px.centered();
        let ring = shape::circle(&p, 52.0).abs() - 2.5;
        let moon = shape::circle(&p - vec2(time.cos() * 52.0, time.sin() * 52.0), 11.0);
        let core = shape::circle(&p, 18.0 + (time * 3.0).sin() * 3.0);
        let body = shape::smooth_union(ring, moon, 12.0).min(core);
        color(rgb(0xffd166)).clip(body).over(color(rgb(0x1a1f3a)))
    })
}

pub fn aurora(time: f32) -> Paint {
    paint(|px| {
        let uv = px.uv();
        let drift = noise::value(&uv * vec2(3.0, 5.0) + vec2(time * 0.3, time * 0.1));
        let band = ((uv.y() + drift * 0.35) * 9.0 - time).sin().abs();
        let glow = (1.0 - band).pow(6.0) * (1.0 - uv.y() * 0.6);
        color(rgb(0x3ee6b0))
            .mix(color(rgb(0x7b5cff)), uv.x())
            .mask(glow)
            .over(color(rgb(0x060914)))
    })
}

/// Fractal clouds: five octaves of noise in one GPU loop.
pub fn clouds(time: f32) -> Paint {
    paint(|px| {
        let p = px.uv() * 3.0 + vec2(time * 0.15, time * 0.05);
        let fbm = iterate(5, vec2(0.0, 0.5), |acc, octave| {
            let scale = constant(2.0).pow(octave);
            vec2(acc.x() + noise::value(&p * &scale) * acc.y(), acc.y() * 0.5)
        });
        color(rgb(0x1b2a6b)).mix(color(rgb(0xf6d6ff)), fbm.x().smoothstep(0.25, 0.85))
    })
}

/// A torus, raymarched in pure Rust expressions and lit with diffuse,
/// specular, and rim light. The pointer turns it.
pub fn torus(input: &Input) -> Paint {
    let turn = (input.pointer - input.size * 0.5) / input.size.y;
    let yaw = turn.x * 3.0 + input.time * 0.5;
    let pitch = 0.6 + turn.y * 2.0;
    let light = wgsl_rs::std::normalize(vec3f(-0.5, 0.8, -0.6));
    paint(|px| {
        let uv = px.centered() / px.size().y();
        let origin = Vec3::constant(vec3f(0.0, 0.0, -4.4));
        let ray = vec3(uv.x(), -uv.y(), 1.5).normalize();
        let scene = |p: &Vec3| {
            let tilted = vec2(p.y(), p.z()).rotate(pitch);
            let spun = vec2(p.x(), tilted.y()).rotate(yaw);
            let ring = vec2(spun.length() - 0.9, tilted.x()).length();
            ring - 0.34
        };
        let t = shape::raymarch(&origin, &ray, 8.0, 80, scene);
        let normal = shape::normal(&(&origin + &ray * &t), scene);
        let diffuse = normal.dot(light).max(0.0);
        let halfway = (Vec3::constant(light) - &ray).normalize();
        let specular = normal.dot(halfway).max(0.0).pow(48.0);
        let rim = (normal.dot(&ray) + 1.0).pow(3.0);
        let shade = vec3(1.0, 0.42, 0.24) * (diffuse * 0.85 + 0.1)
            + vec3(0.5, 0.7, 1.0) * rim * 0.7
            + Vec3::splat(specular);
        let surface = rgba(shade.x(), shade.y(), shade.z(), 1.0);
        let backdrop = color(rgb(0x0b0e1c)).mix(color(rgb(0x1d2645)), px.uv().y());
        surface.select(t.lt(8.0), backdrop)
    })
}

/// A field of dots that swell and brighten around the pointer.
pub fn spotlight(input: &Input) -> Paint {
    let (pointer, hover) = (input.pointer, input.hover);
    paint(|px| {
        let cell = (px.position() / 14.0).fract() - 0.5;
        let near = (1.0 - (px.position() - pointer).length() / 90.0).max(0.0);
        let dot = shape::circle(cell, &near * hover * 0.3 + 0.1);
        let tint = color(rgb(0x7cf0ff)).mix(color(white()), &near * hover);
        tint.clip(dot)
            .opacity(near * hover * 0.8 + 0.2)
            .over(color(rgb(0x0b0e1c)))
    })
}

/// A checkerboard, swirled by remapping where it is sampled.
pub fn swirl(time: f32) -> Paint {
    let checker = paint(|px| {
        let cell = (px.position() / 16.0).floor();
        let parity = ((cell.x() + cell.y()) * 0.5).fract() * 2.0;
        color(rgb(0x1a1f3a)).mix(color(rgb(0xe8ecff)), parity)
    });
    checker.map_uv(|uv| {
        let centered = uv - 0.5;
        let twist = (0.5 - centered.length()).max(0.0) * 5.0 * time.sin();
        centered.rotate(twist) + 0.5
    })
}

pub fn plasma(time: f32) -> Paint {
    // Raw WGSL has no CPU twin, so name a color for renderers without shaders.
    PLASMA.with(time).fallback(rgb(0x7b5cff))
}

pub fn ripple(time: f32) -> Paint {
    paint(|px| {
        let wave = RIPPLE.call((px.centered(), time));
        color(rgb(0x0b1d3a)).mix(color(rgb(0x5ad1ff)), wave)
    })
}

/// A hue sweep around the box's center, for a border.
pub fn rainbow(time: f32) -> Paint {
    paint(|px| {
        let p = px.centered();
        let turn = p.y().atan2(p.x()) + time;
        let hue = (Vec3::splat(turn) + vec3(0.0, 2.1, 4.2)).cos() * 0.5 + 0.5;
        rgba(hue.x(), hue.y(), hue.z(), 1.0)
    })
}

pub fn stripes(time: f32) -> Paint {
    paint(|px| {
        let position = px.position();
        let band = ((position.x() + position.y()) / 10.0 - time * 3.0)
            .sin()
            .step(0.0);
        color(rgb(0xff5f6d)).mix(color(rgb(0xffc371)), band)
    })
}

/// Glass: the scene behind the box, magnified with a little chromatic split.
pub fn lens() -> Paint {
    paint(|px| {
        let offset = px.uv() - 0.5;
        let zoom = |amount: f32| px.backdrop(&offset * amount + 0.5);
        let channel = rgba(zoom(0.70).red(), zoom(0.72).green(), zoom(0.74).blue(), 1.0);
        color(white()).opacity(0.12).over(channel)
    })
}

/// Every paint in the gallery, for checks.
pub fn paints(time: f32) -> Vec<(&'static str, Paint)> {
    vec![
        ("waves", waves(time)),
        ("orbits", orbits(time)),
        ("aurora", aurora(time)),
        ("swirl", swirl(time)),
        ("plasma", plasma(time)),
        ("ripple", ripple(time)),
        ("rainbow", rainbow(time)),
        ("stripes", stripes(time)),
        ("lens", lens()),
        ("clouds", clouds(time)),
        ("torus", torus(&sample_input(time))),
        ("spotlight", spotlight(&sample_input(time))),
    ]
}

/// What a 200px layer sees with the pointer just right of center.
fn sample_input(time: f32) -> Input {
    Input {
        time,
        size: vec2f(CARD, CARD),
        pointer: vec2f(CARD * 0.6, CARD * 0.5),
        hover: 1.0,
        pressed: false,
    }
}

pub struct Gallery {
    start: Instant,
    frozen: Option<f32>,
}

impl Gallery {
    pub fn new() -> Self {
        Self {
            start: Instant::now(),
            frozen: None,
        }
    }

    /// A gallery stopped at `time` seconds.
    pub fn frozen(time: f32) -> Self {
        Self {
            start: Instant::now() - Duration::from_secs_f32(time),
            frozen: Some(time),
        }
    }
}

fn card(title: &'static str, surface: impl IntoElement) -> impl IntoElement {
    div()
        .flex()
        .flex_col()
        .gap_2()
        .child(surface)
        .child(div().text_sm().text_color(rgb(0xaab3d0)).child(title))
}

fn surface() -> gpui::Div {
    div().size(px(CARD)).rounded(px(20.0)).overflow_hidden()
}

/// A card whose paint follows the pointer and time.
fn layer(id: &'static str, paint: impl Fn(&Input) -> Paint + 'static) -> shader::Layer {
    shader::layer(id, paint)
        .animate()
        .size(px(CARD))
        .rounded(px(20.0))
}

fn sparks(time: f32) -> AnyElement {
    canvas(
        |_, _, _| {},
        move |bounds, _, window, _| {
            let center = [
                f32::from(bounds.size.width) / 2.0,
                f32::from(bounds.size.height) / 2.0,
            ];
            let instances = (0..64).map(|index| {
                let along = index as f32 / 64.0;
                let angle = along * TAU * 3.0 + time * (0.5 + along);
                let reach = 16.0 + along * 74.0;
                let tint = [1.0 - along * 0.6, 0.4 + along * 0.5, 1.0, 0.9];
                let position = [
                    center[0] + angle.cos() * reach,
                    center[1] + angle.sin() * reach,
                ];
                (position, 4.0 + along * 10.0, tint)
            });
            window.paint_pipeline(&SPARKS, bounds, instances);
        },
    )
    .size_full()
    .into_any_element()
}

impl Render for Gallery {
    fn render(&mut self, window: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        let time = self
            .frozen
            .unwrap_or_else(|| self.start.elapsed().as_secs_f32());
        if self.frozen.is_none() {
            window.request_animation_frame();
        }
        let status = if window.supports_shader_paint() {
            "Running on the GPU."
        } else {
            "This renderer cannot run shaders: paints show their fallbacks."
        };

        div()
            .size_full()
            .bg(rgb(INK))
            .p_6()
            .flex()
            .flex_col()
            .gap_4()
            .child(
                div()
                    .flex()
                    .flex_col()
                    .child(div().text_xl().text_color(white()).child("Shader paints"))
                    .child(div().text_sm().text_color(rgb(0x6f7898)).child(status)),
            )
            .child(
                div()
                    .flex()
                    .flex_wrap()
                    .gap_4()
                    .child(card("Expressions", surface().bg(waves(time))))
                    .child(card("Signed distances", surface().bg(orbits(time))))
                    .child(card("Noise", surface().bg(aurora(time))))
                    .child(card("Loops", surface().bg(clouds(time))))
                    .child(card("Remapped", surface().bg(swirl(time))))
                    .child(card("A .wgsl file", surface().bg(plasma(time))))
                    .child(card("A #[wgsl] module", surface().bg(ripple(time))))
                    .child(card("Raymarched 3D", layer("torus", torus)))
                    .child(card(
                        "Borders",
                        surface()
                            .border(px(6.0))
                            .border_color(rainbow(time))
                            .bg(rgb(0x1a1f3a)),
                    ))
                    .child(card(
                        "Backdrop",
                        surface().relative().bg(stripes(time)).child(
                            div()
                                .absolute()
                                .top(px(40.0))
                                .left(px(40.0))
                                .size(px(120.0))
                                .rounded(px(60.0))
                                .bg(lens()),
                        ),
                    ))
                    .child(card("Pointer", layer("spotlight", spotlight)))
                    .child(card(
                        "A custom pipeline",
                        surface().bg(rgb(0x060914)).child(sparks(time)),
                    )),
            )
    }
}
