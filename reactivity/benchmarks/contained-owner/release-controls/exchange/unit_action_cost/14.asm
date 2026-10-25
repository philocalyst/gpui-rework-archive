
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070c3e0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer>:
  70c3e0:	55                   	push   %rbp
  70c3e1:	41 57                	push   %r15
  70c3e3:	41 56                	push   %r14
  70c3e5:	41 55                	push   %r13
  70c3e7:	41 54                	push   %r12
  70c3e9:	53                   	push   %rbx
  70c3ea:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  70c3f1:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  70c3f8:	75 0c                	jne    70c406 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x26>
  70c3fa:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70c401:	e9 37 02 00 00       	jmp    70c63d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c406:	80 be 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rsi)
  70c40d:	0f 85 23 02 00 00    	jne    70c636 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c413:	80 be 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rsi)
  70c41a:	0f 85 16 02 00 00    	jne    70c636 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c420:	80 be 20 07 00 00 00 	cmpb   $0x0,0x720(%rsi)
  70c427:	0f 84 09 02 00 00    	je     70c636 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c42d:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  70c434:	ff 
  70c435:	0f 85 fb 01 00 00    	jne    70c636 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c43b:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  70c442:	48 3b 86 68 06 00 00 	cmp    0x668(%rsi),%rax
  70c449:	0f 85 e7 01 00 00    	jne    70c636 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c44f:	48 8b 86 78 06 00 00 	mov    0x678(%rsi),%rax
  70c456:	48 3b 86 70 06 00 00 	cmp    0x670(%rsi),%rax
  70c45d:	0f 85 d3 01 00 00    	jne    70c636 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c463:	f3 0f 10 96 14 07 00 	movss  0x714(%rsi),%xmm2
  70c46a:	00 
  70c46b:	0f 2e 96 18 07 00 00 	ucomiss 0x718(%rsi),%xmm2
  70c472:	0f 85 be 01 00 00    	jne    70c636 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c478:	0f 8a b8 01 00 00    	jp     70c636 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x256>
  70c47e:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70c484:	f3 0f 11 0c 24       	movss  %xmm1,(%rsp)
  70c489:	48 89 fd             	mov    %rdi,%rbp
  70c48c:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c491:	48 89 f3             	mov    %rsi,%rbx
  70c494:	49 89 d7             	mov    %rdx,%r15
  70c497:	49 89 ce             	mov    %rcx,%r14
  70c49a:	e8 61 e2 ff ff       	call   70a700 <<gpui::runtime::Runtime<unit_action_cost::Model>>::input_index>
  70c49f:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c4a4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  70c4a9:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c4ad:	0f 85 9c 01 00 00    	jne    70c64f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x26f>
  70c4b3:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70c4ba:	49 39 f4             	cmp    %rsi,%r12
  70c4bd:	0f 83 8b 04 00 00    	jae    70c94e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x56e>
  70c4c3:	48 89 e8             	mov    %rbp,%rax
  70c4c6:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70c4cd:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  70c4d1:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
  70c4d5:	48 8b 8b 78 05 00 00 	mov    0x578(%rbx),%rcx
  70c4dc:	48 8b 93 80 05 00 00 	mov    0x580(%rbx),%rdx
  70c4e3:	48 c1 e2 04          	shl    $0x4,%rdx
  70c4e7:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  70c4eb:	31 d2                	xor    %edx,%edx
  70c4ed:	49 89 c8             	mov    %rcx,%r8
  70c4f0:	48 39 d7             	cmp    %rdx,%rdi
  70c4f3:	0f 84 7b 01 00 00    	je     70c674 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x294>
  70c4f9:	48 83 c2 50          	add    $0x50,%rdx
  70c4fd:	49 39 70 20          	cmp    %rsi,0x20(%r8)
  70c501:	4d 8d 40 50          	lea    0x50(%r8),%r8
  70c505:	75 e9                	jne    70c4f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x110>
  70c507:	f3 0f 10 44 11 e0    	movss  -0x20(%rcx,%rdx,1),%xmm0
  70c50d:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70c510:	0f 8a 5e 01 00 00    	jp     70c674 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x294>
  70c516:	f3 0f 10 4c 11 e4    	movss  -0x1c(%rcx,%rdx,1),%xmm1
  70c51c:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  70c523:	00 00 
  70c525:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70c528:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  70c52b:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  70c532:	00 
  70c533:	0f 5a 44 11 e8       	cvtps2pd -0x18(%rcx,%rdx,1),%xmm0
  70c538:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70c53d:	0f 5a 44 11 f0       	cvtps2pd -0x10(%rcx,%rdx,1),%xmm0
  70c542:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  70c549:	00 
  70c54a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c54f:	e8 7c 81 ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c554:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  70c55b:	00 
  70c55c:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  70c561:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70c566:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  70c56b:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  70c572:	00 
  70c573:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  70c578:	c6 44 24 40 00       	movb   $0x0,0x40(%rsp)
  70c57d:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  70c584:	00 
  70c585:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  70c58a:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
  70c590:	f3 0f 10 0c 24       	movss  (%rsp),%xmm1
  70c595:	ff 15 6d 5c 3f 00    	call   *0x3f5c6d(%rip)        # b02208 <_DYNAMIC+0x4c0>
  70c59b:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  70c5a2:	00 00 
  70c5a4:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  70c5ab:	01 
  70c5ac:	0f 85 34 01 00 00    	jne    70c6e6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x306>
  70c5b2:	f3 0f 10 84 24 94 00 	movss  0x94(%rsp),%xmm0
  70c5b9:	00 00 
  70c5bb:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  70c5c0:	f3 0f 10 84 24 98 00 	movss  0x98(%rsp),%xmm0
  70c5c7:	00 00 
  70c5c9:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70c5cf:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c5d4:	e8 f7 80 ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c5d9:	48 8b b3 68 05 00 00 	mov    0x568(%rbx),%rsi
  70c5e0:	49 39 f4             	cmp    %rsi,%r12
  70c5e3:	0f 83 75 03 00 00    	jae    70c95e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x57e>
  70c5e9:	48 8b 8b 60 05 00 00 	mov    0x560(%rbx),%rcx
  70c5f0:	48 8d b3 c0 02 00 00 	lea    0x2c0(%rbx),%rsi
  70c5f7:	4c 89 e0             	mov    %r12,%rax
  70c5fa:	48 c1 e0 04          	shl    $0x4,%rax
  70c5fe:	0f 10 04 01          	movups (%rcx,%rax,1),%xmm0
  70c602:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  70c609:	00 
  70c60a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c60f:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
  70c616:	00 
  70c617:	ff 15 cb 5b 3f 00    	call   *0x3f5bcb(%rip)        # b021e8 <_DYNAMIC+0x4a0>
  70c61d:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  70c622:	74 59                	je     70c67d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x29d>
  70c624:	0f b6 44 24 11       	movzbl 0x11(%rsp),%eax
  70c629:	48 c7 45 00 22 00 00 	movq   $0x22,0x0(%rbp)
  70c630:	00 
  70c631:	88 45 08             	mov    %al,0x8(%rbp)
  70c634:	eb 07                	jmp    70c63d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c636:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70c63d:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  70c644:	5b                   	pop    %rbx
  70c645:	41 5c                	pop    %r12
  70c647:	41 5d                	pop    %r13
  70c649:	41 5e                	pop    %r14
  70c64b:	41 5f                	pop    %r15
  70c64d:	5d                   	pop    %rbp
  70c64e:	c3                   	ret
  70c64f:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  70c654:	48 89 4d 30          	mov    %rcx,0x30(%rbp)
  70c658:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  70c65d:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  70c662:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  70c666:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70c66a:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70c66e:	4c 89 65 08          	mov    %r12,0x8(%rbp)
  70c672:	eb c9                	jmp    70c63d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c674:	48 c7 00 19 00 00 00 	movq   $0x19,(%rax)
  70c67b:	eb c0                	jmp    70c63d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c67d:	f3 0f 10 44 24 34    	movss  0x34(%rsp),%xmm0
  70c683:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  70c68a:	00 00 
  70c68c:	f3 0f 10 44 24 3c    	movss  0x3c(%rsp),%xmm0
  70c692:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  70c698:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c69d:	48 89 de             	mov    %rbx,%rsi
  70c6a0:	4c 89 e2             	mov    %r12,%rdx
  70c6a3:	e8 c8 eb ff ff       	call   70b270 <<gpui::runtime::Runtime<unit_action_cost::Model>>::interaction_layout>
  70c6a8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c6ad:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c6b1:	75 40                	jne    70c6f3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x313>
  70c6b3:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
  70c6b9:	f3 0f 5c 4c 24 70    	subss  0x70(%rsp),%xmm1
  70c6bf:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  70c6c4:	f3 0f 5c 84 24 80 00 	subss  0x80(%rsp),%xmm0
  70c6cb:	00 00 
  70c6cd:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  70c6d2:	ff 15 38 5b 3f 00    	call   *0x3f5b38(%rip)        # b02210 <_DYNAMIC+0x4c8>
  70c6d8:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  70c6df:	00 00 
  70c6e1:	80 fa 02             	cmp    $0x2,%dl
  70c6e4:	75 3a                	jne    70c720 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x340>
  70c6e6:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70c6ed:	00 
  70c6ee:	e9 4a ff ff ff       	jmp    70c63d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c6f3:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  70c6f8:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  70c6fd:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  70c701:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70c706:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
  70c70a:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  70c70f:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70c713:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70c717:	48 89 4d 08          	mov    %rcx,0x8(%rbp)
  70c71b:	e9 1d ff ff ff       	jmp    70c63d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c720:	41 89 d5             	mov    %edx,%r13d
  70c723:	41 89 c4             	mov    %eax,%r12d
  70c726:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c72b:	e8 a0 7f ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c730:	48 83 bb 60 06 00 00 	cmpq   $0xffffffffffffffff,0x660(%rbx)
  70c737:	ff 
  70c738:	0f 84 03 02 00 00    	je     70c941 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x561>
  70c73e:	48 c7 44 24 10 1f 00 	movq   $0x1f,0x10(%rsp)
  70c745:	00 00 
  70c747:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c74c:	e8 7f 7f ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70c751:	48 89 de             	mov    %rbx,%rsi
  70c754:	48 8b 83 e8 05 00 00 	mov    0x5e8(%rbx),%rax
  70c75b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  70c760:	48 8b 83 f0 05 00 00 	mov    0x5f0(%rbx),%rax
  70c767:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  70c76e:	00 
  70c76f:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  70c776:	48 89 04 24          	mov    %rax,(%rsp)
  70c77a:	48 8b 83 88 06 00 00 	mov    0x688(%rbx),%rax
  70c781:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  70c786:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c78b:	4c 89 fa             	mov    %r15,%rdx
  70c78e:	4c 89 f1             	mov    %r14,%rcx
  70c791:	e8 1a dd ff ff       	call   70a4b0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::focus>
  70c796:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c79b:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c79f:	0f 85 fa 00 00 00    	jne    70c89f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x4bf>
  70c7a5:	41 80 e5 01          	and    $0x1,%r13b
  70c7a9:	44 89 a4 24 c0 00 00 	mov    %r12d,0xc0(%rsp)
  70c7b0:	00 
  70c7b1:	44 88 ac 24 c4 00 00 	mov    %r13b,0xc4(%rsp)
  70c7b8:	00 
  70c7b9:	44 89 a4 24 c8 00 00 	mov    %r12d,0xc8(%rsp)
  70c7c0:	00 
  70c7c1:	44 88 ac 24 cc 00 00 	mov    %r13b,0xcc(%rsp)
  70c7c8:	00 
  70c7c9:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70c7ce:	4c 8d 84 24 c0 00 00 	lea    0xc0(%rsp),%r8
  70c7d5:	00 
  70c7d6:	48 89 de             	mov    %rbx,%rsi
  70c7d9:	4c 89 fa             	mov    %r15,%rdx
  70c7dc:	4c 89 f1             	mov    %r14,%rcx
  70c7df:	e8 fc f9 ff ff       	call   70c1e0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input>
  70c7e4:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70c7e9:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70c7ee:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  70c7f5:	00 
  70c7f6:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70c7fb:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  70c802:	00 
  70c803:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70c808:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  70c80f:	00 
  70c810:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c814:	0f 85 bf 00 00 00    	jne    70c8d9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x4f9>
  70c81a:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  70c821:	00 
  70c822:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70c829:	00 
  70c82a:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  70c831:	00 
  70c832:	0f 29 94 24 00 01 00 	movaps %xmm2,0x100(%rsp)
  70c839:	00 
  70c83a:	0f 29 8c 24 f0 00 00 	movaps %xmm1,0xf0(%rsp)
  70c841:	00 
  70c842:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  70c849:	00 
  70c84a:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  70c851:	48 85 c0             	test   %rax,%rax
  70c854:	48 89 ef             	mov    %rbp,%rdi
  70c857:	0f 84 a9 00 00 00    	je     70c906 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x526>
  70c85d:	48 8b 0c 24          	mov    (%rsp),%rcx
  70c861:	48 85 c9             	test   %rcx,%rcx
  70c864:	0f 84 a7 00 00 00    	je     70c911 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x531>
  70c86a:	48 39 c8             	cmp    %rcx,%rax
  70c86d:	0f 85 9e 00 00 00    	jne    70c911 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x531>
  70c873:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  70c878:	48 39 83 88 06 00 00 	cmp    %rax,0x688(%rbx)
  70c87f:	0f 85 8c 00 00 00    	jne    70c911 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x531>
  70c885:	48 89 de             	mov    %rbx,%rsi
  70c888:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  70c88d:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  70c894:	00 
  70c895:	e8 d6 00 00 00       	call   70c970 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::publish_focus_change>
  70c89a:	e9 9e fd ff ff       	jmp    70c63d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c89f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  70c8a4:	0f b6 54 24 40       	movzbl 0x40(%rsp),%edx
  70c8a9:	8b 74 24 44          	mov    0x44(%rsp),%esi
  70c8ad:	89 75 34             	mov    %esi,0x34(%rbp)
  70c8b0:	8b 74 24 41          	mov    0x41(%rsp),%esi
  70c8b4:	89 75 31             	mov    %esi,0x31(%rbp)
  70c8b7:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70c8bc:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70c8c1:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70c8c5:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70c8c9:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70c8cd:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  70c8d1:	88 55 30             	mov    %dl,0x30(%rbp)
  70c8d4:	e9 64 fd ff ff       	jmp    70c63d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c8d9:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  70c8e0:	00 
  70c8e1:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70c8e8:	00 
  70c8e9:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  70c8f0:	00 
  70c8f1:	0f 11 55 28          	movups %xmm2,0x28(%rbp)
  70c8f5:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70c8f9:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70c8fd:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70c901:	e9 37 fd ff ff       	jmp    70c63d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c906:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
  70c90b:	0f 84 74 ff ff ff    	je     70c885 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x4a5>
  70c911:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
  70c918:	00 
  70c919:	0f 28 8c 24 f0 00 00 	movaps 0xf0(%rsp),%xmm1
  70c920:	00 
  70c921:	0f 28 94 24 00 01 00 	movaps 0x100(%rsp),%xmm2
  70c928:	00 
  70c929:	0f 11 57 28          	movups %xmm2,0x28(%rdi)
  70c92d:	0f 11 4f 18          	movups %xmm1,0x18(%rdi)
  70c931:	0f 11 47 08          	movups %xmm0,0x8(%rdi)
  70c935:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  70c93c:	e9 fc fc ff ff       	jmp    70c63d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c941:	48 c7 45 00 1f 00 00 	movq   $0x1f,0x0(%rbp)
  70c948:	00 
  70c949:	e9 ef fc ff ff       	jmp    70c63d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer+0x25d>
  70c94e:	48 8d 15 03 77 3c 00 	lea    0x3c7703(%rip),%rdx        # ad4058 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x870>
  70c955:	4c 89 e7             	mov    %r12,%rdi
  70c958:	ff 15 62 57 3f 00    	call   *0x3f5762(%rip)        # b020c0 <_DYNAMIC+0x378>
  70c95e:	48 8d 15 0b 77 3c 00 	lea    0x3c770b(%rip),%rdx        # ad4070 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x888>
  70c965:	4c 89 e7             	mov    %r12,%rdi
  70c968:	ff 15 52 57 3f 00    	call   *0x3f5752(%rip)        # b020c0 <_DYNAMIC+0x378>
