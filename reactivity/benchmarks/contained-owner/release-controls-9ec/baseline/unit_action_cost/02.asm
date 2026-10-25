
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000072f790 <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::admit>:
  72f790:	53                   	push   %rbx
  72f791:	48 83 ec 10          	sub    $0x10,%rsp
  72f795:	48 89 fb             	mov    %rdi,%rbx
  72f798:	48 89 e7             	mov    %rsp,%rdi
  72f79b:	48 89 d6             	mov    %rdx,%rsi
  72f79e:	ff 51 18             	call   *0x18(%rcx)
  72f7a1:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  72f7a6:	66 0f 74 05 e2 62 93 	pcmpeqb -0x6c9d1e(%rip),%xmm0        # 65a90 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0xd80>
  72f7ad:	ff 
  72f7ae:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  72f7b2:	b8 01 00 00 00       	mov    $0x1,%eax
  72f7b7:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  72f7bd:	75 15                	jne    72f7d4 <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::admit+0x44>
  72f7bf:	66 c7 43 08 00 00    	movw   $0x0,0x8(%rbx)
  72f7c5:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  72f7cc:	00 
  72f7cd:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  72f7d4:	48 89 03             	mov    %rax,(%rbx)
  72f7d7:	48 89 d8             	mov    %rbx,%rax
  72f7da:	48 83 c4 10          	add    $0x10,%rsp
  72f7de:	5b                   	pop    %rbx
  72f7df:	c3                   	ret
