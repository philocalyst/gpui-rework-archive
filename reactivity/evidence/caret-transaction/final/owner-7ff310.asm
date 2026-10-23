
/tmp/gpui-caret-transaction-bin/62e-native-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007ff310 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut>:
  7ff310:	55                   	push   %rbp
  7ff311:	41 57                	push   %r15
  7ff313:	41 56                	push   %r14
  7ff315:	41 55                	push   %r13
  7ff317:	41 54                	push   %r12
  7ff319:	53                   	push   %rbx
  7ff31a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  7ff321:	48 8b 02             	mov    (%rdx),%rax
  7ff324:	48 85 c0             	test   %rax,%rax
  7ff327:	0f 84 f9 02 00 00    	je     7ff626 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x316>
  7ff32d:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  7ff332:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  7ff339:	00 
  7ff33a:	0f 10 42 08          	movups 0x8(%rdx),%xmm0
  7ff33e:	0f 10 4a 18          	movups 0x18(%rdx),%xmm1
  7ff342:	0f 10 52 28          	movups 0x28(%rdx),%xmm2
  7ff346:	0f 10 5a 38          	movups 0x38(%rdx),%xmm3
  7ff34a:	0f 11 84 24 d8 00 00 	movups %xmm0,0xd8(%rsp)
  7ff351:	00 
  7ff352:	0f 11 8c 24 e8 00 00 	movups %xmm1,0xe8(%rsp)
  7ff359:	00 
  7ff35a:	0f 11 94 24 f8 00 00 	movups %xmm2,0xf8(%rsp)
  7ff361:	00 
  7ff362:	0f 11 9c 24 08 01 00 	movups %xmm3,0x108(%rsp)
  7ff369:	00 
  7ff36a:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  7ff36f:	48 8d b4 24 d0 00 00 	lea    0xd0(%rsp),%rsi
  7ff376:	00 
  7ff377:	e8 24 b3 ff ff       	call   7fa6a0 <<parley::layout::line::GlyphRun<()>>::positioned_glyphs>
  7ff37c:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  7ff381:	48 8b 5c 24 38       	mov    0x38(%rsp),%rbx
  7ff386:	0f b6 4c 24 40       	movzbl 0x40(%rsp),%ecx
  7ff38b:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7ff390:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7ff395:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  7ff39a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  7ff39f:	4c 8b 74 24 68       	mov    0x68(%rsp),%r14
  7ff3a4:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  7ff3a9:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  7ff3ae:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  7ff3b3:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  7ff3ba:	00 
  7ff3bb:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7ff3c0:	44 8b a4 24 88 00 00 	mov    0x88(%rsp),%r12d
  7ff3c7:	00 
  7ff3c8:	44 8b ac 24 8c 00 00 	mov    0x8c(%rsp),%r13d
  7ff3cf:	00 
  7ff3d0:	44 8b 84 24 90 00 00 	mov    0x90(%rsp),%r8d
  7ff3d7:	00 
  7ff3d8:	44 8b 9c 24 94 00 00 	mov    0x94(%rsp),%r11d
  7ff3df:	00 
  7ff3e0:	0f b6 ac 24 b0 00 00 	movzbl 0xb0(%rsp),%ebp
  7ff3e7:	00 
  7ff3e8:	44 0f b6 bc 24 c4 00 	movzbl 0xc4(%rsp),%r15d
  7ff3ef:	00 00 
  7ff3f1:	31 c0                	xor    %eax,%eax
  7ff3f3:	eb 14                	jmp    7ff409 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0xf9>
  7ff3f5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  7ff3fc:	00 00 00 00 
  7ff400:	48 83 c7 10          	add    $0x10,%rdi
  7ff404:	48 ff c0             	inc    %rax
  7ff407:	31 c9                	xor    %ecx,%ecx
  7ff409:	f6 c1 01             	test   $0x1,%cl
  7ff40c:	75 f6                	jne    7ff404 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0xf4>
  7ff40e:	45 89 c1             	mov    %r8d,%r9d
  7ff411:	48 39 df             	cmp    %rbx,%rdi
  7ff414:	75 ea                	jne    7ff400 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0xf0>
  7ff416:	48 39 df             	cmp    %rbx,%rdi
  7ff419:	0f 94 c1             	sete   %cl
  7ff41c:	45 89 ca             	mov    %r9d,%r10d
  7ff41f:	90                   	nop
  7ff420:	41 f6 c7 01          	test   $0x1,%r15b
  7ff424:	74 7a                	je     7ff4a0 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x190>
  7ff426:	45 39 da             	cmp    %r11d,%r10d
  7ff429:	0f 82 8a 01 00 00    	jb     7ff5b9 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x2a9>
  7ff42f:	45 39 e2             	cmp    %r12d,%r10d
  7ff432:	40 0f 95 c6          	setne  %sil
  7ff436:	40 84 f5             	test   %sil,%bpl
  7ff439:	0f 84 e0 01 00 00    	je     7ff61f <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x30f>
  7ff43f:	41 8d 72 ff          	lea    -0x1(%r10),%esi
  7ff443:	48 39 f2             	cmp    %rsi,%rdx
  7ff446:	0f 86 6c 02 00 00    	jbe    7ff6b8 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x3a8>
  7ff44c:	44 39 e6             	cmp    %r12d,%esi
  7ff44f:	0f 86 cb 00 00 00    	jbe    7ff520 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x210>
  7ff455:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  7ff459:	4d 8d 4e 16          	lea    0x16(%r14),%r9
  7ff45d:	4f 8d 04 c1          	lea    (%r9,%r8,8),%r8
  7ff461:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  7ff468:	0f 1f 84 00 00 00 00 
  7ff46f:	00 
  7ff470:	48 39 f2             	cmp    %rsi,%rdx
  7ff473:	0f 86 18 02 00 00    	jbe    7ff691 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x381>
  7ff479:	41 f6 40 01 02       	testb  $0x2,0x1(%r8)
  7ff47e:	0f 85 9c 00 00 00    	jne    7ff520 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x210>
  7ff484:	48 ff ce             	dec    %rsi
  7ff487:	49 83 c0 e8          	add    $0xffffffffffffffe8,%r8
  7ff48b:	41 39 f4             	cmp    %esi,%r12d
  7ff48e:	72 e0                	jb     7ff470 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x160>
  7ff490:	4c 89 e6             	mov    %r12,%rsi
  7ff493:	45 89 e0             	mov    %r12d,%r8d
  7ff496:	e9 88 00 00 00       	jmp    7ff523 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x213>
  7ff49b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  7ff4a0:	45 39 da             	cmp    %r11d,%r10d
  7ff4a3:	0f 82 07 01 00 00    	jb     7ff5b0 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x2a0>
  7ff4a9:	45 39 eb             	cmp    %r13d,%r11d
  7ff4ac:	40 0f 95 c6          	setne  %sil
  7ff4b0:	40 84 f5             	test   %sil,%bpl
  7ff4b3:	0f 84 66 01 00 00    	je     7ff61f <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x30f>
  7ff4b9:	44 89 de             	mov    %r11d,%esi
  7ff4bc:	48 39 f2             	cmp    %rsi,%rdx
  7ff4bf:	0f 86 1f 02 00 00    	jbe    7ff6e4 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x3d4>
  7ff4c5:	45 8d 53 01          	lea    0x1(%r11),%r10d
  7ff4c9:	45 39 ea             	cmp    %r13d,%r10d
  7ff4cc:	73 31                	jae    7ff4ff <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x1ef>
  7ff4ce:	45 89 d1             	mov    %r10d,%r9d
  7ff4d1:	4f 8d 04 49          	lea    (%r9,%r9,2),%r8
  7ff4d5:	4d 8d 56 16          	lea    0x16(%r14),%r10
  7ff4d9:	4f 8d 04 c2          	lea    (%r10,%r8,8),%r8
  7ff4dd:	4d 89 ca             	mov    %r9,%r10
  7ff4e0:	4c 39 d2             	cmp    %r10,%rdx
  7ff4e3:	0f 86 8b 01 00 00    	jbe    7ff674 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x364>
  7ff4e9:	41 f6 40 01 02       	testb  $0x2,0x1(%r8)
  7ff4ee:	75 0f                	jne    7ff4ff <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x1ef>
  7ff4f0:	49 ff c2             	inc    %r10
  7ff4f3:	49 83 c0 18          	add    $0x18,%r8
  7ff4f7:	4d 39 d5             	cmp    %r10,%r13
  7ff4fa:	75 e4                	jne    7ff4e0 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x1d0>
  7ff4fc:	45 89 ea             	mov    %r13d,%r10d
  7ff4ff:	45 89 d1             	mov    %r10d,%r9d
  7ff502:	49 ff c9             	dec    %r9
  7ff505:	49 39 d1             	cmp    %rdx,%r9
  7ff508:	0f 83 ec 01 00 00    	jae    7ff6fa <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x3ea>
  7ff50e:	45 89 d8             	mov    %r11d,%r8d
  7ff511:	eb 28                	jmp    7ff53b <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x22b>
  7ff513:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  7ff51a:	84 00 00 00 00 00 
  7ff520:	41 89 f0             	mov    %esi,%r8d
  7ff523:	48 39 f2             	cmp    %rsi,%rdx
  7ff526:	0f 86 a2 01 00 00    	jbe    7ff6ce <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x3be>
  7ff52c:	45 89 d1             	mov    %r10d,%r9d
  7ff52f:	49 ff c9             	dec    %r9
  7ff532:	49 39 d1             	cmp    %rdx,%r9
  7ff535:	0f 83 d5 01 00 00    	jae    7ff710 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x400>
  7ff53b:	45 89 d3             	mov    %r10d,%r11d
  7ff53e:	48 83 7c 24 28 00    	cmpq   $0x0,0x28(%rsp)
  7ff544:	0f 84 d5 00 00 00    	je     7ff61f <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x30f>
  7ff54a:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  7ff54e:	45 8b 14 f6          	mov    (%r14,%rsi,8),%r10d
  7ff552:	4b 8d 34 49          	lea    (%r9,%r9,2),%rsi
  7ff556:	41 8b 74 f6 04       	mov    0x4(%r14,%rsi,8),%esi
  7ff55b:	44 39 d6             	cmp    %r10d,%esi
  7ff55e:	0f 82 d9 00 00 00    	jb     7ff63d <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x32d>
  7ff564:	48 39 74 24 10       	cmp    %rsi,0x10(%rsp)
  7ff569:	0f 82 ce 00 00 00    	jb     7ff63d <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x32d>
  7ff56f:	44 39 d6             	cmp    %r10d,%esi
  7ff572:	0f 84 2f 01 00 00    	je     7ff6a7 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x397>
  7ff578:	44 89 de             	mov    %r11d,%esi
  7ff57b:	48 39 f2             	cmp    %rsi,%rdx
  7ff57e:	41 0f 92 c1          	setb   %r9b
  7ff582:	45 39 c3             	cmp    %r8d,%r11d
  7ff585:	72 1c                	jb     7ff5a3 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x293>
  7ff587:	45 84 c9             	test   %r9b,%r9b
  7ff58a:	0f 85 c2 00 00 00    	jne    7ff652 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x342>
  7ff590:	45 89 c2             	mov    %r8d,%r10d
  7ff593:	f6 c1 01             	test   $0x1,%cl
  7ff596:	b1 01                	mov    $0x1,%cl
  7ff598:	0f 85 82 fe ff ff    	jne    7ff420 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x110>
  7ff59e:	e9 5d fe ff ff       	jmp    7ff400 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0xf0>
  7ff5a3:	41 b1 01             	mov    $0x1,%r9b
  7ff5a6:	45 84 c9             	test   %r9b,%r9b
  7ff5a9:	74 e5                	je     7ff590 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x280>
  7ff5ab:	e9 a2 00 00 00       	jmp    7ff652 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x342>
  7ff5b0:	45 8d 42 01          	lea    0x1(%r10),%r8d
  7ff5b4:	45 89 c1             	mov    %r8d,%r9d
  7ff5b7:	eb 09                	jmp    7ff5c2 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x2b2>
  7ff5b9:	41 ff cb             	dec    %r11d
  7ff5bc:	45 89 d1             	mov    %r10d,%r9d
  7ff5bf:	45 89 da             	mov    %r11d,%r10d
  7ff5c2:	44 89 d7             	mov    %r10d,%edi
  7ff5c5:	48 39 fa             	cmp    %rdi,%rdx
  7ff5c8:	0f 86 58 01 00 00    	jbe    7ff726 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x416>
  7ff5ce:	48 8d 0c 7f          	lea    (%rdi,%rdi,2),%rcx
  7ff5d2:	41 f6 44 ce 17 01    	testb  $0x1,0x17(%r14,%rcx,8)
  7ff5d8:	75 36                	jne    7ff610 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x300>
  7ff5da:	49 8d 0c ce          	lea    (%r14,%rcx,8),%rcx
  7ff5de:	8b 79 08             	mov    0x8(%rcx),%edi
  7ff5e1:	8b 49 0c             	mov    0xc(%rcx),%ecx
  7ff5e4:	48 8d 34 39          	lea    (%rcx,%rdi,1),%rsi
  7ff5e8:	48 3b 74 24 08       	cmp    0x8(%rsp),%rsi
  7ff5ed:	77 73                	ja     7ff662 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x352>
  7ff5ef:	48 c1 e7 04          	shl    $0x4,%rdi
  7ff5f3:	48 03 7c 24 18       	add    0x18(%rsp),%rdi
  7ff5f8:	48 89 cb             	mov    %rcx,%rbx
  7ff5fb:	48 c1 e3 04          	shl    $0x4,%rbx
  7ff5ff:	48 01 fb             	add    %rdi,%rbx
  7ff602:	48 85 c9             	test   %rcx,%rcx
  7ff605:	0f 84 0b fe ff ff    	je     7ff416 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x106>
  7ff60b:	e9 f0 fd ff ff       	jmp    7ff400 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0xf0>
  7ff610:	bb 04 00 00 00       	mov    $0x4,%ebx
  7ff615:	bf 04 00 00 00       	mov    $0x4,%edi
  7ff61a:	e9 e5 fd ff ff       	jmp    7ff404 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0xf4>
  7ff61f:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  7ff624:	eb 02                	jmp    7ff628 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x318>
  7ff626:	31 c0                	xor    %eax,%eax
  7ff628:	48 01 f0             	add    %rsi,%rax
  7ff62b:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  7ff632:	5b                   	pop    %rbx
  7ff633:	41 5c                	pop    %r12
  7ff635:	41 5d                	pop    %r13
  7ff637:	41 5e                	pop    %r14
  7ff639:	41 5f                	pop    %r15
  7ff63b:	5d                   	pop    %rbp
  7ff63c:	c3                   	ret
  7ff63d:	48 8d 0d dc 8b 30 00 	lea    0x308bdc(%rip),%rcx        # b08220 <anon.e1aed3256c0f336e2763058c1a348a1e.15.llvm.17407148579165845042>
  7ff644:	4c 89 d7             	mov    %r10,%rdi
  7ff647:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  7ff64c:	ff 15 3e e1 32 00    	call   *0x32e13e(%rip)        # b2d790 <_DYNAMIC+0x290>
  7ff652:	44 89 c7             	mov    %r8d,%edi
  7ff655:	48 8d 0d 9c 8c 30 00 	lea    0x308c9c(%rip),%rcx        # b082f8 <anon.e1aed3256c0f336e2763058c1a348a1e.26.llvm.17407148579165845042+0x18>
  7ff65c:	ff 15 2e e1 32 00    	call   *0x32e12e(%rip)        # b2d790 <_DYNAMIC+0x290>
  7ff662:	48 8d 0d 87 8b 30 00 	lea    0x308b87(%rip),%rcx        # b081f0 <anon.e1aed3256c0f336e2763058c1a348a1e.9.llvm.17407148579165845042+0x30>
  7ff669:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  7ff66e:	ff 15 1c e1 32 00    	call   *0x32e11c(%rip)        # b2d790 <_DYNAMIC+0x290>
  7ff674:	4c 39 ca             	cmp    %r9,%rdx
  7ff677:	4c 0f 47 ca          	cmova  %rdx,%r9
  7ff67b:	48 8d 05 a6 8c 30 00 	lea    0x308ca6(%rip),%rax        # b08328 <anon.e1aed3256c0f336e2763058c1a348a1e.26.llvm.17407148579165845042+0x48>
  7ff682:	4c 89 cf             	mov    %r9,%rdi
  7ff685:	48 89 d6             	mov    %rdx,%rsi
  7ff688:	48 89 c2             	mov    %rax,%rdx
  7ff68b:	ff 15 3f e1 32 00    	call   *0x32e13f(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7ff691:	48 8d 05 e8 8b 30 00 	lea    0x308be8(%rip),%rax        # b08280 <anon.e1aed3256c0f336e2763058c1a348a1e.18.llvm.17407148579165845042+0x30>
  7ff698:	48 89 f7             	mov    %rsi,%rdi
  7ff69b:	48 89 d6             	mov    %rdx,%rsi
  7ff69e:	48 89 c2             	mov    %rax,%rdx
  7ff6a1:	ff 15 29 e1 32 00    	call   *0x32e129(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7ff6a7:	48 8d 15 1a 8c 30 00 	lea    0x308c1a(%rip),%rdx        # b082c8 <anon.e1aed3256c0f336e2763058c1a348a1e.18.llvm.17407148579165845042+0x78>
  7ff6ae:	31 ff                	xor    %edi,%edi
  7ff6b0:	31 f6                	xor    %esi,%esi
  7ff6b2:	ff 15 18 e1 32 00    	call   *0x32e118(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7ff6b8:	48 8d 05 a9 8b 30 00 	lea    0x308ba9(%rip),%rax        # b08268 <anon.e1aed3256c0f336e2763058c1a348a1e.18.llvm.17407148579165845042+0x18>
  7ff6bf:	48 89 f7             	mov    %rsi,%rdi
  7ff6c2:	48 89 d6             	mov    %rdx,%rsi
  7ff6c5:	48 89 c2             	mov    %rax,%rdx
  7ff6c8:	ff 15 02 e1 32 00    	call   *0x32e102(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7ff6ce:	48 8d 05 c3 8b 30 00 	lea    0x308bc3(%rip),%rax        # b08298 <anon.e1aed3256c0f336e2763058c1a348a1e.18.llvm.17407148579165845042+0x48>
  7ff6d5:	48 89 f7             	mov    %rsi,%rdi
  7ff6d8:	48 89 d6             	mov    %rdx,%rsi
  7ff6db:	48 89 c2             	mov    %rax,%rdx
  7ff6de:	ff 15 ec e0 32 00    	call   *0x32e0ec(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7ff6e4:	48 8d 05 25 8c 30 00 	lea    0x308c25(%rip),%rax        # b08310 <anon.e1aed3256c0f336e2763058c1a348a1e.26.llvm.17407148579165845042+0x30>
  7ff6eb:	48 89 f7             	mov    %rsi,%rdi
  7ff6ee:	48 89 d6             	mov    %rdx,%rsi
  7ff6f1:	48 89 c2             	mov    %rax,%rdx
  7ff6f4:	ff 15 d6 e0 32 00    	call   *0x32e0d6(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7ff6fa:	48 8d 05 3f 8c 30 00 	lea    0x308c3f(%rip),%rax        # b08340 <anon.e1aed3256c0f336e2763058c1a348a1e.26.llvm.17407148579165845042+0x60>
  7ff701:	4c 89 cf             	mov    %r9,%rdi
  7ff704:	48 89 d6             	mov    %rdx,%rsi
  7ff707:	48 89 c2             	mov    %rax,%rdx
  7ff70a:	ff 15 c0 e0 32 00    	call   *0x32e0c0(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7ff710:	48 8d 05 99 8b 30 00 	lea    0x308b99(%rip),%rax        # b082b0 <anon.e1aed3256c0f336e2763058c1a348a1e.18.llvm.17407148579165845042+0x60>
  7ff717:	4c 89 cf             	mov    %r9,%rdi
  7ff71a:	48 89 d6             	mov    %rdx,%rsi
  7ff71d:	48 89 c2             	mov    %rax,%rdx
  7ff720:	ff 15 aa e0 32 00    	call   *0x32e0aa(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7ff726:	48 8d 05 ab 8a 30 00 	lea    0x308aab(%rip),%rax        # b081d8 <anon.e1aed3256c0f336e2763058c1a348a1e.9.llvm.17407148579165845042+0x18>
  7ff72d:	48 89 d6             	mov    %rdx,%rsi
  7ff730:	48 89 c2             	mov    %rax,%rdx
  7ff733:	ff 15 97 e0 32 00    	call   *0x32e097(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
