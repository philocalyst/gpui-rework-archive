
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

0000000000730380 <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::invoke>:
  730380:	41 56                	push   %r14
  730382:	53                   	push   %rbx
  730383:	48 83 ec 18          	sub    $0x18,%rsp
  730387:	49 89 d6             	mov    %rdx,%r14
  73038a:	48 89 fb             	mov    %rdi,%rbx
  73038d:	48 89 e7             	mov    %rsp,%rdi
  730390:	48 89 d6             	mov    %rdx,%rsi
  730393:	ff 51 18             	call   *0x18(%rcx)
  730396:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  73039b:	66 0f 74 05 7d 58 93 	pcmpeqb -0x6ca783(%rip),%xmm0        # 65c20 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0xd80>
  7303a2:	ff 
  7303a3:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  7303a7:	b8 01 00 00 00       	mov    $0x1,%eax
  7303ac:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  7303b2:	75 0a                	jne    7303be <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::invoke+0x3e>
  7303b4:	41 ff 06             	incl   (%r14)
  7303b7:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  7303be:	48 89 03             	mov    %rax,(%rbx)
  7303c1:	48 89 d8             	mov    %rbx,%rax
  7303c4:	48 83 c4 18          	add    $0x18,%rsp
  7303c8:	5b                   	pop    %rbx
  7303c9:	41 5e                	pop    %r14
  7303cb:	c3                   	ret
