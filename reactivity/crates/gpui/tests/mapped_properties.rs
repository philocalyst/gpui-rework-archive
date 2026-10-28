//! Public admission, coherence and presentation laws for one mapped source.
use gpui::{
    Error, LaneSet, Questions, Reader, SetError, StartError, WindowOptions,
    prelude::*,
    property::{BACKGROUND, Contribution, PropertyErrorKind, TRANSFORM, WIDTH},
};
use std::sync::mpsc;

#[derive(Clone, Copy)]
struct Frame {
    transform: Affine,
    count: u64,
}
fn frame(count: u64) -> Frame {
    Frame {
        transform: Affine::translation(count as f32, 0.0),
        count,
    }
}
fn bit(frame: &Frame, index: u32) -> Color {
    if frame.count & (1 << index) != 0 {
        Color::WHITE
    } else {
        Color::BLACK
    }
}
struct Panel {
    frame: Signal<Frame>,
    peer: Signal<Frame>,
    use_peer: bool,
    invert: bool,
    rows: usize,
    answer: Option<Reader<u64>>,
}
impl Panel {
    const FRAME: Source<Self, Frame> =
        Source::new(FieldId::new(1), "frame", |m| &m.frame, |m| &mut m.frame);
    const PEER: Source<Self, Frame> =
        Source::new(FieldId::new(2), "peer", |m| &m.peer, |m| &mut m.peer);
    fn new() -> Self {
        Self {
            frame: Signal::new(frame(0)),
            peer: Signal::new(frame(10)),
            use_peer: false,
            invert: false,
            rows: 1000,
            answer: None,
        }
    }
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::FRAME).direct(Self::PEER)
    }
    fn view(&self) -> El<'_> {
        let source = if self.use_peer {
            &self.peer
        } else {
            &self.frame
        };
        let mut root = column((
            div()
                .name("moving")
                .size(8)
                .transform(source.map(|frame| frame.transform))
                .on_click(|_: &mut Self| {}),
            row((0..32).map(|index| {
                div().size(2).bg(
                    source.map_with((index, self.invert), |frame, (index, invert)| {
                        let color = bit(frame, index);
                        if invert {
                            if color == Color::WHITE {
                                Color::BLACK
                            } else {
                                Color::WHITE
                            }
                        } else {
                            color
                        }
                    }),
                )
            })),
            column((0..self.rows).map(|index| div().name(format!("row-{index}")).size(1))),
        ));
        if let Some(answer) = self.answer {
            root = root.child(
                answer
                    .project(|value| text(format!("answer-{value}")))
                    .loading(|| text("pending")),
            );
        }
        root
    }
}
fn ack<M: View + 'static, L: LaneSet<M>>(win: &mut Win<M, L>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn colors<L: LaneSet<Panel>>(win: &Win<Panel, L>) -> Vec<Color> {
    win.inspect()
        .unwrap()
        .nodes
        .iter()
        .skip(3)
        .take(32)
        .map(|node| {
            win.property(node.target.unwrap(), BACKGROUND)
                .unwrap()
                .solid()
                .unwrap()
        })
        .collect()
}

#[test]
fn one_exact_inbox_updates_transform_and_32_colors_without_describing_1000_rows() {
    let (remote, inbox) = Remote::bounded(1);
    let mut win = Win::with_size(Panel::new(), 320, 180)
        .unwrap()
        .with_inbox_for(inbox, Panel::FRAME, |value, next: Frame| *value = next)
        .unwrap();
    let rows = (0..1000)
        .map(|index| win.query().name(&format!("row-{index}")).one().unwrap())
        .collect::<Vec<_>>();
    let moving = win.query().name("moving").one().unwrap();
    let revision = win.root().unwrap().frame.revision();
    win.reset_counters().unwrap();
    let next = frame(0xa55a_f00f);
    // Keep geometry in the viewport while retaining all thirty-two payload bits.
    let next = Frame {
        transform: Affine::translation(9.0, 0.0),
        ..next
    };
    remote.try_send(next).unwrap();
    assert_eq!(win.deliver_ready(1).unwrap().applied, 1);
    assert_ne!(win.root().unwrap().frame.revision(), revision);
    assert_eq!(win.property(moving, TRANSFORM).unwrap(), next.transform);
    assert_eq!(
        colors(&win),
        (0..32).map(|index| bit(&next, index)).collect::<Vec<_>>()
    );
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().descriptions, 0);
    assert_eq!(win.counters().source_reads, 1);
    assert_eq!(win.counters().destination_compares, 33);
    for (index, target) in rows.into_iter().enumerate() {
        assert_eq!(
            win.query().name(&format!("row-{index}")).one().unwrap(),
            target
        );
    }
}

#[test]
fn mapped_geometry_queries_wait_for_ack_and_invalid_output_preserves_all_sinks() {
    let mut win = Win::recording(
        Panel::new(),
        WindowOptions {
            size: [320, 180],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let target = win.query().name("moving").one().unwrap();
    let before = win.bounds(target).unwrap();
    assert_eq!(
        win.hit_target(Point { x: 1.0, y: 1.0 }).unwrap(),
        Some(target)
    );
    win.set(Panel::FRAME, frame(7)).unwrap();
    assert_eq!(win.bounds(target).unwrap(), before);
    assert_eq!(
        win.hit_target(Point { x: 1.0, y: 1.0 }),
        Err(Error::PresentationStale)
    );
    assert_eq!(win.property(target, TRANSFORM).unwrap(), frame(7).transform);
    let pending = win.with_scene(|_, token| token).unwrap();
    let complete_scene = win.scene_digest().unwrap();
    let mut complete_snapshot = win.snapshot().unwrap();
    for node in &mut complete_snapshot.nodes {
        node.target = None;
    }
    let invalid = Frame {
        transform: Affine {
            tx: f32::NAN,
            ..Affine::IDENTITY
        },
        count: u32::MAX as u64,
    };
    assert!(
        matches!(win.set(Panel::FRAME, invalid), Err(SetError::Committed { error: Error::Property(error), .. })
        if error.property == TRANSFORM.id() && error.reason == PropertyErrorKind::NonFinite)
    );
    assert_eq!(win.property(target, TRANSFORM), Err(Error::StaleTarget));
    assert_eq!(win.scene_digest().unwrap(), complete_scene);
    assert!(
        win.snapshot().unwrap().nodes == complete_snapshot.nodes,
        "failed publication preserves acknowledged geometry and removes logical targets"
    );
    assert_eq!(win.bounds(target).unwrap(), before);
    assert_eq!(win.with_scene(|_, token| token).unwrap(), pending);
    win.presented(pending).unwrap();
    assert!((win.bounds(target).unwrap().x - before.x - 7.0).abs() < 0.001);
    assert_eq!(
        win.hit_target(Point { x: 1.0, y: 1.0 }),
        Err(Error::PresentationStale)
    );
    win.set(Panel::FRAME, frame(8)).unwrap();
    ack(&mut win);
    let repaired = win.query().name("moving").one().unwrap();
    assert_ne!(
        repaired, target,
        "failed logical publication revokes old targets"
    );
    let target = repaired;
    assert!((win.bounds(target).unwrap().x - before.x - 8.0).abs() < 0.001);
    assert_eq!(win.hit_target(Point { x: 1.0, y: 1.0 }).unwrap(), None);
    assert_eq!(
        win.hit_target(Point { x: 9.0, y: 1.0 }).unwrap(),
        Some(target)
    );
}

#[test]
fn source_authority_is_checked_before_inbox_callback_and_rebinding_replaces_recipes() {
    let forged = Source::new(
        Panel::FRAME.id(),
        "frame",
        |m: &Panel| &m.frame,
        |m| &mut m.peer,
    );
    let (remote, inbox) = Remote::bounded(1);
    let mut win = Win::with_size(Panel::new(), 320, 180)
        .unwrap()
        .with_inbox_for(inbox, forged, |_, _: ()| {
            panic!("must reject before callback")
        })
        .unwrap();
    remote.try_send(()).unwrap();
    assert!(matches!(
        win.deliver_ready(1).unwrap_err().error,
        Error::Binding(_)
    ));
    assert_eq!(win.root().unwrap().frame.count, 0);
    assert_eq!(win.root().unwrap().peer.count, 10);
    win.update(|model| {
        model.use_peer = true;
        model.invert = true;
        model.peer = Signal::new(frame(21));
    })
    .unwrap();
    win.reset_counters().unwrap();
    win.set(Panel::FRAME, frame(99)).unwrap();
    let target = win.query().name("moving").one().unwrap();
    assert_eq!(
        win.property(target, TRANSFORM).unwrap(),
        frame(21).transform
    );
    win.set(Panel::PEER, frame(22)).unwrap();
    assert_eq!(
        win.property(target, TRANSFORM).unwrap(),
        frame(22).transform
    );
    assert_eq!(
        colors(&win),
        (0..32)
            .map(|index| if bit(&frame(22), index) == Color::WHITE {
                Color::BLACK
            } else {
                Color::WHITE
            })
            .collect::<Vec<_>>()
    );
    assert_eq!(win.counters().owner_reruns, 0);
    win.update(|model| {
        model.rows = 0;
        model.frame = Signal::new(frame(1));
        model.use_peer = false;
        model.invert = false;
    })
    .unwrap();
    win.set(Panel::FRAME, frame(3)).unwrap();
    let target = win.query().name("moving").one().unwrap();
    assert_eq!(win.property(target, TRANSFORM).unwrap(), frame(3).transform);
}

#[test]
fn mapped_outputs_keep_inspector_bases_and_mix_with_direct_text_in_either_install_order() {
    struct Numeric {
        value: Signal<u32>,
        reverse: bool,
    }
    const VALUE: Source<Numeric, u32> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    impl View for Numeric {
        fn sources() -> Sources<Self> {
            Sources::new().direct(VALUE)
        }
        fn view(&self) -> El<'_> {
            let mapped = div()
                .name("mapped")
                .transform(
                    self.value
                        .map(|value| Affine::translation((*value % 4) as f32, 0.0)),
                )
                .w(self.value.map(|value| value + 1))
                .bg(self.value.map(|value| {
                    if *value % 2 == 0 {
                        Color::WHITE
                    } else {
                        Color::BLACK
                    }
                }));
            if self.reverse {
                column((text(&self.value), mapped))
            } else {
                column((mapped, text(&self.value)))
            }
        }
    }
    for reverse in [false, true] {
        let mut win = Win::with_size(
            Numeric {
                value: Signal::new(20),
                reverse,
            },
            100,
            100,
        )
        .unwrap();
        let target = win.query().name("mapped").one().unwrap();
        win.set_property(target, WIDTH, Contribution::Set(Some(50.0)))
            .unwrap();
        win.set(VALUE, 23).unwrap();
        assert!(win.contains_text("23").unwrap());
        assert_eq!(win.property(target, WIDTH).unwrap(), Some(50.0));
        assert_eq!(
            win.property(target, BACKGROUND).unwrap().solid().unwrap(),
            Color::BLACK
        );
        assert_eq!(
            win.property(target, TRANSFORM).unwrap(),
            Affine::translation(3.0, 0.0)
        );
        win.set_property(target, WIDTH, Contribution::Inherit)
            .unwrap();
        assert_eq!(win.property(target, WIDTH).unwrap(), Some(24.0));
        assert_eq!(win.counters().owner_reruns, 0);
    }
    struct Colors(Signal<Color>);
    const COLOR: Source<Colors, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.0, |m| &mut m.0);
    impl View for Colors {
        fn sources() -> Sources<Self> {
            Sources::new().direct(COLOR)
        }
        fn view(&self) -> El<'_> {
            row((
                div().name("direct").bg(&self.0),
                div().name("map").bg(self.0.map(|_| Color::BLACK)),
            ))
        }
    }
    let mut win = Win::demo(Colors(Signal::new(Color::BLACK)));
    win.set(COLOR, Color::WHITE).unwrap();
    assert_eq!(
        win.property(win.query().name("direct").one().unwrap(), BACKGROUND)
            .unwrap()
            .solid()
            .unwrap(),
        Color::WHITE
    );
    assert_eq!(
        win.property(win.query().name("map").one().unwrap(), BACKGROUND)
            .unwrap()
            .solid()
            .unwrap(),
        Color::BLACK
    );
}

#[test]
fn source_dependent_question_refreshes_reader_before_exact_patch_gate() {
    let (send, jobs) = mpsc::channel();
    let (questions, answer) = Questions::new()
        .question(
            Panel::FRAME,
            |frame| frame.count,
            move |input, completion: gpui::Completion<u64, std::convert::Infallible>| {
                send.send((input, completion))
                    .map_err(|_| StartError::Closed)
            },
        )
        .unwrap();
    let mut model = Panel::new();
    model.answer = Some(answer);
    let (remote, inbox) = Remote::bounded(1);
    let mut win = Win::with_questions(
        model,
        questions,
        WindowOptions {
            size: [320, 180],
            ..Default::default()
        },
    )
    .unwrap()
    .with_inbox_for(inbox, Panel::FRAME, |value, next| *value = next)
    .unwrap();
    let (_, completion) = jobs.recv().unwrap();
    completion.complete(Ok(123)).unwrap();
    win.deliver_ready(8).unwrap();
    assert!(win.contains_text("answer-123").unwrap());
    win.reset_counters().unwrap();
    remote.try_send(frame(5)).unwrap();
    win.deliver_ready(1).unwrap();
    assert_eq!(win.with_ready(answer, |value| *value).unwrap(), None);
    assert_eq!(
        win.question_status(answer).unwrap(),
        gpui::QuestionStatus::Pending
    );
    assert!(win.contains_text("Updating…").unwrap());
    assert_eq!(win.counters().owner_reruns, 1);
    let (input, completion) = jobs.recv().unwrap();
    assert_eq!(input, 5);
    completion.complete(Ok(456)).unwrap();
    win.deliver_ready(8).unwrap();
    assert!(win.contains_text("answer-456").unwrap());
}

#[test]
fn oversized_recipe_rejects_mount_and_literal_overwrite_removes_it() {
    struct Oversized {
        value: Signal<u32>,
        overwrite: bool,
    }
    impl View for Oversized {
        fn view(&self) -> El<'_> {
            let params = [1_u64; 3];
            let node = div().bg(self.value.map_with(params, |_, params| {
                std::hint::black_box(params);
                Color::WHITE
            }));
            if self.overwrite {
                node.bg(Color::BLACK)
            } else {
                node
            }
        }
    }
    assert!(matches!(
        Win::with_size(
            Oversized {
                value: Signal::new(0),
                overwrite: false
            },
            20,
            20
        ),
        Err(Error::MapStorage {
            size: 24,
            alignment: 8
        })
    ));
    assert!(
        Win::with_size(
            Oversized {
                value: Signal::new(0),
                overwrite: true
            },
            20,
            20
        )
        .is_ok()
    );
}

#[test]
fn masked_first_direct_sink_cannot_hide_a_shared_peer_change_in_a_mapped_group() {
    struct Colors(Signal<Color>);
    const COLOR: Source<Colors, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.0, |m| &mut m.0);
    impl View for Colors {
        fn sources() -> Sources<Self> {
            Sources::new().direct(COLOR)
        }
        fn view(&self) -> El<'_> {
            row((
                div().name("masked").size(8).bg(&self.0),
                div().name("peer").size(8).bg(&self.0),
                div().size(8).bg(self.0.map(|_| Color::BLACK)),
            ))
        }
    }
    let mut win = Win::with_size(Colors(Signal::new(Color::BLACK)), 100, 100).unwrap();
    let masked = win.query().name("masked").one().unwrap();
    let peer = win.query().name("peer").one().unwrap();
    win.set_property(
        masked,
        BACKGROUND,
        Contribution::Set(gpui::Brush::Solid(Color::WHITE)),
    )
    .unwrap();
    let before = win.scene_digest().unwrap();
    win.reset_counters().unwrap();
    let commit = win.set(COLOR, Color::WHITE).unwrap();
    assert_eq!(
        commit.changed_nodes, 1,
        "the unmasked shared peer changes even when the first sink is masked"
    );
    assert_ne!(win.scene_digest().unwrap(), before);
    assert_eq!(
        win.property(peer, BACKGROUND).unwrap().solid().unwrap(),
        Color::WHITE
    );
    assert_eq!(win.counters().owner_reruns, 0);
    win.set_property(
        peer,
        BACKGROUND,
        Contribution::Set(gpui::Brush::Solid(Color::WHITE)),
    )
    .unwrap();
    let before = win.scene_digest().unwrap();
    win.reset_counters().unwrap();
    let commit = win.set(COLOR, Color::BLACK).unwrap();
    assert_eq!(commit.changed_nodes, 0);
    assert_eq!(
        win.counters().paint_passes,
        0,
        "fully masked source changes need no paint"
    );
    assert_eq!(win.scene_digest().unwrap(), before);
    win.set_property(masked, BACKGROUND, Contribution::Inherit)
        .unwrap();
    assert_eq!(
        win.property(masked, BACKGROUND).unwrap().solid().unwrap(),
        Color::BLACK
    );
}
