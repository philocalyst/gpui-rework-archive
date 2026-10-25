
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000072ad00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at>:
  72ad00:	55                   	push   %rbp
  72ad01:	41 57                	push   %r15
  72ad03:	41 56                	push   %r14
  72ad05:	41 54                	push   %r12
  72ad07:	53                   	push   %rbx
  72ad08:	48 83 ec 40          	sub    $0x40,%rsp
  72ad0c:	44 89 cd             	mov    %r9d,%ebp
  72ad0f:	4d 89 c4             	mov    %r8,%r12
  72ad12:	49 89 d7             	mov    %rdx,%r15
  72ad15:	49 89 f6             	mov    %rsi,%r14
  72ad18:	48 89 fb             	mov    %rdi,%rbx
  72ad1b:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  72ad20:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  72ad25:	48 89 ca             	mov    %rcx,%rdx
  72ad28:	44 89 c9             	mov    %r9d,%ecx
  72ad2b:	e8 50 01 00 00       	call   72ae80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at>
  72ad30:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  72ad35:	0f 85 f8 00 00 00    	jne    72ae33 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x133>
  72ad3b:	4d 89 a6 60 06 00 00 	mov    %r12,0x660(%r14)
  72ad42:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  72ad49:	0f b7 c5             	movzwl %bp,%eax
  72ad4c:	48 8d 0d 55 0c 3d 00 	lea    0x3d0c55(%rip),%rcx        # afb9a8 <__frame_dummy_init_array_entry+0x10a0>
  72ad53:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  72ad58:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  72ad5c:	74 17                	je     72ad75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x75>
  72ad5e:	48 89 df             	mov    %rbx,%rdi
  72ad61:	4c 89 f6             	mov    %r14,%rsi
  72ad64:	48 83 c4 40          	add    $0x40,%rsp
  72ad68:	5b                   	pop    %rbx
  72ad69:	41 5c                	pop    %r12
  72ad6b:	41 5e                	pop    %r14
  72ad6d:	41 5f                	pop    %r15
  72ad6f:	5d                   	pop    %rbp
  72ad70:	e9 1b e8 ff ff       	jmp    729590 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  72ad75:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  72ad7c:	48 85 c0             	test   %rax,%rax
  72ad7f:	74 dd                	je     72ad5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x5e>
  72ad81:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  72ad88:	48 85 c9             	test   %rcx,%rcx
  72ad8b:	74 71                	je     72adfe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xfe>
  72ad8d:	48 89 ca             	mov    %rcx,%rdx
  72ad90:	48 83 e2 07          	and    $0x7,%rdx
  72ad94:	0f 84 c9 00 00 00    	je     72ae63 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x163>
  72ad9a:	31 f6                	xor    %esi,%esi
  72ad9c:	0f 1f 40 00          	nopl   0x0(%rax)
  72ada0:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72ada7:	48 ff c6             	inc    %rsi
  72adaa:	48 39 f2             	cmp    %rsi,%rdx
  72adad:	75 f1                	jne    72ada0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xa0>
  72adaf:	48 89 ca             	mov    %rcx,%rdx
  72adb2:	48 29 f2             	sub    %rsi,%rdx
  72adb5:	48 83 f9 08          	cmp    $0x8,%rcx
  72adb9:	72 43                	jb     72adfe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xfe>
  72adbb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  72adc0:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72adc7:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72adce:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72add5:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72addc:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72ade3:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72adea:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72adf1:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72adf8:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  72adfc:	75 c2                	jne    72adc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xc0>
  72adfe:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  72ae05:	00 
  72ae06:	0f 84 52 ff ff ff    	je     72ad5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x5e>
  72ae0c:	48 83 38 00          	cmpq   $0x0,(%rax)
  72ae10:	0f 85 48 ff ff ff    	jne    72ad5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x5e>
  72ae16:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  72ae1b:	4c 89 f6             	mov    %r14,%rsi
  72ae1e:	4c 89 fa             	mov    %r15,%rdx
  72ae21:	31 c9                	xor    %ecx,%ecx
  72ae23:	e8 e8 2b fd ff       	call   6fda10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>
  72ae28:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  72ae2d:	0f 84 2b ff ff ff    	je     72ad5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x5e>
  72ae33:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  72ae38:	48 89 43 30          	mov    %rax,0x30(%rbx)
  72ae3c:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  72ae41:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  72ae46:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  72ae4b:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  72ae4f:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  72ae53:	0f 11 03             	movups %xmm0,(%rbx)
  72ae56:	48 83 c4 40          	add    $0x40,%rsp
  72ae5a:	5b                   	pop    %rbx
  72ae5b:	41 5c                	pop    %r12
  72ae5d:	41 5e                	pop    %r14
  72ae5f:	41 5f                	pop    %r15
  72ae61:	5d                   	pop    %rbp
  72ae62:	c3                   	ret
  72ae63:	48 89 ca             	mov    %rcx,%rdx
  72ae66:	48 83 f9 08          	cmp    $0x8,%rcx
  72ae6a:	0f 83 50 ff ff ff    	jae    72adc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xc0>
  72ae70:	eb 8c                	jmp    72adfe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xfe>
