
/tmp/gpui-ack-query-comparison/a/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a69750 <<gpui::native::accessibility::text::Cohort>::append>:
  a69750:	55                   	push   %rbp
  a69751:	41 57                	push   %r15
  a69753:	41 56                	push   %r14
  a69755:	41 55                	push   %r13
  a69757:	41 54                	push   %r12
  a69759:	53                   	push   %rbx
  a6975a:	48 81 ec 48 04 00 00 	sub    $0x448,%rsp
  a69761:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  a69766:	49 89 f4             	mov    %rsi,%r12
  a69769:	89 d0                	mov    %edx,%eax
  a6976b:	48 8b 76 38          	mov    0x38(%rsi),%rsi
  a6976f:	48 39 c6             	cmp    %rax,%rsi
  a69772:	0f 86 37 18 00 00    	jbe    a6afaf <<gpui::native::accessibility::text::Cohort>::append+0x185f>
  a69778:	48 8b 4f 10          	mov    0x10(%rdi),%rcx
  a6977c:	48 85 c9             	test   %rcx,%rcx
  a6977f:	0f 84 4b 17 00 00    	je     a6aed0 <<gpui::native::accessibility::text::Cohort>::append+0x1780>
  a69785:	4c 89 cb             	mov    %r9,%rbx
  a69788:	89 d5                	mov    %edx,%ebp
  a6978a:	4d 8b 6c 24 30       	mov    0x30(%r12),%r13
  a6978f:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  a69793:	48 c1 e0 04          	shl    $0x4,%rax
  a69797:	49 8b 54 05 20       	mov    0x20(%r13,%rax,1),%rdx
  a6979c:	4c 8b 77 08          	mov    0x8(%rdi),%r14
  a697a0:	48 83 f9 01          	cmp    $0x1,%rcx
  a697a4:	75 0b                	jne    a697b1 <<gpui::native::accessibility::text::Cohort>::append+0x61>
  a697a6:	49 39 56 08          	cmp    %rdx,0x8(%r14)
  a697aa:	74 48                	je     a697f4 <<gpui::native::accessibility::text::Cohort>::append+0xa4>
  a697ac:	e9 1f 17 00 00       	jmp    a6aed0 <<gpui::native::accessibility::text::Cohort>::append+0x1780>
  a697b1:	31 f6                	xor    %esi,%esi
  a697b3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a697ba:	84 00 00 00 00 00 
  a697c0:	48 89 f7             	mov    %rsi,%rdi
  a697c3:	49 89 ca             	mov    %rcx,%r10
  a697c6:	49 d1 ea             	shr    $1,%r10
  a697c9:	4c 01 d6             	add    %r10,%rsi
  a697cc:	4c 6b ce 38          	imul   $0x38,%rsi,%r9
  a697d0:	4b 39 54 0e 08       	cmp    %rdx,0x8(%r14,%r9,1)
  a697d5:	48 0f 47 f7          	cmova  %rdi,%rsi
  a697d9:	4c 29 d1             	sub    %r10,%rcx
  a697dc:	48 83 f9 01          	cmp    $0x1,%rcx
  a697e0:	77 de                	ja     a697c0 <<gpui::native::accessibility::text::Cohort>::append+0x70>
  a697e2:	48 6b ce 38          	imul   $0x38,%rsi,%rcx
  a697e6:	49 39 54 0e 08       	cmp    %rdx,0x8(%r14,%rcx,1)
  a697eb:	0f 85 df 16 00 00    	jne    a6aed0 <<gpui::native::accessibility::text::Cohort>::append+0x1780>
  a697f1:	49 01 ce             	add    %rcx,%r14
  a697f4:	49 01 c5             	add    %rax,%r13
  a697f7:	41 0f b6 4d 4d       	movzbl 0x4d(%r13),%ecx
  a697fc:	80 f9 01             	cmp    $0x1,%cl
  a697ff:	4c 89 84 24 28 01 00 	mov    %r8,0x128(%rsp)
  a69806:	00 
  a69807:	4c 89 a4 24 40 01 00 	mov    %r12,0x140(%rsp)
  a6980e:	00 
  a6980f:	75 4d                	jne    a6985e <<gpui::native::accessibility::text::Cohort>::append+0x10e>
  a69811:	4c 89 e7             	mov    %r12,%rdi
  a69814:	89 ee                	mov    %ebp,%esi
  a69816:	ff 15 2c 7a ac 00    	call   *0xac7a2c(%rip)        # 1531248 <_DYNAMIC+0x16a8>
  a6981c:	49 8b 75 28          	mov    0x28(%r13),%rsi
  a69820:	48 85 f6             	test   %rsi,%rsi
  a69823:	74 28                	je     a6984d <<gpui::native::accessibility::text::Cohort>::append+0xfd>
  a69825:	48 85 c0             	test   %rax,%rax
  a69828:	74 28                	je     a69852 <<gpui::native::accessibility::text::Cohort>::append+0x102>
  a6982a:	48 8b 0e             	mov    (%rsi),%rcx
  a6982d:	48 d1 e9             	shr    $1,%rcx
  a69830:	48 39 ca             	cmp    %rcx,%rdx
  a69833:	75 1d                	jne    a69852 <<gpui::native::accessibility::text::Cohort>::append+0x102>
  a69835:	48 83 c6 10          	add    $0x10,%rsi
  a69839:	48 89 c7             	mov    %rax,%rdi
  a6983c:	ff 15 86 67 ac 00    	call   *0xac6786(%rip)        # 152ffc8 <bcmp@GLIBC_2.2.5>
  a69842:	41 0f b6 4d 4d       	movzbl 0x4d(%r13),%ecx
  a69847:	85 c0                	test   %eax,%eax
  a69849:	75 1e                	jne    a69869 <<gpui::native::accessibility::text::Cohort>::append+0x119>
  a6984b:	eb 11                	jmp    a6985e <<gpui::native::accessibility::text::Cohort>::append+0x10e>
  a6984d:	48 85 c0             	test   %rax,%rax
  a69850:	74 07                	je     a69859 <<gpui::native::accessibility::text::Cohort>::append+0x109>
  a69852:	41 0f b6 4d 4d       	movzbl 0x4d(%r13),%ecx
  a69857:	eb 10                	jmp    a69869 <<gpui::native::accessibility::text::Cohort>::append+0x119>
  a69859:	41 0f b6 4d 4d       	movzbl 0x4d(%r13),%ecx
  a6985e:	8d 41 fd             	lea    -0x3(%rcx),%eax
  a69861:	3c fe                	cmp    $0xfe,%al
  a69863:	0f 83 ee 00 00 00    	jae    a69957 <<gpui::native::accessibility::text::Cohort>::append+0x207>
  a69869:	b0 03                	mov    $0x3,%al
  a6986b:	80 f9 02             	cmp    $0x2,%cl
  a6986e:	75 12                	jne    a69882 <<gpui::native::accessibility::text::Cohort>::append+0x132>
  a69870:	49 83 7d 28 00       	cmpq   $0x0,0x28(%r13)
  a69875:	b9 03 00 00 00       	mov    $0x3,%ecx
  a6987a:	b8 0e 00 00 00       	mov    $0xe,%eax
  a6987f:	0f 44 c1             	cmove  %ecx,%eax
  a69882:	48 89 1c 24          	mov    %rbx,(%rsp)
  a69886:	48 b9 57 57 57 57 57 	movabs $0x5757575757575757,%rcx
  a6988d:	57 57 57 
  a69890:	48 89 8c 24 47 03 00 	mov    %rcx,0x347(%rsp)
  a69897:	00 
  a69898:	0f 28 05 d1 38 72 ff 	movaps -0x8dc72f(%rip),%xmm0        # 18d170 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a6989f:	0f 11 84 24 38 03 00 	movups %xmm0,0x338(%rsp)
  a698a6:	00 
  a698a7:	0f 11 84 24 28 03 00 	movups %xmm0,0x328(%rsp)
  a698ae:	00 
  a698af:	0f 11 84 24 18 03 00 	movups %xmm0,0x318(%rsp)
  a698b6:	00 
  a698b7:	0f 11 84 24 08 03 00 	movups %xmm0,0x308(%rsp)
  a698be:	00 
  a698bf:	0f 11 84 24 f8 02 00 	movups %xmm0,0x2f8(%rsp)
  a698c6:	00 
  a698c7:	88 84 24 5c 03 00 00 	mov    %al,0x35c(%rsp)
  a698ce:	48 c7 84 24 50 03 00 	movq   $0x0,0x350(%rsp)
  a698d5:	00 00 00 00 00 
  a698da:	c7 84 24 58 03 00 00 	movl   $0x0,0x358(%rsp)
  a698e1:	00 00 00 00 
  a698e5:	48 c7 84 24 e0 02 00 	movq   $0x0,0x2e0(%rsp)
  a698ec:	00 00 00 00 00 
  a698f1:	48 c7 84 24 e8 02 00 	movq   $0x8,0x2e8(%rsp)
  a698f8:	00 08 00 00 00 
  a698fd:	48 c7 84 24 f0 02 00 	movq   $0x0,0x2f0(%rsp)
  a69904:	00 00 00 00 00 
  a69909:	4d 8b 65 28          	mov    0x28(%r13),%r12
  a6990d:	4d 85 e4             	test   %r12,%r12
  a69910:	0f 84 14 17 00 00    	je     a6b02a <<gpui::native::accessibility::text::Cohort>::append+0x18da>
  a69916:	4c 89 eb             	mov    %r13,%rbx
  a69919:	4d 8b 3c 24          	mov    (%r12),%r15
  a6991d:	49 d1 ef             	shr    $1,%r15
  a69920:	74 50                	je     a69972 <<gpui::native::accessibility::text::Cohort>::append+0x222>
  a69922:	ff 15 b8 64 ac 00    	call   *0xac64b8(%rip)        # 152fde0 <_DYNAMIC+0x240>
  a69928:	be 01 00 00 00       	mov    $0x1,%esi
  a6992d:	4c 89 ff             	mov    %r15,%rdi
  a69930:	ff 15 b2 64 ac 00    	call   *0xac64b2(%rip)        # 152fde8 <_DYNAMIC+0x248>
  a69936:	48 85 c0             	test   %rax,%rax
  a69939:	0f 84 19 17 00 00    	je     a6b058 <<gpui::native::accessibility::text::Cohort>::append+0x1908>
  a6993f:	49 89 c5             	mov    %rax,%r13
  a69942:	49 83 c4 10          	add    $0x10,%r12
  a69946:	48 89 c7             	mov    %rax,%rdi
  a69949:	4c 89 e6             	mov    %r12,%rsi
  a6994c:	4c 89 fa             	mov    %r15,%rdx
  a6994f:	ff 15 ab 64 ac 00    	call   *0xac64ab(%rip)        # 152fe00 <memcpy@GLIBC_2.14>
  a69955:	eb 21                	jmp    a69978 <<gpui::native::accessibility::text::Cohort>::append+0x228>
  a69957:	48 c7 84 24 c0 03 00 	movq   $0xffffffffffffffff,0x3c0(%rsp)
  a6995e:	00 ff ff ff ff 
  a69963:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  a69968:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  a6996d:	e9 f4 00 00 00       	jmp    a69a66 <<gpui::native::accessibility::text::Cohort>::append+0x316>
  a69972:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  a69978:	4c 89 bc 24 78 01 00 	mov    %r15,0x178(%rsp)
  a6997f:	00 
  a69980:	4c 89 ac 24 80 01 00 	mov    %r13,0x180(%rsp)
  a69987:	00 
  a69988:	4c 89 bc 24 88 01 00 	mov    %r15,0x188(%rsp)
  a6998f:	00 
  a69990:	c6 84 24 70 01 00 00 	movb   $0x3,0x170(%rsp)
  a69997:	03 
  a69998:	48 8d bc 24 e0 02 00 	lea    0x2e0(%rsp),%rdi
  a6999f:	00 
  a699a0:	48 8d 94 24 70 01 00 	lea    0x170(%rsp),%rdx
  a699a7:	00 
  a699a8:	be 11 00 00 00       	mov    $0x11,%esi
  a699ad:	ff 15 ad 78 ac 00    	call   *0xac78ad(%rip)        # 1531260 <_DYNAMIC+0x16c0>
  a699b3:	4c 8b a4 24 40 01 00 	mov    0x140(%rsp),%r12
  a699ba:	00 
  a699bb:	0f 10 84 24 e0 02 00 	movups 0x2e0(%rsp),%xmm0
  a699c2:	00 
  a699c3:	66 0f 10 8c 24 f0 02 	movupd 0x2f0(%rsp),%xmm1
  a699ca:	00 00 
  a699cc:	66 0f 10 94 24 00 03 	movupd 0x300(%rsp),%xmm2
  a699d3:	00 00 
  a699d5:	66 0f 10 9c 24 10 03 	movupd 0x310(%rsp),%xmm3
  a699dc:	00 00 
  a699de:	0f 29 84 24 c0 03 00 	movaps %xmm0,0x3c0(%rsp)
  a699e5:	00 
  a699e6:	66 0f 29 8c 24 d0 03 	movapd %xmm1,0x3d0(%rsp)
  a699ed:	00 00 
  a699ef:	66 0f 29 94 24 e0 03 	movapd %xmm2,0x3e0(%rsp)
  a699f6:	00 00 
  a699f8:	66 0f 29 9c 24 f0 03 	movapd %xmm3,0x3f0(%rsp)
  a699ff:	00 00 
  a69a01:	0f 10 84 24 20 03 00 	movups 0x320(%rsp),%xmm0
  a69a08:	00 
  a69a09:	0f 29 84 24 00 04 00 	movaps %xmm0,0x400(%rsp)
  a69a10:	00 
  a69a11:	0f 10 84 24 30 03 00 	movups 0x330(%rsp),%xmm0
  a69a18:	00 
  a69a19:	0f 29 84 24 10 04 00 	movaps %xmm0,0x410(%rsp)
  a69a20:	00 
  a69a21:	0f 10 84 24 40 03 00 	movups 0x340(%rsp),%xmm0
  a69a28:	00 
  a69a29:	0f 29 84 24 20 04 00 	movaps %xmm0,0x420(%rsp)
  a69a30:	00 
  a69a31:	66 0f 10 84 24 50 03 	movupd 0x350(%rsp),%xmm0
  a69a38:	00 00 
  a69a3a:	48 83 bc 24 c0 03 00 	cmpq   $0xffffffffffffffff,0x3c0(%rsp)
  a69a41:	00 ff 
  a69a43:	66 0f 29 84 24 30 04 	movapd %xmm0,0x430(%rsp)
  a69a4a:	00 00 
  a69a4c:	48 8d 84 24 c0 03 00 	lea    0x3c0(%rsp),%rax
  a69a53:	00 
  a69a54:	48 0f 44 44 24 30    	cmove  0x30(%rsp),%rax
  a69a5a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  a69a5f:	49 89 dd             	mov    %rbx,%r13
  a69a62:	48 8b 1c 24          	mov    (%rsp),%rbx
  a69a66:	49 8b 4c 24 40       	mov    0x40(%r12),%rcx
  a69a6b:	48 85 c9             	test   %rcx,%rcx
  a69a6e:	0f 84 4b 15 00 00    	je     a6afbf <<gpui::native::accessibility::text::Cohort>::append+0x186f>
  a69a74:	48 8b 41 08          	mov    0x8(%rcx),%rax
  a69a78:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  a69a7c:	48 83 f9 01          	cmp    $0x1,%rcx
  a69a80:	74 44                	je     a69ac6 <<gpui::native::accessibility::text::Cohort>::append+0x376>
  a69a82:	48 85 c9             	test   %rcx,%rcx
  a69a85:	0f 84 34 15 00 00    	je     a6afbf <<gpui::native::accessibility::text::Cohort>::append+0x186f>
  a69a8b:	31 d2                	xor    %edx,%edx
  a69a8d:	0f 1f 00             	nopl   (%rax)
  a69a90:	48 89 d6             	mov    %rdx,%rsi
  a69a93:	48 89 cf             	mov    %rcx,%rdi
  a69a96:	48 d1 ef             	shr    $1,%rdi
  a69a99:	48 01 fa             	add    %rdi,%rdx
  a69a9c:	4c 8d 04 52          	lea    (%rdx,%rdx,2),%r8
  a69aa0:	42 3b 6c c0 10       	cmp    0x10(%rax,%r8,8),%ebp
  a69aa5:	48 0f 42 d6          	cmovb  %rsi,%rdx
  a69aa9:	48 29 f9             	sub    %rdi,%rcx
  a69aac:	48 83 f9 01          	cmp    $0x1,%rcx
  a69ab0:	77 de                	ja     a69a90 <<gpui::native::accessibility::text::Cohort>::append+0x340>
  a69ab2:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  a69ab6:	3b 6c c8 10          	cmp    0x10(%rax,%rcx,8),%ebp
  a69aba:	0f 85 ff 14 00 00    	jne    a6afbf <<gpui::native::accessibility::text::Cohort>::append+0x186f>
  a69ac0:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  a69ac4:	eb 09                	jmp    a69acf <<gpui::native::accessibility::text::Cohort>::append+0x37f>
  a69ac6:	3b 68 10             	cmp    0x10(%rax),%ebp
  a69ac9:	0f 85 f0 14 00 00    	jne    a6afbf <<gpui::native::accessibility::text::Cohort>::append+0x186f>
  a69acf:	f3 41 0f 10 45 30    	movss  0x30(%r13),%xmm0
  a69ad5:	0f 29 04 24          	movaps %xmm0,(%rsp)
  a69ad9:	0f 2e c0             	ucomiss %xmm0,%xmm0
  a69adc:	0f 8a 24 01 00 00    	jp     a69c06 <<gpui::native::accessibility::text::Cohort>::append+0x4b6>
  a69ae2:	f2 0f 10 40 08       	movsd  0x8(%rax),%xmm0
  a69ae7:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  a69aee:	00 
  a69aef:	f3 41 0f 10 45 3c    	movss  0x3c(%r13),%xmm0
  a69af5:	0f 29 84 24 20 02 00 	movaps %xmm0,0x220(%rsp)
  a69afc:	00 
  a69afd:	f2 41 0f 10 45 40    	movsd  0x40(%r13),%xmm0
  a69b03:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  a69b0a:	00 
  a69b0b:	f2 41 0f 10 45 34    	movsd  0x34(%r13),%xmm0
  a69b11:	66 0f 29 84 24 10 01 	movapd %xmm0,0x110(%rsp)
  a69b18:	00 00 
  a69b1a:	ff 15 c0 62 ac 00    	call   *0xac62c0(%rip)        # 152fde0 <_DYNAMIC+0x240>
  a69b20:	bf 30 00 00 00       	mov    $0x30,%edi
  a69b25:	be 08 00 00 00       	mov    $0x8,%esi
  a69b2a:	ff 15 b8 62 ac 00    	call   *0xac62b8(%rip)        # 152fde8 <_DYNAMIC+0x248>
  a69b30:	48 85 c0             	test   %rax,%rax
  a69b33:	0f 84 e5 13 00 00    	je     a6af1e <<gpui::native::accessibility::text::Cohort>::append+0x17ce>
  a69b39:	0f 28 04 24          	movaps (%rsp),%xmm0
  a69b3d:	0f 14 84 24 20 02 00 	unpcklps 0x220(%rsp),%xmm0
  a69b44:	00 
  a69b45:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  a69b48:	0f 5a 9c 24 f0 00 00 	cvtps2pd 0xf0(%rsp),%xmm3
  a69b4f:	00 
  a69b50:	0f 5a 8c 24 10 01 00 	cvtps2pd 0x110(%rsp),%xmm1
  a69b57:	00 
  a69b58:	0f 5a 94 24 00 01 00 	cvtps2pd 0x100(%rsp),%xmm2
  a69b5f:	00 
  a69b60:	66 0f 13 00          	movlpd %xmm0,(%rax)
  a69b64:	66 0f 11 48 08       	movupd %xmm1,0x8(%rax)
  a69b69:	66 0f 17 40 18       	movhpd %xmm0,0x18(%rax)
  a69b6e:	66 0f 59 cb          	mulpd  %xmm3,%xmm1
  a69b72:	66 0f c6 c9 01       	shufpd $0x1,%xmm1,%xmm1
  a69b77:	66 0f 29 1c 24       	movapd %xmm3,(%rsp)
  a69b7c:	66 0f 59 c3          	mulpd  %xmm3,%xmm0
  a69b80:	66 0f 58 c1          	addpd  %xmm1,%xmm0
  a69b84:	66 0f 58 c2          	addpd  %xmm2,%xmm0
  a69b88:	66 0f 11 40 20       	movupd %xmm0,0x20(%rax)
  a69b8d:	48 89 84 24 e8 02 00 	mov    %rax,0x2e8(%rsp)
  a69b94:	00 
  a69b95:	c6 84 24 e0 02 00 00 	movb   $0x19,0x2e0(%rsp)
  a69b9c:	19 
  a69b9d:	c6 84 24 10 01 00 00 	movb   $0x1,0x110(%rsp)
  a69ba4:	01 
  a69ba5:	48 8d 94 24 e0 02 00 	lea    0x2e0(%rsp),%rdx
  a69bac:	00 
  a69bad:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  a69bb2:	be 52 00 00 00       	mov    $0x52,%esi
  a69bb7:	ff 15 a3 76 ac 00    	call   *0xac76a3(%rip)        # 1531260 <_DYNAMIC+0x16c0>
  a69bbd:	41 0f 5a 45 00       	cvtps2pd 0x0(%r13),%xmm0
  a69bc2:	66 0f 28 c8          	movapd %xmm0,%xmm1
  a69bc6:	66 0f 28 14 24       	movapd (%rsp),%xmm2
  a69bcb:	66 0f 5c ca          	subpd  %xmm2,%xmm1
  a69bcf:	66 0f 29 8c 24 e0 02 	movapd %xmm1,0x2e0(%rsp)
  a69bd6:	00 00 
  a69bd8:	41 0f 5a 4d 08       	cvtps2pd 0x8(%r13),%xmm1
  a69bdd:	66 0f 58 c8          	addpd  %xmm0,%xmm1
  a69be1:	66 0f 5c ca          	subpd  %xmm2,%xmm1
  a69be5:	66 0f 29 8c 24 f0 02 	movapd %xmm1,0x2f0(%rsp)
  a69bec:	00 00 
  a69bee:	48 8d 94 24 e0 02 00 	lea    0x2e0(%rsp),%rdx
  a69bf5:	00 
  a69bf6:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  a69bfb:	be 53 00 00 00       	mov    $0x53,%esi
  a69c00:	ff 15 72 76 ac 00    	call   *0xac7672(%rip)        # 1531278 <_DYNAMIC+0x16d8>
  a69c06:	c6 84 24 10 01 00 00 	movb   $0x1,0x110(%rsp)
  a69c0d:	01 
  a69c0e:	40 b5 01             	mov    $0x1,%bpl
  a69c11:	48 85 db             	test   %rbx,%rbx
  a69c14:	74 15                	je     a69c2b <<gpui::native::accessibility::text::Cohort>::append+0x4db>
  a69c16:	49 8b 46 28          	mov    0x28(%r14),%rax
  a69c1a:	48 39 03             	cmp    %rax,(%rbx)
  a69c1d:	0f 96 c1             	setbe  %cl
  a69c20:	48 3b 43 08          	cmp    0x8(%rbx),%rax
  a69c24:	40 0f 92 c5          	setb   %bpl
  a69c28:	40 20 cd             	and    %cl,%bpl
  a69c2b:	49 8b 36             	mov    (%r14),%rsi
  a69c2e:	48 83 c6 10          	add    $0x10,%rsi
  a69c32:	48 8d bc 24 70 01 00 	lea    0x170(%rsp),%rdi
  a69c39:	00 
  a69c3a:	48 89 b4 24 d0 02 00 	mov    %rsi,0x2d0(%rsp)
  a69c41:	00 
  a69c42:	ff 15 08 6a ac 00    	call   *0xac6a08(%rip)        # 1530650 <_DYNAMIC+0xab0>
  a69c48:	48 8d bc 24 18 03 00 	lea    0x318(%rsp),%rdi
  a69c4f:	00 
  a69c50:	48 8d b4 24 70 01 00 	lea    0x170(%rsp),%rsi
  a69c57:	00 
  a69c58:	ba a8 00 00 00       	mov    $0xa8,%edx
  a69c5d:	ff 15 9d 61 ac 00    	call   *0xac619d(%rip)        # 152fe00 <memcpy@GLIBC_2.14>
  a69c63:	48 c7 84 24 10 03 00 	movq   $0x0,0x310(%rsp)
  a69c6a:	00 00 00 00 00 
  a69c6f:	c6 84 24 08 03 00 00 	movb   $0xff,0x308(%rsp)
  a69c76:	ff 
  a69c77:	40 84 ed             	test   %bpl,%bpl
  a69c7a:	0f 84 44 0f 00 00    	je     a6abc4 <<gpui::native::accessibility::text::Cohort>::append+0x1474>
  a69c80:	b2 ff                	mov    $0xff,%dl
  a69c82:	48 8d bc 24 70 01 00 	lea    0x170(%rsp),%rdi
  a69c89:	00 
  a69c8a:	48 8b 1d bf 75 ac 00 	mov    0xac75bf(%rip),%rbx        # 1531250 <_DYNAMIC+0x16b0>
  a69c91:	31 ed                	xor    %ebp,%ebp
  a69c93:	4c 89 ac 24 c8 02 00 	mov    %r13,0x2c8(%rsp)
  a69c9a:	00 
  a69c9b:	48 8b 8c 24 e0 02 00 	mov    0x2e0(%rsp),%rcx
  a69ca2:	00 
  a69ca3:	f2 0f 10 84 24 e8 02 	movsd  0x2e8(%rsp),%xmm0
  a69caa:	00 00 
  a69cac:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  a69cb3:	00 
  a69cb4:	f2 0f 10 84 24 f0 02 	movsd  0x2f0(%rsp),%xmm0
  a69cbb:	00 00 
  a69cbd:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  a69cc4:	00 
  a69cc5:	4c 8b bc 24 f8 02 00 	mov    0x2f8(%rsp),%r15
  a69ccc:	00 
  a69ccd:	48 8b 84 24 00 03 00 	mov    0x300(%rsp),%rax
  a69cd4:	00 
  a69cd5:	48 89 04 24          	mov    %rax,(%rsp)
  a69cd9:	c6 84 24 08 03 00 00 	movb   $0xff,0x308(%rsp)
  a69ce0:	ff 
  a69ce1:	80 fa ff             	cmp    $0xff,%dl
  a69ce4:	74 0d                	je     a69cf3 <<gpui::native::accessibility::text::Cohort>::append+0x5a3>
  a69ce6:	0f b6 c2             	movzbl %dl,%eax
  a69ce9:	83 f8 02             	cmp    $0x2,%eax
  a69cec:	75 6d                	jne    a69d5b <<gpui::native::accessibility::text::Cohort>::append+0x60b>
  a69cee:	e9 57 0f 00 00       	jmp    a6ac4a <<gpui::native::accessibility::text::Cohort>::append+0x14fa>
  a69cf3:	48 8d b4 24 18 03 00 	lea    0x318(%rsp),%rsi
  a69cfa:	00 
  a69cfb:	e8 30 ef ff ff       	call   a68c30 <<gpui_canvas::text::layout::TextGeometry>::runs::{closure#2}>
  a69d00:	0f b6 94 24 90 01 00 	movzbl 0x190(%rsp),%edx
  a69d07:	00 
  a69d08:	80 fa 02             	cmp    $0x2,%dl
  a69d0b:	0f 84 39 0f 00 00    	je     a6ac4a <<gpui::native::accessibility::text::Cohort>::append+0x14fa>
  a69d11:	f2 0f 10 84 24 70 01 	movsd  0x170(%rsp),%xmm0
  a69d18:	00 00 
  a69d1a:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  a69d21:	00 
  a69d22:	f2 0f 10 84 24 78 01 	movsd  0x178(%rsp),%xmm0
  a69d29:	00 00 
  a69d2b:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  a69d32:	00 
  a69d33:	4c 8b bc 24 80 01 00 	mov    0x180(%rsp),%r15
  a69d3a:	00 
  a69d3b:	48 8b 84 24 88 01 00 	mov    0x188(%rsp),%rax
  a69d42:	00 
  a69d43:	48 89 04 24          	mov    %rax,(%rsp)
  a69d47:	48 8b 8c 24 10 03 00 	mov    0x310(%rsp),%rcx
  a69d4e:	00 
  a69d4f:	48 8d 41 01          	lea    0x1(%rcx),%rax
  a69d53:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  a69d5a:	00 
  a69d5b:	88 94 24 20 02 00 00 	mov    %dl,0x220(%rsp)
  a69d62:	49 8b 46 28          	mov    0x28(%r14),%rax
  a69d66:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
  a69d6d:	00 
  a69d6e:	48 89 8c 24 18 02 00 	mov    %rcx,0x218(%rsp)
  a69d75:	00 
  a69d76:	48 8d 14 08          	lea    (%rax,%rcx,1),%rdx
  a69d7a:	48 ff c2             	inc    %rdx
  a69d7d:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  a69d82:	31 f6                	xor    %esi,%esi
  a69d84:	48 89 94 24 c0 02 00 	mov    %rdx,0x2c0(%rsp)
  a69d8b:	00 
  a69d8c:	ff d3                	call   *%rbx
  a69d8e:	48 89 ac 24 b8 02 00 	mov    %rbp,0x2b8(%rsp)
  a69d95:	00 
  a69d96:	4c 89 bc 24 30 01 00 	mov    %r15,0x130(%rsp)
  a69d9d:	00 
  a69d9e:	4d 8b 65 28          	mov    0x28(%r13),%r12
  a69da2:	4d 85 e4             	test   %r12,%r12
  a69da5:	48 8b 14 24          	mov    (%rsp),%rdx
  a69da9:	0f 84 51 12 00 00    	je     a6b000 <<gpui::native::accessibility::text::Cohort>::append+0x18b0>
  a69daf:	49 8b 34 24          	mov    (%r12),%rsi
  a69db3:	48 d1 ee             	shr    $1,%rsi
  a69db6:	49 83 c4 10          	add    $0x10,%r12
  a69dba:	48 89 d5             	mov    %rdx,%rbp
  a69dbd:	48 c1 ed 20          	shr    $0x20,%rbp
  a69dc1:	41 89 d7             	mov    %edx,%r15d
  a69dc4:	39 ea                	cmp    %ebp,%edx
  a69dc6:	0f 87 19 12 00 00    	ja     a6afe5 <<gpui::native::accessibility::text::Cohort>::append+0x1895>
  a69dcc:	f3 41 0f 10 45 30    	movss  0x30(%r13),%xmm0
  a69dd2:	f3 0f 11 84 24 4c 01 	movss  %xmm0,0x14c(%rsp)
  a69dd9:	00 00 
  a69ddb:	85 d2                	test   %edx,%edx
  a69ddd:	74 17                	je     a69df6 <<gpui::native::accessibility::text::Cohort>::append+0x6a6>
  a69ddf:	4c 39 fe             	cmp    %r15,%rsi
  a69de2:	76 0c                	jbe    a69df0 <<gpui::native::accessibility::text::Cohort>::append+0x6a0>
  a69de4:	43 80 3c 3c c0       	cmpb   $0xc0,(%r12,%r15,1)
  a69de9:	7d 0b                	jge    a69df6 <<gpui::native::accessibility::text::Cohort>::append+0x6a6>
  a69deb:	e9 f5 11 00 00       	jmp    a6afe5 <<gpui::native::accessibility::text::Cohort>::append+0x1895>
  a69df0:	0f 85 ef 11 00 00    	jne    a6afe5 <<gpui::native::accessibility::text::Cohort>::append+0x1895>
  a69df6:	48 85 ed             	test   %rbp,%rbp
  a69df9:	74 17                	je     a69e12 <<gpui::native::accessibility::text::Cohort>::append+0x6c2>
  a69dfb:	48 39 ee             	cmp    %rbp,%rsi
  a69dfe:	76 0c                	jbe    a69e0c <<gpui::native::accessibility::text::Cohort>::append+0x6bc>
  a69e00:	41 80 3c 2c c0       	cmpb   $0xc0,(%r12,%rbp,1)
  a69e05:	7d 0b                	jge    a69e12 <<gpui::native::accessibility::text::Cohort>::append+0x6c2>
  a69e07:	e9 d9 11 00 00       	jmp    a6afe5 <<gpui::native::accessibility::text::Cohort>::append+0x1895>
  a69e0c:	0f 85 d3 11 00 00    	jne    a6afe5 <<gpui::native::accessibility::text::Cohort>::append+0x1895>
  a69e12:	48 89 eb             	mov    %rbp,%rbx
  a69e15:	48 b8 57 57 57 57 57 	movabs $0x5757575757575757,%rax
  a69e1c:	57 57 57 
  a69e1f:	48 8d 8c 24 48 02 00 	lea    0x248(%rsp),%rcx
  a69e26:	00 
  a69e27:	48 89 41 4f          	mov    %rax,0x4f(%rcx)
  a69e2b:	0f 28 05 3e 33 72 ff 	movaps -0x8dccc2(%rip),%xmm0        # 18d170 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a69e32:	0f 11 41 40          	movups %xmm0,0x40(%rcx)
  a69e36:	0f 11 41 30          	movups %xmm0,0x30(%rcx)
  a69e3a:	0f 11 41 20          	movups %xmm0,0x20(%rcx)
  a69e3e:	0f 11 41 10          	movups %xmm0,0x10(%rcx)
  a69e42:	0f 11 01             	movups %xmm0,(%rcx)
  a69e45:	c6 84 24 ac 02 00 00 	movb   $0x1,0x2ac(%rsp)
  a69e4c:	01 
  a69e4d:	48 c7 84 24 a0 02 00 	movq   $0x0,0x2a0(%rsp)
  a69e54:	00 00 00 00 00 
  a69e59:	c7 84 24 a8 02 00 00 	movl   $0x0,0x2a8(%rsp)
  a69e60:	00 00 00 00 
  a69e64:	48 c7 84 24 30 02 00 	movq   $0x0,0x230(%rsp)
  a69e6b:	00 00 00 00 00 
  a69e70:	48 c7 84 24 38 02 00 	movq   $0x8,0x238(%rsp)
  a69e77:	00 08 00 00 00 
  a69e7c:	48 c7 84 24 40 02 00 	movq   $0x0,0x240(%rsp)
  a69e83:	00 00 00 00 00 
  a69e88:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  a69e8e:	4c 29 fb             	sub    %r15,%rbx
  a69e91:	74 24                	je     a69eb7 <<gpui::native::accessibility::text::Cohort>::append+0x767>
  a69e93:	ff 15 47 5f ac 00    	call   *0xac5f47(%rip)        # 152fde0 <_DYNAMIC+0x240>
  a69e99:	be 01 00 00 00       	mov    $0x1,%esi
  a69e9e:	48 89 df             	mov    %rbx,%rdi
  a69ea1:	ff 15 41 5f ac 00    	call   *0xac5f41(%rip)        # 152fde8 <_DYNAMIC+0x248>
  a69ea7:	48 85 c0             	test   %rax,%rax
  a69eaa:	0f 84 89 11 00 00    	je     a6b039 <<gpui::native::accessibility::text::Cohort>::append+0x18e9>
  a69eb0:	49 89 c5             	mov    %rax,%r13
  a69eb3:	48 8b 14 24          	mov    (%rsp),%rdx
  a69eb7:	4d 01 e7             	add    %r12,%r15
  a69eba:	39 d5                	cmp    %edx,%ebp
  a69ebc:	74 0f                	je     a69ecd <<gpui::native::accessibility::text::Cohort>::append+0x77d>
  a69ebe:	4c 89 ef             	mov    %r13,%rdi
  a69ec1:	4c 89 fe             	mov    %r15,%rsi
  a69ec4:	48 89 da             	mov    %rbx,%rdx
  a69ec7:	ff 15 33 5f ac 00    	call   *0xac5f33(%rip)        # 152fe00 <memcpy@GLIBC_2.14>
  a69ecd:	48 89 9c 24 78 01 00 	mov    %rbx,0x178(%rsp)
  a69ed4:	00 
  a69ed5:	4c 89 ac 24 80 01 00 	mov    %r13,0x180(%rsp)
  a69edc:	00 
  a69edd:	48 89 9c 24 88 01 00 	mov    %rbx,0x188(%rsp)
  a69ee4:	00 
  a69ee5:	c6 84 24 70 01 00 00 	movb   $0x3,0x170(%rsp)
  a69eec:	03 
  a69eed:	48 8d bc 24 30 02 00 	lea    0x230(%rsp),%rdi
  a69ef4:	00 
  a69ef5:	be 11 00 00 00       	mov    $0x11,%esi
  a69efa:	48 8d 94 24 70 01 00 	lea    0x170(%rsp),%rdx
  a69f01:	00 
  a69f02:	ff 15 58 73 ac 00    	call   *0xac7358(%rip)        # 1531260 <_DYNAMIC+0x16c0>
  a69f08:	49 01 ec             	add    %rbp,%r12
  a69f0b:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  a69f12:	00 00 
  a69f14:	48 c7 44 24 48 08 00 	movq   $0x8,0x48(%rsp)
  a69f1b:	00 00 
  a69f1d:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  a69f24:	00 00 
  a69f26:	c7 44 24 60 ff ff ff 	movl   $0xffffffff,0x60(%rsp)
  a69f2d:	ff 
  a69f2e:	4c 89 7c 24 68       	mov    %r15,0x68(%rsp)
  a69f33:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  a69f38:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
  a69f3f:	00 00 
  a69f41:	48 8d 05 18 80 a5 00 	lea    0xa58018(%rip),%rax        # 14c1f60 <anon.fc2f92b0223d15b7043d040ea72c4e93.10.llvm.5483804487471879235+0x78>
  a69f48:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  a69f4f:	00 
  a69f50:	48 8d 05 09 eb ff ff 	lea    -0x14f7(%rip),%rax        # a68a60 <icu_segmenter::rule_segmenter_v1::empty_handle_complex::<icu_segmenter::scaffold::Utf8>>
  a69f57:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  a69f5e:	00 
  a69f5f:	48 89 9c 24 90 00 00 	mov    %rbx,0x90(%rsp)
  a69f66:	00 
  a69f67:	48 c7 84 24 98 00 00 	movq   $0x0,0x98(%rsp)
  a69f6e:	00 00 00 00 00 
  a69f73:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  a69f7a:	00 00 00 00 00 
  a69f7f:	c6 84 24 d0 00 00 00 	movb   $0x0,0xd0(%rsp)
  a69f86:	00 
  a69f87:	4c 8d 7c 24 40       	lea    0x40(%rsp),%r15
  a69f8c:	4c 89 ff             	mov    %r15,%rdi
  a69f8f:	e8 bc 1e 00 00       	call   a6be50 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  a69f94:	4c 8b ac 24 c8 02 00 	mov    0x2c8(%rsp),%r13
  a69f9b:	00 
  a69f9c:	a8 01                	test   $0x1,%al
  a69f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  a69fa3:	48 0f 44 d0          	cmove  %rax,%rdx
  a69fa7:	48 89 94 24 50 01 00 	mov    %rdx,0x150(%rsp)
  a69fae:	00 
  a69faf:	ba 98 00 00 00       	mov    $0x98,%edx
  a69fb4:	48 8d 9c 24 70 01 00 	lea    0x170(%rsp),%rbx
  a69fbb:	00 
  a69fbc:	48 89 df             	mov    %rbx,%rdi
  a69fbf:	4c 89 fe             	mov    %r15,%rsi
  a69fc2:	ff 15 38 5e ac 00    	call   *0xac5e38(%rip)        # 152fe00 <memcpy@GLIBC_2.14>
  a69fc8:	48 8d 84 24 50 01 00 	lea    0x150(%rsp),%rax
  a69fcf:	00 
  a69fd0:	48 89 84 24 08 02 00 	mov    %rax,0x208(%rsp)
  a69fd7:	00 
  a69fd8:	48 8d bc 24 30 02 00 	lea    0x230(%rsp),%rdi
  a69fdf:	00 
  a69fe0:	48 89 de             	mov    %rbx,%rsi
  a69fe3:	e8 b8 75 ff ff       	call   a615a0 <<accesskit::Node>::set_text_character_lengths::<core::iter::adapters::map::Map<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui::native::accessibility::text::text_run::{closure#0}>>>
  a69fe8:	4c 8b 25 f1 5d ac 00 	mov    0xac5df1(%rip),%r12        # 152fde0 <_DYNAMIC+0x240>
  a69fef:	84 c0                	test   %al,%al
  a69ff1:	0f 84 44 0f 00 00    	je     a6af3b <<gpui::native::accessibility::text::Cohort>::append+0x17eb>
  a69ff7:	f3 0f 10 84 24 4c 01 	movss  0x14c(%rsp),%xmm0
  a69ffe:	00 00 
  a6a000:	0f 2e c0             	ucomiss %xmm0,%xmm0
  a6a003:	0f 10 84 24 a0 02 00 	movups 0x2a0(%rsp),%xmm0
  a6a00a:	00 
  a6a00b:	0f 29 84 24 e0 01 00 	movaps %xmm0,0x1e0(%rsp)
  a6a012:	00 
  a6a013:	0f 10 84 24 90 02 00 	movups 0x290(%rsp),%xmm0
  a6a01a:	00 
  a6a01b:	0f 29 84 24 d0 01 00 	movaps %xmm0,0x1d0(%rsp)
  a6a022:	00 
  a6a023:	0f 10 84 24 80 02 00 	movups 0x280(%rsp),%xmm0
  a6a02a:	00 
  a6a02b:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  a6a032:	00 
  a6a033:	0f 10 84 24 70 02 00 	movups 0x270(%rsp),%xmm0
  a6a03a:	00 
  a6a03b:	0f 29 84 24 b0 01 00 	movaps %xmm0,0x1b0(%rsp)
  a6a042:	00 
  a6a043:	0f 10 84 24 30 02 00 	movups 0x230(%rsp),%xmm0
  a6a04a:	00 
  a6a04b:	0f 10 8c 24 40 02 00 	movups 0x240(%rsp),%xmm1
  a6a052:	00 
  a6a053:	66 0f 10 94 24 50 02 	movupd 0x250(%rsp),%xmm2
  a6a05a:	00 00 
  a6a05c:	66 0f 10 9c 24 60 02 	movupd 0x260(%rsp),%xmm3
  a6a063:	00 00 
  a6a065:	66 0f 29 9c 24 a0 01 	movapd %xmm3,0x1a0(%rsp)
  a6a06c:	00 00 
  a6a06e:	66 0f 29 94 24 90 01 	movapd %xmm2,0x190(%rsp)
  a6a075:	00 00 
  a6a077:	0f 29 8c 24 80 01 00 	movaps %xmm1,0x180(%rsp)
  a6a07e:	00 
  a6a07f:	0f 29 84 24 70 01 00 	movaps %xmm0,0x170(%rsp)
  a6a086:	00 
  a6a087:	0f 8a b8 0a 00 00    	jp     a6ab45 <<gpui::native::accessibility::text::Cohort>::append+0x13f5>
  a6a08d:	0f 5a 84 24 00 01 00 	cvtps2pd 0x100(%rsp),%xmm0
  a6a094:	00 
  a6a095:	0f 5a 8c 24 f0 00 00 	cvtps2pd 0xf0(%rsp),%xmm1
  a6a09c:	00 
  a6a09d:	66 0f 29 44 24 40    	movapd %xmm0,0x40(%rsp)
  a6a0a3:	66 0f 58 c8          	addpd  %xmm0,%xmm1
  a6a0a7:	66 0f 29 4c 24 50    	movapd %xmm1,0x50(%rsp)
  a6a0ad:	48 89 df             	mov    %rbx,%rdi
  a6a0b0:	be 53 00 00 00       	mov    $0x53,%esi
  a6a0b5:	4c 89 fa             	mov    %r15,%rdx
  a6a0b8:	ff 15 ba 71 ac 00    	call   *0xac71ba(%rip)        # 1531278 <_DYNAMIC+0x16d8>
  a6a0be:	0f b6 84 24 20 02 00 	movzbl 0x220(%rsp),%eax
  a6a0c5:	00 
  a6a0c6:	88 44 24 41          	mov    %al,0x41(%rsp)
  a6a0ca:	c6 44 24 40 10       	movb   $0x10,0x40(%rsp)
  a6a0cf:	48 89 df             	mov    %rbx,%rdi
  a6a0d2:	be 49 00 00 00       	mov    $0x49,%esi
  a6a0d7:	4c 89 fa             	mov    %r15,%rdx
  a6a0da:	ff 15 80 71 ac 00    	call   *0xac7180(%rip)        # 1531260 <_DYNAMIC+0x16c0>
  a6a0e0:	0f b6 bc 24 c8 01 00 	movzbl 0x1c8(%rsp),%edi
  a6a0e7:	00 
  a6a0e8:	48 8d 05 21 88 73 ff 	lea    -0x8c77df(%rip),%rax        # 1a2910 <anon.5d7b745689a4da2246def3d316fdcab4.1.llvm.18443242379705941574+0x56e4>
  a6a0ef:	48 83 ff 57          	cmp    $0x57,%rdi
  a6a0f3:	74 21                	je     a6a116 <<gpui::native::accessibility::text::Cohort>::append+0x9c6>
  a6a0f5:	48 8b b4 24 80 01 00 	mov    0x180(%rsp),%rsi
  a6a0fc:	00 
  a6a0fd:	48 39 fe             	cmp    %rdi,%rsi
  a6a100:	0f 86 43 0f 00 00    	jbe    a6b049 <<gpui::native::accessibility::text::Cohort>::append+0x18f9>
  a6a106:	48 8b 84 24 78 01 00 	mov    0x178(%rsp),%rax
  a6a10d:	00 
  a6a10e:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  a6a112:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  a6a116:	0f b6 08             	movzbl (%rax),%ecx
  a6a119:	83 f9 09             	cmp    $0x9,%ecx
  a6a11c:	74 22                	je     a6a140 <<gpui::native::accessibility::text::Cohort>::append+0x9f0>
  a6a11e:	83 f9 0a             	cmp    $0xa,%ecx
  a6a121:	48 ba fc ff ff ff ff 	movabs $0x7ffffffffffffffc,%rdx
  a6a128:	ff ff 7f 
  a6a12b:	75 23                	jne    a6a150 <<gpui::native::accessibility::text::Cohort>::append+0xa00>
  a6a12d:	48 8b 48 18          	mov    0x18(%rax),%rcx
  a6a131:	48 3b 48 10          	cmp    0x10(%rax),%rcx
  a6a135:	be 00 00 00 00       	mov    $0x0,%esi
  a6a13a:	48 0f 46 f1          	cmovbe %rcx,%rsi
  a6a13e:	eb 12                	jmp    a6a152 <<gpui::native::accessibility::text::Cohort>::append+0xa02>
  a6a140:	48 8b 70 18          	mov    0x18(%rax),%rsi
  a6a144:	48 ba fc ff ff ff ff 	movabs $0x7ffffffffffffffc,%rdx
  a6a14b:	ff ff 7f 
  a6a14e:	eb 02                	jmp    a6a152 <<gpui::native::accessibility::text::Cohort>::append+0xa02>
  a6a150:	31 f6                	xor    %esi,%esi
  a6a152:	48 89 b4 24 d8 02 00 	mov    %rsi,0x2d8(%rsp)
  a6a159:	00 
  a6a15a:	48 8d 1c b5 00 00 00 	lea    0x0(,%rsi,4),%rbx
  a6a161:	00 
  a6a162:	48 89 f0             	mov    %rsi,%rax
  a6a165:	48 c1 e8 3e          	shr    $0x3e,%rax
  a6a169:	0f 95 c0             	setne  %al
  a6a16c:	48 39 d3             	cmp    %rdx,%rbx
  a6a16f:	0f 97 c1             	seta   %cl
  a6a172:	08 c1                	or     %al,%cl
  a6a174:	0f 85 89 0c 00 00    	jne    a6ae03 <<gpui::native::accessibility::text::Cohort>::append+0x16b3>
  a6a17a:	48 85 db             	test   %rbx,%rbx
  a6a17d:	74 5d                	je     a6a1dc <<gpui::native::accessibility::text::Cohort>::append+0xa8c>
  a6a17f:	4c 89 e0             	mov    %r12,%rax
  a6a182:	49 89 f4             	mov    %rsi,%r12
  a6a185:	ff d0                	call   *%rax
  a6a187:	be 04 00 00 00       	mov    $0x4,%esi
  a6a18c:	48 89 df             	mov    %rbx,%rdi
  a6a18f:	4c 8b 3d 52 5c ac 00 	mov    0xac5c52(%rip),%r15        # 152fde8 <_DYNAMIC+0x248>
  a6a196:	41 ff d7             	call   *%r15
  a6a199:	48 85 c0             	test   %rax,%rax
  a6a19c:	0f 84 c6 0e 00 00    	je     a6b068 <<gpui::native::accessibility::text::Cohort>::append+0x1918>
  a6a1a2:	4c 89 64 24 18       	mov    %r12,0x18(%rsp)
  a6a1a7:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  a6a1ae:	00 
  a6a1af:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  a6a1b4:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  a6a1bb:	00 00 
  a6a1bd:	ff 15 1d 5c ac 00    	call   *0xac5c1d(%rip)        # 152fde0 <_DYNAMIC+0x240>
  a6a1c3:	be 04 00 00 00       	mov    $0x4,%esi
  a6a1c8:	48 89 df             	mov    %rbx,%rdi
  a6a1cb:	41 ff d7             	call   *%r15
  a6a1ce:	48 85 c0             	test   %rax,%rax
  a6a1d1:	0f 84 a3 0e 00 00    	je     a6b07a <<gpui::native::accessibility::text::Cohort>::append+0x192a>
  a6a1d7:	4c 89 e6             	mov    %r12,%rsi
  a6a1da:	eb 28                	jmp    a6a204 <<gpui::native::accessibility::text::Cohort>::append+0xab4>
  a6a1dc:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  a6a1e3:	00 00 
  a6a1e5:	48 c7 44 24 20 04 00 	movq   $0x4,0x20(%rsp)
  a6a1ec:	00 00 
  a6a1ee:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  a6a1f5:	00 00 
  a6a1f7:	b8 04 00 00 00       	mov    $0x4,%eax
  a6a1fc:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  a6a203:	00 
  a6a204:	48 8b 14 24          	mov    (%rsp),%rdx
  a6a208:	49 89 f7             	mov    %rsi,%r15
  a6a20b:	48 89 b4 24 d8 00 00 	mov    %rsi,0xd8(%rsp)
  a6a212:	00 
  a6a213:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  a6a21a:	00 
  a6a21b:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  a6a222:	00 00 00 00 00 
  a6a227:	41 b4 01             	mov    $0x1,%r12b
  a6a22a:	48 8d bc 24 30 02 00 	lea    0x230(%rsp),%rdi
  a6a231:	00 
  a6a232:	48 8b b4 24 d0 02 00 	mov    0x2d0(%rsp),%rsi
  a6a239:	00 
  a6a23a:	89 e9                	mov    %ebp,%ecx
  a6a23c:	ff 15 3e 71 ac 00    	call   *0xac713e(%rip)        # 1531380 <_DYNAMIC+0x17e0>
  a6a242:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  a6a247:	48 8d 9c 24 70 01 00 	lea    0x170(%rsp),%rbx
  a6a24e:	00 
  a6a24f:	48 8d ac 24 50 01 00 	lea    0x150(%rsp),%rbp
  a6a256:	00 
  a6a257:	48 83 bc 24 30 02 00 	cmpq   $0x0,0x230(%rsp)
  a6a25e:	00 00 
  a6a260:	0f b6 8c 24 20 02 00 	movzbl 0x220(%rsp),%ecx
  a6a267:	00 
  a6a268:	0f 84 eb 0c 00 00    	je     a6af59 <<gpui::native::accessibility::text::Cohort>::append+0x1809>
  a6a26e:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  a6a273:	48 8b 84 24 70 02 00 	mov    0x270(%rsp),%rax
  a6a27a:	00 
  a6a27b:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  a6a282:	00 
  a6a283:	0f 10 84 24 30 02 00 	movups 0x230(%rsp),%xmm0
  a6a28a:	00 
  a6a28b:	66 0f 10 8c 24 40 02 	movupd 0x240(%rsp),%xmm1
  a6a292:	00 00 
  a6a294:	66 0f 10 94 24 50 02 	movupd 0x250(%rsp),%xmm2
  a6a29b:	00 00 
  a6a29d:	66 0f 10 9c 24 60 02 	movupd 0x260(%rsp),%xmm3
  a6a2a4:	00 00 
  a6a2a6:	66 0f 29 5c 24 70    	movapd %xmm3,0x70(%rsp)
  a6a2ac:	66 0f 29 54 24 60    	movapd %xmm2,0x60(%rsp)
  a6a2b2:	66 0f 29 4c 24 50    	movapd %xmm1,0x50(%rsp)
  a6a2b8:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  a6a2bd:	f6 c1 01             	test   $0x1,%cl
  a6a2c0:	4c 8d a4 24 30 02 00 	lea    0x230(%rsp),%r12
  a6a2c7:	00 
  a6a2c8:	48 8d 44 24 78       	lea    0x78(%rsp),%rax
  a6a2cd:	0f 84 bf 02 00 00    	je     a6a592 <<gpui::native::accessibility::text::Cohort>::append+0xe42>
  a6a2d3:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  a6a2d8:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  a6a2dd:	48 85 d2             	test   %rdx,%rdx
  a6a2e0:	0f 84 48 05 00 00    	je     a6a82e <<gpui::native::accessibility::text::Cohort>::append+0x10de>
  a6a2e6:	0f 28 84 24 f0 00 00 	movaps 0xf0(%rsp),%xmm0
  a6a2ed:	00 
  a6a2ee:	f3 0f 58 84 24 00 01 	addss  0x100(%rsp),%xmm0
  a6a2f5:	00 00 
  a6a2f7:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  a6a2fe:	00 
  a6a2ff:	90                   	nop
  a6a300:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  a6a305:	b9 01 00 00 00       	mov    $0x1,%ecx
  a6a30a:	48 83 fa 01          	cmp    $0x1,%rdx
  a6a30e:	74 29                	je     a6a339 <<gpui::native::accessibility::text::Cohort>::append+0xbe9>
  a6a310:	48 8d 70 28          	lea    0x28(%rax),%rsi
  a6a314:	48 8d 7a 01          	lea    0x1(%rdx),%rdi
  a6a318:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a6a31f:	00 
  a6a320:	44 8b 46 e8          	mov    -0x18(%rsi),%r8d
  a6a324:	44 3b 06             	cmp    (%rsi),%r8d
  a6a327:	75 10                	jne    a6a339 <<gpui::native::accessibility::text::Cohort>::append+0xbe9>
  a6a329:	48 ff c1             	inc    %rcx
  a6a32c:	48 83 c6 18          	add    $0x18,%rsi
  a6a330:	48 ff cf             	dec    %rdi
  a6a333:	48 83 ff 02          	cmp    $0x2,%rdi
  a6a337:	77 e7                	ja     a6a320 <<gpui::native::accessibility::text::Cohort>::append+0xbd0>
  a6a339:	48 29 ca             	sub    %rcx,%rdx
  a6a33c:	0f 82 be 0b 00 00    	jb     a6af00 <<gpui::native::accessibility::text::Cohort>::append+0x17b0>
  a6a342:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  a6a346:	48 8d 34 f0          	lea    (%rax,%rsi,8),%rsi
  a6a34a:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
  a6a34f:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  a6a354:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  a6a359:	48 85 ff             	test   %rdi,%rdi
  a6a35c:	0f 85 70 01 00 00    	jne    a6a4d2 <<gpui::native::accessibility::text::Cohort>::append+0xd82>
  a6a362:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  a6a367:	48 85 d2             	test   %rdx,%rdx
  a6a36a:	0f 84 be 04 00 00    	je     a6a82e <<gpui::native::accessibility::text::Cohort>::append+0x10de>
  a6a370:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  a6a375:	bf 01 00 00 00       	mov    $0x1,%edi
  a6a37a:	48 83 fa 01          	cmp    $0x1,%rdx
  a6a37e:	74 29                	je     a6a3a9 <<gpui::native::accessibility::text::Cohort>::append+0xc59>
  a6a380:	4c 8d 46 28          	lea    0x28(%rsi),%r8
  a6a384:	4c 8d 4a 01          	lea    0x1(%rdx),%r9
  a6a388:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a6a38f:	00 
  a6a390:	45 8b 50 e8          	mov    -0x18(%r8),%r10d
  a6a394:	45 3b 10             	cmp    (%r8),%r10d
  a6a397:	75 10                	jne    a6a3a9 <<gpui::native::accessibility::text::Cohort>::append+0xc59>
  a6a399:	48 ff c7             	inc    %rdi
  a6a39c:	49 83 c0 18          	add    $0x18,%r8
  a6a3a0:	49 ff c9             	dec    %r9
  a6a3a3:	49 83 f9 02          	cmp    $0x2,%r9
  a6a3a7:	77 e7                	ja     a6a390 <<gpui::native::accessibility::text::Cohort>::append+0xc40>
  a6a3a9:	48 29 fa             	sub    %rdi,%rdx
  a6a3ac:	0f 82 4e 0b 00 00    	jb     a6af00 <<gpui::native::accessibility::text::Cohort>::append+0x17b0>
  a6a3b2:	4c 8d 04 7f          	lea    (%rdi,%rdi,2),%r8
  a6a3b6:	4e 8d 04 c6          	lea    (%rsi,%r8,8),%r8
  a6a3ba:	4c 89 44 24 50       	mov    %r8,0x50(%rsp)
  a6a3bf:	48 89 54 24 58       	mov    %rdx,0x58(%rsp)
  a6a3c4:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  a6a3cb:	00 
  a6a3cc:	48 89 8c 24 58 01 00 	mov    %rcx,0x158(%rsp)
  a6a3d3:	00 
  a6a3d4:	48 89 b4 24 60 01 00 	mov    %rsi,0x160(%rsp)
  a6a3db:	00 
  a6a3dc:	48 89 bc 24 68 01 00 	mov    %rdi,0x168(%rsp)
  a6a3e3:	00 
  a6a3e4:	4c 89 e7             	mov    %r12,%rdi
  a6a3e7:	48 8d 74 24 38       	lea    0x38(%rsp),%rsi
  a6a3ec:	48 89 ea             	mov    %rbp,%rdx
  a6a3ef:	e8 9c 65 ff ff       	call   a60990 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut>
  a6a3f4:	80 bc 24 34 02 00 00 	cmpb   $0x2,0x234(%rsp)
  a6a3fb:	02 
  a6a3fc:	75 13                	jne    a6a411 <<gpui::native::accessibility::text::Cohort>::append+0xcc1>
  a6a3fe:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  a6a403:	48 85 d2             	test   %rdx,%rdx
  a6a406:	0f 85 f4 fe ff ff    	jne    a6a300 <<gpui::native::accessibility::text::Cohort>::append+0xbb0>
  a6a40c:	e9 1d 04 00 00       	jmp    a6a82e <<gpui::native::accessibility::text::Cohort>::append+0x10de>
  a6a411:	0f 28 84 24 f0 00 00 	movaps 0xf0(%rsp),%xmm0
  a6a418:	00 
  a6a419:	f3 0f 5c 84 24 40 02 	subss  0x240(%rsp),%xmm0
  a6a420:	00 00 
  a6a422:	f3 0f 11 84 24 00 01 	movss  %xmm0,0x100(%rsp)
  a6a429:	00 00 
  a6a42b:	f3 0f 10 84 24 48 02 	movss  0x248(%rsp),%xmm0
  a6a432:	00 00 
  a6a434:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  a6a439:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  a6a43e:	48 3b 5c 24 18       	cmp    0x18(%rsp),%rbx
  a6a443:	75 0b                	jne    a6a450 <<gpui::native::accessibility::text::Cohort>::append+0xd00>
  a6a445:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
  a6a44a:	ff 15 38 6f ac 00    	call   *0xac6f38(%rip)        # 1531388 <_DYNAMIC+0x17e8>
  a6a450:	f3 0f 10 84 24 00 01 	movss  0x100(%rsp),%xmm0
  a6a457:	00 00 
  a6a459:	f3 0f 5c 04 24       	subss  (%rsp),%xmm0
  a6a45e:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  a6a463:	f3 0f 11 04 98       	movss  %xmm0,(%rax,%rbx,4)
  a6a468:	48 ff c3             	inc    %rbx
  a6a46b:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
  a6a470:	48 8b 9c 24 e8 00 00 	mov    0xe8(%rsp),%rbx
  a6a477:	00 
  a6a478:	48 3b 9c 24 d8 00 00 	cmp    0xd8(%rsp),%rbx
  a6a47f:	00 
  a6a480:	75 0e                	jne    a6a490 <<gpui::native::accessibility::text::Cohort>::append+0xd40>
  a6a482:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a6a489:	00 
  a6a48a:	ff 15 f8 6e ac 00    	call   *0xac6ef8(%rip)        # 1531388 <_DYNAMIC+0x17e8>
  a6a490:	48 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%rax
  a6a497:	00 
  a6a498:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  a6a49d:	f3 0f 11 04 98       	movss  %xmm0,(%rax,%rbx,4)
  a6a4a2:	48 ff c3             	inc    %rbx
  a6a4a5:	48 89 9c 24 e8 00 00 	mov    %rbx,0xe8(%rsp)
  a6a4ac:	00 
  a6a4ad:	48 8d 44 24 78       	lea    0x78(%rsp),%rax
  a6a4b2:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  a6a4b7:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  a6a4bc:	48 85 d2             	test   %rdx,%rdx
  a6a4bf:	48 8d 9c 24 70 01 00 	lea    0x170(%rsp),%rbx
  a6a4c6:	00 
  a6a4c7:	0f 85 33 fe ff ff    	jne    a6a300 <<gpui::native::accessibility::text::Cohort>::append+0xbb0>
  a6a4cd:	e9 5c 03 00 00       	jmp    a6a82e <<gpui::native::accessibility::text::Cohort>::append+0x10de>
  a6a4d2:	48 c7 44 24 60 00 00 	movq   $0x0,0x60(%rsp)
  a6a4d9:	00 00 
  a6a4db:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  a6a4e0:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  a6a4e5:	49 89 d0             	mov    %rdx,%r8
  a6a4e8:	49 89 f1             	mov    %rsi,%r9
  a6a4eb:	49 89 d2             	mov    %rdx,%r10
  a6a4ee:	48 83 fa 01          	cmp    $0x1,%rdx
  a6a4f2:	74 30                	je     a6a524 <<gpui::native::accessibility::text::Cohort>::append+0xdd4>
  a6a4f4:	4d 85 c0             	test   %r8,%r8
  a6a4f7:	0f 84 31 03 00 00    	je     a6a82e <<gpui::native::accessibility::text::Cohort>::append+0x10de>
  a6a4fd:	49 8d 51 28          	lea    0x28(%r9),%rdx
  a6a501:	49 8d 70 01          	lea    0x1(%r8),%rsi
  a6a505:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  a6a50b:	44 8b 5a e8          	mov    -0x18(%rdx),%r11d
  a6a50f:	44 3b 1a             	cmp    (%rdx),%r11d
  a6a512:	75 10                	jne    a6a524 <<gpui::native::accessibility::text::Cohort>::append+0xdd4>
  a6a514:	49 ff c2             	inc    %r10
  a6a517:	48 83 c2 18          	add    $0x18,%rdx
  a6a51b:	48 ff ce             	dec    %rsi
  a6a51e:	48 83 fe 02          	cmp    $0x2,%rsi
  a6a522:	77 e7                	ja     a6a50b <<gpui::native::accessibility::text::Cohort>::append+0xdbb>
  a6a524:	4c 89 c2             	mov    %r8,%rdx
  a6a527:	4c 29 d2             	sub    %r10,%rdx
  a6a52a:	0f 82 d0 09 00 00    	jb     a6af00 <<gpui::native::accessibility::text::Cohort>::append+0x17b0>
  a6a530:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  a6a534:	4b 8d 34 d9          	lea    (%r9,%r11,8),%rsi
  a6a538:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
  a6a53d:	48 89 54 24 58       	mov    %rdx,0x58(%rsp)
  a6a542:	48 ff cf             	dec    %rdi
  a6a545:	75 9e                	jne    a6a4e5 <<gpui::native::accessibility::text::Cohort>::append+0xd95>
  a6a547:	48 89 d7             	mov    %rdx,%rdi
  a6a54a:	48 83 fa 01          	cmp    $0x1,%rdx
  a6a54e:	0f 84 55 fe ff ff    	je     a6a3a9 <<gpui::native::accessibility::text::Cohort>::append+0xc59>
  a6a554:	48 85 d2             	test   %rdx,%rdx
  a6a557:	0f 84 d1 02 00 00    	je     a6a82e <<gpui::native::accessibility::text::Cohort>::append+0x10de>
  a6a55d:	4f 8d 0c d9          	lea    (%r9,%r11,8),%r9
  a6a561:	49 83 c1 28          	add    $0x28,%r9
  a6a565:	4d 29 d0             	sub    %r10,%r8
  a6a568:	49 ff c0             	inc    %r8
  a6a56b:	bf 01 00 00 00       	mov    $0x1,%edi
  a6a570:	45 8b 51 e8          	mov    -0x18(%r9),%r10d
  a6a574:	45 3b 11             	cmp    (%r9),%r10d
  a6a577:	0f 85 2c fe ff ff    	jne    a6a3a9 <<gpui::native::accessibility::text::Cohort>::append+0xc59>
  a6a57d:	48 ff c7             	inc    %rdi
  a6a580:	49 83 c1 18          	add    $0x18,%r9
  a6a584:	49 ff c8             	dec    %r8
  a6a587:	49 83 f8 02          	cmp    $0x2,%r8
  a6a58b:	77 e3                	ja     a6a570 <<gpui::native::accessibility::text::Cohort>::append+0xe20>
  a6a58d:	e9 17 fe ff ff       	jmp    a6a3a9 <<gpui::native::accessibility::text::Cohort>::append+0xc59>
  a6a592:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  a6a597:	e9 84 02 00 00       	jmp    a6a820 <<gpui::native::accessibility::text::Cohort>::append+0x10d0>
  a6a59c:	0f 1f 40 00          	nopl   0x0(%rax)
  a6a5a0:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  a6a5a5:	b9 01 00 00 00       	mov    $0x1,%ecx
  a6a5aa:	48 83 fa 01          	cmp    $0x1,%rdx
  a6a5ae:	74 29                	je     a6a5d9 <<gpui::native::accessibility::text::Cohort>::append+0xe89>
  a6a5b0:	48 8d 70 28          	lea    0x28(%rax),%rsi
  a6a5b4:	48 8d 7a 01          	lea    0x1(%rdx),%rdi
  a6a5b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a6a5bf:	00 
  a6a5c0:	44 8b 46 e8          	mov    -0x18(%rsi),%r8d
  a6a5c4:	44 3b 06             	cmp    (%rsi),%r8d
  a6a5c7:	75 10                	jne    a6a5d9 <<gpui::native::accessibility::text::Cohort>::append+0xe89>
  a6a5c9:	48 ff c1             	inc    %rcx
  a6a5cc:	48 83 c6 18          	add    $0x18,%rsi
  a6a5d0:	48 ff cf             	dec    %rdi
  a6a5d3:	48 83 ff 02          	cmp    $0x2,%rdi
  a6a5d7:	77 e7                	ja     a6a5c0 <<gpui::native::accessibility::text::Cohort>::append+0xe70>
  a6a5d9:	48 29 ca             	sub    %rcx,%rdx
  a6a5dc:	0f 82 00 09 00 00    	jb     a6aee2 <<gpui::native::accessibility::text::Cohort>::append+0x1792>
  a6a5e2:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  a6a5e6:	48 8d 34 f0          	lea    (%rax,%rsi,8),%rsi
  a6a5ea:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
  a6a5ef:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  a6a5f4:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  a6a5f9:	48 85 ff             	test   %rdi,%rdi
  a6a5fc:	0f 85 5d 01 00 00    	jne    a6a75f <<gpui::native::accessibility::text::Cohort>::append+0x100f>
  a6a602:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  a6a607:	48 85 d2             	test   %rdx,%rdx
  a6a60a:	0f 84 1e 02 00 00    	je     a6a82e <<gpui::native::accessibility::text::Cohort>::append+0x10de>
  a6a610:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  a6a615:	bf 01 00 00 00       	mov    $0x1,%edi
  a6a61a:	48 83 fa 01          	cmp    $0x1,%rdx
  a6a61e:	74 29                	je     a6a649 <<gpui::native::accessibility::text::Cohort>::append+0xef9>
  a6a620:	4c 8d 46 28          	lea    0x28(%rsi),%r8
  a6a624:	4c 8d 4a 01          	lea    0x1(%rdx),%r9
  a6a628:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a6a62f:	00 
  a6a630:	45 8b 50 e8          	mov    -0x18(%r8),%r10d
  a6a634:	45 3b 10             	cmp    (%r8),%r10d
  a6a637:	75 10                	jne    a6a649 <<gpui::native::accessibility::text::Cohort>::append+0xef9>
  a6a639:	48 ff c7             	inc    %rdi
  a6a63c:	49 83 c0 18          	add    $0x18,%r8
  a6a640:	49 ff c9             	dec    %r9
  a6a643:	49 83 f9 02          	cmp    $0x2,%r9
  a6a647:	77 e7                	ja     a6a630 <<gpui::native::accessibility::text::Cohort>::append+0xee0>
  a6a649:	48 29 fa             	sub    %rdi,%rdx
  a6a64c:	0f 82 90 08 00 00    	jb     a6aee2 <<gpui::native::accessibility::text::Cohort>::append+0x1792>
  a6a652:	4c 8d 04 7f          	lea    (%rdi,%rdi,2),%r8
  a6a656:	4e 8d 04 c6          	lea    (%rsi,%r8,8),%r8
  a6a65a:	4c 89 44 24 50       	mov    %r8,0x50(%rsp)
  a6a65f:	48 89 54 24 58       	mov    %rdx,0x58(%rsp)
  a6a664:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  a6a66b:	00 
  a6a66c:	48 89 8c 24 58 01 00 	mov    %rcx,0x158(%rsp)
  a6a673:	00 
  a6a674:	48 89 b4 24 60 01 00 	mov    %rsi,0x160(%rsp)
  a6a67b:	00 
  a6a67c:	48 89 bc 24 68 01 00 	mov    %rdi,0x168(%rsp)
  a6a683:	00 
  a6a684:	4c 89 e7             	mov    %r12,%rdi
  a6a687:	48 8d 74 24 38       	lea    0x38(%rsp),%rsi
  a6a68c:	48 89 ea             	mov    %rbp,%rdx
  a6a68f:	e8 fc 62 ff ff       	call   a60990 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut>
  a6a694:	80 bc 24 34 02 00 00 	cmpb   $0x2,0x234(%rsp)
  a6a69b:	02 
  a6a69c:	0f 84 7e 01 00 00    	je     a6a820 <<gpui::native::accessibility::text::Cohort>::append+0x10d0>
  a6a6a2:	f3 0f 10 84 24 40 02 	movss  0x240(%rsp),%xmm0
  a6a6a9:	00 00 
  a6a6ab:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  a6a6b0:	f3 0f 10 84 24 48 02 	movss  0x248(%rsp),%xmm0
  a6a6b7:	00 00 
  a6a6b9:	f3 0f 11 84 24 f0 00 	movss  %xmm0,0xf0(%rsp)
  a6a6c0:	00 00 
  a6a6c2:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  a6a6c7:	48 3b 5c 24 18       	cmp    0x18(%rsp),%rbx
  a6a6cc:	75 0b                	jne    a6a6d9 <<gpui::native::accessibility::text::Cohort>::append+0xf89>
  a6a6ce:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
  a6a6d3:	ff 15 af 6c ac 00    	call   *0xac6caf(%rip)        # 1531388 <_DYNAMIC+0x17e8>
  a6a6d9:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  a6a6de:	f3 0f 5c 84 24 00 01 	subss  0x100(%rsp),%xmm0
  a6a6e5:	00 00 
  a6a6e7:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  a6a6ec:	f3 0f 11 04 98       	movss  %xmm0,(%rax,%rbx,4)
  a6a6f1:	48 ff c3             	inc    %rbx
  a6a6f4:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
  a6a6f9:	48 8b 9c 24 e8 00 00 	mov    0xe8(%rsp),%rbx
  a6a700:	00 
  a6a701:	48 3b 9c 24 d8 00 00 	cmp    0xd8(%rsp),%rbx
  a6a708:	00 
  a6a709:	75 0e                	jne    a6a719 <<gpui::native::accessibility::text::Cohort>::append+0xfc9>
  a6a70b:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a6a712:	00 
  a6a713:	ff 15 6f 6c ac 00    	call   *0xac6c6f(%rip)        # 1531388 <_DYNAMIC+0x17e8>
  a6a719:	48 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%rax
  a6a720:	00 
  a6a721:	f3 0f 10 84 24 f0 00 	movss  0xf0(%rsp),%xmm0
  a6a728:	00 00 
  a6a72a:	f3 0f 11 04 98       	movss  %xmm0,(%rax,%rbx,4)
  a6a72f:	48 ff c3             	inc    %rbx
  a6a732:	48 89 9c 24 e8 00 00 	mov    %rbx,0xe8(%rsp)
  a6a739:	00 
  a6a73a:	48 8d 44 24 78       	lea    0x78(%rsp),%rax
  a6a73f:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  a6a744:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  a6a749:	48 85 d2             	test   %rdx,%rdx
  a6a74c:	48 8d 9c 24 70 01 00 	lea    0x170(%rsp),%rbx
  a6a753:	00 
  a6a754:	0f 85 46 fe ff ff    	jne    a6a5a0 <<gpui::native::accessibility::text::Cohort>::append+0xe50>
  a6a75a:	e9 cf 00 00 00       	jmp    a6a82e <<gpui::native::accessibility::text::Cohort>::append+0x10de>
  a6a75f:	48 c7 44 24 60 00 00 	movq   $0x0,0x60(%rsp)
  a6a766:	00 00 
  a6a768:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  a6a76d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  a6a772:	49 89 d0             	mov    %rdx,%r8
  a6a775:	49 89 f1             	mov    %rsi,%r9
  a6a778:	49 89 d2             	mov    %rdx,%r10
  a6a77b:	48 83 fa 01          	cmp    $0x1,%rdx
  a6a77f:	74 30                	je     a6a7b1 <<gpui::native::accessibility::text::Cohort>::append+0x1061>
  a6a781:	4d 85 c0             	test   %r8,%r8
  a6a784:	0f 84 a4 00 00 00    	je     a6a82e <<gpui::native::accessibility::text::Cohort>::append+0x10de>
  a6a78a:	49 8d 51 28          	lea    0x28(%r9),%rdx
  a6a78e:	49 8d 70 01          	lea    0x1(%r8),%rsi
  a6a792:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  a6a798:	44 8b 5a e8          	mov    -0x18(%rdx),%r11d
  a6a79c:	44 3b 1a             	cmp    (%rdx),%r11d
  a6a79f:	75 10                	jne    a6a7b1 <<gpui::native::accessibility::text::Cohort>::append+0x1061>
  a6a7a1:	49 ff c2             	inc    %r10
  a6a7a4:	48 83 c2 18          	add    $0x18,%rdx
  a6a7a8:	48 ff ce             	dec    %rsi
  a6a7ab:	48 83 fe 02          	cmp    $0x2,%rsi
  a6a7af:	77 e7                	ja     a6a798 <<gpui::native::accessibility::text::Cohort>::append+0x1048>
  a6a7b1:	4c 89 c2             	mov    %r8,%rdx
  a6a7b4:	4c 29 d2             	sub    %r10,%rdx
  a6a7b7:	0f 82 25 07 00 00    	jb     a6aee2 <<gpui::native::accessibility::text::Cohort>::append+0x1792>
  a6a7bd:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  a6a7c1:	4b 8d 34 d9          	lea    (%r9,%r11,8),%rsi
  a6a7c5:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
  a6a7ca:	48 89 54 24 58       	mov    %rdx,0x58(%rsp)
  a6a7cf:	48 ff cf             	dec    %rdi
  a6a7d2:	75 9e                	jne    a6a772 <<gpui::native::accessibility::text::Cohort>::append+0x1022>
  a6a7d4:	48 89 d7             	mov    %rdx,%rdi
  a6a7d7:	48 83 fa 01          	cmp    $0x1,%rdx
  a6a7db:	0f 84 68 fe ff ff    	je     a6a649 <<gpui::native::accessibility::text::Cohort>::append+0xef9>
  a6a7e1:	48 85 d2             	test   %rdx,%rdx
  a6a7e4:	74 48                	je     a6a82e <<gpui::native::accessibility::text::Cohort>::append+0x10de>
  a6a7e6:	4f 8d 0c d9          	lea    (%r9,%r11,8),%r9
  a6a7ea:	49 83 c1 28          	add    $0x28,%r9
  a6a7ee:	4d 29 d0             	sub    %r10,%r8
  a6a7f1:	49 ff c0             	inc    %r8
  a6a7f4:	bf 01 00 00 00       	mov    $0x1,%edi
  a6a7f9:	45 8b 51 e8          	mov    -0x18(%r9),%r10d
  a6a7fd:	45 3b 11             	cmp    (%r9),%r10d
  a6a800:	0f 85 43 fe ff ff    	jne    a6a649 <<gpui::native::accessibility::text::Cohort>::append+0xef9>
  a6a806:	48 ff c7             	inc    %rdi
  a6a809:	49 83 c1 18          	add    $0x18,%r9
  a6a80d:	49 ff c8             	dec    %r8
  a6a810:	49 83 f8 02          	cmp    $0x2,%r8
  a6a814:	77 e3                	ja     a6a7f9 <<gpui::native::accessibility::text::Cohort>::append+0x10a9>
  a6a816:	e9 2e fe ff ff       	jmp    a6a649 <<gpui::native::accessibility::text::Cohort>::append+0xef9>
  a6a81b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  a6a820:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  a6a825:	48 85 d2             	test   %rdx,%rdx
  a6a828:	0f 85 72 fd ff ff    	jne    a6a5a0 <<gpui::native::accessibility::text::Cohort>::append+0xe50>
  a6a82e:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  a6a833:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  a6a838:	4c 39 f8             	cmp    %r15,%rax
  a6a83b:	0f 85 36 07 00 00    	jne    a6af77 <<gpui::native::accessibility::text::Cohort>::append+0x1827>
  a6a841:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  a6a846:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  a6a84b:	48 89 41 e0          	mov    %rax,-0x20(%rcx)
  a6a84f:	66 0f 10 44 24 18    	movupd 0x18(%rsp),%xmm0
  a6a855:	66 0f 11 41 d0       	movupd %xmm0,-0x30(%rcx)
  a6a85a:	c6 44 24 40 0b       	movb   $0xb,0x40(%rsp)
  a6a85f:	45 31 e4             	xor    %r12d,%r12d
  a6a862:	48 89 df             	mov    %rbx,%rdi
  a6a865:	be 42 00 00 00       	mov    $0x42,%esi
  a6a86a:	48 8d 54 24 40       	lea    0x40(%rsp),%rdx
  a6a86f:	ff 15 eb 69 ac 00    	call   *0xac69eb(%rip)        # 1531260 <_DYNAMIC+0x16c0>
  a6a875:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  a6a87c:	00 
  a6a87d:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  a6a882:	48 89 41 e0          	mov    %rax,-0x20(%rcx)
  a6a886:	0f 10 84 24 d8 00 00 	movups 0xd8(%rsp),%xmm0
  a6a88d:	00 
  a6a88e:	0f 11 41 d0          	movups %xmm0,-0x30(%rcx)
  a6a892:	c6 44 24 40 0b       	movb   $0xb,0x40(%rsp)
  a6a897:	48 89 df             	mov    %rbx,%rdi
  a6a89a:	be 43 00 00 00       	mov    $0x43,%esi
  a6a89f:	48 8d 54 24 40       	lea    0x40(%rsp),%rdx
  a6a8a4:	ff 15 b6 69 ac 00    	call   *0xac69b6(%rip)        # 1531260 <_DYNAMIC+0x16c0>
  a6a8aa:	0f 28 84 24 70 01 00 	movaps 0x170(%rsp),%xmm0
  a6a8b1:	00 
  a6a8b2:	66 0f 28 8c 24 80 01 	movapd 0x180(%rsp),%xmm1
  a6a8b9:	00 00 
  a6a8bb:	66 0f 28 94 24 90 01 	movapd 0x190(%rsp),%xmm2
  a6a8c2:	00 00 
  a6a8c4:	66 0f 28 9c 24 a0 01 	movapd 0x1a0(%rsp),%xmm3
  a6a8cb:	00 00 
  a6a8cd:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  a6a8d2:	66 0f 29 4c 24 50    	movapd %xmm1,0x50(%rsp)
  a6a8d8:	66 0f 29 54 24 60    	movapd %xmm2,0x60(%rsp)
  a6a8de:	66 0f 29 5c 24 70    	movapd %xmm3,0x70(%rsp)
  a6a8e4:	0f 28 84 24 b0 01 00 	movaps 0x1b0(%rsp),%xmm0
  a6a8eb:	00 
  a6a8ec:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  a6a8f3:	00 
  a6a8f4:	0f 28 84 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm0
  a6a8fb:	00 
  a6a8fc:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  a6a903:	00 
  a6a904:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  a6a90b:	00 
  a6a90c:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  a6a913:	00 
  a6a914:	0f 28 84 24 e0 01 00 	movaps 0x1e0(%rsp),%xmm0
  a6a91b:	00 
  a6a91c:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  a6a923:	00 
  a6a924:	4c 8b a4 24 40 01 00 	mov    0x140(%rsp),%r12
  a6a92b:	00 
  a6a92c:	4c 8b bc 24 28 01 00 	mov    0x128(%rsp),%r15
  a6a933:	00 
  a6a934:	48 8b ac 24 30 01 00 	mov    0x130(%rsp),%rbp
  a6a93b:	00 
  a6a93c:	48 8b 84 24 18 02 00 	mov    0x218(%rsp),%rax
  a6a943:	00 
  a6a944:	48 01 84 24 38 01 00 	add    %rax,0x138(%rsp)
  a6a94b:	00 
  a6a94c:	48 39 ac 24 b0 02 00 	cmp    %rbp,0x2b0(%rsp)
  a6a953:	00 
  a6a954:	0f 94 c0             	sete   %al
  a6a957:	48 8b 8c 24 b8 02 00 	mov    0x2b8(%rsp),%rcx
  a6a95e:	00 
  a6a95f:	20 c1                	and    %al,%cl
  a6a961:	80 f9 01             	cmp    $0x1,%cl
  a6a964:	75 18                	jne    a6a97e <<gpui::native::accessibility::text::Cohort>::append+0x122e>
  a6a966:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a6a96b:	be 0d 00 00 00       	mov    $0xd,%esi
  a6a970:	48 8b 94 24 38 01 00 	mov    0x138(%rsp),%rdx
  a6a977:	00 
  a6a978:	ff 15 12 6a ac 00    	call   *0xac6a12(%rip)        # 1531390 <_DYNAMIC+0x17f0>
  a6a97e:	0f b6 84 24 08 03 00 	movzbl 0x308(%rsp),%eax
  a6a985:	00 
  a6a986:	3c ff                	cmp    $0xff,%al
  a6a988:	0f 85 b3 00 00 00    	jne    a6aa41 <<gpui::native::accessibility::text::Cohort>::append+0x12f1>
  a6a98e:	48 89 df             	mov    %rbx,%rdi
  a6a991:	48 8d b4 24 18 03 00 	lea    0x318(%rsp),%rsi
  a6a998:	00 
  a6a999:	e8 92 e2 ff ff       	call   a68c30 <<gpui_canvas::text::layout::TextGeometry>::runs::{closure#2}>
  a6a99e:	0f b6 84 24 90 01 00 	movzbl 0x190(%rsp),%eax
  a6a9a5:	00 
  a6a9a6:	3c 02                	cmp    $0x2,%al
  a6a9a8:	75 02                	jne    a6a9ac <<gpui::native::accessibility::text::Cohort>::append+0x125c>
  a6a9aa:	eb 51                	jmp    a6a9fd <<gpui::native::accessibility::text::Cohort>::append+0x12ad>
  a6a9ac:	0f 10 84 24 70 01 00 	movups 0x170(%rsp),%xmm0
  a6a9b3:	00 
  a6a9b4:	66 0f 10 8c 24 80 01 	movupd 0x180(%rsp),%xmm1
  a6a9bb:	00 00 
  a6a9bd:	66 0f 29 8c 24 40 02 	movapd %xmm1,0x240(%rsp)
  a6a9c4:	00 00 
  a6a9c6:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  a6a9cd:	00 
  a6a9ce:	48 8d 94 24 91 01 00 	lea    0x191(%rsp),%rdx
  a6a9d5:	00 
  a6a9d6:	8b 0a                	mov    (%rdx),%ecx
  a6a9d8:	8b 52 03             	mov    0x3(%rdx),%edx
  a6a9db:	89 8c 24 50 01 00 00 	mov    %ecx,0x150(%rsp)
  a6a9e2:	89 94 24 53 01 00 00 	mov    %edx,0x153(%rsp)
  a6a9e9:	48 8b 8c 24 10 03 00 	mov    0x310(%rsp),%rcx
  a6a9f0:	00 
  a6a9f1:	48 8d 51 01          	lea    0x1(%rcx),%rdx
  a6a9f5:	48 89 94 24 10 03 00 	mov    %rdx,0x310(%rsp)
  a6a9fc:	00 
  a6a9fd:	48 89 8c 24 e0 02 00 	mov    %rcx,0x2e0(%rsp)
  a6aa04:	00 
  a6aa05:	0f 28 84 24 30 02 00 	movaps 0x230(%rsp),%xmm0
  a6aa0c:	00 
  a6aa0d:	66 0f 28 8c 24 40 02 	movapd 0x240(%rsp),%xmm1
  a6aa14:	00 00 
  a6aa16:	48 8d b4 24 09 03 00 	lea    0x309(%rsp),%rsi
  a6aa1d:	00 
  a6aa1e:	66 0f 11 4e ef       	movupd %xmm1,-0x11(%rsi)
  a6aa23:	0f 11 46 df          	movups %xmm0,-0x21(%rsi)
  a6aa27:	88 84 24 08 03 00 00 	mov    %al,0x308(%rsp)
  a6aa2e:	8b 8c 24 50 01 00 00 	mov    0x150(%rsp),%ecx
  a6aa35:	8b 94 24 53 01 00 00 	mov    0x153(%rsp),%edx
  a6aa3c:	89 56 03             	mov    %edx,0x3(%rsi)
  a6aa3f:	89 0e                	mov    %ecx,(%rsi)
  a6aa41:	3c 02                	cmp    $0x2,%al
  a6aa43:	74 26                	je     a6aa6b <<gpui::native::accessibility::text::Cohort>::append+0x131b>
  a6aa45:	48 39 ac 24 f8 02 00 	cmp    %rbp,0x2f8(%rsp)
  a6aa4c:	00 
  a6aa4d:	75 1c                	jne    a6aa6b <<gpui::native::accessibility::text::Cohort>::append+0x131b>
  a6aa4f:	48 8b 94 24 38 01 00 	mov    0x138(%rsp),%rdx
  a6aa56:	00 
  a6aa57:	48 83 c2 02          	add    $0x2,%rdx
  a6aa5b:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a6aa60:	be 0c 00 00 00       	mov    $0xc,%esi
  a6aa65:	ff 15 25 69 ac 00    	call   *0xac6925(%rip)        # 1531390 <_DYNAMIC+0x17f0>
  a6aa6b:	0f 28 84 24 b0 00 00 	movaps 0xb0(%rsp),%xmm0
  a6aa72:	00 
  a6aa73:	48 8d 84 24 91 01 00 	lea    0x191(%rsp),%rax
  a6aa7a:	00 
  a6aa7b:	0f 11 40 57          	movups %xmm0,0x57(%rax)
  a6aa7f:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  a6aa86:	00 
  a6aa87:	0f 11 40 47          	movups %xmm0,0x47(%rax)
  a6aa8b:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  a6aa92:	00 
  a6aa93:	0f 11 40 37          	movups %xmm0,0x37(%rax)
  a6aa97:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  a6aa9e:	00 
  a6aa9f:	0f 11 40 27          	movups %xmm0,0x27(%rax)
  a6aaa3:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  a6aaa8:	66 0f 28 4c 24 50    	movapd 0x50(%rsp),%xmm1
  a6aaae:	66 0f 28 54 24 60    	movapd 0x60(%rsp),%xmm2
  a6aab4:	66 0f 28 5c 24 70    	movapd 0x70(%rsp),%xmm3
  a6aaba:	66 0f 11 58 17       	movupd %xmm3,0x17(%rax)
  a6aabf:	66 0f 11 50 07       	movupd %xmm2,0x7(%rax)
  a6aac4:	66 0f 11 48 f7       	movupd %xmm1,-0x9(%rax)
  a6aac9:	0f 11 40 e7          	movups %xmm0,-0x19(%rax)
  a6aacd:	48 8b 84 24 c0 02 00 	mov    0x2c0(%rsp),%rax
  a6aad4:	00 
  a6aad5:	48 89 84 24 70 01 00 	mov    %rax,0x170(%rsp)
  a6aadc:	00 
  a6aadd:	49 8b 5f 10          	mov    0x10(%r15),%rbx
  a6aae1:	49 3b 1f             	cmp    (%r15),%rbx
  a6aae4:	75 09                	jne    a6aaef <<gpui::native::accessibility::text::Cohort>::append+0x139f>
  a6aae6:	4c 89 ff             	mov    %r15,%rdi
  a6aae9:	ff 15 69 67 ac 00    	call   *0xac6769(%rip)        # 1531258 <_DYNAMIC+0x16b8>
  a6aaef:	48 89 d8             	mov    %rbx,%rax
  a6aaf2:	48 c1 e0 07          	shl    $0x7,%rax
  a6aaf6:	48 8d 3c d8          	lea    (%rax,%rbx,8),%rdi
  a6aafa:	49 03 7f 08          	add    0x8(%r15),%rdi
  a6aafe:	ba 88 00 00 00       	mov    $0x88,%edx
  a6ab03:	48 8d ac 24 70 01 00 	lea    0x170(%rsp),%rbp
  a6ab0a:	00 
  a6ab0b:	48 89 ee             	mov    %rbp,%rsi
  a6ab0e:	ff 15 ec 52 ac 00    	call   *0xac52ec(%rip)        # 152fe00 <memcpy@GLIBC_2.14>
  a6ab14:	48 ff c3             	inc    %rbx
  a6ab17:	49 89 5f 10          	mov    %rbx,0x10(%r15)
  a6ab1b:	48 89 ef             	mov    %rbp,%rdi
  a6ab1e:	40 b5 01             	mov    $0x1,%bpl
  a6ab21:	0f b6 94 24 08 03 00 	movzbl 0x308(%rsp),%edx
  a6ab28:	00 
  a6ab29:	48 8b 84 24 30 01 00 	mov    0x130(%rsp),%rax
  a6ab30:	00 
  a6ab31:	48 89 84 24 b0 02 00 	mov    %rax,0x2b0(%rsp)
  a6ab38:	00 
  a6ab39:	48 8b 1d 10 67 ac 00 	mov    0xac6710(%rip),%rbx        # 1531250 <_DYNAMIC+0x16b0>
  a6ab40:	e9 56 f1 ff ff       	jmp    a69c9b <<gpui::native::accessibility::text::Cohort>::append+0x54b>
  a6ab45:	0f 28 84 24 e0 01 00 	movaps 0x1e0(%rsp),%xmm0
  a6ab4c:	00 
  a6ab4d:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  a6ab54:	00 
  a6ab55:	0f 28 84 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm0
  a6ab5c:	00 
  a6ab5d:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  a6ab64:	00 
  a6ab65:	0f 28 84 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm0
  a6ab6c:	00 
  a6ab6d:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  a6ab74:	00 
  a6ab75:	0f 28 84 24 b0 01 00 	movaps 0x1b0(%rsp),%xmm0
  a6ab7c:	00 
  a6ab7d:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  a6ab84:	00 
  a6ab85:	0f 28 84 24 70 01 00 	movaps 0x170(%rsp),%xmm0
  a6ab8c:	00 
  a6ab8d:	66 0f 28 8c 24 80 01 	movapd 0x180(%rsp),%xmm1
  a6ab94:	00 00 
  a6ab96:	66 0f 28 94 24 90 01 	movapd 0x190(%rsp),%xmm2
  a6ab9d:	00 00 
  a6ab9f:	66 0f 28 9c 24 a0 01 	movapd 0x1a0(%rsp),%xmm3
  a6aba6:	00 00 
  a6aba8:	66 0f 29 5c 24 70    	movapd %xmm3,0x70(%rsp)
  a6abae:	66 0f 29 54 24 60    	movapd %xmm2,0x60(%rsp)
  a6abb4:	66 0f 29 4c 24 50    	movapd %xmm1,0x50(%rsp)
  a6abba:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  a6abbf:	e9 60 fd ff ff       	jmp    a6a924 <<gpui::native::accessibility::text::Cohort>::append+0x11d4>
  a6abc4:	48 8d 9c 24 70 01 00 	lea    0x170(%rsp),%rbx
  a6abcb:	00 
  a6abcc:	4c 8b 3d 7d 66 ac 00 	mov    0xac667d(%rip),%r15        # 1531250 <_DYNAMIC+0x16b0>
  a6abd3:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  a6abd8:	eb 25                	jmp    a6abff <<gpui::native::accessibility::text::Cohort>::append+0x14af>
  a6abda:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  a6abe0:	48 8b 94 24 10 03 00 	mov    0x310(%rsp),%rdx
  a6abe7:	00 
  a6abe8:	48 ff c2             	inc    %rdx
  a6abeb:	48 89 94 24 10 03 00 	mov    %rdx,0x310(%rsp)
  a6abf2:	00 
  a6abf3:	49 03 56 28          	add    0x28(%r14),%rdx
  a6abf7:	48 89 ef             	mov    %rbp,%rdi
  a6abfa:	31 f6                	xor    %esi,%esi
  a6abfc:	41 ff d7             	call   *%r15
  a6abff:	48 8b 94 24 e0 02 00 	mov    0x2e0(%rsp),%rdx
  a6ac06:	00 
  a6ac07:	0f b6 84 24 08 03 00 	movzbl 0x308(%rsp),%eax
  a6ac0e:	00 
  a6ac0f:	c6 84 24 08 03 00 00 	movb   $0xff,0x308(%rsp)
  a6ac16:	ff 
  a6ac17:	3d ff 00 00 00       	cmp    $0xff,%eax
  a6ac1c:	74 12                	je     a6ac30 <<gpui::native::accessibility::text::Cohort>::append+0x14e0>
  a6ac1e:	83 f8 02             	cmp    $0x2,%eax
  a6ac21:	74 27                	je     a6ac4a <<gpui::native::accessibility::text::Cohort>::append+0x14fa>
  a6ac23:	48 ff c2             	inc    %rdx
  a6ac26:	eb cb                	jmp    a6abf3 <<gpui::native::accessibility::text::Cohort>::append+0x14a3>
  a6ac28:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a6ac2f:	00 
  a6ac30:	48 89 df             	mov    %rbx,%rdi
  a6ac33:	48 8d b4 24 18 03 00 	lea    0x318(%rsp),%rsi
  a6ac3a:	00 
  a6ac3b:	e8 f0 df ff ff       	call   a68c30 <<gpui_canvas::text::layout::TextGeometry>::runs::{closure#2}>
  a6ac40:	80 bc 24 90 01 00 00 	cmpb   $0x2,0x190(%rsp)
  a6ac47:	02 
  a6ac48:	75 96                	jne    a6abe0 <<gpui::native::accessibility::text::Cohort>::append+0x1490>
  a6ac4a:	48 83 bc 24 c0 03 00 	cmpq   $0xffffffffffffffff,0x3c0(%rsp)
  a6ac51:	00 ff 
  a6ac53:	0f 94 84 24 10 01 00 	sete   0x110(%rsp)
  a6ac5a:	00 
  a6ac5b:	0f 84 53 01 00 00    	je     a6adb4 <<gpui::native::accessibility::text::Cohort>::append+0x1664>
  a6ac61:	0f 28 84 24 30 04 00 	movaps 0x430(%rsp),%xmm0
  a6ac68:	00 
  a6ac69:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  a6ac70:	00 
  a6ac71:	0f 28 84 24 20 04 00 	movaps 0x420(%rsp),%xmm0
  a6ac78:	00 
  a6ac79:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  a6ac80:	00 
  a6ac81:	0f 28 84 24 10 04 00 	movaps 0x410(%rsp),%xmm0
  a6ac88:	00 
  a6ac89:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  a6ac90:	00 
  a6ac91:	0f 28 84 24 00 04 00 	movaps 0x400(%rsp),%xmm0
  a6ac98:	00 
  a6ac99:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  a6aca0:	00 
  a6aca1:	0f 28 84 24 c0 03 00 	movaps 0x3c0(%rsp),%xmm0
  a6aca8:	00 
  a6aca9:	66 0f 28 8c 24 d0 03 	movapd 0x3d0(%rsp),%xmm1
  a6acb0:	00 00 
  a6acb2:	66 0f 28 94 24 e0 03 	movapd 0x3e0(%rsp),%xmm2
  a6acb9:	00 00 
  a6acbb:	66 0f 28 9c 24 f0 03 	movapd 0x3f0(%rsp),%xmm3
  a6acc2:	00 00 
  a6acc4:	66 0f 29 5c 24 70    	movapd %xmm3,0x70(%rsp)
  a6acca:	66 0f 29 54 24 60    	movapd %xmm2,0x60(%rsp)
  a6acd0:	66 0f 29 4c 24 50    	movapd %xmm1,0x50(%rsp)
  a6acd6:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  a6acdb:	49 8b 5e 28          	mov    0x28(%r14),%rbx
  a6acdf:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  a6ace4:	31 f6                	xor    %esi,%esi
  a6ace6:	48 89 da             	mov    %rbx,%rdx
  a6ace9:	ff 15 61 65 ac 00    	call   *0xac6561(%rip)        # 1531250 <_DYNAMIC+0x16b0>
  a6acef:	0f 28 84 24 b0 00 00 	movaps 0xb0(%rsp),%xmm0
  a6acf6:	00 
  a6acf7:	0f 11 84 24 e8 01 00 	movups %xmm0,0x1e8(%rsp)
  a6acfe:	00 
  a6acff:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  a6ad06:	00 
  a6ad07:	0f 11 84 24 d8 01 00 	movups %xmm0,0x1d8(%rsp)
  a6ad0e:	00 
  a6ad0f:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  a6ad16:	00 
  a6ad17:	0f 11 84 24 c8 01 00 	movups %xmm0,0x1c8(%rsp)
  a6ad1e:	00 
  a6ad1f:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  a6ad26:	00 
  a6ad27:	0f 11 84 24 b8 01 00 	movups %xmm0,0x1b8(%rsp)
  a6ad2e:	00 
  a6ad2f:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  a6ad34:	66 0f 28 4c 24 50    	movapd 0x50(%rsp),%xmm1
  a6ad3a:	66 0f 28 54 24 60    	movapd 0x60(%rsp),%xmm2
  a6ad40:	66 0f 28 5c 24 70    	movapd 0x70(%rsp),%xmm3
  a6ad46:	66 0f 11 9c 24 a8 01 	movupd %xmm3,0x1a8(%rsp)
  a6ad4d:	00 00 
  a6ad4f:	66 0f 11 94 24 98 01 	movupd %xmm2,0x198(%rsp)
  a6ad56:	00 00 
  a6ad58:	66 0f 11 8c 24 88 01 	movupd %xmm1,0x188(%rsp)
  a6ad5f:	00 00 
  a6ad61:	0f 11 84 24 78 01 00 	movups %xmm0,0x178(%rsp)
  a6ad68:	00 
  a6ad69:	48 89 9c 24 70 01 00 	mov    %rbx,0x170(%rsp)
  a6ad70:	00 
  a6ad71:	4c 8b bc 24 28 01 00 	mov    0x128(%rsp),%r15
  a6ad78:	00 
  a6ad79:	49 8b 5f 10          	mov    0x10(%r15),%rbx
  a6ad7d:	49 3b 1f             	cmp    (%r15),%rbx
  a6ad80:	75 09                	jne    a6ad8b <<gpui::native::accessibility::text::Cohort>::append+0x163b>
  a6ad82:	4c 89 ff             	mov    %r15,%rdi
  a6ad85:	ff 15 cd 64 ac 00    	call   *0xac64cd(%rip)        # 1531258 <_DYNAMIC+0x16b8>
  a6ad8b:	48 89 d8             	mov    %rbx,%rax
  a6ad8e:	48 c1 e0 07          	shl    $0x7,%rax
  a6ad92:	48 8d 3c d8          	lea    (%rax,%rbx,8),%rdi
  a6ad96:	49 03 7f 08          	add    0x8(%r15),%rdi
  a6ad9a:	48 8d b4 24 70 01 00 	lea    0x170(%rsp),%rsi
  a6ada1:	00 
  a6ada2:	ba 88 00 00 00       	mov    $0x88,%edx
  a6ada7:	ff 15 53 50 ac 00    	call   *0xac5053(%rip)        # 152fe00 <memcpy@GLIBC_2.14>
  a6adad:	48 ff c3             	inc    %rbx
  a6adb0:	49 89 5f 10          	mov    %rbx,0x10(%r15)
  a6adb4:	49 83 7e 18 00       	cmpq   $0x0,0x18(%r14)
  a6adb9:	0f 84 11 01 00 00    	je     a6aed0 <<gpui::native::accessibility::text::Cohort>::append+0x1780>
  a6adbf:	41 80 7d 4d 02       	cmpb   $0x2,0x4d(%r13)
  a6adc4:	0f 85 45 02 00 00    	jne    a6b00f <<gpui::native::accessibility::text::Cohort>::append+0x18bf>
  a6adca:	49 8b 45 28          	mov    0x28(%r13),%rax
  a6adce:	48 85 c0             	test   %rax,%rax
  a6add1:	0f 84 38 02 00 00    	je     a6b00f <<gpui::native::accessibility::text::Cohort>::append+0x18bf>
  a6add7:	48 8b 18             	mov    (%rax),%rbx
  a6adda:	41 0f b6 6c 24 24    	movzbl 0x24(%r12),%ebp
  a6ade0:	40 80 fd 02          	cmp    $0x2,%bpl
  a6ade4:	74 32                	je     a6ae18 <<gpui::native::accessibility::text::Cohort>::append+0x16c8>
  a6ade6:	49 8b 44 24 10       	mov    0x10(%r12),%rax
  a6adeb:	49 3b 45 20          	cmp    0x20(%r13),%rax
  a6adef:	75 27                	jne    a6ae18 <<gpui::native::accessibility::text::Cohort>::append+0x16c8>
  a6adf1:	41 8b 74 24 18       	mov    0x18(%r12),%esi
  a6adf6:	41 0f b6 44 24 1c    	movzbl 0x1c(%r12),%eax
  a6adfc:	41 8b 5c 24 20       	mov    0x20(%r12),%ebx
  a6ae01:	eb 2c                	jmp    a6ae2f <<gpui::native::accessibility::text::Cohort>::append+0x16df>
  a6ae03:	31 ff                	xor    %edi,%edi
  a6ae05:	48 8b b4 24 20 01 00 	mov    0x120(%rsp),%rsi
  a6ae0c:	00 
  a6ae0d:	ff 15 c5 50 ac 00    	call   *0xac50c5(%rip)        # 152fed8 <_DYNAMIC+0x338>
  a6ae13:	e9 70 02 00 00       	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6ae18:	48 89 d8             	mov    %rbx,%rax
  a6ae1b:	48 c1 e8 21          	shr    $0x21,%rax
  a6ae1f:	0f 85 ea 01 00 00    	jne    a6b00f <<gpui::native::accessibility::text::Cohort>::append+0x18bf>
  a6ae25:	48 d1 eb             	shr    $1,%rbx
  a6ae28:	b0 01                	mov    $0x1,%al
  a6ae2a:	89 de                	mov    %ebx,%esi
  a6ae2c:	40 b5 01             	mov    $0x1,%bpl
  a6ae2f:	0f b6 d0             	movzbl %al,%edx
  a6ae32:	83 e2 01             	and    $0x1,%edx
  a6ae35:	4c 89 f7             	mov    %r14,%rdi
  a6ae38:	e8 33 05 00 00       	call   a6b370 <<gpui::native::accessibility::text::Input>::native_position>
  a6ae3d:	49 89 c7             	mov    %rax,%r15
  a6ae40:	49 89 d4             	mov    %rdx,%r12
  a6ae43:	40 0f b6 d5          	movzbl %bpl,%edx
  a6ae47:	83 e2 01             	and    $0x1,%edx
  a6ae4a:	4c 89 f7             	mov    %r14,%rdi
  a6ae4d:	89 de                	mov    %ebx,%esi
  a6ae4f:	e8 1c 05 00 00       	call   a6b370 <<gpui::native::accessibility::text::Input>::native_position>
  a6ae54:	48 89 c3             	mov    %rax,%rbx
  a6ae57:	49 89 d5             	mov    %rdx,%r13
  a6ae5a:	ff 15 80 4f ac 00    	call   *0xac4f80(%rip)        # 152fde0 <_DYNAMIC+0x240>
  a6ae60:	bf 20 00 00 00       	mov    $0x20,%edi
  a6ae65:	be 08 00 00 00       	mov    $0x8,%esi
  a6ae6a:	ff 15 78 4f ac 00    	call   *0xac4f78(%rip)        # 152fde8 <_DYNAMIC+0x248>
  a6ae70:	48 85 c0             	test   %rax,%rax
  a6ae73:	0f 84 21 01 00 00    	je     a6af9a <<gpui::native::accessibility::text::Cohort>::append+0x184a>
  a6ae79:	4c 89 38             	mov    %r15,(%rax)
  a6ae7c:	4c 89 60 08          	mov    %r12,0x8(%rax)
  a6ae80:	48 89 58 10          	mov    %rbx,0x10(%rax)
  a6ae84:	4c 89 68 18          	mov    %r13,0x18(%rax)
  a6ae88:	48 89 84 24 78 01 00 	mov    %rax,0x178(%rsp)
  a6ae8f:	00 
  a6ae90:	c6 84 24 70 01 00 00 	movb   $0x1b,0x170(%rsp)
  a6ae97:	1b 
  a6ae98:	48 8d 94 24 70 01 00 	lea    0x170(%rsp),%rdx
  a6ae9f:	00 
  a6aea0:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  a6aea5:	be 54 00 00 00       	mov    $0x54,%esi
  a6aeaa:	ff 15 b0 63 ac 00    	call   *0xac63b0(%rip)        # 1531260 <_DYNAMIC+0x16c0>
  a6aeb0:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  a6aeb5:	8b 42 70             	mov    0x70(%rdx),%eax
  a6aeb8:	89 c1                	mov    %eax,%ecx
  a6aeba:	81 c9 00 04 04 00    	or     $0x40400,%ecx
  a6aec0:	25 f9 ff ef ff       	and    $0xffeffff9,%eax
  a6aec5:	49 83 7e 10 00       	cmpq   $0x0,0x10(%r14)
  a6aeca:	0f 45 c1             	cmovne %ecx,%eax
  a6aecd:	89 42 70             	mov    %eax,0x70(%rdx)
  a6aed0:	48 81 c4 48 04 00 00 	add    $0x448,%rsp
  a6aed7:	5b                   	pop    %rbx
  a6aed8:	41 5c                	pop    %r12
  a6aeda:	41 5d                	pop    %r13
  a6aedc:	41 5e                	pop    %r14
  a6aede:	41 5f                	pop    %r15
  a6aee0:	5d                   	pop    %rbp
  a6aee1:	c3                   	ret
  a6aee2:	48 8d 3d eb 50 73 ff 	lea    -0x8caf15(%rip),%rdi        # 19ffd4 <anon.5d7b745689a4da2246def3d316fdcab4.1.llvm.18443242379705941574+0x2da8>
  a6aee9:	48 8d 15 f8 71 a5 00 	lea    0xa571f8(%rip),%rdx        # 14c20e8 <anon.fc2f92b0223d15b7043d040ea72c4e93.10.llvm.5483804487471879235+0x200>
  a6aef0:	be 13 00 00 00       	mov    $0x13,%esi
  a6aef5:	ff 15 35 4f ac 00    	call   *0xac4f35(%rip)        # 152fe30 <_DYNAMIC+0x290>
  a6aefb:	e9 88 01 00 00       	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6af00:	48 8d 3d cd 50 73 ff 	lea    -0x8caf33(%rip),%rdi        # 19ffd4 <anon.5d7b745689a4da2246def3d316fdcab4.1.llvm.18443242379705941574+0x2da8>
  a6af07:	48 8d 15 da 71 a5 00 	lea    0xa571da(%rip),%rdx        # 14c20e8 <anon.fc2f92b0223d15b7043d040ea72c4e93.10.llvm.5483804487471879235+0x200>
  a6af0e:	be 13 00 00 00       	mov    $0x13,%esi
  a6af13:	ff 15 17 4f ac 00    	call   *0xac4f17(%rip)        # 152fe30 <_DYNAMIC+0x290>
  a6af19:	e9 6a 01 00 00       	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6af1e:	c6 84 24 10 01 00 00 	movb   $0x1,0x110(%rsp)
  a6af25:	01 
  a6af26:	bf 08 00 00 00       	mov    $0x8,%edi
  a6af2b:	be 30 00 00 00       	mov    $0x30,%esi
  a6af30:	ff 15 d2 4e ac 00    	call   *0xac4ed2(%rip)        # 152fe08 <_DYNAMIC+0x268>
  a6af36:	e9 4d 01 00 00       	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6af3b:	48 8d 3d 80 7a 73 ff 	lea    -0x8c8580(%rip),%rdi        # 1a29c2 <anon.5d7b745689a4da2246def3d316fdcab4.1.llvm.18443242379705941574+0x5796>
  a6af42:	48 8d 15 87 71 a5 00 	lea    0xa57187(%rip),%rdx        # 14c20d0 <anon.fc2f92b0223d15b7043d040ea72c4e93.10.llvm.5483804487471879235+0x1e8>
  a6af49:	be 40 01 00 00       	mov    $0x140,%esi
  a6af4e:	ff 15 bc 4e ac 00    	call   *0xac4ebc(%rip)        # 152fe10 <_DYNAMIC+0x270>
  a6af54:	e9 2f 01 00 00       	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6af59:	48 8d 3d 1a 7a 73 ff 	lea    -0x8c85e6(%rip),%rdi        # 1a297a <anon.5d7b745689a4da2246def3d316fdcab4.1.llvm.18443242379705941574+0x574e>
  a6af60:	48 8d 15 21 71 a5 00 	lea    0xa57121(%rip),%rdx        # 14c2088 <anon.fc2f92b0223d15b7043d040ea72c4e93.10.llvm.5483804487471879235+0x1a0>
  a6af67:	be 2b 00 00 00       	mov    $0x2b,%esi
  a6af6c:	ff 15 a6 4f ac 00    	call   *0xac4fa6(%rip)        # 152ff18 <_DYNAMIC+0x378>
  a6af72:	e9 11 01 00 00       	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6af77:	4c 8d 0d 22 71 a5 00 	lea    0xa57122(%rip),%r9        # 14c20a0 <anon.fc2f92b0223d15b7043d040ea72c4e93.10.llvm.5483804487471879235+0x1b8>
  a6af7e:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  a6af83:	48 8d 94 24 d8 02 00 	lea    0x2d8(%rsp),%rdx
  a6af8a:	00 
  a6af8b:	31 ff                	xor    %edi,%edi
  a6af8d:	31 c9                	xor    %ecx,%ecx
  a6af8f:	ff 15 6b 59 ac 00    	call   *0xac596b(%rip)        # 1530900 <_DYNAMIC+0xd60>
  a6af95:	e9 ee 00 00 00       	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6af9a:	bf 08 00 00 00       	mov    $0x8,%edi
  a6af9f:	be 20 00 00 00       	mov    $0x20,%esi
  a6afa4:	ff 15 5e 4e ac 00    	call   *0xac4e5e(%rip)        # 152fe08 <_DYNAMIC+0x268>
  a6afaa:	e9 d9 00 00 00       	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6afaf:	48 8d 15 32 6f a5 00 	lea    0xa56f32(%rip),%rdx        # 14c1ee8 <anon.fc2f92b0223d15b7043d040ea72c4e93.10.llvm.5483804487471879235>
  a6afb6:	48 89 c7             	mov    %rax,%rdi
  a6afb9:	ff 15 91 4e ac 00    	call   *0xac4e91(%rip)        # 152fe50 <_DYNAMIC+0x2b0>
  a6afbf:	c6 84 24 10 01 00 00 	movb   $0x1,0x110(%rsp)
  a6afc6:	01 
  a6afc7:	48 8d 3d d7 79 73 ff 	lea    -0x8c8629(%rip),%rdi        # 1a29a5 <anon.5d7b745689a4da2246def3d316fdcab4.1.llvm.18443242379705941574+0x5779>
  a6afce:	48 8d 15 e3 70 a5 00 	lea    0xa570e3(%rip),%rdx        # 14c20b8 <anon.fc2f92b0223d15b7043d040ea72c4e93.10.llvm.5483804487471879235+0x1d0>
  a6afd5:	be 1d 00 00 00       	mov    $0x1d,%esi
  a6afda:	ff 15 38 4f ac 00    	call   *0xac4f38(%rip)        # 152ff18 <_DYNAMIC+0x378>
  a6afe0:	e9 a3 00 00 00       	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6afe5:	4c 8d 05 84 70 a5 00 	lea    0xa57084(%rip),%r8        # 14c2070 <anon.fc2f92b0223d15b7043d040ea72c4e93.10.llvm.5483804487471879235+0x188>
  a6afec:	4c 89 e7             	mov    %r12,%rdi
  a6afef:	4c 89 fa             	mov    %r15,%rdx
  a6aff2:	48 89 e9             	mov    %rbp,%rcx
  a6aff5:	ff 15 9d 63 ac 00    	call   *0xac639d(%rip)        # 1531398 <_DYNAMIC+0x17f8>
  a6affb:	e9 88 00 00 00       	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6b000:	48 8d 3d f9 6e a5 00 	lea    0xa56ef9(%rip),%rdi        # 14c1f00 <anon.fc2f92b0223d15b7043d040ea72c4e93.10.llvm.5483804487471879235+0x18>
  a6b007:	ff 15 0b 4e ac 00    	call   *0xac4e0b(%rip)        # 152fe18 <_DYNAMIC+0x278>
  a6b00d:	eb 79                	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6b00f:	48 8d 3d c7 4f 73 ff 	lea    -0x8cb039(%rip),%rdi        # 19ffdd <anon.5d7b745689a4da2246def3d316fdcab4.1.llvm.18443242379705941574+0x2db1>
  a6b016:	48 8d 15 fb 6e a5 00 	lea    0xa56efb(%rip),%rdx        # 14c1f18 <anon.fc2f92b0223d15b7043d040ea72c4e93.10.llvm.5483804487471879235+0x30>
  a6b01d:	be 1c 00 00 00       	mov    $0x1c,%esi
  a6b022:	ff 15 f0 4e ac 00    	call   *0xac4ef0(%rip)        # 152ff18 <_DYNAMIC+0x378>
  a6b028:	eb 5e                	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6b02a:	48 8d 3d 6f 6e a5 00 	lea    0xa56e6f(%rip),%rdi        # 14c1ea0 <anon.462c0f24c8d7f5d6db73fdd613655c56.0.llvm.5976073753952528974+0x1b8>
  a6b031:	ff 15 e1 4d ac 00    	call   *0xac4de1(%rip)        # 152fe18 <_DYNAMIC+0x278>
  a6b037:	eb 4f                	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6b039:	bf 01 00 00 00       	mov    $0x1,%edi
  a6b03e:	48 89 de             	mov    %rbx,%rsi
  a6b041:	ff 15 91 4e ac 00    	call   *0xac4e91(%rip)        # 152fed8 <_DYNAMIC+0x338>
  a6b047:	eb 3f                	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6b049:	48 8d 15 f0 6f a5 00 	lea    0xa56ff0(%rip),%rdx        # 14c2040 <anon.fc2f92b0223d15b7043d040ea72c4e93.10.llvm.5483804487471879235+0x158>
  a6b050:	ff 15 fa 4d ac 00    	call   *0xac4dfa(%rip)        # 152fe50 <_DYNAMIC+0x2b0>
  a6b056:	eb 30                	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6b058:	bf 01 00 00 00       	mov    $0x1,%edi
  a6b05d:	4c 89 fe             	mov    %r15,%rsi
  a6b060:	ff 15 72 4e ac 00    	call   *0xac4e72(%rip)        # 152fed8 <_DYNAMIC+0x338>
  a6b066:	eb 20                	jmp    a6b088 <<gpui::native::accessibility::text::Cohort>::append+0x1938>
  a6b068:	48 89 9c 24 20 01 00 	mov    %rbx,0x120(%rsp)
  a6b06f:	00 
  a6b070:	bf 04 00 00 00       	mov    $0x4,%edi
  a6b075:	e9 8b fd ff ff       	jmp    a6ae05 <<gpui::native::accessibility::text::Cohort>::append+0x16b5>
  a6b07a:	bf 04 00 00 00       	mov    $0x4,%edi
  a6b07f:	48 89 de             	mov    %rbx,%rsi
  a6b082:	ff 15 50 4e ac 00    	call   *0xac4e50(%rip)        # 152fed8 <_DYNAMIC+0x338>
  a6b088:	0f 0b                	ud2
  a6b08a:	e9 06 01 00 00       	jmp    a6b195 <<gpui::native::accessibility::text::Cohort>::append+0x1a45>
  a6b08f:	e9 01 01 00 00       	jmp    a6b195 <<gpui::native::accessibility::text::Cohort>::append+0x1a45>
  a6b094:	48 89 c3             	mov    %rax,%rbx
  a6b097:	48 8d bc 24 70 01 00 	lea    0x170(%rsp),%rdi
  a6b09e:	00 
  a6b09f:	e8 ec d8 ff ff       	call   a68990 <core::ptr::drop_glue::<(accesskit::NodeId, accesskit::Node)>>
  a6b0a4:	e9 f9 01 00 00       	jmp    a6b2a2 <<gpui::native::accessibility::text::Cohort>::append+0x1b52>
  a6b0a9:	ff 15 79 4d ac 00    	call   *0xac4d79(%rip)        # 152fe28 <_DYNAMIC+0x288>
  a6b0af:	48 89 c3             	mov    %rax,%rbx
  a6b0b2:	48 8d bc 24 70 01 00 	lea    0x170(%rsp),%rdi
  a6b0b9:	00 
  a6b0ba:	e8 d1 d8 ff ff       	call   a68990 <core::ptr::drop_glue::<(accesskit::NodeId, accesskit::Node)>>
  a6b0bf:	eb 34                	jmp    a6b0f5 <<gpui::native::accessibility::text::Cohort>::append+0x19a5>
  a6b0c1:	ff 15 61 4d ac 00    	call   *0xac4d61(%rip)        # 152fe28 <_DYNAMIC+0x288>
  a6b0c7:	48 89 c3             	mov    %rax,%rbx
  a6b0ca:	e9 f5 00 00 00       	jmp    a6b1c4 <<gpui::native::accessibility::text::Cohort>::append+0x1a74>
  a6b0cf:	48 89 c3             	mov    %rax,%rbx
  a6b0d2:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a6b0d7:	e8 74 d6 ff ff       	call   a68750 <core::ptr::drop_glue::<accesskit::Node>>
  a6b0dc:	e9 c1 01 00 00       	jmp    a6b2a2 <<gpui::native::accessibility::text::Cohort>::append+0x1b52>
  a6b0e1:	e9 fe 00 00 00       	jmp    a6b1e4 <<gpui::native::accessibility::text::Cohort>::append+0x1a94>
  a6b0e6:	eb 7d                	jmp    a6b165 <<gpui::native::accessibility::text::Cohort>::append+0x1a15>
  a6b0e8:	48 89 c3             	mov    %rax,%rbx
  a6b0eb:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a6b0f0:	e8 5b d6 ff ff       	call   a68750 <core::ptr::drop_glue::<accesskit::Node>>
  a6b0f5:	40 b5 01             	mov    $0x1,%bpl
  a6b0f8:	e9 40 01 00 00       	jmp    a6b23d <<gpui::native::accessibility::text::Cohort>::append+0x1aed>
  a6b0fd:	ff 15 25 4d ac 00    	call   *0xac4d25(%rip)        # 152fe28 <_DYNAMIC+0x288>
  a6b103:	48 89 c3             	mov    %rax,%rbx
  a6b106:	e9 90 00 00 00       	jmp    a6b19b <<gpui::native::accessibility::text::Cohort>::append+0x1a4b>
  a6b10b:	eb 58                	jmp    a6b165 <<gpui::native::accessibility::text::Cohort>::append+0x1a15>
  a6b10d:	48 89 c3             	mov    %rax,%rbx
  a6b110:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  a6b115:	48 85 f6             	test   %rsi,%rsi
  a6b118:	74 4e                	je     a6b168 <<gpui::native::accessibility::text::Cohort>::append+0x1a18>
  a6b11a:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  a6b11f:	48 c1 e6 03          	shl    $0x3,%rsi
  a6b123:	ba 08 00 00 00       	mov    $0x8,%edx
  a6b128:	ff 15 c2 4c ac 00    	call   *0xac4cc2(%rip)        # 152fdf0 <_DYNAMIC+0x250>
  a6b12e:	eb 38                	jmp    a6b168 <<gpui::native::accessibility::text::Cohort>::append+0x1a18>
  a6b130:	eb 33                	jmp    a6b165 <<gpui::native::accessibility::text::Cohort>::append+0x1a15>
  a6b132:	eb 24                	jmp    a6b158 <<gpui::native::accessibility::text::Cohort>::append+0x1a08>
  a6b134:	48 89 c3             	mov    %rax,%rbx
  a6b137:	48 8d bc 24 e0 02 00 	lea    0x2e0(%rsp),%rdi
  a6b13e:	00 
  a6b13f:	e8 0c d6 ff ff       	call   a68750 <core::ptr::drop_glue::<accesskit::Node>>
  a6b144:	e9 59 01 00 00       	jmp    a6b2a2 <<gpui::native::accessibility::text::Cohort>::append+0x1b52>
  a6b149:	ff 15 d9 4c ac 00    	call   *0xac4cd9(%rip)        # 152fe28 <_DYNAMIC+0x288>
  a6b14f:	e9 90 00 00 00       	jmp    a6b1e4 <<gpui::native::accessibility::text::Cohort>::append+0x1a94>
  a6b154:	eb 3f                	jmp    a6b195 <<gpui::native::accessibility::text::Cohort>::append+0x1a45>
  a6b156:	eb 3d                	jmp    a6b195 <<gpui::native::accessibility::text::Cohort>::append+0x1a45>
  a6b158:	48 89 c3             	mov    %rax,%rbx
  a6b15b:	40 b5 01             	mov    $0x1,%bpl
  a6b15e:	e9 da 00 00 00       	jmp    a6b23d <<gpui::native::accessibility::text::Cohort>::append+0x1aed>
  a6b163:	eb 30                	jmp    a6b195 <<gpui::native::accessibility::text::Cohort>::append+0x1a45>
  a6b165:	48 89 c3             	mov    %rax,%rbx
  a6b168:	40 b5 01             	mov    $0x1,%bpl
  a6b16b:	48 8d bc 24 30 02 00 	lea    0x230(%rsp),%rdi
  a6b172:	00 
  a6b173:	e8 d8 d5 ff ff       	call   a68750 <core::ptr::drop_glue::<accesskit::Node>>
  a6b178:	e9 c0 00 00 00       	jmp    a6b23d <<gpui::native::accessibility::text::Cohort>::append+0x1aed>
  a6b17d:	ff 15 a5 4c ac 00    	call   *0xac4ca5(%rip)        # 152fe28 <_DYNAMIC+0x288>
  a6b183:	48 89 c3             	mov    %rax,%rbx
  a6b186:	0f b6 ac 24 10 01 00 	movzbl 0x110(%rsp),%ebp
  a6b18d:	00 
  a6b18e:	e9 aa 00 00 00       	jmp    a6b23d <<gpui::native::accessibility::text::Cohort>::append+0x1aed>
  a6b193:	eb 00                	jmp    a6b195 <<gpui::native::accessibility::text::Cohort>::append+0x1a45>
  a6b195:	48 89 c3             	mov    %rax,%rbx
  a6b198:	41 b4 01             	mov    $0x1,%r12b
  a6b19b:	48 8b b4 24 d8 00 00 	mov    0xd8(%rsp),%rsi
  a6b1a2:	00 
  a6b1a3:	48 85 f6             	test   %rsi,%rsi
  a6b1a6:	74 17                	je     a6b1bf <<gpui::native::accessibility::text::Cohort>::append+0x1a6f>
  a6b1a8:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  a6b1af:	00 
  a6b1b0:	48 c1 e6 02          	shl    $0x2,%rsi
  a6b1b4:	ba 04 00 00 00       	mov    $0x4,%edx
  a6b1b9:	ff 15 31 4c ac 00    	call   *0xac4c31(%rip)        # 152fdf0 <_DYNAMIC+0x250>
  a6b1bf:	45 84 e4             	test   %r12b,%r12b
  a6b1c2:	74 23                	je     a6b1e7 <<gpui::native::accessibility::text::Cohort>::append+0x1a97>
  a6b1c4:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  a6b1c9:	48 85 f6             	test   %rsi,%rsi
  a6b1cc:	74 19                	je     a6b1e7 <<gpui::native::accessibility::text::Cohort>::append+0x1a97>
  a6b1ce:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  a6b1d3:	48 c1 e6 02          	shl    $0x2,%rsi
  a6b1d7:	ba 04 00 00 00       	mov    $0x4,%edx
  a6b1dc:	ff 15 0e 4c ac 00    	call   *0xac4c0e(%rip)        # 152fdf0 <_DYNAMIC+0x250>
  a6b1e2:	eb 03                	jmp    a6b1e7 <<gpui::native::accessibility::text::Cohort>::append+0x1a97>
  a6b1e4:	48 89 c3             	mov    %rax,%rbx
  a6b1e7:	4c 8b b4 24 78 01 00 	mov    0x178(%rsp),%r14
  a6b1ee:	00 
  a6b1ef:	4c 8b a4 24 80 01 00 	mov    0x180(%rsp),%r12
  a6b1f6:	00 
  a6b1f7:	49 ff c4             	inc    %r12
  a6b1fa:	4c 89 f7             	mov    %r14,%rdi
  a6b1fd:	0f 1f 00             	nopl   (%rax)
  a6b200:	49 83 fc 01          	cmp    $0x1,%r12
  a6b204:	74 11                	je     a6b217 <<gpui::native::accessibility::text::Cohort>::append+0x1ac7>
  a6b206:	4c 8d 7f 28          	lea    0x28(%rdi),%r15
  a6b20a:	49 ff cc             	dec    %r12
  a6b20d:	e8 2e 3b 01 00       	call   a7ed40 <core::ptr::drop_glue::<accesskit::PropertyValue>>
  a6b212:	4c 89 ff             	mov    %r15,%rdi
  a6b215:	eb e9                	jmp    a6b200 <<gpui::native::accessibility::text::Cohort>::append+0x1ab0>
  a6b217:	48 8b 84 24 70 01 00 	mov    0x170(%rsp),%rax
  a6b21e:	00 
  a6b21f:	40 b5 01             	mov    $0x1,%bpl
  a6b222:	48 85 c0             	test   %rax,%rax
  a6b225:	74 16                	je     a6b23d <<gpui::native::accessibility::text::Cohort>::append+0x1aed>
  a6b227:	48 c1 e0 03          	shl    $0x3,%rax
  a6b22b:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  a6b22f:	ba 08 00 00 00       	mov    $0x8,%edx
  a6b234:	4c 89 f7             	mov    %r14,%rdi
  a6b237:	ff 15 b3 4b ac 00    	call   *0xac4bb3(%rip)        # 152fdf0 <_DYNAMIC+0x250>
  a6b23d:	4c 8b a4 24 c0 03 00 	mov    0x3c0(%rsp),%r12
  a6b244:	00 
  a6b245:	49 83 fc ff          	cmp    $0xffffffffffffffff,%r12
  a6b249:	0f 95 c0             	setne  %al
  a6b24c:	40 84 c5             	test   %al,%bpl
  a6b24f:	74 51                	je     a6b2a2 <<gpui::native::accessibility::text::Cohort>::append+0x1b52>
  a6b251:	4c 8b b4 24 c8 03 00 	mov    0x3c8(%rsp),%r14
  a6b258:	00 
  a6b259:	4c 8b ac 24 d0 03 00 	mov    0x3d0(%rsp),%r13
  a6b260:	00 
  a6b261:	49 ff c5             	inc    %r13
  a6b264:	4c 89 f7             	mov    %r14,%rdi
  a6b267:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  a6b26e:	00 00 
  a6b270:	49 83 fd 01          	cmp    $0x1,%r13
  a6b274:	74 11                	je     a6b287 <<gpui::native::accessibility::text::Cohort>::append+0x1b37>
  a6b276:	4c 8d 7f 28          	lea    0x28(%rdi),%r15
  a6b27a:	49 ff cd             	dec    %r13
  a6b27d:	e8 be 3a 01 00       	call   a7ed40 <core::ptr::drop_glue::<accesskit::PropertyValue>>
  a6b282:	4c 89 ff             	mov    %r15,%rdi
  a6b285:	eb e9                	jmp    a6b270 <<gpui::native::accessibility::text::Cohort>::append+0x1b20>
  a6b287:	4d 85 e4             	test   %r12,%r12
  a6b28a:	74 16                	je     a6b2a2 <<gpui::native::accessibility::text::Cohort>::append+0x1b52>
  a6b28c:	49 c1 e4 03          	shl    $0x3,%r12
  a6b290:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  a6b294:	ba 08 00 00 00       	mov    $0x8,%edx
  a6b299:	4c 89 f7             	mov    %r14,%rdi
  a6b29c:	ff 15 4e 4b ac 00    	call   *0xac4b4e(%rip)        # 152fdf0 <_DYNAMIC+0x250>
  a6b2a2:	48 89 df             	mov    %rbx,%rdi
  a6b2a5:	e8 c6 f3 a4 00       	call   14ba670 <_Unwind_Resume@plt>
  a6b2aa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  a6b2b0:	49 ff cd             	dec    %r13
  a6b2b3:	74 11                	je     a6b2c6 <<gpui::native::accessibility::text::Cohort>::append+0x1b76>
  a6b2b5:	49 8d 5f 28          	lea    0x28(%r15),%rbx
  a6b2b9:	4c 89 ff             	mov    %r15,%rdi
  a6b2bc:	e8 7f 3a 01 00       	call   a7ed40 <core::ptr::drop_glue::<accesskit::PropertyValue>>
  a6b2c1:	49 89 df             	mov    %rbx,%r15
  a6b2c4:	eb ea                	jmp    a6b2b0 <<gpui::native::accessibility::text::Cohort>::append+0x1b60>
  a6b2c6:	4d 85 e4             	test   %r12,%r12
  a6b2c9:	74 4e                	je     a6b319 <<gpui::native::accessibility::text::Cohort>::append+0x1bc9>
  a6b2cb:	49 c1 e4 03          	shl    $0x3,%r12
  a6b2cf:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  a6b2d3:	eb 36                	jmp    a6b30b <<gpui::native::accessibility::text::Cohort>::append+0x1bbb>
  a6b2d5:	ff 15 4d 4b ac 00    	call   *0xac4b4d(%rip)        # 152fe28 <_DYNAMIC+0x288>
  a6b2db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  a6b2e0:	49 ff cc             	dec    %r12
  a6b2e3:	74 11                	je     a6b2f6 <<gpui::native::accessibility::text::Cohort>::append+0x1ba6>
  a6b2e5:	49 8d 5f 28          	lea    0x28(%r15),%rbx
  a6b2e9:	4c 89 ff             	mov    %r15,%rdi
  a6b2ec:	e8 4f 3a 01 00       	call   a7ed40 <core::ptr::drop_glue::<accesskit::PropertyValue>>
  a6b2f1:	49 89 df             	mov    %rbx,%r15
  a6b2f4:	eb ea                	jmp    a6b2e0 <<gpui::native::accessibility::text::Cohort>::append+0x1b90>
  a6b2f6:	48 8b 84 24 70 01 00 	mov    0x170(%rsp),%rax
  a6b2fd:	00 
  a6b2fe:	48 85 c0             	test   %rax,%rax
  a6b301:	74 16                	je     a6b319 <<gpui::native::accessibility::text::Cohort>::append+0x1bc9>
  a6b303:	48 c1 e0 03          	shl    $0x3,%rax
  a6b307:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  a6b30b:	ba 08 00 00 00       	mov    $0x8,%edx
  a6b310:	4c 89 f7             	mov    %r14,%rdi
  a6b313:	ff 15 d7 4a ac 00    	call   *0xac4ad7(%rip)        # 152fdf0 <_DYNAMIC+0x250>
  a6b319:	ff 15 09 4b ac 00    	call   *0xac4b09(%rip)        # 152fe28 <_DYNAMIC+0x288>
  a6b31f:	ff 15 03 4b ac 00    	call   *0xac4b03(%rip)        # 152fe28 <_DYNAMIC+0x288>
