
/tmp/gpui-caret-transaction-bin/matched-partial-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007f92b0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>>:
  7f92b0:	55                   	push   %rbp
  7f92b1:	41 57                	push   %r15
  7f92b3:	41 56                	push   %r14
  7f92b5:	41 55                	push   %r13
  7f92b7:	41 54                	push   %r12
  7f92b9:	53                   	push   %rbx
  7f92ba:	48 81 ec 68 01 00 00 	sub    $0x168,%rsp
  7f92c1:	48 89 cb             	mov    %rcx,%rbx
  7f92c4:	49 89 d6             	mov    %rdx,%r14
  7f92c7:	89 f2                	mov    %esi,%edx
  7f92c9:	48 89 fe             	mov    %rdi,%rsi
  7f92cc:	4c 8d 7c 24 58       	lea    0x58(%rsp),%r15
  7f92d1:	4c 89 ff             	mov    %r15,%rdi
  7f92d4:	e8 97 16 00 00       	call   7fa970 <<parley::layout::run::Clusters<()>>::new>
  7f92d9:	f3 0f 10 03          	movss  (%rbx),%xmm0
  7f92dd:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  7f92e3:	48 8d 7c 24 24       	lea    0x24(%rsp),%rdi
  7f92e8:	4c 89 fe             	mov    %r15,%rsi
  7f92eb:	e8 70 19 00 00       	call   7fac60 <<parley::layout::run::Clusters<()>>::advance_cursor>
  7f92f0:	83 7c 24 24 01       	cmpl   $0x1,0x24(%rsp)
  7f92f5:	0f 85 0c 01 00 00    	jne    7f9407 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0x157>
  7f92fb:	4c 8d a4 24 10 01 00 	lea    0x110(%rsp),%r12
  7f9302:	00 
  7f9303:	4c 8d 6c 24 48       	lea    0x48(%rsp),%r13
  7f9308:	eb 74                	jmp    7f937e <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0xce>
  7f930a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  7f9310:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f9313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  7f9318:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  7f931d:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  7f9322:	f2 0f 10 4a 44       	movsd  0x44(%rdx),%xmm1
  7f9327:	f2 0f 11 4c 24 10    	movsd  %xmm1,0x10(%rsp)
  7f932d:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
  7f9333:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  7f9337:	0f b6 89 8c 00 00 00 	movzbl 0x8c(%rcx),%ecx
  7f933e:	83 e1 01             	and    $0x1,%ecx
  7f9341:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7f9346:	4c 89 e6             	mov    %r12,%rsi
  7f9349:	4c 89 ea             	mov    %r13,%rdx
  7f934c:	ff 15 2e 50 33 00    	call   *0x33502e(%rip)        # b2e380 <_DYNAMIC+0xe80>
  7f9352:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  7f9358:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  7f935c:	f3 0f 11 4c 24 0c    	movss  %xmm1,0xc(%rsp)
  7f9362:	f3 0f 11 0b          	movss  %xmm1,(%rbx)
  7f9366:	48 8d 7c 24 24       	lea    0x24(%rsp),%rdi
  7f936b:	4c 89 fe             	mov    %r15,%rsi
  7f936e:	e8 ed 18 00 00       	call   7fac60 <<parley::layout::run::Clusters<()>>::advance_cursor>
  7f9373:	80 7c 24 24 00       	cmpb   $0x0,0x24(%rsp)
  7f9378:	0f 84 89 00 00 00    	je     7f9407 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0x157>
  7f937e:	48 83 bc 24 10 01 00 	cmpq   $0x0,0x110(%rsp)
  7f9385:	00 00 
  7f9387:	0f 84 8c 00 00 00    	je     7f9419 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0x169>
  7f938d:	4c 89 7c 24 38       	mov    %r15,0x38(%rsp)
  7f9392:	4c 89 64 24 40       	mov    %r12,0x40(%rsp)
  7f9397:	48 8d 44 24 28       	lea    0x28(%rsp),%rax
  7f939c:	0f 10 00             	movups (%rax),%xmm0
  7f939f:	41 0f 11 45 00       	movups %xmm0,0x0(%r13)
  7f93a4:	49 8b 6e 10          	mov    0x10(%r14),%rbp
  7f93a8:	49 3b 2e             	cmp    (%r14),%rbp
  7f93ab:	75 09                	jne    7f93b6 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0x106>
  7f93ad:	4c 89 f7             	mov    %r14,%rdi
  7f93b0:	ff 15 fa 4a 33 00    	call   *0x334afa(%rip)        # b2deb0 <_DYNAMIC+0x9b0>
  7f93b6:	49 8b 46 08          	mov    0x8(%r14),%rax
  7f93ba:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  7f93c0:	f3 0f 11 04 a8       	movss  %xmm0,(%rax,%rbp,4)
  7f93c5:	48 ff c5             	inc    %rbp
  7f93c8:	49 89 6e 10          	mov    %rbp,0x10(%r14)
  7f93cc:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
  7f93d2:	0f 84 38 ff ff ff    	je     7f9310 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0x60>
  7f93d8:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7f93dd:	8b 7c 24 78          	mov    0x78(%rsp),%edi
  7f93e1:	48 8b b0 18 01 00 00 	mov    0x118(%rax),%rsi
  7f93e8:	48 39 fe             	cmp    %rdi,%rsi
  7f93eb:	76 45                	jbe    7f9432 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0x182>
  7f93ed:	48 8b 80 10 01 00 00 	mov    0x110(%rax),%rax
  7f93f4:	48 6b cf 70          	imul   $0x70,%rdi,%rcx
  7f93f8:	f3 0f 10 44 08 50    	movss  0x50(%rax,%rcx,1),%xmm0
  7f93fe:	8b 44 08 54          	mov    0x54(%rax,%rcx,1),%eax
  7f9402:	e9 11 ff ff ff       	jmp    7f9318 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0x68>
  7f9407:	48 81 c4 68 01 00 00 	add    $0x168,%rsp
  7f940e:	5b                   	pop    %rbx
  7f940f:	41 5c                	pop    %r12
  7f9411:	41 5d                	pop    %r13
  7f9413:	41 5e                	pop    %r14
  7f9415:	41 5f                	pop    %r15
  7f9417:	5d                   	pop    %rbp
  7f9418:	c3                   	ret
  7f9419:	48 8d 3d 60 fe 90 ff 	lea    -0x6f01a0(%rip),%rdi        # 109280 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.4.llvm.14379316919819170204>
  7f9420:	48 8d 15 71 e9 30 00 	lea    0x30e971(%rip),%rdx        # b07d98 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.6.llvm.14379316919819170204>
  7f9427:	be 63 00 00 00       	mov    $0x63,%esi
  7f942c:	ff 15 4e 44 33 00    	call   *0x33444e(%rip)        # b2d880 <_DYNAMIC+0x380>
  7f9432:	48 8d 15 77 e9 30 00 	lea    0x30e977(%rip),%rdx        # b07db0 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.7.llvm.14379316919819170204>
  7f9439:	ff 15 91 43 33 00    	call   *0x334391(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
