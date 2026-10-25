
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000767db0 <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::admit>:
  767db0:	53                   	push   %rbx
  767db1:	48 83 ec 10          	sub    $0x10,%rsp
  767db5:	48 89 fb             	mov    %rdi,%rbx
  767db8:	48 89 e7             	mov    %rsp,%rdi
  767dbb:	48 89 d6             	mov    %rdx,%rsi
  767dbe:	ff 51 18             	call   *0x18(%rcx)
  767dc1:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  767dc6:	66 0f 74 05 62 23 8f 	pcmpeqb -0x70dc9e(%rip),%xmm0        # 5a130 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x330>
  767dcd:	ff 
  767dce:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  767dd2:	b8 01 00 00 00       	mov    $0x1,%eax
  767dd7:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  767ddd:	75 15                	jne    767df4 <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::admit+0x44>
  767ddf:	66 c7 43 08 00 00    	movw   $0x0,0x8(%rbx)
  767de5:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  767dec:	00 
  767ded:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  767df4:	48 89 03             	mov    %rax,(%rbx)
  767df7:	48 89 d8             	mov    %rbx,%rax
  767dfa:	48 83 c4 10          	add    $0x10,%rsp
  767dfe:	5b                   	pop    %rbx
  767dff:	c3                   	ret
