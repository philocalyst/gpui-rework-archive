use crate::Ready;
use rtrb::{Consumer, Producer, PushError, RingBuffer};
use std::{num::NonZeroUsize, sync::Arc};

/// Owned preallocated payload. It is intentionally not Clone. Sequence is only
/// diagnostic metadata; actual Box ownership, not generation arithmetic, prevents UAF.
#[derive(Debug)]
pub struct OwnedPage<T> {
    sequence: u64,
    data: Box<[T]>,
}
impl<T> OwnedPage<T> {
    pub fn new(sequence: u64, data: Box<[T]>) -> Self {
        Self { sequence, data }
    }
    pub fn sequence(&self) -> u64 {
        self.sequence
    }
    pub fn set_sequence(&mut self, sequence: u64) {
        self.sequence = sequence;
    }
    pub fn data(&self) -> &[T] {
        &self.data
    }
    pub fn data_mut(&mut self) -> &mut [T] {
        &mut self.data
    }
}
#[derive(Debug)]
pub enum SendError<T> {
    Full(T),
    Closed(T),
}
impl<T> SendError<T> {
    pub fn into_inner(self) -> T {
        match self {
            Self::Full(value) | Self::Closed(value) => value,
        }
    }
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
#[must_use = "wake=true must be forwarded to the host after queue publication"]
pub struct Accepted {
    pub wake: bool,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
#[must_use = "unfinished bounded drains must forward wake=true to the host"]
pub struct DrainReport {
    pub received: usize,
    pub wake: bool,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum DrainError {
    EmptyBudget,
    OccupiedSlot,
}

/// Consumer owns the payload and can only expose shared references. CPU completion
/// consumes this lease; the borrow checker forbids completing while a read is live.
/// This is NOT a GPU fence. An adapter must retain the lease until real release.
///
/// ```compile_fail
/// use gpui_reactivity_ownership_lab::{page_lane,OwnedPage};
/// let (mut producer,mut consumer)=page_lane(std::num::NonZeroUsize::new(1).unwrap());
/// let _=producer.publish(OwnedPage::new(0,vec![1].into_boxed_slice())).unwrap();
/// let mut slots=[None];let _=consumer.drain(&mut slots).unwrap();
/// let lease=slots[0].take().unwrap();
/// let borrowed=lease.data();
/// let completed=lease.complete();
/// assert_eq!(borrowed[0],1); // cannot complete and reuse while this borrow lives
/// ```
#[derive(Debug)]
pub struct ReadLease<T>(OwnedPage<T>);
impl<T> ReadLease<T> {
    pub fn sequence(&self) -> u64 {
        self.0.sequence()
    }
    pub fn data(&self) -> &[T] {
        self.0.data()
    }
    pub fn complete(self) -> CompletedPage<T> {
        CompletedPage(self.0)
    }
}
/// Exclusive ownership after the consumer's CPU reads have ended; only the return
/// ring can make it producer-mutable again. No clone/refcount of payload storage.
#[derive(Debug)]
pub struct CompletedPage<T>(OwnedPage<T>);

struct Sender<T> {
    ring: Producer<T>,
    ready: Arc<Ready>,
}
struct Receiver<T> {
    ring: Consumer<T>,
    ready: Arc<Ready>,
}
fn mailbox<T>(capacity: usize) -> (Sender<T>, Receiver<T>) {
    let (p, c) = RingBuffer::new(capacity);
    let ready = Arc::new(Ready::default());
    (
        Sender {
            ring: p,
            ready: ready.clone(),
        },
        Receiver { ring: c, ready },
    )
}
impl<T> Sender<T> {
    fn push(&mut self, value: T) -> Result<Accepted, SendError<T>> {
        if self.ring.is_abandoned() {
            return Err(SendError::Closed(value));
        }
        self.ring
            .push(value)
            .map(|()| Accepted {
                wake: self.ready.publish(),
            })
            .map_err(|PushError::Full(value)| SendError::Full(value))
    }
}
impl<T> Receiver<T> {
    fn drain<U>(
        &mut self,
        slots: &mut [Option<U>],
        map: fn(T) -> U,
    ) -> Result<DrainReport, DrainError> {
        if slots.is_empty() {
            return Err(DrainError::EmptyBudget);
        }
        if slots.iter().any(Option::is_some) {
            return Err(DrainError::OccupiedSlot);
        }
        self.ready.acknowledge_before_drain();
        let mut received = 0;
        for slot in slots {
            match self.ring.pop() {
                Ok(value) => {
                    *slot = Some(map(value));
                    received += 1;
                }
                Err(_) => break,
            }
        }
        let wake = self.ready.finish_bounded_drain(!self.ring.is_empty());
        Ok(DrainReport { received, wake })
    }
}
/// Two bounded SPSC ownership lanes. One writer/reader per endpoint, no cloning.
/// Successful publish means queue admission, not application/GPU acknowledgement.
/// Every Accepted/DrainReport wake=true must be forwarded to the host; callbacks
/// may be spurious. No blocking send, timer, native loop or default pool is created.
pub struct PageProducer<T> {
    outgoing: Sender<OwnedPage<T>>,
    returned: Receiver<OwnedPage<T>>,
}
pub struct PageConsumer<T> {
    incoming: Receiver<OwnedPage<T>>,
    returning: Sender<OwnedPage<T>>,
}
pub fn page_lane<T>(capacity: NonZeroUsize) -> (PageProducer<T>, PageConsumer<T>) {
    let (outgoing, incoming) = mailbox(capacity.get());
    let (returning, returned) = mailbox(capacity.get());
    (
        PageProducer { outgoing, returned },
        PageConsumer {
            incoming,
            returning,
        },
    )
}
impl<T> PageProducer<T> {
    pub fn publish(&mut self, page: OwnedPage<T>) -> Result<Accepted, SendError<OwnedPage<T>>> {
        self.outgoing.push(page)
    }
    pub fn reclaim(
        &mut self,
        slots: &mut [Option<OwnedPage<T>>],
    ) -> Result<DrainReport, DrainError> {
        self.returned.drain(slots, |page| page)
    }
}
impl<T> PageConsumer<T> {
    pub fn drain(&mut self, slots: &mut [Option<ReadLease<T>>]) -> Result<DrainReport, DrainError> {
        self.incoming.drain(slots, ReadLease)
    }
    pub fn recycle(
        &mut self,
        page: CompletedPage<T>,
    ) -> Result<Accepted, SendError<CompletedPage<T>>> {
        self.returning.push(page.0).map_err(|error| match error {
            SendError::Full(page) => SendError::Full(CompletedPage(page)),
            SendError::Closed(page) => SendError::Closed(CompletedPage(page)),
        })
    }
}
