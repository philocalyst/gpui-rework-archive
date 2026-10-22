
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000729d70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at>:
  729d70:	55                   	push   %rbp
  729d71:	41 57                	push   %r15
  729d73:	41 56                	push   %r14
  729d75:	41 54                	push   %r12
  729d77:	53                   	push   %rbx
  729d78:	48 83 ec 40          	sub    $0x40,%rsp
  729d7c:	44 89 cd             	mov    %r9d,%ebp
  729d7f:	4d 89 c4             	mov    %r8,%r12
  729d82:	49 89 d7             	mov    %rdx,%r15
  729d85:	49 89 f6             	mov    %rsi,%r14
  729d88:	48 89 fb             	mov    %rdi,%rbx
  729d8b:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  729d90:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  729d95:	48 89 ca             	mov    %rcx,%rdx
  729d98:	44 89 c9             	mov    %r9d,%ecx
  729d9b:	e8 50 01 00 00       	call   729ef0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at>
  729da0:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  729da5:	0f 85 f8 00 00 00    	jne    729ea3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x133>
  729dab:	4d 89 a6 60 06 00 00 	mov    %r12,0x660(%r14)
  729db2:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  729db9:	0f b7 c5             	movzwl %bp,%eax
  729dbc:	48 8d 0d 45 1b 3d 00 	lea    0x3d1b45(%rip),%rcx        # afb908 <__frame_dummy_init_array_entry+0x10a0>
  729dc3:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  729dc8:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  729dcc:	74 17                	je     729de5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x75>
  729dce:	48 89 df             	mov    %rbx,%rdi
  729dd1:	4c 89 f6             	mov    %r14,%rsi
  729dd4:	48 83 c4 40          	add    $0x40,%rsp
  729dd8:	5b                   	pop    %rbx
  729dd9:	41 5c                	pop    %r12
  729ddb:	41 5e                	pop    %r14
  729ddd:	41 5f                	pop    %r15
  729ddf:	5d                   	pop    %rbp
  729de0:	e9 0b 0e ff ff       	jmp    71abf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  729de5:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  729dec:	48 85 c0             	test   %rax,%rax
  729def:	74 dd                	je     729dce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5e>
  729df1:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  729df8:	48 85 c9             	test   %rcx,%rcx
  729dfb:	74 71                	je     729e6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xfe>
  729dfd:	48 89 ca             	mov    %rcx,%rdx
  729e00:	48 83 e2 07          	and    $0x7,%rdx
  729e04:	0f 84 c9 00 00 00    	je     729ed3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x163>
  729e0a:	31 f6                	xor    %esi,%esi
  729e0c:	0f 1f 40 00          	nopl   0x0(%rax)
  729e10:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729e17:	48 ff c6             	inc    %rsi
  729e1a:	48 39 f2             	cmp    %rsi,%rdx
  729e1d:	75 f1                	jne    729e10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0>
  729e1f:	48 89 ca             	mov    %rcx,%rdx
  729e22:	48 29 f2             	sub    %rsi,%rdx
  729e25:	48 83 f9 08          	cmp    $0x8,%rcx
  729e29:	72 43                	jb     729e6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xfe>
  729e2b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  729e30:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729e37:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729e3e:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729e45:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729e4c:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729e53:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729e5a:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729e61:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729e68:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  729e6c:	75 c2                	jne    729e30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc0>
  729e6e:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  729e75:	00 
  729e76:	0f 84 52 ff ff ff    	je     729dce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5e>
  729e7c:	48 83 38 00          	cmpq   $0x0,(%rax)
  729e80:	0f 85 48 ff ff ff    	jne    729dce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5e>
  729e86:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  729e8b:	4c 89 f6             	mov    %r14,%rsi
  729e8e:	4c 89 fa             	mov    %r15,%rdx
  729e91:	31 c9                	xor    %ecx,%ecx
  729e93:	e8 78 0a fd ff       	call   6fa910 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>
  729e98:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  729e9d:	0f 84 2b ff ff ff    	je     729dce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5e>
  729ea3:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  729ea8:	48 89 43 30          	mov    %rax,0x30(%rbx)
  729eac:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  729eb1:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  729eb6:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  729ebb:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  729ebf:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  729ec3:	0f 11 03             	movups %xmm0,(%rbx)
  729ec6:	48 83 c4 40          	add    $0x40,%rsp
  729eca:	5b                   	pop    %rbx
  729ecb:	41 5c                	pop    %r12
  729ecd:	41 5e                	pop    %r14
  729ecf:	41 5f                	pop    %r15
  729ed1:	5d                   	pop    %rbp
  729ed2:	c3                   	ret
  729ed3:	48 89 ca             	mov    %rcx,%rdx
  729ed6:	48 83 f9 08          	cmp    $0x8,%rcx
  729eda:	0f 83 50 ff ff ff    	jae    729e30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc0>
  729ee0:	eb 8c                	jmp    729e6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xfe>
