
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

00000000007303b0 <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::invoke>:
  7303b0:	41 56                	push   %r14
  7303b2:	53                   	push   %rbx
  7303b3:	48 83 ec 18          	sub    $0x18,%rsp
  7303b7:	49 89 d6             	mov    %rdx,%r14
  7303ba:	48 89 fb             	mov    %rdi,%rbx
  7303bd:	48 89 e7             	mov    %rsp,%rdi
  7303c0:	48 89 d6             	mov    %rdx,%rsi
  7303c3:	ff 51 18             	call   *0x18(%rcx)
  7303c6:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  7303cb:	66 0f 74 05 4d 58 93 	pcmpeqb -0x6ca7b3(%rip),%xmm0        # 65c20 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0xd80>
  7303d2:	ff 
  7303d3:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  7303d7:	b8 01 00 00 00       	mov    $0x1,%eax
  7303dc:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  7303e2:	75 0a                	jne    7303ee <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::invoke+0x3e>
  7303e4:	41 ff 06             	incl   (%r14)
  7303e7:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  7303ee:	48 89 03             	mov    %rax,(%rbx)
  7303f1:	48 89 d8             	mov    %rbx,%rax
  7303f4:	48 83 c4 18          	add    $0x18,%rsp
  7303f8:	5b                   	pop    %rbx
  7303f9:	41 5e                	pop    %r14
  7303fb:	c3                   	ret
