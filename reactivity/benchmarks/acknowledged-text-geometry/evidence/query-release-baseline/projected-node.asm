
/tmp/gpui-acknowledged-text-evidence/query-release-baseline/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a78bf0 <gpui::native::accessibility::projected_node>:
  a78bf0:	55                   	push   %rbp
  a78bf1:	41 57                	push   %r15
  a78bf3:	41 56                	push   %r14
  a78bf5:	41 55                	push   %r13
  a78bf7:	41 54                	push   %r12
  a78bf9:	53                   	push   %rbx
  a78bfa:	48 81 ec 68 01 00 00 	sub    $0x168,%rsp
  a78c01:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  a78c06:	49 89 f6             	mov    %rsi,%r14
  a78c09:	48 89 fb             	mov    %rdi,%rbx
  a78c0c:	0f b6 4e 4d          	movzbl 0x4d(%rsi),%ecx
  a78c10:	48 8d 05 a9 db 72 ff 	lea    -0x8d2457(%rip),%rax        # 1a67c0 <anon.7f631502f28dba8b34645de2728b692f.11.llvm.12156611386205377922+0x2f7>
  a78c17:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  a78c1c:	48 63 0c 88          	movslq (%rax,%rcx,4),%rcx
  a78c20:	48 01 c1             	add    %rax,%rcx
  a78c23:	49 bf 57 57 57 57 57 	movabs $0x5757575757575757,%r15
  a78c2a:	57 57 57 
  a78c2d:	ff e1                	jmp    *%rcx
  a78c2f:	40 b5 12             	mov    $0x12,%bpl
  a78c32:	41 f6 46 4c 01       	testb  $0x1,0x4c(%r14)
  a78c37:	0f 85 a0 00 00 00    	jne    a78cdd <gpui::native::accessibility::projected_node+0xed>
  a78c3d:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  a78c42:	48 8b 48 50          	mov    0x50(%rax),%rcx
  a78c46:	48 85 c9             	test   %rcx,%rcx
  a78c49:	0f 84 43 0a 00 00    	je     a79692 <gpui::native::accessibility::projected_node+0xaa2>
  a78c4f:	49 8b 46 20          	mov    0x20(%r14),%rax
  a78c53:	48 8b 71 28          	mov    0x28(%rcx),%rsi
  a78c57:	48 85 f6             	test   %rsi,%rsi
  a78c5a:	0f 84 91 0a 00 00    	je     a796f1 <gpui::native::accessibility::projected_node+0xb01>
  a78c60:	48 8b 51 20          	mov    0x20(%rcx),%rdx
  a78c64:	48 83 fe 01          	cmp    $0x1,%rsi
  a78c68:	0f 85 3a 0a 00 00    	jne    a796a8 <gpui::native::accessibility::projected_node+0xab8>
  a78c6e:	48 39 02             	cmp    %rax,(%rdx)
  a78c71:	0f 84 6a 0a 00 00    	je     a796e1 <gpui::native::accessibility::projected_node+0xaf1>
  a78c77:	e9 75 0a 00 00       	jmp    a796f1 <gpui::native::accessibility::projected_node+0xb01>
  a78c7c:	40 b5 18             	mov    $0x18,%bpl
  a78c7f:	eb 5c                	jmp    a78cdd <gpui::native::accessibility::projected_node+0xed>
  a78c81:	40 b5 11             	mov    $0x11,%bpl
  a78c84:	eb 57                	jmp    a78cdd <gpui::native::accessibility::projected_node+0xed>
  a78c86:	40 b5 12             	mov    $0x12,%bpl
  a78c89:	eb 52                	jmp    a78cdd <gpui::native::accessibility::projected_node+0xed>
  a78c8b:	40 b5 6c             	mov    $0x6c,%bpl
  a78c8e:	eb 4d                	jmp    a78cdd <gpui::native::accessibility::projected_node+0xed>
  a78c90:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  a78c95:	4c 8b 60 50          	mov    0x50(%rax),%r12
  a78c99:	4d 85 e4             	test   %r12,%r12
  a78c9c:	0f 84 75 08 00 00    	je     a79517 <gpui::native::accessibility::projected_node+0x927>
  a78ca2:	49 8b 4c 24 28       	mov    0x28(%r12),%rcx
  a78ca7:	48 85 c9             	test   %rcx,%rcx
  a78caa:	0f 84 67 08 00 00    	je     a79517 <gpui::native::accessibility::projected_node+0x927>
  a78cb0:	49 8b 56 20          	mov    0x20(%r14),%rdx
  a78cb4:	49 8b 44 24 20       	mov    0x20(%r12),%rax
  a78cb9:	48 83 f9 01          	cmp    $0x1,%rcx
  a78cbd:	0f 85 19 08 00 00    	jne    a794dc <gpui::native::accessibility::projected_node+0x8ec>
  a78cc3:	48 39 10             	cmp    %rdx,(%rax)
  a78cc6:	0f 85 4b 08 00 00    	jne    a79517 <gpui::native::accessibility::projected_node+0x927>
  a78ccc:	48 8b 78 08          	mov    0x8(%rax),%rdi
  a78cd0:	e9 46 08 00 00       	jmp    a7951b <gpui::native::accessibility::projected_node+0x92b>
  a78cd5:	40 b5 07             	mov    $0x7,%bpl
  a78cd8:	eb 03                	jmp    a78cdd <gpui::native::accessibility::projected_node+0xed>
  a78cda:	40 b5 04             	mov    $0x4,%bpl
  a78cdd:	40 88 ac 24 24 01 00 	mov    %bpl,0x124(%rsp)
  a78ce4:	00 
  a78ce5:	48 c7 84 24 18 01 00 	movq   $0x0,0x118(%rsp)
  a78cec:	00 00 00 00 00 
  a78cf1:	c7 84 24 20 01 00 00 	movl   $0x0,0x120(%rsp)
  a78cf8:	00 00 00 00 
  a78cfc:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  a78d03:	00 00 00 00 00 
  a78d08:	48 c7 84 24 b0 00 00 	movq   $0x8,0xb0(%rsp)
  a78d0f:	00 08 00 00 00 
  a78d14:	48 c7 84 24 b8 00 00 	movq   $0x0,0xb8(%rsp)
  a78d1b:	00 00 00 00 00 
  a78d20:	66 0f 28 05 88 35 71 	movapd -0x8eca78(%rip),%xmm0        # 18c2b0 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a78d27:	ff 
  a78d28:	66 0f 11 84 24 c0 00 	movupd %xmm0,0xc0(%rsp)
  a78d2f:	00 00 
  a78d31:	66 0f 11 84 24 d0 00 	movupd %xmm0,0xd0(%rsp)
  a78d38:	00 00 
  a78d3a:	66 0f 11 84 24 e0 00 	movupd %xmm0,0xe0(%rsp)
  a78d41:	00 00 
  a78d43:	66 0f 11 84 24 f0 00 	movupd %xmm0,0xf0(%rsp)
  a78d4a:	00 00 
  a78d4c:	66 0f 11 84 24 00 01 	movupd %xmm0,0x100(%rsp)
  a78d53:	00 00 
  a78d55:	4c 89 bc 24 0f 01 00 	mov    %r15,0x10f(%rsp)
  a78d5c:	00 
  a78d5d:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  a78d62:	4c 8b 60 50          	mov    0x50(%rax),%r12
  a78d66:	4d 85 e4             	test   %r12,%r12
  a78d69:	74 71                	je     a78ddc <gpui::native::accessibility::projected_node+0x1ec>
  a78d6b:	49 8b 4c 24 28       	mov    0x28(%r12),%rcx
  a78d70:	48 85 c9             	test   %rcx,%rcx
  a78d73:	74 67                	je     a78ddc <gpui::native::accessibility::projected_node+0x1ec>
  a78d75:	49 8b 56 20          	mov    0x20(%r14),%rdx
  a78d79:	49 8b 44 24 20       	mov    0x20(%r12),%rax
  a78d7e:	48 83 f9 01          	cmp    $0x1,%rcx
  a78d82:	75 13                	jne    a78d97 <gpui::native::accessibility::projected_node+0x1a7>
  a78d84:	48 39 10             	cmp    %rdx,(%rax)
  a78d87:	75 53                	jne    a78ddc <gpui::native::accessibility::projected_node+0x1ec>
  a78d89:	4c 8b 78 08          	mov    0x8(%rax),%r15
  a78d8d:	4d 85 ff             	test   %r15,%r15
  a78d90:	75 5a                	jne    a78dec <gpui::native::accessibility::projected_node+0x1fc>
  a78d92:	e9 c3 00 00 00       	jmp    a78e5a <gpui::native::accessibility::projected_node+0x26a>
  a78d97:	31 f6                	xor    %esi,%esi
  a78d99:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  a78da0:	48 89 f7             	mov    %rsi,%rdi
  a78da3:	49 89 c8             	mov    %rcx,%r8
  a78da6:	49 d1 e8             	shr    $1,%r8
  a78da9:	4c 01 c6             	add    %r8,%rsi
  a78dac:	49 89 f1             	mov    %rsi,%r9
  a78daf:	49 c1 e1 04          	shl    $0x4,%r9
  a78db3:	4a 39 14 08          	cmp    %rdx,(%rax,%r9,1)
  a78db7:	48 0f 47 f7          	cmova  %rdi,%rsi
  a78dbb:	4c 29 c1             	sub    %r8,%rcx
  a78dbe:	48 83 f9 01          	cmp    $0x1,%rcx
  a78dc2:	77 dc                	ja     a78da0 <gpui::native::accessibility::projected_node+0x1b0>
  a78dc4:	48 c1 e6 04          	shl    $0x4,%rsi
  a78dc8:	48 39 14 30          	cmp    %rdx,(%rax,%rsi,1)
  a78dcc:	75 0e                	jne    a78ddc <gpui::native::accessibility::projected_node+0x1ec>
  a78dce:	48 01 f0             	add    %rsi,%rax
  a78dd1:	4c 8b 78 08          	mov    0x8(%rax),%r15
  a78dd5:	4d 85 ff             	test   %r15,%r15
  a78dd8:	75 12                	jne    a78dec <gpui::native::accessibility::projected_node+0x1fc>
  a78dda:	eb 7e                	jmp    a78e5a <gpui::native::accessibility::projected_node+0x26a>
  a78ddc:	83 7c 24 08 02       	cmpl   $0x2,0x8(%rsp)
  a78de1:	74 77                	je     a78e5a <gpui::native::accessibility::projected_node+0x26a>
  a78de3:	4d 8b 7e 28          	mov    0x28(%r14),%r15
  a78de7:	4d 85 ff             	test   %r15,%r15
  a78dea:	74 6e                	je     a78e5a <gpui::native::accessibility::projected_node+0x26a>
  a78dec:	4d 8b 2f             	mov    (%r15),%r13
  a78def:	49 d1 ed             	shr    $1,%r13
  a78df2:	74 35                	je     a78e29 <gpui::native::accessibility::projected_node+0x239>
  a78df4:	ff 15 5e ef aa 00    	call   *0xaaef5e(%rip)        # 1527d58 <_DYNAMIC+0x240>
  a78dfa:	be 01 00 00 00       	mov    $0x1,%esi
  a78dff:	4c 89 ef             	mov    %r13,%rdi
  a78e02:	ff 15 58 ef aa 00    	call   *0xaaef58(%rip)        # 1527d60 <_DYNAMIC+0x248>
  a78e08:	48 85 c0             	test   %rax,%rax
  a78e0b:	0f 84 64 09 00 00    	je     a79775 <gpui::native::accessibility::projected_node+0xb85>
  a78e11:	48 89 c5             	mov    %rax,%rbp
  a78e14:	49 83 c7 10          	add    $0x10,%r15
  a78e18:	48 89 c7             	mov    %rax,%rdi
  a78e1b:	4c 89 fe             	mov    %r15,%rsi
  a78e1e:	4c 89 ea             	mov    %r13,%rdx
  a78e21:	ff 15 51 ef aa 00    	call   *0xaaef51(%rip)        # 1527d78 <memcpy@GLIBC_2.14>
  a78e27:	eb 05                	jmp    a78e2e <gpui::native::accessibility::projected_node+0x23e>
  a78e29:	bd 01 00 00 00       	mov    $0x1,%ebp
  a78e2e:	4c 89 6c 24 38       	mov    %r13,0x38(%rsp)
  a78e33:	48 89 6c 24 40       	mov    %rbp,0x40(%rsp)
  a78e38:	4c 89 6c 24 48       	mov    %r13,0x48(%rsp)
  a78e3d:	c6 44 24 30 03       	movb   $0x3,0x30(%rsp)
  a78e42:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  a78e49:	00 
  a78e4a:	48 8d 54 24 30       	lea    0x30(%rsp),%rdx
  a78e4f:	be 0f 00 00 00       	mov    $0xf,%esi
  a78e54:	ff 15 86 02 ab 00    	call   *0xab0286(%rip)        # 15290e0 <_DYNAMIC+0x15c8>
  a78e5a:	83 7c 24 08 02       	cmpl   $0x2,0x8(%rsp)
  a78e5f:	75 77                	jne    a78ed8 <gpui::native::accessibility::projected_node+0x2e8>
  a78e61:	4d 8b 7e 28          	mov    0x28(%r14),%r15
  a78e65:	4d 85 ff             	test   %r15,%r15
  a78e68:	74 6e                	je     a78ed8 <gpui::native::accessibility::projected_node+0x2e8>
  a78e6a:	4d 8b 2f             	mov    (%r15),%r13
  a78e6d:	49 d1 ed             	shr    $1,%r13
  a78e70:	74 35                	je     a78ea7 <gpui::native::accessibility::projected_node+0x2b7>
  a78e72:	ff 15 e0 ee aa 00    	call   *0xaaeee0(%rip)        # 1527d58 <_DYNAMIC+0x240>
  a78e78:	be 01 00 00 00       	mov    $0x1,%esi
  a78e7d:	4c 89 ef             	mov    %r13,%rdi
  a78e80:	ff 15 da ee aa 00    	call   *0xaaeeda(%rip)        # 1527d60 <_DYNAMIC+0x248>
  a78e86:	48 85 c0             	test   %rax,%rax
  a78e89:	0f 84 e6 08 00 00    	je     a79775 <gpui::native::accessibility::projected_node+0xb85>
  a78e8f:	48 89 c5             	mov    %rax,%rbp
  a78e92:	49 83 c7 10          	add    $0x10,%r15
  a78e96:	48 89 c7             	mov    %rax,%rdi
  a78e99:	4c 89 fe             	mov    %r15,%rsi
  a78e9c:	4c 89 ea             	mov    %r13,%rdx
  a78e9f:	ff 15 d3 ee aa 00    	call   *0xaaeed3(%rip)        # 1527d78 <memcpy@GLIBC_2.14>
  a78ea5:	eb 05                	jmp    a78eac <gpui::native::accessibility::projected_node+0x2bc>
  a78ea7:	bd 01 00 00 00       	mov    $0x1,%ebp
  a78eac:	4c 89 6c 24 38       	mov    %r13,0x38(%rsp)
  a78eb1:	48 89 6c 24 40       	mov    %rbp,0x40(%rsp)
  a78eb6:	4c 89 6c 24 48       	mov    %r13,0x48(%rsp)
  a78ebb:	c6 44 24 30 03       	movb   $0x3,0x30(%rsp)
  a78ec0:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  a78ec7:	00 
  a78ec8:	48 8d 54 24 30       	lea    0x30(%rsp),%rdx
  a78ecd:	be 11 00 00 00       	mov    $0x11,%esi
  a78ed2:	ff 15 08 02 ab 00    	call   *0xab0208(%rip)        # 15290e0 <_DYNAMIC+0x15c8>
  a78ed8:	4d 85 e4             	test   %r12,%r12
  a78edb:	0f 84 20 01 00 00    	je     a79001 <gpui::native::accessibility::projected_node+0x411>
  a78ee1:	49 8b 56 20          	mov    0x20(%r14),%rdx
  a78ee5:	49 8b 4c 24 40       	mov    0x40(%r12),%rcx
  a78eea:	48 85 c9             	test   %rcx,%rcx
  a78eed:	0f 84 e3 00 00 00    	je     a78fd6 <gpui::native::accessibility::projected_node+0x3e6>
  a78ef3:	49 8b 44 24 38       	mov    0x38(%r12),%rax
  a78ef8:	48 83 f9 01          	cmp    $0x1,%rcx
  a78efc:	75 17                	jne    a78f15 <gpui::native::accessibility::projected_node+0x325>
  a78efe:	48 39 10             	cmp    %rdx,(%rax)
  a78f01:	0f 85 cf 00 00 00    	jne    a78fd6 <gpui::native::accessibility::projected_node+0x3e6>
  a78f07:	4c 8b 78 08          	mov    0x8(%rax),%r15
  a78f0b:	4d 85 ff             	test   %r15,%r15
  a78f0e:	75 4e                	jne    a78f5e <gpui::native::accessibility::projected_node+0x36e>
  a78f10:	e9 c1 00 00 00       	jmp    a78fd6 <gpui::native::accessibility::projected_node+0x3e6>
  a78f15:	31 f6                	xor    %esi,%esi
  a78f17:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  a78f1e:	00 00 
  a78f20:	48 89 f7             	mov    %rsi,%rdi
  a78f23:	49 89 c8             	mov    %rcx,%r8
  a78f26:	49 d1 e8             	shr    $1,%r8
  a78f29:	4c 01 c6             	add    %r8,%rsi
  a78f2c:	49 89 f1             	mov    %rsi,%r9
  a78f2f:	49 c1 e1 04          	shl    $0x4,%r9
  a78f33:	4a 39 14 08          	cmp    %rdx,(%rax,%r9,1)
  a78f37:	48 0f 47 f7          	cmova  %rdi,%rsi
  a78f3b:	4c 29 c1             	sub    %r8,%rcx
  a78f3e:	48 83 f9 01          	cmp    $0x1,%rcx
  a78f42:	77 dc                	ja     a78f20 <gpui::native::accessibility::projected_node+0x330>
  a78f44:	48 c1 e6 04          	shl    $0x4,%rsi
  a78f48:	48 39 14 30          	cmp    %rdx,(%rax,%rsi,1)
  a78f4c:	0f 85 84 00 00 00    	jne    a78fd6 <gpui::native::accessibility::projected_node+0x3e6>
  a78f52:	48 01 f0             	add    %rsi,%rax
  a78f55:	4c 8b 78 08          	mov    0x8(%rax),%r15
  a78f59:	4d 85 ff             	test   %r15,%r15
  a78f5c:	74 78                	je     a78fd6 <gpui::native::accessibility::projected_node+0x3e6>
  a78f5e:	4d 8b 2f             	mov    (%r15),%r13
  a78f61:	49 d1 ed             	shr    $1,%r13
  a78f64:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
  a78f69:	74 35                	je     a78fa0 <gpui::native::accessibility::projected_node+0x3b0>
  a78f6b:	ff 15 e7 ed aa 00    	call   *0xaaede7(%rip)        # 1527d58 <_DYNAMIC+0x240>
  a78f71:	be 01 00 00 00       	mov    $0x1,%esi
  a78f76:	4c 89 ef             	mov    %r13,%rdi
  a78f79:	ff 15 e1 ed aa 00    	call   *0xaaede1(%rip)        # 1527d60 <_DYNAMIC+0x248>
  a78f7f:	48 85 c0             	test   %rax,%rax
  a78f82:	0f 84 ed 07 00 00    	je     a79775 <gpui::native::accessibility::projected_node+0xb85>
  a78f88:	48 89 c5             	mov    %rax,%rbp
  a78f8b:	49 83 c7 10          	add    $0x10,%r15
  a78f8f:	48 89 c7             	mov    %rax,%rdi
  a78f92:	4c 89 fe             	mov    %r15,%rsi
  a78f95:	4c 89 ea             	mov    %r13,%rdx
  a78f98:	ff 15 da ed aa 00    	call   *0xaaedda(%rip)        # 1527d78 <memcpy@GLIBC_2.14>
  a78f9e:	eb 05                	jmp    a78fa5 <gpui::native::accessibility::projected_node+0x3b5>
  a78fa0:	bd 01 00 00 00       	mov    $0x1,%ebp
  a78fa5:	4c 89 6c 24 38       	mov    %r13,0x38(%rsp)
  a78faa:	48 89 6c 24 40       	mov    %rbp,0x40(%rsp)
  a78faf:	4c 89 6c 24 48       	mov    %r13,0x48(%rsp)
  a78fb4:	c6 44 24 30 03       	movb   $0x3,0x30(%rsp)
  a78fb9:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  a78fc0:	00 
  a78fc1:	48 8d 54 24 30       	lea    0x30(%rsp),%rdx
  a78fc6:	be 10 00 00 00       	mov    $0x10,%esi
  a78fcb:	ff 15 0f 01 ab 00    	call   *0xab010f(%rip)        # 15290e0 <_DYNAMIC+0x15c8>
  a78fd1:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  a78fd6:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  a78fdb:	4c 89 e6             	mov    %r12,%rsi
  a78fde:	e8 cd 51 fd ff       	call   a4e1b0 <<gpui::runtime::scroll::ViewportColumn>::list>
  a78fe3:	83 7c 24 30 01       	cmpl   $0x1,0x30(%rsp)
  a78fe8:	75 17                	jne    a79001 <gpui::native::accessibility::projected_node+0x411>
  a78fea:	8b 54 24 40          	mov    0x40(%rsp),%edx
  a78fee:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  a78ff5:	00 
  a78ff6:	be 38 00 00 00       	mov    $0x38,%esi
  a78ffb:	ff 15 17 03 ab 00    	call   *0xab0317(%rip)        # 1529318 <_DYNAMIC+0x1800>
  a79001:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  a79006:	4c 89 f6             	mov    %r14,%rsi
  a79009:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  a7900e:	ff 15 ec 01 ab 00    	call   *0xab01ec(%rip)        # 1529200 <_DYNAMIC+0x16e8>
  a79014:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  a7901a:	74 17                	je     a79033 <gpui::native::accessibility::projected_node+0x443>
  a7901c:	8b 54 24 48          	mov    0x48(%rsp),%edx
  a79020:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  a79027:	00 
  a79028:	be 39 00 00 00       	mov    $0x39,%esi
  a7902d:	ff 15 e5 02 ab 00    	call   *0xab02e5(%rip)        # 1529318 <_DYNAMIC+0x1800>
  a79033:	f3 41 0f 10 6e 30    	movss  0x30(%r14),%xmm5
  a79039:	0f 2e ed             	ucomiss %xmm5,%xmm5
  a7903c:	0f 29 6c 24 10       	movaps %xmm5,0x10(%rsp)
  a79041:	0f 8a a3 00 00 00    	jp     a790ea <gpui::native::accessibility::projected_node+0x4fa>
  a79047:	f3 41 0f 10 46 34    	movss  0x34(%r14),%xmm0
  a7904d:	0f 28 cd             	movaps %xmm5,%xmm1
  a79050:	0f 14 c8             	unpcklps %xmm0,%xmm1
  a79053:	0f 5a c1             	cvtps2pd %xmm1,%xmm0
  a79056:	41 0f 5a 4e 38       	cvtps2pd 0x38(%r14),%xmm1
  a7905b:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  a79060:	66 0f 29 4c 24 40    	movapd %xmm1,0x40(%rsp)
  a79066:	41 0f 5a 46 40       	cvtps2pd 0x40(%r14),%xmm0
  a7906b:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  a79070:	c6 44 24 60 00       	movb   $0x0,0x60(%rsp)
  a79075:	66 41 0f 10 06       	movupd (%r14),%xmm0
  a7907a:	66 0f 29 84 24 50 01 	movapd %xmm0,0x150(%rsp)
  a79081:	00 00 
  a79083:	48 8d bc 24 3c 01 00 	lea    0x13c(%rsp),%rdi
  a7908a:	00 
  a7908b:	48 8d 74 24 30       	lea    0x30(%rsp),%rsi
  a79090:	48 8d 94 24 50 01 00 	lea    0x150(%rsp),%rdx
  a79097:	00 
  a79098:	ff 15 fa ed aa 00    	call   *0xaaedfa(%rip)        # 1527e98 <_DYNAMIC+0x380>
  a7909e:	83 bc 24 3c 01 00 00 	cmpl   $0x1,0x13c(%rsp)
  a790a5:	01 
  a790a6:	0f 28 6c 24 10       	movaps 0x10(%rsp),%xmm5
  a790ab:	75 3d                	jne    a790ea <gpui::native::accessibility::projected_node+0x4fa>
  a790ad:	0f 5a 84 24 40 01 00 	cvtps2pd 0x140(%rsp),%xmm0
  a790b4:	00 
  a790b5:	0f 5a 8c 24 48 01 00 	cvtps2pd 0x148(%rsp),%xmm1
  a790bc:	00 
  a790bd:	66 0f 58 c8          	addpd  %xmm0,%xmm1
  a790c1:	66 0f 29 44 24 30    	movapd %xmm0,0x30(%rsp)
  a790c7:	66 0f 29 4c 24 40    	movapd %xmm1,0x40(%rsp)
  a790cd:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  a790d4:	00 
  a790d5:	48 8d 54 24 30       	lea    0x30(%rsp),%rdx
  a790da:	be 53 00 00 00       	mov    $0x53,%esi
  a790df:	ff 15 3b 02 ab 00    	call   *0xab023b(%rip)        # 1529320 <_DYNAMIC+0x1808>
  a790e5:	0f 28 6c 24 10       	movaps 0x10(%rsp),%xmm5
  a790ea:	b8 4f 00 00 00       	mov    $0x4f,%eax
  a790ef:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  a790f4:	0f a3 c8             	bt     %ecx,%eax
  a790f7:	73 5a                	jae    a79153 <gpui::native::accessibility::projected_node+0x563>
  a790f9:	4d 85 e4             	test   %r12,%r12
  a790fc:	74 62                	je     a79160 <gpui::native::accessibility::projected_node+0x570>
  a790fe:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  a79103:	48 8b 48 30          	mov    0x30(%rax),%rcx
  a79107:	4c 8b 40 38          	mov    0x38(%rax),%r8
  a7910b:	49 8b 56 20          	mov    0x20(%r14),%rdx
  a7910f:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  a79114:	4c 89 e6             	mov    %r12,%rsi
  a79117:	e8 64 4e fd ff       	call   a4df80 <<gpui::runtime::scroll::ViewportColumn>::info>
  a7911c:	48 83 7c 24 30 02    	cmpq   $0x2,0x30(%rsp)
  a79122:	0f 95 c0             	setne  %al
  a79125:	74 3d                	je     a79164 <gpui::native::accessibility::projected_node+0x574>
  a79127:	f2 0f 10 44 24 38    	movsd  0x38(%rsp),%xmm0
  a7912d:	f2 44 0f 10 44 24 40 	movsd  0x40(%rsp),%xmm8
  a79134:	f2 0f 10 74 24 48    	movsd  0x48(%rsp),%xmm6
  a7913a:	f2 0f 10 5c 24 50    	movsd  0x50(%rsp),%xmm3
  a79140:	f2 0f 10 7c 24 58    	movsd  0x58(%rsp),%xmm7
  a79146:	f2 0f 10 64 24 60    	movsd  0x60(%rsp),%xmm4
  a7914c:	0f b6 6c 24 78       	movzbl 0x78(%rsp),%ebp
  a79151:	eb 11                	jmp    a79164 <gpui::native::accessibility::projected_node+0x574>
  a79153:	80 8c 24 21 01 00 00 	orb    $0x8,0x121(%rsp)
  a7915a:	08 
  a7915b:	4d 85 e4             	test   %r12,%r12
  a7915e:	75 9e                	jne    a790fe <gpui::native::accessibility::projected_node+0x50e>
  a79160:	31 c0                	xor    %eax,%eax
  a79162:	eb 05                	jmp    a79169 <gpui::native::accessibility::projected_node+0x579>
  a79164:	0f 28 6c 24 10       	movaps 0x10(%rsp),%xmm5
  a79169:	0f 2e ed             	ucomiss %xmm5,%xmm5
  a7916c:	0f 8a 4b 02 00 00    	jp     a793bd <gpui::native::accessibility::projected_node+0x7cd>
  a79172:	66 0f 57 c9          	xorpd  %xmm1,%xmm1
  a79176:	0f 2e e9             	ucomiss %xmm1,%xmm5
  a79179:	75 06                	jne    a79181 <gpui::native::accessibility::projected_node+0x591>
  a7917b:	0f 8b 3c 02 00 00    	jnp    a793bd <gpui::native::accessibility::projected_node+0x7cd>
  a79181:	f3 41 0f 10 56 38    	movss  0x38(%r14),%xmm2
  a79187:	0f 2e d1             	ucomiss %xmm1,%xmm2
  a7918a:	0f 85 2d 02 00 00    	jne    a793bd <gpui::native::accessibility::projected_node+0x7cd>
  a79190:	0f 8a 27 02 00 00    	jp     a793bd <gpui::native::accessibility::projected_node+0x7cd>
  a79196:	f3 41 0f 10 56 34    	movss  0x34(%r14),%xmm2
  a7919c:	0f 2e d1             	ucomiss %xmm1,%xmm2
  a7919f:	0f 85 18 02 00 00    	jne    a793bd <gpui::native::accessibility::projected_node+0x7cd>
  a791a5:	0f 8a 12 02 00 00    	jp     a793bd <gpui::native::accessibility::projected_node+0x7cd>
  a791ab:	f3 41 0f 10 56 3c    	movss  0x3c(%r14),%xmm2
  a791b1:	0f 2e d1             	ucomiss %xmm1,%xmm2
  a791b4:	75 06                	jne    a791bc <gpui::native::accessibility::projected_node+0x5cc>
  a791b6:	0f 8b 01 02 00 00    	jnp    a793bd <gpui::native::accessibility::projected_node+0x7cd>
  a791bc:	84 c0                	test   %al,%al
  a791be:	0f 84 f9 01 00 00    	je     a793bd <gpui::native::accessibility::projected_node+0x7cd>
  a791c4:	f3 0f 11 94 24 98 00 	movss  %xmm2,0x98(%rsp)
  a791cb:	00 00 
  a791cd:	f2 44 0f 11 84 24 30 	movsd  %xmm8,0x130(%rsp)
  a791d4:	01 00 00 
  a791d7:	f2 0f 11 7c 24 08    	movsd  %xmm7,0x8(%rsp)
  a791dd:	0f 29 74 24 20       	movaps %xmm6,0x20(%rsp)
  a791e2:	f2 0f 11 a4 24 a0 00 	movsd  %xmm4,0xa0(%rsp)
  a791e9:	00 00 
  a791eb:	66 0f 29 5c 24 10    	movapd %xmm3,0x10(%rsp)
  a791f1:	0f 57 c9             	xorps  %xmm1,%xmm1
  a791f4:	f3 0f 5a cd          	cvtss2sd %xmm5,%xmm1
  a791f8:	f2 0f 11 8c 24 28 01 	movsd  %xmm1,0x128(%rsp)
  a791ff:	00 00 
  a79201:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a79205:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  a7920c:	00 
  a7920d:	be 24 00 00 00       	mov    $0x24,%esi
  a79212:	ff 15 10 01 ab 00    	call   *0xab0110(%rip)        # 1529328 <_DYNAMIC+0x1810>
  a79218:	f3 0f 10 84 24 98 00 	movss  0x98(%rsp),%xmm0
  a7921f:	00 00 
  a79221:	0f 57 c9             	xorps  %xmm1,%xmm1
  a79224:	f3 0f 5a c8          	cvtss2sd %xmm0,%xmm1
  a79228:	f2 0f 10 84 24 30 01 	movsd  0x130(%rsp),%xmm0
  a7922f:	00 00 
  a79231:	f2 0f 11 8c 24 98 00 	movsd  %xmm1,0x98(%rsp)
  a79238:	00 00 
  a7923a:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a7923e:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  a79245:	00 
  a79246:	be 27 00 00 00       	mov    $0x27,%esi
  a7924b:	ff 15 d7 00 ab 00    	call   *0xab00d7(%rip)        # 1529328 <_DYNAMIC+0x1810>
  a79251:	66 0f 28 5c 24 20    	movapd 0x20(%rsp),%xmm3
  a79257:	f2 0f 10 8c 24 28 01 	movsd  0x128(%rsp),%xmm1
  a7925e:	00 00 
  a79260:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
  a79264:	f2 0f 10 44 24 08    	movsd  0x8(%rsp),%xmm0
  a7926a:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a7926e:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a79272:	f2 0f 11 44 24 08    	movsd  %xmm0,0x8(%rsp)
  a79278:	f2 0f 5d c8          	minsd  %xmm0,%xmm1
  a7927c:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a79280:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a79285:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a79289:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a7928d:	66 0f 29 5c 24 20    	movapd %xmm3,0x20(%rsp)
  a79293:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a79297:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a7929b:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  a792a2:	00 
  a792a3:	be 25 00 00 00       	mov    $0x25,%esi
  a792a8:	ff 15 7a 00 ab 00    	call   *0xab007a(%rip)        # 1529328 <_DYNAMIC+0x1810>
  a792ae:	66 0f 28 5c 24 20    	movapd 0x20(%rsp),%xmm3
  a792b4:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a792b8:	f2 0f 5f 4c 24 08    	maxsd  0x8(%rsp),%xmm1
  a792be:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a792c2:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a792c7:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a792cb:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a792cf:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a792d3:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a792d7:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  a792de:	00 
  a792df:	be 26 00 00 00       	mov    $0x26,%esi
  a792e4:	ff 15 3e 00 ab 00    	call   *0xab003e(%rip)        # 1529328 <_DYNAMIC+0x1810>
  a792ea:	66 0f 28 5c 24 10    	movapd 0x10(%rsp),%xmm3
  a792f0:	f2 0f 10 8c 24 98 00 	movsd  0x98(%rsp),%xmm1
  a792f7:	00 00 
  a792f9:	f2 0f 59 d9          	mulsd  %xmm1,%xmm3
  a792fd:	f2 0f 10 84 24 a0 00 	movsd  0xa0(%rsp),%xmm0
  a79304:	00 00 
  a79306:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
  a7930a:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a7930e:	f2 0f 11 84 24 a0 00 	movsd  %xmm0,0xa0(%rsp)
  a79315:	00 00 
  a79317:	f2 0f 5d c8          	minsd  %xmm0,%xmm1
  a7931b:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a7931f:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a79324:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a79328:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a7932c:	66 0f 29 5c 24 10    	movapd %xmm3,0x10(%rsp)
  a79332:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a79336:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a7933a:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  a79341:	00 
  a79342:	be 28 00 00 00       	mov    $0x28,%esi
  a79347:	ff 15 db ff aa 00    	call   *0xaaffdb(%rip)        # 1529328 <_DYNAMIC+0x1810>
  a7934d:	66 0f 28 5c 24 10    	movapd 0x10(%rsp),%xmm3
  a79353:	66 0f 28 cb          	movapd %xmm3,%xmm1
  a79357:	f2 0f 5f 8c 24 a0 00 	maxsd  0xa0(%rsp),%xmm1
  a7935e:	00 00 
  a79360:	66 0f 28 c1          	movapd %xmm1,%xmm0
  a79364:	f2 0f c2 c1 03       	cmpunordsd %xmm1,%xmm0
  a79369:	66 0f 28 d0          	movapd %xmm0,%xmm2
  a7936d:	66 0f 55 d1          	andnpd %xmm1,%xmm2
  a79371:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  a79375:	66 0f 56 c2          	orpd   %xmm2,%xmm0
  a79379:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  a79380:	00 
  a79381:	be 29 00 00 00       	mov    $0x29,%esi
  a79386:	ff 15 9c ff aa 00    	call   *0xaaff9c(%rip)        # 1529328 <_DYNAMIC+0x1810>
  a7938c:	40 f6 c5 01          	test   $0x1,%bpl
  a79390:	b9 00 00 02 00       	mov    $0x20000,%ecx
  a79395:	b8 00 30 02 00       	mov    $0x23000,%eax
  a7939a:	0f 44 c1             	cmove  %ecx,%eax
  a7939d:	0b 84 24 18 01 00 00 	or     0x118(%rsp),%eax
  a793a4:	89 84 24 18 01 00 00 	mov    %eax,0x118(%rsp)
  a793ab:	40 f6 c5 02          	test   $0x2,%bpl
  a793af:	74 0c                	je     a793bd <gpui::native::accessibility::projected_node+0x7cd>
  a793b1:	0d 00 48 00 00       	or     $0x4800,%eax
  a793b6:	89 84 24 18 01 00 00 	mov    %eax,0x118(%rsp)
  a793bd:	41 0f b6 46 4c       	movzbl 0x4c(%r14),%eax
  a793c2:	48 b9 01 02 04 08 10 	movabs $0x8040201008040201,%rcx
  a793c9:	20 40 80 
  a793cc:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  a793d1:	8b 8c 24 18 01 00 00 	mov    0x118(%rsp),%ecx
  a793d8:	31 ff                	xor    %edi,%edi
  a793da:	48 8d 15 ff d3 72 ff 	lea    -0x8d2c01(%rip),%rdx        # 1a67e0 <anon.7f631502f28dba8b34645de2728b692f.11.llvm.12156611386205377922+0x317>
  a793e1:	48 89 fe             	mov    %rdi,%rsi
  a793e4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  a793eb:	00 00 00 00 00 
  a793f0:	0f b6 7c 34 40       	movzbl 0x40(%rsp,%rsi,1),%edi
  a793f5:	40 84 c7             	test   %al,%dil
  a793f8:	75 16                	jne    a79410 <gpui::native::accessibility::projected_node+0x820>
  a793fa:	48 ff c6             	inc    %rsi
  a793fd:	48 83 fe 08          	cmp    $0x8,%rsi
  a79401:	75 ed                	jne    a793f0 <gpui::native::accessibility::projected_node+0x800>
  a79403:	eb 63                	jmp    a79468 <gpui::native::accessibility::projected_node+0x878>
  a79405:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  a7940c:	00 00 00 00 
  a79410:	40 0f b6 ff          	movzbl %dil,%edi
  a79414:	f3 0f bc ff          	tzcnt  %edi,%edi
  a79418:	4c 63 04 ba          	movslq (%rdx,%rdi,4),%r8
  a7941c:	49 01 d0             	add    %rdx,%r8
  a7941f:	41 ff e0             	jmp    *%r8
  a79422:	48 8d 7e 01          	lea    0x1(%rsi),%rdi
  a79426:	48 83 fe 07          	cmp    $0x7,%rsi
  a7942a:	75 b5                	jne    a793e1 <gpui::native::accessibility::projected_node+0x7f1>
  a7942c:	eb 3a                	jmp    a79468 <gpui::native::accessibility::projected_node+0x878>
  a7942e:	bf 01 00 00 00       	mov    $0x1,%edi
  a79433:	eb 1b                	jmp    a79450 <gpui::native::accessibility::projected_node+0x860>
  a79435:	bf 0f 00 00 00       	mov    $0xf,%edi
  a7943a:	eb 14                	jmp    a79450 <gpui::native::accessibility::projected_node+0x860>
  a7943c:	bf 02 00 00 00       	mov    $0x2,%edi
  a79441:	eb 0d                	jmp    a79450 <gpui::native::accessibility::projected_node+0x860>
  a79443:	bf 14 00 00 00       	mov    $0x14,%edi
  a79448:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a7944f:	00 
  a79450:	0f ab f9             	bts    %edi,%ecx
  a79453:	89 8c 24 18 01 00 00 	mov    %ecx,0x118(%rsp)
  a7945a:	48 8d 7e 01          	lea    0x1(%rsi),%rdi
  a7945e:	48 83 fe 07          	cmp    $0x7,%rsi
  a79462:	0f 85 79 ff ff ff    	jne    a793e1 <gpui::native::accessibility::projected_node+0x7f1>
  a79468:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  a7946f:	00 
  a79470:	0f 11 43 70          	movups %xmm0,0x70(%rbx)
  a79474:	0f 10 84 24 08 01 00 	movups 0x108(%rsp),%xmm0
  a7947b:	00 
  a7947c:	0f 11 43 60          	movups %xmm0,0x60(%rbx)
  a79480:	0f 10 84 24 f8 00 00 	movups 0xf8(%rsp),%xmm0
  a79487:	00 
  a79488:	0f 11 43 50          	movups %xmm0,0x50(%rbx)
  a7948c:	0f 10 84 24 e8 00 00 	movups 0xe8(%rsp),%xmm0
  a79493:	00 
  a79494:	0f 11 43 40          	movups %xmm0,0x40(%rbx)
  a79498:	0f 10 84 24 a8 00 00 	movups 0xa8(%rsp),%xmm0
  a7949f:	00 
  a794a0:	0f 10 8c 24 b8 00 00 	movups 0xb8(%rsp),%xmm1
  a794a7:	00 
  a794a8:	0f 10 94 24 c8 00 00 	movups 0xc8(%rsp),%xmm2
  a794af:	00 
  a794b0:	0f 10 9c 24 d8 00 00 	movups 0xd8(%rsp),%xmm3
  a794b7:	00 
  a794b8:	0f 11 5b 30          	movups %xmm3,0x30(%rbx)
  a794bc:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  a794c0:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  a794c4:	0f 11 03             	movups %xmm0,(%rbx)
  a794c7:	48 89 d8             	mov    %rbx,%rax
  a794ca:	48 81 c4 68 01 00 00 	add    $0x168,%rsp
  a794d1:	5b                   	pop    %rbx
  a794d2:	41 5c                	pop    %r12
  a794d4:	41 5d                	pop    %r13
  a794d6:	41 5e                	pop    %r14
  a794d8:	41 5f                	pop    %r15
  a794da:	5d                   	pop    %rbp
  a794db:	c3                   	ret
  a794dc:	31 f6                	xor    %esi,%esi
  a794de:	66 90                	xchg   %ax,%ax
  a794e0:	48 89 f7             	mov    %rsi,%rdi
  a794e3:	49 89 c8             	mov    %rcx,%r8
  a794e6:	49 d1 e8             	shr    $1,%r8
  a794e9:	4c 01 c6             	add    %r8,%rsi
  a794ec:	49 89 f1             	mov    %rsi,%r9
  a794ef:	49 c1 e1 04          	shl    $0x4,%r9
  a794f3:	4a 39 14 08          	cmp    %rdx,(%rax,%r9,1)
  a794f7:	48 0f 47 f7          	cmova  %rdi,%rsi
  a794fb:	4c 29 c1             	sub    %r8,%rcx
  a794fe:	48 83 f9 01          	cmp    $0x1,%rcx
  a79502:	77 dc                	ja     a794e0 <gpui::native::accessibility::projected_node+0x8f0>
  a79504:	48 c1 e6 04          	shl    $0x4,%rsi
  a79508:	48 39 14 30          	cmp    %rdx,(%rax,%rsi,1)
  a7950c:	75 09                	jne    a79517 <gpui::native::accessibility::projected_node+0x927>
  a7950e:	48 01 f0             	add    %rsi,%rax
  a79511:	48 8b 78 08          	mov    0x8(%rax),%rdi
  a79515:	eb 04                	jmp    a7951b <gpui::native::accessibility::projected_node+0x92b>
  a79517:	49 8b 7e 28          	mov    0x28(%r14),%rdi
  a7951b:	48 85 ff             	test   %rdi,%rdi
  a7951e:	74 43                	je     a79563 <gpui::native::accessibility::projected_node+0x973>
  a79520:	48 8b 17             	mov    (%rdi),%rdx
  a79523:	48 d1 ea             	shr    $1,%rdx
  a79526:	48 83 c7 10          	add    $0x10,%rdi
  a7952a:	4d 8b 6e 28          	mov    0x28(%r14),%r13
  a7952e:	40 b5 4e             	mov    $0x4e,%bpl
  a79531:	4d 85 ed             	test   %r13,%r13
  a79534:	74 3b                	je     a79571 <gpui::native::accessibility::projected_node+0x981>
  a79536:	48 85 ff             	test   %rdi,%rdi
  a79539:	0f 84 9e f7 ff ff    	je     a78cdd <gpui::native::accessibility::projected_node+0xed>
  a7953f:	49 8b 45 00          	mov    0x0(%r13),%rax
  a79543:	48 d1 e8             	shr    $1,%rax
  a79546:	48 39 c2             	cmp    %rax,%rdx
  a79549:	0f 85 8e f7 ff ff    	jne    a78cdd <gpui::native::accessibility::projected_node+0xed>
  a7954f:	49 8d 75 10          	lea    0x10(%r13),%rsi
  a79553:	ff 15 df e9 aa 00    	call   *0xaae9df(%rip)        # 1527f38 <bcmp@GLIBC_2.2.5>
  a79559:	85 c0                	test   %eax,%eax
  a7955b:	0f 85 7c f7 ff ff    	jne    a78cdd <gpui::native::accessibility::projected_node+0xed>
  a79561:	eb 17                	jmp    a7957a <gpui::native::accessibility::projected_node+0x98a>
  a79563:	31 ff                	xor    %edi,%edi
  a79565:	4d 8b 6e 28          	mov    0x28(%r14),%r13
  a79569:	40 b5 4e             	mov    $0x4e,%bpl
  a7956c:	4d 85 ed             	test   %r13,%r13
  a7956f:	75 c5                	jne    a79536 <gpui::native::accessibility::projected_node+0x946>
  a79571:	48 85 ff             	test   %rdi,%rdi
  a79574:	0f 85 63 f7 ff ff    	jne    a78cdd <gpui::native::accessibility::projected_node+0xed>
  a7957a:	c6 84 24 24 01 00 00 	movb   $0x3,0x124(%rsp)
  a79581:	03 
  a79582:	48 c7 84 24 18 01 00 	movq   $0x0,0x118(%rsp)
  a79589:	00 00 00 00 00 
  a7958e:	c7 84 24 20 01 00 00 	movl   $0x0,0x120(%rsp)
  a79595:	00 00 00 00 
  a79599:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  a795a0:	00 00 00 00 00 
  a795a5:	48 c7 84 24 b0 00 00 	movq   $0x8,0xb0(%rsp)
  a795ac:	00 08 00 00 00 
  a795b1:	48 c7 84 24 b8 00 00 	movq   $0x0,0xb8(%rsp)
  a795b8:	00 00 00 00 00 
  a795bd:	66 0f 28 05 eb 2c 71 	movapd -0x8ed315(%rip),%xmm0        # 18c2b0 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a795c4:	ff 
  a795c5:	66 0f 11 84 24 c0 00 	movupd %xmm0,0xc0(%rsp)
  a795cc:	00 00 
  a795ce:	66 0f 11 84 24 d0 00 	movupd %xmm0,0xd0(%rsp)
  a795d5:	00 00 
  a795d7:	66 0f 11 84 24 e0 00 	movupd %xmm0,0xe0(%rsp)
  a795de:	00 00 
  a795e0:	66 0f 11 84 24 f0 00 	movupd %xmm0,0xf0(%rsp)
  a795e7:	00 00 
  a795e9:	66 0f 11 84 24 00 01 	movupd %xmm0,0x100(%rsp)
  a795f0:	00 00 
  a795f2:	4c 89 bc 24 0f 01 00 	mov    %r15,0x10f(%rsp)
  a795f9:	00 
  a795fa:	4d 85 ed             	test   %r13,%r13
  a795fd:	0f 84 d5 f8 ff ff    	je     a78ed8 <gpui::native::accessibility::projected_node+0x2e8>
  a79603:	49 8b 75 00          	mov    0x0(%r13),%rsi
  a79607:	48 d1 ee             	shr    $1,%rsi
  a7960a:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  a7960f:	b9 01 00 00 00       	mov    $0x1,%ecx
  a79614:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  a7961a:	48 89 f5             	mov    %rsi,%rbp
  a7961d:	31 d2                	xor    %edx,%edx
  a7961f:	e8 9c 01 fe ff       	call   a597c0 <<alloc::raw_vec::RawVecInner>::try_allocate_in>
  a79624:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
  a79629:	80 7c 24 30 00       	cmpb   $0x0,0x30(%rsp)
  a7962e:	0f 85 31 01 00 00    	jne    a79765 <gpui::native::accessibility::projected_node+0xb75>
  a79634:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
  a79639:	48 89 e8             	mov    %rbp,%rax
  a7963c:	48 85 ed             	test   %rbp,%rbp
  a7963f:	74 20                	je     a79661 <gpui::native::accessibility::projected_node+0xa71>
  a79641:	49 83 c5 10          	add    $0x10,%r13
  a79645:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  a7964a:	4c 89 ff             	mov    %r15,%rdi
  a7964d:	4c 89 ee             	mov    %r13,%rsi
  a79650:	48 89 ea             	mov    %rbp,%rdx
  a79653:	ff 15 1f e7 aa 00    	call   *0xaae71f(%rip)        # 1527d78 <memcpy@GLIBC_2.14>
  a79659:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  a7965e:	48 89 e8             	mov    %rbp,%rax
  a79661:	48 89 7c 24 38       	mov    %rdi,0x38(%rsp)
  a79666:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
  a7966b:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  a79670:	c6 44 24 30 03       	movb   $0x3,0x30(%rsp)
  a79675:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  a7967c:	00 
  a7967d:	48 8d 54 24 30       	lea    0x30(%rsp),%rdx
  a79682:	be 11 00 00 00       	mov    $0x11,%esi
  a79687:	ff 15 53 fa aa 00    	call   *0xaafa53(%rip)        # 15290e0 <_DYNAMIC+0x15c8>
  a7968d:	e9 46 f8 ff ff       	jmp    a78ed8 <gpui::native::accessibility::projected_node+0x2e8>
  a79692:	49 83 7e 28 00       	cmpq   $0x0,0x28(%r14)
  a79697:	40 0f 95 c5          	setne  %bpl
  a7969b:	40 c0 e5 06          	shl    $0x6,%bpl
  a7969f:	40 80 cd 0e          	or     $0xe,%bpl
  a796a3:	e9 35 f6 ff ff       	jmp    a78cdd <gpui::native::accessibility::projected_node+0xed>
  a796a8:	31 ff                	xor    %edi,%edi
  a796aa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  a796b0:	49 89 f8             	mov    %rdi,%r8
  a796b3:	49 89 f1             	mov    %rsi,%r9
  a796b6:	49 d1 e9             	shr    $1,%r9
  a796b9:	4c 01 cf             	add    %r9,%rdi
  a796bc:	49 89 fa             	mov    %rdi,%r10
  a796bf:	49 c1 e2 04          	shl    $0x4,%r10
  a796c3:	4a 39 04 12          	cmp    %rax,(%rdx,%r10,1)
  a796c7:	49 0f 47 f8          	cmova  %r8,%rdi
  a796cb:	4c 29 ce             	sub    %r9,%rsi
  a796ce:	48 83 fe 01          	cmp    $0x1,%rsi
  a796d2:	77 dc                	ja     a796b0 <gpui::native::accessibility::projected_node+0xac0>
  a796d4:	48 c1 e7 04          	shl    $0x4,%rdi
  a796d8:	48 39 04 3a          	cmp    %rax,(%rdx,%rdi,1)
  a796dc:	75 13                	jne    a796f1 <gpui::native::accessibility::projected_node+0xb01>
  a796de:	48 01 fa             	add    %rdi,%rdx
  a796e1:	40 b5 4e             	mov    $0x4e,%bpl
  a796e4:	48 83 7a 08 00       	cmpq   $0x0,0x8(%rdx)
  a796e9:	0f 85 ee f5 ff ff    	jne    a78cdd <gpui::native::accessibility::projected_node+0xed>
  a796ef:	eb 0e                	jmp    a796ff <gpui::native::accessibility::projected_node+0xb0f>
  a796f1:	40 b5 4e             	mov    $0x4e,%bpl
  a796f4:	49 83 7e 28 00       	cmpq   $0x0,0x28(%r14)
  a796f9:	0f 85 de f5 ff ff    	jne    a78cdd <gpui::native::accessibility::projected_node+0xed>
  a796ff:	48 8b 51 40          	mov    0x40(%rcx),%rdx
  a79703:	40 b5 0e             	mov    $0xe,%bpl
  a79706:	48 85 d2             	test   %rdx,%rdx
  a79709:	0f 84 ce f5 ff ff    	je     a78cdd <gpui::native::accessibility::projected_node+0xed>
  a7970f:	48 8b 49 38          	mov    0x38(%rcx),%rcx
  a79713:	48 83 fa 01          	cmp    $0x1,%rdx
  a79717:	75 0b                	jne    a79724 <gpui::native::accessibility::projected_node+0xb34>
  a79719:	48 39 01             	cmp    %rax,(%rcx)
  a7971c:	0f 85 bb f5 ff ff    	jne    a78cdd <gpui::native::accessibility::projected_node+0xed>
  a79722:	eb 37                	jmp    a7975b <gpui::native::accessibility::projected_node+0xb6b>
  a79724:	31 f6                	xor    %esi,%esi
  a79726:	48 89 f7             	mov    %rsi,%rdi
  a79729:	49 89 d0             	mov    %rdx,%r8
  a7972c:	49 d1 e8             	shr    $1,%r8
  a7972f:	4c 01 c6             	add    %r8,%rsi
  a79732:	49 89 f1             	mov    %rsi,%r9
  a79735:	49 c1 e1 04          	shl    $0x4,%r9
  a79739:	4a 39 04 09          	cmp    %rax,(%rcx,%r9,1)
  a7973d:	48 0f 47 f7          	cmova  %rdi,%rsi
  a79741:	4c 29 c2             	sub    %r8,%rdx
  a79744:	48 83 fa 01          	cmp    $0x1,%rdx
  a79748:	77 dc                	ja     a79726 <gpui::native::accessibility::projected_node+0xb36>
  a7974a:	48 c1 e6 04          	shl    $0x4,%rsi
  a7974e:	48 39 04 31          	cmp    %rax,(%rcx,%rsi,1)
  a79752:	0f 85 85 f5 ff ff    	jne    a78cdd <gpui::native::accessibility::projected_node+0xed>
  a79758:	48 01 f1             	add    %rsi,%rcx
  a7975b:	48 83 79 08 00       	cmpq   $0x0,0x8(%rcx)
  a79760:	e9 32 ff ff ff       	jmp    a79697 <gpui::native::accessibility::projected_node+0xaa7>
  a79765:	4c 8b 6c 24 40       	mov    0x40(%rsp),%r13
  a7976a:	4c 89 ee             	mov    %r13,%rsi
  a7976d:	ff 15 d5 e6 aa 00    	call   *0xaae6d5(%rip)        # 1527e48 <_DYNAMIC+0x330>
  a79773:	0f 0b                	ud2
  a79775:	bf 01 00 00 00       	mov    $0x1,%edi
  a7977a:	eb ee                	jmp    a7976a <gpui::native::accessibility::projected_node+0xb7a>
  a7977c:	48 89 c3             	mov    %rax,%rbx
  a7977f:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  a79786:	00 
  a79787:	e8 14 d5 ff ff       	call   a76ca0 <core::ptr::drop_glue::<accesskit::Node>>
  a7978c:	48 89 df             	mov    %rbx,%rdi
  a7978f:	e8 ac 90 a3 00       	call   14b2840 <_Unwind_Resume@plt>
  a79794:	ff 15 06 e6 aa 00    	call   *0xaae606(%rip)        # 1527da0 <_DYNAMIC+0x288>
