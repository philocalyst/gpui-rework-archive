
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000007049d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change>:
  7049d0:	41 57                	push   %r15
  7049d2:	41 56                	push   %r14
  7049d4:	41 54                	push   %r12
  7049d6:	53                   	push   %rbx
  7049d7:	50                   	push   %rax
  7049d8:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  7049df:	48 85 c0             	test   %rax,%rax
  7049e2:	74 12                	je     7049f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  7049e4:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  7049eb:	48 85 c0             	test   %rax,%rax
  7049ee:	74 06                	je     7049f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  7049f0:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  7049f4:	75 63                	jne    704a59 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x89>
  7049f6:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  7049fd:	0f b6 86 20 07 00 00 	movzbl 0x720(%rsi),%eax
  704a04:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  704a0b:	00 
  704a0c:	74 1c                	je     704a2a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x5a>
  704a0e:	84 c0                	test   %al,%al
  704a10:	74 0a                	je     704a1c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x4c>
  704a12:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  704a19:	ff 
  704a1a:	74 0e                	je     704a2a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x5a>
  704a1c:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  704a23:	b9 01 00 00 00       	mov    $0x1,%ecx
  704a28:	eb 02                	jmp    704a2c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x5c>
  704a2a:	31 c9                	xor    %ecx,%ecx
  704a2c:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  704a33:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  704a37:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  704a3b:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  704a3f:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  704a43:	88 47 30             	mov    %al,0x30(%rdi)
  704a46:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  704a4d:	48 83 c4 08          	add    $0x8,%rsp
  704a51:	5b                   	pop    %rbx
  704a52:	41 5c                	pop    %r12
  704a54:	41 5e                	pop    %r14
  704a56:	41 5f                	pop    %r15
  704a58:	c3                   	ret
  704a59:	48 8b 00             	mov    (%rax),%rax
  704a5c:	4c 8b 86 e8 01 00 00 	mov    0x1e8(%rsi),%r8
  704a63:	4d 85 c0             	test   %r8,%r8
  704a66:	0f 84 99 00 00 00    	je     704b05 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x135>
  704a6c:	41 83 f8 01          	cmp    $0x1,%r8d
  704a70:	0f 85 ab 00 00 00    	jne    704b21 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x151>
  704a76:	4c 8b 96 f8 01 00 00 	mov    0x1f8(%rsi),%r10
  704a7d:	4d 85 d2             	test   %r10,%r10
  704a80:	0f 84 70 ff ff ff    	je     7049f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  704a86:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  704a8d:	45 31 c9             	xor    %r9d,%r9d
  704a90:	49 83 fa 01          	cmp    $0x1,%r10
  704a94:	74 2e                	je     704ac4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0xf4>
  704a96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  704a9d:	00 00 00 
  704aa0:	4d 89 cb             	mov    %r9,%r11
  704aa3:	4c 89 d3             	mov    %r10,%rbx
  704aa6:	48 d1 eb             	shr    $1,%rbx
  704aa9:	49 01 d9             	add    %rbx,%r9
  704aac:	4d 89 ce             	mov    %r9,%r14
  704aaf:	49 c1 e6 04          	shl    $0x4,%r14
  704ab3:	4b 39 04 30          	cmp    %rax,(%r8,%r14,1)
  704ab7:	4d 0f 47 cb          	cmova  %r11,%r9
  704abb:	49 29 da             	sub    %rbx,%r10
  704abe:	49 83 fa 01          	cmp    $0x1,%r10
  704ac2:	77 dc                	ja     704aa0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0xd0>
  704ac4:	4d 89 cb             	mov    %r9,%r11
  704ac7:	49 c1 e3 04          	shl    $0x4,%r11
  704acb:	45 31 d2             	xor    %r10d,%r10d
  704ace:	4b 39 04 18          	cmp    %rax,(%r8,%r11,1)
  704ad2:	41 0f 96 c2          	setbe  %r10b
  704ad6:	4d 01 ca             	add    %r9,%r10
  704ad9:	0f 84 17 ff ff ff    	je     7049f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  704adf:	49 c1 e2 04          	shl    $0x4,%r10
  704ae3:	4b 2b 44 10 f0       	sub    -0x10(%r8,%r10,1),%rax
  704ae8:	47 8b 4c 10 fc       	mov    -0x4(%r8,%r10,1),%r9d
  704aed:	4c 39 c8             	cmp    %r9,%rax
  704af0:	0f 83 00 ff ff ff    	jae    7049f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  704af6:	4d 01 d0             	add    %r10,%r8
  704af9:	45 8b 40 f8          	mov    -0x8(%r8),%r8d
  704afd:	4c 01 c0             	add    %r8,%rax
  704b00:	e9 82 00 00 00       	jmp    704b87 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x1b7>
  704b05:	48 2b 86 f0 01 00 00 	sub    0x1f0(%rsi),%rax
  704b0c:	0f 82 e4 fe ff ff    	jb     7049f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  704b12:	48 3b 86 f8 01 00 00 	cmp    0x1f8(%rsi),%rax
  704b19:	0f 83 d7 fe ff ff    	jae    7049f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  704b1f:	eb 66                	jmp    704b87 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x1b7>
  704b21:	4c 8b 8e f8 01 00 00 	mov    0x1f8(%rsi),%r9
  704b28:	4d 85 c9             	test   %r9,%r9
  704b2b:	0f 84 c5 fe ff ff    	je     7049f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  704b31:	4c 8b 86 f0 01 00 00 	mov    0x1f0(%rsi),%r8
  704b38:	49 83 f9 01          	cmp    $0x1,%r9
  704b3c:	75 0b                	jne    704b49 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x179>
  704b3e:	49 39 00             	cmp    %rax,(%r8)
  704b41:	0f 85 af fe ff ff    	jne    7049f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  704b47:	eb 3a                	jmp    704b83 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x1b3>
  704b49:	45 31 d2             	xor    %r10d,%r10d
  704b4c:	0f 1f 40 00          	nopl   0x0(%rax)
  704b50:	4d 89 d3             	mov    %r10,%r11
  704b53:	4c 89 cb             	mov    %r9,%rbx
  704b56:	48 d1 eb             	shr    $1,%rbx
  704b59:	49 01 da             	add    %rbx,%r10
  704b5c:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  704b60:	4b 39 04 b0          	cmp    %rax,(%r8,%r14,4)
  704b64:	4d 0f 47 d3          	cmova  %r11,%r10
  704b68:	49 29 d9             	sub    %rbx,%r9
  704b6b:	49 83 f9 01          	cmp    $0x1,%r9
  704b6f:	77 df                	ja     704b50 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x180>
  704b71:	4f 8d 0c 52          	lea    (%r10,%r10,2),%r9
  704b75:	4b 39 04 88          	cmp    %rax,(%r8,%r9,4)
  704b79:	0f 85 77 fe ff ff    	jne    7049f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  704b7f:	4f 8d 04 88          	lea    (%r8,%r9,4),%r8
  704b83:	41 8b 40 08          	mov    0x8(%r8),%eax
  704b87:	48 89 fb             	mov    %rdi,%rbx
  704b8a:	48 89 f7             	mov    %rsi,%rdi
  704b8d:	49 89 f6             	mov    %rsi,%r14
  704b90:	48 89 c6             	mov    %rax,%rsi
  704b93:	49 89 cf             	mov    %rcx,%r15
  704b96:	49 89 d4             	mov    %rdx,%r12
  704b99:	e8 52 c6 ff ff       	call   7011f0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::editing_at>
  704b9e:	4c 89 f6             	mov    %r14,%rsi
  704ba1:	48 89 df             	mov    %rbx,%rdi
  704ba4:	48 85 c0             	test   %rax,%rax
  704ba7:	0f 84 49 fe ff ff    	je     7049f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  704bad:	80 78 24 02          	cmpb   $0x2,0x24(%rax)
  704bb1:	0f 84 3f fe ff ff    	je     7049f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  704bb7:	4c 89 e2             	mov    %r12,%rdx
  704bba:	4c 89 f9             	mov    %r15,%rcx
  704bbd:	4c 8b 08             	mov    (%rax),%r9
  704bc0:	4d 85 e4             	test   %r12,%r12
  704bc3:	74 19                	je     704bde <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x20e>
  704bc5:	4c 8b 86 b0 05 00 00 	mov    0x5b0(%rsi),%r8
  704bcc:	49 31 d0             	xor    %rdx,%r8
  704bcf:	49 89 ca             	mov    %rcx,%r10
  704bd2:	4d 31 ca             	xor    %r9,%r10
  704bd5:	4d 09 c2             	or     %r8,%r10
  704bd8:	41 0f 94 c0          	sete   %r8b
  704bdc:	eb 03                	jmp    704be1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x211>
  704bde:	45 31 c0             	xor    %r8d,%r8d
  704be1:	44 8b 50 18          	mov    0x18(%rax),%r10d
  704be5:	8b 40 20             	mov    0x20(%rax),%eax
  704be8:	4c 8b 9e e8 05 00 00 	mov    0x5e8(%rsi),%r11
  704bef:	4d 85 db             	test   %r11,%r11
  704bf2:	74 17                	je     704c0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x23b>
  704bf4:	4c 33 9e b0 05 00 00 	xor    0x5b0(%rsi),%r11
  704bfb:	4c 33 8e f0 05 00 00 	xor    0x5f0(%rsi),%r9
  704c02:	4d 09 d9             	or     %r11,%r9
  704c05:	41 0f 94 c1          	sete   %r9b
  704c09:	eb 03                	jmp    704c0e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x23e>
  704c0b:	45 31 c9             	xor    %r9d,%r9d
  704c0e:	41 39 c2             	cmp    %eax,%r10d
  704c11:	0f 85 df fd ff ff    	jne    7049f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  704c17:	45 30 c8             	xor    %r9b,%r8b
  704c1a:	0f 84 d6 fd ff ff    	je     7049f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x26>
  704c20:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  704c27:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  704c2b:	74 28                	je     704c55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x285>
  704c2d:	48 ff c0             	inc    %rax
  704c30:	48 89 86 60 06 00 00 	mov    %rax,0x660(%rsi)
  704c37:	48 ff 86 b0 06 00 00 	incq   0x6b0(%rsi)
  704c3e:	c6 86 1f 07 00 00 01 	movb   $0x1,0x71f(%rsi)
  704c45:	48 83 c4 08          	add    $0x8,%rsp
  704c49:	5b                   	pop    %rbx
  704c4a:	41 5c                	pop    %r12
  704c4c:	41 5e                	pop    %r14
  704c4e:	41 5f                	pop    %r15
  704c50:	e9 6b 35 02 00       	jmp    7281c0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  704c55:	48 89 96 e8 05 00 00 	mov    %rdx,0x5e8(%rsi)
  704c5c:	48 89 8e f0 05 00 00 	mov    %rcx,0x5f0(%rsi)
  704c63:	48 c7 07 1f 00 00 00 	movq   $0x1f,(%rdi)
  704c6a:	e9 de fd ff ff       	jmp    704a4d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change+0x7d>
