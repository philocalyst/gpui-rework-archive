
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660ea0 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>:
  660ea0:	50                   	push   %rax
  660ea1:	48 85 f6             	test   %rsi,%rsi
  660ea4:	74 58                	je     660efe <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x5e>
  660ea6:	48 8b 07             	mov    (%rdi),%rax
  660ea9:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  660ead:	0f 1f 00             	nopl   (%rax)
  660eb0:	48 89 ca             	mov    %rcx,%rdx
  660eb3:	48 83 f9 01          	cmp    $0x1,%rcx
  660eb7:	74 2c                	je     660ee5 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x45>
  660eb9:	48 85 c9             	test   %rcx,%rcx
  660ebc:	74 42                	je     660f00 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x60>
  660ebe:	44 8b 00             	mov    (%rax),%r8d
  660ec1:	4c 8d 48 0c          	lea    0xc(%rax),%r9
  660ec5:	4c 8d 51 01          	lea    0x1(%rcx),%r10
  660ec9:	ba 01 00 00 00       	mov    $0x1,%edx
  660ece:	66 90                	xchg   %ax,%ax
  660ed0:	45 3b 01             	cmp    (%r9),%r8d
  660ed3:	75 10                	jne    660ee5 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x45>
  660ed5:	48 ff c2             	inc    %rdx
  660ed8:	49 83 c1 0c          	add    $0xc,%r9
  660edc:	49 ff ca             	dec    %r10
  660edf:	49 83 fa 02          	cmp    $0x2,%r10
  660ee3:	77 eb                	ja     660ed0 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x30>
  660ee5:	48 29 d1             	sub    %rdx,%rcx
  660ee8:	72 1b                	jb     660f05 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x65>
  660eea:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  660eee:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
  660ef2:	48 89 07             	mov    %rax,(%rdi)
  660ef5:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  660ef9:	48 ff ce             	dec    %rsi
  660efc:	75 b2                	jne    660eb0 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x10>
  660efe:	31 f6                	xor    %esi,%esi
  660f00:	48 89 f0             	mov    %rsi,%rax
  660f03:	59                   	pop    %rcx
  660f04:	c3                   	ret
  660f05:	48 8d 3d 4c 48 9c ff 	lea    -0x63b7b4(%rip),%rdi        # 25758 <anon.510ecd5b06a31c5d706a3e62c051feab.3.llvm.15957366779061141188>
  660f0c:	48 8d 15 b5 b7 11 00 	lea    0x11b7b5(%rip),%rdx        # 77c6c8 <anon.510ecd5b06a31c5d706a3e62c051feab.5.llvm.15957366779061141188>
  660f13:	be 13 00 00 00       	mov    $0x13,%esi
  660f18:	ff 15 52 64 12 00    	call   *0x126452(%rip)        # 787370 <_DYNAMIC+0x250>
