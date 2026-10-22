
/tmp/gpui-text-map-query-controls/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660de0 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>:
  660de0:	50                   	push   %rax
  660de1:	48 85 f6             	test   %rsi,%rsi
  660de4:	74 5c                	je     660e42 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x62>
  660de6:	48 8b 07             	mov    (%rdi),%rax
  660de9:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  660ded:	0f 1f 00             	nopl   (%rax)
  660df0:	48 89 ca             	mov    %rcx,%rdx
  660df3:	48 83 f9 01          	cmp    $0x1,%rcx
  660df7:	74 30                	je     660e29 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x49>
  660df9:	48 85 c9             	test   %rcx,%rcx
  660dfc:	74 46                	je     660e44 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x64>
  660dfe:	4c 8d 40 28          	lea    0x28(%rax),%r8
  660e02:	4c 8d 49 01          	lea    0x1(%rcx),%r9
  660e06:	ba 01 00 00 00       	mov    $0x1,%edx
  660e0b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  660e10:	45 8b 50 e8          	mov    -0x18(%r8),%r10d
  660e14:	45 3b 10             	cmp    (%r8),%r10d
  660e17:	75 10                	jne    660e29 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x49>
  660e19:	48 ff c2             	inc    %rdx
  660e1c:	49 83 c0 18          	add    $0x18,%r8
  660e20:	49 ff c9             	dec    %r9
  660e23:	49 83 f9 02          	cmp    $0x2,%r9
  660e27:	77 e7                	ja     660e10 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x30>
  660e29:	48 29 d1             	sub    %rdx,%rcx
  660e2c:	72 1b                	jb     660e49 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x69>
  660e2e:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  660e32:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
  660e36:	48 89 07             	mov    %rax,(%rdi)
  660e39:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  660e3d:	48 ff ce             	dec    %rsi
  660e40:	75 ae                	jne    660df0 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x10>
  660e42:	31 f6                	xor    %esi,%esi
  660e44:	48 89 f0             	mov    %rsi,%rax
  660e47:	59                   	pop    %rcx
  660e48:	c3                   	ret
  660e49:	48 8d 3d d8 48 9c ff 	lea    -0x63b728(%rip),%rdi        # 25728 <anon.510ecd5b06a31c5d706a3e62c051feab.3.llvm.11060465732669763034>
  660e50:	48 8d 15 f1 b7 11 00 	lea    0x11b7f1(%rip),%rdx        # 77c648 <anon.510ecd5b06a31c5d706a3e62c051feab.5.llvm.11060465732669763034>
  660e57:	be 13 00 00 00       	mov    $0x13,%esi
  660e5c:	ff 15 76 64 12 00    	call   *0x126476(%rip)        # 7872d8 <_DYNAMIC+0x250>
