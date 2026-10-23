//! Matched public owner/transport allocation and codegen control; never timed.
use gpui::{Delivery, El, Inbox, Lane, Remote, View, Win, div};
use std::{hint::black_box, mem::size_of};
struct Page(u64);
impl View for Page { fn view(&self) -> El<'_> { div() } }
fn receive(page: &mut Page, value: u64) { page.0 += value; }
type Owner = Win<Page, Lane<u64, fn(&mut Page, u64), ()>>;
#[inline(never)]
fn transport(capacity: usize) -> (Remote<u64>, Inbox<u64>) { Remote::bounded(capacity) }
#[inline(never)]
fn send(remote: &Remote<u64>, value: u64) -> bool { remote.try_send(value).is_ok() }
#[inline(never)]
fn clone_drop(remote: &Remote<u64>) { drop(remote.clone()); }
#[inline(never)]
fn deliver(owner: &mut Owner, budget: usize) -> Delivery { owner.deliver_ready(budget).unwrap() }
#[inline(never)]
fn ordinary(owner: &mut Win<Page>, value: u64) { owner.update(|page| page.0 += value).unwrap(); }
fn main() {
    println!("layout remote={} inbox={} owner={} empty={}", size_of::<Remote<u64>>(), size_of::<Inbox<u64>>(), size_of::<Owner>(), size_of::<Win<Page>>());
    let mut plain = Win::demo(Page(0));
    ordinary(black_box(&mut plain), black_box(1));
    assert_eq!(plain.root().unwrap().0, 1);
    for capacity in [0, 1, 8, 64] {
        let mut pair = None;
        let cold = allocation_counter::measure(|| pair = Some(transport(black_box(capacity))));
        println!("cold capacity={capacity} {cold:?}");
        drop(pair.take());
        let mut bound = None;
        let owner = allocation_counter::measure(|| {
            let (remote, inbox) = transport(black_box(capacity));
            let win = Win::demo(Page(0)).with_inbox(inbox, receive as fn(&mut Page, u64)).unwrap();
            bound = Some((remote, win));
        });
        println!("owner capacity={capacity} {owner:?}");
        let (remote, mut win) = bound.take().unwrap();
        let cloned = allocation_counter::measure(|| clone_drop(black_box(&remote)));
        assert_eq!(cloned.count_total, 0);
        let sent = allocation_counter::measure(|| for value in 0..capacity { assert!(send(black_box(&remote), black_box(value as u64))); });
        assert_eq!(sent.count_total, 0);
        assert!(!send(&remote, 999));
        let mut report = None;
        let applied = allocation_counter::measure(|| report = Some(deliver(black_box(&mut win), black_box(64))));
        assert_eq!(report.unwrap().applied, capacity);
        assert_eq!(win.root().unwrap().0, (0..capacity as u64).sum::<u64>());
        println!("apply capacity={capacity} {applied:?}");
        let idle = allocation_counter::measure(|| assert_eq!(deliver(black_box(&mut win), 64).applied, 0));
        assert_eq!(idle.count_total, 0);
        let closed = allocation_counter::measure(|| win.close());
        println!("close capacity={capacity} {closed:?}");
        assert!(!send(&remote, 42));
    }
}
