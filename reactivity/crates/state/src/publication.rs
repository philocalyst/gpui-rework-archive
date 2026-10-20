/// A committed logical version. Counters never wrap into an older epoch.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord)]
pub struct Epoch(u64);

impl Epoch {
    pub fn get(self) -> u64 {
        self.0
    }
}

/// A small owned-snapshot model of the two-epoch publication protocol.
///
/// Draft builders and validators see immutable committed data and return new
/// owned values. Returning `Err` or unwinding before publication leaves the old
/// snapshots in place. A presentation failure retains the old frame while the
/// logical epoch stays advanced; retry builds against the newest logical state.
/// Only one old presentation is retained, so failure cannot pin growing history.
///
/// This is a full owned snapshot prototype, not a sparse draft store or a layout
/// inverse journal. It cannot roll back mutations to external/interior state,
/// arbitrary mutable handlers, or panicking destructors. Committed values must
/// have non-panicking `Drop`. Side effects belong after successful publication.
#[derive(Debug)]
pub struct TwoEpoch<L, P> {
    logical: L,
    presentation: P,
    logical_epoch: Epoch,
    presentation_epoch: Epoch,
}

impl<L, P> TwoEpoch<L, P> {
    /// The initial logical state and presentation must describe the same epoch.
    pub fn new(logical: L, presentation: P) -> Self {
        Self {
            logical,
            presentation,
            logical_epoch: Epoch(0),
            presentation_epoch: Epoch(0),
        }
    }

    pub fn logical(&self) -> &L {
        &self.logical
    }
    pub fn presentation(&self) -> &P {
        &self.presentation
    }
    pub fn logical_epoch(&self) -> Epoch {
        self.logical_epoch
    }
    pub fn presentation_epoch(&self) -> Epoch {
        self.presentation_epoch
    }
    pub fn presentation_is_current(&self) -> bool {
        self.logical_epoch == self.presentation_epoch
    }

    /// Build and validate privately, then publish. Effects cannot run recursively
    /// through this API: no effect callback is accepted or invoked.
    /// Panics on epoch exhaustion before building a draft.
    pub fn commit_logical<E>(
        &mut self,
        build: impl FnOnce(&L) -> Result<L, E>,
        validate: impl FnOnce(&L) -> Result<(), E>,
    ) -> Result<Epoch, E> {
        let next = Epoch(
            self.logical_epoch
                .0
                .checked_add(1)
                .expect("logical epoch exhausted"),
        );
        let draft = build(&self.logical)?;
        validate(&draft)?;
        let old = std::mem::replace(&mut self.logical, draft);
        self.logical_epoch = next;
        drop(old);
        Ok(next)
    }

    /// Build the entire presentation (including interaction data) together.
    /// On failure both the previous presentation and its epoch remain unchanged.
    pub fn commit_presentation<E>(
        &mut self,
        build: impl FnOnce(&L, &P) -> Result<P, E>,
        validate: impl FnOnce(&P) -> Result<(), E>,
    ) -> Result<Epoch, E> {
        let draft = build(&self.logical, &self.presentation)?;
        validate(&draft)?;
        let old = std::mem::replace(&mut self.presentation, draft);
        self.presentation_epoch = self.logical_epoch;
        drop(old);
        Ok(self.presentation_epoch)
    }
}
