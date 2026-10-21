//! A borrowed owner turn splits model/runtime state from its static delivery lanes.
//! It owns no state and cannot outlive the exclusive Win borrow.
use super::*;

impl<M: View + 'static, L: LaneSet<M>> RuntimeMut<'_, M, L> {
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
        let exact = match exact {
            Some(field)
                if self.runtime.logical_valid
                    && !self.runtime.sources.invalidates_owner(field)? =>
            {
                Some(field)
            }
            _ => None,
        };
        let result = match exact {
            Some(field) => {
                self.runtime.counters.exact_updates += 1;
                match catch_unwind(AssertUnwindSafe(|| self.patch(field))) {
                    Ok(result) => result,
                    Err(_) => {
                        self.poison();
                        Err(Error::OwnerPanicked)
                    }
                }
            }
            None => {
                self.runtime.counters.coarse_updates += 1;
                self.describe(false).map(|()| false)
            }
        };
        if let Err(error) = result {
            self.runtime.logical_valid = false;
            self.runtime.focused = None;
            return Err(error);
        }
        if result == Ok(true) {
            return Ok(self.publish_metadata(Publish::Field(exact.unwrap())));
        }
        self.present()
    }
    pub(super) fn activate(&mut self, target: Target) -> Result<Commit, Error> {
        self.live()?;
        let identity = self.resolve(target)?;
        let index = self.runtime.by_identity[&identity];
        if self.runtime.nodes[index].kind() == NodeKind::Input {
            self.runtime.changed_nodes = 0;
            return Ok(self.commit());
        }
        let handler = self.runtime.nodes[index]
            .handler
            .as_ref()
            .ok_or(Error::NotInteractive)?;
        let exact = match catch_unwind(AssertUnwindSafe(|| {
            handler.validate(&self.runtime.model, &self.runtime.sources)
        })) {
            Ok(result) => result?,
            Err(_) => {
                self.poison();
                return Err(Error::OwnerPanicked);
            }
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
        let identity = self.resolve(target)?;
        let node = &self.runtime.nodes[self.runtime.by_identity[&identity]];
        if node.kind() != NodeKind::Input {
            return Err(Error::NotInput);
        }
        let field = node
            .text_slot()
            .get(&self.runtime.texts)
            .and_then(|text| text.field)
            .ok_or(Error::UnregisteredInput {
                node: self.runtime.by_identity[&identity],
            })?;
        let codec = self.runtime.fanout[&field].codec;
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
