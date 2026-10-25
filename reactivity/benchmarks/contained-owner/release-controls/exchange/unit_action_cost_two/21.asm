
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000705ca0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change>:
  705ca0:	41 57                	push   %r15
  705ca2:	41 56                	push   %r14
  705ca4:	41 54                	push   %r12
  705ca6:	53                   	push   %rbx
  705ca7:	50                   	push   %rax
  705ca8:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  705caf:	48 85 c0             	test   %rax,%rax
  705cb2:	74 12                	je     705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705cb4:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  705cbb:	48 85 c0             	test   %rax,%rax
  705cbe:	74 06                	je     705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705cc0:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  705cc4:	75 63                	jne    705d29 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x89>
  705cc6:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  705ccd:	0f b6 86 20 07 00 00 	movzbl 0x720(%rsi),%eax
  705cd4:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  705cdb:	00 
  705cdc:	74 1c                	je     705cfa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x5a>
  705cde:	84 c0                	test   %al,%al
  705ce0:	74 0a                	je     705cec <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x4c>
  705ce2:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  705ce9:	ff 
  705cea:	74 0e                	je     705cfa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x5a>
  705cec:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  705cf3:	b9 01 00 00 00       	mov    $0x1,%ecx
  705cf8:	eb 02                	jmp    705cfc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x5c>
  705cfa:	31 c9                	xor    %ecx,%ecx
  705cfc:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  705d03:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  705d07:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  705d0b:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  705d0f:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  705d13:	88 47 30             	mov    %al,0x30(%rdi)
  705d16:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  705d1d:	48 83 c4 08          	add    $0x8,%rsp
  705d21:	5b                   	pop    %rbx
  705d22:	41 5c                	pop    %r12
  705d24:	41 5e                	pop    %r14
  705d26:	41 5f                	pop    %r15
  705d28:	c3                   	ret
  705d29:	48 8b 00             	mov    (%rax),%rax
  705d2c:	4c 8b 86 e8 01 00 00 	mov    0x1e8(%rsi),%r8
  705d33:	4d 85 c0             	test   %r8,%r8
  705d36:	0f 84 99 00 00 00    	je     705dd5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x135>
  705d3c:	41 83 f8 01          	cmp    $0x1,%r8d
  705d40:	0f 85 ab 00 00 00    	jne    705df1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x151>
  705d46:	4c 8b 96 f8 01 00 00 	mov    0x1f8(%rsi),%r10
  705d4d:	4d 85 d2             	test   %r10,%r10
  705d50:	0f 84 70 ff ff ff    	je     705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705d56:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  705d5d:	45 31 c9             	xor    %r9d,%r9d
  705d60:	49 83 fa 01          	cmp    $0x1,%r10
  705d64:	74 2e                	je     705d94 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0xf4>
  705d66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  705d6d:	00 00 00 
  705d70:	4d 89 cb             	mov    %r9,%r11
  705d73:	4c 89 d3             	mov    %r10,%rbx
  705d76:	48 d1 eb             	shr    $1,%rbx
  705d79:	49 01 d9             	add    %rbx,%r9
  705d7c:	4d 89 ce             	mov    %r9,%r14
  705d7f:	49 c1 e6 04          	shl    $0x4,%r14
  705d83:	4b 39 04 30          	cmp    %rax,(%r8,%r14,1)
  705d87:	4d 0f 47 cb          	cmova  %r11,%r9
  705d8b:	49 29 da             	sub    %rbx,%r10
  705d8e:	49 83 fa 01          	cmp    $0x1,%r10
  705d92:	77 dc                	ja     705d70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0xd0>
  705d94:	4d 89 cb             	mov    %r9,%r11
  705d97:	49 c1 e3 04          	shl    $0x4,%r11
  705d9b:	45 31 d2             	xor    %r10d,%r10d
  705d9e:	4b 39 04 18          	cmp    %rax,(%r8,%r11,1)
  705da2:	41 0f 96 c2          	setbe  %r10b
  705da6:	4d 01 ca             	add    %r9,%r10
  705da9:	0f 84 17 ff ff ff    	je     705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705daf:	49 c1 e2 04          	shl    $0x4,%r10
  705db3:	4b 2b 44 10 f0       	sub    -0x10(%r8,%r10,1),%rax
  705db8:	47 8b 4c 10 fc       	mov    -0x4(%r8,%r10,1),%r9d
  705dbd:	4c 39 c8             	cmp    %r9,%rax
  705dc0:	0f 83 00 ff ff ff    	jae    705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705dc6:	4d 01 d0             	add    %r10,%r8
  705dc9:	45 8b 40 f8          	mov    -0x8(%r8),%r8d
  705dcd:	4c 01 c0             	add    %r8,%rax
  705dd0:	e9 82 00 00 00       	jmp    705e57 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x1b7>
  705dd5:	48 2b 86 f0 01 00 00 	sub    0x1f0(%rsi),%rax
  705ddc:	0f 82 e4 fe ff ff    	jb     705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705de2:	48 3b 86 f8 01 00 00 	cmp    0x1f8(%rsi),%rax
  705de9:	0f 83 d7 fe ff ff    	jae    705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705def:	eb 66                	jmp    705e57 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x1b7>
  705df1:	4c 8b 8e f8 01 00 00 	mov    0x1f8(%rsi),%r9
  705df8:	4d 85 c9             	test   %r9,%r9
  705dfb:	0f 84 c5 fe ff ff    	je     705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705e01:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  705e08:	49 83 f9 01          	cmp    $0x1,%r9
  705e0c:	75 0b                	jne    705e19 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x179>
  705e0e:	49 39 00             	cmp    %rax,(%r8)
  705e11:	0f 85 af fe ff ff    	jne    705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705e17:	eb 3a                	jmp    705e53 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x1b3>
  705e19:	45 31 d2             	xor    %r10d,%r10d
  705e1c:	0f 1f 40 00          	nopl   0x0(%rax)
  705e20:	4d 89 d3             	mov    %r10,%r11
  705e23:	4c 89 cb             	mov    %r9,%rbx
  705e26:	48 d1 eb             	shr    $1,%rbx
  705e29:	49 01 da             	add    %rbx,%r10
  705e2c:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  705e30:	4b 39 04 b0          	cmp    %rax,(%r8,%r14,4)
  705e34:	4d 0f 47 d3          	cmova  %r11,%r10
  705e38:	49 29 d9             	sub    %rbx,%r9
  705e3b:	49 83 f9 01          	cmp    $0x1,%r9
  705e3f:	77 df                	ja     705e20 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x180>
  705e41:	4f 8d 0c 52          	lea    (%r10,%r10,2),%r9
  705e45:	4b 39 04 88          	cmp    %rax,(%r8,%r9,4)
  705e49:	0f 85 77 fe ff ff    	jne    705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705e4f:	4f 8d 04 88          	lea    (%r8,%r9,4),%r8
  705e53:	41 8b 40 08          	mov    0x8(%r8),%eax
  705e57:	48 89 fb             	mov    %rdi,%rbx
  705e5a:	48 89 f7             	mov    %rsi,%rdi
  705e5d:	49 89 f6             	mov    %rsi,%r14
  705e60:	48 89 c6             	mov    %rax,%rsi
  705e63:	49 89 cf             	mov    %rcx,%r15
  705e66:	49 89 d4             	mov    %rdx,%r12
  705e69:	e8 52 c6 ff ff       	call   7024c0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::editing_at>
  705e6e:	4c 89 f6             	mov    %r14,%rsi
  705e71:	48 89 df             	mov    %rbx,%rdi
  705e74:	48 85 c0             	test   %rax,%rax
  705e77:	0f 84 49 fe ff ff    	je     705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705e7d:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  705e81:	0f 84 3f fe ff ff    	je     705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705e87:	4c 89 e2             	mov    %r12,%rdx
  705e8a:	4c 89 f9             	mov    %r15,%rcx
  705e8d:	4c 8b 08             	mov    (%rax),%r9
  705e90:	4d 85 e4             	test   %r12,%r12
  705e93:	74 19                	je     705eae <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x20e>
  705e95:	4c 8b 86 b0 05 00 00 	mov    0x5b0(%rsi),%r8
  705e9c:	49 31 d0             	xor    %rdx,%r8
  705e9f:	49 89 ca             	mov    %rcx,%r10
  705ea2:	4d 31 ca             	xor    %r9,%r10
  705ea5:	4d 09 c2             	or     %r8,%r10
  705ea8:	41 0f 94 c0          	sete   %r8b
  705eac:	eb 03                	jmp    705eb1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x211>
  705eae:	45 31 c0             	xor    %r8d,%r8d
  705eb1:	44 8b 50 18          	mov    0x18(%rax),%r10d
  705eb5:	8b 40 20             	mov    0x20(%rax),%eax
  705eb8:	4c 8b 9e e8 05 00 00 	mov    0x5e8(%rsi),%r11
  705ebf:	4d 85 db             	test   %r11,%r11
  705ec2:	74 17                	je     705edb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x23b>
  705ec4:	4c 33 9e b0 05 00 00 	xor    0x5b0(%rsi),%r11
  705ecb:	4c 33 8e f0 05 00 00 	xor    0x5f0(%rsi),%r9
  705ed2:	4d 09 d9             	or     %r11,%r9
  705ed5:	41 0f 94 c1          	sete   %r9b
  705ed9:	eb 03                	jmp    705ede <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x23e>
  705edb:	45 31 c9             	xor    %r9d,%r9d
  705ede:	41 39 c2             	cmp    %eax,%r10d
  705ee1:	0f 85 df fd ff ff    	jne    705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705ee7:	45 30 c8             	xor    %r9b,%r8b
  705eea:	0f 84 d6 fd ff ff    	je     705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705ef0:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  705ef7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  705efb:	74 28                	je     705f25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x285>
  705efd:	48 ff c0             	inc    %rax
  705f00:	48 89 86 60 06 00 00 	mov    %rax,0x660(%rsi)
  705f07:	48 ff 86 b0 06 00 00 	incq   0x6b0(%rsi)
  705f0e:	c6 86 1f 07 00 00 01 	movb   $0x1,0x71f(%rsi)
  705f15:	48 83 c4 08          	add    $0x8,%rsp
  705f19:	5b                   	pop    %rbx
  705f1a:	41 5c                	pop    %r12
  705f1c:	41 5e                	pop    %r14
  705f1e:	41 5f                	pop    %r15
  705f20:	e9 6b 35 02 00       	jmp    729490 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  705f25:	48 89 96 e8 05 00 00 	mov    %rdx,0x5e8(%rsi)
  705f2c:	48 89 8e f0 05 00 00 	mov    %rcx,0x5f0(%rsi)
  705f33:	48 c7 07 1f 00 00 00 	movq   $0x1f,(%rdi)
  705f3a:	e9 de fd ff ff       	jmp    705d1d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x7d>
