use gpui::{Error, ListError, Role, ScrollOffset, WindowOptions, prelude::*};
const LIST: ListId = ListId::new(31);
struct Rows {
    offset: Signal<f64>,
    other: Signal<f64>,
    wrong_writer: bool,
    alternate: bool,
    controlled: bool,
    len: usize,
    first: u64,
    list: bool,
}
impl Rows {
    const OFFSET: Source<Self, f64> = Source::new(
        FieldId::new(1),
        "offset",
        |m| &m.offset,
        |m| {
            if m.wrong_writer {
                &mut m.other
            } else {
                &mut m.offset
            }
        },
    );
    const OTHER: Source<Self, f64> =
        Source::new(FieldId::new(2), "other", |m| &m.other, |m| &mut m.other);
    fn new(offset: f64) -> Self {
        Self {
            offset: Signal::new(offset),
            other: Signal::new(0.),
            wrong_writer: false,
            alternate: false,
            controlled: true,
            len: 100_000,
            first: 100,
            list: true,
        }
    }
}
impl ItemSource for Rows {
    fn len(&self) -> usize {
        self.len
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(self.first + index as u64)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        usize::try_from(key.get().checked_sub(self.first)?)
            .ok()
            .filter(|i| *i < self.len)
    }
    fn row(&self, index: usize) -> El<'_> {
        text(format!("row {}", self.first + index as u64))
            .h(32)
            .w(200)
            .bg(Color::rgb(220, 230, 240))
    }
}
impl View for Rows {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::OFFSET).direct(Self::OTHER)
    }
    fn view(&self) -> El<'_> {
        column((
            text(&self.offset).h(24),
            if self.list {
                uniform_list(LIST, self, 32)
                    .overscan(2)
                    .apply(|list| {
                        if self.controlled {
                            list.scroll_offset(if self.alternate {
                                &self.other
                            } else {
                                &self.offset
                            })
                        } else {
                            list
                        }
                    })
                    .h(96)
                    .w(200)
            } else {
                div().h(96).w(200)
            },
        ))
    }
}
fn pixels(win: &mut Win<Rows>) -> Vec<u8> {
    win.with_pixels(|p, _, _| p.to_vec()).unwrap()
}
fn window(offset: f64) -> Win<Rows> {
    Win::with_size(Rows::new(offset), 240, 160).unwrap()
}
fn offset(win: &Win<Rows>) -> f64 {
    win.list_state(win.list(LIST).unwrap()).unwrap().offset
}
fn ack(win: &mut Win<Rows>) {
    let token = win.with_scene(|_, t| t).unwrap();
    win.presented(token).unwrap();
}

#[test]
fn direct_source_without_owner_dependency_realizes_and_matches_fresh_pixels() {
    let mut win = window(0.);
    for value in [320.25, 16., 3_200_000., 0.] {
        win.set(Rows::OFFSET, value).unwrap();
        let mut fresh = window(value);
        assert_eq!(offset(&win), offset(&fresh));
        assert_eq!(pixels(&mut win), pixels(&mut fresh));
    }
}
#[test]
fn wheel_offset_index_key_and_next_tick_share_one_source() {
    let mut win = window(0.);
    let list = win.list(LIST).unwrap();
    win.scroll_at(Point { x: 50., y: 40. }, 14.).unwrap();
    assert_eq!(*win.read(Rows::OFFSET).unwrap(), 14.);
    assert_eq!(offset(&win), 14.);
    let next = *win.read(Rows::OFFSET).unwrap() + 14.;
    win.set(Rows::OFFSET, next).unwrap();
    assert_eq!(offset(&win), 28.);
    win.scroll_to(list, ScrollOffset { x: 0., y: 320.25 })
        .unwrap();
    assert_eq!(*win.read(Rows::OFFSET).unwrap(), 320.25);
    win.scroll_to_index(list, 100).unwrap();
    assert_eq!(*win.read(Rows::OFFSET).unwrap(), 3200.);
    win.scroll_to_key(list, ItemKey::new(90_100)).unwrap();
    assert_eq!(*win.read(Rows::OFFSET).unwrap(), 2_880_000.);
    win.scroll(list, 16.).unwrap();
    assert_eq!(*win.read(Rows::OFFSET).unwrap(), 2_880_016.);
    let mut fresh = window(2_880_016.);
    assert_eq!(pixels(&mut win), pixels(&mut fresh));
    assert_eq!(
        win.scroll_to_key(list, ItemKey::new(0)),
        Err(Error::List(ListError::MissingKey(ItemKey::new(0))))
    );
}
#[test]
fn controlled_offset_is_absolute_across_prepend_and_clamps_without_shared_writeback() {
    let mut win = window(320.25);
    win.update(|m| {
        m.first -= 1;
        m.len += 1;
    })
    .unwrap();
    assert_eq!(offset(&win), 320.25);
    win.set(Rows::OFFSET, 3_200_000.).unwrap();
    assert_eq!(*win.read(Rows::OFFSET).unwrap(), 3_200_000.);
    assert_eq!(offset(&win), 3_199_936.);
    win.update(|m| m.len = 2).unwrap();
    assert_eq!(offset(&win), 0.);
    assert_eq!(*win.read(Rows::OFFSET).unwrap(), 3_200_000.);
    win.scroll(win.list(LIST).unwrap(), 1.).unwrap();
    assert_eq!(*win.read(Rows::OFFSET).unwrap(), 0.);
}
#[test]
fn pending_and_failed_newer_source_keep_old_sheet_and_eligible_ack() {
    let mut win = Win::recording(
        Rows::new(0.),
        WindowOptions {
            size: [240, 160],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let list = win.list(LIST).unwrap();
    let before = win.snapshot().unwrap();
    win.set(Rows::OFFSET, 320.).unwrap();
    let candidate = win.with_scene(|_, t| t).unwrap();
    assert_eq!(win.scroll(list, 1.), Err(Error::PresentationStale));
    assert_eq!(win.snapshot().unwrap().nodes, before.nodes);
    assert!(win.set(Rows::OFFSET, f64::NAN).is_err());
    assert_eq!(win.with_scene(|_, t| t).unwrap(), candidate);
    win.presented(candidate).unwrap();
    win.set(Rows::OFFSET, 640.25).unwrap();
    ack(&mut win);
    assert_eq!(offset(&win), 640.25);
    let mut fresh = window(640.25);
    assert_eq!(pixels(&mut win), pixels(&mut fresh));
}
#[test]
fn rejected_writer_does_not_mutate_sources_and_rebinding_does_not_use_old_field() {
    let mut win = window(0.);
    let list = win.list(LIST).unwrap();
    assert_eq!(
        win.update(|m| m.wrong_writer = true),
        Err(Error::Binding(gpui::BindError::ProjectionMismatch(
            Rows::OFFSET.id()
        )))
    );
    assert_eq!(*win.read(Rows::OFFSET).unwrap(), 0.);
    assert_eq!(*win.read(Rows::OTHER).unwrap(), 0.);
    assert_eq!(win.scroll(list, 32.), Err(Error::StaleTarget));
    win.update(|m| m.wrong_writer = false).unwrap();
    let list = win.list(LIST).unwrap();
    win.update(|m| m.alternate = true).unwrap();
    win.scroll(list, 32.).unwrap();
    assert_eq!(*win.read(Rows::OFFSET).unwrap(), 0.);
    assert_eq!(*win.read(Rows::OTHER).unwrap(), 32.);
    win.update(|m| m.list = false).unwrap();
    assert_eq!(win.scroll(list, 32.), Err(Error::StaleTarget));
    assert_eq!(*win.read(Rows::OTHER).unwrap(), 32.);
}
#[test]
fn contained_source_resolution_and_writeback_use_component_namespace() {
    struct Parent {
        rows: Rows,
    }
    impl Parent {
        const CHILD: Component<Self, Rows> =
            Component::new(FieldId::new(3), "rows", |m| &m.rows, |m| &mut m.rows);
    }
    impl View for Parent {
        fn sources() -> Sources<Self> {
            Sources::new().component(Self::CHILD)
        }
        fn view(&self) -> El<'_> {
            Self::CHILD.view(self)
        }
    }
    let mut win = Win::with_size(
        Parent {
            rows: Rows::new(0.),
        },
        240,
        160,
    )
    .unwrap();
    win.scroll(win.list(LIST).unwrap(), 32.).unwrap();
    assert_eq!(*win.root().unwrap().rows.offset, 32.);
    win.set(Parent::CHILD.source(Rows::OFFSET), 64.).unwrap();
    assert_eq!(win.list_state(win.list(LIST).unwrap()).unwrap().offset, 64.);
}
#[test]
fn unregistered_scroll_operand_rejects_mount() {
    struct Unregistered(Rows);
    impl View for Unregistered {
        fn view(&self) -> El<'_> {
            uniform_list(LIST, &self.0, 32)
                .scroll_offset(&self.0.offset)
                .h(96)
                .w(200)
        }
    }
    assert!(matches!(
        Win::with_size(Unregistered(Rows::new(0.)), 240, 160),
        Err(Error::UnregisteredInput { .. })
    ));
}
#[test]
fn controlled_source_without_any_other_sink_is_not_lost() {
    struct Only(Rows);
    impl Only {
        const OFFSET: Source<Self, f64> = Source::new(
            FieldId::new(1),
            "offset",
            |m| &m.0.offset,
            |m| &mut m.0.offset,
        );
    }
    impl View for Only {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::OFFSET)
        }
        fn view(&self) -> El<'_> {
            uniform_list(LIST, &self.0, 32)
                .scroll_offset(&self.0.offset)
                .h(96)
                .w(200)
        }
    }
    let mut win = Win::with_size(Only(Rows::new(0.)), 240, 160).unwrap();
    win.set(Only::OFFSET, 320.).unwrap();
    assert_eq!(
        win.list_state(win.list(LIST).unwrap()).unwrap().offset,
        320.
    );
    assert!(win.role(Role::Text).text("row 110").one().is_ok());
}

#[test]
fn shared_offset_updates_both_lists_in_one_source_epoch() {
    struct Shared(Rows);
    impl Shared {
        const OFFSET: Source<Self, f64> = Source::new(
            FieldId::new(1),
            "offset",
            |m| &m.0.offset,
            |m| &mut m.0.offset,
        );
    }
    impl View for Shared {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::OFFSET)
        }
        fn view(&self) -> El<'_> {
            row((
                uniform_list(LIST, &self.0, 32)
                    .scroll_offset(&self.0.offset)
                    .h(96)
                    .w(100),
                uniform_list(ListId::new(32), &self.0, 32)
                    .scroll_offset(&self.0.offset)
                    .h(64)
                    .w(100),
            ))
        }
    }
    let mut win = Win::with_size(Shared(Rows::new(0.)), 240, 160).unwrap();
    let epoch = win.snapshot().unwrap().source_epoch;
    win.scroll(win.list(LIST).unwrap(), 32.).unwrap();
    assert_eq!(*win.read(Shared::OFFSET).unwrap(), 32.);
    for id in [LIST, ListId::new(32)] {
        assert_eq!(win.list_state(win.list(id).unwrap()).unwrap().offset, 32.);
    }
    assert_eq!(win.snapshot().unwrap().source_epoch, epoch + 1);
}
#[test]
fn nested_wheel_commits_controlled_list_and_ordinary_residual_together() {
    struct Nested(Rows);
    impl Nested {
        const OFFSET: Source<Self, f64> = Source::new(
            FieldId::new(1),
            "offset",
            |m| &m.0.offset,
            |m| &mut m.0.offset,
        );
    }
    impl View for Nested {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::OFFSET)
        }
        fn view(&self) -> El<'_> {
            div().w(200).h(100).scroll(gpui::Axis::Y).child(column((
                uniform_list(LIST, &self.0, 32)
                    .scroll_offset(&self.0.offset)
                    .h(64)
                    .w(200),
                div().h(300).w(200).bg(Color::BLACK),
            )))
        }
    }
    let model = |value| {
        let mut rows = Rows::new(value);
        rows.len = 3;
        Nested(rows)
    };
    let mut win = Win::with_size(model(0.), 220, 120).unwrap();
    let outer = win.role(Role::ScrollView).one().unwrap();
    win.scroll_at(Point { x: 10., y: 10. }, 64.).unwrap();
    assert_eq!(*win.read(Nested::OFFSET).unwrap(), 32.);
    assert_eq!(win.list_state(win.list(LIST).unwrap()).unwrap().offset, 32.);
    assert_eq!(win.viewport(outer).unwrap().offset.y, 32.);
    let actual = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
    let mut fresh = Win::with_size(model(32.), 220, 120).unwrap();
    fresh
        .scroll_to(
            fresh.role(Role::ScrollView).one().unwrap(),
            ScrollOffset { x: 0., y: 32. },
        )
        .unwrap();
    fresh.with_pixels(|p, _, _| assert_eq!(actual, p)).unwrap();
}

#[test]
fn optional_list_description_storage_has_exact_charged_costs() {
    let rows = Rows::new(0.);
    for mode in 0..5 {
        let mut element = None;
        let measured = allocation_counter::measure(|| {
            let list = uniform_list(LIST, &rows, 32);
            element = Some(match mode {
                0 => list,
                1 => list.overscan(0),
                2 => list.overscan(2),
                3 => list.scroll_offset(&rows.offset),
                _ => list.overscan(2).scroll_offset(&rows.offset).name("list"),
            });
        });
        let expected = match mode {
            0 | 1 => (1, 56),
            2 | 3 => (2, 88),
            _ => (3, 128),
        };
        assert_eq!((measured.count_total, measured.bytes_total), expected);
        eprintln!(
            "list_description,mode={mode},requests={},bytes={},retained={}",
            measured.count_total, measured.bytes_total, measured.bytes_current
        );
        drop(element);
    }
}

#[test]
fn complete_list_source_allocation_ledger() {
    let mode = std::env::var("GPUI_LIST_SOURCE_LEDGER_MODE")
        .unwrap_or_else(|_| "3".into())
        .parse::<u8>()
        .unwrap();
    assert!(mode < 4);
    let controlled = mode & 1 != 0;
    let overscan = if mode & 2 != 0 { 2 } else { 0 };
    struct Fixture {
        rows: Rows,
        overscan: usize,
    }
    impl Fixture {
        const OFFSET: Source<Self, f64> = Source::new(
            FieldId::new(1),
            "offset",
            |m| &m.rows.offset,
            |m| &mut m.rows.offset,
        );
    }
    impl View for Fixture {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::OFFSET)
        }
        fn view(&self) -> El<'_> {
            column((
                text(&self.rows.offset).h(24),
                uniform_list(LIST, &self.rows, 32)
                    .overscan(self.overscan)
                    .apply(|list| {
                        if self.rows.controlled {
                            list.scroll_offset(&self.rows.offset)
                        } else {
                            list
                        }
                    })
                    .h(96)
                    .w(200),
            ))
        }
    }
    let mut win = None;
    let mount = allocation_counter::measure(|| {
        let mut rows = Rows::new(0.);
        rows.controlled = controlled;
        let mut owner = Win::recording(
            Fixture { rows, overscan },
            WindowOptions {
                size: [240, 160],
                ..Default::default()
            },
        )
        .unwrap();
        let token = owner.with_scene(|_, t| t).unwrap();
        owner.presented(token).unwrap();
        win = Some(owner);
    });
    let mut win = win.unwrap();
    let list = win.list(LIST).unwrap();
    let scroll = allocation_counter::measure(|| {
        for _ in 0..16 {
            win.scroll(list, 14.).unwrap();
            let token = win.with_scene(|_, t| t).unwrap();
            win.presented(token).unwrap();
        }
    });
    assert_eq!(win.list_state(list).unwrap().offset, 224.);
    assert_eq!(
        *win.read(Fixture::OFFSET).unwrap(),
        if controlled { 224. } else { 0. }
    );
    assert_eq!(
        win.snapshot().unwrap().source_epoch,
        if controlled { 16 } else { 0 }
    );
    for (operation, value) in [("mount", mount), ("scroll16", scroll)] {
        eprintln!(
            "list_source_alloc,mode={mode},controlled={controlled},overscan={overscan},operation={operation},requests={},bytes={},retained={},peak={}",
            value.count_total, value.bytes_total, value.bytes_current, value.bytes_max
        );
    }
}
