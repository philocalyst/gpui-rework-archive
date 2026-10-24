//! Direct style sources share ordinary authoring, inspector and presentation ports.
#![allow(clippy::needless_borrows_for_generic_args)] // borrowed-input conformance
use gpui::{
    Error, SetError, WindowOptions,
    prelude::*,
    property::{
        BACKGROUND, CORNER_RADIUS, Contribution, FONT_SIZE, HEIGHT, PropertyErrorKind, TRANSFORM,
        WIDTH,
    },
};

struct Panel {
    number: Signal<f64>,
    color: Signal<Color>,
    radius: Signal<f32>,
    transform: Signal<Affine>,
    wrap: Signal<bool>,
    reverse_order: bool,
}
impl Panel {
    const NUMBER: Source<Self, f64> =
        Source::new(FieldId::new(1), "number", |m| &m.number, |m| &mut m.number);
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(2), "color", |m| &m.color, |m| &mut m.color);
    const RADIUS: Source<Self, f32> =
        Source::new(FieldId::new(3), "radius", |m| &m.radius, |m| &mut m.radius);
    const TRANSFORM: Source<Self, Affine> = Source::new(
        FieldId::new(4),
        "transform",
        |m| &m.transform,
        |m| &mut m.transform,
    );
    const WRAP: Source<Self, bool> =
        Source::new(FieldId::new(5), "wrap", |m| &m.wrap, |m| &mut m.wrap);
    fn new() -> Self {
        Self {
            number: Signal::new(24.0),
            color: Signal::new(Color::BLACK),
            radius: Signal::new(0.0),
            transform: Signal::new(Affine::IDENTITY),
            wrap: Signal::new(false),
            reverse_order: false,
        }
    }
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::NUMBER)
            .direct(Self::COLOR)
            .direct(Self::RADIUS)
            .direct(Self::TRANSFORM)
            .direct(Self::WRAP)
    }
    fn view(&self) -> El<'_> {
        let root = div()
            .name("panel")
            .w(&self.number)
            .font_size(&self.number)
            .bg(&self.color)
            .fg(&self.color)
            .rounded(&self.radius)
            .transform(&self.transform)
            .layout(Flex::row().align(&Align::Center).gap(&2).wrap(&self.wrap));
        // Installation order must not choose a text-only numeric descriptor.
        if self.reverse_order {
            column((text(&self.number), root))
        } else {
            root.child(text(&self.number))
        }
    }
}
fn root(win: &Win<Panel>) -> Target {
    win.query().name("panel").one().unwrap()
}
fn ack<M: View + 'static>(win: &mut Win<M>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}

#[test]
fn paint_geometry_and_layout_ports_use_existing_typed_properties_without_view_work() {
    let mut win = Win::with_size(Panel::new(), 120, 80).unwrap();
    let target = root(&win);
    win.reset_counters().unwrap();
    win.set(Panel::COLOR, Color::WHITE).unwrap();
    assert_eq!(
        win.property(target, BACKGROUND).unwrap().solid().unwrap(),
        Color::WHITE
    );
    assert_eq!(win.counters().source_reads, 1);
    assert_eq!(win.counters().destination_compares, 0);
    assert_eq!(win.counters().layout_runs, 0);
    assert_eq!(win.counters().owner_reruns, 0);
    win.set(Panel::RADIUS, 8.0).unwrap();
    assert_eq!(win.property(target, CORNER_RADIUS).unwrap(), 8.0);
    win.set(Panel::TRANSFORM, Affine::translation(3.0, 4.0))
        .unwrap();
    assert_eq!(win.property(target, TRANSFORM).unwrap().tx, 3.0);
    assert_eq!(win.counters().layout_runs, 0);
    win.reset_counters().unwrap();
    win.set(Panel::NUMBER, 32.0).unwrap();
    assert_eq!(
        win.property(target, WIDTH).unwrap(),
        gpui::Length::Points(32.0)
    );
    assert_eq!(win.property(target, FONT_SIZE).unwrap(), 32.0);
    assert!(win.find_text("32").is_ok());
    assert_eq!(win.counters().source_reads, 1);
    assert_eq!(win.counters().destination_compares, 3);
    assert_eq!(win.counters().owner_reruns, 0);
    assert!(win.counters().layout_runs > 0);
    win.reset_counters().unwrap();
    win.set(Panel::NUMBER, 32.0).unwrap();
    assert_eq!(win.counters().layout_runs, 0);
    assert_eq!(win.counters().presentations, 0);
}

#[test]
fn text_first_and_style_first_keep_combined_numeric_capabilities() {
    for reverse_order in [false, true] {
        let mut model = Panel::new();
        model.reverse_order = reverse_order;
        let mut win = Win::with_size(model, 120, 120).unwrap();
        let target = root(&win);
        win.set(Panel::NUMBER, 40.0).unwrap();
        assert_eq!(
            win.property(target, WIDTH).unwrap(),
            gpui::Length::Points(40.0)
        );
        assert!(win.find_text("40").is_ok());
        assert_eq!(win.counters().owner_reruns, 0);
    }
}

#[test]
fn masked_sources_advance_inspector_bases_and_inherit_reveals_without_view() {
    let mut win = Win::with_size(Panel::new(), 120, 80).unwrap();
    let target = root(&win);
    win.set_property(target, WIDTH, Contribution::Set(gpui::Length::Auto))
        .unwrap();
    win.set_property(
        target,
        BACKGROUND,
        Contribution::Set(gpui::Brush::Solid(Color::WHITE)),
    )
    .unwrap();
    win.set_property(target, CORNER_RADIUS, Contribution::Set(4.0))
        .unwrap();
    win.reset_counters().unwrap();
    win.set(Panel::NUMBER, 36.0).unwrap();
    win.set(Panel::COLOR, rgb(0x123456)).unwrap();
    win.set(Panel::RADIUS, 9.0).unwrap();
    assert_eq!(win.property(target, WIDTH).unwrap(), gpui::Length::Auto);
    assert_eq!(
        win.property(target, BACKGROUND).unwrap().solid().unwrap(),
        Color::WHITE
    );
    assert_eq!(win.property(target, CORNER_RADIUS).unwrap(), 4.0);
    win.set_property(target, WIDTH, Contribution::Inherit)
        .unwrap();
    win.set_property(target, BACKGROUND, Contribution::Inherit)
        .unwrap();
    win.set_property(target, CORNER_RADIUS, Contribution::Inherit)
        .unwrap();
    assert_eq!(
        win.property(target, WIDTH).unwrap(),
        gpui::Length::Points(36.0)
    );
    assert_eq!(
        win.property(target, BACKGROUND).unwrap().solid().unwrap(),
        rgb(0x123456)
    );
    assert_eq!(win.property(target, CORNER_RADIUS).unwrap(), 9.0);
    assert_eq!(win.counters().owner_reruns, 0);
}

#[test]
fn invalid_numeric_publication_commits_source_but_preserves_old_p_and_recovers() {
    let mut win = Win::with_size(Panel::new(), 120, 80).unwrap();
    let before = win.snapshot().unwrap();
    let digest = win.scene_digest().unwrap();
    assert!(
        matches!(win.set(Panel::NUMBER,0.0),Err(SetError::Committed{error:Error::Property(error),..}) if error.property==FONT_SIZE.id() && error.reason==PropertyErrorKind::NonPositive)
    );
    assert_eq!(*win.root().unwrap().number, 0.0);
    assert_eq!(win.snapshot().unwrap().nodes, before.nodes);
    assert_eq!(win.scene_digest().unwrap(), digest);
    win.set(Panel::NUMBER, 28.0).unwrap();
    assert!(win.find_text("28").is_ok());
    assert!(
        matches!(win.set(Panel::NUMBER,f64::MAX),Err(SetError::Committed{error:Error::Property(error),..}) if error.reason==PropertyErrorKind::OutOfRange)
    );
}

#[test]
fn pending_and_failed_geometry_keep_acknowledged_style_geometry() {
    let mut win = Win::recording(
        Panel::new(),
        WindowOptions {
            size: [120, 80],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let target = root(&win);
    let old = win.bounds(target).unwrap();
    win.set(Panel::TRANSFORM, Affine::translation(10.0, 0.0))
        .unwrap();
    let token = win.with_scene(|_, token| token).unwrap();
    assert_eq!(win.bounds(target).unwrap(), old);
    assert!(matches!(
        win.set(Panel::TRANSFORM, Affine::scale(0.0, 1.0)),
        Err(SetError::Committed {
            error: Error::Canvas(_),
            ..
        })
    ));
    assert_eq!(win.with_scene(|_, token| token).unwrap(), token);
    assert_eq!(win.bounds(target).unwrap(), old);
    win.presented(token).unwrap();
    assert!(win.bounds(target).unwrap().x > old.x);
}

#[test]
fn last_write_wins_size_fanout_and_unregistered_snapshots_do_not_keep_obsolete_edges() {
    struct Page {
        a: Signal<u32>,
        b: Signal<u32>,
        color: Signal<Color>,
    }
    impl Page {
        const A: Source<Self, u32> = Source::new(FieldId::new(1), "a", |m| &m.a, |m| &mut m.a);
        const B: Source<Self, u32> = Source::new(FieldId::new(2), "b", |m| &m.b, |m| &mut m.b);
    }
    impl View for Page {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::A).direct(Self::B)
        }
        fn view(&self) -> El<'_> {
            div().name("panel").size(&self.a).w(&self.b).bg(&self.color)
        }
    }
    let mut win = Win::with_size(
        Page {
            a: Signal::new(20),
            b: Signal::new(30),
            color: Signal::new(Color::BLACK),
        },
        80,
        80,
    )
    .unwrap();
    let target = win.query().name("panel").one().unwrap();
    win.reset_counters().unwrap();
    win.set(Page::A, 22).unwrap();
    assert_eq!(
        win.property(target, WIDTH).unwrap(),
        gpui::Length::Points(30.0)
    );
    assert_eq!(
        win.property(target, HEIGHT).unwrap(),
        gpui::Length::Points(22.0)
    );
    assert_eq!(win.counters().destination_compares, 1);
    win.update(|m| *m.color = Color::WHITE).unwrap();
    assert_eq!(
        win.property(target, BACKGROUND).unwrap().solid().unwrap(),
        Color::WHITE
    );
}

#[test]
fn literal_and_borrowed_recipes_preserve_unspecified_fields() {
    const ROW: Flex = Flex::row();
    struct Page;
    impl View for Page {
        fn view(&self) -> El<'_> {
            div()
                .gap(&7)
                .layout(&ROW)
                .child((div().size(&3), div().size(3)))
        }
    }
    let win = Win::with_size(Page, 80, 40).unwrap();
    let target = win.inspect().unwrap().nodes[0].target.unwrap();
    assert_eq!(win.property(target, gpui::property::GAP).unwrap(), 7.0);
}

#[test]
fn radius_literals_keep_deferred_geometry_errors_and_font_uses_its_schema_error() {
    struct Radius(f32);
    impl View for Radius {
        fn view(&self) -> El<'_> {
            div().size(20).rounded(&self.0)
        }
    }
    for value in [-1.0, f32::NAN, f32::INFINITY] {
        assert!(
            matches!(Win::with_size(Radius(value),40,40),Err(Error::GeometryProperty{error,..}) if error.property==CORNER_RADIUS.id())
        );
    }
    let mut win = Win::with_size(Panel::new(), 120, 80).unwrap();
    assert!(
        matches!(win.set(Panel::NUMBER,-1.0),Err(SetError::Committed{error:Error::Property(error),..}) if error.property==WIDTH.id() && error.reason==PropertyErrorKind::Negative)
    );
    struct Font(Signal<f64>);
    impl Font {
        const VALUE: Source<Self, f64> =
            Source::new(FieldId::new(1), "value", |m| &m.0, |m| &mut m.0);
    }
    impl View for Font {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::VALUE)
        }
        fn view(&self) -> El<'_> {
            text("font").font_size(&self.0)
        }
    }
    for invalid in [-1.0, -f64::MIN_POSITIVE] {
        let mut win = Win::with_size(Font(Signal::new(16.0)), 80, 40).unwrap();
        assert!(
            matches!(win.set(Font::VALUE,invalid),Err(SetError::Committed{error:Error::Property(error),..}) if error.reason==PropertyErrorKind::NonPositive)
        );
    }
}

#[test]
fn final_literal_and_final_signal_win_for_direct_and_flex_fields() {
    struct Page {
        value: Signal<u32>,
        align: Signal<Align>,
        wrap: Signal<bool>,
    }
    impl Page {
        const VALUE: Source<Self, u32> =
            Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
        const ALIGN: Source<Self, Align> =
            Source::new(FieldId::new(2), "align", |m| &m.align, |m| &mut m.align);
        const WRAP: Source<Self, bool> =
            Source::new(FieldId::new(3), "wrap", |m| &m.wrap, |m| &mut m.wrap);
    }
    impl View for Page {
        fn sources() -> Sources<Self> {
            Sources::new()
                .direct(Self::VALUE)
                .direct(Self::ALIGN)
                .direct(Self::WRAP)
        }
        fn view(&self) -> El<'_> {
            div()
                .name("panel")
                .w(&self.value)
                .w(44)
                .h(10)
                .h(&self.value)
                .layout(
                    Flex::row()
                        .gap(&self.value)
                        .gap(3)
                        .align(&self.align)
                        .align(Align::Start)
                        .wrap(&self.wrap),
                )
                .wrap(false)
        }
    }
    let mut win = Win::with_size(
        Page {
            value: Signal::new(20),
            align: Signal::new(Align::Center),
            wrap: Signal::new(true),
        },
        80,
        80,
    )
    .unwrap();
    let target = win.query().name("panel").one().unwrap();
    win.reset_counters().unwrap();
    win.set(Page::VALUE, 30).unwrap();
    assert_eq!(win.counters().destination_compares, 1);
    assert_eq!(
        win.property(target, WIDTH).unwrap(),
        gpui::Length::Points(44.0)
    );
    assert_eq!(
        win.property(target, HEIGHT).unwrap(),
        gpui::Length::Points(30.0)
    );
    assert_eq!(win.property(target, gpui::property::GAP).unwrap(), 3.0);
    win.reset_counters().unwrap();
    win.set(Page::ALIGN, Align::End).unwrap();
    win.set(Page::WRAP, true).unwrap();
    assert_eq!(win.counters().source_reads, 0);
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(
        win.property(target, gpui::property::ALIGN).unwrap(),
        Align::Start
    );
    assert!(!win.property(target, gpui::property::WRAP).unwrap());
}

#[test]
fn same_local_component_ids_install_distinct_style_sources() {
    struct Child {
        color: Signal<Color>,
        name: &'static str,
    }
    impl Child {
        const COLOR: Source<Self, Color> =
            Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
    }
    impl View for Child {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::COLOR)
        }
        fn view(&self) -> El<'_> {
            div().name(self.name).size(40).bg(&self.color).child(
                button(self.name).on_click(Self::COLOR.update(|color| *color = Color::WHITE)),
            )
        }
    }
    struct Pair {
        left: Child,
        right: Child,
    }
    impl Pair {
        const LEFT: Component<Self, Child> =
            Component::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.left);
        const RIGHT: Component<Self, Child> =
            Component::new(FieldId::new(2), "right", |m| &m.right, |m| &mut m.right);
    }
    impl View for Pair {
        fn sources() -> Sources<Self> {
            Sources::new()
                .direct_component(Self::LEFT)
                .direct_component(Self::RIGHT)
        }
        fn view(&self) -> El<'_> {
            row((Self::LEFT.view(self), Self::RIGHT.view(self)))
        }
    }
    let mut win = Win::with_size(
        Pair {
            left: Child {
                color: Signal::new(Color::BLACK),
                name: "left",
            },
            right: Child {
                color: Signal::new(Color::BLACK),
                name: "right",
            },
        },
        120,
        80,
    )
    .unwrap();
    let panels = win.inspect().unwrap();
    let left = panels.nodes[1].target.unwrap();
    let right = panels.nodes[3].target.unwrap();
    win.reset_counters().unwrap();
    win.click(win.button("right")).unwrap();
    assert_eq!(
        win.property(left, BACKGROUND).unwrap().solid().unwrap(),
        Color::BLACK
    );
    assert_eq!(
        win.property(right, BACKGROUND).unwrap().solid().unwrap(),
        Color::WHITE
    );
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().source_reads, 1);
}

#[test]
fn dynamic_list_height_is_admitted_before_realization_but_paint_does_not_describe() {
    const LIST: ListId = ListId::new(1);
    struct Rows {
        height: Signal<u32>,
        color: Signal<Color>,
    }
    impl Rows {
        const HEIGHT: Source<Self, u32> =
            Source::new(FieldId::new(1), "height", |m| &m.height, |m| &mut m.height);
        const COLOR: Source<Self, Color> =
            Source::new(FieldId::new(2), "color", |m| &m.color, |m| &mut m.color);
    }
    impl ItemSource for Rows {
        fn len(&self) -> usize {
            100
        }
        fn key(&self, index: usize) -> ItemKey {
            ItemKey::new(index as u64)
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            (key.get() < 100).then_some(key.get() as usize)
        }
        fn row(&self, _: usize) -> El<'_> {
            div().h(20)
        }
    }
    impl View for Rows {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::HEIGHT).direct(Self::COLOR)
        }
        fn view(&self) -> El<'_> {
            uniform_list(LIST, self, 20)
                .w(80)
                .h(&self.height)
                .bg(&self.color)
        }
    }
    let mut win = Win::with_size(
        Rows {
            height: Signal::new(80),
            color: Signal::new(Color::BLACK),
        },
        100,
        160,
    )
    .unwrap();
    let list = win.list(LIST).unwrap();
    assert_eq!(win.list_state(list).unwrap().visible_range, 0..4);
    win.reset_counters().unwrap();
    win.set(Rows::COLOR, Color::WHITE).unwrap();
    assert_eq!(win.counters().descriptions, 0);
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().layout_runs, 0);
    win.set(Rows::HEIGHT, 100).unwrap();
    assert_eq!(win.list_state(list).unwrap().visible_range, 0..5);
    assert_eq!(
        win.counters().descriptions,
        1,
        "one realization boundary, not two descriptions"
    );
}

#[test]
fn borrowed_flex_fields_and_flow_publish_through_the_closed_typed_schema() {
    struct Fields {
        flow: Signal<Flow>,
        align: Signal<Align>,
        justify: Signal<Justify>,
        wrap: Signal<bool>,
        gap: Signal<u8>,
    }
    impl Fields {
        const FLOW: Source<Self, Flow> =
            Source::new(FieldId::new(1), "flow", |m| &m.flow, |m| &mut m.flow);
        const ALIGN: Source<Self, Align> =
            Source::new(FieldId::new(2), "align", |m| &m.align, |m| &mut m.align);
        const JUSTIFY: Source<Self, Justify> = Source::new(
            FieldId::new(3),
            "justify",
            |m| &m.justify,
            |m| &mut m.justify,
        );
        const WRAP: Source<Self, bool> =
            Source::new(FieldId::new(4), "wrap", |m| &m.wrap, |m| &mut m.wrap);
        const GAP: Source<Self, u8> =
            Source::new(FieldId::new(5), "gap", |m| &m.gap, |m| &mut m.gap);
    }
    impl View for Fields {
        fn sources() -> Sources<Self> {
            Sources::new()
                .direct(Self::FLOW)
                .direct(Self::ALIGN)
                .direct(Self::JUSTIFY)
                .direct(Self::WRAP)
                .direct(Self::GAP)
        }
        fn view(&self) -> El<'_> {
            let recipe = Flex::row()
                .gap(&self.gap)
                .align(&self.align)
                .justify(&self.justify)
                .wrap(&self.wrap);
            div()
                .name("flex")
                .size(80)
                .layout(&recipe)
                .flow(&self.flow)
                .child(text(&self.wrap))
        }
    }
    let mut win = Win::with_size(
        Fields {
            flow: Signal::new(Flow::Row),
            align: Signal::new(Align::Start),
            justify: Signal::new(Justify::Start),
            wrap: Signal::new(false),
            gap: Signal::new(0),
        },
        100,
        100,
    )
    .unwrap();
    let target = win.query().name("flex").one().unwrap();
    win.reset_counters().unwrap();
    win.set(Fields::FLOW, Flow::Column).unwrap();
    win.set(Fields::ALIGN, Align::End).unwrap();
    win.set(Fields::JUSTIFY, Justify::Center).unwrap();
    win.set(Fields::WRAP, true).unwrap();
    win.set(Fields::GAP, 4).unwrap();
    assert_eq!(
        win.property(target, gpui::property::FLOW).unwrap(),
        Flow::Column
    );
    assert_eq!(
        win.property(target, gpui::property::ALIGN).unwrap(),
        Align::End
    );
    assert_eq!(
        win.property(target, gpui::property::JUSTIFY).unwrap(),
        Justify::Center
    );
    assert!(win.property(target, gpui::property::WRAP).unwrap());
    assert_eq!(win.property(target, gpui::property::GAP).unwrap(), 4.0);
    assert!(win.find_text("true").is_ok());
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().source_reads, 5);
}

#[test]
fn large_integer_lengths_preserve_the_inherited_f019_narrowing_oracle() {
    // The immediate f019 baseline used IntoLength -> f64 -> f32. These values
    // straddle f32 midpoints after f64 has erased the low bit; direct integer
    // casts differ. This source-port change deliberately preserves that policy.
    let unsigned = (1_u64 << 63) + (1_u64 << 39) + 1;
    let signed = (1_i64 << 62) + (1_i64 << 38) + 1;
    macro_rules! check {
        ($value:expr,$ty:ty) => {{
            let value: $ty = $value;
            let expected = (value as f64) as f32;
            assert_ne!(expected.to_bits(), (value as f32).to_bits());
            struct Literal($ty);
            impl View for Literal {
                fn view(&self) -> El<'_> {
                    div().w(self.0).h(1)
                }
            }
            struct Bound(Signal<$ty>);
            impl View for Bound {
                fn view(&self) -> El<'_> {
                    div().w(&self.0).h(1)
                }
            }
            let literal = Win::with_size(Literal(value), 4, 4).unwrap();
            let bound = Win::with_size(Bound(Signal::new(value)), 4, 4).unwrap();
            for (literal, actual) in [
                (true, {
                    let target = literal.inspect().unwrap().nodes[0].target.unwrap();
                    literal.property(target, WIDTH).unwrap().unwrap()
                }),
                (false, {
                    let target = bound.inspect().unwrap().nodes[0].target.unwrap();
                    bound.property(target, WIDTH).unwrap().unwrap()
                }),
            ] {
                assert_eq!(actual.to_bits(), expected.to_bits(), "literal={literal}");
            }
        }};
    }
    check!(unsigned, u64);
    check!(signed, i64);
}
