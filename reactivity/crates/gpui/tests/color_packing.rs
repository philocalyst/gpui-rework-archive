use gpui::{
    Color, ColorSpace, El, FieldId, Signal, Source, Sources, View, Win, div,
    property::{BACKGROUND, Contribution},
};

struct Swatch {
    color: Signal<Color>,
}
impl Swatch {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
}
impl View for Swatch {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        div().w(8).h(8).bg(*self.color)
    }
}
fn bits(color: Color) -> [u32; 4] {
    color.channels().map(f32::to_bits)
}
fn set_linear(win: &mut Win<Swatch>, channels: [f32; 4]) -> Result<(), gpui_canvas::Error> {
    let color = Color::linear_srgb(channels[0], channels[1], channels[2], channels[3])?;
    win.set(Swatch::COLOR, color).unwrap();
    Ok(())
}
#[test]
fn source_and_typed_inspector_keep_tag_bits_and_rejected_edits_atomic() {
    let mut win = Win::with_size(
        Swatch {
            color: Signal::new(Color::BLACK),
        },
        16,
        16,
    )
    .unwrap();
    let site = win.inspect().unwrap().nodes[0].target.unwrap();
    let colors = [
        Color::srgb(-0., 0.2, 1.5, -0.).unwrap(),
        Color::display_p3(-0.2, 1.4, f32::from_bits(1), 0.6).unwrap(),
        Color::linear_display_p3(4., -2., 0.5, 0.8).unwrap(),
        Color::linear_srgb(-1e19, f32::from_bits(1), -0., 1.).unwrap(),
        Color::oklch(-0., -0., -1., -0.).unwrap(),
    ];
    for color in colors {
        win.set(Swatch::COLOR, color).unwrap();
        assert_eq!(bits(*win.root().unwrap().color), bits(color));
        let value = win.property(site, BACKGROUND).unwrap().solid().unwrap();
        assert_eq!(value.space(), color.space());
        assert_eq!(bits(value), bits(color));
        win.set_property(
            site,
            BACKGROUND,
            Contribution::Set(gpui::Brush::Solid(Color::WHITE)),
        )
        .unwrap();
        win.set_property(site, BACKGROUND, Contribution::Inherit)
            .unwrap();
        let restored = win.property(site, BACKGROUND).unwrap().solid().unwrap();
        assert_eq!(bits(restored), bits(color));
        assert_eq!(restored.space(), color.space());
    }
    let epoch = win.snapshot().unwrap().source_epoch;
    let revision = win.root().unwrap().color.revision();
    let old = bits(*win.root().unwrap().color);
    let digest = win.scene_digest().unwrap();
    for channels in [
        [f32::MAX, 0., 0., 1.],
        [0., f32::NAN, 0., 1.],
        [0., 0., 0., -0.1],
    ] {
        assert!(set_linear(&mut win, channels).is_err());
        assert_eq!(bits(*win.root().unwrap().color), old);
        assert_eq!(win.root().unwrap().color.revision(), revision);
        assert_eq!(win.snapshot().unwrap().source_epoch, epoch);
        assert_eq!(win.scene_digest().unwrap(), digest);
    }
    assert_eq!(
        win.property(site, BACKGROUND)
            .unwrap()
            .solid()
            .unwrap()
            .space(),
        ColorSpace::Oklch
    );
}
