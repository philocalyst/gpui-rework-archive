
/tmp/gpui-caret-transaction-bin/d54-caret-pair-measure:     file format elf64-x86-64


Disassembly of section .text:

0000000000669620 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>>:
  669620:	50                   	push   %rax
  669621:	48 8b 07             	mov    (%rdi),%rax
  669624:	4c 8b 47 08          	mov    0x8(%rdi),%r8
  669628:	4c 39 c0             	cmp    %r8,%rax
  66962b:	0f 84 ca 00 00 00    	je     6696fb <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0xdb>
  669631:	4c 8b 4f 10          	mov    0x10(%rdi),%r9
  669635:	4c 8b 57 18          	mov    0x18(%rdi),%r10
  669639:	4c 8b 1a             	mov    (%rdx),%r11
  66963c:	49 8d 51 01          	lea    0x1(%r9),%rdx
  669640:	48 83 c0 28          	add    $0x28,%rax
  669644:	eb 1a                	jmp    669660 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0x40>
  669646:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  66964d:	00 00 00 
  669650:	48 ff c2             	inc    %rdx
  669653:	48 8d 41 28          	lea    0x28(%rcx),%rax
  669657:	4c 39 c1             	cmp    %r8,%rcx
  66965a:	0f 84 aa 00 00 00    	je     66970a <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0xea>
  669660:	48 89 c1             	mov    %rax,%rcx
  669663:	48 8b 40 e8          	mov    -0x18(%rax),%rax
  669667:	80 79 f9 01          	cmpb   $0x1,-0x7(%rcx)
  66966b:	75 23                	jne    669690 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0x70>
  66966d:	49 8b 72 40          	mov    0x40(%r10),%rsi
  669671:	48 39 f0             	cmp    %rsi,%rax
  669674:	0f 83 ae 00 00 00    	jae    669728 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0x108>
  66967a:	49 ff c1             	inc    %r9
  66967d:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  669681:	eb cd                	jmp    669650 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0x30>
  669683:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  66968a:	84 00 00 00 00 00 
  669690:	49 8b 72 58          	mov    0x58(%r10),%rsi
  669694:	48 39 f0             	cmp    %rsi,%rax
  669697:	0f 83 9e 00 00 00    	jae    66973b <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0x11b>
  66969d:	49 8b b2 e8 00 00 00 	mov    0xe8(%r10),%rsi
  6696a4:	48 39 f0             	cmp    %rsi,%rax
  6696a7:	0f 83 a1 00 00 00    	jae    66974e <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0x12e>
  6696ad:	49 8b 72 50          	mov    0x50(%r10),%rsi
  6696b1:	48 8d 04 c0          	lea    (%rax,%rax,8),%rax
  6696b5:	48 c1 e0 04          	shl    $0x4,%rax
  6696b9:	f6 84 06 8c 00 00 00 	testb  $0x1,0x8c(%rsi,%rax,1)
  6696c0:	01 
  6696c1:	75 3c                	jne    6696ff <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0xdf>
  6696c3:	48 01 c6             	add    %rax,%rsi
  6696c6:	48 8b 46 40          	mov    0x40(%rsi),%rax
  6696ca:	49 3b 82 b8 00 00 00 	cmp    0xb8(%r10),%rax
  6696d1:	73 45                	jae    669718 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0xf8>
  6696d3:	41 80 3b 00          	cmpb   $0x0,(%r11)
  6696d7:	74 26                	je     6696ff <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0xdf>
  6696d9:	49 8b b2 b0 00 00 00 	mov    0xb0(%r10),%rsi
  6696e0:	48 c1 e0 06          	shl    $0x6,%rax
  6696e4:	48 8b 44 06 10       	mov    0x10(%rsi,%rax,1),%rax
  6696e9:	49 3b 43 08          	cmp    0x8(%r11),%rax
  6696ed:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  6696f1:	75 1e                	jne    669711 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0xf1>
  6696f3:	49 ff c1             	inc    %r9
  6696f6:	e9 55 ff ff ff       	jmp    669650 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>+0x30>
  6696fb:	31 c0                	xor    %eax,%eax
  6696fd:	59                   	pop    %rcx
  6696fe:	c3                   	ret
  6696ff:	48 89 0f             	mov    %rcx,(%rdi)
  669702:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  669706:	b0 01                	mov    $0x1,%al
  669708:	59                   	pop    %rcx
  669709:	c3                   	ret
  66970a:	31 c0                	xor    %eax,%eax
  66970c:	48 89 0f             	mov    %rcx,(%rdi)
  66970f:	59                   	pop    %rcx
  669710:	c3                   	ret
  669711:	b0 01                	mov    $0x1,%al
  669713:	48 89 0f             	mov    %rcx,(%rdi)
  669716:	59                   	pop    %rcx
  669717:	c3                   	ret
  669718:	48 89 0f             	mov    %rcx,(%rdi)
  66971b:	48 8d 3d 6e 5d 11 00 	lea    0x115d6e(%rip),%rdi        # 77f490 <anon.d4a86088305c8823b863e6abd2e38045.33.llvm.4134324091787671213>
  669722:	ff 15 28 fa 11 00    	call   *0x11fa28(%rip)        # 789150 <_DYNAMIC+0x338>
  669728:	48 89 0f             	mov    %rcx,(%rdi)
  66972b:	48 8d 15 ce 4c 11 00 	lea    0x114cce(%rip),%rdx        # 77e400 <anon.28dd019c8af4b6db257042fc7d608c44.15.llvm.15465176189207414649>
  669732:	48 89 c7             	mov    %rax,%rdi
  669735:	ff 15 3d fa 11 00    	call   *0x11fa3d(%rip)        # 789178 <_DYNAMIC+0x360>
  66973b:	48 89 0f             	mov    %rcx,(%rdi)
  66973e:	48 8d 15 8b 4c 11 00 	lea    0x114c8b(%rip),%rdx        # 77e3d0 <anon.28dd019c8af4b6db257042fc7d608c44.13.llvm.15465176189207414649>
  669745:	48 89 c7             	mov    %rax,%rdi
  669748:	ff 15 2a fa 11 00    	call   *0x11fa2a(%rip)        # 789178 <_DYNAMIC+0x360>
  66974e:	48 89 0f             	mov    %rcx,(%rdi)
  669751:	48 8d 15 90 4c 11 00 	lea    0x114c90(%rip),%rdx        # 77e3e8 <anon.28dd019c8af4b6db257042fc7d608c44.14.llvm.15465176189207414649>
  669758:	48 89 c7             	mov    %rax,%rdi
  66975b:	ff 15 17 fa 11 00    	call   *0x11fa17(%rip)        # 789178 <_DYNAMIC+0x360>
