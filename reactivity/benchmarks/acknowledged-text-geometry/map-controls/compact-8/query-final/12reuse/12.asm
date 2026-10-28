
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000067a5a0 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Stop>>::grow_one>:
  67a5a0:	41 56                	push   %r14
  67a5a2:	53                   	push   %rbx
  67a5a3:	48 83 ec 18          	sub    $0x18,%rsp
  67a5a7:	48 89 fb             	mov    %rdi,%rbx
  67a5aa:	48 8b 37             	mov    (%rdi),%rsi
  67a5ad:	48 8d 04 36          	lea    (%rsi,%rsi,1),%rax
  67a5b1:	48 83 f8 05          	cmp    $0x5,%rax
  67a5b5:	41 be 04 00 00 00    	mov    $0x4,%r14d
  67a5bb:	4c 0f 43 f0          	cmovae %rax,%r14
  67a5bf:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  67a5c3:	48 89 e7             	mov    %rsp,%rdi
  67a5c6:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  67a5cc:	41 b9 0c 00 00 00    	mov    $0xc,%r9d
  67a5d2:	4c 89 f1             	mov    %r14,%rcx
  67a5d5:	e8 f6 01 00 00       	call   67a7d0 <<alloc::raw_vec::RawVecInner>::finish_grow>
  67a5da:	83 3c 24 01          	cmpl   $0x1,(%rsp)
  67a5de:	74 14                	je     67a5f4 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Stop>>::grow_one+0x54>
  67a5e0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  67a5e5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  67a5e9:	4c 89 33             	mov    %r14,(%rbx)
  67a5ec:	48 83 c4 18          	add    $0x18,%rsp
  67a5f0:	5b                   	pop    %rbx
  67a5f1:	41 5e                	pop    %r14
  67a5f3:	c3                   	ret
  67a5f4:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  67a5f9:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  67a5fe:	ff 15 74 d0 10 00    	call   *0x10d074(%rip)        # 787678 <_DYNAMIC+0x358>
