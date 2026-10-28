
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000067dc20 <<gpui_canvas::text::layout::TextGeometry>::validates_selection>:
  67dc20:	41 56                	push   %r14
  67dc22:	53                   	push   %rbx
  67dc23:	48 83 ec 18          	sub    $0x18,%rsp
  67dc27:	49 89 f6             	mov    %rsi,%r14
  67dc2a:	48 89 fb             	mov    %rdi,%rbx
  67dc2d:	8b 16                	mov    (%rsi),%edx
  67dc2f:	0f b6 4e 04          	movzbl 0x4(%rsi),%ecx
  67dc33:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  67dc38:	48 89 de             	mov    %rbx,%rsi
  67dc3b:	e8 00 fd ff ff       	call   67d940 <<gpui_canvas::text::layout::TextGeometry>::caret_stop>
  67dc40:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
  67dc45:	74 23                	je     67dc6a <<gpui_canvas::text::layout::TextGeometry>::validates_selection+0x4a>
  67dc47:	41 8b 56 08          	mov    0x8(%r14),%edx
  67dc4b:	41 0f b6 4e 0c       	movzbl 0xc(%r14),%ecx
  67dc50:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  67dc55:	48 89 de             	mov    %rbx,%rsi
  67dc58:	e8 e3 fc ff ff       	call   67d940 <<gpui_canvas::text::layout::TextGeometry>::caret_stop>
  67dc5d:	0f b6 44 24 08       	movzbl 0x8(%rsp),%eax
  67dc62:	48 83 c4 18          	add    $0x18,%rsp
  67dc66:	5b                   	pop    %rbx
  67dc67:	41 5e                	pop    %r14
  67dc69:	c3                   	ret
  67dc6a:	31 c0                	xor    %eax,%eax
  67dc6c:	48 83 c4 18          	add    $0x18,%rsp
  67dc70:	5b                   	pop    %rbx
  67dc71:	41 5e                	pop    %r14
  67dc73:	c3                   	ret
