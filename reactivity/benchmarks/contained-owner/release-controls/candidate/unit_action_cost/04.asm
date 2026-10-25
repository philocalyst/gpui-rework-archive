
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

0000000000730360 <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::admit>:
  730360:	53                   	push   %rbx
  730361:	48 83 ec 10          	sub    $0x10,%rsp
  730365:	48 89 fb             	mov    %rdi,%rbx
  730368:	48 89 e7             	mov    %rsp,%rdi
  73036b:	48 89 d6             	mov    %rdx,%rsi
  73036e:	ff 51 18             	call   *0x18(%rcx)
  730371:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  730376:	66 0f 74 05 a2 58 93 	pcmpeqb -0x6ca75e(%rip),%xmm0        # 65c20 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0xd80>
  73037d:	ff 
  73037e:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  730382:	b8 01 00 00 00       	mov    $0x1,%eax
  730387:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  73038d:	75 15                	jne    7303a4 <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::admit+0x44>
  73038f:	66 c7 43 08 00 00    	movw   $0x0,0x8(%rbx)
  730395:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  73039c:	00 
  73039d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  7303a4:	48 89 03             	mov    %rax,(%rbx)
  7303a7:	48 89 d8             	mov    %rbx,%rax
  7303aa:	48 83 c4 10          	add    $0x10,%rsp
  7303ae:	5b                   	pop    %rbx
  7303af:	c3                   	ret
