//! Cold distinct-resource ownership. No image handle is cloned per node.
use super::*;
use crate::{Image, ImageKey, ImageSampling};

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(super) struct ImageUse {
    pub resource: u32,
    pub sampling: ImageSampling,
}
#[derive(Default)]
pub(super) struct Images {
    pub logical: Vec<Image>,
    presented: Vec<Image>,
    pending: Option<(NonZeroU64, Vec<Image>)>,
}
impl Images {
    fn unused(&self) -> bool {
        self.logical.is_empty() && self.presented.is_empty() && self.pending.is_none()
    }
    pub(super) fn get(&self, image: ImageUse) -> &Image {
        &self.logical[image.resource as usize]
    }
    pub(super) fn candidate(&self) -> Result<Vec<Image>, Error> {
        let mut leases = Vec::new();
        leases
            .try_reserve_exact(self.logical.len())
            .map_err(|_| Error::ResourceLimit)?;
        leases.extend(self.logical.iter().cloned());
        Ok(leases)
    }
    pub(super) fn prepare(&mut self, sequence: NonZeroU64, leases: Vec<Image>) {
        self.pending = Some((sequence, leases));
    }
}
pub(super) fn describe(
    drafts: Vec<crate::image::ImageDraft<'_>>,
) -> Result<(Vec<Image>, BTreeMap<usize, ImageUse>), Error> {
    let mut resources = Vec::new();
    let mut indices = BTreeMap::<ImageKey, u32>::new();
    let mut nodes = BTreeMap::new();
    let mut bytes = 0usize;
    for draft in drafts {
        let image = draft.spec.resource;
        let resource = if let Some(&resource) = indices.get(&image.key()) {
            resource
        } else {
            bytes = bytes
                .checked_add(image.pixel_bytes())
                .ok_or(Error::ResourceLimit)?;
            if bytes > gpui_canvas::MAX_IMAGE_SCENE_BYTES {
                return Err(Error::ResourceLimit);
            }
            let resource = u32::try_from(resources.len()).map_err(|_| Error::ResourceLimit)?;
            resources.try_reserve(1).map_err(|_| Error::ResourceLimit)?;
            resources.push(image.clone());
            indices.insert(image.key(), resource);
            resource
        };
        nodes.insert(
            draft.node as usize,
            ImageUse {
                resource,
                sampling: draft.spec.sampling,
            },
        );
    }
    Ok((resources, nodes))
}
pub(super) fn reconcile(current: &mut Option<Box<Images>>, resources: Vec<Image>) {
    if !resources.is_empty() && current.is_none() {
        *current = Some(Box::default());
    }
    if let Some(current) = current {
        current.logical = resources;
    }
    prune(current);
}
pub(super) fn acknowledge(current: &mut Option<Box<Images>>, sequence: NonZeroU64) {
    if let Some(current) = current
        && current
            .pending
            .as_ref()
            .is_some_and(|(pending, _)| *pending == sequence)
    {
        current.presented = current.pending.take().unwrap().1;
    }
    prune(current);
}
fn prune(current: &mut Option<Box<Images>>) {
    if current.as_deref().is_some_and(Images::unused) {
        *current = None;
    }
}

pub(super) fn measure(image: &Image, input: MeasureInput) -> MeasureOutput {
    let ratio = image.width() as f32 / image.height() as f32;
    let (width, height) = match (input.known_dimensions.width, input.known_dimensions.height) {
        (Some(width), Some(height)) => (width, height),
        (Some(width), None) => (width, width / ratio),
        (None, Some(height)) => (height * ratio, height),
        (None, None) => (image.width() as f32, image.height() as f32),
    };
    MeasureOutput::from_size(Size { width, height })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{AlphaMode, El, ImageProfile, WindowOptions, div};
    struct Page {
        cover: Option<Image>,
        bad: bool,
    }
    impl View for Page {
        fn view(&self) -> El<'_> {
            self.cover.as_ref().map_or_else(div, |image| {
                crate::image(image).w(16).h(16).transform(if self.bad {
                    Affine::scale(0., 1.)
                } else {
                    Affine::IDENTITY
                })
            })
        }
    }
    fn cover(red: u8) -> Image {
        Image::rgba8(
            1,
            1,
            ImageProfile::Srgb,
            AlphaMode::Straight,
            vec![red, 17, 29, 255].into_boxed_slice(),
        )
        .unwrap()
    }
    #[test]
    fn image_only_owner_does_not_initialize_text_services() {
        let win = Win::with_size(
            Page {
                cover: Some(cover(17)),
                bad: false,
            },
            32,
            24,
        )
        .unwrap();
        let runtime = win.runtime().unwrap();
        println!(
            "Image={} ImageState={} Runtime={} Node={} Presented={} El={} Draft={} Style={} Canvas={}",
            size_of::<Image>(),
            size_of::<Images>(),
            size_of::<Runtime<Page>>(),
            size_of::<Node>(),
            size_of::<Presented>(),
            size_of::<El<'_>>(),
            size_of::<crate::element::DraftNode<'_>>(),
            size_of::<crate::Style>(),
            size_of::<Canvas>()
        );
        assert!(runtime.text.is_none());
        assert!(runtime.texts.is_empty());
        assert_eq!(runtime.images.as_ref().unwrap().logical.len(), 1);
        assert_eq!(runtime.images.as_ref().unwrap().presented.len(), 1);
    }
    #[test]
    fn exact_image_cohort_leases_survive_failed_newer_candidate_loss_and_removal() {
        let first = cover(17);
        let first_key = first.key();
        let mut win = Win::recording(
            Page {
                cover: Some(first),
                bad: false,
            },
            WindowOptions {
                size: [32, 24],
                ..Default::default()
            },
        )
        .unwrap();
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        let second = cover(149);
        let second_key = second.key();
        win.update(|page| page.cover = Some(second)).unwrap();
        let second_token = win.with_scene(|_, token| token).unwrap();
        let third = cover(219);
        let third_key = third.key();
        assert!(
            win.update(|page| {
                page.cover = Some(third);
                page.bad = true;
            })
            .is_err()
        );
        {
            let runtime = win.runtime().unwrap();
            let images = runtime.images.as_ref().unwrap();
            assert_eq!(images.logical[0].key(), third_key);
            assert_eq!(images.presented[0].key(), first_key);
            assert_eq!(images.pending.as_ref().unwrap().1[0].key(), second_key);
            assert_eq!(images.pending.as_ref().unwrap().0, second_token.sequence);
        }
        win.presented(second_token).unwrap();
        win.presentation_lost().unwrap();
        assert_eq!(
            win.runtime().unwrap().images.as_ref().unwrap().presented[0].key(),
            second_key
        );
        win.update(|page| page.bad = false).unwrap();
        let third_token = win.with_scene(|_, token| token).unwrap();
        assert_eq!(
            win.runtime().unwrap().images.as_ref().unwrap().presented[0].key(),
            second_key
        );
        win.presented(third_token).unwrap();
        assert_eq!(
            win.runtime().unwrap().images.as_ref().unwrap().presented[0].key(),
            third_key
        );
        win.update(|page| page.cover = None).unwrap();
        let removed = win.with_scene(|_, token| token).unwrap();
        assert_eq!(
            win.runtime().unwrap().images.as_ref().unwrap().presented[0].key(),
            third_key
        );
        win.presented(removed).unwrap();
        assert!(win.runtime().unwrap().images.is_none());
        assert_eq!(
            win.with_scene(|scene, _| scene.images().count()).unwrap(),
            0
        );
    }
}
