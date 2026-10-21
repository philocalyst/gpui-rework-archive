//! Concrete question slots are consed into the existing static lane chain.
use super::*;
use crate::{
    FieldId, Source, Sources,
    identity::Sites,
    remote::{LaneSet, Stage, sealed},
};
use gpui_reactivity_state::{OwnerRegistry, OwnerScope, RequestGate};

#[doc(hidden)]
#[derive(Clone, Copy)]
pub enum Change {
    Mount,
    Source(Option<FieldId>),
    Retry(ReaderKey),
}

/// Build typed declarations before the model. Binding consumes this plan once;
/// restoring constructs a new plan and remints Reader keys.
pub struct Questions<M, L = ()> {
    lanes: L,
    scope: Option<OwnerScope>,
    namespace: NonZeroU64,
    next_site: u64,
    marker: PhantomData<fn(M)>,
}
impl<M> Default for Questions<M> {
    fn default() -> Self {
        Self::new()
    }
}
impl<M> Questions<M> {
    pub fn new() -> Self {
        Self {
            lanes: (),
            scope: None,
            namespace: Sites::new().namespace(),
            next_site: 0,
            marker: PhantomData,
        }
    }
}
impl<M: 'static, L: LaneSet<M>> Questions<M, L> {
    /// Freeze one explicit source and enqueue owned work through an existing
    /// executor/service. `start` must return promptly and must not run UI code.
    /// Exactly one physical completion can be outstanding; newer inputs retain
    /// only their latest frozen snapshot while waiting for that credit.
    ///
    /// ```compile_fail
    /// use gpui::{Questions,Source,Completion,StartError};
    /// fn borrowed_input<M:'static>(source:Source<M,String>) {
    ///     let _=Questions::new().question(source,|value|value.as_str(),
    ///         |_:&str,completion:Completion<String,std::convert::Infallible>| {
    ///             drop(completion);Ok::<(),StartError>(())
    ///         });
    /// }
    /// ```
    #[allow(
        clippy::type_complexity,
        reason = "The inferred concrete lane stores all types once; an alias only moves these parameters."
    )]
    pub fn question<
        V: 'static,
        I: Send + 'static,
        T: Send + 'static,
        E: std::error::Error + Send + 'static,
        F,
        S,
    >(
        mut self,
        source: Source<M, V>,
        freeze: F,
        start: S,
    ) -> Result<
        (
            Questions<M, QuestionLane<M, V, I, T, E, F, S, L>>,
            Reader<T>,
        ),
        QuestionFault,
    >
    where
        F: Fn(&V) -> I,
        S: FnMut(I, Completion<T, E>) -> Result<(), StartError>,
    {
        self.next_site = self
            .next_site
            .checked_add(1)
            .ok_or(QuestionFault::Exhausted)?;
        if self.scope.is_none() {
            self.scope = Some(
                OwnerRegistry::new()
                    .mount()
                    .map_err(|_| QuestionFault::Exhausted)?,
            );
        }
        let gate = self
            .scope
            .as_mut()
            .unwrap()
            .producer(self.next_site)
            .map_err(|_| QuestionFault::Exhausted)?;
        let key = ReaderKey {
            namespace: self.namespace,
            site: NonZeroU64::new(self.next_site).unwrap(),
        };
        let lanes = QuestionLane {
            source,
            freeze: Some(freeze),
            start: Some(start),
            key,
            gate,
            controller: Some(Arc::new(Controller::new())),
            state: State::Empty,
            version: None,
            ticket: 0,
            coarse: 0,
            policy: 0,
            pending: None,
            running_ticket: None,
            staged_terminal: None,
            tail: self.lanes,
            cursor: 0,
            stats: QuestionStats::default(),
        };
        Ok((
            Questions {
                lanes,
                scope: self.scope,
                namespace: self.namespace,
                next_site: self.next_site,
                marker: PhantomData,
            },
            Reader {
                key,
                marker: PhantomData,
            },
        ))
    }
    pub(crate) fn bind<A: LaneSet<M>>(self, tail: A) -> QuestionSet<L, A> {
        QuestionSet {
            lanes: self.lanes,
            scope: self.scope,
            tail,
            cursor: 0,
        }
    }
}

enum StoredFault<E> {
    Domain(E),
    Framework(QuestionFault),
}
enum State<T, E> {
    Empty,
    Ready(T),
    Pending(Option<T>),
    Fault(StoredFault<E>, Option<T>),
}
impl<T, E> State<T, E> {
    fn take_previous(&mut self) -> Option<T> {
        match std::mem::replace(self, Self::Empty) {
            Self::Ready(value) => Some(value),
            Self::Pending(previous) | Self::Fault(_, previous) => previous,
            Self::Empty => None,
        }
    }
}
struct Work<I> {
    input: I,
    stamp: RequestStamp,
    version: InputVersion,
}

/// Inferred implementation storage, not a model-managed task or an erased result.
#[doc(hidden)]
pub struct QuestionLane<M, V, I, T, E, F, S, L> {
    source: Source<M, V>,
    freeze: Option<F>,
    start: Option<S>,
    key: ReaderKey,
    gate: RequestGate,
    controller: Option<Arc<Controller<T, E>>>,
    state: State<T, E>,
    version: Option<InputVersion>,
    ticket: u64,
    coarse: u64,
    policy: u64,
    pending: Option<Work<I>>,
    running_ticket: Option<u64>,
    staged_terminal: Option<u8>,
    tail: L,
    cursor: usize,
    stats: QuestionStats,
}
impl<M, V, I, T, E, F, S, L> QuestionLane<M, V, I, T, E, F, S, L> {
    #[inline]
    fn control(&self) -> &Arc<Controller<T, E>> {
        self.controller.as_ref().expect("live question controller")
    }
}
impl<M, V, I, T, E, F, S, L> Drop for QuestionLane<M, V, I, T, E, F, S, L> {
    fn drop(&mut self) {
        // Natural Win/failed-mount destruction must cancel the cooperative
        // hint as well as relinquishing its response-owner lease.
        if let Some(controller) = self.controller.take() {
            controller.current.store(0, Ordering::Release);
            controller.mailbox.close();
        }
    }
}
impl<M, V, I, T: 'static, E: std::error::Error + 'static, F, S, L: ReaderValues> ReaderValues
    for QuestionLane<M, V, I, T, E, F, S, L>
{
    fn read(&self, key: ReaderKey) -> Option<Outcome<'_>> {
        if key != self.key {
            return self.tail.read(key);
        }
        let (status, value, failure) = match &self.state {
            State::Empty => (QuestionStatus::Empty, None, None),
            State::Ready(value) => (QuestionStatus::Ready, Some(value as &dyn Any), None),
            State::Pending(previous) => (
                QuestionStatus::Pending,
                previous.as_ref().map(|v| v as &dyn Any),
                None,
            ),
            State::Fault(error, previous) => (
                QuestionStatus::Fault,
                previous.as_ref().map(|v| v as &dyn Any),
                Some(match error {
                    StoredFault::Domain(error) => Failure::Domain(error),
                    StoredFault::Framework(error) => Failure::Framework(*error),
                }),
            ),
        };
        Some(Outcome {
            info: QuestionInfo {
                status,
                ticket: self.ticket,
                input: self.version,
                completion_leased: self.running_ticket.is_some(),
                stats: self.stats,
            },
            value,
            failure,
        })
    }
}
impl<M, V, I, T, E, F, S, L> sealed::Sealed for QuestionLane<M, V, I, T, E, F, S, L> {}

impl<
    M: 'static,
    V: 'static,
    I: Send + 'static,
    T: Send + 'static,
    E: std::error::Error + Send + 'static,
    F,
    S,
    L: LaneSet<M>,
> QuestionLane<M, V, I, T, E, F, S, L>
where
    F: Fn(&V) -> I,
    S: FnMut(I, Completion<T, E>) -> Result<(), StartError>,
{
    fn fault(&mut self, error: QuestionFault) {
        self.stats.framework_faults = self.stats.framework_faults.saturating_add(1);
        self.control().current.store(0, Ordering::Release);
        self.gate.cancel();
        self.pending = None;
        let previous = self.state.take_previous();
        self.state = State::Fault(StoredFault::Framework(error), previous);
    }
    fn start_pending(&mut self) -> bool {
        if !self.control().mailbox.idle() {
            return false;
        }
        let Some(work) = self.pending.take() else {
            return false;
        };
        self.running_ticket = Some(work.stamp.ticket());
        self.control().mailbox.begin();
        let completion = Completion {
            controller: Some(self.control().clone()),
            stamp: Some(work.stamp),
            version: work.version,
        };
        self.stats.dispatched = self.stats.dispatched.saturating_add(1);
        match catch_unwind(AssertUnwindSafe(|| {
            (self.start.as_mut().expect("live question"))(work.input, completion)
        })) {
            Ok(Ok(())) => false,
            Ok(Err(error)) => {
                self.fault(QuestionFault::StartRejected(error));
                true
            }
            Err(_) => {
                self.fault(QuestionFault::ExecutorPanicked);
                true
            }
        }
    }
    fn apply_response(
        &mut self,
        message: Message<T, E>,
        model: &M,
        sources: &Sources<M>,
        applied: &mut usize,
    ) -> Result<(), crate::Error> {
        let current = match self.source.borrow_registered(model, sources) {
            Ok(signal) => signal,
            Err(error) => {
                self.fault(QuestionFault::InputUnavailable);
                *applied += 1;
                return Err(error.into());
            }
        };
        if Some(message.version) == self.version && message.version.revision != current.revision() {
            // A nested/externally changed source may be discovered here
            // even when a different exact edit did not refresh this slot.
            // Its current ticket cannot become Ready or remain Pending
            // after its only physical completion has already terminated.
            self.fault(QuestionFault::InputUnavailable);
            self.stats.stale_results = self.stats.stale_results.saturating_add(1);
            *applied += 1;
            return Ok(());
        }
        if Some(message.version) == self.version
            && message.version.revision == current.revision()
            && self.gate.accept(&message.stamp).is_ok()
        {
            self.state = match message.value {
                Ok(value) => State::Ready(value),
                Err(error) => {
                    let previous = self.state.take_previous();
                    State::Fault(StoredFault::Domain(error), previous)
                }
            };
            *applied += 1;
            self.stats.accepted = self.stats.accepted.saturating_add(1);
        } else {
            self.stats.stale_results = self.stats.stale_results.saturating_add(1);
        }
        Ok(())
    }
    fn refresh_self(
        &mut self,
        model: &M,
        sources: &Sources<M>,
        change: Change,
    ) -> Result<bool, crate::Error> {
        match change {
            Change::Source(Some(field)) if field != self.source.id() => return Ok(false),
            Change::Retry(key) if key != self.key => return Ok(false),
            Change::Source(None) => {
                let Some(next) = self.coarse.checked_add(1) else {
                    self.fault(QuestionFault::Exhausted);
                    self.gate.revoke();
                    return Err(QuestionFault::Exhausted.into());
                };
                self.coarse = next;
            }
            Change::Retry(_) => {
                let Some(next) = self.policy.checked_add(1) else {
                    self.fault(QuestionFault::Exhausted);
                    self.gate.revoke();
                    return Err(QuestionFault::Exhausted.into());
                };
                self.policy = next;
            }
            _ => {}
        }
        let signal = match self.source.borrow_registered(model, sources) {
            Ok(signal) => signal,
            Err(error) => {
                self.fault(QuestionFault::InputUnavailable);
                return Err(error.into());
            }
        };
        let input = (self.freeze.as_ref().expect("live question"))(signal);
        self.stats.frozen = self.stats.frozen.saturating_add(1);
        let version = InputVersion {
            field: self.source.id(),
            revision: signal.revision(),
            coarse: self.coarse,
            policy: self.policy,
        };
        let stamp = match self.gate.begin() {
            Ok(stamp) => stamp,
            Err(_) => {
                self.fault(QuestionFault::Exhausted);
                return Err(QuestionFault::Exhausted.into());
            }
        };
        self.ticket = stamp.ticket();
        self.version = Some(version);
        self.control().current.store(self.ticket, Ordering::Release);
        if matches!(self.state, State::Pending(_)) {
            self.stats.superseded = self.stats.superseded.saturating_add(1);
        }
        let previous = self.state.take_previous();
        self.state = State::Pending(previous);
        self.pending = Some(Work {
            input,
            stamp,
            version,
        });
        if !matches!(change, Change::Mount) {
            self.start_pending();
        }
        Ok(true)
    }
}

impl<
    M: 'static,
    V: 'static,
    I: Send + 'static,
    T: Send + 'static,
    E: std::error::Error + Send + 'static,
    F,
    S,
    L: LaneSet<M>,
> LaneSet<M> for QuestionLane<M, V, I, T, E, F, S, L>
where
    F: Fn(&V) -> I,
    S: FnMut(I, Completion<T, E>) -> Result<(), StartError>,
{
    const EMPTY: bool = false;
    const QUESTIONS: bool = true;
    fn count(&self) -> usize {
        1 + self.tail.count()
    }
    fn cursor(&self) -> usize {
        self.cursor
    }
    fn set_cursor(&mut self, cursor: usize) {
        self.cursor = cursor;
    }
    fn stage(&mut self, index: usize) -> Stage {
        if index != 0 {
            return self.tail.stage(index - 1);
        }
        if self.staged_terminal.is_some() {
            return Stage::Empty;
        }
        if let Some(terminal) = self.control().mailbox.freeze() {
            self.staged_terminal = Some(terminal);
            Stage::Ready
        } else {
            Stage::Empty
        }
    }

    fn apply(&mut self, model: &mut M, applied: &mut usize) {
        self.tail.apply(model, applied);
    }
    fn refresh(
        &mut self,
        model: &M,
        sources: &Sources<M>,
        change: Change,
    ) -> Result<bool, crate::Error> {
        let own = self.refresh_self(model, sources, change)?;
        Ok(self.tail.refresh(model, sources, change)? || own)
    }
    fn apply_questions(
        &mut self,
        model: &M,
        sources: &Sources<M>,
        applied: &mut usize,
    ) -> Result<(), crate::Error> {
        let mut binding_error = None;
        if let Some(terminal) = self.staged_terminal.take() {
            // The staged terminal seals this response across ordinary callbacks.
            // Take only now, before retiring the physical credit.
            if let Some(message) = self.control().mailbox.take() {
                binding_error = self.apply_response(message, model, sources, applied).err();
            }
            let ticket = self
                .running_ticket
                .take()
                .expect("terminal belongs to one launched cap");
            self.control().mailbox.retire();
            if ticket == self.ticket && matches!(self.state, State::Pending(_)) {
                let failure = match terminal {
                    ABANDONED => Some(QuestionFault::Abandoned),
                    PANICKED => Some(QuestionFault::WorkerPanicked),
                    _ => None,
                };
                if let Some(error) = failure {
                    self.fault(error);
                    *applied += 1;
                }
            }
            *applied += usize::from(self.start_pending());
        }
        let tail = self.tail.apply_questions(model, sources, applied);
        // A checked binding rejection must still retire the physical lease.
        // Otherwise its already-staged terminal would have no next wake.
        if let Some(error) = binding_error {
            return Err(error);
        }
        tail
    }
    fn close(&mut self) {
        self.gate.revoke();
        // Relinquish the owner lease before running input/result destructors.
        // A still-running physical cap owns any deferred response reclamation.
        if let Some(controller) = self.controller.take() {
            controller.current.store(0, Ordering::Release);
            controller.mailbox.close();
        }
        self.staged_terminal = None;
        self.pending = None;
        self.state = State::Empty;
        self.freeze.take();
        self.start.take();
        self.tail.close();
    }
    fn start_questions(&mut self) -> bool {
        let own = self.start_pending();
        self.tail.start_questions() || own
    }
    #[cfg(feature = "native")]
    fn attach(&mut self, wake: &gpui_reactivity_host::native::Wake) {
        let _ = self.control().wake.set(wake.clone());
        self.control().signal();
        self.tail.attach(wake);
    }
    fn signal(&self) {
        if let Some(controller) = &self.controller {
            controller.signal();
        }
        self.tail.signal();
    }
}

/// One owner scope around a concrete chain; no per-producer trait-object box.
#[doc(hidden)]
pub struct QuestionSet<Q, L> {
    lanes: Q,
    scope: Option<OwnerScope>,
    tail: L,
    cursor: usize,
}
impl<Q: ReaderValues, L: ReaderValues> ReaderValues for QuestionSet<Q, L> {
    fn read(&self, key: ReaderKey) -> Option<Outcome<'_>> {
        self.lanes.read(key).or_else(|| self.tail.read(key))
    }
}
impl<Q, L> sealed::Sealed for QuestionSet<Q, L> {}
impl<M, Q: LaneSet<M>, L: LaneSet<M>> LaneSet<M> for QuestionSet<Q, L> {
    const EMPTY: bool = false;
    const QUESTIONS: bool = true;
    fn count(&self) -> usize {
        self.lanes.count() + self.tail.count()
    }
    fn cursor(&self) -> usize {
        self.cursor
    }
    fn set_cursor(&mut self, cursor: usize) {
        self.cursor = cursor;
    }
    fn stage(&mut self, index: usize) -> Stage {
        let count = self.lanes.count();
        if index < count {
            self.lanes.stage(index)
        } else {
            self.tail.stage(index - count)
        }
    }
    fn apply(&mut self, model: &mut M, applied: &mut usize) {
        self.lanes.apply(model, applied);
        self.tail.apply(model, applied);
    }
    fn refresh(
        &mut self,
        model: &M,
        sources: &Sources<M>,
        change: Change,
    ) -> Result<bool, crate::Error> {
        let a = self.lanes.refresh(model, sources, change)?;
        Ok(self.tail.refresh(model, sources, change)? || a)
    }
    fn apply_questions(
        &mut self,
        model: &M,
        sources: &Sources<M>,
        applied: &mut usize,
    ) -> Result<(), crate::Error> {
        let own = self.lanes.apply_questions(model, sources, applied);
        let tail = self.tail.apply_questions(model, sources, applied);
        own.and(tail)
    }
    fn close(&mut self) {
        if let Some(scope) = &mut self.scope {
            scope.revoke();
        }
        self.lanes.close();
        self.tail.close();
    }
    fn start_questions(&mut self) -> bool {
        let own = self.lanes.start_questions();
        self.tail.start_questions() || own
    }
    #[cfg(feature = "native")]
    fn attach(&mut self, wake: &gpui_reactivity_host::native::Wake) {
        self.lanes.attach(wake);
        self.tail.attach(wake);
    }
    fn signal(&self) {
        self.lanes.signal();
        self.tail.signal();
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::convert::Infallible;
    struct Model {
        value: crate::Signal<u32>,
        other: crate::Signal<u32>,
    }
    const VALUE: Source<Model, u32> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    #[test]
    fn version_exhaustion_faults_instead_of_leaving_unstartable_pending_work() {
        let (mut plan, reader) = Questions::new()
            .question(
                VALUE,
                |v| *v,
                |_: u32, cap: Completion<u32, Infallible>| {
                    drop(cap);
                    Ok(())
                },
            )
            .unwrap();
        let model = Model {
            value: crate::Signal::new(1),
            other: crate::Signal::new(2),
        };
        let sources = Sources::new().direct(VALUE);
        plan.lanes.coarse = u64::MAX;
        assert!(matches!(
            plan.lanes
                .refresh_self(&model, &sources, Change::Source(None)),
            Err(crate::Error::Question(QuestionFault::Exhausted))
        ));
        assert_eq!(
            plan.lanes.read(reader.key).unwrap().info.status,
            QuestionStatus::Fault
        );
        assert!(plan.lanes.pending.is_none());
        assert_eq!(plan.lanes.control().current.load(Ordering::Acquire), 0);
        plan.lanes.coarse = 0;
        plan.lanes.policy = u64::MAX;
        assert!(
            plan.lanes
                .refresh_self(&model, &sources, Change::Retry(reader.key))
                .is_err()
        );
        assert!(plan.lanes.pending.is_none());
    }
    #[test]
    fn binding_rejection_retires_the_staged_terminal_before_returning_error() {
        let (send, jobs) = std::sync::mpsc::channel();
        let (mut plan, _) = Questions::new()
            .question(
                VALUE,
                |v| *v,
                move |input, cap: Completion<u32, Infallible>| {
                    send.send((input, cap)).unwrap();
                    Ok(())
                },
            )
            .unwrap();
        let model = Model {
            value: crate::Signal::new(1),
            other: crate::Signal::new(2),
        };
        let sources = Sources::new().direct(VALUE);
        plan.lanes
            .refresh_self(&model, &sources, Change::Mount)
            .unwrap();
        plan.lanes.start_pending();
        jobs.recv().unwrap().1.complete(Ok(1)).unwrap();
        assert!(matches!(plan.lanes.stage(0), Stage::Ready));
        // Simulate a checked projection mismatch without invoking unsafe code or
        // constructing a forged request stamp. No rejected value is admitted.
        plan.lanes.source = Source::new(FieldId::new(1), "value", |m| &m.other, |m| &mut m.other);
        assert!(
            plan.lanes
                .apply_questions(&model, &sources, &mut 0)
                .is_err()
        );
        assert!(plan.lanes.running_ticket.is_none());
        assert!(plan.lanes.control().mailbox.idle());
    }
    #[test]
    fn a_discovered_revision_change_cannot_leave_the_current_ticket_pending_forever() {
        let (send, jobs) = std::sync::mpsc::channel();
        let (mut plan, reader) = Questions::new()
            .question(
                VALUE,
                |v| *v,
                move |_, cap: Completion<u32, Infallible>| {
                    send.send(cap).unwrap();
                    Ok(())
                },
            )
            .unwrap();
        let mut model = Model {
            value: crate::Signal::new(1),
            other: crate::Signal::new(2),
        };
        let sources = Sources::new().direct(VALUE);
        plan.lanes
            .refresh_self(&model, &sources, Change::Mount)
            .unwrap();
        plan.lanes.start_pending();
        // A private fixture deliberately bypasses the normal source hook.
        *model.value = 3;
        jobs.recv().unwrap().complete(Ok(1)).unwrap();
        assert!(matches!(plan.lanes.stage(0), Stage::Ready));
        plan.lanes
            .apply_questions(&model, &sources, &mut 0)
            .unwrap();
        assert_eq!(
            plan.lanes.read(reader.key).unwrap().info.status,
            QuestionStatus::Fault
        );
        assert!(plan.lanes.control().mailbox.idle());
        plan.lanes
            .refresh_self(&model, &sources, Change::Retry(reader.key))
            .unwrap();
        jobs.recv().unwrap().complete(Ok(3)).unwrap();
        assert!(matches!(plan.lanes.stage(0), Stage::Ready));
        plan.lanes
            .apply_questions(&model, &sources, &mut 0)
            .unwrap();
        assert_eq!(
            plan.lanes.read(reader.key).unwrap().info.status,
            QuestionStatus::Ready
        );
    }
}
