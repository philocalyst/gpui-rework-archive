use ecow::EcoVec;
use std::{hint::black_box, time::Instant};
#[derive(Clone, Copy, Debug, PartialEq)]
struct Glyph { meta:u32,x:f32,baseline:f32 }
struct EcoOwner { values:EcoVec<Glyph>,text_len:u16 }
fn glyph(n:usize)->Glyph { Glyph{meta:n as u32,x:f32::from_bits(n as u32),baseline:f32::from_bits(0x8000_0000|n as u32)} }
#[inline(never)]
fn emit_vec(trace:&[(usize,usize)])->Vec<Glyph> {
 let mut result=Vec::new();
 for &(raw,keep) in trace { result.reserve(raw);for _ in 0..keep {result.push(glyph(result.len()));} }
 result
}
#[inline(never)]
fn emit_eco(trace:&[(usize,usize)])->EcoVec<Glyph> {
 let mut result=EcoVec::new();
 for &(raw,keep) in trace { result.reserve(raw);for _ in 0..keep {result.push(glyph(result.len()));} }
 result
}
fn main() {
 println!("HEADERS packed={} eco_vec={} eco_owner={}",size_of::<Glyph>(),size_of::<EcoVec<Glyph>>(),size_of::<EcoOwner>());
 for (case,trace) in [("empty",&[][..]),("single",&[(1,1)][..]),("pair",&[(2,2)][..]),("triple",&[(3,3)][..]),("label",&[(25,25)][..]),("filtered",&[(32,20)][..]),("all_filtered",&[(8,0)][..]),("paragraphs",&[(4,1),(100,98),(2,0)][..]),("max",&[(32768,32768)][..])] {
  let mut old=None;let a=allocation_counter::measure(||old=Some(emit_vec(trace)));let old=old.unwrap();
  let mut new=None;let b=allocation_counter::measure(||new=Some(emit_eco(trace)));let new=new.unwrap();
  assert_eq!(old.as_slice(),new.as_slice());assert_eq!(old.capacity(),new.capacity());
  let mut clone=None;let c=allocation_counter::measure(||clone=Some(new.clone()));let cloned=clone.unwrap();
  assert_eq!((c.count_total,c.bytes_total),(0,0));assert_eq!(new.as_ptr(),cloned.as_ptr());
  let t=Instant::now();for _ in 0..128 {black_box(emit_vec(black_box(trace)));}let old_ns=t.elapsed().as_nanos()/128;
  let t=Instant::now();for _ in 0..128 {black_box(emit_eco(black_box(trace)));}let new_ns=t.elapsed().as_nanos()/128;
  println!("OWNER case={case} len={} capacity={} vec_requests={} eco_requests={} vec_requested={} eco_requested={} vec_live={} eco_live={} vec_peak={} eco_peak={} vec_ns={old_ns} eco_ns={new_ns}",old.len(),old.capacity(),a.count_total,b.count_total,a.bytes_total,b.bytes_total,a.bytes_current,b.bytes_current,a.bytes_max,b.bytes_max);
 }
 let example=EcoOwner{values:EcoVec::new(),text_len:32768};assert!(example.values.is_empty());assert_eq!(example.text_len,32768);
}
