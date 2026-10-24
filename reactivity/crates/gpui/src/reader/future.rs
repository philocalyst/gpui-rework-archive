//! Opt-in Future scheduling; ordinary questions store no task or waker.
use super::{question::Starter, *};
use std::{
    future::Future,
    pin::Pin,
    task::{Context, Poll},
};

/// Cancellation authority for one exact executor task.
pub trait QuestionTask {
    /// Request cancellation promptly, without blocking, panicking, or joining.
    /// This must be idempotent and schedule abort/drop even before the first
    /// poll or when Pending without a registered wake. A bare wake is insufficient.
    /// Cancellation takes effect after any active poll returns; neither cancel
    /// nor handle destruction may reclaim storage still borrowed by that poll.
    /// Returning does not return the question's physical completion credit.
    fn cancel(&mut self);
}

/// An explicitly supplied executor; GPUI installs no hidden runtime.
pub trait QuestionExecutor {
    /// Handle destruction must also be prompt, nonblocking and non-panicking;
    /// it must not join or reclaim storage borrowed by an active poll.
    type Task: QuestionTask;

    /// Enqueue promptly without polling inline or reentering GPUI. A worker may
    /// finish before this returns. Polls must be serialized and non-reentrant.
    /// Ok transfers the future to the exact task named by the returned handle.
    /// Err must drop the rejected future before returning. A panic must either
    /// precede acceptance or drop the accepted future before unwinding.
    ///
    /// Accepting then returning Err/panicking without a handle violates this
    /// contract: GPUI retains the completion lease until actual task teardown;
    /// it cannot recover that lost cancellation handle or fabricate free credit.
    /// A completed future may be retained: its user future and completion have
    /// already been cleared before Ready. Executor allocations are its own cost.
    fn spawn<F>(&mut self, future: F) -> Result<Self::Task, StartError>
    where
        F: Future<Output = ()> + Send + 'static;
}

#[doc(hidden)]
pub struct FutureStarter<X: QuestionExecutor, Make> {
    executor: X,
    make: Make,
    task: Option<X::Task>,
}
impl<X: QuestionExecutor, Make> FutureStarter<X, Make> {
    pub(super) fn new(executor: X, make: Make) -> Self {
        Self {
            executor,
            make,
            task: None,
        }
    }
}
impl<X: QuestionExecutor, Make> Drop for FutureStarter<X, Make> {
    fn drop(&mut self) {
        if let Some(task) = &mut self.task {
            task.cancel();
        }
    }
}
impl<I, T, E, X, Make, Fut> Starter<I, T, E> for FutureStarter<X, Make>
where
    I: Send + 'static,
    T: Send + 'static,
    E: std::error::Error + Send + 'static,
    X: QuestionExecutor,
    Make: FnMut(I) -> Fut,
    Fut: Future<Output = Result<T, E>> + Send + 'static,
{
    fn start(&mut self, input: I, completion: Completion<T, E>) -> Result<(), StartError> {
        debug_assert!(self.task.is_none(), "retire handle before reusing credit");
        let future = (self.make)(input);
        self.task = Some(self.executor.spawn(RunFuture {
            future: Some(future),
            finish: Finish {
                completion: Some(completion),
                panicked: false,
            },
        })?);
        Ok(())
    }
    fn cancel(&mut self) {
        if let Some(task) = &mut self.task {
            task.cancel();
        }
    }
    fn retire(&mut self) {
        self.task.take();
    }
}

pin_project_lite::pin_project! {
    struct RunFuture<F, T, E> {
        // Declaration order is the Pending cancellation protocol: all user
        // state is destroyed before Finish can publish a terminal.
        #[pin]
        future: Option<F>,
        finish: Finish<T, E>,
    }
}
struct Finish<T, E> {
    completion: Option<Completion<T, E>>,
    panicked: bool,
}
impl<T, E> Finish<T, E> {
    fn panic(&mut self) {
        if let Some(completion) = self.completion.take() {
            completion.panicked();
        }
    }
}
impl<T, E> Drop for Finish<T, E> {
    fn drop(&mut self) {
        if self.panicked || std::thread::panicking() {
            self.panic();
        }
        // Otherwise Completion's ordinary Drop publishes Abandoned.
    }
}
impl<F, T, E> Future for RunFuture<F, T, E>
where
    F: Future<Output = Result<T, E>>,
{
    type Output = ();
    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<()> {
        let mut this = self.project();
        let outcome = {
            let Some(future) = this.future.as_mut().as_pin_mut() else {
                return Poll::Ready(());
            };
            catch_unwind(AssertUnwindSafe(|| future.poll(cx)))
        };
        match outcome {
            Ok(Poll::Pending) => Poll::Pending,
            outcome => {
                // Cover both a panicking panic-payload destructor and a
                // panicking Fut destructor. A second unwind may abort as usual.
                this.finish.panicked = true;
                let result = match outcome {
                    Ok(Poll::Ready(result)) => Some(result),
                    Err(payload) => {
                        drop(payload);
                        None
                    }
                    Ok(Poll::Pending) => unreachable!(),
                };
                // Pin::set drops even !Unpin futures in place before overwrite.
                // No completion/result is retained in the now-trivial wrapper.
                this.future.set(None);
                if let Some(result) = result {
                    let _ = this.finish.completion.take().unwrap().complete(result);
                } else {
                    this.finish.panic();
                }
                Poll::Ready(())
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::convert::Infallible;

    #[test]
    fn future_wrapper_has_no_result_slot_or_poll_allocation() {
        struct Small;
        impl Future for Small {
            type Output = Result<[u8; 4096], Infallible>;
            fn poll(self: Pin<&mut Self>, _: &mut Context<'_>) -> Poll<Self::Output> {
                Poll::Ready(Ok([7; 4096]))
            }
        }
        let ticket = Ticket(NonZeroU64::MIN);
        let mut controller = Owner::new(QuestionContext::new());
        let completion = Completion {
            ticket,
            producer: controller.begin(),
        };
        let mut task = std::pin::pin!(RunFuture {
            future: Some(Small),
            finish: Finish {
                completion: Some(completion),
                panicked: false
            }
        });
        let mut cx = Context::from_waker(std::task::Waker::noop());
        let allocation = allocation_counter::measure(|| {
            assert_eq!(task.as_mut().poll(&mut cx), Poll::Ready(()))
        });
        assert_eq!(allocation.count_total, 0);
        assert!(task.future.is_none());
        assert!(task.finish.completion.is_none());
        assert!(size_of::<RunFuture<Small, [u8; 4096], Infallible>>() < 4096);
        println!(
            "future_wrapper,small_future={},wrapper={},completion={},output={},poll_allocations={}",
            size_of::<Small>(),
            size_of::<RunFuture<Small, [u8; 4096], Infallible>>(),
            size_of::<Completion<[u8; 4096], Infallible>>(),
            size_of::<[u8; 4096]>(),
            allocation.count_total
        );
        assert_eq!(controller.take().unwrap().value.unwrap(), [7; 4096]);
    }
}
