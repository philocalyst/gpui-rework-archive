
/tmp/gpui-contained-owner-spike-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d990 <<gpui::element::PropertyRoute<property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::proposal, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::reply> as gpui::element::Route>::proposal>:
  78d990:	41 56                	push   %r14
  78d992:	53                   	push   %rbx
  78d993:	48 83 ec 18          	sub    $0x18,%rsp
  78d997:	49 89 d6             	mov    %rdx,%r14
  78d99a:	48 89 fb             	mov    %rdi,%rbx
  78d99d:	48 89 e7             	mov    %rsp,%rdi
  78d9a0:	48 89 d6             	mov    %rdx,%rsi
  78d9a3:	ff 51 18             	call   *0x18(%rcx)
  78d9a6:	66 0f 6f 04 24       	movdqa (%rsp),%xmm0
  78d9ab:	66 0f 74 05 0d 19 8d 	pcmpeqb -0x72e6f3(%rip),%xmm0        # 5f2c0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1340>
  78d9b2:	ff 
  78d9b3:	66 0f d7 c0          	pmovmskb %xmm0,%eax
  78d9b7:	3d ff ff 00 00       	cmp    $0xffff,%eax
  78d9bc:	75 2a                	jne    78d9e8 <<gpui::element::PropertyRoute<property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::proposal, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::reply> as gpui::element::Route>::proposal+0x58>
  78d9be:	49 8b 0e             	mov    (%r14),%rcx
  78d9c1:	49 8b 56 08          	mov    0x8(%r14),%rdx
  78d9c5:	31 c0                	xor    %eax,%eax
  78d9c7:	48 85 c9             	test   %rcx,%rcx
  78d9ca:	0f 95 c0             	setne  %al
  78d9cd:	48 89 0b             	mov    %rcx,(%rbx)
  78d9d0:	48 89 53 08          	mov    %rdx,0x8(%rbx)
  78d9d4:	c6 43 14 00          	movb   $0x0,0x14(%rbx)
  78d9d8:	48 b9 01 00 00 00 00 	movabs $0x4334000000000001,%rcx
  78d9df:	00 34 43 
  78d9e2:	48 89 4b 18          	mov    %rcx,0x18(%rbx)
  78d9e6:	eb 0c                	jmp    78d9f4 <<gpui::element::PropertyRoute<property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::proposal, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::reply> as gpui::element::Route>::proposal+0x64>
  78d9e8:	48 c7 43 18 01 00 00 	movq   $0x1,0x18(%rbx)
  78d9ef:	00 
  78d9f0:	66 b8 ff ff          	mov    $0xffff,%ax
  78d9f4:	66 89 43 10          	mov    %ax,0x10(%rbx)
  78d9f8:	48 89 d8             	mov    %rbx,%rax
  78d9fb:	48 83 c4 18          	add    $0x18,%rsp
  78d9ff:	5b                   	pop    %rbx
  78da00:	41 5e                	pop    %r14
  78da02:	c3                   	ret
