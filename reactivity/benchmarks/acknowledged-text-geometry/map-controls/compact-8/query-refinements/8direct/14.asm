
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000661fb0 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::CommonStop>>::grow_one>:
  661fb0:	41 56                	push   %r14
  661fb2:	53                   	push   %rbx
  661fb3:	48 83 ec 18          	sub    $0x18,%rsp
  661fb7:	48 89 fb             	mov    %rdi,%rbx
  661fba:	48 8b 37             	mov    (%rdi),%rsi
  661fbd:	48 8d 04 36          	lea    (%rsi,%rsi,1),%rax
  661fc1:	48 83 f8 05          	cmp    $0x5,%rax
  661fc5:	41 be 04 00 00 00    	mov    $0x4,%r14d
  661fcb:	4c 0f 43 f0          	cmovae %rax,%r14
  661fcf:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  661fd3:	48 89 e7             	mov    %rsp,%rdi
  661fd6:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  661fdc:	41 b9 08 00 00 00    	mov    $0x8,%r9d
  661fe2:	4c 89 f1             	mov    %r14,%rcx
  661fe5:	e8 66 02 00 00       	call   662250 <<alloc::raw_vec::RawVecInner>::finish_grow>
  661fea:	83 3c 24 01          	cmpl   $0x1,(%rsp)
  661fee:	74 14                	je     662004 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::CommonStop>>::grow_one+0x54>
  661ff0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  661ff5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  661ff9:	4c 89 33             	mov    %r14,(%rbx)
  661ffc:	48 83 c4 18          	add    $0x18,%rsp
  662000:	5b                   	pop    %rbx
  662001:	41 5e                	pop    %r14
  662003:	c3                   	ret
  662004:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  662009:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  66200e:	ff 15 cc 77 12 00    	call   *0x1277cc(%rip)        # 7897e0 <_DYNAMIC+0x378>
