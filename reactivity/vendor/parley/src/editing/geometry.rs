// Copyright 2026 the GPUI Authors
// SPDX-License-Identifier: Apache-2.0 OR MIT

//! Scoped bulk cursor geometry without repeated source/prefix scans.
use super::{Cursor, cursor::line_cursor_rect};
use crate::BoundingBox;
use crate::layout::{Affinity, Cluster, ClusterPath, Layout, Line, LineItem};
use crate::style::Brush;
use alloc::{vec, vec::Vec};
use core::ops::ControlFlow;
use parley_engine::shape::Whitespace;

#[derive(Clone, Copy)]
struct Entry {
    path: ClusterPath,
    offset: f32,
}

#[derive(Clone, Copy)]
struct RunSlot {
    item: u32,
    origin: f32,
}

// Source shaping appends one item for every shaped run. A line commits a
// contiguous item interval and can omit only its edge runs. Bidi permutes that
// interval without changing stored identities; boxes use a separate domain.
fn source_runs<'s, B: Brush>(
    line: &Line<'_, B>,
    inline: &'s mut [RunSlot; 1],
    spill: &'s mut Vec<RunSlot>,
) -> Option<(usize, &'s mut [RunSlot])> {
    use crate::layout::data::LayoutItemKind;
    let items = &line.layout.data.line_items[line.data.item_range.clone()];
    // This is a visual item position, not a shaped/source run identity. Keep
    // the indexed implementation for a line that cannot reserve MAX as empty.
    if items.len() > u32::MAX as usize {
        return None;
    }
    let mut min = usize::MAX;
    let mut max = 0;
    let mut count = 0;
    for item in items {
        if item.kind == LayoutItemKind::TextRun {
            if item.index >= line.layout.data.shaped_text.runs().len()
                || item.index >= line.layout.data.runs.len()
            {
                return None;
            }
            min = min.min(item.index);
            max = max.max(item.index);
            count += 1;
        }
    }
    if min == usize::MAX {
        return Some((0, &mut inline[..0]));
    }
    let span = max.checked_sub(min)?.checked_add(1)?;
    if span != count {
        return None;
    }
    let empty = RunSlot {
        item: u32::MAX,
        origin: 0.,
    };
    let slots = if span == 1 {
        inline[0] = empty;
        &mut inline[..]
    } else {
        spill.clear();
        spill.resize(span, empty);
        spill.as_mut_slice()
    };
    for (position, item) in items.iter().enumerate() {
        if item.kind == LayoutItemKind::TextRun {
            if slots[item.index - min].item != u32::MAX {
                return None;
            }
            slots[item.index - min].item = u32::try_from(position).ok()?;
        }
    }
    Some((min, slots))
}

/// Transient lookup over one immutably borrowed, fully line-broken layout.
///
/// Construction visits each visible cluster and covered source byte once.
/// Byte-to-entry and visual-prefix lookup are then constant time; resolving
/// a stored path uses the engine's atom lookup. Storage is
/// 16 bytes per source scalar of entry capacity plus four bytes per source byte, released with
/// this index. No field is added to Layout, Run, Cluster or Cursor. Invalid or
/// overlapping source ranges return None rather than publishing an index.
pub struct CursorGeometry<'a, B: Brush> {
    layout: &'a Layout<B>,
    entries: Vec<Entry>,
    bytes: Vec<u32>,
}

impl<'a, B: Brush> CursorGeometry<'a, B> {
    /// Visit source byte requests without building the random-access index.
    ///
    /// Complete source-range validation precedes every callback. `None` means
    /// the same font/range rejection as [`Self::new`], with no callback invoked.
    /// Otherwise the callback can stop traversal with its own concrete error.
    /// Pairs are upstream first; `None` pairs mean ordinary cursors snap away
    /// from that byte. Repeated requests are supported. A decreasing request
    /// switches the remaining requests to ordinary direct cursor geometry.
    ///
    /// Scratch is one reusable source-run slot table per line and one reusable
    /// RTL visual-offset buffer. Neither survives this immutable layout borrow.
    /// Single-run lines use a stack slot; multiple runs spill into the table.
    /// Source lengths above `u32::MAX` retain the exact indexed implementation,
    /// because the engine's stored byte offsets can wrap in that domain.
    pub fn try_for_each_pair<E>(
        layout: &'a Layout<B>,
        offsets: impl IntoIterator<Item = usize>,
        width: f32,
        mut visit: impl FnMut(usize, Option<[BoundingBox; 2]>) -> ControlFlow<E>,
    ) -> Option<ControlFlow<E>> {
        if layout.data.text_len > u32::MAX as usize {
            return visit_indexed(layout, offsets, width, &mut visit);
        }
        if layout.data.shaped_text.characters().len() > u32::MAX as usize
            || layout.len() > u32::MAX as usize
        {
            return None;
        }
        let mut inline = [RunSlot {
            item: u32::MAX,
            origin: 0.,
        }];
        let mut spill = Vec::new();
        let mut count = 0_usize;
        let mut previous_end = 0;
        let mut rtl_capacity = 0;
        for line in layout.lines() {
            let Some((_, slots)) = source_runs(&line, &mut inline, &mut spill) else {
                // Preserve exact old admission for duplicate/fragmented run
                // identities, including empty ranges the old map can accept.
                return visit_indexed(layout, offsets, width, &mut visit);
            };
            for slot in slots {
                if slot.item == u32::MAX {
                    continue;
                }
                let run = line.item(slot.item as usize)?.run()?;
                let mut run_count = 0;
                let full = run.full_slice();
                // Only source ranges/counts are needed for checked admission.
                // Layout's internal grapheme/atom invariants remain trusted.
                for grapheme in run.line_slice().graphemes_start() {
                    // The old index explicitly exempts the empty layout's
                    // synthetic metrics space from source/entry validation.
                    if layout.data.text_len != 0 {
                        let range = full.text_byte_range(grapheme.char_range());
                        if range.start > range.end || range.end > layout.data.text_len {
                            return None;
                        }
                        if !range.is_empty() {
                            if range.start < previous_end {
                                // A decreasing range can be disjoint rather
                                // than overlapping. Preserve the byte map's
                                // exact admission for this unexpected ordering.
                                return visit_indexed(layout, offsets, width, &mut visit);
                            }
                            previous_end = range.end;
                        }
                        u32::try_from(count).ok()?;
                    }
                    count = count.checked_add(1)?;
                    run_count += 1;
                }
                if run.is_rtl() {
                    rtl_capacity = rtl_capacity.max(run_count);
                }
            }
        }
        // Both buffers now have their maximum required capacity. No font
        // admission or scratch growth remains after the first callback.
        let mut rtl = Vec::with_capacity(rtl_capacity);
        Some(visit_source_pairs(
            layout,
            offsets.into_iter(),
            width,
            &mut visit,
            &mut inline,
            &mut spill,
            &mut rtl,
        ))
    }

    pub fn new(layout: &'a Layout<B>) -> Option<Self> {
        if layout.data.shaped_text.characters().len() > u32::MAX as usize
            || layout.len() > u32::MAX as usize
        {
            return None;
        }
        let mut result = Self {
            layout,
            entries: Vec::with_capacity(layout.data.shaped_text.characters().len()),
            bytes: vec![u32::MAX; layout.data.text_len],
        };
        for line in layout.lines() {
            let mut origin = line.metrics().offset;
            for item in line.items_nonpositioned() {
                match item {
                    LineItem::InlineBox(inline_box) => origin += inline_box.width,
                    LineItem::Run(run) => {
                        let mut offset = origin;
                        for cluster in run.visual_clusters() {
                            let index = result.entries.len();
                            result.entries.push(Entry {
                                path: cluster.path(),
                                offset,
                            });
                            offset += cluster.advance();
                            // The upstream empty-layout metrics space is not
                            // document text and has no legal source byte.
                            if layout.data.text_len != 0 {
                                let range = cluster.text_range();
                                let bytes = result.bytes.get_mut(range)?;
                                if bytes.iter().any(|&previous| previous != u32::MAX) {
                                    return None;
                                }
                                bytes.fill(u32::try_from(index).ok()?);
                            }
                        }
                        // Preserve visual_offset's exact f32 operation order:
                        // preceding runs add their complete advance, while a
                        // prefix within this run sums individual clusters.
                        origin += run.advance();
                    }
                }
            }
        }
        Some(result)
    }

    fn entry(&self, byte: usize) -> Option<&Entry> {
        self.entries.get(*self.bytes.get(byte)? as usize)
    }

    fn cluster(&self, byte: usize) -> Option<Cluster<'a, B>> {
        self.entry(byte)?.path.cluster(self.layout)
    }

    /// The same snapping and endpoint/affinity policy as Cursor::from_byte_index.
    pub fn cursor(&self, byte: usize, affinity: Affinity) -> Cursor {
        Cursor::from_source_cluster(self.layout, affinity, self.cluster(byte).as_ref())
    }

    /// Both affinities at an exact source boundary, upstream first.
    /// Returns None when ordinary cursor construction would snap away from byte.
    /// Shared source neighbours are resolved once. Within one run, adjacent
    /// visual entries also share the exact f32 boundary recurrence, so their
    /// two rectangles need only one geometry evaluation.
    pub fn geometries_at(&self, byte: usize, width: f32) -> Option<[BoundingBox; 2]> {
        if let Some(bounds) = self.shared_edge(byte, width) {
            return Some([bounds; 2]);
        }
        pair_from_entries(
            self.layout,
            byte,
            width,
            byte.checked_sub(1)
                .and_then(|previous| self.entry(previous)),
            self.entry(byte),
        )
    }

    fn shared_edge(&self, byte: usize, width: f32) -> Option<BoundingBox> {
        let previous_index = *self.bytes.get(byte.checked_sub(1)?)? as usize;
        let next_index = *self.bytes.get(byte)? as usize;
        let previous = self.entries.get(previous_index)?;
        let next = self.entries.get(next_index)?;
        if previous.path.line_index != next.path.line_index
            || previous.path.run_index != next.path.run_index
        {
            return None;
        }
        let line = next.path.line(self.layout)?;
        let rtl = line.item(next.path.run_index())?.run()?.is_rtl();
        let adjacent = if rtl {
            next_index.checked_add(1) == Some(previous_index)
        } else {
            previous_index.checked_add(1) == Some(next_index)
        };
        // Different adjacent byte owners prove contiguous source ranges:
        // the index constructor filled each range and rejected overlaps.
        // Visual adjacency in one run proves the exact f32 prefix edge.
        adjacent.then(|| {
            line_cursor_rect(
                &line,
                width,
                if rtl { previous.offset } else { next.offset },
            )
        })
    }

    /// The existing Cursor geometry policy, using cached source/prefix lookups.
    pub fn geometry(&self, cursor: Cursor, width: f32) -> BoundingBox {
        let clusters = [
            cursor
                .index()
                .checked_sub(1)
                .and_then(|byte| self.cluster(byte)),
            self.cluster(cursor.index()),
        ];
        cursor.geometry_with(
            self.layout,
            width,
            clusters.each_ref().map(Option::as_ref),
            |cluster| {
                let index = self.bytes[cluster.text_range().start] as usize;
                // Every cluster reachable through this borrowed layout's visual
                // neighbours was indexed above. The layout cannot mutate here.
                self.entries[index].offset
            },
        )
    }
}

fn direct_pair<B: Brush>(layout: &Layout<B>, byte: usize, width: f32) -> Option<[BoundingBox; 2]> {
    let upstream = Cursor::from_byte_index(layout, byte, Affinity::Upstream);
    if upstream.index() != byte {
        return None;
    }
    Some([
        upstream.geometry(layout, width),
        Cursor::from_byte_index(layout, byte, Affinity::Downstream).geometry(layout, width),
    ])
}

// Indexed and monotonic byte owners carry the same exact visual prefixes.
// Keep reconstruction cold and apply one shared cursor endpoint/affinity policy.
#[inline(never)]
fn pair_from_entries<B: Brush>(
    layout: &Layout<B>,
    byte: usize,
    width: f32,
    previous: Option<&Entry>,
    next: Option<&Entry>,
) -> Option<[BoundingBox; 2]> {
    let downstream = next.and_then(|entry| entry.path.cluster(layout));
    let upstream_cursor =
        Cursor::from_source_cluster(layout, Affinity::Upstream, downstream.as_ref());
    if upstream_cursor.index() != byte {
        return None;
    }
    let upstream = previous.and_then(|entry| entry.path.cluster(layout));
    let clusters = [upstream.as_ref(), downstream.as_ref()];
    let geometry = |cursor: Cursor| {
        cursor.geometry_with(layout, width, clusters, |cluster| {
            [previous, next]
                .into_iter()
                .flatten()
                .find(|entry| entry.path == cluster.path())
                .expect("geometry reborrows one of the two source-owner paths")
                .offset
        })
    };
    let first = geometry(upstream_cursor);
    Some([
        first,
        if byte == 0 || downstream.is_none() {
            first
        } else {
            geometry(Cursor::from_source_cluster(
                layout,
                Affinity::Downstream,
                downstream.as_ref(),
            ))
        },
    ])
}

fn visit_indexed<B: Brush, E>(
    layout: &Layout<B>,
    offsets: impl IntoIterator<Item = usize>,
    width: f32,
    visit: &mut impl FnMut(usize, Option<[BoundingBox; 2]>) -> ControlFlow<E>,
) -> Option<ControlFlow<E>> {
    let index = CursorGeometry::new(layout)?;
    Some((|| {
        for byte in offsets {
            visit(byte, index.geometries_at(byte, width))?;
        }
        ControlFlow::Continue(())
    })())
}

fn visit_direct<B: Brush, E>(
    layout: &Layout<B>,
    offsets: impl Iterator<Item = usize>,
    width: f32,
    visit: &mut impl FnMut(usize, Option<[BoundingBox; 2]>) -> ControlFlow<E>,
) -> ControlFlow<E> {
    for byte in offsets {
        visit(byte, direct_pair(layout, byte, width))?;
    }
    ControlFlow::Continue(())
}

fn visit_source_pairs<B: Brush, E>(
    layout: &Layout<B>,
    offsets: impl Iterator<Item = usize>,
    width: f32,
    visit: &mut impl FnMut(usize, Option<[BoundingBox; 2]>) -> ControlFlow<E>,
    inline: &mut [RunSlot; 1],
    spill: &mut Vec<RunSlot>,
    rtl: &mut Vec<f32>,
) -> ControlFlow<E> {
    let mut offsets = offsets.peekable();
    let mut last_request = None;
    let mut previous_owner = None;
    let mut previous_owner_end = 0;
    for line in layout.lines() {
        let (min, slots) =
            source_runs(&line, inline, spill).expect("preflight verified run identities");
        let mut origin = line.metrics().offset;
        for (position, item) in line.items_nonpositioned().enumerate() {
            match item {
                LineItem::InlineBox(inline_box) => origin += inline_box.width,
                LineItem::Run(run) => {
                    let identity =
                        line.layout.data.line_items[line.data.item_range.start + position].index;
                    slots[identity - min].origin = origin;
                    origin += run.advance();
                }
            }
        }
        for slot in slots.iter().copied().filter(|slot| slot.item != u32::MAX) {
            let run = line.item(slot.item as usize).unwrap().run().unwrap();
            let mut prefix = slot.origin;
            rtl.clear();
            if run.is_rtl() {
                run.try_for_each_caret_cluster(true, |run, atom, grapheme| {
                    rtl.push(prefix);
                    prefix += run
                        .line_spacing()
                        .grapheme_advance(atom, grapheme, run.is_rtl());
                    ControlFlow::<E>::Continue(())
                })?;
            }
            let mut previous_end = 0;
            let mut previous_offset = 0.;
            let mut previous_shared = false;
            let full = run.full_slice();
            let mut logical_index = 0;
            let flow = run.try_for_each_caret_cluster(false, |run, atom, grapheme| {
                let range = full.text_byte_range(grapheme.char_range());
                let offset = if run.is_rtl() {
                    rtl[rtl.len() - logical_index - 1]
                } else {
                    let offset = prefix;
                    prefix += run
                        .line_spacing()
                        .grapheme_advance(atom, grapheme, run.is_rtl());
                    offset
                };
                logical_index += 1;
                // Empty ranges, including the empty layout's metrics space,
                // never own a byte in the original random-access byte map.
                if range.is_empty() || layout.data.text_len == 0 {
                    previous_shared = false;
                    return ControlFlow::Continue(());
                }
                let current = Entry {
                    path: ClusterPath::new(run.line_index, run.index, grapheme.char_range().start),
                    offset,
                };
                while let Some(&byte) = offsets.peek().filter(|&&byte| byte < range.end) {
                    if last_request.is_some_and(|previous| byte < previous) {
                        // Break can complete successfully after draining the
                        // remaining requests through the direct fallback.
                        return ControlFlow::Break(visit_direct(
                            layout,
                            offsets.by_ref(),
                            width,
                            visit,
                        ));
                    }
                    offsets.next();
                    last_request = Some(byte);
                    let pair = if byte == range.start {
                        if previous_shared
                            && previous_end == byte
                            && grapheme.whitespace() != Whitespace::Newline
                        {
                            let bounds = line_cursor_rect(
                                &line,
                                width,
                                if run.is_rtl() {
                                    previous_offset
                                } else {
                                    offset
                                },
                            );
                            Some([bounds; 2])
                        } else {
                            pair_from_entries(
                                layout,
                                byte,
                                width,
                                previous_owner
                                    .as_ref()
                                    .filter(|_| previous_owner_end == byte),
                                Some(&current),
                            )
                        }
                    } else if byte > range.start {
                        // The ordinary cursor canonicalizes an in-cluster
                        // byte to its start, so this request would snap away.
                        None
                    } else {
                        pair_from_entries(
                            layout,
                            byte,
                            width,
                            previous_owner
                                .as_ref()
                                .filter(|_| previous_owner_end == byte),
                            None,
                        )
                    };
                    visit(byte, pair).map_break(ControlFlow::Break)?;
                }
                previous_end = range.end;
                previous_offset = offset;
                previous_shared = !range.is_empty() && grapheme.whitespace() != Whitespace::Newline;
                previous_owner = Some(current);
                previous_owner_end = range.end;
                ControlFlow::Continue(())
            });
            if let ControlFlow::Break(completion) = flow {
                return completion;
            }
        }
    }
    while let Some(&byte) = offsets.peek() {
        if last_request.is_some_and(|previous| byte < previous) {
            return visit_direct(layout, offsets, width, visit);
        }
        offsets.next();
        last_request = Some(byte);
        visit(
            byte,
            pair_from_entries(
                layout,
                byte,
                width,
                previous_owner
                    .as_ref()
                    .filter(|_| previous_owner_end == byte),
                None,
            ),
        )?;
    }
    ControlFlow::Continue(())
}
