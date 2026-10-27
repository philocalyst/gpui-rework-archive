//! Sparse C text and geometry, retaining immutable P until acknowledgement.
use super::*;

impl<M: View + 'static> Runtime<M> {
    pub(super) fn try_sparse_text(
        &mut self,
        shaper: &mut gpui_canvas::TextShaper<'_>,
    ) -> Result<bool, Error> {
        let Some((epoch, index)) = self.text.as_ref().and_then(|t| t.dirty_text) else {
            return Ok(false);
        };
        if epoch != self.source_epoch
            || self.prepared.is_some()
            || !self.presentation_valid
            || self.presentation_size != self.requested_size
            || self.presentation_scale_factor != self.requested_scale_factor
            || self.layout_dirty.len() != 1
            || self.nodes[index].kind() != NodeKind::Text
        {
            return Ok(false);
        }
        let (row, transform, clip) =
            if self.metadata.is_some() || self.images.is_some() || !self.viewports.is_empty() {
                let Some(placement) = self.retained_text_placement(index) else {
                    return Ok(false);
                };
                placement
            } else {
                if self.presented.len() != self.nodes.len()
                    || self.presented[index].identity != self.nodes[index].identity()
                {
                    return Ok(false);
                }
                (
                    index,
                    self.presented[index]
                        .transform(geometry::Bases::new(&[]))
                        .ok_or(Error::Canvas(gpui_canvas::Error::InvalidGeometry))?,
                    Rect::new(
                        0.,
                        0.,
                        self.requested_size[0] as f32,
                        self.requested_size[1] as f32,
                    ),
                )
            };
        let owner = self.text.as_ref().unwrap();
        if owner.presented.len() < 2 {
            return Ok(false);
        }
        let Some(previous) = owner.entry(row) else {
            return Ok(false);
        };
        let Some(run) = previous.run else {
            return Ok(false);
        };
        let origin = previous.origin;
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
            style.line_height,
            Some(layout.content_box_width()),
            None,
        )?;
        let patch = Box::new(text_geometry::TextPatch {
            row,
            value,
            geometry: text_geometry::Entry {
                row: row as u32,
                run: Some(run),
                origin,
                map: shape.retain_geometry().expect("interactive text geometry"),
            },
        });
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
            clip,
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

    // Keep optional scene features out of the ordinary positional proof. The
    // caller has already certified unchanged layout/topology and an acknowledged
    // predecessor. Canvas independently verifies exact clip/material/run leases.
    #[inline(never)]
    fn retained_text_placement(&self, logical: usize) -> Option<(usize, Affine, Rect)> {
        if self.inspector_enabled() || self.metadata.as_ref().is_some_and(|m| m.editing.is_some()) {
            return None;
        }
        query::retained_text_placement(self, logical)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{El, Signal, column, text};

    #[cfg(all(any(feature = "x11", feature = "x11-minimal"), target_os = "linux"))]
    #[test]
    fn representative_workload_local_publication_admission() {
        for case in ["stream", "stream-owner", "scroll", "both", "fractional"] {
            let mut fixture = crate::native::workload_port::CostFixture::new(case);
            let token = fixture.owner.with_scene(|_, token| token).unwrap();
            fixture.owner.presented(token).unwrap();
            let mut patches = 0;
            let mut full = 0;
            let mut unchanged_layout = 0;
            let runtime = fixture.owner.runtime().unwrap();
            if case == "stream" {
                let bits = |r: Rect| [r.x, r.y, r.width, r.height].map(f32::to_bits);
                for group in runtime.canvas.prepared_scene().groups() {
                    if group.bounds().len() > 500 {
                        println!(
                            "LOCAL_RASTER_CLIP,{:?},chain={}",
                            bits(group.clip),
                            group.clip_chain().is_some()
                        );
                    }
                }
                for (index, node) in runtime.nodes.iter().enumerate() {
                    if node
                        .text_slot()
                        .get(&runtime.texts)
                        .is_some_and(|t| t.value.len() > 500)
                    {
                        println!(
                            "LOCAL_P_CLIP,{:?}",
                            runtime
                                .retained_text_placement(index)
                                .map(|(row, _, clip)| (row, bits(clip)))
                        );
                    }
                }
            }
            println!(
                "LOCAL_INPUT,{case},clips={},editing={},inspector={}",
                runtime.canvas.prepared_scene().clip_nodes().count(),
                runtime
                    .metadata
                    .as_ref()
                    .is_some_and(|m| m.editing.is_some()),
                runtime.inspector_enabled(),
            );
            for _ in 0..80 {
                let writes = fixture
                    .owner
                    .runtime()
                    .unwrap()
                    .layout
                    .stats()
                    .changed_layout_writes;
                fixture.advance(case);
                let runtime = fixture.owner.runtime().unwrap();
                unchanged_layout +=
                    usize::from(runtime.layout.stats().changed_layout_writes == writes);
                patches += usize::from(runtime.text.as_ref().is_some_and(|t| t.patch.is_some()));
                full += usize::from(runtime.prepared.as_ref().is_some_and(|p| !p.keeps_rows()));
                let token = fixture.owner.with_scene(|_, token| token).unwrap();
                fixture.owner.presented(token).unwrap();
            }
            println!(
                "LOCAL_PUBLICATION,{case},updates=80,patches={patches},full={full},unchanged_layout={unchanged_layout}"
            );
        }
    }
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
}
