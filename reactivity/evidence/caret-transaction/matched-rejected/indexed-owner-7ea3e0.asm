
/tmp/gpui-caret-transaction-bin/matched-indexed-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007ea3e0 <<parley::editing::geometry::CursorGeometry<()>>::new>:
  7ea3e0:	55                   	push   %rbp
  7ea3e1:	41 57                	push   %r15
  7ea3e3:	41 56                	push   %r14
  7ea3e5:	41 55                	push   %r13
  7ea3e7:	41 54                	push   %r12
  7ea3e9:	53                   	push   %rbx
  7ea3ea:	48 81 ec 88 04 00 00 	sub    $0x488,%rsp
  7ea3f1:	4c 8b 7e 70          	mov    0x70(%rsi),%r15
  7ea3f5:	4c 89 f8             	mov    %r15,%rax
  7ea3f8:	48 c1 e8 20          	shr    $0x20,%rax
  7ea3fc:	75 10                	jne    7ea40e <<parley::editing::geometry::CursorGeometry<()>>::new+0x2e>
  7ea3fe:	48 8b 9e 18 01 00 00 	mov    0x118(%rsi),%rbx
  7ea405:	48 89 d8             	mov    %rbx,%rax
  7ea408:	48 c1 e8 20          	shr    $0x20,%rax
  7ea40c:	74 1c                	je     7ea42a <<parley::editing::geometry::CursorGeometry<()>>::new+0x4a>
  7ea40e:	48 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%rdi)
  7ea415:	48 89 f8             	mov    %rdi,%rax
  7ea418:	48 81 c4 88 04 00 00 	add    $0x488,%rsp
  7ea41f:	5b                   	pop    %rbx
  7ea420:	41 5c                	pop    %r12
  7ea422:	41 5d                	pop    %r13
  7ea424:	41 5e                	pop    %r14
  7ea426:	41 5f                	pop    %r15
  7ea428:	5d                   	pop    %rbp
  7ea429:	c3                   	ret
  7ea42a:	4d 89 fe             	mov    %r15,%r14
  7ea42d:	49 c1 e6 04          	shl    $0x4,%r14
  7ea431:	4d 85 ff             	test   %r15,%r15
  7ea434:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
  7ea439:	74 2e                	je     7ea469 <<parley::editing::geometry::CursorGeometry<()>>::new+0x89>
  7ea43b:	49 89 fc             	mov    %rdi,%r12
  7ea43e:	ff 15 ec 0a 34 00    	call   *0x340aec(%rip)        # b2af30 <_DYNAMIC+0x260>
  7ea444:	be 04 00 00 00       	mov    $0x4,%esi
  7ea449:	4c 89 f7             	mov    %r14,%rdi
  7ea44c:	ff 15 be 0a 34 00    	call   *0x340abe(%rip)        # b2af10 <_DYNAMIC+0x240>
  7ea452:	48 89 04 24          	mov    %rax,(%rsp)
  7ea456:	48 85 c0             	test   %rax,%rax
  7ea459:	0f 84 5e 07 00 00    	je     7eabbd <<parley::editing::geometry::CursorGeometry<()>>::new+0x7dd>
  7ea45f:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  7ea464:	4c 89 e7             	mov    %r12,%rdi
  7ea467:	eb 09                	jmp    7ea472 <<parley::editing::geometry::CursorGeometry<()>>::new+0x92>
  7ea469:	b8 04 00 00 00       	mov    $0x4,%eax
  7ea46e:	48 89 04 24          	mov    %rax,(%rsp)
  7ea472:	48 b9 f8 ff ff ff ff 	movabs $0x7ffffffffffffff8,%rcx
  7ea479:	ff ff 7f 
  7ea47c:	48 8b ae 50 01 00 00 	mov    0x150(%rsi),%rbp
  7ea483:	4c 8d 24 ad 00 00 00 	lea    0x0(,%rbp,4),%r12
  7ea48a:	00 
  7ea48b:	48 89 e8             	mov    %rbp,%rax
  7ea48e:	48 c1 e8 3e          	shr    $0x3e,%rax
  7ea492:	0f 95 c0             	setne  %al
  7ea495:	48 83 c1 04          	add    $0x4,%rcx
  7ea499:	49 39 cc             	cmp    %rcx,%r12
  7ea49c:	0f 97 c1             	seta   %cl
  7ea49f:	08 c1                	or     %al,%cl
  7ea4a1:	74 13                	je     7ea4b6 <<parley::editing::geometry::CursorGeometry<()>>::new+0xd6>
  7ea4a3:	31 ed                	xor    %ebp,%ebp
  7ea4a5:	48 89 ef             	mov    %rbp,%rdi
  7ea4a8:	4c 89 e6             	mov    %r12,%rsi
  7ea4ab:	ff 15 f7 0a 34 00    	call   *0x340af7(%rip)        # b2afa8 <_DYNAMIC+0x2d8>
  7ea4b1:	e9 5d 07 00 00       	jmp    7eac13 <<parley::editing::geometry::CursorGeometry<()>>::new+0x833>
  7ea4b6:	48 89 7c 24 70       	mov    %rdi,0x70(%rsp)
  7ea4bb:	4d 85 e4             	test   %r12,%r12
  7ea4be:	48 89 6c 24 78       	mov    %rbp,0x78(%rsp)
  7ea4c3:	74 56                	je     7ea51b <<parley::editing::geometry::CursorGeometry<()>>::new+0x13b>
  7ea4c5:	ff 15 65 0a 34 00    	call   *0x340a65(%rip)        # b2af30 <_DYNAMIC+0x260>
  7ea4cb:	bd 04 00 00 00       	mov    $0x4,%ebp
  7ea4d0:	be 04 00 00 00       	mov    $0x4,%esi
  7ea4d5:	4c 89 e7             	mov    %r12,%rdi
  7ea4d8:	ff 15 32 0a 34 00    	call   *0x340a32(%rip)        # b2af10 <_DYNAMIC+0x240>
  7ea4de:	48 85 c0             	test   %rax,%rax
  7ea4e1:	74 c2                	je     7ea4a5 <<parley::editing::geometry::CursorGeometry<()>>::new+0xc5>
  7ea4e3:	49 89 c5             	mov    %rax,%r13
  7ea4e6:	48 8b 6c 24 78       	mov    0x78(%rsp),%rbp
  7ea4eb:	49 89 ee             	mov    %rbp,%r14
  7ea4ee:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  7ea4f3:	48 83 fd 02          	cmp    $0x2,%rbp
  7ea4f7:	72 31                	jb     7ea52a <<parley::editing::geometry::CursorGeometry<()>>::new+0x14a>
  7ea4f9:	49 8d 54 24 fc       	lea    -0x4(%r12),%rdx
  7ea4fe:	4c 89 ef             	mov    %r13,%rdi
  7ea501:	be ff 00 00 00       	mov    $0xff,%esi
  7ea506:	ff 15 94 0f 34 00    	call   *0x340f94(%rip)        # b2b4a0 <memset@GLIBC_2.2.5>
  7ea50c:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  7ea511:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
  7ea515:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  7ea519:	eb 17                	jmp    7ea532 <<parley::editing::geometry::CursorGeometry<()>>::new+0x152>
  7ea51b:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  7ea521:	45 31 f6             	xor    %r14d,%r14d
  7ea524:	48 83 fd 02          	cmp    $0x2,%rbp
  7ea528:	73 cf                	jae    7ea4f9 <<parley::editing::geometry::CursorGeometry<()>>::new+0x119>
  7ea52a:	4c 89 e8             	mov    %r13,%rax
  7ea52d:	48 85 ed             	test   %rbp,%rbp
  7ea530:	74 06                	je     7ea538 <<parley::editing::geometry::CursorGeometry<()>>::new+0x158>
  7ea532:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%rax)
  7ea538:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
  7ea53d:	4c 89 6c 24 50       	mov    %r13,0x50(%rsp)
  7ea542:	48 89 6c 24 58       	mov    %rbp,0x58(%rsp)
  7ea547:	48 89 74 24 60       	mov    %rsi,0x60(%rsp)
  7ea54c:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
  7ea551:	48 8b 04 24          	mov    (%rsp),%rax
  7ea555:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  7ea55a:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  7ea561:	00 00 
  7ea563:	48 85 db             	test   %rbx,%rbx
  7ea566:	0f 84 f4 05 00 00    	je     7eab60 <<parley::editing::geometry::CursorGeometry<()>>::new+0x780>
  7ea56c:	4c 8b be 10 01 00 00 	mov    0x110(%rsi),%r15
  7ea573:	4c 6b c3 70          	imul   $0x70,%rbx,%r8
  7ea577:	4d 01 f8             	add    %r15,%r8
  7ea57a:	48 8b 96 30 01 00 00 	mov    0x130(%rsi),%rdx
  7ea581:	4c 8b 8e 28 01 00 00 	mov    0x128(%rsi),%r9
  7ea588:	48 8b 4e 58          	mov    0x58(%rsi),%rcx
  7ea58c:	4c 8b 96 e8 00 00 00 	mov    0xe8(%rsi),%r10
  7ea593:	4c 8b 9e e0 00 00 00 	mov    0xe0(%rsi),%r11
  7ea59a:	48 8b 5e 50          	mov    0x50(%rsi),%rbx
  7ea59e:	48 8b 46 38          	mov    0x38(%rsi),%rax
  7ea5a2:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
  7ea5a9:	00 
  7ea5aa:	4c 8b 66 40          	mov    0x40(%rsi),%r12
  7ea5ae:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  7ea5b5:	00 00 
  7ea5b7:	48 8d 05 62 a8 31 00 	lea    0x31a862(%rip),%rax        # b04e20 <anon.48eabac924674053adbe92ba251c58bc.2.llvm.10242891199130889596+0x290>
  7ea5be:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  7ea5c3:	48 8d 05 a6 b0 31 00 	lea    0x31b0a6(%rip),%rax        # b05670 <anon.e15953efb999cecb448192f678c23055.29.llvm.10952606936216045542>
  7ea5ca:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  7ea5cf:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  7ea5d4:	48 89 94 24 f0 00 00 	mov    %rdx,0xf0(%rsp)
  7ea5db:	00 
  7ea5dc:	4c 89 84 24 e8 00 00 	mov    %r8,0xe8(%rsp)
  7ea5e3:	00 
  7ea5e4:	4c 89 8c 24 e0 00 00 	mov    %r9,0xe0(%rsp)
  7ea5eb:	00 
  7ea5ec:	4c 89 94 24 d8 00 00 	mov    %r10,0xd8(%rsp)
  7ea5f3:	00 
  7ea5f4:	4c 89 9c 24 d0 00 00 	mov    %r11,0xd0(%rsp)
  7ea5fb:	00 
  7ea5fc:	48 89 9c 24 c8 00 00 	mov    %rbx,0xc8(%rsp)
  7ea603:	00 
  7ea604:	4c 89 a4 24 c0 00 00 	mov    %r12,0xc0(%rsp)
  7ea60b:	00 
  7ea60c:	49 8b 7f 10          	mov    0x10(%r15),%rdi
  7ea610:	49 8b 47 18          	mov    0x18(%r15),%rax
  7ea614:	48 39 f8             	cmp    %rdi,%rax
  7ea617:	0f 82 8e 05 00 00    	jb     7eabab <<parley::editing::geometry::CursorGeometry<()>>::new+0x7cb>
  7ea61d:	48 39 d0             	cmp    %rdx,%rax
  7ea620:	0f 87 85 05 00 00    	ja     7eabab <<parley::editing::geometry::CursorGeometry<()>>::new+0x7cb>
  7ea626:	48 39 c7             	cmp    %rax,%rdi
  7ea629:	75 1a                	jne    7ea645 <<parley::editing::geometry::CursorGeometry<()>>::new+0x265>
  7ea62b:	49 83 c7 70          	add    $0x70,%r15
  7ea62f:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  7ea634:	ff c0                	inc    %eax
  7ea636:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7ea63b:	4d 39 c7             	cmp    %r8,%r15
  7ea63e:	75 cc                	jne    7ea60c <<parley::editing::geometry::CursorGeometry<()>>::new+0x22c>
  7ea640:	e9 1b 05 00 00       	jmp    7eab60 <<parley::editing::geometry::CursorGeometry<()>>::new+0x780>
  7ea645:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  7ea649:	49 8d 04 c1          	lea    (%r9,%rax,8),%rax
  7ea64d:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
  7ea654:	00 
  7ea655:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  7ea659:	4d 8d 2c c1          	lea    (%r9,%rax,8),%r13
  7ea65d:	f3 41 0f 10 47 28    	movss  0x28(%r15),%xmm0
  7ea663:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  7ea669:	45 31 f6             	xor    %r14d,%r14d
  7ea66c:	49 8b 7d 10          	mov    0x10(%r13),%rdi
  7ea670:	41 80 7d 21 01       	cmpb   $0x1,0x21(%r13)
  7ea675:	75 41                	jne    7ea6b8 <<parley::editing::geometry::CursorGeometry<()>>::new+0x2d8>
  7ea677:	4c 39 e7             	cmp    %r12,%rdi
  7ea67a:	0f 83 64 05 00 00    	jae    7eabe4 <<parley::editing::geometry::CursorGeometry<()>>::new+0x804>
  7ea680:	48 6b c7 38          	imul   $0x38,%rdi,%rax
  7ea684:	48 8b bc 24 f8 00 00 	mov    0xf8(%rsp),%rdi
  7ea68b:	00 
  7ea68c:	f3 0f 10 44 07 24    	movss  0x24(%rdi,%rax,1),%xmm0
  7ea692:	49 83 c5 28          	add    $0x28,%r13
  7ea696:	41 ff c6             	inc    %r14d
  7ea699:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  7ea69f:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  7ea6a3:	f3 0f 11 4c 24 0c    	movss  %xmm1,0xc(%rsp)
  7ea6a9:	4c 3b ac 24 00 01 00 	cmp    0x100(%rsp),%r13
  7ea6b0:	00 
  7ea6b1:	75 b9                	jne    7ea66c <<parley::editing::geometry::CursorGeometry<()>>::new+0x28c>
  7ea6b3:	e9 73 ff ff ff       	jmp    7ea62b <<parley::editing::geometry::CursorGeometry<()>>::new+0x24b>
  7ea6b8:	48 39 cf             	cmp    %rcx,%rdi
  7ea6bb:	0f 83 42 05 00 00    	jae    7eac03 <<parley::editing::geometry::CursorGeometry<()>>::new+0x823>
  7ea6c1:	4c 39 d7             	cmp    %r10,%rdi
  7ea6c4:	0f 83 28 05 00 00    	jae    7eabf2 <<parley::editing::geometry::CursorGeometry<()>>::new+0x812>
  7ea6ca:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
  7ea6ce:	48 c1 e0 04          	shl    $0x4,%rax
  7ea6d2:	48 8d 0c 03          	lea    (%rbx,%rax,1),%rcx
  7ea6d6:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  7ea6da:	48 c1 e2 04          	shl    $0x4,%rdx
  7ea6de:	4c 01 da             	add    %r11,%rdx
  7ea6e1:	48 89 b4 24 80 00 00 	mov    %rsi,0x80(%rsp)
  7ea6e8:	00 
  7ea6e9:	48 89 8c 24 88 00 00 	mov    %rcx,0x88(%rsp)
  7ea6f0:	00 
  7ea6f1:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  7ea6f8:	00 
  7ea6f9:	4c 89 ac 24 98 00 00 	mov    %r13,0x98(%rsp)
  7ea700:	00 
  7ea701:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  7ea706:	89 8c 24 a0 00 00 00 	mov    %ecx,0xa0(%rsp)
  7ea70d:	44 89 b4 24 a4 00 00 	mov    %r14d,0xa4(%rsp)
  7ea714:	00 
  7ea715:	89 bc 24 a8 00 00 00 	mov    %edi,0xa8(%rsp)
  7ea71c:	0f b6 94 03 8c 00 00 	movzbl 0x8c(%rbx,%rax,1),%edx
  7ea723:	00 
  7ea724:	8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%eax
  7ea72b:	89 84 24 f0 01 00 00 	mov    %eax,0x1f0(%rsp)
  7ea732:	8b 84 24 a4 00 00 00 	mov    0xa4(%rsp),%eax
  7ea739:	89 84 24 f4 01 00 00 	mov    %eax,0x1f4(%rsp)
  7ea740:	8b 84 24 a8 00 00 00 	mov    0xa8(%rsp),%eax
  7ea747:	89 84 24 f8 01 00 00 	mov    %eax,0x1f8(%rsp)
  7ea74e:	8b 84 24 ac 00 00 00 	mov    0xac(%rsp),%eax
  7ea755:	89 84 24 fc 01 00 00 	mov    %eax,0x1fc(%rsp)
  7ea75c:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  7ea763:	00 
  7ea764:	48 89 84 24 e0 01 00 	mov    %rax,0x1e0(%rsp)
  7ea76b:	00 
  7ea76c:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  7ea773:	00 
  7ea774:	48 89 84 24 e8 01 00 	mov    %rax,0x1e8(%rsp)
  7ea77b:	00 
  7ea77c:	0f 10 84 24 80 00 00 	movups 0x80(%rsp),%xmm0
  7ea783:	00 
  7ea784:	0f 29 84 24 d0 01 00 	movaps %xmm0,0x1d0(%rsp)
  7ea78b:	00 
  7ea78c:	83 e2 01             	and    $0x1,%edx
  7ea78f:	48 8d 9c 24 78 03 00 	lea    0x378(%rsp),%rbx
  7ea796:	00 
  7ea797:	48 89 df             	mov    %rbx,%rdi
  7ea79a:	4c 8d a4 24 d0 01 00 	lea    0x1d0(%rsp),%r12
  7ea7a1:	00 
  7ea7a2:	4c 89 e6             	mov    %r12,%rsi
  7ea7a5:	e8 76 67 00 00       	call   7f0f20 <<parley::layout::run::Clusters<()>>::new>
  7ea7aa:	ba 10 01 00 00       	mov    $0x110,%edx
  7ea7af:	4c 89 e7             	mov    %r12,%rdi
  7ea7b2:	48 89 de             	mov    %rbx,%rsi
  7ea7b5:	ff 15 85 07 34 00    	call   *0x340785(%rip)        # b2af40 <memcpy@GLIBC_2.14>
  7ea7bb:	66 0f 6e 44 24 0c    	movd   0xc(%rsp),%xmm0
  7ea7c1:	66 0f 7e 04 24       	movd   %xmm0,(%rsp)
  7ea7c6:	eb 1b                	jmp    7ea7e3 <<parley::editing::geometry::CursorGeometry<()>>::new+0x403>
  7ea7c8:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  7ea7cd:	f3 0f 58 c1          	addss  %xmm1,%xmm0
  7ea7d1:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  7ea7d6:	48 8b 6c 24 78       	mov    0x78(%rsp),%rbp
  7ea7db:	4c 8d a4 24 d0 01 00 	lea    0x1d0(%rsp),%r12
  7ea7e2:	00 
  7ea7e3:	48 8d bc 24 e8 02 00 	lea    0x2e8(%rsp),%rdi
  7ea7ea:	00 
  7ea7eb:	4c 89 e6             	mov    %r12,%rsi
  7ea7ee:	e8 8d 6e 00 00       	call   7f1680 <<parley::layout::run::Clusters<()> as core::iter::traits::iterator::Iterator>::next>
  7ea7f3:	48 83 bc 24 e8 02 00 	cmpq   $0x0,0x2e8(%rsp)
  7ea7fa:	00 00 
  7ea7fc:	0f 84 af 02 00 00    	je     7eaab1 <<parley::editing::geometry::CursorGeometry<()>>::new+0x6d1>
  7ea802:	ba 90 00 00 00       	mov    $0x90,%edx
  7ea807:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  7ea80e:	00 
  7ea80f:	48 8d b4 24 e8 02 00 	lea    0x2e8(%rsp),%rsi
  7ea816:	00 
  7ea817:	ff 15 23 07 34 00    	call   *0x340723(%rip)        # b2af40 <memcpy@GLIBC_2.14>
  7ea81d:	4c 8b 64 24 40       	mov    0x40(%rsp),%r12
  7ea822:	f3 0f 7e 84 24 60 01 	movq   0x160(%rsp),%xmm0
  7ea829:	00 00 
  7ea82b:	66 0f 7f 84 24 b0 00 	movdqa %xmm0,0xb0(%rsp)
  7ea832:	00 00 
  7ea834:	8b 9c 24 c0 01 00 00 	mov    0x1c0(%rsp),%ebx
  7ea83b:	4c 3b 64 24 30       	cmp    0x30(%rsp),%r12
  7ea840:	75 0b                	jne    7ea84d <<parley::editing::geometry::CursorGeometry<()>>::new+0x46d>
  7ea842:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  7ea847:	ff 15 eb 12 34 00    	call   *0x3412eb(%rip)        # b2bb38 <_DYNAMIC+0xe68>
  7ea84d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7ea852:	4c 89 e1             	mov    %r12,%rcx
  7ea855:	48 c1 e1 04          	shl    $0x4,%rcx
  7ea859:	0f 28 84 24 b0 00 00 	movaps 0xb0(%rsp),%xmm0
  7ea860:	00 
  7ea861:	0f 13 04 08          	movlps %xmm0,(%rax,%rcx,1)
  7ea865:	89 5c 08 08          	mov    %ebx,0x8(%rax,%rcx,1)
  7ea869:	66 0f 6e 04 24       	movd   (%rsp),%xmm0
  7ea86e:	66 0f 7e 44 08 0c    	movd   %xmm0,0xc(%rax,%rcx,1)
  7ea874:	49 8d 44 24 01       	lea    0x1(%r12),%rax
  7ea879:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  7ea87e:	48 83 bc 24 58 01 00 	cmpq   $0x0,0x158(%rsp)
  7ea885:	00 00 
  7ea887:	74 36                	je     7ea8bf <<parley::editing::geometry::CursorGeometry<()>>::new+0x4df>
  7ea889:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  7ea890:	00 
  7ea891:	8b bc 24 60 01 00 00 	mov    0x160(%rsp),%edi
  7ea898:	48 8b b0 18 01 00 00 	mov    0x118(%rax),%rsi
  7ea89f:	48 39 fe             	cmp    %rdi,%rsi
  7ea8a2:	0f 86 2f 03 00 00    	jbe    7eabd7 <<parley::editing::geometry::CursorGeometry<()>>::new+0x7f7>
  7ea8a8:	48 8b 80 10 01 00 00 	mov    0x110(%rax),%rax
  7ea8af:	48 6b cf 70          	imul   $0x70,%rdi,%rcx
  7ea8b3:	66 0f 6e 44 08 50    	movd   0x50(%rax,%rcx,1),%xmm0
  7ea8b9:	8b 44 08 54          	mov    0x54(%rax,%rcx,1),%eax
  7ea8bd:	eb 09                	jmp    7ea8c8 <<parley::editing::geometry::CursorGeometry<()>>::new+0x4e8>
  7ea8bf:	66 0f ef c0          	pxor   %xmm0,%xmm0
  7ea8c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  7ea8c8:	48 8b 8c 24 48 01 00 	mov    0x148(%rsp),%rcx
  7ea8cf:	00 
  7ea8d0:	48 8b 94 24 50 01 00 	mov    0x150(%rsp),%rdx
  7ea8d7:	00 
  7ea8d8:	f3 0f 7e 4a 44       	movq   0x44(%rdx),%xmm1
  7ea8dd:	66 0f d6 8c 24 08 01 	movq   %xmm1,0x108(%rsp)
  7ea8e4:	00 00 
  7ea8e6:	66 0f 7e 84 24 10 01 	movd   %xmm0,0x110(%rsp)
  7ea8ed:	00 00 
  7ea8ef:	89 84 24 14 01 00 00 	mov    %eax,0x114(%rsp)
  7ea8f6:	0f b6 89 8c 00 00 00 	movzbl 0x8c(%rcx),%ecx
  7ea8fd:	83 e1 01             	and    $0x1,%ecx
  7ea900:	48 8d bc 24 08 01 00 	lea    0x108(%rsp),%rdi
  7ea907:	00 
  7ea908:	48 8d b4 24 70 01 00 	lea    0x170(%rsp),%rsi
  7ea90f:	00 
  7ea910:	48 8d 94 24 c0 01 00 	lea    0x1c0(%rsp),%rdx
  7ea917:	00 
  7ea918:	ff 15 fa 11 34 00    	call   *0x3411fa(%rip)        # b2bb18 <_DYNAMIC+0xe48>
  7ea91e:	66 0f 6f c8          	movdqa %xmm0,%xmm1
  7ea922:	48 85 ed             	test   %rbp,%rbp
  7ea925:	0f 84 9d fe ff ff    	je     7ea7c8 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3e8>
  7ea92b:	66 0f 7e 8c 24 b0 00 	movd   %xmm1,0xb0(%rsp)
  7ea932:	00 00 
  7ea934:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  7ea93b:	00 
  7ea93c:	8b bc 24 68 01 00 00 	mov    0x168(%rsp),%edi
  7ea943:	48 8b 70 58          	mov    0x58(%rax),%rsi
  7ea947:	48 39 fe             	cmp    %rdi,%rsi
  7ea94a:	0f 86 7b 02 00 00    	jbe    7eabcb <<parley::editing::geometry::CursorGeometry<()>>::new+0x7eb>
  7ea950:	48 8b 48 50          	mov    0x50(%rax),%rcx
  7ea954:	48 8d 14 ff          	lea    (%rdi,%rdi,8),%rdx
  7ea958:	48 c1 e2 04          	shl    $0x4,%rdx
  7ea95c:	f3 0f 6f 40 68       	movdqu 0x68(%rax),%xmm0
  7ea961:	0f 10 88 80 00 00 00 	movups 0x80(%rax),%xmm1
  7ea968:	0f 10 90 98 00 00 00 	movups 0x98(%rax),%xmm2
  7ea96f:	f3 0f 7f 84 24 08 01 	movdqu %xmm0,0x108(%rsp)
  7ea976:	00 00 
  7ea978:	0f 11 8c 24 18 01 00 	movups %xmm1,0x118(%rsp)
  7ea97f:	00 
  7ea980:	0f 11 94 24 28 01 00 	movups %xmm2,0x128(%rsp)
  7ea987:	00 
  7ea988:	48 8b 44 11 50       	mov    0x50(%rcx,%rdx,1),%rax
  7ea98d:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
  7ea994:	00 
  7ea995:	8b b4 24 c0 01 00 00 	mov    0x1c0(%rsp),%esi
  7ea99c:	8b 94 24 c4 01 00 00 	mov    0x1c4(%rsp),%edx
  7ea9a3:	48 8d bc 24 08 01 00 	lea    0x108(%rsp),%rdi
  7ea9aa:	00 
  7ea9ab:	ff 15 5f 11 34 00    	call   *0x34115f(%rip)        # b2bb10 <_DYNAMIC+0xe40>
  7ea9b1:	66 0f 6e 8c 24 b0 00 	movd   0xb0(%rsp),%xmm1
  7ea9b8:	00 00 
  7ea9ba:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  7ea9bf:	48 39 c2             	cmp    %rax,%rdx
  7ea9c2:	0f 82 3d 01 00 00    	jb     7eab05 <<parley::editing::geometry::CursorGeometry<()>>::new+0x725>
  7ea9c8:	48 3b 54 24 58       	cmp    0x58(%rsp),%rdx
  7ea9cd:	0f 87 32 01 00 00    	ja     7eab05 <<parley::editing::geometry::CursorGeometry<()>>::new+0x725>
  7ea9d3:	48 89 d1             	mov    %rdx,%rcx
  7ea9d6:	48 29 c1             	sub    %rax,%rcx
  7ea9d9:	48 8d 34 85 00 00 00 	lea    0x0(,%rax,4),%rsi
  7ea9e0:	00 
  7ea9e1:	48 01 ee             	add    %rbp,%rsi
  7ea9e4:	4c 8d 04 85 00 00 00 	lea    0x0(,%rax,4),%r8
  7ea9eb:	00 
  7ea9ec:	48 8d 3c 95 00 00 00 	lea    0x0(,%rdx,4),%rdi
  7ea9f3:	00 
  7ea9f4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  7ea9fb:	00 00 00 00 00 
  7eaa00:	4c 39 c7             	cmp    %r8,%rdi
  7eaa03:	74 11                	je     7eaa16 <<parley::editing::geometry::CursorGeometry<()>>::new+0x636>
  7eaa05:	42 83 7c 05 00 ff    	cmpl   $0xffffffff,0x0(%rbp,%r8,1)
  7eaa0b:	4d 8d 40 04          	lea    0x4(%r8),%r8
  7eaa0f:	74 ef                	je     7eaa00 <<parley::editing::geometry::CursorGeometry<()>>::new+0x620>
  7eaa11:	e9 ef 00 00 00       	jmp    7eab05 <<parley::editing::geometry::CursorGeometry<()>>::new+0x725>
  7eaa16:	4d 89 e0             	mov    %r12,%r8
  7eaa19:	49 c1 e8 20          	shr    $0x20,%r8
  7eaa1d:	0f 85 e2 00 00 00    	jne    7eab05 <<parley::editing::geometry::CursorGeometry<()>>::new+0x725>
  7eaa23:	48 39 c2             	cmp    %rax,%rdx
  7eaa26:	0f 84 9c fd ff ff    	je     7ea7c8 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3e8>
  7eaa2c:	48 c1 e0 02          	shl    $0x2,%rax
  7eaa30:	48 29 c7             	sub    %rax,%rdi
  7eaa33:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
  7eaa37:	48 89 f2             	mov    %rsi,%rdx
  7eaa3a:	48 83 ff 1c          	cmp    $0x1c,%rdi
  7eaa3e:	72 4f                	jb     7eaa8f <<parley::editing::geometry::CursorGeometry<()>>::new+0x6af>
  7eaa40:	48 c1 ef 02          	shr    $0x2,%rdi
  7eaa44:	48 ff c7             	inc    %rdi
  7eaa47:	49 89 f8             	mov    %rdi,%r8
  7eaa4a:	48 ba f8 ff ff ff ff 	movabs $0x7ffffffffffffff8,%rdx
  7eaa51:	ff ff 7f 
  7eaa54:	49 21 d0             	and    %rdx,%r8
  7eaa57:	4a 8d 14 86          	lea    (%rsi,%r8,4),%rdx
  7eaa5b:	66 41 0f 6e c4       	movd   %r12d,%xmm0
  7eaa60:	66 0f 70 c0 00       	pshufd $0x0,%xmm0,%xmm0
  7eaa65:	48 01 e8             	add    %rbp,%rax
  7eaa68:	48 83 c0 10          	add    $0x10,%rax
  7eaa6c:	45 31 c9             	xor    %r9d,%r9d
  7eaa6f:	90                   	nop
  7eaa70:	f3 42 0f 7f 44 88 f0 	movdqu %xmm0,-0x10(%rax,%r9,4)
  7eaa77:	f3 42 0f 7f 04 88    	movdqu %xmm0,(%rax,%r9,4)
  7eaa7d:	49 83 c1 08          	add    $0x8,%r9
  7eaa81:	4d 39 c8             	cmp    %r9,%r8
  7eaa84:	75 ea                	jne    7eaa70 <<parley::editing::geometry::CursorGeometry<()>>::new+0x690>
  7eaa86:	4c 39 c7             	cmp    %r8,%rdi
  7eaa89:	0f 84 39 fd ff ff    	je     7ea7c8 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3e8>
  7eaa8f:	48 8d 04 8e          	lea    (%rsi,%rcx,4),%rax
  7eaa93:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  7eaa9a:	84 00 00 00 00 00 
  7eaaa0:	44 89 22             	mov    %r12d,(%rdx)
  7eaaa3:	48 83 c2 04          	add    $0x4,%rdx
  7eaaa7:	48 39 c2             	cmp    %rax,%rdx
  7eaaaa:	75 f4                	jne    7eaaa0 <<parley::editing::geometry::CursorGeometry<()>>::new+0x6c0>
  7eaaac:	e9 17 fd ff ff       	jmp    7ea7c8 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3e8>
  7eaab1:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
  7eaab8:	00 
  7eaab9:	e8 b2 5b 00 00       	call   7f0670 <<parley::layout::run::Run<()>>::advance>
  7eaabe:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  7eaac3:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  7eaac8:	48 8b 94 24 f0 00 00 	mov    0xf0(%rsp),%rdx
  7eaacf:	00 
  7eaad0:	4c 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%r8
  7eaad7:	00 
  7eaad8:	4c 8b 8c 24 e0 00 00 	mov    0xe0(%rsp),%r9
  7eaadf:	00 
  7eaae0:	4c 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%r10
  7eaae7:	00 
  7eaae8:	4c 8b 9c 24 d0 00 00 	mov    0xd0(%rsp),%r11
  7eaaef:	00 
  7eaaf0:	48 8b 9c 24 c8 00 00 	mov    0xc8(%rsp),%rbx
  7eaaf7:	00 
  7eaaf8:	4c 8b a4 24 c0 00 00 	mov    0xc0(%rsp),%r12
  7eaaff:	00 
  7eab00:	e9 8d fb ff ff       	jmp    7ea692 <<parley::editing::geometry::CursorGeometry<()>>::new+0x2b2>
  7eab05:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  7eab0a:	48 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%rdi)
  7eab11:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  7eab16:	48 85 f6             	test   %rsi,%rsi
  7eab19:	74 1a                	je     7eab35 <<parley::editing::geometry::CursorGeometry<()>>::new+0x755>
  7eab1b:	48 89 fb             	mov    %rdi,%rbx
  7eab1e:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
  7eab23:	48 c1 e6 04          	shl    $0x4,%rsi
  7eab27:	ba 04 00 00 00       	mov    $0x4,%edx
  7eab2c:	ff 15 e6 03 34 00    	call   *0x3403e6(%rip)        # b2af18 <_DYNAMIC+0x248>
  7eab32:	48 89 df             	mov    %rbx,%rdi
  7eab35:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  7eab3a:	48 85 f6             	test   %rsi,%rsi
  7eab3d:	0f 84 d2 f8 ff ff    	je     7ea415 <<parley::editing::geometry::CursorGeometry<()>>::new+0x35>
  7eab43:	48 c1 e6 02          	shl    $0x2,%rsi
  7eab47:	ba 04 00 00 00       	mov    $0x4,%edx
  7eab4c:	48 89 fb             	mov    %rdi,%rbx
  7eab4f:	48 89 ef             	mov    %rbp,%rdi
  7eab52:	ff 15 c0 03 34 00    	call   *0x3403c0(%rip)        # b2af18 <_DYNAMIC+0x248>
  7eab58:	48 89 df             	mov    %rbx,%rdi
  7eab5b:	e9 b5 f8 ff ff       	jmp    7ea415 <<parley::editing::geometry::CursorGeometry<()>>::new+0x35>
  7eab60:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  7eab65:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  7eab6a:	49 89 40 30          	mov    %rax,0x30(%r8)
  7eab6e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  7eab73:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  7eab78:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  7eab7d:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  7eab82:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  7eab87:	49 89 78 20          	mov    %rdi,0x20(%r8)
  7eab8b:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
  7eab90:	49 89 78 28          	mov    %rdi,0x28(%r8)
  7eab94:	4c 89 c7             	mov    %r8,%rdi
  7eab97:	49 89 50 10          	mov    %rdx,0x10(%r8)
  7eab9b:	49 89 70 18          	mov    %rsi,0x18(%r8)
  7eab9f:	49 89 00             	mov    %rax,(%r8)
  7eaba2:	49 89 48 08          	mov    %rcx,0x8(%r8)
  7eaba6:	e9 6a f8 ff ff       	jmp    7ea415 <<parley::editing::geometry::CursorGeometry<()>>::new+0x35>
  7eabab:	48 8d 0d ce a2 31 00 	lea    0x31a2ce(%rip),%rcx        # b04e80 <anon.eb50a12a9d8fd4acc3835e2fdeae5b5b.22.llvm.18322732550499639497>
  7eabb2:	48 89 c6             	mov    %rax,%rsi
  7eabb5:	ff 15 a5 03 34 00    	call   *0x3403a5(%rip)        # b2af60 <_DYNAMIC+0x290>
  7eabbb:	eb 56                	jmp    7eac13 <<parley::editing::geometry::CursorGeometry<()>>::new+0x833>
  7eabbd:	bf 04 00 00 00       	mov    $0x4,%edi
  7eabc2:	4c 89 f6             	mov    %r14,%rsi
  7eabc5:	ff 15 dd 03 34 00    	call   *0x3403dd(%rip)        # b2afa8 <_DYNAMIC+0x2d8>
  7eabcb:	48 8d 05 5e ab 31 00 	lea    0x31ab5e(%rip),%rax        # b05730 <anon.e15953efb999cecb448192f678c23055.38.llvm.10952606936216045542>
  7eabd2:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  7eabd7:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  7eabdc:	ff 15 be 03 34 00    	call   *0x3403be(%rip)        # b2afa0 <_DYNAMIC+0x2d0>
  7eabe2:	eb 2f                	jmp    7eac13 <<parley::editing::geometry::CursorGeometry<()>>::new+0x833>
  7eabe4:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  7eabe9:	48 8d 05 60 a2 31 00 	lea    0x31a260(%rip),%rax        # b04e50 <anon.48eabac924674053adbe92ba251c58bc.2.llvm.10242891199130889596+0x2c0>
  7eabf0:	eb 0c                	jmp    7eabfe <<parley::editing::geometry::CursorGeometry<()>>::new+0x81e>
  7eabf2:	4c 89 54 24 10       	mov    %r10,0x10(%rsp)
  7eabf7:	48 8d 05 3a a2 31 00 	lea    0x31a23a(%rip),%rax        # b04e38 <anon.48eabac924674053adbe92ba251c58bc.2.llvm.10242891199130889596+0x2a8>
  7eabfe:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  7eac03:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  7eac08:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  7eac0d:	ff 15 8d 03 34 00    	call   *0x34038d(%rip)        # b2afa0 <_DYNAMIC+0x2d0>
  7eac13:	0f 0b                	ud2
  7eac15:	eb 04                	jmp    7eac1b <<parley::editing::geometry::CursorGeometry<()>>::new+0x83b>
  7eac17:	eb 02                	jmp    7eac1b <<parley::editing::geometry::CursorGeometry<()>>::new+0x83b>
  7eac19:	eb 00                	jmp    7eac1b <<parley::editing::geometry::CursorGeometry<()>>::new+0x83b>
  7eac1b:	48 89 c3             	mov    %rax,%rbx
  7eac1e:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  7eac23:	e8 78 eb ff ff       	call   7e97a0 <core::ptr::drop_glue::<parley::editing::geometry::CursorGeometry<()>>>
  7eac28:	48 89 df             	mov    %rbx,%rdi
  7eac2b:	e8 60 61 31 00       	call   b00d90 <_Unwind_Resume@plt>
  7eac30:	48 89 c3             	mov    %rax,%rbx
  7eac33:	4d 85 ff             	test   %r15,%r15
  7eac36:	74 12                	je     7eac4a <<parley::editing::geometry::CursorGeometry<()>>::new+0x86a>
  7eac38:	ba 04 00 00 00       	mov    $0x4,%edx
  7eac3d:	48 8b 3c 24          	mov    (%rsp),%rdi
  7eac41:	4c 89 f6             	mov    %r14,%rsi
  7eac44:	ff 15 ce 02 34 00    	call   *0x3402ce(%rip)        # b2af18 <_DYNAMIC+0x248>
  7eac4a:	48 89 df             	mov    %rbx,%rdi
  7eac4d:	e8 3e 61 31 00       	call   b00d90 <_Unwind_Resume@plt>
