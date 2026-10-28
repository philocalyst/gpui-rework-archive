
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000679a40 <<gpui_canvas::text::TextLayout>::lines>:
  679a40:	48 89 f8             	mov    %rdi,%rax
  679a43:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  679a47:	48 85 c9             	test   %rcx,%rcx
  679a4a:	74 0c                	je     679a58 <<gpui_canvas::text::TextLayout>::lines+0x18>
  679a4c:	48 8b 71 30          	mov    0x30(%rcx),%rsi
  679a50:	48 8b 79 38          	mov    0x38(%rcx),%rdi
  679a54:	31 d2                	xor    %edx,%edx
  679a56:	eb 40                	jmp    679a98 <<gpui_canvas::text::TextLayout>::lines+0x58>
  679a58:	48 8b 56 10          	mov    0x10(%rsi),%rdx
  679a5c:	31 c9                	xor    %ecx,%ecx
  679a5e:	48 85 d2             	test   %rdx,%rdx
  679a61:	74 1f                	je     679a82 <<gpui_canvas::text::TextLayout>::lines+0x42>
  679a63:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  679a67:	48 c1 e2 04          	shl    $0x4,%rdx
  679a6b:	4c 8d 04 17          	lea    (%rdi,%rdx,1),%r8
  679a6f:	49 83 c0 f0          	add    $0xfffffffffffffff0,%r8
  679a73:	4d 85 c0             	test   %r8,%r8
  679a76:	74 0a                	je     679a82 <<gpui_canvas::text::TextLayout>::lines+0x42>
  679a78:	48 01 d7             	add    %rdx,%rdi
  679a7b:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
  679a7f:	03 4f f0             	add    -0x10(%rdi),%ecx
  679a82:	f2 0f 10 4e 2c       	movsd  0x2c(%rsi),%xmm1
  679a87:	f3 0f 10 46 28       	movss  0x28(%rsi),%xmm0
  679a8c:	ba 01 00 00 00       	mov    $0x1,%edx
  679a91:	be 04 00 00 00       	mov    $0x4,%esi
  679a96:	31 ff                	xor    %edi,%edi
  679a98:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
  679a9c:	48 8d 3c fe          	lea    (%rsi,%rdi,8),%rdi
  679aa0:	48 89 30             	mov    %rsi,(%rax)
  679aa3:	48 89 78 08          	mov    %rdi,0x8(%rax)
  679aa7:	89 50 10             	mov    %edx,0x10(%rax)
  679aaa:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%rax)
  679ab1:	89 48 18             	mov    %ecx,0x18(%rax)
  679ab4:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%rax)
  679abb:	0f 13 48 20          	movlps %xmm1,0x20(%rax)
  679abf:	f3 0f 11 40 28       	movss  %xmm0,0x28(%rax)
  679ac4:	c3                   	ret
