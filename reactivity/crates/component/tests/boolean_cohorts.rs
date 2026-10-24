//! Ordinary public contracts for shared semantic/appearance destinations.
use gpui::{
    BoolBinding, BoolInput, El, Error, FieldId, IntoProp, PropInput, Role, SetError, Signal,
    SignalMap, Source, Sources, Target, View, Win, WindowOptions,
    property::{BACKGROUND, Contribution},
};
use gpui_component::{Button, Checkbox, Input, Theme};
use std::sync::atomic::{AtomicUsize, Ordering};
fn ack<M: View + 'static>(w: &mut Win<M>) {
    let token = w.with_scene(|_, t| t).unwrap();
    w.presented(token).unwrap();
}
fn invalid<M: View + 'static>(w: &Win<M>, target: Target) -> bool {
    let mut result = None;
    w.visit(|p| {
        if p.target() == target {
            result = Some(p.invalid())
        }
    })
    .unwrap();
    result.unwrap()
}
struct Form {
    number: Signal<f64>,
    text: Signal<String>,
    theme: Theme,
    calls: &'static AtomicUsize,
    root_override: bool,
}
impl Form {
    const NUMBER: Source<Self, f64> =
        Source::new(FieldId::new(1), "number", |m| &m.number, |m| &mut m.number);
    const TEXT: Source<Self, String> =
        Source::new(FieldId::new(2), "text", |m| &m.text, |m| &mut m.text);
    fn new() -> Self {
        Self {
            number: Signal::new(2.0),
            text: Signal::new("Draft".into()),
            theme: Theme::halloween(),
            calls: Box::leak(Box::new(AtomicUsize::new(0))),
            root_override: false,
        }
    }
}
impl View for Form {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::NUMBER).direct(Self::TEXT)
    }
    fn view(&self) -> El<'_> {
        let calls = self.calls;
        let mapped = self.number.map(move |n| {
            calls.fetch_add(1, Ordering::Relaxed);
            *n < 1.0
        });
        let erased: PropInput<'_, bool> = mapped.into_prop();
        let input = Input::new(&self.text, "Title", &self.theme)
            .invalid(erased)
            .parts(|parts| parts.frame(|e: El<'_>| e.name("validation frame")))
            .build();
        let command = Button::new("Finish", &self.theme)
            .disabled(erased)
            .style(|e: El<'_>| {
                if self.root_override {
                    e.disabled(false).bg(gpui::Color::WHITE)
                } else {
                    e
                }
            })
            .build();
        gpui::column((
            input,
            command,
            Checkbox::new("Choice", erased, &self.theme).build(),
        ))
        .w(&self.number)
    }
}
#[test]
fn erased_inputs_share_each_predicate_once_across_semantics_and_named_parts() {
    let mut w = Win::with_size(Form::new(), 320, 240).unwrap();
    // Three explicit cohorts, not an implicit promise to merge distinct sinks.
    assert_eq!(w.root().unwrap().calls.load(Ordering::Relaxed), 3);
    let input = w.query().name("Title").one().unwrap();
    let frame = w.query().name("validation frame").one().unwrap();
    assert!(!invalid(&w, input));
    w.reset_counters().unwrap();
    w.set(Form::NUMBER, 0.5).unwrap();
    assert_eq!(w.root().unwrap().calls.load(Ordering::Relaxed), 6);
    assert!(invalid(&w, input));
    assert_eq!(
        w.property(frame, BACKGROUND).unwrap().solid(),
        Some(w.root().unwrap().theme.danger())
    );
    assert_eq!(w.counters().descriptions, 0);
    assert_eq!(w.counters().owner_reruns, 0);
    let json = w.semantics().unwrap().to_json().unwrap();
    assert!(json.contains("\"invalid\":true"));
}
#[test]
fn invalid_and_palette_freeze_in_old_p_across_failed_new_candidate() {
    let mut w = Win::recording(
        Form::new(),
        WindowOptions {
            size: [320, 240],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut w);
    let input = w.query().name("Title").one().unwrap();
    let frame = w.query().name("validation frame").one().unwrap();
    w.set(Form::NUMBER, 0.5).unwrap();
    let older = w.with_scene(|_, t| t).unwrap();
    assert!(!invalid(&w, input));
    assert!(matches!(
        w.set(Form::NUMBER, f64::NAN),
        Err(SetError::Committed {
            error: Error::Property(_),
            ..
        })
    ));
    assert!(!invalid(&w, input));
    w.presented(older).unwrap();
    assert!(invalid(&w, input));
    // Ordinary inspector property access requires a valid logical owner; P
    // remains readable through its acknowledged semantic sheet after failure.
    assert!(matches!(
        w.property(frame, BACKGROUND),
        Err(Error::StaleTarget)
    ));
    w.set(Form::NUMBER, 2.0).unwrap();
    assert!(invalid(&w, input));
    ack(&mut w);
    let repaired = w.query().name("Title").one().unwrap();
    assert_ne!(
        repaired, input,
        "recovery retires the invalid logical incarnation"
    );
    assert!(!invalid(&w, repaired));
}
#[test]
fn overriding_one_member_keeps_other_members_and_latest_lower_style() {
    let mut model = Form::new();
    model.root_override = true;
    let mut w = Win::with_size(model, 320, 240).unwrap();
    let command = w.query().name("Finish").one().unwrap();
    w.set(Form::NUMBER, 0.5).unwrap();
    w.visit(|p| {
        if p.target() == command {
            assert!(!p.disabled())
        }
    })
    .unwrap();
    assert_eq!(
        w.property(command, BACKGROUND).unwrap().solid(),
        Some(gpui::Color::WHITE)
    );
    let frame = w.query().name("validation frame").one().unwrap();
    let default = gpui::Color::TRANSPARENT;
    w.set_property(frame, BACKGROUND, Contribution::Set(default.into()))
        .unwrap();
    w.set(Form::NUMBER, 2.0).unwrap();
    assert_eq!(
        w.property(frame, BACKGROUND).unwrap().solid(),
        Some(default)
    );
    w.set_property(frame, BACKGROUND, Contribution::Inherit)
        .unwrap();
    assert_eq!(
        w.property(frame, BACKGROUND).unwrap().solid(),
        Some(w.root().unwrap().theme.border())
    );
}
#[test]
fn orphaned_binding_is_rejected_without_reusing_a_later_description_identity() {
    struct Orphan {
        value: Signal<bool>,
    }
    const VALUE: Source<Orphan, bool> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    impl View for Orphan {
        fn sources() -> Sources<Self> {
            Sources::new().direct(VALUE)
        }
        fn view(&self) -> El<'_> {
            let abandoned = BoolBinding::new(&self.value);
            let state = abandoned.state();
            drop(abandoned);
            let unrelated = BoolBinding::new(&self.value);
            unrelated.attach(gpui::checkbox("Orphan", state))
        }
    }
    assert!(matches!(
        Win::with_size(
            Orphan {
                value: Signal::new(false)
            },
            100,
            100
        ),
        Err(Error::BooleanBinding)
    ));
}
#[test]
fn nested_binding_alias_and_generic_boolean_style_share_one_recipe() {
    struct Page {
        value: Signal<u32>,
        calls: &'static AtomicUsize,
    }
    const VALUE: Source<Page, u32> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    impl View for Page {
        fn sources() -> Sources<Self> {
            Sources::new().direct(VALUE)
        }
        fn view(&self) -> El<'_> {
            let calls = self.calls;
            let binding = BoolBinding::new(self.value.map(move |v| {
                calls.fetch_add(1, Ordering::Relaxed);
                *v != 0
            }));
            let state = binding.state();
            let alias = BoolBinding::new(state);
            let alias_state = alias.state();
            binding.attach(
                alias.attach(
                    gpui::checkbox("Choice", alias_state)
                        .wrap(state)
                        .clipped(state)
                        .bg(state.select(gpui::Color::BLACK, gpui::Color::WHITE)),
                ),
            )
        }
    }
    let calls = Box::leak(Box::new(AtomicUsize::new(0)));
    let mut w = Win::with_size(
        Page {
            value: Signal::new(0),
            calls,
        },
        100,
        100,
    )
    .unwrap();
    assert_eq!(calls.load(Ordering::Relaxed), 1);
    w.set(VALUE, 1).unwrap();
    assert_eq!(calls.load(Ordering::Relaxed), 2);
    let target = w.role(Role::CheckBox).one().unwrap();
    w.visit(|p| {
        if p.target() == target {
            assert_eq!(p.checked(), Some(true));
            assert!(p.clips_children())
        }
    })
    .unwrap();
}

#[test]
fn cohort_capture_budget_excludes_palette_codes_and_unused_groups_do_not_poll() {
    struct Page {
        value: Signal<u32>,
        large: bool,
        unused: bool,
        theme: Theme,
    }
    const VALUE: Source<Page, u32> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    impl View for Page {
        fn sources() -> Sources<Self> {
            Sources::new().direct(VALUE)
        }
        fn view(&self) -> El<'_> {
            if self.large {
                let choice = self.value.map_with([1_u32; 5], |value, parameters| {
                    *value < std::hint::black_box(parameters)[0]
                });
                if self.unused {
                    let binding = BoolBinding::new(choice);
                    let state = binding.state();
                    binding.attach(
                        gpui::div()
                            .size(20)
                            .bg(state.select(gpui::Color::BLACK, gpui::Color::WHITE))
                            .bg(gpui::Color::BLACK),
                    )
                } else {
                    Checkbox::new("Choice", choice, &self.theme).build()
                }
            } else {
                Checkbox::new(
                    "Choice",
                    self.value.map_with([1_u32; 3], |value, parameters| {
                        *value < std::hint::black_box(parameters)[0]
                    }),
                    &self.theme,
                )
                .build()
            }
        }
    }
    let model = |large, unused| Page {
        value: Signal::new(0),
        large,
        unused,
        theme: Theme::halloween(),
    };
    let mut w = Win::with_size(model(false, false), 100, 100).unwrap();
    w.set(VALUE, 2).unwrap();
    w.visit(|p| {
        if p.role() == Role::CheckBox {
            assert_eq!(p.checked(), Some(false))
        }
    })
    .unwrap();
    assert!(matches!(
        Win::with_size(model(true, false), 100, 100),
        Err(Error::MapStorage {
            size: 20,
            alignment: 4
        })
    ));
    assert!(Win::with_size(model(true, true), 100, 100).is_ok());
}

#[test]
fn selectors_beyond_the_literal_search_prefix_do_not_retain_historical_colors() {
    struct Palette(Signal<bool>);
    const FLAG: Source<Palette, bool> =
        Source::new(FieldId::new(1), "flag", |m| &m.0, |m| &mut m.0);
    impl View for Palette {
        fn sources() -> Sources<Self> {
            Sources::new().direct(FLAG)
        }
        fn view(&self) -> El<'_> {
            let binding = BoolBinding::new(&self.0);
            let state = binding.state();
            let swatches: Vec<_> = (0..40)
                .map(|n| {
                    gpui::div()
                        .size(2)
                        .bg(state.select(gpui::Color::rgb(n, 12, 24), gpui::Color::rgb(n, 90, 130)))
                })
                .collect();
            binding.attach(gpui::checkbox("Palette", state).child(swatches.into_iter()))
        }
    }
    let mut w = Win::with_size(Palette(Signal::new(false)), 100, 100).unwrap();
    for value in [true, false, true, false] {
        w.set(FLAG, value).unwrap();
    }
    let measured = allocation_counter::measure(|| {
        for n in 0..100 {
            w.set(FLAG, n % 2 == 0).unwrap();
        }
    });
    assert_eq!(
        measured.bytes_current, 0,
        "alternating admitted palettes must not retain historical literal entries"
    );
}
