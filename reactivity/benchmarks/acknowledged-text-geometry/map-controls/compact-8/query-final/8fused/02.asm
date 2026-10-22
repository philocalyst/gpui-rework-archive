
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000066c130 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>>:
  66c130:	55                   	push   %rbp
  66c131:	41 57                	push   %r15
  66c133:	41 56                	push   %r14
  66c135:	41 55                	push   %r13
  66c137:	41 54                	push   %r12
  66c139:	53                   	push   %rbx
  66c13a:	50                   	push   %rax
  66c13b:	48 8b 46 18          	mov    0x18(%rsi),%rax
  66c13f:	4c 8b 46 20          	mov    0x20(%rsi),%r8
  66c143:	4c 39 c0             	cmp    %r8,%rax
  66c146:	0f 83 f1 00 00 00    	jae    66c23d <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x10d>
  66c14c:	4c 8b 0a             	mov    (%rdx),%r9
  66c14f:	4c 8b 52 08          	mov    0x8(%rdx),%r10
  66c153:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  66c157:	4c 8b 76 08          	mov    0x8(%rsi),%r14
  66c15b:	48 8b 56 10          	mov    0x10(%rsi),%rdx
  66c15f:	48 83 3e 01          	cmpq   $0x1,(%rsi)
  66c163:	75 68                	jne    66c1cd <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x9d>
  66c165:	4c 8d 1c 40          	lea    (%rax,%rax,2),%r11
  66c169:	4f 8d 3c 9e          	lea    (%r14,%r11,4),%r15
  66c16d:	49 83 c7 09          	add    $0x9,%r15
  66c171:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  66c178:	0f 1f 84 00 00 00 00 
  66c17f:	00 
  66c180:	48 39 d0             	cmp    %rdx,%rax
  66c183:	0f 83 27 01 00 00    	jae    66c2b0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x180>
  66c189:	41 8b 5f f7          	mov    -0x9(%r15),%ebx
  66c18d:	45 8b 77 fb          	mov    -0x5(%r15),%r14d
  66c191:	45 0f b6 5f ff       	movzbl -0x1(%r15),%r11d
  66c196:	41 0f b6 6f 02       	movzbl 0x2(%r15),%ebp
  66c19b:	40 88 6c 24 06       	mov    %bpl,0x6(%rsp)
  66c1a0:	41 0f b7 2f          	movzwl (%r15),%ebp
  66c1a4:	66 89 6c 24 04       	mov    %bp,0x4(%rsp)
  66c1a9:	4d 8b 21             	mov    (%r9),%r12
  66c1ac:	41 3b 1c 24          	cmp    (%r12),%ebx
  66c1b0:	0f 85 8f 00 00 00    	jne    66c245 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x115>
  66c1b6:	45 84 1a             	test   %r11b,(%r10)
  66c1b9:	0f 85 9b 00 00 00    	jne    66c25a <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x12a>
  66c1bf:	48 ff c0             	inc    %rax
  66c1c2:	49 83 c7 0c          	add    $0xc,%r15
  66c1c6:	49 39 c0             	cmp    %rax,%r8
  66c1c9:	75 b5                	jne    66c180 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x50>
  66c1cb:	eb 6c                	jmp    66c239 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x109>
  66c1cd:	48 39 c2             	cmp    %rax,%rdx
  66c1d0:	49 89 c7             	mov    %rax,%r15
  66c1d3:	4c 0f 47 fa          	cmova  %rdx,%r15
  66c1d7:	49 ff c7             	inc    %r15
  66c1da:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  66c1e0:	48 39 d0             	cmp    %rdx,%rax
  66c1e3:	0f 83 cd 00 00 00    	jae    66c2b6 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x186>
  66c1e9:	4c 8d 60 01          	lea    0x1(%rax),%r12
  66c1ed:	41 8b 1c c6          	mov    (%r14,%rax,8),%ebx
  66c1f1:	49 39 d4             	cmp    %rdx,%r12
  66c1f4:	73 09                	jae    66c1ff <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0xcf>
  66c1f6:	41 b3 01             	mov    $0x1,%r11b
  66c1f9:	43 39 1c e6          	cmp    %ebx,(%r14,%r12,8)
  66c1fd:	74 12                	je     66c211 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0xe1>
  66c1ff:	48 85 c0             	test   %rax,%rax
  66c202:	74 1c                	je     66c220 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0xf0>
  66c204:	43 39 5c e6 f0       	cmp    %ebx,-0x10(%r14,%r12,8)
  66c209:	41 0f 94 c3          	sete   %r11b
  66c20d:	41 80 f3 03          	xor    $0x3,%r11b
  66c211:	4d 8b 29             	mov    (%r9),%r13
  66c214:	41 3b 5d 00          	cmp    0x0(%r13),%ebx
  66c218:	74 12                	je     66c22c <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0xfc>
  66c21a:	eb 29                	jmp    66c245 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x115>
  66c21c:	0f 1f 40 00          	nopl   0x0(%rax)
  66c220:	41 b3 03             	mov    $0x3,%r11b
  66c223:	4d 8b 29             	mov    (%r9),%r13
  66c226:	41 3b 5d 00          	cmp    0x0(%r13),%ebx
  66c22a:	75 19                	jne    66c245 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x115>
  66c22c:	45 84 1a             	test   %r11b,(%r10)
  66c22f:	75 22                	jne    66c253 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x123>
  66c231:	4c 89 e0             	mov    %r12,%rax
  66c234:	4d 39 e0             	cmp    %r12,%r8
  66c237:	75 a7                	jne    66c1e0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0xb0>
  66c239:	4c 89 46 18          	mov    %r8,0x18(%rsi)
  66c23d:	c7 07 02 00 00 00    	movl   $0x2,(%rdi)
  66c243:	eb 59                	jmp    66c29e <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x16e>
  66c245:	48 ff c0             	inc    %rax
  66c248:	48 89 46 18          	mov    %rax,0x18(%rsi)
  66c24c:	c6 01 01             	movb   $0x1,(%rcx)
  66c24f:	31 c9                	xor    %ecx,%ecx
  66c251:	eb 31                	jmp    66c284 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x154>
  66c253:	47 8b 74 e6 fc       	mov    -0x4(%r14,%r12,8),%r14d
  66c258:	eb 06                	jmp    66c260 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x130>
  66c25a:	48 ff c0             	inc    %rax
  66c25d:	49 89 c4             	mov    %rax,%r12
  66c260:	4c 89 66 18          	mov    %r12,0x18(%rsi)
  66c264:	49 c1 e6 20          	shl    $0x20,%r14
  66c268:	89 d8                	mov    %ebx,%eax
  66c26a:	4c 09 f0             	or     %r14,%rax
  66c26d:	0f b6 4c 24 06       	movzbl 0x6(%rsp),%ecx
  66c272:	88 4c 24 02          	mov    %cl,0x2(%rsp)
  66c276:	0f b7 4c 24 04       	movzwl 0x4(%rsp),%ecx
  66c27b:	66 89 0c 24          	mov    %cx,(%rsp)
  66c27f:	b9 01 00 00 00       	mov    $0x1,%ecx
  66c284:	89 0f                	mov    %ecx,(%rdi)
  66c286:	48 89 47 04          	mov    %rax,0x4(%rdi)
  66c28a:	44 88 5f 0c          	mov    %r11b,0xc(%rdi)
  66c28e:	0f b7 04 24          	movzwl (%rsp),%eax
  66c292:	66 89 47 0d          	mov    %ax,0xd(%rdi)
  66c296:	0f b6 44 24 02       	movzbl 0x2(%rsp),%eax
  66c29b:	88 47 0f             	mov    %al,0xf(%rdi)
  66c29e:	48 89 f8             	mov    %rdi,%rax
  66c2a1:	48 83 c4 08          	add    $0x8,%rsp
  66c2a5:	5b                   	pop    %rbx
  66c2a6:	41 5c                	pop    %r12
  66c2a8:	41 5d                	pop    %r13
  66c2aa:	41 5e                	pop    %r14
  66c2ac:	41 5f                	pop    %r15
  66c2ae:	5d                   	pop    %rbp
  66c2af:	c3                   	ret
  66c2b0:	48 ff c0             	inc    %rax
  66c2b3:	49 89 c7             	mov    %rax,%r15
  66c2b6:	4c 89 7e 18          	mov    %r15,0x18(%rsi)
  66c2ba:	48 8d 3d d7 2b 11 00 	lea    0x112bd7(%rip),%rdi        # 77ee98 <anon.17cc0cddeb7f52c0d510aaf5d8af24ac.11.llvm.10253562051569396321>
  66c2c1:	ff 15 09 d5 11 00    	call   *0x11d509(%rip)        # 7897d0 <_DYNAMIC+0x2a8>
