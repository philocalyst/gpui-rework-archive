//! Restricted initial binding admission; ordinary public property edits thereafter.
use gpui::{Error, WindowOptions, prelude::*, property::BACKGROUND};
use serde_json::json;
use std::{fs, path::Path};
struct Paint {
    n: usize,
    sparse: bool,
    color: Signal<Color>,
    transform: Signal<Affine>,
}
impl Paint {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
    const TRANSFORM: Source<Self, Affine> = Source::new(
        FieldId::new(2),
        "transform",
        |m| &m.transform,
        |m| &mut m.transform,
    );
    fn new(n: usize, color: Color, sparse: bool) -> Self {
        Self {
            n,
            sparse,
            color: Signal::new(color),
            transform: Signal::new(Affine::translation(
                0.,
                if n == 1 { 0. } else { -16. * (n - 2) as f32 },
            )),
        }
    }
}
impl View for Paint {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR).direct(Self::TRANSFORM)
    }
    fn view(&self) -> El<'_> {
        if self.n == 1 {
            return div()
                .name("surface")
                .w(32)
                .h(16)
                .bg(&self.color)
                .transform(&self.transform);
        }
        column((
            (0..self.n - 2).map(|j| {
                div()
                    .w(32)
                    .h(16)
                    .transform(Affine::translation(
                        if self.sparse {
                            40.
                        } else if j % 2 == 0 {
                            8.
                        } else {
                            48.
                        },
                        (if self.sparse { 40. } else { 8. }) - 16. * j as f32,
                    ))
                    .bg(if j % 2 == 0 {
                        Color::BLACK
                    } else {
                        Color::WHITE
                    })
            }),
            div()
                .name("surface")
                .w(32)
                .h(16)
                .bg(&self.color)
                .transform(&self.transform),
        ))
        .size(64)
        .bg(Color::WHITE)
        .clip()
    }
}
fn main() {
    let root = std::path::PathBuf::from(std::env::args().nth(1).unwrap());
    fs::create_dir_all(&root).unwrap();
    for sparse in [false, true] {
        let dir = root.join(if sparse { "sparse" } else { "overlap" });
        fs::create_dir(&dir).unwrap();
        for n in [1, 9, 32, 256, 1024] {
            sweep(&dir, n, sparse);
        }
    }
}
fn sweep(root: &Path, n: usize, sparse: bool) {
    let dir = root.join(n.to_string());
    fs::create_dir(&dir).unwrap();
    let mut win = Win::recording(
        Paint::new(n, Color::BLACK, sparse),
        WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    let initial = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
    fs::write(dir.join("initial.rgba"), initial).unwrap();
    let (draws,token)=win.with_scene(|s,t| {
        let draws:Vec<_>=s.draws().map(|d| {
            let r=d.sampled_rect_clip([64,64]).unwrap();
            assert!([r.x,r.y,r.width,r.height].iter().all(|v|v.fract()==0.));
            assert!(d.color.iter().all(|v|*v==0.||*v==1.));
            json!({"rect":[r.x,r.y,r.x+r.width,r.y+r.height],"color":d.color,"clip":[d.clip.x,d.clip.y,d.clip.width,d.clip.height]})
        }).collect();(draws,t)
    }).unwrap();
    assert_eq!(draws.len(), n);
    win.presented(token).unwrap();
    let snapshot = win.inspect().unwrap();
    let target = win.query().name("surface").one().unwrap();
    let colors = [
        (Color::WHITE, 0xffffffffu32),
        (Color::rgb(255, 0, 0), 0xff0000ff),
        (Color::rgb(0, 0, 255), 0xffff0000),
        (Color::BLACK, 0xff000000),
    ];
    let mut events = Vec::new();
    let mut held = None;
    for i in 0..12 {
        let (color, bits) = colors[i % colors.len()];
        win.reset_counters().unwrap();
        let commit = win.set(Paint::COLOR, color).unwrap();
        let actual = win.property(target, BACKGROUND).unwrap().solid().unwrap();
        assert!(actual.same_authoring(color));
        let counters = win.counters();
        assert_eq!(counters.source_reads, 1);
        assert_eq!(counters.owner_reruns, 0);
        assert_eq!(counters.layout_runs, 0);
        assert_eq!(counters.descriptions, 0);
        assert_eq!(counters.paint_passes, 0);
        let token = win.with_scene(|_, t| t).unwrap();
        if i == 11 {
            let failure = win
                .set(Paint::TRANSFORM, Affine::translation(f32::NAN, 0.))
                .unwrap_err();
            assert!(matches!(failure, gpui::SetError::Committed { .. }));
            assert_eq!(win.with_scene(|_, t| t).unwrap(), token);
        }
        if let Some(old) = held.take() {
            assert!(matches!(win.presented(old), Err(Error::StalePresentation)));
        }
        let pixels = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
        let mut fresh = Win::with_size(Paint::new(n, color, sparse), 64, 64).unwrap();
        assert_eq!(pixels, fresh.with_pixels(|p, _, _| p.to_vec()).unwrap());
        let name = format!("paint-{i}.rgba");
        fs::write(dir.join(&name), pixels).unwrap();
        if i % 3 == 0 {
            held = Some(token);
        } else {
            win.presented(token).unwrap();
        }
        events.push(json!({"index":i,"target":target,"color":bits,"commit":commit,"counters":counters,"candidate_property_reads":1,"candidate_snapshot_reads":0,"candidate_draw_enumerations":0,"rejected_invalid_request":i==11,"pixels":name}));
    }
    fs::write(dir.join("public.json"),serde_json::to_vec_pretty(&json!({"n":n,"target":target,"initial_draws":draws,"initial_snapshot":snapshot,"events":events,"scope":"one initial registered binding; no generic production journal integration; full CPU and fresh Win oracles charged separately"})).unwrap()).unwrap();
}
