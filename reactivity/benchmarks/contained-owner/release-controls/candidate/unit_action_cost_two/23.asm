
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000705da0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change>:
  705da0:	41 57                	push   %r15
  705da2:	41 56                	push   %r14
  705da4:	41 54                	push   %r12
  705da6:	53                   	push   %rbx
  705da7:	50                   	push   %rax
  705da8:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  705daf:	48 85 c0             	test   %rax,%rax
  705db2:	74 12                	je     705dc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705db4:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  705dbb:	48 85 c0             	test   %rax,%rax
  705dbe:	74 06                	je     705dc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705dc0:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  705dc4:	75 63                	jne    705e29 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x89>
  705dc6:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  705dcd:	0f b6 86 20 07 00 00 	movzbl 0x720(%rsi),%eax
  705dd4:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  705ddb:	00 
  705ddc:	74 1c                	je     705dfa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x5a>
  705dde:	84 c0                	test   %al,%al
  705de0:	74 0a                	je     705dec <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x4c>
  705de2:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  705de9:	ff 
  705dea:	74 0e                	je     705dfa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x5a>
  705dec:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  705df3:	b9 01 00 00 00       	mov    $0x1,%ecx
  705df8:	eb 02                	jmp    705dfc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x5c>
  705dfa:	31 c9                	xor    %ecx,%ecx
  705dfc:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  705e03:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  705e07:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  705e0b:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  705e0f:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  705e13:	88 47 30             	mov    %al,0x30(%rdi)
  705e16:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  705e1d:	48 83 c4 08          	add    $0x8,%rsp
  705e21:	5b                   	pop    %rbx
  705e22:	41 5c                	pop    %r12
  705e24:	41 5e                	pop    %r14
  705e26:	41 5f                	pop    %r15
  705e28:	c3                   	ret
  705e29:	48 8b 00             	mov    (%rax),%rax
  705e2c:	4c 8b 86 e8 01 00 00 	mov    0x1e8(%rsi),%r8
  705e33:	4d 85 c0             	test   %r8,%r8
  705e36:	0f 84 99 00 00 00    	je     705ed5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x135>
  705e3c:	41 83 f8 01          	cmp    $0x1,%r8d
  705e40:	0f 85 ab 00 00 00    	jne    705ef1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x151>
  705e46:	4c 8b 96 f8 01 00 00 	mov    0x1f8(%rsi),%r10
  705e4d:	4d 85 d2             	test   %r10,%r10
  705e50:	0f 84 70 ff ff ff    	je     705dc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705e56:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  705e5d:	45 31 c9             	xor    %r9d,%r9d
  705e60:	49 83 fa 01          	cmp    $0x1,%r10
  705e64:	74 2e                	je     705e94 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0xf4>
  705e66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  705e6d:	00 00 00 
  705e70:	4d 89 cb             	mov    %r9,%r11
  705e73:	4c 89 d3             	mov    %r10,%rbx
  705e76:	48 d1 eb             	shr    $1,%rbx
  705e79:	49 01 d9             	add    %rbx,%r9
  705e7c:	4d 89 ce             	mov    %r9,%r14
  705e7f:	49 c1 e6 04          	shl    $0x4,%r14
  705e83:	4b 39 04 30          	cmp    %rax,(%r8,%r14,1)
  705e87:	4d 0f 47 cb          	cmova  %r11,%r9
  705e8b:	49 29 da             	sub    %rbx,%r10
  705e8e:	49 83 fa 01          	cmp    $0x1,%r10
  705e92:	77 dc                	ja     705e70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0xd0>
  705e94:	4d 89 cb             	mov    %r9,%r11
  705e97:	49 c1 e3 04          	shl    $0x4,%r11
  705e9b:	45 31 d2             	xor    %r10d,%r10d
  705e9e:	4b 39 04 18          	cmp    %rax,(%r8,%r11,1)
  705ea2:	41 0f 96 c2          	setbe  %r10b
  705ea6:	4d 01 ca             	add    %r9,%r10
  705ea9:	0f 84 17 ff ff ff    	je     705dc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705eaf:	49 c1 e2 04          	shl    $0x4,%r10
  705eb3:	4b 2b 44 10 f0       	sub    -0x10(%r8,%r10,1),%rax
  705eb8:	47 8b 4c 10 fc       	mov    -0x4(%r8,%r10,1),%r9d
  705ebd:	4c 39 c8             	cmp    %r9,%rax
  705ec0:	0f 83 00 ff ff ff    	jae    705dc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705ec6:	4d 01 d0             	add    %r10,%r8
  705ec9:	45 8b 40 f8          	mov    -0x8(%r8),%r8d
  705ecd:	4c 01 c0             	add    %r8,%rax
  705ed0:	e9 82 00 00 00       	jmp    705f57 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x1b7>
  705ed5:	48 2b 86 f0 01 00 00 	sub    0x1f0(%rsi),%rax
  705edc:	0f 82 e4 fe ff ff    	jb     705dc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705ee2:	48 3b 86 f8 01 00 00 	cmp    0x1f8(%rsi),%rax
  705ee9:	0f 83 d7 fe ff ff    	jae    705dc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705eef:	eb 66                	jmp    705f57 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x1b7>
  705ef1:	4c 8b 8e f8 01 00 00 	mov    0x1f8(%rsi),%r9
  705ef8:	4d 85 c9             	test   %r9,%r9
  705efb:	0f 84 c5 fe ff ff    	je     705dc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705f01:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  705f08:	49 83 f9 01          	cmp    $0x1,%r9
  705f0c:	75 0b                	jne    705f19 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x179>
  705f0e:	49 39 00             	cmp    %rax,(%r8)
  705f11:	0f 85 af fe ff ff    	jne    705dc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705f17:	eb 3a                	jmp    705f53 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x1b3>
  705f19:	45 31 d2             	xor    %r10d,%r10d
  705f1c:	0f 1f 40 00          	nopl   0x0(%rax)
  705f20:	4d 89 d3             	mov    %r10,%r11
  705f23:	4c 89 cb             	mov    %r9,%rbx
  705f26:	48 d1 eb             	shr    $1,%rbx
  705f29:	49 01 da             	add    %rbx,%r10
  705f2c:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  705f30:	4b 39 04 b0          	cmp    %rax,(%r8,%r14,4)
  705f34:	4d 0f 47 d3          	cmova  %r11,%r10
  705f38:	49 29 d9             	sub    %rbx,%r9
  705f3b:	49 83 f9 01          	cmp    $0x1,%r9
  705f3f:	77 df                	ja     705f20 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x180>
  705f41:	4f 8d 0c 52          	lea    (%r10,%r10,2),%r9
  705f45:	4b 39 04 88          	cmp    %rax,(%r8,%r9,4)
  705f49:	0f 85 77 fe ff ff    	jne    705dc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705f4f:	4f 8d 04 88          	lea    (%r8,%r9,4),%r8
  705f53:	41 8b 40 08          	mov    0x8(%r8),%eax
  705f57:	48 89 fb             	mov    %rdi,%rbx
  705f5a:	48 89 f7             	mov    %rsi,%rdi
  705f5d:	49 89 f6             	mov    %rsi,%r14
  705f60:	48 89 c6             	mov    %rax,%rsi
  705f63:	49 89 cf             	mov    %rcx,%r15
  705f66:	49 89 d4             	mov    %rdx,%r12
  705f69:	e8 52 c6 ff ff       	call   7025c0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::editing_at>
  705f6e:	4c 89 f6             	mov    %r14,%rsi
  705f71:	48 89 df             	mov    %rbx,%rdi
  705f74:	48 85 c0             	test   %rax,%rax
  705f77:	0f 84 49 fe ff ff    	je     705dc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705f7d:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  705f81:	0f 84 3f fe ff ff    	je     705dc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705f87:	4c 89 e2             	mov    %r12,%rdx
  705f8a:	4c 89 f9             	mov    %r15,%rcx
  705f8d:	4c 8b 08             	mov    (%rax),%r9
  705f90:	4d 85 e4             	test   %r12,%r12
  705f93:	74 19                	je     705fae <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x20e>
  705f95:	4c 8b 86 b0 05 00 00 	mov    0x5b0(%rsi),%r8
  705f9c:	49 31 d0             	xor    %rdx,%r8
  705f9f:	49 89 ca             	mov    %rcx,%r10
  705fa2:	4d 31 ca             	xor    %r9,%r10
  705fa5:	4d 09 c2             	or     %r8,%r10
  705fa8:	41 0f 94 c0          	sete   %r8b
  705fac:	eb 03                	jmp    705fb1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x211>
  705fae:	45 31 c0             	xor    %r8d,%r8d
  705fb1:	44 8b 50 18          	mov    0x18(%rax),%r10d
  705fb5:	8b 40 20             	mov    0x20(%rax),%eax
  705fb8:	4c 8b 9e e8 05 00 00 	mov    0x5e8(%rsi),%r11
  705fbf:	4d 85 db             	test   %r11,%r11
  705fc2:	74 17                	je     705fdb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x23b>
  705fc4:	4c 33 9e b0 05 00 00 	xor    0x5b0(%rsi),%r11
  705fcb:	4c 33 8e f0 05 00 00 	xor    0x5f0(%rsi),%r9
  705fd2:	4d 09 d9             	or     %r11,%r9
  705fd5:	41 0f 94 c1          	sete   %r9b
  705fd9:	eb 03                	jmp    705fde <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x23e>
  705fdb:	45 31 c9             	xor    %r9d,%r9d
  705fde:	41 39 c2             	cmp    %eax,%r10d
  705fe1:	0f 85 df fd ff ff    	jne    705dc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705fe7:	45 30 c8             	xor    %r9b,%r8b
  705fea:	0f 84 d6 fd ff ff    	je     705dc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  705ff0:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  705ff7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  705ffb:	74 28                	je     706025 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x285>
  705ffd:	48 ff c0             	inc    %rax
  706000:	48 89 86 60 06 00 00 	mov    %rax,0x660(%rsi)
  706007:	48 ff 86 b0 06 00 00 	incq   0x6b0(%rsi)
  70600e:	c6 86 1f 07 00 00 01 	movb   $0x1,0x71f(%rsi)
  706015:	48 83 c4 08          	add    $0x8,%rsp
  706019:	5b                   	pop    %rbx
  70601a:	41 5c                	pop    %r12
  70601c:	41 5e                	pop    %r14
  70601e:	41 5f                	pop    %r15
  706020:	e9 6b 35 02 00       	jmp    729590 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  706025:	48 89 96 e8 05 00 00 	mov    %rdx,0x5e8(%rsi)
  70602c:	48 89 8e f0 05 00 00 	mov    %rcx,0x5f0(%rsi)
  706033:	48 c7 07 1f 00 00 00 	movq   $0x1f,(%rdi)
  70603a:	e9 de fd ff ff       	jmp    705e1d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x7d>
