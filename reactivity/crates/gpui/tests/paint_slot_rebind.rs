use gpui::{WindowOptions, prelude::*, property::BACKGROUND};

struct Panel(Signal<Color>);
impl Panel {
    const COLOR: Source<Self, Color> = Source::new(
        FieldId::new(1),
        "color",
        |model| &model.0,
        |model| &mut model.0,
    );
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        div().name("panel").size(16).bg(&self.0)
    }
}
fn pixels(win: &mut Win<Panel>) -> Vec<u8> {
    win.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap()
}
fn acknowledge(win: &mut Win<Panel>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}

#[test]
fn equal_coarse_description_rebinds_the_complete_canvas_before_exact_color_edits() {
    let expected = pixels(&mut Win::with_size(Panel(Signal::new(Color::WHITE)), 16, 16).unwrap());
    for mode in 0..4 {
        let mut win = if mode == 0 {
            Win::with_size(Panel(Signal::new(Color::BLACK)), 16, 16).unwrap()
        } else {
            Win::recording(
                Panel(Signal::new(Color::BLACK)),
                WindowOptions {
                    size: [16, 16],
                    ..Default::default()
                },
            )
            .unwrap()
        };
        if mode == 1 || mode == 3 {
            acknowledge(&mut win);
        }
        if mode == 3 {
            win.set(Panel::COLOR, rgb(0xff0000)).unwrap();
        }
        let acknowledged_before = win.snapshot().unwrap();
        let old_token = win.with_scene(|_, token| token).unwrap();
        win.reset_counters().unwrap();
        win.update(|_| {}).unwrap();
        // Replacing the logical bank deliberately rebuilds its Canvas binding,
        // even when every effective style is equal. This is a charged full walk.
        assert_eq!(win.counters().paint_passes, 1, "mode {mode}");
        assert_ne!(win.with_scene(|_, token| token).unwrap(), old_token);
        win.reset_counters().unwrap();
        let commit = win.set(Panel::COLOR, Color::WHITE).unwrap();
        assert_eq!(commit.source_epoch, if mode == 3 { 3 } else { 2 });
        assert_eq!(win.counters().source_reads, 1);
        assert_eq!(win.counters().paint_passes, 0);
        assert_eq!(pixels(&mut win), expected, "mode {mode}");
        if mode != 0 {
            let before_ack = win.snapshot().unwrap();
            assert_eq!(
                before_ack.presentation_epoch,
                acknowledged_before.presentation_epoch
            );
            assert_eq!(before_ack.nodes, acknowledged_before.nodes);
            acknowledge(&mut win);
        }
        let target = win.query().name("panel").one().unwrap();
        assert!(
            win.property(target, BACKGROUND)
                .unwrap()
                .same_authoring(Color::WHITE)
        );
        assert_eq!(
            win.snapshot().unwrap().presentation_epoch,
            commit.source_epoch
        );
    }
}
