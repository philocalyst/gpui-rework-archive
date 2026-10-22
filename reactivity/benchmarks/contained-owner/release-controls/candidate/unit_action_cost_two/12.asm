
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000729e70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at>:
  729e70:	55                   	push   %rbp
  729e71:	41 57                	push   %r15
  729e73:	41 56                	push   %r14
  729e75:	41 54                	push   %r12
  729e77:	53                   	push   %rbx
  729e78:	48 83 ec 40          	sub    $0x40,%rsp
  729e7c:	44 89 cd             	mov    %r9d,%ebp
  729e7f:	4d 89 c4             	mov    %r8,%r12
  729e82:	49 89 d7             	mov    %rdx,%r15
  729e85:	49 89 f6             	mov    %rsi,%r14
  729e88:	48 89 fb             	mov    %rdi,%rbx
  729e8b:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  729e90:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  729e95:	48 89 ca             	mov    %rcx,%rdx
  729e98:	44 89 c9             	mov    %r9d,%ecx
  729e9b:	e8 50 01 00 00       	call   729ff0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at>
  729ea0:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  729ea5:	0f 85 f8 00 00 00    	jne    729fa3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x133>
  729eab:	4d 89 a6 60 06 00 00 	mov    %r12,0x660(%r14)
  729eb2:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  729eb9:	0f b7 c5             	movzwl %bp,%eax
  729ebc:	48 8d 0d e5 1a 3d 00 	lea    0x3d1ae5(%rip),%rcx        # afb9a8 <__frame_dummy_init_array_entry+0x10a0>
  729ec3:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  729ec8:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  729ecc:	74 17                	je     729ee5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x75>
  729ece:	48 89 df             	mov    %rbx,%rdi
  729ed1:	4c 89 f6             	mov    %r14,%rsi
  729ed4:	48 83 c4 40          	add    $0x40,%rsp
  729ed8:	5b                   	pop    %rbx
  729ed9:	41 5c                	pop    %r12
  729edb:	41 5e                	pop    %r14
  729edd:	41 5f                	pop    %r15
  729edf:	5d                   	pop    %rbp
  729ee0:	e9 0b 0e ff ff       	jmp    71acf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  729ee5:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  729eec:	48 85 c0             	test   %rax,%rax
  729eef:	74 dd                	je     729ece <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5e>
  729ef1:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  729ef8:	48 85 c9             	test   %rcx,%rcx
  729efb:	74 71                	je     729f6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xfe>
  729efd:	48 89 ca             	mov    %rcx,%rdx
  729f00:	48 83 e2 07          	and    $0x7,%rdx
  729f04:	0f 84 c9 00 00 00    	je     729fd3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x163>
  729f0a:	31 f6                	xor    %esi,%esi
  729f0c:	0f 1f 40 00          	nopl   0x0(%rax)
  729f10:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729f17:	48 ff c6             	inc    %rsi
  729f1a:	48 39 f2             	cmp    %rsi,%rdx
  729f1d:	75 f1                	jne    729f10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0>
  729f1f:	48 89 ca             	mov    %rcx,%rdx
  729f22:	48 29 f2             	sub    %rsi,%rdx
  729f25:	48 83 f9 08          	cmp    $0x8,%rcx
  729f29:	72 43                	jb     729f6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xfe>
  729f2b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  729f30:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729f37:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729f3e:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729f45:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729f4c:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729f53:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729f5a:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729f61:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729f68:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  729f6c:	75 c2                	jne    729f30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc0>
  729f6e:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  729f75:	00 
  729f76:	0f 84 52 ff ff ff    	je     729ece <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5e>
  729f7c:	48 83 38 00          	cmpq   $0x0,(%rax)
  729f80:	0f 85 48 ff ff ff    	jne    729ece <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5e>
  729f86:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  729f8b:	4c 89 f6             	mov    %r14,%rsi
  729f8e:	4c 89 fa             	mov    %r15,%rdx
  729f91:	31 c9                	xor    %ecx,%ecx
  729f93:	e8 78 0a fd ff       	call   6faa10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>
  729f98:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  729f9d:	0f 84 2b ff ff ff    	je     729ece <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5e>
  729fa3:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  729fa8:	48 89 43 30          	mov    %rax,0x30(%rbx)
  729fac:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  729fb1:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  729fb6:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  729fbb:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  729fbf:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  729fc3:	0f 11 03             	movups %xmm0,(%rbx)
  729fc6:	48 83 c4 40          	add    $0x40,%rsp
  729fca:	5b                   	pop    %rbx
  729fcb:	41 5c                	pop    %r12
  729fcd:	41 5e                	pop    %r14
  729fcf:	41 5f                	pop    %r15
  729fd1:	5d                   	pop    %rbp
  729fd2:	c3                   	ret
  729fd3:	48 89 ca             	mov    %rcx,%rdx
  729fd6:	48 83 f9 08          	cmp    $0x8,%rcx
  729fda:	0f 83 50 ff ff ff    	jae    729f30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc0>
  729fe0:	eb 8c                	jmp    729f6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xfe>
