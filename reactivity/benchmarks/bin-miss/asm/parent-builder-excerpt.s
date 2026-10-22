
/tmp/gpui-bin-phase-parent-target/release/deps/bin_phase-d773cf8873bbe22b:     file format elf64-x86-64


Disassembly of section .text:

00000000000804a0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>>:
   804a0:	55                   	push   %rbp
   804a1:	41 57                	push   %r15
   804a3:	41 56                	push   %r14
   804a5:	41 55                	push   %r13
   804a7:	41 54                	push   %r12
   804a9:	53                   	push   %rbx
   804aa:	49 89 e3             	mov    %rsp,%r11
   804ad:	49 81 eb 00 10 01 00 	sub    $0x11000,%r11
   804b4:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
   804bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
   804c2:	00 
   804c3:	4c 39 dc             	cmp    %r11,%rsp
   804c6:	75 ec                	jne    804b4 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x14>
   804c8:	48 81 ec f8 0d 00 00 	sub    $0xdf8,%rsp
   804cf:	48 89 94 24 50 02 00 	mov    %rdx,0x250(%rsp)
   804d6:	00 
   804d7:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
   804dc:	48 89 fb             	mov    %rdi,%rbx
   804df:	f6 c1 01             	test   $0x1,%cl
   804e2:	74 2b                	je     8050f <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x6f>
   804e4:	4c 89 c1             	mov    %r8,%rcx
   804e7:	48 c1 e9 20          	shr    $0x20,%rcx
   804eb:	66 41 39 c8          	cmp    %cx,%r8w
   804ef:	74 13                	je     80504 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x64>
   804f1:	4c 89 c2             	mov    %r8,%rdx
   804f4:	48 c1 ea 10          	shr    $0x10,%rdx
   804f8:	4c 89 c0             	mov    %r8,%rax
   804fb:	48 c1 e8 30          	shr    $0x30,%rax
   804ff:	66 39 c2             	cmp    %ax,%dx
   80502:	75 26                	jne    8052a <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x8a>
   80504:	45 31 ff             	xor    %r15d,%r15d
   80507:	31 ff                	xor    %edi,%edi
   80509:	31 c9                	xor    %ecx,%ecx
   8050b:	31 c0                	xor    %eax,%eax
   8050d:	eb 25                	jmp    80534 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x94>
   8050f:	48 8b b3 f0 01 00 00 	mov    0x1f0(%rbx),%rsi
   80516:	48 8b 93 f8 01 00 00 	mov    0x1f8(%rbx),%rdx
   8051d:	31 ff                	xor    %edi,%edi
   8051f:	48 89 d0             	mov    %rdx,%rax
   80522:	48 89 f1             	mov    %rsi,%rcx
   80525:	45 31 ff             	xor    %r15d,%r15d
   80528:	eb 2d                	jmp    80557 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xb7>
   8052a:	45 0f b7 f8          	movzwl %r8w,%r15d
   8052e:	0f b7 c9             	movzwl %cx,%ecx
   80531:	0f b7 fa             	movzwl %dx,%edi
   80534:	48 8b b3 f0 01 00 00 	mov    0x1f0(%rbx),%rsi
   8053b:	48 8b 93 f8 01 00 00 	mov    0x1f8(%rbx),%rdx
   80542:	4c 39 fe             	cmp    %r15,%rsi
   80545:	4c 0f 42 fe          	cmovb  %rsi,%r15
   80549:	41 c1 ef 04          	shr    $0x4,%r15d
   8054d:	48 39 fa             	cmp    %rdi,%rdx
   80550:	48 0f 42 fa          	cmovb  %rdx,%rdi
   80554:	c1 ef 04             	shr    $0x4,%edi
   80557:	89 c9                	mov    %ecx,%ecx
   80559:	48 39 ce             	cmp    %rcx,%rsi
   8055c:	48 0f 42 ce          	cmovb  %rsi,%rcx
   80560:	48 83 c1 0f          	add    $0xf,%rcx
   80564:	48 c1 e9 04          	shr    $0x4,%rcx
   80568:	41 89 c5             	mov    %eax,%r13d
   8056b:	4c 39 ea             	cmp    %r13,%rdx
   8056e:	4c 0f 42 ea          	cmovb  %rdx,%r13
   80572:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
   80577:	41 39 cf             	cmp    %ecx,%r15d
   8057a:	74 56                	je     805d2 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x132>
   8057c:	49 83 c5 0f          	add    $0xf,%r13
   80580:	49 c1 ed 04          	shr    $0x4,%r13
   80584:	4c 89 e8             	mov    %r13,%rax
   80587:	48 29 f8             	sub    %rdi,%rax
   8058a:	74 46                	je     805d2 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x132>
   8058c:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
   80591:	4c 29 f9             	sub    %r15,%rcx
   80594:	49 89 cc             	mov    %rcx,%r12
   80597:	4c 0f af e0          	imul   %rax,%r12
   8059b:	48 c7 83 48 01 00 00 	movq   $0x0,0x148(%rbx)
   805a2:	00 00 00 00 
   805a6:	4c 89 64 24 28       	mov    %r12,0x28(%rsp)
   805ab:	49 ff c4             	inc    %r12
   805ae:	4c 89 7c 24 70       	mov    %r15,0x70(%rsp)
   805b3:	48 89 bc 24 70 01 00 	mov    %rdi,0x170(%rsp)
   805ba:	00 
   805bb:	48 89 84 24 88 03 00 	mov    %rax,0x388(%rsp)
   805c2:	00 
   805c3:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
   805c8:	75 60                	jne    8062a <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x18a>
   805ca:	45 31 e4             	xor    %r12d,%r12d
   805cd:	e9 a1 00 00 00       	jmp    80673 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1d3>
   805d2:	48 8b 53 70          	mov    0x70(%rbx),%rdx
   805d6:	48 8b 8b 80 00 00 00 	mov    0x80(%rbx),%rcx
   805dd:	48 8b 83 10 02 00 00 	mov    0x210(%rbx),%rax
   805e4:	4c 8b 93 18 01 00 00 	mov    0x118(%rbx),%r10
   805eb:	4c 8b 9b 88 00 00 00 	mov    0x88(%rbx),%r11
   805f2:	48 8b b3 a0 00 00 00 	mov    0xa0(%rbx),%rsi
   805f9:	4c 8b b3 b8 00 00 00 	mov    0xb8(%rbx),%r14
   80600:	4c 8b 8b d0 00 00 00 	mov    0xd0(%rbx),%r9
   80607:	4c 8b 83 e8 00 00 00 	mov    0xe8(%rbx),%r8
   8060e:	48 8b bb 00 01 00 00 	mov    0x100(%rbx),%rdi
   80615:	4d 85 d2             	test   %r10,%r10
   80618:	0f 84 4c 06 00 00    	je     80c6a <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x7ca>
   8061e:	4d 8b 12             	mov    (%r10),%r10
   80621:	49 c1 e2 03          	shl    $0x3,%r10
   80625:	e9 43 06 00 00       	jmp    80c6d <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x7cd>
   8062a:	4c 3b a3 38 01 00 00 	cmp    0x138(%rbx),%r12
   80631:	0f 87 89 62 00 00    	ja     868c0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x6420>
   80637:	45 31 f6             	xor    %r14d,%r14d
   8063a:	4c 8b bb 40 01 00 00 	mov    0x140(%rbx),%r15
   80641:	4b 8d 3c f7          	lea    (%r15,%r14,8),%rdi
   80645:	48 8b 6c 24 28       	mov    0x28(%rsp),%rbp
   8064a:	48 8d 14 ed 00 00 00 	lea    0x0(,%rbp,8),%rdx
   80651:	00 
   80652:	31 f6                	xor    %esi,%esi
   80654:	ff 15 06 1d 07 00    	call   *0x71d06(%rip)        # f2360 <memset@GLIBC_2.2.5>
   8065a:	49 8d 04 2e          	lea    (%r14,%rbp,1),%rax
   8065e:	4d 01 f4             	add    %r14,%r12
   80661:	49 c7 04 c7 00 00 00 	movq   $0x0,(%r15,%rax,8)
   80668:	00 
   80669:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
   8066e:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
   80673:	4c 89 a3 48 01 00 00 	mov    %r12,0x148(%rbx)
   8067a:	48 8b 83 80 00 00 00 	mov    0x80(%rbx),%rax
   80681:	48 85 c0             	test   %rax,%rax
   80684:	4c 89 ac 24 d0 00 00 	mov    %r13,0xd0(%rsp)
   8068b:	00 
   8068c:	0f 84 e8 02 00 00    	je     8097a <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x4da>
   80692:	48 8b 73 78          	mov    0x78(%rbx),%rsi
   80696:	48 8d 04 86          	lea    (%rsi,%rax,4),%rax
   8069a:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
   806a1:	00 
   806a2:	4d 89 f8             	mov    %r15,%r8
   806a5:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   806aa:	49 29 d0             	sub    %rdx,%r8
   806ad:	42 8d 04 fd 00 00 00 	lea    0x0(,%r15,8),%eax
   806b4:	00 
   806b5:	bf 18 00 00 00       	mov    $0x18,%edi
   806ba:	48 29 c7             	sub    %rax,%rdi
   806bd:	48 89 7c 24 48       	mov    %rdi,0x48(%rsp)
   806c2:	48 8d 0c cd 00 00 00 	lea    0x0(,%rcx,8),%rcx
   806c9:	00 
   806ca:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
   806cf:	48 8d 0c d5 00 00 00 	lea    0x0(,%rdx,8),%rcx
   806d6:	00 
   806d7:	48 29 c1             	sub    %rax,%rcx
   806da:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
   806e1:	00 
   806e2:	b8 01 00 00 00       	mov    $0x1,%eax
   806e7:	4c 29 f8             	sub    %r15,%rax
   806ea:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
   806ef:	49 8d 47 ff          	lea    -0x1(%r15),%rax
   806f3:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
   806f8:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
   806fd:	eb 23                	jmp    80722 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x282>
   806ff:	90                   	nop
   80700:	48 8b b4 24 e8 00 00 	mov    0xe8(%rsp),%rsi
   80707:	00 
   80708:	48 83 c6 04          	add    $0x4,%rsi
   8070c:	48 3b b4 24 88 00 00 	cmp    0x88(%rsp),%rsi
   80713:	00 
   80714:	4c 8b ac 24 d0 00 00 	mov    0xd0(%rsp),%r13
   8071b:	00 
   8071c:	0f 84 4c 02 00 00    	je     8096e <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x4ce>
   80722:	48 89 b4 24 e8 00 00 	mov    %rsi,0xe8(%rsp)
   80729:	00 
   8072a:	8b 16                	mov    (%rsi),%edx
   8072c:	48 8d bc 24 d8 0d 00 	lea    0xdd8(%rsp),%rdi
   80733:	00 
   80734:	48 89 de             	mov    %rbx,%rsi
   80737:	e8 a4 85 00 00       	call   88ce0 <<gpui_canvas::canvas::DisplayList>::get>
   8073c:	66 0f 76 d2          	pcmpeqd %xmm2,%xmm2
   80740:	48 8b 84 24 50 0e 00 	mov    0xe50(%rsp),%rax
   80747:	00 
   80748:	48 c1 e8 04          	shr    $0x4,%rax
   8074c:	48 8b 8c 24 70 01 00 	mov    0x170(%rsp),%rcx
   80753:	00 
   80754:	48 39 c1             	cmp    %rax,%rcx
   80757:	48 0f 47 c1          	cmova  %rcx,%rax
   8075b:	48 8b 94 24 60 0e 00 	mov    0xe60(%rsp),%rdx
   80762:	00 
   80763:	48 89 d1             	mov    %rdx,%rcx
   80766:	48 c1 e9 04          	shr    $0x4,%rcx
   8076a:	83 e2 0f             	and    $0xf,%edx
   8076d:	48 83 fa 01          	cmp    $0x1,%rdx
   80771:	48 83 d9 ff          	sbb    $0xffffffffffffffff,%rcx
   80775:	49 39 cd             	cmp    %rcx,%r13
   80778:	49 0f 42 cd          	cmovb  %r13,%rcx
   8077c:	48 89 4c 24 78       	mov    %rcx,0x78(%rsp)
   80781:	48 39 c8             	cmp    %rcx,%rax
   80784:	0f 83 76 ff ff ff    	jae    80700 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x260>
   8078a:	48 8b 94 24 48 0e 00 	mov    0xe48(%rsp),%rdx
   80791:	00 
   80792:	48 c1 ea 04          	shr    $0x4,%rdx
   80796:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
   8079b:	48 39 d1             	cmp    %rdx,%rcx
   8079e:	48 0f 47 d1          	cmova  %rcx,%rdx
   807a2:	48 8b b4 24 58 0e 00 	mov    0xe58(%rsp),%rsi
   807a9:	00 
   807aa:	48 89 f7             	mov    %rsi,%rdi
   807ad:	48 c1 ef 04          	shr    $0x4,%rdi
   807b1:	83 e6 0f             	and    $0xf,%esi
   807b4:	48 83 fe 01          	cmp    $0x1,%rsi
   807b8:	48 83 df ff          	sbb    $0xffffffffffffffff,%rdi
   807bc:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
   807c1:	48 39 f9             	cmp    %rdi,%rcx
   807c4:	48 0f 42 f9          	cmovb  %rcx,%rdi
   807c8:	48 89 bc 24 90 00 00 	mov    %rdi,0x90(%rsp)
   807cf:	00 
   807d0:	48 39 fa             	cmp    %rdi,%rdx
   807d3:	0f 83 27 ff ff ff    	jae    80700 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x260>
   807d9:	4c 8b 8b 40 01 00 00 	mov    0x140(%rbx),%r9
   807e0:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
   807e7:	49 89 d2             	mov    %rdx,%r10
   807ea:	49 f7 d2             	not    %r10
   807ed:	4c 03 94 24 90 00 00 	add    0x90(%rsp),%r10
   807f4:	00 
   807f5:	48 89 d7             	mov    %rdx,%rdi
   807f8:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
   807fd:	48 29 cf             	sub    %rcx,%rdi
   80800:	49 89 c0             	mov    %rax,%r8
   80803:	4c 2b 84 24 70 01 00 	sub    0x170(%rsp),%r8
   8080a:	00 
   8080b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
   80810:	4d 0f af d8          	imul   %r8,%r11
   80814:	4c 01 df             	add    %r11,%rdi
   80817:	48 ff c7             	inc    %rdi
   8081a:	48 89 7c 24 40       	mov    %rdi,0x40(%rsp)
   8081f:	4c 89 df             	mov    %r11,%rdi
   80822:	48 f7 d7             	not    %rdi
   80825:	48 01 cf             	add    %rcx,%rdi
   80828:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
   8082d:	48 29 d7             	sub    %rdx,%rdi
   80830:	48 89 7c 24 50       	mov    %rdi,0x50(%rsp)
   80835:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
   8083a:	4c 01 cf             	add    %r9,%rdi
   8083d:	4c 0f af 44 24 60    	imul   0x60(%rsp),%r8
   80843:	4d 8d 2c d0          	lea    (%r8,%rdx,8),%r13
   80847:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
   8084c:	49 01 fd             	add    %rdi,%r13
   8084f:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
   80854:	4c 8d 24 17          	lea    (%rdi,%rdx,1),%r12
   80858:	4d 01 dc             	add    %r11,%r12
   8085b:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
   80860:	4d 29 de             	sub    %r11,%r14
   80863:	49 29 d6             	sub    %rdx,%r14
   80866:	49 01 fb             	add    %rdi,%r11
   80869:	45 31 ff             	xor    %r15d,%r15d
   8086c:	0f 1f 40 00          	nopl   0x0(%rax)
   80870:	4c 39 e6             	cmp    %r12,%rsi
   80873:	4c 89 e5             	mov    %r12,%rbp
   80876:	48 0f 47 ee          	cmova  %rsi,%rbp
   8087a:	4c 01 f5             	add    %r14,%rbp
   8087d:	49 39 ea             	cmp    %rbp,%r10
   80880:	49 0f 42 ea          	cmovb  %r10,%rbp
   80884:	48 89 cf             	mov    %rcx,%rdi
   80887:	49 0f af ff          	imul   %r15,%rdi
   8088b:	48 03 7c 24 40       	add    0x40(%rsp),%rdi
   80890:	48 39 fe             	cmp    %rdi,%rsi
   80893:	48 0f 47 fe          	cmova  %rsi,%rdi
   80897:	4d 0f af c7          	imul   %r15,%r8
   8089b:	4c 03 44 24 50       	add    0x50(%rsp),%r8
   808a0:	49 01 f8             	add    %rdi,%r8
   808a3:	4d 39 c2             	cmp    %r8,%r10
   808a6:	4d 0f 42 c2          	cmovb  %r10,%r8
   808aa:	49 ff c0             	inc    %r8
   808ad:	48 89 d7             	mov    %rdx,%rdi
   808b0:	49 83 f8 05          	cmp    $0x5,%r8
   808b4:	72 5c                	jb     80912 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x472>
   808b6:	44 89 c1             	mov    %r8d,%ecx
   808b9:	83 e1 03             	and    $0x3,%ecx
   808bc:	bf 04 00 00 00       	mov    $0x4,%edi
   808c1:	48 0f 44 cf          	cmove  %rdi,%rcx
   808c5:	49 29 c8             	sub    %rcx,%r8
   808c8:	4c 89 c7             	mov    %r8,%rdi
   808cb:	48 01 d7             	add    %rdx,%rdi
   808ce:	48 29 cd             	sub    %rcx,%rbp
   808d1:	48 ff c5             	inc    %rbp
   808d4:	45 31 c0             	xor    %r8d,%r8d
   808d7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   808de:	00 00 
   808e0:	f3 43 0f 6f 44 c5 f0 	movdqu -0x10(%r13,%r8,8),%xmm0
   808e7:	f3 43 0f 6f 4c c5 00 	movdqu 0x0(%r13,%r8,8),%xmm1
   808ee:	66 0f fb c2          	psubq  %xmm2,%xmm0
   808f2:	66 0f fb ca          	psubq  %xmm2,%xmm1
   808f6:	f3 43 0f 7f 44 c5 f0 	movdqu %xmm0,-0x10(%r13,%r8,8)
   808fd:	f3 43 0f 7f 4c c5 00 	movdqu %xmm1,0x0(%r13,%r8,8)
   80904:	49 83 c0 04          	add    $0x4,%r8
   80908:	4c 39 c5             	cmp    %r8,%rbp
   8090b:	75 d3                	jne    808e0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x440>
   8090d:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
   80912:	48 ff c0             	inc    %rax
   80915:	4c 8b 84 24 90 00 00 	mov    0x90(%rsp),%r8
   8091c:	00 
   8091d:	49 29 f8             	sub    %rdi,%r8
   80920:	4c 01 df             	add    %r11,%rdi
   80923:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   8092a:	84 00 00 00 00 00 
   80930:	48 39 f7             	cmp    %rsi,%rdi
   80933:	0f 83 a4 5e 00 00    	jae    867dd <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x633d>
   80939:	49 ff 04 f9          	incq   (%r9,%rdi,8)
   8093d:	48 ff c7             	inc    %rdi
   80940:	49 ff c8             	dec    %r8
   80943:	75 eb                	jne    80930 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x490>
   80945:	49 ff c7             	inc    %r15
   80948:	4c 03 ac 24 d8 00 00 	add    0xd8(%rsp),%r13
   8094f:	00 
   80950:	49 01 cc             	add    %rcx,%r12
   80953:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
   80958:	4d 01 c6             	add    %r8,%r14
   8095b:	49 01 cb             	add    %rcx,%r11
   8095e:	48 3b 44 24 78       	cmp    0x78(%rsp),%rax
   80963:	0f 85 07 ff ff ff    	jne    80870 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x3d0>
   80969:	e9 92 fd ff ff       	jmp    80700 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x260>
   8096e:	4c 8b a3 48 01 00 00 	mov    0x148(%rbx),%r12
   80975:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
   8097a:	49 83 fc 02          	cmp    $0x2,%r12
   8097e:	72 4c                	jb     809cc <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x52c>
   80980:	bf 01 00 00 00       	mov    $0x1,%edi
   80985:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   8098c:	00 00 00 00 
   80990:	48 8d 47 ff          	lea    -0x1(%rdi),%rax
   80994:	48 8b b3 48 01 00 00 	mov    0x148(%rbx),%rsi
   8099b:	48 39 f0             	cmp    %rsi,%rax
   8099e:	0f 83 8f 60 00 00    	jae    86a33 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x6593>
   809a4:	48 39 f7             	cmp    %rsi,%rdi
   809a7:	0f 83 96 60 00 00    	jae    86a43 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x65a3>
   809ad:	48 8b 83 40 01 00 00 	mov    0x140(%rbx),%rax
   809b4:	48 8b 4c f8 f8       	mov    -0x8(%rax,%rdi,8),%rcx
   809b9:	48 01 0c f8          	add    %rcx,(%rax,%rdi,8)
   809bd:	48 ff c7             	inc    %rdi
   809c0:	49 39 fc             	cmp    %rdi,%r12
   809c3:	75 cb                	jne    80990 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x4f0>
   809c5:	4c 8b a3 48 01 00 00 	mov    0x148(%rbx),%r12
   809cc:	48 c7 83 60 01 00 00 	movq   $0x0,0x160(%rbx)
   809d3:	00 00 00 00 
   809d7:	4d 85 e4             	test   %r12,%r12
   809da:	0f 84 4f 5e 00 00    	je     8682f <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x638f>
   809e0:	48 8b 83 40 01 00 00 	mov    0x140(%rbx),%rax
   809e7:	4e 8b 6c e0 f8       	mov    -0x8(%rax,%r12,8),%r13
   809ec:	4d 85 ed             	test   %r13,%r13
   809ef:	0f 84 f0 02 00 00    	je     80ce5 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x845>
   809f5:	4c 3b ab 50 01 00 00 	cmp    0x150(%rbx),%r13
   809fc:	0f 87 81 5e 00 00    	ja     86883 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x63e3>
   80a02:	45 31 f6             	xor    %r14d,%r14d
   80a05:	4c 8b bb 58 01 00 00 	mov    0x158(%rbx),%r15
   80a0c:	4b 8d 3c b7          	lea    (%r15,%r14,4),%rdi
   80a10:	49 83 fd 01          	cmp    $0x1,%r13
   80a14:	74 22                	je     80a38 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x598>
   80a16:	4a 8d 14 ad fc ff ff 	lea    -0x4(,%r13,4),%rdx
   80a1d:	ff 
   80a1e:	31 f6                	xor    %esi,%esi
   80a20:	ff 15 3a 19 07 00    	call   *0x7193a(%rip)        # f2360 <memset@GLIBC_2.2.5>
   80a26:	4b 8d 04 2e          	lea    (%r14,%r13,1),%rax
   80a2a:	49 8d 3c 87          	lea    (%r15,%rax,4),%rdi
   80a2e:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
   80a32:	4d 01 ee             	add    %r13,%r14
   80a35:	49 ff ce             	dec    %r14
   80a38:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
   80a3d:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
   80a42:	c7 07 00 00 00 00    	movl   $0x0,(%rdi)
   80a48:	49 ff c6             	inc    %r14
   80a4b:	4c 8b a3 48 01 00 00 	mov    0x148(%rbx),%r12
   80a52:	4c 89 b3 60 01 00 00 	mov    %r14,0x160(%rbx)
   80a59:	48 c7 83 78 01 00 00 	movq   $0x0,0x178(%rbx)
   80a60:	00 00 00 00 
   80a64:	4d 39 e5             	cmp    %r12,%r13
   80a67:	0f 87 9b 02 00 00    	ja     80d08 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x868>
   80a6d:	48 8b b3 40 01 00 00 	mov    0x140(%rbx),%rsi
   80a74:	4c 3b ab 68 01 00 00 	cmp    0x168(%rbx),%r13
   80a7b:	0f 87 bb 5d 00 00    	ja     8683c <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x639c>
   80a81:	31 ff                	xor    %edi,%edi
   80a83:	48 c1 e7 03          	shl    $0x3,%rdi
   80a87:	48 03 bb 70 01 00 00 	add    0x170(%rbx),%rdi
   80a8e:	4a 8d 14 ed 00 00 00 	lea    0x0(,%r13,8),%rdx
   80a95:	00 
   80a96:	ff 15 34 18 07 00    	call   *0x71834(%rip)        # f22d0 <memcpy@GLIBC_2.14>
   80a9c:	4c 01 ab 78 01 00 00 	add    %r13,0x178(%rbx)
   80aa3:	48 8b 83 80 00 00 00 	mov    0x80(%rbx),%rax
   80aaa:	45 31 c0             	xor    %r8d,%r8d
   80aad:	48 85 c0             	test   %rax,%rax
   80ab0:	0f 84 7e 01 00 00    	je     80c34 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x794>
   80ab6:	45 31 ed             	xor    %r13d,%r13d
   80ab9:	4c 8b 73 78          	mov    0x78(%rbx),%r14
   80abd:	4d 8d 24 86          	lea    (%r14,%rax,4),%r12
   80ac1:	49 f7 df             	neg    %r15
   80ac4:	4c 89 7c 24 78       	mov    %r15,0x78(%rsp)
   80ac9:	48 8b ac 24 70 01 00 	mov    0x170(%rsp),%rbp
   80ad0:	00 
   80ad1:	48 f7 dd             	neg    %rbp
   80ad4:	4c 8d bc 24 d8 0d 00 	lea    0xdd8(%rsp),%r15
   80adb:	00 
   80adc:	eb 12                	jmp    80af0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x650>
   80ade:	66 90                	xchg   %ax,%ax
   80ae0:	49 83 c6 04          	add    $0x4,%r14
   80ae4:	41 ff c5             	inc    %r13d
   80ae7:	4d 39 e6             	cmp    %r12,%r14
   80aea:	0f 84 38 01 00 00    	je     80c28 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x788>
   80af0:	41 8b 16             	mov    (%r14),%edx
   80af3:	4c 89 ff             	mov    %r15,%rdi
   80af6:	48 89 de             	mov    %rbx,%rsi
   80af9:	e8 e2 81 00 00       	call   88ce0 <<gpui_canvas::canvas::DisplayList>::get>
   80afe:	83 bc 24 d8 0d 00 00 	cmpl   $0xffffffff,0xdd8(%rsp)
   80b05:	ff 
   80b06:	0f 84 1c 01 00 00    	je     80c28 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x788>
   80b0c:	48 8b 8c 24 50 0e 00 	mov    0xe50(%rsp),%rcx
   80b13:	00 
   80b14:	48 c1 e9 04          	shr    $0x4,%rcx
   80b18:	48 8b 84 24 70 01 00 	mov    0x170(%rsp),%rax
   80b1f:	00 
   80b20:	48 39 c8             	cmp    %rcx,%rax
   80b23:	48 0f 47 c8          	cmova  %rax,%rcx
   80b27:	48 8b 84 24 60 0e 00 	mov    0xe60(%rsp),%rax
   80b2e:	00 
   80b2f:	48 89 c2             	mov    %rax,%rdx
   80b32:	48 c1 ea 04          	shr    $0x4,%rdx
   80b36:	83 e0 0f             	and    $0xf,%eax
   80b39:	48 83 f8 01          	cmp    $0x1,%rax
   80b3d:	48 83 da ff          	sbb    $0xffffffffffffffff,%rdx
   80b41:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
   80b48:	00 
   80b49:	48 39 d0             	cmp    %rdx,%rax
   80b4c:	48 0f 42 d0          	cmovb  %rax,%rdx
   80b50:	48 39 d1             	cmp    %rdx,%rcx
   80b53:	73 8b                	jae    80ae0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x640>
   80b55:	48 8b 84 24 48 0e 00 	mov    0xe48(%rsp),%rax
   80b5c:	00 
   80b5d:	48 c1 e8 04          	shr    $0x4,%rax
   80b61:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
   80b66:	48 39 c6             	cmp    %rax,%rsi
   80b69:	48 0f 47 c6          	cmova  %rsi,%rax
   80b6d:	48 8b b4 24 58 0e 00 	mov    0xe58(%rsp),%rsi
   80b74:	00 
   80b75:	49 89 f0             	mov    %rsi,%r8
   80b78:	49 c1 e8 04          	shr    $0x4,%r8
   80b7c:	83 e6 0f             	and    $0xf,%esi
   80b7f:	48 83 fe 01          	cmp    $0x1,%rsi
   80b83:	49 83 d8 ff          	sbb    $0xffffffffffffffff,%r8
   80b87:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
   80b8c:	4c 39 c6             	cmp    %r8,%rsi
   80b8f:	4c 0f 42 c6          	cmovb  %rsi,%r8
   80b93:	49 29 c0             	sub    %rax,%r8
   80b96:	0f 86 44 ff ff ff    	jbe    80ae0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x640>
   80b9c:	48 03 44 24 78       	add    0x78(%rsp),%rax
   80ba1:	4c 8d 0c 29          	lea    (%rcx,%rbp,1),%r9
   80ba5:	4c 0f af 4c 24 20    	imul   0x20(%rsp),%r9
   80bab:	49 01 c1             	add    %rax,%r9
   80bae:	66 90                	xchg   %ax,%ax
   80bb0:	48 ff c1             	inc    %rcx
   80bb3:	4c 89 cf             	mov    %r9,%rdi
   80bb6:	4d 89 c2             	mov    %r8,%r10
   80bb9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   80bc0:	48 8b b3 78 01 00 00 	mov    0x178(%rbx),%rsi
   80bc7:	48 39 f7             	cmp    %rsi,%rdi
   80bca:	0f 83 37 5c 00 00    	jae    86807 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x6367>
   80bd0:	48 8b b3 60 01 00 00 	mov    0x160(%rbx),%rsi
   80bd7:	48 8b 83 70 01 00 00 	mov    0x170(%rbx),%rax
   80bde:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
   80be2:	48 39 f0             	cmp    %rsi,%rax
   80be5:	0f 83 0c 5c 00 00    	jae    867f7 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x6357>
   80beb:	48 8b b3 58 01 00 00 	mov    0x158(%rbx),%rsi
   80bf2:	44 89 2c 86          	mov    %r13d,(%rsi,%rax,4)
   80bf6:	48 8b b3 78 01 00 00 	mov    0x178(%rbx),%rsi
   80bfd:	48 39 f7             	cmp    %rsi,%rdi
   80c00:	0f 83 e4 5b 00 00    	jae    867ea <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x634a>
   80c06:	48 8b 83 70 01 00 00 	mov    0x170(%rbx),%rax
   80c0d:	48 ff 04 f8          	incq   (%rax,%rdi,8)
   80c11:	48 ff c7             	inc    %rdi
   80c14:	49 ff ca             	dec    %r10
   80c17:	75 a7                	jne    80bc0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x720>
   80c19:	4c 03 4c 24 20       	add    0x20(%rsp),%r9
   80c1e:	48 39 d1             	cmp    %rdx,%rcx
   80c21:	75 8d                	jne    80bb0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x710>
   80c23:	e9 b8 fe ff ff       	jmp    80ae0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x640>
   80c28:	4c 8b 83 80 00 00 00 	mov    0x80(%rbx),%r8
   80c2f:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
   80c34:	48 8b 83 90 01 00 00 	mov    0x190(%rbx),%rax
   80c3b:	48 ff c0             	inc    %rax
   80c3e:	49 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%r11
   80c45:	4c 0f 45 d8          	cmovne %rax,%r11
   80c49:	48 8b 83 18 01 00 00 	mov    0x118(%rbx),%rax
   80c50:	48 85 c0             	test   %rax,%rax
   80c53:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
   80c58:	0f 84 bf 00 00 00    	je     80d1d <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x87d>
   80c5e:	48 8b 08             	mov    (%rax),%rcx
   80c61:	48 c1 e1 03          	shl    $0x3,%rcx
   80c65:	e9 b5 00 00 00       	jmp    80d1f <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x87f>
   80c6a:	45 31 d2             	xor    %r10d,%r10d
   80c6d:	4d 6b db 68          	imul   $0x68,%r11,%r11
   80c71:	4f 8d 34 b6          	lea    (%r14,%r14,4),%r14
   80c75:	49 c1 e6 04          	shl    $0x4,%r14
   80c79:	49 c1 e0 05          	shl    $0x5,%r8
   80c7d:	4d 01 f0             	add    %r14,%r8
   80c80:	48 01 d6             	add    %rdx,%rsi
   80c83:	4c 01 cf             	add    %r9,%rdi
   80c86:	49 8d 14 b3          	lea    (%r11,%rsi,4),%rdx
   80c8a:	4c 01 c2             	add    %r8,%rdx
   80c8d:	48 8d 14 fa          	lea    (%rdx,%rdi,8),%rdx
   80c91:	4c 01 d2             	add    %r10,%rdx
   80c94:	48 8b b3 50 01 00 00 	mov    0x150(%rbx),%rsi
   80c9b:	48 8b bb 68 01 00 00 	mov    0x168(%rbx),%rdi
   80ca2:	48 03 bb 38 01 00 00 	add    0x138(%rbx),%rdi
   80ca9:	48 c1 e6 02          	shl    $0x2,%rsi
   80cad:	48 8d 34 fe          	lea    (%rsi,%rdi,8),%rsi
   80cb1:	48 89 8b 98 01 00 00 	mov    %rcx,0x198(%rbx)
   80cb8:	66 0f ef c0          	pxor   %xmm0,%xmm0
   80cbc:	f3 0f 7f 83 a0 01 00 	movdqu %xmm0,0x1a0(%rbx)
   80cc3:	00 
   80cc4:	f3 0f 7f 83 b0 01 00 	movdqu %xmm0,0x1b0(%rbx)
   80ccb:	00 
   80ccc:	48 c7 83 c0 01 00 00 	movq   $0x0,0x1c0(%rbx)
   80cd3:	00 00 00 00 
   80cd7:	48 89 83 c8 01 00 00 	mov    %rax,0x1c8(%rbx)
   80cde:	31 c0                	xor    %eax,%eax
   80ce0:	e9 85 23 00 00       	jmp    8306a <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2bca>
   80ce5:	45 31 f6             	xor    %r14d,%r14d
   80ce8:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
   80ced:	4c 89 b3 60 01 00 00 	mov    %r14,0x160(%rbx)
   80cf4:	48 c7 83 78 01 00 00 	movq   $0x0,0x178(%rbx)
   80cfb:	00 00 00 00 
   80cff:	4d 39 e5             	cmp    %r12,%r13
   80d02:	0f 86 65 fd ff ff    	jbe    80a6d <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x5cd>
   80d08:	48 8d 0d 51 e4 06 00 	lea    0x6e451(%rip),%rcx        # ef160 <anon.3298d8a0178d409610dedcc629419ce8.17.llvm.4435257794685775273+0x5110>
   80d0f:	31 ff                	xor    %edi,%edi
   80d11:	4c 89 ee             	mov    %r13,%rsi
   80d14:	4c 89 e2             	mov    %r12,%rdx
   80d17:	ff 15 8b 18 07 00    	call   *0x7188b(%rip)        # f25a8 <_DYNAMIC+0x5a0>
   80d1d:	31 c9                	xor    %ecx,%ecx
   80d1f:	48 8b 43 70          	mov    0x70(%rbx),%rax
   80d23:	48 89 84 24 98 05 00 	mov    %rax,0x598(%rsp)
   80d2a:	00 
   80d2b:	48 8b 83 88 00 00 00 	mov    0x88(%rbx),%rax
   80d32:	48 89 84 24 70 05 00 	mov    %rax,0x570(%rsp)
   80d39:	00 
   80d3a:	48 8b 83 a0 00 00 00 	mov    0xa0(%rbx),%rax
   80d41:	48 89 84 24 a0 05 00 	mov    %rax,0x5a0(%rsp)
   80d48:	00 
   80d49:	48 8b 83 b8 00 00 00 	mov    0xb8(%rbx),%rax
   80d50:	48 89 84 24 68 05 00 	mov    %rax,0x568(%rsp)
   80d57:	00 
   80d58:	48 8b 83 d0 00 00 00 	mov    0xd0(%rbx),%rax
   80d5f:	48 89 84 24 78 05 00 	mov    %rax,0x578(%rsp)
   80d66:	00 
   80d67:	48 8b 83 e8 00 00 00 	mov    0xe8(%rbx),%rax
   80d6e:	48 89 84 24 90 05 00 	mov    %rax,0x590(%rsp)
   80d75:	00 
   80d76:	48 8b 83 00 01 00 00 	mov    0x100(%rbx),%rax
   80d7d:	48 89 84 24 88 05 00 	mov    %rax,0x588(%rsp)
   80d84:	00 
   80d85:	48 8b 83 60 01 00 00 	mov    0x160(%rbx),%rax
   80d8c:	48 89 84 24 48 02 00 	mov    %rax,0x248(%rsp)
   80d93:	00 
   80d94:	48 8b 93 10 02 00 00 	mov    0x210(%rbx),%rdx
   80d9b:	48 8b 83 68 01 00 00 	mov    0x168(%rbx),%rax
   80da2:	48 03 83 38 01 00 00 	add    0x138(%rbx),%rax
   80da9:	48 8b b3 50 01 00 00 	mov    0x150(%rbx),%rsi
   80db0:	48 89 b4 24 80 05 00 	mov    %rsi,0x580(%rsp)
   80db7:	00 
   80db8:	4c 8b a3 f0 01 00 00 	mov    0x1f0(%rbx),%r12
   80dbf:	48 8b b3 f8 01 00 00 	mov    0x1f8(%rbx),%rsi
   80dc6:	48 89 b4 24 30 04 00 	mov    %rsi,0x430(%rsp)
   80dcd:	00 
   80dce:	f3 0f 6f 83 00 02 00 	movdqu 0x200(%rbx),%xmm0
   80dd5:	00 
   80dd6:	66 0f 7f 84 24 e0 02 	movdqa %xmm0,0x2e0(%rsp)
   80ddd:	00 00 
   80ddf:	48 8b b3 40 01 00 00 	mov    0x140(%rbx),%rsi
   80de6:	48 89 b4 24 38 04 00 	mov    %rsi,0x438(%rsp)
   80ded:	00 
   80dee:	4c 8b b3 48 01 00 00 	mov    0x148(%rbx),%r14
   80df5:	0f b6 b3 21 02 00 00 	movzbl 0x221(%rbx),%esi
   80dfc:	40 88 74 24 0f       	mov    %sil,0xf(%rsp)
   80e01:	48 8b b3 58 01 00 00 	mov    0x158(%rbx),%rsi
   80e08:	48 89 b4 24 d0 02 00 	mov    %rsi,0x2d0(%rsp)
   80e0f:	00 
   80e10:	48 85 ff             	test   %rdi,%rdi
   80e13:	48 8b b4 24 70 01 00 	mov    0x170(%rsp),%rsi
   80e1a:	00 
   80e1b:	4c 89 44 24 50       	mov    %r8,0x50(%rsp)
   80e20:	4c 89 b4 24 80 00 00 	mov    %r14,0x80(%rsp)
   80e27:	00 
   80e28:	4c 89 a4 24 a8 00 00 	mov    %r12,0xa8(%rsp)
   80e2f:	00 
   80e30:	48 89 8c 24 b8 05 00 	mov    %rcx,0x5b8(%rsp)
   80e37:	00 
   80e38:	48 89 94 24 b0 05 00 	mov    %rdx,0x5b0(%rsp)
   80e3f:	00 
   80e40:	48 89 84 24 a8 05 00 	mov    %rax,0x5a8(%rsp)
   80e47:	00 
   80e48:	74 50                	je     80e9a <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x9fa>
   80e4a:	8b ab 80 01 00 00    	mov    0x180(%rbx),%ebp
   80e50:	4c 8b b3 84 01 00 00 	mov    0x184(%rbx),%r14
   80e57:	44 0f b6 bb 8c 01 00 	movzbl 0x18c(%rbx),%r15d
   80e5e:	00 
   80e5f:	0f b6 83 8f 01 00 00 	movzbl 0x18f(%rbx),%eax
   80e66:	88 84 24 d2 09 00 00 	mov    %al,0x9d2(%rsp)
   80e6d:	0f b7 83 8d 01 00 00 	movzwl 0x18d(%rbx),%eax
   80e74:	66 89 84 24 d0 09 00 	mov    %ax,0x9d0(%rsp)
   80e7b:	00 
   80e7c:	45 84 ff             	test   %r15b,%r15b
   80e7f:	0f 95 c0             	setne  %al
   80e82:	85 ed                	test   %ebp,%ebp
   80e84:	41 0f 95 c1          	setne  %r9b
   80e88:	41 08 c1             	or     %al,%r9b
   80e8b:	44 88 8c 24 a8 01 00 	mov    %r9b,0x1a8(%rsp)
   80e92:	00 
   80e93:	74 6d                	je     80f02 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xa62>
   80e95:	45 31 c9             	xor    %r9d,%r9d
   80e98:	eb 7d                	jmp    80f17 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xa77>
   80e9a:	80 bb 8d 01 00 00 00 	cmpb   $0x0,0x18d(%rbx)
   80ea1:	0f 84 fb 00 00 00    	je     80fa2 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xb02>
   80ea7:	4c 89 e5             	mov    %r12,%rbp
   80eaa:	48 c1 e5 07          	shl    $0x7,%rbp
   80eae:	0f 84 b6 59 00 00    	je     8686a <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x63ca>
   80eb4:	4c 8b 8b 30 01 00 00 	mov    0x130(%rbx),%r9
   80ebb:	66 0f ef c0          	pxor   %xmm0,%xmm0
   80ebf:	4d 85 c9             	test   %r9,%r9
   80ec2:	4c 89 9c 24 90 01 00 	mov    %r11,0x190(%rsp)
   80ec9:	00 
   80eca:	0f 84 c8 21 00 00    	je     83098 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2bf8>
   80ed0:	0f b6 83 8c 01 00 00 	movzbl 0x18c(%rbx),%eax
   80ed7:	88 84 24 c0 02 00 00 	mov    %al,0x2c0(%rsp)
   80ede:	48 8b bb 28 01 00 00 	mov    0x128(%rbx),%rdi
   80ee5:	4c 89 c8             	mov    %r9,%rax
   80ee8:	48 09 e8             	or     %rbp,%rax
   80eeb:	48 c1 e8 20          	shr    $0x20,%rax
   80eef:	0f 84 b4 21 00 00    	je     830a9 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2c09>
   80ef5:	4c 89 c8             	mov    %r9,%rax
   80ef8:	31 d2                	xor    %edx,%edx
   80efa:	48 f7 f5             	div    %rbp
   80efd:	e9 ae 21 00 00       	jmp    830b0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2c10>
   80f02:	8b 05 10 41 07 00    	mov    0x74110(%rip),%eax        # f5018 <gpui_canvas::color::OPAQUE_SRGB+0xc00>
   80f08:	85 c0                	test   %eax,%eax
   80f0a:	0f 85 0b 5a 00 00    	jne    8691b <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x647b>
   80f10:	4c 8d 0d 01 35 07 00 	lea    0x73501(%rip),%r9        # f4418 <gpui_canvas::color::OPAQUE_SRGB>
   80f17:	89 ac 24 58 02 00 00 	mov    %ebp,0x258(%rsp)
   80f1e:	4c 89 b4 24 5c 02 00 	mov    %r14,0x25c(%rsp)
   80f25:	00 
   80f26:	44 88 bc 24 64 02 00 	mov    %r15b,0x264(%rsp)
   80f2d:	00 
   80f2e:	0f b7 84 24 d0 09 00 	movzwl 0x9d0(%rsp),%eax
   80f35:	00 
   80f36:	66 89 84 24 65 02 00 	mov    %ax,0x265(%rsp)
   80f3d:	00 
   80f3e:	0f b6 84 24 d2 09 00 	movzbl 0x9d2(%rsp),%eax
   80f45:	00 
   80f46:	88 84 24 67 02 00 00 	mov    %al,0x267(%rsp)
   80f4d:	4c 89 8c 24 f0 00 00 	mov    %r9,0xf0(%rsp)
   80f54:	00 
   80f55:	4c 89 8c 24 68 02 00 	mov    %r9,0x268(%rsp)
   80f5c:	00 
   80f5d:	4c 8b ac 24 a8 00 00 	mov    0xa8(%rsp),%r13
   80f64:	00 
   80f65:	4d 89 e9             	mov    %r13,%r9
   80f68:	49 c1 e1 04          	shl    $0x4,%r9
   80f6c:	0f 84 f8 58 00 00    	je     8686a <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x63ca>
   80f72:	66 0f ef c0          	pxor   %xmm0,%xmm0
   80f76:	48 8b 84 24 50 02 00 	mov    0x250(%rsp),%rax
   80f7d:	00 
   80f7e:	48 85 c0             	test   %rax,%rax
   80f81:	0f 84 28 20 00 00    	je     82faf <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2b0f>
   80f87:	48 89 c2             	mov    %rax,%rdx
   80f8a:	4c 09 ca             	or     %r9,%rdx
   80f8d:	48 c1 ea 20          	shr    $0x20,%rdx
   80f91:	4c 89 8c 24 d0 01 00 	mov    %r9,0x1d0(%rsp)
   80f98:	00 
   80f99:	74 5b                	je     80ff6 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xb56>
   80f9b:	31 d2                	xor    %edx,%edx
   80f9d:	49 f7 f1             	div    %r9
   80fa0:	eb 59                	jmp    80ffb <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xb5b>
   80fa2:	48 8d 83 8d 01 00 00 	lea    0x18d(%rbx),%rax
   80fa9:	8b ab 80 01 00 00    	mov    0x180(%rbx),%ebp
   80faf:	4c 8b b3 84 01 00 00 	mov    0x184(%rbx),%r14
   80fb6:	44 0f b6 bb 8c 01 00 	movzbl 0x18c(%rbx),%r15d
   80fbd:	00 
   80fbe:	0f b6 48 02          	movzbl 0x2(%rax),%ecx
   80fc2:	88 8c 24 d2 09 00 00 	mov    %cl,0x9d2(%rsp)
   80fc9:	0f b7 00             	movzwl (%rax),%eax
   80fcc:	66 89 84 24 d0 09 00 	mov    %ax,0x9d0(%rsp)
   80fd3:	00 
   80fd4:	45 84 ff             	test   %r15b,%r15b
   80fd7:	0f 95 c0             	setne  %al
   80fda:	85 ed                	test   %ebp,%ebp
   80fdc:	0f 95 c1             	setne  %cl
   80fdf:	08 c1                	or     %al,%cl
   80fe1:	88 8c 24 b0 01 00 00 	mov    %cl,0x1b0(%rsp)
   80fe8:	0f 84 fe 1e 00 00    	je     82eec <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2a4c>
   80fee:	45 31 e4             	xor    %r12d,%r12d
   80ff1:	e9 0b 1f 00 00       	jmp    82f01 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2a61>
   80ff6:	31 d2                	xor    %edx,%edx
   80ff8:	41 f7 f1             	div    %r9d
   80ffb:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
   81000:	4c 8b b4 24 80 00 00 	mov    0x80(%rsp),%r14
   81007:	00 
   81008:	48 83 fa 01          	cmp    $0x1,%rdx
   8100c:	48 83 d8 ff          	sbb    $0xffffffffffffffff,%rax
   81010:	48 c7 84 24 68 01 00 	movq   $0x0,0x168(%rsp)
   81017:	00 00 00 00 00 
   8101c:	48 89 c1             	mov    %rax,%rcx
   8101f:	48 29 f1             	sub    %rsi,%rcx
   81022:	ba 00 00 00 00       	mov    $0x0,%edx
   81027:	48 0f 43 d1          	cmovae %rcx,%rdx
   8102b:	48 8b 8c 24 88 03 00 	mov    0x388(%rsp),%rcx
   81032:	00 
   81033:	48 39 ca             	cmp    %rcx,%rdx
   81036:	48 0f 43 d1          	cmovae %rcx,%rdx
   8103a:	48 89 94 24 30 02 00 	mov    %rdx,0x230(%rsp)
   81041:	00 
   81042:	66 0f ef c9          	pxor   %xmm1,%xmm1
   81046:	48 39 f0             	cmp    %rsi,%rax
   81049:	0f 86 64 1f 00 00    	jbe    82fb3 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2b13>
   8104f:	0f 28 94 24 e0 02 00 	movaps 0x2e0(%rsp),%xmm2
   81056:	00 
   81057:	0f 28 da             	movaps %xmm2,%xmm3
   8105a:	0f c6 da ff          	shufps $0xff,%xmm2,%xmm3
   8105e:	f3 0f 10 2d ce f7 f9 	movss  -0x60832(%rip),%xmm5        # 20834 <anon.716c7528f09896edfd633c06424fb6be.44.llvm.7987781668536310964+0x199>
   81065:	ff 
   81066:	0f 2e dd             	ucomiss %xmm5,%xmm3
   81069:	0f 9a c0             	setp   %al
   8106c:	40 0f 95 c5          	setne  %bpl
   81070:	40 08 c5             	or     %al,%bpl
   81073:	66 0f 7e d1          	movd   %xmm2,%ecx
   81077:	89 c8                	mov    %ecx,%eax
   81079:	c1 e8 10             	shr    $0x10,%eax
   8107c:	25 ff 07 00 00       	and    $0x7ff,%eax
   81081:	48 89 84 24 18 04 00 	mov    %rax,0x418(%rsp)
   81088:	00 
   81089:	0f 28 c2             	movaps %xmm2,%xmm0
   8108c:	0f c6 c2 55          	shufps $0x55,%xmm2,%xmm0
   81090:	66 0f 7e c2          	movd   %xmm0,%edx
   81094:	89 d0                	mov    %edx,%eax
   81096:	c1 e8 10             	shr    $0x10,%eax
   81099:	25 ff 07 00 00       	and    $0x7ff,%eax
   8109e:	48 89 84 24 10 04 00 	mov    %rax,0x410(%rsp)
   810a5:	00 
   810a6:	66 0f 6f ca          	movdqa %xmm2,%xmm1
   810aa:	66 0f 6d ca          	punpckhqdq %xmm2,%xmm1
   810ae:	66 41 0f 7e c8       	movd   %xmm1,%r8d
   810b3:	44 89 c0             	mov    %r8d,%eax
   810b6:	c1 e8 10             	shr    $0x10,%eax
   810b9:	25 ff 07 00 00       	and    $0x7ff,%eax
   810be:	48 89 84 24 08 04 00 	mov    %rax,0x408(%rsp)
   810c5:	00 
   810c6:	40 0a ac 24 a8 01 00 	or     0x1a8(%rsp),%bpl
   810cd:	00 
   810ce:	0f 57 f6             	xorps  %xmm6,%xmm6
   810d1:	0f 2e f2             	ucomiss %xmm2,%xmm6
   810d4:	b8 00 00 00 00       	mov    $0x0,%eax
   810d9:	19 c0                	sbb    %eax,%eax
   810db:	89 84 24 38 03 00 00 	mov    %eax,0x338(%rsp)
   810e2:	0f 2e f0             	ucomiss %xmm0,%xmm6
   810e5:	b8 00 00 00 00       	mov    $0x0,%eax
   810ea:	19 c0                	sbb    %eax,%eax
   810ec:	89 84 24 30 03 00 00 	mov    %eax,0x330(%rsp)
   810f3:	0f 2e f1             	ucomiss %xmm1,%xmm6
   810f6:	0f 28 e5             	movaps %xmm5,%xmm4
   810f9:	f3 0f c2 e2 02       	cmpless %xmm2,%xmm4
   810fe:	f3 0f c2 d6 02       	cmpless %xmm6,%xmm2
   81103:	0f 56 d4             	orps   %xmm4,%xmm2
   81106:	0f 28 e5             	movaps %xmm5,%xmm4
   81109:	f3 0f c2 e0 02       	cmpless %xmm0,%xmm4
   8110e:	f3 0f c2 c6 02       	cmpless %xmm6,%xmm0
   81113:	0f 56 c4             	orps   %xmm4,%xmm0
   81116:	0f 28 e5             	movaps %xmm5,%xmm4
   81119:	f3 0f c2 e1 02       	cmpless %xmm1,%xmm4
   8111e:	f3 0f c2 ce 02       	cmpless %xmm6,%xmm1
   81123:	b8 00 00 00 00       	mov    $0x0,%eax
   81128:	19 c0                	sbb    %eax,%eax
   8112a:	89 84 24 00 03 00 00 	mov    %eax,0x300(%rsp)
   81131:	0f 56 cc             	orps   %xmm4,%xmm1
   81134:	49 89 f1             	mov    %rsi,%r9
   81137:	4d 0f af cd          	imul   %r13,%r9
   8113b:	4c 89 c8             	mov    %r9,%rax
   8113e:	48 c1 e0 04          	shl    $0x4,%rax
   81142:	4c 8b 94 24 50 02 00 	mov    0x250(%rsp),%r10
   81149:	00 
   8114a:	49 29 c2             	sub    %rax,%r10
   8114d:	49 c1 e1 06          	shl    $0x6,%r9
   81151:	4c 89 f8             	mov    %r15,%rax
   81154:	48 c1 e0 06          	shl    $0x6,%rax
   81158:	4c 01 c8             	add    %r9,%rax
   8115b:	4d 89 dc             	mov    %r11,%r12
   8115e:	4c 8d 1c 07          	lea    (%rdi,%rax,1),%r11
   81162:	4c 89 9c 24 c8 02 00 	mov    %r11,0x2c8(%rsp)
   81169:	00 
   8116a:	48 01 f8             	add    %rdi,%rax
   8116d:	48 83 c0 10          	add    $0x10,%rax
   81171:	48 89 84 24 c0 01 00 	mov    %rax,0x1c0(%rsp)
   81178:	00 
   81179:	49 01 f9             	add    %rdi,%r9
   8117c:	4c 89 8c 24 18 02 00 	mov    %r9,0x218(%rsp)
   81183:	00 
   81184:	66 0f 7e d8          	movd   %xmm3,%eax
   81188:	48 c1 e0 20          	shl    $0x20,%rax
   8118c:	4c 89 84 24 40 03 00 	mov    %r8,0x340(%rsp)
   81193:	00 
   81194:	4c 01 c0             	add    %r8,%rax
   81197:	48 89 84 24 c0 02 00 	mov    %rax,0x2c0(%rsp)
   8119e:	00 
   8119f:	48 89 94 24 48 03 00 	mov    %rdx,0x348(%rsp)
   811a6:	00 
   811a7:	48 89 d0             	mov    %rdx,%rax
   811aa:	4c 89 d2             	mov    %r10,%rdx
   811ad:	48 c1 e0 20          	shl    $0x20,%rax
   811b1:	48 89 8c 24 50 03 00 	mov    %rcx,0x350(%rsp)
   811b8:	00 
   811b9:	48 01 c8             	add    %rcx,%rax
   811bc:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
   811c3:	00 
   811c4:	44 89 f9             	mov    %r15d,%ecx
   811c7:	c1 e1 04             	shl    $0x4,%ecx
   811ca:	48 89 c8             	mov    %rcx,%rax
   811cd:	48 f7 d0             	not    %rax
   811d0:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
   811d7:	00 
   811d8:	4c 8b 8c 24 d0 01 00 	mov    0x1d0(%rsp),%r9
   811df:	00 
   811e0:	49 f7 d9             	neg    %r9
   811e3:	89 f0                	mov    %esi,%eax
   811e5:	c1 e0 04             	shl    $0x4,%eax
   811e8:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
   811ef:	00 
   811f0:	4c 01 f8             	add    %r15,%rax
   811f3:	48 f7 d8             	neg    %rax
   811f6:	48 89 84 24 60 01 00 	mov    %rax,0x160(%rsp)
   811fd:	00 
   811fe:	48 89 c8             	mov    %rcx,%rax
   81201:	48 f7 d8             	neg    %rax
   81204:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
   8120b:	00 
   8120c:	4c 89 f8             	mov    %r15,%rax
   8120f:	48 c1 e0 05          	shl    $0x5,%rax
   81213:	48 f7 d8             	neg    %rax
   81216:	48 01 e0             	add    %rsp,%rax
   81219:	48 05 08 05 00 00    	add    $0x508,%rax
   8121f:	48 89 84 24 b8 02 00 	mov    %rax,0x2b8(%rsp)
   81226:	00 
   81227:	4c 89 e8             	mov    %r13,%rax
   8122a:	48 c1 e0 06          	shl    $0x6,%rax
   8122e:	48 89 84 24 f8 03 00 	mov    %rax,0x3f8(%rsp)
   81235:	00 
   81236:	66 0f ef db          	pxor   %xmm3,%xmm3
   8123a:	f3 0f 11 94 24 28 03 	movss  %xmm2,0x328(%rsp)
   81241:	00 00 
   81243:	f3 0f 11 84 24 5c 01 	movss  %xmm0,0x15c(%rsp)
   8124a:	00 00 
   8124c:	0f 57 c0             	xorps  %xmm0,%xmm0
   8124f:	f3 0f 11 8c 24 20 03 	movss  %xmm1,0x320(%rsp)
   81256:	00 00 
   81258:	0f 57 c9             	xorps  %xmm1,%xmm1
   8125b:	48 8d 41 10          	lea    0x10(%rcx),%rax
   8125f:	48 89 84 24 e0 01 00 	mov    %rax,0x1e0(%rsp)
   81266:	00 
   81267:	48 89 8c 24 c8 01 00 	mov    %rcx,0x1c8(%rsp)
   8126e:	00 
   8126f:	48 8d 41 01          	lea    0x1(%rcx),%rax
   81273:	48 89 84 24 a0 01 00 	mov    %rax,0x1a0(%rsp)
   8127a:	00 
   8127b:	4a 8d 04 ad 00 00 00 	lea    0x0(,%r13,4),%rax
   81282:	00 
   81283:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
   8128a:	00 
   8128b:	48 8d bc 24 d8 0d 00 	lea    0xdd8(%rsp),%rdi
   81292:	00 
   81293:	4c 8b 15 c6 10 07 00 	mov    0x710c6(%rip),%r10        # f2360 <memset@GLIBC_2.2.5>
   8129a:	48 89 d0             	mov    %rdx,%rax
   8129d:	48 89 9c 24 00 02 00 	mov    %rbx,0x200(%rsp)
   812a4:	00 
   812a5:	4c 89 a4 24 90 01 00 	mov    %r12,0x190(%rsp)
   812ac:	00 
   812ad:	40 88 ac 24 00 04 00 	mov    %bpl,0x400(%rsp)
   812b4:	00 
   812b5:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
   812ba:	4c 89 8c 24 88 00 00 	mov    %r9,0x88(%rsp)
   812c1:	00 
   812c2:	0f 29 8c 24 e0 04 00 	movaps %xmm1,0x4e0(%rsp)
   812c9:	00 
   812ca:	0f 29 84 24 f0 04 00 	movaps %xmm0,0x4f0(%rsp)
   812d1:	00 
   812d2:	49 89 c0             	mov    %rax,%r8
   812d5:	48 8b 8c 24 d0 01 00 	mov    0x1d0(%rsp),%rcx
   812dc:	00 
   812dd:	48 29 c8             	sub    %rcx,%rax
   812e0:	48 89 84 24 28 04 00 	mov    %rax,0x428(%rsp)
   812e7:	00 
   812e8:	4c 0f 43 c1          	cmovae %rcx,%r8
   812ec:	4c 89 84 24 50 01 00 	mov    %r8,0x150(%rsp)
   812f3:	00 
   812f4:	48 8b 84 24 68 01 00 	mov    0x168(%rsp),%rax
   812fb:	00 
   812fc:	4c 0f af c8          	imul   %rax,%r9
   81300:	49 01 d1             	add    %rdx,%r9
   81303:	49 39 c9             	cmp    %rcx,%r9
   81306:	4c 0f 43 c9          	cmovae %rcx,%r9
   8130a:	4c 89 8c 24 f0 01 00 	mov    %r9,0x1f0(%rsp)
   81311:	00 
   81312:	48 01 f0             	add    %rsi,%rax
   81315:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
   8131a:	48 0f af c1          	imul   %rcx,%rax
   8131e:	48 8b 94 24 50 02 00 	mov    0x250(%rsp),%rdx
   81325:	00 
   81326:	48 29 c2             	sub    %rax,%rdx
   81329:	48 39 d1             	cmp    %rdx,%rcx
   8132c:	48 0f 42 d1          	cmovb  %rcx,%rdx
   81330:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
   81335:	8b 84 24 20 01 00 00 	mov    0x120(%rsp),%eax
   8133c:	8b 8c 24 23 01 00 00 	mov    0x123(%rsp),%ecx
   81343:	89 8c 24 7b 01 00 00 	mov    %ecx,0x17b(%rsp)
   8134a:	89 84 24 78 01 00 00 	mov    %eax,0x178(%rsp)
   81351:	f3 0f 7f 9c 24 d9 03 	movdqu %xmm3,0x3d9(%rsp)
   81358:	00 00 
   8135a:	66 0f 7f 9c 24 d0 03 	movdqa %xmm3,0x3d0(%rsp)
   81361:	00 00 
   81363:	66 0f 7f 9c 24 c0 03 	movdqa %xmm3,0x3c0(%rsp)
   8136a:	00 00 
   8136c:	66 0f 7f 9c 24 b0 03 	movdqa %xmm3,0x3b0(%rsp)
   81373:	00 00 
   81375:	66 0f 7f 9c 24 a0 03 	movdqa %xmm3,0x3a0(%rsp)
   8137c:	00 00 
   8137e:	66 0f 7f 9c 24 90 03 	movdqa %xmm3,0x390(%rsp)
   81385:	00 00 
   81387:	ba 20 10 01 00       	mov    $0x11020,%edx
   8138c:	31 f6                	xor    %esi,%esi
   8138e:	41 ff d2             	call   *%r10
   81391:	0f 28 84 24 e0 02 00 	movaps 0x2e0(%rsp),%xmm0
   81398:	00 
   81399:	0f 29 84 24 c0 05 00 	movaps %xmm0,0x5c0(%rsp)
   813a0:	00 
   813a1:	40 84 ed             	test   %bpl,%bpl
   813a4:	74 39                	je     813df <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xf3f>
   813a6:	48 8d bc 24 58 02 00 	lea    0x258(%rsp),%rdi
   813ad:	00 
   813ae:	48 8d b4 24 c0 05 00 	lea    0x5c0(%rsp),%rsi
   813b5:	00 
   813b6:	ff 15 5c 16 07 00    	call   *0x7165c(%rip)        # f2a18 <_DYNAMIC+0xa10>
   813bc:	89 c1                	mov    %eax,%ecx
   813be:	c1 e9 08             	shr    $0x8,%ecx
   813c1:	89 c2                	mov    %eax,%edx
   813c3:	c1 ea 10             	shr    $0x10,%edx
   813c6:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
   813cb:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
   813d2:	00 
   813d3:	4c 8b 15 86 0f 07 00 	mov    0x70f86(%rip),%r10        # f2360 <memset@GLIBC_2.2.5>
   813da:	e9 1f 01 00 00       	jmp    814fe <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x105e>
   813df:	8b 84 24 38 03 00 00 	mov    0x338(%rsp),%eax
   813e6:	f6 84 24 28 03 00 00 	testb  $0x1,0x328(%rsp)
   813ed:	01 
   813ee:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
   813f3:	48 8b 94 24 50 03 00 	mov    0x350(%rsp),%rdx
   813fa:	00 
   813fb:	48 8b b4 24 48 03 00 	mov    0x348(%rsp),%rsi
   81402:	00 
   81403:	48 8b bc 24 40 03 00 	mov    0x340(%rsp),%rdi
   8140a:	00 
   8140b:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
   81412:	00 
   81413:	4c 8b 15 46 0f 07 00 	mov    0x70f46(%rip),%r10        # f2360 <memset@GLIBC_2.2.5>
   8141a:	74 2b                	je     81447 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xfa7>
   8141c:	8b 8c 24 30 03 00 00 	mov    0x330(%rsp),%ecx
   81423:	f6 84 24 5c 01 00 00 	testb  $0x1,0x15c(%rsp)
   8142a:	01 
   8142b:	74 65                	je     81492 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xff2>
   8142d:	f6 84 24 20 03 00 00 	testb  $0x1,0x320(%rsp)
   81434:	01 
   81435:	0f 84 99 00 00 00    	je     814d4 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1034>
   8143b:	8b 94 24 00 03 00 00 	mov    0x300(%rsp),%edx
   81442:	e9 b7 00 00 00       	jmp    814fe <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x105e>
   81447:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
   8144e:	00 
   8144f:	39 91 00 08 00 00    	cmp    %edx,0x800(%rcx)
   81455:	76 15                	jbe    8146c <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xfcc>
   81457:	31 c0                	xor    %eax,%eax
   81459:	8b 8c 24 30 03 00 00 	mov    0x330(%rsp),%ecx
   81460:	f6 84 24 5c 01 00 00 	testb  $0x1,0x15c(%rsp)
   81467:	01 
   81468:	75 c3                	jne    8142d <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xf8d>
   8146a:	eb 26                	jmp    81492 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xff2>
   8146c:	48 8b 84 24 18 04 00 	mov    0x418(%rsp),%rax
   81473:	00 
   81474:	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax
   81478:	3b 94 81 00 08 00 00 	cmp    0x800(%rcx,%rax,4),%edx
   8147f:	1c ff                	sbb    $0xff,%al
   81481:	8b 8c 24 30 03 00 00 	mov    0x330(%rsp),%ecx
   81488:	f6 84 24 5c 01 00 00 	testb  $0x1,0x15c(%rsp)
   8148f:	01 
   81490:	75 9b                	jne    8142d <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xf8d>
   81492:	48 8b 94 24 f0 00 00 	mov    0xf0(%rsp),%rdx
   81499:	00 
   8149a:	39 b2 00 08 00 00    	cmp    %esi,0x800(%rdx)
   814a0:	76 0e                	jbe    814b0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1010>
   814a2:	31 c9                	xor    %ecx,%ecx
   814a4:	f6 84 24 20 03 00 00 	testb  $0x1,0x320(%rsp)
   814ab:	01 
   814ac:	75 8d                	jne    8143b <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xf9b>
   814ae:	eb 24                	jmp    814d4 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1034>
   814b0:	48 8b 8c 24 10 04 00 	mov    0x410(%rsp),%rcx
   814b7:	00 
   814b8:	0f b6 0c 0a          	movzbl (%rdx,%rcx,1),%ecx
   814bc:	3b b4 8a 00 08 00 00 	cmp    0x800(%rdx,%rcx,4),%esi
   814c3:	80 d9 ff             	sbb    $0xff,%cl
   814c6:	f6 84 24 20 03 00 00 	testb  $0x1,0x320(%rsp)
   814cd:	01 
   814ce:	0f 85 67 ff ff ff    	jne    8143b <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0xf9b>
   814d4:	48 8b b4 24 f0 00 00 	mov    0xf0(%rsp),%rsi
   814db:	00 
   814dc:	39 be 00 08 00 00    	cmp    %edi,0x800(%rsi)
   814e2:	76 04                	jbe    814e8 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1048>
   814e4:	31 d2                	xor    %edx,%edx
   814e6:	eb 16                	jmp    814fe <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x105e>
   814e8:	48 8b 94 24 08 04 00 	mov    0x408(%rsp),%rdx
   814ef:	00 
   814f0:	0f b6 14 16          	movzbl (%rsi,%rdx,1),%edx
   814f4:	3b bc 96 00 08 00 00 	cmp    0x800(%rsi,%rdx,4),%edi
   814fb:	80 da ff             	sbb    $0xff,%dl
   814fe:	4c 8b a4 24 68 01 00 	mov    0x168(%rsp),%r12
   81505:	00 
   81506:	49 8d 74 24 01       	lea    0x1(%r12),%rsi
   8150b:	48 89 b4 24 20 04 00 	mov    %rsi,0x420(%rsp)
   81512:	00 
   81513:	0f b6 d2             	movzbl %dl,%edx
   81516:	0f b6 c9             	movzbl %cl,%ecx
   81519:	c1 e1 08             	shl    $0x8,%ecx
   8151c:	0f b6 f0             	movzbl %al,%esi
   8151f:	c1 e6 10             	shl    $0x10,%esi
   81522:	09 ce                	or     %ecx,%esi
   81524:	09 d6                	or     %edx,%esi
   81526:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
   8152b:	4c 0f af e1          	imul   %rcx,%r12
   8152f:	4c 89 a4 24 68 01 00 	mov    %r12,0x168(%rsp)
   81536:	00 
   81537:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   8153c:	48 c1 e0 04          	shl    $0x4,%rax
   81540:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
   81545:	48 8d 50 10          	lea    0x10(%rax),%rdx
   81549:	48 8b 84 24 30 04 00 	mov    0x430(%rsp),%rax
   81550:	00 
   81551:	48 39 d0             	cmp    %rdx,%rax
   81554:	48 0f 42 d0          	cmovb  %rax,%rdx
   81558:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
   8155d:	48 8b 84 24 38 02 00 	mov    0x238(%rsp),%rax
   81564:	00 
   81565:	48 89 84 24 40 02 00 	mov    %rax,0x240(%rsp)
   8156c:	00 
   8156d:	4c 8b a4 24 a0 01 00 	mov    0x1a0(%rsp),%r12
   81574:	00 
   81575:	48 8b ac 24 e0 01 00 	mov    0x1e0(%rsp),%rbp
   8157c:	00 
   8157d:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
   81584:	00 
   81585:	48 89 84 24 d8 01 00 	mov    %rax,0x1d8(%rsp)
   8158c:	00 
   8158d:	48 8b 84 24 c8 02 00 	mov    0x2c8(%rsp),%rax
   81594:	00 
   81595:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
   8159c:	00 
   8159d:	48 8b 84 24 c8 01 00 	mov    0x1c8(%rsp),%rax
   815a4:	00 
   815a5:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
   815aa:	48 8b 84 24 b8 02 00 	mov    0x2b8(%rsp),%rax
   815b1:	00 
   815b2:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
   815b9:	00 
   815ba:	48 8b 84 24 20 02 00 	mov    0x220(%rsp),%rax
   815c1:	00 
   815c2:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
   815c7:	48 8b 84 24 60 01 00 	mov    0x160(%rsp),%rax
   815ce:	00 
   815cf:	48 89 84 24 f8 01 00 	mov    %rax,0x1f8(%rsp)
   815d6:	00 
   815d7:	89 b4 24 58 03 00 00 	mov    %esi,0x358(%rsp)
   815de:	89 b4 24 d8 00 00 00 	mov    %esi,0xd8(%rsp)
   815e5:	48 8b 84 24 28 02 00 	mov    0x228(%rsp),%rax
   815ec:	00 
   815ed:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
   815f4:	00 
   815f5:	48 8b 84 24 c0 02 00 	mov    0x2c0(%rsp),%rax
   815fc:	00 
   815fd:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
   81604:	00 
   81605:	31 f6                	xor    %esi,%esi
   81607:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   8160c:	eb 71                	jmp    8167f <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x11df>
   8160e:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
   81613:	4c 8b b4 24 80 00 00 	mov    0x80(%rsp),%r14
   8161a:	00 
   8161b:	4c 8b a4 24 98 00 00 	mov    0x98(%rsp),%r12
   81622:	00 
   81623:	48 8b ac 24 c0 00 00 	mov    0xc0(%rsp),%rbp
   8162a:	00 
   8162b:	48 8b b4 24 c8 00 00 	mov    0xc8(%rsp),%rsi
   81632:	00 
   81633:	48 ff c6             	inc    %rsi
   81636:	48 ff 8c 24 f8 01 00 	decq   0x1f8(%rsp)
   8163d:	00 
   8163e:	48 83 44 24 78 f0    	addq   $0xfffffffffffffff0,0x78(%rsp)
   81644:	48 83 84 24 b8 01 00 	addq   $0xffffffffffffffe0,0x1b8(%rsp)
   8164b:	00 e0 
   8164d:	48 83 44 24 58 10    	addq   $0x10,0x58(%rsp)
   81653:	48 83 84 24 98 01 00 	addq   $0x40,0x198(%rsp)
   8165a:	00 40 
   8165c:	48 83 84 24 d8 01 00 	addq   $0x40,0x1d8(%rsp)
   81663:	00 40 
   81665:	48 83 c5 10          	add    $0x10,%rbp
   81669:	49 83 c4 10          	add    $0x10,%r12
   8166d:	48 83 84 24 40 02 00 	addq   $0xfffffffffffffff0,0x240(%rsp)
   81674:	00 f0 
   81676:	48 39 ce             	cmp    %rcx,%rsi
   81679:	0f 84 83 17 00 00    	je     82e02 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2962>
   8167f:	49 39 ed             	cmp    %rbp,%r13
   81682:	48 89 e8             	mov    %rbp,%rax
   81685:	49 0f 42 c5          	cmovb  %r13,%rax
   81689:	4c 39 e0             	cmp    %r12,%rax
   8168c:	49 0f 46 c4          	cmovbe %r12,%rax
   81690:	48 89 84 24 10 01 00 	mov    %rax,0x110(%rsp)
   81697:	00 
   81698:	48 89 f7             	mov    %rsi,%rdi
   8169b:	48 c1 e7 04          	shl    $0x4,%rdi
   8169f:	48 8b 84 24 e0 01 00 	mov    0x1e0(%rsp),%rax
   816a6:	00 
   816a7:	4c 8d 1c 38          	lea    (%rax,%rdi,1),%r11
   816ab:	4d 39 dd             	cmp    %r11,%r13
   816ae:	4d 0f 42 dd          	cmovb  %r13,%r11
   816b2:	48 8b 84 24 a0 01 00 	mov    0x1a0(%rsp),%rax
   816b9:	00 
   816ba:	48 89 bc 24 08 01 00 	mov    %rdi,0x108(%rsp)
   816c1:	00 
   816c2:	48 01 f8             	add    %rdi,%rax
   816c5:	49 39 c3             	cmp    %rax,%r11
   816c8:	4c 0f 46 d8          	cmovbe %rax,%r11
   816cc:	4c 89 9c 24 d8 02 00 	mov    %r11,0x2d8(%rsp)
   816d3:	00 
   816d4:	48 8b 84 24 68 01 00 	mov    0x168(%rsp),%rax
   816db:	00 
   816dc:	48 89 b4 24 c8 00 00 	mov    %rsi,0xc8(%rsp)
   816e3:	00 
   816e4:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
   816e8:	4c 39 f7             	cmp    %r14,%rdi
   816eb:	0f 83 84 54 00 00    	jae    86b75 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x66d5>
   816f1:	48 8d 47 01          	lea    0x1(%rdi),%rax
   816f5:	4c 39 f0             	cmp    %r14,%rax
   816f8:	0f 83 87 54 00 00    	jae    86b85 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x66e5>
   816fe:	48 8b 84 24 38 04 00 	mov    0x438(%rsp),%rax
   81705:	00 
   81706:	48 8b 34 f8          	mov    (%rax,%rdi,8),%rsi
   8170a:	4c 8b 5c f8 08       	mov    0x8(%rax,%rdi,8),%r11
   8170f:	49 39 f3             	cmp    %rsi,%r11
   81712:	0f 82 fc 50 00 00    	jb     86814 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x6374>
   81718:	4c 3b 9c 24 48 02 00 	cmp    0x248(%rsp),%r11
   8171f:	00 
   81720:	0f 87 ee 50 00 00    	ja     86814 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x6374>
   81726:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
   8172d:	00 
   8172e:	4c 01 f8             	add    %r15,%rax
   81731:	48 89 84 24 18 01 00 	mov    %rax,0x118(%rsp)
   81738:	00 
   81739:	48 c1 e0 04          	shl    $0x4,%rax
   8173d:	48 89 b4 24 e8 01 00 	mov    %rsi,0x1e8(%rsp)
   81744:	00 
   81745:	4c 8d 34 b5 00 00 00 	lea    0x0(,%rsi,4),%r14
   8174c:	00 
   8174d:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
   81752:	48 83 c0 10          	add    $0x10,%rax
   81756:	49 39 c5             	cmp    %rax,%r13
   81759:	49 0f 42 c5          	cmovb  %r13,%rax
   8175d:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
   81762:	4c 89 9c 24 b0 01 00 	mov    %r11,0x1b0(%rsp)
   81769:	00 
   8176a:	4a 8d 04 9d 00 00 00 	lea    0x0(,%r11,4),%rax
   81771:	00 
   81772:	80 7c 24 0f 00       	cmpb   $0x0,0xf(%rsp)
   81777:	4c 89 a4 24 98 00 00 	mov    %r12,0x98(%rsp)
   8177e:	00 
   8177f:	48 89 ac 24 c0 00 00 	mov    %rbp,0xc0(%rsp)
   81786:	00 
   81787:	74 1c                	je     817a5 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1305>
   81789:	49 39 c6             	cmp    %rax,%r14
   8178c:	4c 8b ac 24 d0 02 00 	mov    0x2d0(%rsp),%r13
   81793:	00 
   81794:	49 89 c4             	mov    %rax,%r12
   81797:	0f 85 2d 01 00 00    	jne    818ca <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x142a>
   8179d:	45 31 ff             	xor    %r15d,%r15d
   817a0:	e9 16 02 00 00       	jmp    819bb <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x151b>
   817a5:	45 31 ff             	xor    %r15d,%r15d
   817a8:	4c 8d ac 24 40 04 00 	lea    0x440(%rsp),%r13
   817af:	00 
   817b0:	49 89 c4             	mov    %rax,%r12
   817b3:	4d 01 fe             	add    %r15,%r14
   817b6:	bd 01 00 00 00       	mov    $0x1,%ebp
   817bb:	4d 39 e6             	cmp    %r12,%r14
   817be:	0f 85 1c 02 00 00    	jne    819e0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1540>
   817c4:	0f 28 94 24 e0 02 00 	movaps 0x2e0(%rsp),%xmm2
   817cb:	00 
   817cc:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
   817d1:	4c 8d b4 24 c0 05 00 	lea    0x5c0(%rsp),%r14
   817d8:	00 
   817d9:	48 8b 84 24 b0 01 00 	mov    0x1b0(%rsp),%rax
   817e0:	00 
   817e1:	48 3b 84 24 e8 01 00 	cmp    0x1e8(%rsp),%rax
   817e8:	00 
   817e9:	0f 84 9e 00 00 00    	je     8188d <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x13ed>
   817ef:	40 f6 c5 01          	test   $0x1,%bpl
   817f3:	0f 84 94 00 00 00    	je     8188d <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x13ed>
   817f9:	0f 29 94 24 c0 05 00 	movaps %xmm2,0x5c0(%rsp)
   81800:	00 
   81801:	0f 28 c2             	movaps %xmm2,%xmm0
   81804:	0f c6 c2 ff          	shufps $0xff,%xmm2,%xmm0
   81808:	0f 2e 05 25 f0 f9 ff 	ucomiss -0x60fdb(%rip),%xmm0        # 20834 <anon.716c7528f09896edfd633c06424fb6be.44.llvm.7987781668536310964+0x199>
   8180f:	0f 9b c0             	setnp  %al
   81812:	0f 94 c1             	sete   %cl
   81815:	20 c1                	and    %al,%cl
   81817:	0f b6 84 24 a8 01 00 	movzbl 0x1a8(%rsp),%eax
   8181e:	00 
   8181f:	f6 d0                	not    %al
   81821:	84 c8                	test   %cl,%al
   81823:	0f 85 55 12 00 00    	jne    82a7e <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x25de>
   81829:	48 8d bc 24 58 02 00 	lea    0x258(%rsp),%rdi
   81830:	00 
   81831:	4c 89 f6             	mov    %r14,%rsi
   81834:	ff 15 de 11 07 00    	call   *0x711de(%rip)        # f2a18 <_DYNAMIC+0xa10>
   8183a:	4c 8b 15 1f 0b 07 00 	mov    0x70b1f(%rip),%r10        # f2360 <memset@GLIBC_2.2.5>
   81841:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
   81848:	00 
   81849:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
   8184e:	89 c1                	mov    %eax,%ecx
   81850:	c1 e9 08             	shr    $0x8,%ecx
   81853:	89 c2                	mov    %eax,%edx
   81855:	c1 ea 10             	shr    $0x10,%edx
   81858:	4c 8b b4 24 80 00 00 	mov    0x80(%rsp),%r14
   8185f:	00 
   81860:	4c 8b ac 24 a8 00 00 	mov    0xa8(%rsp),%r13
   81867:	00 
   81868:	4c 8b a4 24 98 00 00 	mov    0x98(%rsp),%r12
   8186f:	00 
   81870:	48 8b ac 24 c0 00 00 	mov    0xc0(%rsp),%rbp
   81877:	00 
   81878:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
   8187d:	48 39 74 24 38       	cmp    %rsi,0x38(%rsp)
   81882:	0f 82 4f 13 00 00    	jb     82bd7 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2737>
   81888:	e9 66 15 00 00       	jmp    82df3 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2953>
   8188d:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
   81892:	48 39 44 24 38       	cmp    %rax,0x38(%rsp)
   81897:	0f 83 cc 11 00 00    	jae    82a69 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x25c9>
   8189d:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   818a2:	48 3b 44 24 30       	cmp    0x30(%rsp),%rax
   818a7:	0f 83 bc 11 00 00    	jae    82a69 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x25c9>
   818ad:	8b 84 24 58 03 00 00 	mov    0x358(%rsp),%eax
   818b4:	83 fd 01             	cmp    $0x1,%ebp
   818b7:	4c 8b ac 24 a8 00 00 	mov    0xa8(%rsp),%r13
   818be:	00 
   818bf:	0f 85 81 0d 00 00    	jne    82646 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x21a6>
   818c5:	e9 30 13 00 00       	jmp    82bfa <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x275a>
   818ca:	4c 8b bc 24 e8 01 00 	mov    0x1e8(%rsp),%r15
   818d1:	00 
   818d2:	49 f7 d7             	not    %r15
   818d5:	4c 03 bc 24 b0 01 00 	add    0x1b0(%rsp),%r15
   818dc:	00 
   818dd:	4c 89 a4 24 28 01 00 	mov    %r12,0x128(%rsp)
   818e4:	00 
   818e5:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
   818ea:	eb 32                	jmp    8191e <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x147e>
   818ec:	0f 1f 40 00          	nopl   0x0(%rax)
   818f0:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
   818f5:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
   818fa:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   818ff:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
   81906:	00 
   81907:	4c 8b 15 52 0a 07 00 	mov    0x70a52(%rip),%r10        # f2360 <memset@GLIBC_2.2.5>
   8190e:	49 ff cf             	dec    %r15
   81911:	49 83 c4 fc          	add    $0xfffffffffffffffc,%r12
   81915:	4d 39 e6             	cmp    %r12,%r14
   81918:	0f 84 92 00 00 00    	je     819b0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1510>
   8191e:	43 8b 7c 25 fc       	mov    -0x4(%r13,%r12,1),%edi
   81923:	48 8b b3 80 00 00 00 	mov    0x80(%rbx),%rsi
   8192a:	48 39 fe             	cmp    %rdi,%rsi
   8192d:	0f 86 c3 51 00 00    	jbe    86af6 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x6656>
   81933:	48 8b 43 78          	mov    0x78(%rbx),%rax
   81937:	8b 14 b8             	mov    (%rax,%rdi,4),%edx
   8193a:	48 8d bc 24 c0 05 00 	lea    0x5c0(%rsp),%rdi
   81941:	00 
   81942:	48 89 de             	mov    %rbx,%rsi
   81945:	e8 96 73 00 00       	call   88ce0 <<gpui_canvas::canvas::DisplayList>::get>
   8194a:	f3 0f 10 84 24 2c 06 	movss  0x62c(%rsp),%xmm0
   81951:	00 00 
   81953:	0f 2e 05 da ee f9 ff 	ucomiss -0x61126(%rip),%xmm0        # 20834 <anon.716c7528f09896edfd633c06424fb6be.44.llvm.7987781668536310964+0x199>
   8195a:	75 94                	jne    818f0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1450>
   8195c:	7a 92                	jp     818f0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1450>
   8195e:	83 bc 24 c0 05 00 00 	cmpl   $0x0,0x5c0(%rsp)
   81965:	00 
   81966:	75 88                	jne    818f0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1450>
   81968:	48 8d bc 24 c0 05 00 	lea    0x5c0(%rsp),%rdi
   8196f:	00 
   81970:	48 89 ee             	mov    %rbp,%rsi
   81973:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
   81978:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
   8197d:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
   81982:	ff 15 58 10 07 00    	call   *0x71058(%rip)        # f29e0 <_DYNAMIC+0x9d8>
   81988:	84 c0                	test   %al,%al
   8198a:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
   8198f:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
   81994:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   81999:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
   819a0:	00 
   819a1:	4c 8b 15 b8 09 07 00 	mov    0x709b8(%rip),%r10        # f2360 <memset@GLIBC_2.2.5>
   819a8:	0f 84 60 ff ff ff    	je     8190e <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x146e>
   819ae:	eb 03                	jmp    819b3 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1513>
   819b0:	45 31 ff             	xor    %r15d,%r15d
   819b3:	4c 8b a4 24 28 01 00 	mov    0x128(%rsp),%r12
   819ba:	00 
   819bb:	4c 01 bc 24 b0 03 00 	add    %r15,0x3b0(%rsp)
   819c2:	00 
   819c3:	49 c1 e7 02          	shl    $0x2,%r15
   819c7:	4c 8d ac 24 40 04 00 	lea    0x440(%rsp),%r13
   819ce:	00 
   819cf:	4d 01 fe             	add    %r15,%r14
   819d2:	bd 01 00 00 00       	mov    $0x1,%ebp
   819d7:	4d 39 e6             	cmp    %r12,%r14
   819da:	0f 84 e4 fd ff ff    	je     817c4 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1324>
   819e0:	48 8b 84 24 d0 02 00 	mov    0x2d0(%rsp),%rax
   819e7:	00 
   819e8:	48 8b 8c 24 e8 01 00 	mov    0x1e8(%rsp),%rcx
   819ef:	00 
   819f0:	4c 8d 1c 88          	lea    (%rax,%rcx,4),%r11
   819f4:	49 01 c4             	add    %rax,%r12
   819f7:	4d 01 fb             	add    %r15,%r11
   819fa:	48 8b 84 24 18 01 00 	mov    0x118(%rsp),%rax
   81a01:	00 
   81a02:	48 03 44 24 38       	add    0x38(%rsp),%rax
   81a07:	48 89 84 24 18 01 00 	mov    %rax,0x118(%rsp)
   81a0e:	00 
   81a0f:	0f 28 94 24 e0 02 00 	movaps 0x2e0(%rsp),%xmm2
   81a16:	00 
   81a17:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
   81a1c:	4c 89 a4 24 28 01 00 	mov    %r12,0x128(%rsp)
   81a23:	00 
   81a24:	0f 29 94 24 f0 02 00 	movaps %xmm2,0x2f0(%rsp)
   81a2b:	00 
   81a2c:	eb 32                	jmp    81a60 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x15c0>
   81a2e:	66 90                	xchg   %ax,%ax
   81a30:	31 ed                	xor    %ebp,%ebp
   81a32:	4c 8b a4 24 28 01 00 	mov    0x128(%rsp),%r12
   81a39:	00 
   81a3a:	4c 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%r11
   81a41:	00 
   81a42:	4d 39 e3             	cmp    %r12,%r11
   81a45:	4c 8b 7c 24 70       	mov    0x70(%rsp),%r15
   81a4a:	48 8b 9c 24 00 02 00 	mov    0x200(%rsp),%rbx
   81a51:	00 
   81a52:	4c 8d ac 24 40 04 00 	lea    0x440(%rsp),%r13
   81a59:	00 
   81a5a:	0f 84 88 0b 00 00    	je     825e8 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2148>
   81a60:	41 8b 3b             	mov    (%r11),%edi
   81a63:	48 8b b3 80 00 00 00 	mov    0x80(%rbx),%rsi
   81a6a:	48 39 fe             	cmp    %rdi,%rsi
   81a6d:	0f 86 b3 4f 00 00    	jbe    86a26 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x6586>
   81a73:	49 83 c3 04          	add    $0x4,%r11
   81a77:	4c 89 9c 24 b0 00 00 	mov    %r11,0xb0(%rsp)
   81a7e:	00 
   81a7f:	48 8b 43 78          	mov    0x78(%rbx),%rax
   81a83:	8b 14 b8             	mov    (%rax,%rdi,4),%edx
   81a86:	4c 89 ef             	mov    %r13,%rdi
   81a89:	48 89 de             	mov    %rbx,%rsi
   81a8c:	e8 4f 72 00 00       	call   88ce0 <<gpui_canvas::canvas::DisplayList>::get>
   81a91:	44 8b b4 24 40 04 00 	mov    0x440(%rsp),%r14d
   81a98:	00 
   81a99:	45 85 f6             	test   %r14d,%r14d
   81a9c:	0f 94 c0             	sete   %al
   81a9f:	84 44 24 0f          	test   %al,0xf(%rsp)
   81aa3:	74 7b                	je     81b20 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1680>
   81aa5:	4c 89 ef             	mov    %r13,%rdi
   81aa8:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
   81aad:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
   81ab2:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
   81ab7:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
   81abc:	ff 15 1e 0f 07 00    	call   *0x70f1e(%rip)        # f29e0 <_DYNAMIC+0x9d8>
   81ac2:	84 c0                	test   %al,%al
   81ac4:	0f 57 c9             	xorps  %xmm1,%xmm1
   81ac7:	4c 8d a4 24 d8 0d 00 	lea    0xdd8(%rsp),%r12
   81ace:	00 
   81acf:	0f 28 94 24 f0 02 00 	movaps 0x2f0(%rsp),%xmm2
   81ad6:	00 
   81ad7:	0f 84 43 01 00 00    	je     81c20 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1780>
   81add:	48 ff 84 24 a8 03 00 	incq   0x3a8(%rsp)
   81ae4:	00 
   81ae5:	40 f6 c5 01          	test   $0x1,%bpl
   81ae9:	0f 85 ad 0a 00 00    	jne    8259c <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x20fc>
   81aef:	66 c7 84 24 06 05 00 	movw   $0x0,0x506(%rsp)
   81af6:	00 00 00 
   81af9:	48 c7 84 24 d0 09 00 	movq   $0x0,0x9d0(%rsp)
   81b00:	00 00 00 00 00 
   81b05:	b1 01                	mov    $0x1,%cl
   81b07:	31 c0                	xor    %eax,%eax
   81b09:	0f 28 0d 40 a7 f9 ff 	movaps -0x658c0(%rip),%xmm1        # 1c250 <anon.3298d8a0178d409610dedcc629419ce8.4.llvm.4435257794685775273+0x190>
   81b10:	e9 e1 02 00 00       	jmp    81df6 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1956>
   81b15:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   81b1c:	00 00 00 00 
   81b20:	45 85 f6             	test   %r14d,%r14d
   81b23:	0f 57 c9             	xorps  %xmm1,%xmm1
   81b26:	4c 8d a4 24 d8 0d 00 	lea    0xdd8(%rsp),%r12
   81b2d:	00 
   81b2e:	0f 28 94 24 f0 02 00 	movaps 0x2f0(%rsp),%xmm2
   81b35:	00 
   81b36:	0f 84 e4 00 00 00    	je     81c20 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1780>
   81b3c:	66 c7 84 24 06 05 00 	movw   $0x0,0x506(%rsp)
   81b43:	00 00 00 
   81b46:	41 83 fe 02          	cmp    $0x2,%r14d
   81b4a:	0f 85 8a 01 00 00    	jne    81cda <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x183a>
   81b50:	f2 0f 10 84 24 78 04 	movsd  0x478(%rsp),%xmm0
   81b57:	00 00 
   81b59:	31 c0                	xor    %eax,%eax
   81b5b:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
   81b5f:	0f 85 77 01 00 00    	jne    81cdc <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x183c>
   81b65:	0f 8a 71 01 00 00    	jp     81cdc <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x183c>
   81b6b:	f2 0f 10 84 24 80 04 	movsd  0x480(%rsp),%xmm0
   81b72:	00 00 
   81b74:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
   81b78:	0f 85 5e 01 00 00    	jne    81cdc <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x183c>
   81b7e:	0f 8a 58 01 00 00    	jp     81cdc <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x183c>
   81b84:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   81b89:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
   81b90:	00 
   81b91:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   81b96:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
   81b9d:	00 
   81b9e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   81ba3:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
   81baa:	00 
   81bab:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
   81bb0:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
   81bb7:	00 
   81bb8:	4c 89 ee             	mov    %r13,%rsi
   81bbb:	4c 8d ac 24 c0 05 00 	lea    0x5c0(%rsp),%r13
   81bc2:	00 
   81bc3:	4c 89 ef             	mov    %r13,%rdi
   81bc6:	48 8d 94 24 30 01 00 	lea    0x130(%rsp),%rdx
   81bcd:	00 
   81bce:	48 8d 8c 24 90 03 00 	lea    0x390(%rsp),%rcx
   81bd5:	00 
   81bd6:	ff 15 44 0e 07 00    	call   *0x70e44(%rip)        # f2a20 <_DYNAMIC+0xa18>
   81bdc:	48 83 bc 24 c0 05 00 	cmpq   $0x0,0x5c0(%rsp)
   81be3:	00 00 
   81be5:	0f 84 ed 09 00 00    	je     825d8 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2138>
   81beb:	ba 08 04 00 00       	mov    $0x408,%edx
   81bf0:	48 8d bc 24 d0 09 00 	lea    0x9d0(%rsp),%rdi
   81bf7:	00 
   81bf8:	4c 89 ee             	mov    %r13,%rsi
   81bfb:	ff 15 cf 06 07 00    	call   *0x706cf(%rip)        # f22d0 <memcpy@GLIBC_2.14>
   81c01:	31 c0                	xor    %eax,%eax
   81c03:	4c 8d ac 24 40 04 00 	lea    0x440(%rsp),%r13
   81c0a:	00 
   81c0b:	0f 28 94 24 f0 02 00 	movaps 0x2f0(%rsp),%xmm2
   81c12:	00 
   81c13:	e9 d0 00 00 00       	jmp    81ce8 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1848>
   81c18:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   81c1f:	00 
   81c20:	f2 0f 10 84 24 78 04 	movsd  0x478(%rsp),%xmm0
   81c27:	00 00 
   81c29:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
   81c2d:	0f 85 8d 00 00 00    	jne    81cc0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1820>
   81c33:	0f 8a 87 00 00 00    	jp     81cc0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1820>
   81c39:	f2 0f 10 84 24 80 04 	movsd  0x480(%rsp),%xmm0
   81c40:	00 00 
   81c42:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
   81c46:	75 78                	jne    81cc0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1820>
   81c48:	7a 76                	jp     81cc0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1820>
   81c4a:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   81c4f:	48 89 84 24 c0 05 00 	mov    %rax,0x5c0(%rsp)
   81c56:	00 
   81c57:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   81c5c:	48 89 84 24 c8 05 00 	mov    %rax,0x5c8(%rsp)
   81c63:	00 
   81c64:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   81c69:	48 89 84 24 d0 05 00 	mov    %rax,0x5d0(%rsp)
   81c70:	00 
   81c71:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
   81c76:	48 89 84 24 d8 05 00 	mov    %rax,0x5d8(%rsp)
   81c7d:	00 
   81c7e:	48 8d bc 24 06 05 00 	lea    0x506(%rsp),%rdi
   81c85:	00 
   81c86:	4c 89 ee             	mov    %r13,%rsi
   81c89:	48 8d 94 24 c0 05 00 	lea    0x5c0(%rsp),%rdx
   81c90:	00 
   81c91:	48 8d 8c 24 90 03 00 	lea    0x390(%rsp),%rcx
   81c98:	00 
   81c99:	ff 15 49 0d 07 00    	call   *0x70d49(%rip)        # f29e8 <_DYNAMIC+0x9e0>
   81c9f:	66 83 bc 24 06 05 00 	cmpw   $0x1,0x506(%rsp)
   81ca6:	00 01 
   81ca8:	0f 85 20 09 00 00    	jne    825ce <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x212e>
   81cae:	b0 01                	mov    $0x1,%al
   81cb0:	0f 28 94 24 f0 02 00 	movaps 0x2f0(%rsp),%xmm2
   81cb7:	00 
   81cb8:	eb 22                	jmp    81cdc <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x183c>
   81cba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   81cc0:	66 c7 84 24 06 05 00 	movw   $0x0,0x506(%rsp)
   81cc7:	00 00 00 
   81cca:	48 c7 84 24 d0 09 00 	movq   $0x0,0x9d0(%rsp)
   81cd1:	00 00 00 00 00 
   81cd6:	31 c0                	xor    %eax,%eax
   81cd8:	eb 0e                	jmp    81ce8 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1848>
   81cda:	31 c0                	xor    %eax,%eax
   81cdc:	48 c7 84 24 d0 09 00 	movq   $0x0,0x9d0(%rsp)
   81ce3:	00 00 00 00 00 
   81ce8:	40 f6 c5 01          	test   $0x1,%bpl
   81cec:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
   81cf0:	0f 28 0d 59 a5 f9 ff 	movaps -0x65aa7(%rip),%xmm1        # 1c250 <anon.3298d8a0178d409610dedcc629419ce8.4.llvm.4435257794685775273+0x190>
   81cf7:	4c 8d 94 24 90 03 00 	lea    0x390(%rsp),%r10
   81cfe:	00 
   81cff:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
   81d04:	0f 84 d6 00 00 00    	je     81de0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1940>
   81d0a:	80 7c 24 0f 00       	cmpb   $0x0,0xf(%rsp)
   81d0f:	74 5e                	je     81d6f <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x18cf>
   81d11:	31 c9                	xor    %ecx,%ecx
   81d13:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   81d1a:	84 00 00 00 00 00 
   81d20:	0f 11 94 0c d8 0d 01 	movups %xmm2,0x10dd8(%rsp,%rcx,1)
   81d27:	00 
   81d28:	0f 11 94 0c e8 0d 01 	movups %xmm2,0x10de8(%rsp,%rcx,1)
   81d2f:	00 
   81d30:	0f 11 94 0c f8 0d 01 	movups %xmm2,0x10df8(%rsp,%rcx,1)
   81d37:	00 
   81d38:	0f 11 94 0c 08 0e 01 	movups %xmm2,0x10e08(%rsp,%rcx,1)
   81d3f:	00 
   81d40:	0f 11 94 0c 18 0e 01 	movups %xmm2,0x10e18(%rsp,%rcx,1)
   81d47:	00 
   81d48:	0f 11 94 0c 28 0e 01 	movups %xmm2,0x10e28(%rsp,%rcx,1)
   81d4f:	00 
   81d50:	0f 11 94 0c 38 0e 01 	movups %xmm2,0x10e38(%rsp,%rcx,1)
   81d57:	00 
   81d58:	0f 11 94 0c 48 0e 01 	movups %xmm2,0x10e48(%rsp,%rcx,1)
   81d5f:	00 
   81d60:	48 83 e9 80          	sub    $0xffffffffffffff80,%rcx
   81d64:	48 81 f9 00 10 00 00 	cmp    $0x1000,%rcx
   81d6b:	75 b3                	jne    81d20 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1880>
   81d6d:	eb 62                	jmp    81dd1 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1931>
   81d6f:	31 c9                	xor    %ecx,%ecx
   81d71:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   81d78:	0f 1f 84 00 00 00 00 
   81d7f:	00 
   81d80:	0f 11 94 0c d8 0d 00 	movups %xmm2,0xdd8(%rsp,%rcx,1)
   81d87:	00 
   81d88:	0f 11 94 0c e8 0d 00 	movups %xmm2,0xde8(%rsp,%rcx,1)
   81d8f:	00 
   81d90:	0f 11 94 0c f8 0d 00 	movups %xmm2,0xdf8(%rsp,%rcx,1)
   81d97:	00 
   81d98:	0f 11 94 0c 08 0e 00 	movups %xmm2,0xe08(%rsp,%rcx,1)
   81d9f:	00 
   81da0:	0f 11 94 0c 18 0e 00 	movups %xmm2,0xe18(%rsp,%rcx,1)
   81da7:	00 
   81da8:	0f 11 94 0c 28 0e 00 	movups %xmm2,0xe28(%rsp,%rcx,1)
   81daf:	00 
   81db0:	0f 11 94 0c 38 0e 00 	movups %xmm2,0xe38(%rsp,%rcx,1)
   81db7:	00 
   81db8:	0f 11 94 0c 48 0e 00 	movups %xmm2,0xe48(%rsp,%rcx,1)
   81dbf:	00 
   81dc0:	48 83 e9 80          	sub    $0xffffffffffffff80,%rcx
   81dc4:	48 81 f9 00 00 01 00 	cmp    $0x10000,%rcx
   81dcb:	75 b3                	jne    81d80 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x18e0>
   81dcd:	66 0f 76 c0          	pcmpeqd %xmm0,%xmm0
   81dd1:	48 8d 8c 24 d8 1d 01 	lea    0x11dd8(%rsp),%rcx
   81dd8:	00 
   81dd9:	0f 11 41 10          	movups %xmm0,0x10(%rcx)
   81ddd:	0f 11 01             	movups %xmm0,(%rcx)
   81de0:	41 83 fe 03          	cmp    $0x3,%r14d
   81de4:	0f 84 3c 06 00 00    	je     82426 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1f86>
   81dea:	41 83 fe 04          	cmp    $0x4,%r14d
   81dee:	0f 84 63 06 00 00    	je     82457 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1fb7>
   81df4:	31 c9                	xor    %ecx,%ecx
   81df6:	4c 8b bc 24 b8 04 00 	mov    0x4b8(%rsp),%r15
   81dfd:	00 
   81dfe:	48 8b b4 24 c8 04 00 	mov    0x4c8(%rsp),%rsi
   81e05:	00 
   81e06:	48 8b 5c 24 38       	mov    0x38(%rsp),%rbx
   81e0b:	49 39 df             	cmp    %rbx,%r15
   81e0e:	49 0f 47 df          	cmova  %r15,%rbx
   81e12:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
   81e17:	48 39 d6             	cmp    %rdx,%rsi
   81e1a:	48 0f 43 f2          	cmovae %rdx,%rsi
   81e1e:	48 89 74 24 48       	mov    %rsi,0x48(%rsp)
   81e23:	48 39 f3             	cmp    %rsi,%rbx
   81e26:	0f 83 04 fc ff ff    	jae    81a30 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1590>
   81e2c:	48 8b b4 24 b0 04 00 	mov    0x4b0(%rsp),%rsi
   81e33:	00 
   81e34:	4c 8b b4 24 c0 04 00 	mov    0x4c0(%rsp),%r14
   81e3b:	00 
   81e3c:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
   81e41:	48 39 d6             	cmp    %rdx,%rsi
   81e44:	48 0f 46 f2          	cmovbe %rdx,%rsi
   81e48:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
   81e4d:	49 39 d6             	cmp    %rdx,%r14
   81e50:	4c 0f 43 f2          	cmovae %rdx,%r14
   81e54:	48 89 74 24 60       	mov    %rsi,0x60(%rsp)
   81e59:	4c 39 f6             	cmp    %r14,%rsi
   81e5c:	0f 83 ce fb ff ff    	jae    81a30 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1590>
   81e62:	84 c9                	test   %cl,%cl
   81e64:	0f 84 b6 00 00 00    	je     81f20 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1a80>
   81e6a:	48 8b 84 24 b8 00 00 	mov    0xb8(%rsp),%rax
   81e71:	00 
   81e72:	49 39 c7             	cmp    %rax,%r15
   81e75:	4c 0f 46 f8          	cmovbe %rax,%r15
   81e79:	4c 03 bc 24 f8 01 00 	add    0x1f8(%rsp),%r15
   81e80:	00 
   81e81:	49 c1 e7 04          	shl    $0x4,%r15
   81e85:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   81e8c:	00 00 00 00 
   81e90:	48 89 9c 24 90 00 00 	mov    %rbx,0x90(%rsp)
   81e97:	00 
   81e98:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
   81e9d:	48 8d 9c 24 a0 04 00 	lea    0x4a0(%rsp),%rbx
   81ea4:	00 
   81ea5:	4c 8d ac 24 d8 0d 00 	lea    0xdd8(%rsp),%r13
   81eac:	00 
   81ead:	48 8d ac 24 70 02 00 	lea    0x270(%rsp),%rbp
   81eb4:	00 
   81eb5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   81ebc:	00 00 00 00 
   81ec0:	0f 29 8c 24 70 02 00 	movaps %xmm1,0x270(%rsp)
   81ec7:	00 
   81ec8:	0f 29 8c 24 80 02 00 	movaps %xmm1,0x280(%rsp)
   81ecf:	00 
   81ed0:	0f 29 8c 24 90 02 00 	movaps %xmm1,0x290(%rsp)
   81ed7:	00 
   81ed8:	0f 29 8c 24 a0 02 00 	movaps %xmm1,0x2a0(%rsp)
   81edf:	00 
   81ee0:	4b 8d 34 27          	lea    (%r15,%r12,1),%rsi
   81ee4:	49 ff c4             	inc    %r12
   81ee7:	4c 89 ef             	mov    %r13,%rdi
   81eea:	48 89 da             	mov    %rbx,%rdx
   81eed:	48 89 e9             	mov    %rbp,%rcx
   81ef0:	e8 4b 65 00 00       	call   88440 <<gpui_canvas::canvas::samples::Samples>::blend>
   81ef5:	0f 28 0d 54 a3 f9 ff 	movaps -0x65cac(%rip),%xmm1        # 1c250 <anon.3298d8a0178d409610dedcc629419ce8.4.llvm.4435257794685775273+0x190>
   81efc:	4d 39 f4             	cmp    %r14,%r12
   81eff:	72 bf                	jb     81ec0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1a20>
   81f01:	48 8b 9c 24 90 00 00 	mov    0x90(%rsp),%rbx
   81f08:	00 
   81f09:	48 ff c3             	inc    %rbx
   81f0c:	49 83 c7 10          	add    $0x10,%r15
   81f10:	48 3b 5c 24 48       	cmp    0x48(%rsp),%rbx
   81f15:	0f 85 75 ff ff ff    	jne    81e90 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x19f0>
   81f1b:	e9 10 fb ff ff       	jmp    81a30 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1590>
   81f20:	84 c0                	test   %al,%al
   81f22:	0f 84 d5 01 00 00    	je     820fd <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1c5d>
   81f28:	48 8b 84 24 b8 00 00 	mov    0xb8(%rsp),%rax
   81f2f:	00 
   81f30:	49 39 c7             	cmp    %rax,%r15
   81f33:	4c 0f 46 f8          	cmovbe %rax,%r15
   81f37:	4c 03 bc 24 f8 01 00 	add    0x1f8(%rsp),%r15
   81f3e:	00 
   81f3f:	49 c1 e7 04          	shl    $0x4,%r15
   81f43:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   81f4a:	84 00 00 00 00 00 
   81f50:	49 89 dc             	mov    %rbx,%r12
   81f53:	4c 2b 64 24 38       	sub    0x38(%rsp),%r12
   81f58:	49 83 fc 0f          	cmp    $0xf,%r12
   81f5c:	0f 87 90 4a 00 00    	ja     869f2 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x6552>
   81f62:	48 ff c3             	inc    %rbx
   81f65:	48 89 9c 24 90 00 00 	mov    %rbx,0x90(%rsp)
   81f6c:	00 
   81f6d:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
   81f72:	48 8d 9c 24 70 02 00 	lea    0x270(%rsp),%rbx
   81f79:	00 
   81f7a:	48 8b ac 24 b8 01 00 	mov    0x1b8(%rsp),%rbp
   81f81:	00 
   81f82:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   81f89:	1f 84 00 00 00 00 00 
   81f90:	48 ff 84 24 b8 03 00 	incq   0x3b8(%rsp)
   81f97:	00 
   81f98:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
   81f9d:	48 8d 3c 30          	lea    (%rax,%rsi,1),%rdi
   81fa1:	48 83 ff 0f          	cmp    $0xf,%rdi
   81fa5:	0f 87 39 4b 00 00    	ja     86ae4 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x6644>
   81fab:	0f b7 44 75 00       	movzwl 0x0(%rbp,%rsi,2),%eax
   81fb0:	69 c0 11 11 00 00    	imul   $0x1111,%eax,%eax
   81fb6:	66 42 23 84 64 28 05 	and    0x528(%rsp,%r12,2),%ax
   81fbd:	00 00 
   81fbf:	4c 8d 6e 01          	lea    0x1(%rsi),%r13
   81fc3:	0f b7 c0             	movzwl %ax,%eax
   81fc6:	89 c1                	mov    %eax,%ecx
   81fc8:	d1 e9                	shr    $1,%ecx
   81fca:	89 c2                	mov    %eax,%edx
   81fcc:	c1 ea 02             	shr    $0x2,%edx
   81fcf:	89 c7                	mov    %eax,%edi
   81fd1:	66 0f 6e c0          	movd   %eax,%xmm0
   81fd5:	66 0f c4 c1 01       	pinsrw $0x1,%ecx,%xmm0
   81fda:	66 0f c4 c2 02       	pinsrw $0x2,%edx,%xmm0
   81fdf:	c1 ef 03             	shr    $0x3,%edi
   81fe2:	66 0f c4 c7 03       	pinsrw $0x3,%edi,%xmm0
   81fe7:	66 0f 6f 25 61 9e f9 	movdqa -0x6619f(%rip),%xmm4        # 1be50 <anon.3298d8a0178d409610dedcc629419ce8.5.llvm.4435257794685775273+0x420>
   81fee:	ff 
   81fef:	66 0f db c4          	pand   %xmm4,%xmm0
   81ff3:	66 0f ef db          	pxor   %xmm3,%xmm3
   81ff7:	66 0f 61 c3          	punpcklwd %xmm3,%xmm0
   81ffb:	0f 5b c8             	cvtdq2ps %xmm0,%xmm1
   81ffe:	89 c1                	mov    %eax,%ecx
   82000:	c1 e9 0c             	shr    $0xc,%ecx
   82003:	89 c2                	mov    %eax,%edx
   82005:	c1 ea 0d             	shr    $0xd,%edx
   82008:	89 c7                	mov    %eax,%edi
   8200a:	c1 ef 0e             	shr    $0xe,%edi
   8200d:	41 89 c0             	mov    %eax,%r8d
   82010:	41 c1 e8 0f          	shr    $0xf,%r8d
   82014:	83 e7 01             	and    $0x1,%edi
   82017:	83 e2 01             	and    $0x1,%edx
   8201a:	83 e1 01             	and    $0x1,%ecx
   8201d:	66 0f 6e c1          	movd   %ecx,%xmm0
   82021:	66 0f c4 c2 01       	pinsrw $0x1,%edx,%xmm0
   82026:	66 0f c4 c7 02       	pinsrw $0x2,%edi,%xmm0
   8202b:	66 41 0f c4 c0 03    	pinsrw $0x3,%r8d,%xmm0
   82031:	66 0f 61 c3          	punpcklwd %xmm3,%xmm0
   82035:	0f 5b c0             	cvtdq2ps %xmm0,%xmm0
   82038:	0f 29 8c 24 70 02 00 	movaps %xmm1,0x270(%rsp)
   8203f:	00 
   82040:	89 c1                	mov    %eax,%ecx
   82042:	c1 e9 07             	shr    $0x7,%ecx
   82045:	89 c2                	mov    %eax,%edx
   82047:	c1 ea 06             	shr    $0x6,%edx
   8204a:	89 c7                	mov    %eax,%edi
   8204c:	c1 ef 05             	shr    $0x5,%edi
   8204f:	66 0f 6e c8          	movd   %eax,%xmm1
   82053:	66 0f 6f d1          	movdqa %xmm1,%xmm2
   82057:	66 0f 72 d2 04       	psrld  $0x4,%xmm2
   8205c:	66 0f c4 d7 01       	pinsrw $0x1,%edi,%xmm2
   82061:	66 0f c4 d2 02       	pinsrw $0x2,%edx,%xmm2
   82066:	66 0f c4 d1 03       	pinsrw $0x3,%ecx,%xmm2
   8206b:	66 0f db d4          	pand   %xmm4,%xmm2
   8206f:	66 0f 61 d3          	punpcklwd %xmm3,%xmm2
   82073:	0f 5b d2             	cvtdq2ps %xmm2,%xmm2
   82076:	0f 29 94 24 80 02 00 	movaps %xmm2,0x280(%rsp)
   8207d:	00 
   8207e:	89 c1                	mov    %eax,%ecx
   82080:	c1 e9 0b             	shr    $0xb,%ecx
   82083:	89 c2                	mov    %eax,%edx
   82085:	c1 ea 0a             	shr    $0xa,%edx
   82088:	c1 e8 09             	shr    $0x9,%eax
   8208b:	66 0f 72 d1 08       	psrld  $0x8,%xmm1
   82090:	66 0f c4 c8 01       	pinsrw $0x1,%eax,%xmm1
   82095:	66 0f c4 ca 02       	pinsrw $0x2,%edx,%xmm1
   8209a:	66 0f c4 c9 03       	pinsrw $0x3,%ecx,%xmm1
   8209f:	66 0f db cc          	pand   %xmm4,%xmm1
   820a3:	66 0f 61 cb          	punpcklwd %xmm3,%xmm1
   820a7:	0f 5b c9             	cvtdq2ps %xmm1,%xmm1
   820aa:	0f 29 8c 24 90 02 00 	movaps %xmm1,0x290(%rsp)
   820b1:	00 
   820b2:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
   820b9:	00 
   820ba:	4c 01 fe             	add    %r15,%rsi
   820bd:	48 8d bc 24 d8 0d 00 	lea    0xdd8(%rsp),%rdi
   820c4:	00 
   820c5:	48 8d 94 24 a0 04 00 	lea    0x4a0(%rsp),%rdx
   820cc:	00 
   820cd:	48 89 d9             	mov    %rbx,%rcx
   820d0:	e8 6b 63 00 00       	call   88440 <<gpui_canvas::canvas::samples::Samples>::blend>
   820d5:	4c 89 ee             	mov    %r13,%rsi
   820d8:	4d 39 f5             	cmp    %r14,%r13
   820db:	0f 82 af fe ff ff    	jb     81f90 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1af0>
   820e1:	49 83 c7 10          	add    $0x10,%r15
   820e5:	48 8b 9c 24 90 00 00 	mov    0x90(%rsp),%rbx
   820ec:	00 
   820ed:	48 3b 5c 24 48       	cmp    0x48(%rsp),%rbx
   820f2:	0f 85 58 fe ff ff    	jne    81f50 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1ab0>
   820f8:	e9 33 f9 ff ff       	jmp    81a30 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1590>
   820fd:	4c 8b ac 24 d0 09 00 	mov    0x9d0(%rsp),%r13
   82104:	00 
   82105:	4d 85 ed             	test   %r13,%r13
   82108:	0f 85 b5 00 00 00    	jne    821c3 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1d23>
   8210e:	48 8b 84 24 b8 00 00 	mov    0xb8(%rsp),%rax
   82115:	00 
   82116:	49 39 c7             	cmp    %rax,%r15
   82119:	4c 0f 46 f8          	cmovbe %rax,%r15
   8211d:	4c 03 bc 24 f8 01 00 	add    0x1f8(%rsp),%r15
   82124:	00 
   82125:	49 c1 e7 04          	shl    $0x4,%r15
   82129:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   82130:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
   82135:	48 8d ac 24 70 02 00 	lea    0x270(%rsp),%rbp
   8213c:	00 
   8213d:	0f 1f 00             	nopl   (%rax)
   82140:	4d 8d 6c 24 01       	lea    0x1(%r12),%r13
   82145:	48 ff 84 24 b8 03 00 	incq   0x3b8(%rsp)
   8214c:	00 
   8214d:	48 89 ef             	mov    %rbp,%rdi
   82150:	48 8d b4 24 40 04 00 	lea    0x440(%rsp),%rsi
   82157:	00 
   82158:	4c 89 e2             	mov    %r12,%rdx
   8215b:	48 89 d9             	mov    %rbx,%rcx
   8215e:	4c 8d 84 24 90 03 00 	lea    0x390(%rsp),%r8
   82165:	00 
   82166:	ff 15 84 08 07 00    	call   *0x70884(%rip)        # f29f0 <_DYNAMIC+0x9e8>
   8216c:	4d 01 fc             	add    %r15,%r12
   8216f:	48 8d bc 24 d8 0d 00 	lea    0xdd8(%rsp),%rdi
   82176:	00 
   82177:	4c 89 e6             	mov    %r12,%rsi
   8217a:	48 8d 94 24 a0 04 00 	lea    0x4a0(%rsp),%rdx
   82181:	00 
   82182:	48 89 e9             	mov    %rbp,%rcx
   82185:	e8 b6 62 00 00       	call   88440 <<gpui_canvas::canvas::samples::Samples>::blend>
   8218a:	4d 89 ec             	mov    %r13,%r12
   8218d:	4d 39 f5             	cmp    %r14,%r13
   82190:	72 ae                	jb     82140 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1ca0>
   82192:	48 ff c3             	inc    %rbx
   82195:	49 83 c7 10          	add    $0x10,%r15
   82199:	48 3b 5c 24 48       	cmp    0x48(%rsp),%rbx
   8219e:	75 90                	jne    82130 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1c90>
   821a0:	e9 8b f8 ff ff       	jmp    81a30 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1590>
   821a5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   821ac:	00 00 00 00 
   821b0:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
   821b5:	48 89 c3             	mov    %rax,%rbx
   821b8:	48 3b 44 24 48       	cmp    0x48(%rsp),%rax
   821bd:	0f 84 6d f8 ff ff    	je     81a30 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1590>
   821c3:	49 89 dc             	mov    %rbx,%r12
   821c6:	4c 2b 64 24 38       	sub    0x38(%rsp),%r12
   821cb:	49 83 fc 0f          	cmp    $0xf,%r12
   821cf:	0f 87 7b 48 00 00    	ja     86a50 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x65b0>
   821d5:	48 8d 43 01          	lea    0x1(%rbx),%rax
   821d9:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
   821de:	49 c1 e4 05          	shl    $0x5,%r12
   821e2:	48 8d 84 24 d8 0b 00 	lea    0xbd8(%rsp),%rax
   821e9:	00 
   821ea:	49 01 c4             	add    %rax,%r12
   821ed:	48 2b 9c 24 18 01 00 	sub    0x118(%rsp),%rbx
   821f4:	00 
   821f5:	48 c1 e3 04          	shl    $0x4,%rbx
   821f9:	48 89 9c 24 90 00 00 	mov    %rbx,0x90(%rsp)
   82200:	00 
   82201:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
   82206:	48 8d 9c 24 70 02 00 	lea    0x270(%rsp),%rbx
   8220d:	00 
   8220e:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
   82213:	e9 7d 00 00 00       	jmp    82295 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1df5>
   82218:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   8221f:	00 
   82220:	0f 10 84 24 c0 05 00 	movups 0x5c0(%rsp),%xmm0
   82227:	00 
   82228:	0f 10 8c 24 d0 05 00 	movups 0x5d0(%rsp),%xmm1
   8222f:	00 
   82230:	0f 10 94 24 e0 05 00 	movups 0x5e0(%rsp),%xmm2
   82237:	00 
   82238:	f3 0f 6f 9c 24 f0 05 	movdqu 0x5f0(%rsp),%xmm3
   8223f:	00 00 
   82241:	66 0f 7f 9c 24 a0 02 	movdqa %xmm3,0x2a0(%rsp)
   82248:	00 00 
   8224a:	0f 29 94 24 90 02 00 	movaps %xmm2,0x290(%rsp)
   82251:	00 
   82252:	0f 29 8c 24 80 02 00 	movaps %xmm1,0x280(%rsp)
   82259:	00 
   8225a:	0f 29 84 24 70 02 00 	movaps %xmm0,0x270(%rsp)
   82261:	00 
   82262:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
   82269:	00 
   8226a:	4c 8d 7e 01          	lea    0x1(%rsi),%r15
   8226e:	48 01 c6             	add    %rax,%rsi
   82271:	48 8d bc 24 d8 0d 00 	lea    0xdd8(%rsp),%rdi
   82278:	00 
   82279:	48 8d 94 24 a0 04 00 	lea    0x4a0(%rsp),%rdx
   82280:	00 
   82281:	48 89 d9             	mov    %rbx,%rcx
   82284:	e8 b7 61 00 00       	call   88440 <<gpui_canvas::canvas::samples::Samples>::blend>
   82289:	4c 89 fe             	mov    %r15,%rsi
   8228c:	4d 39 f7             	cmp    %r14,%r15
   8228f:	0f 83 1b ff ff ff    	jae    821b0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1d10>
   82295:	48 ff 84 24 b8 03 00 	incq   0x3b8(%rsp)
   8229c:	00 
   8229d:	48 89 f7             	mov    %rsi,%rdi
   822a0:	48 29 ef             	sub    %rbp,%rdi
   822a3:	48 83 ff 0f          	cmp    $0xf,%rdi
   822a7:	0f 87 b6 48 00 00    	ja     86b63 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x66c3>
   822ad:	48 c1 e7 05          	shl    $0x5,%rdi
   822b1:	48 8d 84 24 d8 09 00 	lea    0x9d8(%rsp),%rax
   822b8:	00 
   822b9:	0f 10 04 38          	movups (%rax,%rdi,1),%xmm0
   822bd:	0f 10 4c 38 10       	movups 0x10(%rax,%rdi,1),%xmm1
   822c2:	0f 29 8c 24 70 03 00 	movaps %xmm1,0x370(%rsp)
   822c9:	00 
   822ca:	0f 29 84 24 60 03 00 	movaps %xmm0,0x360(%rsp)
   822d1:	00 
   822d2:	41 0f 10 04 24       	movups (%r12),%xmm0
   822d7:	41 0f 10 4c 24 10    	movups 0x10(%r12),%xmm1
   822dd:	0f 29 8c 24 40 01 00 	movaps %xmm1,0x140(%rsp)
   822e4:	00 
   822e5:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
   822ec:	00 
   822ed:	48 8b 84 24 60 03 00 	mov    0x360(%rsp),%rax
   822f4:	00 
   822f5:	48 39 84 24 68 03 00 	cmp    %rax,0x368(%rsp)
   822fc:	00 
   822fd:	0f 85 ad 00 00 00    	jne    823b0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1f10>
   82303:	48 39 84 24 70 03 00 	cmp    %rax,0x370(%rsp)
   8230a:	00 
   8230b:	0f 85 9f 00 00 00    	jne    823b0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1f10>
   82311:	48 39 84 24 78 03 00 	cmp    %rax,0x378(%rsp)
   82318:	00 
   82319:	0f 85 91 00 00 00    	jne    823b0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1f10>
   8231f:	48 8b bc 24 30 01 00 	mov    0x130(%rsp),%rdi
   82326:	00 
   82327:	48 39 bc 24 38 01 00 	cmp    %rdi,0x138(%rsp)
   8232e:	00 
   8232f:	75 7f                	jne    823b0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1f10>
   82331:	48 39 bc 24 40 01 00 	cmp    %rdi,0x140(%rsp)
   82338:	00 
   82339:	75 75                	jne    823b0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1f10>
   8233b:	48 39 bc 24 48 01 00 	cmp    %rdi,0x148(%rsp)
   82342:	00 
   82343:	75 6b                	jne    823b0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1f10>
   82345:	0f 57 c0             	xorps  %xmm0,%xmm0
   82348:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
   8234c:	f3 0f 10 0d ec e6 f9 	movss  -0x61914(%rip),%xmm1        # 20a40 <anon.716c7528f09896edfd633c06424fb6be.44.llvm.7987781668536310964+0x3a5>
   82353:	ff 
   82354:	74 29                	je     8237f <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1edf>
   82356:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
   8235a:	74 23                	je     8237f <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1edf>
   8235c:	48 01 c7             	add    %rax,%rdi
   8235f:	49 8b 45 10          	mov    0x10(%r13),%rax
   82363:	48 39 c7             	cmp    %rax,%rdi
   82366:	0f 83 61 44 00 00    	jae    867cd <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x632d>
   8236c:	49 8b 45 08          	mov    0x8(%r13),%rax
   82370:	0f b6 04 38          	movzbl (%rax,%rdi,1),%eax
   82374:	0f 57 c0             	xorps  %xmm0,%xmm0
   82377:	f3 0f 2a c0          	cvtsi2ss %eax,%xmm0
   8237b:	f3 0f 5e c1          	divss  %xmm1,%xmm0
   8237f:	0f c6 c0 00          	shufps $0x0,%xmm0,%xmm0
   82383:	0f 29 84 24 70 02 00 	movaps %xmm0,0x270(%rsp)
   8238a:	00 
   8238b:	0f 29 84 24 80 02 00 	movaps %xmm0,0x280(%rsp)
   82392:	00 
   82393:	0f 29 84 24 90 02 00 	movaps %xmm0,0x290(%rsp)
   8239a:	00 
   8239b:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
   823a2:	00 
   823a3:	e9 ba fe ff ff       	jmp    82262 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1dc2>
   823a8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   823af:	00 
   823b0:	31 c9                	xor    %ecx,%ecx
   823b2:	f3 0f 10 0d 86 e6 f9 	movss  -0x6197a(%rip),%xmm1        # 20a40 <anon.716c7528f09896edfd633c06424fb6be.44.llvm.7987781668536310964+0x3a5>
   823b9:	ff 
   823ba:	eb 1a                	jmp    823d6 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1f36>
   823bc:	0f 1f 40 00          	nopl   0x0(%rax)
   823c0:	f3 0f 11 84 8c c0 05 	movss  %xmm0,0x5c0(%rsp,%rcx,4)
   823c7:	00 00 
   823c9:	48 ff c1             	inc    %rcx
   823cc:	48 83 f9 10          	cmp    $0x10,%rcx
   823d0:	0f 84 4a fe ff ff    	je     82220 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1d80>
   823d6:	89 c8                	mov    %ecx,%eax
   823d8:	83 e0 03             	and    $0x3,%eax
   823db:	48 8b 84 c4 60 03 00 	mov    0x360(%rsp,%rax,8),%rax
   823e2:	00 
   823e3:	0f 57 c0             	xorps  %xmm0,%xmm0
   823e6:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
   823ea:	74 d4                	je     823c0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1f20>
   823ec:	48 89 ca             	mov    %rcx,%rdx
   823ef:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
   823f3:	48 8b bc 54 30 01 00 	mov    0x130(%rsp,%rdx,2),%rdi
   823fa:	00 
   823fb:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
   823ff:	74 bf                	je     823c0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1f20>
   82401:	48 01 c7             	add    %rax,%rdi
   82404:	49 8b 45 10          	mov    0x10(%r13),%rax
   82408:	48 39 c7             	cmp    %rax,%rdi
   8240b:	0f 83 bc 43 00 00    	jae    867cd <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x632d>
   82411:	49 8b 45 08          	mov    0x8(%r13),%rax
   82415:	0f b6 04 38          	movzbl (%rax,%rdi,1),%eax
   82419:	0f 57 c0             	xorps  %xmm0,%xmm0
   8241c:	f3 0f 2a c0          	cvtsi2ss %eax,%xmm0
   82420:	f3 0f 5e c1          	divss  %xmm1,%xmm0
   82424:	eb 9a                	jmp    823c0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1f20>
   82426:	48 8b 84 24 48 04 00 	mov    0x448(%rsp),%rax
   8242d:	00 
   8242e:	48 8b 08             	mov    (%rax),%rcx
   82431:	48 8b 41 28          	mov    0x28(%rcx),%rax
   82435:	f2 0f 10 41 30       	movsd  0x30(%rcx),%xmm0
   8243a:	80 79 10 00          	cmpb   $0x0,0x10(%rcx)
   8243e:	74 50                	je     82490 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1ff0>
   82440:	41 b0 01             	mov    $0x1,%r8b
   82443:	31 d2                	xor    %edx,%edx
   82445:	0f b6 b4 24 10 03 00 	movzbl 0x310(%rsp),%esi
   8244c:	00 
   8244d:	0f b6 bc 24 08 03 00 	movzbl 0x308(%rsp),%edi
   82454:	00 
   82455:	eb 56                	jmp    824ad <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x200d>
   82457:	48 8b 84 24 48 04 00 	mov    0x448(%rsp),%rax
   8245e:	00 
   8245f:	48 8b 08             	mov    (%rax),%rcx
   82462:	48 8b 41 28          	mov    0x28(%rcx),%rax
   82466:	f2 0f 10 41 30       	movsd  0x30(%rcx),%xmm0
   8246b:	b2 01                	mov    $0x1,%dl
   8246d:	80 79 10 00          	cmpb   $0x0,0x10(%rcx)
   82471:	4c 8d b4 24 c0 05 00 	lea    0x5c0(%rsp),%r14
   82478:	00 
   82479:	74 3c                	je     824b7 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2017>
   8247b:	0f b6 b4 24 18 03 00 	movzbl 0x318(%rsp),%esi
   82482:	00 
   82483:	0f b6 bc 24 d0 04 00 	movzbl 0x4d0(%rsp),%edi
   8248a:	00 
   8248b:	41 b0 01             	mov    $0x1,%r8b
   8248e:	eb 44                	jmp    824d4 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2034>
   82490:	0f b6 71 11          	movzbl 0x11(%rcx),%esi
   82494:	0f b6 79 12          	movzbl 0x12(%rcx),%edi
   82498:	31 d2                	xor    %edx,%edx
   8249a:	40 88 b4 24 10 03 00 	mov    %sil,0x310(%rsp)
   824a1:	00 
   824a2:	45 31 c0             	xor    %r8d,%r8d
   824a5:	40 88 bc 24 08 03 00 	mov    %dil,0x308(%rsp)
   824ac:	00 
   824ad:	4c 8d b4 24 c0 05 00 	lea    0x5c0(%rsp),%r14
   824b4:	00 
   824b5:	eb 1d                	jmp    824d4 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2034>
   824b7:	0f b6 71 11          	movzbl 0x11(%rcx),%esi
   824bb:	0f b6 79 12          	movzbl 0x12(%rcx),%edi
   824bf:	b2 01                	mov    $0x1,%dl
   824c1:	45 31 c0             	xor    %r8d,%r8d
   824c4:	40 88 b4 24 18 03 00 	mov    %sil,0x318(%rsp)
   824cb:	00 
   824cc:	40 88 bc 24 d0 04 00 	mov    %dil,0x4d0(%rsp)
   824d3:	00 
   824d4:	0f 10 49 18          	movups 0x18(%rcx),%xmm1
   824d8:	44 88 84 24 c0 05 00 	mov    %r8b,0x5c0(%rsp)
   824df:	00 
   824e0:	40 88 b4 24 c1 05 00 	mov    %sil,0x5c1(%rsp)
   824e7:	00 
   824e8:	40 88 bc 24 c2 05 00 	mov    %dil,0x5c2(%rsp)
   824ef:	00 
   824f0:	0f 11 8c 24 c8 05 00 	movups %xmm1,0x5c8(%rsp)
   824f7:	00 
   824f8:	48 89 84 24 d8 05 00 	mov    %rax,0x5d8(%rsp)
   824ff:	00 
   82500:	66 0f 13 84 24 e0 05 	movlpd %xmm0,0x5e0(%rsp)
   82507:	00 00 
   82509:	4c 89 8c 24 30 01 00 	mov    %r9,0x130(%rsp)
   82510:	00 
   82511:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   82516:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
   8251d:	00 
   8251e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   82523:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
   8252a:	00 
   8252b:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
   82530:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
   82537:	00 
   82538:	44 0f b6 ca          	movzbl %dl,%r9d
   8253c:	4c 89 e7             	mov    %r12,%rdi
   8253f:	4c 89 ee             	mov    %r13,%rsi
   82542:	48 8d 94 24 30 01 00 	lea    0x130(%rsp),%rdx
   82549:	00 
   8254a:	4c 89 d1             	mov    %r10,%rcx
   8254d:	4d 89 f0             	mov    %r14,%r8
   82550:	ff 15 a2 04 07 00    	call   *0x704a2(%rip)        # f29f8 <_DYNAMIC+0x9f0>
   82556:	31 ed                	xor    %ebp,%ebp
   82558:	0f 28 94 24 f0 02 00 	movaps 0x2f0(%rsp),%xmm2
   8255f:	00 
   82560:	4c 8b a4 24 28 01 00 	mov    0x128(%rsp),%r12
   82567:	00 
   82568:	4c 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%r11
   8256f:	00 
   82570:	4d 39 e3             	cmp    %r12,%r11
   82573:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
   82578:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
   8257d:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   82582:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
   82589:	00 
   8258a:	4c 8b 15 cf fd 06 00 	mov    0x6fdcf(%rip),%r10        # f2360 <memset@GLIBC_2.2.5>
   82591:	0f 85 8d f4 ff ff    	jne    81a24 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1584>
   82597:	e9 3d f2 ff ff       	jmp    817d9 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x1339>
   8259c:	0f 10 84 24 a0 04 00 	movups 0x4a0(%rsp),%xmm0
   825a3:	00 
   825a4:	f3 0f 10 0d 88 e2 f9 	movss  -0x61d78(%rip),%xmm1        # 20834 <anon.716c7528f09896edfd633c06424fb6be.44.llvm.7987781668536310964+0x199>
   825ab:	ff 
   825ac:	f3 0f 5c 8c 24 ac 04 	subss  0x4ac(%rsp),%xmm1
   825b3:	00 00 
   825b5:	0f c6 c9 00          	shufps $0x0,%xmm1,%xmm1
   825b9:	0f 59 d1             	mulps  %xmm1,%xmm2
   825bc:	0f 58 d0             	addps  %xmm0,%xmm2
   825bf:	bd 01 00 00 00       	mov    $0x1,%ebp
   825c4:	4c 8d b4 24 c0 05 00 	lea    0x5c0(%rsp),%r14
   825cb:	00 
   825cc:	eb 92                	jmp    82560 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x20c0>
   825ce:	4c 8d b4 24 c0 05 00 	lea    0x5c0(%rsp),%r14
   825d5:	00 
   825d6:	eb 80                	jmp    82558 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x20b8>
   825d8:	4d 89 ee             	mov    %r13,%r14
   825db:	4c 8d ac 24 40 04 00 	lea    0x440(%rsp),%r13
   825e2:	00 
   825e3:	e9 70 ff ff ff       	jmp    82558 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x20b8>
   825e8:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
   825ed:	48 39 44 24 38       	cmp    %rax,0x38(%rsp)
   825f2:	0f 83 17 05 00 00    	jae    82b0f <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x266f>
   825f8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   825fd:	48 3b 44 24 30       	cmp    0x30(%rsp),%rax
   82602:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
   82607:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
   8260c:	4c 8b b4 24 80 00 00 	mov    0x80(%rsp),%r14
   82613:	00 
   82614:	4c 8b ac 24 a8 00 00 	mov    0xa8(%rsp),%r13
   8261b:	00 
   8261c:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   82621:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
   82628:	00 
   82629:	4c 8b 15 30 fd 06 00 	mov    0x6fd30(%rip),%r10        # f2360 <memset@GLIBC_2.2.5>
   82630:	4c 8b a4 24 98 00 00 	mov    0x98(%rsp),%r12
   82637:	00 
   82638:	48 8b ac 24 c0 00 00 	mov    0xc0(%rsp),%rbp
   8263f:	00 
   82640:	0f 83 e5 ef ff ff    	jae    8162b <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x118b>
   82646:	80 bc 24 a8 01 00 00 	cmpb   $0x0,0x1a8(%rsp)
   8264d:	00 
   8264e:	0f 84 67 01 00 00    	je     827bb <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x231b>
   82654:	48 8b 84 24 98 01 00 	mov    0x198(%rsp),%rax
   8265b:	00 
   8265c:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
   82663:	00 
   82664:	4c 8b 7c 24 58       	mov    0x58(%rsp),%r15
   82669:	45 31 e4             	xor    %r12d,%r12d
   8266c:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   82671:	eb 44                	jmp    826b7 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2217>
   82673:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   8267a:	84 00 00 00 00 00 
   82680:	49 83 c4 10          	add    $0x10,%r12
   82684:	4c 8b ac 24 a8 00 00 	mov    0xa8(%rsp),%r13
   8268b:	00 
   8268c:	4d 01 ef             	add    %r13,%r15
   8268f:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
   82696:	00 
   82697:	48 03 84 24 a0 00 00 	add    0xa0(%rsp),%rax
   8269e:	00 
   8269f:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
   826a6:	00 
   826a7:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   826ac:	48 3b 44 24 28       	cmp    0x28(%rsp),%rax
   826b1:	0f 84 57 ef ff ff    	je     8160e <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x116e>
   826b7:	48 ff c0             	inc    %rax
   826ba:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
   826bf:	45 31 ed             	xor    %r13d,%r13d
   826c2:	eb 56                	jmp    8271a <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x227a>
   826c4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   826cb:	00 00 00 00 00 
   826d0:	8b 84 24 d8 00 00 00 	mov    0xd8(%rsp),%eax
   826d7:	48 8b 8c 24 90 00 00 	mov    0x90(%rsp),%rcx
   826de:	00 
   826df:	42 89 04 a9          	mov    %eax,(%rcx,%r13,4)
   826e3:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
   826e8:	4c 01 e8             	add    %r13,%rax
   826eb:	48 ff c0             	inc    %rax
   826ee:	49 ff c5             	inc    %r13
   826f1:	48 3b 44 24 30       	cmp    0x30(%rsp),%rax
   826f6:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
   826fb:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
   82700:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   82705:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
   8270c:	00 
   8270d:	4c 8b 15 4c fc 06 00 	mov    0x6fc4c(%rip),%r10        # f2360 <memset@GLIBC_2.2.5>
   82714:	0f 83 66 ff ff ff    	jae    82680 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x21e0>
   8271a:	4b 8d 2c 2f          	lea    (%r15,%r13,1),%rbp
   8271e:	48 3b 6c 24 40       	cmp    0x40(%rsp),%rbp
   82723:	0f 83 aa 07 00 00    	jae    82ed3 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2a33>
   82729:	4b 8d 14 2c          	lea    (%r12,%r13,1),%rdx
   8272d:	48 8d bc 24 80 01 00 	lea    0x180(%rsp),%rdi
   82734:	00 
   82735:	48 8d b4 24 d8 0d 00 	lea    0xdd8(%rsp),%rsi
   8273c:	00 
   8273d:	e8 de 63 00 00       	call   88b20 <<gpui_canvas::canvas::samples::Samples>::color>
   82742:	48 8b ac 24 80 01 00 	mov    0x180(%rsp),%rbp
   82749:	00 
   8274a:	4c 8b b4 24 88 01 00 	mov    0x188(%rsp),%r14
   82751:	00 
   82752:	4c 89 f0             	mov    %r14,%rax
   82755:	48 33 84 24 d0 00 00 	xor    0xd0(%rsp),%rax
   8275c:	00 
   8275d:	48 89 e9             	mov    %rbp,%rcx
   82760:	48 33 8c 24 e8 00 00 	xor    0xe8(%rsp),%rcx
   82767:	00 
   82768:	48 09 c1             	or     %rax,%rcx
   8276b:	0f 84 5f ff ff ff    	je     826d0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2230>
   82771:	48 8d bc 24 58 02 00 	lea    0x258(%rsp),%rdi
   82778:	00 
   82779:	48 8d b4 24 80 01 00 	lea    0x180(%rsp),%rsi
   82780:	00 
   82781:	ff 15 91 02 07 00    	call   *0x70291(%rip)        # f2a18 <_DYNAMIC+0xa10>
   82787:	89 c1                	mov    %eax,%ecx
   82789:	0f b6 d0             	movzbl %al,%edx
   8278c:	c1 e8 10             	shr    $0x10,%eax
   8278f:	0f b6 c0             	movzbl %al,%eax
   82792:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
   82798:	c1 e2 10             	shl    $0x10,%edx
   8279b:	09 ca                	or     %ecx,%edx
   8279d:	09 c2                	or     %eax,%edx
   8279f:	89 94 24 d8 00 00 00 	mov    %edx,0xd8(%rsp)
   827a6:	48 89 ac 24 e8 00 00 	mov    %rbp,0xe8(%rsp)
   827ad:	00 
   827ae:	4c 89 b4 24 d0 00 00 	mov    %r14,0xd0(%rsp)
   827b5:	00 
   827b6:	e9 15 ff ff ff       	jmp    826d0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2230>
   827bb:	4c 8b bc 24 98 01 00 	mov    0x198(%rsp),%r15
   827c2:	00 
   827c3:	48 8b 6c 24 58       	mov    0x58(%rsp),%rbp
   827c8:	45 31 e4             	xor    %r12d,%r12d
   827cb:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   827d0:	eb 47                	jmp    82819 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2379>
   827d2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   827d9:	1f 84 00 00 00 00 00 
   827e0:	4c 8b 64 24 68       	mov    0x68(%rsp),%r12
   827e5:	49 83 c4 10          	add    $0x10,%r12
   827e9:	4c 8b ac 24 a8 00 00 	mov    0xa8(%rsp),%r13
   827f0:	00 
   827f1:	48 8b 6c 24 60       	mov    0x60(%rsp),%rbp
   827f6:	4c 01 ed             	add    %r13,%rbp
   827f9:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
   827fe:	4c 03 bc 24 a0 00 00 	add    0xa0(%rsp),%r15
   82805:	00 
   82806:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
   8280d:	00 
   8280e:	48 3b 44 24 28       	cmp    0x28(%rsp),%rax
   82813:	0f 84 f5 ed ff ff    	je     8160e <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x116e>
   82819:	48 ff c0             	inc    %rax
   8281c:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
   82823:	00 
   82824:	4c 89 7c 24 48       	mov    %r15,0x48(%rsp)
   82829:	48 89 6c 24 60       	mov    %rbp,0x60(%rsp)
   8282e:	4c 89 64 24 68       	mov    %r12,0x68(%rsp)
   82833:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
   82838:	e9 9d 00 00 00       	jmp    828da <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x243a>
   8283d:	0f 1f 00             	nopl   (%rax)
   82840:	48 89 bc 24 90 00 00 	mov    %rdi,0x90(%rsp)
   82847:	00 
   82848:	48 8d bc 24 58 02 00 	lea    0x258(%rsp),%rdi
   8284f:	00 
   82850:	48 8d b4 24 80 01 00 	lea    0x180(%rsp),%rsi
   82857:	00 
   82858:	ff 15 ba 01 07 00    	call   *0x701ba(%rip)        # f2a18 <_DYNAMIC+0xa10>
   8285e:	48 8b bc 24 90 00 00 	mov    0x90(%rsp),%rdi
   82865:	00 
   82866:	4c 8b 15 f3 fa 06 00 	mov    0x6faf3(%rip),%r10        # f2360 <memset@GLIBC_2.2.5>
   8286d:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
   82874:	00 
   82875:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
   8287a:	89 c2                	mov    %eax,%edx
   8287c:	c1 ea 08             	shr    $0x8,%edx
   8287f:	89 c1                	mov    %eax,%ecx
   82881:	c1 e9 10             	shr    $0x10,%ecx
   82884:	0f b6 c9             	movzbl %cl,%ecx
   82887:	0f b6 d2             	movzbl %dl,%edx
   8288a:	c1 e2 08             	shl    $0x8,%edx
   8288d:	0f b6 c0             	movzbl %al,%eax
   82890:	c1 e0 10             	shl    $0x10,%eax
   82893:	09 d0                	or     %edx,%eax
   82895:	09 c8                	or     %ecx,%eax
   82897:	89 84 24 d8 00 00 00 	mov    %eax,0xd8(%rsp)
   8289e:	4c 89 ac 24 e8 00 00 	mov    %r13,0xe8(%rsp)
   828a5:	00 
   828a6:	48 89 bc 24 d0 00 00 	mov    %rdi,0xd0(%rsp)
   828ad:	00 
   828ae:	49 ff c6             	inc    %r14
   828b1:	8b 84 24 d8 00 00 00 	mov    0xd8(%rsp),%eax
   828b8:	41 89 07             	mov    %eax,(%r15)
   828bb:	49 ff c4             	inc    %r12
   828be:	48 ff c5             	inc    %rbp
   828c1:	49 83 c7 04          	add    $0x4,%r15
   828c5:	4c 3b 74 24 30       	cmp    0x30(%rsp),%r14
   828ca:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
   828cf:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   828d4:	0f 83 06 ff ff ff    	jae    827e0 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2340>
   828da:	48 3b 6c 24 40       	cmp    0x40(%rsp),%rbp
   828df:	0f 83 ee 05 00 00    	jae    82ed3 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2a33>
   828e5:	48 8d bc 24 80 01 00 	lea    0x180(%rsp),%rdi
   828ec:	00 
   828ed:	48 8d b4 24 d8 0d 00 	lea    0xdd8(%rsp),%rsi
   828f4:	00 
   828f5:	4c 89 e2             	mov    %r12,%rdx
   828f8:	e8 23 62 00 00       	call   88b20 <<gpui_canvas::canvas::samples::Samples>::color>
   828fd:	4c 8b 15 5c fa 06 00 	mov    0x6fa5c(%rip),%r10        # f2360 <memset@GLIBC_2.2.5>
   82904:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
   8290b:	00 
   8290c:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
   82911:	8b 94 24 80 01 00 00 	mov    0x180(%rsp),%edx
   82918:	8b 8c 24 84 01 00 00 	mov    0x184(%rsp),%ecx
   8291f:	48 8b bc 24 88 01 00 	mov    0x188(%rsp),%rdi
   82926:	00 
   82927:	49 89 cd             	mov    %rcx,%r13
   8292a:	49 c1 e5 20          	shl    $0x20,%r13
   8292e:	49 09 d5             	or     %rdx,%r13
   82931:	48 89 f8             	mov    %rdi,%rax
   82934:	48 33 84 24 d0 00 00 	xor    0xd0(%rsp),%rax
   8293b:	00 
   8293c:	4c 89 ee             	mov    %r13,%rsi
   8293f:	48 33 b4 24 e8 00 00 	xor    0xe8(%rsp),%rsi
   82946:	00 
   82947:	48 09 c6             	or     %rax,%rsi
   8294a:	0f 84 5e ff ff ff    	je     828ae <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x240e>
   82950:	48 89 f8             	mov    %rdi,%rax
   82953:	48 c1 e8 20          	shr    $0x20,%rax
   82957:	66 0f 6e c0          	movd   %eax,%xmm0
   8295b:	0f 2e 05 d2 de f9 ff 	ucomiss -0x6212e(%rip),%xmm0        # 20834 <anon.716c7528f09896edfd633c06424fb6be.44.llvm.7987781668536310964+0x199>
   82962:	0f 85 d8 fe ff ff    	jne    82840 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x23a0>
   82968:	0f 8a d2 fe ff ff    	jp     82840 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x23a0>
   8296e:	66 0f 6e c2          	movd   %edx,%xmm0
   82972:	0f 57 c9             	xorps  %xmm1,%xmm1
   82975:	0f 2e c8             	ucomiss %xmm0,%xmm1
   82978:	73 28                	jae    829a2 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2502>
   8297a:	b0 ff                	mov    $0xff,%al
   8297c:	0f 2e 05 b1 de f9 ff 	ucomiss -0x6214f(%rip),%xmm0        # 20834 <anon.716c7528f09896edfd633c06424fb6be.44.llvm.7987781668536310964+0x199>
   82983:	73 1f                	jae    829a4 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2504>
   82985:	48 8b b4 24 f0 00 00 	mov    0xf0(%rsp),%rsi
   8298c:	00 
   8298d:	39 96 00 08 00 00    	cmp    %edx,0x800(%rsi)
   82993:	76 43                	jbe    829d8 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2538>
   82995:	31 c0                	xor    %eax,%eax
   82997:	66 0f 6e c1          	movd   %ecx,%xmm0
   8299b:	0f 2e c8             	ucomiss %xmm0,%xmm1
   8299e:	72 0d                	jb     829ad <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x250d>
   829a0:	eb 56                	jmp    829f8 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2558>
   829a2:	31 c0                	xor    %eax,%eax
   829a4:	66 0f 6e c1          	movd   %ecx,%xmm0
   829a8:	0f 2e c8             	ucomiss %xmm0,%xmm1
   829ab:	73 4b                	jae    829f8 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2558>
   829ad:	b2 ff                	mov    $0xff,%dl
   829af:	0f 2e 05 7e de f9 ff 	ucomiss -0x62182(%rip),%xmm0        # 20834 <anon.716c7528f09896edfd633c06424fb6be.44.llvm.7987781668536310964+0x199>
   829b6:	73 42                	jae    829fa <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x255a>
   829b8:	48 8b b4 24 f0 00 00 	mov    0xf0(%rsp),%rsi
   829bf:	00 
   829c0:	39 8e 00 08 00 00    	cmp    %ecx,0x800(%rsi)
   829c6:	76 78                	jbe    82a40 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x25a0>
   829c8:	31 d2                	xor    %edx,%edx
   829ca:	66 0f 6e c7          	movd   %edi,%xmm0
   829ce:	0f 2e c8             	ucomiss %xmm0,%xmm1
   829d1:	72 30                	jb     82a03 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2563>
   829d3:	e9 8a 00 00 00       	jmp    82a62 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x25c2>
   829d8:	89 d0                	mov    %edx,%eax
   829da:	c1 e8 10             	shr    $0x10,%eax
   829dd:	25 ff 07 00 00       	and    $0x7ff,%eax
   829e2:	0f b6 04 06          	movzbl (%rsi,%rax,1),%eax
   829e6:	3b 94 86 00 08 00 00 	cmp    0x800(%rsi,%rax,4),%edx
   829ed:	1c ff                	sbb    $0xff,%al
   829ef:	66 0f 6e c1          	movd   %ecx,%xmm0
   829f3:	0f 2e c8             	ucomiss %xmm0,%xmm1
   829f6:	72 b5                	jb     829ad <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x250d>
   829f8:	31 d2                	xor    %edx,%edx
   829fa:	66 0f 6e c7          	movd   %edi,%xmm0
   829fe:	0f 2e c8             	ucomiss %xmm0,%xmm1
   82a01:	73 5f                	jae    82a62 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x25c2>
   82a03:	b1 ff                	mov    $0xff,%cl
   82a05:	0f 2e 05 28 de f9 ff 	ucomiss -0x621d8(%rip),%xmm0        # 20834 <anon.716c7528f09896edfd633c06424fb6be.44.llvm.7987781668536310964+0x199>
   82a0c:	0f 83 72 fe ff ff    	jae    82884 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x23e4>
   82a12:	48 8b b4 24 f0 00 00 	mov    0xf0(%rsp),%rsi
   82a19:	00 
   82a1a:	39 be 00 08 00 00    	cmp    %edi,0x800(%rsi)
   82a20:	77 40                	ja     82a62 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x25c2>
   82a22:	89 f9                	mov    %edi,%ecx
   82a24:	c1 e9 10             	shr    $0x10,%ecx
   82a27:	81 e1 ff 07 00 00    	and    $0x7ff,%ecx
   82a2d:	0f b6 0c 0e          	movzbl (%rsi,%rcx,1),%ecx
   82a31:	3b bc 8e 00 08 00 00 	cmp    0x800(%rsi,%rcx,4),%edi
   82a38:	80 d9 ff             	sbb    $0xff,%cl
   82a3b:	e9 44 fe ff ff       	jmp    82884 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x23e4>
   82a40:	89 ca                	mov    %ecx,%edx
   82a42:	c1 ea 10             	shr    $0x10,%edx
   82a45:	81 e2 ff 07 00 00    	and    $0x7ff,%edx
   82a4b:	0f b6 14 16          	movzbl (%rsi,%rdx,1),%edx
   82a4f:	3b 8c 96 00 08 00 00 	cmp    0x800(%rsi,%rdx,4),%ecx
   82a56:	80 da ff             	sbb    $0xff,%dl
   82a59:	66 0f 6e c7          	movd   %edi,%xmm0
   82a5d:	0f 2e c8             	ucomiss %xmm0,%xmm1
   82a60:	72 a1                	jb     82a03 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2563>
   82a62:	31 c9                	xor    %ecx,%ecx
   82a64:	e9 1b fe ff ff       	jmp    82884 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x23e4>
   82a69:	4c 8b b4 24 80 00 00 	mov    0x80(%rsp),%r14
   82a70:	00 
   82a71:	4c 8b ac 24 a8 00 00 	mov    0xa8(%rsp),%r13
   82a78:	00 
   82a79:	e9 9d eb ff ff       	jmp    8161b <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x117b>
   82a7e:	0f 57 c0             	xorps  %xmm0,%xmm0
   82a81:	0f 2e c2             	ucomiss %xmm2,%xmm0
   82a84:	4c 8b b4 24 80 00 00 	mov    0x80(%rsp),%r14
   82a8b:	00 
   82a8c:	4c 8b ac 24 a8 00 00 	mov    0xa8(%rsp),%r13
   82a93:	00 
   82a94:	4c 8b a4 24 98 00 00 	mov    0x98(%rsp),%r12
   82a9b:	00 
   82a9c:	48 8b ac 24 c0 00 00 	mov    0xc0(%rsp),%rbp
   82aa3:	00 
   82aa4:	73 23                	jae    82ac9 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2629>
   82aa6:	b0 ff                	mov    $0xff,%al
   82aa8:	0f 2e 15 85 dd f9 ff 	ucomiss -0x6227b(%rip),%xmm2        # 20834 <anon.716c7528f09896edfd633c06424fb6be.44.llvm.7987781668536310964+0x199>
   82aaf:	73 1a                	jae    82acb <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x262b>
   82ab1:	66 0f 7e d1          	movd   %xmm2,%ecx
   82ab5:	48 8b 94 24 f0 00 00 	mov    0xf0(%rsp),%rdx
   82abc:	00 
   82abd:	39 8a 00 08 00 00    	cmp    %ecx,0x800(%rdx)
   82ac3:	0f 86 bc 00 00 00    	jbe    82b85 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x26e5>
   82ac9:	31 c0                	xor    %eax,%eax
   82acb:	0f 28 c2             	movaps %xmm2,%xmm0
   82ace:	0f c6 c2 55          	shufps $0x55,%xmm2,%xmm0
   82ad2:	0f 57 c9             	xorps  %xmm1,%xmm1
   82ad5:	0f 2e c8             	ucomiss %xmm0,%xmm1
   82ad8:	73 68                	jae    82b42 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x26a2>
   82ada:	b1 ff                	mov    $0xff,%cl
   82adc:	0f 2e 05 51 dd f9 ff 	ucomiss -0x622af(%rip),%xmm0        # 20834 <anon.716c7528f09896edfd633c06424fb6be.44.llvm.7987781668536310964+0x199>
   82ae3:	73 5f                	jae    82b44 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x26a4>
   82ae5:	66 0f 7e c2          	movd   %xmm0,%edx
   82ae9:	48 8b b4 24 f0 00 00 	mov    0xf0(%rsp),%rsi
   82af0:	00 
   82af1:	39 96 00 08 00 00    	cmp    %edx,0x800(%rsi)
   82af7:	0f 86 a4 00 00 00    	jbe    82ba1 <<gpui_canvas::canvas::Canvas>::render_output::<gpui_canvas::canvas::Serial>+0x2701>
   82afd:	31 c9                	xor    %ecx,%ecx
   82aff:	0f                   	.byte 0xf
