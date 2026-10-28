
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000661210 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth>:
  661210:	41 56                	push   %r14
  661212:	53                   	push   %rbx
  661213:	50                   	push   %rax
  661214:	49 89 f6             	mov    %rsi,%r14
  661217:	48 89 fb             	mov    %rdi,%rbx
  66121a:	48 89 f7             	mov    %rsi,%rdi
  66121d:	48 89 d6             	mov    %rdx,%rsi
  661220:	e8 eb 02 00 00       	call   661510 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>
  661225:	48 85 c0             	test   %rax,%rax
  661228:	74 0f                	je     661239 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x29>
  66122a:	48 c7 03 02 00 00 00 	movq   $0x2,(%rbx)
  661231:	48 83 c4 08          	add    $0x8,%rsp
  661235:	5b                   	pop    %rbx
  661236:	41 5e                	pop    %r14
  661238:	c3                   	ret
  661239:	49 8b 56 18          	mov    0x18(%r14),%rdx
  66123d:	49 8b 76 08          	mov    0x8(%r14),%rsi
  661241:	49 8b 46 10          	mov    0x10(%r14),%rax
  661245:	49 83 3e 01          	cmpq   $0x1,(%r14)
  661249:	75 37                	jne    661282 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x72>
  66124b:	48 39 c2             	cmp    %rax,%rdx
  66124e:	73 da                	jae    66122a <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1a>
  661250:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  661254:	8b 3c 8e             	mov    (%rsi,%rcx,4),%edi
  661257:	4c 8d 40 ff          	lea    -0x1(%rax),%r8
  66125b:	48 8d 34 8e          	lea    (%rsi,%rcx,4),%rsi
  66125f:	48 83 c6 0c          	add    $0xc,%rsi
  661263:	48 89 d1             	mov    %rdx,%rcx
  661266:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  66126d:	00 00 00 
  661270:	49 39 c8             	cmp    %rcx,%r8
  661273:	74 40                	je     6612b5 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xa5>
  661275:	48 ff c1             	inc    %rcx
  661278:	39 3e                	cmp    %edi,(%rsi)
  66127a:	48 8d 76 0c          	lea    0xc(%rsi),%rsi
  66127e:	74 f0                	je     661270 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x60>
  661280:	eb 36                	jmp    6612b8 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xa8>
  661282:	48 39 c2             	cmp    %rax,%rdx
  661285:	73 a3                	jae    66122a <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1a>
  661287:	8b 3c d6             	mov    (%rsi,%rdx,8),%edi
  66128a:	4c 8d 40 ff          	lea    -0x1(%rax),%r8
  66128e:	49 89 d1             	mov    %rdx,%r9
  661291:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  661298:	0f 1f 84 00 00 00 00 
  66129f:	00 
  6612a0:	4d 39 c8             	cmp    %r9,%r8
  6612a3:	74 10                	je     6612b5 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xa5>
  6612a5:	49 8d 49 01          	lea    0x1(%r9),%rcx
  6612a9:	42 39 7c ce 08       	cmp    %edi,0x8(%rsi,%r9,8)
  6612ae:	49 89 c9             	mov    %rcx,%r9
  6612b1:	74 ed                	je     6612a0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x90>
  6612b3:	eb 03                	jmp    6612b8 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xa8>
  6612b5:	48 89 c1             	mov    %rax,%rcx
  6612b8:	49 89 4e 18          	mov    %rcx,0x18(%r14)
  6612bc:	48 89 df             	mov    %rbx,%rdi
  6612bf:	4c 89 f6             	mov    %r14,%rsi
  6612c2:	48 83 c4 08          	add    $0x8,%rsp
  6612c6:	5b                   	pop    %rbx
  6612c7:	41 5e                	pop    %r14
  6612c9:	ff 25 b1 85 12 00    	jmp    *0x1285b1(%rip)        # 789880 <_DYNAMIC+0x358>
