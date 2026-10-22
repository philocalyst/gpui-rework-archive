
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000070b4d0 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click>:
  70b4d0:	55                   	push   %rbp
  70b4d1:	41 57                	push   %r15
  70b4d3:	41 56                	push   %r14
  70b4d5:	41 55                	push   %r13
  70b4d7:	41 54                	push   %r12
  70b4d9:	53                   	push   %rbx
  70b4da:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
  70b4e1:	48 8b 1e             	mov    (%rsi),%rbx
  70b4e4:	48 85 db             	test   %rbx,%rbx
  70b4e7:	74 15                	je     70b4fe <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x2e>
  70b4e9:	80 bb 22 08 00 00 01 	cmpb   $0x1,0x822(%rbx)
  70b4f0:	75 20                	jne    70b512 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x42>
  70b4f2:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70b4f9:	e9 03 03 00 00       	jmp    70b801 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70b4fe:	48 c7 07 0d 00 00 00 	movq   $0xd,(%rdi)
  70b505:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  70b50c:	00 
  70b50d:	e9 ef 02 00 00       	jmp    70b801 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70b512:	48 3b 93 b0 05 00 00 	cmp    0x5b0(%rbx),%rdx
  70b519:	0f 85 7e 02 00 00    	jne    70b79d <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x2cd>
  70b51f:	49 89 f4             	mov    %rsi,%r12
  70b522:	49 89 d6             	mov    %rdx,%r14
  70b525:	48 89 fd             	mov    %rdi,%rbp
  70b528:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b52d:	48 89 de             	mov    %rbx,%rsi
  70b530:	49 89 cf             	mov    %rcx,%r15
  70b533:	48 89 ca             	mov    %rcx,%rdx
  70b536:	e8 45 ee 00 00       	call   71a380 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  70b53b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70b540:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70b544:	0f 85 5a 02 00 00    	jne    70b7a4 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x2d4>
  70b54a:	80 bb 1e 08 00 00 01 	cmpb   $0x1,0x81e(%rbx)
  70b551:	48 89 ef             	mov    %rbp,%rdi
  70b554:	0f 85 a0 02 00 00    	jne    70b7fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b55a:	80 bb 1f 08 00 00 00 	cmpb   $0x0,0x81f(%rbx)
  70b561:	0f 85 93 02 00 00    	jne    70b7fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b567:	80 bb 20 08 00 00 00 	cmpb   $0x0,0x820(%rbx)
  70b56e:	0f 84 86 02 00 00    	je     70b7fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b574:	48 83 bb 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rbx)
  70b57b:	ff 
  70b57c:	0f 85 78 02 00 00    	jne    70b7fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b582:	48 8b 83 60 06 00 00 	mov    0x660(%rbx),%rax
  70b589:	48 3b 83 68 06 00 00 	cmp    0x668(%rbx),%rax
  70b590:	0f 85 64 02 00 00    	jne    70b7fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b596:	48 8b 83 78 06 00 00 	mov    0x678(%rbx),%rax
  70b59d:	48 3b 83 70 06 00 00 	cmp    0x670(%rbx),%rax
  70b5a4:	0f 85 50 02 00 00    	jne    70b7fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b5aa:	f3 0f 10 83 14 08 00 	movss  0x814(%rbx),%xmm0
  70b5b1:	00 
  70b5b2:	0f 2e 83 18 08 00 00 	ucomiss 0x818(%rbx),%xmm0
  70b5b9:	0f 85 3b 02 00 00    	jne    70b7fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b5bf:	0f 8a 35 02 00 00    	jp     70b7fa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70b5c5:	4c 89 e0             	mov    %r12,%rax
  70b5c8:	48 83 c0 08          	add    $0x8,%rax
  70b5cc:	4c 8b ab 78 05 00 00 	mov    0x578(%rbx),%r13
  70b5d3:	48 8b 8b 80 05 00 00 	mov    0x580(%rbx),%rcx
  70b5da:	48 c1 e1 04          	shl    $0x4,%rcx
  70b5de:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  70b5e2:	45 31 e4             	xor    %r12d,%r12d
  70b5e5:	4c 89 ee             	mov    %r13,%rsi
  70b5e8:	4c 89 fa             	mov    %r15,%rdx
  70b5eb:	4c 39 e1             	cmp    %r12,%rcx
  70b5ee:	0f 84 22 02 00 00    	je     70b816 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x346>
  70b5f4:	49 83 c4 50          	add    $0x50,%r12
  70b5f8:	48 39 56 20          	cmp    %rdx,0x20(%rsi)
  70b5fc:	48 8d 76 50          	lea    0x50(%rsi),%rsi
  70b600:	75 e9                	jne    70b5eb <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x11b>
  70b602:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  70b607:	48 c7 44 24 08 11 00 	movq   $0x11,0x8(%rsp)
  70b60e:	00 00 
  70b610:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b615:	e8 d6 c8 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70b61a:	f3 43 0f 10 44 25 e0 	movss  -0x20(%r13,%r12,1),%xmm0
  70b621:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70b624:	7a 62                	jp     70b688 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1b8>
  70b626:	43 8b 44 25 f4       	mov    -0xc(%r13,%r12,1),%eax
  70b62b:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  70b62f:	43 0f 10 4c 25 e4    	movups -0x1c(%r13,%r12,1),%xmm1
  70b635:	0f 11 4c 24 0c       	movups %xmm1,0xc(%rsp)
  70b63a:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70b640:	f3 43 0f 10 44 25 b8 	movss  -0x48(%r13,%r12,1),%xmm0
  70b647:	f3 43 0f 10 4c 25 bc 	movss  -0x44(%r13,%r12,1),%xmm1
  70b64e:	48 8d 7c 24 64       	lea    0x64(%rsp),%rdi
  70b653:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
  70b658:	e8 a3 eb fe ff       	call   6fa200 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click::{closure#1}>
  70b65d:	83 7c 24 64 01       	cmpl   $0x1,0x64(%rsp)
  70b662:	75 24                	jne    70b688 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1b8>
  70b664:	f2 0f 10 44 24 68    	movsd  0x68(%rsp),%xmm0
  70b66a:	0f 28 c8             	movaps %xmm0,%xmm1
  70b66d:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70b671:	4b 8d 3c 2c          	lea    (%r12,%r13,1),%rdi
  70b675:	48 83 c7 c0          	add    $0xffffffffffffffc0,%rdi
  70b679:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  70b67e:	ff 15 44 df 41 00    	call   *0x41df44(%rip)        # b295c8 <_DYNAMIC+0x540>
  70b684:	84 c0                	test   %al,%al
  70b686:	75 40                	jne    70b6c8 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1f8>
  70b688:	f3 43 0f 10 44 25 c8 	movss  -0x38(%r13,%r12,1),%xmm0
  70b68f:	0f 57 d2             	xorps  %xmm2,%xmm2
  70b692:	0f 2e c2             	ucomiss %xmm2,%xmm0
  70b695:	75 06                	jne    70b69d <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1cd>
  70b697:	0f 8b 82 01 00 00    	jnp    70b81f <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70b69d:	f3 43 0f 10 4c 25 cc 	movss  -0x34(%r13,%r12,1),%xmm1
  70b6a4:	0f 2e ca             	ucomiss %xmm2,%xmm1
  70b6a7:	75 06                	jne    70b6af <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1df>
  70b6a9:	0f 8b 70 01 00 00    	jnp    70b81f <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70b6af:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70b6b2:	0f 59 05 67 f8 94 ff 	mulps  -0x6b0799(%rip),%xmm0        # 5af20 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1120>
  70b6b9:	f2 43 0f 10 4c 25 c0 	movsd  -0x40(%r13,%r12,1),%xmm1
  70b6c0:	0f 58 c8             	addps  %xmm0,%xmm1
  70b6c3:	0f 29 4c 24 40       	movaps %xmm1,0x40(%rsp)
  70b6c8:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70b6cf:	00 00 
  70b6d1:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b6d6:	e8 15 c8 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70b6db:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70b6e0:	0f 28 c8             	movaps %xmm0,%xmm1
  70b6e3:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70b6e7:	48 89 df             	mov    %rbx,%rdi
  70b6ea:	0f 29 8c 24 a0 00 00 	movaps %xmm1,0xa0(%rsp)
  70b6f1:	00 
  70b6f2:	e8 49 ef 00 00       	call   71a640 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::hit>
  70b6f7:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70b6fe:	00 00 
  70b700:	a8 01                	test   $0x1,%al
  70b702:	0f 84 17 01 00 00    	je     70b81f <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70b708:	49 89 d5             	mov    %rdx,%r13
  70b70b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b710:	e8 db c7 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70b715:	4d 39 fd             	cmp    %r15,%r13
  70b718:	0f 85 01 01 00 00    	jne    70b81f <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70b71e:	4c 3b b3 b0 05 00 00 	cmp    0x5b0(%rbx),%r14
  70b725:	0f 85 01 01 00 00    	jne    70b82c <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x35c>
  70b72b:	4c 89 fa             	mov    %r15,%rdx
  70b72e:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b733:	48 89 de             	mov    %rbx,%rsi
  70b736:	e8 45 ec 00 00       	call   71a380 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  70b73b:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  70b740:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70b745:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  70b749:	0f 85 e2 00 00 00    	jne    70b831 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x361>
  70b74f:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70b756:	48 39 f0             	cmp    %rsi,%rax
  70b759:	0f 83 88 01 00 00    	jae    70b8e7 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x417>
  70b75f:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70b766:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  70b76a:	8b 44 c1 20          	mov    0x20(%rcx,%rax,8),%eax
  70b76e:	83 e0 07             	and    $0x7,%eax
  70b771:	83 f8 02             	cmp    $0x2,%eax
  70b774:	0f 85 df 00 00 00    	jne    70b859 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x389>
  70b77a:	48 89 ef             	mov    %rbp,%rdi
  70b77d:	48 89 de             	mov    %rbx,%rsi
  70b780:	4c 89 f2             	mov    %r14,%rdx
  70b783:	4c 89 f9             	mov    %r15,%rcx
  70b786:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70b78b:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70b792:	00 
  70b793:	e8 48 95 ff ff       	call   704ce0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer>
  70b798:	e9 05 01 00 00       	jmp    70b8a2 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x3d2>
  70b79d:	b8 11 00 00 00       	mov    $0x11,%eax
  70b7a2:	eb 2c                	jmp    70b7d0 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x300>
  70b7a4:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  70b7a9:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70b7ae:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70b7b3:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70b7b8:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  70b7bf:	00 
  70b7c0:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70b7c5:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  70b7cc:	00 
  70b7cd:	48 89 ef             	mov    %rbp,%rdi
  70b7d0:	48 89 07             	mov    %rax,(%rdi)
  70b7d3:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70b7d7:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70b7dc:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
  70b7e3:	00 
  70b7e4:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70b7e8:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  70b7ec:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  70b7f3:	00 
  70b7f4:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70b7f8:	eb 07                	jmp    70b801 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70b7fa:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70b801:	48 89 f8             	mov    %rdi,%rax
  70b804:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  70b80b:	5b                   	pop    %rbx
  70b80c:	41 5c                	pop    %r12
  70b80e:	41 5d                	pop    %r13
  70b810:	41 5e                	pop    %r14
  70b812:	41 5f                	pop    %r15
  70b814:	5d                   	pop    %rbp
  70b815:	c3                   	ret
  70b816:	48 c7 07 11 00 00 00 	movq   $0x11,(%rdi)
  70b81d:	eb e2                	jmp    70b801 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70b81f:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70b826:	00 
  70b827:	48 89 e8             	mov    %rbp,%rax
  70b82a:	eb d8                	jmp    70b804 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70b82c:	b9 11 00 00 00       	mov    $0x11,%ecx
  70b831:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70b836:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  70b83a:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70b83f:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70b844:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  70b848:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70b84c:	48 89 4d 00          	mov    %rcx,0x0(%rbp)
  70b850:	48 89 45 08          	mov    %rax,0x8(%rbp)
  70b854:	48 89 e8             	mov    %rbp,%rax
  70b857:	eb ab                	jmp    70b804 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70b859:	4c 8b ab e8 05 00 00 	mov    0x5e8(%rbx),%r13
  70b860:	4c 8b a3 f0 05 00 00 	mov    0x5f0(%rbx),%r12
  70b867:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b86c:	48 89 de             	mov    %rbx,%rsi
  70b86f:	4c 89 f2             	mov    %r14,%rdx
  70b872:	4c 89 f9             	mov    %r15,%rcx
  70b875:	e8 46 57 ff ff       	call   700fc0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::focus>
  70b87a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70b87f:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70b883:	75 25                	jne    70b8aa <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x3da>
  70b885:	4c 89 24 24          	mov    %r12,(%rsp)
  70b889:	48 89 ef             	mov    %rbp,%rdi
  70b88c:	48 89 de             	mov    %rbx,%rsi
  70b88f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  70b894:	4c 89 f1             	mov    %r14,%rcx
  70b897:	4d 89 f8             	mov    %r15,%r8
  70b89a:	4d 89 e9             	mov    %r13,%r9
  70b89d:	e8 1e f2 fe ff       	call   6faac0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused>
  70b8a2:	48 89 e8             	mov    %rbp,%rax
  70b8a5:	e9 5a ff ff ff       	jmp    70b804 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70b8aa:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  70b8af:	0f b6 54 24 38       	movzbl 0x38(%rsp),%edx
  70b8b4:	8b 74 24 3c          	mov    0x3c(%rsp),%esi
  70b8b8:	89 75 34             	mov    %esi,0x34(%rbp)
  70b8bb:	8b 74 24 39          	mov    0x39(%rsp),%esi
  70b8bf:	89 75 31             	mov    %esi,0x31(%rbp)
  70b8c2:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  70b8c7:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  70b8cc:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70b8d0:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70b8d4:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70b8d8:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  70b8dc:	88 55 30             	mov    %dl,0x30(%rbp)
  70b8df:	48 89 e8             	mov    %rbp,%rax
  70b8e2:	e9 1d ff ff ff       	jmp    70b804 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70b8e7:	48 8d 15 c2 f8 3e 00 	lea    0x3ef8c2(%rip),%rdx        # afb1b0 <__frame_dummy_init_array_entry+0x948>
  70b8ee:	48 89 c7             	mov    %rax,%rdi
  70b8f1:	ff 15 e9 da 41 00    	call   *0x41dae9(%rip)        # b293e0 <_DYNAMIC+0x358>
