
/tmp/gpui-caret-transaction-bin/62e-native-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007fe5c0 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>>:
  7fe5c0:	50                   	push   %rax
  7fe5c1:	48 8b 07             	mov    (%rdi),%rax
  7fe5c4:	4c 8b 47 08          	mov    0x8(%rdi),%r8
  7fe5c8:	4c 39 c0             	cmp    %r8,%rax
  7fe5cb:	0f 84 ca 00 00 00    	je     7fe69b <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0xdb>
  7fe5d1:	4c 8b 4f 10          	mov    0x10(%rdi),%r9
  7fe5d5:	4c 8b 57 18          	mov    0x18(%rdi),%r10
  7fe5d9:	4c 8b 1a             	mov    (%rdx),%r11
  7fe5dc:	49 8d 51 01          	lea    0x1(%r9),%rdx
  7fe5e0:	48 83 c0 28          	add    $0x28,%rax
  7fe5e4:	eb 1a                	jmp    7fe600 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0x40>
  7fe5e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  7fe5ed:	00 00 00 
  7fe5f0:	48 ff c2             	inc    %rdx
  7fe5f3:	48 8d 41 28          	lea    0x28(%rcx),%rax
  7fe5f7:	4c 39 c1             	cmp    %r8,%rcx
  7fe5fa:	0f 84 aa 00 00 00    	je     7fe6aa <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0xea>
  7fe600:	48 89 c1             	mov    %rax,%rcx
  7fe603:	48 8b 40 e8          	mov    -0x18(%rax),%rax
  7fe607:	80 79 f9 01          	cmpb   $0x1,-0x7(%rcx)
  7fe60b:	75 23                	jne    7fe630 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0x70>
  7fe60d:	49 8b 72 40          	mov    0x40(%r10),%rsi
  7fe611:	48 39 f0             	cmp    %rsi,%rax
  7fe614:	0f 83 ae 00 00 00    	jae    7fe6c8 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0x108>
  7fe61a:	49 ff c1             	inc    %r9
  7fe61d:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  7fe621:	eb cd                	jmp    7fe5f0 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0x30>
  7fe623:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  7fe62a:	84 00 00 00 00 00 
  7fe630:	49 8b 72 58          	mov    0x58(%r10),%rsi
  7fe634:	48 39 f0             	cmp    %rsi,%rax
  7fe637:	0f 83 9e 00 00 00    	jae    7fe6db <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0x11b>
  7fe63d:	49 8b b2 e8 00 00 00 	mov    0xe8(%r10),%rsi
  7fe644:	48 39 f0             	cmp    %rsi,%rax
  7fe647:	0f 83 a1 00 00 00    	jae    7fe6ee <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0x12e>
  7fe64d:	49 8b 72 50          	mov    0x50(%r10),%rsi
  7fe651:	48 8d 04 c0          	lea    (%rax,%rax,8),%rax
  7fe655:	48 c1 e0 04          	shl    $0x4,%rax
  7fe659:	f6 84 06 8c 00 00 00 	testb  $0x1,0x8c(%rsi,%rax,1)
  7fe660:	01 
  7fe661:	75 3c                	jne    7fe69f <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0xdf>
  7fe663:	48 01 c6             	add    %rax,%rsi
  7fe666:	48 8b 46 40          	mov    0x40(%rsi),%rax
  7fe66a:	49 3b 82 b8 00 00 00 	cmp    0xb8(%r10),%rax
  7fe671:	73 45                	jae    7fe6b8 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0xf8>
  7fe673:	41 80 3b 00          	cmpb   $0x0,(%r11)
  7fe677:	74 26                	je     7fe69f <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0xdf>
  7fe679:	49 8b b2 b0 00 00 00 	mov    0xb0(%r10),%rsi
  7fe680:	48 c1 e0 06          	shl    $0x6,%rax
  7fe684:	48 8b 44 06 10       	mov    0x10(%rsi,%rax,1),%rax
  7fe689:	49 3b 43 08          	cmp    0x8(%r11),%rax
  7fe68d:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  7fe691:	75 1e                	jne    7fe6b1 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0xf1>
  7fe693:	49 ff c1             	inc    %r9
  7fe696:	e9 55 ff ff ff       	jmp    7fe5f0 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0x30>
  7fe69b:	31 c0                	xor    %eax,%eax
  7fe69d:	59                   	pop    %rcx
  7fe69e:	c3                   	ret
  7fe69f:	48 89 0f             	mov    %rcx,(%rdi)
  7fe6a2:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  7fe6a6:	b0 01                	mov    $0x1,%al
  7fe6a8:	59                   	pop    %rcx
  7fe6a9:	c3                   	ret
  7fe6aa:	31 c0                	xor    %eax,%eax
  7fe6ac:	48 89 0f             	mov    %rcx,(%rdi)
  7fe6af:	59                   	pop    %rcx
  7fe6b0:	c3                   	ret
  7fe6b1:	b0 01                	mov    $0x1,%al
  7fe6b3:	48 89 0f             	mov    %rcx,(%rdi)
  7fe6b6:	59                   	pop    %rcx
  7fe6b7:	c3                   	ret
  7fe6b8:	48 89 0f             	mov    %rcx,(%rdi)
  7fe6bb:	48 8d 3d 8e 98 30 00 	lea    0x30988e(%rip),%rdi        # b07f50 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.38.llvm.14379316919819170204>
  7fe6c2:	ff 15 c0 f0 32 00    	call   *0x32f0c0(%rip)        # b2d788 <_DYNAMIC+0x288>
  7fe6c8:	48 89 0f             	mov    %rcx,(%rdi)
  7fe6cb:	48 8d 15 ee 9a 30 00 	lea    0x309aee(%rip),%rdx        # b081c0 <anon.e1aed3256c0f336e2763058c1a348a1e.9.llvm.17407148579165845042>
  7fe6d2:	48 89 c7             	mov    %rax,%rdi
  7fe6d5:	ff 15 f5 f0 32 00    	call   *0x32f0f5(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fe6db:	48 89 0f             	mov    %rcx,(%rdi)
  7fe6de:	48 8d 15 ab 9a 30 00 	lea    0x309aab(%rip),%rdx        # b08190 <anon.e1aed3256c0f336e2763058c1a348a1e.7.llvm.17407148579165845042>
  7fe6e5:	48 89 c7             	mov    %rax,%rdi
  7fe6e8:	ff 15 e2 f0 32 00    	call   *0x32f0e2(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7fe6ee:	48 89 0f             	mov    %rcx,(%rdi)
  7fe6f1:	48 8d 15 b0 9a 30 00 	lea    0x309ab0(%rip),%rdx        # b081a8 <anon.e1aed3256c0f336e2763058c1a348a1e.8.llvm.17407148579165845042>
  7fe6f8:	48 89 c7             	mov    %rax,%rdi
  7fe6fb:	ff 15 cf f0 32 00    	call   *0x32f0cf(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
