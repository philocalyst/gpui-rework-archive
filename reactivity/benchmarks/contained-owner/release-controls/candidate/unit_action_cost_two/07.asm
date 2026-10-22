
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000075c090 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::admit>:
  75c090:	53                   	push   %rbx
  75c091:	48 83 ec 10          	sub    $0x10,%rsp
  75c095:	48 89 fb             	mov    %rdi,%rbx
  75c098:	48 89 e7             	mov    %rsp,%rdi
  75c09b:	48 89 d6             	mov    %rdx,%rsi
  75c09e:	ff 51 18             	call   *0x18(%rcx)
  75c0a1:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  75c0a6:	66 0f 74 05 f2 dc 8f 	pcmpeqb -0x70230e(%rip),%xmm0        # 59da0 <anon.052c13baa99450080a7488dc623138c2.75.llvm.10723869756690930045+0x180>
  75c0ad:	ff 
  75c0ae:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  75c0b2:	b8 01 00 00 00       	mov    $0x1,%eax
  75c0b7:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  75c0bd:	75 15                	jne    75c0d4 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::admit+0x44>
  75c0bf:	66 c7 43 08 00 00    	movw   $0x0,0x8(%rbx)
  75c0c5:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  75c0cc:	00 
  75c0cd:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  75c0d4:	48 89 03             	mov    %rax,(%rbx)
  75c0d7:	48 89 d8             	mov    %rbx,%rax
  75c0da:	48 83 c4 10          	add    $0x10,%rsp
  75c0de:	5b                   	pop    %rbx
  75c0df:	c3                   	ret
