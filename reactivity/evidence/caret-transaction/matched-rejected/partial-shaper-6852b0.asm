
/tmp/gpui-caret-transaction-bin/matched-partial-caret_pair_measure:     file format elf64-x86-64


Disassembly of section .text:

00000000006852b0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>>:
  6852b0:	55                   	push   %rbp
  6852b1:	41 57                	push   %r15
  6852b3:	41 56                	push   %r14
  6852b5:	41 55                	push   %r13
  6852b7:	41 54                	push   %r12
  6852b9:	53                   	push   %rbx
  6852ba:	48 81 ec d8 02 00 00 	sub    $0x2d8,%rsp
  6852c1:	83 bf 54 01 00 00 00 	cmpl   $0x0,0x154(%rdi)
  6852c8:	75 1d                	jne    6852e7 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x37>
  6852ca:	48 89 fd             	mov    %rdi,%rbp
  6852cd:	48 8b 47 70          	mov    0x70(%rdi),%rax
  6852d1:	48 c1 e8 20          	shr    $0x20,%rax
  6852d5:	75 10                	jne    6852e7 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x37>
  6852d7:	48 8b 9d 18 01 00 00 	mov    0x118(%rbp),%rbx
  6852de:	48 89 d8             	mov    %rbx,%rax
  6852e1:	48 c1 e8 20          	shr    $0x20,%rax
  6852e5:	74 24                	je     68530b <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x5b>
  6852e7:	48 8b 06             	mov    (%rsi),%rax
  6852ea:	41 b6 01             	mov    $0x1,%r14b
  6852ed:	48 85 c0             	test   %rax,%rax
  6852f0:	0f 84 cc 0a 00 00    	je     685dc2 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb12>
  6852f6:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  6852fa:	48 c1 e0 03          	shl    $0x3,%rax
  6852fe:	ba 08 00 00 00       	mov    $0x8,%edx
  685303:	48 89 c6             	mov    %rax,%rsi
  685306:	e9 b1 0a 00 00       	jmp    685dbc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb0c>
  68530b:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  685311:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
  685316:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  68531d:	00 00 
  68531f:	48 c7 44 24 40 04 00 	movq   $0x4,0x40(%rsp)
  685326:	00 00 
  685328:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
  68532f:	00 00 
  685331:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  685338:	00 00 
  68533a:	48 c7 44 24 58 04 00 	movq   $0x4,0x58(%rsp)
  685341:	00 00 
  685343:	48 c7 44 24 60 00 00 	movq   $0x0,0x60(%rsp)
  68534a:	00 00 
  68534c:	48 8d bc 24 40 02 00 	lea    0x240(%rsp),%rdi
  685353:	00 
  685354:	49 89 d6             	mov    %rdx,%r14
  685357:	ba 98 00 00 00       	mov    $0x98,%edx
  68535c:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
  685362:	ff 15 80 3d 10 00    	call   *0x103d80(%rip)        # 7890e8 <memcpy@GLIBC_2.14>
  685368:	4c 89 b4 24 b0 00 00 	mov    %r14,0xb0(%rsp)
  68536f:	00 
  685370:	f3 0f 10 44 24 18    	movss  0x18(%rsp),%xmm0
  685376:	f3 0f 11 44 24 20    	movss  %xmm0,0x20(%rsp)
  68537c:	48 c7 84 24 30 02 00 	movq   $0x2,0x230(%rsp)
  685383:	00 02 00 00 00 
  685388:	48 c7 84 24 b8 00 00 	movq   $0x0,0xb8(%rsp)
  68538f:	00 00 00 00 00 
  685394:	c7 84 24 a4 01 00 00 	movl   $0x0,0x1a4(%rsp)
  68539b:	00 00 00 00 
  68539f:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  6853a6:	00 00 00 00 00 
  6853ab:	48 c7 84 24 f8 00 00 	movq   $0x0,0xf8(%rsp)
  6853b2:	00 00 00 00 00 
  6853b7:	48 c7 84 24 00 01 00 	movq   $0x0,0x100(%rsp)
  6853be:	00 00 00 00 00 
  6853c3:	48 85 db             	test   %rbx,%rbx
  6853c6:	48 89 6c 24 78       	mov    %rbp,0x78(%rsp)
  6853cb:	0f 84 2b 08 00 00    	je     685bfc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x94c>
  6853d1:	48 8b 8d 10 01 00 00 	mov    0x110(%rbp),%rcx
  6853d8:	48 6b c3 70          	imul   $0x70,%rbx,%rax
  6853dc:	48 01 c8             	add    %rcx,%rax
  6853df:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6853e6:	00 
  6853e7:	4c 8b 85 28 01 00 00 	mov    0x128(%rbp),%r8
  6853ee:	48 8b 95 30 01 00 00 	mov    0x130(%rbp),%rdx
  6853f5:	48 8b 45 58          	mov    0x58(%rbp),%rax
  6853f9:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  685400:	00 
  685401:	48 8b 85 e8 00 00 00 	mov    0xe8(%rbp),%rax
  685408:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  68540f:	00 
  685410:	45 31 c9             	xor    %r9d,%r9d
  685413:	48 8d 05 e6 a2 0f 00 	lea    0xfa2e6(%rip),%rax        # 77f700 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941+0x48>
  68541a:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  685421:	00 
  685422:	48 8d 05 a7 a2 0f 00 	lea    0xfa2a7(%rip),%rax        # 77f6d0 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941+0x18>
  685429:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  68542e:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  685435:	00 
  685436:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  68543b:	48 89 ac 24 90 00 00 	mov    %rbp,0x90(%rsp)
  685442:	00 
  685443:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  68544a:	00 
  68544b:	44 89 8c 24 a0 00 00 	mov    %r9d,0xa0(%rsp)
  685452:	00 
  685453:	48 8b 79 10          	mov    0x10(%rcx),%rdi
  685457:	48 8b 71 18          	mov    0x18(%rcx),%rsi
  68545b:	48 89 f0             	mov    %rsi,%rax
  68545e:	48 29 f8             	sub    %rdi,%rax
  685461:	0f 82 74 09 00 00    	jb     685ddb <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb2b>
  685467:	48 39 d6             	cmp    %rdx,%rsi
  68546a:	0f 87 6b 09 00 00    	ja     685ddb <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb2b>
  685470:	48 c1 e8 20          	shr    $0x20,%rax
  685474:	41 b6 01             	mov    $0x1,%r14b
  685477:	0f 85 e5 08 00 00    	jne    685d62 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  68547d:	4c 89 4c 24 70       	mov    %r9,0x70(%rsp)
  685482:	48 39 fe             	cmp    %rdi,%rsi
  685485:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  68548a:	0f 85 96 03 00 00    	jne    685826 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x576>
  685490:	48 89 fe             	mov    %rdi,%rsi
  685493:	48 89 eb             	mov    %rbp,%rbx
  685496:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  68549b:	45 31 ff             	xor    %r15d,%r15d
  68549e:	4c 8d 6c 24 30       	lea    0x30(%rsp),%r13
  6854a3:	45 31 c9             	xor    %r9d,%r9d
  6854a6:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
  6854ad:	48 39 fe             	cmp    %rdi,%rsi
  6854b0:	0f 82 37 09 00 00    	jb     685ded <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb3d>
  6854b6:	48 39 d6             	cmp    %rdx,%rsi
  6854b9:	0f 87 2e 09 00 00    	ja     685ded <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb3d>
  6854bf:	4c 89 8c 24 f0 00 00 	mov    %r9,0xf0(%rsp)
  6854c6:	00 
  6854c7:	48 39 f7             	cmp    %rsi,%rdi
  6854ca:	0f 85 f8 03 00 00    	jne    6858c8 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x618>
  6854d0:	48 83 44 24 68 70    	addq   $0x70,0x68(%rsp)
  6854d6:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6854db:	ff c0                	inc    %eax
  6854dd:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  6854e2:	49 c1 e7 03          	shl    $0x3,%r15
  6854e6:	31 db                	xor    %ebx,%ebx
  6854e8:	48 8b 6c 24 78       	mov    0x78(%rsp),%rbp
  6854ed:	eb 05                	jmp    6854f4 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x244>
  6854ef:	90                   	nop
  6854f0:	48 83 c3 08          	add    $0x8,%rbx
  6854f4:	49 39 df             	cmp    %rbx,%r15
  6854f7:	0f 84 a0 03 00 00    	je     68589d <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x5ed>
  6854fd:	41 8b 44 1d 00       	mov    0x0(%r13,%rbx,1),%eax
  685502:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  685507:	48 39 c8             	cmp    %rcx,%rax
  68550a:	74 e4                	je     6854f0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x240>
  68550c:	48 8b 94 24 98 00 00 	mov    0x98(%rsp),%rdx
  685513:	00 
  685514:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  685518:	48 01 c1             	add    %rax,%rcx
  68551b:	48 3b 4a 18          	cmp    0x18(%rdx),%rcx
  68551f:	0f 83 f9 08 00 00    	jae    685e1e <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb6e>
  685525:	4c 8b b4 24 90 00 00 	mov    0x90(%rsp),%r14
  68552c:	00 
  68552d:	49 3b 8e 30 01 00 00 	cmp    0x130(%r14),%rcx
  685534:	0f 83 e4 08 00 00    	jae    685e1e <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb6e>
  68553a:	49 8b 96 28 01 00 00 	mov    0x128(%r14),%rdx
  685541:	48 8d 34 89          	lea    (%rcx,%rcx,4),%rsi
  685545:	48 8d 0c f2          	lea    (%rdx,%rsi,8),%rcx
  685549:	80 7c f2 21 01       	cmpb   $0x1,0x21(%rdx,%rsi,8)
  68554e:	0f 84 a8 08 00 00    	je     685dfc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb4c>
  685554:	4c 8b 61 10          	mov    0x10(%rcx),%r12
  685558:	49 8b 76 58          	mov    0x58(%r14),%rsi
  68555c:	49 39 f4             	cmp    %rsi,%r12
  68555f:	0f 83 b9 08 00 00    	jae    685e1e <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb6e>
  685565:	4d 3b a6 e8 00 00 00 	cmp    0xe8(%r14),%r12
  68556c:	0f 83 ac 08 00 00    	jae    685e1e <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb6e>
  685572:	f3 41 0f 10 44 1d 04 	movss  0x4(%r13,%rbx,1),%xmm0
  685579:	8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%edx
  685580:	49 8b 7e 50          	mov    0x50(%r14),%rdi
  685584:	4f 8d 04 e4          	lea    (%r12,%r12,8),%r8
  685588:	49 c1 e0 04          	shl    $0x4,%r8
  68558c:	4f 8d 0c a4          	lea    (%r12,%r12,4),%r9
  685590:	49 c1 e1 04          	shl    $0x4,%r9
  685594:	4d 03 8e e0 00 00 00 	add    0xe0(%r14),%r9
  68559b:	4e 8d 14 07          	lea    (%rdi,%r8,1),%r10
  68559f:	4c 89 b4 24 b8 01 00 	mov    %r14,0x1b8(%rsp)
  6855a6:	00 
  6855a7:	4c 89 94 24 c0 01 00 	mov    %r10,0x1c0(%rsp)
  6855ae:	00 
  6855af:	4c 89 8c 24 c8 01 00 	mov    %r9,0x1c8(%rsp)
  6855b6:	00 
  6855b7:	48 89 8c 24 d0 01 00 	mov    %rcx,0x1d0(%rsp)
  6855be:	00 
  6855bf:	89 94 24 d8 01 00 00 	mov    %edx,0x1d8(%rsp)
  6855c6:	89 84 24 dc 01 00 00 	mov    %eax,0x1dc(%rsp)
  6855cd:	44 89 a4 24 e0 01 00 	mov    %r12d,0x1e0(%rsp)
  6855d4:	00 
  6855d5:	f3 0f 11 44 24 24    	movss  %xmm0,0x24(%rsp)
  6855db:	48 c7 44 24 60 00 00 	movq   $0x0,0x60(%rsp)
  6855e2:	00 00 
  6855e4:	42 f6 84 07 8c 00 00 	testb  $0x1,0x8c(%rdi,%r8,1)
  6855eb:	00 01 
  6855ed:	74 7d                	je     68566c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x3bc>
  6855ef:	41 0f 10 46 68       	movups 0x68(%r14),%xmm0
  6855f4:	41 0f 10 8e 80 00 00 	movups 0x80(%r14),%xmm1
  6855fb:	00 
  6855fc:	41 0f 10 96 98 00 00 	movups 0x98(%r14),%xmm2
  685603:	00 
  685604:	0f 11 84 24 18 01 00 	movups %xmm0,0x118(%rsp)
  68560b:	00 
  68560c:	0f 11 8c 24 28 01 00 	movups %xmm1,0x128(%rsp)
  685613:	00 
  685614:	0f 11 94 24 38 01 00 	movups %xmm2,0x138(%rsp)
  68561b:	00 
  68561c:	48 8b 41 18          	mov    0x18(%rcx),%rax
  685620:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  685627:	00 
  685628:	48 8d bc 24 18 01 00 	lea    0x118(%rsp),%rdi
  68562f:	00 
  685630:	ff 15 4a 41 10 00    	call   *0x10414a(%rip)        # 789780 <_DYNAMIC+0x968>
  685636:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  68563b:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  685640:	48 29 f1             	sub    %rsi,%rcx
  685643:	48 39 c8             	cmp    %rcx,%rax
  685646:	0f 87 bd 01 00 00    	ja     685809 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x559>
  68564c:	48 8d bc 24 b8 01 00 	lea    0x1b8(%rsp),%rdi
  685653:	00 
  685654:	be 01 00 00 00       	mov    $0x1,%esi
  685659:	48 8d 54 24 50       	lea    0x50(%rsp),%rdx
  68565e:	48 8d 4c 24 24       	lea    0x24(%rsp),%rcx
  685663:	e8 68 c2 ff ff       	call   6818d0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>>
  685668:	49 8b 76 58          	mov    0x58(%r14),%rsi
  68566c:	44 89 e7             	mov    %r12d,%edi
  68566f:	48 c7 84 24 08 01 00 	movq   $0x0,0x108(%rsp)
  685676:	00 00 00 00 00 
  68567b:	c7 84 24 8c 00 00 00 	movl   $0x0,0x8c(%rsp)
  685682:	00 00 00 00 
  685686:	c6 44 24 0f 00       	movb   $0x0,0xf(%rsp)
  68568b:	48 39 fe             	cmp    %rdi,%rsi
  68568e:	0f 86 9a 07 00 00    	jbe    685e2e <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb7e>
  685694:	41 0f 10 46 68       	movups 0x68(%r14),%xmm0
  685699:	41 0f 10 8e 80 00 00 	movups 0x80(%r14),%xmm1
  6856a0:	00 
  6856a1:	41 0f 10 96 98 00 00 	movups 0x98(%r14),%xmm2
  6856a8:	00 
  6856a9:	49 8b 46 50          	mov    0x50(%r14),%rax
  6856ad:	48 8d 0c ff          	lea    (%rdi,%rdi,8),%rcx
  6856b1:	48 c1 e1 04          	shl    $0x4,%rcx
  6856b5:	0f 11 84 24 e8 01 00 	movups %xmm0,0x1e8(%rsp)
  6856bc:	00 
  6856bd:	0f 11 8c 24 f8 01 00 	movups %xmm1,0x1f8(%rsp)
  6856c4:	00 
  6856c5:	0f 11 94 24 08 02 00 	movups %xmm2,0x208(%rsp)
  6856cc:	00 
  6856cd:	48 8b 44 08 50       	mov    0x50(%rax,%rcx,1),%rax
  6856d2:	48 89 84 24 18 02 00 	mov    %rax,0x218(%rsp)
  6856d9:	00 
  6856da:	48 c7 84 24 10 01 00 	movq   $0x0,0x110(%rsp)
  6856e1:	00 00 00 00 00 
  6856e6:	48 8d 84 24 e8 01 00 	lea    0x1e8(%rsp),%rax
  6856ed:	00 
  6856ee:	48 89 84 24 18 01 00 	mov    %rax,0x118(%rsp)
  6856f5:	00 
  6856f6:	48 89 ac 24 20 01 00 	mov    %rbp,0x120(%rsp)
  6856fd:	00 
  6856fe:	48 8d 84 24 00 01 00 	lea    0x100(%rsp),%rax
  685705:	00 
  685706:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  68570d:	00 
  68570e:	48 8d 84 24 f8 00 00 	lea    0xf8(%rsp),%rax
  685715:	00 
  685716:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  68571d:	00 
  68571e:	48 8d 44 24 50       	lea    0x50(%rsp),%rax
  685723:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
  68572a:	00 
  68572b:	48 8d 84 24 10 01 00 	lea    0x110(%rsp),%rax
  685732:	00 
  685733:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  68573a:	00 
  68573b:	48 8d 44 24 24       	lea    0x24(%rsp),%rax
  685740:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  685747:	00 
  685748:	48 8d 44 24 0f       	lea    0xf(%rsp),%rax
  68574d:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  685754:	00 
  685755:	48 8d 84 24 30 02 00 	lea    0x230(%rsp),%rax
  68575c:	00 
  68575d:	48 89 84 24 58 01 00 	mov    %rax,0x158(%rsp)
  685764:	00 
  685765:	48 8d 84 24 b8 00 00 	lea    0xb8(%rsp),%rax
  68576c:	00 
  68576d:	48 89 84 24 60 01 00 	mov    %rax,0x160(%rsp)
  685774:	00 
  685775:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  68577a:	48 89 84 24 68 01 00 	mov    %rax,0x168(%rsp)
  685781:	00 
  685782:	48 8d 84 24 b0 00 00 	lea    0xb0(%rsp),%rax
  685789:	00 
  68578a:	48 89 84 24 70 01 00 	mov    %rax,0x170(%rsp)
  685791:	00 
  685792:	48 8d 84 24 08 01 00 	lea    0x108(%rsp),%rax
  685799:	00 
  68579a:	48 89 84 24 78 01 00 	mov    %rax,0x178(%rsp)
  6857a1:	00 
  6857a2:	48 8d 84 24 90 00 00 	lea    0x90(%rsp),%rax
  6857a9:	00 
  6857aa:	48 89 84 24 80 01 00 	mov    %rax,0x180(%rsp)
  6857b1:	00 
  6857b2:	48 8d 84 24 8c 00 00 	lea    0x8c(%rsp),%rax
  6857b9:	00 
  6857ba:	48 89 84 24 88 01 00 	mov    %rax,0x188(%rsp)
  6857c1:	00 
  6857c2:	48 8d 84 24 a4 01 00 	lea    0x1a4(%rsp),%rax
  6857c9:	00 
  6857ca:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  6857d1:	00 
  6857d2:	48 8d 84 24 c8 00 00 	lea    0xc8(%rsp),%rax
  6857d9:	00 
  6857da:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
  6857e1:	00 
  6857e2:	48 8d bc 24 b8 01 00 	lea    0x1b8(%rsp),%rdi
  6857e9:	00 
  6857ea:	31 f6                	xor    %esi,%esi
  6857ec:	48 8d 94 24 18 01 00 	lea    0x118(%rsp),%rdx
  6857f3:	00 
  6857f4:	e8 f7 b9 ff ff       	call   6811f0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>>
  6857f9:	41 89 c6             	mov    %eax,%r14d
  6857fc:	3c 02                	cmp    $0x2,%al
  6857fe:	0f 84 ec fc ff ff    	je     6854f0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x240>
  685804:	e9 59 05 00 00       	jmp    685d62 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  685809:	b9 04 00 00 00       	mov    $0x4,%ecx
  68580e:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  685814:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
  685819:	48 89 c2             	mov    %rax,%rdx
  68581c:	e8 0f e4 fd ff       	call   663c30 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  685821:	e9 26 fe ff ff       	jmp    68564c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x39c>
  685826:	48 8d 04 fd 00 00 00 	lea    0x0(,%rdi,8),%rax
  68582d:	00 
  68582e:	48 8d 2c 80          	lea    (%rax,%rax,4),%rbp
  685832:	48 8d 04 f5 00 00 00 	lea    0x0(,%rsi,8),%rax
  685839:	00 
  68583a:	48 8d 1c 80          	lea    (%rax,%rax,4),%rbx
  68583e:	49 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%r9
  685845:	48 89 e9             	mov    %rbp,%rcx
  685848:	31 c0                	xor    %eax,%eax
  68584a:	45 31 ed             	xor    %r13d,%r13d
  68584d:	eb 0e                	jmp    68585d <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x5ad>
  68584f:	90                   	nop
  685850:	48 83 c1 28          	add    $0x28,%rcx
  685854:	48 39 cb             	cmp    %rcx,%rbx
  685857:	0f 84 df 01 00 00    	je     685a3c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x78c>
  68585d:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  685862:	80 7c 0a 21 00       	cmpb   $0x0,0x21(%rdx,%rcx,1)
  685867:	75 e7                	jne    685850 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x5a0>
  685869:	48 8b 54 0a 10       	mov    0x10(%rdx,%rcx,1),%rdx
  68586e:	48 3b 94 24 e8 00 00 	cmp    0xe8(%rsp),%rdx
  685875:	00 
  685876:	0f 83 e6 04 00 00    	jae    685d62 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  68587c:	48 3b 94 24 e0 00 00 	cmp    0xe0(%rsp),%rdx
  685883:	00 
  685884:	0f 83 d8 04 00 00    	jae    685d62 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  68588a:	4c 39 ca             	cmp    %r9,%rdx
  68588d:	4c 0f 42 ca          	cmovb  %rdx,%r9
  685891:	48 39 c2             	cmp    %rax,%rdx
  685894:	48 0f 47 c2          	cmova  %rdx,%rax
  685898:	49 ff c5             	inc    %r13
  68589b:	eb b3                	jmp    685850 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x5a0>
  68589d:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
  6858a2:	48 3b 8c 24 d0 00 00 	cmp    0xd0(%rsp),%rcx
  6858a9:	00 
  6858aa:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  6858b0:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  6858b7:	00 
  6858b8:	4c 8b 4c 24 70       	mov    0x70(%rsp),%r9
  6858bd:	0f 85 78 fb ff ff    	jne    68543b <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x18b>
  6858c3:	e9 34 03 00 00       	jmp    685bfc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x94c>
  6858c8:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6858cd:	f3 0f 10 48 28       	movss  0x28(%rax),%xmm1
  6858d2:	8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%eax
  6858d9:	89 84 24 84 00 00 00 	mov    %eax,0x84(%rsp)
  6858e0:	48 c1 e7 03          	shl    $0x3,%rdi
  6858e4:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  6858e8:	4c 8b b3 28 01 00 00 	mov    0x128(%rbx),%r14
  6858ef:	49 01 c6             	add    %rax,%r14
  6858f2:	48 c1 e6 03          	shl    $0x3,%rsi
  6858f6:	48 8d 2c b6          	lea    (%rsi,%rsi,4),%rbp
  6858fa:	48 29 c5             	sub    %rax,%rbp
  6858fd:	45 31 e4             	xor    %r12d,%r12d
  685900:	eb 2c                	jmp    68592e <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x67e>
  685902:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  685909:	1f 84 00 00 00 00 00 
  685910:	f3 0f 10 8c 24 88 00 	movss  0x88(%rsp),%xmm1
  685917:	00 00 
  685919:	49 83 c6 28          	add    $0x28,%r14
  68591d:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  685921:	49 ff c4             	inc    %r12
  685924:	48 83 c5 d8          	add    $0xffffffffffffffd8,%rbp
  685928:	0f 84 a2 fb ff ff    	je     6854d0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x220>
  68592e:	49 8b 7e 10          	mov    0x10(%r14),%rdi
  685932:	41 80 7e 21 01       	cmpb   $0x1,0x21(%r14)
  685937:	75 27                	jne    685960 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x6b0>
  685939:	48 8b 73 40          	mov    0x40(%rbx),%rsi
  68593d:	48 39 f7             	cmp    %rsi,%rdi
  685940:	0f 83 f1 04 00 00    	jae    685e37 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb87>
  685946:	48 8b 43 38          	mov    0x38(%rbx),%rax
  68594a:	48 6b cf 38          	imul   $0x38,%rdi,%rcx
  68594e:	f3 0f 10 44 08 24    	movss  0x24(%rax,%rcx,1),%xmm0
  685954:	eb c3                	jmp    685919 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x669>
  685956:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  68595d:	00 00 00 
  685960:	48 8b 73 58          	mov    0x58(%rbx),%rsi
  685964:	48 39 f7             	cmp    %rsi,%rdi
  685967:	0f 83 d3 04 00 00    	jae    685e40 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb90>
  68596d:	48 8b b3 e8 00 00 00 	mov    0xe8(%rbx),%rsi
  685974:	48 39 f7             	cmp    %rsi,%rdi
  685977:	0f 83 cc 04 00 00    	jae    685e49 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb99>
  68597d:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
  685981:	48 c1 e0 04          	shl    $0x4,%rax
  685985:	48 03 43 50          	add    0x50(%rbx),%rax
  685989:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  68598d:	48 c1 e1 04          	shl    $0x4,%rcx
  685991:	48 03 8b e0 00 00 00 	add    0xe0(%rbx),%rcx
  685998:	48 89 9c 24 18 01 00 	mov    %rbx,0x118(%rsp)
  68599f:	00 
  6859a0:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6859a7:	00 
  6859a8:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  6859af:	00 
  6859b0:	4c 89 b4 24 30 01 00 	mov    %r14,0x130(%rsp)
  6859b7:	00 
  6859b8:	8b 84 24 84 00 00 00 	mov    0x84(%rsp),%eax
  6859bf:	89 84 24 38 01 00 00 	mov    %eax,0x138(%rsp)
  6859c6:	44 89 a4 24 3c 01 00 	mov    %r12d,0x13c(%rsp)
  6859cd:	00 
  6859ce:	89 bc 24 40 01 00 00 	mov    %edi,0x140(%rsp)
  6859d5:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  6859dc:	00 
  6859dd:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  6859e2:	48 8b 79 10          	mov    0x10(%rcx),%rdi
  6859e6:	4c 01 e7             	add    %r12,%rdi
  6859e9:	48 8b b0 30 01 00 00 	mov    0x130(%rax),%rsi
  6859f0:	48 39 f7             	cmp    %rsi,%rdi
  6859f3:	0f 83 59 04 00 00    	jae    685e52 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xba2>
  6859f9:	48 8b 80 28 01 00 00 	mov    0x128(%rax),%rax
  685a00:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  685a04:	48 8b 7c c8 10       	mov    0x10(%rax,%rcx,8),%rdi
  685a09:	48 2b bc 24 f0 00 00 	sub    0xf0(%rsp),%rdi
  685a10:	00 
  685a11:	4c 39 ff             	cmp    %r15,%rdi
  685a14:	0f 83 41 04 00 00    	jae    685e5b <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbab>
  685a1a:	f3 0f 11 8c 24 88 00 	movss  %xmm1,0x88(%rsp)
  685a21:	00 00 
  685a23:	f3 41 0f 11 4c fd 04 	movss  %xmm1,0x4(%r13,%rdi,8)
  685a2a:	48 8d bc 24 18 01 00 	lea    0x118(%rsp),%rdi
  685a31:	00 
  685a32:	e8 59 c8 ff ff       	call   682290 <<parley::layout::run::Run<()>>::advance>
  685a37:	e9 d4 fe ff ff       	jmp    685910 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x660>
  685a3c:	49 83 f9 ff          	cmp    $0xffffffffffffffff,%r9
  685a40:	74 32                	je     685a74 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x7c4>
  685a42:	48 89 c1             	mov    %rax,%rcx
  685a45:	4c 29 c9             	sub    %r9,%rcx
  685a48:	0f 82 14 03 00 00    	jb     685d62 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  685a4e:	48 ff c1             	inc    %rcx
  685a51:	4c 39 e9             	cmp    %r13,%rcx
  685a54:	0f 85 08 03 00 00    	jne    685d62 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  685a5a:	4c 39 c8             	cmp    %r9,%rax
  685a5d:	75 29                	jne    685a88 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x7d8>
  685a5f:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
  685a64:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  685a6a:	4c 8d 6c 24 30       	lea    0x30(%rsp),%r13
  685a6f:	e9 c6 00 00 00       	jmp    685b3a <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x88a>
  685a74:	48 8b 5c 24 78       	mov    0x78(%rsp),%rbx
  685a79:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  685a7e:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  685a83:	e9 13 fa ff ff       	jmp    68549b <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x1eb>
  685a88:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
  685a8f:	00 00 
  685a91:	4d 85 ed             	test   %r13,%r13
  685a94:	74 2f                	je     685ac5 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x815>
  685a96:	4c 3b 6c 24 38       	cmp    0x38(%rsp),%r13
  685a9b:	0f 87 1e 01 00 00    	ja     685bbf <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x90f>
  685aa1:	45 31 ff             	xor    %r15d,%r15d
  685aa4:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  685aa9:	4a 8d 04 ff          	lea    (%rdi,%r15,8),%rax
  685aad:	49 83 fd 01          	cmp    $0x1,%r13
  685ab1:	74 72                	je     685b25 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x875>
  685ab3:	b9 01 00 00 00       	mov    $0x1,%ecx
  685ab8:	49 83 fd 05          	cmp    $0x5,%r13
  685abc:	73 0c                	jae    685aca <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x81a>
  685abe:	be ff ff ff ff       	mov    $0xffffffff,%esi
  685ac3:	eb 48                	jmp    685b0d <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x85d>
  685ac5:	45 31 ff             	xor    %r15d,%r15d
  685ac8:	eb 66                	jmp    685b30 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x880>
  685aca:	49 8d 55 ff          	lea    -0x1(%r13),%rdx
  685ace:	48 89 d6             	mov    %rdx,%rsi
  685ad1:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
  685ad5:	48 8d 04 f0          	lea    (%rax,%rsi,8),%rax
  685ad9:	48 8d 4e 01          	lea    0x1(%rsi),%rcx
  685add:	4a 8d 3c ff          	lea    (%rdi,%r15,8),%rdi
  685ae1:	48 83 c7 10          	add    $0x10,%rdi
  685ae5:	45 31 c0             	xor    %r8d,%r8d
  685ae8:	0f 28 05 41 fd 99 ff 	movaps -0x6602bf(%rip),%xmm0        # 25830 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0xb70>
  685aef:	42 0f 11 44 c7 f0    	movups %xmm0,-0x10(%rdi,%r8,8)
  685af5:	42 0f 11 04 c7       	movups %xmm0,(%rdi,%r8,8)
  685afa:	49 83 c0 04          	add    $0x4,%r8
  685afe:	4c 39 c6             	cmp    %r8,%rsi
  685b01:	75 ec                	jne    685aef <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x83f>
  685b03:	48 39 f2             	cmp    %rsi,%rdx
  685b06:	be ff ff ff ff       	mov    $0xffffffff,%esi
  685b0b:	74 12                	je     685b1f <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x86f>
  685b0d:	4c 89 ea             	mov    %r13,%rdx
  685b10:	48 29 ca             	sub    %rcx,%rdx
  685b13:	48 89 30             	mov    %rsi,(%rax)
  685b16:	48 83 c0 08          	add    $0x8,%rax
  685b1a:	48 ff ca             	dec    %rdx
  685b1d:	75 f4                	jne    685b13 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x863>
  685b1f:	4d 01 ef             	add    %r13,%r15
  685b22:	49 ff cf             	dec    %r15
  685b25:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  685b2a:	48 89 08             	mov    %rcx,(%rax)
  685b2d:	49 ff c7             	inc    %r15
  685b30:	4c 89 7c 24 48       	mov    %r15,0x48(%rsp)
  685b35:	4c 8b 6c 24 40       	mov    0x40(%rsp),%r13
  685b3a:	31 c0                	xor    %eax,%eax
  685b3c:	eb 13                	jmp    685b51 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x8a1>
  685b3e:	66 90                	xchg   %ax,%ax
  685b40:	41 89 44 fd 00       	mov    %eax,0x0(%r13,%rdi,8)
  685b45:	48 83 c5 28          	add    $0x28,%rbp
  685b49:	48 ff c0             	inc    %rax
  685b4c:	48 39 eb             	cmp    %rbp,%rbx
  685b4f:	74 3c                	je     685b8d <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x8dd>
  685b51:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  685b56:	80 7c 29 21 00       	cmpb   $0x0,0x21(%rcx,%rbp,1)
  685b5b:	75 e8                	jne    685b45 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x895>
  685b5d:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  685b62:	48 8b 7c 29 10       	mov    0x10(%rcx,%rbp,1),%rdi
  685b67:	4c 29 cf             	sub    %r9,%rdi
  685b6a:	4c 39 ff             	cmp    %r15,%rdi
  685b6d:	0f 83 04 03 00 00    	jae    685e77 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbc7>
  685b73:	41 83 7c fd 00 ff    	cmpl   $0xffffffff,0x0(%r13,%rdi,8)
  685b79:	0f 85 e3 01 00 00    	jne    685d62 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  685b7f:	48 89 c1             	mov    %rax,%rcx
  685b82:	48 c1 e9 20          	shr    $0x20,%rcx
  685b86:	74 b8                	je     685b40 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x890>
  685b88:	e9 d5 01 00 00       	jmp    685d62 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  685b8d:	48 8b 9c 24 90 00 00 	mov    0x90(%rsp),%rbx
  685b94:	00 
  685b95:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  685b9c:	00 
  685b9d:	48 8b 78 10          	mov    0x10(%rax),%rdi
  685ba1:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  685ba6:	48 8b 70 18          	mov    0x18(%rax),%rsi
  685baa:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
  685bb1:	48 39 fe             	cmp    %rdi,%rsi
  685bb4:	0f 83 fc f8 ff ff    	jae    6854b6 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x206>
  685bba:	e9 2e 02 00 00       	jmp    685ded <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb3d>
  685bbf:	4d 89 cc             	mov    %r9,%r12
  685bc2:	b9 04 00 00 00       	mov    $0x4,%ecx
  685bc7:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  685bcd:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  685bd2:	31 f6                	xor    %esi,%esi
  685bd4:	4c 89 ea             	mov    %r13,%rdx
  685bd7:	e8 54 e0 fd ff       	call   663c30 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  685bdc:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  685be1:	4d 89 e1             	mov    %r12,%r9
  685be4:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  685be9:	4a 8d 04 ff          	lea    (%rdi,%r15,8),%rax
  685bed:	49 83 fd 01          	cmp    $0x1,%r13
  685bf1:	0f 85 bc fe ff ff    	jne    685ab3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x803>
  685bf7:	e9 29 ff ff ff       	jmp    685b25 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x875>
  685bfc:	4c 8d bc 24 20 01 00 	lea    0x120(%rsp),%r15
  685c03:	00 
  685c04:	31 ed                	xor    %ebp,%ebp
  685c06:	4c 8d a4 24 e8 01 00 	lea    0x1e8(%rsp),%r12
  685c0d:	00 
  685c0e:	48 8b 1d 0b 3b 10 00 	mov    0x103b0b(%rip),%rbx        # 789720 <_DYNAMIC+0x908>
  685c15:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  685c1c:	00 00 00 00 
  685c20:	4c 8b b4 24 30 02 00 	mov    0x230(%rsp),%r14
  685c27:	00 
  685c28:	49 83 fe 02          	cmp    $0x2,%r14
  685c2c:	75 20                	jne    685c4e <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x99e>
  685c2e:	48 8d bc 24 40 02 00 	lea    0x240(%rsp),%rdi
  685c35:	00 
  685c36:	e8 55 e9 fe ff       	call   674590 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  685c3b:	49 89 c6             	mov    %rax,%r14
  685c3e:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  685c45:	00 
  685c46:	48 89 94 24 38 02 00 	mov    %rdx,0x238(%rsp)
  685c4d:	00 
  685c4e:	49 83 fe 01          	cmp    $0x1,%r14
  685c52:	0f 85 0a 01 00 00    	jne    685d62 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  685c58:	4c 8b ac 24 38 02 00 	mov    0x238(%rsp),%r13
  685c5f:	00 
  685c60:	83 bc 24 b8 00 00 00 	cmpl   $0x1,0xb8(%rsp)
  685c67:	01 
  685c68:	75 0e                	jne    685c78 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x9c8>
  685c6a:	4c 3b ac 24 c0 00 00 	cmp    0xc0(%rsp),%r13
  685c71:	00 
  685c72:	0f 82 ea 00 00 00    	jb     685d62 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xab2>
  685c78:	48 c7 84 24 30 02 00 	movq   $0x2,0x230(%rsp)
  685c7f:	00 02 00 00 00 
  685c84:	48 c7 84 24 b8 00 00 	movq   $0x1,0xb8(%rsp)
  685c8b:	00 01 00 00 00 
  685c90:	4c 39 ac 24 c8 00 00 	cmp    %r13,0xc8(%rsp)
  685c97:	00 
  685c98:	b9 00 00 00 00       	mov    $0x0,%ecx
  685c9d:	48 8d 84 24 a8 01 00 	lea    0x1a8(%rsp),%rax
  685ca4:	00 
  685ca5:	48 0f 44 c8          	cmove  %rax,%rcx
  685ca9:	80 bc 24 a4 01 00 00 	cmpb   $0x0,0x1a4(%rsp)
  685cb0:	00 
  685cb1:	4c 89 ac 24 c0 00 00 	mov    %r13,0xc0(%rsp)
  685cb8:	00 
  685cb9:	48 0f 44 cd          	cmove  %rbp,%rcx
  685cbd:	f3 0f 10 44 24 20    	movss  0x20(%rsp),%xmm0
  685cc3:	4c 89 e7             	mov    %r12,%rdi
  685cc6:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  685ccb:	4c 89 ea             	mov    %r13,%rdx
  685cce:	45 31 c0             	xor    %r8d,%r8d
  685cd1:	ff d3                	call   *%rbx
  685cd3:	48 8b 84 24 28 02 00 	mov    0x228(%rsp),%rax
  685cda:	00 
  685cdb:	49 89 47 40          	mov    %rax,0x40(%r15)
  685cdf:	0f 10 84 24 e8 01 00 	movups 0x1e8(%rsp),%xmm0
  685ce6:	00 
  685ce7:	0f 10 8c 24 f8 01 00 	movups 0x1f8(%rsp),%xmm1
  685cee:	00 
  685cef:	0f 10 94 24 08 02 00 	movups 0x208(%rsp),%xmm2
  685cf6:	00 
  685cf7:	0f 10 9c 24 18 02 00 	movups 0x218(%rsp),%xmm3
  685cfe:	00 
  685cff:	41 0f 11 5f 30       	movups %xmm3,0x30(%r15)
  685d04:	41 0f 11 57 20       	movups %xmm2,0x20(%r15)
  685d09:	41 0f 11 4f 10       	movups %xmm1,0x10(%r15)
  685d0e:	41 0f 11 07          	movups %xmm0,(%r15)
  685d12:	4c 8b b4 24 b0 00 00 	mov    0xb0(%rsp),%r14
  685d19:	00 
  685d1a:	4c 89 ac 24 18 01 00 	mov    %r13,0x118(%rsp)
  685d21:	00 
  685d22:	83 bc 24 20 01 00 00 	cmpl   $0x1,0x120(%rsp)
  685d29:	01 
  685d2a:	0f 85 f0 fe ff ff    	jne    685c20 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x970>
  685d30:	49 8b 7e 08          	mov    0x8(%r14),%rdi
  685d34:	49 8b 76 10          	mov    0x10(%r14),%rsi
  685d38:	49 8b 46 18          	mov    0x18(%r14),%rax
  685d3c:	48 8b 10             	mov    (%rax),%rdx
  685d3f:	49 8b 46 20          	mov    0x20(%r14),%rax
  685d43:	f3 0f 10 00          	movss  (%rax),%xmm0
  685d47:	4c 89 e9             	mov    %r13,%rcx
  685d4a:	4d 89 f8             	mov    %r15,%r8
  685d4d:	e8 ae ad ff ff       	call   680b00 <gpui_canvas::text::planner::append_caret>
  685d52:	83 f8 ff             	cmp    $0xffffffff,%eax
  685d55:	0f 95 c0             	setne  %al
  685d58:	49 8b 0e             	mov    (%r14),%rcx
  685d5b:	08 01                	or     %al,(%rcx)
  685d5d:	e9 be fe ff ff       	jmp    685c20 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0x970>
  685d62:	48 8b b4 24 40 02 00 	mov    0x240(%rsp),%rsi
  685d69:	00 
  685d6a:	48 85 f6             	test   %rsi,%rsi
  685d6d:	74 17                	je     685d86 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xad6>
  685d6f:	48 8b bc 24 48 02 00 	mov    0x248(%rsp),%rdi
  685d76:	00 
  685d77:	48 c1 e6 03          	shl    $0x3,%rsi
  685d7b:	ba 08 00 00 00       	mov    $0x8,%edx
  685d80:	ff 15 ca 32 10 00    	call   *0x1032ca(%rip)        # 789050 <_DYNAMIC+0x238>
  685d86:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  685d8b:	48 85 f6             	test   %rsi,%rsi
  685d8e:	74 14                	je     685da4 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xaf4>
  685d90:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
  685d95:	48 c1 e6 02          	shl    $0x2,%rsi
  685d99:	ba 04 00 00 00       	mov    $0x4,%edx
  685d9e:	ff 15 ac 32 10 00    	call   *0x1032ac(%rip)        # 789050 <_DYNAMIC+0x238>
  685da4:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  685da9:	48 85 f6             	test   %rsi,%rsi
  685dac:	74 14                	je     685dc2 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xb12>
  685dae:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  685db3:	48 c1 e6 03          	shl    $0x3,%rsi
  685db7:	ba 04 00 00 00       	mov    $0x4,%edx
  685dbc:	ff 15 8e 32 10 00    	call   *0x10328e(%rip)        # 789050 <_DYNAMIC+0x238>
  685dc2:	41 80 e6 01          	and    $0x1,%r14b
  685dc6:	44 89 f0             	mov    %r14d,%eax
  685dc9:	48 81 c4 d8 02 00 00 	add    $0x2d8,%rsp
  685dd0:	5b                   	pop    %rbx
  685dd1:	41 5c                	pop    %r12
  685dd3:	41 5d                	pop    %r13
  685dd5:	41 5e                	pop    %r14
  685dd7:	41 5f                	pop    %r15
  685dd9:	5d                   	pop    %rbp
  685dda:	c3                   	ret
  685ddb:	48 8d 0d 06 99 0f 00 	lea    0xf9906(%rip),%rcx        # 77f6e8 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941+0x30>
  685de2:	ff 15 88 35 10 00    	call   *0x103588(%rip)        # 789370 <_DYNAMIC+0x558>
  685de8:	e9 88 00 00 00       	jmp    685e75 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbc5>
  685ded:	48 8d 0d 84 96 0f 00 	lea    0xf9684(%rip),%rcx        # 77f478 <anon.d4a86088305c8823b863e6abd2e38045.32.llvm.2509172480284221941>
  685df4:	ff 15 76 35 10 00    	call   *0x103576(%rip)        # 789370 <_DYNAMIC+0x558>
  685dfa:	eb 79                	jmp    685e75 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbc5>
  685dfc:	48 8b 41 10          	mov    0x10(%rcx),%rax
  685e00:	49 3b 46 40          	cmp    0x40(%r14),%rax
  685e04:	48 8d 05 0d 99 0f 00 	lea    0xf990d(%rip),%rax        # 77f718 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941+0x60>
  685e0b:	48 8d 0d ee 98 0f 00 	lea    0xf98ee(%rip),%rcx        # 77f700 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941+0x48>
  685e12:	48 0f 42 c8          	cmovb  %rax,%rcx
  685e16:	48 89 8c 24 a8 00 00 	mov    %rcx,0xa8(%rsp)
  685e1d:	00 
  685e1e:	48 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%rdi
  685e25:	00 
  685e26:	ff 15 24 33 10 00    	call   *0x103324(%rip)        # 789150 <_DYNAMIC+0x338>
  685e2c:	eb 47                	jmp    685e75 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbc5>
  685e2e:	48 8d 05 8b 99 0f 00 	lea    0xf998b(%rip),%rax        # 77f7c0 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941+0x108>
  685e35:	eb 2e                	jmp    685e65 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbb5>
  685e37:	48 8d 05 6a 99 0f 00 	lea    0xf996a(%rip),%rax        # 77f7a8 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941+0xf0>
  685e3e:	eb 25                	jmp    685e65 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbb5>
  685e40:	48 8d 05 31 99 0f 00 	lea    0xf9931(%rip),%rax        # 77f778 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941+0xc0>
  685e47:	eb 1c                	jmp    685e65 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbb5>
  685e49:	48 8d 05 40 99 0f 00 	lea    0xf9940(%rip),%rax        # 77f790 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941+0xd8>
  685e50:	eb 13                	jmp    685e65 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbb5>
  685e52:	48 8d 05 d7 98 0f 00 	lea    0xf98d7(%rip),%rax        # 77f730 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941+0x78>
  685e59:	eb 0a                	jmp    685e65 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbb5>
  685e5b:	4c 89 fe             	mov    %r15,%rsi
  685e5e:	48 8d 05 e3 98 0f 00 	lea    0xf98e3(%rip),%rax        # 77f748 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941+0x90>
  685e65:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  685e6a:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  685e6f:	ff 15 03 33 10 00    	call   *0x103303(%rip)        # 789178 <_DYNAMIC+0x360>
  685e75:	0f 0b                	ud2
  685e77:	4c 89 fe             	mov    %r15,%rsi
  685e7a:	eb ee                	jmp    685e6a <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbba>
  685e7c:	eb 08                	jmp    685e86 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbd6>
  685e7e:	eb 06                	jmp    685e86 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbd6>
  685e80:	eb 04                	jmp    685e86 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbd6>
  685e82:	eb 02                	jmp    685e86 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbd6>
  685e84:	eb 00                	jmp    685e86 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbd6>
  685e86:	48 89 c3             	mov    %rax,%rbx
  685e89:	48 8b b4 24 40 02 00 	mov    0x240(%rsp),%rsi
  685e90:	00 
  685e91:	48 85 f6             	test   %rsi,%rsi
  685e94:	75 1c                	jne    685eb2 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xc02>
  685e96:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  685e9b:	48 85 f6             	test   %rsi,%rsi
  685e9e:	75 33                	jne    685ed3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xc23>
  685ea0:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  685ea5:	48 85 f6             	test   %rsi,%rsi
  685ea8:	75 47                	jne    685ef1 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xc41>
  685eaa:	48 89 df             	mov    %rbx,%rdi
  685ead:	e8 be 70 0f 00       	call   77cf70 <_Unwind_Resume@plt>
  685eb2:	48 8b bc 24 48 02 00 	mov    0x248(%rsp),%rdi
  685eb9:	00 
  685eba:	48 c1 e6 03          	shl    $0x3,%rsi
  685ebe:	ba 08 00 00 00       	mov    $0x8,%edx
  685ec3:	ff 15 87 31 10 00    	call   *0x103187(%rip)        # 789050 <_DYNAMIC+0x238>
  685ec9:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  685ece:	48 85 f6             	test   %rsi,%rsi
  685ed1:	74 cd                	je     685ea0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbf0>
  685ed3:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
  685ed8:	48 c1 e6 02          	shl    $0x2,%rsi
  685edc:	ba 04 00 00 00       	mov    $0x4,%edx
  685ee1:	ff 15 69 31 10 00    	call   *0x103169(%rip)        # 789050 <_DYNAMIC+0x238>
  685ee7:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  685eec:	48 85 f6             	test   %rsi,%rsi
  685eef:	74 b9                	je     685eaa <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>+0xbfa>
  685ef1:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  685ef6:	48 c1 e6 03          	shl    $0x3,%rsi
  685efa:	ba 04 00 00 00       	mov    $0x4,%edx
  685eff:	ff 15 4b 31 10 00    	call   *0x10314b(%rip)        # 789050 <_DYNAMIC+0x238>
  685f05:	48 89 df             	mov    %rbx,%rdi
  685f08:	e8 63 70 0f 00       	call   77cf70 <_Unwind_Resume@plt>
