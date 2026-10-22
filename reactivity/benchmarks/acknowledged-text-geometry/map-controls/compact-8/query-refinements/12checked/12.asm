
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000685680 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Stop>>::grow_one>:
  685680:	41 56                	push   %r14
  685682:	53                   	push   %rbx
  685683:	48 83 ec 18          	sub    $0x18,%rsp
  685687:	48 89 fb             	mov    %rdi,%rbx
  68568a:	48 8b 37             	mov    (%rdi),%rsi
  68568d:	48 8d 04 36          	lea    (%rsi,%rsi,1),%rax
  685691:	48 83 f8 05          	cmp    $0x5,%rax
  685695:	41 be 04 00 00 00    	mov    $0x4,%r14d
  68569b:	4c 0f 43 f0          	cmovae %rax,%r14
  68569f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  6856a3:	48 89 e7             	mov    %rsp,%rdi
  6856a6:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  6856ac:	41 b9 0c 00 00 00    	mov    $0xc,%r9d
  6856b2:	4c 89 f1             	mov    %r14,%rcx
  6856b5:	e8 f6 01 00 00       	call   6858b0 <<alloc::raw_vec::RawVecInner>::finish_grow>
  6856ba:	83 3c 24 01          	cmpl   $0x1,(%rsp)
  6856be:	74 14                	je     6856d4 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Stop>>::grow_one+0x54>
  6856c0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6856c5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6856c9:	4c 89 33             	mov    %r14,(%rbx)
  6856cc:	48 83 c4 18          	add    $0x18,%rsp
  6856d0:	5b                   	pop    %rbx
  6856d1:	41 5e                	pop    %r14
  6856d3:	c3                   	ret
  6856d4:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6856d9:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  6856de:	ff 15 94 1d 10 00    	call   *0x101d94(%rip)        # 787478 <_DYNAMIC+0x358>
