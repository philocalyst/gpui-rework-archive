
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070ca80 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change>:
  70ca80:	41 57                	push   %r15
  70ca82:	41 56                	push   %r14
  70ca84:	41 54                	push   %r12
  70ca86:	53                   	push   %rbx
  70ca87:	50                   	push   %rax
  70ca88:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  70ca8f:	48 85 c0             	test   %rax,%rax
  70ca92:	74 12                	je     70caa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70ca94:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  70ca9b:	48 85 c0             	test   %rax,%rax
  70ca9e:	74 06                	je     70caa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70caa0:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  70caa4:	75 63                	jne    70cb09 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x89>
  70caa6:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  70caad:	0f b6 86 20 07 00 00 	movzbl 0x720(%rsi),%eax
  70cab4:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  70cabb:	00 
  70cabc:	74 1c                	je     70cada <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x5a>
  70cabe:	84 c0                	test   %al,%al
  70cac0:	74 0a                	je     70cacc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x4c>
  70cac2:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  70cac9:	ff 
  70caca:	74 0e                	je     70cada <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x5a>
  70cacc:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  70cad3:	b9 01 00 00 00       	mov    $0x1,%ecx
  70cad8:	eb 02                	jmp    70cadc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x5c>
  70cada:	31 c9                	xor    %ecx,%ecx
  70cadc:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  70cae3:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70cae7:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  70caeb:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  70caef:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  70caf3:	88 47 30             	mov    %al,0x30(%rdi)
  70caf6:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  70cafd:	48 83 c4 08          	add    $0x8,%rsp
  70cb01:	5b                   	pop    %rbx
  70cb02:	41 5c                	pop    %r12
  70cb04:	41 5e                	pop    %r14
  70cb06:	41 5f                	pop    %r15
  70cb08:	c3                   	ret
  70cb09:	48 8b 00             	mov    (%rax),%rax
  70cb0c:	4c 8b 86 e8 01 00 00 	mov    0x1e8(%rsi),%r8
  70cb13:	4d 85 c0             	test   %r8,%r8
  70cb16:	0f 84 99 00 00 00    	je     70cbb5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x135>
  70cb1c:	41 83 f8 01          	cmp    $0x1,%r8d
  70cb20:	0f 85 ab 00 00 00    	jne    70cbd1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x151>
  70cb26:	4c 8b 96 f8 01 00 00 	mov    0x1f8(%rsi),%r10
  70cb2d:	4d 85 d2             	test   %r10,%r10
  70cb30:	0f 84 70 ff ff ff    	je     70caa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cb36:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  70cb3d:	45 31 c9             	xor    %r9d,%r9d
  70cb40:	49 83 fa 01          	cmp    $0x1,%r10
  70cb44:	74 2e                	je     70cb74 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0xf4>
  70cb46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  70cb4d:	00 00 00 
  70cb50:	4d 89 cb             	mov    %r9,%r11
  70cb53:	4c 89 d3             	mov    %r10,%rbx
  70cb56:	48 d1 eb             	shr    $1,%rbx
  70cb59:	49 01 d9             	add    %rbx,%r9
  70cb5c:	4d 89 ce             	mov    %r9,%r14
  70cb5f:	49 c1 e6 04          	shl    $0x4,%r14
  70cb63:	4b 39 04 30          	cmp    %rax,(%r8,%r14,1)
  70cb67:	4d 0f 47 cb          	cmova  %r11,%r9
  70cb6b:	49 29 da             	sub    %rbx,%r10
  70cb6e:	49 83 fa 01          	cmp    $0x1,%r10
  70cb72:	77 dc                	ja     70cb50 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0xd0>
  70cb74:	4d 89 cb             	mov    %r9,%r11
  70cb77:	49 c1 e3 04          	shl    $0x4,%r11
  70cb7b:	45 31 d2             	xor    %r10d,%r10d
  70cb7e:	4b 39 04 18          	cmp    %rax,(%r8,%r11,1)
  70cb82:	41 0f 96 c2          	setbe  %r10b
  70cb86:	4d 01 ca             	add    %r9,%r10
  70cb89:	0f 84 17 ff ff ff    	je     70caa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cb8f:	49 c1 e2 04          	shl    $0x4,%r10
  70cb93:	4b 2b 44 10 f0       	sub    -0x10(%r8,%r10,1),%rax
  70cb98:	47 8b 4c 10 fc       	mov    -0x4(%r8,%r10,1),%r9d
  70cb9d:	4c 39 c8             	cmp    %r9,%rax
  70cba0:	0f 83 00 ff ff ff    	jae    70caa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cba6:	4d 01 d0             	add    %r10,%r8
  70cba9:	45 8b 40 f8          	mov    -0x8(%r8),%r8d
  70cbad:	4c 01 c0             	add    %r8,%rax
  70cbb0:	e9 82 00 00 00       	jmp    70cc37 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x1b7>
  70cbb5:	48 2b 86 f0 01 00 00 	sub    0x1f0(%rsi),%rax
  70cbbc:	0f 82 e4 fe ff ff    	jb     70caa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cbc2:	48 3b 86 f8 01 00 00 	cmp    0x1f8(%rsi),%rax
  70cbc9:	0f 83 d7 fe ff ff    	jae    70caa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cbcf:	eb 66                	jmp    70cc37 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x1b7>
  70cbd1:	4c 8b 8e f8 01 00 00 	mov    0x1f8(%rsi),%r9
  70cbd8:	4d 85 c9             	test   %r9,%r9
  70cbdb:	0f 84 c5 fe ff ff    	je     70caa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cbe1:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  70cbe8:	49 83 f9 01          	cmp    $0x1,%r9
  70cbec:	75 0b                	jne    70cbf9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x179>
  70cbee:	49 39 00             	cmp    %rax,(%r8)
  70cbf1:	0f 85 af fe ff ff    	jne    70caa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cbf7:	eb 3a                	jmp    70cc33 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x1b3>
  70cbf9:	45 31 d2             	xor    %r10d,%r10d
  70cbfc:	0f 1f 40 00          	nopl   0x0(%rax)
  70cc00:	4d 89 d3             	mov    %r10,%r11
  70cc03:	4c 89 cb             	mov    %r9,%rbx
  70cc06:	48 d1 eb             	shr    $1,%rbx
  70cc09:	49 01 da             	add    %rbx,%r10
  70cc0c:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  70cc10:	4b 39 04 b0          	cmp    %rax,(%r8,%r14,4)
  70cc14:	4d 0f 47 d3          	cmova  %r11,%r10
  70cc18:	49 29 d9             	sub    %rbx,%r9
  70cc1b:	49 83 f9 01          	cmp    $0x1,%r9
  70cc1f:	77 df                	ja     70cc00 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x180>
  70cc21:	4f 8d 0c 52          	lea    (%r10,%r10,2),%r9
  70cc25:	4b 39 04 88          	cmp    %rax,(%r8,%r9,4)
  70cc29:	0f 85 77 fe ff ff    	jne    70caa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cc2f:	4f 8d 04 88          	lea    (%r8,%r9,4),%r8
  70cc33:	41 8b 40 08          	mov    0x8(%r8),%eax
  70cc37:	48 89 fb             	mov    %rdi,%rbx
  70cc3a:	48 89 f7             	mov    %rsi,%rdi
  70cc3d:	49 89 f6             	mov    %rsi,%r14
  70cc40:	48 89 c6             	mov    %rax,%rsi
  70cc43:	49 89 cf             	mov    %rcx,%r15
  70cc46:	49 89 d4             	mov    %rdx,%r12
  70cc49:	e8 c2 da ff ff       	call   70a710 <<gpui::runtime::Runtime<unit_action_cost::Model>>::editing_at>
  70cc4e:	4c 89 f6             	mov    %r14,%rsi
  70cc51:	48 89 df             	mov    %rbx,%rdi
  70cc54:	48 85 c0             	test   %rax,%rax
  70cc57:	0f 84 49 fe ff ff    	je     70caa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cc5d:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  70cc61:	0f 84 3f fe ff ff    	je     70caa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cc67:	4c 89 e2             	mov    %r12,%rdx
  70cc6a:	4c 89 f9             	mov    %r15,%rcx
  70cc6d:	4c 8b 08             	mov    (%rax),%r9
  70cc70:	4d 85 e4             	test   %r12,%r12
  70cc73:	74 19                	je     70cc8e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x20e>
  70cc75:	4c 8b 86 b0 05 00 00 	mov    0x5b0(%rsi),%r8
  70cc7c:	49 31 d0             	xor    %rdx,%r8
  70cc7f:	49 89 ca             	mov    %rcx,%r10
  70cc82:	4d 31 ca             	xor    %r9,%r10
  70cc85:	4d 09 c2             	or     %r8,%r10
  70cc88:	41 0f 94 c0          	sete   %r8b
  70cc8c:	eb 03                	jmp    70cc91 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x211>
  70cc8e:	45 31 c0             	xor    %r8d,%r8d
  70cc91:	44 8b 50 18          	mov    0x18(%rax),%r10d
  70cc95:	8b 40 20             	mov    0x20(%rax),%eax
  70cc98:	4c 8b 9e e8 05 00 00 	mov    0x5e8(%rsi),%r11
  70cc9f:	4d 85 db             	test   %r11,%r11
  70cca2:	74 17                	je     70ccbb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x23b>
  70cca4:	4c 33 9e b0 05 00 00 	xor    0x5b0(%rsi),%r11
  70ccab:	4c 33 8e f0 05 00 00 	xor    0x5f0(%rsi),%r9
  70ccb2:	4d 09 d9             	or     %r11,%r9
  70ccb5:	41 0f 94 c1          	sete   %r9b
  70ccb9:	eb 03                	jmp    70ccbe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x23e>
  70ccbb:	45 31 c9             	xor    %r9d,%r9d
  70ccbe:	41 39 c2             	cmp    %eax,%r10d
  70ccc1:	0f 85 df fd ff ff    	jne    70caa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70ccc7:	45 30 c8             	xor    %r9b,%r8b
  70ccca:	0f 84 d6 fd ff ff    	je     70caa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70ccd0:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  70ccd7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  70ccdb:	74 28                	je     70cd05 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x285>
  70ccdd:	48 ff c0             	inc    %rax
  70cce0:	48 89 86 60 06 00 00 	mov    %rax,0x660(%rsi)
  70cce7:	48 ff 86 b0 06 00 00 	incq   0x6b0(%rsi)
  70ccee:	c6 86 1f 07 00 00 01 	movb   $0x1,0x71f(%rsi)
  70ccf5:	48 83 c4 08          	add    $0x8,%rsp
  70ccf9:	5b                   	pop    %rbx
  70ccfa:	41 5c                	pop    %r12
  70ccfc:	41 5e                	pop    %r14
  70ccfe:	41 5f                	pop    %r15
  70cd00:	e9 8b 19 01 00       	jmp    71e690 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70cd05:	48 89 96 e8 05 00 00 	mov    %rdx,0x5e8(%rsi)
  70cd0c:	48 89 8e f0 05 00 00 	mov    %rcx,0x5f0(%rsi)
  70cd13:	48 c7 07 1f 00 00 00 	movq   $0x1f,(%rdi)
  70cd1a:	e9 de fd ff ff       	jmp    70cafd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x7d>
