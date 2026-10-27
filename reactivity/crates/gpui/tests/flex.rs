use gpui::{
    Application, Error, Role, Style, WindowOptions,
    prelude::*,
    property::{ALIGN, Contribution, FLOW, JUSTIFY, WRAP},
};

struct Panel {
    recipe: Flex,
    height: f32,
}
impl View for Panel {
    fn view(&self) -> El<'_> {
        div().w(100).h(self.height).layout(self.recipe).child((
            button("a").w(20).h(10).on_click(|_: &mut Self| {}),
            button("b")
                .w(20)
                .h(20)
                .bg(Color::BLACK)
                .on_click(|_: &mut Self| {}),
        ))
    }
}
fn panel(recipe: Flex) -> Win<Panel> {
    Application::demo()
        .open(Panel {
            recipe,
            height: 60.0,
        })
        .unwrap()
}
fn bounds(win: &Win<Panel>, name: &str) -> Rect {
    let target = win.role(Role::Button).text(name).one().unwrap();
    win.bounds(target).unwrap()
}
fn near(actual: Rect, expected: [f32; 4]) {
    let actual = [actual.x, actual.y, actual.width, actual.height];
    for (a, b) in actual.into_iter().zip(expected) {
        assert!((a - b).abs() < 0.001, "{actual:?} != {expected:?}");
    }
}
fn container(win: &mut Win<Panel>) -> Target {
    win.inspect().unwrap().nodes[0].target.unwrap()
}

#[test]
fn aligned_and_distributed_children_share_layout_hits_and_pixels() {
    let mut win = panel(
        Flex::row()
            .align(Align::Center)
            .justify(Justify::SpaceBetween),
    );
    near(bounds(&win, "a"), [0.0, 25.0, 20.0, 10.0]);
    near(bounds(&win, "b"), [80.0, 20.0, 20.0, 20.0]);
    let target = win.role(Role::Button).text("b").one().unwrap();
    assert_eq!(
        win.hit_target(Point { x: 85.0, y: 22.0 }).unwrap(),
        Some(target)
    );
    assert_eq!(win.hit_target(Point { x: 85.0, y: 5.0 }).unwrap(), None);
    // A typed layout override moves the actual surface, without a View rerun.
    let root = container(&mut win);
    win.reset_counters().unwrap();
    win.set_property(root, ALIGN, Contribution::Set(Align::End))
        .unwrap();
    near(bounds(&win, "a"), [0.0, 50.0, 20.0, 10.0]);
    near(bounds(&win, "b"), [80.0, 40.0, 20.0, 20.0]);
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().layout_runs, 1);
    win.with_pixels(|pixels, w, _| {
        let old = (22 * w as usize + 85) * 4;
        assert_eq!(&pixels[old..old + 4], &[255; 4]);
        let new = (59 * w as usize + 99) * 4;
        assert_eq!(&pixels[new..new + 4], &[0, 0, 0, 255]);
    })
    .unwrap();
}

#[test]
fn both_axes_and_every_distribution_use_the_same_recipe() {
    for (justify, start, second) in [
        (Justify::Start, 0.0, 20.0),
        (Justify::End, 60.0, 80.0),
        (Justify::Center, 30.0, 50.0),
        (Justify::SpaceBetween, 0.0, 80.0),
        (Justify::SpaceAround, 15.0, 65.0),
        (Justify::SpaceEvenly, 20.0, 60.0),
    ] {
        let win = panel(Flex::row().align(Align::Start).justify(justify));
        near(bounds(&win, "a"), [start, 0.0, 20.0, 10.0]);
        near(bounds(&win, "b"), [second, 0.0, 20.0, 20.0]);
    }
    let mut win = panel(Flex::column().align(Align::End).justify(Justify::Center));
    near(bounds(&win, "a"), [80.0, 15.0, 20.0, 10.0]);
    near(bounds(&win, "b"), [80.0, 25.0, 20.0, 20.0]);
    let root = container(&mut win);
    win.set_property(root, FLOW, Contribution::Set(Flow::Row))
        .unwrap();
    near(bounds(&win, "a"), [30.0, 50.0, 20.0, 10.0]);
}

#[test]
fn wrapping_overrides_and_unset_reveal_changed_declarations() {
    let mut win = panel(Flex::row().align(Align::Start));
    let root = container(&mut win);
    win.set_property(root, WRAP, Contribution::Set(true))
        .unwrap();
    win.set_property(root, gpui::property::WIDTH, Contribution::Set(Some(30.0)))
        .unwrap();
    let a = win.role(Role::Button).text("a").one().unwrap();
    let b = win.role(Role::Button).text("b").one().unwrap();
    near(bounds(&win, "b"), [0.0, 25.0, 20.0, 20.0]);
    win.update(|m| m.recipe = Flex::row().align(Align::End).wrap(false))
        .unwrap();
    assert!(win.property(root, WRAP).unwrap());
    win.set_property(root, WRAP, Contribution::Inherit).unwrap();
    near(bounds(&win, "b"), [20.0, 40.0, 20.0, 20.0]);
    win.set_property(root, gpui::property::WIDTH, Contribution::Inherit)
        .unwrap();
    assert_eq!(win.role(Role::Button).text("a").one().unwrap(), a);
    assert_eq!(win.role(Role::Button).text("b").one().unwrap(), b);
    assert_eq!(win.property(root, ALIGN).unwrap(), Align::End);
}

#[test]
fn wrapping_reflows_at_resize_and_density_changes_without_replacing_targets() {
    struct Fluid;
    impl View for Fluid {
        fn view(&self) -> El<'_> {
            div()
                .h(60)
                .layout(Flex::row().align(Align::Start).wrap(true))
                .child((
                    button("a").w(30).h(10),
                    button("b").w(30).h(10),
                    button("c").w(30).h(10),
                ))
        }
    }
    let mut win = Win::with_size(Fluid, 80, 60).unwrap();
    let b = win.role(Role::Button).text("b").one().unwrap();
    let c = win.role(Role::Button).text("c").one().unwrap();
    near(win.bounds(b).unwrap(), [30.0, 0.0, 30.0, 10.0]);
    near(win.bounds(c).unwrap(), [0.0, 30.0, 30.0, 10.0]);
    win.reset_counters().unwrap();
    win.resize([40, 60]).unwrap();
    near(win.bounds(b).unwrap(), [0.0, 20.0, 30.0, 10.0]);
    near(win.bounds(c).unwrap(), [0.0, 40.0, 30.0, 10.0]);
    win.resize_scaled([80, 120], 2.0).unwrap();
    near(win.bounds(b).unwrap(), [0.0, 40.0, 60.0, 20.0]);
    near(win.bounds(c).unwrap(), [0.0, 80.0, 60.0, 20.0]);
    assert_eq!(win.role(Role::Button).text("b").one().unwrap(), b);
    assert_eq!(win.role(Role::Button).text("c").one().unwrap(), c);
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().layout_runs, 2);
}

#[test]
fn pending_layout_keeps_acknowledged_geometry_and_blocks_coordinate_actions() {
    let mut win = Win::recording(
        Panel {
            recipe: Flex::row(),
            height: 60.0,
        },
        WindowOptions {
            size: [100, 60],
            ..Default::default()
        },
    )
    .unwrap();
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    let root = container(&mut win);
    let a = win.role(Role::Button).text("a").one().unwrap();
    let before = win.bounds(a).unwrap();
    win.set_property(root, JUSTIFY, Contribution::Set(Justify::End))
        .unwrap();
    assert_eq!(win.bounds(a).unwrap(), before);
    assert_eq!(
        win.click_at(Point { x: 61.0, y: 5.0 }),
        Err(Error::PresentationStale)
    );
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    near(win.bounds(a).unwrap(), [60.0, 0.0, 20.0, 10.0]);
    assert_eq!(win.hit_target(Point { x: 61.0, y: 5.0 }).unwrap(), Some(a));
}

#[test]
fn partial_recipes_preserve_previous_declared_fields() {
    struct Compose;
    impl View for Compose {
        fn view(&self) -> El<'_> {
            div()
                .w(100)
                .h(60)
                .layout(
                    Flex::row()
                        .align(Align::End)
                        .justify(Justify::End)
                        .gap(5)
                        .wrap(true),
                )
                .layout(Flex::column())
                .child(button("child").w(20).h(10))
        }
    }
    let win = Application::demo().open(Compose).unwrap();
    let root = win.inspect().unwrap().nodes[0].target.unwrap();
    assert_eq!(win.property(root, FLOW).unwrap(), Flow::Column);
    assert_eq!(win.property(root, ALIGN).unwrap(), Align::End);
    assert_eq!(win.property(root, JUSTIFY).unwrap(), Justify::End);
    assert!(win.property(root, WRAP).unwrap());
    let target = win.role(Role::Button).text("child").one().unwrap();
    near(win.bounds(target).unwrap(), [80.0, 50.0, 20.0, 10.0]);
    // Absolute line height adds eight bytes to authored style on this ABI.
    if cfg!(target_pointer_width = "64") {
        assert_eq!(std::mem::size_of::<Style>(), 96);
        assert_eq!(std::mem::size_of::<El<'_>>(), 184);
    }
}

#[test]
fn shared_style_discovery_keeps_distinct_alignment_destinations() {
    struct Repeated;
    impl View for Repeated {
        fn view(&self) -> El<'_> {
            column((0..9).map(|index| {
                div()
                    .w(20)
                    .h(40)
                    .layout(Flex::column().align(if index % 2 == 0 {
                        Align::Start
                    } else {
                        Align::End
                    }))
                    .child(button(format!("{index}")).w(10).h(10))
            }))
        }
    }
    let win = Application::demo().open(Repeated).unwrap();
    for index in 0..9 {
        let target = win
            .role(Role::Button)
            .text(&format!("{index}"))
            .one()
            .unwrap();
        near(
            win.bounds(target).unwrap(),
            [
                if index % 2 == 0 { 0.0 } else { 10.0 },
                index as f32 * 40.0,
                10.0,
                10.0,
            ],
        );
    }
}

#[test]
fn baseline_alignment_uses_shaped_text_baselines_and_stretch_respects_auto_size() {
    struct Type;
    impl View for Type {
        fn view(&self) -> El<'_> {
            row((text("small").font_size(10), text("large").font_size(20)))
                .layout(Flex::row().align(Align::Baseline))
        }
    }
    let win = Application::demo().open(Type).unwrap();
    let small = win
        .bounds(win.role(Role::Text).text("small").one().unwrap())
        .unwrap();
    let large = win
        .bounds(win.role(Role::Text).text("large").one().unwrap())
        .unwrap();
    let font = gpui_canvas::TextSystem::bundled().unwrap();
    let a = font.shape("small", 10.0, None).unwrap().baseline;
    let b = font.shape("large", 20.0, None).unwrap().baseline;
    assert!((small.y + a - large.y - b).abs() < 0.001);
    assert!(small.y > large.y);

    struct Stretch;
    impl View for Stretch {
        fn view(&self) -> El<'_> {
            column(button("x").h(10)).w(100).h(30)
        }
    }
    let mut win = Application::demo().open(Stretch).unwrap();
    let root = win.inspect().unwrap().nodes[0].target.unwrap();
    let child = win.role(Role::Button).text("x").one().unwrap();
    let stretched = win.bounds(child).unwrap();
    // Public world bounds round outward; layout's exact width remains 100.
    assert!((stretched.width - 100.0).abs() < 0.001);
    win.set_property(root, ALIGN, Contribution::Set(Align::Start))
        .unwrap();
    assert!(win.bounds(child).unwrap().width < 100.0);
    win.set_property(root, ALIGN, Contribution::Inherit)
        .unwrap();
    assert_eq!(win.bounds(child).unwrap(), stretched);
}

#[test]
fn oversized_row_item_and_column_wrapping_preserve_gap_and_order() {
    struct Wrapped {
        column: bool,
    }
    impl View for Wrapped {
        fn view(&self) -> El<'_> {
            let flow = if self.column {
                Flex::column()
            } else {
                Flex::row()
            };
            div()
                .w(if self.column { 45 } else { 100 })
                .h(25)
                .layout(flow.align(Align::Start).gap(5).wrap(true))
                .child((
                    button("a").w(if self.column { 20 } else { 130 }).h(10),
                    button("b").w(20).h(10),
                    button("c").w(20).h(10),
                ))
        }
    }
    let mut win = Application::demo().open(Wrapped { column: false }).unwrap();
    let get = |win: &Win<Wrapped>, s: &str| {
        win.bounds(win.role(Role::Button).text(s).one().unwrap())
            .unwrap()
    };
    near(get(&win, "a"), [0.0, 0.0, 130.0, 10.0]);
    near(get(&win, "b"), [0.0, 15.0, 20.0, 10.0]);
    near(get(&win, "c"), [25.0, 15.0, 20.0, 10.0]);
    win.update(|m| m.column = true).unwrap();
    near(get(&win, "a"), [0.0, 0.0, 20.0, 10.0]);
    near(get(&win, "b"), [0.0, 15.0, 20.0, 10.0]);
    near(get(&win, "c"), [25.0, 0.0, 20.0, 10.0]);
}

#[test]
fn explicit_default_contributions_survive_changed_component_recipes() {
    let mut win = panel(Flex::row());
    let root = container(&mut win);
    win.set_property(root, ALIGN, Contribution::Set(Align::Stretch))
        .unwrap();
    win.set_property(root, JUSTIFY, Contribution::Set(Justify::Start))
        .unwrap();
    win.set_property(root, WRAP, Contribution::Set(false))
        .unwrap();
    win.update(|m| {
        m.recipe = Flex::row()
            .align(Align::End)
            .justify(Justify::End)
            .wrap(true)
    })
    .unwrap();
    assert_eq!(win.property(root, ALIGN).unwrap(), Align::Stretch);
    assert_eq!(win.property(root, JUSTIFY).unwrap(), Justify::Start);
    assert!(!win.property(root, WRAP).unwrap());
    assert_eq!(
        win.contribution(root, WRAP).unwrap(),
        Contribution::Set(false)
    );
    win.set_property(root, ALIGN, Contribution::Inherit)
        .unwrap();
    win.set_property(root, JUSTIFY, Contribution::Inherit)
        .unwrap();
    win.set_property(root, WRAP, Contribution::Inherit).unwrap();
    assert_eq!(win.property(root, ALIGN).unwrap(), Align::End);
    assert_eq!(win.property(root, JUSTIFY).unwrap(), Justify::End);
    assert!(win.property(root, WRAP).unwrap());
}
