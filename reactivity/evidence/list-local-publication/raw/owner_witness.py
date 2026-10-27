from pathlib import Path
w=Path('/home/user/gpui-local-publication-lab/reactivity/crates/gpui/src')
p=w/'runtime.rs';s=p.read_text();start=s.index('    fn describe_inner(');end=s.index('    fn patch(',start);a=s[start:end]
def sub(old,new):
 global a
 assert a.count(old)==1,(old,a.count(old));a=a.replace(old,new)
sub('        let reuse_identities = self.logical_valid;', '''        let mut text_only = !mount
            && property_changed.is_none()
            && self.can_record_text_change();
        let mut changed_text = None;
        let reuse_identities = self.logical_valid;''')
sub('            self.dirty |= ports.finish_description(field, &drafts, &mut color_discovery);','''            let rebound = ports.finish_description(field, &drafts, &mut color_discovery);
            self.dirty |= rebound;
            text_only &= !rebound;''')
sub('''                // Rebind the complete scene before slot edits.''','''                // Rebind the complete scene before slot edits.''') if False else None
sub('''                // interchangeable. Rebind the complete scene before slot edits.
                self.dirty = true;''','''                // interchangeable. Rebind the complete scene before slot edits.
                self.dirty = true;
                text_only = false;''')
sub('''            let text = draft.text.as_ref().map(|text| text.borrowed_value());''','''            text_only &= !node_changed;
            let text = draft.text.as_ref().map(|text| text.borrowed_value());''')
sub('''            if site.as_ref().map(|site| site.value.as_ref()) != text.as_deref() {
                self.rebuild_layout''','''            if site.as_ref().map(|site| site.value.as_ref()) != text.as_deref() {
                text_only &= node.kind() == NodeKind::Text
                    && site.is_some()
                    && text.is_some()
                    && changed_text.is_none();
                changed_text = Some(index);
                self.rebuild_layout''')
sub('''            if !styles::exact_eq(&previous_style, &style) {
                self.dirty = true;''','''            if !styles::exact_eq(&previous_style, &style) {
                text_only = false;
                self.dirty = true;''')
sub('''            if node.has_handler() != draft.on_click.is_some() {
                // Eligibility''','''            if node.has_handler() != draft.on_click.is_some() {
                text_only = false;
                // Eligibility''')
sub('''        self.topology_changed |= topology;''','''        text_only &= !topology;
        self.topology_changed |= topology;''')
sub('''            self.dirty |= changed;
            for row in draft.rows {''','''            self.dirty |= changed;
            text_only &= !changed;
            for row in draft.rows {''')
sub('''                list_rows.insert(
                    identity,
                    ListRow {''','''                text_only = text_only && self.list_rows.get(&identity).is_some_and(|old| {
                    old.list == draft.id && old.key == row.key && old.index == row.item_index
                        && old.y.to_bits() == row.y.to_bits()
                        && old.height.to_bits() == row.height.to_bits()
                        && old.visible
                        && old.retain_offscreen == draft.plan.retain_offscreen
                        && old.buffered == !draft.plan.viewport.visible_range.contains(&(row.item_index as usize))
                });
                list_rows.insert(
                    identity,
                    ListRow {''')
sub('''                .is_none_or(|state| state.axes != draft.axes)
            {
                self.dirty = true;''','''                .is_none_or(|state| state.axes != draft.axes)
            {
                text_only = false;
                self.dirty = true;''')
sub('''        if !annotation_drafts.is_empty() || !viewports.is_empty() || self.metadata.is_some() {''','''        text_only &= self.viewports.len() == viewports.len()
            && self.list_rows.len() == list_rows.len();
        if !annotation_drafts.is_empty() || !viewports.is_empty() || self.metadata.is_some() {''')
sub('''            metadata.base = base;''','''            text_only = text_only && metadata.base.len() == base.len()
                && metadata.base.iter().zip(&base).all(|(old, new)| {
                    old.identity == new.identity && old.name == new.name
                        && old.description == new.description
                });
            metadata.base = base;''')
sub('''            self.dirty |=
                background::reconcile(&mut self.images, &nodes, &by_identity, background_drafts)?;''','''            let changed = background::reconcile(&mut self.images, &nodes, &by_identity, background_drafts)?;
            self.dirty |= changed;
            text_only &= !changed;''')
sub('''        self.reconcile_geometry(&nodes, geometry_drafts);''','''        text_only &= !self.reconcile_geometry(&nodes, geometry_drafts);''')
sub('''        self.dirty |= matches!(self.styles, styles::Styles::Colors(_));''','''        let replaces_bank = matches!(self.styles, styles::Styles::Colors(_));
        self.dirty |= replaces_bank;
        text_only &= !replaces_bank;''')
sub('''        self.changed_nodes = changed;
        Ok(())''','''        self.changed_nodes = changed;
        if let Some(text) = &mut self.text {
            text.dirty_text = if text_only && changed == 1 {
                changed_text.map(|index| (self.source_epoch, index))
            } else {
                None
            };
        }
        Ok(())''')
p.write_text(s[:start]+a+s[end:])
p=w/'runtime/geometry.rs';s=p.read_text();start=s.index('    pub(super) fn reconcile_geometry(');end=s.index('\n}\nimpl<M:',start);a=s[start:end];a=a.replace('    ) {','    ) -> bool {',1).replace('            return;','            return false;',1).replace('        let metadata =','        let mut changed = false;\n        let metadata =',1).replace('                self.dirty = true;','                changed = true;',1);a=a.rsplit('\n    }',1)[0]+'\n        self.dirty |= changed;\n        changed\n    }';p.write_text(s[:start]+a+s[end:])
p=w/'runtime/sparse_text.rs';s=p.read_text();pos=s.index('    pub(super) fn try_sparse_text(');s=s[:pos]+'''    // Owner callbacks still run and reconcile normally. This only starts a
    // transient witness; every non-text description change must revoke it.
    #[inline(never)]
    pub(super) fn can_record_text_change(&self) -> bool {
        if self.text.is_none() || self.dirty || !self.logical_valid
            || !self.presentation_valid || self.prepared.is_some()
            || self.complete_epoch.checked_add(1) != Some(self.source_epoch)
            || self.inspector_enabled()
            || self.metadata.as_ref().is_some_and(|m| m.editing.is_some())
        {
            return false;
        }
        // A wheel cohort can change logical offsets before describing. Check
        // P itself; an already-mutated logical predecessor is not a witness.
        self.viewports.iter().all(|(&key, state)| {
            let offset = match state {
                ViewportState::List(list) => crate::ScrollOffset { x: 0., y: list.viewport.offset },
                ViewportState::Scroll(scroll) => scroll.offset,
            };
            self.metadata.as_ref()
                .and_then(|m| m.presented.viewports.offset(state.identity(key)))
                .is_some_and(|old| old.x.to_bits() == offset.x.to_bits()
                    && old.y.to_bits() == offset.y.to_bits())
        })
    }

'''+s[pos:];p.write_text(s)
