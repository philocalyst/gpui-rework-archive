
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000683870 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>:
  683870:	55                   	push   %rbp
  683871:	41 57                	push   %r15
  683873:	41 56                	push   %r14
  683875:	41 55                	push   %r13
  683877:	41 54                	push   %r12
  683879:	53                   	push   %rbx
  68387a:	48 81 ec 38 01 00 00 	sub    $0x138,%rsp
  683881:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  683886:	83 3f 02             	cmpl   $0x2,(%rdi)
  683889:	75 1a                	jne    6838a5 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x35>
  68388b:	41 b6 02             	mov    $0x2,%r14b
  68388e:	89 f0                	mov    %esi,%eax
  683890:	44 89 f2             	mov    %r14d,%edx
  683893:	48 81 c4 38 01 00 00 	add    $0x138,%rsp
  68389a:	5b                   	pop    %rbx
  68389b:	41 5c                	pop    %r12
  68389d:	41 5d                	pop    %r13
  68389f:	41 5e                	pop    %r14
  6838a1:	41 5f                	pop    %r15
  6838a3:	5d                   	pop    %rbp
  6838a4:	c3                   	ret
  6838a5:	48 89 f2             	mov    %rsi,%rdx
  6838a8:	48 89 fb             	mov    %rdi,%rbx
  6838ab:	f3 0f 11 44 24 1c    	movss  %xmm0,0x1c(%rsp)
  6838b1:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6838b8:	00 
  6838b9:	48 89 de             	mov    %rbx,%rsi
  6838bc:	e8 ff 2e 00 00       	call   6867c0 <<gpui_canvas::text::layout::TextGeometry>::line_tail>
  6838c1:	f3 0f 10 43 4c       	movss  0x4c(%rbx),%xmm0
  6838c6:	f3 0f 59 05 aa 9d 99 	mulss  -0x666256(%rip),%xmm0        # 1d678 <GCC_except_table0+0x8c>
  6838cd:	ff 
  6838ce:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  6838d5:	00 
  6838d6:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  6838dd:	00 
  6838de:	0f 10 8c 24 f0 00 00 	movups 0xf0(%rsp),%xmm1
  6838e5:	00 
  6838e6:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  6838ed:	00 
  6838ee:	0f 57 d2             	xorps  %xmm2,%xmm2
  6838f1:	0f 11 94 24 a8 00 00 	movups %xmm2,0xa8(%rsp)
  6838f8:	00 
  6838f9:	0f 29 4c 24 60       	movaps %xmm1,0x60(%rsp)
  6838fe:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  683903:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
  68390a:	00 00 
  68390c:	48 c7 84 24 98 00 00 	movq   $0x0,0x98(%rsp)
  683913:	00 00 00 00 00 
  683918:	48 c7 84 24 a0 00 00 	movq   $0x1,0xa0(%rsp)
  68391f:	00 01 00 00 00 
  683924:	48 89 9c 24 b8 00 00 	mov    %rbx,0xb8(%rsp)
  68392b:	00 
  68392c:	f3 0f 11 84 24 c0 00 	movss  %xmm0,0xc0(%rsp)
  683933:	00 00 
  683935:	48 89 9c 24 c8 00 00 	mov    %rbx,0xc8(%rsp)
  68393c:	00 
  68393d:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  683942:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  683949:	00 
  68394a:	c6 84 24 d8 00 00 00 	movb   $0x0,0xd8(%rsp)
  683951:	00 
  683952:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  683959:	00 
  68395a:	40 b5 02             	mov    $0x2,%bpl
  68395d:	4c 8d bc 24 08 01 00 	lea    0x108(%rsp),%r15
  683964:	00 
  683965:	4c 8d 64 24 60       	lea    0x60(%rsp),%r12
  68396a:	4c 8d 6c 24 28       	lea    0x28(%rsp),%r13
  68396f:	41 b6 02             	mov    $0x2,%r14b
  683972:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  683979:	1f 84 00 00 00 00 00 
  683980:	4c 89 ff             	mov    %r15,%rdi
  683983:	4c 89 e6             	mov    %r12,%rsi
  683986:	e8 95 33 00 00       	call   686d20 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next>
  68398b:	83 bc 24 08 01 00 00 	cmpl   $0x2,0x108(%rsp)
  683992:	02 
  683993:	0f 84 96 01 00 00    	je     683b2f <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2bf>
  683999:	48 8b b4 24 b8 00 00 	mov    0xb8(%rsp),%rsi
  6839a0:	00 
  6839a1:	f3 0f 10 84 24 c0 00 	movss  0xc0(%rsp),%xmm0
  6839a8:	00 00 
  6839aa:	4c 89 ef             	mov    %r13,%rdi
  6839ad:	4c 89 fa             	mov    %r15,%rdx
  6839b0:	e8 3b f8 ff ff       	call   6831f0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}>
  6839b5:	0f b6 4c 24 2c       	movzbl 0x2c(%rsp),%ecx
  6839ba:	80 f9 02             	cmp    $0x2,%cl
  6839bd:	74 c1                	je     683980 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x110>
  6839bf:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6839c6:	00 
  6839c7:	48 8b 94 24 d0 00 00 	mov    0xd0(%rsp),%rdx
  6839ce:	00 
  6839cf:	48 8b 3a             	mov    (%rdx),%rdi
  6839d2:	48 8b 70 40          	mov    0x40(%rax),%rsi
  6839d6:	48 39 f7             	cmp    %rsi,%rdi
  6839d9:	0f 83 94 02 00 00    	jae    683c73 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x403>
  6839df:	8b 74 24 28          	mov    0x28(%rsp),%esi
  6839e3:	48 8b 40 38          	mov    0x38(%rax),%rax
  6839e7:	48 8d 14 7f          	lea    (%rdi,%rdi,2),%rdx
  6839eb:	3b 74 d0 04          	cmp    0x4(%rax,%rdx,8),%esi
  6839ef:	0f 87 3a 01 00 00    	ja     683b2f <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2bf>
  6839f5:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6839fa:	48 8b 94 24 e0 00 00 	mov    0xe0(%rsp),%rdx
  683a01:	00 
  683a02:	48 3b 02             	cmp    (%rdx),%rax
  683a05:	0f 85 75 ff ff ff    	jne    683980 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x110>
  683a0b:	f3 0f 10 4c 24 50    	movss  0x50(%rsp),%xmm1
  683a11:	f6 44 24 58 01       	testb  $0x1,0x58(%rsp)
  683a16:	74 40                	je     683a58 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1e8>
  683a18:	89 f0                	mov    %esi,%eax
  683a1a:	89 ca                	mov    %ecx,%edx
  683a1c:	0f 28 c1             	movaps %xmm1,%xmm0
  683a1f:	f3 0f 10 54 24 1c    	movss  0x1c(%rsp),%xmm2
  683a25:	0f 2e ca             	ucomiss %xmm2,%xmm1
  683a28:	0f 87 a2 00 00 00    	ja     683ad0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x260>
  683a2e:	0f 2e d0             	ucomiss %xmm0,%xmm2
  683a31:	0f 86 0a 02 00 00    	jbe    683c41 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3d1>
  683a37:	40 80 fd 02          	cmp    $0x2,%bpl
  683a3b:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  683a41:	0f 84 cc 00 00 00    	je     683b13 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2a3>
  683a47:	0f 2e c1             	ucomiss %xmm1,%xmm0
  683a4a:	0f 87 c3 00 00 00    	ja     683b13 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2a3>
  683a50:	0f 28 c1             	movaps %xmm1,%xmm0
  683a53:	e9 b5 00 00 00       	jmp    683b0d <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x29d>
  683a58:	8b 44 24 30          	mov    0x30(%rsp),%eax
  683a5c:	0f b6 54 24 34       	movzbl 0x34(%rsp),%edx
  683a61:	f3 0f 10 44 24 54    	movss  0x54(%rsp),%xmm0
  683a67:	80 e2 01             	and    $0x1,%dl
  683a6a:	0f 28 d9             	movaps %xmm1,%xmm3
  683a6d:	f3 0f 5d d8          	minss  %xmm0,%xmm3
  683a71:	0f 28 d3             	movaps %xmm3,%xmm2
  683a74:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  683a79:	0f 28 e2             	movaps %xmm2,%xmm4
  683a7c:	0f 55 e3             	andnps %xmm3,%xmm4
  683a7f:	0f 54 d1             	andps  %xmm1,%xmm2
  683a82:	0f 56 d4             	orps   %xmm4,%xmm2
  683a85:	0f 28 d9             	movaps %xmm1,%xmm3
  683a88:	f3 0f 5f d8          	maxss  %xmm0,%xmm3
  683a8c:	0f 2e c1             	ucomiss %xmm1,%xmm0
  683a8f:	89 f7                	mov    %esi,%edi
  683a91:	0f 46 f8             	cmovbe %eax,%edi
  683a94:	0f 28 c3             	movaps %xmm3,%xmm0
  683a97:	f3 0f c2 c3 03       	cmpunordss %xmm3,%xmm0
  683a9c:	44 0f b6 c1          	movzbl %cl,%r8d
  683aa0:	0f b6 d2             	movzbl %dl,%edx
  683aa3:	44 89 c1             	mov    %r8d,%ecx
  683aa6:	0f 46 ca             	cmovbe %edx,%ecx
  683aa9:	0f 28 e0             	movaps %xmm0,%xmm4
  683aac:	0f 46 c6             	cmovbe %esi,%eax
  683aaf:	0f 55 e3             	andnps %xmm3,%xmm4
  683ab2:	41 0f 46 d0          	cmovbe %r8d,%edx
  683ab6:	0f 54 c1             	andps  %xmm1,%xmm0
  683ab9:	0f 56 c4             	orps   %xmm4,%xmm0
  683abc:	0f 28 ca             	movaps %xmm2,%xmm1
  683abf:	89 fe                	mov    %edi,%esi
  683ac1:	f3 0f 10 54 24 1c    	movss  0x1c(%rsp),%xmm2
  683ac7:	0f 2e ca             	ucomiss %xmm2,%xmm1
  683aca:	0f 86 5e ff ff ff    	jbe    683a2e <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1be>
  683ad0:	41 80 fe 02          	cmp    $0x2,%r14b
  683ad4:	74 24                	je     683afa <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x28a>
  683ad6:	f3 0f 10 44 24 14    	movss  0x14(%rsp),%xmm0
  683adc:	0f 2e c1             	ucomiss %xmm1,%xmm0
  683adf:	8b 44 24 10          	mov    0x10(%rsp),%eax
  683ae3:	76 0d                	jbe    683af2 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x282>
  683ae5:	f3 0f 11 4c 24 14    	movss  %xmm1,0x14(%rsp)
  683aeb:	89 74 24 18          	mov    %esi,0x18(%rsp)
  683aef:	41 89 ce             	mov    %ecx,%r14d
  683af2:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  683af8:	eb 17                	jmp    683b11 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2a1>
  683afa:	f3 0f 11 4c 24 14    	movss  %xmm1,0x14(%rsp)
  683b00:	89 74 24 18          	mov    %esi,0x18(%rsp)
  683b04:	41 89 ce             	mov    %ecx,%r14d
  683b07:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  683b0d:	8b 44 24 10          	mov    0x10(%rsp),%eax
  683b11:	89 ea                	mov    %ebp,%edx
  683b13:	80 bc 24 d8 00 00 00 	cmpb   $0x0,0xd8(%rsp)
  683b1a:	00 
  683b1b:	89 d5                	mov    %edx,%ebp
  683b1d:	89 44 24 10          	mov    %eax,0x10(%rsp)
  683b21:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  683b27:	0f 84 53 fe ff ff    	je     683980 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x110>
  683b2d:	eb 0c                	jmp    683b3b <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2cb>
  683b2f:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  683b35:	8b 44 24 10          	mov    0x10(%rsp),%eax
  683b39:	89 ea                	mov    %ebp,%edx
  683b3b:	80 fa 02             	cmp    $0x2,%dl
  683b3e:	0f 85 ad 00 00 00    	jne    683bf1 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x381>
  683b44:	41 80 fe 02          	cmp    $0x2,%r14b
  683b48:	8b 74 24 18          	mov    0x18(%rsp),%esi
  683b4c:	0f 85 3c fd ff ff    	jne    68388e <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1e>
  683b52:	0f 10 84 24 f0 00 00 	movups 0xf0(%rsp),%xmm0
  683b59:	00 
  683b5a:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  683b61:	00 
  683b62:	0f 11 44 24 60       	movups %xmm0,0x60(%rsp)
  683b67:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  683b6c:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
  683b73:	00 00 
  683b75:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  683b7c:	00 
  683b7d:	48 8d 84 24 98 00 00 	lea    0x98(%rsp),%rax
  683b84:	00 
  683b85:	c6 84 24 98 00 00 00 	movb   $0x0,0x98(%rsp)
  683b8c:	00 
  683b8d:	48 8d 8c 24 88 00 00 	lea    0x88(%rsp),%rcx
  683b94:	00 
  683b95:	48 89 9c 24 88 00 00 	mov    %rbx,0x88(%rsp)
  683b9c:	00 
  683b9d:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  683ba2:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  683ba9:	00 
  683baa:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  683baf:	48 89 5c 24 30       	mov    %rbx,0x30(%rsp)
  683bb4:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
  683bb9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  683bbe:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  683bc3:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
  683bc8:	e8 b3 de ff ff       	call   681a80 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::TextPosition>, <gpui_canvas::text::layout::TextGeometry>::position_on_line::{closure#4}::{closure#0}, core::iter::traits::iterator::Iterator::find_map::check<gpui_canvas::text::layout::Stop, gpui_canvas::text::layout::TextPosition, <gpui_canvas::text::layout::TextGeometry>::position_on_line::{closure#4}::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::TextPosition>>>>
  683bcd:	89 c6                	mov    %eax,%esi
  683bcf:	80 fa ff             	cmp    $0xff,%dl
  683bd2:	0f b6 c2             	movzbl %dl,%eax
  683bd5:	b9 02 00 00 00       	mov    $0x2,%ecx
  683bda:	0f 44 c1             	cmove  %ecx,%eax
  683bdd:	89 c2                	mov    %eax,%edx
  683bdf:	80 e2 01             	and    $0x1,%dl
  683be2:	3c 02                	cmp    $0x2,%al
  683be4:	44 0f b6 f2          	movzbl %dl,%r14d
  683be8:	44 0f 44 f1          	cmove  %ecx,%r14d
  683bec:	e9 9d fc ff ff       	jmp    68388e <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1e>
  683bf1:	41 80 fe 02          	cmp    $0x2,%r14b
  683bf5:	8b 74 24 18          	mov    0x18(%rsp),%esi
  683bf9:	75 0a                	jne    683c05 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x395>
  683bfb:	41 89 d6             	mov    %edx,%r14d
  683bfe:	89 c6                	mov    %eax,%esi
  683c00:	e9 89 fc ff ff       	jmp    68388e <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1e>
  683c05:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  683c09:	f3 0f 10 4c 24 14    	movss  0x14(%rsp),%xmm1
  683c0f:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  683c13:	f2 0f 58 c8          	addsd  %xmm0,%xmm1
  683c17:	f2 0f 59 0d c1 0b 9a 	mulsd  -0x65f43f(%rip),%xmm1        # 247e0 <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x111>
  683c1e:	ff 
  683c1f:	f3 0f 10 44 24 1c    	movss  0x1c(%rsp),%xmm0
  683c25:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  683c29:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  683c2d:	0f 46 f0             	cmovbe %eax,%esi
  683c30:	41 0f b6 c6          	movzbl %r14b,%eax
  683c34:	44 0f b6 f2          	movzbl %dl,%r14d
  683c38:	44 0f 47 f0          	cmova  %eax,%r14d
  683c3c:	e9 4d fc ff ff       	jmp    68388e <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1e>
  683c41:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  683c45:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  683c49:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
  683c4d:	f2 0f 59 05 8b 0b 9a 	mulsd  -0x65f475(%rip),%xmm0        # 247e0 <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x111>
  683c54:	ff 
  683c55:	0f 57 c9             	xorps  %xmm1,%xmm1
  683c58:	f3 0f 5a ca          	cvtss2sd %xmm2,%xmm1
  683c5c:	66 0f 2e c8          	ucomisd %xmm0,%xmm1
  683c60:	0f 47 f0             	cmova  %eax,%esi
  683c63:	0f b6 c2             	movzbl %dl,%eax
  683c66:	44 0f b6 f1          	movzbl %cl,%r14d
  683c6a:	44 0f 47 f0          	cmova  %eax,%r14d
  683c6e:	e9 1b fc ff ff       	jmp    68388e <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1e>
  683c73:	48 8d 15 26 c1 0f 00 	lea    0xfc126(%rip),%rdx        # 77fda0 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x198>
  683c7a:	ff 15 58 5b 10 00    	call   *0x105b58(%rip)        # 7897d8 <_DYNAMIC+0x370>
