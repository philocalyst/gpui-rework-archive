//! Opt-in local shape state. Each published sheet owns its own sparse values;
//! no presented node borrows the mutable logical inspector layer.
use super::*;
use crate::property::{GeometryStyle, Overrides};

#[derive(Default)]
pub(super) struct Geometry {
    current: Vec<(u64, GeometryStyle)>,
    overrides: Overrides<GeometryStyle>,
    presented: Vec<(u64, GeometryStyle)>,
    candidate: Option<Vec<(u64, GeometryStyle)>>,
}
impl Geometry {
    pub fn frozen_radius(&self, identity: u64) -> f32 {
        self.presented
            .binary_search_by_key(&identity, |entry| entry.0)
            .ok()
            .map_or(0.0, |i| self.presented[i].1.corner_radius)
    }
    pub fn freeze(&self, include: impl Fn(u64) -> bool) -> Vec<(u64, GeometryStyle)> {
        // The logical column is already sorted. Iterate only opted-in sites;
        // list clipping consults the caller's existing publication scratch.
        let mut column = Vec::with_capacity(self.current.len());
        column.extend(
            self.current.iter().copied().filter(|(identity, style)| {
                style.corner_radius.to_bits() != 0 && include(*identity)
            }),
        );
        column
    }
    pub fn prepare(&mut self, column: Vec<(u64, GeometryStyle)>) {
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
    pub(super) fn set_geometry_property<T: PartialEq>(
        &mut self,
        target: Target,
        property: Property<T, GeometryStyle>,
        contribution: Contribution<T>,
    ) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        let identity = runtime.resolve(target)?;
        let epoch = runtime
            .source_epoch
            .checked_add(1)
            .ok_or(Error::EpochExhausted)?;
        if let Contribution::Set(value) = &contribution {
            property.validate(value)?;
        }
        let before = runtime
            .metadata
            .as_ref()
            .and_then(|m| m.geometry.as_ref())
            .map_or_else(Default::default, |g| g.get(identity));
        let metadata = runtime.metadata.get_or_insert_with(Default::default);
        let geometry = metadata.geometry.get_or_insert_with(Default::default);
        let after = geometry
            .overrides
            .set(identity, before, property, contribution)?;
        geometry.store(identity, after);
        if geometry.unused() {
            metadata.geometry = None;
        }
        runtime.source_epoch = epoch;
        runtime.counters.source_operations += 1;
        let changed = !crate::property::CORNER_RADIUS
            .same_authoring(&before.corner_radius, &after.corner_radius);
        runtime.changed_nodes = usize::from(changed);
        runtime.dirty |= changed;
        if runtime.metadata.as_deref().is_some_and(Metadata::unused) {
            runtime.metadata = None;
        }
        runtime.present()
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
            for (identity, _) in &geometry.presented {
                assert!(
                    runtime
                        .presented
                        .iter()
                        .any(|node| node.identity == *identity)
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
