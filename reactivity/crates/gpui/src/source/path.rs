//! Typed paths borrow declarations, never owner addresses or schema ordinals.
use super::*;
use std::marker::PhantomData;

/// A typed source relative to an owner. Implementations are library-owned:
/// declarations and contained paths share registered source admission.
#[allow(private_bounds)]
pub trait SourcePath<M, T: 'static>: Path<M, T> {}
impl<M, T: 'static, S: Path<M, T>> SourcePath<M, T> for S {}

pub(crate) trait Path<M, T: 'static> {
    // Schema-only lookup for mounted question invalidation, not authority.
    // Mount must first resolve the input against this immutable schema/model.
    fn field(&self, sources: &Sources<M>) -> Result<FieldId, BindError>;
    fn resolve<'a>(
        &self,
        model: &'a M,
        sources: &Sources<M>,
    ) -> Result<(FieldId, &'a Signal<T>), BindError>;
    fn modify<R>(&self, model: &mut M, edit: impl FnOnce(&mut T) -> R) -> Result<R, BindError>;
}
impl<M, T: 'static> Path<M, T> for Source<M, T> {
    fn field(&self, _: &Sources<M>) -> Result<FieldId, BindError> {
        Ok(self.id)
    }
    fn resolve<'a>(
        &self,
        model: &'a M,
        sources: &Sources<M>,
    ) -> Result<(FieldId, &'a Signal<T>), BindError> {
        Ok((self.id, self.borrow_registered(model, sources)?))
    }
    fn modify<R>(&self, model: &mut M, edit: impl FnOnce(&mut T) -> R) -> Result<R, BindError> {
        Source::modify(self, model, edit)
    }
}
impl<M, T: 'static, S: Path<M, T>> Path<M, T> for &S {
    fn field(&self, sources: &Sources<M>) -> Result<FieldId, BindError> {
        (**self).field(sources)
    }
    fn resolve<'a>(
        &self,
        model: &'a M,
        sources: &Sources<M>,
    ) -> Result<(FieldId, &'a Signal<T>), BindError> {
        (**self).resolve(model, sources)
    }
    fn modify<R>(&self, model: &mut M, edit: impl FnOnce(&mut T) -> R) -> Result<R, BindError> {
        (**self).modify(model, edit)
    }
}

/// A contained source declared with [`Component::source`]. The path borrows its
/// component declaration and owns only the child declaration/path. It retains no
/// model address, revision, resolved scope, allocation or window authority.
pub struct ProjectedSource<'a, P, C, T, S> {
    component: &'a Component<P, C>,
    source: S,
    value: PhantomData<fn() -> T>,
}
impl<P, C, T, S: Copy> Copy for ProjectedSource<'_, P, C, T, S> {}
impl<P, C, T, S: Clone> Clone for ProjectedSource<'_, P, C, T, S> {
    fn clone(&self) -> Self {
        Self {
            component: self.component,
            source: self.source.clone(),
            value: PhantomData,
        }
    }
}
impl<P, C> Component<P, C> {
    /// Compose a child source with this registered component. Nested components
    /// compose in the same way. Borrow declared Sources to avoid copying their
    /// metadata. Transient read/set paths may borrow local declarations; retained
    /// actions/questions need static declarations, as their closures do.
    ///
    /// For example, a parent can use the source declared by a nested library
    /// counter, without registering an alias or duplicating its Signal:
    ///
    /// ```text
    /// // Each View registers its own sources once:
    /// // Counter: Sources::new().direct(Self::COUNT)
    /// // Pane:    Sources::new().direct_component(Self::COUNTER)
    /// // Page:    Sources::new().direct_component(Self::LEFT)
    /// let count = Page::LEFT.source(Pane::COUNTER.source(&Counter::COUNT));
    /// let current = win.read(count)?;
    /// win.set(count, *current + 1)?;
    /// let button = button("Increase left").on_click(count.update(|n| *n += 1));
    /// // Retained question inputs can borrow the entire static path:
    /// let input = &const { Page::LEFT.source(Pane::COUNTER.source(&Counter::COUNT)) };
    /// let (questions, answer) = Questions::new().question(input, |n| *n, start)?;
    /// ```
    ///
    /// `component_sources` is a complete ordinary native example of this shape.
    /// Paths name the current registered field, not a historical component
    /// instance or presentation. They do not retain a model or grant access
    /// after its Win closes. A borrowed read prevents editing that same Win
    /// until the returned value's last use.
    pub const fn source<T: 'static, S: SourcePath<C, T>>(
        &self,
        source: S,
    ) -> ProjectedSource<'_, P, C, T, S> {
        ProjectedSource {
            component: self,
            source,
            value: PhantomData,
        }
    }
}
impl<P: 'static, C: 'static, T: 'static, S: SourcePath<C, T>> Path<P, T>
    for ProjectedSource<'_, P, C, T, S>
{
    fn field(&self, sources: &Sources<P>) -> Result<FieldId, BindError> {
        let entry = sources.component_entry::<C>(self.component.id)?;
        Ok(entry.qualify(self.source.field(&entry.sources)?))
    }
    fn resolve<'a>(
        &self,
        parent: &'a P,
        sources: &Sources<P>,
    ) -> Result<(FieldId, &'a Signal<T>), BindError> {
        let entry = sources.component_entry::<C>(self.component.id)?;
        let child = (self.component.read)(parent);
        if !std::ptr::eq(child, (entry.component.read)(parent)) {
            return Err(BindError::ComponentProjectionMismatch(self.component.id));
        }
        let (field, value) = self.source.resolve(child, &entry.sources)?;
        Ok((entry.qualify(field), value))
    }
    fn modify<R>(&self, parent: &mut P, edit: impl FnOnce(&mut T) -> R) -> Result<R, BindError> {
        self.source
            .modify(self.component.project_mut(parent)?, edit)
    }
}
impl<P, C, T: 'static, S> ProjectedSource<'_, P, C, T, S> {
    /// A route whose only mutable model access is the contained source value.
    pub fn update<F: Fn(&mut T)>(self, update: F) -> FieldAction<P, T, F, Self> {
        FieldAction {
            source: self,
            update,
            owner: PhantomData,
        }
    }
}
