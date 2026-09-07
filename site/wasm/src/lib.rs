//! Tiny, dependency-free Rust module behind the field guide's ocean.
//!
//! The landing page's WebGL wave field is one draw call. Its clock and the
//! shape of its swell come from here rather than from JavaScript, so the
//! motion on the page is Rust all the way down.

/// Advances the wave field's phase. Hover engagement raises its pace without
/// introducing a second JavaScript animation state machine.
#[unsafe(no_mangle)]
pub extern "C" fn field_phase(seconds: f32, engagement: f32) -> f32 {
    let energy = engagement.clamp(0.0, 1.0);
    seconds * (0.11 + energy * 0.34) + (seconds * 0.13).sin() * (0.06 + energy * 0.04)
}

/// Height of the swell at horizontal position `x` (0..1) for a given phase.
/// The page samples this to let CSS-shaped edges agree with the shader.
#[unsafe(no_mangle)]
pub extern "C" fn swell(x: f32, phase: f32) -> f32 {
    let x = x.clamp(0.0, 1.0);
    (x * 6.283 + phase).sin() * 0.55 + (x * 12.566 - phase * 0.7).sin() * 0.3 + (x * 25.13 + phase * 1.9).sin() * 0.15
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn exports_are_bounded_and_deterministic() {
        assert!(field_phase(1.0, 0.0) < field_phase(1.0, 1.0));
        assert!(swell(0.25, 0.0).abs() <= 1.0);
        assert_eq!(swell(0.5, 1.0), swell(0.5, 1.0));
    }
}
