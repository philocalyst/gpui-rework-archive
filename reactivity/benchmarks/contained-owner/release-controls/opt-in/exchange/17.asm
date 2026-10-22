
/tmp/gpui-contained-property-exchange-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d7f0 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install>:
  78d7f0:	41 57                	push   %r15
  78d7f2:	41 56                	push   %r14
  78d7f4:	41 55                	push   %r13
  78d7f6:	41 54                	push   %r12
  78d7f8:	53                   	push   %rbx
  78d7f9:	48 83 ec 10          	sub    $0x10,%rsp
  78d7fd:	48 89 d3             	mov    %rdx,%rbx
  78d800:	49 89 f4             	mov    %rsi,%r12
  78d803:	49 89 fe             	mov    %rdi,%r14
  78d806:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  78d80b:	ff 15 8f a1 3d 00    	call   *0x3da18f(%rip)        # b679a0 <_DYNAMIC+0x240>
  78d811:	bf 08 00 00 00       	mov    $0x8,%edi
  78d816:	be 08 00 00 00       	mov    $0x8,%esi
  78d81b:	ff 15 87 a1 3d 00    	call   *0x3da187(%rip)        # b679a8 <_DYNAMIC+0x248>
  78d821:	48 85 c0             	test   %rax,%rax
  78d824:	74 74                	je     78d89a <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install+0xaa>
  78d826:	49 89 c7             	mov    %rax,%r15
  78d829:	4c 89 20             	mov    %r12,(%rax)
  78d82c:	4c 8b a3 88 00 00 00 	mov    0x88(%rbx),%r12
  78d833:	4d 85 e4             	test   %r12,%r12
  78d836:	74 2b                	je     78d863 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install+0x73>
  78d838:	4c 8b ab 90 00 00 00 	mov    0x90(%rbx),%r13
  78d83f:	49 8b 45 00          	mov    0x0(%r13),%rax
  78d843:	48 85 c0             	test   %rax,%rax
  78d846:	74 05                	je     78d84d <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install+0x5d>
  78d848:	4c 89 e7             	mov    %r12,%rdi
  78d84b:	ff d0                	call   *%rax
  78d84d:	49 8b 75 08          	mov    0x8(%r13),%rsi
  78d851:	48 85 f6             	test   %rsi,%rsi
  78d854:	74 0d                	je     78d863 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install+0x73>
  78d856:	49 8b 55 10          	mov    0x10(%r13),%rdx
  78d85a:	4c 89 e7             	mov    %r12,%rdi
  78d85d:	ff 15 75 a1 3d 00    	call   *0x3da175(%rip)        # b679d8 <_DYNAMIC+0x278>
  78d863:	4c 89 bb 88 00 00 00 	mov    %r15,0x88(%rbx)
  78d86a:	48 8d 05 f7 bc 3a 00 	lea    0x3abcf7(%rip),%rax        # b39568 <anon.75d8aac7edf8b6f46ec43f1ed25af874.54.llvm.4809752233461249609>
  78d871:	48 89 83 90 00 00 00 	mov    %rax,0x90(%rbx)
  78d878:	ba b0 00 00 00       	mov    $0xb0,%edx
  78d87d:	4c 89 f7             	mov    %r14,%rdi
  78d880:	48 89 de             	mov    %rbx,%rsi
  78d883:	ff 15 27 a1 3d 00    	call   *0x3da127(%rip)        # b679b0 <memcpy@GLIBC_2.14>
  78d889:	4c 89 f0             	mov    %r14,%rax
  78d88c:	48 83 c4 10          	add    $0x10,%rsp
  78d890:	5b                   	pop    %rbx
  78d891:	41 5c                	pop    %r12
  78d893:	41 5d                	pop    %r13
  78d895:	41 5e                	pop    %r14
  78d897:	41 5f                	pop    %r15
  78d899:	c3                   	ret
  78d89a:	bf 08 00 00 00       	mov    $0x8,%edi
  78d89f:	be 08 00 00 00       	mov    $0x8,%esi
  78d8a4:	ff 15 0e a1 3d 00    	call   *0x3da10e(%rip)        # b679b8 <_DYNAMIC+0x258>
  78d8aa:	0f 0b                	ud2
  78d8ac:	49 89 c6             	mov    %rax,%r14
  78d8af:	49 8b 75 08          	mov    0x8(%r13),%rsi
  78d8b3:	48 85 f6             	test   %rsi,%rsi
  78d8b6:	74 0d                	je     78d8c5 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install+0xd5>
  78d8b8:	49 8b 55 10          	mov    0x10(%r13),%rdx
  78d8bc:	4c 89 e7             	mov    %r12,%rdi
  78d8bf:	ff 15 13 a1 3d 00    	call   *0x3da113(%rip)        # b679d8 <_DYNAMIC+0x278>
  78d8c5:	4c 89 bb 88 00 00 00 	mov    %r15,0x88(%rbx)
  78d8cc:	48 8d 05 95 bc 3a 00 	lea    0x3abc95(%rip),%rax        # b39568 <anon.75d8aac7edf8b6f46ec43f1ed25af874.54.llvm.4809752233461249609>
  78d8d3:	48 89 83 90 00 00 00 	mov    %rax,0x90(%rbx)
  78d8da:	eb 1e                	jmp    78d8fa <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install+0x10a>
  78d8dc:	49 89 c6             	mov    %rax,%r14
  78d8df:	f0 49 ff 44 24 10    	lock incq 0x10(%r12)
  78d8e5:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  78d8ea:	f0 48 ff 08          	lock decq (%rax)
  78d8ee:	75 0a                	jne    78d8fa <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install+0x10a>
  78d8f0:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  78d8f5:	e8 36 e0 fe ff       	call   77b930 <<alloc::sync::Arc<core::sync::atomic::Atomic<usize>>>::drop_slow>
  78d8fa:	48 89 df             	mov    %rbx,%rdi
  78d8fd:	e8 ae e0 ff ff       	call   78b9b0 <core::ptr::drop_glue::<gpui::element::El>>
  78d902:	4c 89 f7             	mov    %r14,%rdi
  78d905:	e8 46 89 3a 00       	call   b36250 <_Unwind_Resume@plt>
  78d90a:	ff 15 b0 a0 3d 00    	call   *0x3da0b0(%rip)        # b679c0 <_DYNAMIC+0x260>
  78d910:	ff 15 aa a0 3d 00    	call   *0x3da0aa(%rip)        # b679c0 <_DYNAMIC+0x260>
