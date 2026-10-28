
/tmp/gpui-caret-transaction-bin/matched-partial-caret_pair_measure:     file format elf64-x86-64


Disassembly of section .text:

0000000000683310 <<parley::layout::run::Clusters<()>>::new>:
  683310:	55                   	push   %rbp
  683311:	41 57                	push   %r15
  683313:	41 56                	push   %r14
  683315:	41 55                	push   %r13
  683317:	41 54                	push   %r12
  683319:	53                   	push   %rbx
  68331a:	48 83 ec 38          	sub    $0x38,%rsp
  68331e:	49 89 f4             	mov    %rsi,%r12
  683321:	49 89 fe             	mov    %rdi,%r14
  683324:	48 8b 06             	mov    (%rsi),%rax
  683327:	8b 7e 28             	mov    0x28(%rsi),%edi
  68332a:	48 8b 70 58          	mov    0x58(%rax),%rsi
  68332e:	48 39 fe             	cmp    %rdi,%rsi
  683331:	0f 86 73 02 00 00    	jbe    6835aa <<parley::layout::run::Clusters<()>>::new+0x29a>
  683337:	49 8b 4c 24 18       	mov    0x18(%r12),%rcx
  68333c:	48 85 c9             	test   %rcx,%rcx
  68333f:	74 0a                	je     68334b <<parley::layout::run::Clusters<()>>::new+0x3b>
  683341:	48 8d 79 18          	lea    0x18(%rcx),%rdi
  683345:	48 83 c1 1c          	add    $0x1c,%rcx
  683349:	eb 1c                	jmp    683367 <<parley::layout::run::Clusters<()>>::new+0x57>
  68334b:	4c 8b 40 50          	mov    0x50(%rax),%r8
  68334f:	48 8d 34 ff          	lea    (%rdi,%rdi,8),%rsi
  683353:	48 c1 e6 04          	shl    $0x4,%rsi
  683357:	49 8d 0c 30          	lea    (%r8,%rsi,1),%rcx
  68335b:	48 83 c1 54          	add    $0x54,%rcx
  68335f:	49 8d 3c 30          	lea    (%r8,%rsi,1),%rdi
  683363:	48 83 c7 50          	add    $0x50,%rdi
  683367:	4c 8b 40 68          	mov    0x68(%rax),%r8
  68336b:	4c 8b 48 70          	mov    0x70(%rax),%r9
  68336f:	4c 8b b8 80 00 00 00 	mov    0x80(%rax),%r15
  683376:	48 8b b0 88 00 00 00 	mov    0x88(%rax),%rsi
  68337d:	4c 8b 90 98 00 00 00 	mov    0x98(%rax),%r10
  683384:	4c 8b 98 a0 00 00 00 	mov    0xa0(%rax),%r11
  68338b:	8b 29                	mov    (%rcx),%ebp
  68338d:	8b 1f                	mov    (%rdi),%ebx
  68338f:	84 d2                	test   %dl,%dl
  683391:	74 19                	je     6833ac <<parley::layout::run::Clusters<()>>::new+0x9c>
  683393:	39 eb                	cmp    %ebp,%ebx
  683395:	75 2c                	jne    6833c3 <<parley::layout::run::Clusters<()>>::new+0xb3>
  683397:	44 8d 6d 01          	lea    0x1(%rbp),%r13d
  68339b:	41 39 ed             	cmp    %ebp,%r13d
  68339e:	44 0f 46 ed          	cmovbe %ebp,%r13d
  6833a2:	41 ff cd             	dec    %r13d
  6833a5:	0f 57 db             	xorps  %xmm3,%xmm3
  6833a8:	31 c9                	xor    %ecx,%ecx
  6833aa:	eb 10                	jmp    6833bc <<parley::layout::run::Clusters<()>>::new+0xac>
  6833ac:	39 eb                	cmp    %ebp,%ebx
  6833ae:	0f 85 b4 00 00 00    	jne    683468 <<parley::layout::run::Clusters<()>>::new+0x158>
  6833b4:	0f 57 db             	xorps  %xmm3,%xmm3
  6833b7:	31 c9                	xor    %ecx,%ecx
  6833b9:	41 89 ed             	mov    %ebp,%r13d
  6833bc:	89 e8                	mov    %ebp,%eax
  6833be:	e9 37 01 00 00       	jmp    6834fa <<parley::layout::run::Clusters<()>>::new+0x1ea>
  6833c3:	48 39 de             	cmp    %rbx,%rsi
  6833c6:	0f 86 eb 01 00 00    	jbe    6835b7 <<parley::layout::run::Clusters<()>>::new+0x2a7>
  6833cc:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  6833d0:	48 39 f7             	cmp    %rsi,%rdi
  6833d3:	0f 83 ee 01 00 00    	jae    6835c7 <<parley::layout::run::Clusters<()>>::new+0x2b7>
  6833d9:	4c 89 5c 24 20       	mov    %r11,0x20(%rsp)
  6833de:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
  6833e3:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  6833e7:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
  6833eb:	41 39 ed             	cmp    %ebp,%r13d
  6833ee:	44 0f 46 ed          	cmovbe %ebp,%r13d
  6833f2:	41 ff cd             	dec    %r13d
  6833f5:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  6833fa:	4c 39 ee             	cmp    %r13,%rsi
  6833fd:	0f 86 e3 01 00 00    	jbe    6835e6 <<parley::layout::run::Clusters<()>>::new+0x2d6>
  683403:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  683407:	41 8b 44 c7 04       	mov    0x4(%r15,%rax,8),%eax
  68340c:	89 44 24 08          	mov    %eax,0x8(%rsp)
  683410:	4a 8d 04 6d 00 00 00 	lea    0x0(,%r13,2),%rax
  683417:	00 
  683418:	4c 01 e8             	add    %r13,%rax
  68341b:	49 8d 3c c7          	lea    (%r15,%rax,8),%rdi
  68341f:	f3 41 0f 10 44 c7 10 	movss  0x10(%r15,%rax,8),%xmm0
  683426:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  68342c:	4c 89 c6             	mov    %r8,%rsi
  68342f:	4c 89 ca             	mov    %r9,%rdx
  683432:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  683437:	4c 89 4c 24 30       	mov    %r9,0x30(%rsp)
  68343c:	ff 15 e6 62 10 00    	call   *0x1062e6(%rip)        # 789728 <_DYNAMIC+0x910>
  683442:	f3 0f 10 5c 24 04    	movss  0x4(%rsp),%xmm3
  683448:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  68344c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  683451:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  683456:	89 c0                	mov    %eax,%eax
  683458:	0f 57 c0             	xorps  %xmm0,%xmm0
  68345b:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
  683460:	f3 0f 5e d8          	divss  %xmm0,%xmm3
  683464:	89 e8                	mov    %ebp,%eax
  683466:	eb 7f                	jmp    6834e7 <<parley::layout::run::Clusters<()>>::new+0x1d7>
  683468:	48 39 de             	cmp    %rbx,%rsi
  68346b:	0f 86 46 01 00 00    	jbe    6835b7 <<parley::layout::run::Clusters<()>>::new+0x2a7>
  683471:	4c 89 5c 24 20       	mov    %r11,0x20(%rsp)
  683476:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
  68347b:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  68347f:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  683483:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  683488:	48 39 f7             	cmp    %rsi,%rdi
  68348b:	0f 83 43 01 00 00    	jae    6835d4 <<parley::layout::run::Clusters<()>>::new+0x2c4>
  683491:	48 8d 04 5b          	lea    (%rbx,%rbx,2),%rax
  683495:	49 8d 3c c7          	lea    (%r15,%rax,8),%rdi
  683499:	41 8b 0c c7          	mov    (%r15,%rax,8),%ecx
  68349d:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  6834a1:	f3 41 0f 10 44 c7 10 	movss  0x10(%r15,%rax,8),%xmm0
  6834a8:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  6834ae:	4c 89 c6             	mov    %r8,%rsi
  6834b1:	4c 89 ca             	mov    %r9,%rdx
  6834b4:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  6834b9:	4d 89 cd             	mov    %r9,%r13
  6834bc:	ff 15 66 62 10 00    	call   *0x106266(%rip)        # 789728 <_DYNAMIC+0x910>
  6834c2:	f3 0f 10 5c 24 04    	movss  0x4(%rsp),%xmm3
  6834c8:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  6834cc:	4d 89 e9             	mov    %r13,%r9
  6834cf:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  6834d4:	89 c0                	mov    %eax,%eax
  6834d6:	0f 57 c0             	xorps  %xmm0,%xmm0
  6834d9:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
  6834de:	f3 0f 5e d8          	divss  %xmm0,%xmm3
  6834e2:	41 89 dd             	mov    %ebx,%r13d
  6834e5:	89 d8                	mov    %ebx,%eax
  6834e7:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  6834eb:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  6834f0:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  6834f5:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  6834fa:	41 0f 10 04 24       	movups (%r12),%xmm0
  6834ff:	41 0f 10 4c 24 10    	movups 0x10(%r12),%xmm1
  683505:	41 0f 10 54 24 20    	movups 0x20(%r12),%xmm2
  68350b:	41 0f 11 56 20       	movups %xmm2,0x20(%r14)
  683510:	41 0f 11 4e 10       	movups %xmm1,0x10(%r14)
  683515:	41 0f 11 06          	movups %xmm0,(%r14)
  683519:	4d 89 46 30          	mov    %r8,0x30(%r14)
  68351d:	4d 89 4e 38          	mov    %r9,0x38(%r14)
  683521:	4d 89 7e 40          	mov    %r15,0x40(%r14)
  683525:	49 89 76 48          	mov    %rsi,0x48(%r14)
  683529:	4d 89 56 50          	mov    %r10,0x50(%r14)
  68352d:	4d 89 5e 58          	mov    %r11,0x58(%r14)
  683531:	41 89 5e 60          	mov    %ebx,0x60(%r14)
  683535:	41 89 6e 64          	mov    %ebp,0x64(%r14)
  683539:	41 89 46 68          	mov    %eax,0x68(%r14)
  68353d:	4d 89 46 70          	mov    %r8,0x70(%r14)
  683541:	4d 89 4e 78          	mov    %r9,0x78(%r14)
  683545:	4d 89 be 80 00 00 00 	mov    %r15,0x80(%r14)
  68354c:	49 89 b6 88 00 00 00 	mov    %rsi,0x88(%r14)
  683553:	4d 89 96 90 00 00 00 	mov    %r10,0x90(%r14)
  68355a:	4d 89 9e 98 00 00 00 	mov    %r11,0x98(%r14)
  683561:	41 89 9e a0 00 00 00 	mov    %ebx,0xa0(%r14)
  683568:	41 89 ae a4 00 00 00 	mov    %ebp,0xa4(%r14)
  68356f:	41 89 8e a8 00 00 00 	mov    %ecx,0xa8(%r14)
  683576:	45 89 ae ac 00 00 00 	mov    %r13d,0xac(%r14)
  68357d:	f3 41 0f 11 9e b0 00 	movss  %xmm3,0xb0(%r14)
  683584:	00 00 
  683586:	49 c7 86 b8 00 00 00 	movq   $0x0,0xb8(%r14)
  68358d:	00 00 00 00 
  683591:	41 88 96 08 01 00 00 	mov    %dl,0x108(%r14)
  683598:	4c 89 f0             	mov    %r14,%rax
  68359b:	48 83 c4 38          	add    $0x38,%rsp
  68359f:	5b                   	pop    %rbx
  6835a0:	41 5c                	pop    %r12
  6835a2:	41 5d                	pop    %r13
  6835a4:	41 5e                	pop    %r14
  6835a6:	41 5f                	pop    %r15
  6835a8:	5d                   	pop    %rbp
  6835a9:	c3                   	ret
  6835aa:	48 8d 15 5f c0 0f 00 	lea    0xfc05f(%rip),%rdx        # 77f610 <anon.d4a86088305c8823b863e6abd2e38045.52.llvm.2509172480284221941>
  6835b1:	ff 15 c1 5b 10 00    	call   *0x105bc1(%rip)        # 789178 <_DYNAMIC+0x360>
  6835b7:	48 8d 15 b2 bd 0f 00 	lea    0xfbdb2(%rip),%rdx        # 77f370 <anon.d4a86088305c8823b863e6abd2e38045.3.llvm.2509172480284221941+0x90>
  6835be:	48 89 df             	mov    %rbx,%rdi
  6835c1:	ff 15 b1 5b 10 00    	call   *0x105bb1(%rip)        # 789178 <_DYNAMIC+0x360>
  6835c7:	48 8d 15 ba bd 0f 00 	lea    0xfbdba(%rip),%rdx        # 77f388 <anon.d4a86088305c8823b863e6abd2e38045.3.llvm.2509172480284221941+0xa8>
  6835ce:	ff 15 a4 5b 10 00    	call   *0x105ba4(%rip)        # 789178 <_DYNAMIC+0x360>
  6835d4:	48 8d 15 ad bd 0f 00 	lea    0xfbdad(%rip),%rdx        # 77f388 <anon.d4a86088305c8823b863e6abd2e38045.3.llvm.2509172480284221941+0xa8>
  6835db:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  6835e0:	ff 15 92 5b 10 00    	call   *0x105b92(%rip)        # 789178 <_DYNAMIC+0x360>
  6835e6:	48 8d 15 5b be 0f 00 	lea    0xfbe5b(%rip),%rdx        # 77f448 <anon.d4a86088305c8823b863e6abd2e38045.3.llvm.2509172480284221941+0x168>
  6835ed:	4c 89 ef             	mov    %r13,%rdi
  6835f0:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  6835f5:	ff 15 7d 5b 10 00    	call   *0x105b7d(%rip)        # 789178 <_DYNAMIC+0x360>
