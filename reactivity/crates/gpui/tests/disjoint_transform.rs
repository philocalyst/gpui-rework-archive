//! Versioned intrinsic-dependency controls. Original disjoint-dispatcher work
#![cfg(feature = "source-observation-experiment")]
//! expectations remain frozen at81cd; every full-output/authority oracle stays.
use gpui::{ItemKey, ItemSource, ListId, WindowOptions, prelude::*};
const LIST: ListId = ListId::new(31);
#[derive(Clone, Copy)]
enum Placement { Sibling, Ancestor, InsideList, InsideScroll, MixedLayout }
struct Page { transform: Signal<Affine>, placement: Placement, tracked: bool }
impl Page {
    const TRANSFORM: Source<Self, Affine> = Source::new(
        FieldId::new(1), "transform", |m| &m.transform, |m| &mut m.transform,
    );
    fn new(placement: Placement) -> Self { Self { transform: Signal::new(Affine::IDENTITY), placement, tracked: false } }
}
impl ItemSource for Page {
    fn observation_dependencies(&self)->Option<&[FieldId]> {self.tracked.then_some(&[])}
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
            // Ordinary ancestor transform: affects placement/clip, not local list planning.
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
fn untracked_source_keeps_observation_and_complete_presentation() {
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
        assert!(exact.counters().descriptions > 0, "legacy ItemSource has no across-turn read witness");
        assert!(exact.counters().owner_reruns > 0);
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
        let mut fresh = Win::with_size(Page { tracked: false, transform: Signal::new(value), placement: Placement::Sibling }, 160, 120).unwrap();
        let pixels = exact.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
        fresh.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
    }
}
#[test]
fn viewport_ancestry_and_sibling_width_do_not_read_intrinsic_list_realization() {
    for placement in [Placement::Ancestor, Placement::InsideList, Placement::InsideScroll, Placement::MixedLayout] {
        let mut win = window(placement);
        win.reset_counters().unwrap();
        win.set(Page::TRANSFORM, Affine::translation(3., 2.)).unwrap();
        assert!(win.counters().descriptions > 0, "untracked external item/template reads must be observed");
        assert!(win.counters().owner_reruns > 0);
        ack(&mut win);
        let mut fresh = Win::with_size(Page {
            tracked: false, transform: Signal::new(Affine::translation(3., 2.)), placement,
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
    assert!(win.counters().descriptions > 0);
    assert_eq!(win.counters().source_operations, 2);
    let eligible = win.with_scene(|_, token| token).unwrap();
    assert!(win.set(Page::TRANSFORM, Affine::scale(0., 1.)).is_err());
    assert_eq!(win.with_scene(|_, token| token).unwrap(), eligible);
    assert_eq!(win.snapshot().unwrap().nodes, old_rows);
    let receipt = win.presented(eligible).unwrap();
    assert!(receipt.presentation_epoch < receipt.source_epoch);
    let mut expected = Win::with_size(Page {
        tracked: false, transform: Signal::new(Affine::translation(9., 2.)), placement: Placement::Sibling,
    }, 160, 120).unwrap();
    let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
    expected.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
    win.reset_counters().unwrap();
    win.set(Page::TRANSFORM, Affine::translation(6., 1.)).unwrap();
    assert!(win.counters().descriptions > 0, "untracked source is observed during full repair");
    assert!(win.counters().layout_runs > 0);
    assert!(win.counters().paint_passes > 0);
    ack(&mut win);
    let mut expected = Win::with_size(Page {
        tracked: false, transform: Signal::new(Affine::translation(6., 1.)), placement: Placement::Sibling,
    }, 160, 120).unwrap();
    let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
    expected.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
}

#[test]
fn pending_physical_size_or_scale_preserves_intrinsic_read_boundary() {
    for (size, scale) in [([180, 140], 1.), ([160, 120], 1.25)] {
        let mut win = window(Placement::Sibling);
        win.resize_scaled(size, scale).unwrap();
        win.reset_counters().unwrap();
        win.set(Page::TRANSFORM, Affine::translation(3., 1.)).unwrap();
        assert!(win.counters().descriptions > 0, "legacy external source observation boundary retained");
        ack(&mut win);
        let mut expected = Win::with_options_scaled(Page {
            tracked: false, transform: Signal::new(Affine::translation(3., 1.)), placement: Placement::Sibling,
        }, WindowOptions { size, ..Default::default() }, scale).unwrap();
        let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
        expected.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
    }
}

#[test]
fn mixed_visual_text_and_world_transform_preserve_local_realization_inputs() {
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
    assert!(win.counters().descriptions > 0, "untracked template reads remain conservative");
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    let mut fresh = Win::with_size(NumberPage { value: Signal::new(3.) }, 160, 120).unwrap();
    let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
    fresh.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
}

#[test]
fn many_sinks_and_viewports_use_shared_intrinsic_dependencies_without_redescription() {
    struct Crowded { transform: Signal<Affine> }
    impl Crowded {
        const TRANSFORM: Source<Self, Affine> = Source::new(
            FieldId::new(1), "transform", |m| &m.transform, |m| &mut m.transform,
        );
    }
    impl ItemSource for Crowded {
        fn len(&self) -> usize { 2 }
        fn key(&self, index: usize) -> ItemKey { ItemKey::new(index as u64 + 1) }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            (1..=2).contains(&key.get()).then(|| key.get() as usize - 1)
        }
        fn row(&self, _index: usize) -> El<'_> { text("row").h(12) }
    }
    impl View for Crowded {
        fn sources() -> Sources<Self> { Sources::new().direct(Self::TRANSFORM) }
        fn view(&self) -> El<'_> {
            column((0..32).map(|index| column((
                div().size(3).bg(rgb(0x3388aa)).transform(&self.transform),
                uniform_list(ListId::new(index + 1), self, 12).w(120).h(12),
            ))))
        }
    }
    let mut win = Win::recording(Crowded { transform: Signal::new(Affine::IDENTITY) }, WindowOptions {
        size: [160, 120], ..Default::default()
    }).unwrap();
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    win.reset_counters().unwrap();
    win.set(Crowded::TRANSFORM, Affine::translation(2., 1.)).unwrap();
    assert!(win.counters().descriptions > 0, "untracked sources cannot claim stable template evidence");
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    let mut fresh = Win::with_size(Crowded {
        transform: Signal::new(Affine::translation(2., 1.)),
    }, 160, 120).unwrap();
    let pixels = win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
    fresh.with_pixels(|expected, _, _| assert_eq!(pixels, expected)).unwrap();
}

#[test]
fn matched_tracked_source_adapter_earns_the_same_transform_pass_removal() {
    let mut tracked=Win::recording(Page {transform:Signal::new(Affine::IDENTITY),placement:Placement::Sibling,tracked:true},WindowOptions {size:[160,120],..Default::default()}).unwrap();
    ack(&mut tracked);let mut legacy=window(Placement::Sibling);
    for value in [Affine::translation(3.,1.),Affine::translation(7.,2.),Affine::IDENTITY] {
        tracked.reset_counters().unwrap();legacy.reset_counters().unwrap();
        // Identical real interaction operation; only explicit source/template
        // capability differs. This is NOT a win on the untouched old fixture.
        tracked.set(Page::TRANSFORM,value).unwrap();legacy.set(Page::TRANSFORM,value).unwrap();
        assert_eq!(tracked.counters().descriptions,0);assert!(legacy.counters().descriptions>0);
        ack(&mut tracked);ack(&mut legacy);equal(&mut tracked,&mut legacy);
        let mut fresh=Win::with_size(Page {transform:Signal::new(value),placement:Placement::Sibling,tracked:true},160,120).unwrap();
        let pixels=tracked.with_pixels(|p,_,_|p.to_vec()).unwrap();fresh.with_pixels(|p,_,_|assert_eq!(pixels,p)).unwrap();
    }
}
