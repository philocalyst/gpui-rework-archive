from pathlib import Path
base=Path('/home/user/gpui-list-source-lab/reactivity/crates/gpui/src')
p=base/'runtime/turn.rs';s=p.read_text();at=s.index('    pub(super) fn operation(\n');s=s[:at]+'''    pub(super) fn validate_offsets(&mut self, values: &[(FieldId, f64)]) -> Result<(), Error> {
        match catch_unwind(AssertUnwindSafe(|| {
            for &(field, _) in values {
                self.runtime.sources.offset(&mut self.runtime.model, field, None)?;
            }
            Ok(())
        })) {
            Ok(result) => result,
            Err(_) => { self.poison(); Err(Error::OwnerPanicked) }
        }
    }

    // A wheel cohort can move nested ordinary/uncontrolled viewports and write
    // registered list sources. Gather first, validate every writer, then publish
    // the final model and viewport state through one normal source barrier.
    pub(super) fn scroll_sources(
        &mut self,
        values: &[(FieldId, f64)],
        viewports: &[(u64, crate::ScrollOffset, Option<ListId>)],
    ) -> Result<Commit, Error> {
        self.live()?;
        let epoch = self.source_epoch.checked_add(1).ok_or(Error::EpochExhausted)?;
        self.validate_offsets(values)?;
        let mut applied = 0;
        let result = catch_unwind(AssertUnwindSafe(|| -> Result<(), Error> {
            for &(field, value) in values {
                self.runtime.sources.offset(&mut self.runtime.model, field, Some(value))?;
                applied += 1;
            }
            Ok(())
        }));
        if applied != 0 {
            self.runtime.source_epoch = epoch;
            self.runtime.counters.source_operations += 1;
            self.runtime.changed_nodes = 0;
        }
        match result {
            Err(_) => { self.poison(); return Err(Error::OwnerPanicked); }
            Ok(Err(error)) => {
                if applied != 0 {
                    self.runtime.logical_valid = false;
                    self.runtime.clear_editing();
                    self.runtime.focused = None;
                }
                return Err(error);
            }
            Ok(Ok(())) => {}
        }
        for &(identity, offset, list) in viewports {
            match list {
                Some(id) => {
                    if let Some(ViewportState::List(state)) = self.runtime.viewports.get_mut(&ViewportKey::List(id))
                        && state.offset_field.is_none()
                    {
                        state.viewport.offset = offset.y;
                        state.anchor = None;
                    }
                }
                None => {
                    if let Some(ViewportState::Scroll(state)) = self.runtime.viewports.get_mut(&ViewportKey::Scroll(identity)) {
                        state.offset = offset;
                    }
                }
            }
        }
        let exact = values.first().map(|&(field, _)| field)
            .filter(|field| values.iter().all(|(other, _)| other == field));
        self.after_source_with_editing(exact, EditingIntent::None)
    }

'''+s[at:];p.write_text(s)
p=base/'runtime/scroll.rs';s=p.read_text();needle='''        let mut requests = Vec::new(); // Allocates only when virtual rows must be materialized.''';assert needle in s;s=s.replace(needle,'''        // Retain no new storage on the ordinary unbound path. Controlled input
        // gathers the same ordered viewport plan before borrowing the model mutably.
        if runtime.viewports.values().any(|state| state.list().is_some_and(|list| list.offset_field.is_some())) {
            let movements = {
                let state = &runtime.runtime;
                let Some(metadata) = &state.metadata else { return Ok(state.commit()); };
                let context = Context {
                    nodes: &state.presented,
                    sheet: &metadata.presented,
                    scale: f64::from(state.presentation_scale_factor),
                    geometry: metadata.geometry.as_deref().map_or_else(geometry::GeometryView::empty, geometry::Geometry::view),
                };
                plan.iter(context).collect::<Vec<_>>()
            };
            let mut values: Vec<(FieldId, f64)> = Vec::new();
            for &(_, offset, list) in &movements {
                if let Some(field) = list.and_then(|id| runtime.list_by_id(id)).and_then(|(_, state)| state.offset_field) {
                    if let Some((_, value)) = values.iter_mut().find(|(old, _)| *old == field) {
                        *value = offset.y;
                    } else {
                        values.push((field, offset.y));
                    }
                }
            }
            if !values.is_empty() {
                return runtime.scroll_sources(&values, &movements);
            }
        }
'''+needle);p.write_text(s)
p=base/'runtime/list.rs';s=p.read_text();needle='''        runtime.changed_nodes = 0;
        runtime.describe_with(false, &[ScrollRequest { id, position }])?;
        runtime.present()''';assert needle in s;s=s.replace(needle,'''        if let Some(field) = runtime.list_by_id(id).and_then(|(_, state)| state.offset_field) {
            let viewport = runtime.list_by_id(id).unwrap().1.viewport.clone();
            let offset = match position {
                ScrollPosition::Delta(delta) => viewport.offset + delta,
                ScrollPosition::Offset(offset) => offset,
                ScrollPosition::Index(index) => {
                    if index >= viewport.len { return Err(ListError::IndexOutOfRange.into()); }
                    index as f64 * viewport.row_height
                }
                ScrollPosition::Key(key) => {
                    if let Some(index) = runtime.list_rows.values().find(|row| row.list == id && row.key == key).map(|row| row.index) {
                        f64::from(index) * viewport.row_height
                    } else {
                        // ItemSource is borrowed only during description. Resolve
                        // a distant key without publishing this intermediate tree;
                        // after writeback, rebuild all sinks against the new source.
                        runtime.validate_offsets(&[(field, 0.0)])?;
                        runtime.describe_with(false, &[ScrollRequest { id, position }])?;
                        runtime.list_by_id(id).unwrap().1.viewport.offset
                    }
                }
            }.clamp(0.0, (viewport.extent - viewport.viewport_height).max(0.0));
            let result = runtime.scroll_sources(&[(field, offset)], &[]);
            if result.is_err() {
                runtime.logical_valid = false;
                runtime.clear_editing();
                runtime.focused = None;
            }
            return result;
        }
        runtime.changed_nodes = 0;
        runtime.describe_with(false, &[ScrollRequest { id, position }])?;
        runtime.present()''');p.write_text(s)
