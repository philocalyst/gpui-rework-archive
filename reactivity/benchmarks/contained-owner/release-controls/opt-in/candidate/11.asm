
/tmp/gpui-contained-owner-spike-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d7d0 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::admit>:
  78d7d0:	53                   	push   %rbx
  78d7d1:	48 83 ec 10          	sub    $0x10,%rsp
  78d7d5:	48 89 fb             	mov    %rdi,%rbx
  78d7d8:	48 89 e7             	mov    %rsp,%rdi
  78d7db:	48 89 d6             	mov    %rdx,%rsi
  78d7de:	ff 51 18             	call   *0x18(%rcx)
  78d7e1:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  78d7e6:	66 0f 74 05 12 05 8d 	pcmpeqb -0x72faee(%rip),%xmm0        # 5dd00 <anon.079f5e587c394fcac2765eb4d0cf0bc2.360.llvm.6319143315422321905+0x2c>
  78d7ed:	ff 
  78d7ee:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  78d7f2:	b8 01 00 00 00       	mov    $0x1,%eax
  78d7f7:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  78d7fd:	75 0d                	jne    78d80c <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::admit+0x3c>
  78d7ff:	66 c7 43 08 02 00    	movw   $0x2,0x8(%rbx)
  78d805:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  78d80c:	48 89 03             	mov    %rax,(%rbx)
  78d80f:	48 89 d8             	mov    %rbx,%rax
  78d812:	48 83 c4 10          	add    $0x10,%rsp
  78d816:	5b                   	pop    %rbx
  78d817:	c3                   	ret
