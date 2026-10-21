use gpui::{Error, Role, prelude::*};

struct Page {
    draft: Signal<String>,
}
impl Page {
    const DRAFT: Source<Self, String> =
        Source::new(FieldId::new(1), "draft", |m| &m.draft, |m| &mut m.draft);
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::DRAFT)
    }
    fn view(&self) -> El<'_> {
        column((
            text("A semantic test"),
            text_input(&self.draft).w(160).h(24),
            text(&self.draft),
            row((button("Same"), button("Same"))),
            button("Unique")
                .w(80)
                .h(24)
                .transform(Affine::translation(10., 4.)),
        ))
        .gap(8)
    }
}
fn page() -> Page {
    Page {
        draft: Signal::new("ready".into()),
    }
}

#[test]
fn semantic_queries_use_presented_roles_and_bounds_without_diagnostic_snapshots() {
    let mut win = Win::demo(page());
    assert!(win.contains_text("semantic").unwrap());
    assert_eq!(win.role(Role::Button).count().unwrap(), 3);
    assert_eq!(
        win.role(Role::Button).text("Same").one(),
        Err(Error::AmbiguousElement { matches: 2 })
    );
    assert_eq!(
        win.role(Role::Text).text("absent").one(),
        Err(Error::MissingElement)
    );
    let target = win.role(Role::Button).text("Unique").one().unwrap();
    let bounds = win.bounds(target).unwrap();
    let snapshot_bounds = win
        .inspect()
        .unwrap()
        .nodes
        .into_iter()
        .find(|node| node.target == Some(target))
        .unwrap()
        .rect();
    assert_eq!(bounds, snapshot_bounds);
    assert!(bounds.width > 0. && bounds.height > 0.);
    let measured = allocation_counter::measure(|| {
        for _ in 0..1000 {
            assert!(win.contains_text("semantic").unwrap());
            assert_eq!(win.role(Role::Button).count().unwrap(), 3);
            assert_eq!(
                win.filter_count(|part| part.role() == Role::TextInput)
                    .unwrap(),
                1
            );
            assert_eq!(win.bounds(target).unwrap(), bounds);
            assert_eq!(win.role(Role::Button).text("Unique").one().unwrap(), target);
        }
    });
    assert_eq!(
        measured.count_total, 0,
        "queries must not allocate a snapshot mirror"
    );
    let other = Win::demo(page());
    assert_eq!(other.bounds(target), Err(Error::StaleTarget));
    win.close();
    assert_eq!(win.contains_text("semantic"), Err(Error::Closed));
}

#[test]
fn query_reads_the_acknowledged_sheet_while_source_edits_wait_for_repair() {
    let mut win = Win::demo(page());
    let input = win.role(Role::TextInput).one().unwrap();
    assert!(win.type_text(input, "漢").is_err());
    assert_eq!(win.query().within(input).count().unwrap(), 1);
    assert_eq!(win.role(Role::Text).text("ready").count().unwrap(), 1);
    assert_eq!(
        win.role(Role::TextInput).one(),
        Err(Error::PresentationStale)
    );
    win.backspace(input).unwrap();
    assert_eq!(win.role(Role::TextInput).one().unwrap(), input);
    assert_eq!(win.role(Role::Text).text("ready").count().unwrap(), 1);
    win.presentation_lost().unwrap();
    assert_eq!(win.role(Role::Text).count(), Err(Error::PresentationStale));
}

#[test]
fn scoped_preorder_queries_match_an_independent_parent_walk_for_every_subtree() {
    struct Nested;
    impl View for Nested {
        fn view(&self) -> El<'_> {
            column((
                button("outer").child(row((
                    button("inner").child(text("label")),
                    button("sibling"),
                ))),
                row((text("branch"), button("next"))),
                button("last"),
            ))
        }
    }
    let win = Win::demo(Nested);
    let mut parts = Vec::new();
    win.visit(|part| parts.push((part.target(), part.parent(), part.role())))
        .unwrap();
    for &(root, _, _) in &parts {
        let expected = |buttons: bool| {
            parts
                .iter()
                .filter(|&&(target, _, role)| {
                    if buttons && role != Role::Button {
                        return false;
                    }
                    let mut cursor = Some(target);
                    while let Some(target) = cursor {
                        if target == root {
                            return true;
                        }
                        cursor = parts.iter().find(|part| part.0 == target).unwrap().1;
                    }
                    false
                })
                .count()
        };
        assert_eq!(win.query().within(root).count().unwrap(), expected(false));
        assert_eq!(
            win.role(Role::Button).within(root).count().unwrap(),
            expected(true)
        );
    }
    let last = win.button("last");
    assert_eq!(win.query().within(last).one().unwrap(), last);
    assert_eq!(win.query().within(last).count().unwrap(), 1);
    let foreign = Win::demo(Nested).button("last");
    assert_eq!(win.query().within(foreign).count(), Err(Error::StaleTarget));
}
