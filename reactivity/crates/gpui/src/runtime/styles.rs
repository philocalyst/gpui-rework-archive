//! Current-owner resolved styles. A sheet never borrows this mutable lane.
use super::Style;
mod colours;
pub(super) use colours::{Change as ColorChange, Discovery as ColorDiscovery, Slot as ColorSlot};

#[cfg(test)]
pub(super) fn color_headers() -> [usize; 3] {
    [
        size_of::<colours::SourceColor>(),
        size_of::<colours::Record>(),
        size_of::<colours::Bound>(),
    ]
}

const PALETTE_LIMIT: usize = 32;
const SMALL_OWNER: usize = 8;
const _: () = assert!(PALETTE_LIMIT <= u8::MAX as usize);

trait Value: Copy {
    const DEFAULT: Self;
    fn same(&self, other: &Self) -> bool;
}
impl Value for Style {
    const DEFAULT: Self = Style::DEFAULT;
    fn same(&self, other: &Self) -> bool {
        exact_eq(self, other)
    }
}
enum Lane<T> {
    Default,
    Dense(Vec<T>),
    Shared {
        palette: Box<[T]>,
        indices: Box<[u8]>,
    },
}
impl<T: Value> Lane<T> {
    #[inline]
    fn get(&self, index: usize) -> T {
        match self {
            Self::Default => T::DEFAULT,
            Self::Dense(values) => values[index],
            Self::Shared { palette, indices } => palette[usize::from(indices[index])],
        }
    }
    #[cfg(test)]
    fn bytes(&self) -> usize {
        match self {
            Self::Default => 0,
            Self::Dense(values) => values.capacity() * size_of::<T>(),
            Self::Shared { palette, indices } => {
                size_of_val(palette.as_ref()) + size_of_val(indices.as_ref())
            }
        }
    }
    fn set(&mut self, index: usize, value: T, count: usize) {
        if !matches!(self, Self::Dense(_)) {
            *self = Self::Dense((0..count).map(|index| self.get(index)).collect());
        }
        let Self::Dense(values) = self else {
            unreachable!()
        };
        values[index] = value;
    }
}
#[derive(Default)]
pub(super) enum Styles {
    #[default]
    Default,
    Dense(Vec<Style>),
    Shared {
        palette: Box<[Style]>,
        indices: Box<[u8]>,
    },
    Colors(Box<colours::Bound>),
}
impl Styles {
    /// Borrow ordinary lanes directly. Only a source-colored record needs a
    /// temporary resolved value; the callback cannot retain a borrow of it.
    #[inline]
    pub(super) fn with<R>(&self, index: usize, read: impl FnOnce(&Style) -> R) -> R {
        match self {
            Self::Default => read(&Style::DEFAULT),
            Self::Dense(values) => read(&values[index]),
            Self::Shared { palette, indices } => read(&palette[usize::from(indices[index])]),
            Self::Colors(values) => read(&values.get(index)),
        }
    }
    #[inline]
    pub(super) fn get(&self, index: usize) -> Style {
        match self {
            Self::Default => Style::DEFAULT,
            Self::Dense(values) => values[index],
            Self::Shared { palette, indices } => palette[usize::from(indices[index])],
            Self::Colors(values) => values.get(index),
        }
    }
    pub(super) fn set(&mut self, index: usize, value: Style, count: usize) {
        if let Self::Colors(values) = self {
            values.set(index, value, count);
            return;
        }
        if !matches!(self, Self::Dense(_)) {
            *self = Self::Dense((0..count).map(|index| self.get(index)).collect());
        }
        let Self::Dense(values) = self else {
            unreachable!()
        };
        values[index] = value;
    }
    pub(super) fn binding_fields(&self, index: usize) -> [Option<super::FieldId>; 2] {
        match self {
            Self::Colors(values) => values.binding_fields(index),
            _ => [None; 2],
        }
    }
    pub(super) fn declared_colors(&self, index: usize) -> Option<(crate::Color, crate::Color)> {
        match self {
            Self::Colors(values) => Some(values.declared_colors(index)),
            _ => None,
        }
    }
    pub(super) fn color_contribution(
        &mut self,
        index: usize,
        id: crate::property::PropertyId,
        value: Style,
        explicit: bool,
        count: usize,
    ) -> bool {
        if let Self::Colors(values) = self {
            return values.contribution(index, id, value, explicit, count);
        }
        false
    }
    #[cfg(feature = "native-core")]
    pub(super) fn slot_transition(&self) -> Option<&super::paint::SlotTransition> {
        match self {
            Self::Colors(values) => values.transition.as_ref(),
            _ => None,
        }
    }
    #[cfg(feature = "native-core")]
    pub(super) fn record_slot_transition(
        &mut self,
        from: super::PresentationToken,
        edits: super::paint::PaintEdits,
    ) {
        let Self::Colors(values) = self else {
            unreachable!("bound source has slot owner")
        };
        values.transition = Some(super::paint::SlotTransition {
            from,
            edits,
        });
    }
    pub(super) fn clear_slot_transition(&mut self) {
        #[cfg(feature = "native-core")]
        if let Self::Colors(values) = self {
            values.transition = None;
        }
    }
    pub(super) fn reset_canvas_slots(&mut self) {
        if let Self::Colors(values) = self {
            values.reset_canvas_slots();
        }
    }
    pub(super) fn shared_paint(
        &mut self,
        index: usize,
        foreground: bool,
    ) -> Option<(gpui_canvas::PaintColor, &mut Option<gpui_canvas::PaintSlot>)> {
        match self {
            Self::Colors(values) => values.shared_paint(index, foreground),
            _ => None,
        }
    }
    pub(super) fn update_color(
        &mut self,
        slot: ColorSlot,
        color: crate::Color,
    ) -> Option<ColorChange> {
        let Self::Colors(values) = self else {
            unreachable!("source color has retained bank")
        };
        values.bank.update(slot, color)
    }
}

enum Building<T> {
    Default,
    Dense(Vec<T>),
    Shared { palette: Vec<T>, indices: Vec<u8> },
}
struct LaneBuilder<T> {
    count: usize,
    total: usize,
    mode: Building<T>,
}
impl<T: Value> LaneBuilder<T> {
    fn new(total: usize) -> Self {
        Self {
            count: 0,
            total,
            mode: Building::Default,
        }
    }
    #[inline]
    fn push(&mut self, value: T) {
        if matches!(self.mode, Building::Default) && !value.same(&T::DEFAULT) {
            self.mode = if self.total <= SMALL_OWNER {
                let mut values = Vec::with_capacity(self.total);
                values.resize(self.count, T::DEFAULT);
                Building::Dense(values)
            } else {
                let mut palette = Vec::with_capacity(PALETTE_LIMIT);
                let mut indices = Vec::with_capacity(self.total);
                if self.count != 0 {
                    palette.push(T::DEFAULT);
                    indices.resize(self.count, 0);
                }
                Building::Shared { palette, indices }
            };
        }
        match &mut self.mode {
            Building::Default => {}
            Building::Dense(values) => values.push(value),
            Building::Shared { palette, indices } => {
                if let Some(index) = palette.iter().position(|old| old.same(&value)) {
                    indices.push(index as u8);
                } else if palette.len() < PALETTE_LIMIT {
                    indices.push(palette.len() as u8);
                    palette.push(value);
                } else {
                    let mut values = dense(palette, indices, self.total);
                    values.push(value);
                    self.mode = Building::Dense(values);
                }
            }
        }
        self.count += 1;
    }
    fn finish(self) -> Lane<T> {
        debug_assert_eq!(self.count, self.total);
        match self.mode {
            Building::Default => Lane::Default,
            Building::Dense(values) => Lane::Dense(values),
            Building::Shared { palette, indices } => {
                let shared = palette.len() * size_of::<T>() + indices.len();
                if shared * 4 >= self.total * size_of::<T>() * 3 {
                    Lane::Dense(dense(&palette, &indices, self.total))
                } else {
                    Lane::Shared {
                        palette: palette.into_boxed_slice(),
                        indices: indices.into_boxed_slice(),
                    }
                }
            }
        }
    }
}
fn dense<T: Value>(palette: &[T], indices: &[u8], capacity: usize) -> Vec<T> {
    let mut values = Vec::with_capacity(capacity);
    values.extend(indices.iter().map(|&index| palette[usize::from(index)]));
    values
}

enum BuildingStyles {
    Plain(LaneBuilder<Style>),
    Colors(colours::Builder),
}
pub(super) struct Builder {
    mode: BuildingStyles,
}
impl Builder {
    pub(super) fn new(total: usize) -> Self {
        Self {
            mode: BuildingStyles::Plain(LaneBuilder::new(total)),
        }
    }
    pub(super) fn with_colors(total: usize, discovery: ColorDiscovery) -> Self {
        if discovery.is_empty() {
            Self::new(total)
        } else {
            Self {
                mode: BuildingStyles::Colors(colours::Builder::new(total, discovery)),
            }
        }
    }
    #[cfg(test)]
    #[inline]
    pub(super) fn push(&mut self, style: &Style) {
        match &mut self.mode {
            BuildingStyles::Plain(values) => values.push(*style),
            BuildingStyles::Colors(_) => unreachable!("bound declaration required"),
        }
    }
    pub(super) fn binding_fields(&self, index: usize) -> [Option<super::FieldId>; 2] {
        match &self.mode {
            BuildingStyles::Colors(values) => values.binding_fields(index),
            _ => [None; 2],
        }
    }
    pub(super) fn declaration(&mut self, index: usize, declared: Style, resolved: Style, mask: u8) {
        match &mut self.mode {
            BuildingStyles::Plain(values) => values.push(resolved),
            BuildingStyles::Colors(values) => values.push(index, declared, resolved, mask),
        }
    }
    pub(super) fn finish(self) -> Styles {
        match self.mode {
            BuildingStyles::Plain(values) => match values.finish() {
                Lane::Default => Styles::Default,
                Lane::Dense(values) => Styles::Dense(values),
                Lane::Shared { palette, indices } => Styles::Shared { palette, indices },
            },
            BuildingStyles::Colors(values) => Styles::Colors(Box::new(values.finish())),
        }
    }
}

// Numerical equality intentionally treats signed zero as equal. Interning has
// the stronger obligation to retain the exact authored channels and profile.
#[inline]
pub(super) fn exact_eq(a: &Style, b: &Style) -> bool {
    use crate::property::ExactValue;
    Option::<f32>::same(&a.width, &b.width)
        && Option::<f32>::same(&a.height, &b.height)
        && f32::same(&a.gap, &b.gap)
        && f32::same(&a.padding, &b.padding)
        && f32::same(&a.font_size, &b.font_size)
        && crate::Flow::same(&a.flow, &b.flow)
        && crate::Align::same(&a.align, &b.align)
        && crate::Justify::same(&a.justify, &b.justify)
        && bool::same(&a.wrap, &b.wrap)
        && crate::Affine::same(&a.transform, &b.transform)
        && crate::Color::same(&a.fg, &b.fg)
        && crate::Color::same(&a.bg, &b.bg)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn ordinary_property_reads_borrow_the_actual_style_once() {
        let dense = Styles::Dense(vec![Style::DEFAULT]);
        let Styles::Dense(values) = &dense else {
            unreachable!()
        };
        let mut calls = 0;
        dense.with(0, |style| {
            calls += 1;
            assert!(std::ptr::eq(style, &values[0]));
        });
        assert_eq!(calls, 1);

        let shared = Styles::Shared {
            palette: vec![Style::DEFAULT].into_boxed_slice(),
            indices: vec![0].into_boxed_slice(),
        };
        let Styles::Shared { palette, .. } = &shared else {
            unreachable!()
        };
        shared.with(0, |style| assert!(std::ptr::eq(style, &palette[0])));
        Styles::Default.with(0, |style| assert!(exact_eq(style, &Style::DEFAULT)));
    }
    use crate::{Align, Color, Flow, Justify};

    fn build(values: impl IntoIterator<Item = Style>, count: usize) -> Styles {
        let mut builder = Builder::new(count);
        for value in values {
            builder.push(&value);
        }
        builder.finish()
    }

    fn numbered(index: usize) -> Style {
        Style {
            width: Some(index as f32),
            ..Style::default()
        }
    }

    #[test]
    fn storage_modes_and_overflow_preserve_every_admitted_style() {
        assert!(matches!(build([], 0), Styles::Default));
        assert!(matches!(
            build([Style::default(); 512], 512),
            Styles::Default
        ));
        assert!(matches!(build((0..3).map(numbered), 3), Styles::Dense(_)));
        assert!(matches!(
            build((0..512).map(|i| numbered(i % 8)), 512),
            Styles::Shared { .. }
        ));
        for count in [9, 32, 33, 100, super::super::MAX_NODES] {
            let lane = build((0..count).map(numbered), count);
            assert!(matches!(lane, Styles::Dense(_)));
            for index in 0..count {
                assert!(exact_eq(&lane.get(index), &numbered(index)));
            }
        }
    }

    #[test]
    fn shared_values_preserve_author_channels_profiles_and_signed_zero() {
        let mut values = vec![Style::default(); 8];
        values[1].gap = -0.0;
        values[2].width = Some(0.0);
        values[3].transform.b = -0.0;
        values[4].fg = Color::linear_srgb(-0.0, 0.0, 0.0, 1.0).unwrap();
        values[5].fg = Color::linear_srgb(0.0, 0.0, 0.0, 1.0).unwrap();
        values[6].fg = Color::display_p3(0.0, 0.0, 0.0, 1.0).unwrap();
        values[7].bg = Color::linear_display_p3(-0.5, 2.0, 0.25, 0.5).unwrap();
        let lane = build((0..512).map(|i| values[i % values.len()]), 512);
        let Styles::Shared { palette, indices } = &lane else {
            panic!("expected shared styles")
        };
        assert_eq!(palette.len(), values.len());
        assert_eq!(indices.len(), 512);
        for index in 0..512 {
            assert!(exact_eq(&lane.get(index), &values[index % values.len()]));
        }
    }

    #[test]
    fn inspector_edits_densify_once_and_do_not_mutate_shared_peers() {
        for mut lane in [
            build([Style::default(); 128], 128),
            build((0..128).map(|i| numbered(i % 2)), 128),
        ] {
            let old = lane.get(17);
            lane.set(16, numbered(99), 128);
            assert!(exact_eq(&lane.get(17), &old));
            let Styles::Dense(values) = &lane else {
                unreachable!()
            };
            let pointer = values.as_ptr();
            lane.set(16, numbered(100), 128);
            let Styles::Dense(values) = &lane else {
                unreachable!()
            };
            assert_eq!(pointer, values.as_ptr());
            assert!(exact_eq(&lane.get(16), &numbered(100)));
        }
    }

    #[test]
    fn rebuilt_lanes_keep_no_historical_style_palette() {
        let mut lane = build((0..256).map(numbered), 256);
        for frame in 1..100 {
            lane = build((0..256).map(|i| numbered(i + frame * 256)), 256);
            let Styles::Dense(values) = &lane else {
                unreachable!()
            };
            assert_eq!(values.capacity(), 256);
        }
        drop(lane);
        let lane = build([Style::default(); 4], 4);
        assert!(matches!(lane, Styles::Default));
    }

    #[test]
    fn late_palette_overflow_and_late_nondefault_prefix_preserve_all_values() {
        let count = 4096;
        let value = |index| numbered(if index == count - 1 { 33 } else { index % 32 });
        let lane = build((0..count).map(value), count);
        assert!(matches!(lane, Styles::Dense(_)));
        for index in 0..count {
            assert!(exact_eq(&lane.get(index), &value(index)));
        }
        let value = |index| {
            if index == count - 1 {
                numbered(7)
            } else {
                Style::default()
            }
        };
        let lane = build((0..count).map(value), count);
        assert!(matches!(lane, Styles::Shared { .. }));
        for index in 0..count {
            assert!(exact_eq(&lane.get(index), &value(index)));
        }
    }

    #[test]
    fn exact_comparison_covers_every_style_field() {
        let base = Style::default();
        let mut changes = [base; 18];
        changes[0].width = Some(0.0);
        changes[1].height = Some(0.0);
        changes[2].gap = -0.0;
        changes[3].padding = -0.0;
        changes[4].font_size = 17.0;
        changes[5].flow = Flow::Row;
        changes[6].transform.a = 2.0;
        changes[7].transform.b = -0.0;
        changes[8].transform.c = -0.0;
        changes[9].transform.d = 2.0;
        changes[10].transform.tx = -0.0;
        changes[11].transform.ty = -0.0;
        changes[12].fg = Color::linear_srgb(0.0, 0.0, 0.0, 1.0).unwrap();
        changes[13].bg = Color::linear_srgb(0.0, 0.0, 0.0, 0.0).unwrap();
        changes[14].bg = Color::rgba(1, 0, 0, 0);
        changes[15].align = Align::End;
        changes[16].justify = Justify::End;
        changes[17].wrap = true;
        assert!(changes.into_iter().all(|value| !exact_eq(&base, &value)));
    }

    #[test]
    fn style_lane_allocation_ledger() {
        assert_eq!(size_of::<Styles>(), 40);
        for (label, count, period) in [
            ("default", 4096, 0),
            ("small", 3, 3),
            ("shared", 4096, 8),
            ("unique", 4096, 4096),
        ] {
            let mut lane = None;
            let allocation = allocation_counter::measure(|| {
                lane = Some(build(
                    (0..count).map(|i| {
                        if period == 0 {
                            Style::default()
                        } else {
                            numbered(i % period)
                        }
                    }),
                    count,
                ));
            });
            let bytes = match lane.as_ref().unwrap() {
                Styles::Default => 0,
                Styles::Dense(values) => values.capacity() * size_of::<Style>(),
                Styles::Colors(values) => values.bytes(),
                Styles::Shared { palette, indices } => {
                    size_of_val(palette.as_ref()) + size_of_val(indices.as_ref())
                }
            };
            println!(
                "style_lane,{label},nodes={count},allocations={},requested_bytes={},live_bytes={bytes},peak_bytes={}",
                allocation.count_total, allocation.bytes_total, allocation.bytes_max
            );
            if period == 0 {
                assert_eq!(allocation.count_total, 0);
            }
        }
    }
}
