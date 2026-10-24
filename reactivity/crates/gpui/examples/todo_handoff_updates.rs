//! Exact full10k Todo source with origin-only updates through ordinary public APIs.
#[path = "support/todo_five.rs"]
#[expect(
    dead_code,
    reason = "This driver profiles the ordinary public animation source."
)]
mod todos;
use gpui::{
    Affine, Target, Win, WindowOptions,
    property::{Contribution, TRANSFORM},
};
use std::{hint::black_box, time::Instant};
fn origin(win: &mut Win<todos::Todos>, target: Target, index: u64) {
    let offset = 12. * (index as f32 / 120. * std::f32::consts::TAU).sin();
    win.set_property(
        target,
        TRANSFORM,
        Contribution::Set(Affine::translation(0., offset)),
    )
    .unwrap();
}
fn main() {
    let mut win = Win::recording(
        todos::Todos::seeded(10_000, false),
        WindowOptions {
            size: [540, 620],
            ..Default::default()
        },
    )
    .unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let mut target = None;
    win.visit(|part| {
        if target.is_none() {
            target = Some(part.target());
        }
    })
    .unwrap();
    let target = target.unwrap();
    let source = win.source_json().unwrap();
    let initial_scene = win.scene_digest().unwrap();
    for index in 1..=8 {
        origin(&mut win, target, index);
        win.presented(win.with_scene(|_, token| token).unwrap())
            .unwrap();
    }
    win.reset_counters().unwrap();
    let start = Instant::now();
    let mut scenes = Vec::with_capacity(64);
    let cost = allocation_counter::measure(|| {
        for index in 9..=72 {
            origin(&mut win, target, index);
            win.presented(win.with_scene(|_, token| token).unwrap())
                .unwrap();
            scenes.push(black_box(win.scene_digest().unwrap()));
        }
    });
    let ns = start.elapsed().as_nanos();
    assert_eq!(source, win.source_json().unwrap());
    let counters = win.counters();
    assert_eq!(counters.layout_runs, 0);
    assert_eq!(counters.measure_calls, 0);
    assert_eq!(counters.owner_reruns, 0);
    println!(
        "TODO_HANDOFF_UPDATES,{}",
        serde_json::json!({"rows":10000,"ticks":64,"wall_ns":ns,"allocations":cost.count_total,"requested_bytes":cost.bytes_total,"retained_delta_bytes":cost.bytes_current,"peak_extra_bytes":cost.bytes_max,"initial_scene":initial_scene,"scenes":scenes,"counters":counters,"source_equal":true})
    );
}
