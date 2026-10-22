//! Text geometry follows the exact C/P rows, independently from mutable L.
use super::*;
use std::sync::Arc;

pub(super) struct Entry {
    pub row: u32,
    pub origin: Point,
    pub map: Arc<gpui_canvas::TextGeometry>,
}
#[derive(Default)]
pub(super) struct TextResources {
    pub system: Option<TextSystem>,
    pub presented: Vec<Entry>,
    pub candidate: Option<Vec<Entry>>,
}
impl TextResources {
    pub fn unused(&self) -> bool {
        self.system.is_none() && self.presented.is_empty() && self.candidate.is_none()
    }
    pub fn acknowledge(&mut self) {
        if let Some(column) = self.candidate.take() {
            self.presented = column;
        }
    }
    pub fn entry(&self, row: usize) -> Option<&Entry> {
        self.presented
            .binary_search_by_key(&row, |entry| entry.row as usize)
            .ok()
            .map(|index| &self.presented[index])
    }
}

/// Borrowed geometry placed by the exact acknowledged node transform/origin.
/// Content uses logical layout units; window points/bounds use physical pixels.
#[derive(Clone, Copy)]
pub struct TextGeometry<'a> {
    pub(super) part: Part<'a>,
    pub(super) map: &'a gpui_canvas::TextGeometry,
    pub(super) origin: Point,
}
impl<'a> TextGeometry<'a> {
    /// Canonical content-local operations, shared with Canvas shaping.
    pub fn layout(self) -> &'a gpui_canvas::TextGeometry {
        self.map
    }
    pub fn origin(self) -> Point {
        self.origin
    }
    /// Content-local to window-physical, including text padding and DPI once.
    pub fn transform(self) -> Option<CoordinateSpace> {
        Some(
            CoordinateSpace::new(self.part.transform()?)
                .translated(f64::from(self.origin.x), f64::from(self.origin.y)),
        )
    }
    pub fn bounds(self, local: Rect) -> Option<Rect> {
        let map = self.transform()?;
        if !local.is_valid() {
            return None;
        }
        if !local.is_empty() {
            return map.bounds(local);
        }
        // The damage API intentionally discards empty rectangles. Text ranges
        // also need zero-width semantic carets/advances, including under shear.
        let points = [
            Point {
                x: local.x,
                y: local.y,
            },
            Point {
                x: local.x + local.width,
                y: local.y,
            },
            Point {
                x: local.x,
                y: local.y + local.height,
            },
            Point {
                x: local.x + local.width,
                y: local.y + local.height,
            },
        ];
        let mut bounds = [
            f32::INFINITY,
            f32::INFINITY,
            f32::NEG_INFINITY,
            f32::NEG_INFINITY,
        ];
        for point in points {
            let point = map.to_window(point)?;
            bounds[0] = bounds[0].min(point.x);
            bounds[1] = bounds[1].min(point.y);
            bounds[2] = bounds[2].max(point.x);
            bounds[3] = bounds[3].max(point.y);
        }
        Some(Rect::new(
            bounds[0],
            bounds[1],
            bounds[2] - bounds[0],
            bounds[3] - bounds[1],
        ))
    }
    /// Continuous viewport clipping from this P, never current scroll state.
    /// This is semantic geometry, distinct from the raster sample clip.
    /// A transformed rectangle's physical AABB is conservative under shear.
    pub fn visible_bounds(self, local: Rect) -> Option<Rect> {
        let bounds = self.bounds(local)?;
        let clip = self.part.text_clip();
        if clip.is_empty() {
            return None;
        }
        let axis = |start: f32, length: f32, clip: f32, extent: f32| {
            if length == 0. {
                (f64::from(start) >= f64::from(clip)
                    && f64::from(start) < f64::from(clip) + f64::from(extent))
                .then_some((start, 0.))
            } else {
                let left = start.max(clip);
                let right =
                    (f64::from(start) + f64::from(length)).min(f64::from(clip) + f64::from(extent));
                (right > f64::from(left)).then_some((left, (right - f64::from(left)) as f32))
            }
        };
        let (x, width) = axis(bounds.x, bounds.width, clip.x, clip.width)?;
        let (y, height) = axis(bounds.y, bounds.height, clip.y, clip.height)?;
        Some(Rect::new(x, y, width, height))
    }
    pub fn caret_bounds(self, position: gpui_canvas::TextPosition) -> Option<Rect> {
        self.bounds(self.map.caret_bounds(position)?)
    }
    pub fn grapheme_bounds(self, start: gpui_canvas::TextOffset) -> Option<Rect> {
        self.bounds(self.map.grapheme(start)?.bounds())
    }
    fn to_local(self, point: Point) -> Option<Point> {
        self.transform()?.to_local(point)
    }
    /// Nearest legal caret, clamped outside the paragraph. Does not clip;
    /// use hit_position when a visible-window hit is required.
    pub fn position_at(self, point: Point) -> Option<gpui_canvas::TextPosition> {
        self.map.position_at(self.to_local(point)?)
    }
    pub fn hit_position(self, point: Point) -> Option<gpui_canvas::TextPosition> {
        self.part
            .contains_point(point)
            .then(|| self.position_at(point))
            .flatten()
    }
    /// Containing visible unit, distinct from nearest-caret midpoint behavior.
    pub fn grapheme_at(self, point: Point) -> Option<gpui_canvas::TextGrapheme> {
        if !self.part.contains_point(point) {
            return None;
        }
        self.map.grapheme_at(self.to_local(point)?)
    }
    /// Full, unclipped window-physical range rectangles. Endpoint validation
    /// completes before callbacks; a singular placement invokes none.
    pub fn selection_rects(
        self,
        selection: gpui_canvas::TextSelection,
        mut visit: impl FnMut(Rect, usize),
    ) -> bool {
        let Some(_) = self.transform() else {
            return false;
        };
        self.map.selection_rects(selection, |rect, line| {
            if let Some(bounds) = self.bounds(rect) {
                visit(bounds, line);
            }
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{El, div, row, text};
    struct Page {
        value: String,
        broken: bool,
    }
    impl View for Page {
        fn view(&self) -> El<'_> {
            row((
                text(&self.value).w(400),
                div().size(4).bg(Color::BLACK).transform(if self.broken {
                    Affine::scale(0., 1.)
                } else {
                    Affine::IDENTITY
                }),
            ))
        }
    }
    fn report(name: &str, win: &Win<Page>, cost: allocation_counter::AllocationInfo) {
        let runtime = win.runtime().unwrap();
        let owner = runtime.text.as_ref().unwrap();
        let mut maps = Vec::new();
        let mut glyph_capacity = 0;
        for site in runtime.texts.iter().flatten() {
            if let Some(shape) = &site.shaped {
                glyph_capacity += std::mem::size_of_val(shape.layout.glyphs());
                maps.push(shape.layout.geometry().unwrap() as *const _);
            }
        }
        maps.extend(owner.presented.iter().map(|entry| Arc::as_ptr(&entry.map)));
        maps.extend(
            owner
                .candidate
                .iter()
                .flatten()
                .map(|entry| Arc::as_ptr(&entry.map)),
        );
        maps.sort_unstable();
        maps.dedup();
        println!(
            "TEXT_OWNER case={name} unique_maps={} l_glyph_len_bytes={glyph_capacity} p_entries={} p_capacity_bytes={} c_entries={} c_capacity_bytes={} allocations={} requested={} peak_extra={} retained_delta={}",
            maps.len(),
            owner.presented.len(),
            owner.presented.capacity() * size_of::<Entry>(),
            owner.candidate.as_ref().map_or(0, Vec::len),
            owner
                .candidate
                .as_ref()
                .map_or(0, |entries| entries.capacity() * size_of::<Entry>()),
            cost.count_total,
            cost.bytes_total,
            cost.bytes_max,
            cost.bytes_current
        );
    }
    #[test]
    fn acknowledged_geometry_owner_epoch_and_allocation_ledger() {
        println!(
            "TEXT_OWNER_HEADERS resources={} entry={} runtime={} text_site={} node={} presented={} prepared={} part={}",
            size_of::<TextResources>(),
            size_of::<Entry>(),
            size_of::<Runtime<()>>(),
            size_of::<TextSite>(),
            size_of::<Node>(),
            size_of::<Presented>(),
            size_of::<Prepared>(),
            size_of::<Part<'_>>()
        );
        let mut owner = None;
        let cost = allocation_counter::measure(|| {
            owner = Some(
                Win::recording(
                    Page {
                        value: "a".repeat(32 * 1024),
                        broken: false,
                    },
                    WindowOptions::default(),
                )
                .unwrap(),
            )
        });
        let mut win = owner.unwrap();
        report("first_c", &win, cost);
        win.presented(win.with_scene(|_, token| token).unwrap())
            .unwrap();
        let cost = allocation_counter::measure(|| {
            win.update(|page| page.value = "b".repeat(32 * 1024))
                .unwrap();
        });
        report("old_p_new_c", &win, cost);
        let c = win.with_scene(|_, token| token).unwrap();
        let cost = allocation_counter::measure(|| {
            assert!(
                win.update(|page| {
                    page.value = "c".repeat(32 * 1024);
                    page.broken = true;
                })
                .is_err()
            );
        });
        report("old_p_old_c_failed_l", &win, cost);
        let cost = allocation_counter::measure(|| {
            win.presented(c).unwrap();
        });
        report("old_c_ack_failed_l", &win, cost);
        assert_eq!(
            win.runtime().unwrap().text.as_ref().unwrap().presented[0]
                .map
                .text_len(),
            32 * 1024
        );
    }
}
