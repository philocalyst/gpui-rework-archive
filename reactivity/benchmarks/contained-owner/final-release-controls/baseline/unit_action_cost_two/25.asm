
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000704440 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer>:
  704440:	55                   	push   %rbp
  704441:	41 57                	push   %r15
  704443:	41 56                	push   %r14
  704445:	41 55                	push   %r13
  704447:	41 54                	push   %r12
  704449:	53                   	push   %rbx
  70444a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  704451:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  704458:	75 0c                	jne    704466 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x26>
  70445a:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  704461:	e9 37 02 00 00       	jmp    70469d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  704466:	80 be 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rsi)
  70446d:	0f 85 23 02 00 00    	jne    704696 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  704473:	80 be 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rsi)
  70447a:	0f 85 16 02 00 00    	jne    704696 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  704480:	80 be 20 07 00 00 00 	cmpb   $0x0,0x720(%rsi)
  704487:	0f 84 09 02 00 00    	je     704696 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  70448d:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  704494:	ff 
  704495:	0f 85 fb 01 00 00    	jne    704696 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  70449b:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  7044a2:	48 3b 86 68 06 00 00 	cmp    0x668(%rsi),%rax
  7044a9:	0f 85 e7 01 00 00    	jne    704696 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  7044af:	48 8b 86 78 06 00 00 	mov    0x678(%rsi),%rax
  7044b6:	48 3b 86 70 06 00 00 	cmp    0x670(%rsi),%rax
  7044bd:	0f 85 d3 01 00 00    	jne    704696 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  7044c3:	f3 0f 10 96 14 07 00 	movss  0x714(%rsi),%xmm2
  7044ca:	00 
  7044cb:	0f 2e 96 18 07 00 00 	ucomiss 0x718(%rsi),%xmm2
  7044d2:	0f 85 be 01 00 00    	jne    704696 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  7044d8:	0f 8a b8 01 00 00    	jp     704696 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  7044de:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  7044e4:	f3 0f 11 0c 24       	movss  %xmm1,(%rsp)
  7044e9:	48 89 fd             	mov    %rdi,%rbp
  7044ec:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7044f1:	48 89 f3             	mov    %rsi,%rbx
  7044f4:	49 89 d7             	mov    %rdx,%r15
  7044f7:	49 89 ce             	mov    %rcx,%r14
  7044fa:	e8 f1 cd ff ff       	call   7012f0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::input_index>
  7044ff:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  704504:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  704509:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70450d:	0f 85 9c 01 00 00    	jne    7046af <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x26f>
  704513:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70451a:	49 39 f4             	cmp    %rsi,%r12
  70451d:	0f 83 8b 04 00 00    	jae    7049ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x56e>
  704523:	48 89 e8             	mov    %rbp,%rax
  704526:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70452d:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  704531:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
  704535:	48 8b 8b 78 05 00 00 	mov    0x578(%rbx),%rcx
  70453c:	48 8b 93 80 05 00 00 	mov    0x580(%rbx),%rdx
  704543:	48 c1 e2 04          	shl    $0x4,%rdx
  704547:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  70454b:	31 d2                	xor    %edx,%edx
  70454d:	49 89 c8             	mov    %rcx,%r8
  704550:	48 39 d7             	cmp    %rdx,%rdi
  704553:	0f 84 7b 01 00 00    	je     7046d4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x294>
  704559:	48 83 c2 50          	add    $0x50,%rdx
  70455d:	49 39 70 20          	cmp    %rsi,0x20(%r8)
  704561:	4d 8d 40 50          	lea    0x50(%r8),%r8
  704565:	75 e9                	jne    704550 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x110>
  704567:	f3 0f 10 44 11 e0    	movss  -0x20(%rcx,%rdx,1),%xmm0
  70456d:	0f 2e c0             	ucomiss %xmm0,%xmm0
  704570:	0f 8a 5e 01 00 00    	jp     7046d4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x294>
  704576:	f3 0f 10 4c 11 e4    	movss  -0x1c(%rcx,%rdx,1),%xmm1
  70457c:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  704583:	00 00 
  704585:	0f 14 c1             	unpcklps %xmm1,%xmm0
  704588:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  70458b:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  704592:	00 
  704593:	0f 5a 44 11 e8       	cvtps2pd -0x18(%rcx,%rdx,1),%xmm0
  704598:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70459d:	0f 5a 44 11 f0       	cvtps2pd -0x10(%rcx,%rdx,1),%xmm0
  7045a2:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  7045a9:	00 
  7045aa:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7045af:	e8 cc 34 ff ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7045b4:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  7045bb:	00 
  7045bc:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  7045c1:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  7045c6:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  7045cb:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  7045d2:	00 
  7045d3:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  7045d8:	c6 44 24 40 00       	movb   $0x0,0x40(%rsp)
  7045dd:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  7045e4:	00 
  7045e5:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  7045ea:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
  7045f0:	f3 0f 10 0c 24       	movss  (%rsp),%xmm1
  7045f5:	ff 15 55 3b 42 00    	call   *0x423b55(%rip)        # b28150 <_DYNAMIC+0x498>
  7045fb:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  704602:	00 00 
  704604:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  70460b:	01 
  70460c:	0f 85 34 01 00 00    	jne    704746 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x306>
  704612:	f3 0f 10 84 24 94 00 	movss  0x94(%rsp),%xmm0
  704619:	00 00 
  70461b:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  704620:	f3 0f 10 84 24 98 00 	movss  0x98(%rsp),%xmm0
  704627:	00 00 
  704629:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70462f:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  704634:	e8 47 34 ff ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  704639:	48 8b b3 68 05 00 00 	mov    0x568(%rbx),%rsi
  704640:	49 39 f4             	cmp    %rsi,%r12
  704643:	0f 83 75 03 00 00    	jae    7049be <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x57e>
  704649:	48 8b 8b 60 05 00 00 	mov    0x560(%rbx),%rcx
  704650:	48 8d b3 c0 02 00 00 	lea    0x2c0(%rbx),%rsi
  704657:	4c 89 e0             	mov    %r12,%rax
  70465a:	48 c1 e0 04          	shl    $0x4,%rax
  70465e:	0f 10 04 01          	movups (%rcx,%rax,1),%xmm0
  704662:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  704669:	00 
  70466a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70466f:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
  704676:	00 
  704677:	ff 15 b3 3a 42 00    	call   *0x423ab3(%rip)        # b28130 <_DYNAMIC+0x478>
  70467d:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  704682:	74 59                	je     7046dd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x29d>
  704684:	0f b6 44 24 11       	movzbl 0x11(%rsp),%eax
  704689:	48 c7 45 00 22 00 00 	movq   $0x22,0x0(%rbp)
  704690:	00 
  704691:	88 45 08             	mov    %al,0x8(%rbp)
  704694:	eb 07                	jmp    70469d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  704696:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70469d:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  7046a4:	5b                   	pop    %rbx
  7046a5:	41 5c                	pop    %r12
  7046a7:	41 5d                	pop    %r13
  7046a9:	41 5e                	pop    %r14
  7046ab:	41 5f                	pop    %r15
  7046ad:	5d                   	pop    %rbp
  7046ae:	c3                   	ret
  7046af:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  7046b4:	48 89 4d 30          	mov    %rcx,0x30(%rbp)
  7046b8:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  7046bd:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  7046c2:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  7046c6:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  7046ca:	48 89 45 00          	mov    %rax,0x0(%rbp)
  7046ce:	4c 89 65 08          	mov    %r12,0x8(%rbp)
  7046d2:	eb c9                	jmp    70469d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  7046d4:	48 c7 00 19 00 00 00 	movq   $0x19,(%rax)
  7046db:	eb c0                	jmp    70469d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  7046dd:	f3 0f 10 44 24 34    	movss  0x34(%rsp),%xmm0
  7046e3:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  7046ea:	00 00 
  7046ec:	f3 0f 10 44 24 3c    	movss  0x3c(%rsp),%xmm0
  7046f2:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  7046f8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7046fd:	48 89 de             	mov    %rbx,%rsi
  704700:	4c 89 e2             	mov    %r12,%rdx
  704703:	e8 58 d7 ff ff       	call   701e60 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::interaction_layout>
  704708:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70470d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  704711:	75 40                	jne    704753 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x313>
  704713:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
  704719:	f3 0f 5c 4c 24 70    	subss  0x70(%rsp),%xmm1
  70471f:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  704724:	f3 0f 5c 84 24 80 00 	subss  0x80(%rsp),%xmm0
  70472b:	00 00 
  70472d:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  704732:	ff 15 20 3a 42 00    	call   *0x423a20(%rip)        # b28158 <_DYNAMIC+0x4a0>
  704738:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  70473f:	00 00 
  704741:	80 fa 02             	cmp    $0x2,%dl
  704744:	75 3a                	jne    704780 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x340>
  704746:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70474d:	00 
  70474e:	e9 4a ff ff ff       	jmp    70469d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  704753:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  704758:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  70475d:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  704761:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  704766:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
  70476a:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  70476f:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  704773:	48 89 45 00          	mov    %rax,0x0(%rbp)
  704777:	48 89 4d 08          	mov    %rcx,0x8(%rbp)
  70477b:	e9 1d ff ff ff       	jmp    70469d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  704780:	41 89 d5             	mov    %edx,%r13d
  704783:	41 89 c4             	mov    %eax,%r12d
  704786:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70478b:	e8 f0 32 ff ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  704790:	48 83 bb 60 06 00 00 	cmpq   $0xffffffffffffffff,0x660(%rbx)
  704797:	ff 
  704798:	0f 84 03 02 00 00    	je     7049a1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x561>
  70479e:	48 c7 44 24 10 1f 00 	movq   $0x1f,0x10(%rsp)
  7047a5:	00 00 
  7047a7:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7047ac:	e8 cf 32 ff ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7047b1:	48 89 de             	mov    %rbx,%rsi
  7047b4:	48 8b 83 e8 05 00 00 	mov    0x5e8(%rbx),%rax
  7047bb:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7047c0:	48 8b 83 f0 05 00 00 	mov    0x5f0(%rbx),%rax
  7047c7:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  7047ce:	00 
  7047cf:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  7047d6:	48 89 04 24          	mov    %rax,(%rsp)
  7047da:	48 8b 83 88 06 00 00 	mov    0x688(%rbx),%rax
  7047e1:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  7047e6:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7047eb:	4c 89 fa             	mov    %r15,%rdx
  7047ee:	4c 89 f1             	mov    %r14,%rcx
  7047f1:	e8 1a b7 ff ff       	call   6fff10 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::focus>
  7047f6:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7047fb:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  7047ff:	0f 85 fa 00 00 00    	jne    7048ff <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x4bf>
  704805:	41 80 e5 01          	and    $0x1,%r13b
  704809:	44 89 a4 24 c0 00 00 	mov    %r12d,0xc0(%rsp)
  704810:	00 
  704811:	44 88 ac 24 c4 00 00 	mov    %r13b,0xc4(%rsp)
  704818:	00 
  704819:	44 89 a4 24 c8 00 00 	mov    %r12d,0xc8(%rsp)
  704820:	00 
  704821:	44 88 ac 24 cc 00 00 	mov    %r13b,0xcc(%rsp)
  704828:	00 
  704829:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70482e:	4c 8d 84 24 c0 00 00 	lea    0xc0(%rsp),%r8
  704835:	00 
  704836:	48 89 de             	mov    %rbx,%rsi
  704839:	4c 89 fa             	mov    %r15,%rdx
  70483c:	4c 89 f1             	mov    %r14,%rcx
  70483f:	e8 fc f9 ff ff       	call   704240 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input>
  704844:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  704849:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70484e:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  704855:	00 
  704856:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70485b:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  704862:	00 
  704863:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  704868:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  70486f:	00 
  704870:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  704874:	0f 85 bf 00 00 00    	jne    704939 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x4f9>
  70487a:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  704881:	00 
  704882:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  704889:	00 
  70488a:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  704891:	00 
  704892:	0f 29 94 24 00 01 00 	movaps %xmm2,0x100(%rsp)
  704899:	00 
  70489a:	0f 29 8c 24 f0 00 00 	movaps %xmm1,0xf0(%rsp)
  7048a1:	00 
  7048a2:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  7048a9:	00 
  7048aa:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  7048b1:	48 85 c0             	test   %rax,%rax
  7048b4:	48 89 ef             	mov    %rbp,%rdi
  7048b7:	0f 84 a9 00 00 00    	je     704966 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x526>
  7048bd:	48 8b 0c 24          	mov    (%rsp),%rcx
  7048c1:	48 85 c9             	test   %rcx,%rcx
  7048c4:	0f 84 a7 00 00 00    	je     704971 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x531>
  7048ca:	48 39 c8             	cmp    %rcx,%rax
  7048cd:	0f 85 9e 00 00 00    	jne    704971 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x531>
  7048d3:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  7048d8:	48 39 83 88 06 00 00 	cmp    %rax,0x688(%rbx)
  7048df:	0f 85 8c 00 00 00    	jne    704971 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x531>
  7048e5:	48 89 de             	mov    %rbx,%rsi
  7048e8:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  7048ed:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  7048f4:	00 
  7048f5:	e8 d6 00 00 00       	call   7049d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change>
  7048fa:	e9 9e fd ff ff       	jmp    70469d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  7048ff:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  704904:	0f b6 54 24 40       	movzbl 0x40(%rsp),%edx
  704909:	8b 74 24 44          	mov    0x44(%rsp),%esi
  70490d:	89 75 34             	mov    %esi,0x34(%rbp)
  704910:	8b 74 24 41          	mov    0x41(%rsp),%esi
  704914:	89 75 31             	mov    %esi,0x31(%rbp)
  704917:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70491c:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  704921:	48 89 45 00          	mov    %rax,0x0(%rbp)
  704925:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  704929:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70492d:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  704931:	88 55 30             	mov    %dl,0x30(%rbp)
  704934:	e9 64 fd ff ff       	jmp    70469d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  704939:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  704940:	00 
  704941:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  704948:	00 
  704949:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  704950:	00 
  704951:	0f 11 55 28          	movups %xmm2,0x28(%rbp)
  704955:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  704959:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70495d:	48 89 45 00          	mov    %rax,0x0(%rbp)
  704961:	e9 37 fd ff ff       	jmp    70469d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  704966:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
  70496b:	0f 84 74 ff ff ff    	je     7048e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x4a5>
  704971:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
  704978:	00 
  704979:	0f 28 8c 24 f0 00 00 	movaps 0xf0(%rsp),%xmm1
  704980:	00 
  704981:	0f 28 94 24 00 01 00 	movaps 0x100(%rsp),%xmm2
  704988:	00 
  704989:	0f 11 57 28          	movups %xmm2,0x28(%rdi)
  70498d:	0f 11 4f 18          	movups %xmm1,0x18(%rdi)
  704991:	0f 11 47 08          	movups %xmm0,0x8(%rdi)
  704995:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  70499c:	e9 fc fc ff ff       	jmp    70469d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  7049a1:	48 c7 45 00 1f 00 00 	movq   $0x1f,0x0(%rbp)
  7049a8:	00 
  7049a9:	e9 ef fc ff ff       	jmp    70469d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  7049ae:	48 8d 15 7b 52 3f 00 	lea    0x3f527b(%rip),%rdx        # af9c30 <__frame_dummy_init_array_entry+0x708>
  7049b5:	4c 89 e7             	mov    %r12,%rdi
  7049b8:	ff 15 52 36 42 00    	call   *0x423652(%rip)        # b28010 <_DYNAMIC+0x358>
  7049be:	48 8d 15 83 52 3f 00 	lea    0x3f5283(%rip),%rdx        # af9c48 <__frame_dummy_init_array_entry+0x720>
  7049c5:	4c 89 e7             	mov    %r12,%rdi
  7049c8:	ff 15 42 36 42 00    	call   *0x423642(%rip)        # b28010 <_DYNAMIC+0x358>
