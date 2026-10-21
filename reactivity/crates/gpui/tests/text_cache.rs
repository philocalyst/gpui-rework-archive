//! Cache lifetime through public source, action, resize and presentation paths.
use gpui::{
    Error, WindowOptions,
    prelude::*,
    property::{self, Contribution},
};

struct Page {
    words: Signal<String>,
    extra: bool,
    font: f32,
}
impl Page {
    const WORDS: Source<Self, String> =
        Source::new(FieldId::new(1), "words", |m| &m.words, |m| &mut m.words);
    fn toggle(&mut self) {
        self.extra = !self.extra;
    }
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::WORDS)
    }
    fn view(&self) -> El<'_> {
        column((
            column(self.extra.then(|| text("inserted").w(80))),
            text(&self.words).w(48).font_size(self.font),
            text(&self.words).w(120).font_size(self.font),
            button("Toggle").on_click(Self::toggle),
        ))
    }
}
fn page(words: &str, extra: bool, font: f32) -> Page {
    Page {
        words: Signal::new(words.into()),
        extra,
        font,
    }
}
fn pixels<M: View + 'static>(win: &mut Win<M>) -> Vec<u8> {
    win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap()
}
// Independent fixed descriptions carry no source binding or cache history.
struct Expected {
    words: &'static str,
    extra: bool,
    font: f32,
}
impl View for Expected {
    fn view(&self) -> El<'_> {
        column((
            column(self.extra.then(|| text("inserted").w(80))),
            text(self.words).w(48).font_size(self.font),
            text(self.words).w(120).font_size(self.font),
            button("Toggle").on_click(|_: &mut Self| {}),
        ))
    }
}
fn compare(win: &mut Win<Page>, words: &'static str, extra: bool, font: f32, size: [u32; 2]) {
    let mut expected = Win::with_size(Expected { words, extra, font }, size[0], size[1]).unwrap();
    assert_eq!(pixels(win), pixels(&mut expected));
    assert!(win.with_scene(|scene, _| scene.draws().len() > 0).unwrap());
}

#[test]
fn shared_text_at_distinct_widths_survives_actions_remounts_and_resize() {
    let mut win = Win::with_size(page("alpha beta gamma", false, 16.0), 180, 200).unwrap();
    let toggle = win.button("Toggle");
    win.reset_counters().unwrap();
    win.set(Page::WORDS, "longer words wrap differently".into())
        .unwrap();
    assert_eq!(win.counters().source_reads, 1);
    assert_eq!(win.counters().text_promotions, 1);
    assert_eq!(win.counters().destination_compares, 2);
    assert_eq!(win.counters().owner_reruns, 0);
    compare(
        &mut win,
        "longer words wrap differently",
        false,
        16.0,
        [180, 200],
    );
    win.click(toggle).unwrap();
    assert_eq!(win.button("Toggle"), toggle);
    compare(
        &mut win,
        "longer words wrap differently",
        true,
        16.0,
        [180, 200],
    );
    win.resize([144, 240]).unwrap();
    compare(
        &mut win,
        "longer words wrap differently",
        true,
        16.0,
        [144, 240],
    );
    win.click(toggle).unwrap();
    compare(
        &mut win,
        "longer words wrap differently",
        false,
        16.0,
        [144, 240],
    );
    win.reset_counters().unwrap();
    win.set(Page::WORDS, "longer words wrap differently".into())
        .unwrap();
    for _ in 0..100 {
        win.settle().unwrap();
    }
    assert_eq!(win.counters().paint_passes, 0);
    assert_eq!(win.counters().measure_calls, 0);
}

#[test]
fn font_override_then_inherit_matches_fresh_shaping() {
    let mut win = Win::with_size(page("alpha beta gamma", false, 16.0), 180, 240).unwrap();
    let text = win.find_text("alpha beta gamma").unwrap();
    win.set_property(text, property::FONT_SIZE, Contribution::Set(22.0))
        .unwrap();
    let override_pixels = pixels(&mut win);
    win.update(|m| m.font = 18.0).unwrap();
    assert_eq!(win.property(text, property::FONT_SIZE).unwrap(), 22.0);
    assert_ne!(pixels(&mut win), override_pixels); // second text follows the declaration
    win.set_property(text, property::FONT_SIZE, Contribution::Inherit)
        .unwrap();
    compare(&mut win, "alpha beta gamma", false, 18.0, [180, 240]);
}

#[test]
fn failed_shaping_retains_old_pixels_and_recovers_without_owner_description() {
    let options = WindowOptions {
        size: [180, 200],
        ..Default::default()
    };
    let mut win = Win::recording(page("alpha beta gamma", false, 16.0), options).unwrap();
    let old = win.with_scene(|_, token| token).unwrap();
    win.presented(old).unwrap();
    let before = pixels(&mut win);
    win.reset_counters().unwrap();
    assert!(win.set(Page::WORDS, "漢".into()).is_err());
    assert_eq!(win.with_model(|m| m.words.to_string()).unwrap(), "漢");
    assert_eq!(win.with_scene(|_, token| token).unwrap(), old);
    assert_eq!(pixels(&mut win), before);
    assert_eq!(
        win.hit_target(Point { x: 1.0, y: 1.0 }),
        Err(Error::PresentationStale)
    );
    win.set(Page::WORDS, "repaired".into()).unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    compare(&mut win, "repaired", false, 16.0, [180, 200]);
    assert_eq!(win.counters().owner_reruns, 0);
}
