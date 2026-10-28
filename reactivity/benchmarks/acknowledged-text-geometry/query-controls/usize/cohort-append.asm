
/tmp/gpui-ack-query-comparison/usize/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a5d680 <<gpui::native::accessibility::text::Cohort>::append>:
  a5d680:	55                   	push   %rbp
  a5d681:	41 57                	push   %r15
  a5d683:	41 56                	push   %r14
  a5d685:	41 55                	push   %r13
  a5d687:	41 54                	push   %r12
  a5d689:	53                   	push   %rbx
  a5d68a:	48 81 ec 58 04 00 00 	sub    $0x458,%rsp
  a5d691:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  a5d696:	49 89 f4             	mov    %rsi,%r12
  a5d699:	48 8b 76 38          	mov    0x38(%rsi),%rsi
  a5d69d:	48 39 f2             	cmp    %rsi,%rdx
  a5d6a0:	0f 83 7d 18 00 00    	jae    a5ef23 <<gpui::native::accessibility::text::Cohort>::append+0x18a3>
  a5d6a6:	48 8b 4f 10          	mov    0x10(%rdi),%rcx
  a5d6aa:	48 85 c9             	test   %rcx,%rcx
  a5d6ad:	0f 84 6d 17 00 00    	je     a5ee20 <<gpui::native::accessibility::text::Cohort>::append+0x17a0>
  a5d6b3:	4c 89 cb             	mov    %r9,%rbx
  a5d6b6:	4d 8b 6c 24 30       	mov    0x30(%r12),%r13
  a5d6bb:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
  a5d6bf:	48 c1 e0 04          	shl    $0x4,%rax
  a5d6c3:	49 8b 74 05 20       	mov    0x20(%r13,%rax,1),%rsi
  a5d6c8:	4c 8b 77 08          	mov    0x8(%rdi),%r14
  a5d6cc:	48 83 f9 01          	cmp    $0x1,%rcx
  a5d6d0:	75 0b                	jne    a5d6dd <<gpui::native::accessibility::text::Cohort>::append+0x5d>
  a5d6d2:	49 39 76 08          	cmp    %rsi,0x8(%r14)
  a5d6d6:	74 3c                	je     a5d714 <<gpui::native::accessibility::text::Cohort>::append+0x94>
  a5d6d8:	e9 43 17 00 00       	jmp    a5ee20 <<gpui::native::accessibility::text::Cohort>::append+0x17a0>
  a5d6dd:	31 ff                	xor    %edi,%edi
  a5d6df:	90                   	nop
  a5d6e0:	49 89 fb             	mov    %rdi,%r11
  a5d6e3:	49 89 c9             	mov    %rcx,%r9
  a5d6e6:	49 d1 e9             	shr    $1,%r9
  a5d6e9:	4c 01 cf             	add    %r9,%rdi
  a5d6ec:	4c 6b d7 38          	imul   $0x38,%rdi,%r10
  a5d6f0:	4b 39 74 16 08       	cmp    %rsi,0x8(%r14,%r10,1)
  a5d6f5:	49 0f 47 fb          	cmova  %r11,%rdi
  a5d6f9:	4c 29 c9             	sub    %r9,%rcx
  a5d6fc:	48 83 f9 01          	cmp    $0x1,%rcx
  a5d700:	77 de                	ja     a5d6e0 <<gpui::native::accessibility::text::Cohort>::append+0x60>
  a5d702:	48 6b cf 38          	imul   $0x38,%rdi,%rcx
  a5d706:	49 39 74 0e 08       	cmp    %rsi,0x8(%r14,%rcx,1)
  a5d70b:	0f 85 0f 17 00 00    	jne    a5ee20 <<gpui::native::accessibility::text::Cohort>::append+0x17a0>
  a5d711:	49 01 ce             	add    %rcx,%r14
  a5d714:	49 01 c5             	add    %rax,%r13
  a5d717:	41 0f b6 45 4d       	movzbl 0x4d(%r13),%eax
  a5d71c:	3c 01                	cmp    $0x1,%al
  a5d71e:	4c 89 84 24 30 01 00 	mov    %r8,0x130(%rsp)
  a5d725:	00 
  a5d726:	75 3f                	jne    a5d767 <<gpui::native::accessibility::text::Cohort>::append+0xe7>
  a5d728:	4c 89 e7             	mov    %r12,%rdi
  a5d72b:	49 89 d7             	mov    %rdx,%r15
  a5d72e:	48 89 d6             	mov    %rdx,%rsi
  a5d731:	ff 15 51 36 ad 00    	call   *0xad3651(%rip)        # 1530d88 <_DYNAMIC+0x1668>
  a5d737:	49 8b 75 28          	mov    0x28(%r13),%rsi
  a5d73b:	48 85 f6             	test   %rsi,%rsi
  a5d73e:	0f 94 c1             	sete   %cl
  a5d741:	74 3c                	je     a5d77f <<gpui::native::accessibility::text::Cohort>::append+0xff>
  a5d743:	48 85 c0             	test   %rax,%rax
  a5d746:	74 3e                	je     a5d786 <<gpui::native::accessibility::text::Cohort>::append+0x106>
  a5d748:	48 8b 0e             	mov    (%rsi),%rcx
  a5d74b:	48 d1 e9             	shr    $1,%rcx
  a5d74e:	48 39 ca             	cmp    %rcx,%rdx
  a5d751:	75 31                	jne    a5d784 <<gpui::native::accessibility::text::Cohort>::append+0x104>
  a5d753:	48 83 c6 10          	add    $0x10,%rsi
  a5d757:	48 89 c7             	mov    %rax,%rdi
  a5d75a:	ff 15 e8 23 ad 00    	call   *0xad23e8(%rip)        # 152fb48 <bcmp@GLIBC_2.2.5>
  a5d760:	85 c0                	test   %eax,%eax
  a5d762:	0f 94 c1             	sete   %cl
  a5d765:	eb 1f                	jmp    a5d786 <<gpui::native::accessibility::text::Cohort>::append+0x106>
  a5d767:	31 c9                	xor    %ecx,%ecx
  a5d769:	84 c9                	test   %cl,%cl
  a5d76b:	4c 89 a4 24 48 01 00 	mov    %r12,0x148(%rsp)
  a5d772:	00 
  a5d773:	4c 89 ac 24 38 02 00 	mov    %r13,0x238(%rsp)
  a5d77a:	00 
  a5d77b:	74 28                	je     a5d7a5 <<gpui::native::accessibility::text::Cohort>::append+0x125>
  a5d77d:	eb 44                	jmp    a5d7c3 <<gpui::native::accessibility::text::Cohort>::append+0x143>
  a5d77f:	48 85 c0             	test   %rax,%rax
  a5d782:	74 02                	je     a5d786 <<gpui::native::accessibility::text::Cohort>::append+0x106>
  a5d784:	31 c9                	xor    %ecx,%ecx
  a5d786:	4c 89 fa             	mov    %r15,%rdx
  a5d789:	80 f1 01             	xor    $0x1,%cl
  a5d78c:	41 0f b6 45 4d       	movzbl 0x4d(%r13),%eax
  a5d791:	84 c9                	test   %cl,%cl
  a5d793:	4c 89 a4 24 48 01 00 	mov    %r12,0x148(%rsp)
  a5d79a:	00 
  a5d79b:	4c 89 ac 24 38 02 00 	mov    %r13,0x238(%rsp)
  a5d7a2:	00 
  a5d7a3:	75 1e                	jne    a5d7c3 <<gpui::native::accessibility::text::Cohort>::append+0x143>
  a5d7a5:	8d 48 fd             	lea    -0x3(%rax),%ecx
  a5d7a8:	80 f9 fe             	cmp    $0xfe,%cl
  a5d7ab:	72 16                	jb     a5d7c3 <<gpui::native::accessibility::text::Cohort>::append+0x143>
  a5d7ad:	48 c7 84 24 d0 03 00 	movq   $0xffffffffffffffff,0x3d0(%rsp)
  a5d7b4:	00 ff ff ff ff 
  a5d7b9:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
  a5d7be:	e9 d9 01 00 00       	jmp    a5d99c <<gpui::native::accessibility::text::Cohort>::append+0x31c>
  a5d7c3:	4d 8b 7d 28          	mov    0x28(%r13),%r15
  a5d7c7:	4d 85 ff             	test   %r15,%r15
  a5d7ca:	b9 03 00 00 00       	mov    $0x3,%ecx
  a5d7cf:	be 0e 00 00 00       	mov    $0xe,%esi
  a5d7d4:	0f 44 f1             	cmove  %ecx,%esi
  a5d7d7:	3c 02                	cmp    $0x2,%al
  a5d7d9:	0f 45 f1             	cmovne %ecx,%esi
  a5d7dc:	48 b8 57 57 57 57 57 	movabs $0x5757575757575757,%rax
  a5d7e3:	57 57 57 
  a5d7e6:	48 89 84 24 57 03 00 	mov    %rax,0x357(%rsp)
  a5d7ed:	00 
  a5d7ee:	0f 28 05 0b f9 72 ff 	movaps -0x8d06f5(%rip),%xmm0        # 18d100 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a5d7f5:	0f 11 84 24 48 03 00 	movups %xmm0,0x348(%rsp)
  a5d7fc:	00 
  a5d7fd:	0f 11 84 24 38 03 00 	movups %xmm0,0x338(%rsp)
  a5d804:	00 
  a5d805:	0f 11 84 24 28 03 00 	movups %xmm0,0x328(%rsp)
  a5d80c:	00 
  a5d80d:	0f 11 84 24 18 03 00 	movups %xmm0,0x318(%rsp)
  a5d814:	00 
  a5d815:	0f 11 84 24 08 03 00 	movups %xmm0,0x308(%rsp)
  a5d81c:	00 
  a5d81d:	40 88 b4 24 6c 03 00 	mov    %sil,0x36c(%rsp)
  a5d824:	00 
  a5d825:	48 c7 84 24 60 03 00 	movq   $0x0,0x360(%rsp)
  a5d82c:	00 00 00 00 00 
  a5d831:	c7 84 24 68 03 00 00 	movl   $0x0,0x368(%rsp)
  a5d838:	00 00 00 00 
  a5d83c:	48 c7 84 24 f0 02 00 	movq   $0x0,0x2f0(%rsp)
  a5d843:	00 00 00 00 00 
  a5d848:	48 c7 84 24 f8 02 00 	movq   $0x8,0x2f8(%rsp)
  a5d84f:	00 08 00 00 00 
  a5d854:	48 c7 84 24 00 03 00 	movq   $0x0,0x300(%rsp)
  a5d85b:	00 00 00 00 00 
  a5d860:	4d 85 ff             	test   %r15,%r15
  a5d863:	0f 84 52 16 00 00    	je     a5eebb <<gpui::native::accessibility::text::Cohort>::append+0x183b>
  a5d869:	48 89 d5             	mov    %rdx,%rbp
  a5d86c:	4d 8b 27             	mov    (%r15),%r12
  a5d86f:	49 d1 ec             	shr    $1,%r12
  a5d872:	74 35                	je     a5d8a9 <<gpui::native::accessibility::text::Cohort>::append+0x229>
  a5d874:	ff 15 e6 20 ad 00    	call   *0xad20e6(%rip)        # 152f960 <_DYNAMIC+0x240>
  a5d87a:	be 01 00 00 00       	mov    $0x1,%esi
  a5d87f:	4c 89 e7             	mov    %r12,%rdi
  a5d882:	ff 15 e0 20 ad 00    	call   *0xad20e0(%rip)        # 152f968 <_DYNAMIC+0x248>
  a5d888:	48 85 c0             	test   %rax,%rax
  a5d88b:	0f 84 1d 17 00 00    	je     a5efae <<gpui::native::accessibility::text::Cohort>::append+0x192e>
  a5d891:	49 89 c5             	mov    %rax,%r13
  a5d894:	49 83 c7 10          	add    $0x10,%r15
  a5d898:	48 89 c7             	mov    %rax,%rdi
  a5d89b:	4c 89 fe             	mov    %r15,%rsi
  a5d89e:	4c 89 e2             	mov    %r12,%rdx
  a5d8a1:	ff 15 d9 20 ad 00    	call   *0xad20d9(%rip)        # 152f980 <memcpy@GLIBC_2.14>
  a5d8a7:	eb 06                	jmp    a5d8af <<gpui::native::accessibility::text::Cohort>::append+0x22f>
  a5d8a9:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  a5d8af:	4c 89 a4 24 88 01 00 	mov    %r12,0x188(%rsp)
  a5d8b6:	00 
  a5d8b7:	4c 89 ac 24 90 01 00 	mov    %r13,0x190(%rsp)
  a5d8be:	00 
  a5d8bf:	4c 89 a4 24 98 01 00 	mov    %r12,0x198(%rsp)
  a5d8c6:	00 
  a5d8c7:	c6 84 24 80 01 00 00 	movb   $0x3,0x180(%rsp)
  a5d8ce:	03 
  a5d8cf:	48 8d bc 24 f0 02 00 	lea    0x2f0(%rsp),%rdi
  a5d8d6:	00 
  a5d8d7:	48 8d 94 24 80 01 00 	lea    0x180(%rsp),%rdx
  a5d8de:	00 
  a5d8df:	be 11 00 00 00       	mov    $0x11,%esi
  a5d8e4:	ff 15 a6 34 ad 00    	call   *0xad34a6(%rip)        # 1530d90 <_DYNAMIC+0x1670>
  a5d8ea:	0f 10 84 24 f0 02 00 	movups 0x2f0(%rsp),%xmm0
  a5d8f1:	00 
  a5d8f2:	66 0f 10 8c 24 00 03 	movupd 0x300(%rsp),%xmm1
  a5d8f9:	00 00 
  a5d8fb:	66 0f 10 94 24 10 03 	movupd 0x310(%rsp),%xmm2
  a5d902:	00 00 
  a5d904:	66 0f 10 9c 24 20 03 	movupd 0x320(%rsp),%xmm3
  a5d90b:	00 00 
  a5d90d:	0f 29 84 24 d0 03 00 	movaps %xmm0,0x3d0(%rsp)
  a5d914:	00 
  a5d915:	66 0f 29 8c 24 e0 03 	movapd %xmm1,0x3e0(%rsp)
  a5d91c:	00 00 
  a5d91e:	66 0f 29 94 24 f0 03 	movapd %xmm2,0x3f0(%rsp)
  a5d925:	00 00 
  a5d927:	66 0f 29 9c 24 00 04 	movapd %xmm3,0x400(%rsp)
  a5d92e:	00 00 
  a5d930:	0f 10 84 24 30 03 00 	movups 0x330(%rsp),%xmm0
  a5d937:	00 
  a5d938:	0f 29 84 24 10 04 00 	movaps %xmm0,0x410(%rsp)
  a5d93f:	00 
  a5d940:	0f 10 84 24 40 03 00 	movups 0x340(%rsp),%xmm0
  a5d947:	00 
  a5d948:	0f 29 84 24 20 04 00 	movaps %xmm0,0x420(%rsp)
  a5d94f:	00 
  a5d950:	0f 10 84 24 50 03 00 	movups 0x350(%rsp),%xmm0
  a5d957:	00 
  a5d958:	0f 29 84 24 30 04 00 	movaps %xmm0,0x430(%rsp)
  a5d95f:	00 
  a5d960:	66 0f 10 84 24 60 03 	movupd 0x360(%rsp),%xmm0
  a5d967:	00 00 
  a5d969:	48 83 bc 24 d0 03 00 	cmpq   $0xffffffffffffffff,0x3d0(%rsp)
  a5d970:	00 ff 
  a5d972:	66 0f 29 84 24 40 04 	movapd %xmm0,0x440(%rsp)
  a5d979:	00 00 
  a5d97b:	4c 8d bc 24 d0 03 00 	lea    0x3d0(%rsp),%r15
  a5d982:	00 
  a5d983:	4c 0f 44 7c 24 30    	cmove  0x30(%rsp),%r15
  a5d989:	48 89 ea             	mov    %rbp,%rdx
  a5d98c:	4c 8b a4 24 48 01 00 	mov    0x148(%rsp),%r12
  a5d993:	00 
  a5d994:	4c 8b ac 24 38 02 00 	mov    0x238(%rsp),%r13
  a5d99b:	00 
  a5d99c:	49 8b 4c 24 40       	mov    0x40(%r12),%rcx
  a5d9a1:	48 85 c9             	test   %rcx,%rcx
  a5d9a4:	0f 84 8c 15 00 00    	je     a5ef36 <<gpui::native::accessibility::text::Cohort>::append+0x18b6>
  a5d9aa:	48 8b 41 08          	mov    0x8(%rcx),%rax
  a5d9ae:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  a5d9b2:	48 83 f9 01          	cmp    $0x1,%rcx
  a5d9b6:	74 54                	je     a5da0c <<gpui::native::accessibility::text::Cohort>::append+0x38c>
  a5d9b8:	48 85 c9             	test   %rcx,%rcx
  a5d9bb:	0f 84 75 15 00 00    	je     a5ef36 <<gpui::native::accessibility::text::Cohort>::append+0x18b6>
  a5d9c1:	31 f6                	xor    %esi,%esi
  a5d9c3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a5d9ca:	84 00 00 00 00 00 
  a5d9d0:	48 89 f7             	mov    %rsi,%rdi
  a5d9d3:	49 89 c8             	mov    %rcx,%r8
  a5d9d6:	49 d1 e8             	shr    $1,%r8
  a5d9d9:	4c 01 c6             	add    %r8,%rsi
  a5d9dc:	4c 8d 0c 76          	lea    (%rsi,%rsi,2),%r9
  a5d9e0:	46 8b 4c c8 10       	mov    0x10(%rax,%r9,8),%r9d
  a5d9e5:	4c 39 ca             	cmp    %r9,%rdx
  a5d9e8:	48 0f 42 f7          	cmovb  %rdi,%rsi
  a5d9ec:	4c 29 c1             	sub    %r8,%rcx
  a5d9ef:	48 83 f9 01          	cmp    $0x1,%rcx
  a5d9f3:	77 db                	ja     a5d9d0 <<gpui::native::accessibility::text::Cohort>::append+0x350>
  a5d9f5:	48 8d 0c 76          	lea    (%rsi,%rsi,2),%rcx
  a5d9f9:	8b 74 c8 10          	mov    0x10(%rax,%rcx,8),%esi
  a5d9fd:	48 39 f2             	cmp    %rsi,%rdx
  a5da00:	0f 85 30 15 00 00    	jne    a5ef36 <<gpui::native::accessibility::text::Cohort>::append+0x18b6>
  a5da06:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  a5da0a:	eb 0c                	jmp    a5da18 <<gpui::native::accessibility::text::Cohort>::append+0x398>
  a5da0c:	8b 48 10             	mov    0x10(%rax),%ecx
  a5da0f:	48 39 ca             	cmp    %rcx,%rdx
  a5da12:	0f 85 1e 15 00 00    	jne    a5ef36 <<gpui::native::accessibility::text::Cohort>::append+0x18b6>
  a5da18:	f3 41 0f 10 45 30    	movss  0x30(%r13),%xmm0
  a5da1e:	0f 29 04 24          	movaps %xmm0,(%rsp)
  a5da22:	0f 2e c0             	ucomiss %xmm0,%xmm0
  a5da25:	4c 89 bc 24 50 01 00 	mov    %r15,0x150(%rsp)
  a5da2c:	00 
  a5da2d:	0f 8a 25 01 00 00    	jp     a5db58 <<gpui::native::accessibility::text::Cohort>::append+0x4d8>
  a5da33:	f2 0f 10 40 08       	movsd  0x8(%rax),%xmm0
  a5da38:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  a5da3f:	00 
  a5da40:	f3 41 0f 10 45 3c    	movss  0x3c(%r13),%xmm0
  a5da46:	0f 29 84 24 40 02 00 	movaps %xmm0,0x240(%rsp)
  a5da4d:	00 
  a5da4e:	f2 41 0f 10 45 40    	movsd  0x40(%r13),%xmm0
  a5da54:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  a5da5b:	00 
  a5da5c:	f2 41 0f 10 45 34    	movsd  0x34(%r13),%xmm0
  a5da62:	66 0f 29 84 24 10 01 	movapd %xmm0,0x110(%rsp)
  a5da69:	00 00 
  a5da6b:	ff 15 ef 1e ad 00    	call   *0xad1eef(%rip)        # 152f960 <_DYNAMIC+0x240>
  a5da71:	bf 30 00 00 00       	mov    $0x30,%edi
  a5da76:	be 08 00 00 00       	mov    $0x8,%esi
  a5da7b:	ff 15 e7 1e ad 00    	call   *0xad1ee7(%rip)        # 152f968 <_DYNAMIC+0x248>
  a5da81:	48 85 c0             	test   %rax,%rax
  a5da84:	0f 84 e4 13 00 00    	je     a5ee6e <<gpui::native::accessibility::text::Cohort>::append+0x17ee>
  a5da8a:	0f 28 04 24          	movaps (%rsp),%xmm0
  a5da8e:	0f 14 84 24 40 02 00 	unpcklps 0x240(%rsp),%xmm0
  a5da95:	00 
  a5da96:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  a5da99:	0f 5a 9c 24 f0 00 00 	cvtps2pd 0xf0(%rsp),%xmm3
  a5daa0:	00 
  a5daa1:	0f 5a 8c 24 10 01 00 	cvtps2pd 0x110(%rsp),%xmm1
  a5daa8:	00 
  a5daa9:	0f 5a 94 24 00 01 00 	cvtps2pd 0x100(%rsp),%xmm2
  a5dab0:	00 
  a5dab1:	66 0f 13 00          	movlpd %xmm0,(%rax)
  a5dab5:	66 0f 11 48 08       	movupd %xmm1,0x8(%rax)
  a5daba:	66 0f 17 40 18       	movhpd %xmm0,0x18(%rax)
  a5dabf:	66 0f 59 cb          	mulpd  %xmm3,%xmm1
  a5dac3:	66 0f c6 c9 01       	shufpd $0x1,%xmm1,%xmm1
  a5dac8:	66 0f 29 1c 24       	movapd %xmm3,(%rsp)
  a5dacd:	66 0f 59 c3          	mulpd  %xmm3,%xmm0
  a5dad1:	66 0f 58 c1          	addpd  %xmm1,%xmm0
  a5dad5:	66 0f 58 c2          	addpd  %xmm2,%xmm0
  a5dad9:	66 0f 11 40 20       	movupd %xmm0,0x20(%rax)
  a5dade:	48 89 84 24 f8 02 00 	mov    %rax,0x2f8(%rsp)
  a5dae5:	00 
  a5dae6:	c6 84 24 f0 02 00 00 	movb   $0x19,0x2f0(%rsp)
  a5daed:	19 
  a5daee:	c6 84 24 10 01 00 00 	movb   $0x1,0x110(%rsp)
  a5daf5:	01 
  a5daf6:	48 8d 94 24 f0 02 00 	lea    0x2f0(%rsp),%rdx
  a5dafd:	00 
  a5dafe:	4c 89 ff             	mov    %r15,%rdi
  a5db01:	be 52 00 00 00       	mov    $0x52,%esi
  a5db06:	ff 15 84 32 ad 00    	call   *0xad3284(%rip)        # 1530d90 <_DYNAMIC+0x1670>
  a5db0c:	41 0f 5a 45 00       	cvtps2pd 0x0(%r13),%xmm0
  a5db11:	66 0f 28 c8          	movapd %xmm0,%xmm1
  a5db15:	66 0f 28 14 24       	movapd (%rsp),%xmm2
  a5db1a:	66 0f 5c ca          	subpd  %xmm2,%xmm1
  a5db1e:	66 0f 29 8c 24 f0 02 	movapd %xmm1,0x2f0(%rsp)
  a5db25:	00 00 
  a5db27:	41 0f 5a 4d 08       	cvtps2pd 0x8(%r13),%xmm1
  a5db2c:	66 0f 58 c8          	addpd  %xmm0,%xmm1
  a5db30:	66 0f 5c ca          	subpd  %xmm2,%xmm1
  a5db34:	66 0f 29 8c 24 00 03 	movapd %xmm1,0x300(%rsp)
  a5db3b:	00 00 
  a5db3d:	48 8d 94 24 f0 02 00 	lea    0x2f0(%rsp),%rdx
  a5db44:	00 
  a5db45:	48 8b bc 24 50 01 00 	mov    0x150(%rsp),%rdi
  a5db4c:	00 
  a5db4d:	be 53 00 00 00       	mov    $0x53,%esi
  a5db52:	ff 15 40 32 ad 00    	call   *0xad3240(%rip)        # 1530d98 <_DYNAMIC+0x1678>
  a5db58:	c6 84 24 10 01 00 00 	movb   $0x1,0x110(%rsp)
  a5db5f:	01 
  a5db60:	40 b5 01             	mov    $0x1,%bpl
  a5db63:	48 85 db             	test   %rbx,%rbx
  a5db66:	74 15                	je     a5db7d <<gpui::native::accessibility::text::Cohort>::append+0x4fd>
  a5db68:	49 8b 46 28          	mov    0x28(%r14),%rax
  a5db6c:	48 39 03             	cmp    %rax,(%rbx)
  a5db6f:	0f 96 c1             	setbe  %cl
  a5db72:	48 3b 43 08          	cmp    0x8(%rbx),%rax
  a5db76:	40 0f 92 c5          	setb   %bpl
  a5db7a:	40 20 cd             	and    %cl,%bpl
  a5db7d:	49 8b 36             	mov    (%r14),%rsi
  a5db80:	48 83 c6 10          	add    $0x10,%rsi
  a5db84:	48 8d bc 24 80 01 00 	lea    0x180(%rsp),%rdi
  a5db8b:	00 
  a5db8c:	48 89 b4 24 e0 02 00 	mov    %rsi,0x2e0(%rsp)
  a5db93:	00 
  a5db94:	ff 15 26 26 ad 00    	call   *0xad2626(%rip)        # 15301c0 <_DYNAMIC+0xaa0>
  a5db9a:	48 8d bc 24 28 03 00 	lea    0x328(%rsp),%rdi
  a5dba1:	00 
  a5dba2:	48 8d b4 24 80 01 00 	lea    0x180(%rsp),%rsi
  a5dba9:	00 
  a5dbaa:	ba a8 00 00 00       	mov    $0xa8,%edx
  a5dbaf:	ff 15 cb 1d ad 00    	call   *0xad1dcb(%rip)        # 152f980 <memcpy@GLIBC_2.14>
  a5dbb5:	48 c7 84 24 20 03 00 	movq   $0x0,0x320(%rsp)
  a5dbbc:	00 00 00 00 00 
  a5dbc1:	c6 84 24 18 03 00 00 	movb   $0xff,0x318(%rsp)
  a5dbc8:	ff 
  a5dbc9:	40 84 ed             	test   %bpl,%bpl
  a5dbcc:	0f 84 45 0f 00 00    	je     a5eb17 <<gpui::native::accessibility::text::Cohort>::append+0x1497>
  a5dbd2:	b2 ff                	mov    $0xff,%dl
  a5dbd4:	48 8d bc 24 80 01 00 	lea    0x180(%rsp),%rdi
  a5dbdb:	00 
  a5dbdc:	48 8b 1d bd 31 ad 00 	mov    0xad31bd(%rip),%rbx        # 1530da0 <_DYNAMIC+0x1680>
  a5dbe3:	31 ed                	xor    %ebp,%ebp
  a5dbe5:	48 8b 8c 24 f0 02 00 	mov    0x2f0(%rsp),%rcx
  a5dbec:	00 
  a5dbed:	f2 0f 10 84 24 f8 02 	movsd  0x2f8(%rsp),%xmm0
  a5dbf4:	00 00 
  a5dbf6:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  a5dbfd:	00 
  a5dbfe:	f2 0f 10 84 24 00 03 	movsd  0x300(%rsp),%xmm0
  a5dc05:	00 00 
  a5dc07:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  a5dc0e:	00 
  a5dc0f:	4c 8b bc 24 08 03 00 	mov    0x308(%rsp),%r15
  a5dc16:	00 
  a5dc17:	48 8b 84 24 10 03 00 	mov    0x310(%rsp),%rax
  a5dc1e:	00 
  a5dc1f:	48 89 04 24          	mov    %rax,(%rsp)
  a5dc23:	c6 84 24 18 03 00 00 	movb   $0xff,0x318(%rsp)
  a5dc2a:	ff 
  a5dc2b:	80 fa ff             	cmp    $0xff,%dl
  a5dc2e:	74 0d                	je     a5dc3d <<gpui::native::accessibility::text::Cohort>::append+0x5bd>
  a5dc30:	0f b6 c2             	movzbl %dl,%eax
  a5dc33:	83 f8 02             	cmp    $0x2,%eax
  a5dc36:	75 6d                	jne    a5dca5 <<gpui::native::accessibility::text::Cohort>::append+0x625>
  a5dc38:	e9 5d 0f 00 00       	jmp    a5eb9a <<gpui::native::accessibility::text::Cohort>::append+0x151a>
  a5dc3d:	48 8d b4 24 28 03 00 	lea    0x328(%rsp),%rsi
  a5dc44:	00 
  a5dc45:	e8 06 ef ff ff       	call   a5cb50 <<gpui_canvas::text::layout::TextGeometry>::runs::{closure#2}>
  a5dc4a:	0f b6 94 24 a0 01 00 	movzbl 0x1a0(%rsp),%edx
  a5dc51:	00 
  a5dc52:	80 fa 02             	cmp    $0x2,%dl
  a5dc55:	0f 84 3f 0f 00 00    	je     a5eb9a <<gpui::native::accessibility::text::Cohort>::append+0x151a>
  a5dc5b:	f2 0f 10 84 24 80 01 	movsd  0x180(%rsp),%xmm0
  a5dc62:	00 00 
  a5dc64:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  a5dc6b:	00 
  a5dc6c:	f2 0f 10 84 24 88 01 	movsd  0x188(%rsp),%xmm0
  a5dc73:	00 00 
  a5dc75:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  a5dc7c:	00 
  a5dc7d:	4c 8b bc 24 90 01 00 	mov    0x190(%rsp),%r15
  a5dc84:	00 
  a5dc85:	48 8b 84 24 98 01 00 	mov    0x198(%rsp),%rax
  a5dc8c:	00 
  a5dc8d:	48 89 04 24          	mov    %rax,(%rsp)
  a5dc91:	48 8b 8c 24 20 03 00 	mov    0x320(%rsp),%rcx
  a5dc98:	00 
  a5dc99:	48 8d 41 01          	lea    0x1(%rcx),%rax
  a5dc9d:	48 89 84 24 20 03 00 	mov    %rax,0x320(%rsp)
  a5dca4:	00 
  a5dca5:	88 94 24 40 02 00 00 	mov    %dl,0x240(%rsp)
  a5dcac:	49 8b 46 28          	mov    0x28(%r14),%rax
  a5dcb0:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  a5dcb7:	00 
  a5dcb8:	48 89 8c 24 30 02 00 	mov    %rcx,0x230(%rsp)
  a5dcbf:	00 
  a5dcc0:	48 8d 14 08          	lea    (%rax,%rcx,1),%rdx
  a5dcc4:	48 ff c2             	inc    %rdx
  a5dcc7:	48 8b bc 24 50 01 00 	mov    0x150(%rsp),%rdi
  a5dcce:	00 
  a5dccf:	31 f6                	xor    %esi,%esi
  a5dcd1:	48 89 94 24 d8 02 00 	mov    %rdx,0x2d8(%rsp)
  a5dcd8:	00 
  a5dcd9:	ff d3                	call   *%rbx
  a5dcdb:	4d 8b 65 28          	mov    0x28(%r13),%r12
  a5dcdf:	4d 85 e4             	test   %r12,%r12
  a5dce2:	0f 84 a3 11 00 00    	je     a5ee8b <<gpui::native::accessibility::text::Cohort>::append+0x180b>
  a5dce8:	48 89 ac 24 d0 02 00 	mov    %rbp,0x2d0(%rsp)
  a5dcef:	00 
  a5dcf0:	4c 89 bc 24 38 01 00 	mov    %r15,0x138(%rsp)
  a5dcf7:	00 
  a5dcf8:	49 8b 34 24          	mov    (%r12),%rsi
  a5dcfc:	48 d1 ee             	shr    $1,%rsi
  a5dcff:	49 83 c4 10          	add    $0x10,%r12
  a5dd03:	48 8b 04 24          	mov    (%rsp),%rax
  a5dd07:	48 89 c5             	mov    %rax,%rbp
  a5dd0a:	48 c1 ed 20          	shr    $0x20,%rbp
  a5dd0e:	41 89 c7             	mov    %eax,%r15d
  a5dd11:	39 e8                	cmp    %ebp,%eax
  a5dd13:	0f 87 43 12 00 00    	ja     a5ef5c <<gpui::native::accessibility::text::Cohort>::append+0x18dc>
  a5dd19:	f3 41 0f 10 45 30    	movss  0x30(%r13),%xmm0
  a5dd1f:	f3 0f 11 84 24 5c 01 	movss  %xmm0,0x15c(%rsp)
  a5dd26:	00 00 
  a5dd28:	83 3c 24 00          	cmpl   $0x0,(%rsp)
  a5dd2c:	74 17                	je     a5dd45 <<gpui::native::accessibility::text::Cohort>::append+0x6c5>
  a5dd2e:	4c 39 fe             	cmp    %r15,%rsi
  a5dd31:	76 0c                	jbe    a5dd3f <<gpui::native::accessibility::text::Cohort>::append+0x6bf>
  a5dd33:	43 80 3c 3c c0       	cmpb   $0xc0,(%r12,%r15,1)
  a5dd38:	7d 0b                	jge    a5dd45 <<gpui::native::accessibility::text::Cohort>::append+0x6c5>
  a5dd3a:	e9 1d 12 00 00       	jmp    a5ef5c <<gpui::native::accessibility::text::Cohort>::append+0x18dc>
  a5dd3f:	0f 85 17 12 00 00    	jne    a5ef5c <<gpui::native::accessibility::text::Cohort>::append+0x18dc>
  a5dd45:	48 85 ed             	test   %rbp,%rbp
  a5dd48:	74 17                	je     a5dd61 <<gpui::native::accessibility::text::Cohort>::append+0x6e1>
  a5dd4a:	48 39 ee             	cmp    %rbp,%rsi
  a5dd4d:	76 0c                	jbe    a5dd5b <<gpui::native::accessibility::text::Cohort>::append+0x6db>
  a5dd4f:	41 80 3c 2c c0       	cmpb   $0xc0,(%r12,%rbp,1)
  a5dd54:	7d 0b                	jge    a5dd61 <<gpui::native::accessibility::text::Cohort>::append+0x6e1>
  a5dd56:	e9 01 12 00 00       	jmp    a5ef5c <<gpui::native::accessibility::text::Cohort>::append+0x18dc>
  a5dd5b:	0f 85 fb 11 00 00    	jne    a5ef5c <<gpui::native::accessibility::text::Cohort>::append+0x18dc>
  a5dd61:	48 89 eb             	mov    %rbp,%rbx
  a5dd64:	48 8d 84 24 68 02 00 	lea    0x268(%rsp),%rax
  a5dd6b:	00 
  a5dd6c:	48 b9 57 57 57 57 57 	movabs $0x5757575757575757,%rcx
  a5dd73:	57 57 57 
  a5dd76:	48 89 48 4f          	mov    %rcx,0x4f(%rax)
  a5dd7a:	0f 28 05 7f f3 72 ff 	movaps -0x8d0c81(%rip),%xmm0        # 18d100 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a5dd81:	0f 11 40 40          	movups %xmm0,0x40(%rax)
  a5dd85:	0f 11 40 30          	movups %xmm0,0x30(%rax)
  a5dd89:	0f 11 40 20          	movups %xmm0,0x20(%rax)
  a5dd8d:	0f 11 40 10          	movups %xmm0,0x10(%rax)
  a5dd91:	0f 11 00             	movups %xmm0,(%rax)
  a5dd94:	c6 84 24 cc 02 00 00 	movb   $0x1,0x2cc(%rsp)
  a5dd9b:	01 
  a5dd9c:	48 c7 84 24 c0 02 00 	movq   $0x0,0x2c0(%rsp)
  a5dda3:	00 00 00 00 00 
  a5dda8:	c7 84 24 c8 02 00 00 	movl   $0x0,0x2c8(%rsp)
  a5ddaf:	00 00 00 00 
  a5ddb3:	48 c7 84 24 50 02 00 	movq   $0x0,0x250(%rsp)
  a5ddba:	00 00 00 00 00 
  a5ddbf:	48 c7 84 24 58 02 00 	movq   $0x8,0x258(%rsp)
  a5ddc6:	00 08 00 00 00 
  a5ddcb:	48 c7 84 24 60 02 00 	movq   $0x0,0x260(%rsp)
  a5ddd2:	00 00 00 00 00 
  a5ddd7:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  a5dddd:	4c 29 fb             	sub    %r15,%rbx
  a5dde0:	74 20                	je     a5de02 <<gpui::native::accessibility::text::Cohort>::append+0x782>
  a5dde2:	ff 15 78 1b ad 00    	call   *0xad1b78(%rip)        # 152f960 <_DYNAMIC+0x240>
  a5dde8:	be 01 00 00 00       	mov    $0x1,%esi
  a5dded:	48 89 df             	mov    %rbx,%rdi
  a5ddf0:	ff 15 72 1b ad 00    	call   *0xad1b72(%rip)        # 152f968 <_DYNAMIC+0x248>
  a5ddf6:	48 85 c0             	test   %rax,%rax
  a5ddf9:	0f 84 90 11 00 00    	je     a5ef8f <<gpui::native::accessibility::text::Cohort>::append+0x190f>
  a5ddff:	49 89 c5             	mov    %rax,%r13
  a5de02:	4d 01 e7             	add    %r12,%r15
  a5de05:	3b 2c 24             	cmp    (%rsp),%ebp
  a5de08:	74 0f                	je     a5de19 <<gpui::native::accessibility::text::Cohort>::append+0x799>
  a5de0a:	4c 89 ef             	mov    %r13,%rdi
  a5de0d:	4c 89 fe             	mov    %r15,%rsi
  a5de10:	48 89 da             	mov    %rbx,%rdx
  a5de13:	ff 15 67 1b ad 00    	call   *0xad1b67(%rip)        # 152f980 <memcpy@GLIBC_2.14>
  a5de19:	48 89 9c 24 88 01 00 	mov    %rbx,0x188(%rsp)
  a5de20:	00 
  a5de21:	4c 89 ac 24 90 01 00 	mov    %r13,0x190(%rsp)
  a5de28:	00 
  a5de29:	48 89 9c 24 98 01 00 	mov    %rbx,0x198(%rsp)
  a5de30:	00 
  a5de31:	c6 84 24 80 01 00 00 	movb   $0x3,0x180(%rsp)
  a5de38:	03 
  a5de39:	48 8d bc 24 50 02 00 	lea    0x250(%rsp),%rdi
  a5de40:	00 
  a5de41:	be 11 00 00 00       	mov    $0x11,%esi
  a5de46:	48 8d 94 24 80 01 00 	lea    0x180(%rsp),%rdx
  a5de4d:	00 
  a5de4e:	ff 15 3c 2f ad 00    	call   *0xad2f3c(%rip)        # 1530d90 <_DYNAMIC+0x1670>
  a5de54:	49 01 ec             	add    %rbp,%r12
  a5de57:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  a5de5e:	00 00 
  a5de60:	48 c7 44 24 48 08 00 	movq   $0x8,0x48(%rsp)
  a5de67:	00 00 
  a5de69:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  a5de70:	00 00 
  a5de72:	c7 44 24 60 ff ff ff 	movl   $0xffffffff,0x60(%rsp)
  a5de79:	ff 
  a5de7a:	4c 89 7c 24 68       	mov    %r15,0x68(%rsp)
  a5de7f:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  a5de84:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
  a5de8b:	00 00 
  a5de8d:	48 8d 05 5c 36 a6 00 	lea    0xa6365c(%rip),%rax        # 14c14f0 <anon.8df5206834877815e8786c895557e178.5.llvm.4810214434977047461+0xc0>
  a5de94:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  a5de9b:	00 
  a5de9c:	48 8d 05 dd ea ff ff 	lea    -0x1523(%rip),%rax        # a5c980 <icu_segmenter::rule_segmenter_v1::empty_handle_complex::<icu_segmenter::scaffold::Utf8>>
  a5dea3:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  a5deaa:	00 
  a5deab:	48 89 9c 24 90 00 00 	mov    %rbx,0x90(%rsp)
  a5deb2:	00 
  a5deb3:	48 c7 84 24 98 00 00 	movq   $0x0,0x98(%rsp)
  a5deba:	00 00 00 00 00 
  a5debf:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  a5dec6:	00 00 00 00 00 
  a5decb:	c6 84 24 d0 00 00 00 	movb   $0x0,0xd0(%rsp)
  a5ded2:	00 
  a5ded3:	4c 8d 7c 24 40       	lea    0x40(%rsp),%r15
  a5ded8:	4c 89 ff             	mov    %r15,%rdi
  a5dedb:	e8 d0 1e 00 00       	call   a5fdb0 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  a5dee0:	4c 8b ac 24 38 02 00 	mov    0x238(%rsp),%r13
  a5dee7:	00 
  a5dee8:	a8 01                	test   $0x1,%al
  a5deea:	b8 00 00 00 00       	mov    $0x0,%eax
  a5deef:	48 0f 44 d0          	cmove  %rax,%rdx
  a5def3:	48 89 94 24 60 01 00 	mov    %rdx,0x160(%rsp)
  a5defa:	00 
  a5defb:	ba 98 00 00 00       	mov    $0x98,%edx
  a5df00:	48 8d 9c 24 80 01 00 	lea    0x180(%rsp),%rbx
  a5df07:	00 
  a5df08:	48 89 df             	mov    %rbx,%rdi
  a5df0b:	4c 89 fe             	mov    %r15,%rsi
  a5df0e:	ff 15 6c 1a ad 00    	call   *0xad1a6c(%rip)        # 152f980 <memcpy@GLIBC_2.14>
  a5df14:	48 8d 84 24 60 01 00 	lea    0x160(%rsp),%rax
  a5df1b:	00 
  a5df1c:	48 89 84 24 18 02 00 	mov    %rax,0x218(%rsp)
  a5df23:	00 
  a5df24:	48 8d bc 24 50 02 00 	lea    0x250(%rsp),%rdi
  a5df2b:	00 
  a5df2c:	48 89 de             	mov    %rbx,%rsi
  a5df2f:	e8 3c 41 00 00       	call   a62070 <<accesskit::Node>::set_text_character_lengths::<core::iter::adapters::map::Map<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui::native::accessibility::text::text_run::{closure#0}>>>
  a5df34:	4c 8b 25 25 1a ad 00 	mov    0xad1a25(%rip),%r12        # 152f960 <_DYNAMIC+0x240>
  a5df3b:	84 c0                	test   %al,%al
  a5df3d:	0f 84 5a 0f 00 00    	je     a5ee9d <<gpui::native::accessibility::text::Cohort>::append+0x181d>
  a5df43:	f3 0f 10 84 24 5c 01 	movss  0x15c(%rsp),%xmm0
  a5df4a:	00 00 
  a5df4c:	0f 2e c0             	ucomiss %xmm0,%xmm0
  a5df4f:	0f 10 84 24 c0 02 00 	movups 0x2c0(%rsp),%xmm0
  a5df56:	00 
  a5df57:	0f 29 84 24 f0 01 00 	movaps %xmm0,0x1f0(%rsp)
  a5df5e:	00 
  a5df5f:	0f 10 84 24 b0 02 00 	movups 0x2b0(%rsp),%xmm0
  a5df66:	00 
  a5df67:	0f 29 84 24 e0 01 00 	movaps %xmm0,0x1e0(%rsp)
  a5df6e:	00 
  a5df6f:	0f 10 84 24 a0 02 00 	movups 0x2a0(%rsp),%xmm0
  a5df76:	00 
  a5df77:	0f 29 84 24 d0 01 00 	movaps %xmm0,0x1d0(%rsp)
  a5df7e:	00 
  a5df7f:	0f 10 84 24 90 02 00 	movups 0x290(%rsp),%xmm0
  a5df86:	00 
  a5df87:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  a5df8e:	00 
  a5df8f:	0f 10 84 24 50 02 00 	movups 0x250(%rsp),%xmm0
  a5df96:	00 
  a5df97:	0f 10 8c 24 60 02 00 	movups 0x260(%rsp),%xmm1
  a5df9e:	00 
  a5df9f:	66 0f 10 94 24 70 02 	movupd 0x270(%rsp),%xmm2
  a5dfa6:	00 00 
  a5dfa8:	66 0f 10 9c 24 80 02 	movupd 0x280(%rsp),%xmm3
  a5dfaf:	00 00 
  a5dfb1:	66 0f 29 9c 24 b0 01 	movapd %xmm3,0x1b0(%rsp)
  a5dfb8:	00 00 
  a5dfba:	66 0f 29 94 24 a0 01 	movapd %xmm2,0x1a0(%rsp)
  a5dfc1:	00 00 
  a5dfc3:	0f 29 8c 24 90 01 00 	movaps %xmm1,0x190(%rsp)
  a5dfca:	00 
  a5dfcb:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  a5dfd2:	00 
  a5dfd3:	0f 8a bf 0a 00 00    	jp     a5ea98 <<gpui::native::accessibility::text::Cohort>::append+0x1418>
  a5dfd9:	0f 5a 84 24 00 01 00 	cvtps2pd 0x100(%rsp),%xmm0
  a5dfe0:	00 
  a5dfe1:	0f 5a 8c 24 f0 00 00 	cvtps2pd 0xf0(%rsp),%xmm1
  a5dfe8:	00 
  a5dfe9:	66 0f 29 44 24 40    	movapd %xmm0,0x40(%rsp)
  a5dfef:	66 0f 58 c8          	addpd  %xmm0,%xmm1
  a5dff3:	66 0f 29 4c 24 50    	movapd %xmm1,0x50(%rsp)
  a5dff9:	48 89 df             	mov    %rbx,%rdi
  a5dffc:	be 53 00 00 00       	mov    $0x53,%esi
  a5e001:	4c 89 fa             	mov    %r15,%rdx
  a5e004:	ff 15 8e 2d ad 00    	call   *0xad2d8e(%rip)        # 1530d98 <_DYNAMIC+0x1678>
  a5e00a:	0f b6 84 24 40 02 00 	movzbl 0x240(%rsp),%eax
  a5e011:	00 
  a5e012:	88 44 24 41          	mov    %al,0x41(%rsp)
  a5e016:	c6 44 24 40 10       	movb   $0x10,0x40(%rsp)
  a5e01b:	48 89 df             	mov    %rbx,%rdi
  a5e01e:	be 49 00 00 00       	mov    $0x49,%esi
  a5e023:	4c 89 fa             	mov    %r15,%rdx
  a5e026:	ff 15 64 2d ad 00    	call   *0xad2d64(%rip)        # 1530d90 <_DYNAMIC+0x1670>
  a5e02c:	0f b6 bc 24 d8 01 00 	movzbl 0x1d8(%rsp),%edi
  a5e033:	00 
  a5e034:	48 8d 05 5d 18 74 ff 	lea    -0x8be7a3(%rip),%rax        # 19f898 <anon.f1514e157150765e701d959c660d2214.14.llvm.14306826168292286542+0x29ac>
  a5e03b:	48 83 ff 57          	cmp    $0x57,%rdi
  a5e03f:	74 21                	je     a5e062 <<gpui::native::accessibility::text::Cohort>::append+0x9e2>
  a5e041:	48 8b b4 24 90 01 00 	mov    0x190(%rsp),%rsi
  a5e048:	00 
  a5e049:	48 39 fe             	cmp    %rdi,%rsi
  a5e04c:	0f 86 4d 0f 00 00    	jbe    a5ef9f <<gpui::native::accessibility::text::Cohort>::append+0x191f>
  a5e052:	48 8b 84 24 88 01 00 	mov    0x188(%rsp),%rax
  a5e059:	00 
  a5e05a:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  a5e05e:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  a5e062:	0f b6 08             	movzbl (%rax),%ecx
  a5e065:	83 f9 09             	cmp    $0x9,%ecx
  a5e068:	74 22                	je     a5e08c <<gpui::native::accessibility::text::Cohort>::append+0xa0c>
  a5e06a:	83 f9 0a             	cmp    $0xa,%ecx
  a5e06d:	48 ba fc ff ff ff ff 	movabs $0x7ffffffffffffffc,%rdx
  a5e074:	ff ff 7f 
  a5e077:	75 23                	jne    a5e09c <<gpui::native::accessibility::text::Cohort>::append+0xa1c>
  a5e079:	48 8b 48 18          	mov    0x18(%rax),%rcx
  a5e07d:	48 3b 48 10          	cmp    0x10(%rax),%rcx
  a5e081:	be 00 00 00 00       	mov    $0x0,%esi
  a5e086:	48 0f 46 f1          	cmovbe %rcx,%rsi
  a5e08a:	eb 12                	jmp    a5e09e <<gpui::native::accessibility::text::Cohort>::append+0xa1e>
  a5e08c:	48 8b 70 18          	mov    0x18(%rax),%rsi
  a5e090:	48 ba fc ff ff ff ff 	movabs $0x7ffffffffffffffc,%rdx
  a5e097:	ff ff 7f 
  a5e09a:	eb 02                	jmp    a5e09e <<gpui::native::accessibility::text::Cohort>::append+0xa1e>
  a5e09c:	31 f6                	xor    %esi,%esi
  a5e09e:	48 89 b4 24 e8 02 00 	mov    %rsi,0x2e8(%rsp)
  a5e0a5:	00 
  a5e0a6:	48 8d 1c b5 00 00 00 	lea    0x0(,%rsi,4),%rbx
  a5e0ad:	00 
  a5e0ae:	48 89 f0             	mov    %rsi,%rax
  a5e0b1:	48 c1 e8 3e          	shr    $0x3e,%rax
  a5e0b5:	0f 95 c0             	setne  %al
  a5e0b8:	48 39 d3             	cmp    %rdx,%rbx
  a5e0bb:	0f 97 c1             	seta   %cl
  a5e0be:	08 c1                	or     %al,%cl
  a5e0c0:	0f 85 8d 0c 00 00    	jne    a5ed53 <<gpui::native::accessibility::text::Cohort>::append+0x16d3>
  a5e0c6:	48 85 db             	test   %rbx,%rbx
  a5e0c9:	74 5d                	je     a5e128 <<gpui::native::accessibility::text::Cohort>::append+0xaa8>
  a5e0cb:	4c 89 e0             	mov    %r12,%rax
  a5e0ce:	49 89 f4             	mov    %rsi,%r12
  a5e0d1:	ff d0                	call   *%rax
  a5e0d3:	be 04 00 00 00       	mov    $0x4,%esi
  a5e0d8:	48 89 df             	mov    %rbx,%rdi
  a5e0db:	4c 8b 3d 86 18 ad 00 	mov    0xad1886(%rip),%r15        # 152f968 <_DYNAMIC+0x248>
  a5e0e2:	41 ff d7             	call   *%r15
  a5e0e5:	48 85 c0             	test   %rax,%rax
  a5e0e8:	0f 84 d0 0e 00 00    	je     a5efbe <<gpui::native::accessibility::text::Cohort>::append+0x193e>
  a5e0ee:	4c 89 64 24 18       	mov    %r12,0x18(%rsp)
  a5e0f3:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  a5e0fa:	00 
  a5e0fb:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  a5e100:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  a5e107:	00 00 
  a5e109:	ff 15 51 18 ad 00    	call   *0xad1851(%rip)        # 152f960 <_DYNAMIC+0x240>
  a5e10f:	be 04 00 00 00       	mov    $0x4,%esi
  a5e114:	48 89 df             	mov    %rbx,%rdi
  a5e117:	41 ff d7             	call   *%r15
  a5e11a:	48 85 c0             	test   %rax,%rax
  a5e11d:	0f 84 ad 0e 00 00    	je     a5efd0 <<gpui::native::accessibility::text::Cohort>::append+0x1950>
  a5e123:	4c 89 e6             	mov    %r12,%rsi
  a5e126:	eb 28                	jmp    a5e150 <<gpui::native::accessibility::text::Cohort>::append+0xad0>
  a5e128:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  a5e12f:	00 00 
  a5e131:	48 c7 44 24 20 04 00 	movq   $0x4,0x20(%rsp)
  a5e138:	00 00 
  a5e13a:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  a5e141:	00 00 
  a5e143:	b8 04 00 00 00       	mov    $0x4,%eax
  a5e148:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  a5e14f:	00 
  a5e150:	49 89 f7             	mov    %rsi,%r15
  a5e153:	48 89 b4 24 d8 00 00 	mov    %rsi,0xd8(%rsp)
  a5e15a:	00 
  a5e15b:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  a5e162:	00 
  a5e163:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  a5e16a:	00 00 00 00 00 
  a5e16f:	41 b4 01             	mov    $0x1,%r12b
  a5e172:	48 8d bc 24 50 02 00 	lea    0x250(%rsp),%rdi
  a5e179:	00 
  a5e17a:	48 8b b4 24 e0 02 00 	mov    0x2e0(%rsp),%rsi
  a5e181:	00 
  a5e182:	48 8b 14 24          	mov    (%rsp),%rdx
  a5e186:	89 e9                	mov    %ebp,%ecx
  a5e188:	ff 15 1a 2c ad 00    	call   *0xad2c1a(%rip)        # 1530da8 <_DYNAMIC+0x1688>
  a5e18e:	48 8d 9c 24 80 01 00 	lea    0x180(%rsp),%rbx
  a5e195:	00 
  a5e196:	48 8d ac 24 60 01 00 	lea    0x160(%rsp),%rbp
  a5e19d:	00 
  a5e19e:	48 83 bc 24 50 02 00 	cmpq   $0x0,0x250(%rsp)
  a5e1a5:	00 00 
  a5e1a7:	0f b6 8c 24 40 02 00 	movzbl 0x240(%rsp),%ecx
  a5e1ae:	00 
  a5e1af:	0f 84 18 0d 00 00    	je     a5eecd <<gpui::native::accessibility::text::Cohort>::append+0x184d>
  a5e1b5:	48 8b 84 24 90 02 00 	mov    0x290(%rsp),%rax
  a5e1bc:	00 
  a5e1bd:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  a5e1c4:	00 
  a5e1c5:	0f 10 84 24 50 02 00 	movups 0x250(%rsp),%xmm0
  a5e1cc:	00 
  a5e1cd:	66 0f 10 8c 24 60 02 	movupd 0x260(%rsp),%xmm1
  a5e1d4:	00 00 
  a5e1d6:	66 0f 10 94 24 70 02 	movupd 0x270(%rsp),%xmm2
  a5e1dd:	00 00 
  a5e1df:	66 0f 10 9c 24 80 02 	movupd 0x280(%rsp),%xmm3
  a5e1e6:	00 00 
  a5e1e8:	66 0f 29 5c 24 70    	movapd %xmm3,0x70(%rsp)
  a5e1ee:	66 0f 29 54 24 60    	movapd %xmm2,0x60(%rsp)
  a5e1f4:	66 0f 29 4c 24 50    	movapd %xmm1,0x50(%rsp)
  a5e1fa:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  a5e1ff:	f6 c1 01             	test   $0x1,%cl
  a5e202:	4c 8d a4 24 50 02 00 	lea    0x250(%rsp),%r12
  a5e209:	00 
  a5e20a:	48 8d 44 24 78       	lea    0x78(%rsp),%rax
  a5e20f:	0f 84 cd 02 00 00    	je     a5e4e2 <<gpui::native::accessibility::text::Cohort>::append+0xe62>
  a5e215:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  a5e21a:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  a5e21f:	48 85 d2             	test   %rdx,%rdx
  a5e222:	0f 84 56 05 00 00    	je     a5e77e <<gpui::native::accessibility::text::Cohort>::append+0x10fe>
  a5e228:	0f 28 84 24 f0 00 00 	movaps 0xf0(%rsp),%xmm0
  a5e22f:	00 
  a5e230:	f3 0f 58 84 24 00 01 	addss  0x100(%rsp),%xmm0
  a5e237:	00 00 
  a5e239:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  a5e240:	00 
  a5e241:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a5e248:	0f 1f 84 00 00 00 00 
  a5e24f:	00 
  a5e250:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  a5e255:	b9 01 00 00 00       	mov    $0x1,%ecx
  a5e25a:	48 83 fa 01          	cmp    $0x1,%rdx
  a5e25e:	74 29                	je     a5e289 <<gpui::native::accessibility::text::Cohort>::append+0xc09>
  a5e260:	48 8d 70 28          	lea    0x28(%rax),%rsi
  a5e264:	48 8d 7a 01          	lea    0x1(%rdx),%rdi
  a5e268:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a5e26f:	00 
  a5e270:	44 8b 46 e8          	mov    -0x18(%rsi),%r8d
  a5e274:	44 3b 06             	cmp    (%rsi),%r8d
  a5e277:	75 10                	jne    a5e289 <<gpui::native::accessibility::text::Cohort>::append+0xc09>
  a5e279:	48 ff c1             	inc    %rcx
  a5e27c:	48 83 c6 18          	add    $0x18,%rsi
  a5e280:	48 ff cf             	dec    %rdi
  a5e283:	48 83 ff 02          	cmp    $0x2,%rdi
  a5e287:	77 e7                	ja     a5e270 <<gpui::native::accessibility::text::Cohort>::append+0xbf0>
  a5e289:	48 29 ca             	sub    %rcx,%rdx
  a5e28c:	0f 82 a0 0b 00 00    	jb     a5ee32 <<gpui::native::accessibility::text::Cohort>::append+0x17b2>
  a5e292:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  a5e296:	48 8d 34 f0          	lea    (%rax,%rsi,8),%rsi
  a5e29a:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
  a5e29f:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  a5e2a4:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  a5e2a9:	48 85 ff             	test   %rdi,%rdi
  a5e2ac:	0f 85 70 01 00 00    	jne    a5e422 <<gpui::native::accessibility::text::Cohort>::append+0xda2>
  a5e2b2:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  a5e2b7:	48 85 d2             	test   %rdx,%rdx
  a5e2ba:	0f 84 be 04 00 00    	je     a5e77e <<gpui::native::accessibility::text::Cohort>::append+0x10fe>
  a5e2c0:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  a5e2c5:	bf 01 00 00 00       	mov    $0x1,%edi
  a5e2ca:	48 83 fa 01          	cmp    $0x1,%rdx
  a5e2ce:	74 29                	je     a5e2f9 <<gpui::native::accessibility::text::Cohort>::append+0xc79>
  a5e2d0:	4c 8d 46 28          	lea    0x28(%rsi),%r8
  a5e2d4:	4c 8d 4a 01          	lea    0x1(%rdx),%r9
  a5e2d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a5e2df:	00 
  a5e2e0:	45 8b 50 e8          	mov    -0x18(%r8),%r10d
  a5e2e4:	45 3b 10             	cmp    (%r8),%r10d
  a5e2e7:	75 10                	jne    a5e2f9 <<gpui::native::accessibility::text::Cohort>::append+0xc79>
  a5e2e9:	48 ff c7             	inc    %rdi
  a5e2ec:	49 83 c0 18          	add    $0x18,%r8
  a5e2f0:	49 ff c9             	dec    %r9
  a5e2f3:	49 83 f9 02          	cmp    $0x2,%r9
  a5e2f7:	77 e7                	ja     a5e2e0 <<gpui::native::accessibility::text::Cohort>::append+0xc60>
  a5e2f9:	48 29 fa             	sub    %rdi,%rdx
  a5e2fc:	0f 82 30 0b 00 00    	jb     a5ee32 <<gpui::native::accessibility::text::Cohort>::append+0x17b2>
  a5e302:	4c 8d 04 7f          	lea    (%rdi,%rdi,2),%r8
  a5e306:	4e 8d 04 c6          	lea    (%rsi,%r8,8),%r8
  a5e30a:	4c 89 44 24 50       	mov    %r8,0x50(%rsp)
  a5e30f:	48 89 54 24 58       	mov    %rdx,0x58(%rsp)
  a5e314:	48 89 84 24 60 01 00 	mov    %rax,0x160(%rsp)
  a5e31b:	00 
  a5e31c:	48 89 8c 24 68 01 00 	mov    %rcx,0x168(%rsp)
  a5e323:	00 
  a5e324:	48 89 b4 24 70 01 00 	mov    %rsi,0x170(%rsp)
  a5e32b:	00 
  a5e32c:	48 89 bc 24 78 01 00 	mov    %rdi,0x178(%rsp)
  a5e333:	00 
  a5e334:	4c 89 e7             	mov    %r12,%rdi
  a5e337:	48 8d 74 24 38       	lea    0x38(%rsp),%rsi
  a5e33c:	48 89 ea             	mov    %rbp,%rdx
  a5e33f:	e8 4c b9 00 00       	call   a69c90 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut>
  a5e344:	80 bc 24 54 02 00 00 	cmpb   $0x2,0x254(%rsp)
  a5e34b:	02 
  a5e34c:	75 13                	jne    a5e361 <<gpui::native::accessibility::text::Cohort>::append+0xce1>
  a5e34e:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  a5e353:	48 85 d2             	test   %rdx,%rdx
  a5e356:	0f 85 f4 fe ff ff    	jne    a5e250 <<gpui::native::accessibility::text::Cohort>::append+0xbd0>
  a5e35c:	e9 1d 04 00 00       	jmp    a5e77e <<gpui::native::accessibility::text::Cohort>::append+0x10fe>
  a5e361:	0f 28 84 24 f0 00 00 	movaps 0xf0(%rsp),%xmm0
  a5e368:	00 
  a5e369:	f3 0f 5c 84 24 60 02 	subss  0x260(%rsp),%xmm0
  a5e370:	00 00 
  a5e372:	f3 0f 11 84 24 00 01 	movss  %xmm0,0x100(%rsp)
  a5e379:	00 00 
  a5e37b:	f3 0f 10 84 24 68 02 	movss  0x268(%rsp),%xmm0
  a5e382:	00 00 
  a5e384:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  a5e389:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  a5e38e:	48 3b 5c 24 18       	cmp    0x18(%rsp),%rbx
  a5e393:	75 0b                	jne    a5e3a0 <<gpui::native::accessibility::text::Cohort>::append+0xd20>
  a5e395:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
  a5e39a:	ff 15 10 2a ad 00    	call   *0xad2a10(%rip)        # 1530db0 <_DYNAMIC+0x1690>
  a5e3a0:	f3 0f 10 84 24 00 01 	movss  0x100(%rsp),%xmm0
  a5e3a7:	00 00 
  a5e3a9:	f3 0f 5c 04 24       	subss  (%rsp),%xmm0
  a5e3ae:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  a5e3b3:	f3 0f 11 04 98       	movss  %xmm0,(%rax,%rbx,4)
  a5e3b8:	48 ff c3             	inc    %rbx
  a5e3bb:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
  a5e3c0:	48 8b 9c 24 e8 00 00 	mov    0xe8(%rsp),%rbx
  a5e3c7:	00 
  a5e3c8:	48 3b 9c 24 d8 00 00 	cmp    0xd8(%rsp),%rbx
  a5e3cf:	00 
  a5e3d0:	75 0e                	jne    a5e3e0 <<gpui::native::accessibility::text::Cohort>::append+0xd60>
  a5e3d2:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a5e3d9:	00 
  a5e3da:	ff 15 d0 29 ad 00    	call   *0xad29d0(%rip)        # 1530db0 <_DYNAMIC+0x1690>
  a5e3e0:	48 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%rax
  a5e3e7:	00 
  a5e3e8:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  a5e3ed:	f3 0f 11 04 98       	movss  %xmm0,(%rax,%rbx,4)
  a5e3f2:	48 ff c3             	inc    %rbx
  a5e3f5:	48 89 9c 24 e8 00 00 	mov    %rbx,0xe8(%rsp)
  a5e3fc:	00 
  a5e3fd:	48 8d 44 24 78       	lea    0x78(%rsp),%rax
  a5e402:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  a5e407:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  a5e40c:	48 85 d2             	test   %rdx,%rdx
  a5e40f:	48 8d 9c 24 80 01 00 	lea    0x180(%rsp),%rbx
  a5e416:	00 
  a5e417:	0f 85 33 fe ff ff    	jne    a5e250 <<gpui::native::accessibility::text::Cohort>::append+0xbd0>
  a5e41d:	e9 5c 03 00 00       	jmp    a5e77e <<gpui::native::accessibility::text::Cohort>::append+0x10fe>
  a5e422:	48 c7 44 24 60 00 00 	movq   $0x0,0x60(%rsp)
  a5e429:	00 00 
  a5e42b:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  a5e430:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  a5e435:	49 89 d0             	mov    %rdx,%r8
  a5e438:	49 89 f1             	mov    %rsi,%r9
  a5e43b:	49 89 d2             	mov    %rdx,%r10
  a5e43e:	48 83 fa 01          	cmp    $0x1,%rdx
  a5e442:	74 30                	je     a5e474 <<gpui::native::accessibility::text::Cohort>::append+0xdf4>
  a5e444:	4d 85 c0             	test   %r8,%r8
  a5e447:	0f 84 31 03 00 00    	je     a5e77e <<gpui::native::accessibility::text::Cohort>::append+0x10fe>
  a5e44d:	49 8d 51 28          	lea    0x28(%r9),%rdx
  a5e451:	49 8d 70 01          	lea    0x1(%r8),%rsi
  a5e455:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  a5e45b:	44 8b 5a e8          	mov    -0x18(%rdx),%r11d
  a5e45f:	44 3b 1a             	cmp    (%rdx),%r11d
  a5e462:	75 10                	jne    a5e474 <<gpui::native::accessibility::text::Cohort>::append+0xdf4>
  a5e464:	49 ff c2             	inc    %r10
  a5e467:	48 83 c2 18          	add    $0x18,%rdx
  a5e46b:	48 ff ce             	dec    %rsi
  a5e46e:	48 83 fe 02          	cmp    $0x2,%rsi
  a5e472:	77 e7                	ja     a5e45b <<gpui::native::accessibility::text::Cohort>::append+0xddb>
  a5e474:	4c 89 c2             	mov    %r8,%rdx
  a5e477:	4c 29 d2             	sub    %r10,%rdx
  a5e47a:	0f 82 b2 09 00 00    	jb     a5ee32 <<gpui::native::accessibility::text::Cohort>::append+0x17b2>
  a5e480:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  a5e484:	4b 8d 34 d9          	lea    (%r9,%r11,8),%rsi
  a5e488:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
  a5e48d:	48 89 54 24 58       	mov    %rdx,0x58(%rsp)
  a5e492:	48 ff cf             	dec    %rdi
  a5e495:	75 9e                	jne    a5e435 <<gpui::native::accessibility::text::Cohort>::append+0xdb5>
  a5e497:	48 89 d7             	mov    %rdx,%rdi
  a5e49a:	48 83 fa 01          	cmp    $0x1,%rdx
  a5e49e:	0f 84 55 fe ff ff    	je     a5e2f9 <<gpui::native::accessibility::text::Cohort>::append+0xc79>
  a5e4a4:	48 85 d2             	test   %rdx,%rdx
  a5e4a7:	0f 84 d1 02 00 00    	je     a5e77e <<gpui::native::accessibility::text::Cohort>::append+0x10fe>
  a5e4ad:	4f 8d 0c d9          	lea    (%r9,%r11,8),%r9
  a5e4b1:	49 83 c1 28          	add    $0x28,%r9
  a5e4b5:	4d 29 d0             	sub    %r10,%r8
  a5e4b8:	49 ff c0             	inc    %r8
  a5e4bb:	bf 01 00 00 00       	mov    $0x1,%edi
  a5e4c0:	45 8b 51 e8          	mov    -0x18(%r9),%r10d
  a5e4c4:	45 3b 11             	cmp    (%r9),%r10d
  a5e4c7:	0f 85 2c fe ff ff    	jne    a5e2f9 <<gpui::native::accessibility::text::Cohort>::append+0xc79>
  a5e4cd:	48 ff c7             	inc    %rdi
  a5e4d0:	49 83 c1 18          	add    $0x18,%r9
  a5e4d4:	49 ff c8             	dec    %r8
  a5e4d7:	49 83 f8 02          	cmp    $0x2,%r8
  a5e4db:	77 e3                	ja     a5e4c0 <<gpui::native::accessibility::text::Cohort>::append+0xe40>
  a5e4dd:	e9 17 fe ff ff       	jmp    a5e2f9 <<gpui::native::accessibility::text::Cohort>::append+0xc79>
  a5e4e2:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  a5e4e7:	e9 84 02 00 00       	jmp    a5e770 <<gpui::native::accessibility::text::Cohort>::append+0x10f0>
  a5e4ec:	0f 1f 40 00          	nopl   0x0(%rax)
  a5e4f0:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  a5e4f5:	b9 01 00 00 00       	mov    $0x1,%ecx
  a5e4fa:	48 83 fa 01          	cmp    $0x1,%rdx
  a5e4fe:	74 29                	je     a5e529 <<gpui::native::accessibility::text::Cohort>::append+0xea9>
  a5e500:	48 8d 70 28          	lea    0x28(%rax),%rsi
  a5e504:	48 8d 7a 01          	lea    0x1(%rdx),%rdi
  a5e508:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a5e50f:	00 
  a5e510:	44 8b 46 e8          	mov    -0x18(%rsi),%r8d
  a5e514:	44 3b 06             	cmp    (%rsi),%r8d
  a5e517:	75 10                	jne    a5e529 <<gpui::native::accessibility::text::Cohort>::append+0xea9>
  a5e519:	48 ff c1             	inc    %rcx
  a5e51c:	48 83 c6 18          	add    $0x18,%rsi
  a5e520:	48 ff cf             	dec    %rdi
  a5e523:	48 83 ff 02          	cmp    $0x2,%rdi
  a5e527:	77 e7                	ja     a5e510 <<gpui::native::accessibility::text::Cohort>::append+0xe90>
  a5e529:	48 29 ca             	sub    %rcx,%rdx
  a5e52c:	0f 82 1e 09 00 00    	jb     a5ee50 <<gpui::native::accessibility::text::Cohort>::append+0x17d0>
  a5e532:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  a5e536:	48 8d 34 f0          	lea    (%rax,%rsi,8),%rsi
  a5e53a:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
  a5e53f:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  a5e544:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  a5e549:	48 85 ff             	test   %rdi,%rdi
  a5e54c:	0f 85 5d 01 00 00    	jne    a5e6af <<gpui::native::accessibility::text::Cohort>::append+0x102f>
  a5e552:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  a5e557:	48 85 d2             	test   %rdx,%rdx
  a5e55a:	0f 84 1e 02 00 00    	je     a5e77e <<gpui::native::accessibility::text::Cohort>::append+0x10fe>
  a5e560:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  a5e565:	bf 01 00 00 00       	mov    $0x1,%edi
  a5e56a:	48 83 fa 01          	cmp    $0x1,%rdx
  a5e56e:	74 29                	je     a5e599 <<gpui::native::accessibility::text::Cohort>::append+0xf19>
  a5e570:	4c 8d 46 28          	lea    0x28(%rsi),%r8
  a5e574:	4c 8d 4a 01          	lea    0x1(%rdx),%r9
  a5e578:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a5e57f:	00 
  a5e580:	45 8b 50 e8          	mov    -0x18(%r8),%r10d
  a5e584:	45 3b 10             	cmp    (%r8),%r10d
  a5e587:	75 10                	jne    a5e599 <<gpui::native::accessibility::text::Cohort>::append+0xf19>
  a5e589:	48 ff c7             	inc    %rdi
  a5e58c:	49 83 c0 18          	add    $0x18,%r8
  a5e590:	49 ff c9             	dec    %r9
  a5e593:	49 83 f9 02          	cmp    $0x2,%r9
  a5e597:	77 e7                	ja     a5e580 <<gpui::native::accessibility::text::Cohort>::append+0xf00>
  a5e599:	48 29 fa             	sub    %rdi,%rdx
  a5e59c:	0f 82 ae 08 00 00    	jb     a5ee50 <<gpui::native::accessibility::text::Cohort>::append+0x17d0>
  a5e5a2:	4c 8d 04 7f          	lea    (%rdi,%rdi,2),%r8
  a5e5a6:	4e 8d 04 c6          	lea    (%rsi,%r8,8),%r8
  a5e5aa:	4c 89 44 24 50       	mov    %r8,0x50(%rsp)
  a5e5af:	48 89 54 24 58       	mov    %rdx,0x58(%rsp)
  a5e5b4:	48 89 84 24 60 01 00 	mov    %rax,0x160(%rsp)
  a5e5bb:	00 
  a5e5bc:	48 89 8c 24 68 01 00 	mov    %rcx,0x168(%rsp)
  a5e5c3:	00 
  a5e5c4:	48 89 b4 24 70 01 00 	mov    %rsi,0x170(%rsp)
  a5e5cb:	00 
  a5e5cc:	48 89 bc 24 78 01 00 	mov    %rdi,0x178(%rsp)
  a5e5d3:	00 
  a5e5d4:	4c 89 e7             	mov    %r12,%rdi
  a5e5d7:	48 8d 74 24 38       	lea    0x38(%rsp),%rsi
  a5e5dc:	48 89 ea             	mov    %rbp,%rdx
  a5e5df:	e8 ac b6 00 00       	call   a69c90 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut>
  a5e5e4:	80 bc 24 54 02 00 00 	cmpb   $0x2,0x254(%rsp)
  a5e5eb:	02 
  a5e5ec:	0f 84 7e 01 00 00    	je     a5e770 <<gpui::native::accessibility::text::Cohort>::append+0x10f0>
  a5e5f2:	f3 0f 10 84 24 60 02 	movss  0x260(%rsp),%xmm0
  a5e5f9:	00 00 
  a5e5fb:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  a5e600:	f3 0f 10 84 24 68 02 	movss  0x268(%rsp),%xmm0
  a5e607:	00 00 
  a5e609:	f3 0f 11 84 24 f0 00 	movss  %xmm0,0xf0(%rsp)
  a5e610:	00 00 
  a5e612:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  a5e617:	48 3b 5c 24 18       	cmp    0x18(%rsp),%rbx
  a5e61c:	75 0b                	jne    a5e629 <<gpui::native::accessibility::text::Cohort>::append+0xfa9>
  a5e61e:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
  a5e623:	ff 15 87 27 ad 00    	call   *0xad2787(%rip)        # 1530db0 <_DYNAMIC+0x1690>
  a5e629:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  a5e62e:	f3 0f 5c 84 24 00 01 	subss  0x100(%rsp),%xmm0
  a5e635:	00 00 
  a5e637:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  a5e63c:	f3 0f 11 04 98       	movss  %xmm0,(%rax,%rbx,4)
  a5e641:	48 ff c3             	inc    %rbx
  a5e644:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
  a5e649:	48 8b 9c 24 e8 00 00 	mov    0xe8(%rsp),%rbx
  a5e650:	00 
  a5e651:	48 3b 9c 24 d8 00 00 	cmp    0xd8(%rsp),%rbx
  a5e658:	00 
  a5e659:	75 0e                	jne    a5e669 <<gpui::native::accessibility::text::Cohort>::append+0xfe9>
  a5e65b:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a5e662:	00 
  a5e663:	ff 15 47 27 ad 00    	call   *0xad2747(%rip)        # 1530db0 <_DYNAMIC+0x1690>
  a5e669:	48 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%rax
  a5e670:	00 
  a5e671:	f3 0f 10 84 24 f0 00 	movss  0xf0(%rsp),%xmm0
  a5e678:	00 00 
  a5e67a:	f3 0f 11 04 98       	movss  %xmm0,(%rax,%rbx,4)
  a5e67f:	48 ff c3             	inc    %rbx
  a5e682:	48 89 9c 24 e8 00 00 	mov    %rbx,0xe8(%rsp)
  a5e689:	00 
  a5e68a:	48 8d 44 24 78       	lea    0x78(%rsp),%rax
  a5e68f:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  a5e694:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  a5e699:	48 85 d2             	test   %rdx,%rdx
  a5e69c:	48 8d 9c 24 80 01 00 	lea    0x180(%rsp),%rbx
  a5e6a3:	00 
  a5e6a4:	0f 85 46 fe ff ff    	jne    a5e4f0 <<gpui::native::accessibility::text::Cohort>::append+0xe70>
  a5e6aa:	e9 cf 00 00 00       	jmp    a5e77e <<gpui::native::accessibility::text::Cohort>::append+0x10fe>
  a5e6af:	48 c7 44 24 60 00 00 	movq   $0x0,0x60(%rsp)
  a5e6b6:	00 00 
  a5e6b8:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  a5e6bd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  a5e6c2:	49 89 d0             	mov    %rdx,%r8
  a5e6c5:	49 89 f1             	mov    %rsi,%r9
  a5e6c8:	49 89 d2             	mov    %rdx,%r10
  a5e6cb:	48 83 fa 01          	cmp    $0x1,%rdx
  a5e6cf:	74 30                	je     a5e701 <<gpui::native::accessibility::text::Cohort>::append+0x1081>
  a5e6d1:	4d 85 c0             	test   %r8,%r8
  a5e6d4:	0f 84 a4 00 00 00    	je     a5e77e <<gpui::native::accessibility::text::Cohort>::append+0x10fe>
  a5e6da:	49 8d 51 28          	lea    0x28(%r9),%rdx
  a5e6de:	49 8d 70 01          	lea    0x1(%r8),%rsi
  a5e6e2:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  a5e6e8:	44 8b 5a e8          	mov    -0x18(%rdx),%r11d
  a5e6ec:	44 3b 1a             	cmp    (%rdx),%r11d
  a5e6ef:	75 10                	jne    a5e701 <<gpui::native::accessibility::text::Cohort>::append+0x1081>
  a5e6f1:	49 ff c2             	inc    %r10
  a5e6f4:	48 83 c2 18          	add    $0x18,%rdx
  a5e6f8:	48 ff ce             	dec    %rsi
  a5e6fb:	48 83 fe 02          	cmp    $0x2,%rsi
  a5e6ff:	77 e7                	ja     a5e6e8 <<gpui::native::accessibility::text::Cohort>::append+0x1068>
  a5e701:	4c 89 c2             	mov    %r8,%rdx
  a5e704:	4c 29 d2             	sub    %r10,%rdx
  a5e707:	0f 82 43 07 00 00    	jb     a5ee50 <<gpui::native::accessibility::text::Cohort>::append+0x17d0>
  a5e70d:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  a5e711:	4b 8d 34 d9          	lea    (%r9,%r11,8),%rsi
  a5e715:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
  a5e71a:	48 89 54 24 58       	mov    %rdx,0x58(%rsp)
  a5e71f:	48 ff cf             	dec    %rdi
  a5e722:	75 9e                	jne    a5e6c2 <<gpui::native::accessibility::text::Cohort>::append+0x1042>
  a5e724:	48 89 d7             	mov    %rdx,%rdi
  a5e727:	48 83 fa 01          	cmp    $0x1,%rdx
  a5e72b:	0f 84 68 fe ff ff    	je     a5e599 <<gpui::native::accessibility::text::Cohort>::append+0xf19>
  a5e731:	48 85 d2             	test   %rdx,%rdx
  a5e734:	74 48                	je     a5e77e <<gpui::native::accessibility::text::Cohort>::append+0x10fe>
  a5e736:	4f 8d 0c d9          	lea    (%r9,%r11,8),%r9
  a5e73a:	49 83 c1 28          	add    $0x28,%r9
  a5e73e:	4d 29 d0             	sub    %r10,%r8
  a5e741:	49 ff c0             	inc    %r8
  a5e744:	bf 01 00 00 00       	mov    $0x1,%edi
  a5e749:	45 8b 51 e8          	mov    -0x18(%r9),%r10d
  a5e74d:	45 3b 11             	cmp    (%r9),%r10d
  a5e750:	0f 85 43 fe ff ff    	jne    a5e599 <<gpui::native::accessibility::text::Cohort>::append+0xf19>
  a5e756:	48 ff c7             	inc    %rdi
  a5e759:	49 83 c1 18          	add    $0x18,%r9
  a5e75d:	49 ff c8             	dec    %r8
  a5e760:	49 83 f8 02          	cmp    $0x2,%r8
  a5e764:	77 e3                	ja     a5e749 <<gpui::native::accessibility::text::Cohort>::append+0x10c9>
  a5e766:	e9 2e fe ff ff       	jmp    a5e599 <<gpui::native::accessibility::text::Cohort>::append+0xf19>
  a5e76b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  a5e770:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  a5e775:	48 85 d2             	test   %rdx,%rdx
  a5e778:	0f 85 72 fd ff ff    	jne    a5e4f0 <<gpui::native::accessibility::text::Cohort>::append+0xe70>
  a5e77e:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  a5e783:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  a5e788:	4c 39 f8             	cmp    %r15,%rax
  a5e78b:	0f 85 5a 07 00 00    	jne    a5eeeb <<gpui::native::accessibility::text::Cohort>::append+0x186b>
  a5e791:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  a5e796:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  a5e79b:	48 89 41 e0          	mov    %rax,-0x20(%rcx)
  a5e79f:	66 0f 10 44 24 18    	movupd 0x18(%rsp),%xmm0
  a5e7a5:	66 0f 11 41 d0       	movupd %xmm0,-0x30(%rcx)
  a5e7aa:	c6 44 24 40 0b       	movb   $0xb,0x40(%rsp)
  a5e7af:	45 31 e4             	xor    %r12d,%r12d
  a5e7b2:	48 89 df             	mov    %rbx,%rdi
  a5e7b5:	be 42 00 00 00       	mov    $0x42,%esi
  a5e7ba:	48 8d 54 24 40       	lea    0x40(%rsp),%rdx
  a5e7bf:	ff 15 cb 25 ad 00    	call   *0xad25cb(%rip)        # 1530d90 <_DYNAMIC+0x1670>
  a5e7c5:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  a5e7cc:	00 
  a5e7cd:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  a5e7d2:	48 89 41 e0          	mov    %rax,-0x20(%rcx)
  a5e7d6:	0f 10 84 24 d8 00 00 	movups 0xd8(%rsp),%xmm0
  a5e7dd:	00 
  a5e7de:	0f 11 41 d0          	movups %xmm0,-0x30(%rcx)
  a5e7e2:	c6 44 24 40 0b       	movb   $0xb,0x40(%rsp)
  a5e7e7:	48 89 df             	mov    %rbx,%rdi
  a5e7ea:	be 43 00 00 00       	mov    $0x43,%esi
  a5e7ef:	48 8d 54 24 40       	lea    0x40(%rsp),%rdx
  a5e7f4:	ff 15 96 25 ad 00    	call   *0xad2596(%rip)        # 1530d90 <_DYNAMIC+0x1670>
  a5e7fa:	0f 28 84 24 80 01 00 	movaps 0x180(%rsp),%xmm0
  a5e801:	00 
  a5e802:	66 0f 28 8c 24 90 01 	movapd 0x190(%rsp),%xmm1
  a5e809:	00 00 
  a5e80b:	66 0f 28 94 24 a0 01 	movapd 0x1a0(%rsp),%xmm2
  a5e812:	00 00 
  a5e814:	66 0f 28 9c 24 b0 01 	movapd 0x1b0(%rsp),%xmm3
  a5e81b:	00 00 
  a5e81d:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  a5e822:	66 0f 29 4c 24 50    	movapd %xmm1,0x50(%rsp)
  a5e828:	66 0f 29 54 24 60    	movapd %xmm2,0x60(%rsp)
  a5e82e:	66 0f 29 5c 24 70    	movapd %xmm3,0x70(%rsp)
  a5e834:	0f 28 84 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm0
  a5e83b:	00 
  a5e83c:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  a5e843:	00 
  a5e844:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  a5e84b:	00 
  a5e84c:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  a5e853:	00 
  a5e854:	0f 28 84 24 e0 01 00 	movaps 0x1e0(%rsp),%xmm0
  a5e85b:	00 
  a5e85c:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  a5e863:	00 
  a5e864:	0f 28 84 24 f0 01 00 	movaps 0x1f0(%rsp),%xmm0
  a5e86b:	00 
  a5e86c:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  a5e873:	00 
  a5e874:	4c 8b a4 24 48 01 00 	mov    0x148(%rsp),%r12
  a5e87b:	00 
  a5e87c:	4c 8b bc 24 30 01 00 	mov    0x130(%rsp),%r15
  a5e883:	00 
  a5e884:	48 8b ac 24 38 01 00 	mov    0x138(%rsp),%rbp
  a5e88b:	00 
  a5e88c:	48 8b 84 24 28 02 00 	mov    0x228(%rsp),%rax
  a5e893:	00 
  a5e894:	48 8b 8c 24 30 02 00 	mov    0x230(%rsp),%rcx
  a5e89b:	00 
  a5e89c:	48 01 8c 24 40 01 00 	add    %rcx,0x140(%rsp)
  a5e8a3:	00 
  a5e8a4:	48 39 e8             	cmp    %rbp,%rax
  a5e8a7:	0f 94 c0             	sete   %al
  a5e8aa:	48 8b 8c 24 d0 02 00 	mov    0x2d0(%rsp),%rcx
  a5e8b1:	00 
  a5e8b2:	20 c1                	and    %al,%cl
  a5e8b4:	80 f9 01             	cmp    $0x1,%cl
  a5e8b7:	75 18                	jne    a5e8d1 <<gpui::native::accessibility::text::Cohort>::append+0x1251>
  a5e8b9:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a5e8be:	be 0d 00 00 00       	mov    $0xd,%esi
  a5e8c3:	48 8b 94 24 40 01 00 	mov    0x140(%rsp),%rdx
  a5e8ca:	00 
  a5e8cb:	ff 15 e7 24 ad 00    	call   *0xad24e7(%rip)        # 1530db8 <_DYNAMIC+0x1698>
  a5e8d1:	0f b6 84 24 18 03 00 	movzbl 0x318(%rsp),%eax
  a5e8d8:	00 
  a5e8d9:	3c ff                	cmp    $0xff,%al
  a5e8db:	0f 85 b3 00 00 00    	jne    a5e994 <<gpui::native::accessibility::text::Cohort>::append+0x1314>
  a5e8e1:	48 89 df             	mov    %rbx,%rdi
  a5e8e4:	48 8d b4 24 28 03 00 	lea    0x328(%rsp),%rsi
  a5e8eb:	00 
  a5e8ec:	e8 5f e2 ff ff       	call   a5cb50 <<gpui_canvas::text::layout::TextGeometry>::runs::{closure#2}>
  a5e8f1:	0f b6 84 24 a0 01 00 	movzbl 0x1a0(%rsp),%eax
  a5e8f8:	00 
  a5e8f9:	3c 02                	cmp    $0x2,%al
  a5e8fb:	75 02                	jne    a5e8ff <<gpui::native::accessibility::text::Cohort>::append+0x127f>
  a5e8fd:	eb 51                	jmp    a5e950 <<gpui::native::accessibility::text::Cohort>::append+0x12d0>
  a5e8ff:	0f 10 84 24 80 01 00 	movups 0x180(%rsp),%xmm0
  a5e906:	00 
  a5e907:	66 0f 10 8c 24 90 01 	movupd 0x190(%rsp),%xmm1
  a5e90e:	00 00 
  a5e910:	66 0f 29 8c 24 60 02 	movapd %xmm1,0x260(%rsp)
  a5e917:	00 00 
  a5e919:	0f 29 84 24 50 02 00 	movaps %xmm0,0x250(%rsp)
  a5e920:	00 
  a5e921:	48 8d 94 24 a1 01 00 	lea    0x1a1(%rsp),%rdx
  a5e928:	00 
  a5e929:	8b 0a                	mov    (%rdx),%ecx
  a5e92b:	8b 52 03             	mov    0x3(%rdx),%edx
  a5e92e:	89 8c 24 60 01 00 00 	mov    %ecx,0x160(%rsp)
  a5e935:	89 94 24 63 01 00 00 	mov    %edx,0x163(%rsp)
  a5e93c:	48 8b 8c 24 20 03 00 	mov    0x320(%rsp),%rcx
  a5e943:	00 
  a5e944:	48 8d 51 01          	lea    0x1(%rcx),%rdx
  a5e948:	48 89 94 24 20 03 00 	mov    %rdx,0x320(%rsp)
  a5e94f:	00 
  a5e950:	48 89 8c 24 f0 02 00 	mov    %rcx,0x2f0(%rsp)
  a5e957:	00 
  a5e958:	0f 28 84 24 50 02 00 	movaps 0x250(%rsp),%xmm0
  a5e95f:	00 
  a5e960:	66 0f 28 8c 24 60 02 	movapd 0x260(%rsp),%xmm1
  a5e967:	00 00 
  a5e969:	48 8d b4 24 19 03 00 	lea    0x319(%rsp),%rsi
  a5e970:	00 
  a5e971:	66 0f 11 4e ef       	movupd %xmm1,-0x11(%rsi)
  a5e976:	0f 11 46 df          	movups %xmm0,-0x21(%rsi)
  a5e97a:	88 84 24 18 03 00 00 	mov    %al,0x318(%rsp)
  a5e981:	8b 8c 24 60 01 00 00 	mov    0x160(%rsp),%ecx
  a5e988:	8b 94 24 63 01 00 00 	mov    0x163(%rsp),%edx
  a5e98f:	89 56 03             	mov    %edx,0x3(%rsi)
  a5e992:	89 0e                	mov    %ecx,(%rsi)
  a5e994:	3c 02                	cmp    $0x2,%al
  a5e996:	74 26                	je     a5e9be <<gpui::native::accessibility::text::Cohort>::append+0x133e>
  a5e998:	48 39 ac 24 08 03 00 	cmp    %rbp,0x308(%rsp)
  a5e99f:	00 
  a5e9a0:	75 1c                	jne    a5e9be <<gpui::native::accessibility::text::Cohort>::append+0x133e>
  a5e9a2:	48 8b 94 24 40 01 00 	mov    0x140(%rsp),%rdx
  a5e9a9:	00 
  a5e9aa:	48 83 c2 02          	add    $0x2,%rdx
  a5e9ae:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a5e9b3:	be 0c 00 00 00       	mov    $0xc,%esi
  a5e9b8:	ff 15 fa 23 ad 00    	call   *0xad23fa(%rip)        # 1530db8 <_DYNAMIC+0x1698>
  a5e9be:	0f 28 84 24 b0 00 00 	movaps 0xb0(%rsp),%xmm0
  a5e9c5:	00 
  a5e9c6:	48 8d 84 24 a1 01 00 	lea    0x1a1(%rsp),%rax
  a5e9cd:	00 
  a5e9ce:	0f 11 40 57          	movups %xmm0,0x57(%rax)
  a5e9d2:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  a5e9d9:	00 
  a5e9da:	0f 11 40 47          	movups %xmm0,0x47(%rax)
  a5e9de:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  a5e9e5:	00 
  a5e9e6:	0f 11 40 37          	movups %xmm0,0x37(%rax)
  a5e9ea:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  a5e9f1:	00 
  a5e9f2:	0f 11 40 27          	movups %xmm0,0x27(%rax)
  a5e9f6:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  a5e9fb:	66 0f 28 4c 24 50    	movapd 0x50(%rsp),%xmm1
  a5ea01:	66 0f 28 54 24 60    	movapd 0x60(%rsp),%xmm2
  a5ea07:	66 0f 28 5c 24 70    	movapd 0x70(%rsp),%xmm3
  a5ea0d:	66 0f 11 58 17       	movupd %xmm3,0x17(%rax)
  a5ea12:	66 0f 11 50 07       	movupd %xmm2,0x7(%rax)
  a5ea17:	66 0f 11 48 f7       	movupd %xmm1,-0x9(%rax)
  a5ea1c:	0f 11 40 e7          	movups %xmm0,-0x19(%rax)
  a5ea20:	48 8b 84 24 d8 02 00 	mov    0x2d8(%rsp),%rax
  a5ea27:	00 
  a5ea28:	48 89 84 24 80 01 00 	mov    %rax,0x180(%rsp)
  a5ea2f:	00 
  a5ea30:	49 8b 5f 10          	mov    0x10(%r15),%rbx
  a5ea34:	49 3b 1f             	cmp    (%r15),%rbx
  a5ea37:	75 09                	jne    a5ea42 <<gpui::native::accessibility::text::Cohort>::append+0x13c2>
  a5ea39:	4c 89 ff             	mov    %r15,%rdi
  a5ea3c:	ff 15 7e 23 ad 00    	call   *0xad237e(%rip)        # 1530dc0 <_DYNAMIC+0x16a0>
  a5ea42:	48 89 d8             	mov    %rbx,%rax
  a5ea45:	48 c1 e0 07          	shl    $0x7,%rax
  a5ea49:	48 8d 3c d8          	lea    (%rax,%rbx,8),%rdi
  a5ea4d:	49 03 7f 08          	add    0x8(%r15),%rdi
  a5ea51:	ba 88 00 00 00       	mov    $0x88,%edx
  a5ea56:	48 8d ac 24 80 01 00 	lea    0x180(%rsp),%rbp
  a5ea5d:	00 
  a5ea5e:	48 89 ee             	mov    %rbp,%rsi
  a5ea61:	ff 15 19 0f ad 00    	call   *0xad0f19(%rip)        # 152f980 <memcpy@GLIBC_2.14>
  a5ea67:	48 ff c3             	inc    %rbx
  a5ea6a:	49 89 5f 10          	mov    %rbx,0x10(%r15)
  a5ea6e:	48 89 ef             	mov    %rbp,%rdi
  a5ea71:	40 b5 01             	mov    $0x1,%bpl
  a5ea74:	0f b6 94 24 18 03 00 	movzbl 0x318(%rsp),%edx
  a5ea7b:	00 
  a5ea7c:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  a5ea83:	00 
  a5ea84:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  a5ea8b:	00 
  a5ea8c:	48 8b 1d 0d 23 ad 00 	mov    0xad230d(%rip),%rbx        # 1530da0 <_DYNAMIC+0x1680>
  a5ea93:	e9 4d f1 ff ff       	jmp    a5dbe5 <<gpui::native::accessibility::text::Cohort>::append+0x565>
  a5ea98:	0f 28 84 24 f0 01 00 	movaps 0x1f0(%rsp),%xmm0
  a5ea9f:	00 
  a5eaa0:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  a5eaa7:	00 
  a5eaa8:	0f 28 84 24 e0 01 00 	movaps 0x1e0(%rsp),%xmm0
  a5eaaf:	00 
  a5eab0:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  a5eab7:	00 
  a5eab8:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  a5eabf:	00 
  a5eac0:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  a5eac7:	00 
  a5eac8:	0f 28 84 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm0
  a5eacf:	00 
  a5ead0:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  a5ead7:	00 
  a5ead8:	0f 28 84 24 80 01 00 	movaps 0x180(%rsp),%xmm0
  a5eadf:	00 
  a5eae0:	66 0f 28 8c 24 90 01 	movapd 0x190(%rsp),%xmm1
  a5eae7:	00 00 
  a5eae9:	66 0f 28 94 24 a0 01 	movapd 0x1a0(%rsp),%xmm2
  a5eaf0:	00 00 
  a5eaf2:	66 0f 28 9c 24 b0 01 	movapd 0x1b0(%rsp),%xmm3
  a5eaf9:	00 00 
  a5eafb:	66 0f 29 5c 24 70    	movapd %xmm3,0x70(%rsp)
  a5eb01:	66 0f 29 54 24 60    	movapd %xmm2,0x60(%rsp)
  a5eb07:	66 0f 29 4c 24 50    	movapd %xmm1,0x50(%rsp)
  a5eb0d:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  a5eb12:	e9 5d fd ff ff       	jmp    a5e874 <<gpui::native::accessibility::text::Cohort>::append+0x11f4>
  a5eb17:	48 8d 9c 24 80 01 00 	lea    0x180(%rsp),%rbx
  a5eb1e:	00 
  a5eb1f:	4c 8b 3d 7a 22 ad 00 	mov    0xad227a(%rip),%r15        # 1530da0 <_DYNAMIC+0x1680>
  a5eb26:	48 8b ac 24 50 01 00 	mov    0x150(%rsp),%rbp
  a5eb2d:	00 
  a5eb2e:	eb 1f                	jmp    a5eb4f <<gpui::native::accessibility::text::Cohort>::append+0x14cf>
  a5eb30:	48 8b 94 24 20 03 00 	mov    0x320(%rsp),%rdx
  a5eb37:	00 
  a5eb38:	48 ff c2             	inc    %rdx
  a5eb3b:	48 89 94 24 20 03 00 	mov    %rdx,0x320(%rsp)
  a5eb42:	00 
  a5eb43:	49 03 56 28          	add    0x28(%r14),%rdx
  a5eb47:	48 89 ef             	mov    %rbp,%rdi
  a5eb4a:	31 f6                	xor    %esi,%esi
  a5eb4c:	41 ff d7             	call   *%r15
  a5eb4f:	48 8b 94 24 f0 02 00 	mov    0x2f0(%rsp),%rdx
  a5eb56:	00 
  a5eb57:	0f b6 84 24 18 03 00 	movzbl 0x318(%rsp),%eax
  a5eb5e:	00 
  a5eb5f:	c6 84 24 18 03 00 00 	movb   $0xff,0x318(%rsp)
  a5eb66:	ff 
  a5eb67:	3d ff 00 00 00       	cmp    $0xff,%eax
  a5eb6c:	74 12                	je     a5eb80 <<gpui::native::accessibility::text::Cohort>::append+0x1500>
  a5eb6e:	83 f8 02             	cmp    $0x2,%eax
  a5eb71:	74 27                	je     a5eb9a <<gpui::native::accessibility::text::Cohort>::append+0x151a>
  a5eb73:	48 ff c2             	inc    %rdx
  a5eb76:	eb cb                	jmp    a5eb43 <<gpui::native::accessibility::text::Cohort>::append+0x14c3>
  a5eb78:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a5eb7f:	00 
  a5eb80:	48 89 df             	mov    %rbx,%rdi
  a5eb83:	48 8d b4 24 28 03 00 	lea    0x328(%rsp),%rsi
  a5eb8a:	00 
  a5eb8b:	e8 c0 df ff ff       	call   a5cb50 <<gpui_canvas::text::layout::TextGeometry>::runs::{closure#2}>
  a5eb90:	80 bc 24 a0 01 00 00 	cmpb   $0x2,0x1a0(%rsp)
  a5eb97:	02 
  a5eb98:	75 96                	jne    a5eb30 <<gpui::native::accessibility::text::Cohort>::append+0x14b0>
  a5eb9a:	48 83 bc 24 d0 03 00 	cmpq   $0xffffffffffffffff,0x3d0(%rsp)
  a5eba1:	00 ff 
  a5eba3:	0f 94 84 24 10 01 00 	sete   0x110(%rsp)
  a5ebaa:	00 
  a5ebab:	0f 84 53 01 00 00    	je     a5ed04 <<gpui::native::accessibility::text::Cohort>::append+0x1684>
  a5ebb1:	0f 28 84 24 40 04 00 	movaps 0x440(%rsp),%xmm0
  a5ebb8:	00 
  a5ebb9:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  a5ebc0:	00 
  a5ebc1:	0f 28 84 24 30 04 00 	movaps 0x430(%rsp),%xmm0
  a5ebc8:	00 
  a5ebc9:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  a5ebd0:	00 
  a5ebd1:	0f 28 84 24 20 04 00 	movaps 0x420(%rsp),%xmm0
  a5ebd8:	00 
  a5ebd9:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  a5ebe0:	00 
  a5ebe1:	0f 28 84 24 10 04 00 	movaps 0x410(%rsp),%xmm0
  a5ebe8:	00 
  a5ebe9:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  a5ebf0:	00 
  a5ebf1:	0f 28 84 24 d0 03 00 	movaps 0x3d0(%rsp),%xmm0
  a5ebf8:	00 
  a5ebf9:	66 0f 28 8c 24 e0 03 	movapd 0x3e0(%rsp),%xmm1
  a5ec00:	00 00 
  a5ec02:	66 0f 28 94 24 f0 03 	movapd 0x3f0(%rsp),%xmm2
  a5ec09:	00 00 
  a5ec0b:	66 0f 28 9c 24 00 04 	movapd 0x400(%rsp),%xmm3
  a5ec12:	00 00 
  a5ec14:	66 0f 29 5c 24 70    	movapd %xmm3,0x70(%rsp)
  a5ec1a:	66 0f 29 54 24 60    	movapd %xmm2,0x60(%rsp)
  a5ec20:	66 0f 29 4c 24 50    	movapd %xmm1,0x50(%rsp)
  a5ec26:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  a5ec2b:	49 8b 5e 28          	mov    0x28(%r14),%rbx
  a5ec2f:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  a5ec34:	31 f6                	xor    %esi,%esi
  a5ec36:	48 89 da             	mov    %rbx,%rdx
  a5ec39:	ff 15 61 21 ad 00    	call   *0xad2161(%rip)        # 1530da0 <_DYNAMIC+0x1680>
  a5ec3f:	0f 28 84 24 b0 00 00 	movaps 0xb0(%rsp),%xmm0
  a5ec46:	00 
  a5ec47:	0f 11 84 24 f8 01 00 	movups %xmm0,0x1f8(%rsp)
  a5ec4e:	00 
  a5ec4f:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  a5ec56:	00 
  a5ec57:	0f 11 84 24 e8 01 00 	movups %xmm0,0x1e8(%rsp)
  a5ec5e:	00 
  a5ec5f:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  a5ec66:	00 
  a5ec67:	0f 11 84 24 d8 01 00 	movups %xmm0,0x1d8(%rsp)
  a5ec6e:	00 
  a5ec6f:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  a5ec76:	00 
  a5ec77:	0f 11 84 24 c8 01 00 	movups %xmm0,0x1c8(%rsp)
  a5ec7e:	00 
  a5ec7f:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  a5ec84:	66 0f 28 4c 24 50    	movapd 0x50(%rsp),%xmm1
  a5ec8a:	66 0f 28 54 24 60    	movapd 0x60(%rsp),%xmm2
  a5ec90:	66 0f 28 5c 24 70    	movapd 0x70(%rsp),%xmm3
  a5ec96:	66 0f 11 9c 24 b8 01 	movupd %xmm3,0x1b8(%rsp)
  a5ec9d:	00 00 
  a5ec9f:	66 0f 11 94 24 a8 01 	movupd %xmm2,0x1a8(%rsp)
  a5eca6:	00 00 
  a5eca8:	66 0f 11 8c 24 98 01 	movupd %xmm1,0x198(%rsp)
  a5ecaf:	00 00 
  a5ecb1:	0f 11 84 24 88 01 00 	movups %xmm0,0x188(%rsp)
  a5ecb8:	00 
  a5ecb9:	48 89 9c 24 80 01 00 	mov    %rbx,0x180(%rsp)
  a5ecc0:	00 
  a5ecc1:	4c 8b bc 24 30 01 00 	mov    0x130(%rsp),%r15
  a5ecc8:	00 
  a5ecc9:	49 8b 5f 10          	mov    0x10(%r15),%rbx
  a5eccd:	49 3b 1f             	cmp    (%r15),%rbx
  a5ecd0:	75 09                	jne    a5ecdb <<gpui::native::accessibility::text::Cohort>::append+0x165b>
  a5ecd2:	4c 89 ff             	mov    %r15,%rdi
  a5ecd5:	ff 15 e5 20 ad 00    	call   *0xad20e5(%rip)        # 1530dc0 <_DYNAMIC+0x16a0>
  a5ecdb:	48 89 d8             	mov    %rbx,%rax
  a5ecde:	48 c1 e0 07          	shl    $0x7,%rax
  a5ece2:	48 8d 3c d8          	lea    (%rax,%rbx,8),%rdi
  a5ece6:	49 03 7f 08          	add    0x8(%r15),%rdi
  a5ecea:	48 8d b4 24 80 01 00 	lea    0x180(%rsp),%rsi
  a5ecf1:	00 
  a5ecf2:	ba 88 00 00 00       	mov    $0x88,%edx
  a5ecf7:	ff 15 83 0c ad 00    	call   *0xad0c83(%rip)        # 152f980 <memcpy@GLIBC_2.14>
  a5ecfd:	48 ff c3             	inc    %rbx
  a5ed00:	49 89 5f 10          	mov    %rbx,0x10(%r15)
  a5ed04:	49 83 7e 18 00       	cmpq   $0x0,0x18(%r14)
  a5ed09:	0f 84 11 01 00 00    	je     a5ee20 <<gpui::native::accessibility::text::Cohort>::append+0x17a0>
  a5ed0f:	41 80 7d 4d 02       	cmpb   $0x2,0x4d(%r13)
  a5ed14:	0f 85 5a 02 00 00    	jne    a5ef74 <<gpui::native::accessibility::text::Cohort>::append+0x18f4>
  a5ed1a:	49 8b 45 28          	mov    0x28(%r13),%rax
  a5ed1e:	48 85 c0             	test   %rax,%rax
  a5ed21:	0f 84 4d 02 00 00    	je     a5ef74 <<gpui::native::accessibility::text::Cohort>::append+0x18f4>
  a5ed27:	48 8b 18             	mov    (%rax),%rbx
  a5ed2a:	41 0f b6 6c 24 24    	movzbl 0x24(%r12),%ebp
  a5ed30:	40 80 fd 02          	cmp    $0x2,%bpl
  a5ed34:	74 32                	je     a5ed68 <<gpui::native::accessibility::text::Cohort>::append+0x16e8>
  a5ed36:	49 8b 44 24 10       	mov    0x10(%r12),%rax
  a5ed3b:	49 3b 45 20          	cmp    0x20(%r13),%rax
  a5ed3f:	75 27                	jne    a5ed68 <<gpui::native::accessibility::text::Cohort>::append+0x16e8>
  a5ed41:	41 8b 74 24 18       	mov    0x18(%r12),%esi
  a5ed46:	41 0f b6 44 24 1c    	movzbl 0x1c(%r12),%eax
  a5ed4c:	41 8b 5c 24 20       	mov    0x20(%r12),%ebx
  a5ed51:	eb 2c                	jmp    a5ed7f <<gpui::native::accessibility::text::Cohort>::append+0x16ff>
  a5ed53:	31 ff                	xor    %edi,%edi
  a5ed55:	48 8b b4 24 28 01 00 	mov    0x128(%rsp),%rsi
  a5ed5c:	00 
  a5ed5d:	ff 15 f5 0c ad 00    	call   *0xad0cf5(%rip)        # 152fa58 <_DYNAMIC+0x338>
  a5ed63:	e9 76 02 00 00       	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5ed68:	48 89 d8             	mov    %rbx,%rax
  a5ed6b:	48 c1 e8 21          	shr    $0x21,%rax
  a5ed6f:	0f 85 ff 01 00 00    	jne    a5ef74 <<gpui::native::accessibility::text::Cohort>::append+0x18f4>
  a5ed75:	48 d1 eb             	shr    $1,%rbx
  a5ed78:	b0 01                	mov    $0x1,%al
  a5ed7a:	89 de                	mov    %ebx,%esi
  a5ed7c:	40 b5 01             	mov    $0x1,%bpl
  a5ed7f:	0f b6 d0             	movzbl %al,%edx
  a5ed82:	83 e2 01             	and    $0x1,%edx
  a5ed85:	4c 89 f7             	mov    %r14,%rdi
  a5ed88:	e8 43 05 00 00       	call   a5f2d0 <<gpui::native::accessibility::text::Input>::native_position>
  a5ed8d:	49 89 c7             	mov    %rax,%r15
  a5ed90:	49 89 d4             	mov    %rdx,%r12
  a5ed93:	40 0f b6 d5          	movzbl %bpl,%edx
  a5ed97:	83 e2 01             	and    $0x1,%edx
  a5ed9a:	4c 89 f7             	mov    %r14,%rdi
  a5ed9d:	89 de                	mov    %ebx,%esi
  a5ed9f:	e8 2c 05 00 00       	call   a5f2d0 <<gpui::native::accessibility::text::Input>::native_position>
  a5eda4:	48 89 c3             	mov    %rax,%rbx
  a5eda7:	49 89 d5             	mov    %rdx,%r13
  a5edaa:	ff 15 b0 0b ad 00    	call   *0xad0bb0(%rip)        # 152f960 <_DYNAMIC+0x240>
  a5edb0:	bf 20 00 00 00       	mov    $0x20,%edi
  a5edb5:	be 08 00 00 00       	mov    $0x8,%esi
  a5edba:	ff 15 a8 0b ad 00    	call   *0xad0ba8(%rip)        # 152f968 <_DYNAMIC+0x248>
  a5edc0:	48 85 c0             	test   %rax,%rax
  a5edc3:	0f 84 45 01 00 00    	je     a5ef0e <<gpui::native::accessibility::text::Cohort>::append+0x188e>
  a5edc9:	4c 89 38             	mov    %r15,(%rax)
  a5edcc:	4c 89 60 08          	mov    %r12,0x8(%rax)
  a5edd0:	48 89 58 10          	mov    %rbx,0x10(%rax)
  a5edd4:	4c 89 68 18          	mov    %r13,0x18(%rax)
  a5edd8:	48 89 84 24 88 01 00 	mov    %rax,0x188(%rsp)
  a5eddf:	00 
  a5ede0:	c6 84 24 80 01 00 00 	movb   $0x1b,0x180(%rsp)
  a5ede7:	1b 
  a5ede8:	48 8d 94 24 80 01 00 	lea    0x180(%rsp),%rdx
  a5edef:	00 
  a5edf0:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  a5edf5:	be 54 00 00 00       	mov    $0x54,%esi
  a5edfa:	ff 15 90 1f ad 00    	call   *0xad1f90(%rip)        # 1530d90 <_DYNAMIC+0x1670>
  a5ee00:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  a5ee05:	8b 42 70             	mov    0x70(%rdx),%eax
  a5ee08:	89 c1                	mov    %eax,%ecx
  a5ee0a:	81 c9 00 04 04 00    	or     $0x40400,%ecx
  a5ee10:	25 f9 ff ef ff       	and    $0xffeffff9,%eax
  a5ee15:	49 83 7e 10 00       	cmpq   $0x0,0x10(%r14)
  a5ee1a:	0f 45 c1             	cmovne %ecx,%eax
  a5ee1d:	89 42 70             	mov    %eax,0x70(%rdx)
  a5ee20:	48 81 c4 58 04 00 00 	add    $0x458,%rsp
  a5ee27:	5b                   	pop    %rbx
  a5ee28:	41 5c                	pop    %r12
  a5ee2a:	41 5d                	pop    %r13
  a5ee2c:	41 5e                	pop    %r14
  a5ee2e:	41 5f                	pop    %r15
  a5ee30:	5d                   	pop    %rbp
  a5ee31:	c3                   	ret
  a5ee32:	48 8d 3d 23 e1 73 ff 	lea    -0x8c1edd(%rip),%rdi        # 19cf5c <anon.f1514e157150765e701d959c660d2214.14.llvm.14306826168292286542+0x70>
  a5ee39:	48 8d 15 38 28 a6 00 	lea    0xa62838(%rip),%rdx        # 14c1678 <anon.8df5206834877815e8786c895557e178.5.llvm.4810214434977047461+0x248>
  a5ee40:	be 13 00 00 00       	mov    $0x13,%esi
  a5ee45:	ff 15 65 0b ad 00    	call   *0xad0b65(%rip)        # 152f9b0 <_DYNAMIC+0x290>
  a5ee4b:	e9 8e 01 00 00       	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5ee50:	48 8d 3d 05 e1 73 ff 	lea    -0x8c1efb(%rip),%rdi        # 19cf5c <anon.f1514e157150765e701d959c660d2214.14.llvm.14306826168292286542+0x70>
  a5ee57:	48 8d 15 1a 28 a6 00 	lea    0xa6281a(%rip),%rdx        # 14c1678 <anon.8df5206834877815e8786c895557e178.5.llvm.4810214434977047461+0x248>
  a5ee5e:	be 13 00 00 00       	mov    $0x13,%esi
  a5ee63:	ff 15 47 0b ad 00    	call   *0xad0b47(%rip)        # 152f9b0 <_DYNAMIC+0x290>
  a5ee69:	e9 70 01 00 00       	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5ee6e:	c6 84 24 10 01 00 00 	movb   $0x1,0x110(%rsp)
  a5ee75:	01 
  a5ee76:	bf 08 00 00 00       	mov    $0x8,%edi
  a5ee7b:	be 30 00 00 00       	mov    $0x30,%esi
  a5ee80:	ff 15 02 0b ad 00    	call   *0xad0b02(%rip)        # 152f988 <_DYNAMIC+0x268>
  a5ee86:	e9 53 01 00 00       	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5ee8b:	48 8d 3d fe 25 a6 00 	lea    0xa625fe(%rip),%rdi        # 14c1490 <anon.8df5206834877815e8786c895557e178.5.llvm.4810214434977047461+0x60>
  a5ee92:	ff 15 00 0b ad 00    	call   *0xad0b00(%rip)        # 152f998 <_DYNAMIC+0x278>
  a5ee98:	e9 41 01 00 00       	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5ee9d:	48 8d 3d a6 0a 74 ff 	lea    -0x8bf55a(%rip),%rdi        # 19f94a <anon.f1514e157150765e701d959c660d2214.14.llvm.14306826168292286542+0x2a5e>
  a5eea4:	48 8d 15 b5 27 a6 00 	lea    0xa627b5(%rip),%rdx        # 14c1660 <anon.8df5206834877815e8786c895557e178.5.llvm.4810214434977047461+0x230>
  a5eeab:	be 40 01 00 00       	mov    $0x140,%esi
  a5eeb0:	ff 15 da 0a ad 00    	call   *0xad0ada(%rip)        # 152f990 <_DYNAMIC+0x270>
  a5eeb6:	e9 23 01 00 00       	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5eebb:	48 8d 3d 86 25 a6 00 	lea    0xa62586(%rip),%rdi        # 14c1448 <anon.8df5206834877815e8786c895557e178.5.llvm.4810214434977047461+0x18>
  a5eec2:	ff 15 d0 0a ad 00    	call   *0xad0ad0(%rip)        # 152f998 <_DYNAMIC+0x278>
  a5eec8:	e9 11 01 00 00       	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5eecd:	48 8d 3d 2e 0a 74 ff 	lea    -0x8bf5d2(%rip),%rdi        # 19f902 <anon.f1514e157150765e701d959c660d2214.14.llvm.14306826168292286542+0x2a16>
  a5eed4:	48 8d 15 3d 27 a6 00 	lea    0xa6273d(%rip),%rdx        # 14c1618 <anon.8df5206834877815e8786c895557e178.5.llvm.4810214434977047461+0x1e8>
  a5eedb:	be 2b 00 00 00       	mov    $0x2b,%esi
  a5eee0:	ff 15 b2 0b ad 00    	call   *0xad0bb2(%rip)        # 152fa98 <_DYNAMIC+0x378>
  a5eee6:	e9 f3 00 00 00       	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5eeeb:	4c 8d 0d 3e 27 a6 00 	lea    0xa6273e(%rip),%r9        # 14c1630 <anon.8df5206834877815e8786c895557e178.5.llvm.4810214434977047461+0x200>
  a5eef2:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  a5eef7:	48 8d 94 24 e8 02 00 	lea    0x2e8(%rsp),%rdx
  a5eefe:	00 
  a5eeff:	31 ff                	xor    %edi,%edi
  a5ef01:	31 c9                	xor    %ecx,%ecx
  a5ef03:	ff 15 1f 1d ad 00    	call   *0xad1d1f(%rip)        # 1530c28 <_DYNAMIC+0x1508>
  a5ef09:	e9 d0 00 00 00       	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5ef0e:	bf 08 00 00 00       	mov    $0x8,%edi
  a5ef13:	be 20 00 00 00       	mov    $0x20,%esi
  a5ef18:	ff 15 6a 0a ad 00    	call   *0xad0a6a(%rip)        # 152f988 <_DYNAMIC+0x268>
  a5ef1e:	e9 bb 00 00 00       	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5ef23:	48 8d 05 06 25 a6 00 	lea    0xa62506(%rip),%rax        # 14c1430 <anon.8df5206834877815e8786c895557e178.5.llvm.4810214434977047461>
  a5ef2a:	48 89 d7             	mov    %rdx,%rdi
  a5ef2d:	48 89 c2             	mov    %rax,%rdx
  a5ef30:	ff 15 1a 0b ad 00    	call   *0xad0b1a(%rip)        # 152fa50 <_DYNAMIC+0x330>
  a5ef36:	c6 84 24 10 01 00 00 	movb   $0x1,0x110(%rsp)
  a5ef3d:	01 
  a5ef3e:	48 8d 3d e8 09 74 ff 	lea    -0x8bf618(%rip),%rdi        # 19f92d <anon.f1514e157150765e701d959c660d2214.14.llvm.14306826168292286542+0x2a41>
  a5ef45:	48 8d 15 fc 26 a6 00 	lea    0xa626fc(%rip),%rdx        # 14c1648 <anon.8df5206834877815e8786c895557e178.5.llvm.4810214434977047461+0x218>
  a5ef4c:	be 1d 00 00 00       	mov    $0x1d,%esi
  a5ef51:	ff 15 41 0b ad 00    	call   *0xad0b41(%rip)        # 152fa98 <_DYNAMIC+0x378>
  a5ef57:	e9 82 00 00 00       	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5ef5c:	4c 8d 05 9d 26 a6 00 	lea    0xa6269d(%rip),%r8        # 14c1600 <anon.8df5206834877815e8786c895557e178.5.llvm.4810214434977047461+0x1d0>
  a5ef63:	4c 89 e7             	mov    %r12,%rdi
  a5ef66:	4c 89 fa             	mov    %r15,%rdx
  a5ef69:	48 89 e9             	mov    %rbp,%rcx
  a5ef6c:	ff 15 56 1e ad 00    	call   *0xad1e56(%rip)        # 1530dc8 <_DYNAMIC+0x16a8>
  a5ef72:	eb 6a                	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5ef74:	48 8d 3d ea df 73 ff 	lea    -0x8c2016(%rip),%rdi        # 19cf65 <anon.f1514e157150765e701d959c660d2214.14.llvm.14306826168292286542+0x79>
  a5ef7b:	48 8d 15 26 25 a6 00 	lea    0xa62526(%rip),%rdx        # 14c14a8 <anon.8df5206834877815e8786c895557e178.5.llvm.4810214434977047461+0x78>
  a5ef82:	be 1c 00 00 00       	mov    $0x1c,%esi
  a5ef87:	ff 15 0b 0b ad 00    	call   *0xad0b0b(%rip)        # 152fa98 <_DYNAMIC+0x378>
  a5ef8d:	eb 4f                	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5ef8f:	bf 01 00 00 00       	mov    $0x1,%edi
  a5ef94:	48 89 de             	mov    %rbx,%rsi
  a5ef97:	ff 15 bb 0a ad 00    	call   *0xad0abb(%rip)        # 152fa58 <_DYNAMIC+0x338>
  a5ef9d:	eb 3f                	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5ef9f:	48 8d 15 2a 26 a6 00 	lea    0xa6262a(%rip),%rdx        # 14c15d0 <anon.8df5206834877815e8786c895557e178.5.llvm.4810214434977047461+0x1a0>
  a5efa6:	ff 15 a4 0a ad 00    	call   *0xad0aa4(%rip)        # 152fa50 <_DYNAMIC+0x330>
  a5efac:	eb 30                	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5efae:	bf 01 00 00 00       	mov    $0x1,%edi
  a5efb3:	4c 89 e6             	mov    %r12,%rsi
  a5efb6:	ff 15 9c 0a ad 00    	call   *0xad0a9c(%rip)        # 152fa58 <_DYNAMIC+0x338>
  a5efbc:	eb 20                	jmp    a5efde <<gpui::native::accessibility::text::Cohort>::append+0x195e>
  a5efbe:	48 89 9c 24 28 01 00 	mov    %rbx,0x128(%rsp)
  a5efc5:	00 
  a5efc6:	bf 04 00 00 00       	mov    $0x4,%edi
  a5efcb:	e9 85 fd ff ff       	jmp    a5ed55 <<gpui::native::accessibility::text::Cohort>::append+0x16d5>
  a5efd0:	bf 04 00 00 00       	mov    $0x4,%edi
  a5efd5:	48 89 de             	mov    %rbx,%rsi
  a5efd8:	ff 15 7a 0a ad 00    	call   *0xad0a7a(%rip)        # 152fa58 <_DYNAMIC+0x338>
  a5efde:	0f 0b                	ud2
  a5efe0:	e9 06 01 00 00       	jmp    a5f0eb <<gpui::native::accessibility::text::Cohort>::append+0x1a6b>
  a5efe5:	e9 01 01 00 00       	jmp    a5f0eb <<gpui::native::accessibility::text::Cohort>::append+0x1a6b>
  a5efea:	48 89 c3             	mov    %rax,%rbx
  a5efed:	48 8d bc 24 80 01 00 	lea    0x180(%rsp),%rdi
  a5eff4:	00 
  a5eff5:	e8 b6 d8 ff ff       	call   a5c8b0 <core::ptr::drop_glue::<(accesskit::NodeId, accesskit::Node)>>
  a5effa:	e9 03 02 00 00       	jmp    a5f202 <<gpui::native::accessibility::text::Cohort>::append+0x1b82>
  a5efff:	ff 15 a3 09 ad 00    	call   *0xad09a3(%rip)        # 152f9a8 <_DYNAMIC+0x288>
  a5f005:	48 89 c3             	mov    %rax,%rbx
  a5f008:	48 8d bc 24 80 01 00 	lea    0x180(%rsp),%rdi
  a5f00f:	00 
  a5f010:	e8 9b d8 ff ff       	call   a5c8b0 <core::ptr::drop_glue::<(accesskit::NodeId, accesskit::Node)>>
  a5f015:	eb 34                	jmp    a5f04b <<gpui::native::accessibility::text::Cohort>::append+0x19cb>
  a5f017:	ff 15 8b 09 ad 00    	call   *0xad098b(%rip)        # 152f9a8 <_DYNAMIC+0x288>
  a5f01d:	48 89 c3             	mov    %rax,%rbx
  a5f020:	e9 f5 00 00 00       	jmp    a5f11a <<gpui::native::accessibility::text::Cohort>::append+0x1a9a>
  a5f025:	48 89 c3             	mov    %rax,%rbx
  a5f028:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a5f02d:	e8 fe d6 ff ff       	call   a5c730 <core::ptr::drop_glue::<accesskit::Node>>
  a5f032:	e9 cb 01 00 00       	jmp    a5f202 <<gpui::native::accessibility::text::Cohort>::append+0x1b82>
  a5f037:	e9 fe 00 00 00       	jmp    a5f13a <<gpui::native::accessibility::text::Cohort>::append+0x1aba>
  a5f03c:	eb 7d                	jmp    a5f0bb <<gpui::native::accessibility::text::Cohort>::append+0x1a3b>
  a5f03e:	48 89 c3             	mov    %rax,%rbx
  a5f041:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a5f046:	e8 e5 d6 ff ff       	call   a5c730 <core::ptr::drop_glue::<accesskit::Node>>
  a5f04b:	40 b5 01             	mov    $0x1,%bpl
  a5f04e:	e9 4a 01 00 00       	jmp    a5f19d <<gpui::native::accessibility::text::Cohort>::append+0x1b1d>
  a5f053:	ff 15 4f 09 ad 00    	call   *0xad094f(%rip)        # 152f9a8 <_DYNAMIC+0x288>
  a5f059:	48 89 c3             	mov    %rax,%rbx
  a5f05c:	e9 90 00 00 00       	jmp    a5f0f1 <<gpui::native::accessibility::text::Cohort>::append+0x1a71>
  a5f061:	eb 58                	jmp    a5f0bb <<gpui::native::accessibility::text::Cohort>::append+0x1a3b>
  a5f063:	48 89 c3             	mov    %rax,%rbx
  a5f066:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  a5f06b:	48 85 f6             	test   %rsi,%rsi
  a5f06e:	74 4e                	je     a5f0be <<gpui::native::accessibility::text::Cohort>::append+0x1a3e>
  a5f070:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  a5f075:	48 c1 e6 03          	shl    $0x3,%rsi
  a5f079:	ba 08 00 00 00       	mov    $0x8,%edx
  a5f07e:	ff 15 ec 08 ad 00    	call   *0xad08ec(%rip)        # 152f970 <_DYNAMIC+0x250>
  a5f084:	eb 38                	jmp    a5f0be <<gpui::native::accessibility::text::Cohort>::append+0x1a3e>
  a5f086:	eb 33                	jmp    a5f0bb <<gpui::native::accessibility::text::Cohort>::append+0x1a3b>
  a5f088:	eb 09                	jmp    a5f093 <<gpui::native::accessibility::text::Cohort>::append+0x1a13>
  a5f08a:	e9 ab 00 00 00       	jmp    a5f13a <<gpui::native::accessibility::text::Cohort>::append+0x1aba>
  a5f08f:	eb 5a                	jmp    a5f0eb <<gpui::native::accessibility::text::Cohort>::append+0x1a6b>
  a5f091:	eb 58                	jmp    a5f0eb <<gpui::native::accessibility::text::Cohort>::append+0x1a6b>
  a5f093:	48 89 c3             	mov    %rax,%rbx
  a5f096:	40 b5 01             	mov    $0x1,%bpl
  a5f099:	e9 ff 00 00 00       	jmp    a5f19d <<gpui::native::accessibility::text::Cohort>::append+0x1b1d>
  a5f09e:	48 89 c3             	mov    %rax,%rbx
  a5f0a1:	48 8d bc 24 f0 02 00 	lea    0x2f0(%rsp),%rdi
  a5f0a8:	00 
  a5f0a9:	e8 82 d6 ff ff       	call   a5c730 <core::ptr::drop_glue::<accesskit::Node>>
  a5f0ae:	e9 4f 01 00 00       	jmp    a5f202 <<gpui::native::accessibility::text::Cohort>::append+0x1b82>
  a5f0b3:	ff 15 ef 08 ad 00    	call   *0xad08ef(%rip)        # 152f9a8 <_DYNAMIC+0x288>
  a5f0b9:	eb 30                	jmp    a5f0eb <<gpui::native::accessibility::text::Cohort>::append+0x1a6b>
  a5f0bb:	48 89 c3             	mov    %rax,%rbx
  a5f0be:	40 b5 01             	mov    $0x1,%bpl
  a5f0c1:	48 8d bc 24 50 02 00 	lea    0x250(%rsp),%rdi
  a5f0c8:	00 
  a5f0c9:	e8 62 d6 ff ff       	call   a5c730 <core::ptr::drop_glue::<accesskit::Node>>
  a5f0ce:	e9 ca 00 00 00       	jmp    a5f19d <<gpui::native::accessibility::text::Cohort>::append+0x1b1d>
  a5f0d3:	ff 15 cf 08 ad 00    	call   *0xad08cf(%rip)        # 152f9a8 <_DYNAMIC+0x288>
  a5f0d9:	48 89 c3             	mov    %rax,%rbx
  a5f0dc:	0f b6 ac 24 10 01 00 	movzbl 0x110(%rsp),%ebp
  a5f0e3:	00 
  a5f0e4:	e9 b4 00 00 00       	jmp    a5f19d <<gpui::native::accessibility::text::Cohort>::append+0x1b1d>
  a5f0e9:	eb 00                	jmp    a5f0eb <<gpui::native::accessibility::text::Cohort>::append+0x1a6b>
  a5f0eb:	48 89 c3             	mov    %rax,%rbx
  a5f0ee:	41 b4 01             	mov    $0x1,%r12b
  a5f0f1:	48 8b b4 24 d8 00 00 	mov    0xd8(%rsp),%rsi
  a5f0f8:	00 
  a5f0f9:	48 85 f6             	test   %rsi,%rsi
  a5f0fc:	74 17                	je     a5f115 <<gpui::native::accessibility::text::Cohort>::append+0x1a95>
  a5f0fe:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  a5f105:	00 
  a5f106:	48 c1 e6 02          	shl    $0x2,%rsi
  a5f10a:	ba 04 00 00 00       	mov    $0x4,%edx
  a5f10f:	ff 15 5b 08 ad 00    	call   *0xad085b(%rip)        # 152f970 <_DYNAMIC+0x250>
  a5f115:	45 84 e4             	test   %r12b,%r12b
  a5f118:	74 23                	je     a5f13d <<gpui::native::accessibility::text::Cohort>::append+0x1abd>
  a5f11a:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  a5f11f:	48 85 f6             	test   %rsi,%rsi
  a5f122:	74 19                	je     a5f13d <<gpui::native::accessibility::text::Cohort>::append+0x1abd>
  a5f124:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  a5f129:	48 c1 e6 02          	shl    $0x2,%rsi
  a5f12d:	ba 04 00 00 00       	mov    $0x4,%edx
  a5f132:	ff 15 38 08 ad 00    	call   *0xad0838(%rip)        # 152f970 <_DYNAMIC+0x250>
  a5f138:	eb 03                	jmp    a5f13d <<gpui::native::accessibility::text::Cohort>::append+0x1abd>
  a5f13a:	48 89 c3             	mov    %rax,%rbx
  a5f13d:	4c 8b b4 24 88 01 00 	mov    0x188(%rsp),%r14
  a5f144:	00 
  a5f145:	4c 8b a4 24 90 01 00 	mov    0x190(%rsp),%r12
  a5f14c:	00 
  a5f14d:	49 ff c4             	inc    %r12
  a5f150:	4c 89 f7             	mov    %r14,%rdi
  a5f153:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a5f15a:	84 00 00 00 00 00 
  a5f160:	49 83 fc 01          	cmp    $0x1,%r12
  a5f164:	74 11                	je     a5f177 <<gpui::native::accessibility::text::Cohort>::append+0x1af7>
  a5f166:	4c 8d 7f 28          	lea    0x28(%rdi),%r15
  a5f16a:	49 ff cc             	dec    %r12
  a5f16d:	e8 6e 26 01 00       	call   a717e0 <core::ptr::drop_glue::<accesskit::PropertyValue>>
  a5f172:	4c 89 ff             	mov    %r15,%rdi
  a5f175:	eb e9                	jmp    a5f160 <<gpui::native::accessibility::text::Cohort>::append+0x1ae0>
  a5f177:	48 8b 84 24 80 01 00 	mov    0x180(%rsp),%rax
  a5f17e:	00 
  a5f17f:	40 b5 01             	mov    $0x1,%bpl
  a5f182:	48 85 c0             	test   %rax,%rax
  a5f185:	74 16                	je     a5f19d <<gpui::native::accessibility::text::Cohort>::append+0x1b1d>
  a5f187:	48 c1 e0 03          	shl    $0x3,%rax
  a5f18b:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  a5f18f:	ba 08 00 00 00       	mov    $0x8,%edx
  a5f194:	4c 89 f7             	mov    %r14,%rdi
  a5f197:	ff 15 d3 07 ad 00    	call   *0xad07d3(%rip)        # 152f970 <_DYNAMIC+0x250>
  a5f19d:	4c 8b a4 24 d0 03 00 	mov    0x3d0(%rsp),%r12
  a5f1a4:	00 
  a5f1a5:	49 83 fc ff          	cmp    $0xffffffffffffffff,%r12
  a5f1a9:	0f 95 c0             	setne  %al
  a5f1ac:	40 84 c5             	test   %al,%bpl
  a5f1af:	74 51                	je     a5f202 <<gpui::native::accessibility::text::Cohort>::append+0x1b82>
  a5f1b1:	4c 8b b4 24 d8 03 00 	mov    0x3d8(%rsp),%r14
  a5f1b8:	00 
  a5f1b9:	4c 8b ac 24 e0 03 00 	mov    0x3e0(%rsp),%r13
  a5f1c0:	00 
  a5f1c1:	49 ff c5             	inc    %r13
  a5f1c4:	4c 89 f7             	mov    %r14,%rdi
  a5f1c7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  a5f1ce:	00 00 
  a5f1d0:	49 83 fd 01          	cmp    $0x1,%r13
  a5f1d4:	74 11                	je     a5f1e7 <<gpui::native::accessibility::text::Cohort>::append+0x1b67>
  a5f1d6:	4c 8d 7f 28          	lea    0x28(%rdi),%r15
  a5f1da:	49 ff cd             	dec    %r13
  a5f1dd:	e8 fe 25 01 00       	call   a717e0 <core::ptr::drop_glue::<accesskit::PropertyValue>>
  a5f1e2:	4c 89 ff             	mov    %r15,%rdi
  a5f1e5:	eb e9                	jmp    a5f1d0 <<gpui::native::accessibility::text::Cohort>::append+0x1b50>
  a5f1e7:	4d 85 e4             	test   %r12,%r12
  a5f1ea:	74 16                	je     a5f202 <<gpui::native::accessibility::text::Cohort>::append+0x1b82>
  a5f1ec:	49 c1 e4 03          	shl    $0x3,%r12
  a5f1f0:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  a5f1f4:	ba 08 00 00 00       	mov    $0x8,%edx
  a5f1f9:	4c 89 f7             	mov    %r14,%rdi
  a5f1fc:	ff 15 6e 07 ad 00    	call   *0xad076e(%rip)        # 152f970 <_DYNAMIC+0x250>
  a5f202:	48 89 df             	mov    %rbx,%rdi
  a5f205:	e8 66 b0 a5 00       	call   14ba270 <_Unwind_Resume@plt>
  a5f20a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  a5f210:	49 ff cd             	dec    %r13
  a5f213:	74 11                	je     a5f226 <<gpui::native::accessibility::text::Cohort>::append+0x1ba6>
  a5f215:	49 8d 5f 28          	lea    0x28(%r15),%rbx
  a5f219:	4c 89 ff             	mov    %r15,%rdi
  a5f21c:	e8 bf 25 01 00       	call   a717e0 <core::ptr::drop_glue::<accesskit::PropertyValue>>
  a5f221:	49 89 df             	mov    %rbx,%r15
  a5f224:	eb ea                	jmp    a5f210 <<gpui::native::accessibility::text::Cohort>::append+0x1b90>
  a5f226:	4d 85 e4             	test   %r12,%r12
  a5f229:	74 4e                	je     a5f279 <<gpui::native::accessibility::text::Cohort>::append+0x1bf9>
  a5f22b:	49 c1 e4 03          	shl    $0x3,%r12
  a5f22f:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  a5f233:	eb 36                	jmp    a5f26b <<gpui::native::accessibility::text::Cohort>::append+0x1beb>
  a5f235:	ff 15 6d 07 ad 00    	call   *0xad076d(%rip)        # 152f9a8 <_DYNAMIC+0x288>
  a5f23b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  a5f240:	49 ff cc             	dec    %r12
  a5f243:	74 11                	je     a5f256 <<gpui::native::accessibility::text::Cohort>::append+0x1bd6>
  a5f245:	49 8d 5f 28          	lea    0x28(%r15),%rbx
  a5f249:	4c 89 ff             	mov    %r15,%rdi
  a5f24c:	e8 8f 25 01 00       	call   a717e0 <core::ptr::drop_glue::<accesskit::PropertyValue>>
  a5f251:	49 89 df             	mov    %rbx,%r15
  a5f254:	eb ea                	jmp    a5f240 <<gpui::native::accessibility::text::Cohort>::append+0x1bc0>
  a5f256:	48 8b 84 24 80 01 00 	mov    0x180(%rsp),%rax
  a5f25d:	00 
  a5f25e:	48 85 c0             	test   %rax,%rax
  a5f261:	74 16                	je     a5f279 <<gpui::native::accessibility::text::Cohort>::append+0x1bf9>
  a5f263:	48 c1 e0 03          	shl    $0x3,%rax
  a5f267:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  a5f26b:	ba 08 00 00 00       	mov    $0x8,%edx
  a5f270:	4c 89 f7             	mov    %r14,%rdi
  a5f273:	ff 15 f7 06 ad 00    	call   *0xad06f7(%rip)        # 152f970 <_DYNAMIC+0x250>
  a5f279:	ff 15 29 07 ad 00    	call   *0xad0729(%rip)        # 152f9a8 <_DYNAMIC+0x288>
  a5f27f:	ff 15 23 07 ad 00    	call   *0xad0723(%rip)        # 152f9a8 <_DYNAMIC+0x288>
