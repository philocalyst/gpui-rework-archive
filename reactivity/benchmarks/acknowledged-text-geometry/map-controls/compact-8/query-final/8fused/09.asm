
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000067d4b0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>:
  67d4b0:	55                   	push   %rbp
  67d4b1:	41 57                	push   %r15
  67d4b3:	41 56                	push   %r14
  67d4b5:	41 55                	push   %r13
  67d4b7:	41 54                	push   %r12
  67d4b9:	53                   	push   %rbx
  67d4ba:	48 81 ec 38 01 00 00 	sub    $0x138,%rsp
  67d4c1:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  67d4c6:	83 3f 02             	cmpl   $0x2,(%rdi)
  67d4c9:	75 1a                	jne    67d4e5 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x35>
  67d4cb:	41 b6 02             	mov    $0x2,%r14b
  67d4ce:	89 f0                	mov    %esi,%eax
  67d4d0:	44 89 f2             	mov    %r14d,%edx
  67d4d3:	48 81 c4 38 01 00 00 	add    $0x138,%rsp
  67d4da:	5b                   	pop    %rbx
  67d4db:	41 5c                	pop    %r12
  67d4dd:	41 5d                	pop    %r13
  67d4df:	41 5e                	pop    %r14
  67d4e1:	41 5f                	pop    %r15
  67d4e3:	5d                   	pop    %rbp
  67d4e4:	c3                   	ret
  67d4e5:	48 89 f2             	mov    %rsi,%rdx
  67d4e8:	48 89 fb             	mov    %rdi,%rbx
  67d4eb:	f3 0f 11 44 24 1c    	movss  %xmm0,0x1c(%rsp)
  67d4f1:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  67d4f8:	00 
  67d4f9:	48 89 de             	mov    %rbx,%rsi
  67d4fc:	e8 1f 2e 00 00       	call   680320 <<gpui_canvas::text::layout::TextGeometry>::line_tail>
  67d501:	f3 0f 10 43 4c       	movss  0x4c(%rbx),%xmm0
  67d506:	f3 0f 59 05 8a 01 9a 	mulss  -0x65fe76(%rip),%xmm0        # 1d698 <GCC_except_table0+0x88>
  67d50d:	ff 
  67d50e:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  67d515:	00 
  67d516:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  67d51d:	00 
  67d51e:	0f 10 8c 24 f0 00 00 	movups 0xf0(%rsp),%xmm1
  67d525:	00 
  67d526:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  67d52d:	00 
  67d52e:	0f 57 d2             	xorps  %xmm2,%xmm2
  67d531:	0f 11 94 24 a8 00 00 	movups %xmm2,0xa8(%rsp)
  67d538:	00 
  67d539:	0f 29 4c 24 60       	movaps %xmm1,0x60(%rsp)
  67d53e:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  67d543:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
  67d54a:	00 00 
  67d54c:	48 c7 84 24 98 00 00 	movq   $0x0,0x98(%rsp)
  67d553:	00 00 00 00 00 
  67d558:	48 c7 84 24 a0 00 00 	movq   $0x1,0xa0(%rsp)
  67d55f:	00 01 00 00 00 
  67d564:	48 89 9c 24 b8 00 00 	mov    %rbx,0xb8(%rsp)
  67d56b:	00 
  67d56c:	f3 0f 11 84 24 c0 00 	movss  %xmm0,0xc0(%rsp)
  67d573:	00 00 
  67d575:	48 89 9c 24 c8 00 00 	mov    %rbx,0xc8(%rsp)
  67d57c:	00 
  67d57d:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  67d582:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  67d589:	00 
  67d58a:	c6 84 24 d8 00 00 00 	movb   $0x0,0xd8(%rsp)
  67d591:	00 
  67d592:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  67d599:	00 
  67d59a:	40 b5 02             	mov    $0x2,%bpl
  67d59d:	4c 8d bc 24 08 01 00 	lea    0x108(%rsp),%r15
  67d5a4:	00 
  67d5a5:	4c 8d 64 24 60       	lea    0x60(%rsp),%r12
  67d5aa:	4c 8d 6c 24 28       	lea    0x28(%rsp),%r13
  67d5af:	41 b6 02             	mov    $0x2,%r14b
  67d5b2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  67d5b9:	1f 84 00 00 00 00 00 
  67d5c0:	4c 89 ff             	mov    %r15,%rdi
  67d5c3:	4c 89 e6             	mov    %r12,%rsi
  67d5c6:	e8 b5 32 00 00       	call   680880 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next>
  67d5cb:	83 bc 24 08 01 00 00 	cmpl   $0x2,0x108(%rsp)
  67d5d2:	02 
  67d5d3:	0f 84 96 01 00 00    	je     67d76f <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2bf>
  67d5d9:	48 8b b4 24 b8 00 00 	mov    0xb8(%rsp),%rsi
  67d5e0:	00 
  67d5e1:	f3 0f 10 84 24 c0 00 	movss  0xc0(%rsp),%xmm0
  67d5e8:	00 00 
  67d5ea:	4c 89 ef             	mov    %r13,%rdi
  67d5ed:	4c 89 fa             	mov    %r15,%rdx
  67d5f0:	e8 3b f7 ff ff       	call   67cd30 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}>
  67d5f5:	0f b6 4c 24 2c       	movzbl 0x2c(%rsp),%ecx
  67d5fa:	80 f9 02             	cmp    $0x2,%cl
  67d5fd:	74 c1                	je     67d5c0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x110>
  67d5ff:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  67d606:	00 
  67d607:	48 8b 94 24 d0 00 00 	mov    0xd0(%rsp),%rdx
  67d60e:	00 
  67d60f:	48 8b 3a             	mov    (%rdx),%rdi
  67d612:	48 8b 70 40          	mov    0x40(%rax),%rsi
  67d616:	48 39 f7             	cmp    %rsi,%rdi
  67d619:	0f 83 94 02 00 00    	jae    67d8b3 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x403>
  67d61f:	8b 74 24 28          	mov    0x28(%rsp),%esi
  67d623:	48 8b 40 38          	mov    0x38(%rax),%rax
  67d627:	48 8d 14 7f          	lea    (%rdi,%rdi,2),%rdx
  67d62b:	3b 74 d0 04          	cmp    0x4(%rax,%rdx,8),%esi
  67d62f:	0f 87 3a 01 00 00    	ja     67d76f <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2bf>
  67d635:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  67d63a:	48 8b 94 24 e0 00 00 	mov    0xe0(%rsp),%rdx
  67d641:	00 
  67d642:	48 3b 02             	cmp    (%rdx),%rax
  67d645:	0f 85 75 ff ff ff    	jne    67d5c0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x110>
  67d64b:	f3 0f 10 4c 24 50    	movss  0x50(%rsp),%xmm1
  67d651:	f6 44 24 58 01       	testb  $0x1,0x58(%rsp)
  67d656:	74 40                	je     67d698 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1e8>
  67d658:	89 f0                	mov    %esi,%eax
  67d65a:	89 ca                	mov    %ecx,%edx
  67d65c:	0f 28 c1             	movaps %xmm1,%xmm0
  67d65f:	f3 0f 10 54 24 1c    	movss  0x1c(%rsp),%xmm2
  67d665:	0f 2e ca             	ucomiss %xmm2,%xmm1
  67d668:	0f 87 a2 00 00 00    	ja     67d710 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x260>
  67d66e:	0f 2e d0             	ucomiss %xmm0,%xmm2
  67d671:	0f 86 0a 02 00 00    	jbe    67d881 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3d1>
  67d677:	40 80 fd 02          	cmp    $0x2,%bpl
  67d67b:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  67d681:	0f 84 cc 00 00 00    	je     67d753 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2a3>
  67d687:	0f 2e c1             	ucomiss %xmm1,%xmm0
  67d68a:	0f 87 c3 00 00 00    	ja     67d753 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2a3>
  67d690:	0f 28 c1             	movaps %xmm1,%xmm0
  67d693:	e9 b5 00 00 00       	jmp    67d74d <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x29d>
  67d698:	8b 44 24 30          	mov    0x30(%rsp),%eax
  67d69c:	0f b6 54 24 34       	movzbl 0x34(%rsp),%edx
  67d6a1:	f3 0f 10 44 24 54    	movss  0x54(%rsp),%xmm0
  67d6a7:	80 e2 01             	and    $0x1,%dl
  67d6aa:	0f 28 d9             	movaps %xmm1,%xmm3
  67d6ad:	f3 0f 5d d8          	minss  %xmm0,%xmm3
  67d6b1:	0f 28 d3             	movaps %xmm3,%xmm2
  67d6b4:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  67d6b9:	0f 28 e2             	movaps %xmm2,%xmm4
  67d6bc:	0f 55 e3             	andnps %xmm3,%xmm4
  67d6bf:	0f 54 d1             	andps  %xmm1,%xmm2
  67d6c2:	0f 56 d4             	orps   %xmm4,%xmm2
  67d6c5:	0f 28 d9             	movaps %xmm1,%xmm3
  67d6c8:	f3 0f 5f d8          	maxss  %xmm0,%xmm3
  67d6cc:	0f 2e c1             	ucomiss %xmm1,%xmm0
  67d6cf:	89 f7                	mov    %esi,%edi
  67d6d1:	0f 46 f8             	cmovbe %eax,%edi
  67d6d4:	0f 28 c3             	movaps %xmm3,%xmm0
  67d6d7:	f3 0f c2 c3 03       	cmpunordss %xmm3,%xmm0
  67d6dc:	44 0f b6 c1          	movzbl %cl,%r8d
  67d6e0:	0f b6 d2             	movzbl %dl,%edx
  67d6e3:	44 89 c1             	mov    %r8d,%ecx
  67d6e6:	0f 46 ca             	cmovbe %edx,%ecx
  67d6e9:	0f 28 e0             	movaps %xmm0,%xmm4
  67d6ec:	0f 46 c6             	cmovbe %esi,%eax
  67d6ef:	0f 55 e3             	andnps %xmm3,%xmm4
  67d6f2:	41 0f 46 d0          	cmovbe %r8d,%edx
  67d6f6:	0f 54 c1             	andps  %xmm1,%xmm0
  67d6f9:	0f 56 c4             	orps   %xmm4,%xmm0
  67d6fc:	0f 28 ca             	movaps %xmm2,%xmm1
  67d6ff:	89 fe                	mov    %edi,%esi
  67d701:	f3 0f 10 54 24 1c    	movss  0x1c(%rsp),%xmm2
  67d707:	0f 2e ca             	ucomiss %xmm2,%xmm1
  67d70a:	0f 86 5e ff ff ff    	jbe    67d66e <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1be>
  67d710:	41 80 fe 02          	cmp    $0x2,%r14b
  67d714:	74 24                	je     67d73a <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x28a>
  67d716:	f3 0f 10 44 24 14    	movss  0x14(%rsp),%xmm0
  67d71c:	0f 2e c1             	ucomiss %xmm1,%xmm0
  67d71f:	8b 44 24 10          	mov    0x10(%rsp),%eax
  67d723:	76 0d                	jbe    67d732 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x282>
  67d725:	f3 0f 11 4c 24 14    	movss  %xmm1,0x14(%rsp)
  67d72b:	89 74 24 18          	mov    %esi,0x18(%rsp)
  67d72f:	41 89 ce             	mov    %ecx,%r14d
  67d732:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  67d738:	eb 17                	jmp    67d751 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2a1>
  67d73a:	f3 0f 11 4c 24 14    	movss  %xmm1,0x14(%rsp)
  67d740:	89 74 24 18          	mov    %esi,0x18(%rsp)
  67d744:	41 89 ce             	mov    %ecx,%r14d
  67d747:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  67d74d:	8b 44 24 10          	mov    0x10(%rsp),%eax
  67d751:	89 ea                	mov    %ebp,%edx
  67d753:	80 bc 24 d8 00 00 00 	cmpb   $0x0,0xd8(%rsp)
  67d75a:	00 
  67d75b:	89 d5                	mov    %edx,%ebp
  67d75d:	89 44 24 10          	mov    %eax,0x10(%rsp)
  67d761:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  67d767:	0f 84 53 fe ff ff    	je     67d5c0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x110>
  67d76d:	eb 0c                	jmp    67d77b <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2cb>
  67d76f:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  67d775:	8b 44 24 10          	mov    0x10(%rsp),%eax
  67d779:	89 ea                	mov    %ebp,%edx
  67d77b:	80 fa 02             	cmp    $0x2,%dl
  67d77e:	0f 85 ad 00 00 00    	jne    67d831 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x381>
  67d784:	41 80 fe 02          	cmp    $0x2,%r14b
  67d788:	8b 74 24 18          	mov    0x18(%rsp),%esi
  67d78c:	0f 85 3c fd ff ff    	jne    67d4ce <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1e>
  67d792:	0f 10 84 24 f0 00 00 	movups 0xf0(%rsp),%xmm0
  67d799:	00 
  67d79a:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  67d7a1:	00 
  67d7a2:	0f 11 44 24 60       	movups %xmm0,0x60(%rsp)
  67d7a7:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  67d7ac:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
  67d7b3:	00 00 
  67d7b5:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  67d7bc:	00 
  67d7bd:	48 8d 84 24 98 00 00 	lea    0x98(%rsp),%rax
  67d7c4:	00 
  67d7c5:	c6 84 24 98 00 00 00 	movb   $0x0,0x98(%rsp)
  67d7cc:	00 
  67d7cd:	48 8d 8c 24 88 00 00 	lea    0x88(%rsp),%rcx
  67d7d4:	00 
  67d7d5:	48 89 9c 24 88 00 00 	mov    %rbx,0x88(%rsp)
  67d7dc:	00 
  67d7dd:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  67d7e2:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  67d7e9:	00 
  67d7ea:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  67d7ef:	48 89 5c 24 30       	mov    %rbx,0x30(%rsp)
  67d7f4:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
  67d7f9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  67d7fe:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  67d803:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
  67d808:	e8 c3 ea fe ff       	call   66c2d0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::TextPosition>, <gpui_canvas::text::layout::TextGeometry>::position_on_line::{closure#4}::{closure#0}, core::iter::traits::iterator::Iterator::find_map::check<gpui_canvas::text::layout::Stop, gpui_canvas::text::layout::TextPosition, <gpui_canvas::text::layout::TextGeometry>::position_on_line::{closure#4}::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::TextPosition>>>>
  67d80d:	89 c6                	mov    %eax,%esi
  67d80f:	80 fa ff             	cmp    $0xff,%dl
  67d812:	0f b6 c2             	movzbl %dl,%eax
  67d815:	b9 02 00 00 00       	mov    $0x2,%ecx
  67d81a:	0f 44 c1             	cmove  %ecx,%eax
  67d81d:	89 c2                	mov    %eax,%edx
  67d81f:	80 e2 01             	and    $0x1,%dl
  67d822:	3c 02                	cmp    $0x2,%al
  67d824:	44 0f b6 f2          	movzbl %dl,%r14d
  67d828:	44 0f 44 f1          	cmove  %ecx,%r14d
  67d82c:	e9 9d fc ff ff       	jmp    67d4ce <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1e>
  67d831:	41 80 fe 02          	cmp    $0x2,%r14b
  67d835:	8b 74 24 18          	mov    0x18(%rsp),%esi
  67d839:	75 0a                	jne    67d845 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x395>
  67d83b:	41 89 d6             	mov    %edx,%r14d
  67d83e:	89 c6                	mov    %eax,%esi
  67d840:	e9 89 fc ff ff       	jmp    67d4ce <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1e>
  67d845:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  67d849:	f3 0f 10 4c 24 14    	movss  0x14(%rsp),%xmm1
  67d84f:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  67d853:	f2 0f 58 c8          	addsd  %xmm0,%xmm1
  67d857:	f2 0f 59 0d a1 6f 9a 	mulsd  -0x65905f(%rip),%xmm1        # 24800 <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x111>
  67d85e:	ff 
  67d85f:	f3 0f 10 44 24 1c    	movss  0x1c(%rsp),%xmm0
  67d865:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  67d869:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  67d86d:	0f 46 f0             	cmovbe %eax,%esi
  67d870:	41 0f b6 c6          	movzbl %r14b,%eax
  67d874:	44 0f b6 f2          	movzbl %dl,%r14d
  67d878:	44 0f 47 f0          	cmova  %eax,%r14d
  67d87c:	e9 4d fc ff ff       	jmp    67d4ce <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1e>
  67d881:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  67d885:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  67d889:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
  67d88d:	f2 0f 59 05 6b 6f 9a 	mulsd  -0x659095(%rip),%xmm0        # 24800 <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x111>
  67d894:	ff 
  67d895:	0f 57 c9             	xorps  %xmm1,%xmm1
  67d898:	f3 0f 5a ca          	cvtss2sd %xmm2,%xmm1
  67d89c:	66 0f 2e c8          	ucomisd %xmm0,%xmm1
  67d8a0:	0f 47 f0             	cmova  %eax,%esi
  67d8a3:	0f b6 c2             	movzbl %dl,%eax
  67d8a6:	44 0f b6 f1          	movzbl %cl,%r14d
  67d8aa:	44 0f 47 f0          	cmova  %eax,%r14d
  67d8ae:	e9 1b fc ff ff       	jmp    67d4ce <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1e>
  67d8b3:	48 8d 15 16 1e 10 00 	lea    0x101e16(%rip),%rdx        # 77f6d0 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0x78>
  67d8ba:	ff 15 d0 bf 10 00    	call   *0x10bfd0(%rip)        # 789890 <_DYNAMIC+0x368>
