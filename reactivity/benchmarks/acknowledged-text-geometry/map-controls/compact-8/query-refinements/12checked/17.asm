
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000662770 <<gpui_canvas::text::layout::TextGeometry>::intervals>:
  662770:	48 89 f8             	mov    %rdi,%rax
  662773:	0f 57 c9             	xorps  %xmm1,%xmm1
  662776:	0f 11 4f 28          	movups %xmm1,0x28(%rdi)
  66277a:	48 89 17             	mov    %rdx,(%rdi)
  66277d:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  662781:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  662785:	48 89 4f 18          	mov    %rcx,0x18(%rdi)
  662789:	48 c7 47 20 01 00 00 	movq   $0x1,0x20(%rdi)
  662790:	00 
  662791:	48 89 77 38          	mov    %rsi,0x38(%rdi)
  662795:	f3 0f 11 47 40       	movss  %xmm0,0x40(%rdi)
  66279a:	c3                   	ret
