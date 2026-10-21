//! Logical text ports and assistive observers share production source and frame cuts.
use gpui::{
    Error, ListInfo, ListItemInfo, Role, SemanticText, WindowOptions, prelude::*,
    property::Contribution,
};

#[derive(Default)]
struct Labelled {
    value: Signal<String>,
    name: Signal<String>,
    bright: bool,
    broken: bool,
}
impl Labelled {
    const NAME: Source<Self, String> =
        Source::new(FieldId::new(1), "name", |m| &m.name, |m| &mut m.name);
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(2), "value", |m| &m.value, |m| &mut m.value);
    fn initial() -> Self {
        Self {
            name: Signal::new("First name".into()),
            value: Signal::new("edited value".into()),
            ..Default::default()
        }
    }
}
impl View for Labelled {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::NAME).direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.value)
                .name(&self.name)
                .description(&self.name)
                .w(180)
                .h(32),
            button("Fallback label"),
        ))
        .bg(if self.bright {
            Color::WHITE
        } else {
            Color::BLACK
        })
        .transform(if self.broken {
            Affine::scale(0., 1.)
        } else {
            Affine::IDENTITY
        })
    }
}
type LabelRecord = (Role, Option<String>, Option<String>, Option<String>);
fn labels<M: View + 'static>(win: &Win<M>) -> Vec<LabelRecord> {
    let mut out = Vec::new();
    win.visit(|part| {
        out.push((
            part.role(),
            part.name().map(str::to_owned),
            part.description().map(str::to_owned),
            part.value().map(str::to_owned),
        ))
    })
    .unwrap();
    out
}
fn input_label<M: View + 'static>(win: &Win<M>) -> (String, String, String) {
    let values = labels(win);
    let (_, name, description, value) =
        values.into_iter().find(|p| p.0 == Role::TextInput).unwrap();
    (name.unwrap(), description.unwrap(), value.unwrap())
}
fn token<M: View + 'static>(win: &Win<M>) -> gpui::PresentationToken {
    win.with_scene(|_, token| token).unwrap()
}
fn record() -> Win<Labelled> {
    Win::recording(
        Labelled::initial(),
        WindowOptions {
            size: [240, 100],
            ..Default::default()
        },
    )
    .unwrap()
}

#[test]
fn direct_name_and_description_share_one_read_and_promotion_without_visual_work() {
    let mut win = Win::with_size(Labelled::initial(), 240, 100).unwrap();
    let digest = win.scene_digest().unwrap();
    let input = win.input();
    win.reset_counters().unwrap();
    let commit = win.set(Labelled::NAME, "Changed".to_owned()).unwrap();
    assert_eq!((commit.source_epoch, commit.presentation_epoch), (1, 1));
    assert_eq!(commit.changed_nodes, 1);
    assert_eq!(
        input_label(&win),
        ("Changed".into(), "Changed".into(), "edited value".into())
    );
    assert_eq!(
        win.role(Role::TextInput).name("Changed").one().unwrap(),
        input
    );
    assert_eq!(win.query().description("Changed").count().unwrap(), 1);
    let c = win.counters();
    assert_eq!(
        (
            c.source_reads,
            c.destination_compares,
            c.text_promotions,
            c.text_bytes_copied
        ),
        (1, 2, 1, 7)
    );
    assert_eq!(
        (
            c.owner_reruns,
            c.layout_runs,
            c.measure_calls,
            c.paint_passes,
            c.presentations
        ),
        (0, 0, 0, 0, 0)
    );
    assert_eq!(win.scene_digest().unwrap(), digest);
    win.reset_counters().unwrap();
    win.set(Labelled::NAME, "Changed".to_owned()).unwrap();
    assert_eq!(win.counters().text_promotions, 0);
    assert_eq!(win.counters().paint_passes, 0);
    assert_eq!(
        win.role(Role::Button)
            .name("Fallback label")
            .count()
            .unwrap(),
        1
    );
}

#[test]
fn metadata_extends_pending_complete_sheet_but_never_relabels_an_older_failed_candidate() {
    let mut win = record();
    let initial = token(&win);
    win.presented(initial).unwrap();
    win.update(|m| m.bright = true).unwrap(); // C1 at S1, P0.
    let candidate = token(&win);
    win.set(Labelled::NAME, "Candidate label".to_owned())
        .unwrap(); // S2 extends C1, P stays old.
    assert_eq!(token(&win), candidate);
    assert_eq!(input_label(&win).0, "First name");
    assert_eq!(win.snapshot().unwrap().prepared_epoch, Some(2));
    win.presented(candidate).unwrap();
    assert_eq!(input_label(&win).0, "Candidate label");
    // The full adversarial C1@S1 -> newer visual failure -> semantic-only S3 cut.
    let mut win = record();
    win.presented(token(&win)).unwrap();
    win.update(|m| {
        m.bright = true;
        *m.name = "Candidate one".to_owned()
    })
    .unwrap();
    let candidate = token(&win);
    assert!(matches!(
        win.update(|m| m.broken = true),
        Err(Error::Canvas(_))
    ));
    win.reset_counters().unwrap();
    let commit = win
        .set(Labelled::NAME, "Deferred label".to_owned())
        .unwrap();
    assert_eq!(
        (
            commit.source_epoch,
            commit.presentation_epoch,
            commit.prepared_epoch
        ),
        (3, 0, Some(1))
    );
    assert_eq!(
        win.counters().paint_passes,
        0,
        "a label edit must not retry failed rendering"
    );
    assert_eq!(input_label(&win).0, "First name");
    assert_eq!(
        win.semantic_text(win.input(), SemanticText::Name).unwrap(),
        Some("Deferred label")
    );
    assert_eq!(token(&win), candidate);
    let ack = win.presented(candidate).unwrap();
    assert_eq!(ack.presentation_epoch, 1);
    assert_eq!(
        input_label(&win).0,
        "Candidate one",
        "the old candidate was not rewritten"
    );
    win.update(|m| m.broken = false).unwrap();
    let repaired = token(&win);
    win.presented(repaired).unwrap();
    assert_eq!(input_label(&win).0, "Deferred label");
    assert_eq!(win.snapshot().unwrap().presentation_epoch, 4);
}

#[test]
fn surface_loss_and_failed_preparation_keep_names_frozen_until_the_right_ack() {
    let mut win = record();
    win.presented(token(&win)).unwrap();
    win.presentation_lost().unwrap();
    let scene = token(&win);
    win.set(Labelled::NAME, "After loss".to_owned()).unwrap();
    assert_eq!(win.snapshot().unwrap().prepared_epoch, Some(1));
    assert_eq!(
        win.query().name("After loss").count(),
        Err(Error::PresentationStale)
    );
    // A newer failed scene cannot replace the metadata-only complete candidate.
    assert!(matches!(
        win.update(|m| m.broken = true),
        Err(Error::Canvas(_))
    ));
    win.set(Labelled::NAME, "Too new".to_owned()).unwrap();
    win.presented(scene).unwrap();
    assert_eq!(input_label(&win).0, "After loss");
    assert_eq!(win.snapshot().unwrap().presentation_epoch, 1);
    win.update(|m| m.broken = false).unwrap();
    win.presented(token(&win)).unwrap();
    assert_eq!(input_label(&win).0, "Too new");
}

#[test]
fn typed_contributions_preserve_inheritance_and_explicit_name_absence() {
    let mut win = Win::with_size(Labelled::initial(), 240, 100).unwrap();
    let input = win.input();
    let button = win.button("Fallback label");
    win.reset_counters().unwrap();
    win.set_semantic(
        input,
        SemanticText::Name,
        Contribution::Set(Some("Inspector name".into())),
    )
    .unwrap();
    win.set(Labelled::NAME, "Latest declaration".into())
        .unwrap();
    assert_eq!(input_label(&win).0, "Inspector name");
    assert_eq!(
        win.semantic_contribution(input, SemanticText::Name)
            .unwrap(),
        Contribution::Set(Some("Inspector name"))
    );
    win.set_semantic(input, SemanticText::Name, Contribution::Inherit)
        .unwrap();
    assert_eq!(input_label(&win).0, "Latest declaration");
    win.set_semantic(button, SemanticText::Name, Contribution::Set(None))
        .unwrap();
    assert_eq!(
        win.role(Role::Button)
            .name("Fallback label")
            .count()
            .unwrap(),
        0
    );
    assert_eq!(win.semantic_text(button, SemanticText::Name).unwrap(), None);
    win.set_semantic(button, SemanticText::Name, Contribution::Inherit)
        .unwrap();
    assert_eq!(
        win.role(Role::Button)
            .name("Fallback label")
            .count()
            .unwrap(),
        1
    );
    assert_eq!(
        (win.counters().layout_runs, win.counters().paint_passes),
        (0, 0)
    );
    let foreign = Win::demo(Labelled::initial()).input();
    let value = "preserve rejected string".to_owned();
    let pointer = value.as_ptr();
    match win.set_semantic(
        foreign,
        SemanticText::Description,
        Contribution::Set(Some(value)),
    ) {
        Err(gpui::SetError::Rejected {
            error: Error::StaleTarget,
            value: Contribution::Set(Some(value)),
        }) => assert_eq!(value.as_ptr(), pointer),
        other => panic!("unexpected result {other:?}"),
    }
}

#[derive(Default)]
struct Child {
    name: Signal<String>,
    value: Signal<String>,
}
impl Child {
    const NAME: Source<Self, String> =
        Source::new(FieldId::new(1), "name", |m| &m.name, |m| &mut m.name);
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(2), "value", |m| &m.value, |m| &mut m.value);
}
impl View for Child {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::NAME).direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.value)
                .name(&self.name)
                .description("A contained editor")
                .w(120)
                .h(24),
            button("Rename").on_click(Self::NAME.update(|name| name.push('!'))),
        ))
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
#[test]
fn contained_direct_sources_route_semantic_ports_without_parent_or_sibling_redescriptions() {
    let mut win = Win::with_size(
        Pair {
            left: Child {
                name: Signal::new("Left editor".into()),
                ..Default::default()
            },
            right: Child {
                name: Signal::new("Right editor".into()),
                ..Default::default()
            },
        },
        400,
        100,
    )
    .unwrap();
    let left = win.role(Role::TextInput).name("Left editor").one().unwrap();
    let mut scope = None;
    win.visit(|part| {
        if part.target() == left {
            scope = part.parent()
        }
    })
    .unwrap();
    let rename = win.role(Role::Button).within(scope.unwrap()).one().unwrap();
    win.reset_counters().unwrap();
    win.activate(rename).unwrap();
    assert_eq!(
        win.role(Role::TextInput)
            .name("Left editor!")
            .one()
            .unwrap(),
        left
    );
    assert_eq!(
        win.role(Role::TextInput)
            .name("Right editor")
            .count()
            .unwrap(),
        1
    );
    assert_eq!(
        (
            win.counters().owner_reruns,
            win.counters().layout_runs,
            win.counters().paint_passes
        ),
        (0, 0, 0)
    );
}

struct Rows {
    len: usize,
    reverse: bool,
    broken: bool,
}
const LIST: ListId = ListId::new(7);
impl ItemSource for Rows {
    fn len(&self) -> usize {
        self.len
    }
    fn key(&self, i: usize) -> ItemKey {
        ItemKey::new((if self.reverse { self.len - i - 1 } else { i }) as u64 + 1000)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        let n = usize::try_from(key.get().checked_sub(1000)?).ok()?;
        (n < self.len).then(|| if self.reverse { self.len - n - 1 } else { n })
    }
    fn row(&self, i: usize) -> El<'_> {
        button(if self.broken {
            "\u{05d0}".to_owned()
        } else {
            format!("row {}", self.key(i).get())
        })
        .h(24)
        .w(180)
    }
}
impl View for Rows {
    fn view(&self) -> El<'_> {
        uniform_list(LIST, self, 24)
            .name("Recordings")
            .h(72)
            .w(180)
            .bg(Color::WHITE)
    }
}
fn list_metadata<M: View + 'static>(win: &Win<M>) -> (Vec<ListInfo>, Vec<ListItemInfo>) {
    let mut lists = vec![];
    let mut rows = vec![];
    win.visit(|part| {
        if let Some(info) = part.list() {
            lists.push(info)
        };
        if let Some(info) = part.list_item() {
            rows.push(info)
        }
    })
    .unwrap();
    (lists, rows)
}
#[test]
fn list_position_count_and_key_are_frozen_with_p_not_read_from_logical_s() {
    let mut win = Win::recording(
        Rows {
            len: 100,
            reverse: false,
            broken: false,
        },
        WindowOptions {
            size: [200, 100],
            ..Default::default()
        },
    )
    .unwrap();
    win.presented(token(&win)).unwrap();
    let initial = list_metadata(&win);
    assert_eq!(
        initial.0,
        vec![ListInfo {
            id: LIST,
            count: 100
        }]
    );
    assert_eq!(
        initial
            .1
            .iter()
            .map(|row| (row.key.get(), row.index, row.count))
            .collect::<Vec<_>>(),
        [(1000, 0, 100), (1001, 1, 100), (1002, 2, 100)]
    );
    let list = win.list(LIST).unwrap();
    win.scroll_to_index(list, 50).unwrap();
    assert_eq!(list_metadata(&win), initial);
    win.presented(token(&win)).unwrap();
    let scrolled = list_metadata(&win);
    assert_eq!(scrolled.1[0].index, 50);
    assert!(scrolled.1.iter().all(|row| row.list == list));
    win.update(|m| {
        m.len = 101;
        m.reverse = true
    })
    .unwrap();
    let candidate = token(&win);
    let candidate_epoch = win.snapshot().unwrap().prepared_epoch.unwrap();
    assert!(matches!(
        win.update(|m| {
            m.len = 102;
            m.broken = true
        }),
        Err(Error::Canvas(_))
    ));
    assert_eq!(list_metadata(&win), scrolled);
    win.presented(candidate).unwrap();
    let acknowledged = list_metadata(&win);
    assert_eq!(win.snapshot().unwrap().presentation_epoch, candidate_epoch);
    assert_eq!(acknowledged.0[0].count, 101);
    assert!(acknowledged.1.iter().all(|row| row.count == 101));
    for row in &acknowledged.1 {
        assert_eq!(row.index as u64, 1100 - row.key.get());
    }
    win.update(|m| m.broken = false).unwrap();
    win.presented(token(&win)).unwrap();
    assert_eq!(list_metadata(&win).0[0].count, 102);
}

#[test]
fn nested_realized_rows_keep_their_immediate_frozen_list_parent() {
    struct Nested {
        len: usize,
        inner: Rows,
        transform: Affine,
    }
    impl ItemSource for Nested {
        fn len(&self) -> usize {
            self.len
        }
        fn key(&self, index: usize) -> ItemKey {
            ItemKey::new(index as u64)
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            let index = usize::try_from(key.get()).ok()?;
            (index < self.len).then_some(index)
        }
        fn row(&self, index: usize) -> El<'_> {
            column((
                text("Outer row"),
                uniform_list(ListId::new(100 + index as u64), &self.inner, 24)
                    .h(48)
                    .w(120),
            ))
        }
    }
    impl View for Nested {
        fn view(&self) -> El<'_> {
            uniform_list(LIST, self, 96)
                .h(144)
                .w(160)
                .transform(self.transform)
        }
    }
    fn check(win: &Win<Nested>, outer_count: u32, inner_count: u32) -> usize {
        let mut preceding: Vec<(Target, Role, Option<ListInfo>)> = Vec::new();
        let mut rows = 0;
        win.visit(|part| {
            if part.role() == Role::ListItem {
                let item = part.list_item().expect("every row wrapper has metadata");
                let parent = part.parent().expect("a row has a parent");
                let (_, role, list) = preceding
                    .iter()
                    .find(|(target, _, _)| *target == parent)
                    .expect("the list precedes its row in P");
                assert_eq!(*role, Role::List);
                let list = list.expect("the immediate parent has frozen list metadata");
                assert_eq!(item.list, parent);
                assert_eq!(item.count, list.count);
                assert!(item.index < item.count);
                if list.id == LIST {
                    assert_eq!(item.count, outer_count);
                    assert_eq!(item.key.get(), u64::from(item.index));
                } else {
                    assert_eq!(item.count, inner_count);
                    assert_eq!(item.key.get(), 1000 + u64::from(item.index));
                }
                rows += 1;
            } else {
                assert!(
                    part.list_item().is_none(),
                    "descendants are not row wrappers"
                );
            }
            preceding.push((part.target(), part.role(), part.list()));
        })
        .unwrap();
        rows
    }
    for transform in [
        Affine::IDENTITY,
        Affine {
            a: -1.0,
            tx: 160.25,
            ty: 0.25,
            ..Affine::IDENTITY
        },
        Affine::translation(-1000.0, 0.0),
    ] {
        for len in [0, 1, 4] {
            let mut win = Win::recording(
                Nested {
                    len,
                    inner: Rows {
                        len: 3,
                        reverse: false,
                        broken: false,
                    },
                    transform,
                },
                WindowOptions {
                    size: [240, 200],
                    ..Default::default()
                },
            )
            .unwrap();
            win.resize_scaled([240, 200], 1.25).unwrap();
            win.presented(token(&win)).unwrap();
            let count = check(&win, len as u32, 3);
            if len == 0 || transform.tx < -900.0 {
                assert_eq!(count, 0);
            } else {
                assert!(count > 0);
            }
            let list = win.list(LIST).unwrap();
            win.scroll(list, 12.25).unwrap();
            win.presented(token(&win)).unwrap();
            check(&win, len as u32, 3);
            let frozen = list_metadata(&win);
            win.update(|model| {
                model.len += 1;
                model.inner.len = 5;
            })
            .unwrap();
            assert_eq!(
                list_metadata(&win),
                frozen,
                "pending S cannot supply parent counts"
            );
            check(&win, len as u32, 3);
            win.presented(token(&win)).unwrap();
            check(&win, len as u32 + 1, 5);
        }
    }
}

#[path = "../examples/support/library.rs"]
mod library;
#[path = "../examples/support/todos.rs"]
mod todos;
#[test]
fn real_apps_have_explicit_names_separate_from_values_and_play_labels() {
    let mut todos = Win::demo(todos::Todos::default());
    let input = todos.role(Role::TextInput).name("New task").one().unwrap();
    todos.type_text(input, "Ship annotations").unwrap();
    assert_eq!(
        todos.role(Role::TextInput).name("New task").one().unwrap(),
        input
    );
    let mut seen = false;
    todos
        .visit(|part| {
            if part.target() == input {
                seen = true;
                assert_eq!(part.value(), Some("Ship annotations"));
                assert_eq!(part.description(), Some("Type a task, then choose Add"));
            }
        })
        .unwrap();
    assert!(seen);
    let library = Win::demo(library::Library::new(10_000));
    assert_eq!(
        library
            .role(Role::List)
            .name("Library recordings")
            .count()
            .unwrap(),
        1
    );
    assert_eq!(
        library.role(Role::Button).text("Play").count().unwrap(),
        library
            .filter_count(|part| part.role() == Role::Button
                && part.name().is_some_and(|name| name.starts_with("Play ")))
            .unwrap()
    );
}

#[test]
fn published_semantic_reads_allocate_nothing_and_use_the_same_static_inbox_owner() {
    let (remote, inbox) = Remote::<String>::bounded(2);
    let mut win = Win::with_size(Labelled::initial(), 240, 100)
        .unwrap()
        .with_inbox(inbox, |model, label| *model.name = label)
        .unwrap();
    remote.try_send("Worker name".into()).unwrap();
    win.reset_counters().unwrap();
    let delivery = win.deliver_ready(8).unwrap();
    assert_eq!(delivery.applied, 1);
    assert_eq!(
        win.role(Role::TextInput)
            .name("Worker name")
            .count()
            .unwrap(),
        1
    );
    assert_eq!(win.counters().paint_passes, 0);
    let allocations = allocation_counter::measure(|| {
        for _ in 0..1000 {
            win.visit(|part| {
                std::hint::black_box((
                    part.target(),
                    part.parent(),
                    part.name(),
                    part.description(),
                    part.value(),
                    part.list(),
                    part.list_item(),
                ));
            })
            .unwrap();
        }
    });
    assert_eq!(allocations.count_total, 0);
}

#[test]
fn cleared_description_inherits_the_latest_source_without_unmasking_early() {
    let mut win = Win::with_size(Labelled::initial(), 240, 100).unwrap();
    let input = win.input();
    win.set_semantic(input, SemanticText::Description, Contribution::Set(None))
        .unwrap();
    win.set(Labelled::NAME, "Current declaration".into())
        .unwrap();
    win.visit(|part| {
        if part.target() == input {
            assert_eq!(part.description(), None)
        }
    })
    .unwrap();
    win.set_semantic(input, SemanticText::Description, Contribution::Inherit)
        .unwrap();
    win.visit(|part| {
        if part.target() == input {
            assert_eq!(part.description(), Some("Current declaration"))
        }
    })
    .unwrap();
}

#[test]
fn a_panicking_semantic_projector_quarantines_the_same_owner_and_focus() {
    struct Fragile {
        label: Signal<String>,
    }
    impl Fragile {
        const LABEL: Source<Self, String> = Source::new(
            FieldId::new(1),
            "label",
            |m| {
                assert_ne!(&*m.label, "panic");
                &m.label
            },
            |m| &mut m.label,
        );
    }
    impl View for Fragile {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::LABEL)
        }
        fn view(&self) -> El<'_> {
            button("action")
                .name(&self.label)
                .on_click(|_: &mut Self| {})
        }
    }
    let mut win = Win::demo(Fragile {
        label: Signal::new("safe".into()),
    });
    let button = win.button("action");
    win.focus(button).unwrap();
    assert!(matches!(
        win.set(Fragile::LABEL, "panic".into()),
        Err(gpui::SetError::Committed {
            error: Error::OwnerPanicked,
            ..
        })
    ));
    assert_eq!(win.focused(), Ok(None));
    assert_eq!(win.activate(button), Err(Error::Poisoned));
    assert_eq!(win.query().name("safe").count(), Err(Error::Poisoned));
    assert_eq!(win.snapshot().unwrap().source_epoch, 1);
}

#[test]
fn query_dimensions_are_conjunctive_and_order_independent() {
    struct Commands;
    impl View for Commands {
        fn view(&self) -> El<'_> {
            column((
                button("Alpha").name("Save").description("Write"),
                button("Beta").name("Cancel").description("Dismiss"),
            ))
        }
    }
    let win = Win::demo(Commands);
    assert_eq!(win.query().name("Save").count().unwrap(), 1);
    assert_eq!(win.query().description("Dismiss").count().unwrap(), 1);
    assert_eq!(win.query().text("Alpha").count().unwrap(), 1);
    let absent = [
        win.query().name("Save").description("Dismiss"),
        win.query().description("Dismiss").name("Save"),
        win.query().text("Beta").name("Save"),
        win.query().name("Save").text("Beta"),
        win.query()
            .containing("Bet")
            .name("Save")
            .description("Write"),
        win.query()
            .name("Save")
            .description("Write")
            .containing("Bet"),
        win.query()
            .description("Write")
            .containing("Bet")
            .name("Save"),
    ];
    for query in absent {
        assert_eq!(query.count().unwrap(), 0);
        assert_eq!(query.one(), Err(Error::MissingElement));
    }
    let expected = win.role(Role::Button).name("Save").one().unwrap();
    let present = [
        win.query().text("Alpha").name("Save").description("Write"),
        win.query().description("Write").name("Save").text("Alpha"),
        win.query()
            .name("Save")
            .containing("Al")
            .description("Write"),
    ];
    for query in present {
        assert_eq!(query.one().unwrap(), expected);
    }
    // Exact and containing remain alternatives for the same visual dimension.
    assert_eq!(
        win.query()
            .text("missing")
            .containing("Al")
            .name("Save")
            .one()
            .unwrap(),
        expected
    );
}
