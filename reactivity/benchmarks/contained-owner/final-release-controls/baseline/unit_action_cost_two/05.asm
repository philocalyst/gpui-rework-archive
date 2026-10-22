
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000007604d0 <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::admit>:
  7604d0:	53                   	push   %rbx
  7604d1:	48 83 ec 10          	sub    $0x10,%rsp
  7604d5:	48 89 fb             	mov    %rdi,%rbx
  7604d8:	48 89 e7             	mov    %rsp,%rdi
  7604db:	48 89 d6             	mov    %rdx,%rsi
  7604de:	ff 51 18             	call   *0x18(%rcx)
  7604e1:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  7604e6:	66 0f 74 05 b2 9a 8f 	pcmpeqb -0x70654e(%rip),%xmm0        # 59fa0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x330>
  7604ed:	ff 
  7604ee:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  7604f2:	b8 01 00 00 00       	mov    $0x1,%eax
  7604f7:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  7604fd:	75 15                	jne    760514 <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::admit+0x44>
  7604ff:	66 c7 43 08 00 00    	movw   $0x0,0x8(%rbx)
  760505:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  76050c:	00 
  76050d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  760514:	48 89 03             	mov    %rax,(%rbx)
  760517:	48 89 d8             	mov    %rbx,%rax
  76051a:	48 83 c4 10          	add    $0x10,%rsp
  76051e:	5b                   	pop    %rbx
  76051f:	c3                   	ret
