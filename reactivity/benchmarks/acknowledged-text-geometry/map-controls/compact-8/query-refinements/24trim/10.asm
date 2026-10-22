
/tmp/gpui-text-map-query-refinements/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000678310 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Run>>::grow_one>:
  678310:	41 56                	push   %r14
  678312:	53                   	push   %rbx
  678313:	48 83 ec 18          	sub    $0x18,%rsp
  678317:	48 89 fb             	mov    %rdi,%rbx
  67831a:	48 8b 37             	mov    (%rdi),%rsi
  67831d:	48 8d 04 36          	lea    (%rsi,%rsi,1),%rax
  678321:	48 83 f8 05          	cmp    $0x5,%rax
  678325:	41 be 04 00 00 00    	mov    $0x4,%r14d
  67832b:	4c 0f 43 f0          	cmovae %rax,%r14
  67832f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  678333:	48 89 e7             	mov    %rsp,%rdi
  678336:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  67833c:	41 b9 18 00 00 00    	mov    $0x18,%r9d
  678342:	4c 89 f1             	mov    %r14,%rcx
  678345:	e8 f6 01 00 00       	call   678540 <<alloc::raw_vec::RawVecInner>::finish_grow>
  67834a:	83 3c 24 01          	cmpl   $0x1,(%rsp)
  67834e:	74 14                	je     678364 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Run>>::grow_one+0x54>
  678350:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  678355:	48 89 43 08          	mov    %rax,0x8(%rbx)
  678359:	4c 89 33             	mov    %r14,(%rbx)
  67835c:	48 83 c4 18          	add    $0x18,%rsp
  678360:	5b                   	pop    %rbx
  678361:	41 5e                	pop    %r14
  678363:	c3                   	ret
  678364:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  678369:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  67836e:	ff 15 6c f0 10 00    	call   *0x10f06c(%rip)        # 7873e0 <_DYNAMIC+0x358>
