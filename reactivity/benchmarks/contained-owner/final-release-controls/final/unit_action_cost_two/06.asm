
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000767d60 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::invoke>:
  767d60:	41 56                	push   %r14
  767d62:	53                   	push   %rbx
  767d63:	48 83 ec 18          	sub    $0x18,%rsp
  767d67:	49 89 d6             	mov    %rdx,%r14
  767d6a:	48 89 fb             	mov    %rdi,%rbx
  767d6d:	48 89 e7             	mov    %rsp,%rdi
  767d70:	48 89 d6             	mov    %rdx,%rsi
  767d73:	ff 51 18             	call   *0x18(%rcx)
  767d76:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  767d7b:	66 0f 74 05 ad 1f 8f 	pcmpeqb -0x70e053(%rip),%xmm0        # 59d30 <anon.052c13baa99450080a7488dc623138c2.75.llvm.10723869756690930045+0x180>
  767d82:	ff 
  767d83:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  767d87:	b8 01 00 00 00       	mov    $0x1,%eax
  767d8c:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  767d92:	75 0e                	jne    767da2 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::invoke+0x42>
  767d94:	41 ff 86 00 01 00 00 	incl   0x100(%r14)
  767d9b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  767da2:	48 89 03             	mov    %rax,(%rbx)
  767da5:	48 89 d8             	mov    %rbx,%rax
  767da8:	48 83 c4 18          	add    $0x18,%rsp
  767dac:	5b                   	pop    %rbx
  767dad:	41 5e                	pop    %r14
  767daf:	c3                   	ret
