//! Bounded owned messages. Workers have transport capabilities, never UI access.
use crate::{
    Commit, Error,
    reader::{Outcome, ReaderKey, ReaderValues, question::Change},
    source::{FieldAction, FieldId, SourcePath, Sources},
};
#[cfg(feature = "native-core")]
use gpui_reactivity_host::native::Wake;
use parking_lot::Mutex;
#[cfg(feature = "native-core")]
use std::sync::OnceLock;
use std::{collections::VecDeque, panic::AssertUnwindSafe, sync::Arc};

// The sole payload buffer includes both the owner's frozen prefix and later
// sends. No callback or payload destructor runs while this mutex is held.
struct State<T> {
    queue: VecDeque<T>,
    capacity: usize,
    producers: usize,
    open: bool,
    observe_close: bool,
}
struct Shared<T> {
    // No user code runs under this lock; checked producer overflow leaves the
    // queue intact. Preserve the std mutex's public unwind auto-traits.
    state: AssertUnwindSafe<Mutex<State<T>>>,
    #[cfg(feature = "native-core")]
    wake: OnceLock<Wake>,
}
impl<T> Shared<T> {
    fn signal(&self) {
        #[cfg(feature = "native-core")]
        if let Some(wake) = self.wake.get() {
            wake.signal();
        }
    }
}

/// A rejected send retains the original owned payload, including its allocation.
pub enum SendError<T> {
    Full(T),
    Closed(T),
}
impl<T> SendError<T> {
    pub fn into_value(self) -> T {
        match self {
            Self::Full(value) | Self::Closed(value) => value,
        }
    }
}
impl<T> std::fmt::Debug for SendError<T> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_tuple(match self {
            Self::Full(_) => "Full",
            Self::Closed(_) => "Closed",
        })
        .field(&std::any::type_name::<T>())
        .finish()
    }
}

/// Cloneable any-thread sender for a bounded FIFO stream. Sending never invokes
/// application code. A successful send transfers ownership into the queue; it
/// does not promise delivery after the receiving owner closes or is quarantined.
/// Concurrent revocation may race an enqueue, but revoked work is never applied.
///
/// ```
/// use gpui::{El, Remote, View, Win, text};
/// #[derive(Default)]
/// struct Catalogue { results: u64 }
/// impl View for Catalogue {
///     fn view(&self) -> El<'_> { text(format!("{} results", self.results)) }
/// }
/// let (remote, inbox) = Remote::bounded(8);
/// let mut win = Win::demo(Catalogue::default())
///     .with_inbox(inbox, |model: &mut Catalogue, count: u64| model.results = count)?;
/// std::thread::spawn(move || remote.try_send(42).unwrap()).join().unwrap();
/// assert_eq!(win.root()?.results, 0); // enqueue is inert
/// let delivery = win.deliver_ready(8)?;
/// assert_eq!(delivery.applied, 1);
/// assert!(win.contains_text("42 results")?);
/// # Ok::<(), Box<dyn std::error::Error>>(())
/// ```
pub struct Remote<T> {
    shared: Arc<Shared<T>>,
}
impl<T> Clone for Remote<T> {
    fn clone(&self) -> Self {
        let mut state = self.shared.state.lock();
        state.producers = state
            .producers
            .checked_add(1)
            .expect("too many inbox producers");
        Self {
            shared: Arc::clone(&self.shared),
        }
    }
}
impl<T> Drop for Remote<T> {
    fn drop(&mut self) {
        let mut state = self.shared.state.lock();
        state.producers -= 1;
        let notify = state.producers == 0 && state.observe_close;
        drop(state);
        if notify {
            self.shared.signal();
        }
    }
}
impl<T> Remote<T> {
    /// Create an unbound lane. Sending before binding is permitted and bounded.
    /// Moving its sole Inbox into a window binds that receiver exactly once.
    /// Capacity bounds all accepted but undelivered values, including a frozen
    /// delivery remainder. Zero rejects every try_send with Full. One payload
    /// buffer is allocated here; queue operations share a mutex and can wait for
    /// its current holder. Callbacks and payload destruction run outside it.
    /// An attached native event proxy/OS may allocate separately when posting wakes.
    pub fn bounded(capacity: usize) -> (Self, Inbox<T>) {
        let shared = Arc::new(Shared {
            state: AssertUnwindSafe(Mutex::new(State {
                queue: VecDeque::with_capacity(capacity),
                capacity,
                producers: 1,
                open: true,
                observe_close: false,
            })),
            #[cfg(feature = "native-core")]
            wake: OnceLock::new(),
        });
        (
            Self {
                shared: Arc::clone(&shared),
            },
            Inbox {
                shared,
                frozen: 0,
                terminal: Terminal::Open,
            },
        )
    }
    pub fn try_send(&self, value: T) -> Result<(), SendError<T>> {
        let mut state = self.shared.state.lock();
        if !state.open {
            return Err(SendError::Closed(value));
        }
        // VecDeque's allocation capacity is not a logical bound (notably for ZSTs).
        if state.queue.len() == state.capacity {
            return Err(SendError::Full(value));
        }
        state.queue.push_back(value);
        drop(state);
        self.shared.signal();
        Ok(())
    }
}

/// The unique owned receiver. There is no public receive operation: delivery
/// enters through the ordinary production window barrier after binding.
/// ```compile_fail
/// let (_, inbox) = gpui::Remote::<u64>::bounded(8);
/// let second_receiver = inbox.clone();
/// ```
pub struct Inbox<T> {
    shared: Arc<Shared<T>>,
    frozen: usize,
    terminal: Terminal,
}
#[derive(PartialEq, Eq)]
enum Terminal {
    Open,
    Frozen,
    Delivered,
}
impl<T> Inbox<T> {
    // Return ownership without dropping values, allowing a static lane chain to
    // revoke every producer before any user destructor can unwind retirement.
    fn revoke(&mut self) -> VecDeque<T> {
        let mut state = self.shared.state.lock();
        state.open = false;
        self.frozen = 0;
        self.terminal = Terminal::Delivered;
        std::mem::take(&mut state.queue)
    }
    pub(crate) fn close(&mut self) {
        drop(self.revoke());
    }
    pub(crate) fn observe_close(&self) -> Result<(), Error> {
        let mut state = self.shared.state.lock();
        if state.capacity == 0 || !state.open {
            return Err(Error::ZeroInboxCapacity);
        }
        state.observe_close = true;
        Ok(())
    }
    pub(crate) fn stage(&mut self, observe_close: bool) -> Stage {
        if self.terminal != Terminal::Open {
            return Stage::Empty;
        }
        let state = self.shared.state.lock();
        if !state.open || state.capacity == 0 {
            return Stage::Empty;
        }
        if self.frozen == state.capacity {
            return Stage::Limited;
        }
        if self.frozen < state.queue.len() {
            self.frozen += 1;
            Stage::Ready
        } else if state.producers == 0 && observe_close {
            self.terminal = Terminal::Frozen;
            Stage::Ready
        } else {
            Stage::Empty
        }
    }
    fn pop(&mut self) -> Option<T> {
        if self.frozen == 0 {
            return None;
        }
        let mut state = self.shared.state.lock();
        self.frozen -= 1;
        state.queue.pop_front()
    }
}
impl<T> Drop for Inbox<T> {
    fn drop(&mut self) {
        self.close();
    }
}

/// One explicit delivery turn. `more` is a conservative scheduling hint: a
/// saturated batch rearms once even if its last receive emptied the queue.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Delivery {
    /// New messages frozen from the transport in this turn. `applied` may also
    /// include messages retained from a previous checked delivery failure.
    pub received: usize,
    pub applied: usize,
    pub commit: Commit,
    pub more: bool,
}
/// Normal callback returns may commit S even when presentation fails. The exact
/// commit and applied count remain available; applied messages are never replayed.
/// A panic quarantines the owner, cancels the remaining queue and promises no rollback.
#[derive(Debug)]
pub struct DeliveryError {
    pub error: Error,
    pub delivery: Option<Delivery>,
}
impl std::fmt::Display for DeliveryError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.error.fmt(f)
    }
}
impl std::error::Error for DeliveryError {}

pub(crate) mod sealed {
    pub trait Sealed {}
}
/// Transient typed edits admitted by one frozen delivery batch.
/// Overflow and opaque callbacks retain the conservative owner boundary.
#[doc(hidden)]
#[derive(Default)]
pub struct SourceEdits {
    fields: [Option<FieldId>; 4],
    coarse: bool,
}
impl SourceEdits {
    pub(crate) fn record(&mut self, field: Option<FieldId>) {
        if self.coarse {
            return;
        }
        let Some(field) = field else {
            self.coarsen();
            return;
        };
        for slot in &mut self.fields {
            if *slot == Some(field) {
                return;
            }
            if slot.is_none() {
                *slot = Some(field);
                return;
            }
        }
        self.coarsen();
    }
    pub(crate) fn coarsen(&mut self) {
        self.coarse = true;
    }
    pub(crate) fn single(&self) -> Option<FieldId> {
        if self.coarse || self.fields[1].is_some() {
            None
        } else {
            self.fields[0]
        }
    }
    pub(crate) fn question_change<M: 'static>(
        &self,
        sources: &Sources<M>,
    ) -> Result<Change<'_>, Error> {
        if let Some(fields) = self.multiple() {
            for field in fields {
                if sources.invalidates_owner(field)? {
                    return Ok(Change::Source(None));
                }
            }
            Ok(Change::Sources(&self.fields))
        } else {
            Ok(Change::Source(self.single()))
        }
    }
    pub(crate) fn multiple(&self) -> Option<impl Iterator<Item = FieldId> + Clone + '_> {
        (!self.coarse && self.fields[1].is_some()).then(|| self.fields.iter().copied().flatten())
    }
}
/// Internal static receiver chain. Applications infer this type through with_inbox.
#[doc(hidden)]
pub trait LaneSet<M>: sealed::Sealed + ReaderValues {
    const EMPTY: bool;
    const QUESTIONS: bool = false;
    // Whether any model-message handler can return an exact source identity.
    const FIELD_EDITS: bool = false;
    type Retired;
    fn count(&self) -> usize;
    fn cursor(&self) -> usize;
    fn set_cursor(&mut self, cursor: usize);
    fn stage(&mut self, index: usize) -> Stage;
    fn staged(&self) -> usize {
        0
    }
    fn validate(&self, _: &M, _: &Sources<M>) -> Result<(), Error> {
        Ok(())
    }
    fn apply(
        &mut self,
        model: &mut M,
        sources: &Sources<M>,
        applied: &mut usize,
        exact: &mut SourceEdits,
        remaining: &mut usize,
    ) -> Result<(), Error>;
    fn refresh(&mut self, _: &M, _: &Sources<M>, _: Change<'_>) -> Result<bool, Error> {
        Ok(false)
    }
    fn apply_questions(
        &mut self,
        _: &M,
        _: &Sources<M>,
        _: &mut usize,
        _: &mut usize,
    ) -> Result<(), Error> {
        Ok(())
    }
    fn start_questions(&mut self) -> bool {
        false
    }
    fn cancel_questions(&mut self) -> Self::Retired;
    fn clear(&mut self);
    fn close(&mut self) {
        // Complete cancellation across the static chain before any retained
        // response, input, inbox or closure destructor can unwind cleanup.
        let retired = self.cancel_questions();
        drop(retired);
        self.clear();
    }
    #[cfg(feature = "native-core")]
    fn attach(&mut self, wake: &Wake);
}
#[doc(hidden)]
pub enum Stage {
    Ready,
    Empty,
    Limited,
}
impl sealed::Sealed for () {}
impl<M> LaneSet<M> for () {
    const EMPTY: bool = true;
    type Retired = ();
    fn count(&self) -> usize {
        0
    }
    fn cursor(&self) -> usize {
        0
    }
    fn set_cursor(&mut self, _: usize) {}
    fn stage(&mut self, _: usize) -> Stage {
        Stage::Empty
    }
    fn apply(
        &mut self,
        _: &mut M,
        _: &Sources<M>,
        _: &mut usize,
        _: &mut SourceEdits,
        _: &mut usize,
    ) -> Result<(), Error> {
        Ok(())
    }
    fn cancel_questions(&mut self) {}
    fn clear(&mut self) {}
    #[cfg(feature = "native-core")]
    fn attach(&mut self, _: &Wake) {}
}

/// An inferred, statically dispatched lane; not an application-managed task.
#[doc(hidden)]
pub struct Lane<T, F, L> {
    inbox: Inbox<T>,
    receive: F,
    tail: L,
    cursor: usize,
}
impl<T, F, L> Lane<T, F, L> {
    pub(crate) fn new(inbox: Inbox<T>, receive: F, tail: L) -> Self {
        Self {
            inbox,
            receive,
            tail,
            cursor: 0,
        }
    }
}
impl<T, F, L> sealed::Sealed for Lane<T, F, L> {}
impl<T, F, L: ReaderValues> ReaderValues for Lane<T, F, L> {
    fn read(&self, key: ReaderKey) -> Option<Outcome<'_>> {
        self.tail.read(key)
    }
    fn visit_inputs(&self, key: ReaderKey, visit: &mut impl FnMut(crate::QuestionInput)) -> bool {
        self.tail.visit_inputs(key, visit)
    }
}
/// Inferred callback adapter for a lane which observes producer disconnection.
#[doc(hidden)]
pub struct InboxStatus<F>(pub(crate) F);
#[doc(hidden)]
pub type StatusLane<T, F, L> = Lane<T, InboxStatus<F>, L>;
#[doc(hidden)]
pub trait InboxHandler<M, T> {
    const OBSERVE_CLOSE: bool;
    const FIELD_EDITS: bool = false;
    fn validate(&self, _: &M, _: &Sources<M>) -> Result<(), Error> {
        Ok(())
    }
    fn receive(
        &mut self,
        model: &mut M,
        sources: &Sources<M>,
        value: T,
    ) -> Result<Option<FieldId>, Error>;
    fn closed(&mut self, _: &mut M) {}
}
impl<M, T, F: FnMut(&mut M, T)> InboxHandler<M, T> for F {
    const OBSERVE_CLOSE: bool = false;
    fn receive(
        &mut self,
        model: &mut M,
        _: &Sources<M>,
        value: T,
    ) -> Result<Option<FieldId>, Error> {
        self(model, value);
        Ok(None)
    }
}
impl<M, T, F: FnMut(&mut M, Option<T>)> InboxHandler<M, T> for InboxStatus<F> {
    const OBSERVE_CLOSE: bool = true;
    fn receive(
        &mut self,
        model: &mut M,
        _: &Sources<M>,
        value: T,
    ) -> Result<Option<FieldId>, Error> {
        (self.0)(model, Some(value));
        Ok(None)
    }
    fn closed(&mut self, model: &mut M) {
        (self.0)(model, None);
    }
}
impl<M, T, U: 'static, F: FnMut(&mut U, T), S: SourcePath<M, U>> InboxHandler<M, T>
    for FieldAction<M, U, F, S>
{
    const OBSERVE_CLOSE: bool = false;
    const FIELD_EDITS: bool = true;
    fn validate(&self, model: &M, sources: &Sources<M>) -> Result<(), Error> {
        self.validate_registered(model, sources)
            .map(|_| ())
            .map_err(Into::into)
    }
    fn receive(
        &mut self,
        model: &mut M,
        sources: &Sources<M>,
        value: T,
    ) -> Result<Option<FieldId>, Error> {
        FieldAction::receive(self, model, sources, value)
            .map(Some)
            .map_err(Into::into)
    }
}
impl<M, T: Send + 'static, F: InboxHandler<M, T>, L: LaneSet<M>> LaneSet<M> for Lane<T, F, L> {
    const EMPTY: bool = false;
    const QUESTIONS: bool = L::QUESTIONS;
    const FIELD_EDITS: bool = F::FIELD_EDITS || L::FIELD_EDITS;
    type Retired = (VecDeque<T>, L::Retired);
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
        self.inbox.stage(F::OBSERVE_CLOSE)
    }
    fn staged(&self) -> usize {
        self.inbox.frozen
            + usize::from(self.inbox.terminal == Terminal::Frozen)
            + self.tail.staged()
    }
    fn apply(
        &mut self,
        model: &mut M,
        sources: &Sources<M>,
        applied: &mut usize,
        exact: &mut SourceEdits,
        remaining: &mut usize,
    ) -> Result<(), Error> {
        while *remaining != 0 {
            let Some(value) = self.inbox.pop() else {
                break;
            };
            *remaining -= 1;
            let field = self.receive.receive(model, sources, value)?;
            exact.record(field);
            *applied += 1;
        }
        if *remaining != 0 && self.inbox.terminal == Terminal::Frozen {
            *remaining -= 1;
            self.inbox.terminal = Terminal::Delivered;
            self.receive.closed(model);
            exact.coarsen();
            *applied += 1;
        }
        self.tail.apply(model, sources, applied, exact, remaining)
    }
    fn validate(&self, model: &M, sources: &Sources<M>) -> Result<(), Error> {
        self.receive.validate(model, sources)?;
        self.tail.validate(model, sources)
    }
    fn cancel_questions(&mut self) -> Self::Retired {
        (self.inbox.revoke(), self.tail.cancel_questions())
    }
    fn clear(&mut self) {
        self.inbox.close();
        self.tail.clear();
    }
    fn refresh(
        &mut self,
        model: &M,
        sources: &Sources<M>,
        change: Change<'_>,
    ) -> Result<bool, Error> {
        self.tail.refresh(model, sources, change)
    }
    fn apply_questions(
        &mut self,
        model: &M,
        sources: &Sources<M>,
        applied: &mut usize,
        remaining: &mut usize,
    ) -> Result<(), Error> {
        self.tail
            .apply_questions(model, sources, applied, remaining)
    }
    fn start_questions(&mut self) -> bool {
        self.tail.start_questions()
    }
    #[cfg(feature = "native-core")]
    fn attach(&mut self, wake: &Wake) {
        // Attach once to this owner's event loop; surface suspend/resume does not
        // change its loop. Signal after attachment covers messages sent unbound.
        let open = self.inbox.shared.state.lock().open;
        if open {
            let _ = self.inbox.shared.wake.set(wake.clone());
            // Installation followed by a wake covers both pre-bind sends and
            // last-producer death, including a race with wake publication.
            wake.signal();
        }
        self.tail.attach(wake);
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[cfg(feature = "native-core")]
    #[test]
    fn native_status_builder_rejects_zero_capacity_and_an_already_closed_inbox() {
        struct Page;
        impl crate::View for Page {
            fn view(&self) -> crate::El<'_> {
                crate::div()
            }
        }
        for closed in [false, true] {
            let (remote, mut inbox) = Remote::<u64>::bounded(usize::from(closed));
            if closed {
                inbox.close();
            }
            assert!(matches!(
                crate::Window::document(Page)
                    .with_inbox_status(inbox, |_: &mut Page, _: Option<u64>| {}),
                Err(Error::ZeroInboxCapacity)
            ));
            assert!(matches!(remote.try_send(1), Err(SendError::Closed(1))));
        }
    }
    #[test]
    fn a_checked_producer_overflow_unwinds_without_losing_the_queue() {
        let (remote, mut inbox) = Remote::bounded(1);
        remote.shared.state.lock().producers = usize::MAX;
        assert!(std::panic::catch_unwind(|| remote.clone()).is_err());
        assert_eq!(remote.shared.state.lock().producers, usize::MAX);
        remote.shared.state.lock().producers = 1;
        drop(remote.clone());
        remote.try_send(7).unwrap();
        assert!(matches!(inbox.stage(false), Stage::Ready));
        assert_eq!(inbox.pop(), Some(7));
        assert!(matches!(inbox.stage(false), Stage::Empty));
    }
    #[test]
    fn preallocated_frozen_prefix_has_no_per_message_allocations() {
        let (remote, inbox) = Remote::bounded(8);
        let mut lanes = Lane::new(inbox, |sum: &mut u64, value: u64| *sum += value, ());
        let sources = Sources::new();
        let mut sum = 0;
        let measured = allocation_counter::measure(|| {
            for _ in 0..1000 {
                for _ in 0..8 {
                    remote.try_send(1).unwrap();
                }
                for _ in 0..8 {
                    assert!(matches!(lanes.stage(0), Stage::Ready));
                }
                let mut applied = 0;
                lanes
                    .apply(
                        &mut sum,
                        &sources,
                        &mut applied,
                        &mut SourceEdits::default(),
                        &mut 8,
                    )
                    .unwrap();
                assert_eq!(applied, 8);
            }
        });
        assert_eq!(sum, 8000);
        assert_eq!(measured.count_total, 0);
    }
}

#[cfg(test)]
mod ledger {
    use super::*;
    use crate::{El, View, Win, div};
    #[test]
    fn cold_and_first_lock_transport_allocation_ledger() {
        for capacity in [0, 1, 8] {
            let mut pair = None;
            let cold = allocation_counter::measure(|| {
                pair = Some(Remote::<u64>::bounded(capacity));
            });
            let (remote, mut inbox) = pair.unwrap();
            let send = allocation_counter::measure(|| {
                if capacity == 0 {
                    assert!(matches!(remote.try_send(7), Err(SendError::Full(7))));
                } else {
                    remote.try_send(7).unwrap();
                }
            });
            let stage = allocation_counter::measure(|| {
                assert!(matches!(inbox.stage(false), Stage::Ready) == (capacity != 0));
            });
            let pop = allocation_counter::measure(|| {
                assert_eq!(inbox.pop(), (capacity != 0).then_some(7));
            });
            let (_remote, mut untouched) = Remote::<u64>::bounded(capacity);
            let first_stage = allocation_counter::measure(|| {
                assert!(matches!(untouched.stage(false), Stage::Empty));
            });
            let (_remote, mut untouched) = Remote::<u64>::bounded(capacity);
            let first_close = allocation_counter::measure(|| untouched.close());
            println!(
                "remote_first_use,capacity={capacity},cold_count={},cold_bytes={},send_count={},send_bytes={},stage_count={},stage_bytes={},pop_count={},pop_bytes={},untouched_stage_count={},untouched_stage_bytes={},untouched_close_count={},untouched_close_bytes={},mutex={},shared={},state={}",
                cold.count_total,
                cold.bytes_total,
                send.count_total,
                send.bytes_total,
                stage.count_total,
                stage.bytes_total,
                pop.count_total,
                pop.bytes_total,
                first_stage.count_total,
                first_stage.bytes_total,
                first_close.count_total,
                first_close.bytes_total,
                size_of::<Mutex<State<u64>>>(),
                size_of::<Shared<u64>>(),
                size_of::<State<u64>>()
            );
        }
    }
    #[test]
    fn requested_lane_storage_is_explicit_and_unused_windows_remain_one_pointer() {
        struct Page;
        impl View for Page {
            fn view(&self) -> El<'_> {
                div()
            }
        }
        let mut pair = None;
        let cold = allocation_counter::measure(|| pair = Some(Remote::<u64>::bounded(8)));
        let (_, inbox) = pair.unwrap();
        let mut bound = None;
        let win = Win::demo(Page);
        let bind = allocation_counter::measure(|| {
            bound = Some(win.with_inbox(inbox, |_: &mut Page, _: u64| {}).unwrap())
        });
        assert_eq!(
            std::mem::size_of::<Win<Page>>(),
            std::mem::size_of::<usize>()
        );
        assert!(std::mem::size_of::<DeliveryError>() <= 128);
        println!(
            "remote={} inbox={} lane={} shared={} state={} delivery={} error={} empty_win={} channel_allocs={} channel_bytes={} bind_allocs={} bind_bytes={}",
            std::mem::size_of::<Remote<u64>>(),
            std::mem::size_of::<Inbox<u64>>(),
            std::mem::size_of::<Lane<u64, fn(&mut Page, u64), ()>>(),
            std::mem::size_of::<Shared<u64>>(),
            std::mem::size_of::<State<u64>>(),
            std::mem::size_of::<Delivery>(),
            std::mem::size_of::<DeliveryError>(),
            std::mem::size_of::<Win<Page>>(),
            cold.count_total,
            cold.bytes_total,
            bind.count_total,
            bind.bytes_total
        );
        drop(bound);
    }
}
