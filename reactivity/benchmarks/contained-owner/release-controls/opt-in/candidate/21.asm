
/tmp/gpui-contained-owner-spike-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078da10 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install>:
  78da10:	41 57                	push   %r15
  78da12:	41 56                	push   %r14
  78da14:	41 55                	push   %r13
  78da16:	41 54                	push   %r12
  78da18:	53                   	push   %rbx
  78da19:	48 83 ec 10          	sub    $0x10,%rsp
  78da1d:	48 89 d3             	mov    %rdx,%rbx
  78da20:	49 89 f4             	mov    %rsi,%r12
  78da23:	49 89 fe             	mov    %rdi,%r14
  78da26:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  78da2b:	ff 15 ef a1 3d 00    	call   *0x3da1ef(%rip)        # b67c20 <_DYNAMIC+0x240>
  78da31:	bf 08 00 00 00       	mov    $0x8,%edi
  78da36:	be 08 00 00 00       	mov    $0x8,%esi
  78da3b:	ff 15 e7 a1 3d 00    	call   *0x3da1e7(%rip)        # b67c28 <_DYNAMIC+0x248>
  78da41:	48 85 c0             	test   %rax,%rax
  78da44:	74 74                	je     78daba <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install+0xaa>
  78da46:	49 89 c7             	mov    %rax,%r15
  78da49:	4c 89 20             	mov    %r12,(%rax)
  78da4c:	4c 8b a3 88 00 00 00 	mov    0x88(%rbx),%r12
  78da53:	4d 85 e4             	test   %r12,%r12
  78da56:	74 2b                	je     78da83 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install+0x73>
  78da58:	4c 8b ab 90 00 00 00 	mov    0x90(%rbx),%r13
  78da5f:	49 8b 45 00          	mov    0x0(%r13),%rax
  78da63:	48 85 c0             	test   %rax,%rax
  78da66:	74 05                	je     78da6d <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install+0x5d>
  78da68:	4c 89 e7             	mov    %r12,%rdi
  78da6b:	ff d0                	call   *%rax
  78da6d:	49 8b 75 08          	mov    0x8(%r13),%rsi
  78da71:	48 85 f6             	test   %rsi,%rsi
  78da74:	74 0d                	je     78da83 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install+0x73>
  78da76:	49 8b 55 10          	mov    0x10(%r13),%rdx
  78da7a:	4c 89 e7             	mov    %r12,%rdi
  78da7d:	ff 15 d5 a1 3d 00    	call   *0x3da1d5(%rip)        # b67c58 <_DYNAMIC+0x278>
  78da83:	4c 89 bb 88 00 00 00 	mov    %r15,0x88(%rbx)
  78da8a:	48 8d 05 0f bd 3a 00 	lea    0x3abd0f(%rip),%rax        # b397a0 <anon.75d8aac7edf8b6f46ec43f1ed25af874.54.llvm.14276540693209387658>
  78da91:	48 89 83 90 00 00 00 	mov    %rax,0x90(%rbx)
  78da98:	ba b0 00 00 00       	mov    $0xb0,%edx
  78da9d:	4c 89 f7             	mov    %r14,%rdi
  78daa0:	48 89 de             	mov    %rbx,%rsi
  78daa3:	ff 15 87 a1 3d 00    	call   *0x3da187(%rip)        # b67c30 <memcpy@GLIBC_2.14>
  78daa9:	4c 89 f0             	mov    %r14,%rax
  78daac:	48 83 c4 10          	add    $0x10,%rsp
  78dab0:	5b                   	pop    %rbx
  78dab1:	41 5c                	pop    %r12
  78dab3:	41 5d                	pop    %r13
  78dab5:	41 5e                	pop    %r14
  78dab7:	41 5f                	pop    %r15
  78dab9:	c3                   	ret
  78daba:	bf 08 00 00 00       	mov    $0x8,%edi
  78dabf:	be 08 00 00 00       	mov    $0x8,%esi
  78dac4:	ff 15 6e a1 3d 00    	call   *0x3da16e(%rip)        # b67c38 <_DYNAMIC+0x258>
  78daca:	0f 0b                	ud2
  78dacc:	49 89 c6             	mov    %rax,%r14
  78dacf:	49 8b 75 08          	mov    0x8(%r13),%rsi
  78dad3:	48 85 f6             	test   %rsi,%rsi
  78dad6:	74 0d                	je     78dae5 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install+0xd5>
  78dad8:	49 8b 55 10          	mov    0x10(%r13),%rdx
  78dadc:	4c 89 e7             	mov    %r12,%rdi
  78dadf:	ff 15 73 a1 3d 00    	call   *0x3da173(%rip)        # b67c58 <_DYNAMIC+0x278>
  78dae5:	4c 89 bb 88 00 00 00 	mov    %r15,0x88(%rbx)
  78daec:	48 8d 05 ad bc 3a 00 	lea    0x3abcad(%rip),%rax        # b397a0 <anon.75d8aac7edf8b6f46ec43f1ed25af874.54.llvm.14276540693209387658>
  78daf3:	48 89 83 90 00 00 00 	mov    %rax,0x90(%rbx)
  78dafa:	eb 1e                	jmp    78db1a <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install+0x10a>
  78dafc:	49 89 c6             	mov    %rax,%r14
  78daff:	f0 49 ff 44 24 10    	lock incq 0x10(%r12)
  78db05:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  78db0a:	f0 48 ff 08          	lock decq (%rax)
  78db0e:	75 0a                	jne    78db1a <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::IntoHandler<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, gpui::element::shape::Property>>::install+0x10a>
  78db10:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  78db15:	e8 06 e1 fe ff       	call   77bc20 <<alloc::sync::Arc<core::sync::atomic::Atomic<usize>>>::drop_slow>
  78db1a:	48 89 df             	mov    %rbx,%rdi
  78db1d:	e8 7e e1 ff ff       	call   78bca0 <core::ptr::drop_glue::<gpui::element::El>>
  78db22:	4c 89 f7             	mov    %r14,%rdi
  78db25:	e8 16 89 3a 00       	call   b36440 <_Unwind_Resume@plt>
  78db2a:	ff 15 10 a1 3d 00    	call   *0x3da110(%rip)        # b67c40 <_DYNAMIC+0x260>
  78db30:	ff 15 0a a1 3d 00    	call   *0x3da10a(%rip)        # b67c40 <_DYNAMIC+0x260>
