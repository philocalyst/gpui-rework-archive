
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000681420 <<gpui_canvas::text::layout::TextGeometry>::intervals>:
  681420:	48 89 f8             	mov    %rdi,%rax
  681423:	0f 57 c9             	xorps  %xmm1,%xmm1
  681426:	0f 11 4f 28          	movups %xmm1,0x28(%rdi)
  68142a:	48 89 17             	mov    %rdx,(%rdi)
  68142d:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  681431:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  681435:	48 89 4f 18          	mov    %rcx,0x18(%rdi)
  681439:	48 c7 47 20 01 00 00 	movq   $0x1,0x20(%rdi)
  681440:	00 
  681441:	48 89 77 38          	mov    %rsi,0x38(%rdi)
  681445:	f3 0f 11 47 40       	movss  %xmm0,0x40(%rdi)
  68144a:	c3                   	ret
