
/tmp/gpui-ack-query-comparison/a/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a603b0 <gpui::native::accessibility::project>:
  a603b0:	55                   	push   %rbp
  a603b1:	41 57                	push   %r15
  a603b3:	41 56                	push   %r14
  a603b5:	41 55                	push   %r13
  a603b7:	41 54                	push   %r12
  a603b9:	53                   	push   %rbx
  a603ba:	48 81 ec 58 01 00 00 	sub    $0x158,%rsp
  a603c1:	48 b8 57 57 57 57 57 	movabs $0x5757575757575757,%rax
  a603c8:	57 57 57 
  a603cb:	48 89 84 24 3f 01 00 	mov    %rax,0x13f(%rsp)
  a603d2:	00 
  a603d3:	66 0f 28 05 95 cd 72 	movapd -0x8d326b(%rip),%xmm0        # 18d170 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a603da:	ff 
  a603db:	66 0f 11 84 24 30 01 	movupd %xmm0,0x130(%rsp)
  a603e2:	00 00 
  a603e4:	66 0f 11 84 24 20 01 	movupd %xmm0,0x120(%rsp)
  a603eb:	00 00 
  a603ed:	66 0f 11 84 24 10 01 	movupd %xmm0,0x110(%rsp)
  a603f4:	00 00 
  a603f6:	66 0f 11 84 24 00 01 	movupd %xmm0,0x100(%rsp)
  a603fd:	00 00 
  a603ff:	66 0f 11 84 24 f0 00 	movupd %xmm0,0xf0(%rsp)
  a60406:	00 00 
  a60408:	c6 84 24 54 01 00 00 	movb   $0x85,0x154(%rsp)
  a6040f:	85 
  a60410:	48 c7 84 24 48 01 00 	movq   $0x0,0x148(%rsp)
  a60417:	00 00 00 00 00 
  a6041c:	c7 84 24 50 01 00 00 	movl   $0x0,0x150(%rsp)
  a60423:	00 00 00 00 
  a60427:	48 c7 84 24 d8 00 00 	movq   $0x0,0xd8(%rsp)
  a6042e:	00 00 00 00 00 
  a60433:	48 c7 84 24 e0 00 00 	movq   $0x8,0xe0(%rsp)
  a6043a:	00 08 00 00 00 
  a6043f:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  a60446:	00 00 00 00 00 
  a6044b:	4d 85 c0             	test   %r8,%r8
  a6044e:	0f 88 18 01 00 00    	js     a6056c <gpui::native::accessibility::project+0x1bc>
  a60454:	4d 89 cf             	mov    %r9,%r15
  a60457:	4d 89 c4             	mov    %r8,%r12
  a6045a:	49 89 d5             	mov    %rdx,%r13
  a6045d:	49 89 f6             	mov    %rsi,%r14
  a60460:	48 89 bc 24 d0 00 00 	mov    %rdi,0xd0(%rsp)
  a60467:	00 
  a60468:	74 43                	je     a604ad <gpui::native::accessibility::project+0xfd>
  a6046a:	48 89 8c 24 c8 00 00 	mov    %rcx,0xc8(%rsp)
  a60471:	00 
  a60472:	ff 15 68 f9 ac 00    	call   *0xacf968(%rip)        # 152fde0 <_DYNAMIC+0x240>
  a60478:	bd 01 00 00 00       	mov    $0x1,%ebp
  a6047d:	be 01 00 00 00       	mov    $0x1,%esi
  a60482:	4c 89 e7             	mov    %r12,%rdi
  a60485:	ff 15 5d f9 ac 00    	call   *0xacf95d(%rip)        # 152fde8 <_DYNAMIC+0x248>
  a6048b:	48 85 c0             	test   %rax,%rax
  a6048e:	0f 84 da 00 00 00    	je     a6056e <gpui::native::accessibility::project+0x1be>
  a60494:	48 89 c3             	mov    %rax,%rbx
  a60497:	48 89 c7             	mov    %rax,%rdi
  a6049a:	48 8b b4 24 c8 00 00 	mov    0xc8(%rsp),%rsi
  a604a1:	00 
  a604a2:	4c 89 e2             	mov    %r12,%rdx
  a604a5:	ff 15 55 f9 ac 00    	call   *0xacf955(%rip)        # 152fe00 <memcpy@GLIBC_2.14>
  a604ab:	eb 05                	jmp    a604b2 <gpui::native::accessibility::project+0x102>
  a604ad:	bb 01 00 00 00       	mov    $0x1,%ebx
  a604b2:	4c 89 64 24 48       	mov    %r12,0x48(%rsp)
  a604b7:	48 89 5c 24 50       	mov    %rbx,0x50(%rsp)
  a604bc:	4c 89 64 24 58       	mov    %r12,0x58(%rsp)
  a604c1:	c6 44 24 40 03       	movb   $0x3,0x40(%rsp)
  a604c6:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a604cd:	00 
  a604ce:	48 8d 54 24 40       	lea    0x40(%rsp),%rdx
  a604d3:	be 0f 00 00 00       	mov    $0xf,%esi
  a604d8:	ff 15 82 0d ad 00    	call   *0xad0d82(%rip)        # 1531260 <_DYNAMIC+0x16c0>
  a604de:	80 8c 24 51 01 00 00 	orb    $0x8,0x151(%rsp)
  a604e5:	08 
  a604e6:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
  a604ea:	66 0f 29 44 24 40    	movapd %xmm0,0x40(%rsp)
  a604f0:	f2 41 0f 10 4d 28    	movsd  0x28(%r13),%xmm1
  a604f6:	0f 14 c8             	unpcklps %xmm0,%xmm1
  a604f9:	66 0f 28 05 4f ee 72 	movapd -0x8d11b1(%rip),%xmm0        # 18f350 <anon.05933fb6bb17d4b782622fe161e9f81c.309.llvm.18391229140309290632+0x950>
  a60500:	ff 
  a60501:	66 0f 56 c8          	orpd   %xmm0,%xmm1
  a60505:	66 0f 5c c8          	subpd  %xmm0,%xmm1
  a60509:	66 0f 29 4c 24 50    	movapd %xmm1,0x50(%rsp)
  a6050f:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a60516:	00 
  a60517:	48 8d 54 24 40       	lea    0x40(%rsp),%rdx
  a6051c:	be 53 00 00 00       	mov    $0x53,%esi
  a60521:	ff 15 51 0d ad 00    	call   *0xad0d51(%rip)        # 1531278 <_DYNAMIC+0x16d8>
  a60527:	4d 8b 6e 38          	mov    0x38(%r14),%r13
  a6052b:	4d 85 ed             	test   %r13,%r13
  a6052e:	74 4f                	je     a6057f <gpui::native::accessibility::project+0x1cf>
  a60530:	49 8d 5d 01          	lea    0x1(%r13),%rbx
  a60534:	45 31 e4             	xor    %r12d,%r12d
  a60537:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  a6053e:	00 00 
  a60540:	4c 89 ff             	mov    %r15,%rdi
  a60543:	4c 89 f6             	mov    %r14,%rsi
  a60546:	44 89 e2             	mov    %r12d,%edx
  a60549:	e8 d2 8e 00 00       	call   a69420 <<gpui::native::accessibility::text::Cohort>::text_count>
  a6054e:	48 01 c3             	add    %rax,%rbx
  a60551:	49 ff c4             	inc    %r12
  a60554:	4d 39 e5             	cmp    %r12,%r13
  a60557:	75 e7                	jne    a60540 <gpui::native::accessibility::project+0x190>
  a60559:	48 b8 f0 f0 f0 f0 f0 	movabs $0xf0f0f0f0f0f0f0,%rax
  a60560:	f0 f0 00 
  a60563:	48 39 c3             	cmp    %rax,%rbx
  a60566:	0f 86 8e 02 00 00    	jbe    a607fa <gpui::native::accessibility::project+0x44a>
  a6056c:	31 ed                	xor    %ebp,%ebp
  a6056e:	48 89 ef             	mov    %rbp,%rdi
  a60571:	4c 89 e6             	mov    %r12,%rsi
  a60574:	ff 15 5e f9 ac 00    	call   *0xacf95e(%rip)        # 152fed8 <_DYNAMIC+0x338>
  a6057a:	e9 aa 02 00 00       	jmp    a60829 <gpui::native::accessibility::project+0x479>
  a6057f:	41 bc 88 00 00 00    	mov    $0x88,%r12d
  a60585:	bb 01 00 00 00       	mov    $0x1,%ebx
  a6058a:	ff 15 50 f8 ac 00    	call   *0xacf850(%rip)        # 152fde0 <_DYNAMIC+0x240>
  a60590:	bd 08 00 00 00       	mov    $0x8,%ebp
  a60595:	be 08 00 00 00       	mov    $0x8,%esi
  a6059a:	4c 89 e7             	mov    %r12,%rdi
  a6059d:	ff 15 45 f8 ac 00    	call   *0xacf845(%rip)        # 152fde8 <_DYNAMIC+0x248>
  a605a3:	48 85 c0             	test   %rax,%rax
  a605a6:	74 c6                	je     a6056e <gpui::native::accessibility::project+0x1be>
  a605a8:	48 89 c7             	mov    %rax,%rdi
  a605ab:	48 89 5c 24 08       	mov    %rbx,0x8(%rsp)
  a605b0:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  a605b5:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  a605bc:	00 00 
  a605be:	0f 10 84 24 48 01 00 	movups 0x148(%rsp),%xmm0
  a605c5:	00 
  a605c6:	0f 11 84 24 b8 00 00 	movups %xmm0,0xb8(%rsp)
  a605cd:	00 
  a605ce:	0f 10 84 24 38 01 00 	movups 0x138(%rsp),%xmm0
  a605d5:	00 
  a605d6:	0f 11 84 24 a8 00 00 	movups %xmm0,0xa8(%rsp)
  a605dd:	00 
  a605de:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  a605e5:	00 
  a605e6:	0f 11 84 24 98 00 00 	movups %xmm0,0x98(%rsp)
  a605ed:	00 
  a605ee:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  a605f5:	00 
  a605f6:	0f 11 84 24 88 00 00 	movups %xmm0,0x88(%rsp)
  a605fd:	00 
  a605fe:	66 0f 10 84 24 d8 00 	movupd 0xd8(%rsp),%xmm0
  a60605:	00 00 
  a60607:	66 0f 10 8c 24 e8 00 	movupd 0xe8(%rsp),%xmm1
  a6060e:	00 00 
  a60610:	0f 10 94 24 f8 00 00 	movups 0xf8(%rsp),%xmm2
  a60617:	00 
  a60618:	0f 10 9c 24 08 01 00 	movups 0x108(%rsp),%xmm3
  a6061f:	00 
  a60620:	0f 11 5c 24 78       	movups %xmm3,0x78(%rsp)
  a60625:	0f 11 54 24 68       	movups %xmm2,0x68(%rsp)
  a6062a:	66 0f 11 4c 24 58    	movupd %xmm1,0x58(%rsp)
  a60630:	66 0f 11 44 24 48    	movupd %xmm0,0x48(%rsp)
  a60636:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  a6063d:	00 00 
  a6063f:	48 85 db             	test   %rbx,%rbx
  a60642:	48 8b 9c 24 d0 00 00 	mov    0xd0(%rsp),%rbx
  a60649:	00 
  a6064a:	75 10                	jne    a6065c <gpui::native::accessibility::project+0x2ac>
  a6064c:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  a60651:	ff 15 01 0c ad 00    	call   *0xad0c01(%rip)        # 1531258 <_DYNAMIC+0x16b8>
  a60657:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  a6065c:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  a60661:	ba 88 00 00 00       	mov    $0x88,%edx
  a60666:	ff 15 94 f7 ac 00    	call   *0xacf794(%rip)        # 152fe00 <memcpy@GLIBC_2.14>
  a6066c:	48 c7 44 24 18 01 00 	movq   $0x1,0x18(%rsp)
  a60673:	00 00 
  a60675:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  a6067c:	00 00 
  a6067e:	48 c7 44 24 30 08 00 	movq   $0x8,0x30(%rsp)
  a60685:	00 00 
  a60687:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  a6068e:	00 00 
  a60690:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  a60697:	00 00 
  a60699:	48 8d 44 24 28       	lea    0x28(%rsp),%rax
  a6069e:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  a606a3:	4c 89 7c 24 48       	mov    %r15,0x48(%rsp)
  a606a8:	48 8d 44 24 08       	lea    0x8(%rsp),%rax
  a606ad:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  a606b2:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  a606b7:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  a606bc:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  a606c1:	4c 89 f7             	mov    %r14,%rdi
  a606c4:	e8 27 c8 01 00       	call   a7cef0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>>
  a606c9:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  a606d0:	00 00 
  a606d2:	48 c7 44 24 40 ff ff 	movq   $0xffffffffffffffff,0x40(%rsp)
  a606d9:	ff ff 
  a606db:	48 c7 44 24 58 ff ff 	movq   $0xffffffffffffffff,0x58(%rsp)
  a606e2:	ff ff 
  a606e4:	ff 15 f6 f6 ac 00    	call   *0xacf6f6(%rip)        # 152fde0 <_DYNAMIC+0x240>
  a606ea:	41 be 04 00 00 00    	mov    $0x4,%r14d
  a606f0:	bf 04 00 00 00       	mov    $0x4,%edi
  a606f5:	be 01 00 00 00       	mov    $0x1,%esi
  a606fa:	ff 15 e8 f6 ac 00    	call   *0xacf6e8(%rip)        # 152fde8 <_DYNAMIC+0x248>
  a60700:	48 85 c0             	test   %rax,%rax
  a60703:	0f 84 12 01 00 00    	je     a6081b <gpui::native::accessibility::project+0x46b>
  a60709:	c7 00 47 50 55 49    	movl   $0x49555047,(%rax)
  a6070f:	48 c7 44 24 40 04 00 	movq   $0x4,0x40(%rsp)
  a60716:	00 00 
  a60718:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  a6071d:	48 c7 44 24 50 04 00 	movq   $0x4,0x50(%rsp)
  a60724:	00 00 
  a60726:	ff 15 b4 f6 ac 00    	call   *0xacf6b4(%rip)        # 152fde0 <_DYNAMIC+0x240>
  a6072c:	41 be 05 00 00 00    	mov    $0x5,%r14d
  a60732:	bf 05 00 00 00       	mov    $0x5,%edi
  a60737:	be 01 00 00 00       	mov    $0x1,%esi
  a6073c:	ff 15 a6 f6 ac 00    	call   *0xacf6a6(%rip)        # 152fde8 <_DYNAMIC+0x248>
  a60742:	48 85 c0             	test   %rax,%rax
  a60745:	0f 84 d0 00 00 00    	je     a6081b <gpui::native::accessibility::project+0x46b>
  a6074b:	c6 40 04 30          	movb   $0x30,0x4(%rax)
  a6074f:	c7 00 30 2e 31 2e    	movl   $0x2e312e30,(%rax)
  a60755:	48 c7 44 24 58 05 00 	movq   $0x5,0x58(%rsp)
  a6075c:	00 00 
  a6075e:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  a60763:	48 c7 44 24 68 05 00 	movq   $0x5,0x68(%rsp)
  a6076a:	00 00 
  a6076c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  a60771:	48 89 43 10          	mov    %rax,0x10(%rbx)
  a60775:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  a6077a:	0f 11 03             	movups %xmm0,(%rbx)
  a6077d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  a60782:	48 89 43 48          	mov    %rax,0x48(%rbx)
  a60786:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  a6078b:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  a60790:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  a60795:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  a6079a:	48 89 53 38          	mov    %rdx,0x38(%rbx)
  a6079e:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  a607a3:	48 89 53 40          	mov    %rdx,0x40(%rbx)
  a607a7:	48 89 43 28          	mov    %rax,0x28(%rbx)
  a607ab:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  a607af:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  a607b3:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  a607b8:	0f 57 c0             	xorps  %xmm0,%xmm0
  a607bb:	0f 11 43 50          	movups %xmm0,0x50(%rbx)
  a607bf:	48 89 43 60          	mov    %rax,0x60(%rbx)
  a607c3:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  a607c8:	48 85 c0             	test   %rax,%rax
  a607cb:	74 18                	je     a607e5 <gpui::native::accessibility::project+0x435>
  a607cd:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  a607d2:	48 c1 e0 03          	shl    $0x3,%rax
  a607d6:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  a607da:	ba 08 00 00 00       	mov    $0x8,%edx
  a607df:	ff 15 0b f6 ac 00    	call   *0xacf60b(%rip)        # 152fdf0 <_DYNAMIC+0x250>
  a607e5:	48 89 d8             	mov    %rbx,%rax
  a607e8:	48 81 c4 58 01 00 00 	add    $0x158,%rsp
  a607ef:	5b                   	pop    %rbx
  a607f0:	41 5c                	pop    %r12
  a607f2:	41 5d                	pop    %r13
  a607f4:	41 5e                	pop    %r14
  a607f6:	41 5f                	pop    %r15
  a607f8:	5d                   	pop    %rbp
  a607f9:	c3                   	ret
  a607fa:	48 85 db             	test   %rbx,%rbx
  a607fd:	74 10                	je     a6080f <gpui::native::accessibility::project+0x45f>
  a607ff:	48 89 d8             	mov    %rbx,%rax
  a60802:	48 c1 e0 07          	shl    $0x7,%rax
  a60806:	4c 8d 24 d8          	lea    (%rax,%rbx,8),%r12
  a6080a:	e9 7b fd ff ff       	jmp    a6058a <gpui::native::accessibility::project+0x1da>
  a6080f:	bf 08 00 00 00       	mov    $0x8,%edi
  a60814:	31 db                	xor    %ebx,%ebx
  a60816:	e9 90 fd ff ff       	jmp    a605ab <gpui::native::accessibility::project+0x1fb>
  a6081b:	bf 01 00 00 00       	mov    $0x1,%edi
  a60820:	4c 89 f6             	mov    %r14,%rsi
  a60823:	ff 15 af f6 ac 00    	call   *0xacf6af(%rip)        # 152fed8 <_DYNAMIC+0x338>
  a60829:	0f 0b                	ud2
  a6082b:	48 89 c3             	mov    %rax,%rbx
  a6082e:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a60833:	e8 28 cd ff ff       	call   a5d560 <core::ptr::drop_glue::<(accesskit::NodeId, accesskit::Node)>>
  a60838:	eb 3a                	jmp    a60874 <gpui::native::accessibility::project+0x4c4>
  a6083a:	ff 15 e8 f5 ac 00    	call   *0xacf5e8(%rip)        # 152fe28 <_DYNAMIC+0x288>
  a60840:	48 89 c3             	mov    %rax,%rbx
  a60843:	eb 0d                	jmp    a60852 <gpui::native::accessibility::project+0x4a2>
  a60845:	48 89 c3             	mov    %rax,%rbx
  a60848:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a6084d:	e8 2e c0 ff ff       	call   a5c880 <core::ptr::drop_glue::<accesskit::TreeInfo>>
  a60852:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  a60857:	48 85 c0             	test   %rax,%rax
  a6085a:	74 18                	je     a60874 <gpui::native::accessibility::project+0x4c4>
  a6085c:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  a60861:	48 c1 e0 03          	shl    $0x3,%rax
  a60865:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  a60869:	ba 08 00 00 00       	mov    $0x8,%edx
  a6086e:	ff 15 7c f5 ac 00    	call   *0xacf57c(%rip)        # 152fdf0 <_DYNAMIC+0x250>
  a60874:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  a60879:	e8 b2 bc ff ff       	call   a5c530 <core::ptr::drop_glue::<alloc::vec::Vec<(accesskit::NodeId, accesskit::Node)>>>
  a6087e:	eb 12                	jmp    a60892 <gpui::native::accessibility::project+0x4e2>
  a60880:	eb 00                	jmp    a60882 <gpui::native::accessibility::project+0x4d2>
  a60882:	48 89 c3             	mov    %rax,%rbx
  a60885:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a6088c:	00 
  a6088d:	e8 1e bf ff ff       	call   a5c7b0 <core::ptr::drop_glue::<accesskit::Node>>
  a60892:	48 89 df             	mov    %rbx,%rdi
  a60895:	e8 d6 9d a5 00       	call   14ba670 <_Unwind_Resume@plt>
  a6089a:	ff 15 88 f5 ac 00    	call   *0xacf588(%rip)        # 152fe28 <_DYNAMIC+0x288>
