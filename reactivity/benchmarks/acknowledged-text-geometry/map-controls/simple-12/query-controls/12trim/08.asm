
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000679a20 <<gpui_canvas::text::TextLayout>::previous_visual>:
  679a20:	48 8b 7f 20          	mov    0x20(%rdi),%rdi
  679a24:	48 85 ff             	test   %rdi,%rdi
  679a27:	74 14                	je     679a3d <<gpui_canvas::text::TextLayout>::previous_visual+0x1d>
  679a29:	50                   	push   %rax
  679a2a:	48 83 c7 10          	add    $0x10,%rdi
  679a2e:	0f b6 d2             	movzbl %dl,%edx
  679a31:	31 c9                	xor    %ecx,%ecx
  679a33:	e8 28 7d fe ff       	call   661760 <<gpui_canvas::text::layout::TextGeometry>::move_visual>
  679a38:	48 83 c4 08          	add    $0x8,%rsp
  679a3c:	c3                   	ret
  679a3d:	b2 02                	mov    $0x2,%dl
  679a3f:	c3                   	ret
