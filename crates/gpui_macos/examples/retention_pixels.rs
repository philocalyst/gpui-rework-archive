//! Real Metal pixel oracle for retained GPUI rendering.
//!
//! Run on macOS with `cargo run -p gpui_ce_macos --example retention_pixels
//! --features test-support`. Each state is rendered incrementally, captured
//! from the GPU, then compared pixel-for-pixel with a full invalidation render
//! of that same state.

#[cfg(all(target_os = "macos", feature = "test-support"))]
mod macos {
    use gpui::{
        AppContext as _, Context, Entity, FocusHandle, InteractiveElement as _, IntoElement,
        ParentElement as _, Render, Styled as _, VisualTestAppContext, Window, deferred, div, px,
        rgb, rgba, white,
    };
    use gpui_ce_macos::MacPlatform;
    use image::RgbaImage;
    use std::{
        cell::{Cell, RefCell},
        rc::Rc,
    };

    #[derive(Default)]
    struct RenderCounts {
        root: Cell<usize>,
        left: Cell<usize>,
        right: Cell<usize>,
        filter: Cell<usize>,
        input: Cell<usize>,
        popup: Cell<usize>,
    }

    #[derive(Clone, Copy, Debug, Default)]
    struct CountSnapshot {
        root: usize,
        left: usize,
        right: usize,
        filter: usize,
        input: usize,
        popup: usize,
    }

    impl RenderCounts {
        fn snapshot(&self) -> CountSnapshot {
            CountSnapshot {
                root: self.root.get(),
                left: self.left.get(),
                right: self.right.get(),
                filter: self.filter.get(),
                input: self.input.get(),
                popup: self.popup.get(),
            }
        }
    }

    #[derive(Default)]
    struct SceneModel {
        left_text: String,
        right_text: String,
        input_text: String,
        left_x: f32,
        right_x: f32,
        left_first: bool,
        right_mounted: bool,
        show_filter: bool,
        show_popup: bool,
        popup_detail: String,
        accent: bool,
    }

    type SharedModel = Rc<RefCell<SceneModel>>;

    struct Panel {
        left: bool,
        model: SharedModel,
        counts: Rc<RenderCounts>,
    }

    impl Render for Panel {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            if self.left {
                self.counts.left.set(self.counts.left.get() + 1);
            } else {
                self.counts.right.set(self.counts.right.get() + 1);
            }

            let (background, title, copy) = {
                let model = self.model.borrow();
                if self.left {
                    (
                        if model.accent { 0x324b70 } else { 0x24354c },
                        "Retained text pane",
                        model.left_text.clone(),
                    )
                } else {
                    (
                        if model.accent { 0x5a3a57 } else { 0x403044 },
                        "Sibling pane stays clean",
                        model.right_text.clone(),
                    )
                }
            };

            div()
                .size_full()
                .overflow_hidden()
                .rounded(px(14.0))
                .border_1()
                .border_color(rgb(0x73849d))
                .bg(rgb(background))
                .p(px(20.0))
                .text_color(white())
                .text_size(px(18.0))
                .child(
                    div()
                        .text_size(px(23.0))
                        .font_weight(gpui::FontWeight::BOLD)
                        .child(title),
                )
                .child(div().mt(px(12.0)).child(copy))
                .child(
                    div()
                        .mt(px(12.0))
                        .child("An inline run: ")
                        .child(
                            div()
                                .inline()
                                .font_weight(gpui::FontWeight::BOLD)
                                .text_color(rgb(0xffcf76))
                                .child("café العربية אבג"),
                        )
                        .child(" wraps naturally through its parent paragraph."),
                )
        }
    }

    struct InputPane {
        model: SharedModel,
        counts: Rc<RenderCounts>,
        focus: FocusHandle,
    }

    impl Render for InputPane {
        fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
            self.counts.input.set(self.counts.input.get() + 1);
            let input = self.model.borrow().input_text.clone();
            div()
                .id("pixel-oracle-input")
                .track_focus(&self.focus)
                .on_key_down(cx.listener(|this, event: &gpui::KeyDownEvent, _, cx| {
                    if let Some(character) = &event.keystroke.key_char {
                        this.model.borrow_mut().input_text.push_str(character);
                        cx.notify();
                    }
                }))
                .w(px(490.0))
                .h(px(48.0))
                .rounded(px(8.0))
                .border_1()
                .border_color(rgb(0x8798ac))
                .bg(rgb(0x202a38))
                .px(px(14.0))
                .py(px(10.0))
                .text_color(white())
                .text_size(px(18.0))
                .child(format!("Focused input: {input}  |  type to update"))
        }
    }

    struct FilterGlass {
        model: SharedModel,
        counts: Rc<RenderCounts>,
    }

    impl Render for FilterGlass {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            self.counts.filter.set(self.counts.filter.get() + 1);
            if !self.model.borrow().show_filter {
                return div().w(px(0.0)).h(px(0.0));
            }

            div()
                .absolute()
                .left(px(370.0))
                .top(px(312.0))
                .w(px(470.0))
                .h(px(120.0))
                .rounded(px(18.0))
                .backdrop_blur(px(7.0))
                .bg(rgba(0x92c6ff66))
                .border_1()
                .border_color(rgba(0xd8eeffcc))
                .p(px(20.0))
                .text_color(white())
                .text_size(px(21.0))
                .child("Backdrop-filter glass samples both panes beneath it")
        }
    }

    struct NestedPopup {
        model: SharedModel,
        counts: Rc<RenderCounts>,
    }

    impl Render for NestedPopup {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            self.counts.popup.set(self.counts.popup.get() + 1);
            let (show_popup, detail) = {
                let model = self.model.borrow();
                (model.show_popup, model.popup_detail.clone())
            };
            if !show_popup {
                return div().w(px(0.0)).h(px(0.0));
            }

            div().child(deferred(
                div()
                    .absolute()
                    .left(px(800.0))
                    .top(px(365.0))
                    .w(px(320.0))
                    .h(px(172.0))
                    .rounded(px(14.0))
                    .border_1()
                    .border_color(rgb(0xffd38d))
                    .bg(rgb(0x5b472c))
                    .p(px(18.0))
                    .text_color(white())
                    .text_size(px(19.0))
                    .child("Deferred popup")
                    .child(deferred(
                        div()
                            .mt(px(18.0))
                            .rounded(px(8.0))
                            .bg(rgb(0x76592f))
                            .p(px(10.0))
                            .child(detail),
                    )),
            ))
        }
    }

    struct SceneRoot {
        model: SharedModel,
        counts: Rc<RenderCounts>,
        left: Entity<Panel>,
        right: Entity<Panel>,
        input: Entity<InputPane>,
        filter: Entity<FilterGlass>,
        popup: Entity<NestedPopup>,
    }

    impl Render for SceneRoot {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            self.counts.root.set(self.counts.root.get() + 1);
            let model = self.model.borrow();
            let mut root = div()
                .id("pixel-oracle-root")
                .relative()
                .size_full()
                .overflow_hidden()
                .bg(rgb(0x111821))
                .text_color(white())
                .text_size(px(17.0))
                .child(
                    div()
                        .absolute()
                        .left(px(44.0))
                        .top(px(30.0))
                        .text_size(px(27.0))
                        .font_weight(gpui::FontWeight::BOLD)
                        .child("GPUI retained-render pixel oracle"),
                )
                .child(
                    div()
                        .absolute()
                        .left(px(44.0))
                        .top(px(66.0))
                        .text_color(rgb(0xaab8c8))
                        .child("Real macOS fonts · nested entities · filters · deferred layers"),
                );

            let left_x = model.left_x;
            let right_x = model.right_x;
            let left_first = model.left_first;
            let right_mounted = model.right_mounted;
            let show_popup = model.show_popup;
            drop(model);

            let left = div()
                .absolute()
                .left(px(left_x))
                .top(px(112.0))
                .w(px(430.0))
                .h(px(258.0))
                .child(self.left.clone());
            let right = div()
                .absolute()
                .left(px(right_x))
                .top(px(112.0))
                .w(px(430.0))
                .h(px(258.0))
                .child(self.right.clone());

            if left_first {
                root = root.child(left);
                if right_mounted {
                    root = root.child(right);
                }
            } else {
                if right_mounted {
                    root = root.child(right);
                }
                root = root.child(left);
            }

            root = root
                .child(
                    div()
                        .absolute()
                        .left(px(44.0))
                        .top(px(610.0))
                        .child(self.input.clone()),
                )
                .child(self.filter.clone());

            if show_popup {
                root = root.child(self.popup.clone());
            }

            root
        }
    }

    struct SceneHandles {
        root: Entity<SceneRoot>,
        left: Entity<Panel>,
        right: Entity<Panel>,
        input: Entity<InputPane>,
        filter: Entity<FilterGlass>,
        popup: Entity<NestedPopup>,
    }

    fn draw_and_capture(cx: &mut VisualTestAppContext, window: gpui::AnyWindowHandle) -> RgbaImage {
        cx.update_window(window, |_, window, app| window.draw(app).clear(app))
            .expect("window draw failed");
        cx.capture_screenshot(window)
            .expect("GPU screenshot capture failed")
    }

    fn force_full_render(
        cx: &mut VisualTestAppContext,
        window: gpui::AnyWindowHandle,
    ) -> RgbaImage {
        // Rebuild the complete window frame from its current view state without
        // changing the entity invalidation set used for the incremental draw.
        cx.update_window(window, |_, window, app| {
            window.refresh();
            window.draw(app).clear(app);
        })
        .expect("full reference draw failed");
        cx.capture_screenshot(window)
            .expect("full reference GPU screenshot capture failed")
    }

    fn compare_exact(step: &str, incremental: &RgbaImage, full: &RgbaImage) {
        assert_eq!(
            incremental.dimensions(),
            full.dimensions(),
            "{step}: image size changed"
        );
        if incremental.as_raw() != full.as_raw() {
            let changed = incremental
                .pixels()
                .zip(full.pixels())
                .filter(|(a, b)| a != b)
                .count();
            if let Some(path) = std::env::var_os("GPUI_RETENTION_MISMATCH_IMAGE") {
                incremental
                    .save(path)
                    .expect("failed to save mismatch image");
            }
            panic!("{step}: incremental and full GPU pixels differ at {changed} pixels");
        }
    }

    fn changed_pixels(a: &RgbaImage, b: &RgbaImage) -> usize {
        assert_eq!(
            a.dimensions(),
            b.dimensions(),
            "pixel-change images differ in size"
        );
        a.pixels().zip(b.pixels()).filter(|(a, b)| a != b).count()
    }

    fn run_step(
        cx: &mut VisualTestAppContext,
        window: gpui::AnyWindowHandle,
        name: &str,
    ) -> RgbaImage {
        let incremental = draw_and_capture(cx, window);
        let full = force_full_render(cx, window);
        compare_exact(name, &incremental, &full);
        eprintln!("retention pixel oracle: {name}: exact GPU match");
        incremental
    }

    fn replay_clean_frames(
        cx: &mut VisualTestAppContext,
        window: gpui::AnyWindowHandle,
        handles: &SceneHandles,
        counts: &RenderCounts,
        previous: &RgbaImage,
        label: &str,
        count: usize,
    ) -> RgbaImage {
        let mut previous = previous.clone();
        for frame in 1..=count {
            let before = counts.snapshot();
            update_view(cx, &handles.root, |_, cx| cx.notify());
            let replay = draw_and_capture(cx, window);
            let after = counts.snapshot();
            assert!(
                after.root > before.root,
                "{label} root-only replay {frame} did not render the root: {before:?} -> {after:?}"
            );
            assert_eq!(
                (
                    after.left,
                    after.right,
                    after.filter,
                    after.input,
                    after.popup
                ),
                (
                    before.left,
                    before.right,
                    before.filter,
                    before.input,
                    before.popup
                ),
                "{label} root-only replay {frame} rendered a clean descendant: {before:?} -> {after:?}"
            );
            compare_exact(&format!("{label} clean replay {frame}"), &replay, &previous);
            eprintln!("retention pixel oracle: {label} clean replay {frame}: exact GPU match");
            previous = replay;
        }
        previous
    }

    fn update_view<T: 'static>(
        cx: &mut VisualTestAppContext,
        view: &Entity<T>,
        update: impl FnOnce(&mut T, &mut Context<T>),
    ) {
        cx.update(|app| view.update(app, update));
    }

    pub fn run() {
        let mut cx = VisualTestAppContext::new(Rc::new(MacPlatform::new(false)));
        let model = Rc::new(RefCell::new(SceneModel {
            left_text: "Wrapped copy flows across several lines in a retained paragraph. Resize the pane and move it: this long sentence should reflow against the narrower width without disturbing its sibling.".into(),
            right_text: "This independent entity includes a separate paragraph with punctuation, numerals 12345, and enough text to exercise native shaping and line wrapping.".into(),
            input_text: String::new(),
            left_x: 44.0,
            right_x: 530.0,
            left_first: true,
            right_mounted: true,
            show_filter: true,
            show_popup: false,
            popup_detail: "Nested deferred menu row".into(),
            accent: false,
        }));
        let counts = Rc::new(RenderCounts::default());

        let (left, right, input, filter, popup, root) = cx.update(|app| {
            let left = app.new(|_| Panel {
                left: true,
                model: model.clone(),
                counts: counts.clone(),
            });
            let right = app.new(|_| Panel {
                left: false,
                model: model.clone(),
                counts: counts.clone(),
            });
            let input = app.new(|cx| InputPane {
                model: model.clone(),
                counts: counts.clone(),
                focus: cx.focus_handle(),
            });
            let filter = app.new(|_| FilterGlass {
                model: model.clone(),
                counts: counts.clone(),
            });
            let popup = app.new(|_| NestedPopup {
                model: model.clone(),
                counts: counts.clone(),
            });
            let root = app.new(|_| SceneRoot {
                model: model.clone(),
                counts: counts.clone(),
                left: left.clone(),
                right: right.clone(),
                input: input.clone(),
                filter: filter.clone(),
                popup: popup.clone(),
            });
            (left, right, input, filter, popup, root)
        });
        let handles = SceneHandles {
            root: root.clone(),
            left,
            right,
            input,
            filter,
            popup,
        };

        let window = cx
            .open_offscreen_window_default(|_, _| root)
            .expect("failed to create offscreen Metal window");
        let window = window.into();
        let first = draw_and_capture(&mut cx, window);
        assert!(
            first.width() > 0 && first.height() > 0,
            "GPU returned an empty image"
        );
        let baseline = force_full_render(&mut cx, window);
        compare_exact("initial nested scene", &first, &baseline);
        eprintln!("retention pixel oracle: initial nested scene: exact GPU match");

        // A leaf update must repaint that entity while the other retained
        // entities remain untouched.
        let before = counts.snapshot();
        model.borrow_mut().left_text = "Changed only the left retained view. The wrapped paragraph now has different words and a different line ending.".into();
        update_view(&mut cx, &handles.left, |_, cx| cx.notify());
        let incremental = draw_and_capture(&mut cx, window);
        let after = counts.snapshot();
        assert!(
            after.left > before.left,
            "left leaf did not render after notification: {before:?} -> {after:?}"
        );
        assert_eq!(
            after.right, before.right,
            "clean right sibling rendered during left-only update: {before:?} -> {after:?}"
        );
        assert_eq!(
            after.filter, before.filter,
            "clean filter rendered during left-only update: {before:?} -> {after:?}"
        );
        assert_eq!(
            after.input, before.input,
            "clean input rendered during left-only update: {before:?} -> {after:?}"
        );
        assert!(
            changed_pixels(&first, &incremental) > 100,
            "left text update changed too few GPU pixels"
        );
        let full = force_full_render(&mut cx, window);
        compare_exact(
            "left leaf update preserves clean siblings",
            &incremental,
            &full,
        );
        eprintln!(
            "retention pixel oracle: left leaf update preserves clean siblings: exact GPU match"
        );

        model.borrow_mut().right_text = "The right sibling is now independently dirty; native Parley shaping keeps this Latin, 日本語, and emoji line coherent.".into();
        update_view(&mut cx, &handles.right, |_, cx| cx.notify());
        run_step(&mut cx, window, "right sibling text update");

        // Exercise real focus tracking and keyboard dispatch, not a synthetic
        // text assignment to the view.
        let focus = cx.read(|app| handles.input.read(app).focus.clone());
        cx.update_window(window, |_, window, app| window.focus(&focus, app))
            .expect("failed to focus input view");
        cx.simulate_input(window, "pixel");
        run_step(&mut cx, window, "focused keyboard input");

        model.borrow_mut().show_filter = false;
        model.borrow_mut().accent = true;
        update_view(&mut cx, &handles.filter, |_, cx| cx.notify());
        update_view(&mut cx, &handles.left, |_, cx| cx.notify());
        update_view(&mut cx, &handles.right, |_, cx| cx.notify());
        run_step(&mut cx, window, "filter removal and color update");

        // Relocate and reorder the independent panes, then change the actual
        // viewport size so retained layout and clipping are both exercised.
        {
            let mut model = model.borrow_mut();
            model.left_x = 62.0;
            model.right_x = 548.0;
            model.left_first = false;
            model.show_filter = true;
            model.show_popup = true;
        }
        update_view(&mut cx, &handles.root, |_, cx| cx.notify());
        update_view(&mut cx, &handles.filter, |_, cx| cx.notify());
        update_view(&mut cx, &handles.popup, |_, cx| cx.notify());
        cx.update_window(window, |_, window, _| {
            window.resize(gpui::size(px(1120.0), px(720.0)))
        })
        .expect("failed to resize oracle window");
        let nested_popup_frame = run_step(
            &mut cx,
            window,
            "move reorder resize and nested deferred popup",
        );

        let nested_popup_frame = replay_clean_frames(
            &mut cx,
            window,
            &handles,
            &counts,
            &nested_popup_frame,
            "nested popup baseline",
            3,
        );

        // Shrink a sibling's text primitives, replay several root-only frames
        // so old nested ranges are compacted, then dirty the nested deferred
        // popup to exercise replay of the surviving ranges.
        model.borrow_mut().right_text = "Tiny.".into();
        let before_shrink = counts.snapshot();
        update_view(&mut cx, &handles.right, |_, cx| cx.notify());
        let shrunk_sibling = draw_and_capture(&mut cx, window);
        let after_shrink = counts.snapshot();
        assert!(
            after_shrink.right > before_shrink.right,
            "sibling text shrink did not render the right pane: {before_shrink:?} -> {after_shrink:?}"
        );
        assert_eq!(
            (
                after_shrink.left,
                after_shrink.filter,
                after_shrink.input,
                after_shrink.popup
            ),
            (
                before_shrink.left,
                before_shrink.filter,
                before_shrink.input,
                before_shrink.popup
            ),
            "sibling text shrink rendered an unrelated retained view: {before_shrink:?} -> {after_shrink:?}"
        );
        assert!(
            changed_pixels(&nested_popup_frame, &shrunk_sibling) > 20,
            "sibling text shrink changed too few GPU pixels"
        );
        eprintln!("retention pixel oracle: sibling text shrink: captured incremental GPU frame");

        let nested_popup_frame = replay_clean_frames(
            &mut cx,
            window,
            &handles,
            &counts,
            &shrunk_sibling,
            "after sibling text shrink",
            3,
        );

        model.borrow_mut().popup_detail =
            "Nested deferred row changed after compacted replays".into();
        let before_popup = counts.snapshot();
        update_view(&mut cx, &handles.popup, |_, cx| cx.notify());
        let nested_update = draw_and_capture(&mut cx, window);
        let after_popup = counts.snapshot();
        assert!(
            after_popup.popup > before_popup.popup,
            "nested deferred popup did not render after its notification: {before_popup:?} -> {after_popup:?}"
        );
        assert!(
            changed_pixels(&nested_popup_frame, &nested_update) > 20,
            "nested deferred update changed too few GPU pixels"
        );
        let full = force_full_render(&mut cx, window);
        compare_exact(
            "nested deferred dirty update after sibling shrink",
            &nested_update,
            &full,
        );
        eprintln!(
            "retention pixel oracle: nested deferred dirty update after sibling shrink: exact GPU match"
        );

        model.borrow_mut().right_mounted = false;
        model.borrow_mut().show_popup = false;
        update_view(&mut cx, &handles.root, |_, cx| cx.notify());
        run_step(&mut cx, window, "unmount right pane and popup");
        eprintln!("retention pixel oracle: all real-Metal scenarios passed");
    }
}

#[cfg(all(target_os = "macos", feature = "test-support"))]
fn main() {
    macos::run();
}

#[cfg(not(all(target_os = "macos", feature = "test-support")))]
fn main() {
    eprintln!("retention_pixels requires macOS and --features test-support");
}
