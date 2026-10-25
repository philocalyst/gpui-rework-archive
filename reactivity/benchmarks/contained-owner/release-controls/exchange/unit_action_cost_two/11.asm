
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000072ac00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at>:
  72ac00:	55                   	push   %rbp
  72ac01:	41 57                	push   %r15
  72ac03:	41 56                	push   %r14
  72ac05:	41 54                	push   %r12
  72ac07:	53                   	push   %rbx
  72ac08:	48 83 ec 40          	sub    $0x40,%rsp
  72ac0c:	44 89 cd             	mov    %r9d,%ebp
  72ac0f:	4d 89 c4             	mov    %r8,%r12
  72ac12:	49 89 d7             	mov    %rdx,%r15
  72ac15:	49 89 f6             	mov    %rsi,%r14
  72ac18:	48 89 fb             	mov    %rdi,%rbx
  72ac1b:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  72ac20:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  72ac25:	48 89 ca             	mov    %rcx,%rdx
  72ac28:	44 89 c9             	mov    %r9d,%ecx
  72ac2b:	e8 50 01 00 00       	call   72ad80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at>
  72ac30:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  72ac35:	0f 85 f8 00 00 00    	jne    72ad33 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x133>
  72ac3b:	4d 89 a6 60 06 00 00 	mov    %r12,0x660(%r14)
  72ac42:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  72ac49:	0f b7 c5             	movzwl %bp,%eax
  72ac4c:	48 8d 0d b5 0c 3d 00 	lea    0x3d0cb5(%rip),%rcx        # afb908 <__frame_dummy_init_array_entry+0x10a0>
  72ac53:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  72ac58:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  72ac5c:	74 17                	je     72ac75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x75>
  72ac5e:	48 89 df             	mov    %rbx,%rdi
  72ac61:	4c 89 f6             	mov    %r14,%rsi
  72ac64:	48 83 c4 40          	add    $0x40,%rsp
  72ac68:	5b                   	pop    %rbx
  72ac69:	41 5c                	pop    %r12
  72ac6b:	41 5e                	pop    %r14
  72ac6d:	41 5f                	pop    %r15
  72ac6f:	5d                   	pop    %rbp
  72ac70:	e9 1b e8 ff ff       	jmp    729490 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  72ac75:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  72ac7c:	48 85 c0             	test   %rax,%rax
  72ac7f:	74 dd                	je     72ac5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x5e>
  72ac81:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  72ac88:	48 85 c9             	test   %rcx,%rcx
  72ac8b:	74 71                	je     72acfe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xfe>
  72ac8d:	48 89 ca             	mov    %rcx,%rdx
  72ac90:	48 83 e2 07          	and    $0x7,%rdx
  72ac94:	0f 84 c9 00 00 00    	je     72ad63 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x163>
  72ac9a:	31 f6                	xor    %esi,%esi
  72ac9c:	0f 1f 40 00          	nopl   0x0(%rax)
  72aca0:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72aca7:	48 ff c6             	inc    %rsi
  72acaa:	48 39 f2             	cmp    %rsi,%rdx
  72acad:	75 f1                	jne    72aca0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xa0>
  72acaf:	48 89 ca             	mov    %rcx,%rdx
  72acb2:	48 29 f2             	sub    %rsi,%rdx
  72acb5:	48 83 f9 08          	cmp    $0x8,%rcx
  72acb9:	72 43                	jb     72acfe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xfe>
  72acbb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  72acc0:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72acc7:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72acce:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72acd5:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72acdc:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72ace3:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72acea:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72acf1:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72acf8:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  72acfc:	75 c2                	jne    72acc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xc0>
  72acfe:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  72ad05:	00 
  72ad06:	0f 84 52 ff ff ff    	je     72ac5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x5e>
  72ad0c:	48 83 38 00          	cmpq   $0x0,(%rax)
  72ad10:	0f 85 48 ff ff ff    	jne    72ac5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x5e>
  72ad16:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  72ad1b:	4c 89 f6             	mov    %r14,%rsi
  72ad1e:	4c 89 fa             	mov    %r15,%rdx
  72ad21:	31 c9                	xor    %ecx,%ecx
  72ad23:	e8 e8 2b fd ff       	call   6fd910 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>
  72ad28:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  72ad2d:	0f 84 2b ff ff ff    	je     72ac5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x5e>
  72ad33:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  72ad38:	48 89 43 30          	mov    %rax,0x30(%rbx)
  72ad3c:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  72ad41:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  72ad46:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  72ad4b:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  72ad4f:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  72ad53:	0f 11 03             	movups %xmm0,(%rbx)
  72ad56:	48 83 c4 40          	add    $0x40,%rsp
  72ad5a:	5b                   	pop    %rbx
  72ad5b:	41 5c                	pop    %r12
  72ad5d:	41 5e                	pop    %r14
  72ad5f:	41 5f                	pop    %r15
  72ad61:	5d                   	pop    %rbp
  72ad62:	c3                   	ret
  72ad63:	48 89 ca             	mov    %rcx,%rdx
  72ad66:	48 83 f9 08          	cmp    $0x8,%rcx
  72ad6a:	0f 83 50 ff ff ff    	jae    72acc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xc0>
  72ad70:	eb 8c                	jmp    72acfe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xfe>
