//! Bounded owned messages. Workers have transport capabilities, never UI access.
use crate::{
    Commit, Error,
    reader::{Outcome, ReaderKey, ReaderValues, question::Change},
    source::Sources,
};
#[cfg(feature = "native")]
use gpui_reactivity_host::native::Wake;
use std::collections::VecDeque;
use std::sync::mpsc::{self, Receiver, SyncSender, TrySendError};
#[cfg(feature = "native")]
use std::sync::{Arc, OnceLock};

#[cfg(feature = "native")]
struct Notification {
    wake: OnceLock<Wake>,
}
#[cfg(feature = "native")]
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
    sender: SyncSender<T>,
    #[cfg(feature = "native")]
    notification: Arc<Notification>,
}
impl<T> Clone for Remote<T> {
    fn clone(&self) -> Self {
        Self {
            sender: self.sender.clone(),
            #[cfg(feature = "native")]
            notification: Arc::clone(&self.notification),
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
        #[cfg(feature = "native")]
        let notification = Arc::new(Notification {
            wake: OnceLock::new(),
        });
        (
            Self {
                sender,
                #[cfg(feature = "native")]
                notification: Arc::clone(&notification),
            },
            Inbox {
                receiver: Some(receiver),
                staging: VecDeque::with_capacity(capacity),
                capacity,
                #[cfg(feature = "native")]
                notification,
            },
        )
    }
    pub fn try_send(&self, value: T) -> Result<(), SendError<T>> {
        match self.sender.try_send(value) {
            Ok(()) => {
                #[cfg(feature = "native")]
                self.notification.signal();
                Ok(())
            }
            Err(TrySendError::Full(value)) => Err(SendError::Full(value)),
            Err(TrySendError::Disconnected(value)) => Err(SendError::Closed(value)),
        }
    }
    pub(crate) fn signal(&self) {
        #[cfg(feature = "native")]
        self.notification.signal();
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
    #[cfg(feature = "native")]
    notification: Arc<Notification>,
}
impl<T> Inbox<T> {
    pub(crate) fn close(&mut self) {
        self.receiver.take();
        self.staging.clear();
    }
    pub(crate) fn stage(&mut self) -> Stage {
        if self.capacity == 0 {
            return Stage::Empty;
        }
        if self.staging.len() == self.capacity {
            return Stage::Limited;
        }
        match self
            .receiver
            .as_ref()
            .and_then(|receiver| receiver.try_recv().ok())
        {
            Some(value) => {
                self.staging.push_back(value);
                Stage::Ready
            }
            None => Stage::Empty,
        }
    }
    pub(crate) fn pop(&mut self) -> Option<T> {
        self.staging.pop_front()
    }
    #[cfg(feature = "native")]
    pub(crate) fn attach(&mut self, wake: &Wake) {
        let _ = self.notification.wake.set(wake.clone());
        self.notification.signal();
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
    fn close(&mut self);
    #[cfg(feature = "native")]
    fn attach(&mut self, wake: &Wake);
    fn signal(&self);
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
    fn close(&mut self) {}
    #[cfg(feature = "native")]
    fn attach(&mut self, _: &Wake) {}
    fn signal(&self) {}
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
}
impl<M, T: Send + 'static, F: FnMut(&mut M, T), L: LaneSet<M>> LaneSet<M> for Lane<T, F, L> {
    const EMPTY: bool = false;
    const QUESTIONS: bool = L::QUESTIONS;
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
        self.inbox.stage()
    }
    fn apply(&mut self, model: &mut M, applied: &mut usize) {
        while let Some(value) = self.inbox.staging.pop_front() {
            (self.receive)(model, value);
            *applied += 1;
        }
        self.tail.apply(model, applied);
    }
    fn close(&mut self) {
        self.inbox.close();
        self.tail.close();
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
    #[cfg(feature = "native")]
    fn attach(&mut self, wake: &Wake) {
        // Attach once to this owner's event loop; surface suspend/resume does not
        // change its loop. Signal after attachment covers messages sent unbound.
        let _ = self.inbox.notification.wake.set(wake.clone());
        self.inbox.notification.signal();
        self.tail.attach(wake);
    }
    fn signal(&self) {
        #[cfg(feature = "native")]
        self.inbox.notification.signal();
        self.tail.signal();
    }
}

#[cfg(test)]
mod tests {
    use super::*;
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
    #[cfg(feature = "native")]
    {
        std::mem::size_of::<Notification>()
    }
    #[cfg(not(feature = "native"))]
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
            "remote={} inbox={} lane={} notification={} delivery={} error={} empty_win={} channel_allocs={} channel_bytes={} bind_allocs={} bind_bytes={}",
            std::mem::size_of::<Remote<u64>>(),
            std::mem::size_of::<Inbox<u64>>(),
            std::mem::size_of::<Lane<u64, fn(&mut Page, u64), ()>>(),
            notification_size(),
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
