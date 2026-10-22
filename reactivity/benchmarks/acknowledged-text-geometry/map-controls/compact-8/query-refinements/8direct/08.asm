
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000683540 <<gpui_canvas::text::layout::TextGeometry>::move_visual>:
  683540:	55                   	push   %rbp
  683541:	41 57                	push   %r15
  683543:	41 56                	push   %r14
  683545:	41 55                	push   %r13
  683547:	41 54                	push   %r12
  683549:	53                   	push   %rbx
  68354a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  683551:	41 89 cf             	mov    %ecx,%r15d
  683554:	41 89 d6             	mov    %edx,%r14d
  683557:	89 f5                	mov    %esi,%ebp
  683559:	48 89 fb             	mov    %rdi,%rbx
  68355c:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  683561:	48 89 de             	mov    %rbx,%rsi
  683564:	89 ea                	mov    %ebp,%edx
  683566:	44 89 f1             	mov    %r14d,%ecx
  683569:	ff 15 69 64 10 00    	call   *0x106469(%rip)        # 7899d8 <_DYNAMIC+0x570>
  68356f:	83 7c 24 60 01       	cmpl   $0x1,0x60(%rsp)
  683574:	0f 85 43 02 00 00    	jne    6837bd <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x27d>
  68357a:	f3 0f 10 44 24 64    	movss  0x64(%rsp),%xmm0
  683580:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
  683586:	41 0f b6 d6          	movzbl %r14b,%edx
  68358a:	48 89 df             	mov    %rbx,%rdi
  68358d:	89 ee                	mov    %ebp,%esi
  68358f:	ff 15 73 68 10 00    	call   *0x106873(%rip)        # 789e08 <_DYNAMIC+0x9a0>
  683595:	a8 01                	test   $0x1,%al
  683597:	0f 84 24 02 00 00    	je     6837c1 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x281>
  68359d:	44 89 7c 24 04       	mov    %r15d,0x4(%rsp)
  6835a2:	44 89 74 24 0c       	mov    %r14d,0xc(%rsp)
  6835a7:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  6835ac:	4c 8d 6c 24 28       	lea    0x28(%rsp),%r13
  6835b1:	4c 89 ef             	mov    %r13,%rdi
  6835b4:	48 89 de             	mov    %rbx,%rsi
  6835b7:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6835bc:	e8 ff 31 00 00       	call   6867c0 <<gpui_canvas::text::layout::TextGeometry>::line_tail>
  6835c1:	f3 0f 10 43 4c       	movss  0x4c(%rbx),%xmm0
  6835c6:	f3 0f 59 05 aa a0 99 	mulss  -0x665f56(%rip),%xmm0        # 1d678 <GCC_except_table0+0x8c>
  6835cd:	ff 
  6835ce:	0f 57 c9             	xorps  %xmm1,%xmm1
  6835d1:	0f 11 8c 24 a8 00 00 	movups %xmm1,0xa8(%rsp)
  6835d8:	00 
  6835d9:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  6835de:	0f 29 4c 24 60       	movaps %xmm1,0x60(%rsp)
  6835e3:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6835e8:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  6835ed:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  6835f4:	00 
  6835f5:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  6835fc:	00 
  6835fd:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
  683604:	00 00 
  683606:	48 c7 84 24 98 00 00 	movq   $0x0,0x98(%rsp)
  68360d:	00 00 00 00 00 
  683612:	48 c7 84 24 a0 00 00 	movq   $0x1,0xa0(%rsp)
  683619:	00 01 00 00 00 
  68361e:	48 89 9c 24 b8 00 00 	mov    %rbx,0xb8(%rsp)
  683625:	00 
  683626:	f3 0f 11 84 24 c0 00 	movss  %xmm0,0xc0(%rsp)
  68362d:	00 00 
  68362f:	48 89 9c 24 c8 00 00 	mov    %rbx,0xc8(%rsp)
  683636:	00 
  683637:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  68363c:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  683643:	00 
  683644:	c6 84 24 d8 00 00 00 	movb   $0x0,0xd8(%rsp)
  68364b:	00 
  68364c:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  683653:	00 
  683654:	f3 0f 10 05 4c a0 99 	movss  -0x665fb4(%rip),%xmm0        # 1d6a8 <GCC_except_table0+0xbc>
  68365b:	ff 
  68365c:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  683662:	b2 02                	mov    $0x2,%dl
  683664:	4c 8d a4 24 e8 00 00 	lea    0xe8(%rsp),%r12
  68366b:	00 
  68366c:	4c 8d 7c 24 60       	lea    0x60(%rsp),%r15
  683671:	41 89 d6             	mov    %edx,%r14d
  683674:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  68367b:	00 00 00 00 00 
  683680:	4c 89 e7             	mov    %r12,%rdi
  683683:	4c 89 fe             	mov    %r15,%rsi
  683686:	e8 95 36 00 00       	call   686d20 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next>
  68368b:	83 bc 24 e8 00 00 00 	cmpl   $0x2,0xe8(%rsp)
  683692:	02 
  683693:	0f 84 2c 01 00 00    	je     6837c5 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x285>
  683699:	48 8b b4 24 b8 00 00 	mov    0xb8(%rsp),%rsi
  6836a0:	00 
  6836a1:	f3 0f 10 84 24 c0 00 	movss  0xc0(%rsp),%xmm0
  6836a8:	00 00 
  6836aa:	4c 89 ef             	mov    %r13,%rdi
  6836ad:	4c 89 e2             	mov    %r12,%rdx
  6836b0:	e8 3b fb ff ff       	call   6831f0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}>
  6836b5:	0f b6 44 24 2c       	movzbl 0x2c(%rsp),%eax
  6836ba:	3c 02                	cmp    $0x2,%al
  6836bc:	74 c2                	je     683680 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x140>
  6836be:	48 8b 94 24 c8 00 00 	mov    0xc8(%rsp),%rdx
  6836c5:	00 
  6836c6:	48 8b 8c 24 d0 00 00 	mov    0xd0(%rsp),%rcx
  6836cd:	00 
  6836ce:	48 8b 39             	mov    (%rcx),%rdi
  6836d1:	48 8b 72 40          	mov    0x40(%rdx),%rsi
  6836d5:	48 39 f7             	cmp    %rsi,%rdi
  6836d8:	0f 83 77 01 00 00    	jae    683855 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x315>
  6836de:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
  6836e2:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  6836e6:	48 8d 34 7f          	lea    (%rdi,%rdi,2),%rsi
  6836ea:	3b 4c f2 04          	cmp    0x4(%rdx,%rsi,8),%ecx
  6836ee:	0f 87 d1 00 00 00    	ja     6837c5 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x285>
  6836f4:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6836f9:	48 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%rsi
  683700:	00 
  683701:	48 3b 16             	cmp    (%rsi),%rdx
  683704:	0f 85 76 ff ff ff    	jne    683680 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x140>
  68370a:	f6 44 24 58 01       	testb  $0x1,0x58(%rsp)
  68370f:	0f 85 6b ff ff ff    	jne    683680 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x140>
  683715:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
  68371b:	f3 0f 10 4c 24 54    	movss  0x54(%rsp),%xmm1
  683721:	80 7c 24 04 00       	cmpb   $0x0,0x4(%rsp)
  683726:	74 23                	je     68374b <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x20b>
  683728:	0f 28 d8             	movaps %xmm0,%xmm3
  68372b:	f3 0f 5f d9          	maxss  %xmm1,%xmm3
  68372f:	0f 28 d3             	movaps %xmm3,%xmm2
  683732:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  683737:	0f 28 e2             	movaps %xmm2,%xmm4
  68373a:	0f 55 e3             	andnps %xmm3,%xmm4
  68373d:	0f 54 d0             	andps  %xmm0,%xmm2
  683740:	0f 56 d4             	orps   %xmm4,%xmm2
  683743:	f3 0f 5c 54 24 10    	subss  0x10(%rsp),%xmm2
  683749:	eb 25                	jmp    683770 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x230>
  68374b:	0f 28 d0             	movaps %xmm0,%xmm2
  68374e:	f3 0f 5d d1          	minss  %xmm1,%xmm2
  683752:	0f 28 da             	movaps %xmm2,%xmm3
  683755:	f3 0f c2 da 03       	cmpunordss %xmm2,%xmm3
  68375a:	0f 28 e3             	movaps %xmm3,%xmm4
  68375d:	0f 55 e2             	andnps %xmm2,%xmm4
  683760:	0f 54 d8             	andps  %xmm0,%xmm3
  683763:	0f 56 dc             	orps   %xmm4,%xmm3
  683766:	f3 0f 10 54 24 10    	movss  0x10(%rsp),%xmm2
  68376c:	f3 0f 5c d3          	subss  %xmm3,%xmm2
  683770:	44 89 f2             	mov    %r14d,%edx
  683773:	0f 57 db             	xorps  %xmm3,%xmm3
  683776:	0f 2e d3             	ucomiss %xmm3,%xmm2
  683779:	76 32                	jbe    6837ad <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x26d>
  68377b:	f3 0f 10 5c 24 08    	movss  0x8(%rsp),%xmm3
  683781:	0f 2e da             	ucomiss %xmm2,%xmm3
  683784:	76 27                	jbe    6837ad <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x26d>
  683786:	0f 2e c8             	ucomiss %xmm0,%xmm1
  683789:	0f 96 c2             	setbe  %dl
  68378c:	32 54 24 04          	xor    0x4(%rsp),%dl
  683790:	0f 45 4c 24 30       	cmovne 0x30(%rsp),%ecx
  683795:	0f b6 74 24 34       	movzbl 0x34(%rsp),%esi
  68379a:	0f b6 d0             	movzbl %al,%edx
  68379d:	0f 45 d6             	cmovne %esi,%edx
  6837a0:	80 e2 01             	and    $0x1,%dl
  6837a3:	f3 0f 11 54 24 08    	movss  %xmm2,0x8(%rsp)
  6837a9:	89 4c 24 14          	mov    %ecx,0x14(%rsp)
  6837ad:	80 bc 24 d8 00 00 00 	cmpb   $0x0,0xd8(%rsp)
  6837b4:	00 
  6837b5:	0f 84 b6 fe ff ff    	je     683671 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x131>
  6837bb:	eb 0b                	jmp    6837c8 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x288>
  6837bd:	b2 02                	mov    $0x2,%dl
  6837bf:	eb 78                	jmp    683839 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2f9>
  6837c1:	b2 02                	mov    $0x2,%dl
  6837c3:	eb 72                	jmp    683837 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2f7>
  6837c5:	44 89 f2             	mov    %r14d,%edx
  6837c8:	80 fa 02             	cmp    $0x2,%dl
  6837cb:	8b 44 24 14          	mov    0x14(%rsp),%eax
  6837cf:	75 66                	jne    683837 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2f7>
  6837d1:	80 7c 24 04 00       	cmpb   $0x0,0x4(%rsp)
  6837d6:	74 29                	je     683801 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2c1>
  6837d8:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  6837dd:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  6837e1:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  6837e5:	74 66                	je     68384d <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x30d>
  6837e7:	48 ff c6             	inc    %rsi
  6837ea:	31 c0                	xor    %eax,%eax
  6837ec:	48 3b 73 40          	cmp    0x40(%rbx),%rsi
  6837f0:	0f 92 c0             	setb   %al
  6837f3:	a8 01                	test   $0x1,%al
  6837f5:	74 5c                	je     683853 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x313>
  6837f7:	f3 0f 10 05 b5 9e 99 	movss  -0x66614b(%rip),%xmm0        # 1d6b4 <GCC_except_table0+0xc8>
  6837fe:	ff 
  6837ff:	eb 2e                	jmp    68382f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2ef>
  683801:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  683806:	48 85 f6             	test   %rsi,%rsi
  683809:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  68380d:	74 12                	je     683821 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2e1>
  68380f:	48 ff ce             	dec    %rsi
  683812:	31 c0                	xor    %eax,%eax
  683814:	48 3b 73 40          	cmp    0x40(%rbx),%rsi
  683818:	0f 92 c0             	setb   %al
  68381b:	a8 01                	test   $0x1,%al
  68381d:	75 08                	jne    683827 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2e7>
  68381f:	eb 32                	jmp    683853 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x313>
  683821:	31 c0                	xor    %eax,%eax
  683823:	a8 01                	test   $0x1,%al
  683825:	74 2c                	je     683853 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x313>
  683827:	f3 0f 10 05 71 9e 99 	movss  -0x66618f(%rip),%xmm0        # 1d6a0 <GCC_except_table0+0xb4>
  68382e:	ff 
  68382f:	48 89 df             	mov    %rbx,%rdi
  683832:	e8 39 00 00 00       	call   683870 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>
  683837:	89 c5                	mov    %eax,%ebp
  683839:	89 e8                	mov    %ebp,%eax
  68383b:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  683842:	5b                   	pop    %rbx
  683843:	41 5c                	pop    %r12
  683845:	41 5d                	pop    %r13
  683847:	41 5e                	pop    %r14
  683849:	41 5f                	pop    %r15
  68384b:	5d                   	pop    %rbp
  68384c:	c3                   	ret
  68384d:	31 c0                	xor    %eax,%eax
  68384f:	a8 01                	test   $0x1,%al
  683851:	75 a4                	jne    6837f7 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2b7>
  683853:	eb e4                	jmp    683839 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2f9>
  683855:	48 8d 15 2c c5 0f 00 	lea    0xfc52c(%rip),%rdx        # 77fd88 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x180>
  68385c:	ff 15 76 5f 10 00    	call   *0x105f76(%rip)        # 7897d8 <_DYNAMIC+0x370>
