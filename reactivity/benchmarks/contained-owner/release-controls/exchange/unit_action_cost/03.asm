
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

0000000000730250 <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::admit>:
  730250:	53                   	push   %rbx
  730251:	48 83 ec 10          	sub    $0x10,%rsp
  730255:	48 89 fb             	mov    %rdi,%rbx
  730258:	48 89 e7             	mov    %rsp,%rdi
  73025b:	48 89 d6             	mov    %rdx,%rsi
  73025e:	ff 51 18             	call   *0x18(%rcx)
  730261:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  730266:	66 0f 74 05 52 59 93 	pcmpeqb -0x6ca6ae(%rip),%xmm0        # 65bc0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0xd80>
  73026d:	ff 
  73026e:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  730272:	b8 01 00 00 00       	mov    $0x1,%eax
  730277:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  73027d:	75 15                	jne    730294 <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::admit+0x44>
  73027f:	66 c7 43 08 00 00    	movw   $0x0,0x8(%rbx)
  730285:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  73028c:	00 
  73028d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  730294:	48 89 03             	mov    %rax,(%rbx)
  730297:	48 89 d8             	mov    %rbx,%rax
  73029a:	48 83 c4 10          	add    $0x10,%rsp
  73029e:	5b                   	pop    %rbx
  73029f:	c3                   	ret
