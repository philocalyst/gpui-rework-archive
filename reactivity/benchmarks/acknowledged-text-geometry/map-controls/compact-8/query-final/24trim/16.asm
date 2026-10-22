
/tmp/gpui-text-map-query-final/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006859e0 <<gpui_canvas::text::layout::TextGeometry>::intervals>:
  6859e0:	48 89 f8             	mov    %rdi,%rax
  6859e3:	0f 57 c9             	xorps  %xmm1,%xmm1
  6859e6:	0f 11 4f 28          	movups %xmm1,0x28(%rdi)
  6859ea:	48 89 17             	mov    %rdx,(%rdi)
  6859ed:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  6859f1:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  6859f5:	48 89 4f 18          	mov    %rcx,0x18(%rdi)
  6859f9:	48 c7 47 20 01 00 00 	movq   $0x1,0x20(%rdi)
  685a00:	00 
  685a01:	48 89 77 38          	mov    %rsi,0x38(%rdi)
  685a05:	f3 0f 11 47 40       	movss  %xmm0,0x40(%rdi)
  685a0a:	c3                   	ret
