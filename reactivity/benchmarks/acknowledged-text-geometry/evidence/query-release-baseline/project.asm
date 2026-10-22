
/tmp/gpui-acknowledged-text-evidence/query-release-baseline/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a79a70 <gpui::native::accessibility::project>:
  a79a70:	55                   	push   %rbp
  a79a71:	41 57                	push   %r15
  a79a73:	41 56                	push   %r14
  a79a75:	41 55                	push   %r13
  a79a77:	41 54                	push   %r12
  a79a79:	53                   	push   %rbx
  a79a7a:	48 81 ec 58 01 00 00 	sub    $0x158,%rsp
  a79a81:	48 b8 57 57 57 57 57 	movabs $0x5757575757575757,%rax
  a79a88:	57 57 57 
  a79a8b:	48 89 84 24 3f 01 00 	mov    %rax,0x13f(%rsp)
  a79a92:	00 
  a79a93:	66 0f 28 05 15 28 71 	movapd -0x8ed7eb(%rip),%xmm0        # 18c2b0 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a79a9a:	ff 
  a79a9b:	66 0f 11 84 24 30 01 	movupd %xmm0,0x130(%rsp)
  a79aa2:	00 00 
  a79aa4:	66 0f 11 84 24 20 01 	movupd %xmm0,0x120(%rsp)
  a79aab:	00 00 
  a79aad:	66 0f 11 84 24 10 01 	movupd %xmm0,0x110(%rsp)
  a79ab4:	00 00 
  a79ab6:	66 0f 11 84 24 00 01 	movupd %xmm0,0x100(%rsp)
  a79abd:	00 00 
  a79abf:	66 0f 11 84 24 f0 00 	movupd %xmm0,0xf0(%rsp)
  a79ac6:	00 00 
  a79ac8:	c6 84 24 54 01 00 00 	movb   $0x85,0x154(%rsp)
  a79acf:	85 
  a79ad0:	48 c7 84 24 48 01 00 	movq   $0x0,0x148(%rsp)
  a79ad7:	00 00 00 00 00 
  a79adc:	c7 84 24 50 01 00 00 	movl   $0x0,0x150(%rsp)
  a79ae3:	00 00 00 00 
  a79ae7:	48 c7 84 24 d8 00 00 	movq   $0x0,0xd8(%rsp)
  a79aee:	00 00 00 00 00 
  a79af3:	48 c7 84 24 e0 00 00 	movq   $0x8,0xe0(%rsp)
  a79afa:	00 08 00 00 00 
  a79aff:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  a79b06:	00 00 00 00 00 
  a79b0b:	4d 85 c0             	test   %r8,%r8
  a79b0e:	0f 88 10 01 00 00    	js     a79c24 <gpui::native::accessibility::project+0x1b4>
  a79b14:	4c 89 cb             	mov    %r9,%rbx
  a79b17:	4d 89 c4             	mov    %r8,%r12
  a79b1a:	49 89 d5             	mov    %rdx,%r13
  a79b1d:	48 89 f5             	mov    %rsi,%rbp
  a79b20:	48 89 bc 24 d0 00 00 	mov    %rdi,0xd0(%rsp)
  a79b27:	00 
  a79b28:	74 4f                	je     a79b79 <gpui::native::accessibility::project+0x109>
  a79b2a:	48 89 9c 24 c8 00 00 	mov    %rbx,0xc8(%rsp)
  a79b31:	00 
  a79b32:	48 89 eb             	mov    %rbp,%rbx
  a79b35:	49 89 ce             	mov    %rcx,%r14
  a79b38:	ff 15 1a e2 aa 00    	call   *0xaae21a(%rip)        # 1527d58 <_DYNAMIC+0x240>
  a79b3e:	bd 01 00 00 00       	mov    $0x1,%ebp
  a79b43:	be 01 00 00 00       	mov    $0x1,%esi
  a79b48:	4c 89 e7             	mov    %r12,%rdi
  a79b4b:	ff 15 0f e2 aa 00    	call   *0xaae20f(%rip)        # 1527d60 <_DYNAMIC+0x248>
  a79b51:	48 85 c0             	test   %rax,%rax
  a79b54:	0f 84 cc 00 00 00    	je     a79c26 <gpui::native::accessibility::project+0x1b6>
  a79b5a:	49 89 c7             	mov    %rax,%r15
  a79b5d:	48 89 c7             	mov    %rax,%rdi
  a79b60:	4c 89 f6             	mov    %r14,%rsi
  a79b63:	4c 89 e2             	mov    %r12,%rdx
  a79b66:	ff 15 0c e2 aa 00    	call   *0xaae20c(%rip)        # 1527d78 <memcpy@GLIBC_2.14>
  a79b6c:	48 89 dd             	mov    %rbx,%rbp
  a79b6f:	48 8b 9c 24 c8 00 00 	mov    0xc8(%rsp),%rbx
  a79b76:	00 
  a79b77:	eb 06                	jmp    a79b7f <gpui::native::accessibility::project+0x10f>
  a79b79:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  a79b7f:	4c 89 64 24 48       	mov    %r12,0x48(%rsp)
  a79b84:	4c 89 7c 24 50       	mov    %r15,0x50(%rsp)
  a79b89:	4c 89 64 24 58       	mov    %r12,0x58(%rsp)
  a79b8e:	c6 44 24 40 03       	movb   $0x3,0x40(%rsp)
  a79b93:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a79b9a:	00 
  a79b9b:	48 8d 54 24 40       	lea    0x40(%rsp),%rdx
  a79ba0:	be 0f 00 00 00       	mov    $0xf,%esi
  a79ba5:	ff 15 35 f5 aa 00    	call   *0xaaf535(%rip)        # 15290e0 <_DYNAMIC+0x15c8>
  a79bab:	80 8c 24 51 01 00 00 	orb    $0x8,0x151(%rsp)
  a79bb2:	08 
  a79bb3:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
  a79bb7:	66 0f 29 44 24 40    	movapd %xmm0,0x40(%rsp)
  a79bbd:	f2 41 0f 10 4d 28    	movsd  0x28(%r13),%xmm1
  a79bc3:	0f 14 c8             	unpcklps %xmm0,%xmm1
  a79bc6:	66 0f 28 05 62 47 71 	movapd -0x8eb89e(%rip),%xmm0        # 18e330 <anon.05933fb6bb17d4b782622fe161e9f81c.309.llvm.18391229140309290632+0x8a0>
  a79bcd:	ff 
  a79bce:	66 0f 56 c8          	orpd   %xmm0,%xmm1
  a79bd2:	66 0f 5c c8          	subpd  %xmm0,%xmm1
  a79bd6:	66 0f 29 4c 24 50    	movapd %xmm1,0x50(%rsp)
  a79bdc:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a79be3:	00 
  a79be4:	48 8d 54 24 40       	lea    0x40(%rsp),%rdx
  a79be9:	be 53 00 00 00       	mov    $0x53,%esi
  a79bee:	ff 15 2c f7 aa 00    	call   *0xaaf72c(%rip)        # 1529320 <_DYNAMIC+0x1808>
  a79bf4:	48 8b 45 38          	mov    0x38(%rbp),%rax
  a79bf8:	48 ff c0             	inc    %rax
  a79bfb:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  a79c00:	48 8d 74 24 18       	lea    0x18(%rsp),%rsi
  a79c05:	48 89 ef             	mov    %rbp,%rdi
  a79c08:	48 89 da             	mov    %rbx,%rdx
  a79c0b:	e8 d0 18 fe ff       	call   a5b4e0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#0}>>
  a79c10:	4c 8b 74 24 18       	mov    0x18(%rsp),%r14
  a79c15:	48 b8 f0 f0 f0 f0 f0 	movabs $0xf0f0f0f0f0f0f0,%rax
  a79c1c:	f0 f0 00 
  a79c1f:	49 39 c6             	cmp    %rax,%r14
  a79c22:	76 13                	jbe    a79c37 <gpui::native::accessibility::project+0x1c7>
  a79c24:	31 ed                	xor    %ebp,%ebp
  a79c26:	48 89 ef             	mov    %rbp,%rdi
  a79c29:	4c 89 e6             	mov    %r12,%rsi
  a79c2c:	ff 15 16 e2 aa 00    	call   *0xaae216(%rip)        # 1527e48 <_DYNAMIC+0x330>
  a79c32:	e9 9e 02 00 00       	jmp    a79ed5 <gpui::native::accessibility::project+0x465>
  a79c37:	4c 89 f0             	mov    %r14,%rax
  a79c3a:	48 c1 e0 07          	shl    $0x7,%rax
  a79c3e:	4e 8d 24 f0          	lea    (%rax,%r14,8),%r12
  a79c42:	4d 85 e4             	test   %r12,%r12
  a79c45:	74 2f                	je     a79c76 <gpui::native::accessibility::project+0x206>
  a79c47:	49 89 df             	mov    %rbx,%r15
  a79c4a:	48 89 eb             	mov    %rbp,%rbx
  a79c4d:	ff 15 05 e1 aa 00    	call   *0xaae105(%rip)        # 1527d58 <_DYNAMIC+0x240>
  a79c53:	bd 08 00 00 00       	mov    $0x8,%ebp
  a79c58:	be 08 00 00 00       	mov    $0x8,%esi
  a79c5d:	4c 89 e7             	mov    %r12,%rdi
  a79c60:	ff 15 fa e0 aa 00    	call   *0xaae0fa(%rip)        # 1527d60 <_DYNAMIC+0x248>
  a79c66:	48 85 c0             	test   %rax,%rax
  a79c69:	74 bb                	je     a79c26 <gpui::native::accessibility::project+0x1b6>
  a79c6b:	48 89 c7             	mov    %rax,%rdi
  a79c6e:	48 89 dd             	mov    %rbx,%rbp
  a79c71:	4c 89 fb             	mov    %r15,%rbx
  a79c74:	eb 08                	jmp    a79c7e <gpui::native::accessibility::project+0x20e>
  a79c76:	bf 08 00 00 00       	mov    $0x8,%edi
  a79c7b:	45 31 f6             	xor    %r14d,%r14d
  a79c7e:	4c 89 34 24          	mov    %r14,(%rsp)
  a79c82:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  a79c87:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
  a79c8e:	00 00 
  a79c90:	0f 10 84 24 48 01 00 	movups 0x148(%rsp),%xmm0
  a79c97:	00 
  a79c98:	0f 11 84 24 b8 00 00 	movups %xmm0,0xb8(%rsp)
  a79c9f:	00 
  a79ca0:	0f 10 84 24 38 01 00 	movups 0x138(%rsp),%xmm0
  a79ca7:	00 
  a79ca8:	0f 11 84 24 a8 00 00 	movups %xmm0,0xa8(%rsp)
  a79caf:	00 
  a79cb0:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  a79cb7:	00 
  a79cb8:	0f 11 84 24 98 00 00 	movups %xmm0,0x98(%rsp)
  a79cbf:	00 
  a79cc0:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  a79cc7:	00 
  a79cc8:	0f 11 84 24 88 00 00 	movups %xmm0,0x88(%rsp)
  a79ccf:	00 
  a79cd0:	66 0f 10 84 24 d8 00 	movupd 0xd8(%rsp),%xmm0
  a79cd7:	00 00 
  a79cd9:	66 0f 10 8c 24 e8 00 	movupd 0xe8(%rsp),%xmm1
  a79ce0:	00 00 
  a79ce2:	0f 10 94 24 f8 00 00 	movups 0xf8(%rsp),%xmm2
  a79ce9:	00 
  a79cea:	0f 10 9c 24 08 01 00 	movups 0x108(%rsp),%xmm3
  a79cf1:	00 
  a79cf2:	0f 11 5c 24 78       	movups %xmm3,0x78(%rsp)
  a79cf7:	0f 11 54 24 68       	movups %xmm2,0x68(%rsp)
  a79cfc:	66 0f 11 4c 24 58    	movupd %xmm1,0x58(%rsp)
  a79d02:	66 0f 11 44 24 48    	movupd %xmm0,0x48(%rsp)
  a79d08:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  a79d0f:	00 00 
  a79d11:	4d 85 f6             	test   %r14,%r14
  a79d14:	75 0e                	jne    a79d24 <gpui::native::accessibility::project+0x2b4>
  a79d16:	48 89 e7             	mov    %rsp,%rdi
  a79d19:	ff 15 89 f4 aa 00    	call   *0xaaf489(%rip)        # 15291a8 <_DYNAMIC+0x1690>
  a79d1f:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  a79d24:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  a79d29:	ba 88 00 00 00       	mov    $0x88,%edx
  a79d2e:	ff 15 44 e0 aa 00    	call   *0xaae044(%rip)        # 1527d78 <memcpy@GLIBC_2.14>
  a79d34:	48 c7 44 24 10 01 00 	movq   $0x1,0x10(%rsp)
  a79d3b:	00 00 
  a79d3d:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  a79d44:	00 00 
  a79d46:	48 c7 44 24 30 08 00 	movq   $0x8,0x30(%rsp)
  a79d4d:	00 00 
  a79d4f:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  a79d56:	00 00 
  a79d58:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  a79d5f:	00 00 
  a79d61:	48 8d 44 24 28       	lea    0x28(%rsp),%rax
  a79d66:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  a79d6b:	48 89 5c 24 48       	mov    %rbx,0x48(%rsp)
  a79d70:	48 89 e0             	mov    %rsp,%rax
  a79d73:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  a79d78:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  a79d7d:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  a79d82:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  a79d87:	48 89 ef             	mov    %rbp,%rdi
  a79d8a:	e8 a1 18 fe ff       	call   a5b630 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>>
  a79d8f:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  a79d96:	00 00 
  a79d98:	48 c7 44 24 40 ff ff 	movq   $0xffffffffffffffff,0x40(%rsp)
  a79d9f:	ff ff 
  a79da1:	48 c7 44 24 58 ff ff 	movq   $0xffffffffffffffff,0x58(%rsp)
  a79da8:	ff ff 
  a79daa:	ff 15 a8 df aa 00    	call   *0xaadfa8(%rip)        # 1527d58 <_DYNAMIC+0x240>
  a79db0:	41 be 04 00 00 00    	mov    $0x4,%r14d
  a79db6:	bf 04 00 00 00       	mov    $0x4,%edi
  a79dbb:	be 01 00 00 00       	mov    $0x1,%esi
  a79dc0:	ff 15 9a df aa 00    	call   *0xaadf9a(%rip)        # 1527d60 <_DYNAMIC+0x248>
  a79dc6:	48 85 c0             	test   %rax,%rax
  a79dc9:	0f 84 f8 00 00 00    	je     a79ec7 <gpui::native::accessibility::project+0x457>
  a79dcf:	c7 00 47 50 55 49    	movl   $0x49555047,(%rax)
  a79dd5:	48 c7 44 24 40 04 00 	movq   $0x4,0x40(%rsp)
  a79ddc:	00 00 
  a79dde:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  a79de3:	48 c7 44 24 50 04 00 	movq   $0x4,0x50(%rsp)
  a79dea:	00 00 
  a79dec:	ff 15 66 df aa 00    	call   *0xaadf66(%rip)        # 1527d58 <_DYNAMIC+0x240>
  a79df2:	41 be 05 00 00 00    	mov    $0x5,%r14d
  a79df8:	bf 05 00 00 00       	mov    $0x5,%edi
  a79dfd:	be 01 00 00 00       	mov    $0x1,%esi
  a79e02:	ff 15 58 df aa 00    	call   *0xaadf58(%rip)        # 1527d60 <_DYNAMIC+0x248>
  a79e08:	48 85 c0             	test   %rax,%rax
  a79e0b:	0f 84 b6 00 00 00    	je     a79ec7 <gpui::native::accessibility::project+0x457>
  a79e11:	c6 40 04 30          	movb   $0x30,0x4(%rax)
  a79e15:	c7 00 30 2e 31 2e    	movl   $0x2e312e30,(%rax)
  a79e1b:	48 c7 44 24 58 05 00 	movq   $0x5,0x58(%rsp)
  a79e22:	00 00 
  a79e24:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  a79e29:	48 c7 44 24 68 05 00 	movq   $0x5,0x68(%rsp)
  a79e30:	00 00 
  a79e32:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  a79e37:	48 8b 9c 24 d0 00 00 	mov    0xd0(%rsp),%rbx
  a79e3e:	00 
  a79e3f:	48 89 43 10          	mov    %rax,0x10(%rbx)
  a79e43:	0f 10 04 24          	movups (%rsp),%xmm0
  a79e47:	0f 11 03             	movups %xmm0,(%rbx)
  a79e4a:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  a79e4f:	48 89 43 48          	mov    %rax,0x48(%rbx)
  a79e53:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  a79e58:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  a79e5d:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  a79e62:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  a79e67:	48 89 53 38          	mov    %rdx,0x38(%rbx)
  a79e6b:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  a79e70:	48 89 53 40          	mov    %rdx,0x40(%rbx)
  a79e74:	48 89 43 28          	mov    %rax,0x28(%rbx)
  a79e78:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  a79e7c:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  a79e80:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  a79e85:	0f 57 c0             	xorps  %xmm0,%xmm0
  a79e88:	0f 11 43 50          	movups %xmm0,0x50(%rbx)
  a79e8c:	48 89 43 60          	mov    %rax,0x60(%rbx)
  a79e90:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  a79e95:	48 85 c0             	test   %rax,%rax
  a79e98:	74 18                	je     a79eb2 <gpui::native::accessibility::project+0x442>
  a79e9a:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  a79e9f:	48 c1 e0 03          	shl    $0x3,%rax
  a79ea3:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  a79ea7:	ba 08 00 00 00       	mov    $0x8,%edx
  a79eac:	ff 15 b6 de aa 00    	call   *0xaadeb6(%rip)        # 1527d68 <_DYNAMIC+0x250>
  a79eb2:	48 89 d8             	mov    %rbx,%rax
  a79eb5:	48 81 c4 58 01 00 00 	add    $0x158,%rsp
  a79ebc:	5b                   	pop    %rbx
  a79ebd:	41 5c                	pop    %r12
  a79ebf:	41 5d                	pop    %r13
  a79ec1:	41 5e                	pop    %r14
  a79ec3:	41 5f                	pop    %r15
  a79ec5:	5d                   	pop    %rbp
  a79ec6:	c3                   	ret
  a79ec7:	bf 01 00 00 00       	mov    $0x1,%edi
  a79ecc:	4c 89 f6             	mov    %r14,%rsi
  a79ecf:	ff 15 73 df aa 00    	call   *0xaadf73(%rip)        # 1527e48 <_DYNAMIC+0x330>
  a79ed5:	0f 0b                	ud2
  a79ed7:	48 89 c3             	mov    %rax,%rbx
  a79eda:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a79edf:	e8 7c d1 ff ff       	call   a77060 <core::ptr::drop_glue::<(accesskit::NodeId, accesskit::Node)>>
  a79ee4:	eb 3a                	jmp    a79f20 <gpui::native::accessibility::project+0x4b0>
  a79ee6:	ff 15 b4 de aa 00    	call   *0xaadeb4(%rip)        # 1527da0 <_DYNAMIC+0x288>
  a79eec:	48 89 c3             	mov    %rax,%rbx
  a79eef:	eb 0d                	jmp    a79efe <gpui::native::accessibility::project+0x48e>
  a79ef1:	48 89 c3             	mov    %rax,%rbx
  a79ef4:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a79ef9:	e8 72 ce ff ff       	call   a76d70 <core::ptr::drop_glue::<accesskit::TreeInfo>>
  a79efe:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  a79f03:	48 85 c0             	test   %rax,%rax
  a79f06:	74 18                	je     a79f20 <gpui::native::accessibility::project+0x4b0>
  a79f08:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  a79f0d:	48 c1 e0 03          	shl    $0x3,%rax
  a79f11:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  a79f15:	ba 08 00 00 00       	mov    $0x8,%edx
  a79f1a:	ff 15 48 de aa 00    	call   *0xaade48(%rip)        # 1527d68 <_DYNAMIC+0x250>
  a79f20:	48 89 e7             	mov    %rsp,%rdi
  a79f23:	e8 68 cb ff ff       	call   a76a90 <core::ptr::drop_glue::<alloc::vec::Vec<(accesskit::NodeId, accesskit::Node)>>>
  a79f28:	eb 10                	jmp    a79f3a <gpui::native::accessibility::project+0x4ca>
  a79f2a:	48 89 c3             	mov    %rax,%rbx
  a79f2d:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a79f34:	00 
  a79f35:	e8 66 cd ff ff       	call   a76ca0 <core::ptr::drop_glue::<accesskit::Node>>
  a79f3a:	48 89 df             	mov    %rbx,%rdi
  a79f3d:	e8 fe 88 a3 00       	call   14b2840 <_Unwind_Resume@plt>
  a79f42:	ff 15 58 de aa 00    	call   *0xaade58(%rip)        # 1527da0 <_DYNAMIC+0x288>
