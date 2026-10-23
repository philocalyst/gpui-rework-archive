//! The native callback and deterministic caller enter the same serial owner turn.
use super::*;

impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    /// Inspect current logical readiness. A stale retained value is not Ready;
    /// the displayed semantic tree remains governed by presentation admission.
    pub fn question_status<T>(
        &self,
        reader: crate::Reader<T>,
    ) -> Result<crate::QuestionStatus, Error> {
        self.runtime()?.live()?;
        self.lanes
            .read(reader.key)
            .map(|outcome| outcome.info.status)
            .ok_or(crate::QuestionFault::Revoked.into())
    }
    pub fn question_info<T>(&self, reader: crate::Reader<T>) -> Result<crate::QuestionInfo, Error> {
        self.runtime()?.live()?;
        self.lanes
            .read(reader.key)
            .map(|outcome| outcome.info)
            .ok_or(crate::QuestionFault::Revoked.into())
    }
    /// Visit every declared input in order, without allocating a diagnostic
    /// vector. Versions are the last valid observed cohort, including blocked
    /// Readers; a binding rejection invalidates the pack and visits no members.
    ///
    /// ```compile_fail
    /// use gpui::{Reader,View,Win,LaneSet};
    /// fn reenter<M:View+'static,L:LaneSet<M>>(win:&mut Win<M,L>,reader:Reader<String>) {
    ///     win.visit_question_inputs(reader,|_| { win.update(|_|{}).unwrap(); }).unwrap();
    /// }
    /// ```
    pub fn visit_question_inputs<T>(
        &self,
        reader: crate::Reader<T>,
        mut visit: impl FnMut(crate::QuestionInput),
    ) -> Result<usize, Error> {
        self.runtime()?.live()?;
        let mut count = 0;
        if !self.lanes.visit_inputs(reader.key, &mut |input| {
            count += 1;
            visit(input);
        }) {
            return Err(crate::QuestionFault::Revoked.into());
        }
        Ok(count)
    }
    /// A scoped borrow only when the current answer is Ready. The callback
    /// cannot keep that borrow while replacing/closing this exclusive owner.
    ///
    /// ```compile_fail
    /// use gpui::{Reader,View,Win,LaneSet};
    /// fn escape<M:View+'static,L:LaneSet<M>>(win:&Win<M,L>,reader:Reader<String>)->&str {
    ///     win.with_ready(reader,|value|value.as_str()).unwrap().unwrap()
    /// }
    /// ```
    /// ```compile_fail
    /// use gpui::{Reader,View,Win,LaneSet};
    /// fn reenter<M:View+'static,L:LaneSet<M>>(win:&mut Win<M,L>,reader:Reader<String>) {
    ///     win.with_ready(reader,|_|win.update(|_|{})).unwrap();
    /// }
    /// ```
    pub fn with_ready<T: 'static, R>(
        &self,
        reader: crate::Reader<T>,
        read: impl FnOnce(&T) -> R,
    ) -> Result<Option<R>, Error> {
        self.runtime()?.live()?;
        let outcome = self
            .lanes
            .read(reader.key)
            .ok_or(crate::QuestionFault::Revoked)?;
        if outcome.info.status != crate::QuestionStatus::Ready {
            return Ok(None);
        }
        Ok(outcome
            .value
            .and_then(|value| value.downcast_ref::<T>())
            .map(read))
    }
    pub fn retry<T>(&mut self, reader: crate::Reader<T>) -> Result<Commit, Error> {
        let mut turn = self.runtime_mut()?;
        turn.live()?;
        if turn.lanes.read(reader.key).is_none() {
            return Err(crate::QuestionFault::Revoked.into());
        }
        let epoch = turn
            .source_epoch
            .checked_add(1)
            .ok_or(Error::EpochExhausted)?;
        turn.source_epoch = epoch;
        turn.counters.source_operations += 1;
        match catch_unwind(AssertUnwindSafe(|| {
            turn.lanes.refresh(
                &turn.runtime.model,
                &turn.runtime.sources,
                crate::reader::question::Change::Retry(reader.key),
            )
        })) {
            Ok(Ok(_)) => {}
            Ok(Err(error)) => {
                turn.logical_valid = false;
                turn.focused = None;
                return Err(error);
            }
            Err(_) => {
                turn.poison();
                return Err(Error::OwnerPanicked);
            }
        }
        turn.after_admission(None, true)
    }
    /// Bind a unique receiver to this owned window. Sends made before binding
    /// remain queued. Each callback consumes one owned payload; a batch uses one
    /// conservative source/description/presentation barrier.
    pub fn with_inbox<T: Send + 'static, F: FnMut(&mut M, T)>(
        self,
        inbox: Inbox<T>,
        receive: F,
    ) -> Result<Win<M, Lane<T, F, L>>, Error> {
        self.with_inbox_handler(inbox, receive)
    }

    /// Observe owned messages and then exactly one `None` when all producers
    /// disconnect. Buffered messages precede `None`; owner close revokes both.
    /// Capacity zero is rejected because this lane requires receive progress.
    pub fn with_inbox_status<T: Send + 'static, F: FnMut(&mut M, Option<T>)>(
        self,
        inbox: Inbox<T>,
        receive: F,
    ) -> Result<Win<M, Lane<T, crate::InboxStatus<F>, L>>, Error> {
        inbox.observe_close()?;
        self.with_inbox_handler(inbox, crate::InboxStatus(receive))
    }

    fn with_inbox_handler<T: Send + 'static, F: crate::InboxHandler<M, T>>(
        self,
        inbox: Inbox<T>,
        receive: F,
    ) -> Result<Win<M, Lane<T, F, L>>, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        if runtime.source_epoch == u64::MAX {
            return Err(Error::EpochExhausted);
        }
        let Self { lanes, inner } = self;
        let lane = Lane::new(inbox, receive, lanes);
        Ok(Win { lanes: lane, inner })
    }

    /// Admit at most `budget` messages, freezing the batch before any callback.
    /// Zero is an idle no-op. Native hosts call this same operation on WorkReady;
    /// headless hosts explicitly choose when ready results enter the owner.
    /// Per-lane FIFO is preserved; ordering between different lanes is unspecified.
    #[allow(
        clippy::result_large_err,
        reason = "Keep the fixed commit report inline rather than allocate during fault reporting."
    )]
    pub fn deliver_ready(&mut self, budget: usize) -> Result<Delivery, DeliveryError> {
        let Self { lanes, inner } = self;
        let Some(runtime) = inner.as_deref_mut() else {
            return Err(DeliveryError {
                error: Error::Closed,
                delivery: None,
            });
        };
        if let Err(error) = runtime.live() {
            lanes.close();
            return Err(DeliveryError {
                error,
                delivery: Some(Delivery {
                    received: 0,
                    applied: 0,
                    more: false,
                    commit: runtime.commit(),
                }),
            });
        }
        runtime.changed_nodes = 0;
        if budget != 0 && lanes.count() != 0 && runtime.source_epoch == u64::MAX {
            lanes.close();
            return Err(DeliveryError {
                error: Error::EpochExhausted,
                delivery: Some(Delivery {
                    received: 0,
                    applied: 0,
                    more: false,
                    commit: runtime.commit(),
                }),
            });
        }
        let count = lanes.count();
        let mut received = 0;
        let mut misses = 0;
        let mut limited = false;
        let mut cursor = lanes.cursor();
        while received < budget && misses < count {
            match lanes.stage(cursor) {
                Stage::Ready => {
                    received += 1;
                    misses = 0;
                }
                Stage::Limited => {
                    limited = true;
                    misses += 1;
                }
                Stage::Empty => misses += 1,
            }
            cursor = (cursor + 1) % count;
        }
        lanes.set_cursor(cursor);
        let more = budget != 0 && (received == budget || limited);
        if received == 0 {
            return Ok(Delivery {
                received,
                applied: 0,
                more: false,
                commit: runtime.commit(),
            });
        }
        let mut applied = 0;
        let result = RuntimeMut { runtime, lanes }.deliver(&mut applied);
        let revoked = runtime.poisoned || runtime.source_epoch == u64::MAX;
        let delivery = Delivery {
            received,
            applied,
            commit: runtime.commit(),
            more: more && !revoked,
        };
        match result {
            Ok(_) => Ok(delivery),
            Err(error) => Err(DeliveryError {
                error,
                delivery: Some(delivery),
            }),
        }
    }

    #[cfg(feature = "native-core")]
    pub(crate) fn runtime_epoch(&self) -> u64 {
        self.inner
            .as_ref()
            .expect("mounted owner exists")
            .source_epoch
    }

    #[cfg(feature = "native-core")]
    pub(crate) fn attach_wake(&mut self, wake: &gpui_reactivity_host::native::Wake) {
        self.lanes.attach(wake);
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{El, Remote, SendError, Signal, div, text, text_input};
    use std::sync::mpsc;
    struct Fault<const MODE: u8> {
        sender: Remote<u32>,
        observed: mpsc::Sender<bool>,
        input: Signal<String>,
    }
    impl<const MODE: u8> Drop for Fault<MODE> {
        fn drop(&mut self) {
            self.observed
                .send(matches!(self.sender.try_send(1), Err(SendError::Closed(1))))
                .unwrap();
        }
    }
    impl<const MODE: u8> View for Fault<MODE> {
        fn sources() -> Sources<Self> {
            if MODE == 0 {
                panic!("schema fault");
            }
            Sources::new()
        }
        fn view(&self) -> El<'_> {
            match MODE {
                1 => panic!("view fault"),
                2 => text_input(&self.input),
                3 => text("漢"),
                _ => div(),
            }
        }
    }
    fn failed_mount<const MODE: u8>(options: WindowOptions, scale: f32) {
        let (sender, inbox) = Remote::bounded(2);
        let (observed, result) = mpsc::channel();
        let model = Fault::<MODE> {
            sender: sender.clone(),
            observed,
            input: Signal::new(String::new()),
        };
        let lanes = Lane::new(inbox, |_: &mut Fault<MODE>, _: u32| {}, ());
        let result_mount = Win::mount_lanes(model, lanes, options, false, scale, false);
        assert!(result_mount.is_err());
        assert!(
            result.recv().unwrap(),
            "receiver must close before failed-mount model destruction"
        );
        assert!(matches!(sender.try_send(9), Err(SendError::Closed(9))));
    }
    #[test]
    fn mount_preparation_and_description_faults_close_lanes_before_the_model() {
        failed_mount::<0>(WindowOptions::default(), 1.0);
        failed_mount::<1>(WindowOptions::default(), 1.0);
        failed_mount::<2>(WindowOptions::default(), 1.0);
        failed_mount::<3>(WindowOptions::default(), 1.0);
        failed_mount::<4>(
            WindowOptions {
                size: [0, 0],
                ..WindowOptions::default()
            },
            1.0,
        );
        failed_mount::<5>(WindowOptions::default(), f32::NAN);
    }

    #[test]
    fn epoch_exhaustion_retires_delivery_without_consuming_or_retaining_the_remaining_queue() {
        struct Payload {
            value: u64,
            dropped: mpsc::Sender<u64>,
        }
        impl Drop for Payload {
            fn drop(&mut self) {
                self.dropped.send(self.value).unwrap();
            }
        }
        struct Owner {
            count: u64,
        }
        impl View for Owner {
            fn view(&self) -> El<'_> {
                div()
            }
        }
        let (dropped, observe) = mpsc::channel();
        let (sender, inbox) = Remote::bounded(4);
        let mut win = Win::demo(Owner { count: 0 })
            .with_inbox(inbox, |m: &mut Owner, v: Payload| m.count += v.value)
            .unwrap();
        win.runtime_mut().unwrap().source_epoch = u64::MAX - 1;
        sender
            .try_send(Payload {
                value: 1,
                dropped: dropped.clone(),
            })
            .unwrap();
        sender
            .try_send(Payload {
                value: 2,
                dropped: dropped.clone(),
            })
            .unwrap();
        let final_batch = win.deliver_ready(1).unwrap();
        assert_eq!(final_batch.commit.source_epoch, u64::MAX);
        assert_eq!(final_batch.applied, 1);
        assert!(!final_batch.more);
        assert_eq!(win.root().unwrap().count, 1);
        let rejected = match sender.try_send(Payload {
            value: 3,
            dropped: dropped.clone(),
        }) {
            Err(SendError::Closed(value)) => value,
            _ => panic!("retired"),
        };
        assert_eq!(rejected.value, 3);
        let failure = win.deliver_ready(1).unwrap_err();
        assert_eq!(failure.error, Error::EpochExhausted);
        assert_eq!(failure.delivery.unwrap().received, 0);
        assert!(!win.snapshot().unwrap().poisoned);
        drop(rejected);
        let (new_sender, new_inbox) = Remote::bounded(2);
        new_sender
            .try_send(Payload {
                value: 4,
                dropped: dropped.clone(),
            })
            .unwrap();
        assert!(matches!(
            win.with_inbox(new_inbox, |_: &mut Owner, _: Payload| {}),
            Err(Error::EpochExhausted)
        ));
        assert!(matches!(
            new_sender.try_send(Payload {
                value: 5,
                dropped: dropped.clone()
            }),
            Err(SendError::Closed(_))
        ));
        drop(dropped);
        let mut values = observe.into_iter().collect::<Vec<_>>();
        values.sort_unstable();
        assert_eq!(values, [1, 2, 3, 4, 5]);
    }
}
