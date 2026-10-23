//! A candidate owns only changed rows while its published topology matches P.
//! All deltas borrow the same P epoch; candidates never borrow each other.
use super::*;
use std::ops::Index;

pub(super) struct Change {
    index: u32,
    row: Presented,
}
pub(super) enum CandidateRows {
    Full(Vec<Presented>),
    Changes(Vec<Change>),
}
impl CandidateRows {
    pub fn empty() -> Self {
        Self::Changes(Vec::new())
    }
    pub fn view<'a>(&'a self, base: &'a [Presented]) -> Rows<'a> {
        match self {
            Self::Full(rows) => Rows {
                base: rows,
                changes: &[],
            },
            Self::Changes(changes) => Rows { base, changes },
        }
    }
    pub(super) fn full(&mut self, base: &[Presented], capacity: usize) -> &mut Vec<Presented> {
        if matches!(self, Self::Changes(_)) {
            let Self::Changes(changes) = std::mem::replace(self, Self::empty()) else {
                unreachable!()
            };
            let mut changes = changes.into_iter().peekable();
            let mut rows = Vec::with_capacity(capacity);
            for (index, old) in base.iter().enumerate() {
                rows.push(
                    if changes
                        .peek()
                        .is_some_and(|change| change.index as usize == index)
                    {
                        changes.next().unwrap().row
                    } else {
                        old.clone()
                    },
                );
            }
            *self = Self::Full(rows);
        }
        match self {
            Self::Full(rows) => rows,
            Self::Changes(_) => unreachable!(),
        }
    }
    pub fn acknowledge(self, base: &mut Vec<Presented>) {
        match self {
            Self::Full(rows) => *base = rows,
            Self::Changes(changes) => {
                for change in changes {
                    base[change.index as usize] = change.row;
                }
            }
        }
    }
}

/// Only C needs overlay lookup. P uses its original slice implementation.
pub(super) trait RowAccess<'a>: Copy {
    fn at(self, index: usize) -> &'a Presented;
    fn len(self) -> usize;
    fn contains_point(
        self,
        geometry: geometry::GeometryView<'_>,
        has_viewports: bool,
        index: usize,
        point: Point,
    ) -> bool;
    fn get(self, index: usize) -> Option<&'a Presented>;
    fn iter(self) -> impl DoubleEndedIterator<Item = &'a Presented> + ExactSizeIterator;
}
impl<'a> RowAccess<'a> for &'a [Presented] {
    // Keep the point kernel in GPUI, beside its nongeneric geometry helpers.
    fn contains_point(
        self,
        geometry: geometry::GeometryView<'_>,
        has_viewports: bool,
        index: usize,
        point: Point,
    ) -> bool {
        query::contains_point_in_rows(self, geometry, has_viewports, index, point)
    }
    #[inline]
    fn at(self, index: usize) -> &'a Presented {
        &self[index]
    }
    #[inline]
    fn len(self) -> usize {
        <[Presented]>::len(self)
    }
    #[inline]
    fn get(self, index: usize) -> Option<&'a Presented> {
        <[Presented]>::get(self, index)
    }
    #[inline]
    fn iter(self) -> impl DoubleEndedIterator<Item = &'a Presented> + ExactSizeIterator {
        <[Presented]>::iter(self)
    }
}
#[derive(Clone, Copy)]
pub(super) struct Rows<'a> {
    base: &'a [Presented],
    changes: &'a [Change],
}
impl<'a> From<&'a [Presented]> for Rows<'a> {
    fn from(base: &'a [Presented]) -> Self {
        Self { base, changes: &[] }
    }
}
impl Index<usize> for Rows<'_> {
    type Output = Presented;
    fn index(&self, index: usize) -> &Presented {
        self.get(index).unwrap()
    }
}
impl<'a> RowAccess<'a> for Rows<'a> {
    fn contains_point(
        self,
        geometry: geometry::GeometryView<'_>,
        has_viewports: bool,
        index: usize,
        point: Point,
    ) -> bool {
        query::contains_point_in_rows(self, geometry, has_viewports, index, point)
    }
    fn at(self, index: usize) -> &'a Presented {
        self.get(index).unwrap()
    }
    fn len(self) -> usize {
        self.base.len()
    }
    fn get(self, index: usize) -> Option<&'a Presented> {
        self.changes
            .binary_search_by_key(&index, |change| change.index as usize)
            .map(|at| &self.changes[at].row)
            .ok()
            .or_else(|| self.base.get(index))
    }
    fn iter(self) -> impl DoubleEndedIterator<Item = &'a Presented> + ExactSizeIterator {
        Iter {
            rows: self,
            front: 0,
            back: self.len(),
        }
    }
}
struct Iter<'a> {
    rows: Rows<'a>,
    front: usize,
    back: usize,
}
impl<'a> Iterator for Iter<'a> {
    type Item = &'a Presented;
    fn next(&mut self) -> Option<Self::Item> {
        if self.front == self.back {
            return None;
        }
        let index = self.front;
        self.front += 1;
        if let Some(change) = self.rows.changes.first()
            && change.index as usize == index
        {
            self.rows.changes = &self.rows.changes[1..];
            Some(&change.row)
        } else {
            Some(&self.rows.base[index])
        }
    }
    fn size_hint(&self) -> (usize, Option<usize>) {
        let len = self.back - self.front;
        (len, Some(len))
    }
    fn nth(&mut self, n: usize) -> Option<Self::Item> {
        self.front += n.min(self.back - self.front);
        let at = self
            .rows
            .changes
            .partition_point(|change| (change.index as usize) < self.front);
        self.rows.changes = &self.rows.changes[at..];
        self.next()
    }
}
impl DoubleEndedIterator for Iter<'_> {
    fn next_back(&mut self) -> Option<Self::Item> {
        if self.front == self.back {
            return None;
        }
        self.back -= 1;
        if let Some(change) = self.rows.changes.last()
            && change.index as usize == self.back
        {
            self.rows.changes = &self.rows.changes[..self.rows.changes.len() - 1];
            Some(&change.row)
        } else {
            Some(&self.rows.base[self.back])
        }
    }
    fn nth_back(&mut self, n: usize) -> Option<Self::Item> {
        self.back -= n.min(self.back - self.front);
        let at = self
            .rows
            .changes
            .partition_point(|change| (change.index as usize) < self.back);
        self.rows.changes = &self.rows.changes[..at];
        self.next_back()
    }
}
impl ExactSizeIterator for Iter<'_> {}

pub(super) struct Build<'a> {
    base: &'a [Presented],
    rows: CandidateRows,
    len: usize,
    capacity: usize,
}
impl<'a> Build<'a> {
    pub fn new(base: &'a [Presented], capacity: usize) -> Self {
        Self {
            base,
            rows: if base.is_empty() {
                CandidateRows::Full(Vec::with_capacity(capacity))
            } else {
                CandidateRows::empty()
            },
            len: 0,
            capacity,
        }
    }
    pub fn len(&self) -> usize {
        self.len
    }
    pub fn view(&self) -> Rows<'_> {
        self.rows.view(&self.base[..self.len.min(self.base.len())])
    }
    pub fn get(&self, index: usize) -> Option<&Presented> {
        self.view().get(index)
    }
    pub fn last(&self) -> Option<&Presented> {
        self.len.checked_sub(1).and_then(|index| self.get(index))
    }
    pub fn push(&mut self, row: Presented<&SharedText>) {
        if let CandidateRows::Changes(changes) = &mut self.rows {
            let old = self.base.get(self.len).filter(|old| {
                old.identity == row.identity && old.parent.index() == row.parent.index()
            });
            if old.is_some_and(|old| old.same(&row)) {
                self.len += 1;
                return;
            }
            let grow = if changes.len() == changes.capacity() {
                (changes.len() + 1).next_power_of_two()
            } else {
                changes.capacity()
            };
            if old.is_none()
                || grow * size_of::<Change>() >= self.base.len() * size_of::<Presented>()
            {
                self.rows.full(&self.base[..self.len], self.capacity);
            } else if changes.capacity() < grow {
                // Avoid Vec's minimum four rows for the first sparse change.
                changes.reserve_exact(grow - changes.len());
            }
        }
        let row = row.into_owned();
        match &mut self.rows {
            CandidateRows::Full(rows) => rows.push(row),
            CandidateRows::Changes(changes) => changes.push(Change {
                index: self.len as u32,
                row,
            }),
        }
        self.len += 1;
    }
    pub fn finish(mut self) -> CandidateRows {
        if self.len != self.base.len() {
            self.rows
                .full(&self.base[..self.len.min(self.base.len())], self.capacity);
        }
        self.rows
    }
}

impl Presented {
    fn same(&self, next: &Presented<&SharedText>) -> bool {
        let text = match (&self.text, next.text) {
            (Some(old), Some(next)) => std::ptr::eq::<str>(old.as_ref(), next.as_ref()),
            (None, None) => true,
            _ => false,
        };
        // Different immutable leases conservatively own a changed row even if
        // bytes are equal. The common identical pointer never scans long text.
        text && self.identity == next.identity
            && self.parent.0 == next.parent.0
            && self.kind == next.kind
            && self.basis == next.basis
            && [
                self.placement.translation.x,
                self.placement.translation.y,
                self.placement.size[0],
                self.placement.size[1],
                self.bounds.x,
                self.bounds.y,
                self.bounds.width,
                self.bounds.height,
            ]
            .map(f32::to_bits)
                == [
                    next.placement.translation.x,
                    next.placement.translation.y,
                    next.placement.size[0],
                    next.placement.size[1],
                    next.bounds.x,
                    next.bounds.y,
                    next.bounds.width,
                    next.bounds.height,
                ]
                .map(f32::to_bits)
            && self.hittable == next.hittable
            && self.actions == next.actions
    }
}
impl Presented<&SharedText> {
    fn into_owned(self) -> Presented {
        Presented {
            identity: self.identity,
            parent: self.parent,
            kind: self.kind,
            text: self.text.cloned(),
            placement: self.placement,
            basis: self.basis,
            bounds: self.bounds,
            hittable: self.hittable,
            actions: self.actions,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn owned(index: usize, text: &SharedText) -> Presented {
        Presented {
            identity: index as u64 + 1,
            parent: PresentedLink::new(
                if index == 0 {
                    Parent::NONE
                } else {
                    Parent::new(Some(0))
                },
                false,
                None,
            ),
            kind: NodeKind::Text,
            text: Some(text.clone()),
            placement: geometry::Placement::new([10., 10.], Some(Affine::IDENTITY)),
            basis: geometry::MapBasis::record(Some(Affine::IDENTITY), None, &mut Vec::new()),
            bounds: Rect::new(0., index as f32 * 10., 10., 10.),
            hittable: true,
            actions: Actions::for_node(NodeKind::Text, false),
        }
    }
    fn borrowed(row: &Presented) -> Presented<&SharedText> {
        Presented {
            identity: row.identity,
            parent: row.parent,
            kind: row.kind,
            text: row.text.as_ref(),
            placement: row.placement,
            basis: row.basis,
            bounds: row.bounds,
            hittable: row.hittable,
            actions: row.actions,
        }
    }
    #[test]
    fn exact_sparse_rows_keep_unmodified_leases_and_apply_in_place() {
        let text = SharedText::from("not a static literal: ".repeat(100));
        let mut base: Vec<_> = (0..32).map(|index| owned(index, &text)).collect();
        let base_pointer = base.as_ptr();
        let capacity = base.capacity();
        let leases = text.lease_count().unwrap();
        let mut unchanged = None;
        let cost = allocation_counter::measure(|| {
            let mut build = Build::new(&base, base.len());
            for row in &base {
                build.push(borrowed(row));
            }
            unchanged = Some(build.finish());
        });
        assert_eq!(cost.count_total, 0);
        assert_eq!(text.lease_count(), Some(leases));
        assert!(matches!(unchanged.unwrap(), CandidateRows::Changes(rows) if rows.is_empty()));
        let mut build = Build::new(&base, base.len());
        for (index, old) in base.iter().enumerate() {
            let mut row = borrowed(old);
            if index == 17 {
                row.bounds.x = -0.;
            }
            build.push(row);
        }
        let candidate = build.finish();
        assert!(
            matches!(&candidate, CandidateRows::Changes(rows) if rows.len()==1 && rows.capacity()==1)
        );
        assert_eq!(text.lease_count(), Some(leases + 1));
        assert_eq!(
            candidate.view(&base)[17].bounds.x.to_bits(),
            (-0f32).to_bits()
        );
        assert_eq!(base[17].bounds.x.to_bits(), 0f32.to_bits());
        candidate.acknowledge(&mut base);
        assert_eq!(base.as_ptr(), base_pointer);
        assert_eq!(base.capacity(), capacity);
        assert_eq!(text.lease_count(), Some(leases));
        assert_eq!(base[17].bounds.x.to_bits(), (-0f32).to_bits());
        println!(
            "ROW_HEADERS owned={} borrowed={} change={} candidate={} option_candidate={} prepared={} option_prepared={} rows={} p_hit={} c_hit={} runtime={}",
            size_of::<Presented>(),
            size_of::<Presented<&SharedText>>(),
            size_of::<Change>(),
            size_of::<CandidateRows>(),
            size_of::<Option<CandidateRows>>(),
            size_of::<Prepared>(),
            size_of::<Option<Prepared>>(),
            size_of::<Rows<'_>>(),
            size_of::<query::HitSheet<'_>>(),
            size_of::<query::HitSheet<'_, Rows<'_>>>(),
            size_of::<Runtime<()>>()
        );
    }
    #[test]
    fn overlay_iteration_and_topology_fallbacks_use_the_same_candidate_rows() {
        let text = SharedText::from(String::from("immutable row"));
        let base: Vec<_> = (0..32).map(|index| owned(index, &text)).collect();
        let mut build = Build::new(&base, base.len());
        for (index, old) in base.iter().enumerate() {
            let mut row = borrowed(old);
            if [1, 7, 19].contains(&index) {
                row.bounds.x = f32::from_bits(1);
            }
            build.push(row);
        }
        let candidate = build.finish();
        let view = candidate.view(&base);
        let expected: Vec<_> = (0..base.len())
            .map(|index| view[index].bounds.x.to_bits())
            .collect();
        assert_eq!(
            view.iter()
                .map(|row| row.bounds.x.to_bits())
                .collect::<Vec<_>>(),
            expected
        );
        assert_eq!(
            view.iter()
                .rev()
                .map(|row| row.bounds.x.to_bits())
                .collect::<Vec<_>>(),
            expected.iter().rev().copied().collect::<Vec<_>>()
        );
        for front in 0..33 {
            for back in 0..33 - front {
                let mut rows = view.iter();
                assert_eq!(
                    rows.nth(front).map(|row| row.bounds.x.to_bits()),
                    expected.get(front).copied()
                );
                let remaining = 32usize.saturating_sub(front + 1);
                assert_eq!(
                    rows.nth_back(back).map(|row| row.bounds.x.to_bits()),
                    remaining
                        .checked_sub(back + 1)
                        .map(|at| expected[front + 1 + at])
                );
            }
        }
        for topology in 0..4 {
            let mut build = Build::new(&base, 33);
            let mut order: Vec<_> = (0..32).collect();
            match topology {
                0 => order.swap(4, 5),
                1 => {
                    order.pop();
                }
                2 => order.push(31),
                _ => {}
            }
            for (index, &at) in order.iter().enumerate() {
                let mut row = borrowed(&base[at]);
                if topology == 3 && index == 12 {
                    row.parent = PresentedLink::new(Parent::NONE, false, None);
                }
                build.push(row);
            }
            let candidate = build.finish();
            assert!(matches!(candidate, CandidateRows::Full(_)));
            assert_eq!(
                candidate
                    .view(&base)
                    .iter()
                    .map(|row| row.identity)
                    .collect::<Vec<_>>(),
                order
                    .iter()
                    .map(|&at| base[at].identity)
                    .collect::<Vec<_>>()
            );
        }
    }
    #[test]
    fn dense_and_tiny_changes_fall_back_without_sparse_minimum_capacity_tax() {
        let text = SharedText::from(String::from("payload"));
        for count in [1, 32, 16384] {
            let mut base: Vec<_> = (0..count).map(|index| owned(index, &text)).collect();
            let mut build = Build::new(&base, count);
            for old in &base {
                let mut row = borrowed(old);
                row.hittable = false;
                build.push(row);
            }
            let candidate = build.finish();
            assert!(matches!(candidate, CandidateRows::Full(_)));
            candidate.acknowledge(&mut base);
            assert!(base.iter().all(|row| !row.hittable));
        }
        let base: Vec<_> = (0..32).map(|index| owned(index, &text)).collect();
        let equal = SharedText::from(String::from("payload"));
        assert_eq!(&*text, &*equal);
        let mut build = Build::new(&base, 32);
        for (index, old) in base.iter().enumerate() {
            let mut row = borrowed(old);
            if index == 2 {
                row.text = Some(&equal);
            }
            build.push(row);
        }
        assert!(matches!(build.finish(),CandidateRows::Changes(rows) if rows.len()==1));
    }
}

#[cfg(test)]
mod owner_tests;
