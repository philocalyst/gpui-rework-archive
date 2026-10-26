//! Ordinary components, perceptual authoring colors and transformed composition.
use gpui::prelude::*;

struct Palette([Color; 6]);
impl Palette {
    fn new(chroma: f32) -> Self {
        Self(
            [25., 85., 145., 205., 265., 325.]
                .map(|hue| oklch(0.76, chroma, hue).expect("fixed palette is finite")),
        )
    }
}
impl View for Palette {
    fn view(&self) -> El<'_> {
        row(self
            .0
            .iter()
            .copied()
            .map(|color| div().w(72).h(56).bg(color)))
        .gap(8)
    }
}

pub struct Graphics {
    angle: Signal<f32>,
    palette: Palette,
}
impl Default for Graphics {
    fn default() -> Self {
        Self {
            angle: Signal::new(0.),
            palette: Palette::new(0.14),
        }
    }
}
impl Graphics {
    const ANGLE: Source<Self, f32> =
        Source::new(FieldId::new(1), "angle", |m| &m.angle, |m| &mut m.angle);
    fn toggle_chroma(&mut self) {
        self.palette = Palette::new(if self.palette.0[0].channels()[1] > 0.05 {
            0.04
        } else {
            0.14
        });
    }
}
impl View for Graphics {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::ANGLE)
    }
    fn view(&self) -> El<'_> {
        let transform = Affine::translation(90., 45.)
            .compose(Affine::rotation(*self.angle))
            .compose(Affine::translation(-90., -45.));
        column((
            text("Color and geometry").font_size(28),
            row((
                button("Rotate")
                    .p(10)
                    .bg(rgb(0xdbeafe))
                    .on_click(Self::ANGLE.update(|value| {
                        *value = (*value + 0.15).rem_euclid(std::f32::consts::TAU)
                    })),
                button("Reset")
                    .p(10)
                    .bg(rgb(0xe2e8f0))
                    .on_click(Self::ANGLE.update(|value| *value = 0.)),
                button("Toggle chroma")
                    .p(10)
                    .bg(rgb(0xfef3c7))
                    .on_click(Self::toggle_chroma),
            ))
            .gap(8),
            text("OKLCH authoring"),
            &self.palette,
            text("Linear composition"),
            row((
                column((text("Transformed drawing"), text("Borrowed component")))
                    .w(180)
                    .h(90)
                    .p(12)
                    .gap(8)
                    .bg(Color::oklch(0.72, 0.17, 250., 0.7).unwrap())
                    .transform(transform),
                div()
                    .w(110)
                    .h(90)
                    .bg(Color::linear_srgb(2., 0.25, 0.02, 0.55).unwrap())
                    .transform(Affine::translation(-28., 14.)),
            ))
            .gap(12),
        ))
        .p(24)
        .gap(18)
    }
}
