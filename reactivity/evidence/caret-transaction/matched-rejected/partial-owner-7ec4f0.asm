
/tmp/gpui-caret-transaction-bin/matched-partial-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007ec4f0 <<parley::editing::geometry::CursorGeometry<()>>::new>:
  7ec4f0:	55                   	push   %rbp
  7ec4f1:	41 57                	push   %r15
  7ec4f3:	41 56                	push   %r14
  7ec4f5:	41 55                	push   %r13
  7ec4f7:	41 54                	push   %r12
  7ec4f9:	53                   	push   %rbx
  7ec4fa:	48 81 ec 18 04 00 00 	sub    $0x418,%rsp
  7ec501:	4c 8b 7e 70          	mov    0x70(%rsi),%r15
  7ec505:	4c 89 f8             	mov    %r15,%rax
  7ec508:	48 c1 e8 20          	shr    $0x20,%rax
  7ec50c:	75 10                	jne    7ec51e <<parley::editing::geometry::CursorGeometry<()>>::new+0x2e>
  7ec50e:	48 8b 9e 18 01 00 00 	mov    0x118(%rsi),%rbx
  7ec515:	48 89 d8             	mov    %rbx,%rax
  7ec518:	48 c1 e8 20          	shr    $0x20,%rax
  7ec51c:	74 1c                	je     7ec53a <<parley::editing::geometry::CursorGeometry<()>>::new+0x4a>
  7ec51e:	48 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%rdi)
  7ec525:	48 89 f8             	mov    %rdi,%rax
  7ec528:	48 81 c4 18 04 00 00 	add    $0x418,%rsp
  7ec52f:	5b                   	pop    %rbx
  7ec530:	41 5c                	pop    %r12
  7ec532:	41 5d                	pop    %r13
  7ec534:	41 5e                	pop    %r14
  7ec536:	41 5f                	pop    %r15
  7ec538:	5d                   	pop    %rbp
  7ec539:	c3                   	ret
  7ec53a:	4d 89 fe             	mov    %r15,%r14
  7ec53d:	49 c1 e6 04          	shl    $0x4,%r14
  7ec541:	4d 85 ff             	test   %r15,%r15
  7ec544:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  7ec549:	74 2f                	je     7ec57a <<parley::editing::geometry::CursorGeometry<()>>::new+0x8a>
  7ec54b:	49 89 fc             	mov    %rdi,%r12
  7ec54e:	ff 15 0c 12 34 00    	call   *0x34120c(%rip)        # b2d760 <_DYNAMIC+0x260>
  7ec554:	be 04 00 00 00       	mov    $0x4,%esi
  7ec559:	4c 89 f7             	mov    %r14,%rdi
  7ec55c:	ff 15 de 11 34 00    	call   *0x3411de(%rip)        # b2d740 <_DYNAMIC+0x240>
  7ec562:	48 85 c0             	test   %rax,%rax
  7ec565:	0f 84 c3 07 00 00    	je     7ecd2e <<parley::editing::geometry::CursorGeometry<()>>::new+0x83e>
  7ec56b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7ec570:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  7ec575:	4c 89 e7             	mov    %r12,%rdi
  7ec578:	eb 0a                	jmp    7ec584 <<parley::editing::geometry::CursorGeometry<()>>::new+0x94>
  7ec57a:	b8 04 00 00 00       	mov    $0x4,%eax
  7ec57f:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7ec584:	48 b9 f8 ff ff ff ff 	movabs $0x7ffffffffffffff8,%rcx
  7ec58b:	ff ff 7f 
  7ec58e:	48 8b 96 50 01 00 00 	mov    0x150(%rsi),%rdx
  7ec595:	4c 8d 24 95 00 00 00 	lea    0x0(,%rdx,4),%r12
  7ec59c:	00 
  7ec59d:	48 89 d0             	mov    %rdx,%rax
  7ec5a0:	48 c1 e8 3e          	shr    $0x3e,%rax
  7ec5a4:	0f 95 c0             	setne  %al
  7ec5a7:	48 83 c1 04          	add    $0x4,%rcx
  7ec5ab:	49 39 cc             	cmp    %rcx,%r12
  7ec5ae:	0f 97 c1             	seta   %cl
  7ec5b1:	08 c1                	or     %al,%cl
  7ec5b3:	74 13                	je     7ec5c8 <<parley::editing::geometry::CursorGeometry<()>>::new+0xd8>
  7ec5b5:	31 ed                	xor    %ebp,%ebp
  7ec5b7:	48 89 ef             	mov    %rbp,%rdi
  7ec5ba:	4c 89 e6             	mov    %r12,%rsi
  7ec5bd:	ff 15 15 12 34 00    	call   *0x341215(%rip)        # b2d7d8 <_DYNAMIC+0x2d8>
  7ec5c3:	e9 c4 07 00 00       	jmp    7ecd8c <<parley::editing::geometry::CursorGeometry<()>>::new+0x89c>
  7ec5c8:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  7ec5cd:	48 89 bc 24 88 00 00 	mov    %rdi,0x88(%rsp)
  7ec5d4:	00 
  7ec5d5:	4d 85 e4             	test   %r12,%r12
  7ec5d8:	74 5b                	je     7ec635 <<parley::editing::geometry::CursorGeometry<()>>::new+0x145>
  7ec5da:	ff 15 80 11 34 00    	call   *0x341180(%rip)        # b2d760 <_DYNAMIC+0x260>
  7ec5e0:	bd 04 00 00 00       	mov    $0x4,%ebp
  7ec5e5:	be 04 00 00 00       	mov    $0x4,%esi
  7ec5ea:	4c 89 e7             	mov    %r12,%rdi
  7ec5ed:	ff 15 4d 11 34 00    	call   *0x34114d(%rip)        # b2d740 <_DYNAMIC+0x240>
  7ec5f3:	48 85 c0             	test   %rax,%rax
  7ec5f6:	74 bf                	je     7ec5b7 <<parley::editing::geometry::CursorGeometry<()>>::new+0xc7>
  7ec5f8:	49 89 c5             	mov    %rax,%r13
  7ec5fb:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  7ec600:	49 89 ce             	mov    %rcx,%r14
  7ec603:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  7ec608:	48 83 f9 02          	cmp    $0x2,%rcx
  7ec60c:	72 3b                	jb     7ec649 <<parley::editing::geometry::CursorGeometry<()>>::new+0x159>
  7ec60e:	49 8d 54 24 fc       	lea    -0x4(%r12),%rdx
  7ec613:	4c 89 ef             	mov    %r13,%rdi
  7ec616:	be ff 00 00 00       	mov    $0xff,%esi
  7ec61b:	ff 15 af 16 34 00    	call   *0x3416af(%rip)        # b2dcd0 <memset@GLIBC_2.2.5>
  7ec621:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  7ec626:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
  7ec62a:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  7ec62e:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  7ec633:	eb 21                	jmp    7ec656 <<parley::editing::geometry::CursorGeometry<()>>::new+0x166>
  7ec635:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  7ec63b:	45 31 f6             	xor    %r14d,%r14d
  7ec63e:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  7ec643:	48 83 f9 02          	cmp    $0x2,%rcx
  7ec647:	73 c5                	jae    7ec60e <<parley::editing::geometry::CursorGeometry<()>>::new+0x11e>
  7ec649:	4c 89 e8             	mov    %r13,%rax
  7ec64c:	48 85 c9             	test   %rcx,%rcx
  7ec64f:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  7ec654:	74 06                	je     7ec65c <<parley::editing::geometry::CursorGeometry<()>>::new+0x16c>
  7ec656:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%rax)
  7ec65c:	4c 89 74 24 58       	mov    %r14,0x58(%rsp)
  7ec661:	4c 89 6c 24 60       	mov    %r13,0x60(%rsp)
  7ec666:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  7ec66b:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  7ec670:	48 89 74 24 70       	mov    %rsi,0x70(%rsp)
  7ec675:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
  7ec67a:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
  7ec67f:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  7ec686:	00 00 
  7ec688:	48 85 db             	test   %rbx,%rbx
  7ec68b:	0f 84 22 06 00 00    	je     7eccb3 <<parley::editing::geometry::CursorGeometry<()>>::new+0x7c3>
  7ec691:	4c 8b a6 10 01 00 00 	mov    0x110(%rsi),%r12
  7ec698:	4c 6b c3 70          	imul   $0x70,%rbx,%r8
  7ec69c:	4d 01 e0             	add    %r12,%r8
  7ec69f:	4c 8d ac 24 e8 01 00 	lea    0x1e8(%rsp),%r13
  7ec6a6:	00 
  7ec6a7:	48 8b 96 30 01 00 00 	mov    0x130(%rsi),%rdx
  7ec6ae:	4c 8b 8e 28 01 00 00 	mov    0x128(%rsi),%r9
  7ec6b5:	48 8b 4e 58          	mov    0x58(%rsi),%rcx
  7ec6b9:	4c 8b 96 e8 00 00 00 	mov    0xe8(%rsi),%r10
  7ec6c0:	48 8b 9e e0 00 00 00 	mov    0xe0(%rsi),%rbx
  7ec6c7:	4c 8b 5e 50          	mov    0x50(%rsi),%r11
  7ec6cb:	48 8b 46 38          	mov    0x38(%rsi),%rax
  7ec6cf:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  7ec6d6:	00 
  7ec6d7:	48 8b 46 40          	mov    0x40(%rsi),%rax
  7ec6db:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  7ec6e2:	00 
  7ec6e3:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  7ec6ea:	00 00 
  7ec6ec:	48 8d 05 ed af 31 00 	lea    0x31afed(%rip),%rax        # b076e0 <anon.8b5fc042aaf44ecdb8851cb64b83294a.9.llvm.11756661080873179907+0x18>
  7ec6f3:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  7ec6f8:	48 8d 05 51 bb 31 00 	lea    0x31bb51(%rip),%rax        # b08250 <anon.e1aed3256c0f336e2763058c1a348a1e.18.llvm.17407148579165845042>
  7ec6ff:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  7ec704:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  7ec709:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  7ec710:	00 
  7ec711:	4c 89 84 24 b8 00 00 	mov    %r8,0xb8(%rsp)
  7ec718:	00 
  7ec719:	4c 89 8c 24 b0 00 00 	mov    %r9,0xb0(%rsp)
  7ec720:	00 
  7ec721:	4c 89 94 24 a8 00 00 	mov    %r10,0xa8(%rsp)
  7ec728:	00 
  7ec729:	48 89 9c 24 c8 00 00 	mov    %rbx,0xc8(%rsp)
  7ec730:	00 
  7ec731:	4c 89 9c 24 a0 00 00 	mov    %r11,0xa0(%rsp)
  7ec738:	00 
  7ec739:	49 8b 7c 24 10       	mov    0x10(%r12),%rdi
  7ec73e:	49 8b 44 24 18       	mov    0x18(%r12),%rax
  7ec743:	48 39 f8             	cmp    %rdi,%rax
  7ec746:	0f 82 b5 05 00 00    	jb     7ecd01 <<parley::editing::geometry::CursorGeometry<()>>::new+0x811>
  7ec74c:	48 39 d0             	cmp    %rdx,%rax
  7ec74f:	0f 87 ac 05 00 00    	ja     7ecd01 <<parley::editing::geometry::CursorGeometry<()>>::new+0x811>
  7ec755:	48 39 c7             	cmp    %rax,%rdi
  7ec758:	75 1a                	jne    7ec774 <<parley::editing::geometry::CursorGeometry<()>>::new+0x284>
  7ec75a:	49 83 c4 70          	add    $0x70,%r12
  7ec75e:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7ec763:	ff c0                	inc    %eax
  7ec765:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  7ec76a:	4d 39 c4             	cmp    %r8,%r12
  7ec76d:	75 ca                	jne    7ec739 <<parley::editing::geometry::CursorGeometry<()>>::new+0x249>
  7ec76f:	e9 3f 05 00 00       	jmp    7eccb3 <<parley::editing::geometry::CursorGeometry<()>>::new+0x7c3>
  7ec774:	f3 41 0f 10 44 24 28 	movss  0x28(%r12),%xmm0
  7ec77b:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
  7ec781:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  7ec785:	4d 8d 34 c1          	lea    (%r9,%rax,8),%r14
  7ec789:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  7ec78d:	4d 8d 3c c1          	lea    (%r9,%rax,8),%r15
  7ec791:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%rsp)
  7ec798:	00 
  7ec799:	4c 89 b4 24 d0 00 00 	mov    %r14,0xd0(%rsp)
  7ec7a0:	00 
  7ec7a1:	49 8b 7f 10          	mov    0x10(%r15),%rdi
  7ec7a5:	41 80 7f 21 01       	cmpb   $0x1,0x21(%r15)
  7ec7aa:	75 42                	jne    7ec7ee <<parley::editing::geometry::CursorGeometry<()>>::new+0x2fe>
  7ec7ac:	48 3b bc 24 80 00 00 	cmp    0x80(%rsp),%rdi
  7ec7b3:	00 
  7ec7b4:	0f 83 a9 05 00 00    	jae    7ecd63 <<parley::editing::geometry::CursorGeometry<()>>::new+0x873>
  7ec7ba:	48 6b c7 38          	imul   $0x38,%rdi,%rax
  7ec7be:	48 8b bc 24 d8 00 00 	mov    0xd8(%rsp),%rdi
  7ec7c5:	00 
  7ec7c6:	f3 0f 10 44 07 24    	movss  0x24(%rdi,%rax,1),%xmm0
  7ec7cc:	49 83 c7 28          	add    $0x28,%r15
  7ec7d0:	ff 44 24 14          	incl   0x14(%rsp)
  7ec7d4:	f3 0f 10 4c 24 10    	movss  0x10(%rsp),%xmm1
  7ec7da:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  7ec7de:	f3 0f 11 4c 24 10    	movss  %xmm1,0x10(%rsp)
  7ec7e4:	4d 39 f7             	cmp    %r14,%r15
  7ec7e7:	75 b8                	jne    7ec7a1 <<parley::editing::geometry::CursorGeometry<()>>::new+0x2b1>
  7ec7e9:	e9 6c ff ff ff       	jmp    7ec75a <<parley::editing::geometry::CursorGeometry<()>>::new+0x26a>
  7ec7ee:	48 39 cf             	cmp    %rcx,%rdi
  7ec7f1:	0f 83 85 05 00 00    	jae    7ecd7c <<parley::editing::geometry::CursorGeometry<()>>::new+0x88c>
  7ec7f7:	4c 39 d7             	cmp    %r10,%rdi
  7ec7fa:	0f 83 55 05 00 00    	jae    7ecd55 <<parley::editing::geometry::CursorGeometry<()>>::new+0x865>
  7ec800:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
  7ec804:	48 c1 e0 04          	shl    $0x4,%rax
  7ec808:	49 8d 0c 03          	lea    (%r11,%rax,1),%rcx
  7ec80c:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  7ec810:	48 c1 e2 04          	shl    $0x4,%rdx
  7ec814:	48 01 da             	add    %rbx,%rdx
  7ec817:	48 89 b4 24 20 01 00 	mov    %rsi,0x120(%rsp)
  7ec81e:	00 
  7ec81f:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  7ec826:	00 
  7ec827:	48 89 94 24 30 01 00 	mov    %rdx,0x130(%rsp)
  7ec82e:	00 
  7ec82f:	4c 89 bc 24 38 01 00 	mov    %r15,0x138(%rsp)
  7ec836:	00 
  7ec837:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  7ec83c:	89 8c 24 40 01 00 00 	mov    %ecx,0x140(%rsp)
  7ec843:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  7ec847:	89 8c 24 44 01 00 00 	mov    %ecx,0x144(%rsp)
  7ec84e:	89 bc 24 48 01 00 00 	mov    %edi,0x148(%rsp)
  7ec855:	41 0f b6 94 03 8c 00 	movzbl 0x8c(%r11,%rax,1),%edx
  7ec85c:	00 00 
  7ec85e:	83 e2 01             	and    $0x1,%edx
  7ec861:	4c 8d b4 24 08 03 00 	lea    0x308(%rsp),%r14
  7ec868:	00 
  7ec869:	4c 89 f7             	mov    %r14,%rdi
  7ec86c:	48 8d b4 24 20 01 00 	lea    0x120(%rsp),%rsi
  7ec873:	00 
  7ec874:	e8 f7 e0 00 00       	call   7fa970 <<parley::layout::run::Clusters<()>>::new>
  7ec879:	ba 10 01 00 00       	mov    $0x110,%edx
  7ec87e:	48 8d 9c 24 f8 01 00 	lea    0x1f8(%rsp),%rbx
  7ec885:	00 
  7ec886:	48 89 df             	mov    %rbx,%rdi
  7ec889:	4c 89 f6             	mov    %r14,%rsi
  7ec88c:	ff 15 de 0e 34 00    	call   *0x340ede(%rip)        # b2d770 <memcpy@GLIBC_2.14>
  7ec892:	66 0f 6e 44 24 10    	movd   0x10(%rsp),%xmm0
  7ec898:	66 0f 7e 44 24 08    	movd   %xmm0,0x8(%rsp)
  7ec89e:	eb 18                	jmp    7ec8b8 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3c8>
  7ec8a0:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
  7ec8a6:	f3 0f 58 c1          	addss  %xmm1,%xmm0
  7ec8aa:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  7ec8b0:	48 8d 9c 24 f8 01 00 	lea    0x1f8(%rsp),%rbx
  7ec8b7:	00 
  7ec8b8:	48 8d bc 24 68 01 00 	lea    0x168(%rsp),%rdi
  7ec8bf:	00 
  7ec8c0:	48 89 de             	mov    %rbx,%rsi
  7ec8c3:	e8 98 e3 00 00       	call   7fac60 <<parley::layout::run::Clusters<()>>::advance_cursor>
  7ec8c8:	83 bc 24 68 01 00 00 	cmpl   $0x1,0x168(%rsp)
  7ec8cf:	01 
  7ec8d0:	0f 85 2b 03 00 00    	jne    7ecc01 <<parley::editing::geometry::CursorGeometry<()>>::new+0x711>
  7ec8d6:	41 0f 10 45 84       	movups -0x7c(%r13),%xmm0
  7ec8db:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  7ec8e2:	00 
  7ec8e3:	48 8b 84 24 b0 02 00 	mov    0x2b0(%rsp),%rax
  7ec8ea:	00 
  7ec8eb:	48 85 c0             	test   %rax,%rax
  7ec8ee:	0f 84 1f 04 00 00    	je     7ecd13 <<parley::editing::geometry::CursorGeometry<()>>::new+0x823>
  7ec8f4:	48 8b 9c 24 f8 01 00 	mov    0x1f8(%rsp),%rbx
  7ec8fb:	00 
  7ec8fc:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
  7ec903:	00 
  7ec904:	0f 29 84 24 50 01 00 	movaps %xmm0,0x150(%rsp)
  7ec90b:	00 
  7ec90c:	48 85 db             	test   %rbx,%rbx
  7ec90f:	0f 84 ec 02 00 00    	je     7ecc01 <<parley::editing::geometry::CursorGeometry<()>>::new+0x711>
  7ec915:	48 89 9c 24 68 01 00 	mov    %rbx,0x168(%rsp)
  7ec91c:	00 
  7ec91d:	48 8d 94 24 b8 02 00 	lea    0x2b8(%rsp),%rdx
  7ec924:	00 
  7ec925:	48 8b 8a 68 ff ff ff 	mov    -0x98(%rdx),%rcx
  7ec92c:	49 89 4d a8          	mov    %rcx,-0x58(%r13)
  7ec930:	0f 10 82 48 ff ff ff 	movups -0xb8(%rdx),%xmm0
  7ec937:	0f 10 8a 58 ff ff ff 	movups -0xa8(%rdx),%xmm1
  7ec93e:	41 0f 11 4d 98       	movups %xmm1,-0x68(%r13)
  7ec943:	41 0f 11 45 88       	movups %xmm0,-0x78(%r13)
  7ec948:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
  7ec94f:	00 
  7ec950:	48 8b 42 40          	mov    0x40(%rdx),%rax
  7ec954:	49 89 45 f8          	mov    %rax,-0x8(%r13)
  7ec958:	0f 10 02             	movups (%rdx),%xmm0
  7ec95b:	f3 0f 6f 4a 10       	movdqu 0x10(%rdx),%xmm1
  7ec960:	0f 10 52 20          	movups 0x20(%rdx),%xmm2
  7ec964:	0f 10 5a 30          	movups 0x30(%rdx),%xmm3
  7ec968:	41 0f 11 5d e8       	movups %xmm3,-0x18(%r13)
  7ec96d:	41 0f 11 55 d8       	movups %xmm2,-0x28(%r13)
  7ec972:	f3 41 0f 7f 4d c8    	movdqu %xmm1,-0x38(%r13)
  7ec978:	41 0f 11 45 b8       	movups %xmm0,-0x48(%r13)
  7ec97d:	0f 28 84 24 50 01 00 	movaps 0x150(%rsp),%xmm0
  7ec984:	00 
  7ec985:	41 0f 11 45 00       	movups %xmm0,0x0(%r13)
  7ec98a:	4c 8b 74 24 50       	mov    0x50(%rsp),%r14
  7ec98f:	f3 0f 7e 84 24 88 01 	movq   0x188(%rsp),%xmm0
  7ec996:	00 00 
  7ec998:	66 0f 7f 84 24 90 00 	movdqa %xmm0,0x90(%rsp)
  7ec99f:	00 00 
  7ec9a1:	8b ac 24 e8 01 00 00 	mov    0x1e8(%rsp),%ebp
  7ec9a8:	4c 3b 74 24 40       	cmp    0x40(%rsp),%r14
  7ec9ad:	75 0b                	jne    7ec9ba <<parley::editing::geometry::CursorGeometry<()>>::new+0x4ca>
  7ec9af:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  7ec9b4:	ff 15 be 19 34 00    	call   *0x3419be(%rip)        # b2e378 <_DYNAMIC+0xe78>
  7ec9ba:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  7ec9bf:	4c 89 f1             	mov    %r14,%rcx
  7ec9c2:	48 c1 e1 04          	shl    $0x4,%rcx
  7ec9c6:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  7ec9cd:	00 
  7ec9ce:	0f 13 04 08          	movlps %xmm0,(%rax,%rcx,1)
  7ec9d2:	89 6c 08 08          	mov    %ebp,0x8(%rax,%rcx,1)
  7ec9d6:	66 0f 6e 44 24 08    	movd   0x8(%rsp),%xmm0
  7ec9dc:	66 0f 7e 44 08 0c    	movd   %xmm0,0xc(%rax,%rcx,1)
  7ec9e2:	49 8d 46 01          	lea    0x1(%r14),%rax
  7ec9e6:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  7ec9eb:	48 83 bc 24 80 01 00 	cmpq   $0x0,0x180(%rsp)
  7ec9f2:	00 00 
  7ec9f4:	74 2e                	je     7eca24 <<parley::editing::geometry::CursorGeometry<()>>::new+0x534>
  7ec9f6:	8b bc 24 88 01 00 00 	mov    0x188(%rsp),%edi
  7ec9fd:	48 8b b3 18 01 00 00 	mov    0x118(%rbx),%rsi
  7eca04:	48 39 fe             	cmp    %rdi,%rsi
  7eca07:	0f 86 3b 03 00 00    	jbe    7ecd48 <<parley::editing::geometry::CursorGeometry<()>>::new+0x858>
  7eca0d:	48 8b 83 10 01 00 00 	mov    0x110(%rbx),%rax
  7eca14:	48 6b cf 70          	imul   $0x70,%rdi,%rcx
  7eca18:	66 0f 6e 44 08 50    	movd   0x50(%rax,%rcx,1),%xmm0
  7eca1e:	8b 44 08 54          	mov    0x54(%rax,%rcx,1),%eax
  7eca22:	eb 09                	jmp    7eca2d <<parley::editing::geometry::CursorGeometry<()>>::new+0x53d>
  7eca24:	66 0f ef c0          	pxor   %xmm0,%xmm0
  7eca28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  7eca2d:	48 8b 8c 24 70 01 00 	mov    0x170(%rsp),%rcx
  7eca34:	00 
  7eca35:	48 8b 94 24 78 01 00 	mov    0x178(%rsp),%rdx
  7eca3c:	00 
  7eca3d:	f3 0f 7e 4a 44       	movq   0x44(%rdx),%xmm1
  7eca42:	66 0f d6 8c 24 e0 00 	movq   %xmm1,0xe0(%rsp)
  7eca49:	00 00 
  7eca4b:	66 0f 7e 84 24 e8 00 	movd   %xmm0,0xe8(%rsp)
  7eca52:	00 00 
  7eca54:	89 84 24 ec 00 00 00 	mov    %eax,0xec(%rsp)
  7eca5b:	0f b6 89 8c 00 00 00 	movzbl 0x8c(%rcx),%ecx
  7eca62:	83 e1 01             	and    $0x1,%ecx
  7eca65:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
  7eca6c:	00 
  7eca6d:	48 8d b4 24 98 01 00 	lea    0x198(%rsp),%rsi
  7eca74:	00 
  7eca75:	4c 89 ea             	mov    %r13,%rdx
  7eca78:	ff 15 02 19 34 00    	call   *0x341902(%rip)        # b2e380 <_DYNAMIC+0xe80>
  7eca7e:	66 0f 6f c8          	movdqa %xmm0,%xmm1
  7eca82:	48 83 7c 24 28 00    	cmpq   $0x0,0x28(%rsp)
  7eca88:	0f 84 12 fe ff ff    	je     7ec8a0 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3b0>
  7eca8e:	66 0f 7e 8c 24 90 00 	movd   %xmm1,0x90(%rsp)
  7eca95:	00 00 
  7eca97:	8b bc 24 90 01 00 00 	mov    0x190(%rsp),%edi
  7eca9e:	48 8b 73 58          	mov    0x58(%rbx),%rsi
  7ecaa2:	48 39 fe             	cmp    %rdi,%rsi
  7ecaa5:	0f 86 91 02 00 00    	jbe    7ecd3c <<parley::editing::geometry::CursorGeometry<()>>::new+0x84c>
  7ecaab:	48 8b 43 50          	mov    0x50(%rbx),%rax
  7ecaaf:	48 8d 0c ff          	lea    (%rdi,%rdi,8),%rcx
  7ecab3:	48 c1 e1 04          	shl    $0x4,%rcx
  7ecab7:	f3 0f 6f 43 68       	movdqu 0x68(%rbx),%xmm0
  7ecabc:	0f 10 8b 80 00 00 00 	movups 0x80(%rbx),%xmm1
  7ecac3:	0f 10 93 98 00 00 00 	movups 0x98(%rbx),%xmm2
  7ecaca:	f3 0f 7f 84 24 e0 00 	movdqu %xmm0,0xe0(%rsp)
  7ecad1:	00 00 
  7ecad3:	0f 11 8c 24 f0 00 00 	movups %xmm1,0xf0(%rsp)
  7ecada:	00 
  7ecadb:	0f 11 94 24 00 01 00 	movups %xmm2,0x100(%rsp)
  7ecae2:	00 
  7ecae3:	48 8b 44 08 50       	mov    0x50(%rax,%rcx,1),%rax
  7ecae8:	48 89 84 24 10 01 00 	mov    %rax,0x110(%rsp)
  7ecaef:	00 
  7ecaf0:	8b b4 24 e8 01 00 00 	mov    0x1e8(%rsp),%esi
  7ecaf7:	8b 94 24 ec 01 00 00 	mov    0x1ec(%rsp),%edx
  7ecafe:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
  7ecb05:	00 
  7ecb06:	ff 15 64 18 34 00    	call   *0x341864(%rip)        # b2e370 <_DYNAMIC+0xe70>
  7ecb0c:	66 0f 6e 8c 24 90 00 	movd   0x90(%rsp),%xmm1
  7ecb13:	00 00 
  7ecb15:	48 8b 6c 24 60       	mov    0x60(%rsp),%rbp
  7ecb1a:	48 39 c2             	cmp    %rax,%rdx
  7ecb1d:	0f 82 32 01 00 00    	jb     7ecc55 <<parley::editing::geometry::CursorGeometry<()>>::new+0x765>
  7ecb23:	48 3b 54 24 68       	cmp    0x68(%rsp),%rdx
  7ecb28:	0f 87 27 01 00 00    	ja     7ecc55 <<parley::editing::geometry::CursorGeometry<()>>::new+0x765>
  7ecb2e:	48 89 d1             	mov    %rdx,%rcx
  7ecb31:	48 29 c1             	sub    %rax,%rcx
  7ecb34:	48 8d 34 85 00 00 00 	lea    0x0(,%rax,4),%rsi
  7ecb3b:	00 
  7ecb3c:	48 01 ee             	add    %rbp,%rsi
  7ecb3f:	4c 8d 04 85 00 00 00 	lea    0x0(,%rax,4),%r8
  7ecb46:	00 
  7ecb47:	48 8d 3c 95 00 00 00 	lea    0x0(,%rdx,4),%rdi
  7ecb4e:	00 
  7ecb4f:	90                   	nop
  7ecb50:	4c 39 c7             	cmp    %r8,%rdi
  7ecb53:	74 11                	je     7ecb66 <<parley::editing::geometry::CursorGeometry<()>>::new+0x676>
  7ecb55:	42 83 7c 05 00 ff    	cmpl   $0xffffffff,0x0(%rbp,%r8,1)
  7ecb5b:	4d 8d 40 04          	lea    0x4(%r8),%r8
  7ecb5f:	74 ef                	je     7ecb50 <<parley::editing::geometry::CursorGeometry<()>>::new+0x660>
  7ecb61:	e9 ef 00 00 00       	jmp    7ecc55 <<parley::editing::geometry::CursorGeometry<()>>::new+0x765>
  7ecb66:	4d 89 f0             	mov    %r14,%r8
  7ecb69:	49 c1 e8 20          	shr    $0x20,%r8
  7ecb6d:	0f 85 e2 00 00 00    	jne    7ecc55 <<parley::editing::geometry::CursorGeometry<()>>::new+0x765>
  7ecb73:	48 39 c2             	cmp    %rax,%rdx
  7ecb76:	0f 84 24 fd ff ff    	je     7ec8a0 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3b0>
  7ecb7c:	48 c1 e0 02          	shl    $0x2,%rax
  7ecb80:	48 29 c7             	sub    %rax,%rdi
  7ecb83:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
  7ecb87:	48 89 f2             	mov    %rsi,%rdx
  7ecb8a:	48 83 ff 1c          	cmp    $0x1c,%rdi
  7ecb8e:	72 4f                	jb     7ecbdf <<parley::editing::geometry::CursorGeometry<()>>::new+0x6ef>
  7ecb90:	48 c1 ef 02          	shr    $0x2,%rdi
  7ecb94:	48 ff c7             	inc    %rdi
  7ecb97:	49 89 f8             	mov    %rdi,%r8
  7ecb9a:	48 ba f8 ff ff ff ff 	movabs $0x7ffffffffffffff8,%rdx
  7ecba1:	ff ff 7f 
  7ecba4:	49 21 d0             	and    %rdx,%r8
  7ecba7:	4a 8d 14 86          	lea    (%rsi,%r8,4),%rdx
  7ecbab:	66 41 0f 6e c6       	movd   %r14d,%xmm0
  7ecbb0:	66 0f 70 c0 00       	pshufd $0x0,%xmm0,%xmm0
  7ecbb5:	48 01 e8             	add    %rbp,%rax
  7ecbb8:	48 83 c0 10          	add    $0x10,%rax
  7ecbbc:	45 31 c9             	xor    %r9d,%r9d
  7ecbbf:	90                   	nop
  7ecbc0:	f3 42 0f 7f 44 88 f0 	movdqu %xmm0,-0x10(%rax,%r9,4)
  7ecbc7:	f3 42 0f 7f 04 88    	movdqu %xmm0,(%rax,%r9,4)
  7ecbcd:	49 83 c1 08          	add    $0x8,%r9
  7ecbd1:	4d 39 c8             	cmp    %r9,%r8
  7ecbd4:	75 ea                	jne    7ecbc0 <<parley::editing::geometry::CursorGeometry<()>>::new+0x6d0>
  7ecbd6:	4c 39 c7             	cmp    %r8,%rdi
  7ecbd9:	0f 84 c1 fc ff ff    	je     7ec8a0 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3b0>
  7ecbdf:	48 8d 04 8e          	lea    (%rsi,%rcx,4),%rax
  7ecbe3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  7ecbea:	84 00 00 00 00 00 
  7ecbf0:	44 89 32             	mov    %r14d,(%rdx)
  7ecbf3:	48 83 c2 04          	add    $0x4,%rdx
  7ecbf7:	48 39 c2             	cmp    %rax,%rdx
  7ecbfa:	75 f4                	jne    7ecbf0 <<parley::editing::geometry::CursorGeometry<()>>::new+0x700>
  7ecbfc:	e9 9f fc ff ff       	jmp    7ec8a0 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3b0>
  7ecc01:	48 8d bc 24 20 01 00 	lea    0x120(%rsp),%rdi
  7ecc08:	00 
  7ecc09:	e8 42 d7 00 00       	call   7fa350 <<parley::layout::run::Run<()>>::advance>
  7ecc0e:	48 8b 9c 24 c8 00 00 	mov    0xc8(%rsp),%rbx
  7ecc15:	00 
  7ecc16:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  7ecc1b:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  7ecc20:	48 8b 94 24 c0 00 00 	mov    0xc0(%rsp),%rdx
  7ecc27:	00 
  7ecc28:	4c 8b 84 24 b8 00 00 	mov    0xb8(%rsp),%r8
  7ecc2f:	00 
  7ecc30:	4c 8b 8c 24 b0 00 00 	mov    0xb0(%rsp),%r9
  7ecc37:	00 
  7ecc38:	4c 8b 94 24 a8 00 00 	mov    0xa8(%rsp),%r10
  7ecc3f:	00 
  7ecc40:	4c 8b 9c 24 a0 00 00 	mov    0xa0(%rsp),%r11
  7ecc47:	00 
  7ecc48:	4c 8b b4 24 d0 00 00 	mov    0xd0(%rsp),%r14
  7ecc4f:	00 
  7ecc50:	e9 77 fb ff ff       	jmp    7ec7cc <<parley::editing::geometry::CursorGeometry<()>>::new+0x2dc>
  7ecc55:	48 8b bc 24 88 00 00 	mov    0x88(%rsp),%rdi
  7ecc5c:	00 
  7ecc5d:	48 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%rdi)
  7ecc64:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  7ecc69:	48 85 f6             	test   %rsi,%rsi
  7ecc6c:	74 1a                	je     7ecc88 <<parley::editing::geometry::CursorGeometry<()>>::new+0x798>
  7ecc6e:	48 89 fb             	mov    %rdi,%rbx
  7ecc71:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  7ecc76:	48 c1 e6 04          	shl    $0x4,%rsi
  7ecc7a:	ba 04 00 00 00       	mov    $0x4,%edx
  7ecc7f:	ff 15 c3 0a 34 00    	call   *0x340ac3(%rip)        # b2d748 <_DYNAMIC+0x248>
  7ecc85:	48 89 df             	mov    %rbx,%rdi
  7ecc88:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  7ecc8d:	48 85 f6             	test   %rsi,%rsi
  7ecc90:	0f 84 8f f8 ff ff    	je     7ec525 <<parley::editing::geometry::CursorGeometry<()>>::new+0x35>
  7ecc96:	48 c1 e6 02          	shl    $0x2,%rsi
  7ecc9a:	ba 04 00 00 00       	mov    $0x4,%edx
  7ecc9f:	48 89 fb             	mov    %rdi,%rbx
  7ecca2:	48 89 ef             	mov    %rbp,%rdi
  7ecca5:	ff 15 9d 0a 34 00    	call   *0x340a9d(%rip)        # b2d748 <_DYNAMIC+0x248>
  7eccab:	48 89 df             	mov    %rbx,%rdi
  7eccae:	e9 72 f8 ff ff       	jmp    7ec525 <<parley::editing::geometry::CursorGeometry<()>>::new+0x35>
  7eccb3:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  7eccb8:	4c 8b 84 24 88 00 00 	mov    0x88(%rsp),%r8
  7eccbf:	00 
  7eccc0:	49 89 40 30          	mov    %rax,0x30(%r8)
  7eccc4:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  7eccc9:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  7eccce:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  7eccd3:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  7eccd8:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  7eccdd:	49 89 78 20          	mov    %rdi,0x20(%r8)
  7ecce1:	48 8b 7c 24 68       	mov    0x68(%rsp),%rdi
  7ecce6:	49 89 78 28          	mov    %rdi,0x28(%r8)
  7eccea:	4c 89 c7             	mov    %r8,%rdi
  7ecced:	49 89 50 10          	mov    %rdx,0x10(%r8)
  7eccf1:	49 89 70 18          	mov    %rsi,0x18(%r8)
  7eccf5:	49 89 00             	mov    %rax,(%r8)
  7eccf8:	49 89 48 08          	mov    %rcx,0x8(%r8)
  7eccfc:	e9 24 f8 ff ff       	jmp    7ec525 <<parley::editing::geometry::CursorGeometry<()>>::new+0x35>
  7ecd01:	48 8d 0d 30 b2 31 00 	lea    0x31b230(%rip),%rcx        # b07f38 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.37.llvm.14379316919819170204>
  7ecd08:	48 89 c6             	mov    %rax,%rsi
  7ecd0b:	ff 15 7f 0a 34 00    	call   *0x340a7f(%rip)        # b2d790 <_DYNAMIC+0x290>
  7ecd11:	eb 79                	jmp    7ecd8c <<parley::editing::geometry::CursorGeometry<()>>::new+0x89c>
  7ecd13:	48 8d 3d 66 c5 91 ff 	lea    -0x6e3a9a(%rip),%rdi        # 109280 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.4.llvm.14379316919819170204>
  7ecd1a:	48 8d 15 0f b4 31 00 	lea    0x31b40f(%rip),%rdx        # b08130 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.60.llvm.14379316919819170204>
  7ecd21:	be 63 00 00 00       	mov    $0x63,%esi
  7ecd26:	ff 15 54 0b 34 00    	call   *0x340b54(%rip)        # b2d880 <_DYNAMIC+0x380>
  7ecd2c:	eb 5e                	jmp    7ecd8c <<parley::editing::geometry::CursorGeometry<()>>::new+0x89c>
  7ecd2e:	bf 04 00 00 00       	mov    $0x4,%edi
  7ecd33:	4c 89 f6             	mov    %r14,%rsi
  7ecd36:	ff 15 9c 0a 34 00    	call   *0x340a9c(%rip)        # b2d7d8 <_DYNAMIC+0x2d8>
  7ecd3c:	48 8d 05 9d b5 31 00 	lea    0x31b59d(%rip),%rax        # b082e0 <anon.e1aed3256c0f336e2763058c1a348a1e.26.llvm.17407148579165845042>
  7ecd43:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  7ecd48:	48 8b 54 24 78       	mov    0x78(%rsp),%rdx
  7ecd4d:	ff 15 7d 0a 34 00    	call   *0x340a7d(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7ecd53:	eb 37                	jmp    7ecd8c <<parley::editing::geometry::CursorGeometry<()>>::new+0x89c>
  7ecd55:	4c 89 54 24 18       	mov    %r10,0x18(%rsp)
  7ecd5a:	48 8d 05 97 a9 31 00 	lea    0x31a997(%rip),%rax        # b076f8 <anon.8b5fc042aaf44ecdb8851cb64b83294a.9.llvm.11756661080873179907+0x30>
  7ecd61:	eb 14                	jmp    7ecd77 <<parley::editing::geometry::CursorGeometry<()>>::new+0x887>
  7ecd63:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  7ecd6a:	00 
  7ecd6b:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  7ecd70:	48 8d 05 99 a9 31 00 	lea    0x31a999(%rip),%rax        # b07710 <anon.8b5fc042aaf44ecdb8851cb64b83294a.9.llvm.11756661080873179907+0x48>
  7ecd77:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  7ecd7c:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  7ecd81:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  7ecd86:	ff 15 44 0a 34 00    	call   *0x340a44(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7ecd8c:	0f 0b                	ud2
  7ecd8e:	eb 06                	jmp    7ecd96 <<parley::editing::geometry::CursorGeometry<()>>::new+0x8a6>
  7ecd90:	eb 04                	jmp    7ecd96 <<parley::editing::geometry::CursorGeometry<()>>::new+0x8a6>
  7ecd92:	eb 02                	jmp    7ecd96 <<parley::editing::geometry::CursorGeometry<()>>::new+0x8a6>
  7ecd94:	eb 00                	jmp    7ecd96 <<parley::editing::geometry::CursorGeometry<()>>::new+0x8a6>
  7ecd96:	48 89 c3             	mov    %rax,%rbx
  7ecd99:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  7ecd9e:	e8 0d ef ff ff       	call   7ebcb0 <core::ptr::drop_glue::<parley::editing::geometry::CursorGeometry<()>>>
  7ecda3:	48 89 df             	mov    %rbx,%rdi
  7ecda6:	e8 85 67 31 00       	call   b03530 <_Unwind_Resume@plt>
  7ecdab:	48 89 c3             	mov    %rax,%rbx
  7ecdae:	4d 85 ff             	test   %r15,%r15
  7ecdb1:	74 13                	je     7ecdc6 <<parley::editing::geometry::CursorGeometry<()>>::new+0x8d6>
  7ecdb3:	ba 04 00 00 00       	mov    $0x4,%edx
  7ecdb8:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  7ecdbd:	4c 89 f6             	mov    %r14,%rsi
  7ecdc0:	ff 15 82 09 34 00    	call   *0x340982(%rip)        # b2d748 <_DYNAMIC+0x248>
  7ecdc6:	48 89 df             	mov    %rbx,%rdi
  7ecdc9:	e8 62 67 31 00       	call   b03530 <_Unwind_Resume@plt>
