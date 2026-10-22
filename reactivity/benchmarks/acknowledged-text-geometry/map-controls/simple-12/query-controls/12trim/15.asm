
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000662900 <<gpui_canvas::text::layout::TextGeometry>::intervals>:
  662900:	48 89 f8             	mov    %rdi,%rax
  662903:	0f 57 c9             	xorps  %xmm1,%xmm1
  662906:	0f 11 4f 28          	movups %xmm1,0x28(%rdi)
  66290a:	48 89 17             	mov    %rdx,(%rdi)
  66290d:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  662911:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  662915:	48 89 4f 18          	mov    %rcx,0x18(%rdi)
  662919:	48 c7 47 20 01 00 00 	movq   $0x1,0x20(%rdi)
  662920:	00 
  662921:	48 89 77 38          	mov    %rsi,0x38(%rdi)
  662925:	f3 0f 11 47 40       	movss  %xmm0,0x40(%rdi)
  66292a:	c3                   	ret
