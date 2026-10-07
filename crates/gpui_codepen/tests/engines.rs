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
    let input = PreviewContext { viewport: size(px(400.), px(300.)), scale_factor: 1.25, elapsed_ms: 16, ..Default::default() };
    let mut backgrounds = Vec::new();
    for generation in 1..=3 {
        let reply = execute(&mut runtime, generation, source, input.clone());
        let frame = reply.frame.expect(&reply.diagnostics);
        let scene = frame.scene.to_scene().unwrap();
        backgrounds.push(scene.quads[0].background);
        assert_eq!(scene.quads[0].bounds.size.width, ScaledPixels(125.));
        assert_eq!(frame.next_frame_ms.is_some(), generation < 3);
    }
    for (index, background) in backgrounds.into_iter().enumerate() {
        assert_eq!(background, gpui::Background::from(gpui::rgb(0x100001 + index as u32)));
    }
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
    let text = first.frame.expect(&first.diagnostics).text.expect("focused real input handler");
    assert_eq!(text.text, "A😀B");
    assert_eq!(text.length, Some(4));
    let marked = execute(&mut runtime, 2, source, PreviewContext { events: vec![InputMessage::Text(TextEdit::Mark { range: Some(1..3), text: "é水".into(), selection: Some(0..2) })], ..Default::default() });
    let text = marked.frame.expect(&marked.diagnostics).text.unwrap();
    assert_eq!(text.text, "Aé水B");
    assert_eq!(text.marked, Some(1..3));
    assert_eq!(text.selection.unwrap().range, 1..3);
    let committed = execute(&mut runtime, 3, source, PreviewContext { events: vec![InputMessage::Text(TextEdit::Replace { range: None, text: "🌿".into() }), InputMessage::Text(TextEdit::Select { range: 0..1 }), InputMessage::Text(TextEdit::Unmark)], ..Default::default() });
    let text = committed.frame.expect(&committed.diagnostics).text.unwrap();
    assert_eq!(text.text, "A🌿B");
    assert_eq!(text.marked, None);
    assert_eq!(text.selection.unwrap().range, 0..1);
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
