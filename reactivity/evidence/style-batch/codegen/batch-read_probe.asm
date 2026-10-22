
/tmp/gpui-style-batch-release-target/release/deps/gpui-559efaa5b4b411d5:     file format elf64-x86-64


Disassembly of section .text:

000000000090d7c0 <gpui::runtime::style_ledger::batch_phase::read_probe>:
  90d7c0:	41 56                	push   %r14
  90d7c2:	53                   	push   %rbx
  90d7c3:	48 83 ec 38          	sub    $0x38,%rsp
  90d7c7:	48 85 ff             	test   %rdi,%rdi
  90d7ca:	0f 84 a7 0f 00 00    	je     90e777 <gpui::runtime::style_ledger::batch_phase::read_probe+0xfb7>
  90d7d0:	48 89 f9             	mov    %rdi,%rcx
  90d7d3:	48 8b 97 c8 02 00 00 	mov    0x2c8(%rdi),%rdx
  90d7da:	48 85 d2             	test   %rdx,%rdx
  90d7dd:	74 2c                	je     90d80b <gpui::runtime::style_ledger::batch_phase::read_probe+0x4b>
  90d7df:	48 8b 81 28 02 00 00 	mov    0x228(%rcx),%rax
  90d7e6:	48 83 f8 01          	cmp    $0x1,%rax
  90d7ea:	74 27                	je     90d813 <gpui::runtime::style_ledger::batch_phase::read_probe+0x53>
  90d7ec:	48 85 c0             	test   %rax,%rax
  90d7ef:	0f 85 99 00 00 00    	jne    90d88e <gpui::runtime::style_ledger::batch_phase::read_probe+0xce>
  90d7f5:	48 b8 00 00 00 18 04 	movabs $0x418000000,%rax
  90d7fc:	00 00 00 
  90d7ff:	48 0f af d0          	imul   %rax,%rdx
  90d803:	49 89 d0             	mov    %rdx,%r8
  90d806:	e9 1f 0f 00 00       	jmp    90e72a <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  90d80b:	45 31 c0             	xor    %r8d,%r8d
  90d80e:	e9 17 0f 00 00       	jmp    90e72a <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  90d813:	48 8b b1 40 02 00 00 	mov    0x240(%rcx),%rsi
  90d81a:	bf 18 00 00 00       	mov    $0x18,%edi
  90d81f:	45 31 c0             	xor    %r8d,%r8d
  90d822:	45 31 c9             	xor    %r9d,%r9d
  90d825:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  90d82c:	00 00 00 00 
  90d830:	4c 39 ce             	cmp    %r9,%rsi
  90d833:	0f 84 24 0f 00 00    	je     90e75d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf9d>
  90d839:	49 ff c1             	inc    %r9
  90d83c:	48 8b 81 38 02 00 00 	mov    0x238(%rcx),%rax
  90d843:	44 8b 54 38 f8       	mov    -0x8(%rax,%rdi,1),%r10d
  90d848:	4d 89 c3             	mov    %r8,%r11
  90d84b:	44 8b 04 38          	mov    (%rax,%rdi,1),%r8d
  90d84f:	4d 01 d3             	add    %r10,%r11
  90d852:	4d 01 d8             	add    %r11,%r8
  90d855:	48 83 c7 58          	add    $0x58,%rdi
  90d859:	4c 39 ca             	cmp    %r9,%rdx
  90d85c:	75 d2                	jne    90d830 <gpui::runtime::style_ledger::batch_phase::read_probe+0x70>
  90d85e:	4c 8d 4a ff          	lea    -0x1(%rdx),%r9
  90d862:	48 89 f7             	mov    %rsi,%rdi
  90d865:	4c 39 ce             	cmp    %r9,%rsi
  90d868:	0f 86 fc 0e 00 00    	jbe    90e76a <gpui::runtime::style_ledger::batch_phase::read_probe+0xfaa>
  90d86e:	48 be fc ff ff ff ff 	movabs $0x3fffffffffffffc,%rsi
  90d875:	ff ff 03 
  90d878:	89 d1                	mov    %edx,%ecx
  90d87a:	83 e1 03             	and    $0x3,%ecx
  90d87d:	49 83 f9 03          	cmp    $0x3,%r9
  90d881:	0f 83 63 04 00 00    	jae    90dcea <gpui::runtime::style_ledger::batch_phase::read_probe+0x52a>
  90d887:	31 ff                	xor    %edi,%edi
  90d889:	e9 ca 04 00 00       	jmp    90dd58 <gpui::runtime::style_ledger::batch_phase::read_probe+0x598>
  90d88e:	48 8b b9 48 02 00 00 	mov    0x248(%rcx),%rdi
  90d895:	48 85 ff             	test   %rdi,%rdi
  90d898:	0f 84 9f 0e 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90d89e:	48 8b b1 38 02 00 00 	mov    0x238(%rcx),%rsi
  90d8a5:	4c 8b 89 40 02 00 00 	mov    0x240(%rcx),%r9
  90d8ac:	41 0f b6 01          	movzbl (%r9),%eax
  90d8b0:	48 39 c6             	cmp    %rax,%rsi
  90d8b3:	0f 86 94 0e 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90d8b9:	48 8b 89 30 02 00 00 	mov    0x230(%rcx),%rcx
  90d8c0:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90d8c4:	44 8b 54 01 10       	mov    0x10(%rcx,%rax,1),%r10d
  90d8c9:	44 8b 44 01 18       	mov    0x18(%rcx,%rax,1),%r8d
  90d8ce:	4d 01 d0             	add    %r10,%r8
  90d8d1:	48 83 fa 01          	cmp    $0x1,%rdx
  90d8d5:	75 09                	jne    90d8e0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x120>
  90d8d7:	49 c1 e0 04          	shl    $0x4,%r8
  90d8db:	e9 4a 0e 00 00       	jmp    90e72a <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  90d8e0:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90d8e6:	4d 89 c2             	mov    %r8,%r10
  90d8e9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  90d8f0:	4c 39 df             	cmp    %r11,%rdi
  90d8f3:	0f 84 44 0e 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90d8f9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90d8fe:	48 39 c6             	cmp    %rax,%rsi
  90d901:	0f 86 46 0e 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90d907:	49 ff c3             	inc    %r11
  90d90a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90d90e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90d912:	4d 89 d6             	mov    %r10,%r14
  90d915:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90d91a:	49 01 de             	add    %rbx,%r14
  90d91d:	4d 01 f2             	add    %r14,%r10
  90d920:	4c 39 da             	cmp    %r11,%rdx
  90d923:	75 cb                	jne    90d8f0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x130>
  90d925:	4d 01 c2             	add    %r8,%r10
  90d928:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90d92e:	66 90                	xchg   %ax,%ax
  90d930:	4c 39 df             	cmp    %r11,%rdi
  90d933:	0f 84 04 0e 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90d939:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90d93e:	48 39 c6             	cmp    %rax,%rsi
  90d941:	0f 86 06 0e 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90d947:	49 ff c3             	inc    %r11
  90d94a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90d94e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90d952:	4d 89 d6             	mov    %r10,%r14
  90d955:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90d95a:	49 01 de             	add    %rbx,%r14
  90d95d:	4d 01 f2             	add    %r14,%r10
  90d960:	4c 39 da             	cmp    %r11,%rdx
  90d963:	75 cb                	jne    90d930 <gpui::runtime::style_ledger::batch_phase::read_probe+0x170>
  90d965:	4d 01 c2             	add    %r8,%r10
  90d968:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90d96e:	66 90                	xchg   %ax,%ax
  90d970:	4c 39 df             	cmp    %r11,%rdi
  90d973:	0f 84 c4 0d 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90d979:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90d97e:	48 39 c6             	cmp    %rax,%rsi
  90d981:	0f 86 c6 0d 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90d987:	49 ff c3             	inc    %r11
  90d98a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90d98e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90d992:	4d 89 d6             	mov    %r10,%r14
  90d995:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90d99a:	49 01 de             	add    %rbx,%r14
  90d99d:	4d 01 f2             	add    %r14,%r10
  90d9a0:	4c 39 da             	cmp    %r11,%rdx
  90d9a3:	75 cb                	jne    90d970 <gpui::runtime::style_ledger::batch_phase::read_probe+0x1b0>
  90d9a5:	4d 01 c2             	add    %r8,%r10
  90d9a8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90d9ae:	66 90                	xchg   %ax,%ax
  90d9b0:	4c 39 df             	cmp    %r11,%rdi
  90d9b3:	0f 84 84 0d 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90d9b9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90d9be:	48 39 c6             	cmp    %rax,%rsi
  90d9c1:	0f 86 86 0d 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90d9c7:	49 ff c3             	inc    %r11
  90d9ca:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90d9ce:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90d9d2:	4d 89 d6             	mov    %r10,%r14
  90d9d5:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90d9da:	49 01 de             	add    %rbx,%r14
  90d9dd:	4d 01 f2             	add    %r14,%r10
  90d9e0:	4c 39 da             	cmp    %r11,%rdx
  90d9e3:	75 cb                	jne    90d9b0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x1f0>
  90d9e5:	4d 01 c2             	add    %r8,%r10
  90d9e8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90d9ee:	66 90                	xchg   %ax,%ax
  90d9f0:	4c 39 df             	cmp    %r11,%rdi
  90d9f3:	0f 84 44 0d 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90d9f9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90d9fe:	48 39 c6             	cmp    %rax,%rsi
  90da01:	0f 86 46 0d 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90da07:	49 ff c3             	inc    %r11
  90da0a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90da0e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90da12:	4d 89 d6             	mov    %r10,%r14
  90da15:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90da1a:	49 01 de             	add    %rbx,%r14
  90da1d:	4d 01 f2             	add    %r14,%r10
  90da20:	4c 39 da             	cmp    %r11,%rdx
  90da23:	75 cb                	jne    90d9f0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x230>
  90da25:	4d 01 c2             	add    %r8,%r10
  90da28:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90da2e:	66 90                	xchg   %ax,%ax
  90da30:	4c 39 df             	cmp    %r11,%rdi
  90da33:	0f 84 04 0d 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90da39:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90da3e:	48 39 c6             	cmp    %rax,%rsi
  90da41:	0f 86 06 0d 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90da47:	49 ff c3             	inc    %r11
  90da4a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90da4e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90da52:	4d 89 d6             	mov    %r10,%r14
  90da55:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90da5a:	49 01 de             	add    %rbx,%r14
  90da5d:	4d 01 f2             	add    %r14,%r10
  90da60:	4c 39 da             	cmp    %r11,%rdx
  90da63:	75 cb                	jne    90da30 <gpui::runtime::style_ledger::batch_phase::read_probe+0x270>
  90da65:	4d 01 c2             	add    %r8,%r10
  90da68:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90da6e:	66 90                	xchg   %ax,%ax
  90da70:	4c 39 df             	cmp    %r11,%rdi
  90da73:	0f 84 c4 0c 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90da79:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90da7e:	48 39 c6             	cmp    %rax,%rsi
  90da81:	0f 86 c6 0c 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90da87:	49 ff c3             	inc    %r11
  90da8a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90da8e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90da92:	4d 89 d6             	mov    %r10,%r14
  90da95:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90da9a:	49 01 de             	add    %rbx,%r14
  90da9d:	4d 01 f2             	add    %r14,%r10
  90daa0:	4c 39 da             	cmp    %r11,%rdx
  90daa3:	75 cb                	jne    90da70 <gpui::runtime::style_ledger::batch_phase::read_probe+0x2b0>
  90daa5:	4d 01 c2             	add    %r8,%r10
  90daa8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90daae:	66 90                	xchg   %ax,%ax
  90dab0:	4c 39 df             	cmp    %r11,%rdi
  90dab3:	0f 84 84 0c 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90dab9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90dabe:	48 39 c6             	cmp    %rax,%rsi
  90dac1:	0f 86 86 0c 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90dac7:	49 ff c3             	inc    %r11
  90daca:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90dace:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90dad2:	4d 89 d6             	mov    %r10,%r14
  90dad5:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90dada:	49 01 de             	add    %rbx,%r14
  90dadd:	4d 01 f2             	add    %r14,%r10
  90dae0:	4c 39 da             	cmp    %r11,%rdx
  90dae3:	75 cb                	jne    90dab0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x2f0>
  90dae5:	4d 01 c2             	add    %r8,%r10
  90dae8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90daee:	66 90                	xchg   %ax,%ax
  90daf0:	4c 39 df             	cmp    %r11,%rdi
  90daf3:	0f 84 44 0c 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90daf9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90dafe:	48 39 c6             	cmp    %rax,%rsi
  90db01:	0f 86 46 0c 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90db07:	49 ff c3             	inc    %r11
  90db0a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90db0e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90db12:	4d 89 d6             	mov    %r10,%r14
  90db15:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90db1a:	49 01 de             	add    %rbx,%r14
  90db1d:	4d 01 f2             	add    %r14,%r10
  90db20:	4c 39 da             	cmp    %r11,%rdx
  90db23:	75 cb                	jne    90daf0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x330>
  90db25:	4d 01 c2             	add    %r8,%r10
  90db28:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90db2e:	66 90                	xchg   %ax,%ax
  90db30:	4c 39 df             	cmp    %r11,%rdi
  90db33:	0f 84 04 0c 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90db39:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90db3e:	48 39 c6             	cmp    %rax,%rsi
  90db41:	0f 86 06 0c 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90db47:	49 ff c3             	inc    %r11
  90db4a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90db4e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90db52:	4d 89 d6             	mov    %r10,%r14
  90db55:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90db5a:	49 01 de             	add    %rbx,%r14
  90db5d:	4d 01 f2             	add    %r14,%r10
  90db60:	4c 39 da             	cmp    %r11,%rdx
  90db63:	75 cb                	jne    90db30 <gpui::runtime::style_ledger::batch_phase::read_probe+0x370>
  90db65:	4d 01 c2             	add    %r8,%r10
  90db68:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90db6e:	66 90                	xchg   %ax,%ax
  90db70:	4c 39 df             	cmp    %r11,%rdi
  90db73:	0f 84 c4 0b 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90db79:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90db7e:	48 39 c6             	cmp    %rax,%rsi
  90db81:	0f 86 c6 0b 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90db87:	49 ff c3             	inc    %r11
  90db8a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90db8e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90db92:	4d 89 d6             	mov    %r10,%r14
  90db95:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90db9a:	49 01 de             	add    %rbx,%r14
  90db9d:	4d 01 f2             	add    %r14,%r10
  90dba0:	4c 39 da             	cmp    %r11,%rdx
  90dba3:	75 cb                	jne    90db70 <gpui::runtime::style_ledger::batch_phase::read_probe+0x3b0>
  90dba5:	4d 01 c2             	add    %r8,%r10
  90dba8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90dbae:	66 90                	xchg   %ax,%ax
  90dbb0:	4c 39 df             	cmp    %r11,%rdi
  90dbb3:	0f 84 84 0b 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90dbb9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90dbbe:	48 39 c6             	cmp    %rax,%rsi
  90dbc1:	0f 86 86 0b 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90dbc7:	49 ff c3             	inc    %r11
  90dbca:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90dbce:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90dbd2:	4d 89 d6             	mov    %r10,%r14
  90dbd5:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90dbda:	49 01 de             	add    %rbx,%r14
  90dbdd:	4d 01 f2             	add    %r14,%r10
  90dbe0:	4c 39 da             	cmp    %r11,%rdx
  90dbe3:	75 cb                	jne    90dbb0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x3f0>
  90dbe5:	4d 01 c2             	add    %r8,%r10
  90dbe8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90dbee:	66 90                	xchg   %ax,%ax
  90dbf0:	4c 39 df             	cmp    %r11,%rdi
  90dbf3:	0f 84 44 0b 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90dbf9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90dbfe:	48 39 c6             	cmp    %rax,%rsi
  90dc01:	0f 86 46 0b 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90dc07:	49 ff c3             	inc    %r11
  90dc0a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90dc0e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90dc12:	4d 89 d6             	mov    %r10,%r14
  90dc15:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90dc1a:	49 01 de             	add    %rbx,%r14
  90dc1d:	4d 01 f2             	add    %r14,%r10
  90dc20:	4c 39 da             	cmp    %r11,%rdx
  90dc23:	75 cb                	jne    90dbf0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x430>
  90dc25:	4d 01 c2             	add    %r8,%r10
  90dc28:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90dc2e:	66 90                	xchg   %ax,%ax
  90dc30:	4c 39 df             	cmp    %r11,%rdi
  90dc33:	0f 84 04 0b 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90dc39:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90dc3e:	48 39 c6             	cmp    %rax,%rsi
  90dc41:	0f 86 06 0b 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90dc47:	49 ff c3             	inc    %r11
  90dc4a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90dc4e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90dc52:	4d 89 d6             	mov    %r10,%r14
  90dc55:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90dc5a:	49 01 de             	add    %rbx,%r14
  90dc5d:	4d 01 f2             	add    %r14,%r10
  90dc60:	4c 39 da             	cmp    %r11,%rdx
  90dc63:	75 cb                	jne    90dc30 <gpui::runtime::style_ledger::batch_phase::read_probe+0x470>
  90dc65:	4d 01 c2             	add    %r8,%r10
  90dc68:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90dc6e:	66 90                	xchg   %ax,%ax
  90dc70:	4c 39 df             	cmp    %r11,%rdi
  90dc73:	0f 84 c4 0a 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90dc79:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90dc7e:	48 39 c6             	cmp    %rax,%rsi
  90dc81:	0f 86 c6 0a 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90dc87:	49 ff c3             	inc    %r11
  90dc8a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90dc8e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90dc92:	4d 89 d6             	mov    %r10,%r14
  90dc95:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  90dc9a:	49 01 de             	add    %rbx,%r14
  90dc9d:	4d 01 f2             	add    %r14,%r10
  90dca0:	4c 39 da             	cmp    %r11,%rdx
  90dca3:	75 cb                	jne    90dc70 <gpui::runtime::style_ledger::batch_phase::read_probe+0x4b0>
  90dca5:	4d 01 c2             	add    %r8,%r10
  90dca8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  90dcae:	66 90                	xchg   %ax,%ax
  90dcb0:	4c 39 df             	cmp    %r11,%rdi
  90dcb3:	0f 84 84 0a 00 00    	je     90e73d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  90dcb9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  90dcbe:	48 39 c6             	cmp    %rax,%rsi
  90dcc1:	0f 86 86 0a 00 00    	jbe    90e74d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  90dcc7:	49 ff c3             	inc    %r11
  90dcca:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  90dcce:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  90dcd2:	44 8b 44 01 18       	mov    0x18(%rcx,%rax,1),%r8d
  90dcd7:	49 01 da             	add    %rbx,%r10
  90dcda:	4d 01 d0             	add    %r10,%r8
  90dcdd:	4d 89 c2             	mov    %r8,%r10
  90dce0:	4c 39 da             	cmp    %r11,%rdx
  90dce3:	75 cb                	jne    90dcb0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x4f0>
  90dce5:	e9 40 0a 00 00       	jmp    90e72a <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  90dcea:	49 89 d2             	mov    %rdx,%r10
  90dced:	49 21 f2             	and    %rsi,%r10
  90dcf0:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  90dcf7:	31 ff                	xor    %edi,%edi
  90dcf9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  90dd00:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  90dd07:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  90dd0e:	4c 01 c3             	add    %r8,%rbx
  90dd11:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  90dd18:	4d 01 f0             	add    %r14,%r8
  90dd1b:	49 01 d8             	add    %rbx,%r8
  90dd1e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  90dd25:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  90dd29:	49 01 de             	add    %rbx,%r14
  90dd2c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  90dd30:	4c 01 f3             	add    %r14,%rbx
  90dd33:	4c 01 c3             	add    %r8,%rbx
  90dd36:	48 83 c7 04          	add    $0x4,%rdi
  90dd3a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  90dd3e:	45 8b 03             	mov    (%r11),%r8d
  90dd41:	4d 01 f0             	add    %r14,%r8
  90dd44:	49 01 d8             	add    %rbx,%r8
  90dd47:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  90dd4e:	49 39 fa             	cmp    %rdi,%r10
  90dd51:	75 ad                	jne    90dd00 <gpui::runtime::style_ledger::batch_phase::read_probe+0x540>
  90dd53:	48 85 c9             	test   %rcx,%rcx
  90dd56:	74 33                	je     90dd8b <gpui::runtime::style_ledger::batch_phase::read_probe+0x5cb>
  90dd58:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  90dd5c:	48 01 c7             	add    %rax,%rdi
  90dd5f:	48 83 c7 18          	add    $0x18,%rdi
  90dd63:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  90dd67:	45 31 db             	xor    %r11d,%r11d
  90dd6a:	4c 89 c3             	mov    %r8,%rbx
  90dd6d:	0f 1f 00             	nopl   (%rax)
  90dd70:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  90dd75:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  90dd79:	49 01 de             	add    %rbx,%r14
  90dd7c:	4d 01 f0             	add    %r14,%r8
  90dd7f:	49 83 c3 58          	add    $0x58,%r11
  90dd83:	4c 89 c3             	mov    %r8,%rbx
  90dd86:	4d 39 da             	cmp    %r11,%r10
  90dd89:	75 e5                	jne    90dd70 <gpui::runtime::style_ledger::batch_phase::read_probe+0x5b0>
  90dd8b:	49 83 f9 03          	cmp    $0x3,%r9
  90dd8f:	73 04                	jae    90dd95 <gpui::runtime::style_ledger::batch_phase::read_probe+0x5d5>
  90dd91:	31 ff                	xor    %edi,%edi
  90dd93:	eb 73                	jmp    90de08 <gpui::runtime::style_ledger::batch_phase::read_probe+0x648>
  90dd95:	49 89 d2             	mov    %rdx,%r10
  90dd98:	49 21 f2             	and    %rsi,%r10
  90dd9b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  90dda2:	31 ff                	xor    %edi,%edi
  90dda4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  90ddab:	00 00 00 00 00 
  90ddb0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  90ddb7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  90ddbe:	4c 01 c3             	add    %r8,%rbx
  90ddc1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  90ddc8:	4d 01 f0             	add    %r14,%r8
  90ddcb:	49 01 d8             	add    %rbx,%r8
  90ddce:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  90ddd5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  90ddd9:	49 01 de             	add    %rbx,%r14
  90dddc:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  90dde0:	4c 01 f3             	add    %r14,%rbx
  90dde3:	4c 01 c3             	add    %r8,%rbx
  90dde6:	48 83 c7 04          	add    $0x4,%rdi
  90ddea:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  90ddee:	45 8b 03             	mov    (%r11),%r8d
  90ddf1:	4d 01 f0             	add    %r14,%r8
  90ddf4:	49 01 d8             	add    %rbx,%r8
  90ddf7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  90ddfe:	49 39 fa             	cmp    %rdi,%r10
  90de01:	75 ad                	jne    90ddb0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x5f0>
  90de03:	f6 c2 03             	test   $0x3,%dl
  90de06:	74 33                	je     90de3b <gpui::runtime::style_ledger::batch_phase::read_probe+0x67b>
  90de08:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  90de0c:	48 01 c7             	add    %rax,%rdi
  90de0f:	48 83 c7 18          	add    $0x18,%rdi
  90de13:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  90de17:	45 31 db             	xor    %r11d,%r11d
  90de1a:	4c 89 c3             	mov    %r8,%rbx
  90de1d:	0f 1f 00             	nopl   (%rax)
  90de20:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  90de25:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  90de29:	49 01 de             	add    %rbx,%r14
  90de2c:	4d 01 f0             	add    %r14,%r8
  90de2f:	49 83 c3 58          	add    $0x58,%r11
  90de33:	4c 89 c3             	mov    %r8,%rbx
  90de36:	4d 39 da             	cmp    %r11,%r10
  90de39:	75 e5                	jne    90de20 <gpui::runtime::style_ledger::batch_phase::read_probe+0x660>
  90de3b:	49 83 f9 03          	cmp    $0x3,%r9
  90de3f:	73 04                	jae    90de45 <gpui::runtime::style_ledger::batch_phase::read_probe+0x685>
  90de41:	31 ff                	xor    %edi,%edi
  90de43:	eb 73                	jmp    90deb8 <gpui::runtime::style_ledger::batch_phase::read_probe+0x6f8>
  90de45:	49 89 d2             	mov    %rdx,%r10
  90de48:	49 21 f2             	and    %rsi,%r10
  90de4b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  90de52:	31 ff                	xor    %edi,%edi
  90de54:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  90de5b:	00 00 00 00 00 
  90de60:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  90de67:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  90de6e:	4c 01 c3             	add    %r8,%rbx
  90de71:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  90de78:	4d 01 f0             	add    %r14,%r8
  90de7b:	49 01 d8             	add    %rbx,%r8
  90de7e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  90de85:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  90de89:	49 01 de             	add    %rbx,%r14
  90de8c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  90de90:	4c 01 f3             	add    %r14,%rbx
  90de93:	4c 01 c3             	add    %r8,%rbx
  90de96:	48 83 c7 04          	add    $0x4,%rdi
  90de9a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  90de9e:	45 8b 03             	mov    (%r11),%r8d
  90dea1:	4d 01 f0             	add    %r14,%r8
  90dea4:	49 01 d8             	add    %rbx,%r8
  90dea7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  90deae:	49 39 fa             	cmp    %rdi,%r10
  90deb1:	75 ad                	jne    90de60 <gpui::runtime::style_ledger::batch_phase::read_probe+0x6a0>
  90deb3:	f6 c2 03             	test   $0x3,%dl
  90deb6:	74 33                	je     90deeb <gpui::runtime::style_ledger::batch_phase::read_probe+0x72b>
  90deb8:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  90debc:	48 01 c7             	add    %rax,%rdi
  90debf:	48 83 c7 18          	add    $0x18,%rdi
  90dec3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  90dec7:	45 31 db             	xor    %r11d,%r11d
  90deca:	4c 89 c3             	mov    %r8,%rbx
  90decd:	0f 1f 00             	nopl   (%rax)
  90ded0:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  90ded5:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  90ded9:	49 01 de             	add    %rbx,%r14
  90dedc:	4d 01 f0             	add    %r14,%r8
  90dedf:	49 83 c3 58          	add    $0x58,%r11
  90dee3:	4c 89 c3             	mov    %r8,%rbx
  90dee6:	4d 39 da             	cmp    %r11,%r10
  90dee9:	75 e5                	jne    90ded0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x710>
  90deeb:	49 83 f9 03          	cmp    $0x3,%r9
  90deef:	73 04                	jae    90def5 <gpui::runtime::style_ledger::batch_phase::read_probe+0x735>
  90def1:	31 ff                	xor    %edi,%edi
  90def3:	eb 73                	jmp    90df68 <gpui::runtime::style_ledger::batch_phase::read_probe+0x7a8>
  90def5:	49 89 d2             	mov    %rdx,%r10
  90def8:	49 21 f2             	and    %rsi,%r10
  90defb:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  90df02:	31 ff                	xor    %edi,%edi
  90df04:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  90df0b:	00 00 00 00 00 
  90df10:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  90df17:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  90df1e:	4c 01 c3             	add    %r8,%rbx
  90df21:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  90df28:	4d 01 f0             	add    %r14,%r8
  90df2b:	49 01 d8             	add    %rbx,%r8
  90df2e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  90df35:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  90df39:	49 01 de             	add    %rbx,%r14
  90df3c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  90df40:	4c 01 f3             	add    %r14,%rbx
  90df43:	4c 01 c3             	add    %r8,%rbx
  90df46:	48 83 c7 04          	add    $0x4,%rdi
  90df4a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  90df4e:	45 8b 03             	mov    (%r11),%r8d
  90df51:	4d 01 f0             	add    %r14,%r8
  90df54:	49 01 d8             	add    %rbx,%r8
  90df57:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  90df5e:	49 39 fa             	cmp    %rdi,%r10
  90df61:	75 ad                	jne    90df10 <gpui::runtime::style_ledger::batch_phase::read_probe+0x750>
  90df63:	f6 c2 03             	test   $0x3,%dl
  90df66:	74 33                	je     90df9b <gpui::runtime::style_ledger::batch_phase::read_probe+0x7db>
  90df68:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  90df6c:	48 01 c7             	add    %rax,%rdi
  90df6f:	48 83 c7 18          	add    $0x18,%rdi
  90df73:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  90df77:	45 31 db             	xor    %r11d,%r11d
  90df7a:	4c 89 c3             	mov    %r8,%rbx
  90df7d:	0f 1f 00             	nopl   (%rax)
  90df80:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  90df85:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  90df89:	49 01 de             	add    %rbx,%r14
  90df8c:	4d 01 f0             	add    %r14,%r8
  90df8f:	49 83 c3 58          	add    $0x58,%r11
  90df93:	4c 89 c3             	mov    %r8,%rbx
  90df96:	4d 39 da             	cmp    %r11,%r10
  90df99:	75 e5                	jne    90df80 <gpui::runtime::style_ledger::batch_phase::read_probe+0x7c0>
  90df9b:	49 83 f9 03          	cmp    $0x3,%r9
  90df9f:	73 04                	jae    90dfa5 <gpui::runtime::style_ledger::batch_phase::read_probe+0x7e5>
  90dfa1:	31 ff                	xor    %edi,%edi
  90dfa3:	eb 73                	jmp    90e018 <gpui::runtime::style_ledger::batch_phase::read_probe+0x858>
  90dfa5:	49 89 d2             	mov    %rdx,%r10
  90dfa8:	49 21 f2             	and    %rsi,%r10
  90dfab:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  90dfb2:	31 ff                	xor    %edi,%edi
  90dfb4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  90dfbb:	00 00 00 00 00 
  90dfc0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  90dfc7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  90dfce:	4c 01 c3             	add    %r8,%rbx
  90dfd1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  90dfd8:	4d 01 f0             	add    %r14,%r8
  90dfdb:	49 01 d8             	add    %rbx,%r8
  90dfde:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  90dfe5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  90dfe9:	49 01 de             	add    %rbx,%r14
  90dfec:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  90dff0:	4c 01 f3             	add    %r14,%rbx
  90dff3:	4c 01 c3             	add    %r8,%rbx
  90dff6:	48 83 c7 04          	add    $0x4,%rdi
  90dffa:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  90dffe:	45 8b 03             	mov    (%r11),%r8d
  90e001:	4d 01 f0             	add    %r14,%r8
  90e004:	49 01 d8             	add    %rbx,%r8
  90e007:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  90e00e:	49 39 fa             	cmp    %rdi,%r10
  90e011:	75 ad                	jne    90dfc0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x800>
  90e013:	f6 c2 03             	test   $0x3,%dl
  90e016:	74 33                	je     90e04b <gpui::runtime::style_ledger::batch_phase::read_probe+0x88b>
  90e018:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  90e01c:	48 01 c7             	add    %rax,%rdi
  90e01f:	48 83 c7 18          	add    $0x18,%rdi
  90e023:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  90e027:	45 31 db             	xor    %r11d,%r11d
  90e02a:	4c 89 c3             	mov    %r8,%rbx
  90e02d:	0f 1f 00             	nopl   (%rax)
  90e030:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  90e035:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  90e039:	49 01 de             	add    %rbx,%r14
  90e03c:	4d 01 f0             	add    %r14,%r8
  90e03f:	49 83 c3 58          	add    $0x58,%r11
  90e043:	4c 89 c3             	mov    %r8,%rbx
  90e046:	4d 39 da             	cmp    %r11,%r10
  90e049:	75 e5                	jne    90e030 <gpui::runtime::style_ledger::batch_phase::read_probe+0x870>
  90e04b:	49 83 f9 03          	cmp    $0x3,%r9
  90e04f:	73 04                	jae    90e055 <gpui::runtime::style_ledger::batch_phase::read_probe+0x895>
  90e051:	31 ff                	xor    %edi,%edi
  90e053:	eb 73                	jmp    90e0c8 <gpui::runtime::style_ledger::batch_phase::read_probe+0x908>
  90e055:	49 89 d2             	mov    %rdx,%r10
  90e058:	49 21 f2             	and    %rsi,%r10
  90e05b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  90e062:	31 ff                	xor    %edi,%edi
  90e064:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  90e06b:	00 00 00 00 00 
  90e070:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  90e077:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  90e07e:	4c 01 c3             	add    %r8,%rbx
  90e081:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  90e088:	4d 01 f0             	add    %r14,%r8
  90e08b:	49 01 d8             	add    %rbx,%r8
  90e08e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  90e095:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  90e099:	49 01 de             	add    %rbx,%r14
  90e09c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  90e0a0:	4c 01 f3             	add    %r14,%rbx
  90e0a3:	4c 01 c3             	add    %r8,%rbx
  90e0a6:	48 83 c7 04          	add    $0x4,%rdi
  90e0aa:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  90e0ae:	45 8b 03             	mov    (%r11),%r8d
  90e0b1:	4d 01 f0             	add    %r14,%r8
  90e0b4:	49 01 d8             	add    %rbx,%r8
  90e0b7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  90e0be:	49 39 fa             	cmp    %rdi,%r10
  90e0c1:	75 ad                	jne    90e070 <gpui::runtime::style_ledger::batch_phase::read_probe+0x8b0>
  90e0c3:	f6 c2 03             	test   $0x3,%dl
  90e0c6:	74 33                	je     90e0fb <gpui::runtime::style_ledger::batch_phase::read_probe+0x93b>
  90e0c8:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  90e0cc:	48 01 c7             	add    %rax,%rdi
  90e0cf:	48 83 c7 18          	add    $0x18,%rdi
  90e0d3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  90e0d7:	45 31 db             	xor    %r11d,%r11d
  90e0da:	4c 89 c3             	mov    %r8,%rbx
  90e0dd:	0f 1f 00             	nopl   (%rax)
  90e0e0:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  90e0e5:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  90e0e9:	49 01 de             	add    %rbx,%r14
  90e0ec:	4d 01 f0             	add    %r14,%r8
  90e0ef:	49 83 c3 58          	add    $0x58,%r11
  90e0f3:	4c 89 c3             	mov    %r8,%rbx
  90e0f6:	4d 39 da             	cmp    %r11,%r10
  90e0f9:	75 e5                	jne    90e0e0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x920>
  90e0fb:	49 83 f9 03          	cmp    $0x3,%r9
  90e0ff:	73 04                	jae    90e105 <gpui::runtime::style_ledger::batch_phase::read_probe+0x945>
  90e101:	31 ff                	xor    %edi,%edi
  90e103:	eb 73                	jmp    90e178 <gpui::runtime::style_ledger::batch_phase::read_probe+0x9b8>
  90e105:	49 89 d2             	mov    %rdx,%r10
  90e108:	49 21 f2             	and    %rsi,%r10
  90e10b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  90e112:	31 ff                	xor    %edi,%edi
  90e114:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  90e11b:	00 00 00 00 00 
  90e120:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  90e127:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  90e12e:	4c 01 c3             	add    %r8,%rbx
  90e131:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  90e138:	4d 01 f0             	add    %r14,%r8
  90e13b:	49 01 d8             	add    %rbx,%r8
  90e13e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  90e145:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  90e149:	49 01 de             	add    %rbx,%r14
  90e14c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  90e150:	4c 01 f3             	add    %r14,%rbx
  90e153:	4c 01 c3             	add    %r8,%rbx
  90e156:	48 83 c7 04          	add    $0x4,%rdi
  90e15a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  90e15e:	45 8b 03             	mov    (%r11),%r8d
  90e161:	4d 01 f0             	add    %r14,%r8
  90e164:	49 01 d8             	add    %rbx,%r8
  90e167:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  90e16e:	49 39 fa             	cmp    %rdi,%r10
  90e171:	75 ad                	jne    90e120 <gpui::runtime::style_ledger::batch_phase::read_probe+0x960>
  90e173:	f6 c2 03             	test   $0x3,%dl
  90e176:	74 33                	je     90e1ab <gpui::runtime::style_ledger::batch_phase::read_probe+0x9eb>
  90e178:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  90e17c:	48 01 c7             	add    %rax,%rdi
  90e17f:	48 83 c7 18          	add    $0x18,%rdi
  90e183:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  90e187:	45 31 db             	xor    %r11d,%r11d
  90e18a:	4c 89 c3             	mov    %r8,%rbx
  90e18d:	0f 1f 00             	nopl   (%rax)
  90e190:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  90e195:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  90e199:	49 01 de             	add    %rbx,%r14
  90e19c:	4d 01 f0             	add    %r14,%r8
  90e19f:	49 83 c3 58          	add    $0x58,%r11
  90e1a3:	4c 89 c3             	mov    %r8,%rbx
  90e1a6:	4d 39 da             	cmp    %r11,%r10
  90e1a9:	75 e5                	jne    90e190 <gpui::runtime::style_ledger::batch_phase::read_probe+0x9d0>
  90e1ab:	49 83 f9 03          	cmp    $0x3,%r9
  90e1af:	73 04                	jae    90e1b5 <gpui::runtime::style_ledger::batch_phase::read_probe+0x9f5>
  90e1b1:	31 ff                	xor    %edi,%edi
  90e1b3:	eb 73                	jmp    90e228 <gpui::runtime::style_ledger::batch_phase::read_probe+0xa68>
  90e1b5:	49 89 d2             	mov    %rdx,%r10
  90e1b8:	49 21 f2             	and    %rsi,%r10
  90e1bb:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  90e1c2:	31 ff                	xor    %edi,%edi
  90e1c4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  90e1cb:	00 00 00 00 00 
  90e1d0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  90e1d7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  90e1de:	4c 01 c3             	add    %r8,%rbx
  90e1e1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  90e1e8:	4d 01 f0             	add    %r14,%r8
  90e1eb:	49 01 d8             	add    %rbx,%r8
  90e1ee:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  90e1f5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  90e1f9:	49 01 de             	add    %rbx,%r14
  90e1fc:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  90e200:	4c 01 f3             	add    %r14,%rbx
  90e203:	4c 01 c3             	add    %r8,%rbx
  90e206:	48 83 c7 04          	add    $0x4,%rdi
  90e20a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  90e20e:	45 8b 03             	mov    (%r11),%r8d
  90e211:	4d 01 f0             	add    %r14,%r8
  90e214:	49 01 d8             	add    %rbx,%r8
  90e217:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  90e21e:	49 39 fa             	cmp    %rdi,%r10
  90e221:	75 ad                	jne    90e1d0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xa10>
  90e223:	f6 c2 03             	test   $0x3,%dl
  90e226:	74 33                	je     90e25b <gpui::runtime::style_ledger::batch_phase::read_probe+0xa9b>
  90e228:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  90e22c:	48 01 c7             	add    %rax,%rdi
  90e22f:	48 83 c7 18          	add    $0x18,%rdi
  90e233:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  90e237:	45 31 db             	xor    %r11d,%r11d
  90e23a:	4c 89 c3             	mov    %r8,%rbx
  90e23d:	0f 1f 00             	nopl   (%rax)
  90e240:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  90e245:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  90e249:	49 01 de             	add    %rbx,%r14
  90e24c:	4d 01 f0             	add    %r14,%r8
  90e24f:	49 83 c3 58          	add    $0x58,%r11
  90e253:	4c 89 c3             	mov    %r8,%rbx
  90e256:	4d 39 da             	cmp    %r11,%r10
  90e259:	75 e5                	jne    90e240 <gpui::runtime::style_ledger::batch_phase::read_probe+0xa80>
  90e25b:	49 83 f9 03          	cmp    $0x3,%r9
  90e25f:	73 04                	jae    90e265 <gpui::runtime::style_ledger::batch_phase::read_probe+0xaa5>
  90e261:	31 ff                	xor    %edi,%edi
  90e263:	eb 73                	jmp    90e2d8 <gpui::runtime::style_ledger::batch_phase::read_probe+0xb18>
  90e265:	49 89 d2             	mov    %rdx,%r10
  90e268:	49 21 f2             	and    %rsi,%r10
  90e26b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  90e272:	31 ff                	xor    %edi,%edi
  90e274:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  90e27b:	00 00 00 00 00 
  90e280:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  90e287:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  90e28e:	4c 01 c3             	add    %r8,%rbx
  90e291:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  90e298:	4d 01 f0             	add    %r14,%r8
  90e29b:	49 01 d8             	add    %rbx,%r8
  90e29e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  90e2a5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  90e2a9:	49 01 de             	add    %rbx,%r14
  90e2ac:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  90e2b0:	4c 01 f3             	add    %r14,%rbx
  90e2b3:	4c 01 c3             	add    %r8,%rbx
  90e2b6:	48 83 c7 04          	add    $0x4,%rdi
  90e2ba:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  90e2be:	45 8b 03             	mov    (%r11),%r8d
  90e2c1:	4d 01 f0             	add    %r14,%r8
  90e2c4:	49 01 d8             	add    %rbx,%r8
  90e2c7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  90e2ce:	49 39 fa             	cmp    %rdi,%r10
  90e2d1:	75 ad                	jne    90e280 <gpui::runtime::style_ledger::batch_phase::read_probe+0xac0>
  90e2d3:	f6 c2 03             	test   $0x3,%dl
  90e2d6:	74 33                	je     90e30b <gpui::runtime::style_ledger::batch_phase::read_probe+0xb4b>
  90e2d8:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  90e2dc:	48 01 c7             	add    %rax,%rdi
  90e2df:	48 83 c7 18          	add    $0x18,%rdi
  90e2e3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  90e2e7:	45 31 db             	xor    %r11d,%r11d
  90e2ea:	4c 89 c3             	mov    %r8,%rbx
  90e2ed:	0f 1f 00             	nopl   (%rax)
  90e2f0:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  90e2f5:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  90e2f9:	49 01 de             	add    %rbx,%r14
  90e2fc:	4d 01 f0             	add    %r14,%r8
  90e2ff:	49 83 c3 58          	add    $0x58,%r11
  90e303:	4c 89 c3             	mov    %r8,%rbx
  90e306:	4d 39 da             	cmp    %r11,%r10
  90e309:	75 e5                	jne    90e2f0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xb30>
  90e30b:	49 83 f9 03          	cmp    $0x3,%r9
  90e30f:	73 04                	jae    90e315 <gpui::runtime::style_ledger::batch_phase::read_probe+0xb55>
  90e311:	31 ff                	xor    %edi,%edi
  90e313:	eb 73                	jmp    90e388 <gpui::runtime::style_ledger::batch_phase::read_probe+0xbc8>
  90e315:	49 89 d2             	mov    %rdx,%r10
  90e318:	49 21 f2             	and    %rsi,%r10
  90e31b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  90e322:	31 ff                	xor    %edi,%edi
  90e324:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  90e32b:	00 00 00 00 00 
  90e330:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  90e337:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  90e33e:	4c 01 c3             	add    %r8,%rbx
  90e341:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  90e348:	4d 01 f0             	add    %r14,%r8
  90e34b:	49 01 d8             	add    %rbx,%r8
  90e34e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  90e355:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  90e359:	49 01 de             	add    %rbx,%r14
  90e35c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  90e360:	4c 01 f3             	add    %r14,%rbx
  90e363:	4c 01 c3             	add    %r8,%rbx
  90e366:	48 83 c7 04          	add    $0x4,%rdi
  90e36a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  90e36e:	45 8b 03             	mov    (%r11),%r8d
  90e371:	4d 01 f0             	add    %r14,%r8
  90e374:	49 01 d8             	add    %rbx,%r8
  90e377:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  90e37e:	49 39 fa             	cmp    %rdi,%r10
  90e381:	75 ad                	jne    90e330 <gpui::runtime::style_ledger::batch_phase::read_probe+0xb70>
  90e383:	f6 c2 03             	test   $0x3,%dl
  90e386:	74 33                	je     90e3bb <gpui::runtime::style_ledger::batch_phase::read_probe+0xbfb>
  90e388:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  90e38c:	48 01 c7             	add    %rax,%rdi
  90e38f:	48 83 c7 18          	add    $0x18,%rdi
  90e393:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  90e397:	45 31 db             	xor    %r11d,%r11d
  90e39a:	4c 89 c3             	mov    %r8,%rbx
  90e39d:	0f 1f 00             	nopl   (%rax)
  90e3a0:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  90e3a5:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  90e3a9:	49 01 de             	add    %rbx,%r14
  90e3ac:	4d 01 f0             	add    %r14,%r8
  90e3af:	49 83 c3 58          	add    $0x58,%r11
  90e3b3:	4c 89 c3             	mov    %r8,%rbx
  90e3b6:	4d 39 da             	cmp    %r11,%r10
  90e3b9:	75 e5                	jne    90e3a0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xbe0>
  90e3bb:	49 83 f9 03          	cmp    $0x3,%r9
  90e3bf:	73 04                	jae    90e3c5 <gpui::runtime::style_ledger::batch_phase::read_probe+0xc05>
  90e3c1:	31 ff                	xor    %edi,%edi
  90e3c3:	eb 73                	jmp    90e438 <gpui::runtime::style_ledger::batch_phase::read_probe+0xc78>
  90e3c5:	49 89 d2             	mov    %rdx,%r10
  90e3c8:	49 21 f2             	and    %rsi,%r10
  90e3cb:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  90e3d2:	31 ff                	xor    %edi,%edi
  90e3d4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  90e3db:	00 00 00 00 00 
  90e3e0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  90e3e7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  90e3ee:	4c 01 c3             	add    %r8,%rbx
  90e3f1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  90e3f8:	4d 01 f0             	add    %r14,%r8
  90e3fb:	49 01 d8             	add    %rbx,%r8
  90e3fe:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  90e405:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  90e409:	49 01 de             	add    %rbx,%r14
  90e40c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  90e410:	4c 01 f3             	add    %r14,%rbx
  90e413:	4c 01 c3             	add    %r8,%rbx
  90e416:	48 83 c7 04          	add    $0x4,%rdi
  90e41a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  90e41e:	45 8b 03             	mov    (%r11),%r8d
  90e421:	4d 01 f0             	add    %r14,%r8
  90e424:	49 01 d8             	add    %rbx,%r8
  90e427:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  90e42e:	49 39 fa             	cmp    %rdi,%r10
  90e431:	75 ad                	jne    90e3e0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xc20>
  90e433:	f6 c2 03             	test   $0x3,%dl
  90e436:	74 33                	je     90e46b <gpui::runtime::style_ledger::batch_phase::read_probe+0xcab>
  90e438:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  90e43c:	48 01 c7             	add    %rax,%rdi
  90e43f:	48 83 c7 18          	add    $0x18,%rdi
  90e443:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  90e447:	45 31 db             	xor    %r11d,%r11d
  90e44a:	4c 89 c3             	mov    %r8,%rbx
  90e44d:	0f 1f 00             	nopl   (%rax)
  90e450:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  90e455:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  90e459:	49 01 de             	add    %rbx,%r14
  90e45c:	4d 01 f0             	add    %r14,%r8
  90e45f:	49 83 c3 58          	add    $0x58,%r11
  90e463:	4c 89 c3             	mov    %r8,%rbx
  90e466:	4d 39 da             	cmp    %r11,%r10
  90e469:	75 e5                	jne    90e450 <gpui::runtime::style_ledger::batch_phase::read_probe+0xc90>
  90e46b:	49 83 f9 03          	cmp    $0x3,%r9
  90e46f:	73 04                	jae    90e475 <gpui::runtime::style_ledger::batch_phase::read_probe+0xcb5>
  90e471:	31 ff                	xor    %edi,%edi
  90e473:	eb 73                	jmp    90e4e8 <gpui::runtime::style_ledger::batch_phase::read_probe+0xd28>
  90e475:	49 89 d2             	mov    %rdx,%r10
  90e478:	49 21 f2             	and    %rsi,%r10
  90e47b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  90e482:	31 ff                	xor    %edi,%edi
  90e484:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  90e48b:	00 00 00 00 00 
  90e490:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  90e497:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  90e49e:	4c 01 c3             	add    %r8,%rbx
  90e4a1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  90e4a8:	4d 01 f0             	add    %r14,%r8
  90e4ab:	49 01 d8             	add    %rbx,%r8
  90e4ae:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  90e4b5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  90e4b9:	49 01 de             	add    %rbx,%r14
  90e4bc:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  90e4c0:	4c 01 f3             	add    %r14,%rbx
  90e4c3:	4c 01 c3             	add    %r8,%rbx
  90e4c6:	48 83 c7 04          	add    $0x4,%rdi
  90e4ca:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  90e4ce:	45 8b 03             	mov    (%r11),%r8d
  90e4d1:	4d 01 f0             	add    %r14,%r8
  90e4d4:	49 01 d8             	add    %rbx,%r8
  90e4d7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  90e4de:	49 39 fa             	cmp    %rdi,%r10
  90e4e1:	75 ad                	jne    90e490 <gpui::runtime::style_ledger::batch_phase::read_probe+0xcd0>
  90e4e3:	f6 c2 03             	test   $0x3,%dl
  90e4e6:	74 33                	je     90e51b <gpui::runtime::style_ledger::batch_phase::read_probe+0xd5b>
  90e4e8:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  90e4ec:	48 01 c7             	add    %rax,%rdi
  90e4ef:	48 83 c7 18          	add    $0x18,%rdi
  90e4f3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  90e4f7:	45 31 db             	xor    %r11d,%r11d
  90e4fa:	4c 89 c3             	mov    %r8,%rbx
  90e4fd:	0f 1f 00             	nopl   (%rax)
  90e500:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  90e505:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  90e509:	49 01 de             	add    %rbx,%r14
  90e50c:	4d 01 f0             	add    %r14,%r8
  90e50f:	49 83 c3 58          	add    $0x58,%r11
  90e513:	4c 89 c3             	mov    %r8,%rbx
  90e516:	4d 39 da             	cmp    %r11,%r10
  90e519:	75 e5                	jne    90e500 <gpui::runtime::style_ledger::batch_phase::read_probe+0xd40>
  90e51b:	49 83 f9 03          	cmp    $0x3,%r9
  90e51f:	73 04                	jae    90e525 <gpui::runtime::style_ledger::batch_phase::read_probe+0xd65>
  90e521:	31 ff                	xor    %edi,%edi
  90e523:	eb 73                	jmp    90e598 <gpui::runtime::style_ledger::batch_phase::read_probe+0xdd8>
  90e525:	49 89 d2             	mov    %rdx,%r10
  90e528:	49 21 f2             	and    %rsi,%r10
  90e52b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  90e532:	31 ff                	xor    %edi,%edi
  90e534:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  90e53b:	00 00 00 00 00 
  90e540:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  90e547:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  90e54e:	4c 01 c3             	add    %r8,%rbx
  90e551:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  90e558:	4d 01 f0             	add    %r14,%r8
  90e55b:	49 01 d8             	add    %rbx,%r8
  90e55e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  90e565:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  90e569:	49 01 de             	add    %rbx,%r14
  90e56c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  90e570:	4c 01 f3             	add    %r14,%rbx
  90e573:	4c 01 c3             	add    %r8,%rbx
  90e576:	48 83 c7 04          	add    $0x4,%rdi
  90e57a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  90e57e:	45 8b 03             	mov    (%r11),%r8d
  90e581:	4d 01 f0             	add    %r14,%r8
  90e584:	49 01 d8             	add    %rbx,%r8
  90e587:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  90e58e:	49 39 fa             	cmp    %rdi,%r10
  90e591:	75 ad                	jne    90e540 <gpui::runtime::style_ledger::batch_phase::read_probe+0xd80>
  90e593:	f6 c2 03             	test   $0x3,%dl
  90e596:	74 33                	je     90e5cb <gpui::runtime::style_ledger::batch_phase::read_probe+0xe0b>
  90e598:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  90e59c:	48 01 c7             	add    %rax,%rdi
  90e59f:	48 83 c7 18          	add    $0x18,%rdi
  90e5a3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  90e5a7:	45 31 db             	xor    %r11d,%r11d
  90e5aa:	4c 89 c3             	mov    %r8,%rbx
  90e5ad:	0f 1f 00             	nopl   (%rax)
  90e5b0:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  90e5b5:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  90e5b9:	49 01 de             	add    %rbx,%r14
  90e5bc:	4d 01 f0             	add    %r14,%r8
  90e5bf:	49 83 c3 58          	add    $0x58,%r11
  90e5c3:	4c 89 c3             	mov    %r8,%rbx
  90e5c6:	4d 39 da             	cmp    %r11,%r10
  90e5c9:	75 e5                	jne    90e5b0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xdf0>
  90e5cb:	49 83 f9 03          	cmp    $0x3,%r9
  90e5cf:	73 04                	jae    90e5d5 <gpui::runtime::style_ledger::batch_phase::read_probe+0xe15>
  90e5d1:	31 ff                	xor    %edi,%edi
  90e5d3:	eb 73                	jmp    90e648 <gpui::runtime::style_ledger::batch_phase::read_probe+0xe88>
  90e5d5:	49 89 d2             	mov    %rdx,%r10
  90e5d8:	49 21 f2             	and    %rsi,%r10
  90e5db:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  90e5e2:	31 ff                	xor    %edi,%edi
  90e5e4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  90e5eb:	00 00 00 00 00 
  90e5f0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  90e5f7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  90e5fe:	4c 01 c3             	add    %r8,%rbx
  90e601:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  90e608:	4d 01 f0             	add    %r14,%r8
  90e60b:	49 01 d8             	add    %rbx,%r8
  90e60e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  90e615:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  90e619:	49 01 de             	add    %rbx,%r14
  90e61c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  90e620:	4c 01 f3             	add    %r14,%rbx
  90e623:	4c 01 c3             	add    %r8,%rbx
  90e626:	48 83 c7 04          	add    $0x4,%rdi
  90e62a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  90e62e:	45 8b 03             	mov    (%r11),%r8d
  90e631:	4d 01 f0             	add    %r14,%r8
  90e634:	49 01 d8             	add    %rbx,%r8
  90e637:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  90e63e:	49 39 fa             	cmp    %rdi,%r10
  90e641:	75 ad                	jne    90e5f0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xe30>
  90e643:	f6 c2 03             	test   $0x3,%dl
  90e646:	74 33                	je     90e67b <gpui::runtime::style_ledger::batch_phase::read_probe+0xebb>
  90e648:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  90e64c:	48 01 c7             	add    %rax,%rdi
  90e64f:	48 83 c7 18          	add    $0x18,%rdi
  90e653:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  90e657:	45 31 db             	xor    %r11d,%r11d
  90e65a:	4c 89 c3             	mov    %r8,%rbx
  90e65d:	0f 1f 00             	nopl   (%rax)
  90e660:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  90e665:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  90e669:	49 01 de             	add    %rbx,%r14
  90e66c:	4d 01 f0             	add    %r14,%r8
  90e66f:	49 83 c3 58          	add    $0x58,%r11
  90e673:	4c 89 c3             	mov    %r8,%rbx
  90e676:	4d 39 da             	cmp    %r11,%r10
  90e679:	75 e5                	jne    90e660 <gpui::runtime::style_ledger::batch_phase::read_probe+0xea0>
  90e67b:	49 83 f9 03          	cmp    $0x3,%r9
  90e67f:	73 04                	jae    90e685 <gpui::runtime::style_ledger::batch_phase::read_probe+0xec5>
  90e681:	31 ff                	xor    %edi,%edi
  90e683:	eb 73                	jmp    90e6f8 <gpui::runtime::style_ledger::batch_phase::read_probe+0xf38>
  90e685:	48 21 d6             	and    %rdx,%rsi
  90e688:	4c 8d 88 20 01 00 00 	lea    0x120(%rax),%r9
  90e68f:	31 ff                	xor    %edi,%edi
  90e691:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  90e698:	0f 1f 84 00 00 00 00 
  90e69f:	00 
  90e6a0:	45 8b 91 f0 fe ff ff 	mov    -0x110(%r9),%r10d
  90e6a7:	45 8b 99 f8 fe ff ff 	mov    -0x108(%r9),%r11d
  90e6ae:	4d 01 c2             	add    %r8,%r10
  90e6b1:	45 8b 81 48 ff ff ff 	mov    -0xb8(%r9),%r8d
  90e6b8:	4d 01 d8             	add    %r11,%r8
  90e6bb:	4d 01 d0             	add    %r10,%r8
  90e6be:	45 8b 91 50 ff ff ff 	mov    -0xb0(%r9),%r10d
  90e6c5:	45 8b 59 a0          	mov    -0x60(%r9),%r11d
  90e6c9:	4d 01 d3             	add    %r10,%r11
  90e6cc:	45 8b 51 a8          	mov    -0x58(%r9),%r10d
  90e6d0:	4d 01 da             	add    %r11,%r10
  90e6d3:	4d 01 c2             	add    %r8,%r10
  90e6d6:	48 83 c7 04          	add    $0x4,%rdi
  90e6da:	45 8b 59 f8          	mov    -0x8(%r9),%r11d
  90e6de:	45 8b 01             	mov    (%r9),%r8d
  90e6e1:	4d 01 d8             	add    %r11,%r8
  90e6e4:	4d 01 d0             	add    %r10,%r8
  90e6e7:	49 81 c1 60 01 00 00 	add    $0x160,%r9
  90e6ee:	48 39 fe             	cmp    %rdi,%rsi
  90e6f1:	75 ad                	jne    90e6a0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xee0>
  90e6f3:	f6 c2 03             	test   $0x3,%dl
  90e6f6:	74 32                	je     90e72a <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  90e6f8:	48 6b d7 58          	imul   $0x58,%rdi,%rdx
  90e6fc:	48 01 d0             	add    %rdx,%rax
  90e6ff:	48 83 c0 18          	add    $0x18,%rax
  90e703:	48 6b c9 58          	imul   $0x58,%rcx,%rcx
  90e707:	31 d2                	xor    %edx,%edx
  90e709:	4c 89 c6             	mov    %r8,%rsi
  90e70c:	0f 1f 40 00          	nopl   0x0(%rax)
  90e710:	8b 7c 10 f8          	mov    -0x8(%rax,%rdx,1),%edi
  90e714:	44 8b 04 10          	mov    (%rax,%rdx,1),%r8d
  90e718:	48 01 f7             	add    %rsi,%rdi
  90e71b:	49 01 f8             	add    %rdi,%r8
  90e71e:	48 83 c2 58          	add    $0x58,%rdx
  90e722:	4c 89 c6             	mov    %r8,%rsi
  90e725:	48 39 d1             	cmp    %rdx,%rcx
  90e728:	75 e6                	jne    90e710 <gpui::runtime::style_ledger::batch_phase::read_probe+0xf50>
  90e72a:	4c 89 04 24          	mov    %r8,(%rsp)
  90e72e:	48 89 e0             	mov    %rsp,%rax
  90e731:	48 8b 04 24          	mov    (%rsp),%rax
  90e735:	48 83 c4 38          	add    $0x38,%rsp
  90e739:	5b                   	pop    %rbx
  90e73a:	41 5e                	pop    %r14
  90e73c:	c3                   	ret
  90e73d:	48 8d 15 4c 54 36 00 	lea    0x36544c(%rip),%rdx        # c73b90 <anon.1b72a5b8b5110b04d021962373711302.349.llvm.10952795245580062517+0x30>
  90e744:	48 89 fe             	mov    %rdi,%rsi
  90e747:	ff 15 c3 e0 38 00    	call   *0x38e0c3(%rip)        # c9c810 <_DYNAMIC+0x298>
  90e74d:	48 8d 15 54 54 36 00 	lea    0x365454(%rip),%rdx        # c73ba8 <anon.1b72a5b8b5110b04d021962373711302.349.llvm.10952795245580062517+0x48>
  90e754:	48 89 c7             	mov    %rax,%rdi
  90e757:	ff 15 b3 e0 38 00    	call   *0x38e0b3(%rip)        # c9c810 <_DYNAMIC+0x298>
  90e75d:	48 ff ca             	dec    %rdx
  90e760:	48 39 d6             	cmp    %rdx,%rsi
  90e763:	48 0f 42 d6          	cmovb  %rsi,%rdx
  90e767:	48 89 d7             	mov    %rdx,%rdi
  90e76a:	48 8d 15 07 54 36 00 	lea    0x365407(%rip),%rdx        # c73b78 <anon.1b72a5b8b5110b04d021962373711302.349.llvm.10952795245580062517+0x18>
  90e771:	ff 15 99 e0 38 00    	call   *0x38e099(%rip)        # c9c810 <_DYNAMIC+0x298>
  90e777:	48 c7 04 24 0d 00 00 	movq   $0xd,(%rsp)
  90e77e:	00 
  90e77f:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  90e786:	00 00 
  90e788:	48 8d 3d b3 29 78 ff 	lea    -0x87d64d(%rip),%rdi        # 91142 <anon.1b72a5b8b5110b04d021962373711302.333.llvm.10952795245580062517>
  90e78f:	48 8d 0d 7a 52 36 00 	lea    0x36527a(%rip),%rcx        # c73a10 <anon.1b72a5b8b5110b04d021962373711302.334.llvm.10952795245580062517>
  90e796:	4c 8d 05 3b 5d 36 00 	lea    0x365d3b(%rip),%r8        # c744d8 <anon.1b72a5b8b5110b04d021962373711302.458.llvm.10952795245580062517+0x4d0>
  90e79d:	48 89 e2             	mov    %rsp,%rdx
  90e7a0:	be 2b 00 00 00       	mov    $0x2b,%esi
  90e7a5:	ff 15 0d e1 38 00    	call   *0x38e10d(%rip)        # c9c8b8 <_DYNAMIC+0x340>
  90e7ab:	0f 0b                	ud2
  90e7ad:	48 89 c3             	mov    %rax,%rbx
  90e7b0:	48 89 e7             	mov    %rsp,%rdi
  90e7b3:	e8 38 bd ff ff       	call   90a4f0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  90e7b8:	48 89 df             	mov    %rbx,%rdi
  90e7bb:	e8 b0 70 35 00       	call   c65870 <_Unwind_Resume@plt>
