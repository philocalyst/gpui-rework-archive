
/tmp/gpui-validated-lookup-apps-47b10baaa49b35f2e0adf9713c95b13d4bbe776de05550eb007192163d59af6f:     file format elf64-x86-64


Disassembly of section .text:

00000000005b0a90 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_>:
  5b0a90:	53                   	push   %rbx
  5b0a91:	41 b9 11 00 00 00    	mov    $0x11,%r9d
  5b0a97:	48 3b 96 88 07 00 00 	cmp    0x788(%rsi),%rdx
  5b0a9e:	0f 85 6e 01 00 00    	jne    5b0c12 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x182>
  5b0aa4:	80 be 5a 09 00 00 01 	cmpb   $0x1,0x95a(%rsi)
  5b0aab:	0f 85 61 01 00 00    	jne    5b0c12 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x182>
  5b0ab1:	48 8b 86 b0 07 00 00 	mov    0x7b0(%rsi),%rax
  5b0ab8:	48 85 c0             	test   %rax,%rax
  5b0abb:	0f 84 51 01 00 00    	je     5b0c12 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x182>
  5b0ac1:	48 8b 96 b8 07 00 00 	mov    0x7b8(%rsi),%rdx
  5b0ac8:	44 0f b7 90 ba 00 00 	movzwl 0xba(%rax),%r10d
  5b0acf:	00 
  5b0ad0:	45 89 d3             	mov    %r10d,%r11d
  5b0ad3:	41 c1 e3 03          	shl    $0x3,%r11d
  5b0ad7:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  5b0ade:	66 90                	xchg   %ax,%ax
  5b0ae0:	4d 85 db             	test   %r11,%r11
  5b0ae3:	74 22                	je     5b0b07 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x77>
  5b0ae5:	4a 3b 4c c0 10       	cmp    0x10(%rax,%r8,8),%rcx
  5b0aea:	0f 97 c3             	seta   %bl
  5b0aed:	80 db 00             	sbb    $0x0,%bl
  5b0af0:	49 ff c0             	inc    %r8
  5b0af3:	49 83 c3 f8          	add    $0xfffffffffffffff8,%r11
  5b0af7:	80 fb 01             	cmp    $0x1,%bl
  5b0afa:	74 e4                	je     5b0ae0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x50>
  5b0afc:	44 0f b6 d3          	movzbl %bl,%r10d
  5b0b00:	45 85 d2             	test   %r10d,%r10d
  5b0b03:	74 19                	je     5b0b1e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x8e>
  5b0b05:	eb 03                	jmp    5b0b0a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x7a>
  5b0b07:	4d 89 d0             	mov    %r10,%r8
  5b0b0a:	48 83 ea 01          	sub    $0x1,%rdx
  5b0b0e:	0f 82 fe 00 00 00    	jb     5b0c12 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x182>
  5b0b14:	4a 8b 84 c0 c0 00 00 	mov    0xc0(%rax,%r8,8),%rax
  5b0b1b:	00 
  5b0b1c:	eb aa                	jmp    5b0ac8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x38>
  5b0b1e:	4a 8b 54 c0 60       	mov    0x60(%rax,%r8,8),%rdx
  5b0b23:	48 83 be 28 08 00 00 	cmpq   $0x0,0x828(%rsi)
  5b0b2a:	00 
  5b0b2b:	0f 84 d2 00 00 00    	je     5b0c03 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x173>
  5b0b31:	48 8b 86 c8 02 00 00 	mov    0x2c8(%rsi),%rax
  5b0b38:	48 39 c2             	cmp    %rax,%rdx
  5b0b3b:	0f 83 d6 00 00 00    	jae    5b0c17 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x187>
  5b0b41:	4c 8b 96 c0 02 00 00 	mov    0x2c0(%rsi),%r10
  5b0b48:	41 bb ff ff ff ff    	mov    $0xffffffff,%r11d
  5b0b4e:	49 89 d0             	mov    %rdx,%r8
  5b0b51:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b0b58:	0f 1f 84 00 00 00 00 
  5b0b5f:	00 
  5b0b60:	4f 8d 04 80          	lea    (%r8,%r8,4),%r8
  5b0b64:	43 8b 5c c2 20       	mov    0x20(%r10,%r8,8),%ebx
  5b0b69:	83 e3 07             	and    $0x7,%ebx
  5b0b6c:	83 fb 05             	cmp    $0x5,%ebx
  5b0b6f:	73 1b                	jae    5b0b8c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0xfc>
  5b0b71:	4f 8d 04 c2          	lea    (%r10,%r8,8),%r8
  5b0b75:	45 8b 40 18          	mov    0x18(%r8),%r8d
  5b0b79:	4d 39 d8             	cmp    %r11,%r8
  5b0b7c:	0f 84 81 00 00 00    	je     5b0c03 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x173>
  5b0b82:	4c 39 c0             	cmp    %r8,%rax
  5b0b85:	77 d9                	ja     5b0b60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0xd0>
  5b0b87:	e9 8e 00 00 00       	jmp    5b0c1a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x18a>
  5b0b8c:	74 1e                	je     5b0bac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x11c>
  5b0b8e:	83 fb 06             	cmp    $0x6,%ebx
  5b0b91:	74 de                	je     5b0b71 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0xe1>
  5b0b93:	48 8d 3d 1e af ac ff 	lea    -0x5350e2(%rip),%rdi        # 7bab8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5b0b9a:	48 8d 15 c7 81 50 00 	lea    0x5081c7(%rip),%rdx        # ab8d68 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x130>
  5b0ba1:	be a1 00 00 00       	mov    $0xa1,%esi
  5b0ba6:	ff 15 34 94 53 00    	call   *0x539434(%rip)        # ae9fe0 <_DYNAMIC+0x280>
  5b0bac:	48 8d 86 68 07 00 00 	lea    0x768(%rsi),%rax
  5b0bb3:	4c 8d 86 50 07 00 00 	lea    0x750(%rsi),%r8
  5b0bba:	4c 8d 96 70 07 00 00 	lea    0x770(%rsi),%r10
  5b0bc1:	4c 8d 9e 58 07 00 00 	lea    0x758(%rsi),%r11
  5b0bc8:	48 83 be 60 07 00 00 	cmpq   $0xffffffffffffffff,0x760(%rsi)
  5b0bcf:	ff 
  5b0bd0:	49 0f 44 c0          	cmove  %r8,%rax
  5b0bd4:	4d 0f 45 da          	cmovne %r10,%r11
  5b0bd8:	49 8b 33             	mov    (%r11),%rsi
  5b0bdb:	48 8b 00             	mov    (%rax),%rax
  5b0bde:	48 c1 e6 04          	shl    $0x4,%rsi
  5b0be2:	48 8d 34 b6          	lea    (%rsi,%rsi,4),%rsi
  5b0be6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5b0bed:	00 00 00 
  5b0bf0:	48 85 f6             	test   %rsi,%rsi
  5b0bf3:	74 1d                	je     5b0c12 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x182>
  5b0bf5:	48 83 c6 b0          	add    $0xffffffffffffffb0,%rsi
  5b0bf9:	48 39 48 20          	cmp    %rcx,0x20(%rax)
  5b0bfd:	48 8d 40 50          	lea    0x50(%rax),%rax
  5b0c01:	75 ed                	jne    5b0bf0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x160>
  5b0c03:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  5b0c07:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  5b0c0b:	49 c7 c1 fe ff ff ff 	mov    $0xfffffffffffffffe,%r9
  5b0c12:	4c 89 0f             	mov    %r9,(%rdi)
  5b0c15:	5b                   	pop    %rbx
  5b0c16:	c3                   	ret
  5b0c17:	49 89 d0             	mov    %rdx,%r8
  5b0c1a:	48 8d 15 e7 80 50 00 	lea    0x5080e7(%rip),%rdx        # ab8d08 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0xd0>
  5b0c21:	4c 89 c7             	mov    %r8,%rdi
  5b0c24:	48 89 c6             	mov    %rax,%rsi
  5b0c27:	ff 15 ab 93 53 00    	call   *0x5393ab(%rip)        # ae9fd8 <_DYNAMIC+0x278>
