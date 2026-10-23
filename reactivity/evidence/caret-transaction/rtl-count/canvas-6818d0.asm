
/tmp/gpui-caret-transaction-bin/d54-caret-pair-measure:     file format elf64-x86-64


Disassembly of section .text:

00000000006818d0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>>:
  6818d0:	55                   	push   %rbp
  6818d1:	41 57                	push   %r15
  6818d3:	41 56                	push   %r14
  6818d5:	41 55                	push   %r13
  6818d7:	41 54                	push   %r12
  6818d9:	53                   	push   %rbx
  6818da:	48 81 ec 68 01 00 00 	sub    $0x168,%rsp
  6818e1:	48 89 cb             	mov    %rcx,%rbx
  6818e4:	49 89 d6             	mov    %rdx,%r14
  6818e7:	89 f2                	mov    %esi,%edx
  6818e9:	48 89 fe             	mov    %rdi,%rsi
  6818ec:	4c 8d 7c 24 58       	lea    0x58(%rsp),%r15
  6818f1:	4c 89 ff             	mov    %r15,%rdi
  6818f4:	e8 17 1a 00 00       	call   683310 <<parley::layout::run::Clusters<()>>::new>
  6818f9:	f3 0f 10 03          	movss  (%rbx),%xmm0
  6818fd:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  681903:	48 8d 7c 24 24       	lea    0x24(%rsp),%rdi
  681908:	4c 89 fe             	mov    %r15,%rsi
  68190b:	e8 f0 1c 00 00       	call   683600 <<parley::layout::run::Clusters<()>>::advance_cursor>
  681910:	83 7c 24 24 01       	cmpl   $0x1,0x24(%rsp)
  681915:	0f 85 0c 01 00 00    	jne    681a27 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0x157>
  68191b:	4c 8d a4 24 10 01 00 	lea    0x110(%rsp),%r12
  681922:	00 
  681923:	4c 8d 6c 24 48       	lea    0x48(%rsp),%r13
  681928:	eb 74                	jmp    68199e <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0xce>
  68192a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  681930:	0f 57 c0             	xorps  %xmm0,%xmm0
  681933:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  681938:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  68193d:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  681942:	f2 0f 10 4a 44       	movsd  0x44(%rdx),%xmm1
  681947:	f2 0f 11 4c 24 10    	movsd  %xmm1,0x10(%rsp)
  68194d:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
  681953:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  681957:	0f b6 89 8c 00 00 00 	movzbl 0x8c(%rcx),%ecx
  68195e:	83 e1 01             	and    $0x1,%ecx
  681961:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  681966:	4c 89 e6             	mov    %r12,%rsi
  681969:	4c 89 ea             	mov    %r13,%rdx
  68196c:	ff 15 a6 7d 10 00    	call   *0x107da6(%rip)        # 789718 <_DYNAMIC+0x900>
  681972:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  681978:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  68197c:	f3 0f 11 4c 24 0c    	movss  %xmm1,0xc(%rsp)
  681982:	f3 0f 11 0b          	movss  %xmm1,(%rbx)
  681986:	48 8d 7c 24 24       	lea    0x24(%rsp),%rdi
  68198b:	4c 89 fe             	mov    %r15,%rsi
  68198e:	e8 6d 1c 00 00       	call   683600 <<parley::layout::run::Clusters<()>>::advance_cursor>
  681993:	80 7c 24 24 00       	cmpb   $0x0,0x24(%rsp)
  681998:	0f 84 89 00 00 00    	je     681a27 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0x157>
  68199e:	48 83 bc 24 10 01 00 	cmpq   $0x0,0x110(%rsp)
  6819a5:	00 00 
  6819a7:	0f 84 8c 00 00 00    	je     681a39 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0x169>
  6819ad:	4c 89 7c 24 38       	mov    %r15,0x38(%rsp)
  6819b2:	4c 89 64 24 40       	mov    %r12,0x40(%rsp)
  6819b7:	48 8d 44 24 28       	lea    0x28(%rsp),%rax
  6819bc:	0f 10 00             	movups (%rax),%xmm0
  6819bf:	41 0f 11 45 00       	movups %xmm0,0x0(%r13)
  6819c4:	49 8b 6e 10          	mov    0x10(%r14),%rbp
  6819c8:	49 3b 2e             	cmp    (%r14),%rbp
  6819cb:	75 09                	jne    6819d6 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0x106>
  6819cd:	4c 89 f7             	mov    %r14,%rdi
  6819d0:	ff 15 1a 79 10 00    	call   *0x10791a(%rip)        # 7892f0 <_DYNAMIC+0x4d8>
  6819d6:	49 8b 46 08          	mov    0x8(%r14),%rax
  6819da:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  6819e0:	f3 0f 11 04 a8       	movss  %xmm0,(%rax,%rbp,4)
  6819e5:	48 ff c5             	inc    %rbp
  6819e8:	49 89 6e 10          	mov    %rbp,0x10(%r14)
  6819ec:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
  6819f2:	0f 84 38 ff ff ff    	je     681930 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0x60>
  6819f8:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6819fd:	8b 7c 24 78          	mov    0x78(%rsp),%edi
  681a01:	48 8b b0 18 01 00 00 	mov    0x118(%rax),%rsi
  681a08:	48 39 fe             	cmp    %rdi,%rsi
  681a0b:	76 45                	jbe    681a52 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0x182>
  681a0d:	48 8b 80 10 01 00 00 	mov    0x110(%rax),%rax
  681a14:	48 6b cf 70          	imul   $0x70,%rdi,%rcx
  681a18:	f3 0f 10 44 08 50    	movss  0x50(%rax,%rcx,1),%xmm0
  681a1e:	8b 44 08 54          	mov    0x54(%rax,%rcx,1),%eax
  681a22:	e9 11 ff ff ff       	jmp    681938 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::convert::Infallible, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#1}>+0x68>
  681a27:	48 81 c4 68 01 00 00 	add    $0x168,%rsp
  681a2e:	5b                   	pop    %rbx
  681a2f:	41 5c                	pop    %r12
  681a31:	41 5d                	pop    %r13
  681a33:	41 5e                	pop    %r14
  681a35:	41 5f                	pop    %r15
  681a37:	5d                   	pop    %rbp
  681a38:	c3                   	ret
  681a39:	48 8d 3d 20 c9 bd ff 	lea    -0x4236e0(%rip),%rdi        # 25e360 <anon.d4a86088305c8823b863e6abd2e38045.0.llvm.4134324091787671213>
  681a40:	48 8d 15 81 d8 0f 00 	lea    0xfd881(%rip),%rdx        # 77f2c8 <anon.d4a86088305c8823b863e6abd2e38045.2.llvm.4134324091787671213>
  681a47:	be 63 00 00 00       	mov    $0x63,%esi
  681a4c:	ff 15 a6 78 10 00    	call   *0x1078a6(%rip)        # 7892f8 <_DYNAMIC+0x4e0>
  681a52:	48 8d 15 87 d8 0f 00 	lea    0xfd887(%rip),%rdx        # 77f2e0 <anon.d4a86088305c8823b863e6abd2e38045.3.llvm.4134324091787671213>
  681a59:	ff 15 19 77 10 00    	call   *0x107719(%rip)        # 789178 <_DYNAMIC+0x360>
