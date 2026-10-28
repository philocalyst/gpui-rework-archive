use gpui::{Error, ListError, Role, WindowOptions, prelude::*};
use std::sync::atomic::{AtomicUsize, Ordering};
fn near(actual: f32, expected: f32) {
    assert!(
        (actual - expected).abs() < 0.001,
        "actual={actual}, expected={expected}"
    );
}
const LIST: ListId = ListId::new(7);
struct Rows {
    len: usize,
    first: u64,
    reverse: bool,
    height: f32,
    calls: AtomicUsize,
    selected: Option<ItemKey>,
    overscan: usize,
}
impl Rows {
    fn new(len: usize) -> Self {
        Self {
            len,
            first: 100,
            reverse: false,
            height: 96.0,
            calls: AtomicUsize::new(0),
            selected: None,
            overscan: 0,
        }
    }
}
impl ItemSource for Rows {
    fn len(&self) -> usize {
        self.len
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(
            self.first
                + if self.reverse {
                    self.len - 1 - index
                } else {
                    index
                } as u64,
        )
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        let n = usize::try_from(key.get().checked_sub(self.first)?).ok()?;
        (n < self.len).then(|| if self.reverse { self.len - 1 - n } else { n })
    }
    fn row(&self, index: usize) -> El<'_> {
        self.calls.fetch_add(1, Ordering::Relaxed);
        let key = self.key(index);
        button(format!("item {}", key.get()))
            .h(32)
            .w(200)
            .bg(Color::rgb(220, 230, 240))
            .on_click(move |owner: &mut Self| owner.selected = Some(key))
    }
}
impl View for Rows {
    fn view(&self) -> El<'_> {
        column((
            div().h(20).w(200).bg(Color::BLACK),
            uniform_list(LIST, self, 32)
                .overscan(self.overscan)
                .h(self.height)
                .w(200),
            div().h(20).w(200).bg(Color::BLACK),
        ))
    }
}
fn item(win: &Win<Rows>, key: u64) -> Target {
    let row = win
        .list_item(win.list(LIST).unwrap(), ItemKey::new(key))
        .unwrap();
    win.role(Role::Button).within(row).one().unwrap()
}
#[test]
fn quarter_million_rows_have_bounded_realization_and_wide_local_scroll() {
    let mut win = Win::with_size(Rows::new(250_000), 240, 160).unwrap();
    let list = win.list(LIST).unwrap();
    assert_eq!(win.root().unwrap().calls.load(Ordering::Relaxed), 3);
    assert_eq!(win.role(Role::Button).count().unwrap(), 3);
    assert_eq!(win.list_state(list).unwrap().visible_range, 0..3);
    let epoch = win.snapshot().unwrap().source_epoch;
    win.scroll_to_index(list, 200_000).unwrap();
    let state = win.list_state(list).unwrap();
    assert_eq!(state.visible_range, 200_000..200_003);
    assert_eq!(state.extent, 8_000_000.0);
    assert_eq!(state.offset, 6_400_000.0);
    assert_eq!(state.realized_rows, 3);
    assert_eq!(win.snapshot().unwrap().source_epoch, epoch);
    for node in win.snapshot().unwrap().nodes {
        assert!(node.bounds.iter().all(|v| v.abs() < 1_000_000.0));
    }
    win.scroll_to_key(list, ItemKey::new(250_099)).unwrap();
    assert_eq!(
        win.list_state(list).unwrap().visible_range,
        249_997..250_000
    );
    assert_eq!(win.root().unwrap().calls.load(Ordering::Relaxed), 9);
}
#[test]
fn overlap_survives_scroll_reorder_and_prepend_but_offscreen_target_never_revives() {
    let mut win = Win::with_size(Rows::new(100), 240, 160).unwrap();
    let list = win.list(LIST).unwrap();
    let kept = item(&win, 101);
    let departed = item(&win, 100);
    win.scroll(list, 32.0).unwrap();
    assert_eq!(item(&win, 101), kept);
    assert_eq!(win.activate(departed), Err(Error::StaleTarget));
    win.update(|m| {
        m.first -= 1;
        m.len += 1;
    })
    .unwrap();
    assert_eq!(win.list_state(list).unwrap().visible_range, 2..5);
    assert_eq!(item(&win, 101), kept);
    win.activate(kept).unwrap();
    assert_eq!(win.root().unwrap().selected, Some(ItemKey::new(101)));
    win.update(|m| m.reverse = true).unwrap();
    assert_eq!(item(&win, 101), kept);
    win.activate(kept).unwrap();
    assert_eq!(win.root().unwrap().selected, Some(ItemKey::new(101)));
    win.scroll_to_key(list, ItemKey::new(100)).unwrap();
    assert_ne!(item(&win, 100), departed);
    assert_eq!(win.activate(departed), Err(Error::StaleTarget));
}
#[test]
fn fractional_scroll_clips_fixed_slots_and_does_not_hit_header_or_footer() {
    let mut win = Win::with_size(Rows::new(100), 240, 160).unwrap();
    let list = win.list(LIST).unwrap();
    win.scroll(list, 16.25).unwrap();
    assert_eq!(win.list_state(list).unwrap().visible_range, 0..4);
    let row = item(&win, 100);
    let bounds = win.bounds(row).unwrap();
    near(bounds.y, 20.0);
    near(bounds.height, 15.75);
    assert_eq!(
        win.click_at(Point { x: 10.0, y: 19.875 }),
        Err(Error::NotHittable)
    );
    assert_eq!(
        win.click_at(Point { x: 10.0, y: 116.0 }),
        Err(Error::NotHittable)
    );
    win.click_at(Point { x: 10.0, y: 20.125 }).unwrap();
    assert_eq!(win.root().unwrap().selected, Some(ItemKey::new(100)));
}
#[test]
fn recording_scroll_publishes_semantics_only_after_exact_acknowledgement() {
    let mut win = Win::recording(
        Rows::new(100),
        WindowOptions {
            size: [240, 160],
            ..Default::default()
        },
    )
    .unwrap();
    let first = win.with_scene(|_, token| token).unwrap();
    win.presented(first).unwrap();
    let list = win.list(LIST).unwrap();
    let oldrow = win.list_item(list, ItemKey::new(100)).unwrap();
    let oldbutton = item(&win, 100);
    win.scroll_to_index(list, 50).unwrap();
    assert_eq!(win.list_state(list), Err(Error::PresentationStale));
    assert_eq!(
        win.list_item(list, ItemKey::new(150)),
        Err(Error::PresentationStale)
    );
    assert_eq!(win.role(Role::Button).within(oldrow).count().unwrap(), 1);
    near(win.bounds(oldbutton).unwrap().y, 20.0);
    assert_eq!(win.scroll(list, 1.0), Err(Error::PresentationStale));
    assert_eq!(win.presented(first), Err(Error::StalePresentation));
    let second = win.with_scene(|_, token| token).unwrap();
    assert_ne!(first, second);
    win.presented(second).unwrap();
    assert_eq!(win.list_state(list).unwrap().visible_range, 50..53);
    assert_eq!(
        win.role(Role::Button).within(oldrow).count(),
        Err(Error::StaleTarget)
    );
    assert_eq!(win.activate(oldbutton), Err(Error::StaleTarget));
    assert_eq!(win.snapshot().unwrap().source_epoch, 0);
}
#[test]
fn empty_shrink_and_invalid_scroll_admission_are_checked() {
    let mut win = Win::with_size(Rows::new(0), 240, 160).unwrap();
    let list = win.list(LIST).unwrap();
    assert_eq!(win.list_state(list).unwrap().realized_rows, 0);
    assert_eq!(
        win.scroll(list, f64::NAN),
        Err(Error::List(ListError::InvalidDelta))
    );
    assert_eq!(
        win.scroll_to_index(list, 0),
        Err(Error::List(ListError::IndexOutOfRange))
    );
    win.update(|m| m.len = 100).unwrap();
    let list = win.list(LIST).unwrap();
    win.scroll_to_index(list, 99).unwrap();
    win.update(|m| m.len = 1).unwrap();
    assert_eq!(win.list_state(list).unwrap().offset, 0.0);
    assert_eq!(win.list_state(list).unwrap().visible_range, 0..1);
    win.update(|m| m.len = 0).unwrap();
    assert_eq!(win.list_state(list).unwrap().visible_range, 0..0);
}

#[test]
fn row_slots_clip_overflow_and_keep_empty_structural_ancestors() {
    struct Overflow {
        selected: bool,
    }
    impl ItemSource for Overflow {
        fn len(&self) -> usize {
            20
        }
        fn key(&self, index: usize) -> ItemKey {
            ItemKey::new(index as u64)
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            (key.get() < 20).then_some(key.get() as usize)
        }
        fn row(&self, _: usize) -> El<'_> {
            div().h(0).child(
                button("overflow")
                    .h(100)
                    .w(100)
                    .bg(Color::BLACK)
                    .on_click(|m: &mut Self| m.selected = true),
            )
        }
    }
    impl View for Overflow {
        fn view(&self) -> El<'_> {
            uniform_list(LIST, self, 32).h(64).w(100)
        }
    }
    let mut win = Win::with_size(Overflow { selected: false }, 100, 100).unwrap();
    let list = win.list(LIST).unwrap();
    let row = win.list_item(list, ItemKey::new(0)).unwrap();
    let target = win.role(Role::Button).within(row).one().unwrap();
    near(win.bounds(target).unwrap().height, 32.0);
    win.click(target).unwrap();
    assert!(win.root().unwrap().selected);
    assert_eq!(win.role(Role::Button).count().unwrap(), 2);
    assert_eq!(
        win.click_at(Point { x: 10.0, y: 64.0 }),
        Err(Error::NotHittable)
    );
}

#[test]
fn wheel_obeys_painter_order_and_nested_viewports() {
    struct Overlay {
        blocks: bool,
    }
    impl ItemSource for Overlay {
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
            div().h(32).w(100).bg(Color::rgb(200, 200, 200))
        }
    }
    impl View for Overlay {
        fn view(&self) -> El<'_> {
            column((
                uniform_list(LIST, self, 32).h(64).w(100),
                self.blocks.then(|| {
                    div()
                        .size(40)
                        .bg(Color::BLACK)
                        .transform(Affine::translation(0.0, -64.0))
                }),
            ))
        }
    }
    let mut win = Win::with_size(Overlay { blocks: true }, 100, 100).unwrap();
    let list = win.list(LIST).unwrap();
    assert_eq!(
        win.scroll_at(Point { x: 10.0, y: 10.0 }, 32.0),
        Err(Error::NotHittable)
    );
    assert_eq!(win.list_state(list).unwrap().offset, 0.0);
    win.scroll_at(Point { x: 80.0, y: 10.0 }, 32.0).unwrap();
    assert_eq!(win.list_state(list).unwrap().offset, 32.0);
    win.update(|m| m.blocks = false).unwrap();
    // Ordinary unkeyed root survives this optional-child shape change, while
    // the list's own identity is retained by its explicit ID.
    let list = win.list(LIST).unwrap();
    win.scroll_at(Point { x: 10.0, y: 10.0 }, 32.0).unwrap();
    assert_eq!(win.list_state(list).unwrap().offset, 64.0);
}

#[test]
fn invalid_requests_leave_the_current_cohort_usable() {
    let mut win = Win::with_size(Rows::new(100), 240, 160).unwrap();
    let list = win.list(LIST).unwrap();
    let target = item(&win, 100);
    let snapshot = win.snapshot().unwrap();
    assert_eq!(
        win.scroll_to_key(list, ItemKey::new(999)),
        Err(Error::List(ListError::MissingKey(ItemKey::new(999))))
    );
    assert_eq!(
        win.scroll_to_index(list, 100),
        Err(Error::List(ListError::IndexOutOfRange))
    );
    assert_eq!(win.snapshot().unwrap(), snapshot);
    assert_eq!(win.list(LIST).unwrap(), list);
    win.click(target).unwrap();
}

#[test]
fn root_auto_width_and_flex_row_available_width_are_real_viewports() {
    struct FlexRows {
        nested: bool,
    }
    impl ItemSource for FlexRows {
        fn len(&self) -> usize {
            10
        }
        fn key(&self, index: usize) -> ItemKey {
            ItemKey::new(index as u64)
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            (key.get() < 10).then_some(key.get() as usize)
        }
        fn row(&self, _: usize) -> El<'_> {
            button("row").h(32).on_click(|_: &mut Self| {})
        }
    }
    impl View for FlexRows {
        fn view(&self) -> El<'_> {
            let list = uniform_list(LIST, self, 32).h(64);
            if self.nested {
                row((div().w(40).h(64), list)).w(200)
            } else {
                list
            }
        }
    }
    for nested in [false, true] {
        let win = Win::with_size(FlexRows { nested }, 200, 100).unwrap();
        let list = win.list(LIST).unwrap();
        let bounds = win.bounds(list).unwrap();
        near(bounds.width, if nested { 160.0 } else { 200.0 });
        near(bounds.x, if nested { 40.0 } else { 0.0 });
        assert_eq!(win.role(Role::Button).count().unwrap(), 2);
        assert!(win.list_item(list, ItemKey::new(0)).is_ok());
    }
}

#[test]
fn malformed_source_metrics_and_duplicate_list_ids_fail_admission() {
    struct Invalid {
        mode: u8,
    }
    impl ItemSource for Invalid {
        fn len(&self) -> usize {
            if self.mode == 5 { 1_000_000_001 } else { 10 }
        }
        fn key(&self, index: usize) -> ItemKey {
            ItemKey::new(if self.mode == 1 { 0 } else { index as u64 })
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            Some(if self.mode == 2 {
                999
            } else {
                key.get() as usize
            })
        }
        fn row(&self, _: usize) -> El<'_> {
            div().h(32)
        }
    }
    impl View for Invalid {
        fn view(&self) -> El<'_> {
            let height = if self.mode == 3 { 0.0 } else { 64.0 };
            let row_height = if self.mode == 4 { f64::NAN } else { 32.0 };
            let list = uniform_list(LIST, self, row_height).h(height);
            if self.mode == 6 {
                row((list, uniform_list(LIST, self, 32).h(64)))
            } else {
                list
            }
        }
    }
    for (mode, error) in [
        (1, ListError::DuplicateKey(ItemKey::new(0))),
        (2, ListError::InvalidIndex(ItemKey::new(0))),
        (3, ListError::InvalidMetrics),
        (4, ListError::InvalidMetrics),
        (5, ListError::ResourceLimit),
        (6, ListError::DuplicateList(LIST)),
    ] {
        assert_eq!(
            Win::with_size(Invalid { mode }, 200, 100).err(),
            Some(Error::List(error))
        );
    }
}

#[test]
fn window_clip_removes_authority_and_resize_return_mints_a_fresh_capability() {
    let mut win = Win::with_size(Rows::new(100), 240, 160).unwrap();
    let list = win.list(LIST).unwrap();
    let old = item(&win, 102);
    win.resize([240, 64]).unwrap();
    assert_eq!(
        win.list_item(list, ItemKey::new(102)),
        Err(Error::MissingElement)
    );
    assert_eq!(win.activate(old), Err(Error::StaleTarget));
    win.resize([240, 160]).unwrap();
    assert_ne!(item(&win, 102), old);
    assert_eq!(win.activate(old), Err(Error::StaleTarget));
}

#[test]
fn raster_clip_matches_finite_canvas_edges_and_keeps_off_lattice_pointer_hits() {
    struct Tiny {
        side: f32,
        selected: bool,
    }
    impl ItemSource for Tiny {
        fn len(&self) -> usize {
            2
        }
        fn key(&self, index: usize) -> ItemKey {
            ItemKey::new(index as u64)
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            (key.get() < 2).then_some(key.get() as usize)
        }
        fn row(&self, _: usize) -> El<'_> {
            button("tiny")
                .size(self.side)
                .bg(Color::BLACK)
                .on_click(|m: &mut Self| m.selected = true)
        }
    }
    impl View for Tiny {
        fn view(&self) -> El<'_> {
            uniform_list(LIST, self, self.side)
                .size(self.side)
                .transform(Affine::scale(0.1, 0.1))
        }
    }
    // Exact end .1f32 * 1.25 is just ABOVE sample .125; a nearest f32
    // geometric clip would lose it. Sample lowering must match ordinary paint.
    let mut tiny = Win::with_size(
        Tiny {
            side: 1.25,
            selected: false,
        },
        1,
        1,
    )
    .unwrap();
    struct Plain;
    impl View for Plain {
        fn view(&self) -> El<'_> {
            div()
                .size(1.25)
                .bg(Color::BLACK)
                .transform(Affine::scale(0.1, 0.1))
        }
    }
    let mut plain = Win::with_size(Plain, 1, 1).unwrap();
    plain
        .with_pixels(|pixels, _, _| {
            assert!(pixels[0] < 255);
            tiny.with_pixels(|actual, _, _| assert_eq!(pixels, actual))
                .unwrap();
        })
        .unwrap();
    // A non-lattice pointer may equal an inward-rounded endpoint even when
    // all raster samples agree. The broad envelope plus ancestor inverse
    // predicates must accept this actual interior point, and reject outside.
    let side = 1.2_f32;
    let edge = (f64::from(0.1_f32) * f64::from(side)) as f32;
    assert!(f64::from(edge) < f64::from(0.1_f32) * f64::from(side));
    let mut win = Win::with_size(
        Tiny {
            side,
            selected: false,
        },
        1,
        1,
    )
    .unwrap();
    win.click_at(Point { x: edge, y: 0.05 }).unwrap();
    assert!(win.root().unwrap().selected);
    assert_eq!(
        win.click_at(Point {
            x: edge.next_up(),
            y: 0.05
        }),
        Err(Error::NotHittable)
    );
}

#[test]
fn ordinary_fractional_device_scales_admit_list_and_row_clips() {
    for scale in [1.0, 1.25, 1.3, 1.5, 1.75, 2.0] {
        let win = Win::with_options_scaled(
            Rows::new(100),
            WindowOptions {
                size: [480, 320],
                ..Default::default()
            },
            scale,
        )
        .unwrap();
        assert_eq!(win.role(Role::Button).count().unwrap(), 3);
        assert_eq!(
            win.list_state(win.list(LIST).unwrap())
                .unwrap()
                .realized_rows,
            3
        );
    }
}

#[test]
fn reflected_half_open_viewport_matches_ordinary_paint() {
    struct Reflected;
    impl ItemSource for Reflected {
        fn len(&self) -> usize {
            1
        }
        fn key(&self, _: usize) -> ItemKey {
            ItemKey::new(0)
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            (key.get() == 0).then_some(0)
        }
        fn row(&self, _: usize) -> El<'_> {
            div().size(1).bg(Color::BLACK)
        }
    }
    let map = Affine {
        a: -1.0,
        b: 0.0,
        c: 0.0,
        d: 1.0,
        tx: 0.125,
        ty: 0.0,
    };
    struct Ordinary(Affine);
    impl View for Ordinary {
        fn view(&self) -> El<'_> {
            div().size(1).bg(Color::BLACK).transform(self.0)
        }
    }
    let mut ordinary = Win::with_size(Ordinary(map), 1, 1).unwrap();
    ordinary
        .with_pixels(|pixels, _, _| assert_eq!(pixels[0], 225))
        .unwrap();
    impl View for Reflected {
        fn view(&self) -> El<'_> {
            uniform_list(LIST, self, 1).size(1).transform(Affine {
                a: -1.0,
                b: 0.0,
                c: 0.0,
                d: 1.0,
                tx: 0.125,
                ty: 0.0,
            })
        }
    }
    let mut reflected = Win::with_size(Reflected, 1, 1).unwrap();
    reflected
        .with_pixels(|pixels, _, _| assert_eq!(pixels[0], 225))
        .unwrap();
}

#[test]
fn collapsed_forward_span_keeps_inverse_sample_semantics_and_point_authority() {
    struct Narrow {
        selected: bool,
    }
    impl ItemSource for Narrow {
        fn len(&self) -> usize {
            1
        }
        fn key(&self, _: usize) -> ItemKey {
            ItemKey::new(0)
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            (key.get() == 0).then_some(0)
        }
        fn row(&self, _: usize) -> El<'_> {
            div()
                .w(1e-20)
                .h(1)
                .bg(Color::BLACK)
                .on_click(|m: &mut Self| m.selected = true)
        }
    }
    impl View for Narrow {
        fn view(&self) -> El<'_> {
            uniform_list(LIST, self, 1).w(1e-20).h(1).transform(Affine {
                a: 1e-10,
                b: 0.0,
                c: 0.0,
                d: 1.0,
                tx: 0.125,
                ty: 0.0,
            })
        }
    }
    let mut win = Win::with_size(Narrow { selected: false }, 1, 1).unwrap();
    win.with_pixels(|pixels, _, _| assert_eq!(pixels[0], 225))
        .unwrap();
    assert_eq!(win.role(Role::ListItem).count().unwrap(), 1);
    let list = win.list(LIST).unwrap();
    assert!(win.list_item(list, ItemKey::new(0)).is_ok());
    win.click_at(Point { x: 0.125, y: 0.5 }).unwrap();
    assert!(win.root().unwrap().selected);
}

#[test]
fn parent_flow_updates_list_layout_like_a_cold_mount_including_property_overrides() {
    struct FlexSource {
        column: bool,
    }
    impl ItemSource for FlexSource {
        fn len(&self) -> usize {
            10
        }
        fn key(&self, index: usize) -> ItemKey {
            ItemKey::new(index as u64)
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            (key.get() < 10).then_some(key.get() as usize)
        }
        fn row(&self, _: usize) -> El<'_> {
            div().h(32).bg(Color::BLACK)
        }
    }
    impl View for FlexSource {
        fn view(&self) -> El<'_> {
            let children = (div().w(40).h(10), uniform_list(LIST, self, 32).h(64));
            (if self.column {
                column(children)
            } else {
                row(children)
            })
            .w(200)
            .h(100)
        }
    }
    let mut retained = Win::with_size(FlexSource { column: false }, 200, 100).unwrap();
    let list = retained.list(LIST).unwrap();
    retained.update(|m| m.column = true).unwrap();
    let cold = Win::with_size(FlexSource { column: true }, 200, 100).unwrap();
    let expected = cold.bounds(cold.list(LIST).unwrap()).unwrap();
    assert_eq!(retained.bounds(list).unwrap(), expected);
    near(expected.height, 64.0);
    let mut override_win = Win::with_size(FlexSource { column: false }, 200, 100).unwrap();
    let list = override_win.list(LIST).unwrap();
    let root = override_win.inspect().unwrap().nodes[0].target.unwrap();
    override_win
        .set_property(
            root,
            gpui::property::FLOW,
            gpui::property::Contribution::Set(Flow::Column),
        )
        .unwrap();
    assert_eq!(override_win.bounds(list).unwrap(), expected);
}

#[test]
fn zero_width_is_an_empty_viewport_and_flex_can_exhaust_available_width() {
    struct EmptyWidth {
        explicit: bool,
    }
    impl ItemSource for EmptyWidth {
        fn len(&self) -> usize {
            10
        }
        fn key(&self, index: usize) -> ItemKey {
            ItemKey::new(index as u64)
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            (key.get() < 10).then_some(key.get() as usize)
        }
        fn row(&self, _: usize) -> El<'_> {
            div().h(32).bg(Color::BLACK)
        }
    }
    impl View for EmptyWidth {
        fn view(&self) -> El<'_> {
            let list = uniform_list(LIST, self, 32).h(64);
            if self.explicit {
                list.w(0)
            } else {
                row((div().w(200), list)).w(200)
            }
        }
    }
    for explicit in [false, true] {
        let win = Win::with_size(EmptyWidth { explicit }, 200, 100).unwrap();
        assert_eq!(win.role(Role::ListItem).count().unwrap(), 0);
        assert_eq!(
            win.list_item(win.list(LIST).unwrap(), ItemKey::new(0)),
            Err(Error::MissingElement)
        );
    }
}

#[test]
fn wheel_rejects_the_physical_window_edge_even_with_an_outward_envelope() {
    struct Shift;
    impl ItemSource for Shift {
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
            div().h(32).bg(Color::BLACK)
        }
    }
    impl View for Shift {
        fn view(&self) -> El<'_> {
            uniform_list(LIST, self, 32)
                .w(100)
                .h(1)
                .transform(Affine::translation(0.0062, 0.0))
        }
    }
    let mut win = Win::with_size(Shift, 31, 16).unwrap();
    assert_eq!(
        win.scroll_at(Point { x: 31.0, y: 0.5 }, 1.0),
        Err(Error::NotHittable)
    );
    win.scroll_at(Point { x: 30.99, y: 0.5 }, 1.0).unwrap();
    assert_eq!(win.list_state(win.list(LIST).unwrap()).unwrap().offset, 1.0);
}

#[test]
fn zero_raster_samples_do_not_erase_a_continuous_pointer_action_ancestor() {
    struct TinyAncestor {
        selected: bool,
    }
    impl ItemSource for TinyAncestor {
        fn len(&self) -> usize {
            1
        }
        fn key(&self, _: usize) -> ItemKey {
            ItemKey::new(0)
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            (key.get() == 0).then_some(0)
        }
        fn row(&self, _: usize) -> El<'_> {
            div()
                .h(0)
                .on_click(|m: &mut Self| m.selected = true)
                .child(div().size(0.01).bg(Color::BLACK))
        }
    }
    impl View for TinyAncestor {
        fn view(&self) -> El<'_> {
            uniform_list(LIST, self, 1.0 / 64.0).size(0.01)
        }
    }
    let mut win = Win::with_size(TinyAncestor { selected: false }, 1, 1).unwrap();
    win.with_pixels(|pixels, _, _| assert_eq!(pixels, [255; 4]))
        .unwrap();
    assert_eq!(win.role(Role::ListItem).count().unwrap(), 1);
    win.click_at(Point { x: 0.005, y: 0.005 }).unwrap();
    assert!(win.root().unwrap().selected);
}

fn buffered(len: usize, overscan: usize) -> Rows {
    Rows {
        overscan,
        ..Rows::new(len)
    }
}
fn scroll_offset(win: &mut Win<Rows>, offset: f64) {
    let list = win.list(LIST).unwrap();
    let previous = win.list_state(list).unwrap().offset;
    win.scroll(list, offset - previous).unwrap();
}
fn image(win: &mut Win<Rows>) -> Vec<u8> {
    win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap()
}
#[test]
fn overscan_ranges_clamp_and_pixels_match_zero_buffer_at_fractional_offsets() {
    let mut win = Win::with_size(buffered(250_000, 2), 240, 160).unwrap();
    let list = win.list(LIST).unwrap();
    assert_eq!(win.list_state(list).unwrap().realized_range, 0..5);
    assert_eq!(win.root().unwrap().calls.load(Ordering::Relaxed), 5);
    for offset in [0., 16.25, 320., 6_400_000.125, 8_000_000.] {
        scroll_offset(&mut win, offset);
        let state = win.list_state(list).unwrap();
        assert_eq!(
            state.realized_range,
            state.visible_range.start.saturating_sub(2)
                ..state.visible_range.end.saturating_add(2).min(state.len)
        );
        assert_eq!(state.realized_rows, state.realized_range.len());
        let mut oracle = Win::with_size(Rows::new(250_000), 240, 160).unwrap();
        scroll_offset(&mut oracle, offset);
        assert_eq!(image(&mut win), image(&mut oracle));
        assert_eq!(
            win.role(Role::Button).count().unwrap(),
            state.visible_range.len()
        );
        for index in state.visible_range.clone() {
            let target = item(&win, index as u64 + 100);
            assert_eq!(
                win.bounds(target).unwrap(),
                oracle.bounds(item(&oracle, index as u64 + 100)).unwrap()
            );
        }
        if state.realized_range.start < state.visible_range.start {
            assert_eq!(
                win.list_item(list, ItemKey::new(state.realized_range.start as u64 + 100)),
                Err(Error::MissingElement)
            );
        }
    }
    for len in [0, 1, 2, 4096] {
        let win = Win::with_size(buffered(len, usize::MAX), 240, 160).unwrap();
        assert_eq!(
            win.list_state(win.list(LIST).unwrap())
                .unwrap()
                .realized_range,
            0..len
        );
        assert_eq!(win.root().unwrap().calls.load(Ordering::Relaxed), len);
    }
}
#[test]
fn overscan_preserves_buffered_identity_but_not_offscreen_authority_or_departed_keys() {
    let mut win = Win::with_size(buffered(100, 2), 240, 160).unwrap();
    let list = win.list(LIST).unwrap();
    let first = item(&win, 100);
    win.click(first).unwrap();
    assert_eq!(win.focused().unwrap(), Some(first));
    win.scroll_to_index(list, 1).unwrap();
    assert_eq!(
        win.list_item(list, ItemKey::new(100)),
        Err(Error::MissingElement)
    );
    assert_eq!(win.activate(first), Err(Error::StaleTarget));
    assert_eq!(win.focused().unwrap(), None);
    assert_eq!(
        win.click_at(Point { x: 10., y: 19.875 }),
        Err(Error::NotHittable)
    );
    win.scroll_to_index(list, 0).unwrap();
    assert_eq!(item(&win, 100), first);
    win.scroll_to_index(list, 3).unwrap();
    win.scroll_to_index(list, 0).unwrap();
    assert_ne!(item(&win, 100), first);
    assert_eq!(win.activate(first), Err(Error::StaleTarget));
}
#[test]
fn overscan_anchor_is_first_visible_key_across_prepend_and_reverse() {
    let mut win = Win::with_size(buffered(100, 2), 240, 160).unwrap();
    let list = win.list(LIST).unwrap();
    scroll_offset(&mut win, 320.25);
    let held = item(&win, 110);
    win.update(|m| {
        m.first -= 1;
        m.len += 1;
    })
    .unwrap();
    assert_eq!(win.list_state(list).unwrap().offset, 352.25);
    assert_eq!(item(&win, 110), held);
    win.update(|m| m.reverse = true).unwrap();
    assert_eq!(win.list_state(list).unwrap().offset, 89. * 32. + 0.25);
    assert_eq!(item(&win, 110), held);
}
#[test]
fn overscan_rejects_excess_before_rows_and_preserves_older_candidate_after_failure() {
    let mut win = Win::recording(
        buffered(100, 2),
        WindowOptions {
            size: [240, 160],
            ..Default::default()
        },
    )
    .unwrap();
    let initial = win.with_scene(|_, token| token).unwrap();
    win.presented(initial).unwrap();
    scroll_offset(&mut win, 320.);
    let candidate = win.with_scene(|_, token| token).unwrap();
    let old = image(&mut win);
    let calls = win.root().unwrap().calls.load(Ordering::Relaxed);
    assert_eq!(
        win.update(|m| {
            m.len = 4097;
            m.overscan = usize::MAX;
        })
        .err(),
        Some(Error::List(ListError::ResourceLimit))
    );
    assert_eq!(win.root().unwrap().calls.load(Ordering::Relaxed), calls);
    win.presented(candidate).unwrap();
    assert_eq!(image(&mut win), old);
    win.update(|m| {
        m.len = 100;
        m.overscan = 2;
    })
    .unwrap();
    let repaired = win.with_scene(|_, token| token).unwrap();
    win.presented(repaired).unwrap();
    let mut fresh = Win::with_size(buffered(100, 2), 240, 160).unwrap();
    scroll_offset(&mut fresh, 320.);
    assert_eq!(image(&mut win), image(&mut fresh));
}

#[test]
fn overscan_pixels_match_independently_materialized_eager_rows() {
    struct Eager(usize);
    impl View for Eager {
        fn view(&self) -> El<'_> {
            column((
                div().h(20).w(200).bg(Color::BLACK),
                column((self.0..self.0 + 3).map(|index| {
                    button(format!("item {}", index + 100))
                        .h(32)
                        .w(200)
                        .bg(Color::rgb(220, 230, 240))
                }))
                .h(96)
                .w(200),
                div().h(20).w(200).bg(Color::BLACK),
            ))
        }
    }
    let mut win = Win::with_size(buffered(100_000, 2), 240, 160).unwrap();
    for index in [0, 10, 99_997] {
        win.scroll_to_index(win.list(LIST).unwrap(), index).unwrap();
        let mut eager = Win::with_size(Eager(index), 240, 160).unwrap();
        let actual = image(&mut win);
        eager
            .with_pixels(|expected, _, _| assert_eq!(actual, expected))
            .unwrap();
    }
}

#[test]
fn overscan_checks_buffered_key_coherence_before_any_row_description() {
    struct Bad(bool);
    impl ItemSource for Bad {
        fn len(&self) -> usize {
            8
        }
        fn key(&self, index: usize) -> ItemKey {
            ItemKey::new(if self.0 && index == 3 {
                0
            } else {
                index as u64
            })
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            Some(if !self.0 && key.get() == 3 {
                999
            } else {
                key.get() as usize
            })
        }
        fn row(&self, _: usize) -> El<'_> {
            panic!("invalid key set must fail before descriptions")
        }
    }
    impl View for Bad {
        fn view(&self) -> El<'_> {
            // Exercise decorations both before and after the list-only builder.
            uniform_list(LIST, self, 32)
                .name("list")
                .rounded(0.)
                .overscan(2)
                .h(96)
                .w(200)
        }
    }
    for (bad, expected) in [
        (true, ListError::DuplicateKey(ItemKey::new(0))),
        (false, ListError::InvalidIndex(ItemKey::new(3))),
    ] {
        assert_eq!(
            Win::with_size(Bad(bad), 240, 160).err(),
            Some(Error::List(expected))
        );
    }
}
