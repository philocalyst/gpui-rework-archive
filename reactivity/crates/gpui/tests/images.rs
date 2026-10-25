use gpui::{AlphaMode, Image, ImageProfile, ImageSampling, Role, prelude::*};

fn cover(profile: ImageProfile) -> Image {
    Image::rgba8(
        2,
        2,
        profile,
        AlphaMode::Straight,
        vec![255, 0, 0, 255, 0, 255, 0, 127, 0, 0, 255, 63, 17, 29, 49, 0].into_boxed_slice(),
    )
    .unwrap()
}
struct Gallery {
    cover: Image,
    sampling: ImageSampling,
    clicks: usize,
}
impl Gallery {
    fn clicked(&mut self) {
        self.clicks += 1;
    }
}
impl View for Gallery {
    fn view(&self) -> El<'_> {
        image(&self.cover)
            .sampling(self.sampling)
            .w(24)
            .h(16)
            .name("Cover art")
            .on_click(Self::clicked)
    }
}
#[test]
fn borrowed_image_port_matches_canvas_and_survives_resource_and_filter_changes() {
    for profile in [ImageProfile::Srgb, ImageProfile::DisplayP3] {
        let mut win = Win::with_size(
            Gallery {
                cover: cover(profile),
                sampling: ImageSampling::Linear,
                clicks: 0,
            },
            32,
            24,
        )
        .unwrap();
        let target = win.role(Role::Image).one().unwrap();
        for sampling in [ImageSampling::Linear, ImageSampling::Nearest] {
            win.update(|page| page.sampling = sampling).unwrap();
            let mut expected = gpui_canvas::Canvas::new(32, 24).unwrap();
            expected.clear(Color::WHITE);
            win.with_model(|page| {
                expected
                    .draw_image(
                        &page.cover,
                        Rect::new(0., 0., 24., 16.),
                        Affine::IDENTITY,
                        Rect::new(0., 0., 32., 24.),
                        sampling,
                    )
                    .unwrap()
            })
            .unwrap();
            win.with_pixels(|bytes, _, _| assert_eq!(bytes, expected.pixels()))
                .unwrap();
            assert_eq!(win.role(Role::Image).one().unwrap(), target);
            win.visit(|part| {
                assert_eq!(part.name(), Some("Cover art"));
                assert_eq!(part.text(), None);
                assert_eq!(part.value(), None);
            })
            .unwrap();
        }
        win.activate(target).unwrap();
        assert_eq!(win.root().unwrap().clicks, 1);
        win.update(|page| page.cover = cover(ImageProfile::Srgb))
            .unwrap();
        assert_eq!(win.role(Role::Image).one().unwrap(), target);
        assert_eq!(
            win.with_scene(|scene, _| scene.images().count()).unwrap(),
            1
        );
        // The explicit accessible name is retained once; images have no text site.
        assert_eq!(win.counters().text_promotions, 1);
    }
}

#[test]
fn one_shared_resource_is_leased_for_many_public_image_nodes() {
    struct Repeated(Image);
    impl View for Repeated {
        fn view(&self) -> El<'_> {
            column((
                image(&self.0).w(8).h(8),
                image(&self.0).w(8).h(8),
                image(&self.0).w(8).h(8),
            ))
        }
    }
    let win = Win::with_size(Repeated(cover(ImageProfile::Srgb)), 32, 32).unwrap();
    assert_eq!(
        win.with_scene(|scene, _| scene.images().count()).unwrap(),
        1
    );
    assert_eq!(
        win.with_scene(|scene, _| scene.draws().filter(|d| d.source.image().is_some()).count())
            .unwrap(),
        3
    );
}

#[test]
fn image_measurement_preserves_aspect_when_flex_constrains_only_one_axis() {
    struct Intrinsic {
        image: Image,
        axis: u8,
    }
    impl View for Intrinsic {
        fn view(&self) -> El<'_> {
            let port = image(&self.image);
            let port = match self.axis {
                1 => port.w(30),
                2 => port.h(20),
                _ => port,
            };
            column((port,)).w(80).h(80)
        }
    }
    let image = Image::rgba8(
        3,
        2,
        ImageProfile::Srgb,
        AlphaMode::Straight,
        vec![255; 3 * 2 * 4].into_boxed_slice(),
    )
    .unwrap();
    let mut win = Win::with_size(Intrinsic { image, axis: 0 }, 100, 100).unwrap();
    for (axis, expected) in [(0, (80., 80. / 1.5)), (1, (30., 20.)), (2, (80., 20.))] {
        win.update(|page| page.axis = axis).unwrap();
        let bounds = win.bounds(win.role(Role::Image).one().unwrap()).unwrap();
        assert!(
            (bounds.width - expected.0).abs() < 0.001 && (bounds.height - expected.1).abs() < 0.001,
            "axis{axis}: {bounds:?}"
        );
    }
}
