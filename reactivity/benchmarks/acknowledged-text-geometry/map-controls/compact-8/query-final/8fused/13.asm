
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000665530 <<gpui_canvas::text::TextLayout>::lines>:
  665530:	48 89 f8             	mov    %rdi,%rax
  665533:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  665537:	48 85 c9             	test   %rcx,%rcx
  66553a:	74 0c                	je     665548 <<gpui_canvas::text::TextLayout>::lines+0x18>
  66553c:	48 8b 71 48          	mov    0x48(%rcx),%rsi
  665540:	48 8b 79 50          	mov    0x50(%rcx),%rdi
  665544:	31 d2                	xor    %edx,%edx
  665546:	eb 40                	jmp    665588 <<gpui_canvas::text::TextLayout>::lines+0x58>
  665548:	48 8b 56 10          	mov    0x10(%rsi),%rdx
  66554c:	31 c9                	xor    %ecx,%ecx
  66554e:	48 85 d2             	test   %rdx,%rdx
  665551:	74 1f                	je     665572 <<gpui_canvas::text::TextLayout>::lines+0x42>
  665553:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  665557:	48 c1 e2 04          	shl    $0x4,%rdx
  66555b:	4c 8d 04 17          	lea    (%rdi,%rdx,1),%r8
  66555f:	49 83 c0 f0          	add    $0xfffffffffffffff0,%r8
  665563:	4d 85 c0             	test   %r8,%r8
  665566:	74 0a                	je     665572 <<gpui_canvas::text::TextLayout>::lines+0x42>
  665568:	48 01 d7             	add    %rdx,%rdi
  66556b:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
  66556f:	03 4f f0             	add    -0x10(%rdi),%ecx
  665572:	f2 0f 10 4e 2c       	movsd  0x2c(%rsi),%xmm1
  665577:	f3 0f 10 46 28       	movss  0x28(%rsi),%xmm0
  66557c:	ba 01 00 00 00       	mov    $0x1,%edx
  665581:	be 04 00 00 00       	mov    $0x4,%esi
  665586:	31 ff                	xor    %edi,%edi
  665588:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
  66558c:	48 8d 3c fe          	lea    (%rsi,%rdi,8),%rdi
  665590:	48 89 30             	mov    %rsi,(%rax)
  665593:	48 89 78 08          	mov    %rdi,0x8(%rax)
  665597:	89 50 10             	mov    %edx,0x10(%rax)
  66559a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%rax)
  6655a1:	89 48 18             	mov    %ecx,0x18(%rax)
  6655a4:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%rax)
  6655ab:	0f 13 48 20          	movlps %xmm1,0x20(%rax)
  6655af:	f3 0f 11 40 28       	movss  %xmm0,0x28(%rax)
  6655b4:	c3                   	ret
