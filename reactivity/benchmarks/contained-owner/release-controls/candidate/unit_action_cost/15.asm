
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070c4f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer>:
  70c4f0:	55                   	push   %rbp
  70c4f1:	41 57                	push   %r15
  70c4f3:	41 56                	push   %r14
  70c4f5:	41 55                	push   %r13
  70c4f7:	41 54                	push   %r12
  70c4f9:	53                   	push   %rbx
  70c4fa:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  70c501:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  70c508:	75 0c                	jne    70c516 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x26>
  70c50a:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70c511:	e9 37 02 00 00       	jmp    70c74d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c516:	80 be 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rsi)
  70c51d:	0f 85 23 02 00 00    	jne    70c746 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c523:	80 be 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rsi)
  70c52a:	0f 85 16 02 00 00    	jne    70c746 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c530:	80 be 20 07 00 00 00 	cmpb   $0x0,0x720(%rsi)
  70c537:	0f 84 09 02 00 00    	je     70c746 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c53d:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  70c544:	ff 
  70c545:	0f 85 fb 01 00 00    	jne    70c746 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c54b:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  70c552:	48 3b 86 68 06 00 00 	cmp    0x668(%rsi),%rax
  70c559:	0f 85 e7 01 00 00    	jne    70c746 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c55f:	48 8b 86 78 06 00 00 	mov    0x678(%rsi),%rax
  70c566:	48 3b 86 70 06 00 00 	cmp    0x670(%rsi),%rax
  70c56d:	0f 85 d3 01 00 00    	jne    70c746 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c573:	f3 0f 10 96 14 07 00 	movss  0x714(%rsi),%xmm2
  70c57a:	00 
  70c57b:	0f 2e 96 18 07 00 00 	ucomiss 0x718(%rsi),%xmm2
  70c582:	0f 85 be 01 00 00    	jne    70c746 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c588:	0f 8a b8 01 00 00    	jp     70c746 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c58e:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70c594:	f3 0f 11 0c 24       	movss  %xmm1,(%rsp)
  70c599:	48 89 fd             	mov    %rdi,%rbp
  70c59c:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c5a1:	48 89 f3             	mov    %rsi,%rbx
  70c5a4:	49 89 d7             	mov    %rdx,%r15
  70c5a7:	49 89 ce             	mov    %rcx,%r14
  70c5aa:	e8 61 e2 ff ff       	call   70a810 <<gpui::runtime::Runtime<unit_action_cost::Model>>::input_index>
  70c5af:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c5b4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  70c5b9:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c5bd:	0f 85 9c 01 00 00    	jne    70c75f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x26f>
  70c5c3:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70c5ca:	49 39 f4             	cmp    %rsi,%r12
  70c5cd:	0f 83 8b 04 00 00    	jae    70ca5e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x56e>
  70c5d3:	48 89 e8             	mov    %rbp,%rax
  70c5d6:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70c5dd:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  70c5e1:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
  70c5e5:	48 8b 8b 78 05 00 00 	mov    0x578(%rbx),%rcx
  70c5ec:	48 8b 93 80 05 00 00 	mov    0x580(%rbx),%rdx
  70c5f3:	48 c1 e2 04          	shl    $0x4,%rdx
  70c5f7:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  70c5fb:	31 d2                	xor    %edx,%edx
  70c5fd:	49 89 c8             	mov    %rcx,%r8
  70c600:	48 39 d7             	cmp    %rdx,%rdi
  70c603:	0f 84 7b 01 00 00    	je     70c784 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x294>
  70c609:	48 83 c2 50          	add    $0x50,%rdx
  70c60d:	49 39 70 20          	cmp    %rsi,0x20(%r8)
  70c611:	4d 8d 40 50          	lea    0x50(%r8),%r8
  70c615:	75 e9                	jne    70c600 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x110>
  70c617:	f3 0f 10 44 11 e0    	movss  -0x20(%rcx,%rdx,1),%xmm0
  70c61d:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70c620:	0f 8a 5e 01 00 00    	jp     70c784 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x294>
  70c626:	f3 0f 10 4c 11 e4    	movss  -0x1c(%rcx,%rdx,1),%xmm1
  70c62c:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  70c633:	00 00 
  70c635:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70c638:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  70c63b:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  70c642:	00 
  70c643:	0f 5a 44 11 e8       	cvtps2pd -0x18(%rcx,%rdx,1),%xmm0
  70c648:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70c64d:	0f 5a 44 11 f0       	cvtps2pd -0x10(%rcx,%rdx,1),%xmm0
  70c652:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  70c659:	00 
  70c65a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c65f:	e8 7c 81 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c664:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  70c66b:	00 
  70c66c:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  70c671:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70c676:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  70c67b:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  70c682:	00 
  70c683:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  70c688:	c6 44 24 40 00       	movb   $0x0,0x40(%rsp)
  70c68d:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  70c694:	00 
  70c695:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  70c69a:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
  70c6a0:	f3 0f 10 0c 24       	movss  (%rsp),%xmm1
  70c6a5:	ff 15 5d 5c 3f 00    	call   *0x3f5c5d(%rip)        # b02308 <_DYNAMIC+0x4c0>
  70c6ab:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  70c6b2:	00 00 
  70c6b4:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  70c6bb:	01 
  70c6bc:	0f 85 34 01 00 00    	jne    70c7f6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x306>
  70c6c2:	f3 0f 10 84 24 94 00 	movss  0x94(%rsp),%xmm0
  70c6c9:	00 00 
  70c6cb:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  70c6d0:	f3 0f 10 84 24 98 00 	movss  0x98(%rsp),%xmm0
  70c6d7:	00 00 
  70c6d9:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70c6df:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c6e4:	e8 f7 80 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c6e9:	48 8b b3 68 05 00 00 	mov    0x568(%rbx),%rsi
  70c6f0:	49 39 f4             	cmp    %rsi,%r12
  70c6f3:	0f 83 75 03 00 00    	jae    70ca6e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x57e>
  70c6f9:	48 8b 8b 60 05 00 00 	mov    0x560(%rbx),%rcx
  70c700:	48 8d b3 c0 02 00 00 	lea    0x2c0(%rbx),%rsi
  70c707:	4c 89 e0             	mov    %r12,%rax
  70c70a:	48 c1 e0 04          	shl    $0x4,%rax
  70c70e:	0f 10 04 01          	movups (%rcx,%rax,1),%xmm0
  70c712:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  70c719:	00 
  70c71a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c71f:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
  70c726:	00 
  70c727:	ff 15 bb 5b 3f 00    	call   *0x3f5bbb(%rip)        # b022e8 <_DYNAMIC+0x4a0>
  70c72d:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  70c732:	74 59                	je     70c78d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x29d>
  70c734:	0f b6 44 24 11       	movzbl 0x11(%rsp),%eax
  70c739:	48 c7 45 00 22 00 00 	movq   $0x22,0x0(%rbp)
  70c740:	00 
  70c741:	88 45 08             	mov    %al,0x8(%rbp)
  70c744:	eb 07                	jmp    70c74d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c746:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70c74d:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  70c754:	5b                   	pop    %rbx
  70c755:	41 5c                	pop    %r12
  70c757:	41 5d                	pop    %r13
  70c759:	41 5e                	pop    %r14
  70c75b:	41 5f                	pop    %r15
  70c75d:	5d                   	pop    %rbp
  70c75e:	c3                   	ret
  70c75f:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  70c764:	48 89 4d 30          	mov    %rcx,0x30(%rbp)
  70c768:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  70c76d:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  70c772:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  70c776:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70c77a:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70c77e:	4c 89 65 08          	mov    %r12,0x8(%rbp)
  70c782:	eb c9                	jmp    70c74d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c784:	48 c7 00 19 00 00 00 	movq   $0x19,(%rax)
  70c78b:	eb c0                	jmp    70c74d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c78d:	f3 0f 10 44 24 34    	movss  0x34(%rsp),%xmm0
  70c793:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  70c79a:	00 00 
  70c79c:	f3 0f 10 44 24 3c    	movss  0x3c(%rsp),%xmm0
  70c7a2:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  70c7a8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c7ad:	48 89 de             	mov    %rbx,%rsi
  70c7b0:	4c 89 e2             	mov    %r12,%rdx
  70c7b3:	e8 c8 eb ff ff       	call   70b380 <<gpui::runtime::Runtime<unit_action_cost::Model>>::interaction_layout>
  70c7b8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c7bd:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c7c1:	75 40                	jne    70c803 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x313>
  70c7c3:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
  70c7c9:	f3 0f 5c 4c 24 70    	subss  0x70(%rsp),%xmm1
  70c7cf:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  70c7d4:	f3 0f 5c 84 24 80 00 	subss  0x80(%rsp),%xmm0
  70c7db:	00 00 
  70c7dd:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  70c7e2:	ff 15 28 5b 3f 00    	call   *0x3f5b28(%rip)        # b02310 <_DYNAMIC+0x4c8>
  70c7e8:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  70c7ef:	00 00 
  70c7f1:	80 fa 02             	cmp    $0x2,%dl
  70c7f4:	75 3a                	jne    70c830 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x340>
  70c7f6:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70c7fd:	00 
  70c7fe:	e9 4a ff ff ff       	jmp    70c74d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c803:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  70c808:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  70c80d:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  70c811:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70c816:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
  70c81a:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  70c81f:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70c823:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70c827:	48 89 4d 08          	mov    %rcx,0x8(%rbp)
  70c82b:	e9 1d ff ff ff       	jmp    70c74d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c830:	41 89 d5             	mov    %edx,%r13d
  70c833:	41 89 c4             	mov    %eax,%r12d
  70c836:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c83b:	e8 a0 7f ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c840:	48 83 bb 60 06 00 00 	cmpq   $0xffffffffffffffff,0x660(%rbx)
  70c847:	ff 
  70c848:	0f 84 03 02 00 00    	je     70ca51 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x561>
  70c84e:	48 c7 44 24 10 1f 00 	movq   $0x1f,0x10(%rsp)
  70c855:	00 00 
  70c857:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c85c:	e8 7f 7f ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c861:	48 89 de             	mov    %rbx,%rsi
  70c864:	48 8b 83 e8 05 00 00 	mov    0x5e8(%rbx),%rax
  70c86b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  70c870:	48 8b 83 f0 05 00 00 	mov    0x5f0(%rbx),%rax
  70c877:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  70c87e:	00 
  70c87f:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  70c886:	48 89 04 24          	mov    %rax,(%rsp)
  70c88a:	48 8b 83 88 06 00 00 	mov    0x688(%rbx),%rax
  70c891:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  70c896:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c89b:	4c 89 fa             	mov    %r15,%rdx
  70c89e:	4c 89 f1             	mov    %r14,%rcx
  70c8a1:	e8 1a dd ff ff       	call   70a5c0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::focus>
  70c8a6:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c8ab:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c8af:	0f 85 fa 00 00 00    	jne    70c9af <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x4bf>
  70c8b5:	41 80 e5 01          	and    $0x1,%r13b
  70c8b9:	44 89 a4 24 c0 00 00 	mov    %r12d,0xc0(%rsp)
  70c8c0:	00 
  70c8c1:	44 88 ac 24 c4 00 00 	mov    %r13b,0xc4(%rsp)
  70c8c8:	00 
  70c8c9:	44 89 a4 24 c8 00 00 	mov    %r12d,0xc8(%rsp)
  70c8d0:	00 
  70c8d1:	44 88 ac 24 cc 00 00 	mov    %r13b,0xcc(%rsp)
  70c8d8:	00 
  70c8d9:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c8de:	4c 8d 84 24 c0 00 00 	lea    0xc0(%rsp),%r8
  70c8e5:	00 
  70c8e6:	48 89 de             	mov    %rbx,%rsi
  70c8e9:	4c 89 fa             	mov    %r15,%rdx
  70c8ec:	4c 89 f1             	mov    %r14,%rcx
  70c8ef:	e8 fc f9 ff ff       	call   70c2f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input>
  70c8f4:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c8f9:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70c8fe:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  70c905:	00 
  70c906:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70c90b:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  70c912:	00 
  70c913:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70c918:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  70c91f:	00 
  70c920:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c924:	0f 85 bf 00 00 00    	jne    70c9e9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x4f9>
  70c92a:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  70c931:	00 
  70c932:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70c939:	00 
  70c93a:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  70c941:	00 
  70c942:	0f 29 94 24 00 01 00 	movaps %xmm2,0x100(%rsp)
  70c949:	00 
  70c94a:	0f 29 8c 24 f0 00 00 	movaps %xmm1,0xf0(%rsp)
  70c951:	00 
  70c952:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  70c959:	00 
  70c95a:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  70c961:	48 85 c0             	test   %rax,%rax
  70c964:	48 89 ef             	mov    %rbp,%rdi
  70c967:	0f 84 a9 00 00 00    	je     70ca16 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x526>
  70c96d:	48 8b 0c 24          	mov    (%rsp),%rcx
  70c971:	48 85 c9             	test   %rcx,%rcx
  70c974:	0f 84 a7 00 00 00    	je     70ca21 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x531>
  70c97a:	48 39 c8             	cmp    %rcx,%rax
  70c97d:	0f 85 9e 00 00 00    	jne    70ca21 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x531>
  70c983:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  70c988:	48 39 83 88 06 00 00 	cmp    %rax,0x688(%rbx)
  70c98f:	0f 85 8c 00 00 00    	jne    70ca21 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x531>
  70c995:	48 89 de             	mov    %rbx,%rsi
  70c998:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  70c99d:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  70c9a4:	00 
  70c9a5:	e8 d6 00 00 00       	call   70ca80 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change>
  70c9aa:	e9 9e fd ff ff       	jmp    70c74d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c9af:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  70c9b4:	0f b6 54 24 40       	movzbl 0x40(%rsp),%edx
  70c9b9:	8b 74 24 44          	mov    0x44(%rsp),%esi
  70c9bd:	89 75 34             	mov    %esi,0x34(%rbp)
  70c9c0:	8b 74 24 41          	mov    0x41(%rsp),%esi
  70c9c4:	89 75 31             	mov    %esi,0x31(%rbp)
  70c9c7:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70c9cc:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70c9d1:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70c9d5:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70c9d9:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70c9dd:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  70c9e1:	88 55 30             	mov    %dl,0x30(%rbp)
  70c9e4:	e9 64 fd ff ff       	jmp    70c74d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c9e9:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  70c9f0:	00 
  70c9f1:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70c9f8:	00 
  70c9f9:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  70ca00:	00 
  70ca01:	0f 11 55 28          	movups %xmm2,0x28(%rbp)
  70ca05:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70ca09:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70ca0d:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70ca11:	e9 37 fd ff ff       	jmp    70c74d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70ca16:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
  70ca1b:	0f 84 74 ff ff ff    	je     70c995 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x4a5>
  70ca21:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
  70ca28:	00 
  70ca29:	0f 28 8c 24 f0 00 00 	movaps 0xf0(%rsp),%xmm1
  70ca30:	00 
  70ca31:	0f 28 94 24 00 01 00 	movaps 0x100(%rsp),%xmm2
  70ca38:	00 
  70ca39:	0f 11 57 28          	movups %xmm2,0x28(%rdi)
  70ca3d:	0f 11 4f 18          	movups %xmm1,0x18(%rdi)
  70ca41:	0f 11 47 08          	movups %xmm0,0x8(%rdi)
  70ca45:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  70ca4c:	e9 fc fc ff ff       	jmp    70c74d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70ca51:	48 c7 45 00 1f 00 00 	movq   $0x1f,0x0(%rbp)
  70ca58:	00 
  70ca59:	e9 ef fc ff ff       	jmp    70c74d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70ca5e:	48 8d 15 b3 76 3c 00 	lea    0x3c76b3(%rip),%rdx        # ad4118 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x870>
  70ca65:	4c 89 e7             	mov    %r12,%rdi
  70ca68:	ff 15 52 57 3f 00    	call   *0x3f5752(%rip)        # b021c0 <_DYNAMIC+0x378>
  70ca6e:	48 8d 15 bb 76 3c 00 	lea    0x3c76bb(%rip),%rdx        # ad4130 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x888>
  70ca75:	4c 89 e7             	mov    %r12,%rdi
  70ca78:	ff 15 42 57 3f 00    	call   *0x3f5742(%rip)        # b021c0 <_DYNAMIC+0x378>
