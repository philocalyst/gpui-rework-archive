
/tmp/gpui-bounds-candidate-gpui-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000004ecb30 <<gpui::runtime::query::Part>::unclipped_bounds>:
  4ecb30:	push   %rbx
  4ecb31:	sub    $0x50,%rsp
  4ecb35:	mov    %rdi,%rbx
  4ecb38:	movss  0x30(%rsi),%xmm0
  4ecb3d:	ucomiss %xmm0,%xmm0
  4ecb40:	jp     4ecb8a <<gpui::runtime::query::Part>::unclipped_bounds+0x5a>
  4ecb42:	movss  0x34(%rsi),%xmm1
  4ecb47:	unpcklps %xmm1,%xmm0
  4ecb4a:	cvtps2pd %xmm0,%xmm0
  4ecb4d:	cvtps2pd 0x38(%rsi),%xmm1
  4ecb51:	movaps %xmm0,0x10(%rsp)
  4ecb56:	movaps %xmm1,0x20(%rsp)
  4ecb5b:	cvtps2pd 0x40(%rsi),%xmm0
  4ecb5f:	movaps %xmm0,0x30(%rsp)
  4ecb64:	movb   $0x0,0x40(%rsp)
  4ecb69:	movups (%rsi),%xmm0
  4ecb6c:	movaps %xmm0,(%rsp)
  4ecb70:	lea    0x10(%rsp),%rsi
  4ecb75:	mov    %rsp,%rdx
  4ecb78:	mov    %rbx,%rdi
  4ecb7b:	call   *0x2af44f(%rip)        # 79bfd0 <_DYNAMIC+0x3e8>
  4ecb81:	mov    %rbx,%rax
  4ecb84:	add    $0x50,%rsp
  4ecb88:	pop    %rbx
  4ecb89:	ret
  4ecb8a:	movl   $0x0,(%rbx)
  4ecb90:	mov    %rbx,%rax
  4ecb93:	add    $0x50,%rsp
  4ecb97:	pop    %rbx
  4ecb98:	ret
