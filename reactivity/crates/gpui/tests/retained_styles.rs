use gpui::{
    Color, Error, PresentationToken, Target, WindowOptions,
    prelude::*,
    property::{BACKGROUND, Contribution, TRANSFORM},
};

struct Panels {
    count: usize,
    unique: bool,
    broken: bool,
}
impl View for Panels {
    fn view(&self) -> El<'_> {
        column((0..self.count).map(|index| {
            div()
                .size(2)
                .bg(rgb(if self.unique { index as u32 } else { 0x123456 }))
                .transform(if self.broken && index == 0 {
                    Affine::scale(0.0, 1.0)
                } else {
                    Affine::IDENTITY
                })
        }))
    }
}
fn token<M: View + 'static>(window: &Win<M>) -> PresentationToken {
    window.with_scene(|_, token| token).unwrap()
}
fn target(window: &Win<Panels>, index: usize) -> Target {
    window.inspect().unwrap().nodes[index + 1].target.unwrap()
}

#[test]
fn typed_edits_and_style_mode_changes_keep_pending_and_displayed_geometry_independent() {
    let mut window = Win::recording(
        Panels {
            count: 128,
            unique: false,
            broken: false,
        },
        WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    window.presented(token(&window)).unwrap();
    let first = target(&window, 0);
    let peer = target(&window, 1);
    let displayed = window.snapshot().unwrap();
    window
        .set_property(first, BACKGROUND, Contribution::Set(Color::WHITE))
        .unwrap();
    window
        .set_property(
            first,
            TRANSFORM,
            Contribution::Set(Affine::translation(8.0, 0.0)),
        )
        .unwrap();
    let candidate = token(&window);
    let candidate_digest = window.scene_digest().unwrap();
    assert_eq!(window.property(peer, BACKGROUND).unwrap(), rgb(0x123456));
    assert_eq!(window.snapshot().unwrap().nodes, displayed.nodes);
    // Inherit exposes the authored zero-scale transform, so this description
    // fails while the preceding complete candidate and old P remain intact.
    window.update(|model| model.broken = true).unwrap();
    assert!(matches!(
        window.set_property(first, TRANSFORM, Contribution::Inherit),
        Err(Error::Canvas(_))
    ));
    assert_eq!(token(&window), candidate);
    assert_eq!(window.scene_digest().unwrap(), candidate_digest);
    assert_eq!(window.snapshot().unwrap().nodes, displayed.nodes);
    window.presented(candidate).unwrap();
    assert_eq!(
        window.snapshot().unwrap().nodes[1].transform.unwrap()[4],
        8.0
    );
    window
        .update(|model| {
            model.broken = false;
            model.unique = true;
        })
        .unwrap();
    window.resize_scaled([80, 64], 1.25).unwrap();
    window.presented(token(&window)).unwrap();
    assert_eq!(window.property(first, BACKGROUND).unwrap(), Color::WHITE);
    assert_eq!(window.property(peer, BACKGROUND).unwrap(), rgb(1));
    window
        .set_property(first, BACKGROUND, Contribution::Inherit)
        .unwrap();
    assert_eq!(window.property(first, BACKGROUND).unwrap(), rgb(0));
    window.update(|model| model.count = 2).unwrap();
    assert_eq!(window.property(first, BACKGROUND), Err(Error::StaleTarget));
}

struct Swatches {
    colors: [Color; 8],
}
impl View for Swatches {
    fn view(&self) -> El<'_> {
        column((0..128).map(|index| div().size(1).bg(self.colors[index % 8])))
    }
}

#[test]
fn repeated_authored_styles_keep_profile_and_signed_channel_bits() {
    let colors = [
        Color::BLACK,
        Color::srgb(-0.0, 0.0, 0.0, 1.0).unwrap(),
        Color::linear_srgb(-0.0, 0.0, 0.0, 1.0).unwrap(),
        Color::linear_srgb(0.0, 0.0, 0.0, 1.0).unwrap(),
        Color::display_p3(0.0, 0.0, 0.0, 1.0).unwrap(),
        Color::linear_display_p3(0.0, 0.0, 0.0, 1.0).unwrap(),
        Color::oklch(0.0, 0.0, 0.0, 1.0).unwrap(),
        Color::linear_srgb(-0.5, 2.0, 0.25, 0.5).unwrap(),
    ];
    let mut window = Win::with_size(Swatches { colors }, 64, 64).unwrap();
    let sites = window
        .inspect()
        .unwrap()
        .nodes
        .into_iter()
        .skip(1)
        .map(|node| node.target.unwrap())
        .collect::<Vec<_>>();
    for frame in 0..3 {
        window.update(|model| model.colors.rotate_left(1)).unwrap();
        for (index, site) in sites.iter().enumerate() {
            let expected = colors[(index + frame + 1) % colors.len()];
            let actual = window.property(*site, BACKGROUND).unwrap();
            assert_eq!(actual.space(), expected.space());
            assert_eq!(
                actual.channels().map(f32::to_bits),
                expected.channels().map(f32::to_bits)
            );
        }
    }
}
