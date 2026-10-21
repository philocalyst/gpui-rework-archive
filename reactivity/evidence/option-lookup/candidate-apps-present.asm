
/tmp/gpui-option-lookup-apps-4ce6cc649f0e16dbafb29422b9fe83c03ae8c259be19afa59f8979a49f4cb322:     file format elf64-x86-64


Disassembly of section .text:

00000000005b0bb0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896>:
  5b0bb0:	55                   	push   %rbp
  5b0bb1:	41 57                	push   %r15
  5b0bb3:	41 56                	push   %r14
  5b0bb5:	41 55                	push   %r13
  5b0bb7:	41 54                	push   %r12
  5b0bb9:	53                   	push   %rbx
  5b0bba:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  5b0bc1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  5b0bc8:	00 
  5b0bc9:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  5b0bd0:	49 89 f5             	mov    %rsi,%r13
  5b0bd3:	80 be 5b 09 00 00 00 	cmpb   $0x0,0x95b(%rsi)
  5b0bda:	48 89 34 24          	mov    %rsi,(%rsp)
  5b0bde:	0f 84 a6 00 00 00    	je     5b0c8a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xda>
  5b0be4:	49 8b 9d 90 07 00 00 	mov    0x790(%r13),%rbx
  5b0beb:	49 89 d8             	mov    %rbx,%r8
  5b0bee:	49 ff c0             	inc    %r8
  5b0bf1:	48 89 bc 24 a0 00 00 	mov    %rdi,0xa0(%rsp)
  5b0bf8:	00 
  5b0bf9:	0f 84 ac 3e 00 00    	je     5b4aab <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3efb>
  5b0bff:	4d 8b bd 88 07 00 00 	mov    0x788(%r13),%r15
  5b0c06:	49 8b b5 78 08 00 00 	mov    0x878(%r13),%rsi
  5b0c0d:	66 48 0f 6e c6       	movq   %rsi,%xmm0
  5b0c12:	66 0f 7f 44 24 60    	movdqa %xmm0,0x60(%rsp)
  5b0c18:	66 0f 70 c0 55       	pshufd $0x55,%xmm0,%xmm0
  5b0c1d:	66 0f 7e c2          	movd   %xmm0,%edx
  5b0c21:	f3 41 0f 10 85 50 09 	movss  0x950(%r13),%xmm0
  5b0c28:	00 00 
  5b0c2a:	f3 0f 11 44 24 24    	movss  %xmm0,0x24(%rsp)
  5b0c30:	41 8b 85 f0 01 00 00 	mov    0x1f0(%r13),%eax
  5b0c37:	49 8b 8d f8 01 00 00 	mov    0x1f8(%r13),%rcx
  5b0c3e:	48 c1 e1 20          	shl    $0x20,%rcx
  5b0c42:	48 09 c1             	or     %rax,%rcx
  5b0c45:	48 89 b4 24 90 00 00 	mov    %rsi,0x90(%rsp)
  5b0c4c:	00 
  5b0c4d:	48 39 f1             	cmp    %rsi,%rcx
  5b0c50:	4c 89 84 24 90 03 00 	mov    %r8,0x390(%rsp)
  5b0c57:	00 
  5b0c58:	89 54 24 54          	mov    %edx,0x54(%rsp)
  5b0c5c:	0f 85 64 03 00 00    	jne    5b0fc6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x416>
  5b0c62:	48 c7 84 24 58 0c 00 	movq   $0x2,0xc58(%rsp)
  5b0c69:	00 02 00 00 00 
  5b0c6e:	41 be 02 00 00 00    	mov    $0x2,%r14d
  5b0c74:	81 bc 24 90 00 00 00 	cmpl   $0xffff,0x90(%rsp)
  5b0c7b:	ff ff 00 00 
  5b0c7f:	0f 86 ed 04 00 00    	jbe    5b1172 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x5c2>
  5b0c85:	e9 f2 04 00 00       	jmp    5b117c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x5cc>
  5b0c8a:	4d 8b 95 60 08 00 00 	mov    0x860(%r13),%r10
  5b0c91:	4d 85 d2             	test   %r10,%r10
  5b0c94:	0f 84 ff 02 00 00    	je     5b0f99 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3e9>
  5b0c9a:	4d 8b bd 10 08 00 00 	mov    0x810(%r13),%r15
  5b0ca1:	4d 85 ff             	test   %r15,%r15
  5b0ca4:	0f 84 ef 02 00 00    	je     5b0f99 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3e9>
  5b0caa:	49 8b 85 90 08 00 00 	mov    0x890(%r13),%rax
  5b0cb1:	49 8d 4a ff          	lea    -0x1(%r10),%rcx
  5b0cb5:	48 39 c8             	cmp    %rcx,%rax
  5b0cb8:	0f 85 a0 03 00 00    	jne    5b105e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4ae>
  5b0cbe:	4c 89 94 24 90 00 00 	mov    %r10,0x90(%rsp)
  5b0cc5:	00 
  5b0cc6:	48 89 bc 24 a0 00 00 	mov    %rdi,0xa0(%rsp)
  5b0ccd:	00 
  5b0cce:	49 8b ad 60 07 00 00 	mov    0x760(%r13),%rbp
  5b0cd5:	41 0f b6 95 5c 09 00 	movzbl 0x95c(%r13),%edx
  5b0cdc:	00 
  5b0cdd:	88 54 24 24          	mov    %dl,0x24(%rsp)
  5b0ce1:	80 f2 01             	xor    $0x1,%dl
  5b0ce4:	49 8d 85 68 07 00 00 	lea    0x768(%r13),%rax
  5b0ceb:	49 8d 8d 50 07 00 00 	lea    0x750(%r13),%rcx
  5b0cf2:	48 83 fd ff          	cmp    $0xffffffffffffffff,%rbp
  5b0cf6:	88 54 24 60          	mov    %dl,0x60(%rsp)
  5b0cfa:	0f b6 d2             	movzbl %dl,%edx
  5b0cfd:	be 01 00 00 00       	mov    $0x1,%esi
  5b0d02:	0f 44 f2             	cmove  %edx,%esi
  5b0d05:	89 74 24 54          	mov    %esi,0x54(%rsp)
  5b0d09:	4d 8b a5 58 07 00 00 	mov    0x758(%r13),%r12
  5b0d10:	4d 8b b5 70 07 00 00 	mov    0x770(%r13),%r14
  5b0d17:	48 0f 44 c1          	cmove  %rcx,%rax
  5b0d1b:	48 8b 18             	mov    (%rax),%rbx
  5b0d1e:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b0d25:	00 
  5b0d26:	4c 89 ee             	mov    %r13,%rsi
  5b0d29:	4c 89 fa             	mov    %r15,%rdx
  5b0d2c:	e8 2f 92 f8 ff       	call   539f60 <_RNCNvMs1_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataINtB9_7RuntimeNtNtB9_12style_ledger9AdversaryE14metadata_sheet0Bb_>
  5b0d31:	49 8b 85 18 08 00 00 	mov    0x818(%r13),%rax
  5b0d38:	49 8b 8d 20 08 00 00 	mov    0x820(%r13),%rcx
  5b0d3f:	31 d2                	xor    %edx,%edx
  5b0d41:	48 89 c6             	mov    %rax,%rsi
  5b0d44:	48 85 c0             	test   %rax,%rax
  5b0d47:	0f 95 c2             	setne  %dl
  5b0d4a:	74 0b                	je     5b0d57 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1a7>
  5b0d4c:	48 8b 34 24          	mov    (%rsp),%rsi
  5b0d50:	48 8b b6 28 08 00 00 	mov    0x828(%rsi),%rsi
  5b0d57:	48 89 94 24 a0 09 00 	mov    %rdx,0x9a0(%rsp)
  5b0d5e:	00 
  5b0d5f:	48 c7 84 24 a8 09 00 	movq   $0x0,0x9a8(%rsp)
  5b0d66:	00 00 00 00 00 
  5b0d6b:	48 89 84 24 b0 09 00 	mov    %rax,0x9b0(%rsp)
  5b0d72:	00 
  5b0d73:	48 89 8c 24 b8 09 00 	mov    %rcx,0x9b8(%rsp)
  5b0d7a:	00 
  5b0d7b:	48 89 94 24 c0 09 00 	mov    %rdx,0x9c0(%rsp)
  5b0d82:	00 
  5b0d83:	48 c7 84 24 c8 09 00 	movq   $0x0,0x9c8(%rsp)
  5b0d8a:	00 00 00 00 00 
  5b0d8f:	48 89 84 24 d0 09 00 	mov    %rax,0x9d0(%rsp)
  5b0d96:	00 
  5b0d97:	48 89 8c 24 d8 09 00 	mov    %rcx,0x9d8(%rsp)
  5b0d9e:	00 
  5b0d9f:	48 89 b4 24 e0 09 00 	mov    %rsi,0x9e0(%rsp)
  5b0da6:	00 
  5b0da7:	48 8d bc 24 58 0c 00 	lea    0xc58(%rsp),%rdi
  5b0dae:	00 
  5b0daf:	48 8d b4 24 a0 09 00 	lea    0x9a0(%rsp),%rsi
  5b0db6:	00 
  5b0db7:	e8 74 22 17 00       	call   723030 <_RINvXs1o_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB7_8BTreeMapyNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata8ListInfoEINtNtNtNtCs4NRVxsYgnAr_4core4iter6traits7collect12FromIteratorTyB19_EE9from_iterINtNtNtB26_8adapters3map3MapINtB7_4IterNtNtB1f_4list6ListIdNtNtB1d_4list9ListStateENCNvMs1_B1b_INtB1d_7RuntimeNtNtB1d_12style_ledger9AdversaryE13list_metadata0EEB1f_>
  5b0dbc:	48 89 6c 24 30       	mov    %rbp,0x30(%rsp)
  5b0dc1:	48 83 fd ff          	cmp    $0xffffffffffffffff,%rbp
  5b0dc5:	4d 0f 44 f4          	cmove  %r12,%r14
  5b0dc9:	4d 85 f6             	test   %r14,%r14
  5b0dcc:	0f 84 79 18 00 00    	je     5b264b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1a9b>
  5b0dd2:	49 c1 e6 04          	shl    $0x4,%r14
  5b0dd6:	4b 8d 2c b6          	lea    (%r14,%r14,4),%rbp
  5b0dda:	4c 8d 24 2b          	lea    (%rbx,%rbp,1),%r12
  5b0dde:	4c 8b b4 24 58 0c 00 	mov    0xc58(%rsp),%r14
  5b0de5:	00 
  5b0de6:	48 8b 04 24          	mov    (%rsp),%rax
  5b0dea:	4c 8b a8 30 08 00 00 	mov    0x830(%rax),%r13
  5b0df1:	48 8b 80 38 08 00 00 	mov    0x838(%rax),%rax
  5b0df8:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  5b0dfd:	4d 85 f6             	test   %r14,%r14
  5b0e00:	0f 84 88 11 00 00    	je     5b1f8e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13de>
  5b0e06:	48 8b ac 24 60 0c 00 	mov    0xc60(%rsp),%rbp
  5b0e0d:	00 
  5b0e0e:	4d 85 ed             	test   %r13,%r13
  5b0e11:	0f 84 71 12 00 00    	je     5b2088 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x14d8>
  5b0e17:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5b0e1e:	00 00 
  5b0e20:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  5b0e24:	48 83 c3 50          	add    $0x50,%rbx
  5b0e28:	48 89 e9             	mov    %rbp,%rcx
  5b0e2b:	4c 89 f0             	mov    %r14,%rax
  5b0e2e:	0f b7 b8 12 01 00 00 	movzwl 0x112(%rax),%edi
  5b0e35:	41 89 f9             	mov    %edi,%r9d
  5b0e38:	41 c1 e1 04          	shl    $0x4,%r9d
  5b0e3c:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  5b0e43:	45 31 c0             	xor    %r8d,%r8d
  5b0e46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5b0e4d:	00 00 00 
  5b0e50:	4d 39 c1             	cmp    %r8,%r9
  5b0e53:	74 3b                	je     5b0e90 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2e0>
  5b0e55:	48 3b 94 f0 c0 00 00 	cmp    0xc0(%rax,%rsi,8),%rdx
  5b0e5c:	00 
  5b0e5d:	41 0f 97 c2          	seta   %r10b
  5b0e61:	41 80 da 00          	sbb    $0x0,%r10b
  5b0e65:	49 83 c0 10          	add    $0x10,%r8
  5b0e69:	48 ff c6             	inc    %rsi
  5b0e6c:	41 80 fa 01          	cmp    $0x1,%r10b
  5b0e70:	74 de                	je     5b0e50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2a0>
  5b0e72:	41 0f b6 fa          	movzbl %r10b,%edi
  5b0e76:	85 ff                	test   %edi,%edi
  5b0e78:	74 36                	je     5b0eb0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x300>
  5b0e7a:	48 83 e9 01          	sub    $0x1,%rcx
  5b0e7e:	73 1d                	jae    5b0e9d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2ed>
  5b0e80:	e9 08 01 00 00       	jmp    5b0f8d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3dd>
  5b0e85:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5b0e8c:	00 00 00 00 
  5b0e90:	48 89 fe             	mov    %rdi,%rsi
  5b0e93:	48 83 e9 01          	sub    $0x1,%rcx
  5b0e97:	0f 82 f0 00 00 00    	jb     5b0f8d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3dd>
  5b0e9d:	48 8b 84 f0 18 01 00 	mov    0x118(%rax,%rsi,8),%rax
  5b0ea4:	00 
  5b0ea5:	eb 87                	jmp    5b0e2e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x27e>
  5b0ea7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5b0eae:	00 00 
  5b0eb0:	4a 8b 4c 00 f0       	mov    -0x10(%rax,%r8,1),%rcx
  5b0eb5:	42 8b 44 00 f8       	mov    -0x8(%rax,%r8,1),%eax
  5b0eba:	48 89 8c 24 a8 09 00 	mov    %rcx,0x9a8(%rsp)
  5b0ec1:	00 
  5b0ec2:	89 84 24 b0 09 00 00 	mov    %eax,0x9b0(%rsp)
  5b0ec9:	b8 01 00 00 00       	mov    $0x1,%eax
  5b0ece:	48 89 84 24 a0 09 00 	mov    %rax,0x9a0(%rsp)
  5b0ed5:	00 
  5b0ed6:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  5b0edb:	4d 89 e8             	mov    %r13,%r8
  5b0ede:	41 0f b7 b0 c2 01 00 	movzwl 0x1c2(%r8),%esi
  5b0ee5:	00 
  5b0ee6:	41 89 f1             	mov    %esi,%r9d
  5b0ee9:	41 c1 e1 05          	shl    $0x5,%r9d
  5b0eed:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  5b0ef4:	31 ff                	xor    %edi,%edi
  5b0ef6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5b0efd:	00 00 00 
  5b0f00:	4d 89 ca             	mov    %r9,%r10
  5b0f03:	49 01 fa             	add    %rdi,%r10
  5b0f06:	74 38                	je     5b0f40 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x390>
  5b0f08:	49 3b 94 c8 70 01 00 	cmp    0x170(%r8,%rcx,8),%rdx
  5b0f0f:	00 
  5b0f10:	41 0f 97 c2          	seta   %r10b
  5b0f14:	41 80 da 00          	sbb    $0x0,%r10b
  5b0f18:	48 83 c7 e0          	add    $0xffffffffffffffe0,%rdi
  5b0f1c:	48 ff c1             	inc    %rcx
  5b0f1f:	41 80 fa 01          	cmp    $0x1,%r10b
  5b0f23:	74 db                	je     5b0f00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x350>
  5b0f25:	41 0f b6 f2          	movzbl %r10b,%esi
  5b0f29:	85 f6                	test   %esi,%esi
  5b0f2b:	74 33                	je     5b0f60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3b0>
  5b0f2d:	48 83 e8 01          	sub    $0x1,%rax
  5b0f31:	73 16                	jae    5b0f49 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x399>
  5b0f33:	eb 5f                	jmp    5b0f94 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3e4>
  5b0f35:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5b0f3c:	00 00 00 00 
  5b0f40:	48 89 f1             	mov    %rsi,%rcx
  5b0f43:	48 83 e8 01          	sub    $0x1,%rax
  5b0f47:	72 4b                	jb     5b0f94 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3e4>
  5b0f49:	4d 8b 84 c8 c8 01 00 	mov    0x1c8(%r8,%rcx,8),%r8
  5b0f50:	00 
  5b0f51:	eb 8b                	jmp    5b0ede <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x32e>
  5b0f53:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b0f5a:	84 00 00 00 00 00 
  5b0f60:	49 29 f8             	sub    %rdi,%r8
  5b0f63:	49 83 c0 e0          	add    $0xffffffffffffffe0,%r8
  5b0f67:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b0f6e:	00 
  5b0f6f:	4c 89 fe             	mov    %r15,%rsi
  5b0f72:	48 8d 8c 24 a0 09 00 	lea    0x9a0(%rsp),%rcx
  5b0f79:	00 
  5b0f7a:	e8 31 70 1a 00       	call   757fb0 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataNtB4_5Sheet7capture>
  5b0f7f:	4c 39 e3             	cmp    %r12,%rbx
  5b0f82:	0f 85 98 fe ff ff    	jne    5b0e20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x270>
  5b0f88:	e9 be 16 00 00       	jmp    5b264b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1a9b>
  5b0f8d:	31 c0                	xor    %eax,%eax
  5b0f8f:	e9 3a ff ff ff       	jmp    5b0ece <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x31e>
  5b0f94:	45 31 c0             	xor    %r8d,%r8d
  5b0f97:	eb ce                	jmp    5b0f67 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3b7>
  5b0f99:	4d 89 95 90 08 00 00 	mov    %r10,0x890(%r13)
  5b0fa0:	49 8b 95 60 07 00 00 	mov    0x760(%r13),%rdx
  5b0fa7:	48 83 fa ff          	cmp    $0xffffffffffffffff,%rdx
  5b0fab:	0f 94 c1             	sete   %cl
  5b0fae:	41 0f b6 85 5c 09 00 	movzbl 0x95c(%r13),%eax
  5b0fb5:	00 
  5b0fb6:	84 c1                	test   %al,%cl
  5b0fb8:	74 51                	je     5b100b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x45b>
  5b0fba:	4d 89 95 68 08 00 00 	mov    %r10,0x868(%r13)
  5b0fc1:	4c 89 d1             	mov    %r10,%rcx
  5b0fc4:	eb 4c                	jmp    5b1012 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x462>
  5b0fc6:	49 8d 85 80 01 00 00 	lea    0x180(%r13),%rax
  5b0fcd:	41 80 bd 5d 09 00 00 	cmpb   $0x0,0x95d(%r13)
  5b0fd4:	00 
  5b0fd5:	0f 84 e3 00 00 00    	je     5b10be <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x50e>
  5b0fdb:	66 0f 10 00          	movupd (%rax),%xmm0
  5b0fdf:	66 0f 29 84 24 a0 09 	movapd %xmm0,0x9a0(%rsp)
  5b0fe6:	00 00 
  5b0fe8:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b0fef:	00 
  5b0ff0:	48 8d 8c 24 a0 09 00 	lea    0x9a0(%rsp),%rcx
  5b0ff7:	00 
  5b0ff8:	48 8b b4 24 90 00 00 	mov    0x90(%rsp),%rsi
  5b0fff:	00 
  5b1000:	ff 15 2a 8f 53 00    	call   *0x538f2a(%rip)        # ae9f30 <_DYNAMIC+0x380>
  5b1006:	e9 de 00 00 00       	jmp    5b10e9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x539>
  5b100b:	49 8b 8d 68 08 00 00 	mov    0x868(%r13),%rcx
  5b1012:	89 c6                	mov    %eax,%esi
  5b1014:	40 80 f6 01          	xor    $0x1,%sil
  5b1018:	48 83 fa ff          	cmp    $0xffffffffffffffff,%rdx
  5b101c:	0f 95 c2             	setne  %dl
  5b101f:	49 83 bd 80 08 00 00 	cmpq   $0x0,0x880(%r13)
  5b1026:	00 
  5b1027:	41 0f 95 c0          	setne  %r8b
  5b102b:	40 08 f2             	or     %sil,%dl
  5b102e:	44 20 c2             	and    %r8b,%dl
  5b1031:	0f b6 d2             	movzbl %dl,%edx
  5b1034:	49 8b b5 48 09 00 00 	mov    0x948(%r13),%rsi
  5b103b:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  5b103f:	4c 89 57 10          	mov    %r10,0x10(%rdi)
  5b1043:	4c 89 57 18          	mov    %r10,0x18(%rdi)
  5b1047:	48 89 4f 20          	mov    %rcx,0x20(%rdi)
  5b104b:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  5b104f:	88 47 30             	mov    %al,0x30(%rdi)
  5b1052:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  5b1059:	e9 b5 3a 00 00       	jmp    5b4b13 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3f63>
  5b105e:	49 8b 8d 68 08 00 00 	mov    0x868(%r13),%rcx
  5b1065:	41 0f b6 95 5c 09 00 	movzbl 0x95c(%r13),%edx
  5b106c:	00 
  5b106d:	89 d6                	mov    %edx,%esi
  5b106f:	49 83 bd 80 08 00 00 	cmpq   $0x0,0x880(%r13)
  5b1076:	00 
  5b1077:	41 0f 95 c1          	setne  %r9b
  5b107b:	49 83 bd 60 07 00 00 	cmpq   $0xffffffffffffffff,0x760(%r13)
  5b1082:	ff 
  5b1083:	41 0f 95 c0          	setne  %r8b
  5b1087:	80 f2 01             	xor    $0x1,%dl
  5b108a:	44 08 c2             	or     %r8b,%dl
  5b108d:	44 20 ca             	and    %r9b,%dl
  5b1090:	0f b6 d2             	movzbl %dl,%edx
  5b1093:	4d 8b 85 48 09 00 00 	mov    0x948(%r13),%r8
  5b109a:	4c 89 57 18          	mov    %r10,0x18(%rdi)
  5b109e:	48 89 4f 20          	mov    %rcx,0x20(%rdi)
  5b10a2:	40 88 77 30          	mov    %sil,0x30(%rdi)
  5b10a6:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  5b10aa:	48 89 47 10          	mov    %rax,0x10(%rdi)
  5b10ae:	4c 89 47 28          	mov    %r8,0x28(%rdi)
  5b10b2:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  5b10b9:	e9 55 3a 00 00       	jmp    5b4b13 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3f63>
  5b10be:	66 0f 10 00          	movupd (%rax),%xmm0
  5b10c2:	66 0f 29 84 24 a0 09 	movapd %xmm0,0x9a0(%rsp)
  5b10c9:	00 00 
  5b10cb:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b10d2:	00 
  5b10d3:	48 8d 8c 24 a0 09 00 	lea    0x9a0(%rsp),%rcx
  5b10da:	00 
  5b10db:	48 8b b4 24 90 00 00 	mov    0x90(%rsp),%rsi
  5b10e2:	00 
  5b10e3:	ff 15 57 8e 53 00    	call   *0x538e57(%rip)        # ae9f40 <_DYNAMIC+0x390>
  5b10e9:	4c 8b b4 24 d0 04 00 	mov    0x4d0(%rsp),%r14
  5b10f0:	00 
  5b10f1:	44 8b a4 24 d8 04 00 	mov    0x4d8(%rsp),%r12d
  5b10f8:	00 
  5b10f9:	8b ac 24 dc 04 00 00 	mov    0x4dc(%rsp),%ebp
  5b1100:	49 83 fe 02          	cmp    $0x2,%r14
  5b1104:	75 12                	jne    5b1118 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x568>
  5b1106:	45 89 e5             	mov    %r12d,%r13d
  5b1109:	41 c1 ed 08          	shr    $0x8,%r13d
  5b110d:	41 bf 22 00 00 00    	mov    $0x22,%r15d
  5b1113:	e9 3c 38 00 00       	jmp    5b4954 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3da4>
  5b1118:	48 8d b4 24 e0 04 00 	lea    0x4e0(%rsp),%rsi
  5b111f:	00 
  5b1120:	48 8d bc 24 80 0e 00 	lea    0xe80(%rsp),%rdi
  5b1127:	00 
  5b1128:	ba 18 02 00 00       	mov    $0x218,%edx
  5b112d:	ff 15 1d 8d 53 00    	call   *0x538d1d(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5b1133:	4c 89 b4 24 58 0c 00 	mov    %r14,0xc58(%rsp)
  5b113a:	00 
  5b113b:	44 89 a4 24 60 0c 00 	mov    %r12d,0xc60(%rsp)
  5b1142:	00 
  5b1143:	89 ac 24 64 0c 00 00 	mov    %ebp,0xc64(%rsp)
  5b114a:	48 8d bc 24 68 0c 00 	lea    0xc68(%rsp),%rdi
  5b1151:	00 
  5b1152:	48 8d b4 24 80 0e 00 	lea    0xe80(%rsp),%rsi
  5b1159:	00 
  5b115a:	ba 18 02 00 00       	mov    $0x218,%edx
  5b115f:	ff 15 eb 8c 53 00    	call   *0x538ceb(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5b1165:	81 bc 24 90 00 00 00 	cmpl   $0xffff,0x90(%rsp)
  5b116c:	ff ff 00 00 
  5b1170:	77 0a                	ja     5b117c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x5cc>
  5b1172:	81 7c 24 54 ff ff 00 	cmpl   $0xffff,0x54(%rsp)
  5b1179:	00 
  5b117a:	76 1b                	jbe    5b1197 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x5e7>
  5b117c:	45 31 ed             	xor    %r13d,%r13d
  5b117f:	45 31 e4             	xor    %r12d,%r12d
  5b1182:	41 bf 22 00 00 00    	mov    $0x22,%r15d
  5b1188:	41 83 fe 02          	cmp    $0x2,%r14d
  5b118c:	0f 85 b5 37 00 00    	jne    5b4947 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3d97>
  5b1192:	e9 bd 37 00 00       	jmp    5b4954 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3da4>
  5b1197:	48 89 9c 24 88 00 00 	mov    %rbx,0x88(%rsp)
  5b119e:	00 
  5b119f:	48 8b 04 24          	mov    (%rsp),%rax
  5b11a3:	48 8d 88 98 08 00 00 	lea    0x898(%rax),%rcx
  5b11aa:	48 89 8c 24 90 01 00 	mov    %rcx,0x190(%rsp)
  5b11b1:	00 
  5b11b2:	48 8b 98 98 08 00 00 	mov    0x898(%rax),%rbx
  5b11b9:	48 85 db             	test   %rbx,%rbx
  5b11bc:	0f 84 da 0c 00 00    	je     5b1e9c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x12ec>
  5b11c2:	f0 48 ff 03          	lock incq (%rbx)
  5b11c6:	0f 8e c0 0d 00 00    	jle    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b11cc:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  5b11d3:	00 
  5b11d4:	48 8d 84 24 98 00 00 	lea    0x98(%rsp),%rax
  5b11db:	00 
  5b11dc:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  5b11e3:	00 
  5b11e4:	48 c7 84 24 28 01 00 	movq   $0x0,0x128(%rsp)
  5b11eb:	00 00 00 00 00 
  5b11f0:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b11f4:	48 8d 99 e8 02 00 00 	lea    0x2e8(%rcx),%rbx
  5b11fb:	80 b9 58 09 00 00 00 	cmpb   $0x0,0x958(%rcx)
  5b1202:	4c 89 bc 24 98 01 00 	mov    %r15,0x198(%rsp)
  5b1209:	00 
  5b120a:	48 89 5c 24 78       	mov    %rbx,0x78(%rsp)
  5b120f:	0f 85 a1 03 00 00    	jne    5b15b6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xa06>
  5b1215:	80 b9 59 09 00 00 00 	cmpb   $0x0,0x959(%rcx)
  5b121c:	0f 85 94 03 00 00    	jne    5b15b6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xa06>
  5b1222:	80 b9 28 07 00 00 00 	cmpb   $0x0,0x728(%rcx)
  5b1229:	0f 85 87 03 00 00    	jne    5b15b6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xa06>
  5b122f:	48 8b 81 18 08 00 00 	mov    0x818(%rcx),%rax
  5b1236:	48 8b 99 28 08 00 00 	mov    0x828(%rcx),%rbx
  5b123d:	48 85 c0             	test   %rax,%rax
  5b1240:	0f 95 c1             	setne  %cl
  5b1243:	48 85 db             	test   %rbx,%rbx
  5b1246:	0f 95 c2             	setne  %dl
  5b1249:	20 ca                	and    %cl,%dl
  5b124b:	80 fa 01             	cmp    $0x1,%dl
  5b124e:	0f 85 3a 07 00 00    	jne    5b198e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xdde>
  5b1254:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b1258:	4c 8d a1 48 08 00 00 	lea    0x848(%rcx),%r12
  5b125f:	4c 8b b1 20 08 00 00 	mov    0x820(%rcx),%r14
  5b1266:	45 31 ff             	xor    %r15d,%r15d
  5b1269:	48 8d 0d 20 7a 50 00 	lea    0x507a20(%rip),%rcx        # ab8c90 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x60>
  5b1270:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  5b1275:	48 8d 0d 2c 7a 50 00 	lea    0x507a2c(%rip),%rcx        # ab8ca8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x78>
  5b127c:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  5b1281:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  5b1287:	eb 1d                	jmp    5b12a6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x6f6>
  5b1289:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5b1290:	4c 89 e7             	mov    %r12,%rdi
  5b1293:	e8 a8 78 17 00       	call   728b40 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5b1298:	b8 00 00 00 00       	mov    $0x0,%eax
  5b129d:	48 85 db             	test   %rbx,%rbx
  5b12a0:	0f 84 e8 06 00 00    	je     5b198e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xdde>
  5b12a6:	4d 85 ff             	test   %r15,%r15
  5b12a9:	74 25                	je     5b12d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x720>
  5b12ab:	41 0f b7 8f 32 05 00 	movzwl 0x532(%r15),%ecx
  5b12b2:	00 
  5b12b3:	49 39 ce             	cmp    %rcx,%r14
  5b12b6:	0f 83 c4 00 00 00    	jae    5b1380 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x7d0>
  5b12bc:	4c 89 f9             	mov    %r15,%rcx
  5b12bf:	4c 89 f2             	mov    %r14,%rdx
  5b12c2:	e9 e0 00 00 00       	jmp    5b13a7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x7f7>
  5b12c7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5b12ce:	00 00 
  5b12d0:	4d 85 f6             	test   %r14,%r14
  5b12d3:	74 38                	je     5b130d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x75d>
  5b12d5:	4c 89 f1             	mov    %r14,%rcx
  5b12d8:	49 89 c7             	mov    %rax,%r15
  5b12db:	48 83 e1 07          	and    $0x7,%rcx
  5b12df:	74 31                	je     5b1312 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x762>
  5b12e1:	31 d2                	xor    %edx,%edx
  5b12e3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b12ea:	84 00 00 00 00 00 
  5b12f0:	4d 8b bf 38 05 00 00 	mov    0x538(%r15),%r15
  5b12f7:	48 ff c2             	inc    %rdx
  5b12fa:	48 39 d1             	cmp    %rdx,%rcx
  5b12fd:	75 f1                	jne    5b12f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x740>
  5b12ff:	4c 89 f0             	mov    %r14,%rax
  5b1302:	48 29 d0             	sub    %rdx,%rax
  5b1305:	49 83 fe 08          	cmp    $0x8,%r14
  5b1309:	73 15                	jae    5b1320 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x770>
  5b130b:	eb 51                	jmp    5b135e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x7ae>
  5b130d:	49 89 c7             	mov    %rax,%r15
  5b1310:	eb 4c                	jmp    5b135e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x7ae>
  5b1312:	4c 89 f0             	mov    %r14,%rax
  5b1315:	49 83 fe 08          	cmp    $0x8,%r14
  5b1319:	72 43                	jb     5b135e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x7ae>
  5b131b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5b1320:	49 8b 8f 38 05 00 00 	mov    0x538(%r15),%rcx
  5b1327:	48 8b 89 38 05 00 00 	mov    0x538(%rcx),%rcx
  5b132e:	48 8b 89 38 05 00 00 	mov    0x538(%rcx),%rcx
  5b1335:	48 8b 89 38 05 00 00 	mov    0x538(%rcx),%rcx
  5b133c:	48 8b 89 38 05 00 00 	mov    0x538(%rcx),%rcx
  5b1343:	48 8b 89 38 05 00 00 	mov    0x538(%rcx),%rcx
  5b134a:	48 8b 89 38 05 00 00 	mov    0x538(%rcx),%rcx
  5b1351:	4c 8b b9 38 05 00 00 	mov    0x538(%rcx),%r15
  5b1358:	48 83 c0 f8          	add    $0xfffffffffffffff8,%rax
  5b135c:	75 c2                	jne    5b1320 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x770>
  5b135e:	31 c0                	xor    %eax,%eax
  5b1360:	45 31 f6             	xor    %r14d,%r14d
  5b1363:	41 0f b7 8f 32 05 00 	movzwl 0x532(%r15),%ecx
  5b136a:	00 
  5b136b:	49 39 ce             	cmp    %rcx,%r14
  5b136e:	0f 82 48 ff ff ff    	jb     5b12bc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x70c>
  5b1374:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b137b:	00 00 00 00 00 
  5b1380:	49 8b 8f d0 04 00 00 	mov    0x4d0(%r15),%rcx
  5b1387:	48 85 c9             	test   %rcx,%rcx
  5b138a:	0f 84 d7 37 00 00    	je     5b4b67 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3fb7>
  5b1390:	48 ff c0             	inc    %rax
  5b1393:	41 0f b7 97 30 05 00 	movzwl 0x530(%r15),%edx
  5b139a:	00 
  5b139b:	49 89 cf             	mov    %rcx,%r15
  5b139e:	66 3b 91 32 05 00 00 	cmp    0x532(%rcx),%dx
  5b13a5:	73 d9                	jae    5b1380 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x7d0>
  5b13a7:	48 85 c0             	test   %rax,%rax
  5b13aa:	0f 84 a0 00 00 00    	je     5b1450 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x8a0>
  5b13b0:	48 8d 34 d1          	lea    (%rcx,%rdx,8),%rsi
  5b13b4:	48 81 c6 40 05 00 00 	add    $0x540,%rsi
  5b13bb:	48 89 c7             	mov    %rax,%rdi
  5b13be:	48 83 e7 07          	and    $0x7,%rdi
  5b13c2:	0f 84 dc 01 00 00    	je     5b15a4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x9f4>
  5b13c8:	45 31 c0             	xor    %r8d,%r8d
  5b13cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5b13d0:	4c 8b 3e             	mov    (%rsi),%r15
  5b13d3:	49 8d b7 38 05 00 00 	lea    0x538(%r15),%rsi
  5b13da:	49 ff c0             	inc    %r8
  5b13dd:	4c 39 c7             	cmp    %r8,%rdi
  5b13e0:	75 ee                	jne    5b13d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x820>
  5b13e2:	48 89 c7             	mov    %rax,%rdi
  5b13e5:	4c 29 c7             	sub    %r8,%rdi
  5b13e8:	48 83 f8 08          	cmp    $0x8,%rax
  5b13ec:	72 43                	jb     5b1431 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x881>
  5b13ee:	66 90                	xchg   %ax,%ax
  5b13f0:	48 8b 06             	mov    (%rsi),%rax
  5b13f3:	48 8b 80 38 05 00 00 	mov    0x538(%rax),%rax
  5b13fa:	48 8b 80 38 05 00 00 	mov    0x538(%rax),%rax
  5b1401:	48 8b 80 38 05 00 00 	mov    0x538(%rax),%rax
  5b1408:	48 8b 80 38 05 00 00 	mov    0x538(%rax),%rax
  5b140f:	48 8b 80 38 05 00 00 	mov    0x538(%rax),%rax
  5b1416:	48 8b 80 38 05 00 00 	mov    0x538(%rax),%rax
  5b141d:	4c 8b b8 38 05 00 00 	mov    0x538(%rax),%r15
  5b1424:	49 8d b7 38 05 00 00 	lea    0x538(%r15),%rsi
  5b142b:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  5b142f:	75 bf                	jne    5b13f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x840>
  5b1431:	45 31 f6             	xor    %r14d,%r14d
  5b1434:	48 8b 3c 24          	mov    (%rsp),%rdi
  5b1438:	48 8b 87 b0 07 00 00 	mov    0x7b0(%rdi),%rax
  5b143f:	48 85 c0             	test   %rax,%rax
  5b1442:	75 27                	jne    5b146b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x8bb>
  5b1444:	e9 73 38 00 00       	jmp    5b4cbc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x410c>
  5b1449:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5b1450:	4c 8d 72 01          	lea    0x1(%rdx),%r14
  5b1454:	49 89 cf             	mov    %rcx,%r15
  5b1457:	48 8b 3c 24          	mov    (%rsp),%rdi
  5b145b:	48 8b 87 b0 07 00 00 	mov    0x7b0(%rdi),%rax
  5b1462:	48 85 c0             	test   %rax,%rax
  5b1465:	0f 84 51 38 00 00    	je     5b4cbc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x410c>
  5b146b:	48 ff cb             	dec    %rbx
  5b146e:	48 6b f2 70          	imul   $0x70,%rdx,%rsi
  5b1472:	48 8b 97 b8 07 00 00 	mov    0x7b8(%rdi),%rdx
  5b1479:	48 8b 74 31 18       	mov    0x18(%rcx,%rsi,1),%rsi
  5b147e:	0f b7 b8 ba 00 00 00 	movzwl 0xba(%rax),%edi
  5b1485:	41 89 f8             	mov    %edi,%r8d
  5b1488:	41 c1 e0 03          	shl    $0x3,%r8d
  5b148c:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  5b1493:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b149a:	84 00 00 00 00 00 
  5b14a0:	4d 85 c0             	test   %r8,%r8
  5b14a3:	74 2b                	je     5b14d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x920>
  5b14a5:	48 3b 74 c8 10       	cmp    0x10(%rax,%rcx,8),%rsi
  5b14aa:	41 0f 97 c1          	seta   %r9b
  5b14ae:	41 80 d9 00          	sbb    $0x0,%r9b
  5b14b2:	48 ff c1             	inc    %rcx
  5b14b5:	49 83 c0 f8          	add    $0xfffffffffffffff8,%r8
  5b14b9:	41 80 f9 01          	cmp    $0x1,%r9b
  5b14bd:	74 e1                	je     5b14a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x8f0>
  5b14bf:	41 0f b6 f9          	movzbl %r9b,%edi
  5b14c3:	85 ff                	test   %edi,%edi
  5b14c5:	75 0c                	jne    5b14d3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x923>
  5b14c7:	eb 27                	jmp    5b14f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x940>
  5b14c9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5b14d0:	48 89 f9             	mov    %rdi,%rcx
  5b14d3:	48 83 ea 01          	sub    $0x1,%rdx
  5b14d7:	0f 82 df 37 00 00    	jb     5b4cbc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x410c>
  5b14dd:	48 8b 84 c8 c0 00 00 	mov    0xc0(%rax,%rcx,8),%rax
  5b14e4:	00 
  5b14e5:	eb 97                	jmp    5b147e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x8ce>
  5b14e7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5b14ee:	00 00 
  5b14f0:	48 8b 7c c8 60       	mov    0x60(%rax,%rcx,8),%rdi
  5b14f5:	48 8b 04 24          	mov    (%rsp),%rax
  5b14f9:	48 8b a8 c8 02 00 00 	mov    0x2c8(%rax),%rbp
  5b1500:	48 39 ef             	cmp    %rbp,%rdi
  5b1503:	0f 83 5c 38 00 00    	jae    5b4d65 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41b5>
  5b1509:	48 8b 88 c0 02 00 00 	mov    0x2c0(%rax),%rcx
  5b1510:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  5b1514:	8b 7c c1 18          	mov    0x18(%rcx,%rax,8),%edi
  5b1518:	4c 39 ef             	cmp    %r13,%rdi
  5b151b:	0f 84 77 fd ff ff    	je     5b1298 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x6e8>
  5b1521:	48 39 fd             	cmp    %rdi,%rbp
  5b1524:	0f 86 f0 37 00 00    	jbe    5b4d1a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x416a>
  5b152a:	49 8b 04 24          	mov    (%r12),%rax
  5b152e:	48 85 c0             	test   %rax,%rax
  5b1531:	0f 84 61 fd ff ff    	je     5b1298 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x6e8>
  5b1537:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  5b153b:	48 8b 0c d1          	mov    (%rcx,%rdx,8),%rcx
  5b153f:	48 8b 14 24          	mov    (%rsp),%rdx
  5b1543:	48 8b 92 50 08 00 00 	mov    0x850(%rdx),%rdx
  5b154a:	44 0f b7 40 62       	movzwl 0x62(%rax),%r8d
  5b154f:	45 89 c1             	mov    %r8d,%r9d
  5b1552:	41 c1 e1 03          	shl    $0x3,%r9d
  5b1556:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  5b155d:	0f 1f 00             	nopl   (%rax)
  5b1560:	4d 85 c9             	test   %r9,%r9
  5b1563:	74 2b                	je     5b1590 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x9e0>
  5b1565:	48 3b 4c f8 10       	cmp    0x10(%rax,%rdi,8),%rcx
  5b156a:	41 0f 97 c2          	seta   %r10b
  5b156e:	41 80 da 00          	sbb    $0x0,%r10b
  5b1572:	48 ff c7             	inc    %rdi
  5b1575:	49 83 c1 f8          	add    $0xfffffffffffffff8,%r9
  5b1579:	41 80 fa 01          	cmp    $0x1,%r10b
  5b157d:	74 e1                	je     5b1560 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x9b0>
  5b157f:	45 0f b6 c2          	movzbl %r10b,%r8d
  5b1583:	45 85 c0             	test   %r8d,%r8d
  5b1586:	0f 84 04 fd ff ff    	je     5b1290 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x6e0>
  5b158c:	eb 05                	jmp    5b1593 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x9e3>
  5b158e:	66 90                	xchg   %ax,%ax
  5b1590:	4c 89 c7             	mov    %r8,%rdi
  5b1593:	48 83 ea 01          	sub    $0x1,%rdx
  5b1597:	0f 82 fb fc ff ff    	jb     5b1298 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x6e8>
  5b159d:	48 8b 44 f8 68       	mov    0x68(%rax,%rdi,8),%rax
  5b15a2:	eb a6                	jmp    5b154a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x99a>
  5b15a4:	48 89 c7             	mov    %rax,%rdi
  5b15a7:	48 83 f8 08          	cmp    $0x8,%rax
  5b15ab:	0f 82 80 fe ff ff    	jb     5b1431 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x881>
  5b15b1:	e9 3a fe ff ff       	jmp    5b13f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x840>
  5b15b6:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b15bd:	00 
  5b15be:	ff 15 74 89 53 00    	call   *0x538974(%rip)        # ae9f38 <_DYNAMIC+0x388>
  5b15c4:	48 89 df             	mov    %rbx,%rdi
  5b15c7:	e8 04 58 f8 ff       	call   536dd0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs1rQ3kaVqKLB_20gpui_reactivity_core6layout10LayoutTreeECs6gaF1xUz9Bf_4gpui>
  5b15cc:	48 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%rsi
  5b15d3:	00 
  5b15d4:	ba 48 04 00 00       	mov    $0x448,%edx
  5b15d9:	48 89 df             	mov    %rbx,%rdi
  5b15dc:	ff 15 6e 88 53 00    	call   *0x53886e(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5b15e2:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b15e6:	48 c7 81 40 07 00 00 	movq   $0x0,0x740(%rcx)
  5b15ed:	00 00 00 00 
  5b15f1:	48 8b 81 c8 02 00 00 	mov    0x2c8(%rcx),%rax
  5b15f8:	48 85 c0             	test   %rax,%rax
  5b15fb:	0f 84 5d 0b 00 00    	je     5b215e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x15ae>
  5b1601:	48 8d 91 30 07 00 00 	lea    0x730(%rcx),%rdx
  5b1608:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  5b160d:	48 8b 99 c0 02 00 00 	mov    0x2c0(%rcx),%rbx
  5b1614:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  5b1618:	48 8d 04 c3          	lea    (%rbx,%rax,8),%rax
  5b161c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5b1621:	4c 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%r15
  5b1628:	00 
  5b1629:	48 8d 05 00 72 50 00 	lea    0x507200(%rip),%rax        # ab8830 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x90>
  5b1630:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  5b1635:	31 ed                	xor    %ebp,%ebp
  5b1637:	45 31 ed             	xor    %r13d,%r13d
  5b163a:	eb 40                	jmp    5b167c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xacc>
  5b163c:	0f 1f 40 00          	nopl   0x0(%rax)
  5b1640:	48 83 c3 28          	add    $0x28,%rbx
  5b1644:	49 ff c5             	inc    %r13
  5b1647:	48 8b 14 24          	mov    (%rsp),%rdx
  5b164b:	48 8b 82 38 07 00 00 	mov    0x738(%rdx),%rax
  5b1652:	48 89 e9             	mov    %rbp,%rcx
  5b1655:	48 c1 e1 04          	shl    $0x4,%rcx
  5b1659:	66 0f 28 84 24 60 04 	movapd 0x460(%rsp),%xmm0
  5b1660:	00 00 
  5b1662:	66 0f 11 04 08       	movupd %xmm0,(%rax,%rcx,1)
  5b1667:	48 ff c5             	inc    %rbp
  5b166a:	48 89 aa 40 07 00 00 	mov    %rbp,0x740(%rdx)
  5b1671:	48 3b 5c 24 30       	cmp    0x30(%rsp),%rbx
  5b1676:	0f 84 e4 0a 00 00    	je     5b2160 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x15b0>
  5b167c:	8b 7b 18             	mov    0x18(%rbx),%edi
  5b167f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  5b1684:	48 39 c7             	cmp    %rax,%rdi
  5b1687:	74 51                	je     5b16da <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xb2a>
  5b1689:	48 39 fd             	cmp    %rdi,%rbp
  5b168c:	0f 86 d3 36 00 00    	jbe    5b4d65 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41b5>
  5b1692:	48 8b 04 24          	mov    (%rsp),%rax
  5b1696:	48 8b 80 38 07 00 00 	mov    0x738(%rax),%rax
  5b169d:	48 89 f9             	mov    %rdi,%rcx
  5b16a0:	48 c1 e1 04          	shl    $0x4,%rcx
  5b16a4:	66 0f 10 04 08       	movupd (%rax,%rcx,1),%xmm0
  5b16a9:	48 8d 84 24 20 09 00 	lea    0x920(%rsp),%rax
  5b16b0:	00 
  5b16b1:	66 0f 11 00          	movupd %xmm0,(%rax)
  5b16b5:	b8 01 00 00 00       	mov    $0x1,%eax
  5b16ba:	48 89 84 24 18 09 00 	mov    %rax,0x918(%rsp)
  5b16c1:	00 
  5b16c2:	8b 4b 20             	mov    0x20(%rbx),%ecx
  5b16c5:	83 e1 07             	and    $0x7,%ecx
  5b16c8:	31 c0                	xor    %eax,%eax
  5b16ca:	48 8d 15 fb d1 ab ff 	lea    -0x542e05(%rip),%rdx        # 6e8cc <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x80c>
  5b16d1:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
  5b16d5:	48 01 d1             	add    %rdx,%rcx
  5b16d8:	ff e1                	jmp    *%rcx
  5b16da:	31 c0                	xor    %eax,%eax
  5b16dc:	48 89 84 24 18 09 00 	mov    %rax,0x918(%rsp)
  5b16e3:	00 
  5b16e4:	8b 4b 20             	mov    0x20(%rbx),%ecx
  5b16e7:	83 e1 07             	and    $0x7,%ecx
  5b16ea:	31 c0                	xor    %eax,%eax
  5b16ec:	48 8d 15 d9 d1 ab ff 	lea    -0x542e27(%rip),%rdx        # 6e8cc <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x80c>
  5b16f3:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
  5b16f7:	48 01 d1             	add    %rdx,%rcx
  5b16fa:	ff e1                	jmp    *%rcx
  5b16fc:	b0 01                	mov    $0x1,%al
  5b16fe:	eb 20                	jmp    5b1720 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xb70>
  5b1700:	b0 05                	mov    $0x5,%al
  5b1702:	eb 1c                	jmp    5b1720 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xb70>
  5b1704:	b0 06                	mov    $0x6,%al
  5b1706:	eb 18                	jmp    5b1720 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xb70>
  5b1708:	b0 02                	mov    $0x2,%al
  5b170a:	eb 14                	jmp    5b1720 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xb70>
  5b170c:	b0 04                	mov    $0x4,%al
  5b170e:	eb 10                	jmp    5b1720 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xb70>
  5b1710:	b0 03                	mov    $0x3,%al
  5b1712:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b1719:	1f 84 00 00 00 00 00 
  5b1720:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b1724:	48 8b 89 28 02 00 00 	mov    0x228(%rcx),%rcx
  5b172b:	48 8d 15 36 a3 ac ff 	lea    -0x535cca(%rip),%rdx        # 7ba68 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x8>
  5b1732:	48 85 c9             	test   %rcx,%rcx
  5b1735:	74 44                	je     5b177b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xbcb>
  5b1737:	83 f9 02             	cmp    $0x2,%ecx
  5b173a:	0f 85 91 00 00 00    	jne    5b17d1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xc21>
  5b1740:	48 8b 34 24          	mov    (%rsp),%rsi
  5b1744:	48 8b ae 48 02 00 00 	mov    0x248(%rsi),%rbp
  5b174b:	49 39 ed             	cmp    %rbp,%r13
  5b174e:	0f 83 f6 35 00 00    	jae    5b4d4a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x419a>
  5b1754:	48 8b ae 38 02 00 00 	mov    0x238(%rsi),%rbp
  5b175b:	48 8b 96 40 02 00 00 	mov    0x240(%rsi),%rdx
  5b1762:	42 0f b6 14 2a       	movzbl (%rdx,%r13,1),%edx
  5b1767:	48 39 d5             	cmp    %rdx,%rbp
  5b176a:	0f 86 e6 35 00 00    	jbe    5b4d56 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41a6>
  5b1770:	48 6b d2 58          	imul   $0x58,%rdx,%rdx
  5b1774:	48 03 96 30 02 00 00 	add    0x230(%rsi),%rdx
  5b177b:	83 ff ff             	cmp    $0xffffffff,%edi
  5b177e:	74 75                	je     5b17f5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xc45>
  5b1780:	48 8d 35 e1 a2 ac ff 	lea    -0x535d1f(%rip),%rsi        # 7ba68 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x8>
  5b1787:	48 85 c9             	test   %rcx,%rcx
  5b178a:	0f 84 9b 00 00 00    	je     5b182b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xc7b>
  5b1790:	83 f9 02             	cmp    $0x2,%ecx
  5b1793:	75 77                	jne    5b180c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xc5c>
  5b1795:	4c 8b 04 24          	mov    (%rsp),%r8
  5b1799:	49 8b a8 48 02 00 00 	mov    0x248(%r8),%rbp
  5b17a0:	48 39 fd             	cmp    %rdi,%rbp
  5b17a3:	0f 86 8c 35 00 00    	jbe    5b4d35 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4185>
  5b17a9:	49 8b a8 38 02 00 00 	mov    0x238(%r8),%rbp
  5b17b0:	49 8b 88 40 02 00 00 	mov    0x240(%r8),%rcx
  5b17b7:	0f b6 3c 39          	movzbl (%rcx,%rdi,1),%edi
  5b17bb:	48 39 fd             	cmp    %rdi,%rbp
  5b17be:	0f 86 95 35 00 00    	jbe    5b4d59 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41a9>
  5b17c4:	48 6b f7 58          	imul   $0x58,%rdi,%rsi
  5b17c8:	49 03 b0 30 02 00 00 	add    0x230(%r8),%rsi
  5b17cf:	eb 5a                	jmp    5b182b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xc7b>
  5b17d1:	48 8b 34 24          	mov    (%rsp),%rsi
  5b17d5:	48 8b ae 40 02 00 00 	mov    0x240(%rsi),%rbp
  5b17dc:	49 39 ed             	cmp    %rbp,%r13
  5b17df:	0f 83 59 35 00 00    	jae    5b4d3e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x418e>
  5b17e5:	49 6b d5 58          	imul   $0x58,%r13,%rdx
  5b17e9:	48 03 96 38 02 00 00 	add    0x238(%rsi),%rdx
  5b17f0:	83 ff ff             	cmp    $0xffffffff,%edi
  5b17f3:	75 8b                	jne    5b1780 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xbd0>
  5b17f5:	b1 02                	mov    $0x2,%cl
  5b17f7:	48 8b 3c 24          	mov    (%rsp),%rdi
  5b17fb:	4c 8b 87 30 08 00 00 	mov    0x830(%rdi),%r8
  5b1802:	4d 85 c0             	test   %r8,%r8
  5b1805:	75 38                	jne    5b183f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xc8f>
  5b1807:	e9 b0 00 00 00       	jmp    5b18bc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xd0c>
  5b180c:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b1810:	48 8b a9 40 02 00 00 	mov    0x240(%rcx),%rbp
  5b1817:	48 39 fd             	cmp    %rdi,%rbp
  5b181a:	0f 86 0c 35 00 00    	jbe    5b4d2c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x417c>
  5b1820:	48 6b f7 58          	imul   $0x58,%rdi,%rsi
  5b1824:	48 03 b1 38 02 00 00 	add    0x238(%rcx),%rsi
  5b182b:	0f b6 4e 54          	movzbl 0x54(%rsi),%ecx
  5b182f:	48 8b 3c 24          	mov    (%rsp),%rdi
  5b1833:	4c 8b 87 30 08 00 00 	mov    0x830(%rdi),%r8
  5b183a:	4d 85 c0             	test   %r8,%r8
  5b183d:	74 7d                	je     5b18bc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xd0c>
  5b183f:	48 8b 33             	mov    (%rbx),%rsi
  5b1842:	48 8b bf 38 08 00 00 	mov    0x838(%rdi),%rdi
  5b1849:	45 0f b7 90 c2 01 00 	movzwl 0x1c2(%r8),%r10d
  5b1850:	00 
  5b1851:	45 89 d6             	mov    %r10d,%r14d
  5b1854:	41 c1 e6 05          	shl    $0x5,%r14d
  5b1858:	49 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%r9
  5b185f:	45 31 db             	xor    %r11d,%r11d
  5b1862:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b1869:	1f 84 00 00 00 00 00 
  5b1870:	4d 89 f4             	mov    %r14,%r12
  5b1873:	4d 01 dc             	add    %r11,%r12
  5b1876:	74 28                	je     5b18a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xcf0>
  5b1878:	4b 3b b4 c8 70 01 00 	cmp    0x170(%r8,%r9,8),%rsi
  5b187f:	00 
  5b1880:	40 0f 97 c5          	seta   %bpl
  5b1884:	40 80 dd 00          	sbb    $0x0,%bpl
  5b1888:	49 83 c3 e0          	add    $0xffffffffffffffe0,%r11
  5b188c:	49 ff c1             	inc    %r9
  5b188f:	40 80 fd 01          	cmp    $0x1,%bpl
  5b1893:	74 db                	je     5b1870 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xcc0>
  5b1895:	44 0f b6 d5          	movzbl %bpl,%r10d
  5b1899:	45 85 d2             	test   %r10d,%r10d
  5b189c:	75 05                	jne    5b18a3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xcf3>
  5b189e:	eb 13                	jmp    5b18b3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xd03>
  5b18a0:	4d 89 d1             	mov    %r10,%r9
  5b18a3:	48 83 ef 01          	sub    $0x1,%rdi
  5b18a7:	72 13                	jb     5b18bc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xd0c>
  5b18a9:	4f 8b 84 c8 c8 01 00 	mov    0x1c8(%r8,%r9,8),%r8
  5b18b0:	00 
  5b18b1:	eb 96                	jmp    5b1849 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xc99>
  5b18b3:	4d 29 d8             	sub    %r11,%r8
  5b18b6:	49 83 c0 e0          	add    $0xffffffffffffffe0,%r8
  5b18ba:	eb 03                	jmp    5b18bf <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xd0f>
  5b18bc:	45 31 c0             	xor    %r8d,%r8d
  5b18bf:	0f b6 f0             	movzbl %al,%esi
  5b18c2:	0f b6 c9             	movzbl %cl,%ecx
  5b18c5:	4c 89 ff             	mov    %r15,%rdi
  5b18c8:	e8 73 e2 21 00       	call   7cfb40 <_RNvNtNtCs6gaF1xUz9Bf_4gpui7runtime4list9row_style>
  5b18cd:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b18d4:	00 
  5b18d5:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  5b18da:	48 8d 94 24 18 09 00 	lea    0x918(%rsp),%rdx
  5b18e1:	00 
  5b18e2:	31 c9                	xor    %ecx,%ecx
  5b18e4:	4d 89 f8             	mov    %r15,%r8
  5b18e7:	ff 15 63 86 53 00    	call   *0x538663(%rip)        # ae9f50 <_DYNAMIC+0x3a0>
  5b18ed:	80 bc 24 a0 09 00 00 	cmpb   $0x0,0x9a0(%rsp)
  5b18f4:	00 
  5b18f5:	0f 85 74 10 00 00    	jne    5b296f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1dbf>
  5b18fb:	48 8d 84 24 a8 09 00 	lea    0x9a8(%rsp),%rax
  5b1902:	00 
  5b1903:	0f 10 00             	movups (%rax),%xmm0
  5b1906:	48 8d 84 24 76 04 00 	lea    0x476(%rsp),%rax
  5b190d:	00 
  5b190e:	0f 11 00             	movups %xmm0,(%rax)
  5b1911:	66 0f 10 00          	movupd (%rax),%xmm0
  5b1915:	66 0f 29 84 24 60 04 	movapd %xmm0,0x460(%rsp)
  5b191c:	00 00 
  5b191e:	8b 43 20             	mov    0x20(%rbx),%eax
  5b1921:	89 c1                	mov    %eax,%ecx
  5b1923:	83 e1 07             	and    $0x7,%ecx
  5b1926:	83 f9 06             	cmp    $0x6,%ecx
  5b1929:	73 07                	jae    5b1932 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xd82>
  5b192b:	83 f8 07             	cmp    $0x7,%eax
  5b192e:	77 08                	ja     5b1938 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xd88>
  5b1930:	eb 35                	jmp    5b1967 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xdb7>
  5b1932:	0f 85 ed 31 00 00    	jne    5b4b25 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3f75>
  5b1938:	66 0f 28 84 24 60 04 	movapd 0x460(%rsp),%xmm0
  5b193f:	00 00 
  5b1941:	66 0f 29 84 24 d0 04 	movapd %xmm0,0x4d0(%rsp)
  5b1948:	00 00 
  5b194a:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
  5b194f:	4c 89 fe             	mov    %r15,%rsi
  5b1952:	48 8d 15 b7 c4 0a 00 	lea    0xac4b7(%rip),%rdx        # 65de10 <_RNvNtCs6gaF1xUz9Bf_4gpui7runtime14measure_marker>
  5b1959:	ff 15 f9 85 53 00    	call   *0x5385f9(%rip)        # ae9f58 <_DYNAMIC+0x3a8>
  5b195f:	a8 01                	test   $0x1,%al
  5b1961:	0f 85 80 0c 00 00    	jne    5b25e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1a37>
  5b1967:	48 8b 04 24          	mov    (%rsp),%rax
  5b196b:	48 8b a8 40 07 00 00 	mov    0x740(%rax),%rbp
  5b1972:	48 3b a8 30 07 00 00 	cmp    0x730(%rax),%rbp
  5b1979:	0f 85 c1 fc ff ff    	jne    5b1640 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xa90>
  5b197f:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  5b1984:	e8 47 ba 21 00       	call   7cd3d0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecAINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdEj2_E8grow_oneB1s_>
  5b1989:	e9 b2 fc ff ff       	jmp    5b1640 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xa90>
  5b198e:	48 8b 04 24          	mov    (%rsp),%rax
  5b1992:	48 8b 90 48 08 00 00 	mov    0x848(%rax),%rdx
  5b1999:	4c 8b a8 58 08 00 00 	mov    0x858(%rax),%r13
  5b19a0:	48 85 d2             	test   %rdx,%rdx
  5b19a3:	0f 95 c0             	setne  %al
  5b19a6:	4d 85 ed             	test   %r13,%r13
  5b19a9:	0f 95 c1             	setne  %cl
  5b19ac:	20 c1                	and    %al,%cl
  5b19ae:	80 f9 01             	cmp    $0x1,%cl
  5b19b1:	0f 85 c1 06 00 00    	jne    5b2078 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x14c8>
  5b19b7:	48 8b 04 24          	mov    (%rsp),%rax
  5b19bb:	48 8b b0 50 08 00 00 	mov    0x850(%rax),%rsi
  5b19c2:	45 31 ff             	xor    %r15d,%r15d
  5b19c5:	48 8d 05 7c 72 50 00 	lea    0x50727c(%rip),%rax        # ab8c48 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x18>
  5b19cc:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b19d1:	48 8d 05 88 72 50 00 	lea    0x507288(%rip),%rax        # ab8c60 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x30>
  5b19d8:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  5b19dd:	4c 8d 35 84 a0 ac ff 	lea    -0x535f7c(%rip),%r14        # 7ba68 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x8>
  5b19e4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b19eb:	00 00 00 00 00 
  5b19f0:	4d 85 ff             	test   %r15,%r15
  5b19f3:	74 19                	je     5b1a0e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xe5e>
  5b19f5:	41 0f b7 47 62       	movzwl 0x62(%r15),%eax
  5b19fa:	48 39 c6             	cmp    %rax,%rsi
  5b19fd:	0f 83 9d 00 00 00    	jae    5b1aa0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xef0>
  5b1a03:	4c 89 f8             	mov    %r15,%rax
  5b1a06:	48 89 f1             	mov    %rsi,%rcx
  5b1a09:	e9 af 00 00 00       	jmp    5b1abd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xf0d>
  5b1a0e:	48 85 f6             	test   %rsi,%rsi
  5b1a11:	74 37                	je     5b1a4a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xe9a>
  5b1a13:	48 89 f0             	mov    %rsi,%rax
  5b1a16:	49 89 d7             	mov    %rdx,%r15
  5b1a19:	48 83 e0 07          	and    $0x7,%rax
  5b1a1d:	74 30                	je     5b1a4f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xe9f>
  5b1a1f:	31 c9                	xor    %ecx,%ecx
  5b1a21:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b1a28:	0f 1f 84 00 00 00 00 
  5b1a2f:	00 
  5b1a30:	4d 8b 7f 68          	mov    0x68(%r15),%r15
  5b1a34:	48 ff c1             	inc    %rcx
  5b1a37:	48 39 c8             	cmp    %rcx,%rax
  5b1a3a:	75 f4                	jne    5b1a30 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xe80>
  5b1a3c:	48 89 f0             	mov    %rsi,%rax
  5b1a3f:	48 29 c8             	sub    %rcx,%rax
  5b1a42:	48 83 fe 08          	cmp    $0x8,%rsi
  5b1a46:	73 18                	jae    5b1a60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xeb0>
  5b1a48:	eb 3c                	jmp    5b1a86 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xed6>
  5b1a4a:	49 89 d7             	mov    %rdx,%r15
  5b1a4d:	eb 37                	jmp    5b1a86 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xed6>
  5b1a4f:	48 89 f0             	mov    %rsi,%rax
  5b1a52:	48 83 fe 08          	cmp    $0x8,%rsi
  5b1a56:	72 2e                	jb     5b1a86 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xed6>
  5b1a58:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5b1a5f:	00 
  5b1a60:	49 8b 4f 68          	mov    0x68(%r15),%rcx
  5b1a64:	48 8b 49 68          	mov    0x68(%rcx),%rcx
  5b1a68:	48 8b 49 68          	mov    0x68(%rcx),%rcx
  5b1a6c:	48 8b 49 68          	mov    0x68(%rcx),%rcx
  5b1a70:	48 8b 49 68          	mov    0x68(%rcx),%rcx
  5b1a74:	48 8b 49 68          	mov    0x68(%rcx),%rcx
  5b1a78:	48 8b 49 68          	mov    0x68(%rcx),%rcx
  5b1a7c:	4c 8b 79 68          	mov    0x68(%rcx),%r15
  5b1a80:	48 83 c0 f8          	add    $0xfffffffffffffff8,%rax
  5b1a84:	75 da                	jne    5b1a60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xeb0>
  5b1a86:	31 d2                	xor    %edx,%edx
  5b1a88:	31 f6                	xor    %esi,%esi
  5b1a8a:	41 0f b7 47 62       	movzwl 0x62(%r15),%eax
  5b1a8f:	48 39 c6             	cmp    %rax,%rsi
  5b1a92:	0f 82 6b ff ff ff    	jb     5b1a03 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xe53>
  5b1a98:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5b1a9f:	00 
  5b1aa0:	49 8b 07             	mov    (%r15),%rax
  5b1aa3:	48 85 c0             	test   %rax,%rax
  5b1aa6:	0f 84 dd 31 00 00    	je     5b4c89 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x40d9>
  5b1aac:	48 ff c2             	inc    %rdx
  5b1aaf:	41 0f b7 4f 60       	movzwl 0x60(%r15),%ecx
  5b1ab4:	49 89 c7             	mov    %rax,%r15
  5b1ab7:	66 3b 48 62          	cmp    0x62(%rax),%cx
  5b1abb:	73 e3                	jae    5b1aa0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xef0>
  5b1abd:	48 85 d2             	test   %rdx,%rdx
  5b1ac0:	0f 84 7b 00 00 00    	je     5b1b41 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xf91>
  5b1ac6:	48 8d 34 c8          	lea    (%rax,%rcx,8),%rsi
  5b1aca:	48 83 c6 70          	add    $0x70,%rsi
  5b1ace:	48 89 d7             	mov    %rdx,%rdi
  5b1ad1:	48 83 e7 07          	and    $0x7,%rdi
  5b1ad5:	0f 84 71 01 00 00    	je     5b1c4c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x109c>
  5b1adb:	45 31 c0             	xor    %r8d,%r8d
  5b1ade:	66 90                	xchg   %ax,%ax
  5b1ae0:	4c 8b 3e             	mov    (%rsi),%r15
  5b1ae3:	49 8d 77 68          	lea    0x68(%r15),%rsi
  5b1ae7:	49 ff c0             	inc    %r8
  5b1aea:	4c 39 c7             	cmp    %r8,%rdi
  5b1aed:	75 f1                	jne    5b1ae0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xf30>
  5b1aef:	48 89 d7             	mov    %rdx,%rdi
  5b1af2:	4c 29 c7             	sub    %r8,%rdi
  5b1af5:	48 83 fa 08          	cmp    $0x8,%rdx
  5b1af9:	72 2e                	jb     5b1b29 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xf79>
  5b1afb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5b1b00:	48 8b 16             	mov    (%rsi),%rdx
  5b1b03:	48 8b 52 68          	mov    0x68(%rdx),%rdx
  5b1b07:	48 8b 52 68          	mov    0x68(%rdx),%rdx
  5b1b0b:	48 8b 52 68          	mov    0x68(%rdx),%rdx
  5b1b0f:	48 8b 52 68          	mov    0x68(%rdx),%rdx
  5b1b13:	48 8b 52 68          	mov    0x68(%rdx),%rdx
  5b1b17:	48 8b 52 68          	mov    0x68(%rdx),%rdx
  5b1b1b:	4c 8b 7a 68          	mov    0x68(%rdx),%r15
  5b1b1f:	49 8d 77 68          	lea    0x68(%r15),%rsi
  5b1b23:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  5b1b27:	75 d7                	jne    5b1b00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xf50>
  5b1b29:	45 31 e4             	xor    %r12d,%r12d
  5b1b2c:	48 8b 34 24          	mov    (%rsp),%rsi
  5b1b30:	48 8b 96 b0 07 00 00 	mov    0x7b0(%rsi),%rdx
  5b1b37:	48 85 d2             	test   %rdx,%rdx
  5b1b3a:	75 20                	jne    5b1b5c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xfac>
  5b1b3c:	e9 7b 31 00 00       	jmp    5b4cbc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x410c>
  5b1b41:	4c 8d 61 01          	lea    0x1(%rcx),%r12
  5b1b45:	49 89 c7             	mov    %rax,%r15
  5b1b48:	48 8b 34 24          	mov    (%rsp),%rsi
  5b1b4c:	48 8b 96 b0 07 00 00 	mov    0x7b0(%rsi),%rdx
  5b1b53:	48 85 d2             	test   %rdx,%rdx
  5b1b56:	0f 84 60 31 00 00    	je     5b4cbc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x410c>
  5b1b5c:	49 ff cd             	dec    %r13
  5b1b5f:	48 8b b6 b8 07 00 00 	mov    0x7b8(%rsi),%rsi
  5b1b66:	48 8b 7c c8 08       	mov    0x8(%rax,%rcx,8),%rdi
  5b1b6b:	44 0f b7 8a ba 00 00 	movzwl 0xba(%rdx),%r9d
  5b1b72:	00 
  5b1b73:	45 89 ca             	mov    %r9d,%r10d
  5b1b76:	41 c1 e2 03          	shl    $0x3,%r10d
  5b1b7a:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  5b1b81:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b1b88:	0f 1f 84 00 00 00 00 
  5b1b8f:	00 
  5b1b90:	4d 85 d2             	test   %r10,%r10
  5b1b93:	74 2b                	je     5b1bc0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1010>
  5b1b95:	4a 3b 7c c2 10       	cmp    0x10(%rdx,%r8,8),%rdi
  5b1b9a:	41 0f 97 c3          	seta   %r11b
  5b1b9e:	41 80 db 00          	sbb    $0x0,%r11b
  5b1ba2:	49 ff c0             	inc    %r8
  5b1ba5:	49 83 c2 f8          	add    $0xfffffffffffffff8,%r10
  5b1ba9:	41 80 fb 01          	cmp    $0x1,%r11b
  5b1bad:	74 e1                	je     5b1b90 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xfe0>
  5b1baf:	45 0f b6 cb          	movzbl %r11b,%r9d
  5b1bb3:	45 85 c9             	test   %r9d,%r9d
  5b1bb6:	75 0b                	jne    5b1bc3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1013>
  5b1bb8:	eb 26                	jmp    5b1be0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1030>
  5b1bba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5b1bc0:	4d 89 c8             	mov    %r9,%r8
  5b1bc3:	48 83 ee 01          	sub    $0x1,%rsi
  5b1bc7:	0f 82 ef 30 00 00    	jb     5b4cbc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x410c>
  5b1bcd:	4a 8b 94 c2 c0 00 00 	mov    0xc0(%rdx,%r8,8),%rdx
  5b1bd4:	00 
  5b1bd5:	eb 94                	jmp    5b1b6b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xfbb>
  5b1bd7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5b1bde:	00 00 
  5b1be0:	4a 8b 7c c2 60       	mov    0x60(%rdx,%r8,8),%rdi
  5b1be5:	4c 8b 04 24          	mov    (%rsp),%r8
  5b1be9:	49 8b a8 40 07 00 00 	mov    0x740(%r8),%rbp
  5b1bf0:	48 39 ef             	cmp    %rbp,%rdi
  5b1bf3:	0f 83 6c 31 00 00    	jae    5b4d65 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41b5>
  5b1bf9:	49 8b 90 38 07 00 00 	mov    0x738(%r8),%rdx
  5b1c00:	48 89 fe             	mov    %rdi,%rsi
  5b1c03:	48 c1 e6 04          	shl    $0x4,%rsi
  5b1c07:	66 0f 10 04 32       	movupd (%rdx,%rsi,1),%xmm0
  5b1c0c:	66 0f 29 84 24 70 04 	movapd %xmm0,0x470(%rsp)
  5b1c13:	00 00 
  5b1c15:	49 8b a8 c8 02 00 00 	mov    0x2c8(%r8),%rbp
  5b1c1c:	48 39 ef             	cmp    %rbp,%rdi
  5b1c1f:	0f 83 fe 30 00 00    	jae    5b4d23 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4173>
  5b1c25:	4d 8b 80 c0 02 00 00 	mov    0x2c0(%r8),%r8
  5b1c2c:	4c 8d 0c bf          	lea    (%rdi,%rdi,4),%r9
  5b1c30:	43 8b 54 c8 20       	mov    0x20(%r8,%r9,8),%edx
  5b1c35:	83 e2 07             	and    $0x7,%edx
  5b1c38:	48 8d 35 6d cc ab ff 	lea    -0x543393(%rip),%rsi        # 6e8ac <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x7ec>
  5b1c3f:	48 63 14 96          	movslq (%rsi,%rdx,4),%rdx
  5b1c43:	48 01 f2             	add    %rsi,%rdx
  5b1c46:	ff e2                	jmp    *%rdx
  5b1c48:	31 f6                	xor    %esi,%esi
  5b1c4a:	eb 34                	jmp    5b1c80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x10d0>
  5b1c4c:	48 89 d7             	mov    %rdx,%rdi
  5b1c4f:	48 83 fa 08          	cmp    $0x8,%rdx
  5b1c53:	0f 83 a7 fe ff ff    	jae    5b1b00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xf50>
  5b1c59:	e9 cb fe ff ff       	jmp    5b1b29 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xf79>
  5b1c5e:	40 b6 05             	mov    $0x5,%sil
  5b1c61:	eb 1d                	jmp    5b1c80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x10d0>
  5b1c63:	40 b6 06             	mov    $0x6,%sil
  5b1c66:	eb 18                	jmp    5b1c80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x10d0>
  5b1c68:	40 b6 02             	mov    $0x2,%sil
  5b1c6b:	eb 13                	jmp    5b1c80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x10d0>
  5b1c6d:	40 b6 01             	mov    $0x1,%sil
  5b1c70:	eb 0e                	jmp    5b1c80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x10d0>
  5b1c72:	40 b6 04             	mov    $0x4,%sil
  5b1c75:	eb 09                	jmp    5b1c80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x10d0>
  5b1c77:	40 b6 03             	mov    $0x3,%sil
  5b1c7a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5b1c80:	48 8b 14 24          	mov    (%rsp),%rdx
  5b1c84:	4c 8b 92 28 02 00 00 	mov    0x228(%rdx),%r10
  5b1c8b:	4c 89 f2             	mov    %r14,%rdx
  5b1c8e:	4d 85 d2             	test   %r10,%r10
  5b1c91:	74 61                	je     5b1cf4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1144>
  5b1c93:	41 83 fa 02          	cmp    $0x2,%r10d
  5b1c97:	75 3c                	jne    5b1cd5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1125>
  5b1c99:	4c 8b 1c 24          	mov    (%rsp),%r11
  5b1c9d:	49 8b ab 48 02 00 00 	mov    0x248(%r11),%rbp
  5b1ca4:	48 39 ef             	cmp    %rbp,%rdi
  5b1ca7:	0f 83 88 30 00 00    	jae    5b4d35 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4185>
  5b1cad:	49 8b ab 38 02 00 00 	mov    0x238(%r11),%rbp
  5b1cb4:	49 8b 93 40 02 00 00 	mov    0x240(%r11),%rdx
  5b1cbb:	0f b6 3c 3a          	movzbl (%rdx,%rdi,1),%edi
  5b1cbf:	48 39 fd             	cmp    %rdi,%rbp
  5b1cc2:	0f 86 91 30 00 00    	jbe    5b4d59 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41a9>
  5b1cc8:	48 6b d7 58          	imul   $0x58,%rdi,%rdx
  5b1ccc:	49 03 93 30 02 00 00 	add    0x230(%r11),%rdx
  5b1cd3:	eb 1f                	jmp    5b1cf4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1144>
  5b1cd5:	4c 8b 1c 24          	mov    (%rsp),%r11
  5b1cd9:	49 8b ab 40 02 00 00 	mov    0x240(%r11),%rbp
  5b1ce0:	48 39 ef             	cmp    %rbp,%rdi
  5b1ce3:	0f 83 43 30 00 00    	jae    5b4d2c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x417c>
  5b1ce9:	48 6b d7 58          	imul   $0x58,%rdi,%rdx
  5b1ced:	49 03 93 38 02 00 00 	add    0x238(%r11),%rdx
  5b1cf4:	4b 8d 3c c8          	lea    (%r8,%r9,8),%rdi
  5b1cf8:	8b 7f 18             	mov    0x18(%rdi),%edi
  5b1cfb:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
  5b1d01:	4c 39 c7             	cmp    %r8,%rdi
  5b1d04:	74 4b                	je     5b1d51 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x11a1>
  5b1d06:	4d 89 f0             	mov    %r14,%r8
  5b1d09:	4d 85 d2             	test   %r10,%r10
  5b1d0c:	74 67                	je     5b1d75 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x11c5>
  5b1d0e:	41 83 fa 02          	cmp    $0x2,%r10d
  5b1d12:	75 42                	jne    5b1d56 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x11a6>
  5b1d14:	4c 8b 0c 24          	mov    (%rsp),%r9
  5b1d18:	49 8b a9 48 02 00 00 	mov    0x248(%r9),%rbp
  5b1d1f:	48 39 fd             	cmp    %rdi,%rbp
  5b1d22:	0f 86 0d 30 00 00    	jbe    5b4d35 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4185>
  5b1d28:	49 8b a9 38 02 00 00 	mov    0x238(%r9),%rbp
  5b1d2f:	4d 8b 81 40 02 00 00 	mov    0x240(%r9),%r8
  5b1d36:	41 0f b6 3c 38       	movzbl (%r8,%rdi,1),%edi
  5b1d3b:	48 39 fd             	cmp    %rdi,%rbp
  5b1d3e:	0f 86 15 30 00 00    	jbe    5b4d59 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41a9>
  5b1d44:	4c 6b c7 58          	imul   $0x58,%rdi,%r8
  5b1d48:	4d 03 81 30 02 00 00 	add    0x230(%r9),%r8
  5b1d4f:	eb 24                	jmp    5b1d75 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x11c5>
  5b1d51:	40 b7 02             	mov    $0x2,%dil
  5b1d54:	eb 24                	jmp    5b1d7a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x11ca>
  5b1d56:	4c 8b 0c 24          	mov    (%rsp),%r9
  5b1d5a:	49 8b a9 40 02 00 00 	mov    0x240(%r9),%rbp
  5b1d61:	48 39 fd             	cmp    %rdi,%rbp
  5b1d64:	0f 86 c2 2f 00 00    	jbe    5b4d2c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x417c>
  5b1d6a:	4c 6b c7 58          	imul   $0x58,%rdi,%r8
  5b1d6e:	4d 03 81 38 02 00 00 	add    0x238(%r9),%r8
  5b1d75:	41 0f b6 78 54       	movzbl 0x54(%r8),%edi
  5b1d7a:	4c 8b 0c 24          	mov    (%rsp),%r9
  5b1d7e:	4d 8b 81 30 08 00 00 	mov    0x830(%r9),%r8
  5b1d85:	4d 85 c0             	test   %r8,%r8
  5b1d88:	4c 89 64 24 30       	mov    %r12,0x30(%rsp)
  5b1d8d:	0f 84 80 00 00 00    	je     5b1e13 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1263>
  5b1d93:	4c 89 f3             	mov    %r14,%rbx
  5b1d96:	4d 8b 89 38 08 00 00 	mov    0x838(%r9),%r9
  5b1d9d:	48 8b 44 c8 08       	mov    0x8(%rax,%rcx,8),%rax
  5b1da2:	45 0f b7 90 c2 01 00 	movzwl 0x1c2(%r8),%r10d
  5b1da9:	00 
  5b1daa:	45 89 d6             	mov    %r10d,%r14d
  5b1dad:	41 c1 e6 05          	shl    $0x5,%r14d
  5b1db1:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  5b1db8:	45 31 db             	xor    %r11d,%r11d
  5b1dbb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5b1dc0:	4d 89 f4             	mov    %r14,%r12
  5b1dc3:	4d 01 dc             	add    %r11,%r12
  5b1dc6:	74 28                	je     5b1df0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1240>
  5b1dc8:	49 3b 84 c8 70 01 00 	cmp    0x170(%r8,%rcx,8),%rax
  5b1dcf:	00 
  5b1dd0:	40 0f 97 c5          	seta   %bpl
  5b1dd4:	40 80 dd 00          	sbb    $0x0,%bpl
  5b1dd8:	49 83 c3 e0          	add    $0xffffffffffffffe0,%r11
  5b1ddc:	48 ff c1             	inc    %rcx
  5b1ddf:	40 80 fd 01          	cmp    $0x1,%bpl
  5b1de3:	74 db                	je     5b1dc0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1210>
  5b1de5:	44 0f b6 d5          	movzbl %bpl,%r10d
  5b1de9:	45 85 d2             	test   %r10d,%r10d
  5b1dec:	75 05                	jne    5b1df3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1243>
  5b1dee:	eb 17                	jmp    5b1e07 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1257>
  5b1df0:	4c 89 d1             	mov    %r10,%rcx
  5b1df3:	49 83 e9 01          	sub    $0x1,%r9
  5b1df7:	0f 82 97 00 00 00    	jb     5b1e94 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x12e4>
  5b1dfd:	4d 8b 84 c8 c8 01 00 	mov    0x1c8(%r8,%rcx,8),%r8
  5b1e04:	00 
  5b1e05:	eb 9b                	jmp    5b1da2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x11f2>
  5b1e07:	4d 29 d8             	sub    %r11,%r8
  5b1e0a:	49 83 c0 e0          	add    $0xffffffffffffffe0,%r8
  5b1e0e:	49 89 de             	mov    %rbx,%r14
  5b1e11:	eb 03                	jmp    5b1e16 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1266>
  5b1e13:	45 31 c0             	xor    %r8d,%r8d
  5b1e16:	40 0f b6 f6          	movzbl %sil,%esi
  5b1e1a:	40 0f b6 cf          	movzbl %dil,%ecx
  5b1e1e:	48 8d 9c 24 d0 04 00 	lea    0x4d0(%rsp),%rbx
  5b1e25:	00 
  5b1e26:	48 89 df             	mov    %rbx,%rdi
  5b1e29:	e8 12 dd 21 00       	call   7cfb40 <_RNvNtNtCs6gaF1xUz9Bf_4gpui7runtime4list9row_style>
  5b1e2e:	66 0f 28 84 24 70 04 	movapd 0x470(%rsp),%xmm0
  5b1e35:	00 00 
  5b1e37:	66 0f 29 84 24 a0 09 	movapd %xmm0,0x9a0(%rsp)
  5b1e3e:	00 00 
  5b1e40:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
  5b1e45:	48 8d b4 24 a0 09 00 	lea    0x9a0(%rsp),%rsi
  5b1e4c:	00 
  5b1e4d:	48 89 da             	mov    %rbx,%rdx
  5b1e50:	ff 15 0a 81 53 00    	call   *0x53810a(%rip)        # ae9f60 <_DYNAMIC+0x3b0>
  5b1e56:	a8 01                	test   $0x1,%al
  5b1e58:	0f 85 89 07 00 00    	jne    5b25e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1a37>
  5b1e5e:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
  5b1e63:	48 8d b4 24 70 04 00 	lea    0x470(%rsp),%rsi
  5b1e6a:	00 
  5b1e6b:	ff 15 f7 80 53 00    	call   *0x5380f7(%rip)        # ae9f68 <_DYNAMIC+0x3b8>
  5b1e71:	41 89 c4             	mov    %eax,%r12d
  5b1e74:	3c ff                	cmp    $0xff,%al
  5b1e76:	0f 85 fc 0a 00 00    	jne    5b2978 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1dc8>
  5b1e7c:	ba 00 00 00 00       	mov    $0x0,%edx
  5b1e81:	4d 85 ed             	test   %r13,%r13
  5b1e84:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  5b1e89:	0f 85 61 fb ff ff    	jne    5b19f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0xe40>
  5b1e8f:	e9 e4 01 00 00       	jmp    5b2078 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x14c8>
  5b1e94:	45 31 c0             	xor    %r8d,%r8d
  5b1e97:	e9 72 ff ff ff       	jmp    5b1e0e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x125e>
  5b1e9c:	48 8b 04 24          	mov    (%rsp),%rax
  5b1ea0:	48 83 b8 e0 02 00 00 	cmpq   $0x0,0x2e0(%rax)
  5b1ea7:	00 
  5b1ea8:	0f 84 41 07 00 00    	je     5b25ef <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1a3f>
  5b1eae:	41 b6 01             	mov    $0x1,%r14b
  5b1eb1:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b1eb8:	00 
  5b1eb9:	ff 15 b1 80 53 00    	call   *0x5380b1(%rip)        # ae9f70 <_DYNAMIC+0x3c0>
  5b1ebf:	48 8b 9c 24 d0 04 00 	mov    0x4d0(%rsp),%rbx
  5b1ec6:	00 
  5b1ec7:	44 8b a4 24 d8 04 00 	mov    0x4d8(%rsp),%r12d
  5b1ece:	00 
  5b1ecf:	8b ac 24 dc 04 00 00 	mov    0x4dc(%rsp),%ebp
  5b1ed6:	48 85 db             	test   %rbx,%rbx
  5b1ed9:	48 8b bc 24 90 01 00 	mov    0x190(%rsp),%rdi
  5b1ee0:	00 
  5b1ee1:	0f 84 9f 0a 00 00    	je     5b2986 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1dd6>
  5b1ee7:	48 8b 84 24 10 05 00 	mov    0x510(%rsp),%rax
  5b1eee:	00 
  5b1eef:	48 89 84 24 40 04 00 	mov    %rax,0x440(%rsp)
  5b1ef6:	00 
  5b1ef7:	0f 10 84 24 e0 04 00 	movups 0x4e0(%rsp),%xmm0
  5b1efe:	00 
  5b1eff:	0f 10 8c 24 f0 04 00 	movups 0x4f0(%rsp),%xmm1
  5b1f06:	00 
  5b1f07:	0f 10 94 24 00 05 00 	movups 0x500(%rsp),%xmm2
  5b1f0e:	00 
  5b1f0f:	0f 29 94 24 30 04 00 	movaps %xmm2,0x430(%rsp)
  5b1f16:	00 
  5b1f17:	0f 29 8c 24 20 04 00 	movaps %xmm1,0x420(%rsp)
  5b1f1e:	00 
  5b1f1f:	0f 29 84 24 10 04 00 	movaps %xmm0,0x410(%rsp)
  5b1f26:	00 
  5b1f27:	e8 64 7d f7 ff       	call   529c90 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs7XZEQI6Z5Ts_11gpui_canvas4text10TextSystemEECs6gaF1xUz9Bf_4gpui>
  5b1f2c:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b1f30:	48 89 99 98 08 00 00 	mov    %rbx,0x898(%rcx)
  5b1f37:	44 89 a1 a0 08 00 00 	mov    %r12d,0x8a0(%rcx)
  5b1f3e:	89 a9 a4 08 00 00    	mov    %ebp,0x8a4(%rcx)
  5b1f44:	66 0f 28 84 24 10 04 	movapd 0x410(%rsp),%xmm0
  5b1f4b:	00 00 
  5b1f4d:	0f 28 8c 24 20 04 00 	movaps 0x420(%rsp),%xmm1
  5b1f54:	00 
  5b1f55:	0f 28 94 24 30 04 00 	movaps 0x430(%rsp),%xmm2
  5b1f5c:	00 
  5b1f5d:	66 0f 11 81 a8 08 00 	movupd %xmm0,0x8a8(%rcx)
  5b1f64:	00 
  5b1f65:	0f 11 89 b8 08 00 00 	movups %xmm1,0x8b8(%rcx)
  5b1f6c:	0f 11 91 c8 08 00 00 	movups %xmm2,0x8c8(%rcx)
  5b1f73:	48 8b 84 24 40 04 00 	mov    0x440(%rsp),%rax
  5b1f7a:	00 
  5b1f7b:	48 89 81 d8 08 00 00 	mov    %rax,0x8d8(%rcx)
  5b1f82:	f0 48 ff 03          	lock incq (%rbx)
  5b1f86:	0f 8f 40 f2 ff ff    	jg     5b11cc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x61c>
  5b1f8c:	0f 0b                	ud2
  5b1f8e:	4d 85 ed             	test   %r13,%r13
  5b1f91:	0f 84 75 06 00 00    	je     5b260c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1a5c>
  5b1f97:	4c 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%r14
  5b1f9e:	00 
  5b1f9f:	48 8d ac 24 a0 09 00 	lea    0x9a0(%rsp),%rbp
  5b1fa6:	00 
  5b1fa7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5b1fae:	00 00 
  5b1fb0:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  5b1fb4:	48 83 c3 50          	add    $0x50,%rbx
  5b1fb8:	48 c7 84 24 a0 09 00 	movq   $0x0,0x9a0(%rsp)
  5b1fbf:	00 00 00 00 00 
  5b1fc4:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  5b1fc9:	4d 89 e8             	mov    %r13,%r8
  5b1fcc:	41 0f b7 b0 c2 01 00 	movzwl 0x1c2(%r8),%esi
  5b1fd3:	00 
  5b1fd4:	41 89 f1             	mov    %esi,%r9d
  5b1fd7:	41 c1 e1 05          	shl    $0x5,%r9d
  5b1fdb:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  5b1fe2:	31 ff                	xor    %edi,%edi
  5b1fe4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b1feb:	00 00 00 00 00 
  5b1ff0:	4d 89 ca             	mov    %r9,%r10
  5b1ff3:	49 01 fa             	add    %rdi,%r10
  5b1ff6:	74 38                	je     5b2030 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1480>
  5b1ff8:	49 3b 94 c8 70 01 00 	cmp    0x170(%r8,%rcx,8),%rdx
  5b1fff:	00 
  5b2000:	41 0f 97 c2          	seta   %r10b
  5b2004:	41 80 da 00          	sbb    $0x0,%r10b
  5b2008:	48 83 c7 e0          	add    $0xffffffffffffffe0,%rdi
  5b200c:	48 ff c1             	inc    %rcx
  5b200f:	41 80 fa 01          	cmp    $0x1,%r10b
  5b2013:	74 db                	je     5b1ff0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1440>
  5b2015:	41 0f b6 f2          	movzbl %r10b,%esi
  5b2019:	81 fe ff 00 00 00    	cmp    $0xff,%esi
  5b201f:	74 12                	je     5b2033 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1483>
  5b2021:	eb 2d                	jmp    5b2050 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x14a0>
  5b2023:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b202a:	84 00 00 00 00 00 
  5b2030:	48 89 f1             	mov    %rsi,%rcx
  5b2033:	48 83 e8 01          	sub    $0x1,%rax
  5b2037:	72 3a                	jb     5b2073 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x14c3>
  5b2039:	4d 8b 84 c8 c8 01 00 	mov    0x1c8(%r8,%rcx,8),%r8
  5b2040:	00 
  5b2041:	eb 89                	jmp    5b1fcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x141c>
  5b2043:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b204a:	84 00 00 00 00 00 
  5b2050:	49 29 f8             	sub    %rdi,%r8
  5b2053:	49 83 c0 e0          	add    $0xffffffffffffffe0,%r8
  5b2057:	4c 89 f7             	mov    %r14,%rdi
  5b205a:	4c 89 fe             	mov    %r15,%rsi
  5b205d:	48 89 e9             	mov    %rbp,%rcx
  5b2060:	e8 4b 5f 1a 00       	call   757fb0 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataNtB4_5Sheet7capture>
  5b2065:	4c 39 e3             	cmp    %r12,%rbx
  5b2068:	0f 85 42 ff ff ff    	jne    5b1fb0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1400>
  5b206e:	e9 d8 05 00 00       	jmp    5b264b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1a9b>
  5b2073:	45 31 c0             	xor    %r8d,%r8d
  5b2076:	eb df                	jmp    5b2057 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x14a7>
  5b2078:	48 8b 04 24          	mov    (%rsp),%rax
  5b207c:	48 8b a8 40 07 00 00 	mov    0x740(%rax),%rbp
  5b2083:	e9 d8 00 00 00       	jmp    5b2160 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x15b0>
  5b2088:	4c 8d ac 24 a0 09 00 	lea    0x9a0(%rsp),%r13
  5b208f:	00 
  5b2090:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  5b2094:	48 83 c3 50          	add    $0x50,%rbx
  5b2098:	48 89 e9             	mov    %rbp,%rcx
  5b209b:	4c 89 f0             	mov    %r14,%rax
  5b209e:	0f b7 b8 12 01 00 00 	movzwl 0x112(%rax),%edi
  5b20a5:	41 89 f9             	mov    %edi,%r9d
  5b20a8:	41 c1 e1 04          	shl    $0x4,%r9d
  5b20ac:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  5b20b3:	45 31 c0             	xor    %r8d,%r8d
  5b20b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5b20bd:	00 00 00 
  5b20c0:	4d 39 c1             	cmp    %r8,%r9
  5b20c3:	74 2b                	je     5b20f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1540>
  5b20c5:	48 3b 94 f0 c0 00 00 	cmp    0xc0(%rax,%rsi,8),%rdx
  5b20cc:	00 
  5b20cd:	41 0f 97 c2          	seta   %r10b
  5b20d1:	41 80 da 00          	sbb    $0x0,%r10b
  5b20d5:	49 83 c0 10          	add    $0x10,%r8
  5b20d9:	48 ff c6             	inc    %rsi
  5b20dc:	41 80 fa 01          	cmp    $0x1,%r10b
  5b20e0:	74 de                	je     5b20c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1510>
  5b20e2:	41 0f b6 fa          	movzbl %r10b,%edi
  5b20e6:	81 ff ff 00 00 00    	cmp    $0xff,%edi
  5b20ec:	74 05                	je     5b20f3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1543>
  5b20ee:	eb 20                	jmp    5b2110 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1560>
  5b20f0:	48 89 fe             	mov    %rdi,%rsi
  5b20f3:	48 83 e9 01          	sub    $0x1,%rcx
  5b20f7:	72 61                	jb     5b215a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x15aa>
  5b20f9:	48 8b 84 f0 18 01 00 	mov    0x118(%rax,%rsi,8),%rax
  5b2100:	00 
  5b2101:	eb 9b                	jmp    5b209e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x14ee>
  5b2103:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b210a:	84 00 00 00 00 00 
  5b2110:	4a 8b 4c 00 f0       	mov    -0x10(%rax,%r8,1),%rcx
  5b2115:	42 8b 44 00 f8       	mov    -0x8(%rax,%r8,1),%eax
  5b211a:	48 89 8c 24 a8 09 00 	mov    %rcx,0x9a8(%rsp)
  5b2121:	00 
  5b2122:	89 84 24 b0 09 00 00 	mov    %eax,0x9b0(%rsp)
  5b2129:	b8 01 00 00 00       	mov    $0x1,%eax
  5b212e:	48 89 84 24 a0 09 00 	mov    %rax,0x9a0(%rsp)
  5b2135:	00 
  5b2136:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b213d:	00 
  5b213e:	4c 89 fe             	mov    %r15,%rsi
  5b2141:	4c 89 e9             	mov    %r13,%rcx
  5b2144:	45 31 c0             	xor    %r8d,%r8d
  5b2147:	e8 64 5e 1a 00       	call   757fb0 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataNtB4_5Sheet7capture>
  5b214c:	4c 39 e3             	cmp    %r12,%rbx
  5b214f:	0f 85 3b ff ff ff    	jne    5b2090 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x14e0>
  5b2155:	e9 f1 04 00 00       	jmp    5b264b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1a9b>
  5b215a:	31 c0                	xor    %eax,%eax
  5b215c:	eb d0                	jmp    5b212e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x157e>
  5b215e:	31 ed                	xor    %ebp,%ebp
  5b2160:	48 8b 34 24          	mov    (%rsp),%rsi
  5b2164:	4c 8b b6 f0 06 00 00 	mov    0x6f0(%rsi),%r14
  5b216b:	48 8b 9e 10 07 00 00 	mov    0x710(%rsi),%rbx
  5b2172:	48 8d 86 30 07 00 00 	lea    0x730(%rsi),%rax
  5b2179:	48 c7 84 24 28 03 00 	movq   $0xfffffffffffffffe,0x328(%rsp)
  5b2180:	00 fe ff ff ff 
  5b2185:	48 8d 8e b8 02 00 00 	lea    0x2b8(%rsi),%rcx
  5b218c:	4c 8d 86 28 02 00 00 	lea    0x228(%rsi),%r8
  5b2193:	48 8d 96 d0 02 00 00 	lea    0x2d0(%rsi),%rdx
  5b219a:	48 8d be a8 07 00 00 	lea    0x7a8(%rsi),%rdi
  5b21a1:	48 89 84 24 68 09 00 	mov    %rax,0x968(%rsp)
  5b21a8:	00 
  5b21a9:	48 89 8c 24 70 09 00 	mov    %rcx,0x970(%rsp)
  5b21b0:	00 
  5b21b1:	48 89 bc 24 00 02 00 	mov    %rdi,0x200(%rsp)
  5b21b8:	00 
  5b21b9:	48 89 bc 24 78 09 00 	mov    %rdi,0x978(%rsp)
  5b21c0:	00 
  5b21c1:	48 8d 84 24 20 01 00 	lea    0x120(%rsp),%rax
  5b21c8:	00 
  5b21c9:	48 89 84 24 80 09 00 	mov    %rax,0x980(%rsp)
  5b21d0:	00 
  5b21d1:	48 89 94 24 88 09 00 	mov    %rdx,0x988(%rsp)
  5b21d8:	00 
  5b21d9:	4c 89 84 24 88 03 00 	mov    %r8,0x388(%rsp)
  5b21e0:	00 
  5b21e1:	4c 89 84 24 90 09 00 	mov    %r8,0x990(%rsp)
  5b21e8:	00 
  5b21e9:	48 8d 84 24 28 03 00 	lea    0x328(%rsp),%rax
  5b21f0:	00 
  5b21f1:	48 89 84 24 98 09 00 	mov    %rax,0x998(%rsp)
  5b21f8:	00 
  5b21f9:	48 85 ed             	test   %rbp,%rbp
  5b21fc:	0f 84 76 2b 00 00    	je     5b4d78 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41c8>
  5b2202:	48 8b 86 38 07 00 00 	mov    0x738(%rsi),%rax
  5b2209:	66 0f 10 00          	movupd (%rax),%xmm0
  5b220d:	66 0f 29 84 24 a0 09 	movapd %xmm0,0x9a0(%rsp)
  5b2214:	00 00 
  5b2216:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
  5b221a:	66 0f 28 4c 24 60    	movapd 0x60(%rsp),%xmm1
  5b2220:	0f 14 c8             	unpcklps %xmm0,%xmm1
  5b2223:	66 0f 28 05 25 b0 ab 	movapd -0x544fdb(%rip),%xmm0        # 6d250 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0x11d0>
  5b222a:	ff 
  5b222b:	66 0f 56 c8          	orpd   %xmm0,%xmm1
  5b222f:	66 0f 5c c8          	subpd  %xmm0,%xmm1
  5b2233:	66 0f 5a c9          	cvtpd2ps %xmm1,%xmm1
  5b2237:	66 0f 28 c1          	movapd %xmm1,%xmm0
  5b223b:	0f c6 c1 55          	shufps $0x55,%xmm1,%xmm0
  5b223f:	0f 29 8c 24 f0 02 00 	movaps %xmm1,0x2f0(%rsp)
  5b2246:	00 
  5b2247:	f3 0f 10 54 24 24    	movss  0x24(%rsp),%xmm2
  5b224d:	f3 0f 5e ca          	divss  %xmm2,%xmm1
  5b2251:	f3 0f 5e c2          	divss  %xmm2,%xmm0
  5b2255:	c7 84 24 d0 04 00 00 	movl   $0x0,0x4d0(%rsp)
  5b225c:	00 00 00 00 
  5b2260:	f3 0f 11 8c 24 d4 04 	movss  %xmm1,0x4d4(%rsp)
  5b2267:	00 00 
  5b2269:	c7 84 24 d8 04 00 00 	movl   $0x0,0x4d8(%rsp)
  5b2270:	00 00 00 00 
  5b2274:	f3 0f 11 84 24 dc 04 	movss  %xmm0,0x4dc(%rsp)
  5b227b:	00 00 
  5b227d:	b0 01                	mov    $0x1,%al
  5b227f:	89 44 24 08          	mov    %eax,0x8(%rsp)
  5b2283:	4c 8d 05 66 6e 50 00 	lea    0x506e66(%rip),%r8        # ab90f0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x4c0>
  5b228a:	48 8d b4 24 a0 09 00 	lea    0x9a0(%rsp),%rsi
  5b2291:	00 
  5b2292:	48 8d 94 24 d0 04 00 	lea    0x4d0(%rsp),%rdx
  5b2299:	00 
  5b229a:	48 8d 8c 24 68 09 00 	lea    0x968(%rsp),%rcx
  5b22a1:	00 
  5b22a2:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
  5b22a7:	ff 15 cb 7c 53 00    	call   *0x537ccb(%rip)        # ae9f78 <_DYNAMIC+0x3c8>
  5b22ad:	a8 01                	test   $0x1,%al
  5b22af:	74 1f                	je     5b22d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1720>
  5b22b1:	41 89 d4             	mov    %edx,%r12d
  5b22b4:	41 b6 01             	mov    $0x1,%r14b
  5b22b7:	41 bf 21 00 00 00    	mov    $0x21,%r15d
  5b22bd:	83 bc 24 28 03 00 00 	cmpl   $0xfffffffe,0x328(%rsp)
  5b22c4:	fe 
  5b22c5:	0f 85 2a 26 00 00    	jne    5b48f5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3d45>
  5b22cb:	e9 32 26 00 00       	jmp    5b4902 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3d52>
  5b22d0:	4c 8b 24 24          	mov    (%rsp),%r12
  5b22d4:	49 8b 84 24 f0 06 00 	mov    0x6f0(%r12),%rax
  5b22db:	00 
  5b22dc:	4c 29 f0             	sub    %r14,%rax
  5b22df:	49 8b 8c 24 10 07 00 	mov    0x710(%r12),%rcx
  5b22e6:	00 
  5b22e7:	49 01 84 24 18 09 00 	add    %rax,0x918(%r12)
  5b22ee:	00 
  5b22ef:	48 29 d9             	sub    %rbx,%rcx
  5b22f2:	49 01 8c 24 20 09 00 	add    %rcx,0x920(%r12)
  5b22f9:	00 
  5b22fa:	4c 8b bc 24 28 03 00 	mov    0x328(%rsp),%r15
  5b2301:	00 
  5b2302:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  5b2306:	0f 85 83 02 00 00    	jne    5b258f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x19df>
  5b230c:	49 8b b4 24 c8 02 00 	mov    0x2c8(%r12),%rsi
  5b2313:	00 
  5b2314:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b231b:	00 
  5b231c:	b9 08 00 00 00       	mov    $0x8,%ecx
  5b2321:	41 b8 50 00 00 00    	mov    $0x50,%r8d
  5b2327:	31 d2                	xor    %edx,%edx
  5b2329:	e8 d2 c9 21 00       	call   7ced00 <_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs6gaF1xUz9Bf_4gpui>
  5b232e:	48 8b bc 24 d8 04 00 	mov    0x4d8(%rsp),%rdi
  5b2335:	00 
  5b2336:	80 bc 24 d0 04 00 00 	cmpb   $0x0,0x4d0(%rsp)
  5b233d:	00 
  5b233e:	0f 85 b1 28 00 00    	jne    5b4bf5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4045>
  5b2344:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b234b:	00 
  5b234c:	48 89 bc 24 b8 01 00 	mov    %rdi,0x1b8(%rsp)
  5b2353:	00 
  5b2354:	48 89 84 24 c0 01 00 	mov    %rax,0x1c0(%rsp)
  5b235b:	00 
  5b235c:	48 c7 84 24 c8 01 00 	movq   $0x0,0x1c8(%rsp)
  5b2363:	00 00 00 00 00 
  5b2368:	49 8b b4 24 c8 02 00 	mov    0x2c8(%r12),%rsi
  5b236f:	00 
  5b2370:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b2377:	00 
  5b2378:	b9 08 00 00 00       	mov    $0x8,%ecx
  5b237d:	41 b8 38 00 00 00    	mov    $0x38,%r8d
  5b2383:	31 d2                	xor    %edx,%edx
  5b2385:	e8 76 c9 21 00       	call   7ced00 <_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs6gaF1xUz9Bf_4gpui>
  5b238a:	48 8b bc 24 d8 04 00 	mov    0x4d8(%rsp),%rdi
  5b2391:	00 
  5b2392:	80 bc 24 d0 04 00 00 	cmpb   $0x0,0x4d0(%rsp)
  5b2399:	00 
  5b239a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  5b23a1:	00 
  5b23a2:	0f 85 60 28 00 00    	jne    5b4c08 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4058>
  5b23a8:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b23af:	00 
  5b23b0:	48 89 bc 24 30 01 00 	mov    %rdi,0x130(%rsp)
  5b23b7:	00 
  5b23b8:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
  5b23bf:	00 
  5b23c0:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  5b23c7:	00 00 00 00 00 
  5b23cc:	49 8b 84 24 28 08 00 	mov    0x828(%r12),%rax
  5b23d3:	00 
  5b23d4:	49 89 c7             	mov    %rax,%r15
  5b23d7:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b23dc:	48 85 c0             	test   %rax,%rax
  5b23df:	74 0b                	je     5b23ec <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x183c>
  5b23e1:	48 8b 04 24          	mov    (%rsp),%rax
  5b23e5:	4c 8b b8 c8 02 00 00 	mov    0x2c8(%rax),%r15
  5b23ec:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b23f3:	00 
  5b23f4:	b9 04 00 00 00       	mov    $0x4,%ecx
  5b23f9:	41 b8 10 00 00 00    	mov    $0x10,%r8d
  5b23ff:	4c 89 fe             	mov    %r15,%rsi
  5b2402:	31 d2                	xor    %edx,%edx
  5b2404:	e8 f7 c8 21 00       	call   7ced00 <_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs6gaF1xUz9Bf_4gpui>
  5b2409:	48 8b bc 24 d8 04 00 	mov    0x4d8(%rsp),%rdi
  5b2410:	00 
  5b2411:	80 bc 24 d0 04 00 00 	cmpb   $0x0,0x4d0(%rsp)
  5b2418:	00 
  5b2419:	0f 85 fc 27 00 00    	jne    5b4c1b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x406b>
  5b241f:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b2426:	00 
  5b2427:	48 89 bc 24 48 01 00 	mov    %rdi,0x148(%rsp)
  5b242e:	00 
  5b242f:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  5b2436:	00 
  5b2437:	48 c7 84 24 58 01 00 	movq   $0x0,0x158(%rsp)
  5b243e:	00 00 00 00 00 
  5b2443:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b244a:	00 
  5b244b:	b9 04 00 00 00       	mov    $0x4,%ecx
  5b2450:	41 b8 10 00 00 00    	mov    $0x10,%r8d
  5b2456:	4c 89 fe             	mov    %r15,%rsi
  5b2459:	31 d2                	xor    %edx,%edx
  5b245b:	e8 a0 c8 21 00       	call   7ced00 <_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs6gaF1xUz9Bf_4gpui>
  5b2460:	48 8b bc 24 d8 04 00 	mov    0x4d8(%rsp),%rdi
  5b2467:	00 
  5b2468:	80 bc 24 d0 04 00 00 	cmpb   $0x0,0x4d0(%rsp)
  5b246f:	00 
  5b2470:	0f 85 b8 27 00 00    	jne    5b4c2e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x407e>
  5b2476:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b247d:	00 
  5b247e:	48 89 bc 24 60 01 00 	mov    %rdi,0x160(%rsp)
  5b2485:	00 
  5b2486:	48 89 84 24 68 01 00 	mov    %rax,0x168(%rsp)
  5b248d:	00 
  5b248e:	48 c7 84 24 70 01 00 	movq   $0x0,0x170(%rsp)
  5b2495:	00 00 00 00 00 
  5b249a:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b24a1:	00 
  5b24a2:	b9 01 00 00 00       	mov    $0x1,%ecx
  5b24a7:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  5b24ad:	4c 89 fe             	mov    %r15,%rsi
  5b24b0:	31 d2                	xor    %edx,%edx
  5b24b2:	e8 49 c8 21 00       	call   7ced00 <_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs6gaF1xUz9Bf_4gpui>
  5b24b7:	48 8b bc 24 d8 04 00 	mov    0x4d8(%rsp),%rdi
  5b24be:	00 
  5b24bf:	80 bc 24 d0 04 00 00 	cmpb   $0x0,0x4d0(%rsp)
  5b24c6:	00 
  5b24c7:	0f 85 74 27 00 00    	jne    5b4c41 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4091>
  5b24cd:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b24d4:	00 
  5b24d5:	48 89 bc 24 78 01 00 	mov    %rdi,0x178(%rsp)
  5b24dc:	00 
  5b24dd:	48 89 84 24 80 01 00 	mov    %rax,0x180(%rsp)
  5b24e4:	00 
  5b24e5:	48 c7 84 24 88 01 00 	movq   $0x0,0x188(%rsp)
  5b24ec:	00 00 00 00 00 
  5b24f1:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b24f8:	00 
  5b24f9:	b9 04 00 00 00       	mov    $0x4,%ecx
  5b24fe:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  5b2504:	4c 89 fe             	mov    %r15,%rsi
  5b2507:	31 d2                	xor    %edx,%edx
  5b2509:	e8 f2 c7 21 00       	call   7ced00 <_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs6gaF1xUz9Bf_4gpui>
  5b250e:	48 8b bc 24 d8 04 00 	mov    0x4d8(%rsp),%rdi
  5b2515:	00 
  5b2516:	80 bc 24 d0 04 00 00 	cmpb   $0x0,0x4d0(%rsp)
  5b251d:	00 
  5b251e:	0f 85 30 27 00 00    	jne    5b4c54 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x40a4>
  5b2524:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b252b:	00 
  5b252c:	48 89 bc 24 a8 00 00 	mov    %rdi,0xa8(%rsp)
  5b2533:	00 
  5b2534:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5b253b:	00 
  5b253c:	48 c7 84 24 b8 00 00 	movq   $0x0,0xb8(%rsp)
  5b2543:	00 00 00 00 00 
  5b2548:	48 c7 84 24 a8 02 00 	movq   $0x0,0x2a8(%rsp)
  5b254f:	00 00 00 00 00 
  5b2554:	48 c7 84 24 b8 02 00 	movq   $0x0,0x2b8(%rsp)
  5b255b:	00 00 00 00 00 
  5b2560:	48 8b 34 24          	mov    (%rsp),%rsi
  5b2564:	48 8b 96 10 08 00 00 	mov    0x810(%rsi),%rdx
  5b256b:	48 85 d2             	test   %rdx,%rdx
  5b256e:	0f 84 36 04 00 00    	je     5b29aa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1dfa>
  5b2574:	b0 01                	mov    $0x1,%al
  5b2576:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b257a:	48 8d bc 24 98 03 00 	lea    0x398(%rsp),%rdi
  5b2581:	00 
  5b2582:	41 b6 01             	mov    $0x1,%r14b
  5b2585:	e8 d6 79 f8 ff       	call   539f60 <_RNCNvMs1_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataINtB9_7RuntimeNtNtB9_12style_ledger9AdversaryE14metadata_sheet0Bb_>
  5b258a:	e9 27 04 00 00       	jmp    5b29b6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1e06>
  5b258f:	44 8b a4 24 30 03 00 	mov    0x330(%rsp),%r12d
  5b2596:	00 
  5b2597:	8b ac 24 34 03 00 00 	mov    0x334(%rsp),%ebp
  5b259e:	45 89 e5             	mov    %r12d,%r13d
  5b25a1:	41 c1 ed 08          	shr    $0x8,%r13d
  5b25a5:	0f 10 84 24 38 03 00 	movups 0x338(%rsp),%xmm0
  5b25ac:	00 
  5b25ad:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  5b25b2:	66 0f 10 84 24 48 03 	movupd 0x348(%rsp),%xmm0
  5b25b9:	00 00 
  5b25bb:	66 0f 29 44 24 30    	movapd %xmm0,0x30(%rsp)
  5b25c1:	0f b6 9c 24 58 03 00 	movzbl 0x358(%rsp),%ebx
  5b25c8:	00 
  5b25c9:	8b 84 24 59 03 00 00 	mov    0x359(%rsp),%eax
  5b25d0:	89 44 24 58          	mov    %eax,0x58(%rsp)
  5b25d4:	8b 84 24 5c 03 00 00 	mov    0x35c(%rsp),%eax
  5b25db:	89 44 24 5b          	mov    %eax,0x5b(%rsp)
  5b25df:	41 b6 01             	mov    $0x1,%r14b
  5b25e2:	e9 1b 23 00 00       	jmp    5b4902 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3d52>
  5b25e7:	41 89 d4             	mov    %edx,%r12d
  5b25ea:	e9 89 03 00 00       	jmp    5b2978 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1dc8>
  5b25ef:	48 c7 84 24 98 00 00 	movq   $0x0,0x98(%rsp)
  5b25f6:	00 00 00 00 00 
  5b25fb:	48 c7 84 24 20 01 00 	movq   $0x0,0x120(%rsp)
  5b2602:	00 00 00 00 00 
  5b2607:	e9 e4 eb ff ff       	jmp    5b11f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x640>
  5b260c:	45 31 f6             	xor    %r14d,%r14d
  5b260f:	4c 8d a4 24 d0 04 00 	lea    0x4d0(%rsp),%r12
  5b2616:	00 
  5b2617:	4c 8d ac 24 a0 09 00 	lea    0x9a0(%rsp),%r13
  5b261e:	00 
  5b261f:	90                   	nop
  5b2620:	4a 8b 54 33 20       	mov    0x20(%rbx,%r14,1),%rdx
  5b2625:	48 c7 84 24 a0 09 00 	movq   $0x0,0x9a0(%rsp)
  5b262c:	00 00 00 00 00 
  5b2631:	4c 89 e7             	mov    %r12,%rdi
  5b2634:	4c 89 fe             	mov    %r15,%rsi
  5b2637:	4c 89 e9             	mov    %r13,%rcx
  5b263a:	45 31 c0             	xor    %r8d,%r8d
  5b263d:	e8 6e 59 1a 00       	call   757fb0 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataNtB4_5Sheet7capture>
  5b2642:	49 83 c6 50          	add    $0x50,%r14
  5b2646:	4c 39 f5             	cmp    %r14,%rbp
  5b2649:	75 d5                	jne    5b2620 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1a70>
  5b264b:	4c 8d a4 24 d0 04 00 	lea    0x4d0(%rsp),%r12
  5b2652:	00 
  5b2653:	4c 89 e7             	mov    %r12,%rdi
  5b2656:	e8 25 58 1a 00       	call   757e80 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataNtB4_5Sheet4sort>
  5b265b:	48 8b 9c 24 d0 04 00 	mov    0x4d0(%rsp),%rbx
  5b2662:	00 
  5b2663:	0f 10 84 24 d8 04 00 	movups 0x4d8(%rsp),%xmm0
  5b266a:	00 
  5b266b:	0f 29 84 24 a0 09 00 	movaps %xmm0,0x9a0(%rsp)
  5b2672:	00 
  5b2673:	0f 10 84 24 e8 04 00 	movups 0x4e8(%rsp),%xmm0
  5b267a:	00 
  5b267b:	0f 29 84 24 b0 09 00 	movaps %xmm0,0x9b0(%rsp)
  5b2682:	00 
  5b2683:	0f 10 84 24 f8 04 00 	movups 0x4f8(%rsp),%xmm0
  5b268a:	00 
  5b268b:	0f 29 84 24 c0 09 00 	movaps %xmm0,0x9c0(%rsp)
  5b2692:	00 
  5b2693:	0f 10 84 24 08 05 00 	movups 0x508(%rsp),%xmm0
  5b269a:	00 
  5b269b:	0f 29 84 24 d0 09 00 	movaps %xmm0,0x9d0(%rsp)
  5b26a2:	00 
  5b26a3:	66 0f 10 84 24 18 05 	movupd 0x518(%rsp),%xmm0
  5b26aa:	00 00 
  5b26ac:	66 0f 29 84 24 e0 09 	movapd %xmm0,0x9e0(%rsp)
  5b26b3:	00 00 
  5b26b5:	48 8b 84 24 28 05 00 	mov    0x528(%rsp),%rax
  5b26bc:	00 
  5b26bd:	48 89 84 24 f0 09 00 	mov    %rax,0x9f0(%rsp)
  5b26c4:	00 
  5b26c5:	48 8d bc 24 58 0c 00 	lea    0xc58(%rsp),%rdi
  5b26cc:	00 
  5b26cd:	e8 5e b3 17 00       	call   72da30 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5b26d2:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5b26d6:	4c 8b b4 24 90 00 00 	mov    0x90(%rsp),%r14
  5b26dd:	00 
  5b26de:	8b 6c 24 54          	mov    0x54(%rsp),%ebp
  5b26e2:	0f 84 af 01 00 00    	je     5b2897 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1ce7>
  5b26e8:	40 84 ed             	test   %bpl,%bpl
  5b26eb:	0f 84 e2 00 00 00    	je     5b27d3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1c23>
  5b26f1:	48 89 9c 24 d0 04 00 	mov    %rbx,0x4d0(%rsp)
  5b26f8:	00 
  5b26f9:	48 8b 84 24 f0 09 00 	mov    0x9f0(%rsp),%rax
  5b2700:	00 
  5b2701:	48 89 84 24 28 05 00 	mov    %rax,0x528(%rsp)
  5b2708:	00 
  5b2709:	0f 28 84 24 e0 09 00 	movaps 0x9e0(%rsp),%xmm0
  5b2710:	00 
  5b2711:	0f 11 84 24 18 05 00 	movups %xmm0,0x518(%rsp)
  5b2718:	00 
  5b2719:	0f 28 84 24 a0 09 00 	movaps 0x9a0(%rsp),%xmm0
  5b2720:	00 
  5b2721:	0f 28 8c 24 b0 09 00 	movaps 0x9b0(%rsp),%xmm1
  5b2728:	00 
  5b2729:	0f 28 94 24 c0 09 00 	movaps 0x9c0(%rsp),%xmm2
  5b2730:	00 
  5b2731:	0f 28 9c 24 d0 09 00 	movaps 0x9d0(%rsp),%xmm3
  5b2738:	00 
  5b2739:	0f 11 9c 24 08 05 00 	movups %xmm3,0x508(%rsp)
  5b2740:	00 
  5b2741:	0f 11 94 24 f8 04 00 	movups %xmm2,0x4f8(%rsp)
  5b2748:	00 
  5b2749:	0f 11 8c 24 e8 04 00 	movups %xmm1,0x4e8(%rsp)
  5b2750:	00 
  5b2751:	0f 11 84 24 d8 04 00 	movups %xmm0,0x4d8(%rsp)
  5b2758:	00 
  5b2759:	49 83 7f 78 ff       	cmpq   $0xffffffffffffffff,0x78(%r15)
  5b275e:	74 09                	je     5b2769 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1bb9>
  5b2760:	49 8d 7f 78          	lea    0x78(%r15),%rdi
  5b2764:	e8 87 63 f8 ff       	call   538af0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5SheetEBH_>
  5b2769:	49 89 5f 78          	mov    %rbx,0x78(%r15)
  5b276d:	0f 28 84 24 a0 09 00 	movaps 0x9a0(%rsp),%xmm0
  5b2774:	00 
  5b2775:	0f 28 8c 24 b0 09 00 	movaps 0x9b0(%rsp),%xmm1
  5b277c:	00 
  5b277d:	0f 28 94 24 c0 09 00 	movaps 0x9c0(%rsp),%xmm2
  5b2784:	00 
  5b2785:	0f 28 9c 24 d0 09 00 	movaps 0x9d0(%rsp),%xmm3
  5b278c:	00 
  5b278d:	41 0f 11 87 80 00 00 	movups %xmm0,0x80(%r15)
  5b2794:	00 
  5b2795:	41 0f 11 8f 90 00 00 	movups %xmm1,0x90(%r15)
  5b279c:	00 
  5b279d:	41 0f 11 97 a0 00 00 	movups %xmm2,0xa0(%r15)
  5b27a4:	00 
  5b27a5:	41 0f 11 9f b0 00 00 	movups %xmm3,0xb0(%r15)
  5b27ac:	00 
  5b27ad:	66 0f 28 84 24 e0 09 	movapd 0x9e0(%rsp),%xmm0
  5b27b4:	00 00 
  5b27b6:	66 41 0f 11 87 c0 00 	movupd %xmm0,0xc0(%r15)
  5b27bd:	00 00 
  5b27bf:	48 8b 84 24 f0 09 00 	mov    0x9f0(%rsp),%rax
  5b27c6:	00 
  5b27c7:	49 89 87 d0 00 00 00 	mov    %rax,0xd0(%r15)
  5b27ce:	e9 c4 00 00 00       	jmp    5b2897 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1ce7>
  5b27d3:	48 89 9c 24 d0 04 00 	mov    %rbx,0x4d0(%rsp)
  5b27da:	00 
  5b27db:	0f 28 84 24 a0 09 00 	movaps 0x9a0(%rsp),%xmm0
  5b27e2:	00 
  5b27e3:	0f 28 8c 24 b0 09 00 	movaps 0x9b0(%rsp),%xmm1
  5b27ea:	00 
  5b27eb:	0f 28 94 24 c0 09 00 	movaps 0x9c0(%rsp),%xmm2
  5b27f2:	00 
  5b27f3:	0f 28 9c 24 d0 09 00 	movaps 0x9d0(%rsp),%xmm3
  5b27fa:	00 
  5b27fb:	0f 11 84 24 d8 04 00 	movups %xmm0,0x4d8(%rsp)
  5b2802:	00 
  5b2803:	0f 11 8c 24 e8 04 00 	movups %xmm1,0x4e8(%rsp)
  5b280a:	00 
  5b280b:	0f 11 94 24 f8 04 00 	movups %xmm2,0x4f8(%rsp)
  5b2812:	00 
  5b2813:	0f 11 9c 24 08 05 00 	movups %xmm3,0x508(%rsp)
  5b281a:	00 
  5b281b:	0f 28 84 24 e0 09 00 	movaps 0x9e0(%rsp),%xmm0
  5b2822:	00 
  5b2823:	0f 11 84 24 18 05 00 	movups %xmm0,0x518(%rsp)
  5b282a:	00 
  5b282b:	48 8b 84 24 f0 09 00 	mov    0x9f0(%rsp),%rax
  5b2832:	00 
  5b2833:	48 89 84 24 28 05 00 	mov    %rax,0x528(%rsp)
  5b283a:	00 
  5b283b:	49 8d 7f 18          	lea    0x18(%r15),%rdi
  5b283f:	e8 ac 62 f8 ff       	call   538af0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5SheetEBH_>
  5b2844:	49 89 5f 18          	mov    %rbx,0x18(%r15)
  5b2848:	0f 28 84 24 a0 09 00 	movaps 0x9a0(%rsp),%xmm0
  5b284f:	00 
  5b2850:	0f 28 8c 24 b0 09 00 	movaps 0x9b0(%rsp),%xmm1
  5b2857:	00 
  5b2858:	0f 28 94 24 c0 09 00 	movaps 0x9c0(%rsp),%xmm2
  5b285f:	00 
  5b2860:	0f 28 9c 24 d0 09 00 	movaps 0x9d0(%rsp),%xmm3
  5b2867:	00 
  5b2868:	41 0f 11 47 20       	movups %xmm0,0x20(%r15)
  5b286d:	41 0f 11 4f 30       	movups %xmm1,0x30(%r15)
  5b2872:	41 0f 11 57 40       	movups %xmm2,0x40(%r15)
  5b2877:	41 0f 11 5f 50       	movups %xmm3,0x50(%r15)
  5b287c:	66 0f 28 84 24 e0 09 	movapd 0x9e0(%rsp),%xmm0
  5b2883:	00 00 
  5b2885:	66 41 0f 11 47 60    	movupd %xmm0,0x60(%r15)
  5b288b:	48 8b 84 24 f0 09 00 	mov    0x9f0(%rsp),%rax
  5b2892:	00 
  5b2893:	49 89 47 70          	mov    %rax,0x70(%r15)
  5b2897:	49 83 7f 10 00       	cmpq   $0x0,0x10(%r15)
  5b289c:	48 8b 9c 24 a0 00 00 	mov    0xa0(%rsp),%rbx
  5b28a3:	00 
  5b28a4:	4c 8b 64 24 30       	mov    0x30(%rsp),%r12
  5b28a9:	75 57                	jne    5b2902 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1d52>
  5b28ab:	49 83 bf e8 00 00 00 	cmpq   $0x0,0xe8(%r15)
  5b28b2:	00 
  5b28b3:	75 4d                	jne    5b2902 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1d52>
  5b28b5:	49 83 7f 78 ff       	cmpq   $0xffffffffffffffff,0x78(%r15)
  5b28ba:	75 46                	jne    5b2902 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1d52>
  5b28bc:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  5b28c1:	75 3f                	jne    5b2902 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1d52>
  5b28c3:	49 83 7f 40 00       	cmpq   $0x0,0x40(%r15)
  5b28c8:	75 38                	jne    5b2902 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1d52>
  5b28ca:	49 83 7f 58 00       	cmpq   $0x0,0x58(%r15)
  5b28cf:	75 31                	jne    5b2902 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1d52>
  5b28d1:	49 83 7f 70 00       	cmpq   $0x0,0x70(%r15)
  5b28d6:	75 2a                	jne    5b2902 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1d52>
  5b28d8:	4c 89 ff             	mov    %r15,%rdi
  5b28db:	e8 30 64 f8 ff       	call   538d10 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata8MetadataEBH_>
  5b28e0:	be f0 00 00 00       	mov    $0xf0,%esi
  5b28e5:	ba 08 00 00 00       	mov    $0x8,%edx
  5b28ea:	4c 89 ff             	mov    %r15,%rdi
  5b28ed:	ff 15 05 75 53 00    	call   *0x537505(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b28f3:	48 8b 04 24          	mov    (%rsp),%rax
  5b28f7:	48 c7 80 10 08 00 00 	movq   $0x0,0x810(%rax)
  5b28fe:	00 00 00 00 
  5b2902:	48 8b 34 24          	mov    (%rsp),%rsi
  5b2906:	4c 89 b6 90 08 00 00 	mov    %r14,0x890(%rsi)
  5b290d:	40 84 ed             	test   %bpl,%bpl
  5b2910:	74 09                	je     5b291b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1d6b>
  5b2912:	48 8b 86 68 08 00 00 	mov    0x868(%rsi),%rax
  5b2919:	eb 0a                	jmp    5b2925 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1d75>
  5b291b:	4c 89 b6 68 08 00 00 	mov    %r14,0x868(%rsi)
  5b2922:	4c 89 f0             	mov    %r14,%rax
  5b2925:	48 83 be 80 08 00 00 	cmpq   $0x0,0x880(%rsi)
  5b292c:	00 
  5b292d:	0f 95 c1             	setne  %cl
  5b2930:	49 83 fc ff          	cmp    $0xffffffffffffffff,%r12
  5b2934:	0f 95 c2             	setne  %dl
  5b2937:	0a 54 24 60          	or     0x60(%rsp),%dl
  5b293b:	20 ca                	and    %cl,%dl
  5b293d:	0f b6 ca             	movzbl %dl,%ecx
  5b2940:	48 8b 96 48 09 00 00 	mov    0x948(%rsi),%rdx
  5b2947:	4c 89 73 18          	mov    %r14,0x18(%rbx)
  5b294b:	48 89 43 20          	mov    %rax,0x20(%rbx)
  5b294f:	0f b6 44 24 24       	movzbl 0x24(%rsp),%eax
  5b2954:	88 43 30             	mov    %al,0x30(%rbx)
  5b2957:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  5b295b:	4c 89 73 10          	mov    %r14,0x10(%rbx)
  5b295f:	48 89 53 28          	mov    %rdx,0x28(%rbx)
  5b2963:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  5b296a:	e9 a4 21 00 00       	jmp    5b4b13 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3f63>
  5b296f:	44 0f b6 a4 24 a1 09 	movzbl 0x9a1(%rsp),%r12d
  5b2976:	00 00 
  5b2978:	41 b6 01             	mov    $0x1,%r14b
  5b297b:	41 bf 21 00 00 00    	mov    $0x21,%r15d
  5b2981:	e9 7c 1f 00 00       	jmp    5b4902 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3d52>
  5b2986:	45 89 e5             	mov    %r12d,%r13d
  5b2989:	41 c1 ed 08          	shr    $0x8,%r13d
  5b298d:	4c 8b b4 24 58 0c 00 	mov    0xc58(%rsp),%r14
  5b2994:	00 
  5b2995:	41 bf 22 00 00 00    	mov    $0x22,%r15d
  5b299b:	41 83 fe 02          	cmp    $0x2,%r14d
  5b299f:	0f 85 a2 1f 00 00    	jne    5b4947 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3d97>
  5b29a5:	e9 aa 1f 00 00       	jmp    5b4954 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3da4>
  5b29aa:	48 c7 84 24 98 03 00 	movq   $0xffffffffffffffff,0x398(%rsp)
  5b29b1:	00 ff ff ff ff 
  5b29b6:	48 8b 84 24 00 02 00 	mov    0x200(%rsp),%rax
  5b29bd:	00 
  5b29be:	48 8b 30             	mov    (%rax),%rsi
  5b29c1:	48 85 f6             	test   %rsi,%rsi
  5b29c4:	0f 84 95 00 00 00    	je     5b2a5f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1eaf>
  5b29ca:	b0 01                	mov    $0x1,%al
  5b29cc:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b29d0:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b29d7:	00 
  5b29d8:	b0 01                	mov    $0x1,%al
  5b29da:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b29de:	41 b6 01             	mov    $0x1,%r14b
  5b29e1:	e8 0a 56 1c 00       	call   777ff0 <_RNvMNtNtCs6gaF1xUz9Bf_4gpui7runtime5imageNtB2_6Images9candidate>
  5b29e6:	4c 8b bc 24 d0 04 00 	mov    0x4d0(%rsp),%r15
  5b29ed:	00 
  5b29ee:	48 8b 8c 24 d8 04 00 	mov    0x4d8(%rsp),%rcx
  5b29f5:	00 
  5b29f6:	44 8b a4 24 d8 04 00 	mov    0x4d8(%rsp),%r12d
  5b29fd:	00 
  5b29fe:	8b ac 24 dc 04 00 00 	mov    0x4dc(%rsp),%ebp
  5b2a05:	0f 10 84 24 e0 04 00 	movups 0x4e0(%rsp),%xmm0
  5b2a0c:	00 
  5b2a0d:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  5b2a12:	66 0f 10 84 24 f0 04 	movupd 0x4f0(%rsp),%xmm0
  5b2a19:	00 00 
  5b2a1b:	66 0f 29 44 24 30    	movapd %xmm0,0x30(%rsp)
  5b2a21:	0f b6 9c 24 00 05 00 	movzbl 0x500(%rsp),%ebx
  5b2a28:	00 
  5b2a29:	8b 84 24 01 05 00 00 	mov    0x501(%rsp),%eax
  5b2a30:	89 84 24 a0 09 00 00 	mov    %eax,0x9a0(%rsp)
  5b2a37:	8b 84 24 04 05 00 00 	mov    0x504(%rsp),%eax
  5b2a3e:	89 84 24 a3 09 00 00 	mov    %eax,0x9a3(%rsp)
  5b2a45:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  5b2a49:	0f 85 a2 14 00 00    	jne    5b3ef1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3341>
  5b2a4f:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  5b2a56:	00 
  5b2a57:	66 0f 28 44 24 60    	movapd 0x60(%rsp),%xmm0
  5b2a5d:	eb 07                	jmp    5b2a66 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1eb6>
  5b2a5f:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  5b2a66:	66 0f 11 84 24 00 04 	movupd %xmm0,0x400(%rsp)
  5b2a6d:	00 00 
  5b2a6f:	48 89 8c 24 f0 01 00 	mov    %rcx,0x1f0(%rsp)
  5b2a76:	00 
  5b2a77:	48 89 8c 24 f8 03 00 	mov    %rcx,0x3f8(%rsp)
  5b2a7e:	00 
  5b2a7f:	b0 01                	mov    $0x1,%al
  5b2a81:	89 84 24 c0 00 00 00 	mov    %eax,0xc0(%rsp)
  5b2a88:	48 8d bc 24 48 04 00 	lea    0x448(%rsp),%rdi
  5b2a8f:	00 
  5b2a90:	b0 01                	mov    $0x1,%al
  5b2a92:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b2a96:	b0 01                	mov    $0x1,%al
  5b2a98:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b2a9c:	41 b6 01             	mov    $0x1,%r14b
  5b2a9f:	48 8b 34 24          	mov    (%rsp),%rsi
  5b2aa3:	e8 e8 2f f9 ff       	call   545a90 <_RNvMs1_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataINtB7_7RuntimeNtNtB7_12style_ledger9AdversaryE13list_metadataB9_>
  5b2aa8:	83 bc 24 58 0c 00 00 	cmpl   $0x2,0xc58(%rsp)
  5b2aaf:	02 
  5b2ab0:	48 8d b4 24 58 0c 00 	lea    0xc58(%rsp),%rsi
  5b2ab7:	00 
  5b2ab8:	48 0f 44 34 24       	cmove  (%rsp),%rsi
  5b2abd:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b2ac4:	00 
  5b2ac5:	ff 15 b5 74 53 00    	call   *0x5374b5(%rip)        # ae9f80 <_DYNAMIC+0x3d0>
  5b2acb:	66 0f 10 05 cd 92 ab 	movupd -0x546d33(%rip),%xmm0        # 6bda0 <anon.1f6b7bab1fc61e0fcd36456038a862fb.97.llvm.5148459089407822190>
  5b2ad2:	ff 
  5b2ad3:	66 0f 29 84 24 d0 04 	movapd %xmm0,0x4d0(%rsp)
  5b2ada:	00 00 
  5b2adc:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b2ae3:	00 
  5b2ae4:	48 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%rsi
  5b2aeb:	00 
  5b2aec:	ff 15 96 74 53 00    	call   *0x537496(%rip)        # ae9f88 <_DYNAMIC+0x3d8>
  5b2af2:	48 8b 04 24          	mov    (%rsp),%rax
  5b2af6:	48 ff 80 30 09 00 00 	incq   0x930(%rax)
  5b2afd:	48 8b 80 c8 02 00 00 	mov    0x2c8(%rax),%rax
  5b2b04:	48 89 84 24 70 03 00 	mov    %rax,0x370(%rsp)
  5b2b0b:	00 
  5b2b0c:	48 85 c0             	test   %rax,%rax
  5b2b0f:	0f 84 6e 13 00 00    	je     5b3e83 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x32d3>
  5b2b15:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  5b2b1b:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  5b2b1f:	f2 0f 11 84 24 78 03 	movsd  %xmm0,0x378(%rsp)
  5b2b26:	00 00 
  5b2b28:	48 8b 04 24          	mov    (%rsp),%rax
  5b2b2c:	48 05 30 08 00 00    	add    $0x830,%rax
  5b2b32:	48 89 84 24 68 03 00 	mov    %rax,0x368(%rsp)
  5b2b39:	00 
  5b2b3a:	45 31 e4             	xor    %r12d,%r12d
  5b2b3d:	48 8d 05 ac 61 50 00 	lea    0x5061ac(%rip),%rax        # ab8cf0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0xc0>
  5b2b44:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  5b2b49:	48 b8 00 00 00 00 00 	movabs $0x8000000000000000,%rax
  5b2b50:	00 00 80 
  5b2b53:	48 ff c0             	inc    %rax
  5b2b56:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  5b2b5d:	00 
  5b2b5e:	48 8d 05 3b 60 50 00 	lea    0x50603b(%rip),%rax        # ab8ba0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x130>
  5b2b65:	48 89 84 24 68 02 00 	mov    %rax,0x268(%rsp)
  5b2b6c:	00 
  5b2b6d:	48 8d 05 74 8f ac ff 	lea    -0x53708c(%rip),%rax        # 7bae8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5b2b74:	48 89 84 24 60 02 00 	mov    %rax,0x260(%rsp)
  5b2b7b:	00 
  5b2b7c:	48 8d 05 7d 5c 50 00 	lea    0x505c7d(%rip),%rax        # ab8800 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x60>
  5b2b83:	48 89 84 24 e8 01 00 	mov    %rax,0x1e8(%rsp)
  5b2b8a:	00 
  5b2b8b:	48 8d 05 8e 61 50 00 	lea    0x50618e(%rip),%rax        # ab8d20 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0xf0>
  5b2b92:	48 89 84 24 58 02 00 	mov    %rax,0x258(%rsp)
  5b2b99:	00 
  5b2b9a:	eb 35                	jmp    5b2bd1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2021>
  5b2b9c:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5b2ba3:	00 
  5b2ba4:	44 89 24 98          	mov    %r12d,(%rax,%rbx,4)
  5b2ba8:	48 ff c3             	inc    %rbx
  5b2bab:	48 89 9c 24 b8 00 00 	mov    %rbx,0xb8(%rsp)
  5b2bb2:	00 
  5b2bb3:	4c 8b a4 24 80 03 00 	mov    0x380(%rsp),%r12
  5b2bba:	00 
  5b2bbb:	4c 3b a4 24 70 03 00 	cmp    0x370(%rsp),%r12
  5b2bc2:	00 
  5b2bc3:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  5b2bca:	00 
  5b2bcb:	0f 84 b2 12 00 00    	je     5b3e83 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x32d3>
  5b2bd1:	48 8b 04 24          	mov    (%rsp),%rax
  5b2bd5:	4c 8b b8 40 07 00 00 	mov    0x740(%rax),%r15
  5b2bdc:	4d 39 fc             	cmp    %r15,%r12
  5b2bdf:	0f 83 1e 22 00 00    	jae    5b4e03 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4253>
  5b2be5:	48 8b 80 38 07 00 00 	mov    0x738(%rax),%rax
  5b2bec:	4c 89 e1             	mov    %r12,%rcx
  5b2bef:	48 c1 e1 04          	shl    $0x4,%rcx
  5b2bf3:	66 0f 10 04 08       	movupd (%rax,%rcx,1),%xmm0
  5b2bf8:	66 0f 29 84 24 70 04 	movapd %xmm0,0x470(%rsp)
  5b2bff:	00 00 
  5b2c01:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b2c08:	00 
  5b2c09:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  5b2c0e:	48 8d 94 24 70 04 00 	lea    0x470(%rsp),%rdx
  5b2c15:	00 
  5b2c16:	ff 15 74 73 53 00    	call   *0x537374(%rip)        # ae9f90 <_DYNAMIC+0x3e0>
  5b2c1c:	80 bc 24 d0 04 00 00 	cmpb   $0x0,0x4d0(%rsp)
  5b2c23:	00 
  5b2c24:	0f 85 c1 17 00 00    	jne    5b43eb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x383b>
  5b2c2a:	49 8d 74 24 01       	lea    0x1(%r12),%rsi
  5b2c2f:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b2c33:	48 8b 81 c8 02 00 00 	mov    0x2c8(%rcx),%rax
  5b2c3a:	48 39 c6             	cmp    %rax,%rsi
  5b2c3d:	73 26                	jae    5b2c65 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x20b5>
  5b2c3f:	48 8b 89 c0 02 00 00 	mov    0x2c0(%rcx),%rcx
  5b2c46:	48 8d 14 b6          	lea    (%rsi,%rsi,4),%rdx
  5b2c4a:	8b 4c d1 18          	mov    0x18(%rcx,%rdx,8),%ecx
  5b2c4e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  5b2c53:	48 39 d1             	cmp    %rdx,%rcx
  5b2c56:	0f 95 c2             	setne  %dl
  5b2c59:	49 39 cc             	cmp    %rcx,%r12
  5b2c5c:	40 0f 94 c7          	sete   %dil
  5b2c60:	40 20 d7             	and    %dl,%dil
  5b2c63:	eb 02                	jmp    5b2c67 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x20b7>
  5b2c65:	31 ff                	xor    %edi,%edi
  5b2c67:	f2 0f 10 9c 24 14 05 	movsd  0x514(%rsp),%xmm3
  5b2c6e:	00 00 
  5b2c70:	f2 0f 10 84 24 1c 05 	movsd  0x51c(%rsp),%xmm0
  5b2c77:	00 00 
  5b2c79:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  5b2c80:	00 
  5b2c81:	0f 10 84 24 e4 04 00 	movups 0x4e4(%rsp),%xmm0
  5b2c88:	00 
  5b2c89:	0f 29 84 24 e0 02 00 	movaps %xmm0,0x2e0(%rsp)
  5b2c90:	00 
  5b2c91:	f3 0f 10 8c 24 e8 04 	movss  0x4e8(%rsp),%xmm1
  5b2c98:	00 00 
  5b2c9a:	0f 10 84 24 f4 04 00 	movups 0x4f4(%rsp),%xmm0
  5b2ca1:	00 
  5b2ca2:	0f 29 84 24 20 02 00 	movaps %xmm0,0x220(%rsp)
  5b2ca9:	00 
  5b2caa:	f3 0f 10 94 24 fc 04 	movss  0x4fc(%rsp),%xmm2
  5b2cb1:	00 00 
  5b2cb3:	f3 0f 10 84 24 f8 04 	movss  0x4f8(%rsp),%xmm0
  5b2cba:	00 00 
  5b2cbc:	f3 0f 11 84 24 84 00 	movss  %xmm0,0x84(%rsp)
  5b2cc3:	00 00 
  5b2cc5:	f2 0f 10 84 24 24 05 	movsd  0x524(%rsp),%xmm0
  5b2ccc:	00 00 
  5b2cce:	0f 29 84 24 d0 02 00 	movaps %xmm0,0x2d0(%rsp)
  5b2cd5:	00 
  5b2cd6:	48 8b 8c 24 88 03 00 	mov    0x388(%rsp),%rcx
  5b2cdd:	00 
  5b2cde:	48 8b 09             	mov    (%rcx),%rcx
  5b2ce1:	48 8d 1d 80 8d ac ff 	lea    -0x537280(%rip),%rbx        # 7ba68 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x8>
  5b2ce8:	48 85 c9             	test   %rcx,%rcx
  5b2ceb:	74 61                	je     5b2d4e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x219e>
  5b2ced:	83 f9 02             	cmp    $0x2,%ecx
  5b2cf0:	75 3d                	jne    5b2d2f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x217f>
  5b2cf2:	48 8b 14 24          	mov    (%rsp),%rdx
  5b2cf6:	4c 8b ba 48 02 00 00 	mov    0x248(%rdx),%r15
  5b2cfd:	4d 39 fc             	cmp    %r15,%r12
  5b2d00:	0f 83 e5 20 00 00    	jae    5b4deb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x423b>
  5b2d06:	4c 8b ba 38 02 00 00 	mov    0x238(%rdx),%r15
  5b2d0d:	48 8b 8a 40 02 00 00 	mov    0x240(%rdx),%rcx
  5b2d14:	42 0f b6 0c 21       	movzbl (%rcx,%r12,1),%ecx
  5b2d19:	49 39 cf             	cmp    %rcx,%r15
  5b2d1c:	0f 86 d2 20 00 00    	jbe    5b4df4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4244>
  5b2d22:	48 6b d9 58          	imul   $0x58,%rcx,%rbx
  5b2d26:	48 03 9a 30 02 00 00 	add    0x230(%rdx),%rbx
  5b2d2d:	eb 1f                	jmp    5b2d4e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x219e>
  5b2d2f:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b2d33:	4c 8b b9 40 02 00 00 	mov    0x240(%rcx),%r15
  5b2d3a:	4d 39 fc             	cmp    %r15,%r12
  5b2d3d:	0f 83 9f 20 00 00    	jae    5b4de2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4232>
  5b2d43:	49 6b dc 58          	imul   $0x58,%r12,%rbx
  5b2d47:	48 03 99 38 02 00 00 	add    0x238(%rcx),%rbx
  5b2d4e:	f3 0f 11 8c 24 c0 02 	movss  %xmm1,0x2c0(%rsp)
  5b2d55:	00 00 
  5b2d57:	89 bc 24 08 02 00 00 	mov    %edi,0x208(%rsp)
  5b2d5e:	49 39 c4             	cmp    %rax,%r12
  5b2d61:	0f 83 2d 20 00 00    	jae    5b4d94 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41e4>
  5b2d67:	48 89 b4 24 80 03 00 	mov    %rsi,0x380(%rsp)
  5b2d6e:	00 
  5b2d6f:	48 8b 04 24          	mov    (%rsp),%rax
  5b2d73:	4c 8b b0 c0 02 00 00 	mov    0x2c0(%rax),%r14
  5b2d7a:	4f 8d 2c a4          	lea    (%r12,%r12,4),%r13
  5b2d7e:	47 8b 64 ee 18       	mov    0x18(%r14,%r13,8),%r12d
  5b2d83:	f2 0f 10 84 24 78 03 	movsd  0x378(%rsp),%xmm0
  5b2d8a:	00 00 
  5b2d8c:	f2 0f 11 84 24 d0 04 	movsd  %xmm0,0x4d0(%rsp)
  5b2d93:	00 00 
  5b2d95:	48 8d 84 24 d8 04 00 	lea    0x4d8(%rsp),%rax
  5b2d9c:	00 
  5b2d9d:	0f 57 c9             	xorps  %xmm1,%xmm1
  5b2da0:	0f 11 08             	movups %xmm1,(%rax)
  5b2da3:	f2 0f 11 84 24 e8 04 	movsd  %xmm0,0x4e8(%rsp)
  5b2daa:	00 00 
  5b2dac:	0f 11 48 18          	movups %xmm1,0x18(%rax)
  5b2db0:	c6 40 28 00          	movb   $0x0,0x28(%rax)
  5b2db4:	48 8d 84 24 d0 04 00 	lea    0x4d0(%rsp),%rax
  5b2dbb:	00 
  5b2dbc:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  5b2dc1:	49 39 cc             	cmp    %rcx,%r12
  5b2dc4:	74 1d                	je     5b2de3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2233>
  5b2dc6:	4c 8b bc 24 40 01 00 	mov    0x140(%rsp),%r15
  5b2dcd:	00 
  5b2dce:	4d 39 e7             	cmp    %r12,%r15
  5b2dd1:	0f 86 c9 1f 00 00    	jbe    5b4da0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41f0>
  5b2dd7:	49 6b c4 38          	imul   $0x38,%r12,%rax
  5b2ddb:	48 03 84 24 38 01 00 	add    0x138(%rsp),%rax
  5b2de2:	00 
  5b2de3:	f3 0f 11 94 24 0c 02 	movss  %xmm2,0x20c(%rsp)
  5b2dea:	00 00 
  5b2dec:	48 8b 48 30          	mov    0x30(%rax),%rcx
  5b2df0:	48 89 8c 24 a0 04 00 	mov    %rcx,0x4a0(%rsp)
  5b2df7:	00 
  5b2df8:	0f 10 00             	movups (%rax),%xmm0
  5b2dfb:	0f 10 48 10          	movups 0x10(%rax),%xmm1
  5b2dff:	0f 10 50 20          	movups 0x20(%rax),%xmm2
  5b2e03:	0f 29 94 24 90 04 00 	movaps %xmm2,0x490(%rsp)
  5b2e0a:	00 
  5b2e0b:	0f 29 8c 24 80 04 00 	movaps %xmm1,0x480(%rsp)
  5b2e12:	00 
  5b2e13:	0f 29 84 24 70 04 00 	movaps %xmm0,0x470(%rsp)
  5b2e1a:	00 
  5b2e1b:	66 0f 28 05 2d ac ab 	movapd -0x5453d3(%rip),%xmm0        # 6da50 <anon.1f6b7bab1fc61e0fcd36456038a862fb.80.llvm.5148459089407822190+0x290>
  5b2e22:	ff 
  5b2e23:	66 0f 29 84 24 f0 00 	movapd %xmm0,0xf0(%rsp)
  5b2e2a:	00 00 
  5b2e2c:	0f 29 9c 24 d0 0b 00 	movaps %xmm3,0xbd0(%rsp)
  5b2e33:	00 
  5b2e34:	0f 13 9c 24 00 01 00 	movlps %xmm3,0x100(%rsp)
  5b2e3b:	00 
  5b2e3c:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b2e43:	00 
  5b2e44:	48 8d b4 24 70 04 00 	lea    0x470(%rsp),%rsi
  5b2e4b:	00 
  5b2e4c:	48 8d 94 24 f0 00 00 	lea    0xf0(%rsp),%rdx
  5b2e53:	00 
  5b2e54:	ff 15 3e 71 53 00    	call   *0x53713e(%rip)        # ae9f98 <_DYNAMIC+0x3e8>
  5b2e5a:	48 8b 43 4c          	mov    0x4c(%rbx),%rax
  5b2e5e:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
  5b2e65:	00 
  5b2e66:	66 0f 10 43 3c       	movupd 0x3c(%rbx),%xmm0
  5b2e6b:	66 0f 29 84 24 f0 00 	movapd %xmm0,0xf0(%rsp)
  5b2e72:	00 00 
  5b2e74:	48 8d bc 24 30 09 00 	lea    0x930(%rsp),%rdi
  5b2e7b:	00 
  5b2e7c:	48 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%rsi
  5b2e83:	00 
  5b2e84:	48 8d 94 24 f0 00 00 	lea    0xf0(%rsp),%rdx
  5b2e8b:	00 
  5b2e8c:	ff 15 06 71 53 00    	call   *0x537106(%rip)        # ae9f98 <_DYNAMIC+0x3e8>
  5b2e92:	4c 8b bc 24 40 01 00 	mov    0x140(%rsp),%r15
  5b2e99:	00 
  5b2e9a:	4c 3b bc 24 30 01 00 	cmp    0x130(%rsp),%r15
  5b2ea1:	00 
  5b2ea2:	75 0d                	jne    5b2eb1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2301>
  5b2ea4:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  5b2eab:	00 
  5b2eac:	e8 6f a6 21 00       	call   7cd520 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs1rQ3kaVqKLB_20gpui_reactivity_core8geometry15CoordinateSpaceE8grow_oneCs6gaF1xUz9Bf_4gpui>
  5b2eb1:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  5b2eb8:	00 
  5b2eb9:	49 6b cf 38          	imul   $0x38,%r15,%rcx
  5b2ebd:	48 8b 94 24 60 09 00 	mov    0x960(%rsp),%rdx
  5b2ec4:	00 
  5b2ec5:	48 89 54 08 30       	mov    %rdx,0x30(%rax,%rcx,1)
  5b2eca:	0f 28 84 24 30 09 00 	movaps 0x930(%rsp),%xmm0
  5b2ed1:	00 
  5b2ed2:	0f 28 8c 24 40 09 00 	movaps 0x940(%rsp),%xmm1
  5b2ed9:	00 
  5b2eda:	0f 28 94 24 50 09 00 	movaps 0x950(%rsp),%xmm2
  5b2ee1:	00 
  5b2ee2:	0f 11 54 08 20       	movups %xmm2,0x20(%rax,%rcx,1)
  5b2ee7:	0f 11 4c 08 10       	movups %xmm1,0x10(%rax,%rcx,1)
  5b2eec:	0f 11 04 08          	movups %xmm0,(%rax,%rcx,1)
  5b2ef0:	66 0f 5a 84 24 30 09 	cvtpd2ps 0x930(%rsp),%xmm0
  5b2ef7:	00 00 
  5b2ef9:	66 0f 29 44 24 10    	movapd %xmm0,0x10(%rsp)
  5b2eff:	49 ff c7             	inc    %r15
  5b2f02:	66 0f 5a 84 24 40 09 	cvtpd2ps 0x940(%rsp),%xmm0
  5b2f09:	00 00 
  5b2f0b:	66 0f 29 84 24 40 02 	movapd %xmm0,0x240(%rsp)
  5b2f12:	00 00 
  5b2f14:	4c 89 bc 24 40 01 00 	mov    %r15,0x140(%rsp)
  5b2f1b:	00 
  5b2f1c:	66 0f 5a 84 24 50 09 	cvtpd2ps 0x950(%rsp),%xmm0
  5b2f23:	00 00 
  5b2f25:	66 0f 29 44 24 30    	movapd %xmm0,0x30(%rsp)
  5b2f2b:	48 8d bc 24 30 09 00 	lea    0x930(%rsp),%rdi
  5b2f32:	00 
  5b2f33:	ff 15 67 70 53 00    	call   *0x537067(%rip)        # ae9fa0 <_DYNAMIC+0x3f0>
  5b2f39:	c7 44 24 60 00 00 00 	movl   $0x0,0x60(%rsp)
  5b2f40:	00 
  5b2f41:	84 c0                	test   %al,%al
  5b2f43:	0f 84 a1 00 00 00    	je     5b2fea <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x243a>
  5b2f49:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  5b2f4e:	66 0f 14 84 24 40 02 	unpcklpd 0x240(%rsp),%xmm0
  5b2f55:	00 00 
  5b2f57:	0f 29 84 24 10 02 00 	movaps %xmm0,0x210(%rsp)
  5b2f5e:	00 
  5b2f5f:	0f 29 84 24 d0 04 00 	movaps %xmm0,0x4d0(%rsp)
  5b2f66:	00 
  5b2f67:	66 0f 28 44 24 30    	movapd 0x30(%rsp),%xmm0
  5b2f6d:	66 0f 13 84 24 e0 04 	movlpd %xmm0,0x4e0(%rsp)
  5b2f74:	00 00 
  5b2f76:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b2f7d:	00 
  5b2f7e:	ff 15 24 70 53 00    	call   *0x537024(%rip)        # ae9fa8 <_DYNAMIC+0x3f8>
  5b2f84:	84 c0                	test   %al,%al
  5b2f86:	74 62                	je     5b2fea <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x243a>
  5b2f88:	0f 28 84 24 10 02 00 	movaps 0x210(%rsp),%xmm0
  5b2f8f:	00 
  5b2f90:	0f 29 84 24 d0 04 00 	movaps %xmm0,0x4d0(%rsp)
  5b2f97:	00 
  5b2f98:	66 0f 28 44 24 30    	movapd 0x30(%rsp),%xmm0
  5b2f9e:	66 0f 13 84 24 e0 04 	movlpd %xmm0,0x4e0(%rsp)
  5b2fa5:	00 00 
  5b2fa7:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b2fae:	00 
  5b2faf:	ff 15 fb 6f 53 00    	call   *0x536ffb(%rip)        # ae9fb0 <_DYNAMIC+0x400>
  5b2fb5:	84 c0                	test   %al,%al
  5b2fb7:	74 31                	je     5b2fea <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x243a>
  5b2fb9:	c7 44 24 60 01 00 00 	movl   $0x1,0x60(%rsp)
  5b2fc0:	00 
  5b2fc1:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  5b2fc6:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  5b2fcb:	0f 28 84 24 40 02 00 	movaps 0x240(%rsp),%xmm0
  5b2fd2:	00 
  5b2fd3:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  5b2fda:	00 
  5b2fdb:	66 0f 28 44 24 30    	movapd 0x30(%rsp),%xmm0
  5b2fe1:	66 0f 29 84 24 d0 01 	movapd %xmm0,0x1d0(%rsp)
  5b2fe8:	00 00 
  5b2fea:	4f 8d 2c ee          	lea    (%r14,%r13,8),%r13
  5b2fee:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  5b2ff4:	74 71                	je     5b3067 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x24b7>
  5b2ff6:	45 8b 65 18          	mov    0x18(%r13),%r12d
  5b2ffa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  5b2fff:	49 39 c4             	cmp    %rax,%r12
  5b3002:	0f 84 8b 00 00 00    	je     5b3093 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x24e3>
  5b3008:	4c 8b bc 24 58 01 00 	mov    0x158(%rsp),%r15
  5b300f:	00 
  5b3010:	4d 39 e7             	cmp    %r12,%r15
  5b3013:	0f 86 99 1d 00 00    	jbe    5b4db2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4202>
  5b3019:	48 8b 8c 24 50 01 00 	mov    0x150(%rsp),%rcx
  5b3020:	00 
  5b3021:	4c 89 e0             	mov    %r12,%rax
  5b3024:	48 c1 e0 04          	shl    $0x4,%rax
  5b3028:	66 0f 10 04 01       	movupd (%rcx,%rax,1),%xmm0
  5b302d:	66 0f 29 84 24 d0 00 	movapd %xmm0,0xd0(%rsp)
  5b3034:	00 00 
  5b3036:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
  5b303a:	66 0f 14 84 24 f0 02 	unpcklpd 0x2f0(%rsp),%xmm0
  5b3041:	00 00 
  5b3043:	66 0f 11 84 24 d0 04 	movupd %xmm0,0x4d0(%rsp)
  5b304a:	00 00 
  5b304c:	4c 8b bc 24 70 01 00 	mov    0x170(%rsp),%r15
  5b3053:	00 
  5b3054:	4d 39 e7             	cmp    %r12,%r15
  5b3057:	0f 86 5e 1d 00 00    	jbe    5b4dbb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x420b>
  5b305d:	48 03 84 24 68 01 00 	add    0x168(%rsp),%rax
  5b3064:	00 
  5b3065:	eb 53                	jmp    5b30ba <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x250a>
  5b3067:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
  5b306b:	66 0f 14 84 24 f0 02 	unpcklpd 0x2f0(%rsp),%xmm0
  5b3072:	00 00 
  5b3074:	66 0f 29 84 24 d0 00 	movapd %xmm0,0xd0(%rsp)
  5b307b:	00 00 
  5b307d:	66 0f 29 84 24 a0 01 	movapd %xmm0,0x1a0(%rsp)
  5b3084:	00 00 
  5b3086:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%rsp)
  5b308d:	00 
  5b308e:	e9 c0 00 00 00       	jmp    5b3153 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x25a3>
  5b3093:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
  5b3097:	66 0f 14 84 24 f0 02 	unpcklpd 0x2f0(%rsp),%xmm0
  5b309e:	00 00 
  5b30a0:	66 0f 29 84 24 d0 00 	movapd %xmm0,0xd0(%rsp)
  5b30a7:	00 00 
  5b30a9:	66 0f 11 84 24 d0 04 	movupd %xmm0,0x4d0(%rsp)
  5b30b0:	00 00 
  5b30b2:	48 8d 84 24 d0 04 00 	lea    0x4d0(%rsp),%rax
  5b30b9:	00 
  5b30ba:	66 0f 10 00          	movupd (%rax),%xmm0
  5b30be:	66 0f 29 84 24 a0 01 	movapd %xmm0,0x1a0(%rsp)
  5b30c5:	00 00 
  5b30c7:	41 8b 45 20          	mov    0x20(%r13),%eax
  5b30cb:	83 e0 07             	and    $0x7,%eax
  5b30ce:	83 f8 05             	cmp    $0x5,%eax
  5b30d1:	73 34                	jae    5b3107 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2557>
  5b30d3:	4c 8b bc 24 88 01 00 	mov    0x188(%rsp),%r15
  5b30da:	00 
  5b30db:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  5b30df:	74 1c                	je     5b30fd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x254d>
  5b30e1:	4d 39 e7             	cmp    %r12,%r15
  5b30e4:	0f 86 ef 1c 00 00    	jbe    5b4dd9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4229>
  5b30ea:	48 8b 84 24 80 01 00 	mov    0x180(%rsp),%rax
  5b30f1:	00 
  5b30f2:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax
  5b30f7:	89 44 24 30          	mov    %eax,0x30(%rsp)
  5b30fb:	eb 24                	jmp    5b3121 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2571>
  5b30fd:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%rsp)
  5b3104:	00 
  5b3105:	eb 1a                	jmp    5b3121 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2571>
  5b3107:	74 0a                	je     5b3113 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2563>
  5b3109:	83 f8 06             	cmp    $0x6,%eax
  5b310c:	74 c5                	je     5b30d3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2523>
  5b310e:	e9 c5 1b 00 00       	jmp    5b4cd8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4128>
  5b3113:	b0 01                	mov    $0x1,%al
  5b3115:	89 44 24 30          	mov    %eax,0x30(%rsp)
  5b3119:	4c 8b bc 24 88 01 00 	mov    0x188(%rsp),%r15
  5b3120:	00 
  5b3121:	4c 3b bc 24 78 01 00 	cmp    0x178(%rsp),%r15
  5b3128:	00 
  5b3129:	75 0d                	jne    5b3138 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2588>
  5b312b:	48 8d bc 24 78 01 00 	lea    0x178(%rsp),%rdi
  5b3132:	00 
  5b3133:	e8 78 aa 21 00       	call   7cdbb0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecbE8grow_oneCs6gaF1xUz9Bf_4gpui>
  5b3138:	48 8b 84 24 80 01 00 	mov    0x180(%rsp),%rax
  5b313f:	00 
  5b3140:	8b 4c 24 30          	mov    0x30(%rsp),%ecx
  5b3144:	42 88 0c 38          	mov    %cl,(%rax,%r15,1)
  5b3148:	49 ff c7             	inc    %r15
  5b314b:	4c 89 bc 24 88 01 00 	mov    %r15,0x188(%rsp)
  5b3152:	00 
  5b3153:	41 8b 45 20          	mov    0x20(%r13),%eax
  5b3157:	83 e0 07             	and    $0x7,%eax
  5b315a:	b9 a1 00 00 00       	mov    $0xa1,%ecx
  5b315f:	48 89 8c 24 f8 01 00 	mov    %rcx,0x1f8(%rsp)
  5b3166:	00 
  5b3167:	b9 4f 00 00 00       	mov    $0x4f,%ecx
  5b316c:	0f a3 c1             	bt     %eax,%ecx
  5b316f:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
  5b3173:	66 0f 14 84 24 30 02 	unpcklpd 0x230(%rsp),%xmm0
  5b317a:	00 00 
  5b317c:	66 0f 29 44 24 10    	movapd %xmm0,0x10(%rsp)
  5b3182:	0f 82 e3 00 00 00    	jb     5b326b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x26bb>
  5b3188:	b9 30 00 00 00       	mov    $0x30,%ecx
  5b318d:	0f a3 c1             	bt     %eax,%ecx
  5b3190:	0f 83 3c 1a 00 00    	jae    5b4bd2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4022>
  5b3196:	8b 44 24 60          	mov    0x60(%rsp),%eax
  5b319a:	89 84 24 f0 00 00 00 	mov    %eax,0xf0(%rsp)
  5b31a1:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  5b31a6:	66 0f 14 84 24 c0 00 	unpcklpd 0xc0(%rsp),%xmm0
  5b31ad:	00 00 
  5b31af:	0f 11 84 24 f4 00 00 	movups %xmm0,0xf4(%rsp)
  5b31b6:	00 
  5b31b7:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  5b31be:	00 
  5b31bf:	0f 13 84 24 04 01 00 	movlps %xmm0,0x104(%rsp)
  5b31c6:	00 
  5b31c7:	66 0f 28 44 24 10    	movapd 0x10(%rsp),%xmm0
  5b31cd:	66 0f 11 84 24 e0 00 	movupd %xmm0,0xe0(%rsp)
  5b31d4:	00 00 
  5b31d6:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b31dd:	00 
  5b31de:	48 8d b4 24 d0 00 00 	lea    0xd0(%rsp),%rsi
  5b31e5:	00 
  5b31e6:	48 8d 94 24 a0 01 00 	lea    0x1a0(%rsp),%rdx
  5b31ed:	00 
  5b31ee:	48 8d 8c 24 f0 00 00 	lea    0xf0(%rsp),%rcx
  5b31f5:	00 
  5b31f6:	4c 8d 84 24 e0 00 00 	lea    0xe0(%rsp),%r8
  5b31fd:	00 
  5b31fe:	4c 8b 8c 24 90 00 00 	mov    0x90(%rsp),%r9
  5b3205:	00 
  5b3206:	e8 15 bd 21 00       	call   7cef20 <_RNvNtNtCs6gaF1xUz9Bf_4gpui7runtime4list13viewport_clip>
  5b320b:	4c 8b bc 24 d0 04 00 	mov    0x4d0(%rsp),%r15
  5b3212:	00 
  5b3213:	44 8b a4 24 d8 04 00 	mov    0x4d8(%rsp),%r12d
  5b321a:	00 
  5b321b:	8b ac 24 dc 04 00 00 	mov    0x4dc(%rsp),%ebp
  5b3222:	f3 0f 6f 84 24 e0 04 	movdqu 0x4e0(%rsp),%xmm0
  5b3229:	00 00 
  5b322b:	48 8b 84 24 f0 04 00 	mov    0x4f0(%rsp),%rax
  5b3232:	00 
  5b3233:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  5b3237:	0f 85 26 18 00 00    	jne    5b4a63 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3eb3>
  5b323d:	44 89 a4 24 d0 00 00 	mov    %r12d,0xd0(%rsp)
  5b3244:	00 
  5b3245:	89 ac 24 d4 00 00 00 	mov    %ebp,0xd4(%rsp)
  5b324c:	66 0f d6 84 24 d8 00 	movq   %xmm0,0xd8(%rsp)
  5b3253:	00 00 
  5b3255:	66 0f 70 c0 ee       	pshufd $0xee,%xmm0,%xmm0
  5b325a:	66 0f d6 84 24 a0 01 	movq   %xmm0,0x1a0(%rsp)
  5b3261:	00 00 
  5b3263:	48 89 84 24 a8 01 00 	mov    %rax,0x1a8(%rsp)
  5b326a:	00 
  5b326b:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  5b3271:	0f 84 8e 00 00 00    	je     5b3305 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2755>
  5b3277:	4c 8b b4 24 58 01 00 	mov    0x158(%rsp),%r14
  5b327e:	00 
  5b327f:	4c 3b b4 24 48 01 00 	cmp    0x148(%rsp),%r14
  5b3286:	00 
  5b3287:	75 0d                	jne    5b3296 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x26e6>
  5b3289:	48 8d bc 24 48 01 00 	lea    0x148(%rsp),%rdi
  5b3290:	00 
  5b3291:	e8 fa a2 21 00       	call   7cd590 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs1rQ3kaVqKLB_20gpui_reactivity_core8geometry4RectE8grow_oneCs6gaF1xUz9Bf_4gpui>
  5b3296:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  5b329d:	00 
  5b329e:	4c 89 f1             	mov    %r14,%rcx
  5b32a1:	48 c1 e1 04          	shl    $0x4,%rcx
  5b32a5:	66 0f 28 84 24 d0 00 	movapd 0xd0(%rsp),%xmm0
  5b32ac:	00 00 
  5b32ae:	66 0f 11 04 08       	movupd %xmm0,(%rax,%rcx,1)
  5b32b3:	49 ff c6             	inc    %r14
  5b32b6:	4c 89 b4 24 58 01 00 	mov    %r14,0x158(%rsp)
  5b32bd:	00 
  5b32be:	4c 8b b4 24 70 01 00 	mov    0x170(%rsp),%r14
  5b32c5:	00 
  5b32c6:	4c 3b b4 24 60 01 00 	cmp    0x160(%rsp),%r14
  5b32cd:	00 
  5b32ce:	75 0d                	jne    5b32dd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x272d>
  5b32d0:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  5b32d7:	00 
  5b32d8:	e8 b3 a2 21 00       	call   7cd590 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs1rQ3kaVqKLB_20gpui_reactivity_core8geometry4RectE8grow_oneCs6gaF1xUz9Bf_4gpui>
  5b32dd:	48 8b 84 24 68 01 00 	mov    0x168(%rsp),%rax
  5b32e4:	00 
  5b32e5:	4c 89 f1             	mov    %r14,%rcx
  5b32e8:	48 c1 e1 04          	shl    $0x4,%rcx
  5b32ec:	66 0f 6f 84 24 a0 01 	movdqa 0x1a0(%rsp),%xmm0
  5b32f3:	00 00 
  5b32f5:	f3 0f 7f 04 08       	movdqu %xmm0,(%rax,%rcx,1)
  5b32fa:	49 ff c6             	inc    %r14
  5b32fd:	4c 89 b4 24 70 01 00 	mov    %r14,0x170(%rsp)
  5b3304:	00 
  5b3305:	83 7c 24 60 00       	cmpl   $0x0,0x60(%rsp)
  5b330a:	74 7a                	je     5b3386 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x27d6>
  5b330c:	0f 5a 44 24 40       	cvtps2pd 0x40(%rsp),%xmm0
  5b3311:	0f 29 84 24 d0 04 00 	movaps %xmm0,0x4d0(%rsp)
  5b3318:	00 
  5b3319:	0f 5a 84 24 c0 00 00 	cvtps2pd 0xc0(%rsp),%xmm0
  5b3320:	00 
  5b3321:	0f 5a 8c 24 d0 01 00 	cvtps2pd 0x1d0(%rsp),%xmm1
  5b3328:	00 
  5b3329:	0f 29 84 24 e0 04 00 	movaps %xmm0,0x4e0(%rsp)
  5b3330:	00 
  5b3331:	0f 29 8c 24 f0 04 00 	movaps %xmm1,0x4f0(%rsp)
  5b3338:	00 
  5b3339:	c6 84 24 00 05 00 00 	movb   $0x0,0x500(%rsp)
  5b3340:	00 
  5b3341:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
  5b3347:	f3 0f 7f 84 24 e0 00 	movdqu %xmm0,0xe0(%rsp)
  5b334e:	00 00 
  5b3350:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  5b3357:	00 
  5b3358:	48 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%rsi
  5b335f:	00 
  5b3360:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
  5b3367:	00 
  5b3368:	ff 15 4a 6c 53 00    	call   *0x536c4a(%rip)        # ae9fb8 <_DYNAMIC+0x408>
  5b336e:	83 bc 24 f0 00 00 00 	cmpl   $0x1,0xf0(%rsp)
  5b3375:	01 
  5b3376:	75 0e                	jne    5b3386 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x27d6>
  5b3378:	48 8d 84 24 f4 00 00 	lea    0xf4(%rsp),%rax
  5b337f:	00 
  5b3380:	f3 0f 6f 00          	movdqu (%rax),%xmm0
  5b3384:	eb 04                	jmp    5b338a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x27da>
  5b3386:	66 0f ef c0          	pxor   %xmm0,%xmm0
  5b338a:	66 0f 7f 84 24 00 03 	movdqa %xmm0,0x300(%rsp)
  5b3391:	00 00 
  5b3393:	80 7c 24 30 00       	cmpb   $0x0,0x30(%rsp)
  5b3398:	74 22                	je     5b33bc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x280c>
  5b339a:	48 8d bc 24 18 03 00 	lea    0x318(%rsp),%rdi
  5b33a1:	00 
  5b33a2:	48 8d b4 24 00 03 00 	lea    0x300(%rsp),%rsi
  5b33a9:	00 
  5b33aa:	48 8d 94 24 a0 01 00 	lea    0x1a0(%rsp),%rdx
  5b33b1:	00 
  5b33b2:	e8 e9 be 21 00       	call   7cf2a0 <_RNvNtNtCs6gaF1xUz9Bf_4gpui7runtime4list14clipped_bounds>
  5b33b7:	e9 82 00 00 00       	jmp    5b343e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x288e>
  5b33bc:	41 8b 45 20          	mov    0x20(%r13),%eax
  5b33c0:	83 e0 07             	and    $0x7,%eax
  5b33c3:	b9 6f 00 00 00       	mov    $0x6f,%ecx
  5b33c8:	0f a3 c1             	bt     %eax,%ecx
  5b33cb:	0f 83 a4 0a 00 00    	jae    5b3e75 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x32c5>
  5b33d1:	f2 0f 10 84 24 00 03 	movsd  0x300(%rsp),%xmm0
  5b33d8:	00 00 
  5b33da:	f2 0f 10 8c 24 08 03 	movsd  0x308(%rsp),%xmm1
  5b33e1:	00 00 
  5b33e3:	0f 28 d0             	movaps %xmm0,%xmm2
  5b33e6:	0f 58 c8             	addps  %xmm0,%xmm1
  5b33e9:	0f 57 e4             	xorps  %xmm4,%xmm4
  5b33ec:	0f 5f c4             	maxps  %xmm4,%xmm0
  5b33ef:	0f 28 d8             	movaps %xmm0,%xmm3
  5b33f2:	0f c2 d8 03          	cmpunordps %xmm0,%xmm3
  5b33f6:	0f 54 d3             	andps  %xmm3,%xmm2
  5b33f9:	0f 55 d8             	andnps %xmm0,%xmm3
  5b33fc:	0f 56 da             	orps   %xmm2,%xmm3
  5b33ff:	0f 28 c1             	movaps %xmm1,%xmm0
  5b3402:	0f 5d 84 24 f0 02 00 	minps  0x2f0(%rsp),%xmm0
  5b3409:	00 
  5b340a:	0f 28 d0             	movaps %xmm0,%xmm2
  5b340d:	0f c2 d0 03          	cmpunordps %xmm0,%xmm2
  5b3411:	0f 54 ca             	andps  %xmm2,%xmm1
  5b3414:	0f 55 d0             	andnps %xmm0,%xmm2
  5b3417:	0f 56 d1             	orps   %xmm1,%xmm2
  5b341a:	0f 5c d3             	subps  %xmm3,%xmm2
  5b341d:	0f 28 c2             	movaps %xmm2,%xmm0
  5b3420:	0f 5f c4             	maxps  %xmm4,%xmm0
  5b3423:	0f 28 c8             	movaps %xmm0,%xmm1
  5b3426:	0f c2 c8 03          	cmpunordps %xmm0,%xmm1
  5b342a:	0f 54 d1             	andps  %xmm1,%xmm2
  5b342d:	0f 55 c8             	andnps %xmm0,%xmm1
  5b3430:	0f 56 ca             	orps   %xmm2,%xmm1
  5b3433:	0f 16 d9             	movlhps %xmm1,%xmm3
  5b3436:	0f 11 9c 24 18 03 00 	movups %xmm3,0x318(%rsp)
  5b343d:	00 
  5b343e:	8b 43 38             	mov    0x38(%rbx),%eax
  5b3441:	b9 ff ff ff 3f       	mov    $0x3fffffff,%ecx
  5b3446:	21 c8                	and    %ecx,%eax
  5b3448:	3d 01 00 80 3f       	cmp    $0x3f800001,%eax
  5b344d:	b9 00 00 00 80       	mov    $0x80000000,%ecx
  5b3452:	0f 44 c1             	cmove  %ecx,%eax
  5b3455:	66 0f 6e c8          	movd   %eax,%xmm1
  5b3459:	0f 57 c0             	xorps  %xmm0,%xmm0
  5b345c:	66 0f 7e 8c 24 10 02 	movd   %xmm1,0x210(%rsp)
  5b3463:	00 00 
  5b3465:	0f 2e c8             	ucomiss %xmm0,%xmm1
  5b3468:	0f 86 b3 00 00 00    	jbe    5b3521 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2971>
  5b346e:	c7 84 24 d8 04 00 00 	movl   $0x1,0x4d8(%rsp)
  5b3475:	01 00 00 00 
  5b3479:	48 c7 84 24 d0 04 00 	movq   $0x22,0x4d0(%rsp)
  5b3480:	00 22 00 00 00 
  5b3485:	80 7c 24 60 00       	cmpb   $0x0,0x60(%rsp)
  5b348a:	0f 84 d5 12 00 00    	je     5b4765 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3bb5>
  5b3490:	4c 8d 73 2c          	lea    0x2c(%rbx),%r14
  5b3494:	4c 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%r15
  5b349b:	00 
  5b349c:	4c 89 ff             	mov    %r15,%rdi
  5b349f:	e8 4c 44 f8 ff       	call   5378f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime5ErrorEBF_.llvm.18178969024155037896>
  5b34a4:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  5b34a9:	66 0f 14 84 24 c0 00 	unpcklpd 0xc0(%rsp),%xmm0
  5b34b0:	00 00 
  5b34b2:	0f 29 84 24 e0 0b 00 	movaps %xmm0,0xbe0(%rsp)
  5b34b9:	00 
  5b34ba:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  5b34c1:	00 
  5b34c2:	0f 13 84 24 f0 0b 00 	movlps %xmm0,0xbf0(%rsp)
  5b34c9:	00 
  5b34ca:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  5b34d1:	00 
  5b34d2:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  5b34d9:	00 
  5b34da:	41 0f 10 06          	movups (%r14),%xmm0
  5b34de:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  5b34e5:	00 
  5b34e6:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  5b34eb:	0f 11 84 24 d0 04 00 	movups %xmm0,0x4d0(%rsp)
  5b34f2:	00 
  5b34f3:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b34fa:	00 
  5b34fb:	4c 89 fe             	mov    %r15,%rsi
  5b34fe:	48 8d 94 24 e0 0b 00 	lea    0xbe0(%rsp),%rdx
  5b3505:	00 
  5b3506:	48 8d 8c 24 e0 00 00 	lea    0xe0(%rsp),%rcx
  5b350d:	00 
  5b350e:	4c 8d 84 24 f0 00 00 	lea    0xf0(%rsp),%r8
  5b3515:	00 
  5b3516:	ff 15 a4 6a 53 00    	call   *0x536aa4(%rip)        # ae9fc0 <_DYNAMIC+0x410>
  5b351c:	e9 c5 00 00 00       	jmp    5b35e6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2a36>
  5b3521:	49 83 7d 08 00       	cmpq   $0x0,0x8(%r13)
  5b3526:	75 11                	jne    5b3539 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2989>
  5b3528:	41 8b 7d 20          	mov    0x20(%r13),%edi
  5b352c:	e8 ef 58 f9 ff       	call   548e20 <_RNvMsh_NtCs6gaF1xUz9Bf_4gpui7runtimeNtB5_4Node4kind>
  5b3531:	3c 02                	cmp    $0x2,%al
  5b3533:	0f 85 b9 00 00 00    	jne    5b35f2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2a42>
  5b3539:	c7 84 24 d8 04 00 00 	movl   $0x1,0x4d8(%rsp)
  5b3540:	01 00 00 00 
  5b3544:	48 c7 84 24 d0 04 00 	movq   $0x22,0x4d0(%rsp)
  5b354b:	00 22 00 00 00 
  5b3550:	80 7c 24 60 00       	cmpb   $0x0,0x60(%rsp)
  5b3555:	0f 84 0a 12 00 00    	je     5b4765 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3bb5>
  5b355b:	4c 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%r14
  5b3562:	00 
  5b3563:	4c 89 f7             	mov    %r14,%rdi
  5b3566:	e8 85 43 f8 ff       	call   5378f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime5ErrorEBF_.llvm.18178969024155037896>
  5b356b:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  5b3570:	66 0f 14 84 24 c0 00 	unpcklpd 0xc0(%rsp),%xmm0
  5b3577:	00 00 
  5b3579:	0f 29 84 24 00 0c 00 	movaps %xmm0,0xc00(%rsp)
  5b3580:	00 
  5b3581:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  5b3588:	00 
  5b3589:	0f 13 84 24 10 0c 00 	movlps %xmm0,0xc10(%rsp)
  5b3590:	00 
  5b3591:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  5b3598:	00 
  5b3599:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  5b35a0:	00 
  5b35a1:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  5b35a6:	0f 11 84 24 f0 00 00 	movups %xmm0,0xf0(%rsp)
  5b35ad:	00 
  5b35ae:	0f 10 05 1b a2 ab ff 	movups -0x545de5(%rip),%xmm0        # 6d7d0 <anon.1f6b7bab1fc61e0fcd36456038a862fb.80.llvm.5148459089407822190+0x10>
  5b35b5:	0f 29 84 24 d0 04 00 	movaps %xmm0,0x4d0(%rsp)
  5b35bc:	00 
  5b35bd:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b35c4:	00 
  5b35c5:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  5b35cc:	00 
  5b35cd:	48 8d 94 24 00 0c 00 	lea    0xc00(%rsp),%rdx
  5b35d4:	00 
  5b35d5:	48 8d 8c 24 e0 00 00 	lea    0xe0(%rsp),%rcx
  5b35dc:	00 
  5b35dd:	4d 89 f0             	mov    %r14,%r8
  5b35e0:	ff 15 da 69 53 00    	call   *0x5369da(%rip)        # ae9fc0 <_DYNAMIC+0x410>
  5b35e6:	41 89 c4             	mov    %eax,%r12d
  5b35e9:	83 f8 ff             	cmp    $0xffffffff,%eax
  5b35ec:	0f 85 71 09 00 00    	jne    5b3f63 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x33b3>
  5b35f2:	45 8b 75 20          	mov    0x20(%r13),%r14d
  5b35f6:	44 89 f0             	mov    %r14d,%eax
  5b35f9:	83 e0 07             	and    $0x7,%eax
  5b35fc:	83 f8 06             	cmp    $0x6,%eax
  5b35ff:	0f 83 5d 02 00 00    	jae    5b3862 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2cb2>
  5b3605:	45 89 f4             	mov    %r14d,%r12d
  5b3608:	41 c1 ec 03          	shr    $0x3,%r12d
  5b360c:	0f 84 56 02 00 00    	je     5b3868 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2cb8>
  5b3612:	48 8b 04 24          	mov    (%rsp),%rax
  5b3616:	4c 8b b8 e0 02 00 00 	mov    0x2e0(%rax),%r15
  5b361d:	41 ff cc             	dec    %r12d
  5b3620:	4d 39 e7             	cmp    %r12,%r15
  5b3623:	0f 86 80 17 00 00    	jbe    5b4da9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41f9>
  5b3629:	48 8b a8 d8 02 00 00 	mov    0x2d8(%rax),%rbp
  5b3630:	4b 8d 0c a4          	lea    (%r12,%r12,4),%rcx
  5b3634:	48 c1 e1 04          	shl    $0x4,%rcx
  5b3638:	48 8b 44 0d 00       	mov    0x0(%rbp,%rcx,1),%rax
  5b363d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  5b3641:	0f 84 2f 16 00 00    	je     5b4c76 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x40c6>
  5b3647:	0f 10 43 1c          	movups 0x1c(%rbx),%xmm0
  5b364b:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  5b3652:	00 
  5b3653:	48 8b 94 24 90 01 00 	mov    0x190(%rsp),%rdx
  5b365a:	00 
  5b365b:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  5b365f:	0f 84 23 15 00 00    	je     5b4b88 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3fd8>
  5b3665:	48 83 bc 24 20 01 00 	cmpq   $0x0,0x120(%rsp)
  5b366c:	00 00 
  5b366e:	0f 84 05 15 00 00    	je     5b4b79 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3fc9>
  5b3674:	48 01 cd             	add    %rcx,%rbp
  5b3677:	f3 0f 10 43 18       	movss  0x18(%rbx),%xmm0
  5b367c:	0f 28 8c 24 30 02 00 	movaps 0x230(%rsp),%xmm1
  5b3683:	00 
  5b3684:	f3 0f 5c 8c 24 20 02 	subss  0x220(%rsp),%xmm1
  5b368b:	00 00 
  5b368d:	f3 0f 5c 8c 24 84 00 	subss  0x84(%rsp),%xmm1
  5b3694:	00 00 
  5b3696:	f3 0f 5c 8c 24 e0 02 	subss  0x2e0(%rsp),%xmm1
  5b369d:	00 00 
  5b369f:	f3 0f 5c 8c 24 c0 02 	subss  0x2c0(%rsp),%xmm1
  5b36a6:	00 00 
  5b36a8:	f3 0f 5c 8c 24 d0 02 	subss  0x2d0(%rsp),%xmm1
  5b36af:	00 00 
  5b36b1:	f3 0f 5f 0d 53 a9 ab 	maxss  -0x5456ad(%rip),%xmm1        # 6e00c <anon.5f884de6e78125e25881320d811d32df.286.llvm.17146438997930651657+0x10>
  5b36b8:	ff 
  5b36b9:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5b36bd:	74 13                	je     5b36d2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2b22>
  5b36bf:	83 7d 38 01          	cmpl   $0x1,0x38(%rbp)
  5b36c3:	75 0d                	jne    5b36d2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2b22>
  5b36c5:	66 0f 7e c8          	movd   %xmm1,%eax
  5b36c9:	39 45 3c             	cmp    %eax,0x3c(%rbp)
  5b36cc:	0f 84 d3 00 00 00    	je     5b37a5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2bf5>
  5b36d2:	48 8b 55 40          	mov    0x40(%rbp),%rdx
  5b36d6:	48 8b 0a             	mov    (%rdx),%rcx
  5b36d9:	48 d1 e9             	shr    $1,%rcx
  5b36dc:	48 83 c2 10          	add    $0x10,%rdx
  5b36e0:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b36e7:	00 
  5b36e8:	48 8d b4 24 20 01 00 	lea    0x120(%rsp),%rsi
  5b36ef:	00 
  5b36f0:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  5b36f6:	f3 0f 11 8c 24 84 00 	movss  %xmm1,0x84(%rsp)
  5b36fd:	00 00 
  5b36ff:	ff 15 fb 67 53 00    	call   *0x5367fb(%rip)        # ae9f00 <_DYNAMIC+0x350>
  5b3705:	48 8b 9c 24 d0 04 00 	mov    0x4d0(%rsp),%rbx
  5b370c:	00 
  5b370d:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5b3711:	0f 84 6a 10 00 00    	je     5b4781 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3bd1>
  5b3717:	f2 0f 10 84 24 d8 04 	movsd  0x4d8(%rsp),%xmm0
  5b371e:	00 00 
  5b3720:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
  5b3727:	00 
  5b3728:	48 8d 8c 24 d8 04 00 	lea    0x4d8(%rsp),%rcx
  5b372f:	00 
  5b3730:	48 8b 41 28          	mov    0x28(%rcx),%rax
  5b3734:	48 89 84 24 10 01 00 	mov    %rax,0x110(%rsp)
  5b373b:	00 
  5b373c:	0f 10 41 08          	movups 0x8(%rcx),%xmm0
  5b3740:	0f 10 49 18          	movups 0x18(%rcx),%xmm1
  5b3744:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  5b374b:	00 
  5b374c:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  5b3753:	00 
  5b3754:	48 89 ef             	mov    %rbp,%rdi
  5b3757:	e8 b4 5f f7 ff       	call   529710 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime6ShapedEEB11_.llvm.18178969024155037896>
  5b375c:	48 89 5d 00          	mov    %rbx,0x0(%rbp)
  5b3760:	0f 28 84 24 c0 02 00 	movaps 0x2c0(%rsp),%xmm0
  5b3767:	00 
  5b3768:	0f 13 45 08          	movlps %xmm0,0x8(%rbp)
  5b376c:	0f 28 84 24 f0 00 00 	movaps 0xf0(%rsp),%xmm0
  5b3773:	00 
  5b3774:	0f 28 8c 24 00 01 00 	movaps 0x100(%rsp),%xmm1
  5b377b:	00 
  5b377c:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  5b3780:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  5b3784:	48 8b 84 24 10 01 00 	mov    0x110(%rsp),%rax
  5b378b:	00 
  5b378c:	48 89 45 30          	mov    %rax,0x30(%rbp)
  5b3790:	c7 45 38 01 00 00 00 	movl   $0x1,0x38(%rbp)
  5b3797:	f3 0f 10 84 24 84 00 	movss  0x84(%rsp),%xmm0
  5b379e:	00 00 
  5b37a0:	f3 0f 11 45 3c       	movss  %xmm0,0x3c(%rbp)
  5b37a5:	c7 84 24 d8 04 00 00 	movl   $0x1,0x4d8(%rsp)
  5b37ac:	01 00 00 00 
  5b37b0:	48 c7 84 24 d0 04 00 	movq   $0x22,0x4d0(%rsp)
  5b37b7:	00 22 00 00 00 
  5b37bc:	80 7c 24 60 00       	cmpb   $0x0,0x60(%rsp)
  5b37c1:	0f 84 ac 0f 00 00    	je     5b4773 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3bc3>
  5b37c7:	48 8d 9c 24 d0 04 00 	lea    0x4d0(%rsp),%rbx
  5b37ce:	00 
  5b37cf:	48 89 df             	mov    %rbx,%rdi
  5b37d2:	e8 19 41 f8 ff       	call   5378f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime5ErrorEBF_.llvm.18178969024155037896>
  5b37d7:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  5b37dc:	66 0f 14 84 24 c0 00 	unpcklpd 0xc0(%rsp),%xmm0
  5b37e3:	00 00 
  5b37e5:	0f 29 84 24 20 0c 00 	movaps %xmm0,0xc20(%rsp)
  5b37ec:	00 
  5b37ed:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  5b37f4:	00 
  5b37f5:	0f 13 84 24 30 0c 00 	movlps %xmm0,0xc30(%rsp)
  5b37fc:	00 
  5b37fd:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  5b3804:	00 
  5b3805:	0f 29 84 24 d0 04 00 	movaps %xmm0,0x4d0(%rsp)
  5b380c:	00 
  5b380d:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b3814:	00 
  5b3815:	48 8b b4 24 90 01 00 	mov    0x190(%rsp),%rsi
  5b381c:	00 
  5b381d:	48 89 ea             	mov    %rbp,%rdx
  5b3820:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  5b3827:	00 
  5b3828:	f3 0f 10 8c 24 0c 02 	movss  0x20c(%rsp),%xmm1
  5b382f:	00 00 
  5b3831:	48 8d 8c 24 20 0c 00 	lea    0xc20(%rsp),%rcx
  5b3838:	00 
  5b3839:	49 89 d8             	mov    %rbx,%r8
  5b383c:	4c 8d 8c 24 e0 00 00 	lea    0xe0(%rsp),%r9
  5b3843:	00 
  5b3844:	f3 0f 10 54 24 24    	movss  0x24(%rsp),%xmm2
  5b384a:	ff 15 78 67 53 00    	call   *0x536778(%rip)        # ae9fc8 <_DYNAMIC+0x418>
  5b3850:	41 89 c4             	mov    %eax,%r12d
  5b3853:	83 f8 ff             	cmp    $0xffffffff,%eax
  5b3856:	0f 85 07 07 00 00    	jne    5b3f63 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x33b3>
  5b385c:	45 8b 75 20          	mov    0x20(%r13),%r14d
  5b3860:	eb 06                	jmp    5b3868 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2cb8>
  5b3862:	0f 85 6a 13 00 00    	jne    5b4bd2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4022>
  5b3868:	44 89 f0             	mov    %r14d,%eax
  5b386b:	83 e0 07             	and    $0x7,%eax
  5b386e:	83 f8 06             	cmp    $0x6,%eax
  5b3871:	0f 83 62 01 00 00    	jae    5b39d9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2e29>
  5b3877:	45 8b 65 18          	mov    0x18(%r13),%r12d
  5b387b:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  5b3881:	74 2b                	je     5b38ae <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2cfe>
  5b3883:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  5b3887:	74 1f                	je     5b38a8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2cf8>
  5b3889:	4c 8b bc 24 b8 00 00 	mov    0xb8(%rsp),%r15
  5b3890:	00 
  5b3891:	4d 39 e7             	cmp    %r12,%r15
  5b3894:	0f 86 36 15 00 00    	jbe    5b4dd0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4220>
  5b389a:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5b38a1:	00 
  5b38a2:	46 8b 24 a0          	mov    (%rax,%r12,4),%r12d
  5b38a6:	eb 06                	jmp    5b38ae <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2cfe>
  5b38a8:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
  5b38ae:	80 7c 24 30 00       	cmpb   $0x0,0x30(%rsp)
  5b38b3:	74 2b                	je     5b38e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2d30>
  5b38b5:	f3 0f 10 84 24 20 03 	movss  0x320(%rsp),%xmm0
  5b38bc:	00 00 
  5b38be:	0f 57 c9             	xorps  %xmm1,%xmm1
  5b38c1:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5b38c4:	75 06                	jne    5b38cc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2d1c>
  5b38c6:	0f 8b 9f 00 00 00    	jnp    5b396b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2dbb>
  5b38cc:	f3 0f 10 84 24 24 03 	movss  0x324(%rsp),%xmm0
  5b38d3:	00 00 
  5b38d5:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5b38d8:	75 06                	jne    5b38e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2d30>
  5b38da:	0f 8b 8b 00 00 00    	jnp    5b396b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2dbb>
  5b38e0:	41 8b 45 20          	mov    0x20(%r13),%eax
  5b38e4:	83 e0 07             	and    $0x7,%eax
  5b38e7:	83 f8 05             	cmp    $0x5,%eax
  5b38ea:	0f 83 d5 00 00 00    	jae    5b39c5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2e15>
  5b38f0:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  5b38f6:	74 4b                	je     5b3943 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2d93>
  5b38f8:	48 8b 9c 24 c8 01 00 	mov    0x1c8(%rsp),%rbx
  5b38ff:	00 
  5b3900:	48 81 fb 9f 86 01 00 	cmp    $0x1869f,%rbx
  5b3907:	0f 87 9a 12 00 00    	ja     5b4ba7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3ff7>
  5b390d:	4c 8b b4 24 b8 00 00 	mov    0xb8(%rsp),%r14
  5b3914:	00 
  5b3915:	4c 3b b4 24 a8 00 00 	cmp    0xa8(%rsp),%r14
  5b391c:	00 
  5b391d:	75 0d                	jne    5b392c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2d7c>
  5b391f:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  5b3926:	00 
  5b3927:	e8 c4 a0 21 00       	call   7cd9f0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6gaF1xUz9Bf_4gpui7runtime6ParentE8grow_oneBP_>
  5b392c:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5b3933:	00 
  5b3934:	42 89 1c b0          	mov    %ebx,(%rax,%r14,4)
  5b3938:	49 ff c6             	inc    %r14
  5b393b:	4c 89 b4 24 b8 00 00 	mov    %r14,0xb8(%rsp)
  5b3942:	00 
  5b3943:	49 8b 5d 00          	mov    0x0(%r13),%rbx
  5b3947:	41 8b 45 20          	mov    0x20(%r13),%eax
  5b394b:	89 c1                	mov    %eax,%ecx
  5b394d:	83 e1 07             	and    $0x7,%ecx
  5b3950:	45 31 ff             	xor    %r15d,%r15d
  5b3953:	48 8d 15 92 af ab ff 	lea    -0x54506e(%rip),%rdx        # 6e8ec <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x82c>
  5b395a:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
  5b395e:	48 01 d1             	add    %rdx,%rcx
  5b3961:	ff e1                	jmp    *%rcx
  5b3963:	45 31 f6             	xor    %r14d,%r14d
  5b3966:	e9 d7 01 00 00       	jmp    5b3b42 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2f92>
  5b396b:	80 bc 24 08 02 00 00 	cmpb   $0x0,0x208(%rsp)
  5b3972:	00 
  5b3973:	74 28                	je     5b399d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2ded>
  5b3975:	f3 0f 10 84 24 a8 01 	movss  0x1a8(%rsp),%xmm0
  5b397c:	00 00 
  5b397e:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5b3981:	75 02                	jne    5b3985 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2dd5>
  5b3983:	7b 18                	jnp    5b399d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2ded>
  5b3985:	f3 0f 10 84 24 ac 01 	movss  0x1ac(%rsp),%xmm0
  5b398c:	00 00 
  5b398e:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5b3991:	0f 85 49 ff ff ff    	jne    5b38e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2d30>
  5b3997:	0f 8a 43 ff ff ff    	jp     5b38e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2d30>
  5b399d:	48 8b 9c 24 b8 00 00 	mov    0xb8(%rsp),%rbx
  5b39a4:	00 
  5b39a5:	48 3b 9c 24 a8 00 00 	cmp    0xa8(%rsp),%rbx
  5b39ac:	00 
  5b39ad:	0f 85 e9 f1 ff ff    	jne    5b2b9c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1fec>
  5b39b3:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  5b39ba:	00 
  5b39bb:	e8 30 a0 21 00       	call   7cd9f0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6gaF1xUz9Bf_4gpui7runtime6ParentE8grow_oneBP_>
  5b39c0:	e9 d7 f1 ff ff       	jmp    5b2b9c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x1fec>
  5b39c5:	0f 84 4a 01 00 00    	je     5b3b15 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2f65>
  5b39cb:	83 f8 06             	cmp    $0x6,%eax
  5b39ce:	0f 84 1c ff ff ff    	je     5b38f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2d40>
  5b39d4:	e9 f9 11 00 00       	jmp    5b4bd2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4022>
  5b39d9:	0f 85 f3 11 00 00    	jne    5b4bd2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4022>
  5b39df:	41 c1 ee 03          	shr    $0x3,%r14d
  5b39e3:	41 8d 46 ff          	lea    -0x1(%r14),%eax
  5b39e7:	41 83 ee 01          	sub    $0x1,%r14d
  5b39eb:	0f 82 86 fe ff ff    	jb     5b3877 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2cc7>
  5b39f1:	48 8b 8c 24 00 02 00 	mov    0x200(%rsp),%rcx
  5b39f8:	00 
  5b39f9:	48 8b 09             	mov    (%rcx),%rcx
  5b39fc:	48 85 c9             	test   %rcx,%rcx
  5b39ff:	0f 84 f7 12 00 00    	je     5b4cfc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x414c>
  5b3a05:	d1 e8                	shr    $1,%eax
  5b3a07:	4c 8b 79 10          	mov    0x10(%rcx),%r15
  5b3a0b:	41 89 c4             	mov    %eax,%r12d
  5b3a0e:	4d 39 e7             	cmp    %r12,%r15
  5b3a11:	0f 86 02 14 00 00    	jbe    5b4e19 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4269>
  5b3a17:	48 8b 41 08          	mov    0x8(%rcx),%rax
  5b3a1b:	0f 28 9c 24 e0 02 00 	movaps 0x2e0(%rsp),%xmm3
  5b3a22:	00 
  5b3a23:	0f 28 c3             	movaps %xmm3,%xmm0
  5b3a26:	0f c6 c3 e8          	shufps $0xe8,%xmm3,%xmm0
  5b3a2a:	0f 28 a4 24 d0 0b 00 	movaps 0xbd0(%rsp),%xmm4
  5b3a31:	00 
  5b3a32:	0f 58 e0             	addps  %xmm0,%xmm4
  5b3a35:	0f 28 ac 24 20 02 00 	movaps 0x220(%rsp),%xmm5
  5b3a3c:	00 
  5b3a3d:	0f 28 cd             	movaps %xmm5,%xmm1
  5b3a40:	0f c6 cd e8          	shufps $0xe8,%xmm5,%xmm1
  5b3a44:	0f 28 94 24 30 02 00 	movaps 0x230(%rsp),%xmm2
  5b3a4b:	00 
  5b3a4c:	0f 5c d1             	subps  %xmm1,%xmm2
  5b3a4f:	0f 58 cc             	addps  %xmm4,%xmm1
  5b3a52:	0f c6 ed ed          	shufps $0xed,%xmm5,%xmm5
  5b3a56:	0f 5c d5             	subps  %xmm5,%xmm2
  5b3a59:	0f 5c d0             	subps  %xmm0,%xmm2
  5b3a5c:	0f c6 db ed          	shufps $0xed,%xmm3,%xmm3
  5b3a60:	0f 5c d3             	subps  %xmm3,%xmm2
  5b3a63:	0f 5c 94 24 d0 02 00 	subps  0x2d0(%rsp),%xmm2
  5b3a6a:	00 
  5b3a6b:	0f 16 ca             	movlhps %xmm2,%xmm1
  5b3a6e:	0f 11 8c 24 f0 00 00 	movups %xmm1,0xf0(%rsp)
  5b3a75:	00 
  5b3a76:	c7 84 24 d8 04 00 00 	movl   $0x1,0x4d8(%rsp)
  5b3a7d:	01 00 00 00 
  5b3a81:	48 c7 84 24 d0 04 00 	movq   $0x22,0x4d0(%rsp)
  5b3a88:	00 22 00 00 00 
  5b3a8d:	80 7c 24 60 00       	cmpb   $0x0,0x60(%rsp)
  5b3a92:	0f 84 cd 0c 00 00    	je     5b4765 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3bb5>
  5b3a98:	41 80 f6 01          	xor    $0x1,%r14b
  5b3a9c:	4e 8d 3c e0          	lea    (%rax,%r12,8),%r15
  5b3aa0:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b3aa7:	00 
  5b3aa8:	e8 43 3e f8 ff       	call   5378f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime5ErrorEBF_.llvm.18178969024155037896>
  5b3aad:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  5b3ab2:	66 0f 14 84 24 c0 00 	unpcklpd 0xc0(%rsp),%xmm0
  5b3ab9:	00 00 
  5b3abb:	0f 29 84 24 40 0c 00 	movaps %xmm0,0xc40(%rsp)
  5b3ac2:	00 
  5b3ac3:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  5b3aca:	00 
  5b3acb:	0f 13 84 24 50 0c 00 	movlps %xmm0,0xc50(%rsp)
  5b3ad2:	00 
  5b3ad3:	45 0f b6 ce          	movzbl %r14b,%r9d
  5b3ad7:	41 83 e1 01          	and    $0x1,%r9d
  5b3adb:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b3ae2:	00 
  5b3ae3:	4c 89 fe             	mov    %r15,%rsi
  5b3ae6:	48 8d 94 24 f0 00 00 	lea    0xf0(%rsp),%rdx
  5b3aed:	00 
  5b3aee:	48 8d 8c 24 40 0c 00 	lea    0xc40(%rsp),%rcx
  5b3af5:	00 
  5b3af6:	4c 8d 84 24 d0 00 00 	lea    0xd0(%rsp),%r8
  5b3afd:	00 
  5b3afe:	ff 15 cc 64 53 00    	call   *0x5364cc(%rip)        # ae9fd0 <_DYNAMIC+0x420>
  5b3b04:	41 89 c4             	mov    %eax,%r12d
  5b3b07:	83 f8 ff             	cmp    $0xffffffff,%eax
  5b3b0a:	0f 84 67 fd ff ff    	je     5b3877 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2cc7>
  5b3b10:	e9 4e 04 00 00       	jmp    5b3f63 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x33b3>
  5b3b15:	49 8b 75 00          	mov    0x0(%r13),%rsi
  5b3b19:	48 8d bc 24 a8 02 00 	lea    0x2a8(%rsp),%rdi
  5b3b20:	00 
  5b3b21:	e8 1a 50 17 00       	call   728b40 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5b3b26:	e9 c5 fd ff ff       	jmp    5b38f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2d40>
  5b3b2b:	41 b6 04             	mov    $0x4,%r14b
  5b3b2e:	eb 12                	jmp    5b3b42 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2f92>
  5b3b30:	41 b6 02             	mov    $0x2,%r14b
  5b3b33:	eb 0d                	jmp    5b3b42 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2f92>
  5b3b35:	41 b6 03             	mov    $0x3,%r14b
  5b3b38:	eb 08                	jmp    5b3b42 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2f92>
  5b3b3a:	41 b6 01             	mov    $0x1,%r14b
  5b3b3d:	eb 03                	jmp    5b3b42 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2f92>
  5b3b3f:	41 b6 05             	mov    $0x5,%r14b
  5b3b42:	c1 e8 03             	shr    $0x3,%eax
  5b3b45:	74 65                	je     5b3bac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2ffc>
  5b3b47:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b3b4b:	4c 8b b9 e0 02 00 00 	mov    0x2e0(%rcx),%r15
  5b3b52:	ff c8                	dec    %eax
  5b3b54:	49 39 c7             	cmp    %rax,%r15
  5b3b57:	0f 86 67 12 00 00    	jbe    5b4dc4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4214>
  5b3b5d:	48 8b 89 d8 02 00 00 	mov    0x2d8(%rcx),%rcx
  5b3b64:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  5b3b68:	48 c1 e0 04          	shl    $0x4,%rax
  5b3b6c:	48 83 3c 01 fe       	cmpq   $0xfffffffffffffffe,(%rcx,%rax,1)
  5b3b71:	0f 84 f0 10 00 00    	je     5b4c67 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x40b7>
  5b3b77:	48 01 c1             	add    %rax,%rcx
  5b3b7a:	4c 8b 79 40          	mov    0x40(%rcx),%r15
  5b3b7e:	41 f6 07 01          	testb  $0x1,(%r15)
  5b3b82:	75 30                	jne    5b3bb4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3004>
  5b3b84:	49 8b 47 08          	mov    0x8(%r15),%rax
  5b3b88:	a8 01                	test   $0x1,%al
  5b3b8a:	75 28                	jne    5b3bb4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3004>
  5b3b8c:	b8 02 00 00 00       	mov    $0x2,%eax
  5b3b91:	f0 49 0f c1 47 08    	lock xadd %rax,0x8(%r15)
  5b3b97:	48 23 84 24 60 03 00 	and    0x360(%rsp),%rax
  5b3b9e:	00 
  5b3b9f:	48 f7 d8             	neg    %rax
  5b3ba2:	71 10                	jno    5b3bb4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3004>
  5b3ba4:	f0 49 83 4f 08 01    	lock orq $0x1,0x8(%r15)
  5b3baa:	eb 08                	jmp    5b3bb4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3004>
  5b3bac:	45 31 ff             	xor    %r15d,%r15d
  5b3baf:	eb 03                	jmp    5b3bb4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3004>
  5b3bb1:	41 b6 06             	mov    $0x6,%r14b
  5b3bb4:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  5b3bb9:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  5b3bbe:	80 7c 24 60 00       	cmpb   $0x0,0x60(%rsp)
  5b3bc3:	75 78                	jne    5b3c3d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x308d>
  5b3bc5:	f3 0f 10 05 8f a4 ab 	movss  -0x545b71(%rip),%xmm0        # 6e05c <anon.3ba400ff3979798c885aff398562f819.15.llvm.6226793394568926217+0x2c>
  5b3bcc:	ff 
  5b3bcd:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  5b3bd2:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  5b3bd9:	00 
  5b3bda:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  5b3bdf:	74 6b                	je     5b3c4c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x309c>
  5b3be1:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  5b3be8:	00 
  5b3be9:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  5b3bf0:	00 
  5b3bf1:	75 0b                	jne    5b3bfe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x304e>
  5b3bf3:	0f 57 c0             	xorps  %xmm0,%xmm0
  5b3bf6:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  5b3bfd:	00 
  5b3bfe:	41 8b 7d 20          	mov    0x20(%r13),%edi
  5b3c02:	89 f8                	mov    %edi,%eax
  5b3c04:	83 e0 07             	and    $0x7,%eax
  5b3c07:	83 f8 06             	cmp    $0x6,%eax
  5b3c0a:	73 61                	jae    5b3c6d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x30bd>
  5b3c0c:	0f 57 c0             	xorps  %xmm0,%xmm0
  5b3c0f:	f3 0f 10 8c 24 10 02 	movss  0x210(%rsp),%xmm1
  5b3c16:	00 00 
  5b3c18:	0f 2e c8             	ucomiss %xmm0,%xmm1
  5b3c1b:	b2 01                	mov    $0x1,%dl
  5b3c1d:	77 67                	ja     5b3c86 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x30d6>
  5b3c1f:	83 ff 07             	cmp    $0x7,%edi
  5b3c22:	77 62                	ja     5b3c86 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x30d6>
  5b3c24:	49 83 7d 08 00       	cmpq   $0x0,0x8(%r13)
  5b3c29:	75 5b                	jne    5b3c86 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x30d6>
  5b3c2b:	e8 f0 51 f9 ff       	call   548e20 <_RNvMsh_NtCs6gaF1xUz9Bf_4gpui7runtimeNtB5_4Node4kind>
  5b3c30:	04 fe                	add    $0xfe,%al
  5b3c32:	a8 fb                	test   $0xfb,%al
  5b3c34:	0f 94 c2             	sete   %dl
  5b3c37:	41 8b 7d 20          	mov    0x20(%r13),%edi
  5b3c3b:	eb 49                	jmp    5b3c86 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x30d6>
  5b3c3d:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  5b3c44:	00 
  5b3c45:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  5b3c4a:	75 95                	jne    5b3be1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3031>
  5b3c4c:	f2 0f 10 05 ac 99 ab 	movsd  -0x546654(%rip),%xmm0        # 6d600 <anon.1f6b7bab1fc61e0fcd36456038a862fb.99.llvm.5148459089407822190+0x2c0>
  5b3c53:	ff 
  5b3c54:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  5b3c59:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  5b3c60:	00 
  5b3c61:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  5b3c68:	00 
  5b3c69:	74 88                	je     5b3bf3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3043>
  5b3c6b:	eb 91                	jmp    5b3bfe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x304e>
  5b3c6d:	0f 85 28 10 00 00    	jne    5b4c9b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x40eb>
  5b3c73:	b2 01                	mov    $0x1,%dl
  5b3c75:	0f 57 c0             	xorps  %xmm0,%xmm0
  5b3c78:	f3 0f 10 8c 24 10 02 	movss  0x210(%rsp),%xmm1
  5b3c7f:	00 00 
  5b3c81:	0f 2e c8             	ucomiss %xmm0,%xmm1
  5b3c84:	76 9e                	jbe    5b3c24 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3074>
  5b3c86:	83 e7 07             	and    $0x7,%edi
  5b3c89:	48 8d 0d 7c ac ab ff 	lea    -0x545384(%rip),%rcx        # 6e90c <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x84c>
  5b3c90:	48 63 04 b9          	movslq (%rcx,%rdi,4),%rax
  5b3c94:	48 01 c8             	add    %rcx,%rax
  5b3c97:	4c 89 ac 24 40 02 00 	mov    %r13,0x240(%rsp)
  5b3c9e:	00 
  5b3c9f:	48 89 9c 24 e0 02 00 	mov    %rbx,0x2e0(%rsp)
  5b3ca6:	00 
  5b3ca7:	4c 89 b4 24 d0 02 00 	mov    %r14,0x2d0(%rsp)
  5b3cae:	00 
  5b3caf:	4c 89 bc 24 20 02 00 	mov    %r15,0x220(%rsp)
  5b3cb6:	00 
  5b3cb7:	88 94 24 10 02 00 00 	mov    %dl,0x210(%rsp)
  5b3cbe:	ff e0                	jmp    *%rax
  5b3cc0:	41 b6 01             	mov    $0x1,%r14b
  5b3cc3:	45 31 ed             	xor    %r13d,%r13d
  5b3cc6:	31 c0                	xor    %eax,%eax
  5b3cc8:	48 8b 8c 24 40 02 00 	mov    0x240(%rsp),%rcx
  5b3ccf:	00 
  5b3cd0:	48 83 79 08 00       	cmpq   $0x0,0x8(%rcx)
  5b3cd5:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  5b3cdb:	b9 06 00 00 00       	mov    $0x6,%ecx
  5b3ce0:	44 0f 45 f9          	cmovne %ecx,%r15d
  5b3ce4:	40 0f 95 c5          	setne  %bpl
  5b3ce8:	84 c0                	test   %al,%al
  5b3cea:	44 0f 45 f9          	cmovne %ecx,%r15d
  5b3cee:	48 8b 9c 24 c8 01 00 	mov    0x1c8(%rsp),%rbx
  5b3cf5:	00 
  5b3cf6:	48 3b 9c 24 b8 01 00 	cmp    0x1b8(%rsp),%rbx
  5b3cfd:	00 
  5b3cfe:	75 0d                	jne    5b3d0d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x315d>
  5b3d00:	48 8d bc 24 b8 01 00 	lea    0x1b8(%rsp),%rdi
  5b3d07:	00 
  5b3d08:	e8 a3 97 21 00       	call   7cd4b0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime8TextSiteEE8grow_oneB1r_>
  5b3d0d:	44 20 f5             	and    %r14b,%bpl
  5b3d10:	41 08 ed             	or     %bpl,%r13b
  5b3d13:	45 08 fd             	or     %r15b,%r13b
  5b3d16:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
  5b3d1d:	00 
  5b3d1e:	48 8d 0c 9b          	lea    (%rbx,%rbx,4),%rcx
  5b3d22:	48 c1 e1 04          	shl    $0x4,%rcx
  5b3d26:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  5b3d2b:	0f 11 04 08          	movups %xmm0,(%rax,%rcx,1)
  5b3d2f:	0f 10 84 24 18 03 00 	movups 0x318(%rsp),%xmm0
  5b3d36:	00 
  5b3d37:	0f 11 44 08 10       	movups %xmm0,0x10(%rax,%rcx,1)
  5b3d3c:	48 8b 94 24 e0 02 00 	mov    0x2e0(%rsp),%rdx
  5b3d43:	00 
  5b3d44:	48 89 54 08 20       	mov    %rdx,0x20(%rax,%rcx,1)
  5b3d49:	48 8b 94 24 20 02 00 	mov    0x220(%rsp),%rdx
  5b3d50:	00 
  5b3d51:	48 89 54 08 28       	mov    %rdx,0x28(%rax,%rcx,1)
  5b3d56:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  5b3d5b:	66 0f 14 44 24 60    	unpcklpd 0x60(%rsp),%xmm0
  5b3d61:	0f 11 44 08 30       	movups %xmm0,0x30(%rax,%rcx,1)
  5b3d66:	66 0f 28 84 24 30 02 	movapd 0x230(%rsp),%xmm0
  5b3d6d:	00 00 
  5b3d6f:	66 0f 13 44 08 40    	movlpd %xmm0,0x40(%rax,%rcx,1)
  5b3d75:	44 89 64 08 48       	mov    %r12d,0x48(%rax,%rcx,1)
  5b3d7a:	44 88 6c 08 4c       	mov    %r13b,0x4c(%rax,%rcx,1)
  5b3d7f:	48 8b 94 24 d0 02 00 	mov    0x2d0(%rsp),%rdx
  5b3d86:	00 
  5b3d87:	88 54 08 4d          	mov    %dl,0x4d(%rax,%rcx,1)
  5b3d8b:	0f b6 94 24 10 02 00 	movzbl 0x210(%rsp),%edx
  5b3d92:	00 
  5b3d93:	88 54 08 4e          	mov    %dl,0x4e(%rax,%rcx,1)
  5b3d97:	48 ff c3             	inc    %rbx
  5b3d9a:	48 89 9c 24 c8 01 00 	mov    %rbx,0x1c8(%rsp)
  5b3da1:	00 
  5b3da2:	48 83 bc 24 98 03 00 	cmpq   $0xffffffffffffffff,0x398(%rsp)
  5b3da9:	00 ff 
  5b3dab:	0f 84 02 ee ff ff    	je     5b2bb3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2003>
  5b3db1:	48 8b 04 24          	mov    (%rsp),%rax
  5b3db5:	4c 8b b8 10 08 00 00 	mov    0x810(%rax),%r15
  5b3dbc:	4d 85 ff             	test   %r15,%r15
  5b3dbf:	0f 84 ee ed ff ff    	je     5b2bb3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2003>
  5b3dc5:	48 8b 9c 24 40 02 00 	mov    0x240(%rsp),%rbx
  5b3dcc:	00 
  5b3dcd:	4c 8b 23             	mov    (%rbx),%r12
  5b3dd0:	4c 89 a4 24 e0 00 00 	mov    %r12,0xe0(%rsp)
  5b3dd7:	00 
  5b3dd8:	48 8d bc 24 48 04 00 	lea    0x448(%rsp),%rdi
  5b3ddf:	00 
  5b3de0:	48 8d b4 24 e0 00 00 	lea    0xe0(%rsp),%rsi
  5b3de7:	00 
  5b3de8:	e8 f3 5c 16 00       	call   719ae0 <_RINvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB6_8BTreeMapjTNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdRNtB1b_8RowDraftEE3getjEB1d_>
  5b3ded:	48 85 c0             	test   %rax,%rax
  5b3df0:	74 1c                	je     5b3e0e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x325e>
  5b3df2:	48 8b 08             	mov    (%rax),%rcx
  5b3df5:	8b 40 08             	mov    0x8(%rax),%eax
  5b3df8:	48 89 8c 24 d8 04 00 	mov    %rcx,0x4d8(%rsp)
  5b3dff:	00 
  5b3e00:	89 84 24 e0 04 00 00 	mov    %eax,0x4e0(%rsp)
  5b3e07:	b8 01 00 00 00       	mov    $0x1,%eax
  5b3e0c:	eb 02                	jmp    5b3e10 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3260>
  5b3e0e:	31 c0                	xor    %eax,%eax
  5b3e10:	48 89 84 24 d0 04 00 	mov    %rax,0x4d0(%rsp)
  5b3e17:	00 
  5b3e18:	48 8b 03             	mov    (%rbx),%rax
  5b3e1b:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
  5b3e22:	00 
  5b3e23:	48 8b bc 24 68 03 00 	mov    0x368(%rsp),%rdi
  5b3e2a:	00 
  5b3e2b:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  5b3e32:	00 
  5b3e33:	e8 38 5d 16 00       	call   719b70 <_RINvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB6_8BTreeMapyAINtNtCs6gaF1xUz9Bf_4gpui8property12ContributionINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtB1e_11shared_text10SharedTextEEj2_E3getyEB1e_>
  5b3e38:	48 8d bc 24 98 03 00 	lea    0x398(%rsp),%rdi
  5b3e3f:	00 
  5b3e40:	4c 89 fe             	mov    %r15,%rsi
  5b3e43:	4c 89 e2             	mov    %r12,%rdx
  5b3e46:	48 8d 8c 24 d0 04 00 	lea    0x4d0(%rsp),%rcx
  5b3e4d:	00 
  5b3e4e:	49 89 c0             	mov    %rax,%r8
  5b3e51:	e8 5a 41 1a 00       	call   757fb0 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataNtB4_5Sheet7capture>
  5b3e56:	e9 58 ed ff ff       	jmp    5b2bb3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x2003>
  5b3e5b:	b0 01                	mov    $0x1,%al
  5b3e5d:	41 b5 08             	mov    $0x8,%r13b
  5b3e60:	45 31 f6             	xor    %r14d,%r14d
  5b3e63:	e9 60 fe ff ff       	jmp    5b3cc8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3118>
  5b3e68:	41 b6 01             	mov    $0x1,%r14b
  5b3e6b:	45 31 ed             	xor    %r13d,%r13d
  5b3e6e:	b0 01                	mov    $0x1,%al
  5b3e70:	e9 53 fe ff ff       	jmp    5b3cc8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3118>
  5b3e75:	83 f8 04             	cmp    $0x4,%eax
  5b3e78:	0f 84 1c f5 ff ff    	je     5b339a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x27ea>
  5b3e7e:	e9 4f 0d 00 00       	jmp    5b4bd2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4022>
  5b3e83:	48 83 bc 24 98 03 00 	cmpq   $0xffffffffffffffff,0x398(%rsp)
  5b3e8a:	00 ff 
  5b3e8c:	74 0d                	je     5b3e9b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x32eb>
  5b3e8e:	48 8d bc 24 98 03 00 	lea    0x398(%rsp),%rdi
  5b3e95:	00 
  5b3e96:	e8 e5 3f 1a 00       	call   757e80 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime8metadataNtB4_5Sheet4sort>
  5b3e9b:	48 8b 04 24          	mov    (%rsp),%rax
  5b3e9f:	80 b8 5d 09 00 00 00 	cmpb   $0x0,0x95d(%rax)
  5b3ea6:	4c 8b b4 24 98 01 00 	mov    0x198(%rsp),%r14
  5b3ead:	00 
  5b3eae:	4c 8d a4 24 d0 04 00 	lea    0x4d0(%rsp),%r12
  5b3eb5:	00 
  5b3eb6:	48 8d b4 24 a0 09 00 	lea    0x9a0(%rsp),%rsi
  5b3ebd:	00 
  5b3ebe:	ba 30 02 00 00       	mov    $0x230,%edx
  5b3ec3:	4c 89 e7             	mov    %r12,%rdi
  5b3ec6:	74 63                	je     5b3f2b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x337b>
  5b3ec8:	ff 15 82 5f 53 00    	call   *0x535f82(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5b3ece:	41 b5 01             	mov    $0x1,%r13b
  5b3ed1:	b0 01                	mov    $0x1,%al
  5b3ed3:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b3ed7:	40 b5 01             	mov    $0x1,%bpl
  5b3eda:	b0 01                	mov    $0x1,%al
  5b3edc:	89 44 24 08          	mov    %eax,0x8(%rsp)
  5b3ee0:	4c 89 e7             	mov    %r12,%rdi
  5b3ee3:	ff 15 ef 60 53 00    	call   *0x5360ef(%rip)        # ae9fd8 <_DYNAMIC+0x428>
  5b3ee9:	45 31 e4             	xor    %r12d,%r12d
  5b3eec:	e9 9d 00 00 00       	jmp    5b3f8e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x33de>
  5b3ef1:	8b 84 24 a0 09 00 00 	mov    0x9a0(%rsp),%eax
  5b3ef8:	8b 8c 24 a3 09 00 00 	mov    0x9a3(%rsp),%ecx
  5b3eff:	89 4c 24 5b          	mov    %ecx,0x5b(%rsp)
  5b3f03:	89 44 24 58          	mov    %eax,0x58(%rsp)
  5b3f07:	45 89 e5             	mov    %r12d,%r13d
  5b3f0a:	41 c1 ed 08          	shr    $0x8,%r13d
  5b3f0e:	b0 01                	mov    $0x1,%al
  5b3f10:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b3f14:	48 83 bc 24 98 03 00 	cmpq   $0xffffffffffffffff,0x398(%rsp)
  5b3f1b:	00 ff 
  5b3f1d:	41 b6 01             	mov    $0x1,%r14b
  5b3f20:	0f 85 dd 08 00 00    	jne    5b4803 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3c53>
  5b3f26:	e9 e5 08 00 00       	jmp    5b4810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3c60>
  5b3f2b:	ff 15 1f 5f 53 00    	call   *0x535f1f(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5b3f31:	41 b5 01             	mov    $0x1,%r13b
  5b3f34:	b0 01                	mov    $0x1,%al
  5b3f36:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b3f3a:	40 b5 01             	mov    $0x1,%bpl
  5b3f3d:	b0 01                	mov    $0x1,%al
  5b3f3f:	89 44 24 08          	mov    %eax,0x8(%rsp)
  5b3f43:	4c 89 e7             	mov    %r12,%rdi
  5b3f46:	ff 15 94 60 53 00    	call   *0x536094(%rip)        # ae9fe0 <_DYNAMIC+0x430>
  5b3f4c:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b3f50:	48 83 b9 60 07 00 00 	cmpq   $0xffffffffffffffff,0x760(%rcx)
  5b3f57:	ff 
  5b3f58:	74 17                	je     5b3f71 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x33c1>
  5b3f5a:	48 8b b1 78 07 00 00 	mov    0x778(%rcx),%rsi
  5b3f61:	eb 10                	jmp    5b3f73 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x33c3>
  5b3f63:	89 d5                	mov    %edx,%ebp
  5b3f65:	45 89 e5             	mov    %r12d,%r13d
  5b3f68:	41 c1 ed 08          	shr    $0x8,%r13d
  5b3f6c:	e9 26 08 00 00       	jmp    5b4797 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3be7>
  5b3f71:	31 f6                	xor    %esi,%esi
  5b3f73:	b1 01                	mov    $0x1,%cl
  5b3f75:	89 4c 24 40          	mov    %ecx,0x40(%rsp)
  5b3f79:	40 b5 01             	mov    $0x1,%bpl
  5b3f7c:	b1 01                	mov    $0x1,%cl
  5b3f7e:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  5b3f82:	48 89 c7             	mov    %rax,%rdi
  5b3f85:	ff 15 95 5f 53 00    	call   *0x535f95(%rip)        # ae9f20 <_DYNAMIC+0x370>
  5b3f8b:	49 89 c4             	mov    %rax,%r12
  5b3f8e:	48 8b 04 24          	mov    (%rsp),%rax
  5b3f92:	4c 8b 88 30 08 00 00 	mov    0x830(%rax),%r9
  5b3f99:	48 8b 80 40 08 00 00 	mov    0x840(%rax),%rax
  5b3fa0:	4d 85 c9             	test   %r9,%r9
  5b3fa3:	0f 95 c1             	setne  %cl
  5b3fa6:	48 85 c0             	test   %rax,%rax
  5b3fa9:	0f 95 c2             	setne  %dl
  5b3fac:	20 ca                	and    %cl,%dl
  5b3fae:	80 fa 01             	cmp    $0x1,%dl
  5b3fb1:	0f 85 76 02 00 00    	jne    5b422d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x367d>
  5b3fb7:	31 c9                	xor    %ecx,%ecx
  5b3fb9:	4d 85 c9             	test   %r9,%r9
  5b3fbc:	0f 95 c1             	setne  %cl
  5b3fbf:	48 8b 14 24          	mov    (%rsp),%rdx
  5b3fc3:	48 8b b2 38 08 00 00 	mov    0x838(%rdx),%rsi
  5b3fca:	31 d2                	xor    %edx,%edx
  5b3fcc:	eb 30                	jmp    5b3ffe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x344e>
  5b3fce:	41 b1 01             	mov    $0x1,%r9b
  5b3fd1:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  5b3fd8:	00 
  5b3fd9:	4c 8b b4 24 98 01 00 	mov    0x198(%rsp),%r14
  5b3fe0:	00 
  5b3fe1:	48 ff c8             	dec    %rax
  5b3fe4:	49 c1 e0 05          	shl    $0x5,%r8
  5b3fe8:	4c 01 c7             	add    %r8,%rdi
  5b3feb:	44 88 4f 1c          	mov    %r9b,0x1c(%rdi)
  5b3fef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  5b3ff5:	48 85 c0             	test   %rax,%rax
  5b3ff8:	0f 84 2f 02 00 00    	je     5b422d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x367d>
  5b3ffe:	48 85 d2             	test   %rdx,%rdx
  5b4001:	75 44                	jne    5b4047 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3497>
  5b4003:	f6 c1 01             	test   $0x1,%cl
  5b4006:	74 3f                	je     5b4047 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3497>
  5b4008:	b9 01 00 00 00       	mov    $0x1,%ecx
  5b400d:	48 85 f6             	test   %rsi,%rsi
  5b4010:	74 55                	je     5b4067 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x34b7>
  5b4012:	48 89 f7             	mov    %rsi,%rdi
  5b4015:	4c 89 ca             	mov    %r9,%rdx
  5b4018:	48 83 e7 07          	and    $0x7,%rdi
  5b401c:	74 4e                	je     5b406c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x34bc>
  5b401e:	45 31 c0             	xor    %r8d,%r8d
  5b4021:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b4028:	0f 1f 84 00 00 00 00 
  5b402f:	00 
  5b4030:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b4037:	49 ff c0             	inc    %r8
  5b403a:	4c 39 c7             	cmp    %r8,%rdi
  5b403d:	75 f1                	jne    5b4030 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3480>
  5b403f:	48 89 f7             	mov    %rsi,%rdi
  5b4042:	4c 29 c7             	sub    %r8,%rdi
  5b4045:	eb 28                	jmp    5b406f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x34bf>
  5b4047:	f6 c1 01             	test   $0x1,%cl
  5b404a:	0f 84 f3 0a 00 00    	je     5b4b43 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3f93>
  5b4050:	0f b7 ba c2 01 00 00 	movzwl 0x1c2(%rdx),%edi
  5b4057:	48 39 fe             	cmp    %rdi,%rsi
  5b405a:	73 74                	jae    5b40d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3520>
  5b405c:	48 89 d7             	mov    %rdx,%rdi
  5b405f:	49 89 f0             	mov    %rsi,%r8
  5b4062:	e9 91 00 00 00       	jmp    5b40f8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3548>
  5b4067:	4c 89 ca             	mov    %r9,%rdx
  5b406a:	eb 52                	jmp    5b40be <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x350e>
  5b406c:	48 89 f7             	mov    %rsi,%rdi
  5b406f:	48 83 fe 08          	cmp    $0x8,%rsi
  5b4073:	72 49                	jb     5b40be <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x350e>
  5b4075:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5b407c:	00 00 00 00 
  5b4080:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b4087:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b408e:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b4095:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b409c:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b40a3:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b40aa:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b40b1:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b40b8:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  5b40bc:	75 c2                	jne    5b4080 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x34d0>
  5b40be:	31 f6                	xor    %esi,%esi
  5b40c0:	45 31 c9             	xor    %r9d,%r9d
  5b40c3:	0f b7 ba c2 01 00 00 	movzwl 0x1c2(%rdx),%edi
  5b40ca:	48 39 fe             	cmp    %rdi,%rsi
  5b40cd:	72 8d                	jb     5b405c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x34ac>
  5b40cf:	90                   	nop
  5b40d0:	48 8b ba 60 01 00 00 	mov    0x160(%rdx),%rdi
  5b40d7:	48 85 ff             	test   %rdi,%rdi
  5b40da:	0f 84 28 0c 00 00    	je     5b4d08 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4158>
  5b40e0:	49 ff c1             	inc    %r9
  5b40e3:	44 0f b7 82 c0 01 00 	movzwl 0x1c0(%rdx),%r8d
  5b40ea:	00 
  5b40eb:	48 89 fa             	mov    %rdi,%rdx
  5b40ee:	66 44 3b 87 c2 01 00 	cmp    0x1c2(%rdi),%r8w
  5b40f5:	00 
  5b40f6:	73 d8                	jae    5b40d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3520>
  5b40f8:	4d 85 c9             	test   %r9,%r9
  5b40fb:	74 3d                	je     5b413a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x358a>
  5b40fd:	4a 8d 34 c7          	lea    (%rdi,%r8,8),%rsi
  5b4101:	48 81 c6 d0 01 00 00 	add    $0x1d0,%rsi
  5b4108:	4d 89 ca             	mov    %r9,%r10
  5b410b:	49 83 e2 07          	and    $0x7,%r10
  5b410f:	74 32                	je     5b4143 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3593>
  5b4111:	45 31 db             	xor    %r11d,%r11d
  5b4114:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b411b:	00 00 00 00 00 
  5b4120:	48 8b 16             	mov    (%rsi),%rdx
  5b4123:	48 8d b2 c8 01 00 00 	lea    0x1c8(%rdx),%rsi
  5b412a:	49 ff c3             	inc    %r11
  5b412d:	4d 39 da             	cmp    %r11,%r10
  5b4130:	75 ee                	jne    5b4120 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3570>
  5b4132:	4d 89 ca             	mov    %r9,%r10
  5b4135:	4d 29 da             	sub    %r11,%r10
  5b4138:	eb 0c                	jmp    5b4146 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3596>
  5b413a:	49 8d 70 01          	lea    0x1(%r8),%rsi
  5b413e:	48 89 fa             	mov    %rdi,%rdx
  5b4141:	eb 50                	jmp    5b4193 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x35e3>
  5b4143:	4d 89 ca             	mov    %r9,%r10
  5b4146:	49 83 f9 08          	cmp    $0x8,%r9
  5b414a:	72 45                	jb     5b4191 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x35e1>
  5b414c:	0f 1f 40 00          	nopl   0x0(%rax)
  5b4150:	48 8b 16             	mov    (%rsi),%rdx
  5b4153:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b415a:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b4161:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b4168:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b416f:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b4176:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b417d:	48 8b 92 c8 01 00 00 	mov    0x1c8(%rdx),%rdx
  5b4184:	48 8d b2 c8 01 00 00 	lea    0x1c8(%rdx),%rsi
  5b418b:	49 83 c2 f8          	add    $0xfffffffffffffff8,%r10
  5b418f:	75 bf                	jne    5b4150 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x35a0>
  5b4191:	31 f6                	xor    %esi,%esi
  5b4193:	4c 8b 8c 24 a8 02 00 	mov    0x2a8(%rsp),%r9
  5b419a:	00 
  5b419b:	4d 85 c9             	test   %r9,%r9
  5b419e:	74 75                	je     5b4215 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3665>
  5b41a0:	4e 8b 94 c7 68 01 00 	mov    0x168(%rdi,%r8,8),%r10
  5b41a7:	00 
  5b41a8:	4c 8b 9c 24 b0 02 00 	mov    0x2b0(%rsp),%r11
  5b41af:	00 
  5b41b0:	45 0f b7 71 62       	movzwl 0x62(%r9),%r14d
  5b41b5:	45 89 f7             	mov    %r14d,%r15d
  5b41b8:	41 c1 e7 03          	shl    $0x3,%r15d
  5b41bc:	48 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%rbx
  5b41c3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b41ca:	84 00 00 00 00 00 
  5b41d0:	4d 85 ff             	test   %r15,%r15
  5b41d3:	74 28                	je     5b41fd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x364d>
  5b41d5:	4d 3b 54 d9 10       	cmp    0x10(%r9,%rbx,8),%r10
  5b41da:	40 0f 97 c5          	seta   %bpl
  5b41de:	40 80 dd 00          	sbb    $0x0,%bpl
  5b41e2:	48 ff c3             	inc    %rbx
  5b41e5:	49 83 c7 f8          	add    $0xfffffffffffffff8,%r15
  5b41e9:	40 80 fd 01          	cmp    $0x1,%bpl
  5b41ed:	74 e1                	je     5b41d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3620>
  5b41ef:	40 0f b6 ed          	movzbl %bpl,%ebp
  5b41f3:	85 ed                	test   %ebp,%ebp
  5b41f5:	0f 84 d3 fd ff ff    	je     5b3fce <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x341e>
  5b41fb:	eb 03                	jmp    5b4200 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3650>
  5b41fd:	4c 89 f3             	mov    %r14,%rbx
  5b4200:	4c 8b b4 24 98 01 00 	mov    0x198(%rsp),%r14
  5b4207:	00 
  5b4208:	49 83 eb 01          	sub    $0x1,%r11
  5b420c:	72 0f                	jb     5b421d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x366d>
  5b420e:	4d 8b 4c d9 68       	mov    0x68(%r9,%rbx,8),%r9
  5b4213:	eb 9b                	jmp    5b41b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3600>
  5b4215:	45 31 c9             	xor    %r9d,%r9d
  5b4218:	e9 c4 fd ff ff       	jmp    5b3fe1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3431>
  5b421d:	45 31 c9             	xor    %r9d,%r9d
  5b4220:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  5b4227:	00 
  5b4228:	e9 b4 fd ff ff       	jmp    5b3fe1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3431>
  5b422d:	b0 01                	mov    $0x1,%al
  5b422f:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b4233:	83 bc 24 58 0c 00 00 	cmpl   $0x2,0xc58(%rsp)
  5b423a:	02 
  5b423b:	b0 01                	mov    $0x1,%al
  5b423d:	89 44 24 08          	mov    %eax,0x8(%rsp)
  5b4241:	74 4d                	je     5b4290 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x36e0>
  5b4243:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b424a:	00 
  5b424b:	48 8d b4 24 58 0c 00 	lea    0xc58(%rsp),%rsi
  5b4252:	00 
  5b4253:	ba 28 02 00 00       	mov    $0x228,%edx
  5b4258:	ff 15 f2 5b 53 00    	call   *0x535bf2(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5b425e:	48 8b 1c 24          	mov    (%rsp),%rbx
  5b4262:	48 89 df             	mov    %rbx,%rdi
  5b4265:	e8 06 39 f8 ff       	call   537b70 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs7XZEQI6Z5Ts_11gpui_canvas6canvas6CanvasECs6gaF1xUz9Bf_4gpui>
  5b426a:	48 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%rsi
  5b4271:	00 
  5b4272:	ba 28 02 00 00       	mov    $0x228,%edx
  5b4277:	48 89 df             	mov    %rbx,%rdi
  5b427a:	ff 15 d0 5b 53 00    	call   *0x535bd0(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5b4280:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%rsp)
  5b4287:	00 
  5b4288:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  5b428f:	00 
  5b4290:	48 83 bc 24 98 03 00 	cmpq   $0xffffffffffffffff,0x398(%rsp)
  5b4297:	00 ff 
  5b4299:	0f 84 83 01 00 00    	je     5b4422 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3872>
  5b429f:	0f 10 84 24 e8 03 00 	movups 0x3e8(%rsp),%xmm0
  5b42a6:	00 
  5b42a7:	0f 29 84 24 c0 04 00 	movaps %xmm0,0x4c0(%rsp)
  5b42ae:	00 
  5b42af:	0f 10 84 24 d8 03 00 	movups 0x3d8(%rsp),%xmm0
  5b42b6:	00 
  5b42b7:	0f 29 84 24 b0 04 00 	movaps %xmm0,0x4b0(%rsp)
  5b42be:	00 
  5b42bf:	66 0f 10 84 24 98 03 	movupd 0x398(%rsp),%xmm0
  5b42c6:	00 00 
  5b42c8:	0f 10 8c 24 a8 03 00 	movups 0x3a8(%rsp),%xmm1
  5b42cf:	00 
  5b42d0:	0f 10 94 24 b8 03 00 	movups 0x3b8(%rsp),%xmm2
  5b42d7:	00 
  5b42d8:	0f 10 9c 24 c8 03 00 	movups 0x3c8(%rsp),%xmm3
  5b42df:	00 
  5b42e0:	0f 29 9c 24 a0 04 00 	movaps %xmm3,0x4a0(%rsp)
  5b42e7:	00 
  5b42e8:	0f 29 94 24 90 04 00 	movaps %xmm2,0x490(%rsp)
  5b42ef:	00 
  5b42f0:	0f 29 8c 24 80 04 00 	movaps %xmm1,0x480(%rsp)
  5b42f7:	00 
  5b42f8:	66 0f 29 84 24 70 04 	movapd %xmm0,0x470(%rsp)
  5b42ff:	00 00 
  5b4301:	48 8b 04 24          	mov    (%rsp),%rax
  5b4305:	48 8b b8 10 08 00 00 	mov    0x810(%rax),%rdi
  5b430c:	48 85 ff             	test   %rdi,%rdi
  5b430f:	0f 84 ea 00 00 00    	je     5b43ff <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x384f>
  5b4315:	0f 10 84 24 e8 03 00 	movups 0x3e8(%rsp),%xmm0
  5b431c:	00 
  5b431d:	0f 29 84 24 20 05 00 	movaps %xmm0,0x520(%rsp)
  5b4324:	00 
  5b4325:	0f 10 84 24 d8 03 00 	movups 0x3d8(%rsp),%xmm0
  5b432c:	00 
  5b432d:	0f 29 84 24 10 05 00 	movaps %xmm0,0x510(%rsp)
  5b4334:	00 
  5b4335:	0f 10 84 24 98 03 00 	movups 0x398(%rsp),%xmm0
  5b433c:	00 
  5b433d:	0f 10 8c 24 a8 03 00 	movups 0x3a8(%rsp),%xmm1
  5b4344:	00 
  5b4345:	0f 10 94 24 b8 03 00 	movups 0x3b8(%rsp),%xmm2
  5b434c:	00 
  5b434d:	0f 10 9c 24 c8 03 00 	movups 0x3c8(%rsp),%xmm3
  5b4354:	00 
  5b4355:	0f 29 9c 24 00 05 00 	movaps %xmm3,0x500(%rsp)
  5b435c:	00 
  5b435d:	0f 29 94 24 f0 04 00 	movaps %xmm2,0x4f0(%rsp)
  5b4364:	00 
  5b4365:	0f 29 8c 24 e0 04 00 	movaps %xmm1,0x4e0(%rsp)
  5b436c:	00 
  5b436d:	0f 29 84 24 d0 04 00 	movaps %xmm0,0x4d0(%rsp)
  5b4374:	00 
  5b4375:	48 83 7f 78 ff       	cmpq   $0xffffffffffffffff,0x78(%rdi)
  5b437a:	74 14                	je     5b4390 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x37e0>
  5b437c:	48 83 c7 78          	add    $0x78,%rdi
  5b4380:	e8 6b 47 f8 ff       	call   538af0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5SheetEBH_>
  5b4385:	48 8b 04 24          	mov    (%rsp),%rax
  5b4389:	48 8b b8 10 08 00 00 	mov    0x810(%rax),%rdi
  5b4390:	0f 28 84 24 20 05 00 	movaps 0x520(%rsp),%xmm0
  5b4397:	00 
  5b4398:	0f 11 87 c8 00 00 00 	movups %xmm0,0xc8(%rdi)
  5b439f:	0f 28 84 24 10 05 00 	movaps 0x510(%rsp),%xmm0
  5b43a6:	00 
  5b43a7:	0f 11 87 b8 00 00 00 	movups %xmm0,0xb8(%rdi)
  5b43ae:	66 0f 28 84 24 d0 04 	movapd 0x4d0(%rsp),%xmm0
  5b43b5:	00 00 
  5b43b7:	0f 28 8c 24 e0 04 00 	movaps 0x4e0(%rsp),%xmm1
  5b43be:	00 
  5b43bf:	0f 28 94 24 f0 04 00 	movaps 0x4f0(%rsp),%xmm2
  5b43c6:	00 
  5b43c7:	0f 28 9c 24 00 05 00 	movaps 0x500(%rsp),%xmm3
  5b43ce:	00 
  5b43cf:	0f 11 9f a8 00 00 00 	movups %xmm3,0xa8(%rdi)
  5b43d6:	0f 11 97 98 00 00 00 	movups %xmm2,0x98(%rdi)
  5b43dd:	0f 11 8f 88 00 00 00 	movups %xmm1,0x88(%rdi)
  5b43e4:	66 0f 11 47 78       	movupd %xmm0,0x78(%rdi)
  5b43e9:	eb 2f                	jmp    5b441a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x386a>
  5b43eb:	44 0f b6 a4 24 d1 04 	movzbl 0x4d1(%rsp),%r12d
  5b43f2:	00 00 
  5b43f4:	41 bf 21 00 00 00    	mov    $0x21,%r15d
  5b43fa:	e9 80 03 00 00       	jmp    5b477f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3bcf>
  5b43ff:	41 b5 01             	mov    $0x1,%r13b
  5b4402:	c7 44 24 40 00 00 00 	movl   $0x0,0x40(%rsp)
  5b4409:	00 
  5b440a:	48 8d bc 24 70 04 00 	lea    0x470(%rsp),%rdi
  5b4411:	00 
  5b4412:	40 b5 01             	mov    $0x1,%bpl
  5b4415:	e8 d6 46 f8 ff       	call   538af0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5SheetEBH_>
  5b441a:	c7 44 24 40 00 00 00 	movl   $0x0,0x40(%rsp)
  5b4421:	00 
  5b4422:	48 83 bc 24 f0 01 00 	cmpq   $0xffffffffffffffff,0x1f0(%rsp)
  5b4429:	00 ff 
  5b442b:	74 29                	je     5b4456 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x38a6>
  5b442d:	48 8b 84 24 00 02 00 	mov    0x200(%rsp),%rax
  5b4434:	00 
  5b4435:	48 8b 38             	mov    (%rax),%rdi
  5b4438:	48 85 ff             	test   %rdi,%rdi
  5b443b:	0f 84 a9 08 00 00    	je     5b4cea <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x413a>
  5b4441:	48 8d 94 24 f8 03 00 	lea    0x3f8(%rsp),%rdx
  5b4448:	00 
  5b4449:	48 89 de             	mov    %rbx,%rsi
  5b444c:	e8 5f 3a 1c 00       	call   777eb0 <_RNvMNtNtCs6gaF1xUz9Bf_4gpui7runtime5imageNtB2_6Images7prepare>
  5b4451:	45 31 ed             	xor    %r13d,%r13d
  5b4454:	eb 03                	jmp    5b4459 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x38a9>
  5b4456:	41 b5 01             	mov    $0x1,%r13b
  5b4459:	48 8b 84 24 c8 01 00 	mov    0x1c8(%rsp),%rax
  5b4460:	00 
  5b4461:	48 89 84 24 e0 04 00 	mov    %rax,0x4e0(%rsp)
  5b4468:	00 
  5b4469:	0f 10 84 24 b8 01 00 	movups 0x1b8(%rsp),%xmm0
  5b4470:	00 
  5b4471:	0f 29 84 24 d0 04 00 	movaps %xmm0,0x4d0(%rsp)
  5b4478:	00 
  5b4479:	48 8b 1c 24          	mov    (%rsp),%rbx
  5b447d:	48 8d ab 60 07 00 00 	lea    0x760(%rbx),%rbp
  5b4484:	48 89 ef             	mov    %rbp,%rdi
  5b4487:	e8 74 53 f7 ff       	call   529800 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime8PreparedEEB11_>
  5b448c:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b4493:	00 
  5b4494:	48 89 45 10          	mov    %rax,0x10(%rbp)
  5b4498:	0f 28 84 24 d0 04 00 	movaps 0x4d0(%rsp),%xmm0
  5b449f:	00 
  5b44a0:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
  5b44a4:	4c 89 a3 78 07 00 00 	mov    %r12,0x778(%rbx)
  5b44ab:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  5b44b2:	00 
  5b44b3:	66 89 83 80 07 00 00 	mov    %ax,0x780(%rbx)
  5b44ba:	8b 44 24 54          	mov    0x54(%rsp),%eax
  5b44be:	66 89 83 82 07 00 00 	mov    %ax,0x782(%rbx)
  5b44c5:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  5b44cb:	f3 0f 11 83 84 07 00 	movss  %xmm0,0x784(%rbx)
  5b44d2:	00 
  5b44d3:	4c 89 b3 80 08 00 00 	mov    %r14,0x880(%rbx)
  5b44da:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5b44e1:	00 
  5b44e2:	48 89 83 88 08 00 00 	mov    %rax,0x888(%rbx)
  5b44e9:	48 8b 83 60 08 00 00 	mov    0x860(%rbx),%rax
  5b44f0:	48 89 83 90 08 00 00 	mov    %rax,0x890(%rbx)
  5b44f7:	48 8b 84 24 90 03 00 	mov    0x390(%rsp),%rax
  5b44fe:	00 
  5b44ff:	48 89 83 90 07 00 00 	mov    %rax,0x790(%rbx)
  5b4506:	48 83 bb e0 02 00 00 	cmpq   $0x0,0x2e0(%rbx)
  5b450d:	00 
  5b450e:	48 8b bc 24 90 01 00 	mov    0x190(%rsp),%rdi
  5b4515:	00 
  5b4516:	75 13                	jne    5b452b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x397b>
  5b4518:	48 89 fb             	mov    %rdi,%rbx
  5b451b:	e8 70 57 f7 ff       	call   529c90 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs7XZEQI6Z5Ts_11gpui_canvas4text10TextSystemEECs6gaF1xUz9Bf_4gpui>
  5b4520:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
  5b4527:	48 8b 1c 24          	mov    (%rsp),%rbx
  5b452b:	c6 83 5b 09 00 00 00 	movb   $0x0,0x95b(%rbx)
  5b4532:	66 c7 83 58 09 00 00 	movw   $0x0,0x958(%rbx)
  5b4539:	00 00 
  5b453b:	48 8d bb 48 08 00 00 	lea    0x848(%rbx),%rdi
  5b4542:	31 ed                	xor    %ebp,%ebp
  5b4544:	e8 47 43 17 00       	call   728890 <_RNvMsh_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE5clearCs6gaF1xUz9Bf_4gpui>
  5b4549:	48 8b 8c 24 88 00 00 	mov    0x88(%rsp),%rcx
  5b4550:	00 
  5b4551:	48 8b 04 24          	mov    (%rsp),%rax
  5b4555:	80 b8 5d 09 00 00 00 	cmpb   $0x0,0x95d(%rax)
  5b455c:	44 89 ac 24 c0 00 00 	mov    %r13d,0xc0(%rsp)
  5b4563:	00 
  5b4564:	74 28                	je     5b458e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x39de>
  5b4566:	31 ed                	xor    %ebp,%ebp
  5b4568:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b456f:	00 
  5b4570:	48 8b 34 24          	mov    (%rsp),%rsi
  5b4574:	4c 89 f2             	mov    %r14,%rdx
  5b4577:	e8 a4 56 ff ff       	call   5a9c20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE11acknowledgeB7_.llvm.18178969024155037896>
  5b457c:	4c 8b bc 24 d0 04 00 	mov    0x4d0(%rsp),%r15
  5b4583:	00 
  5b4584:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  5b4588:	0f 85 78 01 00 00    	jne    5b4706 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3b56>
  5b458e:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5b4595:	00 
  5b4596:	48 8d bc 24 48 04 00 	lea    0x448(%rsp),%rdi
  5b459d:	00 
  5b459e:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b45a3:	e8 88 94 17 00       	call   72da30 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5b45a8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5b45af:	00 
  5b45b0:	48 8d bc 24 a8 02 00 	lea    0x2a8(%rsp),%rdi
  5b45b7:	00 
  5b45b8:	e8 23 9c 17 00       	call   72e1e0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB4_7set_val9SetValZSTENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5b45bd:	48 8b b4 24 a8 00 00 	mov    0xa8(%rsp),%rsi
  5b45c4:	00 
  5b45c5:	48 85 f6             	test   %rsi,%rsi
  5b45c8:	74 17                	je     5b45e1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3a31>
  5b45ca:	48 8b bc 24 b0 00 00 	mov    0xb0(%rsp),%rdi
  5b45d1:	00 
  5b45d2:	48 c1 e6 02          	shl    $0x2,%rsi
  5b45d6:	ba 04 00 00 00       	mov    $0x4,%edx
  5b45db:	ff 15 17 58 53 00    	call   *0x535817(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b45e1:	48 8b b4 24 78 01 00 	mov    0x178(%rsp),%rsi
  5b45e8:	00 
  5b45e9:	48 85 f6             	test   %rsi,%rsi
  5b45ec:	74 13                	je     5b4601 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3a51>
  5b45ee:	48 8b bc 24 80 01 00 	mov    0x180(%rsp),%rdi
  5b45f5:	00 
  5b45f6:	ba 01 00 00 00       	mov    $0x1,%edx
  5b45fb:	ff 15 f7 57 53 00    	call   *0x5357f7(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b4601:	48 8b b4 24 60 01 00 	mov    0x160(%rsp),%rsi
  5b4608:	00 
  5b4609:	48 85 f6             	test   %rsi,%rsi
  5b460c:	74 17                	je     5b4625 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3a75>
  5b460e:	48 8b bc 24 68 01 00 	mov    0x168(%rsp),%rdi
  5b4615:	00 
  5b4616:	48 c1 e6 04          	shl    $0x4,%rsi
  5b461a:	ba 04 00 00 00       	mov    $0x4,%edx
  5b461f:	ff 15 d3 57 53 00    	call   *0x5357d3(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b4625:	48 8b b4 24 48 01 00 	mov    0x148(%rsp),%rsi
  5b462c:	00 
  5b462d:	48 85 f6             	test   %rsi,%rsi
  5b4630:	74 17                	je     5b4649 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3a99>
  5b4632:	48 8b bc 24 50 01 00 	mov    0x150(%rsp),%rdi
  5b4639:	00 
  5b463a:	48 c1 e6 04          	shl    $0x4,%rsi
  5b463e:	ba 04 00 00 00       	mov    $0x4,%edx
  5b4643:	ff 15 af 57 53 00    	call   *0x5357af(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b4649:	48 8b 84 24 30 01 00 	mov    0x130(%rsp),%rax
  5b4650:	00 
  5b4651:	48 85 c0             	test   %rax,%rax
  5b4654:	74 17                	je     5b466d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3abd>
  5b4656:	48 8b bc 24 38 01 00 	mov    0x138(%rsp),%rdi
  5b465d:	00 
  5b465e:	48 6b f0 38          	imul   $0x38,%rax,%rsi
  5b4662:	ba 08 00 00 00       	mov    $0x8,%edx
  5b4667:	ff 15 8b 57 53 00    	call   *0x53578b(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b466d:	48 8b bc 24 20 01 00 	mov    0x120(%rsp),%rdi
  5b4674:	00 
  5b4675:	48 8b b4 24 28 01 00 	mov    0x128(%rsp),%rsi
  5b467c:	00 
  5b467d:	e8 ce 52 f7 ff       	call   529950 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs7XZEQI6Z5Ts_11gpui_canvas4text10TextShaperEECs6gaF1xUz9Bf_4gpui>
  5b4682:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  5b4689:	00 
  5b468a:	48 85 c0             	test   %rax,%rax
  5b468d:	74 14                	je     5b46a3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3af3>
  5b468f:	f0 48 ff 08          	lock decq (%rax)
  5b4693:	75 0e                	jne    5b46a3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3af3>
  5b4695:	48 8d bc 24 98 00 00 	lea    0x98(%rsp),%rdi
  5b469c:	00 
  5b469d:	ff 15 fd 57 53 00    	call   *0x5357fd(%rip)        # ae9ea0 <_DYNAMIC+0x2f0>
  5b46a3:	4c 8b 04 24          	mov    (%rsp),%r8
  5b46a7:	66 41 0f 10 80 60 08 	movupd 0x860(%r8),%xmm0
  5b46ae:	00 00 
  5b46b0:	41 0f b6 80 5c 09 00 	movzbl 0x95c(%r8),%eax
  5b46b7:	00 
  5b46b8:	49 83 b8 80 08 00 00 	cmpq   $0x0,0x880(%r8)
  5b46bf:	00 
  5b46c0:	74 21                	je     5b46e3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3b33>
  5b46c2:	89 c2                	mov    %eax,%edx
  5b46c4:	80 f2 01             	xor    $0x1,%dl
  5b46c7:	49 83 b8 60 07 00 00 	cmpq   $0xffffffffffffffff,0x760(%r8)
  5b46ce:	ff 
  5b46cf:	49 8b 88 90 08 00 00 	mov    0x890(%r8),%rcx
  5b46d6:	40 0f 95 c6          	setne  %sil
  5b46da:	40 08 d6             	or     %dl,%sil
  5b46dd:	40 0f b6 d6          	movzbl %sil,%edx
  5b46e1:	eb 02                	jmp    5b46e5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3b35>
  5b46e3:	31 d2                	xor    %edx,%edx
  5b46e5:	48 8b bc 24 a0 00 00 	mov    0xa0(%rsp),%rdi
  5b46ec:	00 
  5b46ed:	49 8b b0 48 09 00 00 	mov    0x948(%r8),%rsi
  5b46f4:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  5b46f8:	48 89 4f 10          	mov    %rcx,0x10(%rdi)
  5b46fc:	66 0f 11 47 18       	movupd %xmm0,0x18(%rdi)
  5b4701:	e9 45 c9 ff ff       	jmp    5b104b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x49b>
  5b4706:	44 8b a4 24 d8 04 00 	mov    0x4d8(%rsp),%r12d
  5b470d:	00 
  5b470e:	8b ac 24 dc 04 00 00 	mov    0x4dc(%rsp),%ebp
  5b4715:	0f 10 84 24 e0 04 00 	movups 0x4e0(%rsp),%xmm0
  5b471c:	00 
  5b471d:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  5b4722:	66 0f 10 84 24 f0 04 	movupd 0x4f0(%rsp),%xmm0
  5b4729:	00 00 
  5b472b:	66 0f 29 44 24 30    	movapd %xmm0,0x30(%rsp)
  5b4731:	0f b6 9c 24 00 05 00 	movzbl 0x500(%rsp),%ebx
  5b4738:	00 
  5b4739:	8b 84 24 01 05 00 00 	mov    0x501(%rsp),%eax
  5b4740:	89 44 24 58          	mov    %eax,0x58(%rsp)
  5b4744:	8b 84 24 04 05 00 00 	mov    0x504(%rsp),%eax
  5b474b:	89 44 24 5b          	mov    %eax,0x5b(%rsp)
  5b474f:	45 89 e5             	mov    %r12d,%r13d
  5b4752:	41 c1 ed 08          	shr    $0x8,%r13d
  5b4756:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5b475d:	00 
  5b475e:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b4763:	eb 5d                	jmp    5b47c2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3c12>
  5b4765:	41 bf 22 00 00 00    	mov    $0x22,%r15d
  5b476b:	41 b4 01             	mov    $0x1,%r12b
  5b476e:	45 31 ed             	xor    %r13d,%r13d
  5b4771:	eb 0c                	jmp    5b477f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3bcf>
  5b4773:	41 b4 01             	mov    $0x1,%r12b
  5b4776:	45 31 ed             	xor    %r13d,%r13d
  5b4779:	41 bf 22 00 00 00    	mov    $0x22,%r15d
  5b477f:	eb 1c                	jmp    5b479d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3bed>
  5b4781:	4c 8b a4 24 d8 04 00 	mov    0x4d8(%rsp),%r12
  5b4788:	00 
  5b4789:	45 89 e5             	mov    %r12d,%r13d
  5b478c:	41 c1 ed 08          	shr    $0x8,%r13d
  5b4790:	4c 89 e5             	mov    %r12,%rbp
  5b4793:	48 c1 ed 20          	shr    $0x20,%rbp
  5b4797:	41 bf 22 00 00 00    	mov    $0x22,%r15d
  5b479d:	41 b6 01             	mov    $0x1,%r14b
  5b47a0:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b47a7:	00 
  5b47a8:	e8 c3 33 f8 ff       	call   537b70 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs7XZEQI6Z5Ts_11gpui_canvas6canvas6CanvasECs6gaF1xUz9Bf_4gpui>
  5b47ad:	b0 01                	mov    $0x1,%al
  5b47af:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b47b3:	b0 01                	mov    $0x1,%al
  5b47b5:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b47b9:	b0 01                	mov    $0x1,%al
  5b47bb:	89 84 24 c0 00 00 00 	mov    %eax,0xc0(%rsp)
  5b47c2:	48 8d bc 24 48 04 00 	lea    0x448(%rsp),%rdi
  5b47c9:	00 
  5b47ca:	e8 61 92 17 00       	call   72da30 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5b47cf:	48 83 bc 24 f0 01 00 	cmpq   $0xffffffffffffffff,0x1f0(%rsp)
  5b47d6:	00 ff 
  5b47d8:	0f 95 c0             	setne  %al
  5b47db:	84 84 24 c0 00 00 00 	test   %al,0xc0(%rsp)
  5b47e2:	74 0d                	je     5b47f1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3c41>
  5b47e4:	48 8d bc 24 f8 03 00 	lea    0x3f8(%rsp),%rdi
  5b47eb:	00 
  5b47ec:	e8 7f 1c f8 ff       	call   536470 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs7XZEQI6Z5Ts_11gpui_canvas5image5ImageEECs6gaF1xUz9Bf_4gpui>
  5b47f1:	48 83 bc 24 98 03 00 	cmpq   $0xffffffffffffffff,0x398(%rsp)
  5b47f8:	00 ff 
  5b47fa:	0f 95 c0             	setne  %al
  5b47fd:	84 44 24 40          	test   %al,0x40(%rsp)
  5b4801:	74 0d                	je     5b4810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3c60>
  5b4803:	48 8d bc 24 98 03 00 	lea    0x398(%rsp),%rdi
  5b480a:	00 
  5b480b:	e8 e0 42 f8 ff       	call   538af0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5SheetEBH_>
  5b4810:	48 8d bc 24 a8 02 00 	lea    0x2a8(%rsp),%rdi
  5b4817:	00 
  5b4818:	e8 c3 99 17 00       	call   72e1e0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB4_7set_val9SetValZSTENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5b481d:	48 8b b4 24 a8 00 00 	mov    0xa8(%rsp),%rsi
  5b4824:	00 
  5b4825:	48 85 f6             	test   %rsi,%rsi
  5b4828:	74 17                	je     5b4841 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3c91>
  5b482a:	48 8b bc 24 b0 00 00 	mov    0xb0(%rsp),%rdi
  5b4831:	00 
  5b4832:	48 c1 e6 02          	shl    $0x2,%rsi
  5b4836:	ba 04 00 00 00       	mov    $0x4,%edx
  5b483b:	ff 15 b7 55 53 00    	call   *0x5355b7(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b4841:	48 8b b4 24 78 01 00 	mov    0x178(%rsp),%rsi
  5b4848:	00 
  5b4849:	48 85 f6             	test   %rsi,%rsi
  5b484c:	74 13                	je     5b4861 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3cb1>
  5b484e:	48 8b bc 24 80 01 00 	mov    0x180(%rsp),%rdi
  5b4855:	00 
  5b4856:	ba 01 00 00 00       	mov    $0x1,%edx
  5b485b:	ff 15 97 55 53 00    	call   *0x535597(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b4861:	48 8b b4 24 60 01 00 	mov    0x160(%rsp),%rsi
  5b4868:	00 
  5b4869:	48 85 f6             	test   %rsi,%rsi
  5b486c:	74 17                	je     5b4885 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3cd5>
  5b486e:	48 8b bc 24 68 01 00 	mov    0x168(%rsp),%rdi
  5b4875:	00 
  5b4876:	48 c1 e6 04          	shl    $0x4,%rsi
  5b487a:	ba 04 00 00 00       	mov    $0x4,%edx
  5b487f:	ff 15 73 55 53 00    	call   *0x535573(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b4885:	48 8b b4 24 48 01 00 	mov    0x148(%rsp),%rsi
  5b488c:	00 
  5b488d:	48 85 f6             	test   %rsi,%rsi
  5b4890:	74 17                	je     5b48a9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3cf9>
  5b4892:	48 8b bc 24 50 01 00 	mov    0x150(%rsp),%rdi
  5b4899:	00 
  5b489a:	48 c1 e6 04          	shl    $0x4,%rsi
  5b489e:	ba 04 00 00 00       	mov    $0x4,%edx
  5b48a3:	ff 15 4f 55 53 00    	call   *0x53554f(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b48a9:	44 89 74 24 08       	mov    %r14d,0x8(%rsp)
  5b48ae:	48 8b 84 24 30 01 00 	mov    0x130(%rsp),%rax
  5b48b5:	00 
  5b48b6:	48 85 c0             	test   %rax,%rax
  5b48b9:	74 17                	je     5b48d2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3d22>
  5b48bb:	48 8b bc 24 38 01 00 	mov    0x138(%rsp),%rdi
  5b48c2:	00 
  5b48c3:	48 6b f0 38          	imul   $0x38,%rax,%rsi
  5b48c7:	ba 08 00 00 00       	mov    $0x8,%edx
  5b48cc:	ff 15 26 55 53 00    	call   *0x535526(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b48d2:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  5b48d7:	74 0d                	je     5b48e6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3d36>
  5b48d9:	48 8d bc 24 b8 01 00 	lea    0x1b8(%rsp),%rdi
  5b48e0:	00 
  5b48e1:	e8 fa 19 f8 ff       	call   5362e0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs6gaF1xUz9Bf_4gpui7runtime9PresentedEEB1b_>
  5b48e6:	83 bc 24 28 03 00 00 	cmpl   $0xfffffffe,0x328(%rsp)
  5b48ed:	fe 
  5b48ee:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b48f3:	74 0d                	je     5b4902 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3d52>
  5b48f5:	48 8d bc 24 28 03 00 	lea    0x328(%rsp),%rdi
  5b48fc:	00 
  5b48fd:	e8 ee 2f f8 ff       	call   5378f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime5ErrorEBF_.llvm.18178969024155037896>
  5b4902:	48 8b bc 24 20 01 00 	mov    0x120(%rsp),%rdi
  5b4909:	00 
  5b490a:	48 8b b4 24 28 01 00 	mov    0x128(%rsp),%rsi
  5b4911:	00 
  5b4912:	e8 39 50 f7 ff       	call   529950 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs7XZEQI6Z5Ts_11gpui_canvas4text10TextShaperEECs6gaF1xUz9Bf_4gpui>
  5b4917:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  5b491e:	00 
  5b491f:	48 85 c0             	test   %rax,%rax
  5b4922:	74 14                	je     5b4938 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3d88>
  5b4924:	f0 48 ff 08          	lock decq (%rax)
  5b4928:	75 0e                	jne    5b4938 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3d88>
  5b492a:	48 8d bc 24 98 00 00 	lea    0x98(%rsp),%rdi
  5b4931:	00 
  5b4932:	ff 15 68 55 53 00    	call   *0x535568(%rip)        # ae9ea0 <_DYNAMIC+0x2f0>
  5b4938:	83 bc 24 58 0c 00 00 	cmpl   $0x2,0xc58(%rsp)
  5b493f:	02 
  5b4940:	74 12                	je     5b4954 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3da4>
  5b4942:	45 84 f6             	test   %r14b,%r14b
  5b4945:	74 0d                	je     5b4954 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3da4>
  5b4947:	48 8d bc 24 58 0c 00 	lea    0xc58(%rsp),%rdi
  5b494e:	00 
  5b494f:	e8 1c 32 f8 ff       	call   537b70 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs7XZEQI6Z5Ts_11gpui_canvas6canvas6CanvasECs6gaF1xUz9Bf_4gpui>
  5b4954:	41 c1 e5 08          	shl    $0x8,%r13d
  5b4958:	41 0f b6 c4          	movzbl %r12b,%eax
  5b495c:	4c 09 e8             	or     %r13,%rax
  5b495f:	48 c1 e5 20          	shl    $0x20,%rbp
  5b4963:	48 09 c5             	or     %rax,%rbp
  5b4966:	8b 44 24 58          	mov    0x58(%rsp),%eax
  5b496a:	8b 4c 24 5b          	mov    0x5b(%rsp),%ecx
  5b496e:	89 84 24 a1 02 00 00 	mov    %eax,0x2a1(%rsp)
  5b4975:	89 8c 24 a4 02 00 00 	mov    %ecx,0x2a4(%rsp)
  5b497c:	4c 89 bc 24 70 02 00 	mov    %r15,0x270(%rsp)
  5b4983:	00 
  5b4984:	48 89 ac 24 78 02 00 	mov    %rbp,0x278(%rsp)
  5b498b:	00 
  5b498c:	0f 28 44 24 60       	movaps 0x60(%rsp),%xmm0
  5b4991:	0f 11 84 24 80 02 00 	movups %xmm0,0x280(%rsp)
  5b4998:	00 
  5b4999:	66 0f 28 44 24 30    	movapd 0x30(%rsp),%xmm0
  5b499f:	66 0f 11 84 24 90 02 	movupd %xmm0,0x290(%rsp)
  5b49a6:	00 00 
  5b49a8:	88 9c 24 a0 02 00 00 	mov    %bl,0x2a0(%rsp)
  5b49af:	49 83 ff fd          	cmp    $0xfffffffffffffffd,%r15
  5b49b3:	0f 85 0a 01 00 00    	jne    5b4ac3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3f13>
  5b49b9:	4c 8b 34 24          	mov    (%rsp),%r14
  5b49bd:	41 c6 86 58 09 00 00 	movb   $0x1,0x958(%r14)
  5b49c4:	01 
  5b49c5:	4d 8d be 98 08 00 00 	lea    0x898(%r14),%r15
  5b49cc:	4c 89 ff             	mov    %r15,%rdi
  5b49cf:	e8 bc 52 f7 ff       	call   529c90 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs7XZEQI6Z5Ts_11gpui_canvas4text10TextSystemEECs6gaF1xUz9Bf_4gpui>
  5b49d4:	49 c7 86 98 08 00 00 	movq   $0x0,0x898(%r14)
  5b49db:	00 00 00 00 
  5b49df:	49 8b 9e e0 02 00 00 	mov    0x2e0(%r14),%rbx
  5b49e6:	48 85 db             	test   %rbx,%rbx
  5b49e9:	74 35                	je     5b4a20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3e70>
  5b49eb:	4d 8b b6 d8 02 00 00 	mov    0x2d8(%r14),%r14
  5b49f2:	eb 15                	jmp    5b4a09 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3e59>
  5b49f4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b49fb:	00 00 00 00 00 
  5b4a00:	49 83 c6 50          	add    $0x50,%r14
  5b4a04:	48 ff cb             	dec    %rbx
  5b4a07:	74 17                	je     5b4a20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3e70>
  5b4a09:	49 83 3e fe          	cmpq   $0xfffffffffffffffe,(%r14)
  5b4a0d:	74 f1                	je     5b4a00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3e50>
  5b4a0f:	4c 89 f7             	mov    %r14,%rdi
  5b4a12:	e8 f9 4c f7 ff       	call   529710 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime6ShapedEEB11_.llvm.18178969024155037896>
  5b4a17:	49 c7 06 ff ff ff ff 	movq   $0xffffffffffffffff,(%r14)
  5b4a1e:	eb e0                	jmp    5b4a00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3e50>
  5b4a20:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5b4a27:	00 
  5b4a28:	48 c7 00 10 00 00 00 	movq   $0x10,(%rax)
  5b4a2f:	4c 8b b4 24 80 02 00 	mov    0x280(%rsp),%r14
  5b4a36:	00 
  5b4a37:	49 8b 06             	mov    (%r14),%rax
  5b4a3a:	48 85 c0             	test   %rax,%rax
  5b4a3d:	74 05                	je     5b4a44 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3e94>
  5b4a3f:	48 89 ef             	mov    %rbp,%rdi
  5b4a42:	ff d0                	call   *%rax
  5b4a44:	49 8b 76 08          	mov    0x8(%r14),%rsi
  5b4a48:	48 85 f6             	test   %rsi,%rsi
  5b4a4b:	0f 84 c2 00 00 00    	je     5b4b13 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3f63>
  5b4a51:	49 8b 56 10          	mov    0x10(%r14),%rdx
  5b4a55:	48 89 ef             	mov    %rbp,%rdi
  5b4a58:	ff 15 9a 53 53 00    	call   *0x53539a(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b4a5e:	e9 b0 00 00 00       	jmp    5b4b13 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3f63>
  5b4a63:	66 0f 7f 44 24 60    	movdqa %xmm0,0x60(%rsp)
  5b4a69:	0f b6 9c 24 00 05 00 	movzbl 0x500(%rsp),%ebx
  5b4a70:	00 
  5b4a71:	8b 8c 24 01 05 00 00 	mov    0x501(%rsp),%ecx
  5b4a78:	89 4c 24 58          	mov    %ecx,0x58(%rsp)
  5b4a7c:	8b 8c 24 04 05 00 00 	mov    0x504(%rsp),%ecx
  5b4a83:	89 4c 24 5b          	mov    %ecx,0x5b(%rsp)
  5b4a87:	f3 0f 7e 84 24 f8 04 	movq   0x4f8(%rsp),%xmm0
  5b4a8e:	00 00 
  5b4a90:	45 89 e5             	mov    %r12d,%r13d
  5b4a93:	41 c1 ed 08          	shr    $0x8,%r13d
  5b4a97:	66 48 0f 6e c8       	movq   %rax,%xmm1
  5b4a9c:	66 0f 6c c8          	punpcklqdq %xmm0,%xmm1
  5b4aa0:	66 0f 7f 4c 24 30    	movdqa %xmm1,0x30(%rsp)
  5b4aa6:	e9 f2 fc ff ff       	jmp    5b479d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3bed>
  5b4aab:	48 c7 84 24 70 02 00 	movq   $0x1e,0x270(%rsp)
  5b4ab2:	00 1e 00 00 00 
  5b4ab7:	48 c7 84 24 78 02 00 	movq   $0x0,0x278(%rsp)
  5b4abe:	00 00 00 00 00 
  5b4ac3:	48 8b 84 24 a0 02 00 	mov    0x2a0(%rsp),%rax
  5b4aca:	00 
  5b4acb:	48 8b 94 24 a0 00 00 	mov    0xa0(%rsp),%rdx
  5b4ad2:	00 
  5b4ad3:	48 89 42 30          	mov    %rax,0x30(%rdx)
  5b4ad7:	48 8b 84 24 70 02 00 	mov    0x270(%rsp),%rax
  5b4ade:	00 
  5b4adf:	48 8b 8c 24 78 02 00 	mov    0x278(%rsp),%rcx
  5b4ae6:	00 
  5b4ae7:	66 0f 10 84 24 80 02 	movupd 0x280(%rsp),%xmm0
  5b4aee:	00 00 
  5b4af0:	0f 10 8c 24 90 02 00 	movups 0x290(%rsp),%xmm1
  5b4af7:	00 
  5b4af8:	0f 11 4a 20          	movups %xmm1,0x20(%rdx)
  5b4afc:	66 0f 11 42 10       	movupd %xmm0,0x10(%rdx)
  5b4b01:	48 89 02             	mov    %rax,(%rdx)
  5b4b04:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  5b4b08:	48 8b 04 24          	mov    (%rsp),%rax
  5b4b0c:	c6 80 58 09 00 00 01 	movb   $0x1,0x958(%rax)
  5b4b13:	48 81 c4 98 10 00 00 	add    $0x1098,%rsp
  5b4b1a:	5b                   	pop    %rbx
  5b4b1b:	41 5c                	pop    %r12
  5b4b1d:	41 5d                	pop    %r13
  5b4b1f:	41 5e                	pop    %r14
  5b4b21:	41 5f                	pop    %r15
  5b4b23:	5d                   	pop    %rbp
  5b4b24:	c3                   	ret
  5b4b25:	48 8d 3d bc 6f ac ff 	lea    -0x539044(%rip),%rdi        # 7bae8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5b4b2c:	48 8d 15 6d 40 50 00 	lea    0x50406d(%rip),%rdx        # ab8ba0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x130>
  5b4b33:	be a1 00 00 00       	mov    $0xa1,%esi
  5b4b38:	ff 15 f2 52 53 00    	call   *0x5352f2(%rip)        # ae9e30 <_DYNAMIC+0x280>
  5b4b3e:	e9 49 d4 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4b43:	41 b5 01             	mov    $0x1,%r13b
  5b4b46:	48 8d 3d 0b 40 50 00 	lea    0x50400b(%rip),%rdi        # ab8b58 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0xe8>
  5b4b4d:	b0 01                	mov    $0x1,%al
  5b4b4f:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b4b53:	40 b5 01             	mov    $0x1,%bpl
  5b4b56:	b0 01                	mov    $0x1,%al
  5b4b58:	89 44 24 08          	mov    %eax,0x8(%rsp)
  5b4b5c:	ff 15 06 53 53 00    	call   *0x535306(%rip)        # ae9e68 <_DYNAMIC+0x2b8>
  5b4b62:	e9 25 d4 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4b67:	48 8d 3d ea 76 50 00 	lea    0x5076ea(%rip),%rdi        # abc258 <anon.e9030509e4132593006b31277530c411.11.llvm.555413502705965614>
  5b4b6e:	ff 15 f4 52 53 00    	call   *0x5352f4(%rip)        # ae9e68 <_DYNAMIC+0x2b8>
  5b4b74:	e9 13 d4 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4b79:	48 8d 05 b8 41 50 00 	lea    0x5041b8(%rip),%rax        # ab8d38 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x108>
  5b4b80:	48 89 84 24 58 02 00 	mov    %rax,0x258(%rsp)
  5b4b87:	00 
  5b4b88:	48 8d 3d 50 70 ac ff 	lea    -0x538fb0(%rip),%rdi        # 7bbdf <anon.c906c25ea787c8c2757c1f36aabcd0ba.91.llvm.18178969024155037896+0x2a>
  5b4b8f:	be 1e 00 00 00       	mov    $0x1e,%esi
  5b4b94:	48 8b 94 24 58 02 00 	mov    0x258(%rsp),%rdx
  5b4b9b:	00 
  5b4b9c:	ff 15 be 52 53 00    	call   *0x5352be(%rip)        # ae9e60 <_DYNAMIC+0x2b0>
  5b4ba2:	e9 e5 d3 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4ba7:	b8 55 00 00 00       	mov    $0x55,%eax
  5b4bac:	48 89 84 24 f8 01 00 	mov    %rax,0x1f8(%rsp)
  5b4bb3:	00 
  5b4bb4:	48 8d 05 6b 67 ac ff 	lea    -0x539895(%rip),%rax        # 7b326 <anon.c906c25ea787c8c2757c1f36aabcd0ba.26.llvm.18178969024155037896>
  5b4bbb:	48 89 84 24 60 02 00 	mov    %rax,0x260(%rsp)
  5b4bc2:	00 
  5b4bc3:	48 8d 05 d6 3b 50 00 	lea    0x503bd6(%rip),%rax        # ab87a0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896>
  5b4bca:	48 89 84 24 68 02 00 	mov    %rax,0x268(%rsp)
  5b4bd1:	00 
  5b4bd2:	48 8b bc 24 60 02 00 	mov    0x260(%rsp),%rdi
  5b4bd9:	00 
  5b4bda:	48 8b b4 24 f8 01 00 	mov    0x1f8(%rsp),%rsi
  5b4be1:	00 
  5b4be2:	48 8b 94 24 68 02 00 	mov    0x268(%rsp),%rdx
  5b4be9:	00 
  5b4bea:	ff 15 40 52 53 00    	call   *0x535240(%rip)        # ae9e30 <_DYNAMIC+0x280>
  5b4bf0:	e9 97 d3 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4bf5:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
  5b4bfc:	00 
  5b4bfd:	ff 15 f5 52 53 00    	call   *0x5352f5(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5b4c03:	e9 84 d3 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4c08:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
  5b4c0f:	00 
  5b4c10:	ff 15 e2 52 53 00    	call   *0x5352e2(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5b4c16:	e9 71 d3 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4c1b:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
  5b4c22:	00 
  5b4c23:	ff 15 cf 52 53 00    	call   *0x5352cf(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5b4c29:	e9 5e d3 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4c2e:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
  5b4c35:	00 
  5b4c36:	ff 15 bc 52 53 00    	call   *0x5352bc(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5b4c3c:	e9 4b d3 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4c41:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
  5b4c48:	00 
  5b4c49:	ff 15 a9 52 53 00    	call   *0x5352a9(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5b4c4f:	e9 38 d3 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4c54:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
  5b4c5b:	00 
  5b4c5c:	ff 15 96 52 53 00    	call   *0x535296(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5b4c62:	e9 25 d3 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4c67:	48 8d 05 62 3b 50 00 	lea    0x503b62(%rip),%rax        # ab87d0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x30>
  5b4c6e:	48 89 84 24 e8 01 00 	mov    %rax,0x1e8(%rsp)
  5b4c75:	00 
  5b4c76:	48 8b bc 24 e8 01 00 	mov    0x1e8(%rsp),%rdi
  5b4c7d:	00 
  5b4c7e:	ff 15 e4 51 53 00    	call   *0x5351e4(%rip)        # ae9e68 <_DYNAMIC+0x2b8>
  5b4c84:	e9 03 d3 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4c89:	48 8d 3d c8 75 50 00 	lea    0x5075c8(%rip),%rdi        # abc258 <anon.e9030509e4132593006b31277530c411.11.llvm.555413502705965614>
  5b4c90:	ff 15 d2 51 53 00    	call   *0x5351d2(%rip)        # ae9e68 <_DYNAMIC+0x2b8>
  5b4c96:	e9 f1 d2 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4c9b:	4c 89 fb             	mov    %r15,%rbx
  5b4c9e:	48 8d 3d 43 6e ac ff 	lea    -0x5391bd(%rip),%rdi        # 7bae8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5b4ca5:	48 8d 15 f4 3e 50 00 	lea    0x503ef4(%rip),%rdx        # ab8ba0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x130>
  5b4cac:	be a1 00 00 00       	mov    $0xa1,%esi
  5b4cb1:	ff 15 79 51 53 00    	call   *0x535179(%rip)        # ae9e30 <_DYNAMIC+0x280>
  5b4cb7:	e9 d0 d2 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4cbc:	48 8d 3d 4d 66 ac ff 	lea    -0x5399b3(%rip),%rdi        # 7b310 <anon.1fd5a6dfce1e15409e22077740bd43db.29.llvm.12479153529690704726+0x121>
  5b4cc3:	be 16 00 00 00       	mov    $0x16,%esi
  5b4cc8:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  5b4ccd:	ff 15 8d 51 53 00    	call   *0x53518d(%rip)        # ae9e60 <_DYNAMIC+0x2b0>
  5b4cd3:	e9 b4 d2 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4cd8:	b8 a1 00 00 00       	mov    $0xa1,%eax
  5b4cdd:	48 89 84 24 f8 01 00 	mov    %rax,0x1f8(%rsp)
  5b4ce4:	00 
  5b4ce5:	e9 e8 fe ff ff       	jmp    5b4bd2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4022>
  5b4cea:	48 8d 3d e7 3f 50 00 	lea    0x503fe7(%rip),%rdi        # ab8cd8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0xa8>
  5b4cf1:	ff 15 71 51 53 00    	call   *0x535171(%rip)        # ae9e68 <_DYNAMIC+0x2b8>
  5b4cf7:	e9 90 d2 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4cfc:	48 8d 05 4d 40 50 00 	lea    0x50404d(%rip),%rax        # ab8d50 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x120>
  5b4d03:	e9 66 ff ff ff       	jmp    5b4c6e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x40be>
  5b4d08:	48 8d 3d 09 3b 50 00 	lea    0x503b09(%rip),%rdi        # ab8818 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x78>
  5b4d0f:	ff 15 53 51 53 00    	call   *0x535153(%rip)        # ae9e68 <_DYNAMIC+0x2b8>
  5b4d15:	e9 72 d2 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4d1a:	48 8d 05 27 3b 50 00 	lea    0x503b27(%rip),%rax        # ab8848 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0xa8>
  5b4d21:	eb 3d                	jmp    5b4d60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41b0>
  5b4d23:	48 8d 05 4e 3f 50 00 	lea    0x503f4e(%rip),%rax        # ab8c78 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x48>
  5b4d2a:	eb 34                	jmp    5b4d60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41b0>
  5b4d2c:	48 8d 05 ad 3d 50 00 	lea    0x503dad(%rip),%rax        # ab8ae0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x70>
  5b4d33:	eb 2b                	jmp    5b4d60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41b0>
  5b4d35:	48 8d 05 bc 3d 50 00 	lea    0x503dbc(%rip),%rax        # ab8af8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x88>
  5b4d3c:	eb 22                	jmp    5b4d60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41b0>
  5b4d3e:	4c 89 ef             	mov    %r13,%rdi
  5b4d41:	48 8d 05 98 3d 50 00 	lea    0x503d98(%rip),%rax        # ab8ae0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x70>
  5b4d48:	eb 16                	jmp    5b4d60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41b0>
  5b4d4a:	4c 89 ef             	mov    %r13,%rdi
  5b4d4d:	48 8d 05 a4 3d 50 00 	lea    0x503da4(%rip),%rax        # ab8af8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x88>
  5b4d54:	eb 0a                	jmp    5b4d60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x41b0>
  5b4d56:	48 89 d7             	mov    %rdx,%rdi
  5b4d59:	48 8d 05 b0 3d 50 00 	lea    0x503db0(%rip),%rax        # ab8b10 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0xa0>
  5b4d60:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  5b4d65:	48 89 ee             	mov    %rbp,%rsi
  5b4d68:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  5b4d6d:	ff 15 b5 50 53 00    	call   *0x5350b5(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5b4d73:	e9 14 d2 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4d78:	b0 01                	mov    $0x1,%al
  5b4d7a:	89 44 24 08          	mov    %eax,0x8(%rsp)
  5b4d7e:	48 8d 15 3b 3f 50 00 	lea    0x503f3b(%rip),%rdx        # ab8cc0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x90>
  5b4d85:	31 ff                	xor    %edi,%edi
  5b4d87:	31 f6                	xor    %esi,%esi
  5b4d89:	ff 15 99 50 53 00    	call   *0x535099(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5b4d8f:	e9 f8 d1 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4d94:	49 89 c7             	mov    %rax,%r15
  5b4d97:	48 8d 05 6a 3f 50 00 	lea    0x503f6a(%rip),%rax        # ab8d08 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0xd8>
  5b4d9e:	eb 5e                	jmp    5b4dfe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x424e>
  5b4da0:	48 8d 05 49 3b 50 00 	lea    0x503b49(%rip),%rax        # ab88f0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x150>
  5b4da7:	eb 55                	jmp    5b4dfe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x424e>
  5b4da9:	48 8d 05 38 3a 50 00 	lea    0x503a38(%rip),%rax        # ab87e8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x48>
  5b4db0:	eb 4c                	jmp    5b4dfe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x424e>
  5b4db2:	48 8d 05 4f 3b 50 00 	lea    0x503b4f(%rip),%rax        # ab8908 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x168>
  5b4db9:	eb 43                	jmp    5b4dfe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x424e>
  5b4dbb:	48 8d 05 5e 3b 50 00 	lea    0x503b5e(%rip),%rax        # ab8920 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x180>
  5b4dc2:	eb 3a                	jmp    5b4dfe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x424e>
  5b4dc4:	49 89 c4             	mov    %rax,%r12
  5b4dc7:	48 8d 05 ea 39 50 00 	lea    0x5039ea(%rip),%rax        # ab87b8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x18>
  5b4dce:	eb 2e                	jmp    5b4dfe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x424e>
  5b4dd0:	48 8d 05 79 3b 50 00 	lea    0x503b79(%rip),%rax        # ab8950 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x1b0>
  5b4dd7:	eb 25                	jmp    5b4dfe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x424e>
  5b4dd9:	48 8d 05 58 3b 50 00 	lea    0x503b58(%rip),%rax        # ab8938 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x198>
  5b4de0:	eb 1c                	jmp    5b4dfe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x424e>
  5b4de2:	48 8d 05 f7 3c 50 00 	lea    0x503cf7(%rip),%rax        # ab8ae0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x70>
  5b4de9:	eb 13                	jmp    5b4dfe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x424e>
  5b4deb:	48 8d 05 06 3d 50 00 	lea    0x503d06(%rip),%rax        # ab8af8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x88>
  5b4df2:	eb 0a                	jmp    5b4dfe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x424e>
  5b4df4:	49 89 cc             	mov    %rcx,%r12
  5b4df7:	48 8d 05 12 3d 50 00 	lea    0x503d12(%rip),%rax        # ab8b10 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0xa0>
  5b4dfe:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  5b4e03:	4c 89 e7             	mov    %r12,%rdi
  5b4e06:	4c 89 fe             	mov    %r15,%rsi
  5b4e09:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  5b4e0e:	ff 15 14 50 53 00    	call   *0x535014(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5b4e14:	e9 73 d1 ff ff       	jmp    5b1f8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x13dc>
  5b4e19:	48 8d 05 88 3a 50 00 	lea    0x503a88(%rip),%rax        # ab88a8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x108>
  5b4e20:	eb dc                	jmp    5b4dfe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x424e>
  5b4e22:	49 89 c7             	mov    %rax,%r15
  5b4e25:	48 8b 04 24          	mov    (%rsp),%rax
  5b4e29:	48 8b 80 10 08 00 00 	mov    0x810(%rax),%rax
  5b4e30:	0f 28 84 24 20 05 00 	movaps 0x520(%rsp),%xmm0
  5b4e37:	00 
  5b4e38:	0f 11 80 c8 00 00 00 	movups %xmm0,0xc8(%rax)
  5b4e3f:	0f 28 84 24 10 05 00 	movaps 0x510(%rsp),%xmm0
  5b4e46:	00 
  5b4e47:	0f 11 80 b8 00 00 00 	movups %xmm0,0xb8(%rax)
  5b4e4e:	66 0f 28 84 24 d0 04 	movapd 0x4d0(%rsp),%xmm0
  5b4e55:	00 00 
  5b4e57:	0f 28 8c 24 e0 04 00 	movaps 0x4e0(%rsp),%xmm1
  5b4e5e:	00 
  5b4e5f:	0f 28 94 24 f0 04 00 	movaps 0x4f0(%rsp),%xmm2
  5b4e66:	00 
  5b4e67:	0f 28 9c 24 00 05 00 	movaps 0x500(%rsp),%xmm3
  5b4e6e:	00 
  5b4e6f:	0f 11 98 a8 00 00 00 	movups %xmm3,0xa8(%rax)
  5b4e76:	0f 11 90 98 00 00 00 	movups %xmm2,0x98(%rax)
  5b4e7d:	0f 11 88 88 00 00 00 	movups %xmm1,0x88(%rax)
  5b4e84:	66 0f 11 40 78       	movupd %xmm0,0x78(%rax)
  5b4e89:	41 b5 01             	mov    $0x1,%r13b
  5b4e8c:	c7 44 24 40 00 00 00 	movl   $0x0,0x40(%rsp)
  5b4e93:	00 
  5b4e94:	b0 01                	mov    $0x1,%al
  5b4e96:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b4e9a:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b4e9f:	e9 f5 03 00 00       	jmp    5b5299 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x46e9>
  5b4ea4:	48 89 c3             	mov    %rax,%rbx
  5b4ea7:	be f0 00 00 00       	mov    $0xf0,%esi
  5b4eac:	ba 08 00 00 00       	mov    $0x8,%edx
  5b4eb1:	4c 89 ff             	mov    %r15,%rdi
  5b4eb4:	ff 15 3e 4f 53 00    	call   *0x534f3e(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b4eba:	48 8b 04 24          	mov    (%rsp),%rax
  5b4ebe:	48 c7 80 10 08 00 00 	movq   $0x0,0x810(%rax)
  5b4ec5:	00 00 00 00 
  5b4ec9:	48 89 df             	mov    %rbx,%rdi
  5b4ecc:	e8 ff 23 50 00       	call   ab72d0 <_Unwind_Resume@plt>
  5b4ed1:	49 89 c7             	mov    %rax,%r15
  5b4ed4:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
  5b4edb:	e9 90 00 00 00       	jmp    5b4f70 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x43c0>
  5b4ee0:	49 89 c7             	mov    %rax,%r15
  5b4ee3:	48 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%rsi
  5b4eea:	00 
  5b4eeb:	ba 28 02 00 00       	mov    $0x228,%edx
  5b4ef0:	48 89 df             	mov    %rbx,%rdi
  5b4ef3:	ff 15 57 4f 53 00    	call   *0x534f57(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5b4ef9:	41 b5 01             	mov    $0x1,%r13b
  5b4efc:	45 31 f6             	xor    %r14d,%r14d
  5b4eff:	b0 01                	mov    $0x1,%al
  5b4f01:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b4f05:	b0 01                	mov    $0x1,%al
  5b4f07:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b4f0b:	e9 89 03 00 00       	jmp    5b5299 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x46e9>
  5b4f10:	49 89 c7             	mov    %rax,%r15
  5b4f13:	b0 01                	mov    $0x1,%al
  5b4f15:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b4f19:	45 31 ed             	xor    %r13d,%r13d
  5b4f1c:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b4f21:	e9 73 03 00 00       	jmp    5b5299 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x46e9>
  5b4f26:	49 89 c7             	mov    %rax,%r15
  5b4f29:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5b4f30:	00 
  5b4f31:	48 89 45 10          	mov    %rax,0x10(%rbp)
  5b4f35:	0f 28 84 24 d0 04 00 	movaps 0x4d0(%rsp),%xmm0
  5b4f3c:	00 
  5b4f3d:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
  5b4f41:	4c 89 a3 78 07 00 00 	mov    %r12,0x778(%rbx)
  5b4f48:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  5b4f4f:	00 
  5b4f50:	66 89 83 80 07 00 00 	mov    %ax,0x780(%rbx)
  5b4f57:	8b 44 24 54          	mov    0x54(%rsp),%eax
  5b4f5b:	66 89 83 82 07 00 00 	mov    %ax,0x782(%rbx)
  5b4f62:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  5b4f68:	f3 0f 11 83 84 07 00 	movss  %xmm0,0x784(%rbx)
  5b4f6f:	00 
  5b4f70:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5b4f77:	00 
  5b4f78:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b4f7d:	e9 17 03 00 00       	jmp    5b5299 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x46e9>
  5b4f82:	4c 89 fb             	mov    %r15,%rbx
  5b4f85:	e9 72 02 00 00       	jmp    5b51fc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x464c>
  5b4f8a:	49 89 c7             	mov    %rax,%r15
  5b4f8d:	e9 32 03 00 00       	jmp    5b52c4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4714>
  5b4f92:	49 89 c7             	mov    %rax,%r15
  5b4f95:	48 8b bc 24 20 02 00 	mov    0x220(%rsp),%rdi
  5b4f9c:	00 
  5b4f9d:	e8 de 46 f7 ff       	call   529680 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui11shared_text10SharedTextEEB11_>
  5b4fa2:	e9 d3 02 00 00       	jmp    5b527a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x46ca>
  5b4fa7:	ff 15 6b 4e 53 00    	call   *0x534e6b(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5b4fad:	49 89 c7             	mov    %rax,%r15
  5b4fb0:	e9 3b 03 00 00       	jmp    5b52f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4740>
  5b4fb5:	49 89 c7             	mov    %rax,%r15
  5b4fb8:	48 8b 0c 24          	mov    (%rsp),%rcx
  5b4fbc:	48 89 99 98 08 00 00 	mov    %rbx,0x898(%rcx)
  5b4fc3:	44 89 a1 a0 08 00 00 	mov    %r12d,0x8a0(%rcx)
  5b4fca:	89 a9 a4 08 00 00    	mov    %ebp,0x8a4(%rcx)
  5b4fd0:	66 0f 28 84 24 10 04 	movapd 0x410(%rsp),%xmm0
  5b4fd7:	00 00 
  5b4fd9:	0f 28 8c 24 20 04 00 	movaps 0x420(%rsp),%xmm1
  5b4fe0:	00 
  5b4fe1:	0f 28 94 24 30 04 00 	movaps 0x430(%rsp),%xmm2
  5b4fe8:	00 
  5b4fe9:	66 0f 11 81 a8 08 00 	movupd %xmm0,0x8a8(%rcx)
  5b4ff0:	00 
  5b4ff1:	0f 11 89 b8 08 00 00 	movups %xmm1,0x8b8(%rcx)
  5b4ff8:	0f 11 91 c8 08 00 00 	movups %xmm2,0x8c8(%rcx)
  5b4fff:	48 8b 84 24 40 04 00 	mov    0x440(%rsp),%rax
  5b5006:	00 
  5b5007:	48 89 81 d8 08 00 00 	mov    %rax,0x8d8(%rcx)
  5b500e:	41 b6 01             	mov    $0x1,%r14b
  5b5011:	e9 f3 03 00 00       	jmp    5b5409 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4859>
  5b5016:	49 89 c7             	mov    %rax,%r15
  5b5019:	48 89 5d 00          	mov    %rbx,0x0(%rbp)
  5b501d:	66 0f 6f 84 24 c0 02 	movdqa 0x2c0(%rsp),%xmm0
  5b5024:	00 00 
  5b5026:	66 0f 7e 45 08       	movd   %xmm0,0x8(%rbp)
  5b502b:	66 0f 70 c0 55       	pshufd $0x55,%xmm0,%xmm0
  5b5030:	66 0f 7e 45 0c       	movd   %xmm0,0xc(%rbp)
  5b5035:	0f 28 84 24 f0 00 00 	movaps 0xf0(%rsp),%xmm0
  5b503c:	00 
  5b503d:	0f 28 8c 24 00 01 00 	movaps 0x100(%rsp),%xmm1
  5b5044:	00 
  5b5045:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  5b5049:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  5b504d:	48 8b 84 24 10 01 00 	mov    0x110(%rsp),%rax
  5b5054:	00 
  5b5055:	48 89 45 30          	mov    %rax,0x30(%rbp)
  5b5059:	c7 45 38 01 00 00 00 	movl   $0x1,0x38(%rbp)
  5b5060:	f3 0f 10 84 24 84 00 	movss  0x84(%rsp),%xmm0
  5b5067:	00 00 
  5b5069:	f3 0f 11 45 3c       	movss  %xmm0,0x3c(%rbp)
  5b506e:	e9 07 02 00 00       	jmp    5b527a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x46ca>
  5b5073:	49 89 c7             	mov    %rax,%r15
  5b5076:	e9 68 02 00 00       	jmp    5b52e3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4733>
  5b507b:	49 89 c7             	mov    %rax,%r15
  5b507e:	41 b5 01             	mov    $0x1,%r13b
  5b5081:	b0 01                	mov    $0x1,%al
  5b5083:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b5087:	b0 01                	mov    $0x1,%al
  5b5089:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b508d:	41 b6 01             	mov    $0x1,%r14b
  5b5090:	e9 04 02 00 00       	jmp    5b5299 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x46e9>
  5b5095:	49 89 c7             	mov    %rax,%r15
  5b5098:	44 8b ac 24 c0 00 00 	mov    0xc0(%rsp),%r13d
  5b509f:	00 
  5b50a0:	e9 01 02 00 00       	jmp    5b52a6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x46f6>
  5b50a5:	48 89 c3             	mov    %rax,%rbx
  5b50a8:	b8 78 00 00 00       	mov    $0x78,%eax
  5b50ad:	eb 08                	jmp    5b50b7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4507>
  5b50af:	48 89 c3             	mov    %rax,%rbx
  5b50b2:	b8 18 00 00 00       	mov    $0x18,%eax
  5b50b7:	41 0f 10 44 24 50    	movups 0x50(%r12),%xmm0
  5b50bd:	41 0f 11 44 07 50    	movups %xmm0,0x50(%r15,%rax,1)
  5b50c3:	41 0f 10 44 24 40    	movups 0x40(%r12),%xmm0
  5b50c9:	41 0f 11 44 07 40    	movups %xmm0,0x40(%r15,%rax,1)
  5b50cf:	41 0f 10 04 24       	movups (%r12),%xmm0
  5b50d4:	41 0f 10 4c 24 10    	movups 0x10(%r12),%xmm1
  5b50da:	41 0f 10 54 24 20    	movups 0x20(%r12),%xmm2
  5b50e0:	41 0f 10 5c 24 30    	movups 0x30(%r12),%xmm3
  5b50e6:	41 0f 11 5c 07 30    	movups %xmm3,0x30(%r15,%rax,1)
  5b50ec:	41 0f 11 54 07 20    	movups %xmm2,0x20(%r15,%rax,1)
  5b50f2:	41 0f 11 4c 07 10    	movups %xmm1,0x10(%r15,%rax,1)
  5b50f8:	41 0f 11 04 07       	movups %xmm0,(%r15,%rax,1)
  5b50fd:	48 89 df             	mov    %rbx,%rdi
  5b5100:	e8 cb 21 50 00       	call   ab72d0 <_Unwind_Resume@plt>
  5b5105:	49 89 c7             	mov    %rax,%r15
  5b5108:	48 8d b4 24 d0 04 00 	lea    0x4d0(%rsp),%rsi
  5b510f:	00 
  5b5110:	ba 48 04 00 00       	mov    $0x448,%edx
  5b5115:	48 89 df             	mov    %rbx,%rdi
  5b5118:	ff 15 32 4d 53 00    	call   *0x534d32(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5b511e:	e9 ad 02 00 00       	jmp    5b53d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4820>
  5b5123:	49 89 c7             	mov    %rax,%r15
  5b5126:	e9 de 02 00 00       	jmp    5b5409 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4859>
  5b512b:	49 89 c7             	mov    %rax,%r15
  5b512e:	e9 b5 02 00 00       	jmp    5b53e8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4838>
  5b5133:	eb 53                	jmp    5b5188 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x45d8>
  5b5135:	48 89 c3             	mov    %rax,%rbx
  5b5138:	eb 5e                	jmp    5b5198 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x45e8>
  5b513a:	48 89 c3             	mov    %rax,%rbx
  5b513d:	49 8b 76 08          	mov    0x8(%r14),%rsi
  5b5141:	48 85 f6             	test   %rsi,%rsi
  5b5144:	0f 84 a4 00 00 00    	je     5b51ee <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x463e>
  5b514a:	49 8b 56 10          	mov    0x10(%r14),%rdx
  5b514e:	48 89 ef             	mov    %rbp,%rdi
  5b5151:	ff 15 a1 4c 53 00    	call   *0x534ca1(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b5157:	48 89 df             	mov    %rbx,%rdi
  5b515a:	e8 71 21 50 00       	call   ab72d0 <_Unwind_Resume@plt>
  5b515f:	48 89 c3             	mov    %rax,%rbx
  5b5162:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
  5b5169:	eb 76                	jmp    5b51e1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4631>
  5b516b:	e9 5d 02 00 00       	jmp    5b53cd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x481d>
  5b5170:	eb 16                	jmp    5b5188 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x45d8>
  5b5172:	e9 00 01 00 00       	jmp    5b5277 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x46c7>
  5b5177:	49 89 c7             	mov    %rax,%r15
  5b517a:	e9 a6 02 00 00       	jmp    5b5425 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4875>
  5b517f:	eb 07                	jmp    5b5188 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x45d8>
  5b5181:	eb 05                	jmp    5b5188 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x45d8>
  5b5183:	e9 45 02 00 00       	jmp    5b53cd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x481d>
  5b5188:	48 89 c3             	mov    %rax,%rbx
  5b518b:	48 8d bc 24 58 0c 00 	lea    0xc58(%rsp),%rdi
  5b5192:	00 
  5b5193:	e8 98 88 17 00       	call   72da30 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5b5198:	48 8d bc 24 d0 04 00 	lea    0x4d0(%rsp),%rdi
  5b519f:	00 
  5b51a0:	e8 4b 39 f8 ff       	call   538af0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5SheetEBH_>
  5b51a5:	eb 47                	jmp    5b51ee <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x463e>
  5b51a7:	e9 21 02 00 00       	jmp    5b53cd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x481d>
  5b51ac:	0f 0b                	ud2
  5b51ae:	49 89 c7             	mov    %rax,%r15
  5b51b1:	48 8d bc 24 f8 03 00 	lea    0x3f8(%rsp),%rdi
  5b51b8:	00 
  5b51b9:	e8 b2 12 f8 ff       	call   536470 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs7XZEQI6Z5Ts_11gpui_canvas5image5ImageEECs6gaF1xUz9Bf_4gpui>
  5b51be:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b51c3:	b0 01                	mov    $0x1,%al
  5b51c5:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b51c9:	45 31 ed             	xor    %r13d,%r13d
  5b51cc:	e9 c8 00 00 00       	jmp    5b5299 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x46e9>
  5b51d1:	ff 15 41 4c 53 00    	call   *0x534c41(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5b51d7:	48 89 c3             	mov    %rax,%rbx
  5b51da:	49 c7 06 ff ff ff ff 	movq   $0xffffffffffffffff,(%r14)
  5b51e1:	48 8d bc 24 70 02 00 	lea    0x270(%rsp),%rdi
  5b51e8:	00 
  5b51e9:	e8 a2 4e f7 ff       	call   52a090 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultIBC_bNtNtCs6gaF1xUz9Bf_4gpui7runtime5ErrorEINtNtCscdodAO9FK5_5alloc5boxed3BoxDNtNtB4_3any3AnyNtNtB4_6marker4SendEL_EEEB16_>
  5b51ee:	48 89 df             	mov    %rbx,%rdi
  5b51f1:	e8 da 20 50 00       	call   ab72d0 <_Unwind_Resume@plt>
  5b51f6:	ff 15 1c 4c 53 00    	call   *0x534c1c(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5b51fc:	49 89 c7             	mov    %rax,%r15
  5b51ff:	48 89 df             	mov    %rbx,%rdi
  5b5202:	e8 79 44 f7 ff       	call   529680 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui11shared_text10SharedTextEEB11_>
  5b5207:	eb 71                	jmp    5b527a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x46ca>
  5b5209:	0f 0b                	ud2
  5b520b:	49 89 c7             	mov    %rax,%r15
  5b520e:	b0 01                	mov    $0x1,%al
  5b5210:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b5214:	41 b6 01             	mov    $0x1,%r14b
  5b5217:	e9 f8 00 00 00       	jmp    5b5314 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4764>
  5b521c:	49 89 c7             	mov    %rax,%r15
  5b521f:	b0 01                	mov    $0x1,%al
  5b5221:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b5225:	41 b6 01             	mov    $0x1,%r14b
  5b5228:	e9 07 01 00 00       	jmp    5b5334 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4784>
  5b522d:	49 89 c7             	mov    %rax,%r15
  5b5230:	b0 01                	mov    $0x1,%al
  5b5232:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b5236:	41 b6 01             	mov    $0x1,%r14b
  5b5239:	e9 1a 01 00 00       	jmp    5b5358 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x47a8>
  5b523e:	49 89 c7             	mov    %rax,%r15
  5b5241:	b0 01                	mov    $0x1,%al
  5b5243:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b5247:	41 b6 01             	mov    $0x1,%r14b
  5b524a:	e9 2d 01 00 00       	jmp    5b537c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x47cc>
  5b524f:	49 89 c7             	mov    %rax,%r15
  5b5252:	41 b6 01             	mov    $0x1,%r14b
  5b5255:	e9 4d 01 00 00       	jmp    5b53a7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x47f7>
  5b525a:	49 89 c7             	mov    %rax,%r15
  5b525d:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b5262:	e9 4d 01 00 00       	jmp    5b53b4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4804>
  5b5267:	0f 0b                	ud2
  5b5269:	89 6c 24 10          	mov    %ebp,0x10(%rsp)
  5b526d:	49 89 c7             	mov    %rax,%r15
  5b5270:	44 8b 74 24 08       	mov    0x8(%rsp),%r14d
  5b5275:	eb 22                	jmp    5b5299 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x46e9>
  5b5277:	49 89 c7             	mov    %rax,%r15
  5b527a:	41 b5 01             	mov    $0x1,%r13b
  5b527d:	48 8d bc 24 a0 09 00 	lea    0x9a0(%rsp),%rdi
  5b5284:	00 
  5b5285:	e8 e6 28 f8 ff       	call   537b70 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs7XZEQI6Z5Ts_11gpui_canvas6canvas6CanvasECs6gaF1xUz9Bf_4gpui>
  5b528a:	b0 01                	mov    $0x1,%al
  5b528c:	89 44 24 40          	mov    %eax,0x40(%rsp)
  5b5290:	b0 01                	mov    $0x1,%al
  5b5292:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b5296:	41 b6 01             	mov    $0x1,%r14b
  5b5299:	48 8d bc 24 48 04 00 	lea    0x448(%rsp),%rdi
  5b52a0:	00 
  5b52a1:	e8 8a 87 17 00       	call   72da30 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5b52a6:	48 83 bc 24 f0 01 00 	cmpq   $0xffffffffffffffff,0x1f0(%rsp)
  5b52ad:	00 ff 
  5b52af:	0f 95 c0             	setne  %al
  5b52b2:	44 84 e8             	test   %r13b,%al
  5b52b5:	74 0d                	je     5b52c4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4714>
  5b52b7:	48 8d bc 24 f8 03 00 	lea    0x3f8(%rsp),%rdi
  5b52be:	00 
  5b52bf:	e8 ac 11 f8 ff       	call   536470 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs7XZEQI6Z5Ts_11gpui_canvas5image5ImageEECs6gaF1xUz9Bf_4gpui>
  5b52c4:	48 83 bc 24 98 03 00 	cmpq   $0xffffffffffffffff,0x398(%rsp)
  5b52cb:	00 ff 
  5b52cd:	0f 95 c0             	setne  %al
  5b52d0:	84 44 24 40          	test   %al,0x40(%rsp)
  5b52d4:	74 0d                	je     5b52e3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4733>
  5b52d6:	48 8d bc 24 98 03 00 	lea    0x398(%rsp),%rdi
  5b52dd:	00 
  5b52de:	e8 0d 38 f8 ff       	call   538af0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5SheetEBH_>
  5b52e3:	48 8d bc 24 a8 02 00 	lea    0x2a8(%rsp),%rdi
  5b52ea:	00 
  5b52eb:	e8 f0 8e 17 00       	call   72e1e0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB4_7set_val9SetValZSTENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5b52f0:	48 8b b4 24 a8 00 00 	mov    0xa8(%rsp),%rsi
  5b52f7:	00 
  5b52f8:	48 85 f6             	test   %rsi,%rsi
  5b52fb:	74 17                	je     5b5314 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4764>
  5b52fd:	48 8b bc 24 b0 00 00 	mov    0xb0(%rsp),%rdi
  5b5304:	00 
  5b5305:	48 c1 e6 02          	shl    $0x2,%rsi
  5b5309:	ba 04 00 00 00       	mov    $0x4,%edx
  5b530e:	ff 15 e4 4a 53 00    	call   *0x534ae4(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b5314:	48 8b b4 24 78 01 00 	mov    0x178(%rsp),%rsi
  5b531b:	00 
  5b531c:	48 85 f6             	test   %rsi,%rsi
  5b531f:	74 13                	je     5b5334 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4784>
  5b5321:	48 8b bc 24 80 01 00 	mov    0x180(%rsp),%rdi
  5b5328:	00 
  5b5329:	ba 01 00 00 00       	mov    $0x1,%edx
  5b532e:	ff 15 c4 4a 53 00    	call   *0x534ac4(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b5334:	48 8b b4 24 60 01 00 	mov    0x160(%rsp),%rsi
  5b533b:	00 
  5b533c:	48 85 f6             	test   %rsi,%rsi
  5b533f:	74 17                	je     5b5358 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x47a8>
  5b5341:	48 8b bc 24 68 01 00 	mov    0x168(%rsp),%rdi
  5b5348:	00 
  5b5349:	48 c1 e6 04          	shl    $0x4,%rsi
  5b534d:	ba 04 00 00 00       	mov    $0x4,%edx
  5b5352:	ff 15 a0 4a 53 00    	call   *0x534aa0(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b5358:	48 8b b4 24 48 01 00 	mov    0x148(%rsp),%rsi
  5b535f:	00 
  5b5360:	48 85 f6             	test   %rsi,%rsi
  5b5363:	74 17                	je     5b537c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x47cc>
  5b5365:	48 8b bc 24 50 01 00 	mov    0x150(%rsp),%rdi
  5b536c:	00 
  5b536d:	48 c1 e6 04          	shl    $0x4,%rsi
  5b5371:	ba 04 00 00 00       	mov    $0x4,%edx
  5b5376:	ff 15 7c 4a 53 00    	call   *0x534a7c(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b537c:	48 8b 84 24 30 01 00 	mov    0x130(%rsp),%rax
  5b5383:	00 
  5b5384:	48 85 c0             	test   %rax,%rax
  5b5387:	74 17                	je     5b53a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x47f0>
  5b5389:	48 8b bc 24 38 01 00 	mov    0x138(%rsp),%rdi
  5b5390:	00 
  5b5391:	48 6b f0 38          	imul   $0x38,%rax,%rsi
  5b5395:	ba 08 00 00 00       	mov    $0x8,%edx
  5b539a:	ff 15 58 4a 53 00    	call   *0x534a58(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b53a0:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  5b53a5:	74 0d                	je     5b53b4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4804>
  5b53a7:	48 8d bc 24 b8 01 00 	lea    0x1b8(%rsp),%rdi
  5b53ae:	00 
  5b53af:	e8 2c 0f f8 ff       	call   5362e0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs6gaF1xUz9Bf_4gpui7runtime9PresentedEEB1b_>
  5b53b4:	83 bc 24 28 03 00 00 	cmpl   $0xfffffffe,0x328(%rsp)
  5b53bb:	fe 
  5b53bc:	74 15                	je     5b53d3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4823>
  5b53be:	48 8d bc 24 28 03 00 	lea    0x328(%rsp),%rdi
  5b53c5:	00 
  5b53c6:	e8 25 25 f8 ff       	call   5378f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime5ErrorEBF_.llvm.18178969024155037896>
  5b53cb:	eb 06                	jmp    5b53d3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4823>
  5b53cd:	49 89 c7             	mov    %rax,%r15
  5b53d0:	41 b6 01             	mov    $0x1,%r14b
  5b53d3:	48 8b bc 24 20 01 00 	mov    0x120(%rsp),%rdi
  5b53da:	00 
  5b53db:	48 8b b4 24 28 01 00 	mov    0x128(%rsp),%rsi
  5b53e2:	00 
  5b53e3:	e8 68 45 f7 ff       	call   529950 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs7XZEQI6Z5Ts_11gpui_canvas4text10TextShaperEECs6gaF1xUz9Bf_4gpui>
  5b53e8:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  5b53ef:	00 
  5b53f0:	48 85 c0             	test   %rax,%rax
  5b53f3:	74 14                	je     5b5409 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4859>
  5b53f5:	f0 48 ff 08          	lock decq (%rax)
  5b53f9:	75 0e                	jne    5b5409 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4859>
  5b53fb:	48 8d bc 24 98 00 00 	lea    0x98(%rsp),%rdi
  5b5402:	00 
  5b5403:	ff 15 97 4a 53 00    	call   *0x534a97(%rip)        # ae9ea0 <_DYNAMIC+0x2f0>
  5b5409:	83 bc 24 58 0c 00 00 	cmpl   $0x2,0xc58(%rsp)
  5b5410:	02 
  5b5411:	74 12                	je     5b5425 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4875>
  5b5413:	45 84 f6             	test   %r14b,%r14b
  5b5416:	74 0d                	je     5b5425 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x4875>
  5b5418:	48 8d bc 24 58 0c 00 	lea    0xc58(%rsp),%rdi
  5b541f:	00 
  5b5420:	e8 4b 27 f8 ff       	call   537b70 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs7XZEQI6Z5Ts_11gpui_canvas6canvas6CanvasECs6gaF1xUz9Bf_4gpui>
  5b5425:	4c 89 ff             	mov    %r15,%rdi
  5b5428:	ff 15 e2 49 53 00    	call   *0x5349e2(%rip)        # ae9e10 <_DYNAMIC+0x260>
  5b542e:	48 89 c5             	mov    %rax,%rbp
  5b5431:	48 89 84 24 78 02 00 	mov    %rax,0x278(%rsp)
  5b5438:	00 
  5b5439:	48 89 94 24 80 02 00 	mov    %rdx,0x280(%rsp)
  5b5440:	00 
  5b5441:	48 c7 84 24 70 02 00 	movq   $0xfffffffffffffffd,0x270(%rsp)
  5b5448:	00 fd ff ff ff 
  5b544d:	e9 67 f5 ff ff       	jmp    5b49b9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896+0x3e09>
  5b5452:	ff 15 c8 49 53 00    	call   *0x5349c8(%rip)        # ae9e20 <_DYNAMIC+0x270>
  5b5458:	ff 15 ba 49 53 00    	call   *0x5349ba(%rip)        # ae9e18 <_DYNAMIC+0x268>
