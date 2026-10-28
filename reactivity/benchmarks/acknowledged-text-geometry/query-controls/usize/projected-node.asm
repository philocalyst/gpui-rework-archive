
/tmp/gpui-ack-query-comparison/usize/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a68a90 <gpui::native::accessibility::projected_node>:
  a68a90:	55                   	push   %rbp
  a68a91:	41 57                	push   %r15
  a68a93:	41 56                	push   %r14
  a68a95:	41 55                	push   %r13
  a68a97:	41 54                	push   %r12
  a68a99:	53                   	push   %rbx
  a68a9a:	48 81 ec 68 01 00 00 	sub    $0x168,%rsp
  a68aa1:	49 89 d6             	mov    %rdx,%r14
  a68aa4:	49 89 f5             	mov    %rsi,%r13
  a68aa7:	48 8b 76 38          	mov    0x38(%rsi),%rsi
  a68aab:	48 39 f2             	cmp    %rsi,%rdx
  a68aae:	0f 83 67 0a 00 00    	jae    a6951b <gpui::native::accessibility::projected_node+0xa8b>
  a68ab4:	49 89 ff             	mov    %rdi,%r15
  a68ab7:	49 8b 55 30          	mov    0x30(%r13),%rdx
  a68abb:	4b 8d 04 b6          	lea    (%r14,%r14,4),%rax
  a68abf:	48 c1 e0 04          	shl    $0x4,%rax
  a68ac3:	4c 8d 24 02          	lea    (%rdx,%rax,1),%r12
  a68ac7:	0f b6 7c 02 4d       	movzbl 0x4d(%rdx,%rax,1),%edi
  a68acc:	48 8d 05 e1 75 73 ff 	lea    -0x8c8a1f(%rip),%rax        # 1a00b4 <anon.2d11e2141b093c27f090b0b9ce5baeda.1.llvm.16487183139640134713+0x4c0>
  a68ad3:	48 63 0c b8          	movslq (%rax,%rdi,4),%rcx
  a68ad7:	48 01 c1             	add    %rax,%rcx
  a68ada:	48 bb 57 57 57 57 57 	movabs $0x5757575757575757,%rbx
  a68ae1:	57 57 57 
  a68ae4:	48 89 b4 24 10 01 00 	mov    %rsi,0x110(%rsp)
  a68aeb:	00 
  a68aec:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
  a68af1:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  a68af6:	4c 89 b4 24 20 01 00 	mov    %r14,0x120(%rsp)
  a68afd:	00 
  a68afe:	ff e1                	jmp    *%rcx
  a68b00:	40 b5 12             	mov    $0x12,%bpl
  a68b03:	41 f6 44 24 4c 01    	testb  $0x1,0x4c(%r12)
  a68b09:	0f 85 ad 00 00 00    	jne    a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a68b0f:	4c 89 ef             	mov    %r13,%rdi
  a68b12:	4c 89 f6             	mov    %r14,%rsi
  a68b15:	ff 15 6d 82 ac 00    	call   *0xac826d(%rip)        # 1530d88 <_DYNAMIC+0x1668>
  a68b1b:	40 b5 4e             	mov    $0x4e,%bpl
  a68b1e:	48 85 c0             	test   %rax,%rax
  a68b21:	0f 85 95 00 00 00    	jne    a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a68b27:	49 8b 45 60          	mov    0x60(%r13),%rax
  a68b2b:	40 b5 0e             	mov    $0xe,%bpl
  a68b2e:	48 85 c0             	test   %rax,%rax
  a68b31:	0f 84 85 00 00 00    	je     a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a68b37:	48 8b 50 40          	mov    0x40(%rax),%rdx
  a68b3b:	48 85 d2             	test   %rdx,%rdx
  a68b3e:	74 7c                	je     a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a68b40:	49 8b 4c 24 20       	mov    0x20(%r12),%rcx
  a68b45:	48 8b 40 38          	mov    0x38(%rax),%rax
  a68b49:	48 83 fa 01          	cmp    $0x1,%rdx
  a68b4d:	0f 85 71 09 00 00    	jne    a694c4 <gpui::native::accessibility::projected_node+0xa34>
  a68b53:	48 39 08             	cmp    %rcx,(%rax)
  a68b56:	75 64                	jne    a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a68b58:	e9 9e 09 00 00       	jmp    a694fb <gpui::native::accessibility::projected_node+0xa6b>
  a68b5d:	40 b5 18             	mov    $0x18,%bpl
  a68b60:	eb 5a                	jmp    a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a68b62:	40 b5 11             	mov    $0x11,%bpl
  a68b65:	eb 55                	jmp    a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a68b67:	40 b5 12             	mov    $0x12,%bpl
  a68b6a:	eb 50                	jmp    a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a68b6c:	40 b5 6c             	mov    $0x6c,%bpl
  a68b6f:	eb 4b                	jmp    a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a68b71:	4c 89 ef             	mov    %r13,%rdi
  a68b74:	4c 89 f6             	mov    %r14,%rsi
  a68b77:	ff 15 0b 82 ac 00    	call   *0xac820b(%rip)        # 1530d88 <_DYNAMIC+0x1668>
  a68b7d:	49 8b 74 24 28       	mov    0x28(%r12),%rsi
  a68b82:	40 b5 4e             	mov    $0x4e,%bpl
  a68b85:	48 85 f6             	test   %rsi,%rsi
  a68b88:	0f 84 cb 02 00 00    	je     a68e59 <gpui::native::accessibility::projected_node+0x3c9>
  a68b8e:	48 85 c0             	test   %rax,%rax
  a68b91:	74 29                	je     a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a68b93:	48 8b 0e             	mov    (%rsi),%rcx
  a68b96:	48 d1 e9             	shr    $1,%rcx
  a68b99:	48 39 ca             	cmp    %rcx,%rdx
  a68b9c:	75 1e                	jne    a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a68b9e:	48 83 c6 10          	add    $0x10,%rsi
  a68ba2:	48 89 c7             	mov    %rax,%rdi
  a68ba5:	ff 15 9d 6f ac 00    	call   *0xac6f9d(%rip)        # 152fb48 <bcmp@GLIBC_2.2.5>
  a68bab:	85 c0                	test   %eax,%eax
  a68bad:	75 0d                	jne    a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a68baf:	e9 ae 02 00 00       	jmp    a68e62 <gpui::native::accessibility::projected_node+0x3d2>
  a68bb4:	40 b5 07             	mov    $0x7,%bpl
  a68bb7:	eb 03                	jmp    a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a68bb9:	40 b5 04             	mov    $0x4,%bpl
  a68bbc:	40 88 ac 24 0c 01 00 	mov    %bpl,0x10c(%rsp)
  a68bc3:	00 
  a68bc4:	48 c7 84 24 00 01 00 	movq   $0x0,0x100(%rsp)
  a68bcb:	00 00 00 00 00 
  a68bd0:	c7 84 24 08 01 00 00 	movl   $0x0,0x108(%rsp)
  a68bd7:	00 00 00 00 
  a68bdb:	48 c7 84 24 90 00 00 	movq   $0x0,0x90(%rsp)
  a68be2:	00 00 00 00 00 
  a68be7:	48 c7 84 24 98 00 00 	movq   $0x8,0x98(%rsp)
  a68bee:	00 08 00 00 00 
  a68bf3:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
  a68bfa:	00 00 00 00 00 
  a68bff:	66 0f 28 05 f9 44 72 	movapd -0x8dbb07(%rip),%xmm0        # 18d100 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a68c06:	ff 
  a68c07:	66 0f 11 84 24 a8 00 	movupd %xmm0,0xa8(%rsp)
  a68c0e:	00 00 
  a68c10:	66 0f 11 84 24 b8 00 	movupd %xmm0,0xb8(%rsp)
  a68c17:	00 00 
  a68c19:	66 0f 11 84 24 c8 00 	movupd %xmm0,0xc8(%rsp)
  a68c20:	00 00 
  a68c22:	66 0f 11 84 24 d8 00 	movupd %xmm0,0xd8(%rsp)
  a68c29:	00 00 
  a68c2b:	66 0f 11 84 24 e8 00 	movupd %xmm0,0xe8(%rsp)
  a68c32:	00 00 
  a68c34:	48 89 9c 24 f7 00 00 	mov    %rbx,0xf7(%rsp)
  a68c3b:	00 
  a68c3c:	4c 89 ef             	mov    %r13,%rdi
  a68c3f:	4c 89 f6             	mov    %r14,%rsi
  a68c42:	ff 15 40 81 ac 00    	call   *0xac8140(%rip)        # 1530d88 <_DYNAMIC+0x1668>
  a68c48:	48 85 c0             	test   %rax,%rax
  a68c4b:	0f 84 8c 00 00 00    	je     a68cdd <gpui::native::accessibility::projected_node+0x24d>
  a68c51:	49 89 d6             	mov    %rdx,%r14
  a68c54:	48 85 d2             	test   %rdx,%rdx
  a68c57:	79 11                	jns    a68c6a <gpui::native::accessibility::projected_node+0x1da>
  a68c59:	45 31 ff             	xor    %r15d,%r15d
  a68c5c:	4c 89 ff             	mov    %r15,%rdi
  a68c5f:	4c 89 f6             	mov    %r14,%rsi
  a68c62:	ff 15 f0 6d ac 00    	call   *0xac6df0(%rip)        # 152fa58 <_DYNAMIC+0x338>
  a68c68:	0f 0b                	ud2
  a68c6a:	74 40                	je     a68cac <gpui::native::accessibility::projected_node+0x21c>
  a68c6c:	4c 89 7c 24 08       	mov    %r15,0x8(%rsp)
  a68c71:	48 89 c5             	mov    %rax,%rbp
  a68c74:	ff 15 e6 6c ac 00    	call   *0xac6ce6(%rip)        # 152f960 <_DYNAMIC+0x240>
  a68c7a:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  a68c80:	be 01 00 00 00       	mov    $0x1,%esi
  a68c85:	4c 89 f7             	mov    %r14,%rdi
  a68c88:	ff 15 da 6c ac 00    	call   *0xac6cda(%rip)        # 152f968 <_DYNAMIC+0x248>
  a68c8e:	48 85 c0             	test   %rax,%rax
  a68c91:	74 c9                	je     a68c5c <gpui::native::accessibility::projected_node+0x1cc>
  a68c93:	48 89 c3             	mov    %rax,%rbx
  a68c96:	48 89 c7             	mov    %rax,%rdi
  a68c99:	48 89 ee             	mov    %rbp,%rsi
  a68c9c:	4c 89 f2             	mov    %r14,%rdx
  a68c9f:	ff 15 db 6c ac 00    	call   *0xac6cdb(%rip)        # 152f980 <memcpy@GLIBC_2.14>
  a68ca5:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  a68caa:	eb 05                	jmp    a68cb1 <gpui::native::accessibility::projected_node+0x221>
  a68cac:	bb 01 00 00 00       	mov    $0x1,%ebx
  a68cb1:	4c 89 74 24 28       	mov    %r14,0x28(%rsp)
  a68cb6:	48 89 5c 24 30       	mov    %rbx,0x30(%rsp)
  a68cbb:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  a68cc0:	c6 44 24 20 03       	movb   $0x3,0x20(%rsp)
  a68cc5:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  a68ccc:	00 
  a68ccd:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a68cd2:	be 0f 00 00 00       	mov    $0xf,%esi
  a68cd7:	ff 15 b3 80 ac 00    	call   *0xac80b3(%rip)        # 1530d90 <_DYNAMIC+0x1670>
  a68cdd:	41 80 7c 24 4d 02    	cmpb   $0x2,0x4d(%r12)
  a68ce3:	0f 85 89 00 00 00    	jne    a68d72 <gpui::native::accessibility::projected_node+0x2e2>
  a68ce9:	49 8b 6c 24 28       	mov    0x28(%r12),%rbp
  a68cee:	48 85 ed             	test   %rbp,%rbp
  a68cf1:	74 7f                	je     a68d72 <gpui::native::accessibility::projected_node+0x2e2>
  a68cf3:	4c 8b 75 00          	mov    0x0(%rbp),%r14
  a68cf7:	49 d1 ee             	shr    $1,%r14
  a68cfa:	74 45                	je     a68d41 <gpui::native::accessibility::projected_node+0x2b1>
  a68cfc:	4c 89 7c 24 08       	mov    %r15,0x8(%rsp)
  a68d01:	ff 15 59 6c ac 00    	call   *0xac6c59(%rip)        # 152f960 <_DYNAMIC+0x240>
  a68d07:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  a68d0d:	be 01 00 00 00       	mov    $0x1,%esi
  a68d12:	4c 89 f7             	mov    %r14,%rdi
  a68d15:	ff 15 4d 6c ac 00    	call   *0xac6c4d(%rip)        # 152f968 <_DYNAMIC+0x248>
  a68d1b:	48 85 c0             	test   %rax,%rax
  a68d1e:	0f 84 38 ff ff ff    	je     a68c5c <gpui::native::accessibility::projected_node+0x1cc>
  a68d24:	48 89 c3             	mov    %rax,%rbx
  a68d27:	48 83 c5 10          	add    $0x10,%rbp
  a68d2b:	48 89 c7             	mov    %rax,%rdi
  a68d2e:	48 89 ee             	mov    %rbp,%rsi
  a68d31:	4c 89 f2             	mov    %r14,%rdx
  a68d34:	ff 15 46 6c ac 00    	call   *0xac6c46(%rip)        # 152f980 <memcpy@GLIBC_2.14>
  a68d3a:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  a68d3f:	eb 05                	jmp    a68d46 <gpui::native::accessibility::projected_node+0x2b6>
  a68d41:	bb 01 00 00 00       	mov    $0x1,%ebx
  a68d46:	4c 89 74 24 28       	mov    %r14,0x28(%rsp)
  a68d4b:	48 89 5c 24 30       	mov    %rbx,0x30(%rsp)
  a68d50:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  a68d55:	c6 44 24 20 03       	movb   $0x3,0x20(%rsp)
  a68d5a:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  a68d61:	00 
  a68d62:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a68d67:	be 11 00 00 00       	mov    $0x11,%esi
  a68d6c:	ff 15 1e 80 ac 00    	call   *0xac801e(%rip)        # 1530d90 <_DYNAMIC+0x1670>
  a68d72:	49 8b 6d 60          	mov    0x60(%r13),%rbp
  a68d76:	48 85 ed             	test   %rbp,%rbp
  a68d79:	0f 84 5b 02 00 00    	je     a68fda <gpui::native::accessibility::projected_node+0x54a>
  a68d7f:	49 8b 54 24 20       	mov    0x20(%r12),%rdx
  a68d84:	48 8b 4d 40          	mov    0x40(%rbp),%rcx
  a68d88:	48 85 c9             	test   %rcx,%rcx
  a68d8b:	0f 84 1e 02 00 00    	je     a68faf <gpui::native::accessibility::projected_node+0x51f>
  a68d91:	48 8b 45 38          	mov    0x38(%rbp),%rax
  a68d95:	48 83 f9 01          	cmp    $0x1,%rcx
  a68d99:	75 17                	jne    a68db2 <gpui::native::accessibility::projected_node+0x322>
  a68d9b:	48 39 10             	cmp    %rdx,(%rax)
  a68d9e:	0f 85 0b 02 00 00    	jne    a68faf <gpui::native::accessibility::projected_node+0x51f>
  a68da4:	48 8b 58 08          	mov    0x8(%rax),%rbx
  a68da8:	48 85 db             	test   %rbx,%rbx
  a68dab:	75 55                	jne    a68e02 <gpui::native::accessibility::projected_node+0x372>
  a68dad:	e9 fd 01 00 00       	jmp    a68faf <gpui::native::accessibility::projected_node+0x51f>
  a68db2:	31 f6                	xor    %esi,%esi
  a68db4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a68dbb:	00 00 00 00 00 
  a68dc0:	48 89 f7             	mov    %rsi,%rdi
  a68dc3:	49 89 c8             	mov    %rcx,%r8
  a68dc6:	49 d1 e8             	shr    $1,%r8
  a68dc9:	4c 01 c6             	add    %r8,%rsi
  a68dcc:	49 89 f1             	mov    %rsi,%r9
  a68dcf:	49 c1 e1 04          	shl    $0x4,%r9
  a68dd3:	4a 39 14 08          	cmp    %rdx,(%rax,%r9,1)
  a68dd7:	48 0f 47 f7          	cmova  %rdi,%rsi
  a68ddb:	4c 29 c1             	sub    %r8,%rcx
  a68dde:	48 83 f9 01          	cmp    $0x1,%rcx
  a68de2:	77 dc                	ja     a68dc0 <gpui::native::accessibility::projected_node+0x330>
  a68de4:	48 c1 e6 04          	shl    $0x4,%rsi
  a68de8:	48 39 14 30          	cmp    %rdx,(%rax,%rsi,1)
  a68dec:	0f 85 bd 01 00 00    	jne    a68faf <gpui::native::accessibility::projected_node+0x51f>
  a68df2:	48 01 f0             	add    %rsi,%rax
  a68df5:	48 8b 58 08          	mov    0x8(%rax),%rbx
  a68df9:	48 85 db             	test   %rbx,%rbx
  a68dfc:	0f 84 ad 01 00 00    	je     a68faf <gpui::native::accessibility::projected_node+0x51f>
  a68e02:	4c 8b 33             	mov    (%rbx),%r14
  a68e05:	49 d1 ee             	shr    $1,%r14
  a68e08:	0f 84 6b 01 00 00    	je     a68f79 <gpui::native::accessibility::projected_node+0x4e9>
  a68e0e:	4c 89 7c 24 08       	mov    %r15,0x8(%rsp)
  a68e13:	ff 15 47 6b ac 00    	call   *0xac6b47(%rip)        # 152f960 <_DYNAMIC+0x240>
  a68e19:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  a68e1f:	be 01 00 00 00       	mov    $0x1,%esi
  a68e24:	4c 89 f7             	mov    %r14,%rdi
  a68e27:	ff 15 3b 6b ac 00    	call   *0xac6b3b(%rip)        # 152f968 <_DYNAMIC+0x248>
  a68e2d:	48 85 c0             	test   %rax,%rax
  a68e30:	0f 84 26 fe ff ff    	je     a68c5c <gpui::native::accessibility::projected_node+0x1cc>
  a68e36:	48 83 c3 10          	add    $0x10,%rbx
  a68e3a:	48 89 c7             	mov    %rax,%rdi
  a68e3d:	48 89 de             	mov    %rbx,%rsi
  a68e40:	4c 89 f2             	mov    %r14,%rdx
  a68e43:	48 89 c3             	mov    %rax,%rbx
  a68e46:	ff 15 34 6b ac 00    	call   *0xac6b34(%rip)        # 152f980 <memcpy@GLIBC_2.14>
  a68e4c:	48 89 d8             	mov    %rbx,%rax
  a68e4f:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  a68e54:	e9 25 01 00 00       	jmp    a68f7e <gpui::native::accessibility::projected_node+0x4ee>
  a68e59:	48 85 c0             	test   %rax,%rax
  a68e5c:	0f 85 5a fd ff ff    	jne    a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a68e62:	c6 84 24 0c 01 00 00 	movb   $0x3,0x10c(%rsp)
  a68e69:	03 
  a68e6a:	48 c7 84 24 00 01 00 	movq   $0x0,0x100(%rsp)
  a68e71:	00 00 00 00 00 
  a68e76:	c7 84 24 08 01 00 00 	movl   $0x0,0x108(%rsp)
  a68e7d:	00 00 00 00 
  a68e81:	48 c7 84 24 90 00 00 	movq   $0x0,0x90(%rsp)
  a68e88:	00 00 00 00 00 
  a68e8d:	48 c7 84 24 98 00 00 	movq   $0x8,0x98(%rsp)
  a68e94:	00 08 00 00 00 
  a68e99:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
  a68ea0:	00 00 00 00 00 
  a68ea5:	66 0f 28 05 53 42 72 	movapd -0x8dbdad(%rip),%xmm0        # 18d100 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a68eac:	ff 
  a68ead:	66 0f 11 84 24 a8 00 	movupd %xmm0,0xa8(%rsp)
  a68eb4:	00 00 
  a68eb6:	66 0f 11 84 24 b8 00 	movupd %xmm0,0xb8(%rsp)
  a68ebd:	00 00 
  a68ebf:	66 0f 11 84 24 c8 00 	movupd %xmm0,0xc8(%rsp)
  a68ec6:	00 00 
  a68ec8:	66 0f 11 84 24 d8 00 	movupd %xmm0,0xd8(%rsp)
  a68ecf:	00 00 
  a68ed1:	66 0f 11 84 24 e8 00 	movupd %xmm0,0xe8(%rsp)
  a68ed8:	00 00 
  a68eda:	48 89 9c 24 f7 00 00 	mov    %rbx,0xf7(%rsp)
  a68ee1:	00 
  a68ee2:	49 8b 6c 24 28       	mov    0x28(%r12),%rbp
  a68ee7:	48 85 ed             	test   %rbp,%rbp
  a68eea:	0f 84 ed fd ff ff    	je     a68cdd <gpui::native::accessibility::projected_node+0x24d>
  a68ef0:	4c 89 7c 24 08       	mov    %r15,0x8(%rsp)
  a68ef5:	4c 8b 75 00          	mov    0x0(%rbp),%r14
  a68ef9:	49 d1 ee             	shr    $1,%r14
  a68efc:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  a68f01:	b9 01 00 00 00       	mov    $0x1,%ecx
  a68f06:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  a68f0c:	4c 89 f6             	mov    %r14,%rsi
  a68f0f:	31 d2                	xor    %edx,%edx
  a68f11:	e8 ea 14 01 00       	call   a7a400 <<alloc::raw_vec::RawVecInner>::try_allocate_in>
  a68f16:	4c 8b 7c 24 28       	mov    0x28(%rsp),%r15
  a68f1b:	80 7c 24 20 00       	cmpb   $0x0,0x20(%rsp)
  a68f20:	0f 85 eb 05 00 00    	jne    a69511 <gpui::native::accessibility::projected_node+0xa81>
  a68f26:	48 8b 5c 24 30       	mov    0x30(%rsp),%rbx
  a68f2b:	4d 85 f6             	test   %r14,%r14
  a68f2e:	74 13                	je     a68f43 <gpui::native::accessibility::projected_node+0x4b3>
  a68f30:	48 83 c5 10          	add    $0x10,%rbp
  a68f34:	48 89 df             	mov    %rbx,%rdi
  a68f37:	48 89 ee             	mov    %rbp,%rsi
  a68f3a:	4c 89 f2             	mov    %r14,%rdx
  a68f3d:	ff 15 3d 6a ac 00    	call   *0xac6a3d(%rip)        # 152f980 <memcpy@GLIBC_2.14>
  a68f43:	4c 89 7c 24 28       	mov    %r15,0x28(%rsp)
  a68f48:	48 89 5c 24 30       	mov    %rbx,0x30(%rsp)
  a68f4d:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  a68f52:	c6 44 24 20 03       	movb   $0x3,0x20(%rsp)
  a68f57:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  a68f5e:	00 
  a68f5f:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a68f64:	be 11 00 00 00       	mov    $0x11,%esi
  a68f69:	ff 15 21 7e ac 00    	call   *0xac7e21(%rip)        # 1530d90 <_DYNAMIC+0x1670>
  a68f6f:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  a68f74:	e9 64 fd ff ff       	jmp    a68cdd <gpui::native::accessibility::projected_node+0x24d>
  a68f79:	b8 01 00 00 00       	mov    $0x1,%eax
  a68f7e:	4c 89 74 24 28       	mov    %r14,0x28(%rsp)
  a68f83:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  a68f88:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  a68f8d:	c6 44 24 20 03       	movb   $0x3,0x20(%rsp)
  a68f92:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  a68f99:	00 
  a68f9a:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a68f9f:	be 10 00 00 00       	mov    $0x10,%esi
  a68fa4:	ff 15 e6 7d ac 00    	call   *0xac7de6(%rip)        # 1530d90 <_DYNAMIC+0x1670>
  a68faa:	49 8b 54 24 20       	mov    0x20(%r12),%rdx
  a68faf:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  a68fb4:	48 89 ee             	mov    %rbp,%rsi
  a68fb7:	e8 04 11 ff ff       	call   a5a0c0 <<gpui::runtime::scroll::ViewportColumn>::list>
  a68fbc:	83 7c 24 20 01       	cmpl   $0x1,0x20(%rsp)
  a68fc1:	75 17                	jne    a68fda <gpui::native::accessibility::projected_node+0x54a>
  a68fc3:	8b 54 24 30          	mov    0x30(%rsp),%edx
  a68fc7:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  a68fce:	00 
  a68fcf:	be 38 00 00 00       	mov    $0x38,%esi
  a68fd4:	ff 15 36 7f ac 00    	call   *0xac7f36(%rip)        # 1530f10 <_DYNAMIC+0x17f0>
  a68fda:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  a68fdf:	4c 89 ee             	mov    %r13,%rsi
  a68fe2:	48 8b 94 24 20 01 00 	mov    0x120(%rsp),%rdx
  a68fe9:	00 
  a68fea:	ff 15 00 7e ac 00    	call   *0xac7e00(%rip)        # 1530df0 <_DYNAMIC+0x16d0>
  a68ff0:	48 83 7c 24 20 00    	cmpq   $0x0,0x20(%rsp)
  a68ff6:	74 17                	je     a6900f <gpui::native::accessibility::projected_node+0x57f>
  a68ff8:	8b 54 24 38          	mov    0x38(%rsp),%edx
  a68ffc:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  a69003:	00 
  a69004:	be 39 00 00 00       	mov    $0x39,%esi
  a69009:	ff 15 01 7f ac 00    	call   *0xac7f01(%rip)        # 1530f10 <_DYNAMIC+0x17f0>
  a6900f:	f3 41 0f 10 44 24 30 	movss  0x30(%r12),%xmm0
  a69016:	0f 2e c0             	ucomiss %xmm0,%xmm0
  a69019:	0f 8a 99 00 00 00    	jp     a690b8 <gpui::native::accessibility::projected_node+0x628>
  a6901f:	f3 41 0f 10 4c 24 34 	movss  0x34(%r12),%xmm1
  a69026:	0f 14 c1             	unpcklps %xmm1,%xmm0
  a69029:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  a6902c:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  a69031:	41 0f 5a 44 24 38    	cvtps2pd 0x38(%r12),%xmm0
  a69037:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  a6903c:	41 0f 5a 44 24 40    	cvtps2pd 0x40(%r12),%xmm0
  a69042:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  a69047:	c6 44 24 50 00       	movb   $0x0,0x50(%rsp)
  a6904c:	66 41 0f 10 04 24    	movupd (%r12),%xmm0
  a69052:	66 0f 29 84 24 50 01 	movapd %xmm0,0x150(%rsp)
  a69059:	00 00 
  a6905b:	48 8d bc 24 3c 01 00 	lea    0x13c(%rsp),%rdi
  a69062:	00 
  a69063:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  a69068:	48 8d 94 24 50 01 00 	lea    0x150(%rsp),%rdx
  a6906f:	00 
  a69070:	ff 15 32 6a ac 00    	call   *0xac6a32(%rip)        # 152faa8 <_DYNAMIC+0x388>
  a69076:	83 bc 24 3c 01 00 00 	cmpl   $0x1,0x13c(%rsp)
  a6907d:	01 
  a6907e:	75 38                	jne    a690b8 <gpui::native::accessibility::projected_node+0x628>
  a69080:	0f 5a 84 24 40 01 00 	cvtps2pd 0x140(%rsp),%xmm0
  a69087:	00 
  a69088:	0f 5a 8c 24 48 01 00 	cvtps2pd 0x148(%rsp),%xmm1
  a6908f:	00 
  a69090:	66 0f 58 c8          	addpd  %xmm0,%xmm1
  a69094:	66 0f 29 44 24 20    	movapd %xmm0,0x20(%rsp)
  a6909a:	66 0f 29 4c 24 30    	movapd %xmm1,0x30(%rsp)
  a690a0:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  a690a7:	00 
  a690a8:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  a690ad:	be 53 00 00 00       	mov    $0x53,%esi
  a690b2:	ff 15 e0 7c ac 00    	call   *0xac7ce0(%rip)        # 1530d98 <_DYNAMIC+0x1678>
  a690b8:	b8 4f 00 00 00       	mov    $0x4f,%eax
  a690bd:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  a690c2:	0f a3 c8             	bt     %ecx,%eax
  a690c5:	73 6a                	jae    a69131 <gpui::native::accessibility::projected_node+0x6a1>
  a690c7:	48 85 ed             	test   %rbp,%rbp
  a690ca:	74 72                	je     a6913e <gpui::native::accessibility::projected_node+0x6ae>
  a690cc:	49 8b 54 24 20       	mov    0x20(%r12),%rdx
  a690d1:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  a690d6:	48 89 ee             	mov    %rbp,%rsi
  a690d9:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  a690de:	4c 8b 84 24 10 01 00 	mov    0x110(%rsp),%r8
  a690e5:	00 
  a690e6:	e8 a5 0d ff ff       	call   a59e90 <<gpui::runtime::scroll::ViewportColumn>::info>
  a690eb:	48 83 7c 24 20 02    	cmpq   $0x2,0x20(%rsp)
  a690f1:	0f 95 c0             	setne  %al
  a690f4:	74 4a                	je     a69140 <gpui::native::accessibility::projected_node+0x6b0>
  a690f6:	f2 0f 10 44 24 28    	movsd  0x28(%rsp),%xmm0
  a690fc:	f2 44 0f 10 44 24 30 	movsd  0x30(%rsp),%xmm8
  a69103:	f2 0f 10 74 24 38    	movsd  0x38(%rsp),%xmm6
  a69109:	f2 0f 10 64 24 40    	movsd  0x40(%rsp),%xmm4
  a6910f:	f2 0f 10 7c 24 48    	movsd  0x48(%rsp),%xmm7
  a69115:	f2 0f 10 6c 24 50    	movsd  0x50(%rsp),%xmm5
  a6911b:	0f b6 5c 24 68       	movzbl 0x68(%rsp),%ebx
  a69120:	f3 41 0f 10 4c 24 30 	movss  0x30(%r12),%xmm1
  a69127:	0f 2e c9             	ucomiss %xmm1,%xmm1
  a6912a:	7b 24                	jnp    a69150 <gpui::native::accessibility::projected_node+0x6c0>
  a6912c:	e9 6c 02 00 00       	jmp    a6939d <gpui::native::accessibility::projected_node+0x90d>
  a69131:	80 8c 24 09 01 00 00 	orb    $0x8,0x109(%rsp)
  a69138:	08 
  a69139:	48 85 ed             	test   %rbp,%rbp
  a6913c:	75 8e                	jne    a690cc <gpui::native::accessibility::projected_node+0x63c>
  a6913e:	31 c0                	xor    %eax,%eax
  a69140:	f3 41 0f 10 4c 24 30 	movss  0x30(%r12),%xmm1
  a69147:	0f 2e c9             	ucomiss %xmm1,%xmm1
  a6914a:	0f 8a 4d 02 00 00    	jp     a6939d <gpui::native::accessibility::projected_node+0x90d>
  a69150:	0f 57 d2             	xorps  %xmm2,%xmm2
  a69153:	0f 2e ca             	ucomiss %xmm2,%xmm1
  a69156:	75 06                	jne    a6915e <gpui::native::accessibility::projected_node+0x6ce>
  a69158:	0f 8b 3f 02 00 00    	jnp    a6939d <gpui::native::accessibility::projected_node+0x90d>
  a6915e:	f3 41 0f 10 5c 24 38 	movss  0x38(%r12),%xmm3
  a69165:	0f 2e da             	ucomiss %xmm2,%xmm3
  a69168:	0f 85 2f 02 00 00    	jne    a6939d <gpui::native::accessibility::projected_node+0x90d>
  a6916e:	0f 8a 29 02 00 00    	jp     a6939d <gpui::native::accessibility::projected_node+0x90d>
  a69174:	f3 41 0f 10 5c 24 34 	movss  0x34(%r12),%xmm3
  a6917b:	0f 2e da             	ucomiss %xmm2,%xmm3
  a6917e:	0f 85 19 02 00 00    	jne    a6939d <gpui::native::accessibility::projected_node+0x90d>
  a69184:	0f 8a 13 02 00 00    	jp     a6939d <gpui::native::accessibility::projected_node+0x90d>
  a6918a:	f3 41 0f 10 5c 24 3c 	movss  0x3c(%r12),%xmm3
  a69191:	0f 2e da             	ucomiss %xmm2,%xmm3
  a69194:	75 06                	jne    a6919c <gpui::native::accessibility::projected_node+0x70c>
  a69196:	0f 8b 01 02 00 00    	jnp    a6939d <gpui::native::accessibility::projected_node+0x90d>
  a6919c:	84 c0                	test   %al,%al
  a6919e:	0f 84 f9 01 00 00    	je     a6939d <gpui::native::accessibility::projected_node+0x90d>
  a691a4:	f3 0f 11 9c 24 88 00 	movss  %xmm3,0x88(%rsp)
  a691ab:	00 00 
  a691ad:	f2 44 0f 11 44 24 08 	movsd  %xmm8,0x8(%rsp)
  a691b4:	f2 0f 11 7c 24 18    	movsd  %xmm7,0x18(%rsp)
  a691ba:	0f 29 b4 24 20 01 00 	movaps %xmm6,0x120(%rsp)
  a691c1:	00 
  a691c2:	f2 0f 11 6c 24 10    	movsd  %xmm5,0x10(%rsp)
  a691c8:	0f 29 a4 24 10 01 00 	movaps %xmm4,0x110(%rsp)
  a691cf:	00 
  a691d0:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  a691d4:	f2 0f 11 8c 24 30 01 	movsd  %xmm1,0x130(%rsp)
  a691db:	00 00 
  a691dd:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a691e1:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  a691e8:	00 
  a691e9:	be 24 00 00 00       	mov    $0x24,%esi
  a691ee:	ff 15 24 7d ac 00    	call   *0xac7d24(%rip)        # 1530f18 <_DYNAMIC+0x17f8>
  a691f4:	f3 0f 10 84 24 88 00 	movss  0x88(%rsp),%xmm0
  a691fb:	00 00 
  a691fd:	0f 57 c9             	xorps  %xmm1,%xmm1
  a69200:	f3 0f 5a c8          	cvtss2sd %xmm0,%xmm1
  a69204:	f2 0f 10 44 24 08    	movsd  0x8(%rsp),%xmm0
  a6920a:	f2 0f 11 8c 24 88 00 	movsd  %xmm1,0x88(%rsp)
  a69211:	00 00 
  a69213:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a69217:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  a6921e:	00 
  a6921f:	be 27 00 00 00       	mov    $0x27,%esi
  a69224:	ff 15 ee 7c ac 00    	call   *0xac7cee(%rip)        # 1530f18 <_DYNAMIC+0x17f8>
  a6922a:	66 0f 28 9c 24 20 01 	movapd 0x120(%rsp),%xmm3
  a69231:	00 00 
  a69233:	f2 0f 10 8c 24 30 01 	movsd  0x130(%rsp),%xmm1
  a6923a:	00 00 
  a6923c:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
  a69240:	f2 0f 10 44 24 18    	movsd  0x18(%rsp),%xmm0
  a69246:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a6924a:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a6924e:	f2 0f 11 44 24 18    	movsd  %xmm0,0x18(%rsp)
  a69254:	f2 0f 5d c8          	minsd  %xmm0,%xmm1
  a69258:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a6925c:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a69261:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a69265:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a69269:	66 0f 29 9c 24 20 01 	movapd %xmm3,0x120(%rsp)
  a69270:	00 00 
  a69272:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a69276:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a6927a:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  a69281:	00 
  a69282:	be 25 00 00 00       	mov    $0x25,%esi
  a69287:	ff 15 8b 7c ac 00    	call   *0xac7c8b(%rip)        # 1530f18 <_DYNAMIC+0x17f8>
  a6928d:	66 0f 28 9c 24 20 01 	movapd 0x120(%rsp),%xmm3
  a69294:	00 00 
  a69296:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a6929a:	f2 0f 5f 4c 24 18    	maxsd  0x18(%rsp),%xmm1
  a692a0:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a692a4:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a692a9:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a692ad:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a692b1:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a692b5:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a692b9:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  a692c0:	00 
  a692c1:	be 26 00 00 00       	mov    $0x26,%esi
  a692c6:	ff 15 4c 7c ac 00    	call   *0xac7c4c(%rip)        # 1530f18 <_DYNAMIC+0x17f8>
  a692cc:	66 0f 28 9c 24 10 01 	movapd 0x110(%rsp),%xmm3
  a692d3:	00 00 
  a692d5:	f2 0f 10 8c 24 88 00 	movsd  0x88(%rsp),%xmm1
  a692dc:	00 00 
  a692de:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
  a692e2:	f2 0f 10 44 24 10    	movsd  0x10(%rsp),%xmm0
  a692e8:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a692ec:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a692f0:	f2 0f 11 44 24 10    	movsd  %xmm0,0x10(%rsp)
  a692f6:	f2 0f 5d c8          	minsd  %xmm0,%xmm1
  a692fa:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a692fe:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a69303:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a69307:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a6930b:	66 0f 29 9c 24 10 01 	movapd %xmm3,0x110(%rsp)
  a69312:	00 00 
  a69314:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a69318:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a6931c:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  a69323:	00 
  a69324:	be 28 00 00 00       	mov    $0x28,%esi
  a69329:	ff 15 e9 7b ac 00    	call   *0xac7be9(%rip)        # 1530f18 <_DYNAMIC+0x17f8>
  a6932f:	66 0f 28 9c 24 10 01 	movapd 0x110(%rsp),%xmm3
  a69336:	00 00 
  a69338:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a6933c:	f2 0f 5f 4c 24 10    	maxsd  0x10(%rsp),%xmm1
  a69342:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a69346:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a6934b:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a6934f:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a69353:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a69357:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a6935b:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  a69362:	00 
  a69363:	be 29 00 00 00       	mov    $0x29,%esi
  a69368:	ff 15 aa 7b ac 00    	call   *0xac7baa(%rip)        # 1530f18 <_DYNAMIC+0x17f8>
  a6936e:	f6 c3 01             	test   $0x1,%bl
  a69371:	b9 00 00 02 00       	mov    $0x20000,%ecx
  a69376:	b8 00 30 02 00       	mov    $0x23000,%eax
  a6937b:	0f 44 c1             	cmove  %ecx,%eax
  a6937e:	0b 84 24 00 01 00 00 	or     0x100(%rsp),%eax
  a69385:	89 84 24 00 01 00 00 	mov    %eax,0x100(%rsp)
  a6938c:	f6 c3 02             	test   $0x2,%bl
  a6938f:	74 0c                	je     a6939d <gpui::native::accessibility::projected_node+0x90d>
  a69391:	0d 00 48 00 00       	or     $0x4800,%eax
  a69396:	89 84 24 00 01 00 00 	mov    %eax,0x100(%rsp)
  a6939d:	41 0f b6 44 24 4c    	movzbl 0x4c(%r12),%eax
  a693a3:	48 b9 01 02 04 08 10 	movabs $0x8040201008040201,%rcx
  a693aa:	20 40 80 
  a693ad:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  a693b2:	8b 8c 24 00 01 00 00 	mov    0x100(%rsp),%ecx
  a693b9:	31 ff                	xor    %edi,%edi
  a693bb:	48 8d 15 12 6d 73 ff 	lea    -0x8c92ee(%rip),%rdx        # 1a00d4 <anon.2d11e2141b093c27f090b0b9ce5baeda.1.llvm.16487183139640134713+0x4e0>
  a693c2:	48 89 fe             	mov    %rdi,%rsi
  a693c5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  a693cc:	00 00 00 00 
  a693d0:	0f b6 7c 34 30       	movzbl 0x30(%rsp,%rsi,1),%edi
  a693d5:	40 84 c7             	test   %al,%dil
  a693d8:	75 16                	jne    a693f0 <gpui::native::accessibility::projected_node+0x960>
  a693da:	48 ff c6             	inc    %rsi
  a693dd:	48 83 fe 08          	cmp    $0x8,%rsi
  a693e1:	75 ed                	jne    a693d0 <gpui::native::accessibility::projected_node+0x940>
  a693e3:	eb 63                	jmp    a69448 <gpui::native::accessibility::projected_node+0x9b8>
  a693e5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  a693ec:	00 00 00 00 
  a693f0:	40 0f b6 ff          	movzbl %dil,%edi
  a693f4:	f3 0f bc ff          	tzcnt  %edi,%edi
  a693f8:	4c 63 04 ba          	movslq (%rdx,%rdi,4),%r8
  a693fc:	49 01 d0             	add    %rdx,%r8
  a693ff:	41 ff e0             	jmp    *%r8
  a69402:	48 8d 7e 01          	lea    0x1(%rsi),%rdi
  a69406:	48 83 fe 07          	cmp    $0x7,%rsi
  a6940a:	75 b6                	jne    a693c2 <gpui::native::accessibility::projected_node+0x932>
  a6940c:	eb 3a                	jmp    a69448 <gpui::native::accessibility::projected_node+0x9b8>
  a6940e:	bf 01 00 00 00       	mov    $0x1,%edi
  a69413:	eb 1b                	jmp    a69430 <gpui::native::accessibility::projected_node+0x9a0>
  a69415:	bf 0f 00 00 00       	mov    $0xf,%edi
  a6941a:	eb 14                	jmp    a69430 <gpui::native::accessibility::projected_node+0x9a0>
  a6941c:	bf 02 00 00 00       	mov    $0x2,%edi
  a69421:	eb 0d                	jmp    a69430 <gpui::native::accessibility::projected_node+0x9a0>
  a69423:	bf 14 00 00 00       	mov    $0x14,%edi
  a69428:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a6942f:	00 
  a69430:	0f ab f9             	bts    %edi,%ecx
  a69433:	89 8c 24 00 01 00 00 	mov    %ecx,0x100(%rsp)
  a6943a:	48 8d 7e 01          	lea    0x1(%rsi),%rdi
  a6943e:	48 83 fe 07          	cmp    $0x7,%rsi
  a69442:	0f 85 7a ff ff ff    	jne    a693c2 <gpui::native::accessibility::projected_node+0x932>
  a69448:	0f 10 84 24 00 01 00 	movups 0x100(%rsp),%xmm0
  a6944f:	00 
  a69450:	41 0f 11 47 70       	movups %xmm0,0x70(%r15)
  a69455:	0f 10 84 24 f0 00 00 	movups 0xf0(%rsp),%xmm0
  a6945c:	00 
  a6945d:	41 0f 11 47 60       	movups %xmm0,0x60(%r15)
  a69462:	0f 10 84 24 e0 00 00 	movups 0xe0(%rsp),%xmm0
  a69469:	00 
  a6946a:	41 0f 11 47 50       	movups %xmm0,0x50(%r15)
  a6946f:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  a69476:	00 
  a69477:	41 0f 11 47 40       	movups %xmm0,0x40(%r15)
  a6947c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  a69483:	00 
  a69484:	0f 10 8c 24 a0 00 00 	movups 0xa0(%rsp),%xmm1
  a6948b:	00 
  a6948c:	0f 10 94 24 b0 00 00 	movups 0xb0(%rsp),%xmm2
  a69493:	00 
  a69494:	0f 10 9c 24 c0 00 00 	movups 0xc0(%rsp),%xmm3
  a6949b:	00 
  a6949c:	41 0f 11 5f 30       	movups %xmm3,0x30(%r15)
  a694a1:	41 0f 11 57 20       	movups %xmm2,0x20(%r15)
  a694a6:	41 0f 11 4f 10       	movups %xmm1,0x10(%r15)
  a694ab:	41 0f 11 07          	movups %xmm0,(%r15)
  a694af:	4c 89 f8             	mov    %r15,%rax
  a694b2:	48 81 c4 68 01 00 00 	add    $0x168,%rsp
  a694b9:	5b                   	pop    %rbx
  a694ba:	41 5c                	pop    %r12
  a694bc:	41 5d                	pop    %r13
  a694be:	41 5e                	pop    %r14
  a694c0:	41 5f                	pop    %r15
  a694c2:	5d                   	pop    %rbp
  a694c3:	c3                   	ret
  a694c4:	31 f6                	xor    %esi,%esi
  a694c6:	48 89 f7             	mov    %rsi,%rdi
  a694c9:	49 89 d0             	mov    %rdx,%r8
  a694cc:	49 d1 e8             	shr    $1,%r8
  a694cf:	4c 01 c6             	add    %r8,%rsi
  a694d2:	49 89 f1             	mov    %rsi,%r9
  a694d5:	49 c1 e1 04          	shl    $0x4,%r9
  a694d9:	4a 39 0c 08          	cmp    %rcx,(%rax,%r9,1)
  a694dd:	48 0f 47 f7          	cmova  %rdi,%rsi
  a694e1:	4c 29 c2             	sub    %r8,%rdx
  a694e4:	48 83 fa 01          	cmp    $0x1,%rdx
  a694e8:	77 dc                	ja     a694c6 <gpui::native::accessibility::projected_node+0xa36>
  a694ea:	48 c1 e6 04          	shl    $0x4,%rsi
  a694ee:	48 39 0c 30          	cmp    %rcx,(%rax,%rsi,1)
  a694f2:	0f 85 c4 f6 ff ff    	jne    a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a694f8:	48 01 f0             	add    %rsi,%rax
  a694fb:	48 83 78 08 00       	cmpq   $0x0,0x8(%rax)
  a69500:	40 0f 95 c5          	setne  %bpl
  a69504:	40 c0 e5 06          	shl    $0x6,%bpl
  a69508:	40 80 cd 0e          	or     $0xe,%bpl
  a6950c:	e9 ab f6 ff ff       	jmp    a68bbc <gpui::native::accessibility::projected_node+0x12c>
  a69511:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
  a69516:	e9 41 f7 ff ff       	jmp    a68c5c <gpui::native::accessibility::projected_node+0x1cc>
  a6951b:	48 8d 15 c6 86 a5 00 	lea    0xa586c6(%rip),%rdx        # 14c1be8 <anon.2e3f3fe1e3954a22393ffc36c003c388.5.llvm.12158732999685545915>
  a69522:	4c 89 f7             	mov    %r14,%rdi
  a69525:	ff 15 25 65 ac 00    	call   *0xac6525(%rip)        # 152fa50 <_DYNAMIC+0x330>
  a6952b:	48 89 c3             	mov    %rax,%rbx
  a6952e:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  a69535:	00 
  a69536:	e8 55 c3 ff ff       	call   a65890 <core::ptr::drop_glue::<accesskit::Node>>
  a6953b:	48 89 df             	mov    %rbx,%rdi
  a6953e:	e8 2d 0d a5 00       	call   14ba270 <_Unwind_Resume@plt>
  a69543:	ff 15 5f 64 ac 00    	call   *0xac645f(%rip)        # 152f9a8 <_DYNAMIC+0x288>
