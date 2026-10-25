
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000705d30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change>:
  705d30:	41 57                	push   %r15
  705d32:	41 56                	push   %r14
  705d34:	41 54                	push   %r12
  705d36:	53                   	push   %rbx
  705d37:	50                   	push   %rax
  705d38:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  705d3f:	48 85 c0             	test   %rax,%rax
  705d42:	74 12                	je     705d56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705d44:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  705d4b:	48 85 c0             	test   %rax,%rax
  705d4e:	74 06                	je     705d56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705d50:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  705d54:	75 63                	jne    705db9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x89>
  705d56:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  705d5d:	0f b6 86 20 07 00 00 	movzbl 0x720(%rsi),%eax
  705d64:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  705d6b:	00 
  705d6c:	74 1c                	je     705d8a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x5a>
  705d6e:	84 c0                	test   %al,%al
  705d70:	74 0a                	je     705d7c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x4c>
  705d72:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  705d79:	ff 
  705d7a:	74 0e                	je     705d8a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x5a>
  705d7c:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  705d83:	b9 01 00 00 00       	mov    $0x1,%ecx
  705d88:	eb 02                	jmp    705d8c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x5c>
  705d8a:	31 c9                	xor    %ecx,%ecx
  705d8c:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  705d93:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  705d97:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  705d9b:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  705d9f:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  705da3:	88 47 30             	mov    %al,0x30(%rdi)
  705da6:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  705dad:	48 83 c4 08          	add    $0x8,%rsp
  705db1:	5b                   	pop    %rbx
  705db2:	41 5c                	pop    %r12
  705db4:	41 5e                	pop    %r14
  705db6:	41 5f                	pop    %r15
  705db8:	c3                   	ret
  705db9:	48 8b 00             	mov    (%rax),%rax
  705dbc:	4c 8b 86 e8 01 00 00 	mov    0x1e8(%rsi),%r8
  705dc3:	4d 85 c0             	test   %r8,%r8
  705dc6:	0f 84 99 00 00 00    	je     705e65 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x135>
  705dcc:	41 83 f8 01          	cmp    $0x1,%r8d
  705dd0:	0f 85 ab 00 00 00    	jne    705e81 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x151>
  705dd6:	4c 8b 96 f8 01 00 00 	mov    0x1f8(%rsi),%r10
  705ddd:	4d 85 d2             	test   %r10,%r10
  705de0:	0f 84 70 ff ff ff    	je     705d56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705de6:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  705ded:	45 31 c9             	xor    %r9d,%r9d
  705df0:	49 83 fa 01          	cmp    $0x1,%r10
  705df4:	74 2e                	je     705e24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0xf4>
  705df6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  705dfd:	00 00 00 
  705e00:	4d 89 cb             	mov    %r9,%r11
  705e03:	4c 89 d3             	mov    %r10,%rbx
  705e06:	48 d1 eb             	shr    $1,%rbx
  705e09:	49 01 d9             	add    %rbx,%r9
  705e0c:	4d 89 ce             	mov    %r9,%r14
  705e0f:	49 c1 e6 04          	shl    $0x4,%r14
  705e13:	4b 39 04 30          	cmp    %rax,(%r8,%r14,1)
  705e17:	4d 0f 47 cb          	cmova  %r11,%r9
  705e1b:	49 29 da             	sub    %rbx,%r10
  705e1e:	49 83 fa 01          	cmp    $0x1,%r10
  705e22:	77 dc                	ja     705e00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0xd0>
  705e24:	4d 89 cb             	mov    %r9,%r11
  705e27:	49 c1 e3 04          	shl    $0x4,%r11
  705e2b:	45 31 d2             	xor    %r10d,%r10d
  705e2e:	4b 39 04 18          	cmp    %rax,(%r8,%r11,1)
  705e32:	41 0f 96 c2          	setbe  %r10b
  705e36:	4d 01 ca             	add    %r9,%r10
  705e39:	0f 84 17 ff ff ff    	je     705d56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705e3f:	49 c1 e2 04          	shl    $0x4,%r10
  705e43:	4b 2b 44 10 f0       	sub    -0x10(%r8,%r10,1),%rax
  705e48:	47 8b 4c 10 fc       	mov    -0x4(%r8,%r10,1),%r9d
  705e4d:	4c 39 c8             	cmp    %r9,%rax
  705e50:	0f 83 00 ff ff ff    	jae    705d56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705e56:	4d 01 d0             	add    %r10,%r8
  705e59:	45 8b 40 f8          	mov    -0x8(%r8),%r8d
  705e5d:	4c 01 c0             	add    %r8,%rax
  705e60:	e9 82 00 00 00       	jmp    705ee7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x1b7>
  705e65:	48 2b 86 f0 01 00 00 	sub    0x1f0(%rsi),%rax
  705e6c:	0f 82 e4 fe ff ff    	jb     705d56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705e72:	48 3b 86 f8 01 00 00 	cmp    0x1f8(%rsi),%rax
  705e79:	0f 83 d7 fe ff ff    	jae    705d56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705e7f:	eb 66                	jmp    705ee7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x1b7>
  705e81:	4c 8b 8e f8 01 00 00 	mov    0x1f8(%rsi),%r9
  705e88:	4d 85 c9             	test   %r9,%r9
  705e8b:	0f 84 c5 fe ff ff    	je     705d56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705e91:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  705e98:	49 83 f9 01          	cmp    $0x1,%r9
  705e9c:	75 0b                	jne    705ea9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x179>
  705e9e:	49 39 00             	cmp    %rax,(%r8)
  705ea1:	0f 85 af fe ff ff    	jne    705d56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705ea7:	eb 3a                	jmp    705ee3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x1b3>
  705ea9:	45 31 d2             	xor    %r10d,%r10d
  705eac:	0f 1f 40 00          	nopl   0x0(%rax)
  705eb0:	4d 89 d3             	mov    %r10,%r11
  705eb3:	4c 89 cb             	mov    %r9,%rbx
  705eb6:	48 d1 eb             	shr    $1,%rbx
  705eb9:	49 01 da             	add    %rbx,%r10
  705ebc:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  705ec0:	4b 39 04 b0          	cmp    %rax,(%r8,%r14,4)
  705ec4:	4d 0f 47 d3          	cmova  %r11,%r10
  705ec8:	49 29 d9             	sub    %rbx,%r9
  705ecb:	49 83 f9 01          	cmp    $0x1,%r9
  705ecf:	77 df                	ja     705eb0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x180>
  705ed1:	4f 8d 0c 52          	lea    (%r10,%r10,2),%r9
  705ed5:	4b 39 04 88          	cmp    %rax,(%r8,%r9,4)
  705ed9:	0f 85 77 fe ff ff    	jne    705d56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705edf:	4f 8d 04 88          	lea    (%r8,%r9,4),%r8
  705ee3:	41 8b 40 08          	mov    0x8(%r8),%eax
  705ee7:	48 89 fb             	mov    %rdi,%rbx
  705eea:	48 89 f7             	mov    %rsi,%rdi
  705eed:	49 89 f6             	mov    %rsi,%r14
  705ef0:	48 89 c6             	mov    %rax,%rsi
  705ef3:	49 89 cf             	mov    %rcx,%r15
  705ef6:	49 89 d4             	mov    %rdx,%r12
  705ef9:	e8 52 c6 ff ff       	call   702550 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::editing_at>
  705efe:	4c 89 f6             	mov    %r14,%rsi
  705f01:	48 89 df             	mov    %rbx,%rdi
  705f04:	48 85 c0             	test   %rax,%rax
  705f07:	0f 84 49 fe ff ff    	je     705d56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705f0d:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  705f11:	0f 84 3f fe ff ff    	je     705d56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705f17:	4c 89 e2             	mov    %r12,%rdx
  705f1a:	4c 89 f9             	mov    %r15,%rcx
  705f1d:	4c 8b 08             	mov    (%rax),%r9
  705f20:	4d 85 e4             	test   %r12,%r12
  705f23:	74 19                	je     705f3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x20e>
  705f25:	4c 8b 86 b0 05 00 00 	mov    0x5b0(%rsi),%r8
  705f2c:	49 31 d0             	xor    %rdx,%r8
  705f2f:	49 89 ca             	mov    %rcx,%r10
  705f32:	4d 31 ca             	xor    %r9,%r10
  705f35:	4d 09 c2             	or     %r8,%r10
  705f38:	41 0f 94 c0          	sete   %r8b
  705f3c:	eb 03                	jmp    705f41 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x211>
  705f3e:	45 31 c0             	xor    %r8d,%r8d
  705f41:	44 8b 50 18          	mov    0x18(%rax),%r10d
  705f45:	8b 40 20             	mov    0x20(%rax),%eax
  705f48:	4c 8b 9e e8 05 00 00 	mov    0x5e8(%rsi),%r11
  705f4f:	4d 85 db             	test   %r11,%r11
  705f52:	74 17                	je     705f6b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x23b>
  705f54:	4c 33 9e b0 05 00 00 	xor    0x5b0(%rsi),%r11
  705f5b:	4c 33 8e f0 05 00 00 	xor    0x5f0(%rsi),%r9
  705f62:	4d 09 d9             	or     %r11,%r9
  705f65:	41 0f 94 c1          	sete   %r9b
  705f69:	eb 03                	jmp    705f6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x23e>
  705f6b:	45 31 c9             	xor    %r9d,%r9d
  705f6e:	41 39 c2             	cmp    %eax,%r10d
  705f71:	0f 85 df fd ff ff    	jne    705d56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705f77:	45 30 c8             	xor    %r9b,%r8b
  705f7a:	0f 84 d6 fd ff ff    	je     705d56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705f80:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  705f87:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  705f8b:	74 28                	je     705fb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x285>
  705f8d:	48 ff c0             	inc    %rax
  705f90:	48 89 86 60 06 00 00 	mov    %rax,0x660(%rsi)
  705f97:	48 ff 86 b0 06 00 00 	incq   0x6b0(%rsi)
  705f9e:	c6 86 1f 07 00 00 01 	movb   $0x1,0x71f(%rsi)
  705fa5:	48 83 c4 08          	add    $0x8,%rsp
  705fa9:	5b                   	pop    %rbx
  705faa:	41 5c                	pop    %r12
  705fac:	41 5e                	pop    %r14
  705fae:	41 5f                	pop    %r15
  705fb0:	e9 6b 35 02 00       	jmp    729520 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  705fb5:	48 89 96 e8 05 00 00 	mov    %rdx,0x5e8(%rsi)
  705fbc:	48 89 8e f0 05 00 00 	mov    %rcx,0x5f0(%rsi)
  705fc3:	48 c7 07 1f 00 00 00 	movq   $0x1f,(%rdi)
  705fca:	e9 de fd ff ff       	jmp    705dad <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x7d>
