use gpui::{prelude::*, *};

const LIST: ListId = ListId::new(73);
struct Page {
    label: Signal<String>,
    offset: Signal<f64>,
    after: bool,
    clipped: bool,
}
impl Page {
    const LABEL: Source<Self, String> =
        Source::new(FieldId::new(1), "label", |m| &m.label, |m| &mut m.label);
    const OFFSET: Source<Self, f64> =
        Source::new(FieldId::new(2), "offset", |m| &m.offset, |m| &mut m.offset);
}
impl ItemSource for Page {
    fn len(&self) -> usize {
        100_000
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64 + 1)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        usize::try_from(key.get().checked_sub(1)?)
            .ok()
            .filter(|i| *i < self.len())
    }
    fn row(&self, index: usize) -> El<'_> {
        text(format!("row {index:06}")).w(180).h(24)
    }
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::LABEL).direct(Self::OFFSET)
    }
    fn view(&self) -> El<'_> {
        let label = text(&self.label).w(180).h(24).name("changing");
        let list = uniform_list(LIST, self, 24)
            .overscan(2)
            .scroll_offset(&self.offset)
            .w(180)
            .h(72);
        // Equal-length adjacent text makes wrong-P-row selection observable:
        // the Canvas run can be valid even when semantic identity is wrong.
        let neighbor = text("Count: 20").w(180).h(24);
        let items = if self.after {
            column((list, label, neighbor))
        } else {
            column((label, neighbor, list))
        };
        items
            .child(text("Count: 0123456789").w(180).h(24))
            .w(192)
            .h(144)
            .clipped(self.clipped)
            .transform(Affine::translation(3., 2.))
    }
}
fn window(label: &str, after: bool, clipped: bool) -> Win<Page> {
    Win::recording(
        Page {
            label: Signal::new(label.into()),
            offset: Signal::new(48.),
            after,
            clipped,
        },
        WindowOptions {
            size: [210, 160],
            ..Default::default()
        },
    )
    .unwrap()
}
fn ack<M: View + 'static>(win: &mut Win<M>) {
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
}
fn pixels<M: View + 'static>(win: &mut Win<M>) -> Vec<u8> {
    win.with_pixels(|p, _, _| p.to_vec()).unwrap()
}
type TextSnapshot = (String, Rect, Vec<(usize, usize, Rect)>);
fn text_state<M: View + 'static>(win: &Win<M>) -> Vec<TextSnapshot> {
    let mut result = Vec::new();
    win.visit(|part| {
        if let Some(value) = part.text() {
            let geometry = part.text_geometry().unwrap();
            result.push((
                value.into(),
                part.bounds(),
                geometry
                    .layout()
                    .graphemes()
                    .map(|g| {
                        let range = g.text_range();
                        (
                            range.start.byte(),
                            range.end.byte(),
                            geometry.bounds(g.bounds()).unwrap(),
                        )
                    })
                    .collect(),
            ));
        }
    })
    .unwrap();
    result
}

#[test]
fn exact_text_keeps_list_identity_and_old_geometry_until_ack() {
    for after in [false, true] {
        for clipped in [false, true] {
            let mut win = window("Count: 10", after, clipped);
            ack(&mut win);
            let target = win.query().name("changing").one().unwrap();
            let list = win.list(LIST).unwrap();
            let item = win.list_item(list, ItemKey::new(3)).unwrap();
            for value in ["Count: 11", "Count: 12", "Count: 10"] {
                let before = text_state(&win);
                win.set(Page::LABEL, value.into()).unwrap();
                assert_eq!(text_state(&win), before, "P changed before ACK");
                let mut retained = false;
                win.visit(|part| retained |= part.target() == item).unwrap();
                assert!(retained, "old P lost its list item before ACK");
                let mut full = window(value, after, clipped);
                assert_eq!(pixels(&mut win), pixels(&mut full));
                ack(&mut win);
                ack(&mut full);
                assert_eq!(text_state(&win), text_state(&full));
                assert_eq!(win.query().name("changing").one().unwrap(), target);
                assert_eq!(win.list_item(list, ItemKey::new(3)).unwrap(), item);
            }
        }
    }
}

#[test]
fn coalesced_new_glyphs_resize_and_list_retirement_keep_complete_outputs() {
    let mut win = window("Count: 10", true, false);
    ack(&mut win);
    let old = text_state(&win);
    for value in ["Count: 11", "Count: 12", "new Ω text with more glyphs"] {
        win.set(Page::LABEL, value.into()).unwrap();
        assert_eq!(text_state(&win), old);
        let mut full = window(value, true, false);
        assert_eq!(pixels(&mut win), pixels(&mut full));
    }
    ack(&mut win);
    let list = win.list(LIST).unwrap();
    let retired = win.list_item(list, ItemKey::new(3)).unwrap();
    win.set(Page::OFFSET, 4800.).unwrap();
    ack(&mut win);
    assert!(win.bounds(retired).is_err());
    win.resize([220, 170]).unwrap();
    ack(&mut win);
    win.set(Page::LABEL, "Count: 13".into()).unwrap();
    let mut full = window("Count: 13", true, false);
    full.set(Page::OFFSET, 4800.).unwrap();
    full.resize([220, 170]).unwrap();
    assert_eq!(pixels(&mut win), pixels(&mut full));
    ack(&mut win);
    ack(&mut full);
    assert_eq!(text_state(&win), text_state(&full));
}

struct Decorated {
    label: Signal<String>,
    cover: Image,
    rounded: bool,
    scrolled: bool,
    broken: bool,
}
impl Decorated {
    const LABEL: Source<Self, String> =
        Source::new(FieldId::new(1), "label", |m| &m.label, |m| &mut m.label);
}
impl View for Decorated {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::LABEL)
    }
    fn view(&self) -> El<'_> {
        let label = text(&self.label).w(180).h(24).name("changing");
        let label = if self.scrolled {
            div()
                .child(label)
                .scroll(Axis::X)
                .w(120)
                .h(24)
                .name("scroll")
        } else {
            label
        };
        column((
            label,
            text("Count: 0123456789").w(180).h(24),
            image(&self.cover).size(12),
            div()
                .size(1)
                .rounded(if self.broken { f32::NAN } else { 0. }),
        ))
        .w(192)
        .h(90)
        .rounded(if self.rounded { 8. } else { 0. })
        .clipped(self.rounded)
        .transform(Affine::translation(3., 2.))
    }
}
fn decorated(value: &str, rounded: bool, scrolled: bool) -> Win<Decorated> {
    Win::recording(
        Decorated {
            label: Signal::new(value.into()),
            rounded,
            scrolled,
            broken: false,
            cover: Image::rgba8(
                2,
                2,
                ImageProfile::Srgb,
                AlphaMode::Straight,
                vec![
                    20, 90, 180, 127, 200, 20, 10, 255, 30, 200, 40, 255, 50, 60, 70, 80,
                ]
                .into_boxed_slice(),
            )
            .unwrap(),
        },
        WindowOptions {
            size: [210, 110],
            ..Default::default()
        },
    )
    .unwrap()
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
            assert!(
                win.update(|m| {
                    *m.label = "Count: 12".into();
                    m.broken = true;
                })
                .is_err()
            );
            assert_eq!(text_state(&win), before);
            assert_eq!(pixels(&mut win), candidate_pixels);
            win.presented(eligible).unwrap();
            let mut full = decorated("Count: 11", rounded, scrolled);
            assert_eq!(pixels(&mut win), pixels(&mut full));
            ack(&mut full);
            assert_eq!(text_state(&win), text_state(&full));
            assert_eq!(
                win.with_scene(|scene, _| scene.images().count()).unwrap(),
                1,
                "rounded={rounded} scrolled={scrolled}"
            );
        }
    }
}

struct NestedClips {
    label: Signal<String>,
    map: Affine,
    rounded: bool,
    scrolled: bool,
}
impl NestedClips {
    const LABEL: Source<Self, String> =
        Source::new(FieldId::new(1), "label", |m| &m.label, |m| &mut m.label);
}
impl View for NestedClips {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::LABEL)
    }
    fn view(&self) -> El<'_> {
        let content = column((
            text(&self.label).w(180).h(24).name("changing"),
            text("Count: 0123456789").w(180).h(24),
        ));
        let inner = if self.scrolled {
            div().child(content).scroll(Axis::X).name("scroll")
        } else {
            content
        };
        div()
            .child(
                inner
                    .w(100)
                    .h(60)
                    .clipped(true)
                    .rounded(if self.rounded { 7. } else { 0. })
                    .transform(self.map),
            )
            .w(165)
            .h(95)
            .clipped(true)
            .transform(Affine::translation(5.125, 3.375))
    }
}
fn nested(value: &str, map: Affine, rounded: bool, scrolled: bool) -> Win<NestedClips> {
    let mut win = Win::recording(
        NestedClips {
            label: Signal::new(value.into()),
            map,
            rounded,
            scrolled,
        },
        WindowOptions {
            size: [180, 120],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    if scrolled {
        let target = win.query().name("scroll").one().unwrap();
        win.scroll_to(target, ScrollOffset { x: 12., y: 0. })
            .unwrap();
        ack(&mut win);
    }
    win
}
#[test]
fn nested_sample_clips_and_unsupported_shapes_preserve_exact_publication() {
    let maps = [
        Affine::translation(3.125, 2.375),
        Affine {
            a: 0.75,
            d: 1.25,
            tx: 3.375,
            ty: 2.125,
            ..Affine::IDENTITY
        },
        Affine {
            a: -1.,
            tx: 150.125,
            ty: 2.375,
            ..Affine::IDENTITY
        },
        Affine {
            c: 0.125,
            tx: 3.125,
            ty: 2.375,
            ..Affine::IDENTITY
        },
    ];
    for map in maps {
        for rounded in [false, true] {
            for scrolled in [false, true] {
                // Ordinary scrolling deliberately rejects sheared ancestors.
                if scrolled && map.c != 0. {
                    continue;
                }
                let mut win = nested("Count: 10", map, rounded, scrolled);
                let target = win.query().name("changing").one().unwrap();
                for value in ["Count: 11", "Count: 12", "Count: 10"] {
                    let before = text_state(&win);
                    win.set(NestedClips::LABEL, value.into()).unwrap();
                    assert_eq!(text_state(&win), before);
                    let mut full = nested(value, map, rounded, scrolled);
                    let actual = pixels(&mut win);
                    assert!(
                        actual
                            .as_chunks::<4>()
                            .0
                            .iter()
                            .any(|p| *p != [255, 255, 255, 255])
                    );
                    assert_eq!(actual, pixels(&mut full));
                    ack(&mut win);
                    ack(&mut full);
                    assert_eq!(text_state(&win), text_state(&full));
                    assert_eq!(win.query().name("changing").one().unwrap(), target);
                }
            }
        }
    }
}

#[test]
fn owner_text_with_unchanged_or_changed_list_keeps_complete_publication() {
    for after in [false, true] {
        for clipped in [false, true] {
            let mut win = window("Count: 10", after, clipped);
            ack(&mut win);
            for (value, offset) in [
                ("Count: 11", 48.),
                ("Count: 12", 4800.),
                ("Count: 10", 4800.),
            ] {
                let before = text_state(&win);
                win.update(|m| {
                    *m.label = value.into();
                    *m.offset = offset;
                })
                .unwrap();
                assert_eq!(text_state(&win), before);
                let mut full = window(value, after, clipped);
                full.set(Page::OFFSET, offset).unwrap();
                assert_eq!(pixels(&mut win), pixels(&mut full));
                ack(&mut win);
                ack(&mut full);
                assert_eq!(text_state(&win), text_state(&full));
            }
        }
    }
}

struct OwnerMixed {
    label: String,
    variant: u8,
    cover: Image,
}
impl OwnerMixed {
    fn cover(variant: u8) -> Image {
        let color = if variant == 6 {
            [20, 220, 30, 127]
        } else {
            [220, 20, 30, 127]
        };
        Image::rgba8(
            1,
            1,
            ImageProfile::Srgb,
            AlphaMode::Straight,
            color.to_vec().into_boxed_slice(),
        )
        .unwrap()
    }
    fn set(&mut self, value: &str, variant: u8) {
        self.label = value.into();
        self.variant = variant;
        if variant == 6 {
            self.cover = Self::cover(variant);
        }
    }
}
impl View for OwnerMixed {
    fn view(&self) -> El<'_> {
        let button = button("").w(40).h(12).bg(rgb(0x556677));
        let button = if self.variant == 4 {
            button
        } else {
            button.on_click(|_: &mut Self| {})
        };
        let body = column((
            text(self.label.as_str()).w(140).h(24).name("changing"),
            text("Count: 0123456789").w(140).h(24),
            image(&self.cover).size(12),
            button,
        ));
        let body = if self.variant == 7 {
            body.child(div().size(3).bg(rgb(0x123456)))
        } else {
            body
        };
        body.w(150)
            .h(90)
            .name(if self.variant == 1 {
                "new caption"
            } else {
                "old caption"
            })
            .bg(if self.variant == 2 {
                rgb(0xaaccdd)
            } else {
                rgb(0xddeeff)
            })
            .rounded(if self.variant == 8 {
                f32::NAN
            } else if self.variant == 3 {
                9.
            } else {
                0.
            })
            .clipped(true)
            .transform(Affine::translation(
                if self.variant == 5 { 7.125 } else { 3.125 },
                2.375,
            ))
    }
}
fn mixed(value: &str, variant: u8) -> Win<OwnerMixed> {
    Win::recording(
        OwnerMixed {
            label: value.into(),
            variant,
            cover: OwnerMixed::cover(variant),
        },
        WindowOptions {
            size: [170, 110],
            ..Default::default()
        },
    )
    .unwrap()
}
fn semantic_state<M: View + 'static>(win: &Win<M>) -> Vec<(Role, Option<String>, Actions, Rect)> {
    let mut result = Vec::new();
    win.visit(|part| {
        result.push((
            part.role(),
            part.name().map(str::to_owned),
            part.actions(),
            part.bounds(),
        ))
    })
    .unwrap();
    result
}
#[test]
fn owner_text_plus_other_changes_does_not_hide_non_text_publication() {
    for variant in 0..8 {
        let mut win = mixed("Count: 10", 0);
        ack(&mut win);
        let before = (text_state(&win), semantic_state(&win));
        win.update(|m| m.set("Count: 11", variant)).unwrap();
        assert_eq!((text_state(&win), semantic_state(&win)), before);
        let candidate = win.with_scene(|_, token| token).unwrap();
        let candidate_pixels = pixels(&mut win);
        let mut full = mixed("Count: 11", variant);
        assert_eq!(candidate_pixels, pixels(&mut full), "variant={variant}");
        // A newer rejected owner description must preserve both the older C
        // and the exact P that remains authoritative before its ACK.
        assert!(win.update(|m| m.set("Count: 12", 8)).is_err());
        assert_eq!((text_state(&win), semantic_state(&win)), before);
        assert_eq!(pixels(&mut win), candidate_pixels);
        win.presented(candidate).unwrap();
        ack(&mut full);
        assert_eq!(text_state(&win), text_state(&full));
        assert_eq!(
            semantic_state(&win),
            semantic_state(&full),
            "variant={variant}"
        );
    }
}
