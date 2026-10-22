use super::*;
use crate::{Axis, column, div, row};

struct Page {
    count: usize,
    overlay: bool,
    broken: bool,
}
impl View for Page {
    fn view(&self) -> crate::El<'_> {
        column((
            row((
                div()
                    .size(20)
                    .bg(Color::BLACK)
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
// ancestor routing. It reads original eligibility, never compressed jumps.
fn exhaustive(runtime: &Runtime<Page>, point: Point) -> Option<u64> {
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
        if node.hit.eligible() && runtime.sheet_hit(index, point) {
            let mut cursor = Some(index);
            while let Some(index) = cursor {
                let node = &runtime.presented[index];
                if let Some(&logical) = runtime.by_identity.get(&node.identity)
                    && (runtime.nodes[logical].handler.is_some() || node.kind == NodeKind::Input)
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
fn compare(win: &Win<Page>) {
    let runtime = win.runtime().unwrap();
    assert_eq!(size_of::<Presented>(), 80);
    for y in -1..65 {
        for x in -1..65 {
            let point = Point {
                x: x as f32 + 0.5,
                y: y as f32 + 0.5,
            };
            assert_eq!(runtime.hit(point), exhaustive(runtime, point), "{point:?}");
        }
    }
    let mut impossible = 0;
    for node in &runtime.presented {
        if !node.hit.eligible() || node.bounds.is_empty() {
            impossible += 1;
        } else {
            impossible = 0;
        }
        assert_eq!(node.hit.skip(), impossible.min(127));
    }
}
#[test]
fn compressed_hits_match_exhaustive_routing_across_publication_and_failure() {
    for count in [0, 1, 126, 127, 128, 255, 256, 4096] {
        let mut win = Win::recording(
            Page {
                count,
                overlay: false,
                broken: false,
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
        win.update(|page| page.overlay = true).unwrap();
        compare(&win); // pending C cannot replace P's skip proof
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        compare(&win);
        assert!(win.update(|page| page.broken = true).is_err());
        compare(&win); // failed preparation retains the complete old sheet
    }
}
