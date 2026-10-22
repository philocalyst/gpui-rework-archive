
/tmp/gpui-contained-property-exchange-target/release/deps/property_actions-e550015686cf69d3:     file format elf64-x86-64


Disassembly of section .text:

000000000078d720 <<gpui::element::PropertyRoute<property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::proposal, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::reply> as gpui::element::Route>::property>:
  78d720:	41 57                	push   %r15
  78d722:	41 56                	push   %r14
  78d724:	41 55                	push   %r13
  78d726:	41 54                	push   %r12
  78d728:	53                   	push   %rbx
  78d729:	48 83 ec 10          	sub    $0x10,%rsp
  78d72d:	48 89 fb             	mov    %rdi,%rbx
  78d730:	49 bf e1 a7 d1 de ba 	movabs $0x856efbaded1a7e1,%r15
  78d737:	ef 56 08 
  78d73a:	49 bc 06 7f d0 91 8d 	movabs $0x773b758d91d07f06,%r12
  78d741:	75 3b 77 
  78d744:	83 3a 01             	cmpl   $0x1,(%rdx)
  78d747:	75 2a                	jne    78d773 <<gpui::element::PropertyRoute<property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::proposal, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::reply> as gpui::element::Route>::property+0x53>
  78d749:	4c 8b 72 10          	mov    0x10(%rdx),%r14
  78d74d:	48 8b 42 18          	mov    0x18(%rdx),%rax
  78d751:	48 89 e7             	mov    %rsp,%rdi
  78d754:	4c 89 f6             	mov    %r14,%rsi
  78d757:	ff 50 18             	call   *0x18(%rax)
  78d75a:	4c 33 7c 24 08       	xor    0x8(%rsp),%r15
  78d75f:	4c 33 24 24          	xor    (%rsp),%r12
  78d763:	4d 09 fc             	or     %r15,%r12
  78d766:	b8 01 00 00 00       	mov    $0x1,%eax
  78d76b:	75 64                	jne    78d7d1 <<gpui::element::PropertyRoute<property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::proposal, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::reply> as gpui::element::Route>::property+0xb1>
  78d76d:	41 ff 46 10          	incl   0x10(%r14)
  78d771:	eb 57                	jmp    78d7ca <<gpui::element::PropertyRoute<property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::proposal, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::reply> as gpui::element::Route>::property+0xaa>
  78d773:	4c 8b 72 08          	mov    0x8(%rdx),%r14
  78d777:	48 8b 42 10          	mov    0x10(%rdx),%rax
  78d77b:	4c 8b 6a 18          	mov    0x18(%rdx),%r13
  78d77f:	48 89 e7             	mov    %rsp,%rdi
  78d782:	4c 89 f6             	mov    %r14,%rsi
  78d785:	ff 50 18             	call   *0x18(%rax)
  78d788:	4c 33 7c 24 08       	xor    0x8(%rsp),%r15
  78d78d:	4c 33 24 24          	xor    (%rsp),%r12
  78d791:	4d 09 fc             	or     %r15,%r12
  78d794:	b8 01 00 00 00       	mov    $0x1,%eax
  78d799:	75 36                	jne    78d7d1 <<gpui::element::PropertyRoute<property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::proposal, <property_actions::post_mutation_projection_rejection_quarantines_instead_of_leaving_live_l::Child>::reply> as gpui::element::Route>::property+0xb1>
  78d79b:	49 8b 06             	mov    (%r14),%rax
  78d79e:	49 8b 4e 08          	mov    0x8(%r14),%rcx
  78d7a2:	31 d2                	xor    %edx,%edx
  78d7a4:	48 85 c0             	test   %rax,%rax
  78d7a7:	0f 95 c2             	setne  %dl
  78d7aa:	49 89 45 00          	mov    %rax,0x0(%r13)
  78d7ae:	49 89 4d 08          	mov    %rcx,0x8(%r13)
  78d7b2:	66 41 89 55 10       	mov    %dx,0x10(%r13)
  78d7b7:	41 c6 45 14 00       	movb   $0x0,0x14(%r13)
  78d7bc:	48 b8 01 00 00 00 00 	movabs $0x4334000000000001,%rax
  78d7c3:	00 34 43 
  78d7c6:	49 89 45 18          	mov    %rax,0x18(%r13)
  78d7ca:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  78d7d1:	48 89 03             	mov    %rax,(%rbx)
  78d7d4:	48 89 d8             	mov    %rbx,%rax
  78d7d7:	48 83 c4 10          	add    $0x10,%rsp
  78d7db:	5b                   	pop    %rbx
  78d7dc:	41 5c                	pop    %r12
  78d7de:	41 5d                	pop    %r13
  78d7e0:	41 5e                	pop    %r14
  78d7e2:	41 5f                	pop    %r15
  78d7e4:	c3                   	ret
