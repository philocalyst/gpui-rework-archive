//! Explicit borrowed multi-edit admission with one publication barrier.
use super::*;

/// A window-exclusive edit turn. Each operation admits its normal logical
/// mutation and source epoch but cannot publish or acknowledge an intermediate
/// candidate. Call `finish` once to prepare the admitted final state.
///
/// Dropping a turn never publishes and never rolls back accepted logical edits.
/// A later `Win::settle` or ordinary edit realizes that prefix. A rejected edit
/// may be caught and followed by more edits or `finish`; each rejection retains
/// its existing atomic-admission/committed-error semantics. A failed `finish`
/// retains the old acknowledged P and old eligible complete C, not a rollback.
///
/// A panic in an owner callback keeps the existing poisoned-owner behavior.
/// An unrelated caller panic drops the turn without publication; its accepted
/// logical prefix remains available for repair. Drop never performs publication;
/// the existing poisoned-owner lane cleanup still applies.
///
/// ```compile_fail
/// use gpui::{El, View, Win, div};
/// struct Page;
/// impl View for Page { fn view(&self) -> El<'_> { div().size(10) } }
/// let mut win = Win::demo(Page);
/// let turn = win.edit_turn().unwrap();
/// win.settle().unwrap();
/// turn.finish().unwrap(); // The exclusive turn prevents nested Win mutation.
/// ```
#[must_use = "call finish to publish, or drop to retain only the logical prefix"]
pub struct EditTurn<'a, M: View + 'static, L: LaneSet<M> = ()> {
    runtime: RuntimeMut<'a, M, L>,
}
impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    /// Borrow the App/event-loop context for every admission and the one finish
    /// barrier. A scoped window never downgrades to the legacy unaccounted path.
    pub fn edit_turn_with_resources<'a>(&'a mut self, resources: &'a mut gpui_reactivity_core::resource::ResourceContext) -> Result<EditTurn<'a, M, L>, Error> {
        let mut runtime = self.runtime_borrow()?;
        runtime.resources = Some(resources);
        runtime.admit_resources()?;
        runtime.live()?;
        runtime.deferred = true;
        Ok(EditTurn { runtime })
    }
    pub fn edit_turn(&mut self) -> Result<EditTurn<'_, M, L>, Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.admit_resources()?;
        runtime.live()?;
        runtime.deferred = true;
        Ok(EditTurn { runtime })
    }
}
impl<M: View + 'static, L: LaneSet<M>> EditTurn<'_, M, L> {
    /// Admit one exact source operation. This receipt is not a prepared frame.
    pub fn set<T: 'static>(
        &mut self,
        source: impl SourcePath<M, T>,
        value: T,
    ) -> Result<Commit, SetError<T>> {
        self.runtime.set_source(source, value)
    }
    pub fn update(&mut self, edit: impl FnOnce(&mut M)) -> Result<Commit, Error> {
        self.runtime.operation(None, |model, _| {
            edit(model);
            Ok(())
        })
    }
    pub fn read<T: 'static>(&self, source: impl SourcePath<M, T>) -> Result<&T, Error> {
        Ok(source
            .resolve(&self.runtime.model, &self.runtime.sources)?
            .1)
    }
    pub fn set_property<T: PartialEq, D: crate::property::PropertyDomain>(
        &mut self,
        target: Target,
        property: Property<T, D>,
        contribution: Contribution<T>,
    ) -> Result<Commit, Error> {
        self.runtime.set_property(target, property, contribution)
    }
    pub fn set_property_value(
        &mut self,
        target: Target,
        id: crate::property::PropertyId,
        contribution: Contribution<crate::property::PropertyValue>,
    ) -> Result<Commit, Error> {
        let (index, epoch) = self.runtime.property_edit_target(target)?;
        self.runtime
            .set_property_value_at(index, epoch, id, contribution)
    }
    pub fn property_value(
        &self,
        target: Target,
        id: crate::property::PropertyId,
    ) -> Result<crate::property::PropertyValue, Error> {
        self.runtime.live()?;
        let index = self.runtime.resolve_index(target)?;
        self.runtime.property_value_at(index, id)
    }
    pub fn finish(mut self) -> Result<Commit, Error> {
        self.runtime.live()?;
        self.runtime.deferred = false;
        if !self.runtime.logical_valid {
            self.runtime.describe(false)?;
        }
        self.runtime.present()
    }
}
impl<M: View + 'static, L: LaneSet<M>> RuntimeMut<'_, M, L> {
    pub(super) fn admit_resources(&mut self) -> Result<(), Error> {
        if matches!(self.runtime.accounting, gpui_reactivity_core::resource::WindowAccounting::Unaccounted) && self.resources.is_some() {
            // Accounting is fixed before initial mount; a later turn cannot
            // retroactively claim its already-created unaccounted resources.
            return Err(Error::Resource(gpui_reactivity_core::resource::ResourceError::Unaccounted));
        }
        if let gpui_reactivity_core::resource::WindowAccounting::Scoped(_) = self.runtime.accounting {
            let context = self.resources.as_deref_mut().ok_or(Error::Resource(gpui_reactivity_core::resource::ResourceError::Unaccounted))?;
            context.ledger_for(self.runtime.accounting, self.runtime.sites.issuer()).map_err(Error::Resource)?;
        }
        Ok(())
    }
    // This shadows Runtime::present only for an explicitly borrowed turn. All
    // ordinary Win/delivery borrows use deferred=false. Logical editing and
    // inspector admission remain ordered before the optional publication.
    pub(super) fn present(&mut self) -> Result<Commit, Error> {
        if self.deferred {
            self.runtime.reconcile_editing(EditingIntent::None)?;
            self.runtime.refresh_inspector(false)?;
            Ok(self.runtime.commit())
        } else {
            self.runtime.present_with_resources(self.resources.as_deref_mut())
        }
    }
    pub(super) fn set_source<T: 'static>(
        &mut self,
        source: impl SourcePath<M, T>,
        value: T,
    ) -> Result<Commit, SetError<T>> {
        let runtime = self;
        let mut value = Some(value);
        let previous_epoch = runtime.source_epoch;
        let result = (|| {
            runtime.live()?;
            let field = match catch_unwind(AssertUnwindSafe(|| {
                source
                    .resolve(&runtime.model, &runtime.sources)
                    .map(|(field, _)| field)
            })) {
                Ok(result) => result?,
                Err(_) => {
                    runtime.poison();
                    return Err(Error::OwnerPanicked);
                }
            };
            runtime.operation(Some(field), |model, _| {
                source.modify(model, |old| {
                    // Projector agreement and mutable-value admission have
                    // succeeded. This is the only ownership-transfer point.
                    *old = value.take().expect("source assignment runs once");
                })?;
                Ok(())
            })
        })();
        match result {
            Ok(commit) => Ok(commit),
            Err(error) => Err(if let Some(value) = value {
                SetError::Rejected { error, value }
            } else if runtime.source_epoch != previous_epoch {
                SetError::Committed {
                    error,
                    commit: runtime.commit(),
                }
            } else {
                SetError::OwnerFault { error }
            }),
        }
    }
}
