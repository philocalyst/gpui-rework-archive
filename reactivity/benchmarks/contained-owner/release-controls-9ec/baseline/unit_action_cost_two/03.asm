
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000760430 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::admit>:
  760430:	53                   	push   %rbx
  760431:	48 83 ec 10          	sub    $0x10,%rsp
  760435:	48 89 fb             	mov    %rdi,%rbx
  760438:	48 89 e7             	mov    %rsp,%rdi
  76043b:	48 89 d6             	mov    %rdx,%rsi
  76043e:	ff 51 18             	call   *0x18(%rcx)
  760441:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  760446:	66 0f 74 05 52 97 8f 	pcmpeqb -0x7068ae(%rip),%xmm0        # 59ba0 <anon.052c13baa99450080a7488dc623138c2.75.llvm.10723869756690930045+0x180>
  76044d:	ff 
  76044e:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  760452:	b8 01 00 00 00       	mov    $0x1,%eax
  760457:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  76045d:	75 15                	jne    760474 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::admit+0x44>
  76045f:	66 c7 43 08 00 00    	movw   $0x0,0x8(%rbx)
  760465:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  76046c:	00 
  76046d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  760474:	48 89 03             	mov    %rax,(%rbx)
  760477:	48 89 d8             	mov    %rbx,%rax
  76047a:	48 83 c4 10          	add    $0x10,%rsp
  76047e:	5b                   	pop    %rbx
  76047f:	c3                   	ret
