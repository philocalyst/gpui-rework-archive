//! One exact hover source is not two property operations or a deferred edit turn.
use gpui::{Error, PresentationToken, WindowOptions, prelude::*, property::BACKGROUND};
const NONE: u32 = u32::MAX;
const CELLS: u32 = 16;
struct Page { hovered: Signal<u32>, alpha: bool, hidden: bool }
impl Page {
    const HOVER: Source<Self, u32> = Source::new(
        FieldId::new(1), "hovered", |model| &model.hovered, |model| &mut model.hovered,
    );
    fn new(hovered: u32, alpha: bool, hidden: bool) -> Self {
        Self { hovered: Signal::new(hovered), alpha, hidden }
    }
}
fn base(index: u32) -> Color { rgb(0x102030 + index * 0x010101) }
impl View for Page {
    fn sources() -> Sources<Self> { Sources::new().direct(Self::HOVER) }
    fn view(&self) -> El<'_> {
        row((0..CELLS).map(|index| {
            div().name(format!("cell-{index}")).size(if self.hidden { 0 } else { 10 })
                .bg(self.hovered.map_with((index, self.alpha), |hovered, (index, alpha)| {
                    if alpha && index == 0 {
                        if *hovered == 0 { Color::TRANSPARENT } else { Color::WHITE }
                    } else if *hovered == index { Color::WHITE } else { base(index) }
                }))
        })).gap(1).w(256).h(24)
    }
}
fn window(alpha: bool, hidden: bool) -> Win<Page> {
    let mut win = Win::recording(Page::new(0, alpha, hidden), WindowOptions {
        size: [256, 24], ..Default::default()
    }).unwrap();
    ack(&mut win);
    win
}
fn token(win: &Win<Page>) -> PresentationToken { win.with_scene(|_, token| token).unwrap() }
fn ack(win: &mut Win<Page>) { win.presented(token(win)).unwrap(); }
fn pixels(win: &mut Win<Page>) -> Vec<u8> { win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap() }
fn cold(win: &mut Win<Page>, hovered: u32, alpha: bool, hidden: bool) {
    let mut reference = Win::with_size(Page::new(hovered, alpha, hidden), 256, 24).unwrap();
    assert_eq!(pixels(win), pixels(&mut reference));
    let normalize = |win: &Win<Page>| {
        let mut nodes = win.snapshot().unwrap().nodes;
        for node in &mut nodes { node.identity = 0; node.target = None; }
        nodes
    };
    assert_eq!(normalize(win), normalize(&reference));
}
#[test]
fn one_source_hover_transfer_changes_two_colors_without_full_scene_or_layout() {
    let mut win = window(false, false);
    let targets: Vec<_> = (0..CELLS).map(|index| win.query().name(&format!("cell-{index}")).one().unwrap()).collect();
    let mut previous = 0;
    for hovered in [1, 2, CELLS - 1, 0] {
        let old_token = token(&win);
        let old_p = win.snapshot().unwrap().nodes;
        let old_pixels = pixels(&mut win);
        win.reset_counters().unwrap();
        let commit = win.set(Page::HOVER, hovered).unwrap();
        assert_eq!(commit.changed_nodes, 2, "one real source transfer changes old and new relationships");
        let work = win.counters();
        assert_eq!(work.source_operations, 1);
        assert_eq!(work.descriptions, 0);
        assert_eq!(work.owner_reruns, 0);
        assert_eq!(work.layout_runs, 0);
        assert_eq!(work.paint_passes, 0, "this is the missing composed multi-slot path");
        assert_ne!(token(&win), old_token);
        assert_eq!(win.snapshot().unwrap().nodes, old_p);
        assert_eq!(win.hit_target(Point { x: 1., y: 1. }), Err(Error::PresentationStale));
        assert_eq!(win.property(targets[previous as usize], BACKGROUND).unwrap().solid(), Some(base(previous)));
        assert_eq!(win.property(targets[hovered as usize], BACKGROUND).unwrap().solid(), Some(Color::WHITE));
        assert_ne!(pixels(&mut win), old_pixels);
        ack(&mut win);
        cold(&mut win, hovered, false, false);
        for (index, target) in targets.iter().enumerate() {
            assert_eq!(win.query().name(&format!("cell-{index}")).one().unwrap(), *target);
        }
        previous = hovered;
    }
}
#[test]
fn alpha_fallback_keeps_every_later_logical_peer_and_full_cold_output() {
    let mut win = window(true, false);
    let peer = win.query().name("cell-1").one().unwrap();
    win.reset_counters().unwrap();
    win.set(Page::HOVER, 1).unwrap();
    assert!(win.counters().paint_passes > 0);
    assert_eq!(win.property(peer, BACKGROUND).unwrap().solid(), Some(Color::WHITE));
    ack(&mut win);
    cold(&mut win, 1, true, false);
}
#[test]
fn absent_complete_slots_relabel_only_without_making_a_false_visual_candidate() {
    let mut win = window(false, true);
    let unchanged = pixels(&mut win);
    let before = token(&win);
    win.reset_counters().unwrap();
    win.set(Page::HOVER, 1).unwrap();
    assert_eq!(token(&win), before);
    assert_eq!(win.counters().paint_passes, 0);
    assert_eq!(win.counters().layout_runs, 0);
    assert_eq!(win.snapshot().unwrap().source_epoch, win.snapshot().unwrap().presentation_epoch);
    assert_eq!(pixels(&mut win), unchanged);
    cold(&mut win, 1, false, true);
}
#[test]
fn deferred_sources_keep_old_canvas_then_take_full_finish_not_cross_turn_slot_transport() {
    let mut win = window(false, false);
    let before = token(&win);
    let old_pixels = pixels(&mut win);
    win.reset_counters().unwrap();
    {
        let mut turn = win.edit_turn().unwrap();
        turn.set(Page::HOVER, 1).unwrap();
        turn.set(Page::HOVER, 2).unwrap();
        drop(turn);
    }
    assert_eq!(token(&win), before);
    assert_eq!(pixels(&mut win), old_pixels);
    assert_eq!(win.counters().source_operations, 2);
    assert_eq!(win.counters().paint_passes, 0);
    win.settle().unwrap();
    assert!(win.counters().paint_passes > 0, "deferred publication retains its full-preparation fallback");
    ack(&mut win);
    cold(&mut win, 2, false, false);
}
#[test]
fn unused_source_value_remains_a_nonvisual_complete_relabel() {
    let mut win = window(false, false);
    win.set(Page::HOVER, NONE).unwrap();
    ack(&mut win);
    win.reset_counters().unwrap();
    let before = token(&win);
    win.set(Page::HOVER, NONE - 1).unwrap();
    assert_eq!(token(&win), before);
    assert_eq!(win.counters().paint_passes, 0);
    cold(&mut win, NONE - 1, false, false);
}
