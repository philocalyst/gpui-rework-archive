
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

0000000000707620 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing>:
  707620:	55                   	push   %rbp
  707621:	41 57                	push   %r15
  707623:	41 56                	push   %r14
  707625:	41 55                	push   %r13
  707627:	41 54                	push   %r12
  707629:	53                   	push   %rbx
  70762a:	48 81 ec c8 03 00 00 	sub    $0x3c8,%rsp
  707631:	4d 89 c4             	mov    %r8,%r12
  707634:	49 89 cf             	mov    %rcx,%r15
  707637:	49 89 f6             	mov    %rsi,%r14
  70763a:	48 89 fb             	mov    %rdi,%rbx
  70763d:	41 83 38 02          	cmpl   $0x2,(%r8)
  707641:	75 08                	jne    70764b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2b>
  707643:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  70764a:	01 
  70764b:	4d 85 ff             	test   %r15,%r15
  70764e:	0f 84 94 01 00 00    	je     7077e8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c8>
  707654:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  70765b:	01 
  70765c:	0f 85 86 01 00 00    	jne    7077e8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c8>
  707662:	49 8b 86 28 02 00 00 	mov    0x228(%r14),%rax
  707669:	49 8d 8e 30 02 00 00 	lea    0x230(%r14),%rcx
  707670:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  707674:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
  707679:	48 0f 44 ce          	cmove  %rsi,%rcx
  70767d:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  707681:	66 0f 7f 84 24 60 01 	movdqa %xmm0,0x160(%rsp)
  707688:	00 00 
  70768a:	74 45                	je     7076d1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xb1>
  70768c:	66 0f 6f 84 24 60 01 	movdqa 0x160(%rsp),%xmm0
  707693:	00 00 
  707695:	f3 0f 7f 84 24 c8 01 	movdqu %xmm0,0x1c8(%rsp)
  70769c:	00 00 
  70769e:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  7076a5:	00 
  7076a6:	48 8b 94 24 c9 01 00 	mov    0x1c9(%rsp),%rdx
  7076ad:	00 
  7076ae:	48 8b b4 24 d0 01 00 	mov    0x1d0(%rsp),%rsi
  7076b5:	00 
  7076b6:	48 89 73 18          	mov    %rsi,0x18(%rbx)
  7076ba:	48 89 53 11          	mov    %rdx,0x11(%rbx)
  7076be:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  7076c5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  7076c9:	88 4b 10             	mov    %cl,0x10(%rbx)
  7076cc:	e9 5e 03 00 00       	jmp    707a2f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  7076d1:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  7076d6:	41 83 ff 01          	cmp    $0x1,%r15d
  7076da:	0f 85 80 00 00 00    	jne    707760 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x140>
  7076e0:	48 89 d5             	mov    %rdx,%rbp
  7076e3:	49 8b 8e 48 02 00 00 	mov    0x248(%r14),%rcx
  7076ea:	4d 8b a6 50 02 00 00 	mov    0x250(%r14),%r12
  7076f1:	49 c1 e4 04          	shl    $0x4,%r12
  7076f5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  7076fc:	00 00 00 00 
  707700:	4d 85 e4             	test   %r12,%r12
  707703:	0f 84 7a 03 00 00    	je     707a83 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x463>
  707709:	4c 8d 69 10          	lea    0x10(%rcx),%r13
  70770d:	48 8b 39             	mov    (%rcx),%rdi
  707710:	48 8b 41 08          	mov    0x8(%rcx),%rax
  707714:	ff 50 18             	call   *0x18(%rax)
  707717:	49 83 c4 f0          	add    $0xfffffffffffffff0,%r12
  70771b:	4c 89 e9             	mov    %r13,%rcx
  70771e:	4c 39 f8             	cmp    %r15,%rax
  707721:	75 dd                	jne    707700 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xe0>
  707723:	49 8b 8e 60 02 00 00 	mov    0x260(%r14),%rcx
  70772a:	49 8b 86 68 02 00 00 	mov    0x268(%r14),%rax
  707731:	48 c1 e0 03          	shl    $0x3,%rax
  707735:	31 f6                	xor    %esi,%esi
  707737:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70773c:	0f 1f 40 00          	nopl   0x0(%rax)
  707740:	48 89 f2             	mov    %rsi,%rdx
  707743:	48 39 f0             	cmp    %rsi,%rax
  707746:	74 0a                	je     707752 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x132>
  707748:	48 8d 72 08          	lea    0x8(%rdx),%rsi
  70774c:	4c 39 3c 11          	cmp    %r15,(%rcx,%rdx,1)
  707750:	75 ee                	jne    707740 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x120>
  707752:	48 39 d0             	cmp    %rdx,%rax
  707755:	0f 95 c1             	setne  %cl
  707758:	48 89 ea             	mov    %rbp,%rdx
  70775b:	e9 7f 00 00 00       	jmp    7077df <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1bf>
  707760:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  707767:	00 
  707768:	4d 8b a6 78 02 00 00 	mov    0x278(%r14),%r12
  70776f:	4d 8b ae 80 02 00 00 	mov    0x280(%r14),%r13
  707776:	49 c1 e5 04          	shl    $0x4,%r13
  70777a:	31 ed                	xor    %ebp,%ebp
  70777c:	0f 1f 40 00          	nopl   0x0(%rax)
  707780:	49 39 ed             	cmp    %rbp,%r13
  707783:	0f 84 0e 03 00 00    	je     707a97 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x477>
  707789:	49 8b 3c 2c          	mov    (%r12,%rbp,1),%rdi
  70778d:	49 8b 44 2c 08       	mov    0x8(%r12,%rbp,1),%rax
  707792:	4c 89 fe             	mov    %r15,%rsi
  707795:	ff 50 30             	call   *0x30(%rax)
  707798:	48 83 c5 10          	add    $0x10,%rbp
  70779c:	84 c0                	test   %al,%al
  70779e:	74 e0                	je     707780 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160>
  7077a0:	49 8b 74 2c f0       	mov    -0x10(%r12,%rbp,1),%rsi
  7077a5:	49 8b 44 2c f8       	mov    -0x8(%r12,%rbp,1),%rax
  7077aa:	48 8d bc 24 c0 01 00 	lea    0x1c0(%rsp),%rdi
  7077b1:	00 
  7077b2:	4c 89 fa             	mov    %r15,%rdx
  7077b5:	ff 50 60             	call   *0x60(%rax)
  7077b8:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
  7077bf:	00 
  7077c0:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  7077c7:	00 
  7077c8:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7077cc:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7077d1:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  7077d8:	00 
  7077d9:	0f 85 c7 fe ff ff    	jne    7076a6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x86>
  7077df:	f6 c1 01             	test   $0x1,%cl
  7077e2:	0f 84 f4 02 00 00    	je     707adc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x4bc>
  7077e8:	49 ff 86 00 07 00 00 	incq   0x700(%r14)
  7077ef:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  7077f4:	4c 89 f6             	mov    %r14,%rsi
  7077f7:	31 c9                	xor    %ecx,%ecx
  7077f9:	e8 92 f5 ff ff       	call   706d90 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>
  7077fe:	83 7c 24 70 fe       	cmpl   $0xfffffffe,0x70(%rsp)
  707803:	75 16                	jne    70781b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1fb>
  707805:	c6 84 24 28 02 00 00 	movb   $0x0,0x228(%rsp)
  70780c:	00 
  70780d:	48 c7 84 24 20 02 00 	movq   $0xfffffffffffffffe,0x220(%rsp)
  707814:	00 fe ff ff ff 
  707819:	eb 41                	jmp    70785c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x23c>
  70781b:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  707822:	00 
  707823:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  70782a:	00 
  70782b:	f3 0f 6f 44 24 70    	movdqu 0x70(%rsp),%xmm0
  707831:	f3 0f 6f 8c 24 80 00 	movdqu 0x80(%rsp),%xmm1
  707838:	00 00 
  70783a:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  707841:	00 
  707842:	0f 29 94 24 40 02 00 	movaps %xmm2,0x240(%rsp)
  707849:	00 
  70784a:	66 0f 7f 8c 24 30 02 	movdqa %xmm1,0x230(%rsp)
  707851:	00 00 
  707853:	66 0f 7f 84 24 20 02 	movdqa %xmm0,0x220(%rsp)
  70785a:	00 00 
  70785c:	40 b5 01             	mov    $0x1,%bpl
  70785f:	45 31 ff             	xor    %r15d,%r15d
  707862:	48 83 bc 24 20 02 00 	cmpq   $0xfffffffffffffffe,0x220(%rsp)
  707869:	00 fe 
  70786b:	0f 85 ba 00 00 00    	jne    70792b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x30b>
  707871:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  707878:	00 
  707879:	4c 89 f6             	mov    %r14,%rsi
  70787c:	4c 89 e2             	mov    %r12,%rdx
  70787f:	e8 8c 29 00 00       	call   70a210 <<gpui::runtime::Runtime<unit_action_cost::Model>>::reconcile_editing>
  707884:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  70788b:	00 
  70788c:	44 0f b6 a4 24 f8 00 	movzbl 0xf8(%rsp),%r12d
  707893:	00 00 
  707895:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  707899:	0f 85 61 01 00 00    	jne    707a00 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x3e0>
  70789f:	48 8d 35 d2 f0 95 ff 	lea    -0x6a0f2e(%rip),%rsi        # 66978 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e8>
  7078a6:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  7078ad:	00 
  7078ae:	e8 8d 7f 01 00       	call   71f840 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  7078b3:	84 c0                	test   %al,%al
  7078b5:	74 26                	je     7078dd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2bd>
  7078b7:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  7078be:	48 85 c0             	test   %rax,%rax
  7078c1:	0f 84 7a 01 00 00    	je     707a41 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x421>
  7078c7:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  7078ce:	00 
  7078cf:	0f 95 c0             	setne  %al
  7078d2:	44 08 e0             	or     %r12b,%al
  7078d5:	a8 01                	test   $0x1,%al
  7078d7:	0f 84 6e 01 00 00    	je     707a4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x42b>
  7078dd:	48 8d 35 cc f0 95 ff 	lea    -0x6a0f34(%rip),%rsi        # 669b0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x320>
  7078e4:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  7078eb:	00 
  7078ec:	e8 4f 7f 01 00       	call   71f840 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  7078f1:	84 c0                	test   %al,%al
  7078f3:	74 26                	je     70791b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2fb>
  7078f5:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  7078fc:	48 85 c0             	test   %rax,%rax
  7078ff:	0f 84 a7 01 00 00    	je     707aac <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x48c>
  707905:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70790c:	00 
  70790d:	0f 95 c0             	setne  %al
  707910:	44 08 e0             	or     %r12b,%al
  707913:	a8 01                	test   $0x1,%al
  707915:	0f 84 9b 01 00 00    	je     707ab6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x496>
  70791b:	48 89 df             	mov    %rbx,%rdi
  70791e:	4c 89 f6             	mov    %r14,%rsi
  707921:	e8 ca 61 01 00       	call   71daf0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  707926:	e9 04 01 00 00       	jmp    707a2f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  70792b:	48 8b 84 24 50 02 00 	mov    0x250(%rsp),%rax
  707932:	00 
  707933:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  70793a:	00 
  70793b:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  707942:	00 
  707943:	0f 28 8c 24 30 02 00 	movaps 0x230(%rsp),%xmm1
  70794a:	00 
  70794b:	0f 28 94 24 40 02 00 	movaps 0x240(%rsp),%xmm2
  707952:	00 
  707953:	0f 29 94 24 10 01 00 	movaps %xmm2,0x110(%rsp)
  70795a:	00 
  70795b:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  707962:	00 
  707963:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  70796a:	00 
  70796b:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  707972:	48 85 c0             	test   %rax,%rax
  707975:	74 41                	je     7079b8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x398>
  707977:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  70797e:	48 85 c0             	test   %rax,%rax
  707981:	74 35                	je     7079b8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x398>
  707983:	48 8b 78 10          	mov    0x10(%rax),%rdi
  707987:	0f b6 48 24          	movzbl 0x24(%rax),%ecx
  70798b:	c6 40 24 02          	movb   $0x2,0x24(%rax)
  70798f:	80 f9 02             	cmp    $0x2,%cl
  707992:	74 24                	je     7079b8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x398>
  707994:	f6 07 01             	testb  $0x1,(%rdi)
  707997:	75 17                	jne    7079b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x390>
  707999:	48 8b 47 08          	mov    0x8(%rdi),%rax
  70799d:	a8 01                	test   $0x1,%al
  70799f:	75 0f                	jne    7079b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x390>
  7079a1:	48 8d 47 08          	lea    0x8(%rdi),%rax
  7079a5:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  7079aa:	0f 84 31 19 00 00    	je     7092e1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cc1>
  7079b0:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  7079b7:	01 
  7079b8:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  7079bf:	00 
  7079c0:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  7079c7:	00 00 00 00 
  7079cb:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  7079d2:	00 
  7079d3:	48 89 43 30          	mov    %rax,0x30(%rbx)
  7079d7:	66 0f 6f 84 24 f0 00 	movdqa 0xf0(%rsp),%xmm0
  7079de:	00 00 
  7079e0:	66 0f 6f 8c 24 00 01 	movdqa 0x100(%rsp),%xmm1
  7079e7:	00 00 
  7079e9:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
  7079f0:	00 
  7079f1:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  7079f5:	f3 0f 7f 4b 10       	movdqu %xmm1,0x10(%rbx)
  7079fa:	f3 0f 7f 03          	movdqu %xmm0,(%rbx)
  7079fe:	eb 2f                	jmp    707a2f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  707a00:	f3 0f 6f 84 24 f9 00 	movdqu 0xf9(%rsp),%xmm0
  707a07:	00 00 
  707a09:	f3 0f 6f 8c 24 09 01 	movdqu 0x109(%rsp),%xmm1
  707a10:	00 00 
  707a12:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  707a19:	00 
  707a1a:	0f 11 53 28          	movups %xmm2,0x28(%rbx)
  707a1e:	f3 0f 7f 4b 19       	movdqu %xmm1,0x19(%rbx)
  707a23:	f3 0f 7f 43 09       	movdqu %xmm0,0x9(%rbx)
  707a28:	48 89 03             	mov    %rax,(%rbx)
  707a2b:	44 88 63 08          	mov    %r12b,0x8(%rbx)
  707a2f:	48 81 c4 c8 03 00 00 	add    $0x3c8,%rsp
  707a36:	5b                   	pop    %rbx
  707a37:	41 5c                	pop    %r12
  707a39:	41 5d                	pop    %r13
  707a3b:	41 5e                	pop    %r14
  707a3d:	41 5f                	pop    %r15
  707a3f:	5d                   	pop    %rbp
  707a40:	c3                   	ret
  707a41:	41 80 fc 01          	cmp    $0x1,%r12b
  707a45:	0f 84 92 fe ff ff    	je     7078dd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2bd>
  707a4b:	f3 41 0f 6f 86 60 06 	movdqu 0x660(%r14),%xmm0
  707a52:	00 00 
  707a54:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  707a5b:	00 
  707a5c:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  707a63:	00 
  707a64:	74 16                	je     707a7c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x45c>
  707a66:	84 c0                	test   %al,%al
  707a68:	0f 84 c7 00 00 00    	je     707b35 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x515>
  707a6e:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  707a75:	ff 
  707a76:	0f 85 b9 00 00 00    	jne    707b35 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x515>
  707a7c:	31 c9                	xor    %ecx,%ecx
  707a7e:	e9 be 00 00 00       	jmp    707b41 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x521>
  707a83:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  707a8a:	00 
  707a8b:	b8 0b 00 00 00       	mov    $0xb,%eax
  707a90:	b1 01                	mov    $0x1,%cl
  707a92:	e9 0f fc ff ff       	jmp    7076a6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x86>
  707a97:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  707a9e:	00 
  707a9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  707aa4:	44 89 f9             	mov    %r15d,%ecx
  707aa7:	e9 fa fb ff ff       	jmp    7076a6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x86>
  707aac:	41 80 fc 01          	cmp    $0x1,%r12b
  707ab0:	0f 84 65 fe ff ff    	je     70791b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2fb>
  707ab6:	40 84 ed             	test   %bpl,%bpl
  707ab9:	0f 85 15 18 00 00    	jne    7092d4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cb4>
  707abf:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  707ac3:	4c 89 f6             	mov    %r14,%rsi
  707ac6:	31 d2                	xor    %edx,%edx
  707ac8:	4c 89 f9             	mov    %r15,%rcx
  707acb:	e8 30 32 00 00       	call   70ad00 <<gpui::runtime::Runtime<unit_action_cost::Model>>::publish_metadata>
  707ad0:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  707ad7:	e9 53 ff ff ff       	jmp    707a2f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  707adc:	4c 89 bc 24 68 03 00 	mov    %r15,0x368(%rsp)
  707ae3:	00 
  707ae4:	49 ff 86 f8 06 00 00 	incq   0x6f8(%r14)
  707aeb:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  707af2:	48 85 c0             	test   %rax,%rax
  707af5:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  707afc:	00 
  707afd:	0f 84 90 02 00 00    	je     707d93 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  707b03:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  707b0a:	48 85 c9             	test   %rcx,%rcx
  707b0d:	0f 84 9c 00 00 00    	je     707baf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x58f>
  707b13:	48 89 ca             	mov    %rcx,%rdx
  707b16:	48 83 e2 07          	and    $0x7,%rdx
  707b1a:	74 4c                	je     707b68 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x548>
  707b1c:	31 f6                	xor    %esi,%esi
  707b1e:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  707b25:	48 ff c6             	inc    %rsi
  707b28:	48 39 f2             	cmp    %rsi,%rdx
  707b2b:	75 f1                	jne    707b1e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x4fe>
  707b2d:	48 89 ca             	mov    %rcx,%rdx
  707b30:	48 29 f2             	sub    %rsi,%rdx
  707b33:	eb 36                	jmp    707b6b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x54b>
  707b35:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  707b3c:	b9 01 00 00 00       	mov    $0x1,%ecx
  707b41:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  707b48:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  707b4c:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  707b50:	f3 0f 7f 43 18       	movdqu %xmm0,0x18(%rbx)
  707b55:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  707b59:	88 43 30             	mov    %al,0x30(%rbx)
  707b5c:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  707b63:	e9 c7 fe ff ff       	jmp    707a2f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  707b68:	48 89 ca             	mov    %rcx,%rdx
  707b6b:	48 83 f9 08          	cmp    $0x8,%rcx
  707b6f:	72 3e                	jb     707baf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x58f>
  707b71:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  707b78:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  707b7f:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  707b86:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  707b8d:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  707b94:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  707b9b:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  707ba2:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  707ba9:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  707bad:	75 c2                	jne    707b71 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x551>
  707baf:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  707bb6:	00 
  707bb7:	0f 84 d6 01 00 00    	je     707d93 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  707bbd:	80 38 00             	cmpb   $0x0,(%rax)
  707bc0:	0f 85 cd 01 00 00    	jne    707d93 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  707bc6:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  707bcd:	48 8d b4 24 68 03 00 	lea    0x368(%rsp),%rsi
  707bd4:	00 
  707bd5:	e8 36 84 01 00       	call   720010 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout>>::get::<gpui::source::FieldId>>
  707bda:	48 85 c0             	test   %rax,%rax
  707bdd:	0f 84 b0 01 00 00    	je     707d93 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  707be3:	48 8b 48 10          	mov    0x10(%rax),%rcx
  707be7:	48 c1 e1 02          	shl    $0x2,%rcx
  707beb:	48 83 38 ff          	cmpq   $0xffffffffffffffff,(%rax)
  707bef:	ba 04 00 00 00       	mov    $0x4,%edx
  707bf4:	48 0f 45 50 08       	cmovne 0x8(%rax),%rdx
  707bf9:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  707bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  707c03:	48 0f 45 c1          	cmovne %rcx,%rax
  707c07:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  707c0c:	48 85 c0             	test   %rax,%rax
  707c0f:	0f 84 7e 01 00 00    	je     707d93 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  707c15:	45 31 ed             	xor    %r13d,%r13d
  707c18:	48 8b 05 79 98 3f 00 	mov    0x3f9879(%rip),%rax        # b01498 <_DYNAMIC+0x3a8>
  707c1f:	48 83 c0 20          	add    $0x20,%rax
  707c23:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  707c28:	48 8b 05 71 98 3f 00 	mov    0x3f9871(%rip),%rax        # b014a0 <_DYNAMIC+0x3b0>
  707c2f:	48 83 c0 20          	add    $0x20,%rax
  707c33:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  707c38:	48 8b 05 69 98 3f 00 	mov    0x3f9869(%rip),%rax        # b014a8 <_DYNAMIC+0x3b8>
  707c3f:	48 83 c0 20          	add    $0x20,%rax
  707c43:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  707c48:	48 8b 05 61 98 3f 00 	mov    0x3f9861(%rip),%rax        # b014b0 <_DYNAMIC+0x3c0>
  707c4f:	48 83 c0 20          	add    $0x20,%rax
  707c53:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  707c58:	48 8b 05 59 98 3f 00 	mov    0x3f9859(%rip),%rax        # b014b8 <_DYNAMIC+0x3c8>
  707c5f:	48 83 c0 20          	add    $0x20,%rax
  707c63:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  707c68:	48 8b 05 51 98 3f 00 	mov    0x3f9851(%rip),%rax        # b014c0 <_DYNAMIC+0x3d0>
  707c6f:	48 83 c0 20          	add    $0x20,%rax
  707c73:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  707c7a:	00 
  707c7b:	48 8b 05 46 98 3f 00 	mov    0x3f9846(%rip),%rax        # b014c8 <_DYNAMIC+0x3d8>
  707c82:	48 83 c0 20          	add    $0x20,%rax
  707c86:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  707c8d:	00 
  707c8e:	48 8b 05 3b 98 3f 00 	mov    0x3f983b(%rip),%rax        # b014d0 <_DYNAMIC+0x3e0>
  707c95:	48 83 c0 20          	add    $0x20,%rax
  707c99:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  707c9e:	48 8b 05 33 98 3f 00 	mov    0x3f9833(%rip),%rax        # b014d8 <_DYNAMIC+0x3e8>
  707ca5:	48 83 c0 20          	add    $0x20,%rax
  707ca9:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  707cb0:	00 
  707cb1:	48 8b 05 28 98 3f 00 	mov    0x3f9828(%rip),%rax        # b014e0 <_DYNAMIC+0x3f0>
  707cb8:	48 83 c0 20          	add    $0x20,%rax
  707cbc:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  707cc1:	48 8b 05 20 98 3f 00 	mov    0x3f9820(%rip),%rax        # b014e8 <_DYNAMIC+0x3f8>
  707cc8:	48 83 c0 20          	add    $0x20,%rax
  707ccc:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  707cd3:	00 
  707cd4:	48 8b 05 15 98 3f 00 	mov    0x3f9815(%rip),%rax        # b014f0 <_DYNAMIC+0x400>
  707cdb:	48 83 c0 20          	add    $0x20,%rax
  707cdf:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  707ce4:	48 8b 05 0d 98 3f 00 	mov    0x3f980d(%rip),%rax        # b014f8 <_DYNAMIC+0x408>
  707ceb:	48 83 c0 20          	add    $0x20,%rax
  707cef:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  707cf4:	48 8d 2d 65 e4 95 ff 	lea    -0x6a1b9b(%rip),%rbp        # 66160 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1450>
  707cfb:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  707d00:	42 8b 3c 28          	mov    (%rax,%r13,1),%edi
  707d04:	ff 15 f6 97 3f 00    	call   *0x3f97f6(%rip)        # b01500 <_DYNAMIC+0x410>
  707d0a:	0f b7 c0             	movzwl %ax,%eax
  707d0d:	48 63 4c 85 00       	movslq 0x0(%rbp,%rax,4),%rcx
  707d12:	48 01 e9             	add    %rbp,%rcx
  707d15:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  707d1a:	ff e1                	jmp    *%rcx
  707d1c:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  707d21:	eb 57                	jmp    707d7a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  707d23:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  707d2a:	00 
  707d2b:	eb 4d                	jmp    707d7a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  707d2d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  707d32:	eb 46                	jmp    707d7a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  707d34:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  707d39:	eb 3f                	jmp    707d7a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  707d3b:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  707d42:	00 
  707d43:	eb 35                	jmp    707d7a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  707d45:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  707d4a:	eb 2e                	jmp    707d7a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  707d4c:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  707d53:	00 
  707d54:	eb 24                	jmp    707d7a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  707d56:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  707d5b:	eb 1d                	jmp    707d7a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  707d5d:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  707d62:	eb 16                	jmp    707d7a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  707d64:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  707d6b:	00 
  707d6c:	eb 0c                	jmp    707d7a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  707d6e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  707d73:	eb 05                	jmp    707d7a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  707d75:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  707d7a:	80 78 13 00          	cmpb   $0x0,0x13(%rax)
  707d7e:	0f 85 03 11 00 00    	jne    708e87 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1867>
  707d84:	49 83 c5 04          	add    $0x4,%r13
  707d88:	4c 39 6c 24 18       	cmp    %r13,0x18(%rsp)
  707d8d:	0f 85 68 ff ff ff    	jne    707cfb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x6db>
  707d93:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  707d9a:	00 00 
  707d9c:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  707da3:	48 85 ed             	test   %rbp,%rbp
  707da6:	0f 84 f2 10 00 00    	je     708e9e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x187e>
  707dac:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  707db3:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  707dba:	49 8b 86 d0 05 00 00 	mov    0x5d0(%r14),%rax
  707dc1:	48 89 c7             	mov    %rax,%rdi
  707dc4:	48 89 e9             	mov    %rbp,%rcx
  707dc7:	44 0f b7 91 c2 01 00 	movzwl 0x1c2(%rcx),%r10d
  707dce:	00 
  707dcf:	45 89 d3             	mov    %r10d,%r11d
  707dd2:	41 c1 e3 05          	shl    $0x5,%r11d
  707dd6:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  707ddd:	45 31 c9             	xor    %r9d,%r9d
  707de0:	4d 39 cb             	cmp    %r9,%r11
  707de3:	74 28                	je     707e0d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7ed>
  707de5:	4e 3b bc c1 70 01 00 	cmp    0x170(%rcx,%r8,8),%r15
  707dec:	00 
  707ded:	41 0f 97 c4          	seta   %r12b
  707df1:	41 80 dc 00          	sbb    $0x0,%r12b
  707df5:	49 83 c1 20          	add    $0x20,%r9
  707df9:	49 ff c0             	inc    %r8
  707dfc:	41 80 fc 01          	cmp    $0x1,%r12b
  707e00:	74 de                	je     707de0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7c0>
  707e02:	45 0f b6 d4          	movzbl %r12b,%r10d
  707e06:	45 85 d2             	test   %r10d,%r10d
  707e09:	75 05                	jne    707e10 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7f0>
  707e0b:	eb 1c                	jmp    707e29 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x809>
  707e0d:	4d 89 d0             	mov    %r10,%r8
  707e10:	48 83 ef 01          	sub    $0x1,%rdi
  707e14:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  707e19:	0f 82 92 00 00 00    	jb     707eb1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x891>
  707e1f:	4a 8b 8c c1 c8 01 00 	mov    0x1c8(%rcx,%r8,8),%rcx
  707e26:	00 
  707e27:	eb 9e                	jmp    707dc7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7a7>
  707e29:	4a 83 7c 09 e0 ff    	cmpq   $0xffffffffffffffff,-0x20(%rcx,%r9,1)
  707e2f:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  707e34:	75 7b                	jne    707eb1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x891>
  707e36:	42 8b 6c 09 e8       	mov    -0x18(%rcx,%r9,1),%ebp
  707e3b:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  707e42:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  707e49:	4c 8d 05 40 bb 3c 00 	lea    0x3cbb40(%rip),%r8        # ad3990 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xd78>
  707e50:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  707e55:	4c 89 f9             	mov    %r15,%rcx
  707e58:	45 31 c9             	xor    %r9d,%r9d
  707e5b:	e8 40 a3 03 00       	call   7421a0 <<gpui::source::Sources<unit_action_cost::Model>>::freeze>
  707e60:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  707e65:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  707e6a:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  707e71:	00 
  707e72:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  707e76:	0f 85 e6 00 00 00    	jne    707f62 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x942>
  707e7c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  707e83:	00 
  707e84:	48 89 cd             	mov    %rcx,%rbp
  707e87:	48 c1 ed 08          	shr    $0x8,%rbp
  707e8b:	b8 20 00 00 00       	mov    $0x20,%eax
  707e90:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  707e95:	89 cf                	mov    %ecx,%edi
  707e97:	e9 bb 12 00 00       	jmp    709157 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  707e9c:	48 89 f9             	mov    %rdi,%rcx
  707e9f:	48 83 e8 01          	sub    $0x1,%rax
  707ea3:	0f 82 f5 0f 00 00    	jb     708e9e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x187e>
  707ea9:	48 8b ac cd c8 01 00 	mov    0x1c8(%rbp,%rcx,8),%rbp
  707eb0:	00 
  707eb1:	0f b7 bd c2 01 00 00 	movzwl 0x1c2(%rbp),%edi
  707eb8:	41 89 f8             	mov    %edi,%r8d
  707ebb:	41 c1 e0 05          	shl    $0x5,%r8d
  707ebf:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  707ec6:	45 31 ed             	xor    %r13d,%r13d
  707ec9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  707ed0:	4d 39 e8             	cmp    %r13,%r8
  707ed3:	74 c7                	je     707e9c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x87c>
  707ed5:	4c 3b bc cd 70 01 00 	cmp    0x170(%rbp,%rcx,8),%r15
  707edc:	00 
  707edd:	41 0f 97 c1          	seta   %r9b
  707ee1:	41 80 d9 00          	sbb    $0x0,%r9b
  707ee5:	49 83 c5 20          	add    $0x20,%r13
  707ee9:	48 ff c1             	inc    %rcx
  707eec:	41 80 f9 01          	cmp    $0x1,%r9b
  707ef0:	74 de                	je     707ed0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x8b0>
  707ef2:	41 0f b6 f9          	movzbl %r9b,%edi
  707ef6:	85 ff                	test   %edi,%edi
  707ef8:	75 a5                	jne    707e9f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x87f>
  707efa:	4a 8b 4c 2d e0       	mov    -0x20(%rbp,%r13,1),%rcx
  707eff:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  707f03:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  707f08:	74 41                	je     707f4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x92b>
  707f0a:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  707f0f:	48 85 c0             	test   %rax,%rax
  707f12:	0f 84 46 01 00 00    	je     70805e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa3e>
  707f18:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  707f1d:	48 ff c8             	dec    %rax
  707f20:	48 bf ff ff ff ff ff 	movabs $0x3fffffffffffffff,%rdi
  707f27:	ff ff 3f 
  707f2a:	48 21 c7             	and    %rax,%rdi
  707f2d:	4c 8d 4f 01          	lea    0x1(%rdi),%r9
  707f31:	45 89 c8             	mov    %r9d,%r8d
  707f34:	41 83 e0 03          	and    $0x3,%r8d
  707f38:	48 83 ff 03          	cmp    $0x3,%rdi
  707f3c:	0f 83 25 01 00 00    	jae    708067 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa47>
  707f42:	31 c0                	xor    %eax,%eax
  707f44:	31 ff                	xor    %edi,%edi
  707f46:	e9 b0 01 00 00       	jmp    7080fb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xadb>
  707f4b:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  707f52:	4c 8d 05 37 ba 3c 00 	lea    0x3cba37(%rip),%r8        # ad3990 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xd78>
  707f59:	31 c0                	xor    %eax,%eax
  707f5b:	31 ff                	xor    %edi,%edi
  707f5d:	e9 d4 01 00 00       	jmp    708136 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xb16>
  707f62:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  707f67:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  707f6c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  707f73:	00 
  707f74:	48 89 84 24 d0 02 00 	mov    %rax,0x2d0(%rsp)
  707f7b:	00 
  707f7c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  707f83:	00 
  707f84:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
  707f8b:	00 
  707f8c:	41 83 fd 02          	cmp    $0x2,%r13d
  707f90:	0f 84 bc 13 00 00    	je     709352 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d32>
  707f96:	4c 89 6c 24 70       	mov    %r13,0x70(%rsp)
  707f9b:	0f 28 84 24 c0 02 00 	movaps 0x2c0(%rsp),%xmm0
  707fa2:	00 
  707fa3:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  707fa8:	48 8b 84 24 d0 02 00 	mov    0x2d0(%rsp),%rax
  707faf:	00 
  707fb0:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  707fb7:	00 
  707fb8:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  707fbf:	00 
  707fc0:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  707fc5:	ba 06 00 00 00       	mov    $0x6,%edx
  707fca:	ff 15 38 95 3f 00    	call   *0x3f9538(%rip)        # b01508 <_DYNAMIC+0x418>
  707fd0:	0f b6 94 24 60 01 00 	movzbl 0x160(%rsp),%edx
  707fd7:	00 
  707fd8:	80 fa ff             	cmp    $0xff,%dl
  707fdb:	0f 84 79 0e 00 00    	je     708e5a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x183a>
  707fe1:	8b 8c 24 63 01 00 00 	mov    0x163(%rsp),%ecx
  707fe8:	0f b6 84 24 67 01 00 	movzbl 0x167(%rsp),%eax
  707fef:	00 
  707ff0:	0f 10 84 24 68 01 00 	movups 0x168(%rsp),%xmm0
  707ff7:	00 
  707ff8:	0f 29 84 24 90 03 00 	movaps %xmm0,0x390(%rsp)
  707fff:	00 
  708000:	8b b4 24 78 01 00 00 	mov    0x178(%rsp),%esi
  708007:	89 b4 24 a0 03 00 00 	mov    %esi,0x3a0(%rsp)
  70800e:	80 fa 02             	cmp    $0x2,%dl
  708011:	0f 85 35 0f 00 00    	jne    708f4c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x192c>
  708017:	89 ea                	mov    %ebp,%edx
  708019:	48 c1 e0 20          	shl    $0x20,%rax
  70801d:	48 09 c8             	or     %rcx,%rax
  708020:	48 c1 e8 08          	shr    $0x8,%rax
  708024:	89 84 24 60 02 00 00 	mov    %eax,0x260(%rsp)
  70802b:	8b 84 24 98 03 00 00 	mov    0x398(%rsp),%eax
  708032:	89 84 24 6c 02 00 00 	mov    %eax,0x26c(%rsp)
  708039:	48 8b 84 24 90 03 00 	mov    0x390(%rsp),%rax
  708040:	00 
  708041:	48 89 84 24 64 02 00 	mov    %rax,0x264(%rsp)
  708048:	00 
  708049:	41 80 be 1f 07 00 00 	cmpb   $0x0,0x71f(%r14)
  708050:	00 
  708051:	0f 84 0c 0f 00 00    	je     708f63 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1943>
  708057:	31 ed                	xor    %ebp,%ebp
  708059:	e9 24 0f 00 00       	jmp    708f82 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1962>
  70805e:	31 ff                	xor    %edi,%edi
  708060:	31 c0                	xor    %eax,%eax
  708062:	e9 b5 00 00 00       	jmp    70811c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xafc>
  708067:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  70806c:	48 b8 00 00 00 00 00 	movabs $0x8000000000000000,%rax
  708073:	00 00 80 
  708076:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  70807a:	49 21 c1             	and    %rax,%r9
  70807d:	31 c0                	xor    %eax,%eax
  70807f:	31 ff                	xor    %edi,%edi
  708081:	44 8b 11             	mov    (%rcx),%r10d
  708084:	44 8b 41 04          	mov    0x4(%rcx),%r8d
  708088:	45 89 d4             	mov    %r10d,%r12d
  70808b:	41 f7 d4             	not    %r12d
  70808e:	41 f6 c4 03          	test   $0x3,%r12b
  708092:	41 0f 94 c4          	sete   %r12b
  708096:	45 89 c3             	mov    %r8d,%r11d
  708099:	41 f7 d3             	not    %r11d
  70809c:	41 f6 c3 03          	test   $0x3,%r11b
  7080a0:	41 0f 94 c3          	sete   %r11b
  7080a4:	45 08 e3             	or     %r12b,%r11b
  7080a7:	8b 51 08             	mov    0x8(%rcx),%edx
  7080aa:	41 89 d4             	mov    %edx,%r12d
  7080ad:	41 f7 d4             	not    %r12d
  7080b0:	41 f6 c4 03          	test   $0x3,%r12b
  7080b4:	41 0f 94 c4          	sete   %r12b
  7080b8:	8b 71 0c             	mov    0xc(%rcx),%esi
  7080bb:	48 83 c1 10          	add    $0x10,%rcx
  7080bf:	21 f2                	and    %esi,%edx
  7080c1:	f7 d6                	not    %esi
  7080c3:	40 f6 c6 03          	test   $0x3,%sil
  7080c7:	40 0f 94 c6          	sete   %sil
  7080cb:	44 08 e6             	or     %r12b,%sil
  7080ce:	44 08 de             	or     %r11b,%sil
  7080d1:	40 08 f7             	or     %sil,%dil
  7080d4:	45 21 c2             	and    %r8d,%r10d
  7080d7:	41 21 d2             	and    %edx,%r10d
  7080da:	41 f7 d2             	not    %r10d
  7080dd:	41 f6 c2 03          	test   $0x3,%r10b
  7080e1:	0f 95 c2             	setne  %dl
  7080e4:	08 d0                	or     %dl,%al
  7080e6:	49 83 c1 fc          	add    $0xfffffffffffffffc,%r9
  7080ea:	75 95                	jne    708081 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa61>
  7080ec:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  7080f1:	4d 85 c0             	test   %r8,%r8
  7080f4:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7080f9:	74 21                	je     70811c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xafc>
  7080fb:	45 31 c9             	xor    %r9d,%r9d
  7080fe:	42 8b 14 89          	mov    (%rcx,%r9,4),%edx
  708102:	83 e2 03             	and    $0x3,%edx
  708105:	83 fa 03             	cmp    $0x3,%edx
  708108:	0f 95 c2             	setne  %dl
  70810b:	40 0f 94 c6          	sete   %sil
  70810f:	40 08 f7             	or     %sil,%dil
  708112:	08 d0                	or     %dl,%al
  708114:	49 ff c1             	inc    %r9
  708117:	4d 39 c8             	cmp    %r9,%r8
  70811a:	75 e2                	jne    7080fe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xade>
  70811c:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  708123:	4e 8b 44 2d f8       	mov    -0x8(%rbp,%r13,1),%r8
  708128:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  70812f:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  708136:	40 0f b6 cf          	movzbl %dil,%ecx
  70813a:	83 e1 01             	and    $0x1,%ecx
  70813d:	89 0c 24             	mov    %ecx,(%rsp)
  708140:	44 0f b6 c8          	movzbl %al,%r9d
  708144:	41 83 e1 01          	and    $0x1,%r9d
  708148:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  70814d:	4c 89 f9             	mov    %r15,%rcx
  708150:	e8 4b a0 03 00       	call   7421a0 <<gpui::source::Sources<unit_action_cost::Model>>::freeze>
  708155:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  70815a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  70815f:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  708166:	00 
  708167:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  70816e:	00 
  70816f:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  708174:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  708179:	48 83 f9 fd          	cmp    $0xfffffffffffffffd,%rcx
  70817d:	75 1d                	jne    70819c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xb7c>
  70817f:	48 89 c5             	mov    %rax,%rbp
  708182:	48 c1 ed 08          	shr    $0x8,%rbp
  708186:	b9 20 00 00 00       	mov    $0x20,%ecx
  70818b:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  708190:	89 c7                	mov    %eax,%edi
  708192:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  708197:	e9 bb 0f 00 00       	jmp    709157 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  70819c:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  7081a1:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  7081a8:	00 
  7081a9:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  7081b0:	00 
  7081b1:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  7081b8:	00 00 
  7081ba:	66 0f 7f 84 24 40 03 	movdqa %xmm0,0x340(%rsp)
  7081c1:	00 00 
  7081c3:	48 83 7c 24 08 ff    	cmpq   $0xffffffffffffffff,0x8(%rsp)
  7081c9:	0f 84 69 0c 00 00    	je     708e38 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1818>
  7081cf:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  7081d4:	48 85 c0             	test   %rax,%rax
  7081d7:	0f 84 5b 0c 00 00    	je     708e38 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1818>
  7081dd:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  7081e2:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  7081e7:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  7081ec:	48 c1 e0 02          	shl    $0x2,%rax
  7081f0:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7081f5:	8b 44 24 18          	mov    0x18(%rsp),%eax
  7081f9:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  708200:	00 
  708201:	45 31 e4             	xor    %r12d,%r12d
  708204:	48 83 f8 02          	cmp    $0x2,%rax
  708208:	0f 85 72 0b 00 00    	jne    708d80 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1760>
  70820e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708213:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  708217:	ff 15 e3 92 3f 00    	call   *0x3f92e3(%rip)        # b01500 <_DYNAMIC+0x410>
  70821d:	66 85 c0             	test   %ax,%ax
  708220:	0f 85 ba 12 00 00    	jne    7094e0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ec0>
  708226:	49 83 c4 04          	add    $0x4,%r12
  70822a:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  70822f:	75 dd                	jne    70820e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xbee>
  708231:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  708236:	48 85 c0             	test   %rax,%rax
  708239:	0f 84 dd 0d 00 00    	je     70901c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x19fc>
  70823f:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  708244:	48 89 8c 24 48 01 00 	mov    %rcx,0x148(%rsp)
  70824b:	00 
  70824c:	48 c1 e0 02          	shl    $0x2,%rax
  708250:	f3 0f 7e 44 24 30    	movq   0x30(%rsp),%xmm0
  708256:	66 0f 6f 0d 92 d4 95 	movdqa -0x6a2b6e(%rip),%xmm1        # 656f0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x9e0>
  70825d:	ff 
  70825e:	66 0f 6c c8          	punpcklqdq %xmm0,%xmm1
  708262:	66 0f 7f 8c 24 b0 03 	movdqa %xmm1,0x3b0(%rsp)
  708269:	00 00 
  70826b:	48 c7 84 24 d0 00 00 	movq   $0x0,0xd0(%rsp)
  708272:	00 00 00 00 00 
  708277:	48 8d 0d 52 b7 3c 00 	lea    0x3cb752(%rip),%rcx        # ad39d0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xdb8>
  70827e:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  708283:	48 b9 00 00 00 00 00 	movabs $0x8000000000000000,%rcx
  70828a:	00 00 80 
  70828d:	48 ff c1             	inc    %rcx
  708290:	48 89 8c 24 38 01 00 	mov    %rcx,0x138(%rsp)
  708297:	00 
  708298:	48 8d 0d 05 12 96 ff 	lea    -0x69edfb(%rip),%rcx        # 694a4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e14>
  70829f:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  7082a6:	00 
  7082a7:	48 8d 0d b2 b7 3c 00 	lea    0x3cb7b2(%rip),%rcx        # ad3a60 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xe48>
  7082ae:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  7082b5:	00 
  7082b6:	48 8d 0d 2b b7 3c 00 	lea    0x3cb72b(%rip),%rcx        # ad39e8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xdd0>
  7082bd:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  7082c4:	00 
  7082c5:	48 8d 0d af 11 96 ff 	lea    -0x69ee51(%rip),%rcx        # 6947b <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2deb>
  7082cc:	48 89 8c 24 e0 00 00 	mov    %rcx,0xe0(%rsp)
  7082d3:	00 
  7082d4:	48 8d 0d dd ab 3c 00 	lea    0x3cabdd(%rip),%rcx        # ad2eb8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x2a0>
  7082db:	48 89 8c 24 b8 01 00 	mov    %rcx,0x1b8(%rsp)
  7082e2:	00 
  7082e3:	31 c9                	xor    %ecx,%ecx
  7082e5:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  7082ec:	00 00 00 00 00 
  7082f1:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  7082f8:	00 00 00 00 00 
  7082fd:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  708304:	00 00 
  708306:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  70830b:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  708312:	00 
  708313:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  708318:	8b 2c 08             	mov    (%rax,%rcx,1),%ebp
  70831b:	49 ff 86 c0 06 00 00 	incq   0x6c0(%r14)
  708322:	89 e8                	mov    %ebp,%eax
  708324:	c1 e8 0f             	shr    $0xf,%eax
  708327:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70832e:	48 39 c6             	cmp    %rax,%rsi
  708331:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  708336:	0f 86 7c 11 00 00    	jbe    7094b8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e98>
  70833c:	4d 8b a6 98 02 00 00 	mov    0x298(%r14),%r12
  708343:	4c 8d 2c 80          	lea    (%rax,%rax,4),%r13
  708347:	4b 8b 04 ec          	mov    (%r12,%r13,8),%rax
  70834b:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  708350:	89 ef                	mov    %ebp,%edi
  708352:	ff 15 a8 91 3f 00    	call   *0x3f91a8(%rip)        # b01500 <_DYNAMIC+0x410>
  708358:	89 44 24 08          	mov    %eax,0x8(%rsp)
  70835c:	4b 8d 04 ec          	lea    (%r12,%r13,8),%rax
  708360:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  708367:	00 
  708368:	8b 54 24 08          	mov    0x8(%rsp),%edx
  70836c:	66 85 d2             	test   %dx,%dx
  70836f:	0f 84 31 01 00 00    	je     7084a6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xe86>
  708375:	83 bc 24 60 03 00 00 	cmpl   $0x2,0x360(%rsp)
  70837c:	02 
  70837d:	0f 84 6d 0f 00 00    	je     7092f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cd0>
  708383:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  708388:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  70838d:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  708394:	00 
  708395:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  70839a:	48 89 41 10          	mov    %rax,0x10(%rcx)
  70839e:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  7083a5:	00 00 
  7083a7:	f3 0f 7f 01          	movdqu %xmm0,(%rcx)
  7083ab:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  7083b2:	00 
  7083b3:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  7083b8:	ff 15 4a 91 3f 00    	call   *0x3f914a(%rip)        # b01508 <_DYNAMIC+0x418>
  7083be:	0f b6 84 24 60 01 00 	movzbl 0x160(%rsp),%eax
  7083c5:	00 
  7083c6:	3c ff                	cmp    $0xff,%al
  7083c8:	0f 84 10 0d 00 00    	je     7090de <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1abe>
  7083ce:	0f b7 8c 24 61 01 00 	movzwl 0x161(%rsp),%ecx
  7083d5:	00 
  7083d6:	8b 94 24 63 01 00 00 	mov    0x163(%rsp),%edx
  7083dd:	0f b6 b4 24 67 01 00 	movzbl 0x167(%rsp),%esi
  7083e4:	00 
  7083e5:	4c 8d 84 24 68 01 00 	lea    0x168(%rsp),%r8
  7083ec:	00 
  7083ed:	41 8b 78 10          	mov    0x10(%r8),%edi
  7083f1:	4c 8d 8c 24 7c 03 00 	lea    0x37c(%rsp),%r9
  7083f8:	00 
  7083f9:	41 89 79 10          	mov    %edi,0x10(%r9)
  7083fd:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
  708402:	f3 41 0f 7f 01       	movdqu %xmm0,(%r9)
  708407:	88 84 24 74 03 00 00 	mov    %al,0x374(%rsp)
  70840e:	66 89 8c 24 75 03 00 	mov    %cx,0x375(%rsp)
  708415:	00 
  708416:	40 88 b4 24 7b 03 00 	mov    %sil,0x37b(%rsp)
  70841d:	00 
  70841e:	89 94 24 77 03 00 00 	mov    %edx,0x377(%rsp)
  708425:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  708429:	44 0f b7 e9          	movzwl %cx,%r13d
  70842d:	48 8d 05 34 b9 3c 00 	lea    0x3cb934(%rip),%rax        # ad3d68 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x1150>
  708434:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  708439:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  70843d:	0f 84 c7 00 00 00    	je     70850a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xeea>
  708443:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  708448:	49 8d b6 10 06 00 00 	lea    0x610(%r14),%rsi
  70844f:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  708454:	4c 8d 84 24 74 03 00 	lea    0x374(%rsp),%r8
  70845b:	00 
  70845c:	ff 15 ae 90 3f 00    	call   *0x3f90ae(%rip)        # b01510 <_DYNAMIC+0x420>
  708462:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  708467:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  70846c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708470:	0f 85 ab 0d 00 00    	jne    709221 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c01>
  708476:	40 80 ff 01          	cmp    $0x1,%dil
  70847a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70847f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  708484:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  708489:	0f 85 9e 08 00 00    	jne    708d2d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x170d>
  70848f:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  708496:	01 
  708497:	b0 01                	mov    $0x1,%al
  708499:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  7084a0:	00 
  7084a1:	e9 4e 08 00 00       	jmp    708cf4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16d4>
  7084a6:	48 83 7c 24 60 fe    	cmpq   $0xfffffffffffffffe,0x60(%rsp)
  7084ac:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7084b1:	0f 84 59 0e 00 00    	je     709310 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cf0>
  7084b7:	83 e5 03             	and    $0x3,%ebp
  7084ba:	8d 45 ff             	lea    -0x1(%rbp),%eax
  7084bd:	83 f8 02             	cmp    $0x2,%eax
  7084c0:	0f 83 8a 00 00 00    	jae    708550 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf30>
  7084c6:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  7084cd:	48 8b 38             	mov    (%rax),%rdi
  7084d0:	41 bc 2b 00 00 00    	mov    $0x2b,%r12d
  7084d6:	48 85 ff             	test   %rdi,%rdi
  7084d9:	0f 84 19 0e 00 00    	je     7092f8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cd8>
  7084df:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  7084e4:	ff 15 2e 90 3f 00    	call   *0x3f902e(%rip)        # b01518 <_DYNAMIC+0x428>
  7084ea:	48 85 c0             	test   %rax,%rax
  7084ed:	0f 84 05 0e 00 00    	je     7092f8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cd8>
  7084f3:	83 fd 01             	cmp    $0x1,%ebp
  7084f6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7084fb:	0f 85 a6 00 00 00    	jne    7085a7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf87>
  708501:	48 8b 78 08          	mov    0x8(%rax),%rdi
  708505:	e9 a1 00 00 00       	jmp    7085ab <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf8b>
  70850a:	49 8d 86 00 02 00 00 	lea    0x200(%r14),%rax
  708511:	48 8b 00             	mov    (%rax),%rax
  708514:	48 8d 15 7d dc 95 ff 	lea    -0x6a2383(%rip),%rdx        # 66198 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1488>
  70851b:	48 63 0c 82          	movslq (%rdx,%rax,4),%rcx
  70851f:	48 01 d1             	add    %rdx,%rcx
  708522:	48 8d 05 6b e3 95 ff 	lea    -0x6a1c95(%rip),%rax        # 66894 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x204>
  708529:	ff e1                	jmp    *%rcx
  70852b:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  708532:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  708537:	48 39 c6             	cmp    %rax,%rsi
  70853a:	0f 86 3a 0f 00 00    	jbe    70947a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e5a>
  708540:	48 6b c0 58          	imul   $0x58,%rax,%rax
  708544:	49 03 86 10 02 00 00 	add    0x210(%r14),%rax
  70854b:	e9 4e 03 00 00       	jmp    70889e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x127e>
  708550:	85 ed                	test   %ebp,%ebp
  708552:	0f 85 18 0e 00 00    	jne    709370 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d50>
  708558:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  70855f:	00 
  708560:	8b 40 20             	mov    0x20(%rax),%eax
  708563:	89 c1                	mov    %eax,%ecx
  708565:	83 e1 07             	and    $0x7,%ecx
  708568:	83 f9 06             	cmp    $0x6,%ecx
  70856b:	74 74                	je     7085e1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  70856d:	c1 e8 03             	shr    $0x3,%eax
  708570:	74 6f                	je     7085e1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  708572:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  708579:	ff c8                	dec    %eax
  70857b:	48 39 c6             	cmp    %rax,%rsi
  70857e:	0f 86 23 0f 00 00    	jbe    7094a7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e87>
  708584:	49 8b 8e b0 02 00 00 	mov    0x2b0(%r14),%rcx
  70858b:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  70858f:	48 c1 e0 04          	shl    $0x4,%rax
  708593:	48 83 3c 01 fe       	cmpq   $0xfffffffffffffffe,(%rcx,%rax,1)
  708598:	0f 84 59 0e 00 00    	je     7093f7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1dd7>
  70859e:	48 01 c1             	add    %rax,%rcx
  7085a1:	48 8b 79 40          	mov    0x40(%rcx),%rdi
  7085a5:	eb 13                	jmp    7085ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf9a>
  7085a7:	48 8b 78 10          	mov    0x10(%rax),%rdi
  7085ab:	b0 01                	mov    $0x1,%al
  7085ad:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  7085b4:	00 
  7085b5:	48 85 ff             	test   %rdi,%rdi
  7085b8:	74 27                	je     7085e1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  7085ba:	48 8b 07             	mov    (%rdi),%rax
  7085bd:	48 d1 e8             	shr    $1,%rax
  7085c0:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  7085c5:	48 39 d0             	cmp    %rdx,%rax
  7085c8:	75 17                	jne    7085e1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  7085ca:	48 83 c7 10          	add    $0x10,%rdi
  7085ce:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  7085d3:	ff 15 47 8f 3f 00    	call   *0x3f8f47(%rip)        # b01520 <bcmp@GLIBC_2.2.5>
  7085d9:	85 c0                	test   %eax,%eax
  7085db:	0f 84 3a 06 00 00    	je     708c1b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x15fb>
  7085e1:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  7085e6:	4d 85 e4             	test   %r12,%r12
  7085e9:	75 6d                	jne    708658 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1038>
  7085eb:	4c 8d 25 2e d9 95 ff 	lea    -0x6a26d2(%rip),%r12        # 65f20 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1210>
  7085f2:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  7085f7:	48 85 f6             	test   %rsi,%rsi
  7085fa:	74 41                	je     70863d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x101d>
  7085fc:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  708603:	00 00 
  708605:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  70860a:	31 d2                	xor    %edx,%edx
  70860c:	31 c9                	xor    %ecx,%ecx
  70860e:	ff 15 14 8f 3f 00    	call   *0x3f8f14(%rip)        # b01528 <_DYNAMIC+0x438>
  708614:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  708619:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  70861d:	0f 85 6e 0e 00 00    	jne    709491 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e71>
  708623:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
  708628:	49 8d 7c 24 10       	lea    0x10(%r12),%rdi
  70862d:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  708632:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  708637:	ff 15 23 8d 3f 00    	call   *0x3f8d23(%rip)        # b01360 <memcpy@GLIBC_2.14>
  70863d:	f3 41 0f 6f 86 c8 06 	movdqu 0x6c8(%r14),%xmm0
  708644:	00 00 
  708646:	66 0f d4 84 24 b0 03 	paddq  0x3b0(%rsp),%xmm0
  70864d:	00 00 
  70864f:	f3 41 0f 7f 86 c8 06 	movdqu %xmm0,0x6c8(%r14)
  708656:	00 00 
  708658:	85 ed                	test   %ebp,%ebp
  70865a:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  70865f:	0f 84 b1 00 00 00    	je     708716 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10f6>
  708665:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  70866c:	48 8b 38             	mov    (%rax),%rdi
  70866f:	41 bd 2b 00 00 00    	mov    $0x2b,%r13d
  708675:	48 85 ff             	test   %rdi,%rdi
  708678:	0f 84 2e 0d 00 00    	je     7093ac <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d8c>
  70867e:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  708683:	ff 15 a7 8e 3f 00    	call   *0x3f8ea7(%rip)        # b01530 <_DYNAMIC+0x440>
  708689:	48 85 c0             	test   %rax,%rax
  70868c:	0f 84 1a 0d 00 00    	je     7093ac <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d8c>
  708692:	83 fd 01             	cmp    $0x1,%ebp
  708695:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70869a:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  70869f:	0f 85 4d 01 00 00    	jne    7087f2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11d2>
  7086a5:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  7086aa:	48 85 c9             	test   %rcx,%rcx
  7086ad:	74 2c                	je     7086db <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  7086af:	f6 01 01             	testb  $0x1,(%rcx)
  7086b2:	75 27                	jne    7086db <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  7086b4:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  7086b8:	f6 c2 01             	test   $0x1,%dl
  7086bb:	75 1e                	jne    7086db <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  7086bd:	ba 02 00 00 00       	mov    $0x2,%edx
  7086c2:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  7086c8:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  7086cf:	00 
  7086d0:	48 f7 da             	neg    %rdx
  7086d3:	71 06                	jno    7086db <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  7086d5:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  7086db:	48 89 c5             	mov    %rax,%rbp
  7086de:	48 8b 78 08          	mov    0x8(%rax),%rdi
  7086e2:	48 85 ff             	test   %rdi,%rdi
  7086e5:	74 1c                	je     708703 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  7086e7:	f6 07 01             	testb  $0x1,(%rdi)
  7086ea:	75 17                	jne    708703 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  7086ec:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7086f0:	a8 01                	test   $0x1,%al
  7086f2:	75 0f                	jne    708703 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  7086f4:	48 8d 47 08          	lea    0x8(%rdi),%rax
  7086f8:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  7086fd:	0f 84 50 06 00 00    	je     708d53 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1733>
  708703:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  708708:	48 89 45 08          	mov    %rax,0x8(%rbp)
  70870c:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  708711:	e9 de 05 00 00       	jmp    708cf4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16d4>
  708716:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  70871d:	00 
  70871e:	8b 78 20             	mov    0x20(%rax),%edi
  708721:	89 f8                	mov    %edi,%eax
  708723:	83 e0 07             	and    $0x7,%eax
  708726:	41 bd 16 00 00 00    	mov    $0x16,%r13d
  70872c:	83 f8 06             	cmp    $0x6,%eax
  70872f:	0f 84 59 0c 00 00    	je     70938e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d6e>
  708735:	c1 ef 03             	shr    $0x3,%edi
  708738:	0f 84 50 0c 00 00    	je     70938e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d6e>
  70873e:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  708745:	ff cf                	dec    %edi
  708747:	48 39 fe             	cmp    %rdi,%rsi
  70874a:	0f 86 01 0d 00 00    	jbe    709451 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e31>
  708750:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  708757:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  70875b:	48 c1 e0 04          	shl    $0x4,%rax
  70875f:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  708765:	0f 84 5f 0c 00 00    	je     7093ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1daa>
  70876b:	4d 85 e4             	test   %r12,%r12
  70876e:	0f 84 68 0c 00 00    	je     7093dc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1dbc>
  708774:	41 f6 04 24 01       	testb  $0x1,(%r12)
  708779:	75 2a                	jne    7087a5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1185>
  70877b:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  708780:	f6 c1 01             	test   $0x1,%cl
  708783:	75 20                	jne    7087a5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1185>
  708785:	b9 02 00 00 00       	mov    $0x2,%ecx
  70878a:	f0 49 0f c1 4c 24 08 	lock xadd %rcx,0x8(%r12)
  708791:	48 23 8c 24 38 01 00 	and    0x138(%rsp),%rcx
  708798:	00 
  708799:	48 f7 d9             	neg    %rcx
  70879c:	71 07                	jno    7087a5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1185>
  70879e:	f0 49 83 4c 24 08 01 	lock orq $0x1,0x8(%r12)
  7087a5:	48 01 c5             	add    %rax,%rbp
  7087a8:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  7087ac:	f6 07 01             	testb  $0x1,(%rdi)
  7087af:	75 17                	jne    7087c8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11a8>
  7087b1:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7087b5:	a8 01                	test   $0x1,%al
  7087b7:	75 0f                	jne    7087c8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11a8>
  7087b9:	48 8d 47 08          	lea    0x8(%rdi),%rax
  7087bd:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  7087c2:	0f 84 7c 05 00 00    	je     708d44 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1724>
  7087c8:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  7087cc:	48 89 ef             	mov    %rbp,%rdi
  7087cf:	e8 bc 8c ff ff       	call   701490 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  7087d4:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  7087db:	ff 
  7087dc:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  7087e3:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  7087e8:	e8 a3 86 01 00       	call   720e90 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  7087ed:	e9 e1 04 00 00       	jmp    708cd3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16b3>
  7087f2:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  7087f7:	48 85 c9             	test   %rcx,%rcx
  7087fa:	74 2c                	je     708828 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  7087fc:	f6 01 01             	testb  $0x1,(%rcx)
  7087ff:	75 27                	jne    708828 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  708801:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  708805:	f6 c2 01             	test   $0x1,%dl
  708808:	75 1e                	jne    708828 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  70880a:	ba 02 00 00 00       	mov    $0x2,%edx
  70880f:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  708815:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  70881c:	00 
  70881d:	48 f7 da             	neg    %rdx
  708820:	71 06                	jno    708828 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  708822:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  708828:	48 89 c5             	mov    %rax,%rbp
  70882b:	48 8b 78 10          	mov    0x10(%rax),%rdi
  70882f:	48 85 ff             	test   %rdi,%rdi
  708832:	74 1c                	je     708850 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  708834:	f6 07 01             	testb  $0x1,(%rdi)
  708837:	75 17                	jne    708850 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  708839:	48 8b 47 08          	mov    0x8(%rdi),%rax
  70883d:	a8 01                	test   $0x1,%al
  70883f:	75 0f                	jne    708850 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  708841:	48 8d 47 08          	lea    0x8(%rdi),%rax
  708845:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  70884a:	0f 84 12 05 00 00    	je     708d62 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1742>
  708850:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  708855:	48 89 45 10          	mov    %rax,0x10(%rbp)
  708859:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  70885e:	e9 91 04 00 00       	jmp    708cf4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16d4>
  708863:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  70886a:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  70886f:	48 39 ce             	cmp    %rcx,%rsi
  708872:	0f 86 eb 0b 00 00    	jbe    709463 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e43>
  708878:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  70887f:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  708886:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
  70888a:	48 39 c6             	cmp    %rax,%rsi
  70888d:	0f 86 d9 0b 00 00    	jbe    70946c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e4c>
  708893:	48 6b c0 58          	imul   $0x58,%rax,%rax
  708897:	49 03 86 08 02 00 00 	add    0x208(%r14),%rax
  70889e:	48 8b 48 50          	mov    0x50(%rax),%rcx
  7088a2:	48 89 8c 24 b0 02 00 	mov    %rcx,0x2b0(%rsp)
  7088a9:	00 
  7088aa:	0f 10 40 40          	movups 0x40(%rax),%xmm0
  7088ae:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
  7088b5:	00 
  7088b6:	f3 0f 6f 00          	movdqu (%rax),%xmm0
  7088ba:	f3 0f 6f 48 10       	movdqu 0x10(%rax),%xmm1
  7088bf:	0f 10 50 20          	movups 0x20(%rax),%xmm2
  7088c3:	0f 10 58 30          	movups 0x30(%rax),%xmm3
  7088c7:	0f 29 9c 24 90 02 00 	movaps %xmm3,0x290(%rsp)
  7088ce:	00 
  7088cf:	0f 29 94 24 80 02 00 	movaps %xmm2,0x280(%rsp)
  7088d6:	00 
  7088d7:	66 0f 7f 8c 24 70 02 	movdqa %xmm1,0x270(%rsp)
  7088de:	00 00 
  7088e0:	66 0f 7f 84 24 60 02 	movdqa %xmm0,0x260(%rsp)
  7088e7:	00 00 
  7088e9:	eb 1a                	jmp    708905 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x12e5>
  7088eb:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  7088f2:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
  7088f9:	00 
  7088fa:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  7088ff:	ff 15 43 8b 3f 00    	call   *0x3f8b43(%rip)        # b01448 <_DYNAMIC+0x358>
  708905:	48 8b 84 24 b0 02 00 	mov    0x2b0(%rsp),%rax
  70890c:	00 
  70890d:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  708914:	00 
  708915:	0f 28 84 24 a0 02 00 	movaps 0x2a0(%rsp),%xmm0
  70891c:	00 
  70891d:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  708924:	00 
  708925:	66 0f 6f 84 24 60 02 	movdqa 0x260(%rsp),%xmm0
  70892c:	00 00 
  70892e:	66 0f 6f 8c 24 70 02 	movdqa 0x270(%rsp),%xmm1
  708935:	00 00 
  708937:	0f 28 94 24 80 02 00 	movaps 0x280(%rsp),%xmm2
  70893e:	00 
  70893f:	0f 28 9c 24 90 02 00 	movaps 0x290(%rsp),%xmm3
  708946:	00 
  708947:	0f 29 9c 24 a0 00 00 	movaps %xmm3,0xa0(%rsp)
  70894e:	00 
  70894f:	0f 29 94 24 90 00 00 	movaps %xmm2,0x90(%rsp)
  708956:	00 
  708957:	66 0f 7f 8c 24 80 00 	movdqa %xmm1,0x80(%rsp)
  70895e:	00 00 
  708960:	66 0f 7f 44 24 70    	movdqa %xmm0,0x70(%rsp)
  708966:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  70896d:	00 
  70896e:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  708975:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  70897a:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  70897f:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  708984:	4c 8d 8c 24 74 03 00 	lea    0x374(%rsp),%r9
  70898b:	00 
  70898c:	e8 6f 80 02 00       	call   730a00 <<gpui::property::Overrides>::update_base>
  708991:	8b 84 24 60 01 00 00 	mov    0x160(%rsp),%eax
  708998:	8b 8c 24 65 01 00 00 	mov    0x165(%rsp),%ecx
  70899f:	0f b6 ac 24 69 01 00 	movzbl 0x169(%rsp),%ebp
  7089a6:	00 
  7089a7:	48 c1 e5 20          	shl    $0x20,%rbp
  7089ab:	48 09 cd             	or     %rcx,%rbp
  7089ae:	0f b6 bc 24 64 01 00 	movzbl 0x164(%rsp),%edi
  7089b5:	00 
  7089b6:	83 f8 02             	cmp    $0x2,%eax
  7089b9:	0f 84 ba 08 00 00    	je     709279 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c59>
  7089bf:	48 8d 8c 24 68 01 00 	lea    0x168(%rsp),%rcx
  7089c6:	00 
  7089c7:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  7089cb:	48 8d 94 24 ca 01 00 	lea    0x1ca(%rsp),%rdx
  7089d2:	00 
  7089d3:	0f 11 42 3e          	movups %xmm0,0x3e(%rdx)
  7089d7:	0f 10 41 02          	movups 0x2(%rcx),%xmm0
  7089db:	0f 10 49 12          	movups 0x12(%rcx),%xmm1
  7089df:	0f 10 51 22          	movups 0x22(%rcx),%xmm2
  7089e3:	0f 10 59 32          	movups 0x32(%rcx),%xmm3
  7089e7:	0f 11 5a 30          	movups %xmm3,0x30(%rdx)
  7089eb:	0f 11 52 20          	movups %xmm2,0x20(%rdx)
  7089ef:	0f 11 4a 10          	movups %xmm1,0x10(%rdx)
  7089f3:	0f 11 02             	movups %xmm0,(%rdx)
  7089f6:	89 84 24 c0 01 00 00 	mov    %eax,0x1c0(%rsp)
  7089fd:	40 88 bc 24 c4 01 00 	mov    %dil,0x1c4(%rsp)
  708a04:	00 
  708a05:	48 89 e8             	mov    %rbp,%rax
  708a08:	48 c1 e8 20          	shr    $0x20,%rax
  708a0c:	88 84 24 c9 01 00 00 	mov    %al,0x1c9(%rsp)
  708a13:	89 ac 24 c5 01 00 00 	mov    %ebp,0x1c5(%rsp)
  708a1a:	f3 0f 6f 84 24 d0 01 	movdqu 0x1d0(%rsp),%xmm0
  708a21:	00 00 
  708a23:	f3 0f 6f 8c 24 e0 01 	movdqu 0x1e0(%rsp),%xmm1
  708a2a:	00 00 
  708a2c:	0f 10 94 24 f0 01 00 	movups 0x1f0(%rsp),%xmm2
  708a33:	00 
  708a34:	0f 10 9c 24 00 02 00 	movups 0x200(%rsp),%xmm3
  708a3b:	00 
  708a3c:	66 0f 7f 84 24 d0 02 	movdqa %xmm0,0x2d0(%rsp)
  708a43:	00 00 
  708a45:	66 0f 7f 8c 24 e0 02 	movdqa %xmm1,0x2e0(%rsp)
  708a4c:	00 00 
  708a4e:	0f 29 94 24 f0 02 00 	movaps %xmm2,0x2f0(%rsp)
  708a55:	00 
  708a56:	0f 29 9c 24 00 03 00 	movaps %xmm3,0x300(%rsp)
  708a5d:	00 
  708a5e:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  708a65:	00 
  708a66:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  708a6d:	00 
  708a6e:	8b 84 24 c0 01 00 00 	mov    0x1c0(%rsp),%eax
  708a75:	89 84 24 c0 02 00 00 	mov    %eax,0x2c0(%rsp)
  708a7c:	0f b6 84 24 c4 01 00 	movzbl 0x1c4(%rsp),%eax
  708a83:	00 
  708a84:	88 84 24 c4 02 00 00 	mov    %al,0x2c4(%rsp)
  708a8b:	8b 84 24 c5 01 00 00 	mov    0x1c5(%rsp),%eax
  708a92:	89 84 24 c5 02 00 00 	mov    %eax,0x2c5(%rsp)
  708a99:	0f b6 84 24 c9 01 00 	movzbl 0x1c9(%rsp),%eax
  708aa0:	00 
  708aa1:	88 84 24 c9 02 00 00 	mov    %al,0x2c9(%rsp)
  708aa8:	8b 84 24 ca 01 00 00 	mov    0x1ca(%rsp),%eax
  708aaf:	89 84 24 ca 02 00 00 	mov    %eax,0x2ca(%rsp)
  708ab6:	0f b7 84 24 ce 01 00 	movzwl 0x1ce(%rsp),%eax
  708abd:	00 
  708abe:	66 89 84 24 ce 02 00 	mov    %ax,0x2ce(%rsp)
  708ac5:	00 
  708ac6:	0f b6 84 24 c0 02 00 	movzbl 0x2c0(%rsp),%eax
  708acd:	00 
  708ace:	83 bc 24 60 02 00 00 	cmpl   $0x1,0x260(%rsp)
  708ad5:	01 
  708ad6:	75 1a                	jne    708af2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x14d2>
  708ad8:	8b 8c 24 c4 02 00 00 	mov    0x2c4(%rsp),%ecx
  708adf:	39 8c 24 64 02 00 00 	cmp    %ecx,0x264(%rsp)
  708ae6:	0f 94 c1             	sete   %cl
  708ae9:	84 c8                	test   %cl,%al
  708aeb:	75 0d                	jne    708afa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x14da>
  708aed:	e9 38 01 00 00       	jmp    708c2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  708af2:	a8 01                	test   $0x1,%al
  708af4:	0f 85 30 01 00 00    	jne    708c2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  708afa:	0f b6 84 24 c8 02 00 	movzbl 0x2c8(%rsp),%eax
  708b01:	00 
  708b02:	83 bc 24 68 02 00 00 	cmpl   $0x1,0x268(%rsp)
  708b09:	01 
  708b0a:	75 1b                	jne    708b27 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1507>
  708b0c:	8b 8c 24 cc 02 00 00 	mov    0x2cc(%rsp),%ecx
  708b13:	39 8c 24 6c 02 00 00 	cmp    %ecx,0x26c(%rsp)
  708b1a:	0f 94 c1             	sete   %cl
  708b1d:	84 c8                	test   %cl,%al
  708b1f:	0f 84 05 01 00 00    	je     708c2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  708b25:	eb 08                	jmp    708b2f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x150f>
  708b27:	a8 01                	test   $0x1,%al
  708b29:	0f 85 fb 00 00 00    	jne    708c2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  708b2f:	8b 84 24 70 02 00 00 	mov    0x270(%rsp),%eax
  708b36:	3b 84 24 d0 02 00 00 	cmp    0x2d0(%rsp),%eax
  708b3d:	0f 85 e7 00 00 00    	jne    708c2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  708b43:	8b 84 24 74 02 00 00 	mov    0x274(%rsp),%eax
  708b4a:	3b 84 24 d4 02 00 00 	cmp    0x2d4(%rsp),%eax
  708b51:	0f 85 d3 00 00 00    	jne    708c2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  708b57:	8b 84 24 78 02 00 00 	mov    0x278(%rsp),%eax
  708b5e:	3b 84 24 d8 02 00 00 	cmp    0x2d8(%rsp),%eax
  708b65:	0f 85 bf 00 00 00    	jne    708c2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  708b6b:	0f b6 84 24 b4 02 00 	movzbl 0x2b4(%rsp),%eax
  708b72:	00 
  708b73:	3a 84 24 14 03 00 00 	cmp    0x314(%rsp),%al
  708b7a:	0f 85 aa 00 00 00    	jne    708c2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  708b80:	0f b6 84 24 b6 02 00 	movzbl 0x2b6(%rsp),%eax
  708b87:	00 
  708b88:	3a 84 24 16 03 00 00 	cmp    0x316(%rsp),%al
  708b8f:	0f 85 95 00 00 00    	jne    708c2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  708b95:	0f b6 84 24 b7 02 00 	movzbl 0x2b7(%rsp),%eax
  708b9c:	00 
  708b9d:	3a 84 24 17 03 00 00 	cmp    0x317(%rsp),%al
  708ba4:	0f 85 80 00 00 00    	jne    708c2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  708baa:	0f b6 84 24 b5 02 00 	movzbl 0x2b5(%rsp),%eax
  708bb1:	00 
  708bb2:	3a 84 24 15 03 00 00 	cmp    0x315(%rsp),%al
  708bb9:	75 6f                	jne    708c2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  708bbb:	48 8d bc 24 9c 02 00 	lea    0x29c(%rsp),%rdi
  708bc2:	00 
  708bc3:	48 8d b4 24 fc 02 00 	lea    0x2fc(%rsp),%rsi
  708bca:	00 
  708bcb:	e8 60 67 01 00       	call   71f330 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  708bd0:	84 c0                	test   %al,%al
  708bd2:	74 56                	je     708c2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  708bd4:	f3 0f 6f 84 24 7c 02 	movdqu 0x27c(%rsp),%xmm0
  708bdb:	00 00 
  708bdd:	f3 0f 6f 8c 24 dc 02 	movdqu 0x2dc(%rsp),%xmm1
  708be4:	00 00 
  708be6:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  708bea:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  708bee:	3d ff ff 00 00       	cmp    $0xffff,%eax
  708bf3:	75 35                	jne    708c2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  708bf5:	f3 0f 6f 84 24 8c 02 	movdqu 0x28c(%rsp),%xmm0
  708bfc:	00 00 
  708bfe:	f3 0f 6f 8c 24 ec 02 	movdqu 0x2ec(%rsp),%xmm1
  708c05:	00 00 
  708c07:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  708c0b:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  708c0f:	3d ff ff 00 00       	cmp    $0xffff,%eax
  708c14:	75 14                	jne    708c2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  708c16:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  708c1b:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  708c20:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  708c25:	e9 08 01 00 00       	jmp    708d32 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1712>
  708c2a:	48 8d 05 37 b1 3c 00 	lea    0x3cb137(%rip),%rax        # ad3d68 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x1150>
  708c31:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  708c36:	80 78 13 02          	cmpb   $0x2,0x13(%rax)
  708c3a:	75 11                	jne    708c4d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x162d>
  708c3c:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  708c43:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  708c48:	e8 43 82 01 00       	call   720e90 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  708c4d:	66 83 7c 24 08 05    	cmpw   $0x5,0x8(%rsp)
  708c53:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  708c58:	75 5a                	jne    708cb4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1694>
  708c5a:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  708c61:	00 
  708c62:	8b 40 20             	mov    0x20(%rax),%eax
  708c65:	89 c1                	mov    %eax,%ecx
  708c67:	83 e1 07             	and    $0x7,%ecx
  708c6a:	83 f9 06             	cmp    $0x6,%ecx
  708c6d:	74 45                	je     708cb4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1694>
  708c6f:	c1 e8 03             	shr    $0x3,%eax
  708c72:	74 40                	je     708cb4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1694>
  708c74:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  708c7b:	ff c8                	dec    %eax
  708c7d:	48 39 c6             	cmp    %rax,%rsi
  708c80:	0f 86 fd 07 00 00    	jbe    709483 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e63>
  708c86:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  708c8d:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  708c91:	48 c1 e0 04          	shl    $0x4,%rax
  708c95:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  708c9b:	0f 84 65 07 00 00    	je     709406 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1de6>
  708ca1:	48 01 c5             	add    %rax,%rbp
  708ca4:	48 89 ef             	mov    %rbp,%rdi
  708ca7:	e8 e4 87 ff ff       	call   701490 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  708cac:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  708cb3:	ff 
  708cb4:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  708cbb:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  708cc2:	4c 89 e6             	mov    %r12,%rsi
  708cc5:	48 8d 94 24 c0 01 00 	lea    0x1c0(%rsp),%rdx
  708ccc:	00 
  708ccd:	ff 15 65 88 3f 00    	call   *0x3f8865(%rip)        # b01538 <_DYNAMIC+0x448>
  708cd3:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  708cda:	01 
  708cdb:	b0 01                	mov    $0x1,%al
  708cdd:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  708ce4:	00 
  708ce5:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  708cea:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  708cef:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  708cf4:	4c 39 ac 24 50 01 00 	cmp    %r13,0x150(%rsp)
  708cfb:	00 
  708cfc:	0f 94 c0             	sete   %al
  708cff:	84 84 24 d0 00 00 00 	test   %al,0xd0(%rsp)
  708d06:	74 0c                	je     708d14 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16f4>
  708d08:	b0 01                	mov    $0x1,%al
  708d0a:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  708d11:	00 
  708d12:	eb 19                	jmp    708d2d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x170d>
  708d14:	49 ff 86 08 07 00 00 	incq   0x708(%r14)
  708d1b:	b0 01                	mov    $0x1,%al
  708d1d:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  708d24:	00 
  708d25:	4c 89 ac 24 50 01 00 	mov    %r13,0x150(%rsp)
  708d2c:	00 
  708d2d:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  708d32:	48 83 c1 04          	add    $0x4,%rcx
  708d36:	48 39 c8             	cmp    %rcx,%rax
  708d39:	0f 85 cc f5 ff ff    	jne    70830b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xceb>
  708d3f:	e9 ee 02 00 00       	jmp    709032 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a12>
  708d44:	48 8b 47 08          	mov    0x8(%rdi),%rax
  708d48:	ff 15 4a 86 3f 00    	call   *0x3f864a(%rip)        # b01398 <_DYNAMIC+0x2a8>
  708d4e:	e9 75 fa ff ff       	jmp    7087c8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11a8>
  708d53:	48 8b 47 08          	mov    0x8(%rdi),%rax
  708d57:	ff 15 3b 86 3f 00    	call   *0x3f863b(%rip)        # b01398 <_DYNAMIC+0x2a8>
  708d5d:	e9 a1 f9 ff ff       	jmp    708703 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  708d62:	48 8b 47 08          	mov    0x8(%rdi),%rax
  708d66:	ff 15 2c 86 3f 00    	call   *0x3f862c(%rip)        # b01398 <_DYNAMIC+0x2a8>
  708d6c:	e9 df fa ff ff       	jmp    708850 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  708d71:	49 83 c4 04          	add    $0x4,%r12
  708d75:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  708d7a:	0f 84 b1 f4 ff ff    	je     708231 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xc11>
  708d80:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708d85:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  708d89:	ff 15 71 87 3f 00    	call   *0x3f8771(%rip)        # b01500 <_DYNAMIC+0x410>
  708d8f:	66 85 c0             	test   %ax,%ax
  708d92:	74 dd                	je     708d71 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1751>
  708d94:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  708d99:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  708d9e:	48 8b 8c 24 50 03 00 	mov    0x350(%rsp),%rcx
  708da5:	00 
  708da6:	48 8d 54 24 78       	lea    0x78(%rsp),%rdx
  708dab:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
  708daf:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  708db6:	00 00 
  708db8:	f3 0f 7f 02          	movdqu %xmm0,(%rdx)
  708dbc:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  708dc3:	00 
  708dc4:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  708dc9:	89 c2                	mov    %eax,%edx
  708dcb:	ff 15 37 87 3f 00    	call   *0x3f8737(%rip)        # b01508 <_DYNAMIC+0x418>
  708dd1:	80 bc 24 60 01 00 00 	cmpb   $0xff,0x160(%rsp)
  708dd8:	ff 
  708dd9:	75 96                	jne    708d71 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1751>
  708ddb:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  708de2:	00 
  708de3:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  708dea:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  708df1:	00 
  708df2:	48 c1 e5 20          	shl    $0x20,%rbp
  708df6:	48 09 c5             	or     %rax,%rbp
  708df9:	b8 24 00 00 00       	mov    $0x24,%eax
  708dfe:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  708e03:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  708e08:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  708e0d:	48 85 f6             	test   %rsi,%rsi
  708e10:	0f 8e 12 02 00 00    	jle    709028 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a08>
  708e16:	ba 01 00 00 00       	mov    $0x1,%edx
  708e1b:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  708e1f:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  708e24:	ff 15 0e 85 3f 00    	call   *0x3f850e(%rip)        # b01338 <_DYNAMIC+0x248>
  708e2a:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  708e2e:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  708e33:	e9 1f 03 00 00       	jmp    709157 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  708e38:	31 ff                	xor    %edi,%edi
  708e3a:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  708e3f:	48 85 f6             	test   %rsi,%rsi
  708e42:	7e 5c                	jle    708ea0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1880>
  708e44:	ba 01 00 00 00       	mov    $0x1,%edx
  708e49:	89 fd                	mov    %edi,%ebp
  708e4b:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  708e50:	ff 15 e2 84 3f 00    	call   *0x3f84e2(%rip)        # b01338 <_DYNAMIC+0x248>
  708e56:	89 ef                	mov    %ebp,%edi
  708e58:	eb 46                	jmp    708ea0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1880>
  708e5a:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  708e61:	00 
  708e62:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  708e69:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  708e70:	00 
  708e71:	48 c1 e5 20          	shl    $0x20,%rbp
  708e75:	48 09 c5             	or     %rax,%rbp
  708e78:	b8 24 00 00 00       	mov    $0x24,%eax
  708e7d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  708e82:	e9 99 02 00 00       	jmp    709120 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  708e87:	b0 01                	mov    $0x1,%al
  708e89:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  708e8e:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  708e95:	48 85 ed             	test   %rbp,%rbp
  708e98:	0f 85 0e ef ff ff    	jne    707dac <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x78c>
  708e9e:	31 ff                	xor    %edi,%edi
  708ea0:	80 7c 24 40 00       	cmpb   $0x0,0x40(%rsp)
  708ea5:	74 3c                	je     708ee3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x18c3>
  708ea7:	41 80 be 1f 07 00 00 	cmpb   $0x1,0x71f(%r14)
  708eae:	01 
  708eaf:	75 32                	jne    708ee3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x18c3>
  708eb1:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  708eb6:	4c 89 f6             	mov    %r14,%rsi
  708eb9:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  708ec0:	00 
  708ec1:	31 c9                	xor    %ecx,%ecx
  708ec3:	e8 c8 de ff ff       	call   706d90 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>
  708ec8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  708ecd:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708ed1:	75 1e                	jne    708ef1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x18d1>
  708ed3:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  708eda:	ff ff 
  708edc:	31 ff                	xor    %edi,%edi
  708ede:	e9 94 02 00 00       	jmp    709177 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b57>
  708ee3:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  708eea:	ff ff 
  708eec:	e9 86 02 00 00       	jmp    709177 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b57>
  708ef1:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  708ef6:	0f b6 4c 24 7f       	movzbl 0x7f(%rsp),%ecx
  708efb:	c1 e1 10             	shl    $0x10,%ecx
  708efe:	0f b7 54 24 7d       	movzwl 0x7d(%rsp),%edx
  708f03:	09 ca                	or     %ecx,%edx
  708f05:	48 c1 e2 20          	shl    $0x20,%rdx
  708f09:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  708f0d:	48 09 d5             	or     %rdx,%rbp
  708f10:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  708f17:	00 
  708f18:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  708f1f:	00 
  708f20:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  708f27:	00 00 
  708f29:	66 0f 7f 84 24 c0 01 	movdqa %xmm0,0x1c0(%rsp)
  708f30:	00 00 
  708f32:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  708f39:	00 
  708f3a:	48 89 8c 24 d0 01 00 	mov    %rcx,0x1d0(%rsp)
  708f41:	00 
  708f42:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  708f47:	e9 2b 02 00 00       	jmp    709177 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b57>
  708f4c:	b8 20 00 00 00       	mov    $0x20,%eax
  708f51:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  708f56:	40 b7 0c             	mov    $0xc,%dil
  708f59:	31 ed                	xor    %ebp,%ebp
  708f5b:	4d 89 f8             	mov    %r15,%r8
  708f5e:	e9 bd 01 00 00       	jmp    709120 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  708f63:	49 8b 86 90 06 00 00 	mov    0x690(%r14),%rax
  708f6a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  708f6e:	49 3b 8e 60 06 00 00 	cmp    0x660(%r14),%rcx
  708f75:	40 0f 94 c5          	sete   %bpl
  708f79:	48 ff c0             	inc    %rax
  708f7c:	0f 84 d5 f0 ff ff    	je     708057 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa37>
  708f82:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  708f89:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  708f90:	00 
  708f91:	48 8d 8c 24 60 02 00 	lea    0x260(%rsp),%rcx
  708f98:	00 
  708f99:	ff 15 a1 85 3f 00    	call   *0x3f85a1(%rip)        # b01540 <_DYNAMIC+0x450>
  708f9f:	80 bc 24 60 01 00 00 	cmpb   $0x0,0x160(%rsp)
  708fa6:	00 
  708fa7:	74 21                	je     708fca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x19aa>
  708fa9:	8b 94 24 84 01 00 00 	mov    0x184(%rsp),%edx
  708fb0:	49 89 96 08 07 00 00 	mov    %rdx,0x708(%r14)
  708fb7:	40 84 ed             	test   %bpl,%bpl
  708fba:	0f 84 48 01 00 00    	je     709108 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ae8>
  708fc0:	48 8d 94 24 64 01 00 	lea    0x164(%rsp),%rdx
  708fc7:	00 
  708fc8:	eb 16                	jmp    708fe0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x19c0>
  708fca:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  708fd1:	00 00 00 00 
  708fd5:	31 d2                	xor    %edx,%edx
  708fd7:	40 84 ed             	test   %bpl,%bpl
  708fda:	0f 84 28 01 00 00    	je     709108 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ae8>
  708fe0:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  708fe5:	4c 89 f6             	mov    %r14,%rsi
  708fe8:	e8 f3 07 00 00       	call   7097e0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::finish_color_slot>
  708fed:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  708ff2:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  708ff7:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708ffb:	0f 85 8c 00 00 00    	jne    70908d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a6d>
  709001:	40 f6 c7 01          	test   $0x1,%dil
  709005:	0f 84 f6 00 00 00    	je     709101 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ae1>
  70900b:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  709012:	ff ff 
  709014:	40 b7 02             	mov    $0x2,%dil
  709017:	e9 04 01 00 00       	jmp    709120 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  70901c:	31 ff                	xor    %edi,%edi
  70901e:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709023:	e9 12 fe ff ff       	jmp    708e3a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709028:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  70902d:	e9 25 01 00 00       	jmp    709157 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  709032:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  709039:	00 
  70903a:	34 01                	xor    $0x1,%al
  70903c:	0f b6 c0             	movzbl %al,%eax
  70903f:	31 ff                	xor    %edi,%edi
  709041:	f6 84 24 40 01 00 00 	testb  $0x1,0x140(%rsp)
  709048:	01 
  709049:	0f 45 f8             	cmovne %eax,%edi
  70904c:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709051:	48 85 c0             	test   %rax,%rax
  709054:	0f 84 e0 fd ff ff    	je     708e3a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  70905a:	f6 00 01             	testb  $0x1,(%rax)
  70905d:	0f 85 d7 fd ff ff    	jne    708e3a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709063:	89 fd                	mov    %edi,%ebp
  709065:	48 8b 40 08          	mov    0x8(%rax),%rax
  709069:	a8 01                	test   $0x1,%al
  70906b:	75 14                	jne    709081 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a61>
  70906d:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709072:	48 83 c0 08          	add    $0x8,%rax
  709076:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  70907b:	0f 84 b5 03 00 00    	je     709436 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e16>
  709081:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709086:	89 ef                	mov    %ebp,%edi
  709088:	e9 ad fd ff ff       	jmp    708e3a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  70908d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709092:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  709097:	c1 e0 10             	shl    $0x10,%eax
  70909a:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  70909f:	09 c1                	or     %eax,%ecx
  7090a1:	48 c1 e1 20          	shl    $0x20,%rcx
  7090a5:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  7090a9:	48 09 cd             	or     %rcx,%rbp
  7090ac:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  7090b3:	00 
  7090b4:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  7090bb:	00 
  7090bc:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  7090c3:	00 
  7090c4:	0f 29 84 24 20 03 00 	movaps %xmm0,0x320(%rsp)
  7090cb:	00 
  7090cc:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  7090d3:	00 
  7090d4:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  7090db:	00 
  7090dc:	eb 42                	jmp    709120 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  7090de:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  7090e5:	00 
  7090e6:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  7090ed:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  7090f4:	00 
  7090f5:	48 c1 e5 20          	shl    $0x20,%rbp
  7090f9:	48 09 c5             	or     %rax,%rbp
  7090fc:	e9 85 01 00 00       	jmp    709286 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c66>
  709101:	49 8b 96 08 07 00 00 	mov    0x708(%r14),%rdx
  709108:	48 85 d2             	test   %rdx,%rdx
  70910b:	0f 95 c0             	setne  %al
  70910e:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  709115:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  70911c:	ff ff 
  70911e:	31 ff                	xor    %edi,%edi
  709120:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  709125:	48 85 f6             	test   %rsi,%rsi
  709128:	7e 22                	jle    70914c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b2c>
  70912a:	ba 01 00 00 00       	mov    $0x1,%edx
  70912f:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  709134:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  709138:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  70913d:	ff 15 f5 81 3f 00    	call   *0x3f81f5(%rip)        # b01338 <_DYNAMIC+0x248>
  709143:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  709147:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  70914c:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  709151:	0f 84 49 fd ff ff    	je     708ea0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1880>
  709157:	48 8b 84 24 30 03 00 	mov    0x330(%rsp),%rax
  70915e:	00 
  70915f:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  709166:	00 
  709167:	0f 28 84 24 20 03 00 	movaps 0x320(%rsp),%xmm0
  70916e:	00 
  70916f:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  709176:	00 
  709177:	40 0f b6 c7          	movzbl %dil,%eax
  70917b:	48 c1 e5 08          	shl    $0x8,%rbp
  70917f:	48 09 c5             	or     %rax,%rbp
  709182:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  709189:	00 
  70918a:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  709191:	00 
  709192:	66 0f 6f 84 24 c0 01 	movdqa 0x1c0(%rsp),%xmm0
  709199:	00 00 
  70919b:	f3 0f 7f 84 24 10 01 	movdqu %xmm0,0x110(%rsp)
  7091a2:	00 00 
  7091a4:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  7091a9:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  7091b0:	00 
  7091b1:	48 89 ac 24 f8 00 00 	mov    %rbp,0xf8(%rsp)
  7091b8:	00 
  7091b9:	4c 89 84 24 00 01 00 	mov    %r8,0x100(%rsp)
  7091c0:	00 
  7091c1:	4c 89 ac 24 08 01 00 	mov    %r13,0x108(%rsp)
  7091c8:	00 
  7091c9:	66 0f 7f 84 24 40 02 	movdqa %xmm0,0x240(%rsp)
  7091d0:	00 00 
  7091d2:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  7091d9:	00 
  7091da:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  7091e1:	00 
  7091e2:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  7091e9:	00 
  7091ea:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
  7091f1:	00 
  7091f2:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
  7091f9:	00 
  7091fa:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  709201:	00 
  709202:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  709209:	00 
  70920a:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  709211:	00 
  709212:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  709219:	00 
  70921a:	31 ed                	xor    %ebp,%ebp
  70921c:	e9 41 e6 ff ff       	jmp    707862 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x242>
  709221:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709226:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  70922b:	c1 e0 10             	shl    $0x10,%eax
  70922e:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  709233:	09 c1                	or     %eax,%ecx
  709235:	48 c1 e1 20          	shl    $0x20,%rcx
  709239:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  70923d:	48 09 cd             	or     %rcx,%rbp
  709240:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  709247:	00 
  709248:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  70924d:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  709254:	00 
  709255:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  70925c:	00 00 
  70925e:	66 0f 7f 84 24 20 03 	movdqa %xmm0,0x320(%rsp)
  709265:	00 00 
  709267:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  70926e:	00 
  70926f:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  709276:	00 
  709277:	eb 17                	jmp    709290 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c70>
  709279:	48 b8 ff ff ff ff ff 	movabs $0xffffffffff,%rax
  709280:	00 00 00 
  709283:	48 21 c5             	and    %rax,%rbp
  709286:	b8 24 00 00 00       	mov    $0x24,%eax
  70928b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709290:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  709295:	48 85 c9             	test   %rcx,%rcx
  709298:	0f 84 65 fb ff ff    	je     708e03 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e3>
  70929e:	f6 01 01             	testb  $0x1,(%rcx)
  7092a1:	0f 85 5c fb ff ff    	jne    708e03 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e3>
  7092a7:	48 8b 41 08          	mov    0x8(%rcx),%rax
  7092ab:	a8 01                	test   $0x1,%al
  7092ad:	0f 85 50 fb ff ff    	jne    708e03 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e3>
  7092b3:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  7092b7:	48 8d 41 08          	lea    0x8(%rcx),%rax
  7092bb:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  7092c0:	0f 84 53 01 00 00    	je     709419 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1df9>
  7092c6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7092cb:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  7092cf:	e9 34 fb ff ff       	jmp    708e08 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e8>
  7092d4:	48 8d 3d d5 9e 3c 00 	lea    0x3c9ed5(%rip),%rdi        # ad31b0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x598>
  7092db:	ff 15 97 80 3f 00    	call   *0x3f8097(%rip)        # b01378 <_DYNAMIC+0x288>
  7092e1:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7092e5:	ff 15 ad 80 3f 00    	call   *0x3f80ad(%rip)        # b01398 <_DYNAMIC+0x2a8>
  7092eb:	e9 c0 e6 ff ff       	jmp    7079b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x390>
  7092f0:	41 bc 15 00 00 00    	mov    $0x15,%r12d
  7092f6:	eb 3c                	jmp    709334 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d14>
  7092f8:	48 8d 05 a5 01 96 ff 	lea    -0x69fe5b(%rip),%rax        # 694a4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e14>
  7092ff:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  709306:	00 
  709307:	48 8d 05 0a a7 3c 00 	lea    0x3ca70a(%rip),%rax        # ad3a18 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xe00>
  70930e:	eb 1c                	jmp    70932c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d0c>
  709310:	41 bc 14 00 00 00    	mov    $0x14,%r12d
  709316:	48 8d 05 73 01 96 ff 	lea    -0x69fe8d(%rip),%rax        # 69490 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e00>
  70931d:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  709324:	00 
  709325:	48 8d 05 d4 a6 3c 00 	lea    0x3ca6d4(%rip),%rax        # ad3a00 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xde8>
  70932c:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  709333:	00 
  709334:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  70933b:	00 
  70933c:	4c 89 e6             	mov    %r12,%rsi
  70933f:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  709346:	00 
  709347:	ff 15 0b 81 3f 00    	call   *0x3f810b(%rip)        # b01458 <_DYNAMIC+0x368>
  70934d:	e9 a7 01 00 00       	jmp    7094f9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709352:	48 8d 3d 0f 01 96 ff 	lea    -0x69fef1(%rip),%rdi        # 69468 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2dd8>
  709359:	48 8d 15 40 a6 3c 00 	lea    0x3ca640(%rip),%rdx        # ad39a0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xd88>
  709360:	be 13 00 00 00       	mov    $0x13,%esi
  709365:	ff 15 ed 80 3f 00    	call   *0x3f80ed(%rip)        # b01458 <_DYNAMIC+0x368>
  70936b:	e9 89 01 00 00       	jmp    7094f9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709370:	48 8d 3d 6e 01 96 ff 	lea    -0x69fe92(%rip),%rdi        # 694e5 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e55>
  709377:	48 8d 15 fa a6 3c 00 	lea    0x3ca6fa(%rip),%rdx        # ad3a78 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xe60>
  70937e:	be 93 00 00 00       	mov    $0x93,%esi
  709383:	ff 15 07 80 3f 00    	call   *0x3f8007(%rip)        # b01390 <_DYNAMIC+0x2a0>
  709389:	e9 6b 01 00 00       	jmp    7094f9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  70938e:	48 8d 05 3a 01 96 ff 	lea    -0x69fec6(%rip),%rax        # 694cf <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e3f>
  709395:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  70939c:	00 
  70939d:	48 8d 05 8c a6 3c 00 	lea    0x3ca68c(%rip),%rax        # ad3a30 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xe18>
  7093a4:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  7093ab:	00 
  7093ac:	48 8b bc 24 30 01 00 	mov    0x130(%rsp),%rdi
  7093b3:	00 
  7093b4:	4c 89 ee             	mov    %r13,%rsi
  7093b7:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
  7093be:	00 
  7093bf:	ff 15 93 80 3f 00    	call   *0x3f8093(%rip)        # b01458 <_DYNAMIC+0x368>
  7093c5:	e9 2f 01 00 00       	jmp    7094f9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  7093ca:	48 8d 3d e7 9a 3c 00 	lea    0x3c9ae7(%rip),%rdi        # ad2eb8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x2a0>
  7093d1:	ff 15 a1 7f 3f 00    	call   *0x3f7fa1(%rip)        # b01378 <_DYNAMIC+0x288>
  7093d7:	e9 1d 01 00 00       	jmp    7094f9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  7093dc:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  7093e3:	00 00 
  7093e5:	48 8d 3d 5c a6 3c 00 	lea    0x3ca65c(%rip),%rdi        # ad3a48 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xe30>
  7093ec:	ff 15 86 7f 3f 00    	call   *0x3f7f86(%rip)        # b01378 <_DYNAMIC+0x288>
  7093f2:	e9 02 01 00 00       	jmp    7094f9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  7093f7:	48 8d 05 8a 9a 3c 00 	lea    0x3c9a8a(%rip),%rax        # ad2e88 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x270>
  7093fe:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  709405:	00 
  709406:	48 8b bc 24 b8 01 00 	mov    0x1b8(%rsp),%rdi
  70940d:	00 
  70940e:	ff 15 64 7f 3f 00    	call   *0x3f7f64(%rip)        # b01378 <_DYNAMIC+0x288>
  709414:	e9 e0 00 00 00       	jmp    7094f9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709419:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  70941e:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709422:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709427:	ff 15 6b 7f 3f 00    	call   *0x3f7f6b(%rip)        # b01398 <_DYNAMIC+0x2a8>
  70942d:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  709431:	e9 d2 f9 ff ff       	jmp    708e08 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e8>
  709436:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  70943b:	48 8b 47 08          	mov    0x8(%rdi),%rax
  70943f:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709444:	ff 15 4e 7f 3f 00    	call   *0x3f7f4e(%rip)        # b01398 <_DYNAMIC+0x2a8>
  70944a:	89 ef                	mov    %ebp,%edi
  70944c:	e9 e9 f9 ff ff       	jmp    708e3a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709451:	48 8d 15 48 9a 3c 00 	lea    0x3c9a48(%rip),%rdx        # ad2ea0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x288>
  709458:	ff 15 0a 80 3f 00    	call   *0x3f800a(%rip)        # b01468 <_DYNAMIC+0x378>
  70945e:	e9 96 00 00 00       	jmp    7094f9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709463:	48 8d 05 8e 9d 3c 00 	lea    0x3c9d8e(%rip),%rax        # ad31f8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x5e0>
  70946a:	eb 47                	jmp    7094b3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  70946c:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  709471:	48 8d 05 98 9d 3c 00 	lea    0x3c9d98(%rip),%rax        # ad3210 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x5f8>
  709478:	eb 39                	jmp    7094b3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  70947a:	48 8d 05 5f 9d 3c 00 	lea    0x3c9d5f(%rip),%rax        # ad31e0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x5c8>
  709481:	eb 30                	jmp    7094b3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  709483:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  709488:	48 8d 05 11 9a 3c 00 	lea    0x3c9a11(%rip),%rax        # ad2ea0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x288>
  70948f:	eb 22                	jmp    7094b3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  709491:	48 85 ff             	test   %rdi,%rdi
  709494:	75 34                	jne    7094ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1eaa>
  709496:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  70949d:	00 00 
  70949f:	ff 15 a3 80 3f 00    	call   *0x3f80a3(%rip)        # b01548 <_DYNAMIC+0x458>
  7094a5:	eb 52                	jmp    7094f9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  7094a7:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7094ac:	48 8d 05 bd 99 3c 00 	lea    0x3c99bd(%rip),%rax        # ad2e70 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x258>
  7094b3:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  7094b8:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  7094bd:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  7094c2:	ff 15 a0 7f 3f 00    	call   *0x3f7fa0(%rip)        # b01468 <_DYNAMIC+0x378>
  7094c8:	eb 2f                	jmp    7094f9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  7094ca:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  7094cf:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  7094d6:	00 00 
  7094d8:	ff 15 8a 7e 3f 00    	call   *0x3f7e8a(%rip)        # b01368 <_DYNAMIC+0x278>
  7094de:	eb 19                	jmp    7094f9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  7094e0:	48 8d 3d 94 ff 95 ff 	lea    -0x6a006c(%rip),%rdi        # 6947b <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2deb>
  7094e7:	48 8d 15 ca a4 3c 00 	lea    0x3ca4ca(%rip),%rdx        # ad39b8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xda0>
  7094ee:	be 15 00 00 00       	mov    $0x15,%esi
  7094f3:	ff 15 5f 7f 3f 00    	call   *0x3f7f5f(%rip)        # b01458 <_DYNAMIC+0x368>
  7094f9:	0f 0b                	ud2
  7094fb:	49 89 c5             	mov    %rax,%r13
  7094fe:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709503:	48 89 45 10          	mov    %rax,0x10(%rbp)
  709507:	eb 6d                	jmp    709576 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  709509:	49 89 c5             	mov    %rax,%r13
  70950c:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709511:	48 89 45 08          	mov    %rax,0x8(%rbp)
  709515:	eb 5f                	jmp    709576 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  709517:	49 89 c5             	mov    %rax,%r13
  70951a:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  70951e:	eb 56                	jmp    709576 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  709520:	48 89 c3             	mov    %rax,%rbx
  709523:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  70952a:	00 
  70952b:	e8 40 ae ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709530:	48 89 df             	mov    %rbx,%rdi
  709533:	e8 a8 82 3c 00       	call   ad17e0 <_Unwind_Resume@plt>
  709538:	eb 18                	jmp    709552 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f32>
  70953a:	eb 16                	jmp    709552 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f32>
  70953c:	eb 00                	jmp    70953e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f1e>
  70953e:	49 89 c5             	mov    %rax,%r13
  709541:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  709548:	ff 
  709549:	eb 2b                	jmp    709576 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  70954b:	49 89 c5             	mov    %rax,%r13
  70954e:	eb 4d                	jmp    70959d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f7d>
  709550:	eb 21                	jmp    709573 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f53>
  709552:	49 89 c5             	mov    %rax,%r13
  709555:	eb 29                	jmp    709580 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f60>
  709557:	49 89 c5             	mov    %rax,%r13
  70955a:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
  709560:	7e 3b                	jle    70959d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f7d>
  709562:	ba 01 00 00 00       	mov    $0x1,%edx
  709567:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  70956c:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  709571:	eb 24                	jmp    709597 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f77>
  709573:	49 89 c5             	mov    %rax,%r13
  709576:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  70957b:	e8 80 7e ff ff       	call   701400 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  709580:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  709586:	7e 15                	jle    70959d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f7d>
  709588:	ba 01 00 00 00       	mov    $0x1,%edx
  70958d:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  709592:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  709597:	ff 15 9b 7d 3f 00    	call   *0x3f7d9b(%rip)        # b01338 <_DYNAMIC+0x248>
  70959d:	4c 89 ef             	mov    %r13,%rdi
  7095a0:	ff 15 d2 7e 3f 00    	call   *0x3f7ed2(%rip)        # b01478 <_DYNAMIC+0x388>
  7095a6:	49 89 c5             	mov    %rax,%r13
  7095a9:	48 89 d5             	mov    %rdx,%rbp
  7095ac:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
  7095b3:	00 
  7095b4:	48 89 94 24 00 01 00 	mov    %rdx,0x100(%rsp)
  7095bb:	00 
  7095bc:	48 c7 84 24 f0 00 00 	movq   $0xfffffffffffffffd,0xf0(%rsp)
  7095c3:	00 fd ff ff ff 
  7095c8:	4c 89 f7             	mov    %r14,%rdi
  7095cb:	e8 40 43 01 00       	call   71d910 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  7095d0:	48 c7 84 24 20 02 00 	movq   $0xf,0x220(%rsp)
  7095d7:	00 0f 00 00 00 
  7095dc:	48 8b 45 00          	mov    0x0(%rbp),%rax
  7095e0:	48 85 c0             	test   %rax,%rax
  7095e3:	74 05                	je     7095ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1fca>
  7095e5:	4c 89 ef             	mov    %r13,%rdi
  7095e8:	ff d0                	call   *%rax
  7095ea:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  7095ee:	48 85 f6             	test   %rsi,%rsi
  7095f1:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7095f6:	74 0d                	je     709605 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1fe5>
  7095f8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  7095fc:	4c 89 ef             	mov    %r13,%rdi
  7095ff:	ff 15 33 7d 3f 00    	call   *0x3f7d33(%rip)        # b01338 <_DYNAMIC+0x248>
  709605:	31 ed                	xor    %ebp,%ebp
  709607:	e9 56 e2 ff ff       	jmp    707862 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x242>
  70960c:	48 89 c3             	mov    %rax,%rbx
  70960f:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  709613:	48 85 f6             	test   %rsi,%rsi
  709616:	74 2b                	je     709643 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2023>
  709618:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  70961c:	4c 89 ef             	mov    %r13,%rdi
  70961f:	ff 15 13 7d 3f 00    	call   *0x3f7d13(%rip)        # b01338 <_DYNAMIC+0x248>
  709625:	48 89 df             	mov    %rbx,%rdi
  709628:	e8 b3 81 3c 00       	call   ad17e0 <_Unwind_Resume@plt>
  70962d:	ff 15 55 7d 3f 00    	call   *0x3f7d55(%rip)        # b01388 <_DYNAMIC+0x298>
  709633:	48 89 c3             	mov    %rax,%rbx
  709636:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  70963d:	00 
  70963e:	e8 8d 82 ff ff       	call   7018d0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  709643:	48 89 df             	mov    %rbx,%rdi
  709646:	e8 95 81 3c 00       	call   ad17e0 <_Unwind_Resume@plt>
  70964b:	ff 15 37 7d 3f 00    	call   *0x3f7d37(%rip)        # b01388 <_DYNAMIC+0x298>
  709651:	ff 15 29 7e 3f 00    	call   *0x3f7e29(%rip)        # b01480 <_DYNAMIC+0x390>
