
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000685610 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Run>>::grow_one>:
  685610:	41 56                	push   %r14
  685612:	53                   	push   %rbx
  685613:	48 83 ec 18          	sub    $0x18,%rsp
  685617:	48 89 fb             	mov    %rdi,%rbx
  68561a:	48 8b 37             	mov    (%rdi),%rsi
  68561d:	48 8d 04 36          	lea    (%rsi,%rsi,1),%rax
  685621:	48 83 f8 05          	cmp    $0x5,%rax
  685625:	41 be 04 00 00 00    	mov    $0x4,%r14d
  68562b:	4c 0f 43 f0          	cmovae %rax,%r14
  68562f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  685633:	48 89 e7             	mov    %rsp,%rdi
  685636:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  68563c:	41 b9 18 00 00 00    	mov    $0x18,%r9d
  685642:	4c 89 f1             	mov    %r14,%rcx
  685645:	e8 66 02 00 00       	call   6858b0 <<alloc::raw_vec::RawVecInner>::finish_grow>
  68564a:	83 3c 24 01          	cmpl   $0x1,(%rsp)
  68564e:	74 14                	je     685664 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Run>>::grow_one+0x54>
  685650:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  685655:	48 89 43 08          	mov    %rax,0x8(%rbx)
  685659:	4c 89 33             	mov    %r14,(%rbx)
  68565c:	48 83 c4 18          	add    $0x18,%rsp
  685660:	5b                   	pop    %rbx
  685661:	41 5e                	pop    %r14
  685663:	c3                   	ret
  685664:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  685669:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  68566e:	ff 15 04 1e 10 00    	call   *0x101e04(%rip)        # 787478 <_DYNAMIC+0x358>
