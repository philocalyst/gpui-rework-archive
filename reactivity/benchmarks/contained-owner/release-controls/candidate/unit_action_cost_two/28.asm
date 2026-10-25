
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000070b5d0 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click>:
  70b5d0:	55                   	push   %rbp
  70b5d1:	41 57                	push   %r15
  70b5d3:	41 56                	push   %r14
  70b5d5:	41 55                	push   %r13
  70b5d7:	41 54                	push   %r12
  70b5d9:	53                   	push   %rbx
  70b5da:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
  70b5e1:	48 8b 1e             	mov    (%rsi),%rbx
  70b5e4:	48 85 db             	test   %rbx,%rbx
  70b5e7:	74 15                	je     70b5fe <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x2e>
  70b5e9:	80 bb 22 08 00 00 01 	cmpb   $0x1,0x822(%rbx)
  70b5f0:	75 20                	jne    70b612 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x42>
  70b5f2:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70b5f9:	e9 03 03 00 00       	jmp    70b901 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70b5fe:	48 c7 07 0d 00 00 00 	movq   $0xd,(%rdi)
  70b605:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  70b60c:	00 
  70b60d:	e9 ef 02 00 00       	jmp    70b901 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70b612:	48 3b 93 b0 05 00 00 	cmp    0x5b0(%rbx),%rdx
  70b619:	0f 85 7e 02 00 00    	jne    70b89d <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x2cd>
  70b61f:	49 89 f4             	mov    %rsi,%r12
  70b622:	49 89 d6             	mov    %rdx,%r14
  70b625:	48 89 fd             	mov    %rdi,%rbp
  70b628:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b62d:	48 89 de             	mov    %rbx,%rsi
  70b630:	49 89 cf             	mov    %rcx,%r15
  70b633:	48 89 ca             	mov    %rcx,%rdx
  70b636:	e8 45 ee 00 00       	call   71a480 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  70b63b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70b640:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70b644:	0f 85 5a 02 00 00    	jne    70b8a4 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x2d4>
  70b64a:	80 bb 1e 08 00 00 01 	cmpb   $0x1,0x81e(%rbx)
  70b651:	48 89 ef             	mov    %rbp,%rdi
  70b654:	0f 85 a0 02 00 00    	jne    70b8fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b65a:	80 bb 1f 08 00 00 00 	cmpb   $0x0,0x81f(%rbx)
  70b661:	0f 85 93 02 00 00    	jne    70b8fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b667:	80 bb 20 08 00 00 00 	cmpb   $0x0,0x820(%rbx)
  70b66e:	0f 84 86 02 00 00    	je     70b8fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b674:	48 83 bb 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rbx)
  70b67b:	ff 
  70b67c:	0f 85 78 02 00 00    	jne    70b8fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b682:	48 8b 83 60 06 00 00 	mov    0x660(%rbx),%rax
  70b689:	48 3b 83 68 06 00 00 	cmp    0x668(%rbx),%rax
  70b690:	0f 85 64 02 00 00    	jne    70b8fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b696:	48 8b 83 78 06 00 00 	mov    0x678(%rbx),%rax
  70b69d:	48 3b 83 70 06 00 00 	cmp    0x670(%rbx),%rax
  70b6a4:	0f 85 50 02 00 00    	jne    70b8fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b6aa:	f3 0f 10 83 14 08 00 	movss  0x814(%rbx),%xmm0
  70b6b1:	00 
  70b6b2:	0f 2e 83 18 08 00 00 	ucomiss 0x818(%rbx),%xmm0
  70b6b9:	0f 85 3b 02 00 00    	jne    70b8fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b6bf:	0f 8a 35 02 00 00    	jp     70b8fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b6c5:	4c 89 e0             	mov    %r12,%rax
  70b6c8:	48 83 c0 08          	add    $0x8,%rax
  70b6cc:	4c 8b ab 78 05 00 00 	mov    0x578(%rbx),%r13
  70b6d3:	48 8b 8b 80 05 00 00 	mov    0x580(%rbx),%rcx
  70b6da:	48 c1 e1 04          	shl    $0x4,%rcx
  70b6de:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  70b6e2:	45 31 e4             	xor    %r12d,%r12d
  70b6e5:	4c 89 ee             	mov    %r13,%rsi
  70b6e8:	4c 89 fa             	mov    %r15,%rdx
  70b6eb:	4c 39 e1             	cmp    %r12,%rcx
  70b6ee:	0f 84 22 02 00 00    	je     70b916 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x346>
  70b6f4:	49 83 c4 50          	add    $0x50,%r12
  70b6f8:	48 39 56 20          	cmp    %rdx,0x20(%rsi)
  70b6fc:	48 8d 76 50          	lea    0x50(%rsi),%rsi
  70b700:	75 e9                	jne    70b6eb <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x11b>
  70b702:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  70b707:	48 c7 44 24 08 11 00 	movq   $0x11,0x8(%rsp)
  70b70e:	00 00 
  70b710:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b715:	e8 d6 c8 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70b71a:	f3 43 0f 10 44 25 e0 	movss  -0x20(%r13,%r12,1),%xmm0
  70b721:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70b724:	7a 62                	jp     70b788 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1b8>
  70b726:	43 8b 44 25 f4       	mov    -0xc(%r13,%r12,1),%eax
  70b72b:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  70b72f:	43 0f 10 4c 25 e4    	movups -0x1c(%r13,%r12,1),%xmm1
  70b735:	0f 11 4c 24 0c       	movups %xmm1,0xc(%rsp)
  70b73a:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70b740:	f3 43 0f 10 44 25 b8 	movss  -0x48(%r13,%r12,1),%xmm0
  70b747:	f3 43 0f 10 4c 25 bc 	movss  -0x44(%r13,%r12,1),%xmm1
  70b74e:	48 8d 7c 24 64       	lea    0x64(%rsp),%rdi
  70b753:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
  70b758:	e8 a3 eb fe ff       	call   6fa300 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click::{closure#1}>
  70b75d:	83 7c 24 64 01       	cmpl   $0x1,0x64(%rsp)
  70b762:	75 24                	jne    70b788 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1b8>
  70b764:	f2 0f 10 44 24 68    	movsd  0x68(%rsp),%xmm0
  70b76a:	0f 28 c8             	movaps %xmm0,%xmm1
  70b76d:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70b771:	4b 8d 3c 2c          	lea    (%r12,%r13,1),%rdi
  70b775:	48 83 c7 c0          	add    $0xffffffffffffffc0,%rdi
  70b779:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  70b77e:	ff 15 2c df 41 00    	call   *0x41df2c(%rip)        # b296b0 <_DYNAMIC+0x540>
  70b784:	84 c0                	test   %al,%al
  70b786:	75 40                	jne    70b7c8 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1f8>
  70b788:	f3 43 0f 10 44 25 c8 	movss  -0x38(%r13,%r12,1),%xmm0
  70b78f:	0f 57 d2             	xorps  %xmm2,%xmm2
  70b792:	0f 2e c2             	ucomiss %xmm2,%xmm0
  70b795:	75 06                	jne    70b79d <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1cd>
  70b797:	0f 8b 82 01 00 00    	jnp    70b91f <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70b79d:	f3 43 0f 10 4c 25 cc 	movss  -0x34(%r13,%r12,1),%xmm1
  70b7a4:	0f 2e ca             	ucomiss %xmm2,%xmm1
  70b7a7:	75 06                	jne    70b7af <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1df>
  70b7a9:	0f 8b 70 01 00 00    	jnp    70b91f <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70b7af:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70b7b2:	0f 59 05 d7 f7 94 ff 	mulps  -0x6b0829(%rip),%xmm0        # 5af90 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1120>
  70b7b9:	f2 43 0f 10 4c 25 c0 	movsd  -0x40(%r13,%r12,1),%xmm1
  70b7c0:	0f 58 c8             	addps  %xmm0,%xmm1
  70b7c3:	0f 29 4c 24 40       	movaps %xmm1,0x40(%rsp)
  70b7c8:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70b7cf:	00 00 
  70b7d1:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b7d6:	e8 15 c8 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70b7db:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70b7e0:	0f 28 c8             	movaps %xmm0,%xmm1
  70b7e3:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70b7e7:	48 89 df             	mov    %rbx,%rdi
  70b7ea:	0f 29 8c 24 a0 00 00 	movaps %xmm1,0xa0(%rsp)
  70b7f1:	00 
  70b7f2:	e8 49 ef 00 00       	call   71a740 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::hit>
  70b7f7:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70b7fe:	00 00 
  70b800:	a8 01                	test   $0x1,%al
  70b802:	0f 84 17 01 00 00    	je     70b91f <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70b808:	49 89 d5             	mov    %rdx,%r13
  70b80b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b810:	e8 db c7 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70b815:	4d 39 fd             	cmp    %r15,%r13
  70b818:	0f 85 01 01 00 00    	jne    70b91f <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70b81e:	4c 3b b3 b0 05 00 00 	cmp    0x5b0(%rbx),%r14
  70b825:	0f 85 01 01 00 00    	jne    70b92c <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x35c>
  70b82b:	4c 89 fa             	mov    %r15,%rdx
  70b82e:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b833:	48 89 de             	mov    %rbx,%rsi
  70b836:	e8 45 ec 00 00       	call   71a480 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  70b83b:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  70b840:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70b845:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  70b849:	0f 85 e2 00 00 00    	jne    70b931 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x361>
  70b84f:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70b856:	48 39 f0             	cmp    %rsi,%rax
  70b859:	0f 83 88 01 00 00    	jae    70b9e7 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x417>
  70b85f:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70b866:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  70b86a:	8b 44 c1 20          	mov    0x20(%rcx,%rax,8),%eax
  70b86e:	83 e0 07             	and    $0x7,%eax
  70b871:	83 f8 02             	cmp    $0x2,%eax
  70b874:	0f 85 df 00 00 00    	jne    70b959 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x389>
  70b87a:	48 89 ef             	mov    %rbp,%rdi
  70b87d:	48 89 de             	mov    %rbx,%rsi
  70b880:	4c 89 f2             	mov    %r14,%rdx
  70b883:	4c 89 f9             	mov    %r15,%rcx
  70b886:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70b88b:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70b892:	00 
  70b893:	e8 48 95 ff ff       	call   704de0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer>
  70b898:	e9 05 01 00 00       	jmp    70b9a2 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x3d2>
  70b89d:	b8 11 00 00 00       	mov    $0x11,%eax
  70b8a2:	eb 2c                	jmp    70b8d0 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x300>
  70b8a4:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  70b8a9:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70b8ae:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70b8b3:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70b8b8:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  70b8bf:	00 
  70b8c0:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70b8c5:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  70b8cc:	00 
  70b8cd:	48 89 ef             	mov    %rbp,%rdi
  70b8d0:	48 89 07             	mov    %rax,(%rdi)
  70b8d3:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70b8d7:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70b8dc:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
  70b8e3:	00 
  70b8e4:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70b8e8:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  70b8ec:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  70b8f3:	00 
  70b8f4:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70b8f8:	eb 07                	jmp    70b901 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70b8fa:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70b901:	48 89 f8             	mov    %rdi,%rax
  70b904:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  70b90b:	5b                   	pop    %rbx
  70b90c:	41 5c                	pop    %r12
  70b90e:	41 5d                	pop    %r13
  70b910:	41 5e                	pop    %r14
  70b912:	41 5f                	pop    %r15
  70b914:	5d                   	pop    %rbp
  70b915:	c3                   	ret
  70b916:	48 c7 07 11 00 00 00 	movq   $0x11,(%rdi)
  70b91d:	eb e2                	jmp    70b901 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70b91f:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70b926:	00 
  70b927:	48 89 e8             	mov    %rbp,%rax
  70b92a:	eb d8                	jmp    70b904 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70b92c:	b9 11 00 00 00       	mov    $0x11,%ecx
  70b931:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70b936:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  70b93a:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70b93f:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70b944:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  70b948:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70b94c:	48 89 4d 00          	mov    %rcx,0x0(%rbp)
  70b950:	48 89 45 08          	mov    %rax,0x8(%rbp)
  70b954:	48 89 e8             	mov    %rbp,%rax
  70b957:	eb ab                	jmp    70b904 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70b959:	4c 8b ab e8 05 00 00 	mov    0x5e8(%rbx),%r13
  70b960:	4c 8b a3 f0 05 00 00 	mov    0x5f0(%rbx),%r12
  70b967:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b96c:	48 89 de             	mov    %rbx,%rsi
  70b96f:	4c 89 f2             	mov    %r14,%rdx
  70b972:	4c 89 f9             	mov    %r15,%rcx
  70b975:	e8 46 57 ff ff       	call   7010c0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::focus>
  70b97a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70b97f:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70b983:	75 25                	jne    70b9aa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x3da>
  70b985:	4c 89 24 24          	mov    %r12,(%rsp)
  70b989:	48 89 ef             	mov    %rbp,%rdi
  70b98c:	48 89 de             	mov    %rbx,%rsi
  70b98f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  70b994:	4c 89 f1             	mov    %r14,%rcx
  70b997:	4d 89 f8             	mov    %r15,%r8
  70b99a:	4d 89 e9             	mov    %r13,%r9
  70b99d:	e8 1e f2 fe ff       	call   6fabc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused>
  70b9a2:	48 89 e8             	mov    %rbp,%rax
  70b9a5:	e9 5a ff ff ff       	jmp    70b904 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70b9aa:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  70b9af:	0f b6 54 24 38       	movzbl 0x38(%rsp),%edx
  70b9b4:	8b 74 24 3c          	mov    0x3c(%rsp),%esi
  70b9b8:	89 75 34             	mov    %esi,0x34(%rbp)
  70b9bb:	8b 74 24 39          	mov    0x39(%rsp),%esi
  70b9bf:	89 75 31             	mov    %esi,0x31(%rbp)
  70b9c2:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  70b9c7:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  70b9cc:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70b9d0:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70b9d4:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70b9d8:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  70b9dc:	88 55 30             	mov    %dl,0x30(%rbp)
  70b9df:	48 89 e8             	mov    %rbp,%rax
  70b9e2:	e9 1d ff ff ff       	jmp    70b904 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70b9e7:	48 8d 15 62 f8 3e 00 	lea    0x3ef862(%rip),%rdx        # afb250 <__frame_dummy_init_array_entry+0x948>
  70b9ee:	48 89 c7             	mov    %rax,%rdi
  70b9f1:	ff 15 d1 da 41 00    	call   *0x41dad1(%rip)        # b294c8 <_DYNAMIC+0x358>
