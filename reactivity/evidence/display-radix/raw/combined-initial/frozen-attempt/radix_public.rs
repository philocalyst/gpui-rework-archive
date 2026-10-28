//! Restricted initial binding admission; ordinary public property edits thereafter.
use gpui::{Error, ImagePixels, WindowOptions, prelude::*, property::BACKGROUND};
use serde_json::{Value, json};
use std::{fs, path::Path};
struct Paint {
    n: usize,
    color: Signal<Color>,
}
impl Paint {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
    fn new(n: usize, color: Color) -> Self {
        Self {
            n,
            color: Signal::new(color),
        }
    }
}
impl View for Paint {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        if self.n == 1 {
            return div().name("surface").w(32).h(16).bg(&self.color);
        }
        column((
            (0..self.n - 2).map(|j| {
                div()
                    .w(32)
                    .h(16)
                    .transform(Affine::translation(
                        if j % 2 == 0 { 8. } else { 48. },
                        8. - 16. * j as f32,
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
                .transform(Affine::translation(0., -16. * (self.n - 2) as f32)),
        ))
        .size(64)
        .bg(Color::WHITE)
        .clip()
    }
}
fn main() {
    let root = std::path::PathBuf::from(std::env::args().nth(1).unwrap());
    fs::create_dir_all(&root).unwrap();
    for n in [1, 9, 32, 256, 1024] {
        sweep(&root, n);
    }
    assets(&root);
}
fn sweep(root: &Path, n: usize) {
    let dir = root.join(n.to_string());
    fs::create_dir(&dir).unwrap();
    let mut win = Win::recording(
        Paint::new(n, Color::BLACK),
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
        if let Some(old) = held.take() {
            assert!(matches!(win.presented(old), Err(Error::StalePresentation)));
        }
        let pixels = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
        let mut fresh = Win::with_size(Paint::new(n, color), 64, 64).unwrap();
        assert_eq!(pixels, fresh.with_pixels(|p, _, _| p.to_vec()).unwrap());
        let name = format!("paint-{i}.rgba");
        fs::write(dir.join(&name), pixels).unwrap();
        if i % 3 == 0 {
            held = Some(token);
        } else {
            win.presented(token).unwrap();
        }
        events.push(json!({"index":i,"target":target,"color":bits,"commit":commit,"counters":counters,"candidate_property_reads":1,"candidate_snapshot_reads":0,"candidate_draw_enumerations":0,"pixels":name}));
    }
    fs::write(dir.join("public.json"),serde_json::to_vec_pretty(&json!({"n":n,"target":target,"initial_draws":draws,"initial_snapshot":snapshot,"events":events,"scope":"one initial registered binding; no generic production journal integration; full CPU and fresh Win oracles charged separately"})).unwrap()).unwrap();
}
struct Assets {
    bitmap: Image,
}
impl View for Assets {
    fn view(&self) -> El<'_> {
        column((
            image(&self.bitmap)
                .size(8)
                .transform(Affine::translation(8., 24.)),
            div()
                .size(4)
                .bg(Color::BLACK)
                .transform(Affine::translation(10., 18.)),
            div()
                .w(32)
                .h(16)
                .bg(Color::BLACK)
                .transform(Affine::translation(48., 28.)),
        ))
        .size(64)
        .bg(Color::WHITE)
        .clip()
    }
}
fn assets(root: &Path) {
    let dir = root.join("images");
    fs::create_dir(&dir).unwrap();
    let mut cases = Vec::<Value>::new();
    for i in 0..4 {
        let pixels: Vec<u8> = (0..64)
            .flat_map(|p| {
                [
                    if (p + i) % 2 == 0 { 255 } else { 0 },
                    if (p / 8 + i) % 2 == 0 { 255 } else { 0 },
                    if i % 2 == 0 { 255 } else { 0 },
                    255,
                ]
            })
            .collect();
        let bitmap = Image::rgba8(
            8,
            8,
            ImageProfile::Srgb,
            AlphaMode::Straight,
            pixels.clone().into_boxed_slice(),
        )
        .unwrap();
        let mut win = Win::with_size(Assets { bitmap }, 64, 64).unwrap();
        let full = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
        let name = format!("image-{i}.rgba");
        fs::write(dir.join(&name), full).unwrap();
        let draws=win.with_scene(|s,_|{
            let image=s.images().next().unwrap();let ImagePixels::Rgba8{bytes,..}=image.pixels() else{panic!("RGBA fixture")};assert_eq!(bytes,pixels);
            s.draws().map(|d|{let r=d.sampled_rect_clip([64,64]).unwrap();assert!([r.x,r.y,r.width,r.height].iter().all(|v|v.fract()==0.));
                json!({"rect":[r.x,r.y,r.x+r.width,r.y+r.height],"color":d.color,"image":d.source.image().is_some()})}).collect::<Vec<_>>()
        }).unwrap();
        let raw = format!("resource-{i}.rgba");
        fs::write(dir.join(&raw), pixels).unwrap();
        cases.push(json!({"index":i,"pixels":name,"resource":raw,"draws":draws}));
    }
    fs::write(
        dir.join("images.json"),
        serde_json::to_vec_pretty(&cases).unwrap(),
    )
    .unwrap();
}
