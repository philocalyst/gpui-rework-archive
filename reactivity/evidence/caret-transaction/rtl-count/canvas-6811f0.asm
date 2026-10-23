
/tmp/gpui-caret-transaction-bin/d54-caret-pair-measure:     file format elf64-x86-64


Disassembly of section .text:

00000000006811f0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>>:
  6811f0:	55                   	push   %rbp
  6811f1:	41 57                	push   %r15
  6811f3:	41 56                	push   %r14
  6811f5:	41 55                	push   %r13
  6811f7:	41 54                	push   %r12
  6811f9:	53                   	push   %rbx
  6811fa:	48 81 ec 88 02 00 00 	sub    $0x288,%rsp
  681201:	48 89 d3             	mov    %rdx,%rbx
  681204:	89 f2                	mov    %esi,%edx
  681206:	48 89 fe             	mov    %rdi,%rsi
  681209:	4c 8d b4 24 78 01 00 	lea    0x178(%rsp),%r14
  681210:	00 
  681211:	4c 89 f7             	mov    %r14,%rdi
  681214:	e8 f7 20 00 00       	call   683310 <<parley::layout::run::Clusters<()>>::new>
  681219:	48 8b 03             	mov    (%rbx),%rax
  68121c:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  681223:	00 
  681224:	48 8b 43 08          	mov    0x8(%rbx),%rax
  681228:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  68122d:	48 8b 43 18          	mov    0x18(%rbx),%rax
  681231:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  681238:	00 
  681239:	48 8b 43 10          	mov    0x10(%rbx),%rax
  68123d:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  681242:	48 8b 43 20          	mov    0x20(%rbx),%rax
  681246:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  68124d:	00 
  68124e:	48 8b 6b 28          	mov    0x28(%rbx),%rbp
  681252:	48 8b 43 30          	mov    0x30(%rbx),%rax
  681256:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  68125b:	4c 8b 6b 40          	mov    0x40(%rbx),%r13
  68125f:	4c 8b 7b 48          	mov    0x48(%rbx),%r15
  681263:	48 8b 43 50          	mov    0x50(%rbx),%rax
  681267:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  68126c:	4c 8b 63 78          	mov    0x78(%rbx),%r12
  681270:	48 8b 83 80 00 00 00 	mov    0x80(%rbx),%rax
  681277:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  68127c:	48 8b 43 38          	mov    0x38(%rbx),%rax
  681280:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  681285:	48 8b 43 60          	mov    0x60(%rbx),%rax
  681289:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  68128e:	48 8b 43 68          	mov    0x68(%rbx),%rax
  681292:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  681297:	48 8b 43 70          	mov    0x70(%rbx),%rax
  68129b:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6812a0:	48 8b 43 58          	mov    0x58(%rbx),%rax
  6812a4:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  6812ab:	00 
  6812ac:	48 8d bc 24 f4 00 00 	lea    0xf4(%rsp),%rdi
  6812b3:	00 
  6812b4:	4c 89 f6             	mov    %r14,%rsi
  6812b7:	e8 44 23 00 00       	call   683600 <<parley::layout::run::Clusters<()>>::advance_cursor>
  6812bc:	b0 02                	mov    $0x2,%al
  6812be:	83 bc 24 f4 00 00 00 	cmpl   $0x1,0xf4(%rsp)
  6812c5:	01 
  6812c6:	0f 85 b4 05 00 00    	jne    681880 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x690>
  6812cc:	4c 89 e3             	mov    %r12,%rbx
  6812cf:	49 8d 44 24 04       	lea    0x4(%r12),%rax
  6812d4:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6812d9:	4c 8d a4 24 30 01 00 	lea    0x130(%rsp),%r12
  6812e0:	00 
  6812e1:	48 89 ac 24 98 00 00 	mov    %rbp,0x98(%rsp)
  6812e8:	00 
  6812e9:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
  6812ee:	eb 2e                	jmp    68131e <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x12e>
  6812f0:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6812f5:	c6 00 00             	movb   $0x0,(%rax)
  6812f8:	48 8d bc 24 f4 00 00 	lea    0xf4(%rsp),%rdi
  6812ff:	00 
  681300:	4c 8d b4 24 78 01 00 	lea    0x178(%rsp),%r14
  681307:	00 
  681308:	4c 89 f6             	mov    %r14,%rsi
  68130b:	e8 f0 22 00 00       	call   683600 <<parley::layout::run::Clusters<()>>::advance_cursor>
  681310:	80 bc 24 f4 00 00 00 	cmpb   $0x0,0xf4(%rsp)
  681317:	00 
  681318:	0f 84 60 05 00 00    	je     68187e <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68e>
  68131e:	48 83 bc 24 30 02 00 	cmpq   $0x0,0x230(%rsp)
  681325:	00 00 
  681327:	0f 84 65 05 00 00    	je     681892 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x6a2>
  68132d:	4c 89 b4 24 08 01 00 	mov    %r14,0x108(%rsp)
  681334:	00 
  681335:	48 8d 84 24 30 02 00 	lea    0x230(%rsp),%rax
  68133c:	00 
  68133d:	48 89 84 24 10 01 00 	mov    %rax,0x110(%rsp)
  681344:	00 
  681345:	48 8d 84 24 f8 00 00 	lea    0xf8(%rsp),%rax
  68134c:	00 
  68134d:	0f 10 00             	movups (%rax),%xmm0
  681350:	48 8d 84 24 18 01 00 	lea    0x118(%rsp),%rax
  681357:	00 
  681358:	0f 11 00             	movups %xmm0,(%rax)
  68135b:	8b 9c 24 18 01 00 00 	mov    0x118(%rsp),%ebx
  681362:	8b 94 24 1c 01 00 00 	mov    0x11c(%rsp),%edx
  681369:	48 8b bc 24 90 00 00 	mov    0x90(%rsp),%rdi
  681370:	00 
  681371:	89 de                	mov    %ebx,%esi
  681373:	ff 15 07 80 10 00    	call   *0x108007(%rip)        # 789380 <_DYNAMIC+0x568>
  681379:	49 89 c6             	mov    %rax,%r14
  68137c:	49 89 d0             	mov    %rdx,%r8
  68137f:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  681384:	48 8b 80 50 01 00 00 	mov    0x150(%rax),%rax
  68138b:	48 85 c0             	test   %rax,%rax
  68138e:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  681395:	00 
  681396:	74 37                	je     6813cf <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x1df>
  681398:	4d 39 c6             	cmp    %r8,%r14
  68139b:	0f 87 d9 04 00 00    	ja     68187a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68a>
  6813a1:	49 39 c0             	cmp    %rax,%r8
  6813a4:	0f 87 d0 04 00 00    	ja     68187a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68a>
  6813aa:	4d 39 c6             	cmp    %r8,%r14
  6813ad:	73 31                	jae    6813e0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x1f0>
  6813af:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6813b4:	4c 3b 30             	cmp    (%rax),%r14
  6813b7:	0f 82 bd 04 00 00    	jb     68187a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68a>
  6813bd:	83 7a 04 00          	cmpl   $0x0,0x4(%rdx)
  6813c1:	0f 85 b3 04 00 00    	jne    68187a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68a>
  6813c7:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6813cc:	4c 89 00             	mov    %r8,(%rax)
  6813cf:	48 8b 02             	mov    (%rdx),%rax
  6813d2:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6813d6:	75 18                	jne    6813f0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x200>
  6813d8:	e9 9d 04 00 00       	jmp    68187a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68a>
  6813dd:	0f 1f 00             	nopl   (%rax)
  6813e0:	48 8b 02             	mov    (%rdx),%rax
  6813e3:	48 89 c1             	mov    %rax,%rcx
  6813e6:	48 c1 e9 20          	shr    $0x20,%rcx
  6813ea:	0f 85 8a 04 00 00    	jne    68187a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68a>
  6813f0:	48 ff c0             	inc    %rax
  6813f3:	48 89 02             	mov    %rax,(%rdx)
  6813f6:	48 8b 84 24 80 01 00 	mov    0x180(%rsp),%rax
  6813fd:	00 
  6813fe:	0f b6 80 8c 00 00 00 	movzbl 0x8c(%rax),%eax
  681405:	88 44 24 03          	mov    %al,0x3(%rsp)
  681409:	a8 01                	test   $0x1,%al
  68140b:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
  681410:	75 5e                	jne    681470 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x280>
  681412:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  681417:	f3 0f 10 00          	movss  (%rax),%xmm0
  68141b:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  681421:	48 83 bc 24 90 01 00 	cmpq   $0x0,0x190(%rsp)
  681428:	00 00 
  68142a:	0f 84 80 00 00 00    	je     6814b0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x2c0>
  681430:	48 8b 84 24 78 01 00 	mov    0x178(%rsp),%rax
  681437:	00 
  681438:	8b bc 24 98 01 00 00 	mov    0x198(%rsp),%edi
  68143f:	48 8b b0 18 01 00 00 	mov    0x118(%rax),%rsi
  681446:	48 39 fe             	cmp    %rdi,%rsi
  681449:	0f 86 69 04 00 00    	jbe    6818b8 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x6c8>
  68144f:	48 8b 80 10 01 00 00 	mov    0x110(%rax),%rax
  681456:	48 6b cf 70          	imul   $0x70,%rdi,%rcx
  68145a:	f3 0f 10 44 08 50    	movss  0x50(%rax,%rcx,1),%xmm0
  681460:	8b 44 08 54          	mov    0x54(%rax,%rcx,1),%eax
  681464:	eb 52                	jmp    6814b8 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x2c8>
  681466:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  68146d:	00 00 00 
  681470:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  681477:	00 
  681478:	48 8b 71 10          	mov    0x10(%rcx),%rsi
  68147c:	48 8b 45 00          	mov    0x0(%rbp),%rax
  681480:	48 89 c7             	mov    %rax,%rdi
  681483:	48 f7 d7             	not    %rdi
  681486:	48 01 f7             	add    %rsi,%rdi
  681489:	0f 83 1c 04 00 00    	jae    6818ab <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x6bb>
  68148f:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  681493:	f3 0f 10 04 b9       	movss  (%rcx,%rdi,4),%xmm0
  681498:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  68149e:	48 ff c0             	inc    %rax
  6814a1:	48 89 45 00          	mov    %rax,0x0(%rbp)
  6814a5:	4d 39 c6             	cmp    %r8,%r14
  6814a8:	0f 83 42 fe ff ff    	jae    6812f0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x100>
  6814ae:	eb 74                	jmp    681524 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x334>
  6814b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  6814b5:	0f 57 c0             	xorps  %xmm0,%xmm0
  6814b8:	48 8b 8c 24 88 01 00 	mov    0x188(%rsp),%rcx
  6814bf:	00 
  6814c0:	f2 0f 10 49 44       	movsd  0x44(%rcx),%xmm1
  6814c5:	f2 0f 11 8c 24 28 01 	movsd  %xmm1,0x128(%rsp)
  6814cc:	00 00 
  6814ce:	f3 0f 11 84 24 30 01 	movss  %xmm0,0x130(%rsp)
  6814d5:	00 00 
  6814d7:	89 84 24 34 01 00 00 	mov    %eax,0x134(%rsp)
  6814de:	48 8d bc 24 28 01 00 	lea    0x128(%rsp),%rdi
  6814e5:	00 
  6814e6:	48 8d b4 24 30 02 00 	lea    0x230(%rsp),%rsi
  6814ed:	00 
  6814ee:	48 8d 94 24 18 01 00 	lea    0x118(%rsp),%rdx
  6814f5:	00 
  6814f6:	31 c9                	xor    %ecx,%ecx
  6814f8:	ff 15 1a 82 10 00    	call   *0x10821a(%rip)        # 789718 <_DYNAMIC+0x900>
  6814fe:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  681503:	f3 0f 58 00          	addss  (%rax),%xmm0
  681507:	f3 0f 11 00          	movss  %xmm0,(%rax)
  68150b:	48 8b 45 00          	mov    0x0(%rbp),%rax
  68150f:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  681514:	48 ff c0             	inc    %rax
  681517:	48 89 45 00          	mov    %rax,0x0(%rbp)
  68151b:	4d 39 c6             	cmp    %r8,%r14
  68151e:	0f 83 cc fd ff ff    	jae    6812f0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x100>
  681524:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  681529:	48 83 b8 50 01 00 00 	cmpq   $0x0,0x150(%rax)
  681530:	00 
  681531:	0f 84 b9 fd ff ff    	je     6812f0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x100>
  681537:	48 8b 84 24 98 01 00 	mov    0x198(%rsp),%rax
  68153e:	00 
  68153f:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  681544:	89 5c 24 70          	mov    %ebx,0x70(%rsp)
  681548:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  68154e:	f3 0f 11 44 24 74    	movss  %xmm0,0x74(%rsp)
  681554:	0f b7 84 24 24 01 00 	movzwl 0x124(%rsp),%eax
  68155b:	00 
  68155c:	83 e0 0e             	and    $0xe,%eax
  68155f:	89 44 24 14          	mov    %eax,0x14(%rsp)
  681563:	eb 13                	jmp    681578 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x388>
  681565:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  68156c:	00 00 00 00 
  681570:	48 8b ac 24 98 00 00 	mov    0x98(%rsp),%rbp
  681577:	00 
  681578:	49 8b 45 00          	mov    0x0(%r13),%rax
  68157c:	48 83 f8 02          	cmp    $0x2,%rax
  681580:	75 16                	jne    681598 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x3a8>
  681582:	49 8d 7d 10          	lea    0x10(%r13),%rdi
  681586:	e8 05 30 ff ff       	call   674590 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  68158b:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  681590:	49 89 45 00          	mov    %rax,0x0(%r13)
  681594:	49 89 55 08          	mov    %rdx,0x8(%r13)
  681598:	48 83 f8 01          	cmp    $0x1,%rax
  68159c:	0f 85 8e 02 00 00    	jne    681830 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x640>
  6815a2:	49 8b 5d 08          	mov    0x8(%r13),%rbx
  6815a6:	4c 39 c3             	cmp    %r8,%rbx
  6815a9:	0f 83 81 02 00 00    	jae    681830 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x640>
  6815af:	41 80 3f 00          	cmpb   $0x0,(%r15)
  6815b3:	74 0a                	je     6815bf <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x3cf>
  6815b5:	49 3b 5f 08          	cmp    0x8(%r15),%rbx
  6815b9:	0f 82 bb 02 00 00    	jb     68187a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68a>
  6815bf:	49 c7 45 00 02 00 00 	movq   $0x2,0x0(%r13)
  6815c6:	00 
  6815c7:	49 c7 07 01 00 00 00 	movq   $0x1,(%r15)
  6815ce:	49 89 5f 08          	mov    %rbx,0x8(%r15)
  6815d2:	4c 39 f3             	cmp    %r14,%rbx
  6815d5:	75 79                	jne    681650 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x460>
  6815d7:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6815dc:	80 38 00             	cmpb   $0x0,(%rax)
  6815df:	74 1c                	je     6815fd <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x40d>
  6815e1:	66 83 7c 24 14 0c    	cmpw   $0xc,0x14(%rsp)
  6815e7:	0f 94 c0             	sete   %al
  6815ea:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6815ef:	4c 39 31             	cmp    %r14,(%rcx)
  6815f2:	0f 95 c1             	setne  %cl
  6815f5:	08 c1                	or     %al,%cl
  6815f7:	0f 84 57 01 00 00    	je     681754 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x564>
  6815fd:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  681602:	4c 39 30             	cmp    %r14,(%rax)
  681605:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  68160a:	f3 0f 10 00          	movss  (%rax),%xmm0
  68160e:	b9 00 00 00 00       	mov    $0x0,%ecx
  681613:	48 0f 44 4c 24 20    	cmove  0x20(%rsp),%rcx
  681619:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  68161e:	80 38 00             	cmpb   $0x0,(%rax)
  681621:	b8 00 00 00 00       	mov    $0x0,%eax
  681626:	48 0f 44 c8          	cmove  %rax,%rcx
  68162a:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  681631:	00 
  681632:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  681637:	4c 89 f2             	mov    %r14,%rdx
  68163a:	4c 8d 44 24 68       	lea    0x68(%rsp),%r8
  68163f:	eb 5f                	jmp    6816a0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x4b0>
  681641:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  681648:	0f 1f 84 00 00 00 00 
  68164f:	00 
  681650:	76 0e                	jbe    681660 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x470>
  681652:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  681659:	00 00 00 00 00 
  68165e:	eb 4b                	jmp    6816ab <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x4bb>
  681660:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  681665:	48 39 18             	cmp    %rbx,(%rax)
  681668:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  68166d:	f3 0f 10 00          	movss  (%rax),%xmm0
  681671:	b9 00 00 00 00       	mov    $0x0,%ecx
  681676:	48 0f 44 4c 24 20    	cmove  0x20(%rsp),%rcx
  68167c:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  681681:	80 38 00             	cmpb   $0x0,(%rax)
  681684:	b8 00 00 00 00       	mov    $0x0,%eax
  681689:	48 0f 44 c8          	cmove  %rax,%rcx
  68168d:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  681694:	00 
  681695:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  68169a:	48 89 da             	mov    %rbx,%rdx
  68169d:	45 31 c0             	xor    %r8d,%r8d
  6816a0:	ff 15 7a 80 10 00    	call   *0x10807a(%rip)        # 789720 <_DYNAMIC+0x908>
  6816a6:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  6816ab:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  6816b2:	00 
  6816b3:	49 89 44 24 40       	mov    %rax,0x40(%r12)
  6816b8:	48 8b 84 24 a8 00 00 	mov    0xa8(%rsp),%rax
  6816bf:	00 
  6816c0:	48 8b 8c 24 b0 00 00 	mov    0xb0(%rsp),%rcx
  6816c7:	00 
  6816c8:	0f 10 84 24 b8 00 00 	movups 0xb8(%rsp),%xmm0
  6816cf:	00 
  6816d0:	0f 10 8c 24 c8 00 00 	movups 0xc8(%rsp),%xmm1
  6816d7:	00 
  6816d8:	0f 10 94 24 d8 00 00 	movups 0xd8(%rsp),%xmm2
  6816df:	00 
  6816e0:	41 0f 11 54 24 30    	movups %xmm2,0x30(%r12)
  6816e6:	41 0f 11 4c 24 20    	movups %xmm1,0x20(%r12)
  6816ec:	41 0f 11 44 24 10    	movups %xmm0,0x10(%r12)
  6816f2:	49 89 04 24          	mov    %rax,(%r12)
  6816f6:	49 89 4c 24 08       	mov    %rcx,0x8(%r12)
  6816fb:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  681702:	00 
  681703:	48 8b 28             	mov    (%rax),%rbp
  681706:	48 89 9c 24 28 01 00 	mov    %rbx,0x128(%rsp)
  68170d:	00 
  68170e:	83 bc 24 30 01 00 00 	cmpl   $0x1,0x130(%rsp)
  681715:	01 
  681716:	0f 85 54 fe ff ff    	jne    681570 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x380>
  68171c:	48 8b 7d 08          	mov    0x8(%rbp),%rdi
  681720:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  681724:	48 8b 45 18          	mov    0x18(%rbp),%rax
  681728:	48 8b 10             	mov    (%rax),%rdx
  68172b:	48 8b 45 20          	mov    0x20(%rbp),%rax
  68172f:	f3 0f 10 00          	movss  (%rax),%xmm0
  681733:	48 89 d9             	mov    %rbx,%rcx
  681736:	4d 89 e0             	mov    %r12,%r8
  681739:	e8 c2 f3 ff ff       	call   680b00 <gpui_canvas::text::planner::append_caret>
  68173e:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  681743:	83 f8 ff             	cmp    $0xffffffff,%eax
  681746:	0f 95 c0             	setne  %al
  681749:	48 8b 4d 00          	mov    0x0(%rbp),%rcx
  68174d:	08 01                	or     %al,(%rcx)
  68174f:	e9 1c fe ff ff       	jmp    681570 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x380>
  681754:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  68175a:	f6 44 24 03 01       	testb  $0x1,0x3(%rsp)
  68175f:	74 09                	je     68176a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x57a>
  681761:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  681766:	f3 0f 10 00          	movss  (%rax),%xmm0
  68176a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  68176f:	48 8b 40 08          	mov    0x8(%rax),%rax
  681773:	0f 57 c9             	xorps  %xmm1,%xmm1
  681776:	f3 0f 5a c8          	cvtss2sd %xmm0,%xmm1
  68177a:	f3 0f 10 50 40       	movss  0x40(%rax),%xmm2
  68177f:	f3 0f 10 58 44       	movss  0x44(%rax),%xmm3
  681784:	0f 28 e2             	movaps %xmm2,%xmm4
  681787:	f3 0f 5d 60 48       	minss  0x48(%rax),%xmm4
  68178c:	0f 28 ec             	movaps %xmm4,%xmm5
  68178f:	f3 0f c2 ec 03       	cmpunordss %xmm4,%xmm5
  681794:	0f 28 f5             	movaps %xmm5,%xmm6
  681797:	0f 55 f4             	andnps %xmm4,%xmm6
  68179a:	0f 54 ea             	andps  %xmm2,%xmm5
  68179d:	0f 56 ee             	orps   %xmm6,%xmm5
  6817a0:	0f 57 d2             	xorps  %xmm2,%xmm2
  6817a3:	f3 0f 5a d5          	cvtss2sd %xmm5,%xmm2
  6817a7:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6817ac:	f3 0f 58 01          	addss  (%rcx),%xmm0
  6817b0:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  6817b4:	0f 28 e3             	movaps %xmm3,%xmm4
  6817b7:	f3 0f 5f 60 4c       	maxss  0x4c(%rax),%xmm4
  6817bc:	0f 28 ec             	movaps %xmm4,%xmm5
  6817bf:	f3 0f c2 ec 03       	cmpunordss %xmm4,%xmm5
  6817c4:	0f 28 f5             	movaps %xmm5,%xmm6
  6817c7:	0f 55 f4             	andnps %xmm4,%xmm6
  6817ca:	0f 54 eb             	andps  %xmm3,%xmm5
  6817cd:	0f 56 ee             	orps   %xmm6,%xmm5
  6817d0:	0f 57 db             	xorps  %xmm3,%xmm3
  6817d3:	f3 0f 5a dd          	cvtss2sd %xmm5,%xmm3
  6817d7:	f2 0f 11 8c 24 b0 00 	movsd  %xmm1,0xb0(%rsp)
  6817de:	00 00 
  6817e0:	f2 0f 11 94 24 b8 00 	movsd  %xmm2,0xb8(%rsp)
  6817e7:	00 00 
  6817e9:	f2 0f 11 84 24 c0 00 	movsd  %xmm0,0xc0(%rsp)
  6817f0:	00 00 
  6817f2:	f2 0f 11 9c 24 c8 00 	movsd  %xmm3,0xc8(%rsp)
  6817f9:	00 00 
  6817fb:	f2 0f 11 8c 24 d0 00 	movsd  %xmm1,0xd0(%rsp)
  681802:	00 00 
  681804:	f2 0f 11 94 24 d8 00 	movsd  %xmm2,0xd8(%rsp)
  68180b:	00 00 
  68180d:	f2 0f 11 84 24 e0 00 	movsd  %xmm0,0xe0(%rsp)
  681814:	00 00 
  681816:	f2 0f 11 9c 24 e8 00 	movsd  %xmm3,0xe8(%rsp)
  68181d:	00 00 
  68181f:	48 c7 84 24 a8 00 00 	movq   $0x1,0xa8(%rsp)
  681826:	00 01 00 00 00 
  68182b:	e9 7b fe ff ff       	jmp    6816ab <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x4bb>
  681830:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  681835:	4c 89 00             	mov    %r8,(%rax)
  681838:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  68183d:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  681843:	f3 0f 11 00          	movss  %xmm0,(%rax)
  681847:	66 83 7c 24 14 0c    	cmpw   $0xc,0x14(%rsp)
  68184d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  681852:	0f 95 00             	setne  (%rax)
  681855:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  68185a:	c7 03 01 00 00 00    	movl   $0x1,(%rbx)
  681860:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  681865:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  68186a:	0f 11 00             	movups %xmm0,(%rax)
  68186d:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  681872:	4c 89 00             	mov    %r8,(%rax)
  681875:	e9 7e fa ff ff       	jmp    6812f8 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x108>
  68187a:	b0 01                	mov    $0x1,%al
  68187c:	eb 02                	jmp    681880 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x690>
  68187e:	b0 02                	mov    $0x2,%al
  681880:	48 81 c4 88 02 00 00 	add    $0x288,%rsp
  681887:	5b                   	pop    %rbx
  681888:	41 5c                	pop    %r12
  68188a:	41 5d                	pop    %r13
  68188c:	41 5e                	pop    %r14
  68188e:	41 5f                	pop    %r15
  681890:	5d                   	pop    %rbp
  681891:	c3                   	ret
  681892:	48 8d 3d c7 ca bd ff 	lea    -0x423539(%rip),%rdi        # 25e360 <anon.d4a86088305c8823b863e6abd2e38045.0.llvm.4134324091787671213>
  681899:	48 8d 15 28 da 0f 00 	lea    0xfda28(%rip),%rdx        # 77f2c8 <anon.d4a86088305c8823b863e6abd2e38045.2.llvm.4134324091787671213>
  6818a0:	be 63 00 00 00       	mov    $0x63,%esi
  6818a5:	ff 15 4d 7a 10 00    	call   *0x107a4d(%rip)        # 7892f8 <_DYNAMIC+0x4e0>
  6818ab:	48 8d 15 5e da 0f 00 	lea    0xfda5e(%rip),%rdx        # 77f310 <anon.d4a86088305c8823b863e6abd2e38045.3.llvm.4134324091787671213+0x30>
  6818b2:	ff 15 c0 78 10 00    	call   *0x1078c0(%rip)        # 789178 <_DYNAMIC+0x360>
  6818b8:	48 8d 15 21 da 0f 00 	lea    0xfda21(%rip),%rdx        # 77f2e0 <anon.d4a86088305c8823b863e6abd2e38045.3.llvm.4134324091787671213>
  6818bf:	ff 15 b3 78 10 00    	call   *0x1078b3(%rip)        # 789178 <_DYNAMIC+0x360>
