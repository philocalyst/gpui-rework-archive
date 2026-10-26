//! A borrowed owner turn splits model/runtime state from its static delivery lanes.
//! It owns no state and cannot outlive the exclusive Win borrow.
use super::*;

impl<M: View + 'static> Runtime<M> {
    /// Exact direct sources already exclude branch/format/structural reads.
    /// This additional certificate excludes every viewport dependency: only
    /// Transform (plus existing Paint) sinks, on subtrees disjoint from all
    /// List/ListItem/Scroll ancestry. Ordinary patch and full publication still
    /// perform geometry, clipping, hit, text/resource and accessibility work.
    // Admission for legacy UNTRACKED provider observation only. This grants
    // no dependency/output cleanliness and never bypasses full presentation.
    #[inline(never)]
    fn source_observation_disjoint(&self, field: FieldId) -> bool {
        if !self.logical_valid || !self.presentation_valid
            || self.dirty || self.topology_changed || self.rebuild_layout
            || self.layout_edits.is_some() || self.layout.is_poisoned()
            || self.requested_size != self.presentation_size
            || self.requested_scale_factor != self.presentation_scale_factor
        {
            return false;
        }
        let Some(fanout) = self.fanout.get(&field) else { return false };
        fanout.all_destinations().all(|(destination, _, _)| {
            match destination.property() {
                Some(id) if id.info().impact == crate::property::Impact::Paint => true,
                Some(crate::property::PropertyId::Transform) => {
                    self.nodes.get(destination.node()).is_some_and(|node| {
                        !node.links.viewport_ancestor() && !node.links.viewport_subtree()
                    })
                }
                // Includes text, semantic ports and every Layout sink. Keep
                // their existing realization boundary even in a mixed fanout.
                _ => false,
            }
        })
    }
}

#[cfg(test)]
impl<M: View + 'static> Runtime<M> {
    fn disjoint_transform_ports(&self, field: FieldId) -> bool { self.source_observation_disjoint(field) }
}

impl<M: View + 'static, L: LaneSet<M>> RuntimeMut<'_, M, L> {
    pub(super) fn deliver(&mut self, applied: &mut usize, budget: usize) -> Result<Commit, Error> {
        self.admit_resources()?;
        self.live()?;
        let epoch = self
            .source_epoch
            .checked_add(1)
            .ok_or(Error::EpochExhausted)?;
        let mut models = 0;
        let mut exact = None;
        let mut remaining = budget;
        let result = match catch_unwind(AssertUnwindSafe(|| {
            self.lanes.apply(
                &mut self.runtime.model,
                &self.runtime.sources,
                &mut models,
                &mut exact,
                &mut remaining,
            )
        })) {
            Ok(result) => result,
            Err(_) => {
                *applied = models;
                self.poison();
                return Err(Error::OwnerPanicked);
            }
        };
        // Ordinary callbacks stay coarse even when queue operations outline
        // apply; their static chain cannot report a declaration-bound edit.
        if !L::FIELD_EDITS {
            exact = None;
        }
        *applied = models;
        if models != 0 {
            // Normal model callbacks commit before any derived freeze/projection
            // can fail. Current inputs supersede older completions in this batch.
            self.runtime.source_epoch = epoch;
            self.runtime.counters.source_operations += 1;
        }
        let rejected = result.is_err();
        let mut questions = 0;
        let mut questions_changed = false;
        let result = match catch_unwind(AssertUnwindSafe(|| {
            if models != 0 {
                questions_changed = self.lanes.refresh(
                    &self.runtime.model,
                    &self.runtime.sources,
                    crate::reader::question::Change::Source(exact),
                )?;
            }
            // An accepted prefix supersedes old answers even when a later
            // callback is rejected. Refresh before returning that rejection;
            // leave frozen completions for a later bounded continuation.
            result?;
            self.lanes.apply_questions(
                &self.runtime.model,
                &self.runtime.sources,
                &mut questions,
                &mut remaining,
            )
        })) {
            Ok(result) => result,
            Err(_) => {
                *applied += questions;
                self.poison();
                return Err(Error::OwnerPanicked);
            }
        };
        *applied += questions;
        if questions != 0 && models == 0 {
            self.runtime.source_epoch = epoch;
            self.runtime.counters.source_operations += 1;
        }
        if let Err(error) = result {
            // A projector rejection before every callback leaves the coherent
            // input untouched. Applied prefixes revoke their logical addresses.
            if !rejected || models != 0 {
                self.runtime.clear_editing();
                self.runtime.logical_valid = false;
                self.runtime.focused = None;
            }
            return Err(error);
        }
        if *applied == 0 {
            return Ok(self.commit());
        }
        self.after_admission(exact, questions_changed || questions != 0)
    }
    pub(super) fn describe(&mut self, mount: bool) -> Result<(), Error> {
        self.describe_with(mount, &[])
    }
    pub(super) fn describe_with(
        &mut self,
        mount: bool,
        scroll: &[ScrollRequest],
    ) -> Result<(), Error> {
        self.describe_with_changed(mount, scroll, None)
    }
    pub(super) fn describe_with_changed(
        &mut self,
        mount: bool,
        scroll: &[ScrollRequest],
        property_changed: Option<NonZeroU64>,
    ) -> Result<(), Error> {
        let was_valid = self.logical_valid;
        match catch_unwind(AssertUnwindSafe(|| {
            self.runtime.sources.validate(&mut self.runtime.model)?;
            if mount {
                self.lanes
                    .validate(&self.runtime.model, &self.runtime.sources)?;
            }
            if mount && L::QUESTIONS {
                self.lanes.refresh(
                    &self.runtime.model,
                    &self.runtime.sources,
                    crate::reader::question::Change::Mount,
                )?;
            }
            self.runtime
                .describe_inner(mount, scroll, self.lanes, property_changed)
        })) {
            Ok(Ok(())) => Ok(()),
            Ok(Err(error)) => {
                // Only an EARLY rejected scroll leaves the old logical cohort
                // untouched. describe_inner revokes logical_valid before its
                // first destructive take; a late resource failure must retain
                // old P/C without authorizing stale current identity lookups.
                self.logical_valid = !scroll.is_empty() && was_valid && self.logical_valid;
                if !self.logical_valid {
                    self.runtime.changes.full(gpui_reactivity_core::change::FullReasons::UNKNOWN_DEPENDENCY);
                    self.focused = None;
                }
                Err(error)
            }
            Err(_) => {
                self.poison();
                Err(Error::OwnerPanicked)
            }
        }
    }

    pub(super) fn operation(
        &mut self,
        exact: Option<FieldId>,
        edit: impl FnOnce(&mut M, &Sources<M>) -> Result<(), Error>,
    ) -> Result<Commit, Error> {
        self.operation_with(exact, |model, sources, _| edit(model, sources))
    }
    pub(super) fn operation_with(
        &mut self,
        exact: Option<FieldId>,
        edit: impl FnOnce(&mut M, &Sources<M>, &mut L) -> Result<(), Error>,
    ) -> Result<Commit, Error> {
        self.operation_with_editing(exact, edit, EditingIntent::None)
    }
    pub(super) fn operation_with_editing(
        &mut self,
        exact: Option<FieldId>,
        edit: impl FnOnce(&mut M, &Sources<M>, &mut L) -> Result<(), Error>,
        editing: EditingIntent,
    ) -> Result<Commit, Error> {
        self.admit_resources()?;
        self.live()?;
        let epoch = self
            .source_epoch
            .checked_add(1)
            .ok_or(Error::EpochExhausted)?;
        match catch_unwind(AssertUnwindSafe(|| {
            edit(&mut self.runtime.model, &self.runtime.sources, self.lanes)
        })) {
            Ok(result) => result?,
            Err(_) => {
                self.poison();
                return Err(Error::OwnerPanicked);
            }
        }
        self.runtime.source_epoch = epoch;
        self.runtime.counters.source_operations += 1;
        self.runtime.changed_nodes = 0;
        self.after_source_with_editing(exact, editing)
    }
    fn after_source_with_editing(
        &mut self,
        exact: Option<FieldId>,
        editing: EditingIntent,
    ) -> Result<Commit, Error> {
        self.after_source_changed(exact, editing, None)
    }
    fn after_source_changed(
        &mut self,
        exact: Option<FieldId>,
        editing: EditingIntent,
        property_changed: Option<NonZeroU64>,
    ) -> Result<Commit, Error> {
        let questions_changed = match catch_unwind(AssertUnwindSafe(|| {
            self.lanes.refresh(
                &self.runtime.model,
                &self.runtime.sources,
                crate::reader::question::Change::Source(exact),
            )
        })) {
            Ok(Ok(changed)) => changed,
            Ok(Err(error)) => {
                self.runtime.clear_editing();
                self.runtime.logical_valid = false;
                self.runtime.focused = None;
                return Err(error);
            }
            Err(_) => {
                self.poison();
                return Err(Error::OwnerPanicked);
            }
        };
        self.after_admission_changed(exact, questions_changed, editing, property_changed)
    }
    pub(super) fn after_admission(
        &mut self,
        exact: Option<FieldId>,
        questions_changed: bool,
    ) -> Result<Commit, Error> {
        self.after_admission_changed(exact, questions_changed, EditingIntent::None, None)
    }
    fn after_admission_changed(
        &mut self,
        exact: Option<FieldId>,
        questions_changed: bool,
        editing: EditingIntent,
        property_changed: Option<NonZeroU64>,
    ) -> Result<Commit, Error> {
        let ime_changed = self.runtime.reconcile_ime();
        // A bank-only candidate cannot include changed caret visibility.
        // Disable that early publication before patching, then combine both
        // effects in the one ordinary full preparation below.
        if matches!(editing, EditingIntent::Focus) {
            self.runtime.dirty = true;
        }
        let exact = match exact {
            Some(field)
                if self.runtime.logical_valid
                    && !questions_changed
                    && !self.runtime.sources.invalidates_owner(field)? =>
            {
                Some(field)
            }
            _ => None,
        };
        let result = match exact {
            Some(field) => {
                self.runtime.counters.exact_updates += 1;
                // Source sinks record ordinary typed input facts. Intrinsic
                // template consumers, not interaction names/ancestry, decide
                // whether logical realization is required after patching.
                match catch_unwind(AssertUnwindSafe(|| {
                    // Preserve legacy observation boundaries from ACTUAL typed
                    // installed sinks, never transport outcome/case names.
                    let observe_untracked = self.runtime.fanout.get(&field).is_some_and(|fanout|
                        fanout.all_destinations().any(|(destination, _, _)| destination.property()
                            .is_some_and(|property| property.info().impact != crate::property::Impact::Paint)))
                        && !self.runtime.source_observation_disjoint(field);
                    let semantic = self.runtime.patch_admitted(field, !self.deferred)?;
                    // Ordinary retained trees patch directly. Mixed virtual-list
                    // windows still need their list realization boundary.
                    if self.dirty && self.runtime.requires_realization(observe_untracked)? {
                        self.describe(false)?;
                        Ok(PatchOutcome::Visual)
                    } else {
                        Ok(semantic)
                    }
                })) {
                    Ok(result) => result,
                    Err(_) => {
                        self.poison();
                        Err(Error::OwnerPanicked)
                    }
                }
            }
            None => {
                self.runtime.counters.coarse_updates += 1;
                self.describe_with_changed(false, &[], property_changed)
                    .map(|()| PatchOutcome::Visual)
            }
        };
        let outcome = match result {
            Ok(outcome) => outcome,
            Err(error) => {
                self.runtime.clear_editing();
                self.runtime.logical_valid = false;
                self.runtime.focused = None;
                return Err(error);
            }
        };
        let editing_changed = self.runtime.reconcile_editing(editing)? || ime_changed;
        if self.deferred {
            return self.present();
        }
        if !self.inspector_enabled() && !editing_changed {
            match outcome {
                PatchOutcome::Unchanged => {
                    self.runtime.publish_paint(None)?;
                    return Ok(self.commit());
                }
                PatchOutcome::Paint(intent) => {
                    if self.runtime.publish_paint_intent(intent)? {
                        return Ok(self.commit());
                    }
                }
                PatchOutcome::Metadata => {
                    return Ok(self.publish_metadata(Publish::Field(exact.unwrap())));
                }
                PatchOutcome::Visual => {}
            }
        }
        self.present()
    }
    pub(super) fn activate(&mut self, target: Target) -> Result<Commit, Error> {
        self.activate_with_editing(target, EditingIntent::None)
    }

    /// Compound clicks admit focus and model output into at most one candidate.
    /// A rejected action has not admitted either effect; committed failures
    /// retain the existing source/reconciliation cleanup rather than reviving P.
    pub(super) fn activate_focused(
        &mut self,
        target: Target,
        previous: Option<Target>,
    ) -> Result<Commit, Error> {
        let epoch = self.source_epoch;
        let prepared = self.latest_token;
        let focus_changed = self.focus_needs_paint(previous);
        let intent = if focus_changed {
            EditingIntent::Focus
        } else {
            EditingIntent::None
        };
        match self.activate_with_editing(target, intent) {
            // Closed Window actions and an empty Property proposal can return
            // without consuming the intent. They prepare a full scene or none;
            // unlike model source patches, neither can publish a bank-only
            // candidate that omitted changed caret visibility.
            Ok(_) if focus_changed && self.latest_token == prepared => {
                self.publish_focus_change(previous)
            }
            Err(error) => {
                if self.source_epoch == epoch && self.logical_valid && self.runtime.live().is_ok() {
                    self.runtime.focused = previous;
                }
                Err(error)
            }
            result => result,
        }
    }

    fn activate_with_editing(
        &mut self,
        target: Target,
        editing: EditingIntent,
    ) -> Result<Commit, Error> {
        self.live()?;
        let index = self.resolve_index(target)?;
        if self.runtime.nodes[index].kind() == NodeKind::Input {
            self.runtime.changed_nodes = 0;
            return Ok(self.commit());
        }
        let slot = self.runtime.nodes[index]
            .handler_slot()
            .ok_or(Error::NotInteractive)?;
        let handler = self.runtime.handlers.as_deref().unwrap().get(slot);
        let admission = match catch_unwind(AssertUnwindSafe(|| {
            handler.admit(&self.runtime.model, &self.runtime.sources)
        })) {
            Ok(result) => result?,
            Err(_) => {
                self.poison();
                return Err(Error::OwnerPanicked);
            }
        };
        let exact = match admission {
            crate::element::Admission::Model { exact } => exact,
            crate::element::Admission::Window(action) => return self.window_action(action),
            crate::element::Admission::Property => return self.activate_property(index, editing),
        };
        let epoch = self
            .source_epoch
            .checked_add(1)
            .ok_or(Error::EpochExhausted)?;
        match catch_unwind(AssertUnwindSafe(|| handler.invoke(&mut self.runtime.model))) {
            Ok(result) => result?,
            Err(_) => {
                self.poison();
                return Err(Error::OwnerPanicked);
            }
        }
        self.runtime.source_epoch = epoch;
        self.runtime.counters.source_operations += 1;
        self.runtime.changed_nodes = 0;
        self.after_source_with_editing(exact, editing)
    }

    #[inline(never)]
    fn activate_property(&mut self, index: usize, editing: EditingIntent) -> Result<Commit, Error> {
        // The request and reply cannot change retained nodes: they borrow only
        // M, and the shared property mutation touches only style/geometry.
        // Own this existing route on the stack so no handler/node borrow spans
        // logical mutation. Restore it before the sole reconciliation barrier.
        let slot = self.runtime.nodes[index]
            .handler_slot()
            .expect("admitted route");
        let handler = self.runtime.handlers.as_deref_mut().unwrap().take(slot);
        let before = self.source_epoch;
        let mut property_changed = None;
        let result = catch_unwind(AssertUnwindSafe(|| -> Result<bool, Error> {
            let own_target = self.sites.target(self.runtime.nodes[index].identity());
            let Some(request) = handler.proposal(&self.runtime.model, own_target)? else {
                self.runtime.changed_nodes = 0;
                return Ok(false);
            };
            let (target, id, contribution) = match request {
                crate::element::PropertyRequest::Inspect(target, id) => (target, id, None),
                crate::element::PropertyRequest::Edit((target, id, contribution)) => {
                    (target, id, Some(contribution))
                }
            };
            let epoch = self
                .source_epoch
                .checked_add(1)
                .ok_or(Error::EpochExhausted)?;
            let result = self.resolve_index(target).and_then(|index| {
                if let Some(contribution) = contribution {
                    property_changed = self.apply_property_value_at(index, id, contribution)?;
                }
                // Reads and writes share the closed PropertyId destination.
                // Accepted edits leave the same typed Style/Geometry domain.
                Ok(crate::PropertyState {
                    target,
                    id,
                    value: self.property_value_at(index, id)?,
                    contribution: self
                        .property_contribution_at(self.runtime.nodes[index].identity(), id),
                })
            });
            if let Err(error) = &result
                && !matches!(error, Error::StaleTarget | Error::Property(_))
            {
                return result.map(|_| true);
            }
            // Accepted contributions and the ordinary reply method are one
            // source operation. Rejection changes no contribution; its reply
            // may still change the tool's ordinary model error/status state.
            self.runtime.source_epoch = epoch;
            self.runtime.counters.source_operations += 1;
            handler.applied_logically(&mut self.runtime.model, result.as_ref())?;
            Ok(true)
        }));
        self.runtime
            .handlers
            .as_deref_mut()
            .unwrap()
            .restore(slot, handler);
        match result {
            Ok(Ok(false)) => Ok(self.commit()),
            Ok(Ok(true)) => self.after_source_changed(None, editing, property_changed),
            Ok(Err(error)) => {
                // Within this closed operation only the reply can reject after
                // S admission. The route is restored above before quarantine;
                // an accepted contribution cannot leave stale logical authority
                // live merely because its mutable projector was malformed.
                if self.source_epoch != before {
                    self.poison();
                }
                Err(error)
            }
            Err(_) => {
                self.poison();
                Err(Error::OwnerPanicked)
            }
        }
    }
}
