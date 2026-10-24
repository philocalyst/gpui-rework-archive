//! Ordinary external contracts for direct semantic and appearance bindings.
use gpui::{
    Action, ActionKind, Affine, Color, Component, El, Error, FieldId, Key, Length, Role, SetError,
    Signal, SignalMap, Source, Sources, Target, View, Win, WindowOptions,
    property::{BACKGROUND, Contribution, FOREGROUND},
};
use gpui_component::{Button, ButtonVariant, Checkbox, Input, Theme};

fn ack<M: View + 'static>(win: &mut Win<M>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn state<M: View + 'static>(win: &Win<M>, target: Target) -> (Option<bool>, bool) {
    let mut value = None;
    win.visit(|part| {
        if part.target() == target {
            value = Some((part.checked(), part.disabled()));
        }
    })
    .unwrap();
    value.unwrap()
}
struct Form {
    checked: Signal<bool>,
    disabled: Signal<bool>,
    child_disabled: Signal<bool>,
    title: Signal<String>,
    peer: Signal<bool>,
    rebind: bool,
    singular_when_disabled: bool,
    custom: bool,
    requested: Option<bool>,
    calls: usize,
    theme: Theme,
}
impl Default for Form {
    fn default() -> Self {
        Self {
            checked: Signal::new(false),
            disabled: Signal::new(false),
            child_disabled: Signal::new(false),
            title: Signal::new("Draft".into()),
            peer: Signal::new(false),
            rebind: false,
            singular_when_disabled: false,
            custom: false,
            requested: None,
            calls: 0,
            theme: Theme::halloween(),
        }
    }
}
impl Form {
    const CHECKED: Source<Self, bool> = Source::new(
        FieldId::new(1),
        "checked",
        |m| &m.checked,
        |m| &mut m.checked,
    );
    const DISABLED: Source<Self, bool> = Source::new(
        FieldId::new(2),
        "disabled",
        |m| &m.disabled,
        |m| &mut m.disabled,
    );
    const CHILD_DISABLED: Source<Self, bool> = Source::new(
        FieldId::new(3),
        "child-disabled",
        |m| &m.child_disabled,
        |m| &mut m.child_disabled,
    );
    const TITLE: Source<Self, String> =
        Source::new(FieldId::new(4), "title", |m| &m.title, |m| &mut m.title);
    const PEER: Source<Self, bool> =
        Source::new(FieldId::new(5), "peer", |m| &m.peer, |m| &mut m.peer);
}
impl View for Form {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::CHECKED)
            .direct(Self::DISABLED)
            .direct(Self::CHILD_DISABLED)
            .direct(Self::TITLE)
            .direct(Self::PEER)
    }
    fn view(&self) -> El<'_> {
        let checked = if self.rebind {
            &self.peer
        } else {
            &self.checked
        };
        let checkbox = Checkbox::new("Treats", checked, &self.theme)
            .toggle(Self::CHECKED)
            .disabled(&self.disabled)
            .parts(|parts| parts.indicator(|e: El<'_>| e.name("indicator")));
        let checkbox = if self.custom {
            checkbox.on_change(|m: &mut Self, next| {
                m.calls += 1;
                m.requested = Some(next);
            })
        } else {
            checkbox
        };
        let input = Input::new(&self.title, "Title", &self.theme)
            .invalid(self.title.map(|s| s.len() < 3))
            .disabled(&self.disabled)
            .parts(|parts| {
                parts
                    .frame(|e: El<'_>| e.name("input frame"))
                    .control(|e: El<'_>| {
                        let e = e.w(180);
                        if self.singular_when_disabled {
                            e.transform(self.disabled.map(|disabled| {
                                if *disabled {
                                    Affine {
                                        a: 0.0,
                                        d: 0.0,
                                        ..Affine::IDENTITY
                                    }
                                } else {
                                    Affine::IDENTITY
                                }
                            }))
                        } else {
                            e
                        }
                    })
            });
        gpui::column((
            checkbox.build(),
            input.build(),
            Button::new("Command", &self.theme)
                .variant(ButtonVariant::Primary)
                .disabled(&self.disabled)
                .on_click(|m: &mut Self| m.calls += 1)
                .build(),
            // Named-part actions inherit the control root's state. A descendant's
            // own disabled policy survives enabling that ancestor again.
            gpui::button("Parent")
                .name("parent")
                .disabled(&self.disabled)
                .on_click(|_: &mut Self| {})
                .child(
                    gpui::button("Child")
                        .name("child")
                        .disabled(&self.child_disabled)
                        .on_click(|m: &mut Self| m.calls += 1),
                ),
        ))
        .w(300)
    }
}

#[test]
fn direct_checkbox_and_default_toggle_publish_without_owner_description() {
    let mut win = Win::with_size(Form::default(), 320, 300).unwrap();
    let target = win.role(Role::CheckBox).one().unwrap();
    let indicator = win.query().name("indicator").one().unwrap();
    let accent = win.root().unwrap().theme.accent();
    win.reset_counters().unwrap();
    win.activate(target).unwrap();
    assert_eq!(win.read(Form::CHECKED).unwrap(), &true);
    assert_eq!(state(&win, target), (Some(true), false));
    assert_eq!(
        win.property(indicator, BACKGROUND).unwrap().solid(),
        Some(accent)
    );
    win.key(Key::Space).unwrap();
    assert_eq!(state(&win, target), (Some(false), false));
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().descriptions, 0);
    assert_eq!(win.counters().coarse_updates, 0);
    assert_eq!(win.counters().exact_updates, 2);
    assert_eq!(win.counters().source_reads, 2);
}

#[test]
fn custom_controlled_intent_uses_latest_logical_checked_and_replaces_default_once() {
    let mut win = Win::with_size(
        Form {
            custom: true,
            ..Default::default()
        },
        320,
        300,
    )
    .unwrap();
    let target = win.role(Role::CheckBox).one().unwrap();
    win.reset_counters().unwrap();
    win.set(Form::CHECKED, true).unwrap();
    assert_eq!(win.counters().descriptions, 0);
    win.activate(target).unwrap();
    assert_eq!(win.root().unwrap().requested, Some(false));
    assert_eq!(win.root().unwrap().calls, 1);
    assert_eq!(win.read(Form::CHECKED).unwrap(), &true);
    win.key(Key::Enter).unwrap();
    assert_eq!(win.root().unwrap().calls, 2);
    assert_eq!(win.root().unwrap().requested, Some(false));
}

#[test]
fn semantic_and_palette_overrides_keep_explicit_default_and_reveal_latest_source() {
    let mut win = Win::with_size(Form::default(), 320, 300).unwrap();
    let indicator = win.query().name("indicator").one().unwrap();
    let target = win.role(Role::CheckBox).one().unwrap();
    let accent = win.root().unwrap().theme.accent();
    win.set_property(
        indicator,
        BACKGROUND,
        Contribution::Set(Color::TRANSPARENT.into()),
    )
    .unwrap();
    win.reset_counters().unwrap();
    win.set(Form::CHECKED, true).unwrap();
    assert_eq!(state(&win, target).0, Some(true));
    assert_eq!(
        win.property(indicator, BACKGROUND).unwrap().solid(),
        Some(Color::TRANSPARENT)
    );
    win.set_property(indicator, BACKGROUND, Contribution::Inherit)
        .unwrap();
    assert_eq!(
        win.property(indicator, BACKGROUND).unwrap().solid(),
        Some(accent)
    );
    assert_eq!(win.counters().descriptions, 0);
}

#[test]
fn direct_disabled_revokes_focus_and_input_actions_before_ack() {
    let mut win = Win::recording(
        Form::default(),
        WindowOptions {
            size: [320, 300],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let target = win.role(Role::TextInput).one().unwrap();
    win.focus(target).unwrap();
    ack(&mut win);
    win.reset_counters().unwrap();
    win.set(Form::DISABLED, true).unwrap();
    assert_eq!(win.focused().unwrap(), None);
    assert!(!state(&win, target).1);
    assert!(matches!(
        win.type_text(target, "forbidden"),
        Err(Error::NotInteractive)
    ));
    assert!(matches!(
        win.perform(target, Action::SetValue("forbidden")),
        Err(Error::NotInteractive)
    ));
    ack(&mut win);
    assert!(state(&win, target).1);
    win.visit(|part| {
        if part.target() == target {
            assert!(!part.actions().contains(ActionKind::SetValue));
        }
    })
    .unwrap();
    win.set(Form::DISABLED, false).unwrap();
    ack(&mut win);
    win.type_text(target, "!").unwrap();
    assert_eq!(win.read(Form::TITLE).unwrap(), "Draft!");
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().descriptions, 0);
}

#[test]
fn ancestor_inheritance_preserves_descendant_own_disabled_and_route_storage() {
    let mut win = Win::with_size(Form::default(), 320, 300).unwrap();
    let child = win.query().name("child").one().unwrap();
    win.set(Form::CHILD_DISABLED, true).unwrap();
    win.set(Form::DISABLED, true).unwrap();
    win.set(Form::CHILD_DISABLED, false).unwrap();
    assert!(state(&win, child).1);
    assert!(matches!(win.activate(child), Err(Error::NotInteractive)));
    win.set(Form::CHILD_DISABLED, true).unwrap();
    win.set(Form::DISABLED, false).unwrap();
    assert!(state(&win, child).1);
    win.set(Form::CHILD_DISABLED, false).unwrap();
    assert!(!state(&win, child).1);
    win.activate(child).unwrap();
    assert_eq!(win.root().unwrap().calls, 1);
}

#[test]
fn validation_predicate_maps_into_palette_without_owner_snapshot_logic() {
    let mut win = Win::with_size(Form::default(), 320, 300).unwrap();
    let frame = win.query().name("input frame").one().unwrap();
    let danger = win.root().unwrap().theme.danger();
    let border = win.root().unwrap().theme.border();
    win.reset_counters().unwrap();
    win.set(Form::TITLE, "a".into()).unwrap();
    assert_eq!(
        win.property(frame, BACKGROUND).unwrap().solid(),
        Some(danger)
    );
    win.set(Form::TITLE, "Recovery".into()).unwrap();
    assert_eq!(
        win.property(frame, BACKGROUND).unwrap().solid(),
        Some(border)
    );
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().descriptions, 0);
}

#[test]
fn failed_new_preparation_and_old_ack_cannot_restore_direct_disabled_authority() {
    let mut win = Win::recording(
        Form {
            singular_when_disabled: true,
            ..Default::default()
        },
        WindowOptions {
            size: [320, 300],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let input = win.role(Role::TextInput).one().unwrap();
    win.focus(input).unwrap();
    ack(&mut win);
    win.set(Form::TITLE, "Eligible older candidate".into())
        .unwrap();
    let older = win.with_scene(|_, token| token).unwrap();
    assert!(matches!(
        win.set(Form::DISABLED, true),
        Err(SetError::Committed {
            error: Error::Canvas(_),
            ..
        })
    ));
    assert_eq!(win.focused().unwrap(), None);
    win.presented(older).unwrap();
    assert!(!state(&win, input).1);
    assert!(matches!(
        win.type_text(input, "forbidden"),
        Err(Error::NotInteractive)
    ));
    assert_eq!(win.read(Form::TITLE).unwrap(), "Eligible older candidate");
}

#[test]
fn bound_input_rebind_retires_old_source_and_keeps_mount_identity() {
    let mut win = Win::with_size(Form::default(), 320, 300).unwrap();
    let target = win.role(Role::CheckBox).one().unwrap();
    win.update(|m| m.rebind = true).unwrap();
    assert_eq!(win.role(Role::CheckBox).one().unwrap(), target);
    win.reset_counters().unwrap();
    win.set(Form::CHECKED, true).unwrap();
    assert_eq!(state(&win, target).0, Some(false));
    win.set(Form::PEER, true).unwrap();
    assert_eq!(state(&win, target).0, Some(true));
    assert_eq!(win.counters().descriptions, 0);
}

#[test]
fn primary_disabled_false_preserves_variant_foreground() {
    let win = Win::with_size(Form::default(), 320, 300).unwrap();
    let command = win.button("Command");
    assert_eq!(
        win.property(command, FOREGROUND).unwrap(),
        win.root().unwrap().theme.on_accent()
    );
}

#[test]
fn literal_and_direct_intrinsic_inputs_preserve_hot_headers_and_default_allocation_floor() {
    assert_eq!(size_of::<El<'_>>(), 176);
    assert_eq!(size_of::<gpui::Style>(), 88);
    assert_eq!(size_of::<gpui::PropInput<'_, Length>>(), 48);
    let cost = allocation_counter::measure(|| {
        drop(gpui::checkbox("", false));
        drop(gpui::button("").disabled(false));
        drop(gpui::div().disabled(false));
    });
    assert_eq!(cost.count_total, 0);
    let signal = Signal::new(false);
    let mut el = None;
    let direct = allocation_counter::measure(|| el = Some(gpui::checkbox("", &signal)));
    println!(
        "direct_intrinsic,allocations={},retained={}",
        direct.count_total, direct.bytes_current
    );
    assert_eq!(direct.count_total, 2);
    assert_eq!(direct.bytes_current, 80);
    drop(el);
}
