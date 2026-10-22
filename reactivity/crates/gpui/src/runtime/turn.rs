//! A borrowed owner turn splits model/runtime state from its static delivery lanes.
//! It owns no state and cannot outlive the exclusive Win borrow.
use super::*;

impl<M: View + 'static, L: LaneSet<M>> RuntimeMut<'_, M, L> {
    pub(super) fn deliver(&mut self, applied: &mut usize) -> Result<Commit, Error> {
        self.live()?;
        let epoch = self
            .source_epoch
            .checked_add(1)
            .ok_or(Error::EpochExhausted)?;
        let mut models = 0;
        match catch_unwind(AssertUnwindSafe(|| {
            self.lanes.apply(&mut self.runtime.model, &mut models)
        })) {
            Ok(()) => {}
            Err(_) => {
                *applied = models;
                self.poison();
                return Err(Error::OwnerPanicked);
            }
        }
        *applied = models;
        if models != 0 {
            // Normal model callbacks commit before any derived freeze/projection
            // can fail. Current inputs supersede older completions in this batch.
            self.runtime.source_epoch = epoch;
            self.runtime.counters.source_operations += 1;
        }
        let mut questions = 0;
        let result = match catch_unwind(AssertUnwindSafe(|| {
            if models != 0 {
                self.lanes.refresh(
                    &self.runtime.model,
                    &self.runtime.sources,
                    crate::reader::question::Change::Source(None),
                )?;
            }
            self.lanes
                .apply_questions(&self.runtime.model, &self.runtime.sources, &mut questions)
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
            self.runtime.logical_valid = false;
            self.runtime.focused = None;
            return Err(error);
        }
        if *applied == 0 {
            return Ok(self.commit());
        }
        self.after_admission(None, questions != 0)
    }
    pub(super) fn describe(&mut self, mount: bool) -> Result<(), Error> {
        self.describe_with(mount, &[])
    }
    pub(super) fn describe_with(
        &mut self,
        mount: bool,
        scroll: &[ScrollRequest],
    ) -> Result<(), Error> {
        let was_valid = self.logical_valid;
        match catch_unwind(AssertUnwindSafe(|| {
            self.runtime.sources.validate(&mut self.runtime.model)?;
            if mount && L::QUESTIONS {
                self.lanes.refresh(
                    &self.runtime.model,
                    &self.runtime.sources,
                    crate::reader::question::Change::Mount,
                )?;
            }
            self.runtime.describe_inner(mount, scroll, self.lanes)
        })) {
            Ok(Ok(())) => Ok(()),
            Ok(Err(error)) => {
                // A rejected presentation-only scroll has not edited the model
                // or reached reconciliation; its acknowledged cohort stays live.
                self.logical_valid = !scroll.is_empty() && was_valid;
                if !self.logical_valid {
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
        self.after_source(exact)
    }
    fn after_source(&mut self, exact: Option<FieldId>) -> Result<Commit, Error> {
        let questions_changed = match catch_unwind(AssertUnwindSafe(|| {
            self.lanes.refresh(
                &self.runtime.model,
                &self.runtime.sources,
                crate::reader::question::Change::Source(exact),
            )
        })) {
            Ok(Ok(changed)) => changed,
            Ok(Err(error)) => {
                self.runtime.logical_valid = false;
                self.runtime.focused = None;
                return Err(error);
            }
            Err(_) => {
                self.poison();
                return Err(Error::OwnerPanicked);
            }
        };
        self.after_admission(exact, questions_changed)
    }
    pub(super) fn after_admission(
        &mut self,
        exact: Option<FieldId>,
        questions_changed: bool,
    ) -> Result<Commit, Error> {
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
                let realize = self.has_lists()
                    && self.fanout.get(&field).is_some_and(|fanout| {
                        fanout.destinations().iter().any(|destination| {
                            destination.property().is_some_and(|id| {
                                id.info().impact != crate::property::Impact::Paint
                            })
                        })
                    });
                match catch_unwind(AssertUnwindSafe(|| {
                    let semantic = self.patch(field)?;
                    // Ordinary retained trees patch directly. Mixed virtual-list
                    // windows still need their list realization boundary.
                    if realize && self.dirty {
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
                self.describe(false).map(|()| PatchOutcome::Visual)
            }
        };
        if let Err(error) = result {
            self.runtime.logical_valid = false;
            self.runtime.focused = None;
            return Err(error);
        }
        if result == Ok(PatchOutcome::Complete) && !self.inspector_enabled() {
            return Ok(self.commit());
        }
        if result == Ok(PatchOutcome::Metadata) && !self.inspector_enabled() {
            return Ok(self.publish_metadata(Publish::Field(exact.unwrap())));
        }
        self.present()
    }
    pub(super) fn activate(&mut self, target: Target) -> Result<Commit, Error> {
        self.live()?;
        let index = self.resolve_index(target)?;
        if self.runtime.nodes[index].kind() == NodeKind::Input {
            self.runtime.changed_nodes = 0;
            return Ok(self.commit());
        }
        let handler = self.runtime.nodes[index]
            .handler
            .as_ref()
            .ok_or(Error::NotInteractive)?;
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
        self.after_source(exact)
    }
    pub(super) fn edit_text(
        &mut self,
        target: Target,
        edit: impl FnOnce(&mut String),
    ) -> Result<Commit, Error> {
        self.live()?;
        let index = self.resolve_index(target)?;
        let node = &self.runtime.nodes[index];
        if node.kind() != NodeKind::Input {
            return Err(Error::NotInput);
        }
        let field = node
            .text_slot()
            .get(&self.runtime.texts)
            .and_then(|text| text.field)
            .ok_or(Error::UnregisteredInput { node: index })?;
        let codec = self.runtime.fanout[&field].codec();
        let mut input = match catch_unwind(AssertUnwindSafe(|| {
            self.runtime
                .sources
                .read_text(&self.runtime.model, field, codec)
                .map(|text| text.into_owned())
        })) {
            Ok(result) => result?,
            Err(_) => {
                self.poison();
                return Err(Error::OwnerPanicked);
            }
        };
        edit(&mut input);
        self.operation(Some(field), move |model, sources| {
            sources.write_text(model, field, input, codec)?;
            Ok(())
        })
    }
}
