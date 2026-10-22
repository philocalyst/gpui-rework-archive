
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000072ac90 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at>:
  72ac90:	55                   	push   %rbp
  72ac91:	41 57                	push   %r15
  72ac93:	41 56                	push   %r14
  72ac95:	41 54                	push   %r12
  72ac97:	53                   	push   %rbx
  72ac98:	48 83 ec 40          	sub    $0x40,%rsp
  72ac9c:	44 89 cd             	mov    %r9d,%ebp
  72ac9f:	4d 89 c4             	mov    %r8,%r12
  72aca2:	49 89 d7             	mov    %rdx,%r15
  72aca5:	49 89 f6             	mov    %rsi,%r14
  72aca8:	48 89 fb             	mov    %rdi,%rbx
  72acab:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  72acb0:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  72acb5:	48 89 ca             	mov    %rcx,%rdx
  72acb8:	44 89 c9             	mov    %r9d,%ecx
  72acbb:	e8 50 01 00 00       	call   72ae10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at>
  72acc0:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  72acc5:	0f 85 f8 00 00 00    	jne    72adc3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x133>
  72accb:	4d 89 a6 60 06 00 00 	mov    %r12,0x660(%r14)
  72acd2:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  72acd9:	0f b7 c5             	movzwl %bp,%eax
  72acdc:	48 8d 0d 55 0c 3d 00 	lea    0x3d0c55(%rip),%rcx        # afb938 <__frame_dummy_init_array_entry+0x10a0>
  72ace3:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  72ace8:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  72acec:	74 17                	je     72ad05 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x75>
  72acee:	48 89 df             	mov    %rbx,%rdi
  72acf1:	4c 89 f6             	mov    %r14,%rsi
  72acf4:	48 83 c4 40          	add    $0x40,%rsp
  72acf8:	5b                   	pop    %rbx
  72acf9:	41 5c                	pop    %r12
  72acfb:	41 5e                	pop    %r14
  72acfd:	41 5f                	pop    %r15
  72acff:	5d                   	pop    %rbp
  72ad00:	e9 1b e8 ff ff       	jmp    729520 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  72ad05:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  72ad0c:	48 85 c0             	test   %rax,%rax
  72ad0f:	74 dd                	je     72acee <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x5e>
  72ad11:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  72ad18:	48 85 c9             	test   %rcx,%rcx
  72ad1b:	74 71                	je     72ad8e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xfe>
  72ad1d:	48 89 ca             	mov    %rcx,%rdx
  72ad20:	48 83 e2 07          	and    $0x7,%rdx
  72ad24:	0f 84 c9 00 00 00    	je     72adf3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x163>
  72ad2a:	31 f6                	xor    %esi,%esi
  72ad2c:	0f 1f 40 00          	nopl   0x0(%rax)
  72ad30:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72ad37:	48 ff c6             	inc    %rsi
  72ad3a:	48 39 f2             	cmp    %rsi,%rdx
  72ad3d:	75 f1                	jne    72ad30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xa0>
  72ad3f:	48 89 ca             	mov    %rcx,%rdx
  72ad42:	48 29 f2             	sub    %rsi,%rdx
  72ad45:	48 83 f9 08          	cmp    $0x8,%rcx
  72ad49:	72 43                	jb     72ad8e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xfe>
  72ad4b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  72ad50:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72ad57:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72ad5e:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72ad65:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72ad6c:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72ad73:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72ad7a:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72ad81:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72ad88:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  72ad8c:	75 c2                	jne    72ad50 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xc0>
  72ad8e:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  72ad95:	00 
  72ad96:	0f 84 52 ff ff ff    	je     72acee <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x5e>
  72ad9c:	48 83 38 00          	cmpq   $0x0,(%rax)
  72ada0:	0f 85 48 ff ff ff    	jne    72acee <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x5e>
  72ada6:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  72adab:	4c 89 f6             	mov    %r14,%rsi
  72adae:	4c 89 fa             	mov    %r15,%rdx
  72adb1:	31 c9                	xor    %ecx,%ecx
  72adb3:	e8 18 2c fd ff       	call   6fd9d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>
  72adb8:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  72adbd:	0f 84 2b ff ff ff    	je     72acee <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0x5e>
  72adc3:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  72adc8:	48 89 43 30          	mov    %rax,0x30(%rbx)
  72adcc:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  72add1:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  72add6:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  72addb:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  72addf:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  72ade3:	0f 11 03             	movups %xmm0,(%rbx)
  72ade6:	48 83 c4 40          	add    $0x40,%rsp
  72adea:	5b                   	pop    %rbx
  72adeb:	41 5c                	pop    %r12
  72aded:	41 5e                	pop    %r14
  72adef:	41 5f                	pop    %r15
  72adf1:	5d                   	pop    %rbp
  72adf2:	c3                   	ret
  72adf3:	48 89 ca             	mov    %rcx,%rdx
  72adf6:	48 83 f9 08          	cmp    $0x8,%rcx
  72adfa:	0f 83 50 ff ff ff    	jae    72ad50 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xc0>
  72ae00:	eb 8c                	jmp    72ad8e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at+0xfe>
