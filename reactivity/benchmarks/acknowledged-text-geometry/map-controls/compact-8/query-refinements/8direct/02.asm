
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006818e0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>>:
  6818e0:	55                   	push   %rbp
  6818e1:	41 57                	push   %r15
  6818e3:	41 56                	push   %r14
  6818e5:	41 55                	push   %r13
  6818e7:	41 54                	push   %r12
  6818e9:	53                   	push   %rbx
  6818ea:	50                   	push   %rax
  6818eb:	48 8b 46 18          	mov    0x18(%rsi),%rax
  6818ef:	4c 8b 46 20          	mov    0x20(%rsi),%r8
  6818f3:	4c 39 c0             	cmp    %r8,%rax
  6818f6:	0f 83 f1 00 00 00    	jae    6819ed <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x10d>
  6818fc:	4c 8b 0a             	mov    (%rdx),%r9
  6818ff:	4c 8b 52 08          	mov    0x8(%rdx),%r10
  681903:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  681907:	4c 8b 76 08          	mov    0x8(%rsi),%r14
  68190b:	48 8b 56 10          	mov    0x10(%rsi),%rdx
  68190f:	48 83 3e 01          	cmpq   $0x1,(%rsi)
  681913:	75 68                	jne    68197d <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x9d>
  681915:	4c 8d 1c 40          	lea    (%rax,%rax,2),%r11
  681919:	4f 8d 3c 9e          	lea    (%r14,%r11,4),%r15
  68191d:	49 83 c7 09          	add    $0x9,%r15
  681921:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  681928:	0f 1f 84 00 00 00 00 
  68192f:	00 
  681930:	48 39 d0             	cmp    %rdx,%rax
  681933:	0f 83 27 01 00 00    	jae    681a60 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x180>
  681939:	41 8b 5f f7          	mov    -0x9(%r15),%ebx
  68193d:	45 8b 77 fb          	mov    -0x5(%r15),%r14d
  681941:	45 0f b6 5f ff       	movzbl -0x1(%r15),%r11d
  681946:	41 0f b6 6f 02       	movzbl 0x2(%r15),%ebp
  68194b:	40 88 6c 24 06       	mov    %bpl,0x6(%rsp)
  681950:	41 0f b7 2f          	movzwl (%r15),%ebp
  681954:	66 89 6c 24 04       	mov    %bp,0x4(%rsp)
  681959:	4d 8b 21             	mov    (%r9),%r12
  68195c:	41 3b 1c 24          	cmp    (%r12),%ebx
  681960:	0f 85 8f 00 00 00    	jne    6819f5 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x115>
  681966:	45 84 1a             	test   %r11b,(%r10)
  681969:	0f 85 9b 00 00 00    	jne    681a0a <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x12a>
  68196f:	48 ff c0             	inc    %rax
  681972:	49 83 c7 0c          	add    $0xc,%r15
  681976:	49 39 c0             	cmp    %rax,%r8
  681979:	75 b5                	jne    681930 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x50>
  68197b:	eb 6c                	jmp    6819e9 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x109>
  68197d:	48 39 c2             	cmp    %rax,%rdx
  681980:	49 89 c7             	mov    %rax,%r15
  681983:	4c 0f 47 fa          	cmova  %rdx,%r15
  681987:	49 ff c7             	inc    %r15
  68198a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  681990:	48 39 d0             	cmp    %rdx,%rax
  681993:	0f 83 cd 00 00 00    	jae    681a66 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x186>
  681999:	4c 8d 60 01          	lea    0x1(%rax),%r12
  68199d:	41 8b 1c c6          	mov    (%r14,%rax,8),%ebx
  6819a1:	49 39 d4             	cmp    %rdx,%r12
  6819a4:	73 09                	jae    6819af <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0xcf>
  6819a6:	41 b3 01             	mov    $0x1,%r11b
  6819a9:	43 39 1c e6          	cmp    %ebx,(%r14,%r12,8)
  6819ad:	74 12                	je     6819c1 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0xe1>
  6819af:	48 85 c0             	test   %rax,%rax
  6819b2:	74 1c                	je     6819d0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0xf0>
  6819b4:	43 39 5c e6 f0       	cmp    %ebx,-0x10(%r14,%r12,8)
  6819b9:	41 0f 94 c3          	sete   %r11b
  6819bd:	41 80 f3 03          	xor    $0x3,%r11b
  6819c1:	4d 8b 29             	mov    (%r9),%r13
  6819c4:	41 3b 5d 00          	cmp    0x0(%r13),%ebx
  6819c8:	74 12                	je     6819dc <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0xfc>
  6819ca:	eb 29                	jmp    6819f5 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x115>
  6819cc:	0f 1f 40 00          	nopl   0x0(%rax)
  6819d0:	41 b3 03             	mov    $0x3,%r11b
  6819d3:	4d 8b 29             	mov    (%r9),%r13
  6819d6:	41 3b 5d 00          	cmp    0x0(%r13),%ebx
  6819da:	75 19                	jne    6819f5 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x115>
  6819dc:	45 84 1a             	test   %r11b,(%r10)
  6819df:	75 22                	jne    681a03 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x123>
  6819e1:	4c 89 e0             	mov    %r12,%rax
  6819e4:	4d 39 e0             	cmp    %r12,%r8
  6819e7:	75 a7                	jne    681990 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0xb0>
  6819e9:	4c 89 46 18          	mov    %r8,0x18(%rsi)
  6819ed:	c7 07 02 00 00 00    	movl   $0x2,(%rdi)
  6819f3:	eb 59                	jmp    681a4e <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x16e>
  6819f5:	48 ff c0             	inc    %rax
  6819f8:	48 89 46 18          	mov    %rax,0x18(%rsi)
  6819fc:	c6 01 01             	movb   $0x1,(%rcx)
  6819ff:	31 c9                	xor    %ecx,%ecx
  681a01:	eb 31                	jmp    681a34 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x154>
  681a03:	47 8b 74 e6 fc       	mov    -0x4(%r14,%r12,8),%r14d
  681a08:	eb 06                	jmp    681a10 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>+0x130>
  681a0a:	48 ff c0             	inc    %rax
  681a0d:	49 89 c4             	mov    %rax,%r12
  681a10:	4c 89 66 18          	mov    %r12,0x18(%rsi)
  681a14:	49 c1 e6 20          	shl    $0x20,%r14
  681a18:	89 d8                	mov    %ebx,%eax
  681a1a:	4c 09 f0             	or     %r14,%rax
  681a1d:	0f b6 4c 24 06       	movzbl 0x6(%rsp),%ecx
  681a22:	88 4c 24 02          	mov    %cl,0x2(%rsp)
  681a26:	0f b7 4c 24 04       	movzwl 0x4(%rsp),%ecx
  681a2b:	66 89 0c 24          	mov    %cx,(%rsp)
  681a2f:	b9 01 00 00 00       	mov    $0x1,%ecx
  681a34:	89 0f                	mov    %ecx,(%rdi)
  681a36:	48 89 47 04          	mov    %rax,0x4(%rdi)
  681a3a:	44 88 5f 0c          	mov    %r11b,0xc(%rdi)
  681a3e:	0f b7 04 24          	movzwl (%rsp),%eax
  681a42:	66 89 47 0d          	mov    %ax,0xd(%rdi)
  681a46:	0f b6 44 24 02       	movzbl 0x2(%rsp),%eax
  681a4b:	88 47 0f             	mov    %al,0xf(%rdi)
  681a4e:	48 89 f8             	mov    %rdi,%rax
  681a51:	48 83 c4 08          	add    $0x8,%rsp
  681a55:	5b                   	pop    %rbx
  681a56:	41 5c                	pop    %r12
  681a58:	41 5d                	pop    %r13
  681a5a:	41 5e                	pop    %r14
  681a5c:	41 5f                	pop    %r15
  681a5e:	5d                   	pop    %rbp
  681a5f:	c3                   	ret
  681a60:	48 ff c0             	inc    %rax
  681a63:	49 89 c7             	mov    %rax,%r15
  681a66:	4c 89 7e 18          	mov    %r15,0x18(%rsi)
  681a6a:	48 8d 3d 97 e1 0f 00 	lea    0xfe197(%rip),%rdi        # 77fc08 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468>
  681a71:	ff 15 99 7c 10 00    	call   *0x107c99(%rip)        # 789710 <_DYNAMIC+0x2a8>
