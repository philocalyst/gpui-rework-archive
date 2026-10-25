
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000070c3b0 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click>:
  70c3b0:	55                   	push   %rbp
  70c3b1:	41 57                	push   %r15
  70c3b3:	41 56                	push   %r14
  70c3b5:	41 55                	push   %r13
  70c3b7:	41 54                	push   %r12
  70c3b9:	53                   	push   %rbx
  70c3ba:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
  70c3c1:	48 8b 1e             	mov    (%rsi),%rbx
  70c3c4:	48 85 db             	test   %rbx,%rbx
  70c3c7:	74 15                	je     70c3de <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x2e>
  70c3c9:	80 bb 22 07 00 00 01 	cmpb   $0x1,0x722(%rbx)
  70c3d0:	75 20                	jne    70c3f2 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x42>
  70c3d2:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70c3d9:	e9 03 03 00 00       	jmp    70c6e1 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70c3de:	48 c7 07 0d 00 00 00 	movq   $0xd,(%rdi)
  70c3e5:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  70c3ec:	00 
  70c3ed:	e9 ef 02 00 00       	jmp    70c6e1 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70c3f2:	48 3b 93 b0 05 00 00 	cmp    0x5b0(%rbx),%rdx
  70c3f9:	0f 85 7e 02 00 00    	jne    70c67d <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x2cd>
  70c3ff:	49 89 f4             	mov    %rsi,%r12
  70c402:	49 89 d6             	mov    %rdx,%r14
  70c405:	48 89 fd             	mov    %rdi,%rbp
  70c408:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c40d:	48 89 de             	mov    %rbx,%rsi
  70c410:	49 89 cf             	mov    %rcx,%r15
  70c413:	48 89 ca             	mov    %rcx,%rdx
  70c416:	e8 95 c8 01 00       	call   728cb0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  70c41b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70c420:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c424:	0f 85 5a 02 00 00    	jne    70c684 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x2d4>
  70c42a:	80 bb 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rbx)
  70c431:	48 89 ef             	mov    %rbp,%rdi
  70c434:	0f 85 a0 02 00 00    	jne    70c6da <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c43a:	80 bb 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rbx)
  70c441:	0f 85 93 02 00 00    	jne    70c6da <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c447:	80 bb 20 07 00 00 00 	cmpb   $0x0,0x720(%rbx)
  70c44e:	0f 84 86 02 00 00    	je     70c6da <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c454:	48 83 bb 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rbx)
  70c45b:	ff 
  70c45c:	0f 85 78 02 00 00    	jne    70c6da <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c462:	48 8b 83 60 06 00 00 	mov    0x660(%rbx),%rax
  70c469:	48 3b 83 68 06 00 00 	cmp    0x668(%rbx),%rax
  70c470:	0f 85 64 02 00 00    	jne    70c6da <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c476:	48 8b 83 78 06 00 00 	mov    0x678(%rbx),%rax
  70c47d:	48 3b 83 70 06 00 00 	cmp    0x670(%rbx),%rax
  70c484:	0f 85 50 02 00 00    	jne    70c6da <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c48a:	f3 0f 10 83 14 07 00 	movss  0x714(%rbx),%xmm0
  70c491:	00 
  70c492:	0f 2e 83 18 07 00 00 	ucomiss 0x718(%rbx),%xmm0
  70c499:	0f 85 3b 02 00 00    	jne    70c6da <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c49f:	0f 8a 35 02 00 00    	jp     70c6da <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c4a5:	4c 89 e0             	mov    %r12,%rax
  70c4a8:	48 83 c0 08          	add    $0x8,%rax
  70c4ac:	4c 8b ab 78 05 00 00 	mov    0x578(%rbx),%r13
  70c4b3:	48 8b 8b 80 05 00 00 	mov    0x580(%rbx),%rcx
  70c4ba:	48 c1 e1 04          	shl    $0x4,%rcx
  70c4be:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  70c4c2:	45 31 e4             	xor    %r12d,%r12d
  70c4c5:	4c 89 ee             	mov    %r13,%rsi
  70c4c8:	4c 89 fa             	mov    %r15,%rdx
  70c4cb:	4c 39 e1             	cmp    %r12,%rcx
  70c4ce:	0f 84 22 02 00 00    	je     70c6f6 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x346>
  70c4d4:	49 83 c4 50          	add    $0x50,%r12
  70c4d8:	48 39 56 20          	cmp    %rdx,0x20(%rsi)
  70c4dc:	48 8d 76 50          	lea    0x50(%rsi),%rsi
  70c4e0:	75 e9                	jne    70c4cb <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x11b>
  70c4e2:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  70c4e7:	48 c7 44 24 08 11 00 	movq   $0x11,0x8(%rsp)
  70c4ee:	00 00 
  70c4f0:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c4f5:	e8 e6 ba fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c4fa:	f3 43 0f 10 44 25 e0 	movss  -0x20(%r13,%r12,1),%xmm0
  70c501:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70c504:	7a 62                	jp     70c568 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1b8>
  70c506:	43 8b 44 25 f4       	mov    -0xc(%r13,%r12,1),%eax
  70c50b:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  70c50f:	43 0f 10 4c 25 e4    	movups -0x1c(%r13,%r12,1),%xmm1
  70c515:	0f 11 4c 24 0c       	movups %xmm1,0xc(%rsp)
  70c51a:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70c520:	f3 43 0f 10 44 25 b8 	movss  -0x48(%r13,%r12,1),%xmm0
  70c527:	f3 43 0f 10 4c 25 bc 	movss  -0x44(%r13,%r12,1),%xmm1
  70c52e:	48 8d 7c 24 64       	lea    0x64(%rsp),%rdi
  70c533:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
  70c538:	e8 b3 dd fe ff       	call   6fa2f0 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click::{closure#1}>
  70c53d:	83 7c 24 64 01       	cmpl   $0x1,0x64(%rsp)
  70c542:	75 24                	jne    70c568 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1b8>
  70c544:	f2 0f 10 44 24 68    	movsd  0x68(%rsp),%xmm0
  70c54a:	0f 28 c8             	movaps %xmm0,%xmm1
  70c54d:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70c551:	4b 8d 3c 2c          	lea    (%r12,%r13,1),%rdi
  70c555:	48 83 c7 c0          	add    $0xffffffffffffffc0,%rdi
  70c559:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  70c55e:	ff 15 dc d0 41 00    	call   *0x41d0dc(%rip)        # b29640 <_DYNAMIC+0x540>
  70c564:	84 c0                	test   %al,%al
  70c566:	75 40                	jne    70c5a8 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1f8>
  70c568:	f3 43 0f 10 44 25 c8 	movss  -0x38(%r13,%r12,1),%xmm0
  70c56f:	0f 57 d2             	xorps  %xmm2,%xmm2
  70c572:	0f 2e c2             	ucomiss %xmm2,%xmm0
  70c575:	75 06                	jne    70c57d <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1cd>
  70c577:	0f 8b 82 01 00 00    	jnp    70c6ff <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70c57d:	f3 43 0f 10 4c 25 cc 	movss  -0x34(%r13,%r12,1),%xmm1
  70c584:	0f 2e ca             	ucomiss %xmm2,%xmm1
  70c587:	75 06                	jne    70c58f <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1df>
  70c589:	0f 8b 70 01 00 00    	jnp    70c6ff <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70c58f:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70c592:	0f 59 05 e7 e9 94 ff 	mulps  -0x6b1619(%rip),%xmm0        # 5af80 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1120>
  70c599:	f2 43 0f 10 4c 25 c0 	movsd  -0x40(%r13,%r12,1),%xmm1
  70c5a0:	0f 58 c8             	addps  %xmm0,%xmm1
  70c5a3:	0f 29 4c 24 40       	movaps %xmm1,0x40(%rsp)
  70c5a8:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70c5af:	00 00 
  70c5b1:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c5b6:	e8 25 ba fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c5bb:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70c5c0:	0f 28 c8             	movaps %xmm0,%xmm1
  70c5c3:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70c5c7:	48 89 df             	mov    %rbx,%rdi
  70c5ca:	0f 29 8c 24 a0 00 00 	movaps %xmm1,0xa0(%rsp)
  70c5d1:	00 
  70c5d2:	e8 99 c9 01 00       	call   728f70 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::hit>
  70c5d7:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70c5de:	00 00 
  70c5e0:	a8 01                	test   $0x1,%al
  70c5e2:	0f 84 17 01 00 00    	je     70c6ff <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70c5e8:	49 89 d5             	mov    %rdx,%r13
  70c5eb:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c5f0:	e8 eb b9 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c5f5:	4d 39 fd             	cmp    %r15,%r13
  70c5f8:	0f 85 01 01 00 00    	jne    70c6ff <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70c5fe:	4c 3b b3 b0 05 00 00 	cmp    0x5b0(%rbx),%r14
  70c605:	0f 85 01 01 00 00    	jne    70c70c <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x35c>
  70c60b:	4c 89 fa             	mov    %r15,%rdx
  70c60e:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c613:	48 89 de             	mov    %rbx,%rsi
  70c616:	e8 95 c6 01 00       	call   728cb0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  70c61b:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  70c620:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c625:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  70c629:	0f 85 e2 00 00 00    	jne    70c711 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x361>
  70c62f:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70c636:	48 39 f0             	cmp    %rsi,%rax
  70c639:	0f 83 88 01 00 00    	jae    70c7c7 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x417>
  70c63f:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70c646:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  70c64a:	8b 44 c1 20          	mov    0x20(%rcx,%rax,8),%eax
  70c64e:	83 e0 07             	and    $0x7,%eax
  70c651:	83 f8 02             	cmp    $0x2,%eax
  70c654:	0f 85 df 00 00 00    	jne    70c739 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x389>
  70c65a:	48 89 ef             	mov    %rbp,%rdi
  70c65d:	48 89 de             	mov    %rbx,%rsi
  70c660:	4c 89 f2             	mov    %r14,%rdx
  70c663:	4c 89 f9             	mov    %r15,%rcx
  70c666:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70c66b:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70c672:	00 
  70c673:	e8 28 91 ff ff       	call   7057a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer>
  70c678:	e9 05 01 00 00       	jmp    70c782 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x3d2>
  70c67d:	b8 11 00 00 00       	mov    $0x11,%eax
  70c682:	eb 2c                	jmp    70c6b0 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x300>
  70c684:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  70c689:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70c68e:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70c693:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70c698:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  70c69f:	00 
  70c6a0:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70c6a5:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  70c6ac:	00 
  70c6ad:	48 89 ef             	mov    %rbp,%rdi
  70c6b0:	48 89 07             	mov    %rax,(%rdi)
  70c6b3:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70c6b7:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70c6bc:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
  70c6c3:	00 
  70c6c4:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70c6c8:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  70c6cc:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  70c6d3:	00 
  70c6d4:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70c6d8:	eb 07                	jmp    70c6e1 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70c6da:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70c6e1:	48 89 f8             	mov    %rdi,%rax
  70c6e4:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  70c6eb:	5b                   	pop    %rbx
  70c6ec:	41 5c                	pop    %r12
  70c6ee:	41 5d                	pop    %r13
  70c6f0:	41 5e                	pop    %r14
  70c6f2:	41 5f                	pop    %r15
  70c6f4:	5d                   	pop    %rbp
  70c6f5:	c3                   	ret
  70c6f6:	48 c7 07 11 00 00 00 	movq   $0x11,(%rdi)
  70c6fd:	eb e2                	jmp    70c6e1 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70c6ff:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70c706:	00 
  70c707:	48 89 e8             	mov    %rbp,%rax
  70c70a:	eb d8                	jmp    70c6e4 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70c70c:	b9 11 00 00 00       	mov    $0x11,%ecx
  70c711:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70c716:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  70c71a:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70c71f:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70c724:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  70c728:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70c72c:	48 89 4d 00          	mov    %rcx,0x0(%rbp)
  70c730:	48 89 45 08          	mov    %rax,0x8(%rbp)
  70c734:	48 89 e8             	mov    %rbp,%rax
  70c737:	eb ab                	jmp    70c6e4 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70c739:	4c 8b ab e8 05 00 00 	mov    0x5e8(%rbx),%r13
  70c740:	4c 8b a3 f0 05 00 00 	mov    0x5f0(%rbx),%r12
  70c747:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c74c:	48 89 de             	mov    %rbx,%rsi
  70c74f:	4c 89 f2             	mov    %r14,%rdx
  70c752:	4c 89 f9             	mov    %r15,%rcx
  70c755:	e8 16 4b ff ff       	call   701270 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::focus>
  70c75a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70c75f:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c763:	75 25                	jne    70c78a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x3da>
  70c765:	4c 89 24 24          	mov    %r12,(%rsp)
  70c769:	48 89 ef             	mov    %rbp,%rdi
  70c76c:	48 89 de             	mov    %rbx,%rsi
  70c76f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  70c774:	4c 89 f1             	mov    %r14,%rcx
  70c777:	4d 89 f8             	mov    %r15,%r8
  70c77a:	4d 89 e9             	mov    %r13,%r9
  70c77d:	e8 fe 13 ff ff       	call   6fdb80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused>
  70c782:	48 89 e8             	mov    %rbp,%rax
  70c785:	e9 5a ff ff ff       	jmp    70c6e4 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70c78a:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  70c78f:	0f b6 54 24 38       	movzbl 0x38(%rsp),%edx
  70c794:	8b 74 24 3c          	mov    0x3c(%rsp),%esi
  70c798:	89 75 34             	mov    %esi,0x34(%rbp)
  70c79b:	8b 74 24 39          	mov    0x39(%rsp),%esi
  70c79f:	89 75 31             	mov    %esi,0x31(%rbp)
  70c7a2:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  70c7a7:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  70c7ac:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70c7b0:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70c7b4:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70c7b8:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  70c7bc:	88 55 30             	mov    %dl,0x30(%rbp)
  70c7bf:	48 89 e8             	mov    %rbp,%rax
  70c7c2:	e9 1d ff ff ff       	jmp    70c6e4 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70c7c7:	48 8d 15 12 ea 3e 00 	lea    0x3eea12(%rip),%rdx        # afb1e0 <__frame_dummy_init_array_entry+0x948>
  70c7ce:	48 89 c7             	mov    %rax,%rdi
  70c7d1:	ff 15 81 cc 41 00    	call   *0x41cc81(%rip)        # b29458 <_DYNAMIC+0x358>
