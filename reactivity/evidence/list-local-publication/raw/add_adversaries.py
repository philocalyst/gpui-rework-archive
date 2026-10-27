from pathlib import Path
p=Path('/home/user/gpui-local-publication-lab/reactivity/crates/gpui/tests/local_publication.rs')
s=p.read_text().replace('fn ack(win: &mut Win<Page>)', "fn ack<M: View + 'static>(win: &mut Win<M>)").replace('fn pixels(win: &mut Win<Page>)', "fn pixels<M: View + 'static>(win: &mut Win<M>)").replace('fn text_state(win: &Win<Page>)', "fn text_state<M: View + 'static>(win: &Win<M>)")
s += r"""

struct Decorated {
    label: Signal<String>,
    cover: Image,
    rounded: bool,
    scrolled: bool,
    broken: bool,
}
impl Decorated {
    const LABEL: Source<Self, String> = Source::new(
        FieldId::new(1), "label", |m| &m.label, |m| &mut m.label);
}
impl View for Decorated {
    fn sources() -> Sources<Self> { Sources::new().direct(Self::LABEL) }
    fn view(&self) -> El<'_> {
        let label = text(&self.label).w(180).h(24).name("changing");
        let label = if self.scrolled {
            div().child(label).scroll(Axis::X).w(120).h(24).name("scroll")
        } else { label };
        column((label, text("Count: 0123456789").w(180).h(24),
            image(&self.cover).size(12),
            div().size(1).rounded(if self.broken { f32::NAN } else { 0. }),
        )).w(192).h(90).rounded(if self.rounded { 8. } else { 0. })
            .clipped(self.rounded).transform(Affine::translation(3., 2.))
    }
}
fn decorated(value: &str, rounded: bool, scrolled: bool) -> Win<Decorated> {
    Win::recording(Decorated {
        label: Signal::new(value.into()), rounded, scrolled, broken: false,
        cover: Image::rgba8(1, 1, ImageProfile::Srgb, AlphaMode::Straight,
            vec![20, 90, 180, 127].into_boxed_slice()).unwrap(),
    }, WindowOptions { size: [210, 110], ..Default::default() }).unwrap()
}
#[test]
fn image_clip_and_scroller_preserve_older_candidate_after_newer_failure() {
    for rounded in [false, true] {
        for scrolled in [false, true] {
            let mut win = decorated("Count: 10", rounded, scrolled);
            ack(&mut win);
            let before = text_state(&win);
            win.set(Decorated::LABEL, "Count: 11".into()).unwrap();
            let eligible = win.with_scene(|_, token| token).unwrap();
            let candidate_pixels = pixels(&mut win);
            assert_eq!(text_state(&win), before);
            assert!(win.update(|m| { *m.label = "Count: 12".into(); m.broken = true; }).is_err());
            assert_eq!(text_state(&win), before);
            assert_eq!(pixels(&mut win), candidate_pixels);
            win.presented(eligible).unwrap();
            let mut full = decorated("Count: 11", rounded, scrolled);
            assert_eq!(pixels(&mut win), pixels(&mut full));
            ack(&mut full);
            assert_eq!(text_state(&win), text_state(&full));
            assert_eq!(win.with_scene(|scene, _| scene.images().count()).unwrap(), 1);
        }
    }
}
"""
p.write_text(s)
