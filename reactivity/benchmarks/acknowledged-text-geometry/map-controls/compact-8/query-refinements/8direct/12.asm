
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000665d40 <<gpui_canvas::text::TextLayout>::previous_visual>:
  665d40:	48 8b 7f 20          	mov    0x20(%rdi),%rdi
  665d44:	48 85 ff             	test   %rdi,%rdi
  665d47:	74 14                	je     665d5d <<gpui_canvas::text::TextLayout>::previous_visual+0x1d>
  665d49:	50                   	push   %rax
  665d4a:	48 83 c7 10          	add    $0x10,%rdi
  665d4e:	0f b6 d2             	movzbl %dl,%edx
  665d51:	31 c9                	xor    %ecx,%ecx
  665d53:	e8 e8 d7 01 00       	call   683540 <<gpui_canvas::text::layout::TextGeometry>::move_visual>
  665d58:	48 83 c4 08          	add    $0x8,%rsp
  665d5c:	c3                   	ret
  665d5d:	b2 02                	mov    $0x2,%dl
  665d5f:	c3                   	ret
