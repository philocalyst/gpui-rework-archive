// Copyright 2026 the GPUI Authors
// SPDX-License-Identifier: Apache-2.0 OR MIT

//! Scoped bulk cursor geometry without repeated source/prefix scans.
use super::{Cursor, cursor::line_cursor_rect};
use crate::BoundingBox;
use crate::layout::{Affinity, Cluster, ClusterPath, Layout, LineItem};
use crate::style::Brush;
use alloc::{vec, vec::Vec};

#[derive(Clone, Copy)]
struct Entry {
    path: ClusterPath,
    offset: f32,
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

    fn cluster(&self, byte: usize) -> Option<Cluster<'a, B>> {
        let index = *self.bytes.get(byte)? as usize;
        self.entries.get(index)?.path.cluster(self.layout)
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
        self.boundary_geometries(byte, width)
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

    // Keep large source-cluster reconstruction outside the cached-edge frame.
    #[inline(never)]
    fn boundary_geometries(&self, byte: usize, width: f32) -> Option<[BoundingBox; 2]> {
        let next = self.cluster(byte);
        let upstream = Cursor::from_source_cluster(self.layout, Affinity::Upstream, next.as_ref());
        if upstream.index() != byte {
            return None;
        }
        let previous = byte.checked_sub(1).and_then(|b| self.cluster(b));
        let clusters = [previous.as_ref(), next.as_ref()];
        // A present byte-zero cluster forces both cursors downstream. A
        // missing next cluster forces both to the upstream text endpoint.
        let same_edge = byte == 0 || next.is_none();
        let geometry = |cursor: Cursor| {
            cursor.geometry_with(self.layout, width, clusters, |cluster| {
                let index = self.bytes[cluster.text_range().start] as usize;
                self.entries[index].offset
            })
        };
        let first = geometry(upstream);
        Some([
            first,
            if same_edge {
                first
            } else {
                let downstream =
                    Cursor::from_source_cluster(self.layout, Affinity::Downstream, next.as_ref());
                geometry(downstream)
            },
        ])
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
