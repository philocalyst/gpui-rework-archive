//! Opt-in local shape state. Each published sheet owns its own sparse values;
//! no presented node borrows the mutable logical inspector layer.
use super::*;
use crate::property::{GeometryStyle, Overrides};

/// The local rectangle always starts at +0,+0. Its former origin words carry
/// the admitted map's exact translation instead; clipped bounds are independent.
#[derive(Clone, Copy)]
pub(super) struct Placement {
    pub translation: Point,
    pub size: [f32; 2],
}
impl Placement {
    pub fn new(size: [f32; 2], map: Option<Affine>) -> Self {
        Self {
            translation: map.map_or(Point { x: 0.0, y: 0.0 }, |map| Point {
                x: map.tx,
                y: map.ty,
            }),
            size,
        }
    }
    pub fn local_rect(self) -> Rect {
        Rect::new(0.0, 0.0, self.size[0], self.size[1])
    }
}

/// Exact finite basis bits, including signed zeros. This never recomposes or
/// renarrows an admitted map; equality is equality of all four stored words.
#[derive(Clone, Copy, PartialEq, Eq)]
struct Basis([u32; 4]);
impl Basis {
    fn from_map(map: Affine) -> Self {
        Self([map.a, map.b, map.c, map.d].map(f32::to_bits))
    }
    fn dpi(scale: f32) -> Self {
        Self([scale.to_bits(), 0, 0, scale.to_bits()])
    }
    fn map(self, translation: Point) -> Affine {
        let [a, b, c, d] = self.0.map(f32::from_bits);
        Affine {
            a,
            b,
            c,
            d,
            tx: translation.x,
            ty: translation.y,
        }
    }
}
struct Radius {
    identity: u64,
    value: f32,
}

/// One safe, private 16-byte geometry stream: finite basis records precede
/// radius records. A basis has passed the existing finite-map admission, so
/// its first word cannot equal the reserved NaN radius marker. All payloads
/// remain ordinary u32 values; no enum/float representation is reinterpreted.
#[derive(Clone, Copy)]
pub(super) struct Record([u32; 4]);
impl Record {
    const RADIUS: u32 = 0x7fc0_0000;

    fn from_basis(basis: Basis) -> Self {
        debug_assert!(
            basis
                .0
                .into_iter()
                .all(|word| f32::from_bits(word).is_finite())
        );
        Self(basis.0)
    }
    fn from_radius(radius: Radius) -> Self {
        Self([
            Self::RADIUS,
            radius.value.to_bits(),
            radius.identity as u32,
            (radius.identity >> 32) as u32,
        ])
    }
    fn is_basis(&self) -> bool {
        self.0[0] != Self::RADIUS
    }
    fn basis(self) -> Basis {
        debug_assert!(self.is_basis());
        Basis(self.0)
    }
    fn radius(self) -> Radius {
        debug_assert!(!self.is_basis());
        Radius {
            identity: u64::from(self.0[2]) | (u64::from(self.0[3]) << 32),
            value: f32::from_bits(self.0[1]),
        }
    }
}

/// Keys belong to one sheet's pool and scale. Zero is its exact DPI basis;
/// MAX is unavailable. Other values are one-based indices in the basis prefix.
#[derive(Clone, Copy)]
pub(super) struct BasisKey(u32);
const _: () = assert!(MAX_NODES < u32::MAX as usize);
impl BasisKey {
    pub fn record(
        map: Option<Affine>,
        parent: Option<Self>,
        scale: f32,
        records: &mut Vec<Record>,
    ) -> Self {
        debug_assert!(map.is_none_or(|map| map.is_finite() && map.is_invertible()));
        let Some(map) = map else {
            return Self(u32::MAX);
        };
        let basis = Basis::from_map(map);
        if basis == Basis::dpi(scale) {
            return Self(0);
        }
        if let Some(parent) = parent
            && Bases::new(scale, records).get(parent) == Some(basis)
        {
            return parent;
        }
        // Only emitted rows append bases. MAX_NODES bounds both the Vec and
        // this conversion, leaving the unavailable sentinel disjoint.
        assert!(
            records.len() < MAX_NODES,
            "basis belongs to the admitted sheet"
        );
        records.push(Record::from_basis(basis));
        Self(records.len() as u32)
    }
}

/// Borrowed basis prefix. During lowering this is the still-local C vector;
/// acknowledged queries obtain it from a once-split immutable Geometry view.
#[derive(Clone, Copy)]
pub(super) struct Bases<'a> {
    scale: f32,
    records: &'a [Record],
}
impl<'a> Bases<'a> {
    pub fn new(scale: f32, records: &'a [Record]) -> Self {
        Self { scale, records }
    }
    fn get(self, key: BasisKey) -> Option<Basis> {
        match key.0 {
            0 => Some(Basis::dpi(self.scale)),
            u32::MAX => None,
            index => Some(self.records[index as usize - 1].basis()),
        }
    }
    pub fn transform(self, key: BasisKey, placement: Placement) -> Option<Affine> {
        self.get(key).map(|basis| basis.map(placement.translation))
    }
}

/// One borrowed split per query/hit view, never a split or allocation per row.
#[derive(Clone, Copy)]
pub(super) struct GeometryView<'a> {
    records: &'a [Record],
    radius_start: usize,
    scale: f32,
}
impl<'a> GeometryView<'a> {
    pub fn empty(scale: f32) -> Self {
        Self {
            records: &[],
            radius_start: 0,
            scale,
        }
    }
    fn new(scale: f32, records: &'a [Record]) -> Self {
        Self {
            records,
            radius_start: records.partition_point(Record::is_basis),
            scale,
        }
    }
    pub fn bases(self) -> Bases<'a> {
        Bases::new(self.scale, &self.records[..self.radius_start])
    }
    pub fn radius(self, identity: u64) -> f32 {
        let radii = &self.records[self.radius_start..];
        radii
            .binary_search_by_key(&identity, |record| record.radius().identity)
            .ok()
            .map_or(0.0, |index| radii[index].radius().value)
    }
}

#[derive(Default)]
pub(super) struct Geometry {
    current: Vec<(u64, GeometryStyle)>,
    overrides: Overrides<GeometryStyle>,
    presented: Vec<Record>,
    candidate: Option<Vec<Record>>,
}
impl Geometry {
    #[cfg(test)]
    pub(super) fn record_storage(&self) -> (usize, usize) {
        (self.presented.len(), self.presented.capacity())
    }
    pub(super) fn contribution(
        &self,
        identity: u64,
        id: crate::property::PropertyId,
    ) -> Contribution<crate::property::PropertyValue> {
        self.overrides.contribution(identity, id)
    }
    pub fn view(&self, scale: f32) -> GeometryView<'_> {
        GeometryView::new(scale, &self.presented)
    }
    pub fn freeze(&self, mut column: Vec<Record>, include: impl Fn(u64) -> bool) -> Vec<Record> {
        // Bases are already stable direct indices. Append only published radii;
        // the logical column is sorted, so the suffix keeps binary-search order.
        column.reserve_exact(self.current.len());
        column.extend(self.current.iter().filter_map(|(identity, style)| {
            (style.corner_radius.to_bits() != 0 && include(*identity)).then(|| {
                Record::from_radius(Radius {
                    identity: *identity,
                    value: style.corner_radius,
                })
            })
        }));
        column
    }
    pub fn prepare(&mut self, column: Vec<Record>) {
        self.candidate = Some(column);
    }
    pub fn acknowledge(&mut self) {
        if let Some(column) = self.candidate.take() {
            self.presented = column;
        }
    }
    pub fn get(&self, identity: u64) -> GeometryStyle {
        self.current
            .binary_search_by_key(&identity, |entry| entry.0)
            .ok()
            .map_or_else(Default::default, |i| self.current[i].1)
    }
    fn store(&mut self, identity: u64, value: GeometryStyle) {
        let at = self
            .current
            .binary_search_by_key(&identity, |entry| entry.0);
        // Keep authored -0 for logical inspection; paint/hit use ordinary zero.
        match (at, value.corner_radius.to_bits() != 0) {
            (Ok(i), true) => self.current[i].1 = value,
            (Ok(i), false) => {
                self.current.remove(i);
            }
            (Err(i), true) => self.current.insert(i, (identity, value)),
            (Err(_), false) => {}
        }
    }
    pub fn retain(&mut self, live: impl FnMut(u64) -> bool) {
        self.overrides.retain(live);
    }
    pub fn unused(&self) -> bool {
        self.current.is_empty()
            && self.overrides.is_empty()
            && self.presented.is_empty()
            && self.candidate.is_none()
    }
}
/// Patch the canonical lower geometry without borrowing the owner/model.
pub(super) fn patch(
    metadata: &mut Option<Box<Metadata>>,
    identity: u64,
    id: crate::property::PropertyId,
    value: crate::property::PropertyValue,
) -> Result<bool, Error> {
    let before = metadata
        .as_deref()
        .and_then(|m| m.geometry.as_ref())
        .map_or_else(Default::default, |g| g.get(identity));
    let crate::property::PropertyValue::Number(radius) = value else {
        unreachable!("validated geometry value")
    };
    let after = if let Some(geometry) = metadata.as_deref_mut().and_then(|m| m.geometry.as_mut()) {
        geometry
            .overrides
            .update_base(identity, before, id, value)?
    } else {
        GeometryStyle {
            corner_radius: radius,
        }
    };
    let changed =
        !crate::property::CORNER_RADIUS.same_authoring(&before.corner_radius, &after.corner_radius);
    if changed {
        metadata
            .get_or_insert_with(Default::default)
            .geometry
            .get_or_insert_with(Default::default)
            .store(identity, after);
    }
    Ok(changed)
}

impl<M: View + 'static> Runtime<M> {
    pub(super) fn reconcile_geometry(
        &mut self,
        nodes: &[Node],
        drafts: Vec<(usize, GeometryStyle)>,
    ) {
        if drafts.is_empty() && self.metadata.as_ref().is_none_or(|m| m.geometry.is_none()) {
            return;
        }
        let metadata = self.metadata.get_or_insert_with(Default::default);
        let mut geometry = metadata.geometry.take().unwrap_or_default();
        let mut next = Vec::with_capacity(drafts.len());
        let mut drafts = drafts.into_iter().peekable();
        for (index, node) in nodes.iter().enumerate() {
            let declared = if drafts.peek().is_some_and(|entry| entry.0 == index) {
                drafts.next().unwrap().1
            } else {
                GeometryStyle::default()
            };
            let before = geometry.get(node.identity());
            let after = geometry.overrides.resolve(node.identity(), declared);
            if !crate::property::CORNER_RADIUS
                .same_authoring(&before.corner_radius, &after.corner_radius)
            {
                self.dirty = true;
            }
            if after.corner_radius.to_bits() != 0 {
                next.push((node.identity(), after));
            }
        }
        next.sort_unstable_by_key(|entry| entry.0);
        geometry.current = next;
        // Removed targets cannot retain overrides or authoring history.
        if !geometry.unused() {
            metadata.geometry = Some(geometry);
        }
    }
}
impl<M: View + 'static, L: crate::remote::LaneSet<M>> Win<M, L> {
    pub(super) fn geometry_property<T>(
        &self,
        target: Target,
        property: Property<T, GeometryStyle>,
    ) -> Result<T, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let identity = runtime.resolve(target)?;
        let value = runtime
            .metadata
            .as_ref()
            .and_then(|m| m.geometry.as_ref())
            .map_or_else(Default::default, |g| g.get(identity));
        Ok(property.get(&value))
    }
    pub(super) fn geometry_contribution<T>(
        &self,
        target: Target,
        property: Property<T, GeometryStyle>,
    ) -> Result<Contribution<T>, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let identity = runtime.resolve(target)?;
        Ok(runtime
            .metadata
            .as_ref()
            .and_then(|m| m.geometry.as_ref())
            .map_or(Contribution::Inherit, |g| {
                g.overrides.get(identity, property)
            }))
    }
}
impl<M: View + 'static, L: crate::remote::LaneSet<M>> RuntimeMut<'_, M, L> {
    pub(super) fn set_geometry_value(
        &mut self,
        index: usize,
        id: crate::property::PropertyId,
        contribution: Contribution<crate::property::PropertyValue>,
    ) -> Result<(), Error> {
        let runtime = self;
        let identity = runtime.nodes[index].identity();
        let before = runtime
            .metadata
            .as_ref()
            .and_then(|m| m.geometry.as_ref())
            .map_or_else(Default::default, |g| g.get(identity));
        let metadata = runtime.metadata.get_or_insert_with(Default::default);
        let geometry = metadata.geometry.get_or_insert_with(Default::default);
        let after = geometry
            .overrides
            .set_value(identity, before, id, contribution)?;
        geometry.store(identity, after);
        if geometry.unused() {
            metadata.geometry = None;
        }
        let changed = !crate::property::CORNER_RADIUS
            .same_authoring(&before.corner_radius, &after.corner_radius);
        runtime.changed_nodes = usize::from(changed);
        runtime.dirty |= changed;
        if runtime.metadata.as_deref().is_some_and(Metadata::unused) {
            runtime.metadata = None;
        }
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{El, div};
    #[test]
    fn cold_geometry_storage_is_absent_from_plain_owners_and_reclaimed_after_removal() {
        eprintln!(
            "rounded_gpui,Style={},El={},Extra={},Annotations={},ImageSpec={},Node={},P={},Runtime={},Metadata={},Sheet={},Geometry={},Entry={},PropertyStyle={},PropertyGeometry={}",
            size_of::<Style>(),
            size_of::<El<'_>>(),
            size_of::<crate::semantic::ElementExtra<'_>>(),
            size_of::<crate::semantic::Annotations<'_>>(),
            size_of::<crate::image::ImageSpec<'_>>(),
            size_of::<Node>(),
            size_of::<Presented>(),
            size_of::<Runtime<()>>(),
            size_of::<Metadata>(),
            size_of::<metadata::Sheet>(),
            size_of::<Geometry>(),
            size_of::<(u64, GeometryStyle)>(),
            size_of::<Property<f32>>(),
            size_of::<Property<f32, GeometryStyle>>()
        );
        assert_eq!(size_of::<Property<f32>>(), size_of::<usize>());
        assert_eq!(
            size_of::<Property<f32, GeometryStyle>>(),
            size_of::<usize>()
        );
        assert_eq!(size_of::<crate::semantic::Annotations<'_>>(), 48);
        assert_eq!(size_of::<crate::semantic::ElementExtra<'_>>(), 56);
        assert_eq!(size_of::<crate::image::ImageSpec<'_>>(), 16);
        for (name, make) in [
            ("absent", (div as fn() -> El<'static>)),
            ("rounded", || div().rounded(6.0)),
            ("named", || div().name("n")),
            ("rounded_named", || div().rounded(6.0).name("n")),
            ("named_rounded", || div().name("n").rounded(6.0)),
        ] {
            let mut value = None;
            let count = allocation_counter::measure(|| value = Some(make()));
            eprintln!(
                "rounded_element,{name},allocations={},bytes={}",
                count.count_total, count.bytes_total
            );
            assert_eq!(
                count.bytes_total,
                match name {
                    "absent" => 0,
                    "rounded" | "named" => 56,
                    _ => 104,
                }
            );
            drop(value);
        }
        struct Page(bool);
        impl View for Page {
            fn view(&self) -> El<'_> {
                let el = div().size(32).bg(Color::BLACK);
                if self.0 { el.rounded(8.0) } else { el }
            }
        }
        let mut win = Win::demo(Page(false));
        assert!(win.runtime().unwrap().metadata.is_none());
        let runtime = win.runtime().unwrap();
        let target = runtime.sites.target(runtime.nodes[0].identity());
        win.set_property(
            target,
            crate::property::CORNER_RADIUS,
            Contribution::Set(0.0),
        )
        .unwrap();
        assert!(win.runtime().unwrap().metadata.is_some());
        win.set_property(
            target,
            crate::property::CORNER_RADIUS,
            Contribution::Inherit,
        )
        .unwrap();
        assert!(win.runtime().unwrap().metadata.is_none());
        win.update(|page| page.0 = true).unwrap();
        assert_eq!(
            win.runtime()
                .unwrap()
                .metadata
                .as_ref()
                .unwrap()
                .geometry
                .as_ref()
                .unwrap()
                .presented
                .len(),
            1
        );
        win.update(|page| page.0 = false).unwrap();
        assert!(win.runtime().unwrap().metadata.is_none());
    }

    #[test]
    fn sparse_frozen_radii_include_only_admitted_list_sites_without_history() {
        use crate::{ItemKey, ItemSource, ListId, uniform_list};
        struct Rows {
            rounded: bool,
        }
        impl ItemSource for Rows {
            fn len(&self) -> usize {
                10_000
            }
            fn key(&self, index: usize) -> ItemKey {
                ItemKey::new(index as u64)
            }
            fn index_of(&self, key: ItemKey) -> Option<usize> {
                (key.get() < 10_000).then_some(key.get() as usize)
            }
            fn row(&self, _: usize) -> El<'_> {
                let el = div().w(64).h(16).bg(Color::BLACK);
                if self.rounded { el.rounded(4.0) } else { el }
            }
        }
        const LIST: ListId = ListId::new(91);
        impl View for Rows {
            fn view(&self) -> El<'_> {
                uniform_list(LIST, self, 16).w(64).h(32)
            }
        }
        let mut win = Win::with_size(Rows { rounded: true }, 64, 32).unwrap();
        for index in [0, 500, 9_900] {
            let list = win.list(LIST).unwrap();
            win.scroll_to_index(list, index).unwrap();
            let runtime = win.runtime().unwrap();
            let geometry = runtime
                .metadata
                .as_ref()
                .unwrap()
                .geometry
                .as_ref()
                .unwrap();
            assert!(!geometry.presented.is_empty());
            assert!(geometry.presented.len() <= 2);
            for record in &geometry.presented {
                let identity = record.radius().identity;
                assert!(
                    runtime
                        .presented
                        .iter()
                        .any(|node| node.identity == identity)
                );
            }
        }
        win.update(|rows| rows.rounded = false).unwrap();
        assert!(
            win.runtime()
                .unwrap()
                .metadata
                .as_ref()
                .unwrap()
                .geometry
                .is_none()
        );
    }
}

#[cfg(test)]
mod basis_tests {
    use super::*;

    fn bits(map: Affine) -> [u32; 6] {
        [map.a, map.b, map.c, map.d, map.tx, map.ty].map(f32::to_bits)
    }
    #[test]
    fn exact_admitted_maps_and_zero_origin_extent_survive_factorization() {
        assert_eq!(size_of::<BasisKey>(), 4);
        assert_eq!(size_of::<Placement>(), 16);
        assert_eq!(size_of::<Record>(), 16);
        let mut records = Vec::new();
        let absent = BasisKey::record(None, None, 1.0, &mut records);
        assert!(
            Bases::new(1.0, &records)
                .transform(absent, Placement::new([0.0, -0.0], None))
                .is_none()
        );
        for map in [
            Affine::IDENTITY,
            Affine {
                a: -0.0,
                b: 1.0,
                c: -1.0,
                d: 0.0,
                tx: -0.0,
                ty: 0.0,
            },
            Affine::scale(-2.0, 0.25),
            Affine::translation(f32::MAX, -f32::MAX),
            Affine {
                a: f32::from_bits(1),
                d: f32::MAX,
                ..Affine::IDENTITY
            },
            Affine {
                b: -0.0,
                c: -0.0,
                ..Affine::IDENTITY
            },
        ] {
            let placement = Placement::new([-0.0, f32::MIN_POSITIVE], Some(map));
            let key = BasisKey::record(Some(map), None, 1.0, &mut records);
            let actual = Bases::new(1.0, &records).transform(key, placement).unwrap();
            assert_eq!(bits(actual), bits(map));
            let local = placement.local_rect();
            assert_eq!(
                [local.x, local.y, local.width, local.height].map(f32::to_bits),
                [0, 0, (-0.0f32).to_bits(), f32::MIN_POSITIVE.to_bits()]
            );
        }
    }
    #[test]
    fn parent_reuse_requires_every_basis_bit_and_keys_are_sheet_local() {
        let mut records = Vec::new();
        let map = Affine {
            a: 1.5,
            b: 0.125,
            ..Affine::IDENTITY
        };
        let parent = BasisKey::record(Some(map), None, 1.0, &mut records);
        let translated = Affine {
            tx: 7.0,
            ty: -0.0,
            ..map
        };
        let child = BasisKey::record(Some(translated), Some(parent), 1.0, &mut records);
        assert_eq!(parent.0, child.0);
        assert_eq!(records.len(), 1);
        let changed = Affine { c: -0.0, ..map };
        let signed = BasisKey::record(Some(changed), Some(parent), 1.0, &mut records);
        assert_ne!(signed.0, parent.0);
        let default = BasisKey::record(Some(Affine::IDENTITY), None, 1.0, &mut records);
        assert_eq!(default.0, 0);
        assert_ne!(
            bits(
                Bases::new(1.0, &records)
                    .transform(default, Placement::new([1.0; 2], Some(Affine::IDENTITY)))
                    .unwrap()
            ),
            bits(
                Bases::new(2.0, &records)
                    .transform(default, Placement::new([1.0; 2], Some(Affine::IDENTITY)))
                    .unwrap()
            )
        );
        let sibling = BasisKey::record(Some(map), None, 1.0, &mut records);
        assert_ne!(sibling.0, parent.0); // No sibling interner or hash pass.
    }
    #[test]
    fn mixed_stream_keeps_full_radius_identity_and_empty_candidate_clears_p() {
        let mut geometry = Geometry::default();
        let mut records = Vec::new();
        let map = Affine {
            a: 1.5,
            b: 0.25,
            ..Affine::IDENTITY
        };
        let key = BasisKey::record(Some(map), None, 1.0, &mut records);
        for (identity, value) in [(1, -0.0), (u64::MAX, 3.5)] {
            geometry.store(
                identity,
                GeometryStyle {
                    corner_radius: value,
                },
            );
        }
        geometry.prepare(geometry.freeze(records, |_| true));
        assert!(geometry.view(1.0).records.is_empty());
        geometry.acknowledge();
        let view = geometry.view(1.0);
        assert_eq!(view.radius_start, 1);
        assert_eq!(view.radius(1).to_bits(), (-0.0f32).to_bits());
        assert_eq!(view.radius(u64::MAX), 3.5);
        assert_eq!(view.radius(2), 0.0);
        assert!(view.bases().get(key) == Some(Basis::from_map(map)));
        geometry.acknowledge(); // KEEP has no candidate and preserves P.
        assert_eq!(geometry.view(1.0).radius_start, 1);
        geometry.prepare(Vec::new());
        geometry.acknowledge();
        assert!(geometry.view(1.0).records.is_empty());
    }
}
