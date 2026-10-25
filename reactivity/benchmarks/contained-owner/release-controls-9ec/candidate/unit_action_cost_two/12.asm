
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000729e00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at>:
  729e00:	55                   	push   %rbp
  729e01:	41 57                	push   %r15
  729e03:	41 56                	push   %r14
  729e05:	41 54                	push   %r12
  729e07:	53                   	push   %rbx
  729e08:	48 83 ec 40          	sub    $0x40,%rsp
  729e0c:	44 89 cd             	mov    %r9d,%ebp
  729e0f:	4d 89 c4             	mov    %r8,%r12
  729e12:	49 89 d7             	mov    %rdx,%r15
  729e15:	49 89 f6             	mov    %rsi,%r14
  729e18:	48 89 fb             	mov    %rdi,%rbx
  729e1b:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  729e20:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  729e25:	48 89 ca             	mov    %rcx,%rdx
  729e28:	44 89 c9             	mov    %r9d,%ecx
  729e2b:	e8 50 01 00 00       	call   729f80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at>
  729e30:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  729e35:	0f 85 f8 00 00 00    	jne    729f33 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x133>
  729e3b:	4d 89 a6 60 06 00 00 	mov    %r12,0x660(%r14)
  729e42:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  729e49:	0f b7 c5             	movzwl %bp,%eax
  729e4c:	48 8d 0d e5 1a 3d 00 	lea    0x3d1ae5(%rip),%rcx        # afb938 <__frame_dummy_init_array_entry+0x10a0>
  729e53:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  729e58:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  729e5c:	74 17                	je     729e75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x75>
  729e5e:	48 89 df             	mov    %rbx,%rdi
  729e61:	4c 89 f6             	mov    %r14,%rsi
  729e64:	48 83 c4 40          	add    $0x40,%rsp
  729e68:	5b                   	pop    %rbx
  729e69:	41 5c                	pop    %r12
  729e6b:	41 5e                	pop    %r14
  729e6d:	41 5f                	pop    %r15
  729e6f:	5d                   	pop    %rbp
  729e70:	e9 0b 0e ff ff       	jmp    71ac80 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  729e75:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  729e7c:	48 85 c0             	test   %rax,%rax
  729e7f:	74 dd                	je     729e5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5e>
  729e81:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  729e88:	48 85 c9             	test   %rcx,%rcx
  729e8b:	74 71                	je     729efe <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xfe>
  729e8d:	48 89 ca             	mov    %rcx,%rdx
  729e90:	48 83 e2 07          	and    $0x7,%rdx
  729e94:	0f 84 c9 00 00 00    	je     729f63 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x163>
  729e9a:	31 f6                	xor    %esi,%esi
  729e9c:	0f 1f 40 00          	nopl   0x0(%rax)
  729ea0:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729ea7:	48 ff c6             	inc    %rsi
  729eaa:	48 39 f2             	cmp    %rsi,%rdx
  729ead:	75 f1                	jne    729ea0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0>
  729eaf:	48 89 ca             	mov    %rcx,%rdx
  729eb2:	48 29 f2             	sub    %rsi,%rdx
  729eb5:	48 83 f9 08          	cmp    $0x8,%rcx
  729eb9:	72 43                	jb     729efe <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xfe>
  729ebb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  729ec0:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729ec7:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729ece:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729ed5:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729edc:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729ee3:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729eea:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729ef1:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729ef8:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  729efc:	75 c2                	jne    729ec0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc0>
  729efe:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  729f05:	00 
  729f06:	0f 84 52 ff ff ff    	je     729e5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5e>
  729f0c:	48 83 38 00          	cmpq   $0x0,(%rax)
  729f10:	0f 85 48 ff ff ff    	jne    729e5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5e>
  729f16:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  729f1b:	4c 89 f6             	mov    %r14,%rsi
  729f1e:	4c 89 fa             	mov    %r15,%rdx
  729f21:	31 c9                	xor    %ecx,%ecx
  729f23:	e8 d8 0a fd ff       	call   6faa00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>
  729f28:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  729f2d:	0f 84 2b ff ff ff    	je     729e5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5e>
  729f33:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  729f38:	48 89 43 30          	mov    %rax,0x30(%rbx)
  729f3c:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  729f41:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  729f46:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  729f4b:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  729f4f:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  729f53:	0f 11 03             	movups %xmm0,(%rbx)
  729f56:	48 83 c4 40          	add    $0x40,%rsp
  729f5a:	5b                   	pop    %rbx
  729f5b:	41 5c                	pop    %r12
  729f5d:	41 5e                	pop    %r14
  729f5f:	41 5f                	pop    %r15
  729f61:	5d                   	pop    %rbp
  729f62:	c3                   	ret
  729f63:	48 89 ca             	mov    %rcx,%rdx
  729f66:	48 83 f9 08          	cmp    $0x8,%rcx
  729f6a:	0f 83 50 ff ff ff    	jae    729ec0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc0>
  729f70:	eb 8c                	jmp    729efe <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xfe>
