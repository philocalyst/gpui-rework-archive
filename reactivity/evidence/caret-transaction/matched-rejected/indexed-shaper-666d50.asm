
/tmp/gpui-caret-transaction-bin/matched-indexed-caret_pair_measure:     file format elf64-x86-64


Disassembly of section .text:

0000000000666d50 <<parley::layout::run::Clusters<()>>::new>:
  666d50:	55                   	push   %rbp
  666d51:	41 57                	push   %r15
  666d53:	41 56                	push   %r14
  666d55:	41 55                	push   %r13
  666d57:	41 54                	push   %r12
  666d59:	53                   	push   %rbx
  666d5a:	48 83 ec 38          	sub    $0x38,%rsp
  666d5e:	49 89 f4             	mov    %rsi,%r12
  666d61:	49 89 fe             	mov    %rdi,%r14
  666d64:	48 8b 06             	mov    (%rsi),%rax
  666d67:	8b 7e 28             	mov    0x28(%rsi),%edi
  666d6a:	48 8b 70 58          	mov    0x58(%rax),%rsi
  666d6e:	48 39 fe             	cmp    %rdi,%rsi
  666d71:	0f 86 73 02 00 00    	jbe    666fea <<parley::layout::run::Clusters<()>>::new+0x29a>
  666d77:	49 8b 4c 24 18       	mov    0x18(%r12),%rcx
  666d7c:	48 85 c9             	test   %rcx,%rcx
  666d7f:	74 0a                	je     666d8b <<parley::layout::run::Clusters<()>>::new+0x3b>
  666d81:	48 8d 79 18          	lea    0x18(%rcx),%rdi
  666d85:	48 83 c1 1c          	add    $0x1c,%rcx
  666d89:	eb 1c                	jmp    666da7 <<parley::layout::run::Clusters<()>>::new+0x57>
  666d8b:	4c 8b 40 50          	mov    0x50(%rax),%r8
  666d8f:	48 8d 34 ff          	lea    (%rdi,%rdi,8),%rsi
  666d93:	48 c1 e6 04          	shl    $0x4,%rsi
  666d97:	49 8d 0c 30          	lea    (%r8,%rsi,1),%rcx
  666d9b:	48 83 c1 54          	add    $0x54,%rcx
  666d9f:	49 8d 3c 30          	lea    (%r8,%rsi,1),%rdi
  666da3:	48 83 c7 50          	add    $0x50,%rdi
  666da7:	4c 8b 40 68          	mov    0x68(%rax),%r8
  666dab:	4c 8b 48 70          	mov    0x70(%rax),%r9
  666daf:	4c 8b b8 80 00 00 00 	mov    0x80(%rax),%r15
  666db6:	48 8b b0 88 00 00 00 	mov    0x88(%rax),%rsi
  666dbd:	4c 8b 90 98 00 00 00 	mov    0x98(%rax),%r10
  666dc4:	4c 8b 98 a0 00 00 00 	mov    0xa0(%rax),%r11
  666dcb:	8b 29                	mov    (%rcx),%ebp
  666dcd:	8b 1f                	mov    (%rdi),%ebx
  666dcf:	84 d2                	test   %dl,%dl
  666dd1:	74 19                	je     666dec <<parley::layout::run::Clusters<()>>::new+0x9c>
  666dd3:	39 eb                	cmp    %ebp,%ebx
  666dd5:	75 2c                	jne    666e03 <<parley::layout::run::Clusters<()>>::new+0xb3>
  666dd7:	44 8d 6d 01          	lea    0x1(%rbp),%r13d
  666ddb:	41 39 ed             	cmp    %ebp,%r13d
  666dde:	44 0f 46 ed          	cmovbe %ebp,%r13d
  666de2:	41 ff cd             	dec    %r13d
  666de5:	0f 57 db             	xorps  %xmm3,%xmm3
  666de8:	31 c9                	xor    %ecx,%ecx
  666dea:	eb 10                	jmp    666dfc <<parley::layout::run::Clusters<()>>::new+0xac>
  666dec:	39 eb                	cmp    %ebp,%ebx
  666dee:	0f 85 b4 00 00 00    	jne    666ea8 <<parley::layout::run::Clusters<()>>::new+0x158>
  666df4:	0f 57 db             	xorps  %xmm3,%xmm3
  666df7:	31 c9                	xor    %ecx,%ecx
  666df9:	41 89 ed             	mov    %ebp,%r13d
  666dfc:	89 e8                	mov    %ebp,%eax
  666dfe:	e9 37 01 00 00       	jmp    666f3a <<parley::layout::run::Clusters<()>>::new+0x1ea>
  666e03:	48 39 de             	cmp    %rbx,%rsi
  666e06:	0f 86 eb 01 00 00    	jbe    666ff7 <<parley::layout::run::Clusters<()>>::new+0x2a7>
  666e0c:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  666e10:	48 39 f7             	cmp    %rsi,%rdi
  666e13:	0f 83 ee 01 00 00    	jae    667007 <<parley::layout::run::Clusters<()>>::new+0x2b7>
  666e19:	4c 89 5c 24 20       	mov    %r11,0x20(%rsp)
  666e1e:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
  666e23:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  666e27:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
  666e2b:	41 39 ed             	cmp    %ebp,%r13d
  666e2e:	44 0f 46 ed          	cmovbe %ebp,%r13d
  666e32:	41 ff cd             	dec    %r13d
  666e35:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  666e3a:	4c 39 ee             	cmp    %r13,%rsi
  666e3d:	0f 86 e3 01 00 00    	jbe    667026 <<parley::layout::run::Clusters<()>>::new+0x2d6>
  666e43:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  666e47:	41 8b 44 c7 04       	mov    0x4(%r15,%rax,8),%eax
  666e4c:	89 44 24 08          	mov    %eax,0x8(%rsp)
  666e50:	4a 8d 04 6d 00 00 00 	lea    0x0(,%r13,2),%rax
  666e57:	00 
  666e58:	4c 01 e8             	add    %r13,%rax
  666e5b:	49 8d 3c c7          	lea    (%r15,%rax,8),%rdi
  666e5f:	f3 41 0f 10 44 c7 10 	movss  0x10(%r15,%rax,8),%xmm0
  666e66:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  666e6c:	4c 89 c6             	mov    %r8,%rsi
  666e6f:	4c 89 ca             	mov    %r9,%rdx
  666e72:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  666e77:	4c 89 4c 24 30       	mov    %r9,0x30(%rsp)
  666e7c:	ff 15 2e 03 12 00    	call   *0x12032e(%rip)        # 7871b0 <_DYNAMIC+0x528>
  666e82:	f3 0f 10 5c 24 04    	movss  0x4(%rsp),%xmm3
  666e88:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  666e8c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  666e91:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  666e96:	89 c0                	mov    %eax,%eax
  666e98:	0f 57 c0             	xorps  %xmm0,%xmm0
  666e9b:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
  666ea0:	f3 0f 5e d8          	divss  %xmm0,%xmm3
  666ea4:	89 e8                	mov    %ebp,%eax
  666ea6:	eb 7f                	jmp    666f27 <<parley::layout::run::Clusters<()>>::new+0x1d7>
  666ea8:	48 39 de             	cmp    %rbx,%rsi
  666eab:	0f 86 46 01 00 00    	jbe    666ff7 <<parley::layout::run::Clusters<()>>::new+0x2a7>
  666eb1:	4c 89 5c 24 20       	mov    %r11,0x20(%rsp)
  666eb6:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
  666ebb:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  666ebf:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  666ec3:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  666ec8:	48 39 f7             	cmp    %rsi,%rdi
  666ecb:	0f 83 43 01 00 00    	jae    667014 <<parley::layout::run::Clusters<()>>::new+0x2c4>
  666ed1:	48 8d 04 5b          	lea    (%rbx,%rbx,2),%rax
  666ed5:	49 8d 3c c7          	lea    (%r15,%rax,8),%rdi
  666ed9:	41 8b 0c c7          	mov    (%r15,%rax,8),%ecx
  666edd:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  666ee1:	f3 41 0f 10 44 c7 10 	movss  0x10(%r15,%rax,8),%xmm0
  666ee8:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  666eee:	4c 89 c6             	mov    %r8,%rsi
  666ef1:	4c 89 ca             	mov    %r9,%rdx
  666ef4:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  666ef9:	4d 89 cd             	mov    %r9,%r13
  666efc:	ff 15 ae 02 12 00    	call   *0x1202ae(%rip)        # 7871b0 <_DYNAMIC+0x528>
  666f02:	f3 0f 10 5c 24 04    	movss  0x4(%rsp),%xmm3
  666f08:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  666f0c:	4d 89 e9             	mov    %r13,%r9
  666f0f:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  666f14:	89 c0                	mov    %eax,%eax
  666f16:	0f 57 c0             	xorps  %xmm0,%xmm0
  666f19:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
  666f1e:	f3 0f 5e d8          	divss  %xmm0,%xmm3
  666f22:	41 89 dd             	mov    %ebx,%r13d
  666f25:	89 d8                	mov    %ebx,%eax
  666f27:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  666f2b:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  666f30:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  666f35:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  666f3a:	41 0f 10 04 24       	movups (%r12),%xmm0
  666f3f:	41 0f 10 4c 24 10    	movups 0x10(%r12),%xmm1
  666f45:	41 0f 10 54 24 20    	movups 0x20(%r12),%xmm2
  666f4b:	41 0f 11 56 20       	movups %xmm2,0x20(%r14)
  666f50:	41 0f 11 4e 10       	movups %xmm1,0x10(%r14)
  666f55:	41 0f 11 06          	movups %xmm0,(%r14)
  666f59:	4d 89 46 30          	mov    %r8,0x30(%r14)
  666f5d:	4d 89 4e 38          	mov    %r9,0x38(%r14)
  666f61:	4d 89 7e 40          	mov    %r15,0x40(%r14)
  666f65:	49 89 76 48          	mov    %rsi,0x48(%r14)
  666f69:	4d 89 56 50          	mov    %r10,0x50(%r14)
  666f6d:	4d 89 5e 58          	mov    %r11,0x58(%r14)
  666f71:	41 89 5e 60          	mov    %ebx,0x60(%r14)
  666f75:	41 89 6e 64          	mov    %ebp,0x64(%r14)
  666f79:	41 89 46 68          	mov    %eax,0x68(%r14)
  666f7d:	4d 89 46 70          	mov    %r8,0x70(%r14)
  666f81:	4d 89 4e 78          	mov    %r9,0x78(%r14)
  666f85:	4d 89 be 80 00 00 00 	mov    %r15,0x80(%r14)
  666f8c:	49 89 b6 88 00 00 00 	mov    %rsi,0x88(%r14)
  666f93:	4d 89 96 90 00 00 00 	mov    %r10,0x90(%r14)
  666f9a:	4d 89 9e 98 00 00 00 	mov    %r11,0x98(%r14)
  666fa1:	41 89 9e a0 00 00 00 	mov    %ebx,0xa0(%r14)
  666fa8:	41 89 ae a4 00 00 00 	mov    %ebp,0xa4(%r14)
  666faf:	41 89 8e a8 00 00 00 	mov    %ecx,0xa8(%r14)
  666fb6:	45 89 ae ac 00 00 00 	mov    %r13d,0xac(%r14)
  666fbd:	f3 41 0f 11 9e b0 00 	movss  %xmm3,0xb0(%r14)
  666fc4:	00 00 
  666fc6:	49 c7 86 b8 00 00 00 	movq   $0x0,0xb8(%r14)
  666fcd:	00 00 00 00 
  666fd1:	41 88 96 08 01 00 00 	mov    %dl,0x108(%r14)
  666fd8:	4c 89 f0             	mov    %r14,%rax
  666fdb:	48 83 c4 38          	add    $0x38,%rsp
  666fdf:	5b                   	pop    %rbx
  666fe0:	41 5c                	pop    %r12
  666fe2:	41 5d                	pop    %r13
  666fe4:	41 5e                	pop    %r14
  666fe6:	41 5f                	pop    %r15
  666fe8:	5d                   	pop    %rbp
  666fe9:	c3                   	ret
  666fea:	48 8d 15 37 56 11 00 	lea    0x115637(%rip),%rdx        # 77c628 <anon.d1c5e71728065e152e7afc2084c95a94.38.llvm.16205762496989061431>
  666ff1:	ff 15 f1 ff 11 00    	call   *0x11fff1(%rip)        # 786fe8 <_DYNAMIC+0x360>
  666ff7:	48 8d 15 a2 53 11 00 	lea    0x1153a2(%rip),%rdx        # 77c3a0 <anon.d1c5e71728065e152e7afc2084c95a94.4.llvm.16205762496989061431+0x18>
  666ffe:	48 89 df             	mov    %rbx,%rdi
  667001:	ff 15 e1 ff 11 00    	call   *0x11ffe1(%rip)        # 786fe8 <_DYNAMIC+0x360>
  667007:	48 8d 15 aa 53 11 00 	lea    0x1153aa(%rip),%rdx        # 77c3b8 <anon.d1c5e71728065e152e7afc2084c95a94.4.llvm.16205762496989061431+0x30>
  66700e:	ff 15 d4 ff 11 00    	call   *0x11ffd4(%rip)        # 786fe8 <_DYNAMIC+0x360>
  667014:	48 8d 15 9d 53 11 00 	lea    0x11539d(%rip),%rdx        # 77c3b8 <anon.d1c5e71728065e152e7afc2084c95a94.4.llvm.16205762496989061431+0x30>
  66701b:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  667020:	ff 15 c2 ff 11 00    	call   *0x11ffc2(%rip)        # 786fe8 <_DYNAMIC+0x360>
  667026:	48 8d 15 4b 54 11 00 	lea    0x11544b(%rip),%rdx        # 77c478 <anon.d1c5e71728065e152e7afc2084c95a94.4.llvm.16205762496989061431+0xf0>
  66702d:	4c 89 ef             	mov    %r13,%rdi
  667030:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  667035:	ff 15 ad ff 11 00    	call   *0x11ffad(%rip)        # 786fe8 <_DYNAMIC+0x360>
