
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000675090 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Run>>::grow_one>:
  675090:	41 56                	push   %r14
  675092:	53                   	push   %rbx
  675093:	48 83 ec 18          	sub    $0x18,%rsp
  675097:	48 89 fb             	mov    %rdi,%rbx
  67509a:	48 8b 37             	mov    (%rdi),%rsi
  67509d:	48 8d 04 36          	lea    (%rsi,%rsi,1),%rax
  6750a1:	48 83 f8 05          	cmp    $0x5,%rax
  6750a5:	41 be 04 00 00 00    	mov    $0x4,%r14d
  6750ab:	4c 0f 43 f0          	cmovae %rax,%r14
  6750af:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  6750b3:	48 89 e7             	mov    %rsp,%rdi
  6750b6:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  6750bc:	41 b9 18 00 00 00    	mov    $0x18,%r9d
  6750c2:	4c 89 f1             	mov    %r14,%rcx
  6750c5:	e8 f6 01 00 00       	call   6752c0 <<alloc::raw_vec::RawVecInner>::finish_grow>
  6750ca:	83 3c 24 01          	cmpl   $0x1,(%rsp)
  6750ce:	74 14                	je     6750e4 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Run>>::grow_one+0x54>
  6750d0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6750d5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6750d9:	4c 89 33             	mov    %r14,(%rbx)
  6750dc:	48 83 c4 18          	add    $0x18,%rsp
  6750e0:	5b                   	pop    %rbx
  6750e1:	41 5e                	pop    %r14
  6750e3:	c3                   	ret
  6750e4:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6750e9:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  6750ee:	ff 15 a4 47 11 00    	call   *0x1147a4(%rip)        # 789898 <_DYNAMIC+0x370>
