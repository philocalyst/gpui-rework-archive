//! Sparse C text and geometry, retaining immutable P until acknowledgement.
use super::*;

impl<M: View + 'static> Runtime<M> {
    pub(super) fn try_sparse_text(
        &mut self,
        shaper: &mut gpui_canvas::TextShaper<'_>,
    ) -> Result<bool, Error> {
        let Some(text_geometry::DirtyText::One(epoch, index)) =
            self.text.as_ref().and_then(|t| t.dirty_text)
        else {
            return self.try_sparse_text_batch(shaper);
        };
        if epoch != self.source_epoch
            || self.prepared.is_some()
            || !self.presentation_valid
            || self.metadata.is_some()
            || self.images.is_some()
            || !self.viewports.is_empty()
            || self.presentation_size != self.requested_size
            || self.presentation_scale_factor != self.requested_scale_factor
            || self.layout_dirty.len() != 1
            || self.nodes[index].kind() != NodeKind::Text
            || self.presented.len() != self.nodes.len()
            || self.presented[index].identity != self.nodes[index].identity()
        {
            return Ok(false);
        }
        let owner = self.text.as_ref().unwrap();
        if owner.presented.len() < 2 {
            return Ok(false);
        }
        let Some(previous) = owner.entry(index) else {
            return Ok(false);
        };
        let Some(run) = previous.run else {
            return Ok(false);
        };
        let origin = previous.origin;
        let transform = self.presented[index]
            .transform(geometry::Bases::new(&[]))
            .ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?;
        let layout = self.layout.layout(self.layout_nodes[index])?;
        let style = self.styles.get(index);
        let text = self.nodes[index]
            .text_slot()
            .get_mut(&mut self.texts)
            .unwrap();
        let value = text.value.clone();
        let shape = text.shape_text(
            shaper,
            style.font_size,
            Some(layout.content_box_width()),
            None,
        )?;
        let patch = vec![text_geometry::TextPatch {
            row: index,
            value,
            geometry: text_geometry::Entry {
                row: index as u32,
                run: Some(run),
                origin,
                map: shape.retain_geometry().expect("interactive text geometry"),
            },
        }]
        .into_boxed_slice();
        let sequence = self.next_presentation;
        let next = sequence.checked_add(1).ok_or(Error::EpochExhausted)?;
        let token = PresentationToken {
            window: self.sites.namespace(),
            sequence,
        };
        let service = self.text.as_mut().unwrap().system.as_mut().unwrap();
        let Some(damage) = self.canvas.try_patch_text(
            run,
            service,
            shape,
            origin,
            transform,
            Rect::new(
                0.,
                0.,
                self.requested_size[0] as f32,
                self.requested_size[1] as f32,
            ),
            style.fg,
            self.requested_scale_factor,
        )?
        else {
            return Ok(false);
        };
        self.text.as_mut().unwrap().patch = Some(patch);
        self.text.as_mut().unwrap().dirty_text = None;
        self.layout_dirty.clear();
        self.styles.clear_slot_transition();
        // Native accessibility takes its independent full projection when the
        // text changes. Paint-only relabelling cannot certify semantic equality.
        #[cfg(feature = "accessibility")]
        if let Some(observer) = &mut self.accessibility {
            observer.invalidate();
        }
        self.counters.paint_passes += 1;
        self.publish_paint(Some((damage, token, next)))?;
        Ok(true)
    }
}

impl<M: View + 'static> Runtime<M> {
    #[inline(never)]
    fn try_sparse_text_batch(
        &mut self,
        shaper: &mut gpui_canvas::TextShaper<'_>,
    ) -> Result<bool, Error> {
        let Some(text_geometry::DirtyText::Batch(epoch)) =
            self.text.as_ref().and_then(|t| t.dirty_text)
        else {
            return Ok(false);
        };
        if epoch != self.source_epoch
            || self.prepared.is_some()
            || !self.presentation_valid
            || self.metadata.is_some()
            || self.images.is_some()
            || !self.viewports.is_empty()
            || self.presentation_size != self.requested_size
            || self.presentation_scale_factor != self.requested_scale_factor
            || !(2..=4).contains(&self.layout_dirty.len())
            || self.presented.len() != self.nodes.len()
        {
            return Ok(false);
        }
        let mut indices: Vec<_> = self
            .layout_dirty
            .iter()
            .map(|&id| self.by_identity.required(id))
            .collect();
        indices.sort_unstable();
        let mut shapes = Vec::with_capacity(indices.len());
        let mut patches = Vec::with_capacity(indices.len());
        for index in indices {
            if self.nodes[index].kind() != NodeKind::Text
                || self.presented[index].identity != self.nodes[index].identity()
            {
                return Ok(false);
            }
            let owner = self.text.as_ref().unwrap();
            let Some(previous) = owner.entry(index) else {
                return Ok(false);
            };
            let Some(run) = previous.run else {
                return Ok(false);
            };
            let origin = previous.origin;
            let transform = self.presented[index]
                .transform(geometry::Bases::new(&[]))
                .ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?;
            let layout = self.layout.layout(self.layout_nodes[index])?;
            let style = self.styles.get(index);
            let text = self.nodes[index]
                .text_slot()
                .get_mut(&mut self.texts)
                .unwrap();
            let value = text.value.clone();
            let shape = text
                .shape_text(
                    shaper,
                    style.font_size,
                    Some(layout.content_box_width()),
                    None,
                )?
                .clone();
            patches.push(text_geometry::TextPatch {
                row: index,
                value,
                geometry: text_geometry::Entry {
                    row: index as u32,
                    run: Some(run),
                    origin,
                    map: shape.retain_geometry().expect("interactive text geometry"),
                },
            });
            shapes.push((run, shape, origin, transform, style.fg));
        }
        let sequence = self.next_presentation;
        let next = sequence.checked_add(1).ok_or(Error::EpochExhausted)?;
        let token = PresentationToken {
            window: self.sites.namespace(),
            sequence,
        };
        let replacements: Vec<_> = shapes
            .iter()
            .map(
                |(slot, layout, origin, transform, color)| gpui_canvas::TextRunReplacement {
                    slot: *slot,
                    layout,
                    origin: *origin,
                    transform: *transform,
                    clip: Rect::new(
                        0.,
                        0.,
                        self.requested_size[0] as f32,
                        self.requested_size[1] as f32,
                    ),
                    color: *color,
                    raster_scale: self.requested_scale_factor,
                },
            )
            .collect();
        let service = self.text.as_mut().unwrap().system.as_mut().unwrap();
        let Some(damage) = self.canvas.try_patch_texts(service, &replacements)? else {
            return Ok(false);
        };
        let owner = self.text.as_mut().unwrap();
        owner.patch = Some(patches.into_boxed_slice());
        owner.dirty_text = None;
        self.layout_dirty.clear();
        self.styles.clear_slot_transition();
        #[cfg(feature = "accessibility")]
        if let Some(observer) = &mut self.accessibility {
            observer.invalidate();
        }
        self.counters.paint_passes += 1;
        self.publish_paint(Some((damage, token, next)))?;
        Ok(true)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{El, Signal, column, text};
    struct Page {
        label: Signal<String>,
    }
    impl Page {
        const LABEL: crate::Source<Self, String> =
            crate::Source::new(FieldId::new(1), "label", |m| &m.label, |m| &mut m.label);
    }
    impl View for Page {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::LABEL)
        }
        fn view(&self) -> El<'_> {
            column((
                text(&self.label).w(180).h(24),
                text("Count: 0123456789").w(180).h(24),
            ))
            .w(192)
            .h(80)
        }
    }
    #[test]
    fn direct_text_prepares_a_sparse_candidate_and_defers_p_mutation() {
        let mut win = Win::recording(
            Page {
                label: Signal::new("Count: 10".into()),
            },
            WindowOptions {
                size: [192, 80],
                ..Default::default()
            },
        )
        .unwrap();
        win.presented(win.with_scene(|_, token| token).unwrap())
            .unwrap();
        let before = {
            let r = win.runtime().unwrap();
            (
                r.layout.stats(),
                r.layout_nodes
                    .iter()
                    .map(|&id| r.layout.layout(id).unwrap())
                    .collect::<Vec<_>>(),
            )
        };
        win.set(Page::LABEL, "Count: 11".into()).unwrap();
        let runtime = win.runtime().unwrap();
        eprintln!(
            "layout write delta={} final differing layouts={}",
            runtime.layout.stats().changed_layout_writes - before.0.changed_layout_writes,
            runtime
                .layout_nodes
                .iter()
                .enumerate()
                .filter(|(i, id)| runtime.layout.layout(**id).unwrap() != before.1[*i])
                .count()
        );
        assert!(runtime.prepared.as_ref().unwrap().keeps_rows());
        assert!(runtime.text.as_ref().unwrap().patch.is_some());
        assert!(runtime.text.as_ref().unwrap().candidate.is_none());
        assert!(runtime.prepared.as_ref().unwrap().nodes.is_empty());
        assert!(
            runtime
                .presented
                .iter()
                .any(|n| n.text.as_deref() == Some("Count: 10"))
        );
    }
    #[test]
    fn batched_text_prepares_sparse_rows_before_acknowledgement() {
        struct Pair {
            a: Signal<String>,
            b: Signal<String>,
        }
        impl Pair {
            const A: crate::Source<Self, String> =
                crate::Source::new(FieldId::new(1), "a", |m| &m.a, |m| &mut m.a);
            const B: crate::Source<Self, String> =
                crate::Source::new(FieldId::new(2), "b", |m| &m.b, |m| &mut m.b);
        }
        impl View for Pair {
            fn sources() -> Sources<Self> {
                Sources::new().direct(Self::A).direct(Self::B)
            }
            fn view(&self) -> El<'_> {
                column((text(&self.a).w(180).h(24), text(&self.b).w(180).h(24)))
                    .w(192)
                    .h(80)
            }
        }
        let win = Win::recording(
            Pair {
                a: Signal::new("11".into()),
                b: Signal::new("22".into()),
            },
            WindowOptions {
                size: [192, 80],
                ..Default::default()
            },
        )
        .unwrap();
        let (a, ai) = crate::Remote::bounded(2);
        let (b, bi) = crate::Remote::bounded(2);
        let mut win = win
            .with_inbox_for(ai, Pair::A, |v, n| *v = n)
            .unwrap()
            .with_inbox_for(bi, Pair::B, |v, n| *v = n)
            .unwrap();
        win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
        a.try_send("22".into()).unwrap();
        b.try_send("11".into()).unwrap();
        win.deliver_ready(4).unwrap();
        let runtime = win.runtime().unwrap();
        assert!(runtime.prepared.as_ref().unwrap().keeps_rows());
        assert_eq!(
            runtime.text.as_ref().unwrap().patch.as_ref().unwrap().len(),
            2
        );
        assert!(runtime.text.as_ref().unwrap().candidate.is_none());
        assert_eq!(runtime.text.as_ref().unwrap().presented.len(), 2);
    }
    #[test]
    fn sparse_batch_layout_ledger() {
        eprintln!(
            "SPARSE_LAYOUT,text_resources={},dirty_text={},prior_dirty_text={},patch_owner={},prior_patch_owner={},patch_row={}",
            size_of::<text_geometry::TextResources>(),
            size_of::<Option<text_geometry::DirtyText>>(),
            size_of::<Option<(u64, usize)>>(),
            size_of::<Option<Box<[text_geometry::TextPatch]>>>(),
            size_of::<Option<Box<text_geometry::TextPatch>>>(),
            size_of::<text_geometry::TextPatch>()
        );
    }
}
