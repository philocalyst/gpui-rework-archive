
/tmp/gpui-contained-owner-spike-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d770 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::applied_logically>:
  78d770:	53                   	push   %rbx
  78d771:	48 83 ec 10          	sub    $0x10,%rsp
  78d775:	48 89 fb             	mov    %rdi,%rbx
  78d778:	48 89 e7             	mov    %rsp,%rdi
  78d77b:	48 89 d6             	mov    %rdx,%rsi
  78d77e:	ff 51 18             	call   *0x18(%rcx)
  78d781:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  78d786:	66 0f 74 05 72 05 8d 	pcmpeqb -0x72fa8e(%rip),%xmm0        # 5dd00 <anon.079f5e587c394fcac2765eb4d0cf0bc2.360.llvm.6319143315422321905+0x2c>
  78d78d:	ff 
  78d78e:	66 0f d7 c0          	pmovmskb %xmm0,%eax
  78d792:	3d ff ff 00 00       	cmp    $0xffff,%eax
  78d797:	74 10                	je     78d7a9 <<gpui::element::PropertyRoute<property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#0}, <property_actions::request_and_reply_panics_restore_the_owned_route_until_close::Owner as gpui::View>::view::{closure#1}> as gpui::element::Route>::applied_logically+0x39>
  78d799:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  78d7a0:	48 89 d8             	mov    %rbx,%rax
  78d7a3:	48 83 c4 10          	add    $0x10,%rsp
  78d7a7:	5b                   	pop    %rbx
  78d7a8:	c3                   	ret
  78d7a9:	48 8d 3d e0 1d 8e ff 	lea    -0x71e220(%rip),%rdi        # 6f590 <anon.75d8aac7edf8b6f46ec43f1ed25af874.26.llvm.14276540693209387658+0x32>
  78d7b0:	48 8d 15 09 be 3a 00 	lea    0x3abe09(%rip),%rdx        # b395c0 <anon.75d8aac7edf8b6f46ec43f1ed25af874.27.llvm.14276540693209387658+0x48>
  78d7b7:	be 17 00 00 00       	mov    $0x17,%esi
  78d7bc:	ff 15 56 a6 3d 00    	call   *0x3da656(%rip)        # b67e18 <_DYNAMIC+0x438>
