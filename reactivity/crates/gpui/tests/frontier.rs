use gpui::{Error, WindowOptions, prelude::*};
use std::path::Path;

#[derive(Clone, Copy, Debug)]
enum Kind {
    Plain,
    Clip,
    Wide,
    List,
    Scroll,
    Deep,
}
struct Fixture {
    kind: Kind,
    nodes: usize,
    broken: bool,
}
impl ItemSource for Fixture {
    fn len(&self) -> usize {
        if matches!(self.kind, Kind::List) && self.nodes > 4096 {
            (self.nodes - 1) / 3
        } else {
            self.nodes
        }
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64 + 1)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        let index = key.get().checked_sub(1)? as usize;
        (index < self.len()).then_some(index)
    }
    fn row(&self, index: usize) -> El<'_> {
        let row = div()
            .w(40)
            .h(1)
            .name(format!("item{index}"))
            .bg(if index % 2 == 0 {
                Color::BLACK
            } else {
                Color::rgb(30, 50, 80)
            });
        if self.nodes > 4096 {
            row.child(div().w(40).h(1).name(format!("child{index}")))
        } else {
            row
        }
    }
}
impl View for Fixture {
    fn view(&self) -> El<'_> {
        let fail = if self.broken {
            Affine::scale(0.0, 1.0)
        } else {
            Affine::IDENTITY
        };
        if matches!(self.kind, Kind::List) {
            return uniform_list(ListId::new(31), self, 1)
                .w(40)
                .h(self.len() as f32)
                .name("fixture")
                .transform(fail);
        }
        if matches!(self.kind, Kind::Deep) {
            let mut child = div().w(8).h(8).bg(Color::BLACK).name("leaf");
            for index in 1..self.nodes {
                child = div()
                    .w(16)
                    .h(16)
                    .name(format!("depth{index}"))
                    .transform(Affine::translation(0.125, -0.0625))
                    .child(child);
            }
            return child.transform(fail);
        }
        let content = column((1..self.nodes).map(|index| {
            let child = div()
                .w(40)
                .h(1)
                .name(format!("row{index}"))
                .bg(if index % 2 == 0 {
                    Color::BLACK
                } else {
                    Color::rgb(90, 30, 50)
                });
            if matches!(self.kind, Kind::Wide) {
                child.transform(Affine::translation((index % 3) as f32 * 0.125, 0.0))
            } else {
                child
            }
        }))
        .w(40)
        .h(32)
        .name("fixture")
        .transform(fail);
        match self.kind {
            Kind::Clip => content.rounded(5.0).clip(),
            Kind::Scroll => content.scroll(Axis::BOTH),
            _ => content,
        }
    }
}
fn ack<M: View + 'static>(win: &mut Win<M>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn evidence<M: View + 'static>(win: &mut Win<M>, path: &Path, label: &str) {
    std::fs::write(
        path.join(format!("{label}.json")),
        win.semantics().unwrap().to_json().unwrap(),
    )
    .unwrap();
    let mut hits = Vec::new();
    win.visit(|part| {
        for y in [0.125, 0.5, 1.5, 15.5, 31.875, 63.5] {
            for x in [0.125, 0.5, 1.5, 15.5, 31.875, 63.5] {
                hits.push(u8::from(part.contains_point(Point { x, y })));
            }
        }
    })
    .unwrap();
    std::fs::write(path.join(format!("{label}.hits")), hits).unwrap();
    win.with_pixels(|pixels, _, _| {
        std::fs::write(path.join(format!("{label}.rgba")), pixels).unwrap()
    })
    .unwrap();
}
#[test]
fn allocation_and_exact_public_sheet_corpus() {
    let out = std::env::var("GPUI_FRONTIER_EVIDENCE")
        .unwrap_or_else(|_| format!("/tmp/gpui-frontier-public-{}", std::process::id()));
    let out = Path::new(&out);
    std::fs::create_dir_all(out).unwrap();
    drop(
        Win::recording(
            Fixture {
                kind: Kind::Plain,
                nodes: 1,
                broken: false,
            },
            WindowOptions::default(),
        )
        .unwrap(),
    );
    for kind in [
        Kind::Plain,
        Kind::Clip,
        Kind::Wide,
        Kind::List,
        Kind::Scroll,
        Kind::Deep,
    ] {
        for nodes in if matches!(kind, Kind::Deep) {
            [1, 32, 129]
        } else {
            [1, 32, 10000]
        } {
            let label = format!("{kind:?}-{nodes}");
            let mut owner = None;
            let cold = allocation_counter::measure(|| {
                owner = Some(
                    Win::recording(
                        Fixture {
                            kind,
                            nodes,
                            broken: false,
                        },
                        WindowOptions {
                            size: [64, 64],
                            ..Default::default()
                        },
                    )
                    .unwrap(),
                );
            });
            let mut win = owner.unwrap();
            ack(&mut win);
            evidence(&mut win, out, &format!("{label}-cold"));
            let warm = allocation_counter::measure(|| {
                win.resize([64, 65]).unwrap();
                ack(&mut win);
                win.resize([64, 64]).unwrap();
                ack(&mut win);
            });
            evidence(&mut win, out, &format!("{label}-warm"));
            println!(
                "FRONTIER_ALLOC {label} logical={} cold={},{},{},{} warm={},{},{},{}",
                win.snapshot().unwrap().nodes.len(),
                cold.count_total,
                cold.bytes_total,
                cold.bytes_current,
                cold.bytes_max,
                warm.count_total,
                warm.bytes_total,
                warm.bytes_current,
                warm.bytes_max
            );
        }
    }
}

struct Mixed {
    broken: bool,
    phase: bool,
}
impl ItemSource for Mixed {
    fn len(&self) -> usize {
        100
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64 + 1)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        let n = key.get().checked_sub(1)? as usize;
        (n < 100).then_some(n)
    }
    fn row(&self, index: usize) -> El<'_> {
        let nested = column((
            div()
                .w(35)
                .h(4)
                .name(format!("inside{index}"))
                .bg(Color::BLACK),
            div()
                .w(12)
                .h(4)
                .name(format!("tail{index}"))
                .bg(Color::rgb(100, 40, 90)),
        ))
        .w(20)
        .h(6)
        .scroll(Axis::BOTH)
        .name(format!("nested{index}"));
        div()
            .w(24)
            .h(8)
            .rounded(1.)
            .clip()
            .name(format!("row{index}"))
            .child(nested)
    }
}
impl View for Mixed {
    fn view(&self) -> El<'_> {
        let branch = column((
            div()
                .size(12)
                .rounded(3.)
                .clip()
                .transform(Affine::translation(0.25, 0.5))
                .child(div().size(18).name("clipped-leaf").bg(Color::BLACK)),
            div()
                .size(8)
                .name("after-unwind")
                .bg(Color::rgb(60, 100, 30)),
            uniform_list(ListId::new(17), self, 8)
                .w(24)
                .h(16)
                .name("nested-list"),
        ))
        .w(32)
        .h(24)
        .scroll(Axis::BOTH)
        .name("outer-scroll");
        column((
            branch,
            div()
                .size(8)
                .clip()
                .name("last-sibling")
                .bg(if self.phase {
                    Color::BLACK
                } else {
                    Color::WHITE
                })
                .transform(if self.broken {
                    Affine::scale(0., 1.)
                } else {
                    Affine::IDENTITY
                }),
        ))
        .size(48)
        .rounded(4.)
        .clip()
        .name("mixed-root")
    }
}
#[test]
fn sibling_unwind_nested_viewports_and_late_failure_preserve_acknowledgement() {
    let out = std::env::var("GPUI_FRONTIER_EVIDENCE")
        .unwrap_or_else(|_| format!("/tmp/gpui-frontier-public-{}", std::process::id()));
    let out = Path::new(&out);
    std::fs::create_dir_all(out).unwrap();
    let mut win = Win::recording(
        Mixed {
            broken: false,
            phase: false,
        },
        WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    evidence(&mut win, out, "mixed-p");
    let outer = win.query().name("outer-scroll").one().unwrap();
    let nested = win.query().name("nested0").one().unwrap();
    win.scroll_to(nested, ScrollOffset { x: 4., y: 2. })
        .unwrap();
    ack(&mut win);
    win.scroll_to(outer, ScrollOffset { x: 0., y: 5. }).unwrap();
    ack(&mut win);
    evidence(&mut win, out, "mixed-scrolled");
    win.update(|page| page.phase = true).unwrap();
    let eligible = win.with_scene(|_, token| token).unwrap();
    let prior = win.semantics().unwrap().to_json().unwrap();
    let old_pixels = win.with_pixels(|bytes, _, _| bytes.to_vec()).unwrap();
    assert!(win.update(|page| page.broken = true).is_err());
    assert_eq!(win.with_scene(|_, token| token).unwrap(), eligible);
    assert_eq!(
        win.with_pixels(|bytes, _, _| bytes.to_vec()).unwrap(),
        old_pixels
    );
    let after: serde_json::Value =
        serde_json::from_str(&win.semantics().unwrap().to_json().unwrap()).unwrap();
    let prior: serde_json::Value = serde_json::from_str(&prior).unwrap();
    assert_eq!(after["nodes"], prior["nodes"]);
    win.presented(eligible).unwrap();
    evidence(&mut win, out, "mixed-eligible-after-failure");
    win.update(|page| page.broken = false).unwrap();
    ack(&mut win);
    evidence(&mut win, out, "mixed-repaired");
}
#[test]
fn layout_depth_128_is_admitted_and_129_is_rejected_without_losing_candidate() {
    let mut win = Win::recording(
        Fixture {
            kind: Kind::Deep,
            nodes: 129,
            broken: false,
        },
        WindowOptions {
            size: [32, 32],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    win.resize([33, 32]).unwrap();
    let eligible = win.with_scene(|_, token| token).unwrap();
    assert!(matches!(
        win.update(|page| page.nodes = 130),
        Err(Error::DepthLimit { .. })
    ));
    assert_eq!(win.with_scene(|_, token| token).unwrap(), eligible);
    win.presented(eligible).unwrap();
}
