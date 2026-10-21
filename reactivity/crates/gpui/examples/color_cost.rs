//! Author-color access and retained-style cost. Run fresh processes; output CSV.
use gpui::{Color, ColorSpace, El, Style, View, Win, WindowOptions, column, div};
use std::{hint::black_box, time::Instant};

#[inline(never)]
pub fn decoded(color: Color) -> [f32; 4] {
    color.channels()
}
#[inline(never)]
pub fn alpha_only(color: Color) -> f32 {
    color.alpha()
}
#[inline(never)]
pub fn space_only(color: Color) -> ColorSpace {
    color.space()
}

struct Styles {
    count: usize,
    unique: bool,
}
impl View for Styles {
    fn view(&self) -> El<'_> {
        column((0..self.count).map(|i| {
            let color = if self.unique {
                Color::rgb(i as u8, (i >> 8) as u8, 127)
            } else {
                Color::BLACK
            };
            div().w(100).h(1).bg(color)
        }))
    }
}
fn main() {
    println!("headers,color,style,el,canvas");
    println!(
        "bytes,{},{},{},{}",
        size_of::<Color>(),
        size_of::<Style>(),
        size_of::<El<'_>>(),
        size_of::<gpui_canvas::Canvas>()
    );
    let colors = [
        Color::rgb(10, 80, 250),
        Color::display_p3(-0.3, 1.5, 0.2, 0.7).unwrap(),
        Color::linear_display_p3(4., -2., 0.5, 0.8).unwrap(),
        Color::linear_srgb(-4., 8., 0.5, 0.9).unwrap(),
        Color::oklch(0.7, 0.2, 130., 0.6).unwrap(),
    ];
    println!("operation,space,nanos_per_color");
    for color in colors {
        for op in ["channels", "alpha", "space", "working", "equal"] {
            let start = Instant::now();
            for _ in 0..1_000_000 {
                let c = black_box(color);
                match op {
                    "channels" => {
                        black_box(decoded(c));
                    }
                    "alpha" => {
                        black_box(alpha_only(c));
                    }
                    "space" => {
                        black_box(space_only(c));
                    }
                    "working" => {
                        black_box(c.to_linear_srgb());
                    }
                    "equal" => {
                        black_box(c == black_box(color));
                    }
                    _ => unreachable!(),
                }
            }
            println!(
                "{op},{:?},{:.3}",
                color.space(),
                start.elapsed().as_nanos() as f64 / 1e6
            );
        }
    }
    println!("styles,count,prepare_us,retained_bytes,peak_bytes,allocations,nodes");
    for count in [1, 1000, 10000] {
        for unique in [false, true] {
            let start = Instant::now();
            let mut mounted = None;
            let stats = allocation_counter::measure(|| {
                mounted = Some(
                    Win::recording(
                        Styles { count, unique },
                        WindowOptions {
                            size: [120, 64],
                            ..Default::default()
                        },
                    )
                    .unwrap(),
                );
            });
            let mut win = mounted.unwrap();
            let us = start.elapsed().as_secs_f64() * 1e6;
            let token = win.with_scene(|_, token| token).unwrap();
            win.presented(token).unwrap();
            println!(
                "{unique},{count},{us:.3},{},{},{},{}",
                stats.bytes_current,
                stats.bytes_max,
                stats.count_total,
                win.inspect().unwrap().nodes.len()
            );
            black_box(win);
        }
    }
}
