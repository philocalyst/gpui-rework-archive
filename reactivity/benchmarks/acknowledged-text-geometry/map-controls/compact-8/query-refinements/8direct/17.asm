
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000662090 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Stop>>::grow_one>:
  662090:	41 56                	push   %r14
  662092:	53                   	push   %rbx
  662093:	48 83 ec 18          	sub    $0x18,%rsp
  662097:	48 89 fb             	mov    %rdi,%rbx
  66209a:	48 8b 37             	mov    (%rdi),%rsi
  66209d:	48 8d 04 36          	lea    (%rsi,%rsi,1),%rax
  6620a1:	48 83 f8 05          	cmp    $0x5,%rax
  6620a5:	41 be 04 00 00 00    	mov    $0x4,%r14d
  6620ab:	4c 0f 43 f0          	cmovae %rax,%r14
  6620af:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  6620b3:	48 89 e7             	mov    %rsp,%rdi
  6620b6:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  6620bc:	41 b9 0c 00 00 00    	mov    $0xc,%r9d
  6620c2:	4c 89 f1             	mov    %r14,%rcx
  6620c5:	e8 86 01 00 00       	call   662250 <<alloc::raw_vec::RawVecInner>::finish_grow>
  6620ca:	83 3c 24 01          	cmpl   $0x1,(%rsp)
  6620ce:	74 14                	je     6620e4 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Stop>>::grow_one+0x54>
  6620d0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6620d5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6620d9:	4c 89 33             	mov    %r14,(%rbx)
  6620dc:	48 83 c4 18          	add    $0x18,%rsp
  6620e0:	5b                   	pop    %rbx
  6620e1:	41 5e                	pop    %r14
  6620e3:	c3                   	ret
  6620e4:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6620e9:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  6620ee:	ff 15 ec 76 12 00    	call   *0x1276ec(%rip)        # 7897e0 <_DYNAMIC+0x378>
