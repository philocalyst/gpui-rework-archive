
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660f60 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>:
  660f60:	50                   	push   %rax
  660f61:	48 85 f6             	test   %rsi,%rsi
  660f64:	74 58                	je     660fbe <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x5e>
  660f66:	48 8b 07             	mov    (%rdi),%rax
  660f69:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  660f6d:	0f 1f 00             	nopl   (%rax)
  660f70:	48 89 ca             	mov    %rcx,%rdx
  660f73:	48 83 f9 01          	cmp    $0x1,%rcx
  660f77:	74 2c                	je     660fa5 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x45>
  660f79:	48 85 c9             	test   %rcx,%rcx
  660f7c:	74 42                	je     660fc0 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x60>
  660f7e:	44 8b 00             	mov    (%rax),%r8d
  660f81:	4c 8d 48 0c          	lea    0xc(%rax),%r9
  660f85:	4c 8d 51 01          	lea    0x1(%rcx),%r10
  660f89:	ba 01 00 00 00       	mov    $0x1,%edx
  660f8e:	66 90                	xchg   %ax,%ax
  660f90:	45 3b 01             	cmp    (%r9),%r8d
  660f93:	75 10                	jne    660fa5 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x45>
  660f95:	48 ff c2             	inc    %rdx
  660f98:	49 83 c1 0c          	add    $0xc,%r9
  660f9c:	49 ff ca             	dec    %r10
  660f9f:	49 83 fa 02          	cmp    $0x2,%r10
  660fa3:	77 eb                	ja     660f90 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x30>
  660fa5:	48 29 d1             	sub    %rdx,%rcx
  660fa8:	72 1b                	jb     660fc5 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x65>
  660faa:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  660fae:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
  660fb2:	48 89 07             	mov    %rax,(%rdi)
  660fb5:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  660fb9:	48 ff ce             	dec    %rsi
  660fbc:	75 b2                	jne    660f70 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x10>
  660fbe:	31 f6                	xor    %esi,%esi
  660fc0:	48 89 f0             	mov    %rsi,%rax
  660fc3:	59                   	pop    %rcx
  660fc4:	c3                   	ret
  660fc5:	48 8d 3d bc 47 9c ff 	lea    -0x63b844(%rip),%rdi        # 25788 <anon.510ecd5b06a31c5d706a3e62c051feab.4.llvm.7134429625646942036>
  660fcc:	48 8d 15 dd b8 11 00 	lea    0x11b8dd(%rip),%rdx        # 77c8b0 <anon.510ecd5b06a31c5d706a3e62c051feab.6.llvm.7134429625646942036>
  660fd3:	be 13 00 00 00       	mov    $0x13,%esi
  660fd8:	ff 15 92 65 12 00    	call   *0x126592(%rip)        # 787570 <_DYNAMIC+0x250>
