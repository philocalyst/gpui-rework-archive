#![cfg(not(target_family = "wasm"))]
//! End-to-end real Rust execution and interactive latency, using vendored Miri.
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
            session_id: "engine-tests".into(),
            generation,
            source: source.into(),
            backend: Backend::Miri,
            restart: false,
            input,
        },
        &AtomicU64::new(generation),
    )
}
#[test]
#[ignore = "requires setup.py: real pinned Rust and vendored Miri"]
fn persistent_rust_interaction_edit_errors_and_cancellation() {
    let mut runtime = Runtime::new().unwrap();
    for (index, lesson) in LESSONS.iter().enumerate() {
        let reply = execute(&mut runtime, 1, lesson.source, PreviewContext::default());
        assert!(
            reply.frame.is_some(),
            "lesson {index}: {}",
            reply.diagnostics
        );
        println!("{}: first render {} ms", lesson.title, reply.elapsed_ms);
    }
    let first = execute(
        &mut runtime,
        2,
        LESSONS[3].source,
        PreviewContext::default(),
    );
    assert!(first.frame.is_some(), "{}", first.diagnostics);
    let mut state = first.frame.unwrap().state;
    let mut times = vec![];
    let start = Instant::now();
    for generation in 3..23 {
        let reply = execute(
            &mut runtime,
            generation,
            LESSONS[3].source,
            PreviewContext {
                state,
                event: Some("increment".into()),
            },
        );
        assert!(reply.frame.is_some(), "{}", reply.diagnostics);
        times.push(reply.elapsed_ms);
        state = reply.frame.unwrap().state;
        assert_eq!(
            state["count"],
            generation - 2,
            "all rapid interactions must commit once"
        );
    }
    times.sort();
    println!(
        "20 resident clicks: {} ms total; median {} ms; max {} ms",
        start.elapsed().as_millis(),
        times[10],
        times[19]
    );
    // A loose regression ceiling still rules out recompilation per interaction.
    assert!(times[10] < 250, "resident clicks too slow: {times:?}");
    let changed = LESSONS[3].source.replace("count += 1", "count += 5");
    let edited = execute(
        &mut runtime,
        24,
        &changed,
        PreviewContext {
            state,
            event: Some("increment".into()),
        },
    );
    assert_eq!(
        edited.frame.as_ref().expect(&edited.diagnostics).state["count"],
        25
    );
    println!("Source edit including compile: {} ms", edited.elapsed_ms);
    // Reset must restart the resident interpreter, including Rust globals.
    let globals = "use gpui_codepen_guest::*; static N: std::sync::atomic::AtomicUsize = std::sync::atomic::AtomicUsize::new(0); fn render(cx: &mut PreviewContext) -> Node { let n = N.fetch_add(1, std::sync::atomic::Ordering::Relaxed); cx.state = json!({\"global\":n}); div().child(n.to_string()).into() }";
    let first = execute(&mut runtime, 30, globals, PreviewContext::default());
    assert_eq!(
        first.frame.as_ref().expect(&first.diagnostics).state["global"],
        0
    );
    let second = execute(&mut runtime, 31, globals, PreviewContext::default());
    assert_eq!(
        second.frame.as_ref().expect(&second.diagnostics).state["global"],
        1
    );
    let reset = runtime.evaluate(
        Request {
            session_id: "engine-tests".into(),
            generation: 32,
            source: globals.into(),
            backend: Backend::Miri,
            restart: true,
            input: PreviewContext::default(),
        },
        &AtomicU64::new(32),
    );
    assert_eq!(
        reset.frame.as_ref().expect(&reset.diagnostics).state["global"],
        0
    );
    let broken = execute(
        &mut runtime,
        25,
        "fn render( broken rust",
        PreviewContext::default(),
    );
    assert!(
        broken.frame.is_none() && broken.diagnostics.contains("error"),
        "{}",
        broken.diagnostics
    );
    let panic = execute(
        &mut runtime,
        26,
        "use gpui_codepen_guest::*; fn render(_: &mut PreviewContext) -> Node { panic!(\"test panic\") }",
        PreviewContext::default(),
    );
    assert!(
        panic.frame.is_none() && panic.diagnostics.contains("test panic"),
        "{}",
        panic.diagnostics
    );
    let generation = Arc::new(AtomicU64::new(27));
    let cancel = generation.clone();
    let thread = std::thread::spawn(move || {
        std::thread::sleep(std::time::Duration::from_millis(500));
        cancel.store(28, Ordering::Relaxed);
    });
    let stopped = runtime.evaluate(Request { session_id: "engine-tests".into(), generation: 27,
        source: "use gpui_codepen_guest::*; fn render(_: &mut PreviewContext) -> Node { loop { std::hint::black_box(1); } }".into(),
        backend: Backend::Miri, restart: false, input: PreviewContext::default() }, &generation);
    thread.join().unwrap();
    assert!(
        stopped.diagnostics.contains("Superseded"),
        "{}",
        stopped.diagnostics
    );
    assert!(
        stopped.elapsed_ms < 1200,
        "cancellation must terminate promptly"
    );
    let recovered = execute(
        &mut runtime,
        28,
        LESSONS[0].source,
        PreviewContext::default(),
    );
    assert!(recovered.frame.is_some(), "{}", recovered.diagnostics);
}
