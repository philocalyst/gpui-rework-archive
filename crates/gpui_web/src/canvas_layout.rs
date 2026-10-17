use gpui::{
    Bounds, CaretAffinity, CaretMovement, CaretPosition, InlineRangeGeometry, Pixels,
    PlatformTextLayout, Point, TextMovement, TextSelectionKind, VisualDirection, px,
};
use std::{cmp::Ordering, ops::Range, sync::Arc};

/// Canvas-measured geometry for one fallback grapheme in the original text.
#[derive(Clone, Debug, PartialEq)]
pub(crate) struct CanvasOverlay {
    /// The grapheme's original UTF-8 source range.
    pub(crate) source: Range<usize>,
    /// Its Canvas-measured bounds relative to the complete inline layout.
    pub(crate) bounds: Bounds<Pixels>,
    /// The visual line containing the grapheme.
    pub(crate) line_index: usize,
    /// Whether this grapheme is visually right-to-left.
    pub(crate) rtl: bool,
}

/// Retains native shaping and source indices while replacing fallback geometry with Canvas boxes.
#[derive(Debug)]
pub(crate) struct CanvasPlatformTextLayout {
    inner: Arc<dyn PlatformTextLayout>,
    overlays: Arc<[CanvasOverlay]>,
}

impl CanvasPlatformTextLayout {
    pub(crate) fn new(inner: Arc<dyn PlatformTextLayout>, overlays: Vec<CanvasOverlay>) -> Self {
        let mut overlays = overlays;
        overlays.sort_by(|left, right| {
            left.source
                .start
                .cmp(&right.source.start)
                .then_with(|| left.source.end.cmp(&right.source.end))
        });
        Self {
            inner,
            overlays: overlays.into(),
        }
    }

    fn hit_overlay(&self, point: Point<Pixels>) -> Option<&CanvasOverlay> {
        let mut hits = self
            .overlays
            .iter()
            .filter(|overlay| contains(overlay.bounds, point));
        let hit = hits.next()?;
        // At touching or overlapping Canvas boxes, source order is not visual
        // order for mixed bidi text. Let the native full-context layout resolve
        // the shared edge and preserve its bidi affinity.
        if hits.next().is_some() {
            None
        } else {
            Some(hit)
        }
    }

    fn caret_for_overlay_hit(overlay: &CanvasOverlay, point: Point<Pixels>) -> CaretPosition {
        let midpoint = overlay.bounds.origin.x + overlay.bounds.size.width / 2.0;
        let visual_left = point.x <= midpoint;
        let logical_start = visual_left != overlay.rtl;
        if logical_start {
            CaretPosition::attached_to_next_cluster(overlay.source.start)
        } else {
            CaretPosition::attached_to_previous_cluster(overlay.source.end)
        }
    }

    fn overlay_caret_edge(&self, caret: CaretPosition) -> Option<(&CanvasOverlay, Pixels)> {
        self.overlays.iter().find_map(|overlay| {
            if caret.index == overlay.source.start && caret.affinity == CaretAffinity::Downstream {
                let x = if overlay.rtl {
                    overlay.bounds.origin.x + overlay.bounds.size.width
                } else {
                    overlay.bounds.origin.x
                };
                Some((overlay, x))
            } else if caret.index == overlay.source.end && caret.affinity == CaretAffinity::Upstream
            {
                let x = if overlay.rtl {
                    overlay.bounds.origin.x
                } else {
                    overlay.bounds.origin.x + overlay.bounds.size.width
                };
                Some((overlay, x))
            } else {
                None
            }
        })
    }

    fn intersects_source(overlay: &CanvasOverlay, range: &Range<usize>) -> bool {
        overlay.source.start < range.end && range.start < overlay.source.end
    }

    fn append_overlay_geometry(
        &self,
        range: &Range<usize>,
        mut geometry: Vec<InlineRangeGeometry>,
    ) -> Vec<InlineRangeGeometry> {
        for overlay in self
            .overlays
            .iter()
            .filter(|overlay| Self::intersects_source(overlay, range))
        {
            // Replace only geometry for this exact source range. Coordinate
            // filtering can erase a neighboring collapsed cluster at a shared
            // visual edge, especially when bidi reverses source order.
            let replaced = self
                .inner
                .inline_geometry(overlay.source.clone())
                .unwrap_or_default();
            geometry.retain(|native| !replaced.contains(native));
            let duplicate = geometry.iter().any(|item| {
                item.visual_line_index == overlay.line_index && item.bounds == overlay.bounds
            });
            if !duplicate {
                geometry.push(InlineRangeGeometry {
                    visual_line_index: overlay.line_index,
                    bounds: overlay.bounds,
                });
            }
        }
        geometry.sort_by(|left, right| {
            left.visual_line_index
                .cmp(&right.visual_line_index)
                .then_with(|| {
                    left.bounds
                        .origin
                        .x
                        .partial_cmp(&right.bounds.origin.x)
                        .unwrap_or(Ordering::Equal)
                })
        });
        geometry
    }

    fn append_overlay_selection_bounds(
        &self,
        range: &Range<usize>,
        line_height: Pixels,
        mut bounds: Vec<Bounds<Pixels>>,
    ) -> Vec<Bounds<Pixels>> {
        for overlay in self
            .overlays
            .iter()
            .filter(|overlay| Self::intersects_source(overlay, range))
        {
            // Remove only the inner rectangle associated with this exact source
            // span, never a neighboring zero-advance character sharing its x.
            let replaced = self
                .inner
                .selection_bounds(overlay.source.clone(), line_height);
            bounds.retain(|native| !replaced.contains(native));
            let duplicate = bounds.iter().any(|existing| *existing == overlay.bounds);
            if !duplicate {
                bounds.push(overlay.bounds);
            }
        }
        bounds.sort_by(|left, right| {
            left.origin
                .y
                .partial_cmp(&right.origin.y)
                .unwrap_or(Ordering::Equal)
                .then_with(|| {
                    left.origin
                        .x
                        .partial_cmp(&right.origin.x)
                        .unwrap_or(Ordering::Equal)
                })
        });
        bounds
    }
}

fn contains(bounds: Bounds<Pixels>, point: Point<Pixels>) -> bool {
    point.x >= bounds.origin.x
        && point.x <= bounds.origin.x + bounds.size.width
        && point.y >= bounds.origin.y
        && point.y <= bounds.origin.y + bounds.size.height
}

impl PlatformTextLayout for CanvasPlatformTextLayout {
    fn len(&self) -> usize {
        self.inner.len()
    }

    fn line_count(&self) -> usize {
        self.inner.line_count()
    }

    fn size(&self) -> gpui::Size<Pixels> {
        self.inner.size()
    }

    fn byte_index_from_pixel_point(
        &self,
        pixel_point: Point<Pixels>,
        line_height: Pixels,
    ) -> Result<usize, usize> {
        if let Some(overlay) = self.hit_overlay(pixel_point) {
            return Ok(Self::caret_for_overlay_hit(overlay, pixel_point).index);
        }
        self.inner
            .byte_index_from_pixel_point(pixel_point, line_height)
    }

    fn caret_from_pixel_point(
        &self,
        pixel_point: Point<Pixels>,
        line_height: Pixels,
    ) -> Result<CaretPosition, CaretPosition> {
        if let Some(overlay) = self.hit_overlay(pixel_point) {
            return Ok(Self::caret_for_overlay_hit(overlay, pixel_point));
        }
        self.inner.caret_from_pixel_point(pixel_point, line_height)
    }

    fn caret_bounds(&self, caret: CaretPosition, line_height: Pixels) -> Option<Bounds<Pixels>> {
        if let Some((overlay, x)) = self.overlay_caret_edge(caret) {
            let mut bounds = self
                .inner
                .caret_bounds(caret, line_height)
                .unwrap_or(overlay.bounds);
            bounds.origin.x = x;
            if bounds.size.width <= px(0.) {
                bounds.size.width = px(1.);
            }
            Some(bounds)
        } else {
            self.inner.caret_bounds(caret, line_height)
        }
    }

    fn normalized_caret(&self, caret: CaretPosition) -> CaretPosition {
        self.inner.normalized_caret(caret)
    }

    fn adjacent_visual_caret(
        &self,
        caret: CaretPosition,
        direction: VisualDirection,
    ) -> Option<CaretPosition> {
        if let Some((overlay, _)) = self.overlay_caret_edge(caret) {
            let toward_other_edge = if caret.index == overlay.source.start {
                direction
                    == if overlay.rtl {
                        VisualDirection::Left
                    } else {
                        VisualDirection::Right
                    }
            } else {
                direction
                    == if overlay.rtl {
                        VisualDirection::Right
                    } else {
                        VisualDirection::Left
                    }
            };
            if toward_other_edge {
                return Some(if caret.index == overlay.source.start {
                    CaretPosition::attached_to_previous_cluster(overlay.source.end)
                } else {
                    CaretPosition::attached_to_next_cluster(overlay.source.start)
                });
            }
        }
        self.inner.adjacent_visual_caret(caret, direction)
    }

    fn selection_bounds(
        &self,
        byte_range: Range<usize>,
        line_height: Pixels,
    ) -> Vec<Bounds<Pixels>> {
        let native = self.inner.selection_bounds(byte_range.clone(), line_height);
        self.append_overlay_selection_bounds(&byte_range, line_height, native)
    }

    fn inline_geometry(&self, range: Range<usize>) -> Option<Vec<InlineRangeGeometry>> {
        if range.is_empty() {
            return None;
        }
        let native = self
            .inner
            .inline_geometry(range.clone())
            .unwrap_or_default();
        Some(self.append_overlay_geometry(&range, native))
    }

    fn inline_geometry_for_ranges(&self, ranges: &[Range<usize>]) -> Vec<Vec<InlineRangeGeometry>> {
        ranges
            .iter()
            .map(|range| self.inline_geometry(range.clone()).unwrap_or_default())
            .collect()
    }

    fn logical_cluster_before(&self, caret: CaretPosition) -> Option<Range<usize>> {
        self.inner.logical_cluster_before(caret)
    }

    fn logical_cluster_after(&self, caret: CaretPosition) -> Option<Range<usize>> {
        self.inner.logical_cluster_after(caret)
    }

    fn caret_movement(
        &self,
        caret: CaretPosition,
        movement: TextMovement,
        vertical_navigation_x: Option<Pixels>,
    ) -> CaretMovement {
        self.inner
            .caret_movement(caret, movement, vertical_navigation_x)
    }

    fn selection_from_pixel_point(
        &self,
        pixel_point: Point<Pixels>,
        line_height: Pixels,
        kind: TextSelectionKind,
    ) -> Range<usize> {
        let native = self
            .inner
            .selection_from_pixel_point(pixel_point, line_height, kind);
        if let Some(overlay) = self.hit_overlay(pixel_point) {
            if native.is_empty() {
                return overlay.source.clone();
            }
            return native.start.min(overlay.source.start)..native.end.max(overlay.source.end);
        }
        native
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui::{point, size};

    #[derive(Debug)]
    struct FixtureLayout;

    fn rect(x: f32, y: f32, width: f32, height: f32) -> Bounds<Pixels> {
        Bounds {
            origin: point(px(x), px(y)),
            size: size(px(width), px(height)),
        }
    }

    fn fixture_overlays() -> Vec<CanvasOverlay> {
        vec![
            CanvasOverlay {
                source: 2..6,
                bounds: rect(10., 0., 20., 20.),
                line_index: 0,
                rtl: false,
            },
            CanvasOverlay {
                source: 8..12,
                bounds: rect(100., 20., 20., 20.),
                line_index: 1,
                rtl: true,
            },
        ]
    }

    impl PlatformTextLayout for FixtureLayout {
        fn len(&self) -> usize {
            12
        }
        fn line_count(&self) -> usize {
            2
        }
        fn size(&self) -> gpui::Size<Pixels> {
            size(px(140.), px(40.))
        }

        fn byte_index_from_pixel_point(&self, _: Point<Pixels>, _: Pixels) -> Result<usize, usize> {
            Err(0)
        }

        fn caret_from_pixel_point(
            &self,
            point: Point<Pixels>,
            _: Pixels,
        ) -> Result<CaretPosition, CaretPosition> {
            if point.x == px(20.) {
                Ok(CaretPosition::attached_to_previous_cluster(5))
            } else {
                Err(CaretPosition::default())
            }
        }

        fn caret_bounds(&self, caret: CaretPosition, _: Pixels) -> Option<Bounds<Pixels>> {
            let (x, y) = match (caret.index, caret.affinity) {
                (2, CaretAffinity::Downstream) => (10., 0.),
                (6, CaretAffinity::Upstream) => (30., 0.),
                (8, CaretAffinity::Downstream) => (120., 20.),
                (12, CaretAffinity::Upstream) => (100., 20.),
                _ => return None,
            };
            Some(rect(x, y, 0., 20.))
        }

        fn normalized_caret(&self, caret: CaretPosition) -> CaretPosition {
            caret
        }

        fn adjacent_visual_caret(
            &self,
            _: CaretPosition,
            _: VisualDirection,
        ) -> Option<CaretPosition> {
            None
        }

        fn selection_bounds(&self, range: Range<usize>, _: Pixels) -> Vec<Bounds<Pixels>> {
            let first = rect(10., 0., 0., 20.);
            let second = rect(100., 20., 0., 20.);
            if range == (0..12) {
                vec![
                    rect(0., 0., 10., 20.),
                    first,
                    rect(10., 0., 0., 8.),
                    rect(30., 0., 10., 20.),
                    second,
                ]
            } else if range == (2..6) {
                vec![first]
            } else if range == (8..12) {
                vec![second]
            } else {
                Vec::new()
            }
        }

        fn logical_cluster_before(&self, caret: CaretPosition) -> Option<Range<usize>> {
            Some(caret.index.saturating_sub(1)..caret.index)
        }

        fn logical_cluster_after(&self, caret: CaretPosition) -> Option<Range<usize>> {
            Some(caret.index..caret.index + 1)
        }

        fn caret_movement(
            &self,
            caret: CaretPosition,
            _: TextMovement,
            vertical_navigation_x: Option<Pixels>,
        ) -> CaretMovement {
            CaretMovement {
                result: caret,
                vertical_navigation_x,
            }
        }

        fn selection_from_pixel_point(
            &self,
            _: Point<Pixels>,
            _: Pixels,
            _: TextSelectionKind,
        ) -> Range<usize> {
            0..0
        }
    }

    fn layout(overlays: Vec<CanvasOverlay>) -> CanvasPlatformTextLayout {
        CanvasPlatformTextLayout::new(Arc::new(FixtureLayout), overlays)
    }

    #[test]
    fn hit_mapping_uses_visual_side_and_rtl_direction() {
        let wrapped = layout(fixture_overlays());
        assert_eq!(wrapped.len(), 12);
        assert_eq!(
            wrapped
                .caret_from_pixel_point(point(px(11.), px(8.)), px(20.))
                .unwrap()
                .index,
            2
        );
        assert_eq!(
            wrapped
                .caret_from_pixel_point(point(px(29.), px(8.)), px(20.))
                .unwrap()
                .index,
            6
        );
        assert_eq!(
            wrapped
                .caret_from_pixel_point(point(px(101.), px(28.)), px(20.))
                .unwrap()
                .index,
            12
        );
        assert_eq!(
            wrapped.byte_index_from_pixel_point(point(px(119.), px(28.)), px(20.)),
            Ok(8)
        );
    }

    #[test]
    fn caret_geometry_and_visual_steps_use_only_canonical_overlay_affinities() {
        let wrapped = layout(fixture_overlays());
        assert_eq!(
            wrapped
                .caret_bounds(CaretPosition::attached_to_next_cluster(2), px(20.))
                .unwrap(),
            rect(10., 0., 1., 20.)
        );
        assert_eq!(
            wrapped
                .caret_bounds(CaretPosition::attached_to_next_cluster(8), px(20.))
                .unwrap(),
            rect(120., 20., 1., 20.)
        );
        assert_eq!(
            wrapped.adjacent_visual_caret(
                CaretPosition::attached_to_next_cluster(2),
                VisualDirection::Right,
            ),
            Some(CaretPosition::attached_to_previous_cluster(6))
        );
        assert_eq!(
            wrapped.adjacent_visual_caret(
                CaretPosition::attached_to_next_cluster(8),
                VisualDirection::Left,
            ),
            Some(CaretPosition::attached_to_previous_cluster(12))
        );
        assert!(
            wrapped
                .caret_bounds(CaretPosition::attached_to_previous_cluster(2), px(20.))
                .is_none(),
            "the opposite affinity at a shared bidi boundary belongs to the neighbor"
        );
    }

    #[test]
    fn selection_and_inline_geometry_replace_only_exact_source_rectangles() {
        let wrapped = layout(fixture_overlays());
        let selection = wrapped.selection_bounds(0..12, px(20.));
        assert_eq!(
            selection,
            vec![
                rect(0., 0., 10., 20.),
                rect(10., 0., 0., 8.),
                rect(10., 0., 20., 20.),
                rect(30., 0., 10., 20.),
                rect(100., 20., 20., 20.),
            ]
        );

        let inline = wrapped.inline_geometry(0..12).unwrap();
        assert_eq!(inline.len(), 5);
        assert!(
            inline
                .iter()
                .any(|item| item.bounds == rect(10., 0., 0., 8.))
        );
        assert!(
            inline
                .iter()
                .any(|item| item.bounds == rect(10., 0., 20., 20.))
        );
        assert!(inline.iter().any(|item| {
            item.bounds == rect(100., 20., 20., 20.) && item.visual_line_index == 1
        }));
    }

    #[test]
    fn edge_touching_boxes_defer_to_native_affinity() {
        let overlays = vec![
            CanvasOverlay {
                source: 4..6,
                bounds: rect(10., 0., 10., 20.),
                line_index: 0,
                rtl: false,
            },
            CanvasOverlay {
                source: 6..8,
                bounds: rect(20., 0., 10., 20.),
                line_index: 0,
                rtl: false,
            },
        ];
        let wrapped = layout(overlays);
        assert_eq!(
            wrapped.caret_from_pixel_point(point(px(20.), px(10.)), px(20.)),
            Ok(CaretPosition::attached_to_previous_cluster(5)),
            "an ambiguous shared edge is resolved by the native layout"
        );
    }

    #[test]
    fn mixed_bidi_visual_edge_defers_to_native_affinity() {
        let overlays = vec![
            CanvasOverlay {
                source: 4..6,
                bounds: rect(20., 0., 10., 20.),
                line_index: 0,
                rtl: false,
            },
            CanvasOverlay {
                source: 6..8,
                bounds: rect(10., 0., 10., 20.),
                line_index: 0,
                rtl: true,
            },
        ];
        let wrapped = layout(overlays);
        assert_eq!(
            wrapped.caret_from_pixel_point(point(px(20.), px(10.)), px(20.)),
            Ok(CaretPosition::attached_to_previous_cluster(5))
        );
    }
}
