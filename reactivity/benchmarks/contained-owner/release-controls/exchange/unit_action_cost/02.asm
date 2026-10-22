
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

00000000007302a0 <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::invoke>:
  7302a0:	41 56                	push   %r14
  7302a2:	53                   	push   %rbx
  7302a3:	48 83 ec 18          	sub    $0x18,%rsp
  7302a7:	49 89 d6             	mov    %rdx,%r14
  7302aa:	48 89 fb             	mov    %rdi,%rbx
  7302ad:	48 89 e7             	mov    %rsp,%rdi
  7302b0:	48 89 d6             	mov    %rdx,%rsi
  7302b3:	ff 51 18             	call   *0x18(%rcx)
  7302b6:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  7302bb:	66 0f 74 05 fd 58 93 	pcmpeqb -0x6ca703(%rip),%xmm0        # 65bc0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0xd80>
  7302c2:	ff 
  7302c3:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  7302c7:	b8 01 00 00 00       	mov    $0x1,%eax
  7302cc:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  7302d2:	75 0a                	jne    7302de <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::invoke+0x3e>
  7302d4:	41 ff 06             	incl   (%r14)
  7302d7:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  7302de:	48 89 03             	mov    %rax,(%rbx)
  7302e1:	48 89 d8             	mov    %rbx,%rax
  7302e4:	48 83 c4 18          	add    $0x18,%rsp
  7302e8:	5b                   	pop    %rbx
  7302e9:	41 5e                	pop    %r14
  7302eb:	c3                   	ret
