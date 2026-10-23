
/tmp/gpui-caret-transaction-bin/d54-caret-pair-measure:     file format elf64-x86-64


Disassembly of section .text:

0000000000669f80 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut>:
  669f80:	55                   	push   %rbp
  669f81:	41 57                	push   %r15
  669f83:	41 56                	push   %r14
  669f85:	41 55                	push   %r13
  669f87:	41 54                	push   %r12
  669f89:	53                   	push   %rbx
  669f8a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  669f91:	48 8b 02             	mov    (%rdx),%rax
  669f94:	48 85 c0             	test   %rax,%rax
  669f97:	0f 84 f9 02 00 00    	je     66a296 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x316>
  669f9d:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  669fa2:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  669fa9:	00 
  669faa:	0f 10 42 08          	movups 0x8(%rdx),%xmm0
  669fae:	0f 10 4a 18          	movups 0x18(%rdx),%xmm1
  669fb2:	0f 10 52 28          	movups 0x28(%rdx),%xmm2
  669fb6:	0f 10 5a 38          	movups 0x38(%rdx),%xmm3
  669fba:	0f 11 84 24 d8 00 00 	movups %xmm0,0xd8(%rsp)
  669fc1:	00 
  669fc2:	0f 11 8c 24 e8 00 00 	movups %xmm1,0xe8(%rsp)
  669fc9:	00 
  669fca:	0f 11 94 24 f8 00 00 	movups %xmm2,0xf8(%rsp)
  669fd1:	00 
  669fd2:	0f 11 9c 24 08 01 00 	movups %xmm3,0x108(%rsp)
  669fd9:	00 
  669fda:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  669fdf:	48 8d b4 24 d0 00 00 	lea    0xd0(%rsp),%rsi
  669fe6:	00 
  669fe7:	e8 54 90 01 00       	call   683040 <<parley::layout::line::GlyphRun<()>>::positioned_glyphs>
  669fec:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  669ff1:	48 8b 5c 24 38       	mov    0x38(%rsp),%rbx
  669ff6:	0f b6 4c 24 40       	movzbl 0x40(%rsp),%ecx
  669ffb:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  66a000:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  66a005:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  66a00a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  66a00f:	4c 8b 74 24 68       	mov    0x68(%rsp),%r14
  66a014:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  66a019:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  66a01e:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  66a023:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  66a02a:	00 
  66a02b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  66a030:	44 8b a4 24 88 00 00 	mov    0x88(%rsp),%r12d
  66a037:	00 
  66a038:	44 8b ac 24 8c 00 00 	mov    0x8c(%rsp),%r13d
  66a03f:	00 
  66a040:	44 8b 84 24 90 00 00 	mov    0x90(%rsp),%r8d
  66a047:	00 
  66a048:	44 8b 9c 24 94 00 00 	mov    0x94(%rsp),%r11d
  66a04f:	00 
  66a050:	0f b6 ac 24 b0 00 00 	movzbl 0xb0(%rsp),%ebp
  66a057:	00 
  66a058:	44 0f b6 bc 24 c4 00 	movzbl 0xc4(%rsp),%r15d
  66a05f:	00 00 
  66a061:	31 c0                	xor    %eax,%eax
  66a063:	eb 14                	jmp    66a079 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0xf9>
  66a065:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  66a06c:	00 00 00 00 
  66a070:	48 83 c7 10          	add    $0x10,%rdi
  66a074:	48 ff c0             	inc    %rax
  66a077:	31 c9                	xor    %ecx,%ecx
  66a079:	f6 c1 01             	test   $0x1,%cl
  66a07c:	75 f6                	jne    66a074 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0xf4>
  66a07e:	45 89 c1             	mov    %r8d,%r9d
  66a081:	48 39 df             	cmp    %rbx,%rdi
  66a084:	75 ea                	jne    66a070 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0xf0>
  66a086:	48 39 df             	cmp    %rbx,%rdi
  66a089:	0f 94 c1             	sete   %cl
  66a08c:	45 89 ca             	mov    %r9d,%r10d
  66a08f:	90                   	nop
  66a090:	41 f6 c7 01          	test   $0x1,%r15b
  66a094:	74 7a                	je     66a110 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x190>
  66a096:	45 39 da             	cmp    %r11d,%r10d
  66a099:	0f 82 8a 01 00 00    	jb     66a229 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x2a9>
  66a09f:	45 39 e2             	cmp    %r12d,%r10d
  66a0a2:	40 0f 95 c6          	setne  %sil
  66a0a6:	40 84 f5             	test   %sil,%bpl
  66a0a9:	0f 84 e0 01 00 00    	je     66a28f <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x30f>
  66a0af:	41 8d 72 ff          	lea    -0x1(%r10),%esi
  66a0b3:	48 39 f2             	cmp    %rsi,%rdx
  66a0b6:	0f 86 6c 02 00 00    	jbe    66a328 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x3a8>
  66a0bc:	44 39 e6             	cmp    %r12d,%esi
  66a0bf:	0f 86 cb 00 00 00    	jbe    66a190 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x210>
  66a0c5:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  66a0c9:	4d 8d 4e 16          	lea    0x16(%r14),%r9
  66a0cd:	4f 8d 04 c1          	lea    (%r9,%r8,8),%r8
  66a0d1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  66a0d8:	0f 1f 84 00 00 00 00 
  66a0df:	00 
  66a0e0:	48 39 f2             	cmp    %rsi,%rdx
  66a0e3:	0f 86 18 02 00 00    	jbe    66a301 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x381>
  66a0e9:	41 f6 40 01 02       	testb  $0x2,0x1(%r8)
  66a0ee:	0f 85 9c 00 00 00    	jne    66a190 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x210>
  66a0f4:	48 ff ce             	dec    %rsi
  66a0f7:	49 83 c0 e8          	add    $0xffffffffffffffe8,%r8
  66a0fb:	41 39 f4             	cmp    %esi,%r12d
  66a0fe:	72 e0                	jb     66a0e0 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x160>
  66a100:	4c 89 e6             	mov    %r12,%rsi
  66a103:	45 89 e0             	mov    %r12d,%r8d
  66a106:	e9 88 00 00 00       	jmp    66a193 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x213>
  66a10b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  66a110:	45 39 da             	cmp    %r11d,%r10d
  66a113:	0f 82 07 01 00 00    	jb     66a220 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x2a0>
  66a119:	45 39 eb             	cmp    %r13d,%r11d
  66a11c:	40 0f 95 c6          	setne  %sil
  66a120:	40 84 f5             	test   %sil,%bpl
  66a123:	0f 84 66 01 00 00    	je     66a28f <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x30f>
  66a129:	44 89 de             	mov    %r11d,%esi
  66a12c:	48 39 f2             	cmp    %rsi,%rdx
  66a12f:	0f 86 1f 02 00 00    	jbe    66a354 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x3d4>
  66a135:	45 8d 53 01          	lea    0x1(%r11),%r10d
  66a139:	45 39 ea             	cmp    %r13d,%r10d
  66a13c:	73 31                	jae    66a16f <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x1ef>
  66a13e:	45 89 d1             	mov    %r10d,%r9d
  66a141:	4f 8d 04 49          	lea    (%r9,%r9,2),%r8
  66a145:	4d 8d 56 16          	lea    0x16(%r14),%r10
  66a149:	4f 8d 04 c2          	lea    (%r10,%r8,8),%r8
  66a14d:	4d 89 ca             	mov    %r9,%r10
  66a150:	4c 39 d2             	cmp    %r10,%rdx
  66a153:	0f 86 8b 01 00 00    	jbe    66a2e4 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x364>
  66a159:	41 f6 40 01 02       	testb  $0x2,0x1(%r8)
  66a15e:	75 0f                	jne    66a16f <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x1ef>
  66a160:	49 ff c2             	inc    %r10
  66a163:	49 83 c0 18          	add    $0x18,%r8
  66a167:	4d 39 d5             	cmp    %r10,%r13
  66a16a:	75 e4                	jne    66a150 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x1d0>
  66a16c:	45 89 ea             	mov    %r13d,%r10d
  66a16f:	45 89 d1             	mov    %r10d,%r9d
  66a172:	49 ff c9             	dec    %r9
  66a175:	49 39 d1             	cmp    %rdx,%r9
  66a178:	0f 83 ec 01 00 00    	jae    66a36a <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x3ea>
  66a17e:	45 89 d8             	mov    %r11d,%r8d
  66a181:	eb 28                	jmp    66a1ab <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x22b>
  66a183:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  66a18a:	84 00 00 00 00 00 
  66a190:	41 89 f0             	mov    %esi,%r8d
  66a193:	48 39 f2             	cmp    %rsi,%rdx
  66a196:	0f 86 a2 01 00 00    	jbe    66a33e <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x3be>
  66a19c:	45 89 d1             	mov    %r10d,%r9d
  66a19f:	49 ff c9             	dec    %r9
  66a1a2:	49 39 d1             	cmp    %rdx,%r9
  66a1a5:	0f 83 d5 01 00 00    	jae    66a380 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x400>
  66a1ab:	45 89 d3             	mov    %r10d,%r11d
  66a1ae:	48 83 7c 24 28 00    	cmpq   $0x0,0x28(%rsp)
  66a1b4:	0f 84 d5 00 00 00    	je     66a28f <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x30f>
  66a1ba:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  66a1be:	45 8b 14 f6          	mov    (%r14,%rsi,8),%r10d
  66a1c2:	4b 8d 34 49          	lea    (%r9,%r9,2),%rsi
  66a1c6:	41 8b 74 f6 04       	mov    0x4(%r14,%rsi,8),%esi
  66a1cb:	44 39 d6             	cmp    %r10d,%esi
  66a1ce:	0f 82 d9 00 00 00    	jb     66a2ad <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x32d>
  66a1d4:	48 39 74 24 10       	cmp    %rsi,0x10(%rsp)
  66a1d9:	0f 82 ce 00 00 00    	jb     66a2ad <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x32d>
  66a1df:	44 39 d6             	cmp    %r10d,%esi
  66a1e2:	0f 84 2f 01 00 00    	je     66a317 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x397>
  66a1e8:	44 89 de             	mov    %r11d,%esi
  66a1eb:	48 39 f2             	cmp    %rsi,%rdx
  66a1ee:	41 0f 92 c1          	setb   %r9b
  66a1f2:	45 39 c3             	cmp    %r8d,%r11d
  66a1f5:	72 1c                	jb     66a213 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x293>
  66a1f7:	45 84 c9             	test   %r9b,%r9b
  66a1fa:	0f 85 c2 00 00 00    	jne    66a2c2 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x342>
  66a200:	45 89 c2             	mov    %r8d,%r10d
  66a203:	f6 c1 01             	test   $0x1,%cl
  66a206:	b1 01                	mov    $0x1,%cl
  66a208:	0f 85 82 fe ff ff    	jne    66a090 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x110>
  66a20e:	e9 5d fe ff ff       	jmp    66a070 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0xf0>
  66a213:	41 b1 01             	mov    $0x1,%r9b
  66a216:	45 84 c9             	test   %r9b,%r9b
  66a219:	74 e5                	je     66a200 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x280>
  66a21b:	e9 a2 00 00 00       	jmp    66a2c2 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x342>
  66a220:	45 8d 42 01          	lea    0x1(%r10),%r8d
  66a224:	45 89 c1             	mov    %r8d,%r9d
  66a227:	eb 09                	jmp    66a232 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x2b2>
  66a229:	41 ff cb             	dec    %r11d
  66a22c:	45 89 d1             	mov    %r10d,%r9d
  66a22f:	45 89 da             	mov    %r11d,%r10d
  66a232:	44 89 d7             	mov    %r10d,%edi
  66a235:	48 39 fa             	cmp    %rdi,%rdx
  66a238:	0f 86 58 01 00 00    	jbe    66a396 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x416>
  66a23e:	48 8d 0c 7f          	lea    (%rdi,%rdi,2),%rcx
  66a242:	41 f6 44 ce 17 01    	testb  $0x1,0x17(%r14,%rcx,8)
  66a248:	75 36                	jne    66a280 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x300>
  66a24a:	49 8d 0c ce          	lea    (%r14,%rcx,8),%rcx
  66a24e:	8b 79 08             	mov    0x8(%rcx),%edi
  66a251:	8b 49 0c             	mov    0xc(%rcx),%ecx
  66a254:	48 8d 34 39          	lea    (%rcx,%rdi,1),%rsi
  66a258:	48 3b 74 24 08       	cmp    0x8(%rsp),%rsi
  66a25d:	77 73                	ja     66a2d2 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x352>
  66a25f:	48 c1 e7 04          	shl    $0x4,%rdi
  66a263:	48 03 7c 24 18       	add    0x18(%rsp),%rdi
  66a268:	48 89 cb             	mov    %rcx,%rbx
  66a26b:	48 c1 e3 04          	shl    $0x4,%rbx
  66a26f:	48 01 fb             	add    %rdi,%rbx
  66a272:	48 85 c9             	test   %rcx,%rcx
  66a275:	0f 84 0b fe ff ff    	je     66a086 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x106>
  66a27b:	e9 f0 fd ff ff       	jmp    66a070 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0xf0>
  66a280:	bb 04 00 00 00       	mov    $0x4,%ebx
  66a285:	bf 04 00 00 00       	mov    $0x4,%edi
  66a28a:	e9 e5 fd ff ff       	jmp    66a074 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0xf4>
  66a28f:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  66a294:	eb 02                	jmp    66a298 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut+0x318>
  66a296:	31 c0                	xor    %eax,%eax
  66a298:	48 01 f0             	add    %rsi,%rax
  66a29b:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  66a2a2:	5b                   	pop    %rbx
  66a2a3:	41 5c                	pop    %r12
  66a2a5:	41 5d                	pop    %r13
  66a2a7:	41 5e                	pop    %r14
  66a2a9:	41 5f                	pop    %r15
  66a2ab:	5d                   	pop    %rbp
  66a2ac:	c3                   	ret
  66a2ad:	48 8d 0d 44 43 11 00 	lea    0x114344(%rip),%rcx        # 77e5f8 <anon.28dd019c8af4b6db257042fc7d608c44.15.llvm.15465176189207414649+0x1f8>
  66a2b4:	4c 89 d7             	mov    %r10,%rdi
  66a2b7:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  66a2bc:	ff 15 ae f0 11 00    	call   *0x11f0ae(%rip)        # 789370 <_DYNAMIC+0x558>
  66a2c2:	44 89 c7             	mov    %r8d,%edi
  66a2c5:	48 8d 0d 5c 43 11 00 	lea    0x11435c(%rip),%rcx        # 77e628 <anon.28dd019c8af4b6db257042fc7d608c44.15.llvm.15465176189207414649+0x228>
  66a2cc:	ff 15 9e f0 11 00    	call   *0x11f09e(%rip)        # 789370 <_DYNAMIC+0x558>
  66a2d2:	48 8d 0d e7 41 11 00 	lea    0x1141e7(%rip),%rcx        # 77e4c0 <anon.28dd019c8af4b6db257042fc7d608c44.15.llvm.15465176189207414649+0xc0>
  66a2d9:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  66a2de:	ff 15 8c f0 11 00    	call   *0x11f08c(%rip)        # 789370 <_DYNAMIC+0x558>
  66a2e4:	4c 39 ca             	cmp    %r9,%rdx
  66a2e7:	4c 0f 47 ca          	cmova  %rdx,%r9
  66a2eb:	48 8d 05 66 43 11 00 	lea    0x114366(%rip),%rax        # 77e658 <anon.28dd019c8af4b6db257042fc7d608c44.15.llvm.15465176189207414649+0x258>
  66a2f2:	4c 89 cf             	mov    %r9,%rdi
  66a2f5:	48 89 d6             	mov    %rdx,%rsi
  66a2f8:	48 89 c2             	mov    %rax,%rdx
  66a2fb:	ff 15 77 ee 11 00    	call   *0x11ee77(%rip)        # 789178 <_DYNAMIC+0x360>
  66a301:	48 8d 05 90 42 11 00 	lea    0x114290(%rip),%rax        # 77e598 <anon.28dd019c8af4b6db257042fc7d608c44.15.llvm.15465176189207414649+0x198>
  66a308:	48 89 f7             	mov    %rsi,%rdi
  66a30b:	48 89 d6             	mov    %rdx,%rsi
  66a30e:	48 89 c2             	mov    %rax,%rdx
  66a311:	ff 15 61 ee 11 00    	call   *0x11ee61(%rip)        # 789178 <_DYNAMIC+0x360>
  66a317:	48 8d 15 c2 42 11 00 	lea    0x1142c2(%rip),%rdx        # 77e5e0 <anon.28dd019c8af4b6db257042fc7d608c44.15.llvm.15465176189207414649+0x1e0>
  66a31e:	31 ff                	xor    %edi,%edi
  66a320:	31 f6                	xor    %esi,%esi
  66a322:	ff 15 50 ee 11 00    	call   *0x11ee50(%rip)        # 789178 <_DYNAMIC+0x360>
  66a328:	48 8d 05 51 42 11 00 	lea    0x114251(%rip),%rax        # 77e580 <anon.28dd019c8af4b6db257042fc7d608c44.15.llvm.15465176189207414649+0x180>
  66a32f:	48 89 f7             	mov    %rsi,%rdi
  66a332:	48 89 d6             	mov    %rdx,%rsi
  66a335:	48 89 c2             	mov    %rax,%rdx
  66a338:	ff 15 3a ee 11 00    	call   *0x11ee3a(%rip)        # 789178 <_DYNAMIC+0x360>
  66a33e:	48 8d 05 6b 42 11 00 	lea    0x11426b(%rip),%rax        # 77e5b0 <anon.28dd019c8af4b6db257042fc7d608c44.15.llvm.15465176189207414649+0x1b0>
  66a345:	48 89 f7             	mov    %rsi,%rdi
  66a348:	48 89 d6             	mov    %rdx,%rsi
  66a34b:	48 89 c2             	mov    %rax,%rdx
  66a34e:	ff 15 24 ee 11 00    	call   *0x11ee24(%rip)        # 789178 <_DYNAMIC+0x360>
  66a354:	48 8d 05 e5 42 11 00 	lea    0x1142e5(%rip),%rax        # 77e640 <anon.28dd019c8af4b6db257042fc7d608c44.15.llvm.15465176189207414649+0x240>
  66a35b:	48 89 f7             	mov    %rsi,%rdi
  66a35e:	48 89 d6             	mov    %rdx,%rsi
  66a361:	48 89 c2             	mov    %rax,%rdx
  66a364:	ff 15 0e ee 11 00    	call   *0x11ee0e(%rip)        # 789178 <_DYNAMIC+0x360>
  66a36a:	48 8d 05 ff 42 11 00 	lea    0x1142ff(%rip),%rax        # 77e670 <anon.28dd019c8af4b6db257042fc7d608c44.15.llvm.15465176189207414649+0x270>
  66a371:	4c 89 cf             	mov    %r9,%rdi
  66a374:	48 89 d6             	mov    %rdx,%rsi
  66a377:	48 89 c2             	mov    %rax,%rdx
  66a37a:	ff 15 f8 ed 11 00    	call   *0x11edf8(%rip)        # 789178 <_DYNAMIC+0x360>
  66a380:	48 8d 05 41 42 11 00 	lea    0x114241(%rip),%rax        # 77e5c8 <anon.28dd019c8af4b6db257042fc7d608c44.15.llvm.15465176189207414649+0x1c8>
  66a387:	4c 89 cf             	mov    %r9,%rdi
  66a38a:	48 89 d6             	mov    %rdx,%rsi
  66a38d:	48 89 c2             	mov    %rax,%rdx
  66a390:	ff 15 e2 ed 11 00    	call   *0x11ede2(%rip)        # 789178 <_DYNAMIC+0x360>
  66a396:	48 8d 05 0b 41 11 00 	lea    0x11410b(%rip),%rax        # 77e4a8 <anon.28dd019c8af4b6db257042fc7d608c44.15.llvm.15465176189207414649+0xa8>
  66a39d:	48 89 d6             	mov    %rdx,%rsi
  66a3a0:	48 89 c2             	mov    %rax,%rdx
  66a3a3:	ff 15 cf ed 11 00    	call   *0x11edcf(%rip)        # 789178 <_DYNAMIC+0x360>
