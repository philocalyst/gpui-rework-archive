use gpui::{Action, Error, Role, WindowOptions, prelude::*};
use serde_json::{Value, json};

struct Page {
    value: Signal<String>,
    visible: bool,
}
impl Page {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column((
            text("A \"quoted\" page\nΕλληνικά"),
            self.visible.then(|| {
                text_input(&self.value)
                    .name("Search")
                    .description("Library query")
                    .w(120)
                    .h(24)
            }),
            button("Run").on_click(|_: &mut Self| {}),
        ))
        .name("Main")
        .transform(Affine::translation(5.0, 7.0))
    }
}
fn page() -> Page {
    Page {
        value: Signal::new("ready".into()),
        visible: true,
    }
}
fn json(win: &Win<Page>) -> Value {
    serde_json::from_str(&win.semantics().unwrap().to_json().unwrap()).unwrap()
}
fn input(doc: &Value) -> &Value {
    doc["nodes"]
        .as_array()
        .unwrap()
        .iter()
        .find(|v| v["role"] == "TextInput")
        .unwrap()
}

#[test]
fn serializes_the_same_parts_actions_names_geometry_and_focus_as_public_queries() {
    let mut win = Win::with_size(page(), 240, 160).unwrap();
    let target = win.role(Role::TextInput).one().unwrap();
    win.perform(target, Action::Focus).unwrap();
    let document = json(&win);
    assert_eq!(document["schema_version"], 1);
    assert_eq!(document["source_epoch"], 0);
    assert_eq!(document["presentation_epoch"], 0);
    assert_eq!(document["size"], json!([240, 160]));
    let node = input(&document);
    assert_eq!(node["name"], "Search");
    assert_eq!(node["description"], "Library query");
    assert_eq!(node["value"], "ready");
    assert_eq!(node["focused"], true);
    assert_eq!(node["target"], serde_json::to_value(target).unwrap());
    assert_eq!(node["actions"], json!(["Focus", "Blur", "SetValue"]));
    let mut count = 0;
    win.visit(|part| {
        // Compare the same JSON representation: Value's in-memory f32
        // conversion widens to f64, while the writer emits shortest f32 text.
        let standalone: Value =
            serde_json::from_str(&serde_json::to_string(&part).unwrap()).unwrap();
        assert_eq!(standalone, document["nodes"][count]);
        assert_eq!(
            standalone["text"],
            serde_json::to_value(part.text()).unwrap()
        );
        count += 1;
    })
    .unwrap();
    assert_eq!(count, document["nodes"].as_array().unwrap().len());
    assert!(
        document["nodes"]
            .as_array()
            .unwrap()
            .iter()
            .any(|v| v["text"] == "A \"quoted\" page\nΕλληνικά")
    );
}

#[test]
fn pending_and_failed_candidates_serialize_old_p_with_current_source_epochs() {
    let mut win = Win::recording(
        page(),
        WindowOptions {
            size: [240, 160],
            ..Default::default()
        },
    )
    .unwrap();
    assert!(matches!(win.semantics(), Err(Error::PresentationStale)));
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    let before = json(&win);
    win.set(Page::VALUE, "next".into()).unwrap();
    let pending = json(&win);
    assert_eq!(input(&pending)["value"], "ready");
    assert_eq!(pending["source_epoch"], 1);
    assert_eq!(pending["presentation_epoch"], 0);
    assert_eq!(pending["prepared_epoch"], 1);
    assert_eq!(pending["nodes"], before["nodes"]);
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    let accepted = json(&win);
    assert_eq!(input(&accepted)["value"], "next");
    assert_ne!(accepted["nodes"], before["nodes"]);
    assert!(win.set(Page::VALUE, "漢".into()).is_err());
    let failed = json(&win);
    assert_eq!(input(&failed)["value"], "next");
    assert_eq!(failed["source_epoch"], 2);
    assert_eq!(failed["presentation_epoch"], 1);
    assert_eq!(failed["nodes"], accepted["nodes"]);
    win.presentation_lost().unwrap();
    assert!(matches!(win.semantics(), Err(Error::PresentationStale)));
}

#[test]
fn old_semantic_identities_do_not_grant_authority_after_logical_removal() {
    let mut win = Win::recording(
        page(),
        WindowOptions {
            size: [240, 160],
            ..Default::default()
        },
    )
    .unwrap();
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    let target = win.role(Role::TextInput).one().unwrap();
    win.update(|m| m.visible = false).unwrap();
    assert_eq!(
        input(&json(&win))["target"],
        serde_json::to_value(target).unwrap()
    );
    assert_eq!(win.perform(target, Action::Focus), Err(Error::StaleTarget));
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    assert!(
        !json(&win)["nodes"]
            .as_array()
            .unwrap()
            .iter()
            .any(|v| v["role"] == "TextInput")
    );
}

#[test]
fn streaming_has_no_framework_allocations_and_writer_failure_does_not_mutate_owner() {
    let win = Win::with_size(page(), 240, 160).unwrap();
    let before = json(&win);
    let allocation = allocation_counter::measure(|| {
        for _ in 0..32 {
            win.semantics()
                .unwrap()
                .write_json(std::io::sink())
                .unwrap();
        }
    });
    assert_eq!(allocation.count_total, 0);
    assert_eq!(allocation.bytes_total, 0);
    struct Broken;
    impl std::io::Write for Broken {
        fn write(&mut self, _: &[u8]) -> std::io::Result<usize> {
            Err(std::io::Error::other("fixture"))
        }
        fn flush(&mut self) -> std::io::Result<()> {
            Ok(())
        }
    }
    assert!(matches!(
        win.semantics().unwrap().write_json(Broken),
        Err(Error::Serialization(_))
    ));
    assert_eq!(json(&win), before);
}

#[test]
fn virtual_lists_serialize_only_realized_rows_and_frozen_keys() {
    struct Catalogue;
    impl ItemSource for Catalogue {
        fn len(&self) -> usize {
            250_000
        }
        fn key(&self, i: usize) -> ItemKey {
            ItemKey::new(i as u64 + 7)
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            key.get()
                .checked_sub(7)
                .and_then(|i| (i < 250_000).then_some(i as usize))
        }
        fn row(&self, i: usize) -> El<'_> {
            text(format!("row{i}"))
        }
    }
    impl View for Catalogue {
        fn view(&self) -> El<'_> {
            uniform_list(ListId::new(3), self, 20).w(100).h(40)
        }
    }
    let mut win = Win::with_size(Catalogue, 120, 60).unwrap();
    let read = |win: &Win<Catalogue>| {
        serde_json::from_str::<Value>(&win.semantics().unwrap().to_json().unwrap()).unwrap()
    };
    let initial = read(&win);
    assert!(initial["nodes"].as_array().unwrap().len() < 10);
    assert_eq!(initial["nodes"][0]["list"], json!({"id":3,"count":250_000}));
    let rows = |value: &Value| {
        value["nodes"]
            .as_array()
            .unwrap()
            .iter()
            .filter_map(|v| v["list_item"]["key"].as_u64())
            .collect::<Vec<_>>()
    };
    assert_eq!(rows(&initial), vec![7, 8]);
    let list = win.role(Role::List).one().unwrap();
    win.scroll(list, 40.0).unwrap();
    assert_eq!(rows(&read(&win)), vec![9, 10]);
}

#[test]
fn closed_and_quarantined_owners_cannot_serialize_an_old_sheet() {
    let mut win = Win::with_size(page(), 240, 160).unwrap();
    assert_eq!(
        win.update(|_| panic!("fixture owner failure")),
        Err(Error::OwnerPanicked)
    );
    assert!(matches!(win.semantics(), Err(Error::Poisoned)));
    win.close();
    assert!(matches!(win.semantics(), Err(Error::Closed)));
}

#[test]
fn viewport_serialization_uses_the_same_acknowledged_offset_and_range_as_parts() {
    struct Pane {
        wide: bool,
    }
    impl View for Pane {
        fn view(&self) -> El<'_> {
            column(div().w(if self.wide { 400 } else { 200 }).h(160))
                .w(80)
                .h(60)
                .scroll(Axis::BOTH)
        }
    }
    let mut win = Win::recording(
        Pane { wide: false },
        WindowOptions {
            size: [100, 80],
            ..Default::default()
        },
    )
    .unwrap();
    let read = |win: &Win<Pane>| {
        serde_json::from_str::<Value>(&win.semantics().unwrap().to_json().unwrap()).unwrap()
            ["nodes"][0]["viewport"].clone()
    };
    let ack = |win: &mut Win<Pane>| {
        win.presented(win.with_scene(|_, token| token).unwrap())
            .unwrap();
    };
    ack(&mut win);
    let target = win.role(Role::ScrollView).one().unwrap();
    let before = read(&win);
    assert_eq!(before["axes"], "Both");
    assert_eq!(before["size"], json!([80.0, 60.0]));
    assert_eq!(before["max"], json!({"x":120.0,"y":100.0}));
    win.scroll_by(target, ScrollDelta { x: 12.0, y: 20.0 })
        .unwrap();
    assert_eq!(read(&win), before);
    ack(&mut win);
    let scrolled = read(&win);
    assert_eq!(scrolled["offset"], json!({"x":12.0,"y":20.0}));
    assert_eq!(
        scrolled,
        serde_json::to_value(win.viewport(target).unwrap()).unwrap()
    );
    win.update(|m| m.wide = true).unwrap();
    assert_eq!(read(&win), scrolled);
    ack(&mut win);
    assert_eq!(read(&win)["max"]["x"], 320.0);
}
