
/tmp/gpui-contained-property-exchange-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d550 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::admit>:
  78d550:	53                   	push   %rbx
  78d551:	48 83 ec 10          	sub    $0x10,%rsp
  78d555:	48 89 fb             	mov    %rdi,%rbx
  78d558:	48 89 e7             	mov    %rsp,%rdi
  78d55b:	48 89 d6             	mov    %rdx,%rsi
  78d55e:	ff 51 18             	call   *0x18(%rcx)
  78d561:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  78d566:	66 0f 74 05 42 06 8d 	pcmpeqb -0x72f9be(%rip),%xmm0        # 5dbb0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.360.llvm.6319143315422321905+0x2c>
  78d56d:	ff 
  78d56e:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  78d572:	b8 01 00 00 00       	mov    $0x1,%eax
  78d577:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  78d57d:	75 0d                	jne    78d58c <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::admit+0x3c>
  78d57f:	66 c7 43 08 02 00    	movw   $0x2,0x8(%rbx)
  78d585:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  78d58c:	48 89 03             	mov    %rax,(%rbx)
  78d58f:	48 89 d8             	mov    %rbx,%rax
  78d592:	48 83 c4 10          	add    $0x10,%rsp
  78d596:	5b                   	pop    %rbx
  78d597:	c3                   	ret
