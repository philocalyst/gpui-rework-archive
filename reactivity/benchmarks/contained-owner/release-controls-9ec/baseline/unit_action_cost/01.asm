
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000072f7e0 <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::invoke>:
  72f7e0:	41 56                	push   %r14
  72f7e2:	53                   	push   %rbx
  72f7e3:	48 83 ec 18          	sub    $0x18,%rsp
  72f7e7:	49 89 d6             	mov    %rdx,%r14
  72f7ea:	48 89 fb             	mov    %rdi,%rbx
  72f7ed:	48 89 e7             	mov    %rsp,%rdi
  72f7f0:	48 89 d6             	mov    %rdx,%rsi
  72f7f3:	ff 51 18             	call   *0x18(%rcx)
  72f7f6:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  72f7fb:	66 0f 74 05 8d 62 93 	pcmpeqb -0x6c9d73(%rip),%xmm0        # 65a90 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0xd80>
  72f802:	ff 
  72f803:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  72f807:	b8 01 00 00 00       	mov    $0x1,%eax
  72f80c:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  72f812:	75 0a                	jne    72f81e <<gpui::element::MethodRoute<unit_action_cost::Model, <unit_action_cost::Model>::increment> as gpui::element::Route>::invoke+0x3e>
  72f814:	41 ff 06             	incl   (%r14)
  72f817:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  72f81e:	48 89 03             	mov    %rax,(%rbx)
  72f821:	48 89 d8             	mov    %rbx,%rax
  72f824:	48 83 c4 18          	add    $0x18,%rsp
  72f828:	5b                   	pop    %rbx
  72f829:	41 5e                	pop    %r14
  72f82b:	c3                   	ret
