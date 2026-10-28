
/tmp/gpui-validated-lookup-apps-47b10baaa49b35f2e0adf9713c95b13d4bbe776de05550eb007192163d59af6f:     file format elf64-x86-64


Disassembly of section .text:

00000000005b0c30 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399>:
  5b0c30:	55                   	push   %rbp
  5b0c31:	41 57                	push   %r15
  5b0c33:	41 56                	push   %r14
  5b0c35:	41 55                	push   %r13
  5b0c37:	41 54                	push   %r12
  5b0c39:	53                   	push   %rbx
  5b0c3a:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  5b0c41:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  5b0c48:	00 
  5b0c49:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  5b0c50:	49 89 f5             	mov    %rsi,%r13
  5b0c53:	80 be 5b 09 00 00 00 	cmpb   $0x0,0x95b(%rsi)
  5b0c5a:	48 89 34 24          	mov    %rsi,(%rsp)
  5b0c5e:	0f 84 a6 00 00 00    	je     5b0d0a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xda>
  5b0c64:	49 8b 9d 90 07 00 00 	mov    0x790(%r13),%rbx
  5b0c6b:	49 89 d8             	mov    %rbx,%r8
  5b0c6e:	49 ff c0             	inc    %r8
  5b0c71:	48 89 bc 24 a0 00 00 	mov    %rdi,0xa0(%rsp)
  5b0c78:	00 
  5b0c79:	0f 84 ac 3e 00 00    	je     5b4b2b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3efb>
  5b0c7f:	4d 8b bd 88 07 00 00 	mov    0x788(%r13),%r15
  5b0c86:	49 8b b5 78 08 00 00 	mov    0x878(%r13),%rsi
  5b0c8d:	66 48 0f 6e c6       	movq   %rsi,%xmm0
  5b0c92:	66 0f 7f 44 24 60    	movdqa %xmm0,0x60(%rsp)
  5b0c98:	66 0f 70 c0 55       	pshufd $0x55,%xmm0,%xmm0
  5b0c9d:	66 0f 7e c2          	movd   %xmm0,%edx
  5b0ca1:	f3 41 0f 10 85 50 09 	movss  0x950(%r13),%xmm0
  5b0ca8:	00 00 
  5b0caa:	f3 0f 11 44 24 24    	movss  %xmm0,0x24(%rsp)
  5b0cb0:	41 8b 85 f0 01 00 00 	mov    0x1f0(%r13),%eax
  5b0cb7:	49 8b 8d f8 01 00 00 	mov    0x1f8(%r13),%rcx
  5b0cbe:	48 c1 e1 20          	shl    $0x20,%rcx
  5b0cc2:	48 09 c1             	or     %rax,%rcx
  5b0cc5:	48 89 b4 24 90 00 00 	mov    %rsi,0x90(%rsp)
  5b0ccc:	00 
  5b0ccd:	48 39 f1             	cmp    %rsi,%rcx
  5b0cd0:	4c 89 84 24 90 03 00 	mov    %r8,0x390(%rsp)
  5b0cd7:	00 
  5b0cd8:	89 54 24 54          	mov    %edx,0x54(%rsp)
  5b0cdc:	0f 85 64 03 00 00    	jne    5b1046 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x416>
  5b0ce2:	48 c7 84 24 58 0c 00 	movq   $0x2,0xc58(%rsp)
  5b0ce9:	00 02 00 00 00 
  5b0cee:	41 be 02 00 00 00    	mov    $0x2,%r14d
  5b0cf4:	81 bc 24 90 00 00 00 	cmpl   $0xffff,0x90(%rsp)
  5b0cfb:	ff ff 00 00 
  5b0cff:	0f 86 ed 04 00 00    	jbe    5b11f2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x5c2>
  5b0d05:	e9 f2 04 00 00       	jmp    5b11fc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x5cc>
  5b0d0a:	4d 8b 95 60 08 00 00 	mov    0x860(%r13),%r10
  5b0d11:	4d 85 d2             	test   %r10,%r10
  5b0d14:	0f 84 ff 02 00 00    	je     5b1019 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3e9>
  5b0d1a:	4d 8b bd 10 08 00 00 	mov    0x810(%r13),%r15
  5b0d21:	4d 85 ff             	test   %r15,%r15
  5b0d24:	0f 84 ef 02 00 00    	je     5b1019 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3e9>
  5b0d2a:	49 8b 85 90 08 00 00 	mov    0x890(%r13),%rax
  5b0d31:	49 8d 4a ff          	lea    -0x1(%r10),%rcx
  5b0d35:	48 39 c8             	cmp    %rcx,%rax
  5b0d38:	0f 85 a0 03 00 00    	jne    5b10de <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4ae>
  5b0d3e:	4c 89 94 24 90 00 00 	mov    %r10,0x90(%rsp)
  5b0d45:	00 
  5b0d46:	48 89 bc 24 a0 00 00 	mov    %rdi,0xa0(%rsp)
  5b0d4d:	00 
  5b0d4e:	49 8b ad 60 07 00 00 	mov    0x760(%r13),%rbp
  5b0d55:	41 0f b6 95 5c 09 00 	movzbl 0x95c(%r13),%edx
  5b0d5c:	00 
  5b0d5d:	88 54 24 24          	mov    %dl,0x24(%rsp)
  5b0d61:	80 f2 01             	xor    $0x1,%dl
  5b0d64:	49 8d 85 68 07 00 00 	lea    0x768(%r13),%rax
  5b0d6b:	49 8d 8d 50 07 00 00 	lea    0x750(%r13),%rcx
  5b0d72:	48 83 fd ff          	cmp    $0xffffffffffffffff,%rbp
  5b0d76:	88 54 24 60          	mov    %dl,0x60(%rsp)
  5b0d7a:	0f b6 d2             	movzbl %dl,%edx
  5b0d7d:	be 01 00 00 00       	mov    $0x1,%esi
  5b0d82:	0f 44 f2             	cmove  %edx,%esi
  5b0d85:	89 74 24 54          	mov    %esi,0x54(%rsp)
  5b0d89:	4d 8b a5 58 07 00 00 	mov    0x758(%r13),%r12
  5b0d90:	4d 8b b5 70 07 00 00 	mov    0x770(%r13),%r14
  5b0d97:	48 0f 44 c1          	cmove  %rcx,%rax
  5b0d9b:	48 8b 18             	mov    (%rax),%rbx
  5b0d9e:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b0da5:	00 
  5b0da6:	4c 89 ee             	mov    %r13,%rsi
  5b0da9:	4c 89 fa             	mov    %r15,%rdx
  5b0dac:	e8 3f 91 f8 ff       	call   539ef0 <_RNCNvMs1_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataINtB9_7RuntimeNtNtB9_12style_ledger9AdversaryE14metadata_sheet0Bb_>
  5b0db1:	49 8b 85 18 08 00 00 	mov    0x818(%r13),%rax
  5b0db8:	49 8b 8d 20 08 00 00 	mov    0x820(%r13),%rcx
  5b0dbf:	31 d2                	xor    %edx,%edx
  5b0dc1:	48 89 c6             	mov    %rax,%rsi
  5b0dc4:	48 85 c0             	test   %rax,%rax
  5b0dc7:	0f 95 c2             	setne  %dl
  5b0dca:	74 0b                	je     5b0dd7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1a7>
  5b0dcc:	48 8b 34 24          	mov    (%rsp),%rsi
  5b0dd0:	48 8b b6 28 08 00 00 	mov    0x828(%rsi),%rsi
  5b0dd7:	48 89 94 24 a0 09 00 	mov    %rdx,0x9a0(%rsp)
  5b0dde:	00 
  5b0ddf:	48 c7 84 24 a8 09 00 	movq   $0x0,0x9a8(%rsp)
  5b0de6:	00 00 00 00 00 
  5b0deb:	48 89 84 24 b0 09 00 	mov    %rax,0x9b0(%rsp)
  5b0df2:	00 
  5b0df3:	48 89 8c 24 b8 09 00 	mov    %rcx,0x9b8(%rsp)
  5b0dfa:	00 
  5b0dfb:	48 89 94 24 c0 09 00 	mov    %rdx,0x9c0(%rsp)
  5b0e02:	00 
  5b0e03:	48 c7 84 24 c8 09 00 	movq   $0x0,0x9c8(%rsp)
  5b0e0a:	00 00 00 00 00 
  5b0e0f:	48 89 84 24 d0 09 00 	mov    %rax,0x9d0(%rsp)
  5b0e16:	00 
  5b0e17:	48 89 8c 24 d8 09 00 	mov    %rcx,0x9d8(%rsp)
  5b0e1e:	00 
  5b0e1f:	48 89 b4 24 e0 09 00 	mov    %rsi,0x9e0(%rsp)
  5b0e26:	00 
  5b0e27:	48 8d bc 24 58 0c 00 	lea    0xc58(%rsp),%rdi
  5b0e2e:	00 
  5b0e2f:	48 8d b4 24 a0 09 00 	lea    0x9a0(%rsp),%rsi
  5b0e36:	00 
  5b0e37:	e8 d4 23 17 00       	call   723210 <_RINvXs1o_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB7_8BTreeMapyNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata8ListInfoEINtNtNtNtCs4NRVxsYgnAr_4core4iter6traits7collect12FromIteratorTyB19_EE9from_iterINtNtNtB26_8adapters3map3MapINtB7_4IterNtNtB1f_4list6ListIdNtNtB1d_4list9ListStateENCNvMs1_B1b_INtB1d_7RuntimeNtNtB1d_12style_ledger9AdversaryE13list_metadata0EEB1f_>
  5b0e3c:	48 89 6c 24 30       	mov    %rbp,0x30(%rsp)
  5b0e41:	48 83 fd ff          	cmp    $0xffffffffffffffff,%rbp
  5b0e45:	4d 0f 44 f4          	cmove  %r12,%r14
  5b0e49:	4d 85 f6             	test   %r14,%r14
  5b0e4c:	0f 84 79 18 00 00    	je     5b26cb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1a9b>
  5b0e52:	49 c1 e6 04          	shl    $0x4,%r14
  5b0e56:	4b 8d 2c b6          	lea    (%r14,%r14,4),%rbp
  5b0e5a:	4c 8d 24 2b          	lea    (%rbx,%rbp,1),%r12
  5b0e5e:	4c 8b b4 24 58 0c 00 	mov    0xc58(%rsp),%r14
  5b0e65:	00 
  5b0e66:	48 8b 04 24          	mov    (%rsp),%rax
  5b0e6a:	4c 8b a8 30 08 00 00 	mov    0x830(%rax),%r13
  5b0e71:	48 8b 80 38 08 00 00 	mov    0x838(%rax),%rax
  5b0e78:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  5b0e7d:	4d 85 f6             	test   %r14,%r14
  5b0e80:	0f 84 88 11 00 00    	je     5b200e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13de>
  5b0e86:	48 8b ac 24 60 0c 00 	mov    0xc60(%rsp),%rbp
  5b0e8d:	00 
  5b0e8e:	4d 85 ed             	test   %r13,%r13
  5b0e91:	0f 84 71 12 00 00    	je     5b2108 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x14d8>
  5b0e97:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5b0e9e:	00 00 
  5b0ea0:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  5b0ea4:	48 83 c3 50          	add    $0x50,%rbx
  5b0ea8:	48 89 e9             	mov    %rbp,%rcx
  5b0eab:	4c 89 f0             	mov    %r14,%rax
  5b0eae:	0f b7 b8 12 01 00 00 	movzwl 0x112(%rax),%edi
  5b0eb5:	41 89 f9             	mov    %edi,%r9d
  5b0eb8:	41 c1 e1 04          	shl    $0x4,%r9d
  5b0ebc:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  5b0ec3:	45 31 c0             	xor    %r8d,%r8d
  5b0ec6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5b0ecd:	00 00 00 
  5b0ed0:	4d 39 c1             	cmp    %r8,%r9
  5b0ed3:	74 3b                	je     5b0f10 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2e0>
  5b0ed5:	48 3b 94 f0 c0 00 00 	cmp    0xc0(%rax,%rsi,8),%rdx
  5b0edc:	00 
  5b0edd:	41 0f 97 c2          	seta   %r10b
  5b0ee1:	41 80 da 00          	sbb    $0x0,%r10b
  5b0ee5:	49 83 c0 10          	add    $0x10,%r8
  5b0ee9:	48 ff c6             	inc    %rsi
  5b0eec:	41 80 fa 01          	cmp    $0x1,%r10b
  5b0ef0:	74 de                	je     5b0ed0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2a0>
  5b0ef2:	41 0f b6 fa          	movzbl %r10b,%edi
  5b0ef6:	85 ff                	test   %edi,%edi
  5b0ef8:	74 36                	je     5b0f30 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x300>
  5b0efa:	48 83 e9 01          	sub    $0x1,%rcx
  5b0efe:	73 1d                	jae    5b0f1d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2ed>
  5b0f00:	e9 08 01 00 00       	jmp    5b100d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3dd>
  5b0f05:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5b0f0c:	00 00 00 00 
  5b0f10:	48 89 fe             	mov    %rdi,%rsi
  5b0f13:	48 83 e9 01          	sub    $0x1,%rcx
  5b0f17:	0f 82 f0 00 00 00    	jb     5b100d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3dd>
  5b0f1d:	48 8b 84 f0 18 01 00 	mov    0x118(%rax,%rsi,8),%rax
  5b0f24:	00 
  5b0f25:	eb 87                	jmp    5b0eae <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x27e>
  5b0f27:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5b0f2e:	00 00 
  5b0f30:	4a 8b 4c 00 f0       	mov    -0x10(%rax,%r8,1),%rcx
  5b0f35:	42 8b 44 00 f8       	mov    -0x8(%rax,%r8,1),%eax
  5b0f3a:	48 89 8c 24 a8 09 00 	mov    %rcx,0x9a8(%rsp)
  5b0f41:	00 
  5b0f42:	89 84 24 b0 09 00 00 	mov    %eax,0x9b0(%rsp)
  5b0f49:	b8 01 00 00 00       	mov    $0x1,%eax
  5b0f4e:	48 89 84 24 a0 09 00 	mov    %rax,0x9a0(%rsp)
  5b0f55:	00 
  5b0f56:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  5b0f5b:	4d 89 e8             	mov    %r13,%r8
  5b0f5e:	41 0f b7 b0 c2 01 00 	movzwl 0x1c2(%r8),%esi
  5b0f65:	00 
  5b0f66:	41 89 f1             	mov    %esi,%r9d
  5b0f69:	41 c1 e1 05          	shl    $0x5,%r9d
  5b0f6d:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  5b0f74:	31 ff                	xor    %edi,%edi
  5b0f76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5b0f7d:	00 00 00 
  5b0f80:	4d 89 ca             	mov    %r9,%r10
  5b0f83:	49 01 fa             	add    %rdi,%r10
  5b0f86:	74 38                	je     5b0fc0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x390>
  5b0f88:	49 3b 94 c8 70 01 00 	cmp    0x170(%r8,%rcx,8),%rdx
  5b0f8f:	00 
  5b0f90:	41 0f 97 c2          	seta   %r10b
  5b0f94:	41 80 da 00          	sbb    $0x0,%r10b
  5b0f98:	48 83 c7 e0          	add    $0xffffffffffffffe0,%rdi
  5b0f9c:	48 ff c1             	inc    %rcx
  5b0f9f:	41 80 fa 01          	cmp    $0x1,%r10b
  5b0fa3:	74 db                	je     5b0f80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x350>
  5b0fa5:	41 0f b6 f2          	movzbl %r10b,%esi
  5b0fa9:	85 f6                	test   %esi,%esi
  5b0fab:	74 33                	je     5b0fe0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3b0>
  5b0fad:	48 83 e8 01          	sub    $0x1,%rax
  5b0fb1:	73 16                	jae    5b0fc9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x399>
  5b0fb3:	eb 5f                	jmp    5b1014 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3e4>
  5b0fb5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5b0fbc:	00 00 00 00 
  5b0fc0:	48 89 f1             	mov    %rsi,%rcx
  5b0fc3:	48 83 e8 01          	sub    $0x1,%rax
  5b0fc7:	72 4b                	jb     5b1014 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3e4>
  5b0fc9:	4d 8b 84 c8 c8 01 00 	mov    0x1c8(%r8,%rcx,8),%r8
  5b0fd0:	00 
  5b0fd1:	eb 8b                	jmp    5b0f5e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x32e>
  5b0fd3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b0fda:	84 00 00 00 00 00 
  5b0fe0:	49 29 f8             	sub    %rdi,%r8
  5b0fe3:	49 83 c0 e0          	add    $0xffffffffffffffe0,%r8
  5b0fe7:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b0fee:	00 
  5b0fef:	4c 89 fe             	mov    %r15,%rsi
  5b0ff2:	48 8d 8c 24 a0 09 00 	lea    0x9a0(%rsp),%rcx
  5b0ff9:	00 
  5b0ffa:	e8 91 71 1a 00       	call   758190 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataNtB4_5Sheet7capture>
  5b0fff:	4c 39 e3             	cmp    %r12,%rbx
  5b1002:	0f 85 98 fe ff ff    	jne    5b0ea0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x270>
  5b1008:	e9 be 16 00 00       	jmp    5b26cb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1a9b>
  5b100d:	31 c0                	xor    %eax,%eax
  5b100f:	e9 3a ff ff ff       	jmp    5b0f4e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x31e>
  5b1014:	45 31 c0             	xor    %r8d,%r8d
  5b1017:	eb ce                	jmp    5b0fe7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3b7>
  5b1019:	4d 89 95 90 08 00 00 	mov    %r10,0x890(%r13)
  5b1020:	49 8b 95 60 07 00 00 	mov    0x760(%r13),%rdx
  5b1027:	48 83 fa ff          	cmp    $0xffffffffffffffff,%rdx
  5b102b:	0f 94 c1             	sete   %cl
  5b102e:	41 0f b6 85 5c 09 00 	movzbl 0x95c(%r13),%eax
  5b1035:	00 
  5b1036:	84 c1                	test   %al,%cl
  5b1038:	74 51                	je     5b108b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x45b>
  5b103a:	4d 89 95 68 08 00 00 	mov    %r10,0x868(%r13)
  5b1041:	4c 89 d1             	mov    %r10,%rcx
  5b1044:	eb 4c                	jmp    5b1092 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x462>
  5b1046:	49 8d 85 80 01 00 00 	lea    0x180(%r13),%rax
  5b104d:	41 80 bd 5d 09 00 00 	cmpb   $0x0,0x95d(%r13)
  5b1054:	00 
  5b1055:	0f 84 e3 00 00 00    	je     5b113e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x50e>
  5b105b:	66 0f 10 00          	movupd (%rax),%xmm0
  5b105f:	66 0f 29 84 24 a0 09 	movapd %xmm0,0x9a0(%rsp)
  5b1066:	00 00 
  5b1068:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b106f:	00 
  5b1070:	48 8d 8c 24 a0 09 00 	lea    0x9a0(%rsp),%rcx
  5b1077:	00 
  5b1078:	48 8b b4 24 90 00 00 	mov    0x90(%rsp),%rsi
  5b107f:	00 
  5b1080:	ff 15 5a 90 53 00    	call   *0x53905a(%rip)        # aea0e0 <_DYNAMIC+0x380>
  5b1086:	e9 de 00 00 00       	jmp    5b1169 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x539>
  5b108b:	49 8b 8d 68 08 00 00 	mov    0x868(%r13),%rcx
  5b1092:	89 c6                	mov    %eax,%esi
  5b1094:	40 80 f6 01          	xor    $0x1,%sil
  5b1098:	48 83 fa ff          	cmp    $0xffffffffffffffff,%rdx
  5b109c:	0f 95 c2             	setne  %dl
  5b109f:	49 83 bd 80 08 00 00 	cmpq   $0x0,0x880(%r13)
  5b10a6:	00 
  5b10a7:	41 0f 95 c0          	setne  %r8b
  5b10ab:	40 08 f2             	or     %sil,%dl
  5b10ae:	44 20 c2             	and    %r8b,%dl
  5b10b1:	0f b6 d2             	movzbl %dl,%edx
  5b10b4:	49 8b b5 48 09 00 00 	mov    0x948(%r13),%rsi
  5b10bb:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  5b10bf:	4c 89 57 10          	mov    %r10,0x10(%rdi)
  5b10c3:	4c 89 57 18          	mov    %r10,0x18(%rdi)
  5b10c7:	48 89 4f 20          	mov    %rcx,0x20(%rdi)
  5b10cb:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  5b10cf:	88 47 30             	mov    %al,0x30(%rdi)
  5b10d2:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  5b10d9:	e9 b5 3a 00 00       	jmp    5b4b93 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3f63>
  5b10de:	49 8b 8d 68 08 00 00 	mov    0x868(%r13),%rcx
  5b10e5:	41 0f b6 95 5c 09 00 	movzbl 0x95c(%r13),%edx
  5b10ec:	00 
  5b10ed:	89 d6                	mov    %edx,%esi
  5b10ef:	49 83 bd 80 08 00 00 	cmpq   $0x0,0x880(%r13)
  5b10f6:	00 
  5b10f7:	41 0f 95 c1          	setne  %r9b
  5b10fb:	49 83 bd 60 07 00 00 	cmpq   $0xffffffffffffffff,0x760(%r13)
  5b1102:	ff 
  5b1103:	41 0f 95 c0          	setne  %r8b
  5b1107:	80 f2 01             	xor    $0x1,%dl
  5b110a:	44 08 c2             	or     %r8b,%dl
  5b110d:	44 20 ca             	and    %r9b,%dl
  5b1110:	0f b6 d2             	movzbl %dl,%edx
  5b1113:	4d 8b 85 48 09 00 00 	mov    0x948(%r13),%r8
  5b111a:	4c 89 57 18          	mov    %r10,0x18(%rdi)
  5b111e:	48 89 4f 20          	mov    %rcx,0x20(%rdi)
  5b1122:	40 88 77 30          	mov    %sil,0x30(%rdi)
  5b1126:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  5b112a:	48 89 47 10          	mov    %rax,0x10(%rdi)
  5b112e:	4c 89 47 28          	mov    %r8,0x28(%rdi)
  5b1132:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  5b1139:	e9 55 3a 00 00       	jmp    5b4b93 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3f63>
  5b113e:	66 0f 10 00          	movupd (%rax),%xmm0
  5b1142:	66 0f 29 84 24 a0 09 	movapd %xmm0,0x9a0(%rsp)
  5b1149:	00 00 
  5b114b:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b1152:	00 
  5b1153:	48 8d 8c 24 a0 09 00 	lea    0x9a0(%rsp),%rcx
  5b115a:	00 
  5b115b:	48 8b b4 24 90 00 00 	mov    0x90(%rsp),%rsi
  5b1162:	00 
  5b1163:	ff 15 87 8f 53 00    	call   *0x538f87(%rip)        # aea0f0 <_DYNAMIC+0x390>
  5b1169:	4c 8b b4 24 d0 04 00 	mov    0x4d0(%rsp),%r14
  5b1170:	00 
  5b1171:	44 8b a4 24 d8 04 00 	mov    0x4d8(%rsp),%r12d
  5b1178:	00 
  5b1179:	8b ac 24 dc 04 00 00 	mov    0x4dc(%rsp),%ebp
  5b1180:	49 83 fe 02          	cmp    $0x2,%r14
  5b1184:	75 12                	jne    5b1198 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x568>
  5b1186:	45 89 e5             	mov    %r12d,%r13d
  5b1189:	41 c1 ed 08          	shr    $0x8,%r13d
  5b118d:	41 bf 22 00 00 00    	mov    $0x22,%r15d
  5b1193:	e9 3c 38 00 00       	jmp    5b49d4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3da4>
  5b1198:	48 8d b4 24 e0 04 00 	lea    0x4e0(%rsp),%rsi
  5b119f:	00 
  5b11a0:	48 8d bc 24 80 0e 00 	lea    0xe80(%rsp),%rdi
  5b11a7:	00 
  5b11a8:	ba 18 02 00 00       	mov    $0x218,%edx
  5b11ad:	ff 15 4d 8e 53 00    	call   *0x538e4d(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5b11b3:	4c 89 b4 24 58 0c 00 	mov    %r14,0xc58(%rsp)
  5b11ba:	00 
  5b11bb:	44 89 a4 24 60 0c 00 	mov    %r12d,0xc60(%rsp)
  5b11c2:	00 
  5b11c3:	89 ac 24 64 0c 00 00 	mov    %ebp,0xc64(%rsp)
  5b11ca:	48 8d bc 24 68 0c 00 	lea    0xc68(%rsp),%rdi
  5b11d1:	00 
  5b11d2:	48 8d b4 24 80 0e 00 	lea    0xe80(%rsp),%rsi
  5b11d9:	00 
  5b11da:	ba 18 02 00 00       	mov    $0x218,%edx
  5b11df:	ff 15 1b 8e 53 00    	call   *0x538e1b(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5b11e5:	81 bc 24 90 00 00 00 	cmpl   $0xffff,0x90(%rsp)
  5b11ec:	ff ff 00 00 
  5b11f0:	77 0a                	ja     5b11fc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x5cc>
  5b11f2:	81 7c 24 54 ff ff 00 	cmpl   $0xffff,0x54(%rsp)
  5b11f9:	00 
  5b11fa:	76 1b                	jbe    5b1217 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x5e7>
  5b11fc:	45 31 ed             	xor    %r13d,%r13d
  5b11ff:	45 31 e4             	xor    %r12d,%r12d
  5b1202:	41 bf 22 00 00 00    	mov    $0x22,%r15d
  5b1208:	41 83 fe 02          	cmp    $0x2,%r14d
  5b120c:	0f 85 b5 37 00 00    	jne    5b49c7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3d97>
  5b1212:	e9 bd 37 00 00       	jmp    5b49d4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3da4>
  5b1217:	48 89 9c 24 88 00 00 	mov    %rbx,0x88(%rsp)
  5b121e:	00 
  5b121f:	48 8b 04 24          	mov    (%rsp),%rax
  5b1223:	48 8d 88 98 08 00 00 	lea    0x898(%rax),%rcx
  5b122a:	48 89 8c 24 90 01 00 	mov    %rcx,0x190(%rsp)
  5b1231:	00 
  5b1232:	48 8b 98 98 08 00 00 	mov    0x898(%rax),%rbx
  5b1239:	48 85 db             	test   %rbx,%rbx
  5b123c:	0f 84 da 0c 00 00    	je     5b1f1c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x12ec>
  5b1242:	f0 48 ff 03          	lock incq (%rbx)
  5b1246:	0f 8e c0 0d 00 00    	jle    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b124c:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  5b1253:	00 
  5b1254:	48 8d 84 24 98 00 00 	lea    0x98(%rsp),%rax
  5b125b:	00 
  5b125c:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  5b1263:	00 
  5b1264:	48 c7 84 24 28 01 00 	movq   $0x0,0x128(%rsp)
  5b126b:	00 00 00 00 00 
  5b1270:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b1274:	48 8d 99 e8 02 00 00 	lea    0x2e8(%rcx),%rbx
  5b127b:	80 b9 58 09 00 00 00 	cmpb   $0x0,0x958(%rcx)
  5b1282:	4c 89 bc 24 98 01 00 	mov    %r15,0x198(%rsp)
  5b1289:	00 
  5b128a:	48 89 5c 24 78       	mov    %rbx,0x78(%rsp)
  5b128f:	0f 85 a1 03 00 00    	jne    5b1636 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xa06>
  5b1295:	80 b9 59 09 00 00 00 	cmpb   $0x0,0x959(%rcx)
  5b129c:	0f 85 94 03 00 00    	jne    5b1636 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xa06>
  5b12a2:	80 b9 28 07 00 00 00 	cmpb   $0x0,0x728(%rcx)
  5b12a9:	0f 85 87 03 00 00    	jne    5b1636 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xa06>
  5b12af:	48 8b 81 18 08 00 00 	mov    0x818(%rcx),%rax
  5b12b6:	48 8b 99 28 08 00 00 	mov    0x828(%rcx),%rbx
  5b12bd:	48 85 c0             	test   %rax,%rax
  5b12c0:	0f 95 c1             	setne  %cl
  5b12c3:	48 85 db             	test   %rbx,%rbx
  5b12c6:	0f 95 c2             	setne  %dl
  5b12c9:	20 ca                	and    %cl,%dl
  5b12cb:	80 fa 01             	cmp    $0x1,%dl
  5b12ce:	0f 85 3a 07 00 00    	jne    5b1a0e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xdde>
  5b12d4:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b12d8:	4c 8d a1 48 08 00 00 	lea    0x848(%rcx),%r12
  5b12df:	4c 8b b1 20 08 00 00 	mov    0x820(%rcx),%r14
  5b12e6:	45 31 ff             	xor    %r15d,%r15d
  5b12e9:	48 8d 0d 68 7b 50 00 	lea    0x507b68(%rip),%rcx        # ab8e58 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x60>
  5b12f0:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  5b12f5:	48 8d 0d 74 7b 50 00 	lea    0x507b74(%rip),%rcx        # ab8e70 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x78>
  5b12fc:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  5b1301:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  5b1307:	eb 1d                	jmp    5b1326 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x6f6>
  5b1309:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5b1310:	4c 89 e7             	mov    %r12,%rdi
  5b1313:	e8 08 7a 17 00       	call   728d20 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5b1318:	b8 00 00 00 00       	mov    $0x0,%eax
  5b131d:	48 85 db             	test   %rbx,%rbx
  5b1320:	0f 84 e8 06 00 00    	je     5b1a0e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xdde>
  5b1326:	4d 85 ff             	test   %r15,%r15
  5b1329:	74 25                	je     5b1350 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x720>
  5b132b:	41 0f b7 8f 32 05 00 	movzwl 0x532(%r15),%ecx
  5b1332:	00 
  5b1333:	49 39 ce             	cmp    %rcx,%r14
  5b1336:	0f 83 c4 00 00 00    	jae    5b1400 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x7d0>
  5b133c:	4c 89 f9             	mov    %r15,%rcx
  5b133f:	4c 89 f2             	mov    %r14,%rdx
  5b1342:	e9 e0 00 00 00       	jmp    5b1427 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x7f7>
  5b1347:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5b134e:	00 00 
  5b1350:	4d 85 f6             	test   %r14,%r14
  5b1353:	74 38                	je     5b138d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x75d>
  5b1355:	4c 89 f1             	mov    %r14,%rcx
  5b1358:	49 89 c7             	mov    %rax,%r15
  5b135b:	48 83 e1 07          	and    $0x7,%rcx
  5b135f:	74 31                	je     5b1392 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x762>
  5b1361:	31 d2                	xor    %edx,%edx
  5b1363:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b136a:	84 00 00 00 00 00 
  5b1370:	4d 8b bf 38 05 00 00 	mov    0x538(%r15),%r15
  5b1377:	48 ff c2             	inc    %rdx
  5b137a:	48 39 d1             	cmp    %rdx,%rcx
  5b137d:	75 f1                	jne    5b1370 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x740>
  5b137f:	4c 89 f0             	mov    %r14,%rax
  5b1382:	48 29 d0             	sub    %rdx,%rax
  5b1385:	49 83 fe 08          	cmp    $0x8,%r14
  5b1389:	73 15                	jae    5b13a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x770>
  5b138b:	eb 51                	jmp    5b13de <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x7ae>
  5b138d:	49 89 c7             	mov    %rax,%r15
  5b1390:	eb 4c                	jmp    5b13de <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x7ae>
  5b1392:	4c 89 f0             	mov    %r14,%rax
  5b1395:	49 83 fe 08          	cmp    $0x8,%r14
  5b1399:	72 43                	jb     5b13de <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x7ae>
  5b139b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5b13a0:	49 8b 8f 38 05 00 00 	mov    0x538(%r15),%rcx
  5b13a7:	48 8b 89 38 05 00 00 	mov    0x538(%rcx),%rcx
  5b13ae:	48 8b 89 38 05 00 00 	mov    0x538(%rcx),%rcx
  5b13b5:	48 8b 89 38 05 00 00 	mov    0x538(%rcx),%rcx
  5b13bc:	48 8b 89 38 05 00 00 	mov    0x538(%rcx),%rcx
  5b13c3:	48 8b 89 38 05 00 00 	mov    0x538(%rcx),%rcx
  5b13ca:	48 8b 89 38 05 00 00 	mov    0x538(%rcx),%rcx
  5b13d1:	4c 8b b9 38 05 00 00 	mov    0x538(%rcx),%r15
  5b13d8:	48 83 c0 f8          	add    $0xfffffffffffffff8,%rax
  5b13dc:	75 c2                	jne    5b13a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x770>
  5b13de:	31 c0                	xor    %eax,%eax
  5b13e0:	45 31 f6             	xor    %r14d,%r14d
  5b13e3:	41 0f b7 8f 32 05 00 	movzwl 0x532(%r15),%ecx
  5b13ea:	00 
  5b13eb:	49 39 ce             	cmp    %rcx,%r14
  5b13ee:	0f 82 48 ff ff ff    	jb     5b133c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x70c>
  5b13f4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b13fb:	00 00 00 00 00 
  5b1400:	49 8b 8f d0 04 00 00 	mov    0x4d0(%r15),%rcx
  5b1407:	48 85 c9             	test   %rcx,%rcx
  5b140a:	0f 84 d7 37 00 00    	je     5b4be7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3fb7>
  5b1410:	48 ff c0             	inc    %rax
  5b1413:	41 0f b7 97 30 05 00 	movzwl 0x530(%r15),%edx
  5b141a:	00 
  5b141b:	49 89 cf             	mov    %rcx,%r15
  5b141e:	66 3b 91 32 05 00 00 	cmp    0x532(%rcx),%dx
  5b1425:	73 d9                	jae    5b1400 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x7d0>
  5b1427:	48 85 c0             	test   %rax,%rax
  5b142a:	0f 84 a0 00 00 00    	je     5b14d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x8a0>
  5b1430:	48 8d 34 d1          	lea    (%rcx,%rdx,8),%rsi
  5b1434:	48 81 c6 40 05 00 00 	add    $0x540,%rsi
  5b143b:	48 89 c7             	mov    %rax,%rdi
  5b143e:	48 83 e7 07          	and    $0x7,%rdi
  5b1442:	0f 84 dc 01 00 00    	je     5b1624 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x9f4>
  5b1448:	45 31 c0             	xor    %r8d,%r8d
  5b144b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5b1450:	4c 8b 3e             	mov    (%rsi),%r15
  5b1453:	49 8d b7 38 05 00 00 	lea    0x538(%r15),%rsi
  5b145a:	49 ff c0             	inc    %r8
  5b145d:	4c 39 c7             	cmp    %r8,%rdi
  5b1460:	75 ee                	jne    5b1450 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x820>
  5b1462:	48 89 c7             	mov    %rax,%rdi
  5b1465:	4c 29 c7             	sub    %r8,%rdi
  5b1468:	48 83 f8 08          	cmp    $0x8,%rax
  5b146c:	72 43                	jb     5b14b1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x881>
  5b146e:	66 90                	xchg   %ax,%ax
  5b1470:	48 8b 06             	mov    (%rsi),%rax
  5b1473:	48 8b 80 38 05 00 00 	mov    0x538(%rax),%rax
  5b147a:	48 8b 80 38 05 00 00 	mov    0x538(%rax),%rax
  5b1481:	48 8b 80 38 05 00 00 	mov    0x538(%rax),%rax
  5b1488:	48 8b 80 38 05 00 00 	mov    0x538(%rax),%rax
  5b148f:	48 8b 80 38 05 00 00 	mov    0x538(%rax),%rax
  5b1496:	48 8b 80 38 05 00 00 	mov    0x538(%rax),%rax
  5b149d:	4c 8b b8 38 05 00 00 	mov    0x538(%rax),%r15
  5b14a4:	49 8d b7 38 05 00 00 	lea    0x538(%r15),%rsi
  5b14ab:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  5b14af:	75 bf                	jne    5b1470 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x840>
  5b14b1:	45 31 f6             	xor    %r14d,%r14d
  5b14b4:	48 8b 3c 24          	mov    (%rsp),%rdi
  5b14b8:	48 8b 87 b0 07 00 00 	mov    0x7b0(%rdi),%rax
  5b14bf:	48 85 c0             	test   %rax,%rax
  5b14c2:	75 27                	jne    5b14eb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x8bb>
  5b14c4:	e9 73 38 00 00       	jmp    5b4d3c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x410c>
  5b14c9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5b14d0:	4c 8d 72 01          	lea    0x1(%rdx),%r14
  5b14d4:	49 89 cf             	mov    %rcx,%r15
  5b14d7:	48 8b 3c 24          	mov    (%rsp),%rdi
  5b14db:	48 8b 87 b0 07 00 00 	mov    0x7b0(%rdi),%rax
  5b14e2:	48 85 c0             	test   %rax,%rax
  5b14e5:	0f 84 51 38 00 00    	je     5b4d3c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x410c>
  5b14eb:	48 ff cb             	dec    %rbx
  5b14ee:	48 6b f2 70          	imul   $0x70,%rdx,%rsi
  5b14f2:	48 8b 97 b8 07 00 00 	mov    0x7b8(%rdi),%rdx
  5b14f9:	48 8b 74 31 18       	mov    0x18(%rcx,%rsi,1),%rsi
  5b14fe:	0f b7 b8 ba 00 00 00 	movzwl 0xba(%rax),%edi
  5b1505:	41 89 f8             	mov    %edi,%r8d
  5b1508:	41 c1 e0 03          	shl    $0x3,%r8d
  5b150c:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  5b1513:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b151a:	84 00 00 00 00 00 
  5b1520:	4d 85 c0             	test   %r8,%r8
  5b1523:	74 2b                	je     5b1550 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x920>
  5b1525:	48 3b 74 c8 10       	cmp    0x10(%rax,%rcx,8),%rsi
  5b152a:	41 0f 97 c1          	seta   %r9b
  5b152e:	41 80 d9 00          	sbb    $0x0,%r9b
  5b1532:	48 ff c1             	inc    %rcx
  5b1535:	49 83 c0 f8          	add    $0xfffffffffffffff8,%r8
  5b1539:	41 80 f9 01          	cmp    $0x1,%r9b
  5b153d:	74 e1                	je     5b1520 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x8f0>
  5b153f:	41 0f b6 f9          	movzbl %r9b,%edi
  5b1543:	85 ff                	test   %edi,%edi
  5b1545:	75 0c                	jne    5b1553 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x923>
  5b1547:	eb 27                	jmp    5b1570 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x940>
  5b1549:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5b1550:	48 89 f9             	mov    %rdi,%rcx
  5b1553:	48 83 ea 01          	sub    $0x1,%rdx
  5b1557:	0f 82 df 37 00 00    	jb     5b4d3c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x410c>
  5b155d:	48 8b 84 c8 c0 00 00 	mov    0xc0(%rax,%rcx,8),%rax
  5b1564:	00 
  5b1565:	eb 97                	jmp    5b14fe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x8ce>
  5b1567:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5b156e:	00 00 
  5b1570:	48 8b 7c c8 60       	mov    0x60(%rax,%rcx,8),%rdi
  5b1575:	48 8b 04 24          	mov    (%rsp),%rax
  5b1579:	48 8b a8 c8 02 00 00 	mov    0x2c8(%rax),%rbp
  5b1580:	48 39 ef             	cmp    %rbp,%rdi
  5b1583:	0f 83 5c 38 00 00    	jae    5b4de5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41b5>
  5b1589:	48 8b 88 c0 02 00 00 	mov    0x2c0(%rax),%rcx
  5b1590:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  5b1594:	8b 7c c1 18          	mov    0x18(%rcx,%rax,8),%edi
  5b1598:	4c 39 ef             	cmp    %r13,%rdi
  5b159b:	0f 84 77 fd ff ff    	je     5b1318 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x6e8>
  5b15a1:	48 39 fd             	cmp    %rdi,%rbp
  5b15a4:	0f 86 f0 37 00 00    	jbe    5b4d9a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x416a>
  5b15aa:	49 8b 04 24          	mov    (%r12),%rax
  5b15ae:	48 85 c0             	test   %rax,%rax
  5b15b1:	0f 84 61 fd ff ff    	je     5b1318 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x6e8>
  5b15b7:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  5b15bb:	48 8b 0c d1          	mov    (%rcx,%rdx,8),%rcx
  5b15bf:	48 8b 14 24          	mov    (%rsp),%rdx
  5b15c3:	48 8b 92 50 08 00 00 	mov    0x850(%rdx),%rdx
  5b15ca:	44 0f b7 40 62       	movzwl 0x62(%rax),%r8d
  5b15cf:	45 89 c1             	mov    %r8d,%r9d
  5b15d2:	41 c1 e1 03          	shl    $0x3,%r9d
  5b15d6:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  5b15dd:	0f 1f 00             	nopl   (%rax)
  5b15e0:	4d 85 c9             	test   %r9,%r9
  5b15e3:	74 2b                	je     5b1610 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x9e0>
  5b15e5:	48 3b 4c f8 10       	cmp    0x10(%rax,%rdi,8),%rcx
  5b15ea:	41 0f 97 c2          	seta   %r10b
  5b15ee:	41 80 da 00          	sbb    $0x0,%r10b
  5b15f2:	48 ff c7             	inc    %rdi
  5b15f5:	49 83 c1 f8          	add    $0xfffffffffffffff8,%r9
  5b15f9:	41 80 fa 01          	cmp    $0x1,%r10b
  5b15fd:	74 e1                	je     5b15e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x9b0>
  5b15ff:	45 0f b6 c2          	movzbl %r10b,%r8d
  5b1603:	45 85 c0             	test   %r8d,%r8d
  5b1606:	0f 84 04 fd ff ff    	je     5b1310 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x6e0>
  5b160c:	eb 05                	jmp    5b1613 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x9e3>
  5b160e:	66 90                	xchg   %ax,%ax
  5b1610:	4c 89 c7             	mov    %r8,%rdi
  5b1613:	48 83 ea 01          	sub    $0x1,%rdx
  5b1617:	0f 82 fb fc ff ff    	jb     5b1318 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x6e8>
  5b161d:	48 8b 44 f8 68       	mov    0x68(%rax,%rdi,8),%rax
  5b1622:	eb a6                	jmp    5b15ca <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x99a>
  5b1624:	48 89 c7             	mov    %rax,%rdi
  5b1627:	48 83 f8 08          	cmp    $0x8,%rax
  5b162b:	0f 82 80 fe ff ff    	jb     5b14b1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x881>
  5b1631:	e9 3a fe ff ff       	jmp    5b1470 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x840>
  5b1636:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b163d:	00 
  5b163e:	ff 15 a4 8a 53 00    	call   *0x538aa4(%rip)        # aea0e8 <_DYNAMIC+0x388>
  5b1644:	48 89 df             	mov    %rbx,%rdi
  5b1647:	e8 14 57 f8 ff       	call   536d60 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs1rQ3kaVqKLB_20gpui_reactivity_core6layout10LayoutTreeECs6gaF1xUz9Bf_4gpui>
  5b164c:	48 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%rsi
  5b1653:	00 
  5b1654:	ba 48 04 00 00       	mov    $0x448,%edx
  5b1659:	48 89 df             	mov    %rbx,%rdi
  5b165c:	ff 15 9e 89 53 00    	call   *0x53899e(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5b1662:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b1666:	48 c7 81 40 07 00 00 	movq   $0x0,0x740(%rcx)
  5b166d:	00 00 00 00 
  5b1671:	48 8b 81 c8 02 00 00 	mov    0x2c8(%rcx),%rax
  5b1678:	48 85 c0             	test   %rax,%rax
  5b167b:	0f 84 5d 0b 00 00    	je     5b21de <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x15ae>
  5b1681:	48 8d 91 30 07 00 00 	lea    0x730(%rcx),%rdx
  5b1688:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  5b168d:	48 8b 99 c0 02 00 00 	mov    0x2c0(%rcx),%rbx
  5b1694:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  5b1698:	48 8d 04 c3          	lea    (%rbx,%rax,8),%rax
  5b169c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5b16a1:	4c 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%r15
  5b16a8:	00 
  5b16a9:	48 8d 05 48 73 50 00 	lea    0x507348(%rip),%rax        # ab89f8 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x90>
  5b16b0:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  5b16b5:	31 ed                	xor    %ebp,%ebp
  5b16b7:	45 31 ed             	xor    %r13d,%r13d
  5b16ba:	eb 40                	jmp    5b16fc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xacc>
  5b16bc:	0f 1f 40 00          	nopl   0x0(%rax)
  5b16c0:	48 83 c3 28          	add    $0x28,%rbx
  5b16c4:	49 ff c5             	inc    %r13
  5b16c7:	48 8b 14 24          	mov    (%rsp),%rdx
  5b16cb:	48 8b 82 38 07 00 00 	mov    0x738(%rdx),%rax
  5b16d2:	48 89 e9             	mov    %rbp,%rcx
  5b16d5:	48 c1 e1 04          	shl    $0x4,%rcx
  5b16d9:	66 0f 28 84 24 60 04 	movapd 0x460(%rsp),%xmm0
  5b16e0:	00 00 
  5b16e2:	66 0f 11 04 08       	movupd %xmm0,(%rax,%rcx,1)
  5b16e7:	48 ff c5             	inc    %rbp
  5b16ea:	48 89 aa 40 07 00 00 	mov    %rbp,0x740(%rdx)
  5b16f1:	48 3b 5c 24 30       	cmp    0x30(%rsp),%rbx
  5b16f6:	0f 84 e4 0a 00 00    	je     5b21e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x15b0>
  5b16fc:	8b 7b 18             	mov    0x18(%rbx),%edi
  5b16ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  5b1704:	48 39 c7             	cmp    %rax,%rdi
  5b1707:	74 51                	je     5b175a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xb2a>
  5b1709:	48 39 fd             	cmp    %rdi,%rbp
  5b170c:	0f 86 d3 36 00 00    	jbe    5b4de5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41b5>
  5b1712:	48 8b 04 24          	mov    (%rsp),%rax
  5b1716:	48 8b 80 38 07 00 00 	mov    0x738(%rax),%rax
  5b171d:	48 89 f9             	mov    %rdi,%rcx
  5b1720:	48 c1 e1 04          	shl    $0x4,%rcx
  5b1724:	66 0f 10 04 08       	movupd (%rax,%rcx,1),%xmm0
  5b1729:	48 8d 84 24 20 09 00 	lea    0x920(%rsp),%rax
  5b1730:	00 
  5b1731:	66 0f 11 00          	movupd %xmm0,(%rax)
  5b1735:	b8 01 00 00 00       	mov    $0x1,%eax
  5b173a:	48 89 84 24 18 09 00 	mov    %rax,0x918(%rsp)
  5b1741:	00 
  5b1742:	8b 4b 20             	mov    0x20(%rbx),%ecx
  5b1745:	83 e1 07             	and    $0x7,%ecx
  5b1748:	31 c0                	xor    %eax,%eax
  5b174a:	48 8d 15 4b d1 ab ff 	lea    -0x542eb5(%rip),%rdx        # 6e89c <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x80c>
  5b1751:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
  5b1755:	48 01 d1             	add    %rdx,%rcx
  5b1758:	ff e1                	jmp    *%rcx
  5b175a:	31 c0                	xor    %eax,%eax
  5b175c:	48 89 84 24 18 09 00 	mov    %rax,0x918(%rsp)
  5b1763:	00 
  5b1764:	8b 4b 20             	mov    0x20(%rbx),%ecx
  5b1767:	83 e1 07             	and    $0x7,%ecx
  5b176a:	31 c0                	xor    %eax,%eax
  5b176c:	48 8d 15 29 d1 ab ff 	lea    -0x542ed7(%rip),%rdx        # 6e89c <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x80c>
  5b1773:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
  5b1777:	48 01 d1             	add    %rdx,%rcx
  5b177a:	ff e1                	jmp    *%rcx
  5b177c:	b0 01                	mov    $0x1,%al
  5b177e:	eb 20                	jmp    5b17a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xb70>
  5b1780:	b0 05                	mov    $0x5,%al
  5b1782:	eb 1c                	jmp    5b17a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xb70>
  5b1784:	b0 06                	mov    $0x6,%al
  5b1786:	eb 18                	jmp    5b17a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xb70>
  5b1788:	b0 02                	mov    $0x2,%al
  5b178a:	eb 14                	jmp    5b17a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xb70>
  5b178c:	b0 04                	mov    $0x4,%al
  5b178e:	eb 10                	jmp    5b17a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xb70>
  5b1790:	b0 03                	mov    $0x3,%al
  5b1792:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b1799:	1f 84 00 00 00 00 00 
  5b17a0:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b17a4:	48 8b 89 28 02 00 00 	mov    0x228(%rcx),%rcx
  5b17ab:	48 8d 15 86 a2 ac ff 	lea    -0x535d7a(%rip),%rdx        # 7ba38 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x8>
  5b17b2:	48 85 c9             	test   %rcx,%rcx
  5b17b5:	74 44                	je     5b17fb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xbcb>
  5b17b7:	83 f9 02             	cmp    $0x2,%ecx
  5b17ba:	0f 85 91 00 00 00    	jne    5b1851 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xc21>
  5b17c0:	48 8b 34 24          	mov    (%rsp),%rsi
  5b17c4:	48 8b ae 48 02 00 00 	mov    0x248(%rsi),%rbp
  5b17cb:	49 39 ed             	cmp    %rbp,%r13
  5b17ce:	0f 83 f6 35 00 00    	jae    5b4dca <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x419a>
  5b17d4:	48 8b ae 38 02 00 00 	mov    0x238(%rsi),%rbp
  5b17db:	48 8b 96 40 02 00 00 	mov    0x240(%rsi),%rdx
  5b17e2:	42 0f b6 14 2a       	movzbl (%rdx,%r13,1),%edx
  5b17e7:	48 39 d5             	cmp    %rdx,%rbp
  5b17ea:	0f 86 e6 35 00 00    	jbe    5b4dd6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41a6>
  5b17f0:	48 6b d2 58          	imul   $0x58,%rdx,%rdx
  5b17f4:	48 03 96 30 02 00 00 	add    0x230(%rsi),%rdx
  5b17fb:	83 ff ff             	cmp    $0xffffffff,%edi
  5b17fe:	74 75                	je     5b1875 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xc45>
  5b1800:	48 8d 35 31 a2 ac ff 	lea    -0x535dcf(%rip),%rsi        # 7ba38 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x8>
  5b1807:	48 85 c9             	test   %rcx,%rcx
  5b180a:	0f 84 9b 00 00 00    	je     5b18ab <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xc7b>
  5b1810:	83 f9 02             	cmp    $0x2,%ecx
  5b1813:	75 77                	jne    5b188c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xc5c>
  5b1815:	4c 8b 04 24          	mov    (%rsp),%r8
  5b1819:	49 8b a8 48 02 00 00 	mov    0x248(%r8),%rbp
  5b1820:	48 39 fd             	cmp    %rdi,%rbp
  5b1823:	0f 86 8c 35 00 00    	jbe    5b4db5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4185>
  5b1829:	49 8b a8 38 02 00 00 	mov    0x238(%r8),%rbp
  5b1830:	49 8b 88 40 02 00 00 	mov    0x240(%r8),%rcx
  5b1837:	0f b6 3c 39          	movzbl (%rcx,%rdi,1),%edi
  5b183b:	48 39 fd             	cmp    %rdi,%rbp
  5b183e:	0f 86 95 35 00 00    	jbe    5b4dd9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41a9>
  5b1844:	48 6b f7 58          	imul   $0x58,%rdi,%rsi
  5b1848:	49 03 b0 30 02 00 00 	add    0x230(%r8),%rsi
  5b184f:	eb 5a                	jmp    5b18ab <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xc7b>
  5b1851:	48 8b 34 24          	mov    (%rsp),%rsi
  5b1855:	48 8b ae 40 02 00 00 	mov    0x240(%rsi),%rbp
  5b185c:	49 39 ed             	cmp    %rbp,%r13
  5b185f:	0f 83 59 35 00 00    	jae    5b4dbe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x418e>
  5b1865:	49 6b d5 58          	imul   $0x58,%r13,%rdx
  5b1869:	48 03 96 38 02 00 00 	add    0x238(%rsi),%rdx
  5b1870:	83 ff ff             	cmp    $0xffffffff,%edi
  5b1873:	75 8b                	jne    5b1800 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xbd0>
  5b1875:	b1 02                	mov    $0x2,%cl
  5b1877:	48 8b 3c 24          	mov    (%rsp),%rdi
  5b187b:	4c 8b 87 30 08 00 00 	mov    0x830(%rdi),%r8
  5b1882:	4d 85 c0             	test   %r8,%r8
  5b1885:	75 38                	jne    5b18bf <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xc8f>
  5b1887:	e9 b0 00 00 00       	jmp    5b193c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xd0c>
  5b188c:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b1890:	48 8b a9 40 02 00 00 	mov    0x240(%rcx),%rbp
  5b1897:	48 39 fd             	cmp    %rdi,%rbp
  5b189a:	0f 86 0c 35 00 00    	jbe    5b4dac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x417c>
  5b18a0:	48 6b f7 58          	imul   $0x58,%rdi,%rsi
  5b18a4:	48 03 b1 38 02 00 00 	add    0x238(%rcx),%rsi
  5b18ab:	0f b6 4e 54          	movzbl 0x54(%rsi),%ecx
  5b18af:	48 8b 3c 24          	mov    (%rsp),%rdi
  5b18b3:	4c 8b 87 30 08 00 00 	mov    0x830(%rdi),%r8
  5b18ba:	4d 85 c0             	test   %r8,%r8
  5b18bd:	74 7d                	je     5b193c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xd0c>
  5b18bf:	48 8b 33             	mov    (%rbx),%rsi
  5b18c2:	48 8b bf 38 08 00 00 	mov    0x838(%rdi),%rdi
  5b18c9:	45 0f b7 90 c2 01 00 	movzwl 0x1c2(%r8),%r10d
  5b18d0:	00 
  5b18d1:	45 89 d6             	mov    %r10d,%r14d
  5b18d4:	41 c1 e6 05          	shl    $0x5,%r14d
  5b18d8:	49 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%r9
  5b18df:	45 31 db             	xor    %r11d,%r11d
  5b18e2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b18e9:	1f 84 00 00 00 00 00 
  5b18f0:	4d 89 f4             	mov    %r14,%r12
  5b18f3:	4d 01 dc             	add    %r11,%r12
  5b18f6:	74 28                	je     5b1920 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xcf0>
  5b18f8:	4b 3b b4 c8 70 01 00 	cmp    0x170(%r8,%r9,8),%rsi
  5b18ff:	00 
  5b1900:	40 0f 97 c5          	seta   %bpl
  5b1904:	40 80 dd 00          	sbb    $0x0,%bpl
  5b1908:	49 83 c3 e0          	add    $0xffffffffffffffe0,%r11
  5b190c:	49 ff c1             	inc    %r9
  5b190f:	40 80 fd 01          	cmp    $0x1,%bpl
  5b1913:	74 db                	je     5b18f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xcc0>
  5b1915:	44 0f b6 d5          	movzbl %bpl,%r10d
  5b1919:	45 85 d2             	test   %r10d,%r10d
  5b191c:	75 05                	jne    5b1923 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xcf3>
  5b191e:	eb 13                	jmp    5b1933 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xd03>
  5b1920:	4d 89 d1             	mov    %r10,%r9
  5b1923:	48 83 ef 01          	sub    $0x1,%rdi
  5b1927:	72 13                	jb     5b193c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xd0c>
  5b1929:	4f 8b 84 c8 c8 01 00 	mov    0x1c8(%r8,%r9,8),%r8
  5b1930:	00 
  5b1931:	eb 96                	jmp    5b18c9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xc99>
  5b1933:	4d 29 d8             	sub    %r11,%r8
  5b1936:	49 83 c0 e0          	add    $0xffffffffffffffe0,%r8
  5b193a:	eb 03                	jmp    5b193f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xd0f>
  5b193c:	45 31 c0             	xor    %r8d,%r8d
  5b193f:	0f b6 f0             	movzbl %al,%esi
  5b1942:	0f b6 c9             	movzbl %cl,%ecx
  5b1945:	4c 89 ff             	mov    %r15,%rdi
  5b1948:	e8 d3 e3 21 00       	call   7cfd20 <_RNvNtNtCs6gaF1xUz9Bf_4gpui7runtime4list9row_style>
  5b194d:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b1954:	00 
  5b1955:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  5b195a:	48 8d 94 24 18 09 00 	lea    0x918(%rsp),%rdx
  5b1961:	00 
  5b1962:	31 c9                	xor    %ecx,%ecx
  5b1964:	4d 89 f8             	mov    %r15,%r8
  5b1967:	ff 15 93 87 53 00    	call   *0x538793(%rip)        # aea100 <_DYNAMIC+0x3a0>
  5b196d:	80 bc 24 a0 09 00 00 	cmpb   $0x0,0x9a0(%rsp)
  5b1974:	00 
  5b1975:	0f 85 74 10 00 00    	jne    5b29ef <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1dbf>
  5b197b:	48 8d 84 24 a8 09 00 	lea    0x9a8(%rsp),%rax
  5b1982:	00 
  5b1983:	0f 10 00             	movups (%rax),%xmm0
  5b1986:	48 8d 84 24 76 04 00 	lea    0x476(%rsp),%rax
  5b198d:	00 
  5b198e:	0f 11 00             	movups %xmm0,(%rax)
  5b1991:	66 0f 10 00          	movupd (%rax),%xmm0
  5b1995:	66 0f 29 84 24 60 04 	movapd %xmm0,0x460(%rsp)
  5b199c:	00 00 
  5b199e:	8b 43 20             	mov    0x20(%rbx),%eax
  5b19a1:	89 c1                	mov    %eax,%ecx
  5b19a3:	83 e1 07             	and    $0x7,%ecx
  5b19a6:	83 f9 06             	cmp    $0x6,%ecx
  5b19a9:	73 07                	jae    5b19b2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xd82>
  5b19ab:	83 f8 07             	cmp    $0x7,%eax
  5b19ae:	77 08                	ja     5b19b8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xd88>
  5b19b0:	eb 35                	jmp    5b19e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xdb7>
  5b19b2:	0f 85 ed 31 00 00    	jne    5b4ba5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3f75>
  5b19b8:	66 0f 28 84 24 60 04 	movapd 0x460(%rsp),%xmm0
  5b19bf:	00 00 
  5b19c1:	66 0f 29 84 24 d0 04 	movapd %xmm0,0x4d0(%rsp)
  5b19c8:	00 00 
  5b19ca:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
  5b19cf:	4c 89 fe             	mov    %r15,%rsi
  5b19d2:	48 8d 15 17 c6 0a 00 	lea    0xac617(%rip),%rdx        # 65dff0 <_RNvNtCs6gaF1xUz9Bf_4gpui7runtime14measure_marker>
  5b19d9:	ff 15 29 87 53 00    	call   *0x538729(%rip)        # aea108 <_DYNAMIC+0x3a8>
  5b19df:	a8 01                	test   $0x1,%al
  5b19e1:	0f 85 80 0c 00 00    	jne    5b2667 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1a37>
  5b19e7:	48 8b 04 24          	mov    (%rsp),%rax
  5b19eb:	48 8b a8 40 07 00 00 	mov    0x740(%rax),%rbp
  5b19f2:	48 3b a8 30 07 00 00 	cmp    0x730(%rax),%rbp
  5b19f9:	0f 85 c1 fc ff ff    	jne    5b16c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xa90>
  5b19ff:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  5b1a04:	e8 a7 bb 21 00       	call   7cd5b0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecAINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdEj2_E8grow_oneB1s_>
  5b1a09:	e9 b2 fc ff ff       	jmp    5b16c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xa90>
  5b1a0e:	48 8b 04 24          	mov    (%rsp),%rax
  5b1a12:	48 8b 90 48 08 00 00 	mov    0x848(%rax),%rdx
  5b1a19:	4c 8b a8 58 08 00 00 	mov    0x858(%rax),%r13
  5b1a20:	48 85 d2             	test   %rdx,%rdx
  5b1a23:	0f 95 c0             	setne  %al
  5b1a26:	4d 85 ed             	test   %r13,%r13
  5b1a29:	0f 95 c1             	setne  %cl
  5b1a2c:	20 c1                	and    %al,%cl
  5b1a2e:	80 f9 01             	cmp    $0x1,%cl
  5b1a31:	0f 85 c1 06 00 00    	jne    5b20f8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x14c8>
  5b1a37:	48 8b 04 24          	mov    (%rsp),%rax
  5b1a3b:	48 8b b0 50 08 00 00 	mov    0x850(%rax),%rsi
  5b1a42:	45 31 ff             	xor    %r15d,%r15d
  5b1a45:	48 8d 05 c4 73 50 00 	lea    0x5073c4(%rip),%rax        # ab8e10 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x18>
  5b1a4c:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b1a51:	48 8d 05 d0 73 50 00 	lea    0x5073d0(%rip),%rax        # ab8e28 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x30>
  5b1a58:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  5b1a5d:	4c 8d 35 d4 9f ac ff 	lea    -0x53602c(%rip),%r14        # 7ba38 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x8>
  5b1a64:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b1a6b:	00 00 00 00 00 
  5b1a70:	4d 85 ff             	test   %r15,%r15
  5b1a73:	74 19                	je     5b1a8e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xe5e>
  5b1a75:	41 0f b7 47 62       	movzwl 0x62(%r15),%eax
  5b1a7a:	48 39 c6             	cmp    %rax,%rsi
  5b1a7d:	0f 83 9d 00 00 00    	jae    5b1b20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xef0>
  5b1a83:	4c 89 f8             	mov    %r15,%rax
  5b1a86:	48 89 f1             	mov    %rsi,%rcx
  5b1a89:	e9 af 00 00 00       	jmp    5b1b3d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xf0d>
  5b1a8e:	48 85 f6             	test   %rsi,%rsi
  5b1a91:	74 37                	je     5b1aca <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xe9a>
  5b1a93:	48 89 f0             	mov    %rsi,%rax
  5b1a96:	49 89 d7             	mov    %rdx,%r15
  5b1a99:	48 83 e0 07          	and    $0x7,%rax
  5b1a9d:	74 30                	je     5b1acf <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xe9f>
  5b1a9f:	31 c9                	xor    %ecx,%ecx
  5b1aa1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b1aa8:	0f 1f 84 00 00 00 00 
  5b1aaf:	00 
  5b1ab0:	4d 8b 7f 68          	mov    0x68(%r15),%r15
  5b1ab4:	48 ff c1             	inc    %rcx
  5b1ab7:	48 39 c8             	cmp    %rcx,%rax
  5b1aba:	75 f4                	jne    5b1ab0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xe80>
  5b1abc:	48 89 f0             	mov    %rsi,%rax
  5b1abf:	48 29 c8             	sub    %rcx,%rax
  5b1ac2:	48 83 fe 08          	cmp    $0x8,%rsi
  5b1ac6:	73 18                	jae    5b1ae0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xeb0>
  5b1ac8:	eb 3c                	jmp    5b1b06 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xed6>
  5b1aca:	49 89 d7             	mov    %rdx,%r15
  5b1acd:	eb 37                	jmp    5b1b06 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xed6>
  5b1acf:	48 89 f0             	mov    %rsi,%rax
  5b1ad2:	48 83 fe 08          	cmp    $0x8,%rsi
  5b1ad6:	72 2e                	jb     5b1b06 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xed6>
  5b1ad8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5b1adf:	00 
  5b1ae0:	49 8b 4f 68          	mov    0x68(%r15),%rcx
  5b1ae4:	48 8b 49 68          	mov    0x68(%rcx),%rcx
  5b1ae8:	48 8b 49 68          	mov    0x68(%rcx),%rcx
  5b1aec:	48 8b 49 68          	mov    0x68(%rcx),%rcx
  5b1af0:	48 8b 49 68          	mov    0x68(%rcx),%rcx
  5b1af4:	48 8b 49 68          	mov    0x68(%rcx),%rcx
  5b1af8:	48 8b 49 68          	mov    0x68(%rcx),%rcx
  5b1afc:	4c 8b 79 68          	mov    0x68(%rcx),%r15
  5b1b00:	48 83 c0 f8          	add    $0xfffffffffffffff8,%rax
  5b1b04:	75 da                	jne    5b1ae0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xeb0>
  5b1b06:	31 d2                	xor    %edx,%edx
  5b1b08:	31 f6                	xor    %esi,%esi
  5b1b0a:	41 0f b7 47 62       	movzwl 0x62(%r15),%eax
  5b1b0f:	48 39 c6             	cmp    %rax,%rsi
  5b1b12:	0f 82 6b ff ff ff    	jb     5b1a83 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xe53>
  5b1b18:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5b1b1f:	00 
  5b1b20:	49 8b 07             	mov    (%r15),%rax
  5b1b23:	48 85 c0             	test   %rax,%rax
  5b1b26:	0f 84 dd 31 00 00    	je     5b4d09 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x40d9>
  5b1b2c:	48 ff c2             	inc    %rdx
  5b1b2f:	41 0f b7 4f 60       	movzwl 0x60(%r15),%ecx
  5b1b34:	49 89 c7             	mov    %rax,%r15
  5b1b37:	66 3b 48 62          	cmp    0x62(%rax),%cx
  5b1b3b:	73 e3                	jae    5b1b20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xef0>
  5b1b3d:	48 85 d2             	test   %rdx,%rdx
  5b1b40:	0f 84 7b 00 00 00    	je     5b1bc1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xf91>
  5b1b46:	48 8d 34 c8          	lea    (%rax,%rcx,8),%rsi
  5b1b4a:	48 83 c6 70          	add    $0x70,%rsi
  5b1b4e:	48 89 d7             	mov    %rdx,%rdi
  5b1b51:	48 83 e7 07          	and    $0x7,%rdi
  5b1b55:	0f 84 71 01 00 00    	je     5b1ccc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x109c>
  5b1b5b:	45 31 c0             	xor    %r8d,%r8d
  5b1b5e:	66 90                	xchg   %ax,%ax
  5b1b60:	4c 8b 3e             	mov    (%rsi),%r15
  5b1b63:	49 8d 77 68          	lea    0x68(%r15),%rsi
  5b1b67:	49 ff c0             	inc    %r8
  5b1b6a:	4c 39 c7             	cmp    %r8,%rdi
  5b1b6d:	75 f1                	jne    5b1b60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xf30>
  5b1b6f:	48 89 d7             	mov    %rdx,%rdi
  5b1b72:	4c 29 c7             	sub    %r8,%rdi
  5b1b75:	48 83 fa 08          	cmp    $0x8,%rdx
  5b1b79:	72 2e                	jb     5b1ba9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xf79>
  5b1b7b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5b1b80:	48 8b 16             	mov    (%rsi),%rdx
  5b1b83:	48 8b 52 68          	mov    0x68(%rdx),%rdx
  5b1b87:	48 8b 52 68          	mov    0x68(%rdx),%rdx
  5b1b8b:	48 8b 52 68          	mov    0x68(%rdx),%rdx
  5b1b8f:	48 8b 52 68          	mov    0x68(%rdx),%rdx
  5b1b93:	48 8b 52 68          	mov    0x68(%rdx),%rdx
  5b1b97:	48 8b 52 68          	mov    0x68(%rdx),%rdx
  5b1b9b:	4c 8b 7a 68          	mov    0x68(%rdx),%r15
  5b1b9f:	49 8d 77 68          	lea    0x68(%r15),%rsi
  5b1ba3:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  5b1ba7:	75 d7                	jne    5b1b80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xf50>
  5b1ba9:	45 31 e4             	xor    %r12d,%r12d
  5b1bac:	48 8b 34 24          	mov    (%rsp),%rsi
  5b1bb0:	48 8b 96 b0 07 00 00 	mov    0x7b0(%rsi),%rdx
  5b1bb7:	48 85 d2             	test   %rdx,%rdx
  5b1bba:	75 20                	jne    5b1bdc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xfac>
  5b1bbc:	e9 7b 31 00 00       	jmp    5b4d3c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x410c>
  5b1bc1:	4c 8d 61 01          	lea    0x1(%rcx),%r12
  5b1bc5:	49 89 c7             	mov    %rax,%r15
  5b1bc8:	48 8b 34 24          	mov    (%rsp),%rsi
  5b1bcc:	48 8b 96 b0 07 00 00 	mov    0x7b0(%rsi),%rdx
  5b1bd3:	48 85 d2             	test   %rdx,%rdx
  5b1bd6:	0f 84 60 31 00 00    	je     5b4d3c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x410c>
  5b1bdc:	49 ff cd             	dec    %r13
  5b1bdf:	48 8b b6 b8 07 00 00 	mov    0x7b8(%rsi),%rsi
  5b1be6:	48 8b 7c c8 08       	mov    0x8(%rax,%rcx,8),%rdi
  5b1beb:	44 0f b7 8a ba 00 00 	movzwl 0xba(%rdx),%r9d
  5b1bf2:	00 
  5b1bf3:	45 89 ca             	mov    %r9d,%r10d
  5b1bf6:	41 c1 e2 03          	shl    $0x3,%r10d
  5b1bfa:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  5b1c01:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b1c08:	0f 1f 84 00 00 00 00 
  5b1c0f:	00 
  5b1c10:	4d 85 d2             	test   %r10,%r10
  5b1c13:	74 2b                	je     5b1c40 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1010>
  5b1c15:	4a 3b 7c c2 10       	cmp    0x10(%rdx,%r8,8),%rdi
  5b1c1a:	41 0f 97 c3          	seta   %r11b
  5b1c1e:	41 80 db 00          	sbb    $0x0,%r11b
  5b1c22:	49 ff c0             	inc    %r8
  5b1c25:	49 83 c2 f8          	add    $0xfffffffffffffff8,%r10
  5b1c29:	41 80 fb 01          	cmp    $0x1,%r11b
  5b1c2d:	74 e1                	je     5b1c10 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xfe0>
  5b1c2f:	45 0f b6 cb          	movzbl %r11b,%r9d
  5b1c33:	45 85 c9             	test   %r9d,%r9d
  5b1c36:	75 0b                	jne    5b1c43 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1013>
  5b1c38:	eb 26                	jmp    5b1c60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1030>
  5b1c3a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5b1c40:	4d 89 c8             	mov    %r9,%r8
  5b1c43:	48 83 ee 01          	sub    $0x1,%rsi
  5b1c47:	0f 82 ef 30 00 00    	jb     5b4d3c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x410c>
  5b1c4d:	4a 8b 94 c2 c0 00 00 	mov    0xc0(%rdx,%r8,8),%rdx
  5b1c54:	00 
  5b1c55:	eb 94                	jmp    5b1beb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xfbb>
  5b1c57:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5b1c5e:	00 00 
  5b1c60:	4a 8b 7c c2 60       	mov    0x60(%rdx,%r8,8),%rdi
  5b1c65:	4c 8b 04 24          	mov    (%rsp),%r8
  5b1c69:	49 8b a8 40 07 00 00 	mov    0x740(%r8),%rbp
  5b1c70:	48 39 ef             	cmp    %rbp,%rdi
  5b1c73:	0f 83 6c 31 00 00    	jae    5b4de5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41b5>
  5b1c79:	49 8b 90 38 07 00 00 	mov    0x738(%r8),%rdx
  5b1c80:	48 89 fe             	mov    %rdi,%rsi
  5b1c83:	48 c1 e6 04          	shl    $0x4,%rsi
  5b1c87:	66 0f 10 04 32       	movupd (%rdx,%rsi,1),%xmm0
  5b1c8c:	66 0f 29 84 24 70 04 	movapd %xmm0,0x470(%rsp)
  5b1c93:	00 00 
  5b1c95:	49 8b a8 c8 02 00 00 	mov    0x2c8(%r8),%rbp
  5b1c9c:	48 39 ef             	cmp    %rbp,%rdi
  5b1c9f:	0f 83 fe 30 00 00    	jae    5b4da3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4173>
  5b1ca5:	4d 8b 80 c0 02 00 00 	mov    0x2c0(%r8),%r8
  5b1cac:	4c 8d 0c bf          	lea    (%rdi,%rdi,4),%r9
  5b1cb0:	43 8b 54 c8 20       	mov    0x20(%r8,%r9,8),%edx
  5b1cb5:	83 e2 07             	and    $0x7,%edx
  5b1cb8:	48 8d 35 bd cb ab ff 	lea    -0x543443(%rip),%rsi        # 6e87c <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x7ec>
  5b1cbf:	48 63 14 96          	movslq (%rsi,%rdx,4),%rdx
  5b1cc3:	48 01 f2             	add    %rsi,%rdx
  5b1cc6:	ff e2                	jmp    *%rdx
  5b1cc8:	31 f6                	xor    %esi,%esi
  5b1cca:	eb 34                	jmp    5b1d00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x10d0>
  5b1ccc:	48 89 d7             	mov    %rdx,%rdi
  5b1ccf:	48 83 fa 08          	cmp    $0x8,%rdx
  5b1cd3:	0f 83 a7 fe ff ff    	jae    5b1b80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xf50>
  5b1cd9:	e9 cb fe ff ff       	jmp    5b1ba9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xf79>
  5b1cde:	40 b6 05             	mov    $0x5,%sil
  5b1ce1:	eb 1d                	jmp    5b1d00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x10d0>
  5b1ce3:	40 b6 06             	mov    $0x6,%sil
  5b1ce6:	eb 18                	jmp    5b1d00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x10d0>
  5b1ce8:	40 b6 02             	mov    $0x2,%sil
  5b1ceb:	eb 13                	jmp    5b1d00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x10d0>
  5b1ced:	40 b6 01             	mov    $0x1,%sil
  5b1cf0:	eb 0e                	jmp    5b1d00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x10d0>
  5b1cf2:	40 b6 04             	mov    $0x4,%sil
  5b1cf5:	eb 09                	jmp    5b1d00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x10d0>
  5b1cf7:	40 b6 03             	mov    $0x3,%sil
  5b1cfa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5b1d00:	48 8b 14 24          	mov    (%rsp),%rdx
  5b1d04:	4c 8b 92 28 02 00 00 	mov    0x228(%rdx),%r10
  5b1d0b:	4c 89 f2             	mov    %r14,%rdx
  5b1d0e:	4d 85 d2             	test   %r10,%r10
  5b1d11:	74 61                	je     5b1d74 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1144>
  5b1d13:	41 83 fa 02          	cmp    $0x2,%r10d
  5b1d17:	75 3c                	jne    5b1d55 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1125>
  5b1d19:	4c 8b 1c 24          	mov    (%rsp),%r11
  5b1d1d:	49 8b ab 48 02 00 00 	mov    0x248(%r11),%rbp
  5b1d24:	48 39 ef             	cmp    %rbp,%rdi
  5b1d27:	0f 83 88 30 00 00    	jae    5b4db5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4185>
  5b1d2d:	49 8b ab 38 02 00 00 	mov    0x238(%r11),%rbp
  5b1d34:	49 8b 93 40 02 00 00 	mov    0x240(%r11),%rdx
  5b1d3b:	0f b6 3c 3a          	movzbl (%rdx,%rdi,1),%edi
  5b1d3f:	48 39 fd             	cmp    %rdi,%rbp
  5b1d42:	0f 86 91 30 00 00    	jbe    5b4dd9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41a9>
  5b1d48:	48 6b d7 58          	imul   $0x58,%rdi,%rdx
  5b1d4c:	49 03 93 30 02 00 00 	add    0x230(%r11),%rdx
  5b1d53:	eb 1f                	jmp    5b1d74 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1144>
  5b1d55:	4c 8b 1c 24          	mov    (%rsp),%r11
  5b1d59:	49 8b ab 40 02 00 00 	mov    0x240(%r11),%rbp
  5b1d60:	48 39 ef             	cmp    %rbp,%rdi
  5b1d63:	0f 83 43 30 00 00    	jae    5b4dac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x417c>
  5b1d69:	48 6b d7 58          	imul   $0x58,%rdi,%rdx
  5b1d6d:	49 03 93 38 02 00 00 	add    0x238(%r11),%rdx
  5b1d74:	4b 8d 3c c8          	lea    (%r8,%r9,8),%rdi
  5b1d78:	8b 7f 18             	mov    0x18(%rdi),%edi
  5b1d7b:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
  5b1d81:	4c 39 c7             	cmp    %r8,%rdi
  5b1d84:	74 4b                	je     5b1dd1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x11a1>
  5b1d86:	4d 89 f0             	mov    %r14,%r8
  5b1d89:	4d 85 d2             	test   %r10,%r10
  5b1d8c:	74 67                	je     5b1df5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x11c5>
  5b1d8e:	41 83 fa 02          	cmp    $0x2,%r10d
  5b1d92:	75 42                	jne    5b1dd6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x11a6>
  5b1d94:	4c 8b 0c 24          	mov    (%rsp),%r9
  5b1d98:	49 8b a9 48 02 00 00 	mov    0x248(%r9),%rbp
  5b1d9f:	48 39 fd             	cmp    %rdi,%rbp
  5b1da2:	0f 86 0d 30 00 00    	jbe    5b4db5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4185>
  5b1da8:	49 8b a9 38 02 00 00 	mov    0x238(%r9),%rbp
  5b1daf:	4d 8b 81 40 02 00 00 	mov    0x240(%r9),%r8
  5b1db6:	41 0f b6 3c 38       	movzbl (%r8,%rdi,1),%edi
  5b1dbb:	48 39 fd             	cmp    %rdi,%rbp
  5b1dbe:	0f 86 15 30 00 00    	jbe    5b4dd9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41a9>
  5b1dc4:	4c 6b c7 58          	imul   $0x58,%rdi,%r8
  5b1dc8:	4d 03 81 30 02 00 00 	add    0x230(%r9),%r8
  5b1dcf:	eb 24                	jmp    5b1df5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x11c5>
  5b1dd1:	40 b7 02             	mov    $0x2,%dil
  5b1dd4:	eb 24                	jmp    5b1dfa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x11ca>
  5b1dd6:	4c 8b 0c 24          	mov    (%rsp),%r9
  5b1dda:	49 8b a9 40 02 00 00 	mov    0x240(%r9),%rbp
  5b1de1:	48 39 fd             	cmp    %rdi,%rbp
  5b1de4:	0f 86 c2 2f 00 00    	jbe    5b4dac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x417c>
  5b1dea:	4c 6b c7 58          	imul   $0x58,%rdi,%r8
  5b1dee:	4d 03 81 38 02 00 00 	add    0x238(%r9),%r8
  5b1df5:	41 0f b6 78 54       	movzbl 0x54(%r8),%edi
  5b1dfa:	4c 8b 0c 24          	mov    (%rsp),%r9
  5b1dfe:	4d 8b 81 30 08 00 00 	mov    0x830(%r9),%r8
  5b1e05:	4d 85 c0             	test   %r8,%r8
  5b1e08:	4c 89 64 24 30       	mov    %r12,0x30(%rsp)
  5b1e0d:	0f 84 80 00 00 00    	je     5b1e93 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1263>
  5b1e13:	4c 89 f3             	mov    %r14,%rbx
  5b1e16:	4d 8b 89 38 08 00 00 	mov    0x838(%r9),%r9
  5b1e1d:	48 8b 44 c8 08       	mov    0x8(%rax,%rcx,8),%rax
  5b1e22:	45 0f b7 90 c2 01 00 	movzwl 0x1c2(%r8),%r10d
  5b1e29:	00 
  5b1e2a:	45 89 d6             	mov    %r10d,%r14d
  5b1e2d:	41 c1 e6 05          	shl    $0x5,%r14d
  5b1e31:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  5b1e38:	45 31 db             	xor    %r11d,%r11d
  5b1e3b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5b1e40:	4d 89 f4             	mov    %r14,%r12
  5b1e43:	4d 01 dc             	add    %r11,%r12
  5b1e46:	74 28                	je     5b1e70 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1240>
  5b1e48:	49 3b 84 c8 70 01 00 	cmp    0x170(%r8,%rcx,8),%rax
  5b1e4f:	00 
  5b1e50:	40 0f 97 c5          	seta   %bpl
  5b1e54:	40 80 dd 00          	sbb    $0x0,%bpl
  5b1e58:	49 83 c3 e0          	add    $0xffffffffffffffe0,%r11
  5b1e5c:	48 ff c1             	inc    %rcx
  5b1e5f:	40 80 fd 01          	cmp    $0x1,%bpl
  5b1e63:	74 db                	je     5b1e40 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1210>
  5b1e65:	44 0f b6 d5          	movzbl %bpl,%r10d
  5b1e69:	45 85 d2             	test   %r10d,%r10d
  5b1e6c:	75 05                	jne    5b1e73 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1243>
  5b1e6e:	eb 17                	jmp    5b1e87 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1257>
  5b1e70:	4c 89 d1             	mov    %r10,%rcx
  5b1e73:	49 83 e9 01          	sub    $0x1,%r9
  5b1e77:	0f 82 97 00 00 00    	jb     5b1f14 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x12e4>
  5b1e7d:	4d 8b 84 c8 c8 01 00 	mov    0x1c8(%r8,%rcx,8),%r8
  5b1e84:	00 
  5b1e85:	eb 9b                	jmp    5b1e22 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x11f2>
  5b1e87:	4d 29 d8             	sub    %r11,%r8
  5b1e8a:	49 83 c0 e0          	add    $0xffffffffffffffe0,%r8
  5b1e8e:	49 89 de             	mov    %rbx,%r14
  5b1e91:	eb 03                	jmp    5b1e96 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1266>
  5b1e93:	45 31 c0             	xor    %r8d,%r8d
  5b1e96:	40 0f b6 f6          	movzbl %sil,%esi
  5b1e9a:	40 0f b6 cf          	movzbl %dil,%ecx
  5b1e9e:	48 8d 9c 24 d0 04 00 	lea    0x4d0(%rsp),%rbx
  5b1ea5:	00 
  5b1ea6:	48 89 df             	mov    %rbx,%rdi
  5b1ea9:	e8 72 de 21 00       	call   7cfd20 <_RNvNtNtCs6gaF1xUz9Bf_4gpui7runtime4list9row_style>
  5b1eae:	66 0f 28 84 24 70 04 	movapd 0x470(%rsp),%xmm0
  5b1eb5:	00 00 
  5b1eb7:	66 0f 29 84 24 a0 09 	movapd %xmm0,0x9a0(%rsp)
  5b1ebe:	00 00 
  5b1ec0:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
  5b1ec5:	48 8d b4 24 a0 09 00 	lea    0x9a0(%rsp),%rsi
  5b1ecc:	00 
  5b1ecd:	48 89 da             	mov    %rbx,%rdx
  5b1ed0:	ff 15 3a 82 53 00    	call   *0x53823a(%rip)        # aea110 <_DYNAMIC+0x3b0>
  5b1ed6:	a8 01                	test   $0x1,%al
  5b1ed8:	0f 85 89 07 00 00    	jne    5b2667 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1a37>
  5b1ede:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
  5b1ee3:	48 8d b4 24 70 04 00 	lea    0x470(%rsp),%rsi
  5b1eea:	00 
  5b1eeb:	ff 15 27 82 53 00    	call   *0x538227(%rip)        # aea118 <_DYNAMIC+0x3b8>
  5b1ef1:	41 89 c4             	mov    %eax,%r12d
  5b1ef4:	3c ff                	cmp    $0xff,%al
  5b1ef6:	0f 85 fc 0a 00 00    	jne    5b29f8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1dc8>
  5b1efc:	ba 00 00 00 00       	mov    $0x0,%edx
  5b1f01:	4d 85 ed             	test   %r13,%r13
  5b1f04:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  5b1f09:	0f 85 61 fb ff ff    	jne    5b1a70 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0xe40>
  5b1f0f:	e9 e4 01 00 00       	jmp    5b20f8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x14c8>
  5b1f14:	45 31 c0             	xor    %r8d,%r8d
  5b1f17:	e9 72 ff ff ff       	jmp    5b1e8e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x125e>
  5b1f1c:	48 8b 04 24          	mov    (%rsp),%rax
  5b1f20:	48 83 b8 e0 02 00 00 	cmpq   $0x0,0x2e0(%rax)
  5b1f27:	00 
  5b1f28:	0f 84 41 07 00 00    	je     5b266f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1a3f>
  5b1f2e:	41 b6 01             	mov    $0x1,%r14b
  5b1f31:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b1f38:	00 
  5b1f39:	ff 15 e1 81 53 00    	call   *0x5381e1(%rip)        # aea120 <_DYNAMIC+0x3c0>
  5b1f3f:	48 8b 9c 24 d0 04 00 	mov    0x4d0(%rsp),%rbx
  5b1f46:	00 
  5b1f47:	44 8b a4 24 d8 04 00 	mov    0x4d8(%rsp),%r12d
  5b1f4e:	00 
  5b1f4f:	8b ac 24 dc 04 00 00 	mov    0x4dc(%rsp),%ebp
  5b1f56:	48 85 db             	test   %rbx,%rbx
  5b1f59:	48 8b bc 24 90 01 00 	mov    0x190(%rsp),%rdi
  5b1f60:	00 
  5b1f61:	0f 84 9f 0a 00 00    	je     5b2a06 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1dd6>
  5b1f67:	48 8b 84 24 10 05 00 	mov    0x510(%rsp),%rax
  5b1f6e:	00 
  5b1f6f:	48 89 84 24 40 04 00 	mov    %rax,0x440(%rsp)
  5b1f76:	00 
  5b1f77:	0f 10 84 24 e0 04 00 	movups 0x4e0(%rsp),%xmm0
  5b1f7e:	00 
  5b1f7f:	0f 10 8c 24 f0 04 00 	movups 0x4f0(%rsp),%xmm1
  5b1f86:	00 
  5b1f87:	0f 10 94 24 00 05 00 	movups 0x500(%rsp),%xmm2
  5b1f8e:	00 
  5b1f8f:	0f 29 94 24 30 04 00 	movaps %xmm2,0x430(%rsp)
  5b1f96:	00 
  5b1f97:	0f 29 8c 24 20 04 00 	movaps %xmm1,0x420(%rsp)
  5b1f9e:	00 
  5b1f9f:	0f 29 84 24 10 04 00 	movaps %xmm0,0x410(%rsp)
  5b1fa6:	00 
  5b1fa7:	e8 74 7c f7 ff       	call   529c20 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs7XZEQI6Z5Ts_11gpui_canvas4text10TextSystemEECs6gaF1xUz9Bf_4gpui>
  5b1fac:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b1fb0:	48 89 99 98 08 00 00 	mov    %rbx,0x898(%rcx)
  5b1fb7:	44 89 a1 a0 08 00 00 	mov    %r12d,0x8a0(%rcx)
  5b1fbe:	89 a9 a4 08 00 00    	mov    %ebp,0x8a4(%rcx)
  5b1fc4:	66 0f 28 84 24 10 04 	movapd 0x410(%rsp),%xmm0
  5b1fcb:	00 00 
  5b1fcd:	0f 28 8c 24 20 04 00 	movaps 0x420(%rsp),%xmm1
  5b1fd4:	00 
  5b1fd5:	0f 28 94 24 30 04 00 	movaps 0x430(%rsp),%xmm2
  5b1fdc:	00 
  5b1fdd:	66 0f 11 81 a8 08 00 	movupd %xmm0,0x8a8(%rcx)
  5b1fe4:	00 
  5b1fe5:	0f 11 89 b8 08 00 00 	movups %xmm1,0x8b8(%rcx)
  5b1fec:	0f 11 91 c8 08 00 00 	movups %xmm2,0x8c8(%rcx)
  5b1ff3:	48 8b 84 24 40 04 00 	mov    0x440(%rsp),%rax
  5b1ffa:	00 
  5b1ffb:	48 89 81 d8 08 00 00 	mov    %rax,0x8d8(%rcx)
  5b2002:	f0 48 ff 03          	lock incq (%rbx)
  5b2006:	0f 8f 40 f2 ff ff    	jg     5b124c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x61c>
  5b200c:	0f 0b                	ud2
  5b200e:	4d 85 ed             	test   %r13,%r13
  5b2011:	0f 84 75 06 00 00    	je     5b268c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1a5c>
  5b2017:	4c 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%r14
  5b201e:	00 
  5b201f:	48 8d ac 24 a0 09 00 	lea    0x9a0(%rsp),%rbp
  5b2026:	00 
  5b2027:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5b202e:	00 00 
  5b2030:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  5b2034:	48 83 c3 50          	add    $0x50,%rbx
  5b2038:	48 c7 84 24 a0 09 00 	movq   $0x0,0x9a0(%rsp)
  5b203f:	00 00 00 00 00 
  5b2044:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  5b2049:	4d 89 e8             	mov    %r13,%r8
  5b204c:	41 0f b7 b0 c2 01 00 	movzwl 0x1c2(%r8),%esi
  5b2053:	00 
  5b2054:	41 89 f1             	mov    %esi,%r9d
  5b2057:	41 c1 e1 05          	shl    $0x5,%r9d
  5b205b:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  5b2062:	31 ff                	xor    %edi,%edi
  5b2064:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b206b:	00 00 00 00 00 
  5b2070:	4d 89 ca             	mov    %r9,%r10
  5b2073:	49 01 fa             	add    %rdi,%r10
  5b2076:	74 38                	je     5b20b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1480>
  5b2078:	49 3b 94 c8 70 01 00 	cmp    0x170(%r8,%rcx,8),%rdx
  5b207f:	00 
  5b2080:	41 0f 97 c2          	seta   %r10b
  5b2084:	41 80 da 00          	sbb    $0x0,%r10b
  5b2088:	48 83 c7 e0          	add    $0xffffffffffffffe0,%rdi
  5b208c:	48 ff c1             	inc    %rcx
  5b208f:	41 80 fa 01          	cmp    $0x1,%r10b
  5b2093:	74 db                	je     5b2070 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1440>
  5b2095:	41 0f b6 f2          	movzbl %r10b,%esi
  5b2099:	81 fe ff 00 00 00    	cmp    $0xff,%esi
  5b209f:	74 12                	je     5b20b3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1483>
  5b20a1:	eb 2d                	jmp    5b20d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x14a0>
  5b20a3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b20aa:	84 00 00 00 00 00 
  5b20b0:	48 89 f1             	mov    %rsi,%rcx
  5b20b3:	48 83 e8 01          	sub    $0x1,%rax
  5b20b7:	72 3a                	jb     5b20f3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x14c3>
  5b20b9:	4d 8b 84 c8 c8 01 00 	mov    0x1c8(%r8,%rcx,8),%r8
  5b20c0:	00 
  5b20c1:	eb 89                	jmp    5b204c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x141c>
  5b20c3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b20ca:	84 00 00 00 00 00 
  5b20d0:	49 29 f8             	sub    %rdi,%r8
  5b20d3:	49 83 c0 e0          	add    $0xffffffffffffffe0,%r8
  5b20d7:	4c 89 f7             	mov    %r14,%rdi
  5b20da:	4c 89 fe             	mov    %r15,%rsi
  5b20dd:	48 89 e9             	mov    %rbp,%rcx
  5b20e0:	e8 ab 60 1a 00       	call   758190 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataNtB4_5Sheet7capture>
  5b20e5:	4c 39 e3             	cmp    %r12,%rbx
  5b20e8:	0f 85 42 ff ff ff    	jne    5b2030 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1400>
  5b20ee:	e9 d8 05 00 00       	jmp    5b26cb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1a9b>
  5b20f3:	45 31 c0             	xor    %r8d,%r8d
  5b20f6:	eb df                	jmp    5b20d7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x14a7>
  5b20f8:	48 8b 04 24          	mov    (%rsp),%rax
  5b20fc:	48 8b a8 40 07 00 00 	mov    0x740(%rax),%rbp
  5b2103:	e9 d8 00 00 00       	jmp    5b21e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x15b0>
  5b2108:	4c 8d ac 24 a0 09 00 	lea    0x9a0(%rsp),%r13
  5b210f:	00 
  5b2110:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  5b2114:	48 83 c3 50          	add    $0x50,%rbx
  5b2118:	48 89 e9             	mov    %rbp,%rcx
  5b211b:	4c 89 f0             	mov    %r14,%rax
  5b211e:	0f b7 b8 12 01 00 00 	movzwl 0x112(%rax),%edi
  5b2125:	41 89 f9             	mov    %edi,%r9d
  5b2128:	41 c1 e1 04          	shl    $0x4,%r9d
  5b212c:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  5b2133:	45 31 c0             	xor    %r8d,%r8d
  5b2136:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5b213d:	00 00 00 
  5b2140:	4d 39 c1             	cmp    %r8,%r9
  5b2143:	74 2b                	je     5b2170 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1540>
  5b2145:	48 3b 94 f0 c0 00 00 	cmp    0xc0(%rax,%rsi,8),%rdx
  5b214c:	00 
  5b214d:	41 0f 97 c2          	seta   %r10b
  5b2151:	41 80 da 00          	sbb    $0x0,%r10b
  5b2155:	49 83 c0 10          	add    $0x10,%r8
  5b2159:	48 ff c6             	inc    %rsi
  5b215c:	41 80 fa 01          	cmp    $0x1,%r10b
  5b2160:	74 de                	je     5b2140 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1510>
  5b2162:	41 0f b6 fa          	movzbl %r10b,%edi
  5b2166:	81 ff ff 00 00 00    	cmp    $0xff,%edi
  5b216c:	74 05                	je     5b2173 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1543>
  5b216e:	eb 20                	jmp    5b2190 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1560>
  5b2170:	48 89 fe             	mov    %rdi,%rsi
  5b2173:	48 83 e9 01          	sub    $0x1,%rcx
  5b2177:	72 61                	jb     5b21da <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x15aa>
  5b2179:	48 8b 84 f0 18 01 00 	mov    0x118(%rax,%rsi,8),%rax
  5b2180:	00 
  5b2181:	eb 9b                	jmp    5b211e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x14ee>
  5b2183:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b218a:	84 00 00 00 00 00 
  5b2190:	4a 8b 4c 00 f0       	mov    -0x10(%rax,%r8,1),%rcx
  5b2195:	42 8b 44 00 f8       	mov    -0x8(%rax,%r8,1),%eax
  5b219a:	48 89 8c 24 a8 09 00 	mov    %rcx,0x9a8(%rsp)
  5b21a1:	00 
  5b21a2:	89 84 24 b0 09 00 00 	mov    %eax,0x9b0(%rsp)
  5b21a9:	b8 01 00 00 00       	mov    $0x1,%eax
  5b21ae:	48 89 84 24 a0 09 00 	mov    %rax,0x9a0(%rsp)
  5b21b5:	00 
  5b21b6:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b21bd:	00 
  5b21be:	4c 89 fe             	mov    %r15,%rsi
  5b21c1:	4c 89 e9             	mov    %r13,%rcx
  5b21c4:	45 31 c0             	xor    %r8d,%r8d
  5b21c7:	e8 c4 5f 1a 00       	call   758190 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataNtB4_5Sheet7capture>
  5b21cc:	4c 39 e3             	cmp    %r12,%rbx
  5b21cf:	0f 85 3b ff ff ff    	jne    5b2110 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x14e0>
  5b21d5:	e9 f1 04 00 00       	jmp    5b26cb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1a9b>
  5b21da:	31 c0                	xor    %eax,%eax
  5b21dc:	eb d0                	jmp    5b21ae <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x157e>
  5b21de:	31 ed                	xor    %ebp,%ebp
  5b21e0:	48 8b 34 24          	mov    (%rsp),%rsi
  5b21e4:	4c 8b b6 f0 06 00 00 	mov    0x6f0(%rsi),%r14
  5b21eb:	48 8b 9e 10 07 00 00 	mov    0x710(%rsi),%rbx
  5b21f2:	48 8d 86 30 07 00 00 	lea    0x730(%rsi),%rax
  5b21f9:	48 c7 84 24 28 03 00 	movq   $0xfffffffffffffffe,0x328(%rsp)
  5b2200:	00 fe ff ff ff 
  5b2205:	48 8d 8e b8 02 00 00 	lea    0x2b8(%rsi),%rcx
  5b220c:	4c 8d 86 28 02 00 00 	lea    0x228(%rsi),%r8
  5b2213:	48 8d 96 d0 02 00 00 	lea    0x2d0(%rsi),%rdx
  5b221a:	48 8d be a8 07 00 00 	lea    0x7a8(%rsi),%rdi
  5b2221:	48 89 84 24 68 09 00 	mov    %rax,0x968(%rsp)
  5b2228:	00 
  5b2229:	48 89 8c 24 70 09 00 	mov    %rcx,0x970(%rsp)
  5b2230:	00 
  5b2231:	48 89 bc 24 00 02 00 	mov    %rdi,0x200(%rsp)
  5b2238:	00 
  5b2239:	48 89 bc 24 78 09 00 	mov    %rdi,0x978(%rsp)
  5b2240:	00 
  5b2241:	48 8d 84 24 20 01 00 	lea    0x120(%rsp),%rax
  5b2248:	00 
  5b2249:	48 89 84 24 80 09 00 	mov    %rax,0x980(%rsp)
  5b2250:	00 
  5b2251:	48 89 94 24 88 09 00 	mov    %rdx,0x988(%rsp)
  5b2258:	00 
  5b2259:	4c 89 84 24 88 03 00 	mov    %r8,0x388(%rsp)
  5b2260:	00 
  5b2261:	4c 89 84 24 90 09 00 	mov    %r8,0x990(%rsp)
  5b2268:	00 
  5b2269:	48 8d 84 24 28 03 00 	lea    0x328(%rsp),%rax
  5b2270:	00 
  5b2271:	48 89 84 24 98 09 00 	mov    %rax,0x998(%rsp)
  5b2278:	00 
  5b2279:	48 85 ed             	test   %rbp,%rbp
  5b227c:	0f 84 76 2b 00 00    	je     5b4df8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41c8>
  5b2282:	48 8b 86 38 07 00 00 	mov    0x738(%rsi),%rax
  5b2289:	66 0f 10 00          	movupd (%rax),%xmm0
  5b228d:	66 0f 29 84 24 a0 09 	movapd %xmm0,0x9a0(%rsp)
  5b2294:	00 00 
  5b2296:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
  5b229a:	66 0f 28 4c 24 60    	movapd 0x60(%rsp),%xmm1
  5b22a0:	0f 14 c8             	unpcklps %xmm0,%xmm1
  5b22a3:	66 0f 28 05 75 af ab 	movapd -0x54508b(%rip),%xmm0        # 6d220 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0x11d0>
  5b22aa:	ff 
  5b22ab:	66 0f 56 c8          	orpd   %xmm0,%xmm1
  5b22af:	66 0f 5c c8          	subpd  %xmm0,%xmm1
  5b22b3:	66 0f 5a c9          	cvtpd2ps %xmm1,%xmm1
  5b22b7:	66 0f 28 c1          	movapd %xmm1,%xmm0
  5b22bb:	0f c6 c1 55          	shufps $0x55,%xmm1,%xmm0
  5b22bf:	0f 29 8c 24 f0 02 00 	movaps %xmm1,0x2f0(%rsp)
  5b22c6:	00 
  5b22c7:	f3 0f 10 54 24 24    	movss  0x24(%rsp),%xmm2
  5b22cd:	f3 0f 5e ca          	divss  %xmm2,%xmm1
  5b22d1:	f3 0f 5e c2          	divss  %xmm2,%xmm0
  5b22d5:	c7 84 24 d0 04 00 00 	movl   $0x0,0x4d0(%rsp)
  5b22dc:	00 00 00 00 
  5b22e0:	f3 0f 11 8c 24 d4 04 	movss  %xmm1,0x4d4(%rsp)
  5b22e7:	00 00 
  5b22e9:	c7 84 24 d8 04 00 00 	movl   $0x0,0x4d8(%rsp)
  5b22f0:	00 00 00 00 
  5b22f4:	f3 0f 11 84 24 dc 04 	movss  %xmm0,0x4dc(%rsp)
  5b22fb:	00 00 
  5b22fd:	b0 01                	mov    $0x1,%al
  5b22ff:	89 44 24 08          	mov    %eax,0x8(%rsp)
  5b2303:	4c 8d 05 ae 6f 50 00 	lea    0x506fae(%rip),%r8        # ab92b8 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x4c0>
  5b230a:	48 8d b4 24 a0 09 00 	lea    0x9a0(%rsp),%rsi
  5b2311:	00 
  5b2312:	48 8d 94 24 d0 04 00 	lea    0x4d0(%rsp),%rdx
  5b2319:	00 
  5b231a:	48 8d 8c 24 68 09 00 	lea    0x968(%rsp),%rcx
  5b2321:	00 
  5b2322:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
  5b2327:	ff 15 fb 7d 53 00    	call   *0x537dfb(%rip)        # aea128 <_DYNAMIC+0x3c8>
  5b232d:	a8 01                	test   $0x1,%al
  5b232f:	74 1f                	je     5b2350 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1720>
  5b2331:	41 89 d4             	mov    %edx,%r12d
  5b2334:	41 b6 01             	mov    $0x1,%r14b
  5b2337:	41 bf 21 00 00 00    	mov    $0x21,%r15d
  5b233d:	83 bc 24 28 03 00 00 	cmpl   $0xfffffffe,0x328(%rsp)
  5b2344:	fe 
  5b2345:	0f 85 2a 26 00 00    	jne    5b4975 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3d45>
  5b234b:	e9 32 26 00 00       	jmp    5b4982 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3d52>
  5b2350:	4c 8b 24 24          	mov    (%rsp),%r12
  5b2354:	49 8b 84 24 f0 06 00 	mov    0x6f0(%r12),%rax
  5b235b:	00 
  5b235c:	4c 29 f0             	sub    %r14,%rax
  5b235f:	49 8b 8c 24 10 07 00 	mov    0x710(%r12),%rcx
  5b2366:	00 
  5b2367:	49 01 84 24 18 09 00 	add    %rax,0x918(%r12)
  5b236e:	00 
  5b236f:	48 29 d9             	sub    %rbx,%rcx
  5b2372:	49 01 8c 24 20 09 00 	add    %rcx,0x920(%r12)
  5b2379:	00 
  5b237a:	4c 8b bc 24 28 03 00 	mov    0x328(%rsp),%r15
  5b2381:	00 
  5b2382:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  5b2386:	0f 85 83 02 00 00    	jne    5b260f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x19df>
  5b238c:	49 8b b4 24 c8 02 00 	mov    0x2c8(%r12),%rsi
  5b2393:	00 
  5b2394:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b239b:	00 
  5b239c:	b9 08 00 00 00       	mov    $0x8,%ecx
  5b23a1:	41 b8 50 00 00 00    	mov    $0x50,%r8d
  5b23a7:	31 d2                	xor    %edx,%edx
  5b23a9:	e8 32 cb 21 00       	call   7ceee0 <_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs6gaF1xUz9Bf_4gpui>
  5b23ae:	48 8b bc 24 d8 04 00 	mov    0x4d8(%rsp),%rdi
  5b23b5:	00 
  5b23b6:	80 bc 24 d0 04 00 00 	cmpb   $0x0,0x4d0(%rsp)
  5b23bd:	00 
  5b23be:	0f 85 b1 28 00 00    	jne    5b4c75 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4045>
  5b23c4:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b23cb:	00 
  5b23cc:	48 89 bc 24 b8 01 00 	mov    %rdi,0x1b8(%rsp)
  5b23d3:	00 
  5b23d4:	48 89 84 24 c0 01 00 	mov    %rax,0x1c0(%rsp)
  5b23db:	00 
  5b23dc:	48 c7 84 24 c8 01 00 	movq   $0x0,0x1c8(%rsp)
  5b23e3:	00 00 00 00 00 
  5b23e8:	49 8b b4 24 c8 02 00 	mov    0x2c8(%r12),%rsi
  5b23ef:	00 
  5b23f0:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b23f7:	00 
  5b23f8:	b9 08 00 00 00       	mov    $0x8,%ecx
  5b23fd:	41 b8 38 00 00 00    	mov    $0x38,%r8d
  5b2403:	31 d2                	xor    %edx,%edx
  5b2405:	e8 d6 ca 21 00       	call   7ceee0 <_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs6gaF1xUz9Bf_4gpui>
  5b240a:	48 8b bc 24 d8 04 00 	mov    0x4d8(%rsp),%rdi
  5b2411:	00 
  5b2412:	80 bc 24 d0 04 00 00 	cmpb   $0x0,0x4d0(%rsp)
  5b2419:	00 
  5b241a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  5b2421:	00 
  5b2422:	0f 85 60 28 00 00    	jne    5b4c88 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4058>
  5b2428:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b242f:	00 
  5b2430:	48 89 bc 24 30 01 00 	mov    %rdi,0x130(%rsp)
  5b2437:	00 
  5b2438:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
  5b243f:	00 
  5b2440:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  5b2447:	00 00 00 00 00 
  5b244c:	49 8b 84 24 28 08 00 	mov    0x828(%r12),%rax
  5b2453:	00 
  5b2454:	49 89 c7             	mov    %rax,%r15
  5b2457:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b245c:	48 85 c0             	test   %rax,%rax
  5b245f:	74 0b                	je     5b246c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x183c>
  5b2461:	48 8b 04 24          	mov    (%rsp),%rax
  5b2465:	4c 8b b8 c8 02 00 00 	mov    0x2c8(%rax),%r15
  5b246c:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b2473:	00 
  5b2474:	b9 04 00 00 00       	mov    $0x4,%ecx
  5b2479:	41 b8 10 00 00 00    	mov    $0x10,%r8d
  5b247f:	4c 89 fe             	mov    %r15,%rsi
  5b2482:	31 d2                	xor    %edx,%edx
  5b2484:	e8 57 ca 21 00       	call   7ceee0 <_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs6gaF1xUz9Bf_4gpui>
  5b2489:	48 8b bc 24 d8 04 00 	mov    0x4d8(%rsp),%rdi
  5b2490:	00 
  5b2491:	80 bc 24 d0 04 00 00 	cmpb   $0x0,0x4d0(%rsp)
  5b2498:	00 
  5b2499:	0f 85 fc 27 00 00    	jne    5b4c9b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x406b>
  5b249f:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b24a6:	00 
  5b24a7:	48 89 bc 24 48 01 00 	mov    %rdi,0x148(%rsp)
  5b24ae:	00 
  5b24af:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  5b24b6:	00 
  5b24b7:	48 c7 84 24 58 01 00 	movq   $0x0,0x158(%rsp)
  5b24be:	00 00 00 00 00 
  5b24c3:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b24ca:	00 
  5b24cb:	b9 04 00 00 00       	mov    $0x4,%ecx
  5b24d0:	41 b8 10 00 00 00    	mov    $0x10,%r8d
  5b24d6:	4c 89 fe             	mov    %r15,%rsi
  5b24d9:	31 d2                	xor    %edx,%edx
  5b24db:	e8 00 ca 21 00       	call   7ceee0 <_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs6gaF1xUz9Bf_4gpui>
  5b24e0:	48 8b bc 24 d8 04 00 	mov    0x4d8(%rsp),%rdi
  5b24e7:	00 
  5b24e8:	80 bc 24 d0 04 00 00 	cmpb   $0x0,0x4d0(%rsp)
  5b24ef:	00 
  5b24f0:	0f 85 b8 27 00 00    	jne    5b4cae <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x407e>
  5b24f6:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b24fd:	00 
  5b24fe:	48 89 bc 24 60 01 00 	mov    %rdi,0x160(%rsp)
  5b2505:	00 
  5b2506:	48 89 84 24 68 01 00 	mov    %rax,0x168(%rsp)
  5b250d:	00 
  5b250e:	48 c7 84 24 70 01 00 	movq   $0x0,0x170(%rsp)
  5b2515:	00 00 00 00 00 
  5b251a:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b2521:	00 
  5b2522:	b9 01 00 00 00       	mov    $0x1,%ecx
  5b2527:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  5b252d:	4c 89 fe             	mov    %r15,%rsi
  5b2530:	31 d2                	xor    %edx,%edx
  5b2532:	e8 a9 c9 21 00       	call   7ceee0 <_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs6gaF1xUz9Bf_4gpui>
  5b2537:	48 8b bc 24 d8 04 00 	mov    0x4d8(%rsp),%rdi
  5b253e:	00 
  5b253f:	80 bc 24 d0 04 00 00 	cmpb   $0x0,0x4d0(%rsp)
  5b2546:	00 
  5b2547:	0f 85 74 27 00 00    	jne    5b4cc1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4091>
  5b254d:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b2554:	00 
  5b2555:	48 89 bc 24 78 01 00 	mov    %rdi,0x178(%rsp)
  5b255c:	00 
  5b255d:	48 89 84 24 80 01 00 	mov    %rax,0x180(%rsp)
  5b2564:	00 
  5b2565:	48 c7 84 24 88 01 00 	movq   $0x0,0x188(%rsp)
  5b256c:	00 00 00 00 00 
  5b2571:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b2578:	00 
  5b2579:	b9 04 00 00 00       	mov    $0x4,%ecx
  5b257e:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  5b2584:	4c 89 fe             	mov    %r15,%rsi
  5b2587:	31 d2                	xor    %edx,%edx
  5b2589:	e8 52 c9 21 00       	call   7ceee0 <_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs6gaF1xUz9Bf_4gpui>
  5b258e:	48 8b bc 24 d8 04 00 	mov    0x4d8(%rsp),%rdi
  5b2595:	00 
  5b2596:	80 bc 24 d0 04 00 00 	cmpb   $0x0,0x4d0(%rsp)
  5b259d:	00 
  5b259e:	0f 85 30 27 00 00    	jne    5b4cd4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x40a4>
  5b25a4:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b25ab:	00 
  5b25ac:	48 89 bc 24 a8 00 00 	mov    %rdi,0xa8(%rsp)
  5b25b3:	00 
  5b25b4:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5b25bb:	00 
  5b25bc:	48 c7 84 24 b8 00 00 	movq   $0x0,0xb8(%rsp)
  5b25c3:	00 00 00 00 00 
  5b25c8:	48 c7 84 24 a8 02 00 	movq   $0x0,0x2a8(%rsp)
  5b25cf:	00 00 00 00 00 
  5b25d4:	48 c7 84 24 b8 02 00 	movq   $0x0,0x2b8(%rsp)
  5b25db:	00 00 00 00 00 
  5b25e0:	48 8b 34 24          	mov    (%rsp),%rsi
  5b25e4:	48 8b 96 10 08 00 00 	mov    0x810(%rsi),%rdx
  5b25eb:	48 85 d2             	test   %rdx,%rdx
  5b25ee:	0f 84 36 04 00 00    	je     5b2a2a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1dfa>
  5b25f4:	b0 01                	mov    $0x1,%al
  5b25f6:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b25fa:	48 8d bc 24 98 03 00 	lea    0x398(%rsp),%rdi
  5b2601:	00 
  5b2602:	41 b6 01             	mov    $0x1,%r14b
  5b2605:	e8 e6 78 f8 ff       	call   539ef0 <_RNCNvMs1_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataINtB9_7RuntimeNtNtB9_12style_ledger9AdversaryE14metadata_sheet0Bb_>
  5b260a:	e9 27 04 00 00       	jmp    5b2a36 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1e06>
  5b260f:	44 8b a4 24 30 03 00 	mov    0x330(%rsp),%r12d
  5b2616:	00 
  5b2617:	8b ac 24 34 03 00 00 	mov    0x334(%rsp),%ebp
  5b261e:	45 89 e5             	mov    %r12d,%r13d
  5b2621:	41 c1 ed 08          	shr    $0x8,%r13d
  5b2625:	0f 10 84 24 38 03 00 	movups 0x338(%rsp),%xmm0
  5b262c:	00 
  5b262d:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  5b2632:	66 0f 10 84 24 48 03 	movupd 0x348(%rsp),%xmm0
  5b2639:	00 00 
  5b263b:	66 0f 29 44 24 30    	movapd %xmm0,0x30(%rsp)
  5b2641:	0f b6 9c 24 58 03 00 	movzbl 0x358(%rsp),%ebx
  5b2648:	00 
  5b2649:	8b 84 24 59 03 00 00 	mov    0x359(%rsp),%eax
  5b2650:	89 44 24 58          	mov    %eax,0x58(%rsp)
  5b2654:	8b 84 24 5c 03 00 00 	mov    0x35c(%rsp),%eax
  5b265b:	89 44 24 5b          	mov    %eax,0x5b(%rsp)
  5b265f:	41 b6 01             	mov    $0x1,%r14b
  5b2662:	e9 1b 23 00 00       	jmp    5b4982 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3d52>
  5b2667:	41 89 d4             	mov    %edx,%r12d
  5b266a:	e9 89 03 00 00       	jmp    5b29f8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1dc8>
  5b266f:	48 c7 84 24 98 00 00 	movq   $0x0,0x98(%rsp)
  5b2676:	00 00 00 00 00 
  5b267b:	48 c7 84 24 20 01 00 	movq   $0x0,0x120(%rsp)
  5b2682:	00 00 00 00 00 
  5b2687:	e9 e4 eb ff ff       	jmp    5b1270 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x640>
  5b268c:	45 31 f6             	xor    %r14d,%r14d
  5b268f:	4c 8d a4 24 d0 04 00 	lea    0x4d0(%rsp),%r12
  5b2696:	00 
  5b2697:	4c 8d ac 24 a0 09 00 	lea    0x9a0(%rsp),%r13
  5b269e:	00 
  5b269f:	90                   	nop
  5b26a0:	4a 8b 54 33 20       	mov    0x20(%rbx,%r14,1),%rdx
  5b26a5:	48 c7 84 24 a0 09 00 	movq   $0x0,0x9a0(%rsp)
  5b26ac:	00 00 00 00 00 
  5b26b1:	4c 89 e7             	mov    %r12,%rdi
  5b26b4:	4c 89 fe             	mov    %r15,%rsi
  5b26b7:	4c 89 e9             	mov    %r13,%rcx
  5b26ba:	45 31 c0             	xor    %r8d,%r8d
  5b26bd:	e8 ce 5a 1a 00       	call   758190 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataNtB4_5Sheet7capture>
  5b26c2:	49 83 c6 50          	add    $0x50,%r14
  5b26c6:	4c 39 f5             	cmp    %r14,%rbp
  5b26c9:	75 d5                	jne    5b26a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1a70>
  5b26cb:	4c 8d a4 24 d0 04 00 	lea    0x4d0(%rsp),%r12
  5b26d2:	00 
  5b26d3:	4c 89 e7             	mov    %r12,%rdi
  5b26d6:	e8 85 59 1a 00       	call   758060 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataNtB4_5Sheet4sort>
  5b26db:	48 8b 9c 24 d0 04 00 	mov    0x4d0(%rsp),%rbx
  5b26e2:	00 
  5b26e3:	0f 10 84 24 d8 04 00 	movups 0x4d8(%rsp),%xmm0
  5b26ea:	00 
  5b26eb:	0f 29 84 24 a0 09 00 	movaps %xmm0,0x9a0(%rsp)
  5b26f2:	00 
  5b26f3:	0f 10 84 24 e8 04 00 	movups 0x4e8(%rsp),%xmm0
  5b26fa:	00 
  5b26fb:	0f 29 84 24 b0 09 00 	movaps %xmm0,0x9b0(%rsp)
  5b2702:	00 
  5b2703:	0f 10 84 24 f8 04 00 	movups 0x4f8(%rsp),%xmm0
  5b270a:	00 
  5b270b:	0f 29 84 24 c0 09 00 	movaps %xmm0,0x9c0(%rsp)
  5b2712:	00 
  5b2713:	0f 10 84 24 08 05 00 	movups 0x508(%rsp),%xmm0
  5b271a:	00 
  5b271b:	0f 29 84 24 d0 09 00 	movaps %xmm0,0x9d0(%rsp)
  5b2722:	00 
  5b2723:	66 0f 10 84 24 18 05 	movupd 0x518(%rsp),%xmm0
  5b272a:	00 00 
  5b272c:	66 0f 29 84 24 e0 09 	movapd %xmm0,0x9e0(%rsp)
  5b2733:	00 00 
  5b2735:	48 8b 84 24 28 05 00 	mov    0x528(%rsp),%rax
  5b273c:	00 
  5b273d:	48 89 84 24 f0 09 00 	mov    %rax,0x9f0(%rsp)
  5b2744:	00 
  5b2745:	48 8d bc 24 58 0c 00 	lea    0xc58(%rsp),%rdi
  5b274c:	00 
  5b274d:	e8 be b4 17 00       	call   72dc10 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5b2752:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5b2756:	4c 8b b4 24 90 00 00 	mov    0x90(%rsp),%r14
  5b275d:	00 
  5b275e:	8b 6c 24 54          	mov    0x54(%rsp),%ebp
  5b2762:	0f 84 af 01 00 00    	je     5b2917 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1ce7>
  5b2768:	40 84 ed             	test   %bpl,%bpl
  5b276b:	0f 84 e2 00 00 00    	je     5b2853 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1c23>
  5b2771:	48 89 9c 24 d0 04 00 	mov    %rbx,0x4d0(%rsp)
  5b2778:	00 
  5b2779:	48 8b 84 24 f0 09 00 	mov    0x9f0(%rsp),%rax
  5b2780:	00 
  5b2781:	48 89 84 24 28 05 00 	mov    %rax,0x528(%rsp)
  5b2788:	00 
  5b2789:	0f 28 84 24 e0 09 00 	movaps 0x9e0(%rsp),%xmm0
  5b2790:	00 
  5b2791:	0f 11 84 24 18 05 00 	movups %xmm0,0x518(%rsp)
  5b2798:	00 
  5b2799:	0f 28 84 24 a0 09 00 	movaps 0x9a0(%rsp),%xmm0
  5b27a0:	00 
  5b27a1:	0f 28 8c 24 b0 09 00 	movaps 0x9b0(%rsp),%xmm1
  5b27a8:	00 
  5b27a9:	0f 28 94 24 c0 09 00 	movaps 0x9c0(%rsp),%xmm2
  5b27b0:	00 
  5b27b1:	0f 28 9c 24 d0 09 00 	movaps 0x9d0(%rsp),%xmm3
  5b27b8:	00 
  5b27b9:	0f 11 9c 24 08 05 00 	movups %xmm3,0x508(%rsp)
  5b27c0:	00 
  5b27c1:	0f 11 94 24 f8 04 00 	movups %xmm2,0x4f8(%rsp)
  5b27c8:	00 
  5b27c9:	0f 11 8c 24 e8 04 00 	movups %xmm1,0x4e8(%rsp)
  5b27d0:	00 
  5b27d1:	0f 11 84 24 d8 04 00 	movups %xmm0,0x4d8(%rsp)
  5b27d8:	00 
  5b27d9:	49 83 7f 78 ff       	cmpq   $0xffffffffffffffff,0x78(%r15)
  5b27de:	74 09                	je     5b27e9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1bb9>
  5b27e0:	49 8d 7f 78          	lea    0x78(%r15),%rdi
  5b27e4:	e8 97 62 f8 ff       	call   538a80 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5SheetEBH_>
  5b27e9:	49 89 5f 78          	mov    %rbx,0x78(%r15)
  5b27ed:	0f 28 84 24 a0 09 00 	movaps 0x9a0(%rsp),%xmm0
  5b27f4:	00 
  5b27f5:	0f 28 8c 24 b0 09 00 	movaps 0x9b0(%rsp),%xmm1
  5b27fc:	00 
  5b27fd:	0f 28 94 24 c0 09 00 	movaps 0x9c0(%rsp),%xmm2
  5b2804:	00 
  5b2805:	0f 28 9c 24 d0 09 00 	movaps 0x9d0(%rsp),%xmm3
  5b280c:	00 
  5b280d:	41 0f 11 87 80 00 00 	movups %xmm0,0x80(%r15)
  5b2814:	00 
  5b2815:	41 0f 11 8f 90 00 00 	movups %xmm1,0x90(%r15)
  5b281c:	00 
  5b281d:	41 0f 11 97 a0 00 00 	movups %xmm2,0xa0(%r15)
  5b2824:	00 
  5b2825:	41 0f 11 9f b0 00 00 	movups %xmm3,0xb0(%r15)
  5b282c:	00 
  5b282d:	66 0f 28 84 24 e0 09 	movapd 0x9e0(%rsp),%xmm0
  5b2834:	00 00 
  5b2836:	66 41 0f 11 87 c0 00 	movupd %xmm0,0xc0(%r15)
  5b283d:	00 00 
  5b283f:	48 8b 84 24 f0 09 00 	mov    0x9f0(%rsp),%rax
  5b2846:	00 
  5b2847:	49 89 87 d0 00 00 00 	mov    %rax,0xd0(%r15)
  5b284e:	e9 c4 00 00 00       	jmp    5b2917 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1ce7>
  5b2853:	48 89 9c 24 d0 04 00 	mov    %rbx,0x4d0(%rsp)
  5b285a:	00 
  5b285b:	0f 28 84 24 a0 09 00 	movaps 0x9a0(%rsp),%xmm0
  5b2862:	00 
  5b2863:	0f 28 8c 24 b0 09 00 	movaps 0x9b0(%rsp),%xmm1
  5b286a:	00 
  5b286b:	0f 28 94 24 c0 09 00 	movaps 0x9c0(%rsp),%xmm2
  5b2872:	00 
  5b2873:	0f 28 9c 24 d0 09 00 	movaps 0x9d0(%rsp),%xmm3
  5b287a:	00 
  5b287b:	0f 11 84 24 d8 04 00 	movups %xmm0,0x4d8(%rsp)
  5b2882:	00 
  5b2883:	0f 11 8c 24 e8 04 00 	movups %xmm1,0x4e8(%rsp)
  5b288a:	00 
  5b288b:	0f 11 94 24 f8 04 00 	movups %xmm2,0x4f8(%rsp)
  5b2892:	00 
  5b2893:	0f 11 9c 24 08 05 00 	movups %xmm3,0x508(%rsp)
  5b289a:	00 
  5b289b:	0f 28 84 24 e0 09 00 	movaps 0x9e0(%rsp),%xmm0
  5b28a2:	00 
  5b28a3:	0f 11 84 24 18 05 00 	movups %xmm0,0x518(%rsp)
  5b28aa:	00 
  5b28ab:	48 8b 84 24 f0 09 00 	mov    0x9f0(%rsp),%rax
  5b28b2:	00 
  5b28b3:	48 89 84 24 28 05 00 	mov    %rax,0x528(%rsp)
  5b28ba:	00 
  5b28bb:	49 8d 7f 18          	lea    0x18(%r15),%rdi
  5b28bf:	e8 bc 61 f8 ff       	call   538a80 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5SheetEBH_>
  5b28c4:	49 89 5f 18          	mov    %rbx,0x18(%r15)
  5b28c8:	0f 28 84 24 a0 09 00 	movaps 0x9a0(%rsp),%xmm0
  5b28cf:	00 
  5b28d0:	0f 28 8c 24 b0 09 00 	movaps 0x9b0(%rsp),%xmm1
  5b28d7:	00 
  5b28d8:	0f 28 94 24 c0 09 00 	movaps 0x9c0(%rsp),%xmm2
  5b28df:	00 
  5b28e0:	0f 28 9c 24 d0 09 00 	movaps 0x9d0(%rsp),%xmm3
  5b28e7:	00 
  5b28e8:	41 0f 11 47 20       	movups %xmm0,0x20(%r15)
  5b28ed:	41 0f 11 4f 30       	movups %xmm1,0x30(%r15)
  5b28f2:	41 0f 11 57 40       	movups %xmm2,0x40(%r15)
  5b28f7:	41 0f 11 5f 50       	movups %xmm3,0x50(%r15)
  5b28fc:	66 0f 28 84 24 e0 09 	movapd 0x9e0(%rsp),%xmm0
  5b2903:	00 00 
  5b2905:	66 41 0f 11 47 60    	movupd %xmm0,0x60(%r15)
  5b290b:	48 8b 84 24 f0 09 00 	mov    0x9f0(%rsp),%rax
  5b2912:	00 
  5b2913:	49 89 47 70          	mov    %rax,0x70(%r15)
  5b2917:	49 83 7f 10 00       	cmpq   $0x0,0x10(%r15)
  5b291c:	48 8b 9c 24 a0 00 00 	mov    0xa0(%rsp),%rbx
  5b2923:	00 
  5b2924:	4c 8b 64 24 30       	mov    0x30(%rsp),%r12
  5b2929:	75 57                	jne    5b2982 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1d52>
  5b292b:	49 83 bf e8 00 00 00 	cmpq   $0x0,0xe8(%r15)
  5b2932:	00 
  5b2933:	75 4d                	jne    5b2982 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1d52>
  5b2935:	49 83 7f 78 ff       	cmpq   $0xffffffffffffffff,0x78(%r15)
  5b293a:	75 46                	jne    5b2982 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1d52>
  5b293c:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  5b2941:	75 3f                	jne    5b2982 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1d52>
  5b2943:	49 83 7f 40 00       	cmpq   $0x0,0x40(%r15)
  5b2948:	75 38                	jne    5b2982 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1d52>
  5b294a:	49 83 7f 58 00       	cmpq   $0x0,0x58(%r15)
  5b294f:	75 31                	jne    5b2982 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1d52>
  5b2951:	49 83 7f 70 00       	cmpq   $0x0,0x70(%r15)
  5b2956:	75 2a                	jne    5b2982 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1d52>
  5b2958:	4c 89 ff             	mov    %r15,%rdi
  5b295b:	e8 40 63 f8 ff       	call   538ca0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata8MetadataEBH_>
  5b2960:	be f0 00 00 00       	mov    $0xf0,%esi
  5b2965:	ba 08 00 00 00       	mov    $0x8,%edx
  5b296a:	4c 89 ff             	mov    %r15,%rdi
  5b296d:	ff 15 35 76 53 00    	call   *0x537635(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b2973:	48 8b 04 24          	mov    (%rsp),%rax
  5b2977:	48 c7 80 10 08 00 00 	movq   $0x0,0x810(%rax)
  5b297e:	00 00 00 00 
  5b2982:	48 8b 34 24          	mov    (%rsp),%rsi
  5b2986:	4c 89 b6 90 08 00 00 	mov    %r14,0x890(%rsi)
  5b298d:	40 84 ed             	test   %bpl,%bpl
  5b2990:	74 09                	je     5b299b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1d6b>
  5b2992:	48 8b 86 68 08 00 00 	mov    0x868(%rsi),%rax
  5b2999:	eb 0a                	jmp    5b29a5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1d75>
  5b299b:	4c 89 b6 68 08 00 00 	mov    %r14,0x868(%rsi)
  5b29a2:	4c 89 f0             	mov    %r14,%rax
  5b29a5:	48 83 be 80 08 00 00 	cmpq   $0x0,0x880(%rsi)
  5b29ac:	00 
  5b29ad:	0f 95 c1             	setne  %cl
  5b29b0:	49 83 fc ff          	cmp    $0xffffffffffffffff,%r12
  5b29b4:	0f 95 c2             	setne  %dl
  5b29b7:	0a 54 24 60          	or     0x60(%rsp),%dl
  5b29bb:	20 ca                	and    %cl,%dl
  5b29bd:	0f b6 ca             	movzbl %dl,%ecx
  5b29c0:	48 8b 96 48 09 00 00 	mov    0x948(%rsi),%rdx
  5b29c7:	4c 89 73 18          	mov    %r14,0x18(%rbx)
  5b29cb:	48 89 43 20          	mov    %rax,0x20(%rbx)
  5b29cf:	0f b6 44 24 24       	movzbl 0x24(%rsp),%eax
  5b29d4:	88 43 30             	mov    %al,0x30(%rbx)
  5b29d7:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  5b29db:	4c 89 73 10          	mov    %r14,0x10(%rbx)
  5b29df:	48 89 53 28          	mov    %rdx,0x28(%rbx)
  5b29e3:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  5b29ea:	e9 a4 21 00 00       	jmp    5b4b93 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3f63>
  5b29ef:	44 0f b6 a4 24 a1 09 	movzbl 0x9a1(%rsp),%r12d
  5b29f6:	00 00 
  5b29f8:	41 b6 01             	mov    $0x1,%r14b
  5b29fb:	41 bf 21 00 00 00    	mov    $0x21,%r15d
  5b2a01:	e9 7c 1f 00 00       	jmp    5b4982 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3d52>
  5b2a06:	45 89 e5             	mov    %r12d,%r13d
  5b2a09:	41 c1 ed 08          	shr    $0x8,%r13d
  5b2a0d:	4c 8b b4 24 58 0c 00 	mov    0xc58(%rsp),%r14
  5b2a14:	00 
  5b2a15:	41 bf 22 00 00 00    	mov    $0x22,%r15d
  5b2a1b:	41 83 fe 02          	cmp    $0x2,%r14d
  5b2a1f:	0f 85 a2 1f 00 00    	jne    5b49c7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3d97>
  5b2a25:	e9 aa 1f 00 00       	jmp    5b49d4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3da4>
  5b2a2a:	48 c7 84 24 98 03 00 	movq   $0xffffffffffffffff,0x398(%rsp)
  5b2a31:	00 ff ff ff ff 
  5b2a36:	48 8b 84 24 00 02 00 	mov    0x200(%rsp),%rax
  5b2a3d:	00 
  5b2a3e:	48 8b 30             	mov    (%rax),%rsi
  5b2a41:	48 85 f6             	test   %rsi,%rsi
  5b2a44:	0f 84 95 00 00 00    	je     5b2adf <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1eaf>
  5b2a4a:	b0 01                	mov    $0x1,%al
  5b2a4c:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b2a50:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b2a57:	00 
  5b2a58:	b0 01                	mov    $0x1,%al
  5b2a5a:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b2a5e:	41 b6 01             	mov    $0x1,%r14b
  5b2a61:	e8 6a 57 1c 00       	call   7781d0 <_RNvMNtNtCs6gaF1xUz9Bf_4gpui7runtime5imageNtB2_6Images9candidate>
  5b2a66:	4c 8b bc 24 d0 04 00 	mov    0x4d0(%rsp),%r15
  5b2a6d:	00 
  5b2a6e:	48 8b 8c 24 d8 04 00 	mov    0x4d8(%rsp),%rcx
  5b2a75:	00 
  5b2a76:	44 8b a4 24 d8 04 00 	mov    0x4d8(%rsp),%r12d
  5b2a7d:	00 
  5b2a7e:	8b ac 24 dc 04 00 00 	mov    0x4dc(%rsp),%ebp
  5b2a85:	0f 10 84 24 e0 04 00 	movups 0x4e0(%rsp),%xmm0
  5b2a8c:	00 
  5b2a8d:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  5b2a92:	66 0f 10 84 24 f0 04 	movupd 0x4f0(%rsp),%xmm0
  5b2a99:	00 00 
  5b2a9b:	66 0f 29 44 24 30    	movapd %xmm0,0x30(%rsp)
  5b2aa1:	0f b6 9c 24 00 05 00 	movzbl 0x500(%rsp),%ebx
  5b2aa8:	00 
  5b2aa9:	8b 84 24 01 05 00 00 	mov    0x501(%rsp),%eax
  5b2ab0:	89 84 24 a0 09 00 00 	mov    %eax,0x9a0(%rsp)
  5b2ab7:	8b 84 24 04 05 00 00 	mov    0x504(%rsp),%eax
  5b2abe:	89 84 24 a3 09 00 00 	mov    %eax,0x9a3(%rsp)
  5b2ac5:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  5b2ac9:	0f 85 a2 14 00 00    	jne    5b3f71 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3341>
  5b2acf:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  5b2ad6:	00 
  5b2ad7:	66 0f 28 44 24 60    	movapd 0x60(%rsp),%xmm0
  5b2add:	eb 07                	jmp    5b2ae6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1eb6>
  5b2adf:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  5b2ae6:	66 0f 11 84 24 00 04 	movupd %xmm0,0x400(%rsp)
  5b2aed:	00 00 
  5b2aef:	48 89 8c 24 f0 01 00 	mov    %rcx,0x1f0(%rsp)
  5b2af6:	00 
  5b2af7:	48 89 8c 24 f8 03 00 	mov    %rcx,0x3f8(%rsp)
  5b2afe:	00 
  5b2aff:	b0 01                	mov    $0x1,%al
  5b2b01:	89 84 24 c0 00 00 00 	mov    %eax,0xc0(%rsp)
  5b2b08:	48 8d bc 24 48 04 00 	lea    0x448(%rsp),%rdi
  5b2b0f:	00 
  5b2b10:	b0 01                	mov    $0x1,%al
  5b2b12:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b2b16:	b0 01                	mov    $0x1,%al
  5b2b18:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b2b1c:	41 b6 01             	mov    $0x1,%r14b
  5b2b1f:	48 8b 34 24          	mov    (%rsp),%rsi
  5b2b23:	e8 08 2f f9 ff       	call   545a30 <_RNvMs1_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataINtB7_7RuntimeNtNtB7_12style_ledger9AdversaryE13list_metadataB9_>
  5b2b28:	83 bc 24 58 0c 00 00 	cmpl   $0x2,0xc58(%rsp)
  5b2b2f:	02 
  5b2b30:	48 8d b4 24 58 0c 00 	lea    0xc58(%rsp),%rsi
  5b2b37:	00 
  5b2b38:	48 0f 44 34 24       	cmove  (%rsp),%rsi
  5b2b3d:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b2b44:	00 
  5b2b45:	ff 15 e5 75 53 00    	call   *0x5375e5(%rip)        # aea130 <_DYNAMIC+0x3d0>
  5b2b4b:	66 0f 10 05 1d 92 ab 	movupd -0x546de3(%rip),%xmm0        # 6bd70 <anon.1f6b7bab1fc61e0fcd36456038a862fb.97.llvm.12454362996328431623>
  5b2b52:	ff 
  5b2b53:	66 0f 29 84 24 d0 04 	movapd %xmm0,0x4d0(%rsp)
  5b2b5a:	00 00 
  5b2b5c:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b2b63:	00 
  5b2b64:	48 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%rsi
  5b2b6b:	00 
  5b2b6c:	ff 15 c6 75 53 00    	call   *0x5375c6(%rip)        # aea138 <_DYNAMIC+0x3d8>
  5b2b72:	48 8b 04 24          	mov    (%rsp),%rax
  5b2b76:	48 ff 80 30 09 00 00 	incq   0x930(%rax)
  5b2b7d:	48 8b 80 c8 02 00 00 	mov    0x2c8(%rax),%rax
  5b2b84:	48 89 84 24 70 03 00 	mov    %rax,0x370(%rsp)
  5b2b8b:	00 
  5b2b8c:	48 85 c0             	test   %rax,%rax
  5b2b8f:	0f 84 6e 13 00 00    	je     5b3f03 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x32d3>
  5b2b95:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  5b2b9b:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  5b2b9f:	f2 0f 11 84 24 78 03 	movsd  %xmm0,0x378(%rsp)
  5b2ba6:	00 00 
  5b2ba8:	48 8b 04 24          	mov    (%rsp),%rax
  5b2bac:	48 05 30 08 00 00    	add    $0x830,%rax
  5b2bb2:	48 89 84 24 68 03 00 	mov    %rax,0x368(%rsp)
  5b2bb9:	00 
  5b2bba:	45 31 e4             	xor    %r12d,%r12d
  5b2bbd:	48 8d 05 f4 62 50 00 	lea    0x5062f4(%rip),%rax        # ab8eb8 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0xc0>
  5b2bc4:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  5b2bc9:	48 b8 00 00 00 00 00 	movabs $0x8000000000000000,%rax
  5b2bd0:	00 00 80 
  5b2bd3:	48 ff c0             	inc    %rax
  5b2bd6:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  5b2bdd:	00 
  5b2bde:	48 8d 05 83 61 50 00 	lea    0x506183(%rip),%rax        # ab8d68 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x130>
  5b2be5:	48 89 84 24 68 02 00 	mov    %rax,0x268(%rsp)
  5b2bec:	00 
  5b2bed:	48 8d 05 c4 8e ac ff 	lea    -0x53713c(%rip),%rax        # 7bab8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5b2bf4:	48 89 84 24 60 02 00 	mov    %rax,0x260(%rsp)
  5b2bfb:	00 
  5b2bfc:	48 8d 05 c5 5d 50 00 	lea    0x505dc5(%rip),%rax        # ab89c8 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x60>
  5b2c03:	48 89 84 24 e8 01 00 	mov    %rax,0x1e8(%rsp)
  5b2c0a:	00 
  5b2c0b:	48 8d 05 d6 62 50 00 	lea    0x5062d6(%rip),%rax        # ab8ee8 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0xf0>
  5b2c12:	48 89 84 24 58 02 00 	mov    %rax,0x258(%rsp)
  5b2c19:	00 
  5b2c1a:	eb 35                	jmp    5b2c51 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2021>
  5b2c1c:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5b2c23:	00 
  5b2c24:	44 89 24 98          	mov    %r12d,(%rax,%rbx,4)
  5b2c28:	48 ff c3             	inc    %rbx
  5b2c2b:	48 89 9c 24 b8 00 00 	mov    %rbx,0xb8(%rsp)
  5b2c32:	00 
  5b2c33:	4c 8b a4 24 80 03 00 	mov    0x380(%rsp),%r12
  5b2c3a:	00 
  5b2c3b:	4c 3b a4 24 70 03 00 	cmp    0x370(%rsp),%r12
  5b2c42:	00 
  5b2c43:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  5b2c4a:	00 
  5b2c4b:	0f 84 b2 12 00 00    	je     5b3f03 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x32d3>
  5b2c51:	48 8b 04 24          	mov    (%rsp),%rax
  5b2c55:	4c 8b b8 40 07 00 00 	mov    0x740(%rax),%r15
  5b2c5c:	4d 39 fc             	cmp    %r15,%r12
  5b2c5f:	0f 83 1e 22 00 00    	jae    5b4e83 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4253>
  5b2c65:	48 8b 80 38 07 00 00 	mov    0x738(%rax),%rax
  5b2c6c:	4c 89 e1             	mov    %r12,%rcx
  5b2c6f:	48 c1 e1 04          	shl    $0x4,%rcx
  5b2c73:	66 0f 10 04 08       	movupd (%rax,%rcx,1),%xmm0
  5b2c78:	66 0f 29 84 24 70 04 	movapd %xmm0,0x470(%rsp)
  5b2c7f:	00 00 
  5b2c81:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b2c88:	00 
  5b2c89:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  5b2c8e:	48 8d 94 24 70 04 00 	lea    0x470(%rsp),%rdx
  5b2c95:	00 
  5b2c96:	ff 15 a4 74 53 00    	call   *0x5374a4(%rip)        # aea140 <_DYNAMIC+0x3e0>
  5b2c9c:	80 bc 24 d0 04 00 00 	cmpb   $0x0,0x4d0(%rsp)
  5b2ca3:	00 
  5b2ca4:	0f 85 c1 17 00 00    	jne    5b446b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x383b>
  5b2caa:	49 8d 74 24 01       	lea    0x1(%r12),%rsi
  5b2caf:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b2cb3:	48 8b 81 c8 02 00 00 	mov    0x2c8(%rcx),%rax
  5b2cba:	48 39 c6             	cmp    %rax,%rsi
  5b2cbd:	73 26                	jae    5b2ce5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x20b5>
  5b2cbf:	48 8b 89 c0 02 00 00 	mov    0x2c0(%rcx),%rcx
  5b2cc6:	48 8d 14 b6          	lea    (%rsi,%rsi,4),%rdx
  5b2cca:	8b 4c d1 18          	mov    0x18(%rcx,%rdx,8),%ecx
  5b2cce:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  5b2cd3:	48 39 d1             	cmp    %rdx,%rcx
  5b2cd6:	0f 95 c2             	setne  %dl
  5b2cd9:	49 39 cc             	cmp    %rcx,%r12
  5b2cdc:	40 0f 94 c7          	sete   %dil
  5b2ce0:	40 20 d7             	and    %dl,%dil
  5b2ce3:	eb 02                	jmp    5b2ce7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x20b7>
  5b2ce5:	31 ff                	xor    %edi,%edi
  5b2ce7:	f2 0f 10 9c 24 14 05 	movsd  0x514(%rsp),%xmm3
  5b2cee:	00 00 
  5b2cf0:	f2 0f 10 84 24 1c 05 	movsd  0x51c(%rsp),%xmm0
  5b2cf7:	00 00 
  5b2cf9:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  5b2d00:	00 
  5b2d01:	0f 10 84 24 e4 04 00 	movups 0x4e4(%rsp),%xmm0
  5b2d08:	00 
  5b2d09:	0f 29 84 24 e0 02 00 	movaps %xmm0,0x2e0(%rsp)
  5b2d10:	00 
  5b2d11:	f3 0f 10 8c 24 e8 04 	movss  0x4e8(%rsp),%xmm1
  5b2d18:	00 00 
  5b2d1a:	0f 10 84 24 f4 04 00 	movups 0x4f4(%rsp),%xmm0
  5b2d21:	00 
  5b2d22:	0f 29 84 24 20 02 00 	movaps %xmm0,0x220(%rsp)
  5b2d29:	00 
  5b2d2a:	f3 0f 10 94 24 fc 04 	movss  0x4fc(%rsp),%xmm2
  5b2d31:	00 00 
  5b2d33:	f3 0f 10 84 24 f8 04 	movss  0x4f8(%rsp),%xmm0
  5b2d3a:	00 00 
  5b2d3c:	f3 0f 11 84 24 84 00 	movss  %xmm0,0x84(%rsp)
  5b2d43:	00 00 
  5b2d45:	f2 0f 10 84 24 24 05 	movsd  0x524(%rsp),%xmm0
  5b2d4c:	00 00 
  5b2d4e:	0f 29 84 24 d0 02 00 	movaps %xmm0,0x2d0(%rsp)
  5b2d55:	00 
  5b2d56:	48 8b 8c 24 88 03 00 	mov    0x388(%rsp),%rcx
  5b2d5d:	00 
  5b2d5e:	48 8b 09             	mov    (%rcx),%rcx
  5b2d61:	48 8d 1d d0 8c ac ff 	lea    -0x537330(%rip),%rbx        # 7ba38 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x8>
  5b2d68:	48 85 c9             	test   %rcx,%rcx
  5b2d6b:	74 61                	je     5b2dce <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x219e>
  5b2d6d:	83 f9 02             	cmp    $0x2,%ecx
  5b2d70:	75 3d                	jne    5b2daf <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x217f>
  5b2d72:	48 8b 14 24          	mov    (%rsp),%rdx
  5b2d76:	4c 8b ba 48 02 00 00 	mov    0x248(%rdx),%r15
  5b2d7d:	4d 39 fc             	cmp    %r15,%r12
  5b2d80:	0f 83 e5 20 00 00    	jae    5b4e6b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x423b>
  5b2d86:	4c 8b ba 38 02 00 00 	mov    0x238(%rdx),%r15
  5b2d8d:	48 8b 8a 40 02 00 00 	mov    0x240(%rdx),%rcx
  5b2d94:	42 0f b6 0c 21       	movzbl (%rcx,%r12,1),%ecx
  5b2d99:	49 39 cf             	cmp    %rcx,%r15
  5b2d9c:	0f 86 d2 20 00 00    	jbe    5b4e74 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4244>
  5b2da2:	48 6b d9 58          	imul   $0x58,%rcx,%rbx
  5b2da6:	48 03 9a 30 02 00 00 	add    0x230(%rdx),%rbx
  5b2dad:	eb 1f                	jmp    5b2dce <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x219e>
  5b2daf:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b2db3:	4c 8b b9 40 02 00 00 	mov    0x240(%rcx),%r15
  5b2dba:	4d 39 fc             	cmp    %r15,%r12
  5b2dbd:	0f 83 9f 20 00 00    	jae    5b4e62 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4232>
  5b2dc3:	49 6b dc 58          	imul   $0x58,%r12,%rbx
  5b2dc7:	48 03 99 38 02 00 00 	add    0x238(%rcx),%rbx
  5b2dce:	f3 0f 11 8c 24 c0 02 	movss  %xmm1,0x2c0(%rsp)
  5b2dd5:	00 00 
  5b2dd7:	89 bc 24 08 02 00 00 	mov    %edi,0x208(%rsp)
  5b2dde:	49 39 c4             	cmp    %rax,%r12
  5b2de1:	0f 83 2d 20 00 00    	jae    5b4e14 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41e4>
  5b2de7:	48 89 b4 24 80 03 00 	mov    %rsi,0x380(%rsp)
  5b2dee:	00 
  5b2def:	48 8b 04 24          	mov    (%rsp),%rax
  5b2df3:	4c 8b b0 c0 02 00 00 	mov    0x2c0(%rax),%r14
  5b2dfa:	4f 8d 2c a4          	lea    (%r12,%r12,4),%r13
  5b2dfe:	47 8b 64 ee 18       	mov    0x18(%r14,%r13,8),%r12d
  5b2e03:	f2 0f 10 84 24 78 03 	movsd  0x378(%rsp),%xmm0
  5b2e0a:	00 00 
  5b2e0c:	f2 0f 11 84 24 d0 04 	movsd  %xmm0,0x4d0(%rsp)
  5b2e13:	00 00 
  5b2e15:	48 8d 84 24 d8 04 00 	lea    0x4d8(%rsp),%rax
  5b2e1c:	00 
  5b2e1d:	0f 57 c9             	xorps  %xmm1,%xmm1
  5b2e20:	0f 11 08             	movups %xmm1,(%rax)
  5b2e23:	f2 0f 11 84 24 e8 04 	movsd  %xmm0,0x4e8(%rsp)
  5b2e2a:	00 00 
  5b2e2c:	0f 11 48 18          	movups %xmm1,0x18(%rax)
  5b2e30:	c6 40 28 00          	movb   $0x0,0x28(%rax)
  5b2e34:	48 8d 84 24 d0 04 00 	lea    0x4d0(%rsp),%rax
  5b2e3b:	00 
  5b2e3c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  5b2e41:	49 39 cc             	cmp    %rcx,%r12
  5b2e44:	74 1d                	je     5b2e63 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2233>
  5b2e46:	4c 8b bc 24 40 01 00 	mov    0x140(%rsp),%r15
  5b2e4d:	00 
  5b2e4e:	4d 39 e7             	cmp    %r12,%r15
  5b2e51:	0f 86 c9 1f 00 00    	jbe    5b4e20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41f0>
  5b2e57:	49 6b c4 38          	imul   $0x38,%r12,%rax
  5b2e5b:	48 03 84 24 38 01 00 	add    0x138(%rsp),%rax
  5b2e62:	00 
  5b2e63:	f3 0f 11 94 24 0c 02 	movss  %xmm2,0x20c(%rsp)
  5b2e6a:	00 00 
  5b2e6c:	48 8b 48 30          	mov    0x30(%rax),%rcx
  5b2e70:	48 89 8c 24 a0 04 00 	mov    %rcx,0x4a0(%rsp)
  5b2e77:	00 
  5b2e78:	0f 10 00             	movups (%rax),%xmm0
  5b2e7b:	0f 10 48 10          	movups 0x10(%rax),%xmm1
  5b2e7f:	0f 10 50 20          	movups 0x20(%rax),%xmm2
  5b2e83:	0f 29 94 24 90 04 00 	movaps %xmm2,0x490(%rsp)
  5b2e8a:	00 
  5b2e8b:	0f 29 8c 24 80 04 00 	movaps %xmm1,0x480(%rsp)
  5b2e92:	00 
  5b2e93:	0f 29 84 24 70 04 00 	movaps %xmm0,0x470(%rsp)
  5b2e9a:	00 
  5b2e9b:	66 0f 28 05 7d ab ab 	movapd -0x545483(%rip),%xmm0        # 6da20 <anon.1f6b7bab1fc61e0fcd36456038a862fb.80.llvm.12454362996328431623+0x290>
  5b2ea2:	ff 
  5b2ea3:	66 0f 29 84 24 f0 00 	movapd %xmm0,0xf0(%rsp)
  5b2eaa:	00 00 
  5b2eac:	0f 29 9c 24 d0 0b 00 	movaps %xmm3,0xbd0(%rsp)
  5b2eb3:	00 
  5b2eb4:	0f 13 9c 24 00 01 00 	movlps %xmm3,0x100(%rsp)
  5b2ebb:	00 
  5b2ebc:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b2ec3:	00 
  5b2ec4:	48 8d b4 24 70 04 00 	lea    0x470(%rsp),%rsi
  5b2ecb:	00 
  5b2ecc:	48 8d 94 24 f0 00 00 	lea    0xf0(%rsp),%rdx
  5b2ed3:	00 
  5b2ed4:	ff 15 6e 72 53 00    	call   *0x53726e(%rip)        # aea148 <_DYNAMIC+0x3e8>
  5b2eda:	48 8b 43 4c          	mov    0x4c(%rbx),%rax
  5b2ede:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
  5b2ee5:	00 
  5b2ee6:	66 0f 10 43 3c       	movupd 0x3c(%rbx),%xmm0
  5b2eeb:	66 0f 29 84 24 f0 00 	movapd %xmm0,0xf0(%rsp)
  5b2ef2:	00 00 
  5b2ef4:	48 8d bc 24 30 09 00 	lea    0x930(%rsp),%rdi
  5b2efb:	00 
  5b2efc:	48 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%rsi
  5b2f03:	00 
  5b2f04:	48 8d 94 24 f0 00 00 	lea    0xf0(%rsp),%rdx
  5b2f0b:	00 
  5b2f0c:	ff 15 36 72 53 00    	call   *0x537236(%rip)        # aea148 <_DYNAMIC+0x3e8>
  5b2f12:	4c 8b bc 24 40 01 00 	mov    0x140(%rsp),%r15
  5b2f19:	00 
  5b2f1a:	4c 3b bc 24 30 01 00 	cmp    0x130(%rsp),%r15
  5b2f21:	00 
  5b2f22:	75 0d                	jne    5b2f31 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2301>
  5b2f24:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  5b2f2b:	00 
  5b2f2c:	e8 cf a7 21 00       	call   7cd700 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs1rQ3kaVqKLB_20gpui_reactivity_core8geometry15CoordinateSpaceE8grow_oneCs6gaF1xUz9Bf_4gpui>
  5b2f31:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  5b2f38:	00 
  5b2f39:	49 6b cf 38          	imul   $0x38,%r15,%rcx
  5b2f3d:	48 8b 94 24 60 09 00 	mov    0x960(%rsp),%rdx
  5b2f44:	00 
  5b2f45:	48 89 54 08 30       	mov    %rdx,0x30(%rax,%rcx,1)
  5b2f4a:	0f 28 84 24 30 09 00 	movaps 0x930(%rsp),%xmm0
  5b2f51:	00 
  5b2f52:	0f 28 8c 24 40 09 00 	movaps 0x940(%rsp),%xmm1
  5b2f59:	00 
  5b2f5a:	0f 28 94 24 50 09 00 	movaps 0x950(%rsp),%xmm2
  5b2f61:	00 
  5b2f62:	0f 11 54 08 20       	movups %xmm2,0x20(%rax,%rcx,1)
  5b2f67:	0f 11 4c 08 10       	movups %xmm1,0x10(%rax,%rcx,1)
  5b2f6c:	0f 11 04 08          	movups %xmm0,(%rax,%rcx,1)
  5b2f70:	66 0f 5a 84 24 30 09 	cvtpd2ps 0x930(%rsp),%xmm0
  5b2f77:	00 00 
  5b2f79:	66 0f 29 44 24 10    	movapd %xmm0,0x10(%rsp)
  5b2f7f:	49 ff c7             	inc    %r15
  5b2f82:	66 0f 5a 84 24 40 09 	cvtpd2ps 0x940(%rsp),%xmm0
  5b2f89:	00 00 
  5b2f8b:	66 0f 29 84 24 40 02 	movapd %xmm0,0x240(%rsp)
  5b2f92:	00 00 
  5b2f94:	4c 89 bc 24 40 01 00 	mov    %r15,0x140(%rsp)
  5b2f9b:	00 
  5b2f9c:	66 0f 5a 84 24 50 09 	cvtpd2ps 0x950(%rsp),%xmm0
  5b2fa3:	00 00 
  5b2fa5:	66 0f 29 44 24 30    	movapd %xmm0,0x30(%rsp)
  5b2fab:	48 8d bc 24 30 09 00 	lea    0x930(%rsp),%rdi
  5b2fb2:	00 
  5b2fb3:	ff 15 97 71 53 00    	call   *0x537197(%rip)        # aea150 <_DYNAMIC+0x3f0>
  5b2fb9:	c7 44 24 60 00 00 00 	movl   $0x0,0x60(%rsp)
  5b2fc0:	00 
  5b2fc1:	84 c0                	test   %al,%al
  5b2fc3:	0f 84 a1 00 00 00    	je     5b306a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x243a>
  5b2fc9:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  5b2fce:	66 0f 14 84 24 40 02 	unpcklpd 0x240(%rsp),%xmm0
  5b2fd5:	00 00 
  5b2fd7:	0f 29 84 24 10 02 00 	movaps %xmm0,0x210(%rsp)
  5b2fde:	00 
  5b2fdf:	0f 29 84 24 d0 04 00 	movaps %xmm0,0x4d0(%rsp)
  5b2fe6:	00 
  5b2fe7:	66 0f 28 44 24 30    	movapd 0x30(%rsp),%xmm0
  5b2fed:	66 0f 13 84 24 e0 04 	movlpd %xmm0,0x4e0(%rsp)
  5b2ff4:	00 00 
  5b2ff6:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b2ffd:	00 
  5b2ffe:	ff 15 54 71 53 00    	call   *0x537154(%rip)        # aea158 <_DYNAMIC+0x3f8>
  5b3004:	84 c0                	test   %al,%al
  5b3006:	74 62                	je     5b306a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x243a>
  5b3008:	0f 28 84 24 10 02 00 	movaps 0x210(%rsp),%xmm0
  5b300f:	00 
  5b3010:	0f 29 84 24 d0 04 00 	movaps %xmm0,0x4d0(%rsp)
  5b3017:	00 
  5b3018:	66 0f 28 44 24 30    	movapd 0x30(%rsp),%xmm0
  5b301e:	66 0f 13 84 24 e0 04 	movlpd %xmm0,0x4e0(%rsp)
  5b3025:	00 00 
  5b3027:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b302e:	00 
  5b302f:	ff 15 2b 71 53 00    	call   *0x53712b(%rip)        # aea160 <_DYNAMIC+0x400>
  5b3035:	84 c0                	test   %al,%al
  5b3037:	74 31                	je     5b306a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x243a>
  5b3039:	c7 44 24 60 01 00 00 	movl   $0x1,0x60(%rsp)
  5b3040:	00 
  5b3041:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  5b3046:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  5b304b:	0f 28 84 24 40 02 00 	movaps 0x240(%rsp),%xmm0
  5b3052:	00 
  5b3053:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  5b305a:	00 
  5b305b:	66 0f 28 44 24 30    	movapd 0x30(%rsp),%xmm0
  5b3061:	66 0f 29 84 24 d0 01 	movapd %xmm0,0x1d0(%rsp)
  5b3068:	00 00 
  5b306a:	4f 8d 2c ee          	lea    (%r14,%r13,8),%r13
  5b306e:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  5b3074:	74 71                	je     5b30e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x24b7>
  5b3076:	45 8b 65 18          	mov    0x18(%r13),%r12d
  5b307a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  5b307f:	49 39 c4             	cmp    %rax,%r12
  5b3082:	0f 84 8b 00 00 00    	je     5b3113 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x24e3>
  5b3088:	4c 8b bc 24 58 01 00 	mov    0x158(%rsp),%r15
  5b308f:	00 
  5b3090:	4d 39 e7             	cmp    %r12,%r15
  5b3093:	0f 86 99 1d 00 00    	jbe    5b4e32 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4202>
  5b3099:	48 8b 8c 24 50 01 00 	mov    0x150(%rsp),%rcx
  5b30a0:	00 
  5b30a1:	4c 89 e0             	mov    %r12,%rax
  5b30a4:	48 c1 e0 04          	shl    $0x4,%rax
  5b30a8:	66 0f 10 04 01       	movupd (%rcx,%rax,1),%xmm0
  5b30ad:	66 0f 29 84 24 d0 00 	movapd %xmm0,0xd0(%rsp)
  5b30b4:	00 00 
  5b30b6:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
  5b30ba:	66 0f 14 84 24 f0 02 	unpcklpd 0x2f0(%rsp),%xmm0
  5b30c1:	00 00 
  5b30c3:	66 0f 11 84 24 d0 04 	movupd %xmm0,0x4d0(%rsp)
  5b30ca:	00 00 
  5b30cc:	4c 8b bc 24 70 01 00 	mov    0x170(%rsp),%r15
  5b30d3:	00 
  5b30d4:	4d 39 e7             	cmp    %r12,%r15
  5b30d7:	0f 86 5e 1d 00 00    	jbe    5b4e3b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x420b>
  5b30dd:	48 03 84 24 68 01 00 	add    0x168(%rsp),%rax
  5b30e4:	00 
  5b30e5:	eb 53                	jmp    5b313a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x250a>
  5b30e7:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
  5b30eb:	66 0f 14 84 24 f0 02 	unpcklpd 0x2f0(%rsp),%xmm0
  5b30f2:	00 00 
  5b30f4:	66 0f 29 84 24 d0 00 	movapd %xmm0,0xd0(%rsp)
  5b30fb:	00 00 
  5b30fd:	66 0f 29 84 24 a0 01 	movapd %xmm0,0x1a0(%rsp)
  5b3104:	00 00 
  5b3106:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%rsp)
  5b310d:	00 
  5b310e:	e9 c0 00 00 00       	jmp    5b31d3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x25a3>
  5b3113:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
  5b3117:	66 0f 14 84 24 f0 02 	unpcklpd 0x2f0(%rsp),%xmm0
  5b311e:	00 00 
  5b3120:	66 0f 29 84 24 d0 00 	movapd %xmm0,0xd0(%rsp)
  5b3127:	00 00 
  5b3129:	66 0f 11 84 24 d0 04 	movupd %xmm0,0x4d0(%rsp)
  5b3130:	00 00 
  5b3132:	48 8d 84 24 d0 04 00 	lea    0x4d0(%rsp),%rax
  5b3139:	00 
  5b313a:	66 0f 10 00          	movupd (%rax),%xmm0
  5b313e:	66 0f 29 84 24 a0 01 	movapd %xmm0,0x1a0(%rsp)
  5b3145:	00 00 
  5b3147:	41 8b 45 20          	mov    0x20(%r13),%eax
  5b314b:	83 e0 07             	and    $0x7,%eax
  5b314e:	83 f8 05             	cmp    $0x5,%eax
  5b3151:	73 34                	jae    5b3187 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2557>
  5b3153:	4c 8b bc 24 88 01 00 	mov    0x188(%rsp),%r15
  5b315a:	00 
  5b315b:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  5b315f:	74 1c                	je     5b317d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x254d>
  5b3161:	4d 39 e7             	cmp    %r12,%r15
  5b3164:	0f 86 ef 1c 00 00    	jbe    5b4e59 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4229>
  5b316a:	48 8b 84 24 80 01 00 	mov    0x180(%rsp),%rax
  5b3171:	00 
  5b3172:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax
  5b3177:	89 44 24 30          	mov    %eax,0x30(%rsp)
  5b317b:	eb 24                	jmp    5b31a1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2571>
  5b317d:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%rsp)
  5b3184:	00 
  5b3185:	eb 1a                	jmp    5b31a1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2571>
  5b3187:	74 0a                	je     5b3193 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2563>
  5b3189:	83 f8 06             	cmp    $0x6,%eax
  5b318c:	74 c5                	je     5b3153 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2523>
  5b318e:	e9 c5 1b 00 00       	jmp    5b4d58 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4128>
  5b3193:	b0 01                	mov    $0x1,%al
  5b3195:	89 44 24 30          	mov    %eax,0x30(%rsp)
  5b3199:	4c 8b bc 24 88 01 00 	mov    0x188(%rsp),%r15
  5b31a0:	00 
  5b31a1:	4c 3b bc 24 78 01 00 	cmp    0x178(%rsp),%r15
  5b31a8:	00 
  5b31a9:	75 0d                	jne    5b31b8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2588>
  5b31ab:	48 8d bc 24 78 01 00 	lea    0x178(%rsp),%rdi
  5b31b2:	00 
  5b31b3:	e8 d8 ab 21 00       	call   7cdd90 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecbE8grow_oneCs6gaF1xUz9Bf_4gpui>
  5b31b8:	48 8b 84 24 80 01 00 	mov    0x180(%rsp),%rax
  5b31bf:	00 
  5b31c0:	8b 4c 24 30          	mov    0x30(%rsp),%ecx
  5b31c4:	42 88 0c 38          	mov    %cl,(%rax,%r15,1)
  5b31c8:	49 ff c7             	inc    %r15
  5b31cb:	4c 89 bc 24 88 01 00 	mov    %r15,0x188(%rsp)
  5b31d2:	00 
  5b31d3:	41 8b 45 20          	mov    0x20(%r13),%eax
  5b31d7:	83 e0 07             	and    $0x7,%eax
  5b31da:	b9 a1 00 00 00       	mov    $0xa1,%ecx
  5b31df:	48 89 8c 24 f8 01 00 	mov    %rcx,0x1f8(%rsp)
  5b31e6:	00 
  5b31e7:	b9 4f 00 00 00       	mov    $0x4f,%ecx
  5b31ec:	0f a3 c1             	bt     %eax,%ecx
  5b31ef:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
  5b31f3:	66 0f 14 84 24 30 02 	unpcklpd 0x230(%rsp),%xmm0
  5b31fa:	00 00 
  5b31fc:	66 0f 29 44 24 10    	movapd %xmm0,0x10(%rsp)
  5b3202:	0f 82 e3 00 00 00    	jb     5b32eb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x26bb>
  5b3208:	b9 30 00 00 00       	mov    $0x30,%ecx
  5b320d:	0f a3 c1             	bt     %eax,%ecx
  5b3210:	0f 83 3c 1a 00 00    	jae    5b4c52 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4022>
  5b3216:	8b 44 24 60          	mov    0x60(%rsp),%eax
  5b321a:	89 84 24 f0 00 00 00 	mov    %eax,0xf0(%rsp)
  5b3221:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  5b3226:	66 0f 14 84 24 c0 00 	unpcklpd 0xc0(%rsp),%xmm0
  5b322d:	00 00 
  5b322f:	0f 11 84 24 f4 00 00 	movups %xmm0,0xf4(%rsp)
  5b3236:	00 
  5b3237:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  5b323e:	00 
  5b323f:	0f 13 84 24 04 01 00 	movlps %xmm0,0x104(%rsp)
  5b3246:	00 
  5b3247:	66 0f 28 44 24 10    	movapd 0x10(%rsp),%xmm0
  5b324d:	66 0f 11 84 24 e0 00 	movupd %xmm0,0xe0(%rsp)
  5b3254:	00 00 
  5b3256:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b325d:	00 
  5b325e:	48 8d b4 24 d0 00 00 	lea    0xd0(%rsp),%rsi
  5b3265:	00 
  5b3266:	48 8d 94 24 a0 01 00 	lea    0x1a0(%rsp),%rdx
  5b326d:	00 
  5b326e:	48 8d 8c 24 f0 00 00 	lea    0xf0(%rsp),%rcx
  5b3275:	00 
  5b3276:	4c 8d 84 24 e0 00 00 	lea    0xe0(%rsp),%r8
  5b327d:	00 
  5b327e:	4c 8b 8c 24 90 00 00 	mov    0x90(%rsp),%r9
  5b3285:	00 
  5b3286:	e8 75 be 21 00       	call   7cf100 <_RNvNtNtCs6gaF1xUz9Bf_4gpui7runtime4list13viewport_clip>
  5b328b:	4c 8b bc 24 d0 04 00 	mov    0x4d0(%rsp),%r15
  5b3292:	00 
  5b3293:	44 8b a4 24 d8 04 00 	mov    0x4d8(%rsp),%r12d
  5b329a:	00 
  5b329b:	8b ac 24 dc 04 00 00 	mov    0x4dc(%rsp),%ebp
  5b32a2:	f3 0f 6f 84 24 e0 04 	movdqu 0x4e0(%rsp),%xmm0
  5b32a9:	00 00 
  5b32ab:	48 8b 84 24 f0 04 00 	mov    0x4f0(%rsp),%rax
  5b32b2:	00 
  5b32b3:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  5b32b7:	0f 85 26 18 00 00    	jne    5b4ae3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3eb3>
  5b32bd:	44 89 a4 24 d0 00 00 	mov    %r12d,0xd0(%rsp)
  5b32c4:	00 
  5b32c5:	89 ac 24 d4 00 00 00 	mov    %ebp,0xd4(%rsp)
  5b32cc:	66 0f d6 84 24 d8 00 	movq   %xmm0,0xd8(%rsp)
  5b32d3:	00 00 
  5b32d5:	66 0f 70 c0 ee       	pshufd $0xee,%xmm0,%xmm0
  5b32da:	66 0f d6 84 24 a0 01 	movq   %xmm0,0x1a0(%rsp)
  5b32e1:	00 00 
  5b32e3:	48 89 84 24 a8 01 00 	mov    %rax,0x1a8(%rsp)
  5b32ea:	00 
  5b32eb:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  5b32f1:	0f 84 8e 00 00 00    	je     5b3385 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2755>
  5b32f7:	4c 8b b4 24 58 01 00 	mov    0x158(%rsp),%r14
  5b32fe:	00 
  5b32ff:	4c 3b b4 24 48 01 00 	cmp    0x148(%rsp),%r14
  5b3306:	00 
  5b3307:	75 0d                	jne    5b3316 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x26e6>
  5b3309:	48 8d bc 24 48 01 00 	lea    0x148(%rsp),%rdi
  5b3310:	00 
  5b3311:	e8 5a a4 21 00       	call   7cd770 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs1rQ3kaVqKLB_20gpui_reactivity_core8geometry4RectE8grow_oneCs6gaF1xUz9Bf_4gpui>
  5b3316:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  5b331d:	00 
  5b331e:	4c 89 f1             	mov    %r14,%rcx
  5b3321:	48 c1 e1 04          	shl    $0x4,%rcx
  5b3325:	66 0f 28 84 24 d0 00 	movapd 0xd0(%rsp),%xmm0
  5b332c:	00 00 
  5b332e:	66 0f 11 04 08       	movupd %xmm0,(%rax,%rcx,1)
  5b3333:	49 ff c6             	inc    %r14
  5b3336:	4c 89 b4 24 58 01 00 	mov    %r14,0x158(%rsp)
  5b333d:	00 
  5b333e:	4c 8b b4 24 70 01 00 	mov    0x170(%rsp),%r14
  5b3345:	00 
  5b3346:	4c 3b b4 24 60 01 00 	cmp    0x160(%rsp),%r14
  5b334d:	00 
  5b334e:	75 0d                	jne    5b335d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x272d>
  5b3350:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  5b3357:	00 
  5b3358:	e8 13 a4 21 00       	call   7cd770 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs1rQ3kaVqKLB_20gpui_reactivity_core8geometry4RectE8grow_oneCs6gaF1xUz9Bf_4gpui>
  5b335d:	48 8b 84 24 68 01 00 	mov    0x168(%rsp),%rax
  5b3364:	00 
  5b3365:	4c 89 f1             	mov    %r14,%rcx
  5b3368:	48 c1 e1 04          	shl    $0x4,%rcx
  5b336c:	66 0f 6f 84 24 a0 01 	movdqa 0x1a0(%rsp),%xmm0
  5b3373:	00 00 
  5b3375:	f3 0f 7f 04 08       	movdqu %xmm0,(%rax,%rcx,1)
  5b337a:	49 ff c6             	inc    %r14
  5b337d:	4c 89 b4 24 70 01 00 	mov    %r14,0x170(%rsp)
  5b3384:	00 
  5b3385:	83 7c 24 60 00       	cmpl   $0x0,0x60(%rsp)
  5b338a:	74 7a                	je     5b3406 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x27d6>
  5b338c:	0f 5a 44 24 40       	cvtps2pd 0x40(%rsp),%xmm0
  5b3391:	0f 29 84 24 d0 04 00 	movaps %xmm0,0x4d0(%rsp)
  5b3398:	00 
  5b3399:	0f 5a 84 24 c0 00 00 	cvtps2pd 0xc0(%rsp),%xmm0
  5b33a0:	00 
  5b33a1:	0f 5a 8c 24 d0 01 00 	cvtps2pd 0x1d0(%rsp),%xmm1
  5b33a8:	00 
  5b33a9:	0f 29 84 24 e0 04 00 	movaps %xmm0,0x4e0(%rsp)
  5b33b0:	00 
  5b33b1:	0f 29 8c 24 f0 04 00 	movaps %xmm1,0x4f0(%rsp)
  5b33b8:	00 
  5b33b9:	c6 84 24 00 05 00 00 	movb   $0x0,0x500(%rsp)
  5b33c0:	00 
  5b33c1:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
  5b33c7:	f3 0f 7f 84 24 e0 00 	movdqu %xmm0,0xe0(%rsp)
  5b33ce:	00 00 
  5b33d0:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  5b33d7:	00 
  5b33d8:	48 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%rsi
  5b33df:	00 
  5b33e0:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
  5b33e7:	00 
  5b33e8:	ff 15 7a 6d 53 00    	call   *0x536d7a(%rip)        # aea168 <_DYNAMIC+0x408>
  5b33ee:	83 bc 24 f0 00 00 00 	cmpl   $0x1,0xf0(%rsp)
  5b33f5:	01 
  5b33f6:	75 0e                	jne    5b3406 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x27d6>
  5b33f8:	48 8d 84 24 f4 00 00 	lea    0xf4(%rsp),%rax
  5b33ff:	00 
  5b3400:	f3 0f 6f 00          	movdqu (%rax),%xmm0
  5b3404:	eb 04                	jmp    5b340a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x27da>
  5b3406:	66 0f ef c0          	pxor   %xmm0,%xmm0
  5b340a:	66 0f 7f 84 24 00 03 	movdqa %xmm0,0x300(%rsp)
  5b3411:	00 00 
  5b3413:	80 7c 24 30 00       	cmpb   $0x0,0x30(%rsp)
  5b3418:	74 22                	je     5b343c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x280c>
  5b341a:	48 8d bc 24 18 03 00 	lea    0x318(%rsp),%rdi
  5b3421:	00 
  5b3422:	48 8d b4 24 00 03 00 	lea    0x300(%rsp),%rsi
  5b3429:	00 
  5b342a:	48 8d 94 24 a0 01 00 	lea    0x1a0(%rsp),%rdx
  5b3431:	00 
  5b3432:	e8 49 c0 21 00       	call   7cf480 <_RNvNtNtCs6gaF1xUz9Bf_4gpui7runtime4list14clipped_bounds>
  5b3437:	e9 82 00 00 00       	jmp    5b34be <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x288e>
  5b343c:	41 8b 45 20          	mov    0x20(%r13),%eax
  5b3440:	83 e0 07             	and    $0x7,%eax
  5b3443:	b9 6f 00 00 00       	mov    $0x6f,%ecx
  5b3448:	0f a3 c1             	bt     %eax,%ecx
  5b344b:	0f 83 a4 0a 00 00    	jae    5b3ef5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x32c5>
  5b3451:	f2 0f 10 84 24 00 03 	movsd  0x300(%rsp),%xmm0
  5b3458:	00 00 
  5b345a:	f2 0f 10 8c 24 08 03 	movsd  0x308(%rsp),%xmm1
  5b3461:	00 00 
  5b3463:	0f 28 d0             	movaps %xmm0,%xmm2
  5b3466:	0f 58 c8             	addps  %xmm0,%xmm1
  5b3469:	0f 57 e4             	xorps  %xmm4,%xmm4
  5b346c:	0f 5f c4             	maxps  %xmm4,%xmm0
  5b346f:	0f 28 d8             	movaps %xmm0,%xmm3
  5b3472:	0f c2 d8 03          	cmpunordps %xmm0,%xmm3
  5b3476:	0f 54 d3             	andps  %xmm3,%xmm2
  5b3479:	0f 55 d8             	andnps %xmm0,%xmm3
  5b347c:	0f 56 da             	orps   %xmm2,%xmm3
  5b347f:	0f 28 c1             	movaps %xmm1,%xmm0
  5b3482:	0f 5d 84 24 f0 02 00 	minps  0x2f0(%rsp),%xmm0
  5b3489:	00 
  5b348a:	0f 28 d0             	movaps %xmm0,%xmm2
  5b348d:	0f c2 d0 03          	cmpunordps %xmm0,%xmm2
  5b3491:	0f 54 ca             	andps  %xmm2,%xmm1
  5b3494:	0f 55 d0             	andnps %xmm0,%xmm2
  5b3497:	0f 56 d1             	orps   %xmm1,%xmm2
  5b349a:	0f 5c d3             	subps  %xmm3,%xmm2
  5b349d:	0f 28 c2             	movaps %xmm2,%xmm0
  5b34a0:	0f 5f c4             	maxps  %xmm4,%xmm0
  5b34a3:	0f 28 c8             	movaps %xmm0,%xmm1
  5b34a6:	0f c2 c8 03          	cmpunordps %xmm0,%xmm1
  5b34aa:	0f 54 d1             	andps  %xmm1,%xmm2
  5b34ad:	0f 55 c8             	andnps %xmm0,%xmm1
  5b34b0:	0f 56 ca             	orps   %xmm2,%xmm1
  5b34b3:	0f 16 d9             	movlhps %xmm1,%xmm3
  5b34b6:	0f 11 9c 24 18 03 00 	movups %xmm3,0x318(%rsp)
  5b34bd:	00 
  5b34be:	8b 43 38             	mov    0x38(%rbx),%eax
  5b34c1:	b9 ff ff ff 3f       	mov    $0x3fffffff,%ecx
  5b34c6:	21 c8                	and    %ecx,%eax
  5b34c8:	3d 01 00 80 3f       	cmp    $0x3f800001,%eax
  5b34cd:	b9 00 00 00 80       	mov    $0x80000000,%ecx
  5b34d2:	0f 44 c1             	cmove  %ecx,%eax
  5b34d5:	66 0f 6e c8          	movd   %eax,%xmm1
  5b34d9:	0f 57 c0             	xorps  %xmm0,%xmm0
  5b34dc:	66 0f 7e 8c 24 10 02 	movd   %xmm1,0x210(%rsp)
  5b34e3:	00 00 
  5b34e5:	0f 2e c8             	ucomiss %xmm0,%xmm1
  5b34e8:	0f 86 b3 00 00 00    	jbe    5b35a1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2971>
  5b34ee:	c7 84 24 d8 04 00 00 	movl   $0x1,0x4d8(%rsp)
  5b34f5:	01 00 00 00 
  5b34f9:	48 c7 84 24 d0 04 00 	movq   $0x22,0x4d0(%rsp)
  5b3500:	00 22 00 00 00 
  5b3505:	80 7c 24 60 00       	cmpb   $0x0,0x60(%rsp)
  5b350a:	0f 84 d5 12 00 00    	je     5b47e5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3bb5>
  5b3510:	4c 8d 73 2c          	lea    0x2c(%rbx),%r14
  5b3514:	4c 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%r15
  5b351b:	00 
  5b351c:	4c 89 ff             	mov    %r15,%rdi
  5b351f:	e8 5c 43 f8 ff       	call   537880 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime5ErrorEBF_.llvm.18021777786862421399>
  5b3524:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  5b3529:	66 0f 14 84 24 c0 00 	unpcklpd 0xc0(%rsp),%xmm0
  5b3530:	00 00 
  5b3532:	0f 29 84 24 e0 0b 00 	movaps %xmm0,0xbe0(%rsp)
  5b3539:	00 
  5b353a:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  5b3541:	00 
  5b3542:	0f 13 84 24 f0 0b 00 	movlps %xmm0,0xbf0(%rsp)
  5b3549:	00 
  5b354a:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  5b3551:	00 
  5b3552:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  5b3559:	00 
  5b355a:	41 0f 10 06          	movups (%r14),%xmm0
  5b355e:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  5b3565:	00 
  5b3566:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  5b356b:	0f 11 84 24 d0 04 00 	movups %xmm0,0x4d0(%rsp)
  5b3572:	00 
  5b3573:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b357a:	00 
  5b357b:	4c 89 fe             	mov    %r15,%rsi
  5b357e:	48 8d 94 24 e0 0b 00 	lea    0xbe0(%rsp),%rdx
  5b3585:	00 
  5b3586:	48 8d 8c 24 e0 00 00 	lea    0xe0(%rsp),%rcx
  5b358d:	00 
  5b358e:	4c 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%r8
  5b3595:	00 
  5b3596:	ff 15 d4 6b 53 00    	call   *0x536bd4(%rip)        # aea170 <_DYNAMIC+0x410>
  5b359c:	e9 c5 00 00 00       	jmp    5b3666 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2a36>
  5b35a1:	49 83 7d 08 00       	cmpq   $0x0,0x8(%r13)
  5b35a6:	75 11                	jne    5b35b9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2989>
  5b35a8:	41 8b 7d 20          	mov    0x20(%r13),%edi
  5b35ac:	e8 0f 58 f9 ff       	call   548dc0 <_RNvMsh_NtCs6gaF1xUz9Bf_4gpui7runtimeNtB5_4Node4kind>
  5b35b1:	3c 02                	cmp    $0x2,%al
  5b35b3:	0f 85 b9 00 00 00    	jne    5b3672 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2a42>
  5b35b9:	c7 84 24 d8 04 00 00 	movl   $0x1,0x4d8(%rsp)
  5b35c0:	01 00 00 00 
  5b35c4:	48 c7 84 24 d0 04 00 	movq   $0x22,0x4d0(%rsp)
  5b35cb:	00 22 00 00 00 
  5b35d0:	80 7c 24 60 00       	cmpb   $0x0,0x60(%rsp)
  5b35d5:	0f 84 0a 12 00 00    	je     5b47e5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3bb5>
  5b35db:	4c 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%r14
  5b35e2:	00 
  5b35e3:	4c 89 f7             	mov    %r14,%rdi
  5b35e6:	e8 95 42 f8 ff       	call   537880 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime5ErrorEBF_.llvm.18021777786862421399>
  5b35eb:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  5b35f0:	66 0f 14 84 24 c0 00 	unpcklpd 0xc0(%rsp),%xmm0
  5b35f7:	00 00 
  5b35f9:	0f 29 84 24 00 0c 00 	movaps %xmm0,0xc00(%rsp)
  5b3600:	00 
  5b3601:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  5b3608:	00 
  5b3609:	0f 13 84 24 10 0c 00 	movlps %xmm0,0xc10(%rsp)
  5b3610:	00 
  5b3611:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  5b3618:	00 
  5b3619:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  5b3620:	00 
  5b3621:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  5b3626:	0f 11 84 24 f0 00 00 	movups %xmm0,0xf0(%rsp)
  5b362d:	00 
  5b362e:	0f 10 05 6b a1 ab ff 	movups -0x545e95(%rip),%xmm0        # 6d7a0 <anon.1f6b7bab1fc61e0fcd36456038a862fb.80.llvm.12454362996328431623+0x10>
  5b3635:	0f 29 84 24 d0 04 00 	movaps %xmm0,0x4d0(%rsp)
  5b363c:	00 
  5b363d:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b3644:	00 
  5b3645:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  5b364c:	00 
  5b364d:	48 8d 94 24 00 0c 00 	lea    0xc00(%rsp),%rdx
  5b3654:	00 
  5b3655:	48 8d 8c 24 e0 00 00 	lea    0xe0(%rsp),%rcx
  5b365c:	00 
  5b365d:	4d 89 f0             	mov    %r14,%r8
  5b3660:	ff 15 0a 6b 53 00    	call   *0x536b0a(%rip)        # aea170 <_DYNAMIC+0x410>
  5b3666:	41 89 c4             	mov    %eax,%r12d
  5b3669:	83 f8 ff             	cmp    $0xffffffff,%eax
  5b366c:	0f 85 71 09 00 00    	jne    5b3fe3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x33b3>
  5b3672:	45 8b 75 20          	mov    0x20(%r13),%r14d
  5b3676:	44 89 f0             	mov    %r14d,%eax
  5b3679:	83 e0 07             	and    $0x7,%eax
  5b367c:	83 f8 06             	cmp    $0x6,%eax
  5b367f:	0f 83 5d 02 00 00    	jae    5b38e2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2cb2>
  5b3685:	45 89 f4             	mov    %r14d,%r12d
  5b3688:	41 c1 ec 03          	shr    $0x3,%r12d
  5b368c:	0f 84 56 02 00 00    	je     5b38e8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2cb8>
  5b3692:	48 8b 04 24          	mov    (%rsp),%rax
  5b3696:	4c 8b b8 e0 02 00 00 	mov    0x2e0(%rax),%r15
  5b369d:	41 ff cc             	dec    %r12d
  5b36a0:	4d 39 e7             	cmp    %r12,%r15
  5b36a3:	0f 86 80 17 00 00    	jbe    5b4e29 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41f9>
  5b36a9:	48 8b a8 d8 02 00 00 	mov    0x2d8(%rax),%rbp
  5b36b0:	4b 8d 0c a4          	lea    (%r12,%r12,4),%rcx
  5b36b4:	48 c1 e1 04          	shl    $0x4,%rcx
  5b36b8:	48 8b 44 0d 00       	mov    0x0(%rbp,%rcx,1),%rax
  5b36bd:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  5b36c1:	0f 84 2f 16 00 00    	je     5b4cf6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x40c6>
  5b36c7:	0f 10 43 1c          	movups 0x1c(%rbx),%xmm0
  5b36cb:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  5b36d2:	00 
  5b36d3:	48 8b 94 24 90 01 00 	mov    0x190(%rsp),%rdx
  5b36da:	00 
  5b36db:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  5b36df:	0f 84 23 15 00 00    	je     5b4c08 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3fd8>
  5b36e5:	48 83 bc 24 20 01 00 	cmpq   $0x0,0x120(%rsp)
  5b36ec:	00 00 
  5b36ee:	0f 84 05 15 00 00    	je     5b4bf9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3fc9>
  5b36f4:	48 01 cd             	add    %rcx,%rbp
  5b36f7:	f3 0f 10 43 18       	movss  0x18(%rbx),%xmm0
  5b36fc:	0f 28 8c 24 30 02 00 	movaps 0x230(%rsp),%xmm1
  5b3703:	00 
  5b3704:	f3 0f 5c 8c 24 20 02 	subss  0x220(%rsp),%xmm1
  5b370b:	00 00 
  5b370d:	f3 0f 5c 8c 24 84 00 	subss  0x84(%rsp),%xmm1
  5b3714:	00 00 
  5b3716:	f3 0f 5c 8c 24 e0 02 	subss  0x2e0(%rsp),%xmm1
  5b371d:	00 00 
  5b371f:	f3 0f 5c 8c 24 c0 02 	subss  0x2c0(%rsp),%xmm1
  5b3726:	00 00 
  5b3728:	f3 0f 5c 8c 24 d0 02 	subss  0x2d0(%rsp),%xmm1
  5b372f:	00 00 
  5b3731:	f3 0f 5f 0d a3 a8 ab 	maxss  -0x54575d(%rip),%xmm1        # 6dfdc <anon.5f884de6e78125e25881320d811d32df.286.llvm.17146438997930651657+0x10>
  5b3738:	ff 
  5b3739:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5b373d:	74 13                	je     5b3752 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2b22>
  5b373f:	83 7d 38 01          	cmpl   $0x1,0x38(%rbp)
  5b3743:	75 0d                	jne    5b3752 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2b22>
  5b3745:	66 0f 7e c8          	movd   %xmm1,%eax
  5b3749:	39 45 3c             	cmp    %eax,0x3c(%rbp)
  5b374c:	0f 84 d3 00 00 00    	je     5b3825 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2bf5>
  5b3752:	48 8b 55 40          	mov    0x40(%rbp),%rdx
  5b3756:	48 8b 0a             	mov    (%rdx),%rcx
  5b3759:	48 d1 e9             	shr    $1,%rcx
  5b375c:	48 83 c2 10          	add    $0x10,%rdx
  5b3760:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b3767:	00 
  5b3768:	48 8d b4 24 20 01 00 	lea    0x120(%rsp),%rsi
  5b376f:	00 
  5b3770:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  5b3776:	f3 0f 11 8c 24 84 00 	movss  %xmm1,0x84(%rsp)
  5b377d:	00 00 
  5b377f:	ff 15 2b 69 53 00    	call   *0x53692b(%rip)        # aea0b0 <_DYNAMIC+0x350>
  5b3785:	48 8b 9c 24 d0 04 00 	mov    0x4d0(%rsp),%rbx
  5b378c:	00 
  5b378d:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5b3791:	0f 84 6a 10 00 00    	je     5b4801 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3bd1>
  5b3797:	f2 0f 10 84 24 d8 04 	movsd  0x4d8(%rsp),%xmm0
  5b379e:	00 00 
  5b37a0:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
  5b37a7:	00 
  5b37a8:	48 8d 8c 24 d8 04 00 	lea    0x4d8(%rsp),%rcx
  5b37af:	00 
  5b37b0:	48 8b 41 28          	mov    0x28(%rcx),%rax
  5b37b4:	48 89 84 24 10 01 00 	mov    %rax,0x110(%rsp)
  5b37bb:	00 
  5b37bc:	0f 10 41 08          	movups 0x8(%rcx),%xmm0
  5b37c0:	0f 10 49 18          	movups 0x18(%rcx),%xmm1
  5b37c4:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  5b37cb:	00 
  5b37cc:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  5b37d3:	00 
  5b37d4:	48 89 ef             	mov    %rbp,%rdi
  5b37d7:	e8 c4 5e f7 ff       	call   5296a0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime6ShapedEEB11_.llvm.18021777786862421399>
  5b37dc:	48 89 5d 00          	mov    %rbx,0x0(%rbp)
  5b37e0:	0f 28 84 24 c0 02 00 	movaps 0x2c0(%rsp),%xmm0
  5b37e7:	00 
  5b37e8:	0f 13 45 08          	movlps %xmm0,0x8(%rbp)
  5b37ec:	0f 28 84 24 f0 00 00 	movaps 0xf0(%rsp),%xmm0
  5b37f3:	00 
  5b37f4:	0f 28 8c 24 00 01 00 	movaps 0x100(%rsp),%xmm1
  5b37fb:	00 
  5b37fc:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  5b3800:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  5b3804:	48 8b 84 24 10 01 00 	mov    0x110(%rsp),%rax
  5b380b:	00 
  5b380c:	48 89 45 30          	mov    %rax,0x30(%rbp)
  5b3810:	c7 45 38 01 00 00 00 	movl   $0x1,0x38(%rbp)
  5b3817:	f3 0f 10 84 24 84 00 	movss  0x84(%rsp),%xmm0
  5b381e:	00 00 
  5b3820:	f3 0f 11 45 3c       	movss  %xmm0,0x3c(%rbp)
  5b3825:	c7 84 24 d8 04 00 00 	movl   $0x1,0x4d8(%rsp)
  5b382c:	01 00 00 00 
  5b3830:	48 c7 84 24 d0 04 00 	movq   $0x22,0x4d0(%rsp)
  5b3837:	00 22 00 00 00 
  5b383c:	80 7c 24 60 00       	cmpb   $0x0,0x60(%rsp)
  5b3841:	0f 84 ac 0f 00 00    	je     5b47f3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3bc3>
  5b3847:	48 8d 9c 24 d0 04 00 	lea    0x4d0(%rsp),%rbx
  5b384e:	00 
  5b384f:	48 89 df             	mov    %rbx,%rdi
  5b3852:	e8 29 40 f8 ff       	call   537880 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime5ErrorEBF_.llvm.18021777786862421399>
  5b3857:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  5b385c:	66 0f 14 84 24 c0 00 	unpcklpd 0xc0(%rsp),%xmm0
  5b3863:	00 00 
  5b3865:	0f 29 84 24 20 0c 00 	movaps %xmm0,0xc20(%rsp)
  5b386c:	00 
  5b386d:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  5b3874:	00 
  5b3875:	0f 13 84 24 30 0c 00 	movlps %xmm0,0xc30(%rsp)
  5b387c:	00 
  5b387d:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  5b3884:	00 
  5b3885:	0f 29 84 24 d0 04 00 	movaps %xmm0,0x4d0(%rsp)
  5b388c:	00 
  5b388d:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b3894:	00 
  5b3895:	48 8b b4 24 90 01 00 	mov    0x190(%rsp),%rsi
  5b389c:	00 
  5b389d:	48 89 ea             	mov    %rbp,%rdx
  5b38a0:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  5b38a7:	00 
  5b38a8:	f3 0f 10 8c 24 0c 02 	movss  0x20c(%rsp),%xmm1
  5b38af:	00 00 
  5b38b1:	48 8d 8c 24 20 0c 00 	lea    0xc20(%rsp),%rcx
  5b38b8:	00 
  5b38b9:	49 89 d8             	mov    %rbx,%r8
  5b38bc:	4c 8d 8c 24 e0 00 00 	lea    0xe0(%rsp),%r9
  5b38c3:	00 
  5b38c4:	f3 0f 10 54 24 24    	movss  0x24(%rsp),%xmm2
  5b38ca:	ff 15 a8 68 53 00    	call   *0x5368a8(%rip)        # aea178 <_DYNAMIC+0x418>
  5b38d0:	41 89 c4             	mov    %eax,%r12d
  5b38d3:	83 f8 ff             	cmp    $0xffffffff,%eax
  5b38d6:	0f 85 07 07 00 00    	jne    5b3fe3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x33b3>
  5b38dc:	45 8b 75 20          	mov    0x20(%r13),%r14d
  5b38e0:	eb 06                	jmp    5b38e8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2cb8>
  5b38e2:	0f 85 6a 13 00 00    	jne    5b4c52 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4022>
  5b38e8:	44 89 f0             	mov    %r14d,%eax
  5b38eb:	83 e0 07             	and    $0x7,%eax
  5b38ee:	83 f8 06             	cmp    $0x6,%eax
  5b38f1:	0f 83 62 01 00 00    	jae    5b3a59 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2e29>
  5b38f7:	45 8b 65 18          	mov    0x18(%r13),%r12d
  5b38fb:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  5b3901:	74 2b                	je     5b392e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2cfe>
  5b3903:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  5b3907:	74 1f                	je     5b3928 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2cf8>
  5b3909:	4c 8b bc 24 b8 00 00 	mov    0xb8(%rsp),%r15
  5b3910:	00 
  5b3911:	4d 39 e7             	cmp    %r12,%r15
  5b3914:	0f 86 36 15 00 00    	jbe    5b4e50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4220>
  5b391a:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5b3921:	00 
  5b3922:	46 8b 24 a0          	mov    (%rax,%r12,4),%r12d
  5b3926:	eb 06                	jmp    5b392e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2cfe>
  5b3928:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
  5b392e:	80 7c 24 30 00       	cmpb   $0x0,0x30(%rsp)
  5b3933:	74 2b                	je     5b3960 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2d30>
  5b3935:	f3 0f 10 84 24 20 03 	movss  0x320(%rsp),%xmm0
  5b393c:	00 00 
  5b393e:	0f 57 c9             	xorps  %xmm1,%xmm1
  5b3941:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5b3944:	75 06                	jne    5b394c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2d1c>
  5b3946:	0f 8b 9f 00 00 00    	jnp    5b39eb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2dbb>
  5b394c:	f3 0f 10 84 24 24 03 	movss  0x324(%rsp),%xmm0
  5b3953:	00 00 
  5b3955:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5b3958:	75 06                	jne    5b3960 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2d30>
  5b395a:	0f 8b 8b 00 00 00    	jnp    5b39eb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2dbb>
  5b3960:	41 8b 45 20          	mov    0x20(%r13),%eax
  5b3964:	83 e0 07             	and    $0x7,%eax
  5b3967:	83 f8 05             	cmp    $0x5,%eax
  5b396a:	0f 83 d5 00 00 00    	jae    5b3a45 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2e15>
  5b3970:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  5b3976:	74 4b                	je     5b39c3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2d93>
  5b3978:	48 8b 9c 24 c8 01 00 	mov    0x1c8(%rsp),%rbx
  5b397f:	00 
  5b3980:	48 81 fb 9f 86 01 00 	cmp    $0x1869f,%rbx
  5b3987:	0f 87 9a 12 00 00    	ja     5b4c27 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3ff7>
  5b398d:	4c 8b b4 24 b8 00 00 	mov    0xb8(%rsp),%r14
  5b3994:	00 
  5b3995:	4c 3b b4 24 a8 00 00 	cmp    0xa8(%rsp),%r14
  5b399c:	00 
  5b399d:	75 0d                	jne    5b39ac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2d7c>
  5b399f:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  5b39a6:	00 
  5b39a7:	e8 24 a2 21 00       	call   7cdbd0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6gaF1xUz9Bf_4gpui7runtime6ParentE8grow_oneBP_>
  5b39ac:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5b39b3:	00 
  5b39b4:	42 89 1c b0          	mov    %ebx,(%rax,%r14,4)
  5b39b8:	49 ff c6             	inc    %r14
  5b39bb:	4c 89 b4 24 b8 00 00 	mov    %r14,0xb8(%rsp)
  5b39c2:	00 
  5b39c3:	49 8b 5d 00          	mov    0x0(%r13),%rbx
  5b39c7:	41 8b 45 20          	mov    0x20(%r13),%eax
  5b39cb:	89 c1                	mov    %eax,%ecx
  5b39cd:	83 e1 07             	and    $0x7,%ecx
  5b39d0:	45 31 ff             	xor    %r15d,%r15d
  5b39d3:	48 8d 15 e2 ae ab ff 	lea    -0x54511e(%rip),%rdx        # 6e8bc <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x82c>
  5b39da:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
  5b39de:	48 01 d1             	add    %rdx,%rcx
  5b39e1:	ff e1                	jmp    *%rcx
  5b39e3:	45 31 f6             	xor    %r14d,%r14d
  5b39e6:	e9 d7 01 00 00       	jmp    5b3bc2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2f92>
  5b39eb:	80 bc 24 08 02 00 00 	cmpb   $0x0,0x208(%rsp)
  5b39f2:	00 
  5b39f3:	74 28                	je     5b3a1d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2ded>
  5b39f5:	f3 0f 10 84 24 a8 01 	movss  0x1a8(%rsp),%xmm0
  5b39fc:	00 00 
  5b39fe:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5b3a01:	75 02                	jne    5b3a05 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2dd5>
  5b3a03:	7b 18                	jnp    5b3a1d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2ded>
  5b3a05:	f3 0f 10 84 24 ac 01 	movss  0x1ac(%rsp),%xmm0
  5b3a0c:	00 00 
  5b3a0e:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5b3a11:	0f 85 49 ff ff ff    	jne    5b3960 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2d30>
  5b3a17:	0f 8a 43 ff ff ff    	jp     5b3960 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2d30>
  5b3a1d:	48 8b 9c 24 b8 00 00 	mov    0xb8(%rsp),%rbx
  5b3a24:	00 
  5b3a25:	48 3b 9c 24 a8 00 00 	cmp    0xa8(%rsp),%rbx
  5b3a2c:	00 
  5b3a2d:	0f 85 e9 f1 ff ff    	jne    5b2c1c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1fec>
  5b3a33:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  5b3a3a:	00 
  5b3a3b:	e8 90 a1 21 00       	call   7cdbd0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6gaF1xUz9Bf_4gpui7runtime6ParentE8grow_oneBP_>
  5b3a40:	e9 d7 f1 ff ff       	jmp    5b2c1c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x1fec>
  5b3a45:	0f 84 4a 01 00 00    	je     5b3b95 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2f65>
  5b3a4b:	83 f8 06             	cmp    $0x6,%eax
  5b3a4e:	0f 84 1c ff ff ff    	je     5b3970 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2d40>
  5b3a54:	e9 f9 11 00 00       	jmp    5b4c52 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4022>
  5b3a59:	0f 85 f3 11 00 00    	jne    5b4c52 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4022>
  5b3a5f:	41 c1 ee 03          	shr    $0x3,%r14d
  5b3a63:	41 8d 46 ff          	lea    -0x1(%r14),%eax
  5b3a67:	41 83 ee 01          	sub    $0x1,%r14d
  5b3a6b:	0f 82 86 fe ff ff    	jb     5b38f7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2cc7>
  5b3a71:	48 8b 8c 24 00 02 00 	mov    0x200(%rsp),%rcx
  5b3a78:	00 
  5b3a79:	48 8b 09             	mov    (%rcx),%rcx
  5b3a7c:	48 85 c9             	test   %rcx,%rcx
  5b3a7f:	0f 84 f7 12 00 00    	je     5b4d7c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x414c>
  5b3a85:	d1 e8                	shr    $1,%eax
  5b3a87:	4c 8b 79 10          	mov    0x10(%rcx),%r15
  5b3a8b:	41 89 c4             	mov    %eax,%r12d
  5b3a8e:	4d 39 e7             	cmp    %r12,%r15
  5b3a91:	0f 86 02 14 00 00    	jbe    5b4e99 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4269>
  5b3a97:	48 8b 41 08          	mov    0x8(%rcx),%rax
  5b3a9b:	0f 28 9c 24 e0 02 00 	movaps 0x2e0(%rsp),%xmm3
  5b3aa2:	00 
  5b3aa3:	0f 28 c3             	movaps %xmm3,%xmm0
  5b3aa6:	0f c6 c3 e8          	shufps $0xe8,%xmm3,%xmm0
  5b3aaa:	0f 28 a4 24 d0 0b 00 	movaps 0xbd0(%rsp),%xmm4
  5b3ab1:	00 
  5b3ab2:	0f 58 e0             	addps  %xmm0,%xmm4
  5b3ab5:	0f 28 ac 24 20 02 00 	movaps 0x220(%rsp),%xmm5
  5b3abc:	00 
  5b3abd:	0f 28 cd             	movaps %xmm5,%xmm1
  5b3ac0:	0f c6 cd e8          	shufps $0xe8,%xmm5,%xmm1
  5b3ac4:	0f 28 94 24 30 02 00 	movaps 0x230(%rsp),%xmm2
  5b3acb:	00 
  5b3acc:	0f 5c d1             	subps  %xmm1,%xmm2
  5b3acf:	0f 58 cc             	addps  %xmm4,%xmm1
  5b3ad2:	0f c6 ed ed          	shufps $0xed,%xmm5,%xmm5
  5b3ad6:	0f 5c d5             	subps  %xmm5,%xmm2
  5b3ad9:	0f 5c d0             	subps  %xmm0,%xmm2
  5b3adc:	0f c6 db ed          	shufps $0xed,%xmm3,%xmm3
  5b3ae0:	0f 5c d3             	subps  %xmm3,%xmm2
  5b3ae3:	0f 5c 94 24 d0 02 00 	subps  0x2d0(%rsp),%xmm2
  5b3aea:	00 
  5b3aeb:	0f 16 ca             	movlhps %xmm2,%xmm1
  5b3aee:	0f 11 8c 24 f0 00 00 	movups %xmm1,0xf0(%rsp)
  5b3af5:	00 
  5b3af6:	c7 84 24 d8 04 00 00 	movl   $0x1,0x4d8(%rsp)
  5b3afd:	01 00 00 00 
  5b3b01:	48 c7 84 24 d0 04 00 	movq   $0x22,0x4d0(%rsp)
  5b3b08:	00 22 00 00 00 
  5b3b0d:	80 7c 24 60 00       	cmpb   $0x0,0x60(%rsp)
  5b3b12:	0f 84 cd 0c 00 00    	je     5b47e5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3bb5>
  5b3b18:	41 80 f6 01          	xor    $0x1,%r14b
  5b3b1c:	4e 8d 3c e0          	lea    (%rax,%r12,8),%r15
  5b3b20:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b3b27:	00 
  5b3b28:	e8 53 3d f8 ff       	call   537880 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime5ErrorEBF_.llvm.18021777786862421399>
  5b3b2d:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  5b3b32:	66 0f 14 84 24 c0 00 	unpcklpd 0xc0(%rsp),%xmm0
  5b3b39:	00 00 
  5b3b3b:	0f 29 84 24 40 0c 00 	movaps %xmm0,0xc40(%rsp)
  5b3b42:	00 
  5b3b43:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  5b3b4a:	00 
  5b3b4b:	0f 13 84 24 50 0c 00 	movlps %xmm0,0xc50(%rsp)
  5b3b52:	00 
  5b3b53:	45 0f b6 ce          	movzbl %r14b,%r9d
  5b3b57:	41 83 e1 01          	and    $0x1,%r9d
  5b3b5b:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b3b62:	00 
  5b3b63:	4c 89 fe             	mov    %r15,%rsi
  5b3b66:	48 8d 94 24 f0 00 00 	lea    0xf0(%rsp),%rdx
  5b3b6d:	00 
  5b3b6e:	48 8d 8c 24 40 0c 00 	lea    0xc40(%rsp),%rcx
  5b3b75:	00 
  5b3b76:	4c 8d 84 24 d0 00 00 	lea    0xd0(%rsp),%r8
  5b3b7d:	00 
  5b3b7e:	ff 15 fc 65 53 00    	call   *0x5365fc(%rip)        # aea180 <_DYNAMIC+0x420>
  5b3b84:	41 89 c4             	mov    %eax,%r12d
  5b3b87:	83 f8 ff             	cmp    $0xffffffff,%eax
  5b3b8a:	0f 84 67 fd ff ff    	je     5b38f7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2cc7>
  5b3b90:	e9 4e 04 00 00       	jmp    5b3fe3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x33b3>
  5b3b95:	49 8b 75 00          	mov    0x0(%r13),%rsi
  5b3b99:	48 8d bc 24 a8 02 00 	lea    0x2a8(%rsp),%rdi
  5b3ba0:	00 
  5b3ba1:	e8 7a 51 17 00       	call   728d20 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5b3ba6:	e9 c5 fd ff ff       	jmp    5b3970 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2d40>
  5b3bab:	41 b6 04             	mov    $0x4,%r14b
  5b3bae:	eb 12                	jmp    5b3bc2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2f92>
  5b3bb0:	41 b6 02             	mov    $0x2,%r14b
  5b3bb3:	eb 0d                	jmp    5b3bc2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2f92>
  5b3bb5:	41 b6 03             	mov    $0x3,%r14b
  5b3bb8:	eb 08                	jmp    5b3bc2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2f92>
  5b3bba:	41 b6 01             	mov    $0x1,%r14b
  5b3bbd:	eb 03                	jmp    5b3bc2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2f92>
  5b3bbf:	41 b6 05             	mov    $0x5,%r14b
  5b3bc2:	c1 e8 03             	shr    $0x3,%eax
  5b3bc5:	74 65                	je     5b3c2c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2ffc>
  5b3bc7:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b3bcb:	4c 8b b9 e0 02 00 00 	mov    0x2e0(%rcx),%r15
  5b3bd2:	ff c8                	dec    %eax
  5b3bd4:	49 39 c7             	cmp    %rax,%r15
  5b3bd7:	0f 86 67 12 00 00    	jbe    5b4e44 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4214>
  5b3bdd:	48 8b 89 d8 02 00 00 	mov    0x2d8(%rcx),%rcx
  5b3be4:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  5b3be8:	48 c1 e0 04          	shl    $0x4,%rax
  5b3bec:	48 83 3c 01 fe       	cmpq   $0xfffffffffffffffe,(%rcx,%rax,1)
  5b3bf1:	0f 84 f0 10 00 00    	je     5b4ce7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x40b7>
  5b3bf7:	48 01 c1             	add    %rax,%rcx
  5b3bfa:	4c 8b 79 40          	mov    0x40(%rcx),%r15
  5b3bfe:	41 f6 07 01          	testb  $0x1,(%r15)
  5b3c02:	75 30                	jne    5b3c34 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3004>
  5b3c04:	49 8b 47 08          	mov    0x8(%r15),%rax
  5b3c08:	a8 01                	test   $0x1,%al
  5b3c0a:	75 28                	jne    5b3c34 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3004>
  5b3c0c:	b8 02 00 00 00       	mov    $0x2,%eax
  5b3c11:	f0 49 0f c1 47 08    	lock xadd %rax,0x8(%r15)
  5b3c17:	48 23 84 24 60 03 00 	and    0x360(%rsp),%rax
  5b3c1e:	00 
  5b3c1f:	48 f7 d8             	neg    %rax
  5b3c22:	71 10                	jno    5b3c34 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3004>
  5b3c24:	f0 49 83 4f 08 01    	lock orq $0x1,0x8(%r15)
  5b3c2a:	eb 08                	jmp    5b3c34 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3004>
  5b3c2c:	45 31 ff             	xor    %r15d,%r15d
  5b3c2f:	eb 03                	jmp    5b3c34 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3004>
  5b3c31:	41 b6 06             	mov    $0x6,%r14b
  5b3c34:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  5b3c39:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  5b3c3e:	80 7c 24 60 00       	cmpb   $0x0,0x60(%rsp)
  5b3c43:	75 78                	jne    5b3cbd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x308d>
  5b3c45:	f3 0f 10 05 df a3 ab 	movss  -0x545c21(%rip),%xmm0        # 6e02c <anon.3ba400ff3979798c885aff398562f819.15.llvm.6226793394568926217+0x2c>
  5b3c4c:	ff 
  5b3c4d:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  5b3c52:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  5b3c59:	00 
  5b3c5a:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  5b3c5f:	74 6b                	je     5b3ccc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x309c>
  5b3c61:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  5b3c68:	00 
  5b3c69:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  5b3c70:	00 
  5b3c71:	75 0b                	jne    5b3c7e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x304e>
  5b3c73:	0f 57 c0             	xorps  %xmm0,%xmm0
  5b3c76:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  5b3c7d:	00 
  5b3c7e:	41 8b 7d 20          	mov    0x20(%r13),%edi
  5b3c82:	89 f8                	mov    %edi,%eax
  5b3c84:	83 e0 07             	and    $0x7,%eax
  5b3c87:	83 f8 06             	cmp    $0x6,%eax
  5b3c8a:	73 61                	jae    5b3ced <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x30bd>
  5b3c8c:	0f 57 c0             	xorps  %xmm0,%xmm0
  5b3c8f:	f3 0f 10 8c 24 10 02 	movss  0x210(%rsp),%xmm1
  5b3c96:	00 00 
  5b3c98:	0f 2e c8             	ucomiss %xmm0,%xmm1
  5b3c9b:	b2 01                	mov    $0x1,%dl
  5b3c9d:	77 67                	ja     5b3d06 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x30d6>
  5b3c9f:	83 ff 07             	cmp    $0x7,%edi
  5b3ca2:	77 62                	ja     5b3d06 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x30d6>
  5b3ca4:	49 83 7d 08 00       	cmpq   $0x0,0x8(%r13)
  5b3ca9:	75 5b                	jne    5b3d06 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x30d6>
  5b3cab:	e8 10 51 f9 ff       	call   548dc0 <_RNvMsh_NtCs6gaF1xUz9Bf_4gpui7runtimeNtB5_4Node4kind>
  5b3cb0:	04 fe                	add    $0xfe,%al
  5b3cb2:	a8 fb                	test   $0xfb,%al
  5b3cb4:	0f 94 c2             	sete   %dl
  5b3cb7:	41 8b 7d 20          	mov    0x20(%r13),%edi
  5b3cbb:	eb 49                	jmp    5b3d06 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x30d6>
  5b3cbd:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  5b3cc4:	00 
  5b3cc5:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  5b3cca:	75 95                	jne    5b3c61 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3031>
  5b3ccc:	f2 0f 10 05 fc 98 ab 	movsd  -0x546704(%rip),%xmm0        # 6d5d0 <anon.1f6b7bab1fc61e0fcd36456038a862fb.99.llvm.12454362996328431623+0x2c0>
  5b3cd3:	ff 
  5b3cd4:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  5b3cd9:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  5b3ce0:	00 
  5b3ce1:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  5b3ce8:	00 
  5b3ce9:	74 88                	je     5b3c73 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3043>
  5b3ceb:	eb 91                	jmp    5b3c7e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x304e>
  5b3ced:	0f 85 28 10 00 00    	jne    5b4d1b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x40eb>
  5b3cf3:	b2 01                	mov    $0x1,%dl
  5b3cf5:	0f 57 c0             	xorps  %xmm0,%xmm0
  5b3cf8:	f3 0f 10 8c 24 10 02 	movss  0x210(%rsp),%xmm1
  5b3cff:	00 00 
  5b3d01:	0f 2e c8             	ucomiss %xmm0,%xmm1
  5b3d04:	76 9e                	jbe    5b3ca4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3074>
  5b3d06:	83 e7 07             	and    $0x7,%edi
  5b3d09:	48 8d 0d cc ab ab ff 	lea    -0x545434(%rip),%rcx        # 6e8dc <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x84c>
  5b3d10:	48 63 04 b9          	movslq (%rcx,%rdi,4),%rax
  5b3d14:	48 01 c8             	add    %rcx,%rax
  5b3d17:	4c 89 ac 24 40 02 00 	mov    %r13,0x240(%rsp)
  5b3d1e:	00 
  5b3d1f:	48 89 9c 24 e0 02 00 	mov    %rbx,0x2e0(%rsp)
  5b3d26:	00 
  5b3d27:	4c 89 b4 24 d0 02 00 	mov    %r14,0x2d0(%rsp)
  5b3d2e:	00 
  5b3d2f:	4c 89 bc 24 20 02 00 	mov    %r15,0x220(%rsp)
  5b3d36:	00 
  5b3d37:	88 94 24 10 02 00 00 	mov    %dl,0x210(%rsp)
  5b3d3e:	ff e0                	jmp    *%rax
  5b3d40:	41 b6 01             	mov    $0x1,%r14b
  5b3d43:	45 31 ed             	xor    %r13d,%r13d
  5b3d46:	31 c0                	xor    %eax,%eax
  5b3d48:	48 8b 8c 24 40 02 00 	mov    0x240(%rsp),%rcx
  5b3d4f:	00 
  5b3d50:	48 83 79 08 00       	cmpq   $0x0,0x8(%rcx)
  5b3d55:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  5b3d5b:	b9 06 00 00 00       	mov    $0x6,%ecx
  5b3d60:	44 0f 45 f9          	cmovne %ecx,%r15d
  5b3d64:	40 0f 95 c5          	setne  %bpl
  5b3d68:	84 c0                	test   %al,%al
  5b3d6a:	44 0f 45 f9          	cmovne %ecx,%r15d
  5b3d6e:	48 8b 9c 24 c8 01 00 	mov    0x1c8(%rsp),%rbx
  5b3d75:	00 
  5b3d76:	48 3b 9c 24 b8 01 00 	cmp    0x1b8(%rsp),%rbx
  5b3d7d:	00 
  5b3d7e:	75 0d                	jne    5b3d8d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x315d>
  5b3d80:	48 8d bc 24 b8 01 00 	lea    0x1b8(%rsp),%rdi
  5b3d87:	00 
  5b3d88:	e8 03 99 21 00       	call   7cd690 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime8TextSiteEE8grow_oneB1r_>
  5b3d8d:	44 20 f5             	and    %r14b,%bpl
  5b3d90:	41 08 ed             	or     %bpl,%r13b
  5b3d93:	45 08 fd             	or     %r15b,%r13b
  5b3d96:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
  5b3d9d:	00 
  5b3d9e:	48 8d 0c 9b          	lea    (%rbx,%rbx,4),%rcx
  5b3da2:	48 c1 e1 04          	shl    $0x4,%rcx
  5b3da6:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  5b3dab:	0f 11 04 08          	movups %xmm0,(%rax,%rcx,1)
  5b3daf:	0f 10 84 24 18 03 00 	movups 0x318(%rsp),%xmm0
  5b3db6:	00 
  5b3db7:	0f 11 44 08 10       	movups %xmm0,0x10(%rax,%rcx,1)
  5b3dbc:	48 8b 94 24 e0 02 00 	mov    0x2e0(%rsp),%rdx
  5b3dc3:	00 
  5b3dc4:	48 89 54 08 20       	mov    %rdx,0x20(%rax,%rcx,1)
  5b3dc9:	48 8b 94 24 20 02 00 	mov    0x220(%rsp),%rdx
  5b3dd0:	00 
  5b3dd1:	48 89 54 08 28       	mov    %rdx,0x28(%rax,%rcx,1)
  5b3dd6:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  5b3ddb:	66 0f 14 44 24 60    	unpcklpd 0x60(%rsp),%xmm0
  5b3de1:	0f 11 44 08 30       	movups %xmm0,0x30(%rax,%rcx,1)
  5b3de6:	66 0f 28 84 24 30 02 	movapd 0x230(%rsp),%xmm0
  5b3ded:	00 00 
  5b3def:	66 0f 13 44 08 40    	movlpd %xmm0,0x40(%rax,%rcx,1)
  5b3df5:	44 89 64 08 48       	mov    %r12d,0x48(%rax,%rcx,1)
  5b3dfa:	44 88 6c 08 4c       	mov    %r13b,0x4c(%rax,%rcx,1)
  5b3dff:	48 8b 94 24 d0 02 00 	mov    0x2d0(%rsp),%rdx
  5b3e06:	00 
  5b3e07:	88 54 08 4d          	mov    %dl,0x4d(%rax,%rcx,1)
  5b3e0b:	0f b6 94 24 10 02 00 	movzbl 0x210(%rsp),%edx
  5b3e12:	00 
  5b3e13:	88 54 08 4e          	mov    %dl,0x4e(%rax,%rcx,1)
  5b3e17:	48 ff c3             	inc    %rbx
  5b3e1a:	48 89 9c 24 c8 01 00 	mov    %rbx,0x1c8(%rsp)
  5b3e21:	00 
  5b3e22:	48 83 bc 24 98 03 00 	cmpq   $0xffffffffffffffff,0x398(%rsp)
  5b3e29:	00 ff 
  5b3e2b:	0f 84 02 ee ff ff    	je     5b2c33 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2003>
  5b3e31:	48 8b 04 24          	mov    (%rsp),%rax
  5b3e35:	4c 8b b8 10 08 00 00 	mov    0x810(%rax),%r15
  5b3e3c:	4d 85 ff             	test   %r15,%r15
  5b3e3f:	0f 84 ee ed ff ff    	je     5b2c33 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2003>
  5b3e45:	48 8b 9c 24 40 02 00 	mov    0x240(%rsp),%rbx
  5b3e4c:	00 
  5b3e4d:	4c 8b 23             	mov    (%rbx),%r12
  5b3e50:	4c 89 a4 24 e0 00 00 	mov    %r12,0xe0(%rsp)
  5b3e57:	00 
  5b3e58:	48 8d bc 24 48 04 00 	lea    0x448(%rsp),%rdi
  5b3e5f:	00 
  5b3e60:	48 8d b4 24 e0 00 00 	lea    0xe0(%rsp),%rsi
  5b3e67:	00 
  5b3e68:	e8 53 5e 16 00       	call   719cc0 <_RINvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB6_8BTreeMapjTNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdRNtB1b_8RowDraftEE3getjEB1d_>
  5b3e6d:	48 85 c0             	test   %rax,%rax
  5b3e70:	74 1c                	je     5b3e8e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x325e>
  5b3e72:	48 8b 08             	mov    (%rax),%rcx
  5b3e75:	8b 40 08             	mov    0x8(%rax),%eax
  5b3e78:	48 89 8c 24 d8 04 00 	mov    %rcx,0x4d8(%rsp)
  5b3e7f:	00 
  5b3e80:	89 84 24 e0 04 00 00 	mov    %eax,0x4e0(%rsp)
  5b3e87:	b8 01 00 00 00       	mov    $0x1,%eax
  5b3e8c:	eb 02                	jmp    5b3e90 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3260>
  5b3e8e:	31 c0                	xor    %eax,%eax
  5b3e90:	48 89 84 24 d0 04 00 	mov    %rax,0x4d0(%rsp)
  5b3e97:	00 
  5b3e98:	48 8b 03             	mov    (%rbx),%rax
  5b3e9b:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
  5b3ea2:	00 
  5b3ea3:	48 8b bc 24 68 03 00 	mov    0x368(%rsp),%rdi
  5b3eaa:	00 
  5b3eab:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  5b3eb2:	00 
  5b3eb3:	e8 98 5e 16 00       	call   719d50 <_RINvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB6_8BTreeMapyAINtNtCs6gaF1xUz9Bf_4gpui8property12ContributionINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtB1e_11shared_text10SharedTextEEj2_E3getyEB1e_>
  5b3eb8:	48 8d bc 24 98 03 00 	lea    0x398(%rsp),%rdi
  5b3ebf:	00 
  5b3ec0:	4c 89 fe             	mov    %r15,%rsi
  5b3ec3:	4c 89 e2             	mov    %r12,%rdx
  5b3ec6:	48 8d 8c 24 d0 04 00 	lea    0x4d0(%rsp),%rcx
  5b3ecd:	00 
  5b3ece:	49 89 c0             	mov    %rax,%r8
  5b3ed1:	e8 ba 42 1a 00       	call   758190 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataNtB4_5Sheet7capture>
  5b3ed6:	e9 58 ed ff ff       	jmp    5b2c33 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x2003>
  5b3edb:	b0 01                	mov    $0x1,%al
  5b3edd:	41 b5 08             	mov    $0x8,%r13b
  5b3ee0:	45 31 f6             	xor    %r14d,%r14d
  5b3ee3:	e9 60 fe ff ff       	jmp    5b3d48 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3118>
  5b3ee8:	41 b6 01             	mov    $0x1,%r14b
  5b3eeb:	45 31 ed             	xor    %r13d,%r13d
  5b3eee:	b0 01                	mov    $0x1,%al
  5b3ef0:	e9 53 fe ff ff       	jmp    5b3d48 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3118>
  5b3ef5:	83 f8 04             	cmp    $0x4,%eax
  5b3ef8:	0f 84 1c f5 ff ff    	je     5b341a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x27ea>
  5b3efe:	e9 4f 0d 00 00       	jmp    5b4c52 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4022>
  5b3f03:	48 83 bc 24 98 03 00 	cmpq   $0xffffffffffffffff,0x398(%rsp)
  5b3f0a:	00 ff 
  5b3f0c:	74 0d                	je     5b3f1b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x32eb>
  5b3f0e:	48 8d bc 24 98 03 00 	lea    0x398(%rsp),%rdi
  5b3f15:	00 
  5b3f16:	e8 45 41 1a 00       	call   758060 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataNtB4_5Sheet4sort>
  5b3f1b:	48 8b 04 24          	mov    (%rsp),%rax
  5b3f1f:	80 b8 5d 09 00 00 00 	cmpb   $0x0,0x95d(%rax)
  5b3f26:	4c 8b b4 24 98 01 00 	mov    0x198(%rsp),%r14
  5b3f2d:	00 
  5b3f2e:	4c 8d a4 24 d0 04 00 	lea    0x4d0(%rsp),%r12
  5b3f35:	00 
  5b3f36:	48 8d b4 24 a0 09 00 	lea    0x9a0(%rsp),%rsi
  5b3f3d:	00 
  5b3f3e:	ba 30 02 00 00       	mov    $0x230,%edx
  5b3f43:	4c 89 e7             	mov    %r12,%rdi
  5b3f46:	74 63                	je     5b3fab <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x337b>
  5b3f48:	ff 15 b2 60 53 00    	call   *0x5360b2(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5b3f4e:	41 b5 01             	mov    $0x1,%r13b
  5b3f51:	b0 01                	mov    $0x1,%al
  5b3f53:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b3f57:	40 b5 01             	mov    $0x1,%bpl
  5b3f5a:	b0 01                	mov    $0x1,%al
  5b3f5c:	89 44 24 08          	mov    %eax,0x8(%rsp)
  5b3f60:	4c 89 e7             	mov    %r12,%rdi
  5b3f63:	ff 15 1f 62 53 00    	call   *0x53621f(%rip)        # aea188 <_DYNAMIC+0x428>
  5b3f69:	45 31 e4             	xor    %r12d,%r12d
  5b3f6c:	e9 9d 00 00 00       	jmp    5b400e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x33de>
  5b3f71:	8b 84 24 a0 09 00 00 	mov    0x9a0(%rsp),%eax
  5b3f78:	8b 8c 24 a3 09 00 00 	mov    0x9a3(%rsp),%ecx
  5b3f7f:	89 4c 24 5b          	mov    %ecx,0x5b(%rsp)
  5b3f83:	89 44 24 58          	mov    %eax,0x58(%rsp)
  5b3f87:	45 89 e5             	mov    %r12d,%r13d
  5b3f8a:	41 c1 ed 08          	shr    $0x8,%r13d
  5b3f8e:	b0 01                	mov    $0x1,%al
  5b3f90:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b3f94:	48 83 bc 24 98 03 00 	cmpq   $0xffffffffffffffff,0x398(%rsp)
  5b3f9b:	00 ff 
  5b3f9d:	41 b6 01             	mov    $0x1,%r14b
  5b3fa0:	0f 85 dd 08 00 00    	jne    5b4883 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3c53>
  5b3fa6:	e9 e5 08 00 00       	jmp    5b4890 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3c60>
  5b3fab:	ff 15 4f 60 53 00    	call   *0x53604f(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5b3fb1:	41 b5 01             	mov    $0x1,%r13b
  5b3fb4:	b0 01                	mov    $0x1,%al
  5b3fb6:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b3fba:	40 b5 01             	mov    $0x1,%bpl
  5b3fbd:	b0 01                	mov    $0x1,%al
  5b3fbf:	89 44 24 08          	mov    %eax,0x8(%rsp)
  5b3fc3:	4c 89 e7             	mov    %r12,%rdi
  5b3fc6:	ff 15 c4 61 53 00    	call   *0x5361c4(%rip)        # aea190 <_DYNAMIC+0x430>
  5b3fcc:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b3fd0:	48 83 b9 60 07 00 00 	cmpq   $0xffffffffffffffff,0x760(%rcx)
  5b3fd7:	ff 
  5b3fd8:	74 17                	je     5b3ff1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x33c1>
  5b3fda:	48 8b b1 78 07 00 00 	mov    0x778(%rcx),%rsi
  5b3fe1:	eb 10                	jmp    5b3ff3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x33c3>
  5b3fe3:	89 d5                	mov    %edx,%ebp
  5b3fe5:	45 89 e5             	mov    %r12d,%r13d
  5b3fe8:	41 c1 ed 08          	shr    $0x8,%r13d
  5b3fec:	e9 26 08 00 00       	jmp    5b4817 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3be7>
  5b3ff1:	31 f6                	xor    %esi,%esi
  5b3ff3:	b1 01                	mov    $0x1,%cl
  5b3ff5:	89 4c 24 40          	mov    %ecx,0x40(%rsp)
  5b3ff9:	40 b5 01             	mov    $0x1,%bpl
  5b3ffc:	b1 01                	mov    $0x1,%cl
  5b3ffe:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  5b4002:	48 89 c7             	mov    %rax,%rdi
  5b4005:	ff 15 c5 60 53 00    	call   *0x5360c5(%rip)        # aea0d0 <_DYNAMIC+0x370>
  5b400b:	49 89 c4             	mov    %rax,%r12
  5b400e:	48 8b 04 24          	mov    (%rsp),%rax
  5b4012:	4c 8b 88 30 08 00 00 	mov    0x830(%rax),%r9
  5b4019:	48 8b 80 40 08 00 00 	mov    0x840(%rax),%rax
  5b4020:	4d 85 c9             	test   %r9,%r9
  5b4023:	0f 95 c1             	setne  %cl
  5b4026:	48 85 c0             	test   %rax,%rax
  5b4029:	0f 95 c2             	setne  %dl
  5b402c:	20 ca                	and    %cl,%dl
  5b402e:	80 fa 01             	cmp    $0x1,%dl
  5b4031:	0f 85 76 02 00 00    	jne    5b42ad <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x367d>
  5b4037:	31 c9                	xor    %ecx,%ecx
  5b4039:	4d 85 c9             	test   %r9,%r9
  5b403c:	0f 95 c1             	setne  %cl
  5b403f:	48 8b 14 24          	mov    (%rsp),%rdx
  5b4043:	48 8b b2 38 08 00 00 	mov    0x838(%rdx),%rsi
  5b404a:	31 d2                	xor    %edx,%edx
  5b404c:	eb 30                	jmp    5b407e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x344e>
  5b404e:	41 b1 01             	mov    $0x1,%r9b
  5b4051:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  5b4058:	00 
  5b4059:	4c 8b b4 24 98 01 00 	mov    0x198(%rsp),%r14
  5b4060:	00 
  5b4061:	48 ff c8             	dec    %rax
  5b4064:	49 c1 e0 05          	shl    $0x5,%r8
  5b4068:	4c 01 c7             	add    %r8,%rdi
  5b406b:	44 88 4f 1c          	mov    %r9b,0x1c(%rdi)
  5b406f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  5b4075:	48 85 c0             	test   %rax,%rax
  5b4078:	0f 84 2f 02 00 00    	je     5b42ad <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x367d>
  5b407e:	48 85 d2             	test   %rdx,%rdx
  5b4081:	75 44                	jne    5b40c7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3497>
  5b4083:	f6 c1 01             	test   $0x1,%cl
  5b4086:	74 3f                	je     5b40c7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3497>
  5b4088:	b9 01 00 00 00       	mov    $0x1,%ecx
  5b408d:	48 85 f6             	test   %rsi,%rsi
  5b4090:	74 55                	je     5b40e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x34b7>
  5b4092:	48 89 f7             	mov    %rsi,%rdi
  5b4095:	4c 89 ca             	mov    %r9,%rdx
  5b4098:	48 83 e7 07          	and    $0x7,%rdi
  5b409c:	74 4e                	je     5b40ec <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x34bc>
  5b409e:	45 31 c0             	xor    %r8d,%r8d
  5b40a1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b40a8:	0f 1f 84 00 00 00 00 
  5b40af:	00 
  5b40b0:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b40b7:	49 ff c0             	inc    %r8
  5b40ba:	4c 39 c7             	cmp    %r8,%rdi
  5b40bd:	75 f1                	jne    5b40b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3480>
  5b40bf:	48 89 f7             	mov    %rsi,%rdi
  5b40c2:	4c 29 c7             	sub    %r8,%rdi
  5b40c5:	eb 28                	jmp    5b40ef <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x34bf>
  5b40c7:	f6 c1 01             	test   $0x1,%cl
  5b40ca:	0f 84 f3 0a 00 00    	je     5b4bc3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3f93>
  5b40d0:	0f b7 ba c2 01 00 00 	movzwl 0x1c2(%rdx),%edi
  5b40d7:	48 39 fe             	cmp    %rdi,%rsi
  5b40da:	73 74                	jae    5b4150 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3520>
  5b40dc:	48 89 d7             	mov    %rdx,%rdi
  5b40df:	49 89 f0             	mov    %rsi,%r8
  5b40e2:	e9 91 00 00 00       	jmp    5b4178 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3548>
  5b40e7:	4c 89 ca             	mov    %r9,%rdx
  5b40ea:	eb 52                	jmp    5b413e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x350e>
  5b40ec:	48 89 f7             	mov    %rsi,%rdi
  5b40ef:	48 83 fe 08          	cmp    $0x8,%rsi
  5b40f3:	72 49                	jb     5b413e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x350e>
  5b40f5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5b40fc:	00 00 00 00 
  5b4100:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b4107:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b410e:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b4115:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b411c:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b4123:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b412a:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b4131:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b4138:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  5b413c:	75 c2                	jne    5b4100 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x34d0>
  5b413e:	31 f6                	xor    %esi,%esi
  5b4140:	45 31 c9             	xor    %r9d,%r9d
  5b4143:	0f b7 ba c2 01 00 00 	movzwl 0x1c2(%rdx),%edi
  5b414a:	48 39 fe             	cmp    %rdi,%rsi
  5b414d:	72 8d                	jb     5b40dc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x34ac>
  5b414f:	90                   	nop
  5b4150:	48 8b ba 60 01 00 00 	mov    0x160(%rdx),%rdi
  5b4157:	48 85 ff             	test   %rdi,%rdi
  5b415a:	0f 84 28 0c 00 00    	je     5b4d88 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4158>
  5b4160:	49 ff c1             	inc    %r9
  5b4163:	44 0f b7 82 c0 01 00 	movzwl 0x1c0(%rdx),%r8d
  5b416a:	00 
  5b416b:	48 89 fa             	mov    %rdi,%rdx
  5b416e:	66 44 3b 87 c2 01 00 	cmp    0x1c2(%rdi),%r8w
  5b4175:	00 
  5b4176:	73 d8                	jae    5b4150 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3520>
  5b4178:	4d 85 c9             	test   %r9,%r9
  5b417b:	74 3d                	je     5b41ba <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x358a>
  5b417d:	4a 8d 34 c7          	lea    (%rdi,%r8,8),%rsi
  5b4181:	48 81 c6 d0 01 00 00 	add    $0x1d0,%rsi
  5b4188:	4d 89 ca             	mov    %r9,%r10
  5b418b:	49 83 e2 07          	and    $0x7,%r10
  5b418f:	74 32                	je     5b41c3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3593>
  5b4191:	45 31 db             	xor    %r11d,%r11d
  5b4194:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b419b:	00 00 00 00 00 
  5b41a0:	48 8b 16             	mov    (%rsi),%rdx
  5b41a3:	48 8d b2 c8 01 00 00 	lea    0x1c8(%rdx),%rsi
  5b41aa:	49 ff c3             	inc    %r11
  5b41ad:	4d 39 da             	cmp    %r11,%r10
  5b41b0:	75 ee                	jne    5b41a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3570>
  5b41b2:	4d 89 ca             	mov    %r9,%r10
  5b41b5:	4d 29 da             	sub    %r11,%r10
  5b41b8:	eb 0c                	jmp    5b41c6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3596>
  5b41ba:	49 8d 70 01          	lea    0x1(%r8),%rsi
  5b41be:	48 89 fa             	mov    %rdi,%rdx
  5b41c1:	eb 50                	jmp    5b4213 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x35e3>
  5b41c3:	4d 89 ca             	mov    %r9,%r10
  5b41c6:	49 83 f9 08          	cmp    $0x8,%r9
  5b41ca:	72 45                	jb     5b4211 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x35e1>
  5b41cc:	0f 1f 40 00          	nopl   0x0(%rax)
  5b41d0:	48 8b 16             	mov    (%rsi),%rdx
  5b41d3:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b41da:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b41e1:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b41e8:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b41ef:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b41f6:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b41fd:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b4204:	48 8d b2 c8 01 00 00 	lea    0x1c8(%rdx),%rsi
  5b420b:	49 83 c2 f8          	add    $0xfffffffffffffff8,%r10
  5b420f:	75 bf                	jne    5b41d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x35a0>
  5b4211:	31 f6                	xor    %esi,%esi
  5b4213:	4c 8b 8c 24 a8 02 00 	mov    0x2a8(%rsp),%r9
  5b421a:	00 
  5b421b:	4d 85 c9             	test   %r9,%r9
  5b421e:	74 75                	je     5b4295 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3665>
  5b4220:	4e 8b 94 c7 68 01 00 	mov    0x168(%rdi,%r8,8),%r10
  5b4227:	00 
  5b4228:	4c 8b 9c 24 b0 02 00 	mov    0x2b0(%rsp),%r11
  5b422f:	00 
  5b4230:	45 0f b7 71 62       	movzwl 0x62(%r9),%r14d
  5b4235:	45 89 f7             	mov    %r14d,%r15d
  5b4238:	41 c1 e7 03          	shl    $0x3,%r15d
  5b423c:	48 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%rbx
  5b4243:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b424a:	84 00 00 00 00 00 
  5b4250:	4d 85 ff             	test   %r15,%r15
  5b4253:	74 28                	je     5b427d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x364d>
  5b4255:	4d 3b 54 d9 10       	cmp    0x10(%r9,%rbx,8),%r10
  5b425a:	40 0f 97 c5          	seta   %bpl
  5b425e:	40 80 dd 00          	sbb    $0x0,%bpl
  5b4262:	48 ff c3             	inc    %rbx
  5b4265:	49 83 c7 f8          	add    $0xfffffffffffffff8,%r15
  5b4269:	40 80 fd 01          	cmp    $0x1,%bpl
  5b426d:	74 e1                	je     5b4250 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3620>
  5b426f:	40 0f b6 ed          	movzbl %bpl,%ebp
  5b4273:	85 ed                	test   %ebp,%ebp
  5b4275:	0f 84 d3 fd ff ff    	je     5b404e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x341e>
  5b427b:	eb 03                	jmp    5b4280 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3650>
  5b427d:	4c 89 f3             	mov    %r14,%rbx
  5b4280:	4c 8b b4 24 98 01 00 	mov    0x198(%rsp),%r14
  5b4287:	00 
  5b4288:	49 83 eb 01          	sub    $0x1,%r11
  5b428c:	72 0f                	jb     5b429d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x366d>
  5b428e:	4d 8b 4c d9 68       	mov    0x68(%r9,%rbx,8),%r9
  5b4293:	eb 9b                	jmp    5b4230 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3600>
  5b4295:	45 31 c9             	xor    %r9d,%r9d
  5b4298:	e9 c4 fd ff ff       	jmp    5b4061 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3431>
  5b429d:	45 31 c9             	xor    %r9d,%r9d
  5b42a0:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  5b42a7:	00 
  5b42a8:	e9 b4 fd ff ff       	jmp    5b4061 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3431>
  5b42ad:	b0 01                	mov    $0x1,%al
  5b42af:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b42b3:	83 bc 24 58 0c 00 00 	cmpl   $0x2,0xc58(%rsp)
  5b42ba:	02 
  5b42bb:	b0 01                	mov    $0x1,%al
  5b42bd:	89 44 24 08          	mov    %eax,0x8(%rsp)
  5b42c1:	74 4d                	je     5b4310 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x36e0>
  5b42c3:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b42ca:	00 
  5b42cb:	48 8d b4 24 58 0c 00 	lea    0xc58(%rsp),%rsi
  5b42d2:	00 
  5b42d3:	ba 28 02 00 00       	mov    $0x228,%edx
  5b42d8:	ff 15 22 5d 53 00    	call   *0x535d22(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5b42de:	48 8b 1c 24          	mov    (%rsp),%rbx
  5b42e2:	48 89 df             	mov    %rbx,%rdi
  5b42e5:	e8 16 38 f8 ff       	call   537b00 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs7XZEQI6Z5Ts_11gpui_canvas6canvas6CanvasECs6gaF1xUz9Bf_4gpui>
  5b42ea:	48 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%rsi
  5b42f1:	00 
  5b42f2:	ba 28 02 00 00       	mov    $0x228,%edx
  5b42f7:	48 89 df             	mov    %rbx,%rdi
  5b42fa:	ff 15 00 5d 53 00    	call   *0x535d00(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5b4300:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%rsp)
  5b4307:	00 
  5b4308:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  5b430f:	00 
  5b4310:	48 83 bc 24 98 03 00 	cmpq   $0xffffffffffffffff,0x398(%rsp)
  5b4317:	00 ff 
  5b4319:	0f 84 83 01 00 00    	je     5b44a2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3872>
  5b431f:	0f 10 84 24 e8 03 00 	movups 0x3e8(%rsp),%xmm0
  5b4326:	00 
  5b4327:	0f 29 84 24 c0 04 00 	movaps %xmm0,0x4c0(%rsp)
  5b432e:	00 
  5b432f:	0f 10 84 24 d8 03 00 	movups 0x3d8(%rsp),%xmm0
  5b4336:	00 
  5b4337:	0f 29 84 24 b0 04 00 	movaps %xmm0,0x4b0(%rsp)
  5b433e:	00 
  5b433f:	66 0f 10 84 24 98 03 	movupd 0x398(%rsp),%xmm0
  5b4346:	00 00 
  5b4348:	0f 10 8c 24 a8 03 00 	movups 0x3a8(%rsp),%xmm1
  5b434f:	00 
  5b4350:	0f 10 94 24 b8 03 00 	movups 0x3b8(%rsp),%xmm2
  5b4357:	00 
  5b4358:	0f 10 9c 24 c8 03 00 	movups 0x3c8(%rsp),%xmm3
  5b435f:	00 
  5b4360:	0f 29 9c 24 a0 04 00 	movaps %xmm3,0x4a0(%rsp)
  5b4367:	00 
  5b4368:	0f 29 94 24 90 04 00 	movaps %xmm2,0x490(%rsp)
  5b436f:	00 
  5b4370:	0f 29 8c 24 80 04 00 	movaps %xmm1,0x480(%rsp)
  5b4377:	00 
  5b4378:	66 0f 29 84 24 70 04 	movapd %xmm0,0x470(%rsp)
  5b437f:	00 00 
  5b4381:	48 8b 04 24          	mov    (%rsp),%rax
  5b4385:	48 8b b8 10 08 00 00 	mov    0x810(%rax),%rdi
  5b438c:	48 85 ff             	test   %rdi,%rdi
  5b438f:	0f 84 ea 00 00 00    	je     5b447f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x384f>
  5b4395:	0f 10 84 24 e8 03 00 	movups 0x3e8(%rsp),%xmm0
  5b439c:	00 
  5b439d:	0f 29 84 24 20 05 00 	movaps %xmm0,0x520(%rsp)
  5b43a4:	00 
  5b43a5:	0f 10 84 24 d8 03 00 	movups 0x3d8(%rsp),%xmm0
  5b43ac:	00 
  5b43ad:	0f 29 84 24 10 05 00 	movaps %xmm0,0x510(%rsp)
  5b43b4:	00 
  5b43b5:	0f 10 84 24 98 03 00 	movups 0x398(%rsp),%xmm0
  5b43bc:	00 
  5b43bd:	0f 10 8c 24 a8 03 00 	movups 0x3a8(%rsp),%xmm1
  5b43c4:	00 
  5b43c5:	0f 10 94 24 b8 03 00 	movups 0x3b8(%rsp),%xmm2
  5b43cc:	00 
  5b43cd:	0f 10 9c 24 c8 03 00 	movups 0x3c8(%rsp),%xmm3
  5b43d4:	00 
  5b43d5:	0f 29 9c 24 00 05 00 	movaps %xmm3,0x500(%rsp)
  5b43dc:	00 
  5b43dd:	0f 29 94 24 f0 04 00 	movaps %xmm2,0x4f0(%rsp)
  5b43e4:	00 
  5b43e5:	0f 29 8c 24 e0 04 00 	movaps %xmm1,0x4e0(%rsp)
  5b43ec:	00 
  5b43ed:	0f 29 84 24 d0 04 00 	movaps %xmm0,0x4d0(%rsp)
  5b43f4:	00 
  5b43f5:	48 83 7f 78 ff       	cmpq   $0xffffffffffffffff,0x78(%rdi)
  5b43fa:	74 14                	je     5b4410 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x37e0>
  5b43fc:	48 83 c7 78          	add    $0x78,%rdi
  5b4400:	e8 7b 46 f8 ff       	call   538a80 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5SheetEBH_>
  5b4405:	48 8b 04 24          	mov    (%rsp),%rax
  5b4409:	48 8b b8 10 08 00 00 	mov    0x810(%rax),%rdi
  5b4410:	0f 28 84 24 20 05 00 	movaps 0x520(%rsp),%xmm0
  5b4417:	00 
  5b4418:	0f 11 87 c8 00 00 00 	movups %xmm0,0xc8(%rdi)
  5b441f:	0f 28 84 24 10 05 00 	movaps 0x510(%rsp),%xmm0
  5b4426:	00 
  5b4427:	0f 11 87 b8 00 00 00 	movups %xmm0,0xb8(%rdi)
  5b442e:	66 0f 28 84 24 d0 04 	movapd 0x4d0(%rsp),%xmm0
  5b4435:	00 00 
  5b4437:	0f 28 8c 24 e0 04 00 	movaps 0x4e0(%rsp),%xmm1
  5b443e:	00 
  5b443f:	0f 28 94 24 f0 04 00 	movaps 0x4f0(%rsp),%xmm2
  5b4446:	00 
  5b4447:	0f 28 9c 24 00 05 00 	movaps 0x500(%rsp),%xmm3
  5b444e:	00 
  5b444f:	0f 11 9f a8 00 00 00 	movups %xmm3,0xa8(%rdi)
  5b4456:	0f 11 97 98 00 00 00 	movups %xmm2,0x98(%rdi)
  5b445d:	0f 11 8f 88 00 00 00 	movups %xmm1,0x88(%rdi)
  5b4464:	66 0f 11 47 78       	movupd %xmm0,0x78(%rdi)
  5b4469:	eb 2f                	jmp    5b449a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x386a>
  5b446b:	44 0f b6 a4 24 d1 04 	movzbl 0x4d1(%rsp),%r12d
  5b4472:	00 00 
  5b4474:	41 bf 21 00 00 00    	mov    $0x21,%r15d
  5b447a:	e9 80 03 00 00       	jmp    5b47ff <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3bcf>
  5b447f:	41 b5 01             	mov    $0x1,%r13b
  5b4482:	c7 44 24 40 00 00 00 	movl   $0x0,0x40(%rsp)
  5b4489:	00 
  5b448a:	48 8d bc 24 70 04 00 	lea    0x470(%rsp),%rdi
  5b4491:	00 
  5b4492:	40 b5 01             	mov    $0x1,%bpl
  5b4495:	e8 e6 45 f8 ff       	call   538a80 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5SheetEBH_>
  5b449a:	c7 44 24 40 00 00 00 	movl   $0x0,0x40(%rsp)
  5b44a1:	00 
  5b44a2:	48 83 bc 24 f0 01 00 	cmpq   $0xffffffffffffffff,0x1f0(%rsp)
  5b44a9:	00 ff 
  5b44ab:	74 29                	je     5b44d6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x38a6>
  5b44ad:	48 8b 84 24 00 02 00 	mov    0x200(%rsp),%rax
  5b44b4:	00 
  5b44b5:	48 8b 38             	mov    (%rax),%rdi
  5b44b8:	48 85 ff             	test   %rdi,%rdi
  5b44bb:	0f 84 a9 08 00 00    	je     5b4d6a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x413a>
  5b44c1:	48 8d 94 24 f8 03 00 	lea    0x3f8(%rsp),%rdx
  5b44c8:	00 
  5b44c9:	48 89 de             	mov    %rbx,%rsi
  5b44cc:	e8 bf 3b 1c 00       	call   778090 <_RNvMNtNtCs6gaF1xUz9Bf_4gpui7runtime5imageNtB2_6Images7prepare>
  5b44d1:	45 31 ed             	xor    %r13d,%r13d
  5b44d4:	eb 03                	jmp    5b44d9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x38a9>
  5b44d6:	41 b5 01             	mov    $0x1,%r13b
  5b44d9:	48 8b 84 24 c8 01 00 	mov    0x1c8(%rsp),%rax
  5b44e0:	00 
  5b44e1:	48 89 84 24 e0 04 00 	mov    %rax,0x4e0(%rsp)
  5b44e8:	00 
  5b44e9:	0f 10 84 24 b8 01 00 	movups 0x1b8(%rsp),%xmm0
  5b44f0:	00 
  5b44f1:	0f 29 84 24 d0 04 00 	movaps %xmm0,0x4d0(%rsp)
  5b44f8:	00 
  5b44f9:	48 8b 1c 24          	mov    (%rsp),%rbx
  5b44fd:	48 8d ab 60 07 00 00 	lea    0x760(%rbx),%rbp
  5b4504:	48 89 ef             	mov    %rbp,%rdi
  5b4507:	e8 84 52 f7 ff       	call   529790 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime8PreparedEEB11_>
  5b450c:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b4513:	00 
  5b4514:	48 89 45 10          	mov    %rax,0x10(%rbp)
  5b4518:	0f 28 84 24 d0 04 00 	movaps 0x4d0(%rsp),%xmm0
  5b451f:	00 
  5b4520:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
  5b4524:	4c 89 a3 78 07 00 00 	mov    %r12,0x778(%rbx)
  5b452b:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  5b4532:	00 
  5b4533:	66 89 83 80 07 00 00 	mov    %ax,0x780(%rbx)
  5b453a:	8b 44 24 54          	mov    0x54(%rsp),%eax
  5b453e:	66 89 83 82 07 00 00 	mov    %ax,0x782(%rbx)
  5b4545:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  5b454b:	f3 0f 11 83 84 07 00 	movss  %xmm0,0x784(%rbx)
  5b4552:	00 
  5b4553:	4c 89 b3 80 08 00 00 	mov    %r14,0x880(%rbx)
  5b455a:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5b4561:	00 
  5b4562:	48 89 83 88 08 00 00 	mov    %rax,0x888(%rbx)
  5b4569:	48 8b 83 60 08 00 00 	mov    0x860(%rbx),%rax
  5b4570:	48 89 83 90 08 00 00 	mov    %rax,0x890(%rbx)
  5b4577:	48 8b 84 24 90 03 00 	mov    0x390(%rsp),%rax
  5b457e:	00 
  5b457f:	48 89 83 90 07 00 00 	mov    %rax,0x790(%rbx)
  5b4586:	48 83 bb e0 02 00 00 	cmpq   $0x0,0x2e0(%rbx)
  5b458d:	00 
  5b458e:	48 8b bc 24 90 01 00 	mov    0x190(%rsp),%rdi
  5b4595:	00 
  5b4596:	75 13                	jne    5b45ab <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x397b>
  5b4598:	48 89 fb             	mov    %rdi,%rbx
  5b459b:	e8 80 56 f7 ff       	call   529c20 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs7XZEQI6Z5Ts_11gpui_canvas4text10TextSystemEECs6gaF1xUz9Bf_4gpui>
  5b45a0:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
  5b45a7:	48 8b 1c 24          	mov    (%rsp),%rbx
  5b45ab:	c6 83 5b 09 00 00 00 	movb   $0x0,0x95b(%rbx)
  5b45b2:	66 c7 83 58 09 00 00 	movw   $0x0,0x958(%rbx)
  5b45b9:	00 00 
  5b45bb:	48 8d bb 48 08 00 00 	lea    0x848(%rbx),%rdi
  5b45c2:	31 ed                	xor    %ebp,%ebp
  5b45c4:	e8 a7 44 17 00       	call   728a70 <_RNvMsh_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE5clearCs6gaF1xUz9Bf_4gpui>
  5b45c9:	48 8b 8c 24 88 00 00 	mov    0x88(%rsp),%rcx
  5b45d0:	00 
  5b45d1:	48 8b 04 24          	mov    (%rsp),%rax
  5b45d5:	80 b8 5d 09 00 00 00 	cmpb   $0x0,0x95d(%rax)
  5b45dc:	44 89 ac 24 c0 00 00 	mov    %r13d,0xc0(%rsp)
  5b45e3:	00 
  5b45e4:	74 28                	je     5b460e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x39de>
  5b45e6:	31 ed                	xor    %ebp,%ebp
  5b45e8:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b45ef:	00 
  5b45f0:	48 8b 34 24          	mov    (%rsp),%rsi
  5b45f4:	4c 89 f2             	mov    %r14,%rdx
  5b45f7:	e8 44 56 ff ff       	call   5a9c40 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE11acknowledgeB7_.llvm.18021777786862421399>
  5b45fc:	4c 8b bc 24 d0 04 00 	mov    0x4d0(%rsp),%r15
  5b4603:	00 
  5b4604:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  5b4608:	0f 85 78 01 00 00    	jne    5b4786 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3b56>
  5b460e:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5b4615:	00 
  5b4616:	48 8d bc 24 48 04 00 	lea    0x448(%rsp),%rdi
  5b461d:	00 
  5b461e:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b4623:	e8 e8 95 17 00       	call   72dc10 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5b4628:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5b462f:	00 
  5b4630:	48 8d bc 24 a8 02 00 	lea    0x2a8(%rsp),%rdi
  5b4637:	00 
  5b4638:	e8 83 9d 17 00       	call   72e3c0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB4_7set_val9SetValZSTENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5b463d:	48 8b b4 24 a8 00 00 	mov    0xa8(%rsp),%rsi
  5b4644:	00 
  5b4645:	48 85 f6             	test   %rsi,%rsi
  5b4648:	74 17                	je     5b4661 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3a31>
  5b464a:	48 8b bc 24 b0 00 00 	mov    0xb0(%rsp),%rdi
  5b4651:	00 
  5b4652:	48 c1 e6 02          	shl    $0x2,%rsi
  5b4656:	ba 04 00 00 00       	mov    $0x4,%edx
  5b465b:	ff 15 47 59 53 00    	call   *0x535947(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b4661:	48 8b b4 24 78 01 00 	mov    0x178(%rsp),%rsi
  5b4668:	00 
  5b4669:	48 85 f6             	test   %rsi,%rsi
  5b466c:	74 13                	je     5b4681 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3a51>
  5b466e:	48 8b bc 24 80 01 00 	mov    0x180(%rsp),%rdi
  5b4675:	00 
  5b4676:	ba 01 00 00 00       	mov    $0x1,%edx
  5b467b:	ff 15 27 59 53 00    	call   *0x535927(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b4681:	48 8b b4 24 60 01 00 	mov    0x160(%rsp),%rsi
  5b4688:	00 
  5b4689:	48 85 f6             	test   %rsi,%rsi
  5b468c:	74 17                	je     5b46a5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3a75>
  5b468e:	48 8b bc 24 68 01 00 	mov    0x168(%rsp),%rdi
  5b4695:	00 
  5b4696:	48 c1 e6 04          	shl    $0x4,%rsi
  5b469a:	ba 04 00 00 00       	mov    $0x4,%edx
  5b469f:	ff 15 03 59 53 00    	call   *0x535903(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b46a5:	48 8b b4 24 48 01 00 	mov    0x148(%rsp),%rsi
  5b46ac:	00 
  5b46ad:	48 85 f6             	test   %rsi,%rsi
  5b46b0:	74 17                	je     5b46c9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3a99>
  5b46b2:	48 8b bc 24 50 01 00 	mov    0x150(%rsp),%rdi
  5b46b9:	00 
  5b46ba:	48 c1 e6 04          	shl    $0x4,%rsi
  5b46be:	ba 04 00 00 00       	mov    $0x4,%edx
  5b46c3:	ff 15 df 58 53 00    	call   *0x5358df(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b46c9:	48 8b 84 24 30 01 00 	mov    0x130(%rsp),%rax
  5b46d0:	00 
  5b46d1:	48 85 c0             	test   %rax,%rax
  5b46d4:	74 17                	je     5b46ed <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3abd>
  5b46d6:	48 8b bc 24 38 01 00 	mov    0x138(%rsp),%rdi
  5b46dd:	00 
  5b46de:	48 6b f0 38          	imul   $0x38,%rax,%rsi
  5b46e2:	ba 08 00 00 00       	mov    $0x8,%edx
  5b46e7:	ff 15 bb 58 53 00    	call   *0x5358bb(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b46ed:	48 8b bc 24 20 01 00 	mov    0x120(%rsp),%rdi
  5b46f4:	00 
  5b46f5:	48 8b b4 24 28 01 00 	mov    0x128(%rsp),%rsi
  5b46fc:	00 
  5b46fd:	e8 de 51 f7 ff       	call   5298e0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs7XZEQI6Z5Ts_11gpui_canvas4text10TextShaperEECs6gaF1xUz9Bf_4gpui>
  5b4702:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  5b4709:	00 
  5b470a:	48 85 c0             	test   %rax,%rax
  5b470d:	74 14                	je     5b4723 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3af3>
  5b470f:	f0 48 ff 08          	lock decq (%rax)
  5b4713:	75 0e                	jne    5b4723 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3af3>
  5b4715:	48 8d bc 24 98 00 00 	lea    0x98(%rsp),%rdi
  5b471c:	00 
  5b471d:	ff 15 2d 59 53 00    	call   *0x53592d(%rip)        # aea050 <_DYNAMIC+0x2f0>
  5b4723:	4c 8b 04 24          	mov    (%rsp),%r8
  5b4727:	66 41 0f 10 80 60 08 	movupd 0x860(%r8),%xmm0
  5b472e:	00 00 
  5b4730:	41 0f b6 80 5c 09 00 	movzbl 0x95c(%r8),%eax
  5b4737:	00 
  5b4738:	49 83 b8 80 08 00 00 	cmpq   $0x0,0x880(%r8)
  5b473f:	00 
  5b4740:	74 21                	je     5b4763 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3b33>
  5b4742:	89 c2                	mov    %eax,%edx
  5b4744:	80 f2 01             	xor    $0x1,%dl
  5b4747:	49 83 b8 60 07 00 00 	cmpq   $0xffffffffffffffff,0x760(%r8)
  5b474e:	ff 
  5b474f:	49 8b 88 90 08 00 00 	mov    0x890(%r8),%rcx
  5b4756:	40 0f 95 c6          	setne  %sil
  5b475a:	40 08 d6             	or     %dl,%sil
  5b475d:	40 0f b6 d6          	movzbl %sil,%edx
  5b4761:	eb 02                	jmp    5b4765 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3b35>
  5b4763:	31 d2                	xor    %edx,%edx
  5b4765:	48 8b bc 24 a0 00 00 	mov    0xa0(%rsp),%rdi
  5b476c:	00 
  5b476d:	49 8b b0 48 09 00 00 	mov    0x948(%r8),%rsi
  5b4774:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  5b4778:	48 89 4f 10          	mov    %rcx,0x10(%rdi)
  5b477c:	66 0f 11 47 18       	movupd %xmm0,0x18(%rdi)
  5b4781:	e9 45 c9 ff ff       	jmp    5b10cb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x49b>
  5b4786:	44 8b a4 24 d8 04 00 	mov    0x4d8(%rsp),%r12d
  5b478d:	00 
  5b478e:	8b ac 24 dc 04 00 00 	mov    0x4dc(%rsp),%ebp
  5b4795:	0f 10 84 24 e0 04 00 	movups 0x4e0(%rsp),%xmm0
  5b479c:	00 
  5b479d:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  5b47a2:	66 0f 10 84 24 f0 04 	movupd 0x4f0(%rsp),%xmm0
  5b47a9:	00 00 
  5b47ab:	66 0f 29 44 24 30    	movapd %xmm0,0x30(%rsp)
  5b47b1:	0f b6 9c 24 00 05 00 	movzbl 0x500(%rsp),%ebx
  5b47b8:	00 
  5b47b9:	8b 84 24 01 05 00 00 	mov    0x501(%rsp),%eax
  5b47c0:	89 44 24 58          	mov    %eax,0x58(%rsp)
  5b47c4:	8b 84 24 04 05 00 00 	mov    0x504(%rsp),%eax
  5b47cb:	89 44 24 5b          	mov    %eax,0x5b(%rsp)
  5b47cf:	45 89 e5             	mov    %r12d,%r13d
  5b47d2:	41 c1 ed 08          	shr    $0x8,%r13d
  5b47d6:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5b47dd:	00 
  5b47de:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b47e3:	eb 5d                	jmp    5b4842 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3c12>
  5b47e5:	41 bf 22 00 00 00    	mov    $0x22,%r15d
  5b47eb:	41 b4 01             	mov    $0x1,%r12b
  5b47ee:	45 31 ed             	xor    %r13d,%r13d
  5b47f1:	eb 0c                	jmp    5b47ff <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3bcf>
  5b47f3:	41 b4 01             	mov    $0x1,%r12b
  5b47f6:	45 31 ed             	xor    %r13d,%r13d
  5b47f9:	41 bf 22 00 00 00    	mov    $0x22,%r15d
  5b47ff:	eb 1c                	jmp    5b481d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3bed>
  5b4801:	4c 8b a4 24 d8 04 00 	mov    0x4d8(%rsp),%r12
  5b4808:	00 
  5b4809:	45 89 e5             	mov    %r12d,%r13d
  5b480c:	41 c1 ed 08          	shr    $0x8,%r13d
  5b4810:	4c 89 e5             	mov    %r12,%rbp
  5b4813:	48 c1 ed 20          	shr    $0x20,%rbp
  5b4817:	41 bf 22 00 00 00    	mov    $0x22,%r15d
  5b481d:	41 b6 01             	mov    $0x1,%r14b
  5b4820:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b4827:	00 
  5b4828:	e8 d3 32 f8 ff       	call   537b00 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs7XZEQI6Z5Ts_11gpui_canvas6canvas6CanvasECs6gaF1xUz9Bf_4gpui>
  5b482d:	b0 01                	mov    $0x1,%al
  5b482f:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b4833:	b0 01                	mov    $0x1,%al
  5b4835:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b4839:	b0 01                	mov    $0x1,%al
  5b483b:	89 84 24 c0 00 00 00 	mov    %eax,0xc0(%rsp)
  5b4842:	48 8d bc 24 48 04 00 	lea    0x448(%rsp),%rdi
  5b4849:	00 
  5b484a:	e8 c1 93 17 00       	call   72dc10 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5b484f:	48 83 bc 24 f0 01 00 	cmpq   $0xffffffffffffffff,0x1f0(%rsp)
  5b4856:	00 ff 
  5b4858:	0f 95 c0             	setne  %al
  5b485b:	84 84 24 c0 00 00 00 	test   %al,0xc0(%rsp)
  5b4862:	74 0d                	je     5b4871 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3c41>
  5b4864:	48 8d bc 24 f8 03 00 	lea    0x3f8(%rsp),%rdi
  5b486b:	00 
  5b486c:	e8 8f 1b f8 ff       	call   536400 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs7XZEQI6Z5Ts_11gpui_canvas5image5ImageEECs6gaF1xUz9Bf_4gpui>
  5b4871:	48 83 bc 24 98 03 00 	cmpq   $0xffffffffffffffff,0x398(%rsp)
  5b4878:	00 ff 
  5b487a:	0f 95 c0             	setne  %al
  5b487d:	84 44 24 40          	test   %al,0x40(%rsp)
  5b4881:	74 0d                	je     5b4890 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3c60>
  5b4883:	48 8d bc 24 98 03 00 	lea    0x398(%rsp),%rdi
  5b488a:	00 
  5b488b:	e8 f0 41 f8 ff       	call   538a80 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5SheetEBH_>
  5b4890:	48 8d bc 24 a8 02 00 	lea    0x2a8(%rsp),%rdi
  5b4897:	00 
  5b4898:	e8 23 9b 17 00       	call   72e3c0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB4_7set_val9SetValZSTENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5b489d:	48 8b b4 24 a8 00 00 	mov    0xa8(%rsp),%rsi
  5b48a4:	00 
  5b48a5:	48 85 f6             	test   %rsi,%rsi
  5b48a8:	74 17                	je     5b48c1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3c91>
  5b48aa:	48 8b bc 24 b0 00 00 	mov    0xb0(%rsp),%rdi
  5b48b1:	00 
  5b48b2:	48 c1 e6 02          	shl    $0x2,%rsi
  5b48b6:	ba 04 00 00 00       	mov    $0x4,%edx
  5b48bb:	ff 15 e7 56 53 00    	call   *0x5356e7(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b48c1:	48 8b b4 24 78 01 00 	mov    0x178(%rsp),%rsi
  5b48c8:	00 
  5b48c9:	48 85 f6             	test   %rsi,%rsi
  5b48cc:	74 13                	je     5b48e1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3cb1>
  5b48ce:	48 8b bc 24 80 01 00 	mov    0x180(%rsp),%rdi
  5b48d5:	00 
  5b48d6:	ba 01 00 00 00       	mov    $0x1,%edx
  5b48db:	ff 15 c7 56 53 00    	call   *0x5356c7(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b48e1:	48 8b b4 24 60 01 00 	mov    0x160(%rsp),%rsi
  5b48e8:	00 
  5b48e9:	48 85 f6             	test   %rsi,%rsi
  5b48ec:	74 17                	je     5b4905 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3cd5>
  5b48ee:	48 8b bc 24 68 01 00 	mov    0x168(%rsp),%rdi
  5b48f5:	00 
  5b48f6:	48 c1 e6 04          	shl    $0x4,%rsi
  5b48fa:	ba 04 00 00 00       	mov    $0x4,%edx
  5b48ff:	ff 15 a3 56 53 00    	call   *0x5356a3(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b4905:	48 8b b4 24 48 01 00 	mov    0x148(%rsp),%rsi
  5b490c:	00 
  5b490d:	48 85 f6             	test   %rsi,%rsi
  5b4910:	74 17                	je     5b4929 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3cf9>
  5b4912:	48 8b bc 24 50 01 00 	mov    0x150(%rsp),%rdi
  5b4919:	00 
  5b491a:	48 c1 e6 04          	shl    $0x4,%rsi
  5b491e:	ba 04 00 00 00       	mov    $0x4,%edx
  5b4923:	ff 15 7f 56 53 00    	call   *0x53567f(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b4929:	44 89 74 24 08       	mov    %r14d,0x8(%rsp)
  5b492e:	48 8b 84 24 30 01 00 	mov    0x130(%rsp),%rax
  5b4935:	00 
  5b4936:	48 85 c0             	test   %rax,%rax
  5b4939:	74 17                	je     5b4952 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3d22>
  5b493b:	48 8b bc 24 38 01 00 	mov    0x138(%rsp),%rdi
  5b4942:	00 
  5b4943:	48 6b f0 38          	imul   $0x38,%rax,%rsi
  5b4947:	ba 08 00 00 00       	mov    $0x8,%edx
  5b494c:	ff 15 56 56 53 00    	call   *0x535656(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b4952:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  5b4957:	74 0d                	je     5b4966 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3d36>
  5b4959:	48 8d bc 24 b8 01 00 	lea    0x1b8(%rsp),%rdi
  5b4960:	00 
  5b4961:	e8 0a 19 f8 ff       	call   536270 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs6gaF1xUz9Bf_4gpui7runtime9PresentedEEB1b_>
  5b4966:	83 bc 24 28 03 00 00 	cmpl   $0xfffffffe,0x328(%rsp)
  5b496d:	fe 
  5b496e:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b4973:	74 0d                	je     5b4982 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3d52>
  5b4975:	48 8d bc 24 28 03 00 	lea    0x328(%rsp),%rdi
  5b497c:	00 
  5b497d:	e8 fe 2e f8 ff       	call   537880 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime5ErrorEBF_.llvm.18021777786862421399>
  5b4982:	48 8b bc 24 20 01 00 	mov    0x120(%rsp),%rdi
  5b4989:	00 
  5b498a:	48 8b b4 24 28 01 00 	mov    0x128(%rsp),%rsi
  5b4991:	00 
  5b4992:	e8 49 4f f7 ff       	call   5298e0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs7XZEQI6Z5Ts_11gpui_canvas4text10TextShaperEECs6gaF1xUz9Bf_4gpui>
  5b4997:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  5b499e:	00 
  5b499f:	48 85 c0             	test   %rax,%rax
  5b49a2:	74 14                	je     5b49b8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3d88>
  5b49a4:	f0 48 ff 08          	lock decq (%rax)
  5b49a8:	75 0e                	jne    5b49b8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3d88>
  5b49aa:	48 8d bc 24 98 00 00 	lea    0x98(%rsp),%rdi
  5b49b1:	00 
  5b49b2:	ff 15 98 56 53 00    	call   *0x535698(%rip)        # aea050 <_DYNAMIC+0x2f0>
  5b49b8:	83 bc 24 58 0c 00 00 	cmpl   $0x2,0xc58(%rsp)
  5b49bf:	02 
  5b49c0:	74 12                	je     5b49d4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3da4>
  5b49c2:	45 84 f6             	test   %r14b,%r14b
  5b49c5:	74 0d                	je     5b49d4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3da4>
  5b49c7:	48 8d bc 24 58 0c 00 	lea    0xc58(%rsp),%rdi
  5b49ce:	00 
  5b49cf:	e8 2c 31 f8 ff       	call   537b00 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs7XZEQI6Z5Ts_11gpui_canvas6canvas6CanvasECs6gaF1xUz9Bf_4gpui>
  5b49d4:	41 c1 e5 08          	shl    $0x8,%r13d
  5b49d8:	41 0f b6 c4          	movzbl %r12b,%eax
  5b49dc:	4c 09 e8             	or     %r13,%rax
  5b49df:	48 c1 e5 20          	shl    $0x20,%rbp
  5b49e3:	48 09 c5             	or     %rax,%rbp
  5b49e6:	8b 44 24 58          	mov    0x58(%rsp),%eax
  5b49ea:	8b 4c 24 5b          	mov    0x5b(%rsp),%ecx
  5b49ee:	89 84 24 a1 02 00 00 	mov    %eax,0x2a1(%rsp)
  5b49f5:	89 8c 24 a4 02 00 00 	mov    %ecx,0x2a4(%rsp)
  5b49fc:	4c 89 bc 24 70 02 00 	mov    %r15,0x270(%rsp)
  5b4a03:	00 
  5b4a04:	48 89 ac 24 78 02 00 	mov    %rbp,0x278(%rsp)
  5b4a0b:	00 
  5b4a0c:	0f 28 44 24 60       	movaps 0x60(%rsp),%xmm0
  5b4a11:	0f 11 84 24 80 02 00 	movups %xmm0,0x280(%rsp)
  5b4a18:	00 
  5b4a19:	66 0f 28 44 24 30    	movapd 0x30(%rsp),%xmm0
  5b4a1f:	66 0f 11 84 24 90 02 	movupd %xmm0,0x290(%rsp)
  5b4a26:	00 00 
  5b4a28:	88 9c 24 a0 02 00 00 	mov    %bl,0x2a0(%rsp)
  5b4a2f:	49 83 ff fd          	cmp    $0xfffffffffffffffd,%r15
  5b4a33:	0f 85 0a 01 00 00    	jne    5b4b43 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3f13>
  5b4a39:	4c 8b 34 24          	mov    (%rsp),%r14
  5b4a3d:	41 c6 86 58 09 00 00 	movb   $0x1,0x958(%r14)
  5b4a44:	01 
  5b4a45:	4d 8d be 98 08 00 00 	lea    0x898(%r14),%r15
  5b4a4c:	4c 89 ff             	mov    %r15,%rdi
  5b4a4f:	e8 cc 51 f7 ff       	call   529c20 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs7XZEQI6Z5Ts_11gpui_canvas4text10TextSystemEECs6gaF1xUz9Bf_4gpui>
  5b4a54:	49 c7 86 98 08 00 00 	movq   $0x0,0x898(%r14)
  5b4a5b:	00 00 00 00 
  5b4a5f:	49 8b 9e e0 02 00 00 	mov    0x2e0(%r14),%rbx
  5b4a66:	48 85 db             	test   %rbx,%rbx
  5b4a69:	74 35                	je     5b4aa0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3e70>
  5b4a6b:	4d 8b b6 d8 02 00 00 	mov    0x2d8(%r14),%r14
  5b4a72:	eb 15                	jmp    5b4a89 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3e59>
  5b4a74:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b4a7b:	00 00 00 00 00 
  5b4a80:	49 83 c6 50          	add    $0x50,%r14
  5b4a84:	48 ff cb             	dec    %rbx
  5b4a87:	74 17                	je     5b4aa0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3e70>
  5b4a89:	49 83 3e fe          	cmpq   $0xfffffffffffffffe,(%r14)
  5b4a8d:	74 f1                	je     5b4a80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3e50>
  5b4a8f:	4c 89 f7             	mov    %r14,%rdi
  5b4a92:	e8 09 4c f7 ff       	call   5296a0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime6ShapedEEB11_.llvm.18021777786862421399>
  5b4a97:	49 c7 06 ff ff ff ff 	movq   $0xffffffffffffffff,(%r14)
  5b4a9e:	eb e0                	jmp    5b4a80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3e50>
  5b4aa0:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5b4aa7:	00 
  5b4aa8:	48 c7 00 10 00 00 00 	movq   $0x10,(%rax)
  5b4aaf:	4c 8b b4 24 80 02 00 	mov    0x280(%rsp),%r14
  5b4ab6:	00 
  5b4ab7:	49 8b 06             	mov    (%r14),%rax
  5b4aba:	48 85 c0             	test   %rax,%rax
  5b4abd:	74 05                	je     5b4ac4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3e94>
  5b4abf:	48 89 ef             	mov    %rbp,%rdi
  5b4ac2:	ff d0                	call   *%rax
  5b4ac4:	49 8b 76 08          	mov    0x8(%r14),%rsi
  5b4ac8:	48 85 f6             	test   %rsi,%rsi
  5b4acb:	0f 84 c2 00 00 00    	je     5b4b93 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3f63>
  5b4ad1:	49 8b 56 10          	mov    0x10(%r14),%rdx
  5b4ad5:	48 89 ef             	mov    %rbp,%rdi
  5b4ad8:	ff 15 ca 54 53 00    	call   *0x5354ca(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b4ade:	e9 b0 00 00 00       	jmp    5b4b93 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3f63>
  5b4ae3:	66 0f 7f 44 24 60    	movdqa %xmm0,0x60(%rsp)
  5b4ae9:	0f b6 9c 24 00 05 00 	movzbl 0x500(%rsp),%ebx
  5b4af0:	00 
  5b4af1:	8b 8c 24 01 05 00 00 	mov    0x501(%rsp),%ecx
  5b4af8:	89 4c 24 58          	mov    %ecx,0x58(%rsp)
  5b4afc:	8b 8c 24 04 05 00 00 	mov    0x504(%rsp),%ecx
  5b4b03:	89 4c 24 5b          	mov    %ecx,0x5b(%rsp)
  5b4b07:	f3 0f 7e 84 24 f8 04 	movq   0x4f8(%rsp),%xmm0
  5b4b0e:	00 00 
  5b4b10:	45 89 e5             	mov    %r12d,%r13d
  5b4b13:	41 c1 ed 08          	shr    $0x8,%r13d
  5b4b17:	66 48 0f 6e c8       	movq   %rax,%xmm1
  5b4b1c:	66 0f 6c c8          	punpcklqdq %xmm0,%xmm1
  5b4b20:	66 0f 7f 4c 24 30    	movdqa %xmm1,0x30(%rsp)
  5b4b26:	e9 f2 fc ff ff       	jmp    5b481d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3bed>
  5b4b2b:	48 c7 84 24 70 02 00 	movq   $0x1e,0x270(%rsp)
  5b4b32:	00 1e 00 00 00 
  5b4b37:	48 c7 84 24 78 02 00 	movq   $0x0,0x278(%rsp)
  5b4b3e:	00 00 00 00 00 
  5b4b43:	48 8b 84 24 a0 02 00 	mov    0x2a0(%rsp),%rax
  5b4b4a:	00 
  5b4b4b:	48 8b 94 24 a0 00 00 	mov    0xa0(%rsp),%rdx
  5b4b52:	00 
  5b4b53:	48 89 42 30          	mov    %rax,0x30(%rdx)
  5b4b57:	48 8b 84 24 70 02 00 	mov    0x270(%rsp),%rax
  5b4b5e:	00 
  5b4b5f:	48 8b 8c 24 78 02 00 	mov    0x278(%rsp),%rcx
  5b4b66:	00 
  5b4b67:	66 0f 10 84 24 80 02 	movupd 0x280(%rsp),%xmm0
  5b4b6e:	00 00 
  5b4b70:	0f 10 8c 24 90 02 00 	movups 0x290(%rsp),%xmm1
  5b4b77:	00 
  5b4b78:	0f 11 4a 20          	movups %xmm1,0x20(%rdx)
  5b4b7c:	66 0f 11 42 10       	movupd %xmm0,0x10(%rdx)
  5b4b81:	48 89 02             	mov    %rax,(%rdx)
  5b4b84:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  5b4b88:	48 8b 04 24          	mov    (%rsp),%rax
  5b4b8c:	c6 80 58 09 00 00 01 	movb   $0x1,0x958(%rax)
  5b4b93:	48 81 c4 98 10 00 00 	add    $0x1098,%rsp
  5b4b9a:	5b                   	pop    %rbx
  5b4b9b:	41 5c                	pop    %r12
  5b4b9d:	41 5d                	pop    %r13
  5b4b9f:	41 5e                	pop    %r14
  5b4ba1:	41 5f                	pop    %r15
  5b4ba3:	5d                   	pop    %rbp
  5b4ba4:	c3                   	ret
  5b4ba5:	48 8d 3d 0c 6f ac ff 	lea    -0x5390f4(%rip),%rdi        # 7bab8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5b4bac:	48 8d 15 b5 41 50 00 	lea    0x5041b5(%rip),%rdx        # ab8d68 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x130>
  5b4bb3:	be a1 00 00 00       	mov    $0xa1,%esi
  5b4bb8:	ff 15 22 54 53 00    	call   *0x535422(%rip)        # ae9fe0 <_DYNAMIC+0x280>
  5b4bbe:	e9 49 d4 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4bc3:	41 b5 01             	mov    $0x1,%r13b
  5b4bc6:	48 8d 3d 53 41 50 00 	lea    0x504153(%rip),%rdi        # ab8d20 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0xe8>
  5b4bcd:	b0 01                	mov    $0x1,%al
  5b4bcf:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b4bd3:	40 b5 01             	mov    $0x1,%bpl
  5b4bd6:	b0 01                	mov    $0x1,%al
  5b4bd8:	89 44 24 08          	mov    %eax,0x8(%rsp)
  5b4bdc:	ff 15 36 54 53 00    	call   *0x535436(%rip)        # aea018 <_DYNAMIC+0x2b8>
  5b4be2:	e9 25 d4 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4be7:	48 8d 3d 1a 78 50 00 	lea    0x50781a(%rip),%rdi        # abc408 <anon.e9030509e4132593006b31277530c411.11.llvm.555413502705965614>
  5b4bee:	ff 15 24 54 53 00    	call   *0x535424(%rip)        # aea018 <_DYNAMIC+0x2b8>
  5b4bf4:	e9 13 d4 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4bf9:	48 8d 05 00 43 50 00 	lea    0x504300(%rip),%rax        # ab8f00 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x108>
  5b4c00:	48 89 84 24 58 02 00 	mov    %rax,0x258(%rsp)
  5b4c07:	00 
  5b4c08:	48 8d 3d a0 6f ac ff 	lea    -0x539060(%rip),%rdi        # 7bbaf <anon.2a25786c1a741fd89e690b6b2ddad436.90.llvm.18021777786862421399+0x2a>
  5b4c0f:	be 1e 00 00 00       	mov    $0x1e,%esi
  5b4c14:	48 8b 94 24 58 02 00 	mov    0x258(%rsp),%rdx
  5b4c1b:	00 
  5b4c1c:	ff 15 ee 53 53 00    	call   *0x5353ee(%rip)        # aea010 <_DYNAMIC+0x2b0>
  5b4c22:	e9 e5 d3 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4c27:	b8 55 00 00 00       	mov    $0x55,%eax
  5b4c2c:	48 89 84 24 f8 01 00 	mov    %rax,0x1f8(%rsp)
  5b4c33:	00 
  5b4c34:	48 8d 05 bb 66 ac ff 	lea    -0x539945(%rip),%rax        # 7b2f6 <anon.2a25786c1a741fd89e690b6b2ddad436.25.llvm.18021777786862421399>
  5b4c3b:	48 89 84 24 60 02 00 	mov    %rax,0x260(%rsp)
  5b4c42:	00 
  5b4c43:	48 8d 05 1e 3d 50 00 	lea    0x503d1e(%rip),%rax        # ab8968 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399>
  5b4c4a:	48 89 84 24 68 02 00 	mov    %rax,0x268(%rsp)
  5b4c51:	00 
  5b4c52:	48 8b bc 24 60 02 00 	mov    0x260(%rsp),%rdi
  5b4c59:	00 
  5b4c5a:	48 8b b4 24 f8 01 00 	mov    0x1f8(%rsp),%rsi
  5b4c61:	00 
  5b4c62:	48 8b 94 24 68 02 00 	mov    0x268(%rsp),%rdx
  5b4c69:	00 
  5b4c6a:	ff 15 70 53 53 00    	call   *0x535370(%rip)        # ae9fe0 <_DYNAMIC+0x280>
  5b4c70:	e9 97 d3 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4c75:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
  5b4c7c:	00 
  5b4c7d:	ff 15 25 54 53 00    	call   *0x535425(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5b4c83:	e9 84 d3 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4c88:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
  5b4c8f:	00 
  5b4c90:	ff 15 12 54 53 00    	call   *0x535412(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5b4c96:	e9 71 d3 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4c9b:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
  5b4ca2:	00 
  5b4ca3:	ff 15 ff 53 53 00    	call   *0x5353ff(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5b4ca9:	e9 5e d3 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4cae:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
  5b4cb5:	00 
  5b4cb6:	ff 15 ec 53 53 00    	call   *0x5353ec(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5b4cbc:	e9 4b d3 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4cc1:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
  5b4cc8:	00 
  5b4cc9:	ff 15 d9 53 53 00    	call   *0x5353d9(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5b4ccf:	e9 38 d3 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4cd4:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
  5b4cdb:	00 
  5b4cdc:	ff 15 c6 53 53 00    	call   *0x5353c6(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5b4ce2:	e9 25 d3 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4ce7:	48 8d 05 aa 3c 50 00 	lea    0x503caa(%rip),%rax        # ab8998 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x30>
  5b4cee:	48 89 84 24 e8 01 00 	mov    %rax,0x1e8(%rsp)
  5b4cf5:	00 
  5b4cf6:	48 8b bc 24 e8 01 00 	mov    0x1e8(%rsp),%rdi
  5b4cfd:	00 
  5b4cfe:	ff 15 14 53 53 00    	call   *0x535314(%rip)        # aea018 <_DYNAMIC+0x2b8>
  5b4d04:	e9 03 d3 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4d09:	48 8d 3d f8 76 50 00 	lea    0x5076f8(%rip),%rdi        # abc408 <anon.e9030509e4132593006b31277530c411.11.llvm.555413502705965614>
  5b4d10:	ff 15 02 53 53 00    	call   *0x535302(%rip)        # aea018 <_DYNAMIC+0x2b8>
  5b4d16:	e9 f1 d2 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4d1b:	4c 89 fb             	mov    %r15,%rbx
  5b4d1e:	48 8d 3d 93 6d ac ff 	lea    -0x53926d(%rip),%rdi        # 7bab8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5b4d25:	48 8d 15 3c 40 50 00 	lea    0x50403c(%rip),%rdx        # ab8d68 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x130>
  5b4d2c:	be a1 00 00 00       	mov    $0xa1,%esi
  5b4d31:	ff 15 a9 52 53 00    	call   *0x5352a9(%rip)        # ae9fe0 <_DYNAMIC+0x280>
  5b4d37:	e9 d0 d2 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4d3c:	48 8d 3d 9d 65 ac ff 	lea    -0x539a63(%rip),%rdi        # 7b2e0 <anon.1fd5a6dfce1e15409e22077740bd43db.29.llvm.12479153529690704726+0x121>
  5b4d43:	be 16 00 00 00       	mov    $0x16,%esi
  5b4d48:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  5b4d4d:	ff 15 bd 52 53 00    	call   *0x5352bd(%rip)        # aea010 <_DYNAMIC+0x2b0>
  5b4d53:	e9 b4 d2 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4d58:	b8 a1 00 00 00       	mov    $0xa1,%eax
  5b4d5d:	48 89 84 24 f8 01 00 	mov    %rax,0x1f8(%rsp)
  5b4d64:	00 
  5b4d65:	e9 e8 fe ff ff       	jmp    5b4c52 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4022>
  5b4d6a:	48 8d 3d 2f 41 50 00 	lea    0x50412f(%rip),%rdi        # ab8ea0 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0xa8>
  5b4d71:	ff 15 a1 52 53 00    	call   *0x5352a1(%rip)        # aea018 <_DYNAMIC+0x2b8>
  5b4d77:	e9 90 d2 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4d7c:	48 8d 05 95 41 50 00 	lea    0x504195(%rip),%rax        # ab8f18 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x120>
  5b4d83:	e9 66 ff ff ff       	jmp    5b4cee <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x40be>
  5b4d88:	48 8d 3d 51 3c 50 00 	lea    0x503c51(%rip),%rdi        # ab89e0 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x78>
  5b4d8f:	ff 15 83 52 53 00    	call   *0x535283(%rip)        # aea018 <_DYNAMIC+0x2b8>
  5b4d95:	e9 72 d2 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4d9a:	48 8d 05 6f 3c 50 00 	lea    0x503c6f(%rip),%rax        # ab8a10 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0xa8>
  5b4da1:	eb 3d                	jmp    5b4de0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41b0>
  5b4da3:	48 8d 05 96 40 50 00 	lea    0x504096(%rip),%rax        # ab8e40 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x48>
  5b4daa:	eb 34                	jmp    5b4de0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41b0>
  5b4dac:	48 8d 05 f5 3e 50 00 	lea    0x503ef5(%rip),%rax        # ab8ca8 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x70>
  5b4db3:	eb 2b                	jmp    5b4de0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41b0>
  5b4db5:	48 8d 05 04 3f 50 00 	lea    0x503f04(%rip),%rax        # ab8cc0 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x88>
  5b4dbc:	eb 22                	jmp    5b4de0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41b0>
  5b4dbe:	4c 89 ef             	mov    %r13,%rdi
  5b4dc1:	48 8d 05 e0 3e 50 00 	lea    0x503ee0(%rip),%rax        # ab8ca8 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x70>
  5b4dc8:	eb 16                	jmp    5b4de0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41b0>
  5b4dca:	4c 89 ef             	mov    %r13,%rdi
  5b4dcd:	48 8d 05 ec 3e 50 00 	lea    0x503eec(%rip),%rax        # ab8cc0 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x88>
  5b4dd4:	eb 0a                	jmp    5b4de0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x41b0>
  5b4dd6:	48 89 d7             	mov    %rdx,%rdi
  5b4dd9:	48 8d 05 f8 3e 50 00 	lea    0x503ef8(%rip),%rax        # ab8cd8 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0xa0>
  5b4de0:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  5b4de5:	48 89 ee             	mov    %rbp,%rsi
  5b4de8:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  5b4ded:	ff 15 e5 51 53 00    	call   *0x5351e5(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5b4df3:	e9 14 d2 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4df8:	b0 01                	mov    $0x1,%al
  5b4dfa:	89 44 24 08          	mov    %eax,0x8(%rsp)
  5b4dfe:	48 8d 15 83 40 50 00 	lea    0x504083(%rip),%rdx        # ab8e88 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x90>
  5b4e05:	31 ff                	xor    %edi,%edi
  5b4e07:	31 f6                	xor    %esi,%esi
  5b4e09:	ff 15 c9 51 53 00    	call   *0x5351c9(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5b4e0f:	e9 f8 d1 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4e14:	49 89 c7             	mov    %rax,%r15
  5b4e17:	48 8d 05 b2 40 50 00 	lea    0x5040b2(%rip),%rax        # ab8ed0 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0xd8>
  5b4e1e:	eb 5e                	jmp    5b4e7e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x424e>
  5b4e20:	48 8d 05 91 3c 50 00 	lea    0x503c91(%rip),%rax        # ab8ab8 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x150>
  5b4e27:	eb 55                	jmp    5b4e7e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x424e>
  5b4e29:	48 8d 05 80 3b 50 00 	lea    0x503b80(%rip),%rax        # ab89b0 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x48>
  5b4e30:	eb 4c                	jmp    5b4e7e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x424e>
  5b4e32:	48 8d 05 97 3c 50 00 	lea    0x503c97(%rip),%rax        # ab8ad0 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x168>
  5b4e39:	eb 43                	jmp    5b4e7e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x424e>
  5b4e3b:	48 8d 05 a6 3c 50 00 	lea    0x503ca6(%rip),%rax        # ab8ae8 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x180>
  5b4e42:	eb 3a                	jmp    5b4e7e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x424e>
  5b4e44:	49 89 c4             	mov    %rax,%r12
  5b4e47:	48 8d 05 32 3b 50 00 	lea    0x503b32(%rip),%rax        # ab8980 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x18>
  5b4e4e:	eb 2e                	jmp    5b4e7e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x424e>
  5b4e50:	48 8d 05 c1 3c 50 00 	lea    0x503cc1(%rip),%rax        # ab8b18 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x1b0>
  5b4e57:	eb 25                	jmp    5b4e7e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x424e>
  5b4e59:	48 8d 05 a0 3c 50 00 	lea    0x503ca0(%rip),%rax        # ab8b00 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x198>
  5b4e60:	eb 1c                	jmp    5b4e7e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x424e>
  5b4e62:	48 8d 05 3f 3e 50 00 	lea    0x503e3f(%rip),%rax        # ab8ca8 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x70>
  5b4e69:	eb 13                	jmp    5b4e7e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x424e>
  5b4e6b:	48 8d 05 4e 3e 50 00 	lea    0x503e4e(%rip),%rax        # ab8cc0 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x88>
  5b4e72:	eb 0a                	jmp    5b4e7e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x424e>
  5b4e74:	49 89 cc             	mov    %rcx,%r12
  5b4e77:	48 8d 05 5a 3e 50 00 	lea    0x503e5a(%rip),%rax        # ab8cd8 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0xa0>
  5b4e7e:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  5b4e83:	4c 89 e7             	mov    %r12,%rdi
  5b4e86:	4c 89 fe             	mov    %r15,%rsi
  5b4e89:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  5b4e8e:	ff 15 44 51 53 00    	call   *0x535144(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5b4e94:	e9 73 d1 ff ff       	jmp    5b200c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x13dc>
  5b4e99:	48 8d 05 d0 3b 50 00 	lea    0x503bd0(%rip),%rax        # ab8a70 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x108>
  5b4ea0:	eb dc                	jmp    5b4e7e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x424e>
  5b4ea2:	49 89 c7             	mov    %rax,%r15
  5b4ea5:	48 8b 04 24          	mov    (%rsp),%rax
  5b4ea9:	48 8b 80 10 08 00 00 	mov    0x810(%rax),%rax
  5b4eb0:	0f 28 84 24 20 05 00 	movaps 0x520(%rsp),%xmm0
  5b4eb7:	00 
  5b4eb8:	0f 11 80 c8 00 00 00 	movups %xmm0,0xc8(%rax)
  5b4ebf:	0f 28 84 24 10 05 00 	movaps 0x510(%rsp),%xmm0
  5b4ec6:	00 
  5b4ec7:	0f 11 80 b8 00 00 00 	movups %xmm0,0xb8(%rax)
  5b4ece:	66 0f 28 84 24 d0 04 	movapd 0x4d0(%rsp),%xmm0
  5b4ed5:	00 00 
  5b4ed7:	0f 28 8c 24 e0 04 00 	movaps 0x4e0(%rsp),%xmm1
  5b4ede:	00 
  5b4edf:	0f 28 94 24 f0 04 00 	movaps 0x4f0(%rsp),%xmm2
  5b4ee6:	00 
  5b4ee7:	0f 28 9c 24 00 05 00 	movaps 0x500(%rsp),%xmm3
  5b4eee:	00 
  5b4eef:	0f 11 98 a8 00 00 00 	movups %xmm3,0xa8(%rax)
  5b4ef6:	0f 11 90 98 00 00 00 	movups %xmm2,0x98(%rax)
  5b4efd:	0f 11 88 88 00 00 00 	movups %xmm1,0x88(%rax)
  5b4f04:	66 0f 11 40 78       	movupd %xmm0,0x78(%rax)
  5b4f09:	41 b5 01             	mov    $0x1,%r13b
  5b4f0c:	c7 44 24 40 00 00 00 	movl   $0x0,0x40(%rsp)
  5b4f13:	00 
  5b4f14:	b0 01                	mov    $0x1,%al
  5b4f16:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b4f1a:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b4f1f:	e9 f5 03 00 00       	jmp    5b5319 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x46e9>
  5b4f24:	48 89 c3             	mov    %rax,%rbx
  5b4f27:	be f0 00 00 00       	mov    $0xf0,%esi
  5b4f2c:	ba 08 00 00 00       	mov    $0x8,%edx
  5b4f31:	4c 89 ff             	mov    %r15,%rdi
  5b4f34:	ff 15 6e 50 53 00    	call   *0x53506e(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b4f3a:	48 8b 04 24          	mov    (%rsp),%rax
  5b4f3e:	48 c7 80 10 08 00 00 	movq   $0x0,0x810(%rax)
  5b4f45:	00 00 00 00 
  5b4f49:	48 89 df             	mov    %rbx,%rdi
  5b4f4c:	e8 5f 25 50 00       	call   ab74b0 <_Unwind_Resume@plt>
  5b4f51:	49 89 c7             	mov    %rax,%r15
  5b4f54:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
  5b4f5b:	e9 90 00 00 00       	jmp    5b4ff0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x43c0>
  5b4f60:	49 89 c7             	mov    %rax,%r15
  5b4f63:	48 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%rsi
  5b4f6a:	00 
  5b4f6b:	ba 28 02 00 00       	mov    $0x228,%edx
  5b4f70:	48 89 df             	mov    %rbx,%rdi
  5b4f73:	ff 15 87 50 53 00    	call   *0x535087(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5b4f79:	41 b5 01             	mov    $0x1,%r13b
  5b4f7c:	45 31 f6             	xor    %r14d,%r14d
  5b4f7f:	b0 01                	mov    $0x1,%al
  5b4f81:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b4f85:	b0 01                	mov    $0x1,%al
  5b4f87:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b4f8b:	e9 89 03 00 00       	jmp    5b5319 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x46e9>
  5b4f90:	49 89 c7             	mov    %rax,%r15
  5b4f93:	b0 01                	mov    $0x1,%al
  5b4f95:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b4f99:	45 31 ed             	xor    %r13d,%r13d
  5b4f9c:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b4fa1:	e9 73 03 00 00       	jmp    5b5319 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x46e9>
  5b4fa6:	49 89 c7             	mov    %rax,%r15
  5b4fa9:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b4fb0:	00 
  5b4fb1:	48 89 45 10          	mov    %rax,0x10(%rbp)
  5b4fb5:	0f 28 84 24 d0 04 00 	movaps 0x4d0(%rsp),%xmm0
  5b4fbc:	00 
  5b4fbd:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
  5b4fc1:	4c 89 a3 78 07 00 00 	mov    %r12,0x778(%rbx)
  5b4fc8:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  5b4fcf:	00 
  5b4fd0:	66 89 83 80 07 00 00 	mov    %ax,0x780(%rbx)
  5b4fd7:	8b 44 24 54          	mov    0x54(%rsp),%eax
  5b4fdb:	66 89 83 82 07 00 00 	mov    %ax,0x782(%rbx)
  5b4fe2:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  5b4fe8:	f3 0f 11 83 84 07 00 	movss  %xmm0,0x784(%rbx)
  5b4fef:	00 
  5b4ff0:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5b4ff7:	00 
  5b4ff8:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b4ffd:	e9 17 03 00 00       	jmp    5b5319 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x46e9>
  5b5002:	4c 89 fb             	mov    %r15,%rbx
  5b5005:	e9 72 02 00 00       	jmp    5b527c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x464c>
  5b500a:	49 89 c7             	mov    %rax,%r15
  5b500d:	e9 32 03 00 00       	jmp    5b5344 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4714>
  5b5012:	49 89 c7             	mov    %rax,%r15
  5b5015:	48 8b bc 24 20 02 00 	mov    0x220(%rsp),%rdi
  5b501c:	00 
  5b501d:	e8 ee 45 f7 ff       	call   529610 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui11shared_text10SharedTextEEB11_>
  5b5022:	e9 d3 02 00 00       	jmp    5b52fa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x46ca>
  5b5027:	ff 15 9b 4f 53 00    	call   *0x534f9b(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5b502d:	49 89 c7             	mov    %rax,%r15
  5b5030:	e9 3b 03 00 00       	jmp    5b5370 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4740>
  5b5035:	49 89 c7             	mov    %rax,%r15
  5b5038:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b503c:	48 89 99 98 08 00 00 	mov    %rbx,0x898(%rcx)
  5b5043:	44 89 a1 a0 08 00 00 	mov    %r12d,0x8a0(%rcx)
  5b504a:	89 a9 a4 08 00 00    	mov    %ebp,0x8a4(%rcx)
  5b5050:	66 0f 28 84 24 10 04 	movapd 0x410(%rsp),%xmm0
  5b5057:	00 00 
  5b5059:	0f 28 8c 24 20 04 00 	movaps 0x420(%rsp),%xmm1
  5b5060:	00 
  5b5061:	0f 28 94 24 30 04 00 	movaps 0x430(%rsp),%xmm2
  5b5068:	00 
  5b5069:	66 0f 11 81 a8 08 00 	movupd %xmm0,0x8a8(%rcx)
  5b5070:	00 
  5b5071:	0f 11 89 b8 08 00 00 	movups %xmm1,0x8b8(%rcx)
  5b5078:	0f 11 91 c8 08 00 00 	movups %xmm2,0x8c8(%rcx)
  5b507f:	48 8b 84 24 40 04 00 	mov    0x440(%rsp),%rax
  5b5086:	00 
  5b5087:	48 89 81 d8 08 00 00 	mov    %rax,0x8d8(%rcx)
  5b508e:	41 b6 01             	mov    $0x1,%r14b
  5b5091:	e9 f3 03 00 00       	jmp    5b5489 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4859>
  5b5096:	49 89 c7             	mov    %rax,%r15
  5b5099:	48 89 5d 00          	mov    %rbx,0x0(%rbp)
  5b509d:	66 0f 6f 84 24 c0 02 	movdqa 0x2c0(%rsp),%xmm0
  5b50a4:	00 00 
  5b50a6:	66 0f 7e 45 08       	movd   %xmm0,0x8(%rbp)
  5b50ab:	66 0f 70 c0 55       	pshufd $0x55,%xmm0,%xmm0
  5b50b0:	66 0f 7e 45 0c       	movd   %xmm0,0xc(%rbp)
  5b50b5:	0f 28 84 24 f0 00 00 	movaps 0xf0(%rsp),%xmm0
  5b50bc:	00 
  5b50bd:	0f 28 8c 24 00 01 00 	movaps 0x100(%rsp),%xmm1
  5b50c4:	00 
  5b50c5:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  5b50c9:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  5b50cd:	48 8b 84 24 10 01 00 	mov    0x110(%rsp),%rax
  5b50d4:	00 
  5b50d5:	48 89 45 30          	mov    %rax,0x30(%rbp)
  5b50d9:	c7 45 38 01 00 00 00 	movl   $0x1,0x38(%rbp)
  5b50e0:	f3 0f 10 84 24 84 00 	movss  0x84(%rsp),%xmm0
  5b50e7:	00 00 
  5b50e9:	f3 0f 11 45 3c       	movss  %xmm0,0x3c(%rbp)
  5b50ee:	e9 07 02 00 00       	jmp    5b52fa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x46ca>
  5b50f3:	49 89 c7             	mov    %rax,%r15
  5b50f6:	e9 68 02 00 00       	jmp    5b5363 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4733>
  5b50fb:	49 89 c7             	mov    %rax,%r15
  5b50fe:	41 b5 01             	mov    $0x1,%r13b
  5b5101:	b0 01                	mov    $0x1,%al
  5b5103:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b5107:	b0 01                	mov    $0x1,%al
  5b5109:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b510d:	41 b6 01             	mov    $0x1,%r14b
  5b5110:	e9 04 02 00 00       	jmp    5b5319 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x46e9>
  5b5115:	49 89 c7             	mov    %rax,%r15
  5b5118:	44 8b ac 24 c0 00 00 	mov    0xc0(%rsp),%r13d
  5b511f:	00 
  5b5120:	e9 01 02 00 00       	jmp    5b5326 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x46f6>
  5b5125:	48 89 c3             	mov    %rax,%rbx
  5b5128:	b8 78 00 00 00       	mov    $0x78,%eax
  5b512d:	eb 08                	jmp    5b5137 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4507>
  5b512f:	48 89 c3             	mov    %rax,%rbx
  5b5132:	b8 18 00 00 00       	mov    $0x18,%eax
  5b5137:	41 0f 10 44 24 50    	movups 0x50(%r12),%xmm0
  5b513d:	41 0f 11 44 07 50    	movups %xmm0,0x50(%r15,%rax,1)
  5b5143:	41 0f 10 44 24 40    	movups 0x40(%r12),%xmm0
  5b5149:	41 0f 11 44 07 40    	movups %xmm0,0x40(%r15,%rax,1)
  5b514f:	41 0f 10 04 24       	movups (%r12),%xmm0
  5b5154:	41 0f 10 4c 24 10    	movups 0x10(%r12),%xmm1
  5b515a:	41 0f 10 54 24 20    	movups 0x20(%r12),%xmm2
  5b5160:	41 0f 10 5c 24 30    	movups 0x30(%r12),%xmm3
  5b5166:	41 0f 11 5c 07 30    	movups %xmm3,0x30(%r15,%rax,1)
  5b516c:	41 0f 11 54 07 20    	movups %xmm2,0x20(%r15,%rax,1)
  5b5172:	41 0f 11 4c 07 10    	movups %xmm1,0x10(%r15,%rax,1)
  5b5178:	41 0f 11 04 07       	movups %xmm0,(%r15,%rax,1)
  5b517d:	48 89 df             	mov    %rbx,%rdi
  5b5180:	e8 2b 23 50 00       	call   ab74b0 <_Unwind_Resume@plt>
  5b5185:	49 89 c7             	mov    %rax,%r15
  5b5188:	48 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%rsi
  5b518f:	00 
  5b5190:	ba 48 04 00 00       	mov    $0x448,%edx
  5b5195:	48 89 df             	mov    %rbx,%rdi
  5b5198:	ff 15 62 4e 53 00    	call   *0x534e62(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5b519e:	e9 ad 02 00 00       	jmp    5b5450 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4820>
  5b51a3:	49 89 c7             	mov    %rax,%r15
  5b51a6:	e9 de 02 00 00       	jmp    5b5489 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4859>
  5b51ab:	49 89 c7             	mov    %rax,%r15
  5b51ae:	e9 b5 02 00 00       	jmp    5b5468 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4838>
  5b51b3:	eb 53                	jmp    5b5208 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x45d8>
  5b51b5:	48 89 c3             	mov    %rax,%rbx
  5b51b8:	eb 5e                	jmp    5b5218 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x45e8>
  5b51ba:	48 89 c3             	mov    %rax,%rbx
  5b51bd:	49 8b 76 08          	mov    0x8(%r14),%rsi
  5b51c1:	48 85 f6             	test   %rsi,%rsi
  5b51c4:	0f 84 a4 00 00 00    	je     5b526e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x463e>
  5b51ca:	49 8b 56 10          	mov    0x10(%r14),%rdx
  5b51ce:	48 89 ef             	mov    %rbp,%rdi
  5b51d1:	ff 15 d1 4d 53 00    	call   *0x534dd1(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b51d7:	48 89 df             	mov    %rbx,%rdi
  5b51da:	e8 d1 22 50 00       	call   ab74b0 <_Unwind_Resume@plt>
  5b51df:	48 89 c3             	mov    %rax,%rbx
  5b51e2:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
  5b51e9:	eb 76                	jmp    5b5261 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4631>
  5b51eb:	e9 5d 02 00 00       	jmp    5b544d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x481d>
  5b51f0:	eb 16                	jmp    5b5208 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x45d8>
  5b51f2:	e9 00 01 00 00       	jmp    5b52f7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x46c7>
  5b51f7:	49 89 c7             	mov    %rax,%r15
  5b51fa:	e9 a6 02 00 00       	jmp    5b54a5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4875>
  5b51ff:	eb 07                	jmp    5b5208 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x45d8>
  5b5201:	eb 05                	jmp    5b5208 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x45d8>
  5b5203:	e9 45 02 00 00       	jmp    5b544d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x481d>
  5b5208:	48 89 c3             	mov    %rax,%rbx
  5b520b:	48 8d bc 24 58 0c 00 	lea    0xc58(%rsp),%rdi
  5b5212:	00 
  5b5213:	e8 f8 89 17 00       	call   72dc10 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5b5218:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b521f:	00 
  5b5220:	e8 5b 38 f8 ff       	call   538a80 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5SheetEBH_>
  5b5225:	eb 47                	jmp    5b526e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x463e>
  5b5227:	e9 21 02 00 00       	jmp    5b544d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x481d>
  5b522c:	0f 0b                	ud2
  5b522e:	49 89 c7             	mov    %rax,%r15
  5b5231:	48 8d bc 24 f8 03 00 	lea    0x3f8(%rsp),%rdi
  5b5238:	00 
  5b5239:	e8 c2 11 f8 ff       	call   536400 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs7XZEQI6Z5Ts_11gpui_canvas5image5ImageEECs6gaF1xUz9Bf_4gpui>
  5b523e:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b5243:	b0 01                	mov    $0x1,%al
  5b5245:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b5249:	45 31 ed             	xor    %r13d,%r13d
  5b524c:	e9 c8 00 00 00       	jmp    5b5319 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x46e9>
  5b5251:	ff 15 71 4d 53 00    	call   *0x534d71(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5b5257:	48 89 c3             	mov    %rax,%rbx
  5b525a:	49 c7 06 ff ff ff ff 	movq   $0xffffffffffffffff,(%r14)
  5b5261:	48 8d bc 24 70 02 00 	lea    0x270(%rsp),%rdi
  5b5268:	00 
  5b5269:	e8 b2 4d f7 ff       	call   52a020 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultIBC_bNtNtCs6gaF1xUz9Bf_4gpui7runtime5ErrorEINtNtCscdodAO9FK5_5alloc5boxed3BoxDNtNtB4_3any3AnyNtNtB4_6marker4SendEL_EEEB16_>
  5b526e:	48 89 df             	mov    %rbx,%rdi
  5b5271:	e8 3a 22 50 00       	call   ab74b0 <_Unwind_Resume@plt>
  5b5276:	ff 15 4c 4d 53 00    	call   *0x534d4c(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5b527c:	49 89 c7             	mov    %rax,%r15
  5b527f:	48 89 df             	mov    %rbx,%rdi
  5b5282:	e8 89 43 f7 ff       	call   529610 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui11shared_text10SharedTextEEB11_>
  5b5287:	eb 71                	jmp    5b52fa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x46ca>
  5b5289:	0f 0b                	ud2
  5b528b:	49 89 c7             	mov    %rax,%r15
  5b528e:	b0 01                	mov    $0x1,%al
  5b5290:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b5294:	41 b6 01             	mov    $0x1,%r14b
  5b5297:	e9 f8 00 00 00       	jmp    5b5394 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4764>
  5b529c:	49 89 c7             	mov    %rax,%r15
  5b529f:	b0 01                	mov    $0x1,%al
  5b52a1:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b52a5:	41 b6 01             	mov    $0x1,%r14b
  5b52a8:	e9 07 01 00 00       	jmp    5b53b4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4784>
  5b52ad:	49 89 c7             	mov    %rax,%r15
  5b52b0:	b0 01                	mov    $0x1,%al
  5b52b2:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b52b6:	41 b6 01             	mov    $0x1,%r14b
  5b52b9:	e9 1a 01 00 00       	jmp    5b53d8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x47a8>
  5b52be:	49 89 c7             	mov    %rax,%r15
  5b52c1:	b0 01                	mov    $0x1,%al
  5b52c3:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b52c7:	41 b6 01             	mov    $0x1,%r14b
  5b52ca:	e9 2d 01 00 00       	jmp    5b53fc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x47cc>
  5b52cf:	49 89 c7             	mov    %rax,%r15
  5b52d2:	41 b6 01             	mov    $0x1,%r14b
  5b52d5:	e9 4d 01 00 00       	jmp    5b5427 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x47f7>
  5b52da:	49 89 c7             	mov    %rax,%r15
  5b52dd:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b52e2:	e9 4d 01 00 00       	jmp    5b5434 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4804>
  5b52e7:	0f 0b                	ud2
  5b52e9:	89 6c 24 10          	mov    %ebp,0x10(%rsp)
  5b52ed:	49 89 c7             	mov    %rax,%r15
  5b52f0:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b52f5:	eb 22                	jmp    5b5319 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x46e9>
  5b52f7:	49 89 c7             	mov    %rax,%r15
  5b52fa:	41 b5 01             	mov    $0x1,%r13b
  5b52fd:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b5304:	00 
  5b5305:	e8 f6 27 f8 ff       	call   537b00 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs7XZEQI6Z5Ts_11gpui_canvas6canvas6CanvasECs6gaF1xUz9Bf_4gpui>
  5b530a:	b0 01                	mov    $0x1,%al
  5b530c:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b5310:	b0 01                	mov    $0x1,%al
  5b5312:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b5316:	41 b6 01             	mov    $0x1,%r14b
  5b5319:	48 8d bc 24 48 04 00 	lea    0x448(%rsp),%rdi
  5b5320:	00 
  5b5321:	e8 ea 88 17 00       	call   72dc10 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5b5326:	48 83 bc 24 f0 01 00 	cmpq   $0xffffffffffffffff,0x1f0(%rsp)
  5b532d:	00 ff 
  5b532f:	0f 95 c0             	setne  %al
  5b5332:	44 84 e8             	test   %r13b,%al
  5b5335:	74 0d                	je     5b5344 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4714>
  5b5337:	48 8d bc 24 f8 03 00 	lea    0x3f8(%rsp),%rdi
  5b533e:	00 
  5b533f:	e8 bc 10 f8 ff       	call   536400 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs7XZEQI6Z5Ts_11gpui_canvas5image5ImageEECs6gaF1xUz9Bf_4gpui>
  5b5344:	48 83 bc 24 98 03 00 	cmpq   $0xffffffffffffffff,0x398(%rsp)
  5b534b:	00 ff 
  5b534d:	0f 95 c0             	setne  %al
  5b5350:	84 44 24 40          	test   %al,0x40(%rsp)
  5b5354:	74 0d                	je     5b5363 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4733>
  5b5356:	48 8d bc 24 98 03 00 	lea    0x398(%rsp),%rdi
  5b535d:	00 
  5b535e:	e8 1d 37 f8 ff       	call   538a80 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5SheetEBH_>
  5b5363:	48 8d bc 24 a8 02 00 	lea    0x2a8(%rsp),%rdi
  5b536a:	00 
  5b536b:	e8 50 90 17 00       	call   72e3c0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB4_7set_val9SetValZSTENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5b5370:	48 8b b4 24 a8 00 00 	mov    0xa8(%rsp),%rsi
  5b5377:	00 
  5b5378:	48 85 f6             	test   %rsi,%rsi
  5b537b:	74 17                	je     5b5394 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4764>
  5b537d:	48 8b bc 24 b0 00 00 	mov    0xb0(%rsp),%rdi
  5b5384:	00 
  5b5385:	48 c1 e6 02          	shl    $0x2,%rsi
  5b5389:	ba 04 00 00 00       	mov    $0x4,%edx
  5b538e:	ff 15 14 4c 53 00    	call   *0x534c14(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b5394:	48 8b b4 24 78 01 00 	mov    0x178(%rsp),%rsi
  5b539b:	00 
  5b539c:	48 85 f6             	test   %rsi,%rsi
  5b539f:	74 13                	je     5b53b4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4784>
  5b53a1:	48 8b bc 24 80 01 00 	mov    0x180(%rsp),%rdi
  5b53a8:	00 
  5b53a9:	ba 01 00 00 00       	mov    $0x1,%edx
  5b53ae:	ff 15 f4 4b 53 00    	call   *0x534bf4(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b53b4:	48 8b b4 24 60 01 00 	mov    0x160(%rsp),%rsi
  5b53bb:	00 
  5b53bc:	48 85 f6             	test   %rsi,%rsi
  5b53bf:	74 17                	je     5b53d8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x47a8>
  5b53c1:	48 8b bc 24 68 01 00 	mov    0x168(%rsp),%rdi
  5b53c8:	00 
  5b53c9:	48 c1 e6 04          	shl    $0x4,%rsi
  5b53cd:	ba 04 00 00 00       	mov    $0x4,%edx
  5b53d2:	ff 15 d0 4b 53 00    	call   *0x534bd0(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b53d8:	48 8b b4 24 48 01 00 	mov    0x148(%rsp),%rsi
  5b53df:	00 
  5b53e0:	48 85 f6             	test   %rsi,%rsi
  5b53e3:	74 17                	je     5b53fc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x47cc>
  5b53e5:	48 8b bc 24 50 01 00 	mov    0x150(%rsp),%rdi
  5b53ec:	00 
  5b53ed:	48 c1 e6 04          	shl    $0x4,%rsi
  5b53f1:	ba 04 00 00 00       	mov    $0x4,%edx
  5b53f6:	ff 15 ac 4b 53 00    	call   *0x534bac(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b53fc:	48 8b 84 24 30 01 00 	mov    0x130(%rsp),%rax
  5b5403:	00 
  5b5404:	48 85 c0             	test   %rax,%rax
  5b5407:	74 17                	je     5b5420 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x47f0>
  5b5409:	48 8b bc 24 38 01 00 	mov    0x138(%rsp),%rdi
  5b5410:	00 
  5b5411:	48 6b f0 38          	imul   $0x38,%rax,%rsi
  5b5415:	ba 08 00 00 00       	mov    $0x8,%edx
  5b541a:	ff 15 88 4b 53 00    	call   *0x534b88(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b5420:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  5b5425:	74 0d                	je     5b5434 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4804>
  5b5427:	48 8d bc 24 b8 01 00 	lea    0x1b8(%rsp),%rdi
  5b542e:	00 
  5b542f:	e8 3c 0e f8 ff       	call   536270 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs6gaF1xUz9Bf_4gpui7runtime9PresentedEEB1b_>
  5b5434:	83 bc 24 28 03 00 00 	cmpl   $0xfffffffe,0x328(%rsp)
  5b543b:	fe 
  5b543c:	74 15                	je     5b5453 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4823>
  5b543e:	48 8d bc 24 28 03 00 	lea    0x328(%rsp),%rdi
  5b5445:	00 
  5b5446:	e8 35 24 f8 ff       	call   537880 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime5ErrorEBF_.llvm.18021777786862421399>
  5b544b:	eb 06                	jmp    5b5453 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4823>
  5b544d:	49 89 c7             	mov    %rax,%r15
  5b5450:	41 b6 01             	mov    $0x1,%r14b
  5b5453:	48 8b bc 24 20 01 00 	mov    0x120(%rsp),%rdi
  5b545a:	00 
  5b545b:	48 8b b4 24 28 01 00 	mov    0x128(%rsp),%rsi
  5b5462:	00 
  5b5463:	e8 78 44 f7 ff       	call   5298e0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs7XZEQI6Z5Ts_11gpui_canvas4text10TextShaperEECs6gaF1xUz9Bf_4gpui>
  5b5468:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  5b546f:	00 
  5b5470:	48 85 c0             	test   %rax,%rax
  5b5473:	74 14                	je     5b5489 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4859>
  5b5475:	f0 48 ff 08          	lock decq (%rax)
  5b5479:	75 0e                	jne    5b5489 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4859>
  5b547b:	48 8d bc 24 98 00 00 	lea    0x98(%rsp),%rdi
  5b5482:	00 
  5b5483:	ff 15 c7 4b 53 00    	call   *0x534bc7(%rip)        # aea050 <_DYNAMIC+0x2f0>
  5b5489:	83 bc 24 58 0c 00 00 	cmpl   $0x2,0xc58(%rsp)
  5b5490:	02 
  5b5491:	74 12                	je     5b54a5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4875>
  5b5493:	45 84 f6             	test   %r14b,%r14b
  5b5496:	74 0d                	je     5b54a5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x4875>
  5b5498:	48 8d bc 24 58 0c 00 	lea    0xc58(%rsp),%rdi
  5b549f:	00 
  5b54a0:	e8 5b 26 f8 ff       	call   537b00 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs7XZEQI6Z5Ts_11gpui_canvas6canvas6CanvasECs6gaF1xUz9Bf_4gpui>
  5b54a5:	4c 89 ff             	mov    %r15,%rdi
  5b54a8:	ff 15 12 4b 53 00    	call   *0x534b12(%rip)        # ae9fc0 <_DYNAMIC+0x260>
  5b54ae:	48 89 c5             	mov    %rax,%rbp
  5b54b1:	48 89 84 24 78 02 00 	mov    %rax,0x278(%rsp)
  5b54b8:	00 
  5b54b9:	48 89 94 24 80 02 00 	mov    %rdx,0x280(%rsp)
  5b54c0:	00 
  5b54c1:	48 c7 84 24 70 02 00 	movq   $0xfffffffffffffffd,0x270(%rsp)
  5b54c8:	00 fd ff ff ff 
  5b54cd:	e9 67 f5 ff ff       	jmp    5b4a39 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399+0x3e09>
  5b54d2:	ff 15 f8 4a 53 00    	call   *0x534af8(%rip)        # ae9fd0 <_DYNAMIC+0x270>
  5b54d8:	ff 15 ea 4a 53 00    	call   *0x534aea(%rip)        # ae9fc8 <_DYNAMIC+0x268>
