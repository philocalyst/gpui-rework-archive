//! The same exclusively owned application model runs headlessly and natively.
use gpui::{Component, El, FieldId, Signal, Source, Sources, View};
use gpui_component::{
    Badge, Button, ButtonVariant, Checkbox, Field, Input, Label, Space, Theme,
    layout::{inline, section, stack},
};

pub struct Preparation {
    pub lanterns: Signal<bool>,
    pub treats: Signal<bool>,
    pub requested: usize,
    theme: Theme,
}
impl Preparation {
    pub const LANTERNS: Source<Self, bool> = Source::new(
        FieldId::new(1),
        "lanterns",
        |m| &m.lanterns,
        |m| &mut m.lanterns,
    );
    pub const TREATS: Source<Self, bool> =
        Source::new(FieldId::new(2), "treats", |m| &m.treats, |m| &mut m.treats);
    fn set_lanterns(&mut self, checked: bool) {
        self.requested += 1;
        *self.lanterns = checked;
    }
    pub fn new(theme: Theme) -> Self {
        Self {
            lanterns: Signal::new(false),
            treats: Signal::new(true),
            requested: 0,
            theme,
        }
    }
}
impl View for Preparation {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::LANTERNS).field(Self::TREATS)
    }
    fn view(&self) -> El<'_> {
        let t = &self.theme;
        stack(
            (
                Label::new("Before the doorbell rings", t)
                    .style(|e: El<'_>| e.font_size(t.rem(9.0 / 7.0)))
                    .build(),
                Checkbox::new("Light the lanterns", *self.lanterns, t)
                    .toggle(Self::LANTERNS)
                    // Application policy replaces the reusable default route.
                    .on_change(Self::set_lanterns)
                    .parts(|parts| parts.indicator(|e: El<'_>| e.rounded(t.radius() / 3.0)))
                    .build(),
                Checkbox::new("Set out the treats", *self.treats, t)
                    .toggle(Self::TREATS)
                    .build(),
            ),
            t,
        )
    }
}
pub struct Party {
    pub title: Signal<String>,
    pub preparation: Preparation,
    pub finished: bool,
    pub default_calls: usize,
    pub finish_calls: usize,
    pub theme: Theme,
}
impl Default for Party {
    fn default() -> Self {
        let theme = Theme::halloween();
        Self {
            title: Signal::new("The midnight gathering".into()),
            preparation: Preparation::new(theme.clone()),
            finished: false,
            default_calls: 0,
            finish_calls: 0,
            theme,
        }
    }
}
impl Party {
    pub const TITLE: Source<Self, String> =
        Source::new(FieldId::new(1), "title", |m| &m.title, |m| &mut m.title);
    pub const PREPARATION: Component<Self, Preparation> = Component::new(
        FieldId::new(2),
        "preparation",
        |m| &m.preparation,
        |m| &mut m.preparation,
    );
    fn default_finish(&mut self) {
        self.default_calls += 1;
    }
    fn finish(&mut self) {
        if self.ready() {
            self.finish_calls += 1;
            self.finished = true;
        }
    }
    pub fn ready(&self) -> bool {
        self.title.trim().chars().count() >= 3
            && *self.preparation.lanterns
            && *self.preparation.treats
            && !self.finished
    }
}
impl View for Party {
    fn sources() -> Sources<Self> {
        Sources::new()
            .field(Self::TITLE)
            .component(Self::PREPARATION)
    }
    fn view(&self) -> El<'_> {
        let t = &self.theme;
        let invalid = self.title.trim().chars().count() < 3;
        gpui::column((
            inline(
                (
                    Label::new("HALLOWEEN · OCTOBER 31", t)
                        .style(|e: El<'_>| e.font_size(t.rem(6.0 / 7.0)).fg(t.muted()))
                        .build(),
                    Badge::new(
                        if self.finished {
                            "Ready to share"
                        } else {
                            "Draft invitation"
                        },
                        t,
                    )
                    .build(),
                ),
                t,
            ),
            Label::new("A little after dark", t)
                .style(|e: El<'_>| e.font_size(t.rem(20.0 / 7.0)))
                .build(),
            Label::new("Good company. Warm cider. One quietly haunted evening.", t)
                .style(|e: El<'_>| e.fg(t.muted()))
                .build(),
            section(
                (
                    Label::new("Your invitation", t)
                        .style(|e: El<'_>| e.font_size(t.rem(10.0 / 7.0)))
                        .build(),
                    Field::new(
                        "Gathering name",
                        Input::new(&self.title, "Gathering name", t)
                            .invalid(invalid)
                            .description("At least three characters")
                            .parts(|parts| {
                                parts.frame(|e: El<'_>| e.w(gpui::Length::Percent(100.0)))
                            })
                            .build(),
                        t,
                    )
                    .help(if invalid {
                        "Use at least three characters"
                    } else {
                        "Saturday, October 31 · 7:30 pm · The old conservatory"
                    })
                    .build(),
                    Self::PREPARATION.view(self),
                ),
                t,
            ),
            inline(
                (
                    Button::new(
                        if self.finished {
                            "Ready"
                        } else {
                            "Finish invitation"
                        },
                        t,
                    )
                    .variant(ButtonVariant::Primary)
                    .on_click(Self::default_finish)
                    .on_click(Self::finish)
                    .disabled(!self.ready())
                    .style(|e: El<'_>| e.rounded(t.radius() / 2.0))
                    .build(),
                    Label::new(
                        if self.finished {
                            "Your invitation is ready to share"
                        } else {
                            "Finish the checklist to prepare your invitation"
                        },
                        t,
                    )
                    .style(|e: El<'_>| e.fg(t.muted()).font_size(t.rem(6.0 / 7.0)))
                    .build(),
                ),
                t,
            ),
            Label::new("Costumes welcome. Ghost stories optional.", t)
                .style(|e: El<'_>| e.fg(t.muted()).font_size(t.rem(6.0 / 7.0)))
                .build(),
        ))
        .size(gpui::Length::Percent(100.0))
        .gap(t.space(Space::Group))
        .p(t.space(Space::Region))
        .bg(t.background())
        .fg(t.foreground())
    }
}
