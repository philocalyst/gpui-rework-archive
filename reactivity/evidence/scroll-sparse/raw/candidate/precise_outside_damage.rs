fn outside_damage(
    previous: &Canvas,
    next: &Canvas,
    destination: Bounds,
    _damage: DamageRegion,
) -> crate::DamageRegions {
    fn unchanged(old: BorrowedCommand<'_>, new: BorrowedCommand<'_>) -> bool {
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
                    BorrowedCommand { source: new.source, ..old }
                } else {
                    old
                }
            }
            _ => old,
        };
        old.unchanged(new)
    }
    let outside = |draw: &BorrowedCommand<'_>| {
        let [l, t, r, b] = draw.bounds.map(|v| v as i32);
        l < destination[0] || t < destination[1] || r > destination[2] || b > destination[3]
    };
    let mut old = previous.commands.iter(viewport_rect(previous.width, previous.height)).filter(outside);
    let mut new = next.commands.iter(viewport_rect(next.width, next.height)).filter(outside);
    let mut regions = crate::DamageRegions::default();
    // Positional comparison can overstate work after insertions/removals. Each
    // unmatched old AND new contribution still keeps its conservative support;
    // unlike zip, consuming an unequal tail cannot silently discard one item.
    loop {
        match (old.next(), new.next()) {
            (None, None) => break,
            (Some(a), Some(b)) if unchanged(a, b) => {}
            (a, b) => {
                for draw in [a, b].into_iter().flatten() {
                    regions.include(DamageRegion::checked_canvas_bounds(draw.bounds));
                }
            }
        }
    }
    regions
}
