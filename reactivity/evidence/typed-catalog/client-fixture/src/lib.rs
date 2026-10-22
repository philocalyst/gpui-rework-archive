use gpui::{Affine, Align, Color, El, FieldId, Flow, Justify, Signal, Source, Sources, Target, View, Win, row};
use gpui::property::{self as p, Contribution::Set};

pub struct LibraryPage {
    pub fill: Signal<Color>,
    pub radius: Signal<f32>,
    pub gap: Signal<f32>,
    pub saved: u32,
    pub filtered: u32,
}
impl Default for LibraryPage {
    fn default() -> Self {
        Self { fill: Signal::new(gpui::rgb(0x204060)), radius: Signal::new(4.),
            gap: Signal::new(3.), saved: 0, filtered: 0 }
    }
}
impl LibraryPage {
    pub const FILL: Source<Self, Color> = Source::new(FieldId::new(1), "fill", |m| &m.fill, |m| &mut m.fill);
    pub const RADIUS: Source<Self, f32> = Source::new(FieldId::new(2), "radius", |m| &m.radius, |m| &mut m.radius);
    pub const GAP: Source<Self, f32> = Source::new(FieldId::new(3), "gap", |m| &m.gap, |m| &mut m.gap);
    fn save(&mut self) { self.saved += 1; }
    fn filter(&mut self) { self.filtered += 10; }
}
impl View for LibraryPage {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::FILL).direct(Self::RADIUS).direct(Self::GAP)
    }
    fn view(&self) -> El<'_> {
        row((
            action_button::primary("Save", action_button::Appearance {
                fill: &self.fill, ink: Color::WHITE, radius: &self.radius,
            }, Self::save),
            filter_chip::choice("Open", filter_chip::Appearance {
                fill: gpui::rgb(0x507030), ink: Color::BLACK, gap: &self.gap,
            }, Self::filter),
        )).gap(8)
    }
}
pub struct OtherPage(pub u32);
impl View for OtherPage {
    fn view(&self) -> El<'_> {
        action_button::primary("Other", action_button::Appearance {
            fill: Color::BLACK, ink: Color::WHITE, radius: 2.,
        }, |m: &mut Self| m.0 += 2)
    }
}
/// Same ordinary typed workload in one and two external model instantiations.
/// Each accepted write is observable through its commit/source epoch.
#[inline(never)]
pub fn exercise<M: View + 'static>(win: &mut Win<M>, target: Target, n: f32) -> u64 {
    win.set_property(target, p::WIDTH, Set(Some(n + 40.))).unwrap();
    win.set_property(target, p::HEIGHT, Set(Some(n + 30.))).unwrap();
    win.set_property(target, p::GAP, Set(n)).unwrap();
    win.set_property(target, p::PADDING, Set(n)).unwrap();
    win.set_property(target, p::FONT_SIZE, Set(n + 16.)).unwrap();
    win.set_property(target, p::FOREGROUND, Set(Color::WHITE)).unwrap();
    win.set_property(target, p::BACKGROUND, Set(gpui::rgb(0x123456))).unwrap();
    win.set_property(target, p::FLOW, Set(Flow::Row)).unwrap();
    win.set_property(target, p::TRANSFORM, Set(Affine::translation(n, n))).unwrap();
    win.set_property(target, p::ALIGN, Set(Align::Center)).unwrap();
    win.set_property(target, p::JUSTIFY, Set(Justify::Center)).unwrap();
    win.set_property(target, p::WRAP, Set(true)).unwrap();
    win.set_property(target, p::CORNER_RADIUS, Set(n)).unwrap().source_epoch
}

