use super::*;
use crate::{Axis, ItemKey, ItemSource, Signal, column, div, row, uniform_list};

struct Page {
    count: usize,
    overlay: bool,
    broken: bool,
    color: Signal<Color>,
}
impl Page {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR)
    }
    fn view(&self) -> crate::El<'_> {
        column((
            row((
                div()
                    .size(20)
                    .bg(&self.color)
                    .rounded(8.0)
                    .on_click(|_: &mut Self| {}),
                div()
                    .size(20)
                    .name("transparent")
                    .on_click(|_: &mut Self| {}),
                div().size(20).bg(Color::BLACK),
            )),
            // An ordinary viewport clips descendants but retains their P.
            column((0..self.count).map(|_| div().size(4).bg(Color::BLACK)))
                .size(32)
                .scroll(Axis::Y),
            self.overlay.then(|| {
                div()
                    .size(20)
                    .bg(Color::BLACK)
                    .transform(Affine::translation(0.0, -52.0))
            }),
            div()
                .size(4)
                .transform(if self.broken {
                    Affine::scale(0.0, 1.0)
                } else {
                    Affine::IDENTITY
                })
                .bg(Color::BLACK),
        ))
    }
}
// Frozen exhaustive oracle: the previous implementation's reverse scan and
// ancestor routing. It reads row eligibility, never compressed jumps.
fn exhaustive<M: View + 'static>(runtime: &Runtime<M>, point: Point) -> Option<u64> {
    if !Rect::new(
        0.0,
        0.0,
        runtime.presentation_size[0] as f32,
        runtime.presentation_size[1] as f32,
    )
    .contains(point)
    {
        return None;
    }
    for (index, node) in runtime.presented.iter().enumerate().rev() {
        if node.hittable && runtime.sheet_hit(index, point) {
            let mut cursor = Some(index);
            while let Some(index) = cursor {
                let node = &runtime.presented[index];
                if let Some(logical) = runtime.by_identity.get(node.identity)
                    && (runtime.nodes[logical].has_route() || node.kind == NodeKind::Input)
                {
                    return Some(node.identity);
                }
                cursor = node.parent.index();
            }
            return None;
        }
    }
    None
}
fn compare<M: View + 'static>(win: &Win<M>) {
    let runtime = win.runtime().unwrap();
    assert_eq!(size_of::<Presented>(), 64);
    let step = if runtime.presented.len() > 5000 {
        16
    } else {
        1
    };
    for y in (-1..65).step_by(step) {
        for x in (-1..65).step_by(step) {
            let point = Point {
                x: x as f32 + 0.5,
                y: y as f32 + 0.5,
            };
            assert_eq!(runtime.hit(point), exhaustive(runtime, point), "{point:?}");
        }
    }
    let mut impossible = 0;
    for (index, node) in runtime.presented.iter().enumerate() {
        assert!(node.parent.index().is_none_or(|parent| parent < index));
        if node.bounds.is_empty() {
            assert!(!node.hittable);
            assert!(!runtime.sheet_hit(index, Point { x: 0.0, y: 0.0 }));
        }
        if !node.hittable || node.bounds.is_empty() {
            impossible += 1;
        } else {
            impossible = 0;
        }
        assert_eq!(node.parent.skip(), impossible.min(PresentedLink::MAX_SKIP));
    }
}
#[test]
fn compressed_hits_match_exhaustive_routing_across_publication_and_failure() {
    for count in [
        0, 1, 126, 127, 128, 255, 256, 4096, 32766, 32767, 32768, 65536, 99990,
    ] {
        let mut win = Win::recording(
            Page {
                count,
                overlay: false,
                broken: false,
                color: Signal::new(Color::BLACK),
            },
            WindowOptions {
                size: [64, 64],
                ..Default::default()
            },
        )
        .unwrap();
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        compare(&win);
        let links: Vec<_> = win
            .runtime()
            .unwrap()
            .presented
            .iter()
            .map(|n| n.parent.0)
            .collect();
        win.set(Page::COLOR, Color::rgb(1, 2, 3)).unwrap();
        assert_eq!(
            win.runtime()
                .unwrap()
                .presented
                .iter()
                .map(|n| n.parent.0)
                .collect::<Vec<_>>(),
            links
        );
        compare(&win); // same-alpha paint candidates retain the exact old P
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        compare(&win);
        win.update(|page| page.overlay = true).unwrap();
        compare(&win); // pending C cannot replace P's skip proof
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        compare(&win);
        assert!(win.update(|page| page.broken = true).is_err());
        compare(&win); // failed preparation retains the complete old sheet
    }
}

#[test]
fn packed_parent_and_saturated_runs_have_independent_exact_domains() {
    assert_eq!(size_of::<PresentedLink>(), size_of::<Parent>());
    for parent in [None, Some(0), Some(32767), Some(65535), Some(MAX_NODES - 1)] {
        let mut previous = None;
        for run in 1..=MAX_NODES {
            let link = PresentedLink::new(Parent::new(parent), true, previous);
            assert_eq!(link.index(), parent);
            assert_eq!(link.skip(), run.min(PresentedLink::MAX_SKIP));
            previous = Some(link);
        }
        let eligible = PresentedLink::new(Parent::new(parent), false, previous);
        assert_eq!(eligible.index(), parent);
        assert_eq!(eligible.skip(), 0);
    }
}

#[test]
fn compacted_list_parents_and_scroll_keep_exact_routing() {
    struct Rows;
    const LIST: ListId = ListId::new(1);
    impl ItemSource for Rows {
        fn len(&self) -> usize {
            100
        }
        fn key(&self, index: usize) -> ItemKey {
            ItemKey::new(index as u64)
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            (key.get() < 100).then_some(key.get() as usize)
        }
        fn row(&self, _: usize) -> crate::El<'_> {
            column((
                div().size(0), // pruned from P: subsequent parents need remapping
                div()
                    .h(0)
                    .child(div().size(20).bg(Color::BLACK).on_click(|_: &mut Self| {})),
            ))
        }
    }
    impl View for Rows {
        fn view(&self) -> crate::El<'_> {
            column((div().h(8), uniform_list(LIST, self, 32).size(64)))
        }
    }
    let mut win = Win::with_size(Rows, 64, 64).unwrap();
    compare(&win);
    assert!(win.runtime().unwrap().presented.len() < win.runtime().unwrap().nodes.len());
    let list = win.list(LIST).unwrap();
    for delta in [0.25, 31.0, 64.0, -48.5] {
        win.scroll(list, delta).unwrap();
        compare(&win);
    }
}
