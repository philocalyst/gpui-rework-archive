
/tmp/gpui-bounds-baseline-gpui-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000004ecb20 <<gpui::runtime::query::Part>::unclipped_bounds>:
  4ecb20:	push   %rbx
  4ecb21:	sub    $0x50,%rsp
  4ecb25:	mov    %rdi,%rbx
  4ecb28:	movss  0x30(%rsi),%xmm0
  4ecb2d:	ucomiss %xmm0,%xmm0
  4ecb30:	jp     4ecb7a <<gpui::runtime::query::Part>::unclipped_bounds+0x5a>
  4ecb32:	movss  0x34(%rsi),%xmm1
  4ecb37:	unpcklps %xmm1,%xmm0
  4ecb3a:	cvtps2pd %xmm0,%xmm0
  4ecb3d:	cvtps2pd 0x38(%rsi),%xmm1
  4ecb41:	movaps %xmm0,0x10(%rsp)
  4ecb46:	movaps %xmm1,0x20(%rsp)
  4ecb4b:	cvtps2pd 0x40(%rsi),%xmm0
  4ecb4f:	movaps %xmm0,0x30(%rsp)
  4ecb54:	movb   $0x0,0x40(%rsp)
  4ecb59:	movups (%rsi),%xmm0
  4ecb5c:	movaps %xmm0,(%rsp)
  4ecb60:	lea    0x10(%rsp),%rsi
  4ecb65:	mov    %rsp,%rdx
  4ecb68:	mov    %rbx,%rdi
  4ecb6b:	call   *0x2af37f(%rip)        # 79bef0 <_DYNAMIC+0x3e8>
  4ecb71:	mov    %rbx,%rax
  4ecb74:	add    $0x50,%rsp
  4ecb78:	pop    %rbx
  4ecb79:	ret
  4ecb7a:	movl   $0x0,(%rbx)
  4ecb80:	mov    %rbx,%rax
  4ecb83:	add    $0x50,%rsp
  4ecb87:	pop    %rbx
  4ecb88:	ret
