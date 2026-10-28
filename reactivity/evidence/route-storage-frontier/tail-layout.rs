use std::alloc::Layout;
use std::mem::{align_of, size_of, offset_of};
#[repr(C)] struct Head<T> { ops: &'static (), value: T }
#[repr(C)] struct Tail<T> { value: T, ops: &'static () }
#[repr(align(16))] struct A16([u8; 1]);
#[repr(align(64))] struct A64([u8; 1]);
#[repr(align(128))] struct A128([u8; 1]);
#[repr(align(64))] struct B64([u8; 64]);
#[repr(align(128))] struct B128([u8; 128]);
fn row<T>() {
 let (combined, off) = Layout::new::<T>().extend(Layout::new::<&()>()).unwrap();
 println!("T={} align={} Head={} Tail={} TailOff={} request={} request_align={} offset={} overhead={}", size_of::<T>(), align_of::<T>(), size_of::<Head<T>>(), size_of::<Tail<T>>(), offset_of!(Tail<T>, ops), combined.size(), combined.align(), off, combined.size()-size_of::<T>());
}
fn main(){row::<u8>();row::<A16>();row::<A64>();row::<A128>();row::<B64>();row::<B128>();}
