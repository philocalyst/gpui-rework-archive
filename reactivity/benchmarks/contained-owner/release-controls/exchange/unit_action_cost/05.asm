
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000071ebf0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at>:
  71ebf0:	55                   	push   %rbp
  71ebf1:	41 57                	push   %r15
  71ebf3:	41 56                	push   %r14
  71ebf5:	41 54                	push   %r12
  71ebf7:	53                   	push   %rbx
  71ebf8:	48 83 ec 40          	sub    $0x40,%rsp
  71ebfc:	44 89 cd             	mov    %r9d,%ebp
  71ebff:	4d 89 c4             	mov    %r8,%r12
  71ec02:	49 89 d7             	mov    %rdx,%r15
  71ec05:	49 89 f6             	mov    %rsi,%r14
  71ec08:	48 89 fb             	mov    %rdi,%rbx
  71ec0b:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  71ec10:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  71ec15:	48 89 ca             	mov    %rcx,%rdx
  71ec18:	44 89 c9             	mov    %r9d,%ecx
  71ec1b:	e8 50 01 00 00       	call   71ed70 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at>
  71ec20:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  71ec25:	0f 85 f8 00 00 00    	jne    71ed23 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x133>
  71ec2b:	4d 89 a6 60 06 00 00 	mov    %r12,0x660(%r14)
  71ec32:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  71ec39:	0f b7 c5             	movzwl %bp,%eax
  71ec3c:	48 8d 0d 3d 5d 3b 00 	lea    0x3b5d3d(%rip),%rcx        # ad4980 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1198>
  71ec43:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  71ec48:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  71ec4c:	74 17                	je     71ec65 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x75>
  71ec4e:	48 89 df             	mov    %rbx,%rdi
  71ec51:	4c 89 f6             	mov    %r14,%rsi
  71ec54:	48 83 c4 40          	add    $0x40,%rsp
  71ec58:	5b                   	pop    %rbx
  71ec59:	41 5c                	pop    %r12
  71ec5b:	41 5e                	pop    %r14
  71ec5d:	41 5f                	pop    %r15
  71ec5f:	5d                   	pop    %rbp
  71ec60:	e9 1b f9 ff ff       	jmp    71e580 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  71ec65:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  71ec6c:	48 85 c0             	test   %rax,%rax
  71ec6f:	74 dd                	je     71ec4e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5e>
  71ec71:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  71ec78:	48 85 c9             	test   %rcx,%rcx
  71ec7b:	74 71                	je     71ecee <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xfe>
  71ec7d:	48 89 ca             	mov    %rcx,%rdx
  71ec80:	48 83 e2 07          	and    $0x7,%rdx
  71ec84:	0f 84 c9 00 00 00    	je     71ed53 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x163>
  71ec8a:	31 f6                	xor    %esi,%esi
  71ec8c:	0f 1f 40 00          	nopl   0x0(%rax)
  71ec90:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ec97:	48 ff c6             	inc    %rsi
  71ec9a:	48 39 f2             	cmp    %rsi,%rdx
  71ec9d:	75 f1                	jne    71ec90 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0>
  71ec9f:	48 89 ca             	mov    %rcx,%rdx
  71eca2:	48 29 f2             	sub    %rsi,%rdx
  71eca5:	48 83 f9 08          	cmp    $0x8,%rcx
  71eca9:	72 43                	jb     71ecee <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xfe>
  71ecab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  71ecb0:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ecb7:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ecbe:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ecc5:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71eccc:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ecd3:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ecda:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ece1:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ece8:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  71ecec:	75 c2                	jne    71ecb0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc0>
  71ecee:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  71ecf5:	00 
  71ecf6:	0f 84 52 ff ff ff    	je     71ec4e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5e>
  71ecfc:	48 83 38 00          	cmpq   $0x0,(%rax)
  71ed00:	0f 85 48 ff ff ff    	jne    71ec4e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5e>
  71ed06:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  71ed0b:	4c 89 f6             	mov    %r14,%rsi
  71ed0e:	4c 89 fa             	mov    %r15,%rdx
  71ed11:	31 c9                	xor    %ecx,%ecx
  71ed13:	e8 d8 83 fe ff       	call   7070f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>
  71ed18:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  71ed1d:	0f 84 2b ff ff ff    	je     71ec4e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5e>
  71ed23:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  71ed28:	48 89 43 30          	mov    %rax,0x30(%rbx)
  71ed2c:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  71ed31:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  71ed36:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  71ed3b:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  71ed3f:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  71ed43:	0f 11 03             	movups %xmm0,(%rbx)
  71ed46:	48 83 c4 40          	add    $0x40,%rsp
  71ed4a:	5b                   	pop    %rbx
  71ed4b:	41 5c                	pop    %r12
  71ed4d:	41 5e                	pop    %r14
  71ed4f:	41 5f                	pop    %r15
  71ed51:	5d                   	pop    %rbp
  71ed52:	c3                   	ret
  71ed53:	48 89 ca             	mov    %rcx,%rdx
  71ed56:	48 83 f9 08          	cmp    $0x8,%rcx
  71ed5a:	0f 83 50 ff ff ff    	jae    71ecb0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc0>
  71ed60:	eb 8c                	jmp    71ecee <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xfe>
