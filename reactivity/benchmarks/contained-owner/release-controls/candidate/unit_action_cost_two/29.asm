
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000070c420 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click>:
  70c420:	55                   	push   %rbp
  70c421:	41 57                	push   %r15
  70c423:	41 56                	push   %r14
  70c425:	41 55                	push   %r13
  70c427:	41 54                	push   %r12
  70c429:	53                   	push   %rbx
  70c42a:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
  70c431:	48 8b 1e             	mov    (%rsi),%rbx
  70c434:	48 85 db             	test   %rbx,%rbx
  70c437:	74 15                	je     70c44e <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x2e>
  70c439:	80 bb 22 07 00 00 01 	cmpb   $0x1,0x722(%rbx)
  70c440:	75 20                	jne    70c462 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x42>
  70c442:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70c449:	e9 03 03 00 00       	jmp    70c751 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70c44e:	48 c7 07 0d 00 00 00 	movq   $0xd,(%rdi)
  70c455:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  70c45c:	00 
  70c45d:	e9 ef 02 00 00       	jmp    70c751 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70c462:	48 3b 93 b0 05 00 00 	cmp    0x5b0(%rbx),%rdx
  70c469:	0f 85 7e 02 00 00    	jne    70c6ed <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x2cd>
  70c46f:	49 89 f4             	mov    %rsi,%r12
  70c472:	49 89 d6             	mov    %rdx,%r14
  70c475:	48 89 fd             	mov    %rdi,%rbp
  70c478:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c47d:	48 89 de             	mov    %rbx,%rsi
  70c480:	49 89 cf             	mov    %rcx,%r15
  70c483:	48 89 ca             	mov    %rcx,%rdx
  70c486:	e8 95 c8 01 00       	call   728d20 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  70c48b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70c490:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c494:	0f 85 5a 02 00 00    	jne    70c6f4 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x2d4>
  70c49a:	80 bb 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rbx)
  70c4a1:	48 89 ef             	mov    %rbp,%rdi
  70c4a4:	0f 85 a0 02 00 00    	jne    70c74a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c4aa:	80 bb 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rbx)
  70c4b1:	0f 85 93 02 00 00    	jne    70c74a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c4b7:	80 bb 20 07 00 00 00 	cmpb   $0x0,0x720(%rbx)
  70c4be:	0f 84 86 02 00 00    	je     70c74a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c4c4:	48 83 bb 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rbx)
  70c4cb:	ff 
  70c4cc:	0f 85 78 02 00 00    	jne    70c74a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c4d2:	48 8b 83 60 06 00 00 	mov    0x660(%rbx),%rax
  70c4d9:	48 3b 83 68 06 00 00 	cmp    0x668(%rbx),%rax
  70c4e0:	0f 85 64 02 00 00    	jne    70c74a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c4e6:	48 8b 83 78 06 00 00 	mov    0x678(%rbx),%rax
  70c4ed:	48 3b 83 70 06 00 00 	cmp    0x670(%rbx),%rax
  70c4f4:	0f 85 50 02 00 00    	jne    70c74a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c4fa:	f3 0f 10 83 14 07 00 	movss  0x714(%rbx),%xmm0
  70c501:	00 
  70c502:	0f 2e 83 18 07 00 00 	ucomiss 0x718(%rbx),%xmm0
  70c509:	0f 85 3b 02 00 00    	jne    70c74a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c50f:	0f 8a 35 02 00 00    	jp     70c74a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c515:	4c 89 e0             	mov    %r12,%rax
  70c518:	48 83 c0 08          	add    $0x8,%rax
  70c51c:	4c 8b ab 78 05 00 00 	mov    0x578(%rbx),%r13
  70c523:	48 8b 8b 80 05 00 00 	mov    0x580(%rbx),%rcx
  70c52a:	48 c1 e1 04          	shl    $0x4,%rcx
  70c52e:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  70c532:	45 31 e4             	xor    %r12d,%r12d
  70c535:	4c 89 ee             	mov    %r13,%rsi
  70c538:	4c 89 fa             	mov    %r15,%rdx
  70c53b:	4c 39 e1             	cmp    %r12,%rcx
  70c53e:	0f 84 22 02 00 00    	je     70c766 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x346>
  70c544:	49 83 c4 50          	add    $0x50,%r12
  70c548:	48 39 56 20          	cmp    %rdx,0x20(%rsi)
  70c54c:	48 8d 76 50          	lea    0x50(%rsi),%rsi
  70c550:	75 e9                	jne    70c53b <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x11b>
  70c552:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  70c557:	48 c7 44 24 08 11 00 	movq   $0x11,0x8(%rsp)
  70c55e:	00 00 
  70c560:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c565:	e8 86 ba fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c56a:	f3 43 0f 10 44 25 e0 	movss  -0x20(%r13,%r12,1),%xmm0
  70c571:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70c574:	7a 62                	jp     70c5d8 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1b8>
  70c576:	43 8b 44 25 f4       	mov    -0xc(%r13,%r12,1),%eax
  70c57b:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  70c57f:	43 0f 10 4c 25 e4    	movups -0x1c(%r13,%r12,1),%xmm1
  70c585:	0f 11 4c 24 0c       	movups %xmm1,0xc(%rsp)
  70c58a:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70c590:	f3 43 0f 10 44 25 b8 	movss  -0x48(%r13,%r12,1),%xmm0
  70c597:	f3 43 0f 10 4c 25 bc 	movss  -0x44(%r13,%r12,1),%xmm1
  70c59e:	48 8d 7c 24 64       	lea    0x64(%rsp),%rdi
  70c5a3:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
  70c5a8:	e8 53 dd fe ff       	call   6fa300 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click::{closure#1}>
  70c5ad:	83 7c 24 64 01       	cmpl   $0x1,0x64(%rsp)
  70c5b2:	75 24                	jne    70c5d8 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1b8>
  70c5b4:	f2 0f 10 44 24 68    	movsd  0x68(%rsp),%xmm0
  70c5ba:	0f 28 c8             	movaps %xmm0,%xmm1
  70c5bd:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70c5c1:	4b 8d 3c 2c          	lea    (%r12,%r13,1),%rdi
  70c5c5:	48 83 c7 c0          	add    $0xffffffffffffffc0,%rdi
  70c5c9:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  70c5ce:	ff 15 dc d0 41 00    	call   *0x41d0dc(%rip)        # b296b0 <_DYNAMIC+0x540>
  70c5d4:	84 c0                	test   %al,%al
  70c5d6:	75 40                	jne    70c618 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1f8>
  70c5d8:	f3 43 0f 10 44 25 c8 	movss  -0x38(%r13,%r12,1),%xmm0
  70c5df:	0f 57 d2             	xorps  %xmm2,%xmm2
  70c5e2:	0f 2e c2             	ucomiss %xmm2,%xmm0
  70c5e5:	75 06                	jne    70c5ed <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1cd>
  70c5e7:	0f 8b 82 01 00 00    	jnp    70c76f <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70c5ed:	f3 43 0f 10 4c 25 cc 	movss  -0x34(%r13,%r12,1),%xmm1
  70c5f4:	0f 2e ca             	ucomiss %xmm2,%xmm1
  70c5f7:	75 06                	jne    70c5ff <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1df>
  70c5f9:	0f 8b 70 01 00 00    	jnp    70c76f <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70c5ff:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70c602:	0f 59 05 87 e9 94 ff 	mulps  -0x6b1679(%rip),%xmm0        # 5af90 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1120>
  70c609:	f2 43 0f 10 4c 25 c0 	movsd  -0x40(%r13,%r12,1),%xmm1
  70c610:	0f 58 c8             	addps  %xmm0,%xmm1
  70c613:	0f 29 4c 24 40       	movaps %xmm1,0x40(%rsp)
  70c618:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70c61f:	00 00 
  70c621:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c626:	e8 c5 b9 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c62b:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70c630:	0f 28 c8             	movaps %xmm0,%xmm1
  70c633:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70c637:	48 89 df             	mov    %rbx,%rdi
  70c63a:	0f 29 8c 24 a0 00 00 	movaps %xmm1,0xa0(%rsp)
  70c641:	00 
  70c642:	e8 99 c9 01 00       	call   728fe0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::hit>
  70c647:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70c64e:	00 00 
  70c650:	a8 01                	test   $0x1,%al
  70c652:	0f 84 17 01 00 00    	je     70c76f <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70c658:	49 89 d5             	mov    %rdx,%r13
  70c65b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c660:	e8 8b b9 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c665:	4d 39 fd             	cmp    %r15,%r13
  70c668:	0f 85 01 01 00 00    	jne    70c76f <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70c66e:	4c 3b b3 b0 05 00 00 	cmp    0x5b0(%rbx),%r14
  70c675:	0f 85 01 01 00 00    	jne    70c77c <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x35c>
  70c67b:	4c 89 fa             	mov    %r15,%rdx
  70c67e:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c683:	48 89 de             	mov    %rbx,%rsi
  70c686:	e8 95 c6 01 00       	call   728d20 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  70c68b:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  70c690:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c695:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  70c699:	0f 85 e2 00 00 00    	jne    70c781 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x361>
  70c69f:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70c6a6:	48 39 f0             	cmp    %rsi,%rax
  70c6a9:	0f 83 88 01 00 00    	jae    70c837 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x417>
  70c6af:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70c6b6:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  70c6ba:	8b 44 c1 20          	mov    0x20(%rcx,%rax,8),%eax
  70c6be:	83 e0 07             	and    $0x7,%eax
  70c6c1:	83 f8 02             	cmp    $0x2,%eax
  70c6c4:	0f 85 df 00 00 00    	jne    70c7a9 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x389>
  70c6ca:	48 89 ef             	mov    %rbp,%rdi
  70c6cd:	48 89 de             	mov    %rbx,%rsi
  70c6d0:	4c 89 f2             	mov    %r14,%rdx
  70c6d3:	4c 89 f9             	mov    %r15,%rcx
  70c6d6:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70c6db:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70c6e2:	00 
  70c6e3:	e8 28 91 ff ff       	call   705810 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer>
  70c6e8:	e9 05 01 00 00       	jmp    70c7f2 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x3d2>
  70c6ed:	b8 11 00 00 00       	mov    $0x11,%eax
  70c6f2:	eb 2c                	jmp    70c720 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x300>
  70c6f4:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  70c6f9:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70c6fe:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70c703:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70c708:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  70c70f:	00 
  70c710:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70c715:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  70c71c:	00 
  70c71d:	48 89 ef             	mov    %rbp,%rdi
  70c720:	48 89 07             	mov    %rax,(%rdi)
  70c723:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70c727:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70c72c:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
  70c733:	00 
  70c734:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70c738:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  70c73c:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  70c743:	00 
  70c744:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70c748:	eb 07                	jmp    70c751 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70c74a:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70c751:	48 89 f8             	mov    %rdi,%rax
  70c754:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  70c75b:	5b                   	pop    %rbx
  70c75c:	41 5c                	pop    %r12
  70c75e:	41 5d                	pop    %r13
  70c760:	41 5e                	pop    %r14
  70c762:	41 5f                	pop    %r15
  70c764:	5d                   	pop    %rbp
  70c765:	c3                   	ret
  70c766:	48 c7 07 11 00 00 00 	movq   $0x11,(%rdi)
  70c76d:	eb e2                	jmp    70c751 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70c76f:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70c776:	00 
  70c777:	48 89 e8             	mov    %rbp,%rax
  70c77a:	eb d8                	jmp    70c754 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70c77c:	b9 11 00 00 00       	mov    $0x11,%ecx
  70c781:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70c786:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  70c78a:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70c78f:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70c794:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  70c798:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70c79c:	48 89 4d 00          	mov    %rcx,0x0(%rbp)
  70c7a0:	48 89 45 08          	mov    %rax,0x8(%rbp)
  70c7a4:	48 89 e8             	mov    %rbp,%rax
  70c7a7:	eb ab                	jmp    70c754 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70c7a9:	4c 8b ab e8 05 00 00 	mov    0x5e8(%rbx),%r13
  70c7b0:	4c 8b a3 f0 05 00 00 	mov    0x5f0(%rbx),%r12
  70c7b7:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c7bc:	48 89 de             	mov    %rbx,%rsi
  70c7bf:	4c 89 f2             	mov    %r14,%rdx
  70c7c2:	4c 89 f9             	mov    %r15,%rcx
  70c7c5:	e8 16 4b ff ff       	call   7012e0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::focus>
  70c7ca:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70c7cf:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c7d3:	75 25                	jne    70c7fa <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x3da>
  70c7d5:	4c 89 24 24          	mov    %r12,(%rsp)
  70c7d9:	48 89 ef             	mov    %rbp,%rdi
  70c7dc:	48 89 de             	mov    %rbx,%rsi
  70c7df:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  70c7e4:	4c 89 f1             	mov    %r14,%rcx
  70c7e7:	4d 89 f8             	mov    %r15,%r8
  70c7ea:	4d 89 e9             	mov    %r13,%r9
  70c7ed:	e8 ce 13 ff ff       	call   6fdbc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused>
  70c7f2:	48 89 e8             	mov    %rbp,%rax
  70c7f5:	e9 5a ff ff ff       	jmp    70c754 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70c7fa:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  70c7ff:	0f b6 54 24 38       	movzbl 0x38(%rsp),%edx
  70c804:	8b 74 24 3c          	mov    0x3c(%rsp),%esi
  70c808:	89 75 34             	mov    %esi,0x34(%rbp)
  70c80b:	8b 74 24 39          	mov    0x39(%rsp),%esi
  70c80f:	89 75 31             	mov    %esi,0x31(%rbp)
  70c812:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  70c817:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  70c81c:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70c820:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70c824:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70c828:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  70c82c:	88 55 30             	mov    %dl,0x30(%rbp)
  70c82f:	48 89 e8             	mov    %rbp,%rax
  70c832:	e9 1d ff ff ff       	jmp    70c754 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70c837:	48 8d 15 12 ea 3e 00 	lea    0x3eea12(%rip),%rdx        # afb250 <__frame_dummy_init_array_entry+0x948>
  70c83e:	48 89 c7             	mov    %rax,%rdi
  70c841:	ff 15 81 cc 41 00    	call   *0x41cc81(%rip)        # b294c8 <_DYNAMIC+0x358>
