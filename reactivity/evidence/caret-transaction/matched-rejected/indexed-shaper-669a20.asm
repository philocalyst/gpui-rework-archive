
/tmp/gpui-caret-transaction-bin/matched-indexed-caret_pair_measure:     file format elf64-x86-64


Disassembly of section .text:

0000000000669a20 <<parley::editing::geometry::CursorGeometry<()>>::new>:
  669a20:	55                   	push   %rbp
  669a21:	41 57                	push   %r15
  669a23:	41 56                	push   %r14
  669a25:	41 55                	push   %r13
  669a27:	41 54                	push   %r12
  669a29:	53                   	push   %rbx
  669a2a:	48 81 ec 88 04 00 00 	sub    $0x488,%rsp
  669a31:	4c 8b 7e 70          	mov    0x70(%rsi),%r15
  669a35:	4c 89 f8             	mov    %r15,%rax
  669a38:	48 c1 e8 20          	shr    $0x20,%rax
  669a3c:	75 10                	jne    669a4e <<parley::editing::geometry::CursorGeometry<()>>::new+0x2e>
  669a3e:	48 8b 9e 18 01 00 00 	mov    0x118(%rsi),%rbx
  669a45:	48 89 d8             	mov    %rbx,%rax
  669a48:	48 c1 e8 20          	shr    $0x20,%rax
  669a4c:	74 1c                	je     669a6a <<parley::editing::geometry::CursorGeometry<()>>::new+0x4a>
  669a4e:	48 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%rdi)
  669a55:	48 89 f8             	mov    %rdi,%rax
  669a58:	48 81 c4 88 04 00 00 	add    $0x488,%rsp
  669a5f:	5b                   	pop    %rbx
  669a60:	41 5c                	pop    %r12
  669a62:	41 5d                	pop    %r13
  669a64:	41 5e                	pop    %r14
  669a66:	41 5f                	pop    %r15
  669a68:	5d                   	pop    %rbp
  669a69:	c3                   	ret
  669a6a:	4d 89 fe             	mov    %r15,%r14
  669a6d:	49 c1 e6 04          	shl    $0x4,%r14
  669a71:	4d 85 ff             	test   %r15,%r15
  669a74:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
  669a79:	74 2e                	je     669aa9 <<parley::editing::geometry::CursorGeometry<()>>::new+0x89>
  669a7b:	49 89 fc             	mov    %rdi,%r12
  669a7e:	ff 15 cc d4 11 00    	call   *0x11d4cc(%rip)        # 786f50 <_DYNAMIC+0x2c8>
  669a84:	be 04 00 00 00       	mov    $0x4,%esi
  669a89:	4c 89 f7             	mov    %r14,%rdi
  669a8c:	ff 15 26 d4 11 00    	call   *0x11d426(%rip)        # 786eb8 <_DYNAMIC+0x230>
  669a92:	48 89 04 24          	mov    %rax,(%rsp)
  669a96:	48 85 c0             	test   %rax,%rax
  669a99:	0f 84 5e 07 00 00    	je     66a1fd <<parley::editing::geometry::CursorGeometry<()>>::new+0x7dd>
  669a9f:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  669aa4:	4c 89 e7             	mov    %r12,%rdi
  669aa7:	eb 09                	jmp    669ab2 <<parley::editing::geometry::CursorGeometry<()>>::new+0x92>
  669aa9:	b8 04 00 00 00       	mov    $0x4,%eax
  669aae:	48 89 04 24          	mov    %rax,(%rsp)
  669ab2:	48 b9 f8 ff ff ff ff 	movabs $0x7ffffffffffffff8,%rcx
  669ab9:	ff ff 7f 
  669abc:	48 8b ae 50 01 00 00 	mov    0x150(%rsi),%rbp
  669ac3:	4c 8d 24 ad 00 00 00 	lea    0x0(,%rbp,4),%r12
  669aca:	00 
  669acb:	48 89 e8             	mov    %rbp,%rax
  669ace:	48 c1 e8 3e          	shr    $0x3e,%rax
  669ad2:	0f 95 c0             	setne  %al
  669ad5:	48 83 c1 04          	add    $0x4,%rcx
  669ad9:	49 39 cc             	cmp    %rcx,%r12
  669adc:	0f 97 c1             	seta   %cl
  669adf:	08 c1                	or     %al,%cl
  669ae1:	74 13                	je     669af6 <<parley::editing::geometry::CursorGeometry<()>>::new+0xd6>
  669ae3:	31 ed                	xor    %ebp,%ebp
  669ae5:	48 89 ef             	mov    %rbp,%rdi
  669ae8:	4c 89 e6             	mov    %r12,%rsi
  669aeb:	ff 15 e7 d4 11 00    	call   *0x11d4e7(%rip)        # 786fd8 <_DYNAMIC+0x350>
  669af1:	e9 5d 07 00 00       	jmp    66a253 <<parley::editing::geometry::CursorGeometry<()>>::new+0x833>
  669af6:	48 89 7c 24 70       	mov    %rdi,0x70(%rsp)
  669afb:	4d 85 e4             	test   %r12,%r12
  669afe:	48 89 6c 24 78       	mov    %rbp,0x78(%rsp)
  669b03:	74 56                	je     669b5b <<parley::editing::geometry::CursorGeometry<()>>::new+0x13b>
  669b05:	ff 15 45 d4 11 00    	call   *0x11d445(%rip)        # 786f50 <_DYNAMIC+0x2c8>
  669b0b:	bd 04 00 00 00       	mov    $0x4,%ebp
  669b10:	be 04 00 00 00       	mov    $0x4,%esi
  669b15:	4c 89 e7             	mov    %r12,%rdi
  669b18:	ff 15 9a d3 11 00    	call   *0x11d39a(%rip)        # 786eb8 <_DYNAMIC+0x230>
  669b1e:	48 85 c0             	test   %rax,%rax
  669b21:	74 c2                	je     669ae5 <<parley::editing::geometry::CursorGeometry<()>>::new+0xc5>
  669b23:	49 89 c5             	mov    %rax,%r13
  669b26:	48 8b 6c 24 78       	mov    0x78(%rsp),%rbp
  669b2b:	49 89 ee             	mov    %rbp,%r14
  669b2e:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  669b33:	48 83 fd 02          	cmp    $0x2,%rbp
  669b37:	72 31                	jb     669b6a <<parley::editing::geometry::CursorGeometry<()>>::new+0x14a>
  669b39:	49 8d 54 24 fc       	lea    -0x4(%r12),%rdx
  669b3e:	4c 89 ef             	mov    %r13,%rdi
  669b41:	be ff 00 00 00       	mov    $0xff,%esi
  669b46:	ff 15 7c d4 11 00    	call   *0x11d47c(%rip)        # 786fc8 <memset@GLIBC_2.2.5>
  669b4c:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  669b51:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
  669b55:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  669b59:	eb 17                	jmp    669b72 <<parley::editing::geometry::CursorGeometry<()>>::new+0x152>
  669b5b:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  669b61:	45 31 f6             	xor    %r14d,%r14d
  669b64:	48 83 fd 02          	cmp    $0x2,%rbp
  669b68:	73 cf                	jae    669b39 <<parley::editing::geometry::CursorGeometry<()>>::new+0x119>
  669b6a:	4c 89 e8             	mov    %r13,%rax
  669b6d:	48 85 ed             	test   %rbp,%rbp
  669b70:	74 06                	je     669b78 <<parley::editing::geometry::CursorGeometry<()>>::new+0x158>
  669b72:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%rax)
  669b78:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
  669b7d:	4c 89 6c 24 50       	mov    %r13,0x50(%rsp)
  669b82:	48 89 6c 24 58       	mov    %rbp,0x58(%rsp)
  669b87:	48 89 74 24 60       	mov    %rsi,0x60(%rsp)
  669b8c:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
  669b91:	48 8b 04 24          	mov    (%rsp),%rax
  669b95:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  669b9a:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  669ba1:	00 00 
  669ba3:	48 85 db             	test   %rbx,%rbx
  669ba6:	0f 84 f4 05 00 00    	je     66a1a0 <<parley::editing::geometry::CursorGeometry<()>>::new+0x780>
  669bac:	4c 8b be 10 01 00 00 	mov    0x110(%rsi),%r15
  669bb3:	4c 6b c3 70          	imul   $0x70,%rbx,%r8
  669bb7:	4d 01 f8             	add    %r15,%r8
  669bba:	48 8b 96 30 01 00 00 	mov    0x130(%rsi),%rdx
  669bc1:	4c 8b 8e 28 01 00 00 	mov    0x128(%rsi),%r9
  669bc8:	48 8b 4e 58          	mov    0x58(%rsi),%rcx
  669bcc:	4c 8b 96 e8 00 00 00 	mov    0xe8(%rsi),%r10
  669bd3:	4c 8b 9e e0 00 00 00 	mov    0xe0(%rsi),%r11
  669bda:	48 8b 5e 50          	mov    0x50(%rsi),%rbx
  669bde:	48 8b 46 38          	mov    0x38(%rsi),%rax
  669be2:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
  669be9:	00 
  669bea:	4c 8b 66 40          	mov    0x40(%rsi),%r12
  669bee:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  669bf5:	00 00 
  669bf7:	48 8d 05 02 2b 11 00 	lea    0x112b02(%rip),%rax        # 77c700 <anon.d1c5e71728065e152e7afc2084c95a94.38.llvm.16205762496989061431+0xd8>
  669bfe:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  669c03:	48 8d 05 4e 39 11 00 	lea    0x11394e(%rip),%rax        # 77d558 <anon.1151abbc0aa39aee2edfb443bb148018.29.llvm.12564331471646380133>
  669c0a:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  669c0f:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  669c14:	48 89 94 24 f0 00 00 	mov    %rdx,0xf0(%rsp)
  669c1b:	00 
  669c1c:	4c 89 84 24 e8 00 00 	mov    %r8,0xe8(%rsp)
  669c23:	00 
  669c24:	4c 89 8c 24 e0 00 00 	mov    %r9,0xe0(%rsp)
  669c2b:	00 
  669c2c:	4c 89 94 24 d8 00 00 	mov    %r10,0xd8(%rsp)
  669c33:	00 
  669c34:	4c 89 9c 24 d0 00 00 	mov    %r11,0xd0(%rsp)
  669c3b:	00 
  669c3c:	48 89 9c 24 c8 00 00 	mov    %rbx,0xc8(%rsp)
  669c43:	00 
  669c44:	4c 89 a4 24 c0 00 00 	mov    %r12,0xc0(%rsp)
  669c4b:	00 
  669c4c:	49 8b 7f 10          	mov    0x10(%r15),%rdi
  669c50:	49 8b 47 18          	mov    0x18(%r15),%rax
  669c54:	48 39 f8             	cmp    %rdi,%rax
  669c57:	0f 82 8e 05 00 00    	jb     66a1eb <<parley::editing::geometry::CursorGeometry<()>>::new+0x7cb>
  669c5d:	48 39 d0             	cmp    %rdx,%rax
  669c60:	0f 87 85 05 00 00    	ja     66a1eb <<parley::editing::geometry::CursorGeometry<()>>::new+0x7cb>
  669c66:	48 39 c7             	cmp    %rax,%rdi
  669c69:	75 1a                	jne    669c85 <<parley::editing::geometry::CursorGeometry<()>>::new+0x265>
  669c6b:	49 83 c7 70          	add    $0x70,%r15
  669c6f:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  669c74:	ff c0                	inc    %eax
  669c76:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  669c7b:	4d 39 c7             	cmp    %r8,%r15
  669c7e:	75 cc                	jne    669c4c <<parley::editing::geometry::CursorGeometry<()>>::new+0x22c>
  669c80:	e9 1b 05 00 00       	jmp    66a1a0 <<parley::editing::geometry::CursorGeometry<()>>::new+0x780>
  669c85:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  669c89:	49 8d 04 c1          	lea    (%r9,%rax,8),%rax
  669c8d:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
  669c94:	00 
  669c95:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  669c99:	4d 8d 2c c1          	lea    (%r9,%rax,8),%r13
  669c9d:	f3 41 0f 10 47 28    	movss  0x28(%r15),%xmm0
  669ca3:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  669ca9:	45 31 f6             	xor    %r14d,%r14d
  669cac:	49 8b 7d 10          	mov    0x10(%r13),%rdi
  669cb0:	41 80 7d 21 01       	cmpb   $0x1,0x21(%r13)
  669cb5:	75 41                	jne    669cf8 <<parley::editing::geometry::CursorGeometry<()>>::new+0x2d8>
  669cb7:	4c 39 e7             	cmp    %r12,%rdi
  669cba:	0f 83 64 05 00 00    	jae    66a224 <<parley::editing::geometry::CursorGeometry<()>>::new+0x804>
  669cc0:	48 6b c7 38          	imul   $0x38,%rdi,%rax
  669cc4:	48 8b bc 24 f8 00 00 	mov    0xf8(%rsp),%rdi
  669ccb:	00 
  669ccc:	f3 0f 10 44 07 24    	movss  0x24(%rdi,%rax,1),%xmm0
  669cd2:	49 83 c5 28          	add    $0x28,%r13
  669cd6:	41 ff c6             	inc    %r14d
  669cd9:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  669cdf:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  669ce3:	f3 0f 11 4c 24 0c    	movss  %xmm1,0xc(%rsp)
  669ce9:	4c 3b ac 24 00 01 00 	cmp    0x100(%rsp),%r13
  669cf0:	00 
  669cf1:	75 b9                	jne    669cac <<parley::editing::geometry::CursorGeometry<()>>::new+0x28c>
  669cf3:	e9 73 ff ff ff       	jmp    669c6b <<parley::editing::geometry::CursorGeometry<()>>::new+0x24b>
  669cf8:	48 39 cf             	cmp    %rcx,%rdi
  669cfb:	0f 83 42 05 00 00    	jae    66a243 <<parley::editing::geometry::CursorGeometry<()>>::new+0x823>
  669d01:	4c 39 d7             	cmp    %r10,%rdi
  669d04:	0f 83 28 05 00 00    	jae    66a232 <<parley::editing::geometry::CursorGeometry<()>>::new+0x812>
  669d0a:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
  669d0e:	48 c1 e0 04          	shl    $0x4,%rax
  669d12:	48 8d 0c 03          	lea    (%rbx,%rax,1),%rcx
  669d16:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  669d1a:	48 c1 e2 04          	shl    $0x4,%rdx
  669d1e:	4c 01 da             	add    %r11,%rdx
  669d21:	48 89 b4 24 80 00 00 	mov    %rsi,0x80(%rsp)
  669d28:	00 
  669d29:	48 89 8c 24 88 00 00 	mov    %rcx,0x88(%rsp)
  669d30:	00 
  669d31:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  669d38:	00 
  669d39:	4c 89 ac 24 98 00 00 	mov    %r13,0x98(%rsp)
  669d40:	00 
  669d41:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  669d46:	89 8c 24 a0 00 00 00 	mov    %ecx,0xa0(%rsp)
  669d4d:	44 89 b4 24 a4 00 00 	mov    %r14d,0xa4(%rsp)
  669d54:	00 
  669d55:	89 bc 24 a8 00 00 00 	mov    %edi,0xa8(%rsp)
  669d5c:	0f b6 94 03 8c 00 00 	movzbl 0x8c(%rbx,%rax,1),%edx
  669d63:	00 
  669d64:	8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%eax
  669d6b:	89 84 24 f0 01 00 00 	mov    %eax,0x1f0(%rsp)
  669d72:	8b 84 24 a4 00 00 00 	mov    0xa4(%rsp),%eax
  669d79:	89 84 24 f4 01 00 00 	mov    %eax,0x1f4(%rsp)
  669d80:	8b 84 24 a8 00 00 00 	mov    0xa8(%rsp),%eax
  669d87:	89 84 24 f8 01 00 00 	mov    %eax,0x1f8(%rsp)
  669d8e:	8b 84 24 ac 00 00 00 	mov    0xac(%rsp),%eax
  669d95:	89 84 24 fc 01 00 00 	mov    %eax,0x1fc(%rsp)
  669d9c:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  669da3:	00 
  669da4:	48 89 84 24 e0 01 00 	mov    %rax,0x1e0(%rsp)
  669dab:	00 
  669dac:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  669db3:	00 
  669db4:	48 89 84 24 e8 01 00 	mov    %rax,0x1e8(%rsp)
  669dbb:	00 
  669dbc:	0f 10 84 24 80 00 00 	movups 0x80(%rsp),%xmm0
  669dc3:	00 
  669dc4:	0f 29 84 24 d0 01 00 	movaps %xmm0,0x1d0(%rsp)
  669dcb:	00 
  669dcc:	83 e2 01             	and    $0x1,%edx
  669dcf:	48 8d 9c 24 78 03 00 	lea    0x378(%rsp),%rbx
  669dd6:	00 
  669dd7:	48 89 df             	mov    %rbx,%rdi
  669dda:	4c 8d a4 24 d0 01 00 	lea    0x1d0(%rsp),%r12
  669de1:	00 
  669de2:	4c 89 e6             	mov    %r12,%rsi
  669de5:	e8 66 cf ff ff       	call   666d50 <<parley::layout::run::Clusters<()>>::new>
  669dea:	ba 10 01 00 00       	mov    $0x110,%edx
  669def:	4c 89 e7             	mov    %r12,%rdi
  669df2:	48 89 de             	mov    %rbx,%rsi
  669df5:	ff 15 5d d1 11 00    	call   *0x11d15d(%rip)        # 786f58 <memcpy@GLIBC_2.14>
  669dfb:	66 0f 6e 44 24 0c    	movd   0xc(%rsp),%xmm0
  669e01:	66 0f 7e 04 24       	movd   %xmm0,(%rsp)
  669e06:	eb 1b                	jmp    669e23 <<parley::editing::geometry::CursorGeometry<()>>::new+0x403>
  669e08:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  669e0d:	f3 0f 58 c1          	addss  %xmm1,%xmm0
  669e11:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  669e16:	48 8b 6c 24 78       	mov    0x78(%rsp),%rbp
  669e1b:	4c 8d a4 24 d0 01 00 	lea    0x1d0(%rsp),%r12
  669e22:	00 
  669e23:	48 8d bc 24 e8 02 00 	lea    0x2e8(%rsp),%rdi
  669e2a:	00 
  669e2b:	4c 89 e6             	mov    %r12,%rsi
  669e2e:	e8 7d d6 ff ff       	call   6674b0 <<parley::layout::run::Clusters<()> as core::iter::traits::iterator::Iterator>::next>
  669e33:	48 83 bc 24 e8 02 00 	cmpq   $0x0,0x2e8(%rsp)
  669e3a:	00 00 
  669e3c:	0f 84 af 02 00 00    	je     66a0f1 <<parley::editing::geometry::CursorGeometry<()>>::new+0x6d1>
  669e42:	ba 90 00 00 00       	mov    $0x90,%edx
  669e47:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  669e4e:	00 
  669e4f:	48 8d b4 24 e8 02 00 	lea    0x2e8(%rsp),%rsi
  669e56:	00 
  669e57:	ff 15 fb d0 11 00    	call   *0x11d0fb(%rip)        # 786f58 <memcpy@GLIBC_2.14>
  669e5d:	4c 8b 64 24 40       	mov    0x40(%rsp),%r12
  669e62:	f3 0f 7e 84 24 60 01 	movq   0x160(%rsp),%xmm0
  669e69:	00 00 
  669e6b:	66 0f 7f 84 24 b0 00 	movdqa %xmm0,0xb0(%rsp)
  669e72:	00 00 
  669e74:	8b 9c 24 c0 01 00 00 	mov    0x1c0(%rsp),%ebx
  669e7b:	4c 3b 64 24 30       	cmp    0x30(%rsp),%r12
  669e80:	75 0b                	jne    669e8d <<parley::editing::geometry::CursorGeometry<()>>::new+0x46d>
  669e82:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  669e87:	ff 15 bb d2 11 00    	call   *0x11d2bb(%rip)        # 787148 <_DYNAMIC+0x4c0>
  669e8d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  669e92:	4c 89 e1             	mov    %r12,%rcx
  669e95:	48 c1 e1 04          	shl    $0x4,%rcx
  669e99:	0f 28 84 24 b0 00 00 	movaps 0xb0(%rsp),%xmm0
  669ea0:	00 
  669ea1:	0f 13 04 08          	movlps %xmm0,(%rax,%rcx,1)
  669ea5:	89 5c 08 08          	mov    %ebx,0x8(%rax,%rcx,1)
  669ea9:	66 0f 6e 04 24       	movd   (%rsp),%xmm0
  669eae:	66 0f 7e 44 08 0c    	movd   %xmm0,0xc(%rax,%rcx,1)
  669eb4:	49 8d 44 24 01       	lea    0x1(%r12),%rax
  669eb9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  669ebe:	48 83 bc 24 58 01 00 	cmpq   $0x0,0x158(%rsp)
  669ec5:	00 00 
  669ec7:	74 36                	je     669eff <<parley::editing::geometry::CursorGeometry<()>>::new+0x4df>
  669ec9:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  669ed0:	00 
  669ed1:	8b bc 24 60 01 00 00 	mov    0x160(%rsp),%edi
  669ed8:	48 8b b0 18 01 00 00 	mov    0x118(%rax),%rsi
  669edf:	48 39 fe             	cmp    %rdi,%rsi
  669ee2:	0f 86 2f 03 00 00    	jbe    66a217 <<parley::editing::geometry::CursorGeometry<()>>::new+0x7f7>
  669ee8:	48 8b 80 10 01 00 00 	mov    0x110(%rax),%rax
  669eef:	48 6b cf 70          	imul   $0x70,%rdi,%rcx
  669ef3:	66 0f 6e 44 08 50    	movd   0x50(%rax,%rcx,1),%xmm0
  669ef9:	8b 44 08 54          	mov    0x54(%rax,%rcx,1),%eax
  669efd:	eb 09                	jmp    669f08 <<parley::editing::geometry::CursorGeometry<()>>::new+0x4e8>
  669eff:	66 0f ef c0          	pxor   %xmm0,%xmm0
  669f03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  669f08:	48 8b 8c 24 48 01 00 	mov    0x148(%rsp),%rcx
  669f0f:	00 
  669f10:	48 8b 94 24 50 01 00 	mov    0x150(%rsp),%rdx
  669f17:	00 
  669f18:	f3 0f 7e 4a 44       	movq   0x44(%rdx),%xmm1
  669f1d:	66 0f d6 8c 24 08 01 	movq   %xmm1,0x108(%rsp)
  669f24:	00 00 
  669f26:	66 0f 7e 84 24 10 01 	movd   %xmm0,0x110(%rsp)
  669f2d:	00 00 
  669f2f:	89 84 24 14 01 00 00 	mov    %eax,0x114(%rsp)
  669f36:	0f b6 89 8c 00 00 00 	movzbl 0x8c(%rcx),%ecx
  669f3d:	83 e1 01             	and    $0x1,%ecx
  669f40:	48 8d bc 24 08 01 00 	lea    0x108(%rsp),%rdi
  669f47:	00 
  669f48:	48 8d b4 24 70 01 00 	lea    0x170(%rsp),%rsi
  669f4f:	00 
  669f50:	48 8d 94 24 c0 01 00 	lea    0x1c0(%rsp),%rdx
  669f57:	00 
  669f58:	ff 15 ca d2 11 00    	call   *0x11d2ca(%rip)        # 787228 <_DYNAMIC+0x5a0>
  669f5e:	66 0f 6f c8          	movdqa %xmm0,%xmm1
  669f62:	48 85 ed             	test   %rbp,%rbp
  669f65:	0f 84 9d fe ff ff    	je     669e08 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3e8>
  669f6b:	66 0f 7e 8c 24 b0 00 	movd   %xmm1,0xb0(%rsp)
  669f72:	00 00 
  669f74:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  669f7b:	00 
  669f7c:	8b bc 24 68 01 00 00 	mov    0x168(%rsp),%edi
  669f83:	48 8b 70 58          	mov    0x58(%rax),%rsi
  669f87:	48 39 fe             	cmp    %rdi,%rsi
  669f8a:	0f 86 7b 02 00 00    	jbe    66a20b <<parley::editing::geometry::CursorGeometry<()>>::new+0x7eb>
  669f90:	48 8b 48 50          	mov    0x50(%rax),%rcx
  669f94:	48 8d 14 ff          	lea    (%rdi,%rdi,8),%rdx
  669f98:	48 c1 e2 04          	shl    $0x4,%rdx
  669f9c:	f3 0f 6f 40 68       	movdqu 0x68(%rax),%xmm0
  669fa1:	0f 10 88 80 00 00 00 	movups 0x80(%rax),%xmm1
  669fa8:	0f 10 90 98 00 00 00 	movups 0x98(%rax),%xmm2
  669faf:	f3 0f 7f 84 24 08 01 	movdqu %xmm0,0x108(%rsp)
  669fb6:	00 00 
  669fb8:	0f 11 8c 24 18 01 00 	movups %xmm1,0x118(%rsp)
  669fbf:	00 
  669fc0:	0f 11 94 24 28 01 00 	movups %xmm2,0x128(%rsp)
  669fc7:	00 
  669fc8:	48 8b 44 11 50       	mov    0x50(%rcx,%rdx,1),%rax
  669fcd:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
  669fd4:	00 
  669fd5:	8b b4 24 c0 01 00 00 	mov    0x1c0(%rsp),%esi
  669fdc:	8b 94 24 c4 01 00 00 	mov    0x1c4(%rsp),%edx
  669fe3:	48 8d bc 24 08 01 00 	lea    0x108(%rsp),%rdi
  669fea:	00 
  669feb:	ff 15 af d1 11 00    	call   *0x11d1af(%rip)        # 7871a0 <_DYNAMIC+0x518>
  669ff1:	66 0f 6e 8c 24 b0 00 	movd   0xb0(%rsp),%xmm1
  669ff8:	00 00 
  669ffa:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  669fff:	48 39 c2             	cmp    %rax,%rdx
  66a002:	0f 82 3d 01 00 00    	jb     66a145 <<parley::editing::geometry::CursorGeometry<()>>::new+0x725>
  66a008:	48 3b 54 24 58       	cmp    0x58(%rsp),%rdx
  66a00d:	0f 87 32 01 00 00    	ja     66a145 <<parley::editing::geometry::CursorGeometry<()>>::new+0x725>
  66a013:	48 89 d1             	mov    %rdx,%rcx
  66a016:	48 29 c1             	sub    %rax,%rcx
  66a019:	48 8d 34 85 00 00 00 	lea    0x0(,%rax,4),%rsi
  66a020:	00 
  66a021:	48 01 ee             	add    %rbp,%rsi
  66a024:	4c 8d 04 85 00 00 00 	lea    0x0(,%rax,4),%r8
  66a02b:	00 
  66a02c:	48 8d 3c 95 00 00 00 	lea    0x0(,%rdx,4),%rdi
  66a033:	00 
  66a034:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  66a03b:	00 00 00 00 00 
  66a040:	4c 39 c7             	cmp    %r8,%rdi
  66a043:	74 11                	je     66a056 <<parley::editing::geometry::CursorGeometry<()>>::new+0x636>
  66a045:	42 83 7c 05 00 ff    	cmpl   $0xffffffff,0x0(%rbp,%r8,1)
  66a04b:	4d 8d 40 04          	lea    0x4(%r8),%r8
  66a04f:	74 ef                	je     66a040 <<parley::editing::geometry::CursorGeometry<()>>::new+0x620>
  66a051:	e9 ef 00 00 00       	jmp    66a145 <<parley::editing::geometry::CursorGeometry<()>>::new+0x725>
  66a056:	4d 89 e0             	mov    %r12,%r8
  66a059:	49 c1 e8 20          	shr    $0x20,%r8
  66a05d:	0f 85 e2 00 00 00    	jne    66a145 <<parley::editing::geometry::CursorGeometry<()>>::new+0x725>
  66a063:	48 39 c2             	cmp    %rax,%rdx
  66a066:	0f 84 9c fd ff ff    	je     669e08 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3e8>
  66a06c:	48 c1 e0 02          	shl    $0x2,%rax
  66a070:	48 29 c7             	sub    %rax,%rdi
  66a073:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
  66a077:	48 89 f2             	mov    %rsi,%rdx
  66a07a:	48 83 ff 1c          	cmp    $0x1c,%rdi
  66a07e:	72 4f                	jb     66a0cf <<parley::editing::geometry::CursorGeometry<()>>::new+0x6af>
  66a080:	48 c1 ef 02          	shr    $0x2,%rdi
  66a084:	48 ff c7             	inc    %rdi
  66a087:	49 89 f8             	mov    %rdi,%r8
  66a08a:	48 ba f8 ff ff ff ff 	movabs $0x7ffffffffffffff8,%rdx
  66a091:	ff ff 7f 
  66a094:	49 21 d0             	and    %rdx,%r8
  66a097:	4a 8d 14 86          	lea    (%rsi,%r8,4),%rdx
  66a09b:	66 41 0f 6e c4       	movd   %r12d,%xmm0
  66a0a0:	66 0f 70 c0 00       	pshufd $0x0,%xmm0,%xmm0
  66a0a5:	48 01 e8             	add    %rbp,%rax
  66a0a8:	48 83 c0 10          	add    $0x10,%rax
  66a0ac:	45 31 c9             	xor    %r9d,%r9d
  66a0af:	90                   	nop
  66a0b0:	f3 42 0f 7f 44 88 f0 	movdqu %xmm0,-0x10(%rax,%r9,4)
  66a0b7:	f3 42 0f 7f 04 88    	movdqu %xmm0,(%rax,%r9,4)
  66a0bd:	49 83 c1 08          	add    $0x8,%r9
  66a0c1:	4d 39 c8             	cmp    %r9,%r8
  66a0c4:	75 ea                	jne    66a0b0 <<parley::editing::geometry::CursorGeometry<()>>::new+0x690>
  66a0c6:	4c 39 c7             	cmp    %r8,%rdi
  66a0c9:	0f 84 39 fd ff ff    	je     669e08 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3e8>
  66a0cf:	48 8d 04 8e          	lea    (%rsi,%rcx,4),%rax
  66a0d3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  66a0da:	84 00 00 00 00 00 
  66a0e0:	44 89 22             	mov    %r12d,(%rdx)
  66a0e3:	48 83 c2 04          	add    $0x4,%rdx
  66a0e7:	48 39 c2             	cmp    %rax,%rdx
  66a0ea:	75 f4                	jne    66a0e0 <<parley::editing::geometry::CursorGeometry<()>>::new+0x6c0>
  66a0ec:	e9 17 fd ff ff       	jmp    669e08 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3e8>
  66a0f1:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  66a0f8:	00 
  66a0f9:	e8 a2 c3 ff ff       	call   6664a0 <<parley::layout::run::Run<()>>::advance>
  66a0fe:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  66a103:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  66a108:	48 8b 94 24 f0 00 00 	mov    0xf0(%rsp),%rdx
  66a10f:	00 
  66a110:	4c 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%r8
  66a117:	00 
  66a118:	4c 8b 8c 24 e0 00 00 	mov    0xe0(%rsp),%r9
  66a11f:	00 
  66a120:	4c 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%r10
  66a127:	00 
  66a128:	4c 8b 9c 24 d0 00 00 	mov    0xd0(%rsp),%r11
  66a12f:	00 
  66a130:	48 8b 9c 24 c8 00 00 	mov    0xc8(%rsp),%rbx
  66a137:	00 
  66a138:	4c 8b a4 24 c0 00 00 	mov    0xc0(%rsp),%r12
  66a13f:	00 
  66a140:	e9 8d fb ff ff       	jmp    669cd2 <<parley::editing::geometry::CursorGeometry<()>>::new+0x2b2>
  66a145:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  66a14a:	48 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%rdi)
  66a151:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  66a156:	48 85 f6             	test   %rsi,%rsi
  66a159:	74 1a                	je     66a175 <<parley::editing::geometry::CursorGeometry<()>>::new+0x755>
  66a15b:	48 89 fb             	mov    %rdi,%rbx
  66a15e:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
  66a163:	48 c1 e6 04          	shl    $0x4,%rsi
  66a167:	ba 04 00 00 00       	mov    $0x4,%edx
  66a16c:	ff 15 4e cd 11 00    	call   *0x11cd4e(%rip)        # 786ec0 <_DYNAMIC+0x238>
  66a172:	48 89 df             	mov    %rbx,%rdi
  66a175:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  66a17a:	48 85 f6             	test   %rsi,%rsi
  66a17d:	0f 84 d2 f8 ff ff    	je     669a55 <<parley::editing::geometry::CursorGeometry<()>>::new+0x35>
  66a183:	48 c1 e6 02          	shl    $0x2,%rsi
  66a187:	ba 04 00 00 00       	mov    $0x4,%edx
  66a18c:	48 89 fb             	mov    %rdi,%rbx
  66a18f:	48 89 ef             	mov    %rbp,%rdi
  66a192:	ff 15 28 cd 11 00    	call   *0x11cd28(%rip)        # 786ec0 <_DYNAMIC+0x238>
  66a198:	48 89 df             	mov    %rbx,%rdi
  66a19b:	e9 b5 f8 ff ff       	jmp    669a55 <<parley::editing::geometry::CursorGeometry<()>>::new+0x35>
  66a1a0:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  66a1a5:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  66a1aa:	49 89 40 30          	mov    %rax,0x30(%r8)
  66a1ae:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  66a1b3:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  66a1b8:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  66a1bd:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  66a1c2:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  66a1c7:	49 89 78 20          	mov    %rdi,0x20(%r8)
  66a1cb:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
  66a1d0:	49 89 78 28          	mov    %rdi,0x28(%r8)
  66a1d4:	4c 89 c7             	mov    %r8,%rdi
  66a1d7:	49 89 50 10          	mov    %rdx,0x10(%r8)
  66a1db:	49 89 70 18          	mov    %rsi,0x18(%r8)
  66a1df:	49 89 00             	mov    %rax,(%r8)
  66a1e2:	49 89 48 08          	mov    %rcx,0x8(%r8)
  66a1e6:	e9 6a f8 ff ff       	jmp    669a55 <<parley::editing::geometry::CursorGeometry<()>>::new+0x35>
  66a1eb:	48 8d 0d 6e 25 11 00 	lea    0x11256e(%rip),%rcx        # 77c760 <anon.4751b62d855c69562269c18746b5820c.22.llvm.11613928405728550318>
  66a1f2:	48 89 c6             	mov    %rax,%rsi
  66a1f5:	ff 15 65 cf 11 00    	call   *0x11cf65(%rip)        # 787160 <_DYNAMIC+0x4d8>
  66a1fb:	eb 56                	jmp    66a253 <<parley::editing::geometry::CursorGeometry<()>>::new+0x833>
  66a1fd:	bf 04 00 00 00       	mov    $0x4,%edi
  66a202:	4c 89 f6             	mov    %r14,%rsi
  66a205:	ff 15 cd cd 11 00    	call   *0x11cdcd(%rip)        # 786fd8 <_DYNAMIC+0x350>
  66a20b:	48 8d 05 06 34 11 00 	lea    0x113406(%rip),%rax        # 77d618 <anon.1151abbc0aa39aee2edfb443bb148018.38.llvm.12564331471646380133>
  66a212:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  66a217:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  66a21c:	ff 15 c6 cd 11 00    	call   *0x11cdc6(%rip)        # 786fe8 <_DYNAMIC+0x360>
  66a222:	eb 2f                	jmp    66a253 <<parley::editing::geometry::CursorGeometry<()>>::new+0x833>
  66a224:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  66a229:	48 8d 05 00 25 11 00 	lea    0x112500(%rip),%rax        # 77c730 <anon.d1c5e71728065e152e7afc2084c95a94.38.llvm.16205762496989061431+0x108>
  66a230:	eb 0c                	jmp    66a23e <<parley::editing::geometry::CursorGeometry<()>>::new+0x81e>
  66a232:	4c 89 54 24 10       	mov    %r10,0x10(%rsp)
  66a237:	48 8d 05 da 24 11 00 	lea    0x1124da(%rip),%rax        # 77c718 <anon.d1c5e71728065e152e7afc2084c95a94.38.llvm.16205762496989061431+0xf0>
  66a23e:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  66a243:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  66a248:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  66a24d:	ff 15 95 cd 11 00    	call   *0x11cd95(%rip)        # 786fe8 <_DYNAMIC+0x360>
  66a253:	0f 0b                	ud2
  66a255:	eb 04                	jmp    66a25b <<parley::editing::geometry::CursorGeometry<()>>::new+0x83b>
  66a257:	eb 02                	jmp    66a25b <<parley::editing::geometry::CursorGeometry<()>>::new+0x83b>
  66a259:	eb 00                	jmp    66a25b <<parley::editing::geometry::CursorGeometry<()>>::new+0x83b>
  66a25b:	48 89 c3             	mov    %rax,%rbx
  66a25e:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  66a263:	e8 78 eb ff ff       	call   668de0 <core::ptr::drop_glue::<parley::editing::geometry::CursorGeometry<()>>>
  66a268:	48 89 df             	mov    %rbx,%rdi
  66a26b:	e8 f0 0b 11 00       	call   77ae60 <_Unwind_Resume@plt>
  66a270:	48 89 c3             	mov    %rax,%rbx
  66a273:	4d 85 ff             	test   %r15,%r15
  66a276:	74 12                	je     66a28a <<parley::editing::geometry::CursorGeometry<()>>::new+0x86a>
  66a278:	ba 04 00 00 00       	mov    $0x4,%edx
  66a27d:	48 8b 3c 24          	mov    (%rsp),%rdi
  66a281:	4c 89 f6             	mov    %r14,%rsi
  66a284:	ff 15 36 cc 11 00    	call   *0x11cc36(%rip)        # 786ec0 <_DYNAMIC+0x238>
  66a28a:	48 89 df             	mov    %rbx,%rdi
  66a28d:	e8 ce 0b 11 00       	call   77ae60 <_Unwind_Resume@plt>
