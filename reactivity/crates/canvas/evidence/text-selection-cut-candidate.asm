000000000065b4a0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>>:
  65b4a0:	55                   	push   %rbp
  65b4a1:	41 57                	push   %r15
  65b4a3:	41 56                	push   %r14
  65b4a5:	41 55                	push   %r13
  65b4a7:	41 54                	push   %r12
  65b4a9:	53                   	push   %rbx
  65b4aa:	48 81 ec a8 00 00 00 	sub    $0xa8,%rsp
  65b4b1:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
  65b4b6:	49 89 f7             	mov    %rsi,%r15
  65b4b9:	49 89 fe             	mov    %rdi,%r14
  65b4bc:	ff 15 56 5d 11 00    	call   *0x115d56(%rip)        # 771218 <_DYNAMIC+0x360>
  65b4c2:	89 c5                	mov    %eax,%ebp
  65b4c4:	84 c0                	test   %al,%al
  65b4c6:	0f 84 22 05 00 00    	je     65b9ee <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x54e>
  65b4cc:	41 8b 17             	mov    (%r15),%edx
  65b4cf:	41 8b 47 08          	mov    0x8(%r15),%eax
  65b4d3:	39 d0                	cmp    %edx,%eax
  65b4d5:	89 d6                	mov    %edx,%esi
  65b4d7:	0f 42 f0             	cmovb  %eax,%esi
  65b4da:	0f 47 d0             	cmova  %eax,%edx
  65b4dd:	0f 84 0b 05 00 00    	je     65b9ee <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x54e>
  65b4e3:	4d 8b 7e 20          	mov    0x20(%r14),%r15
  65b4e7:	4d 85 ff             	test   %r15,%r15
  65b4ea:	0f 84 2b 05 00 00    	je     65ba1b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x57b>
  65b4f0:	4c 89 ff             	mov    %r15,%rdi
  65b4f3:	ff 15 27 5d 11 00    	call   *0x115d27(%rip)        # 771220 <_DYNAMIC+0x368>
  65b4f9:	48 89 d1             	mov    %rdx,%rcx
  65b4fc:	f3 41 0f 10 46 34    	movss  0x34(%r14),%xmm0
  65b502:	f3 0f 59 05 36 ec 9b 	mulss  -0x6413ca(%rip),%xmm0        # 1a140 <GCC_except_table0+0x80>
  65b509:	ff
  65b50a:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  65b50f:	4c 89 fe             	mov    %r15,%rsi
  65b512:	48 89 c2             	mov    %rax,%rdx
  65b515:	ff 15 0d 5d 11 00    	call   *0x115d0d(%rip)        # 771228 <_DYNAMIC+0x370>
  65b51b:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  65b520:	48 85 c0             	test   %rax,%rax
  65b523:	0f 84 c5 04 00 00    	je     65b9ee <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x54e>
  65b529:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  65b52e:	48 8b 09             	mov    (%rcx),%rcx
  65b531:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  65b536:	4c 8b bc 24 98 00 00 	mov    0x98(%rsp),%r15
  65b53d:	00
  65b53e:	f3 0f 10 84 24 a0 00 	movss  0xa0(%rsp),%xmm0
  65b545:	00 00
  65b547:	f3 0f 11 44 24 14    	movss  %xmm0,0x14(%rsp)
  65b54d:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  65b554:	00 00
  65b556:	f3 0f 11 7c 24 10    	movss  %xmm7,0x10(%rsp)
  65b55c:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
  65b562:	0f 28 e9             	movaps %xmm1,%xmm5
  65b565:	0f 28 f0             	movaps %xmm0,%xmm6
  65b568:	eb 34                	jmp    65b59e <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xfe>
  65b56a:	f3 0f 10 4c 24 14    	movss  0x14(%rsp),%xmm1
  65b570:	0f 57 d2             	xorps  %xmm2,%xmm2
  65b573:	0f 2e ca             	ucomiss %xmm2,%xmm1
  65b576:	0f 85 b3 02 00 00    	jne    65b82f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x38f>
  65b57c:	0f 8a ad 02 00 00    	jp     65b82f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x38f>
  65b582:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  65b589:	1f 84 00 00 00 00 00
  65b590:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  65b595:	48 85 c0             	test   %rax,%rax
  65b598:	0f 84 f3 03 00 00    	je     65b991 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4f1>
  65b59e:	4c 8b 74 24 60       	mov    0x60(%rsp),%r14
  65b5a3:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  65b5a9:	48 83 f8 01          	cmp    $0x1,%rax
  65b5ad:	74 28                	je     65b5d7 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x137>
  65b5af:	49 8d 4e 28          	lea    0x28(%r14),%rcx
  65b5b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  65b5b7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  65b5be:	00 00
  65b5c0:	8b 71 e8             	mov    -0x18(%rcx),%esi
  65b5c3:	3b 31                	cmp    (%rcx),%esi
  65b5c5:	75 10                	jne    65b5d7 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x137>
  65b5c7:	49 ff c5             	inc    %r13
  65b5ca:	48 83 c1 18          	add    $0x18,%rcx
  65b5ce:	48 ff ca             	dec    %rdx
  65b5d1:	48 83 fa 02          	cmp    $0x2,%rdx
  65b5d5:	77 e9                	ja     65b5c0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x120>
  65b5d7:	4c 29 e8             	sub    %r13,%rax
  65b5da:	0f 82 22 04 00 00    	jb     65ba02 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x562>
  65b5e0:	4a 8d 0c 6d 00 00 00 	lea    0x0(,%r13,2),%rcx
  65b5e7:	00
  65b5e8:	4c 01 e9             	add    %r13,%rcx
  65b5eb:	49 8d 0c ce          	lea    (%r14,%rcx,8),%rcx
  65b5ef:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  65b5f4:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  65b5f9:	48 8b b4 24 80 00 00 	mov    0x80(%rsp),%rsi
  65b600:	00
  65b601:	48 85 f6             	test   %rsi,%rsi
  65b604:	0f 85 ca 02 00 00    	jne    65b8d4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x434>
  65b60a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  65b60f:	48 85 c0             	test   %rax,%rax
  65b612:	74 5c                	je     65b670 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1d0>
  65b614:	4c 8b 64 24 70       	mov    0x70(%rsp),%r12
  65b619:	ba 01 00 00 00       	mov    $0x1,%edx
  65b61e:	48 83 f8 01          	cmp    $0x1,%rax
  65b622:	74 23                	je     65b647 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1a7>
  65b624:	49 8d 4c 24 28       	lea    0x28(%r12),%rcx
  65b629:	48 8d 70 01          	lea    0x1(%rax),%rsi
  65b62d:	0f 1f 00             	nopl   (%rax)
  65b630:	8b 79 e8             	mov    -0x18(%rcx),%edi
  65b633:	3b 39                	cmp    (%rcx),%edi
  65b635:	75 10                	jne    65b647 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1a7>
  65b637:	48 ff c2             	inc    %rdx
  65b63a:	48 83 c1 18          	add    $0x18,%rcx
  65b63e:	48 ff ce             	dec    %rsi
  65b641:	48 83 fe 02          	cmp    $0x2,%rsi
  65b645:	77 e9                	ja     65b630 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x190>
  65b647:	48 29 d0             	sub    %rdx,%rax
  65b64a:	0f 82 b2 03 00 00    	jb     65ba02 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x562>
  65b650:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  65b654:	49 8d 0c cc          	lea    (%r12,%rcx,8),%rcx
  65b658:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  65b65d:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  65b662:	4d 85 e4             	test   %r12,%r12
  65b665:	75 15                	jne    65b67c <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1dc>
  65b667:	e9 25 03 00 00       	jmp    65b991 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4f1>
  65b66c:	0f 1f 40 00          	nopl   0x0(%rax)
  65b670:	45 31 e4             	xor    %r12d,%r12d
  65b673:	4d 85 e4             	test   %r12,%r12
  65b676:	0f 84 15 03 00 00    	je     65b991 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4f1>
  65b67c:	49 c1 e5 03          	shl    $0x3,%r13
  65b680:	4a 8d 04 6d 00 00 00 	lea    0x0(,%r13,2),%rax
  65b687:	00
  65b688:	4c 01 e8             	add    %r13,%rax
  65b68b:	31 c9                	xor    %ecx,%ecx
  65b68d:	0f 1f 00             	nopl   (%rax)
  65b690:	48 39 c8             	cmp    %rcx,%rax
  65b693:	0f 84 f7 fe ff ff    	je     65b590 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xf0>
  65b699:	4c 8d 69 18          	lea    0x18(%rcx),%r13
  65b69d:	41 f6 44 0e 14 02    	testb  $0x2,0x14(%r14,%rcx,1)
  65b6a3:	4c 89 e9             	mov    %r13,%rcx
  65b6a6:	74 e8                	je     65b690 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1f0>
  65b6a8:	48 c1 e2 03          	shl    $0x3,%rdx
  65b6ac:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
  65b6b0:	31 c9                	xor    %ecx,%ecx
  65b6b2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  65b6b9:	1f 84 00 00 00 00 00
  65b6c0:	48 39 c8             	cmp    %rcx,%rax
  65b6c3:	0f 84 c7 fe ff ff    	je     65b590 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xf0>
  65b6c9:	48 8d 59 18          	lea    0x18(%rcx),%rbx
  65b6cd:	41 f6 44 0c 14 01    	testb  $0x1,0x14(%r12,%rcx,1)
  65b6d3:	48 89 d9             	mov    %rbx,%rcx
  65b6d6:	74 e8                	je     65b6c0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x220>
  65b6d8:	0f 29 74 24 40       	movaps %xmm6,0x40(%rsp)
  65b6dd:	0f 29 6c 24 50       	movaps %xmm5,0x50(%rsp)
  65b6e2:	f3 43 0f 10 44 2e ec 	movss  -0x14(%r14,%r13,1),%xmm0
  65b6e9:	f3 0f 11 44 24 3c    	movss  %xmm0,0x3c(%rsp)
  65b6ef:	4c 89 ff             	mov    %r15,%rdi
  65b6f2:	ff 15 38 5b 11 00    	call   *0x115b38(%rip)        # 771230 <_DYNAMIC+0x378>
  65b6f8:	f3 0f 10 7c 24 3c    	movss  0x3c(%rsp),%xmm7
  65b6fe:	41 0f 2e 7c 1c ec    	ucomiss -0x14(%r12,%rbx,1),%xmm7
  65b704:	f3 43 0f 10 44 2e e8 	movss  -0x18(%r14,%r13,1),%xmm0
  65b70b:	75 02                	jne    65b70f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x26f>
  65b70d:	7b 28                	jnp    65b737 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x297>
  65b70f:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  65b713:	49 8b 57 10          	mov    0x10(%r15),%rdx
  65b717:	48 89 d6             	mov    %rdx,%rsi
  65b71a:	48 85 d2             	test   %rdx,%rdx
  65b71d:	0f 28 6c 24 50       	movaps 0x50(%rsp),%xmm5
  65b722:	0f 28 74 24 40       	movaps 0x40(%rsp),%xmm6
  65b727:	0f 84 95 00 00 00    	je     65b7c2 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x322>
  65b72d:	48 83 fa 01          	cmp    $0x1,%rdx
  65b731:	75 55                	jne    65b788 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x2e8>
  65b733:	31 f6                	xor    %esi,%esi
  65b735:	eb 7c                	jmp    65b7b3 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x313>
  65b737:	f3 41 0f 10 4c 1c e8 	movss  -0x18(%r12,%rbx,1),%xmm1
  65b73e:	0f 28 d0             	movaps %xmm0,%xmm2
  65b741:	f3 0f 5d d1          	minss  %xmm1,%xmm2
  65b745:	0f 28 da             	movaps %xmm2,%xmm3
  65b748:	f3 0f c2 da 03       	cmpunordss %xmm2,%xmm3
  65b74d:	0f 28 e3             	movaps %xmm3,%xmm4
  65b750:	0f 55 e2             	andnps %xmm2,%xmm4
  65b753:	0f 54 d8             	andps  %xmm0,%xmm3
  65b756:	0f 56 dc             	orps   %xmm4,%xmm3
  65b759:	f3 0f 5c c8          	subss  %xmm0,%xmm1
  65b75d:	0f 54 0d 1c 64 9c ff 	andps  -0x639be4(%rip),%xmm1        # 21b80 <anon.121202b9d17673f1d19189a9331508d6.3.llvm.15539743372968447683+0x7d0>
  65b764:	0f 28 c3             	movaps %xmm3,%xmm0
  65b767:	0f 28 6c 24 50       	movaps 0x50(%rsp),%xmm5
  65b76c:	0f 28 74 24 40       	movaps 0x40(%rsp),%xmm6
  65b771:	0f 57 d2             	xorps  %xmm2,%xmm2
  65b774:	0f 2e ca             	ucomiss %xmm2,%xmm1
  65b777:	0f 85 b2 00 00 00    	jne    65b82f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x38f>
  65b77d:	0f 8b 0d fe ff ff    	jnp    65b590 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xf0>
  65b783:	e9 a7 00 00 00       	jmp    65b82f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x38f>
  65b788:	48 89 d7             	mov    %rdx,%rdi
  65b78b:	31 f6                	xor    %esi,%esi
  65b78d:	0f 1f 00             	nopl   (%rax)
  65b790:	49 89 f8             	mov    %rdi,%r8
  65b793:	49 d1 e8             	shr    $1,%r8
  65b796:	4d 8d 0c 30          	lea    (%r8,%rsi,1),%r9
  65b79a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  65b79e:	46 8b 54 d1 10       	mov    0x10(%rcx,%r10,8),%r10d
  65b7a3:	4c 39 d0             	cmp    %r10,%rax
  65b7a6:	49 0f 47 f1          	cmova  %r9,%rsi
  65b7aa:	4c 29 c7             	sub    %r8,%rdi
  65b7ad:	48 83 ff 01          	cmp    $0x1,%rdi
  65b7b1:	77 dd                	ja     65b790 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x2f0>
  65b7b3:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  65b7b7:	8b 7c f9 10          	mov    0x10(%rcx,%rdi,8),%edi
  65b7bb:	48 39 c7             	cmp    %rax,%rdi
  65b7be:	48 83 d6 00          	adc    $0x0,%rsi
  65b7c2:	48 c1 e6 03          	shl    $0x3,%rsi
  65b7c6:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  65b7ca:	4c 8d 04 31          	lea    (%rcx,%rsi,1),%r8
  65b7ce:	43 8b 7c 2e f8       	mov    -0x8(%r14,%r13,1),%edi
  65b7d3:	48 c1 e2 03          	shl    $0x3,%rdx
  65b7d7:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  65b7db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  65b7e0:	48 39 f2             	cmp    %rsi,%rdx
  65b7e3:	0f 84 81 fd ff ff    	je     65b56a <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xca>
  65b7e9:	4d 89 c1             	mov    %r8,%r9
  65b7ec:	45 8b 40 10          	mov    0x10(%r8),%r8d
  65b7f0:	4c 39 c0             	cmp    %r8,%rax
  65b7f3:	0f 85 71 fd ff ff    	jne    65b56a <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xca>
  65b7f9:	4d 8d 41 18          	lea    0x18(%r9),%r8
  65b7fd:	48 83 c6 18          	add    $0x18,%rsi
  65b801:	41 39 39             	cmp    %edi,(%r9)
  65b804:	77 da                	ja     65b7e0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x340>
  65b806:	41 3b 79 04          	cmp    0x4(%r9),%edi
  65b80a:	77 d4                	ja     65b7e0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x340>
  65b80c:	80 7c 31 fd 01       	cmpb   $0x1,-0x3(%rcx,%rsi,1)
  65b811:	0f 85 53 fd ff ff    	jne    65b56a <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xca>
  65b817:	f3 0f 10 4c 24 14    	movss  0x14(%rsp),%xmm1
  65b81d:	f3 0f 5c c1          	subss  %xmm1,%xmm0
  65b821:	0f 57 d2             	xorps  %xmm2,%xmm2
  65b824:	0f 2e ca             	ucomiss %xmm2,%xmm1
  65b827:	75 06                	jne    65b82f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x38f>
  65b829:	0f 8b 61 fd ff ff    	jnp    65b590 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xf0>
  65b82f:	f3 43 0f 10 54 2e f4 	movss  -0xc(%r14,%r13,1),%xmm2
  65b836:	f6 44 24 28 01       	testb  $0x1,0x28(%rsp)
  65b83b:	0f 84 28 01 00 00    	je     65b969 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4c9>
  65b841:	f3 0f 10 5c 24 10    	movss  0x10(%rsp),%xmm3
  65b847:	0f 2e df             	ucomiss %xmm7,%xmm3
  65b84a:	0f 85 c4 00 00 00    	jne    65b914 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x474>
  65b850:	0f 8a be 00 00 00    	jp     65b914 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x474>
  65b856:	48 39 44 24 18       	cmp    %rax,0x18(%rsp)
  65b85b:	0f 85 b3 00 00 00    	jne    65b914 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x474>
  65b861:	f3 0f 10 5c 24 0c    	movss  0xc(%rsp),%xmm3
  65b867:	0f 2e da             	ucomiss %xmm2,%xmm3
  65b86a:	0f 85 a4 00 00 00    	jne    65b914 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x474>
  65b870:	0f 8a 9e 00 00 00    	jp     65b914 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x474>
  65b876:	0f 28 e0             	movaps %xmm0,%xmm4
  65b879:	f3 0f 58 e1          	addss  %xmm1,%xmm4
  65b87d:	0f 2e e6             	ucomiss %xmm6,%xmm4
  65b880:	0f 82 89 00 00 00    	jb     65b90f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x46f>
  65b886:	0f 28 dd             	movaps %xmm5,%xmm3
  65b889:	f3 0f 58 de          	addss  %xmm6,%xmm3
  65b88d:	0f 2e d8             	ucomiss %xmm0,%xmm3
  65b890:	72 7d                	jb     65b90f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x46f>
  65b892:	0f 28 cb             	movaps %xmm3,%xmm1
  65b895:	f3 0f 5f cc          	maxss  %xmm4,%xmm1
  65b899:	0f 28 e9             	movaps %xmm1,%xmm5
  65b89c:	f3 0f c2 e9 03       	cmpunordss %xmm1,%xmm5
  65b8a1:	0f 28 d5             	movaps %xmm5,%xmm2
  65b8a4:	0f 55 d1             	andnps %xmm1,%xmm2
  65b8a7:	0f 54 eb             	andps  %xmm3,%xmm5
  65b8aa:	0f 56 ea             	orps   %xmm2,%xmm5
  65b8ad:	0f 28 ce             	movaps %xmm6,%xmm1
  65b8b0:	f3 0f 5d c8          	minss  %xmm0,%xmm1
  65b8b4:	0f 28 c1             	movaps %xmm1,%xmm0
  65b8b7:	f3 0f c2 c1 03       	cmpunordss %xmm1,%xmm0
  65b8bc:	0f 28 d0             	movaps %xmm0,%xmm2
  65b8bf:	0f 55 d1             	andnps %xmm1,%xmm2
  65b8c2:	0f 54 c6             	andps  %xmm6,%xmm0
  65b8c5:	0f 56 c2             	orps   %xmm2,%xmm0
  65b8c8:	f3 0f 5c e8          	subss  %xmm0,%xmm5
  65b8cc:	0f 28 f0             	movaps %xmm0,%xmm6
  65b8cf:	e9 bc fc ff ff       	jmp    65b590 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xf0>
  65b8d4:	48 c7 84 24 80 00 00 	movq   $0x0,0x80(%rsp)
  65b8db:	00 00 00 00 00
  65b8e0:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  65b8e5:	0f 29 6c 24 50       	movaps %xmm5,0x50(%rsp)
  65b8ea:	0f 29 74 24 40       	movaps %xmm6,0x40(%rsp)
  65b8ef:	e8 6c 02 00 00       	call   65bb60 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::Details>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator>::nth>
  65b8f4:	0f 28 74 24 40       	movaps 0x40(%rsp),%xmm6
  65b8f9:	0f 28 6c 24 50       	movaps 0x50(%rsp),%xmm5
  65b8fe:	49 89 c4             	mov    %rax,%r12
  65b901:	4d 85 e4             	test   %r12,%r12
  65b904:	0f 85 72 fd ff ff    	jne    65b67c <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1dc>
  65b90a:	e9 82 00 00 00       	jmp    65b991 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4f1>
  65b90f:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  65b914:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  65b919:	48 c1 c2 07          	rol    $0x7,%rdx
  65b91d:	66 0f 7e f1          	movd   %xmm6,%ecx
  65b921:	48 31 d1             	xor    %rdx,%rcx
  65b924:	48 c1 c1 07          	rol    $0x7,%rcx
  65b928:	66 0f 6e 5c 24 10    	movd   0x10(%rsp),%xmm3
  65b92e:	66 0f 7e da          	movd   %xmm3,%edx
  65b932:	48 31 ca             	xor    %rcx,%rdx
  65b935:	48 c1 c2 07          	rol    $0x7,%rdx
  65b939:	66 0f 7e e9          	movd   %xmm5,%ecx
  65b93d:	48 31 d1             	xor    %rdx,%rcx
  65b940:	48 c1 c1 07          	rol    $0x7,%rcx
  65b944:	66 0f 6e 5c 24 0c    	movd   0xc(%rsp),%xmm3
  65b94a:	66 0f 7e da          	movd   %xmm3,%edx
  65b94e:	48 31 ca             	xor    %rcx,%rdx
  65b951:	48 c1 c2 07          	rol    $0x7,%rdx
  65b955:	8b 74 24 18          	mov    0x18(%rsp),%esi
  65b959:	48 31 d6             	xor    %rdx,%rsi
  65b95c:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  65b961:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  65b966:	48 89 31             	mov    %rsi,(%rcx)
  65b969:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  65b96e:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  65b973:	b1 01                	mov    $0x1,%cl
  65b975:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  65b97a:	48 85 c0             	test   %rax,%rax
  65b97d:	0f 85 d3 fb ff ff    	jne    65b556 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xb6>
  65b983:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
  65b989:	f3 0f 11 7c 24 10    	movss  %xmm7,0x10(%rsp)
  65b98f:	eb 0d                	jmp    65b99e <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4fe>
  65b991:	0f 28 cd             	movaps %xmm5,%xmm1
  65b994:	0f 28 c6             	movaps %xmm6,%xmm0
  65b997:	f6 44 24 28 01       	testb  $0x1,0x28(%rsp)
  65b99c:	74 50                	je     65b9ee <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x54e>
  65b99e:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  65b9a3:	48 c1 c1 07          	rol    $0x7,%rcx
  65b9a7:	66 0f 7e c0          	movd   %xmm0,%eax
  65b9ab:	48 31 c8             	xor    %rcx,%rax
  65b9ae:	48 c1 c0 07          	rol    $0x7,%rax
  65b9b2:	66 0f 6e 44 24 10    	movd   0x10(%rsp),%xmm0
  65b9b8:	66 0f 7e c1          	movd   %xmm0,%ecx
  65b9bc:	48 31 c1             	xor    %rax,%rcx
  65b9bf:	48 c1 c1 07          	rol    $0x7,%rcx
  65b9c3:	66 0f 7e c8          	movd   %xmm1,%eax
  65b9c7:	48 31 c8             	xor    %rcx,%rax
  65b9ca:	48 c1 c0 07          	rol    $0x7,%rax
  65b9ce:	66 0f 6e 44 24 0c    	movd   0xc(%rsp),%xmm0
  65b9d4:	66 0f 7e c1          	movd   %xmm0,%ecx
  65b9d8:	48 31 c1             	xor    %rax,%rcx
  65b9db:	48 c1 c1 07          	rol    $0x7,%rcx
  65b9df:	8b 44 24 18          	mov    0x18(%rsp),%eax
  65b9e3:	48 31 c8             	xor    %rcx,%rax
  65b9e6:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  65b9eb:	48 89 01             	mov    %rax,(%rcx)
  65b9ee:	89 e8                	mov    %ebp,%eax
  65b9f0:	48 81 c4 a8 00 00 00 	add    $0xa8,%rsp
  65b9f7:	5b                   	pop    %rbx
  65b9f8:	41 5c                	pop    %r12
  65b9fa:	41 5d                	pop    %r13
  65b9fc:	41 5e                	pop    %r14
  65b9fe:	41 5f                	pop    %r15
  65ba00:	5d                   	pop    %rbp
  65ba01:	c3                   	ret
  65ba02:	48 8d 3d a3 66 9c ff 	lea    -0x63995d(%rip),%rdi        # 220ac <anon.121202b9d17673f1d19189a9331508d6.3.llvm.15539743372968447683+0xcfc>
  65ba09:	48 8d 15 50 b4 10 00 	lea    0x10b450(%rip),%rdx        # 766e60 <anon.a48ffa9714aefd715eb9a00ca32a7bbf.2.llvm.6589923435489112917+0x30>
  65ba10:	be 13 00 00 00       	mov    $0x13,%esi
  65ba15:	ff 15 dd 57 11 00    	call   *0x1157dd(%rip)        # 7711f8 <_DYNAMIC+0x340>
  65ba1b:	48 8d 3d f6 b3 10 00 	lea    0x10b3f6(%rip),%rdi        # 766e18 <anon.69ab5625bfb42ad4c39c151a08f96109.50.llvm.1353928436795425194+0x50>
  65ba22:	ff 15 30 57 11 00    	call   *0x115730(%rip)        # 771158 <_DYNAMIC+0x2a0>
  65ba28:	cc                   	int3
  65ba29:	cc                   	int3
  65ba2a:	cc                   	int3
  65ba2b:	cc                   	int3
  65ba2c:	cc                   	int3
  65ba2d:	cc                   	int3
  65ba2e:	cc                   	int3
  65ba2f:	cc                   	int3

000000000065faf0 <<gpui_canvas::text::layout::Details>::stops>:
  65faf0:	53                   	push   %rbx
  65faf1:	89 d0                	mov    %edx,%eax
  65faf3:	31 d2                	xor    %edx,%edx
  65faf5:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  65fafa:	4c 8b 47 40          	mov    0x40(%rdi),%r8
  65fafe:	49 0f 45 d0          	cmovne %r8,%rdx
  65fb02:	b9 04 00 00 00       	mov    $0x4,%ecx
  65fb07:	48 0f 45 4f 38       	cmovne 0x38(%rdi),%rcx
  65fb0c:	85 f6                	test   %esi,%esi
  65fb0e:	74 4e                	je     65fb5e <<gpui_canvas::text::layout::Details>::stops+0x6e>
  65fb10:	48 85 d2             	test   %rdx,%rdx
  65fb13:	0f 84 a8 00 00 00    	je     65fbc1 <<gpui_canvas::text::layout::Details>::stops+0xd1>
  65fb19:	31 ff                	xor    %edi,%edi
  65fb1b:	48 83 fa 01          	cmp    $0x1,%rdx
  65fb1f:	74 2e                	je     65fb4f <<gpui_canvas::text::layout::Details>::stops+0x5f>
  65fb21:	4d 89 c1             	mov    %r8,%r9
  65fb24:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  65fb2b:	00 00 00 00 00
  65fb30:	4d 89 ca             	mov    %r9,%r10
  65fb33:	49 d1 ea             	shr    $1,%r10
  65fb36:	4d 8d 1c 3a          	lea    (%r10,%rdi,1),%r11
  65fb3a:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  65fb3e:	39 74 d9 10          	cmp    %esi,0x10(%rcx,%rbx,8)
  65fb42:	49 0f 42 fb          	cmovb  %r11,%rdi
  65fb46:	4d 29 d1             	sub    %r10,%r9
  65fb49:	49 83 f9 01          	cmp    $0x1,%r9
  65fb4d:	77 e1                	ja     65fb30 <<gpui_canvas::text::layout::Details>::stops+0x40>
  65fb4f:	4c 8d 0c 7f          	lea    (%rdi,%rdi,2),%r9
  65fb53:	42 39 74 c9 10       	cmp    %esi,0x10(%rcx,%r9,8)
  65fb58:	48 83 d7 00          	adc    $0x0,%rdi
  65fb5c:	eb 0c                	jmp    65fb6a <<gpui_canvas::text::layout::Details>::stops+0x7a>
  65fb5e:	31 ff                	xor    %edi,%edi
  65fb60:	be 00 00 00 00       	mov    $0x0,%esi
  65fb65:	48 85 d2             	test   %rdx,%rdx
  65fb68:	74 5d                	je     65fbc7 <<gpui_canvas::text::layout::Details>::stops+0xd7>
  65fb6a:	31 f6                	xor    %esi,%esi
  65fb6c:	48 83 fa 01          	cmp    $0x1,%rdx
  65fb70:	74 30                	je     65fba2 <<gpui_canvas::text::layout::Details>::stops+0xb2>
  65fb72:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  65fb79:	1f 84 00 00 00 00 00
  65fb80:	49 89 f1             	mov    %rsi,%r9
  65fb83:	4d 89 c2             	mov    %r8,%r10
  65fb86:	49 d1 ea             	shr    $1,%r10
  65fb89:	4c 01 d6             	add    %r10,%rsi
  65fb8c:	4c 8d 1c 76          	lea    (%rsi,%rsi,2),%r11
  65fb90:	42 39 44 d9 10       	cmp    %eax,0x10(%rcx,%r11,8)
  65fb95:	49 0f 47 f1          	cmova  %r9,%rsi
  65fb99:	4d 29 d0             	sub    %r10,%r8
  65fb9c:	49 83 f8 01          	cmp    $0x1,%r8
  65fba0:	77 de                	ja     65fb80 <<gpui_canvas::text::layout::Details>::stops+0x90>
  65fba2:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  65fba6:	42 3b 44 c1 10       	cmp    0x10(%rcx,%r8,8),%eax
  65fbab:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
  65fbaf:	48 39 fe             	cmp    %rdi,%rsi
  65fbb2:	73 13                	jae    65fbc7 <<gpui_canvas::text::layout::Details>::stops+0xd7>
  65fbb4:	48 8d 0d ad 74 10 00 	lea    0x1074ad(%rip),%rcx        # 767068 <anon.b00a0cf17e3fb3b511483359a0f70536.25.llvm.14182224944371825864+0xc0>
  65fbbb:	ff 15 0f 17 11 00    	call   *0x11170f(%rip)        # 7712d0 <_DYNAMIC+0x418>
  65fbc1:	48 89 d6             	mov    %rdx,%rsi
  65fbc4:	48 89 d7             	mov    %rdx,%rdi
  65fbc7:	48 29 fe             	sub    %rdi,%rsi
  65fbca:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  65fbce:	48 8d 04 c1          	lea    (%rcx,%rax,8),%rax
  65fbd2:	48 89 f2             	mov    %rsi,%rdx
  65fbd5:	5b                   	pop    %rbx
  65fbd6:	c3                   	ret
  65fbd7:	cc                   	int3
  65fbd8:	cc                   	int3
  65fbd9:	cc                   	int3
  65fbda:	cc                   	int3
  65fbdb:	cc                   	int3
  65fbdc:	cc                   	int3
  65fbdd:	cc                   	int3
  65fbde:	cc                   	int3
  65fbdf:	cc                   	int3

000000000066fe70 <<gpui_canvas::text::TextLayout>::move_visual>:
  66fe70:	55                   	push   %rbp
  66fe71:	41 57                	push   %r15
  66fe73:	41 56                	push   %r14
  66fe75:	41 55                	push   %r13
  66fe77:	41 54                	push   %r12
  66fe79:	53                   	push   %rbx
  66fe7a:	48 81 ec a8 00 00 00 	sub    $0xa8,%rsp
  66fe81:	4c 8b 7f 20          	mov    0x20(%rdi),%r15
  66fe85:	40 b5 02             	mov    $0x2,%bpl
  66fe88:	4d 85 ff             	test   %r15,%r15
  66fe8b:	0f 84 7e 01 00 00    	je     67000f <<gpui_canvas::text::TextLayout>::move_visual+0x19f>
  66fe91:	49 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%r15)
  66fe96:	0f 84 73 01 00 00    	je     67000f <<gpui_canvas::text::TextLayout>::move_visual+0x19f>
  66fe9c:	4d 8b 57 38          	mov    0x38(%r15),%r10
  66fea0:	4d 8b 4f 40          	mov    0x40(%r15),%r9
  66fea4:	4c 89 c8             	mov    %r9,%rax
  66fea7:	4d 85 c9             	test   %r9,%r9
  66feaa:	74 41                	je     66feed <<gpui_canvas::text::TextLayout>::move_visual+0x7d>
  66feac:	31 c0                	xor    %eax,%eax
  66feae:	49 83 f9 01          	cmp    $0x1,%r9
  66feb2:	74 2c                	je     66fee0 <<gpui_canvas::text::TextLayout>::move_visual+0x70>
  66feb4:	4c 89 cb             	mov    %r9,%rbx
  66feb7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  66febe:	00 00
  66fec0:	49 89 de             	mov    %rbx,%r14
  66fec3:	49 d1 ee             	shr    $1,%r14
  66fec6:	4d 8d 04 06          	lea    (%r14,%rax,1),%r8
  66feca:	4f 8d 1c 40          	lea    (%r8,%r8,2),%r11
  66fece:	43 39 74 da 10       	cmp    %esi,0x10(%r10,%r11,8)
  66fed3:	49 0f 42 c0          	cmovb  %r8,%rax
  66fed7:	4c 29 f3             	sub    %r14,%rbx
  66feda:	48 83 fb 01          	cmp    $0x1,%rbx
  66fede:	77 e0                	ja     66fec0 <<gpui_canvas::text::TextLayout>::move_visual+0x50>
  66fee0:	4c 8d 04 40          	lea    (%rax,%rax,2),%r8
  66fee4:	43 39 74 c2 10       	cmp    %esi,0x10(%r10,%r8,8)
  66fee9:	48 83 d0 00          	adc    $0x0,%rax
  66feed:	44 8d 42 01          	lea    0x1(%rdx),%r8d
  66fef1:	48 c1 e0 03          	shl    $0x3,%rax
  66fef5:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  66fef9:	4e 8d 1c cd 00 00 00 	lea    0x0(,%r9,8),%r11
  66ff00:	00
  66ff01:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  66ff05:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  66ff0c:	00 00 00 00
  66ff10:	48 39 c3             	cmp    %rax,%rbx
  66ff13:	0f 84 f6 00 00 00    	je     67000f <<gpui_canvas::text::TextLayout>::move_visual+0x19f>
  66ff19:	41 39 74 02 10       	cmp    %esi,0x10(%r10,%rax,1)
  66ff1e:	0f 85 eb 00 00 00    	jne    67000f <<gpui_canvas::text::TextLayout>::move_visual+0x19f>
  66ff24:	4c 8d 58 18          	lea    0x18(%rax),%r11
  66ff28:	45 84 44 02 14       	test   %r8b,0x14(%r10,%rax,1)
  66ff2d:	4c 89 d8             	mov    %r11,%rax
  66ff30:	74 de                	je     66ff10 <<gpui_canvas::text::TextLayout>::move_visual+0xa0>
  66ff32:	4d 8b 6f 20          	mov    0x20(%r15),%r13
  66ff36:	49 8b 47 28          	mov    0x28(%r15),%rax
  66ff3a:	49 89 c0             	mov    %rax,%r8
  66ff3d:	48 85 c0             	test   %rax,%rax
  66ff40:	4c 89 7c 24 10       	mov    %r15,0x10(%rsp)
  66ff45:	74 60                	je     66ffa7 <<gpui_canvas::text::TextLayout>::move_visual+0x137>
  66ff47:	48 89 d5             	mov    %rdx,%rbp
  66ff4a:	f3 43 0f 10 44 1a ec 	movss  -0x14(%r10,%r11,1),%xmm0
  66ff51:	31 db                	xor    %ebx,%ebx
  66ff53:	48 83 f8 01          	cmp    $0x1,%rax
  66ff57:	74 2a                	je     66ff83 <<gpui_canvas::text::TextLayout>::move_visual+0x113>
  66ff59:	49 89 c0             	mov    %rax,%r8
  66ff5c:	0f 1f 40 00          	nopl   0x0(%rax)
  66ff60:	48 89 da             	mov    %rbx,%rdx
  66ff63:	4d 89 c6             	mov    %r8,%r14
  66ff66:	49 d1 ee             	shr    $1,%r14
  66ff69:	4c 01 f3             	add    %r14,%rbx
  66ff6c:	4c 8d 24 5b          	lea    (%rbx,%rbx,2),%r12
  66ff70:	43 0f 2e 44 e5 08    	ucomiss 0x8(%r13,%r12,8),%xmm0
  66ff76:	48 0f 42 da          	cmovb  %rdx,%rbx
  66ff7a:	4d 29 f0             	sub    %r14,%r8
  66ff7d:	49 83 f8 01          	cmp    $0x1,%r8
  66ff81:	77 dd                	ja     66ff60 <<gpui_canvas::text::TextLayout>::move_visual+0xf0>
  66ff83:	48 8d 14 5b          	lea    (%rbx,%rbx,2),%rdx
  66ff87:	45 31 c0             	xor    %r8d,%r8d
  66ff8a:	41 0f 2e 44 d5 08    	ucomiss 0x8(%r13,%rdx,8),%xmm0
  66ff90:	41 0f 93 c0          	setae  %r8b
  66ff94:	49 01 d8             	add    %rbx,%r8
  66ff97:	49 83 f8 01          	cmp    $0x1,%r8
  66ff9b:	49 83 d0 ff          	adc    $0xffffffffffffffff,%r8
  66ff9f:	48 89 ea             	mov    %rbp,%rdx
  66ffa2:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  66ffa7:	f3 43 0f 10 6c 1a e8 	movss  -0x18(%r10,%r11,1),%xmm5
  66ffae:	4c 89 44 24 38       	mov    %r8,0x38(%rsp)
  66ffb3:	49 39 c0             	cmp    %rax,%r8
  66ffb6:	0f 83 97 05 00 00    	jae    670553 <<gpui_canvas::text::TextLayout>::move_visual+0x6e3>
  66ffbc:	4b 8d 04 40          	lea    (%r8,%r8,2),%rax
  66ffc0:	41 8b 6c c5 00       	mov    0x0(%r13,%rax,8),%ebp
  66ffc5:	85 ed                	test   %ebp,%ebp
  66ffc7:	74 5a                	je     670023 <<gpui_canvas::text::TextLayout>::move_visual+0x1b3>
  66ffc9:	4c 89 c8             	mov    %r9,%rax
  66ffcc:	4d 85 c9             	test   %r9,%r9
  66ffcf:	74 54                	je     670025 <<gpui_canvas::text::TextLayout>::move_visual+0x1b5>
  66ffd1:	31 c0                	xor    %eax,%eax
  66ffd3:	49 83 f9 01          	cmp    $0x1,%r9
  66ffd7:	74 27                	je     670000 <<gpui_canvas::text::TextLayout>::move_visual+0x190>
  66ffd9:	4d 89 c8             	mov    %r9,%r8
  66ffdc:	0f 1f 40 00          	nopl   0x0(%rax)
  66ffe0:	4d 89 c6             	mov    %r8,%r14
  66ffe3:	49 d1 ee             	shr    $1,%r14
  66ffe6:	4d 8d 1c 06          	lea    (%r14,%rax,1),%r11
  66ffea:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  66ffee:	41 39 6c da 10       	cmp    %ebp,0x10(%r10,%rbx,8)
  66fff3:	49 0f 42 c3          	cmovb  %r11,%rax
  66fff7:	4d 29 f0             	sub    %r14,%r8
  66fffa:	49 83 f8 01          	cmp    $0x1,%r8
  66fffe:	77 e0                	ja     66ffe0 <<gpui_canvas::text::TextLayout>::move_visual+0x170>
  670000:	4c 8d 04 40          	lea    (%rax,%rax,2),%r8
  670004:	43 39 6c c2 10       	cmp    %ebp,0x10(%r10,%r8,8)
  670009:	48 83 d0 00          	adc    $0x0,%rax
  67000d:	eb 16                	jmp    670025 <<gpui_canvas::text::TextLayout>::move_visual+0x1b5>
  67000f:	89 ea                	mov    %ebp,%edx
  670011:	48 81 c4 a8 00 00 00 	add    $0xa8,%rsp
  670018:	5b                   	pop    %rbx
  670019:	41 5c                	pop    %r12
  67001b:	41 5d                	pop    %r13
  67001d:	41 5e                	pop    %r14
  67001f:	41 5f                	pop    %r15
  670021:	5d                   	pop    %rbp
  670022:	c3                   	ret
  670023:	31 c0                	xor    %eax,%eax
  670025:	49 29 c1             	sub    %rax,%r9
  670028:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  67002c:	f3 0f 10 47 34       	movss  0x34(%rdi),%xmm0
  670031:	f3 0f 59 05 07 a1 9a 	mulss  -0x655ef9(%rip),%xmm0        # 1a140 <GCC_except_table0+0x80>
  670038:	ff
  670039:	4d 8d 14 c2          	lea    (%r10,%rax,8),%r10
  67003d:	0f 57 c9             	xorps  %xmm1,%xmm1
  670040:	0f 11 4c 24 70       	movups %xmm1,0x70(%rsp)
  670045:	49 8d 47 18          	lea    0x18(%r15),%rax
  670049:	4c 8d 44 24 38       	lea    0x38(%rsp),%r8
  67004e:	4c 89 44 24 40       	mov    %r8,0x40(%rsp)
  670053:	4c 89 54 24 48       	mov    %r10,0x48(%rsp)
  670058:	4c 89 4c 24 50       	mov    %r9,0x50(%rsp)
  67005d:	4c 89 54 24 58       	mov    %r10,0x58(%rsp)
  670062:	4c 89 4c 24 60       	mov    %r9,0x60(%rsp)
  670067:	48 c7 44 24 68 01 00 	movq   $0x1,0x68(%rsp)
  67006e:	00 00
  670070:	4c 89 bc 24 80 00 00 	mov    %r15,0x80(%rsp)
  670077:	00
  670078:	f3 0f 11 84 24 88 00 	movss  %xmm0,0x88(%rsp)
  67007f:	00 00
  670081:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  670088:	00
  670089:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  670090:	00
  670091:	c6 84 24 a0 00 00 00 	movb   $0x0,0xa0(%rsp)
  670098:	00
  670099:	f3 0f 10 35 cb a0 9a 	movss  -0x655f35(%rip),%xmm6        # 1a16c <GCC_except_table0+0xac>
  6700a0:	ff
  6700a1:	40 b5 02             	mov    $0x2,%bpl
  6700a4:	4c 89 fb             	mov    %r15,%rbx
  6700a7:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  6700ac:	89 4c 24 0c          	mov    %ecx,0xc(%rsp)
  6700b0:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  6700b5:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6700ba:	48 85 c0             	test   %rax,%rax
  6700bd:	0f 84 de 03 00 00    	je     6704a1 <<gpui_canvas::text::TextLayout>::move_visual+0x631>
  6700c3:	89 6c 24 04          	mov    %ebp,0x4(%rsp)
  6700c7:	eb 15                	jmp    6700de <<gpui_canvas::text::TextLayout>::move_visual+0x26e>
  6700c9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6700d0:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6700d5:	48 85 c0             	test   %rax,%rax
  6700d8:	0f 84 ac 03 00 00    	je     67048a <<gpui_canvas::text::TextLayout>::move_visual+0x61a>
  6700de:	4c 8b 64 24 48       	mov    0x48(%rsp),%r12
  6700e3:	41 be 01 00 00 00    	mov    $0x1,%r14d
  6700e9:	48 83 f8 01          	cmp    $0x1,%rax
  6700ed:	74 2a                	je     670119 <<gpui_canvas::text::TextLayout>::move_visual+0x2a9>
  6700ef:	4d 8d 44 24 28       	lea    0x28(%r12),%r8
  6700f4:	4c 8d 58 01          	lea    0x1(%rax),%r11
  6700f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  6700ff:	00
  670100:	41 8b 48 e8          	mov    -0x18(%r8),%ecx
  670104:	41 3b 08             	cmp    (%r8),%ecx
  670107:	75 10                	jne    670119 <<gpui_canvas::text::TextLayout>::move_visual+0x2a9>
  670109:	49 ff c6             	inc    %r14
  67010c:	49 83 c0 18          	add    $0x18,%r8
  670110:	49 ff cb             	dec    %r11
  670113:	49 83 fb 02          	cmp    $0x2,%r11
  670117:	77 e7                	ja     670100 <<gpui_canvas::text::TextLayout>::move_visual+0x290>
  670119:	4c 29 f0             	sub    %r14,%rax
  67011c:	0f 82 f5 03 00 00    	jb     670517 <<gpui_canvas::text::TextLayout>::move_visual+0x6a7>
  670122:	4b 8d 0c 76          	lea    (%r14,%r14,2),%rcx
  670126:	49 8d 0c cc          	lea    (%r12,%rcx,8),%rcx
  67012a:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
  67012f:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  670134:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  670139:	48 85 c0             	test   %rax,%rax
  67013c:	0f 85 de 01 00 00    	jne    670320 <<gpui_canvas::text::TextLayout>::move_visual+0x4b0>
  670142:	4c 89 c8             	mov    %r9,%rax
  670145:	49 83 f9 01          	cmp    $0x1,%r9
  670149:	74 3e                	je     670189 <<gpui_canvas::text::TextLayout>::move_visual+0x319>
  67014b:	4d 85 c9             	test   %r9,%r9
  67014e:	0f 84 36 03 00 00    	je     67048a <<gpui_canvas::text::TextLayout>::move_visual+0x61a>
  670154:	4d 8d 42 28          	lea    0x28(%r10),%r8
  670158:	4d 8d 59 01          	lea    0x1(%r9),%r11
  67015c:	b8 01 00 00 00       	mov    $0x1,%eax
  670161:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  670168:	0f 1f 84 00 00 00 00
  67016f:	00
  670170:	41 8b 48 e8          	mov    -0x18(%r8),%ecx
  670174:	41 3b 08             	cmp    (%r8),%ecx
  670177:	75 10                	jne    670189 <<gpui_canvas::text::TextLayout>::move_visual+0x319>
  670179:	48 ff c0             	inc    %rax
  67017c:	49 83 c0 18          	add    $0x18,%r8
  670180:	49 ff cb             	dec    %r11
  670183:	49 83 fb 02          	cmp    $0x2,%r11
  670187:	77 e7                	ja     670170 <<gpui_canvas::text::TextLayout>::move_visual+0x300>
  670189:	49 29 c1             	sub    %rax,%r9
  67018c:	0f 82 85 03 00 00    	jb     670517 <<gpui_canvas::text::TextLayout>::move_visual+0x6a7>
  670192:	48 8d 0c 40          	lea    (%rax,%rax,2),%rcx
  670196:	49 8d 0c ca          	lea    (%r10,%rcx,8),%rcx
  67019a:	4d 89 d5             	mov    %r10,%r13
  67019d:	49 89 ca             	mov    %rcx,%r10
  6701a0:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
  6701a5:	4c 89 4c 24 60       	mov    %r9,0x60(%rsp)
  6701aa:	49 c1 e6 03          	shl    $0x3,%r14
  6701ae:	4b 8d 0c 76          	lea    (%r14,%r14,2),%rcx
  6701b2:	45 31 c0             	xor    %r8d,%r8d
  6701b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6701bc:	00 00 00 00
  6701c0:	4c 39 c1             	cmp    %r8,%rcx
  6701c3:	0f 84 07 ff ff ff    	je     6700d0 <<gpui_canvas::text::TextLayout>::move_visual+0x260>
  6701c9:	49 8d 68 18          	lea    0x18(%r8),%rbp
  6701cd:	43 f6 44 04 14 02    	testb  $0x2,0x14(%r12,%r8,1)
  6701d3:	49 89 e8             	mov    %rbp,%r8
  6701d6:	74 e8                	je     6701c0 <<gpui_canvas::text::TextLayout>::move_visual+0x350>
  6701d8:	48 c1 e0 03          	shl    $0x3,%rax
  6701dc:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  6701e0:	31 c9                	xor    %ecx,%ecx
  6701e2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6701e9:	1f 84 00 00 00 00 00
  6701f0:	48 39 c8             	cmp    %rcx,%rax
  6701f3:	0f 84 d7 fe ff ff    	je     6700d0 <<gpui_canvas::text::TextLayout>::move_visual+0x260>
  6701f9:	4c 8d 71 18          	lea    0x18(%rcx),%r14
  6701fd:	41 f6 44 0d 14 01    	testb  $0x1,0x14(%r13,%rcx,1)
  670203:	4c 89 f1             	mov    %r14,%rcx
  670206:	74 e8                	je     6701f0 <<gpui_canvas::text::TextLayout>::move_visual+0x380>
  670208:	f3 41 0f 10 44 2c ec 	movss  -0x14(%r12,%rbp,1),%xmm0
  67020f:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  670213:	48 85 d2             	test   %rdx,%rdx
  670216:	74 66                	je     67027e <<gpui_canvas::text::TextLayout>::move_visual+0x40e>
  670218:	48 8b 43 20          	mov    0x20(%rbx),%rax
  67021c:	45 31 c0             	xor    %r8d,%r8d
  67021f:	48 83 fa 01          	cmp    $0x1,%rdx
  670223:	74 2d                	je     670252 <<gpui_canvas::text::TextLayout>::move_visual+0x3e2>
  670225:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  67022c:	00 00 00 00
  670230:	4c 89 c1             	mov    %r8,%rcx
  670233:	49 89 d3             	mov    %rdx,%r11
  670236:	49 d1 eb             	shr    $1,%r11
  670239:	4d 01 d8             	add    %r11,%r8
  67023c:	4b 8d 3c 40          	lea    (%r8,%r8,2),%rdi
  670240:	0f 2e 44 f8 08       	ucomiss 0x8(%rax,%rdi,8),%xmm0
  670245:	4c 0f 42 c1          	cmovb  %rcx,%r8
  670249:	4c 29 da             	sub    %r11,%rdx
  67024c:	48 83 fa 01          	cmp    $0x1,%rdx
  670250:	77 de                	ja     670230 <<gpui_canvas::text::TextLayout>::move_visual+0x3c0>
  670252:	49 89 df             	mov    %rbx,%r15
  670255:	4b 8d 0c 40          	lea    (%r8,%r8,2),%rcx
  670259:	31 d2                	xor    %edx,%edx
  67025b:	0f 2e 44 c8 08       	ucomiss 0x8(%rax,%rcx,8),%xmm0
  670260:	0f 93 c2             	setae  %dl
  670263:	4c 01 c2             	add    %r8,%rdx
  670266:	48 83 fa 01          	cmp    $0x1,%rdx
  67026a:	48 83 d2 ff          	adc    $0xffffffffffffffff,%rdx
  67026e:	f3 43 0f 10 4c 35 ec 	movss  -0x14(%r13,%r14,1),%xmm1
  670275:	0f 2e c1             	ucomiss %xmm1,%xmm0
  670278:	75 15                	jne    67028f <<gpui_canvas::text::TextLayout>::move_visual+0x41f>
  67027a:	7a 13                	jp     67028f <<gpui_canvas::text::TextLayout>::move_visual+0x41f>
  67027c:	eb 45                	jmp    6702c3 <<gpui_canvas::text::TextLayout>::move_visual+0x453>
  67027e:	49 89 df             	mov    %rbx,%r15
  670281:	f3 43 0f 10 4c 35 ec 	movss  -0x14(%r13,%r14,1),%xmm1
  670288:	0f 2e c1             	ucomiss %xmm1,%xmm0
  67028b:	75 02                	jne    67028f <<gpui_canvas::text::TextLayout>::move_visual+0x41f>
  67028d:	7b 34                	jnp    6702c3 <<gpui_canvas::text::TextLayout>::move_visual+0x453>
  67028f:	49 8b 47 10          	mov    0x10(%r15),%rax
  670293:	48 83 f8 02          	cmp    $0x2,%rax
  670297:	72 2a                	jb     6702c3 <<gpui_canvas::text::TextLayout>::move_visual+0x453>
  670299:	4d 8b 47 08          	mov    0x8(%r15),%r8
  67029d:	31 c9                	xor    %ecx,%ecx
  67029f:	90                   	nop
  6702a0:	48 89 c7             	mov    %rax,%rdi
  6702a3:	48 d1 ef             	shr    $1,%rdi
  6702a6:	4c 8d 1c 0f          	lea    (%rdi,%rcx,1),%r11
  6702aa:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  6702ae:	41 8b 5c d8 10       	mov    0x10(%r8,%rbx,8),%ebx
  6702b3:	48 39 da             	cmp    %rbx,%rdx
  6702b6:	49 0f 47 cb          	cmova  %r11,%rcx
  6702ba:	48 29 f8             	sub    %rdi,%rax
  6702bd:	48 83 f8 01          	cmp    $0x1,%rax
  6702c1:	77 dd                	ja     6702a0 <<gpui_canvas::text::TextLayout>::move_visual+0x430>
  6702c3:	48 8b 8c 24 90 00 00 	mov    0x90(%rsp),%rcx
  6702ca:	00
  6702cb:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  6702d2:	00
  6702d3:	48 8b 00             	mov    (%rax),%rax
  6702d6:	4c 8b 41 10          	mov    0x10(%rcx),%r8
  6702da:	4c 39 c0             	cmp    %r8,%rax
  6702dd:	0f 83 5d 02 00 00    	jae    670540 <<gpui_canvas::text::TextLayout>::move_visual+0x6d0>
  6702e3:	45 8b 44 2c f8       	mov    -0x8(%r12,%rbp,1),%r8d
  6702e8:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  6702ec:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  6702f0:	44 3b 44 c1 04       	cmp    0x4(%rcx,%rax,8),%r8d
  6702f5:	0f 87 8f 01 00 00    	ja     67048a <<gpui_canvas::text::TextLayout>::move_visual+0x61a>
  6702fb:	0f 2e c1             	ucomiss %xmm1,%xmm0
  6702fe:	4c 89 fb             	mov    %r15,%rbx
  670301:	0f 85 c9 fd ff ff    	jne    6700d0 <<gpui_canvas::text::TextLayout>::move_visual+0x260>
  670307:	0f 8a c3 fd ff ff    	jp     6700d0 <<gpui_canvas::text::TextLayout>::move_visual+0x260>
  67030d:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  670312:	48 3b 10             	cmp    (%rax),%rdx
  670315:	0f 85 b5 fd ff ff    	jne    6700d0 <<gpui_canvas::text::TextLayout>::move_visual+0x260>
  67031b:	e9 a6 00 00 00       	jmp    6703c6 <<gpui_canvas::text::TextLayout>::move_visual+0x556>
  670320:	f3 0f 11 74 24 30    	movss  %xmm6,0x30(%rsp)
  670326:	f3 0f 11 6c 24 34    	movss  %xmm5,0x34(%rsp)
  67032c:	89 74 24 1c          	mov    %esi,0x1c(%rsp)
  670330:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  670335:	48 c7 44 24 68 00 00 	movq   $0x0,0x68(%rsp)
  67033c:	00 00
  67033e:	48 8d 7c 24 58       	lea    0x58(%rsp),%rdi
  670343:	48 89 c6             	mov    %rax,%rsi
  670346:	e8 d5 a7 ff ff       	call   66ab20 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::Details>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>
  67034b:	48 85 c0             	test   %rax,%rax
  67034e:	0f 85 dc 01 00 00    	jne    670530 <<gpui_canvas::text::TextLayout>::move_visual+0x6c0>
  670354:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
  670359:	4d 85 c9             	test   %r9,%r9
  67035c:	0f 84 ce 01 00 00    	je     670530 <<gpui_canvas::text::TextLayout>::move_visual+0x6c0>
  670362:	4c 8b 6c 24 58       	mov    0x58(%rsp),%r13
  670367:	b8 01 00 00 00       	mov    $0x1,%eax
  67036c:	49 83 f9 01          	cmp    $0x1,%r9
  670370:	8b 74 24 1c          	mov    0x1c(%rsp),%esi
  670374:	f3 0f 10 6c 24 34    	movss  0x34(%rsp),%xmm5
  67037a:	f3 0f 10 74 24 30    	movss  0x30(%rsp),%xmm6
  670380:	74 1f                	je     6703a1 <<gpui_canvas::text::TextLayout>::move_visual+0x531>
  670382:	49 8d 4d 28          	lea    0x28(%r13),%rcx
  670386:	4d 8d 41 01          	lea    0x1(%r9),%r8
  67038a:	8b 51 e8             	mov    -0x18(%rcx),%edx
  67038d:	3b 11                	cmp    (%rcx),%edx
  67038f:	75 10                	jne    6703a1 <<gpui_canvas::text::TextLayout>::move_visual+0x531>
  670391:	48 ff c0             	inc    %rax
  670394:	48 83 c1 18          	add    $0x18,%rcx
  670398:	49 ff c8             	dec    %r8
  67039b:	49 83 f8 02          	cmp    $0x2,%r8
  67039f:	77 e9                	ja     67038a <<gpui_canvas::text::TextLayout>::move_visual+0x51a>
  6703a1:	49 29 c1             	sub    %rax,%r9
  6703a4:	0f 82 6d 01 00 00    	jb     670517 <<gpui_canvas::text::TextLayout>::move_visual+0x6a7>
  6703aa:	48 8d 0c 40          	lea    (%rax,%rax,2),%rcx
  6703ae:	48 8d 0c cd 00 00 00 	lea    0x0(,%rcx,8),%rcx
  6703b5:	00
  6703b6:	4c 01 e9             	add    %r13,%rcx
  6703b9:	48 8b 9c 24 80 00 00 	mov    0x80(%rsp),%rbx
  6703c0:	00
  6703c1:	e9 d7 fd ff ff       	jmp    67019d <<gpui_canvas::text::TextLayout>::move_visual+0x32d>
  6703c6:	f3 43 0f 10 4c 35 e8 	movss  -0x18(%r13,%r14,1),%xmm1
  6703cd:	f3 41 0f 10 54 2c e8 	movss  -0x18(%r12,%rbp,1),%xmm2
  6703d4:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
  6703d8:	84 c9                	test   %cl,%cl
  6703da:	74 21                	je     6703fd <<gpui_canvas::text::TextLayout>::move_visual+0x58d>
  6703dc:	0f 28 da             	movaps %xmm2,%xmm3
  6703df:	f3 0f 5f d9          	maxss  %xmm1,%xmm3
  6703e3:	0f 28 c3             	movaps %xmm3,%xmm0
  6703e6:	f3 0f c2 c3 03       	cmpunordss %xmm3,%xmm0
  6703eb:	0f 28 e0             	movaps %xmm0,%xmm4
  6703ee:	0f 55 e3             	andnps %xmm3,%xmm4
  6703f1:	0f 54 c2             	andps  %xmm2,%xmm0
  6703f4:	0f 56 c4             	orps   %xmm4,%xmm0
  6703f7:	f3 0f 5c c5          	subss  %xmm5,%xmm0
  6703fb:	eb 22                	jmp    67041f <<gpui_canvas::text::TextLayout>::move_visual+0x5af>
  6703fd:	0f 28 c2             	movaps %xmm2,%xmm0
  670400:	f3 0f 5d c1          	minss  %xmm1,%xmm0
  670404:	0f 28 d8             	movaps %xmm0,%xmm3
  670407:	f3 0f c2 d8 03       	cmpunordss %xmm0,%xmm3
  67040c:	0f 28 e3             	movaps %xmm3,%xmm4
  67040f:	0f 55 e0             	andnps %xmm0,%xmm4
  670412:	0f 54 da             	andps  %xmm2,%xmm3
  670415:	0f 56 dc             	orps   %xmm4,%xmm3
  670418:	0f 28 c5             	movaps %xmm5,%xmm0
  67041b:	f3 0f 5c c3          	subss  %xmm3,%xmm0
  67041f:	8b 6c 24 04          	mov    0x4(%rsp),%ebp
  670423:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  670428:	0f 28 d8             	movaps %xmm0,%xmm3
  67042b:	f3 0f c2 de 01       	cmpltss %xmm6,%xmm3
  670430:	0f 57 e4             	xorps  %xmm4,%xmm4
  670433:	f3 0f c2 e0 01       	cmpltss %xmm0,%xmm4
  670438:	0f 2e ca             	ucomiss %xmm2,%xmm1
  67043b:	0f 96 c0             	setbe  %al
  67043e:	30 c8                	xor    %cl,%al
  670440:	47 0f 45 44 35 f8    	cmovne -0x8(%r13,%r14,1),%r8d
  670446:	0f 54 e3             	andps  %xmm3,%xmm4
  670449:	66 0f 7e e2          	movd   %xmm4,%edx
  67044d:	34 01                	xor    $0x1,%al
  67044f:	f6 c2 01             	test   $0x1,%dl
  670452:	75 03                	jne    670457 <<gpui_canvas::text::TextLayout>::move_visual+0x5e7>
  670454:	0f 28 c6             	movaps %xmm6,%xmm0
  670457:	0f b6 c0             	movzbl %al,%eax
  67045a:	40 0f b6 ed          	movzbl %bpl,%ebp
  67045e:	0f 45 e8             	cmovne %eax,%ebp
  670461:	8b 44 24 08          	mov    0x8(%rsp),%eax
  670465:	41 0f 45 c0          	cmovne %r8d,%eax
  670469:	89 44 24 08          	mov    %eax,0x8(%rsp)
  67046d:	80 bc 24 a0 00 00 00 	cmpb   $0x0,0xa0(%rsp)
  670474:	00
  670475:	0f 28 f0             	movaps %xmm0,%xmm6
  670478:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  67047d:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  670482:	0f 84 2d fc ff ff    	je     6700b5 <<gpui_canvas::text::TextLayout>::move_visual+0x245>
  670488:	eb 17                	jmp    6704a1 <<gpui_canvas::text::TextLayout>::move_visual+0x631>
  67048a:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  67048f:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
  670493:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  670498:	8b 6c 24 04          	mov    0x4(%rsp),%ebp
  67049c:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  6704a1:	40 80 fd 02          	cmp    $0x2,%bpl
  6704a5:	75 67                	jne    67050e <<gpui_canvas::text::TextLayout>::move_visual+0x69e>
  6704a7:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  6704ac:	84 c9                	test   %cl,%cl
  6704ae:	74 30                	je     6704e0 <<gpui_canvas::text::TextLayout>::move_visual+0x670>
  6704b0:	b8 01 00 00 00       	mov    $0x1,%eax
  6704b5:	49 83 f8 ff          	cmp    $0xffffffffffffffff,%r8
  6704b9:	74 31                	je     6704ec <<gpui_canvas::text::TextLayout>::move_visual+0x67c>
  6704bb:	4c 01 c0             	add    %r8,%rax
  6704be:	89 d5                	mov    %edx,%ebp
  6704c0:	89 74 24 08          	mov    %esi,0x8(%rsp)
  6704c4:	49 3b 47 28          	cmp    0x28(%r15),%rax
  6704c8:	73 44                	jae    67050e <<gpui_canvas::text::TextLayout>::move_visual+0x69e>
  6704ca:	49 8b 57 20          	mov    0x20(%r15),%rdx
  6704ce:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  6704d2:	84 c9                	test   %cl,%cl
  6704d4:	75 1e                	jne    6704f4 <<gpui_canvas::text::TextLayout>::move_visual+0x684>
  6704d6:	f3 0f 10 05 86 9c 9a 	movss  -0x65637a(%rip),%xmm0        # 1a164 <GCC_except_table0+0xa4>
  6704dd:	ff
  6704de:	eb 1c                	jmp    6704fc <<gpui_canvas::text::TextLayout>::move_visual+0x68c>
  6704e0:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  6704e7:	4d 85 c0             	test   %r8,%r8
  6704ea:	75 cf                	jne    6704bb <<gpui_canvas::text::TextLayout>::move_visual+0x64b>
  6704ec:	89 d5                	mov    %edx,%ebp
  6704ee:	89 74 24 08          	mov    %esi,0x8(%rsp)
  6704f2:	eb 1a                	jmp    67050e <<gpui_canvas::text::TextLayout>::move_visual+0x69e>
  6704f4:	f3 0f 10 05 7c 9c 9a 	movss  -0x656384(%rip),%xmm0        # 1a178 <GCC_except_table0+0xb8>
  6704fb:	ff
  6704fc:	f3 0f 10 4c c2 08    	movss  0x8(%rdx,%rax,8),%xmm1
  670502:	ff 15 48 0c 10 00    	call   *0x100c48(%rip)        # 771150 <_DYNAMIC+0x298>
  670508:	89 44 24 08          	mov    %eax,0x8(%rsp)
  67050c:	89 d5                	mov    %edx,%ebp
  67050e:	8b 44 24 08          	mov    0x8(%rsp),%eax
  670512:	e9 f8 fa ff ff       	jmp    67000f <<gpui_canvas::text::TextLayout>::move_visual+0x19f>
  670517:	48 8d 3d f3 b4 be ff 	lea    -0x414b0d(%rip),%rdi        # 25ba11 <gpui_canvas::text::PRIMARY_BYTES+0x1f4448>
  67051e:	48 8d 15 43 74 0f 00 	lea    0xf7443(%rip),%rdx        # 767968 <anon.6c90822af352b8e064c50ed4f1c3be18.6.llvm.10547532359908779909+0x60>
  670525:	be 13 00 00 00       	mov    $0x13,%esi
  67052a:	ff 15 c8 0c 10 00    	call   *0x100cc8(%rip)        # 7711f8 <_DYNAMIC+0x340>
  670530:	48 89 df             	mov    %rbx,%rdi
  670533:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
  670537:	8b 74 24 1c          	mov    0x1c(%rsp),%esi
  67053b:	e9 53 ff ff ff       	jmp    670493 <<gpui_canvas::text::TextLayout>::move_visual+0x623>
  670540:	48 8d 15 f1 73 0f 00 	lea    0xf73f1(%rip),%rdx        # 767938 <anon.6c90822af352b8e064c50ed4f1c3be18.6.llvm.10547532359908779909+0x30>
  670547:	48 89 c7             	mov    %rax,%rdi
  67054a:	4c 89 c6             	mov    %r8,%rsi
  67054d:	ff 15 1d 0d 10 00    	call   *0x100d1d(%rip)        # 771270 <_DYNAMIC+0x3b8>
  670553:	48 8d 15 26 6b 0f 00 	lea    0xf6b26(%rip),%rdx        # 767080 <anon.b00a0cf17e3fb3b511483359a0f70536.36.llvm.14182224944371825864>
  67055a:	4c 89 c7             	mov    %r8,%rdi
  67055d:	48 89 c6             	mov    %rax,%rsi
  670560:	ff 15 0a 0d 10 00    	call   *0x100d0a(%rip)        # 771270 <_DYNAMIC+0x3b8>
  670566:	cc                   	int3
  670567:	cc                   	int3
  670568:	cc                   	int3
  670569:	cc                   	int3
  67056a:	cc                   	int3
  67056b:	cc                   	int3
  67056c:	cc                   	int3
  67056d:	cc                   	int3
  67056e:	cc                   	int3
  67056f:	cc                   	int3

0000000000670570 <<gpui_canvas::text::TextLayout>::position_at>:
  670570:	55                   	push   %rbp
  670571:	41 57                	push   %r15
  670573:	41 56                	push   %r14
  670575:	41 55                	push   %r13
  670577:	41 54                	push   %r12
  670579:	53                   	push   %rbx
  67057a:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  670581:	66 0f 7e c8          	movd   %xmm1,%eax
  670585:	66 0f 7e c1          	movd   %xmm0,%ecx
  670589:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  67058f:	81 f9 00 00 80 7f    	cmp    $0x7f800000,%ecx
  670595:	0f 9d c1             	setge  %cl
  670598:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  67059d:	3d 00 00 80 7f       	cmp    $0x7f800000,%eax
  6705a2:	0f 9d c0             	setge  %al
  6705a5:	08 c8                	or     %cl,%al
  6705a7:	b2 02                	mov    $0x2,%dl
  6705a9:	0f 85 c9 05 00 00    	jne    670b78 <<gpui_canvas::text::TextLayout>::position_at+0x608>
  6705af:	4c 8b 7f 20          	mov    0x20(%rdi),%r15
  6705b3:	4d 85 ff             	test   %r15,%r15
  6705b6:	0f 84 bc 05 00 00    	je     670b78 <<gpui_canvas::text::TextLayout>::position_at+0x608>
  6705bc:	49 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%r15)
  6705c1:	0f 84 b1 05 00 00    	je     670b78 <<gpui_canvas::text::TextLayout>::position_at+0x608>
  6705c7:	49 8b 4f 20          	mov    0x20(%r15),%rcx
  6705cb:	49 8b 77 28          	mov    0x28(%r15),%rsi
  6705cf:	48 89 f0             	mov    %rsi,%rax
  6705d2:	48 85 f6             	test   %rsi,%rsi
  6705d5:	74 56                	je     67062d <<gpui_canvas::text::TextLayout>::position_at+0xbd>
  6705d7:	31 d2                	xor    %edx,%edx
  6705d9:	48 83 fe 01          	cmp    $0x1,%rsi
  6705dd:	74 34                	je     670613 <<gpui_canvas::text::TextLayout>::position_at+0xa3>
  6705df:	48 89 f0             	mov    %rsi,%rax
  6705e2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6705e9:	1f 84 00 00 00 00 00
  6705f0:	49 89 d0             	mov    %rdx,%r8
  6705f3:	49 89 c1             	mov    %rax,%r9
  6705f6:	49 d1 e9             	shr    $1,%r9
  6705f9:	4c 01 ca             	add    %r9,%rdx
  6705fc:	4c 8d 14 52          	lea    (%rdx,%rdx,2),%r10
  670600:	42 0f 2e 4c d1 08    	ucomiss 0x8(%rcx,%r10,8),%xmm1
  670606:	49 0f 42 d0          	cmovb  %r8,%rdx
  67060a:	4c 29 c8             	sub    %r9,%rax
  67060d:	48 83 f8 01          	cmp    $0x1,%rax
  670611:	77 dd                	ja     6705f0 <<gpui_canvas::text::TextLayout>::position_at+0x80>
  670613:	4c 8d 04 52          	lea    (%rdx,%rdx,2),%r8
  670617:	31 c0                	xor    %eax,%eax
  670619:	42 0f 2e 4c c1 08    	ucomiss 0x8(%rcx,%r8,8),%xmm1
  67061f:	0f 93 c0             	setae  %al
  670622:	48 01 d0             	add    %rdx,%rax
  670625:	48 83 f8 01          	cmp    $0x1,%rax
  670629:	48 83 d0 ff          	adc    $0xffffffffffffffff,%rax
  67062d:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  670632:	48 39 f0             	cmp    %rsi,%rax
  670635:	0f 83 16 06 00 00    	jae    670c51 <<gpui_canvas::text::TextLayout>::position_at+0x6e1>
  67063b:	4d 8b 57 38          	mov    0x38(%r15),%r10
  67063f:	4d 8b 5f 40          	mov    0x40(%r15),%r11
  670643:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  670647:	8b 0c c1             	mov    (%rcx,%rax,8),%ecx
  67064a:	85 c9                	test   %ecx,%ecx
  67064c:	74 51                	je     67069f <<gpui_canvas::text::TextLayout>::position_at+0x12f>
  67064e:	4c 89 d8             	mov    %r11,%rax
  670651:	4d 85 db             	test   %r11,%r11
  670654:	74 4b                	je     6706a1 <<gpui_canvas::text::TextLayout>::position_at+0x131>
  670656:	31 c0                	xor    %eax,%eax
  670658:	49 83 fb 01          	cmp    $0x1,%r11
  67065c:	74 32                	je     670690 <<gpui_canvas::text::TextLayout>::position_at+0x120>
  67065e:	4c 89 da             	mov    %r11,%rdx
  670661:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  670668:	0f 1f 84 00 00 00 00
  67066f:	00
  670670:	48 89 d6             	mov    %rdx,%rsi
  670673:	48 d1 ee             	shr    $1,%rsi
  670676:	4c 8d 04 06          	lea    (%rsi,%rax,1),%r8
  67067a:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
  67067e:	43 39 4c ca 10       	cmp    %ecx,0x10(%r10,%r9,8)
  670683:	49 0f 42 c0          	cmovb  %r8,%rax
  670687:	48 29 f2             	sub    %rsi,%rdx
  67068a:	48 83 fa 01          	cmp    $0x1,%rdx
  67068e:	77 e0                	ja     670670 <<gpui_canvas::text::TextLayout>::position_at+0x100>
  670690:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
  670694:	41 39 4c d2 10       	cmp    %ecx,0x10(%r10,%rdx,8)
  670699:	48 83 d0 00          	adc    $0x0,%rax
  67069d:	eb 02                	jmp    6706a1 <<gpui_canvas::text::TextLayout>::position_at+0x131>
  67069f:	31 c0                	xor    %eax,%eax
  6706a1:	4c 89 d9             	mov    %r11,%rcx
  6706a4:	4c 89 9c 24 88 00 00 	mov    %r11,0x88(%rsp)
  6706ab:	00
  6706ac:	48 29 c1             	sub    %rax,%rcx
  6706af:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  6706b3:	4c 89 94 24 90 00 00 	mov    %r10,0x90(%rsp)
  6706ba:	00
  6706bb:	49 8d 2c c2          	lea    (%r10,%rax,8),%rbp
  6706bf:	f3 0f 10 57 34       	movss  0x34(%rdi),%xmm2
  6706c4:	f3 0f 59 15 74 9a 9a 	mulss  -0x65658c(%rip),%xmm2        # 1a140 <GCC_except_table0+0x80>
  6706cb:	ff
  6706cc:	0f 57 c9             	xorps  %xmm1,%xmm1
  6706cf:	0f 11 4c 24 50       	movups %xmm1,0x50(%rsp)
  6706d4:	49 8d 47 18          	lea    0x18(%r15),%rax
  6706d8:	48 8d 54 24 18       	lea    0x18(%rsp),%rdx
  6706dd:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  6706e2:	48 89 6c 24 28       	mov    %rbp,0x28(%rsp)
  6706e7:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  6706ec:	48 89 6c 24 38       	mov    %rbp,0x38(%rsp)
  6706f1:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  6706f6:	48 c7 44 24 48 01 00 	movq   $0x1,0x48(%rsp)
  6706fd:	00 00
  6706ff:	4c 89 7c 24 60       	mov    %r15,0x60(%rsp)
  670704:	f3 0f 11 54 24 68    	movss  %xmm2,0x68(%rsp)
  67070a:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  67070f:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
  670714:	c6 84 24 80 00 00 00 	movb   $0x0,0x80(%rsp)
  67071b:	00
  67071c:	40 b6 02             	mov    $0x2,%sil
  67071f:	b2 02                	mov    $0x2,%dl
  670721:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  670726:	48 85 c0             	test   %rax,%rax
  670729:	0f 84 69 04 00 00    	je     670b98 <<gpui_canvas::text::TextLayout>::position_at+0x628>
  67072f:	40 88 74 24 03       	mov    %sil,0x3(%rsp)
  670734:	eb 18                	jmp    67074e <<gpui_canvas::text::TextLayout>::position_at+0x1de>
  670736:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  67073d:	00 00 00
  670740:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  670745:	48 85 c0             	test   %rax,%rax
  670748:	0f 84 61 03 00 00    	je     670aaf <<gpui_canvas::text::TextLayout>::position_at+0x53f>
  67074e:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
  670753:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  670759:	48 83 f8 01          	cmp    $0x1,%rax
  67075d:	74 28                	je     670787 <<gpui_canvas::text::TextLayout>::position_at+0x217>
  67075f:	49 8d 4e 28          	lea    0x28(%r14),%rcx
  670763:	48 8d 70 01          	lea    0x1(%rax),%rsi
  670767:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  67076e:	00 00
  670770:	8b 79 e8             	mov    -0x18(%rcx),%edi
  670773:	3b 39                	cmp    (%rcx),%edi
  670775:	75 10                	jne    670787 <<gpui_canvas::text::TextLayout>::position_at+0x217>
  670777:	49 ff c5             	inc    %r13
  67077a:	48 83 c1 18          	add    $0x18,%rcx
  67077e:	48 ff ce             	dec    %rsi
  670781:	48 83 fe 02          	cmp    $0x2,%rsi
  670785:	77 e9                	ja     670770 <<gpui_canvas::text::TextLayout>::position_at+0x200>
  670787:	4c 29 e8             	sub    %r13,%rax
  67078a:	0f 82 58 04 00 00    	jb     670be8 <<gpui_canvas::text::TextLayout>::position_at+0x678>
  670790:	4a 8d 0c 6d 00 00 00 	lea    0x0(,%r13,2),%rcx
  670797:	00
  670798:	4c 01 e9             	add    %r13,%rcx
  67079b:	49 8d 0c ce          	lea    (%r14,%rcx,8),%rcx
  67079f:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6707a4:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6707a9:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6707ae:	48 85 f6             	test   %rsi,%rsi
  6707b1:	0f 85 ce 01 00 00    	jne    670985 <<gpui_canvas::text::TextLayout>::position_at+0x415>
  6707b7:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  6707bc:	48 85 f6             	test   %rsi,%rsi
  6707bf:	74 5f                	je     670820 <<gpui_canvas::text::TextLayout>::position_at+0x2b0>
  6707c1:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6707c6:	b9 01 00 00 00       	mov    $0x1,%ecx
  6707cb:	48 83 fe 01          	cmp    $0x1,%rsi
  6707cf:	74 28                	je     6707f9 <<gpui_canvas::text::TextLayout>::position_at+0x289>
  6707d1:	48 8d 78 28          	lea    0x28(%rax),%rdi
  6707d5:	4c 8d 46 01          	lea    0x1(%rsi),%r8
  6707d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6707e0:	44 8b 4f e8          	mov    -0x18(%rdi),%r9d
  6707e4:	44 3b 0f             	cmp    (%rdi),%r9d
  6707e7:	75 10                	jne    6707f9 <<gpui_canvas::text::TextLayout>::position_at+0x289>
  6707e9:	48 ff c1             	inc    %rcx
  6707ec:	48 83 c7 18          	add    $0x18,%rdi
  6707f0:	49 ff c8             	dec    %r8
  6707f3:	49 83 f8 02          	cmp    $0x2,%r8
  6707f7:	77 e7                	ja     6707e0 <<gpui_canvas::text::TextLayout>::position_at+0x270>
  6707f9:	48 29 ce             	sub    %rcx,%rsi
  6707fc:	0f 82 e6 03 00 00    	jb     670be8 <<gpui_canvas::text::TextLayout>::position_at+0x678>
  670802:	48 8d 3c 49          	lea    (%rcx,%rcx,2),%rdi
  670806:	48 8d 3c f8          	lea    (%rax,%rdi,8),%rdi
  67080a:	48 89 7c 24 38       	mov    %rdi,0x38(%rsp)
  67080f:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
  670814:	48 85 c0             	test   %rax,%rax
  670817:	75 12                	jne    67082b <<gpui_canvas::text::TextLayout>::position_at+0x2bb>
  670819:	e9 91 02 00 00       	jmp    670aaf <<gpui_canvas::text::TextLayout>::position_at+0x53f>
  67081e:	66 90                	xchg   %ax,%ax
  670820:	31 c0                	xor    %eax,%eax
  670822:	48 85 c0             	test   %rax,%rax
  670825:	0f 84 84 02 00 00    	je     670aaf <<gpui_canvas::text::TextLayout>::position_at+0x53f>
  67082b:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  670830:	49 c1 e5 03          	shl    $0x3,%r13
  670834:	4a 8d 3c 6d 00 00 00 	lea    0x0(,%r13,2),%rdi
  67083b:	00
  67083c:	4c 01 ef             	add    %r13,%rdi
  67083f:	45 31 c9             	xor    %r9d,%r9d
  670842:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  670849:	1f 84 00 00 00 00 00
  670850:	4c 39 cf             	cmp    %r9,%rdi
  670853:	0f 84 e7 fe ff ff    	je     670740 <<gpui_canvas::text::TextLayout>::position_at+0x1d0>
  670859:	4d 8d 41 18          	lea    0x18(%r9),%r8
  67085d:	43 f6 44 0e 14 02    	testb  $0x2,0x14(%r14,%r9,1)
  670863:	4d 89 c1             	mov    %r8,%r9
  670866:	74 e8                	je     670850 <<gpui_canvas::text::TextLayout>::position_at+0x2e0>
  670868:	48 c1 e1 03          	shl    $0x3,%rcx
  67086c:	48 8d 3c 49          	lea    (%rcx,%rcx,2),%rdi
  670870:	45 31 c9             	xor    %r9d,%r9d
  670873:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  67087a:	84 00 00 00 00 00
  670880:	4c 39 cf             	cmp    %r9,%rdi
  670883:	0f 84 b7 fe ff ff    	je     670740 <<gpui_canvas::text::TextLayout>::position_at+0x1d0>
  670889:	49 8d 49 18          	lea    0x18(%r9),%rcx
  67088d:	42 f6 44 08 14 01    	testb  $0x1,0x14(%rax,%r9,1)
  670893:	49 89 c9             	mov    %rcx,%r9
  670896:	74 e8                	je     670880 <<gpui_canvas::text::TextLayout>::position_at+0x310>
  670898:	f3 43 0f 10 5c 06 ec 	movss  -0x14(%r14,%r8,1),%xmm3
  67089f:	4c 8b 4e 28          	mov    0x28(%rsi),%r9
  6708a3:	4d 85 c9             	test   %r9,%r9
  6708a6:	74 57                	je     6708ff <<gpui_canvas::text::TextLayout>::position_at+0x38f>
  6708a8:	48 8b 7e 20          	mov    0x20(%rsi),%rdi
  6708ac:	45 31 d2             	xor    %r10d,%r10d
  6708af:	49 83 f9 01          	cmp    $0x1,%r9
  6708b3:	74 2e                	je     6708e3 <<gpui_canvas::text::TextLayout>::position_at+0x373>
  6708b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6708bc:	00 00 00 00
  6708c0:	4d 89 d3             	mov    %r10,%r11
  6708c3:	4d 89 cd             	mov    %r9,%r13
  6708c6:	49 d1 ed             	shr    $1,%r13
  6708c9:	4d 01 ea             	add    %r13,%r10
  6708cc:	4f 8d 24 52          	lea    (%r10,%r10,2),%r12
  6708d0:	42 0f 2e 5c e7 08    	ucomiss 0x8(%rdi,%r12,8),%xmm3
  6708d6:	4d 0f 42 d3          	cmovb  %r11,%r10
  6708da:	4d 29 e9             	sub    %r13,%r9
  6708dd:	49 83 f9 01          	cmp    $0x1,%r9
  6708e1:	77 dd                	ja     6708c0 <<gpui_canvas::text::TextLayout>::position_at+0x350>
  6708e3:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  6708e7:	45 31 c9             	xor    %r9d,%r9d
  6708ea:	42 0f 2e 5c df 08    	ucomiss 0x8(%rdi,%r11,8),%xmm3
  6708f0:	41 0f 93 c1          	setae  %r9b
  6708f4:	4d 01 d1             	add    %r10,%r9
  6708f7:	49 83 f9 01          	cmp    $0x1,%r9
  6708fb:	49 83 d1 ff          	adc    $0xffffffffffffffff,%r9
  6708ff:	f3 0f 10 54 08 ec    	movss  -0x14(%rax,%rcx,1),%xmm2
  670905:	0f 2e da             	ucomiss %xmm2,%xmm3
  670908:	75 02                	jne    67090c <<gpui_canvas::text::TextLayout>::position_at+0x39c>
  67090a:	7b 37                	jnp    670943 <<gpui_canvas::text::TextLayout>::position_at+0x3d3>
  67090c:	48 8b 7e 10          	mov    0x10(%rsi),%rdi
  670910:	48 83 ff 02          	cmp    $0x2,%rdi
  670914:	72 2d                	jb     670943 <<gpui_canvas::text::TextLayout>::position_at+0x3d3>
  670916:	48 8b 76 08          	mov    0x8(%rsi),%rsi
  67091a:	45 31 d2             	xor    %r10d,%r10d
  67091d:	0f 1f 00             	nopl   (%rax)
  670920:	49 89 fb             	mov    %rdi,%r11
  670923:	49 d1 eb             	shr    $1,%r11
  670926:	4f 8d 24 13          	lea    (%r11,%r10,1),%r12
  67092a:	4f 8d 2c 64          	lea    (%r12,%r12,2),%r13
  67092e:	46 8b 6c ee 10       	mov    0x10(%rsi,%r13,8),%r13d
  670933:	4d 39 e9             	cmp    %r13,%r9
  670936:	4d 0f 47 d4          	cmova  %r12,%r10
  67093a:	4c 29 df             	sub    %r11,%rdi
  67093d:	48 83 ff 01          	cmp    $0x1,%rdi
  670941:	77 dd                	ja     670920 <<gpui_canvas::text::TextLayout>::position_at+0x3b0>
  670943:	4c 8b 54 24 70       	mov    0x70(%rsp),%r10
  670948:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  67094d:	48 8b 3e             	mov    (%rsi),%rdi
  670950:	49 8b 72 10          	mov    0x10(%r10),%rsi
  670954:	48 39 f7             	cmp    %rsi,%rdi
  670957:	0f 83 da 02 00 00    	jae    670c37 <<gpui_canvas::text::TextLayout>::position_at+0x6c7>
  67095d:	43 8b 74 06 f8       	mov    -0x8(%r14,%r8,1),%esi
  670962:	4d 8b 52 08          	mov    0x8(%r10),%r10
  670966:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
  67096a:	41 3b 74 fa 04       	cmp    0x4(%r10,%rdi,8),%esi
  67096f:	0f 87 3a 01 00 00    	ja     670aaf <<gpui_canvas::text::TextLayout>::position_at+0x53f>
  670975:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  67097a:	4c 3b 0f             	cmp    (%rdi),%r9
  67097d:	0f 85 bd fd ff ff    	jne    670740 <<gpui_canvas::text::TextLayout>::position_at+0x1d0>
  670983:	eb 44                	jmp    6709c9 <<gpui_canvas::text::TextLayout>::position_at+0x459>
  670985:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
  67098c:	00 00
  67098e:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  670993:	89 54 24 14          	mov    %edx,0x14(%rsp)
  670997:	66 0f 7e 44 24 10    	movd   %xmm0,0x10(%rsp)
  67099d:	f3 0f 11 7c 24 0c    	movss  %xmm7,0xc(%rsp)
  6709a3:	e8 78 07 00 00       	call   671120 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::Details>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator>::nth>
  6709a8:	f3 0f 10 7c 24 0c    	movss  0xc(%rsp),%xmm7
  6709ae:	66 0f 6e 44 24 10    	movd   0x10(%rsp),%xmm0
  6709b4:	48 89 d1             	mov    %rdx,%rcx
  6709b7:	8b 54 24 14          	mov    0x14(%rsp),%edx
  6709bb:	48 85 c0             	test   %rax,%rax
  6709be:	0f 85 67 fe ff ff    	jne    67082b <<gpui_canvas::text::TextLayout>::position_at+0x2bb>
  6709c4:	e9 e6 00 00 00       	jmp    670aaf <<gpui_canvas::text::TextLayout>::position_at+0x53f>
  6709c9:	f3 43 0f 10 4c 06 e8 	movss  -0x18(%r14,%r8,1),%xmm1
  6709d0:	40 b7 01             	mov    $0x1,%dil
  6709d3:	0f 2e da             	ucomiss %xmm2,%xmm3
  6709d6:	75 02                	jne    6709da <<gpui_canvas::text::TextLayout>::position_at+0x46a>
  6709d8:	7b 09                	jnp    6709e3 <<gpui_canvas::text::TextLayout>::position_at+0x473>
  6709da:	89 f0                	mov    %esi,%eax
  6709dc:	b1 01                	mov    $0x1,%cl
  6709de:	0f 28 f1             	movaps %xmm1,%xmm6
  6709e1:	eb 5b                	jmp    670a3e <<gpui_canvas::text::TextLayout>::position_at+0x4ce>
  6709e3:	f3 0f 10 54 08 e8    	movss  -0x18(%rax,%rcx,1),%xmm2
  6709e9:	44 8b 44 08 f8       	mov    -0x8(%rax,%rcx,1),%r8d
  6709ee:	0f 28 e9             	movaps %xmm1,%xmm5
  6709f1:	f3 0f 5d ea          	minss  %xmm2,%xmm5
  6709f5:	0f 28 dd             	movaps %xmm5,%xmm3
  6709f8:	f3 0f c2 dd 03       	cmpunordss %xmm5,%xmm3
  6709fd:	0f 28 e3             	movaps %xmm3,%xmm4
  670a00:	0f 55 e5             	andnps %xmm5,%xmm4
  670a03:	0f 54 d9             	andps  %xmm1,%xmm3
  670a06:	0f 56 dc             	orps   %xmm4,%xmm3
  670a09:	0f 28 e1             	movaps %xmm1,%xmm4
  670a0c:	f3 0f 5f e2          	maxss  %xmm2,%xmm4
  670a10:	0f 28 f4             	movaps %xmm4,%xmm6
  670a13:	f3 0f c2 f4 03       	cmpunordss %xmm4,%xmm6
  670a18:	0f 28 ee             	movaps %xmm6,%xmm5
  670a1b:	0f 55 ec             	andnps %xmm4,%xmm5
  670a1e:	0f 54 f1             	andps  %xmm1,%xmm6
  670a21:	0f 56 f5             	orps   %xmm5,%xmm6
  670a24:	0f 2e d1             	ucomiss %xmm1,%xmm2
  670a27:	40 0f 97 c7          	seta   %dil
  670a2b:	89 f0                	mov    %esi,%eax
  670a2d:	41 0f 47 c0          	cmova  %r8d,%eax
  670a31:	44 0f 47 c6          	cmova  %esi,%r8d
  670a35:	0f 96 c1             	setbe  %cl
  670a38:	0f 28 cb             	movaps %xmm3,%xmm1
  670a3b:	44 89 c6             	mov    %r8d,%esi
  670a3e:	44 0f b6 44 24 03    	movzbl 0x3(%rsp),%r8d
  670a44:	0f 2e c8             	ucomiss %xmm0,%xmm1
  670a47:	76 23                	jbe    670a6c <<gpui_canvas::text::TextLayout>::position_at+0x4fc>
  670a49:	80 fa 02             	cmp    $0x2,%dl
  670a4c:	74 34                	je     670a82 <<gpui_canvas::text::TextLayout>::position_at+0x512>
  670a4e:	f3 0f 10 54 24 08    	movss  0x8(%rsp),%xmm2
  670a54:	0f 2e d1             	ucomiss %xmm1,%xmm2
  670a57:	8b 44 24 04          	mov    0x4(%rsp),%eax
  670a5b:	76 0a                	jbe    670a67 <<gpui_canvas::text::TextLayout>::position_at+0x4f7>
  670a5d:	f3 0f 11 4c 24 08    	movss  %xmm1,0x8(%rsp)
  670a63:	89 f3                	mov    %esi,%ebx
  670a65:	89 fa                	mov    %edi,%edx
  670a67:	0f 28 f7             	movaps %xmm7,%xmm6
  670a6a:	eb 27                	jmp    670a93 <<gpui_canvas::text::TextLayout>::position_at+0x523>
  670a6c:	0f 2e c6             	ucomiss %xmm6,%xmm0
  670a6f:	0f 86 8c 01 00 00    	jbe    670c01 <<gpui_canvas::text::TextLayout>::position_at+0x691>
  670a75:	41 80 f8 02          	cmp    $0x2,%r8b
  670a79:	74 1b                	je     670a96 <<gpui_canvas::text::TextLayout>::position_at+0x526>
  670a7b:	0f 2e f7             	ucomiss %xmm7,%xmm6
  670a7e:	76 0c                	jbe    670a8c <<gpui_canvas::text::TextLayout>::position_at+0x51c>
  670a80:	eb 14                	jmp    670a96 <<gpui_canvas::text::TextLayout>::position_at+0x526>
  670a82:	f3 0f 11 4c 24 08    	movss  %xmm1,0x8(%rsp)
  670a88:	89 f3                	mov    %esi,%ebx
  670a8a:	89 fa                	mov    %edi,%edx
  670a8c:	0f 28 f7             	movaps %xmm7,%xmm6
  670a8f:	8b 44 24 04          	mov    0x4(%rsp),%eax
  670a93:	44 89 c1             	mov    %r8d,%ecx
  670a96:	80 bc 24 80 00 00 00 	cmpb   $0x0,0x80(%rsp)
  670a9d:	00
  670a9e:	89 ce                	mov    %ecx,%esi
  670aa0:	89 44 24 04          	mov    %eax,0x4(%rsp)
  670aa4:	0f 28 fe             	movaps %xmm6,%xmm7
  670aa7:	0f 84 74 fc ff ff    	je     670721 <<gpui_canvas::text::TextLayout>::position_at+0x1b1>
  670aad:	eb 0c                	jmp    670abb <<gpui_canvas::text::TextLayout>::position_at+0x54b>
  670aaf:	0f 28 f7             	movaps %xmm7,%xmm6
  670ab2:	8b 44 24 04          	mov    0x4(%rsp),%eax
  670ab6:	0f b6 4c 24 03       	movzbl 0x3(%rsp),%ecx
  670abb:	80 f9 02             	cmp    $0x2,%cl
  670abe:	0f 85 e6 00 00 00    	jne    670baa <<gpui_canvas::text::TextLayout>::position_at+0x63a>
  670ac4:	80 fa 02             	cmp    $0x2,%dl
  670ac7:	0f 85 ab 00 00 00    	jne    670b78 <<gpui_canvas::text::TextLayout>::position_at+0x608>
  670acd:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  670ad4:	00
  670ad5:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  670ad9:	48 8b 8c 24 90 00 00 	mov    0x90(%rsp),%rcx
  670ae0:	00
  670ae1:	48 8d 04 c1          	lea    (%rcx,%rax,8),%rax
  670ae5:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  670aea:	48 8d 0c 7f          	lea    (%rdi,%rdi,2),%rcx
  670aee:	eb 25                	jmp    670b15 <<gpui_canvas::text::TextLayout>::position_at+0x5a5>
  670af0:	48 8d 34 52          	lea    (%rdx,%rdx,2),%rsi
  670af4:	45 31 d2             	xor    %r10d,%r10d
  670af7:	41 0f 2e 44 f1 08    	ucomiss 0x8(%r9,%rsi,8),%xmm0
  670afd:	49 8d 68 18          	lea    0x18(%r8),%rbp
  670b01:	41 0f 93 c2          	setae  %r10b
  670b05:	49 01 d2             	add    %rdx,%r10
  670b08:	49 83 fa 01          	cmp    $0x1,%r10
  670b0c:	49 83 d2 ff          	adc    $0xffffffffffffffff,%r10
  670b10:	49 39 fa             	cmp    %rdi,%r10
  670b13:	74 77                	je     670b8c <<gpui_canvas::text::TextLayout>::position_at+0x61c>
  670b15:	b2 02                	mov    $0x2,%dl
  670b17:	48 39 c5             	cmp    %rax,%rbp
  670b1a:	74 5c                	je     670b78 <<gpui_canvas::text::TextLayout>::position_at+0x608>
  670b1c:	49 8b 77 28          	mov    0x28(%r15),%rsi
  670b20:	48 39 f7             	cmp    %rsi,%rdi
  670b23:	0f 83 1b 01 00 00    	jae    670c44 <<gpui_canvas::text::TextLayout>::position_at+0x6d4>
  670b29:	49 89 e8             	mov    %rbp,%r8
  670b2c:	4d 8b 4f 20          	mov    0x20(%r15),%r9
  670b30:	8b 5d 10             	mov    0x10(%rbp),%ebx
  670b33:	41 3b 5c c9 04       	cmp    0x4(%r9,%rcx,8),%ebx
  670b38:	77 3e                	ja     670b78 <<gpui_canvas::text::TextLayout>::position_at+0x608>
  670b3a:	f3 41 0f 10 40 04    	movss  0x4(%r8),%xmm0
  670b40:	31 d2                	xor    %edx,%edx
  670b42:	48 83 fe 01          	cmp    $0x1,%rsi
  670b46:	74 a8                	je     670af0 <<gpui_canvas::text::TextLayout>::position_at+0x580>
  670b48:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  670b4f:	00
  670b50:	49 89 d2             	mov    %rdx,%r10
  670b53:	49 89 f3             	mov    %rsi,%r11
  670b56:	49 d1 eb             	shr    $1,%r11
  670b59:	4c 01 da             	add    %r11,%rdx
  670b5c:	4c 8d 34 52          	lea    (%rdx,%rdx,2),%r14
  670b60:	43 0f 2e 44 f1 08    	ucomiss 0x8(%r9,%r14,8),%xmm0
  670b66:	49 0f 42 d2          	cmovb  %r10,%rdx
  670b6a:	4c 29 de             	sub    %r11,%rsi
  670b6d:	48 83 fe 01          	cmp    $0x1,%rsi
  670b71:	77 dd                	ja     670b50 <<gpui_canvas::text::TextLayout>::position_at+0x5e0>
  670b73:	e9 78 ff ff ff       	jmp    670af0 <<gpui_canvas::text::TextLayout>::position_at+0x580>
  670b78:	89 d8                	mov    %ebx,%eax
  670b7a:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  670b81:	5b                   	pop    %rbx
  670b82:	41 5c                	pop    %r12
  670b84:	41 5d                	pop    %r13
  670b86:	41 5e                	pop    %r14
  670b88:	41 5f                	pop    %r15
  670b8a:	5d                   	pop    %rbp
  670b8b:	c3                   	ret
  670b8c:	41 0f b6 50 14       	movzbl 0x14(%r8),%edx
  670b91:	d0 ea                	shr    $1,%dl
  670b93:	80 e2 01             	and    $0x1,%dl
  670b96:	eb e0                	jmp    670b78 <<gpui_canvas::text::TextLayout>::position_at+0x608>
  670b98:	0f 28 f7             	movaps %xmm7,%xmm6
  670b9b:	8b 44 24 04          	mov    0x4(%rsp),%eax
  670b9f:	89 f1                	mov    %esi,%ecx
  670ba1:	80 f9 02             	cmp    $0x2,%cl
  670ba4:	0f 84 1a ff ff ff    	je     670ac4 <<gpui_canvas::text::TextLayout>::position_at+0x554>
  670baa:	80 fa 02             	cmp    $0x2,%dl
  670bad:	75 06                	jne    670bb5 <<gpui_canvas::text::TextLayout>::position_at+0x645>
  670baf:	89 ca                	mov    %ecx,%edx
  670bb1:	89 c3                	mov    %eax,%ebx
  670bb3:	eb c3                	jmp    670b78 <<gpui_canvas::text::TextLayout>::position_at+0x608>
  670bb5:	0f 57 d2             	xorps  %xmm2,%xmm2
  670bb8:	f3 0f 5a d6          	cvtss2sd %xmm6,%xmm2
  670bbc:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
  670bc2:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  670bc6:	f2 0f 58 ca          	addsd  %xmm2,%xmm1
  670bca:	f2 0f 59 0d 06 05 9b 	mulsd  -0x64fafa(%rip),%xmm1        # 210d8 <anon.0489ba3ebefb5402e80a192bcb938943.30.llvm.1203371347567281581+0x111>
  670bd1:	ff
  670bd2:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  670bd6:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  670bda:	0f 46 d8             	cmovbe %eax,%ebx
  670bdd:	0f b6 c2             	movzbl %dl,%eax
  670be0:	0f b6 d1             	movzbl %cl,%edx
  670be3:	0f 47 d0             	cmova  %eax,%edx
  670be6:	eb 90                	jmp    670b78 <<gpui_canvas::text::TextLayout>::position_at+0x608>
  670be8:	48 8d 3d 22 ae be ff 	lea    -0x4151de(%rip),%rdi        # 25ba11 <gpui_canvas::text::PRIMARY_BYTES+0x1f4448>
  670bef:	48 8d 15 72 6d 0f 00 	lea    0xf6d72(%rip),%rdx        # 767968 <anon.6c90822af352b8e064c50ed4f1c3be18.6.llvm.10547532359908779909+0x60>
  670bf6:	be 13 00 00 00       	mov    $0x13,%esi
  670bfb:	ff 15 f7 05 10 00    	call   *0x1005f7(%rip)        # 7711f8 <_DYNAMIC+0x340>
  670c01:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  670c05:	0f 57 d2             	xorps  %xmm2,%xmm2
  670c08:	f3 0f 5a d6          	cvtss2sd %xmm6,%xmm2
  670c0c:	f2 0f 58 d1          	addsd  %xmm1,%xmm2
  670c10:	f2 0f 59 15 c0 04 9b 	mulsd  -0x64fb40(%rip),%xmm2        # 210d8 <anon.0489ba3ebefb5402e80a192bcb938943.30.llvm.1203371347567281581+0x111>
  670c17:	ff
  670c18:	0f 57 c9             	xorps  %xmm1,%xmm1
  670c1b:	f3 0f 5a c8          	cvtss2sd %xmm0,%xmm1
  670c1f:	66 0f 2e ca          	ucomisd %xmm2,%xmm1
  670c23:	0f 47 f0             	cmova  %eax,%esi
  670c26:	0f b6 c1             	movzbl %cl,%eax
  670c29:	40 0f b6 d7          	movzbl %dil,%edx
  670c2d:	0f 47 d0             	cmova  %eax,%edx
  670c30:	89 f3                	mov    %esi,%ebx
  670c32:	e9 41 ff ff ff       	jmp    670b78 <<gpui_canvas::text::TextLayout>::position_at+0x608>
  670c37:	48 8d 15 12 6d 0f 00 	lea    0xf6d12(%rip),%rdx        # 767950 <anon.6c90822af352b8e064c50ed4f1c3be18.6.llvm.10547532359908779909+0x48>
  670c3e:	ff 15 2c 06 10 00    	call   *0x10062c(%rip)        # 771270 <_DYNAMIC+0x3b8>
  670c44:	48 8d 15 d5 6c 0f 00 	lea    0xf6cd5(%rip),%rdx        # 767920 <anon.6c90822af352b8e064c50ed4f1c3be18.6.llvm.10547532359908779909+0x18>
  670c4b:	ff 15 1f 06 10 00    	call   *0x10061f(%rip)        # 771270 <_DYNAMIC+0x3b8>
  670c51:	48 8d 15 28 64 0f 00 	lea    0xf6428(%rip),%rdx        # 767080 <anon.b00a0cf17e3fb3b511483359a0f70536.36.llvm.14182224944371825864>
  670c58:	48 89 c7             	mov    %rax,%rdi
  670c5b:	ff 15 0f 06 10 00    	call   *0x10060f(%rip)        # 771270 <_DYNAMIC+0x3b8>
  670c61:	cc                   	int3
  670c62:	cc                   	int3
  670c63:	cc                   	int3
  670c64:	cc                   	int3
  670c65:	cc                   	int3
  670c66:	cc                   	int3
  670c67:	cc                   	int3
  670c68:	cc                   	int3
  670c69:	cc                   	int3
  670c6a:	cc                   	int3
  670c6b:	cc                   	int3
  670c6c:	cc                   	int3
  670c6d:	cc                   	int3
  670c6e:	cc                   	int3
  670c6f:	cc                   	int3
