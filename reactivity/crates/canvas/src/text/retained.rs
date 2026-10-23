//! Exact allocation ownership for finished, bounded text buffers.
use std::{
    fmt,
    marker::PhantomData,
    mem::ManuallyDrop,
    ops::{Deref, DerefMut},
    ptr::NonNull,
};

/// A finished vector retaining its original allocation and exact capacity.
///
/// Both counts must fit u32. Failed admission returns the unchanged vector.
/// Mutation can replace elements, but cannot change length or capacity.
///
pub struct RetainedSlice<T> {
    pointer: NonNull<T>,
    length: u32,
    capacity: u32,
    owns: PhantomData<T>,
}

impl<T> TryFrom<Vec<T>> for RetainedSlice<T> {
    type Error = Vec<T>;

    fn try_from(value: Vec<T>) -> Result<Self, Self::Error> {
        let (Ok(length), Ok(capacity)) =
            (u32::try_from(value.len()), u32::try_from(value.capacity()))
        else {
            return Err(value);
        };
        let mut value = ManuallyDrop::new(value);
        Ok(Self {
            pointer: NonNull::new(value.as_mut_ptr()).expect("Vec pointers are nonnull"),
            length,
            capacity,
            owns: PhantomData,
        })
    }
}

#[cfg(test)]
impl<T> RetainedSlice<T> {
    pub fn capacity(&self) -> usize {
        self.capacity as usize
    }

    pub fn into_vec(self) -> Vec<T> {
        let value = ManuallyDrop::new(self);
        // SAFETY: Admission transfers a Global Vec's unique allocation without
        // changing pointer, length, capacity or allocator. ManuallyDrop transfers
        // its sole destruction obligation back to the reconstructed Vec.
        unsafe {
            Vec::from_raw_parts(
                value.pointer.as_ptr(),
                value.length as usize,
                value.capacity as usize,
            )
        }
    }
}

impl<T> Deref for RetainedSlice<T> {
    type Target = [T];
    fn deref(&self) -> &[T] {
        // SAFETY: The original Vec established alignment, initialization and
        // length. The owner retains the allocation for this shared borrow.
        unsafe { std::slice::from_raw_parts(self.pointer.as_ptr(), self.length as usize) }
    }
}
impl<T> DerefMut for RetainedSlice<T> {
    fn deref_mut(&mut self) -> &mut [T] {
        // SAFETY: The unique owner is exclusively borrowed; no API can change
        // its allocation or counts while this slice borrow remains live.
        unsafe { std::slice::from_raw_parts_mut(self.pointer.as_ptr(), self.length as usize) }
    }
}
impl<T> Drop for RetainedSlice<T> {
    fn drop(&mut self) {
        // SAFETY: Exactly one owner reconstructs the original Vec with its exact
        // allocation layout. Vec drops initialized elements and handles unwind.
        unsafe {
            drop(Vec::from_raw_parts(
                self.pointer.as_ptr(),
                self.length as usize,
                self.capacity as usize,
            ))
        }
    }
}
impl<T: Clone> Clone for RetainedSlice<T> {
    fn clone(&self) -> Self {
        // Standard slice cloning owns cleanup if an element's clone panics.
        Self::try_from(self.to_vec())
            .unwrap_or_else(|_| panic!("cloned capacity exceeds retained-slice domain"))
    }
}
impl<T: fmt::Debug> fmt::Debug for RetainedSlice<T> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        fmt::Debug::fmt(&**self, f)
    }
}

// SAFETY: This has Vec's exclusive allocation ownership. Only T crosses threads;
// shared access exposes &[T], and mutable access requires &mut RetainedSlice<T>.
unsafe impl<T: Send> Send for RetainedSlice<T> {}
unsafe impl<T: Sync> Sync for RetainedSlice<T> {}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    };

    #[derive(Clone, Copy, Debug, PartialEq)]
    #[repr(align(64))]
    struct Aligned(u64);

    #[test]
    fn round_trip_preserves_allocation_spare_capacity_and_alignment() {
        for capacity in [0, 1, 3, 17, 257] {
            let mut vector = Vec::with_capacity(capacity);
            vector.extend((0..capacity / 2).map(|n| Aligned(n as u64)));
            let pointer = vector.as_ptr();
            let capacity = vector.capacity();
            let mut retained = RetainedSlice::try_from(vector).unwrap();
            assert_eq!(retained.as_ptr(), pointer);
            for item in &mut *retained {
                item.0 += 1;
            }
            let vector = retained.into_vec();
            assert_eq!(vector.as_ptr(), pointer);
            assert_eq!(vector.capacity(), capacity);
            assert!(
                vector
                    .iter()
                    .enumerate()
                    .all(|(n, item)| item.0 == n as u64 + 1)
            );
        }
        assert_eq!(
            size_of::<RetainedSlice<Aligned>>(),
            if size_of::<usize>() == 8 { 16 } else { 12 }
        );
        assert_eq!(
            size_of::<Option<RetainedSlice<Aligned>>>(),
            size_of::<RetainedSlice<Aligned>>()
        );
    }

    #[test]
    fn spare_capacity_is_preserved_through_destruction() {
        let mut vector = Vec::with_capacity(17);
        vector.push(42_u64);
        let retained = RetainedSlice::try_from(vector).unwrap();
        assert_eq!(&*retained, &[42]);
        drop(retained);
    }

    struct DropProbe(Arc<AtomicUsize>);
    impl Drop for DropProbe {
        fn drop(&mut self) {
            self.0.fetch_add(1, Ordering::Relaxed);
        }
    }
    #[test]
    fn initialized_elements_drop_once_and_conversion_transfers_the_obligation() {
        let drops = Arc::new(AtomicUsize::new(0));
        let values = (0..4).map(|_| DropProbe(drops.clone())).collect::<Vec<_>>();
        let retained = RetainedSlice::try_from(values).ok().unwrap();
        let values = retained.into_vec();
        assert_eq!(drops.load(Ordering::Relaxed), 0);
        drop(values);
        assert_eq!(drops.load(Ordering::Relaxed), 4);
        let values = (0..3).map(|_| DropProbe(drops.clone())).collect::<Vec<_>>();
        drop(RetainedSlice::try_from(values).ok().unwrap());
        assert_eq!(drops.load(Ordering::Relaxed), 7);
    }

    struct PanicClone {
        id: usize,
        drops: Arc<AtomicUsize>,
    }
    impl Clone for PanicClone {
        fn clone(&self) -> Self {
            assert_ne!(self.id, 2, "deliberate clone failure");
            Self {
                id: self.id,
                drops: self.drops.clone(),
            }
        }
    }
    impl Drop for PanicClone {
        fn drop(&mut self) {
            self.drops.fetch_add(1, Ordering::Relaxed);
        }
    }
    #[test]
    fn partial_clone_unwind_releases_only_the_new_prefix() {
        let drops = Arc::new(AtomicUsize::new(0));
        let values = (0..4)
            .map(|id| PanicClone {
                id,
                drops: drops.clone(),
            })
            .collect::<Vec<_>>();
        let retained = RetainedSlice::try_from(values).ok().unwrap();
        assert!(std::panic::catch_unwind(|| retained.clone()).is_err());
        assert_eq!(drops.load(Ordering::Relaxed), 2);
        assert_eq!(retained.len(), 4);
        drop(retained);
        assert_eq!(drops.load(Ordering::Relaxed), 6);
    }

    #[test]
    fn empty_zero_sized_and_independent_clones_keep_their_ownership() {
        let vector = vec![(); 7];
        match RetainedSlice::try_from(vector) {
            Ok(retained) => {
                assert_eq!(usize::BITS, 32);
                assert_eq!(retained.len(), 7);
            }
            Err(vector) => {
                assert_ne!(usize::BITS, 32);
                assert_eq!(vector.len(), 7);
                assert_eq!(vector.capacity(), usize::MAX);
            }
        }
        let retained =
            RetainedSlice::try_from(vec![String::from("one"), String::from("two")]).unwrap();
        let mut clone = retained.clone();
        assert_ne!(retained.as_ptr(), clone.as_ptr());
        clone[0].push('!');
        drop(retained);
        assert_eq!(&*clone, &["one!", "two"]);
    }

    #[test]
    fn a_panicking_destructor_still_releases_the_remaining_elements() {
        struct Item {
            id: usize,
            drops: Arc<AtomicUsize>,
        }
        impl Drop for Item {
            fn drop(&mut self) {
                self.drops.fetch_add(1, Ordering::Relaxed);
                assert_ne!(self.id, 1, "deliberate destructor failure");
            }
        }
        let drops = Arc::new(AtomicUsize::new(0));
        let values = (0..4)
            .map(|id| Item {
                id,
                drops: drops.clone(),
            })
            .collect::<Vec<_>>();
        let retained = RetainedSlice::try_from(values).ok().unwrap();
        assert!(std::panic::catch_unwind(|| drop(retained)).is_err());
        assert_eq!(drops.load(Ordering::Relaxed), 4);
    }

    #[test]
    fn shared_thread_borrows_and_owned_thread_transfer_join_before_reuse() {
        let retained = RetainedSlice::try_from(vec![1_u64, 2, 3]).unwrap();
        std::thread::scope(|scope| {
            scope.spawn(|| assert_eq!(&*retained, &[1, 2, 3]));
        });
        let vector = std::thread::spawn(move || retained.into_vec())
            .join()
            .unwrap();
        assert_eq!(vector, [1, 2, 3]);
    }

    #[cfg(not(miri))]
    #[test]
    fn admission_and_return_allocate_nothing_and_clone_matches_vec() {
        let mut vector = Vec::with_capacity(257);
        vector.extend(0..128_u64);
        let mut retained = None;
        let cost = allocation_counter::measure(|| {
            retained = Some(RetainedSlice::try_from(vector).unwrap())
        });
        assert_eq!((cost.count_total, cost.bytes_total), (0, 0));
        let mut vector = None;
        let cost =
            allocation_counter::measure(|| vector = Some(retained.take().unwrap().into_vec()));
        assert_eq!((cost.count_total, cost.bytes_total), (0, 0));
        let retained = RetainedSlice::try_from(vector.take().unwrap()).unwrap();
        let mut cloned = None;
        let cost = allocation_counter::measure(|| cloned = Some(retained.clone()));
        assert_eq!((cost.count_total, cost.bytes_total), (1, 128 * 8));
        assert_eq!(&**cloned.as_ref().unwrap(), &*retained);
    }
}
