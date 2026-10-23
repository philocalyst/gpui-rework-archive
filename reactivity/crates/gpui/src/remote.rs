//! Bounded owned messages. Workers have transport capabilities, never UI access.
use crate::{
    Commit, Error,
    reader::{Outcome, ReaderKey, ReaderValues, question::Change},
    source::Sources,
};
#[cfg(feature = "native-core")]
use gpui_reactivity_host::native::Wake;
use std::collections::VecDeque;
use std::sync::mpsc::{self, Receiver, SyncSender, TryRecvError, TrySendError};
#[cfg(feature = "native-core")]
use std::sync::{
    Arc, OnceLock, Weak,
    atomic::{AtomicBool, Ordering},
};

#[cfg(feature = "native-core")]
struct Notification {
    wake: OnceLock<Wake>,
    terminal: AtomicBool,
}
#[cfg(feature = "native-core")]
struct Producer<T> {
    // Rust drops fields in declaration order. Closing the sole channel sender
    // before Notification drops makes the terminal wake observe disconnection.
    sender: SyncSender<T>,
    notification: Notification,
}
#[cfg(feature = "native-core")]
impl Drop for Notification {
    fn drop(&mut self) {
        if *self.terminal.get_mut() {
            self.signal();
        }
    }
}
#[cfg(feature = "native-core")]
impl Notification {
    fn signal(&self) {
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
    #[cfg(not(feature = "native-core"))]
    sender: SyncSender<T>,
    #[cfg(feature = "native-core")]
    producer: Arc<Producer<T>>,
}
impl<T> Clone for Remote<T> {
    fn clone(&self) -> Self {
        Self {
            #[cfg(not(feature = "native-core"))]
            sender: self.sender.clone(),
            #[cfg(feature = "native-core")]
            producer: Arc::clone(&self.producer),
        }
    }
}
impl<T> Remote<T> {
    /// Create an unbound lane. Sending before binding is permitted and bounded.
    /// Moving its sole Inbox into a window binds that receiver exactly once.
    /// Capacity zero rejects every try_send with Full. Storage is allocated here,
    /// including one staging buffer, rather than for each message or owner turn.
    /// An attached native event proxy/OS may allocate separately when posting wakes.
    pub fn bounded(capacity: usize) -> (Self, Inbox<T>) {
        let (sender, receiver) = mpsc::sync_channel(capacity);
        #[cfg(feature = "native-core")]
        let producer = Arc::new(Producer {
            sender,
            notification: Notification {
                wake: OnceLock::new(),
                terminal: AtomicBool::new(false),
            },
        });
        #[cfg(feature = "native-core")]
        let attached = Arc::downgrade(&producer);
        (
            Self {
                #[cfg(not(feature = "native-core"))]
                sender,
                #[cfg(feature = "native-core")]
                producer,
            },
            Inbox {
                receiver: Some(receiver),
                staging: VecDeque::with_capacity(capacity),
                capacity,
                #[cfg(feature = "native-core")]
                producer: attached,
            },
        )
    }
    fn sender(&self) -> &SyncSender<T> {
        #[cfg(feature = "native-core")]
        {
            &self.producer.sender
        }
        #[cfg(not(feature = "native-core"))]
        {
            &self.sender
        }
    }
    pub fn try_send(&self, value: T) -> Result<(), SendError<T>> {
        match self.sender().try_send(value) {
            Ok(()) => {
                #[cfg(feature = "native-core")]
                self.producer.notification.signal();
                Ok(())
            }
            Err(TrySendError::Full(value)) => Err(SendError::Full(value)),
            Err(TrySendError::Disconnected(value)) => Err(SendError::Closed(value)),
        }
    }
}

/// The unique owned receiver. There is no public receive operation: delivery
/// enters through the ordinary production window barrier after binding.
/// ```compile_fail
/// let (_, inbox) = gpui::Remote::<u64>::bounded(8);
/// let second_receiver = inbox.clone();
/// ```
pub struct Inbox<T> {
    receiver: Option<Receiver<T>>,
    staging: VecDeque<T>,
    capacity: usize,
    #[cfg(feature = "native-core")]
    producer: Weak<Producer<T>>,
}
impl<T> Inbox<T> {
    pub(crate) fn close(&mut self) {
        self.receiver.take();
        self.staging.clear();
        self.capacity = 0;
    }
    pub(crate) fn observe_close(&self) -> Result<(), Error> {
        if self.capacity == 0 {
            return Err(Error::ZeroInboxCapacity);
        }
        #[cfg(feature = "native-core")]
        if let Some(producer) = self.producer.upgrade() {
            producer
                .notification
                .terminal
                .store(true, Ordering::Relaxed);
        }
        Ok(())
    }
    pub(crate) fn stage(&mut self, observe_close: bool) -> Stage {
        if self.capacity == 0 {
            return Stage::Empty;
        }
        if self.staging.len() == self.capacity {
            return Stage::Limited;
        }
        match self.receiver.as_ref().map(Receiver::try_recv) {
            Some(Ok(value)) => {
                self.staging.push_back(value);
                Stage::Ready
            }
            Some(Err(TryRecvError::Disconnected)) if observe_close => {
                self.receiver.take();
                Stage::Ready
            }
            _ => Stage::Empty,
        }
    }
}

/// One explicit delivery turn. `more` is a conservative scheduling hint: a
/// saturated batch rearms once even if its last receive emptied the queue.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Delivery {
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
/// Internal static receiver chain. Applications infer this type through with_inbox.
#[doc(hidden)]
pub trait LaneSet<M>: sealed::Sealed + ReaderValues {
    const EMPTY: bool;
    const QUESTIONS: bool = false;
    type Retired;
    fn count(&self) -> usize;
    fn cursor(&self) -> usize;
    fn set_cursor(&mut self, cursor: usize);
    fn stage(&mut self, index: usize) -> Stage;
    fn apply(&mut self, model: &mut M, applied: &mut usize);
    fn refresh(&mut self, _: &M, _: &Sources<M>, _: Change) -> Result<bool, Error> {
        Ok(false)
    }
    fn apply_questions(&mut self, _: &M, _: &Sources<M>, _: &mut usize) -> Result<(), Error> {
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
    fn apply(&mut self, _: &mut M, _: &mut usize) {}
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
    fn receive(&mut self, model: &mut M, value: T);
    fn closed(&mut self, _: &mut M) {}
}
impl<M, T, F: FnMut(&mut M, T)> InboxHandler<M, T> for F {
    const OBSERVE_CLOSE: bool = false;
    fn receive(&mut self, model: &mut M, value: T) {
        self(model, value);
    }
}
impl<M, T, F: FnMut(&mut M, Option<T>)> InboxHandler<M, T> for InboxStatus<F> {
    const OBSERVE_CLOSE: bool = true;
    fn receive(&mut self, model: &mut M, value: T) {
        (self.0)(model, Some(value));
    }
    fn closed(&mut self, model: &mut M) {
        (self.0)(model, None);
    }
}
impl<M, T: Send + 'static, F: InboxHandler<M, T>, L: LaneSet<M>> LaneSet<M> for Lane<T, F, L> {
    const EMPTY: bool = false;
    const QUESTIONS: bool = L::QUESTIONS;
    type Retired = (Option<Receiver<T>>, L::Retired);
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
    fn apply(&mut self, model: &mut M, applied: &mut usize) {
        while let Some(value) = self.inbox.staging.pop_front() {
            self.receive.receive(model, value);
            *applied += 1;
        }
        if F::OBSERVE_CLOSE && self.inbox.receiver.is_none() && self.inbox.capacity != 0 {
            self.inbox.capacity = 0;
            self.receive.closed(model);
            *applied += 1;
        }
        self.tail.apply(model, applied);
    }
    fn cancel_questions(&mut self) -> Self::Retired {
        (self.inbox.receiver.take(), self.tail.cancel_questions())
    }
    fn clear(&mut self) {
        self.inbox.close();
        self.tail.clear();
    }
    fn refresh(&mut self, model: &M, sources: &Sources<M>, change: Change) -> Result<bool, Error> {
        self.tail.refresh(model, sources, change)
    }
    fn apply_questions(
        &mut self,
        model: &M,
        sources: &Sources<M>,
        applied: &mut usize,
    ) -> Result<(), Error> {
        self.tail.apply_questions(model, sources, applied)
    }
    fn start_questions(&mut self) -> bool {
        self.tail.start_questions()
    }
    #[cfg(feature = "native-core")]
    fn attach(&mut self, wake: &Wake) {
        // Attach once to this owner's event loop; surface suspend/resume does not
        // change its loop. Signal after attachment covers messages sent unbound.
        if self.inbox.receiver.is_some() {
            if let Some(producer) = self.inbox.producer.upgrade() {
                let _ = producer.notification.wake.set(wake.clone());
            }
            // Producer death before binding must still enter the owner barrier.
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
    fn preallocated_static_transport_and_staging_have_no_per_message_allocations() {
        let (remote, inbox) = Remote::bounded(8);
        let mut lanes = Lane::new(inbox, |sum: &mut u64, value: u64| *sum += value, ());
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
                lanes.apply(&mut sum, &mut applied);
                assert_eq!(applied, 8);
            }
        });
        assert_eq!(sum, 8000);
        assert_eq!(measured.count_total, 0);
    }
}

#[cfg(test)]
fn notification_size() -> usize {
    #[cfg(feature = "native-core")]
    {
        std::mem::size_of::<Notification>()
    }
    #[cfg(not(feature = "native-core"))]
    {
        0
    }
}

#[cfg(test)]
fn producer_size() -> usize {
    #[cfg(feature = "native-core")]
    {
        std::mem::size_of::<Producer<u64>>()
    }
    #[cfg(not(feature = "native-core"))]
    {
        0
    }
}

#[cfg(test)]
mod ledger {
    use super::*;
    use crate::{El, View, Win, div};
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
            "remote={} inbox={} lane={} notification={} producer={} optional_sender={} delivery={} error={} empty_win={} channel_allocs={} channel_bytes={} bind_allocs={} bind_bytes={}",
            std::mem::size_of::<Remote<u64>>(),
            std::mem::size_of::<Inbox<u64>>(),
            std::mem::size_of::<Lane<u64, fn(&mut Page, u64), ()>>(),
            notification_size(),
            producer_size(),
            std::mem::size_of::<Option<SyncSender<u64>>>(),
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
