
/tmp/gpui-caret-transaction-bin/matched-partial-caret_pair_measure:     file format elf64-x86-64


Disassembly of section .text:

0000000000683600 <<parley::layout::run::Clusters<()>>::advance_cursor>:
  683600:	55                   	push   %rbp
  683601:	41 57                	push   %r15
  683603:	41 56                	push   %r14
  683605:	41 55                	push   %r13
  683607:	41 54                	push   %r12
  683609:	53                   	push   %rbx
  68360a:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  683611:	49 89 f6             	mov    %rsi,%r14
  683614:	49 89 fd             	mov    %rdi,%r13
  683617:	80 be 08 01 00 00 00 	cmpb   $0x0,0x108(%rsi)
  68361e:	0f 84 b4 01 00 00    	je     6837d8 <<parley::layout::run::Clusters<()>>::advance_cursor+0x1d8>
  683624:	45 8b 8e a0 00 00 00 	mov    0xa0(%r14),%r9d
  68362b:	45 8b 96 a4 00 00 00 	mov    0xa4(%r14),%r10d
  683632:	31 c0                	xor    %eax,%eax
  683634:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  68363a:	45 39 d1             	cmp    %r10d,%r9d
  68363d:	74 2c                	je     68366b <<parley::layout::run::Clusters<()>>::advance_cursor+0x6b>
  68363f:	49 8b b6 88 00 00 00 	mov    0x88(%r14),%rsi
  683646:	4c 39 ce             	cmp    %r9,%rsi
  683649:	0f 86 39 05 00 00    	jbe    683b88 <<parley::layout::run::Clusters<()>>::advance_cursor+0x588>
  68364f:	49 8d 7a ff          	lea    -0x1(%r10),%rdi
  683653:	48 39 f7             	cmp    %rsi,%rdi
  683656:	0f 83 3c 05 00 00    	jae    683b98 <<parley::layout::run::Clusters<()>>::advance_cursor+0x598>
  68365c:	49 8b 8e 80 00 00 00 	mov    0x80(%r14),%rcx
  683663:	4b 8d 14 49          	lea    (%r9,%r9,2),%rdx
  683667:	44 8b 1c d1          	mov    (%rcx,%rdx,8),%r11d
  68366b:	41 8b 8e a8 00 00 00 	mov    0xa8(%r14),%ecx
  683672:	44 39 d9             	cmp    %r11d,%ecx
  683675:	0f 84 bb 04 00 00    	je     683b36 <<parley::layout::run::Clusters<()>>::advance_cursor+0x536>
  68367b:	45 8b a6 ac 00 00 00 	mov    0xac(%r14),%r12d
  683682:	49 8b b6 88 00 00 00 	mov    0x88(%r14),%rsi
  683689:	4c 39 e6             	cmp    %r12,%rsi
  68368c:	0f 86 13 05 00 00    	jbe    683ba5 <<parley::layout::run::Clusters<()>>::advance_cursor+0x5a5>
  683692:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
  683699:	00 
  68369a:	44 8d 79 ff          	lea    -0x1(%rcx),%r15d
  68369e:	49 8b 96 80 00 00 00 	mov    0x80(%r14),%rdx
  6836a5:	4b 8d 04 64          	lea    (%r12,%r12,2),%rax
  6836a9:	44 3b 3c c2          	cmp    (%rdx,%rax,8),%r15d
  6836ad:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  6836b2:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  6836b7:	73 7d                	jae    683736 <<parley::layout::run::Clusters<()>>::advance_cursor+0x136>
  6836b9:	41 ff cc             	dec    %r12d
  6836bc:	45 89 a6 ac 00 00 00 	mov    %r12d,0xac(%r14)
  6836c3:	0f 57 c0             	xorps  %xmm0,%xmm0
  6836c6:	45 39 d1             	cmp    %r10d,%r9d
  6836c9:	74 62                	je     68372d <<parley::layout::run::Clusters<()>>::advance_cursor+0x12d>
  6836cb:	4c 89 54 24 18       	mov    %r10,0x18(%rsp)
  6836d0:	4c 39 e6             	cmp    %r12,%rsi
  6836d3:	0f 86 00 02 00 00    	jbe    6838d9 <<parley::layout::run::Clusters<()>>::advance_cursor+0x2d9>
  6836d9:	4c 89 cd             	mov    %r9,%rbp
  6836dc:	44 89 db             	mov    %r11d,%ebx
  6836df:	4b 8d 04 64          	lea    (%r12,%r12,2),%rax
  6836e3:	48 8d 3c c2          	lea    (%rdx,%rax,8),%rdi
  6836e7:	f3 0f 10 44 c2 10    	movss  0x10(%rdx,%rax,8),%xmm0
  6836ed:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  6836f3:	49 8b 76 70          	mov    0x70(%r14),%rsi
  6836f7:	49 8b 56 78          	mov    0x78(%r14),%rdx
  6836fb:	ff 15 27 60 10 00    	call   *0x106027(%rip)        # 789728 <_DYNAMIC+0x910>
  683701:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  683706:	89 c0                	mov    %eax,%eax
  683708:	0f 57 c0             	xorps  %xmm0,%xmm0
  68370b:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
  683710:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  683716:	f3 0f 5e c8          	divss  %xmm0,%xmm1
  68371a:	0f 28 c1             	movaps %xmm1,%xmm0
  68371d:	41 89 db             	mov    %ebx,%r11d
  683720:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  683725:	49 89 e9             	mov    %rbp,%r9
  683728:	4c 8b 54 24 18       	mov    0x18(%rsp),%r10
  68372d:	f3 41 0f 11 86 b0 00 	movss  %xmm0,0xb0(%r14)
  683734:	00 00 
  683736:	4c 39 e6             	cmp    %r12,%rsi
  683739:	0f 86 76 04 00 00    	jbe    683bb5 <<parley::layout::run::Clusters<()>>::advance_cursor+0x5b5>
  68373f:	4b 8d 04 64          	lea    (%r12,%r12,2),%rax
  683743:	44 8b 44 c2 04       	mov    0x4(%rdx,%rax,8),%r8d
  683748:	f3 41 0f 10 a6 b0 00 	movss  0xb0(%r14),%xmm4
  68374f:	00 00 
  683751:	45 39 df             	cmp    %r11d,%r15d
  683754:	0f 86 a5 01 00 00    	jbe    6838ff <<parley::layout::run::Clusters<()>>::advance_cursor+0x2ff>
  68375a:	44 89 44 24 08       	mov    %r8d,0x8(%rsp)
  68375f:	4c 89 6c 24 20       	mov    %r13,0x20(%rsp)
  683764:	49 8b 6e 70          	mov    0x70(%r14),%rbp
  683768:	4d 8b 6e 78          	mov    0x78(%r14),%r13
  68376c:	45 39 d1             	cmp    %r10d,%r9d
  68376f:	0f 85 1b 01 00 00    	jne    683890 <<parley::layout::run::Clusters<()>>::advance_cursor+0x290>
  683775:	0f 57 c0             	xorps  %xmm0,%xmm0
  683778:	eb 0f                	jmp    683789 <<parley::layout::run::Clusters<()>>::advance_cursor+0x189>
  68377a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  683780:	45 39 df             	cmp    %r11d,%r15d
  683783:	0f 86 a0 01 00 00    	jbe    683929 <<parley::layout::run::Clusters<()>>::advance_cursor+0x329>
  683789:	44 89 ff             	mov    %r15d,%edi
  68378c:	49 39 fd             	cmp    %rdi,%r13
  68378f:	0f 86 b7 03 00 00    	jbe    683b4c <<parley::layout::run::Clusters<()>>::advance_cursor+0x54c>
  683795:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  683799:	80 7c 85 08 00       	cmpb   $0x0,0x8(%rbp,%rax,4)
  68379e:	0f 85 51 01 00 00    	jne    6838f5 <<parley::layout::run::Clusters<()>>::advance_cursor+0x2f5>
  6837a4:	44 89 e7             	mov    %r12d,%edi
  6837a7:	48 39 fe             	cmp    %rdi,%rsi
  6837aa:	0f 86 ac 03 00 00    	jbe    683b5c <<parley::layout::run::Clusters<()>>::advance_cursor+0x55c>
  6837b0:	41 ff cf             	dec    %r15d
  6837b3:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  6837b7:	44 3b 3c c2          	cmp    (%rdx,%rax,8),%r15d
  6837bb:	73 c3                	jae    683780 <<parley::layout::run::Clusters<()>>::advance_cursor+0x180>
  6837bd:	41 ff cc             	dec    %r12d
  6837c0:	45 89 a6 ac 00 00 00 	mov    %r12d,0xac(%r14)
  6837c7:	41 c7 86 b0 00 00 00 	movl   $0x0,0xb0(%r14)
  6837ce:	00 00 00 00 
  6837d2:	f3 0f 58 e0          	addss  %xmm0,%xmm4
  6837d6:	eb a8                	jmp    683780 <<parley::layout::run::Clusters<()>>::advance_cursor+0x180>
  6837d8:	49 8d 76 70          	lea    0x70(%r14),%rsi
  6837dc:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6837e1:	ff 15 49 5f 10 00    	call   *0x105f49(%rip)        # 789730 <_DYNAMIC+0x918>
  6837e7:	80 7c 24 30 00       	cmpb   $0x0,0x30(%rsp)
  6837ec:	0f 84 fc 00 00 00    	je     6838ee <<parley::layout::run::Clusters<()>>::advance_cursor+0x2ee>
  6837f2:	44 8b 5c 24 34       	mov    0x34(%rsp),%r11d
  6837f7:	44 8b 7c 24 38       	mov    0x38(%rsp),%r15d
  6837fc:	f3 0f 10 64 24 3c    	movss  0x3c(%rsp),%xmm4
  683802:	0f b7 5c 24 40       	movzwl 0x40(%rsp),%ebx
  683807:	0f b7 6c 24 42       	movzwl 0x42(%rsp),%ebp
  68380c:	41 0f b6 86 08 01 00 	movzbl 0x108(%r14),%eax
  683813:	00 
  683814:	8d 48 04             	lea    0x4(%rax),%ecx
  683817:	0f b6 c9             	movzbl %cl,%ecx
  68381a:	0f a3 cb             	bt     %ecx,%ebx
  68381d:	0f 82 71 01 00 00    	jb     683994 <<parley::layout::run::Clusters<()>>::advance_cursor+0x394>
  683823:	e9 f1 02 00 00       	jmp    683b19 <<parley::layout::run::Clusters<()>>::advance_cursor+0x519>
  683828:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  68382f:	00 
  683830:	44 89 db             	mov    %r11d,%ebx
  683833:	4b 8d 04 64          	lea    (%r12,%r12,2),%rax
  683837:	48 8d 3c c2          	lea    (%rdx,%rax,8),%rdi
  68383b:	f3 0f 10 44 c2 10    	movss  0x10(%rdx,%rax,8),%xmm0
  683841:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  683847:	48 89 ee             	mov    %rbp,%rsi
  68384a:	4c 89 ea             	mov    %r13,%rdx
  68384d:	ff 15 d5 5e 10 00    	call   *0x105ed5(%rip)        # 789728 <_DYNAMIC+0x910>
  683853:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  683858:	89 c0                	mov    %eax,%eax
  68385a:	0f 57 c0             	xorps  %xmm0,%xmm0
  68385d:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
  683862:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
  683868:	f3 0f 5e c8          	divss  %xmm0,%xmm1
  68386c:	f3 41 0f 11 8e b0 00 	movss  %xmm1,0xb0(%r14)
  683873:	00 00 
  683875:	f3 0f 10 64 24 18    	movss  0x18(%rsp),%xmm4
  68387b:	f3 0f 58 e1          	addss  %xmm1,%xmm4
  68387f:	41 89 db             	mov    %ebx,%r11d
  683882:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  683887:	45 39 df             	cmp    %r11d,%r15d
  68388a:	0f 86 99 00 00 00    	jbe    683929 <<parley::layout::run::Clusters<()>>::advance_cursor+0x329>
  683890:	44 89 ff             	mov    %r15d,%edi
  683893:	49 39 fd             	cmp    %rdi,%r13
  683896:	0f 86 b0 02 00 00    	jbe    683b4c <<parley::layout::run::Clusters<()>>::advance_cursor+0x54c>
  68389c:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  6838a0:	80 7c 85 08 00       	cmpb   $0x0,0x8(%rbp,%rax,4)
  6838a5:	75 4e                	jne    6838f5 <<parley::layout::run::Clusters<()>>::advance_cursor+0x2f5>
  6838a7:	44 89 e7             	mov    %r12d,%edi
  6838aa:	48 39 fe             	cmp    %rdi,%rsi
  6838ad:	0f 86 a9 02 00 00    	jbe    683b5c <<parley::layout::run::Clusters<()>>::advance_cursor+0x55c>
  6838b3:	41 ff cf             	dec    %r15d
  6838b6:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  6838ba:	44 3b 3c c2          	cmp    (%rdx,%rax,8),%r15d
  6838be:	73 c7                	jae    683887 <<parley::layout::run::Clusters<()>>::advance_cursor+0x287>
  6838c0:	f3 0f 11 64 24 18    	movss  %xmm4,0x18(%rsp)
  6838c6:	41 ff cc             	dec    %r12d
  6838c9:	45 89 a6 ac 00 00 00 	mov    %r12d,0xac(%r14)
  6838d0:	4c 39 e6             	cmp    %r12,%rsi
  6838d3:	0f 87 57 ff ff ff    	ja     683830 <<parley::layout::run::Clusters<()>>::advance_cursor+0x230>
  6838d9:	48 8d 15 68 bb 0f 00 	lea    0xfbb68(%rip),%rdx        # 77f448 <anon.d4a86088305c8823b863e6abd2e38045.3.llvm.2509172480284221941+0x168>
  6838e0:	4c 89 e7             	mov    %r12,%rdi
  6838e3:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  6838e8:	ff 15 8a 58 10 00    	call   *0x10588a(%rip)        # 789178 <_DYNAMIC+0x360>
  6838ee:	31 c0                	xor    %eax,%eax
  6838f0:	e9 41 02 00 00       	jmp    683b36 <<parley::layout::run::Clusters<()>>::advance_cursor+0x536>
  6838f5:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
  6838fa:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  6838ff:	66 b8 10 00          	mov    $0x10,%ax
  683903:	45 39 df             	cmp    %r11d,%r15d
  683906:	74 2f                	je     683937 <<parley::layout::run::Clusters<()>>::advance_cursor+0x337>
  683908:	44 89 e7             	mov    %r12d,%edi
  68390b:	48 39 fe             	cmp    %rdi,%rsi
  68390e:	0f 86 be 02 00 00    	jbe    683bd2 <<parley::layout::run::Clusters<()>>::advance_cursor+0x5d2>
  683914:	48 8d 0c 7f          	lea    (%rdi,%rdi,2),%rcx
  683918:	31 c0                	xor    %eax,%eax
  68391a:	44 3b 3c ca          	cmp    (%rdx,%rcx,8),%r15d
  68391e:	0f 94 c0             	sete   %al
  683921:	c1 e0 04             	shl    $0x4,%eax
  683924:	45 89 fb             	mov    %r15d,%r11d
  683927:	eb 0e                	jmp    683937 <<parley::layout::run::Clusters<()>>::advance_cursor+0x337>
  683929:	66 b8 10 00          	mov    $0x10,%ax
  68392d:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
  683932:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  683937:	44 89 df             	mov    %r11d,%edi
  68393a:	49 8b 76 78          	mov    0x78(%r14),%rsi
  68393e:	48 39 fe             	cmp    %rdi,%rsi
  683941:	4c 8b bc 24 80 00 00 	mov    0x80(%rsp),%r15
  683948:	00 
  683949:	0f 86 76 02 00 00    	jbe    683bc5 <<parley::layout::run::Clusters<()>>::advance_cursor+0x5c5>
  68394f:	31 c9                	xor    %ecx,%ecx
  683951:	45 39 c7             	cmp    %r8d,%r15d
  683954:	0f 94 c1             	sete   %cl
  683957:	49 8b 56 70          	mov    0x70(%r14),%rdx
  68395b:	48 8d 34 7f          	lea    (%rdi,%rdi,2),%rsi
  68395f:	0f b6 7c b2 07       	movzbl 0x7(%rdx,%rsi,4),%edi
  683964:	0f b6 54 b2 06       	movzbl 0x6(%rdx,%rsi,4),%edx
  683969:	45 89 9e a8 00 00 00 	mov    %r11d,0xa8(%r14)
  683970:	c1 ea 04             	shr    $0x4,%edx
  683973:	83 e2 01             	and    $0x1,%edx
  683976:	8d 14 7a             	lea    (%rdx,%rdi,2),%edx
  683979:	c1 e1 05             	shl    $0x5,%ecx
  68397c:	0f b7 d8             	movzwl %ax,%ebx
  68397f:	09 cb                	or     %ecx,%ebx
  683981:	09 d3                	or     %edx,%ebx
  683983:	b0 01                	mov    $0x1,%al
  683985:	8d 48 04             	lea    0x4(%rax),%ecx
  683988:	0f b6 c9             	movzbl %cl,%ecx
  68398b:	0f a3 cb             	bt     %ecx,%ebx
  68398e:	0f 83 85 01 00 00    	jae    683b19 <<parley::layout::run::Clusters<()>>::advance_cursor+0x519>
  683994:	49 8d 76 30          	lea    0x30(%r14),%rsi
  683998:	84 c0                	test   %al,%al
  68399a:	74 21                	je     6839bd <<parley::layout::run::Clusters<()>>::advance_cursor+0x3bd>
  68399c:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6839a1:	45 89 dc             	mov    %r11d,%r12d
  6839a4:	f3 0f 11 64 24 18    	movss  %xmm4,0x18(%rsp)
  6839aa:	e8 21 f8 ff ff       	call   6831d0 <<parley_engine::shape::atom::Atoms>::prev>
  6839af:	f3 0f 10 64 24 18    	movss  0x18(%rsp),%xmm4
  6839b5:	45 89 e3             	mov    %r12d,%r11d
  6839b8:	e9 e6 00 00 00       	jmp    683aa3 <<parley::layout::run::Clusters<()>>::advance_cursor+0x4a3>
  6839bd:	45 8b 56 64          	mov    0x64(%r14),%r10d
  6839c1:	41 8b 7e 68          	mov    0x68(%r14),%edi
  6839c5:	44 39 d7             	cmp    %r10d,%edi
  6839c8:	75 0e                	jne    6839d8 <<parley::layout::run::Clusters<()>>::advance_cursor+0x3d8>
  6839ca:	48 c7 44 24 30 00 00 	movq   $0x0,0x30(%rsp)
  6839d1:	00 00 
  6839d3:	e9 cb 00 00 00       	jmp    683aa3 <<parley::layout::run::Clusters<()>>::advance_cursor+0x4a3>
  6839d8:	49 8b 46 48          	mov    0x48(%r14),%rax
  6839dc:	48 39 f8             	cmp    %rdi,%rax
  6839df:	0f 86 fa 01 00 00    	jbe    683bdf <<parley::layout::run::Clusters<()>>::advance_cursor+0x5df>
  6839e5:	49 8b 56 40          	mov    0x40(%r14),%rdx
  6839e9:	4c 8d 0c 7f          	lea    (%rdi,%rdi,2),%r9
  6839ed:	f3 42 0f 10 44 ca 10 	movss  0x10(%rdx,%r9,8),%xmm0
  6839f4:	44 8d 47 01          	lea    0x1(%rdi),%r8d
  6839f8:	45 39 d0             	cmp    %r10d,%r8d
  6839fb:	73 4b                	jae    683a48 <<parley::layout::run::Clusters<()>>::advance_cursor+0x448>
  6839fd:	45 89 dc             	mov    %r11d,%r12d
  683a00:	44 89 c1             	mov    %r8d,%ecx
  683a03:	4c 8d 04 49          	lea    (%rcx,%rcx,2),%r8
  683a07:	4e 8d 1c c2          	lea    (%rdx,%r8,8),%r11
  683a0b:	49 83 c3 16          	add    $0x16,%r11
  683a0f:	49 89 c8             	mov    %rcx,%r8
  683a12:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  683a19:	1f 84 00 00 00 00 00 
  683a20:	4c 39 c0             	cmp    %r8,%rax
  683a23:	0f 86 45 01 00 00    	jbe    683b6e <<parley::layout::run::Clusters<()>>::advance_cursor+0x56e>
  683a29:	41 f6 43 01 02       	testb  $0x2,0x1(%r11)
  683a2e:	75 15                	jne    683a45 <<parley::layout::run::Clusters<()>>::advance_cursor+0x445>
  683a30:	f3 41 0f 58 43 fa    	addss  -0x6(%r11),%xmm0
  683a36:	49 ff c0             	inc    %r8
  683a39:	49 83 c3 18          	add    $0x18,%r11
  683a3d:	4d 39 c2             	cmp    %r8,%r10
  683a40:	75 de                	jne    683a20 <<parley::layout::run::Clusters<()>>::advance_cursor+0x420>
  683a42:	45 89 d0             	mov    %r10d,%r8d
  683a45:	45 89 e3             	mov    %r12d,%r11d
  683a48:	45 89 46 68          	mov    %r8d,0x68(%r14)
  683a4c:	44 89 c1             	mov    %r8d,%ecx
  683a4f:	48 ff c9             	dec    %rcx
  683a52:	48 39 c1             	cmp    %rax,%rcx
  683a55:	0f 83 94 01 00 00    	jae    683bef <<parley::layout::run::Clusters<()>>::advance_cursor+0x5ef>
  683a5b:	4a 8d 04 ca          	lea    (%rdx,%r9,8),%rax
  683a5f:	8b 00                	mov    (%rax),%eax
  683a61:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  683a65:	8b 4c ca 04          	mov    0x4(%rdx,%rcx,8),%ecx
  683a69:	48 8b 56 30          	mov    0x30(%rsi),%rdx
  683a6d:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  683a72:	0f 10 0e             	movups (%rsi),%xmm1
  683a75:	0f 10 56 10          	movups 0x10(%rsi),%xmm2
  683a79:	0f 10 5e 20          	movups 0x20(%rsi),%xmm3
  683a7d:	0f 29 5c 24 50       	movaps %xmm3,0x50(%rsp)
  683a82:	0f 29 54 24 40       	movaps %xmm2,0x40(%rsp)
  683a87:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  683a8c:	89 7c 24 68          	mov    %edi,0x68(%rsp)
  683a90:	44 89 44 24 6c       	mov    %r8d,0x6c(%rsp)
  683a95:	89 44 24 70          	mov    %eax,0x70(%rsp)
  683a99:	89 4c 24 74          	mov    %ecx,0x74(%rsp)
  683a9d:	f3 0f 11 44 24 78    	movss  %xmm0,0x78(%rsp)
  683aa3:	8b 44 24 70          	mov    0x70(%rsp),%eax
  683aa7:	41 89 86 f8 00 00 00 	mov    %eax,0xf8(%r14)
  683aae:	8b 44 24 74          	mov    0x74(%rsp),%eax
  683ab2:	41 89 86 fc 00 00 00 	mov    %eax,0xfc(%r14)
  683ab9:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  683abe:	49 89 86 00 01 00 00 	mov    %rax,0x100(%r14)
  683ac5:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  683aca:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  683acf:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  683ad4:	0f 28 4c 24 50       	movaps 0x50(%rsp),%xmm1
  683ad9:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  683ade:	49 89 96 e8 00 00 00 	mov    %rdx,0xe8(%r14)
  683ae5:	8b 54 24 68          	mov    0x68(%rsp),%edx
  683ae9:	41 89 96 f0 00 00 00 	mov    %edx,0xf0(%r14)
  683af0:	8b 54 24 6c          	mov    0x6c(%rsp),%edx
  683af4:	41 89 96 f4 00 00 00 	mov    %edx,0xf4(%r14)
  683afb:	41 0f 11 8e d8 00 00 	movups %xmm1,0xd8(%r14)
  683b02:	00 
  683b03:	41 0f 11 86 c8 00 00 	movups %xmm0,0xc8(%r14)
  683b0a:	00 
  683b0b:	49 89 86 b8 00 00 00 	mov    %rax,0xb8(%r14)
  683b12:	49 89 8e c0 00 00 00 	mov    %rcx,0xc0(%r14)
  683b19:	45 89 5d 04          	mov    %r11d,0x4(%r13)
  683b1d:	45 89 7d 08          	mov    %r15d,0x8(%r13)
  683b21:	f3 41 0f 11 65 0c    	movss  %xmm4,0xc(%r13)
  683b27:	66 41 89 5d 10       	mov    %bx,0x10(%r13)
  683b2c:	66 41 89 6d 12       	mov    %bp,0x12(%r13)
  683b31:	b8 01 00 00 00       	mov    $0x1,%eax
  683b36:	41 89 45 00          	mov    %eax,0x0(%r13)
  683b3a:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  683b41:	5b                   	pop    %rbx
  683b42:	41 5c                	pop    %r12
  683b44:	41 5d                	pop    %r13
  683b46:	41 5e                	pop    %r14
  683b48:	41 5f                	pop    %r15
  683b4a:	5d                   	pop    %rbp
  683b4b:	c3                   	ret
  683b4c:	48 8d 15 5d ba 0f 00 	lea    0xfba5d(%rip),%rdx        # 77f5b0 <anon.d4a86088305c8823b863e6abd2e38045.37.llvm.2509172480284221941+0xd8>
  683b53:	4c 89 ee             	mov    %r13,%rsi
  683b56:	ff 15 1c 56 10 00    	call   *0x10561c(%rip)        # 789178 <_DYNAMIC+0x360>
  683b5c:	48 8d 15 65 ba 0f 00 	lea    0xfba65(%rip),%rdx        # 77f5c8 <anon.d4a86088305c8823b863e6abd2e38045.37.llvm.2509172480284221941+0xf0>
  683b63:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  683b68:	ff 15 0a 56 10 00    	call   *0x10560a(%rip)        # 789178 <_DYNAMIC+0x360>
  683b6e:	48 39 c8             	cmp    %rcx,%rax
  683b71:	48 0f 47 c8          	cmova  %rax,%rcx
  683b75:	48 8d 15 dc ba 0f 00 	lea    0xfbadc(%rip),%rdx        # 77f658 <anon.d4a86088305c8823b863e6abd2e38045.54.llvm.2509172480284221941+0x30>
  683b7c:	48 89 cf             	mov    %rcx,%rdi
  683b7f:	48 89 c6             	mov    %rax,%rsi
  683b82:	ff 15 f0 55 10 00    	call   *0x1055f0(%rip)        # 789178 <_DYNAMIC+0x360>
  683b88:	48 8d 15 e1 b7 0f 00 	lea    0xfb7e1(%rip),%rdx        # 77f370 <anon.d4a86088305c8823b863e6abd2e38045.3.llvm.2509172480284221941+0x90>
  683b8f:	4c 89 cf             	mov    %r9,%rdi
  683b92:	ff 15 e0 55 10 00    	call   *0x1055e0(%rip)        # 789178 <_DYNAMIC+0x360>
  683b98:	48 8d 15 e9 b7 0f 00 	lea    0xfb7e9(%rip),%rdx        # 77f388 <anon.d4a86088305c8823b863e6abd2e38045.3.llvm.2509172480284221941+0xa8>
  683b9f:	ff 15 d3 55 10 00    	call   *0x1055d3(%rip)        # 789178 <_DYNAMIC+0x360>
  683ba5:	48 8d 15 d4 b9 0f 00 	lea    0xfb9d4(%rip),%rdx        # 77f580 <anon.d4a86088305c8823b863e6abd2e38045.37.llvm.2509172480284221941+0xa8>
  683bac:	4c 89 e7             	mov    %r12,%rdi
  683baf:	ff 15 c3 55 10 00    	call   *0x1055c3(%rip)        # 789178 <_DYNAMIC+0x360>
  683bb5:	48 8d 15 dc b9 0f 00 	lea    0xfb9dc(%rip),%rdx        # 77f598 <anon.d4a86088305c8823b863e6abd2e38045.37.llvm.2509172480284221941+0xc0>
  683bbc:	4c 89 e7             	mov    %r12,%rdi
  683bbf:	ff 15 b3 55 10 00    	call   *0x1055b3(%rip)        # 789178 <_DYNAMIC+0x360>
  683bc5:	48 8d 15 2c ba 0f 00 	lea    0xfba2c(%rip),%rdx        # 77f5f8 <anon.d4a86088305c8823b863e6abd2e38045.37.llvm.2509172480284221941+0x120>
  683bcc:	ff 15 a6 55 10 00    	call   *0x1055a6(%rip)        # 789178 <_DYNAMIC+0x360>
  683bd2:	48 8d 15 07 ba 0f 00 	lea    0xfba07(%rip),%rdx        # 77f5e0 <anon.d4a86088305c8823b863e6abd2e38045.37.llvm.2509172480284221941+0x108>
  683bd9:	ff 15 99 55 10 00    	call   *0x105599(%rip)        # 789178 <_DYNAMIC+0x360>
  683bdf:	48 8d 15 5a ba 0f 00 	lea    0xfba5a(%rip),%rdx        # 77f640 <anon.d4a86088305c8823b863e6abd2e38045.54.llvm.2509172480284221941+0x18>
  683be6:	48 89 c6             	mov    %rax,%rsi
  683be9:	ff 15 89 55 10 00    	call   *0x105589(%rip)        # 789178 <_DYNAMIC+0x360>
  683bef:	48 8d 15 7a ba 0f 00 	lea    0xfba7a(%rip),%rdx        # 77f670 <anon.d4a86088305c8823b863e6abd2e38045.54.llvm.2509172480284221941+0x48>
  683bf6:	48 89 cf             	mov    %rcx,%rdi
  683bf9:	48 89 c6             	mov    %rax,%rsi
  683bfc:	ff 15 76 55 10 00    	call   *0x105576(%rip)        # 789178 <_DYNAMIC+0x360>
