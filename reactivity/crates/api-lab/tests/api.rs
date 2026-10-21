use reactivity_api_lab::{
    El, Group, OwnedKind, Retained, View, column, describe, div, row, text, value,
};

struct Panel {
    title: String,
}

impl View for Panel {
    fn view(&self) -> El<'_> {
        text(&self.title)
    }
}

struct Settings {
    title: String,
    count: u64,
    expanded: bool,
    panels: Vec<Panel>,
}

fn empty_state() -> El<'static> {
    text("empty")
}

fn toolbar(settings: &Settings) -> El<'_> {
    row((text(&settings.title), value(&settings.count)))
}

impl View for Settings {
    fn view(&self) -> El<'_> {
        // Concrete return types unify branches without any per-node trait object.
        let details = if self.expanded {
            row(&self.panels)
        } else {
            empty_state()
        };
        column((
            toolbar(self),
            details,
            self.expanded.then(|| div().child(text("on"))),
            row(self.panels.iter().map(|panel| text(&panel.title))),
        ))
    }
}

fn settings() -> Settings {
    Settings {
        title: "Settings".into(),
        count: 7,
        expanded: true,
        panels: vec![
            Panel {
                title: "First".into(),
            },
            Panel {
                title: "Second".into(),
            },
        ],
    }
}

#[test]
fn actual_constructor_syntax_lowers_to_owned_preorder() {
    let mut retained = Retained::default();
    let report = describe(&settings(), &mut retained);
    assert_eq!(report.visited, 12);
    assert_eq!(report.text_copies, 6);
    let nodes = retained.nodes();
    assert_eq!(nodes[0].kind, OwnedKind::Group(Group::Column));
    assert_eq!(nodes[0].children, 4);
    assert_eq!(nodes[1].children, 2);
    assert_eq!(nodes[2].kind, OwnedKind::Text("Settings".into()));
    assert_eq!(nodes[3].kind, OwnedKind::Value(7));
    assert_eq!(nodes[7].kind, OwnedKind::Group(Group::Box));
    // The temporary owner and every borrowed description have already died.
    assert_eq!(nodes[11].kind, OwnedKind::Text("Second".into()));
}

#[test]
fn equal_text_keeps_its_owned_buffer_and_changed_text_copies_once() {
    let mut owner = Panel {
        title: "A deliberately nonempty retained string".into(),
    };
    let mut retained = Retained::default();
    assert_eq!(describe(&owner, &mut retained).text_copies, 1);
    let OwnedKind::Text(text) = &retained.nodes()[0].kind else {
        panic!()
    };
    let pointer = text.as_ptr();

    // Replace source allocation with independently allocated equal bytes.
    owner.title = owner.title.clone();
    let report = describe(&owner, &mut retained);
    assert_eq!(report.text_copies, 0);
    assert_eq!(report.text_bytes_copied, 0);
    let OwnedKind::Text(text) = &retained.nodes()[0].kind else {
        panic!()
    };
    assert_eq!(pointer, text.as_ptr());

    owner.title.push('!');
    let report = describe(&owner, &mut retained);
    assert_eq!(report.text_copies, 1);
    assert_eq!(report.text_bytes_copied, owner.title.len());
    assert_eq!(
        retained.nodes()[0].kind,
        OwnedKind::Text(owner.title.clone())
    );
}

#[test]
fn plain_scalar_changes_and_branch_shape_shrinks() {
    let mut owner = settings();
    let mut retained = Retained::default();
    describe(&owner, &mut retained);
    owner.count += 1;
    assert_eq!(describe(&owner, &mut retained).text_copies, 0);
    assert_eq!(retained.nodes()[3].kind, OwnedKind::Value(8));
    owner.expanded = false;
    describe(&owner, &mut retained);
    let mut cold = Retained::default();
    describe(&owner, &mut cold);
    assert_eq!(retained, cold);
    assert_eq!(retained.nodes()[0].children, 3);
    assert_eq!(retained.nodes().len(), 8);
}

#[test]
fn independent_nested_descriptions_are_safe_to_combine() {
    struct Combined {
        left: Panel,
        right: Panel,
    }
    impl View for Combined {
        fn view(&self) -> El<'_> {
            let outer = self.left.view();
            let inner = { self.right.view() };
            column((outer, row((inner, empty_state()))))
        }
    }
    let owner = Combined {
        left: Panel {
            title: "left".into(),
        },
        right: Panel {
            title: "right".into(),
        },
    };
    let mut retained = Retained::default();
    assert_eq!(describe(&owner, &mut retained).visited, 5);
    assert_eq!(retained.nodes()[3].kind, OwnedKind::Text("right".into()));
}

#[test]
fn static_elements_shorten_and_descriptions_can_outlive_an_unrelated_turn() {
    fn shorten<'a>(el: El<'static>, _: &'a str) -> El<'a> {
        el
    }
    let owner = Panel {
        title: "owner".into(),
    };
    let description = shorten(empty_state(), &owner.title);
    let borrowed = owner.view();
    let mut unrelated = Retained::default();
    describe(
        &Panel {
            title: "another owner".into(),
        },
        &mut unrelated,
    );
    // Ordinary owned description headers are intentionally not tied to that turn.
    let _combined = column((description, borrowed));
}

#[test]
fn bounded_deep_and_wide_shapes_lower_in_preorder() {
    struct Deep(usize);
    impl View for Deep {
        fn view(&self) -> El<'_> {
            let mut el = text("bottom");
            for _ in 0..self.0 {
                el = column(el);
            }
            el
        }
    }
    struct Wide(usize);
    impl View for Wide {
        fn view(&self) -> El<'_> {
            row((0..self.0).map(|_| text("leaf")))
        }
    }
    let mut retained = Retained::default();
    assert_eq!(describe(&Deep(512), &mut retained).visited, 513);
    assert_eq!(retained.nodes()[511].children, 1);
    assert_eq!(retained.nodes()[512].kind, OwnedKind::Text("bottom".into()));
    assert_eq!(describe(&Wide(4096), &mut retained).visited, 4097);
    assert_eq!(retained.nodes()[0].children, 4096);
    assert_eq!(describe(&Wide(4096), &mut retained).text_copies, 0);
}
