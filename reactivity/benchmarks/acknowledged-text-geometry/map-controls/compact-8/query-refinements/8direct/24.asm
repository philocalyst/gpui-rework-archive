
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000686770 <<gpui_canvas::text::layout::TextGeometry>::intervals>:
  686770:	48 89 f8             	mov    %rdi,%rax
  686773:	0f 57 c9             	xorps  %xmm1,%xmm1
  686776:	0f 11 4f 48          	movups %xmm1,0x48(%rdi)
  68677a:	0f 10 0a             	movups (%rdx),%xmm1
  68677d:	0f 11 0f             	movups %xmm1,(%rdi)
  686780:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  686784:	48 89 4f 10          	mov    %rcx,0x10(%rdi)
  686788:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
  68678f:	00 
  686790:	0f 10 0a             	movups (%rdx),%xmm1
  686793:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  686797:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  68679b:	48 89 4f 30          	mov    %rcx,0x30(%rdi)
  68679f:	48 c7 47 38 00 00 00 	movq   $0x0,0x38(%rdi)
  6867a6:	00 
  6867a7:	48 c7 47 40 01 00 00 	movq   $0x1,0x40(%rdi)
  6867ae:	00 
  6867af:	48 89 77 58          	mov    %rsi,0x58(%rdi)
  6867b3:	f3 0f 11 47 60       	movss  %xmm0,0x60(%rdi)
  6867b8:	c3                   	ret
