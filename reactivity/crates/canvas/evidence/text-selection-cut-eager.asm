000000000065b470 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>>:
  65b470:	55                   	push   %rbp
  65b471:	41 57                	push   %r15
  65b473:	41 56                	push   %r14
  65b475:	41 55                	push   %r13
  65b477:	41 54                	push   %r12
  65b479:	53                   	push   %rbx
  65b47a:	48 81 ec a8 00 00 00 	sub    $0xa8,%rsp
  65b481:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
  65b486:	49 89 f7             	mov    %rsi,%r15
  65b489:	49 89 fc             	mov    %rdi,%r12
  65b48c:	ff 15 7e 5b 11 00    	call   *0x115b7e(%rip)        # 771010 <_DYNAMIC+0x360>
  65b492:	84 c0                	test   %al,%al
  65b494:	0f 84 2a 05 00 00    	je     65b9c4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x554>
  65b49a:	45 8b 37             	mov    (%r15),%r14d
  65b49d:	41 8b 57 08          	mov    0x8(%r15),%edx
  65b4a1:	44 39 f2             	cmp    %r14d,%edx
  65b4a4:	44 89 f1             	mov    %r14d,%ecx
  65b4a7:	0f 42 ca             	cmovb  %edx,%ecx
  65b4aa:	89 4c 24 1c          	mov    %ecx,0x1c(%rsp)
  65b4ae:	44 0f 47 f2          	cmova  %edx,%r14d
  65b4b2:	0f 84 0c 05 00 00    	je     65b9c4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x554>
  65b4b8:	4d 8b 6c 24 20       	mov    0x20(%r12),%r13
  65b4bd:	4d 85 ed             	test   %r13,%r13
  65b4c0:	0f 84 29 05 00 00    	je     65b9ef <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x57f>
  65b4c6:	88 44 24 03          	mov    %al,0x3(%rsp)
  65b4ca:	4c 89 ef             	mov    %r13,%rdi
  65b4cd:	8b 74 24 1c          	mov    0x1c(%rsp),%esi
  65b4d1:	44 89 f2             	mov    %r14d,%edx
  65b4d4:	31 c9                	xor    %ecx,%ecx
  65b4d6:	ff 15 3c 5b 11 00    	call   *0x115b3c(%rip)        # 771018 <_DYNAMIC+0x368>
  65b4dc:	48 89 d1             	mov    %rdx,%rcx
  65b4df:	f3 41 0f 10 44 24 34 	movss  0x34(%r12),%xmm0
  65b4e6:	f3 0f 59 05 32 ec 9b 	mulss  -0x6413ce(%rip),%xmm0        # 1a120 <GCC_except_table0+0x84>
  65b4ed:	ff
  65b4ee:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  65b4f3:	4c 89 ee             	mov    %r13,%rsi
  65b4f6:	48 89 c2             	mov    %rax,%rdx
  65b4f9:	ff 15 21 5b 11 00    	call   *0x115b21(%rip)        # 771020 <_DYNAMIC+0x370>
  65b4ff:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  65b504:	48 85 c0             	test   %rax,%rax
  65b507:	0f 84 b2 04 00 00    	je     65b9bf <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x54f>
  65b50d:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  65b512:	48 8b 09             	mov    (%rcx),%rcx
  65b515:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  65b51a:	48 8b ac 24 98 00 00 	mov    0x98(%rsp),%rbp
  65b521:	00
  65b522:	f3 0f 10 84 24 a0 00 	movss  0xa0(%rsp),%xmm0
  65b529:	00 00
  65b52b:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  65b531:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  65b538:	00 00
  65b53a:	f3 0f 11 7c 24 08    	movss  %xmm7,0x8(%rsp)
  65b540:	f3 0f 11 54 24 04    	movss  %xmm2,0x4(%rsp)
  65b546:	0f 28 e9             	movaps %xmm1,%xmm5
  65b549:	0f 28 f0             	movaps %xmm0,%xmm6
  65b54c:	eb 50                	jmp    65b59e <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x12e>
  65b54e:	0f 28 cb             	movaps %xmm3,%xmm1
  65b551:	f3 0f 5f cc          	maxss  %xmm4,%xmm1
  65b555:	0f 28 e9             	movaps %xmm1,%xmm5
  65b558:	f3 0f c2 e9 03       	cmpunordss %xmm1,%xmm5
  65b55d:	0f 28 d5             	movaps %xmm5,%xmm2
  65b560:	0f 55 d1             	andnps %xmm1,%xmm2
  65b563:	0f 54 eb             	andps  %xmm3,%xmm5
  65b566:	0f 56 ea             	orps   %xmm2,%xmm5
  65b569:	0f 28 ce             	movaps %xmm6,%xmm1
  65b56c:	f3 0f 5d c8          	minss  %xmm0,%xmm1
  65b570:	0f 28 c1             	movaps %xmm1,%xmm0
  65b573:	f3 0f c2 c1 03       	cmpunordss %xmm1,%xmm0
  65b578:	0f 28 d0             	movaps %xmm0,%xmm2
  65b57b:	0f 55 d1             	andnps %xmm1,%xmm2
  65b57e:	0f 54 c6             	andps  %xmm6,%xmm0
  65b581:	0f 56 c2             	orps   %xmm2,%xmm0
  65b584:	f3 0f 5c e8          	subss  %xmm0,%xmm5
  65b588:	0f 28 f0             	movaps %xmm0,%xmm6
  65b58b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  65b590:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  65b595:	48 85 c0             	test   %rax,%rax
  65b598:	0f 84 bd 03 00 00    	je     65b95b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4eb>
  65b59e:	48 8b 5c 24 60       	mov    0x60(%rsp),%rbx
  65b5a3:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  65b5a9:	48 83 f8 01          	cmp    $0x1,%rax
  65b5ad:	74 28                	je     65b5d7 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x167>
  65b5af:	48 8d 4b 28          	lea    0x28(%rbx),%rcx
  65b5b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  65b5b7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  65b5be:	00 00
  65b5c0:	8b 71 e8             	mov    -0x18(%rcx),%esi
  65b5c3:	3b 31                	cmp    (%rcx),%esi
  65b5c5:	75 10                	jne    65b5d7 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x167>
  65b5c7:	49 ff c5             	inc    %r13
  65b5ca:	48 83 c1 18          	add    $0x18,%rcx
  65b5ce:	48 ff ca             	dec    %rdx
  65b5d1:	48 83 fa 02          	cmp    $0x2,%rdx
  65b5d5:	77 e9                	ja     65b5c0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x150>
  65b5d7:	4c 29 e8             	sub    %r13,%rax
  65b5da:	0f 82 f6 03 00 00    	jb     65b9d6 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x566>
  65b5e0:	4a 8d 0c 6d 00 00 00 	lea    0x0(,%r13,2),%rcx
  65b5e7:	00
  65b5e8:	4c 01 e9             	add    %r13,%rcx
  65b5eb:	48 8d 0c cb          	lea    (%rbx,%rcx,8),%rcx
  65b5ef:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  65b5f4:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  65b5f9:	48 8b b4 24 80 00 00 	mov    0x80(%rsp),%rsi
  65b600:	00
  65b601:	48 85 f6             	test   %rsi,%rsi
  65b604:	0f 85 8f 02 00 00    	jne    65b899 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x429>
  65b60a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  65b60f:	48 85 c0             	test   %rax,%rax
  65b612:	74 5c                	je     65b670 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x200>
  65b614:	4c 8b 64 24 70       	mov    0x70(%rsp),%r12
  65b619:	ba 01 00 00 00       	mov    $0x1,%edx
  65b61e:	48 83 f8 01          	cmp    $0x1,%rax
  65b622:	74 23                	je     65b647 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1d7>
  65b624:	49 8d 4c 24 28       	lea    0x28(%r12),%rcx
  65b629:	48 8d 70 01          	lea    0x1(%rax),%rsi
  65b62d:	0f 1f 00             	nopl   (%rax)
  65b630:	8b 79 e8             	mov    -0x18(%rcx),%edi
  65b633:	3b 39                	cmp    (%rcx),%edi
  65b635:	75 10                	jne    65b647 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1d7>
  65b637:	48 ff c2             	inc    %rdx
  65b63a:	48 83 c1 18          	add    $0x18,%rcx
  65b63e:	48 ff ce             	dec    %rsi
  65b641:	48 83 fe 02          	cmp    $0x2,%rsi
  65b645:	77 e9                	ja     65b630 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1c0>
  65b647:	48 29 d0             	sub    %rdx,%rax
  65b64a:	0f 82 86 03 00 00    	jb     65b9d6 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x566>
  65b650:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  65b654:	49 8d 0c cc          	lea    (%r12,%rcx,8),%rcx
  65b658:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  65b65d:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  65b662:	4d 85 e4             	test   %r12,%r12
  65b665:	75 15                	jne    65b67c <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x20c>
  65b667:	e9 ef 02 00 00       	jmp    65b95b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4eb>
  65b66c:	0f 1f 40 00          	nopl   0x0(%rax)
  65b670:	45 31 e4             	xor    %r12d,%r12d
  65b673:	4d 85 e4             	test   %r12,%r12
  65b676:	0f 84 df 02 00 00    	je     65b95b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4eb>
  65b67c:	49 c1 e5 03          	shl    $0x3,%r13
  65b680:	4a 8d 04 6d 00 00 00 	lea    0x0(,%r13,2),%rax
  65b687:	00
  65b688:	4c 01 e8             	add    %r13,%rax
  65b68b:	31 c9                	xor    %ecx,%ecx
  65b68d:	0f 1f 00             	nopl   (%rax)
  65b690:	48 39 c8             	cmp    %rcx,%rax
  65b693:	0f 84 f7 fe ff ff    	je     65b590 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x120>
  65b699:	4c 8d 69 18          	lea    0x18(%rcx),%r13
  65b69d:	f6 44 0b 14 02       	testb  $0x2,0x14(%rbx,%rcx,1)
  65b6a2:	4c 89 e9             	mov    %r13,%rcx
  65b6a5:	74 e9                	je     65b690 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x220>
  65b6a7:	48 c1 e2 03          	shl    $0x3,%rdx
  65b6ab:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
  65b6af:	31 c9                	xor    %ecx,%ecx
  65b6b1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  65b6b8:	0f 1f 84 00 00 00 00
  65b6bf:	00
  65b6c0:	48 39 c8             	cmp    %rcx,%rax
  65b6c3:	0f 84 c7 fe ff ff    	je     65b590 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x120>
  65b6c9:	4c 8d 79 18          	lea    0x18(%rcx),%r15
  65b6cd:	41 f6 44 0c 14 01    	testb  $0x1,0x14(%r12,%rcx,1)
  65b6d3:	4c 89 f9             	mov    %r15,%rcx
  65b6d6:	74 e8                	je     65b6c0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x250>
  65b6d8:	0f 29 74 24 40       	movaps %xmm6,0x40(%rsp)
  65b6dd:	0f 29 6c 24 50       	movaps %xmm5,0x50(%rsp)
  65b6e2:	f3 42 0f 10 44 2b ec 	movss  -0x14(%rbx,%r13,1),%xmm0
  65b6e9:	f3 0f 11 44 24 3c    	movss  %xmm0,0x3c(%rsp)
  65b6ef:	48 89 ef             	mov    %rbp,%rdi
  65b6f2:	ff 15 30 59 11 00    	call   *0x115930(%rip)        # 771028 <_DYNAMIC+0x378>
  65b6f8:	f3 0f 10 7c 24 3c    	movss  0x3c(%rsp),%xmm7
  65b6fe:	43 0f 2e 7c 3c ec    	ucomiss -0x14(%r12,%r15,1),%xmm7
  65b704:	f3 42 0f 10 44 2b e8 	movss  -0x18(%rbx,%r13,1),%xmm0
  65b70b:	75 02                	jne    65b70f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x29f>
  65b70d:	7b 28                	jnp    65b737 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x2c7>
  65b70f:	48 8b 4d 08          	mov    0x8(%rbp),%rcx
  65b713:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  65b717:	48 89 f2             	mov    %rsi,%rdx
  65b71a:	48 85 f6             	test   %rsi,%rsi
  65b71d:	0f 28 6c 24 50       	movaps 0x50(%rsp),%xmm5
  65b722:	0f 28 74 24 40       	movaps 0x40(%rsp),%xmm6
  65b727:	0f 84 95 00 00 00    	je     65b7c2 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x352>
  65b72d:	48 83 fe 01          	cmp    $0x1,%rsi
  65b731:	75 4d                	jne    65b780 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x310>
  65b733:	31 d2                	xor    %edx,%edx
  65b735:	eb 7c                	jmp    65b7b3 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x343>
  65b737:	f3 43 0f 10 4c 3c e8 	movss  -0x18(%r12,%r15,1),%xmm1
  65b73e:	0f 28 d0             	movaps %xmm0,%xmm2
  65b741:	f3 0f 5d d1          	minss  %xmm1,%xmm2
  65b745:	0f 28 da             	movaps %xmm2,%xmm3
  65b748:	f3 0f c2 da 03       	cmpunordss %xmm2,%xmm3
  65b74d:	0f 28 e3             	movaps %xmm3,%xmm4
  65b750:	0f 55 e2             	andnps %xmm2,%xmm4
  65b753:	0f 54 d8             	andps  %xmm0,%xmm3
  65b756:	0f 56 dc             	orps   %xmm4,%xmm3
  65b759:	42 8b 54 2b f8       	mov    -0x8(%rbx,%r13,1),%edx
  65b75e:	43 8b 74 3c f8       	mov    -0x8(%r12,%r15,1),%esi
  65b763:	f3 0f 5c c8          	subss  %xmm0,%xmm1
  65b767:	0f 54 0d f2 63 9c ff 	andps  -0x639c0e(%rip),%xmm1        # 21b60 <anon.255c12af0f8be736e5d332bcd13dbe27.0.llvm.11532299149726854919+0x7d0>
  65b76e:	0f 28 c3             	movaps %xmm3,%xmm0
  65b771:	0f 28 6c 24 50       	movaps 0x50(%rsp),%xmm5
  65b776:	0f 28 74 24 40       	movaps 0x40(%rsp),%xmm6
  65b77b:	e9 a7 00 00 00       	jmp    65b827 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3b7>
  65b780:	48 89 f7             	mov    %rsi,%rdi
  65b783:	31 d2                	xor    %edx,%edx
  65b785:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  65b78c:	00 00 00 00
  65b790:	49 89 f8             	mov    %rdi,%r8
  65b793:	49 d1 e8             	shr    $1,%r8
  65b796:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  65b79a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  65b79e:	46 8b 54 d1 10       	mov    0x10(%rcx,%r10,8),%r10d
  65b7a3:	4c 39 d0             	cmp    %r10,%rax
  65b7a6:	49 0f 47 d1          	cmova  %r9,%rdx
  65b7aa:	4c 29 c7             	sub    %r8,%rdi
  65b7ad:	48 83 ff 01          	cmp    $0x1,%rdi
  65b7b1:	77 dd                	ja     65b790 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x320>
  65b7b3:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  65b7b7:	8b 7c f9 10          	mov    0x10(%rcx,%rdi,8),%edi
  65b7bb:	48 39 c7             	cmp    %rax,%rdi
  65b7be:	48 83 d2 00          	adc    $0x0,%rdx
  65b7c2:	48 c1 e2 03          	shl    $0x3,%rdx
  65b7c6:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  65b7ca:	4c 8d 04 39          	lea    (%rcx,%rdi,1),%r8
  65b7ce:	42 8b 54 2b f8       	mov    -0x8(%rbx,%r13,1),%edx
  65b7d3:	48 c1 e6 03          	shl    $0x3,%rsi
  65b7d7:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  65b7db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  65b7e0:	48 39 fe             	cmp    %rdi,%rsi
  65b7e3:	74 37                	je     65b81c <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3ac>
  65b7e5:	4d 89 c1             	mov    %r8,%r9
  65b7e8:	45 8b 40 10          	mov    0x10(%r8),%r8d
  65b7ec:	4c 39 c0             	cmp    %r8,%rax
  65b7ef:	75 2b                	jne    65b81c <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3ac>
  65b7f1:	4d 8d 41 18          	lea    0x18(%r9),%r8
  65b7f5:	48 83 c7 18          	add    $0x18,%rdi
  65b7f9:	41 39 11             	cmp    %edx,(%r9)
  65b7fc:	77 e2                	ja     65b7e0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x370>
  65b7fe:	41 3b 51 04          	cmp    0x4(%r9),%edx
  65b802:	77 dc                	ja     65b7e0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x370>
  65b804:	43 8b 74 3c f8       	mov    -0x8(%r12,%r15,1),%esi
  65b809:	80 7c 39 fd 00       	cmpb   $0x0,-0x3(%rcx,%rdi,1)
  65b80e:	74 11                	je     65b821 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3b1>
  65b810:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  65b816:	f3 0f 5c c1          	subss  %xmm1,%xmm0
  65b81a:	eb 0b                	jmp    65b827 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3b7>
  65b81c:	43 8b 74 3c f8       	mov    -0x8(%r12,%r15,1),%esi
  65b821:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  65b827:	3b 54 24 1c          	cmp    0x1c(%rsp),%edx
  65b82b:	0f 82 5f fd ff ff    	jb     65b590 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x120>
  65b831:	44 39 f6             	cmp    %r14d,%esi
  65b834:	0f 87 56 fd ff ff    	ja     65b590 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x120>
  65b83a:	0f 57 d2             	xorps  %xmm2,%xmm2
  65b83d:	0f 2e ca             	ucomiss %xmm2,%xmm1
  65b840:	75 06                	jne    65b848 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3d8>
  65b842:	0f 8b 48 fd ff ff    	jnp    65b590 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x120>
  65b848:	f3 42 0f 10 54 2b f4 	movss  -0xc(%rbx,%r13,1),%xmm2
  65b84f:	f6 44 24 28 01       	testb  $0x1,0x28(%rsp)
  65b854:	0f 84 d4 00 00 00    	je     65b92e <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4be>
  65b85a:	f3 0f 10 5c 24 08    	movss  0x8(%rsp),%xmm3
  65b860:	0f 2e df             	ucomiss %xmm7,%xmm3
  65b863:	75 74                	jne    65b8d9 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x469>
  65b865:	7a 72                	jp     65b8d9 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x469>
  65b867:	48 39 44 24 10       	cmp    %rax,0x10(%rsp)
  65b86c:	75 6b                	jne    65b8d9 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x469>
  65b86e:	f3 0f 10 5c 24 04    	movss  0x4(%rsp),%xmm3
  65b874:	0f 2e da             	ucomiss %xmm2,%xmm3
  65b877:	75 60                	jne    65b8d9 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x469>
  65b879:	7a 5e                	jp     65b8d9 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x469>
  65b87b:	0f 28 e0             	movaps %xmm0,%xmm4
  65b87e:	f3 0f 58 e1          	addss  %xmm1,%xmm4
  65b882:	0f 2e e6             	ucomiss %xmm6,%xmm4
  65b885:	72 4d                	jb     65b8d4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x464>
  65b887:	0f 28 dd             	movaps %xmm5,%xmm3
  65b88a:	f3 0f 58 de          	addss  %xmm6,%xmm3
  65b88e:	0f 2e d8             	ucomiss %xmm0,%xmm3
  65b891:	0f 83 b7 fc ff ff    	jae    65b54e <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xde>
  65b897:	eb 3b                	jmp    65b8d4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x464>
  65b899:	48 c7 84 24 80 00 00 	movq   $0x0,0x80(%rsp)
  65b8a0:	00 00 00 00 00
  65b8a5:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  65b8aa:	0f 29 6c 24 50       	movaps %xmm5,0x50(%rsp)
  65b8af:	0f 29 74 24 40       	movaps %xmm6,0x40(%rsp)
  65b8b4:	e8 77 02 00 00       	call   65bb30 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::Details>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator>::nth>
  65b8b9:	0f 28 74 24 40       	movaps 0x40(%rsp),%xmm6
  65b8be:	0f 28 6c 24 50       	movaps 0x50(%rsp),%xmm5
  65b8c3:	49 89 c4             	mov    %rax,%r12
  65b8c6:	4d 85 e4             	test   %r12,%r12
  65b8c9:	0f 85 ad fd ff ff    	jne    65b67c <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x20c>
  65b8cf:	e9 87 00 00 00       	jmp    65b95b <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4eb>
  65b8d4:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  65b8d9:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  65b8de:	48 c1 c2 07          	rol    $0x7,%rdx
  65b8e2:	66 0f 7e f1          	movd   %xmm6,%ecx
  65b8e6:	48 31 d1             	xor    %rdx,%rcx
  65b8e9:	48 c1 c1 07          	rol    $0x7,%rcx
  65b8ed:	66 0f 6e 5c 24 08    	movd   0x8(%rsp),%xmm3
  65b8f3:	66 0f 7e da          	movd   %xmm3,%edx
  65b8f7:	48 31 ca             	xor    %rcx,%rdx
  65b8fa:	48 c1 c2 07          	rol    $0x7,%rdx
  65b8fe:	66 0f 7e e9          	movd   %xmm5,%ecx
  65b902:	48 31 d1             	xor    %rdx,%rcx
  65b905:	48 c1 c1 07          	rol    $0x7,%rcx
  65b909:	66 0f 6e 5c 24 04    	movd   0x4(%rsp),%xmm3
  65b90f:	66 0f 7e da          	movd   %xmm3,%edx
  65b913:	48 31 ca             	xor    %rcx,%rdx
  65b916:	48 c1 c2 07          	rol    $0x7,%rdx
  65b91a:	8b 74 24 10          	mov    0x10(%rsp),%esi
  65b91e:	48 31 d6             	xor    %rdx,%rsi
  65b921:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  65b926:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  65b92b:	48 89 31             	mov    %rsi,(%rcx)
  65b92e:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  65b933:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  65b938:	b1 01                	mov    $0x1,%cl
  65b93a:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  65b93f:	48 85 c0             	test   %rax,%rax
  65b942:	0f 85 f2 fb ff ff    	jne    65b53a <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xca>
  65b948:	f3 0f 11 54 24 04    	movss  %xmm2,0x4(%rsp)
  65b94e:	f3 0f 11 7c 24 08    	movss  %xmm7,0x8(%rsp)
  65b954:	0f b6 44 24 03       	movzbl 0x3(%rsp),%eax
  65b959:	eb 12                	jmp    65b96d <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4fd>
  65b95b:	0f 28 cd             	movaps %xmm5,%xmm1
  65b95e:	0f 28 c6             	movaps %xmm6,%xmm0
  65b961:	f6 44 24 28 01       	testb  $0x1,0x28(%rsp)
  65b966:	0f b6 44 24 03       	movzbl 0x3(%rsp),%eax
  65b96b:	74 57                	je     65b9c4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x554>
  65b96d:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  65b972:	48 c1 c1 07          	rol    $0x7,%rcx
  65b976:	66 0f 7e c2          	movd   %xmm0,%edx
  65b97a:	48 31 ca             	xor    %rcx,%rdx
  65b97d:	48 c1 c2 07          	rol    $0x7,%rdx
  65b981:	66 0f 6e 44 24 08    	movd   0x8(%rsp),%xmm0
  65b987:	66 0f 7e c1          	movd   %xmm0,%ecx
  65b98b:	48 31 d1             	xor    %rdx,%rcx
  65b98e:	48 c1 c1 07          	rol    $0x7,%rcx
  65b992:	66 0f 7e ca          	movd   %xmm1,%edx
  65b996:	48 31 ca             	xor    %rcx,%rdx
  65b999:	48 c1 c2 07          	rol    $0x7,%rdx
  65b99d:	66 0f 6e 44 24 04    	movd   0x4(%rsp),%xmm0
  65b9a3:	66 0f 7e c1          	movd   %xmm0,%ecx
  65b9a7:	48 31 d1             	xor    %rdx,%rcx
  65b9aa:	48 c1 c1 07          	rol    $0x7,%rcx
  65b9ae:	8b 54 24 10          	mov    0x10(%rsp),%edx
  65b9b2:	48 31 ca             	xor    %rcx,%rdx
  65b9b5:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  65b9ba:	48 89 11             	mov    %rdx,(%rcx)
  65b9bd:	eb 05                	jmp    65b9c4 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x554>
  65b9bf:	0f b6 44 24 03       	movzbl 0x3(%rsp),%eax
  65b9c4:	48 81 c4 a8 00 00 00 	add    $0xa8,%rsp
  65b9cb:	5b                   	pop    %rbx
  65b9cc:	41 5c                	pop    %r12
  65b9ce:	41 5d                	pop    %r13
  65b9d0:	41 5e                	pop    %r14
  65b9d2:	41 5f                	pop    %r15
  65b9d4:	5d                   	pop    %rbp
  65b9d5:	c3                   	ret
  65b9d6:	48 8d 3d af 66 9c ff 	lea    -0x639951(%rip),%rdi        # 2208c <anon.255c12af0f8be736e5d332bcd13dbe27.0.llvm.11532299149726854919+0xcfc>
  65b9dd:	48 8d 15 bc b2 10 00 	lea    0x10b2bc(%rip),%rdx        # 766ca0 <anon.a48ffa9714aefd715eb9a00ca32a7bbf.2.llvm.7974572617015294607+0x30>
  65b9e4:	be 13 00 00 00       	mov    $0x13,%esi
  65b9e9:	ff 15 01 56 11 00    	call   *0x115601(%rip)        # 770ff0 <_DYNAMIC+0x340>
  65b9ef:	48 8d 3d 62 b2 10 00 	lea    0x10b262(%rip),%rdi        # 766c58 <anon.69ab5625bfb42ad4c39c151a08f96109.50.llvm.1353928436795425194+0x50>
  65b9f6:	ff 15 54 55 11 00    	call   *0x115554(%rip)        # 770f50 <_DYNAMIC+0x2a0>
  65b9fc:	cc                   	int3
  65b9fd:	cc                   	int3
  65b9fe:	cc                   	int3
  65b9ff:	cc                   	int3

000000000065da70 <<gpui_canvas::text::TextLayout>::move_visual>:
  65da70:	55                   	push   %rbp
  65da71:	41 57                	push   %r15
  65da73:	41 56                	push   %r14
  65da75:	41 55                	push   %r13
  65da77:	41 54                	push   %r12
  65da79:	53                   	push   %rbx
  65da7a:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  65da81:	89 d0                	mov    %edx,%eax
  65da83:	48 8b 5f 20          	mov    0x20(%rdi),%rbx
  65da87:	b2 02                	mov    $0x2,%dl
  65da89:	48 85 db             	test   %rbx,%rbx
  65da8c:	0f 84 4d 05 00 00    	je     65dfdf <<gpui_canvas::text::TextLayout>::move_visual+0x56f>
  65da92:	48 83 7b 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rbx)
  65da97:	0f 84 42 05 00 00    	je     65dfdf <<gpui_canvas::text::TextLayout>::move_visual+0x56f>
  65da9d:	4c 8b 4b 38          	mov    0x38(%rbx),%r9
  65daa1:	4c 8b 43 40          	mov    0x40(%rbx),%r8
  65daa5:	4d 89 c2             	mov    %r8,%r10
  65daa8:	4d 85 c0             	test   %r8,%r8
  65daab:	74 40                	je     65daed <<gpui_canvas::text::TextLayout>::move_visual+0x7d>
  65daad:	45 31 d2             	xor    %r10d,%r10d
  65dab0:	49 83 f8 01          	cmp    $0x1,%r8
  65dab4:	74 2a                	je     65dae0 <<gpui_canvas::text::TextLayout>::move_visual+0x70>
  65dab6:	4d 89 c3             	mov    %r8,%r11
  65dab9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  65dac0:	4d 89 de             	mov    %r11,%r14
  65dac3:	49 d1 ee             	shr    $1,%r14
  65dac6:	4f 8d 3c 16          	lea    (%r14,%r10,1),%r15
  65daca:	4f 8d 24 7f          	lea    (%r15,%r15,2),%r12
  65dace:	43 39 74 e1 10       	cmp    %esi,0x10(%r9,%r12,8)
  65dad3:	4d 0f 42 d7          	cmovb  %r15,%r10
  65dad7:	4d 29 f3             	sub    %r14,%r11
  65dada:	49 83 fb 01          	cmp    $0x1,%r11
  65dade:	77 e0                	ja     65dac0 <<gpui_canvas::text::TextLayout>::move_visual+0x50>
  65dae0:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  65dae4:	43 39 74 d9 10       	cmp    %esi,0x10(%r9,%r11,8)
  65dae9:	49 83 d2 00          	adc    $0x0,%r10
  65daed:	44 8d 58 01          	lea    0x1(%rax),%r11d
  65daf1:	49 c1 e2 03          	shl    $0x3,%r10
  65daf5:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  65daf9:	49 c1 e0 03          	shl    $0x3,%r8
  65dafd:	4f 8d 04 40          	lea    (%r8,%r8,2),%r8
  65db01:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  65db08:	0f 1f 84 00 00 00 00
  65db0f:	00
  65db10:	4d 39 f0             	cmp    %r14,%r8
  65db13:	0f 84 c6 04 00 00    	je     65dfdf <<gpui_canvas::text::TextLayout>::move_visual+0x56f>
  65db19:	43 39 74 31 10       	cmp    %esi,0x10(%r9,%r14,1)
  65db1e:	0f 85 bb 04 00 00    	jne    65dfdf <<gpui_canvas::text::TextLayout>::move_visual+0x56f>
  65db24:	4d 8d 56 18          	lea    0x18(%r14),%r10
  65db28:	47 84 5c 31 14       	test   %r11b,0x14(%r9,%r14,1)
  65db2d:	4d 89 d6             	mov    %r10,%r14
  65db30:	74 de                	je     65db10 <<gpui_canvas::text::TextLayout>::move_visual+0xa0>
  65db32:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  65db36:	4c 8b 43 28          	mov    0x28(%rbx),%r8
  65db3a:	4d 89 c6             	mov    %r8,%r14
  65db3d:	4d 85 c0             	test   %r8,%r8
  65db40:	74 5d                	je     65db9f <<gpui_canvas::text::TextLayout>::move_visual+0x12f>
  65db42:	f3 43 0f 10 44 11 ec 	movss  -0x14(%r9,%r10,1),%xmm0
  65db49:	45 31 db             	xor    %r11d,%r11d
  65db4c:	49 83 f8 01          	cmp    $0x1,%r8
  65db50:	74 31                	je     65db83 <<gpui_canvas::text::TextLayout>::move_visual+0x113>
  65db52:	4d 89 c6             	mov    %r8,%r14
  65db55:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  65db5c:	00 00 00 00
  65db60:	4d 89 df             	mov    %r11,%r15
  65db63:	4d 89 f4             	mov    %r14,%r12
  65db66:	49 d1 ec             	shr    $1,%r12
  65db69:	4d 01 e3             	add    %r12,%r11
  65db6c:	4f 8d 2c 5b          	lea    (%r11,%r11,2),%r13
  65db70:	42 0f 2e 44 ea 08    	ucomiss 0x8(%rdx,%r13,8),%xmm0
  65db76:	4d 0f 42 df          	cmovb  %r15,%r11
  65db7a:	4d 29 e6             	sub    %r12,%r14
  65db7d:	49 83 fe 01          	cmp    $0x1,%r14
  65db81:	77 dd                	ja     65db60 <<gpui_canvas::text::TextLayout>::move_visual+0xf0>
  65db83:	4f 8d 3c 5b          	lea    (%r11,%r11,2),%r15
  65db87:	45 31 f6             	xor    %r14d,%r14d
  65db8a:	42 0f 2e 44 fa 08    	ucomiss 0x8(%rdx,%r15,8),%xmm0
  65db90:	41 0f 93 c6          	setae  %r14b
  65db94:	4d 01 de             	add    %r11,%r14
  65db97:	49 83 fe 01          	cmp    $0x1,%r14
  65db9b:	49 83 d6 ff          	adc    $0xffffffffffffffff,%r14
  65db9f:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  65dba4:	89 74 24 10          	mov    %esi,0x10(%rsp)
  65dba8:	89 4c 24 04          	mov    %ecx,0x4(%rsp)
  65dbac:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  65dbb1:	f3 43 0f 10 44 11 e8 	movss  -0x18(%r9,%r10,1),%xmm0
  65dbb8:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  65dbbe:	4c 89 74 24 28       	mov    %r14,0x28(%rsp)
  65dbc3:	4d 39 c6             	cmp    %r8,%r14
  65dbc6:	0f 83 ec 04 00 00    	jae    65e0b8 <<gpui_canvas::text::TextLayout>::move_visual+0x648>
  65dbcc:	4b 8d 04 76          	lea    (%r14,%r14,2),%rax
  65dbd0:	8b 34 c2             	mov    (%rdx,%rax,8),%esi
  65dbd3:	8b 54 c2 04          	mov    0x4(%rdx,%rax,8),%edx
  65dbd7:	48 89 df             	mov    %rbx,%rdi
  65dbda:	b9 01 00 00 00       	mov    $0x1,%ecx
  65dbdf:	ff 15 33 34 11 00    	call   *0x113433(%rip)        # 771018 <_DYNAMIC+0x368>
  65dbe5:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  65dbea:	f3 0f 10 47 34       	movss  0x34(%rdi),%xmm0
  65dbef:	f3 0f 59 05 29 c5 9b 	mulss  -0x643ad7(%rip),%xmm0        # 1a120 <GCC_except_table0+0x84>
  65dbf6:	ff
  65dbf7:	48 89 d1             	mov    %rdx,%rcx
  65dbfa:	0f 57 c9             	xorps  %xmm1,%xmm1
  65dbfd:	0f 11 4c 24 58       	movups %xmm1,0x58(%rsp)
  65dc02:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  65dc07:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  65dc0c:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  65dc11:	48 c7 44 24 50 01 00 	movq   $0x1,0x50(%rsp)
  65dc18:	00 00
  65dc1a:	48 89 5c 24 68       	mov    %rbx,0x68(%rsp)
  65dc1f:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  65dc25:	48 8d 54 24 28       	lea    0x28(%rsp),%rdx
  65dc2a:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
  65dc2f:	48 85 c9             	test   %rcx,%rcx
  65dc32:	0f 84 ef 03 00 00    	je     65e027 <<gpui_canvas::text::TextLayout>::move_visual+0x5b7>
  65dc38:	f3 0f 10 2d 0c c5 9b 	movss  -0x643af4(%rip),%xmm5        # 1a14c <GCC_except_table0+0xb0>
  65dc3f:	ff
  65dc40:	b2 02                	mov    $0x2,%dl
  65dc42:	49 89 db             	mov    %rbx,%r11
  65dc45:	48 89 ce             	mov    %rcx,%rsi
  65dc48:	48 89 9c 24 80 00 00 	mov    %rbx,0x80(%rsp)
  65dc4f:	00
  65dc50:	eb 1c                	jmp    65dc6e <<gpui_canvas::text::TextLayout>::move_visual+0x1fe>
  65dc52:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  65dc59:	1f 84 00 00 00 00 00
  65dc60:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  65dc65:	48 85 f6             	test   %rsi,%rsi
  65dc68:	0f 84 83 03 00 00    	je     65dff1 <<gpui_canvas::text::TextLayout>::move_visual+0x581>
  65dc6e:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
  65dc73:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  65dc79:	48 83 fe 01          	cmp    $0x1,%rsi
  65dc7d:	74 2a                	je     65dca9 <<gpui_canvas::text::TextLayout>::move_visual+0x239>
  65dc7f:	4d 8d 4e 28          	lea    0x28(%r14),%r9
  65dc83:	4c 8d 56 01          	lea    0x1(%rsi),%r10
  65dc87:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  65dc8e:	00 00
  65dc90:	45 8b 41 e8          	mov    -0x18(%r9),%r8d
  65dc94:	45 3b 01             	cmp    (%r9),%r8d
  65dc97:	75 10                	jne    65dca9 <<gpui_canvas::text::TextLayout>::move_visual+0x239>
  65dc99:	49 ff c4             	inc    %r12
  65dc9c:	49 83 c1 18          	add    $0x18,%r9
  65dca0:	49 ff ca             	dec    %r10
  65dca3:	49 83 fa 02          	cmp    $0x2,%r10
  65dca7:	77 e7                	ja     65dc90 <<gpui_canvas::text::TextLayout>::move_visual+0x220>
  65dca9:	4c 29 e6             	sub    %r12,%rsi
  65dcac:	0f 82 ce 03 00 00    	jb     65e080 <<gpui_canvas::text::TextLayout>::move_visual+0x610>
  65dcb2:	4f 8d 04 64          	lea    (%r12,%r12,2),%r8
  65dcb6:	4f 8d 04 c6          	lea    (%r14,%r8,8),%r8
  65dcba:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  65dcbf:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  65dcc4:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  65dcc9:	48 85 f6             	test   %rsi,%rsi
  65dccc:	0f 85 84 02 00 00    	jne    65df56 <<gpui_canvas::text::TextLayout>::move_visual+0x4e6>
  65dcd2:	49 89 c9             	mov    %rcx,%r9
  65dcd5:	48 83 f9 01          	cmp    $0x1,%rcx
  65dcd9:	74 3e                	je     65dd19 <<gpui_canvas::text::TextLayout>::move_visual+0x2a9>
  65dcdb:	48 85 c9             	test   %rcx,%rcx
  65dcde:	0f 84 0d 03 00 00    	je     65dff1 <<gpui_canvas::text::TextLayout>::move_visual+0x581>
  65dce4:	48 8d 70 28          	lea    0x28(%rax),%rsi
  65dce8:	4c 8d 51 01          	lea    0x1(%rcx),%r10
  65dcec:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  65dcf2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  65dcf9:	1f 84 00 00 00 00 00
  65dd00:	44 8b 46 e8          	mov    -0x18(%rsi),%r8d
  65dd04:	44 3b 06             	cmp    (%rsi),%r8d
  65dd07:	75 10                	jne    65dd19 <<gpui_canvas::text::TextLayout>::move_visual+0x2a9>
  65dd09:	49 ff c1             	inc    %r9
  65dd0c:	48 83 c6 18          	add    $0x18,%rsi
  65dd10:	49 ff ca             	dec    %r10
  65dd13:	49 83 fa 02          	cmp    $0x2,%r10
  65dd17:	77 e7                	ja     65dd00 <<gpui_canvas::text::TextLayout>::move_visual+0x290>
  65dd19:	4c 29 c9             	sub    %r9,%rcx
  65dd1c:	0f 82 5e 03 00 00    	jb     65e080 <<gpui_canvas::text::TextLayout>::move_visual+0x610>
  65dd22:	4b 8d 34 49          	lea    (%r9,%r9,2),%rsi
  65dd26:	4c 8d 04 f0          	lea    (%rax,%rsi,8),%r8
  65dd2a:	48 89 c6             	mov    %rax,%rsi
  65dd2d:	4c 89 c0             	mov    %r8,%rax
  65dd30:	4c 89 44 24 40       	mov    %r8,0x40(%rsp)
  65dd35:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
  65dd3a:	49 c1 e4 03          	shl    $0x3,%r12
  65dd3e:	4f 8d 04 64          	lea    (%r12,%r12,2),%r8
  65dd42:	45 31 d2             	xor    %r10d,%r10d
  65dd45:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  65dd4c:	00 00 00 00
  65dd50:	4d 39 d0             	cmp    %r10,%r8
  65dd53:	0f 84 07 ff ff ff    	je     65dc60 <<gpui_canvas::text::TextLayout>::move_visual+0x1f0>
  65dd59:	4d 8d 62 18          	lea    0x18(%r10),%r12
  65dd5d:	43 f6 44 16 14 02    	testb  $0x2,0x14(%r14,%r10,1)
  65dd63:	4d 89 e2             	mov    %r12,%r10
  65dd66:	74 e8                	je     65dd50 <<gpui_canvas::text::TextLayout>::move_visual+0x2e0>
  65dd68:	49 c1 e1 03          	shl    $0x3,%r9
  65dd6c:	4f 8d 04 49          	lea    (%r9,%r9,2),%r8
  65dd70:	45 31 d2             	xor    %r10d,%r10d
  65dd73:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  65dd7a:	84 00 00 00 00 00
  65dd80:	4d 39 d0             	cmp    %r10,%r8
  65dd83:	0f 84 d7 fe ff ff    	je     65dc60 <<gpui_canvas::text::TextLayout>::move_visual+0x1f0>
  65dd89:	4d 8d 4a 18          	lea    0x18(%r10),%r9
  65dd8d:	42 f6 44 16 14 01    	testb  $0x1,0x14(%rsi,%r10,1)
  65dd93:	4d 89 ca             	mov    %r9,%r10
  65dd96:	74 e8                	je     65dd80 <<gpui_canvas::text::TextLayout>::move_visual+0x310>
  65dd98:	f3 43 0f 10 44 26 ec 	movss  -0x14(%r14,%r12,1),%xmm0
  65dd9f:	49 8b 7b 28          	mov    0x28(%r11),%rdi
  65dda3:	48 85 ff             	test   %rdi,%rdi
  65dda6:	74 69                	je     65de11 <<gpui_canvas::text::TextLayout>::move_visual+0x3a1>
  65dda8:	4d 8b 6b 20          	mov    0x20(%r11),%r13
  65ddac:	45 31 ff             	xor    %r15d,%r15d
  65ddaf:	48 83 ff 01          	cmp    $0x1,%rdi
  65ddb3:	74 2e                	je     65dde3 <<gpui_canvas::text::TextLayout>::move_visual+0x373>
  65ddb5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  65ddbc:	00 00 00 00
  65ddc0:	4d 89 f8             	mov    %r15,%r8
  65ddc3:	49 89 fa             	mov    %rdi,%r10
  65ddc6:	49 d1 ea             	shr    $1,%r10
  65ddc9:	4d 01 d7             	add    %r10,%r15
  65ddcc:	4b 8d 2c 7f          	lea    (%r15,%r15,2),%rbp
  65ddd0:	41 0f 2e 44 ed 08    	ucomiss 0x8(%r13,%rbp,8),%xmm0
  65ddd6:	4d 0f 42 f8          	cmovb  %r8,%r15
  65ddda:	4c 29 d7             	sub    %r10,%rdi
  65dddd:	48 83 ff 01          	cmp    $0x1,%rdi
  65dde1:	77 dd                	ja     65ddc0 <<gpui_canvas::text::TextLayout>::move_visual+0x350>
  65dde3:	4c 89 db             	mov    %r11,%rbx
  65dde6:	4f 8d 04 7f          	lea    (%r15,%r15,2),%r8
  65ddea:	31 ff                	xor    %edi,%edi
  65ddec:	43 0f 2e 44 c5 08    	ucomiss 0x8(%r13,%r8,8),%xmm0
  65ddf2:	40 0f 93 c7          	setae  %dil
  65ddf6:	4c 01 ff             	add    %r15,%rdi
  65ddf9:	48 83 ff 01          	cmp    $0x1,%rdi
  65ddfd:	48 83 d7 ff          	adc    $0xffffffffffffffff,%rdi
  65de01:	f3 42 0f 10 4c 0e ec 	movss  -0x14(%rsi,%r9,1),%xmm1
  65de08:	0f 2e c1             	ucomiss %xmm1,%xmm0
  65de0b:	75 15                	jne    65de22 <<gpui_canvas::text::TextLayout>::move_visual+0x3b2>
  65de0d:	7a 13                	jp     65de22 <<gpui_canvas::text::TextLayout>::move_visual+0x3b2>
  65de0f:	eb 59                	jmp    65de6a <<gpui_canvas::text::TextLayout>::move_visual+0x3fa>
  65de11:	4c 89 db             	mov    %r11,%rbx
  65de14:	f3 42 0f 10 4c 0e ec 	movss  -0x14(%rsi,%r9,1),%xmm1
  65de1b:	0f 2e c1             	ucomiss %xmm1,%xmm0
  65de1e:	75 02                	jne    65de22 <<gpui_canvas::text::TextLayout>::move_visual+0x3b2>
  65de20:	7b 48                	jnp    65de6a <<gpui_canvas::text::TextLayout>::move_visual+0x3fa>
  65de22:	4c 8b 6b 10          	mov    0x10(%rbx),%r13
  65de26:	49 83 fd 02          	cmp    $0x2,%r13
  65de2a:	72 3e                	jb     65de6a <<gpui_canvas::text::TextLayout>::move_visual+0x3fa>
  65de2c:	4c 8b 7b 08          	mov    0x8(%rbx),%r15
  65de30:	45 31 c0             	xor    %r8d,%r8d
  65de33:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  65de3a:	84 00 00 00 00 00
  65de40:	4d 89 ea             	mov    %r13,%r10
  65de43:	49 d1 ea             	shr    $1,%r10
  65de46:	4b 8d 2c 02          	lea    (%r10,%r8,1),%rbp
  65de4a:	4c 8d 1c 6d 00 00 00 	lea    0x0(,%rbp,2),%r11
  65de51:	00
  65de52:	49 01 eb             	add    %rbp,%r11
  65de55:	47 8b 5c df 10       	mov    0x10(%r15,%r11,8),%r11d
  65de5a:	4c 39 df             	cmp    %r11,%rdi
  65de5d:	4c 0f 47 c5          	cmova  %rbp,%r8
  65de61:	4d 29 d5             	sub    %r10,%r13
  65de64:	49 83 fd 01          	cmp    $0x1,%r13
  65de68:	77 d6                	ja     65de40 <<gpui_canvas::text::TextLayout>::move_visual+0x3d0>
  65de6a:	0f 2e c1             	ucomiss %xmm1,%xmm0
  65de6d:	49 89 db             	mov    %rbx,%r11
  65de70:	48 8b 9c 24 80 00 00 	mov    0x80(%rsp),%rbx
  65de77:	00
  65de78:	0f 85 e2 fd ff ff    	jne    65dc60 <<gpui_canvas::text::TextLayout>::move_visual+0x1f0>
  65de7e:	0f 8a dc fd ff ff    	jp     65dc60 <<gpui_canvas::text::TextLayout>::move_visual+0x1f0>
  65de84:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
  65de89:	49 3b 38             	cmp    (%r8),%rdi
  65de8c:	0f 85 ce fd ff ff    	jne    65dc60 <<gpui_canvas::text::TextLayout>::move_visual+0x1f0>
  65de92:	f3 42 0f 10 4c 0e e8 	movss  -0x18(%rsi,%r9,1),%xmm1
  65de99:	f3 43 0f 10 54 26 e8 	movss  -0x18(%r14,%r12,1),%xmm2
  65dea0:	44 8b 54 24 04       	mov    0x4(%rsp),%r10d
  65dea5:	45 84 d2             	test   %r10b,%r10b
  65dea8:	74 23                	je     65decd <<gpui_canvas::text::TextLayout>::move_visual+0x45d>
  65deaa:	0f 28 da             	movaps %xmm2,%xmm3
  65dead:	f3 0f 5f d9          	maxss  %xmm1,%xmm3
  65deb1:	0f 28 c3             	movaps %xmm3,%xmm0
  65deb4:	f3 0f c2 c3 03       	cmpunordss %xmm3,%xmm0
  65deb9:	0f 28 e0             	movaps %xmm0,%xmm4
  65debc:	0f 55 e3             	andnps %xmm3,%xmm4
  65debf:	0f 54 c2             	andps  %xmm2,%xmm0
  65dec2:	0f 56 c4             	orps   %xmm4,%xmm0
  65dec5:	f3 0f 5c 44 24 0c    	subss  0xc(%rsp),%xmm0
  65decb:	eb 25                	jmp    65def2 <<gpui_canvas::text::TextLayout>::move_visual+0x482>
  65decd:	0f 28 c2             	movaps %xmm2,%xmm0
  65ded0:	f3 0f 5d c1          	minss  %xmm1,%xmm0
  65ded4:	0f 28 d8             	movaps %xmm0,%xmm3
  65ded7:	f3 0f c2 d8 03       	cmpunordss %xmm0,%xmm3
  65dedc:	0f 28 e3             	movaps %xmm3,%xmm4
  65dedf:	0f 55 e0             	andnps %xmm0,%xmm4
  65dee2:	0f 54 da             	andps  %xmm2,%xmm3
  65dee5:	0f 56 dc             	orps   %xmm4,%xmm3
  65dee8:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
  65deee:	f3 0f 5c c3          	subss  %xmm3,%xmm0
  65def2:	42 8b 74 0e f8       	mov    -0x8(%rsi,%r9,1),%esi
  65def7:	0f 28 d8             	movaps %xmm0,%xmm3
  65defa:	f3 0f c2 dd 01       	cmpltss %xmm5,%xmm3
  65deff:	0f 57 e4             	xorps  %xmm4,%xmm4
  65df02:	f3 0f c2 e0 01       	cmpltss %xmm0,%xmm4
  65df07:	0f 2e ca             	ucomiss %xmm2,%xmm1
  65df0a:	41 0f 96 c0          	setbe  %r8b
  65df0e:	45 30 d0             	xor    %r10b,%r8b
  65df11:	43 0f 44 74 26 f8    	cmove  -0x8(%r14,%r12,1),%esi
  65df17:	0f 54 e3             	andps  %xmm3,%xmm4
  65df1a:	66 0f 7e e7          	movd   %xmm4,%edi
  65df1e:	41 80 f0 01          	xor    $0x1,%r8b
  65df22:	40 f6 c7 01          	test   $0x1,%dil
  65df26:	75 03                	jne    65df2b <<gpui_canvas::text::TextLayout>::move_visual+0x4bb>
  65df28:	0f 28 c5             	movaps %xmm5,%xmm0
  65df2b:	41 0f b6 f8          	movzbl %r8b,%edi
  65df2f:	0f b6 d2             	movzbl %dl,%edx
  65df32:	0f 45 d7             	cmovne %edi,%edx
  65df35:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  65df39:	0f 45 fe             	cmovne %esi,%edi
  65df3c:	89 7c 24 08          	mov    %edi,0x8(%rsp)
  65df40:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  65df45:	0f 28 e8             	movaps %xmm0,%xmm5
  65df48:	48 85 f6             	test   %rsi,%rsi
  65df4b:	0f 85 1d fd ff ff    	jne    65dc6e <<gpui_canvas::text::TextLayout>::move_visual+0x1fe>
  65df51:	e9 a0 00 00 00       	jmp    65dff6 <<gpui_canvas::text::TextLayout>::move_visual+0x586>
  65df56:	f3 0f 11 6c 24 14    	movss  %xmm5,0x14(%rsp)
  65df5c:	41 89 d7             	mov    %edx,%r15d
  65df5f:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  65df66:	00 00
  65df68:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  65df6d:	e8 ee c6 00 00       	call   66a660 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::Details>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>
  65df72:	48 85 c0             	test   %rax,%rax
  65df75:	0f 85 1e 01 00 00    	jne    65e099 <<gpui_canvas::text::TextLayout>::move_visual+0x629>
  65df7b:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  65df80:	48 85 c9             	test   %rcx,%rcx
  65df83:	0f 84 10 01 00 00    	je     65e099 <<gpui_canvas::text::TextLayout>::move_visual+0x629>
  65df89:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  65df8e:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  65df94:	48 83 f9 01          	cmp    $0x1,%rcx
  65df98:	44 89 fa             	mov    %r15d,%edx
  65df9b:	f3 0f 10 6c 24 14    	movss  0x14(%rsp),%xmm5
  65dfa1:	74 21                	je     65dfc4 <<gpui_canvas::text::TextLayout>::move_visual+0x554>
  65dfa3:	48 8d 46 28          	lea    0x28(%rsi),%rax
  65dfa7:	4c 8d 51 01          	lea    0x1(%rcx),%r10
  65dfab:	44 8b 40 e8          	mov    -0x18(%rax),%r8d
  65dfaf:	44 3b 00             	cmp    (%rax),%r8d
  65dfb2:	75 10                	jne    65dfc4 <<gpui_canvas::text::TextLayout>::move_visual+0x554>
  65dfb4:	49 ff c1             	inc    %r9
  65dfb7:	48 83 c0 18          	add    $0x18,%rax
  65dfbb:	49 ff ca             	dec    %r10
  65dfbe:	49 83 fa 02          	cmp    $0x2,%r10
  65dfc2:	77 e7                	ja     65dfab <<gpui_canvas::text::TextLayout>::move_visual+0x53b>
  65dfc4:	4c 29 c9             	sub    %r9,%rcx
  65dfc7:	0f 82 b3 00 00 00    	jb     65e080 <<gpui_canvas::text::TextLayout>::move_visual+0x610>
  65dfcd:	4b 8d 04 49          	lea    (%r9,%r9,2),%rax
  65dfd1:	4c 8d 04 c6          	lea    (%rsi,%rax,8),%r8
  65dfd5:	4c 8b 5c 24 68       	mov    0x68(%rsp),%r11
  65dfda:	e9 4e fd ff ff       	jmp    65dd2d <<gpui_canvas::text::TextLayout>::move_visual+0x2bd>
  65dfdf:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  65dfe6:	5b                   	pop    %rbx
  65dfe7:	41 5c                	pop    %r12
  65dfe9:	41 5d                	pop    %r13
  65dfeb:	41 5e                	pop    %r14
  65dfed:	41 5f                	pop    %r15
  65dfef:	5d                   	pop    %rbp
  65dff0:	c3                   	ret
  65dff1:	44 8b 54 24 04       	mov    0x4(%rsp),%r10d
  65dff6:	80 fa 02             	cmp    $0x2,%dl
  65dff9:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  65dffe:	8b 44 24 08          	mov    0x8(%rsp),%eax
  65e002:	75 db                	jne    65dfdf <<gpui_canvas::text::TextLayout>::move_visual+0x56f>
  65e004:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
  65e009:	8b 44 24 10          	mov    0x10(%rsp),%eax
  65e00d:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  65e012:	45 84 d2             	test   %r10b,%r10b
  65e015:	75 23                	jne    65e03a <<gpui_canvas::text::TextLayout>::move_visual+0x5ca>
  65e017:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  65e01e:	4d 85 f6             	test   %r14,%r14
  65e021:	75 22                	jne    65e045 <<gpui_canvas::text::TextLayout>::move_visual+0x5d5>
  65e023:	89 ca                	mov    %ecx,%edx
  65e025:	eb b8                	jmp    65dfdf <<gpui_canvas::text::TextLayout>::move_visual+0x56f>
  65e027:	44 8b 54 24 04       	mov    0x4(%rsp),%r10d
  65e02c:	8b 44 24 10          	mov    0x10(%rsp),%eax
  65e030:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  65e035:	45 84 d2             	test   %r10b,%r10b
  65e038:	74 dd                	je     65e017 <<gpui_canvas::text::TextLayout>::move_visual+0x5a7>
  65e03a:	be 01 00 00 00       	mov    $0x1,%esi
  65e03f:	49 83 fe ff          	cmp    $0xffffffffffffffff,%r14
  65e043:	74 de                	je     65e023 <<gpui_canvas::text::TextLayout>::move_visual+0x5b3>
  65e045:	4c 01 f6             	add    %r14,%rsi
  65e048:	89 ca                	mov    %ecx,%edx
  65e04a:	48 3b 73 28          	cmp    0x28(%rbx),%rsi
  65e04e:	73 8f                	jae    65dfdf <<gpui_canvas::text::TextLayout>::move_visual+0x56f>
  65e050:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  65e054:	48 8d 04 76          	lea    (%rsi,%rsi,2),%rax
  65e058:	45 84 d2             	test   %r10b,%r10b
  65e05b:	75 0a                	jne    65e067 <<gpui_canvas::text::TextLayout>::move_visual+0x5f7>
  65e05d:	f3 0f 10 05 df c0 9b 	movss  -0x643f21(%rip),%xmm0        # 1a144 <GCC_except_table0+0xa8>
  65e064:	ff
  65e065:	eb 08                	jmp    65e06f <<gpui_canvas::text::TextLayout>::move_visual+0x5ff>
  65e067:	f3 0f 10 05 e9 c0 9b 	movss  -0x643f17(%rip),%xmm0        # 1a158 <GCC_except_table0+0xbc>
  65e06e:	ff
  65e06f:	f3 0f 10 4c c1 08    	movss  0x8(%rcx,%rax,8),%xmm1
  65e075:	ff 15 cd 2e 11 00    	call   *0x112ecd(%rip)        # 770f48 <_DYNAMIC+0x298>
  65e07b:	e9 5f ff ff ff       	jmp    65dfdf <<gpui_canvas::text::TextLayout>::move_visual+0x56f>
  65e080:	48 8d 3d 35 99 bf ff 	lea    -0x4066cb(%rip),%rdi        # 2579bc <gpui_canvas::text::PRIMARY_BYTES+0x1f4448>
  65e087:	48 8d 15 2a 8c 10 00 	lea    0x108c2a(%rip),%rdx        # 766cb8 <anon.a48ffa9714aefd715eb9a00ca32a7bbf.2.llvm.7974572617015294607+0x48>
  65e08e:	be 13 00 00 00       	mov    $0x13,%esi
  65e093:	ff 15 57 2f 11 00    	call   *0x112f57(%rip)        # 770ff0 <_DYNAMIC+0x340>
  65e099:	44 8b 54 24 04       	mov    0x4(%rsp),%r10d
  65e09e:	44 89 fa             	mov    %r15d,%edx
  65e0a1:	80 fa 02             	cmp    $0x2,%dl
  65e0a4:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  65e0a9:	8b 44 24 08          	mov    0x8(%rsp),%eax
  65e0ad:	0f 84 51 ff ff ff    	je     65e004 <<gpui_canvas::text::TextLayout>::move_visual+0x594>
  65e0b3:	e9 27 ff ff ff       	jmp    65dfdf <<gpui_canvas::text::TextLayout>::move_visual+0x56f>
  65e0b8:	48 8d 15 f1 93 10 00 	lea    0x1093f1(%rip),%rdx        # 7674b0 <anon.ff15d46c50634a99bf0be9a017bc6eb6.36.llvm.14034193257400015495>
  65e0bf:	4c 89 f7             	mov    %r14,%rdi
  65e0c2:	4c 89 c6             	mov    %r8,%rsi
  65e0c5:	ff 15 d5 2f 11 00    	call   *0x112fd5(%rip)        # 7710a0 <_DYNAMIC+0x3f0>
  65e0cb:	cc                   	int3
  65e0cc:	cc                   	int3
  65e0cd:	cc                   	int3
  65e0ce:	cc                   	int3
  65e0cf:	cc                   	int3

000000000065e0d0 <<gpui_canvas::text::TextLayout>::position_at>:
  65e0d0:	55                   	push   %rbp
  65e0d1:	41 57                	push   %r15
  65e0d3:	41 56                	push   %r14
  65e0d5:	41 55                	push   %r13
  65e0d7:	41 54                	push   %r12
  65e0d9:	53                   	push   %rbx
  65e0da:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  65e0e1:	66 0f 7e c8          	movd   %xmm1,%eax
  65e0e5:	66 0f 7e c1          	movd   %xmm0,%ecx
  65e0e9:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  65e0ef:	81 f9 00 00 80 7f    	cmp    $0x7f800000,%ecx
  65e0f5:	0f 9d c1             	setge  %cl
  65e0f8:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  65e0fd:	3d 00 00 80 7f       	cmp    $0x7f800000,%eax
  65e102:	0f 9d c0             	setge  %al
  65e105:	08 c8                	or     %cl,%al
  65e107:	b2 02                	mov    $0x2,%dl
  65e109:	0f 85 b1 05 00 00    	jne    65e6c0 <<gpui_canvas::text::TextLayout>::position_at+0x5f0>
  65e10f:	4c 8b 5f 20          	mov    0x20(%rdi),%r11
  65e113:	4d 85 db             	test   %r11,%r11
  65e116:	0f 84 a4 05 00 00    	je     65e6c0 <<gpui_canvas::text::TextLayout>::position_at+0x5f0>
  65e11c:	49 83 7b 30 ff       	cmpq   $0xffffffffffffffff,0x30(%r11)
  65e121:	0f 84 99 05 00 00    	je     65e6c0 <<gpui_canvas::text::TextLayout>::position_at+0x5f0>
  65e127:	49 8b 43 20          	mov    0x20(%r11),%rax
  65e12b:	49 8b 73 28          	mov    0x28(%r11),%rsi
  65e12f:	49 89 f7             	mov    %rsi,%r15
  65e132:	48 85 f6             	test   %rsi,%rsi
  65e135:	74 57                	je     65e18e <<gpui_canvas::text::TextLayout>::position_at+0xbe>
  65e137:	31 c9                	xor    %ecx,%ecx
  65e139:	48 83 fe 01          	cmp    $0x1,%rsi
  65e13d:	74 34                	je     65e173 <<gpui_canvas::text::TextLayout>::position_at+0xa3>
  65e13f:	48 89 f2             	mov    %rsi,%rdx
  65e142:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  65e149:	1f 84 00 00 00 00 00
  65e150:	49 89 c8             	mov    %rcx,%r8
  65e153:	49 89 d1             	mov    %rdx,%r9
  65e156:	49 d1 e9             	shr    $1,%r9
  65e159:	4c 01 c9             	add    %r9,%rcx
  65e15c:	4c 8d 14 49          	lea    (%rcx,%rcx,2),%r10
  65e160:	42 0f 2e 4c d0 08    	ucomiss 0x8(%rax,%r10,8),%xmm1
  65e166:	49 0f 42 c8          	cmovb  %r8,%rcx
  65e16a:	4c 29 ca             	sub    %r9,%rdx
  65e16d:	48 83 fa 01          	cmp    $0x1,%rdx
  65e171:	77 dd                	ja     65e150 <<gpui_canvas::text::TextLayout>::position_at+0x80>
  65e173:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
  65e177:	45 31 ff             	xor    %r15d,%r15d
  65e17a:	0f 2e 4c d0 08       	ucomiss 0x8(%rax,%rdx,8),%xmm1
  65e17f:	41 0f 93 c7          	setae  %r15b
  65e183:	49 01 cf             	add    %rcx,%r15
  65e186:	49 83 ff 01          	cmp    $0x1,%r15
  65e18a:	49 83 d7 ff          	adc    $0xffffffffffffffff,%r15
  65e18e:	66 0f 7e 44 24 2c    	movd   %xmm0,0x2c(%rsp)
  65e194:	4c 89 7c 24 38       	mov    %r15,0x38(%rsp)
  65e199:	49 39 f7             	cmp    %rsi,%r15
  65e19c:	0f 83 f1 05 00 00    	jae    65e793 <<gpui_canvas::text::TextLayout>::position_at+0x6c3>
  65e1a2:	49 89 fe             	mov    %rdi,%r14
  65e1a5:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  65e1a9:	8b 34 c8             	mov    (%rax,%rcx,8),%esi
  65e1ac:	8b 54 c8 04          	mov    0x4(%rax,%rcx,8),%edx
  65e1b0:	4c 89 df             	mov    %r11,%rdi
  65e1b3:	b9 01 00 00 00       	mov    $0x1,%ecx
  65e1b8:	4c 89 5c 24 10       	mov    %r11,0x10(%rsp)
  65e1bd:	ff 15 55 2e 11 00    	call   *0x112e55(%rip)        # 771018 <_DYNAMIC+0x368>
  65e1c3:	4c 8b 5c 24 10       	mov    0x10(%rsp),%r11
  65e1c8:	f3 41 0f 10 46 34    	movss  0x34(%r14),%xmm0
  65e1ce:	f3 0f 59 05 4a bf 9b 	mulss  -0x6440b6(%rip),%xmm0        # 1a120 <GCC_except_table0+0x84>
  65e1d5:	ff
  65e1d6:	0f 57 c9             	xorps  %xmm1,%xmm1
  65e1d9:	0f 11 4c 24 68       	movups %xmm1,0x68(%rsp)
  65e1de:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  65e1e3:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  65e1e8:	48 89 54 24 58       	mov    %rdx,0x58(%rsp)
  65e1ed:	48 c7 44 24 60 01 00 	movq   $0x1,0x60(%rsp)
  65e1f4:	00 00
  65e1f6:	4c 89 5c 24 78       	mov    %r11,0x78(%rsp)
  65e1fb:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  65e202:	00 00
  65e204:	48 8d 4c 24 38       	lea    0x38(%rsp),%rcx
  65e209:	48 89 8c 24 88 00 00 	mov    %rcx,0x88(%rsp)
  65e210:	00
  65e211:	48 85 d2             	test   %rdx,%rdx
  65e214:	0f 84 15 04 00 00    	je     65e62f <<gpui_canvas::text::TextLayout>::position_at+0x55f>
  65e21a:	40 b7 02             	mov    $0x2,%dil
  65e21d:	4d 89 de             	mov    %r11,%r14
  65e220:	49 89 c0             	mov    %rax,%r8
  65e223:	48 89 d1             	mov    %rdx,%rcx
  65e226:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  65e22d:	00
  65e22e:	49 89 d2             	mov    %rdx,%r10
  65e231:	b2 02                	mov    $0x2,%dl
  65e233:	40 88 7c 24 0b       	mov    %dil,0xb(%rsp)
  65e238:	eb 24                	jmp    65e25e <<gpui_canvas::text::TextLayout>::position_at+0x18e>
  65e23a:	48 8b b4 24 88 00 00 	mov    0x88(%rsp),%rsi
  65e241:	00
  65e242:	48 3b 2e             	cmp    (%rsi),%rbp
  65e245:	49 89 de             	mov    %rbx,%r14
  65e248:	0f 84 a5 02 00 00    	je     65e4f3 <<gpui_canvas::text::TextLayout>::position_at+0x423>
  65e24e:	66 90                	xchg   %ax,%ax
  65e250:	4c 8b 54 24 48       	mov    0x48(%rsp),%r10
  65e255:	4d 85 d2             	test   %r10,%r10
  65e258:	0f 84 9a 03 00 00    	je     65e5f8 <<gpui_canvas::text::TextLayout>::position_at+0x528>
  65e25e:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
  65e263:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  65e269:	49 83 fa 01          	cmp    $0x1,%r10
  65e26d:	74 2a                	je     65e299 <<gpui_canvas::text::TextLayout>::position_at+0x1c9>
  65e26f:	49 8d 77 28          	lea    0x28(%r15),%rsi
  65e273:	4d 8d 4a 01          	lea    0x1(%r10),%r9
  65e277:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  65e27e:	00 00
  65e280:	44 8b 5e e8          	mov    -0x18(%rsi),%r11d
  65e284:	44 3b 1e             	cmp    (%rsi),%r11d
  65e287:	75 10                	jne    65e299 <<gpui_canvas::text::TextLayout>::position_at+0x1c9>
  65e289:	49 ff c5             	inc    %r13
  65e28c:	48 83 c6 18          	add    $0x18,%rsi
  65e290:	49 ff c9             	dec    %r9
  65e293:	49 83 f9 02          	cmp    $0x2,%r9
  65e297:	77 e7                	ja     65e280 <<gpui_canvas::text::TextLayout>::position_at+0x1b0>
  65e299:	4d 29 ea             	sub    %r13,%r10
  65e29c:	0f 82 81 04 00 00    	jb     65e723 <<gpui_canvas::text::TextLayout>::position_at+0x653>
  65e2a2:	4a 8d 34 6d 00 00 00 	lea    0x0(,%r13,2),%rsi
  65e2a9:	00
  65e2aa:	4c 01 ee             	add    %r13,%rsi
  65e2ad:	49 8d 34 f7          	lea    (%r15,%rsi,8),%rsi
  65e2b1:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
  65e2b6:	4c 89 54 24 48       	mov    %r10,0x48(%rsp)
  65e2bb:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  65e2c0:	48 85 f6             	test   %rsi,%rsi
  65e2c3:	0f 85 95 01 00 00    	jne    65e45e <<gpui_canvas::text::TextLayout>::position_at+0x38e>
  65e2c9:	49 89 ca             	mov    %rcx,%r10
  65e2cc:	48 83 f9 01          	cmp    $0x1,%rcx
  65e2d0:	74 37                	je     65e309 <<gpui_canvas::text::TextLayout>::position_at+0x239>
  65e2d2:	48 85 c9             	test   %rcx,%rcx
  65e2d5:	0f 84 1d 03 00 00    	je     65e5f8 <<gpui_canvas::text::TextLayout>::position_at+0x528>
  65e2db:	49 8d 70 28          	lea    0x28(%r8),%rsi
  65e2df:	4c 8d 49 01          	lea    0x1(%rcx),%r9
  65e2e3:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  65e2e9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  65e2f0:	44 8b 5e e8          	mov    -0x18(%rsi),%r11d
  65e2f4:	44 3b 1e             	cmp    (%rsi),%r11d
  65e2f7:	75 10                	jne    65e309 <<gpui_canvas::text::TextLayout>::position_at+0x239>
  65e2f9:	49 ff c2             	inc    %r10
  65e2fc:	48 83 c6 18          	add    $0x18,%rsi
  65e300:	49 ff c9             	dec    %r9
  65e303:	49 83 f9 02          	cmp    $0x2,%r9
  65e307:	77 e7                	ja     65e2f0 <<gpui_canvas::text::TextLayout>::position_at+0x220>
  65e309:	4c 29 d1             	sub    %r10,%rcx
  65e30c:	0f 82 11 04 00 00    	jb     65e723 <<gpui_canvas::text::TextLayout>::position_at+0x653>
  65e312:	4b 8d 34 52          	lea    (%r10,%r10,2),%rsi
  65e316:	4d 8d 0c f0          	lea    (%r8,%rsi,8),%r9
  65e31a:	4c 89 c6             	mov    %r8,%rsi
  65e31d:	4d 89 c8             	mov    %r9,%r8
  65e320:	4c 89 4c 24 50       	mov    %r9,0x50(%rsp)
  65e325:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
  65e32a:	49 c1 e5 03          	shl    $0x3,%r13
  65e32e:	4e 8d 1c 6d 00 00 00 	lea    0x0(,%r13,2),%r11
  65e335:	00
  65e336:	4d 01 eb             	add    %r13,%r11
  65e339:	45 31 e4             	xor    %r12d,%r12d
  65e33c:	0f 1f 40 00          	nopl   0x0(%rax)
  65e340:	4d 39 e3             	cmp    %r12,%r11
  65e343:	0f 84 07 ff ff ff    	je     65e250 <<gpui_canvas::text::TextLayout>::position_at+0x180>
  65e349:	4d 8d 4c 24 18       	lea    0x18(%r12),%r9
  65e34e:	43 f6 44 27 14 02    	testb  $0x2,0x14(%r15,%r12,1)
  65e354:	4d 89 cc             	mov    %r9,%r12
  65e357:	74 e7                	je     65e340 <<gpui_canvas::text::TextLayout>::position_at+0x270>
  65e359:	49 c1 e2 03          	shl    $0x3,%r10
  65e35d:	4f 8d 14 52          	lea    (%r10,%r10,2),%r10
  65e361:	45 31 e4             	xor    %r12d,%r12d
  65e364:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  65e36b:	00 00 00 00 00
  65e370:	4d 39 e2             	cmp    %r12,%r10
  65e373:	0f 84 d7 fe ff ff    	je     65e250 <<gpui_canvas::text::TextLayout>::position_at+0x180>
  65e379:	4d 8d 5c 24 18       	lea    0x18(%r12),%r11
  65e37e:	42 f6 44 26 14 01    	testb  $0x1,0x14(%rsi,%r12,1)
  65e384:	4d 89 dc             	mov    %r11,%r12
  65e387:	74 e7                	je     65e370 <<gpui_canvas::text::TextLayout>::position_at+0x2a0>
  65e389:	f3 43 0f 10 44 0f ec 	movss  -0x14(%r15,%r9,1),%xmm0
  65e390:	49 8b 6e 28          	mov    0x28(%r14),%rbp
  65e394:	48 85 ed             	test   %rbp,%rbp
  65e397:	74 58                	je     65e3f1 <<gpui_canvas::text::TextLayout>::position_at+0x321>
  65e399:	4c 89 f3             	mov    %r14,%rbx
  65e39c:	4d 8b 6e 20          	mov    0x20(%r14),%r13
  65e3a0:	45 31 e4             	xor    %r12d,%r12d
  65e3a3:	48 83 fd 01          	cmp    $0x1,%rbp
  65e3a7:	74 2a                	je     65e3d3 <<gpui_canvas::text::TextLayout>::position_at+0x303>
  65e3a9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  65e3b0:	4d 89 e6             	mov    %r12,%r14
  65e3b3:	49 89 ea             	mov    %rbp,%r10
  65e3b6:	49 d1 ea             	shr    $1,%r10
  65e3b9:	4d 01 d4             	add    %r10,%r12
  65e3bc:	4b 8d 3c 64          	lea    (%r12,%r12,2),%rdi
  65e3c0:	41 0f 2e 44 fd 08    	ucomiss 0x8(%r13,%rdi,8),%xmm0
  65e3c6:	4d 0f 42 e6          	cmovb  %r14,%r12
  65e3ca:	4c 29 d5             	sub    %r10,%rbp
  65e3cd:	48 83 fd 01          	cmp    $0x1,%rbp
  65e3d1:	77 dd                	ja     65e3b0 <<gpui_canvas::text::TextLayout>::position_at+0x2e0>
  65e3d3:	4b 8d 3c 64          	lea    (%r12,%r12,2),%rdi
  65e3d7:	31 ed                	xor    %ebp,%ebp
  65e3d9:	41 0f 2e 44 fd 08    	ucomiss 0x8(%r13,%rdi,8),%xmm0
  65e3df:	40 0f 93 c5          	setae  %bpl
  65e3e3:	4c 01 e5             	add    %r12,%rbp
  65e3e6:	48 83 fd 01          	cmp    $0x1,%rbp
  65e3ea:	48 83 d5 ff          	adc    $0xffffffffffffffff,%rbp
  65e3ee:	49 89 de             	mov    %rbx,%r14
  65e3f1:	42 0f 2e 44 1e ec    	ucomiss -0x14(%rsi,%r11,1),%xmm0
  65e3f7:	f3 43 0f 10 4c 0f e8 	movss  -0x18(%r15,%r9,1),%xmm1
  65e3fe:	75 02                	jne    65e402 <<gpui_canvas::text::TextLayout>::position_at+0x332>
  65e400:	7b 46                	jnp    65e448 <<gpui_canvas::text::TextLayout>::position_at+0x378>
  65e402:	4c 89 f3             	mov    %r14,%rbx
  65e405:	49 8b 76 10          	mov    0x10(%r14),%rsi
  65e409:	48 83 fe 02          	cmp    $0x2,%rsi
  65e40d:	0f 82 27 fe ff ff    	jb     65e23a <<gpui_canvas::text::TextLayout>::position_at+0x16a>
  65e413:	4c 8b 5b 08          	mov    0x8(%rbx),%r11
  65e417:	45 31 e4             	xor    %r12d,%r12d
  65e41a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  65e420:	48 89 f7             	mov    %rsi,%rdi
  65e423:	48 d1 ef             	shr    $1,%rdi
  65e426:	4e 8d 14 27          	lea    (%rdi,%r12,1),%r10
  65e42a:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  65e42e:	47 8b 74 f3 10       	mov    0x10(%r11,%r14,8),%r14d
  65e433:	4c 39 f5             	cmp    %r14,%rbp
  65e436:	4d 0f 47 e2          	cmova  %r10,%r12
  65e43a:	48 29 fe             	sub    %rdi,%rsi
  65e43d:	48 83 fe 01          	cmp    $0x1,%rsi
  65e441:	77 dd                	ja     65e420 <<gpui_canvas::text::TextLayout>::position_at+0x350>
  65e443:	e9 f2 fd ff ff       	jmp    65e23a <<gpui_canvas::text::TextLayout>::position_at+0x16a>
  65e448:	48 8b bc 24 88 00 00 	mov    0x88(%rsp),%rdi
  65e44f:	00
  65e450:	48 3b 2f             	cmp    (%rdi),%rbp
  65e453:	0f 85 f7 fd ff ff    	jne    65e250 <<gpui_canvas::text::TextLayout>::position_at+0x180>
  65e459:	e9 a8 00 00 00       	jmp    65e506 <<gpui_canvas::text::TextLayout>::position_at+0x436>
  65e45e:	f3 0f 11 74 24 1c    	movss  %xmm6,0x1c(%rsp)
  65e464:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  65e469:	89 54 24 20          	mov    %edx,0x20(%rsp)
  65e46d:	48 c7 44 24 60 00 00 	movq   $0x0,0x60(%rsp)
  65e474:	00 00
  65e476:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
  65e47b:	e8 e0 c1 00 00       	call   66a660 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::Details>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>
  65e480:	48 85 c0             	test   %rax,%rax
  65e483:	0f 85 ec 02 00 00    	jne    65e775 <<gpui_canvas::text::TextLayout>::position_at+0x6a5>
  65e489:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  65e48e:	48 85 c9             	test   %rcx,%rcx
  65e491:	0f 84 de 02 00 00    	je     65e775 <<gpui_canvas::text::TextLayout>::position_at+0x6a5>
  65e497:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  65e49c:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  65e4a2:	48 83 f9 01          	cmp    $0x1,%rcx
  65e4a6:	8b 54 24 20          	mov    0x20(%rsp),%edx
  65e4aa:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  65e4af:	f3 0f 10 74 24 1c    	movss  0x1c(%rsp),%xmm6
  65e4b5:	74 21                	je     65e4d8 <<gpui_canvas::text::TextLayout>::position_at+0x408>
  65e4b7:	48 8d 7e 28          	lea    0x28(%rsi),%rdi
  65e4bb:	4c 8d 41 01          	lea    0x1(%rcx),%r8
  65e4bf:	44 8b 4f e8          	mov    -0x18(%rdi),%r9d
  65e4c3:	44 3b 0f             	cmp    (%rdi),%r9d
  65e4c6:	75 10                	jne    65e4d8 <<gpui_canvas::text::TextLayout>::position_at+0x408>
  65e4c8:	49 ff c2             	inc    %r10
  65e4cb:	48 83 c7 18          	add    $0x18,%rdi
  65e4cf:	49 ff c8             	dec    %r8
  65e4d2:	49 83 f8 02          	cmp    $0x2,%r8
  65e4d6:	77 e7                	ja     65e4bf <<gpui_canvas::text::TextLayout>::position_at+0x3ef>
  65e4d8:	4c 29 d1             	sub    %r10,%rcx
  65e4db:	0f 82 42 02 00 00    	jb     65e723 <<gpui_canvas::text::TextLayout>::position_at+0x653>
  65e4e1:	4b 8d 3c 52          	lea    (%r10,%r10,2),%rdi
  65e4e5:	4c 8d 0c fe          	lea    (%rsi,%rdi,8),%r9
  65e4e9:	4c 8b 74 24 78       	mov    0x78(%rsp),%r14
  65e4ee:	e9 2a fe ff ff       	jmp    65e31d <<gpui_canvas::text::TextLayout>::position_at+0x24d>
  65e4f3:	47 8b 54 0f f8       	mov    -0x8(%r15,%r9,1),%r10d
  65e4f8:	41 b3 01             	mov    $0x1,%r11b
  65e4fb:	45 89 d1             	mov    %r10d,%r9d
  65e4fe:	40 b6 01             	mov    $0x1,%sil
  65e501:	0f 28 c1             	movaps %xmm1,%xmm0
  65e504:	eb 60                	jmp    65e566 <<gpui_canvas::text::TextLayout>::position_at+0x496>
  65e506:	46 8b 6c 1e f8       	mov    -0x8(%rsi,%r11,1),%r13d
  65e50b:	47 8b 4c 0f f8       	mov    -0x8(%r15,%r9,1),%r9d
  65e510:	f3 42 0f 10 54 1e e8 	movss  -0x18(%rsi,%r11,1),%xmm2
  65e517:	0f 28 c1             	movaps %xmm1,%xmm0
  65e51a:	f3 0f 5d c2          	minss  %xmm2,%xmm0
  65e51e:	0f 28 d8             	movaps %xmm0,%xmm3
  65e521:	f3 0f c2 d8 03       	cmpunordss %xmm0,%xmm3
  65e526:	0f 28 e3             	movaps %xmm3,%xmm4
  65e529:	0f 55 e0             	andnps %xmm0,%xmm4
  65e52c:	0f 54 d9             	andps  %xmm1,%xmm3
  65e52f:	0f 56 dc             	orps   %xmm4,%xmm3
  65e532:	0f 28 e1             	movaps %xmm1,%xmm4
  65e535:	f3 0f 5f e2          	maxss  %xmm2,%xmm4
  65e539:	0f 28 c4             	movaps %xmm4,%xmm0
  65e53c:	f3 0f c2 c4 03       	cmpunordss %xmm4,%xmm0
  65e541:	0f 28 e8             	movaps %xmm0,%xmm5
  65e544:	0f 55 ec             	andnps %xmm4,%xmm5
  65e547:	0f 54 c1             	andps  %xmm1,%xmm0
  65e54a:	0f 56 c5             	orps   %xmm5,%xmm0
  65e54d:	0f 2e d1             	ucomiss %xmm1,%xmm2
  65e550:	41 0f 97 c3          	seta   %r11b
  65e554:	40 0f 96 c6          	setbe  %sil
  65e558:	45 89 ea             	mov    %r13d,%r10d
  65e55b:	45 0f 47 d1          	cmova  %r9d,%r10d
  65e55f:	45 0f 47 cd          	cmova  %r13d,%r9d
  65e563:	0f 28 cb             	movaps %xmm3,%xmm1
  65e566:	f3 0f 10 54 24 2c    	movss  0x2c(%rsp),%xmm2
  65e56c:	0f 2e ca             	ucomiss %xmm2,%xmm1
  65e56f:	76 28                	jbe    65e599 <<gpui_canvas::text::TextLayout>::position_at+0x4c9>
  65e571:	80 fa 02             	cmp    $0x2,%dl
  65e574:	74 48                	je     65e5be <<gpui_canvas::text::TextLayout>::position_at+0x4ee>
  65e576:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  65e57c:	0f 2e c1             	ucomiss %xmm1,%xmm0
  65e57f:	44 8b 4c 24 0c       	mov    0xc(%rsp),%r9d
  65e584:	76 0e                	jbe    65e594 <<gpui_canvas::text::TextLayout>::position_at+0x4c4>
  65e586:	f3 0f 11 4c 24 24    	movss  %xmm1,0x24(%rsp)
  65e58c:	44 89 54 24 28       	mov    %r10d,0x28(%rsp)
  65e591:	44 89 da             	mov    %r11d,%edx
  65e594:	0f 28 c6             	movaps %xmm6,%xmm0
  65e597:	eb 3b                	jmp    65e5d4 <<gpui_canvas::text::TextLayout>::position_at+0x504>
  65e599:	0f 2e d0             	ucomiss %xmm0,%xmm2
  65e59c:	0f 86 9a 01 00 00    	jbe    65e73c <<gpui_canvas::text::TextLayout>::position_at+0x66c>
  65e5a2:	0f b6 7c 24 0b       	movzbl 0xb(%rsp),%edi
  65e5a7:	40 80 ff 02          	cmp    $0x2,%dil
  65e5ab:	74 2c                	je     65e5d9 <<gpui_canvas::text::TextLayout>::position_at+0x509>
  65e5ad:	0f 2e c6             	ucomiss %xmm6,%xmm0
  65e5b0:	77 27                	ja     65e5d9 <<gpui_canvas::text::TextLayout>::position_at+0x509>
  65e5b2:	0f 28 c6             	movaps %xmm6,%xmm0
  65e5b5:	44 8b 4c 24 0c       	mov    0xc(%rsp),%r9d
  65e5ba:	89 fe                	mov    %edi,%esi
  65e5bc:	eb 1b                	jmp    65e5d9 <<gpui_canvas::text::TextLayout>::position_at+0x509>
  65e5be:	f3 0f 11 4c 24 24    	movss  %xmm1,0x24(%rsp)
  65e5c4:	44 89 54 24 28       	mov    %r10d,0x28(%rsp)
  65e5c9:	44 89 da             	mov    %r11d,%edx
  65e5cc:	0f 28 c6             	movaps %xmm6,%xmm0
  65e5cf:	44 8b 4c 24 0c       	mov    0xc(%rsp),%r9d
  65e5d4:	0f b6 74 24 0b       	movzbl 0xb(%rsp),%esi
  65e5d9:	4c 8b 5c 24 10       	mov    0x10(%rsp),%r11
  65e5de:	4c 8b 54 24 48       	mov    0x48(%rsp),%r10
  65e5e3:	89 f7                	mov    %esi,%edi
  65e5e5:	44 89 4c 24 0c       	mov    %r9d,0xc(%rsp)
  65e5ea:	0f 28 f0             	movaps %xmm0,%xmm6
  65e5ed:	4d 85 d2             	test   %r10,%r10
  65e5f0:	0f 85 3d fc ff ff    	jne    65e233 <<gpui_canvas::text::TextLayout>::position_at+0x163>
  65e5f6:	eb 12                	jmp    65e60a <<gpui_canvas::text::TextLayout>::position_at+0x53a>
  65e5f8:	0f 28 c6             	movaps %xmm6,%xmm0
  65e5fb:	44 8b 4c 24 0c       	mov    0xc(%rsp),%r9d
  65e600:	0f b6 74 24 0b       	movzbl 0xb(%rsp),%esi
  65e605:	4c 8b 5c 24 10       	mov    0x10(%rsp),%r11
  65e60a:	40 80 fe 02          	cmp    $0x2,%sil
  65e60e:	0f 85 a1 00 00 00    	jne    65e6b5 <<gpui_canvas::text::TextLayout>::position_at+0x5e5>
  65e614:	80 fa 02             	cmp    $0x2,%dl
  65e617:	44 8b 4c 24 28       	mov    0x28(%rsp),%r9d
  65e61c:	0f 85 9e 00 00 00    	jne    65e6c0 <<gpui_canvas::text::TextLayout>::position_at+0x5f0>
  65e622:	4c 8b 7c 24 38       	mov    0x38(%rsp),%r15
  65e627:	48 8b 94 24 90 00 00 	mov    0x90(%rsp),%rdx
  65e62e:	00
  65e62f:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  65e633:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
  65e637:	eb 2b                	jmp    65e664 <<gpui_canvas::text::TextLayout>::position_at+0x594>
  65e639:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  65e640:	4c 8d 04 7f          	lea    (%rdi,%rdi,2),%r8
  65e644:	31 f6                	xor    %esi,%esi
  65e646:	42 0f 2e 44 c0 08    	ucomiss 0x8(%rax,%r8,8),%xmm0
  65e64c:	40 0f 93 c6          	setae  %sil
  65e650:	48 01 fe             	add    %rdi,%rsi
  65e653:	48 83 fe 01          	cmp    $0x1,%rsi
  65e657:	48 83 d6 ff          	adc    $0xffffffffffffffff,%rsi
  65e65b:	48 8d 42 18          	lea    0x18(%rdx),%rax
  65e65f:	4c 39 fe             	cmp    %r15,%rsi
  65e662:	74 71                	je     65e6d5 <<gpui_canvas::text::TextLayout>::position_at+0x605>
  65e664:	48 39 c8             	cmp    %rcx,%rax
  65e667:	74 55                	je     65e6be <<gpui_canvas::text::TextLayout>::position_at+0x5ee>
  65e669:	48 89 c2             	mov    %rax,%rdx
  65e66c:	49 8b 73 28          	mov    0x28(%r11),%rsi
  65e670:	48 85 f6             	test   %rsi,%rsi
  65e673:	74 e6                	je     65e65b <<gpui_canvas::text::TextLayout>::position_at+0x58b>
  65e675:	f3 0f 10 42 04       	movss  0x4(%rdx),%xmm0
  65e67a:	49 8b 43 20          	mov    0x20(%r11),%rax
  65e67e:	31 ff                	xor    %edi,%edi
  65e680:	48 83 fe 01          	cmp    $0x1,%rsi
  65e684:	74 ba                	je     65e640 <<gpui_canvas::text::TextLayout>::position_at+0x570>
  65e686:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  65e68d:	00 00 00
  65e690:	49 89 f8             	mov    %rdi,%r8
  65e693:	49 89 f1             	mov    %rsi,%r9
  65e696:	49 d1 e9             	shr    $1,%r9
  65e699:	4c 01 cf             	add    %r9,%rdi
  65e69c:	4c 8d 14 7f          	lea    (%rdi,%rdi,2),%r10
  65e6a0:	42 0f 2e 44 d0 08    	ucomiss 0x8(%rax,%r10,8),%xmm0
  65e6a6:	49 0f 42 f8          	cmovb  %r8,%rdi
  65e6aa:	4c 29 ce             	sub    %r9,%rsi
  65e6ad:	48 83 fe 01          	cmp    $0x1,%rsi
  65e6b1:	77 dd                	ja     65e690 <<gpui_canvas::text::TextLayout>::position_at+0x5c0>
  65e6b3:	eb 8b                	jmp    65e640 <<gpui_canvas::text::TextLayout>::position_at+0x570>
  65e6b5:	80 fa 02             	cmp    $0x2,%dl
  65e6b8:	75 2a                	jne    65e6e4 <<gpui_canvas::text::TextLayout>::position_at+0x614>
  65e6ba:	89 f2                	mov    %esi,%edx
  65e6bc:	eb 02                	jmp    65e6c0 <<gpui_canvas::text::TextLayout>::position_at+0x5f0>
  65e6be:	b2 02                	mov    $0x2,%dl
  65e6c0:	44 89 c8             	mov    %r9d,%eax
  65e6c3:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  65e6ca:	5b                   	pop    %rbx
  65e6cb:	41 5c                	pop    %r12
  65e6cd:	41 5d                	pop    %r13
  65e6cf:	41 5e                	pop    %r14
  65e6d1:	41 5f                	pop    %r15
  65e6d3:	5d                   	pop    %rbp
  65e6d4:	c3                   	ret
  65e6d5:	44 8b 4a 10          	mov    0x10(%rdx),%r9d
  65e6d9:	0f b6 52 14          	movzbl 0x14(%rdx),%edx
  65e6dd:	d0 ea                	shr    $1,%dl
  65e6df:	80 e2 01             	and    $0x1,%dl
  65e6e2:	eb dc                	jmp    65e6c0 <<gpui_canvas::text::TextLayout>::position_at+0x5f0>
  65e6e4:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  65e6e8:	f3 0f 10 4c 24 24    	movss  0x24(%rsp),%xmm1
  65e6ee:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  65e6f2:	f2 0f 58 c8          	addsd  %xmm0,%xmm1
  65e6f6:	f2 0f 59 0d ba 29 9c 	mulsd  -0x63d646(%rip),%xmm1        # 210b8 <anon.0489ba3ebefb5402e80a192bcb938943.30.llvm.1203371347567281581+0x111>
  65e6fd:	ff
  65e6fe:	f3 0f 10 44 24 2c    	movss  0x2c(%rsp),%xmm0
  65e704:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  65e708:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  65e70c:	8b 44 24 28          	mov    0x28(%rsp),%eax
  65e710:	41 0f 46 c1          	cmovbe %r9d,%eax
  65e714:	41 89 c1             	mov    %eax,%r9d
  65e717:	0f b6 c2             	movzbl %dl,%eax
  65e71a:	40 0f b6 d6          	movzbl %sil,%edx
  65e71e:	0f 47 d0             	cmova  %eax,%edx
  65e721:	eb 9d                	jmp    65e6c0 <<gpui_canvas::text::TextLayout>::position_at+0x5f0>
  65e723:	48 8d 3d 92 92 bf ff 	lea    -0x406d6e(%rip),%rdi        # 2579bc <gpui_canvas::text::PRIMARY_BYTES+0x1f4448>
  65e72a:	48 8d 15 87 85 10 00 	lea    0x108587(%rip),%rdx        # 766cb8 <anon.a48ffa9714aefd715eb9a00ca32a7bbf.2.llvm.7974572617015294607+0x48>
  65e731:	be 13 00 00 00       	mov    $0x13,%esi
  65e736:	ff 15 b4 28 11 00    	call   *0x1128b4(%rip)        # 770ff0 <_DYNAMIC+0x340>
  65e73c:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  65e740:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  65e744:	f2 0f 58 c1          	addsd  %xmm1,%xmm0
  65e748:	f2 0f 59 05 68 29 9c 	mulsd  -0x63d698(%rip),%xmm0        # 210b8 <anon.0489ba3ebefb5402e80a192bcb938943.30.llvm.1203371347567281581+0x111>
  65e74f:	ff
  65e750:	f3 0f 10 4c 24 2c    	movss  0x2c(%rsp),%xmm1
  65e756:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  65e75a:	66 0f 2e c8          	ucomisd %xmm0,%xmm1
  65e75e:	45 0f 47 d1          	cmova  %r9d,%r10d
  65e762:	40 0f b6 c6          	movzbl %sil,%eax
  65e766:	41 0f b6 d3          	movzbl %r11b,%edx
  65e76a:	0f 47 d0             	cmova  %eax,%edx
  65e76d:	45 89 d1             	mov    %r10d,%r9d
  65e770:	e9 4b ff ff ff       	jmp    65e6c0 <<gpui_canvas::text::TextLayout>::position_at+0x5f0>
  65e775:	f3 0f 10 44 24 1c    	movss  0x1c(%rsp),%xmm0
  65e77b:	44 8b 4c 24 0c       	mov    0xc(%rsp),%r9d
  65e780:	0f b6 74 24 0b       	movzbl 0xb(%rsp),%esi
  65e785:	8b 54 24 20          	mov    0x20(%rsp),%edx
  65e789:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  65e78e:	e9 72 fe ff ff       	jmp    65e605 <<gpui_canvas::text::TextLayout>::position_at+0x535>
  65e793:	48 8d 15 16 8d 10 00 	lea    0x108d16(%rip),%rdx        # 7674b0 <anon.ff15d46c50634a99bf0be9a017bc6eb6.36.llvm.14034193257400015495>
  65e79a:	4c 89 ff             	mov    %r15,%rdi
  65e79d:	ff 15 fd 28 11 00    	call   *0x1128fd(%rip)        # 7710a0 <_DYNAMIC+0x3f0>
  65e7a3:	cc                   	int3
  65e7a4:	cc                   	int3
  65e7a5:	cc                   	int3
  65e7a6:	cc                   	int3
  65e7a7:	cc                   	int3
  65e7a8:	cc                   	int3
  65e7a9:	cc                   	int3
  65e7aa:	cc                   	int3
  65e7ab:	cc                   	int3
  65e7ac:	cc                   	int3
  65e7ad:	cc                   	int3
  65e7ae:	cc                   	int3
  65e7af:	cc                   	int3

0000000000671970 <<gpui_canvas::text::layout::Details>::stops>:
  671970:	41 56                	push   %r14
  671972:	53                   	push   %rbx
  671973:	50                   	push   %rax
  671974:	89 d0                	mov    %edx,%eax
  671976:	45 31 db             	xor    %r11d,%r11d
  671979:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  67197e:	4c 8b 57 40          	mov    0x40(%rdi),%r10
  671982:	4c 89 d2             	mov    %r10,%rdx
  671985:	49 0f 44 d3          	cmove  %r11,%rdx
  671989:	41 b9 04 00 00 00    	mov    $0x4,%r9d
  67198f:	4c 0f 45 4f 38       	cmovne 0x38(%rdi),%r9
  671994:	41 89 f0             	mov    %esi,%r8d
  671997:	48 89 d7             	mov    %rdx,%rdi
  67199a:	48 89 d6             	mov    %rdx,%rsi
  67199d:	48 85 d2             	test   %rdx,%rdx
  6719a0:	74 7d                	je     671a1f <<gpui_canvas::text::layout::Details>::stops+0xaf>
  6719a2:	48 83 fa 01          	cmp    $0x1,%rdx
  6719a6:	74 28                	je     6719d0 <<gpui_canvas::text::layout::Details>::stops+0x60>
  6719a8:	45 31 db             	xor    %r11d,%r11d
  6719ab:	4c 89 d6             	mov    %r10,%rsi
  6719ae:	66 90                	xchg   %ax,%ax
  6719b0:	48 89 f7             	mov    %rsi,%rdi
  6719b3:	48 d1 ef             	shr    $1,%rdi
  6719b6:	4a 8d 1c 1f          	lea    (%rdi,%r11,1),%rbx
  6719ba:	4c 8d 34 5b          	lea    (%rbx,%rbx,2),%r14
  6719be:	47 39 44 f1 10       	cmp    %r8d,0x10(%r9,%r14,8)
  6719c3:	4c 0f 42 db          	cmovb  %rbx,%r11
  6719c7:	48 29 fe             	sub    %rdi,%rsi
  6719ca:	48 83 fe 01          	cmp    $0x1,%rsi
  6719ce:	77 e0                	ja     6719b0 <<gpui_canvas::text::layout::Details>::stops+0x40>
  6719d0:	4b 8d 34 5b          	lea    (%r11,%r11,2),%rsi
  6719d4:	45 39 44 f1 10       	cmp    %r8d,0x10(%r9,%rsi,8)
  6719d9:	4c 89 df             	mov    %r11,%rdi
  6719dc:	48 83 d7 00          	adc    $0x0,%rdi
  6719e0:	31 f6                	xor    %esi,%esi
  6719e2:	48 83 fa 01          	cmp    $0x1,%rdx
  6719e6:	74 2a                	je     671a12 <<gpui_canvas::text::layout::Details>::stops+0xa2>
  6719e8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  6719ef:	00
  6719f0:	49 89 f0             	mov    %rsi,%r8
  6719f3:	4d 89 d3             	mov    %r10,%r11
  6719f6:	49 d1 eb             	shr    $1,%r11
  6719f9:	4c 01 de             	add    %r11,%rsi
  6719fc:	48 8d 1c 76          	lea    (%rsi,%rsi,2),%rbx
  671a00:	41 39 44 d9 10       	cmp    %eax,0x10(%r9,%rbx,8)
  671a05:	49 0f 47 f0          	cmova  %r8,%rsi
  671a09:	4d 29 da             	sub    %r11,%r10
  671a0c:	49 83 fa 01          	cmp    $0x1,%r10
  671a10:	77 de                	ja     6719f0 <<gpui_canvas::text::layout::Details>::stops+0x80>
  671a12:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  671a16:	43 3b 44 c1 10       	cmp    0x10(%r9,%r8,8),%eax
  671a1b:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
  671a1f:	84 c9                	test   %cl,%cl
  671a21:	74 63                	je     671a86 <<gpui_canvas::text::layout::Details>::stops+0x116>
  671a23:	48 89 d0             	mov    %rdx,%rax
  671a26:	48 29 f0             	sub    %rsi,%rax
  671a29:	76 5b                	jbe    671a86 <<gpui_canvas::text::layout::Details>::stops+0x116>
  671a2b:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  671a31:	48 83 f8 01          	cmp    $0x1,%rax
  671a35:	74 4c                	je     671a83 <<gpui_canvas::text::layout::Details>::stops+0x113>
  671a37:	48 8d 0c 76          	lea    (%rsi,%rsi,2),%rcx
  671a3b:	4d 8d 04 c9          	lea    (%r9,%rcx,8),%r8
  671a3f:	45 8b 54 c9 10       	mov    0x10(%r9,%rcx,8),%r10d
  671a44:	31 c9                	xor    %ecx,%ecx
  671a46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  671a4d:	00 00 00
  671a50:	49 89 c3             	mov    %rax,%r11
  671a53:	49 d1 eb             	shr    $1,%r11
  671a56:	49 8d 1c 0b          	lea    (%r11,%rcx,1),%rbx
  671a5a:	4c 8d 34 5b          	lea    (%rbx,%rbx,2),%r14
  671a5e:	47 39 54 f0 10       	cmp    %r10d,0x10(%r8,%r14,8)
  671a63:	48 0f 44 cb          	cmove  %rbx,%rcx
  671a67:	4c 29 d8             	sub    %r11,%rax
  671a6a:	48 83 f8 01          	cmp    $0x1,%rax
  671a6e:	77 e0                	ja     671a50 <<gpui_canvas::text::layout::Details>::stops+0xe0>
  671a70:	48 8d 04 49          	lea    (%rcx,%rcx,2),%rax
  671a74:	45 31 db             	xor    %r11d,%r11d
  671a77:	45 39 54 c0 10       	cmp    %r10d,0x10(%r8,%rax,8)
  671a7c:	41 0f 94 c3          	sete   %r11b
  671a80:	49 01 cb             	add    %rcx,%r11
  671a83:	4c 01 de             	add    %r11,%rsi
  671a86:	48 89 f1             	mov    %rsi,%rcx
  671a89:	48 29 f9             	sub    %rdi,%rcx
  671a8c:	72 18                	jb     671aa6 <<gpui_canvas::text::layout::Details>::stops+0x136>
  671a8e:	48 39 d6             	cmp    %rdx,%rsi
  671a91:	77 13                	ja     671aa6 <<gpui_canvas::text::layout::Details>::stops+0x136>
  671a93:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  671a97:	49 8d 04 c1          	lea    (%r9,%rax,8),%rax
  671a9b:	48 89 ca             	mov    %rcx,%rdx
  671a9e:	48 83 c4 08          	add    $0x8,%rsp
  671aa2:	5b                   	pop    %rbx
  671aa3:	41 5e                	pop    %r14
  671aa5:	c3                   	ret
  671aa6:	48 8d 0d 1b 5a 0f 00 	lea    0xf5a1b(%rip),%rcx        # 7674c8 <anon.ff15d46c50634a99bf0be9a017bc6eb6.36.llvm.14034193257400015495+0x18>
  671aad:	ff 15 e5 f6 0f 00    	call   *0xff6e5(%rip)        # 771198 <_DYNAMIC+0x4e8>
  671ab3:	cc                   	int3
  671ab4:	cc                   	int3
  671ab5:	cc                   	int3
  671ab6:	cc                   	int3
  671ab7:	cc                   	int3
  671ab8:	cc                   	int3
  671ab9:	cc                   	int3
  671aba:	cc                   	int3
  671abb:	cc                   	int3
  671abc:	cc                   	int3
  671abd:	cc                   	int3
  671abe:	cc                   	int3
  671abf:	cc                   	int3
