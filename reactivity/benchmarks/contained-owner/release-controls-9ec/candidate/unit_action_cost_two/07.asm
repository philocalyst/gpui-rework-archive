
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000075c020 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::admit>:
  75c020:	53                   	push   %rbx
  75c021:	48 83 ec 10          	sub    $0x10,%rsp
  75c025:	48 89 fb             	mov    %rdi,%rbx
  75c028:	48 89 e7             	mov    %rsp,%rdi
  75c02b:	48 89 d6             	mov    %rdx,%rsi
  75c02e:	ff 51 18             	call   *0x18(%rcx)
  75c031:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  75c036:	66 0f 74 05 52 dd 8f 	pcmpeqb -0x7022ae(%rip),%xmm0        # 59d90 <anon.052c13baa99450080a7488dc623138c2.75.llvm.10723869756690930045+0x180>
  75c03d:	ff 
  75c03e:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  75c042:	b8 01 00 00 00       	mov    $0x1,%eax
  75c047:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  75c04d:	75 15                	jne    75c064 <<gpui::element::MethodRoute<unit_action_cost_two::SecondModel, <unit_action_cost_two::SecondModel>::increment> as gpui::element::Route>::admit+0x44>
  75c04f:	66 c7 43 08 00 00    	movw   $0x0,0x8(%rbx)
  75c055:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  75c05c:	00 
  75c05d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  75c064:	48 89 03             	mov    %rax,(%rbx)
  75c067:	48 89 d8             	mov    %rbx,%rax
  75c06a:	48 83 c4 10          	add    $0x10,%rsp
  75c06e:	5b                   	pop    %rbx
  75c06f:	c3                   	ret
