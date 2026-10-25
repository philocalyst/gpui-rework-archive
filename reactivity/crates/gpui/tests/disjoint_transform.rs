//! Public controls for disjoint direct transforms; full presentation remains ordinary.
use gpui::{ItemKey, ItemSource, ListId, WindowOptions, prelude::*};
const LIST: ListId = ListId::new(31);
#[derive(Clone, Copy)]
enum Placement { Sibling, Ancestor, InsideList, InsideScroll, MixedLayout }
struct Page { transform: Signal<Affine>, placement: Placement }
impl Page {
    const TRANSFORM: Source<Self, Affine> = Source::new(
        FieldId::new(1), "transform", |m| &m.transform, |m| &mut m.transform,
    );
    fn new(placement: Placement) -> Self { Self { transform: Signal::new(Affine::IDENTITY), placement } }
}
impl ItemSource for Page {
    fn len(&self) -> usize { 8 }
    fn key(&self, index: usize) -> ItemKey { ItemKey::new(index as u64 + 1) }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        (1..=8).contains(&key.get()).then(|| key.get() as usize - 1)
    }
    fn row(&self, _index: usize) -> El<'_> {
        let row = text("row").h(12);
        if matches!(self.placement, Placement::InsideList) {
            row.transform(&self.transform)
        } else { row }
    }
}
impl View for Page {
    fn sources() -> Sources<Self> { Sources::new().direct(Self::TRANSFORM) }
    fn view(&self) -> El<'_> {
        let pane = uniform_list(LIST, self, 12).w(120).h(48);
        if matches!(self.placement, Placement::Ancestor) {
            // Negative authority control: transform ancestor of a viewport.
            column((div().size(8).bg(Color::WHITE), pane)).transform(&self.transform)
        } else {
            let mut popup = div().name("popup").size(8).bg(rgb(0x3388aa)).child(text("P"))
                .transform(&self.transform);
            if matches!(self.placement, Placement::MixedLayout) {
                popup = popup.w(self.transform.map(|value| value.tx.abs() + 8.));
            }
            if matches!(self.placement, Placement::InsideScroll) {
                popup = popup.scroll(Axis::Y);
            }
            column((popup, pane))
        }
    }
}
fn window(placement: Placement) -> Win<Page> {
    let mut win = Win::recording(Page::new(placement), WindowOptions {
        size: [160, 120], ..Default::default()
    }).unwrap();
    ack(&mut win);
    win
}
fn ack(win: &mut Win<Page>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn equal(a: &mut Win<Page>, b: &mut Win<Page>) {
    let mut actual = a.snapshot().unwrap();
    let mut expected = b.snapshot().unwrap();
    for node in actual.nodes.iter_mut().chain(expected.nodes.iter_mut()) { node.target = None; }
    assert_eq!(actual, expected);
    let pixels = a.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
    b.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
}
#[test]
fn exact_disjoint_transform_skips_description_but_rebuilds_complete_presentation() {
    let mut exact = window(Placement::Sibling);
    let mut coarse = window(Placement::Sibling);
    let popup = exact.query().name("popup").one().unwrap();
    let pane = exact.list(LIST).unwrap();
    let row = exact.list_item(pane, ItemKey::new(2)).unwrap();
    for value in [Affine::translation(5., 3.), Affine::translation(11., 1.), Affine::IDENTITY] {
        exact.reset_counters().unwrap();
        coarse.reset_counters().unwrap();
        let old = exact.snapshot().unwrap();
        let old_bounds = exact.bounds(popup).unwrap();
        exact.set(Page::TRANSFORM, value).unwrap();
        // Public forced-coarse oracle with identical logical source-operation history.
        coarse.update(|model| model.transform = Signal::new(value)).unwrap();
        assert_eq!(exact.counters().descriptions, 0);
        assert_eq!(exact.counters().owner_reruns, 0);
        assert!(exact.counters().paint_passes > 0, "not a retained Canvas/GPU claim");
        assert!(coarse.counters().descriptions > 0);
        assert!(coarse.counters().owner_reruns > 0);
        // No publication or capability replacement before actual recording ACK.
        assert_eq!(exact.snapshot().unwrap().nodes, old.nodes);
        ack(&mut exact);
        ack(&mut coarse);
        assert_ne!(exact.bounds(popup).unwrap(), old_bounds, "genuine geometry change");
        assert_eq!(exact.list(LIST).unwrap(), pane);
        assert_eq!(exact.list_item(pane, ItemKey::new(2)).unwrap(), row);
        equal(&mut exact, &mut coarse);
        // Independent freshly realized full-output oracle; identity history differs.
        let mut fresh = Win::with_size(Page { transform: Signal::new(value), placement: Placement::Sibling }, 160, 120).unwrap();
        let pixels = exact.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
        fresh.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
    }
}
#[test]
fn viewport_ancestry_and_mixed_layout_keep_original_description_authority() {
    for placement in [Placement::Ancestor, Placement::InsideList, Placement::InsideScroll, Placement::MixedLayout] {
        let mut win = window(placement);
        win.reset_counters().unwrap();
        win.set(Page::TRANSFORM, Affine::translation(3., 2.)).unwrap();
        assert!(win.counters().descriptions > 0);
        assert!(win.counters().owner_reruns > 0);
        ack(&mut win);
        let mut fresh = Win::with_size(Page {
            transform: Signal::new(Affine::translation(3., 2.)), placement,
        }, 160, 120).unwrap();
        let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
        fresh.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
    }
}

#[test]
fn pending_complete_then_failed_newer_transform_keeps_old_ack_and_full_repair() {
    let mut win = window(Placement::Sibling);
    let old_rows = win.snapshot().unwrap().nodes;
    win.reset_counters().unwrap();
    win.set(Page::TRANSFORM, Affine::translation(4., 1.)).unwrap();
    win.set(Page::TRANSFORM, Affine::translation(9., 2.)).unwrap();
    assert_eq!(win.counters().descriptions, 0);
    assert_eq!(win.counters().source_operations, 2);
    let eligible = win.with_scene(|_, token| token).unwrap();
    assert!(win.set(Page::TRANSFORM, Affine::scale(0., 1.)).is_err());
    assert_eq!(win.with_scene(|_, token| token).unwrap(), eligible);
    assert_eq!(win.snapshot().unwrap().nodes, old_rows);
    let receipt = win.presented(eligible).unwrap();
    assert!(receipt.presentation_epoch < receipt.source_epoch);
    let mut expected = Win::with_size(Page {
        transform: Signal::new(Affine::translation(9., 2.)), placement: Placement::Sibling,
    }, 160, 120).unwrap();
    let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
    expected.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
    win.reset_counters().unwrap();
    win.set(Page::TRANSFORM, Affine::translation(6., 1.)).unwrap();
    assert!(win.counters().descriptions > 0, "failed preparation disables certificate");
    ack(&mut win);
    let mut expected = Win::with_size(Page {
        transform: Signal::new(Affine::translation(6., 1.)), placement: Placement::Sibling,
    }, 160, 120).unwrap();
    let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
    expected.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
}

#[test]
fn pending_physical_size_or_scale_keeps_original_realization_boundary() {
    for (size, scale) in [([180, 140], 1.), ([160, 120], 1.25)] {
        let mut win = window(Placement::Sibling);
        win.resize_scaled(size, scale).unwrap();
        win.reset_counters().unwrap();
        win.set(Page::TRANSFORM, Affine::translation(3., 1.)).unwrap();
        assert!(win.counters().descriptions > 0);
        ack(&mut win);
        let mut expected = Win::with_options_scaled(Page {
            transform: Signal::new(Affine::translation(3., 1.)), placement: Placement::Sibling,
        }, WindowOptions { size, ..Default::default() }, scale).unwrap();
        let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
        expected.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
    }
}

#[test]
fn mixed_visual_text_sink_keeps_original_description_boundary() {
    struct NumberPage { value: Signal<f64> }
    impl NumberPage {
        const VALUE: Source<Self, f64> = Source::new(
            FieldId::new(1), "value", |m| &m.value, |m| &mut m.value,
        );
    }
    impl ItemSource for NumberPage {
        fn len(&self) -> usize { 8 }
        fn key(&self, index: usize) -> ItemKey { ItemKey::new(index as u64 + 1) }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            (1..=8).contains(&key.get()).then(|| key.get() as usize - 1)
        }
        fn row(&self, _index: usize) -> El<'_> { text("row").h(12) }
    }
    impl View for NumberPage {
        fn sources() -> Sources<Self> { Sources::new().direct(Self::VALUE) }
        fn view(&self) -> El<'_> {
            column((
                text(&self.value).h(14),
                div().size(8).bg(rgb(0x3388aa))
                    .transform(self.value.map(|value| Affine::translation(*value as f32, 0.))),
                uniform_list(LIST, self, 12).w(120).h(48),
            ))
        }
    }
    let mut win = Win::recording(NumberPage { value: Signal::new(1.) }, WindowOptions {
        size: [160, 120], ..Default::default()
    }).unwrap();
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    win.reset_counters().unwrap();
    win.set(NumberPage::VALUE, 3.).unwrap();
    assert!(win.counters().descriptions > 0);
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    let mut fresh = Win::with_size(NumberPage { value: Signal::new(3.) }, 160, 120).unwrap();
    let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
    fresh.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
}
