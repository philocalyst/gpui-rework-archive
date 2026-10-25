
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000071ecd0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at>:
  71ecd0:	55                   	push   %rbp
  71ecd1:	41 57                	push   %r15
  71ecd3:	41 56                	push   %r14
  71ecd5:	41 54                	push   %r12
  71ecd7:	53                   	push   %rbx
  71ecd8:	48 83 ec 40          	sub    $0x40,%rsp
  71ecdc:	44 89 cd             	mov    %r9d,%ebp
  71ecdf:	4d 89 c4             	mov    %r8,%r12
  71ece2:	49 89 d7             	mov    %rdx,%r15
  71ece5:	49 89 f6             	mov    %rsi,%r14
  71ece8:	48 89 fb             	mov    %rdi,%rbx
  71eceb:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  71ecf0:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  71ecf5:	48 89 ca             	mov    %rcx,%rdx
  71ecf8:	44 89 c9             	mov    %r9d,%ecx
  71ecfb:	e8 50 01 00 00       	call   71ee50 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at>
  71ed00:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  71ed05:	0f 85 f8 00 00 00    	jne    71ee03 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x133>
  71ed0b:	4d 89 a6 60 06 00 00 	mov    %r12,0x660(%r14)
  71ed12:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  71ed19:	0f b7 c5             	movzwl %bp,%eax
  71ed1c:	48 8d 0d ed 5c 3b 00 	lea    0x3b5ced(%rip),%rcx        # ad4a10 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1198>
  71ed23:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  71ed28:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  71ed2c:	74 17                	je     71ed45 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x75>
  71ed2e:	48 89 df             	mov    %rbx,%rdi
  71ed31:	4c 89 f6             	mov    %r14,%rsi
  71ed34:	48 83 c4 40          	add    $0x40,%rsp
  71ed38:	5b                   	pop    %rbx
  71ed39:	41 5c                	pop    %r12
  71ed3b:	41 5e                	pop    %r14
  71ed3d:	41 5f                	pop    %r15
  71ed3f:	5d                   	pop    %rbp
  71ed40:	e9 1b f9 ff ff       	jmp    71e660 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  71ed45:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  71ed4c:	48 85 c0             	test   %rax,%rax
  71ed4f:	74 dd                	je     71ed2e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5e>
  71ed51:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  71ed58:	48 85 c9             	test   %rcx,%rcx
  71ed5b:	74 71                	je     71edce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xfe>
  71ed5d:	48 89 ca             	mov    %rcx,%rdx
  71ed60:	48 83 e2 07          	and    $0x7,%rdx
  71ed64:	0f 84 c9 00 00 00    	je     71ee33 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x163>
  71ed6a:	31 f6                	xor    %esi,%esi
  71ed6c:	0f 1f 40 00          	nopl   0x0(%rax)
  71ed70:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ed77:	48 ff c6             	inc    %rsi
  71ed7a:	48 39 f2             	cmp    %rsi,%rdx
  71ed7d:	75 f1                	jne    71ed70 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0>
  71ed7f:	48 89 ca             	mov    %rcx,%rdx
  71ed82:	48 29 f2             	sub    %rsi,%rdx
  71ed85:	48 83 f9 08          	cmp    $0x8,%rcx
  71ed89:	72 43                	jb     71edce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xfe>
  71ed8b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  71ed90:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ed97:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ed9e:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71eda5:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71edac:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71edb3:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71edba:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71edc1:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71edc8:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  71edcc:	75 c2                	jne    71ed90 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc0>
  71edce:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  71edd5:	00 
  71edd6:	0f 84 52 ff ff ff    	je     71ed2e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5e>
  71eddc:	48 83 38 00          	cmpq   $0x0,(%rax)
  71ede0:	0f 85 48 ff ff ff    	jne    71ed2e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5e>
  71ede6:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  71edeb:	4c 89 f6             	mov    %r14,%rsi
  71edee:	4c 89 fa             	mov    %r15,%rdx
  71edf1:	31 c9                	xor    %ecx,%ecx
  71edf3:	e8 08 84 fe ff       	call   707200 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>
  71edf8:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  71edfd:	0f 84 2b ff ff ff    	je     71ed2e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5e>
  71ee03:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  71ee08:	48 89 43 30          	mov    %rax,0x30(%rbx)
  71ee0c:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  71ee11:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  71ee16:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  71ee1b:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  71ee1f:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  71ee23:	0f 11 03             	movups %xmm0,(%rbx)
  71ee26:	48 83 c4 40          	add    $0x40,%rsp
  71ee2a:	5b                   	pop    %rbx
  71ee2b:	41 5c                	pop    %r12
  71ee2d:	41 5e                	pop    %r14
  71ee2f:	41 5f                	pop    %r15
  71ee31:	5d                   	pop    %rbp
  71ee32:	c3                   	ret
  71ee33:	48 89 ca             	mov    %rcx,%rdx
  71ee36:	48 83 f9 08          	cmp    $0x8,%rcx
  71ee3a:	0f 83 50 ff ff ff    	jae    71ed90 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc0>
  71ee40:	eb 8c                	jmp    71edce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xfe>
