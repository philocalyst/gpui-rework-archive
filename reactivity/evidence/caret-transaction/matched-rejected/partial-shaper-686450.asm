
/tmp/gpui-caret-transaction-bin/matched-partial-caret_pair_measure:     file format elf64-x86-64


Disassembly of section .text:

0000000000686450 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at>:
  686450:	55                   	push   %rbp
  686451:	41 57                	push   %r15
  686453:	41 56                	push   %r14
  686455:	41 55                	push   %r13
  686457:	41 54                	push   %r12
  686459:	53                   	push   %rbx
  68645a:	48 81 ec c8 00 00 00 	sub    $0xc8,%rsp
  686461:	48 89 fb             	mov    %rdi,%rbx
  686464:	f3 0f 11 44 24 14    	movss  %xmm0,0x14(%rsp)
  68646a:	4c 8b 7e 20          	mov    0x20(%rsi),%r15
  68646e:	4c 8b 66 28          	mov    0x28(%rsi),%r12
  686472:	48 85 d2             	test   %rdx,%rdx
  686475:	0f 84 b5 01 00 00    	je     686630 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1e0>
  68647b:	48 8d 42 ff          	lea    -0x1(%rdx),%rax
  68647f:	4c 39 e0             	cmp    %r12,%rax
  686482:	0f 83 a8 01 00 00    	jae    686630 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1e0>
  686488:	45 8b 6c 97 fc       	mov    -0x4(%r15,%rdx,4),%r13d
  68648d:	4c 39 e2             	cmp    %r12,%rdx
  686490:	0f 83 c1 01 00 00    	jae    686657 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x207>
  686496:	4c 8b 76 08          	mov    0x8(%rsi),%r14
  68649a:	48 8b 6e 10          	mov    0x10(%rsi),%rbp
  68649e:	4c 39 ed             	cmp    %r13,%rbp
  6864a1:	0f 86 b8 01 00 00    	jbe    68665f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
  6864a7:	45 8b 14 97          	mov    (%r15,%rdx,4),%r10d
  6864ab:	4c 39 d5             	cmp    %r10,%rbp
  6864ae:	0f 86 ab 01 00 00    	jbe    68665f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
  6864b4:	4d 89 e8             	mov    %r13,%r8
  6864b7:	49 c1 e0 04          	shl    $0x4,%r8
  6864bb:	4d 01 f0             	add    %r14,%r8
  6864be:	4d 89 d1             	mov    %r10,%r9
  6864c1:	49 c1 e1 04          	shl    $0x4,%r9
  6864c5:	41 8b 08             	mov    (%r8),%ecx
  6864c8:	43 3b 0c 0e          	cmp    (%r14,%r9,1),%ecx
  6864cc:	0f 85 8d 01 00 00    	jne    68665f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
  6864d2:	4d 01 f1             	add    %r14,%r9
  6864d5:	41 8b 40 04          	mov    0x4(%r8),%eax
  6864d9:	41 3b 41 04          	cmp    0x4(%r9),%eax
  6864dd:	0f 85 7c 01 00 00    	jne    68665f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
  6864e3:	48 8b 7e 30          	mov    0x30(%rsi),%rdi
  6864e7:	48 39 8f 18 01 00 00 	cmp    %rcx,0x118(%rdi)
  6864ee:	0f 86 6b 01 00 00    	jbe    68665f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
  6864f4:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
  6864f9:	4c 89 4c 24 30       	mov    %r9,0x30(%rsp)
  6864fe:	4c 89 44 24 38       	mov    %r8,0x38(%rsp)
  686503:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
  686509:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  68650e:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  686513:	48 6b d1 70          	imul   $0x70,%rcx,%rdx
  686517:	48 03 97 10 01 00 00 	add    0x110(%rdi),%rdx
  68651e:	48 89 bc 24 88 00 00 	mov    %rdi,0x88(%rsp)
  686525:	00 
  686526:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  68652d:	00 
  68652e:	89 8c 24 98 00 00 00 	mov    %ecx,0x98(%rsp)
  686535:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  68653a:	48 8d b4 24 88 00 00 	lea    0x88(%rsp),%rsi
  686541:	00 
  686542:	48 89 c2             	mov    %rax,%rdx
  686545:	e8 56 fe ff ff       	call   6863a0 <<parley::layout::line::Line<()>>::item>
  68654a:	83 7c 24 40 01       	cmpl   $0x1,0x40(%rsp)
  68654f:	0f 85 4a 01 00 00    	jne    68669f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x24f>
  686555:	48 83 7c 24 48 00    	cmpq   $0x0,0x48(%rsp)
  68655b:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  686560:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  686565:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  68656b:	0f 84 ee 00 00 00    	je     68665f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
  686571:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  686576:	0f b6 80 8c 00 00 00 	movzbl 0x8c(%rax),%eax
  68657d:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
  686582:	49 8d 49 01          	lea    0x1(%r9),%rcx
  686586:	31 ff                	xor    %edi,%edi
  686588:	4c 39 e9             	cmp    %r13,%rcx
  68658b:	40 0f 94 c7          	sete   %dil
  68658f:	49 8d 4d 01          	lea    0x1(%r13),%rcx
  686593:	45 31 c0             	xor    %r8d,%r8d
  686596:	4c 39 c9             	cmp    %r9,%rcx
  686599:	41 0f 94 c0          	sete   %r8b
  68659d:	24 01                	and    $0x1,%al
  68659f:	88 44 24 0f          	mov    %al,0xf(%rsp)
  6865a3:	41 0f 44 f8          	cmove  %r8d,%edi
  6865a7:	48 8d 84 24 88 00 00 	lea    0x88(%rsp),%rax
  6865ae:	00 
  6865af:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6865b4:	48 8d 44 24 14       	lea    0x14(%rsp),%rax
  6865b9:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6865be:	48 8d 44 24 0f       	lea    0xf(%rsp),%rax
  6865c3:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6865c8:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6865cd:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6865d2:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6865d7:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6865dc:	40 84 ff             	test   %dil,%dil
  6865df:	74 7e                	je     68665f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
  6865e1:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  6865e8:	00 
  6865e9:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  6865ee:	e8 2d fd ff ff       	call   686320 <<parley::editing::geometry::CursorGeometry<()>>::shared_edge::{closure#0}>
  6865f3:	0f 10 84 24 a8 00 00 	movups 0xa8(%rsp),%xmm0
  6865fa:	00 
  6865fb:	0f 10 8c 24 b8 00 00 	movups 0xb8(%rsp),%xmm1
  686602:	00 
  686603:	0f 29 4c 24 70       	movaps %xmm1,0x70(%rsp)
  686608:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  68660d:	0f 29 4c 24 50       	movaps %xmm1,0x50(%rsp)
  686612:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  686617:	0f 11 4b 38          	movups %xmm1,0x38(%rbx)
  68661b:	0f 11 4b 18          	movups %xmm1,0x18(%rbx)
  68661f:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  686623:	0f 11 43 28          	movups %xmm0,0x28(%rbx)
  686627:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  68662e:	eb 5a                	jmp    68668a <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x23a>
  686630:	31 c9                	xor    %ecx,%ecx
  686632:	48 8b 46 30          	mov    0x30(%rsi),%rax
  686636:	4c 39 e2             	cmp    %r12,%rdx
  686639:	73 40                	jae    68667b <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x22b>
  68663b:	41 8b 3c 97          	mov    (%r15,%rdx,4),%edi
  68663f:	49 89 f9             	mov    %rdi,%r9
  686642:	49 c1 e1 04          	shl    $0x4,%r9
  686646:	4c 03 4e 08          	add    0x8(%rsi),%r9
  68664a:	45 31 c0             	xor    %r8d,%r8d
  68664d:	48 39 7e 10          	cmp    %rdi,0x10(%rsi)
  686651:	4d 0f 47 c1          	cmova  %r9,%r8
  686655:	eb 27                	jmp    68667e <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x22e>
  686657:	4c 8b 76 08          	mov    0x8(%rsi),%r14
  68665b:	48 8b 6e 10          	mov    0x10(%rsi),%rbp
  68665f:	4c 89 e8             	mov    %r13,%rax
  686662:	48 c1 e0 04          	shl    $0x4,%rax
  686666:	4c 01 f0             	add    %r14,%rax
  686669:	31 c9                	xor    %ecx,%ecx
  68666b:	4c 39 ed             	cmp    %r13,%rbp
  68666e:	48 0f 47 c8          	cmova  %rax,%rcx
  686672:	48 8b 46 30          	mov    0x30(%rsi),%rax
  686676:	4c 39 e2             	cmp    %r12,%rdx
  686679:	72 c0                	jb     68663b <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1eb>
  68667b:	45 31 c0             	xor    %r8d,%r8d
  68667e:	48 89 df             	mov    %rbx,%rdi
  686681:	48 89 c6             	mov    %rax,%rsi
  686684:	ff 15 96 30 10 00    	call   *0x103096(%rip)        # 789720 <_DYNAMIC+0x908>
  68668a:	48 89 d8             	mov    %rbx,%rax
  68668d:	48 81 c4 c8 00 00 00 	add    $0xc8,%rsp
  686694:	5b                   	pop    %rbx
  686695:	41 5c                	pop    %r12
  686697:	41 5d                	pop    %r13
  686699:	41 5e                	pop    %r14
  68669b:	41 5f                	pop    %r15
  68669d:	5d                   	pop    %rbp
  68669e:	c3                   	ret
  68669f:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6866a4:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  6866a9:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  6866af:	eb ae                	jmp    68665f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
