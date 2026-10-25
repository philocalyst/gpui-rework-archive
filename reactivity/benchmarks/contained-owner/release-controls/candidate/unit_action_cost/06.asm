
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000071ed00 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at>:
  71ed00:	55                   	push   %rbp
  71ed01:	41 57                	push   %r15
  71ed03:	41 56                	push   %r14
  71ed05:	41 54                	push   %r12
  71ed07:	53                   	push   %rbx
  71ed08:	48 83 ec 40          	sub    $0x40,%rsp
  71ed0c:	44 89 cd             	mov    %r9d,%ebp
  71ed0f:	4d 89 c4             	mov    %r8,%r12
  71ed12:	49 89 d7             	mov    %rdx,%r15
  71ed15:	49 89 f6             	mov    %rsi,%r14
  71ed18:	48 89 fb             	mov    %rdi,%rbx
  71ed1b:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  71ed20:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  71ed25:	48 89 ca             	mov    %rcx,%rdx
  71ed28:	44 89 c9             	mov    %r9d,%ecx
  71ed2b:	e8 50 01 00 00       	call   71ee80 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at>
  71ed30:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  71ed35:	0f 85 f8 00 00 00    	jne    71ee33 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x133>
  71ed3b:	4d 89 a6 60 06 00 00 	mov    %r12,0x660(%r14)
  71ed42:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  71ed49:	0f b7 c5             	movzwl %bp,%eax
  71ed4c:	48 8d 0d ed 5c 3b 00 	lea    0x3b5ced(%rip),%rcx        # ad4a40 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1198>
  71ed53:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  71ed58:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  71ed5c:	74 17                	je     71ed75 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x75>
  71ed5e:	48 89 df             	mov    %rbx,%rdi
  71ed61:	4c 89 f6             	mov    %r14,%rsi
  71ed64:	48 83 c4 40          	add    $0x40,%rsp
  71ed68:	5b                   	pop    %rbx
  71ed69:	41 5c                	pop    %r12
  71ed6b:	41 5e                	pop    %r14
  71ed6d:	41 5f                	pop    %r15
  71ed6f:	5d                   	pop    %rbp
  71ed70:	e9 1b f9 ff ff       	jmp    71e690 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  71ed75:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  71ed7c:	48 85 c0             	test   %rax,%rax
  71ed7f:	74 dd                	je     71ed5e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5e>
  71ed81:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  71ed88:	48 85 c9             	test   %rcx,%rcx
  71ed8b:	74 71                	je     71edfe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xfe>
  71ed8d:	48 89 ca             	mov    %rcx,%rdx
  71ed90:	48 83 e2 07          	and    $0x7,%rdx
  71ed94:	0f 84 c9 00 00 00    	je     71ee63 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x163>
  71ed9a:	31 f6                	xor    %esi,%esi
  71ed9c:	0f 1f 40 00          	nopl   0x0(%rax)
  71eda0:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71eda7:	48 ff c6             	inc    %rsi
  71edaa:	48 39 f2             	cmp    %rsi,%rdx
  71edad:	75 f1                	jne    71eda0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0>
  71edaf:	48 89 ca             	mov    %rcx,%rdx
  71edb2:	48 29 f2             	sub    %rsi,%rdx
  71edb5:	48 83 f9 08          	cmp    $0x8,%rcx
  71edb9:	72 43                	jb     71edfe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xfe>
  71edbb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  71edc0:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71edc7:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71edce:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71edd5:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71eddc:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ede3:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71edea:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71edf1:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71edf8:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  71edfc:	75 c2                	jne    71edc0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc0>
  71edfe:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  71ee05:	00 
  71ee06:	0f 84 52 ff ff ff    	je     71ed5e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5e>
  71ee0c:	48 83 38 00          	cmpq   $0x0,(%rax)
  71ee10:	0f 85 48 ff ff ff    	jne    71ed5e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5e>
  71ee16:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  71ee1b:	4c 89 f6             	mov    %r14,%rsi
  71ee1e:	4c 89 fa             	mov    %r15,%rdx
  71ee21:	31 c9                	xor    %ecx,%ecx
  71ee23:	e8 d8 83 fe ff       	call   707200 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>
  71ee28:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  71ee2d:	0f 84 2b ff ff ff    	je     71ed5e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5e>
  71ee33:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  71ee38:	48 89 43 30          	mov    %rax,0x30(%rbx)
  71ee3c:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  71ee41:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  71ee46:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  71ee4b:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  71ee4f:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  71ee53:	0f 11 03             	movups %xmm0,(%rbx)
  71ee56:	48 83 c4 40          	add    $0x40,%rsp
  71ee5a:	5b                   	pop    %rbx
  71ee5b:	41 5c                	pop    %r12
  71ee5d:	41 5e                	pop    %r14
  71ee5f:	41 5f                	pop    %r15
  71ee61:	5d                   	pop    %rbp
  71ee62:	c3                   	ret
  71ee63:	48 89 ca             	mov    %rcx,%rdx
  71ee66:	48 83 f9 08          	cmp    $0x8,%rcx
  71ee6a:	0f 83 50 ff ff ff    	jae    71edc0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc0>
  71ee70:	eb 8c                	jmp    71edfe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xfe>
