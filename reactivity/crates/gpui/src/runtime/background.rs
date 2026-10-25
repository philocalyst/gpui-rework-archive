//! One background authority with a sparse resource arm. Style.bg is the compiled
//! solid arm; under a gradient its transparent value is only a cache placeholder.
//! Keys are process identities, never serialized capabilities or resource indices.
use super::*;
use crate::property::{Brush, PaintStyle, PropertyId, PropertyValue};
use gpui_canvas::{Gradient, GradientKey, GradientView};

#[derive(Default)]
pub(super) struct Backgrounds {
    pub(super) declared: BTreeMap<u64, GradientKey>,
    pub(super) resources: BTreeMap<GradientKey, Gradient>,
    overrides: BTreeMap<u64, GradientKey>,
}
impl Backgrounds {
    fn key(&self, identity: u64, solid_override: bool) -> Option<GradientKey> {
        if let Some(key) = self.overrides.get(&identity) {
            Some(*key)
        } else if solid_override {
            None
        } else {
            self.declared.get(&identity).copied()
        }
    }
    pub(super) fn gradient(&self, identity: u64, solid_override: bool) -> Option<&Gradient> {
        self.resources.get(&self.key(identity, solid_override)?)
    }
    fn release_unused(&mut self, key: GradientKey) {
        // A setter can displace only this key. Unchanged keys need no scan;
        // complete descriptions prune through their admitted needed-key map.
        if !self.declared.values().any(|v| *v == key) && !self.overrides.values().any(|v| *v == key)
        {
            self.resources.remove(&key);
        }
    }
    pub(super) fn unused(&self) -> bool {
        self.declared.is_empty() && self.overrides.is_empty()
    }
}
impl<M> Runtime<M> {
    pub(super) fn backgrounds(&self) -> Option<&Backgrounds> {
        self.images.as_deref()?.backgrounds.as_deref()
    }
    pub(super) fn background(&self, index: usize) -> Brush {
        let solid = self.styles.get(index).bg;
        let identity = self.nodes[index].identity();
        self.backgrounds()
            .and_then(|b| {
                b.key(
                    identity,
                    matches!(
                        self.overrides
                            .contribution(identity, PropertyId::Background),
                        Contribution::Set(_)
                    ),
                )
            })
            .map_or(Brush::Solid(solid), Brush::Gradient)
    }
    pub(super) fn background_contribution(&self, identity: u64) -> Contribution<PropertyValue> {
        let brush = if let Some(key) = self.backgrounds().and_then(|b| b.overrides.get(&identity)) {
            Brush::Gradient(*key)
        } else {
            match self
                .overrides
                .contribution(identity, PropertyId::Background)
            {
                Contribution::Inherit => return Contribution::Inherit,
                Contribution::Set(PropertyValue::Color(color)) => Brush::Solid(color),
                _ => unreachable!("compiled solid background contribution"),
            }
        };
        Contribution::Set(PropertyValue::Brush(brush))
    }
}
pub(super) fn reconcile(
    resources: &mut Option<Box<super::image::SceneResources>>,
    nodes: &[Node],
    live: &IdentityIndex,
    mut drafts: Vec<(usize, &Gradient)>,
) -> Result<bool, Error> {
    if drafts.is_empty() && resources.as_ref().is_none_or(|r| r.backgrounds.is_none()) {
        return Ok(false);
    }
    // The owned description is the admission key stream. Sorting references
    // neither clones author data nor acquires resource leases.
    drafts.sort_unstable_by_key(|(_, gradient)| gradient.key());
    let mut overrides = BTreeSet::new();
    let old = resources.as_ref().and_then(|r| r.backgrounds.as_deref());
    if let Some(bank) = old {
        for (&identity, &key) in &bank.overrides {
            if live.contains(identity) {
                overrides.insert(key);
            }
        }
    }
    let mut bytes = resources.as_ref().map_or(0, |r| {
        r.logical
            .iter()
            .map(crate::Image::pixel_bytes)
            .sum::<usize>()
    });
    let mut previous = None;
    for (_, gradient) in &drafts {
        let key = gradient.key();
        if previous != Some(key) {
            bytes = bytes
                .checked_add(gradient.view().byte_len())
                .ok_or(Error::ResourceLimit)?;
            previous = Some(key);
        }
    }
    for key in &overrides {
        if drafts
            .binary_search_by_key(key, |(_, gradient)| gradient.key())
            .is_err()
        {
            bytes = bytes
                .checked_add(old.unwrap().resources[key].view().byte_len())
                .ok_or(Error::ResourceLimit)?;
        }
    }
    if bytes > gpui_canvas::MAX_IMAGE_SCENE_BYTES {
        return Err(Error::ResourceLimit);
    }
    // All admission completes before changing the preceding bank. Keep the key
    // ordering through resource retention, then restore description node order.
    let mut bank = resources
        .as_mut()
        .and_then(|r| r.backgrounds.take())
        .unwrap_or_default();
    bank.overrides
        .retain(|identity, _| live.contains(*identity));
    bank.resources.retain(|key, _| {
        overrides.contains(key)
            || drafts
                .binary_search_by_key(key, |(_, gradient)| gradient.key())
                .is_ok()
    });
    for (_, gradient) in &drafts {
        bank.resources
            .entry(gradient.key())
            .or_insert_with(|| (*gradient).clone());
    }
    drafts.sort_unstable_by_key(|(index, _)| *index);
    let mut changed = false;
    bank.declared.retain(|identity, _| {
        let keep = live.get(*identity).is_some_and(|index| {
            drafts
                .binary_search_by_key(&index, |(index, _)| *index)
                .is_ok()
        });
        changed |= !keep;
        keep
    });
    for (index, gradient) in drafts {
        changed |= bank
            .declared
            .insert(nodes[index].identity(), gradient.key())
            != Some(gradient.key());
    }
    if !bank.unused() {
        resources.get_or_insert_with(Default::default).backgrounds = Some(bank);
    }
    super::image::prune(resources);
    Ok(changed)
}

impl<M: View + 'static, L: crate::remote::LaneSet<M>> Win<M, L> {
    pub(super) fn paint_property<T>(
        &self,
        target: Target,
        property: Property<T, PaintStyle>,
    ) -> Result<T, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let index = runtime.resolve_index(target)?;
        Ok(property.get(&PaintStyle {
            background: runtime.background(index),
        }))
    }
    pub(super) fn paint_contribution<T>(
        &self,
        target: Target,
        property: Property<T, PaintStyle>,
    ) -> Result<Contribution<T>, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let identity = runtime.resolve(target)?;
        Ok(match runtime.background_contribution(identity) {
            Contribution::Inherit => Contribution::Inherit,
            Contribution::Set(PropertyValue::Brush(value)) => {
                Contribution::Set(property.get(&PaintStyle { background: value }))
            }
            _ => unreachable!(),
        })
    }
    /// Borrow the lossless author geometry/stops for an admitted gradient key.
    /// The current target and its resolved background must both match. Keys
    /// alone are not a persistence format or authority to install a resource.
    pub fn gradient(&self, target: Target, key: GradientKey) -> Result<GradientView<'_>, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        let index = runtime.resolve_index(target)?;
        if runtime.background(index) != Brush::Gradient(key) {
            return Err(Error::StaleResource);
        }
        runtime
            .backgrounds()
            .and_then(|b| b.resources.get(&key))
            .map(Gradient::view)
            .ok_or(Error::StaleResource)
    }
}
impl<M: View + 'static, L: crate::remote::LaneSet<M>> RuntimeMut<'_, M, L> {
    pub(super) fn set_background_value(
        &mut self,
        index: usize,
        contribution: Contribution<PropertyValue>,
    ) -> Result<bool, Error> {
        let brush = match contribution {
            Contribution::Inherit => None,
            Contribution::Set(PropertyValue::Color(c)) => Some(Brush::Solid(c)),
            Contribution::Set(PropertyValue::Brush(b)) => Some(b),
            _ => unreachable!("validated background kind"),
        };
        if let Some(Brush::Gradient(key)) = brush
            && self
                .backgrounds()
                .is_none_or(|b| !b.resources.contains_key(&key))
        {
            return Err(Error::StaleResource);
        }
        let before = self.background(index);
        // Solid contributions live only in the existing style override lane.
        // A gradient also masks solid source ports with a transparent cache.
        let compiled = match brush {
            None => Contribution::Inherit,
            Some(Brush::Solid(c)) => Contribution::Set(PropertyValue::Color(c)),
            Some(Brush::Gradient(_)) => Contribution::Set(PropertyValue::Color(Color::TRANSPARENT)),
        };
        self.set_style_value(index, PropertyId::Background, compiled)?;
        let identity = self.nodes[index].identity();
        if let Some(bank) = self.images.as_mut().and_then(|r| r.backgrounds.as_mut()) {
            let key = match brush {
                Some(Brush::Gradient(key)) => Some(key),
                _ => None,
            };
            let previous = if let Some(key) = key {
                bank.overrides.insert(identity, key)
            } else {
                bank.overrides.remove(&identity)
            };
            if let Some(previous) = previous.filter(|previous| Some(*previous) != key) {
                bank.release_unused(previous);
            }
            if bank.unused() {
                self.images.as_mut().unwrap().backgrounds = None;
            }
            super::image::prune(&mut self.images);
        }
        let changed = !crate::property::BACKGROUND.same_authoring(&before, &self.background(index));
        self.changed_nodes = usize::from(changed);
        self.dirty |= changed;
        Ok(changed)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        El, Extend, GradientGeometry, GradientStop, Interpolation, WindowOptions, div,
        property::BACKGROUND,
    };
    fn gradient(color: Color) -> Gradient {
        Gradient::new(
            GradientGeometry::Linear {
                start: Point::default(),
                end: Point { x: 1., y: 0. },
            },
            &[
                GradientStop::new(0., Color::TRANSPARENT),
                GradientStop::new(0.5, color),
                GradientStop::new(0.5, Color::BLACK),
                GradientStop::new(1., color),
            ],
            Extend::Reflect,
            Interpolation::LinearSrgb,
        )
        .unwrap()
    }
    struct Page {
        paint: Option<Gradient>,
        bad: bool,
    }
    impl View for Page {
        fn view(&self) -> El<'_> {
            let mut el = div().size(16).rounded(3.);
            if let Some(paint) = &self.paint {
                el = el.bg(paint);
            }
            if self.bad {
                el = el.transform(Affine::scale(0., 1.));
            }
            el
        }
    }
    struct Pair {
        paint: Option<Gradient>,
        replace_first: bool,
    }
    impl View for Pair {
        fn view(&self) -> El<'_> {
            let painted = |name| {
                let mut el = div().size(8).name(name);
                if let Some(paint) = &self.paint {
                    el = el.bg(paint);
                }
                el
            };
            crate::column((
                if self.replace_first {
                    crate::button("replacement")
                } else {
                    painted("first")
                },
                painted("second"),
            ))
        }
    }
    #[test]
    fn shared_resource_overrides_follow_surviving_owners_with_one_resource() {
        let paint = gradient(Color::WHITE);
        let key = paint.key();
        let mut win = Win::with_size(
            Pair {
                paint: Some(paint),
                replace_first: false,
            },
            24,
            24,
        )
        .unwrap();
        let first = win.query().name("first").one().unwrap();
        let second = win.query().name("second").one().unwrap();
        assert_eq!(
            win.runtime()
                .unwrap()
                .backgrounds()
                .unwrap()
                .resources
                .len(),
            1
        );
        assert_eq!(
            win.with_scene(|scene, _| scene.gradients().count())
                .unwrap(),
            1
        );
        for target in [first, second] {
            win.set_property(target, BACKGROUND, Contribution::Set(Brush::Gradient(key)))
                .unwrap();
        }
        win.update(|page| page.paint = None).unwrap();
        assert!(
            win.runtime()
                .unwrap()
                .backgrounds()
                .unwrap()
                .declared
                .is_empty()
        );
        assert_eq!(
            win.runtime()
                .unwrap()
                .backgrounds()
                .unwrap()
                .overrides
                .len(),
            2
        );
        win.update(|page| page.replace_first = true).unwrap();
        assert_eq!(win.property(first, BACKGROUND), Err(Error::StaleTarget));
        assert_eq!(win.query().name("second").one().unwrap(), second);
        assert_eq!(
            win.property(second, BACKGROUND).unwrap(),
            Brush::Gradient(key)
        );
        assert_eq!(
            win.runtime()
                .unwrap()
                .backgrounds()
                .unwrap()
                .overrides
                .len(),
            1
        );
        assert_eq!(
            win.runtime()
                .unwrap()
                .backgrounds()
                .unwrap()
                .resources
                .len(),
            1
        );
        win.set_property(second, BACKGROUND, Contribution::Inherit)
            .unwrap();
        assert!(win.runtime().unwrap().images.is_none());
        assert_eq!(
            win.with_scene(|scene, _| scene.gradients().count())
                .unwrap(),
            0
        );
    }
    #[test]
    fn combined_budget_deduplicates_shared_declarations_and_overrides_before_mutation() {
        let first = gradient(Color::WHITE);
        let first_key = first.key();
        let second = gradient(Color::BLACK);
        let second_key = second.key();
        assert_eq!(first.view().byte_len(), 304);
        let mut win = Win::with_size(
            Pair {
                paint: Some(first),
                replace_first: false,
            },
            24,
            24,
        )
        .unwrap();
        for name in ["first", "second"] {
            let target = win.query().name(name).one().unwrap();
            win.set_property(
                target,
                BACKGROUND,
                Contribution::Set(Brush::Gradient(first_key)),
            )
            .unwrap();
        }
        let token = win.with_scene(|_, token| token).unwrap();
        let pixels = win.runtime_mut().unwrap().canvas.pixels().to_vec();
        // Exactly64MiB after two distinct304-byte gradients. Each new gradient
        // declaration and each preceding override occurs twice in the input.
        let image = |width, height| {
            crate::Image::linear_srgb(
                width,
                height,
                crate::AlphaMode::Premultiplied,
                vec![[0.; 4]; width as usize * height as usize].into_boxed_slice(),
            )
            .unwrap()
        };
        let images = vec![image(2048, 2047), image(2010, 1)];
        assert_eq!(
            images.iter().map(crate::Image::pixel_bytes).sum::<usize>() + 608,
            gpui_canvas::MAX_IMAGE_SCENE_BYTES
        );
        let mut runtime = win.runtime_mut().unwrap();
        let Runtime {
            images: owner,
            nodes,
            ..
        } = &mut *runtime;
        let live = IdentityIndex::from_ids(nodes.iter().map(Node::identity));
        let identities = [nodes[1].identity(), nodes[2].identity()];
        owner.as_mut().unwrap().logical = images;
        assert!(reconcile(owner, nodes, &live, vec![(1, &second), (2, &second)]).unwrap());
        let bank = owner.as_ref().unwrap().backgrounds.as_ref().unwrap();
        assert_eq!(bank.resources.len(), 2);
        for identity in identities {
            assert_eq!(bank.declared[&identity], second_key);
            assert_eq!(bank.overrides[&identity], first_key);
        }
        let third = gradient(Color::rgb(255, 0, 0));
        owner.as_mut().unwrap().logical.push(
            crate::Image::rgba8(
                1,
                1,
                crate::ImageProfile::Srgb,
                crate::AlphaMode::Straight,
                vec![0; 4].into_boxed_slice(),
            )
            .unwrap(),
        );
        assert_eq!(
            reconcile(owner, nodes, &live, vec![(1, &third), (2, &third)]),
            Err(Error::ResourceLimit)
        );
        let bank = owner.as_ref().unwrap().backgrounds.as_ref().unwrap();
        assert_eq!(bank.resources.len(), 2);
        assert!(!bank.resources.contains_key(&third.key()));
        for identity in identities {
            assert_eq!(bank.declared[&identity], second_key);
            assert_eq!(bank.overrides[&identity], first_key);
        }
        drop(runtime);
        win.with_scene(|scene, current| {
            assert_eq!(current, token);
            assert_eq!(scene.images().count(), 0);
            assert_eq!(scene.gradients().next().unwrap().key(), first_key);
        })
        .unwrap();
        assert_eq!(win.runtime_mut().unwrap().canvas.pixels(), pixels);
    }
    #[test]
    fn solid_and_gradient_overrides_share_presence_and_prune_only_displaced_resources() {
        let first = gradient(Color::WHITE);
        let first_key = first.key();
        let mut win = Win::with_size(
            Page {
                paint: Some(first),
                bad: false,
            },
            24,
            24,
        )
        .unwrap();
        let target = win.inspect().unwrap().nodes[0].target.unwrap();
        win.set_property(
            target,
            BACKGROUND,
            Contribution::Set(Brush::Gradient(first_key)),
        )
        .unwrap();
        let second = gradient(Color::rgb(255, 0, 0));
        let second_key = second.key();
        win.update(|page| page.paint = Some(second)).unwrap();
        // The explicit resource contribution pins its preceding author lease.
        assert_eq!(
            win.property(target, BACKGROUND).unwrap(),
            Brush::Gradient(first_key)
        );
        assert_eq!(
            win.runtime()
                .unwrap()
                .backgrounds()
                .unwrap()
                .resources
                .len(),
            2
        );
        win.set_property(
            target,
            BACKGROUND,
            Contribution::Set(Brush::Solid(Color::WHITE)),
        )
        .unwrap();
        assert_eq!(
            win.contribution(target, BACKGROUND).unwrap(),
            Contribution::Set(Brush::Solid(Color::WHITE))
        );
        assert!(
            win.runtime()
                .unwrap()
                .backgrounds()
                .unwrap()
                .overrides
                .is_empty()
        );
        assert_eq!(
            win.runtime()
                .unwrap()
                .backgrounds()
                .unwrap()
                .resources
                .len(),
            1
        );
        assert_eq!(
            win.set_property(
                target,
                BACKGROUND,
                Contribution::Set(Brush::Gradient(first_key))
            ),
            Err(Error::StaleResource)
        );
        assert_eq!(
            win.property(target, BACKGROUND).unwrap(),
            Brush::Solid(Color::WHITE)
        );
        let third = gradient(Color::rgb(0, 255, 0));
        let third_key = third.key();
        win.update(|page| page.paint = Some(third)).unwrap();
        assert_eq!(
            win.property(target, BACKGROUND).unwrap(),
            Brush::Solid(Color::WHITE)
        );
        assert!(
            !win.runtime()
                .unwrap()
                .backgrounds()
                .unwrap()
                .resources
                .contains_key(&second_key)
        );
        win.set_property(target, BACKGROUND, Contribution::Inherit)
            .unwrap();
        assert_eq!(
            win.property(target, BACKGROUND).unwrap(),
            Brush::Gradient(third_key)
        );
        // An equal transparent compiled value is still an explicit solid arm.
        win.set_property(
            target,
            BACKGROUND,
            Contribution::Set(Brush::Solid(Color::TRANSPARENT)),
        )
        .unwrap();
        assert_eq!(
            win.property(target, BACKGROUND).unwrap(),
            Brush::Solid(Color::TRANSPARENT)
        );
        assert_eq!(
            win.with_scene(|scene, _| scene.gradients().count())
                .unwrap(),
            0
        );
        win.set_property(target, BACKGROUND, Contribution::Inherit)
            .unwrap();
        assert_eq!(
            win.property(target, BACKGROUND).unwrap(),
            Brush::Gradient(third_key)
        );
        win.set_property(
            target,
            BACKGROUND,
            Contribution::Set(Brush::Gradient(third_key)),
        )
        .unwrap();
        win.update(|page| page.paint = None).unwrap();
        assert_eq!(
            win.property(target, BACKGROUND).unwrap(),
            Brush::Gradient(third_key)
        );
        win.set_property(target, BACKGROUND, Contribution::Inherit)
            .unwrap();
        assert!(win.runtime().unwrap().images.is_none());
        assert_eq!(
            win.contribution(target, BACKGROUND).unwrap(),
            Contribution::Inherit
        );
        assert_eq!(
            win.property(target, BACKGROUND).unwrap(),
            Brush::Solid(Style::DEFAULT.bg)
        );
    }
    #[test]
    fn gradient_description_and_paint_edit_allocation_audit() {
        let resource = gradient(Color::WHITE);
        let key = resource.key();
        let mut win = Win::with_size(
            Page {
                paint: Some(resource.clone()),
                bad: false,
            },
            24,
            24,
        )
        .unwrap();
        let target = win.inspect().unwrap().nodes[0].target.unwrap();
        win.update(|_| {}).unwrap();
        let before = win.runtime().unwrap().counters.descriptions;
        let cost = allocation_counter::measure(|| {
            for _ in 0..16 {
                win.update(|_| {}).unwrap();
            }
        });
        eprintln!(
            "gradient_work_audit,path=unchanged-owner-describe,iterations=16,descriptions={},allocs={},requested={},retained_delta={},peak_delta={}",
            win.runtime().unwrap().counters.descriptions - before,
            cost.count_total,
            cost.bytes_total,
            cost.bytes_current,
            cost.bytes_max
        );
        win.set_property(target, BACKGROUND, Contribution::Set(Brush::Gradient(key)))
            .unwrap();
        let before = win.runtime().unwrap().counters.descriptions;
        let cost = allocation_counter::measure(|| {
            for _ in 0..16 {
                win.set_property(target, BACKGROUND, Contribution::Set(Brush::Gradient(key)))
                    .unwrap();
            }
        });
        eprintln!(
            "gradient_work_audit,path=equal-gradient-contribution,iterations=16,descriptions={},allocs={},requested={},retained_delta={},peak_delta={}",
            win.runtime().unwrap().counters.descriptions - before,
            cost.count_total,
            cost.bytes_total,
            cost.bytes_current,
            cost.bytes_max
        );
        let before = win.runtime().unwrap().counters.descriptions;
        let cost = allocation_counter::measure(|| {
            for _ in 0..8 {
                win.set_property(
                    target,
                    BACKGROUND,
                    Contribution::Set(Brush::Solid(Color::WHITE)),
                )
                .unwrap();
                win.set_property(target, BACKGROUND, Contribution::Set(Brush::Gradient(key)))
                    .unwrap();
            }
        });
        eprintln!(
            "gradient_work_audit,path=changed-solid-gradient-contribution,iterations=16,descriptions={},allocs={},requested={},retained_delta={},peak_delta={}",
            win.runtime().unwrap().counters.descriptions - before,
            cost.count_total,
            cost.bytes_total,
            cost.bytes_current,
            cost.bytes_max
        );
        let mut runtime = win.runtime_mut().unwrap();
        let Runtime { images, nodes, .. } = &mut *runtime;
        let live = IdentityIndex::from_ids(nodes.iter().map(Node::identity));
        let drafts = vec![(0, &resource)];
        let cost = allocation_counter::measure(|| {
            assert!(!reconcile(images, nodes, &live, drafts).unwrap());
        });
        eprintln!(
            "gradient_work_audit,path=unchanged-reconcile-excluding-input-vec,iterations=1,allocs={},requested={},retained_delta={},peak_delta={}",
            cost.count_total, cost.bytes_total, cost.bytes_current, cost.bytes_max
        );
        drop(runtime);
        win.set_property(target, BACKGROUND, Contribution::Inherit)
            .unwrap();
        let mut runtime = win.runtime_mut().unwrap();
        let Runtime { images, nodes, .. } = &mut *runtime;
        let live = IdentityIndex::from_ids(nodes.iter().map(Node::identity));
        let drafts = vec![(0, &resource)];
        let cost = allocation_counter::measure(|| {
            assert!(!reconcile(images, nodes, &live, drafts).unwrap());
        });
        eprintln!(
            "gradient_work_audit,path=unchanged-reconcile-no-overrides-excluding-input-vec,iterations=1,allocs={},requested={},retained_delta={},peak_delta={}",
            cost.count_total, cost.bytes_total, cost.bytes_current, cost.bytes_max
        );
        assert_eq!(
            cost.count_total, 0,
            "unchanged declarations reuse their existing resource and identity authorities"
        );
    }
    #[test]
    fn gradient_background_typed_reflection_owner_validation_and_replacement_are_coherent() {
        assert_eq!(size_of::<Color>(), 16);
        assert_eq!(size_of::<Style>(), 88);
        assert_eq!(size_of::<Node>(), 24);
        assert_eq!(size_of::<crate::property::PropertyValue>(), 28);
        assert_eq!(size_of::<crate::style_port::PropInput<'_, Color>>(), 48);
        assert_eq!(size_of::<crate::semantic::ElementExtra<'_>>(), 56);
        assert_eq!(size_of::<Destination>(), 4);
        let first = gradient(Color::linear_srgb(3., -0.25, 0.5, 0.75).unwrap());
        let first_key = first.key();
        let mut win = Win::with_size(
            Page {
                paint: Some(first),
                bad: false,
            },
            24,
            24,
        )
        .unwrap();
        let target = win.inspect().unwrap().nodes[0].target.unwrap();
        assert_eq!(
            win.property(target, BACKGROUND).unwrap(),
            Brush::Gradient(first_key)
        );
        assert_eq!(
            win.property_value(target, PropertyId::Background).unwrap(),
            PropertyValue::Brush(Brush::Gradient(first_key))
        );
        assert_eq!(win.gradient(target, first_key).unwrap().stop_count(), 4);
        win.set_property(
            target,
            BACKGROUND,
            Contribution::Set(Brush::Solid(Color::WHITE)),
        )
        .unwrap();
        assert_eq!(
            win.property(target, BACKGROUND).unwrap(),
            Brush::Solid(Color::WHITE)
        );
        assert_eq!(
            win.with_scene(|scene, _| scene.gradients().count())
                .unwrap(),
            0
        );
        win.set_property(target, BACKGROUND, Contribution::Inherit)
            .unwrap();
        assert_eq!(
            win.property(target, BACKGROUND).unwrap(),
            Brush::Gradient(first_key)
        );
        let other = gradient(Color::WHITE);
        assert_eq!(
            win.set_property(
                target,
                BACKGROUND,
                Contribution::Set(Brush::Gradient(other.key()))
            ),
            Err(Error::StaleResource)
        );
        assert_eq!(
            win.property(target, BACKGROUND).unwrap(),
            Brush::Gradient(first_key)
        );
        let next = gradient(Color::rgb(255, 0, 0));
        let next_key = next.key();
        win.update(|page| page.paint = Some(next)).unwrap();
        assert_eq!(
            win.property(target, BACKGROUND).unwrap(),
            Brush::Gradient(next_key)
        );
        assert!(matches!(
            win.gradient(target, first_key),
            Err(Error::StaleResource)
        ));
        assert_eq!(
            win.set_property(
                target,
                BACKGROUND,
                Contribution::Set(Brush::Gradient(first_key))
            ),
            Err(Error::StaleResource)
        );
        win.update(|page| page.paint = None).unwrap();
        assert_eq!(
            win.with_scene(|scene, _| scene.gradients().count())
                .unwrap(),
            0
        );
        assert!(
            win.runtime()
                .unwrap()
                .images
                .as_ref()
                .is_none_or(|r| r.backgrounds.is_none())
        );
        let g = gradient(Color::WHITE);
        assert!(
            div()
                .bg(&g)
                .bg(Color::BLACK)
                .flatten_lists(10, &(), |_, _, _, _| unreachable!())
                .unwrap()
                .backgrounds
                .is_empty()
        );
        assert_eq!(
            div()
                .bg(Color::BLACK)
                .bg(&g)
                .flatten_lists(10, &(), |_, _, _, _| unreachable!())
                .unwrap()
                .backgrounds
                .len(),
            1
        );
    }
    #[test]
    fn mounted_gradient_inspector_is_typed_read_only_and_exposes_author_stops() {
        struct Paint(Gradient);
        impl View for Paint {
            fn view(&self) -> El<'_> {
                div().size(32).bg(&self.0).name("gradient")
            }
        }
        let mut win = Win::with_inspector(
            Paint(gradient(Color::WHITE)),
            WindowOptions {
                size: [800, 560],
                ..Default::default()
            },
        )
        .unwrap();
        let target = win.query().name("gradient").one().unwrap();
        win.inspector_select(target).unwrap();
        let panel = win
            .role(crate::Role::ScrollView)
            .name("GPUI Inspector")
            .one()
            .unwrap();
        let choose = win.query().name("background").within(panel).one().unwrap();
        win.activate(choose).unwrap();
        assert!(
            win.contains_text(
                "Logical background:\nLinear, 4 stops, Reflect, LinearSrgb (read only)"
            )
            .unwrap()
        );
        let before = win.property(target, BACKGROUND).unwrap();
        let increase = win.query().name("Increase").within(panel).one().unwrap();
        win.activate(increase).unwrap();
        assert_eq!(win.property(target, BACKGROUND).unwrap(), before);
        assert_eq!(
            win.contribution(target, BACKGROUND).unwrap(),
            Contribution::Inherit
        );
        let Brush::Gradient(key) = before else {
            panic!()
        };
        assert_eq!(
            win.gradient(target, key).unwrap().stop(1).unwrap().offset,
            0.5
        );
        eprintln!(
            "gradient_gpui_headers,Color={},Style={},Node={},Destination={},PropertyValue={},PropInputColor={},ElementExtra={},SceneResources={},Backgrounds={},Runtime={},Metadata={}",
            size_of::<Color>(),
            size_of::<Style>(),
            size_of::<Node>(),
            size_of::<Destination>(),
            size_of::<PropertyValue>(),
            size_of::<crate::style_port::PropInput<'_, Color>>(),
            size_of::<crate::semantic::ElementExtra<'_>>(),
            size_of::<image::SceneResources>(),
            size_of::<Backgrounds>(),
            size_of::<Runtime<()>>(),
            size_of::<Metadata>()
        );
    }
    #[test]
    fn gradient_scene_predecessor_survives_failed_newer_source_stale_ack_loss_and_remove() {
        let first = gradient(Color::WHITE);
        let mut win = Win::recording(
            Page {
                paint: Some(first),
                bad: false,
            },
            WindowOptions {
                size: [24, 24],
                ..Default::default()
            },
        )
        .unwrap();
        let initial = win.with_scene(|_, token| token).unwrap();
        win.presented(initial).unwrap();
        let second = gradient(Color::rgb(255, 0, 0));
        let second_key = second.key();
        win.update(|p| p.paint = Some(second)).unwrap();
        let token2 = win.with_scene(|_, token| token).unwrap();
        let third = gradient(Color::rgb(0, 255, 0));
        let third_key = third.key();
        assert!(
            win.update(|p| {
                p.paint = Some(third);
                p.bad = true
            })
            .is_err()
        );
        assert_eq!(
            win.with_scene(|scene, _| scene.gradients().next().unwrap().key())
                .unwrap(),
            second_key
        );
        assert_eq!(win.presented(initial), Err(Error::StalePresentation));
        win.presented(token2).unwrap();
        win.presentation_lost().unwrap();
        assert_eq!(
            win.with_scene(|scene, _| scene.gradients().next().unwrap().key())
                .unwrap(),
            second_key
        );
        win.update(|p| p.bad = false).unwrap();
        let token3 = win.with_scene(|_, token| token).unwrap();
        assert_eq!(
            win.with_scene(|scene, _| scene.gradients().next().unwrap().key())
                .unwrap(),
            third_key
        );
        win.presented(token3).unwrap();
        win.update(|p| p.paint = None).unwrap();
        let removed = win
            .with_scene(|scene, token| {
                assert_eq!(scene.gradients().count(), 0);
                token
            })
            .unwrap();
        assert_eq!(win.presented(token3), Err(Error::StalePresentation));
        win.presented(removed).unwrap();
    }
}
