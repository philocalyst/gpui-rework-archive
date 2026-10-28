000000000065b3f0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>>:
  65b3f0:	55                   	push   %rbp
  65b3f1:	41 57                	push   %r15
  65b3f3:	41 56                	push   %r14
  65b3f5:	41 55                	push   %r13
  65b3f7:	41 54                	push   %r12
  65b3f9:	53                   	push   %rbx
  65b3fa:	48 81 ec a8 00 00 00 	sub    $0xa8,%rsp
  65b401:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
  65b406:	49 89 f7             	mov    %rsi,%r15
  65b409:	49 89 fe             	mov    %rdi,%r14
  65b40c:	ff 15 2e 59 11 00    	call   *0x11592e(%rip)        # 770d40 <_DYNAMIC+0x360>
  65b412:	84 c0                	test   %al,%al
  65b414:	0f 84 0a 05 00 00    	je     65b924 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x534>
  65b41a:	45 8b 2f             	mov    (%r15),%r13d
  65b41d:	41 8b 57 08          	mov    0x8(%r15),%edx
  65b421:	44 39 ea             	cmp    %r13d,%edx
  65b424:	44 89 e9             	mov    %r13d,%ecx
  65b427:	0f 42 ca             	cmovb  %edx,%ecx
  65b42a:	89 4c 24 38          	mov    %ecx,0x38(%rsp)
  65b42e:	44 0f 47 ea          	cmova  %edx,%r13d
  65b432:	0f 84 ec 04 00 00    	je     65b924 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x534>
  65b438:	49 8b 76 20          	mov    0x20(%r14),%rsi
  65b43c:	48 85 f6             	test   %rsi,%rsi
  65b43f:	0f 84 0a 05 00 00    	je     65b94f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x55f>
  65b445:	88 44 24 0b          	mov    %al,0xb(%rsp)
  65b449:	f3 41 0f 10 46 34    	movss  0x34(%r14),%xmm0
  65b44f:	f3 0f 59 05 79 ec 9b 	mulss  -0x641387(%rip),%xmm0        # 1a0d0 <GCC_except_table0+0x88>
  65b456:	ff
  65b457:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  65b45c:	ff 15 e6 58 11 00    	call   *0x1158e6(%rip)        # 770d48 <_DYNAMIC+0x368>
  65b462:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  65b467:	48 85 c0             	test   %rax,%rax
  65b46a:	0f 84 af 04 00 00    	je     65b91f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x52f>
  65b470:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  65b475:	48 8b 09             	mov    (%rcx),%rcx
  65b478:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  65b47d:	48 8b ac 24 98 00 00 	mov    0x98(%rsp),%rbp
  65b484:	00
  65b485:	f3 0f 10 84 24 a0 00 	movss  0xa0(%rsp),%xmm0
  65b48c:	00 00
  65b48e:	f3 0f 11 44 24 14    	movss  %xmm0,0x14(%rsp)
  65b494:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  65b49b:	00 00
  65b49d:	f3 0f 11 7c 24 10    	movss  %xmm7,0x10(%rsp)
  65b4a3:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
  65b4a9:	0f 28 e9             	movaps %xmm1,%xmm5
  65b4ac:	0f 28 f0             	movaps %xmm0,%xmm6
  65b4af:	eb 4d                	jmp    65b4fe <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x10e>
  65b4b1:	0f 28 cb             	movaps %xmm3,%xmm1
  65b4b4:	f3 0f 5f cc          	maxss  %xmm4,%xmm1
  65b4b8:	0f 28 e9             	movaps %xmm1,%xmm5
  65b4bb:	f3 0f c2 e9 03       	cmpunordss %xmm1,%xmm5
  65b4c0:	0f 28 d5             	movaps %xmm5,%xmm2
  65b4c3:	0f 55 d1             	andnps %xmm1,%xmm2
  65b4c6:	0f 54 eb             	andps  %xmm3,%xmm5
  65b4c9:	0f 56 ea             	orps   %xmm2,%xmm5
  65b4cc:	0f 28 ce             	movaps %xmm6,%xmm1
  65b4cf:	f3 0f 5d c8          	minss  %xmm0,%xmm1
  65b4d3:	0f 28 c1             	movaps %xmm1,%xmm0
  65b4d6:	f3 0f c2 c1 03       	cmpunordss %xmm1,%xmm0
  65b4db:	0f 28 d0             	movaps %xmm0,%xmm2
  65b4de:	0f 55 d1             	andnps %xmm1,%xmm2
  65b4e1:	0f 54 c6             	andps  %xmm6,%xmm0
  65b4e4:	0f 56 c2             	orps   %xmm2,%xmm0
  65b4e7:	f3 0f 5c e8          	subss  %xmm0,%xmm5
  65b4eb:	0f 28 f0             	movaps %xmm0,%xmm6
  65b4ee:	66 90                	xchg   %ax,%ax
  65b4f0:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  65b4f5:	48 85 c0             	test   %rax,%rax
  65b4f8:	0f 84 bd 03 00 00    	je     65b8bb <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4cb>
  65b4fe:	4c 8b 74 24 60       	mov    0x60(%rsp),%r14
  65b503:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  65b509:	48 83 f8 01          	cmp    $0x1,%rax
  65b50d:	74 28                	je     65b537 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x147>
  65b50f:	49 8d 4e 28          	lea    0x28(%r14),%rcx
  65b513:	48 8d 50 01          	lea    0x1(%rax),%rdx
  65b517:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  65b51e:	00 00
  65b520:	8b 71 e8             	mov    -0x18(%rcx),%esi
  65b523:	3b 31                	cmp    (%rcx),%esi
  65b525:	75 10                	jne    65b537 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x147>
  65b527:	49 ff c7             	inc    %r15
  65b52a:	48 83 c1 18          	add    $0x18,%rcx
  65b52e:	48 ff ca             	dec    %rdx
  65b531:	48 83 fa 02          	cmp    $0x2,%rdx
  65b535:	77 e9                	ja     65b520 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x130>
  65b537:	4c 29 f8             	sub    %r15,%rax
  65b53a:	0f 82 f6 03 00 00    	jb     65b936 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x546>
  65b540:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  65b544:	49 8d 0c ce          	lea    (%r14,%rcx,8),%rcx
  65b548:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  65b54d:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  65b552:	48 8b b4 24 80 00 00 	mov    0x80(%rsp),%rsi
  65b559:	00
  65b55a:	48 85 f6             	test   %rsi,%rsi
  65b55d:	0f 85 96 02 00 00    	jne    65b7f9 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x409>
  65b563:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  65b568:	48 85 c0             	test   %rax,%rax
  65b56b:	74 63                	je     65b5d0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1e0>
  65b56d:	4c 8b 64 24 70       	mov    0x70(%rsp),%r12
  65b572:	ba 01 00 00 00       	mov    $0x1,%edx
  65b577:	48 83 f8 01          	cmp    $0x1,%rax
  65b57b:	74 2a                	je     65b5a7 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1b7>
  65b57d:	49 8d 4c 24 28       	lea    0x28(%r12),%rcx
  65b582:	48 8d 70 01          	lea    0x1(%rax),%rsi
  65b586:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  65b58d:	00 00 00
  65b590:	8b 79 e8             	mov    -0x18(%rcx),%edi
  65b593:	3b 39                	cmp    (%rcx),%edi
  65b595:	75 10                	jne    65b5a7 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1b7>
  65b597:	48 ff c2             	inc    %rdx
  65b59a:	48 83 c1 18          	add    $0x18,%rcx
  65b59e:	48 ff ce             	dec    %rsi
  65b5a1:	48 83 fe 02          	cmp    $0x2,%rsi
  65b5a5:	77 e9                	ja     65b590 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1a0>
  65b5a7:	48 29 d0             	sub    %rdx,%rax
  65b5aa:	0f 82 86 03 00 00    	jb     65b936 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x546>
  65b5b0:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  65b5b4:	49 8d 0c cc          	lea    (%r12,%rcx,8),%rcx
  65b5b8:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  65b5bd:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  65b5c2:	4d 85 e4             	test   %r12,%r12
  65b5c5:	75 15                	jne    65b5dc <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1ec>
  65b5c7:	e9 ef 02 00 00       	jmp    65b8bb <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4cb>
  65b5cc:	0f 1f 40 00          	nopl   0x0(%rax)
  65b5d0:	45 31 e4             	xor    %r12d,%r12d
  65b5d3:	4d 85 e4             	test   %r12,%r12
  65b5d6:	0f 84 df 02 00 00    	je     65b8bb <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4cb>
  65b5dc:	49 c1 e7 03          	shl    $0x3,%r15
  65b5e0:	4b 8d 04 7f          	lea    (%r15,%r15,2),%rax
  65b5e4:	31 c9                	xor    %ecx,%ecx
  65b5e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  65b5ed:	00 00 00
  65b5f0:	48 39 c8             	cmp    %rcx,%rax
  65b5f3:	0f 84 f7 fe ff ff    	je     65b4f0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x100>
  65b5f9:	4c 8d 79 18          	lea    0x18(%rcx),%r15
  65b5fd:	41 f6 44 0e 14 02    	testb  $0x2,0x14(%r14,%rcx,1)
  65b603:	4c 89 f9             	mov    %r15,%rcx
  65b606:	74 e8                	je     65b5f0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x200>
  65b608:	48 c1 e2 03          	shl    $0x3,%rdx
  65b60c:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
  65b610:	31 c9                	xor    %ecx,%ecx
  65b612:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  65b619:	1f 84 00 00 00 00 00
  65b620:	48 39 c8             	cmp    %rcx,%rax
  65b623:	0f 84 c7 fe ff ff    	je     65b4f0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x100>
  65b629:	48 8d 59 18          	lea    0x18(%rcx),%rbx
  65b62d:	41 f6 44 0c 14 01    	testb  $0x1,0x14(%r12,%rcx,1)
  65b633:	48 89 d9             	mov    %rbx,%rcx
  65b636:	74 e8                	je     65b620 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x230>
  65b638:	0f 29 74 24 40       	movaps %xmm6,0x40(%rsp)
  65b63d:	0f 29 6c 24 50       	movaps %xmm5,0x50(%rsp)
  65b642:	f3 43 0f 10 44 3e ec 	movss  -0x14(%r14,%r15,1),%xmm0
  65b649:	f3 0f 11 44 24 3c    	movss  %xmm0,0x3c(%rsp)
  65b64f:	48 89 ef             	mov    %rbp,%rdi
  65b652:	ff 15 f8 56 11 00    	call   *0x1156f8(%rip)        # 770d50 <_DYNAMIC+0x370>
  65b658:	f3 0f 10 7c 24 3c    	movss  0x3c(%rsp),%xmm7
  65b65e:	41 0f 2e 7c 1c ec    	ucomiss -0x14(%r12,%rbx,1),%xmm7
  65b664:	f3 43 0f 10 44 3e e8 	movss  -0x18(%r14,%r15,1),%xmm0
  65b66b:	75 02                	jne    65b66f <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x27f>
  65b66d:	7b 28                	jnp    65b697 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x2a7>
  65b66f:	48 8b 4d 08          	mov    0x8(%rbp),%rcx
  65b673:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  65b677:	48 89 f2             	mov    %rsi,%rdx
  65b67a:	48 85 f6             	test   %rsi,%rsi
  65b67d:	0f 28 6c 24 50       	movaps 0x50(%rsp),%xmm5
  65b682:	0f 28 74 24 40       	movaps 0x40(%rsp),%xmm6
  65b687:	0f 84 95 00 00 00    	je     65b722 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x332>
  65b68d:	48 83 fe 01          	cmp    $0x1,%rsi
  65b691:	75 4d                	jne    65b6e0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x2f0>
  65b693:	31 d2                	xor    %edx,%edx
  65b695:	eb 7c                	jmp    65b713 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x323>
  65b697:	f3 41 0f 10 4c 1c e8 	movss  -0x18(%r12,%rbx,1),%xmm1
  65b69e:	0f 28 d0             	movaps %xmm0,%xmm2
  65b6a1:	f3 0f 5d d1          	minss  %xmm1,%xmm2
  65b6a5:	0f 28 da             	movaps %xmm2,%xmm3
  65b6a8:	f3 0f c2 da 03       	cmpunordss %xmm2,%xmm3
  65b6ad:	0f 28 e3             	movaps %xmm3,%xmm4
  65b6b0:	0f 55 e2             	andnps %xmm2,%xmm4
  65b6b3:	0f 54 d8             	andps  %xmm0,%xmm3
  65b6b6:	0f 56 dc             	orps   %xmm4,%xmm3
  65b6b9:	43 8b 54 3e f8       	mov    -0x8(%r14,%r15,1),%edx
  65b6be:	41 8b 74 1c f8       	mov    -0x8(%r12,%rbx,1),%esi
  65b6c3:	f3 0f 5c c8          	subss  %xmm0,%xmm1
  65b6c7:	0f 54 0d 42 64 9c ff 	andps  -0x639bbe(%rip),%xmm1        # 21b10 <anon.255c12af0f8be736e5d332bcd13dbe27.0.llvm.11532299149726854919+0x7d0>
  65b6ce:	0f 28 c3             	movaps %xmm3,%xmm0
  65b6d1:	0f 28 6c 24 50       	movaps 0x50(%rsp),%xmm5
  65b6d6:	0f 28 74 24 40       	movaps 0x40(%rsp),%xmm6
  65b6db:	e9 a7 00 00 00       	jmp    65b787 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x397>
  65b6e0:	48 89 f7             	mov    %rsi,%rdi
  65b6e3:	31 d2                	xor    %edx,%edx
  65b6e5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  65b6ec:	00 00 00 00
  65b6f0:	49 89 f8             	mov    %rdi,%r8
  65b6f3:	49 d1 e8             	shr    $1,%r8
  65b6f6:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  65b6fa:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  65b6fe:	46 8b 54 d1 10       	mov    0x10(%rcx,%r10,8),%r10d
  65b703:	4c 39 d0             	cmp    %r10,%rax
  65b706:	49 0f 47 d1          	cmova  %r9,%rdx
  65b70a:	4c 29 c7             	sub    %r8,%rdi
  65b70d:	48 83 ff 01          	cmp    $0x1,%rdi
  65b711:	77 dd                	ja     65b6f0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x300>
  65b713:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  65b717:	8b 7c f9 10          	mov    0x10(%rcx,%rdi,8),%edi
  65b71b:	48 39 c7             	cmp    %rax,%rdi
  65b71e:	48 83 d2 00          	adc    $0x0,%rdx
  65b722:	48 c1 e2 03          	shl    $0x3,%rdx
  65b726:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  65b72a:	4c 8d 04 39          	lea    (%rcx,%rdi,1),%r8
  65b72e:	43 8b 54 3e f8       	mov    -0x8(%r14,%r15,1),%edx
  65b733:	48 c1 e6 03          	shl    $0x3,%rsi
  65b737:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  65b73b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  65b740:	48 39 fe             	cmp    %rdi,%rsi
  65b743:	74 37                	je     65b77c <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x38c>
  65b745:	4d 89 c1             	mov    %r8,%r9
  65b748:	45 8b 40 10          	mov    0x10(%r8),%r8d
  65b74c:	4c 39 c0             	cmp    %r8,%rax
  65b74f:	75 2b                	jne    65b77c <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x38c>
  65b751:	4d 8d 41 18          	lea    0x18(%r9),%r8
  65b755:	48 83 c7 18          	add    $0x18,%rdi
  65b759:	41 39 11             	cmp    %edx,(%r9)
  65b75c:	77 e2                	ja     65b740 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x350>
  65b75e:	41 3b 51 04          	cmp    0x4(%r9),%edx
  65b762:	77 dc                	ja     65b740 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x350>
  65b764:	41 8b 74 1c f8       	mov    -0x8(%r12,%rbx,1),%esi
  65b769:	80 7c 39 fd 00       	cmpb   $0x0,-0x3(%rcx,%rdi,1)
  65b76e:	74 11                	je     65b781 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x391>
  65b770:	f3 0f 10 4c 24 14    	movss  0x14(%rsp),%xmm1
  65b776:	f3 0f 5c c1          	subss  %xmm1,%xmm0
  65b77a:	eb 0b                	jmp    65b787 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x397>
  65b77c:	41 8b 74 1c f8       	mov    -0x8(%r12,%rbx,1),%esi
  65b781:	f3 0f 10 4c 24 14    	movss  0x14(%rsp),%xmm1
  65b787:	3b 54 24 38          	cmp    0x38(%rsp),%edx
  65b78b:	0f 82 5f fd ff ff    	jb     65b4f0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x100>
  65b791:	44 39 ee             	cmp    %r13d,%esi
  65b794:	0f 87 56 fd ff ff    	ja     65b4f0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x100>
  65b79a:	0f 57 d2             	xorps  %xmm2,%xmm2
  65b79d:	0f 2e ca             	ucomiss %xmm2,%xmm1
  65b7a0:	75 06                	jne    65b7a8 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x3b8>
  65b7a2:	0f 8b 48 fd ff ff    	jnp    65b4f0 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x100>
  65b7a8:	f3 43 0f 10 54 3e f4 	movss  -0xc(%r14,%r15,1),%xmm2
  65b7af:	f6 44 24 28 01       	testb  $0x1,0x28(%rsp)
  65b7b4:	0f 84 d4 00 00 00    	je     65b88e <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x49e>
  65b7ba:	f3 0f 10 5c 24 10    	movss  0x10(%rsp),%xmm3
  65b7c0:	0f 2e df             	ucomiss %xmm7,%xmm3
  65b7c3:	75 74                	jne    65b839 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x449>
  65b7c5:	7a 72                	jp     65b839 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x449>
  65b7c7:	48 39 44 24 18       	cmp    %rax,0x18(%rsp)
  65b7cc:	75 6b                	jne    65b839 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x449>
  65b7ce:	f3 0f 10 5c 24 0c    	movss  0xc(%rsp),%xmm3
  65b7d4:	0f 2e da             	ucomiss %xmm2,%xmm3
  65b7d7:	75 60                	jne    65b839 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x449>
  65b7d9:	7a 5e                	jp     65b839 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x449>
  65b7db:	0f 28 e0             	movaps %xmm0,%xmm4
  65b7de:	f3 0f 58 e1          	addss  %xmm1,%xmm4
  65b7e2:	0f 2e e6             	ucomiss %xmm6,%xmm4
  65b7e5:	72 4d                	jb     65b834 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x444>
  65b7e7:	0f 28 dd             	movaps %xmm5,%xmm3
  65b7ea:	f3 0f 58 de          	addss  %xmm6,%xmm3
  65b7ee:	0f 2e d8             	ucomiss %xmm0,%xmm3
  65b7f1:	0f 83 ba fc ff ff    	jae    65b4b1 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xc1>
  65b7f7:	eb 3b                	jmp    65b834 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x444>
  65b7f9:	48 c7 84 24 80 00 00 	movq   $0x0,0x80(%rsp)
  65b800:	00 00 00 00 00
  65b805:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  65b80a:	0f 29 6c 24 50       	movaps %xmm5,0x50(%rsp)
  65b80f:	0f 29 74 24 40       	movaps %xmm6,0x40(%rsp)
  65b814:	e8 77 02 00 00       	call   65ba90 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::Details>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator>::nth>
  65b819:	0f 28 74 24 40       	movaps 0x40(%rsp),%xmm6
  65b81e:	0f 28 6c 24 50       	movaps 0x50(%rsp),%xmm5
  65b823:	49 89 c4             	mov    %rax,%r12
  65b826:	4d 85 e4             	test   %r12,%r12
  65b829:	0f 85 ad fd ff ff    	jne    65b5dc <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x1ec>
  65b82f:	e9 87 00 00 00       	jmp    65b8bb <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4cb>
  65b834:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  65b839:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  65b83e:	48 c1 c2 07          	rol    $0x7,%rdx
  65b842:	66 0f 7e f1          	movd   %xmm6,%ecx
  65b846:	48 31 d1             	xor    %rdx,%rcx
  65b849:	48 c1 c1 07          	rol    $0x7,%rcx
  65b84d:	66 0f 6e 5c 24 10    	movd   0x10(%rsp),%xmm3
  65b853:	66 0f 7e da          	movd   %xmm3,%edx
  65b857:	48 31 ca             	xor    %rcx,%rdx
  65b85a:	48 c1 c2 07          	rol    $0x7,%rdx
  65b85e:	66 0f 7e e9          	movd   %xmm5,%ecx
  65b862:	48 31 d1             	xor    %rdx,%rcx
  65b865:	48 c1 c1 07          	rol    $0x7,%rcx
  65b869:	66 0f 6e 5c 24 0c    	movd   0xc(%rsp),%xmm3
  65b86f:	66 0f 7e da          	movd   %xmm3,%edx
  65b873:	48 31 ca             	xor    %rcx,%rdx
  65b876:	48 c1 c2 07          	rol    $0x7,%rdx
  65b87a:	8b 74 24 18          	mov    0x18(%rsp),%esi
  65b87e:	48 31 d6             	xor    %rdx,%rsi
  65b881:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  65b886:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  65b88b:	48 89 31             	mov    %rsi,(%rcx)
  65b88e:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  65b893:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  65b898:	b1 01                	mov    $0x1,%cl
  65b89a:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  65b89f:	48 85 c0             	test   %rax,%rax
  65b8a2:	0f 85 f5 fb ff ff    	jne    65b49d <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0xad>
  65b8a8:	f3 0f 11 54 24 0c    	movss  %xmm2,0xc(%rsp)
  65b8ae:	f3 0f 11 7c 24 10    	movss  %xmm7,0x10(%rsp)
  65b8b4:	0f b6 44 24 0b       	movzbl 0xb(%rsp),%eax
  65b8b9:	eb 12                	jmp    65b8cd <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x4dd>
  65b8bb:	0f 28 cd             	movaps %xmm5,%xmm1
  65b8be:	0f 28 c6             	movaps %xmm6,%xmm0
  65b8c1:	f6 44 24 28 01       	testb  $0x1,0x28(%rsp)
  65b8c6:	0f b6 44 24 0b       	movzbl 0xb(%rsp),%eax
  65b8cb:	74 57                	je     65b924 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x534>
  65b8cd:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  65b8d2:	48 c1 c1 07          	rol    $0x7,%rcx
  65b8d6:	66 0f 7e c2          	movd   %xmm0,%edx
  65b8da:	48 31 ca             	xor    %rcx,%rdx
  65b8dd:	48 c1 c2 07          	rol    $0x7,%rdx
  65b8e1:	66 0f 6e 44 24 10    	movd   0x10(%rsp),%xmm0
  65b8e7:	66 0f 7e c1          	movd   %xmm0,%ecx
  65b8eb:	48 31 d1             	xor    %rdx,%rcx
  65b8ee:	48 c1 c1 07          	rol    $0x7,%rcx
  65b8f2:	66 0f 7e ca          	movd   %xmm1,%edx
  65b8f6:	48 31 ca             	xor    %rcx,%rdx
  65b8f9:	48 c1 c2 07          	rol    $0x7,%rdx
  65b8fd:	66 0f 6e 44 24 0c    	movd   0xc(%rsp),%xmm0
  65b903:	66 0f 7e c1          	movd   %xmm0,%ecx
  65b907:	48 31 d1             	xor    %rdx,%rcx
  65b90a:	48 c1 c1 07          	rol    $0x7,%rcx
  65b90e:	8b 54 24 18          	mov    0x18(%rsp),%edx
  65b912:	48 31 ca             	xor    %rcx,%rdx
  65b915:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  65b91a:	48 89 11             	mov    %rdx,(%rcx)
  65b91d:	eb 05                	jmp    65b924 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>+0x534>
  65b91f:	0f b6 44 24 0b       	movzbl 0xb(%rsp),%eax
  65b924:	48 81 c4 a8 00 00 00 	add    $0xa8,%rsp
  65b92b:	5b                   	pop    %rbx
  65b92c:	41 5c                	pop    %r12
  65b92e:	41 5d                	pop    %r13
  65b930:	41 5e                	pop    %r14
  65b932:	41 5f                	pop    %r15
  65b934:	5d                   	pop    %rbp
  65b935:	c3                   	ret
  65b936:	48 8d 3d ff 66 9c ff 	lea    -0x639901(%rip),%rdi        # 2203c <anon.255c12af0f8be736e5d332bcd13dbe27.0.llvm.11532299149726854919+0xcfc>
  65b93d:	48 8d 15 bc b0 10 00 	lea    0x10b0bc(%rip),%rdx        # 766a00 <anon.a48ffa9714aefd715eb9a00ca32a7bbf.2.llvm.9352683839858152548+0x30>
  65b944:	be 13 00 00 00       	mov    $0x13,%esi
  65b949:	ff 15 d1 53 11 00    	call   *0x1153d1(%rip)        # 770d20 <_DYNAMIC+0x340>
  65b94f:	48 8d 3d 62 b0 10 00 	lea    0x10b062(%rip),%rdi        # 7669b8 <anon.69ab5625bfb42ad4c39c151a08f96109.50.llvm.1353928436795425194+0x50>
  65b956:	ff 15 24 53 11 00    	call   *0x115324(%rip)        # 770c80 <_DYNAMIC+0x2a0>
  65b95c:	cc                   	int3
  65b95d:	cc                   	int3
  65b95e:	cc                   	int3
  65b95f:	cc                   	int3

000000000065d9d0 <<gpui_canvas::text::TextLayout>::move_visual>:
  65d9d0:	55                   	push   %rbp
  65d9d1:	41 57                	push   %r15
  65d9d3:	41 56                	push   %r14
  65d9d5:	41 55                	push   %r13
  65d9d7:	41 54                	push   %r12
  65d9d9:	53                   	push   %rbx
  65d9da:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  65d9e1:	4c 8b 7f 20          	mov    0x20(%rdi),%r15
  65d9e5:	b3 02                	mov    $0x2,%bl
  65d9e7:	4d 85 ff             	test   %r15,%r15
  65d9ea:	0f 84 dd 04 00 00    	je     65decd <<gpui_canvas::text::TextLayout>::move_visual+0x4fd>
  65d9f0:	49 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%r15)
  65d9f5:	0f 84 d2 04 00 00    	je     65decd <<gpui_canvas::text::TextLayout>::move_visual+0x4fd>
  65d9fb:	89 cd                	mov    %ecx,%ebp
  65d9fd:	4d 8b 4f 38          	mov    0x38(%r15),%r9
  65da01:	4d 8b 77 40          	mov    0x40(%r15),%r14
  65da05:	31 c0                	xor    %eax,%eax
  65da07:	4d 85 f6             	test   %r14,%r14
  65da0a:	74 41                	je     65da4d <<gpui_canvas::text::TextLayout>::move_visual+0x7d>
  65da0c:	49 83 fe 01          	cmp    $0x1,%r14
  65da10:	74 2e                	je     65da40 <<gpui_canvas::text::TextLayout>::move_visual+0x70>
  65da12:	4c 89 f1             	mov    %r14,%rcx
  65da15:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  65da1c:	00 00 00 00
  65da20:	49 89 cb             	mov    %rcx,%r11
  65da23:	49 d1 eb             	shr    $1,%r11
  65da26:	4d 8d 04 03          	lea    (%r11,%rax,1),%r8
  65da2a:	4f 8d 14 40          	lea    (%r8,%r8,2),%r10
  65da2e:	43 39 74 d1 10       	cmp    %esi,0x10(%r9,%r10,8)
  65da33:	49 0f 42 c0          	cmovb  %r8,%rax
  65da37:	4c 29 d9             	sub    %r11,%rcx
  65da3a:	48 83 f9 01          	cmp    $0x1,%rcx
  65da3e:	77 e0                	ja     65da20 <<gpui_canvas::text::TextLayout>::move_visual+0x50>
  65da40:	48 8d 0c 40          	lea    (%rax,%rax,2),%rcx
  65da44:	41 39 74 c9 10       	cmp    %esi,0x10(%r9,%rcx,8)
  65da49:	48 83 d0 00          	adc    $0x0,%rax
  65da4d:	8d 4a 01             	lea    0x1(%rdx),%ecx
  65da50:	48 c1 e0 03          	shl    $0x3,%rax
  65da54:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  65da58:	4e 8d 04 f5 00 00 00 	lea    0x0(,%r14,8),%r8
  65da5f:	00
  65da60:	4f 8d 14 40          	lea    (%r8,%r8,2),%r10
  65da64:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  65da6b:	00 00 00 00 00
  65da70:	49 39 c2             	cmp    %rax,%r10
  65da73:	0f 84 54 04 00 00    	je     65decd <<gpui_canvas::text::TextLayout>::move_visual+0x4fd>
  65da79:	41 39 74 01 10       	cmp    %esi,0x10(%r9,%rax,1)
  65da7e:	0f 85 49 04 00 00    	jne    65decd <<gpui_canvas::text::TextLayout>::move_visual+0x4fd>
  65da84:	4c 8d 40 18          	lea    0x18(%rax),%r8
  65da88:	41 84 4c 01 14       	test   %cl,0x14(%r9,%rax,1)
  65da8d:	4c 89 c0             	mov    %r8,%rax
  65da90:	74 de                	je     65da70 <<gpui_canvas::text::TextLayout>::move_visual+0xa0>
  65da92:	49 8b 47 28          	mov    0x28(%r15),%rax
  65da96:	48 85 c0             	test   %rax,%rax
  65da99:	74 52                	je     65daed <<gpui_canvas::text::TextLayout>::move_visual+0x11d>
  65da9b:	f3 43 0f 10 44 01 ec 	movss  -0x14(%r9,%r8,1),%xmm0
  65daa2:	4d 8b 57 20          	mov    0x20(%r15),%r10
  65daa6:	45 31 db             	xor    %r11d,%r11d
  65daa9:	48 83 f8 01          	cmp    $0x1,%rax
  65daad:	74 24                	je     65dad3 <<gpui_canvas::text::TextLayout>::move_visual+0x103>
  65daaf:	90                   	nop
  65dab0:	4c 89 d9             	mov    %r11,%rcx
  65dab3:	49 89 c4             	mov    %rax,%r12
  65dab6:	49 d1 ec             	shr    $1,%r12
  65dab9:	4d 01 e3             	add    %r12,%r11
  65dabc:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  65dac0:	41 0f 2e 44 da 08    	ucomiss 0x8(%r10,%rbx,8),%xmm0
  65dac6:	4c 0f 42 d9          	cmovb  %rcx,%r11
  65daca:	4c 29 e0             	sub    %r12,%rax
  65dacd:	48 83 f8 01          	cmp    $0x1,%rax
  65dad1:	77 dd                	ja     65dab0 <<gpui_canvas::text::TextLayout>::move_visual+0xe0>
  65dad3:	4b 8d 0c 5b          	lea    (%r11,%r11,2),%rcx
  65dad7:	31 c0                	xor    %eax,%eax
  65dad9:	41 0f 2e 44 ca 08    	ucomiss 0x8(%r10,%rcx,8),%xmm0
  65dadf:	0f 93 c0             	setae  %al
  65dae2:	4c 01 d8             	add    %r11,%rax
  65dae5:	48 83 f8 01          	cmp    $0x1,%rax
  65dae9:	48 83 d0 ff          	adc    $0xffffffffffffffff,%rax
  65daed:	f3 43 0f 10 6c 01 e8 	movss  -0x18(%r9,%r8,1),%xmm5
  65daf4:	f3 0f 10 47 34       	movss  0x34(%rdi),%xmm0
  65daf9:	f3 0f 59 05 cf c5 9b 	mulss  -0x643a31(%rip),%xmm0        # 1a0d0 <GCC_except_table0+0x88>
  65db00:	ff
  65db01:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  65db06:	0f 57 c9             	xorps  %xmm1,%xmm1
  65db09:	0f 11 4c 24 48       	movups %xmm1,0x48(%rsp)
  65db0e:	4c 89 4c 24 20       	mov    %r9,0x20(%rsp)
  65db13:	4c 89 4c 24 30       	mov    %r9,0x30(%rsp)
  65db18:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  65db1d:	48 c7 44 24 40 01 00 	movq   $0x1,0x40(%rsp)
  65db24:	00 00
  65db26:	4c 89 7c 24 58       	mov    %r15,0x58(%rsp)
  65db2b:	f3 0f 11 44 24 60    	movss  %xmm0,0x60(%rsp)
  65db31:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
  65db36:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  65db3b:	4d 85 f6             	test   %r14,%r14
  65db3e:	0f 84 c4 03 00 00    	je     65df08 <<gpui_canvas::text::TextLayout>::move_visual+0x538>
  65db44:	48 89 7c 24 78       	mov    %rdi,0x78(%rsp)
  65db49:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  65db4e:	f3 0f 10 35 a6 c5 9b 	movss  -0x643a5a(%rip),%xmm6        # 1a0fc <GCC_except_table0+0xb4>
  65db55:	ff
  65db56:	b3 02                	mov    $0x2,%bl
  65db58:	4c 89 bc 24 80 00 00 	mov    %r15,0x80(%rsp)
  65db5f:	00
  65db60:	4c 89 ff             	mov    %r15,%rdi
  65db63:	4c 89 f0             	mov    %r14,%rax
  65db66:	89 2c 24             	mov    %ebp,(%rsp)
  65db69:	89 5c 24 04          	mov    %ebx,0x4(%rsp)
  65db6d:	eb 0f                	jmp    65db7e <<gpui_canvas::text::TextLayout>::move_visual+0x1ae>
  65db6f:	90                   	nop
  65db70:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  65db75:	48 85 c0             	test   %rax,%rax
  65db78:	0f 84 63 03 00 00    	je     65dee1 <<gpui_canvas::text::TextLayout>::move_visual+0x511>
  65db7e:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  65db83:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  65db89:	48 83 f8 01          	cmp    $0x1,%rax
  65db8d:	74 2a                	je     65dbb9 <<gpui_canvas::text::TextLayout>::move_visual+0x1e9>
  65db8f:	4d 8d 44 24 28       	lea    0x28(%r12),%r8
  65db94:	4c 8d 50 01          	lea    0x1(%rax),%r10
  65db98:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  65db9f:	00
  65dba0:	41 8b 48 e8          	mov    -0x18(%r8),%ecx
  65dba4:	41 3b 08             	cmp    (%r8),%ecx
  65dba7:	75 10                	jne    65dbb9 <<gpui_canvas::text::TextLayout>::move_visual+0x1e9>
  65dba9:	49 ff c5             	inc    %r13
  65dbac:	49 83 c0 18          	add    $0x18,%r8
  65dbb0:	49 ff ca             	dec    %r10
  65dbb3:	49 83 fa 02          	cmp    $0x2,%r10
  65dbb7:	77 e7                	ja     65dba0 <<gpui_canvas::text::TextLayout>::move_visual+0x1d0>
  65dbb9:	4c 29 e8             	sub    %r13,%rax
  65dbbc:	0f 82 aa 03 00 00    	jb     65df6c <<gpui_canvas::text::TextLayout>::move_visual+0x59c>
  65dbc2:	4a 8d 0c 6d 00 00 00 	lea    0x0(,%r13,2),%rcx
  65dbc9:	00
  65dbca:	4c 01 e9             	add    %r13,%rcx
  65dbcd:	49 8d 0c cc          	lea    (%r12,%rcx,8),%rcx
  65dbd1:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  65dbd6:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  65dbdb:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  65dbe0:	48 85 c0             	test   %rax,%rax
  65dbe3:	0f 85 8c 01 00 00    	jne    65dd75 <<gpui_canvas::text::TextLayout>::move_visual+0x3a5>
  65dbe9:	4d 89 f0             	mov    %r14,%r8
  65dbec:	49 83 fe 01          	cmp    $0x1,%r14
  65dbf0:	74 35                	je     65dc27 <<gpui_canvas::text::TextLayout>::move_visual+0x257>
  65dbf2:	4d 85 f6             	test   %r14,%r14
  65dbf5:	0f 84 e6 02 00 00    	je     65dee1 <<gpui_canvas::text::TextLayout>::move_visual+0x511>
  65dbfb:	49 8d 41 28          	lea    0x28(%r9),%rax
  65dbff:	4d 8d 56 01          	lea    0x1(%r14),%r10
  65dc03:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  65dc09:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  65dc10:	8b 48 e8             	mov    -0x18(%rax),%ecx
  65dc13:	3b 08                	cmp    (%rax),%ecx
  65dc15:	75 10                	jne    65dc27 <<gpui_canvas::text::TextLayout>::move_visual+0x257>
  65dc17:	49 ff c0             	inc    %r8
  65dc1a:	48 83 c0 18          	add    $0x18,%rax
  65dc1e:	49 ff ca             	dec    %r10
  65dc21:	49 83 fa 02          	cmp    $0x2,%r10
  65dc25:	77 e9                	ja     65dc10 <<gpui_canvas::text::TextLayout>::move_visual+0x240>
  65dc27:	4d 29 c6             	sub    %r8,%r14
  65dc2a:	0f 82 3c 03 00 00    	jb     65df6c <<gpui_canvas::text::TextLayout>::move_visual+0x59c>
  65dc30:	4b 8d 04 40          	lea    (%r8,%r8,2),%rax
  65dc34:	49 8d 0c c1          	lea    (%r9,%rax,8),%rcx
  65dc38:	4c 89 c8             	mov    %r9,%rax
  65dc3b:	49 89 c9             	mov    %rcx,%r9
  65dc3e:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  65dc43:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
  65dc48:	49 c1 e5 03          	shl    $0x3,%r13
  65dc4c:	4a 8d 0c 6d 00 00 00 	lea    0x0(,%r13,2),%rcx
  65dc53:	00
  65dc54:	4c 01 e9             	add    %r13,%rcx
  65dc57:	45 31 d2             	xor    %r10d,%r10d
  65dc5a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  65dc60:	4c 39 d1             	cmp    %r10,%rcx
  65dc63:	0f 84 07 ff ff ff    	je     65db70 <<gpui_canvas::text::TextLayout>::move_visual+0x1a0>
  65dc69:	4d 8d 5a 18          	lea    0x18(%r10),%r11
  65dc6d:	43 f6 44 14 14 02    	testb  $0x2,0x14(%r12,%r10,1)
  65dc73:	4d 89 da             	mov    %r11,%r10
  65dc76:	74 e8                	je     65dc60 <<gpui_canvas::text::TextLayout>::move_visual+0x290>
  65dc78:	49 c1 e0 03          	shl    $0x3,%r8
  65dc7c:	4b 8d 0c 40          	lea    (%r8,%r8,2),%rcx
  65dc80:	45 31 c0             	xor    %r8d,%r8d
  65dc83:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  65dc8a:	84 00 00 00 00 00
  65dc90:	4c 39 c1             	cmp    %r8,%rcx
  65dc93:	0f 84 d7 fe ff ff    	je     65db70 <<gpui_canvas::text::TextLayout>::move_visual+0x1a0>
  65dc99:	4d 8d 68 18          	lea    0x18(%r8),%r13
  65dc9d:	42 f6 44 00 14 01    	testb  $0x1,0x14(%rax,%r8,1)
  65dca3:	4d 89 e8             	mov    %r13,%r8
  65dca6:	74 e8                	je     65dc90 <<gpui_canvas::text::TextLayout>::move_visual+0x2c0>
  65dca8:	f3 43 0f 10 44 1c ec 	movss  -0x14(%r12,%r11,1),%xmm0
  65dcaf:	48 8b 57 28          	mov    0x28(%rdi),%rdx
  65dcb3:	48 85 d2             	test   %rdx,%rdx
  65dcb6:	74 53                	je     65dd0b <<gpui_canvas::text::TextLayout>::move_visual+0x33b>
  65dcb8:	48 8b 6f 20          	mov    0x20(%rdi),%rbp
  65dcbc:	45 31 d2             	xor    %r10d,%r10d
  65dcbf:	48 83 fa 01          	cmp    $0x1,%rdx
  65dcc3:	74 2d                	je     65dcf2 <<gpui_canvas::text::TextLayout>::move_visual+0x322>
  65dcc5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  65dccc:	00 00 00 00
  65dcd0:	4c 89 d1             	mov    %r10,%rcx
  65dcd3:	49 89 d0             	mov    %rdx,%r8
  65dcd6:	49 d1 e8             	shr    $1,%r8
  65dcd9:	4d 01 c2             	add    %r8,%r10
  65dcdc:	4b 8d 1c 52          	lea    (%r10,%r10,2),%rbx
  65dce0:	0f 2e 44 dd 08       	ucomiss 0x8(%rbp,%rbx,8),%xmm0
  65dce5:	4c 0f 42 d1          	cmovb  %rcx,%r10
  65dce9:	4c 29 c2             	sub    %r8,%rdx
  65dcec:	48 83 fa 01          	cmp    $0x1,%rdx
  65dcf0:	77 de                	ja     65dcd0 <<gpui_canvas::text::TextLayout>::move_visual+0x300>
  65dcf2:	4b 8d 0c 52          	lea    (%r10,%r10,2),%rcx
  65dcf6:	31 d2                	xor    %edx,%edx
  65dcf8:	0f 2e 44 cd 08       	ucomiss 0x8(%rbp,%rcx,8),%xmm0
  65dcfd:	0f 93 c2             	setae  %dl
  65dd00:	4c 01 d2             	add    %r10,%rdx
  65dd03:	48 83 fa 01          	cmp    $0x1,%rdx
  65dd07:	48 83 d2 ff          	adc    $0xffffffffffffffff,%rdx
  65dd0b:	f3 42 0f 10 4c 28 ec 	movss  -0x14(%rax,%r13,1),%xmm1
  65dd12:	0f 2e c1             	ucomiss %xmm1,%xmm0
  65dd15:	75 02                	jne    65dd19 <<gpui_canvas::text::TextLayout>::move_visual+0x349>
  65dd17:	7b 3a                	jnp    65dd53 <<gpui_canvas::text::TextLayout>::move_visual+0x383>
  65dd19:	48 8b 6f 10          	mov    0x10(%rdi),%rbp
  65dd1d:	48 83 fd 02          	cmp    $0x2,%rbp
  65dd21:	72 30                	jb     65dd53 <<gpui_canvas::text::TextLayout>::move_visual+0x383>
  65dd23:	4c 8b 57 08          	mov    0x8(%rdi),%r10
  65dd27:	31 c9                	xor    %ecx,%ecx
  65dd29:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  65dd30:	49 89 e8             	mov    %rbp,%r8
  65dd33:	49 d1 e8             	shr    $1,%r8
  65dd36:	49 8d 1c 08          	lea    (%r8,%rcx,1),%rbx
  65dd3a:	4c 8d 3c 5b          	lea    (%rbx,%rbx,2),%r15
  65dd3e:	47 8b 7c fa 10       	mov    0x10(%r10,%r15,8),%r15d
  65dd43:	4c 39 fa             	cmp    %r15,%rdx
  65dd46:	48 0f 47 cb          	cmova  %rbx,%rcx
  65dd4a:	4c 29 c5             	sub    %r8,%rbp
  65dd4d:	48 83 fd 01          	cmp    $0x1,%rbp
  65dd51:	77 dd                	ja     65dd30 <<gpui_canvas::text::TextLayout>::move_visual+0x360>
  65dd53:	0f 2e c1             	ucomiss %xmm1,%xmm0
  65dd56:	0f 85 14 fe ff ff    	jne    65db70 <<gpui_canvas::text::TextLayout>::move_visual+0x1a0>
  65dd5c:	0f 8a 0e fe ff ff    	jp     65db70 <<gpui_canvas::text::TextLayout>::move_visual+0x1a0>
  65dd62:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
  65dd67:	48 3b 11             	cmp    (%rcx),%rdx
  65dd6a:	0f 85 00 fe ff ff    	jne    65db70 <<gpui_canvas::text::TextLayout>::move_visual+0x1a0>
  65dd70:	e9 9a 00 00 00       	jmp    65de0f <<gpui_canvas::text::TextLayout>::move_visual+0x43f>
  65dd75:	f3 0f 11 74 24 10    	movss  %xmm6,0x10(%rsp)
  65dd7b:	f3 0f 11 6c 24 14    	movss  %xmm5,0x14(%rsp)
  65dd81:	89 74 24 08          	mov    %esi,0x8(%rsp)
  65dd85:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  65dd8c:	00 00
  65dd8e:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  65dd93:	48 89 c6             	mov    %rax,%rsi
  65dd96:	e8 d5 ed 00 00       	call   66cb70 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::Details>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>
  65dd9b:	48 85 c0             	test   %rax,%rax
  65dd9e:	0f 85 e1 01 00 00    	jne    65df85 <<gpui_canvas::text::TextLayout>::move_visual+0x5b5>
  65dda4:	4c 8b 74 24 38       	mov    0x38(%rsp),%r14
  65dda9:	4d 85 f6             	test   %r14,%r14
  65ddac:	0f 84 d3 01 00 00    	je     65df85 <<gpui_canvas::text::TextLayout>::move_visual+0x5b5>
  65ddb2:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  65ddb7:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  65ddbd:	49 83 fe 01          	cmp    $0x1,%r14
  65ddc1:	8b 74 24 08          	mov    0x8(%rsp),%esi
  65ddc5:	f3 0f 10 6c 24 14    	movss  0x14(%rsp),%xmm5
  65ddcb:	f3 0f 10 74 24 10    	movss  0x10(%rsp),%xmm6
  65ddd1:	74 21                	je     65ddf4 <<gpui_canvas::text::TextLayout>::move_visual+0x424>
  65ddd3:	4c 8d 48 28          	lea    0x28(%rax),%r9
  65ddd7:	49 8d 4e 01          	lea    0x1(%r14),%rcx
  65dddb:	41 8b 51 e8          	mov    -0x18(%r9),%edx
  65dddf:	41 3b 11             	cmp    (%r9),%edx
  65dde2:	75 10                	jne    65ddf4 <<gpui_canvas::text::TextLayout>::move_visual+0x424>
  65dde4:	49 ff c0             	inc    %r8
  65dde7:	49 83 c1 18          	add    $0x18,%r9
  65ddeb:	48 ff c9             	dec    %rcx
  65ddee:	48 83 f9 02          	cmp    $0x2,%rcx
  65ddf2:	77 e7                	ja     65dddb <<gpui_canvas::text::TextLayout>::move_visual+0x40b>
  65ddf4:	4d 29 c6             	sub    %r8,%r14
  65ddf7:	0f 82 6f 01 00 00    	jb     65df6c <<gpui_canvas::text::TextLayout>::move_visual+0x59c>
  65ddfd:	4b 8d 0c 40          	lea    (%r8,%r8,2),%rcx
  65de01:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
  65de05:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
  65de0a:	e9 2c fe ff ff       	jmp    65dc3b <<gpui_canvas::text::TextLayout>::move_visual+0x26b>
  65de0f:	f3 42 0f 10 4c 28 e8 	movss  -0x18(%rax,%r13,1),%xmm1
  65de16:	f3 43 0f 10 54 1c e8 	movss  -0x18(%r12,%r11,1),%xmm2
  65de1d:	80 3c 24 00          	cmpb   $0x0,(%rsp)
  65de21:	74 21                	je     65de44 <<gpui_canvas::text::TextLayout>::move_visual+0x474>
  65de23:	0f 28 da             	movaps %xmm2,%xmm3
  65de26:	f3 0f 5f d9          	maxss  %xmm1,%xmm3
  65de2a:	0f 28 c3             	movaps %xmm3,%xmm0
  65de2d:	f3 0f c2 c3 03       	cmpunordss %xmm3,%xmm0
  65de32:	0f 28 e0             	movaps %xmm0,%xmm4
  65de35:	0f 55 e3             	andnps %xmm3,%xmm4
  65de38:	0f 54 c2             	andps  %xmm2,%xmm0
  65de3b:	0f 56 c4             	orps   %xmm4,%xmm0
  65de3e:	f3 0f 5c c5          	subss  %xmm5,%xmm0
  65de42:	eb 22                	jmp    65de66 <<gpui_canvas::text::TextLayout>::move_visual+0x496>
  65de44:	0f 28 c2             	movaps %xmm2,%xmm0
  65de47:	f3 0f 5d c1          	minss  %xmm1,%xmm0
  65de4b:	0f 28 d8             	movaps %xmm0,%xmm3
  65de4e:	f3 0f c2 d8 03       	cmpunordss %xmm0,%xmm3
  65de53:	0f 28 e3             	movaps %xmm3,%xmm4
  65de56:	0f 55 e0             	andnps %xmm0,%xmm4
  65de59:	0f 54 da             	andps  %xmm2,%xmm3
  65de5c:	0f 56 dc             	orps   %xmm4,%xmm3
  65de5f:	0f 28 c5             	movaps %xmm5,%xmm0
  65de62:	f3 0f 5c c3          	subss  %xmm3,%xmm0
  65de66:	44 8b 44 24 0c       	mov    0xc(%rsp),%r8d
  65de6b:	42 8b 44 28 f8       	mov    -0x8(%rax,%r13,1),%eax
  65de70:	0f 28 d8             	movaps %xmm0,%xmm3
  65de73:	f3 0f c2 de 01       	cmpltss %xmm6,%xmm3
  65de78:	0f 57 e4             	xorps  %xmm4,%xmm4
  65de7b:	f3 0f c2 e0 01       	cmpltss %xmm0,%xmm4
  65de80:	0f 2e ca             	ucomiss %xmm2,%xmm1
  65de83:	0f 96 c1             	setbe  %cl
  65de86:	8b 2c 24             	mov    (%rsp),%ebp
  65de89:	40 30 e9             	xor    %bpl,%cl
  65de8c:	43 0f 44 44 1c f8    	cmove  -0x8(%r12,%r11,1),%eax
  65de92:	0f 54 e3             	andps  %xmm3,%xmm4
  65de95:	66 0f 7e e2          	movd   %xmm4,%edx
  65de99:	80 f1 01             	xor    $0x1,%cl
  65de9c:	f6 c2 01             	test   $0x1,%dl
  65de9f:	75 03                	jne    65dea4 <<gpui_canvas::text::TextLayout>::move_visual+0x4d4>
  65dea1:	0f 28 c6             	movaps %xmm6,%xmm0
  65dea4:	0f b6 c9             	movzbl %cl,%ecx
  65dea7:	8b 5c 24 04          	mov    0x4(%rsp),%ebx
  65deab:	0f b6 db             	movzbl %bl,%ebx
  65deae:	0f 45 d9             	cmovne %ecx,%ebx
  65deb1:	44 0f 45 c0          	cmovne %eax,%r8d
  65deb5:	44 89 44 24 0c       	mov    %r8d,0xc(%rsp)
  65deba:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  65debf:	0f 28 f0             	movaps %xmm0,%xmm6
  65dec2:	48 85 c0             	test   %rax,%rax
  65dec5:	0f 85 9e fc ff ff    	jne    65db69 <<gpui_canvas::text::TextLayout>::move_visual+0x199>
  65decb:	eb 1b                	jmp    65dee8 <<gpui_canvas::text::TextLayout>::move_visual+0x518>
  65decd:	89 da                	mov    %ebx,%edx
  65decf:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  65ded6:	5b                   	pop    %rbx
  65ded7:	41 5c                	pop    %r12
  65ded9:	41 5d                	pop    %r13
  65dedb:	41 5e                	pop    %r14
  65dedd:	41 5f                	pop    %r15
  65dedf:	5d                   	pop    %rbp
  65dee0:	c3                   	ret
  65dee1:	8b 2c 24             	mov    (%rsp),%ebp
  65dee4:	8b 5c 24 04          	mov    0x4(%rsp),%ebx
  65dee8:	80 fb 02             	cmp    $0x2,%bl
  65deeb:	4c 8b bc 24 80 00 00 	mov    0x80(%rsp),%r15
  65def2:	00
  65def3:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  65def7:	48 8b 7c 24 78       	mov    0x78(%rsp),%rdi
  65defc:	75 cf                	jne    65decd <<gpui_canvas::text::TextLayout>::move_visual+0x4fd>
  65defe:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  65df03:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  65df08:	40 84 ed             	test   %bpl,%bpl
  65df0b:	74 2f                	je     65df3c <<gpui_canvas::text::TextLayout>::move_visual+0x56c>
  65df0d:	b9 01 00 00 00       	mov    $0x1,%ecx
  65df12:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  65df16:	74 30                	je     65df48 <<gpui_canvas::text::TextLayout>::move_visual+0x578>
  65df18:	48 01 c1             	add    %rax,%rcx
  65df1b:	89 d3                	mov    %edx,%ebx
  65df1d:	89 f0                	mov    %esi,%eax
  65df1f:	49 3b 4f 28          	cmp    0x28(%r15),%rcx
  65df23:	73 a8                	jae    65decd <<gpui_canvas::text::TextLayout>::move_visual+0x4fd>
  65df25:	49 8b 47 20          	mov    0x20(%r15),%rax
  65df29:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  65df2d:	40 84 ed             	test   %bpl,%bpl
  65df30:	75 1f                	jne    65df51 <<gpui_canvas::text::TextLayout>::move_visual+0x581>
  65df32:	f3 0f 10 05 ba c1 9b 	movss  -0x643e46(%rip),%xmm0        # 1a0f4 <GCC_except_table0+0xac>
  65df39:	ff
  65df3a:	eb 1d                	jmp    65df59 <<gpui_canvas::text::TextLayout>::move_visual+0x589>
  65df3c:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  65df43:	48 85 c0             	test   %rax,%rax
  65df46:	75 d0                	jne    65df18 <<gpui_canvas::text::TextLayout>::move_visual+0x548>
  65df48:	89 d3                	mov    %edx,%ebx
  65df4a:	89 f0                	mov    %esi,%eax
  65df4c:	e9 7c ff ff ff       	jmp    65decd <<gpui_canvas::text::TextLayout>::move_visual+0x4fd>
  65df51:	f3 0f 10 05 af c1 9b 	movss  -0x643e51(%rip),%xmm0        # 1a108 <GCC_except_table0+0xc0>
  65df58:	ff
  65df59:	f3 0f 10 4c c8 08    	movss  0x8(%rax,%rcx,8),%xmm1
  65df5f:	ff 15 13 2d 11 00    	call   *0x112d13(%rip)        # 770c78 <_DYNAMIC+0x298>
  65df65:	89 d3                	mov    %edx,%ebx
  65df67:	e9 61 ff ff ff       	jmp    65decd <<gpui_canvas::text::TextLayout>::move_visual+0x4fd>
  65df6c:	48 8d 3d f9 99 bf ff 	lea    -0x406607(%rip),%rdi        # 25796c <gpui_canvas::text::PRIMARY_BYTES+0x1f4448>
  65df73:	48 8d 15 9e 8a 10 00 	lea    0x108a9e(%rip),%rdx        # 766a18 <anon.a48ffa9714aefd715eb9a00ca32a7bbf.2.llvm.9352683839858152548+0x48>
  65df7a:	be 13 00 00 00       	mov    $0x13,%esi
  65df7f:	ff 15 9b 2d 11 00    	call   *0x112d9b(%rip)        # 770d20 <_DYNAMIC+0x340>
  65df85:	8b 2c 24             	mov    (%rsp),%ebp
  65df88:	8b 74 24 08          	mov    0x8(%rsp),%esi
  65df8c:	e9 53 ff ff ff       	jmp    65dee4 <<gpui_canvas::text::TextLayout>::move_visual+0x514>
  65df91:	cc                   	int3
  65df92:	cc                   	int3
  65df93:	cc                   	int3
  65df94:	cc                   	int3
  65df95:	cc                   	int3
  65df96:	cc                   	int3
  65df97:	cc                   	int3
  65df98:	cc                   	int3
  65df99:	cc                   	int3
  65df9a:	cc                   	int3
  65df9b:	cc                   	int3
  65df9c:	cc                   	int3
  65df9d:	cc                   	int3
  65df9e:	cc                   	int3
  65df9f:	cc                   	int3

000000000065dfa0 <<gpui_canvas::text::TextLayout>::position_at>:
  65dfa0:	55                   	push   %rbp
  65dfa1:	41 57                	push   %r15
  65dfa3:	41 56                	push   %r14
  65dfa5:	41 55                	push   %r13
  65dfa7:	41 54                	push   %r12
  65dfa9:	53                   	push   %rbx
  65dfaa:	48 83 ec 78          	sub    $0x78,%rsp
  65dfae:	66 0f 7e c8          	movd   %xmm1,%eax
  65dfb2:	66 0f 7e c1          	movd   %xmm0,%ecx
  65dfb6:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  65dfbc:	81 f9 00 00 80 7f    	cmp    $0x7f800000,%ecx
  65dfc2:	0f 9d c1             	setge  %cl
  65dfc5:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  65dfca:	3d 00 00 80 7f       	cmp    $0x7f800000,%eax
  65dfcf:	0f 9d c0             	setge  %al
  65dfd2:	08 c8                	or     %cl,%al
  65dfd4:	b2 02                	mov    $0x2,%dl
  65dfd6:	0f 85 4b 05 00 00    	jne    65e527 <<gpui_canvas::text::TextLayout>::position_at+0x587>
  65dfdc:	4c 8b 7f 20          	mov    0x20(%rdi),%r15
  65dfe0:	4d 85 ff             	test   %r15,%r15
  65dfe3:	0f 84 3e 05 00 00    	je     65e527 <<gpui_canvas::text::TextLayout>::position_at+0x587>
  65dfe9:	49 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%r15)
  65dfee:	0f 84 33 05 00 00    	je     65e527 <<gpui_canvas::text::TextLayout>::position_at+0x587>
  65dff4:	49 8b 57 28          	mov    0x28(%r15),%rdx
  65dff8:	48 85 d2             	test   %rdx,%rdx
  65dffb:	74 4f                	je     65e04c <<gpui_canvas::text::TextLayout>::position_at+0xac>
  65dffd:	49 8b 47 20          	mov    0x20(%r15),%rax
  65e001:	31 c9                	xor    %ecx,%ecx
  65e003:	48 83 fa 01          	cmp    $0x1,%rdx
  65e007:	74 2a                	je     65e033 <<gpui_canvas::text::TextLayout>::position_at+0x93>
  65e009:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  65e010:	48 89 ce             	mov    %rcx,%rsi
  65e013:	49 89 d0             	mov    %rdx,%r8
  65e016:	49 d1 e8             	shr    $1,%r8
  65e019:	4c 01 c1             	add    %r8,%rcx
  65e01c:	4c 8d 0c 49          	lea    (%rcx,%rcx,2),%r9
  65e020:	42 0f 2e 4c c8 08    	ucomiss 0x8(%rax,%r9,8),%xmm1
  65e026:	48 0f 42 ce          	cmovb  %rsi,%rcx
  65e02a:	4c 29 c2             	sub    %r8,%rdx
  65e02d:	48 83 fa 01          	cmp    $0x1,%rdx
  65e031:	77 dd                	ja     65e010 <<gpui_canvas::text::TextLayout>::position_at+0x70>
  65e033:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  65e037:	31 d2                	xor    %edx,%edx
  65e039:	0f 2e 4c f0 08       	ucomiss 0x8(%rax,%rsi,8),%xmm1
  65e03e:	0f 93 c2             	setae  %dl
  65e041:	48 01 ca             	add    %rcx,%rdx
  65e044:	48 83 fa 01          	cmp    $0x1,%rdx
  65e048:	48 83 d2 ff          	adc    $0xffffffffffffffff,%rdx
  65e04c:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  65e051:	f3 0f 10 57 34       	movss  0x34(%rdi),%xmm2
  65e056:	f3 0f 59 15 72 c0 9b 	mulss  -0x643f8e(%rip),%xmm2        # 1a0d0 <GCC_except_table0+0x88>
  65e05d:	ff
  65e05e:	49 8b 4f 38          	mov    0x38(%r15),%rcx
  65e062:	49 8b 47 40          	mov    0x40(%r15),%rax
  65e066:	0f 57 c9             	xorps  %xmm1,%xmm1
  65e069:	0f 11 4c 24 50       	movups %xmm1,0x50(%rsp)
  65e06e:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  65e073:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  65e078:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  65e07d:	48 c7 44 24 48 01 00 	movq   $0x1,0x48(%rsp)
  65e084:	00 00
  65e086:	4c 89 7c 24 60       	mov    %r15,0x60(%rsp)
  65e08b:	f3 0f 11 54 24 68    	movss  %xmm2,0x68(%rsp)
  65e091:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  65e096:	48 89 74 24 70       	mov    %rsi,0x70(%rsp)
  65e09b:	48 85 c0             	test   %rax,%rax
  65e09e:	0f 84 ff 03 00 00    	je     65e4a3 <<gpui_canvas::text::TextLayout>::position_at+0x503>
  65e0a4:	41 b2 02             	mov    $0x2,%r10b
  65e0a7:	4c 89 ff             	mov    %r15,%rdi
  65e0aa:	49 89 c1             	mov    %rax,%r9
  65e0ad:	b2 02                	mov    $0x2,%dl
  65e0af:	44 88 54 24 07       	mov    %r10b,0x7(%rsp)
  65e0b4:	eb 28                	jmp    65e0de <<gpui_canvas::text::TextLayout>::position_at+0x13e>
  65e0b6:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  65e0bb:	48 3b 2e             	cmp    (%rsi),%rbp
  65e0be:	0f 84 ae 02 00 00    	je     65e372 <<gpui_canvas::text::TextLayout>::position_at+0x3d2>
  65e0c4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  65e0cb:	00 00 00 00 00
  65e0d0:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  65e0d5:	4d 85 c9             	test   %r9,%r9
  65e0d8:	0f 84 91 03 00 00    	je     65e46f <<gpui_canvas::text::TextLayout>::position_at+0x4cf>
  65e0de:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  65e0e3:	41 be 01 00 00 00    	mov    $0x1,%r14d
  65e0e9:	49 83 f9 01          	cmp    $0x1,%r9
  65e0ed:	74 2a                	je     65e119 <<gpui_canvas::text::TextLayout>::position_at+0x179>
  65e0ef:	49 8d 75 28          	lea    0x28(%r13),%rsi
  65e0f3:	4d 8d 41 01          	lea    0x1(%r9),%r8
  65e0f7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  65e0fe:	00 00
  65e100:	44 8b 56 e8          	mov    -0x18(%rsi),%r10d
  65e104:	44 3b 16             	cmp    (%rsi),%r10d
  65e107:	75 10                	jne    65e119 <<gpui_canvas::text::TextLayout>::position_at+0x179>
  65e109:	49 ff c6             	inc    %r14
  65e10c:	48 83 c6 18          	add    $0x18,%rsi
  65e110:	49 ff c8             	dec    %r8
  65e113:	49 83 f8 02          	cmp    $0x2,%r8
  65e117:	77 e7                	ja     65e100 <<gpui_canvas::text::TextLayout>::position_at+0x160>
  65e119:	4d 29 f1             	sub    %r14,%r9
  65e11c:	0f 82 26 04 00 00    	jb     65e548 <<gpui_canvas::text::TextLayout>::position_at+0x5a8>
  65e122:	4b 8d 34 76          	lea    (%r14,%r14,2),%rsi
  65e126:	48 8d 34 f5 00 00 00 	lea    0x0(,%rsi,8),%rsi
  65e12d:	00
  65e12e:	4c 01 ee             	add    %r13,%rsi
  65e131:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  65e136:	4c 89 4c 24 30       	mov    %r9,0x30(%rsp)
  65e13b:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  65e140:	48 85 f6             	test   %rsi,%rsi
  65e143:	0f 85 92 01 00 00    	jne    65e2db <<gpui_canvas::text::TextLayout>::position_at+0x33b>
  65e149:	49 89 c1             	mov    %rax,%r9
  65e14c:	48 83 f8 01          	cmp    $0x1,%rax
  65e150:	74 37                	je     65e189 <<gpui_canvas::text::TextLayout>::position_at+0x1e9>
  65e152:	48 85 c0             	test   %rax,%rax
  65e155:	0f 84 14 03 00 00    	je     65e46f <<gpui_canvas::text::TextLayout>::position_at+0x4cf>
  65e15b:	48 8d 71 28          	lea    0x28(%rcx),%rsi
  65e15f:	4c 8d 40 01          	lea    0x1(%rax),%r8
  65e163:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  65e169:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  65e170:	44 8b 56 e8          	mov    -0x18(%rsi),%r10d
  65e174:	44 3b 16             	cmp    (%rsi),%r10d
  65e177:	75 10                	jne    65e189 <<gpui_canvas::text::TextLayout>::position_at+0x1e9>
  65e179:	49 ff c1             	inc    %r9
  65e17c:	48 83 c6 18          	add    $0x18,%rsi
  65e180:	49 ff c8             	dec    %r8
  65e183:	49 83 f8 02          	cmp    $0x2,%r8
  65e187:	77 e7                	ja     65e170 <<gpui_canvas::text::TextLayout>::position_at+0x1d0>
  65e189:	4c 29 c8             	sub    %r9,%rax
  65e18c:	0f 82 b6 03 00 00    	jb     65e548 <<gpui_canvas::text::TextLayout>::position_at+0x5a8>
  65e192:	4b 8d 34 49          	lea    (%r9,%r9,2),%rsi
  65e196:	4c 8d 04 f1          	lea    (%rcx,%rsi,8),%r8
  65e19a:	48 89 ce             	mov    %rcx,%rsi
  65e19d:	4c 89 c1             	mov    %r8,%rcx
  65e1a0:	4c 89 44 24 38       	mov    %r8,0x38(%rsp)
  65e1a5:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  65e1aa:	49 c1 e6 03          	shl    $0x3,%r14
  65e1ae:	4f 8d 14 76          	lea    (%r14,%r14,2),%r10
  65e1b2:	45 31 db             	xor    %r11d,%r11d
  65e1b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  65e1bc:	00 00 00 00
  65e1c0:	4d 39 da             	cmp    %r11,%r10
  65e1c3:	0f 84 07 ff ff ff    	je     65e0d0 <<gpui_canvas::text::TextLayout>::position_at+0x130>
  65e1c9:	4d 8d 43 18          	lea    0x18(%r11),%r8
  65e1cd:	43 f6 44 1d 14 02    	testb  $0x2,0x14(%r13,%r11,1)
  65e1d3:	4d 89 c3             	mov    %r8,%r11
  65e1d6:	74 e8                	je     65e1c0 <<gpui_canvas::text::TextLayout>::position_at+0x220>
  65e1d8:	49 c1 e1 03          	shl    $0x3,%r9
  65e1dc:	4f 8d 0c 49          	lea    (%r9,%r9,2),%r9
  65e1e0:	45 31 db             	xor    %r11d,%r11d
  65e1e3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  65e1ea:	84 00 00 00 00 00
  65e1f0:	4d 39 d9             	cmp    %r11,%r9
  65e1f3:	0f 84 d7 fe ff ff    	je     65e0d0 <<gpui_canvas::text::TextLayout>::position_at+0x130>
  65e1f9:	4d 8d 53 18          	lea    0x18(%r11),%r10
  65e1fd:	42 f6 44 1e 14 01    	testb  $0x1,0x14(%rsi,%r11,1)
  65e203:	4d 89 d3             	mov    %r10,%r11
  65e206:	74 e8                	je     65e1f0 <<gpui_canvas::text::TextLayout>::position_at+0x250>
  65e208:	f3 43 0f 10 4c 05 ec 	movss  -0x14(%r13,%r8,1),%xmm1
  65e20f:	48 8b 6f 28          	mov    0x28(%rdi),%rbp
  65e213:	48 85 ed             	test   %rbp,%rbp
  65e216:	74 56                	je     65e26e <<gpui_canvas::text::TextLayout>::position_at+0x2ce>
  65e218:	4c 8b 5f 20          	mov    0x20(%rdi),%r11
  65e21c:	45 31 f6             	xor    %r14d,%r14d
  65e21f:	48 83 fd 01          	cmp    $0x1,%rbp
  65e223:	74 2e                	je     65e253 <<gpui_canvas::text::TextLayout>::position_at+0x2b3>
  65e225:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  65e22c:	00 00 00 00
  65e230:	4d 89 f4             	mov    %r14,%r12
  65e233:	49 89 e9             	mov    %rbp,%r9
  65e236:	49 d1 e9             	shr    $1,%r9
  65e239:	4d 01 ce             	add    %r9,%r14
  65e23c:	4b 8d 1c 76          	lea    (%r14,%r14,2),%rbx
  65e240:	41 0f 2e 4c db 08    	ucomiss 0x8(%r11,%rbx,8),%xmm1
  65e246:	4d 0f 42 f4          	cmovb  %r12,%r14
  65e24a:	4c 29 cd             	sub    %r9,%rbp
  65e24d:	48 83 fd 01          	cmp    $0x1,%rbp
  65e251:	77 dd                	ja     65e230 <<gpui_canvas::text::TextLayout>::position_at+0x290>
  65e253:	4f 8d 0c 76          	lea    (%r14,%r14,2),%r9
  65e257:	31 ed                	xor    %ebp,%ebp
  65e259:	43 0f 2e 4c cb 08    	ucomiss 0x8(%r11,%r9,8),%xmm1
  65e25f:	40 0f 93 c5          	setae  %bpl
  65e263:	4c 01 f5             	add    %r14,%rbp
  65e266:	48 83 fd 01          	cmp    $0x1,%rbp
  65e26a:	48 83 d5 ff          	adc    $0xffffffffffffffff,%rbp
  65e26e:	42 0f 2e 4c 16 ec    	ucomiss -0x14(%rsi,%r10,1),%xmm1
  65e274:	f3 43 0f 10 4c 05 e8 	movss  -0x18(%r13,%r8,1),%xmm1
  65e27b:	75 02                	jne    65e27f <<gpui_canvas::text::TextLayout>::position_at+0x2df>
  65e27d:	7b 49                	jnp    65e2c8 <<gpui_canvas::text::TextLayout>::position_at+0x328>
  65e27f:	48 8b 77 10          	mov    0x10(%rdi),%rsi
  65e283:	48 83 fe 02          	cmp    $0x2,%rsi
  65e287:	0f 82 29 fe ff ff    	jb     65e0b6 <<gpui_canvas::text::TextLayout>::position_at+0x116>
  65e28d:	4c 8b 57 08          	mov    0x8(%rdi),%r10
  65e291:	45 31 db             	xor    %r11d,%r11d
  65e294:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  65e29b:	00 00 00 00 00
  65e2a0:	49 89 f1             	mov    %rsi,%r9
  65e2a3:	49 d1 e9             	shr    $1,%r9
  65e2a6:	4b 8d 1c 19          	lea    (%r9,%r11,1),%rbx
  65e2aa:	4c 8d 34 5b          	lea    (%rbx,%rbx,2),%r14
  65e2ae:	47 8b 74 f2 10       	mov    0x10(%r10,%r14,8),%r14d
  65e2b3:	4c 39 f5             	cmp    %r14,%rbp
  65e2b6:	4c 0f 47 db          	cmova  %rbx,%r11
  65e2ba:	4c 29 ce             	sub    %r9,%rsi
  65e2bd:	48 83 fe 01          	cmp    $0x1,%rsi
  65e2c1:	77 dd                	ja     65e2a0 <<gpui_canvas::text::TextLayout>::position_at+0x300>
  65e2c3:	e9 ee fd ff ff       	jmp    65e0b6 <<gpui_canvas::text::TextLayout>::position_at+0x116>
  65e2c8:	4c 8b 4c 24 70       	mov    0x70(%rsp),%r9
  65e2cd:	49 3b 29             	cmp    (%r9),%rbp
  65e2d0:	0f 85 fa fd ff ff    	jne    65e0d0 <<gpui_canvas::text::TextLayout>::position_at+0x130>
  65e2d6:	e9 aa 00 00 00       	jmp    65e385 <<gpui_canvas::text::TextLayout>::position_at+0x3e5>
  65e2db:	f3 0f 11 7c 24 0c    	movss  %xmm7,0xc(%rsp)
  65e2e1:	66 0f 7e 44 24 10    	movd   %xmm0,0x10(%rsp)
  65e2e7:	89 54 24 14          	mov    %edx,0x14(%rsp)
  65e2eb:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
  65e2f2:	00 00
  65e2f4:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  65e2f9:	e8 72 e8 00 00       	call   66cb70 <<core::slice::iter::ChunkBy<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::Details>::intervals::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>
  65e2fe:	48 85 c0             	test   %rax,%rax
  65e301:	0f 85 90 02 00 00    	jne    65e597 <<gpui_canvas::text::TextLayout>::position_at+0x5f7>
  65e307:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  65e30c:	48 85 c0             	test   %rax,%rax
  65e30f:	0f 84 82 02 00 00    	je     65e597 <<gpui_canvas::text::TextLayout>::position_at+0x5f7>
  65e315:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  65e31a:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  65e320:	48 83 f8 01          	cmp    $0x1,%rax
  65e324:	8b 54 24 14          	mov    0x14(%rsp),%edx
  65e328:	66 0f 6e 44 24 10    	movd   0x10(%rsp),%xmm0
  65e32e:	f3 0f 10 7c 24 0c    	movss  0xc(%rsp),%xmm7
  65e334:	74 21                	je     65e357 <<gpui_canvas::text::TextLayout>::position_at+0x3b7>
  65e336:	48 8d 4e 28          	lea    0x28(%rsi),%rcx
  65e33a:	48 8d 78 01          	lea    0x1(%rax),%rdi
  65e33e:	44 8b 41 e8          	mov    -0x18(%rcx),%r8d
  65e342:	44 3b 01             	cmp    (%rcx),%r8d
  65e345:	75 10                	jne    65e357 <<gpui_canvas::text::TextLayout>::position_at+0x3b7>
  65e347:	49 ff c1             	inc    %r9
  65e34a:	48 83 c1 18          	add    $0x18,%rcx
  65e34e:	48 ff cf             	dec    %rdi
  65e351:	48 83 ff 02          	cmp    $0x2,%rdi
  65e355:	77 e7                	ja     65e33e <<gpui_canvas::text::TextLayout>::position_at+0x39e>
  65e357:	4c 29 c8             	sub    %r9,%rax
  65e35a:	0f 82 e8 01 00 00    	jb     65e548 <<gpui_canvas::text::TextLayout>::position_at+0x5a8>
  65e360:	4b 8d 0c 49          	lea    (%r9,%r9,2),%rcx
  65e364:	4c 8d 04 ce          	lea    (%rsi,%rcx,8),%r8
  65e368:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  65e36d:	e9 2b fe ff ff       	jmp    65e19d <<gpui_canvas::text::TextLayout>::position_at+0x1fd>
  65e372:	47 8b 4c 05 f8       	mov    -0x8(%r13,%r8,1),%r9d
  65e377:	41 b2 01             	mov    $0x1,%r10b
  65e37a:	45 89 c8             	mov    %r9d,%r8d
  65e37d:	40 b6 01             	mov    $0x1,%sil
  65e380:	0f 28 f1             	movaps %xmm1,%xmm6
  65e383:	eb 60                	jmp    65e3e5 <<gpui_canvas::text::TextLayout>::position_at+0x445>
  65e385:	46 8b 5c 16 f8       	mov    -0x8(%rsi,%r10,1),%r11d
  65e38a:	47 8b 44 05 f8       	mov    -0x8(%r13,%r8,1),%r8d
  65e38f:	f3 42 0f 10 54 16 e8 	movss  -0x18(%rsi,%r10,1),%xmm2
  65e396:	0f 28 e9             	movaps %xmm1,%xmm5
  65e399:	f3 0f 5d ea          	minss  %xmm2,%xmm5
  65e39d:	0f 28 dd             	movaps %xmm5,%xmm3
  65e3a0:	f3 0f c2 dd 03       	cmpunordss %xmm5,%xmm3
  65e3a5:	0f 28 e3             	movaps %xmm3,%xmm4
  65e3a8:	0f 55 e5             	andnps %xmm5,%xmm4
  65e3ab:	0f 54 d9             	andps  %xmm1,%xmm3
  65e3ae:	0f 56 dc             	orps   %xmm4,%xmm3
  65e3b1:	0f 28 e1             	movaps %xmm1,%xmm4
  65e3b4:	f3 0f 5f e2          	maxss  %xmm2,%xmm4
  65e3b8:	0f 28 f4             	movaps %xmm4,%xmm6
  65e3bb:	f3 0f c2 f4 03       	cmpunordss %xmm4,%xmm6
  65e3c0:	0f 28 ee             	movaps %xmm6,%xmm5
  65e3c3:	0f 55 ec             	andnps %xmm4,%xmm5
  65e3c6:	0f 54 f1             	andps  %xmm1,%xmm6
  65e3c9:	0f 56 f5             	orps   %xmm5,%xmm6
  65e3cc:	0f 2e d1             	ucomiss %xmm1,%xmm2
  65e3cf:	41 0f 97 c2          	seta   %r10b
  65e3d3:	40 0f 96 c6          	setbe  %sil
  65e3d7:	45 89 d9             	mov    %r11d,%r9d
  65e3da:	45 0f 47 c8          	cmova  %r8d,%r9d
  65e3de:	45 0f 47 c3          	cmova  %r11d,%r8d
  65e3e2:	0f 28 cb             	movaps %xmm3,%xmm1
  65e3e5:	0f 2e c8             	ucomiss %xmm0,%xmm1
  65e3e8:	76 28                	jbe    65e412 <<gpui_canvas::text::TextLayout>::position_at+0x472>
  65e3ea:	80 fa 02             	cmp    $0x2,%dl
  65e3ed:	74 4a                	je     65e439 <<gpui_canvas::text::TextLayout>::position_at+0x499>
  65e3ef:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
  65e3f5:	0f 2e d1             	ucomiss %xmm1,%xmm2
  65e3f8:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  65e3fd:	76 0e                	jbe    65e40d <<gpui_canvas::text::TextLayout>::position_at+0x46d>
  65e3ff:	f3 0f 11 4c 24 18    	movss  %xmm1,0x18(%rsp)
  65e405:	44 89 4c 24 1c       	mov    %r9d,0x1c(%rsp)
  65e40a:	44 89 d2             	mov    %r10d,%edx
  65e40d:	0f 28 f7             	movaps %xmm7,%xmm6
  65e410:	eb 3d                	jmp    65e44f <<gpui_canvas::text::TextLayout>::position_at+0x4af>
  65e412:	0f 2e c6             	ucomiss %xmm6,%xmm0
  65e415:	0f 86 46 01 00 00    	jbe    65e561 <<gpui_canvas::text::TextLayout>::position_at+0x5c1>
  65e41b:	44 0f b6 4c 24 07    	movzbl 0x7(%rsp),%r9d
  65e421:	41 80 f9 02          	cmp    $0x2,%r9b
  65e425:	74 2d                	je     65e454 <<gpui_canvas::text::TextLayout>::position_at+0x4b4>
  65e427:	0f 2e f7             	ucomiss %xmm7,%xmm6
  65e42a:	77 28                	ja     65e454 <<gpui_canvas::text::TextLayout>::position_at+0x4b4>
  65e42c:	0f 28 f7             	movaps %xmm7,%xmm6
  65e42f:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  65e434:	44 89 ce             	mov    %r9d,%esi
  65e437:	eb 1b                	jmp    65e454 <<gpui_canvas::text::TextLayout>::position_at+0x4b4>
  65e439:	f3 0f 11 4c 24 18    	movss  %xmm1,0x18(%rsp)
  65e43f:	44 89 4c 24 1c       	mov    %r9d,0x1c(%rsp)
  65e444:	44 89 d2             	mov    %r10d,%edx
  65e447:	0f 28 f7             	movaps %xmm7,%xmm6
  65e44a:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  65e44f:	0f b6 74 24 07       	movzbl 0x7(%rsp),%esi
  65e454:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  65e459:	41 89 f2             	mov    %esi,%r10d
  65e45c:	44 89 44 24 08       	mov    %r8d,0x8(%rsp)
  65e461:	0f 28 fe             	movaps %xmm6,%xmm7
  65e464:	4d 85 c9             	test   %r9,%r9
  65e467:	0f 85 42 fc ff ff    	jne    65e0af <<gpui_canvas::text::TextLayout>::position_at+0x10f>
  65e46d:	eb 0d                	jmp    65e47c <<gpui_canvas::text::TextLayout>::position_at+0x4dc>
  65e46f:	0f 28 f7             	movaps %xmm7,%xmm6
  65e472:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  65e477:	0f b6 74 24 07       	movzbl 0x7(%rsp),%esi
  65e47c:	40 80 fe 02          	cmp    $0x2,%sil
  65e480:	0f 85 35 01 00 00    	jne    65e5bb <<gpui_canvas::text::TextLayout>::position_at+0x61b>
  65e486:	80 fa 02             	cmp    $0x2,%dl
  65e489:	44 8b 44 24 1c       	mov    0x1c(%rsp),%r8d
  65e48e:	0f 85 93 00 00 00    	jne    65e527 <<gpui_canvas::text::TextLayout>::position_at+0x587>
  65e494:	49 8b 4f 38          	mov    0x38(%r15),%rcx
  65e498:	49 8b 47 40          	mov    0x40(%r15),%rax
  65e49c:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  65e4a1:	eb 02                	jmp    65e4a5 <<gpui_canvas::text::TextLayout>::position_at+0x505>
  65e4a3:	31 c0                	xor    %eax,%eax
  65e4a5:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  65e4a9:	48 8d 04 c1          	lea    (%rcx,%rax,8),%rax
  65e4ad:	eb 25                	jmp    65e4d4 <<gpui_canvas::text::TextLayout>::position_at+0x534>
  65e4af:	90                   	nop
  65e4b0:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
  65e4b4:	31 ff                	xor    %edi,%edi
  65e4b6:	42 0f 2e 44 c9 08    	ucomiss 0x8(%rcx,%r9,8),%xmm0
  65e4bc:	40 0f 93 c7          	setae  %dil
  65e4c0:	4c 01 c7             	add    %r8,%rdi
  65e4c3:	48 83 ff 01          	cmp    $0x1,%rdi
  65e4c7:	48 83 d7 ff          	adc    $0xffffffffffffffff,%rdi
  65e4cb:	48 8d 4e 18          	lea    0x18(%rsi),%rcx
  65e4cf:	48 39 d7             	cmp    %rdx,%rdi
  65e4d2:	74 65                	je     65e539 <<gpui_canvas::text::TextLayout>::position_at+0x599>
  65e4d4:	48 39 c1             	cmp    %rax,%rcx
  65e4d7:	74 4c                	je     65e525 <<gpui_canvas::text::TextLayout>::position_at+0x585>
  65e4d9:	48 89 ce             	mov    %rcx,%rsi
  65e4dc:	49 8b 7f 28          	mov    0x28(%r15),%rdi
  65e4e0:	48 85 ff             	test   %rdi,%rdi
  65e4e3:	74 e6                	je     65e4cb <<gpui_canvas::text::TextLayout>::position_at+0x52b>
  65e4e5:	f3 0f 10 46 04       	movss  0x4(%rsi),%xmm0
  65e4ea:	49 8b 4f 20          	mov    0x20(%r15),%rcx
  65e4ee:	45 31 c0             	xor    %r8d,%r8d
  65e4f1:	48 83 ff 01          	cmp    $0x1,%rdi
  65e4f5:	74 b9                	je     65e4b0 <<gpui_canvas::text::TextLayout>::position_at+0x510>
  65e4f7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  65e4fe:	00 00
  65e500:	4d 89 c1             	mov    %r8,%r9
  65e503:	49 89 fa             	mov    %rdi,%r10
  65e506:	49 d1 ea             	shr    $1,%r10
  65e509:	4d 01 d0             	add    %r10,%r8
  65e50c:	4f 8d 1c 40          	lea    (%r8,%r8,2),%r11
  65e510:	42 0f 2e 44 d9 08    	ucomiss 0x8(%rcx,%r11,8),%xmm0
  65e516:	4d 0f 42 c1          	cmovb  %r9,%r8
  65e51a:	4c 29 d7             	sub    %r10,%rdi
  65e51d:	48 83 ff 01          	cmp    $0x1,%rdi
  65e521:	77 dd                	ja     65e500 <<gpui_canvas::text::TextLayout>::position_at+0x560>
  65e523:	eb 8b                	jmp    65e4b0 <<gpui_canvas::text::TextLayout>::position_at+0x510>
  65e525:	b2 02                	mov    $0x2,%dl
  65e527:	44 89 c0             	mov    %r8d,%eax
  65e52a:	48 83 c4 78          	add    $0x78,%rsp
  65e52e:	5b                   	pop    %rbx
  65e52f:	41 5c                	pop    %r12
  65e531:	41 5d                	pop    %r13
  65e533:	41 5e                	pop    %r14
  65e535:	41 5f                	pop    %r15
  65e537:	5d                   	pop    %rbp
  65e538:	c3                   	ret
  65e539:	44 8b 46 10          	mov    0x10(%rsi),%r8d
  65e53d:	0f b6 56 14          	movzbl 0x14(%rsi),%edx
  65e541:	d0 ea                	shr    $1,%dl
  65e543:	80 e2 01             	and    $0x1,%dl
  65e546:	eb df                	jmp    65e527 <<gpui_canvas::text::TextLayout>::position_at+0x587>
  65e548:	48 8d 3d 1d 94 bf ff 	lea    -0x406be3(%rip),%rdi        # 25796c <gpui_canvas::text::PRIMARY_BYTES+0x1f4448>
  65e54f:	48 8d 15 c2 84 10 00 	lea    0x1084c2(%rip),%rdx        # 766a18 <anon.a48ffa9714aefd715eb9a00ca32a7bbf.2.llvm.9352683839858152548+0x48>
  65e556:	be 13 00 00 00       	mov    $0x13,%esi
  65e55b:	ff 15 bf 27 11 00    	call   *0x1127bf(%rip)        # 770d20 <_DYNAMIC+0x340>
  65e561:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  65e565:	0f 57 d2             	xorps  %xmm2,%xmm2
  65e568:	f3 0f 5a d6          	cvtss2sd %xmm6,%xmm2
  65e56c:	f2 0f 58 d1          	addsd  %xmm1,%xmm2
  65e570:	f2 0f 59 15 f0 2a 9c 	mulsd  -0x63d510(%rip),%xmm2        # 21068 <anon.0489ba3ebefb5402e80a192bcb938943.30.llvm.1203371347567281581+0x111>
  65e577:	ff
  65e578:	0f 57 c9             	xorps  %xmm1,%xmm1
  65e57b:	f3 0f 5a c8          	cvtss2sd %xmm0,%xmm1
  65e57f:	66 0f 2e ca          	ucomisd %xmm2,%xmm1
  65e583:	45 0f 47 c8          	cmova  %r8d,%r9d
  65e587:	40 0f b6 c6          	movzbl %sil,%eax
  65e58b:	41 0f b6 d2          	movzbl %r10b,%edx
  65e58f:	0f 47 d0             	cmova  %eax,%edx
  65e592:	45 89 c8             	mov    %r9d,%r8d
  65e595:	eb 90                	jmp    65e527 <<gpui_canvas::text::TextLayout>::position_at+0x587>
  65e597:	f3 0f 10 74 24 0c    	movss  0xc(%rsp),%xmm6
  65e59d:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  65e5a2:	0f b6 74 24 07       	movzbl 0x7(%rsp),%esi
  65e5a7:	8b 54 24 14          	mov    0x14(%rsp),%edx
  65e5ab:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  65e5b1:	40 80 fe 02          	cmp    $0x2,%sil
  65e5b5:	0f 84 cb fe ff ff    	je     65e486 <<gpui_canvas::text::TextLayout>::position_at+0x4e6>
  65e5bb:	80 fa 02             	cmp    $0x2,%dl
  65e5be:	75 07                	jne    65e5c7 <<gpui_canvas::text::TextLayout>::position_at+0x627>
  65e5c0:	89 f2                	mov    %esi,%edx
  65e5c2:	e9 60 ff ff ff       	jmp    65e527 <<gpui_canvas::text::TextLayout>::position_at+0x587>
  65e5c7:	0f 57 d2             	xorps  %xmm2,%xmm2
  65e5ca:	f3 0f 5a d6          	cvtss2sd %xmm6,%xmm2
  65e5ce:	f3 0f 10 4c 24 18    	movss  0x18(%rsp),%xmm1
  65e5d4:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  65e5d8:	f2 0f 58 ca          	addsd  %xmm2,%xmm1
  65e5dc:	f2 0f 59 0d 84 2a 9c 	mulsd  -0x63d57c(%rip),%xmm1        # 21068 <anon.0489ba3ebefb5402e80a192bcb938943.30.llvm.1203371347567281581+0x111>
  65e5e3:	ff
  65e5e4:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  65e5e8:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  65e5ec:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  65e5f0:	41 0f 46 c0          	cmovbe %r8d,%eax
  65e5f4:	41 89 c0             	mov    %eax,%r8d
  65e5f7:	0f b6 c2             	movzbl %dl,%eax
  65e5fa:	40 0f b6 d6          	movzbl %sil,%edx
  65e5fe:	0f 47 d0             	cmova  %eax,%edx
  65e601:	e9 21 ff ff ff       	jmp    65e527 <<gpui_canvas::text::TextLayout>::position_at+0x587>
  65e606:	cc                   	int3
  65e607:	cc                   	int3
  65e608:	cc                   	int3
  65e609:	cc                   	int3
  65e60a:	cc                   	int3
  65e60b:	cc                   	int3
  65e60c:	cc                   	int3
  65e60d:	cc                   	int3
  65e60e:	cc                   	int3
  65e60f:	cc                   	int3
