
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000679890 <<gpui_canvas::text::TextLayout>::previous_visual>:
  679890:	48 8b 7f 20          	mov    0x20(%rdi),%rdi
  679894:	48 85 ff             	test   %rdi,%rdi
  679897:	74 14                	je     6798ad <<gpui_canvas::text::TextLayout>::previous_visual+0x1d>
  679899:	50                   	push   %rax
  67989a:	48 83 c7 10          	add    $0x10,%rdi
  67989e:	0f b6 d2             	movzbl %dl,%edx
  6798a1:	31 c9                	xor    %ecx,%ecx
  6798a3:	e8 68 7e fe ff       	call   661710 <<gpui_canvas::text::layout::TextGeometry>::move_visual>
  6798a8:	48 83 c4 08          	add    $0x8,%rsp
  6798ac:	c3                   	ret
  6798ad:	b2 02                	mov    $0x2,%dl
  6798af:	c3                   	ret
