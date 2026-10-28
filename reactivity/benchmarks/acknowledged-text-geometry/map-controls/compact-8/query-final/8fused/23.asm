
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006802d0 <<gpui_canvas::text::layout::TextGeometry>::intervals>:
  6802d0:	48 89 f8             	mov    %rdi,%rax
  6802d3:	0f 57 c9             	xorps  %xmm1,%xmm1
  6802d6:	0f 11 4f 48          	movups %xmm1,0x48(%rdi)
  6802da:	0f 10 0a             	movups (%rdx),%xmm1
  6802dd:	0f 11 0f             	movups %xmm1,(%rdi)
  6802e0:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  6802e4:	48 89 4f 10          	mov    %rcx,0x10(%rdi)
  6802e8:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
  6802ef:	00 
  6802f0:	0f 10 0a             	movups (%rdx),%xmm1
  6802f3:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  6802f7:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  6802fb:	48 89 4f 30          	mov    %rcx,0x30(%rdi)
  6802ff:	48 c7 47 38 00 00 00 	movq   $0x0,0x38(%rdi)
  680306:	00 
  680307:	48 c7 47 40 01 00 00 	movq   $0x1,0x40(%rdi)
  68030e:	00 
  68030f:	48 89 77 58          	mov    %rsi,0x58(%rdi)
  680313:	f3 0f 11 47 60       	movss  %xmm0,0x60(%rdi)
  680318:	c3                   	ret
