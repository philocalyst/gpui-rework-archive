use chrono::{DateTime, Utc};
use parking_lot::Mutex;
use std::time::Duration;

pub use web_time::Instant;

/// Supplies wall-clock and monotonic time to a scheduler.
pub trait Clock {
    fn utc_now(&self) -> DateTime<Utc>;
    fn now(&self) -> Instant;
}

/// Deterministic clock whose monotonic and UTC values can be advanced together.
pub struct TestClock(Mutex<TestClockState>);

struct TestClockState {
    now: Instant,
    utc_now: DateTime<Utc>,
}

impl TestClock {
    /// Starts at a fixed instant, making tests independent of the host clock.
    pub fn new() -> Self {
        const START_TIME: &str = "2025-07-01T23:59:58-00:00";
        let utc_now = DateTime::parse_from_rfc3339(START_TIME).unwrap().to_utc();
        Self(Mutex::new(TestClockState {
            now: Instant::now(),
            utc_now,
        }))
    }

    /// Sets the UTC component without changing monotonic time.
    pub fn set_utc_now(&self, now: DateTime<Utc>) {
        let mut state = self.0.lock();
        state.utc_now = now;
    }

    /// Advances both clock readings by `duration`.
    pub fn advance(&self, duration: Duration) {
        let mut state = self.0.lock();
        state.now += duration;
        state.utc_now += duration;
    }
}

impl Default for TestClock {
    fn default() -> Self {
        Self::new()
    }
}

impl Clock for TestClock {
    fn utc_now(&self) -> DateTime<Utc> {
        self.0.lock().utc_now
    }

    fn now(&self) -> Instant {
        self.0.lock().now
    }
}
