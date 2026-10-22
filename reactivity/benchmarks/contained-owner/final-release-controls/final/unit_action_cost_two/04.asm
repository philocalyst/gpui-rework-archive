
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000767e00 <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::invoke>:
  767e00:	41 56                	push   %r14
  767e02:	53                   	push   %rbx
  767e03:	48 83 ec 18          	sub    $0x18,%rsp
  767e07:	49 89 d6             	mov    %rdx,%r14
  767e0a:	48 89 fb             	mov    %rdi,%rbx
  767e0d:	48 89 e7             	mov    %rsp,%rdi
  767e10:	48 89 d6             	mov    %rdx,%rsi
  767e13:	ff 51 18             	call   *0x18(%rcx)
  767e16:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  767e1b:	66 0f 74 05 0d 23 8f 	pcmpeqb -0x70dcf3(%rip),%xmm0        # 5a130 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x330>
  767e22:	ff 
  767e23:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  767e27:	b8 01 00 00 00       	mov    $0x1,%eax
  767e2c:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  767e32:	75 0a                	jne    767e3e <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::invoke+0x3e>
  767e34:	41 ff 06             	incl   (%r14)
  767e37:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  767e3e:	48 89 03             	mov    %rax,(%rbx)
  767e41:	48 89 d8             	mov    %rbx,%rax
  767e44:	48 83 c4 18          	add    $0x18,%rsp
  767e48:	5b                   	pop    %rbx
  767e49:	41 5e                	pop    %r14
  767e4b:	c3                   	ret
