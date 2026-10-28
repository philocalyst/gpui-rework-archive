//! Conservative changed support over complete ordered command streams.
use super::*;

impl CanvasScene<'_> {
    /// Commit complete commands and retain bounded separated changed support.
    /// The caller must independently certify the external image predecessor.
    /// When candidates coalesce, their earlier damage must also be repaired.
    pub fn commit_with_damage_regions(self) -> crate::DamageRegions {
        let regions = damage_regions(self.target, &self.pending);
        self.commit();
        regions
    }
}

fn damage_regions(previous: &Canvas, next: &Canvas) -> crate::DamageRegions {
    let mut regions = crate::DamageRegions::default();
    let full = DamageRegion::checked_canvas_bounds([0, 0, next.width, next.height]);
    if previous.width != next.width
        || previous.height != next.height
        || previous.color_config != next.color_config
        || previous.clear.map(f32::to_bits) != next.clear.map(f32::to_bits)
    {
        regions.include(full);
        return regions;
    }
    let mut old = previous
        .commands
        .iter(viewport_rect(previous.width, previous.height));
    let mut new = next.commands.iter(viewport_rect(next.width, next.height));
    loop {
        match (old.next(), new.next()) {
            (None, None) => break,
            (Some(a), Some(b)) if unchanged(a, b) => {}
            (a, b) => {
                for draw in [a, b].into_iter().flatten() {
                    let support = DamageRegion::checked_canvas_bounds(draw.bounds);
                    if support == full {
                        let mut complete = crate::DamageRegions::default();
                        complete.include(full);
                        return complete;
                    }
                    regions.include(support);
                }
            }
        }
    }
    regions
}

pub(super) fn unchanged(old: BorrowedCommand<'_>, new: BorrowedCommand<'_>) -> bool {
    // Staged immutable masks can have distinct lease addresses. Keep every
    // canonical geometry/material predicate, substituting identity only
    // after proving equal glyph dimensions, key and exact coverage bytes.
    let old = match (old.source, new.source) {
        (BorrowedSource::Glyph(a), BorrowedSource::Glyph(b)) => {
            let a = mask_view(a);
            let b = mask_view(b);
            if a.key == b.key
                && a.width == b.width
                && a.height == b.height
                && (std::ptr::eq(a.coverage, b.coverage) || a.coverage == b.coverage)
            {
                BorrowedCommand {
                    source: new.source,
                    ..old
                }
            } else {
                old
            }
        }
        _ => old,
    };
    old.unchanged(new)
}
