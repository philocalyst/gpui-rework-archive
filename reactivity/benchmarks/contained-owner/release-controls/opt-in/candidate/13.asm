
/tmp/gpui-contained-owner-spike-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d8f0 <<gpui::element::PropertyRoute<property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::proposal, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::reply> as gpui::element::Route>::applied_logically>:
  78d8f0:	41 56                	push   %r14
  78d8f2:	53                   	push   %rbx
  78d8f3:	48 83 ec 18          	sub    $0x18,%rsp
  78d8f7:	49 89 d6             	mov    %rdx,%r14
  78d8fa:	48 89 fb             	mov    %rdi,%rbx
  78d8fd:	48 89 e7             	mov    %rsp,%rdi
  78d900:	48 89 d6             	mov    %rdx,%rsi
  78d903:	ff 51 18             	call   *0x18(%rcx)
  78d906:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  78d90b:	66 0f 74 05 ad 19 8d 	pcmpeqb -0x72e653(%rip),%xmm0        # 5f2c0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1340>
  78d912:	ff 
  78d913:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  78d917:	b8 01 00 00 00       	mov    $0x1,%eax
  78d91c:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  78d922:	75 0b                	jne    78d92f <<gpui::element::PropertyRoute<property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::proposal, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::reply> as gpui::element::Route>::applied_logically+0x3f>
  78d924:	41 ff 46 10          	incl   0x10(%r14)
  78d928:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  78d92f:	48 89 03             	mov    %rax,(%rbx)
  78d932:	48 89 d8             	mov    %rbx,%rax
  78d935:	48 83 c4 18          	add    $0x18,%rsp
  78d939:	5b                   	pop    %rbx
  78d93a:	41 5e                	pop    %r14
  78d93c:	c3                   	ret
