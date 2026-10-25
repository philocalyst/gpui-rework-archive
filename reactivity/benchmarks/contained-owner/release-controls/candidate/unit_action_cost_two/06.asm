
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000075c180 <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::invoke>:
  75c180:	41 56                	push   %r14
  75c182:	53                   	push   %rbx
  75c183:	48 83 ec 18          	sub    $0x18,%rsp
  75c187:	49 89 d6             	mov    %rdx,%r14
  75c18a:	48 89 fb             	mov    %rdi,%rbx
  75c18d:	48 89 e7             	mov    %rsp,%rdi
  75c190:	48 89 d6             	mov    %rdx,%rsi
  75c193:	ff 51 18             	call   *0x18(%rcx)
  75c196:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  75c19b:	66 0f 74 05 fd df 8f 	pcmpeqb -0x702003(%rip),%xmm0        # 5a1a0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x330>
  75c1a2:	ff 
  75c1a3:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  75c1a7:	b8 01 00 00 00       	mov    $0x1,%eax
  75c1ac:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  75c1b2:	75 0a                	jne    75c1be <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::invoke+0x3e>
  75c1b4:	41 ff 06             	incl   (%r14)
  75c1b7:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  75c1be:	48 89 03             	mov    %rax,(%rbx)
  75c1c1:	48 89 d8             	mov    %rbx,%rax
  75c1c4:	48 83 c4 18          	add    $0x18,%rsp
  75c1c8:	5b                   	pop    %rbx
  75c1c9:	41 5e                	pop    %r14
  75c1cb:	c3                   	ret
