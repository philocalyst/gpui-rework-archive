
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070c970 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change>:
  70c970:	41 57                	push   %r15
  70c972:	41 56                	push   %r14
  70c974:	41 54                	push   %r12
  70c976:	53                   	push   %rbx
  70c977:	50                   	push   %rax
  70c978:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  70c97f:	48 85 c0             	test   %rax,%rax
  70c982:	74 12                	je     70c996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70c984:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  70c98b:	48 85 c0             	test   %rax,%rax
  70c98e:	74 06                	je     70c996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70c990:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  70c994:	75 63                	jne    70c9f9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x89>
  70c996:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  70c99d:	0f b6 86 20 07 00 00 	movzbl 0x720(%rsi),%eax
  70c9a4:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  70c9ab:	00 
  70c9ac:	74 1c                	je     70c9ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x5a>
  70c9ae:	84 c0                	test   %al,%al
  70c9b0:	74 0a                	je     70c9bc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x4c>
  70c9b2:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  70c9b9:	ff 
  70c9ba:	74 0e                	je     70c9ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x5a>
  70c9bc:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  70c9c3:	b9 01 00 00 00       	mov    $0x1,%ecx
  70c9c8:	eb 02                	jmp    70c9cc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x5c>
  70c9ca:	31 c9                	xor    %ecx,%ecx
  70c9cc:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  70c9d3:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70c9d7:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  70c9db:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  70c9df:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  70c9e3:	88 47 30             	mov    %al,0x30(%rdi)
  70c9e6:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  70c9ed:	48 83 c4 08          	add    $0x8,%rsp
  70c9f1:	5b                   	pop    %rbx
  70c9f2:	41 5c                	pop    %r12
  70c9f4:	41 5e                	pop    %r14
  70c9f6:	41 5f                	pop    %r15
  70c9f8:	c3                   	ret
  70c9f9:	48 8b 00             	mov    (%rax),%rax
  70c9fc:	4c 8b 86 e8 01 00 00 	mov    0x1e8(%rsi),%r8
  70ca03:	4d 85 c0             	test   %r8,%r8
  70ca06:	0f 84 99 00 00 00    	je     70caa5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x135>
  70ca0c:	41 83 f8 01          	cmp    $0x1,%r8d
  70ca10:	0f 85 ab 00 00 00    	jne    70cac1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x151>
  70ca16:	4c 8b 96 f8 01 00 00 	mov    0x1f8(%rsi),%r10
  70ca1d:	4d 85 d2             	test   %r10,%r10
  70ca20:	0f 84 70 ff ff ff    	je     70c996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70ca26:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  70ca2d:	45 31 c9             	xor    %r9d,%r9d
  70ca30:	49 83 fa 01          	cmp    $0x1,%r10
  70ca34:	74 2e                	je     70ca64 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0xf4>
  70ca36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  70ca3d:	00 00 00 
  70ca40:	4d 89 cb             	mov    %r9,%r11
  70ca43:	4c 89 d3             	mov    %r10,%rbx
  70ca46:	48 d1 eb             	shr    $1,%rbx
  70ca49:	49 01 d9             	add    %rbx,%r9
  70ca4c:	4d 89 ce             	mov    %r9,%r14
  70ca4f:	49 c1 e6 04          	shl    $0x4,%r14
  70ca53:	4b 39 04 30          	cmp    %rax,(%r8,%r14,1)
  70ca57:	4d 0f 47 cb          	cmova  %r11,%r9
  70ca5b:	49 29 da             	sub    %rbx,%r10
  70ca5e:	49 83 fa 01          	cmp    $0x1,%r10
  70ca62:	77 dc                	ja     70ca40 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0xd0>
  70ca64:	4d 89 cb             	mov    %r9,%r11
  70ca67:	49 c1 e3 04          	shl    $0x4,%r11
  70ca6b:	45 31 d2             	xor    %r10d,%r10d
  70ca6e:	4b 39 04 18          	cmp    %rax,(%r8,%r11,1)
  70ca72:	41 0f 96 c2          	setbe  %r10b
  70ca76:	4d 01 ca             	add    %r9,%r10
  70ca79:	0f 84 17 ff ff ff    	je     70c996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70ca7f:	49 c1 e2 04          	shl    $0x4,%r10
  70ca83:	4b 2b 44 10 f0       	sub    -0x10(%r8,%r10,1),%rax
  70ca88:	47 8b 4c 10 fc       	mov    -0x4(%r8,%r10,1),%r9d
  70ca8d:	4c 39 c8             	cmp    %r9,%rax
  70ca90:	0f 83 00 ff ff ff    	jae    70c996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70ca96:	4d 01 d0             	add    %r10,%r8
  70ca99:	45 8b 40 f8          	mov    -0x8(%r8),%r8d
  70ca9d:	4c 01 c0             	add    %r8,%rax
  70caa0:	e9 82 00 00 00       	jmp    70cb27 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x1b7>
  70caa5:	48 2b 86 f0 01 00 00 	sub    0x1f0(%rsi),%rax
  70caac:	0f 82 e4 fe ff ff    	jb     70c996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cab2:	48 3b 86 f8 01 00 00 	cmp    0x1f8(%rsi),%rax
  70cab9:	0f 83 d7 fe ff ff    	jae    70c996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cabf:	eb 66                	jmp    70cb27 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x1b7>
  70cac1:	4c 8b 8e f8 01 00 00 	mov    0x1f8(%rsi),%r9
  70cac8:	4d 85 c9             	test   %r9,%r9
  70cacb:	0f 84 c5 fe ff ff    	je     70c996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cad1:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  70cad8:	49 83 f9 01          	cmp    $0x1,%r9
  70cadc:	75 0b                	jne    70cae9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x179>
  70cade:	49 39 00             	cmp    %rax,(%r8)
  70cae1:	0f 85 af fe ff ff    	jne    70c996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cae7:	eb 3a                	jmp    70cb23 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x1b3>
  70cae9:	45 31 d2             	xor    %r10d,%r10d
  70caec:	0f 1f 40 00          	nopl   0x0(%rax)
  70caf0:	4d 89 d3             	mov    %r10,%r11
  70caf3:	4c 89 cb             	mov    %r9,%rbx
  70caf6:	48 d1 eb             	shr    $1,%rbx
  70caf9:	49 01 da             	add    %rbx,%r10
  70cafc:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  70cb00:	4b 39 04 b0          	cmp    %rax,(%r8,%r14,4)
  70cb04:	4d 0f 47 d3          	cmova  %r11,%r10
  70cb08:	49 29 d9             	sub    %rbx,%r9
  70cb0b:	49 83 f9 01          	cmp    $0x1,%r9
  70cb0f:	77 df                	ja     70caf0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x180>
  70cb11:	4f 8d 0c 52          	lea    (%r10,%r10,2),%r9
  70cb15:	4b 39 04 88          	cmp    %rax,(%r8,%r9,4)
  70cb19:	0f 85 77 fe ff ff    	jne    70c996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cb1f:	4f 8d 04 88          	lea    (%r8,%r9,4),%r8
  70cb23:	41 8b 40 08          	mov    0x8(%r8),%eax
  70cb27:	48 89 fb             	mov    %rdi,%rbx
  70cb2a:	48 89 f7             	mov    %rsi,%rdi
  70cb2d:	49 89 f6             	mov    %rsi,%r14
  70cb30:	48 89 c6             	mov    %rax,%rsi
  70cb33:	49 89 cf             	mov    %rcx,%r15
  70cb36:	49 89 d4             	mov    %rdx,%r12
  70cb39:	e8 c2 da ff ff       	call   70a600 <<gpui::runtime::Runtime<unit_action_cost::Model>>::editing_at>
  70cb3e:	4c 89 f6             	mov    %r14,%rsi
  70cb41:	48 89 df             	mov    %rbx,%rdi
  70cb44:	48 85 c0             	test   %rax,%rax
  70cb47:	0f 84 49 fe ff ff    	je     70c996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cb4d:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  70cb51:	0f 84 3f fe ff ff    	je     70c996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cb57:	4c 89 e2             	mov    %r12,%rdx
  70cb5a:	4c 89 f9             	mov    %r15,%rcx
  70cb5d:	4c 8b 08             	mov    (%rax),%r9
  70cb60:	4d 85 e4             	test   %r12,%r12
  70cb63:	74 19                	je     70cb7e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x20e>
  70cb65:	4c 8b 86 b0 05 00 00 	mov    0x5b0(%rsi),%r8
  70cb6c:	49 31 d0             	xor    %rdx,%r8
  70cb6f:	49 89 ca             	mov    %rcx,%r10
  70cb72:	4d 31 ca             	xor    %r9,%r10
  70cb75:	4d 09 c2             	or     %r8,%r10
  70cb78:	41 0f 94 c0          	sete   %r8b
  70cb7c:	eb 03                	jmp    70cb81 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x211>
  70cb7e:	45 31 c0             	xor    %r8d,%r8d
  70cb81:	44 8b 50 18          	mov    0x18(%rax),%r10d
  70cb85:	8b 40 20             	mov    0x20(%rax),%eax
  70cb88:	4c 8b 9e e8 05 00 00 	mov    0x5e8(%rsi),%r11
  70cb8f:	4d 85 db             	test   %r11,%r11
  70cb92:	74 17                	je     70cbab <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x23b>
  70cb94:	4c 33 9e b0 05 00 00 	xor    0x5b0(%rsi),%r11
  70cb9b:	4c 33 8e f0 05 00 00 	xor    0x5f0(%rsi),%r9
  70cba2:	4d 09 d9             	or     %r11,%r9
  70cba5:	41 0f 94 c1          	sete   %r9b
  70cba9:	eb 03                	jmp    70cbae <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x23e>
  70cbab:	45 31 c9             	xor    %r9d,%r9d
  70cbae:	41 39 c2             	cmp    %eax,%r10d
  70cbb1:	0f 85 df fd ff ff    	jne    70c996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cbb7:	45 30 c8             	xor    %r9b,%r8b
  70cbba:	0f 84 d6 fd ff ff    	je     70c996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x26>
  70cbc0:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  70cbc7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  70cbcb:	74 28                	je     70cbf5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x285>
  70cbcd:	48 ff c0             	inc    %rax
  70cbd0:	48 89 86 60 06 00 00 	mov    %rax,0x660(%rsi)
  70cbd7:	48 ff 86 b0 06 00 00 	incq   0x6b0(%rsi)
  70cbde:	c6 86 1f 07 00 00 01 	movb   $0x1,0x71f(%rsi)
  70cbe5:	48 83 c4 08          	add    $0x8,%rsp
  70cbe9:	5b                   	pop    %rbx
  70cbea:	41 5c                	pop    %r12
  70cbec:	41 5e                	pop    %r14
  70cbee:	41 5f                	pop    %r15
  70cbf0:	e9 8b 19 01 00       	jmp    71e580 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70cbf5:	48 89 96 e8 05 00 00 	mov    %rdx,0x5e8(%rsi)
  70cbfc:	48 89 8e f0 05 00 00 	mov    %rcx,0x5f0(%rsi)
  70cc03:	48 c7 07 1f 00 00 00 	movq   $0x1f,(%rdi)
  70cc0a:	e9 de fd ff ff       	jmp    70c9ed <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change+0x7d>
