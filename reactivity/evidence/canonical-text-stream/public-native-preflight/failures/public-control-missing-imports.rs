use gpui::{Commit, Error, Key, WindowOptions, prelude::*};
use gpui_canvas::{FontFace, TextGeometry as Map, TextPosition};
use std::{hint::black_box, time::Instant};

struct Editor {
    value: Signal<String>,
    offset: Signal<Affine>,
}
impl Editor {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "document", |m| &m.value, |m| &mut m.value);
    const OFFSET: Source<Self, Affine> =
        Source::new(FieldId::new(2), "offset", |m| &m.offset, |m| &mut m.offset);
    fn new(value: String) -> Self {
        Self { value: Signal::new(value), offset: Signal::new(Affine::IDENTITY) }
    }
}
impl View for Editor {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE).direct(Self::OFFSET)
    }
    fn view(&self) -> El<'_> {
        text_input(&self.value).name("document").w(400).h(240).transform(&self.offset)
    }
}
fn source(case: &str) -> String {
    match case {
        "empty" => String::new(),
        "tiny" => "a".into(),
        "label" => "office café a\u{301} אבג".into(),
        "wrapped32k" => "a".repeat(32768),
        "rtl" => "אבגדהוזחטיךכלםמןנסעףפץצקרשת ".repeat(128),
        "mixed" => "office abc אבג العربية\r\n".repeat(64),
        "hardbreak" => "\r\n\u{2028}\nlast\n".repeat(128),
        "long-grapheme" => format!("a{}\r\n", "\u{301}".repeat(1024)),
        _ => panic!("unknown source {case}"),
    }
}
const CASES: [&str; 8] = ["empty", "tiny", "label", "wrapped32k", "rtl", "mixed", "hardbreak", "long-grapheme"];
fn mix(sum: u64, value: u64) -> u64 {
    (sum ^ value).wrapping_mul(0x100000001b3)
}
fn position(sum: u64, value: TextPosition) -> u64 {
    mix(mix(sum, value.offset.byte() as u64), value.affinity as u64)
}
fn rect(sum: u64, value: Rect) -> u64 {
    [value.x, value.y, value.width, value.height].into_iter().fold(sum, |s, n| mix(s, u64::from(n.to_bits())))
}
fn ack(win: &mut Win<Editor>) -> Commit {
    let token = win.with_scene(|_, token| token).unwrap();
    let commit = win.presented(token).unwrap();
    assert!(commit.presentation_valid);
    assert_eq!(commit.source_epoch, commit.presentation_epoch);
    commit
}
fn mount(value: String) -> Win<Editor> {
    let mut win = Win::recording(Editor::new(value), WindowOptions { size: [420, 260], ..Default::default() }).unwrap();
    ack(&mut win);
    win.focus(win.input()).unwrap();
    ack(&mut win);
    win
}
fn query_hit(map: &Map, point: Point) -> u64 {
    let nearest = map.position_at(point).unwrap();
    let mut sum = position(1, nearest);
    if let Some(unit) = map.grapheme_at(point) {
        sum = rect(mix(sum, unit.text_range().start.byte() as u64), unit.bounds());
    }
    sum
}
fn query_selection(map: &Map, selection: TextSelection) -> u64 {
    let mut sum = 1;
    assert!(map.selection_rects(selection, |bounds, line| { sum = mix(rect(sum, bounds), line as u64); }));
    sum
}
fn query_visual(map: &Map, caret: TextPosition) -> u64 {
    position(position(1, map.next_visual(caret).unwrap()), map.previous_visual(caret).unwrap())
}
fn owner_hit(win: &Win<Editor>, point: Point) -> u64 {
    let mut sum = 0;
    win.visit(|part| {
        if part.role() == Role::TextInput {
            let geometry = part.text_geometry().unwrap();
            sum = position(1, geometry.position_at(point).unwrap());
            sum = mix(sum, u64::from(part.contains_point(point)));
        }
    }).unwrap();
    sum
}
fn owner_arrow(win: &mut Win<Editor>, right: bool) -> u64 {
    let previous = win.selection(win.input()).unwrap();
    win.key(if right { Key::Right { extend: true } } else { Key::Left { extend: true } }).unwrap();
    let commit = ack(win);
    let selection = win.selection(win.input()).unwrap();
    assert_ne!(selection.focus, previous.focus);
    position(mix(commit.source_epoch, commit.presentation_epoch), selection.focus)
}
fn owner_drag(win: &mut Win<Editor>, session: &mut PointerSession, point: Point) -> u64 {
    let previous = win.selection(win.input()).unwrap();
    win.pointer_event(session, PointerEvent::Move(point)).unwrap();
    let commit = ack(win);
    let selection = win.selection(win.input()).unwrap();
    assert_ne!(selection.focus, previous.focus);
    position(position(mix(commit.source_epoch, commit.presentation_epoch), selection.anchor), selection.focus)
}
fn owner_prepare(win: &mut Win<Editor>, alternate: bool) -> u64 {
    win.set(Editor::OFFSET, Affine::translation(if alternate { 1. } else { 0. }, 0.)).unwrap();
    let commit = ack(win);
    mix(commit.source_epoch, commit.presentation_epoch)
}
fn points(win: &Win<Editor>) -> Vec<(Point, TextPosition)> {
    let mut points = Vec::new();
    win.visit(|part| {
        if part.role() == Role::TextInput {
            let geometry = part.text_geometry().unwrap();
            for unit in geometry.layout().graphemes().filter(|unit| !unit.is_hard_break()).take(2) {
                let r = geometry.bounds(unit.bounds()).unwrap();
                let p = Point { x: r.x + r.width * 0.25, y: r.y + r.height * 0.5 };
                points.push((p, geometry.position_at(p).unwrap()));
            }
        }
    }).unwrap();
    points
}
fn map_transcript(map: &Map) -> u64 {
    let mut sum = 1;
    for unit in map.graphemes() {
        sum = rect(mix(mix(mix(sum, unit.text_range().start.byte() as u64), unit.text_range().end.byte() as u64), unit.line() as u64), unit.bounds());
    }
    sum
}
fn old_p_oracle() -> u64 {
    let mut sum = 1;
    for case in CASES {
        let value = source(case);
        let mut win = mount(value.clone());
        let input = win.input();
        let capture = |w: &Win<Editor>| {
            let mut captured = None;
            w.visit(|part| {
                if part.role() == Role::TextInput {
                    captured = Some((part.value().unwrap().to_owned(), part.selection().unwrap(), part.text_geometry().unwrap().layout() as *const Map, map_transcript(part.text_geometry().unwrap().layout())));
                }
            }).unwrap();
            captured.unwrap()
        };
        let old = capture(&win);
        win.select(input, TextSelection::from_bytes(0, value.len()).unwrap()).unwrap();
        let eligible = win.with_scene(|_, token| token).unwrap();
        assert!(matches!(win.type_text(input, "漢"), Err(Error::Canvas(_))));
        assert_eq!(capture(&win), old);
        win.presented(eligible).unwrap();
        let selected = capture(&win);
        assert_eq!(selected.0, value);
        assert_eq!(selected.1, TextSelection::from_bytes(0, value.len()).unwrap());
        assert_eq!((selected.2, selected.3), (old.2, old.3));
        sum = mix(sum, selected.3);
        win.set(Editor::VALUE, value).unwrap();
        ack(&mut win);
        assert_eq!(capture(&win).3, old.3);
    }
    sum
}
fn run(case: &str, operation: &str, count: usize, timed: bool) -> (u64, u128, serde_json::Value) {
    assert!(count > 0);
    let value = source(case);
    let font = FontFace::bundled().unwrap();
    let shape = font.shaper().shape_interactive(&value, 16., Some(400.)).unwrap();
    let map = shape.geometry().unwrap();
    let units = map.graphemes().collect::<Vec<_>>();
    let offsets = units.iter().map(|u| u.text_range().start).collect::<Vec<_>>();
    let caret = |i: usize| TextPosition { offset: offsets.get(i % offsets.len().max(1)).copied().unwrap_or(TextOffset::new(0).unwrap()), affinity: gpui::CaretAffinity::Downstream };
    let mut win = mount(value);
    let input = win.input();
    let drag_points = points(&win);
    let mut pointer = PointerSession::default();
    let initial = TextPosition { offset: TextOffset::new(0).unwrap(), affinity: gpui::CaretAffinity::Downstream };
    let right_first = map.next_visual(initial).unwrap() != initial;
    if operation == "arrow" {
        assert_ne!(case, "empty");
        win.select(input, TextSelection::caret(0).unwrap()).unwrap();
        ack(&mut win);
    }
    if operation == "drag" {
        assert_eq!(drag_points.len(), 2);
        assert_ne!(drag_points[0].1, drag_points[1].1);
        win.pointer_event(&mut pointer, PointerEvent::Move(drag_points[0].0)).unwrap();
        win.pointer_event(&mut pointer, PointerEvent::Press).unwrap();
        ack(&mut win);
    }
    win.reset_counters().unwrap();
    let mut sum = 1;
    let started = timed.then(Instant::now);
    for i in 0..count {
        let output = match operation {
            "hit" => {
                let point = units.get(i % units.len().max(1)).map_or(Point { x: 0., y: 0. }, |unit| { let r = unit.bounds(); Point { x: r.x + r.width * 0.25, y: r.y + r.height * 0.5 } });
                black_box(query_hit as fn(&Map, Point) -> u64)(black_box(map), black_box(point))
            }
            "selection" => black_box(query_selection as fn(&Map, TextSelection) -> u64)(black_box(map), black_box(TextSelection { anchor: caret(i), focus: caret(i + offsets.len() / 2) })),
            "visual" => black_box(query_visual as fn(&Map, TextPosition) -> u64)(black_box(map), black_box(caret(i))),
            "owner-hit" => black_box(owner_hit as fn(&Win<Editor>, Point) -> u64)(black_box(&win), black_box(drag_points.get(i % drag_points.len().max(1)).map_or(Point { x: 0., y: 0. }, |p| p.0))),
            "arrow" => black_box(owner_arrow as fn(&mut Win<Editor>, bool) -> u64)(black_box(&mut win), black_box((i % 2 == 0) == right_first)),
            "drag" => black_box(owner_drag as fn(&mut Win<Editor>, &mut PointerSession, Point) -> u64)(black_box(&mut win), black_box(&mut pointer), black_box(drag_points[1 - i % 2].0)),
            "prepare" => black_box(owner_prepare as fn(&mut Win<Editor>, bool) -> u64)(black_box(&mut win), black_box(i % 2 == 0)),
            _ => panic!("unknown operation {operation}"),
        };
        sum = mix(sum, black_box(output));
    }
    let elapsed = started.map_or(0, |started| started.elapsed().as_nanos());
    if operation == "drag" {
        win.pointer_event(&mut pointer, PointerEvent::Release).unwrap();
        ack(&mut win);
    }
    (sum, elapsed, serde_json::to_value(win.counters()).unwrap())
}
fn main() {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    match args.first().map(String::as_str) {
        Some("oracle") => {
            println!("old_p={}", old_p_oracle());
            for case in CASES {
                for operation in ["hit", "selection", "visual", "owner-hit", "prepare", "arrow", "drag"] {
                    if (case == "empty" && operation == "arrow") || (matches!(case, "empty" | "tiny" | "long-grapheme") && operation == "drag") { continue; }
                    let (sum, _, counters) = run(case, operation, 4, false);
                    println!("{}", serde_json::json!({"case":case,"operation":operation,"count":4,"checksum":sum,"counters":counters}));
                }
            }
        }
        Some("measure") => {
            let count = args[3].parse().unwrap();
            let (sum, elapsed, counters) = run(&args[1], &args[2], count, true);
            println!("{}", serde_json::json!({"case":args[1],"operation":args[2],"count":count,"checksum":sum,"elapsed_ns":elapsed,"counters":counters}));
        }
        _ => panic!("expected oracle | measure CASE OPERATION COUNT"),
    }
}
