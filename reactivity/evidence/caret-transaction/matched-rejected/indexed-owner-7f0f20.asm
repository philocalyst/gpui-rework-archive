
/tmp/gpui-caret-transaction-bin/matched-indexed-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007f0f20 <<parley::layout::run::Clusters<()>>::new>:
  7f0f20:	55                   	push   %rbp
  7f0f21:	41 57                	push   %r15
  7f0f23:	41 56                	push   %r14
  7f0f25:	41 55                	push   %r13
  7f0f27:	41 54                	push   %r12
  7f0f29:	53                   	push   %rbx
  7f0f2a:	48 83 ec 38          	sub    $0x38,%rsp
  7f0f2e:	49 89 f4             	mov    %rsi,%r12
  7f0f31:	49 89 fe             	mov    %rdi,%r14
  7f0f34:	48 8b 06             	mov    (%rsi),%rax
  7f0f37:	8b 7e 28             	mov    0x28(%rsi),%edi
  7f0f3a:	48 8b 70 58          	mov    0x58(%rax),%rsi
  7f0f3e:	48 39 fe             	cmp    %rdi,%rsi
  7f0f41:	0f 86 73 02 00 00    	jbe    7f11ba <<parley::layout::run::Clusters<()>>::new+0x29a>
  7f0f47:	49 8b 4c 24 18       	mov    0x18(%r12),%rcx
  7f0f4c:	48 85 c9             	test   %rcx,%rcx
  7f0f4f:	74 0a                	je     7f0f5b <<parley::layout::run::Clusters<()>>::new+0x3b>
  7f0f51:	48 8d 79 18          	lea    0x18(%rcx),%rdi
  7f0f55:	48 83 c1 1c          	add    $0x1c,%rcx
  7f0f59:	eb 1c                	jmp    7f0f77 <<parley::layout::run::Clusters<()>>::new+0x57>
  7f0f5b:	4c 8b 40 50          	mov    0x50(%rax),%r8
  7f0f5f:	48 8d 34 ff          	lea    (%rdi,%rdi,8),%rsi
  7f0f63:	48 c1 e6 04          	shl    $0x4,%rsi
  7f0f67:	49 8d 0c 30          	lea    (%r8,%rsi,1),%rcx
  7f0f6b:	48 83 c1 54          	add    $0x54,%rcx
  7f0f6f:	49 8d 3c 30          	lea    (%r8,%rsi,1),%rdi
  7f0f73:	48 83 c7 50          	add    $0x50,%rdi
  7f0f77:	4c 8b 40 68          	mov    0x68(%rax),%r8
  7f0f7b:	4c 8b 48 70          	mov    0x70(%rax),%r9
  7f0f7f:	4c 8b b8 80 00 00 00 	mov    0x80(%rax),%r15
  7f0f86:	48 8b b0 88 00 00 00 	mov    0x88(%rax),%rsi
  7f0f8d:	4c 8b 90 98 00 00 00 	mov    0x98(%rax),%r10
  7f0f94:	4c 8b 98 a0 00 00 00 	mov    0xa0(%rax),%r11
  7f0f9b:	8b 29                	mov    (%rcx),%ebp
  7f0f9d:	8b 1f                	mov    (%rdi),%ebx
  7f0f9f:	84 d2                	test   %dl,%dl
  7f0fa1:	74 19                	je     7f0fbc <<parley::layout::run::Clusters<()>>::new+0x9c>
  7f0fa3:	39 eb                	cmp    %ebp,%ebx
  7f0fa5:	75 2c                	jne    7f0fd3 <<parley::layout::run::Clusters<()>>::new+0xb3>
  7f0fa7:	44 8d 6d 01          	lea    0x1(%rbp),%r13d
  7f0fab:	41 39 ed             	cmp    %ebp,%r13d
  7f0fae:	44 0f 46 ed          	cmovbe %ebp,%r13d
  7f0fb2:	41 ff cd             	dec    %r13d
  7f0fb5:	0f 57 db             	xorps  %xmm3,%xmm3
  7f0fb8:	31 c9                	xor    %ecx,%ecx
  7f0fba:	eb 10                	jmp    7f0fcc <<parley::layout::run::Clusters<()>>::new+0xac>
  7f0fbc:	39 eb                	cmp    %ebp,%ebx
  7f0fbe:	0f 85 b4 00 00 00    	jne    7f1078 <<parley::layout::run::Clusters<()>>::new+0x158>
  7f0fc4:	0f 57 db             	xorps  %xmm3,%xmm3
  7f0fc7:	31 c9                	xor    %ecx,%ecx
  7f0fc9:	41 89 ed             	mov    %ebp,%r13d
  7f0fcc:	89 e8                	mov    %ebp,%eax
  7f0fce:	e9 37 01 00 00       	jmp    7f110a <<parley::layout::run::Clusters<()>>::new+0x1ea>
  7f0fd3:	48 39 de             	cmp    %rbx,%rsi
  7f0fd6:	0f 86 eb 01 00 00    	jbe    7f11c7 <<parley::layout::run::Clusters<()>>::new+0x2a7>
  7f0fdc:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  7f0fe0:	48 39 f7             	cmp    %rsi,%rdi
  7f0fe3:	0f 83 ee 01 00 00    	jae    7f11d7 <<parley::layout::run::Clusters<()>>::new+0x2b7>
  7f0fe9:	4c 89 5c 24 20       	mov    %r11,0x20(%rsp)
  7f0fee:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
  7f0ff3:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  7f0ff7:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
  7f0ffb:	41 39 ed             	cmp    %ebp,%r13d
  7f0ffe:	44 0f 46 ed          	cmovbe %ebp,%r13d
  7f1002:	41 ff cd             	dec    %r13d
  7f1005:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  7f100a:	4c 39 ee             	cmp    %r13,%rsi
  7f100d:	0f 86 e3 01 00 00    	jbe    7f11f6 <<parley::layout::run::Clusters<()>>::new+0x2d6>
  7f1013:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  7f1017:	41 8b 44 c7 04       	mov    0x4(%r15,%rax,8),%eax
  7f101c:	89 44 24 08          	mov    %eax,0x8(%rsp)
  7f1020:	4a 8d 04 6d 00 00 00 	lea    0x0(,%r13,2),%rax
  7f1027:	00 
  7f1028:	4c 01 e8             	add    %r13,%rax
  7f102b:	49 8d 3c c7          	lea    (%r15,%rax,8),%rdi
  7f102f:	f3 41 0f 10 44 c7 10 	movss  0x10(%r15,%rax,8),%xmm0
  7f1036:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  7f103c:	4c 89 c6             	mov    %r8,%rsi
  7f103f:	4c 89 ca             	mov    %r9,%rdx
  7f1042:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  7f1047:	4c 89 4c 24 30       	mov    %r9,0x30(%rsp)
  7f104c:	ff 15 3e ab 33 00    	call   *0x33ab3e(%rip)        # b2bb90 <_DYNAMIC+0xec0>
  7f1052:	f3 0f 10 5c 24 04    	movss  0x4(%rsp),%xmm3
  7f1058:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  7f105c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  7f1061:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  7f1066:	89 c0                	mov    %eax,%eax
  7f1068:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f106b:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
  7f1070:	f3 0f 5e d8          	divss  %xmm0,%xmm3
  7f1074:	89 e8                	mov    %ebp,%eax
  7f1076:	eb 7f                	jmp    7f10f7 <<parley::layout::run::Clusters<()>>::new+0x1d7>
  7f1078:	48 39 de             	cmp    %rbx,%rsi
  7f107b:	0f 86 46 01 00 00    	jbe    7f11c7 <<parley::layout::run::Clusters<()>>::new+0x2a7>
  7f1081:	4c 89 5c 24 20       	mov    %r11,0x20(%rsp)
  7f1086:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
  7f108b:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  7f108f:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  7f1093:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  7f1098:	48 39 f7             	cmp    %rsi,%rdi
  7f109b:	0f 83 43 01 00 00    	jae    7f11e4 <<parley::layout::run::Clusters<()>>::new+0x2c4>
  7f10a1:	48 8d 04 5b          	lea    (%rbx,%rbx,2),%rax
  7f10a5:	49 8d 3c c7          	lea    (%r15,%rax,8),%rdi
  7f10a9:	41 8b 0c c7          	mov    (%r15,%rax,8),%ecx
  7f10ad:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  7f10b1:	f3 41 0f 10 44 c7 10 	movss  0x10(%r15,%rax,8),%xmm0
  7f10b8:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  7f10be:	4c 89 c6             	mov    %r8,%rsi
  7f10c1:	4c 89 ca             	mov    %r9,%rdx
  7f10c4:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  7f10c9:	4d 89 cd             	mov    %r9,%r13
  7f10cc:	ff 15 be aa 33 00    	call   *0x33aabe(%rip)        # b2bb90 <_DYNAMIC+0xec0>
  7f10d2:	f3 0f 10 5c 24 04    	movss  0x4(%rsp),%xmm3
  7f10d8:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  7f10dc:	4d 89 e9             	mov    %r13,%r9
  7f10df:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  7f10e4:	89 c0                	mov    %eax,%eax
  7f10e6:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f10e9:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
  7f10ee:	f3 0f 5e d8          	divss  %xmm0,%xmm3
  7f10f2:	41 89 dd             	mov    %ebx,%r13d
  7f10f5:	89 d8                	mov    %ebx,%eax
  7f10f7:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  7f10fb:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  7f1100:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  7f1105:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  7f110a:	41 0f 10 04 24       	movups (%r12),%xmm0
  7f110f:	41 0f 10 4c 24 10    	movups 0x10(%r12),%xmm1
  7f1115:	41 0f 10 54 24 20    	movups 0x20(%r12),%xmm2
  7f111b:	41 0f 11 56 20       	movups %xmm2,0x20(%r14)
  7f1120:	41 0f 11 4e 10       	movups %xmm1,0x10(%r14)
  7f1125:	41 0f 11 06          	movups %xmm0,(%r14)
  7f1129:	4d 89 46 30          	mov    %r8,0x30(%r14)
  7f112d:	4d 89 4e 38          	mov    %r9,0x38(%r14)
  7f1131:	4d 89 7e 40          	mov    %r15,0x40(%r14)
  7f1135:	49 89 76 48          	mov    %rsi,0x48(%r14)
  7f1139:	4d 89 56 50          	mov    %r10,0x50(%r14)
  7f113d:	4d 89 5e 58          	mov    %r11,0x58(%r14)
  7f1141:	41 89 5e 60          	mov    %ebx,0x60(%r14)
  7f1145:	41 89 6e 64          	mov    %ebp,0x64(%r14)
  7f1149:	41 89 46 68          	mov    %eax,0x68(%r14)
  7f114d:	4d 89 46 70          	mov    %r8,0x70(%r14)
  7f1151:	4d 89 4e 78          	mov    %r9,0x78(%r14)
  7f1155:	4d 89 be 80 00 00 00 	mov    %r15,0x80(%r14)
  7f115c:	49 89 b6 88 00 00 00 	mov    %rsi,0x88(%r14)
  7f1163:	4d 89 96 90 00 00 00 	mov    %r10,0x90(%r14)
  7f116a:	4d 89 9e 98 00 00 00 	mov    %r11,0x98(%r14)
  7f1171:	41 89 9e a0 00 00 00 	mov    %ebx,0xa0(%r14)
  7f1178:	41 89 ae a4 00 00 00 	mov    %ebp,0xa4(%r14)
  7f117f:	41 89 8e a8 00 00 00 	mov    %ecx,0xa8(%r14)
  7f1186:	45 89 ae ac 00 00 00 	mov    %r13d,0xac(%r14)
  7f118d:	f3 41 0f 11 9e b0 00 	movss  %xmm3,0xb0(%r14)
  7f1194:	00 00 
  7f1196:	49 c7 86 b8 00 00 00 	movq   $0x0,0xb8(%r14)
  7f119d:	00 00 00 00 
  7f11a1:	41 88 96 08 01 00 00 	mov    %dl,0x108(%r14)
  7f11a8:	4c 89 f0             	mov    %r14,%rax
  7f11ab:	48 83 c4 38          	add    $0x38,%rsp
  7f11af:	5b                   	pop    %rbx
  7f11b0:	41 5c                	pop    %r12
  7f11b2:	41 5d                	pop    %r13
  7f11b4:	41 5e                	pop    %r14
  7f11b6:	41 5f                	pop    %r15
  7f11b8:	5d                   	pop    %rbp
  7f11b9:	c3                   	ret
  7f11ba:	48 8d 15 3f 42 31 00 	lea    0x31423f(%rip),%rdx        # b05400 <anon.6d4bed3e4a32d1777059b27187abe65d.38.llvm.10560691058145123337>
  7f11c1:	ff 15 d9 9d 33 00    	call   *0x339dd9(%rip)        # b2afa0 <_DYNAMIC+0x2d0>
  7f11c7:	48 8d 15 aa 3f 31 00 	lea    0x313faa(%rip),%rdx        # b05178 <anon.6d4bed3e4a32d1777059b27187abe65d.4.llvm.10560691058145123337+0x18>
  7f11ce:	48 89 df             	mov    %rbx,%rdi
  7f11d1:	ff 15 c9 9d 33 00    	call   *0x339dc9(%rip)        # b2afa0 <_DYNAMIC+0x2d0>
  7f11d7:	48 8d 15 b2 3f 31 00 	lea    0x313fb2(%rip),%rdx        # b05190 <anon.6d4bed3e4a32d1777059b27187abe65d.4.llvm.10560691058145123337+0x30>
  7f11de:	ff 15 bc 9d 33 00    	call   *0x339dbc(%rip)        # b2afa0 <_DYNAMIC+0x2d0>
  7f11e4:	48 8d 15 a5 3f 31 00 	lea    0x313fa5(%rip),%rdx        # b05190 <anon.6d4bed3e4a32d1777059b27187abe65d.4.llvm.10560691058145123337+0x30>
  7f11eb:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  7f11f0:	ff 15 aa 9d 33 00    	call   *0x339daa(%rip)        # b2afa0 <_DYNAMIC+0x2d0>
  7f11f6:	48 8d 15 53 40 31 00 	lea    0x314053(%rip),%rdx        # b05250 <anon.6d4bed3e4a32d1777059b27187abe65d.4.llvm.10560691058145123337+0xf0>
  7f11fd:	4c 89 ef             	mov    %r13,%rdi
  7f1200:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  7f1205:	ff 15 95 9d 33 00    	call   *0x339d95(%rip)        # b2afa0 <_DYNAMIC+0x2d0>
