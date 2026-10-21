// Copyright 2026 the GPUI Authors
// SPDX-License-Identifier: Apache-2.0 OR MIT

//! Scoped bulk cursor geometry without repeated source/prefix scans.
use super::Cursor;
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
/// Source lookup and visual-prefix lookup are then constant time. Storage is
/// 16 bytes per shaped cluster plus four bytes per source byte, released with
/// this index. No field is added to Layout, Run, Cluster or Cursor. Invalid or
/// overlapping source ranges return None rather than publishing an index.
pub struct CursorGeometry<'a, B: Brush> {
    layout: &'a Layout<B>,
    entries: Vec<Entry>,
    bytes: Vec<u32>,
}

impl<'a, B: Brush> CursorGeometry<'a, B> {
    pub fn new(layout: &'a Layout<B>) -> Option<Self> {
        if layout.data.clusters.len() > u32::MAX as usize || layout.len() > u32::MAX as usize {
            return None;
        }
        let missing = Entry {
            path: ClusterPath::new(u32::MAX, u32::MAX, u32::MAX),
            offset: 0.0,
        };
        let mut result = Self {
            layout,
            entries: vec![missing; layout.data.clusters.len()],
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
                            let index = run.cluster_range().start + cluster.path().logical_index();
                            let entry = result.entries.get_mut(index)?;
                            if entry.path.line_index() != u32::MAX as usize {
                                return None;
                            }
                            *entry = Entry {
                                path: cluster.path(),
                                offset,
                            };
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
        Cursor::from_source_cluster(self.layout, affinity, self.cluster(byte))
    }

    /// The existing Cursor geometry policy, using cached source/prefix lookups.
    pub fn geometry(&self, cursor: Cursor, width: f32) -> BoundingBox {
        let clusters = cursor.visual_clusters_with(|byte| self.cluster(byte));
        cursor.geometry_with(self.layout, width, clusters, |cluster| {
            let index = cluster.run.cluster_range().start + cluster.path().logical_index();
            // Every cluster reachable through this borrowed layout's visual
            // neighbours was indexed above. The layout cannot mutate here.
            self.entries[index].offset
        })
    }
}
