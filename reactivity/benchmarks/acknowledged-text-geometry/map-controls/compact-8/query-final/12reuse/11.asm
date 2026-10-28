
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000067a530 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Run>>::grow_one>:
  67a530:	41 56                	push   %r14
  67a532:	53                   	push   %rbx
  67a533:	48 83 ec 18          	sub    $0x18,%rsp
  67a537:	48 89 fb             	mov    %rdi,%rbx
  67a53a:	48 8b 37             	mov    (%rdi),%rsi
  67a53d:	48 8d 04 36          	lea    (%rsi,%rsi,1),%rax
  67a541:	48 83 f8 05          	cmp    $0x5,%rax
  67a545:	41 be 04 00 00 00    	mov    $0x4,%r14d
  67a54b:	4c 0f 43 f0          	cmovae %rax,%r14
  67a54f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  67a553:	48 89 e7             	mov    %rsp,%rdi
  67a556:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  67a55c:	41 b9 18 00 00 00    	mov    $0x18,%r9d
  67a562:	4c 89 f1             	mov    %r14,%rcx
  67a565:	e8 66 02 00 00       	call   67a7d0 <<alloc::raw_vec::RawVecInner>::finish_grow>
  67a56a:	83 3c 24 01          	cmpl   $0x1,(%rsp)
  67a56e:	74 14                	je     67a584 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Run>>::grow_one+0x54>
  67a570:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  67a575:	48 89 43 08          	mov    %rax,0x8(%rbx)
  67a579:	4c 89 33             	mov    %r14,(%rbx)
  67a57c:	48 83 c4 18          	add    $0x18,%rsp
  67a580:	5b                   	pop    %rbx
  67a581:	41 5e                	pop    %r14
  67a583:	c3                   	ret
  67a584:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  67a589:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  67a58e:	ff 15 e4 d0 10 00    	call   *0x10d0e4(%rip)        # 787678 <_DYNAMIC+0x358>
