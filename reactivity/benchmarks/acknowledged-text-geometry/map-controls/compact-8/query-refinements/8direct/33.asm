
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000661180 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth>:
  661180:	41 56                	push   %r14
  661182:	53                   	push   %rbx
  661183:	50                   	push   %rax
  661184:	49 89 f6             	mov    %rsi,%r14
  661187:	48 89 fb             	mov    %rdi,%rbx
  66118a:	48 89 f7             	mov    %rsi,%rdi
  66118d:	48 89 d6             	mov    %rdx,%rsi
  661190:	e8 eb 02 00 00       	call   661480 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>
  661195:	48 85 c0             	test   %rax,%rax
  661198:	74 0f                	je     6611a9 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x29>
  66119a:	48 c7 03 02 00 00 00 	movq   $0x2,(%rbx)
  6611a1:	48 83 c4 08          	add    $0x8,%rsp
  6611a5:	5b                   	pop    %rbx
  6611a6:	41 5e                	pop    %r14
  6611a8:	c3                   	ret
  6611a9:	49 8b 56 18          	mov    0x18(%r14),%rdx
  6611ad:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6611b1:	49 8b 46 10          	mov    0x10(%r14),%rax
  6611b5:	49 83 3e 01          	cmpq   $0x1,(%r14)
  6611b9:	75 37                	jne    6611f2 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x72>
  6611bb:	48 39 c2             	cmp    %rax,%rdx
  6611be:	73 da                	jae    66119a <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1a>
  6611c0:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  6611c4:	8b 3c 8e             	mov    (%rsi,%rcx,4),%edi
  6611c7:	4c 8d 40 ff          	lea    -0x1(%rax),%r8
  6611cb:	48 8d 34 8e          	lea    (%rsi,%rcx,4),%rsi
  6611cf:	48 83 c6 0c          	add    $0xc,%rsi
  6611d3:	48 89 d1             	mov    %rdx,%rcx
  6611d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  6611dd:	00 00 00 
  6611e0:	49 39 c8             	cmp    %rcx,%r8
  6611e3:	74 40                	je     661225 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xa5>
  6611e5:	48 ff c1             	inc    %rcx
  6611e8:	39 3e                	cmp    %edi,(%rsi)
  6611ea:	48 8d 76 0c          	lea    0xc(%rsi),%rsi
  6611ee:	74 f0                	je     6611e0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x60>
  6611f0:	eb 36                	jmp    661228 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xa8>
  6611f2:	48 39 c2             	cmp    %rax,%rdx
  6611f5:	73 a3                	jae    66119a <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1a>
  6611f7:	8b 3c d6             	mov    (%rsi,%rdx,8),%edi
  6611fa:	4c 8d 40 ff          	lea    -0x1(%rax),%r8
  6611fe:	49 89 d1             	mov    %rdx,%r9
  661201:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  661208:	0f 1f 84 00 00 00 00 
  66120f:	00 
  661210:	4d 39 c8             	cmp    %r9,%r8
  661213:	74 10                	je     661225 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xa5>
  661215:	49 8d 49 01          	lea    0x1(%r9),%rcx
  661219:	42 39 7c ce 08       	cmp    %edi,0x8(%rsi,%r9,8)
  66121e:	49 89 c9             	mov    %rcx,%r9
  661221:	74 ed                	je     661210 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x90>
  661223:	eb 03                	jmp    661228 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xa8>
  661225:	48 89 c1             	mov    %rax,%rcx
  661228:	49 89 4e 18          	mov    %rcx,0x18(%r14)
  66122c:	48 89 df             	mov    %rbx,%rdi
  66122f:	4c 89 f6             	mov    %r14,%rsi
  661232:	48 83 c4 08          	add    $0x8,%rsp
  661236:	5b                   	pop    %rbx
  661237:	41 5e                	pop    %r14
  661239:	ff 25 81 85 12 00    	jmp    *0x128581(%rip)        # 7897c0 <_DYNAMIC+0x358>
