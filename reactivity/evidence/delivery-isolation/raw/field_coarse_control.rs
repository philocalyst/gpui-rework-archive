//! Public component/source delivery control. Allocation/work oracle, never timed.
use gpui::{Affine, Component, El, FieldId, Inbox, LaneSet, Remote, Signal, Source, Sources, View, Win, div};
use std::{hint::black_box, mem::{size_of, size_of_val}};
struct Surface { map: Signal<Affine> }
impl Surface {
    const MAP: Source<Self, Affine> = Source::new(FieldId::new(1), "map", |m| &m.map, |m| &mut m.map);
}
impl View for Surface {
    fn sources() -> Sources<Self> { Sources::new().direct(Self::MAP) }
    fn view(&self) -> El<'_> { div().name("surface").w(24).h(16).transform(&self.map) }
}
struct Page { surface: Surface }
impl Page {
    const SURFACE: Component<Self, Surface> = Component::new(FieldId::new(1), "surface", |m| &m.surface, |m| &mut m.surface);
    fn new() -> Self { Self { surface: Surface { map: Signal::new(Affine::IDENTITY) } } }
}
impl View for Page {
    fn sources() -> Sources<Self> { Sources::new().direct_component(Self::SURFACE) }
    fn view(&self) -> El<'_> { Self::SURFACE.view(self) }
}
// The paired coarse control changes only this binding and its expected work.
const EXACT: bool = false;
#[inline(never)]
fn bind(inbox: Inbox<Affine>) -> Win<Page, impl LaneSet<Page>> {
    Win::demo(Page::new()).with_inbox(inbox, |page: &mut Page, value| *page.surface.map = value).unwrap()
}
#[inline(never)]
fn deliver<L: LaneSet<Page>>(win: &mut Win<Page, L>, budget: usize) { assert_eq!(win.deliver_ready(black_box(budget)).unwrap().applied, budget); }
fn main() {
    let mut owner = None;
    let made = allocation_counter::measure(|| {
        let (remote, inbox) = Remote::bounded(8);
        owner = Some((remote, bind(inbox)));
    });
    let (remote, mut win) = owner.take().unwrap();
    println!("owner bytes={} remote={} win={} {made:?}", size_of::<Remote<Affine>>() + size_of_val(&win), size_of_val(&remote), size_of_val(&win));
    let source = &const { Page::SURFACE.source(&Surface::MAP) };
    let target = win.query().name("surface").one().unwrap();
    for batch in 0..3 {
        let sent = allocation_counter::measure(|| for item in 0..8 {
            remote.try_send(Affine::translation((batch * 8 + item + 1) as f32, 2.5)).unwrap();
        });
        assert_eq!(sent.count_total, 0);
        win.reset_counters().unwrap();
        let applied = allocation_counter::measure(|| deliver(black_box(&mut win), 8));
        let map = *win.read(source).unwrap();
        assert_eq!(map.tx, ((batch + 1) * 8) as f32);
        assert_eq!(map.ty, 2.5);
        assert_eq!(win.property(target, gpui::property::TRANSFORM).unwrap(), map);
        let work = win.counters();
        if EXACT {
            assert_eq!(work.owner_reruns, 0);
            assert_eq!(work.descriptions, 0);
            assert_eq!(work.layout_runs, 0);
            assert_eq!(work.measure_calls, 0);
            assert_eq!(work.text_bytes_copied, 0);
        } else { assert_eq!(work.owner_reruns, 1); }
        println!("batch={batch} checksum={:08x}/{:08x} {work:?} {applied:?}", map.tx.to_bits(), map.ty.to_bits());
    }
    win.close();
    assert!(remote.try_send(Affine::IDENTITY).is_err());
}
