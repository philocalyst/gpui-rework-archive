
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

0000000000730330 <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::admit>:
  730330:	53                   	push   %rbx
  730331:	48 83 ec 10          	sub    $0x10,%rsp
  730335:	48 89 fb             	mov    %rdi,%rbx
  730338:	48 89 e7             	mov    %rsp,%rdi
  73033b:	48 89 d6             	mov    %rdx,%rsi
  73033e:	ff 51 18             	call   *0x18(%rcx)
  730341:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  730346:	66 0f 74 05 d2 58 93 	pcmpeqb -0x6ca72e(%rip),%xmm0        # 65c20 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0xd80>
  73034d:	ff 
  73034e:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  730352:	b8 01 00 00 00       	mov    $0x1,%eax
  730357:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  73035d:	75 15                	jne    730374 <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::admit+0x44>
  73035f:	66 c7 43 08 00 00    	movw   $0x0,0x8(%rbx)
  730365:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  73036c:	00 
  73036d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  730374:	48 89 03             	mov    %rax,(%rbx)
  730377:	48 89 d8             	mov    %rbx,%rax
  73037a:	48 83 c4 10          	add    $0x10,%rsp
  73037e:	5b                   	pop    %rbx
  73037f:	c3                   	ret
