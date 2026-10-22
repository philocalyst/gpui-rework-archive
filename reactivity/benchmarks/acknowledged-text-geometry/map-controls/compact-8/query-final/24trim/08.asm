
/tmp/gpui-text-map-query-final/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000664420 <<gpui_canvas::text::TextLayout>::lines>:
  664420:	48 89 f8             	mov    %rdi,%rax
  664423:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  664427:	48 85 c9             	test   %rcx,%rcx
  66442a:	74 0c                	je     664438 <<gpui_canvas::text::TextLayout>::lines+0x18>
  66442c:	48 8b 71 30          	mov    0x30(%rcx),%rsi
  664430:	48 8b 79 38          	mov    0x38(%rcx),%rdi
  664434:	31 d2                	xor    %edx,%edx
  664436:	eb 40                	jmp    664478 <<gpui_canvas::text::TextLayout>::lines+0x58>
  664438:	48 8b 56 10          	mov    0x10(%rsi),%rdx
  66443c:	31 c9                	xor    %ecx,%ecx
  66443e:	48 85 d2             	test   %rdx,%rdx
  664441:	74 1f                	je     664462 <<gpui_canvas::text::TextLayout>::lines+0x42>
  664443:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  664447:	48 c1 e2 04          	shl    $0x4,%rdx
  66444b:	4c 8d 04 17          	lea    (%rdi,%rdx,1),%r8
  66444f:	49 83 c0 f0          	add    $0xfffffffffffffff0,%r8
  664453:	4d 85 c0             	test   %r8,%r8
  664456:	74 0a                	je     664462 <<gpui_canvas::text::TextLayout>::lines+0x42>
  664458:	48 01 d7             	add    %rdx,%rdi
  66445b:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
  66445f:	03 4f f0             	add    -0x10(%rdi),%ecx
  664462:	f2 0f 10 4e 2c       	movsd  0x2c(%rsi),%xmm1
  664467:	f3 0f 10 46 28       	movss  0x28(%rsi),%xmm0
  66446c:	ba 01 00 00 00       	mov    $0x1,%edx
  664471:	be 04 00 00 00       	mov    $0x4,%esi
  664476:	31 ff                	xor    %edi,%edi
  664478:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
  66447c:	48 8d 3c fe          	lea    (%rsi,%rdi,8),%rdi
  664480:	48 89 30             	mov    %rsi,(%rax)
  664483:	48 89 78 08          	mov    %rdi,0x8(%rax)
  664487:	89 50 10             	mov    %edx,0x10(%rax)
  66448a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%rax)
  664491:	89 48 18             	mov    %ecx,0x18(%rax)
  664494:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%rax)
  66449b:	0f 13 48 20          	movlps %xmm1,0x20(%rax)
  66449f:	f3 0f 11 40 28       	movss  %xmm0,0x28(%rax)
  6644a4:	c3                   	ret
