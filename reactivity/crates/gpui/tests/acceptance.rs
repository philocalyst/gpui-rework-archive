//! Public-library acceptance: no private runtime or layout testing interface.
use gpui::prelude::*;
use gpui::{ColorConfig, Error, OutputProfile, WindowOptions};
use serde::{Deserialize, Serialize};

#[derive(Default, Serialize, Deserialize)]
struct Counter {
    count: Signal<u32>,
}
impl Counter {
    const COUNT: Source<Self, u32> = Source::new(
        FieldId::new(1),
        "count",
        |model| &model.count,
        |model| &mut model.count,
    );
}
impl View for Counter {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COUNT)
    }
    fn view(&self) -> El<'_> {
        column((
            text(&self.count),
            button("Increment").on_click(Self::COUNT.update(|count| *count += 1)),
        ))
        .p(8)
        .gap(8)
    }
}

#[test]
fn typed_actions_use_real_input_and_pixels_without_redescribing_the_owner() {
    let mut window = Win::with_size(Counter::default(), 180, 100).unwrap();
    let original = window.scene_digest().unwrap();
    let increment = window.button("Increment");
    window.reset_counters().unwrap();
    let commit = window.click(increment).unwrap();
    assert_eq!((commit.source_epoch, commit.presentation_epoch), (1, 1));
    assert_eq!(window.with_model(|model| *model.count).unwrap(), 1);
    assert_eq!(window.counters().owner_reruns, 0);
    assert_eq!(window.counters().exact_updates, 1);
    assert_ne!(window.scene_digest().unwrap(), original);
    let snapshot = window.snapshot().unwrap();
    assert!(
        snapshot
            .nodes
            .iter()
            .any(|node| node.text.as_deref() == Some("1"))
    );

    window.reset_counters().unwrap();
    window.set(Counter::COUNT, 1).unwrap();
    assert_eq!(window.counters().owner_reruns, 0);
    assert_eq!(window.counters().paint_passes, 0);
    assert_eq!(window.counters().layout_runs, 0);
    for _ in 0..100 {
        window.settle().unwrap();
    }
    assert_eq!(window.counters().paint_passes, 0);
    assert_eq!(window.counters().descriptions, 0);
}

#[derive(Default)]
struct Branch {
    show: Signal<bool>,
}
impl Branch {
    const SHOW: Source<Self, bool> = Source::new(
        FieldId::new(1),
        "show",
        |model| &model.show,
        |model| &mut model.show,
    );
}
impl View for Branch {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::SHOW)
    }
    fn view(&self) -> El<'_> {
        if *self.show {
            text("visible")
        } else {
            text("hidden")
        }
    }
}

#[test]
fn ordinary_rust_branches_react_with_the_default_source_registration() {
    let mut window = Win::with_size(Branch::default(), 120, 40).unwrap();
    window.reset_counters().unwrap();
    window.set(Branch::SHOW, true).unwrap();
    assert!(
        window
            .snapshot()
            .unwrap()
            .nodes
            .iter()
            .any(|node| node.text.as_deref() == Some("visible"))
    );
    assert_eq!(window.counters().owner_reruns, 1);
    assert_eq!(window.counters().exact_updates, 0);
}

#[derive(Default)]
struct Rows {
    prepend: bool,
    clicks: usize,
}
impl Rows {
    fn press(&mut self) {
        self.clicks += 1;
    }
}
impl View for Rows {
    fn view(&self) -> El<'_> {
        column((
            self.prepend.then(|| button("new").on_click(Self::press)),
            button("original").on_click(Self::press),
        ))
    }
}

#[test]
fn unkeyed_child_run_changes_revoke_targets_instead_of_retargeting_them() {
    let mut window = Win::with_size(Rows::default(), 180, 100).unwrap();
    let original = window.button("original");
    window.update(|model| model.prepend = true).unwrap();
    assert_eq!(window.activate(original), Err(Error::StaleTarget));
    window.activate(window.button("new")).unwrap();
    assert_eq!(window.with_model(|model| model.clicks).unwrap(), 1);
}

#[test]
fn restoration_preserves_source_values_and_remints_dispatch_authority() {
    let mut window = Win::with_size(Counter::default(), 180, 100).unwrap();
    let original = window.button("Increment");
    window.activate(original).unwrap();
    let json = window.source_json().unwrap();
    assert_eq!(json, "{\"count\":1}");
    let mut restored = Win::<Counter>::from_json(&json).unwrap();
    assert_eq!(
        restored
            .with_model(|model| (*model.count, model.count.revision().get()))
            .unwrap(),
        (1, 0)
    );
    assert_eq!(restored.activate(original), Err(Error::StaleTarget));
    restored.activate(restored.button("Increment")).unwrap();
    assert_eq!(restored.with_model(|model| *model.count).unwrap(), 2);
}

struct Editor {
    content: Signal<String>,
}
impl Editor {
    const CONTENT: Source<Self, String> = Source::new(
        FieldId::new(1),
        "content",
        |model| &model.content,
        |model| &mut model.content,
    );
}
impl View for Editor {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::CONTENT)
    }
    fn view(&self) -> El<'_> {
        text_input(&self.content).w(160).p(4)
    }
}

#[test]
fn presentation_failure_preserves_source_edits_and_the_previous_complete_image() {
    let mut window = Win::with_size(
        Editor {
            content: Signal::new("ok".into()),
        },
        180,
        50,
    )
    .unwrap();
    let input = window.input();
    let original = window.scene_digest().unwrap();
    assert!(window.set(Editor::CONTENT, "ok漢".into()).is_err());
    assert_eq!(
        window
            .with_model(|model| model.content.to_string())
            .unwrap(),
        "ok漢"
    );
    let snapshot = window.snapshot().unwrap();
    assert_eq!((snapshot.source_epoch, snapshot.presentation_epoch), (1, 0));
    assert_eq!(window.scene_digest().unwrap(), original);
    assert_eq!(window.click(input), Err(Error::PresentationStale));
    // Position-free editing remains usable while presentation catches up.
    let recovered = window.backspace(input).unwrap();
    assert_eq!(
        (recovered.source_epoch, recovered.presentation_epoch),
        (2, 2)
    );
    assert_eq!(
        window
            .with_model(|model| model.content.to_string())
            .unwrap(),
        "ok"
    );
    assert_eq!(window.scene_digest().unwrap(), original);
}

#[test]
fn output_color_configuration_reaches_the_real_pixel_surface() {
    let config = ColorConfig {
        profile: OutputProfile::DisplayP3,
        ..ColorConfig::default()
    };
    struct Panel;
    impl View for Panel {
        fn view(&self) -> El<'_> {
            div()
                .size(8)
                .bg(Color::display_p3(1.0, 0.0, 0.0, 1.0).unwrap())
        }
    }
    let mut window = Win::with_options(
        Panel,
        WindowOptions {
            size: [8, 8],
            colors: config,
        },
    )
    .unwrap();
    window
        .with_pixels(|pixels, width, height| {
            assert_eq!((width, height), (8, 8));
            assert!(
                pixels
                    .as_chunks::<4>()
                    .0
                    .iter()
                    .all(|pixel| *pixel == [255, 0, 0, 255])
            );
        })
        .unwrap();
}
