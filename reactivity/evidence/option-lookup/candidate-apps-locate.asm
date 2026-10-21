
/tmp/gpui-option-lookup-apps-4ce6cc649f0e16dbafb29422b9fe83c03ae8c259be19afa59f8979a49f4cb322:     file format elf64-x86-64


Disassembly of section .text:

00000000005b0a20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_>:
  5b0a20:	50                   	push   %rax
  5b0a21:	48 3b b7 88 07 00 00 	cmp    0x788(%rdi),%rsi
  5b0a28:	75 77                	jne    5b0aa1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x81>
  5b0a2a:	80 bf 5a 09 00 00 01 	cmpb   $0x1,0x95a(%rdi)
  5b0a31:	75 6e                	jne    5b0aa1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x81>
  5b0a33:	48 8b 8f b0 07 00 00 	mov    0x7b0(%rdi),%rcx
  5b0a3a:	48 85 c9             	test   %rcx,%rcx
  5b0a3d:	74 62                	je     5b0aa1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x81>
  5b0a3f:	48 8b b7 b8 07 00 00 	mov    0x7b8(%rdi),%rsi
  5b0a46:	31 c0                	xor    %eax,%eax
  5b0a48:	44 0f b7 89 ba 00 00 	movzwl 0xba(%rcx),%r9d
  5b0a4f:	00 
  5b0a50:	45 89 ca             	mov    %r9d,%r10d
  5b0a53:	41 c1 e2 03          	shl    $0x3,%r10d
  5b0a57:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  5b0a5e:	66 90                	xchg   %ax,%ax
  5b0a60:	4d 85 d2             	test   %r10,%r10
  5b0a63:	74 25                	je     5b0a8a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x6a>
  5b0a65:	4a 3b 54 c1 10       	cmp    0x10(%rcx,%r8,8),%rdx
  5b0a6a:	41 0f 97 c3          	seta   %r11b
  5b0a6e:	41 80 db 00          	sbb    $0x0,%r11b
  5b0a72:	49 ff c0             	inc    %r8
  5b0a75:	49 83 c2 f8          	add    $0xfffffffffffffff8,%r10
  5b0a79:	41 80 fb 01          	cmp    $0x1,%r11b
  5b0a7d:	74 e1                	je     5b0a60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x40>
  5b0a7f:	45 0f b6 cb          	movzbl %r11b,%r9d
  5b0a83:	45 85 c9             	test   %r9d,%r9d
  5b0a86:	74 20                	je     5b0aa8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x88>
  5b0a88:	eb 03                	jmp    5b0a8d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x6d>
  5b0a8a:	4d 89 c8             	mov    %r9,%r8
  5b0a8d:	48 83 ee 01          	sub    $0x1,%rsi
  5b0a91:	0f 82 f8 00 00 00    	jb     5b0b8f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x16f>
  5b0a97:	4a 8b 8c c1 c0 00 00 	mov    0xc0(%rcx,%r8,8),%rcx
  5b0a9e:	00 
  5b0a9f:	eb a7                	jmp    5b0a48 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x28>
  5b0aa1:	31 c0                	xor    %eax,%eax
  5b0aa3:	48 89 ca             	mov    %rcx,%rdx
  5b0aa6:	59                   	pop    %rcx
  5b0aa7:	c3                   	ret
  5b0aa8:	4a 8b 4c c1 60       	mov    0x60(%rcx,%r8,8),%rcx
  5b0aad:	b8 01 00 00 00       	mov    $0x1,%eax
  5b0ab2:	48 83 bf 28 08 00 00 	cmpq   $0x0,0x828(%rdi)
  5b0ab9:	00 
  5b0aba:	74 e7                	je     5b0aa3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x83>
  5b0abc:	48 8b b7 c8 02 00 00 	mov    0x2c8(%rdi),%rsi
  5b0ac3:	48 39 f1             	cmp    %rsi,%rcx
  5b0ac6:	0f 83 c8 00 00 00    	jae    5b0b94 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x174>
  5b0acc:	4c 8b 8f c0 02 00 00 	mov    0x2c0(%rdi),%r9
  5b0ad3:	41 ba ff ff ff ff    	mov    $0xffffffff,%r10d
  5b0ad9:	49 89 c8             	mov    %rcx,%r8
  5b0adc:	0f 1f 40 00          	nopl   0x0(%rax)
  5b0ae0:	4f 8d 04 80          	lea    (%r8,%r8,4),%r8
  5b0ae4:	47 8b 5c c1 20       	mov    0x20(%r9,%r8,8),%r11d
  5b0ae9:	41 83 e3 07          	and    $0x7,%r11d
  5b0aed:	41 83 fb 05          	cmp    $0x5,%r11d
  5b0af1:	73 17                	jae    5b0b0a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0xea>
  5b0af3:	4f 8d 04 c1          	lea    (%r9,%r8,8),%r8
  5b0af7:	45 8b 40 18          	mov    0x18(%r8),%r8d
  5b0afb:	4d 39 d0             	cmp    %r10,%r8
  5b0afe:	74 a3                	je     5b0aa3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x83>
  5b0b00:	4c 39 c6             	cmp    %r8,%rsi
  5b0b03:	77 db                	ja     5b0ae0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0xc0>
  5b0b05:	e9 8d 00 00 00       	jmp    5b0b97 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x177>
  5b0b0a:	74 1f                	je     5b0b2b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x10b>
  5b0b0c:	41 83 fb 06          	cmp    $0x6,%r11d
  5b0b10:	74 e1                	je     5b0af3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0xd3>
  5b0b12:	48 8d 3d cf af ac ff 	lea    -0x535031(%rip),%rdi        # 7bae8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5b0b19:	48 8d 15 80 80 50 00 	lea    0x508080(%rip),%rdx        # ab8ba0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x130>
  5b0b20:	be a1 00 00 00       	mov    $0xa1,%esi
  5b0b25:	ff 15 05 93 53 00    	call   *0x539305(%rip)        # ae9e30 <_DYNAMIC+0x280>
  5b0b2b:	48 8d b7 68 07 00 00 	lea    0x768(%rdi),%rsi
  5b0b32:	4c 8d 87 50 07 00 00 	lea    0x750(%rdi),%r8
  5b0b39:	4c 8d 8f 70 07 00 00 	lea    0x770(%rdi),%r9
  5b0b40:	4c 8d 97 58 07 00 00 	lea    0x758(%rdi),%r10
  5b0b47:	48 83 bf 60 07 00 00 	cmpq   $0xffffffffffffffff,0x760(%rdi)
  5b0b4e:	ff 
  5b0b4f:	49 0f 44 f0          	cmove  %r8,%rsi
  5b0b53:	4d 0f 45 d1          	cmovne %r9,%r10
  5b0b57:	49 8b 3a             	mov    (%r10),%rdi
  5b0b5a:	48 8b 36             	mov    (%rsi),%rsi
  5b0b5d:	48 c1 e7 04          	shl    $0x4,%rdi
  5b0b61:	48 8d 3c bf          	lea    (%rdi,%rdi,4),%rdi
  5b0b65:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5b0b6c:	00 00 00 00 
  5b0b70:	48 85 ff             	test   %rdi,%rdi
  5b0b73:	74 13                	je     5b0b88 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x168>
  5b0b75:	48 83 c7 b0          	add    $0xffffffffffffffb0,%rdi
  5b0b79:	48 39 56 20          	cmp    %rdx,0x20(%rsi)
  5b0b7d:	48 8d 76 50          	lea    0x50(%rsi),%rsi
  5b0b81:	75 ed                	jne    5b0b70 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x150>
  5b0b83:	e9 1b ff ff ff       	jmp    5b0aa3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_+0x83>
  5b0b88:	31 c0                	xor    %eax,%eax
  5b0b8a:	48 89 ca             	mov    %rcx,%rdx
  5b0b8d:	59                   	pop    %rcx
  5b0b8e:	c3                   	ret
  5b0b8f:	48 89 ca             	mov    %rcx,%rdx
  5b0b92:	59                   	pop    %rcx
  5b0b93:	c3                   	ret
  5b0b94:	49 89 c8             	mov    %rcx,%r8
  5b0b97:	48 8d 15 a2 7f 50 00 	lea    0x507fa2(%rip),%rdx        # ab8b40 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0xd0>
  5b0b9e:	4c 89 c7             	mov    %r8,%rdi
  5b0ba1:	ff 15 81 92 53 00    	call   *0x539281(%rip)        # ae9e28 <_DYNAMIC+0x278>
