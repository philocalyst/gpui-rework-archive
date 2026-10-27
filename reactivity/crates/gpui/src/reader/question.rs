//! Concrete question slots are consed into the existing static lane chain.
use super::future::FutureStarter;
use super::inputs::{Availability, QuestionInputs};
use super::*;
use crate::{
    FieldId, Sources,
    identity::Sites,
    remote::{LaneSet, Stage, sealed},
};
use std::future::Future;

pub(super) trait Starter<I, T, E> {
    fn start(&mut self, input: I, completion: Completion<T, E>) -> Result<(), StartError>;
    fn cancel(&mut self) {}
    fn retire(&mut self) {}
}
#[doc(hidden)]
#[repr(transparent)]
pub struct SyncStarter<S>(S);
impl<I, T, E, S> Starter<I, T, E> for SyncStarter<S>
where
    S: FnMut(I, Completion<T, E>) -> Result<(), StartError>,
{
    fn start(&mut self, input: I, completion: Completion<T, E>) -> Result<(), StartError> {
        (self.0)(input, completion)
    }
}

#[doc(hidden)]
#[derive(Clone, Copy)]
pub enum Change<'a> {
    Mount,
    Dependencies,
    Source(Option<FieldId>),
    Sources(&'a [Option<FieldId>; 4]),
    Retry(ReaderKey),
}

/// Build typed declarations before the model. Binding consumes this plan once;
/// restoring constructs a new plan and remints Reader keys.
pub struct Questions<M, L = ()> {
    lanes: L,
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
            namespace: Sites::new().namespace(),
            next_site: 0,
            marker: PhantomData,
        }
    }
}
impl<M: 'static, L: LaneSet<M>> Questions<M, L> {
    /// Freeze declared inputs and enqueue owned work through an existing
    /// executor/service. `start` must return promptly and must not run UI code.
    /// Inputs are a Source, an earlier Reader from this same plan, or a nested
    /// pair. Reader inputs freeze only Ready values; Pending/Fault retain no
    /// authority to reuse their previous payload as a new snapshot.
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
        A: QuestionInputs<M>,
        I: Send + 'static,
        T: Send + 'static,
        E: std::error::Error + Send + 'static,
        F,
        S,
    >(
        self,
        inputs: A,
        freeze: F,
        start: S,
    ) -> Result<
        (
            Questions<M, QuestionLane<M, A, I, T, E, F, SyncStarter<S>, L>>,
            Reader<T>,
        ),
        QuestionFault,
    >
    where
        F: for<'a> Fn(A::Borrowed<'a>) -> I,
        S: FnMut(I, Completion<T, E>) -> Result<(), StartError>,
    {
        self.question_with(inputs, freeze, SyncStarter(start))
    }

    /// Ask one bounded Future question using an explicitly owned executor.
    /// `freeze` borrows declared inputs only on the owner; `make` promptly
    /// creates an owned Send future. No model/source/Reader borrow crosses await.
    /// The executor runs the future; GPUI catches poll panics as WorkerPanicked
    /// and factory/spawn panics as ExecutorPanicked. Domain Err retains the prior
    /// value, as do Pending and Fault projections on ordinary questions.
    ///
    /// Superseding inputs cancels the exact old task, including a never-waking
    /// Pending future. The newest frozen input waits for actual future teardown
    /// and terminal admission before starting. Close requests cancellation
    /// without joining. See QuestionExecutor and QuestionTask for obligations.
    ///
    /// ```
    /// use gpui::{Questions, QuestionExecutor, Source};
    /// fn declare<M: 'static, X: QuestionExecutor>(source: Source<M, String>, executor: X) {
    ///     let (questions, answer) = Questions::new().question_future(
    ///         source, Clone::clone, executor,
    ///         |query| async move { Ok::<_, std::convert::Infallible>(query.len()) },
    ///     ).unwrap();
    ///     // Bind questions to a Win/Window; put only the inert answer in the model.
    ///     let _ = (questions, answer);
    /// }
    /// ```
    /// ```compile_fail
    /// use gpui::{Questions, QuestionExecutor, Source};
    /// fn borrowed<M: 'static, X: QuestionExecutor>(source: Source<M, String>, executor: X) {
    ///     let _ = Questions::new().question_future(source, |s| s.as_str(), executor,
    ///         |s| async move { Ok::<_, std::convert::Infallible>(s.len()) });
    /// }
    /// ```
    /// ```compile_fail
    /// use gpui::{Questions, QuestionExecutor, Source};
    /// fn borrowed_capture<M: 'static, X: QuestionExecutor>(source: Source<M, String>, executor: X, service: &str) {
    ///     let _ = Questions::new().question_future(source, Clone::clone, executor,
    ///         |query| async move { Ok::<_, std::convert::Infallible>(format!("{service}{query}")) });
    /// }
    /// ```
    /// ```compile_fail
    /// use gpui::{Questions, QuestionExecutor, Source};
    /// fn foreign_source<M: 'static, X: QuestionExecutor>(source: Source<M, String>, executor: X) {
    ///     let _ = Questions::<()>::new().question_future(source, Clone::clone, executor,
    ///         |query| async move { Ok::<_, std::convert::Infallible>(query) });
    /// }
    /// ```
    #[allow(
        clippy::type_complexity,
        reason = "The inferred lane stores the executor and factory statically."
    )]
    pub fn question_future<A, I, T, E, F, X, Make, Fut>(
        self,
        inputs: A,
        freeze: F,
        executor: X,
        make: Make,
    ) -> Result<
        (
            Questions<M, QuestionLane<M, A, I, T, E, F, FutureStarter<X, Make>, L>>,
            Reader<T>,
        ),
        QuestionFault,
    >
    where
        A: QuestionInputs<M>,
        I: Send + 'static,
        T: Send + 'static,
        E: std::error::Error + Send + 'static,
        F: for<'a> Fn(A::Borrowed<'a>) -> I,
        X: QuestionExecutor,
        Make: FnMut(I) -> Fut,
        Fut: Future<Output = Result<T, E>> + Send + 'static,
    {
        self.question_with(inputs, freeze, FutureStarter::new(executor, make))
    }

    #[allow(
        clippy::type_complexity,
        reason = "Private shared construction preserves the public closure inference bounds."
    )]
    fn question_with<A, I, T, E, F, S>(
        mut self,
        inputs: A,
        freeze: F,
        start: S,
    ) -> Result<
        (
            Questions<M, QuestionLane<M, A, I, T, E, F, S, L>>,
            Reader<T>,
        ),
        QuestionFault,
    >
    where
        A: QuestionInputs<M>,
        I: Send + 'static,
        T: Send + 'static,
        E: std::error::Error + Send + 'static,
        F: for<'a> Fn(A::Borrowed<'a>) -> I,
        S: Starter<I, T, E>,
    {
        self.next_site = self
            .next_site
            .checked_add(1)
            .ok_or(QuestionFault::Exhausted)?;
        let key = ReaderKey {
            namespace: self.namespace,
            site: NonZeroU64::new(self.next_site).unwrap(),
        };
        inputs.validate(key.namespace, key.site)?;
        let lanes = QuestionLane {
            inputs,
            freeze: Some(freeze),
            start: Some(start),
            key,
            controller: Owner::new(QuestionContext::new()),
            state: State::Empty,
            version: None,
            marker: PhantomData,
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
            tail,
            cursor: 0,
        }
    }
}

enum StoredFault<E> {
    Domain(E),
    Framework(QuestionFault),
    Dependency,
}
enum State<T, E> {
    Empty,
    Ready(T),
    Pending(Option<T>),
    Fault(StoredFault<E>, Option<T>),
    Retired(Option<T>),
}
impl<T, E> State<T, E> {
    fn take_previous(&mut self) -> Option<T> {
        match std::mem::replace(self, Self::Empty) {
            Self::Ready(value) => Some(value),
            Self::Pending(previous) | Self::Fault(_, previous) | Self::Retired(previous) => {
                previous
            }
            Self::Empty => None,
        }
    }
}
enum FrozenInput<I> {
    Ready(I),
    Pending,
    Fault,
}
struct Frozen<V, I> {
    version: V,
    input: FrozenInput<I>,
}
struct Work<I> {
    input: I,
    ticket: Ticket,
}

/// Inferred implementation storage, not a model-managed task or an erased result.
#[doc(hidden)]
pub struct QuestionLane<M: 'static, A: QuestionInputs<M>, I, T, E, F, S, L> {
    inputs: A,
    freeze: Option<F>,
    start: Option<S>,
    key: ReaderKey,
    controller: Owner<Message<T, E>, QuestionContext>,
    state: State<T, E>,
    version: Option<A::Versions>,
    marker: PhantomData<fn(M)>,
    ticket: u64,
    coarse: u64,
    policy: u64,
    pending: Option<Work<I>>,
    running_ticket: Option<Ticket>,
    staged_terminal: Option<u8>,
    tail: L,
    cursor: usize,
    stats: QuestionStats,
}
/// Only the transient close stack owns these responses; never an owner field.
#[doc(hidden)]
pub struct RetiredQuestion<T, E, L> {
    _response: Option<Message<T, E>>,
    _tail: L,
}
impl<M: 'static, A: QuestionInputs<M>, I, T, E, F, S, L> QuestionLane<M, A, I, T, E, F, S, L> {
    #[inline]
    fn control(&self) -> &QuestionContext {
        self.controller.context()
    }
}

impl<M: 'static, A: QuestionInputs<M>, I, T, E, F, S, L> Drop
    for QuestionLane<M, A, I, T, E, F, S, L>
{
    fn drop(&mut self) {
        // Release the owner lease before starter/task destructors can cancel
        // synchronously. Explicit close collects responses for deferred drop.
        drop(self.controller.close());
    }
}
impl<
    M: 'static,
    A: QuestionInputs<M>,
    I,
    T: 'static,
    E: std::error::Error + 'static,
    F,
    S,
    L: ReaderValues,
> ReaderValues for QuestionLane<M, A, I, T, E, F, S, L>
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
                    StoredFault::Dependency => self
                        .version
                        .and_then(|version| self.inputs.failure(version, &self.tail))
                        .unwrap_or(Failure::Framework(QuestionFault::InputUnavailable)),
                }),
            ),
            State::Retired(previous) => (
                QuestionStatus::Fault,
                previous.as_ref().map(|value| value as &dyn Any),
                Some(Failure::Framework(QuestionFault::Exhausted)),
            ),
        };
        Some(Outcome {
            info: QuestionInfo {
                status,
                ticket: self.ticket,
                input: self
                    .version
                    .and_then(|v| self.inputs.single(v, self.coarse, self.policy)),
                completion_leased: self.running_ticket.is_some(),
                stats: self.stats,
            },
            value,
            failure,
        })
    }
    fn visit_inputs(&self, key: ReaderKey, visit: &mut impl FnMut(QuestionInput)) -> bool {
        if key != self.key {
            return self.tail.visit_inputs(key, visit);
        }
        if let Some(version) = self.version {
            self.inputs.visit(version, self.coarse, self.policy, visit);
        }
        true
    }
}
impl<M: 'static, A: QuestionInputs<M>, I, T, E, F, S, L> sealed::Sealed
    for QuestionLane<M, A, I, T, E, F, S, L>
{
}

#[allow(
    private_bounds,
    reason = "Only private operational methods use the private starter seam."
)]
impl<
    M: 'static,
    A: QuestionInputs<M>,
    I: Send + 'static,
    T: Send + 'static,
    E: std::error::Error + Send + 'static,
    F,
    S,
    L: LaneSet<M>,
> QuestionLane<M, A, I, T, E, F, S, L>
where
    F: for<'a> Fn(A::Borrowed<'a>) -> I,
    S: Starter<I, T, E>,
{
    fn fault(&mut self, error: QuestionFault) {
        // Exhaustion permanently retires this lane, including after another
        // fault or a diagnostic counter reset. No later refresh may mint work.
        if matches!(self.state, State::Retired(_)) {
            return;
        }
        if matches!(
            error,
            QuestionFault::InputUnavailable | QuestionFault::Exhausted
        ) {
            // No successfully observed pack describes this failed admission.
            // In particular, do not pair an old revision with a new coarse epoch.
            self.version = None;
        }
        self.stats.framework_faults = self.stats.framework_faults.saturating_add(1);
        self.control().current.store(0, Ordering::Release);
        self.start.as_mut().expect("live question").cancel();
        self.pending = None;
        let previous = self.state.take_previous();
        self.state = if error == QuestionFault::Exhausted {
            State::Retired(previous)
        } else {
            State::Fault(StoredFault::Framework(error), previous)
        };
    }
    fn start_pending(&mut self) -> bool {
        if !self.controller.idle() {
            return false;
        }
        let Some(work) = self.pending.take() else {
            return false;
        };
        self.running_ticket = Some(work.ticket);
        let completion = Completion {
            ticket: work.ticket,
            producer: self.controller.begin(),
        };
        self.stats.dispatched = self.stats.dispatched.saturating_add(1);
        match catch_unwind(AssertUnwindSafe(|| {
            self.start
                .as_mut()
                .expect("live question")
                .start(work.input, completion)
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
        // Only this Owner can receive the consuming Producer's message. A
        // matching current token admits it once; diagnostic ticket equality
        // alone would revive a retained Completion after a failed start.
        // Do not consume a newer queued token when retiring an old response.
        let admitted = self.control().current.load(Ordering::Relaxed) == message.ticket.get();
        if admitted {
            self.control().current.store(0, Ordering::Release);
        }
        // Resolve even stale messages: a checked binding rejection remains an
        // owner fault and must retire the staged physical completion below.
        let current = self
            .inputs
            .resolve(model, sources, &self.tail)
            .map(|current| {
                (
                    current.version,
                    matches!(current.availability, Availability::Ready(_)),
                )
            });
        let (version, ready) = match current {
            Ok(current) => current,
            Err(error) => {
                self.fault(QuestionFault::InputUnavailable);
                *applied += 1;
                return Err(error);
            }
        };
        if admitted && (Some(version) != self.version || !ready) {
            self.fault(QuestionFault::InputUnavailable);
            self.stats.stale_results = self.stats.stale_results.saturating_add(1);
            *applied += 1;
            return Ok(());
        }
        if admitted {
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
    // Finish all borrowed resolution/freezing before mutating owner state.
    // The generic borrowed family may have a destructor, so this boundary also
    // makes its lifetime independent of the retained owned input.
    fn freeze_input(
        &self,
        model: &M,
        sources: &Sources<M>,
        force: bool,
    ) -> Result<Option<Frozen<A::Versions, I>>, crate::Error> {
        let resolved = self.inputs.resolve(model, sources, &self.tail)?;
        if !force && self.version == Some(resolved.version) {
            return Ok(None);
        }
        let input = match resolved.availability {
            Availability::Ready(value) => {
                FrozenInput::Ready((self.freeze.as_ref().expect("live question"))(value))
            }
            Availability::Pending => FrozenInput::Pending,
            Availability::Fault => FrozenInput::Fault,
        };
        Ok(Some(Frozen {
            version: resolved.version,
            input,
        }))
    }
    fn refresh_self(
        &mut self,
        model: &M,
        sources: &Sources<M>,
        change: Change<'_>,
    ) -> Result<bool, crate::Error> {
        if let Change::Sources(fields) = change
            && !A::READERS
        {
            let mut relevant = false;
            for field in fields.iter().copied().skip(1).flatten() {
                if self.inputs.contains(sources, field)? {
                    relevant = true;
                    break;
                }
            }
            if !relevant {
                return Ok(false);
            }
        }
        match change {
            Change::Source(Some(field))
                if !A::READERS && !self.inputs.contains(sources, field)? =>
            {
                return Ok(false);
            }
            Change::Retry(key) if key != self.key && !A::READERS => return Ok(false),
            _ if matches!(self.state, State::Retired(_)) => {
                return Err(QuestionFault::Exhausted.into());
            }
            Change::Source(None) => {
                let Some(next) = self.coarse.checked_add(1) else {
                    self.fault(QuestionFault::Exhausted);
                    return Err(QuestionFault::Exhausted.into());
                };
                self.coarse = next;
            }
            Change::Retry(key) if key == self.key => {
                let Some(next) = self.policy.checked_add(1) else {
                    self.fault(QuestionFault::Exhausted);
                    return Err(QuestionFault::Exhausted.into());
                };
                self.policy = next;
            }
            _ => {}
        }
        let force = matches!(change, Change::Mount | Change::Source(None))
            || matches!(change, Change::Retry(key) if key == self.key);
        let frozen = match self.freeze_input(model, sources, force) {
            Ok(Some(frozen)) => frozen,
            Ok(None) => return Ok(false),
            Err(error) => {
                self.fault(QuestionFault::InputUnavailable);
                return Err(error);
            }
        };
        let Frozen { version, input } = frozen;
        if matches!(input, FrozenInput::Ready(_)) {
            self.stats.frozen = self.stats.frozen.saturating_add(1);
        }
        let Some(ticket) = self
            .ticket
            .checked_add(1)
            .and_then(NonZeroU64::new)
            .map(Ticket)
        else {
            self.fault(QuestionFault::Exhausted);
            return Err(QuestionFault::Exhausted.into());
        };
        self.ticket = ticket.get();
        self.version = Some(version);
        self.control().current.store(
            if matches!(input, FrozenInput::Ready(_)) {
                self.ticket
            } else {
                0
            },
            Ordering::Release,
        );
        self.start.as_mut().expect("live question").cancel();
        if matches!(self.state, State::Pending(_)) {
            self.stats.superseded = self.stats.superseded.saturating_add(1);
        }
        let previous = self.state.take_previous();
        match input {
            FrozenInput::Ready(input) => {
                self.state = State::Pending(previous);
                self.pending = Some(Work { input, ticket });
            }
            FrozenInput::Pending => {
                self.state = State::Pending(previous);
                self.pending = None;
            }
            FrozenInput::Fault => {
                self.state = State::Fault(StoredFault::Dependency, previous);
                self.pending = None;
            }
        }
        if !matches!(change, Change::Mount) {
            self.start_pending();
        }
        Ok(true)
    }
}

impl<
    M: 'static,
    A: QuestionInputs<M>,
    I: Send + 'static,
    T: Send + 'static,
    E: std::error::Error + Send + 'static,
    F,
    S,
    L: LaneSet<M>,
> LaneSet<M> for QuestionLane<M, A, I, T, E, F, S, L>
where
    F: for<'a> Fn(A::Borrowed<'a>) -> I,
    S: Starter<I, T, E>,
{
    const EMPTY: bool = false;
    const QUESTIONS: bool = true;
    const FIELD_EDITS: bool = L::FIELD_EDITS;
    type Retired = RetiredQuestion<T, E, L::Retired>;
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
        if let Some(terminal) = self.controller.freeze() {
            self.staged_terminal = Some(terminal);
            Stage::Ready
        } else {
            Stage::Empty
        }
    }

    fn staged(&self) -> usize {
        usize::from(self.staged_terminal.is_some()) + self.tail.staged()
    }

    fn apply(
        &mut self,
        model: &mut M,
        sources: &Sources<M>,
        applied: &mut usize,
        exact: &mut crate::remote::SourceEdits,
        remaining: &mut usize,
    ) -> Result<(), crate::Error> {
        self.tail.apply(model, sources, applied, exact, remaining)
    }
    fn validate(&self, model: &M, sources: &Sources<M>) -> Result<(), crate::Error> {
        self.tail.validate(model, sources)
    }
    fn refresh(
        &mut self,
        model: &M,
        sources: &Sources<M>,
        change: Change<'_>,
    ) -> Result<bool, crate::Error> {
        let tail = self.tail.refresh(model, sources, change);
        let own = self.refresh_self(model, sources, change);
        tail.and_then(|tail| own.map(|own| tail || own))
    }
    fn apply_questions(
        &mut self,
        model: &M,
        sources: &Sources<M>,
        applied: &mut usize,
        remaining: &mut usize,
    ) -> Result<(), crate::Error> {
        let mut binding_error = self
            .tail
            .apply_questions(model, sources, applied, remaining)
            .err();
        if A::READERS
            && let Err(error) = self.refresh_self(model, sources, Change::Dependencies)
            && binding_error.is_none()
        {
            binding_error = Some(error);
        }
        if *remaining != 0
            && let Some(terminal) = self.staged_terminal.take()
        {
            *remaining -= 1;
            // The staged terminal seals this response across ordinary callbacks.
            // Take only now, before retiring the physical credit.
            if let Some(message) = self.controller.take() {
                let own = self.apply_response(message, model, sources, applied).err();
                if binding_error.is_none() {
                    binding_error = own;
                }
            }
            let ticket = self
                .running_ticket
                .take()
                .expect("terminal belongs to one launched cap");
            self.start.as_mut().expect("live question").retire();
            self.controller.retire();
            if ticket.get() == self.ticket && matches!(self.state, State::Pending(_)) {
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
        // A checked binding rejection must still retire the physical lease.
        // Otherwise its already-staged terminal would have no next wake.
        if let Some(error) = binding_error {
            return Err(error);
        }
        Ok(())
    }
    fn cancel_questions(&mut self) -> Self::Retired {
        // Relinquish the owner lease before running input/result destructors.
        // A still-running physical cap owns any deferred response reclamation.
        let response = self.controller.close();
        if let Some(start) = &mut self.start {
            start.cancel();
            start.retire();
        }
        RetiredQuestion {
            _response: response,
            _tail: self.tail.cancel_questions(),
        }
    }
    fn clear(&mut self) {
        self.staged_terminal = None;
        self.pending = None;
        self.state = State::Empty;
        self.freeze.take();
        self.start.take();
        self.tail.clear();
    }
    fn start_questions(&mut self) -> bool {
        let own = self.start_pending();
        self.tail.start_questions() || own
    }
    #[cfg(feature = "native-core")]
    fn attach(&mut self, wake: &gpui_reactivity_host::native::Wake) {
        let _ = self.control().wake.set(wake.clone());
        linear_mailbox::Context::notify(self.control());
        self.tail.attach(wake);
    }
}

/// A concrete question chain; no independent scope or per-producer box.
#[doc(hidden)]
pub struct QuestionSet<Q, L> {
    lanes: Q,
    tail: L,
    cursor: usize,
}
impl<Q: ReaderValues, L: ReaderValues> ReaderValues for QuestionSet<Q, L> {
    fn read(&self, key: ReaderKey) -> Option<Outcome<'_>> {
        self.lanes.read(key).or_else(|| self.tail.read(key))
    }
    fn visit_inputs(&self, key: ReaderKey, visit: &mut impl FnMut(QuestionInput)) -> bool {
        self.lanes.visit_inputs(key, visit) || self.tail.visit_inputs(key, visit)
    }
}
impl<Q, L> sealed::Sealed for QuestionSet<Q, L> {}
impl<M, Q: LaneSet<M>, L: LaneSet<M>> LaneSet<M> for QuestionSet<Q, L> {
    const EMPTY: bool = false;
    const QUESTIONS: bool = true;
    const FIELD_EDITS: bool = Q::FIELD_EDITS || L::FIELD_EDITS;
    type Retired = (Q::Retired, L::Retired);
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
    fn staged(&self) -> usize {
        self.lanes.staged() + self.tail.staged()
    }
    fn apply(
        &mut self,
        model: &mut M,
        sources: &Sources<M>,
        applied: &mut usize,
        exact: &mut crate::remote::SourceEdits,
        remaining: &mut usize,
    ) -> Result<(), crate::Error> {
        self.lanes
            .apply(model, sources, applied, exact, remaining)?;
        self.tail.apply(model, sources, applied, exact, remaining)
    }
    fn validate(&self, model: &M, sources: &Sources<M>) -> Result<(), crate::Error> {
        self.lanes.validate(model, sources)?;
        self.tail.validate(model, sources)
    }
    fn refresh(
        &mut self,
        model: &M,
        sources: &Sources<M>,
        change: Change<'_>,
    ) -> Result<bool, crate::Error> {
        let a = self.lanes.refresh(model, sources, change)?;
        Ok(self.tail.refresh(model, sources, change)? || a)
    }
    fn apply_questions(
        &mut self,
        model: &M,
        sources: &Sources<M>,
        applied: &mut usize,
        remaining: &mut usize,
    ) -> Result<(), crate::Error> {
        let own = self
            .lanes
            .apply_questions(model, sources, applied, remaining);
        let tail = self
            .tail
            .apply_questions(model, sources, applied, remaining);
        own.and(tail)
    }
    fn cancel_questions(&mut self) -> Self::Retired {
        // Each inline owner closes before its task callbacks. Those callbacks
        // can queue work, but cannot reborrow this exclusive chain to admit it.
        // Retained responses remain deferred until all lanes are cancelled.
        (self.lanes.cancel_questions(), self.tail.cancel_questions())
    }
    fn clear(&mut self) {
        self.lanes.clear();
        self.tail.clear();
    }
    fn start_questions(&mut self) -> bool {
        let own = self.lanes.start_questions();
        self.tail.start_questions() || own
    }
    #[cfg(feature = "native-core")]
    fn attach(&mut self, wake: &gpui_reactivity_host::native::Wake) {
        self.lanes.attach(wake);
        self.tail.attach(wake);
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::Source;
    use std::convert::Infallible;
    struct Model {
        value: crate::Signal<u32>,
        other: crate::Signal<u32>,
    }
    const VALUE: Source<Model, u32> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    #[test]
    fn close_and_natural_drop_release_owner_lease_before_synchronous_task_cancellation() {
        use std::{
            pin::Pin,
            sync::{Weak, atomic::AtomicUsize},
            task::{Context, Poll},
        };
        struct Task(Option<Pin<Box<dyn Future<Output = ()> + Send>>>);
        impl QuestionTask for Task {
            fn cancel(&mut self) {
                self.0.take();
            }
        }
        struct Executor;
        impl QuestionExecutor for Executor {
            type Task = Task;
            fn spawn<F: Future<Output = ()> + Send + 'static>(
                &mut self,
                future: F,
            ) -> Result<Task, StartError> {
                Ok(Task(Some(Box::pin(future))))
            }
        }
        struct CheckDrop {
            controller: Weak<Controller<u32, Infallible>>,
            drops: Arc<AtomicUsize>,
        }
        impl Future for CheckDrop {
            type Output = Result<u32, Infallible>;
            fn poll(self: Pin<&mut Self>, _: &mut Context<'_>) -> Poll<Self::Output> {
                Poll::Pending
            }
        }
        impl Drop for CheckDrop {
            fn drop(&mut self) {
                assert_eq!(
                    self.controller.strong_count(),
                    1,
                    "only physical Completion retains the response lease"
                );
                self.drops.fetch_add(1, Ordering::SeqCst);
            }
        }
        for close in [false, true] {
            let controller = Arc::new(std::sync::Mutex::new(
                None::<Weak<Controller<u32, Infallible>>>,
            ));
            let capture = controller.clone();
            let drops = Arc::new(AtomicUsize::new(0));
            let observed = drops.clone();
            let (mut plan, _) = Questions::new()
                .question_future(
                    VALUE,
                    |v| *v,
                    Executor,
                    move |_| CheckDrop {
                        controller: capture.lock().unwrap().as_ref().unwrap().clone(),
                        drops: observed.clone(),
                    },
                )
                .unwrap();
            *controller.lock().unwrap() =
                Some(Arc::downgrade(plan.lanes.controller.shared_for_test()));
            let model = Model {
                value: crate::Signal::new(1),
                other: crate::Signal::new(2),
            };
            let sources = Sources::new().direct(VALUE);
            plan.lanes
                .refresh_self(&model, &sources, Change::Mount)
                .unwrap();
            plan.lanes.start_pending();
            if close {
                plan.lanes.close();
            }
            drop(plan);
            assert_eq!(drops.load(Ordering::SeqCst), 1);
        }
    }
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
    fn exhaustion_stays_terminal_after_counters_reset_rebinding_and_another_fault() {
        for exhaust_policy in [false, true] {
            let (mut plan, reader) = Questions::new()
                .question(
                    VALUE,
                    |v| *v,
                    |_, cap: Completion<u32, Infallible>| {
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
            let change = if exhaust_policy {
                plan.lanes.policy = u64::MAX;
                Change::Retry(reader.key)
            } else {
                plan.lanes.coarse = u64::MAX;
                Change::Source(None)
            };
            assert!(plan.lanes.refresh_self(&model, &sources, change).is_err());
            plan.lanes.coarse = 0;
            plan.lanes.policy = 0;
            plan.lanes.inputs =
                Source::new(FieldId::new(1), "value", |m| &m.other, |m| &mut m.other);
            assert!(
                plan.lanes
                    .refresh_self(&model, &sources, Change::Mount)
                    .is_err()
            );
            plan.lanes.inputs = VALUE;
            plan.lanes.fault(QuestionFault::ExecutorPanicked);
            assert!(matches!(
                plan.lanes
                    .refresh_self(&model, &sources, Change::Retry(reader.key)),
                Err(crate::Error::Question(QuestionFault::Exhausted))
            ));
            assert!(plan.lanes.pending.is_none());
            assert_eq!(plan.lanes.control().current.load(Ordering::Acquire), 0);
            assert_eq!(plan.lanes.stats.dispatched, 0);
            assert!(matches!(
                plan.lanes.read(reader.key).unwrap().failure,
                Some(Failure::Framework(QuestionFault::Exhausted))
            ));
        }
    }
    #[test]
    fn the_maximum_ticket_is_admissible_then_exhaustion_never_recycles_it() {
        let (send, jobs) = std::sync::mpsc::channel();
        let (mut plan, reader) = Questions::new()
            .question(
                VALUE,
                |v| *v,
                move |input, cap: Completion<u32, Infallible>| {
                    send.send((input, cap)).unwrap();
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
        let old = jobs.recv().unwrap().1;
        plan.lanes.ticket = u64::MAX - 1;
        *model.value = 9;
        plan.lanes
            .refresh_self(&model, &sources, Change::Source(None))
            .unwrap();
        assert_eq!(
            plan.lanes.control().current.load(Ordering::Acquire),
            u64::MAX
        );
        old.complete(Ok(1)).unwrap();
        assert!(matches!(plan.lanes.stage(0), Stage::Ready));
        plan.lanes
            .apply_questions(&model, &sources, &mut 0, &mut 1)
            .unwrap();
        let (input, last) = jobs.recv().unwrap();
        assert_eq!(input, 9);
        assert!(
            !last.is_cancelled(),
            "old retirement must preserve the last valid token"
        );
        last.complete(Ok(9)).unwrap();
        assert!(matches!(plan.lanes.stage(0), Stage::Ready));
        plan.lanes
            .apply_questions(&model, &sources, &mut 0, &mut 1)
            .unwrap();
        let outcome = plan.lanes.read(reader.key).unwrap();
        assert_eq!(outcome.info.status, QuestionStatus::Ready);
        assert_eq!(outcome.info.ticket, u64::MAX);
        assert_eq!(plan.lanes.control().current.load(Ordering::Acquire), 0);
        assert!(
            plan.lanes
                .refresh_self(&model, &sources, Change::Retry(reader.key))
                .is_err()
        );
        plan.lanes.ticket = 0;
        plan.lanes.fault(QuestionFault::InputUnavailable);
        assert!(
            plan.lanes
                .refresh_self(&model, &sources, Change::Mount)
                .is_err()
        );
        let outcome = plan.lanes.read(reader.key).unwrap();
        assert_eq!(outcome.info.status, QuestionStatus::Fault);
        assert!(matches!(
            outcome.failure,
            Some(Failure::Framework(QuestionFault::Exhausted))
        ));
        assert_eq!(outcome.value.unwrap().downcast_ref::<u32>(), Some(&9));
        assert!(plan.lanes.pending.is_none());
        assert_eq!(plan.lanes.stats.dispatched, 2);
    }
    #[test]
    fn binding_rejection_retires_a_stale_staged_terminal_before_returning_error() {
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
        let mut model = Model {
            value: crate::Signal::new(1),
            other: crate::Signal::new(2),
        };
        let sources = Sources::new().direct(VALUE);
        plan.lanes
            .refresh_self(&model, &sources, Change::Mount)
            .unwrap();
        plan.lanes.start_pending();
        *model.value = 3;
        plan.lanes
            .refresh_self(&model, &sources, Change::Source(Some(FieldId::new(1))))
            .unwrap();
        assert_eq!(plan.lanes.control().current.load(Ordering::Acquire), 2);
        jobs.recv().unwrap().1.complete(Ok(1)).unwrap();
        assert!(matches!(plan.lanes.stage(0), Stage::Ready));
        // Simulate a checked projection mismatch without invoking unsafe code or
        // constructing a forged request ticket. No rejected value is admitted.
        plan.lanes.inputs = Source::new(FieldId::new(1), "value", |m| &m.other, |m| &mut m.other);
        assert!(
            plan.lanes
                .apply_questions(&model, &sources, &mut 0, &mut 1)
                .is_err()
        );
        assert!(plan.lanes.running_ticket.is_none());
        assert!(
            plan.lanes.version.is_none(),
            "rejected binding must not fabricate a diagnostic pack"
        );
        assert!(plan.lanes.controller.idle());
        assert!(plan.lanes.pending.is_none());
        assert_eq!(plan.lanes.control().current.load(Ordering::Acquire), 0);
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
            .apply_questions(&model, &sources, &mut 0, &mut 1)
            .unwrap();
        assert_eq!(
            plan.lanes.read(reader.key).unwrap().info.status,
            QuestionStatus::Fault
        );
        assert!(plan.lanes.controller.idle());
        plan.lanes
            .refresh_self(&model, &sources, Change::Retry(reader.key))
            .unwrap();
        jobs.recv().unwrap().complete(Ok(3)).unwrap();
        assert!(matches!(plan.lanes.stage(0), Stage::Ready));
        plan.lanes
            .apply_questions(&model, &sources, &mut 0, &mut 1)
            .unwrap();
        assert_eq!(
            plan.lanes.read(reader.key).unwrap().info.status,
            QuestionStatus::Ready
        );
    }
    #[test]
    fn input_family_owner_record_ledger() {
        println!(
            "owner_record,State_u64_infallible={},Work_u64={},Source_version={},Reader_version={},QuestionInfo={}",
            size_of::<State<u64, Infallible>>(),
            size_of::<Work<u64>>(),
            size_of::<Option<Revision>>(),
            size_of::<Option<super::inputs::ReaderVersion>>(),
            size_of::<QuestionInfo>()
        );
    }
}

#[cfg(test)]
#[test]
fn change_layout_ledger() {
    eprintln!(
        "CHANGE_LAYOUT,change_bytes={},source_edits_bytes={}",
        std::mem::size_of::<Change<'_>>(),
        std::mem::size_of::<crate::remote::SourceEdits>()
    );
}
