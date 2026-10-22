
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070e480 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action>:
  70e480:	55                   	push   %rbp
  70e481:	41 57                	push   %r15
  70e483:	41 56                	push   %r14
  70e485:	41 55                	push   %r13
  70e487:	41 54                	push   %r12
  70e489:	53                   	push   %rbx
  70e48a:	48 81 ec 28 01 00 00 	sub    $0x128,%rsp
  70e491:	48 89 fb             	mov    %rdi,%rbx
  70e494:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  70e49b:	74 09                	je     70e4a6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x26>
  70e49d:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  70e4a4:	eb 6f                	jmp    70e515 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e4a6:	49 89 f6             	mov    %rsi,%r14
  70e4a9:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  70e4b0:	48 85 c0             	test   %rax,%rax
  70e4b3:	74 59                	je     70e50e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x8e>
  70e4b5:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70e4bc:	00 
  70e4bd:	74 4f                	je     70e50e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x8e>
  70e4bf:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70e4c6:	00 00 00 00 
  70e4ca:	48 8b a8 d8 00 00 00 	mov    0xd8(%rax),%rbp
  70e4d1:	48 85 ed             	test   %rbp,%rbp
  70e4d4:	0f 84 b0 08 00 00    	je     70ed8a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x90a>
  70e4da:	44 0f b7 65 10       	movzwl 0x10(%rbp),%r12d
  70e4df:	0f b6 7d 16          	movzbl 0x16(%rbp),%edi
  70e4e3:	44 0f b6 45 12       	movzbl 0x12(%rbp),%r8d
  70e4e8:	89 c8                	mov    %ecx,%eax
  70e4ea:	66 83 e8 0e          	sub    $0xe,%ax
  70e4ee:	41 bf 03 00 00 00    	mov    $0x3,%r15d
  70e4f4:	44 0f 43 f8          	cmovae %eax,%r15d
  70e4f8:	66 41 83 ff 03       	cmp    $0x3,%r15w
  70e4fd:	75 28                	jne    70e527 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa7>
  70e4ff:	66 41 39 cc          	cmp    %cx,%r12w
  70e503:	74 22                	je     70e527 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa7>
  70e505:	48 c7 03 11 00 00 00 	movq   $0x11,(%rbx)
  70e50c:	eb 07                	jmp    70e515 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e50e:	48 c7 03 1a 00 00 00 	movq   $0x1a,(%rbx)
  70e515:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70e51c:	5b                   	pop    %rbx
  70e51d:	41 5c                	pop    %r12
  70e51f:	41 5d                	pop    %r13
  70e521:	41 5e                	pop    %r14
  70e523:	41 5f                	pop    %r15
  70e525:	5d                   	pop    %rbp
  70e526:	c3                   	ret
  70e527:	41 89 cd             	mov    %ecx,%r13d
  70e52a:	41 c1 ed 10          	shr    $0x10,%r13d
  70e52e:	45 0f b7 cf          	movzwl %r15w,%r9d
  70e532:	48 8d 05 ef 82 95 ff 	lea    -0x6a7d11(%rip),%rax        # 66828 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x8>
  70e539:	4a 63 34 88          	movslq (%rax,%r9,4),%rsi
  70e53d:	48 01 c6             	add    %rax,%rsi
  70e540:	ff e6                	jmp    *%rsi
  70e542:	44 0f b7 ff          	movzwl %di,%r15d
  70e546:	41 81 cf 00 01 00 00 	or     $0x100,%r15d
  70e54d:	eb 12                	jmp    70e561 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xe1>
  70e54f:	45 0f b7 f8          	movzwl %r8w,%r15d
  70e553:	41 c1 e7 08          	shl    $0x8,%r15d
  70e557:	66 45 39 e5          	cmp    %r12w,%r13w
  70e55b:	0f 85 f3 02 00 00    	jne    70e854 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d4>
  70e561:	b0 01                	mov    $0x1,%al
  70e563:	44 38 ff             	cmp    %r15b,%dil
  70e566:	0f 85 ed 02 00 00    	jne    70e859 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d9>
  70e56c:	41 0f b7 cf          	movzwl %r15w,%ecx
  70e570:	c1 e9 08             	shr    $0x8,%ecx
  70e573:	41 38 c8             	cmp    %cl,%r8b
  70e576:	0f 85 dd 02 00 00    	jne    70e859 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d9>
  70e57c:	80 7d 13 ff          	cmpb   $0xff,0x13(%rbp)
  70e580:	0f 85 d3 02 00 00    	jne    70e859 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d9>
  70e586:	e9 c4 01 00 00       	jmp    70e74f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x2cf>
  70e58b:	f7 c1 00 00 ff 00    	test   $0xff0000,%ecx
  70e591:	0f 84 5d 02 00 00    	je     70e7f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x374>
  70e597:	48 8b 45 00          	mov    0x0(%rbp),%rax
  70e59b:	48 85 c0             	test   %rax,%rax
  70e59e:	0f 84 ab 01 00 00    	je     70e74f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x2cf>
  70e5a4:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  70e5ab:	0f 85 d4 01 00 00    	jne    70e785 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x305>
  70e5b1:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  70e5b6:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  70e5bb:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  70e5c0:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  70e5c4:	4c 8b 65 08          	mov    0x8(%rbp),%r12
  70e5c8:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  70e5cf:	00 00 
  70e5d1:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e5d6:	e8 05 62 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70e5db:	48 8d bc 24 c0 00 00 	lea    0xc0(%rsp),%rdi
  70e5e2:	00 
  70e5e3:	4c 89 f6             	mov    %r14,%rsi
  70e5e6:	4c 89 e2             	mov    %r12,%rdx
  70e5e9:	e8 32 f8 00 00       	call   71de20 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  70e5ee:	48 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%rax
  70e5f5:	00 
  70e5f6:	4c 8b a4 24 c8 00 00 	mov    0xc8(%rsp),%r12
  70e5fd:	00 
  70e5fe:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70e602:	0f 85 fc 05 00 00    	jne    70ec04 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x784>
  70e608:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70e60f:	48 85 c0             	test   %rax,%rax
  70e612:	0f 84 2f 06 00 00    	je     70ec47 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7c7>
  70e618:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70e61f:	00 
  70e620:	0f 84 21 06 00 00    	je     70ec47 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7c7>
  70e626:	49 8b ae a0 02 00 00 	mov    0x2a0(%r14),%rbp
  70e62d:	48 c7 44 24 28 1a 00 	movq   $0x1a,0x28(%rsp)
  70e634:	00 00 
  70e636:	48 83 fd 1c          	cmp    $0x1c,%rbp
  70e63a:	0f 82 07 06 00 00    	jb     70ec47 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7c7>
  70e640:	48 83 c5 e4          	add    $0xffffffffffffffe4,%rbp
  70e644:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e649:	e8 92 61 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70e64e:	49 83 fc 02          	cmp    $0x2,%r12
  70e652:	0f 93 c0             	setae  %al
  70e655:	49 39 ec             	cmp    %rbp,%r12
  70e658:	0f 92 c1             	setb   %cl
  70e65b:	84 c8                	test   %cl,%al
  70e65d:	0f 84 22 01 00 00    	je     70e785 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x305>
  70e663:	66 41 83 ff 01       	cmp    $0x1,%r15w
  70e668:	0f 84 3d 06 00 00    	je     70ecab <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x82b>
  70e66e:	83 7c 24 18 03       	cmpl   $0x3,0x18(%rsp)
  70e673:	0f 85 c3 08 00 00    	jne    70ef3c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xabc>
  70e679:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e67e:	4c 89 f6             	mov    %r14,%rsi
  70e681:	4c 89 e2             	mov    %r12,%rdx
  70e684:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  70e688:	e8 03 04 01 00       	call   71ea90 <<gpui::runtime::Runtime<unit_action_cost::Model>>::property_value_at>
  70e68d:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  70e692:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70e697:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  70e69e:	00 
  70e69f:	0f 10 44 24 3c       	movups 0x3c(%rsp),%xmm0
  70e6a4:	0f 11 84 24 cc 00 00 	movups %xmm0,0xcc(%rsp)
  70e6ab:	00 
  70e6ac:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70e6b0:	0f 85 a4 06 00 00    	jne    70ed5a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x8da>
  70e6b6:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  70e6bd:	00 
  70e6be:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  70e6c5:	00 
  70e6c6:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  70e6cd:	00 
  70e6ce:	0f 11 84 24 0c 01 00 	movups %xmm0,0x10c(%rsp)
  70e6d5:	00 
  70e6d6:	41 0f b6 c5          	movzbl %r13b,%eax
  70e6da:	48 8d 0d 57 81 95 ff 	lea    -0x6a7ea9(%rip),%rcx        # 66838 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x18>
  70e6e1:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  70e6e5:	48 01 c8             	add    %rcx,%rax
  70e6e8:	ff e0                	jmp    *%rax
  70e6ea:	8b 44 24 08          	mov    0x8(%rsp),%eax
  70e6ee:	25 00 00 ff 00       	and    $0xff0000,%eax
  70e6f3:	31 c9                	xor    %ecx,%ecx
  70e6f5:	3d 00 00 02 00       	cmp    $0x20000,%eax
  70e6fa:	0f 94 c1             	sete   %cl
  70e6fd:	48 8d 05 cc 7e 95 ff 	lea    -0x6a8134(%rip),%rax        # 665d0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.21.llvm.6319143315422321905+0x30>
  70e704:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
  70e709:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e70e:	48 8d b4 24 00 01 00 	lea    0x100(%rsp),%rsi
  70e715:	00 
  70e716:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  70e71b:	ff 15 2f 3c 3f 00    	call   *0x3f3c2f(%rip)        # b02350 <_DYNAMIC+0x508>
  70e721:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  70e726:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70e72a:	0f 85 c5 06 00 00    	jne    70edf5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x975>
  70e730:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70e735:	0f 10 4c 24 3c       	movups 0x3c(%rsp),%xmm1
  70e73a:	0f 11 8c 24 ac 00 00 	movups %xmm1,0xac(%rsp)
  70e741:	00 
  70e742:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  70e749:	00 
  70e74a:	e9 e2 06 00 00       	jmp    70ee31 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x9b1>
  70e74f:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70e756:	00 
  70e757:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70e75e:	00 
  70e75f:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70e766:	00 
  70e767:	74 66                	je     70e7cf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x34f>
  70e769:	84 c0                	test   %al,%al
  70e76b:	74 0a                	je     70e777 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x2f7>
  70e76d:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70e774:	ff 
  70e775:	74 58                	je     70e7cf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x34f>
  70e777:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70e77e:	b9 01 00 00 00       	mov    $0x1,%ecx
  70e783:	eb 4c                	jmp    70e7d1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x351>
  70e785:	48 c7 44 24 68 11 00 	movq   $0x11,0x68(%rsp)
  70e78c:	00 00 
  70e78e:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70e795:	00 
  70e796:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70e79d:	00 
  70e79e:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70e7a5:	00 
  70e7a6:	0f 84 26 04 00 00    	je     70ebd2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x752>
  70e7ac:	84 c0                	test   %al,%al
  70e7ae:	74 0e                	je     70e7be <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x33e>
  70e7b0:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70e7b7:	ff 
  70e7b8:	0f 84 14 04 00 00    	je     70ebd2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x752>
  70e7be:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70e7c5:	b9 01 00 00 00       	mov    $0x1,%ecx
  70e7ca:	e9 05 04 00 00       	jmp    70ebd4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x754>
  70e7cf:	31 c9                	xor    %ecx,%ecx
  70e7d1:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70e7d5:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70e7d9:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70e7dd:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  70e7e4:	00 
  70e7e5:	88 43 30             	mov    %al,0x30(%rbx)
  70e7e8:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70e7ef:	e9 21 fd ff ff       	jmp    70e515 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e7f4:	45 0f b7 f8          	movzwl %r8w,%r15d
  70e7f8:	8d 47 01             	lea    0x1(%rdi),%eax
  70e7fb:	89 44 24 18          	mov    %eax,0x18(%rsp)
  70e7ff:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  70e804:	89 cf                	mov    %ecx,%edi
  70e806:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  70e80a:	45 89 c5             	mov    %r8d,%r13d
  70e80d:	e8 ce da ff ff       	call   70c2e0 <<gpui::property::PropertyId>::info>
  70e812:	45 89 e8             	mov    %r13d,%r8d
  70e815:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70e81a:	44 8b 6c 24 08       	mov    0x8(%rsp),%r13d
  70e81f:	0f b6 40 14          	movzbl 0x14(%rax),%eax
  70e823:	31 c9                	xor    %ecx,%ecx
  70e825:	3c 04                	cmp    $0x4,%al
  70e827:	0f 94 c1             	sete   %cl
  70e82a:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  70e82d:	ff c1                	inc    %ecx
  70e82f:	3c 02                	cmp    $0x2,%al
  70e831:	ba 04 00 00 00       	mov    $0x4,%edx
  70e836:	0f 45 d1             	cmovne %ecx,%edx
  70e839:	0f b6 44 24 18       	movzbl 0x18(%rsp),%eax
  70e83e:	f6 f2                	div    %dl
  70e840:	0f b6 c4             	movzbl %ah,%eax
  70e843:	41 c1 e7 08          	shl    $0x8,%r15d
  70e847:	41 09 c7             	or     %eax,%r15d
  70e84a:	66 45 39 e5          	cmp    %r12w,%r13w
  70e84e:	0f 84 0d fd ff ff    	je     70e561 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xe1>
  70e854:	31 c0                	xor    %eax,%eax
  70e856:	45 89 ec             	mov    %r13d,%r12d
  70e859:	49 8b 96 60 06 00 00 	mov    0x660(%r14),%rdx
  70e860:	48 ff c2             	inc    %rdx
  70e863:	0f 84 a8 06 00 00    	je     70ef11 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa91>
  70e869:	41 0f b7 cf          	movzwl %r15w,%ecx
  70e86d:	66 44 89 65 10       	mov    %r12w,0x10(%rbp)
  70e872:	88 4d 16             	mov    %cl,0x16(%rbp)
  70e875:	88 6d 12             	mov    %ch,0x12(%rbp)
  70e878:	c6 45 13 ff          	movb   $0xff,0x13(%rbp)
  70e87c:	84 c0                	test   %al,%al
  70e87e:	0f 85 11 03 00 00    	jne    70eb95 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x715>
  70e884:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70e88b:	48 85 c0             	test   %rax,%rax
  70e88e:	0f 84 da 06 00 00    	je     70ef6e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaee>
  70e894:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70e89b:	00 
  70e89c:	0f 84 cc 06 00 00    	je     70ef6e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaee>
  70e8a2:	4d 8b be a0 02 00 00 	mov    0x2a0(%r14),%r15
  70e8a9:	49 83 ff 1c          	cmp    $0x1c,%r15
  70e8ad:	0f 82 bb 06 00 00    	jb     70ef6e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaee>
  70e8b3:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  70e8b8:	41 0f b7 fc          	movzwl %r12w,%edi
  70e8bc:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  70e8c1:	ff 15 91 3a 3f 00    	call   *0x3f3a91(%rip)        # b02358 <_DYNAMIC+0x510>
  70e8c7:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70e8cc:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70e8d1:	49 8d 7f f7          	lea    -0x9(%r15),%rdi
  70e8d5:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70e8dc:	48 39 f7             	cmp    %rsi,%rdi
  70e8df:	0f 83 99 06 00 00    	jae    70ef7e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70e8e5:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70e8ec:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70e8f0:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70e8f4:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70e8f9:	48 85 ed             	test   %rbp,%rbp
  70e8fc:	74 36                	je     70e934 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x4b4>
  70e8fe:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70e903:	49 8b 45 00          	mov    0x0(%r13),%rax
  70e907:	48 85 c0             	test   %rax,%rax
  70e90a:	74 12                	je     70e91e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x49e>
  70e90c:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70e910:	48 83 c1 08          	add    $0x8,%rcx
  70e914:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70e919:	48 89 ef             	mov    %rbp,%rdi
  70e91c:	ff d0                	call   *%rax
  70e91e:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70e922:	48 85 f6             	test   %rsi,%rsi
  70e925:	74 0d                	je     70e934 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x4b4>
  70e927:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70e92b:	48 89 ef             	mov    %rbp,%rdi
  70e92e:	ff 15 5c 37 3f 00    	call   *0x3f375c(%rip)        # b02090 <_DYNAMIC+0x248>
  70e934:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70e939:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70e93e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70e943:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70e948:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70e94d:	8d b8 00 00 01 00    	lea    0x10000(%rax),%edi
  70e953:	ff 15 ff 39 3f 00    	call   *0x3f39ff(%rip)        # b02358 <_DYNAMIC+0x510>
  70e959:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70e95e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70e963:	49 8d 7f f9          	lea    -0x7(%r15),%rdi
  70e967:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70e96e:	48 39 f7             	cmp    %rsi,%rdi
  70e971:	0f 83 07 06 00 00    	jae    70ef7e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70e977:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70e97e:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70e982:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70e986:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70e98b:	48 85 ed             	test   %rbp,%rbp
  70e98e:	74 36                	je     70e9c6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x546>
  70e990:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70e995:	49 8b 45 00          	mov    0x0(%r13),%rax
  70e999:	48 85 c0             	test   %rax,%rax
  70e99c:	74 12                	je     70e9b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x530>
  70e99e:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70e9a2:	48 83 c1 08          	add    $0x8,%rcx
  70e9a6:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70e9ab:	48 89 ef             	mov    %rbp,%rdi
  70e9ae:	ff d0                	call   *%rax
  70e9b0:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70e9b4:	48 85 f6             	test   %rsi,%rsi
  70e9b7:	74 0d                	je     70e9c6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x546>
  70e9b9:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70e9bd:	48 89 ef             	mov    %rbp,%rdi
  70e9c0:	ff 15 ca 36 3f 00    	call   *0x3f36ca(%rip)        # b02090 <_DYNAMIC+0x248>
  70e9c6:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70e9cb:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70e9d0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70e9d5:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70e9da:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70e9df:	8d b8 00 00 02 00    	lea    0x20000(%rax),%edi
  70e9e5:	ff 15 6d 39 3f 00    	call   *0x3f396d(%rip)        # b02358 <_DYNAMIC+0x510>
  70e9eb:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70e9f0:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70e9f5:	49 8d 7f fa          	lea    -0x6(%r15),%rdi
  70e9f9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70ea00:	48 39 f7             	cmp    %rsi,%rdi
  70ea03:	0f 83 75 05 00 00    	jae    70ef7e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70ea09:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70ea10:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70ea14:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70ea18:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70ea1d:	48 85 ed             	test   %rbp,%rbp
  70ea20:	74 36                	je     70ea58 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x5d8>
  70ea22:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70ea27:	49 8b 45 00          	mov    0x0(%r13),%rax
  70ea2b:	48 85 c0             	test   %rax,%rax
  70ea2e:	74 12                	je     70ea42 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x5c2>
  70ea30:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70ea34:	48 83 c1 08          	add    $0x8,%rcx
  70ea38:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70ea3d:	48 89 ef             	mov    %rbp,%rdi
  70ea40:	ff d0                	call   *%rax
  70ea42:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70ea46:	48 85 f6             	test   %rsi,%rsi
  70ea49:	74 0d                	je     70ea58 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x5d8>
  70ea4b:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70ea4f:	48 89 ef             	mov    %rbp,%rdi
  70ea52:	ff 15 38 36 3f 00    	call   *0x3f3638(%rip)        # b02090 <_DYNAMIC+0x248>
  70ea58:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70ea5d:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70ea62:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70ea67:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70ea6c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70ea71:	8d b8 00 00 03 00    	lea    0x30000(%rax),%edi
  70ea77:	ff 15 db 38 3f 00    	call   *0x3f38db(%rip)        # b02358 <_DYNAMIC+0x510>
  70ea7d:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70ea82:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70ea87:	49 8d 7f fb          	lea    -0x5(%r15),%rdi
  70ea8b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70ea92:	48 39 f7             	cmp    %rsi,%rdi
  70ea95:	0f 83 e3 04 00 00    	jae    70ef7e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70ea9b:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70eaa2:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70eaa6:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70eaaa:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70eaaf:	48 85 ed             	test   %rbp,%rbp
  70eab2:	74 36                	je     70eaea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x66a>
  70eab4:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70eab9:	49 8b 45 00          	mov    0x0(%r13),%rax
  70eabd:	48 85 c0             	test   %rax,%rax
  70eac0:	74 12                	je     70ead4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x654>
  70eac2:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70eac6:	48 83 c1 08          	add    $0x8,%rcx
  70eaca:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70eacf:	48 89 ef             	mov    %rbp,%rdi
  70ead2:	ff d0                	call   *%rax
  70ead4:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70ead8:	48 85 f6             	test   %rsi,%rsi
  70eadb:	74 0d                	je     70eaea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x66a>
  70eadd:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70eae1:	48 89 ef             	mov    %rbp,%rdi
  70eae4:	ff 15 a6 35 3f 00    	call   *0x3f35a6(%rip)        # b02090 <_DYNAMIC+0x248>
  70eaea:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70eaef:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70eaf4:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70eaf9:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70eafe:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  70eb03:	81 cf 00 00 04 00    	or     $0x40000,%edi
  70eb09:	ff 15 49 38 3f 00    	call   *0x3f3849(%rip)        # b02358 <_DYNAMIC+0x510>
  70eb0f:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70eb14:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70eb19:	49 83 c7 fc          	add    $0xfffffffffffffffc,%r15
  70eb1d:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70eb24:	49 39 f7             	cmp    %rsi,%r15
  70eb27:	0f 83 4e 04 00 00    	jae    70ef7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafb>
  70eb2d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70eb34:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  70eb38:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70eb3c:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70eb41:	48 85 ed             	test   %rbp,%rbp
  70eb44:	74 36                	je     70eb7c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x6fc>
  70eb46:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70eb4b:	49 8b 45 00          	mov    0x0(%r13),%rax
  70eb4f:	48 85 c0             	test   %rax,%rax
  70eb52:	74 12                	je     70eb66 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x6e6>
  70eb54:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70eb58:	48 83 c1 08          	add    $0x8,%rcx
  70eb5c:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70eb61:	48 89 ef             	mov    %rbp,%rdi
  70eb64:	ff d0                	call   *%rax
  70eb66:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70eb6a:	48 85 f6             	test   %rsi,%rsi
  70eb6d:	74 0d                	je     70eb7c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x6fc>
  70eb6f:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70eb73:	48 89 ef             	mov    %rbp,%rdi
  70eb76:	ff 15 14 35 3f 00    	call   *0x3f3514(%rip)        # b02090 <_DYNAMIC+0x248>
  70eb7c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70eb81:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70eb86:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70eb8b:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70eb90:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  70eb95:	49 89 96 60 06 00 00 	mov    %rdx,0x660(%r14)
  70eb9c:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  70eba3:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70ebaa:	00 00 00 00 
  70ebae:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  70ebb5:	01 
  70ebb6:	48 89 df             	mov    %rbx,%rdi
  70ebb9:	4c 89 f6             	mov    %r14,%rsi
  70ebbc:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70ebc3:	5b                   	pop    %rbx
  70ebc4:	41 5c                	pop    %r12
  70ebc6:	41 5d                	pop    %r13
  70ebc8:	41 5e                	pop    %r14
  70ebca:	41 5f                	pop    %r15
  70ebcc:	5d                   	pop    %rbp
  70ebcd:	e9 be fa 00 00       	jmp    71e690 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70ebd2:	31 c9                	xor    %ecx,%ecx
  70ebd4:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70ebdb:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70ebdf:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70ebe3:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70ebe7:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70ebeb:	88 43 30             	mov    %al,0x30(%rbx)
  70ebee:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70ebf5:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  70ebfa:	e8 e1 5b ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ebff:	e9 11 f9 ff ff       	jmp    70e515 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70ec04:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  70ec0b:	00 
  70ec0c:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  70ec13:	00 
  70ec14:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  70ec1b:	00 
  70ec1c:	0f 10 8c 24 e0 00 00 	movups 0xe0(%rsp),%xmm1
  70ec23:	00 
  70ec24:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70ec2b:	00 
  70ec2c:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70ec31:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  70ec36:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  70ec3b:	48 83 f8 11          	cmp    $0x11,%rax
  70ec3f:	0f 84 49 fb ff ff    	je     70e78e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x30e>
  70ec45:	eb 2d                	jmp    70ec74 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7f4>
  70ec47:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70ec4c:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  70ec53:	00 
  70ec54:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70ec59:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  70ec5e:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70ec65:	00 
  70ec66:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70ec6b:	48 c7 44 24 68 1a 00 	movq   $0x1a,0x68(%rsp)
  70ec72:	00 00 
  70ec74:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  70ec7b:	00 
  70ec7c:	48 89 43 30          	mov    %rax,0x30(%rbx)
  70ec80:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  70ec85:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  70ec8a:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  70ec8f:	0f 10 8c 24 88 00 00 	movups 0x88(%rsp),%xmm1
  70ec96:	00 
  70ec97:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  70ec9b:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  70ec9f:	48 89 03             	mov    %rax,(%rbx)
  70eca2:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70eca6:	e9 6a f8 ff ff       	jmp    70e515 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70ecab:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70ecb2:	49 39 f4             	cmp    %rsi,%r12
  70ecb5:	0f 83 eb 02 00 00    	jae    70efa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xb26>
  70ecbb:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70ecc2:	4b 8d 0c a4          	lea    (%r12,%r12,4),%rcx
  70ecc6:	44 8b 7c c8 18       	mov    0x18(%rax,%rcx,8),%r15d
  70eccb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  70ecd0:	49 39 c7             	cmp    %rax,%r15
  70ecd3:	0f 84 2c f8 ff ff    	je     70e505 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x85>
  70ecd9:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  70ece0:	00 00 
  70ece2:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ece7:	e8 f4 5a ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ecec:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70ecf3:	4c 39 fe             	cmp    %r15,%rsi
  70ecf6:	0f 86 ba 02 00 00    	jbe    70efb6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xb36>
  70ecfc:	49 8d be b0 05 00 00 	lea    0x5b0(%r14),%rdi
  70ed03:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70ed0a:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  70ed0e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
  70ed12:	ff 15 48 36 3f 00    	call   *0x3f3648(%rip)        # b02360 <_DYNAMIC+0x518>
  70ed18:	49 89 c7             	mov    %rax,%r15
  70ed1b:	49 89 d4             	mov    %rdx,%r12
  70ed1e:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ed23:	4c 89 f6             	mov    %r14,%rsi
  70ed26:	48 89 c2             	mov    %rax,%rdx
  70ed29:	4c 89 e1             	mov    %r12,%rcx
  70ed2c:	e8 5f f5 ff ff       	call   70e290 <<gpui::runtime::Runtime<unit_action_cost::Model>>::inspector_app_index>
  70ed31:	83 7c 24 28 fe       	cmpl   $0xfffffffe,0x28(%rsp)
  70ed36:	75 5f                	jne    70ed97 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x917>
  70ed38:	48 89 df             	mov    %rbx,%rdi
  70ed3b:	4c 89 f6             	mov    %r14,%rsi
  70ed3e:	4c 89 fa             	mov    %r15,%rdx
  70ed41:	4c 89 e1             	mov    %r12,%rcx
  70ed44:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70ed4b:	5b                   	pop    %rbx
  70ed4c:	41 5c                	pop    %r12
  70ed4e:	41 5d                	pop    %r13
  70ed50:	41 5e                	pop    %r14
  70ed52:	41 5f                	pop    %r15
  70ed54:	5d                   	pop    %rbp
  70ed55:	e9 e6 02 00 00       	jmp    70f040 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select>
  70ed5a:	8b 4c 24 5c          	mov    0x5c(%rsp),%ecx
  70ed5e:	89 4b 34             	mov    %ecx,0x34(%rbx)
  70ed61:	0f 10 44 24 4c       	movups 0x4c(%rsp),%xmm0
  70ed66:	0f 11 43 24          	movups %xmm0,0x24(%rbx)
  70ed6a:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  70ed71:	00 
  70ed72:	0f 11 43 14          	movups %xmm0,0x14(%rbx)
  70ed76:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  70ed7d:	00 
  70ed7e:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  70ed82:	48 89 03             	mov    %rax,(%rbx)
  70ed85:	e9 8b f7 ff ff       	jmp    70e515 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70ed8a:	48 8d 3d 5f 54 3c 00 	lea    0x3c545f(%rip),%rdi        # ad41f0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x948>
  70ed91:	ff 15 39 33 3f 00    	call   *0x3f3339(%rip)        # b020d0 <_DYNAMIC+0x288>
  70ed97:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ed9c:	e8 3f 5a ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70eda1:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70eda8:	00 
  70eda9:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70edb0:	00 
  70edb1:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70edb8:	00 
  70edb9:	74 1c                	je     70edd7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x957>
  70edbb:	84 c0                	test   %al,%al
  70edbd:	74 0a                	je     70edc9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x949>
  70edbf:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70edc6:	ff 
  70edc7:	74 0e                	je     70edd7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x957>
  70edc9:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70edd0:	b9 01 00 00 00       	mov    $0x1,%ecx
  70edd5:	eb 02                	jmp    70edd9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x959>
  70edd7:	31 c9                	xor    %ecx,%ecx
  70edd9:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70ede0:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70ede4:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70ede8:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70edec:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70edf0:	e9 f0 f9 ff ff       	jmp    70e7e5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x365>
  70edf5:	83 f8 23             	cmp    $0x23,%eax
  70edf8:	0f 85 eb 00 00 00    	jne    70eee9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa69>
  70edfe:	8b 44 24 30          	mov    0x30(%rsp),%eax
  70ee02:	83 f8 0d             	cmp    $0xd,%eax
  70ee05:	0f 84 12 01 00 00    	je     70ef1d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa9d>
  70ee0b:	83 f8 0e             	cmp    $0xe,%eax
  70ee0e:	0f 85 d5 00 00 00    	jne    70eee9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa69>
  70ee14:	ba 07 00 00 00       	mov    $0x7,%edx
  70ee19:	e9 04 01 00 00       	jmp    70ef22 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaa2>
  70ee1e:	c6 84 24 a0 00 00 00 	movb   $0x0,0xa0(%rsp)
  70ee25:	00 
  70ee26:	c7 84 24 a4 00 00 00 	movl   $0x0,0xa4(%rsp)
  70ee2d:	00 00 00 00 
  70ee31:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  70ee38:	00 
  70ee39:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  70ee3d:	ff 15 25 35 3f 00    	call   *0x3f3525(%rip)        # b02368 <_DYNAMIC+0x520>
  70ee43:	66 85 c0             	test   %ax,%ax
  70ee46:	74 2a                	je     70ee72 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x9f2>
  70ee48:	48 c1 e8 10          	shr    $0x10,%rax
  70ee4c:	48 89 df             	mov    %rbx,%rdi
  70ee4f:	4c 89 f6             	mov    %r14,%rsi
  70ee52:	89 c2                	mov    %eax,%edx
  70ee54:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70ee5b:	5b                   	pop    %rbx
  70ee5c:	41 5c                	pop    %r12
  70ee5e:	41 5d                	pop    %r13
  70ee60:	41 5e                	pop    %r14
  70ee62:	41 5f                	pop    %r15
  70ee64:	5d                   	pop    %rbp
  70ee65:	e9 f6 f4 ff ff       	jmp    70e360 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor>
  70ee6a:	c6 84 24 a0 00 00 00 	movb   $0xff,0xa0(%rsp)
  70ee71:	ff 
  70ee72:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  70ee79:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  70ee7d:	0f 84 8e 00 00 00    	je     70ef11 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa91>
  70ee83:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  70ee8a:	00 00 
  70ee8c:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ee91:	e8 4a 59 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ee96:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70ee9d:	48 85 c0             	test   %rax,%rax
  70eea0:	0f 84 af 00 00 00    	je     70ef55 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xad5>
  70eea6:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70eead:	48 85 c0             	test   %rax,%rax
  70eeb0:	0f 84 9f 00 00 00    	je     70ef55 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xad5>
  70eeb6:	49 ff c7             	inc    %r15
  70eeb9:	c6 40 13 ff          	movb   $0xff,0x13(%rax)
  70eebd:	48 8d 84 24 a0 00 00 	lea    0xa0(%rsp),%rax
  70eec4:	00 
  70eec5:	48 89 04 24          	mov    %rax,(%rsp)
  70eec9:	48 89 df             	mov    %rbx,%rdi
  70eecc:	4c 89 f6             	mov    %r14,%rsi
  70eecf:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  70eed4:	4c 89 e1             	mov    %r12,%rcx
  70eed7:	4d 89 f8             	mov    %r15,%r8
  70eeda:	44 8b 4c 24 08       	mov    0x8(%rsp),%r9d
  70eedf:	e8 1c fe 00 00       	call   71ed00 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at>
  70eee4:	e9 2c f6 ff ff       	jmp    70e515 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70eee9:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70eeee:	48 89 43 30          	mov    %rax,0x30(%rbx)
  70eef2:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70eef7:	0f 10 4c 24 38       	movups 0x38(%rsp),%xmm1
  70eefc:	0f 10 54 24 48       	movups 0x48(%rsp),%xmm2
  70ef01:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  70ef05:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  70ef09:	0f 11 03             	movups %xmm0,(%rbx)
  70ef0c:	e9 04 f6 ff ff       	jmp    70e515 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70ef11:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  70ef18:	e9 f8 f5 ff ff       	jmp    70e515 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70ef1d:	ba 06 00 00 00       	mov    $0x6,%edx
  70ef22:	48 89 df             	mov    %rbx,%rdi
  70ef25:	4c 89 f6             	mov    %r14,%rsi
  70ef28:	e8 33 f4 ff ff       	call   70e360 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor>
  70ef2d:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ef32:	e8 a9 58 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ef37:	e9 d9 f5 ff ff       	jmp    70e515 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70ef3c:	48 8d 3d e1 a4 95 ff 	lea    -0x6a5b1f(%rip),%rdi        # 69424 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c04>
  70ef43:	48 8d 15 1e 53 3c 00 	lea    0x3c531e(%rip),%rdx        # ad4268 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x9c0>
  70ef4a:	be 28 00 00 00       	mov    $0x28,%esi
  70ef4f:	ff 15 73 31 3f 00    	call   *0x3f3173(%rip)        # b020c8 <_DYNAMIC+0x280>
  70ef55:	48 8d 3d 09 a5 95 ff 	lea    -0x6a5af7(%rip),%rdi        # 69465 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c45>
  70ef5c:	48 8d 15 15 52 3c 00 	lea    0x3c5215(%rip),%rdx        # ad4178 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x8d0>
  70ef63:	be 11 00 00 00       	mov    $0x11,%esi
  70ef68:	ff 15 42 32 3f 00    	call   *0x3f3242(%rip)        # b021b0 <_DYNAMIC+0x368>
  70ef6e:	48 8d 3d 93 52 3c 00 	lea    0x3c5293(%rip),%rdi        # ad4208 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x960>
  70ef75:	ff 15 55 31 3f 00    	call   *0x3f3155(%rip)        # b020d0 <_DYNAMIC+0x288>
  70ef7b:	4c 89 ff             	mov    %r15,%rdi
  70ef7e:	48 8d 15 9b 52 3c 00 	lea    0x3c529b(%rip),%rdx        # ad4220 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x978>
  70ef85:	ff 15 35 32 3f 00    	call   *0x3f3235(%rip)        # b021c0 <_DYNAMIC+0x378>
  70ef8b:	0f 0b                	ud2
  70ef8d:	48 8d 3d 90 a4 95 ff 	lea    -0x6a5b70(%rip),%rdi        # 69424 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c04>
  70ef94:	48 8d 15 e5 52 3c 00 	lea    0x3c52e5(%rip),%rdx        # ad4280 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x9d8>
  70ef9b:	be 28 00 00 00       	mov    $0x28,%esi
  70efa0:	ff 15 22 31 3f 00    	call   *0x3f3122(%rip)        # b020c8 <_DYNAMIC+0x280>
  70efa6:	48 8d 15 8b 52 3c 00 	lea    0x3c528b(%rip),%rdx        # ad4238 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x990>
  70efad:	4c 89 e7             	mov    %r12,%rdi
  70efb0:	ff 15 0a 32 3f 00    	call   *0x3f320a(%rip)        # b021c0 <_DYNAMIC+0x378>
  70efb6:	48 8d 15 93 52 3c 00 	lea    0x3c5293(%rip),%rdx        # ad4250 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x9a8>
  70efbd:	4c 89 ff             	mov    %r15,%rdi
  70efc0:	ff 15 fa 31 3f 00    	call   *0x3f31fa(%rip)        # b021c0 <_DYNAMIC+0x378>
  70efc6:	48 89 c3             	mov    %rax,%rbx
  70efc9:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70efce:	e8 0d 58 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70efd3:	48 89 df             	mov    %rbx,%rdi
  70efd6:	e8 95 34 3c 00       	call   ad2470 <_Unwind_Resume@plt>
  70efdb:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  70efe0:	48 89 c3             	mov    %rax,%rbx
  70efe3:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70efe7:	48 85 f6             	test   %rsi,%rsi
  70efea:	74 0d                	je     70eff9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xb79>
  70efec:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70eff0:	48 89 ef             	mov    %rbp,%rdi
  70eff3:	ff 15 97 30 3f 00    	call   *0x3f3097(%rip)        # b02090 <_DYNAMIC+0x248>
  70eff9:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70effe:	49 89 06             	mov    %rax,(%r14)
  70f001:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70f006:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70f00b:	48 89 df             	mov    %rbx,%rdi
  70f00e:	e8 5d 34 3c 00       	call   ad2470 <_Unwind_Resume@plt>
  70f013:	48 89 c3             	mov    %rax,%rbx
  70f016:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70f01b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  70f020:	e8 7b 28 ff ff       	call   7018a0 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  70f025:	48 89 df             	mov    %rbx,%rdi
  70f028:	e8 43 34 3c 00       	call   ad2470 <_Unwind_Resume@plt>
  70f02d:	ff 15 ad 30 3f 00    	call   *0x3f30ad(%rip)        # b020e0 <_DYNAMIC+0x298>
