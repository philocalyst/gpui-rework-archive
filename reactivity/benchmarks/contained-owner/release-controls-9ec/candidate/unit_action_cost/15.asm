
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070c4c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer>:
  70c4c0:	55                   	push   %rbp
  70c4c1:	41 57                	push   %r15
  70c4c3:	41 56                	push   %r14
  70c4c5:	41 55                	push   %r13
  70c4c7:	41 54                	push   %r12
  70c4c9:	53                   	push   %rbx
  70c4ca:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  70c4d1:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  70c4d8:	75 0c                	jne    70c4e6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x26>
  70c4da:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70c4e1:	e9 37 02 00 00       	jmp    70c71d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c4e6:	80 be 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rsi)
  70c4ed:	0f 85 23 02 00 00    	jne    70c716 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c4f3:	80 be 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rsi)
  70c4fa:	0f 85 16 02 00 00    	jne    70c716 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c500:	80 be 20 07 00 00 00 	cmpb   $0x0,0x720(%rsi)
  70c507:	0f 84 09 02 00 00    	je     70c716 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c50d:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  70c514:	ff 
  70c515:	0f 85 fb 01 00 00    	jne    70c716 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c51b:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  70c522:	48 3b 86 68 06 00 00 	cmp    0x668(%rsi),%rax
  70c529:	0f 85 e7 01 00 00    	jne    70c716 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c52f:	48 8b 86 78 06 00 00 	mov    0x678(%rsi),%rax
  70c536:	48 3b 86 70 06 00 00 	cmp    0x670(%rsi),%rax
  70c53d:	0f 85 d3 01 00 00    	jne    70c716 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c543:	f3 0f 10 96 14 07 00 	movss  0x714(%rsi),%xmm2
  70c54a:	00 
  70c54b:	0f 2e 96 18 07 00 00 	ucomiss 0x718(%rsi),%xmm2
  70c552:	0f 85 be 01 00 00    	jne    70c716 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c558:	0f 8a b8 01 00 00    	jp     70c716 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c55e:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70c564:	f3 0f 11 0c 24       	movss  %xmm1,(%rsp)
  70c569:	48 89 fd             	mov    %rdi,%rbp
  70c56c:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c571:	48 89 f3             	mov    %rsi,%rbx
  70c574:	49 89 d7             	mov    %rdx,%r15
  70c577:	49 89 ce             	mov    %rcx,%r14
  70c57a:	e8 61 e2 ff ff       	call   70a7e0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::input_index>
  70c57f:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c584:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  70c589:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c58d:	0f 85 9c 01 00 00    	jne    70c72f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x26f>
  70c593:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70c59a:	49 39 f4             	cmp    %rsi,%r12
  70c59d:	0f 83 8b 04 00 00    	jae    70ca2e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x56e>
  70c5a3:	48 89 e8             	mov    %rbp,%rax
  70c5a6:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70c5ad:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  70c5b1:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
  70c5b5:	48 8b 8b 78 05 00 00 	mov    0x578(%rbx),%rcx
  70c5bc:	48 8b 93 80 05 00 00 	mov    0x580(%rbx),%rdx
  70c5c3:	48 c1 e2 04          	shl    $0x4,%rdx
  70c5c7:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  70c5cb:	31 d2                	xor    %edx,%edx
  70c5cd:	49 89 c8             	mov    %rcx,%r8
  70c5d0:	48 39 d7             	cmp    %rdx,%rdi
  70c5d3:	0f 84 7b 01 00 00    	je     70c754 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x294>
  70c5d9:	48 83 c2 50          	add    $0x50,%rdx
  70c5dd:	49 39 70 20          	cmp    %rsi,0x20(%r8)
  70c5e1:	4d 8d 40 50          	lea    0x50(%r8),%r8
  70c5e5:	75 e9                	jne    70c5d0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x110>
  70c5e7:	f3 0f 10 44 11 e0    	movss  -0x20(%rcx,%rdx,1),%xmm0
  70c5ed:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70c5f0:	0f 8a 5e 01 00 00    	jp     70c754 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x294>
  70c5f6:	f3 0f 10 4c 11 e4    	movss  -0x1c(%rcx,%rdx,1),%xmm1
  70c5fc:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  70c603:	00 00 
  70c605:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70c608:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  70c60b:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  70c612:	00 
  70c613:	0f 5a 44 11 e8       	cvtps2pd -0x18(%rcx,%rdx,1),%xmm0
  70c618:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70c61d:	0f 5a 44 11 f0       	cvtps2pd -0x10(%rcx,%rdx,1),%xmm0
  70c622:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  70c629:	00 
  70c62a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c62f:	e8 ac 81 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c634:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  70c63b:	00 
  70c63c:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  70c641:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70c646:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  70c64b:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  70c652:	00 
  70c653:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  70c658:	c6 44 24 40 00       	movb   $0x0,0x40(%rsp)
  70c65d:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  70c664:	00 
  70c665:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  70c66a:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
  70c670:	f3 0f 10 0c 24       	movss  (%rsp),%xmm1
  70c675:	ff 15 5d 5c 3f 00    	call   *0x3f5c5d(%rip)        # b022d8 <_DYNAMIC+0x4c0>
  70c67b:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  70c682:	00 00 
  70c684:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  70c68b:	01 
  70c68c:	0f 85 34 01 00 00    	jne    70c7c6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x306>
  70c692:	f3 0f 10 84 24 94 00 	movss  0x94(%rsp),%xmm0
  70c699:	00 00 
  70c69b:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  70c6a0:	f3 0f 10 84 24 98 00 	movss  0x98(%rsp),%xmm0
  70c6a7:	00 00 
  70c6a9:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70c6af:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c6b4:	e8 27 81 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c6b9:	48 8b b3 68 05 00 00 	mov    0x568(%rbx),%rsi
  70c6c0:	49 39 f4             	cmp    %rsi,%r12
  70c6c3:	0f 83 75 03 00 00    	jae    70ca3e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x57e>
  70c6c9:	48 8b 8b 60 05 00 00 	mov    0x560(%rbx),%rcx
  70c6d0:	48 8d b3 c0 02 00 00 	lea    0x2c0(%rbx),%rsi
  70c6d7:	4c 89 e0             	mov    %r12,%rax
  70c6da:	48 c1 e0 04          	shl    $0x4,%rax
  70c6de:	0f 10 04 01          	movups (%rcx,%rax,1),%xmm0
  70c6e2:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  70c6e9:	00 
  70c6ea:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c6ef:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
  70c6f6:	00 
  70c6f7:	ff 15 bb 5b 3f 00    	call   *0x3f5bbb(%rip)        # b022b8 <_DYNAMIC+0x4a0>
  70c6fd:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  70c702:	74 59                	je     70c75d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x29d>
  70c704:	0f b6 44 24 11       	movzbl 0x11(%rsp),%eax
  70c709:	48 c7 45 00 22 00 00 	movq   $0x22,0x0(%rbp)
  70c710:	00 
  70c711:	88 45 08             	mov    %al,0x8(%rbp)
  70c714:	eb 07                	jmp    70c71d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c716:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70c71d:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  70c724:	5b                   	pop    %rbx
  70c725:	41 5c                	pop    %r12
  70c727:	41 5d                	pop    %r13
  70c729:	41 5e                	pop    %r14
  70c72b:	41 5f                	pop    %r15
  70c72d:	5d                   	pop    %rbp
  70c72e:	c3                   	ret
  70c72f:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  70c734:	48 89 4d 30          	mov    %rcx,0x30(%rbp)
  70c738:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  70c73d:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  70c742:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  70c746:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70c74a:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70c74e:	4c 89 65 08          	mov    %r12,0x8(%rbp)
  70c752:	eb c9                	jmp    70c71d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c754:	48 c7 00 19 00 00 00 	movq   $0x19,(%rax)
  70c75b:	eb c0                	jmp    70c71d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c75d:	f3 0f 10 44 24 34    	movss  0x34(%rsp),%xmm0
  70c763:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  70c76a:	00 00 
  70c76c:	f3 0f 10 44 24 3c    	movss  0x3c(%rsp),%xmm0
  70c772:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  70c778:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c77d:	48 89 de             	mov    %rbx,%rsi
  70c780:	4c 89 e2             	mov    %r12,%rdx
  70c783:	e8 c8 eb ff ff       	call   70b350 <<gpui::runtime::Runtime<unit_action_cost::Model>>::interaction_layout>
  70c788:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c78d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c791:	75 40                	jne    70c7d3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x313>
  70c793:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
  70c799:	f3 0f 5c 4c 24 70    	subss  0x70(%rsp),%xmm1
  70c79f:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  70c7a4:	f3 0f 5c 84 24 80 00 	subss  0x80(%rsp),%xmm0
  70c7ab:	00 00 
  70c7ad:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  70c7b2:	ff 15 28 5b 3f 00    	call   *0x3f5b28(%rip)        # b022e0 <_DYNAMIC+0x4c8>
  70c7b8:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  70c7bf:	00 00 
  70c7c1:	80 fa 02             	cmp    $0x2,%dl
  70c7c4:	75 3a                	jne    70c800 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x340>
  70c7c6:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70c7cd:	00 
  70c7ce:	e9 4a ff ff ff       	jmp    70c71d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c7d3:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  70c7d8:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  70c7dd:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  70c7e1:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70c7e6:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
  70c7ea:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  70c7ef:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70c7f3:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70c7f7:	48 89 4d 08          	mov    %rcx,0x8(%rbp)
  70c7fb:	e9 1d ff ff ff       	jmp    70c71d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c800:	41 89 d5             	mov    %edx,%r13d
  70c803:	41 89 c4             	mov    %eax,%r12d
  70c806:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c80b:	e8 d0 7f ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c810:	48 83 bb 60 06 00 00 	cmpq   $0xffffffffffffffff,0x660(%rbx)
  70c817:	ff 
  70c818:	0f 84 03 02 00 00    	je     70ca21 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x561>
  70c81e:	48 c7 44 24 10 1f 00 	movq   $0x1f,0x10(%rsp)
  70c825:	00 00 
  70c827:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c82c:	e8 af 7f ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c831:	48 89 de             	mov    %rbx,%rsi
  70c834:	48 8b 83 e8 05 00 00 	mov    0x5e8(%rbx),%rax
  70c83b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  70c840:	48 8b 83 f0 05 00 00 	mov    0x5f0(%rbx),%rax
  70c847:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  70c84e:	00 
  70c84f:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  70c856:	48 89 04 24          	mov    %rax,(%rsp)
  70c85a:	48 8b 83 88 06 00 00 	mov    0x688(%rbx),%rax
  70c861:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  70c866:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c86b:	4c 89 fa             	mov    %r15,%rdx
  70c86e:	4c 89 f1             	mov    %r14,%rcx
  70c871:	e8 1a dd ff ff       	call   70a590 <<gpui::runtime::Runtime<unit_action_cost::Model>>::focus>
  70c876:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c87b:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c87f:	0f 85 fa 00 00 00    	jne    70c97f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x4bf>
  70c885:	41 80 e5 01          	and    $0x1,%r13b
  70c889:	44 89 a4 24 c0 00 00 	mov    %r12d,0xc0(%rsp)
  70c890:	00 
  70c891:	44 88 ac 24 c4 00 00 	mov    %r13b,0xc4(%rsp)
  70c898:	00 
  70c899:	44 89 a4 24 c8 00 00 	mov    %r12d,0xc8(%rsp)
  70c8a0:	00 
  70c8a1:	44 88 ac 24 cc 00 00 	mov    %r13b,0xcc(%rsp)
  70c8a8:	00 
  70c8a9:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c8ae:	4c 8d 84 24 c0 00 00 	lea    0xc0(%rsp),%r8
  70c8b5:	00 
  70c8b6:	48 89 de             	mov    %rbx,%rsi
  70c8b9:	4c 89 fa             	mov    %r15,%rdx
  70c8bc:	4c 89 f1             	mov    %r14,%rcx
  70c8bf:	e8 fc f9 ff ff       	call   70c2c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input>
  70c8c4:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c8c9:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70c8ce:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  70c8d5:	00 
  70c8d6:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70c8db:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  70c8e2:	00 
  70c8e3:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70c8e8:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  70c8ef:	00 
  70c8f0:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c8f4:	0f 85 bf 00 00 00    	jne    70c9b9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x4f9>
  70c8fa:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  70c901:	00 
  70c902:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70c909:	00 
  70c90a:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  70c911:	00 
  70c912:	0f 29 94 24 00 01 00 	movaps %xmm2,0x100(%rsp)
  70c919:	00 
  70c91a:	0f 29 8c 24 f0 00 00 	movaps %xmm1,0xf0(%rsp)
  70c921:	00 
  70c922:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  70c929:	00 
  70c92a:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  70c931:	48 85 c0             	test   %rax,%rax
  70c934:	48 89 ef             	mov    %rbp,%rdi
  70c937:	0f 84 a9 00 00 00    	je     70c9e6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x526>
  70c93d:	48 8b 0c 24          	mov    (%rsp),%rcx
  70c941:	48 85 c9             	test   %rcx,%rcx
  70c944:	0f 84 a7 00 00 00    	je     70c9f1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x531>
  70c94a:	48 39 c8             	cmp    %rcx,%rax
  70c94d:	0f 85 9e 00 00 00    	jne    70c9f1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x531>
  70c953:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  70c958:	48 39 83 88 06 00 00 	cmp    %rax,0x688(%rbx)
  70c95f:	0f 85 8c 00 00 00    	jne    70c9f1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x531>
  70c965:	48 89 de             	mov    %rbx,%rsi
  70c968:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  70c96d:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  70c974:	00 
  70c975:	e8 d6 00 00 00       	call   70ca50 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change>
  70c97a:	e9 9e fd ff ff       	jmp    70c71d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c97f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  70c984:	0f b6 54 24 40       	movzbl 0x40(%rsp),%edx
  70c989:	8b 74 24 44          	mov    0x44(%rsp),%esi
  70c98d:	89 75 34             	mov    %esi,0x34(%rbp)
  70c990:	8b 74 24 41          	mov    0x41(%rsp),%esi
  70c994:	89 75 31             	mov    %esi,0x31(%rbp)
  70c997:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70c99c:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70c9a1:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70c9a5:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70c9a9:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70c9ad:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  70c9b1:	88 55 30             	mov    %dl,0x30(%rbp)
  70c9b4:	e9 64 fd ff ff       	jmp    70c71d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c9b9:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  70c9c0:	00 
  70c9c1:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70c9c8:	00 
  70c9c9:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  70c9d0:	00 
  70c9d1:	0f 11 55 28          	movups %xmm2,0x28(%rbp)
  70c9d5:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70c9d9:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70c9dd:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70c9e1:	e9 37 fd ff ff       	jmp    70c71d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c9e6:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
  70c9eb:	0f 84 74 ff ff ff    	je     70c965 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x4a5>
  70c9f1:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
  70c9f8:	00 
  70c9f9:	0f 28 8c 24 f0 00 00 	movaps 0xf0(%rsp),%xmm1
  70ca00:	00 
  70ca01:	0f 28 94 24 00 01 00 	movaps 0x100(%rsp),%xmm2
  70ca08:	00 
  70ca09:	0f 11 57 28          	movups %xmm2,0x28(%rdi)
  70ca0d:	0f 11 4f 18          	movups %xmm1,0x18(%rdi)
  70ca11:	0f 11 47 08          	movups %xmm0,0x8(%rdi)
  70ca15:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  70ca1c:	e9 fc fc ff ff       	jmp    70c71d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70ca21:	48 c7 45 00 1f 00 00 	movq   $0x1f,0x0(%rbp)
  70ca28:	00 
  70ca29:	e9 ef fc ff ff       	jmp    70c71d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70ca2e:	48 8d 15 b3 76 3c 00 	lea    0x3c76b3(%rip),%rdx        # ad40e8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x870>
  70ca35:	4c 89 e7             	mov    %r12,%rdi
  70ca38:	ff 15 52 57 3f 00    	call   *0x3f5752(%rip)        # b02190 <_DYNAMIC+0x378>
  70ca3e:	48 8d 15 bb 76 3c 00 	lea    0x3c76bb(%rip),%rdx        # ad4100 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x888>
  70ca45:	4c 89 e7             	mov    %r12,%rdi
  70ca48:	ff 15 42 57 3f 00    	call   *0x3f5742(%rip)        # b02190 <_DYNAMIC+0x378>
