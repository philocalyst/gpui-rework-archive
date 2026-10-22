
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000767d10 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::admit>:
  767d10:	53                   	push   %rbx
  767d11:	48 83 ec 10          	sub    $0x10,%rsp
  767d15:	48 89 fb             	mov    %rdi,%rbx
  767d18:	48 89 e7             	mov    %rsp,%rdi
  767d1b:	48 89 d6             	mov    %rdx,%rsi
  767d1e:	ff 51 18             	call   *0x18(%rcx)
  767d21:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  767d26:	66 0f 74 05 02 20 8f 	pcmpeqb -0x70dffe(%rip),%xmm0        # 59d30 <anon.052c13baa99450080a7488dc623138c2.75.llvm.10723869756690930045+0x180>
  767d2d:	ff 
  767d2e:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  767d32:	b8 01 00 00 00       	mov    $0x1,%eax
  767d37:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  767d3d:	75 15                	jne    767d54 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::admit+0x44>
  767d3f:	66 c7 43 08 00 00    	movw   $0x0,0x8(%rbx)
  767d45:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  767d4c:	00 
  767d4d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  767d54:	48 89 03             	mov    %rax,(%rbx)
  767d57:	48 89 d8             	mov    %rbx,%rax
  767d5a:	48 83 c4 10          	add    $0x10,%rsp
  767d5e:	5b                   	pop    %rbx
  767d5f:	c3                   	ret
