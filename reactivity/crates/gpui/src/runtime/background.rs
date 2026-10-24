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
    overrides: BTreeMap<u64, Brush>,
}
impl Backgrounds {
    fn brush(&self, identity: u64, solid: Color) -> Brush {
        self.overrides.get(&identity).copied().unwrap_or_else(|| {
            self.declared
                .get(&identity)
                .copied()
                .map_or(Brush::Solid(solid), Brush::Gradient)
        })
    }
    pub(super) fn gradient(&self, identity: u64) -> Option<&Gradient> {
        let Brush::Gradient(key) = self.brush(identity, Color::TRANSPARENT) else {
            return None;
        };
        self.resources.get(&key)
    }
    fn retain(&mut self, live: impl Fn(u64) -> bool) {
        self.declared.retain(|identity, _| live(*identity));
        self.overrides.retain(|identity, _| live(*identity));
        self.resources.retain(|key, _| {
            self.declared.values().any(|v| v == key)
                || self.overrides.values().any(|v| *v == Brush::Gradient(*key))
        });
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
        self.backgrounds().map_or(Brush::Solid(solid), |b| {
            b.brush(self.nodes[index].identity(), solid)
        })
    }
    pub(super) fn background_contribution(&self, identity: u64) -> Contribution<PropertyValue> {
        self.backgrounds()
            .and_then(|b| b.overrides.get(&identity))
            .copied()
            .map_or(Contribution::Inherit, |v| {
                Contribution::Set(PropertyValue::Brush(v))
            })
    }
}
pub(super) fn reconcile(
    resources: &mut Option<Box<super::image::SceneResources>>,
    dirty: &mut bool,
    nodes: &[Node],
    drafts: Vec<(usize, &Gradient)>,
) -> Result<(), Error> {
    if drafts.is_empty() && resources.as_ref().is_none_or(|r| r.backgrounds.is_none()) {
        return Ok(());
    }
    let live: BTreeSet<_> = nodes.iter().map(Node::identity).collect();
    let mut needed: BTreeMap<_, _> = drafts
        .iter()
        .map(|(_, g)| (g.key(), g.view().byte_len()))
        .collect();
    if let Some(bank) = resources.as_ref().and_then(|r| r.backgrounds.as_deref()) {
        for (identity, brush) in &bank.overrides {
            if live.contains(identity)
                && let Brush::Gradient(key) = brush
            {
                needed.insert(*key, bank.resources[key].view().byte_len());
            }
        }
    }
    let image_bytes = resources.as_ref().map_or(0, |r| {
        r.logical
            .iter()
            .map(crate::Image::pixel_bytes)
            .sum::<usize>()
    });
    let bytes = needed
        .values()
        .try_fold(image_bytes, |sum, bytes| sum.checked_add(*bytes))
        .ok_or(Error::ResourceLimit)?;
    if bytes > gpui_canvas::MAX_IMAGE_SCENE_BYTES {
        return Err(Error::ResourceLimit);
    }
    // Admission precedes removing or mutating any existing owner lease.
    let mut bank = resources
        .as_mut()
        .and_then(|r| r.backgrounds.take())
        .unwrap_or_default();
    let mut declared = BTreeMap::new();
    for (index, gradient) in drafts {
        declared.insert(nodes[index].identity(), gradient.key());
        bank.resources
            .entry(gradient.key())
            .or_insert_with(|| gradient.clone());
    }
    *dirty |= bank.declared != declared;
    bank.declared = declared;
    bank.overrides.retain(|identity, _| live.contains(identity));
    bank.resources.retain(|key, _| needed.contains_key(key));
    if !bank.unused() {
        resources.get_or_insert_with(Default::default).backgrounds = Some(bank);
    }
    super::image::prune(resources);
    Ok(())
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
        // This is the existing solid port's compiled cache and override mask.
        // The Brush contribution below is the sole inspected paint authority.
        let compiled = match brush {
            None => Contribution::Inherit,
            Some(Brush::Solid(c)) => Contribution::Set(PropertyValue::Color(c)),
            Some(Brush::Gradient(_)) => Contribution::Set(PropertyValue::Color(Color::TRANSPARENT)),
        };
        self.set_style_value(index, PropertyId::Background, compiled)?;
        let identity = self.nodes[index].identity();
        if brush.is_some() || self.backgrounds().is_some() {
            let bank = self
                .images
                .get_or_insert_with(Default::default)
                .backgrounds
                .get_or_insert_with(Default::default);
            if let Some(brush) = brush {
                bank.overrides.insert(identity, brush);
            } else {
                bank.overrides.remove(&identity);
            }
            bank.retain(|_| true);
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
    #[test]
    fn gradient_background_typed_reflection_owner_validation_and_replacement_are_coherent() {
        assert_eq!(size_of::<Color>(), 16);
        assert_eq!(size_of::<Style>(), 88);
        assert_eq!(size_of::<Node>(), 40);
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
