
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000070b560 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click>:
  70b560:	55                   	push   %rbp
  70b561:	41 57                	push   %r15
  70b563:	41 56                	push   %r14
  70b565:	41 55                	push   %r13
  70b567:	41 54                	push   %r12
  70b569:	53                   	push   %rbx
  70b56a:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
  70b571:	48 8b 1e             	mov    (%rsi),%rbx
  70b574:	48 85 db             	test   %rbx,%rbx
  70b577:	74 15                	je     70b58e <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x2e>
  70b579:	80 bb 22 08 00 00 01 	cmpb   $0x1,0x822(%rbx)
  70b580:	75 20                	jne    70b5a2 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x42>
  70b582:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70b589:	e9 03 03 00 00       	jmp    70b891 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70b58e:	48 c7 07 0d 00 00 00 	movq   $0xd,(%rdi)
  70b595:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  70b59c:	00 
  70b59d:	e9 ef 02 00 00       	jmp    70b891 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70b5a2:	48 3b 93 b0 05 00 00 	cmp    0x5b0(%rbx),%rdx
  70b5a9:	0f 85 7e 02 00 00    	jne    70b82d <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x2cd>
  70b5af:	49 89 f4             	mov    %rsi,%r12
  70b5b2:	49 89 d6             	mov    %rdx,%r14
  70b5b5:	48 89 fd             	mov    %rdi,%rbp
  70b5b8:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b5bd:	48 89 de             	mov    %rbx,%rsi
  70b5c0:	49 89 cf             	mov    %rcx,%r15
  70b5c3:	48 89 ca             	mov    %rcx,%rdx
  70b5c6:	e8 45 ee 00 00       	call   71a410 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  70b5cb:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70b5d0:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70b5d4:	0f 85 5a 02 00 00    	jne    70b834 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x2d4>
  70b5da:	80 bb 1e 08 00 00 01 	cmpb   $0x1,0x81e(%rbx)
  70b5e1:	48 89 ef             	mov    %rbp,%rdi
  70b5e4:	0f 85 a0 02 00 00    	jne    70b88a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b5ea:	80 bb 1f 08 00 00 00 	cmpb   $0x0,0x81f(%rbx)
  70b5f1:	0f 85 93 02 00 00    	jne    70b88a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b5f7:	80 bb 20 08 00 00 00 	cmpb   $0x0,0x820(%rbx)
  70b5fe:	0f 84 86 02 00 00    	je     70b88a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b604:	48 83 bb 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rbx)
  70b60b:	ff 
  70b60c:	0f 85 78 02 00 00    	jne    70b88a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b612:	48 8b 83 60 06 00 00 	mov    0x660(%rbx),%rax
  70b619:	48 3b 83 68 06 00 00 	cmp    0x668(%rbx),%rax
  70b620:	0f 85 64 02 00 00    	jne    70b88a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b626:	48 8b 83 78 06 00 00 	mov    0x678(%rbx),%rax
  70b62d:	48 3b 83 70 06 00 00 	cmp    0x670(%rbx),%rax
  70b634:	0f 85 50 02 00 00    	jne    70b88a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b63a:	f3 0f 10 83 14 08 00 	movss  0x814(%rbx),%xmm0
  70b641:	00 
  70b642:	0f 2e 83 18 08 00 00 	ucomiss 0x818(%rbx),%xmm0
  70b649:	0f 85 3b 02 00 00    	jne    70b88a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b64f:	0f 8a 35 02 00 00    	jp     70b88a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b655:	4c 89 e0             	mov    %r12,%rax
  70b658:	48 83 c0 08          	add    $0x8,%rax
  70b65c:	4c 8b ab 78 05 00 00 	mov    0x578(%rbx),%r13
  70b663:	48 8b 8b 80 05 00 00 	mov    0x580(%rbx),%rcx
  70b66a:	48 c1 e1 04          	shl    $0x4,%rcx
  70b66e:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  70b672:	45 31 e4             	xor    %r12d,%r12d
  70b675:	4c 89 ee             	mov    %r13,%rsi
  70b678:	4c 89 fa             	mov    %r15,%rdx
  70b67b:	4c 39 e1             	cmp    %r12,%rcx
  70b67e:	0f 84 22 02 00 00    	je     70b8a6 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x346>
  70b684:	49 83 c4 50          	add    $0x50,%r12
  70b688:	48 39 56 20          	cmp    %rdx,0x20(%rsi)
  70b68c:	48 8d 76 50          	lea    0x50(%rsi),%rsi
  70b690:	75 e9                	jne    70b67b <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x11b>
  70b692:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  70b697:	48 c7 44 24 08 11 00 	movq   $0x11,0x8(%rsp)
  70b69e:	00 00 
  70b6a0:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b6a5:	e8 36 c9 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70b6aa:	f3 43 0f 10 44 25 e0 	movss  -0x20(%r13,%r12,1),%xmm0
  70b6b1:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70b6b4:	7a 62                	jp     70b718 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1b8>
  70b6b6:	43 8b 44 25 f4       	mov    -0xc(%r13,%r12,1),%eax
  70b6bb:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  70b6bf:	43 0f 10 4c 25 e4    	movups -0x1c(%r13,%r12,1),%xmm1
  70b6c5:	0f 11 4c 24 0c       	movups %xmm1,0xc(%rsp)
  70b6ca:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70b6d0:	f3 43 0f 10 44 25 b8 	movss  -0x48(%r13,%r12,1),%xmm0
  70b6d7:	f3 43 0f 10 4c 25 bc 	movss  -0x44(%r13,%r12,1),%xmm1
  70b6de:	48 8d 7c 24 64       	lea    0x64(%rsp),%rdi
  70b6e3:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
  70b6e8:	e8 03 ec fe ff       	call   6fa2f0 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click::{closure#1}>
  70b6ed:	83 7c 24 64 01       	cmpl   $0x1,0x64(%rsp)
  70b6f2:	75 24                	jne    70b718 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1b8>
  70b6f4:	f2 0f 10 44 24 68    	movsd  0x68(%rsp),%xmm0
  70b6fa:	0f 28 c8             	movaps %xmm0,%xmm1
  70b6fd:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70b701:	4b 8d 3c 2c          	lea    (%r12,%r13,1),%rdi
  70b705:	48 83 c7 c0          	add    $0xffffffffffffffc0,%rdi
  70b709:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  70b70e:	ff 15 2c df 41 00    	call   *0x41df2c(%rip)        # b29640 <_DYNAMIC+0x540>
  70b714:	84 c0                	test   %al,%al
  70b716:	75 40                	jne    70b758 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1f8>
  70b718:	f3 43 0f 10 44 25 c8 	movss  -0x38(%r13,%r12,1),%xmm0
  70b71f:	0f 57 d2             	xorps  %xmm2,%xmm2
  70b722:	0f 2e c2             	ucomiss %xmm2,%xmm0
  70b725:	75 06                	jne    70b72d <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1cd>
  70b727:	0f 8b 82 01 00 00    	jnp    70b8af <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70b72d:	f3 43 0f 10 4c 25 cc 	movss  -0x34(%r13,%r12,1),%xmm1
  70b734:	0f 2e ca             	ucomiss %xmm2,%xmm1
  70b737:	75 06                	jne    70b73f <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1df>
  70b739:	0f 8b 70 01 00 00    	jnp    70b8af <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70b73f:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70b742:	0f 59 05 37 f8 94 ff 	mulps  -0x6b07c9(%rip),%xmm0        # 5af80 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1120>
  70b749:	f2 43 0f 10 4c 25 c0 	movsd  -0x40(%r13,%r12,1),%xmm1
  70b750:	0f 58 c8             	addps  %xmm0,%xmm1
  70b753:	0f 29 4c 24 40       	movaps %xmm1,0x40(%rsp)
  70b758:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70b75f:	00 00 
  70b761:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b766:	e8 75 c8 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70b76b:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70b770:	0f 28 c8             	movaps %xmm0,%xmm1
  70b773:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70b777:	48 89 df             	mov    %rbx,%rdi
  70b77a:	0f 29 8c 24 a0 00 00 	movaps %xmm1,0xa0(%rsp)
  70b781:	00 
  70b782:	e8 49 ef 00 00       	call   71a6d0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::hit>
  70b787:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70b78e:	00 00 
  70b790:	a8 01                	test   $0x1,%al
  70b792:	0f 84 17 01 00 00    	je     70b8af <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70b798:	49 89 d5             	mov    %rdx,%r13
  70b79b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b7a0:	e8 3b c8 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70b7a5:	4d 39 fd             	cmp    %r15,%r13
  70b7a8:	0f 85 01 01 00 00    	jne    70b8af <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70b7ae:	4c 3b b3 b0 05 00 00 	cmp    0x5b0(%rbx),%r14
  70b7b5:	0f 85 01 01 00 00    	jne    70b8bc <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x35c>
  70b7bb:	4c 89 fa             	mov    %r15,%rdx
  70b7be:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b7c3:	48 89 de             	mov    %rbx,%rsi
  70b7c6:	e8 45 ec 00 00       	call   71a410 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  70b7cb:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  70b7d0:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70b7d5:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  70b7d9:	0f 85 e2 00 00 00    	jne    70b8c1 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x361>
  70b7df:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70b7e6:	48 39 f0             	cmp    %rsi,%rax
  70b7e9:	0f 83 88 01 00 00    	jae    70b977 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x417>
  70b7ef:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70b7f6:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  70b7fa:	8b 44 c1 20          	mov    0x20(%rcx,%rax,8),%eax
  70b7fe:	83 e0 07             	and    $0x7,%eax
  70b801:	83 f8 02             	cmp    $0x2,%eax
  70b804:	0f 85 df 00 00 00    	jne    70b8e9 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x389>
  70b80a:	48 89 ef             	mov    %rbp,%rdi
  70b80d:	48 89 de             	mov    %rbx,%rsi
  70b810:	4c 89 f2             	mov    %r14,%rdx
  70b813:	4c 89 f9             	mov    %r15,%rcx
  70b816:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70b81b:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70b822:	00 
  70b823:	e8 48 95 ff ff       	call   704d70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer>
  70b828:	e9 05 01 00 00       	jmp    70b932 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x3d2>
  70b82d:	b8 11 00 00 00       	mov    $0x11,%eax
  70b832:	eb 2c                	jmp    70b860 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x300>
  70b834:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  70b839:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70b83e:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70b843:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70b848:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  70b84f:	00 
  70b850:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70b855:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  70b85c:	00 
  70b85d:	48 89 ef             	mov    %rbp,%rdi
  70b860:	48 89 07             	mov    %rax,(%rdi)
  70b863:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70b867:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70b86c:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
  70b873:	00 
  70b874:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70b878:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  70b87c:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  70b883:	00 
  70b884:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70b888:	eb 07                	jmp    70b891 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70b88a:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70b891:	48 89 f8             	mov    %rdi,%rax
  70b894:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  70b89b:	5b                   	pop    %rbx
  70b89c:	41 5c                	pop    %r12
  70b89e:	41 5d                	pop    %r13
  70b8a0:	41 5e                	pop    %r14
  70b8a2:	41 5f                	pop    %r15
  70b8a4:	5d                   	pop    %rbp
  70b8a5:	c3                   	ret
  70b8a6:	48 c7 07 11 00 00 00 	movq   $0x11,(%rdi)
  70b8ad:	eb e2                	jmp    70b891 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70b8af:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70b8b6:	00 
  70b8b7:	48 89 e8             	mov    %rbp,%rax
  70b8ba:	eb d8                	jmp    70b894 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70b8bc:	b9 11 00 00 00       	mov    $0x11,%ecx
  70b8c1:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70b8c6:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  70b8ca:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70b8cf:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70b8d4:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  70b8d8:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70b8dc:	48 89 4d 00          	mov    %rcx,0x0(%rbp)
  70b8e0:	48 89 45 08          	mov    %rax,0x8(%rbp)
  70b8e4:	48 89 e8             	mov    %rbp,%rax
  70b8e7:	eb ab                	jmp    70b894 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70b8e9:	4c 8b ab e8 05 00 00 	mov    0x5e8(%rbx),%r13
  70b8f0:	4c 8b a3 f0 05 00 00 	mov    0x5f0(%rbx),%r12
  70b8f7:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b8fc:	48 89 de             	mov    %rbx,%rsi
  70b8ff:	4c 89 f2             	mov    %r14,%rdx
  70b902:	4c 89 f9             	mov    %r15,%rcx
  70b905:	e8 46 57 ff ff       	call   701050 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::focus>
  70b90a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70b90f:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70b913:	75 25                	jne    70b93a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x3da>
  70b915:	4c 89 24 24          	mov    %r12,(%rsp)
  70b919:	48 89 ef             	mov    %rbp,%rdi
  70b91c:	48 89 de             	mov    %rbx,%rsi
  70b91f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  70b924:	4c 89 f1             	mov    %r14,%rcx
  70b927:	4d 89 f8             	mov    %r15,%r8
  70b92a:	4d 89 e9             	mov    %r13,%r9
  70b92d:	e8 7e f2 fe ff       	call   6fabb0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused>
  70b932:	48 89 e8             	mov    %rbp,%rax
  70b935:	e9 5a ff ff ff       	jmp    70b894 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70b93a:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  70b93f:	0f b6 54 24 38       	movzbl 0x38(%rsp),%edx
  70b944:	8b 74 24 3c          	mov    0x3c(%rsp),%esi
  70b948:	89 75 34             	mov    %esi,0x34(%rbp)
  70b94b:	8b 74 24 39          	mov    0x39(%rsp),%esi
  70b94f:	89 75 31             	mov    %esi,0x31(%rbp)
  70b952:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  70b957:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  70b95c:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70b960:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70b964:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70b968:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  70b96c:	88 55 30             	mov    %dl,0x30(%rbp)
  70b96f:	48 89 e8             	mov    %rbp,%rax
  70b972:	e9 1d ff ff ff       	jmp    70b894 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70b977:	48 8d 15 62 f8 3e 00 	lea    0x3ef862(%rip),%rdx        # afb1e0 <__frame_dummy_init_array_entry+0x948>
  70b97e:	48 89 c7             	mov    %rax,%rdi
  70b981:	ff 15 d1 da 41 00    	call   *0x41dad1(%rip)        # b29458 <_DYNAMIC+0x358>
