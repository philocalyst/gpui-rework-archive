
/tmp/gpui-caret-transaction-bin/62e-native-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007fa970 <<parley::layout::run::Clusters<()>>::new>:
  7fa970:	55                   	push   %rbp
  7fa971:	41 57                	push   %r15
  7fa973:	41 56                	push   %r14
  7fa975:	41 55                	push   %r13
  7fa977:	41 54                	push   %r12
  7fa979:	53                   	push   %rbx
  7fa97a:	48 83 ec 38          	sub    $0x38,%rsp
  7fa97e:	49 89 f4             	mov    %rsi,%r12
  7fa981:	49 89 fe             	mov    %rdi,%r14
  7fa984:	48 8b 06             	mov    (%rsi),%rax
  7fa987:	8b 7e 28             	mov    0x28(%rsi),%edi
  7fa98a:	48 8b 70 58          	mov    0x58(%rax),%rsi
  7fa98e:	48 39 fe             	cmp    %rdi,%rsi
  7fa991:	0f 86 73 02 00 00    	jbe    7fac0a <<parley::layout::run::Clusters<()>>::new+0x29a>
  7fa997:	49 8b 4c 24 18       	mov    0x18(%r12),%rcx
  7fa99c:	48 85 c9             	test   %rcx,%rcx
  7fa99f:	74 0a                	je     7fa9ab <<parley::layout::run::Clusters<()>>::new+0x3b>
  7fa9a1:	48 8d 79 18          	lea    0x18(%rcx),%rdi
  7fa9a5:	48 83 c1 1c          	add    $0x1c,%rcx
  7fa9a9:	eb 1c                	jmp    7fa9c7 <<parley::layout::run::Clusters<()>>::new+0x57>
  7fa9ab:	4c 8b 40 50          	mov    0x50(%rax),%r8
  7fa9af:	48 8d 34 ff          	lea    (%rdi,%rdi,8),%rsi
  7fa9b3:	48 c1 e6 04          	shl    $0x4,%rsi
  7fa9b7:	49 8d 0c 30          	lea    (%r8,%rsi,1),%rcx
  7fa9bb:	48 83 c1 54          	add    $0x54,%rcx
  7fa9bf:	49 8d 3c 30          	lea    (%r8,%rsi,1),%rdi
  7fa9c3:	48 83 c7 50          	add    $0x50,%rdi
  7fa9c7:	4c 8b 40 68          	mov    0x68(%rax),%r8
  7fa9cb:	4c 8b 48 70          	mov    0x70(%rax),%r9
  7fa9cf:	4c 8b b8 80 00 00 00 	mov    0x80(%rax),%r15
  7fa9d6:	48 8b b0 88 00 00 00 	mov    0x88(%rax),%rsi
  7fa9dd:	4c 8b 90 98 00 00 00 	mov    0x98(%rax),%r10
  7fa9e4:	4c 8b 98 a0 00 00 00 	mov    0xa0(%rax),%r11
  7fa9eb:	8b 29                	mov    (%rcx),%ebp
  7fa9ed:	8b 1f                	mov    (%rdi),%ebx
  7fa9ef:	84 d2                	test   %dl,%dl
  7fa9f1:	74 19                	je     7faa0c <<parley::layout::run::Clusters<()>>::new+0x9c>
  7fa9f3:	39 eb                	cmp    %ebp,%ebx
  7fa9f5:	75 2c                	jne    7faa23 <<parley::layout::run::Clusters<()>>::new+0xb3>
  7fa9f7:	44 8d 6d 01          	lea    0x1(%rbp),%r13d
  7fa9fb:	41 39 ed             	cmp    %ebp,%r13d
  7fa9fe:	44 0f 46 ed          	cmovbe %ebp,%r13d
  7faa02:	41 ff cd             	dec    %r13d
  7faa05:	0f 57 db             	xorps  %xmm3,%xmm3
  7faa08:	31 c9                	xor    %ecx,%ecx
  7faa0a:	eb 10                	jmp    7faa1c <<parley::layout::run::Clusters<()>>::new+0xac>
  7faa0c:	39 eb                	cmp    %ebp,%ebx
  7faa0e:	0f 85 b4 00 00 00    	jne    7faac8 <<parley::layout::run::Clusters<()>>::new+0x158>
  7faa14:	0f 57 db             	xorps  %xmm3,%xmm3
  7faa17:	31 c9                	xor    %ecx,%ecx
  7faa19:	41 89 ed             	mov    %ebp,%r13d
  7faa1c:	89 e8                	mov    %ebp,%eax
  7faa1e:	e9 37 01 00 00       	jmp    7fab5a <<parley::layout::run::Clusters<()>>::new+0x1ea>
  7faa23:	48 39 de             	cmp    %rbx,%rsi
  7faa26:	0f 86 eb 01 00 00    	jbe    7fac17 <<parley::layout::run::Clusters<()>>::new+0x2a7>
  7faa2c:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  7faa30:	48 39 f7             	cmp    %rsi,%rdi
  7faa33:	0f 83 ee 01 00 00    	jae    7fac27 <<parley::layout::run::Clusters<()>>::new+0x2b7>
  7faa39:	4c 89 5c 24 20       	mov    %r11,0x20(%rsp)
  7faa3e:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
  7faa43:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  7faa47:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
  7faa4b:	41 39 ed             	cmp    %ebp,%r13d
  7faa4e:	44 0f 46 ed          	cmovbe %ebp,%r13d
  7faa52:	41 ff cd             	dec    %r13d
  7faa55:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  7faa5a:	4c 39 ee             	cmp    %r13,%rsi
  7faa5d:	0f 86 e3 01 00 00    	jbe    7fac46 <<parley::layout::run::Clusters<()>>::new+0x2d6>
  7faa63:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  7faa67:	41 8b 44 c7 04       	mov    0x4(%r15,%rax,8),%eax
  7faa6c:	89 44 24 08          	mov    %eax,0x8(%rsp)
  7faa70:	4a 8d 04 6d 00 00 00 	lea    0x0(,%r13,2),%rax
  7faa77:	00 
  7faa78:	4c 01 e8             	add    %r13,%rax
  7faa7b:	49 8d 3c c7          	lea    (%r15,%rax,8),%rdi
  7faa7f:	f3 41 0f 10 44 c7 10 	movss  0x10(%r15,%rax,8),%xmm0
  7faa86:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  7faa8c:	4c 89 c6             	mov    %r8,%rsi
  7faa8f:	4c 89 ca             	mov    %r9,%rdx
  7faa92:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  7faa97:	4c 89 4c 24 30       	mov    %r9,0x30(%rsp)
  7faa9c:	ff 15 26 3a 33 00    	call   *0x333a26(%rip)        # b2e4c8 <_DYNAMIC+0xfc8>
  7faaa2:	f3 0f 10 5c 24 04    	movss  0x4(%rsp),%xmm3
  7faaa8:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  7faaac:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  7faab1:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  7faab6:	89 c0                	mov    %eax,%eax
  7faab8:	0f 57 c0             	xorps  %xmm0,%xmm0
  7faabb:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
  7faac0:	f3 0f 5e d8          	divss  %xmm0,%xmm3
  7faac4:	89 e8                	mov    %ebp,%eax
  7faac6:	eb 7f                	jmp    7fab47 <<parley::layout::run::Clusters<()>>::new+0x1d7>
  7faac8:	48 39 de             	cmp    %rbx,%rsi
  7faacb:	0f 86 46 01 00 00    	jbe    7fac17 <<parley::layout::run::Clusters<()>>::new+0x2a7>
  7faad1:	4c 89 5c 24 20       	mov    %r11,0x20(%rsp)
  7faad6:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
  7faadb:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  7faadf:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  7faae3:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  7faae8:	48 39 f7             	cmp    %rsi,%rdi
  7faaeb:	0f 83 43 01 00 00    	jae    7fac34 <<parley::layout::run::Clusters<()>>::new+0x2c4>
  7faaf1:	48 8d 04 5b          	lea    (%rbx,%rbx,2),%rax
  7faaf5:	49 8d 3c c7          	lea    (%r15,%rax,8),%rdi
  7faaf9:	41 8b 0c c7          	mov    (%r15,%rax,8),%ecx
  7faafd:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  7fab01:	f3 41 0f 10 44 c7 10 	movss  0x10(%r15,%rax,8),%xmm0
  7fab08:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  7fab0e:	4c 89 c6             	mov    %r8,%rsi
  7fab11:	4c 89 ca             	mov    %r9,%rdx
  7fab14:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  7fab19:	4d 89 cd             	mov    %r9,%r13
  7fab1c:	ff 15 a6 39 33 00    	call   *0x3339a6(%rip)        # b2e4c8 <_DYNAMIC+0xfc8>
  7fab22:	f3 0f 10 5c 24 04    	movss  0x4(%rsp),%xmm3
  7fab28:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  7fab2c:	4d 89 e9             	mov    %r13,%r9
  7fab2f:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  7fab34:	89 c0                	mov    %eax,%eax
  7fab36:	0f 57 c0             	xorps  %xmm0,%xmm0
  7fab39:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
  7fab3e:	f3 0f 5e d8          	divss  %xmm0,%xmm3
  7fab42:	41 89 dd             	mov    %ebx,%r13d
  7fab45:	89 d8                	mov    %ebx,%eax
  7fab47:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  7fab4b:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  7fab50:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  7fab55:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  7fab5a:	41 0f 10 04 24       	movups (%r12),%xmm0
  7fab5f:	41 0f 10 4c 24 10    	movups 0x10(%r12),%xmm1
  7fab65:	41 0f 10 54 24 20    	movups 0x20(%r12),%xmm2
  7fab6b:	41 0f 11 56 20       	movups %xmm2,0x20(%r14)
  7fab70:	41 0f 11 4e 10       	movups %xmm1,0x10(%r14)
  7fab75:	41 0f 11 06          	movups %xmm0,(%r14)
  7fab79:	4d 89 46 30          	mov    %r8,0x30(%r14)
  7fab7d:	4d 89 4e 38          	mov    %r9,0x38(%r14)
  7fab81:	4d 89 7e 40          	mov    %r15,0x40(%r14)
  7fab85:	49 89 76 48          	mov    %rsi,0x48(%r14)
  7fab89:	4d 89 56 50          	mov    %r10,0x50(%r14)
  7fab8d:	4d 89 5e 58          	mov    %r11,0x58(%r14)
  7fab91:	41 89 5e 60          	mov    %ebx,0x60(%r14)
  7fab95:	41 89 6e 64          	mov    %ebp,0x64(%r14)
  7fab99:	41 89 46 68          	mov    %eax,0x68(%r14)
  7fab9d:	4d 89 46 70          	mov    %r8,0x70(%r14)
  7faba1:	4d 89 4e 78          	mov    %r9,0x78(%r14)
  7faba5:	4d 89 be 80 00 00 00 	mov    %r15,0x80(%r14)
  7fabac:	49 89 b6 88 00 00 00 	mov    %rsi,0x88(%r14)
  7fabb3:	4d 89 96 90 00 00 00 	mov    %r10,0x90(%r14)
  7fabba:	4d 89 9e 98 00 00 00 	mov    %r11,0x98(%r14)
  7fabc1:	41 89 9e a0 00 00 00 	mov    %ebx,0xa0(%r14)
  7fabc8:	41 89 ae a4 00 00 00 	mov    %ebp,0xa4(%r14)
  7fabcf:	41 89 8e a8 00 00 00 	mov    %ecx,0xa8(%r14)
  7fabd6:	45 89 ae ac 00 00 00 	mov    %r13d,0xac(%r14)
  7fabdd:	f3 41 0f 11 9e b0 00 	movss  %xmm3,0xb0(%r14)
  7fabe4:	00 00 
  7fabe6:	49 c7 86 b8 00 00 00 	movq   $0x0,0xb8(%r14)
  7fabed:	00 00 00 00 
  7fabf1:	41 88 96 08 01 00 00 	mov    %dl,0x108(%r14)
  7fabf8:	4c 89 f0             	mov    %r14,%rax
  7fabfb:	48 83 c4 38          	add    $0x38,%rsp
  7fabff:	5b                   	pop    %rbx
  7fac00:	41 5c                	pop    %r12
  7fac02:	41 5d                	pop    %r13
  7fac04:	41 5e                	pop    %r14
  7fac06:	41 5f                	pop    %r15
  7fac08:	5d                   	pop    %rbp
  7fac09:	c3                   	ret
  7fac0a:	48 8d 15 8f d4 30 00 	lea    0x30d48f(%rip),%rdx        # b080a0 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.54.llvm.14379316919819170204>
  7fac11:	ff 15 b9 2b 33 00    	call   *0x332bb9(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fac17:	48 8d 15 12 d2 30 00 	lea    0x30d212(%rip),%rdx        # b07e30 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.8.llvm.14379316919819170204+0x68>
  7fac1e:	48 89 df             	mov    %rbx,%rdi
  7fac21:	ff 15 a9 2b 33 00    	call   *0x332ba9(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fac27:	48 8d 15 1a d2 30 00 	lea    0x30d21a(%rip),%rdx        # b07e48 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.8.llvm.14379316919819170204+0x80>
  7fac2e:	ff 15 9c 2b 33 00    	call   *0x332b9c(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fac34:	48 8d 15 0d d2 30 00 	lea    0x30d20d(%rip),%rdx        # b07e48 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.8.llvm.14379316919819170204+0x80>
  7fac3b:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  7fac40:	ff 15 8a 2b 33 00    	call   *0x332b8a(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fac46:	48 8d 15 bb d2 30 00 	lea    0x30d2bb(%rip),%rdx        # b07f08 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.8.llvm.14379316919819170204+0x140>
  7fac4d:	4c 89 ef             	mov    %r13,%rdi
  7fac50:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  7fac55:	ff 15 75 2b 33 00    	call   *0x332b75(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
