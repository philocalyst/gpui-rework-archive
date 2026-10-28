
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000662020 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Run>>::grow_one>:
  662020:	41 56                	push   %r14
  662022:	53                   	push   %rbx
  662023:	48 83 ec 18          	sub    $0x18,%rsp
  662027:	48 89 fb             	mov    %rdi,%rbx
  66202a:	48 8b 37             	mov    (%rdi),%rsi
  66202d:	48 8d 04 36          	lea    (%rsi,%rsi,1),%rax
  662031:	48 83 f8 05          	cmp    $0x5,%rax
  662035:	41 be 04 00 00 00    	mov    $0x4,%r14d
  66203b:	4c 0f 43 f0          	cmovae %rax,%r14
  66203f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  662043:	48 89 e7             	mov    %rsp,%rdi
  662046:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  66204c:	41 b9 18 00 00 00    	mov    $0x18,%r9d
  662052:	4c 89 f1             	mov    %r14,%rcx
  662055:	e8 f6 01 00 00       	call   662250 <<alloc::raw_vec::RawVecInner>::finish_grow>
  66205a:	83 3c 24 01          	cmpl   $0x1,(%rsp)
  66205e:	74 14                	je     662074 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Run>>::grow_one+0x54>
  662060:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  662065:	48 89 43 08          	mov    %rax,0x8(%rbx)
  662069:	4c 89 33             	mov    %r14,(%rbx)
  66206c:	48 83 c4 18          	add    $0x18,%rsp
  662070:	5b                   	pop    %rbx
  662071:	41 5e                	pop    %r14
  662073:	c3                   	ret
  662074:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  662079:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  66207e:	ff 15 5c 77 12 00    	call   *0x12775c(%rip)        # 7897e0 <_DYNAMIC+0x378>
