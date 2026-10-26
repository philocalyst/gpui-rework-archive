//! Syntax sketch of `crates/gpui/examples/learn/haptic_feedback.rs`.
//!
//! Haptics are an ambient sink, like `announce` — `self.haptic(Haptic::Generic)`.
//! Hover is a discrete enter, not pointer-rate view. The slider is a widget over a
//! `Signal`; a step is a discrete edge. `.with(…)` binds on the ROUTE, never chained on the
//! element (12 §8): `.on_hover_enter(HapticExample::tap.with(style))`, one meaning, one
//! receiver — not `.on_hover_enter(HapticExample::tap).with(style)`, which used to read as
//! if `.with` configured the element. Neither helper is ever branched over, so both take the
//! lifetime-hiding leaf spelling (14 §1.2): `haptic_button` borrows its label for the frame
//! (`impl Element + '_`); `status_pill` borrows nothing (`impl Element`). Launch is `Application`.

use gpui::prelude::*;

struct HapticExample {
    value: Signal<f32>,
}

impl Default for HapticExample {
    fn default() -> Self {
        Self {
            value: Signal::new(0.0),
        }
    }
}

impl HapticExample {
    fn tap(&mut self, style: Haptic) {
        self.haptic(style);
    }

    fn stepped(&mut self) {
        self.haptic(Haptic::LevelChange);
    }
}

// The helper borrows `label` for the frame, so it returns an element borrowed for `'_` — the
// borrow is diffed at commit, not cloned at every describe.
fn haptic_button(label: &str, style: Haptic, color: u32) -> impl Element + '_ {
    button(label)
        .w(192)
        .py(12)
        .rounded_md()
        .bg(color)
        .text_color(Color::White)
        .hover(|s| s.bg(color.alpha(0.8)))
        .active(|s| s.bg(color.alpha(0.6)))
        .on_hover_enter(HapticExample::tap.with(style))
}

fn status_pill() -> impl Element {
    let supported = Haptic::supported();
    let (dot, msg) = if supported {
        (0x22c55e, "Haptics is supported on this machine")
    } else {
        (0xf59e0b, "Haptics is not supported on this machine")
    };
    row((
        div().size(8).rounded_full().bg(dot),
        text(msg).text_sm().semibold(),
    ))
    .items_center()
    .gap(8)
    .px(16)
    .py(8)
    .rounded_md()
    .bg(dot.alpha(0.1))
}

impl View for HapticExample {
    fn view(&self) -> El<'_> {
        column((
            column((
                text("Haptic Feedback").text_2xl().semibold(),
                text("macOS Force Touch trackpad haptics via NSHapticFeedbackManager")
                    .text_sm()
                    .text_muted(),
            ))
            .gap(8),
            status_pill(),
            text("Hover over each button to trigger haptic feedback").text_sm(),
            row((
                haptic_button("Generic", Haptic::Generic, 0x3b82f6),
                haptic_button("Alignment", Haptic::Alignment, 0x10b981),
                haptic_button("LevelChange", Haptic::LevelChange, 0x8b5cf6),
            ))
            .gap(12),
            column((
                text("Slider with LevelChange haptic").text_lg().semibold(),
                text(self.value.project(|v| format!("Value: {v:.0}"))).semibold(),
                slider(&self.value)
                    .range(0.0, 100.0)
                    .step(10.0)
                    .on_step(HapticExample::stepped)
                    .fill(0x3b82f6),
            ))
            .gap(12),
        ))
        .p(32)
        .gap(24)
        .bg(theme.background)
    }
}

fn main() {
    Application::run(
        Window::document(HapticExample::default())
            .title("Haptic Feedback")
            .size(520, 520)
            .centered(),
    );
}
