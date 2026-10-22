
/tmp/gpui-contained-property-exchange-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d5c0 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::property>:
  78d5c0:	41 57                	push   %r15
  78d5c2:	41 56                	push   %r14
  78d5c4:	41 55                	push   %r13
  78d5c6:	41 54                	push   %r12
  78d5c8:	53                   	push   %rbx
  78d5c9:	48 83 ec 10          	sub    $0x10,%rsp
  78d5cd:	48 89 fb             	mov    %rdi,%rbx
  78d5d0:	49 bf 1a a2 99 aa 5e 	movabs $0x5268785eaa99a21a,%r15
  78d5d7:	78 68 52 
  78d5da:	49 bc e6 c1 c4 4e 0a 	movabs $0xec3b9f0a4ec4c1e6,%r12
  78d5e1:	9f 3b ec 
  78d5e4:	83 3a 01             	cmpl   $0x1,(%rdx)
  78d5e7:	75 3a                	jne    78d623 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::property+0x63>
  78d5e9:	48 8b 72 10          	mov    0x10(%rdx),%rsi
  78d5ed:	48 8b 42 18          	mov    0x18(%rdx),%rax
  78d5f1:	48 89 e7             	mov    %rsp,%rdi
  78d5f4:	ff 50 18             	call   *0x18(%rax)
  78d5f7:	4c 33 7c 24 08       	xor    0x8(%rsp),%r15
  78d5fc:	4c 33 24 24          	xor    (%rsp),%r12
  78d600:	4d 09 fc             	or     %r15,%r12
  78d603:	b8 01 00 00 00       	mov    $0x1,%eax
  78d608:	75 7e                	jne    78d688 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::property+0xc8>
  78d60a:	48 8d 3d 2f 1e 8e ff 	lea    -0x71e1d1(%rip),%rdi        # 6f440 <anon.75d8aac7edf8b6f46ec43f1ed25af874.26.llvm.4809752233461249609+0x32>
  78d611:	48 8d 15 88 bd 3a 00 	lea    0x3abd88(%rip),%rdx        # b393a0 <anon.75d8aac7edf8b6f46ec43f1ed25af874.27.llvm.4809752233461249609+0x48>
  78d618:	be 17 00 00 00       	mov    $0x17,%esi
  78d61d:	ff 15 75 a5 3d 00    	call   *0x3da575(%rip)        # b67b98 <_DYNAMIC+0x438>
  78d623:	4c 8b 72 08          	mov    0x8(%rdx),%r14
  78d627:	48 8b 42 10          	mov    0x10(%rdx),%rax
  78d62b:	4c 8b 6a 18          	mov    0x18(%rdx),%r13
  78d62f:	48 89 e7             	mov    %rsp,%rdi
  78d632:	4c 89 f6             	mov    %r14,%rsi
  78d635:	ff 50 18             	call   *0x18(%rax)
  78d638:	4c 33 7c 24 08       	xor    0x8(%rsp),%r15
  78d63d:	4c 33 24 24          	xor    (%rsp),%r12
  78d641:	4d 09 fc             	or     %r15,%r12
  78d644:	b8 01 00 00 00       	mov    $0x1,%eax
  78d649:	75 3d                	jne    78d688 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::property+0xc8>
  78d64b:	41 80 7e 18 00       	cmpb   $0x0,0x18(%r14)
  78d650:	75 4a                	jne    78d69c <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::property+0xdc>
  78d652:	49 8b 46 08          	mov    0x8(%r14),%rax
  78d656:	48 85 c0             	test   %rax,%rax
  78d659:	74 5a                	je     78d6b5 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::property+0xf5>
  78d65b:	49 8b 4e 10          	mov    0x10(%r14),%rcx
  78d65f:	49 89 45 00          	mov    %rax,0x0(%r13)
  78d663:	49 89 4d 08          	mov    %rcx,0x8(%r13)
  78d667:	66 41 c7 45 10 01 00 	movw   $0x1,0x10(%r13)
  78d66e:	41 c6 45 14 00       	movb   $0x0,0x14(%r13)
  78d673:	48 b8 01 00 00 00 00 	movabs $0x42a0000000000001,%rax
  78d67a:	00 a0 42 
  78d67d:	49 89 45 18          	mov    %rax,0x18(%r13)
  78d681:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  78d688:	48 89 03             	mov    %rax,(%rbx)
  78d68b:	48 89 d8             	mov    %rbx,%rax
  78d68e:	48 83 c4 10          	add    $0x10,%rsp
  78d692:	5b                   	pop    %rbx
  78d693:	41 5c                	pop    %r12
  78d695:	41 5d                	pop    %r13
  78d697:	41 5e                	pop    %r14
  78d699:	41 5f                	pop    %r15
  78d69b:	c3                   	ret
  78d69c:	48 8d 3d 90 1d 8e ff 	lea    -0x71e270(%rip),%rdi        # 6f433 <anon.75d8aac7edf8b6f46ec43f1ed25af874.26.llvm.4809752233461249609+0x25>
  78d6a3:	48 8d 15 de bc 3a 00 	lea    0x3abcde(%rip),%rdx        # b39388 <anon.75d8aac7edf8b6f46ec43f1ed25af874.27.llvm.4809752233461249609+0x30>
  78d6aa:	be 1b 00 00 00       	mov    $0x1b,%esi
  78d6af:	ff 15 e3 a4 3d 00    	call   *0x3da4e3(%rip)        # b67b98 <_DYNAMIC+0x438>
  78d6b5:	48 8d 3d b4 bc 3a 00 	lea    0x3abcb4(%rip),%rdi        # b39370 <anon.75d8aac7edf8b6f46ec43f1ed25af874.27.llvm.4809752233461249609+0x18>
  78d6bc:	ff 15 ae a3 3d 00    	call   *0x3da3ae(%rip)        # b67a70 <_DYNAMIC+0x310>
