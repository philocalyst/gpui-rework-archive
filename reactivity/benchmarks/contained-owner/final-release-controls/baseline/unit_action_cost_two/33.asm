
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fd600 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing>:
  6fd600:	55                   	push   %rbp
  6fd601:	41 57                	push   %r15
  6fd603:	41 56                	push   %r14
  6fd605:	41 55                	push   %r13
  6fd607:	41 54                	push   %r12
  6fd609:	53                   	push   %rbx
  6fd60a:	48 81 ec c8 03 00 00 	sub    $0x3c8,%rsp
  6fd611:	4d 89 c4             	mov    %r8,%r12
  6fd614:	49 89 cf             	mov    %rcx,%r15
  6fd617:	49 89 f6             	mov    %rsi,%r14
  6fd61a:	48 89 fb             	mov    %rdi,%rbx
  6fd61d:	41 83 38 02          	cmpl   $0x2,(%r8)
  6fd621:	75 08                	jne    6fd62b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2b>
  6fd623:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  6fd62a:	01 
  6fd62b:	4d 85 ff             	test   %r15,%r15
  6fd62e:	0f 84 94 01 00 00    	je     6fd7c8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c8>
  6fd634:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  6fd63b:	01 
  6fd63c:	0f 85 86 01 00 00    	jne    6fd7c8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c8>
  6fd642:	49 8b 86 28 02 00 00 	mov    0x228(%r14),%rax
  6fd649:	49 8d 8e 30 02 00 00 	lea    0x230(%r14),%rcx
  6fd650:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fd654:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
  6fd659:	48 0f 44 ce          	cmove  %rsi,%rcx
  6fd65d:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  6fd661:	66 0f 7f 84 24 60 01 	movdqa %xmm0,0x160(%rsp)
  6fd668:	00 00 
  6fd66a:	74 45                	je     6fd6b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xb1>
  6fd66c:	66 0f 6f 84 24 60 01 	movdqa 0x160(%rsp),%xmm0
  6fd673:	00 00 
  6fd675:	f3 0f 7f 84 24 c8 01 	movdqu %xmm0,0x1c8(%rsp)
  6fd67c:	00 00 
  6fd67e:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6fd685:	00 
  6fd686:	48 8b 94 24 c9 01 00 	mov    0x1c9(%rsp),%rdx
  6fd68d:	00 
  6fd68e:	48 8b b4 24 d0 01 00 	mov    0x1d0(%rsp),%rsi
  6fd695:	00 
  6fd696:	48 89 73 18          	mov    %rsi,0x18(%rbx)
  6fd69a:	48 89 53 11          	mov    %rdx,0x11(%rbx)
  6fd69e:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fd6a5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fd6a9:	88 4b 10             	mov    %cl,0x10(%rbx)
  6fd6ac:	e9 5e 03 00 00       	jmp    6fda0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fd6b1:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  6fd6b6:	41 83 ff 01          	cmp    $0x1,%r15d
  6fd6ba:	0f 85 80 00 00 00    	jne    6fd740 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x140>
  6fd6c0:	48 89 d5             	mov    %rdx,%rbp
  6fd6c3:	49 8b 8e 48 02 00 00 	mov    0x248(%r14),%rcx
  6fd6ca:	4d 8b a6 50 02 00 00 	mov    0x250(%r14),%r12
  6fd6d1:	49 c1 e4 04          	shl    $0x4,%r12
  6fd6d5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6fd6dc:	00 00 00 00 
  6fd6e0:	4d 85 e4             	test   %r12,%r12
  6fd6e3:	0f 84 7a 03 00 00    	je     6fda63 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x463>
  6fd6e9:	4c 8d 69 10          	lea    0x10(%rcx),%r13
  6fd6ed:	48 8b 39             	mov    (%rcx),%rdi
  6fd6f0:	48 8b 41 08          	mov    0x8(%rcx),%rax
  6fd6f4:	ff 50 18             	call   *0x18(%rax)
  6fd6f7:	49 83 c4 f0          	add    $0xfffffffffffffff0,%r12
  6fd6fb:	4c 89 e9             	mov    %r13,%rcx
  6fd6fe:	4c 39 f8             	cmp    %r15,%rax
  6fd701:	75 dd                	jne    6fd6e0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xe0>
  6fd703:	49 8b 8e 60 02 00 00 	mov    0x260(%r14),%rcx
  6fd70a:	49 8b 86 68 02 00 00 	mov    0x268(%r14),%rax
  6fd711:	48 c1 e0 03          	shl    $0x3,%rax
  6fd715:	31 f6                	xor    %esi,%esi
  6fd717:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd71c:	0f 1f 40 00          	nopl   0x0(%rax)
  6fd720:	48 89 f2             	mov    %rsi,%rdx
  6fd723:	48 39 f0             	cmp    %rsi,%rax
  6fd726:	74 0a                	je     6fd732 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x132>
  6fd728:	48 8d 72 08          	lea    0x8(%rdx),%rsi
  6fd72c:	4c 39 3c 11          	cmp    %r15,(%rcx,%rdx,1)
  6fd730:	75 ee                	jne    6fd720 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x120>
  6fd732:	48 39 d0             	cmp    %rdx,%rax
  6fd735:	0f 95 c1             	setne  %cl
  6fd738:	48 89 ea             	mov    %rbp,%rdx
  6fd73b:	e9 7f 00 00 00       	jmp    6fd7bf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1bf>
  6fd740:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6fd747:	00 
  6fd748:	4d 8b a6 78 02 00 00 	mov    0x278(%r14),%r12
  6fd74f:	4d 8b ae 80 02 00 00 	mov    0x280(%r14),%r13
  6fd756:	49 c1 e5 04          	shl    $0x4,%r13
  6fd75a:	31 ed                	xor    %ebp,%ebp
  6fd75c:	0f 1f 40 00          	nopl   0x0(%rax)
  6fd760:	49 39 ed             	cmp    %rbp,%r13
  6fd763:	0f 84 0e 03 00 00    	je     6fda77 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x477>
  6fd769:	49 8b 3c 2c          	mov    (%r12,%rbp,1),%rdi
  6fd76d:	49 8b 44 2c 08       	mov    0x8(%r12,%rbp,1),%rax
  6fd772:	4c 89 fe             	mov    %r15,%rsi
  6fd775:	ff 50 30             	call   *0x30(%rax)
  6fd778:	48 83 c5 10          	add    $0x10,%rbp
  6fd77c:	84 c0                	test   %al,%al
  6fd77e:	74 e0                	je     6fd760 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160>
  6fd780:	49 8b 74 2c f0       	mov    -0x10(%r12,%rbp,1),%rsi
  6fd785:	49 8b 44 2c f8       	mov    -0x8(%r12,%rbp,1),%rax
  6fd78a:	48 8d bc 24 c0 01 00 	lea    0x1c0(%rsp),%rdi
  6fd791:	00 
  6fd792:	4c 89 fa             	mov    %r15,%rdx
  6fd795:	ff 50 60             	call   *0x60(%rax)
  6fd798:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
  6fd79f:	00 
  6fd7a0:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  6fd7a7:	00 
  6fd7a8:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fd7ac:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fd7b1:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  6fd7b8:	00 
  6fd7b9:	0f 85 c7 fe ff ff    	jne    6fd686 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x86>
  6fd7bf:	f6 c1 01             	test   $0x1,%cl
  6fd7c2:	0f 84 f4 02 00 00    	je     6fdabc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x4bc>
  6fd7c8:	49 ff 86 00 07 00 00 	incq   0x700(%r14)
  6fd7cf:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fd7d4:	4c 89 f6             	mov    %r14,%rsi
  6fd7d7:	31 c9                	xor    %ecx,%ecx
  6fd7d9:	e8 92 f5 ff ff       	call   6fcd70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>
  6fd7de:	83 7c 24 70 fe       	cmpl   $0xfffffffe,0x70(%rsp)
  6fd7e3:	75 16                	jne    6fd7fb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1fb>
  6fd7e5:	c6 84 24 28 02 00 00 	movb   $0x0,0x228(%rsp)
  6fd7ec:	00 
  6fd7ed:	48 c7 84 24 20 02 00 	movq   $0xfffffffffffffffe,0x220(%rsp)
  6fd7f4:	00 fe ff ff ff 
  6fd7f9:	eb 41                	jmp    6fd83c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x23c>
  6fd7fb:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fd802:	00 
  6fd803:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  6fd80a:	00 
  6fd80b:	f3 0f 6f 44 24 70    	movdqu 0x70(%rsp),%xmm0
  6fd811:	f3 0f 6f 8c 24 80 00 	movdqu 0x80(%rsp),%xmm1
  6fd818:	00 00 
  6fd81a:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  6fd821:	00 
  6fd822:	0f 29 94 24 40 02 00 	movaps %xmm2,0x240(%rsp)
  6fd829:	00 
  6fd82a:	66 0f 7f 8c 24 30 02 	movdqa %xmm1,0x230(%rsp)
  6fd831:	00 00 
  6fd833:	66 0f 7f 84 24 20 02 	movdqa %xmm0,0x220(%rsp)
  6fd83a:	00 00 
  6fd83c:	40 b5 01             	mov    $0x1,%bpl
  6fd83f:	45 31 ff             	xor    %r15d,%r15d
  6fd842:	48 83 bc 24 20 02 00 	cmpq   $0xfffffffffffffffe,0x220(%rsp)
  6fd849:	00 fe 
  6fd84b:	0f 85 ba 00 00 00    	jne    6fd90b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x30b>
  6fd851:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6fd858:	00 
  6fd859:	4c 89 f6             	mov    %r14,%rsi
  6fd85c:	4c 89 e2             	mov    %r12,%rdx
  6fd85f:	e8 2c 40 00 00       	call   701890 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::reconcile_editing>
  6fd864:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  6fd86b:	00 
  6fd86c:	44 0f b6 a4 24 f8 00 	movzbl 0xf8(%rsp),%r12d
  6fd873:	00 00 
  6fd875:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fd879:	0f 85 61 01 00 00    	jne    6fd9e0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x3e0>
  6fd87f:	48 8d 35 f2 a1 96 ff 	lea    -0x695e0e(%rip),%rsi        # 67a78 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x98b>
  6fd886:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6fd88d:	00 
  6fd88e:	e8 6d d7 02 00       	call   72b000 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6fd893:	84 c0                	test   %al,%al
  6fd895:	74 26                	je     6fd8bd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2bd>
  6fd897:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fd89e:	48 85 c0             	test   %rax,%rax
  6fd8a1:	0f 84 7a 01 00 00    	je     6fda21 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x421>
  6fd8a7:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6fd8ae:	00 
  6fd8af:	0f 95 c0             	setne  %al
  6fd8b2:	44 08 e0             	or     %r12b,%al
  6fd8b5:	a8 01                	test   $0x1,%al
  6fd8b7:	0f 84 6e 01 00 00    	je     6fda2b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x42b>
  6fd8bd:	48 8d 35 ec a1 96 ff 	lea    -0x695e14(%rip),%rsi        # 67ab0 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x9c3>
  6fd8c4:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  6fd8cb:	00 
  6fd8cc:	e8 2f d7 02 00       	call   72b000 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  6fd8d1:	84 c0                	test   %al,%al
  6fd8d3:	74 26                	je     6fd8fb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2fb>
  6fd8d5:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fd8dc:	48 85 c0             	test   %rax,%rax
  6fd8df:	0f 84 a7 01 00 00    	je     6fda8c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x48c>
  6fd8e5:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  6fd8ec:	00 
  6fd8ed:	0f 95 c0             	setne  %al
  6fd8f0:	44 08 e0             	or     %r12b,%al
  6fd8f3:	a8 01                	test   $0x1,%al
  6fd8f5:	0f 84 9b 01 00 00    	je     6fda96 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x496>
  6fd8fb:	48 89 df             	mov    %rbx,%rdi
  6fd8fe:	4c 89 f6             	mov    %r14,%rsi
  6fd901:	e8 ba a8 02 00       	call   7281c0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  6fd906:	e9 04 01 00 00       	jmp    6fda0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fd90b:	48 8b 84 24 50 02 00 	mov    0x250(%rsp),%rax
  6fd912:	00 
  6fd913:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6fd91a:	00 
  6fd91b:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  6fd922:	00 
  6fd923:	0f 28 8c 24 30 02 00 	movaps 0x230(%rsp),%xmm1
  6fd92a:	00 
  6fd92b:	0f 28 94 24 40 02 00 	movaps 0x240(%rsp),%xmm2
  6fd932:	00 
  6fd933:	0f 29 94 24 10 01 00 	movaps %xmm2,0x110(%rsp)
  6fd93a:	00 
  6fd93b:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  6fd942:	00 
  6fd943:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  6fd94a:	00 
  6fd94b:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  6fd952:	48 85 c0             	test   %rax,%rax
  6fd955:	74 41                	je     6fd998 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x398>
  6fd957:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  6fd95e:	48 85 c0             	test   %rax,%rax
  6fd961:	74 35                	je     6fd998 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x398>
  6fd963:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fd967:	0f b6 48 24          	movzbl 0x24(%rax),%ecx
  6fd96b:	c6 40 24 02          	movb   $0x2,0x24(%rax)
  6fd96f:	80 f9 02             	cmp    $0x2,%cl
  6fd972:	74 24                	je     6fd998 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x398>
  6fd974:	f6 07 01             	testb  $0x1,(%rdi)
  6fd977:	75 17                	jne    6fd990 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x390>
  6fd979:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fd97d:	a8 01                	test   $0x1,%al
  6fd97f:	75 0f                	jne    6fd990 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x390>
  6fd981:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fd985:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fd98a:	0f 84 31 19 00 00    	je     6ff2c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cc1>
  6fd990:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  6fd997:	01 
  6fd998:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  6fd99f:	00 
  6fd9a0:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fd9a7:	00 00 00 00 
  6fd9ab:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  6fd9b2:	00 
  6fd9b3:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fd9b7:	66 0f 6f 84 24 f0 00 	movdqa 0xf0(%rsp),%xmm0
  6fd9be:	00 00 
  6fd9c0:	66 0f 6f 8c 24 00 01 	movdqa 0x100(%rsp),%xmm1
  6fd9c7:	00 00 
  6fd9c9:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
  6fd9d0:	00 
  6fd9d1:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6fd9d5:	f3 0f 7f 4b 10       	movdqu %xmm1,0x10(%rbx)
  6fd9da:	f3 0f 7f 03          	movdqu %xmm0,(%rbx)
  6fd9de:	eb 2f                	jmp    6fda0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fd9e0:	f3 0f 6f 84 24 f9 00 	movdqu 0xf9(%rsp),%xmm0
  6fd9e7:	00 00 
  6fd9e9:	f3 0f 6f 8c 24 09 01 	movdqu 0x109(%rsp),%xmm1
  6fd9f0:	00 00 
  6fd9f2:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  6fd9f9:	00 
  6fd9fa:	0f 11 53 28          	movups %xmm2,0x28(%rbx)
  6fd9fe:	f3 0f 7f 4b 19       	movdqu %xmm1,0x19(%rbx)
  6fda03:	f3 0f 7f 43 09       	movdqu %xmm0,0x9(%rbx)
  6fda08:	48 89 03             	mov    %rax,(%rbx)
  6fda0b:	44 88 63 08          	mov    %r12b,0x8(%rbx)
  6fda0f:	48 81 c4 c8 03 00 00 	add    $0x3c8,%rsp
  6fda16:	5b                   	pop    %rbx
  6fda17:	41 5c                	pop    %r12
  6fda19:	41 5d                	pop    %r13
  6fda1b:	41 5e                	pop    %r14
  6fda1d:	41 5f                	pop    %r15
  6fda1f:	5d                   	pop    %rbp
  6fda20:	c3                   	ret
  6fda21:	41 80 fc 01          	cmp    $0x1,%r12b
  6fda25:	0f 84 92 fe ff ff    	je     6fd8bd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2bd>
  6fda2b:	f3 41 0f 6f 86 60 06 	movdqu 0x660(%r14),%xmm0
  6fda32:	00 00 
  6fda34:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  6fda3b:	00 
  6fda3c:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fda43:	00 
  6fda44:	74 16                	je     6fda5c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x45c>
  6fda46:	84 c0                	test   %al,%al
  6fda48:	0f 84 c7 00 00 00    	je     6fdb15 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x515>
  6fda4e:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fda55:	ff 
  6fda56:	0f 85 b9 00 00 00    	jne    6fdb15 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x515>
  6fda5c:	31 c9                	xor    %ecx,%ecx
  6fda5e:	e9 be 00 00 00       	jmp    6fdb21 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x521>
  6fda63:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fda6a:	00 
  6fda6b:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fda70:	b1 01                	mov    $0x1,%cl
  6fda72:	e9 0f fc ff ff       	jmp    6fd686 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x86>
  6fda77:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  6fda7e:	00 
  6fda7f:	b8 0b 00 00 00       	mov    $0xb,%eax
  6fda84:	44 89 f9             	mov    %r15d,%ecx
  6fda87:	e9 fa fb ff ff       	jmp    6fd686 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x86>
  6fda8c:	41 80 fc 01          	cmp    $0x1,%r12b
  6fda90:	0f 84 65 fe ff ff    	je     6fd8fb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2fb>
  6fda96:	40 84 ed             	test   %bpl,%bpl
  6fda99:	0f 85 15 18 00 00    	jne    6ff2b4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cb4>
  6fda9f:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  6fdaa3:	4c 89 f6             	mov    %r14,%rsi
  6fdaa6:	31 d2                	xor    %edx,%edx
  6fdaa8:	4c 89 f9             	mov    %r15,%rcx
  6fdaab:	e8 10 53 00 00       	call   702dc0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::publish_metadata>
  6fdab0:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fdab7:	e9 53 ff ff ff       	jmp    6fda0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fdabc:	4c 89 bc 24 68 03 00 	mov    %r15,0x368(%rsp)
  6fdac3:	00 
  6fdac4:	49 ff 86 f8 06 00 00 	incq   0x6f8(%r14)
  6fdacb:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  6fdad2:	48 85 c0             	test   %rax,%rax
  6fdad5:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  6fdadc:	00 
  6fdadd:	0f 84 90 02 00 00    	je     6fdd73 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fdae3:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  6fdaea:	48 85 c9             	test   %rcx,%rcx
  6fdaed:	0f 84 9c 00 00 00    	je     6fdb8f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x58f>
  6fdaf3:	48 89 ca             	mov    %rcx,%rdx
  6fdaf6:	48 83 e2 07          	and    $0x7,%rdx
  6fdafa:	74 4c                	je     6fdb48 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x548>
  6fdafc:	31 f6                	xor    %esi,%esi
  6fdafe:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fdb05:	48 ff c6             	inc    %rsi
  6fdb08:	48 39 f2             	cmp    %rsi,%rdx
  6fdb0b:	75 f1                	jne    6fdafe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x4fe>
  6fdb0d:	48 89 ca             	mov    %rcx,%rdx
  6fdb10:	48 29 f2             	sub    %rsi,%rdx
  6fdb13:	eb 36                	jmp    6fdb4b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x54b>
  6fdb15:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fdb1c:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fdb21:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fdb28:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  6fdb2c:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fdb30:	f3 0f 7f 43 18       	movdqu %xmm0,0x18(%rbx)
  6fdb35:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  6fdb39:	88 43 30             	mov    %al,0x30(%rbx)
  6fdb3c:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fdb43:	e9 c7 fe ff ff       	jmp    6fda0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x40f>
  6fdb48:	48 89 ca             	mov    %rcx,%rdx
  6fdb4b:	48 83 f9 08          	cmp    $0x8,%rcx
  6fdb4f:	72 3e                	jb     6fdb8f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x58f>
  6fdb51:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fdb58:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fdb5f:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fdb66:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fdb6d:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fdb74:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fdb7b:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fdb82:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  6fdb89:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  6fdb8d:	75 c2                	jne    6fdb51 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x551>
  6fdb8f:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  6fdb96:	00 
  6fdb97:	0f 84 d6 01 00 00    	je     6fdd73 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fdb9d:	80 38 00             	cmpb   $0x0,(%rax)
  6fdba0:	0f 85 cd 01 00 00    	jne    6fdd73 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fdba6:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  6fdbad:	48 8d b4 24 68 03 00 	lea    0x368(%rsp),%rsi
  6fdbb4:	00 
  6fdbb5:	e8 a6 4f 04 00       	call   742b60 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout>>::get::<gpui::source::FieldId>>
  6fdbba:	48 85 c0             	test   %rax,%rax
  6fdbbd:	0f 84 b0 01 00 00    	je     6fdd73 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fdbc3:	48 8b 48 10          	mov    0x10(%rax),%rcx
  6fdbc7:	48 c1 e1 02          	shl    $0x2,%rcx
  6fdbcb:	48 83 38 ff          	cmpq   $0xffffffffffffffff,(%rax)
  6fdbcf:	ba 04 00 00 00       	mov    $0x4,%edx
  6fdbd4:	48 0f 45 50 08       	cmovne 0x8(%rax),%rdx
  6fdbd9:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fdbde:	b8 00 00 00 00       	mov    $0x0,%eax
  6fdbe3:	48 0f 45 c1          	cmovne %rcx,%rax
  6fdbe7:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fdbec:	48 85 c0             	test   %rax,%rax
  6fdbef:	0f 84 7e 01 00 00    	je     6fdd73 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x773>
  6fdbf5:	45 31 ed             	xor    %r13d,%r13d
  6fdbf8:	48 8b 05 41 a4 42 00 	mov    0x42a441(%rip),%rax        # b28040 <_DYNAMIC+0x388>
  6fdbff:	48 83 c0 20          	add    $0x20,%rax
  6fdc03:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6fdc08:	48 8b 05 39 a4 42 00 	mov    0x42a439(%rip),%rax        # b28048 <_DYNAMIC+0x390>
  6fdc0f:	48 83 c0 20          	add    $0x20,%rax
  6fdc13:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fdc18:	48 8b 05 31 a4 42 00 	mov    0x42a431(%rip),%rax        # b28050 <_DYNAMIC+0x398>
  6fdc1f:	48 83 c0 20          	add    $0x20,%rax
  6fdc23:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6fdc28:	48 8b 05 29 a4 42 00 	mov    0x42a429(%rip),%rax        # b28058 <_DYNAMIC+0x3a0>
  6fdc2f:	48 83 c0 20          	add    $0x20,%rax
  6fdc33:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  6fdc38:	48 8b 05 21 a4 42 00 	mov    0x42a421(%rip),%rax        # b28060 <_DYNAMIC+0x3a8>
  6fdc3f:	48 83 c0 20          	add    $0x20,%rax
  6fdc43:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fdc48:	48 8b 05 19 a4 42 00 	mov    0x42a419(%rip),%rax        # b28068 <_DYNAMIC+0x3b0>
  6fdc4f:	48 83 c0 20          	add    $0x20,%rax
  6fdc53:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fdc5a:	00 
  6fdc5b:	48 8b 05 0e a4 42 00 	mov    0x42a40e(%rip),%rax        # b28070 <_DYNAMIC+0x3b8>
  6fdc62:	48 83 c0 20          	add    $0x20,%rax
  6fdc66:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6fdc6d:	00 
  6fdc6e:	48 8b 05 03 a4 42 00 	mov    0x42a403(%rip),%rax        # b28078 <_DYNAMIC+0x3c0>
  6fdc75:	48 83 c0 20          	add    $0x20,%rax
  6fdc79:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fdc7e:	48 8b 05 fb a3 42 00 	mov    0x42a3fb(%rip),%rax        # b28080 <_DYNAMIC+0x3c8>
  6fdc85:	48 83 c0 20          	add    $0x20,%rax
  6fdc89:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  6fdc90:	00 
  6fdc91:	48 8b 05 f0 a3 42 00 	mov    0x42a3f0(%rip),%rax        # b28088 <_DYNAMIC+0x3d0>
  6fdc98:	48 83 c0 20          	add    $0x20,%rax
  6fdc9c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fdca1:	48 8b 05 e8 a3 42 00 	mov    0x42a3e8(%rip),%rax        # b28090 <_DYNAMIC+0x3d8>
  6fdca8:	48 83 c0 20          	add    $0x20,%rax
  6fdcac:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  6fdcb3:	00 
  6fdcb4:	48 8b 05 dd a3 42 00 	mov    0x42a3dd(%rip),%rax        # b28098 <_DYNAMIC+0x3e0>
  6fdcbb:	48 83 c0 20          	add    $0x20,%rax
  6fdcbf:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fdcc4:	48 8b 05 d5 a3 42 00 	mov    0x42a3d5(%rip),%rax        # b280a0 <_DYNAMIC+0x3e8>
  6fdccb:	48 83 c0 20          	add    $0x20,%rax
  6fdccf:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6fdcd4:	48 8d 2d 3d d4 95 ff 	lea    -0x6a2bc3(%rip),%rbp        # 5b118 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x14a8>
  6fdcdb:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fdce0:	42 8b 3c 28          	mov    (%rax,%r13,1),%edi
  6fdce4:	ff 15 be a3 42 00    	call   *0x42a3be(%rip)        # b280a8 <_DYNAMIC+0x3f0>
  6fdcea:	0f b7 c0             	movzwl %ax,%eax
  6fdced:	48 63 4c 85 00       	movslq 0x0(%rbp,%rax,4),%rcx
  6fdcf2:	48 01 e9             	add    %rbp,%rcx
  6fdcf5:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fdcfa:	ff e1                	jmp    *%rcx
  6fdcfc:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6fdd01:	eb 57                	jmp    6fdd5a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fdd03:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6fdd0a:	00 
  6fdd0b:	eb 4d                	jmp    6fdd5a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fdd0d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6fdd12:	eb 46                	jmp    6fdd5a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fdd14:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fdd19:	eb 3f                	jmp    6fdd5a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fdd1b:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  6fdd22:	00 
  6fdd23:	eb 35                	jmp    6fdd5a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fdd25:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fdd2a:	eb 2e                	jmp    6fdd5a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fdd2c:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fdd33:	00 
  6fdd34:	eb 24                	jmp    6fdd5a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fdd36:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  6fdd3b:	eb 1d                	jmp    6fdd5a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fdd3d:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fdd42:	eb 16                	jmp    6fdd5a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fdd44:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6fdd4b:	00 
  6fdd4c:	eb 0c                	jmp    6fdd5a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fdd4e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fdd53:	eb 05                	jmp    6fdd5a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x75a>
  6fdd55:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fdd5a:	80 78 13 00          	cmpb   $0x0,0x13(%rax)
  6fdd5e:	0f 85 03 11 00 00    	jne    6fee67 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1867>
  6fdd64:	49 83 c5 04          	add    $0x4,%r13
  6fdd68:	4c 39 6c 24 18       	cmp    %r13,0x18(%rsp)
  6fdd6d:	0f 85 68 ff ff ff    	jne    6fdcdb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x6db>
  6fdd73:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  6fdd7a:	00 00 
  6fdd7c:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  6fdd83:	48 85 ed             	test   %rbp,%rbp
  6fdd86:	0f 84 f2 10 00 00    	je     6fee7e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x187e>
  6fdd8c:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fdd93:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6fdd9a:	49 8b 86 d0 05 00 00 	mov    0x5d0(%r14),%rax
  6fdda1:	48 89 c7             	mov    %rax,%rdi
  6fdda4:	48 89 e9             	mov    %rbp,%rcx
  6fdda7:	44 0f b7 91 c2 01 00 	movzwl 0x1c2(%rcx),%r10d
  6fddae:	00 
  6fddaf:	45 89 d3             	mov    %r10d,%r11d
  6fddb2:	41 c1 e3 05          	shl    $0x5,%r11d
  6fddb6:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  6fddbd:	45 31 c9             	xor    %r9d,%r9d
  6fddc0:	4d 39 cb             	cmp    %r9,%r11
  6fddc3:	74 28                	je     6fdded <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7ed>
  6fddc5:	4e 3b bc c1 70 01 00 	cmp    0x170(%rcx,%r8,8),%r15
  6fddcc:	00 
  6fddcd:	41 0f 97 c4          	seta   %r12b
  6fddd1:	41 80 dc 00          	sbb    $0x0,%r12b
  6fddd5:	49 83 c1 20          	add    $0x20,%r9
  6fddd9:	49 ff c0             	inc    %r8
  6fdddc:	41 80 fc 01          	cmp    $0x1,%r12b
  6fdde0:	74 de                	je     6fddc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7c0>
  6fdde2:	45 0f b6 d4          	movzbl %r12b,%r10d
  6fdde6:	45 85 d2             	test   %r10d,%r10d
  6fdde9:	75 05                	jne    6fddf0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7f0>
  6fddeb:	eb 1c                	jmp    6fde09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x809>
  6fdded:	4d 89 d0             	mov    %r10,%r8
  6fddf0:	48 83 ef 01          	sub    $0x1,%rdi
  6fddf4:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fddf9:	0f 82 92 00 00 00    	jb     6fde91 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x891>
  6fddff:	4a 8b 8c c1 c8 01 00 	mov    0x1c8(%rcx,%r8,8),%rcx
  6fde06:	00 
  6fde07:	eb 9e                	jmp    6fdda7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x7a7>
  6fde09:	4a 83 7c 09 e0 ff    	cmpq   $0xffffffffffffffff,-0x20(%rcx,%r9,1)
  6fde0f:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fde14:	75 7b                	jne    6fde91 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x891>
  6fde16:	42 8b 6c 09 e8       	mov    -0x18(%rcx,%r9,1),%ebp
  6fde1b:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fde22:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  6fde29:	4c 8d 05 50 c3 3f 00 	lea    0x3fc350(%rip),%r8        # afa180 <__frame_dummy_init_array_entry+0xc58>
  6fde30:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fde35:	4c 89 f9             	mov    %r15,%rcx
  6fde38:	45 31 c9             	xor    %r9d,%r9d
  6fde3b:	e8 30 63 05 00       	call   754170 <<gpui::source::Sources<unit_action_cost_two::Model>>::freeze>
  6fde40:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fde45:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  6fde4a:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6fde51:	00 
  6fde52:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6fde56:	0f 85 e6 00 00 00    	jne    6fdf42 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x942>
  6fde5c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fde63:	00 
  6fde64:	48 89 cd             	mov    %rcx,%rbp
  6fde67:	48 c1 ed 08          	shr    $0x8,%rbp
  6fde6b:	b8 20 00 00 00       	mov    $0x20,%eax
  6fde70:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fde75:	89 cf                	mov    %ecx,%edi
  6fde77:	e9 bb 12 00 00       	jmp    6ff137 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  6fde7c:	48 89 f9             	mov    %rdi,%rcx
  6fde7f:	48 83 e8 01          	sub    $0x1,%rax
  6fde83:	0f 82 f5 0f 00 00    	jb     6fee7e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x187e>
  6fde89:	48 8b ac cd c8 01 00 	mov    0x1c8(%rbp,%rcx,8),%rbp
  6fde90:	00 
  6fde91:	0f b7 bd c2 01 00 00 	movzwl 0x1c2(%rbp),%edi
  6fde98:	41 89 f8             	mov    %edi,%r8d
  6fde9b:	41 c1 e0 05          	shl    $0x5,%r8d
  6fde9f:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  6fdea6:	45 31 ed             	xor    %r13d,%r13d
  6fdea9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6fdeb0:	4d 39 e8             	cmp    %r13,%r8
  6fdeb3:	74 c7                	je     6fde7c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x87c>
  6fdeb5:	4c 3b bc cd 70 01 00 	cmp    0x170(%rbp,%rcx,8),%r15
  6fdebc:	00 
  6fdebd:	41 0f 97 c1          	seta   %r9b
  6fdec1:	41 80 d9 00          	sbb    $0x0,%r9b
  6fdec5:	49 83 c5 20          	add    $0x20,%r13
  6fdec9:	48 ff c1             	inc    %rcx
  6fdecc:	41 80 f9 01          	cmp    $0x1,%r9b
  6fded0:	74 de                	je     6fdeb0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x8b0>
  6fded2:	41 0f b6 f9          	movzbl %r9b,%edi
  6fded6:	85 ff                	test   %edi,%edi
  6fded8:	75 a5                	jne    6fde7f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x87f>
  6fdeda:	4a 8b 4c 2d e0       	mov    -0x20(%rbp,%r13,1),%rcx
  6fdedf:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  6fdee3:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fdee8:	74 41                	je     6fdf2b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x92b>
  6fdeea:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fdeef:	48 85 c0             	test   %rax,%rax
  6fdef2:	0f 84 46 01 00 00    	je     6fe03e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa3e>
  6fdef8:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fdefd:	48 ff c8             	dec    %rax
  6fdf00:	48 bf ff ff ff ff ff 	movabs $0x3fffffffffffffff,%rdi
  6fdf07:	ff ff 3f 
  6fdf0a:	48 21 c7             	and    %rax,%rdi
  6fdf0d:	4c 8d 4f 01          	lea    0x1(%rdi),%r9
  6fdf11:	45 89 c8             	mov    %r9d,%r8d
  6fdf14:	41 83 e0 03          	and    $0x3,%r8d
  6fdf18:	48 83 ff 03          	cmp    $0x3,%rdi
  6fdf1c:	0f 83 25 01 00 00    	jae    6fe047 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa47>
  6fdf22:	31 c0                	xor    %eax,%eax
  6fdf24:	31 ff                	xor    %edi,%edi
  6fdf26:	e9 b0 01 00 00       	jmp    6fe0db <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xadb>
  6fdf2b:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fdf32:	4c 8d 05 47 c2 3f 00 	lea    0x3fc247(%rip),%r8        # afa180 <__frame_dummy_init_array_entry+0xc58>
  6fdf39:	31 c0                	xor    %eax,%eax
  6fdf3b:	31 ff                	xor    %edi,%edi
  6fdf3d:	e9 d4 01 00 00       	jmp    6fe116 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xb16>
  6fdf42:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fdf47:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6fdf4c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fdf53:	00 
  6fdf54:	48 89 84 24 d0 02 00 	mov    %rax,0x2d0(%rsp)
  6fdf5b:	00 
  6fdf5c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6fdf63:	00 
  6fdf64:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
  6fdf6b:	00 
  6fdf6c:	41 83 fd 02          	cmp    $0x2,%r13d
  6fdf70:	0f 84 bc 13 00 00    	je     6ff332 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d32>
  6fdf76:	4c 89 6c 24 70       	mov    %r13,0x70(%rsp)
  6fdf7b:	0f 28 84 24 c0 02 00 	movaps 0x2c0(%rsp),%xmm0
  6fdf82:	00 
  6fdf83:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  6fdf88:	48 8b 84 24 d0 02 00 	mov    0x2d0(%rsp),%rax
  6fdf8f:	00 
  6fdf90:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  6fdf97:	00 
  6fdf98:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fdf9f:	00 
  6fdfa0:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6fdfa5:	ba 06 00 00 00       	mov    $0x6,%edx
  6fdfaa:	ff 15 00 a1 42 00    	call   *0x42a100(%rip)        # b280b0 <_DYNAMIC+0x3f8>
  6fdfb0:	0f b6 94 24 60 01 00 	movzbl 0x160(%rsp),%edx
  6fdfb7:	00 
  6fdfb8:	80 fa ff             	cmp    $0xff,%dl
  6fdfbb:	0f 84 79 0e 00 00    	je     6fee3a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x183a>
  6fdfc1:	8b 8c 24 63 01 00 00 	mov    0x163(%rsp),%ecx
  6fdfc8:	0f b6 84 24 67 01 00 	movzbl 0x167(%rsp),%eax
  6fdfcf:	00 
  6fdfd0:	0f 10 84 24 68 01 00 	movups 0x168(%rsp),%xmm0
  6fdfd7:	00 
  6fdfd8:	0f 29 84 24 90 03 00 	movaps %xmm0,0x390(%rsp)
  6fdfdf:	00 
  6fdfe0:	8b b4 24 78 01 00 00 	mov    0x178(%rsp),%esi
  6fdfe7:	89 b4 24 a0 03 00 00 	mov    %esi,0x3a0(%rsp)
  6fdfee:	80 fa 02             	cmp    $0x2,%dl
  6fdff1:	0f 85 35 0f 00 00    	jne    6fef2c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x192c>
  6fdff7:	89 ea                	mov    %ebp,%edx
  6fdff9:	48 c1 e0 20          	shl    $0x20,%rax
  6fdffd:	48 09 c8             	or     %rcx,%rax
  6fe000:	48 c1 e8 08          	shr    $0x8,%rax
  6fe004:	89 84 24 60 02 00 00 	mov    %eax,0x260(%rsp)
  6fe00b:	8b 84 24 98 03 00 00 	mov    0x398(%rsp),%eax
  6fe012:	89 84 24 6c 02 00 00 	mov    %eax,0x26c(%rsp)
  6fe019:	48 8b 84 24 90 03 00 	mov    0x390(%rsp),%rax
  6fe020:	00 
  6fe021:	48 89 84 24 64 02 00 	mov    %rax,0x264(%rsp)
  6fe028:	00 
  6fe029:	41 80 be 1f 07 00 00 	cmpb   $0x0,0x71f(%r14)
  6fe030:	00 
  6fe031:	0f 84 0c 0f 00 00    	je     6fef43 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1943>
  6fe037:	31 ed                	xor    %ebp,%ebp
  6fe039:	e9 24 0f 00 00       	jmp    6fef62 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1962>
  6fe03e:	31 ff                	xor    %edi,%edi
  6fe040:	31 c0                	xor    %eax,%eax
  6fe042:	e9 b5 00 00 00       	jmp    6fe0fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xafc>
  6fe047:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  6fe04c:	48 b8 00 00 00 00 00 	movabs $0x8000000000000000,%rax
  6fe053:	00 00 80 
  6fe056:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  6fe05a:	49 21 c1             	and    %rax,%r9
  6fe05d:	31 c0                	xor    %eax,%eax
  6fe05f:	31 ff                	xor    %edi,%edi
  6fe061:	44 8b 11             	mov    (%rcx),%r10d
  6fe064:	44 8b 41 04          	mov    0x4(%rcx),%r8d
  6fe068:	45 89 d4             	mov    %r10d,%r12d
  6fe06b:	41 f7 d4             	not    %r12d
  6fe06e:	41 f6 c4 03          	test   $0x3,%r12b
  6fe072:	41 0f 94 c4          	sete   %r12b
  6fe076:	45 89 c3             	mov    %r8d,%r11d
  6fe079:	41 f7 d3             	not    %r11d
  6fe07c:	41 f6 c3 03          	test   $0x3,%r11b
  6fe080:	41 0f 94 c3          	sete   %r11b
  6fe084:	45 08 e3             	or     %r12b,%r11b
  6fe087:	8b 51 08             	mov    0x8(%rcx),%edx
  6fe08a:	41 89 d4             	mov    %edx,%r12d
  6fe08d:	41 f7 d4             	not    %r12d
  6fe090:	41 f6 c4 03          	test   $0x3,%r12b
  6fe094:	41 0f 94 c4          	sete   %r12b
  6fe098:	8b 71 0c             	mov    0xc(%rcx),%esi
  6fe09b:	48 83 c1 10          	add    $0x10,%rcx
  6fe09f:	21 f2                	and    %esi,%edx
  6fe0a1:	f7 d6                	not    %esi
  6fe0a3:	40 f6 c6 03          	test   $0x3,%sil
  6fe0a7:	40 0f 94 c6          	sete   %sil
  6fe0ab:	44 08 e6             	or     %r12b,%sil
  6fe0ae:	44 08 de             	or     %r11b,%sil
  6fe0b1:	40 08 f7             	or     %sil,%dil
  6fe0b4:	45 21 c2             	and    %r8d,%r10d
  6fe0b7:	41 21 d2             	and    %edx,%r10d
  6fe0ba:	41 f7 d2             	not    %r10d
  6fe0bd:	41 f6 c2 03          	test   $0x3,%r10b
  6fe0c1:	0f 95 c2             	setne  %dl
  6fe0c4:	08 d0                	or     %dl,%al
  6fe0c6:	49 83 c1 fc          	add    $0xfffffffffffffffc,%r9
  6fe0ca:	75 95                	jne    6fe061 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa61>
  6fe0cc:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  6fe0d1:	4d 85 c0             	test   %r8,%r8
  6fe0d4:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fe0d9:	74 21                	je     6fe0fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xafc>
  6fe0db:	45 31 c9             	xor    %r9d,%r9d
  6fe0de:	42 8b 14 89          	mov    (%rcx,%r9,4),%edx
  6fe0e2:	83 e2 03             	and    $0x3,%edx
  6fe0e5:	83 fa 03             	cmp    $0x3,%edx
  6fe0e8:	0f 95 c2             	setne  %dl
  6fe0eb:	40 0f 94 c6          	sete   %sil
  6fe0ef:	40 08 f7             	or     %sil,%dil
  6fe0f2:	08 d0                	or     %dl,%al
  6fe0f4:	49 ff c1             	inc    %r9
  6fe0f7:	4d 39 c8             	cmp    %r9,%r8
  6fe0fa:	75 e2                	jne    6fe0de <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xade>
  6fe0fc:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  6fe103:	4e 8b 44 2d f8       	mov    -0x8(%rbp,%r13,1),%r8
  6fe108:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fe10f:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  6fe116:	40 0f b6 cf          	movzbl %dil,%ecx
  6fe11a:	83 e1 01             	and    $0x1,%ecx
  6fe11d:	89 0c 24             	mov    %ecx,(%rsp)
  6fe120:	44 0f b6 c8          	movzbl %al,%r9d
  6fe124:	41 83 e1 01          	and    $0x1,%r9d
  6fe128:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fe12d:	4c 89 f9             	mov    %r15,%rcx
  6fe130:	e8 3b 60 05 00       	call   754170 <<gpui::source::Sources<unit_action_cost_two::Model>>::freeze>
  6fe135:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  6fe13a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  6fe13f:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6fe146:	00 
  6fe147:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  6fe14e:	00 
  6fe14f:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fe154:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  6fe159:	48 83 f9 fd          	cmp    $0xfffffffffffffffd,%rcx
  6fe15d:	75 1d                	jne    6fe17c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xb7c>
  6fe15f:	48 89 c5             	mov    %rax,%rbp
  6fe162:	48 c1 ed 08          	shr    $0x8,%rbp
  6fe166:	b9 20 00 00 00       	mov    $0x20,%ecx
  6fe16b:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fe170:	89 c7                	mov    %eax,%edi
  6fe172:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  6fe177:	e9 bb 0f 00 00       	jmp    6ff137 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  6fe17c:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6fe181:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6fe188:	00 
  6fe189:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  6fe190:	00 
  6fe191:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6fe198:	00 00 
  6fe19a:	66 0f 7f 84 24 40 03 	movdqa %xmm0,0x340(%rsp)
  6fe1a1:	00 00 
  6fe1a3:	48 83 7c 24 08 ff    	cmpq   $0xffffffffffffffff,0x8(%rsp)
  6fe1a9:	0f 84 69 0c 00 00    	je     6fee18 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1818>
  6fe1af:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fe1b4:	48 85 c0             	test   %rax,%rax
  6fe1b7:	0f 84 5b 0c 00 00    	je     6fee18 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1818>
  6fe1bd:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  6fe1c2:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fe1c7:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fe1cc:	48 c1 e0 02          	shl    $0x2,%rax
  6fe1d0:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fe1d5:	8b 44 24 18          	mov    0x18(%rsp),%eax
  6fe1d9:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  6fe1e0:	00 
  6fe1e1:	45 31 e4             	xor    %r12d,%r12d
  6fe1e4:	48 83 f8 02          	cmp    $0x2,%rax
  6fe1e8:	0f 85 72 0b 00 00    	jne    6fed60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1760>
  6fe1ee:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fe1f3:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  6fe1f7:	ff 15 ab 9e 42 00    	call   *0x429eab(%rip)        # b280a8 <_DYNAMIC+0x3f0>
  6fe1fd:	66 85 c0             	test   %ax,%ax
  6fe200:	0f 85 ba 12 00 00    	jne    6ff4c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ec0>
  6fe206:	49 83 c4 04          	add    $0x4,%r12
  6fe20a:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  6fe20f:	75 dd                	jne    6fe1ee <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xbee>
  6fe211:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  6fe216:	48 85 c0             	test   %rax,%rax
  6fe219:	0f 84 dd 0d 00 00    	je     6feffc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x19fc>
  6fe21f:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  6fe224:	48 89 8c 24 48 01 00 	mov    %rcx,0x148(%rsp)
  6fe22b:	00 
  6fe22c:	48 c1 e0 02          	shl    $0x2,%rax
  6fe230:	f3 0f 7e 44 24 30    	movq   0x30(%rsp),%xmm0
  6fe236:	66 0f 6f 0d 22 c4 95 	movdqa -0x6a3bde(%rip),%xmm1        # 5a660 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x9f0>
  6fe23d:	ff 
  6fe23e:	66 0f 6c c8          	punpcklqdq %xmm0,%xmm1
  6fe242:	66 0f 7f 8c 24 b0 03 	movdqa %xmm1,0x3b0(%rsp)
  6fe249:	00 00 
  6fe24b:	48 c7 84 24 d0 00 00 	movq   $0x0,0xd0(%rsp)
  6fe252:	00 00 00 00 00 
  6fe257:	48 8d 0d 62 bf 3f 00 	lea    0x3fbf62(%rip),%rcx        # afa1c0 <__frame_dummy_init_array_entry+0xc98>
  6fe25e:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6fe263:	48 b9 00 00 00 00 00 	movabs $0x8000000000000000,%rcx
  6fe26a:	00 00 80 
  6fe26d:	48 ff c1             	inc    %rcx
  6fe270:	48 89 8c 24 38 01 00 	mov    %rcx,0x138(%rsp)
  6fe277:	00 
  6fe278:	48 8d 0d 25 c3 96 ff 	lea    -0x693cdb(%rip),%rcx        # 6a5a4 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34b7>
  6fe27f:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  6fe286:	00 
  6fe287:	48 8d 0d c2 bf 3f 00 	lea    0x3fbfc2(%rip),%rcx        # afa250 <__frame_dummy_init_array_entry+0xd28>
  6fe28e:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  6fe295:	00 
  6fe296:	48 8d 0d 3b bf 3f 00 	lea    0x3fbf3b(%rip),%rcx        # afa1d8 <__frame_dummy_init_array_entry+0xcb0>
  6fe29d:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  6fe2a4:	00 
  6fe2a5:	48 8d 0d cf c2 96 ff 	lea    -0x693d31(%rip),%rcx        # 6a57b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x348e>
  6fe2ac:	48 89 8c 24 e0 00 00 	mov    %rcx,0xe0(%rsp)
  6fe2b3:	00 
  6fe2b4:	48 8d 0d ed b3 3f 00 	lea    0x3fb3ed(%rip),%rcx        # af96a8 <__frame_dummy_init_array_entry+0x180>
  6fe2bb:	48 89 8c 24 b8 01 00 	mov    %rcx,0x1b8(%rsp)
  6fe2c2:	00 
  6fe2c3:	31 c9                	xor    %ecx,%ecx
  6fe2c5:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  6fe2cc:	00 00 00 00 00 
  6fe2d1:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  6fe2d8:	00 00 00 00 00 
  6fe2dd:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fe2e4:	00 00 
  6fe2e6:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fe2eb:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6fe2f2:	00 
  6fe2f3:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  6fe2f8:	8b 2c 08             	mov    (%rax,%rcx,1),%ebp
  6fe2fb:	49 ff 86 c0 06 00 00 	incq   0x6c0(%r14)
  6fe302:	89 e8                	mov    %ebp,%eax
  6fe304:	c1 e8 0f             	shr    $0xf,%eax
  6fe307:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fe30e:	48 39 c6             	cmp    %rax,%rsi
  6fe311:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6fe316:	0f 86 7c 11 00 00    	jbe    6ff498 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e98>
  6fe31c:	4d 8b a6 98 02 00 00 	mov    0x298(%r14),%r12
  6fe323:	4c 8d 2c 80          	lea    (%rax,%rax,4),%r13
  6fe327:	4b 8b 04 ec          	mov    (%r12,%r13,8),%rax
  6fe32b:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  6fe330:	89 ef                	mov    %ebp,%edi
  6fe332:	ff 15 70 9d 42 00    	call   *0x429d70(%rip)        # b280a8 <_DYNAMIC+0x3f0>
  6fe338:	89 44 24 08          	mov    %eax,0x8(%rsp)
  6fe33c:	4b 8d 04 ec          	lea    (%r12,%r13,8),%rax
  6fe340:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6fe347:	00 
  6fe348:	8b 54 24 08          	mov    0x8(%rsp),%edx
  6fe34c:	66 85 d2             	test   %dx,%dx
  6fe34f:	0f 84 31 01 00 00    	je     6fe486 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xe86>
  6fe355:	83 bc 24 60 03 00 00 	cmpl   $0x2,0x360(%rsp)
  6fe35c:	02 
  6fe35d:	0f 84 6d 0f 00 00    	je     6ff2d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cd0>
  6fe363:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  6fe368:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  6fe36d:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  6fe374:	00 
  6fe375:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6fe37a:	48 89 41 10          	mov    %rax,0x10(%rcx)
  6fe37e:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  6fe385:	00 00 
  6fe387:	f3 0f 7f 01          	movdqu %xmm0,(%rcx)
  6fe38b:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fe392:	00 
  6fe393:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6fe398:	ff 15 12 9d 42 00    	call   *0x429d12(%rip)        # b280b0 <_DYNAMIC+0x3f8>
  6fe39e:	0f b6 84 24 60 01 00 	movzbl 0x160(%rsp),%eax
  6fe3a5:	00 
  6fe3a6:	3c ff                	cmp    $0xff,%al
  6fe3a8:	0f 84 10 0d 00 00    	je     6ff0be <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1abe>
  6fe3ae:	0f b7 8c 24 61 01 00 	movzwl 0x161(%rsp),%ecx
  6fe3b5:	00 
  6fe3b6:	8b 94 24 63 01 00 00 	mov    0x163(%rsp),%edx
  6fe3bd:	0f b6 b4 24 67 01 00 	movzbl 0x167(%rsp),%esi
  6fe3c4:	00 
  6fe3c5:	4c 8d 84 24 68 01 00 	lea    0x168(%rsp),%r8
  6fe3cc:	00 
  6fe3cd:	41 8b 78 10          	mov    0x10(%r8),%edi
  6fe3d1:	4c 8d 8c 24 7c 03 00 	lea    0x37c(%rsp),%r9
  6fe3d8:	00 
  6fe3d9:	41 89 79 10          	mov    %edi,0x10(%r9)
  6fe3dd:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
  6fe3e2:	f3 41 0f 7f 01       	movdqu %xmm0,(%r9)
  6fe3e7:	88 84 24 74 03 00 00 	mov    %al,0x374(%rsp)
  6fe3ee:	66 89 8c 24 75 03 00 	mov    %cx,0x375(%rsp)
  6fe3f5:	00 
  6fe3f6:	40 88 b4 24 7b 03 00 	mov    %sil,0x37b(%rsp)
  6fe3fd:	00 
  6fe3fe:	89 94 24 77 03 00 00 	mov    %edx,0x377(%rsp)
  6fe405:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  6fe409:	44 0f b7 e9          	movzwl %cx,%r13d
  6fe40d:	48 8d 05 6c c1 3f 00 	lea    0x3fc16c(%rip),%rax        # afa580 <__frame_dummy_init_array_entry+0x1058>
  6fe414:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6fe419:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  6fe41d:	0f 84 c7 00 00 00    	je     6fe4ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xeea>
  6fe423:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fe428:	49 8d b6 10 06 00 00 	lea    0x610(%r14),%rsi
  6fe42f:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6fe434:	4c 8d 84 24 74 03 00 	lea    0x374(%rsp),%r8
  6fe43b:	00 
  6fe43c:	ff 15 76 9c 42 00    	call   *0x429c76(%rip)        # b280b8 <_DYNAMIC+0x400>
  6fe442:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fe447:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6fe44c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fe450:	0f 85 ab 0d 00 00    	jne    6ff201 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c01>
  6fe456:	40 80 ff 01          	cmp    $0x1,%dil
  6fe45a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fe45f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fe464:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fe469:	0f 85 9e 08 00 00    	jne    6fed0d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x170d>
  6fe46f:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  6fe476:	01 
  6fe477:	b0 01                	mov    $0x1,%al
  6fe479:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fe480:	00 
  6fe481:	e9 4e 08 00 00       	jmp    6fecd4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16d4>
  6fe486:	48 83 7c 24 60 fe    	cmpq   $0xfffffffffffffffe,0x60(%rsp)
  6fe48c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fe491:	0f 84 59 0e 00 00    	je     6ff2f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cf0>
  6fe497:	83 e5 03             	and    $0x3,%ebp
  6fe49a:	8d 45 ff             	lea    -0x1(%rbp),%eax
  6fe49d:	83 f8 02             	cmp    $0x2,%eax
  6fe4a0:	0f 83 8a 00 00 00    	jae    6fe530 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf30>
  6fe4a6:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6fe4ad:	48 8b 38             	mov    (%rax),%rdi
  6fe4b0:	41 bc 2b 00 00 00    	mov    $0x2b,%r12d
  6fe4b6:	48 85 ff             	test   %rdi,%rdi
  6fe4b9:	0f 84 19 0e 00 00    	je     6ff2d8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cd8>
  6fe4bf:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fe4c4:	ff 15 f6 9b 42 00    	call   *0x429bf6(%rip)        # b280c0 <_DYNAMIC+0x408>
  6fe4ca:	48 85 c0             	test   %rax,%rax
  6fe4cd:	0f 84 05 0e 00 00    	je     6ff2d8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1cd8>
  6fe4d3:	83 fd 01             	cmp    $0x1,%ebp
  6fe4d6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fe4db:	0f 85 a6 00 00 00    	jne    6fe587 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf87>
  6fe4e1:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fe4e5:	e9 a1 00 00 00       	jmp    6fe58b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf8b>
  6fe4ea:	49 8d 86 00 02 00 00 	lea    0x200(%r14),%rax
  6fe4f1:	48 8b 00             	mov    (%rax),%rax
  6fe4f4:	48 8d 15 55 cc 95 ff 	lea    -0x6a33ab(%rip),%rdx        # 5b150 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x14e0>
  6fe4fb:	48 63 0c 82          	movslq (%rdx,%rax,4),%rcx
  6fe4ff:	48 01 d1             	add    %rdx,%rcx
  6fe502:	48 8d 05 17 d4 95 ff 	lea    -0x6a2be9(%rip),%rax        # 5b920 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  6fe509:	ff e1                	jmp    *%rcx
  6fe50b:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  6fe512:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  6fe517:	48 39 c6             	cmp    %rax,%rsi
  6fe51a:	0f 86 3a 0f 00 00    	jbe    6ff45a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e5a>
  6fe520:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6fe524:	49 03 86 10 02 00 00 	add    0x210(%r14),%rax
  6fe52b:	e9 4e 03 00 00       	jmp    6fe87e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x127e>
  6fe530:	85 ed                	test   %ebp,%ebp
  6fe532:	0f 85 18 0e 00 00    	jne    6ff350 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d50>
  6fe538:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fe53f:	00 
  6fe540:	8b 40 20             	mov    0x20(%rax),%eax
  6fe543:	89 c1                	mov    %eax,%ecx
  6fe545:	83 e1 07             	and    $0x7,%ecx
  6fe548:	83 f9 06             	cmp    $0x6,%ecx
  6fe54b:	74 74                	je     6fe5c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6fe54d:	c1 e8 03             	shr    $0x3,%eax
  6fe550:	74 6f                	je     6fe5c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6fe552:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fe559:	ff c8                	dec    %eax
  6fe55b:	48 39 c6             	cmp    %rax,%rsi
  6fe55e:	0f 86 23 0f 00 00    	jbe    6ff487 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e87>
  6fe564:	49 8b 8e b0 02 00 00 	mov    0x2b0(%r14),%rcx
  6fe56b:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6fe56f:	48 c1 e0 04          	shl    $0x4,%rax
  6fe573:	48 83 3c 01 fe       	cmpq   $0xfffffffffffffffe,(%rcx,%rax,1)
  6fe578:	0f 84 59 0e 00 00    	je     6ff3d7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1dd7>
  6fe57e:	48 01 c1             	add    %rax,%rcx
  6fe581:	48 8b 79 40          	mov    0x40(%rcx),%rdi
  6fe585:	eb 13                	jmp    6fe59a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xf9a>
  6fe587:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fe58b:	b0 01                	mov    $0x1,%al
  6fe58d:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  6fe594:	00 
  6fe595:	48 85 ff             	test   %rdi,%rdi
  6fe598:	74 27                	je     6fe5c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6fe59a:	48 8b 07             	mov    (%rdi),%rax
  6fe59d:	48 d1 e8             	shr    $1,%rax
  6fe5a0:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6fe5a5:	48 39 d0             	cmp    %rdx,%rax
  6fe5a8:	75 17                	jne    6fe5c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xfc1>
  6fe5aa:	48 83 c7 10          	add    $0x10,%rdi
  6fe5ae:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fe5b3:	ff 15 0f 9b 42 00    	call   *0x429b0f(%rip)        # b280c8 <bcmp@GLIBC_2.2.5>
  6fe5b9:	85 c0                	test   %eax,%eax
  6fe5bb:	0f 84 3a 06 00 00    	je     6febfb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x15fb>
  6fe5c1:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  6fe5c6:	4d 85 e4             	test   %r12,%r12
  6fe5c9:	75 6d                	jne    6fe638 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1038>
  6fe5cb:	4c 8d 25 be c8 95 ff 	lea    -0x6a3742(%rip),%r12        # 5ae90 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1220>
  6fe5d2:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  6fe5d7:	48 85 f6             	test   %rsi,%rsi
  6fe5da:	74 41                	je     6fe61d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x101d>
  6fe5dc:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6fe5e3:	00 00 
  6fe5e5:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fe5ea:	31 d2                	xor    %edx,%edx
  6fe5ec:	31 c9                	xor    %ecx,%ecx
  6fe5ee:	ff 15 dc 9a 42 00    	call   *0x429adc(%rip)        # b280d0 <_DYNAMIC+0x418>
  6fe5f4:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  6fe5f9:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  6fe5fd:	0f 85 6e 0e 00 00    	jne    6ff471 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e71>
  6fe603:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
  6fe608:	49 8d 7c 24 10       	lea    0x10(%r12),%rdi
  6fe60d:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fe612:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  6fe617:	ff 15 03 99 42 00    	call   *0x429903(%rip)        # b27f20 <memcpy@GLIBC_2.14>
  6fe61d:	f3 41 0f 6f 86 c8 06 	movdqu 0x6c8(%r14),%xmm0
  6fe624:	00 00 
  6fe626:	66 0f d4 84 24 b0 03 	paddq  0x3b0(%rsp),%xmm0
  6fe62d:	00 00 
  6fe62f:	f3 41 0f 7f 86 c8 06 	movdqu %xmm0,0x6c8(%r14)
  6fe636:	00 00 
  6fe638:	85 ed                	test   %ebp,%ebp
  6fe63a:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  6fe63f:	0f 84 b1 00 00 00    	je     6fe6f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10f6>
  6fe645:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  6fe64c:	48 8b 38             	mov    (%rax),%rdi
  6fe64f:	41 bd 2b 00 00 00    	mov    $0x2b,%r13d
  6fe655:	48 85 ff             	test   %rdi,%rdi
  6fe658:	0f 84 2e 0d 00 00    	je     6ff38c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d8c>
  6fe65e:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fe663:	ff 15 6f 9a 42 00    	call   *0x429a6f(%rip)        # b280d8 <_DYNAMIC+0x420>
  6fe669:	48 85 c0             	test   %rax,%rax
  6fe66c:	0f 84 1a 0d 00 00    	je     6ff38c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d8c>
  6fe672:	83 fd 01             	cmp    $0x1,%ebp
  6fe675:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fe67a:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fe67f:	0f 85 4d 01 00 00    	jne    6fe7d2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11d2>
  6fe685:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6fe68a:	48 85 c9             	test   %rcx,%rcx
  6fe68d:	74 2c                	je     6fe6bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6fe68f:	f6 01 01             	testb  $0x1,(%rcx)
  6fe692:	75 27                	jne    6fe6bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6fe694:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6fe698:	f6 c2 01             	test   $0x1,%dl
  6fe69b:	75 1e                	jne    6fe6bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6fe69d:	ba 02 00 00 00       	mov    $0x2,%edx
  6fe6a2:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6fe6a8:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6fe6af:	00 
  6fe6b0:	48 f7 da             	neg    %rdx
  6fe6b3:	71 06                	jno    6fe6bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10bb>
  6fe6b5:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6fe6bb:	48 89 c5             	mov    %rax,%rbp
  6fe6be:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fe6c2:	48 85 ff             	test   %rdi,%rdi
  6fe6c5:	74 1c                	je     6fe6e3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  6fe6c7:	f6 07 01             	testb  $0x1,(%rdi)
  6fe6ca:	75 17                	jne    6fe6e3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  6fe6cc:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fe6d0:	a8 01                	test   $0x1,%al
  6fe6d2:	75 0f                	jne    6fe6e3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  6fe6d4:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fe6d8:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fe6dd:	0f 84 50 06 00 00    	je     6fed33 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1733>
  6fe6e3:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fe6e8:	48 89 45 08          	mov    %rax,0x8(%rbp)
  6fe6ec:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fe6f1:	e9 de 05 00 00       	jmp    6fecd4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16d4>
  6fe6f6:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fe6fd:	00 
  6fe6fe:	8b 78 20             	mov    0x20(%rax),%edi
  6fe701:	89 f8                	mov    %edi,%eax
  6fe703:	83 e0 07             	and    $0x7,%eax
  6fe706:	41 bd 16 00 00 00    	mov    $0x16,%r13d
  6fe70c:	83 f8 06             	cmp    $0x6,%eax
  6fe70f:	0f 84 59 0c 00 00    	je     6ff36e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d6e>
  6fe715:	c1 ef 03             	shr    $0x3,%edi
  6fe718:	0f 84 50 0c 00 00    	je     6ff36e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d6e>
  6fe71e:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fe725:	ff cf                	dec    %edi
  6fe727:	48 39 fe             	cmp    %rdi,%rsi
  6fe72a:	0f 86 01 0d 00 00    	jbe    6ff431 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e31>
  6fe730:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6fe737:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  6fe73b:	48 c1 e0 04          	shl    $0x4,%rax
  6fe73f:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6fe745:	0f 84 5f 0c 00 00    	je     6ff3aa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1daa>
  6fe74b:	4d 85 e4             	test   %r12,%r12
  6fe74e:	0f 84 68 0c 00 00    	je     6ff3bc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1dbc>
  6fe754:	41 f6 04 24 01       	testb  $0x1,(%r12)
  6fe759:	75 2a                	jne    6fe785 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1185>
  6fe75b:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  6fe760:	f6 c1 01             	test   $0x1,%cl
  6fe763:	75 20                	jne    6fe785 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1185>
  6fe765:	b9 02 00 00 00       	mov    $0x2,%ecx
  6fe76a:	f0 49 0f c1 4c 24 08 	lock xadd %rcx,0x8(%r12)
  6fe771:	48 23 8c 24 38 01 00 	and    0x138(%rsp),%rcx
  6fe778:	00 
  6fe779:	48 f7 d9             	neg    %rcx
  6fe77c:	71 07                	jno    6fe785 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1185>
  6fe77e:	f0 49 83 4c 24 08 01 	lock orq $0x1,0x8(%r12)
  6fe785:	48 01 c5             	add    %rax,%rbp
  6fe788:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  6fe78c:	f6 07 01             	testb  $0x1,(%rdi)
  6fe78f:	75 17                	jne    6fe7a8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11a8>
  6fe791:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fe795:	a8 01                	test   $0x1,%al
  6fe797:	75 0f                	jne    6fe7a8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11a8>
  6fe799:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fe79d:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fe7a2:	0f 84 7c 05 00 00    	je     6fed24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1724>
  6fe7a8:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  6fe7ac:	48 89 ef             	mov    %rbp,%rdi
  6fe7af:	e8 ac 5c ff ff       	call   6f4460 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6fe7b4:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fe7bb:	ff 
  6fe7bc:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6fe7c3:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fe7c8:	e8 03 58 04 00       	call   743fd0 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6fe7cd:	e9 e1 04 00 00       	jmp    6fecb3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16b3>
  6fe7d2:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6fe7d7:	48 85 c9             	test   %rcx,%rcx
  6fe7da:	74 2c                	je     6fe808 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6fe7dc:	f6 01 01             	testb  $0x1,(%rcx)
  6fe7df:	75 27                	jne    6fe808 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6fe7e1:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  6fe7e5:	f6 c2 01             	test   $0x1,%dl
  6fe7e8:	75 1e                	jne    6fe808 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6fe7ea:	ba 02 00 00 00       	mov    $0x2,%edx
  6fe7ef:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  6fe7f5:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  6fe7fc:	00 
  6fe7fd:	48 f7 da             	neg    %rdx
  6fe800:	71 06                	jno    6fe808 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1208>
  6fe802:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  6fe808:	48 89 c5             	mov    %rax,%rbp
  6fe80b:	48 8b 78 10          	mov    0x10(%rax),%rdi
  6fe80f:	48 85 ff             	test   %rdi,%rdi
  6fe812:	74 1c                	je     6fe830 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  6fe814:	f6 07 01             	testb  $0x1,(%rdi)
  6fe817:	75 17                	jne    6fe830 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  6fe819:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fe81d:	a8 01                	test   $0x1,%al
  6fe81f:	75 0f                	jne    6fe830 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  6fe821:	48 8d 47 08          	lea    0x8(%rdi),%rax
  6fe825:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6fe82a:	0f 84 12 05 00 00    	je     6fed42 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1742>
  6fe830:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6fe835:	48 89 45 10          	mov    %rax,0x10(%rbp)
  6fe839:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fe83e:	e9 91 04 00 00       	jmp    6fecd4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16d4>
  6fe843:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  6fe84a:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  6fe84f:	48 39 ce             	cmp    %rcx,%rsi
  6fe852:	0f 86 eb 0b 00 00    	jbe    6ff443 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e43>
  6fe858:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  6fe85f:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  6fe866:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
  6fe86a:	48 39 c6             	cmp    %rax,%rsi
  6fe86d:	0f 86 d9 0b 00 00    	jbe    6ff44c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e4c>
  6fe873:	48 6b c0 58          	imul   $0x58,%rax,%rax
  6fe877:	49 03 86 08 02 00 00 	add    0x208(%r14),%rax
  6fe87e:	48 8b 48 50          	mov    0x50(%rax),%rcx
  6fe882:	48 89 8c 24 b0 02 00 	mov    %rcx,0x2b0(%rsp)
  6fe889:	00 
  6fe88a:	0f 10 40 40          	movups 0x40(%rax),%xmm0
  6fe88e:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
  6fe895:	00 
  6fe896:	f3 0f 6f 00          	movdqu (%rax),%xmm0
  6fe89a:	f3 0f 6f 48 10       	movdqu 0x10(%rax),%xmm1
  6fe89f:	0f 10 50 20          	movups 0x20(%rax),%xmm2
  6fe8a3:	0f 10 58 30          	movups 0x30(%rax),%xmm3
  6fe8a7:	0f 29 9c 24 90 02 00 	movaps %xmm3,0x290(%rsp)
  6fe8ae:	00 
  6fe8af:	0f 29 94 24 80 02 00 	movaps %xmm2,0x280(%rsp)
  6fe8b6:	00 
  6fe8b7:	66 0f 7f 8c 24 70 02 	movdqa %xmm1,0x270(%rsp)
  6fe8be:	00 00 
  6fe8c0:	66 0f 7f 84 24 60 02 	movdqa %xmm0,0x260(%rsp)
  6fe8c7:	00 00 
  6fe8c9:	eb 1a                	jmp    6fe8e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x12e5>
  6fe8cb:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  6fe8d2:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
  6fe8d9:	00 
  6fe8da:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  6fe8df:	ff 15 0b 97 42 00    	call   *0x42970b(%rip)        # b27ff0 <_DYNAMIC+0x338>
  6fe8e5:	48 8b 84 24 b0 02 00 	mov    0x2b0(%rsp),%rax
  6fe8ec:	00 
  6fe8ed:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  6fe8f4:	00 
  6fe8f5:	0f 28 84 24 a0 02 00 	movaps 0x2a0(%rsp),%xmm0
  6fe8fc:	00 
  6fe8fd:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  6fe904:	00 
  6fe905:	66 0f 6f 84 24 60 02 	movdqa 0x260(%rsp),%xmm0
  6fe90c:	00 00 
  6fe90e:	66 0f 6f 8c 24 70 02 	movdqa 0x270(%rsp),%xmm1
  6fe915:	00 00 
  6fe917:	0f 28 94 24 80 02 00 	movaps 0x280(%rsp),%xmm2
  6fe91e:	00 
  6fe91f:	0f 28 9c 24 90 02 00 	movaps 0x290(%rsp),%xmm3
  6fe926:	00 
  6fe927:	0f 29 9c 24 a0 00 00 	movaps %xmm3,0xa0(%rsp)
  6fe92e:	00 
  6fe92f:	0f 29 94 24 90 00 00 	movaps %xmm2,0x90(%rsp)
  6fe936:	00 
  6fe937:	66 0f 7f 8c 24 80 00 	movdqa %xmm1,0x80(%rsp)
  6fe93e:	00 00 
  6fe940:	66 0f 7f 44 24 70    	movdqa %xmm0,0x70(%rsp)
  6fe946:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fe94d:	00 
  6fe94e:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  6fe955:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6fe95a:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  6fe95f:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  6fe964:	4c 8d 8c 24 74 03 00 	lea    0x374(%rsp),%r9
  6fe96b:	00 
  6fe96c:	e8 8f 80 05 00       	call   756a00 <<gpui::property::Overrides>::update_base>
  6fe971:	8b 84 24 60 01 00 00 	mov    0x160(%rsp),%eax
  6fe978:	8b 8c 24 65 01 00 00 	mov    0x165(%rsp),%ecx
  6fe97f:	0f b6 ac 24 69 01 00 	movzbl 0x169(%rsp),%ebp
  6fe986:	00 
  6fe987:	48 c1 e5 20          	shl    $0x20,%rbp
  6fe98b:	48 09 cd             	or     %rcx,%rbp
  6fe98e:	0f b6 bc 24 64 01 00 	movzbl 0x164(%rsp),%edi
  6fe995:	00 
  6fe996:	83 f8 02             	cmp    $0x2,%eax
  6fe999:	0f 84 ba 08 00 00    	je     6ff259 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c59>
  6fe99f:	48 8d 8c 24 68 01 00 	lea    0x168(%rsp),%rcx
  6fe9a6:	00 
  6fe9a7:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  6fe9ab:	48 8d 94 24 ca 01 00 	lea    0x1ca(%rsp),%rdx
  6fe9b2:	00 
  6fe9b3:	0f 11 42 3e          	movups %xmm0,0x3e(%rdx)
  6fe9b7:	0f 10 41 02          	movups 0x2(%rcx),%xmm0
  6fe9bb:	0f 10 49 12          	movups 0x12(%rcx),%xmm1
  6fe9bf:	0f 10 51 22          	movups 0x22(%rcx),%xmm2
  6fe9c3:	0f 10 59 32          	movups 0x32(%rcx),%xmm3
  6fe9c7:	0f 11 5a 30          	movups %xmm3,0x30(%rdx)
  6fe9cb:	0f 11 52 20          	movups %xmm2,0x20(%rdx)
  6fe9cf:	0f 11 4a 10          	movups %xmm1,0x10(%rdx)
  6fe9d3:	0f 11 02             	movups %xmm0,(%rdx)
  6fe9d6:	89 84 24 c0 01 00 00 	mov    %eax,0x1c0(%rsp)
  6fe9dd:	40 88 bc 24 c4 01 00 	mov    %dil,0x1c4(%rsp)
  6fe9e4:	00 
  6fe9e5:	48 89 e8             	mov    %rbp,%rax
  6fe9e8:	48 c1 e8 20          	shr    $0x20,%rax
  6fe9ec:	88 84 24 c9 01 00 00 	mov    %al,0x1c9(%rsp)
  6fe9f3:	89 ac 24 c5 01 00 00 	mov    %ebp,0x1c5(%rsp)
  6fe9fa:	f3 0f 6f 84 24 d0 01 	movdqu 0x1d0(%rsp),%xmm0
  6fea01:	00 00 
  6fea03:	f3 0f 6f 8c 24 e0 01 	movdqu 0x1e0(%rsp),%xmm1
  6fea0a:	00 00 
  6fea0c:	0f 10 94 24 f0 01 00 	movups 0x1f0(%rsp),%xmm2
  6fea13:	00 
  6fea14:	0f 10 9c 24 00 02 00 	movups 0x200(%rsp),%xmm3
  6fea1b:	00 
  6fea1c:	66 0f 7f 84 24 d0 02 	movdqa %xmm0,0x2d0(%rsp)
  6fea23:	00 00 
  6fea25:	66 0f 7f 8c 24 e0 02 	movdqa %xmm1,0x2e0(%rsp)
  6fea2c:	00 00 
  6fea2e:	0f 29 94 24 f0 02 00 	movaps %xmm2,0x2f0(%rsp)
  6fea35:	00 
  6fea36:	0f 29 9c 24 00 03 00 	movaps %xmm3,0x300(%rsp)
  6fea3d:	00 
  6fea3e:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  6fea45:	00 
  6fea46:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  6fea4d:	00 
  6fea4e:	8b 84 24 c0 01 00 00 	mov    0x1c0(%rsp),%eax
  6fea55:	89 84 24 c0 02 00 00 	mov    %eax,0x2c0(%rsp)
  6fea5c:	0f b6 84 24 c4 01 00 	movzbl 0x1c4(%rsp),%eax
  6fea63:	00 
  6fea64:	88 84 24 c4 02 00 00 	mov    %al,0x2c4(%rsp)
  6fea6b:	8b 84 24 c5 01 00 00 	mov    0x1c5(%rsp),%eax
  6fea72:	89 84 24 c5 02 00 00 	mov    %eax,0x2c5(%rsp)
  6fea79:	0f b6 84 24 c9 01 00 	movzbl 0x1c9(%rsp),%eax
  6fea80:	00 
  6fea81:	88 84 24 c9 02 00 00 	mov    %al,0x2c9(%rsp)
  6fea88:	8b 84 24 ca 01 00 00 	mov    0x1ca(%rsp),%eax
  6fea8f:	89 84 24 ca 02 00 00 	mov    %eax,0x2ca(%rsp)
  6fea96:	0f b7 84 24 ce 01 00 	movzwl 0x1ce(%rsp),%eax
  6fea9d:	00 
  6fea9e:	66 89 84 24 ce 02 00 	mov    %ax,0x2ce(%rsp)
  6feaa5:	00 
  6feaa6:	0f b6 84 24 c0 02 00 	movzbl 0x2c0(%rsp),%eax
  6feaad:	00 
  6feaae:	83 bc 24 60 02 00 00 	cmpl   $0x1,0x260(%rsp)
  6feab5:	01 
  6feab6:	75 1a                	jne    6fead2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x14d2>
  6feab8:	8b 8c 24 c4 02 00 00 	mov    0x2c4(%rsp),%ecx
  6feabf:	39 8c 24 64 02 00 00 	cmp    %ecx,0x264(%rsp)
  6feac6:	0f 94 c1             	sete   %cl
  6feac9:	84 c8                	test   %cl,%al
  6feacb:	75 0d                	jne    6feada <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x14da>
  6feacd:	e9 38 01 00 00       	jmp    6fec0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6fead2:	a8 01                	test   $0x1,%al
  6fead4:	0f 85 30 01 00 00    	jne    6fec0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6feada:	0f b6 84 24 c8 02 00 	movzbl 0x2c8(%rsp),%eax
  6feae1:	00 
  6feae2:	83 bc 24 68 02 00 00 	cmpl   $0x1,0x268(%rsp)
  6feae9:	01 
  6feaea:	75 1b                	jne    6feb07 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1507>
  6feaec:	8b 8c 24 cc 02 00 00 	mov    0x2cc(%rsp),%ecx
  6feaf3:	39 8c 24 6c 02 00 00 	cmp    %ecx,0x26c(%rsp)
  6feafa:	0f 94 c1             	sete   %cl
  6feafd:	84 c8                	test   %cl,%al
  6feaff:	0f 84 05 01 00 00    	je     6fec0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6feb05:	eb 08                	jmp    6feb0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x150f>
  6feb07:	a8 01                	test   $0x1,%al
  6feb09:	0f 85 fb 00 00 00    	jne    6fec0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6feb0f:	8b 84 24 70 02 00 00 	mov    0x270(%rsp),%eax
  6feb16:	3b 84 24 d0 02 00 00 	cmp    0x2d0(%rsp),%eax
  6feb1d:	0f 85 e7 00 00 00    	jne    6fec0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6feb23:	8b 84 24 74 02 00 00 	mov    0x274(%rsp),%eax
  6feb2a:	3b 84 24 d4 02 00 00 	cmp    0x2d4(%rsp),%eax
  6feb31:	0f 85 d3 00 00 00    	jne    6fec0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6feb37:	8b 84 24 78 02 00 00 	mov    0x278(%rsp),%eax
  6feb3e:	3b 84 24 d8 02 00 00 	cmp    0x2d8(%rsp),%eax
  6feb45:	0f 85 bf 00 00 00    	jne    6fec0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6feb4b:	0f b6 84 24 b4 02 00 	movzbl 0x2b4(%rsp),%eax
  6feb52:	00 
  6feb53:	3a 84 24 14 03 00 00 	cmp    0x314(%rsp),%al
  6feb5a:	0f 85 aa 00 00 00    	jne    6fec0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6feb60:	0f b6 84 24 b6 02 00 	movzbl 0x2b6(%rsp),%eax
  6feb67:	00 
  6feb68:	3a 84 24 16 03 00 00 	cmp    0x316(%rsp),%al
  6feb6f:	0f 85 95 00 00 00    	jne    6fec0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6feb75:	0f b6 84 24 b7 02 00 	movzbl 0x2b7(%rsp),%eax
  6feb7c:	00 
  6feb7d:	3a 84 24 17 03 00 00 	cmp    0x317(%rsp),%al
  6feb84:	0f 85 80 00 00 00    	jne    6fec0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6feb8a:	0f b6 84 24 b5 02 00 	movzbl 0x2b5(%rsp),%eax
  6feb91:	00 
  6feb92:	3a 84 24 15 03 00 00 	cmp    0x315(%rsp),%al
  6feb99:	75 6f                	jne    6fec0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6feb9b:	48 8d bc 24 9c 02 00 	lea    0x29c(%rsp),%rdi
  6feba2:	00 
  6feba3:	48 8d b4 24 fc 02 00 	lea    0x2fc(%rsp),%rsi
  6febaa:	00 
  6febab:	e8 40 bf 02 00       	call   72aaf0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  6febb0:	84 c0                	test   %al,%al
  6febb2:	74 56                	je     6fec0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6febb4:	f3 0f 6f 84 24 7c 02 	movdqu 0x27c(%rsp),%xmm0
  6febbb:	00 00 
  6febbd:	f3 0f 6f 8c 24 dc 02 	movdqu 0x2dc(%rsp),%xmm1
  6febc4:	00 00 
  6febc6:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6febca:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6febce:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6febd3:	75 35                	jne    6fec0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6febd5:	f3 0f 6f 84 24 8c 02 	movdqu 0x28c(%rsp),%xmm0
  6febdc:	00 00 
  6febde:	f3 0f 6f 8c 24 ec 02 	movdqu 0x2ec(%rsp),%xmm1
  6febe5:	00 00 
  6febe7:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  6febeb:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  6febef:	3d ff ff 00 00       	cmp    $0xffff,%eax
  6febf4:	75 14                	jne    6fec0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x160a>
  6febf6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6febfb:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fec00:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6fec05:	e9 08 01 00 00       	jmp    6fed12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1712>
  6fec0a:	48 8d 05 6f b9 3f 00 	lea    0x3fb96f(%rip),%rax        # afa580 <__frame_dummy_init_array_entry+0x1058>
  6fec11:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  6fec16:	80 78 13 02          	cmpb   $0x2,0x13(%rax)
  6fec1a:	75 11                	jne    6fec2d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x162d>
  6fec1c:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  6fec23:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  6fec28:	e8 a3 53 04 00       	call   743fd0 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  6fec2d:	66 83 7c 24 08 05    	cmpw   $0x5,0x8(%rsp)
  6fec33:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  6fec38:	75 5a                	jne    6fec94 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1694>
  6fec3a:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fec41:	00 
  6fec42:	8b 40 20             	mov    0x20(%rax),%eax
  6fec45:	89 c1                	mov    %eax,%ecx
  6fec47:	83 e1 07             	and    $0x7,%ecx
  6fec4a:	83 f9 06             	cmp    $0x6,%ecx
  6fec4d:	74 45                	je     6fec94 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1694>
  6fec4f:	c1 e8 03             	shr    $0x3,%eax
  6fec52:	74 40                	je     6fec94 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1694>
  6fec54:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  6fec5b:	ff c8                	dec    %eax
  6fec5d:	48 39 c6             	cmp    %rax,%rsi
  6fec60:	0f 86 fd 07 00 00    	jbe    6ff463 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e63>
  6fec66:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  6fec6d:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  6fec71:	48 c1 e0 04          	shl    $0x4,%rax
  6fec75:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  6fec7b:	0f 84 65 07 00 00    	je     6ff3e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1de6>
  6fec81:	48 01 c5             	add    %rax,%rbp
  6fec84:	48 89 ef             	mov    %rbp,%rdi
  6fec87:	e8 d4 57 ff ff       	call   6f4460 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  6fec8c:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6fec93:	ff 
  6fec94:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  6fec9b:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  6feca2:	4c 89 e6             	mov    %r12,%rsi
  6feca5:	48 8d 94 24 c0 01 00 	lea    0x1c0(%rsp),%rdx
  6fecac:	00 
  6fecad:	ff 15 2d 94 42 00    	call   *0x42942d(%rip)        # b280e0 <_DYNAMIC+0x428>
  6fecb3:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  6fecba:	01 
  6fecbb:	b0 01                	mov    $0x1,%al
  6fecbd:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fecc4:	00 
  6fecc5:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fecca:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  6feccf:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  6fecd4:	4c 39 ac 24 50 01 00 	cmp    %r13,0x150(%rsp)
  6fecdb:	00 
  6fecdc:	0f 94 c0             	sete   %al
  6fecdf:	84 84 24 d0 00 00 00 	test   %al,0xd0(%rsp)
  6fece6:	74 0c                	je     6fecf4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x16f4>
  6fece8:	b0 01                	mov    $0x1,%al
  6fecea:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fecf1:	00 
  6fecf2:	eb 19                	jmp    6fed0d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x170d>
  6fecf4:	49 ff 86 08 07 00 00 	incq   0x708(%r14)
  6fecfb:	b0 01                	mov    $0x1,%al
  6fecfd:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fed04:	00 
  6fed05:	4c 89 ac 24 50 01 00 	mov    %r13,0x150(%rsp)
  6fed0c:	00 
  6fed0d:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fed12:	48 83 c1 04          	add    $0x4,%rcx
  6fed16:	48 39 c8             	cmp    %rcx,%rax
  6fed19:	0f 85 cc f5 ff ff    	jne    6fe2eb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xceb>
  6fed1f:	e9 ee 02 00 00       	jmp    6ff012 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a12>
  6fed24:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fed28:	ff 15 0a 92 42 00    	call   *0x42920a(%rip)        # b27f38 <_DYNAMIC+0x280>
  6fed2e:	e9 75 fa ff ff       	jmp    6fe7a8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x11a8>
  6fed33:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fed37:	ff 15 fb 91 42 00    	call   *0x4291fb(%rip)        # b27f38 <_DYNAMIC+0x280>
  6fed3d:	e9 a1 f9 ff ff       	jmp    6fe6e3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x10e3>
  6fed42:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6fed46:	ff 15 ec 91 42 00    	call   *0x4291ec(%rip)        # b27f38 <_DYNAMIC+0x280>
  6fed4c:	e9 df fa ff ff       	jmp    6fe830 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1230>
  6fed51:	49 83 c4 04          	add    $0x4,%r12
  6fed55:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  6fed5a:	0f 84 b1 f4 ff ff    	je     6fe211 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xc11>
  6fed60:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fed65:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  6fed69:	ff 15 39 93 42 00    	call   *0x429339(%rip)        # b280a8 <_DYNAMIC+0x3f0>
  6fed6f:	66 85 c0             	test   %ax,%ax
  6fed72:	74 dd                	je     6fed51 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1751>
  6fed74:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  6fed79:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  6fed7e:	48 8b 8c 24 50 03 00 	mov    0x350(%rsp),%rcx
  6fed85:	00 
  6fed86:	48 8d 54 24 78       	lea    0x78(%rsp),%rdx
  6fed8b:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
  6fed8f:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  6fed96:	00 00 
  6fed98:	f3 0f 7f 02          	movdqu %xmm0,(%rdx)
  6fed9c:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6feda3:	00 
  6feda4:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  6feda9:	89 c2                	mov    %eax,%edx
  6fedab:	ff 15 ff 92 42 00    	call   *0x4292ff(%rip)        # b280b0 <_DYNAMIC+0x3f8>
  6fedb1:	80 bc 24 60 01 00 00 	cmpb   $0xff,0x160(%rsp)
  6fedb8:	ff 
  6fedb9:	75 96                	jne    6fed51 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1751>
  6fedbb:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6fedc2:	00 
  6fedc3:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6fedca:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6fedd1:	00 
  6fedd2:	48 c1 e5 20          	shl    $0x20,%rbp
  6fedd6:	48 09 c5             	or     %rax,%rbp
  6fedd9:	b8 24 00 00 00       	mov    $0x24,%eax
  6fedde:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fede3:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6fede8:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6feded:	48 85 f6             	test   %rsi,%rsi
  6fedf0:	0f 8e 12 02 00 00    	jle    6ff008 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a08>
  6fedf6:	ba 01 00 00 00       	mov    $0x1,%edx
  6fedfb:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6fedff:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fee04:	ff 15 f6 90 42 00    	call   *0x4290f6(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fee0a:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6fee0e:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6fee13:	e9 1f 03 00 00       	jmp    6ff137 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  6fee18:	31 ff                	xor    %edi,%edi
  6fee1a:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6fee1f:	48 85 f6             	test   %rsi,%rsi
  6fee22:	7e 5c                	jle    6fee80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1880>
  6fee24:	ba 01 00 00 00       	mov    $0x1,%edx
  6fee29:	89 fd                	mov    %edi,%ebp
  6fee2b:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fee30:	ff 15 ca 90 42 00    	call   *0x4290ca(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fee36:	89 ef                	mov    %ebp,%edi
  6fee38:	eb 46                	jmp    6fee80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1880>
  6fee3a:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6fee41:	00 
  6fee42:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6fee49:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6fee50:	00 
  6fee51:	48 c1 e5 20          	shl    $0x20,%rbp
  6fee55:	48 09 c5             	or     %rax,%rbp
  6fee58:	b8 24 00 00 00       	mov    $0x24,%eax
  6fee5d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fee62:	e9 99 02 00 00       	jmp    6ff100 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  6fee67:	b0 01                	mov    $0x1,%al
  6fee69:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  6fee6e:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  6fee75:	48 85 ed             	test   %rbp,%rbp
  6fee78:	0f 85 0e ef ff ff    	jne    6fdd8c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x78c>
  6fee7e:	31 ff                	xor    %edi,%edi
  6fee80:	80 7c 24 40 00       	cmpb   $0x0,0x40(%rsp)
  6fee85:	74 3c                	je     6feec3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x18c3>
  6fee87:	41 80 be 1f 07 00 00 	cmpb   $0x1,0x71f(%r14)
  6fee8e:	01 
  6fee8f:	75 32                	jne    6feec3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x18c3>
  6fee91:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fee96:	4c 89 f6             	mov    %r14,%rsi
  6fee99:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  6feea0:	00 
  6feea1:	31 c9                	xor    %ecx,%ecx
  6feea3:	e8 c8 de ff ff       	call   6fcd70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>
  6feea8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6feead:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6feeb1:	75 1e                	jne    6feed1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x18d1>
  6feeb3:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6feeba:	ff ff 
  6feebc:	31 ff                	xor    %edi,%edi
  6feebe:	e9 94 02 00 00       	jmp    6ff157 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b57>
  6feec3:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6feeca:	ff ff 
  6feecc:	e9 86 02 00 00       	jmp    6ff157 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b57>
  6feed1:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6feed6:	0f b6 4c 24 7f       	movzbl 0x7f(%rsp),%ecx
  6feedb:	c1 e1 10             	shl    $0x10,%ecx
  6feede:	0f b7 54 24 7d       	movzwl 0x7d(%rsp),%edx
  6feee3:	09 ca                	or     %ecx,%edx
  6feee5:	48 c1 e2 20          	shl    $0x20,%rdx
  6feee9:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6feeed:	48 09 d5             	or     %rdx,%rbp
  6feef0:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6feef7:	00 
  6feef8:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6feeff:	00 
  6fef00:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6fef07:	00 00 
  6fef09:	66 0f 7f 84 24 c0 01 	movdqa %xmm0,0x1c0(%rsp)
  6fef10:	00 00 
  6fef12:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  6fef19:	00 
  6fef1a:	48 89 8c 24 d0 01 00 	mov    %rcx,0x1d0(%rsp)
  6fef21:	00 
  6fef22:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fef27:	e9 2b 02 00 00       	jmp    6ff157 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b57>
  6fef2c:	b8 20 00 00 00       	mov    $0x20,%eax
  6fef31:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fef36:	40 b7 0c             	mov    $0xc,%dil
  6fef39:	31 ed                	xor    %ebp,%ebp
  6fef3b:	4d 89 f8             	mov    %r15,%r8
  6fef3e:	e9 bd 01 00 00       	jmp    6ff100 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  6fef43:	49 8b 86 90 06 00 00 	mov    0x690(%r14),%rax
  6fef4a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  6fef4e:	49 3b 8e 60 06 00 00 	cmp    0x660(%r14),%rcx
  6fef55:	40 0f 94 c5          	sete   %bpl
  6fef59:	48 ff c0             	inc    %rax
  6fef5c:	0f 84 d5 f0 ff ff    	je     6fe037 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0xa37>
  6fef62:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  6fef69:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  6fef70:	00 
  6fef71:	48 8d 8c 24 60 02 00 	lea    0x260(%rsp),%rcx
  6fef78:	00 
  6fef79:	ff 15 69 91 42 00    	call   *0x429169(%rip)        # b280e8 <_DYNAMIC+0x430>
  6fef7f:	80 bc 24 60 01 00 00 	cmpb   $0x0,0x160(%rsp)
  6fef86:	00 
  6fef87:	74 21                	je     6fefaa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x19aa>
  6fef89:	8b 94 24 84 01 00 00 	mov    0x184(%rsp),%edx
  6fef90:	49 89 96 08 07 00 00 	mov    %rdx,0x708(%r14)
  6fef97:	40 84 ed             	test   %bpl,%bpl
  6fef9a:	0f 84 48 01 00 00    	je     6ff0e8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ae8>
  6fefa0:	48 8d 94 24 64 01 00 	lea    0x164(%rsp),%rdx
  6fefa7:	00 
  6fefa8:	eb 16                	jmp    6fefc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x19c0>
  6fefaa:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fefb1:	00 00 00 00 
  6fefb5:	31 d2                	xor    %edx,%edx
  6fefb7:	40 84 ed             	test   %bpl,%bpl
  6fefba:	0f 84 28 01 00 00    	je     6ff0e8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ae8>
  6fefc0:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  6fefc5:	4c 89 f6             	mov    %r14,%rsi
  6fefc8:	e8 e3 0a 00 00       	call   6ffab0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::finish_color_slot>
  6fefcd:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  6fefd2:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  6fefd7:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fefdb:	0f 85 8c 00 00 00    	jne    6ff06d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a6d>
  6fefe1:	40 f6 c7 01          	test   $0x1,%dil
  6fefe5:	0f 84 f6 00 00 00    	je     6ff0e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ae1>
  6fefeb:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6feff2:	ff ff 
  6feff4:	40 b7 02             	mov    $0x2,%dil
  6feff7:	e9 04 01 00 00       	jmp    6ff100 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  6feffc:	31 ff                	xor    %edi,%edi
  6feffe:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff003:	e9 12 fe ff ff       	jmp    6fee1a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  6ff008:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6ff00d:	e9 25 01 00 00       	jmp    6ff137 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b37>
  6ff012:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  6ff019:	00 
  6ff01a:	34 01                	xor    $0x1,%al
  6ff01c:	0f b6 c0             	movzbl %al,%eax
  6ff01f:	31 ff                	xor    %edi,%edi
  6ff021:	f6 84 24 40 01 00 00 	testb  $0x1,0x140(%rsp)
  6ff028:	01 
  6ff029:	0f 45 f8             	cmovne %eax,%edi
  6ff02c:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6ff031:	48 85 c0             	test   %rax,%rax
  6ff034:	0f 84 e0 fd ff ff    	je     6fee1a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  6ff03a:	f6 00 01             	testb  $0x1,(%rax)
  6ff03d:	0f 85 d7 fd ff ff    	jne    6fee1a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  6ff043:	89 fd                	mov    %edi,%ebp
  6ff045:	48 8b 40 08          	mov    0x8(%rax),%rax
  6ff049:	a8 01                	test   $0x1,%al
  6ff04b:	75 14                	jne    6ff061 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1a61>
  6ff04d:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6ff052:	48 83 c0 08          	add    $0x8,%rax
  6ff056:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6ff05b:	0f 84 b5 03 00 00    	je     6ff416 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e16>
  6ff061:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff066:	89 ef                	mov    %ebp,%edi
  6ff068:	e9 ad fd ff ff       	jmp    6fee1a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  6ff06d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6ff072:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  6ff077:	c1 e0 10             	shl    $0x10,%eax
  6ff07a:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  6ff07f:	09 c1                	or     %eax,%ecx
  6ff081:	48 c1 e1 20          	shl    $0x20,%rcx
  6ff085:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6ff089:	48 09 cd             	or     %rcx,%rbp
  6ff08c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  6ff093:	00 
  6ff094:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6ff09b:	00 
  6ff09c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  6ff0a3:	00 
  6ff0a4:	0f 29 84 24 20 03 00 	movaps %xmm0,0x320(%rsp)
  6ff0ab:	00 
  6ff0ac:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6ff0b3:	00 
  6ff0b4:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  6ff0bb:	00 
  6ff0bc:	eb 42                	jmp    6ff100 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b00>
  6ff0be:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  6ff0c5:	00 
  6ff0c6:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  6ff0cd:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  6ff0d4:	00 
  6ff0d5:	48 c1 e5 20          	shl    $0x20,%rbp
  6ff0d9:	48 09 c5             	or     %rax,%rbp
  6ff0dc:	e9 85 01 00 00       	jmp    6ff266 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c66>
  6ff0e1:	49 8b 96 08 07 00 00 	mov    0x708(%r14),%rdx
  6ff0e8:	48 85 d2             	test   %rdx,%rdx
  6ff0eb:	0f 95 c0             	setne  %al
  6ff0ee:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  6ff0f5:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  6ff0fc:	ff ff 
  6ff0fe:	31 ff                	xor    %edi,%edi
  6ff100:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  6ff105:	48 85 f6             	test   %rsi,%rsi
  6ff108:	7e 22                	jle    6ff12c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1b2c>
  6ff10a:	ba 01 00 00 00       	mov    $0x1,%edx
  6ff10f:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  6ff114:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6ff118:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6ff11d:	ff 15 dd 8d 42 00    	call   *0x428ddd(%rip)        # b27f00 <_DYNAMIC+0x248>
  6ff123:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6ff127:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  6ff12c:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  6ff131:	0f 84 49 fd ff ff    	je     6fee80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1880>
  6ff137:	48 8b 84 24 30 03 00 	mov    0x330(%rsp),%rax
  6ff13e:	00 
  6ff13f:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  6ff146:	00 
  6ff147:	0f 28 84 24 20 03 00 	movaps 0x320(%rsp),%xmm0
  6ff14e:	00 
  6ff14f:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  6ff156:	00 
  6ff157:	40 0f b6 c7          	movzbl %dil,%eax
  6ff15b:	48 c1 e5 08          	shl    $0x8,%rbp
  6ff15f:	48 09 c5             	or     %rax,%rbp
  6ff162:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  6ff169:	00 
  6ff16a:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  6ff171:	00 
  6ff172:	66 0f 6f 84 24 c0 01 	movdqa 0x1c0(%rsp),%xmm0
  6ff179:	00 00 
  6ff17b:	f3 0f 7f 84 24 10 01 	movdqu %xmm0,0x110(%rsp)
  6ff182:	00 00 
  6ff184:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6ff189:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  6ff190:	00 
  6ff191:	48 89 ac 24 f8 00 00 	mov    %rbp,0xf8(%rsp)
  6ff198:	00 
  6ff199:	4c 89 84 24 00 01 00 	mov    %r8,0x100(%rsp)
  6ff1a0:	00 
  6ff1a1:	4c 89 ac 24 08 01 00 	mov    %r13,0x108(%rsp)
  6ff1a8:	00 
  6ff1a9:	66 0f 7f 84 24 40 02 	movdqa %xmm0,0x240(%rsp)
  6ff1b0:	00 00 
  6ff1b2:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  6ff1b9:	00 
  6ff1ba:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  6ff1c1:	00 
  6ff1c2:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  6ff1c9:	00 
  6ff1ca:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
  6ff1d1:	00 
  6ff1d2:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
  6ff1d9:	00 
  6ff1da:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  6ff1e1:	00 
  6ff1e2:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  6ff1e9:	00 
  6ff1ea:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  6ff1f1:	00 
  6ff1f2:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  6ff1f9:	00 
  6ff1fa:	31 ed                	xor    %ebp,%ebp
  6ff1fc:	e9 41 e6 ff ff       	jmp    6fd842 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x242>
  6ff201:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6ff206:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  6ff20b:	c1 e0 10             	shl    $0x10,%eax
  6ff20e:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  6ff213:	09 c1                	or     %eax,%ecx
  6ff215:	48 c1 e1 20          	shl    $0x20,%rcx
  6ff219:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  6ff21d:	48 09 cd             	or     %rcx,%rbp
  6ff220:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  6ff227:	00 
  6ff228:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6ff22d:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  6ff234:	00 
  6ff235:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  6ff23c:	00 00 
  6ff23e:	66 0f 7f 84 24 20 03 	movdqa %xmm0,0x320(%rsp)
  6ff245:	00 00 
  6ff247:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  6ff24e:	00 
  6ff24f:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  6ff256:	00 
  6ff257:	eb 17                	jmp    6ff270 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1c70>
  6ff259:	48 b8 ff ff ff ff ff 	movabs $0xffffffffff,%rax
  6ff260:	00 00 00 
  6ff263:	48 21 c5             	and    %rax,%rbp
  6ff266:	b8 24 00 00 00       	mov    $0x24,%eax
  6ff26b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6ff270:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  6ff275:	48 85 c9             	test   %rcx,%rcx
  6ff278:	0f 84 65 fb ff ff    	je     6fede3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e3>
  6ff27e:	f6 01 01             	testb  $0x1,(%rcx)
  6ff281:	0f 85 5c fb ff ff    	jne    6fede3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e3>
  6ff287:	48 8b 41 08          	mov    0x8(%rcx),%rax
  6ff28b:	a8 01                	test   $0x1,%al
  6ff28d:	0f 85 50 fb ff ff    	jne    6fede3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e3>
  6ff293:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  6ff297:	48 8d 41 08          	lea    0x8(%rcx),%rax
  6ff29b:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  6ff2a0:	0f 84 53 01 00 00    	je     6ff3f9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1df9>
  6ff2a6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff2ab:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6ff2af:	e9 34 fb ff ff       	jmp    6fede8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e8>
  6ff2b4:	48 8d 3d e5 a6 3f 00 	lea    0x3fa6e5(%rip),%rdi        # af99a0 <__frame_dummy_init_array_entry+0x478>
  6ff2bb:	ff 15 ff 8c 42 00    	call   *0x428cff(%rip)        # b27fc0 <_DYNAMIC+0x308>
  6ff2c1:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6ff2c5:	ff 15 6d 8c 42 00    	call   *0x428c6d(%rip)        # b27f38 <_DYNAMIC+0x280>
  6ff2cb:	e9 c0 e6 ff ff       	jmp    6fd990 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x390>
  6ff2d0:	41 bc 15 00 00 00    	mov    $0x15,%r12d
  6ff2d6:	eb 3c                	jmp    6ff314 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d14>
  6ff2d8:	48 8d 05 c5 b2 96 ff 	lea    -0x694d3b(%rip),%rax        # 6a5a4 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34b7>
  6ff2df:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  6ff2e6:	00 
  6ff2e7:	48 8d 05 1a af 3f 00 	lea    0x3faf1a(%rip),%rax        # afa208 <__frame_dummy_init_array_entry+0xce0>
  6ff2ee:	eb 1c                	jmp    6ff30c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1d0c>
  6ff2f0:	41 bc 14 00 00 00    	mov    $0x14,%r12d
  6ff2f6:	48 8d 05 93 b2 96 ff 	lea    -0x694d6d(%rip),%rax        # 6a590 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34a3>
  6ff2fd:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  6ff304:	00 
  6ff305:	48 8d 05 e4 ae 3f 00 	lea    0x3faee4(%rip),%rax        # afa1f0 <__frame_dummy_init_array_entry+0xcc8>
  6ff30c:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  6ff313:	00 
  6ff314:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  6ff31b:	00 
  6ff31c:	4c 89 e6             	mov    %r12,%rsi
  6ff31f:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  6ff326:	00 
  6ff327:	ff 15 d3 8c 42 00    	call   *0x428cd3(%rip)        # b28000 <_DYNAMIC+0x348>
  6ff32d:	e9 a7 01 00 00       	jmp    6ff4d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  6ff332:	48 8d 3d 2f b2 96 ff 	lea    -0x694dd1(%rip),%rdi        # 6a568 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x347b>
  6ff339:	48 8d 15 50 ae 3f 00 	lea    0x3fae50(%rip),%rdx        # afa190 <__frame_dummy_init_array_entry+0xc68>
  6ff340:	be 13 00 00 00       	mov    $0x13,%esi
  6ff345:	ff 15 b5 8c 42 00    	call   *0x428cb5(%rip)        # b28000 <_DYNAMIC+0x348>
  6ff34b:	e9 89 01 00 00       	jmp    6ff4d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  6ff350:	48 8d 3d 8e b2 96 ff 	lea    -0x694d72(%rip),%rdi        # 6a5e5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34f8>
  6ff357:	48 8d 15 0a af 3f 00 	lea    0x3faf0a(%rip),%rdx        # afa268 <__frame_dummy_init_array_entry+0xd40>
  6ff35e:	be 93 00 00 00       	mov    $0x93,%esi
  6ff363:	ff 15 87 8d 42 00    	call   *0x428d87(%rip)        # b280f0 <_DYNAMIC+0x438>
  6ff369:	e9 6b 01 00 00       	jmp    6ff4d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  6ff36e:	48 8d 05 5a b2 96 ff 	lea    -0x694da6(%rip),%rax        # 6a5cf <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x34e2>
  6ff375:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  6ff37c:	00 
  6ff37d:	48 8d 05 9c ae 3f 00 	lea    0x3fae9c(%rip),%rax        # afa220 <__frame_dummy_init_array_entry+0xcf8>
  6ff384:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  6ff38b:	00 
  6ff38c:	48 8b bc 24 30 01 00 	mov    0x130(%rsp),%rdi
  6ff393:	00 
  6ff394:	4c 89 ee             	mov    %r13,%rsi
  6ff397:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
  6ff39e:	00 
  6ff39f:	ff 15 5b 8c 42 00    	call   *0x428c5b(%rip)        # b28000 <_DYNAMIC+0x348>
  6ff3a5:	e9 2f 01 00 00       	jmp    6ff4d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  6ff3aa:	48 8d 3d f7 a2 3f 00 	lea    0x3fa2f7(%rip),%rdi        # af96a8 <__frame_dummy_init_array_entry+0x180>
  6ff3b1:	ff 15 09 8c 42 00    	call   *0x428c09(%rip)        # b27fc0 <_DYNAMIC+0x308>
  6ff3b7:	e9 1d 01 00 00       	jmp    6ff4d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  6ff3bc:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6ff3c3:	00 00 
  6ff3c5:	48 8d 3d 6c ae 3f 00 	lea    0x3fae6c(%rip),%rdi        # afa238 <__frame_dummy_init_array_entry+0xd10>
  6ff3cc:	ff 15 ee 8b 42 00    	call   *0x428bee(%rip)        # b27fc0 <_DYNAMIC+0x308>
  6ff3d2:	e9 02 01 00 00       	jmp    6ff4d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  6ff3d7:	48 8d 05 9a a2 3f 00 	lea    0x3fa29a(%rip),%rax        # af9678 <__frame_dummy_init_array_entry+0x150>
  6ff3de:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  6ff3e5:	00 
  6ff3e6:	48 8b bc 24 b8 01 00 	mov    0x1b8(%rsp),%rdi
  6ff3ed:	00 
  6ff3ee:	ff 15 cc 8b 42 00    	call   *0x428bcc(%rip)        # b27fc0 <_DYNAMIC+0x308>
  6ff3f4:	e9 e0 00 00 00       	jmp    6ff4d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  6ff3f9:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6ff3fe:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6ff402:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff407:	ff 15 2b 8b 42 00    	call   *0x428b2b(%rip)        # b27f38 <_DYNAMIC+0x280>
  6ff40d:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  6ff411:	e9 d2 f9 ff ff       	jmp    6fede8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x17e8>
  6ff416:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6ff41b:	48 8b 47 08          	mov    0x8(%rdi),%rax
  6ff41f:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff424:	ff 15 0e 8b 42 00    	call   *0x428b0e(%rip)        # b27f38 <_DYNAMIC+0x280>
  6ff42a:	89 ef                	mov    %ebp,%edi
  6ff42c:	e9 e9 f9 ff ff       	jmp    6fee1a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x181a>
  6ff431:	48 8d 15 58 a2 3f 00 	lea    0x3fa258(%rip),%rdx        # af9690 <__frame_dummy_init_array_entry+0x168>
  6ff438:	ff 15 d2 8b 42 00    	call   *0x428bd2(%rip)        # b28010 <_DYNAMIC+0x358>
  6ff43e:	e9 96 00 00 00       	jmp    6ff4d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  6ff443:	48 8d 05 9e a5 3f 00 	lea    0x3fa59e(%rip),%rax        # af99e8 <__frame_dummy_init_array_entry+0x4c0>
  6ff44a:	eb 47                	jmp    6ff493 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  6ff44c:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6ff451:	48 8d 05 a8 a5 3f 00 	lea    0x3fa5a8(%rip),%rax        # af9a00 <__frame_dummy_init_array_entry+0x4d8>
  6ff458:	eb 39                	jmp    6ff493 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  6ff45a:	48 8d 05 6f a5 3f 00 	lea    0x3fa56f(%rip),%rax        # af99d0 <__frame_dummy_init_array_entry+0x4a8>
  6ff461:	eb 30                	jmp    6ff493 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  6ff463:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6ff468:	48 8d 05 21 a2 3f 00 	lea    0x3fa221(%rip),%rax        # af9690 <__frame_dummy_init_array_entry+0x168>
  6ff46f:	eb 22                	jmp    6ff493 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1e93>
  6ff471:	48 85 ff             	test   %rdi,%rdi
  6ff474:	75 34                	jne    6ff4aa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1eaa>
  6ff476:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6ff47d:	00 00 
  6ff47f:	ff 15 73 8c 42 00    	call   *0x428c73(%rip)        # b280f8 <_DYNAMIC+0x440>
  6ff485:	eb 52                	jmp    6ff4d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  6ff487:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6ff48c:	48 8d 05 cd a1 3f 00 	lea    0x3fa1cd(%rip),%rax        # af9660 <__frame_dummy_init_array_entry+0x138>
  6ff493:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  6ff498:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6ff49d:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  6ff4a2:	ff 15 68 8b 42 00    	call   *0x428b68(%rip)        # b28010 <_DYNAMIC+0x358>
  6ff4a8:	eb 2f                	jmp    6ff4d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  6ff4aa:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  6ff4af:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6ff4b6:	00 00 
  6ff4b8:	ff 15 6a 8a 42 00    	call   *0x428a6a(%rip)        # b27f28 <_DYNAMIC+0x270>
  6ff4be:	eb 19                	jmp    6ff4d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1ed9>
  6ff4c0:	48 8d 3d b4 b0 96 ff 	lea    -0x694f4c(%rip),%rdi        # 6a57b <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x348e>
  6ff4c7:	48 8d 15 da ac 3f 00 	lea    0x3facda(%rip),%rdx        # afa1a8 <__frame_dummy_init_array_entry+0xc80>
  6ff4ce:	be 15 00 00 00       	mov    $0x15,%esi
  6ff4d3:	ff 15 27 8b 42 00    	call   *0x428b27(%rip)        # b28000 <_DYNAMIC+0x348>
  6ff4d9:	0f 0b                	ud2
  6ff4db:	49 89 c5             	mov    %rax,%r13
  6ff4de:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6ff4e3:	48 89 45 10          	mov    %rax,0x10(%rbp)
  6ff4e7:	eb 6d                	jmp    6ff556 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  6ff4e9:	49 89 c5             	mov    %rax,%r13
  6ff4ec:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  6ff4f1:	48 89 45 08          	mov    %rax,0x8(%rbp)
  6ff4f5:	eb 5f                	jmp    6ff556 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  6ff4f7:	49 89 c5             	mov    %rax,%r13
  6ff4fa:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  6ff4fe:	eb 56                	jmp    6ff556 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  6ff500:	48 89 c3             	mov    %rax,%rbx
  6ff503:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6ff50a:	00 
  6ff50b:	e8 70 85 ff ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6ff510:	48 89 df             	mov    %rbx,%rdi
  6ff513:	e8 58 8c 3f 00       	call   af8170 <_Unwind_Resume@plt>
  6ff518:	eb 18                	jmp    6ff532 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f32>
  6ff51a:	eb 16                	jmp    6ff532 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f32>
  6ff51c:	eb 00                	jmp    6ff51e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f1e>
  6ff51e:	49 89 c5             	mov    %rax,%r13
  6ff521:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  6ff528:	ff 
  6ff529:	eb 2b                	jmp    6ff556 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f56>
  6ff52b:	49 89 c5             	mov    %rax,%r13
  6ff52e:	eb 4d                	jmp    6ff57d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f7d>
  6ff530:	eb 21                	jmp    6ff553 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f53>
  6ff532:	49 89 c5             	mov    %rax,%r13
  6ff535:	eb 29                	jmp    6ff560 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f60>
  6ff537:	49 89 c5             	mov    %rax,%r13
  6ff53a:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
  6ff540:	7e 3b                	jle    6ff57d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f7d>
  6ff542:	ba 01 00 00 00       	mov    $0x1,%edx
  6ff547:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6ff54c:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  6ff551:	eb 24                	jmp    6ff577 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f77>
  6ff553:	49 89 c5             	mov    %rax,%r13
  6ff556:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  6ff55b:	e8 70 4e ff ff       	call   6f43d0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  6ff560:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  6ff566:	7e 15                	jle    6ff57d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1f7d>
  6ff568:	ba 01 00 00 00       	mov    $0x1,%edx
  6ff56d:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6ff572:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  6ff577:	ff 15 83 89 42 00    	call   *0x428983(%rip)        # b27f00 <_DYNAMIC+0x248>
  6ff57d:	4c 89 ef             	mov    %r13,%rdi
  6ff580:	ff 15 9a 8a 42 00    	call   *0x428a9a(%rip)        # b28020 <_DYNAMIC+0x368>
  6ff586:	49 89 c5             	mov    %rax,%r13
  6ff589:	48 89 d5             	mov    %rdx,%rbp
  6ff58c:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
  6ff593:	00 
  6ff594:	48 89 94 24 00 01 00 	mov    %rdx,0x100(%rsp)
  6ff59b:	00 
  6ff59c:	48 c7 84 24 f0 00 00 	movq   $0xfffffffffffffffd,0xf0(%rsp)
  6ff5a3:	00 fd ff ff ff 
  6ff5a8:	4c 89 f7             	mov    %r14,%rdi
  6ff5ab:	e8 30 8a 02 00       	call   727fe0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6ff5b0:	48 c7 84 24 20 02 00 	movq   $0xf,0x220(%rsp)
  6ff5b7:	00 0f 00 00 00 
  6ff5bc:	48 8b 45 00          	mov    0x0(%rbp),%rax
  6ff5c0:	48 85 c0             	test   %rax,%rax
  6ff5c3:	74 05                	je     6ff5ca <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1fca>
  6ff5c5:	4c 89 ef             	mov    %r13,%rdi
  6ff5c8:	ff d0                	call   *%rax
  6ff5ca:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6ff5ce:	48 85 f6             	test   %rsi,%rsi
  6ff5d1:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  6ff5d6:	74 0d                	je     6ff5e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x1fe5>
  6ff5d8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6ff5dc:	4c 89 ef             	mov    %r13,%rdi
  6ff5df:	ff 15 1b 89 42 00    	call   *0x42891b(%rip)        # b27f00 <_DYNAMIC+0x248>
  6ff5e5:	31 ed                	xor    %ebp,%ebp
  6ff5e7:	e9 56 e2 ff ff       	jmp    6fd842 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x242>
  6ff5ec:	48 89 c3             	mov    %rax,%rbx
  6ff5ef:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  6ff5f3:	48 85 f6             	test   %rsi,%rsi
  6ff5f6:	74 2b                	je     6ff623 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing+0x2023>
  6ff5f8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  6ff5fc:	4c 89 ef             	mov    %r13,%rdi
  6ff5ff:	ff 15 fb 88 42 00    	call   *0x4288fb(%rip)        # b27f00 <_DYNAMIC+0x248>
  6ff605:	48 89 df             	mov    %rbx,%rdi
  6ff608:	e8 63 8b 3f 00       	call   af8170 <_Unwind_Resume@plt>
  6ff60d:	ff 15 1d 89 42 00    	call   *0x42891d(%rip)        # b27f30 <_DYNAMIC+0x278>
  6ff613:	48 89 c3             	mov    %rax,%rbx
  6ff616:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  6ff61d:	00 
  6ff61e:	e8 7d 52 ff ff       	call   6f48a0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6ff623:	48 89 df             	mov    %rbx,%rdi
  6ff626:	e8 45 8b 3f 00       	call   af8170 <_Unwind_Resume@plt>
  6ff62b:	ff 15 ff 88 42 00    	call   *0x4288ff(%rip)        # b27f30 <_DYNAMIC+0x278>
  6ff631:	ff 15 f1 89 42 00    	call   *0x4289f1(%rip)        # b28028 <_DYNAMIC+0x370>
