
/tmp/gpui-spaces-inline-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000004ec210 <<gpui::runtime::query::Part>::unclipped_bounds>:
  4ec210:	53                   	push   %rbx
  4ec211:	48 83 ec 50          	sub    $0x50,%rsp
  4ec215:	48 89 fb             	mov    %rdi,%rbx
  4ec218:	f3 0f 10 46 30       	movss  0x30(%rsi),%xmm0
  4ec21d:	0f 2e c0             	ucomiss %xmm0,%xmm0
  4ec220:	7a 48                	jp     4ec26a <<gpui::runtime::query::Part>::unclipped_bounds+0x5a>
  4ec222:	f3 0f 10 4e 34       	movss  0x34(%rsi),%xmm1
  4ec227:	0f 14 c1             	unpcklps %xmm1,%xmm0
  4ec22a:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  4ec22d:	0f 5a 4e 38          	cvtps2pd 0x38(%rsi),%xmm1
  4ec231:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  4ec236:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  4ec23b:	0f 5a 46 40          	cvtps2pd 0x40(%rsi),%xmm0
  4ec23f:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  4ec244:	c6 44 24 40 00       	movb   $0x0,0x40(%rsp)
  4ec249:	0f 10 06             	movups (%rsi),%xmm0
  4ec24c:	0f 29 04 24          	movaps %xmm0,(%rsp)
  4ec250:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  4ec255:	48 89 e2             	mov    %rsp,%rdx
  4ec258:	48 89 df             	mov    %rbx,%rdi
  4ec25b:	ff 15 f7 fb 2a 00    	call   *0x2afbf7(%rip)        # 79be58 <_DYNAMIC+0x3e8>
  4ec261:	48 89 d8             	mov    %rbx,%rax
  4ec264:	48 83 c4 50          	add    $0x50,%rsp
  4ec268:	5b                   	pop    %rbx
  4ec269:	c3                   	ret
  4ec26a:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  4ec270:	48 89 d8             	mov    %rbx,%rax
  4ec273:	48 83 c4 50          	add    $0x50,%rsp
  4ec277:	5b                   	pop    %rbx
  4ec278:	c3                   	ret
