
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006798b0 <<gpui_canvas::text::TextLayout>::lines>:
  6798b0:	48 89 f8             	mov    %rdi,%rax
  6798b3:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  6798b7:	48 85 c9             	test   %rcx,%rcx
  6798ba:	74 0c                	je     6798c8 <<gpui_canvas::text::TextLayout>::lines+0x18>
  6798bc:	48 8b 71 30          	mov    0x30(%rcx),%rsi
  6798c0:	48 8b 79 38          	mov    0x38(%rcx),%rdi
  6798c4:	31 d2                	xor    %edx,%edx
  6798c6:	eb 40                	jmp    679908 <<gpui_canvas::text::TextLayout>::lines+0x58>
  6798c8:	48 8b 56 10          	mov    0x10(%rsi),%rdx
  6798cc:	31 c9                	xor    %ecx,%ecx
  6798ce:	48 85 d2             	test   %rdx,%rdx
  6798d1:	74 1f                	je     6798f2 <<gpui_canvas::text::TextLayout>::lines+0x42>
  6798d3:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  6798d7:	48 c1 e2 04          	shl    $0x4,%rdx
  6798db:	4c 8d 04 17          	lea    (%rdi,%rdx,1),%r8
  6798df:	49 83 c0 f0          	add    $0xfffffffffffffff0,%r8
  6798e3:	4d 85 c0             	test   %r8,%r8
  6798e6:	74 0a                	je     6798f2 <<gpui_canvas::text::TextLayout>::lines+0x42>
  6798e8:	48 01 d7             	add    %rdx,%rdi
  6798eb:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
  6798ef:	03 4f f0             	add    -0x10(%rdi),%ecx
  6798f2:	f2 0f 10 4e 2c       	movsd  0x2c(%rsi),%xmm1
  6798f7:	f3 0f 10 46 28       	movss  0x28(%rsi),%xmm0
  6798fc:	ba 01 00 00 00       	mov    $0x1,%edx
  679901:	be 04 00 00 00       	mov    $0x4,%esi
  679906:	31 ff                	xor    %edi,%edi
  679908:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
  67990c:	48 8d 3c fe          	lea    (%rsi,%rdi,8),%rdi
  679910:	48 89 30             	mov    %rsi,(%rax)
  679913:	48 89 78 08          	mov    %rdi,0x8(%rax)
  679917:	89 50 10             	mov    %edx,0x10(%rax)
  67991a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%rax)
  679921:	89 48 18             	mov    %ecx,0x18(%rax)
  679924:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%rax)
  67992b:	0f 13 48 20          	movlps %xmm1,0x20(%rax)
  67992f:	f3 0f 11 40 28       	movss  %xmm0,0x28(%rax)
  679934:	c3                   	ret
