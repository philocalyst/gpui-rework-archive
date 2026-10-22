
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000070c320 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click>:
  70c320:	55                   	push   %rbp
  70c321:	41 57                	push   %r15
  70c323:	41 56                	push   %r14
  70c325:	41 55                	push   %r13
  70c327:	41 54                	push   %r12
  70c329:	53                   	push   %rbx
  70c32a:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
  70c331:	48 8b 1e             	mov    (%rsi),%rbx
  70c334:	48 85 db             	test   %rbx,%rbx
  70c337:	74 15                	je     70c34e <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x2e>
  70c339:	80 bb 22 07 00 00 01 	cmpb   $0x1,0x722(%rbx)
  70c340:	75 20                	jne    70c362 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x42>
  70c342:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70c349:	e9 03 03 00 00       	jmp    70c651 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70c34e:	48 c7 07 0d 00 00 00 	movq   $0xd,(%rdi)
  70c355:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  70c35c:	00 
  70c35d:	e9 ef 02 00 00       	jmp    70c651 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70c362:	48 3b 93 b0 05 00 00 	cmp    0x5b0(%rbx),%rdx
  70c369:	0f 85 7e 02 00 00    	jne    70c5ed <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x2cd>
  70c36f:	49 89 f4             	mov    %rsi,%r12
  70c372:	49 89 d6             	mov    %rdx,%r14
  70c375:	48 89 fd             	mov    %rdi,%rbp
  70c378:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c37d:	48 89 de             	mov    %rbx,%rsi
  70c380:	49 89 cf             	mov    %rcx,%r15
  70c383:	48 89 ca             	mov    %rcx,%rdx
  70c386:	e8 95 c8 01 00       	call   728c20 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  70c38b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70c390:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c394:	0f 85 5a 02 00 00    	jne    70c5f4 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x2d4>
  70c39a:	80 bb 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rbx)
  70c3a1:	48 89 ef             	mov    %rbp,%rdi
  70c3a4:	0f 85 a0 02 00 00    	jne    70c64a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c3aa:	80 bb 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rbx)
  70c3b1:	0f 85 93 02 00 00    	jne    70c64a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c3b7:	80 bb 20 07 00 00 00 	cmpb   $0x0,0x720(%rbx)
  70c3be:	0f 84 86 02 00 00    	je     70c64a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c3c4:	48 83 bb 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rbx)
  70c3cb:	ff 
  70c3cc:	0f 85 78 02 00 00    	jne    70c64a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c3d2:	48 8b 83 60 06 00 00 	mov    0x660(%rbx),%rax
  70c3d9:	48 3b 83 68 06 00 00 	cmp    0x668(%rbx),%rax
  70c3e0:	0f 85 64 02 00 00    	jne    70c64a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c3e6:	48 8b 83 78 06 00 00 	mov    0x678(%rbx),%rax
  70c3ed:	48 3b 83 70 06 00 00 	cmp    0x670(%rbx),%rax
  70c3f4:	0f 85 50 02 00 00    	jne    70c64a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c3fa:	f3 0f 10 83 14 07 00 	movss  0x714(%rbx),%xmm0
  70c401:	00 
  70c402:	0f 2e 83 18 07 00 00 	ucomiss 0x718(%rbx),%xmm0
  70c409:	0f 85 3b 02 00 00    	jne    70c64a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c40f:	0f 8a 35 02 00 00    	jp     70c64a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70c415:	4c 89 e0             	mov    %r12,%rax
  70c418:	48 83 c0 08          	add    $0x8,%rax
  70c41c:	4c 8b ab 78 05 00 00 	mov    0x578(%rbx),%r13
  70c423:	48 8b 8b 80 05 00 00 	mov    0x580(%rbx),%rcx
  70c42a:	48 c1 e1 04          	shl    $0x4,%rcx
  70c42e:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  70c432:	45 31 e4             	xor    %r12d,%r12d
  70c435:	4c 89 ee             	mov    %r13,%rsi
  70c438:	4c 89 fa             	mov    %r15,%rdx
  70c43b:	4c 39 e1             	cmp    %r12,%rcx
  70c43e:	0f 84 22 02 00 00    	je     70c666 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x346>
  70c444:	49 83 c4 50          	add    $0x50,%r12
  70c448:	48 39 56 20          	cmp    %rdx,0x20(%rsi)
  70c44c:	48 8d 76 50          	lea    0x50(%rsi),%rsi
  70c450:	75 e9                	jne    70c43b <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x11b>
  70c452:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  70c457:	48 c7 44 24 08 11 00 	movq   $0x11,0x8(%rsp)
  70c45e:	00 00 
  70c460:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c465:	e8 86 ba fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c46a:	f3 43 0f 10 44 25 e0 	movss  -0x20(%r13,%r12,1),%xmm0
  70c471:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70c474:	7a 62                	jp     70c4d8 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1b8>
  70c476:	43 8b 44 25 f4       	mov    -0xc(%r13,%r12,1),%eax
  70c47b:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  70c47f:	43 0f 10 4c 25 e4    	movups -0x1c(%r13,%r12,1),%xmm1
  70c485:	0f 11 4c 24 0c       	movups %xmm1,0xc(%rsp)
  70c48a:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70c490:	f3 43 0f 10 44 25 b8 	movss  -0x48(%r13,%r12,1),%xmm0
  70c497:	f3 43 0f 10 4c 25 bc 	movss  -0x44(%r13,%r12,1),%xmm1
  70c49e:	48 8d 7c 24 64       	lea    0x64(%rsp),%rdi
  70c4a3:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
  70c4a8:	e8 53 dd fe ff       	call   6fa200 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click::{closure#1}>
  70c4ad:	83 7c 24 64 01       	cmpl   $0x1,0x64(%rsp)
  70c4b2:	75 24                	jne    70c4d8 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1b8>
  70c4b4:	f2 0f 10 44 24 68    	movsd  0x68(%rsp),%xmm0
  70c4ba:	0f 28 c8             	movaps %xmm0,%xmm1
  70c4bd:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70c4c1:	4b 8d 3c 2c          	lea    (%r12,%r13,1),%rdi
  70c4c5:	48 83 c7 c0          	add    $0xffffffffffffffc0,%rdi
  70c4c9:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  70c4ce:	ff 15 f4 d0 41 00    	call   *0x41d0f4(%rip)        # b295c8 <_DYNAMIC+0x540>
  70c4d4:	84 c0                	test   %al,%al
  70c4d6:	75 40                	jne    70c518 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1f8>
  70c4d8:	f3 43 0f 10 44 25 c8 	movss  -0x38(%r13,%r12,1),%xmm0
  70c4df:	0f 57 d2             	xorps  %xmm2,%xmm2
  70c4e2:	0f 2e c2             	ucomiss %xmm2,%xmm0
  70c4e5:	75 06                	jne    70c4ed <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1cd>
  70c4e7:	0f 8b 82 01 00 00    	jnp    70c66f <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70c4ed:	f3 43 0f 10 4c 25 cc 	movss  -0x34(%r13,%r12,1),%xmm1
  70c4f4:	0f 2e ca             	ucomiss %xmm2,%xmm1
  70c4f7:	75 06                	jne    70c4ff <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1df>
  70c4f9:	0f 8b 70 01 00 00    	jnp    70c66f <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70c4ff:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70c502:	0f 59 05 17 ea 94 ff 	mulps  -0x6b15e9(%rip),%xmm0        # 5af20 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1120>
  70c509:	f2 43 0f 10 4c 25 c0 	movsd  -0x40(%r13,%r12,1),%xmm1
  70c510:	0f 58 c8             	addps  %xmm0,%xmm1
  70c513:	0f 29 4c 24 40       	movaps %xmm1,0x40(%rsp)
  70c518:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70c51f:	00 00 
  70c521:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c526:	e8 c5 b9 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c52b:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70c530:	0f 28 c8             	movaps %xmm0,%xmm1
  70c533:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70c537:	48 89 df             	mov    %rbx,%rdi
  70c53a:	0f 29 8c 24 a0 00 00 	movaps %xmm1,0xa0(%rsp)
  70c541:	00 
  70c542:	e8 99 c9 01 00       	call   728ee0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::hit>
  70c547:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70c54e:	00 00 
  70c550:	a8 01                	test   $0x1,%al
  70c552:	0f 84 17 01 00 00    	je     70c66f <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70c558:	49 89 d5             	mov    %rdx,%r13
  70c55b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c560:	e8 8b b9 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c565:	4d 39 fd             	cmp    %r15,%r13
  70c568:	0f 85 01 01 00 00    	jne    70c66f <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70c56e:	4c 3b b3 b0 05 00 00 	cmp    0x5b0(%rbx),%r14
  70c575:	0f 85 01 01 00 00    	jne    70c67c <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x35c>
  70c57b:	4c 89 fa             	mov    %r15,%rdx
  70c57e:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c583:	48 89 de             	mov    %rbx,%rsi
  70c586:	e8 95 c6 01 00       	call   728c20 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  70c58b:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  70c590:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c595:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  70c599:	0f 85 e2 00 00 00    	jne    70c681 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x361>
  70c59f:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70c5a6:	48 39 f0             	cmp    %rsi,%rax
  70c5a9:	0f 83 88 01 00 00    	jae    70c737 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x417>
  70c5af:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70c5b6:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  70c5ba:	8b 44 c1 20          	mov    0x20(%rcx,%rax,8),%eax
  70c5be:	83 e0 07             	and    $0x7,%eax
  70c5c1:	83 f8 02             	cmp    $0x2,%eax
  70c5c4:	0f 85 df 00 00 00    	jne    70c6a9 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x389>
  70c5ca:	48 89 ef             	mov    %rbp,%rdi
  70c5cd:	48 89 de             	mov    %rbx,%rsi
  70c5d0:	4c 89 f2             	mov    %r14,%rdx
  70c5d3:	4c 89 f9             	mov    %r15,%rcx
  70c5d6:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70c5db:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70c5e2:	00 
  70c5e3:	e8 28 91 ff ff       	call   705710 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer>
  70c5e8:	e9 05 01 00 00       	jmp    70c6f2 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x3d2>
  70c5ed:	b8 11 00 00 00       	mov    $0x11,%eax
  70c5f2:	eb 2c                	jmp    70c620 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x300>
  70c5f4:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  70c5f9:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70c5fe:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70c603:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70c608:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  70c60f:	00 
  70c610:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70c615:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  70c61c:	00 
  70c61d:	48 89 ef             	mov    %rbp,%rdi
  70c620:	48 89 07             	mov    %rax,(%rdi)
  70c623:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70c627:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70c62c:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
  70c633:	00 
  70c634:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70c638:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  70c63c:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  70c643:	00 
  70c644:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70c648:	eb 07                	jmp    70c651 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70c64a:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70c651:	48 89 f8             	mov    %rdi,%rax
  70c654:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  70c65b:	5b                   	pop    %rbx
  70c65c:	41 5c                	pop    %r12
  70c65e:	41 5d                	pop    %r13
  70c660:	41 5e                	pop    %r14
  70c662:	41 5f                	pop    %r15
  70c664:	5d                   	pop    %rbp
  70c665:	c3                   	ret
  70c666:	48 c7 07 11 00 00 00 	movq   $0x11,(%rdi)
  70c66d:	eb e2                	jmp    70c651 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70c66f:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70c676:	00 
  70c677:	48 89 e8             	mov    %rbp,%rax
  70c67a:	eb d8                	jmp    70c654 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70c67c:	b9 11 00 00 00       	mov    $0x11,%ecx
  70c681:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70c686:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  70c68a:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70c68f:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70c694:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  70c698:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70c69c:	48 89 4d 00          	mov    %rcx,0x0(%rbp)
  70c6a0:	48 89 45 08          	mov    %rax,0x8(%rbp)
  70c6a4:	48 89 e8             	mov    %rbp,%rax
  70c6a7:	eb ab                	jmp    70c654 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70c6a9:	4c 8b ab e8 05 00 00 	mov    0x5e8(%rbx),%r13
  70c6b0:	4c 8b a3 f0 05 00 00 	mov    0x5f0(%rbx),%r12
  70c6b7:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c6bc:	48 89 de             	mov    %rbx,%rsi
  70c6bf:	4c 89 f2             	mov    %r14,%rdx
  70c6c2:	4c 89 f9             	mov    %r15,%rcx
  70c6c5:	e8 16 4b ff ff       	call   7011e0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::focus>
  70c6ca:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70c6cf:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c6d3:	75 25                	jne    70c6fa <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x3da>
  70c6d5:	4c 89 24 24          	mov    %r12,(%rsp)
  70c6d9:	48 89 ef             	mov    %rbp,%rdi
  70c6dc:	48 89 de             	mov    %rbx,%rsi
  70c6df:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  70c6e4:	4c 89 f1             	mov    %r14,%rcx
  70c6e7:	4d 89 f8             	mov    %r15,%r8
  70c6ea:	4d 89 e9             	mov    %r13,%r9
  70c6ed:	e8 ce 13 ff ff       	call   6fdac0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused>
  70c6f2:	48 89 e8             	mov    %rbp,%rax
  70c6f5:	e9 5a ff ff ff       	jmp    70c654 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70c6fa:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  70c6ff:	0f b6 54 24 38       	movzbl 0x38(%rsp),%edx
  70c704:	8b 74 24 3c          	mov    0x3c(%rsp),%esi
  70c708:	89 75 34             	mov    %esi,0x34(%rbp)
  70c70b:	8b 74 24 39          	mov    0x39(%rsp),%esi
  70c70f:	89 75 31             	mov    %esi,0x31(%rbp)
  70c712:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  70c717:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  70c71c:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70c720:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70c724:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70c728:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  70c72c:	88 55 30             	mov    %dl,0x30(%rbp)
  70c72f:	48 89 e8             	mov    %rbp,%rax
  70c732:	e9 1d ff ff ff       	jmp    70c654 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70c737:	48 8d 15 72 ea 3e 00 	lea    0x3eea72(%rip),%rdx        # afb1b0 <__frame_dummy_init_array_entry+0x948>
  70c73e:	48 89 c7             	mov    %rax,%rdi
  70c741:	ff 15 99 cc 41 00    	call   *0x41cc99(%rip)        # b293e0 <_DYNAMIC+0x358>
