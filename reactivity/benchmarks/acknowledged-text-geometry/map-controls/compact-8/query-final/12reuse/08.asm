
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006644a0 <<gpui_canvas::text::TextLayout>::previous_visual>:
  6644a0:	48 8b 7f 20          	mov    0x20(%rdi),%rdi
  6644a4:	48 85 ff             	test   %rdi,%rdi
  6644a7:	74 14                	je     6644bd <<gpui_canvas::text::TextLayout>::previous_visual+0x1d>
  6644a9:	50                   	push   %rax
  6644aa:	48 83 c7 10          	add    $0x10,%rdi
  6644ae:	0f b6 d2             	movzbl %dl,%edx
  6644b1:	31 c9                	xor    %ecx,%ecx
  6644b3:	e8 c8 be 01 00       	call   680380 <<gpui_canvas::text::layout::TextGeometry>::move_visual>
  6644b8:	48 83 c4 08          	add    $0x8,%rsp
  6644bc:	c3                   	ret
  6644bd:	b2 02                	mov    $0x2,%dl
  6644bf:	c3                   	ret
