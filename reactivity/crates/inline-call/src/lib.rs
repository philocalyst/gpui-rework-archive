//! Checked, allocation-free storage for a small Copy callable.
//! This internal experiment has no ownership, lifetime, or pointer identity API.
#![deny(unsafe_op_in_unsafe_fn)]
use std::{
    any::Any,
    mem::{MaybeUninit, align_of, size_of},
};

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct TooLarge {
    pub size: usize,
    pub alignment: usize,
}

#[derive(Clone, Copy)]
#[repr(C, align(8))]
struct Payload([MaybeUninit<u64>; 2]);

/// A callable occupying at most sixteen bytes with alignment at most eight.
/// Copy excludes destructors; Send + Sync excludes hidden thread-bound state.
/// Neither input references nor returned references are retained by this type.
pub struct InlineCall<O> {
    payload: Payload,
    invoke: fn(&Payload, &dyn Any) -> O,
}
impl<O> Copy for InlineCall<O> {}
impl<O> Clone for InlineCall<O> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<O> InlineCall<O> {
    pub fn new<F>(call: F) -> Result<Self, TooLarge>
    where
        F: Fn(&dyn Any) -> O + Copy + Send + Sync + 'static,
    {
        if size_of::<F>() > size_of::<Payload>() || align_of::<F>() > align_of::<Payload>() {
            return Err(TooLarge {
                size: size_of::<F>(),
                alignment: align_of::<F>(),
            });
        }
        let mut payload = Payload([MaybeUninit::uninit(); 2]);
        // SAFETY: checked size and alignment above; the payload starts live and
        // has enough space for every byte of F. No typed reference is exposed.
        unsafe {
            payload.0.as_mut_ptr().cast::<F>().write(call);
        }
        Ok(Self {
            payload,
            invoke: |payload, input| {
                // SAFETY: this thunk is paired only with payload initialized as F.
                // Copies and moves preserve all initialized bytes, including pointer
                // provenance. F is Copy, so reading duplicates it without transferring
                // ownership or needing a destructor. The payload is eight-aligned.
                let call = unsafe { payload.0.as_ptr().cast::<F>().read() };
                call(input)
            },
        })
    }
    pub fn call(&self, input: &dyn Any) -> O {
        (self.invoke)(&self.payload, input)
    }
}

#[cfg(test)]
mod tests {
    // These tests intentionally exercise Clone as well as implicit Copy.
    #![allow(clippy::clone_on_copy)]
    use super::*;
    #[test]
    fn moves_clones_threads_zst_function_pointer_and_full_capture() {
        let zst = InlineCall::new(|input: &dyn Any| *input.downcast_ref::<u64>().unwrap()).unwrap();
        assert_eq!(zst.call(&4_u64), 4);
        fn increment(input: &dyn Any) -> u64 {
            input.downcast_ref::<u64>().unwrap() + 1
        }
        let pointer: fn(&dyn Any) -> u64 = increment;
        let pointer = InlineCall::new(pointer).unwrap();
        assert_eq!(pointer.call(&4_u64), 5);
        let params = [9_u64, 17_u64];
        let captured = InlineCall::new(move |input: &dyn Any| {
            input.downcast_ref::<u64>().unwrap() + params[0] + params[1]
        })
        .unwrap();
        let moved = [captured, captured.clone()];
        assert_eq!(
            std::thread::spawn(move || moved[1].call(&4_u64))
                .join()
                .unwrap(),
            30
        );
        assert_eq!(size_of::<InlineCall<u64>>(), 24);
    }
    #[test]
    fn pointer_provenance_and_padded_environments_survive_reallocation() {
        #[derive(Clone, Copy)]
        struct Padded {
            tag: u8,
            value: &'static u64,
        }
        static VALUE: u64 = 43;
        let padded = Padded {
            tag: 3,
            value: &VALUE,
        };
        let closure = move |input: &dyn Any| {
            let whole = std::hint::black_box(padded);
            *whole.value + whole.tag as u64 + *input.downcast_ref::<u64>().unwrap()
        };
        let recipe = InlineCall::new(closure).unwrap();
        let mut moved = Vec::new();
        for _ in 0..1000 {
            moved.push(recipe.clone());
        }
        assert_eq!(
            std::thread::spawn(move || moved.iter().map(|call| call.call(&2_u64)).sum::<u64>())
                .join()
                .unwrap(),
            48000
        );
        fn add(a: u64, b: u64) -> u64 {
            a + b
        }
        let pointer: fn(u64, u64) -> u64 = add;
        let named: &'static str = "hello";
        let call = InlineCall::new(move |input: &dyn Any| {
            pointer(*input.downcast_ref::<u64>().unwrap(), 5)
        })
        .unwrap();
        assert_eq!(call.call(&9_u64), 14);
        let call = InlineCall::new(move |_: &dyn Any| named.len()).unwrap();
        assert_eq!(call.call(&()), 5);
    }
    #[test]
    fn rejects_large_and_overaligned_captures_without_invocation() {
        let large = [1_u64; 3];
        assert_eq!(
            InlineCall::new(move |_: &dyn Any| std::hint::black_box(large)).err(),
            Some(TooLarge {
                size: 24,
                alignment: 8
            })
        );
        #[derive(Clone, Copy)]
        #[repr(align(16))]
        struct Aligned(u64);
        let aligned = Aligned(7);
        let error = InlineCall::new(move |_: &dyn Any| std::hint::black_box(aligned).0).err();
        assert_eq!(
            error,
            Some(TooLarge {
                size: 16,
                alignment: 16
            })
        );
    }
    #[test]
    fn input_is_borrowed_for_each_call_and_type_failure_is_preserved() {
        let call =
            InlineCall::new(|input: &dyn Any| input.downcast_ref::<String>().map(String::len))
                .unwrap();
        assert_eq!(call.call(&String::from("abc")), Some(3));
        assert_eq!(call.call(&9_u64), None);
        assert_eq!(call.call(&String::from("defgh")), Some(5));
    }
}
