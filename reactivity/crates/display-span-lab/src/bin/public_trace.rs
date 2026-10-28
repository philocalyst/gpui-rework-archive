//! Ordinary existing GPUI APIs; diagnostic extraction is charged as a full scan.
use gpui::{Error, WindowOptions, prelude::*};
use serde_json::{Value, json};
use std::{fs, path::Path};
struct Panel {
    color: Signal<Color>,
    extra: Signal<bool>,
    height: Signal<f64>,
    transform: Signal<Affine>,
}
impl Panel {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
    const EXTRA: Source<Self, bool> =
        Source::new(FieldId::new(2), "extra", |m| &m.extra, |m| &mut m.extra);
    const HEIGHT: Source<Self, f64> =
        Source::new(FieldId::new(3), "height", |m| &m.height, |m| &mut m.height);
    const TRANSFORM: Source<Self, Affine> = Source::new(
        FieldId::new(4),
        "transform",
        |m| &m.transform,
        |m| &mut m.transform,
    );
    fn new() -> Self {
        Self {
            color: Signal::new(Color::BLACK),
            extra: Signal::new(false),
            height: Signal::new(4.),
            transform: Signal::new(Affine::IDENTITY),
        }
    }
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::COLOR)
            .direct(Self::EXTRA)
            .direct(Self::HEIGHT)
            .direct(Self::TRANSFORM)
    }
    fn view(&self) -> El<'_> {
        column((
            div()
                .name("surface")
                .w(32)
                .h(&self.height)
                .bg(&self.color)
                .transform(&self.transform),
            (*self.extra).then(|| div().name("inserted").w(24).h(3).bg(Color::BLACK)),
            (0..7).map(|_| div().w(32).h(4).bg(Color::BLACK)),
        ))
        .size(64)
        .bg(Color::WHITE)
        .clip()
    }
}
fn capture(win: &mut Win<Panel>, root: &Path, name: &str, ack: bool) -> Value {
    let (draws, token, clear) = win
        .with_scene(|s, t| {
            let draws: Vec<_> = s
                .draws()
                .map(|d| {
                    assert!(d.clip_chain.is_none());
                    assert!(d.color.iter().all(|c| *c == 0. || *c == 1.));
                    let r = d.sampled_rect_clip([64, 64]).unwrap();
                    assert!(
                        [r.x, r.y, r.width, r.height]
                            .iter()
                            .all(|x| x.fract() == 0.)
                    );
                    json!({"rect":[r.x,r.y,r.x+r.width,r.y+r.height],"color":d.color})
                })
                .collect();
            (draws, t, s.clear)
        })
        .unwrap();
    let pixels = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
    fs::write(root.join(format!("public-{name}.rgba")), &pixels).unwrap();
    if ack {
        win.presented(token).unwrap();
    }
    let snapshot = win.inspect().unwrap();
    json!({"name":name,"accepted":ack,"snapshot":snapshot,"draws":draws,"clear":clear,"pixels":format!("public-{name}.rgba"),"counters":win.counters(),"adapter_snapshot_nodes":snapshot.nodes.len()})
}
fn main() {
    let dir = std::env::args().nth(1).unwrap();
    let root = Path::new(&dir);
    fs::create_dir_all(root).unwrap();
    let mut win = Win::recording(
        Panel::new(),
        WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    let mut frames = vec![capture(&mut win, root, "initial", true)];
    win.reset_counters().unwrap();
    let target = win.query().name("surface").one().unwrap();
    let commit = win.set(Panel::COLOR, Color::WHITE).unwrap();
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().layout_runs, 0);
    frames.push(capture(&mut win, root, "property", true));
    assert_eq!(win.query().name("surface").one().unwrap(), target);
    win.reset_counters().unwrap();
    win.set(Panel::EXTRA, true).unwrap();
    frames.push(capture(&mut win, root, "insertion", true));
    win.reset_counters().unwrap();
    win.set(Panel::HEIGHT, 7.).unwrap();
    frames.push(capture(&mut win, root, "layout", true));
    win.reset_counters().unwrap();
    win.set(Panel::EXTRA, false).unwrap();
    frames.push(capture(&mut win, root, "removal", true));
    win.reset_counters().unwrap();
    win.set(Panel::COLOR, Color::BLACK).unwrap();
    let stale = win.with_scene(|_, t| t).unwrap();
    frames.push(capture(&mut win, root, "invalidated", false));
    win.set(Panel::COLOR, Color::WHITE).unwrap();
    assert!(matches!(
        win.presented(stale),
        Err(Error::StalePresentation)
    ));
    frames.push(capture(&mut win, root, "latest", true));
    win.set(Panel::COLOR, Color::BLACK).unwrap();
    let eligible = win.with_scene(|_, t| t).unwrap();
    assert!(
        win.set(Panel::TRANSFORM, Affine::translation(f32::NAN, 0.))
            .is_err()
    );
    assert_eq!(win.with_scene(|_, t| t).unwrap(), eligible);
    frames.push(capture(&mut win, root, "failed-newer-eligible", true));
    let report = json!({"source_property_commit":commit,"stale_rejected":true,"failed_newer_keeps_prior":true,"frames":frames,"scope":"rect-only CPU diagnostic acknowledgement; not native presentation; full snapshot adapter"});
    fs::write(
        root.join("public-trace.json"),
        serde_json::to_vec_pretty(&report).unwrap(),
    )
    .unwrap();
}
