
/tmp/gpui-contained-owner-spike-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d940 <<gpui::element::PropertyRoute<property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::proposal, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::reply> as gpui::element::Route>::admit>:
  78d940:	53                   	push   %rbx
  78d941:	48 83 ec 10          	sub    $0x10,%rsp
  78d945:	48 89 fb             	mov    %rdi,%rbx
  78d948:	48 89 e7             	mov    %rsp,%rdi
  78d94b:	48 89 d6             	mov    %rdx,%rsi
  78d94e:	ff 51 18             	call   *0x18(%rcx)
  78d951:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  78d956:	66 0f 74 05 62 19 8d 	pcmpeqb -0x72e69e(%rip),%xmm0        # 5f2c0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1340>
  78d95d:	ff 
  78d95e:	66 0f d7 c8          	pmovmskb %xmm0,%ecx
  78d962:	b8 01 00 00 00       	mov    $0x1,%eax
  78d967:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  78d96d:	75 0d                	jne    78d97c <<gpui::element::PropertyRoute<property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::proposal, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::reply> as gpui::element::Route>::admit+0x3c>
  78d96f:	66 c7 43 08 02 00    	movw   $0x2,0x8(%rbx)
  78d975:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  78d97c:	48 89 03             	mov    %rax,(%rbx)
  78d97f:	48 89 d8             	mov    %rbx,%rax
  78d982:	48 83 c4 10          	add    $0x10,%rsp
  78d986:	5b                   	pop    %rbx
  78d987:	c3                   	ret
