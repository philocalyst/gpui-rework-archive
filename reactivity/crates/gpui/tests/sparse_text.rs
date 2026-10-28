use gpui::{WindowOptions, prelude::*};

struct Page {
    label: Signal<String>,
    broken: bool,
}
impl Page {
    const LABEL: Source<Self, String> =
        Source::new(FieldId::new(1), "label", |m| &m.label, |m| &mut m.label);
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::LABEL)
    }
    fn view(&self) -> El<'_> {
        column((
            text(&self.label).w(180).h(24),
            text("Count: 0123456789").w(180).h(24),
            div().size(4).bg(Color::BLACK).transform(if self.broken {
                gpui::Affine::scale(0., 1.)
            } else {
                gpui::Affine::IDENTITY
            }),
        ))
        .w(192)
        .h(80)
        .bg(Color::WHITE)
    }
}
fn win(value: &str) -> Win<Page> {
    let mut win = Win::recording(
        Page {
            label: Signal::new(value.into()),
            broken: false,
        },
        WindowOptions {
            size: [192, 80],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    win
}
fn ack(win: &mut Win<Page>) {
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
}
fn pixels(win: &mut Win<Page>) -> Vec<u8> {
    win.with_pixels(|p, _, _| p.to_vec()).unwrap()
}

#[test]
fn direct_text_pixels_match_fresh_windows_through_patch_and_fallback() {
    let mut current = win("Count: 10");
    for value in [
        "Count: 11",
        "Count: 12",
        "Count: 99",
        "Count: 100",
        "héllo",
        "",
        "Count: 43",
    ] {
        current.set(Page::LABEL, value.to_string()).unwrap();
        ack(&mut current);
        assert!(current.contains_text(value).unwrap());
        assert_eq!(pixels(&mut current), pixels(&mut win(value)), "{value}");
    }
}

#[test]
fn pending_text_and_geometry_stay_at_acknowledged_epoch_then_survive_newer_failure() {
    let mut current = win("Count: 10");
    current.set(Page::LABEL, "Count: 11".into()).unwrap();
    let eligible = current.with_scene(|_, t| t).unwrap();
    assert!(current.contains_text("Count: 10").unwrap());
    assert!(!current.contains_text("Count: 11").unwrap());
    assert!(current.update(|m| m.broken = true).is_err());
    assert_eq!(current.with_scene(|_, t| t).unwrap(), eligible);
    current.presented(eligible).unwrap();
    assert!(current.contains_text("Count: 11").unwrap());
    assert_eq!(pixels(&mut current), pixels(&mut win("Count: 11")));
    current.update(|m| m.broken = false).unwrap();
    ack(&mut current);
    current.set(Page::LABEL, "Count: 12".into()).unwrap();
    current.set(Page::LABEL, "Count: 13".into()).unwrap();
    ack(&mut current);
    assert!(current.contains_text("Count: 13").unwrap());
    assert_eq!(pixels(&mut current), pixels(&mut win("Count: 13")));
}

#[test]
fn changed_layout_rejects_sparse_publication_and_moves_following_content() {
    struct Auto {
        label: Signal<String>,
    }
    impl Auto {
        const LABEL: Source<Self, String> =
            Source::new(FieldId::new(1), "label", |m| &m.label, |m| &mut m.label);
    }
    impl View for Auto {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::LABEL)
        }
        fn view(&self) -> El<'_> {
            row((text(&self.label), text("iiiWWW")))
                .w(240)
                .h(40)
                .bg(Color::WHITE)
        }
    }
    let mount = |value: &str| {
        let mut win = Win::recording(
            Auto {
                label: Signal::new(value.into()),
            },
            WindowOptions {
                size: [240, 40],
                ..Default::default()
            },
        )
        .unwrap();
        win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
        win
    };
    let mut current = mount("iii");
    for value in ["WWW", "iii", "WiW"] {
        current.set(Auto::LABEL, value.into()).unwrap();
        current
            .presented(current.with_scene(|_, t| t).unwrap())
            .unwrap();
        let mut fresh = mount(value);
        let actual = current.with_pixels(|p, _, _| p.to_vec()).unwrap();
        let expected = fresh.with_pixels(|p, _, _| p.to_vec()).unwrap();
        assert_eq!(actual, expected, "changed layout {value}");
    }
}
