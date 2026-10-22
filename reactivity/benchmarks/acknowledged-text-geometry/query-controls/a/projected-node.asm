
/tmp/gpui-ack-query-comparison/a/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a5f940 <gpui::native::accessibility::projected_node>:
  a5f940:	55                   	push   %rbp
  a5f941:	41 57                	push   %r15
  a5f943:	41 56                	push   %r14
  a5f945:	41 55                	push   %r13
  a5f947:	41 54                	push   %r12
  a5f949:	53                   	push   %rbx
  a5f94a:	48 81 ec 58 01 00 00 	sub    $0x158,%rsp
  a5f951:	49 89 f4             	mov    %rsi,%r12
  a5f954:	49 89 ff             	mov    %rdi,%r15
  a5f957:	89 d7                	mov    %edx,%edi
  a5f959:	48 8b 76 38          	mov    0x38(%rsi),%rsi
  a5f95d:	48 39 fe             	cmp    %rdi,%rsi
  a5f960:	0f 86 1d 0a 00 00    	jbe    a60383 <gpui::native::accessibility::projected_node+0xa43>
  a5f966:	41 89 d5             	mov    %edx,%r13d
  a5f969:	48 89 b4 24 00 01 00 	mov    %rsi,0x100(%rsp)
  a5f970:	00 
  a5f971:	49 8b 4c 24 30       	mov    0x30(%r12),%rcx
  a5f976:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  a5f97a:	48 c1 e0 04          	shl    $0x4,%rax
  a5f97e:	48 8d 1c 01          	lea    (%rcx,%rax,1),%rbx
  a5f982:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  a5f987:	0f b6 4c 01 4d       	movzbl 0x4d(%rcx,%rax,1),%ecx
  a5f98c:	48 8d 05 a9 d6 73 ff 	lea    -0x8c2957(%rip),%rax        # 19d03c <anon.e07b3fe1e30566ac186940ce1c463e28.14.llvm.1651238746562193456+0x80>
  a5f993:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  a5f998:	48 63 0c 88          	movslq (%rax,%rcx,4),%rcx
  a5f99c:	48 01 c1             	add    %rax,%rcx
  a5f99f:	49 be 57 57 57 57 57 	movabs $0x5757575757575757,%r14
  a5f9a6:	57 57 57 
  a5f9a9:	89 94 24 10 01 00 00 	mov    %edx,0x110(%rsp)
  a5f9b0:	ff e1                	jmp    *%rcx
  a5f9b2:	40 b5 12             	mov    $0x12,%bpl
  a5f9b5:	f6 43 4c 01          	testb  $0x1,0x4c(%rbx)
  a5f9b9:	0f 85 ac 00 00 00    	jne    a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a5f9bf:	4c 89 e7             	mov    %r12,%rdi
  a5f9c2:	44 89 ee             	mov    %r13d,%esi
  a5f9c5:	ff 15 7d 18 ad 00    	call   *0xad187d(%rip)        # 1531248 <_DYNAMIC+0x16a8>
  a5f9cb:	40 b5 4e             	mov    $0x4e,%bpl
  a5f9ce:	48 85 c0             	test   %rax,%rax
  a5f9d1:	0f 85 94 00 00 00    	jne    a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a5f9d7:	49 8b 44 24 60       	mov    0x60(%r12),%rax
  a5f9dc:	40 b5 0e             	mov    $0xe,%bpl
  a5f9df:	48 85 c0             	test   %rax,%rax
  a5f9e2:	0f 84 83 00 00 00    	je     a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a5f9e8:	48 8b 50 40          	mov    0x40(%rax),%rdx
  a5f9ec:	48 85 d2             	test   %rdx,%rdx
  a5f9ef:	74 7a                	je     a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a5f9f1:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  a5f9f5:	48 8b 40 38          	mov    0x38(%rax),%rax
  a5f9f9:	48 83 fa 01          	cmp    $0x1,%rdx
  a5f9fd:	0f 85 33 09 00 00    	jne    a60336 <gpui::native::accessibility::projected_node+0x9f6>
  a5fa03:	48 39 08             	cmp    %rcx,(%rax)
  a5fa06:	75 63                	jne    a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a5fa08:	e9 60 09 00 00       	jmp    a6036d <gpui::native::accessibility::projected_node+0xa2d>
  a5fa0d:	40 b5 18             	mov    $0x18,%bpl
  a5fa10:	eb 59                	jmp    a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a5fa12:	40 b5 11             	mov    $0x11,%bpl
  a5fa15:	eb 54                	jmp    a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a5fa17:	40 b5 12             	mov    $0x12,%bpl
  a5fa1a:	eb 4f                	jmp    a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a5fa1c:	40 b5 6c             	mov    $0x6c,%bpl
  a5fa1f:	eb 4a                	jmp    a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a5fa21:	4c 89 e7             	mov    %r12,%rdi
  a5fa24:	44 89 ee             	mov    %r13d,%esi
  a5fa27:	ff 15 1b 18 ad 00    	call   *0xad181b(%rip)        # 1531248 <_DYNAMIC+0x16a8>
  a5fa2d:	48 8b 73 28          	mov    0x28(%rbx),%rsi
  a5fa31:	40 b5 4e             	mov    $0x4e,%bpl
  a5fa34:	48 85 f6             	test   %rsi,%rsi
  a5fa37:	0f 84 bb 02 00 00    	je     a5fcf8 <gpui::native::accessibility::projected_node+0x3b8>
  a5fa3d:	48 85 c0             	test   %rax,%rax
  a5fa40:	74 29                	je     a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a5fa42:	48 8b 0e             	mov    (%rsi),%rcx
  a5fa45:	48 d1 e9             	shr    $1,%rcx
  a5fa48:	48 39 ca             	cmp    %rcx,%rdx
  a5fa4b:	75 1e                	jne    a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a5fa4d:	48 83 c6 10          	add    $0x10,%rsi
  a5fa51:	48 89 c7             	mov    %rax,%rdi
  a5fa54:	ff 15 6e 05 ad 00    	call   *0xad056e(%rip)        # 152ffc8 <bcmp@GLIBC_2.2.5>
  a5fa5a:	85 c0                	test   %eax,%eax
  a5fa5c:	75 0d                	jne    a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a5fa5e:	e9 9e 02 00 00       	jmp    a5fd01 <gpui::native::accessibility::projected_node+0x3c1>
  a5fa63:	40 b5 07             	mov    $0x7,%bpl
  a5fa66:	eb 03                	jmp    a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a5fa68:	40 b5 04             	mov    $0x4,%bpl
  a5fa6b:	40 88 ac 24 fc 00 00 	mov    %bpl,0xfc(%rsp)
  a5fa72:	00 
  a5fa73:	48 c7 84 24 f0 00 00 	movq   $0x0,0xf0(%rsp)
  a5fa7a:	00 00 00 00 00 
  a5fa7f:	c7 84 24 f8 00 00 00 	movl   $0x0,0xf8(%rsp)
  a5fa86:	00 00 00 00 
  a5fa8a:	48 c7 84 24 80 00 00 	movq   $0x0,0x80(%rsp)
  a5fa91:	00 00 00 00 00 
  a5fa96:	48 c7 84 24 88 00 00 	movq   $0x8,0x88(%rsp)
  a5fa9d:	00 08 00 00 00 
  a5faa2:	48 c7 84 24 90 00 00 	movq   $0x0,0x90(%rsp)
  a5faa9:	00 00 00 00 00 
  a5faae:	66 0f 28 05 ba d6 72 	movapd -0x8d2946(%rip),%xmm0        # 18d170 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a5fab5:	ff 
  a5fab6:	66 0f 11 84 24 98 00 	movupd %xmm0,0x98(%rsp)
  a5fabd:	00 00 
  a5fabf:	66 0f 11 84 24 a8 00 	movupd %xmm0,0xa8(%rsp)
  a5fac6:	00 00 
  a5fac8:	66 0f 11 84 24 b8 00 	movupd %xmm0,0xb8(%rsp)
  a5facf:	00 00 
  a5fad1:	66 0f 11 84 24 c8 00 	movupd %xmm0,0xc8(%rsp)
  a5fad8:	00 00 
  a5fada:	66 0f 11 84 24 d8 00 	movupd %xmm0,0xd8(%rsp)
  a5fae1:	00 00 
  a5fae3:	4c 89 b4 24 e7 00 00 	mov    %r14,0xe7(%rsp)
  a5faea:	00 
  a5faeb:	4c 89 e7             	mov    %r12,%rdi
  a5faee:	44 89 ee             	mov    %r13d,%esi
  a5faf1:	ff 15 51 17 ad 00    	call   *0xad1751(%rip)        # 1531248 <_DYNAMIC+0x16a8>
  a5faf7:	48 85 c0             	test   %rax,%rax
  a5fafa:	0f 84 8b 00 00 00    	je     a5fb8b <gpui::native::accessibility::projected_node+0x24b>
  a5fb00:	49 89 d6             	mov    %rdx,%r14
  a5fb03:	48 85 d2             	test   %rdx,%rdx
  a5fb06:	79 11                	jns    a5fb19 <gpui::native::accessibility::projected_node+0x1d9>
  a5fb08:	45 31 ff             	xor    %r15d,%r15d
  a5fb0b:	4c 89 ff             	mov    %r15,%rdi
  a5fb0e:	4c 89 f6             	mov    %r14,%rsi
  a5fb11:	ff 15 c1 03 ad 00    	call   *0xad03c1(%rip)        # 152fed8 <_DYNAMIC+0x338>
  a5fb17:	0f 0b                	ud2
  a5fb19:	74 3e                	je     a5fb59 <gpui::native::accessibility::projected_node+0x219>
  a5fb1b:	4c 89 3c 24          	mov    %r15,(%rsp)
  a5fb1f:	48 89 c5             	mov    %rax,%rbp
  a5fb22:	ff 15 b8 02 ad 00    	call   *0xad02b8(%rip)        # 152fde0 <_DYNAMIC+0x240>
  a5fb28:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  a5fb2e:	be 01 00 00 00       	mov    $0x1,%esi
  a5fb33:	4c 89 f7             	mov    %r14,%rdi
  a5fb36:	ff 15 ac 02 ad 00    	call   *0xad02ac(%rip)        # 152fde8 <_DYNAMIC+0x248>
  a5fb3c:	48 85 c0             	test   %rax,%rax
  a5fb3f:	74 ca                	je     a5fb0b <gpui::native::accessibility::projected_node+0x1cb>
  a5fb41:	49 89 c5             	mov    %rax,%r13
  a5fb44:	48 89 c7             	mov    %rax,%rdi
  a5fb47:	48 89 ee             	mov    %rbp,%rsi
  a5fb4a:	4c 89 f2             	mov    %r14,%rdx
  a5fb4d:	ff 15 ad 02 ad 00    	call   *0xad02ad(%rip)        # 152fe00 <memcpy@GLIBC_2.14>
  a5fb53:	4c 8b 3c 24          	mov    (%rsp),%r15
  a5fb57:	eb 06                	jmp    a5fb5f <gpui::native::accessibility::projected_node+0x21f>
  a5fb59:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  a5fb5f:	4c 89 74 24 28       	mov    %r14,0x28(%rsp)
  a5fb64:	4c 89 6c 24 30       	mov    %r13,0x30(%rsp)
  a5fb69:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  a5fb6e:	c6 44 24 20 03       	movb   $0x3,0x20(%rsp)
  a5fb73:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a5fb7a:	00 
  a5fb7b:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a5fb80:	be 0f 00 00 00       	mov    $0xf,%esi
  a5fb85:	ff 15 d5 16 ad 00    	call   *0xad16d5(%rip)        # 1531260 <_DYNAMIC+0x16c0>
  a5fb8b:	80 7b 4d 02          	cmpb   $0x2,0x4d(%rbx)
  a5fb8f:	0f 85 86 00 00 00    	jne    a5fc1b <gpui::native::accessibility::projected_node+0x2db>
  a5fb95:	4c 8b 6b 28          	mov    0x28(%rbx),%r13
  a5fb99:	4d 85 ed             	test   %r13,%r13
  a5fb9c:	74 7d                	je     a5fc1b <gpui::native::accessibility::projected_node+0x2db>
  a5fb9e:	4d 8b 75 00          	mov    0x0(%r13),%r14
  a5fba2:	49 d1 ee             	shr    $1,%r14
  a5fba5:	74 43                	je     a5fbea <gpui::native::accessibility::projected_node+0x2aa>
  a5fba7:	4c 89 3c 24          	mov    %r15,(%rsp)
  a5fbab:	ff 15 2f 02 ad 00    	call   *0xad022f(%rip)        # 152fde0 <_DYNAMIC+0x240>
  a5fbb1:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  a5fbb7:	be 01 00 00 00       	mov    $0x1,%esi
  a5fbbc:	4c 89 f7             	mov    %r14,%rdi
  a5fbbf:	ff 15 23 02 ad 00    	call   *0xad0223(%rip)        # 152fde8 <_DYNAMIC+0x248>
  a5fbc5:	48 85 c0             	test   %rax,%rax
  a5fbc8:	0f 84 3d ff ff ff    	je     a5fb0b <gpui::native::accessibility::projected_node+0x1cb>
  a5fbce:	48 89 c5             	mov    %rax,%rbp
  a5fbd1:	49 83 c5 10          	add    $0x10,%r13
  a5fbd5:	48 89 c7             	mov    %rax,%rdi
  a5fbd8:	4c 89 ee             	mov    %r13,%rsi
  a5fbdb:	4c 89 f2             	mov    %r14,%rdx
  a5fbde:	ff 15 1c 02 ad 00    	call   *0xad021c(%rip)        # 152fe00 <memcpy@GLIBC_2.14>
  a5fbe4:	4c 8b 3c 24          	mov    (%rsp),%r15
  a5fbe8:	eb 05                	jmp    a5fbef <gpui::native::accessibility::projected_node+0x2af>
  a5fbea:	bd 01 00 00 00       	mov    $0x1,%ebp
  a5fbef:	4c 89 74 24 28       	mov    %r14,0x28(%rsp)
  a5fbf4:	48 89 6c 24 30       	mov    %rbp,0x30(%rsp)
  a5fbf9:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  a5fbfe:	c6 44 24 20 03       	movb   $0x3,0x20(%rsp)
  a5fc03:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a5fc0a:	00 
  a5fc0b:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a5fc10:	be 11 00 00 00       	mov    $0x11,%esi
  a5fc15:	ff 15 45 16 ad 00    	call   *0xad1645(%rip)        # 1531260 <_DYNAMIC+0x16c0>
  a5fc1b:	4d 8b 6c 24 60       	mov    0x60(%r12),%r13
  a5fc20:	4d 85 ed             	test   %r13,%r13
  a5fc23:	0f 84 18 02 00 00    	je     a5fe41 <gpui::native::accessibility::projected_node+0x501>
  a5fc29:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  a5fc2d:	49 8b 4d 40          	mov    0x40(%r13),%rcx
  a5fc31:	48 85 c9             	test   %rcx,%rcx
  a5fc34:	0f 84 dc 01 00 00    	je     a5fe16 <gpui::native::accessibility::projected_node+0x4d6>
  a5fc3a:	49 8b 45 38          	mov    0x38(%r13),%rax
  a5fc3e:	48 83 f9 01          	cmp    $0x1,%rcx
  a5fc42:	75 17                	jne    a5fc5b <gpui::native::accessibility::projected_node+0x31b>
  a5fc44:	48 39 10             	cmp    %rdx,(%rax)
  a5fc47:	0f 85 c9 01 00 00    	jne    a5fe16 <gpui::native::accessibility::projected_node+0x4d6>
  a5fc4d:	48 8b 68 08          	mov    0x8(%rax),%rbp
  a5fc51:	48 85 ed             	test   %rbp,%rbp
  a5fc54:	75 4c                	jne    a5fca2 <gpui::native::accessibility::projected_node+0x362>
  a5fc56:	e9 bb 01 00 00       	jmp    a5fe16 <gpui::native::accessibility::projected_node+0x4d6>
  a5fc5b:	31 f6                	xor    %esi,%esi
  a5fc5d:	0f 1f 00             	nopl   (%rax)
  a5fc60:	48 89 f7             	mov    %rsi,%rdi
  a5fc63:	49 89 c8             	mov    %rcx,%r8
  a5fc66:	49 d1 e8             	shr    $1,%r8
  a5fc69:	4c 01 c6             	add    %r8,%rsi
  a5fc6c:	49 89 f1             	mov    %rsi,%r9
  a5fc6f:	49 c1 e1 04          	shl    $0x4,%r9
  a5fc73:	4a 39 14 08          	cmp    %rdx,(%rax,%r9,1)
  a5fc77:	48 0f 47 f7          	cmova  %rdi,%rsi
  a5fc7b:	4c 29 c1             	sub    %r8,%rcx
  a5fc7e:	48 83 f9 01          	cmp    $0x1,%rcx
  a5fc82:	77 dc                	ja     a5fc60 <gpui::native::accessibility::projected_node+0x320>
  a5fc84:	48 c1 e6 04          	shl    $0x4,%rsi
  a5fc88:	48 39 14 30          	cmp    %rdx,(%rax,%rsi,1)
  a5fc8c:	0f 85 84 01 00 00    	jne    a5fe16 <gpui::native::accessibility::projected_node+0x4d6>
  a5fc92:	48 01 f0             	add    %rsi,%rax
  a5fc95:	48 8b 68 08          	mov    0x8(%rax),%rbp
  a5fc99:	48 85 ed             	test   %rbp,%rbp
  a5fc9c:	0f 84 74 01 00 00    	je     a5fe16 <gpui::native::accessibility::projected_node+0x4d6>
  a5fca2:	4c 8b 75 00          	mov    0x0(%rbp),%r14
  a5fca6:	49 d1 ee             	shr    $1,%r14
  a5fca9:	0f 84 32 01 00 00    	je     a5fde1 <gpui::native::accessibility::projected_node+0x4a1>
  a5fcaf:	4c 89 3c 24          	mov    %r15,(%rsp)
  a5fcb3:	ff 15 27 01 ad 00    	call   *0xad0127(%rip)        # 152fde0 <_DYNAMIC+0x240>
  a5fcb9:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  a5fcbf:	be 01 00 00 00       	mov    $0x1,%esi
  a5fcc4:	4c 89 f7             	mov    %r14,%rdi
  a5fcc7:	ff 15 1b 01 ad 00    	call   *0xad011b(%rip)        # 152fde8 <_DYNAMIC+0x248>
  a5fccd:	48 85 c0             	test   %rax,%rax
  a5fcd0:	0f 84 35 fe ff ff    	je     a5fb0b <gpui::native::accessibility::projected_node+0x1cb>
  a5fcd6:	48 83 c5 10          	add    $0x10,%rbp
  a5fcda:	48 89 c7             	mov    %rax,%rdi
  a5fcdd:	48 89 ee             	mov    %rbp,%rsi
  a5fce0:	4c 89 f2             	mov    %r14,%rdx
  a5fce3:	49 89 c7             	mov    %rax,%r15
  a5fce6:	ff 15 14 01 ad 00    	call   *0xad0114(%rip)        # 152fe00 <memcpy@GLIBC_2.14>
  a5fcec:	4c 89 f8             	mov    %r15,%rax
  a5fcef:	4c 8b 3c 24          	mov    (%rsp),%r15
  a5fcf3:	e9 ee 00 00 00       	jmp    a5fde6 <gpui::native::accessibility::projected_node+0x4a6>
  a5fcf8:	48 85 c0             	test   %rax,%rax
  a5fcfb:	0f 85 6a fd ff ff    	jne    a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a5fd01:	c6 84 24 fc 00 00 00 	movb   $0x3,0xfc(%rsp)
  a5fd08:	03 
  a5fd09:	48 c7 84 24 f0 00 00 	movq   $0x0,0xf0(%rsp)
  a5fd10:	00 00 00 00 00 
  a5fd15:	c7 84 24 f8 00 00 00 	movl   $0x0,0xf8(%rsp)
  a5fd1c:	00 00 00 00 
  a5fd20:	48 c7 84 24 80 00 00 	movq   $0x0,0x80(%rsp)
  a5fd27:	00 00 00 00 00 
  a5fd2c:	48 c7 84 24 88 00 00 	movq   $0x8,0x88(%rsp)
  a5fd33:	00 08 00 00 00 
  a5fd38:	48 c7 84 24 90 00 00 	movq   $0x0,0x90(%rsp)
  a5fd3f:	00 00 00 00 00 
  a5fd44:	66 0f 28 05 24 d4 72 	movapd -0x8d2bdc(%rip),%xmm0        # 18d170 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a5fd4b:	ff 
  a5fd4c:	66 0f 11 84 24 98 00 	movupd %xmm0,0x98(%rsp)
  a5fd53:	00 00 
  a5fd55:	66 0f 11 84 24 a8 00 	movupd %xmm0,0xa8(%rsp)
  a5fd5c:	00 00 
  a5fd5e:	66 0f 11 84 24 b8 00 	movupd %xmm0,0xb8(%rsp)
  a5fd65:	00 00 
  a5fd67:	66 0f 11 84 24 c8 00 	movupd %xmm0,0xc8(%rsp)
  a5fd6e:	00 00 
  a5fd70:	66 0f 11 84 24 d8 00 	movupd %xmm0,0xd8(%rsp)
  a5fd77:	00 00 
  a5fd79:	4c 89 b4 24 e7 00 00 	mov    %r14,0xe7(%rsp)
  a5fd80:	00 
  a5fd81:	4c 8b 6b 28          	mov    0x28(%rbx),%r13
  a5fd85:	4d 85 ed             	test   %r13,%r13
  a5fd88:	0f 84 fd fd ff ff    	je     a5fb8b <gpui::native::accessibility::projected_node+0x24b>
  a5fd8e:	4d 8b 75 00          	mov    0x0(%r13),%r14
  a5fd92:	49 d1 ee             	shr    $1,%r14
  a5fd95:	0f 84 65 05 00 00    	je     a60300 <gpui::native::accessibility::projected_node+0x9c0>
  a5fd9b:	4c 89 3c 24          	mov    %r15,(%rsp)
  a5fd9f:	ff 15 3b 00 ad 00    	call   *0xad003b(%rip)        # 152fde0 <_DYNAMIC+0x240>
  a5fda5:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  a5fdab:	be 01 00 00 00       	mov    $0x1,%esi
  a5fdb0:	4c 89 f7             	mov    %r14,%rdi
  a5fdb3:	ff 15 2f 00 ad 00    	call   *0xad002f(%rip)        # 152fde8 <_DYNAMIC+0x248>
  a5fdb9:	48 85 c0             	test   %rax,%rax
  a5fdbc:	0f 84 49 fd ff ff    	je     a5fb0b <gpui::native::accessibility::projected_node+0x1cb>
  a5fdc2:	48 89 c5             	mov    %rax,%rbp
  a5fdc5:	49 83 c5 10          	add    $0x10,%r13
  a5fdc9:	48 89 c7             	mov    %rax,%rdi
  a5fdcc:	4c 89 ee             	mov    %r13,%rsi
  a5fdcf:	4c 89 f2             	mov    %r14,%rdx
  a5fdd2:	ff 15 28 00 ad 00    	call   *0xad0028(%rip)        # 152fe00 <memcpy@GLIBC_2.14>
  a5fdd8:	4c 8b 3c 24          	mov    (%rsp),%r15
  a5fddc:	e9 24 05 00 00       	jmp    a60305 <gpui::native::accessibility::projected_node+0x9c5>
  a5fde1:	b8 01 00 00 00       	mov    $0x1,%eax
  a5fde6:	4c 89 74 24 28       	mov    %r14,0x28(%rsp)
  a5fdeb:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  a5fdf0:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  a5fdf5:	c6 44 24 20 03       	movb   $0x3,0x20(%rsp)
  a5fdfa:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a5fe01:	00 
  a5fe02:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a5fe07:	be 10 00 00 00       	mov    $0x10,%esi
  a5fe0c:	ff 15 4e 14 ad 00    	call   *0xad144e(%rip)        # 1531260 <_DYNAMIC+0x16c0>
  a5fe12:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  a5fe16:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  a5fe1b:	4c 89 ee             	mov    %r13,%rsi
  a5fe1e:	e8 fd a4 ff ff       	call   a5a320 <<gpui::runtime::scroll::ViewportColumn>::list>
  a5fe23:	83 7c 24 20 01       	cmpl   $0x1,0x20(%rsp)
  a5fe28:	75 17                	jne    a5fe41 <gpui::native::accessibility::projected_node+0x501>
  a5fe2a:	8b 54 24 30          	mov    0x30(%rsp),%edx
  a5fe2e:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a5fe35:	00 
  a5fe36:	be 38 00 00 00       	mov    $0x38,%esi
  a5fe3b:	ff 15 27 14 ad 00    	call   *0xad1427(%rip)        # 1531268 <_DYNAMIC+0x16c8>
  a5fe41:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  a5fe46:	4c 89 e6             	mov    %r12,%rsi
  a5fe49:	8b 94 24 10 01 00 00 	mov    0x110(%rsp),%edx
  a5fe50:	ff 15 1a 14 ad 00    	call   *0xad141a(%rip)        # 1531270 <_DYNAMIC+0x16d0>
  a5fe56:	48 83 7c 24 20 00    	cmpq   $0x0,0x20(%rsp)
  a5fe5c:	74 17                	je     a5fe75 <gpui::native::accessibility::projected_node+0x535>
  a5fe5e:	8b 54 24 38          	mov    0x38(%rsp),%edx
  a5fe62:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a5fe69:	00 
  a5fe6a:	be 39 00 00 00       	mov    $0x39,%esi
  a5fe6f:	ff 15 f3 13 ad 00    	call   *0xad13f3(%rip)        # 1531268 <_DYNAMIC+0x16c8>
  a5fe75:	f3 0f 10 43 30       	movss  0x30(%rbx),%xmm0
  a5fe7a:	0f 2e c0             	ucomiss %xmm0,%xmm0
  a5fe7d:	0f 8a 91 00 00 00    	jp     a5ff14 <gpui::native::accessibility::projected_node+0x5d4>
  a5fe83:	f3 0f 10 4b 34       	movss  0x34(%rbx),%xmm1
  a5fe88:	0f 14 c1             	unpcklps %xmm1,%xmm0
  a5fe8b:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  a5fe8e:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  a5fe93:	0f 5a 43 38          	cvtps2pd 0x38(%rbx),%xmm0
  a5fe97:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  a5fe9c:	0f 5a 43 40          	cvtps2pd 0x40(%rbx),%xmm0
  a5fea0:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  a5fea5:	c6 44 24 50 00       	movb   $0x0,0x50(%rsp)
  a5feaa:	66 0f 10 03          	movupd (%rbx),%xmm0
  a5feae:	66 0f 29 84 24 40 01 	movapd %xmm0,0x140(%rsp)
  a5feb5:	00 00 
  a5feb7:	48 8d bc 24 2c 01 00 	lea    0x12c(%rsp),%rdi
  a5febe:	00 
  a5febf:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  a5fec4:	48 8d 94 24 40 01 00 	lea    0x140(%rsp),%rdx
  a5fecb:	00 
  a5fecc:	ff 15 56 00 ad 00    	call   *0xad0056(%rip)        # 152ff28 <_DYNAMIC+0x388>
  a5fed2:	83 bc 24 2c 01 00 00 	cmpl   $0x1,0x12c(%rsp)
  a5fed9:	01 
  a5feda:	75 38                	jne    a5ff14 <gpui::native::accessibility::projected_node+0x5d4>
  a5fedc:	0f 5a 84 24 30 01 00 	cvtps2pd 0x130(%rsp),%xmm0
  a5fee3:	00 
  a5fee4:	0f 5a 8c 24 38 01 00 	cvtps2pd 0x138(%rsp),%xmm1
  a5feeb:	00 
  a5feec:	66 0f 58 c8          	addpd  %xmm0,%xmm1
  a5fef0:	66 0f 29 44 24 20    	movapd %xmm0,0x20(%rsp)
  a5fef6:	66 0f 29 4c 24 30    	movapd %xmm1,0x30(%rsp)
  a5fefc:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a5ff03:	00 
  a5ff04:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a5ff09:	be 53 00 00 00       	mov    $0x53,%esi
  a5ff0e:	ff 15 64 13 ad 00    	call   *0xad1364(%rip)        # 1531278 <_DYNAMIC+0x16d8>
  a5ff14:	b8 4f 00 00 00       	mov    $0x4f,%eax
  a5ff19:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  a5ff1e:	0f a3 c8             	bt     %ecx,%eax
  a5ff21:	73 67                	jae    a5ff8a <gpui::native::accessibility::projected_node+0x64a>
  a5ff23:	4d 85 ed             	test   %r13,%r13
  a5ff26:	74 6f                	je     a5ff97 <gpui::native::accessibility::projected_node+0x657>
  a5ff28:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  a5ff2c:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  a5ff31:	4c 89 ee             	mov    %r13,%rsi
  a5ff34:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  a5ff39:	4c 8b 84 24 00 01 00 	mov    0x100(%rsp),%r8
  a5ff40:	00 
  a5ff41:	e8 aa a1 ff ff       	call   a5a0f0 <<gpui::runtime::scroll::ViewportColumn>::info>
  a5ff46:	48 83 7c 24 20 02    	cmpq   $0x2,0x20(%rsp)
  a5ff4c:	0f 95 c0             	setne  %al
  a5ff4f:	74 48                	je     a5ff99 <gpui::native::accessibility::projected_node+0x659>
  a5ff51:	f2 0f 10 44 24 28    	movsd  0x28(%rsp),%xmm0
  a5ff57:	f2 44 0f 10 44 24 30 	movsd  0x30(%rsp),%xmm8
  a5ff5e:	f2 0f 10 74 24 38    	movsd  0x38(%rsp),%xmm6
  a5ff64:	f2 0f 10 64 24 40    	movsd  0x40(%rsp),%xmm4
  a5ff6a:	f2 0f 10 7c 24 48    	movsd  0x48(%rsp),%xmm7
  a5ff70:	f2 0f 10 6c 24 50    	movsd  0x50(%rsp),%xmm5
  a5ff76:	0f b6 6c 24 68       	movzbl 0x68(%rsp),%ebp
  a5ff7b:	f3 0f 10 4b 30       	movss  0x30(%rbx),%xmm1
  a5ff80:	0f 2e c9             	ucomiss %xmm1,%xmm1
  a5ff83:	7b 22                	jnp    a5ffa7 <gpui::native::accessibility::projected_node+0x667>
  a5ff85:	e9 58 02 00 00       	jmp    a601e2 <gpui::native::accessibility::projected_node+0x8a2>
  a5ff8a:	80 8c 24 f9 00 00 00 	orb    $0x8,0xf9(%rsp)
  a5ff91:	08 
  a5ff92:	4d 85 ed             	test   %r13,%r13
  a5ff95:	75 91                	jne    a5ff28 <gpui::native::accessibility::projected_node+0x5e8>
  a5ff97:	31 c0                	xor    %eax,%eax
  a5ff99:	f3 0f 10 4b 30       	movss  0x30(%rbx),%xmm1
  a5ff9e:	0f 2e c9             	ucomiss %xmm1,%xmm1
  a5ffa1:	0f 8a 3b 02 00 00    	jp     a601e2 <gpui::native::accessibility::projected_node+0x8a2>
  a5ffa7:	0f 57 d2             	xorps  %xmm2,%xmm2
  a5ffaa:	0f 2e ca             	ucomiss %xmm2,%xmm1
  a5ffad:	75 06                	jne    a5ffb5 <gpui::native::accessibility::projected_node+0x675>
  a5ffaf:	0f 8b 2d 02 00 00    	jnp    a601e2 <gpui::native::accessibility::projected_node+0x8a2>
  a5ffb5:	f3 0f 10 5b 38       	movss  0x38(%rbx),%xmm3
  a5ffba:	0f 2e da             	ucomiss %xmm2,%xmm3
  a5ffbd:	0f 85 1f 02 00 00    	jne    a601e2 <gpui::native::accessibility::projected_node+0x8a2>
  a5ffc3:	0f 8a 19 02 00 00    	jp     a601e2 <gpui::native::accessibility::projected_node+0x8a2>
  a5ffc9:	f3 0f 10 5b 34       	movss  0x34(%rbx),%xmm3
  a5ffce:	0f 2e da             	ucomiss %xmm2,%xmm3
  a5ffd1:	0f 85 0b 02 00 00    	jne    a601e2 <gpui::native::accessibility::projected_node+0x8a2>
  a5ffd7:	0f 8a 05 02 00 00    	jp     a601e2 <gpui::native::accessibility::projected_node+0x8a2>
  a5ffdd:	f3 0f 10 5b 3c       	movss  0x3c(%rbx),%xmm3
  a5ffe2:	0f 2e da             	ucomiss %xmm2,%xmm3
  a5ffe5:	75 06                	jne    a5ffed <gpui::native::accessibility::projected_node+0x6ad>
  a5ffe7:	0f 8b f5 01 00 00    	jnp    a601e2 <gpui::native::accessibility::projected_node+0x8a2>
  a5ffed:	84 c0                	test   %al,%al
  a5ffef:	0f 84 ed 01 00 00    	je     a601e2 <gpui::native::accessibility::projected_node+0x8a2>
  a5fff5:	f3 0f 11 5c 24 18    	movss  %xmm3,0x18(%rsp)
  a5fffb:	f2 44 0f 11 04 24    	movsd  %xmm8,(%rsp)
  a60001:	f2 0f 11 7c 24 10    	movsd  %xmm7,0x10(%rsp)
  a60007:	0f 29 b4 24 10 01 00 	movaps %xmm6,0x110(%rsp)
  a6000e:	00 
  a6000f:	f2 0f 11 6c 24 08    	movsd  %xmm5,0x8(%rsp)
  a60015:	0f 29 a4 24 00 01 00 	movaps %xmm4,0x100(%rsp)
  a6001c:	00 
  a6001d:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  a60021:	f2 0f 11 8c 24 20 01 	movsd  %xmm1,0x120(%rsp)
  a60028:	00 00 
  a6002a:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a6002e:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a60035:	00 
  a60036:	be 24 00 00 00       	mov    $0x24,%esi
  a6003b:	ff 15 3f 12 ad 00    	call   *0xad123f(%rip)        # 1531280 <_DYNAMIC+0x16e0>
  a60041:	f3 0f 10 44 24 18    	movss  0x18(%rsp),%xmm0
  a60047:	0f 57 c9             	xorps  %xmm1,%xmm1
  a6004a:	f3 0f 5a c8          	cvtss2sd %xmm0,%xmm1
  a6004e:	f2 0f 10 04 24       	movsd  (%rsp),%xmm0
  a60053:	f2 0f 11 4c 24 18    	movsd  %xmm1,0x18(%rsp)
  a60059:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a6005d:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a60064:	00 
  a60065:	be 27 00 00 00       	mov    $0x27,%esi
  a6006a:	ff 15 10 12 ad 00    	call   *0xad1210(%rip)        # 1531280 <_DYNAMIC+0x16e0>
  a60070:	66 0f 28 9c 24 10 01 	movapd 0x110(%rsp),%xmm3
  a60077:	00 00 
  a60079:	f2 0f 10 8c 24 20 01 	movsd  0x120(%rsp),%xmm1
  a60080:	00 00 
  a60082:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
  a60086:	f2 0f 10 44 24 10    	movsd  0x10(%rsp),%xmm0
  a6008c:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a60090:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a60094:	f2 0f 11 44 24 10    	movsd  %xmm0,0x10(%rsp)
  a6009a:	f2 0f 5d c8          	minsd  %xmm0,%xmm1
  a6009e:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a600a2:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a600a7:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a600ab:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a600af:	66 0f 29 9c 24 10 01 	movapd %xmm3,0x110(%rsp)
  a600b6:	00 00 
  a600b8:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a600bc:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a600c0:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a600c7:	00 
  a600c8:	be 25 00 00 00       	mov    $0x25,%esi
  a600cd:	ff 15 ad 11 ad 00    	call   *0xad11ad(%rip)        # 1531280 <_DYNAMIC+0x16e0>
  a600d3:	66 0f 28 9c 24 10 01 	movapd 0x110(%rsp),%xmm3
  a600da:	00 00 
  a600dc:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a600e0:	f2 0f 5f 4c 24 10    	maxsd  0x10(%rsp),%xmm1
  a600e6:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a600ea:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a600ef:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a600f3:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a600f7:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a600fb:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a600ff:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a60106:	00 
  a60107:	be 26 00 00 00       	mov    $0x26,%esi
  a6010c:	ff 15 6e 11 ad 00    	call   *0xad116e(%rip)        # 1531280 <_DYNAMIC+0x16e0>
  a60112:	66 0f 28 9c 24 00 01 	movapd 0x100(%rsp),%xmm3
  a60119:	00 00 
  a6011b:	f2 0f 10 4c 24 18    	movsd  0x18(%rsp),%xmm1
  a60121:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
  a60125:	f2 0f 10 44 24 08    	movsd  0x8(%rsp),%xmm0
  a6012b:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a6012f:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a60133:	f2 0f 11 44 24 08    	movsd  %xmm0,0x8(%rsp)
  a60139:	f2 0f 5d c8          	minsd  %xmm0,%xmm1
  a6013d:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a60141:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a60146:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a6014a:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a6014e:	66 0f 29 9c 24 00 01 	movapd %xmm3,0x100(%rsp)
  a60155:	00 00 
  a60157:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a6015b:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a6015f:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a60166:	00 
  a60167:	be 28 00 00 00       	mov    $0x28,%esi
  a6016c:	ff 15 0e 11 ad 00    	call   *0xad110e(%rip)        # 1531280 <_DYNAMIC+0x16e0>
  a60172:	66 0f 28 9c 24 00 01 	movapd 0x100(%rsp),%xmm3
  a60179:	00 00 
  a6017b:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a6017f:	f2 0f 5f 4c 24 08    	maxsd  0x8(%rsp),%xmm1
  a60185:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a60189:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a6018e:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a60192:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a60196:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a6019a:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a6019e:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a601a5:	00 
  a601a6:	be 29 00 00 00       	mov    $0x29,%esi
  a601ab:	ff 15 cf 10 ad 00    	call   *0xad10cf(%rip)        # 1531280 <_DYNAMIC+0x16e0>
  a601b1:	40 f6 c5 01          	test   $0x1,%bpl
  a601b5:	b9 00 00 02 00       	mov    $0x20000,%ecx
  a601ba:	b8 00 30 02 00       	mov    $0x23000,%eax
  a601bf:	0f 44 c1             	cmove  %ecx,%eax
  a601c2:	0b 84 24 f0 00 00 00 	or     0xf0(%rsp),%eax
  a601c9:	89 84 24 f0 00 00 00 	mov    %eax,0xf0(%rsp)
  a601d0:	40 f6 c5 02          	test   $0x2,%bpl
  a601d4:	74 0c                	je     a601e2 <gpui::native::accessibility::projected_node+0x8a2>
  a601d6:	0d 00 48 00 00       	or     $0x4800,%eax
  a601db:	89 84 24 f0 00 00 00 	mov    %eax,0xf0(%rsp)
  a601e2:	0f b6 43 4c          	movzbl 0x4c(%rbx),%eax
  a601e6:	48 b9 01 02 04 08 10 	movabs $0x8040201008040201,%rcx
  a601ed:	20 40 80 
  a601f0:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  a601f5:	8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%ecx
  a601fc:	31 ff                	xor    %edi,%edi
  a601fe:	48 8d 15 57 ce 73 ff 	lea    -0x8c31a9(%rip),%rdx        # 19d05c <anon.e07b3fe1e30566ac186940ce1c463e28.14.llvm.1651238746562193456+0xa0>
  a60205:	48 89 fe             	mov    %rdi,%rsi
  a60208:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a6020f:	00 
  a60210:	0f b6 7c 34 30       	movzbl 0x30(%rsp,%rsi,1),%edi
  a60215:	40 84 c7             	test   %al,%dil
  a60218:	75 16                	jne    a60230 <gpui::native::accessibility::projected_node+0x8f0>
  a6021a:	48 ff c6             	inc    %rsi
  a6021d:	48 83 fe 08          	cmp    $0x8,%rsi
  a60221:	75 ed                	jne    a60210 <gpui::native::accessibility::projected_node+0x8d0>
  a60223:	eb 5f                	jmp    a60284 <gpui::native::accessibility::projected_node+0x944>
  a60225:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  a6022c:	00 00 00 00 
  a60230:	40 0f b6 ff          	movzbl %dil,%edi
  a60234:	f3 0f bc ff          	tzcnt  %edi,%edi
  a60238:	4c 63 04 ba          	movslq (%rdx,%rdi,4),%r8
  a6023c:	49 01 d0             	add    %rdx,%r8
  a6023f:	41 ff e0             	jmp    *%r8
  a60242:	48 8d 7e 01          	lea    0x1(%rsi),%rdi
  a60246:	48 83 fe 07          	cmp    $0x7,%rsi
  a6024a:	75 b9                	jne    a60205 <gpui::native::accessibility::projected_node+0x8c5>
  a6024c:	eb 36                	jmp    a60284 <gpui::native::accessibility::projected_node+0x944>
  a6024e:	bf 01 00 00 00       	mov    $0x1,%edi
  a60253:	eb 1b                	jmp    a60270 <gpui::native::accessibility::projected_node+0x930>
  a60255:	bf 0f 00 00 00       	mov    $0xf,%edi
  a6025a:	eb 14                	jmp    a60270 <gpui::native::accessibility::projected_node+0x930>
  a6025c:	bf 02 00 00 00       	mov    $0x2,%edi
  a60261:	eb 0d                	jmp    a60270 <gpui::native::accessibility::projected_node+0x930>
  a60263:	bf 14 00 00 00       	mov    $0x14,%edi
  a60268:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a6026f:	00 
  a60270:	0f ab f9             	bts    %edi,%ecx
  a60273:	89 8c 24 f0 00 00 00 	mov    %ecx,0xf0(%rsp)
  a6027a:	48 8d 7e 01          	lea    0x1(%rsi),%rdi
  a6027e:	48 83 fe 07          	cmp    $0x7,%rsi
  a60282:	75 81                	jne    a60205 <gpui::native::accessibility::projected_node+0x8c5>
  a60284:	0f 10 84 24 f0 00 00 	movups 0xf0(%rsp),%xmm0
  a6028b:	00 
  a6028c:	41 0f 11 47 70       	movups %xmm0,0x70(%r15)
  a60291:	0f 10 84 24 e0 00 00 	movups 0xe0(%rsp),%xmm0
  a60298:	00 
  a60299:	41 0f 11 47 60       	movups %xmm0,0x60(%r15)
  a6029e:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  a602a5:	00 
  a602a6:	41 0f 11 47 50       	movups %xmm0,0x50(%r15)
  a602ab:	0f 10 84 24 c0 00 00 	movups 0xc0(%rsp),%xmm0
  a602b2:	00 
  a602b3:	41 0f 11 47 40       	movups %xmm0,0x40(%r15)
  a602b8:	0f 10 84 24 80 00 00 	movups 0x80(%rsp),%xmm0
  a602bf:	00 
  a602c0:	0f 10 8c 24 90 00 00 	movups 0x90(%rsp),%xmm1
  a602c7:	00 
  a602c8:	0f 10 94 24 a0 00 00 	movups 0xa0(%rsp),%xmm2
  a602cf:	00 
  a602d0:	0f 10 9c 24 b0 00 00 	movups 0xb0(%rsp),%xmm3
  a602d7:	00 
  a602d8:	41 0f 11 5f 30       	movups %xmm3,0x30(%r15)
  a602dd:	41 0f 11 57 20       	movups %xmm2,0x20(%r15)
  a602e2:	41 0f 11 4f 10       	movups %xmm1,0x10(%r15)
  a602e7:	41 0f 11 07          	movups %xmm0,(%r15)
  a602eb:	4c 89 f8             	mov    %r15,%rax
  a602ee:	48 81 c4 58 01 00 00 	add    $0x158,%rsp
  a602f5:	5b                   	pop    %rbx
  a602f6:	41 5c                	pop    %r12
  a602f8:	41 5d                	pop    %r13
  a602fa:	41 5e                	pop    %r14
  a602fc:	41 5f                	pop    %r15
  a602fe:	5d                   	pop    %rbp
  a602ff:	c3                   	ret
  a60300:	bd 01 00 00 00       	mov    $0x1,%ebp
  a60305:	4c 89 74 24 28       	mov    %r14,0x28(%rsp)
  a6030a:	48 89 6c 24 30       	mov    %rbp,0x30(%rsp)
  a6030f:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  a60314:	c6 44 24 20 03       	movb   $0x3,0x20(%rsp)
  a60319:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a60320:	00 
  a60321:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a60326:	be 11 00 00 00       	mov    $0x11,%esi
  a6032b:	ff 15 2f 0f ad 00    	call   *0xad0f2f(%rip)        # 1531260 <_DYNAMIC+0x16c0>
  a60331:	e9 55 f8 ff ff       	jmp    a5fb8b <gpui::native::accessibility::projected_node+0x24b>
  a60336:	31 f6                	xor    %esi,%esi
  a60338:	48 89 f7             	mov    %rsi,%rdi
  a6033b:	49 89 d0             	mov    %rdx,%r8
  a6033e:	49 d1 e8             	shr    $1,%r8
  a60341:	4c 01 c6             	add    %r8,%rsi
  a60344:	49 89 f1             	mov    %rsi,%r9
  a60347:	49 c1 e1 04          	shl    $0x4,%r9
  a6034b:	4a 39 0c 08          	cmp    %rcx,(%rax,%r9,1)
  a6034f:	48 0f 47 f7          	cmova  %rdi,%rsi
  a60353:	4c 29 c2             	sub    %r8,%rdx
  a60356:	48 83 fa 01          	cmp    $0x1,%rdx
  a6035a:	77 dc                	ja     a60338 <gpui::native::accessibility::projected_node+0x9f8>
  a6035c:	48 c1 e6 04          	shl    $0x4,%rsi
  a60360:	48 39 0c 30          	cmp    %rcx,(%rax,%rsi,1)
  a60364:	0f 85 01 f7 ff ff    	jne    a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a6036a:	48 01 f0             	add    %rsi,%rax
  a6036d:	48 83 78 08 00       	cmpq   $0x0,0x8(%rax)
  a60372:	40 0f 95 c5          	setne  %bpl
  a60376:	40 c0 e5 06          	shl    $0x6,%bpl
  a6037a:	40 80 cd 0e          	or     $0xe,%bpl
  a6037e:	e9 e8 f6 ff ff       	jmp    a5fa6b <gpui::native::accessibility::projected_node+0x12b>
  a60383:	48 8d 15 ce 14 a6 00 	lea    0xa614ce(%rip),%rdx        # 14c1858 <anon.665e0254f8caec42473a4dbe2629ae24.5.llvm.10658688341545287207>
  a6038a:	ff 15 c0 fa ac 00    	call   *0xacfac0(%rip)        # 152fe50 <_DYNAMIC+0x2b0>
  a60390:	48 89 c3             	mov    %rax,%rbx
  a60393:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  a6039a:	00 
  a6039b:	e8 10 c4 ff ff       	call   a5c7b0 <core::ptr::drop_glue::<accesskit::Node>>
  a603a0:	48 89 df             	mov    %rbx,%rdi
  a603a3:	e8 c8 a2 a5 00       	call   14ba670 <_Unwind_Resume@plt>
  a603a8:	ff 15 7a fa ac 00    	call   *0xacfa7a(%rip)        # 152fe28 <_DYNAMIC+0x288>
