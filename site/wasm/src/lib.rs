//! Tiny, dependency-free state machine used by the documentation playgrounds.
//!
//! GPUI's browser backend currently owns one document-level canvas, so several
//! independently embedded GPUI windows cannot safely coexist in an article.
//! These exports keep the examples' changing state in real Rust/WebAssembly;
//! the custom element presents that state as semantic DOM beside canonical
//! GPUI source.

#[unsafe(no_mangle)]
pub extern "C" fn counter_step(value: i32, delta: i32) -> i32 {
    value.saturating_add(delta).clamp(-99, 99)
}

#[unsafe(no_mangle)]
pub extern "C" fn counter_reset() -> i32 {
    0
}

/// Returns the responsive arrangement used by the layout study.
/// 0 = column, 1 = compact row, 2 = spacious row.
#[unsafe(no_mangle)]
pub extern "C" fn layout_mode(width: u32) -> u32 {
    match width {
        0..=339 => 0,
        340..=559 => 1,
        _ => 2,
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn layout_gap(width: u32) -> u32 {
    ((width.saturating_sub(220) / 18) + 8).clamp(8, 28)
}

/// Drives the interaction study. Events are leave, enter, press and release.
#[unsafe(no_mangle)]
pub extern "C" fn interaction_transition(state: u32, event: u32) -> u32 {
    match event {
        0 => 0,
        1 => 1,
        2 => 2,
        3 if state == 2 => 3,
        3 => 1,
        _ => state.min(3),
    }
}

/// Shared clock for the landing-page field. Hover engagement raises its pace
/// without introducing a second JavaScript animation state machine.
#[unsafe(no_mangle)]
pub extern "C" fn field_phase(seconds: f32, engagement: f32) -> f32 {
    let energy = engagement.clamp(0.0, 1.0);
    seconds * (0.07 + energy * 0.31) + (seconds * 0.11).sin() * (0.08 + energy * 0.04)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn state_exports_are_bounded_and_deterministic() {
        assert_eq!(counter_step(99, 1), 99);
        assert_eq!(counter_step(-99, -1), -99);
        assert_eq!(layout_mode(339), 0);
        assert_eq!(layout_mode(340), 1);
        assert_eq!(layout_mode(560), 2);
        assert_eq!(interaction_transition(2, 3), 3);
    }
}

