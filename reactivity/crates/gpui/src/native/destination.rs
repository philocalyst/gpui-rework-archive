//! Server destination validity is independent of retained client-buffer age.
use super::winit::window::RedrawInvalidation;

pub(super) struct Destination {
    full: bool,
}
impl Default for Destination {
    fn default() -> Self {
        Self { full: true }
    }
}
impl Destination {
    pub(super) fn observe(&mut self, invalidation: RedrawInvalidation) {
        if invalidation != RedrawInvalidation::KnownClear {
            self.invalidate();
        }
    }
    pub(super) fn invalidate(&mut self) {
        self.full = true;
    }
    pub(super) fn requires_full(&self) -> bool {
        self.full
    }
    pub(super) fn accepted(&mut self, full: bool) {
        // A partial submit cannot discharge a previously unresolved full repair.
        if full {
            self.full = false;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn takes_and_partial_submits_never_erase_a_full_repair_obligation() {
        let mut destination = Destination::default();
        destination.observe(RedrawInvalidation::KnownClear);
        destination.accepted(false);
        assert!(destination.requires_full());
        destination.accepted(true);
        assert!(!destination.requires_full());
        destination.observe(RedrawInvalidation::Invalidated);
        destination.observe(RedrawInvalidation::KnownClear);
        destination.accepted(false);
        assert!(destination.requires_full());
        destination.accepted(true);
        destination.invalidate(); // Failed submission or lifecycle loss.
        destination.observe(RedrawInvalidation::KnownClear);
        assert!(destination.requires_full());
    }
    #[test]
    fn unsupported_backends_need_full_submission_on_every_redraw() {
        let mut destination = Destination::default();
        for _ in 0..3 {
            destination.observe(RedrawInvalidation::Unknown);
            assert!(destination.requires_full());
            destination.accepted(true);
        }
    }
}
