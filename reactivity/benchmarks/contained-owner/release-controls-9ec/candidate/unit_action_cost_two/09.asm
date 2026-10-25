
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000075c0c0 <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::admit>:
  75c0c0:	53                   	push   %rbx
  75c0c1:	48 83 ec 10          	sub    $0x10,%rsp
  75c0c5:	48 89 fb             	mov    %rdi,%rbx
  75c0c8:	48 89 e7             	mov    %rsp,%rdi
  75c0cb:	48 89 d6             	mov    %rdx,%rsi
  75c0ce:	ff 51 18             	call   *0x18(%rcx)
  75c0d1:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  75c0d6:	66 0f 74 05 b2 e0 8f 	pcmpeqb -0x701f4e(%rip),%xmm0        # 5a190 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x330>
  75c0dd:	ff 
  75c0de:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  75c0e2:	b8 01 00 00 00       	mov    $0x1,%eax
  75c0e7:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  75c0ed:	75 15                	jne    75c104 <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::admit+0x44>
  75c0ef:	66 c7 43 08 00 00    	movw   $0x0,0x8(%rbx)
  75c0f5:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  75c0fc:	00 
  75c0fd:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  75c104:	48 89 03             	mov    %rax,(%rbx)
  75c107:	48 89 d8             	mov    %rbx,%rax
  75c10a:	48 83 c4 10          	add    $0x10,%rsp
  75c10e:	5b                   	pop    %rbx
  75c10f:	c3                   	ret
