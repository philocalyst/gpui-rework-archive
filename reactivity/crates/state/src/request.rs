use std::sync::{
    Arc,
    atomic::{AtomicBool, Ordering},
};

/// Why a request cannot be issued or its completion cannot be admitted.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum AdmissionError {
    Revoked,
    Stale,
    Exhausted,
}

/// An explicit, runtime-owned owner allocator. No global identity counter exists.
#[derive(Debug, Default)]
pub struct OwnerRegistry {
    next_owner: u64,
}

impl OwnerRegistry {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn mount(&mut self) -> Result<OwnerScope, AdmissionError> {
        self.next_owner = self
            .next_owner
            .checked_add(1)
            .ok_or(AdmissionError::Exhausted)?;
        Ok(OwnerScope {
            state: Arc::new(OwnerState {
                owner: self.next_owner,
                incarnation: 1,
                revoked: AtomicBool::new(false),
            }),
            next_producer: 0,
        })
    }
}

#[derive(Debug)]
struct OwnerState {
    owner: u64,
    incarnation: u64,
    revoked: AtomicBool,
}

/// Owns delivery lifetime. Drop or explicit revocation invalidates every gate.
/// Worker stamps retain a revocation token, never access to application state.
#[derive(Debug)]
pub struct OwnerScope {
    state: Arc<OwnerState>,
    next_producer: u64,
}

impl OwnerScope {
    pub fn owner(&self) -> u64 {
        self.state.owner
    }

    pub fn incarnation(&self) -> u64 {
        self.state.incarnation
    }

    pub fn revoke(&mut self) {
        self.state.revoked.store(true, Ordering::Release);
    }

    /// Reuse this owner's diagnostic identity with a fresh lifetime. All old
    /// producer gates remain revoked, even if site and ticket numbers repeat.
    pub fn remount(&mut self) -> Result<(), AdmissionError> {
        let incarnation = self
            .state
            .incarnation
            .checked_add(1)
            .ok_or(AdmissionError::Exhausted)?;
        let state = Arc::new(OwnerState {
            owner: self.state.owner,
            incarnation,
            revoked: AtomicBool::new(false),
        });
        self.revoke();
        self.state = state;
        self.next_producer = 0;
        Ok(())
    }

    /// Mint one latest-request-wins producer. Recreating the same site mints a
    /// distinct producer incarnation; it cannot accept the previous gate's work.
    pub fn producer(&mut self, site: u64) -> Result<RequestGate, AdmissionError> {
        if self.state.revoked.load(Ordering::Acquire) {
            return Err(AdmissionError::Revoked);
        }
        self.next_producer = self
            .next_producer
            .checked_add(1)
            .ok_or(AdmissionError::Exhausted)?;
        Ok(RequestGate {
            owner: self.state.clone(),
            site,
            producer: self.next_producer,
            ticket: 0,
            pending: None,
            revoked: false,
        })
    }
}

impl Drop for OwnerScope {
    fn drop(&mut self) {
        self.revoke();
    }
}

/// Owned work identity. Clone this into a worker and return it with the result.
/// Numeric fields are diagnostic only; the private owner token also prevents
/// collisions between independent registries and restored runtimes.
/// Current layout is 32 bytes on 64-bit targets: one shared token and three
/// `u64`s. The token has one allocation per owner lifetime, not per request.
#[derive(Clone, Debug)]
pub struct RequestStamp {
    owner: Arc<OwnerState>,
    site: u64,
    producer: u64,
    ticket: u64,
}

impl RequestStamp {
    pub fn owner(&self) -> u64 {
        self.owner.owner
    }
    pub fn incarnation(&self) -> u64 {
        self.owner.incarnation
    }
    pub fn site(&self) -> u64 {
        self.site
    }
    pub fn ticket(&self) -> u64 {
        self.ticket
    }
}

/// Exact, consume-once admission for a single producer.
///
/// `begin` must be called whenever the producer's frozen inputs or policy change,
/// including A → B → A. Inputs belong to the owned work; this primitive neither
/// tracks nor validates a graph's input versions. Issue only after the containing
/// logical draft is admitted; a failed draft must not launch work.
///
/// Successful acceptance returns permission to **stage** the payload in a later
/// turn. It never invokes effects or mutates presentation. The owner and its gates
/// must be operated by the same serialized UI loop; the worker only carries the
/// `Send + Sync` stamp. Do not race owner revocation against applying a payload.
#[derive(Debug)]
pub struct RequestGate {
    owner: Arc<OwnerState>,
    site: u64,
    producer: u64,
    ticket: u64,
    pending: Option<u64>,
    revoked: bool,
}

impl RequestGate {
    pub fn begin(&mut self) -> Result<RequestStamp, AdmissionError> {
        self.check_live()?;
        // Exhaustion retires pending work too; no stale request can become valid.
        self.pending = None;
        let Some(ticket) = self.ticket.checked_add(1) else {
            self.revoked = true;
            return Err(AdmissionError::Exhausted);
        };
        self.ticket = ticket;
        self.pending = Some(ticket);
        Ok(RequestStamp {
            owner: self.owner.clone(),
            site: self.site,
            producer: self.producer,
            ticket,
        })
    }

    pub fn accept(&mut self, stamp: &RequestStamp) -> Result<(), AdmissionError> {
        self.check_live()?;
        if !Arc::ptr_eq(&self.owner, &stamp.owner)
            || self.site != stamp.site
            || self.producer != stamp.producer
            || self.pending != Some(stamp.ticket)
        {
            return Err(AdmissionError::Stale);
        }
        self.pending = None;
        Ok(())
    }

    /// Cancel the outstanding request, allowing a later `begin`.
    pub fn cancel(&mut self) {
        self.pending = None;
    }

    /// Permanently retire this producer. Cancellation of its driver is separate.
    pub fn revoke(&mut self) {
        self.revoked = true;
        self.pending = None;
    }

    fn check_live(&self) -> Result<(), AdmissionError> {
        if self.revoked || self.owner.revoked.load(Ordering::Acquire) {
            Err(AdmissionError::Revoked)
        } else {
            Ok(())
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn exhausted_tickets_retire_instead_of_revalidating_old_work() {
        let mut owner = OwnerRegistry::new().mount().unwrap();
        let mut gate = owner.producer(0).unwrap();
        let stamp = gate.begin().unwrap();
        gate.ticket = u64::MAX;
        assert!(matches!(gate.begin(), Err(AdmissionError::Exhausted)));
        assert_eq!(gate.accept(&stamp), Err(AdmissionError::Revoked));
    }
}
