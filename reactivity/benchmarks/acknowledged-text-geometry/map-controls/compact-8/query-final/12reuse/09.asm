
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006644c0 <<gpui_canvas::text::TextLayout>::lines>:
  6644c0:	48 89 f8             	mov    %rdi,%rax
  6644c3:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  6644c7:	48 85 c9             	test   %rcx,%rcx
  6644ca:	74 0c                	je     6644d8 <<gpui_canvas::text::TextLayout>::lines+0x18>
  6644cc:	48 8b 71 30          	mov    0x30(%rcx),%rsi
  6644d0:	48 8b 79 38          	mov    0x38(%rcx),%rdi
  6644d4:	31 d2                	xor    %edx,%edx
  6644d6:	eb 40                	jmp    664518 <<gpui_canvas::text::TextLayout>::lines+0x58>
  6644d8:	48 8b 56 10          	mov    0x10(%rsi),%rdx
  6644dc:	31 c9                	xor    %ecx,%ecx
  6644de:	48 85 d2             	test   %rdx,%rdx
  6644e1:	74 1f                	je     664502 <<gpui_canvas::text::TextLayout>::lines+0x42>
  6644e3:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  6644e7:	48 c1 e2 04          	shl    $0x4,%rdx
  6644eb:	4c 8d 04 17          	lea    (%rdi,%rdx,1),%r8
  6644ef:	49 83 c0 f0          	add    $0xfffffffffffffff0,%r8
  6644f3:	4d 85 c0             	test   %r8,%r8
  6644f6:	74 0a                	je     664502 <<gpui_canvas::text::TextLayout>::lines+0x42>
  6644f8:	48 01 d7             	add    %rdx,%rdi
  6644fb:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
  6644ff:	03 4f f0             	add    -0x10(%rdi),%ecx
  664502:	f2 0f 10 4e 2c       	movsd  0x2c(%rsi),%xmm1
  664507:	f3 0f 10 46 28       	movss  0x28(%rsi),%xmm0
  66450c:	ba 01 00 00 00       	mov    $0x1,%edx
  664511:	be 04 00 00 00       	mov    $0x4,%esi
  664516:	31 ff                	xor    %edi,%edi
  664518:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
  66451c:	48 8d 3c fe          	lea    (%rsi,%rdi,8),%rdi
  664520:	48 89 30             	mov    %rsi,(%rax)
  664523:	48 89 78 08          	mov    %rdi,0x8(%rax)
  664527:	89 50 10             	mov    %edx,0x10(%rax)
  66452a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%rax)
  664531:	89 48 18             	mov    %ecx,0x18(%rax)
  664534:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%rax)
  66453b:	0f 13 48 20          	movlps %xmm1,0x20(%rax)
  66453f:	f3 0f 11 40 28       	movss  %xmm0,0x28(%rax)
  664544:	c3                   	ret
