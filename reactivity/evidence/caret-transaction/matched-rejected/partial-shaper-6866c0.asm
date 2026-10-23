
/tmp/gpui-caret-transaction-bin/matched-partial-caret_pair_measure:     file format elf64-x86-64


Disassembly of section .text:

00000000006866c0 <<parley::editing::geometry::CursorGeometry<()>>::new>:
  6866c0:	55                   	push   %rbp
  6866c1:	41 57                	push   %r15
  6866c3:	41 56                	push   %r14
  6866c5:	41 55                	push   %r13
  6866c7:	41 54                	push   %r12
  6866c9:	53                   	push   %rbx
  6866ca:	48 81 ec 18 04 00 00 	sub    $0x418,%rsp
  6866d1:	4c 8b 7e 70          	mov    0x70(%rsi),%r15
  6866d5:	4c 89 f8             	mov    %r15,%rax
  6866d8:	48 c1 e8 20          	shr    $0x20,%rax
  6866dc:	75 10                	jne    6866ee <<parley::editing::geometry::CursorGeometry<()>>::new+0x2e>
  6866de:	48 8b 9e 18 01 00 00 	mov    0x118(%rsi),%rbx
  6866e5:	48 89 d8             	mov    %rbx,%rax
  6866e8:	48 c1 e8 20          	shr    $0x20,%rax
  6866ec:	74 1c                	je     68670a <<parley::editing::geometry::CursorGeometry<()>>::new+0x4a>
  6866ee:	48 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%rdi)
  6866f5:	48 89 f8             	mov    %rdi,%rax
  6866f8:	48 81 c4 18 04 00 00 	add    $0x418,%rsp
  6866ff:	5b                   	pop    %rbx
  686700:	41 5c                	pop    %r12
  686702:	41 5d                	pop    %r13
  686704:	41 5e                	pop    %r14
  686706:	41 5f                	pop    %r15
  686708:	5d                   	pop    %rbp
  686709:	c3                   	ret
  68670a:	4d 89 fe             	mov    %r15,%r14
  68670d:	49 c1 e6 04          	shl    $0x4,%r14
  686711:	4d 85 ff             	test   %r15,%r15
  686714:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  686719:	74 2f                	je     68674a <<parley::editing::geometry::CursorGeometry<()>>::new+0x8a>
  68671b:	49 89 fc             	mov    %rdi,%r12
  68671e:	ff 15 bc 29 10 00    	call   *0x1029bc(%rip)        # 7890e0 <_DYNAMIC+0x2c8>
  686724:	be 04 00 00 00       	mov    $0x4,%esi
  686729:	4c 89 f7             	mov    %r14,%rdi
  68672c:	ff 15 16 29 10 00    	call   *0x102916(%rip)        # 789048 <_DYNAMIC+0x230>
  686732:	48 85 c0             	test   %rax,%rax
  686735:	0f 84 c3 07 00 00    	je     686efe <<parley::editing::geometry::CursorGeometry<()>>::new+0x83e>
  68673b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  686740:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  686745:	4c 89 e7             	mov    %r12,%rdi
  686748:	eb 0a                	jmp    686754 <<parley::editing::geometry::CursorGeometry<()>>::new+0x94>
  68674a:	b8 04 00 00 00       	mov    $0x4,%eax
  68674f:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  686754:	48 b9 f8 ff ff ff ff 	movabs $0x7ffffffffffffff8,%rcx
  68675b:	ff ff 7f 
  68675e:	48 8b 96 50 01 00 00 	mov    0x150(%rsi),%rdx
  686765:	4c 8d 24 95 00 00 00 	lea    0x0(,%rdx,4),%r12
  68676c:	00 
  68676d:	48 89 d0             	mov    %rdx,%rax
  686770:	48 c1 e8 3e          	shr    $0x3e,%rax
  686774:	0f 95 c0             	setne  %al
  686777:	48 83 c1 04          	add    $0x4,%rcx
  68677b:	49 39 cc             	cmp    %rcx,%r12
  68677e:	0f 97 c1             	seta   %cl
  686781:	08 c1                	or     %al,%cl
  686783:	74 13                	je     686798 <<parley::editing::geometry::CursorGeometry<()>>::new+0xd8>
  686785:	31 ed                	xor    %ebp,%ebp
  686787:	48 89 ef             	mov    %rbp,%rdi
  68678a:	4c 89 e6             	mov    %r12,%rsi
  68678d:	ff 15 d5 29 10 00    	call   *0x1029d5(%rip)        # 789168 <_DYNAMIC+0x350>
  686793:	e9 c4 07 00 00       	jmp    686f5c <<parley::editing::geometry::CursorGeometry<()>>::new+0x89c>
  686798:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  68679d:	48 89 bc 24 88 00 00 	mov    %rdi,0x88(%rsp)
  6867a4:	00 
  6867a5:	4d 85 e4             	test   %r12,%r12
  6867a8:	74 5b                	je     686805 <<parley::editing::geometry::CursorGeometry<()>>::new+0x145>
  6867aa:	ff 15 30 29 10 00    	call   *0x102930(%rip)        # 7890e0 <_DYNAMIC+0x2c8>
  6867b0:	bd 04 00 00 00       	mov    $0x4,%ebp
  6867b5:	be 04 00 00 00       	mov    $0x4,%esi
  6867ba:	4c 89 e7             	mov    %r12,%rdi
  6867bd:	ff 15 85 28 10 00    	call   *0x102885(%rip)        # 789048 <_DYNAMIC+0x230>
  6867c3:	48 85 c0             	test   %rax,%rax
  6867c6:	74 bf                	je     686787 <<parley::editing::geometry::CursorGeometry<()>>::new+0xc7>
  6867c8:	49 89 c5             	mov    %rax,%r13
  6867cb:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  6867d0:	49 89 ce             	mov    %rcx,%r14
  6867d3:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  6867d8:	48 83 f9 02          	cmp    $0x2,%rcx
  6867dc:	72 3b                	jb     686819 <<parley::editing::geometry::CursorGeometry<()>>::new+0x159>
  6867de:	49 8d 54 24 fc       	lea    -0x4(%r12),%rdx
  6867e3:	4c 89 ef             	mov    %r13,%rdi
  6867e6:	be ff 00 00 00       	mov    $0xff,%esi
  6867eb:	ff 15 67 29 10 00    	call   *0x102967(%rip)        # 789158 <memset@GLIBC_2.2.5>
  6867f1:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  6867f6:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
  6867fa:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  6867fe:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  686803:	eb 21                	jmp    686826 <<parley::editing::geometry::CursorGeometry<()>>::new+0x166>
  686805:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  68680b:	45 31 f6             	xor    %r14d,%r14d
  68680e:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  686813:	48 83 f9 02          	cmp    $0x2,%rcx
  686817:	73 c5                	jae    6867de <<parley::editing::geometry::CursorGeometry<()>>::new+0x11e>
  686819:	4c 89 e8             	mov    %r13,%rax
  68681c:	48 85 c9             	test   %rcx,%rcx
  68681f:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  686824:	74 06                	je     68682c <<parley::editing::geometry::CursorGeometry<()>>::new+0x16c>
  686826:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%rax)
  68682c:	4c 89 74 24 58       	mov    %r14,0x58(%rsp)
  686831:	4c 89 6c 24 60       	mov    %r13,0x60(%rsp)
  686836:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  68683b:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  686840:	48 89 74 24 70       	mov    %rsi,0x70(%rsp)
  686845:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
  68684a:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
  68684f:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  686856:	00 00 
  686858:	48 85 db             	test   %rbx,%rbx
  68685b:	0f 84 22 06 00 00    	je     686e83 <<parley::editing::geometry::CursorGeometry<()>>::new+0x7c3>
  686861:	4c 8b a6 10 01 00 00 	mov    0x110(%rsi),%r12
  686868:	4c 6b c3 70          	imul   $0x70,%rbx,%r8
  68686c:	4d 01 e0             	add    %r12,%r8
  68686f:	4c 8d ac 24 e8 01 00 	lea    0x1e8(%rsp),%r13
  686876:	00 
  686877:	48 8b 96 30 01 00 00 	mov    0x130(%rsi),%rdx
  68687e:	4c 8b 8e 28 01 00 00 	mov    0x128(%rsi),%r9
  686885:	48 8b 4e 58          	mov    0x58(%rsi),%rcx
  686889:	4c 8b 96 e8 00 00 00 	mov    0xe8(%rsi),%r10
  686890:	48 8b 9e e0 00 00 00 	mov    0xe0(%rsi),%rbx
  686897:	4c 8b 5e 50          	mov    0x50(%rsi),%r11
  68689b:	48 8b 46 38          	mov    0x38(%rsi),%rax
  68689f:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  6868a6:	00 
  6868a7:	48 8b 46 40          	mov    0x40(%rsi),%rax
  6868ab:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  6868b2:	00 
  6868b3:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  6868ba:	00 00 
  6868bc:	48 8d 05 b5 8e 0f 00 	lea    0xf8eb5(%rip),%rax        # 77f778 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941+0xc0>
  6868c3:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6868c8:	48 8d 05 11 8a 0f 00 	lea    0xf8a11(%rip),%rax        # 77f2e0 <anon.d4a86088305c8823b863e6abd2e38045.3.llvm.2509172480284221941>
  6868cf:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  6868d4:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  6868d9:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  6868e0:	00 
  6868e1:	4c 89 84 24 b8 00 00 	mov    %r8,0xb8(%rsp)
  6868e8:	00 
  6868e9:	4c 89 8c 24 b0 00 00 	mov    %r9,0xb0(%rsp)
  6868f0:	00 
  6868f1:	4c 89 94 24 a8 00 00 	mov    %r10,0xa8(%rsp)
  6868f8:	00 
  6868f9:	48 89 9c 24 c8 00 00 	mov    %rbx,0xc8(%rsp)
  686900:	00 
  686901:	4c 89 9c 24 a0 00 00 	mov    %r11,0xa0(%rsp)
  686908:	00 
  686909:	49 8b 7c 24 10       	mov    0x10(%r12),%rdi
  68690e:	49 8b 44 24 18       	mov    0x18(%r12),%rax
  686913:	48 39 f8             	cmp    %rdi,%rax
  686916:	0f 82 b5 05 00 00    	jb     686ed1 <<parley::editing::geometry::CursorGeometry<()>>::new+0x811>
  68691c:	48 39 d0             	cmp    %rdx,%rax
  68691f:	0f 87 ac 05 00 00    	ja     686ed1 <<parley::editing::geometry::CursorGeometry<()>>::new+0x811>
  686925:	48 39 c7             	cmp    %rax,%rdi
  686928:	75 1a                	jne    686944 <<parley::editing::geometry::CursorGeometry<()>>::new+0x284>
  68692a:	49 83 c4 70          	add    $0x70,%r12
  68692e:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  686933:	ff c0                	inc    %eax
  686935:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  68693a:	4d 39 c4             	cmp    %r8,%r12
  68693d:	75 ca                	jne    686909 <<parley::editing::geometry::CursorGeometry<()>>::new+0x249>
  68693f:	e9 3f 05 00 00       	jmp    686e83 <<parley::editing::geometry::CursorGeometry<()>>::new+0x7c3>
  686944:	f3 41 0f 10 44 24 28 	movss  0x28(%r12),%xmm0
  68694b:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
  686951:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  686955:	4d 8d 34 c1          	lea    (%r9,%rax,8),%r14
  686959:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  68695d:	4d 8d 3c c1          	lea    (%r9,%rax,8),%r15
  686961:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%rsp)
  686968:	00 
  686969:	4c 89 b4 24 d0 00 00 	mov    %r14,0xd0(%rsp)
  686970:	00 
  686971:	49 8b 7f 10          	mov    0x10(%r15),%rdi
  686975:	41 80 7f 21 01       	cmpb   $0x1,0x21(%r15)
  68697a:	75 42                	jne    6869be <<parley::editing::geometry::CursorGeometry<()>>::new+0x2fe>
  68697c:	48 3b bc 24 80 00 00 	cmp    0x80(%rsp),%rdi
  686983:	00 
  686984:	0f 83 a9 05 00 00    	jae    686f33 <<parley::editing::geometry::CursorGeometry<()>>::new+0x873>
  68698a:	48 6b c7 38          	imul   $0x38,%rdi,%rax
  68698e:	48 8b bc 24 d8 00 00 	mov    0xd8(%rsp),%rdi
  686995:	00 
  686996:	f3 0f 10 44 07 24    	movss  0x24(%rdi,%rax,1),%xmm0
  68699c:	49 83 c7 28          	add    $0x28,%r15
  6869a0:	ff 44 24 14          	incl   0x14(%rsp)
  6869a4:	f3 0f 10 4c 24 10    	movss  0x10(%rsp),%xmm1
  6869aa:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  6869ae:	f3 0f 11 4c 24 10    	movss  %xmm1,0x10(%rsp)
  6869b4:	4d 39 f7             	cmp    %r14,%r15
  6869b7:	75 b8                	jne    686971 <<parley::editing::geometry::CursorGeometry<()>>::new+0x2b1>
  6869b9:	e9 6c ff ff ff       	jmp    68692a <<parley::editing::geometry::CursorGeometry<()>>::new+0x26a>
  6869be:	48 39 cf             	cmp    %rcx,%rdi
  6869c1:	0f 83 85 05 00 00    	jae    686f4c <<parley::editing::geometry::CursorGeometry<()>>::new+0x88c>
  6869c7:	4c 39 d7             	cmp    %r10,%rdi
  6869ca:	0f 83 55 05 00 00    	jae    686f25 <<parley::editing::geometry::CursorGeometry<()>>::new+0x865>
  6869d0:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
  6869d4:	48 c1 e0 04          	shl    $0x4,%rax
  6869d8:	49 8d 0c 03          	lea    (%r11,%rax,1),%rcx
  6869dc:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  6869e0:	48 c1 e2 04          	shl    $0x4,%rdx
  6869e4:	48 01 da             	add    %rbx,%rdx
  6869e7:	48 89 b4 24 20 01 00 	mov    %rsi,0x120(%rsp)
  6869ee:	00 
  6869ef:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  6869f6:	00 
  6869f7:	48 89 94 24 30 01 00 	mov    %rdx,0x130(%rsp)
  6869fe:	00 
  6869ff:	4c 89 bc 24 38 01 00 	mov    %r15,0x138(%rsp)
  686a06:	00 
  686a07:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  686a0c:	89 8c 24 40 01 00 00 	mov    %ecx,0x140(%rsp)
  686a13:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  686a17:	89 8c 24 44 01 00 00 	mov    %ecx,0x144(%rsp)
  686a1e:	89 bc 24 48 01 00 00 	mov    %edi,0x148(%rsp)
  686a25:	41 0f b6 94 03 8c 00 	movzbl 0x8c(%r11,%rax,1),%edx
  686a2c:	00 00 
  686a2e:	83 e2 01             	and    $0x1,%edx
  686a31:	4c 8d b4 24 08 03 00 	lea    0x308(%rsp),%r14
  686a38:	00 
  686a39:	4c 89 f7             	mov    %r14,%rdi
  686a3c:	48 8d b4 24 20 01 00 	lea    0x120(%rsp),%rsi
  686a43:	00 
  686a44:	e8 c7 c8 ff ff       	call   683310 <<parley::layout::run::Clusters<()>>::new>
  686a49:	ba 10 01 00 00       	mov    $0x110,%edx
  686a4e:	48 8d 9c 24 f8 01 00 	lea    0x1f8(%rsp),%rbx
  686a55:	00 
  686a56:	48 89 df             	mov    %rbx,%rdi
  686a59:	4c 89 f6             	mov    %r14,%rsi
  686a5c:	ff 15 86 26 10 00    	call   *0x102686(%rip)        # 7890e8 <memcpy@GLIBC_2.14>
  686a62:	66 0f 6e 44 24 10    	movd   0x10(%rsp),%xmm0
  686a68:	66 0f 7e 44 24 08    	movd   %xmm0,0x8(%rsp)
  686a6e:	eb 18                	jmp    686a88 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3c8>
  686a70:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
  686a76:	f3 0f 58 c1          	addss  %xmm1,%xmm0
  686a7a:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  686a80:	48 8d 9c 24 f8 01 00 	lea    0x1f8(%rsp),%rbx
  686a87:	00 
  686a88:	48 8d bc 24 68 01 00 	lea    0x168(%rsp),%rdi
  686a8f:	00 
  686a90:	48 89 de             	mov    %rbx,%rsi
  686a93:	e8 68 cb ff ff       	call   683600 <<parley::layout::run::Clusters<()>>::advance_cursor>
  686a98:	83 bc 24 68 01 00 00 	cmpl   $0x1,0x168(%rsp)
  686a9f:	01 
  686aa0:	0f 85 2b 03 00 00    	jne    686dd1 <<parley::editing::geometry::CursorGeometry<()>>::new+0x711>
  686aa6:	41 0f 10 45 84       	movups -0x7c(%r13),%xmm0
  686aab:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  686ab2:	00 
  686ab3:	48 8b 84 24 b0 02 00 	mov    0x2b0(%rsp),%rax
  686aba:	00 
  686abb:	48 85 c0             	test   %rax,%rax
  686abe:	0f 84 1f 04 00 00    	je     686ee3 <<parley::editing::geometry::CursorGeometry<()>>::new+0x823>
  686ac4:	48 8b 9c 24 f8 01 00 	mov    0x1f8(%rsp),%rbx
  686acb:	00 
  686acc:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
  686ad3:	00 
  686ad4:	0f 29 84 24 50 01 00 	movaps %xmm0,0x150(%rsp)
  686adb:	00 
  686adc:	48 85 db             	test   %rbx,%rbx
  686adf:	0f 84 ec 02 00 00    	je     686dd1 <<parley::editing::geometry::CursorGeometry<()>>::new+0x711>
  686ae5:	48 89 9c 24 68 01 00 	mov    %rbx,0x168(%rsp)
  686aec:	00 
  686aed:	48 8d 94 24 b8 02 00 	lea    0x2b8(%rsp),%rdx
  686af4:	00 
  686af5:	48 8b 8a 68 ff ff ff 	mov    -0x98(%rdx),%rcx
  686afc:	49 89 4d a8          	mov    %rcx,-0x58(%r13)
  686b00:	0f 10 82 48 ff ff ff 	movups -0xb8(%rdx),%xmm0
  686b07:	0f 10 8a 58 ff ff ff 	movups -0xa8(%rdx),%xmm1
  686b0e:	41 0f 11 4d 98       	movups %xmm1,-0x68(%r13)
  686b13:	41 0f 11 45 88       	movups %xmm0,-0x78(%r13)
  686b18:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
  686b1f:	00 
  686b20:	48 8b 42 40          	mov    0x40(%rdx),%rax
  686b24:	49 89 45 f8          	mov    %rax,-0x8(%r13)
  686b28:	0f 10 02             	movups (%rdx),%xmm0
  686b2b:	f3 0f 6f 4a 10       	movdqu 0x10(%rdx),%xmm1
  686b30:	0f 10 52 20          	movups 0x20(%rdx),%xmm2
  686b34:	0f 10 5a 30          	movups 0x30(%rdx),%xmm3
  686b38:	41 0f 11 5d e8       	movups %xmm3,-0x18(%r13)
  686b3d:	41 0f 11 55 d8       	movups %xmm2,-0x28(%r13)
  686b42:	f3 41 0f 7f 4d c8    	movdqu %xmm1,-0x38(%r13)
  686b48:	41 0f 11 45 b8       	movups %xmm0,-0x48(%r13)
  686b4d:	0f 28 84 24 50 01 00 	movaps 0x150(%rsp),%xmm0
  686b54:	00 
  686b55:	41 0f 11 45 00       	movups %xmm0,0x0(%r13)
  686b5a:	4c 8b 74 24 50       	mov    0x50(%rsp),%r14
  686b5f:	f3 0f 7e 84 24 88 01 	movq   0x188(%rsp),%xmm0
  686b66:	00 00 
  686b68:	66 0f 7f 84 24 90 00 	movdqa %xmm0,0x90(%rsp)
  686b6f:	00 00 
  686b71:	8b ac 24 e8 01 00 00 	mov    0x1e8(%rsp),%ebp
  686b78:	4c 3b 74 24 40       	cmp    0x40(%rsp),%r14
  686b7d:	75 0b                	jne    686b8a <<parley::editing::geometry::CursorGeometry<()>>::new+0x4ca>
  686b7f:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  686b84:	ff 15 be 27 10 00    	call   *0x1027be(%rip)        # 789348 <_DYNAMIC+0x530>
  686b8a:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  686b8f:	4c 89 f1             	mov    %r14,%rcx
  686b92:	48 c1 e1 04          	shl    $0x4,%rcx
  686b96:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  686b9d:	00 
  686b9e:	0f 13 04 08          	movlps %xmm0,(%rax,%rcx,1)
  686ba2:	89 6c 08 08          	mov    %ebp,0x8(%rax,%rcx,1)
  686ba6:	66 0f 6e 44 24 08    	movd   0x8(%rsp),%xmm0
  686bac:	66 0f 7e 44 08 0c    	movd   %xmm0,0xc(%rax,%rcx,1)
  686bb2:	49 8d 46 01          	lea    0x1(%r14),%rax
  686bb6:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  686bbb:	48 83 bc 24 80 01 00 	cmpq   $0x0,0x180(%rsp)
  686bc2:	00 00 
  686bc4:	74 2e                	je     686bf4 <<parley::editing::geometry::CursorGeometry<()>>::new+0x534>
  686bc6:	8b bc 24 88 01 00 00 	mov    0x188(%rsp),%edi
  686bcd:	48 8b b3 18 01 00 00 	mov    0x118(%rbx),%rsi
  686bd4:	48 39 fe             	cmp    %rdi,%rsi
  686bd7:	0f 86 3b 03 00 00    	jbe    686f18 <<parley::editing::geometry::CursorGeometry<()>>::new+0x858>
  686bdd:	48 8b 83 10 01 00 00 	mov    0x110(%rbx),%rax
  686be4:	48 6b cf 70          	imul   $0x70,%rdi,%rcx
  686be8:	66 0f 6e 44 08 50    	movd   0x50(%rax,%rcx,1),%xmm0
  686bee:	8b 44 08 54          	mov    0x54(%rax,%rcx,1),%eax
  686bf2:	eb 09                	jmp    686bfd <<parley::editing::geometry::CursorGeometry<()>>::new+0x53d>
  686bf4:	66 0f ef c0          	pxor   %xmm0,%xmm0
  686bf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  686bfd:	48 8b 8c 24 70 01 00 	mov    0x170(%rsp),%rcx
  686c04:	00 
  686c05:	48 8b 94 24 78 01 00 	mov    0x178(%rsp),%rdx
  686c0c:	00 
  686c0d:	f3 0f 7e 4a 44       	movq   0x44(%rdx),%xmm1
  686c12:	66 0f d6 8c 24 e0 00 	movq   %xmm1,0xe0(%rsp)
  686c19:	00 00 
  686c1b:	66 0f 7e 84 24 e8 00 	movd   %xmm0,0xe8(%rsp)
  686c22:	00 00 
  686c24:	89 84 24 ec 00 00 00 	mov    %eax,0xec(%rsp)
  686c2b:	0f b6 89 8c 00 00 00 	movzbl 0x8c(%rcx),%ecx
  686c32:	83 e1 01             	and    $0x1,%ecx
  686c35:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
  686c3c:	00 
  686c3d:	48 8d b4 24 98 01 00 	lea    0x198(%rsp),%rsi
  686c44:	00 
  686c45:	4c 89 ea             	mov    %r13,%rdx
  686c48:	ff 15 ca 2a 10 00    	call   *0x102aca(%rip)        # 789718 <_DYNAMIC+0x900>
  686c4e:	66 0f 6f c8          	movdqa %xmm0,%xmm1
  686c52:	48 83 7c 24 28 00    	cmpq   $0x0,0x28(%rsp)
  686c58:	0f 84 12 fe ff ff    	je     686a70 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3b0>
  686c5e:	66 0f 7e 8c 24 90 00 	movd   %xmm1,0x90(%rsp)
  686c65:	00 00 
  686c67:	8b bc 24 90 01 00 00 	mov    0x190(%rsp),%edi
  686c6e:	48 8b 73 58          	mov    0x58(%rbx),%rsi
  686c72:	48 39 fe             	cmp    %rdi,%rsi
  686c75:	0f 86 91 02 00 00    	jbe    686f0c <<parley::editing::geometry::CursorGeometry<()>>::new+0x84c>
  686c7b:	48 8b 43 50          	mov    0x50(%rbx),%rax
  686c7f:	48 8d 0c ff          	lea    (%rdi,%rdi,8),%rcx
  686c83:	48 c1 e1 04          	shl    $0x4,%rcx
  686c87:	f3 0f 6f 43 68       	movdqu 0x68(%rbx),%xmm0
  686c8c:	0f 10 8b 80 00 00 00 	movups 0x80(%rbx),%xmm1
  686c93:	0f 10 93 98 00 00 00 	movups 0x98(%rbx),%xmm2
  686c9a:	f3 0f 7f 84 24 e0 00 	movdqu %xmm0,0xe0(%rsp)
  686ca1:	00 00 
  686ca3:	0f 11 8c 24 f0 00 00 	movups %xmm1,0xf0(%rsp)
  686caa:	00 
  686cab:	0f 11 94 24 00 01 00 	movups %xmm2,0x100(%rsp)
  686cb2:	00 
  686cb3:	48 8b 44 08 50       	mov    0x50(%rax,%rcx,1),%rax
  686cb8:	48 89 84 24 10 01 00 	mov    %rax,0x110(%rsp)
  686cbf:	00 
  686cc0:	8b b4 24 e8 01 00 00 	mov    0x1e8(%rsp),%esi
  686cc7:	8b 94 24 ec 01 00 00 	mov    0x1ec(%rsp),%edx
  686cce:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
  686cd5:	00 
  686cd6:	ff 15 a4 26 10 00    	call   *0x1026a4(%rip)        # 789380 <_DYNAMIC+0x568>
  686cdc:	66 0f 6e 8c 24 90 00 	movd   0x90(%rsp),%xmm1
  686ce3:	00 00 
  686ce5:	48 8b 6c 24 60       	mov    0x60(%rsp),%rbp
  686cea:	48 39 c2             	cmp    %rax,%rdx
  686ced:	0f 82 32 01 00 00    	jb     686e25 <<parley::editing::geometry::CursorGeometry<()>>::new+0x765>
  686cf3:	48 3b 54 24 68       	cmp    0x68(%rsp),%rdx
  686cf8:	0f 87 27 01 00 00    	ja     686e25 <<parley::editing::geometry::CursorGeometry<()>>::new+0x765>
  686cfe:	48 89 d1             	mov    %rdx,%rcx
  686d01:	48 29 c1             	sub    %rax,%rcx
  686d04:	48 8d 34 85 00 00 00 	lea    0x0(,%rax,4),%rsi
  686d0b:	00 
  686d0c:	48 01 ee             	add    %rbp,%rsi
  686d0f:	4c 8d 04 85 00 00 00 	lea    0x0(,%rax,4),%r8
  686d16:	00 
  686d17:	48 8d 3c 95 00 00 00 	lea    0x0(,%rdx,4),%rdi
  686d1e:	00 
  686d1f:	90                   	nop
  686d20:	4c 39 c7             	cmp    %r8,%rdi
  686d23:	74 11                	je     686d36 <<parley::editing::geometry::CursorGeometry<()>>::new+0x676>
  686d25:	42 83 7c 05 00 ff    	cmpl   $0xffffffff,0x0(%rbp,%r8,1)
  686d2b:	4d 8d 40 04          	lea    0x4(%r8),%r8
  686d2f:	74 ef                	je     686d20 <<parley::editing::geometry::CursorGeometry<()>>::new+0x660>
  686d31:	e9 ef 00 00 00       	jmp    686e25 <<parley::editing::geometry::CursorGeometry<()>>::new+0x765>
  686d36:	4d 89 f0             	mov    %r14,%r8
  686d39:	49 c1 e8 20          	shr    $0x20,%r8
  686d3d:	0f 85 e2 00 00 00    	jne    686e25 <<parley::editing::geometry::CursorGeometry<()>>::new+0x765>
  686d43:	48 39 c2             	cmp    %rax,%rdx
  686d46:	0f 84 24 fd ff ff    	je     686a70 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3b0>
  686d4c:	48 c1 e0 02          	shl    $0x2,%rax
  686d50:	48 29 c7             	sub    %rax,%rdi
  686d53:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
  686d57:	48 89 f2             	mov    %rsi,%rdx
  686d5a:	48 83 ff 1c          	cmp    $0x1c,%rdi
  686d5e:	72 4f                	jb     686daf <<parley::editing::geometry::CursorGeometry<()>>::new+0x6ef>
  686d60:	48 c1 ef 02          	shr    $0x2,%rdi
  686d64:	48 ff c7             	inc    %rdi
  686d67:	49 89 f8             	mov    %rdi,%r8
  686d6a:	48 ba f8 ff ff ff ff 	movabs $0x7ffffffffffffff8,%rdx
  686d71:	ff ff 7f 
  686d74:	49 21 d0             	and    %rdx,%r8
  686d77:	4a 8d 14 86          	lea    (%rsi,%r8,4),%rdx
  686d7b:	66 41 0f 6e c6       	movd   %r14d,%xmm0
  686d80:	66 0f 70 c0 00       	pshufd $0x0,%xmm0,%xmm0
  686d85:	48 01 e8             	add    %rbp,%rax
  686d88:	48 83 c0 10          	add    $0x10,%rax
  686d8c:	45 31 c9             	xor    %r9d,%r9d
  686d8f:	90                   	nop
  686d90:	f3 42 0f 7f 44 88 f0 	movdqu %xmm0,-0x10(%rax,%r9,4)
  686d97:	f3 42 0f 7f 04 88    	movdqu %xmm0,(%rax,%r9,4)
  686d9d:	49 83 c1 08          	add    $0x8,%r9
  686da1:	4d 39 c8             	cmp    %r9,%r8
  686da4:	75 ea                	jne    686d90 <<parley::editing::geometry::CursorGeometry<()>>::new+0x6d0>
  686da6:	4c 39 c7             	cmp    %r8,%rdi
  686da9:	0f 84 c1 fc ff ff    	je     686a70 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3b0>
  686daf:	48 8d 04 8e          	lea    (%rsi,%rcx,4),%rax
  686db3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  686dba:	84 00 00 00 00 00 
  686dc0:	44 89 32             	mov    %r14d,(%rdx)
  686dc3:	48 83 c2 04          	add    $0x4,%rdx
  686dc7:	48 39 c2             	cmp    %rax,%rdx
  686dca:	75 f4                	jne    686dc0 <<parley::editing::geometry::CursorGeometry<()>>::new+0x700>
  686dcc:	e9 9f fc ff ff       	jmp    686a70 <<parley::editing::geometry::CursorGeometry<()>>::new+0x3b0>
  686dd1:	48 8d bc 24 20 01 00 	lea    0x120(%rsp),%rdi
  686dd8:	00 
  686dd9:	e8 b2 b4 ff ff       	call   682290 <<parley::layout::run::Run<()>>::advance>
  686dde:	48 8b 9c 24 c8 00 00 	mov    0xc8(%rsp),%rbx
  686de5:	00 
  686de6:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  686deb:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  686df0:	48 8b 94 24 c0 00 00 	mov    0xc0(%rsp),%rdx
  686df7:	00 
  686df8:	4c 8b 84 24 b8 00 00 	mov    0xb8(%rsp),%r8
  686dff:	00 
  686e00:	4c 8b 8c 24 b0 00 00 	mov    0xb0(%rsp),%r9
  686e07:	00 
  686e08:	4c 8b 94 24 a8 00 00 	mov    0xa8(%rsp),%r10
  686e0f:	00 
  686e10:	4c 8b 9c 24 a0 00 00 	mov    0xa0(%rsp),%r11
  686e17:	00 
  686e18:	4c 8b b4 24 d0 00 00 	mov    0xd0(%rsp),%r14
  686e1f:	00 
  686e20:	e9 77 fb ff ff       	jmp    68699c <<parley::editing::geometry::CursorGeometry<()>>::new+0x2dc>
  686e25:	48 8b bc 24 88 00 00 	mov    0x88(%rsp),%rdi
  686e2c:	00 
  686e2d:	48 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%rdi)
  686e34:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  686e39:	48 85 f6             	test   %rsi,%rsi
  686e3c:	74 1a                	je     686e58 <<parley::editing::geometry::CursorGeometry<()>>::new+0x798>
  686e3e:	48 89 fb             	mov    %rdi,%rbx
  686e41:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  686e46:	48 c1 e6 04          	shl    $0x4,%rsi
  686e4a:	ba 04 00 00 00       	mov    $0x4,%edx
  686e4f:	ff 15 fb 21 10 00    	call   *0x1021fb(%rip)        # 789050 <_DYNAMIC+0x238>
  686e55:	48 89 df             	mov    %rbx,%rdi
  686e58:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  686e5d:	48 85 f6             	test   %rsi,%rsi
  686e60:	0f 84 8f f8 ff ff    	je     6866f5 <<parley::editing::geometry::CursorGeometry<()>>::new+0x35>
  686e66:	48 c1 e6 02          	shl    $0x2,%rsi
  686e6a:	ba 04 00 00 00       	mov    $0x4,%edx
  686e6f:	48 89 fb             	mov    %rdi,%rbx
  686e72:	48 89 ef             	mov    %rbp,%rdi
  686e75:	ff 15 d5 21 10 00    	call   *0x1021d5(%rip)        # 789050 <_DYNAMIC+0x238>
  686e7b:	48 89 df             	mov    %rbx,%rdi
  686e7e:	e9 72 f8 ff ff       	jmp    6866f5 <<parley::editing::geometry::CursorGeometry<()>>::new+0x35>
  686e83:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  686e88:	4c 8b 84 24 88 00 00 	mov    0x88(%rsp),%r8
  686e8f:	00 
  686e90:	49 89 40 30          	mov    %rax,0x30(%r8)
  686e94:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  686e99:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  686e9e:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  686ea3:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  686ea8:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  686ead:	49 89 78 20          	mov    %rdi,0x20(%r8)
  686eb1:	48 8b 7c 24 68       	mov    0x68(%rsp),%rdi
  686eb6:	49 89 78 28          	mov    %rdi,0x28(%r8)
  686eba:	4c 89 c7             	mov    %r8,%rdi
  686ebd:	49 89 50 10          	mov    %rdx,0x10(%r8)
  686ec1:	49 89 70 18          	mov    %rsi,0x18(%r8)
  686ec5:	49 89 00             	mov    %rax,(%r8)
  686ec8:	49 89 48 08          	mov    %rcx,0x8(%r8)
  686ecc:	e9 24 f8 ff ff       	jmp    6866f5 <<parley::editing::geometry::CursorGeometry<()>>::new+0x35>
  686ed1:	48 8d 0d a0 85 0f 00 	lea    0xf85a0(%rip),%rcx        # 77f478 <anon.d4a86088305c8823b863e6abd2e38045.32.llvm.2509172480284221941>
  686ed8:	48 89 c6             	mov    %rax,%rsi
  686edb:	ff 15 8f 24 10 00    	call   *0x10248f(%rip)        # 789370 <_DYNAMIC+0x558>
  686ee1:	eb 79                	jmp    686f5c <<parley::editing::geometry::CursorGeometry<()>>::new+0x89c>
  686ee3:	48 8d 3d 76 74 bd ff 	lea    -0x428b8a(%rip),%rdi        # 25e360 <anon.d4a86088305c8823b863e6abd2e38045.0.llvm.2509172480284221941>
  686eea:	48 8d 15 c7 87 0f 00 	lea    0xf87c7(%rip),%rdx        # 77f6b8 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941>
  686ef1:	be 63 00 00 00       	mov    $0x63,%esi
  686ef6:	ff 15 fc 23 10 00    	call   *0x1023fc(%rip)        # 7892f8 <_DYNAMIC+0x4e0>
  686efc:	eb 5e                	jmp    686f5c <<parley::editing::geometry::CursorGeometry<()>>::new+0x89c>
  686efe:	bf 04 00 00 00       	mov    $0x4,%edi
  686f03:	4c 89 f6             	mov    %r14,%rsi
  686f06:	ff 15 5c 22 10 00    	call   *0x10225c(%rip)        # 789168 <_DYNAMIC+0x350>
  686f0c:	48 8d 05 fd 86 0f 00 	lea    0xf86fd(%rip),%rax        # 77f610 <anon.d4a86088305c8823b863e6abd2e38045.52.llvm.2509172480284221941>
  686f13:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  686f18:	48 8b 54 24 78       	mov    0x78(%rsp),%rdx
  686f1d:	ff 15 55 22 10 00    	call   *0x102255(%rip)        # 789178 <_DYNAMIC+0x360>
  686f23:	eb 37                	jmp    686f5c <<parley::editing::geometry::CursorGeometry<()>>::new+0x89c>
  686f25:	4c 89 54 24 18       	mov    %r10,0x18(%rsp)
  686f2a:	48 8d 05 5f 88 0f 00 	lea    0xf885f(%rip),%rax        # 77f790 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941+0xd8>
  686f31:	eb 14                	jmp    686f47 <<parley::editing::geometry::CursorGeometry<()>>::new+0x887>
  686f33:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  686f3a:	00 
  686f3b:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  686f40:	48 8d 05 61 88 0f 00 	lea    0xf8861(%rip),%rax        # 77f7a8 <anon.d4a86088305c8823b863e6abd2e38045.61.llvm.2509172480284221941+0xf0>
  686f47:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  686f4c:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  686f51:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  686f56:	ff 15 1c 22 10 00    	call   *0x10221c(%rip)        # 789178 <_DYNAMIC+0x360>
  686f5c:	0f 0b                	ud2
  686f5e:	eb 06                	jmp    686f66 <<parley::editing::geometry::CursorGeometry<()>>::new+0x8a6>
  686f60:	eb 04                	jmp    686f66 <<parley::editing::geometry::CursorGeometry<()>>::new+0x8a6>
  686f62:	eb 02                	jmp    686f66 <<parley::editing::geometry::CursorGeometry<()>>::new+0x8a6>
  686f64:	eb 00                	jmp    686f66 <<parley::editing::geometry::CursorGeometry<()>>::new+0x8a6>
  686f66:	48 89 c3             	mov    %rax,%rbx
  686f69:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  686f6e:	e8 9d ef ff ff       	call   685f10 <core::ptr::drop_glue::<parley::editing::geometry::CursorGeometry<()>>>
  686f73:	48 89 df             	mov    %rbx,%rdi
  686f76:	e8 f5 5f 0f 00       	call   77cf70 <_Unwind_Resume@plt>
  686f7b:	48 89 c3             	mov    %rax,%rbx
  686f7e:	4d 85 ff             	test   %r15,%r15
  686f81:	74 13                	je     686f96 <<parley::editing::geometry::CursorGeometry<()>>::new+0x8d6>
  686f83:	ba 04 00 00 00       	mov    $0x4,%edx
  686f88:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  686f8d:	4c 89 f6             	mov    %r14,%rsi
  686f90:	ff 15 ba 20 10 00    	call   *0x1020ba(%rip)        # 789050 <_DYNAMIC+0x238>
  686f96:	48 89 df             	mov    %rbx,%rdi
  686f99:	e8 d2 5f 0f 00       	call   77cf70 <_Unwind_Resume@plt>
