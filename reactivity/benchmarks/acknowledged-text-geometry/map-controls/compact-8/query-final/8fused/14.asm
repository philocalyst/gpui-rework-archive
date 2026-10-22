
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000675020 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::CommonStop>>::grow_one>:
  675020:	41 56                	push   %r14
  675022:	53                   	push   %rbx
  675023:	48 83 ec 18          	sub    $0x18,%rsp
  675027:	48 89 fb             	mov    %rdi,%rbx
  67502a:	48 8b 37             	mov    (%rdi),%rsi
  67502d:	48 8d 04 36          	lea    (%rsi,%rsi,1),%rax
  675031:	48 83 f8 05          	cmp    $0x5,%rax
  675035:	41 be 04 00 00 00    	mov    $0x4,%r14d
  67503b:	4c 0f 43 f0          	cmovae %rax,%r14
  67503f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  675043:	48 89 e7             	mov    %rsp,%rdi
  675046:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  67504c:	41 b9 08 00 00 00    	mov    $0x8,%r9d
  675052:	4c 89 f1             	mov    %r14,%rcx
  675055:	e8 66 02 00 00       	call   6752c0 <<alloc::raw_vec::RawVecInner>::finish_grow>
  67505a:	83 3c 24 01          	cmpl   $0x1,(%rsp)
  67505e:	74 14                	je     675074 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::CommonStop>>::grow_one+0x54>
  675060:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  675065:	48 89 43 08          	mov    %rax,0x8(%rbx)
  675069:	4c 89 33             	mov    %r14,(%rbx)
  67506c:	48 83 c4 18          	add    $0x18,%rsp
  675070:	5b                   	pop    %rbx
  675071:	41 5e                	pop    %r14
  675073:	c3                   	ret
  675074:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  675079:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  67507e:	ff 15 14 48 11 00    	call   *0x114814(%rip)        # 789898 <_DYNAMIC+0x370>
