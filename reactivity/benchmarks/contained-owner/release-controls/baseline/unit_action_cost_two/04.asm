
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000760480 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::invoke>:
  760480:	41 56                	push   %r14
  760482:	53                   	push   %rbx
  760483:	48 83 ec 18          	sub    $0x18,%rsp
  760487:	49 89 d6             	mov    %rdx,%r14
  76048a:	48 89 fb             	mov    %rdi,%rbx
  76048d:	48 89 e7             	mov    %rsp,%rdi
  760490:	48 89 d6             	mov    %rdx,%rsi
  760493:	ff 51 18             	call   *0x18(%rcx)
  760496:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  76049b:	66 0f 74 05 fd 96 8f 	pcmpeqb -0x706903(%rip),%xmm0        # 59ba0 <anon.052c13baa99450080a7488dc623138c2.75.llvm.10723869756690930045+0x180>
  7604a2:	ff 
  7604a3:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  7604a7:	b8 01 00 00 00       	mov    $0x1,%eax
  7604ac:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  7604b2:	75 0e                	jne    7604c2 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::invoke+0x42>
  7604b4:	41 ff 86 00 01 00 00 	incl   0x100(%r14)
  7604bb:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  7604c2:	48 89 03             	mov    %rax,(%rbx)
  7604c5:	48 89 d8             	mov    %rbx,%rax
  7604c8:	48 83 c4 18          	add    $0x18,%rsp
  7604cc:	5b                   	pop    %rbx
  7604cd:	41 5e                	pop    %r14
  7604cf:	c3                   	ret
