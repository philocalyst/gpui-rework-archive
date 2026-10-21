//! A typed, inert read key. Question state belongs to the window's static lane
//! chain; workers carry owned input and a linear completion, never an owner borrow.
use crate::{El, Remote, SendError};
use gpui_reactivity_state::{RequestStamp, Revision};
use std::{
    any::Any,
    fmt,
    marker::PhantomData,
    num::NonZeroU64,
    panic::{AssertUnwindSafe, catch_unwind},
    sync::{
        Arc,
        atomic::{AtomicU8, AtomicU64, Ordering},
    },
};

pub(crate) mod question;
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
    QueueFull,
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
    pub input: Option<InputVersion>,
    pub completion_leased: bool,
    pub stats: QuestionStats,
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
    pub version: InputVersion,
    pub value: Result<T, E>,
}

// Exactly one physical completion lease exists per question. The owner does
// not reuse its immutable local launched ticket until acquiring a terminal
// state. The unique cap is the sole Running -> terminal writer; after publish
// it cannot touch this lease again. Queued messages carry independent stamps.
const IDLE: u8 = 0;
const RUNNING: u8 = 1;
const DELIVERED: u8 = 2;
const ABANDONED: u8 = 3;
const FULL: u8 = 4;
const PANICKED: u8 = 5;
pub(crate) struct Controller<T, E> {
    remote: Remote<Message<T, E>>,
    state: AtomicU8,
    current: AtomicU64,
}
impl<T, E> Controller<T, E> {
    fn terminal(&self, state: u8) {
        self.state.store(state, Ordering::Release);
        // Sending the result can wake before this release. Wake again so a UI
        // turn which observed Running cannot strand newly returned credit.
        self.remote.signal();
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
    version: InputVersion,
}
pub enum CompleteError<T, E> {
    Full(Result<T, E>),
    Closed(Result<T, E>),
}
impl<T, E> CompleteError<T, E> {
    pub fn into_value(self) -> Result<T, E> {
        match self {
            Self::Full(value) | Self::Closed(value) => value,
        }
    }
}
impl<T, E> fmt::Debug for CompleteError<T, E> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(match self {
            Self::Full(_) => "Full(outcome)",
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
            version: self.version,
            value,
        };
        match controller.remote.try_send(message) {
            Ok(()) => {
                controller.terminal(DELIVERED);
                Ok(())
            }
            Err(SendError::Full(message)) => {
                controller.terminal(FULL);
                Err(CompleteError::Full(message.value))
            }
            Err(SendError::Closed(message)) => {
                controller.terminal(DELIVERED);
                Err(CompleteError::Closed(message.value))
            }
        }
    }
    /// Execute on an existing worker. The owner must only enqueue this work;
    /// this helper catches a worker panic separately from a domain error E.
    pub fn run<I>(
        mut self,
        input: I,
        compute: impl FnOnce(I) -> Result<T, E>,
    ) -> Result<(), CompleteError<T, E>> {
        if self.is_cancelled() {
            return Ok(());
        }
        match catch_unwind(AssertUnwindSafe(|| compute(input))) {
            Ok(value) => self.complete(value),
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
    use gpui_reactivity_state::OwnerRegistry;
    use std::convert::Infallible;

    struct Capability {
        completion: Completion<String, Infallible>,
        inbox: crate::Inbox<Message<String, Infallible>>,
        control: Arc<Controller<String, Infallible>>,
        _scope: gpui_reactivity_state::OwnerScope,
    }
    fn capability() -> Capability {
        let mut scope = OwnerRegistry::new().mount().unwrap();
        let mut gate = scope.producer(1).unwrap();
        let stamp = gate.begin().unwrap();
        let version = InputVersion {
            field: crate::FieldId::new(1),
            revision: crate::Signal::new(0).revision(),
            coarse: 0,
            policy: 0,
        };
        let (remote, inbox) = Remote::bounded(1);
        let control = Arc::new(Controller {
            remote,
            state: AtomicU8::new(RUNNING),
            current: AtomicU64::new(stamp.ticket()),
        });
        Capability {
            completion: Completion {
                controller: Some(control.clone()),
                stamp: Some(stamp),
                version,
            },
            inbox,
            control,
            _scope: scope,
        }
    }
    #[test]
    fn full_and_closed_keep_the_same_owned_result_and_publish_terminal_once() {
        let Capability {
            completion,
            mut inbox,
            control,
            _scope,
        } = capability();
        let payload = String::from("current result payload");
        let pointer = payload.as_ptr();
        // Defensive Full fixture: the public linear-cap/one-credit path cannot
        // duplicate a result, so inject an unrelated older message internally.
        let mut other_scope = OwnerRegistry::new().mount().unwrap();
        let stamp = other_scope.producer(9).unwrap().begin().unwrap();
        control
            .remote
            .try_send(Message {
                stamp,
                version: completion.version,
                value: Ok("old".into()),
            })
            .unwrap();
        let returned = match completion.complete(Ok(payload)) {
            Err(CompleteError::Full(value)) => value.unwrap(),
            _ => panic!("full"),
        };
        assert_eq!(returned.as_ptr(), pointer);
        assert_eq!(control.state.load(Ordering::Acquire), FULL);
        inbox.close();
        let Capability {
            completion,
            mut inbox,
            control,
            _scope,
        } = capability();
        inbox.close();
        let payload = String::from("closed result payload");
        let pointer = payload.as_ptr();
        let returned = match completion.complete(Ok(payload)) {
            Err(CompleteError::Closed(value)) => value.unwrap(),
            _ => panic!("closed"),
        };
        assert_eq!(returned.as_ptr(), pointer);
        assert_eq!(control.state.load(Ordering::Acquire), DELIVERED);
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
