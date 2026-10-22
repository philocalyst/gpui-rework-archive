
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000675100 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Stop>>::grow_one>:
  675100:	41 56                	push   %r14
  675102:	53                   	push   %rbx
  675103:	48 83 ec 18          	sub    $0x18,%rsp
  675107:	48 89 fb             	mov    %rdi,%rbx
  67510a:	48 8b 37             	mov    (%rdi),%rsi
  67510d:	48 8d 04 36          	lea    (%rsi,%rsi,1),%rax
  675111:	48 83 f8 05          	cmp    $0x5,%rax
  675115:	41 be 04 00 00 00    	mov    $0x4,%r14d
  67511b:	4c 0f 43 f0          	cmovae %rax,%r14
  67511f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  675123:	48 89 e7             	mov    %rsp,%rdi
  675126:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  67512c:	41 b9 0c 00 00 00    	mov    $0xc,%r9d
  675132:	4c 89 f1             	mov    %r14,%rcx
  675135:	e8 86 01 00 00       	call   6752c0 <<alloc::raw_vec::RawVecInner>::finish_grow>
  67513a:	83 3c 24 01          	cmpl   $0x1,(%rsp)
  67513e:	74 14                	je     675154 <<alloc::raw_vec::RawVec<gpui_canvas::text::layout::Stop>>::grow_one+0x54>
  675140:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  675145:	48 89 43 08          	mov    %rax,0x8(%rbx)
  675149:	4c 89 33             	mov    %r14,(%rbx)
  67514c:	48 83 c4 18          	add    $0x18,%rsp
  675150:	5b                   	pop    %rbx
  675151:	41 5e                	pop    %r14
  675153:	c3                   	ret
  675154:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  675159:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  67515e:	ff 15 34 47 11 00    	call   *0x114734(%rip)        # 789898 <_DYNAMIC+0x370>
