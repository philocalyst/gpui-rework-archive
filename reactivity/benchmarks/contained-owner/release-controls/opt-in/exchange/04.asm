
/tmp/gpui-contained-property-exchange-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078b6f0 <core::ptr::drop_glue::<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}>>>:
  78b6f0:	48 8b 07             	mov    (%rdi),%rax
  78b6f3:	f0 48 ff 40 10       	lock incq 0x10(%rax)
  78b6f8:	48 8b 07             	mov    (%rdi),%rax
  78b6fb:	f0 48 ff 08          	lock decq (%rax)
  78b6ff:	75 05                	jne    78b706 <core::ptr::drop_glue::<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}>>+0x16>
  78b701:	e9 2a 02 ff ff       	jmp    77b930 <<alloc::sync::Arc<core::sync::atomic::Atomic<usize>>>::drop_slow>
  78b706:	c3                   	ret
