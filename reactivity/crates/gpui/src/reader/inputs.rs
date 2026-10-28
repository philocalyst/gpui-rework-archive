//! Static input families. Only borrowed owner values and concrete revision packs
//! live here; workers receive the frozen I and an independent request stamp.
use super::*;
use crate::source::Path;
use crate::{BindError, FieldId, ProjectedSource, Source, SourcePath, Sources};

mod sealed {
    pub trait Sealed {}
}

#[doc(hidden)]
pub enum Availability<B> {
    Ready(B),
    Pending,
    Fault,
}
#[doc(hidden)]
pub struct Resolved<B, V> {
    pub version: V,
    pub availability: Availability<B>,
}
/// A declared question input: a Source, an earlier Reader in the same plan,
/// or a pair of inputs. Nest pairs for larger families. Implementations are
/// sealed so version identity and readiness cannot be invented by callers.
#[doc(hidden)]
pub trait QuestionInputs<M: 'static>: sealed::Sealed + 'static {
    type Borrowed<'a>;
    type Versions: Copy + Eq;
    const READERS: bool;
    fn validate(&self, namespace: NonZeroU64, before: NonZeroU64) -> Result<(), QuestionFault>;
    fn contains(&self, sources: &Sources<M>, field: FieldId) -> Result<bool, BindError>;
    fn resolve<'a, R: ReaderValues>(
        &self,
        model: &'a M,
        sources: &Sources<M>,
        earlier: &'a R,
    ) -> Result<Resolved<Self::Borrowed<'a>, Self::Versions>, crate::Error>;
    fn failure<'a, R: ReaderValues>(
        &self,
        _version: Self::Versions,
        _earlier: &'a R,
    ) -> Option<Failure<'a>> {
        None
    }
    fn single(&self, version: Self::Versions, coarse: u64, policy: u64) -> Option<InputVersion>;
    fn visit(
        &self,
        version: Self::Versions,
        coarse: u64,
        policy: u64,
        visit: &mut impl FnMut(QuestionInput),
    ) {
        if let Some(input) = self.single(version, coarse, policy) {
            visit(QuestionInput::Source(input));
        }
    }
}
// Retain a declared input family by reference, preserving its exact version
// pack and Reader/pair behavior. No owned descriptor or routing cache is made.
impl<I> sealed::Sealed for &I {}
impl<M: 'static, I: QuestionInputs<M>> QuestionInputs<M> for &'static I {
    type Borrowed<'a> = I::Borrowed<'a>;
    type Versions = I::Versions;
    const READERS: bool = I::READERS;
    fn validate(&self, namespace: NonZeroU64, before: NonZeroU64) -> Result<(), QuestionFault> {
        (**self).validate(namespace, before)
    }
    fn contains(&self, sources: &Sources<M>, field: FieldId) -> Result<bool, BindError> {
        (**self).contains(sources, field)
    }
    fn resolve<'a, R: ReaderValues>(
        &self,
        model: &'a M,
        sources: &Sources<M>,
        earlier: &'a R,
    ) -> Result<Resolved<Self::Borrowed<'a>, Self::Versions>, crate::Error> {
        (**self).resolve(model, sources, earlier)
    }
    fn failure<'a, R: ReaderValues>(
        &self,
        version: Self::Versions,
        earlier: &'a R,
    ) -> Option<Failure<'a>> {
        (**self).failure(version, earlier)
    }
    fn single(&self, version: Self::Versions, coarse: u64, policy: u64) -> Option<InputVersion> {
        (**self).single(version, coarse, policy)
    }
    fn visit(
        &self,
        version: Self::Versions,
        coarse: u64,
        policy: u64,
        visit: &mut impl FnMut(QuestionInput),
    ) {
        (**self).visit(version, coarse, policy, visit);
    }
}
impl<M, V> sealed::Sealed for Source<M, V> {}
impl<M: 'static, V: 'static> QuestionInputs<M> for Source<M, V> {
    type Borrowed<'a> = &'a V;
    type Versions = Revision;
    const READERS: bool = false;
    fn validate(&self, _: NonZeroU64, _: NonZeroU64) -> Result<(), QuestionFault> {
        Ok(())
    }
    fn contains(&self, _: &Sources<M>, field: FieldId) -> Result<bool, BindError> {
        Ok(self.id() == field)
    }
    fn resolve<'a, R: ReaderValues>(
        &self,
        model: &'a M,
        sources: &Sources<M>,
        _: &'a R,
    ) -> Result<Resolved<&'a V, Revision>, crate::Error> {
        let value = self.borrow_registered(model, sources)?;
        Ok(Resolved {
            version: value.revision(),
            availability: Availability::Ready(value),
        })
    }
    fn single(&self, revision: Revision, coarse: u64, policy: u64) -> Option<InputVersion> {
        Some(InputVersion {
            field: self.id(),
            revision,
            coarse,
            policy,
        })
    }
}
impl<P, C, T, S> sealed::Sealed for ProjectedSource<'_, P, C, T, S> {}
impl<P: 'static, C: 'static, T: 'static, S: SourcePath<C, T> + 'static> QuestionInputs<P>
    for ProjectedSource<'static, P, C, T, S>
{
    type Borrowed<'a> = &'a T;
    type Versions = (FieldId, Revision);
    const READERS: bool = false;
    fn validate(&self, _: NonZeroU64, _: NonZeroU64) -> Result<(), QuestionFault> {
        Ok(())
    }
    fn contains(&self, sources: &Sources<P>, field: FieldId) -> Result<bool, BindError> {
        Ok(self.field(sources)? == field)
    }
    fn resolve<'a, R: ReaderValues>(
        &self,
        model: &'a P,
        sources: &Sources<P>,
        _: &'a R,
    ) -> Result<Resolved<&'a T, Self::Versions>, crate::Error> {
        let (field, value) = Path::resolve(self, model, sources)?;
        Ok(Resolved {
            version: (field, value.revision()),
            availability: Availability::Ready(value),
        })
    }
    fn single(
        &self,
        (field, revision): Self::Versions,
        coarse: u64,
        policy: u64,
    ) -> Option<InputVersion> {
        Some(InputVersion {
            field,
            revision,
            coarse,
            policy,
        })
    }
}
#[doc(hidden)]
#[derive(Clone, Copy, PartialEq, Eq)]
pub struct ReaderVersion {
    ticket: u64,
    status: QuestionStatus,
}
impl<T> sealed::Sealed for Reader<T> {}
impl<M: 'static, T: 'static> QuestionInputs<M> for Reader<T> {
    type Borrowed<'a> = &'a T;
    type Versions = ReaderVersion;
    const READERS: bool = true;
    fn validate(&self, namespace: NonZeroU64, before: NonZeroU64) -> Result<(), QuestionFault> {
        if self.key.namespace == namespace && self.key.site < before {
            Ok(())
        } else {
            Err(QuestionFault::Revoked)
        }
    }
    fn contains(&self, _: &Sources<M>, _: FieldId) -> Result<bool, BindError> {
        Ok(false)
    }
    fn resolve<'a, R: ReaderValues>(
        &self,
        _: &'a M,
        _: &Sources<M>,
        earlier: &'a R,
    ) -> Result<Resolved<&'a T, ReaderVersion>, crate::Error> {
        let outcome = earlier.read(self.key).ok_or(QuestionFault::Revoked)?;
        let version = ReaderVersion {
            ticket: outcome.info.ticket,
            status: outcome.info.status,
        };
        let availability = match outcome.info.status {
            QuestionStatus::Ready => Availability::Ready(
                outcome
                    .value
                    .and_then(|v| v.downcast_ref())
                    .ok_or(QuestionFault::Revoked)?,
            ),
            QuestionStatus::Empty | QuestionStatus::Pending => Availability::Pending,
            QuestionStatus::Fault => Availability::Fault,
        };
        Ok(Resolved {
            version,
            availability,
        })
    }
    fn failure<'a, R: ReaderValues>(
        &self,
        version: ReaderVersion,
        earlier: &'a R,
    ) -> Option<Failure<'a>> {
        if version.status != QuestionStatus::Fault {
            return None;
        }
        let outcome = earlier.read(self.key)?;
        (outcome.info.ticket == version.ticket && outcome.info.status == version.status)
            .then_some(outcome.failure)
            .flatten()
    }
    fn single(&self, _: ReaderVersion, _: u64, _: u64) -> Option<InputVersion> {
        None
    }
    fn visit(&self, version: ReaderVersion, _: u64, _: u64, visit: &mut impl FnMut(QuestionInput)) {
        visit(QuestionInput::Reader {
            key: self.key,
            ticket: version.ticket,
            status: version.status,
        });
    }
}
impl<A, B> sealed::Sealed for (A, B) {}
impl<M: 'static, A: QuestionInputs<M>, B: QuestionInputs<M>> QuestionInputs<M> for (A, B) {
    type Borrowed<'a> = (A::Borrowed<'a>, B::Borrowed<'a>);
    type Versions = (A::Versions, B::Versions);
    const READERS: bool = A::READERS || B::READERS;
    fn validate(&self, namespace: NonZeroU64, before: NonZeroU64) -> Result<(), QuestionFault> {
        self.0.validate(namespace, before)?;
        self.1.validate(namespace, before)
    }
    fn contains(&self, sources: &Sources<M>, field: FieldId) -> Result<bool, BindError> {
        Ok(self.0.contains(sources, field)? || self.1.contains(sources, field)?)
    }
    fn resolve<'a, R: ReaderValues>(
        &self,
        model: &'a M,
        sources: &Sources<M>,
        earlier: &'a R,
    ) -> Result<Resolved<Self::Borrowed<'a>, Self::Versions>, crate::Error> {
        let a = self.0.resolve(model, sources, earlier)?;
        let b = self.1.resolve(model, sources, earlier)?;
        let availability = match (a.availability, b.availability) {
            (Availability::Fault, _) | (_, Availability::Fault) => Availability::Fault,
            (Availability::Ready(a), Availability::Ready(b)) => Availability::Ready((a, b)),
            _ => Availability::Pending,
        };
        Ok(Resolved {
            version: (a.version, b.version),
            availability,
        })
    }
    fn failure<'a, R: ReaderValues>(
        &self,
        version: Self::Versions,
        earlier: &'a R,
    ) -> Option<Failure<'a>> {
        self.0
            .failure(version.0, earlier)
            .or_else(|| self.1.failure(version.1, earlier))
    }
    fn single(&self, _: Self::Versions, _: u64, _: u64) -> Option<InputVersion> {
        None
    }
    fn visit(
        &self,
        version: Self::Versions,
        coarse: u64,
        policy: u64,
        visit: &mut impl FnMut(QuestionInput),
    ) {
        self.0.visit(version.0, coarse, policy, visit);
        self.1.visit(version.1, coarse, policy, visit);
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn earlier_key_validation_rejects_foreign_equal_and_later_sites() {
        let namespace = NonZeroU64::new(4).unwrap();
        let before = NonZeroU64::new(5).unwrap();
        for (owner, site, valid) in [(4, 4, true), (4, 5, false), (4, 6, false), (3, 1, false)] {
            let reader = Reader::<u32> {
                key: ReaderKey {
                    namespace: NonZeroU64::new(owner).unwrap(),
                    site: NonZeroU64::new(site).unwrap(),
                },
                marker: PhantomData,
            };
            assert_eq!(
                <Reader<u32> as QuestionInputs<()>>::validate(&reader, namespace, before).is_ok(),
                valid
            );
        }
    }
}
