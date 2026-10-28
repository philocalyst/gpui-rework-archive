//! Initial admission plus direct ordinary Source updates. Geometry snapshots are
//! taken once. Full pixels/Views below are separate, explicit correctness oracles.
use gpui::{Error, FontFace, ImagePixels, WindowOptions, prelude::*, property::BACKGROUND};
use serde_json::json;
use std::{fs, path::Path};
struct Paint(Signal<Color>);
impl Paint {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.0, |m| &mut m.0);
}
impl View for Paint {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        column((
            div().name("surface").w(32).h(4).bg(&self.0),
            (0..7).map(|_| div().w(32).h(4).bg(Color::BLACK)),
        ))
        .size(64)
        .bg(Color::WHITE)
    }
}
struct Assets {
    title: String,
    bitmap: Image,
}
impl View for Assets {
    fn view(&self) -> El<'_> {
        column((
            label(self.title.as_str()).font_size(16).fg(Color::BLACK),
            image(&self.bitmap).size(8),
        ))
        .size(64)
        .bg(Color::WHITE)
    }
}
fn main() {
    let dir = std::env::args().nth(1).unwrap();
    let root = Path::new(&dir);
    fs::create_dir_all(root).unwrap();
    let mut win = Win::recording(
        Paint(Signal::new(Color::BLACK)),
        WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    let initial_pixels = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
    fs::write(root.join("initial.rgba"), &initial_pixels).unwrap();
    let (initial, token) = win
        .with_scene(|s, t| {
            let draws: Vec<_> = s
                .draws()
                .map(|d| {
                    assert!(d.clip_chain.is_none());
                    let r = d.sampled_rect_clip([64, 64]).unwrap();
                    assert!(
                        [r.x, r.y, r.width, r.height]
                            .iter()
                            .all(|x| x.fract() == 0.)
                    );
                    assert!(d.color.iter().all(|c| *c == 0. || *c == 1.));
                    json!({"rect":[r.x,r.y,r.x+r.width,r.y+r.height],"color":d.color})
                })
                .collect();
            (draws, t)
        })
        .unwrap();
    win.presented(token).unwrap();
    let snapshot = win.inspect().unwrap();
    let target = win.query().name("surface").one().unwrap();
    let mut events = Vec::new();
    let mut held = None;
    for i in 0..16 {
        win.reset_counters().unwrap();
        let color = if i % 2 == 0 {
            Color::WHITE
        } else {
            Color::BLACK
        };
        let commit = win.set(Paint::COLOR, color).unwrap();
        // A statically registered binding names the exact destination. No draw,
        // description, snapshot or bounds enumeration occurs on this route.
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
        let mut fresh = Win::with_size(Paint(Signal::new(color)), 64, 64).unwrap();
        let expected = fresh.with_pixels(|p, _, _| p.to_vec()).unwrap();
        assert_eq!(pixels, expected);
        fs::write(root.join(format!("direct-{i}.rgba")), &pixels).unwrap();
        let accepted = i != 4 && i != 10;
        if accepted {
            win.presented(token).unwrap();
        } else {
            held = Some(token);
        }
        events.push(json!({"index":i,"target":target,"color":if i%2==0{0xffffffffu32}else{0xff000000u32},"accepted":accepted,"commit":commit,"counters":counters,"candidate_property_reads":1,"candidate_snapshot_reads":0,"candidate_draw_enumerations":0,"pixels":format!("direct-{i}.rgba")}));
    }
    fs::write(root.join("direct.json"),serde_json::to_vec_pretty(&json!({"initial_draws":initial,"initial_snapshot":snapshot,"target":target,"events":events,"candidate_initial_snapshot_count":1,"candidate_initial_draw_enumeration_count":1,"scope":"fixture-specific static destination binding; full CPU pixel/View oracles are separate; no generic production chunk integration"})).unwrap()).unwrap();
    // Extract actual immutable image pixels and font-rasterized glyph coverage
    // through the existing borrowed PreparedScene API, then drop every owner.
    let font_path = "/home/user/zgx-native-profile-lab/comparisons/fonts/DejaVuSans.ttf";
    let font_bytes = fs::read(font_path).unwrap();
    let font = FontFace::new(&font_bytes).unwrap();
    let mut cases = Vec::new();
    for (i, title) in ["A", "g", "Ω"].into_iter().enumerate() {
        let bytes: Vec<u8> = (0..64)
            .flat_map(|p| {
                [
                    (p * 3 + i * 7) as u8,
                    (p + i * 13) as u8,
                    (255 - p * 2) as u8,
                    255,
                ]
            })
            .collect();
        let bitmap = Image::rgba8(
            8,
            8,
            ImageProfile::Srgb,
            AlphaMode::Straight,
            bytes.into_boxed_slice(),
        )
        .unwrap();
        let mut assets = Win::recording(
            Assets {
                title: title.into(),
                bitmap,
            },
            WindowOptions {
                size: [64, 64],
                ..Default::default()
            },
        )
        .unwrap();
        assets.set_text_font(font.clone()).unwrap();
        let resources=assets.with_scene(|s,_|{
            let mut files=Vec::new();
            for (j,mask) in s.masks().enumerate(){
                let name=format!("text-{i}-{j}.a8");fs::write(root.join(&name),mask.coverage).unwrap();
                files.push(json!({"kind":"text-mask","file":name,"bytes":mask.coverage.len(),"width":mask.width,"height":mask.height}));
            }
            for (j,img) in s.images().enumerate(){
                let ImagePixels::Rgba8{bytes,..}=img.pixels() else {panic!("RGBA fixture")};
                let name=format!("image-{i}-{j}.rgba");fs::write(root.join(&name),bytes).unwrap();
                files.push(json!({"kind":"image","file":name,"bytes":bytes.len(),"width":img.width(),"height":img.height()}));
            }
            files
        }).unwrap();
        assert!(resources.iter().any(|r| r["kind"] == "text-mask"));
        assert!(resources.iter().any(|r| r["kind"] == "image"));
        cases.push(json!({"index":i,"title":title,"resources":resources}));
        drop(assets);
    }
    drop(font);
    drop(win);
    fs::write(root.join("assets.json"),serde_json::to_vec_pretty(&json!({"font_path":font_path,"font_bytes":font_bytes.len(),"cases":cases,"scope":"owned copies of real borrowed glyph/image bytes; source owners dropped; not a text renderer integration claim"})).unwrap()).unwrap();
}
