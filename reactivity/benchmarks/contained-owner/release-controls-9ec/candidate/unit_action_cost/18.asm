
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070e450 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action>:
  70e450:	55                   	push   %rbp
  70e451:	41 57                	push   %r15
  70e453:	41 56                	push   %r14
  70e455:	41 55                	push   %r13
  70e457:	41 54                	push   %r12
  70e459:	53                   	push   %rbx
  70e45a:	48 81 ec 28 01 00 00 	sub    $0x128,%rsp
  70e461:	48 89 fb             	mov    %rdi,%rbx
  70e464:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  70e46b:	74 09                	je     70e476 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x26>
  70e46d:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  70e474:	eb 6f                	jmp    70e4e5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e476:	49 89 f6             	mov    %rsi,%r14
  70e479:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  70e480:	48 85 c0             	test   %rax,%rax
  70e483:	74 59                	je     70e4de <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x8e>
  70e485:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70e48c:	00 
  70e48d:	74 4f                	je     70e4de <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x8e>
  70e48f:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70e496:	00 00 00 00 
  70e49a:	48 8b a8 d8 00 00 00 	mov    0xd8(%rax),%rbp
  70e4a1:	48 85 ed             	test   %rbp,%rbp
  70e4a4:	0f 84 b0 08 00 00    	je     70ed5a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x90a>
  70e4aa:	44 0f b7 65 10       	movzwl 0x10(%rbp),%r12d
  70e4af:	0f b6 7d 16          	movzbl 0x16(%rbp),%edi
  70e4b3:	44 0f b6 45 12       	movzbl 0x12(%rbp),%r8d
  70e4b8:	89 c8                	mov    %ecx,%eax
  70e4ba:	66 83 e8 0e          	sub    $0xe,%ax
  70e4be:	41 bf 03 00 00 00    	mov    $0x3,%r15d
  70e4c4:	44 0f 43 f8          	cmovae %eax,%r15d
  70e4c8:	66 41 83 ff 03       	cmp    $0x3,%r15w
  70e4cd:	75 28                	jne    70e4f7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa7>
  70e4cf:	66 41 39 cc          	cmp    %cx,%r12w
  70e4d3:	74 22                	je     70e4f7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa7>
  70e4d5:	48 c7 03 11 00 00 00 	movq   $0x11,(%rbx)
  70e4dc:	eb 07                	jmp    70e4e5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e4de:	48 c7 03 1a 00 00 00 	movq   $0x1a,(%rbx)
  70e4e5:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70e4ec:	5b                   	pop    %rbx
  70e4ed:	41 5c                	pop    %r12
  70e4ef:	41 5d                	pop    %r13
  70e4f1:	41 5e                	pop    %r14
  70e4f3:	41 5f                	pop    %r15
  70e4f5:	5d                   	pop    %rbp
  70e4f6:	c3                   	ret
  70e4f7:	41 89 cd             	mov    %ecx,%r13d
  70e4fa:	41 c1 ed 10          	shr    $0x10,%r13d
  70e4fe:	45 0f b7 cf          	movzwl %r15w,%r9d
  70e502:	48 8d 05 1f 83 95 ff 	lea    -0x6a7ce1(%rip),%rax        # 66828 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x8>
  70e509:	4a 63 34 88          	movslq (%rax,%r9,4),%rsi
  70e50d:	48 01 c6             	add    %rax,%rsi
  70e510:	ff e6                	jmp    *%rsi
  70e512:	44 0f b7 ff          	movzwl %di,%r15d
  70e516:	41 81 cf 00 01 00 00 	or     $0x100,%r15d
  70e51d:	eb 12                	jmp    70e531 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xe1>
  70e51f:	45 0f b7 f8          	movzwl %r8w,%r15d
  70e523:	41 c1 e7 08          	shl    $0x8,%r15d
  70e527:	66 45 39 e5          	cmp    %r12w,%r13w
  70e52b:	0f 85 f3 02 00 00    	jne    70e824 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d4>
  70e531:	b0 01                	mov    $0x1,%al
  70e533:	44 38 ff             	cmp    %r15b,%dil
  70e536:	0f 85 ed 02 00 00    	jne    70e829 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d9>
  70e53c:	41 0f b7 cf          	movzwl %r15w,%ecx
  70e540:	c1 e9 08             	shr    $0x8,%ecx
  70e543:	41 38 c8             	cmp    %cl,%r8b
  70e546:	0f 85 dd 02 00 00    	jne    70e829 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d9>
  70e54c:	80 7d 13 ff          	cmpb   $0xff,0x13(%rbp)
  70e550:	0f 85 d3 02 00 00    	jne    70e829 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d9>
  70e556:	e9 c4 01 00 00       	jmp    70e71f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x2cf>
  70e55b:	f7 c1 00 00 ff 00    	test   $0xff0000,%ecx
  70e561:	0f 84 5d 02 00 00    	je     70e7c4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x374>
  70e567:	48 8b 45 00          	mov    0x0(%rbp),%rax
  70e56b:	48 85 c0             	test   %rax,%rax
  70e56e:	0f 84 ab 01 00 00    	je     70e71f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x2cf>
  70e574:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  70e57b:	0f 85 d4 01 00 00    	jne    70e755 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x305>
  70e581:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  70e586:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  70e58b:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  70e590:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  70e594:	4c 8b 65 08          	mov    0x8(%rbp),%r12
  70e598:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  70e59f:	00 00 
  70e5a1:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e5a6:	e8 35 62 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70e5ab:	48 8d bc 24 c0 00 00 	lea    0xc0(%rsp),%rdi
  70e5b2:	00 
  70e5b3:	4c 89 f6             	mov    %r14,%rsi
  70e5b6:	4c 89 e2             	mov    %r12,%rdx
  70e5b9:	e8 32 f8 00 00       	call   71ddf0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  70e5be:	48 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%rax
  70e5c5:	00 
  70e5c6:	4c 8b a4 24 c8 00 00 	mov    0xc8(%rsp),%r12
  70e5cd:	00 
  70e5ce:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70e5d2:	0f 85 fc 05 00 00    	jne    70ebd4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x784>
  70e5d8:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70e5df:	48 85 c0             	test   %rax,%rax
  70e5e2:	0f 84 2f 06 00 00    	je     70ec17 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7c7>
  70e5e8:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70e5ef:	00 
  70e5f0:	0f 84 21 06 00 00    	je     70ec17 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7c7>
  70e5f6:	49 8b ae a0 02 00 00 	mov    0x2a0(%r14),%rbp
  70e5fd:	48 c7 44 24 28 1a 00 	movq   $0x1a,0x28(%rsp)
  70e604:	00 00 
  70e606:	48 83 fd 1c          	cmp    $0x1c,%rbp
  70e60a:	0f 82 07 06 00 00    	jb     70ec17 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7c7>
  70e610:	48 83 c5 e4          	add    $0xffffffffffffffe4,%rbp
  70e614:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e619:	e8 c2 61 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70e61e:	49 83 fc 02          	cmp    $0x2,%r12
  70e622:	0f 93 c0             	setae  %al
  70e625:	49 39 ec             	cmp    %rbp,%r12
  70e628:	0f 92 c1             	setb   %cl
  70e62b:	84 c8                	test   %cl,%al
  70e62d:	0f 84 22 01 00 00    	je     70e755 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x305>
  70e633:	66 41 83 ff 01       	cmp    $0x1,%r15w
  70e638:	0f 84 3d 06 00 00    	je     70ec7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x82b>
  70e63e:	83 7c 24 18 03       	cmpl   $0x3,0x18(%rsp)
  70e643:	0f 85 c3 08 00 00    	jne    70ef0c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xabc>
  70e649:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e64e:	4c 89 f6             	mov    %r14,%rsi
  70e651:	4c 89 e2             	mov    %r12,%rdx
  70e654:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  70e658:	e8 03 04 01 00       	call   71ea60 <<gpui::runtime::Runtime<unit_action_cost::Model>>::property_value_at>
  70e65d:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  70e662:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70e667:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  70e66e:	00 
  70e66f:	0f 10 44 24 3c       	movups 0x3c(%rsp),%xmm0
  70e674:	0f 11 84 24 cc 00 00 	movups %xmm0,0xcc(%rsp)
  70e67b:	00 
  70e67c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70e680:	0f 85 a4 06 00 00    	jne    70ed2a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x8da>
  70e686:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  70e68d:	00 
  70e68e:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  70e695:	00 
  70e696:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  70e69d:	00 
  70e69e:	0f 11 84 24 0c 01 00 	movups %xmm0,0x10c(%rsp)
  70e6a5:	00 
  70e6a6:	41 0f b6 c5          	movzbl %r13b,%eax
  70e6aa:	48 8d 0d 87 81 95 ff 	lea    -0x6a7e79(%rip),%rcx        # 66838 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x18>
  70e6b1:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  70e6b5:	48 01 c8             	add    %rcx,%rax
  70e6b8:	ff e0                	jmp    *%rax
  70e6ba:	8b 44 24 08          	mov    0x8(%rsp),%eax
  70e6be:	25 00 00 ff 00       	and    $0xff0000,%eax
  70e6c3:	31 c9                	xor    %ecx,%ecx
  70e6c5:	3d 00 00 02 00       	cmp    $0x20000,%eax
  70e6ca:	0f 94 c1             	sete   %cl
  70e6cd:	48 8d 05 fc 7e 95 ff 	lea    -0x6a8104(%rip),%rax        # 665d0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.21.llvm.6319143315422321905+0x30>
  70e6d4:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
  70e6d9:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e6de:	48 8d b4 24 00 01 00 	lea    0x100(%rsp),%rsi
  70e6e5:	00 
  70e6e6:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  70e6eb:	ff 15 2f 3c 3f 00    	call   *0x3f3c2f(%rip)        # b02320 <_DYNAMIC+0x508>
  70e6f1:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  70e6f6:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70e6fa:	0f 85 c5 06 00 00    	jne    70edc5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x975>
  70e700:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70e705:	0f 10 4c 24 3c       	movups 0x3c(%rsp),%xmm1
  70e70a:	0f 11 8c 24 ac 00 00 	movups %xmm1,0xac(%rsp)
  70e711:	00 
  70e712:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  70e719:	00 
  70e71a:	e9 e2 06 00 00       	jmp    70ee01 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x9b1>
  70e71f:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70e726:	00 
  70e727:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70e72e:	00 
  70e72f:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70e736:	00 
  70e737:	74 66                	je     70e79f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x34f>
  70e739:	84 c0                	test   %al,%al
  70e73b:	74 0a                	je     70e747 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x2f7>
  70e73d:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70e744:	ff 
  70e745:	74 58                	je     70e79f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x34f>
  70e747:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70e74e:	b9 01 00 00 00       	mov    $0x1,%ecx
  70e753:	eb 4c                	jmp    70e7a1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x351>
  70e755:	48 c7 44 24 68 11 00 	movq   $0x11,0x68(%rsp)
  70e75c:	00 00 
  70e75e:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70e765:	00 
  70e766:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70e76d:	00 
  70e76e:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70e775:	00 
  70e776:	0f 84 26 04 00 00    	je     70eba2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x752>
  70e77c:	84 c0                	test   %al,%al
  70e77e:	74 0e                	je     70e78e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x33e>
  70e780:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70e787:	ff 
  70e788:	0f 84 14 04 00 00    	je     70eba2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x752>
  70e78e:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70e795:	b9 01 00 00 00       	mov    $0x1,%ecx
  70e79a:	e9 05 04 00 00       	jmp    70eba4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x754>
  70e79f:	31 c9                	xor    %ecx,%ecx
  70e7a1:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70e7a5:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70e7a9:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70e7ad:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  70e7b4:	00 
  70e7b5:	88 43 30             	mov    %al,0x30(%rbx)
  70e7b8:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70e7bf:	e9 21 fd ff ff       	jmp    70e4e5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e7c4:	45 0f b7 f8          	movzwl %r8w,%r15d
  70e7c8:	8d 47 01             	lea    0x1(%rdi),%eax
  70e7cb:	89 44 24 18          	mov    %eax,0x18(%rsp)
  70e7cf:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  70e7d4:	89 cf                	mov    %ecx,%edi
  70e7d6:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  70e7da:	45 89 c5             	mov    %r8d,%r13d
  70e7dd:	e8 ce da ff ff       	call   70c2b0 <<gpui::property::PropertyId>::info>
  70e7e2:	45 89 e8             	mov    %r13d,%r8d
  70e7e5:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70e7ea:	44 8b 6c 24 08       	mov    0x8(%rsp),%r13d
  70e7ef:	0f b6 40 14          	movzbl 0x14(%rax),%eax
  70e7f3:	31 c9                	xor    %ecx,%ecx
  70e7f5:	3c 04                	cmp    $0x4,%al
  70e7f7:	0f 94 c1             	sete   %cl
  70e7fa:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  70e7fd:	ff c1                	inc    %ecx
  70e7ff:	3c 02                	cmp    $0x2,%al
  70e801:	ba 04 00 00 00       	mov    $0x4,%edx
  70e806:	0f 45 d1             	cmovne %ecx,%edx
  70e809:	0f b6 44 24 18       	movzbl 0x18(%rsp),%eax
  70e80e:	f6 f2                	div    %dl
  70e810:	0f b6 c4             	movzbl %ah,%eax
  70e813:	41 c1 e7 08          	shl    $0x8,%r15d
  70e817:	41 09 c7             	or     %eax,%r15d
  70e81a:	66 45 39 e5          	cmp    %r12w,%r13w
  70e81e:	0f 84 0d fd ff ff    	je     70e531 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xe1>
  70e824:	31 c0                	xor    %eax,%eax
  70e826:	45 89 ec             	mov    %r13d,%r12d
  70e829:	49 8b 96 60 06 00 00 	mov    0x660(%r14),%rdx
  70e830:	48 ff c2             	inc    %rdx
  70e833:	0f 84 a8 06 00 00    	je     70eee1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa91>
  70e839:	41 0f b7 cf          	movzwl %r15w,%ecx
  70e83d:	66 44 89 65 10       	mov    %r12w,0x10(%rbp)
  70e842:	88 4d 16             	mov    %cl,0x16(%rbp)
  70e845:	88 6d 12             	mov    %ch,0x12(%rbp)
  70e848:	c6 45 13 ff          	movb   $0xff,0x13(%rbp)
  70e84c:	84 c0                	test   %al,%al
  70e84e:	0f 85 11 03 00 00    	jne    70eb65 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x715>
  70e854:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70e85b:	48 85 c0             	test   %rax,%rax
  70e85e:	0f 84 da 06 00 00    	je     70ef3e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaee>
  70e864:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70e86b:	00 
  70e86c:	0f 84 cc 06 00 00    	je     70ef3e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaee>
  70e872:	4d 8b be a0 02 00 00 	mov    0x2a0(%r14),%r15
  70e879:	49 83 ff 1c          	cmp    $0x1c,%r15
  70e87d:	0f 82 bb 06 00 00    	jb     70ef3e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaee>
  70e883:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  70e888:	41 0f b7 fc          	movzwl %r12w,%edi
  70e88c:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  70e891:	ff 15 91 3a 3f 00    	call   *0x3f3a91(%rip)        # b02328 <_DYNAMIC+0x510>
  70e897:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70e89c:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70e8a1:	49 8d 7f f7          	lea    -0x9(%r15),%rdi
  70e8a5:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70e8ac:	48 39 f7             	cmp    %rsi,%rdi
  70e8af:	0f 83 99 06 00 00    	jae    70ef4e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70e8b5:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70e8bc:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70e8c0:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70e8c4:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70e8c9:	48 85 ed             	test   %rbp,%rbp
  70e8cc:	74 36                	je     70e904 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x4b4>
  70e8ce:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70e8d3:	49 8b 45 00          	mov    0x0(%r13),%rax
  70e8d7:	48 85 c0             	test   %rax,%rax
  70e8da:	74 12                	je     70e8ee <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x49e>
  70e8dc:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70e8e0:	48 83 c1 08          	add    $0x8,%rcx
  70e8e4:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70e8e9:	48 89 ef             	mov    %rbp,%rdi
  70e8ec:	ff d0                	call   *%rax
  70e8ee:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70e8f2:	48 85 f6             	test   %rsi,%rsi
  70e8f5:	74 0d                	je     70e904 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x4b4>
  70e8f7:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70e8fb:	48 89 ef             	mov    %rbp,%rdi
  70e8fe:	ff 15 5c 37 3f 00    	call   *0x3f375c(%rip)        # b02060 <_DYNAMIC+0x248>
  70e904:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70e909:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70e90e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70e913:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70e918:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70e91d:	8d b8 00 00 01 00    	lea    0x10000(%rax),%edi
  70e923:	ff 15 ff 39 3f 00    	call   *0x3f39ff(%rip)        # b02328 <_DYNAMIC+0x510>
  70e929:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70e92e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70e933:	49 8d 7f f9          	lea    -0x7(%r15),%rdi
  70e937:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70e93e:	48 39 f7             	cmp    %rsi,%rdi
  70e941:	0f 83 07 06 00 00    	jae    70ef4e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70e947:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70e94e:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70e952:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70e956:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70e95b:	48 85 ed             	test   %rbp,%rbp
  70e95e:	74 36                	je     70e996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x546>
  70e960:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70e965:	49 8b 45 00          	mov    0x0(%r13),%rax
  70e969:	48 85 c0             	test   %rax,%rax
  70e96c:	74 12                	je     70e980 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x530>
  70e96e:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70e972:	48 83 c1 08          	add    $0x8,%rcx
  70e976:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70e97b:	48 89 ef             	mov    %rbp,%rdi
  70e97e:	ff d0                	call   *%rax
  70e980:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70e984:	48 85 f6             	test   %rsi,%rsi
  70e987:	74 0d                	je     70e996 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x546>
  70e989:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70e98d:	48 89 ef             	mov    %rbp,%rdi
  70e990:	ff 15 ca 36 3f 00    	call   *0x3f36ca(%rip)        # b02060 <_DYNAMIC+0x248>
  70e996:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70e99b:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70e9a0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70e9a5:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70e9aa:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70e9af:	8d b8 00 00 02 00    	lea    0x20000(%rax),%edi
  70e9b5:	ff 15 6d 39 3f 00    	call   *0x3f396d(%rip)        # b02328 <_DYNAMIC+0x510>
  70e9bb:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70e9c0:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70e9c5:	49 8d 7f fa          	lea    -0x6(%r15),%rdi
  70e9c9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70e9d0:	48 39 f7             	cmp    %rsi,%rdi
  70e9d3:	0f 83 75 05 00 00    	jae    70ef4e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70e9d9:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70e9e0:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70e9e4:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70e9e8:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70e9ed:	48 85 ed             	test   %rbp,%rbp
  70e9f0:	74 36                	je     70ea28 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x5d8>
  70e9f2:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70e9f7:	49 8b 45 00          	mov    0x0(%r13),%rax
  70e9fb:	48 85 c0             	test   %rax,%rax
  70e9fe:	74 12                	je     70ea12 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x5c2>
  70ea00:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70ea04:	48 83 c1 08          	add    $0x8,%rcx
  70ea08:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70ea0d:	48 89 ef             	mov    %rbp,%rdi
  70ea10:	ff d0                	call   *%rax
  70ea12:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70ea16:	48 85 f6             	test   %rsi,%rsi
  70ea19:	74 0d                	je     70ea28 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x5d8>
  70ea1b:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70ea1f:	48 89 ef             	mov    %rbp,%rdi
  70ea22:	ff 15 38 36 3f 00    	call   *0x3f3638(%rip)        # b02060 <_DYNAMIC+0x248>
  70ea28:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70ea2d:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70ea32:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70ea37:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70ea3c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70ea41:	8d b8 00 00 03 00    	lea    0x30000(%rax),%edi
  70ea47:	ff 15 db 38 3f 00    	call   *0x3f38db(%rip)        # b02328 <_DYNAMIC+0x510>
  70ea4d:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70ea52:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70ea57:	49 8d 7f fb          	lea    -0x5(%r15),%rdi
  70ea5b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70ea62:	48 39 f7             	cmp    %rsi,%rdi
  70ea65:	0f 83 e3 04 00 00    	jae    70ef4e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70ea6b:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70ea72:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70ea76:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70ea7a:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70ea7f:	48 85 ed             	test   %rbp,%rbp
  70ea82:	74 36                	je     70eaba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x66a>
  70ea84:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70ea89:	49 8b 45 00          	mov    0x0(%r13),%rax
  70ea8d:	48 85 c0             	test   %rax,%rax
  70ea90:	74 12                	je     70eaa4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x654>
  70ea92:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70ea96:	48 83 c1 08          	add    $0x8,%rcx
  70ea9a:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70ea9f:	48 89 ef             	mov    %rbp,%rdi
  70eaa2:	ff d0                	call   *%rax
  70eaa4:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70eaa8:	48 85 f6             	test   %rsi,%rsi
  70eaab:	74 0d                	je     70eaba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x66a>
  70eaad:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70eab1:	48 89 ef             	mov    %rbp,%rdi
  70eab4:	ff 15 a6 35 3f 00    	call   *0x3f35a6(%rip)        # b02060 <_DYNAMIC+0x248>
  70eaba:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70eabf:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70eac4:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70eac9:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70eace:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  70ead3:	81 cf 00 00 04 00    	or     $0x40000,%edi
  70ead9:	ff 15 49 38 3f 00    	call   *0x3f3849(%rip)        # b02328 <_DYNAMIC+0x510>
  70eadf:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70eae4:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70eae9:	49 83 c7 fc          	add    $0xfffffffffffffffc,%r15
  70eaed:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70eaf4:	49 39 f7             	cmp    %rsi,%r15
  70eaf7:	0f 83 4e 04 00 00    	jae    70ef4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafb>
  70eafd:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70eb04:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  70eb08:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70eb0c:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70eb11:	48 85 ed             	test   %rbp,%rbp
  70eb14:	74 36                	je     70eb4c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x6fc>
  70eb16:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70eb1b:	49 8b 45 00          	mov    0x0(%r13),%rax
  70eb1f:	48 85 c0             	test   %rax,%rax
  70eb22:	74 12                	je     70eb36 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x6e6>
  70eb24:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70eb28:	48 83 c1 08          	add    $0x8,%rcx
  70eb2c:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70eb31:	48 89 ef             	mov    %rbp,%rdi
  70eb34:	ff d0                	call   *%rax
  70eb36:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70eb3a:	48 85 f6             	test   %rsi,%rsi
  70eb3d:	74 0d                	je     70eb4c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x6fc>
  70eb3f:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70eb43:	48 89 ef             	mov    %rbp,%rdi
  70eb46:	ff 15 14 35 3f 00    	call   *0x3f3514(%rip)        # b02060 <_DYNAMIC+0x248>
  70eb4c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70eb51:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70eb56:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70eb5b:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70eb60:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  70eb65:	49 89 96 60 06 00 00 	mov    %rdx,0x660(%r14)
  70eb6c:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  70eb73:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70eb7a:	00 00 00 00 
  70eb7e:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  70eb85:	01 
  70eb86:	48 89 df             	mov    %rbx,%rdi
  70eb89:	4c 89 f6             	mov    %r14,%rsi
  70eb8c:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70eb93:	5b                   	pop    %rbx
  70eb94:	41 5c                	pop    %r12
  70eb96:	41 5d                	pop    %r13
  70eb98:	41 5e                	pop    %r14
  70eb9a:	41 5f                	pop    %r15
  70eb9c:	5d                   	pop    %rbp
  70eb9d:	e9 be fa 00 00       	jmp    71e660 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70eba2:	31 c9                	xor    %ecx,%ecx
  70eba4:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70ebab:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70ebaf:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70ebb3:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70ebb7:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70ebbb:	88 43 30             	mov    %al,0x30(%rbx)
  70ebbe:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70ebc5:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  70ebca:	e8 11 5c ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ebcf:	e9 11 f9 ff ff       	jmp    70e4e5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70ebd4:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  70ebdb:	00 
  70ebdc:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  70ebe3:	00 
  70ebe4:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  70ebeb:	00 
  70ebec:	0f 10 8c 24 e0 00 00 	movups 0xe0(%rsp),%xmm1
  70ebf3:	00 
  70ebf4:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70ebfb:	00 
  70ebfc:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70ec01:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  70ec06:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  70ec0b:	48 83 f8 11          	cmp    $0x11,%rax
  70ec0f:	0f 84 49 fb ff ff    	je     70e75e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x30e>
  70ec15:	eb 2d                	jmp    70ec44 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7f4>
  70ec17:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70ec1c:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  70ec23:	00 
  70ec24:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70ec29:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  70ec2e:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70ec35:	00 
  70ec36:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70ec3b:	48 c7 44 24 68 1a 00 	movq   $0x1a,0x68(%rsp)
  70ec42:	00 00 
  70ec44:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  70ec4b:	00 
  70ec4c:	48 89 43 30          	mov    %rax,0x30(%rbx)
  70ec50:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  70ec55:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  70ec5a:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  70ec5f:	0f 10 8c 24 88 00 00 	movups 0x88(%rsp),%xmm1
  70ec66:	00 
  70ec67:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  70ec6b:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  70ec6f:	48 89 03             	mov    %rax,(%rbx)
  70ec72:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70ec76:	e9 6a f8 ff ff       	jmp    70e4e5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70ec7b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70ec82:	49 39 f4             	cmp    %rsi,%r12
  70ec85:	0f 83 eb 02 00 00    	jae    70ef76 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xb26>
  70ec8b:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70ec92:	4b 8d 0c a4          	lea    (%r12,%r12,4),%rcx
  70ec96:	44 8b 7c c8 18       	mov    0x18(%rax,%rcx,8),%r15d
  70ec9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  70eca0:	49 39 c7             	cmp    %rax,%r15
  70eca3:	0f 84 2c f8 ff ff    	je     70e4d5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x85>
  70eca9:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  70ecb0:	00 00 
  70ecb2:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ecb7:	e8 24 5b ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ecbc:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70ecc3:	4c 39 fe             	cmp    %r15,%rsi
  70ecc6:	0f 86 ba 02 00 00    	jbe    70ef86 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xb36>
  70eccc:	49 8d be b0 05 00 00 	lea    0x5b0(%r14),%rdi
  70ecd3:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70ecda:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  70ecde:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
  70ece2:	ff 15 48 36 3f 00    	call   *0x3f3648(%rip)        # b02330 <_DYNAMIC+0x518>
  70ece8:	49 89 c7             	mov    %rax,%r15
  70eceb:	49 89 d4             	mov    %rdx,%r12
  70ecee:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ecf3:	4c 89 f6             	mov    %r14,%rsi
  70ecf6:	48 89 c2             	mov    %rax,%rdx
  70ecf9:	4c 89 e1             	mov    %r12,%rcx
  70ecfc:	e8 5f f5 ff ff       	call   70e260 <<gpui::runtime::Runtime<unit_action_cost::Model>>::inspector_app_index>
  70ed01:	83 7c 24 28 fe       	cmpl   $0xfffffffe,0x28(%rsp)
  70ed06:	75 5f                	jne    70ed67 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x917>
  70ed08:	48 89 df             	mov    %rbx,%rdi
  70ed0b:	4c 89 f6             	mov    %r14,%rsi
  70ed0e:	4c 89 fa             	mov    %r15,%rdx
  70ed11:	4c 89 e1             	mov    %r12,%rcx
  70ed14:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70ed1b:	5b                   	pop    %rbx
  70ed1c:	41 5c                	pop    %r12
  70ed1e:	41 5d                	pop    %r13
  70ed20:	41 5e                	pop    %r14
  70ed22:	41 5f                	pop    %r15
  70ed24:	5d                   	pop    %rbp
  70ed25:	e9 e6 02 00 00       	jmp    70f010 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select>
  70ed2a:	8b 4c 24 5c          	mov    0x5c(%rsp),%ecx
  70ed2e:	89 4b 34             	mov    %ecx,0x34(%rbx)
  70ed31:	0f 10 44 24 4c       	movups 0x4c(%rsp),%xmm0
  70ed36:	0f 11 43 24          	movups %xmm0,0x24(%rbx)
  70ed3a:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  70ed41:	00 
  70ed42:	0f 11 43 14          	movups %xmm0,0x14(%rbx)
  70ed46:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  70ed4d:	00 
  70ed4e:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  70ed52:	48 89 03             	mov    %rax,(%rbx)
  70ed55:	e9 8b f7 ff ff       	jmp    70e4e5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70ed5a:	48 8d 3d 5f 54 3c 00 	lea    0x3c545f(%rip),%rdi        # ad41c0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x948>
  70ed61:	ff 15 39 33 3f 00    	call   *0x3f3339(%rip)        # b020a0 <_DYNAMIC+0x288>
  70ed67:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ed6c:	e8 6f 5a ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ed71:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70ed78:	00 
  70ed79:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70ed80:	00 
  70ed81:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70ed88:	00 
  70ed89:	74 1c                	je     70eda7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x957>
  70ed8b:	84 c0                	test   %al,%al
  70ed8d:	74 0a                	je     70ed99 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x949>
  70ed8f:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70ed96:	ff 
  70ed97:	74 0e                	je     70eda7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x957>
  70ed99:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70eda0:	b9 01 00 00 00       	mov    $0x1,%ecx
  70eda5:	eb 02                	jmp    70eda9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x959>
  70eda7:	31 c9                	xor    %ecx,%ecx
  70eda9:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70edb0:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70edb4:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70edb8:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70edbc:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70edc0:	e9 f0 f9 ff ff       	jmp    70e7b5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x365>
  70edc5:	83 f8 23             	cmp    $0x23,%eax
  70edc8:	0f 85 eb 00 00 00    	jne    70eeb9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa69>
  70edce:	8b 44 24 30          	mov    0x30(%rsp),%eax
  70edd2:	83 f8 0d             	cmp    $0xd,%eax
  70edd5:	0f 84 12 01 00 00    	je     70eeed <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa9d>
  70eddb:	83 f8 0e             	cmp    $0xe,%eax
  70edde:	0f 85 d5 00 00 00    	jne    70eeb9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa69>
  70ede4:	ba 07 00 00 00       	mov    $0x7,%edx
  70ede9:	e9 04 01 00 00       	jmp    70eef2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaa2>
  70edee:	c6 84 24 a0 00 00 00 	movb   $0x0,0xa0(%rsp)
  70edf5:	00 
  70edf6:	c7 84 24 a4 00 00 00 	movl   $0x0,0xa4(%rsp)
  70edfd:	00 00 00 00 
  70ee01:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  70ee08:	00 
  70ee09:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  70ee0d:	ff 15 25 35 3f 00    	call   *0x3f3525(%rip)        # b02338 <_DYNAMIC+0x520>
  70ee13:	66 85 c0             	test   %ax,%ax
  70ee16:	74 2a                	je     70ee42 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x9f2>
  70ee18:	48 c1 e8 10          	shr    $0x10,%rax
  70ee1c:	48 89 df             	mov    %rbx,%rdi
  70ee1f:	4c 89 f6             	mov    %r14,%rsi
  70ee22:	89 c2                	mov    %eax,%edx
  70ee24:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70ee2b:	5b                   	pop    %rbx
  70ee2c:	41 5c                	pop    %r12
  70ee2e:	41 5d                	pop    %r13
  70ee30:	41 5e                	pop    %r14
  70ee32:	41 5f                	pop    %r15
  70ee34:	5d                   	pop    %rbp
  70ee35:	e9 f6 f4 ff ff       	jmp    70e330 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor>
  70ee3a:	c6 84 24 a0 00 00 00 	movb   $0xff,0xa0(%rsp)
  70ee41:	ff 
  70ee42:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  70ee49:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  70ee4d:	0f 84 8e 00 00 00    	je     70eee1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa91>
  70ee53:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  70ee5a:	00 00 
  70ee5c:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ee61:	e8 7a 59 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ee66:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70ee6d:	48 85 c0             	test   %rax,%rax
  70ee70:	0f 84 af 00 00 00    	je     70ef25 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xad5>
  70ee76:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70ee7d:	48 85 c0             	test   %rax,%rax
  70ee80:	0f 84 9f 00 00 00    	je     70ef25 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xad5>
  70ee86:	49 ff c7             	inc    %r15
  70ee89:	c6 40 13 ff          	movb   $0xff,0x13(%rax)
  70ee8d:	48 8d 84 24 a0 00 00 	lea    0xa0(%rsp),%rax
  70ee94:	00 
  70ee95:	48 89 04 24          	mov    %rax,(%rsp)
  70ee99:	48 89 df             	mov    %rbx,%rdi
  70ee9c:	4c 89 f6             	mov    %r14,%rsi
  70ee9f:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  70eea4:	4c 89 e1             	mov    %r12,%rcx
  70eea7:	4d 89 f8             	mov    %r15,%r8
  70eeaa:	44 8b 4c 24 08       	mov    0x8(%rsp),%r9d
  70eeaf:	e8 1c fe 00 00       	call   71ecd0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at>
  70eeb4:	e9 2c f6 ff ff       	jmp    70e4e5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70eeb9:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70eebe:	48 89 43 30          	mov    %rax,0x30(%rbx)
  70eec2:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70eec7:	0f 10 4c 24 38       	movups 0x38(%rsp),%xmm1
  70eecc:	0f 10 54 24 48       	movups 0x48(%rsp),%xmm2
  70eed1:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  70eed5:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  70eed9:	0f 11 03             	movups %xmm0,(%rbx)
  70eedc:	e9 04 f6 ff ff       	jmp    70e4e5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70eee1:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  70eee8:	e9 f8 f5 ff ff       	jmp    70e4e5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70eeed:	ba 06 00 00 00       	mov    $0x6,%edx
  70eef2:	48 89 df             	mov    %rbx,%rdi
  70eef5:	4c 89 f6             	mov    %r14,%rsi
  70eef8:	e8 33 f4 ff ff       	call   70e330 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor>
  70eefd:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ef02:	e8 d9 58 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ef07:	e9 d9 f5 ff ff       	jmp    70e4e5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70ef0c:	48 8d 3d 11 a5 95 ff 	lea    -0x6a5aef(%rip),%rdi        # 69424 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c04>
  70ef13:	48 8d 15 1e 53 3c 00 	lea    0x3c531e(%rip),%rdx        # ad4238 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x9c0>
  70ef1a:	be 28 00 00 00       	mov    $0x28,%esi
  70ef1f:	ff 15 73 31 3f 00    	call   *0x3f3173(%rip)        # b02098 <_DYNAMIC+0x280>
  70ef25:	48 8d 3d 39 a5 95 ff 	lea    -0x6a5ac7(%rip),%rdi        # 69465 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c45>
  70ef2c:	48 8d 15 15 52 3c 00 	lea    0x3c5215(%rip),%rdx        # ad4148 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x8d0>
  70ef33:	be 11 00 00 00       	mov    $0x11,%esi
  70ef38:	ff 15 42 32 3f 00    	call   *0x3f3242(%rip)        # b02180 <_DYNAMIC+0x368>
  70ef3e:	48 8d 3d 93 52 3c 00 	lea    0x3c5293(%rip),%rdi        # ad41d8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x960>
  70ef45:	ff 15 55 31 3f 00    	call   *0x3f3155(%rip)        # b020a0 <_DYNAMIC+0x288>
  70ef4b:	4c 89 ff             	mov    %r15,%rdi
  70ef4e:	48 8d 15 9b 52 3c 00 	lea    0x3c529b(%rip),%rdx        # ad41f0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x978>
  70ef55:	ff 15 35 32 3f 00    	call   *0x3f3235(%rip)        # b02190 <_DYNAMIC+0x378>
  70ef5b:	0f 0b                	ud2
  70ef5d:	48 8d 3d c0 a4 95 ff 	lea    -0x6a5b40(%rip),%rdi        # 69424 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c04>
  70ef64:	48 8d 15 e5 52 3c 00 	lea    0x3c52e5(%rip),%rdx        # ad4250 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x9d8>
  70ef6b:	be 28 00 00 00       	mov    $0x28,%esi
  70ef70:	ff 15 22 31 3f 00    	call   *0x3f3122(%rip)        # b02098 <_DYNAMIC+0x280>
  70ef76:	48 8d 15 8b 52 3c 00 	lea    0x3c528b(%rip),%rdx        # ad4208 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x990>
  70ef7d:	4c 89 e7             	mov    %r12,%rdi
  70ef80:	ff 15 0a 32 3f 00    	call   *0x3f320a(%rip)        # b02190 <_DYNAMIC+0x378>
  70ef86:	48 8d 15 93 52 3c 00 	lea    0x3c5293(%rip),%rdx        # ad4220 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x9a8>
  70ef8d:	4c 89 ff             	mov    %r15,%rdi
  70ef90:	ff 15 fa 31 3f 00    	call   *0x3f31fa(%rip)        # b02190 <_DYNAMIC+0x378>
  70ef96:	48 89 c3             	mov    %rax,%rbx
  70ef99:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ef9e:	e8 3d 58 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70efa3:	48 89 df             	mov    %rbx,%rdi
  70efa6:	e8 95 34 3c 00       	call   ad2440 <_Unwind_Resume@plt>
  70efab:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  70efb0:	48 89 c3             	mov    %rax,%rbx
  70efb3:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70efb7:	48 85 f6             	test   %rsi,%rsi
  70efba:	74 0d                	je     70efc9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xb79>
  70efbc:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70efc0:	48 89 ef             	mov    %rbp,%rdi
  70efc3:	ff 15 97 30 3f 00    	call   *0x3f3097(%rip)        # b02060 <_DYNAMIC+0x248>
  70efc9:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70efce:	49 89 06             	mov    %rax,(%r14)
  70efd1:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70efd6:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70efdb:	48 89 df             	mov    %rbx,%rdi
  70efde:	e8 5d 34 3c 00       	call   ad2440 <_Unwind_Resume@plt>
  70efe3:	48 89 c3             	mov    %rax,%rbx
  70efe6:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70efeb:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  70eff0:	e8 ab 28 ff ff       	call   7018a0 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  70eff5:	48 89 df             	mov    %rbx,%rdi
  70eff8:	e8 43 34 3c 00       	call   ad2440 <_Unwind_Resume@plt>
  70effd:	ff 15 ad 30 3f 00    	call   *0x3f30ad(%rip)        # b020b0 <_DYNAMIC+0x298>
