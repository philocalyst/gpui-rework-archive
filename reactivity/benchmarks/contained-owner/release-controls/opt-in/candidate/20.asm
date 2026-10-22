
/tmp/gpui-contained-owner-spike-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d840 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::proposal>:
  78d840:	41 56                	push   %r14
  78d842:	53                   	push   %rbx
  78d843:	48 83 ec 18          	sub    $0x18,%rsp
  78d847:	49 89 d6             	mov    %rdx,%r14
  78d84a:	48 89 fb             	mov    %rdi,%rbx
  78d84d:	48 89 e7             	mov    %rsp,%rdi
  78d850:	48 89 d6             	mov    %rdx,%rsi
  78d853:	ff 51 18             	call   *0x18(%rcx)
  78d856:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  78d85b:	66 0f 74 05 9d 04 8d 	pcmpeqb -0x72fb63(%rip),%xmm0        # 5dd00 <anon.079f5e587c394fcac2765eb4d0cf0bc2.360.llvm.6319143315422321905+0x2c>
  78d862:	ff 
  78d863:	66 0f d7 c0          	pmovmskb %xmm0,%eax
  78d867:	3d ff ff 00 00       	cmp    $0xffff,%eax
  78d86c:	75 35                	jne    78d8a3 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::proposal+0x63>
  78d86e:	41 80 7e 18 00       	cmpb   $0x0,0x18(%r14)
  78d873:	75 47                	jne    78d8bc <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::proposal+0x7c>
  78d875:	49 8b 46 08          	mov    0x8(%r14),%rax
  78d879:	48 85 c0             	test   %rax,%rax
  78d87c:	74 57                	je     78d8d5 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::proposal+0x95>
  78d87e:	49 8b 4e 10          	mov    0x10(%r14),%rcx
  78d882:	48 89 03             	mov    %rax,(%rbx)
  78d885:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  78d889:	66 c7 43 10 01 00    	movw   $0x1,0x10(%rbx)
  78d88f:	c6 43 14 00          	movb   $0x0,0x14(%rbx)
  78d893:	48 b8 01 00 00 00 00 	movabs $0x42a0000000000001,%rax
  78d89a:	00 a0 42 
  78d89d:	48 89 43 18          	mov    %rax,0x18(%rbx)
  78d8a1:	eb 0e                	jmp    78d8b1 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::proposal+0x71>
  78d8a3:	48 c7 43 18 01 00 00 	movq   $0x1,0x18(%rbx)
  78d8aa:	00 
  78d8ab:	66 c7 43 10 ff ff    	movw   $0xffff,0x10(%rbx)
  78d8b1:	48 89 d8             	mov    %rbx,%rax
  78d8b4:	48 83 c4 18          	add    $0x18,%rsp
  78d8b8:	5b                   	pop    %rbx
  78d8b9:	41 5e                	pop    %r14
  78d8bb:	c3                   	ret
  78d8bc:	48 8d 3d c0 1c 8e ff 	lea    -0x71e340(%rip),%rdi        # 6f583 <anon.75d8aac7edf8b6f46ec43f1ed25af874.26.llvm.14276540693209387658+0x25>
  78d8c3:	48 8d 15 de bc 3a 00 	lea    0x3abcde(%rip),%rdx        # b395a8 <anon.75d8aac7edf8b6f46ec43f1ed25af874.27.llvm.14276540693209387658+0x30>
  78d8ca:	be 1b 00 00 00       	mov    $0x1b,%esi
  78d8cf:	ff 15 43 a5 3d 00    	call   *0x3da543(%rip)        # b67e18 <_DYNAMIC+0x438>
  78d8d5:	48 8d 3d b4 bc 3a 00 	lea    0x3abcb4(%rip),%rdi        # b39590 <anon.75d8aac7edf8b6f46ec43f1ed25af874.27.llvm.14276540693209387658+0x18>
  78d8dc:	ff 15 0e a4 3d 00    	call   *0x3da40e(%rip)        # b67cf0 <_DYNAMIC+0x310>
