
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000075c130 <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::admit>:
  75c130:	53                   	push   %rbx
  75c131:	48 83 ec 10          	sub    $0x10,%rsp
  75c135:	48 89 fb             	mov    %rdi,%rbx
  75c138:	48 89 e7             	mov    %rsp,%rdi
  75c13b:	48 89 d6             	mov    %rdx,%rsi
  75c13e:	ff 51 18             	call   *0x18(%rcx)
  75c141:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  75c146:	66 0f 74 05 52 e0 8f 	pcmpeqb -0x701fae(%rip),%xmm0        # 5a1a0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x330>
  75c14d:	ff 
  75c14e:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  75c152:	b8 01 00 00 00       	mov    $0x1,%eax
  75c157:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  75c15d:	75 15                	jne    75c174 <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::admit+0x44>
  75c15f:	66 c7 43 08 00 00    	movw   $0x0,0x8(%rbx)
  75c165:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  75c16c:	00 
  75c16d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  75c174:	48 89 03             	mov    %rax,(%rbx)
  75c177:	48 89 d8             	mov    %rbx,%rax
  75c17a:	48 83 c4 10          	add    $0x10,%rsp
  75c17e:	5b                   	pop    %rbx
  75c17f:	c3                   	ret
