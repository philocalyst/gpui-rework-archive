//! Matched public consumer for linked-code inspection, not a timing fixture.
use gpui::{
    Color, El, Error, FieldId, Signal, Source, Sources, Target, View, Win, WindowOptions, div,
    property::BACKGROUND,
};

struct Paint {
    bound: bool,
    color: Signal<Color>,
}
impl Paint {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
}
impl View for Paint {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        if self.bound {
            div().size(8).bg(&self.color)
        } else {
            div().size(8).bg(Color::BLACK)
        }
    }
}

#[inline(never)]
fn background(owner: &Win<Paint>, target: Target) -> Result<Color, Error> {
    owner.property(target, BACKGROUND)
}

#[inline(never)]
fn publish(owner: &mut Win<Paint>, color: Color) {
    owner.set(Paint::COLOR, color).unwrap();
}

fn main() {
    println!(
        "public_headers,Canvas={},PreparedScene={},Style={},El={},Win={}",
        size_of::<gpui_canvas::Canvas>(),
        size_of::<gpui_canvas::PreparedScene<'_>>(),
        size_of::<gpui::Style>(),
        size_of::<El<'_>>(),
        size_of::<Win<Paint>>()
    );
    for bound in [false, true] {
        let mut owner = Win::recording(
            Paint {
                bound,
                color: Signal::new(Color::BLACK),
            },
            WindowOptions {
                size: [8, 8],
                ..Default::default()
            },
        )
        .unwrap();
        let target = owner.inspect().unwrap().nodes[0].target.unwrap();
        std::hint::black_box(background(&owner, target).unwrap());
        publish(&mut owner, std::hint::black_box(Color::WHITE));
        std::hint::black_box(background(&owner, target).unwrap());
    }
}
