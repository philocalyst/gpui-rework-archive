//! Selection and source repair use the ordinary exclusive production owner.
use gpui::{
    Action, CaretAffinity as A, Error, Key, TextOffset, TextPosition, TextSelection, WindowOptions,
    prelude::*,
};

fn position(byte: usize) -> TextPosition {
    TextPosition {
        offset: TextOffset::new(byte).unwrap(),
        affinity: A::Downstream,
    }
}
fn range(anchor: usize, focus: usize) -> TextSelection {
    TextSelection {
        anchor: position(anchor),
        focus: position(focus),
    }
}

struct Page {
    value: Signal<String>,
    other: Signal<String>,
    swap: bool,
    show: bool,
    count: u32,
}
impl Page {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    const OTHER: Source<Self, String> =
        Source::new(FieldId::new(2), "other", |m| &m.other, |m| &mut m.other);
    fn new(text: &str) -> Self {
        Self {
            value: Signal::new(text.into()),
            other: Signal::new(text.into()),
            swap: false,
            show: true,
            count: 0,
        }
    }
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE).direct(Self::OTHER)
    }
    fn view(&self) -> El<'_> {
        column((
            self.show.then(|| {
                text_input(if self.swap { &self.other } else { &self.value })
                    .w(180)
                    .h(60)
            }),
            text(format!("{}", self.count)),
        ))
    }
}

#[test]
fn ordinary_replace_typing_keyboard_and_accessibility_share_selection_aware_source_edits() {
    let mut explicit = Win::demo(Page::new("Café office"));
    let mut typed = Win::demo(Page::new("Café office"));
    let mut keyboard = Win::demo(Page::new("Café office"));
    explicit
        .replace(explicit.input(), range(6, 12), "אבג")
        .unwrap();
    typed.select(typed.input(), range(12, 6)).unwrap();
    typed.type_text(typed.input(), "אבג").unwrap();
    keyboard.focus(keyboard.input()).unwrap();
    keyboard.select(keyboard.input(), range(6, 12)).unwrap();
    keyboard.key(Key::Text("אבג")).unwrap();
    for win in [&explicit, &typed, &keyboard] {
        assert_eq!(win.root().unwrap().value.as_str(), "Café אבג");
        assert_eq!(win.selection(win.input()).unwrap(), range(12, 12));
    }
    explicit
        .perform(explicit.input(), Action::SetValue("e\u{301} whole"))
        .unwrap();
    assert_eq!(explicit.root().unwrap().value.as_str(), "e\u{301} whole");
    assert_eq!(explicit.selection(explicit.input()).unwrap(), range(9, 9));
    explicit.backspace(explicit.input()).unwrap();
    assert_eq!(explicit.root().unwrap().value.as_str(), "e\u{301} whol");
}

#[test]
fn grapheme_backspace_and_joined_carets_repair_even_a_failed_visual_source() {
    let mut win = Win::demo(Page::new(""));
    let input = win.input();
    win.type_text(input, "a\u{301}").unwrap();
    win.backspace(input).unwrap();
    assert_eq!(win.root().unwrap().value.as_str(), "");
    assert_eq!(win.selection(input).unwrap(), range(0, 0));

    win.type_text(input, "a\r\n").unwrap();
    win.backspace(input).unwrap();
    assert_eq!(win.root().unwrap().value.as_str(), "a");

    // The unsupported emoji can fail painting; its entire ZWJ grapheme is
    // still one logical backspace and cannot strand a joiner or scalar tail.
    assert!(matches!(
        win.type_text(input, "👩\u{200d}💻"),
        Err(Error::Canvas(_))
    ));
    let joined_end = win.root().unwrap().value.len();
    assert_eq!(win.selection(input).unwrap(), range(joined_end, joined_end));
    win.backspace(input).unwrap();
    assert_eq!(win.root().unwrap().value.as_str(), "a");

    // A Control prevents the preceding base and following degenerate mark from
    // clustering. Deleting it joins both sides and snaps after the whole result.
    assert!(matches!(
        win.perform(input, Action::SetValue("a\u{1}\u{301}")),
        Err(Error::Canvas(_))
    ));
    win.replace(input, range(1, 2), "").unwrap();
    assert_eq!(win.root().unwrap().value.as_str(), "a\u{301}");
    assert_eq!(win.selection(input).unwrap(), range(3, 3));
    win.replace(input, range(0, 3), "\u{301}").unwrap();
    win.replace(input, range(0, 0), "e").unwrap();
    assert_eq!(win.root().unwrap().value.as_str(), "e\u{301}");
    assert_eq!(win.selection(input).unwrap(), range(3, 3));
}

#[test]
fn equal_output_replacement_still_collapses_caret_before_publication() {
    let mut win = Win::demo(Page::new("abc"));
    let input = win.input();
    win.select(input, range(0, 2)).unwrap();
    win.reset_counters().unwrap();
    win.type_text(input, "ab").unwrap();
    assert_eq!(win.root().unwrap().value.as_str(), "abc");
    assert_eq!(win.selection(input).unwrap(), range(2, 2));
    assert_eq!(win.counters().text_promotions, 0);
    assert_eq!(win.counters().source_operations, 1);
}

#[test]
fn stored_selection_is_source_qualified_but_explicit_ranges_address_current_source() {
    let mut win = Win::demo(Page::new("abcdef"));
    let input = win.input();
    win.select(input, range(1, 3)).unwrap();
    win.update(|page| page.count += 1).unwrap();
    assert_eq!(win.selection(input).unwrap(), range(1, 3));
    win.set(Page::VALUE, "UVWXYZ".to_owned()).unwrap();
    assert_eq!(win.selection(input).unwrap(), range(6, 6));
    win.replace(input, range(1, 3), "!").unwrap();
    assert_eq!(win.root().unwrap().value.as_str(), "U!XYZ");
    win.select(input, range(1, 2)).unwrap();
    win.update(|page| page.swap = true).unwrap();
    assert_eq!(
        win.input(),
        input,
        "same node, different admitted source field"
    );
    assert_eq!(win.selection(input).unwrap(), range(6, 6));
    win.update(|page| page.show = false).unwrap();
    assert_eq!(win.selection(input), Err(Error::StaleTarget));
}

#[test]
fn invalid_grapheme_crlf_and_foreign_ranges_are_atomic() {
    let mut win = Win::demo(Page::new("e\u{301}\r\nx"));
    let input = win.input();
    win.select(input, range(0, 3)).unwrap();
    let before = win.snapshot().unwrap();
    let digest = win.scene_digest().unwrap();
    for selected in [range(1, 3), range(0, 4), range(0, 20)] {
        assert_eq!(win.select(input, selected), Err(Error::InvalidSelection));
        assert_eq!(
            win.replace(input, selected, "bad"),
            Err(Error::InvalidSelection)
        );
    }
    let foreign = Win::demo(Page::new("foreign")).input();
    assert_eq!(win.select(foreign, range(0, 0)), Err(Error::StaleTarget));
    assert_eq!(win.snapshot().unwrap(), before);
    assert_eq!(win.scene_digest().unwrap(), digest);
    assert_eq!(win.selection(input).unwrap(), range(0, 3));
}

#[test]
fn logical_selection_survives_pending_and_failed_p_without_rewriting_old_sheet() {
    let mut win = Win::recording(Page::new("ab"), WindowOptions::default()).unwrap();
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    let input = win.input();
    let old = win.snapshot().unwrap();
    win.select(input, range(1, 2)).unwrap();
    assert!(matches!(win.type_text(input, "漢"), Err(Error::Canvas(_))));
    assert_eq!(win.root().unwrap().value.as_str(), "a漢");
    assert_eq!(win.selection(input).unwrap(), range(4, 4));
    assert_eq!(win.snapshot().unwrap().nodes, old.nodes);
    assert_eq!(win.key(Key::Tab), Err(Error::PresentationStale));
    win.backspace(input).unwrap();
    assert_eq!(win.root().unwrap().value.as_str(), "a");
    assert_eq!(win.selection(input).unwrap(), range(1, 1));
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    assert!(win.contains_text("a").unwrap());
}

#[test]
fn visual_arrows_extend_whole_graphemes_and_collapse_bidi_endpoints() {
    let mut win = Win::demo(Page::new("e\u{301} אבג"));
    let input = win.input();
    win.focus(input).unwrap();
    win.select(input, range(0, 0)).unwrap();
    win.key(Key::Right { extend: true }).unwrap();
    let mut extended = range(0, 3);
    extended.focus.affinity = A::Upstream;
    assert_eq!(win.selection(input).unwrap(), extended);
    win.key(Key::Right { extend: false }).unwrap();
    assert_eq!(
        win.selection(input).unwrap(),
        TextSelection {
            anchor: extended.focus,
            focus: extended.focus
        }
    );
    win.key(Key::Left { extend: false }).unwrap();
    assert_eq!(win.selection(input).unwrap(), range(0, 0));

    // GPUI collapses a range to its physical endpoint in the arrow direction.
    // Within the Hebrew run logical byte order and physical order are reversed.
    win.select(input, range(6, 8)).unwrap();
    win.key(Key::Left { extend: false }).unwrap();
    assert_eq!(win.selection(input).unwrap(), range(8, 8));
    win.select(input, range(8, 6)).unwrap();
    win.key(Key::Right { extend: false }).unwrap();
    assert_eq!(win.selection(input).unwrap(), range(6, 6));
}

#[test]
fn selection_and_focus_publish_pixels_without_changing_source_text() {
    let mut win = Win::with_size(Page::new("office"), 200, 90).unwrap();
    let input = win.input();
    let pixels = |win: &mut Win<Page>| win.with_pixels(|p, _, _| p.to_vec()).unwrap();
    let plain = pixels(&mut win);
    win.select(input, range(1, 4)).unwrap();
    let selected = pixels(&mut win);
    assert_ne!(
        selected, plain,
        "selection background must reach raster output"
    );
    win.select(input, range(2, 2)).unwrap();
    assert_eq!(
        pixels(&mut win),
        plain,
        "unfocused collapsed caret is hidden"
    );
    win.focus(input).unwrap();
    let caret = pixels(&mut win);
    assert_ne!(caret, plain, "focused caret must reach raster output");
    win.clear_focus().unwrap();
    assert_eq!(pixels(&mut win), plain);
    win.focus(input).unwrap();
    assert_eq!(pixels(&mut win), caret);
    assert_eq!(win.root().unwrap().value.as_str(), "office");
}

#[test]
fn pointer_drag_uses_current_map_outside_input_and_revokes_on_source_change() {
    let mut win = Win::with_size(Page::new("e\u{301} office"), 240, 100).unwrap();
    let input = win.input();
    let mut pointer = PointerSession::default();
    win.pointer_event(&mut pointer, PointerEvent::Move(Point { x: 0., y: 8. }))
        .unwrap();
    win.pointer_event(&mut pointer, PointerEvent::Press)
        .unwrap();
    assert_eq!(win.focused().unwrap(), Some(input));
    assert_eq!(win.selection(input).unwrap(), range(0, 0));
    win.pointer_event(&mut pointer, PointerEvent::Move(Point { x: 230., y: 8. }))
        .unwrap();
    assert_eq!(win.selection(input).unwrap().focus.offset.byte(), 10);
    assert_eq!(win.selection(input).unwrap().anchor.offset.byte(), 0);
    win.key(Key::Text("replaced")).unwrap();
    assert_eq!(win.root().unwrap().value.as_str(), "replaced");
    // A separately admitted source cannot inherit this gesture's old anchor.
    win.set(Page::VALUE, "new".to_owned()).unwrap();
    assert_eq!(
        win.pointer_event(&mut pointer, PointerEvent::Move(Point { x: 20., y: 8. })),
        Err(Error::StaleTarget)
    );
    assert_eq!(win.selection(input).unwrap(), range(3, 3));
    win.pointer_event(&mut pointer, PointerEvent::Move(Point { x: 0., y: 8. }))
        .unwrap();
    assert_eq!(win.selection(input).unwrap(), range(3, 3));
}

#[test]
fn geometry_navigation_waits_for_ack_but_logical_range_edits_do_not() {
    let mut win = Win::recording(Page::new("abc"), WindowOptions::default()).unwrap();
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    let input = win.input();
    win.focus(input).unwrap();
    win.select(input, range(1, 2)).unwrap();
    let selection = win.selection(input).unwrap();
    assert_eq!(
        win.key(Key::Right { extend: true }),
        Err(Error::PresentationStale)
    );
    assert_eq!(win.selection(input).unwrap(), selection);
    win.type_text(input, "X").unwrap();
    assert_eq!(win.root().unwrap().value.as_str(), "aXc");
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    win.key(Key::Right { extend: true }).unwrap();
    let mut extended = range(2, 3);
    extended.focus.affinity = A::Upstream;
    assert_eq!(win.selection(input).unwrap(), extended);
}

#[test]
fn transformed_padded_input_hits_and_shared_caret_ink_follow_the_real_paint_bank() {
    struct Ink {
        text: Signal<String>,
        color: Signal<Color>,
    }
    impl Ink {
        const COLOR: Source<Self, Color> =
            Source::new(FieldId::new(2), "ink", |m| &m.color, |m| &mut m.color);
        fn new(color: Color) -> Self {
            Self {
                text: Signal::new("office".into()),
                color: Signal::new(color),
            }
        }
    }
    impl View for Ink {
        fn sources() -> Sources<Self> {
            Sources::new()
                .direct(Source::new(
                    FieldId::new(1),
                    "text",
                    |m: &Self| &m.text,
                    |m| &mut m.text,
                ))
                .direct(Self::COLOR)
        }
        fn view(&self) -> El<'_> {
            div().p(5).child(
                text_input(&self.text)
                    .w(140)
                    .h(40)
                    .p(8)
                    .fg(&self.color)
                    .transform(Affine::translation(11., 7.)),
            )
        }
    }
    let mut win = Win::with_size(Ink::new(Color::BLACK), 200, 80).unwrap();
    let input = win.input();
    let bounds = win
        .snapshot()
        .unwrap()
        .nodes
        .into_iter()
        .find(|node| node.target == Some(input))
        .unwrap()
        .rect();
    win.click_at(Point {
        x: bounds.x + 1.,
        y: bounds.y + bounds.height * 0.5,
    })
    .unwrap();
    assert_eq!(win.selection(input).unwrap().focus.offset.byte(), 0);
    win.click_at(Point {
        x: bounds.x + bounds.width - 1.,
        y: bounds.y + bounds.height * 0.5,
    })
    .unwrap();
    assert_eq!(win.selection(input).unwrap().focus.offset.byte(), 6);
    win.reset_counters().unwrap();
    let red = Color::rgb(220, 20, 30);
    win.set(Ink::COLOR, red).unwrap();
    assert_eq!(win.counters().paint_passes, 0);
    assert_eq!(win.counters().layout_runs, 0);
    let mut oracle = Win::with_size(Ink::new(red), 200, 80).unwrap();
    oracle
        .select(oracle.input(), win.selection(input).unwrap())
        .unwrap();
    oracle.focus(oracle.input()).unwrap();
    assert_eq!(
        win.with_pixels(|p, _, _| p.to_vec()).unwrap(),
        oracle.with_pixels(|p, _, _| p.to_vec()).unwrap()
    );
}
