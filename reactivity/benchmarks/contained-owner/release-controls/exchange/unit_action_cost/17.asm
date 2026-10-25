
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070e370 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action>:
  70e370:	55                   	push   %rbp
  70e371:	41 57                	push   %r15
  70e373:	41 56                	push   %r14
  70e375:	41 55                	push   %r13
  70e377:	41 54                	push   %r12
  70e379:	53                   	push   %rbx
  70e37a:	48 81 ec 28 01 00 00 	sub    $0x128,%rsp
  70e381:	48 89 fb             	mov    %rdi,%rbx
  70e384:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  70e38b:	74 09                	je     70e396 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x26>
  70e38d:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  70e394:	eb 6f                	jmp    70e405 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e396:	49 89 f6             	mov    %rsi,%r14
  70e399:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  70e3a0:	48 85 c0             	test   %rax,%rax
  70e3a3:	74 59                	je     70e3fe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x8e>
  70e3a5:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70e3ac:	00 
  70e3ad:	74 4f                	je     70e3fe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x8e>
  70e3af:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70e3b6:	00 00 00 00 
  70e3ba:	48 8b a8 d8 00 00 00 	mov    0xd8(%rax),%rbp
  70e3c1:	48 85 ed             	test   %rbp,%rbp
  70e3c4:	0f 84 b0 08 00 00    	je     70ec7a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x90a>
  70e3ca:	44 0f b7 65 10       	movzwl 0x10(%rbp),%r12d
  70e3cf:	0f b6 7d 16          	movzbl 0x16(%rbp),%edi
  70e3d3:	44 0f b6 45 12       	movzbl 0x12(%rbp),%r8d
  70e3d8:	89 c8                	mov    %ecx,%eax
  70e3da:	66 83 e8 0e          	sub    $0xe,%ax
  70e3de:	41 bf 03 00 00 00    	mov    $0x3,%r15d
  70e3e4:	44 0f 43 f8          	cmovae %eax,%r15d
  70e3e8:	66 41 83 ff 03       	cmp    $0x3,%r15w
  70e3ed:	75 28                	jne    70e417 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa7>
  70e3ef:	66 41 39 cc          	cmp    %cx,%r12w
  70e3f3:	74 22                	je     70e417 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa7>
  70e3f5:	48 c7 03 11 00 00 00 	movq   $0x11,(%rbx)
  70e3fc:	eb 07                	jmp    70e405 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e3fe:	48 c7 03 1a 00 00 00 	movq   $0x1a,(%rbx)
  70e405:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70e40c:	5b                   	pop    %rbx
  70e40d:	41 5c                	pop    %r12
  70e40f:	41 5d                	pop    %r13
  70e411:	41 5e                	pop    %r14
  70e413:	41 5f                	pop    %r15
  70e415:	5d                   	pop    %rbp
  70e416:	c3                   	ret
  70e417:	41 89 cd             	mov    %ecx,%r13d
  70e41a:	41 c1 ed 10          	shr    $0x10,%r13d
  70e41e:	45 0f b7 cf          	movzwl %r15w,%r9d
  70e422:	48 8d 05 9f 83 95 ff 	lea    -0x6a7c61(%rip),%rax        # 667c8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x8>
  70e429:	4a 63 34 88          	movslq (%rax,%r9,4),%rsi
  70e42d:	48 01 c6             	add    %rax,%rsi
  70e430:	ff e6                	jmp    *%rsi
  70e432:	44 0f b7 ff          	movzwl %di,%r15d
  70e436:	41 81 cf 00 01 00 00 	or     $0x100,%r15d
  70e43d:	eb 12                	jmp    70e451 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xe1>
  70e43f:	45 0f b7 f8          	movzwl %r8w,%r15d
  70e443:	41 c1 e7 08          	shl    $0x8,%r15d
  70e447:	66 45 39 e5          	cmp    %r12w,%r13w
  70e44b:	0f 85 f3 02 00 00    	jne    70e744 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d4>
  70e451:	b0 01                	mov    $0x1,%al
  70e453:	44 38 ff             	cmp    %r15b,%dil
  70e456:	0f 85 ed 02 00 00    	jne    70e749 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d9>
  70e45c:	41 0f b7 cf          	movzwl %r15w,%ecx
  70e460:	c1 e9 08             	shr    $0x8,%ecx
  70e463:	41 38 c8             	cmp    %cl,%r8b
  70e466:	0f 85 dd 02 00 00    	jne    70e749 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d9>
  70e46c:	80 7d 13 ff          	cmpb   $0xff,0x13(%rbp)
  70e470:	0f 85 d3 02 00 00    	jne    70e749 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d9>
  70e476:	e9 c4 01 00 00       	jmp    70e63f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x2cf>
  70e47b:	f7 c1 00 00 ff 00    	test   $0xff0000,%ecx
  70e481:	0f 84 5d 02 00 00    	je     70e6e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x374>
  70e487:	48 8b 45 00          	mov    0x0(%rbp),%rax
  70e48b:	48 85 c0             	test   %rax,%rax
  70e48e:	0f 84 ab 01 00 00    	je     70e63f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x2cf>
  70e494:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  70e49b:	0f 85 d4 01 00 00    	jne    70e675 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x305>
  70e4a1:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  70e4a6:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  70e4ab:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  70e4b0:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  70e4b4:	4c 8b 65 08          	mov    0x8(%rbp),%r12
  70e4b8:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  70e4bf:	00 00 
  70e4c1:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e4c6:	e8 05 62 ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70e4cb:	48 8d bc 24 c0 00 00 	lea    0xc0(%rsp),%rdi
  70e4d2:	00 
  70e4d3:	4c 89 f6             	mov    %r14,%rsi
  70e4d6:	4c 89 e2             	mov    %r12,%rdx
  70e4d9:	e8 32 f8 00 00       	call   71dd10 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  70e4de:	48 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%rax
  70e4e5:	00 
  70e4e6:	4c 8b a4 24 c8 00 00 	mov    0xc8(%rsp),%r12
  70e4ed:	00 
  70e4ee:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70e4f2:	0f 85 fc 05 00 00    	jne    70eaf4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x784>
  70e4f8:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70e4ff:	48 85 c0             	test   %rax,%rax
  70e502:	0f 84 2f 06 00 00    	je     70eb37 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7c7>
  70e508:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70e50f:	00 
  70e510:	0f 84 21 06 00 00    	je     70eb37 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7c7>
  70e516:	49 8b ae a0 02 00 00 	mov    0x2a0(%r14),%rbp
  70e51d:	48 c7 44 24 28 1a 00 	movq   $0x1a,0x28(%rsp)
  70e524:	00 00 
  70e526:	48 83 fd 1c          	cmp    $0x1c,%rbp
  70e52a:	0f 82 07 06 00 00    	jb     70eb37 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7c7>
  70e530:	48 83 c5 e4          	add    $0xffffffffffffffe4,%rbp
  70e534:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e539:	e8 92 61 ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70e53e:	49 83 fc 02          	cmp    $0x2,%r12
  70e542:	0f 93 c0             	setae  %al
  70e545:	49 39 ec             	cmp    %rbp,%r12
  70e548:	0f 92 c1             	setb   %cl
  70e54b:	84 c8                	test   %cl,%al
  70e54d:	0f 84 22 01 00 00    	je     70e675 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x305>
  70e553:	66 41 83 ff 01       	cmp    $0x1,%r15w
  70e558:	0f 84 3d 06 00 00    	je     70eb9b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x82b>
  70e55e:	83 7c 24 18 03       	cmpl   $0x3,0x18(%rsp)
  70e563:	0f 85 c3 08 00 00    	jne    70ee2c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xabc>
  70e569:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e56e:	4c 89 f6             	mov    %r14,%rsi
  70e571:	4c 89 e2             	mov    %r12,%rdx
  70e574:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  70e578:	e8 03 04 01 00       	call   71e980 <<gpui::runtime::Runtime<unit_action_cost::Model>>::property_value_at>
  70e57d:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  70e582:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70e587:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  70e58e:	00 
  70e58f:	0f 10 44 24 3c       	movups 0x3c(%rsp),%xmm0
  70e594:	0f 11 84 24 cc 00 00 	movups %xmm0,0xcc(%rsp)
  70e59b:	00 
  70e59c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70e5a0:	0f 85 a4 06 00 00    	jne    70ec4a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x8da>
  70e5a6:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  70e5ad:	00 
  70e5ae:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  70e5b5:	00 
  70e5b6:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  70e5bd:	00 
  70e5be:	0f 11 84 24 0c 01 00 	movups %xmm0,0x10c(%rsp)
  70e5c5:	00 
  70e5c6:	41 0f b6 c5          	movzbl %r13b,%eax
  70e5ca:	48 8d 0d 07 82 95 ff 	lea    -0x6a7df9(%rip),%rcx        # 667d8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x18>
  70e5d1:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  70e5d5:	48 01 c8             	add    %rcx,%rax
  70e5d8:	ff e0                	jmp    *%rax
  70e5da:	8b 44 24 08          	mov    0x8(%rsp),%eax
  70e5de:	25 00 00 ff 00       	and    $0xff0000,%eax
  70e5e3:	31 c9                	xor    %ecx,%ecx
  70e5e5:	3d 00 00 02 00       	cmp    $0x20000,%eax
  70e5ea:	0f 94 c1             	sete   %cl
  70e5ed:	48 8d 05 7c 7f 95 ff 	lea    -0x6a8084(%rip),%rax        # 66570 <anon.079f5e587c394fcac2765eb4d0cf0bc2.21.llvm.6319143315422321905+0x30>
  70e5f4:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
  70e5f9:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e5fe:	48 8d b4 24 00 01 00 	lea    0x100(%rsp),%rsi
  70e605:	00 
  70e606:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  70e60b:	ff 15 3f 3c 3f 00    	call   *0x3f3c3f(%rip)        # b02250 <_DYNAMIC+0x508>
  70e611:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  70e616:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70e61a:	0f 85 c5 06 00 00    	jne    70ece5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x975>
  70e620:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70e625:	0f 10 4c 24 3c       	movups 0x3c(%rsp),%xmm1
  70e62a:	0f 11 8c 24 ac 00 00 	movups %xmm1,0xac(%rsp)
  70e631:	00 
  70e632:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  70e639:	00 
  70e63a:	e9 e2 06 00 00       	jmp    70ed21 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x9b1>
  70e63f:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70e646:	00 
  70e647:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70e64e:	00 
  70e64f:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70e656:	00 
  70e657:	74 66                	je     70e6bf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x34f>
  70e659:	84 c0                	test   %al,%al
  70e65b:	74 0a                	je     70e667 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x2f7>
  70e65d:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70e664:	ff 
  70e665:	74 58                	je     70e6bf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x34f>
  70e667:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70e66e:	b9 01 00 00 00       	mov    $0x1,%ecx
  70e673:	eb 4c                	jmp    70e6c1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x351>
  70e675:	48 c7 44 24 68 11 00 	movq   $0x11,0x68(%rsp)
  70e67c:	00 00 
  70e67e:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70e685:	00 
  70e686:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70e68d:	00 
  70e68e:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70e695:	00 
  70e696:	0f 84 26 04 00 00    	je     70eac2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x752>
  70e69c:	84 c0                	test   %al,%al
  70e69e:	74 0e                	je     70e6ae <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x33e>
  70e6a0:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70e6a7:	ff 
  70e6a8:	0f 84 14 04 00 00    	je     70eac2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x752>
  70e6ae:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70e6b5:	b9 01 00 00 00       	mov    $0x1,%ecx
  70e6ba:	e9 05 04 00 00       	jmp    70eac4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x754>
  70e6bf:	31 c9                	xor    %ecx,%ecx
  70e6c1:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70e6c5:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70e6c9:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70e6cd:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  70e6d4:	00 
  70e6d5:	88 43 30             	mov    %al,0x30(%rbx)
  70e6d8:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70e6df:	e9 21 fd ff ff       	jmp    70e405 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e6e4:	45 0f b7 f8          	movzwl %r8w,%r15d
  70e6e8:	8d 47 01             	lea    0x1(%rdi),%eax
  70e6eb:	89 44 24 18          	mov    %eax,0x18(%rsp)
  70e6ef:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  70e6f4:	89 cf                	mov    %ecx,%edi
  70e6f6:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  70e6fa:	45 89 c5             	mov    %r8d,%r13d
  70e6fd:	e8 ce da ff ff       	call   70c1d0 <<gpui::property::PropertyId>::info>
  70e702:	45 89 e8             	mov    %r13d,%r8d
  70e705:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70e70a:	44 8b 6c 24 08       	mov    0x8(%rsp),%r13d
  70e70f:	0f b6 40 14          	movzbl 0x14(%rax),%eax
  70e713:	31 c9                	xor    %ecx,%ecx
  70e715:	3c 04                	cmp    $0x4,%al
  70e717:	0f 94 c1             	sete   %cl
  70e71a:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  70e71d:	ff c1                	inc    %ecx
  70e71f:	3c 02                	cmp    $0x2,%al
  70e721:	ba 04 00 00 00       	mov    $0x4,%edx
  70e726:	0f 45 d1             	cmovne %ecx,%edx
  70e729:	0f b6 44 24 18       	movzbl 0x18(%rsp),%eax
  70e72e:	f6 f2                	div    %dl
  70e730:	0f b6 c4             	movzbl %ah,%eax
  70e733:	41 c1 e7 08          	shl    $0x8,%r15d
  70e737:	41 09 c7             	or     %eax,%r15d
  70e73a:	66 45 39 e5          	cmp    %r12w,%r13w
  70e73e:	0f 84 0d fd ff ff    	je     70e451 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xe1>
  70e744:	31 c0                	xor    %eax,%eax
  70e746:	45 89 ec             	mov    %r13d,%r12d
  70e749:	49 8b 96 60 06 00 00 	mov    0x660(%r14),%rdx
  70e750:	48 ff c2             	inc    %rdx
  70e753:	0f 84 a8 06 00 00    	je     70ee01 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa91>
  70e759:	41 0f b7 cf          	movzwl %r15w,%ecx
  70e75d:	66 44 89 65 10       	mov    %r12w,0x10(%rbp)
  70e762:	88 4d 16             	mov    %cl,0x16(%rbp)
  70e765:	88 6d 12             	mov    %ch,0x12(%rbp)
  70e768:	c6 45 13 ff          	movb   $0xff,0x13(%rbp)
  70e76c:	84 c0                	test   %al,%al
  70e76e:	0f 85 11 03 00 00    	jne    70ea85 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x715>
  70e774:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70e77b:	48 85 c0             	test   %rax,%rax
  70e77e:	0f 84 da 06 00 00    	je     70ee5e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaee>
  70e784:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70e78b:	00 
  70e78c:	0f 84 cc 06 00 00    	je     70ee5e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaee>
  70e792:	4d 8b be a0 02 00 00 	mov    0x2a0(%r14),%r15
  70e799:	49 83 ff 1c          	cmp    $0x1c,%r15
  70e79d:	0f 82 bb 06 00 00    	jb     70ee5e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaee>
  70e7a3:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  70e7a8:	41 0f b7 fc          	movzwl %r12w,%edi
  70e7ac:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  70e7b1:	ff 15 a1 3a 3f 00    	call   *0x3f3aa1(%rip)        # b02258 <_DYNAMIC+0x510>
  70e7b7:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70e7bc:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70e7c1:	49 8d 7f f7          	lea    -0x9(%r15),%rdi
  70e7c5:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70e7cc:	48 39 f7             	cmp    %rsi,%rdi
  70e7cf:	0f 83 99 06 00 00    	jae    70ee6e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70e7d5:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70e7dc:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70e7e0:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70e7e4:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70e7e9:	48 85 ed             	test   %rbp,%rbp
  70e7ec:	74 36                	je     70e824 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x4b4>
  70e7ee:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70e7f3:	49 8b 45 00          	mov    0x0(%r13),%rax
  70e7f7:	48 85 c0             	test   %rax,%rax
  70e7fa:	74 12                	je     70e80e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x49e>
  70e7fc:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70e800:	48 83 c1 08          	add    $0x8,%rcx
  70e804:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70e809:	48 89 ef             	mov    %rbp,%rdi
  70e80c:	ff d0                	call   *%rax
  70e80e:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70e812:	48 85 f6             	test   %rsi,%rsi
  70e815:	74 0d                	je     70e824 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x4b4>
  70e817:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70e81b:	48 89 ef             	mov    %rbp,%rdi
  70e81e:	ff 15 6c 37 3f 00    	call   *0x3f376c(%rip)        # b01f90 <_DYNAMIC+0x248>
  70e824:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70e829:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70e82e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70e833:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70e838:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70e83d:	8d b8 00 00 01 00    	lea    0x10000(%rax),%edi
  70e843:	ff 15 0f 3a 3f 00    	call   *0x3f3a0f(%rip)        # b02258 <_DYNAMIC+0x510>
  70e849:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70e84e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70e853:	49 8d 7f f9          	lea    -0x7(%r15),%rdi
  70e857:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70e85e:	48 39 f7             	cmp    %rsi,%rdi
  70e861:	0f 83 07 06 00 00    	jae    70ee6e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70e867:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70e86e:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70e872:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70e876:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70e87b:	48 85 ed             	test   %rbp,%rbp
  70e87e:	74 36                	je     70e8b6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x546>
  70e880:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70e885:	49 8b 45 00          	mov    0x0(%r13),%rax
  70e889:	48 85 c0             	test   %rax,%rax
  70e88c:	74 12                	je     70e8a0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x530>
  70e88e:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70e892:	48 83 c1 08          	add    $0x8,%rcx
  70e896:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70e89b:	48 89 ef             	mov    %rbp,%rdi
  70e89e:	ff d0                	call   *%rax
  70e8a0:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70e8a4:	48 85 f6             	test   %rsi,%rsi
  70e8a7:	74 0d                	je     70e8b6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x546>
  70e8a9:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70e8ad:	48 89 ef             	mov    %rbp,%rdi
  70e8b0:	ff 15 da 36 3f 00    	call   *0x3f36da(%rip)        # b01f90 <_DYNAMIC+0x248>
  70e8b6:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70e8bb:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70e8c0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70e8c5:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70e8ca:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70e8cf:	8d b8 00 00 02 00    	lea    0x20000(%rax),%edi
  70e8d5:	ff 15 7d 39 3f 00    	call   *0x3f397d(%rip)        # b02258 <_DYNAMIC+0x510>
  70e8db:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70e8e0:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70e8e5:	49 8d 7f fa          	lea    -0x6(%r15),%rdi
  70e8e9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70e8f0:	48 39 f7             	cmp    %rsi,%rdi
  70e8f3:	0f 83 75 05 00 00    	jae    70ee6e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70e8f9:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70e900:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70e904:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70e908:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70e90d:	48 85 ed             	test   %rbp,%rbp
  70e910:	74 36                	je     70e948 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x5d8>
  70e912:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70e917:	49 8b 45 00          	mov    0x0(%r13),%rax
  70e91b:	48 85 c0             	test   %rax,%rax
  70e91e:	74 12                	je     70e932 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x5c2>
  70e920:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70e924:	48 83 c1 08          	add    $0x8,%rcx
  70e928:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70e92d:	48 89 ef             	mov    %rbp,%rdi
  70e930:	ff d0                	call   *%rax
  70e932:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70e936:	48 85 f6             	test   %rsi,%rsi
  70e939:	74 0d                	je     70e948 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x5d8>
  70e93b:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70e93f:	48 89 ef             	mov    %rbp,%rdi
  70e942:	ff 15 48 36 3f 00    	call   *0x3f3648(%rip)        # b01f90 <_DYNAMIC+0x248>
  70e948:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70e94d:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70e952:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70e957:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70e95c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70e961:	8d b8 00 00 03 00    	lea    0x30000(%rax),%edi
  70e967:	ff 15 eb 38 3f 00    	call   *0x3f38eb(%rip)        # b02258 <_DYNAMIC+0x510>
  70e96d:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70e972:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70e977:	49 8d 7f fb          	lea    -0x5(%r15),%rdi
  70e97b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70e982:	48 39 f7             	cmp    %rsi,%rdi
  70e985:	0f 83 e3 04 00 00    	jae    70ee6e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70e98b:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70e992:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70e996:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70e99a:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70e99f:	48 85 ed             	test   %rbp,%rbp
  70e9a2:	74 36                	je     70e9da <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x66a>
  70e9a4:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70e9a9:	49 8b 45 00          	mov    0x0(%r13),%rax
  70e9ad:	48 85 c0             	test   %rax,%rax
  70e9b0:	74 12                	je     70e9c4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x654>
  70e9b2:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70e9b6:	48 83 c1 08          	add    $0x8,%rcx
  70e9ba:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70e9bf:	48 89 ef             	mov    %rbp,%rdi
  70e9c2:	ff d0                	call   *%rax
  70e9c4:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70e9c8:	48 85 f6             	test   %rsi,%rsi
  70e9cb:	74 0d                	je     70e9da <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x66a>
  70e9cd:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70e9d1:	48 89 ef             	mov    %rbp,%rdi
  70e9d4:	ff 15 b6 35 3f 00    	call   *0x3f35b6(%rip)        # b01f90 <_DYNAMIC+0x248>
  70e9da:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70e9df:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70e9e4:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70e9e9:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70e9ee:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  70e9f3:	81 cf 00 00 04 00    	or     $0x40000,%edi
  70e9f9:	ff 15 59 38 3f 00    	call   *0x3f3859(%rip)        # b02258 <_DYNAMIC+0x510>
  70e9ff:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70ea04:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70ea09:	49 83 c7 fc          	add    $0xfffffffffffffffc,%r15
  70ea0d:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70ea14:	49 39 f7             	cmp    %rsi,%r15
  70ea17:	0f 83 4e 04 00 00    	jae    70ee6b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafb>
  70ea1d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70ea24:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  70ea28:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70ea2c:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70ea31:	48 85 ed             	test   %rbp,%rbp
  70ea34:	74 36                	je     70ea6c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x6fc>
  70ea36:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70ea3b:	49 8b 45 00          	mov    0x0(%r13),%rax
  70ea3f:	48 85 c0             	test   %rax,%rax
  70ea42:	74 12                	je     70ea56 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x6e6>
  70ea44:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70ea48:	48 83 c1 08          	add    $0x8,%rcx
  70ea4c:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70ea51:	48 89 ef             	mov    %rbp,%rdi
  70ea54:	ff d0                	call   *%rax
  70ea56:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70ea5a:	48 85 f6             	test   %rsi,%rsi
  70ea5d:	74 0d                	je     70ea6c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x6fc>
  70ea5f:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70ea63:	48 89 ef             	mov    %rbp,%rdi
  70ea66:	ff 15 24 35 3f 00    	call   *0x3f3524(%rip)        # b01f90 <_DYNAMIC+0x248>
  70ea6c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70ea71:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70ea76:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70ea7b:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70ea80:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  70ea85:	49 89 96 60 06 00 00 	mov    %rdx,0x660(%r14)
  70ea8c:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  70ea93:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70ea9a:	00 00 00 00 
  70ea9e:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  70eaa5:	01 
  70eaa6:	48 89 df             	mov    %rbx,%rdi
  70eaa9:	4c 89 f6             	mov    %r14,%rsi
  70eaac:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70eab3:	5b                   	pop    %rbx
  70eab4:	41 5c                	pop    %r12
  70eab6:	41 5d                	pop    %r13
  70eab8:	41 5e                	pop    %r14
  70eaba:	41 5f                	pop    %r15
  70eabc:	5d                   	pop    %rbp
  70eabd:	e9 be fa 00 00       	jmp    71e580 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70eac2:	31 c9                	xor    %ecx,%ecx
  70eac4:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70eacb:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70eacf:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70ead3:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70ead7:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70eadb:	88 43 30             	mov    %al,0x30(%rbx)
  70eade:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70eae5:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  70eaea:	e8 e1 5b ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70eaef:	e9 11 f9 ff ff       	jmp    70e405 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70eaf4:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  70eafb:	00 
  70eafc:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  70eb03:	00 
  70eb04:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  70eb0b:	00 
  70eb0c:	0f 10 8c 24 e0 00 00 	movups 0xe0(%rsp),%xmm1
  70eb13:	00 
  70eb14:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70eb1b:	00 
  70eb1c:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70eb21:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  70eb26:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  70eb2b:	48 83 f8 11          	cmp    $0x11,%rax
  70eb2f:	0f 84 49 fb ff ff    	je     70e67e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x30e>
  70eb35:	eb 2d                	jmp    70eb64 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7f4>
  70eb37:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70eb3c:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  70eb43:	00 
  70eb44:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70eb49:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  70eb4e:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70eb55:	00 
  70eb56:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70eb5b:	48 c7 44 24 68 1a 00 	movq   $0x1a,0x68(%rsp)
  70eb62:	00 00 
  70eb64:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  70eb6b:	00 
  70eb6c:	48 89 43 30          	mov    %rax,0x30(%rbx)
  70eb70:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  70eb75:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  70eb7a:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  70eb7f:	0f 10 8c 24 88 00 00 	movups 0x88(%rsp),%xmm1
  70eb86:	00 
  70eb87:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  70eb8b:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  70eb8f:	48 89 03             	mov    %rax,(%rbx)
  70eb92:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70eb96:	e9 6a f8 ff ff       	jmp    70e405 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70eb9b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70eba2:	49 39 f4             	cmp    %rsi,%r12
  70eba5:	0f 83 eb 02 00 00    	jae    70ee96 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xb26>
  70ebab:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70ebb2:	4b 8d 0c a4          	lea    (%r12,%r12,4),%rcx
  70ebb6:	44 8b 7c c8 18       	mov    0x18(%rax,%rcx,8),%r15d
  70ebbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  70ebc0:	49 39 c7             	cmp    %rax,%r15
  70ebc3:	0f 84 2c f8 ff ff    	je     70e3f5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x85>
  70ebc9:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  70ebd0:	00 00 
  70ebd2:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ebd7:	e8 f4 5a ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ebdc:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70ebe3:	4c 39 fe             	cmp    %r15,%rsi
  70ebe6:	0f 86 ba 02 00 00    	jbe    70eea6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xb36>
  70ebec:	49 8d be b0 05 00 00 	lea    0x5b0(%r14),%rdi
  70ebf3:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70ebfa:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  70ebfe:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
  70ec02:	ff 15 58 36 3f 00    	call   *0x3f3658(%rip)        # b02260 <_DYNAMIC+0x518>
  70ec08:	49 89 c7             	mov    %rax,%r15
  70ec0b:	49 89 d4             	mov    %rdx,%r12
  70ec0e:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ec13:	4c 89 f6             	mov    %r14,%rsi
  70ec16:	48 89 c2             	mov    %rax,%rdx
  70ec19:	4c 89 e1             	mov    %r12,%rcx
  70ec1c:	e8 5f f5 ff ff       	call   70e180 <<gpui::runtime::Runtime<unit_action_cost::Model>>::inspector_app_index>
  70ec21:	83 7c 24 28 fe       	cmpl   $0xfffffffe,0x28(%rsp)
  70ec26:	75 5f                	jne    70ec87 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x917>
  70ec28:	48 89 df             	mov    %rbx,%rdi
  70ec2b:	4c 89 f6             	mov    %r14,%rsi
  70ec2e:	4c 89 fa             	mov    %r15,%rdx
  70ec31:	4c 89 e1             	mov    %r12,%rcx
  70ec34:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70ec3b:	5b                   	pop    %rbx
  70ec3c:	41 5c                	pop    %r12
  70ec3e:	41 5d                	pop    %r13
  70ec40:	41 5e                	pop    %r14
  70ec42:	41 5f                	pop    %r15
  70ec44:	5d                   	pop    %rbp
  70ec45:	e9 e6 02 00 00       	jmp    70ef30 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select>
  70ec4a:	8b 4c 24 5c          	mov    0x5c(%rsp),%ecx
  70ec4e:	89 4b 34             	mov    %ecx,0x34(%rbx)
  70ec51:	0f 10 44 24 4c       	movups 0x4c(%rsp),%xmm0
  70ec56:	0f 11 43 24          	movups %xmm0,0x24(%rbx)
  70ec5a:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  70ec61:	00 
  70ec62:	0f 11 43 14          	movups %xmm0,0x14(%rbx)
  70ec66:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  70ec6d:	00 
  70ec6e:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  70ec72:	48 89 03             	mov    %rax,(%rbx)
  70ec75:	e9 8b f7 ff ff       	jmp    70e405 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70ec7a:	48 8d 3d af 54 3c 00 	lea    0x3c54af(%rip),%rdi        # ad4130 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x948>
  70ec81:	ff 15 49 33 3f 00    	call   *0x3f3349(%rip)        # b01fd0 <_DYNAMIC+0x288>
  70ec87:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ec8c:	e8 3f 5a ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ec91:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70ec98:	00 
  70ec99:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70eca0:	00 
  70eca1:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70eca8:	00 
  70eca9:	74 1c                	je     70ecc7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x957>
  70ecab:	84 c0                	test   %al,%al
  70ecad:	74 0a                	je     70ecb9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x949>
  70ecaf:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70ecb6:	ff 
  70ecb7:	74 0e                	je     70ecc7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x957>
  70ecb9:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70ecc0:	b9 01 00 00 00       	mov    $0x1,%ecx
  70ecc5:	eb 02                	jmp    70ecc9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x959>
  70ecc7:	31 c9                	xor    %ecx,%ecx
  70ecc9:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70ecd0:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70ecd4:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70ecd8:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70ecdc:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70ece0:	e9 f0 f9 ff ff       	jmp    70e6d5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x365>
  70ece5:	83 f8 23             	cmp    $0x23,%eax
  70ece8:	0f 85 eb 00 00 00    	jne    70edd9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa69>
  70ecee:	8b 44 24 30          	mov    0x30(%rsp),%eax
  70ecf2:	83 f8 0d             	cmp    $0xd,%eax
  70ecf5:	0f 84 12 01 00 00    	je     70ee0d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa9d>
  70ecfb:	83 f8 0e             	cmp    $0xe,%eax
  70ecfe:	0f 85 d5 00 00 00    	jne    70edd9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa69>
  70ed04:	ba 07 00 00 00       	mov    $0x7,%edx
  70ed09:	e9 04 01 00 00       	jmp    70ee12 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaa2>
  70ed0e:	c6 84 24 a0 00 00 00 	movb   $0x0,0xa0(%rsp)
  70ed15:	00 
  70ed16:	c7 84 24 a4 00 00 00 	movl   $0x0,0xa4(%rsp)
  70ed1d:	00 00 00 00 
  70ed21:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  70ed28:	00 
  70ed29:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  70ed2d:	ff 15 35 35 3f 00    	call   *0x3f3535(%rip)        # b02268 <_DYNAMIC+0x520>
  70ed33:	66 85 c0             	test   %ax,%ax
  70ed36:	74 2a                	je     70ed62 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x9f2>
  70ed38:	48 c1 e8 10          	shr    $0x10,%rax
  70ed3c:	48 89 df             	mov    %rbx,%rdi
  70ed3f:	4c 89 f6             	mov    %r14,%rsi
  70ed42:	89 c2                	mov    %eax,%edx
  70ed44:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70ed4b:	5b                   	pop    %rbx
  70ed4c:	41 5c                	pop    %r12
  70ed4e:	41 5d                	pop    %r13
  70ed50:	41 5e                	pop    %r14
  70ed52:	41 5f                	pop    %r15
  70ed54:	5d                   	pop    %rbp
  70ed55:	e9 f6 f4 ff ff       	jmp    70e250 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor>
  70ed5a:	c6 84 24 a0 00 00 00 	movb   $0xff,0xa0(%rsp)
  70ed61:	ff 
  70ed62:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  70ed69:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  70ed6d:	0f 84 8e 00 00 00    	je     70ee01 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa91>
  70ed73:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  70ed7a:	00 00 
  70ed7c:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ed81:	e8 4a 59 ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ed86:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70ed8d:	48 85 c0             	test   %rax,%rax
  70ed90:	0f 84 af 00 00 00    	je     70ee45 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xad5>
  70ed96:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70ed9d:	48 85 c0             	test   %rax,%rax
  70eda0:	0f 84 9f 00 00 00    	je     70ee45 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xad5>
  70eda6:	49 ff c7             	inc    %r15
  70eda9:	c6 40 13 ff          	movb   $0xff,0x13(%rax)
  70edad:	48 8d 84 24 a0 00 00 	lea    0xa0(%rsp),%rax
  70edb4:	00 
  70edb5:	48 89 04 24          	mov    %rax,(%rsp)
  70edb9:	48 89 df             	mov    %rbx,%rdi
  70edbc:	4c 89 f6             	mov    %r14,%rsi
  70edbf:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  70edc4:	4c 89 e1             	mov    %r12,%rcx
  70edc7:	4d 89 f8             	mov    %r15,%r8
  70edca:	44 8b 4c 24 08       	mov    0x8(%rsp),%r9d
  70edcf:	e8 1c fe 00 00       	call   71ebf0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at>
  70edd4:	e9 2c f6 ff ff       	jmp    70e405 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70edd9:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70edde:	48 89 43 30          	mov    %rax,0x30(%rbx)
  70ede2:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70ede7:	0f 10 4c 24 38       	movups 0x38(%rsp),%xmm1
  70edec:	0f 10 54 24 48       	movups 0x48(%rsp),%xmm2
  70edf1:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  70edf5:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  70edf9:	0f 11 03             	movups %xmm0,(%rbx)
  70edfc:	e9 04 f6 ff ff       	jmp    70e405 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70ee01:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  70ee08:	e9 f8 f5 ff ff       	jmp    70e405 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70ee0d:	ba 06 00 00 00       	mov    $0x6,%edx
  70ee12:	48 89 df             	mov    %rbx,%rdi
  70ee15:	4c 89 f6             	mov    %r14,%rsi
  70ee18:	e8 33 f4 ff ff       	call   70e250 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor>
  70ee1d:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ee22:	e8 a9 58 ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ee27:	e9 d9 f5 ff ff       	jmp    70e405 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70ee2c:	48 8d 3d 91 a5 95 ff 	lea    -0x6a5a6f(%rip),%rdi        # 693c4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c04>
  70ee33:	48 8d 15 6e 53 3c 00 	lea    0x3c536e(%rip),%rdx        # ad41a8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x9c0>
  70ee3a:	be 28 00 00 00       	mov    $0x28,%esi
  70ee3f:	ff 15 83 31 3f 00    	call   *0x3f3183(%rip)        # b01fc8 <_DYNAMIC+0x280>
  70ee45:	48 8d 3d b9 a5 95 ff 	lea    -0x6a5a47(%rip),%rdi        # 69405 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c45>
  70ee4c:	48 8d 15 65 52 3c 00 	lea    0x3c5265(%rip),%rdx        # ad40b8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x8d0>
  70ee53:	be 11 00 00 00       	mov    $0x11,%esi
  70ee58:	ff 15 52 32 3f 00    	call   *0x3f3252(%rip)        # b020b0 <_DYNAMIC+0x368>
  70ee5e:	48 8d 3d e3 52 3c 00 	lea    0x3c52e3(%rip),%rdi        # ad4148 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x960>
  70ee65:	ff 15 65 31 3f 00    	call   *0x3f3165(%rip)        # b01fd0 <_DYNAMIC+0x288>
  70ee6b:	4c 89 ff             	mov    %r15,%rdi
  70ee6e:	48 8d 15 eb 52 3c 00 	lea    0x3c52eb(%rip),%rdx        # ad4160 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x978>
  70ee75:	ff 15 45 32 3f 00    	call   *0x3f3245(%rip)        # b020c0 <_DYNAMIC+0x378>
  70ee7b:	0f 0b                	ud2
  70ee7d:	48 8d 3d 40 a5 95 ff 	lea    -0x6a5ac0(%rip),%rdi        # 693c4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c04>
  70ee84:	48 8d 15 35 53 3c 00 	lea    0x3c5335(%rip),%rdx        # ad41c0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x9d8>
  70ee8b:	be 28 00 00 00       	mov    $0x28,%esi
  70ee90:	ff 15 32 31 3f 00    	call   *0x3f3132(%rip)        # b01fc8 <_DYNAMIC+0x280>
  70ee96:	48 8d 15 db 52 3c 00 	lea    0x3c52db(%rip),%rdx        # ad4178 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x990>
  70ee9d:	4c 89 e7             	mov    %r12,%rdi
  70eea0:	ff 15 1a 32 3f 00    	call   *0x3f321a(%rip)        # b020c0 <_DYNAMIC+0x378>
  70eea6:	48 8d 15 e3 52 3c 00 	lea    0x3c52e3(%rip),%rdx        # ad4190 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x9a8>
  70eead:	4c 89 ff             	mov    %r15,%rdi
  70eeb0:	ff 15 0a 32 3f 00    	call   *0x3f320a(%rip)        # b020c0 <_DYNAMIC+0x378>
  70eeb6:	48 89 c3             	mov    %rax,%rbx
  70eeb9:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70eebe:	e8 0d 58 ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70eec3:	48 89 df             	mov    %rbx,%rdi
  70eec6:	e8 e5 34 3c 00       	call   ad23b0 <_Unwind_Resume@plt>
  70eecb:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  70eed0:	48 89 c3             	mov    %rax,%rbx
  70eed3:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70eed7:	48 85 f6             	test   %rsi,%rsi
  70eeda:	74 0d                	je     70eee9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xb79>
  70eedc:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70eee0:	48 89 ef             	mov    %rbp,%rdi
  70eee3:	ff 15 a7 30 3f 00    	call   *0x3f30a7(%rip)        # b01f90 <_DYNAMIC+0x248>
  70eee9:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70eeee:	49 89 06             	mov    %rax,(%r14)
  70eef1:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70eef6:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70eefb:	48 89 df             	mov    %rbx,%rdi
  70eefe:	e8 ad 34 3c 00       	call   ad23b0 <_Unwind_Resume@plt>
  70ef03:	48 89 c3             	mov    %rax,%rbx
  70ef06:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70ef0b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  70ef10:	e8 7b 28 ff ff       	call   701790 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  70ef15:	48 89 df             	mov    %rbx,%rdi
  70ef18:	e8 93 34 3c 00       	call   ad23b0 <_Unwind_Resume@plt>
  70ef1d:	ff 15 bd 30 3f 00    	call   *0x3f30bd(%rip)        # b01fe0 <_DYNAMIC+0x298>
