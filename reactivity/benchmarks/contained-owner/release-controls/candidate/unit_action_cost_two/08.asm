
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000075c0e0 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::invoke>:
  75c0e0:	41 56                	push   %r14
  75c0e2:	53                   	push   %rbx
  75c0e3:	48 83 ec 18          	sub    $0x18,%rsp
  75c0e7:	49 89 d6             	mov    %rdx,%r14
  75c0ea:	48 89 fb             	mov    %rdi,%rbx
  75c0ed:	48 89 e7             	mov    %rsp,%rdi
  75c0f0:	48 89 d6             	mov    %rdx,%rsi
  75c0f3:	ff 51 18             	call   *0x18(%rcx)
  75c0f6:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  75c0fb:	66 0f 74 05 9d dc 8f 	pcmpeqb -0x702363(%rip),%xmm0        # 59da0 <anon.052c13baa99450080a7488dc623138c2.75.llvm.10723869756690930045+0x180>
  75c102:	ff 
  75c103:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  75c107:	b8 01 00 00 00       	mov    $0x1,%eax
  75c10c:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  75c112:	75 0e                	jne    75c122 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::invoke+0x42>
  75c114:	41 ff 86 00 01 00 00 	incl   0x100(%r14)
  75c11b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  75c122:	48 89 03             	mov    %rax,(%rbx)
  75c125:	48 89 d8             	mov    %rbx,%rax
  75c128:	48 83 c4 18          	add    $0x18,%rsp
  75c12c:	5b                   	pop    %rbx
  75c12d:	41 5e                	pop    %r14
  75c12f:	c3                   	ret
