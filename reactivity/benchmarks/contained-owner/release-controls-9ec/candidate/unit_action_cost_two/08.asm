
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000075c070 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::invoke>:
  75c070:	41 56                	push   %r14
  75c072:	53                   	push   %rbx
  75c073:	48 83 ec 18          	sub    $0x18,%rsp
  75c077:	49 89 d6             	mov    %rdx,%r14
  75c07a:	48 89 fb             	mov    %rdi,%rbx
  75c07d:	48 89 e7             	mov    %rsp,%rdi
  75c080:	48 89 d6             	mov    %rdx,%rsi
  75c083:	ff 51 18             	call   *0x18(%rcx)
  75c086:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  75c08b:	66 0f 74 05 fd dc 8f 	pcmpeqb -0x702303(%rip),%xmm0        # 59d90 <anon.052c13baa99450080a7488dc623138c2.75.llvm.10723869756690930045+0x180>
  75c092:	ff 
  75c093:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  75c097:	b8 01 00 00 00       	mov    $0x1,%eax
  75c09c:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  75c0a2:	75 0e                	jne    75c0b2 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::invoke+0x42>
  75c0a4:	41 ff 86 00 01 00 00 	incl   0x100(%r14)
  75c0ab:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  75c0b2:	48 89 03             	mov    %rax,(%rbx)
  75c0b5:	48 89 d8             	mov    %rbx,%rax
  75c0b8:	48 83 c4 18          	add    $0x18,%rsp
  75c0bc:	5b                   	pop    %rbx
  75c0bd:	41 5e                	pop    %r14
  75c0bf:	c3                   	ret
