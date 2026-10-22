
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000760520 <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::invoke>:
  760520:	41 56                	push   %r14
  760522:	53                   	push   %rbx
  760523:	48 83 ec 18          	sub    $0x18,%rsp
  760527:	49 89 d6             	mov    %rdx,%r14
  76052a:	48 89 fb             	mov    %rdi,%rbx
  76052d:	48 89 e7             	mov    %rsp,%rdi
  760530:	48 89 d6             	mov    %rdx,%rsi
  760533:	ff 51 18             	call   *0x18(%rcx)
  760536:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  76053b:	66 0f 74 05 5d 9a 8f 	pcmpeqb -0x7065a3(%rip),%xmm0        # 59fa0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x330>
  760542:	ff 
  760543:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  760547:	b8 01 00 00 00       	mov    $0x1,%eax
  76054c:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  760552:	75 0a                	jne    76055e <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::invoke+0x3e>
  760554:	41 ff 06             	incl   (%r14)
  760557:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  76055e:	48 89 03             	mov    %rax,(%rbx)
  760561:	48 89 d8             	mov    %rbx,%rax
  760564:	48 83 c4 18          	add    $0x18,%rsp
  760568:	5b                   	pop    %rbx
  760569:	41 5e                	pop    %r14
  76056b:	c3                   	ret
