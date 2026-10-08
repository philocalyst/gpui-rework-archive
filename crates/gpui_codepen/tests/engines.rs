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
fn save_browser_case(name: &str, source: &str, cases: &[(PreviewContext, gpui_ce_codepen::guest::Frame)]) {
    let directory = gpui_ce_codepen::runtime::repository_root()
        .join("target/codepen-browser-probe/cases").join(name);
    std::fs::create_dir_all(&directory).unwrap();
    std::fs::write(directory.join("source.rs"), source).unwrap();
    std::fs::write(directory.join("count"), cases.len().to_string()).unwrap();
    for (index, (input, frame)) in cases.iter().enumerate() {
        std::fs::write(directory.join(format!("{index}.input")),
            gpui_ce_codepen::guest::wire::encode_input(input).unwrap()).unwrap();
        std::fs::write(directory.join(format!("{index}.frame")),
            gpui_ce_codepen::guest::wire::encode(frame)).unwrap();
    }
}
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
fn hot_reload_preserves_entities_and_last_good_program() {
    let mut runtime = Runtime::new().unwrap();
    let first = execute(&mut runtime, 1, COUNTER, Default::default());
    assert!(first.frame.is_some(), "{}", first.diagnostics);
    let clicked = execute(&mut runtime, 2, COUNTER, click());
    let clicked = clicked.frame.expect(&clicked.diagnostics);
    let edited = COUNTER.replace("this.count+=1", "this.count+=5");
    let patched = execute(&mut runtime, 3, &edited, Default::default());
    let patched = patched.frame.expect(&patched.diagnostics);
    assert_eq!(patched.scene, clicked.scene, "An edited handler must retain its actual entity state");
    let next = execute(&mut runtime, 4, &edited, click());
    let next = next.frame.expect(&next.diagnostics);
    let scene = next.scene.to_scene().unwrap();
    assert_eq!(scene.quads[0].background, gpui::rgb(0x100006).into());
    let invalid = execute(&mut runtime, 5, "fn component(é", Default::default());
    assert!(invalid.frame.is_none());
    assert!(invalid.diagnostics.contains("error"), "{}", invalid.diagnostics);
    let recovered = execute(&mut runtime, 6, &edited, Default::default());
    let recovered = recovered.frame.expect(&recovered.diagnostics);
    assert_eq!(recovered.scene, next.scene, "A compiler error must leave the last good interpreter alive");
    let color = edited.replace("0x100000", "0x200000");
    let recolored = execute(&mut runtime, 7, &color, Default::default());
    let recolored = recolored.frame.expect(&recolored.diagnostics);
    assert_eq!(recolored.scene.to_scene().unwrap().quads[0].background, gpui::rgb(0x200006).into());
    // The JSPI probe runs these exact GPUI inputs through the production browser
    // workers and compares complete wire frames against this native execution.
    let fixture = gpui_ce_codepen::runtime::repository_root().join("target/codepen-browser-probe");
    std::fs::create_dir_all(&fixture).unwrap();
    std::fs::write(fixture.join("counter.rs"), COUNTER).unwrap();
    for (name, input) in [("idle.input", PreviewContext::default()), ("click.input", click())] {
        std::fs::write(fixture.join(name), gpui_ce_codepen::guest::wire::encode_input(&input).unwrap()).unwrap();
    }
    for (name, frame) in [("initial.frame", first.frame.as_ref().unwrap()), ("clicked.frame", &clicked),
        ("patched.frame", &patched), ("six.frame", &next), ("recolored.frame", &recolored)] {
        std::fs::write(fixture.join(name), gpui_ce_codepen::guest::wire::encode(frame)).unwrap();
    }
}

#[test]
#[ignore = "requires setup.py and full vendored Miri"]
fn documentation_helper_method_edit_preserves_counter_state() {
    let source = include_str!("fixtures/documentation_counter.rs");
    let mut runtime = Runtime::new().unwrap();
    let initial = execute(&mut runtime, 1, source, PreviewContext::default());
    let initial = initial.frame.expect(&initial.diagnostics);
    let scene = initial.scene.to_scene().unwrap();
    let button = scene.quads.iter().find(|quad| quad.background == gpui::rgb(0x155b50).into())
        .expect("Canonical documentation counter has its real GPUI increment button");
    let center = button.bounds.center();
    let center = point(px(center.x.0), px(center.y.0));
    let mut input = click();
    for event in &mut input.events {
        match event {
            gpui_ce_codepen::guest::InputMessage::Event(PlatformInput::MouseDown(event)) => event.position = center,
            gpui_ce_codepen::guest::InputMessage::Event(PlatformInput::MouseUp(event)) => event.position = center,
            _ => {}
        }
    }
    let clicked = execute(&mut runtime, 2, source, input.clone());
    let clicked = clicked.frame.expect(&clicked.diagnostics);
    assert_ne!(clicked.scene, initial.scene, "Click must execute the actual helper method");
    let edited = source.replace("saturating_add(1)", "saturating_add(5)");
    assert_ne!(edited, source);
    let patched = execute(&mut runtime, 3, &edited, PreviewContext::default());
    let patched = patched.frame.expect(&patched.diagnostics);
    assert_eq!(patched.scene, clicked.scene, "Editing a helper method must retain the counter's entity state");
    let next = execute(&mut runtime, 4, &edited, input.clone());
    let next = next.frame.expect(&next.diagnostics);
    assert_ne!(next.scene, patched.scene);
    let mut reference_runtime = Runtime::new().unwrap();
    let reference = execute(&mut reference_runtime, 1,
        &source.replace("Counter { count: 0 }", "Counter { count: 6 }"), PreviewContext::default());
    let reference = reference.frame.expect(&reference.diagnostics);
    assert_eq!(next.scene, reference.scene, "The edited Rust helper must produce Count: 6");
    let local_edit = edited.replace("self.count = self.count.saturating_add(5);",
        "let step = u32::from(5_u8);\n        self.count = self.count.saturating_add(step);");
    assert_ne!(local_edit, edited);
    let local_patched = execute(&mut runtime, 5, &local_edit, PreviewContext::default());
    let local_patched = local_patched.frame.expect(&local_patched.diagnostics);
    assert_eq!(local_patched.scene, next.scene, "Changing helper locals must preserve its live entity");
    let eleven = execute(&mut runtime, 6, &local_edit, input.clone());
    let eleven = eleven.frame.expect(&eleven.diagnostics);
    let mut eleven_runtime = Runtime::new().unwrap();
    let eleven_reference = execute(&mut eleven_runtime, 1,
        &source.replace("Counter { count: 0 }", "Counter { count: 11 }"), PreviewContext::default());
    assert_eq!(eleven.scene, eleven_reference.frame.expect(&eleven_reference.diagnostics).scene,
        "The new local layout and conversion must execute and produce Count: 11");
    let directory = gpui_ce_codepen::runtime::repository_root().join("target/codepen-browser-probe/documentation-counter");
    std::fs::create_dir_all(&directory).unwrap();
    std::fs::write(directory.join("source.rs"), source).unwrap();
    std::fs::write(directory.join("edited.rs"), &edited).unwrap();
    std::fs::write(directory.join("local-edit.rs"), &local_edit).unwrap();
    std::fs::write(directory.join("idle.input"), gpui_ce_codepen::guest::wire::encode_input(&PreviewContext::default()).unwrap()).unwrap();
    std::fs::write(directory.join("click.input"), gpui_ce_codepen::guest::wire::encode_input(&input).unwrap()).unwrap();
    for (name, frame) in [("initial", initial), ("clicked", clicked), ("patched", patched), ("six", next), ("eleven", eleven)] {
        std::fs::write(directory.join(format!("{name}.frame")), gpui_ce_codepen::guest::wire::encode(&frame)).unwrap();
    }
}

#[test]
#[ignore = "requires setup.py and full vendored Miri"]
fn documentation_keyboard_actions_use_the_focused_dispatch_path() {
    let source = include_str!("fixtures/documentation_actions.rs");
    let mut runtime = Runtime::new().unwrap();
    let initial = execute(&mut runtime, 1, source, PreviewContext::default());
    let initial = initial.frame.expect(&initial.diagnostics);
    let input = PreviewContext {
        events: vec![PlatformInput::KeyDown(gpui::KeyDownEvent {
            keystroke: gpui::Keystroke::parse("space").unwrap(),
            is_held: false,
            prefer_character_input: false,
        }).into()],
        ..Default::default()
    };
    let incremented = execute(&mut runtime, 2, source, input.clone());
    let incremented = incremented.frame.expect(&incremented.diagnostics);
    let mut reference = Runtime::new().unwrap();
    let reference = execute(&mut reference, 1,
        &source.replace("KeyboardCounter { count: 0, focus }", "KeyboardCounter { count: 1, focus }"),
        PreviewContext::default());
    assert_eq!(incremented.scene, reference.frame.expect(&reference.diagnostics).scene,
        "Space must dispatch the canonical Increment action to the focused guest view");
    save_browser_case("actions", source, &[(PreviewContext::default(), initial), (input, incremented)]);
}

#[test]
#[ignore = "requires setup.py and full vendored Miri"]
fn documentation_text_hit_testing_maps_a_wrapped_utf8_cluster() {
    let source = include_str!("fixtures/documentation/text-hit-testing.rs");
    let mut runtime = Runtime::new().unwrap();
    let first = execute(&mut runtime, 1, source, PreviewContext::default());
    let first = first.frame.expect(&first.diagnostics);
    let scene = first.scene.to_scene().unwrap();
    let marker = scene.quads.iter().find(|quad| quad.background == gpui::rgb(0xd04736).into())
        .expect("The canonical canvas must query and paint its measured text caret");
    let mut input = click();
    let accent = scene.monochrome_sprites.iter().filter(|sprite| sprite.order == 3).nth(3)
        .expect("The paragraph must paint its combining e-accent cluster");
    let position = point(px(accent.bounds.origin.x.0 + accent.bounds.size.width.0 * 0.25),
        px(marker.bounds.origin.y.0 + 12.));
    for event in &mut input.events {
        match event {
            gpui_ce_codepen::guest::InputMessage::Event(PlatformInput::MouseDown(event)) => event.position = position,
            gpui_ce_codepen::guest::InputMessage::Event(PlatformInput::MouseUp(event)) => event.position = position,
            _ => {}
        }
    }
    let clicked = execute(&mut runtime, 2, source, input.clone());
    let clicked = clicked.frame.expect(&clicked.diagnostics);
    let updated = clicked.scene.to_scene().unwrap();
    let moved = updated.quads.iter().find(|quad| quad.background == gpui::rgb(0xd04736).into()).unwrap();
    assert_ne!(moved.bounds.origin, marker.bounds.origin, "Mouse hit testing must move the actual canvas caret");
    let mut reference = Runtime::new().unwrap();
    let expected = source.replace("index: 0,", "index: 3,").replace("hit: false,", "hit: true,");
    let reference = execute(&mut reference, 1, &expected, PreviewContext::default());
    assert!(clicked.scene == reference.frame.expect(&reference.diagnostics).scene,
        "The combining e-accent must map to the UTF-8 cluster beginning at byte 3");
    save_browser_case("documentation-text-hit-testing", source,
        &[(PreviewContext::default(), first), (input, clicked)]);
}

#[test]
#[ignore = "requires setup.py and full vendored Miri"]
fn every_documentation_starter_executes_and_dispatches_its_interactions() {
    let sources = [
        ("actions", include_str!("fixtures/documentation/actions.rs")),
        ("animation", include_str!("fixtures/documentation/animation.rs")),
        ("async-task", include_str!("fixtures/documentation/async-task.rs")),
        ("counter", include_str!("fixtures/documentation/counter.rs")),
        ("custom-element", include_str!("fixtures/documentation/custom-element.rs")),
        ("drawing", include_str!("fixtures/documentation/drawing.rs")),
        ("first-window", include_str!("fixtures/documentation/first-window.rs")),
        ("layout", include_str!("fixtures/documentation/layout.rs")),
        ("lists", include_str!("fixtures/documentation/lists.rs")),
        ("subscriptions", include_str!("fixtures/documentation/subscriptions.rs")),
        ("text", include_str!("fixtures/documentation/text.rs")),
        ("text-hit-testing", include_str!("fixtures/documentation/text-hit-testing.rs")),
    ];
    let mut failures = Vec::new();
    for (name, source) in sources {
        let mut runtime = Runtime::new().unwrap();
        let initial = execute(&mut runtime, 1, source, PreviewContext::default());
        let Some(initial) = initial.frame else {
            failures.push(format!("{name}: {}", initial.diagnostics));
            continue;
        };
        let mut cases = vec![(PreviewContext::default(), initial.clone())];
        let mut input = PreviewContext::default();
        if name == "actions" {
            input.events.push(PlatformInput::KeyDown(gpui::KeyDownEvent {
                keystroke: gpui::Keystroke::parse("space").unwrap(),
                is_held: false, prefer_character_input: false,
            }).into());
        } else if matches!(name, "counter" | "subscriptions" | "async-task" | "animation") {
            let scene = initial.scene.to_scene().unwrap();
            let button = scene.quads.iter().find(|quad| quad.background == gpui::rgb(0x155b50).into())
                .unwrap_or_else(|| panic!("{name} has its real GPUI action button"));
            let center = button.bounds.center();
            input = click();
            for event in &mut input.events {
                match event {
                    gpui_ce_codepen::guest::InputMessage::Event(PlatformInput::MouseDown(event)) =>
                        event.position = point(px(center.x.0), px(center.y.0)),
                    gpui_ce_codepen::guest::InputMessage::Event(PlatformInput::MouseUp(event)) =>
                        event.position = point(px(center.x.0), px(center.y.0)),
                    _ => {}
                }
            }
        } else if name == "text-hit-testing" {
            input = click();
            for event in &mut input.events {
                match event {
                    gpui_ce_codepen::guest::InputMessage::Event(PlatformInput::MouseDown(event)) =>
                        event.position = point(px(240.), px(155.)),
                    gpui_ce_codepen::guest::InputMessage::Event(PlatformInput::MouseUp(event)) =>
                        event.position = point(px(240.), px(155.)),
                    _ => {}
                }
            }
        }
        let interacted = execute(&mut runtime, 2, source, input.clone());
        let Some(interacted) = interacted.frame else {
            failures.push(format!("{name} interaction: {}", interacted.diagnostics));
            continue;
        };
        if matches!(name, "counter" | "subscriptions" | "actions" | "async-task") {
            assert_ne!(interacted.scene, initial.scene, "{name} must execute its actual callback");
        }
        cases.push((input, interacted.clone()));
        if matches!(name, "async-task" | "animation") {
            let elapsed = PreviewContext { elapsed_ms: if name == "async-task" { 2000 } else { 350 }, ..Default::default() };
            let advanced = execute(&mut runtime, 3, source, elapsed.clone());
            let advanced = advanced.frame.expect(&advanced.diagnostics);
            assert_ne!(advanced.scene, interacted.scene, "{name} must execute its pending timer/frame");
            cases.push((elapsed, advanced));
        }
        save_browser_case(&format!("documentation-{name}"), source, &cases);
        println!("PASS full native Miri canonical starter: {name}");
    }
    assert!(failures.is_empty(), "{}", failures.join("\n\n"));
}

#[test]
#[ignore = "requires setup.py and full vendored Miri"]
fn formatted_text_edit_preserves_live_entity() {
    let source = include_str!("fixtures/documentation_counter.rs");
    let mut runtime = Runtime::new().unwrap();
    let initial = execute(&mut runtime, 1, source, PreviewContext::default());
    let initial = initial.frame.expect(&initial.diagnostics);
    let scene = initial.scene.to_scene().unwrap();
    let button = scene.quads.iter().find(|quad| quad.background == gpui::rgb(0x155b50).into()).unwrap();
    let center = button.bounds.center();
    let mut input = click();
    for event in &mut input.events {
        match event {
            gpui_ce_codepen::guest::InputMessage::Event(PlatformInput::MouseDown(event)) =>
                event.position = point(px(center.x.0), px(center.y.0)),
            gpui_ce_codepen::guest::InputMessage::Event(PlatformInput::MouseUp(event)) =>
                event.position = point(px(center.x.0), px(center.y.0)),
            _ => {}
        }
    }
    assert!(execute(&mut runtime, 2, source, input.clone()).frame.is_some());
    let edited = source.replace("Count: {}", "Total: {}");
    let patched = execute(&mut runtime, 3, &edited, PreviewContext::default());
    let patched = patched.frame.expect(&patched.diagnostics);
    let mut reference_runtime = Runtime::new().unwrap();
    let reference = execute(&mut reference_runtime, 1,
        &edited.replace("Counter { count: 0 }", "Counter { count: 1 }"), PreviewContext::default());
    let reference = reference.frame.expect(&reference.diagnostics);
    assert_eq!(patched.scene, reference.scene,
        "Editing format! text must update its promoted constants while preserving the live counter");
}

#[test]
#[ignore = "requires setup.py and full vendored Miri"]
fn superseded_frame_keeps_its_click_and_entity_state() {
    let directory = tempfile::tempdir().unwrap();
    let marker = directory.path().join("rendering");
    let release = directory.path().join("release");
    let slow = COUNTER.replace("  div()", &format!(r#"  if self.count == 1 {{
   std::fs::write({:?}, b"rendering").unwrap();
   while !std::path::Path::new({:?}).exists() {{
    std::thread::sleep(std::time::Duration::from_millis(2));
   }}
  }}
  div()"#, marker.to_str().unwrap(), release.to_str().unwrap()));
    let mut runtime = Runtime::new().unwrap();
    assert!(execute(&mut runtime, 1, &slow, Default::default()).frame.is_some());
    let latest = Arc::new(AtomicU64::new(2));
    let newer = latest.clone();
    let supersede = std::thread::spawn(move || {
        let deadline = Instant::now() + std::time::Duration::from_secs(10);
        while !marker.exists() {
            assert!(Instant::now() < deadline, "Guest never reached the click render");
            std::thread::sleep(std::time::Duration::from_millis(2));
        }
        newer.store(3, Ordering::Relaxed);
        std::fs::write(release, b"continue").unwrap();
    });
    let stale = runtime.evaluate(Request {
        session_id: "superseded-frame".into(), generation: 2, source: slow.clone(),
        backend: Backend::Miri, restart: false, input: click(),
    }, &latest);
    supersede.join().unwrap();
    assert!(stale.frame.is_none());
    assert!(stale.diagnostics.contains("Superseded"), "{}", stale.diagnostics);
    let edited = slow.replace("this.count+=1", "this.count+=5").replace("0x100000", "0x200000");
    let patched = execute(&mut runtime, 3, &edited, Default::default());
    let patched = patched.frame.expect(&patched.diagnostics);
    assert_eq!(patched.scene.to_scene().unwrap().quads[0].background, gpui::rgb(0x200001).into(),
        "An obsolete frame must retain the click that mutated its entity");
    let clicked = execute(&mut runtime, 4, &edited, click());
    let clicked = clicked.frame.expect(&clicked.diagnostics);
    assert_eq!(clicked.scene.to_scene().unwrap().quads[0].background, gpui::rgb(0x200006).into());
}
#[test]
#[ignore = "requires setup.py and full vendored Miri"]
fn call_and_layout_invariants_preserve_dynamic_execution() {
    let source = r#"use gpui::{*,prelude::*};
enum Choice { Small(u8, u16), Wide(u64, u8) }
trait Tint { fn tint(&self) -> u32; }
impl Tint for Choice {
 fn tint(&self) -> u32 {
  match self { Self::Small(a,b) => u32::from(*a)+u32::from(*b),
   Self::Wide(a,b) => *a as u32+u32::from(*b) }
 }
}
struct Tail<T: ?Sized> { prefix: u8, values: T }
fn sum<const N: usize>(tail: &Tail<[u16]>) -> u32 {
 const { assert!(N > 0); }
 u32::from(tail.prefix) + tail.values.iter().take(N).map(|x|u32::from(*x)).sum::<u32>()
}
#[track_caller]
fn caller_line() -> u32 { std::panic::Location::caller().line() }
fn first(x:u32)->u32{x+1}
fn second(x:u32)->u32{x+7}
struct View { count:u32 }
impl Render for View {
 fn render(&mut self,_:&mut Window,cx:&mut Context<Self>)->impl IntoElement {
  let choice = if self.count%2 == 0 { Choice::Small(2,5) } else { Choice::Wide(1024,3) };
  let dynamic: &dyn Tint = &choice;
  let tail = Tail { prefix:3, values:[10u16,20,30] };
  let slice_tail: &Tail<[u16]> = &tail;
  assert_eq!(sum::<2>(slice_tail),33);
  assert_eq!(sum::<3>(slice_tail),63);
  let earlier = caller_line();
  let later = caller_line();
  assert_eq!(later, earlier+1);
  let function:fn(u32)->u32 = if self.count%2 == 0 {first} else {second};
  let color = 0x100000+dynamic.tint()+function(self.count)+sum::<2>(slice_tail);
  div().id("dynamic").w(px(200.)).h(px(100.)).bg(rgb(color))
   .on_click(cx.listener(|this,_,_,cx|{this.count+=1;cx.notify();}))
 }
}
fn component(_:&mut Window,cx:&mut App)->Entity<View>{cx.new(|_|View{count:0})}
"#;
    let mut runtime = Runtime::new().unwrap();
    let mut cases = Vec::new();
    for (index, expected) in [0x100029, 0x10042c, 0x10002b, 0x10042e].into_iter().enumerate() {
        let input = if index == 0 { PreviewContext::default() } else { click() };
        let reply = execute(&mut runtime, index as u64 + 1, source, input.clone());
        let frame = reply.frame.expect(&reply.diagnostics);
        assert_eq!(frame.scene.to_scene().unwrap().quads[0].background, gpui::rgb(expected).into());
        cases.push((input, frame));
    }
    save_browser_case("layouts", source, &cases);
}

#[test]
#[ignore = "requires setup.py and full vendored Miri"]
fn real_gpui_async_tasks_wake_at_the_requested_frame_without_blocking_edits() {
    let source = r#"use gpui::{*,prelude::*};
use std::time::Duration;
struct AsyncView { done: bool }
impl Render for AsyncView {
 fn render(&mut self,_:&mut Window,_:&mut Context<Self>)->impl IntoElement {
  div().w(px(100.)).h(px(50.)).bg(rgb(if self.done {0x002233} else {0x112233}))
 }
}
fn component(_:&mut Window,cx:&mut App)->Entity<AsyncView>{
 cx.new(|cx: &mut Context<AsyncView>| {
  cx.spawn(async move |this,cx| {
   cx.background_executor().timer(Duration::from_millis(100)).await;
   this.update(cx,|this,cx| {this.done=true;cx.notify();}).unwrap();
  }).detach();
  AsyncView {done:false}
 })
}"#;
    let mut runtime = Runtime::new().unwrap();
    let first = execute(&mut runtime, 1, source, Default::default());
    let first = first.frame.expect(&first.diagnostics);
    assert_eq!(first.next_frame_ms, Some(100));
    let early = execute(
        &mut runtime,
        2,
        source,
        PreviewContext {
            elapsed_ms: 50,
            ..Default::default()
        },
    );
    let early = early.frame.expect(&early.diagnostics);
    assert_eq!(early.scene, first.scene);
    assert_eq!(early.next_frame_ms, Some(50));
    let ready = execute(
        &mut runtime,
        3,
        source,
        PreviewContext {
            elapsed_ms: 50,
            ..Default::default()
        },
    );
    let ready = ready.frame.expect(&ready.diagnostics);
    assert_ne!(ready.scene, first.scene);
    assert_eq!(ready.next_frame_ms, None);
    save_browser_case("async", source, &[
        (Default::default(), first),
        (PreviewContext { elapsed_ms: 50, ..Default::default() }, early),
        (PreviewContext { elapsed_ms: 50, ..Default::default() }, ready),
    ]);
}
#[test]
#[ignore = "requires setup.py and full vendored Miri"]
fn real_gpui_density_and_animation_frames_preserve_initial_state() {
    let source = r#"use gpui::{*,prelude::*};
struct Animated { renders: u32 }
impl Render for Animated {
 fn render(&mut self,window:&mut Window,_:&mut Context<Self>)->impl IntoElement {
  self.renders+=1;
  if self.renders<3 {window.request_animation_frame();}
  div().w(px(100.)).h(px(50.)).bg(rgb(0x100000+self.renders))
 }
}
fn component(window:&mut Window,cx:&mut App)->Entity<Animated>{
 assert_eq!(window.scale_factor(),1.25);
 assert_eq!(window.viewport_size(),size(px(400.),px(300.)));
 cx.new(|_|Animated{renders:0})
}"#;
    let mut runtime = Runtime::new().unwrap();
    let input = PreviewContext {
        viewport: size(px(400.), px(300.)),
        scale_factor: 1.25,
        elapsed_ms: 16,
        ..Default::default()
    };
    let mut backgrounds = Vec::new();
    let mut cases = Vec::new();
    for generation in 1..=3 {
        let reply = execute(&mut runtime, generation, source, input.clone());
        let frame = reply.frame.expect(&reply.diagnostics);
        let scene = frame.scene.to_scene().unwrap();
        backgrounds.push(scene.quads[0].background);
        assert_eq!(scene.quads[0].bounds.size.width, ScaledPixels(125.));
        assert_eq!(frame.next_frame_ms.is_some(), generation < 3);
        cases.push((input.clone(), frame));
    }
    for (index, background) in backgrounds.into_iter().enumerate() {
        assert_eq!(
            background,
            gpui::Background::from(gpui::rgb(0x100001 + index as u32))
        );
    }
    save_browser_case("animation", source, &cases);
}

#[test]
#[ignore = "requires setup.py and full vendored Miri"]
fn real_gpui_platform_text_edits_preserve_utf16_and_composition() {
    let source = r#"use gpui::{*,prelude::*};
use std::ops::Range;
struct Input { text:String, selected:Range<usize>, marked:Option<Range<usize>>, focus:FocusHandle }
impl Input {
 fn replace(&mut self,range:Option<Range<usize>>,text:&str) -> Range<usize> {
  let range=range.or_else(||self.marked.take()).unwrap_or_else(||self.selected.clone());
  let a=utf16_to_utf8_offset(&self.text,range.start);
  let b=utf16_to_utf8_offset(&self.text,range.end);
  self.text.replace_range(a..b,text);
  let end=range.start+text.encode_utf16().count(); self.selected=end..end; range.start..end
 }
}
impl Render for Input {
 fn render(&mut self,_:&mut Window,cx:&mut Context<Self>)->impl IntoElement {
  let entity=cx.entity(); let focus=self.focus.clone();
  div().track_focus(&self.focus).w(px(200.)).h(px(80.)).bg(rgb(0x112233))
   .child(canvas(|_,_,_|(),move|bounds,_,window,cx| {
     window.handle_input(&focus,ElementInputHandler::new(bounds,entity.clone()),cx);
   }).size_full())
 }
}
impl EntityInputHandler for Input {
 fn text_for_range(&mut self,r:Range<usize>,a:&mut Option<Range<usize>>,_:&mut Window,_:&mut Context<Self>)->Option<String>{
  let x=utf16_to_utf8_offset(&self.text,r.start);let y=utf16_to_utf8_offset(&self.text,r.end);
  *a=Some(utf8_to_utf16_offset(&self.text,x)..utf8_to_utf16_offset(&self.text,y));Some(self.text[x..y].into())
 }
 fn selected_text_range(&mut self,_:bool,_:&mut Window,_:&mut Context<Self>)->Option<UTF16Selection>{Some(UTF16Selection{range:self.selected.clone(),reversed:false})}
 fn marked_text_range(&self,_:&mut Window,_:&mut Context<Self>)->Option<Range<usize>>{self.marked.clone()}
 fn unmark_text(&mut self,_:&mut Window,cx:&mut Context<Self>){self.marked=None;cx.notify();}
 fn replace_text_in_range(&mut self,r:Option<Range<usize>>,t:&str,_:&mut Window,cx:&mut Context<Self>){self.replace(r,t);self.marked=None;cx.notify();}
 fn replace_and_mark_text_in_range(&mut self,r:Option<Range<usize>>,t:&str,s:Option<Range<usize>>,_:&mut Window,cx:&mut Context<Self>){let m=self.replace(r,t);if let Some(s)=s{self.selected=m.start+s.start..m.start+s.end;}self.marked=Some(m);cx.notify();}
 fn bounds_for_range(&mut self,_:Range<usize>,b:Bounds<Pixels>,_:&mut Window,_:&mut Context<Self>)->Option<Bounds<Pixels>>{Some(b)}
 fn character_index_for_point(&mut self,_:Point<Pixels>,_:&mut Window,_:&mut Context<Self>)->Option<usize>{Some(0)}
 fn text_length_utf16(&mut self,_:&mut Window,_:&mut Context<Self>)->Option<usize>{Some(self.text.encode_utf16().count())}
 fn set_selected_text_range(&mut self,r:Range<usize>,_:&mut Window,cx:&mut Context<Self>){self.selected=r;cx.notify();}
}
fn component(window:&mut Window,cx:&mut App)->Entity<Input>{
 let focus=cx.focus_handle();window.focus(&focus,cx);
 cx.new(|_|Input{text:"A😀B".into(),selected:4..4,marked:None,focus})
}"#;
    use gpui_ce_codepen::guest::{InputMessage, TextEdit};
    let mut runtime = Runtime::new().unwrap();
    let first = execute(&mut runtime, 1, source, Default::default());
    let first = first.frame.expect(&first.diagnostics);
    let text = first.text.as_ref()
        .expect("focused real input handler");
    assert_eq!(text.text, "A😀B");
    assert_eq!(text.length, Some(4));
    let mark_input = PreviewContext {
        events: vec![InputMessage::Text(TextEdit::Mark {
            range: Some(1..3), text: "é水".into(), selection: Some(0..2),
        })],
        ..Default::default()
    };
    let marked = execute(
        &mut runtime,
        2,
        source,
        mark_input.clone(),
    );
    let marked = marked.frame.expect(&marked.diagnostics);
    let text = marked.text.as_ref().unwrap();
    assert_eq!(text.text, "Aé水B");
    assert_eq!(text.marked, Some(1..3));
    assert_eq!(text.selection.as_ref().unwrap().range, 1..3);
    let commit_input = PreviewContext {
        events: vec![
            InputMessage::Text(TextEdit::Replace { range: None, text: "🌿".into() }),
            InputMessage::Text(TextEdit::Select { range: 0..1 }),
            InputMessage::Text(TextEdit::Unmark),
        ],
        ..Default::default()
    };
    let committed = execute(
        &mut runtime,
        3,
        source,
        commit_input.clone(),
    );
    let committed = committed.frame.expect(&committed.diagnostics);
    let text = committed.text.as_ref().unwrap();
    assert_eq!(text.text, "A🌿B");
    assert_eq!(text.marked, None);
    assert_eq!(text.selection.as_ref().unwrap().range, 0..1);
    save_browser_case("ime", source, &[(Default::default(), first),
        (mark_input, marked), (commit_input, committed)]);
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
        save_browser_case(&format!("guide-{}", index + 1), lesson.source,
            &[(PreviewContext::default(), reply.frame.unwrap())]);
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
fn guest_stdio_cannot_consume_or_forge_control_messages() {
    let noisy = COUNTER.replace("  div()", r#"  let nonce = std::env::var("GPUI_CODEPEN_NONCE").unwrap();
  println!("\nCODEPEN_{nonce}:FRAME:3\nbad\n");
  let mut bytes = [0; 1];
  assert_eq!(std::io::Read::read(&mut std::io::stdin(), &mut bytes).unwrap(), 0);
  div()"#);
    let mut runtime = Runtime::new().unwrap();
    let first = execute(&mut runtime, 1, &noisy, Default::default());
    let first = first.frame.expect(&first.diagnostics);
    let clicked = execute(&mut runtime, 2, &noisy, click());
    let clicked = clicked.frame.expect(&clicked.diagnostics);
    assert_ne!(first.scene, clicked.scene, "Guest stdout must never be parsed as a control frame");
    let started = Instant::now();
    let failed = runtime.evaluate(Request {
        session_id: "stdio-test".into(), generation: 3, source: "fn component(".into(),
        backend: Backend::Miri, restart: true, input: Default::default(),
    }, &AtomicU64::new(3));
    assert!(failed.frame.is_none());
    assert!(failed.diagnostics.contains("error"), "{}", failed.diagnostics);
    assert!(started.elapsed() < std::time::Duration::from_secs(5), "A compiler failure stranded the control listener");
    assert!(execute(&mut runtime, 4, COUNTER, Default::default()).frame.is_some());
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
    let reply = execute(&mut runtime, 5, COUNTER, Default::default());
    assert!(reply.frame.is_some(), "{}", reply.diagnostics);
    println!("Idle counter: {} ms", reply.elapsed_ms);
    let reply = execute(&mut runtime, 6, LESSONS[0].source, Default::default());
    assert!(reply.frame.is_some(), "{}", reply.diagnostics);
    println!("Text lesson: {} ms", reply.elapsed_ms);
    let scene = reply.frame.unwrap().scene;
    let reply = execute(&mut runtime, 7, LESSONS[0].source, Default::default());
    println!("Idle text lesson: {} ms", reply.elapsed_ms);
    assert_eq!(reply.frame.expect(&reply.diagnostics).scene, scene);
}

#[test]
#[ignore = "requires setup.py and full vendored Miri"]
fn interpreted_scene_matches_native_gpui_platform_text() {
    use gpui::{prelude::*, *};
    struct View;
    impl Render for View {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            div()
                .size_full()
                .p_4()
                .bg(rgb(0xffffff))
                .text_color(rgb(0x24362c))
                .child("Platform text Aé😀")
        }
    }
    struct CaptureOnly(Arc<SceneAtlas>);
    impl PlatformHeadlessRenderer for CaptureOnly {
        fn render_scene_to_image(
            &mut self,
            _: &Scene,
            _: Size<DevicePixels>,
        ) -> anyhow::Result<image::RgbaImage> {
            anyhow::bail!("capture only")
        }
        fn render_scene(&mut self, _: &Scene, _: Size<DevicePixels>) -> anyhow::Result<()> {
            Ok(())
        }
        fn sprite_atlas(&self) -> Arc<dyn PlatformAtlas> {
            self.0.clone()
        }
    }
    for (mode, transparent) in [
        (TextRenderingMode::PlatformDefault, false),
        (TextRenderingMode::Grayscale, false),
        (TextRenderingMode::Subpixel, false),
        (TextRenderingMode::Subpixel, true),
    ] {
        let atlas = Arc::new(SceneAtlas::new());
        let captured = atlas.clone();
        let mut native = HeadlessAppContext::with_platform(
            gpui_platform::text_system().unwrap(),
            Arc::new(()),
            move || Some(Box::new(CaptureOnly(captured.clone()))),
        );
        native.set_automatic_drawing(false);
        native.set_subpixel_rendering_supported(true);
        native.update(|cx| cx.set_text_rendering_mode(mode));
        let viewport = size(px(400.), px(250.));
        let window = native
            .open_window_with_scale_factor(viewport, 2., |_, cx| cx.new(|_| View))
            .unwrap();
        native
            .update_window(window.into(), |_, window, _| {
                window.set_background_appearance(if transparent {
                    WindowBackgroundAppearance::Transparent
                } else {
                    WindowBackgroundAppearance::Opaque
                });
            })
            .unwrap();
        native.draw_window(window.into()).unwrap();
        let expected = native
            .capture_scene(window.into(), |tile| atlas.resolve(tile))
            .unwrap();
        let source = r#"use gpui::{*, prelude::*};
struct View;
impl Render for View {
 fn render(&mut self,_:&mut Window,_:&mut Context<Self>)->impl IntoElement {
  div().size_full().p_4().bg(rgb(0xffffff)).text_color(rgb(0x24362c)).child("Platform text Aé😀")
 }
}
fn component(_:&mut Window,cx:&mut App)->Entity<View>{cx.new(|_|View)}"#;
        let mut runtime = Runtime::native().unwrap();
        let reply = execute(
            &mut runtime,
            1,
            source,
            PreviewContext {
                viewport,
                scale_factor: 2.,
                subpixel_rendering: true,
                text_rendering_mode: mode,
                transparent_window: transparent,
                ..Default::default()
            },
        );
        let actual = reply.frame.expect(&reply.diagnostics).scene;
        let atlas = SceneAtlas::from_captured_bitmaps(actual.bitmaps()).unwrap();
        let actual =
            SceneCapture::capture(&actual.to_scene().unwrap(), |tile| atlas.resolve(tile)).unwrap();
        assert_eq!(
            actual, expected,
            "interpreted GPUI must preserve native layout, styles, placements, and glyph pixels"
        );
    }
}
