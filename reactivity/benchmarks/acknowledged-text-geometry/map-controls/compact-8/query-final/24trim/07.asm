
/tmp/gpui-text-map-query-final/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000664400 <<gpui_canvas::text::TextLayout>::previous_visual>:
  664400:	48 8b 7f 20          	mov    0x20(%rdi),%rdi
  664404:	48 85 ff             	test   %rdi,%rdi
  664407:	74 14                	je     66441d <<gpui_canvas::text::TextLayout>::previous_visual+0x1d>
  664409:	50                   	push   %rax
  66440a:	48 83 c7 10          	add    $0x10,%rdi
  66440e:	0f b6 d2             	movzbl %dl,%edx
  664411:	31 c9                	xor    %ecx,%ecx
  664413:	e8 68 03 02 00       	call   684780 <<gpui_canvas::text::layout::TextGeometry>::move_visual>
  664418:	48 83 c4 08          	add    $0x8,%rsp
  66441c:	c3                   	ret
  66441d:	b2 02                	mov    $0x2,%dl
  66441f:	c3                   	ret
