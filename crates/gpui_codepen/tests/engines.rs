#![cfg(not(target_family = "wasm"))]
use gpui::{MouseDownEvent, MouseUpEvent, PlatformInput, ScaledPixels, point, px, size};
use gpui_ce_codepen::{
    guest::PreviewContext,
    lessons::LESSONS,
    runtime::Runtime,
    session::{Backend, Reply, Request},
};
use std::{
    sync::{
        Arc,
        atomic::{AtomicU64, Ordering},
    },
    time::Instant,
};
fn execute(runtime: &mut Runtime, generation: u64, source: &str, input: PreviewContext) -> Reply {
    runtime.evaluate(
        Request {
            session_id: "engine-test".into(),
            generation,
            source: source.into(),
            backend: Backend::Miri,
            restart: false,
            input,
        },
        &AtomicU64::new(generation),
    )
}
const COUNTER: &str = r#"use gpui::{*,prelude::*};
struct Counter { count: u32 }
impl Render for Counter {
 fn render(&mut self,_:&mut Window,cx:&mut Context<Self>)->impl IntoElement {
  div().id("counter").w(px(200.)).h(px(100.)).bg(rgb(0x100000+self.count))
   .on_click(cx.listener(|this,_,_,cx|{this.count+=1;cx.notify();}))
 }
}
fn component(_:&mut Window,cx:&mut App)->Entity<Counter>{cx.new(|_|Counter{count:0})}
"#;
fn click() -> PreviewContext {
    PreviewContext {
        events: vec![
            PlatformInput::MouseDown(MouseDownEvent {
                position: point(px(20.), px(20.)),
                ..Default::default()
            }),
            PlatformInput::MouseUp(MouseUpEvent {
                position: point(px(20.), px(20.)),
                ..Default::default()
            }),
        ]
        .into_iter()
        .map(Into::into)
        .collect(),
        ..Default::default()
    }
}
#[test]
#[ignore = "requires setup.py and full vendored Miri"]
fn real_gpui_render_entities_events_edits_and_all_lessons() {
    let mut runtime = Runtime::new().unwrap();
    let first = execute(&mut runtime, 1, COUNTER, Default::default());
    assert!(first.frame.is_some(), "{}", first.diagnostics);
    let next = execute(&mut runtime, 2, COUNTER, click());
    assert!(next.frame.is_some(), "{}", next.diagnostics);
    assert_ne!(
        first.frame, next.frame,
        "actual GPUI click handler must mutate entity state"
    );
    let resized = execute(
        &mut runtime,
        3,
        COUNTER,
        PreviewContext {
            viewport: size(px(420.), px(300.)),
            scale_factor: 2.,
            ..Default::default()
        },
    );
    assert!(resized.frame.is_some(), "{}", resized.diagnostics);
    let scene = resized.frame.unwrap().scene.to_scene().unwrap();
    assert_eq!(scene.quads[0].bounds.size.width, ScaledPixels(400.));
    let edited = COUNTER.replace("this.count+=1", "this.count+=5");
    assert_ne!(edited, COUNTER);
    let source = execute(&mut runtime, 4, &edited, Default::default());
    assert!(source.frame.is_some(), "{}", source.diagnostics);
    let changed = execute(&mut runtime, 5, &edited, click());
    assert!(changed.frame.is_some(), "{}", changed.diagnostics);
    assert_ne!(source.frame, changed.frame);
    assert_ne!(next.frame, changed.frame);
    let start = Instant::now();
    let mut times = Vec::new();
    for index in 0..20 {
        let reply = execute(&mut runtime, 6 + index, &edited, click());
        assert!(reply.frame.is_some(), "{}", reply.diagnostics);
        times.push(reply.elapsed_ms);
    }
    times.sort_unstable();
    println!(
        "actual GPUI resident frames: median={} ms p95={} ms total={:?}",
        times[10],
        times[18],
        start.elapsed()
    );
    for (index, lesson) in LESSONS.iter().enumerate() {
        let reply = execute(
            &mut runtime,
            40 + index as u64,
            lesson.source,
            Default::default(),
        );
        assert!(
            reply.frame.is_some(),
            "{}: {}",
            lesson.title,
            reply.diagnostics
        );
        println!("{}: {} ms", lesson.title, reply.elapsed_ms);
    }
    let broken = execute(
        &mut runtime,
        50,
        "fn component( this is invalid",
        Default::default(),
    );
    assert!(broken.frame.is_none());
    assert!(!broken.diagnostics.is_empty());
    let recovered = execute(&mut runtime, 51, COUNTER, Default::default());
    assert!(recovered.frame.is_some(), "{}", recovered.diagnostics);
}
#[test]
#[ignore = "requires setup.py and full vendored Miri"]
fn cancellation_interrupts_interpreted_rust_and_recovers() {
    let latest = Arc::new(AtomicU64::new(1));
    let marker = latest.clone();
    let cancel = std::thread::spawn(move || {
        std::thread::sleep(std::time::Duration::from_secs(2));
        marker.store(2, Ordering::Relaxed);
    });
    let mut runtime = Runtime::new().unwrap();
    let looping = COUNTER.replace(
        "cx.new(|_|Counter{count:0})",
        "{loop {std::hint::black_box(1);} }",
    );
    let reply = runtime.evaluate(
        Request {
            session_id: "cancel-test".into(),
            generation: 1,
            source: looping,
            backend: Backend::Miri,
            restart: false,
            input: Default::default(),
        },
        &latest,
    );
    cancel.join().unwrap();
    assert!(reply.frame.is_none());
    assert!(
        reply.diagnostics.contains("Superseded"),
        "{}",
        reply.diagnostics
    );
    let recovered = execute(&mut runtime, 2, COUNTER, Default::default());
    assert!(recovered.frame.is_some(), "{}", recovered.diagnostics);
}

#[test]
#[ignore = "requires setup.py and full vendored Miri"]
fn profile_real_gpui_frames() {
    let mut runtime = Runtime::new().unwrap();
    for generation in 1..=4 {
        let reply = execute(
            &mut runtime,
            generation,
            COUNTER,
            if generation == 1 {
                Default::default()
            } else {
                click()
            },
        );
        assert!(reply.frame.is_some(), "{}", reply.diagnostics);
        println!("Counter frame {generation}: {} ms", reply.elapsed_ms);
    }
    let reply = execute(&mut runtime, 5, LESSONS[0].source, Default::default());
    assert!(reply.frame.is_some(), "{}", reply.diagnostics);
    println!("Text lesson: {} ms", reply.elapsed_ms);
}
