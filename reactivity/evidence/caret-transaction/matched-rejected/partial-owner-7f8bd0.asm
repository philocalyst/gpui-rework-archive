
/tmp/gpui-caret-transaction-bin/matched-partial-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007f8bd0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>>:
  7f8bd0:	55                   	push   %rbp
  7f8bd1:	41 57                	push   %r15
  7f8bd3:	41 56                	push   %r14
  7f8bd5:	41 55                	push   %r13
  7f8bd7:	41 54                	push   %r12
  7f8bd9:	53                   	push   %rbx
  7f8bda:	48 81 ec 88 02 00 00 	sub    $0x288,%rsp
  7f8be1:	48 89 d3             	mov    %rdx,%rbx
  7f8be4:	89 f2                	mov    %esi,%edx
  7f8be6:	48 89 fe             	mov    %rdi,%rsi
  7f8be9:	4c 8d b4 24 78 01 00 	lea    0x178(%rsp),%r14
  7f8bf0:	00 
  7f8bf1:	4c 89 f7             	mov    %r14,%rdi
  7f8bf4:	e8 77 1d 00 00       	call   7fa970 <<parley::layout::run::Clusters<()>>::new>
  7f8bf9:	48 8b 03             	mov    (%rbx),%rax
  7f8bfc:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  7f8c03:	00 
  7f8c04:	48 8b 43 08          	mov    0x8(%rbx),%rax
  7f8c08:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  7f8c0d:	48 8b 43 18          	mov    0x18(%rbx),%rax
  7f8c11:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  7f8c18:	00 
  7f8c19:	48 8b 43 10          	mov    0x10(%rbx),%rax
  7f8c1d:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  7f8c22:	48 8b 43 20          	mov    0x20(%rbx),%rax
  7f8c26:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  7f8c2d:	00 
  7f8c2e:	48 8b 6b 28          	mov    0x28(%rbx),%rbp
  7f8c32:	48 8b 43 30          	mov    0x30(%rbx),%rax
  7f8c36:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  7f8c3b:	4c 8b 6b 40          	mov    0x40(%rbx),%r13
  7f8c3f:	4c 8b 7b 48          	mov    0x48(%rbx),%r15
  7f8c43:	48 8b 43 50          	mov    0x50(%rbx),%rax
  7f8c47:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  7f8c4c:	4c 8b 63 78          	mov    0x78(%rbx),%r12
  7f8c50:	48 8b 83 80 00 00 00 	mov    0x80(%rbx),%rax
  7f8c57:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  7f8c5c:	48 8b 43 38          	mov    0x38(%rbx),%rax
  7f8c60:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  7f8c65:	48 8b 43 60          	mov    0x60(%rbx),%rax
  7f8c69:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  7f8c6e:	48 8b 43 68          	mov    0x68(%rbx),%rax
  7f8c72:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  7f8c77:	48 8b 43 70          	mov    0x70(%rbx),%rax
  7f8c7b:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  7f8c80:	48 8b 43 58          	mov    0x58(%rbx),%rax
  7f8c84:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  7f8c8b:	00 
  7f8c8c:	48 8d bc 24 f4 00 00 	lea    0xf4(%rsp),%rdi
  7f8c93:	00 
  7f8c94:	4c 89 f6             	mov    %r14,%rsi
  7f8c97:	e8 c4 1f 00 00       	call   7fac60 <<parley::layout::run::Clusters<()>>::advance_cursor>
  7f8c9c:	b0 02                	mov    $0x2,%al
  7f8c9e:	83 bc 24 f4 00 00 00 	cmpl   $0x1,0xf4(%rsp)
  7f8ca5:	01 
  7f8ca6:	0f 85 b4 05 00 00    	jne    7f9260 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x690>
  7f8cac:	4c 89 e3             	mov    %r12,%rbx
  7f8caf:	49 8d 44 24 04       	lea    0x4(%r12),%rax
  7f8cb4:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  7f8cb9:	4c 8d a4 24 30 01 00 	lea    0x130(%rsp),%r12
  7f8cc0:	00 
  7f8cc1:	48 89 ac 24 98 00 00 	mov    %rbp,0x98(%rsp)
  7f8cc8:	00 
  7f8cc9:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
  7f8cce:	eb 2e                	jmp    7f8cfe <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x12e>
  7f8cd0:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7f8cd5:	c6 00 00             	movb   $0x0,(%rax)
  7f8cd8:	48 8d bc 24 f4 00 00 	lea    0xf4(%rsp),%rdi
  7f8cdf:	00 
  7f8ce0:	4c 8d b4 24 78 01 00 	lea    0x178(%rsp),%r14
  7f8ce7:	00 
  7f8ce8:	4c 89 f6             	mov    %r14,%rsi
  7f8ceb:	e8 70 1f 00 00       	call   7fac60 <<parley::layout::run::Clusters<()>>::advance_cursor>
  7f8cf0:	80 bc 24 f4 00 00 00 	cmpb   $0x0,0xf4(%rsp)
  7f8cf7:	00 
  7f8cf8:	0f 84 60 05 00 00    	je     7f925e <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68e>
  7f8cfe:	48 83 bc 24 30 02 00 	cmpq   $0x0,0x230(%rsp)
  7f8d05:	00 00 
  7f8d07:	0f 84 65 05 00 00    	je     7f9272 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x6a2>
  7f8d0d:	4c 89 b4 24 08 01 00 	mov    %r14,0x108(%rsp)
  7f8d14:	00 
  7f8d15:	48 8d 84 24 30 02 00 	lea    0x230(%rsp),%rax
  7f8d1c:	00 
  7f8d1d:	48 89 84 24 10 01 00 	mov    %rax,0x110(%rsp)
  7f8d24:	00 
  7f8d25:	48 8d 84 24 f8 00 00 	lea    0xf8(%rsp),%rax
  7f8d2c:	00 
  7f8d2d:	0f 10 00             	movups (%rax),%xmm0
  7f8d30:	48 8d 84 24 18 01 00 	lea    0x118(%rsp),%rax
  7f8d37:	00 
  7f8d38:	0f 11 00             	movups %xmm0,(%rax)
  7f8d3b:	8b 9c 24 18 01 00 00 	mov    0x118(%rsp),%ebx
  7f8d42:	8b 94 24 1c 01 00 00 	mov    0x11c(%rsp),%edx
  7f8d49:	48 8b bc 24 90 00 00 	mov    0x90(%rsp),%rdi
  7f8d50:	00 
  7f8d51:	89 de                	mov    %ebx,%esi
  7f8d53:	ff 15 17 56 33 00    	call   *0x335617(%rip)        # b2e370 <_DYNAMIC+0xe70>
  7f8d59:	49 89 c6             	mov    %rax,%r14
  7f8d5c:	49 89 d0             	mov    %rdx,%r8
  7f8d5f:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  7f8d64:	48 8b 80 50 01 00 00 	mov    0x150(%rax),%rax
  7f8d6b:	48 85 c0             	test   %rax,%rax
  7f8d6e:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  7f8d75:	00 
  7f8d76:	74 37                	je     7f8daf <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x1df>
  7f8d78:	4d 39 c6             	cmp    %r8,%r14
  7f8d7b:	0f 87 d9 04 00 00    	ja     7f925a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68a>
  7f8d81:	49 39 c0             	cmp    %rax,%r8
  7f8d84:	0f 87 d0 04 00 00    	ja     7f925a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68a>
  7f8d8a:	4d 39 c6             	cmp    %r8,%r14
  7f8d8d:	73 31                	jae    7f8dc0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x1f0>
  7f8d8f:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  7f8d94:	4c 3b 30             	cmp    (%rax),%r14
  7f8d97:	0f 82 bd 04 00 00    	jb     7f925a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68a>
  7f8d9d:	83 7a 04 00          	cmpl   $0x0,0x4(%rdx)
  7f8da1:	0f 85 b3 04 00 00    	jne    7f925a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68a>
  7f8da7:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  7f8dac:	4c 89 00             	mov    %r8,(%rax)
  7f8daf:	48 8b 02             	mov    (%rdx),%rax
  7f8db2:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f8db6:	75 18                	jne    7f8dd0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x200>
  7f8db8:	e9 9d 04 00 00       	jmp    7f925a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68a>
  7f8dbd:	0f 1f 00             	nopl   (%rax)
  7f8dc0:	48 8b 02             	mov    (%rdx),%rax
  7f8dc3:	48 89 c1             	mov    %rax,%rcx
  7f8dc6:	48 c1 e9 20          	shr    $0x20,%rcx
  7f8dca:	0f 85 8a 04 00 00    	jne    7f925a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68a>
  7f8dd0:	48 ff c0             	inc    %rax
  7f8dd3:	48 89 02             	mov    %rax,(%rdx)
  7f8dd6:	48 8b 84 24 80 01 00 	mov    0x180(%rsp),%rax
  7f8ddd:	00 
  7f8dde:	0f b6 80 8c 00 00 00 	movzbl 0x8c(%rax),%eax
  7f8de5:	88 44 24 03          	mov    %al,0x3(%rsp)
  7f8de9:	a8 01                	test   $0x1,%al
  7f8deb:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
  7f8df0:	75 5e                	jne    7f8e50 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x280>
  7f8df2:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7f8df7:	f3 0f 10 00          	movss  (%rax),%xmm0
  7f8dfb:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  7f8e01:	48 83 bc 24 90 01 00 	cmpq   $0x0,0x190(%rsp)
  7f8e08:	00 00 
  7f8e0a:	0f 84 80 00 00 00    	je     7f8e90 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x2c0>
  7f8e10:	48 8b 84 24 78 01 00 	mov    0x178(%rsp),%rax
  7f8e17:	00 
  7f8e18:	8b bc 24 98 01 00 00 	mov    0x198(%rsp),%edi
  7f8e1f:	48 8b b0 18 01 00 00 	mov    0x118(%rax),%rsi
  7f8e26:	48 39 fe             	cmp    %rdi,%rsi
  7f8e29:	0f 86 69 04 00 00    	jbe    7f9298 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x6c8>
  7f8e2f:	48 8b 80 10 01 00 00 	mov    0x110(%rax),%rax
  7f8e36:	48 6b cf 70          	imul   $0x70,%rdi,%rcx
  7f8e3a:	f3 0f 10 44 08 50    	movss  0x50(%rax,%rcx,1),%xmm0
  7f8e40:	8b 44 08 54          	mov    0x54(%rax,%rcx,1),%eax
  7f8e44:	eb 52                	jmp    7f8e98 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x2c8>
  7f8e46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  7f8e4d:	00 00 00 
  7f8e50:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  7f8e57:	00 
  7f8e58:	48 8b 71 10          	mov    0x10(%rcx),%rsi
  7f8e5c:	48 8b 45 00          	mov    0x0(%rbp),%rax
  7f8e60:	48 89 c7             	mov    %rax,%rdi
  7f8e63:	48 f7 d7             	not    %rdi
  7f8e66:	48 01 f7             	add    %rsi,%rdi
  7f8e69:	0f 83 1c 04 00 00    	jae    7f928b <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x6bb>
  7f8e6f:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  7f8e73:	f3 0f 10 04 b9       	movss  (%rcx,%rdi,4),%xmm0
  7f8e78:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  7f8e7e:	48 ff c0             	inc    %rax
  7f8e81:	48 89 45 00          	mov    %rax,0x0(%rbp)
  7f8e85:	4d 39 c6             	cmp    %r8,%r14
  7f8e88:	0f 83 42 fe ff ff    	jae    7f8cd0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x100>
  7f8e8e:	eb 74                	jmp    7f8f04 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x334>
  7f8e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  7f8e95:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f8e98:	48 8b 8c 24 88 01 00 	mov    0x188(%rsp),%rcx
  7f8e9f:	00 
  7f8ea0:	f2 0f 10 49 44       	movsd  0x44(%rcx),%xmm1
  7f8ea5:	f2 0f 11 8c 24 28 01 	movsd  %xmm1,0x128(%rsp)
  7f8eac:	00 00 
  7f8eae:	f3 0f 11 84 24 30 01 	movss  %xmm0,0x130(%rsp)
  7f8eb5:	00 00 
  7f8eb7:	89 84 24 34 01 00 00 	mov    %eax,0x134(%rsp)
  7f8ebe:	48 8d bc 24 28 01 00 	lea    0x128(%rsp),%rdi
  7f8ec5:	00 
  7f8ec6:	48 8d b4 24 30 02 00 	lea    0x230(%rsp),%rsi
  7f8ecd:	00 
  7f8ece:	48 8d 94 24 18 01 00 	lea    0x118(%rsp),%rdx
  7f8ed5:	00 
  7f8ed6:	31 c9                	xor    %ecx,%ecx
  7f8ed8:	ff 15 a2 54 33 00    	call   *0x3354a2(%rip)        # b2e380 <_DYNAMIC+0xe80>
  7f8ede:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7f8ee3:	f3 0f 58 00          	addss  (%rax),%xmm0
  7f8ee7:	f3 0f 11 00          	movss  %xmm0,(%rax)
  7f8eeb:	48 8b 45 00          	mov    0x0(%rbp),%rax
  7f8eef:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  7f8ef4:	48 ff c0             	inc    %rax
  7f8ef7:	48 89 45 00          	mov    %rax,0x0(%rbp)
  7f8efb:	4d 39 c6             	cmp    %r8,%r14
  7f8efe:	0f 83 cc fd ff ff    	jae    7f8cd0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x100>
  7f8f04:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  7f8f09:	48 83 b8 50 01 00 00 	cmpq   $0x0,0x150(%rax)
  7f8f10:	00 
  7f8f11:	0f 84 b9 fd ff ff    	je     7f8cd0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x100>
  7f8f17:	48 8b 84 24 98 01 00 	mov    0x198(%rsp),%rax
  7f8f1e:	00 
  7f8f1f:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  7f8f24:	89 5c 24 70          	mov    %ebx,0x70(%rsp)
  7f8f28:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  7f8f2e:	f3 0f 11 44 24 74    	movss  %xmm0,0x74(%rsp)
  7f8f34:	0f b7 84 24 24 01 00 	movzwl 0x124(%rsp),%eax
  7f8f3b:	00 
  7f8f3c:	83 e0 0e             	and    $0xe,%eax
  7f8f3f:	89 44 24 14          	mov    %eax,0x14(%rsp)
  7f8f43:	eb 13                	jmp    7f8f58 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x388>
  7f8f45:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  7f8f4c:	00 00 00 00 
  7f8f50:	48 8b ac 24 98 00 00 	mov    0x98(%rsp),%rbp
  7f8f57:	00 
  7f8f58:	49 8b 45 00          	mov    0x0(%r13),%rax
  7f8f5c:	48 83 f8 02          	cmp    $0x2,%rax
  7f8f60:	75 16                	jne    7f8f78 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x3a8>
  7f8f62:	49 8d 7d 10          	lea    0x10(%r13),%rdi
  7f8f66:	e8 35 4e 01 00       	call   80dda0 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  7f8f6b:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  7f8f70:	49 89 45 00          	mov    %rax,0x0(%r13)
  7f8f74:	49 89 55 08          	mov    %rdx,0x8(%r13)
  7f8f78:	48 83 f8 01          	cmp    $0x1,%rax
  7f8f7c:	0f 85 8e 02 00 00    	jne    7f9210 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x640>
  7f8f82:	49 8b 5d 08          	mov    0x8(%r13),%rbx
  7f8f86:	4c 39 c3             	cmp    %r8,%rbx
  7f8f89:	0f 83 81 02 00 00    	jae    7f9210 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x640>
  7f8f8f:	41 80 3f 00          	cmpb   $0x0,(%r15)
  7f8f93:	74 0a                	je     7f8f9f <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x3cf>
  7f8f95:	49 3b 5f 08          	cmp    0x8(%r15),%rbx
  7f8f99:	0f 82 bb 02 00 00    	jb     7f925a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x68a>
  7f8f9f:	49 c7 45 00 02 00 00 	movq   $0x2,0x0(%r13)
  7f8fa6:	00 
  7f8fa7:	49 c7 07 01 00 00 00 	movq   $0x1,(%r15)
  7f8fae:	49 89 5f 08          	mov    %rbx,0x8(%r15)
  7f8fb2:	4c 39 f3             	cmp    %r14,%rbx
  7f8fb5:	75 79                	jne    7f9030 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x460>
  7f8fb7:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7f8fbc:	80 38 00             	cmpb   $0x0,(%rax)
  7f8fbf:	74 1c                	je     7f8fdd <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x40d>
  7f8fc1:	66 83 7c 24 14 0c    	cmpw   $0xc,0x14(%rsp)
  7f8fc7:	0f 94 c0             	sete   %al
  7f8fca:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  7f8fcf:	4c 39 31             	cmp    %r14,(%rcx)
  7f8fd2:	0f 95 c1             	setne  %cl
  7f8fd5:	08 c1                	or     %al,%cl
  7f8fd7:	0f 84 57 01 00 00    	je     7f9134 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x564>
  7f8fdd:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  7f8fe2:	4c 39 30             	cmp    %r14,(%rax)
  7f8fe5:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  7f8fea:	f3 0f 10 00          	movss  (%rax),%xmm0
  7f8fee:	b9 00 00 00 00       	mov    $0x0,%ecx
  7f8ff3:	48 0f 44 4c 24 20    	cmove  0x20(%rsp),%rcx
  7f8ff9:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  7f8ffe:	80 38 00             	cmpb   $0x0,(%rax)
  7f9001:	b8 00 00 00 00       	mov    $0x0,%eax
  7f9006:	48 0f 44 c8          	cmove  %rax,%rcx
  7f900a:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  7f9011:	00 
  7f9012:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  7f9017:	4c 89 f2             	mov    %r14,%rdx
  7f901a:	4c 8d 44 24 68       	lea    0x68(%rsp),%r8
  7f901f:	eb 5f                	jmp    7f9080 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x4b0>
  7f9021:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  7f9028:	0f 1f 84 00 00 00 00 
  7f902f:	00 
  7f9030:	76 0e                	jbe    7f9040 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x470>
  7f9032:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  7f9039:	00 00 00 00 00 
  7f903e:	eb 4b                	jmp    7f908b <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x4bb>
  7f9040:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  7f9045:	48 39 18             	cmp    %rbx,(%rax)
  7f9048:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  7f904d:	f3 0f 10 00          	movss  (%rax),%xmm0
  7f9051:	b9 00 00 00 00       	mov    $0x0,%ecx
  7f9056:	48 0f 44 4c 24 20    	cmove  0x20(%rsp),%rcx
  7f905c:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  7f9061:	80 38 00             	cmpb   $0x0,(%rax)
  7f9064:	b8 00 00 00 00       	mov    $0x0,%eax
  7f9069:	48 0f 44 c8          	cmove  %rax,%rcx
  7f906d:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  7f9074:	00 
  7f9075:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  7f907a:	48 89 da             	mov    %rbx,%rdx
  7f907d:	45 31 c0             	xor    %r8d,%r8d
  7f9080:	ff 15 8a 52 33 00    	call   *0x33528a(%rip)        # b2e310 <_DYNAMIC+0xe10>
  7f9086:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  7f908b:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  7f9092:	00 
  7f9093:	49 89 44 24 40       	mov    %rax,0x40(%r12)
  7f9098:	48 8b 84 24 a8 00 00 	mov    0xa8(%rsp),%rax
  7f909f:	00 
  7f90a0:	48 8b 8c 24 b0 00 00 	mov    0xb0(%rsp),%rcx
  7f90a7:	00 
  7f90a8:	0f 10 84 24 b8 00 00 	movups 0xb8(%rsp),%xmm0
  7f90af:	00 
  7f90b0:	0f 10 8c 24 c8 00 00 	movups 0xc8(%rsp),%xmm1
  7f90b7:	00 
  7f90b8:	0f 10 94 24 d8 00 00 	movups 0xd8(%rsp),%xmm2
  7f90bf:	00 
  7f90c0:	41 0f 11 54 24 30    	movups %xmm2,0x30(%r12)
  7f90c6:	41 0f 11 4c 24 20    	movups %xmm1,0x20(%r12)
  7f90cc:	41 0f 11 44 24 10    	movups %xmm0,0x10(%r12)
  7f90d2:	49 89 04 24          	mov    %rax,(%r12)
  7f90d6:	49 89 4c 24 08       	mov    %rcx,0x8(%r12)
  7f90db:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  7f90e2:	00 
  7f90e3:	48 8b 28             	mov    (%rax),%rbp
  7f90e6:	48 89 9c 24 28 01 00 	mov    %rbx,0x128(%rsp)
  7f90ed:	00 
  7f90ee:	83 bc 24 30 01 00 00 	cmpl   $0x1,0x130(%rsp)
  7f90f5:	01 
  7f90f6:	0f 85 54 fe ff ff    	jne    7f8f50 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x380>
  7f90fc:	48 8b 7d 08          	mov    0x8(%rbp),%rdi
  7f9100:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  7f9104:	48 8b 45 18          	mov    0x18(%rbp),%rax
  7f9108:	48 8b 10             	mov    (%rax),%rdx
  7f910b:	48 8b 45 20          	mov    0x20(%rbp),%rax
  7f910f:	f3 0f 10 00          	movss  (%rax),%xmm0
  7f9113:	48 89 d9             	mov    %rbx,%rcx
  7f9116:	4d 89 e0             	mov    %r12,%r8
  7f9119:	e8 b2 a1 ff ff       	call   7f32d0 <gpui_canvas::text::planner::append_caret>
  7f911e:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  7f9123:	83 f8 ff             	cmp    $0xffffffff,%eax
  7f9126:	0f 95 c0             	setne  %al
  7f9129:	48 8b 4d 00          	mov    0x0(%rbp),%rcx
  7f912d:	08 01                	or     %al,(%rcx)
  7f912f:	e9 1c fe ff ff       	jmp    7f8f50 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x380>
  7f9134:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  7f913a:	f6 44 24 03 01       	testb  $0x1,0x3(%rsp)
  7f913f:	74 09                	je     7f914a <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x57a>
  7f9141:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  7f9146:	f3 0f 10 00          	movss  (%rax),%xmm0
  7f914a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  7f914f:	48 8b 40 08          	mov    0x8(%rax),%rax
  7f9153:	0f 57 c9             	xorps  %xmm1,%xmm1
  7f9156:	f3 0f 5a c8          	cvtss2sd %xmm0,%xmm1
  7f915a:	f3 0f 10 50 40       	movss  0x40(%rax),%xmm2
  7f915f:	f3 0f 10 58 44       	movss  0x44(%rax),%xmm3
  7f9164:	0f 28 e2             	movaps %xmm2,%xmm4
  7f9167:	f3 0f 5d 60 48       	minss  0x48(%rax),%xmm4
  7f916c:	0f 28 ec             	movaps %xmm4,%xmm5
  7f916f:	f3 0f c2 ec 03       	cmpunordss %xmm4,%xmm5
  7f9174:	0f 28 f5             	movaps %xmm5,%xmm6
  7f9177:	0f 55 f4             	andnps %xmm4,%xmm6
  7f917a:	0f 54 ea             	andps  %xmm2,%xmm5
  7f917d:	0f 56 ee             	orps   %xmm6,%xmm5
  7f9180:	0f 57 d2             	xorps  %xmm2,%xmm2
  7f9183:	f3 0f 5a d5          	cvtss2sd %xmm5,%xmm2
  7f9187:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  7f918c:	f3 0f 58 01          	addss  (%rcx),%xmm0
  7f9190:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  7f9194:	0f 28 e3             	movaps %xmm3,%xmm4
  7f9197:	f3 0f 5f 60 4c       	maxss  0x4c(%rax),%xmm4
  7f919c:	0f 28 ec             	movaps %xmm4,%xmm5
  7f919f:	f3 0f c2 ec 03       	cmpunordss %xmm4,%xmm5
  7f91a4:	0f 28 f5             	movaps %xmm5,%xmm6
  7f91a7:	0f 55 f4             	andnps %xmm4,%xmm6
  7f91aa:	0f 54 eb             	andps  %xmm3,%xmm5
  7f91ad:	0f 56 ee             	orps   %xmm6,%xmm5
  7f91b0:	0f 57 db             	xorps  %xmm3,%xmm3
  7f91b3:	f3 0f 5a dd          	cvtss2sd %xmm5,%xmm3
  7f91b7:	f2 0f 11 8c 24 b0 00 	movsd  %xmm1,0xb0(%rsp)
  7f91be:	00 00 
  7f91c0:	f2 0f 11 94 24 b8 00 	movsd  %xmm2,0xb8(%rsp)
  7f91c7:	00 00 
  7f91c9:	f2 0f 11 84 24 c0 00 	movsd  %xmm0,0xc0(%rsp)
  7f91d0:	00 00 
  7f91d2:	f2 0f 11 9c 24 c8 00 	movsd  %xmm3,0xc8(%rsp)
  7f91d9:	00 00 
  7f91db:	f2 0f 11 8c 24 d0 00 	movsd  %xmm1,0xd0(%rsp)
  7f91e2:	00 00 
  7f91e4:	f2 0f 11 94 24 d8 00 	movsd  %xmm2,0xd8(%rsp)
  7f91eb:	00 00 
  7f91ed:	f2 0f 11 84 24 e0 00 	movsd  %xmm0,0xe0(%rsp)
  7f91f4:	00 00 
  7f91f6:	f2 0f 11 9c 24 e8 00 	movsd  %xmm3,0xe8(%rsp)
  7f91fd:	00 00 
  7f91ff:	48 c7 84 24 a8 00 00 	movq   $0x1,0xa8(%rsp)
  7f9206:	00 01 00 00 00 
  7f920b:	e9 7b fe ff ff       	jmp    7f908b <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x4bb>
  7f9210:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  7f9215:	4c 89 00             	mov    %r8,(%rax)
  7f9218:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  7f921d:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  7f9223:	f3 0f 11 00          	movss  %xmm0,(%rax)
  7f9227:	66 83 7c 24 14 0c    	cmpw   $0xc,0x14(%rsp)
  7f922d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7f9232:	0f 95 00             	setne  (%rax)
  7f9235:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  7f923a:	c7 03 01 00 00 00    	movl   $0x1,(%rbx)
  7f9240:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  7f9245:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7f924a:	0f 11 00             	movups %xmm0,(%rax)
  7f924d:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  7f9252:	4c 89 00             	mov    %r8,(%rax)
  7f9255:	e9 7e fa ff ff       	jmp    7f8cd8 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x108>
  7f925a:	b0 01                	mov    $0x1,%al
  7f925c:	eb 02                	jmp    7f9260 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<core::convert::Infallible>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<true, (), core::convert::Infallible, icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, <parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>::{closure#0}>::{closure#2}>+0x690>
  7f925e:	b0 02                	mov    $0x2,%al
  7f9260:	48 81 c4 88 02 00 00 	add    $0x288,%rsp
  7f9267:	5b                   	pop    %rbx
  7f9268:	41 5c                	pop    %r12
  7f926a:	41 5d                	pop    %r13
  7f926c:	41 5e                	pop    %r14
  7f926e:	41 5f                	pop    %r15
  7f9270:	5d                   	pop    %rbp
  7f9271:	c3                   	ret
  7f9272:	48 8d 3d 07 00 91 ff 	lea    -0x6efff9(%rip),%rdi        # 109280 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.4.llvm.14379316919819170204>
  7f9279:	48 8d 15 18 eb 30 00 	lea    0x30eb18(%rip),%rdx        # b07d98 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.6.llvm.14379316919819170204>
  7f9280:	be 63 00 00 00       	mov    $0x63,%esi
  7f9285:	ff 15 f5 45 33 00    	call   *0x3345f5(%rip)        # b2d880 <_DYNAMIC+0x380>
  7f928b:	48 8d 15 6e eb 30 00 	lea    0x30eb6e(%rip),%rdx        # b07e00 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.8.llvm.14379316919819170204+0x38>
  7f9292:	ff 15 38 45 33 00    	call   *0x334538(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7f9298:	48 8d 15 11 eb 30 00 	lea    0x30eb11(%rip),%rdx        # b07db0 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.7.llvm.14379316919819170204>
  7f929f:	ff 15 2b 45 33 00    	call   *0x33452b(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
