
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000075c110 <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::invoke>:
  75c110:	41 56                	push   %r14
  75c112:	53                   	push   %rbx
  75c113:	48 83 ec 18          	sub    $0x18,%rsp
  75c117:	49 89 d6             	mov    %rdx,%r14
  75c11a:	48 89 fb             	mov    %rdi,%rbx
  75c11d:	48 89 e7             	mov    %rsp,%rdi
  75c120:	48 89 d6             	mov    %rdx,%rsi
  75c123:	ff 51 18             	call   *0x18(%rcx)
  75c126:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  75c12b:	66 0f 74 05 5d e0 8f 	pcmpeqb -0x701fa3(%rip),%xmm0        # 5a190 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x330>
  75c132:	ff 
  75c133:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  75c137:	b8 01 00 00 00       	mov    $0x1,%eax
  75c13c:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  75c142:	75 0a                	jne    75c14e <<gpui::element::MethodRoute<unit_action_cost_two::Model, <unit_action_cost_two::Model>::increment> as gpui::element::Route>::invoke+0x3e>
  75c144:	41 ff 06             	incl   (%r14)
  75c147:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  75c14e:	48 89 03             	mov    %rax,(%rbx)
  75c151:	48 89 d8             	mov    %rbx,%rax
  75c154:	48 83 c4 18          	add    $0x18,%rsp
  75c158:	5b                   	pop    %rbx
  75c159:	41 5e                	pop    %r14
  75c15b:	c3                   	ret
