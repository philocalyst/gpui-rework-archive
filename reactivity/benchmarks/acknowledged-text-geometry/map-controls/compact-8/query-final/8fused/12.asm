
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000665510 <<gpui_canvas::text::TextLayout>::previous_visual>:
  665510:	48 8b 7f 20          	mov    0x20(%rdi),%rdi
  665514:	48 85 ff             	test   %rdi,%rdi
  665517:	74 14                	je     66552d <<gpui_canvas::text::TextLayout>::previous_visual+0x1d>
  665519:	50                   	push   %rax
  66551a:	48 83 c7 10          	add    $0x10,%rdi
  66551e:	0f b6 d2             	movzbl %dl,%edx
  665521:	31 c9                	xor    %ecx,%ecx
  665523:	e8 a8 7b 01 00       	call   67d0d0 <<gpui_canvas::text::layout::TextGeometry>::move_visual>
  665528:	48 83 c4 08          	add    $0x8,%rsp
  66552c:	c3                   	ret
  66552d:	b2 02                	mov    $0x2,%dl
  66552f:	c3                   	ret
