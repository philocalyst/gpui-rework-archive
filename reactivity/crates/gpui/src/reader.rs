//! A typed, inert read key. Question state belongs to the window's static lane
//! chain; workers carry owned input and a linear completion, never an owner borrow.
use crate::El;
use gpui_reactivity_state::{RequestStamp, Revision};
use std::{
    any::Any,
    fmt,
    marker::PhantomData,
    num::NonZeroU64,
    panic::{AssertUnwindSafe, catch_unwind},
    sync::{
        Arc,
        atomic::{AtomicU64, Ordering},
    },
};

mod future;
mod inputs;
// The private response handoff is checked independently with Loom and Miri.
#[allow(unsafe_code)]
mod linear_mailbox;
pub use future::{QuestionExecutor, QuestionTask};
pub use inputs::QuestionInputs;
pub(crate) mod question;
mod sync {
    pub(super) use std::sync::atomic;

    // Loom supplies this same interface with tracked cell-borrow lifetimes.
    pub(super) struct Cell<T>(std::cell::UnsafeCell<T>);
    impl<T> Cell<T> {
        pub(super) fn new(value: T) -> Self {
            Self(std::cell::UnsafeCell::new(value))
        }
        pub(super) fn with_mut<R>(&self, visit: impl FnOnce(*mut T) -> R) -> R {
            visit(self.0.get())
        }
        pub(super) fn into_inner(self) -> T {
            self.0.into_inner()
        }
    }
}
use linear_mailbox::Mailbox;
pub use question::{QuestionSet, Questions};

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ReaderKey {
    namespace: NonZeroU64,
    site: NonZeroU64,
}

/// Copying this key does not read, borrow, start or own its producer. Forward it
/// through ordinary functions, then use `project` where the result is displayed.
/// A Reader deliberately has no Deref, blocking read, or fallback reference.
///
/// ```compile_fail
/// use gpui::Reader;
/// fn cannot_read(reader: Reader<String>) -> usize { reader.len() }
/// ```
pub struct Reader<T> {
    pub(crate) key: ReaderKey,
    marker: PhantomData<fn() -> T>,
}
impl<T> Copy for Reader<T> {}
impl<T> Clone for Reader<T> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<T> fmt::Debug for Reader<T> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_tuple("Reader").field(&self.key).finish()
    }
}
impl<T: 'static> Reader<T> {
    /// The closure can return elements borrowing the ready T. Its output may
    /// not borrow a shorter-lived closure capture: put such a caption beside
    /// the projection, or format an owned caption inside it. The descriptor is
    /// consumed during ordinary description, not retained as a borrowed closure.
    ///
    /// ```compile_fail
    /// use gpui::{Reader,El,text};
    /// fn capture<'a>(reader:Reader<String>,caption:&'a str)->El<'a> {
    ///     reader.project(move |_|text(caption))
    /// }
    /// ```
    pub fn project<'a, F>(self, render: F) -> El<'a>
    where
        F: for<'v> Fn(&'v T) -> El<'v> + 'a,
    {
        El::reader(Box::new(Projection {
            reader: self,
            render,
            loading: || crate::text("Loading…"),
            failed: |failure| crate::text(format!("Question failed: {failure}")),
        }))
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum StartError {
    Busy,
    Closed,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum QuestionFault {
    Revoked,
    Abandoned,
    WorkerPanicked,
    ExecutorPanicked,
    InputUnavailable,
    StartRejected(StartError),
    Exhausted,
}
impl fmt::Display for QuestionFault {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{self:?}")
    }
}
impl std::error::Error for QuestionFault {}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum QuestionStatus {
    Empty,
    Pending,
    Ready,
    Fault,
}
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct QuestionStats {
    pub frozen: u64,
    pub dispatched: u64,
    pub accepted: u64,
    pub stale_results: u64,
    pub superseded: u64,
    pub framework_faults: u64,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct QuestionInfo {
    pub status: QuestionStatus,
    pub ticket: u64,
    /// Present only for a single Source input. Use visit_question_inputs for
    /// the complete diagnostic family of paired or Reader dependencies.
    pub input: Option<InputVersion>,
    pub completion_leased: bool,
    pub stats: QuestionStats,
}
/// One member of the complete declared input family, in declaration order.
/// These records describe the owner's observed cohort, not worker authority.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum QuestionInput {
    Source(InputVersion),
    Reader {
        key: ReaderKey,
        ticket: u64,
        status: QuestionStatus,
    },
}

#[derive(Clone, Copy, Debug)]
pub enum Failure<'a> {
    Domain(&'a (dyn std::error::Error + 'static)),
    Framework(QuestionFault),
}
impl fmt::Display for Failure<'_> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Domain(error) => fmt::Display::fmt(error, f),
            Self::Framework(error) => fmt::Display::fmt(error, f),
        }
    }
}

#[doc(hidden)]
pub struct Outcome<'a> {
    pub(crate) info: QuestionInfo,
    pub(crate) value: Option<&'a dyn Any>,
    pub(crate) failure: Option<Failure<'a>>,
}
/// Borrowed heterogeneous description seam. Values remain in concrete typed
/// question slots; this does not own or box a result, future or producer.
#[doc(hidden)]
pub trait ReaderValues {
    fn read(&self, key: ReaderKey) -> Option<Outcome<'_>>;
    fn visit_inputs(&self, _key: ReaderKey, _visit: &mut impl FnMut(QuestionInput)) -> bool
    where
        Self: Sized,
    {
        false
    }
}
impl ReaderValues for () {
    fn read(&self, _: ReaderKey) -> Option<Outcome<'_>> {
        None
    }
}

pub(crate) trait Projector {
    fn render<'a>(&self, values: &'a dyn ReaderValues) -> El<'a>;
    fn loading(&mut self, render: fn() -> El<'static>);
    fn failed(&mut self, render: for<'a> fn(Failure<'a>) -> El<'a>);
}
struct Projection<T, F> {
    reader: Reader<T>,
    render: F,
    loading: fn() -> El<'static>,
    failed: for<'a> fn(Failure<'a>) -> El<'a>,
}
impl<T: 'static, F: for<'a> Fn(&'a T) -> El<'a>> Projector for Projection<T, F> {
    fn render<'a>(&self, values: &'a dyn ReaderValues) -> El<'a> {
        let Some(outcome) = values.read(self.reader.key) else {
            return crate::column((crate::text("Question revoked"), crate::div().h(0)));
        };
        let value = outcome.value.and_then(|value| value.downcast_ref::<T>());
        // Keep the ready region at one stable child position while its status
        // chrome changes. A Pending-only wrapper would remount live controls.
        let content = value.map(&self.render).unwrap_or_else(|| crate::div().h(0));
        let chrome = match (outcome.info.status, value.is_some(), outcome.failure) {
            (QuestionStatus::Ready, true, _) => crate::div().h(0),
            (QuestionStatus::Pending, true, _) => crate::text("Updating…"),
            (QuestionStatus::Fault, _, Some(error)) => (self.failed)(error),
            (QuestionStatus::Empty | QuestionStatus::Pending, false, _) => (self.loading)(),
            _ => crate::text("Question unavailable"),
        };
        crate::column((chrome, content))
    }
    fn loading(&mut self, render: fn() -> El<'static>) {
        self.loading = render;
    }
    fn failed(&mut self, render: for<'a> fn(Failure<'a>) -> El<'a>) {
        self.failed = render;
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct InputVersion {
    pub(crate) field: crate::FieldId,
    pub(crate) revision: Revision,
    pub(crate) coarse: u64,
    pub(crate) policy: u64,
}
impl InputVersion {
    pub fn source(self) -> crate::FieldId {
        self.field
    }
    pub fn revision(self) -> u32 {
        self.revision.get()
    }
    pub fn coarse_epoch(self) -> u64 {
        self.coarse
    }
    pub fn policy_generation(self) -> u64 {
        self.policy
    }
}
pub(crate) struct Message<T, E> {
    pub stamp: RequestStamp,
    pub value: Result<T, E>,
}

// Exactly one physical completion lease exists per question. The owner does
// not reuse its immutable local launched ticket until acquiring a terminal
// state. The unique cap is the sole Running -> terminal writer; after publish
// it cannot touch this lease again. Queued messages carry independent stamps.
const ABANDONED: u8 = 3;
const PANICKED: u8 = 5;
pub(crate) struct Controller<T, E> {
    mailbox: Mailbox<Message<T, E>>,
    current: AtomicU64,
    #[cfg(feature = "native-core")]
    wake: std::sync::OnceLock<gpui_reactivity_host::native::Wake>,
}
impl<T, E> Controller<T, E> {
    fn new() -> Self {
        Self {
            mailbox: Mailbox::new(),
            current: AtomicU64::new(0),
            #[cfg(feature = "native-core")]
            wake: std::sync::OnceLock::new(),
        }
    }
    fn signal(&self) {
        #[cfg(feature = "native-core")]
        if let Some(wake) = self.wake.get() {
            wake.signal();
        }
    }
    fn terminal(&self, state: u8) {
        self.mailbox.finish(state, || self.signal());
    }
}

/// One owned response authority. It cannot be cloned. Dropping it without an
/// answer publishes Abandoned, so a canceled executor does not leave Pending.
/// `complete` transfers a result only into bounded ingress, never into a model.
///
/// ```compile_fail
/// use gpui::Completion;
/// fn duplicate(cap:Completion<String,std::convert::Infallible>) {
///     let _second=cap.clone();
/// }
/// ```
pub struct Completion<T, E> {
    controller: Option<Arc<Controller<T, E>>>,
    stamp: Option<RequestStamp>,
}

/// Borrowed cancellation hint for one physical completion. This grants no UI
/// access and owns no lease; only normal owner admission can accept a result.
/// A worker may poll it while computing without cloning a controller Arc.
pub struct Cancellation<'a> {
    current: &'a AtomicU64,
    ticket: u64,
}
impl Cancellation<'_> {
    #[inline]
    pub fn is_cancelled(&self) -> bool {
        self.current.load(Ordering::Acquire) != self.ticket
    }
}
pub enum CompleteError<T, E> {
    Closed(Result<T, E>),
}
impl<T, E> CompleteError<T, E> {
    pub fn into_value(self) -> Result<T, E> {
        match self {
            Self::Closed(value) => value,
        }
    }
}
impl<T, E> fmt::Debug for CompleteError<T, E> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(match self {
            Self::Closed(_) => "Closed(outcome)",
        })
    }
}
impl<T, E> Completion<T, E> {
    /// A hint for cooperative worker cancellation; only owner admission decides
    /// whether the owned result is still applicable.
    pub fn is_cancelled(&self) -> bool {
        self.controller.as_ref().is_none_or(|controller| {
            controller.current.load(Ordering::Acquire) != self.stamp.as_ref().unwrap().ticket()
        })
    }
    pub fn complete(mut self, value: Result<T, E>) -> Result<(), CompleteError<T, E>> {
        let controller = self.controller.take().expect("completion is linear");
        let message = Message {
            stamp: self.stamp.take().unwrap(),
            value,
        };
        controller
            .mailbox
            .complete(message, || controller.signal())
            .map_err(|message| CompleteError::Closed(message.value))
    }

    /// Execute on an existing worker. The owner must only enqueue this work;
    /// this helper catches a worker panic separately from a domain error E.
    pub fn run<I>(
        self,
        input: I,
        compute: impl FnOnce(I) -> Result<T, E>,
    ) -> Result<(), CompleteError<T, E>> {
        self.run_cancellable(input, |input, _| Some(compute(input)))
    }

    /// Execute on an existing worker with a scoped cancellation hint. Return
    /// None to abandon this physical completion without constructing an answer.
    /// A current abandoned request becomes Fault; a superseded one only frees
    /// credit for the newest pending input. Cancellation remains advisory: the
    /// owner validates every returned answer even after the final check.
    ///
    /// ```compile_fail
    /// use gpui::{Cancellation, Completion};
    /// fn escape(cap: Completion<(), std::convert::Infallible>) -> Cancellation<'static> {
    ///     let mut saved = None;
    ///     cap.run_cancellable((), |_, cancellation| { saved = Some(cancellation); None }).unwrap();
    ///     saved.unwrap()
    /// }
    /// ```
    /// ```compile_fail
    /// use gpui::Completion;
    /// fn detached(cap: Completion<(), std::convert::Infallible>) {
    ///     cap.run_cancellable((), |_, cancellation| {
    ///         std::thread::spawn(move || cancellation.is_cancelled());
    ///         None
    ///     }).unwrap();
    /// }
    /// ```
    pub fn run_cancellable<I>(
        mut self,
        input: I,
        compute: impl FnOnce(I, Cancellation<'_>) -> Option<Result<T, E>>,
    ) -> Result<(), CompleteError<T, E>> {
        if self.is_cancelled() {
            return Ok(());
        }
        match catch_unwind(AssertUnwindSafe(|| {
            compute(
                input,
                Cancellation {
                    current: &self.controller.as_ref().unwrap().current,
                    ticket: self.stamp.as_ref().unwrap().ticket(),
                },
            )
        })) {
            Ok(Some(value)) => self.complete(value),
            Ok(None) => Ok(()),
            Err(_) => {
                let controller = self.controller.take().unwrap();
                self.stamp.take();
                controller.terminal(PANICKED);
                Ok(())
            }
        }
    }
}
impl<T, E> Drop for Completion<T, E> {
    fn drop(&mut self) {
        if let Some(controller) = self.controller.take() {
            self.stamp.take();
            controller.terminal(ABANDONED);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::convert::Infallible;
    use std::sync::atomic::AtomicUsize;

    #[test]
    fn cancellation_borrows_the_existing_lease_without_allocating_or_cloning_it() {
        let mut scope = gpui_reactivity_state::OwnerRegistry::new().mount().unwrap();
        let stamp = scope.producer(1).unwrap().begin().unwrap();
        let controller = Arc::new(Controller::new());
        controller.mailbox.begin();
        controller.current.store(stamp.ticket(), Ordering::Release);
        let cap = Completion::<u64, Infallible> {
            controller: Some(controller.clone()),
            stamp: Some(stamp),
        };
        let memory = allocation_counter::measure(|| {
            cap.run_cancellable((), |_, cancellation| {
                assert_eq!(Arc::strong_count(&controller), 2);
                assert!(!cancellation.is_cancelled());
                controller.current.store(0, Ordering::Release);
                assert!(cancellation.is_cancelled());
                None
            })
            .unwrap();
        });
        assert_eq!(memory.count_total, 0);
        assert_eq!(Arc::strong_count(&controller), 1);
        assert_eq!(controller.mailbox.freeze(), Some(ABANDONED));
        assert!(controller.mailbox.take().is_none());
        println!(
            "borrowed_cancellation_bytes={},allocations={},controller_leases_during_compute=2",
            size_of::<Cancellation<'_>>(),
            memory.count_total,
        );
    }

    #[test]
    fn closed_completion_returns_the_same_owned_result() {
        let mut scope = gpui_reactivity_state::OwnerRegistry::new().mount().unwrap();
        let stamp = scope.producer(1).unwrap().begin().unwrap();
        let controller = Arc::new(Controller::new());
        controller.mailbox.begin();
        controller.current.store(stamp.ticket(), Ordering::Release);
        let cap = Completion::<String, Infallible> {
            controller: Some(controller.clone()),
            stamp: Some(stamp),
        };
        controller.current.store(0, Ordering::Release);
        controller.mailbox.close();
        assert!(cap.is_cancelled());
        let value = String::from("retain exact allocation");
        let pointer = value.as_ptr();
        let value = cap.complete(Ok(value)).unwrap_err().into_value().unwrap();
        assert_eq!(value.as_ptr(), pointer);
    }

    #[test]
    fn close_and_notify_do_not_hold_the_lock_during_user_drop_or_panic() {
        struct Probe {
            mailbox: Arc<Mailbox<Probe>>,
            drops: Arc<AtomicUsize>,
            panic: bool,
        }
        impl Drop for Probe {
            fn drop(&mut self) {
                assert!(self.mailbox.unlocked());
                self.drops.fetch_add(1, Ordering::SeqCst);
                assert!(!self.panic, "payload drop panic outside mailbox mutex");
            }
        }
        for panic in [false, true] {
            let mailbox = Arc::new(Mailbox::new());
            mailbox.begin();
            let drops = Arc::new(AtomicUsize::new(0));
            let probe = Probe {
                mailbox: mailbox.clone(),
                drops: drops.clone(),
                panic,
            };
            assert!(
                mailbox
                    .complete(probe, || assert!(mailbox.unlocked()))
                    .is_ok()
            );
            mailbox.freeze().unwrap();
            let value = mailbox.take();
            mailbox.retire();
            mailbox.close();
            let result = catch_unwind(AssertUnwindSafe(|| drop(value)));
            assert_eq!(result.is_err(), panic);
            assert!(mailbox.unlocked());
            mailbox.close();
            assert_eq!(drops.load(Ordering::SeqCst), 1);
        }
    }

    #[test]
    fn input_family_storage_and_allocation_ledger() {
        struct Model {
            a: crate::Signal<u64>,
            b: crate::Signal<u64>,
        }
        const A: crate::Source<Model, u64> =
            crate::Source::new(crate::FieldId::new(1), "a", |m| &m.a, |m| &mut m.a);
        const B: crate::Source<Model, u64> =
            crate::Source::new(crate::FieldId::new(2), "b", |m| &m.b, |m| &mut m.b);
        fn report<A: QuestionInputs<Model>>(name: &str, inputs: A) {
            let mut built = None;
            let allocations = allocation_counter::measure(|| {
                built = Some(
                    Questions::new()
                        .question(
                            inputs,
                            |_| 0u64,
                            |_, cap: Completion<u64, Infallible>| {
                                drop(cap);
                                Ok(())
                            },
                        )
                        .unwrap(),
                );
            });
            let (plan, _) = built.unwrap();
            println!(
                "family={name},plan={},inputs={},versions={},optional_versions={},allocations={},requested={}",
                size_of_val(&plan),
                size_of::<A>(),
                size_of::<A::Versions>(),
                size_of::<Option<A::Versions>>(),
                allocations.count_total,
                allocations.bytes_total
            );
            assert_eq!(allocations.count_total, 2);
        }
        report("one_source", A);
        report("two_sources", (A, B));
        report("three_nested", ((A, B), A));
        let (plan, reader) = Questions::new()
            .question(
                A,
                |n| *n,
                |_, cap: Completion<u64, Infallible>| {
                    drop(cap);
                    Ok(())
                },
            )
            .unwrap();
        let mut dependent = None;
        let allocations = allocation_counter::measure(|| {
            dependent = Some(
                plan.question(
                    (reader, B),
                    |(a, b)| *a + *b,
                    |_, cap: Completion<u64, Infallible>| {
                        drop(cap);
                        Ok(())
                    },
                )
                .unwrap(),
            );
        });
        let (plan, _) = dependent.unwrap();
        println!(
            "family=reader_and_source,total_plan={},incremental_allocations={},incremental_requested={},reader_versions={}",
            size_of_val(&plan),
            allocations.count_total,
            allocations.bytes_total,
            size_of::<inputs::ReaderVersion>()
        );
        assert_eq!(allocations.count_total, 1);
    }

    #[test]
    fn absent_plan_and_static_producer_projection_allocation_ledger() {
        struct Model {
            value: crate::Signal<u64>,
        }
        let source = crate::Source::new(
            crate::FieldId::new(1),
            "value",
            |m: &Model| &m.value,
            |m| &mut m.value,
        );
        let mut empty = None;
        let unused = allocation_counter::measure(|| empty = Some(Questions::<Model>::new()));
        assert_eq!(unused.count_total, 0);
        let mut built = None;
        let cold = allocation_counter::measure(|| {
            built = Some(
                empty
                    .take()
                    .unwrap()
                    .question(
                        source,
                        |value| *value,
                        |_: u64, completion: Completion<u64, Infallible>| {
                            drop(completion);
                            Ok(())
                        },
                    )
                    .unwrap(),
            );
        });
        assert_eq!(
            cold.count_total, 2,
            "one shared scope and one response controller"
        );
        let (questions, reader) = built.unwrap();
        let mut descriptor = None;
        let projection = allocation_counter::measure(|| {
            descriptor = Some(reader.project(|value| crate::text(value.to_string())))
        });
        assert_eq!(projection.count_total, 2);
        println!(
            "question_plan,allocations={},requested={},projection_allocations={},projection_requested={},Reader={},Completion={},Version={},Controller={},El={}",
            cold.count_total,
            cold.bytes_total,
            projection.count_total,
            projection.bytes_total,
            size_of::<Reader<u64>>(),
            size_of::<Completion<u64, Infallible>>(),
            size_of::<InputVersion>(),
            size_of::<Controller<u64, Infallible>>(),
            size_of::<El<'_>>()
        );
        println!("plan_bytes={}", size_of_val(&questions));
        let bound = questions.bind(());
        println!("bound_lane_bytes={}", size_of_val(&bound));
    }
}
