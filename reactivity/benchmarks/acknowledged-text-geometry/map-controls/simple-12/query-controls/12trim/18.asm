
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660ef0 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>:
  660ef0:	50                   	push   %rax
  660ef1:	48 85 f6             	test   %rsi,%rsi
  660ef4:	74 58                	je     660f4e <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x5e>
  660ef6:	48 8b 07             	mov    (%rdi),%rax
  660ef9:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  660efd:	0f 1f 00             	nopl   (%rax)
  660f00:	48 89 ca             	mov    %rcx,%rdx
  660f03:	48 83 f9 01          	cmp    $0x1,%rcx
  660f07:	74 2c                	je     660f35 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x45>
  660f09:	48 85 c9             	test   %rcx,%rcx
  660f0c:	74 42                	je     660f50 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x60>
  660f0e:	44 8b 00             	mov    (%rax),%r8d
  660f11:	4c 8d 48 0c          	lea    0xc(%rax),%r9
  660f15:	4c 8d 51 01          	lea    0x1(%rcx),%r10
  660f19:	ba 01 00 00 00       	mov    $0x1,%edx
  660f1e:	66 90                	xchg   %ax,%ax
  660f20:	45 3b 01             	cmp    (%r9),%r8d
  660f23:	75 10                	jne    660f35 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x45>
  660f25:	48 ff c2             	inc    %rdx
  660f28:	49 83 c1 0c          	add    $0xc,%r9
  660f2c:	49 ff ca             	dec    %r10
  660f2f:	49 83 fa 02          	cmp    $0x2,%r10
  660f33:	77 eb                	ja     660f20 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x30>
  660f35:	48 29 d1             	sub    %rdx,%rcx
  660f38:	72 1b                	jb     660f55 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x65>
  660f3a:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  660f3e:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
  660f42:	48 89 07             	mov    %rax,(%rdi)
  660f45:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  660f49:	48 ff ce             	dec    %rsi
  660f4c:	75 b2                	jne    660f00 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x10>
  660f4e:	31 f6                	xor    %esi,%esi
  660f50:	48 89 f0             	mov    %rsi,%rax
  660f53:	59                   	pop    %rcx
  660f54:	c3                   	ret
  660f55:	48 8d 3d fc 47 9c ff 	lea    -0x63b804(%rip),%rdi        # 25758 <anon.510ecd5b06a31c5d706a3e62c051feab.3.llvm.15957366779061141188>
  660f5c:	48 8d 15 f5 b8 11 00 	lea    0x11b8f5(%rip),%rdx        # 77c858 <anon.510ecd5b06a31c5d706a3e62c051feab.5.llvm.15957366779061141188>
  660f63:	be 13 00 00 00       	mov    $0x13,%esi
  660f68:	ff 15 92 65 12 00    	call   *0x126592(%rip)        # 787500 <_DYNAMIC+0x250>
