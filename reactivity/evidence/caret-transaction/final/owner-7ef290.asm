
/tmp/gpui-caret-transaction-bin/62e-native-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007ef290 <<gpui_canvas::text::planner::Planner>::shape>:
  7ef290:	55                   	push   %rbp
  7ef291:	41 57                	push   %r15
  7ef293:	41 56                	push   %r14
  7ef295:	41 55                	push   %r13
  7ef297:	41 54                	push   %r12
  7ef299:	53                   	push   %rbx
  7ef29a:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  7ef2a1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  7ef2a8:	00 
  7ef2a9:	48 81 ec a8 01 00 00 	sub    $0x1a8,%rsp
  7ef2b0:	44 89 8c 24 1c 02 00 	mov    %r9d,0x21c(%rsp)
  7ef2b7:	00 
  7ef2b8:	f3 0f 11 8c 24 9c 01 	movss  %xmm1,0x19c(%rsp)
  7ef2bf:	00 00 
  7ef2c1:	44 89 84 24 98 01 00 	mov    %r8d,0x198(%rsp)
  7ef2c8:	00 
  7ef2c9:	f3 0f 11 84 24 84 00 	movss  %xmm0,0x84(%rsp)
  7ef2d0:	00 00 
  7ef2d2:	48 89 bc 24 68 03 00 	mov    %rdi,0x368(%rsp)
  7ef2d9:	00 
  7ef2da:	4c 8d 24 0a          	lea    (%rdx,%rcx,1),%r12
  7ef2de:	48 85 c9             	test   %rcx,%rcx
  7ef2e1:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  7ef2e6:	4c 89 a4 24 30 01 00 	mov    %r12,0x130(%rsp)
  7ef2ed:	00 
  7ef2ee:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  7ef2f3:	48 89 94 24 28 01 00 	mov    %rdx,0x128(%rsp)
  7ef2fa:	00 
  7ef2fb:	0f 84 8b 03 00 00    	je     7ef68c <<gpui_canvas::text::planner::Planner>::shape+0x3fc>
  7ef301:	48 8d 86 78 0a 00 00 	lea    0xa78(%rsi),%rax
  7ef308:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  7ef30d:	48 8d bc 24 ac 0c 00 	lea    0xcac(%rsp),%rdi
  7ef314:	00 
  7ef315:	48 8d 46 38          	lea    0x38(%rsi),%rax
  7ef319:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  7ef31e:	48 8d 46 3c          	lea    0x3c(%rsi),%rax
  7ef322:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7ef327:	48 8d 46 58          	lea    0x58(%rsi),%rax
  7ef32b:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  7ef330:	48 8d 46 5c          	lea    0x5c(%rsi),%rax
  7ef334:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  7ef339:	c7 04 24 00 00 00 00 	movl   $0x0,(%rsp)
  7ef340:	48 8d b4 24 d0 06 00 	lea    0x6d0(%rsp),%rsi
  7ef347:	00 
  7ef348:	4c 8b 05 49 f0 33 00 	mov    0x33f049(%rip),%r8        # b2e398 <_DYNAMIC+0xe98>
  7ef34f:	49 89 d6             	mov    %rdx,%r14
  7ef352:	eb 25                	jmp    7ef379 <<gpui_canvas::text::planner::Planner>::shape+0xe9>
  7ef354:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  7ef35b:	00 00 00 00 00 
  7ef360:	41 8d 87 d8 df ff ff 	lea    -0x2028(%r15),%eax
  7ef367:	83 f8 02             	cmp    $0x2,%eax
  7ef36a:	0f 83 e1 00 00 00    	jae    7ef451 <<gpui_canvas::text::planner::Planner>::shape+0x1c1>
  7ef370:	4d 39 e6             	cmp    %r12,%r14
  7ef373:	0f 84 b5 02 00 00    	je     7ef62e <<gpui_canvas::text::planner::Planner>::shape+0x39e>
  7ef379:	45 0f b6 3e          	movzbl (%r14),%r15d
  7ef37d:	45 84 ff             	test   %r15b,%r15b
  7ef380:	78 1e                	js     7ef3a0 <<gpui_canvas::text::planner::Planner>::shape+0x110>
  7ef382:	49 ff c6             	inc    %r14
  7ef385:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  7ef38c:	0f 8e 9e 00 00 00    	jle    7ef430 <<gpui_canvas::text::planner::Planner>::shape+0x1a0>
  7ef392:	eb cc                	jmp    7ef360 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  7ef394:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  7ef39b:	00 00 00 00 00 
  7ef3a0:	44 89 f8             	mov    %r15d,%eax
  7ef3a3:	83 e0 1f             	and    $0x1f,%eax
  7ef3a6:	41 0f b6 56 01       	movzbl 0x1(%r14),%edx
  7ef3ab:	83 e2 3f             	and    $0x3f,%edx
  7ef3ae:	41 80 ff df          	cmp    $0xdf,%r15b
  7ef3b2:	76 3d                	jbe    7ef3f1 <<gpui_canvas::text::planner::Planner>::shape+0x161>
  7ef3b4:	41 0f b6 4e 02       	movzbl 0x2(%r14),%ecx
  7ef3b9:	c1 e2 06             	shl    $0x6,%edx
  7ef3bc:	83 e1 3f             	and    $0x3f,%ecx
  7ef3bf:	09 d1                	or     %edx,%ecx
  7ef3c1:	41 80 ff f0          	cmp    $0xf0,%r15b
  7ef3c5:	72 44                	jb     7ef40b <<gpui_canvas::text::planner::Planner>::shape+0x17b>
  7ef3c7:	45 0f b6 7e 03       	movzbl 0x3(%r14),%r15d
  7ef3cc:	49 83 c6 04          	add    $0x4,%r14
  7ef3d0:	83 e0 07             	and    $0x7,%eax
  7ef3d3:	c1 e0 12             	shl    $0x12,%eax
  7ef3d6:	c1 e1 06             	shl    $0x6,%ecx
  7ef3d9:	41 83 e7 3f          	and    $0x3f,%r15d
  7ef3dd:	41 09 cf             	or     %ecx,%r15d
  7ef3e0:	41 09 c7             	or     %eax,%r15d
  7ef3e3:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  7ef3ea:	7e 44                	jle    7ef430 <<gpui_canvas::text::planner::Planner>::shape+0x1a0>
  7ef3ec:	e9 6f ff ff ff       	jmp    7ef360 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  7ef3f1:	49 83 c6 02          	add    $0x2,%r14
  7ef3f5:	c1 e0 06             	shl    $0x6,%eax
  7ef3f8:	09 d0                	or     %edx,%eax
  7ef3fa:	41 89 c7             	mov    %eax,%r15d
  7ef3fd:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  7ef404:	7e 2a                	jle    7ef430 <<gpui_canvas::text::planner::Planner>::shape+0x1a0>
  7ef406:	e9 55 ff ff ff       	jmp    7ef360 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  7ef40b:	49 83 c6 03          	add    $0x3,%r14
  7ef40f:	c1 e0 0c             	shl    $0xc,%eax
  7ef412:	09 c1                	or     %eax,%ecx
  7ef414:	41 89 cf             	mov    %ecx,%r15d
  7ef417:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  7ef41e:	0f 8f 3c ff ff ff    	jg     7ef360 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  7ef424:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  7ef42b:	00 00 00 00 00 
  7ef430:	41 83 ff 0a          	cmp    $0xa,%r15d
  7ef434:	0f 84 36 ff ff ff    	je     7ef370 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  7ef43a:	41 83 ff 0d          	cmp    $0xd,%r15d
  7ef43e:	0f 84 2c ff ff ff    	je     7ef370 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  7ef444:	41 81 ff 85 00 00 00 	cmp    $0x85,%r15d
  7ef44b:	0f 84 1f ff ff ff    	je     7ef370 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  7ef451:	48 89 fd             	mov    %rdi,%rbp
  7ef454:	48 8d 3d 25 83 31 00 	lea    0x318325(%rip),%rdi        # b07780 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x58>
  7ef45b:	49 89 f5             	mov    %rsi,%r13
  7ef45e:	44 89 fe             	mov    %r15d,%esi
  7ef461:	4c 89 c3             	mov    %r8,%rbx
  7ef464:	ff 15 36 ef 33 00    	call   *0x33ef36(%rip)        # b2e3a0 <_DYNAMIC+0xea0>
  7ef46a:	49 89 d8             	mov    %rbx,%r8
  7ef46d:	4c 89 ee             	mov    %r13,%rsi
  7ef470:	48 89 ef             	mov    %rbp,%rdi
  7ef473:	84 c0                	test   %al,%al
  7ef475:	0f 85 f5 fe ff ff    	jne    7ef370 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  7ef47b:	41 bc 0a 00 00 00    	mov    $0xa,%r12d
  7ef481:	41 83 ff 20          	cmp    $0x20,%r15d
  7ef485:	0f 82 57 02 00 00    	jb     7ef6e2 <<gpui_canvas::text::planner::Planner>::shape+0x452>
  7ef48b:	41 8d 47 81          	lea    -0x7f(%r15),%eax
  7ef48f:	83 f8 21             	cmp    $0x21,%eax
  7ef492:	0f 82 4a 02 00 00    	jb     7ef6e2 <<gpui_canvas::text::planner::Planner>::shape+0x452>
  7ef498:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  7ef49d:	44 89 fe             	mov    %r15d,%esi
  7ef4a0:	e8 cb 3b 00 00       	call   7f3070 <<gpui_canvas::text::planner::Cmap>::glyph_index>
  7ef4a5:	49 89 d8             	mov    %rbx,%r8
  7ef4a8:	4c 89 ee             	mov    %r13,%rsi
  7ef4ab:	a8 01                	test   $0x1,%al
  7ef4ad:	4c 8b a4 24 30 01 00 	mov    0x130(%rsp),%r12
  7ef4b4:	00 
  7ef4b5:	74 0c                	je     7ef4c3 <<gpui_canvas::text::planner::Planner>::shape+0x233>
  7ef4b7:	48 89 ef             	mov    %rbp,%rdi
  7ef4ba:	66 85 d2             	test   %dx,%dx
  7ef4bd:	0f 85 ad fe ff ff    	jne    7ef370 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  7ef4c3:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  7ef4c8:	48 8b 81 40 0a 00 00 	mov    0xa40(%rcx),%rax
  7ef4cf:	41 bc 0b 00 00 00    	mov    $0xb,%r12d
  7ef4d5:	80 78 38 01          	cmpb   $0x1,0x38(%rax)
  7ef4d9:	0f 85 03 02 00 00    	jne    7ef6e2 <<gpui_canvas::text::planner::Planner>::shape+0x452>
  7ef4df:	48 83 79 30 00       	cmpq   $0x0,0x30(%rcx)
  7ef4e4:	0f 85 e8 00 00 00    	jne    7ef5d2 <<gpui_canvas::text::planner::Planner>::shape+0x342>
  7ef4ea:	ba 48 ab 03 00       	mov    $0x3ab48,%edx
  7ef4ef:	48 89 f7             	mov    %rsi,%rdi
  7ef4f2:	48 8d 35 37 9e 91 ff 	lea    -0x6e61c9(%rip),%rsi        # 109330 <gpui_canvas::text::ARABIC_BYTES>
  7ef4f9:	31 c9                	xor    %ecx,%ecx
  7ef4fb:	41 ff d0             	call   *%r8
  7ef4fe:	83 bc 24 d0 06 00 00 	cmpl   $0xffffffff,0x6d0(%rsp)
  7ef505:	ff 
  7ef506:	0f 84 59 2c 00 00    	je     7f2165 <<gpui_canvas::text::planner::Planner>::shape+0x2ed5>
  7ef50c:	8b 84 24 a8 0c 00 00 	mov    0xca8(%rsp),%eax
  7ef513:	89 44 24 20          	mov    %eax,0x20(%rsp)
  7ef517:	0f 10 45 00          	movups 0x0(%rbp),%xmm0
  7ef51b:	0f 10 4d 0c          	movups 0xc(%rbp),%xmm1
  7ef51f:	0f 29 84 24 80 04 00 	movaps %xmm0,0x480(%rsp)
  7ef526:	00 
  7ef527:	0f 11 8c 24 8c 04 00 	movups %xmm1,0x48c(%rsp)
  7ef52e:	00 
  7ef52f:	ba 14 69 00 00       	mov    $0x6914,%edx
  7ef534:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7ef53b:	00 
  7ef53c:	48 8d 35 35 49 95 ff 	lea    -0x6ab6cb(%rip),%rsi        # 143e78 <gpui_canvas::text::HEBREW_BYTES>
  7ef543:	31 c9                	xor    %ecx,%ecx
  7ef545:	ff 15 4d ee 33 00    	call   *0x33ee4d(%rip)        # b2e398 <_DYNAMIC+0xe98>
  7ef54b:	83 bc 24 d0 06 00 00 	cmpl   $0xffffffff,0x6d0(%rsp)
  7ef552:	ff 
  7ef553:	0f 84 1e 2c 00 00    	je     7f2177 <<gpui_canvas::text::planner::Planner>::shape+0x2ee7>
  7ef559:	8b 94 24 a8 0c 00 00 	mov    0xca8(%rsp),%edx
  7ef560:	48 8d 84 24 ac 0c 00 	lea    0xcac(%rsp),%rax
  7ef567:	00 
  7ef568:	0f 10 00             	movups (%rax),%xmm0
  7ef56b:	0f 10 48 0c          	movups 0xc(%rax),%xmm1
  7ef56f:	0f 29 84 24 d0 02 00 	movaps %xmm0,0x2d0(%rsp)
  7ef576:	00 
  7ef577:	0f 11 8c 24 dc 02 00 	movups %xmm1,0x2dc(%rsp)
  7ef57e:	00 
  7ef57f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7ef584:	48 c7 40 30 01 00 00 	movq   $0x1,0x30(%rax)
  7ef58b:	00 
  7ef58c:	8b 4c 24 20          	mov    0x20(%rsp),%ecx
  7ef590:	89 48 38             	mov    %ecx,0x38(%rax)
  7ef593:	0f 10 84 24 8c 04 00 	movups 0x48c(%rsp),%xmm0
  7ef59a:	00 
  7ef59b:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  7ef5a0:	0f 11 41 0c          	movups %xmm0,0xc(%rcx)
  7ef5a4:	0f 28 84 24 80 04 00 	movaps 0x480(%rsp),%xmm0
  7ef5ab:	00 
  7ef5ac:	0f 11 01             	movups %xmm0,(%rcx)
  7ef5af:	89 54 24 38          	mov    %edx,0x38(%rsp)
  7ef5b3:	89 50 58             	mov    %edx,0x58(%rax)
  7ef5b6:	0f 10 84 24 dc 02 00 	movups 0x2dc(%rsp),%xmm0
  7ef5bd:	00 
  7ef5be:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7ef5c3:	0f 11 40 0c          	movups %xmm0,0xc(%rax)
  7ef5c7:	0f 28 84 24 d0 02 00 	movaps 0x2d0(%rsp),%xmm0
  7ef5ce:	00 
  7ef5cf:	0f 11 00             	movups %xmm0,(%rax)
  7ef5d2:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  7ef5d7:	44 89 fe             	mov    %r15d,%esi
  7ef5da:	e8 91 3a 00 00       	call   7f3070 <<gpui_canvas::text::planner::Cmap>::glyph_index>
  7ef5df:	66 85 d2             	test   %dx,%dx
  7ef5e2:	0f 95 c1             	setne  %cl
  7ef5e5:	20 c1                	and    %al,%cl
  7ef5e7:	88 4c 24 50          	mov    %cl,0x50(%rsp)
  7ef5eb:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  7ef5f0:	44 89 fe             	mov    %r15d,%esi
  7ef5f3:	e8 78 3a 00 00       	call   7f3070 <<gpui_canvas::text::planner::Cmap>::glyph_index>
  7ef5f8:	66 85 d2             	test   %dx,%dx
  7ef5fb:	0f 95 c1             	setne  %cl
  7ef5fe:	20 c1                	and    %al,%cl
  7ef600:	00 c9                	add    %cl,%cl
  7ef602:	0a 4c 24 50          	or     0x50(%rsp),%cl
  7ef606:	0f 84 d6 00 00 00    	je     7ef6e2 <<gpui_canvas::text::planner::Planner>::shape+0x452>
  7ef60c:	8b 04 24             	mov    (%rsp),%eax
  7ef60f:	08 c8                	or     %cl,%al
  7ef611:	89 04 24             	mov    %eax,(%rsp)
  7ef614:	4c 8b a4 24 30 01 00 	mov    0x130(%rsp),%r12
  7ef61b:	00 
  7ef61c:	4d 39 e6             	cmp    %r12,%r14
  7ef61f:	48 89 ef             	mov    %rbp,%rdi
  7ef622:	4c 89 ee             	mov    %r13,%rsi
  7ef625:	49 89 d8             	mov    %rbx,%r8
  7ef628:	0f 85 4b fd ff ff    	jne    7ef379 <<gpui_canvas::text::planner::Planner>::shape+0xe9>
  7ef62e:	8b 14 24             	mov    (%rsp),%edx
  7ef631:	f6 c2 01             	test   $0x1,%dl
  7ef634:	0f 84 c9 00 00 00    	je     7ef703 <<gpui_canvas::text::planner::Planner>::shape+0x473>
  7ef63a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7ef63f:	48 83 b8 48 0a 00 00 	cmpq   $0x0,0xa48(%rax)
  7ef646:	00 
  7ef647:	0f 85 b6 00 00 00    	jne    7ef703 <<gpui_canvas::text::planner::Planner>::shape+0x473>
  7ef64d:	48 8d 35 0c 1a 34 00 	lea    0x341a0c(%rip),%rsi        # b31060 <gpui_canvas::text::ARABIC_FONT>
  7ef654:	48 8d 15 d5 9c 91 ff 	lea    -0x6e632b(%rip),%rdx        # 109330 <gpui_canvas::text::ARABIC_BYTES>
  7ef65b:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7ef662:	00 
  7ef663:	b9 48 ab 03 00       	mov    $0x3ab48,%ecx
  7ef668:	45 31 c0             	xor    %r8d,%r8d
  7ef66b:	e8 e0 24 01 00       	call   801b50 <<gpui_canvas::text::FontFace>::shared_static>
  7ef670:	83 bc 24 d0 06 00 00 	cmpl   $0x1,0x6d0(%rsp)
  7ef677:	01 
  7ef678:	75 19                	jne    7ef693 <<gpui_canvas::text::planner::Planner>::shape+0x403>
  7ef67a:	44 8b a4 24 d4 06 00 	mov    0x6d4(%rsp),%r12d
  7ef681:	00 
  7ef682:	44 8b bc 24 d8 06 00 	mov    0x6d8(%rsp),%r15d
  7ef689:	00 
  7ef68a:	eb 56                	jmp    7ef6e2 <<gpui_canvas::text::planner::Planner>::shape+0x452>
  7ef68c:	31 d2                	xor    %edx,%edx
  7ef68e:	e9 88 00 00 00       	jmp    7ef71b <<gpui_canvas::text::planner::Planner>::shape+0x48b>
  7ef693:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7ef698:	4c 8d b8 48 0a 00 00 	lea    0xa48(%rax),%r15
  7ef69f:	4c 8b a4 24 d8 06 00 	mov    0x6d8(%rsp),%r12
  7ef6a6:	00 
  7ef6a7:	49 8b 07             	mov    (%r15),%rax
  7ef6aa:	48 85 c0             	test   %rax,%rax
  7ef6ad:	74 0f                	je     7ef6be <<gpui_canvas::text::planner::Planner>::shape+0x42e>
  7ef6af:	f0 48 ff 08          	lock decq (%rax)
  7ef6b3:	75 09                	jne    7ef6be <<gpui_canvas::text::planner::Planner>::shape+0x42e>
  7ef6b5:	4c 89 ff             	mov    %r15,%rdi
  7ef6b8:	ff 15 3a e1 33 00    	call   *0x33e13a(%rip)        # b2d7f8 <_DYNAMIC+0x2f8>
  7ef6be:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  7ef6c3:	4c 89 a7 48 0a 00 00 	mov    %r12,0xa48(%rdi)
  7ef6ca:	be 01 00 00 00       	mov    $0x1,%esi
  7ef6cf:	e8 9c 36 00 00       	call   7f2d70 <<gpui_canvas::text::planner::Planner>::register>
  7ef6d4:	83 f8 ff             	cmp    $0xffffffff,%eax
  7ef6d7:	8b 14 24             	mov    (%rsp),%edx
  7ef6da:	74 27                	je     7ef703 <<gpui_canvas::text::planner::Planner>::shape+0x473>
  7ef6dc:	41 89 c4             	mov    %eax,%r12d
  7ef6df:	45 31 ff             	xor    %r15d,%r15d
  7ef6e2:	44 89 a4 24 a8 00 00 	mov    %r12d,0xa8(%rsp)
  7ef6e9:	00 
  7ef6ea:	44 89 bc 24 ac 00 00 	mov    %r15d,0xac(%rsp)
  7ef6f1:	00 
  7ef6f2:	48 c7 84 24 a0 00 00 	movq   $0xffffffffffffffff,0xa0(%rsp)
  7ef6f9:	00 ff ff ff ff 
  7ef6fe:	e9 6d 2f 00 00       	jmp    7f2670 <<gpui_canvas::text::planner::Planner>::shape+0x33e0>
  7ef703:	f6 c2 02             	test   $0x2,%dl
  7ef706:	74 13                	je     7ef71b <<gpui_canvas::text::planner::Planner>::shape+0x48b>
  7ef708:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7ef70d:	48 83 b8 50 0a 00 00 	cmpq   $0x0,0xa50(%rax)
  7ef714:	00 
  7ef715:	0f 84 9b 26 00 00    	je     7f1db6 <<gpui_canvas::text::planner::Planner>::shape+0x2b26>
  7ef71b:	48 c7 84 24 88 02 00 	movq   $0xffffffffffffffff,0x288(%rsp)
  7ef722:	00 ff ff ff ff 
  7ef727:	48 8d 05 a0 70 91 ff 	lea    -0x6e8f60(%rip),%rax        # 1067ce <anon.8b5fc042aaf44ecdb8851cb64b83294a.7.llvm.11756661080873179907+0xb2>
  7ef72e:	48 89 84 24 90 02 00 	mov    %rax,0x290(%rsp)
  7ef735:	00 
  7ef736:	48 c7 84 24 98 02 00 	movq   $0xc,0x298(%rsp)
  7ef73d:	00 0c 00 00 00 
  7ef742:	48 c7 84 24 a0 02 00 	movq   $0xffffffffffffffff,0x2a0(%rsp)
  7ef749:	00 ff ff ff ff 
  7ef74e:	48 8d 05 85 70 91 ff 	lea    -0x6e8f7b(%rip),%rax        # 1067da <anon.8b5fc042aaf44ecdb8851cb64b83294a.7.llvm.11756661080873179907+0xbe>
  7ef755:	48 89 84 24 a8 02 00 	mov    %rax,0x2a8(%rsp)
  7ef75c:	00 
  7ef75d:	48 c7 84 24 b0 02 00 	movq   $0x11,0x2b0(%rsp)
  7ef764:	00 11 00 00 00 
  7ef769:	48 c7 84 24 b8 02 00 	movq   $0xffffffffffffffff,0x2b8(%rsp)
  7ef770:	00 ff ff ff ff 
  7ef775:	4c 8d 35 6f 70 91 ff 	lea    -0x6e8f91(%rip),%r14        # 1067eb <anon.8b5fc042aaf44ecdb8851cb64b83294a.7.llvm.11756661080873179907+0xcf>
  7ef77c:	4c 89 b4 24 c0 02 00 	mov    %r14,0x2c0(%rsp)
  7ef783:	00 
  7ef784:	48 c7 84 24 c8 02 00 	movq   $0x11,0x2c8(%rsp)
  7ef78b:	00 11 00 00 00 
  7ef790:	f6 c2 01             	test   $0x1,%dl
  7ef793:	75 1c                	jne    7ef7b1 <<gpui_canvas::text::planner::Planner>::shape+0x521>
  7ef795:	4c 8d bc 24 a0 02 00 	lea    0x2a0(%rsp),%r15
  7ef79c:	00 
  7ef79d:	b8 01 00 00 00       	mov    $0x1,%eax
  7ef7a2:	48 89 84 24 f8 01 00 	mov    %rax,0x1f8(%rsp)
  7ef7a9:	00 
  7ef7aa:	f6 c2 02             	test   $0x2,%dl
  7ef7ad:	75 24                	jne    7ef7d3 <<gpui_canvas::text::planner::Planner>::shape+0x543>
  7ef7af:	eb 5a                	jmp    7ef80b <<gpui_canvas::text::planner::Planner>::shape+0x57b>
  7ef7b1:	4c 8d bc 24 b8 02 00 	lea    0x2b8(%rsp),%r15
  7ef7b8:	00 
  7ef7b9:	48 89 84 24 a8 02 00 	mov    %rax,0x2a8(%rsp)
  7ef7c0:	00 
  7ef7c1:	b8 02 00 00 00       	mov    $0x2,%eax
  7ef7c6:	48 89 84 24 f8 01 00 	mov    %rax,0x1f8(%rsp)
  7ef7cd:	00 
  7ef7ce:	f6 c2 02             	test   $0x2,%dl
  7ef7d1:	74 38                	je     7ef80b <<gpui_canvas::text::planner::Planner>::shape+0x57b>
  7ef7d3:	49 8b 37             	mov    (%r15),%rsi
  7ef7d6:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  7ef7da:	77 14                	ja     7ef7f0 <<gpui_canvas::text::planner::Planner>::shape+0x560>
  7ef7dc:	48 85 f6             	test   %rsi,%rsi
  7ef7df:	74 0f                	je     7ef7f0 <<gpui_canvas::text::planner::Planner>::shape+0x560>
  7ef7e1:	49 8b 7f 08          	mov    0x8(%r15),%rdi
  7ef7e5:	ba 01 00 00 00       	mov    $0x1,%edx
  7ef7ea:	ff 15 58 df 33 00    	call   *0x33df58(%rip)        # b2d748 <_DYNAMIC+0x248>
  7ef7f0:	49 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%r15)
  7ef7f7:	4d 89 77 08          	mov    %r14,0x8(%r15)
  7ef7fb:	49 c7 47 10 11 00 00 	movq   $0x11,0x10(%r15)
  7ef802:	00 
  7ef803:	48 ff 84 24 f8 01 00 	incq   0x1f8(%rsp)
  7ef80a:	00 
  7ef80b:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  7ef812:	00 00 00 00 00 
  7ef817:	48 c7 84 24 f0 00 00 	movq   $0x4,0xf0(%rsp)
  7ef81e:	00 04 00 00 00 
  7ef823:	48 c7 84 24 f8 00 00 	movq   $0x0,0xf8(%rsp)
  7ef82a:	00 00 00 00 00 
  7ef82f:	48 c7 84 24 38 01 00 	movq   $0xffffffffffffffff,0x138(%rsp)
  7ef836:	00 ff ff ff ff 
  7ef83b:	f6 84 24 98 01 00 00 	testb  $0x1,0x198(%rsp)
  7ef842:	01 
  7ef843:	75 11                	jne    7ef856 <<gpui_canvas::text::planner::Planner>::shape+0x5c6>
  7ef845:	f3 0f 10 05 3f 00 91 	movss  -0x6effc1(%rip),%xmm0        # ff88c <anon.5923aa265a9ec0a4213c70985337b2b1.13.llvm.1364676386607977936+0x44>
  7ef84c:	ff 
  7ef84d:	f3 0f 11 84 24 9c 01 	movss  %xmm0,0x19c(%rsp)
  7ef854:	00 00 
  7ef856:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7ef85b:	48 8d 48 78          	lea    0x78(%rax),%rcx
  7ef85f:	48 89 8c 24 60 03 00 	mov    %rcx,0x360(%rsp)
  7ef866:	00 
  7ef867:	48 8d 88 38 06 00 00 	lea    0x638(%rax),%rcx
  7ef86e:	48 89 8c 24 58 03 00 	mov    %rcx,0x358(%rsp)
  7ef875:	00 
  7ef876:	48 05 c8 08 00 00    	add    $0x8c8,%rax
  7ef87c:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  7ef881:	4c 8d b4 24 e0 02 00 	lea    0x2e0(%rsp),%r14
  7ef888:	00 
  7ef889:	0f 57 c0             	xorps  %xmm0,%xmm0
  7ef88c:	0f 29 84 24 60 02 00 	movaps %xmm0,0x260(%rsp)
  7ef893:	00 
  7ef894:	f3 0f 11 44 24 58    	movss  %xmm0,0x58(%rsp)
  7ef89a:	f3 0f 11 44 24 7c    	movss  %xmm0,0x7c(%rsp)
  7ef8a0:	4c 8d a4 24 88 04 00 	lea    0x488(%rsp),%r12
  7ef8a7:	00 
  7ef8a8:	48 8d 05 11 80 31 00 	lea    0x318011(%rip),%rax        # b078c0 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x198>
  7ef8af:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  7ef8b4:	48 8d 05 4d 89 31 00 	lea    0x31894d(%rip),%rax        # b08208 <anon.e1aed3256c0f336e2763058c1a348a1e.14.llvm.17407148579165845042>
  7ef8bb:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  7ef8c2:	00 
  7ef8c3:	48 c7 84 24 f0 01 00 	movq   $0x0,0x1f0(%rsp)
  7ef8ca:	00 00 00 00 00 
  7ef8cf:	31 ed                	xor    %ebp,%ebp
  7ef8d1:	48 8b 84 24 28 01 00 	mov    0x128(%rsp),%rax
  7ef8d8:	00 
  7ef8d9:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  7ef8de:	31 c0                	xor    %eax,%eax
  7ef8e0:	be fe ff ff ff       	mov    $0xfffffffe,%esi
  7ef8e5:	48 89 2c 24          	mov    %rbp,(%rsp)
  7ef8e9:	83 fe fe             	cmp    $0xfffffffe,%esi
  7ef8ec:	75 22                	jne    7ef910 <<gpui_canvas::text::planner::Planner>::shape+0x680>
  7ef8ee:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  7ef8f3:	4c 3b 8c 24 30 01 00 	cmp    0x130(%rsp),%r9
  7ef8fa:	00 
  7ef8fb:	74 27                	je     7ef924 <<gpui_canvas::text::planner::Planner>::shape+0x694>
  7ef8fd:	41 0f b6 09          	movzbl (%r9),%ecx
  7ef901:	84 c9                	test   %cl,%cl
  7ef903:	78 3a                	js     7ef93f <<gpui_canvas::text::planner::Planner>::shape+0x6af>
  7ef905:	49 8d 51 01          	lea    0x1(%r9),%rdx
  7ef909:	e9 8e 00 00 00       	jmp    7ef99c <<gpui_canvas::text::planner::Planner>::shape+0x70c>
  7ef90e:	66 90                	xchg   %ax,%ax
  7ef910:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  7ef915:	89 f1                	mov    %esi,%ecx
  7ef917:	4c 8b 84 24 48 03 00 	mov    0x348(%rsp),%r8
  7ef91e:	00 
  7ef91f:	e9 81 00 00 00       	jmp    7ef9a5 <<gpui_canvas::text::planner::Planner>::shape+0x715>
  7ef924:	c7 84 24 80 00 00 00 	movl   $0xfffffffe,0x80(%rsp)
  7ef92b:	fe ff ff ff 
  7ef92f:	b1 01                	mov    $0x1,%cl
  7ef931:	89 4c 24 4c          	mov    %ecx,0x4c(%rsp)
  7ef935:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  7ef93a:	e9 d7 01 00 00       	jmp    7efb16 <<gpui_canvas::text::planner::Planner>::shape+0x886>
  7ef93f:	49 89 c0             	mov    %rax,%r8
  7ef942:	89 c8                	mov    %ecx,%eax
  7ef944:	83 e0 1f             	and    $0x1f,%eax
  7ef947:	41 0f b6 79 01       	movzbl 0x1(%r9),%edi
  7ef94c:	83 e7 3f             	and    $0x3f,%edi
  7ef94f:	80 f9 e0             	cmp    $0xe0,%cl
  7ef952:	72 2d                	jb     7ef981 <<gpui_canvas::text::planner::Planner>::shape+0x6f1>
  7ef954:	41 0f b6 71 02       	movzbl 0x2(%r9),%esi
  7ef959:	c1 e7 06             	shl    $0x6,%edi
  7ef95c:	83 e6 3f             	and    $0x3f,%esi
  7ef95f:	09 fe                	or     %edi,%esi
  7ef961:	80 f9 f0             	cmp    $0xf0,%cl
  7ef964:	72 28                	jb     7ef98e <<gpui_canvas::text::planner::Planner>::shape+0x6fe>
  7ef966:	49 8d 51 04          	lea    0x4(%r9),%rdx
  7ef96a:	41 0f b6 49 03       	movzbl 0x3(%r9),%ecx
  7ef96f:	83 e0 07             	and    $0x7,%eax
  7ef972:	c1 e0 12             	shl    $0x12,%eax
  7ef975:	c1 e6 06             	shl    $0x6,%esi
  7ef978:	83 e1 3f             	and    $0x3f,%ecx
  7ef97b:	09 f1                	or     %esi,%ecx
  7ef97d:	09 c1                	or     %eax,%ecx
  7ef97f:	eb 18                	jmp    7ef999 <<gpui_canvas::text::planner::Planner>::shape+0x709>
  7ef981:	49 8d 51 02          	lea    0x2(%r9),%rdx
  7ef985:	c1 e0 06             	shl    $0x6,%eax
  7ef988:	09 f8                	or     %edi,%eax
  7ef98a:	89 c1                	mov    %eax,%ecx
  7ef98c:	eb 0b                	jmp    7ef999 <<gpui_canvas::text::planner::Planner>::shape+0x709>
  7ef98e:	49 8d 51 03          	lea    0x3(%r9),%rdx
  7ef992:	c1 e0 0c             	shl    $0xc,%eax
  7ef995:	09 c6                	or     %eax,%esi
  7ef997:	89 f1                	mov    %esi,%ecx
  7ef999:	4c 89 c0             	mov    %r8,%rax
  7ef99c:	49 89 c0             	mov    %rax,%r8
  7ef99f:	4c 29 c8             	sub    %r9,%rax
  7ef9a2:	48 01 d0             	add    %rdx,%rax
  7ef9a5:	c7 84 24 80 00 00 00 	movl   $0xfffffffe,0x80(%rsp)
  7ef9ac:	fe ff ff ff 
  7ef9b0:	40 b6 01             	mov    $0x1,%sil
  7ef9b3:	89 74 24 4c          	mov    %esi,0x4c(%rsp)
  7ef9b7:	83 f9 0c             	cmp    $0xc,%ecx
  7ef9ba:	7e 24                	jle    7ef9e0 <<gpui_canvas::text::planner::Planner>::shape+0x750>
  7ef9bc:	83 f9 0d             	cmp    $0xd,%ecx
  7ef9bf:	0f 84 5f 01 00 00    	je     7efb24 <<gpui_canvas::text::planner::Planner>::shape+0x894>
  7ef9c5:	81 f9 85 00 00 00    	cmp    $0x85,%ecx
  7ef9cb:	74 21                	je     7ef9ee <<gpui_canvas::text::planner::Planner>::shape+0x75e>
  7ef9cd:	81 f9 29 20 00 00    	cmp    $0x2029,%ecx
  7ef9d3:	74 19                	je     7ef9ee <<gpui_canvas::text::planner::Planner>::shape+0x75e>
  7ef9d5:	e9 83 00 00 00       	jmp    7efa5d <<gpui_canvas::text::planner::Planner>::shape+0x7cd>
  7ef9da:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  7ef9e0:	83 f9 ff             	cmp    $0xffffffff,%ecx
  7ef9e3:	0f 84 23 01 00 00    	je     7efb0c <<gpui_canvas::text::planner::Planner>::shape+0x87c>
  7ef9e9:	83 f9 0a             	cmp    $0xa,%ecx
  7ef9ec:	75 6f                	jne    7efa5d <<gpui_canvas::text::planner::Planner>::shape+0x7cd>
  7ef9ee:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
  7ef9f3:	81 f9 80 00 00 00    	cmp    $0x80,%ecx
  7ef9f9:	0f 83 36 01 00 00    	jae    7efb35 <<gpui_canvas::text::planner::Planner>::shape+0x8a5>
  7ef9ff:	49 8d 70 01          	lea    0x1(%r8),%rsi
  7efa03:	48 89 b4 24 90 00 00 	mov    %rsi,0x90(%rsp)
  7efa0a:	00 
  7efa0b:	83 f9 0d             	cmp    $0xd,%ecx
  7efa0e:	0f 85 3b 01 00 00    	jne    7efb4f <<gpui_canvas::text::planner::Planner>::shape+0x8bf>
  7efa14:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  7efa19:	4c 3b 8c 24 30 01 00 	cmp    0x130(%rsp),%r9
  7efa20:	00 
  7efa21:	0f 84 08 22 00 00    	je     7f1c2f <<gpui_canvas::text::planner::Planner>::shape+0x299f>
  7efa27:	45 0f b6 11          	movzbl (%r9),%r10d
  7efa2b:	45 84 d2             	test   %r10b,%r10b
  7efa2e:	0f 88 0b 22 00 00    	js     7f1c3f <<gpui_canvas::text::planner::Planner>::shape+0x29af>
  7efa34:	4d 8d 59 01          	lea    0x1(%r9),%r11
  7efa38:	e9 61 22 00 00       	jmp    7f1c9e <<gpui_canvas::text::planner::Planner>::shape+0x2a0e>
  7efa3d:	0f 1f 00             	nopl   (%rax)
  7efa40:	81 f9 29 20 00 00    	cmp    $0x2029,%ecx
  7efa46:	0f 84 dd 00 00 00    	je     7efb29 <<gpui_canvas::text::planner::Planner>::shape+0x899>
  7efa4c:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  7efa51:	81 f9 85 00 00 00    	cmp    $0x85,%ecx
  7efa57:	0f 84 cc 00 00 00    	je     7efb29 <<gpui_canvas::text::planner::Planner>::shape+0x899>
  7efa5d:	48 3b 94 24 30 01 00 	cmp    0x130(%rsp),%rdx
  7efa64:	00 
  7efa65:	0f 84 a1 00 00 00    	je     7efb0c <<gpui_canvas::text::planner::Planner>::shape+0x87c>
  7efa6b:	49 89 c0             	mov    %rax,%r8
  7efa6e:	0f b6 0a             	movzbl (%rdx),%ecx
  7efa71:	84 c9                	test   %cl,%cl
  7efa73:	78 0b                	js     7efa80 <<gpui_canvas::text::planner::Planner>::shape+0x7f0>
  7efa75:	48 8d 42 01          	lea    0x1(%rdx),%rax
  7efa79:	eb 65                	jmp    7efae0 <<gpui_canvas::text::planner::Planner>::shape+0x850>
  7efa7b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  7efa80:	89 c8                	mov    %ecx,%eax
  7efa82:	83 e0 1f             	and    $0x1f,%eax
  7efa85:	0f b6 7a 01          	movzbl 0x1(%rdx),%edi
  7efa89:	83 e7 3f             	and    $0x3f,%edi
  7efa8c:	80 f9 df             	cmp    $0xdf,%cl
  7efa8f:	76 2e                	jbe    7efabf <<gpui_canvas::text::planner::Planner>::shape+0x82f>
  7efa91:	0f b6 72 02          	movzbl 0x2(%rdx),%esi
  7efa95:	c1 e7 06             	shl    $0x6,%edi
  7efa98:	83 e6 3f             	and    $0x3f,%esi
  7efa9b:	09 fe                	or     %edi,%esi
  7efa9d:	80 f9 f0             	cmp    $0xf0,%cl
  7efaa0:	72 2d                	jb     7efacf <<gpui_canvas::text::planner::Planner>::shape+0x83f>
  7efaa2:	48 8d 7a 04          	lea    0x4(%rdx),%rdi
  7efaa6:	0f b6 4a 03          	movzbl 0x3(%rdx),%ecx
  7efaaa:	83 e0 07             	and    $0x7,%eax
  7efaad:	c1 e0 12             	shl    $0x12,%eax
  7efab0:	c1 e6 06             	shl    $0x6,%esi
  7efab3:	83 e1 3f             	and    $0x3f,%ecx
  7efab6:	09 f1                	or     %esi,%ecx
  7efab8:	09 c1                	or     %eax,%ecx
  7efaba:	48 89 f8             	mov    %rdi,%rax
  7efabd:	eb 21                	jmp    7efae0 <<gpui_canvas::text::planner::Planner>::shape+0x850>
  7efabf:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  7efac3:	c1 e0 06             	shl    $0x6,%eax
  7efac6:	09 f8                	or     %edi,%eax
  7efac8:	89 c1                	mov    %eax,%ecx
  7efaca:	48 89 f0             	mov    %rsi,%rax
  7efacd:	eb 11                	jmp    7efae0 <<gpui_canvas::text::planner::Planner>::shape+0x850>
  7efacf:	48 8d 4a 03          	lea    0x3(%rdx),%rcx
  7efad3:	c1 e0 0c             	shl    $0xc,%eax
  7efad6:	09 c6                	or     %eax,%esi
  7efad8:	48 89 c8             	mov    %rcx,%rax
  7efadb:	89 f1                	mov    %esi,%ecx
  7efadd:	0f 1f 00             	nopl   (%rax)
  7efae0:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  7efae5:	48 29 d0             	sub    %rdx,%rax
  7efae8:	4c 01 c0             	add    %r8,%rax
  7efaeb:	81 f9 84 00 00 00    	cmp    $0x84,%ecx
  7efaf1:	0f 8f 49 ff ff ff    	jg     7efa40 <<gpui_canvas::text::planner::Planner>::shape+0x7b0>
  7efaf7:	83 f9 0a             	cmp    $0xa,%ecx
  7efafa:	74 2d                	je     7efb29 <<gpui_canvas::text::planner::Planner>::shape+0x899>
  7efafc:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  7efb01:	83 f9 0d             	cmp    $0xd,%ecx
  7efb04:	0f 85 53 ff ff ff    	jne    7efa5d <<gpui_canvas::text::planner::Planner>::shape+0x7cd>
  7efb0a:	eb 1d                	jmp    7efb29 <<gpui_canvas::text::planner::Planner>::shape+0x899>
  7efb0c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  7efb11:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
  7efb16:	48 8b 14 24          	mov    (%rsp),%rdx
  7efb1a:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  7efb21:	00 
  7efb22:	eb 3a                	jmp    7efb5e <<gpui_canvas::text::planner::Planner>::shape+0x8ce>
  7efb24:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
  7efb29:	81 f9 80 00 00 00    	cmp    $0x80,%ecx
  7efb2f:	0f 82 ca fe ff ff    	jb     7ef9ff <<gpui_canvas::text::planner::Planner>::shape+0x76f>
  7efb35:	81 f9 00 08 00 00    	cmp    $0x800,%ecx
  7efb3b:	b9 03 00 00 00       	mov    $0x3,%ecx
  7efb40:	48 83 d9 00          	sbb    $0x0,%rcx
  7efb44:	4c 01 c1             	add    %r8,%rcx
  7efb47:	48 89 8c 24 90 00 00 	mov    %rcx,0x90(%rsp)
  7efb4e:	00 
  7efb4f:	c7 44 24 4c 00 00 00 	movl   $0x0,0x4c(%rsp)
  7efb56:	00 
  7efb57:	4c 89 c1             	mov    %r8,%rcx
  7efb5a:	48 8b 14 24          	mov    (%rsp),%rdx
  7efb5e:	49 89 c8             	mov    %rcx,%r8
  7efb61:	49 29 d0             	sub    %rdx,%r8
  7efb64:	0f 82 96 2c 00 00    	jb     7f2800 <<gpui_canvas::text::planner::Planner>::shape+0x3570>
  7efb6a:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
  7efb6f:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  7efb76:	00 
  7efb77:	74 2d                	je     7efba6 <<gpui_canvas::text::planner::Planner>::shape+0x916>
  7efb79:	48 8b 14 24          	mov    (%rsp),%rdx
  7efb7d:	48 3b 54 24 60       	cmp    0x60(%rsp),%rdx
  7efb82:	73 1c                	jae    7efba0 <<gpui_canvas::text::planner::Planner>::shape+0x910>
  7efb84:	48 8b 84 24 28 01 00 	mov    0x128(%rsp),%rax
  7efb8b:	00 
  7efb8c:	80 3c 10 bf          	cmpb   $0xbf,(%rax,%rdx,1)
  7efb90:	7f 14                	jg     7efba6 <<gpui_canvas::text::planner::Planner>::shape+0x916>
  7efb92:	e9 69 2c 00 00       	jmp    7f2800 <<gpui_canvas::text::planner::Planner>::shape+0x3570>
  7efb97:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  7efb9e:	00 00 
  7efba0:	0f 85 5a 2c 00 00    	jne    7f2800 <<gpui_canvas::text::planner::Planner>::shape+0x3570>
  7efba6:	48 85 c9             	test   %rcx,%rcx
  7efba9:	74 2b                	je     7efbd6 <<gpui_canvas::text::planner::Planner>::shape+0x946>
  7efbab:	48 3b 4c 24 60       	cmp    0x60(%rsp),%rcx
  7efbb0:	73 1e                	jae    7efbd0 <<gpui_canvas::text::planner::Planner>::shape+0x940>
  7efbb2:	48 8b 84 24 28 01 00 	mov    0x128(%rsp),%rax
  7efbb9:	00 
  7efbba:	80 3c 08 c0          	cmpb   $0xc0,(%rax,%rcx,1)
  7efbbe:	7d 16                	jge    7efbd6 <<gpui_canvas::text::planner::Planner>::shape+0x946>
  7efbc0:	e9 3b 2c 00 00       	jmp    7f2800 <<gpui_canvas::text::planner::Planner>::shape+0x3570>
  7efbc5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  7efbcc:	00 00 00 00 
  7efbd0:	0f 85 2a 2c 00 00    	jne    7f2800 <<gpui_canvas::text::planner::Planner>::shape+0x3570>
  7efbd6:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  7efbdb:	48 8b 84 24 28 01 00 	mov    0x128(%rsp),%rax
  7efbe2:	00 
  7efbe3:	48 8b 0c 24          	mov    (%rsp),%rcx
  7efbe7:	48 01 c1             	add    %rax,%rcx
  7efbea:	48 8d bc 24 58 04 00 	lea    0x458(%rsp),%rdi
  7efbf1:	00 
  7efbf2:	48 8b b4 24 60 03 00 	mov    0x360(%rsp),%rsi
  7efbf9:	00 
  7efbfa:	48 8b 94 24 58 03 00 	mov    0x358(%rsp),%rdx
  7efc01:	00 
  7efc02:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  7efc07:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
  7efc0c:	f3 0f 10 05 6c fb 90 	movss  -0x6f0494(%rip),%xmm0        # ff780 <anon.54edef65de96b8e67cbd7be652d99b9c.303.llvm.8229078508888877484+0x1c>
  7efc13:	ff 
  7efc14:	45 31 c9             	xor    %r9d,%r9d
  7efc17:	e8 54 24 01 00       	call   802070 <<parley::context::LayoutContext<()>>::ranged_builder>
  7efc1c:	48 8d bc 24 58 04 00 	lea    0x458(%rsp),%rdi
  7efc23:	00 
  7efc24:	48 8d b4 24 88 02 00 	lea    0x288(%rsp),%rsi
  7efc2b:	00 
  7efc2c:	48 8b 94 24 f8 01 00 	mov    0x1f8(%rsp),%rdx
  7efc33:	00 
  7efc34:	e8 27 d4 01 00       	call   80d060 <<parley::builder::RangedBuilder<()>>::push_default::<&[parlance::font_family::FontFamilyName]>>
  7efc39:	4c 8b bc 24 58 04 00 	mov    0x458(%rsp),%r15
  7efc40:	00 
  7efc41:	4c 8b ac 24 60 04 00 	mov    0x460(%rsp),%r13
  7efc48:	00 
  7efc49:	49 8d b7 30 02 00 00 	lea    0x230(%r15),%rsi
  7efc50:	c6 84 24 d0 06 00 00 	movb   $0x1,0x6d0(%rsp)
  7efc57:	01 
  7efc58:	f3 0f 10 84 24 84 00 	movss  0x84(%rsp),%xmm0
  7efc5f:	00 00 
  7efc61:	f3 0f 11 84 24 d4 06 	movss  %xmm0,0x6d4(%rsp)
  7efc68:	00 00 
  7efc6a:	f3 0f 10 84 24 78 04 	movss  0x478(%rsp),%xmm0
  7efc71:	00 00 
  7efc73:	48 8d bc 24 80 04 00 	lea    0x480(%rsp),%rdi
  7efc7a:	00 
  7efc7b:	48 89 f5             	mov    %rsi,%rbp
  7efc7e:	4c 89 ea             	mov    %r13,%rdx
  7efc81:	48 8d 9c 24 d0 06 00 	lea    0x6d0(%rsp),%rbx
  7efc88:	00 
  7efc89:	48 89 d9             	mov    %rbx,%rcx
  7efc8c:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
  7efc92:	e8 a9 9b ff ff       	call   7e9840 <<parley::resolve::ResolveContext>::resolve_property::<()>>
  7efc97:	48 89 df             	mov    %rbx,%rdi
  7efc9a:	e8 71 d4 01 00       	call   80d110 <core::ptr::drop_glue::<parley::style::StyleProperty<()>>>
  7efc9f:	49 83 bf 20 05 00 00 	cmpq   $0xffffffffffffffff,0x520(%r15)
  7efca6:	ff 
  7efca7:	0f 84 7d 24 00 00    	je     7f212a <<gpui_canvas::text::planner::Planner>::shape+0x2e9a>
  7efcad:	49 8d 9f 98 04 00 00 	lea    0x498(%r15),%rbx
  7efcb4:	48 89 df             	mov    %rbx,%rdi
  7efcb7:	48 8d b4 24 80 04 00 	lea    0x480(%rsp),%rsi
  7efcbe:	00 
  7efcbf:	e8 1c a1 ff ff       	call   7e9de0 <<parley::resolve::ResolvedStyle<()>>::apply>
  7efcc4:	66 c7 84 24 d0 06 00 	movw   $0x117,0x6d0(%rsp)
  7efccb:	00 17 01 
  7efcce:	48 8d bc 24 80 04 00 	lea    0x480(%rsp),%rdi
  7efcd5:	00 
  7efcd6:	48 89 ee             	mov    %rbp,%rsi
  7efcd9:	4c 89 ea             	mov    %r13,%rdx
  7efcdc:	4c 8d ac 24 d0 06 00 	lea    0x6d0(%rsp),%r13
  7efce3:	00 
  7efce4:	4c 89 e9             	mov    %r13,%rcx
  7efce7:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  7efced:	e8 4e 9b ff ff       	call   7e9840 <<parley::resolve::ResolveContext>::resolve_property::<()>>
  7efcf2:	4c 89 ef             	mov    %r13,%rdi
  7efcf5:	e8 16 d4 01 00       	call   80d110 <core::ptr::drop_glue::<parley::style::StyleProperty<()>>>
  7efcfa:	49 83 bf 20 05 00 00 	cmpq   $0xffffffffffffffff,0x520(%r15)
  7efd01:	ff 
  7efd02:	0f 84 22 24 00 00    	je     7f212a <<gpui_canvas::text::planner::Planner>::shape+0x2e9a>
  7efd08:	48 89 df             	mov    %rbx,%rdi
  7efd0b:	48 8d b4 24 80 04 00 	lea    0x480(%rsp),%rsi
  7efd12:	00 
  7efd13:	e8 c8 a0 ff ff       	call   7e9de0 <<parley::resolve::ResolvedStyle<()>>::apply>
  7efd18:	48 8d bc 24 58 04 00 	lea    0x458(%rsp),%rdi
  7efd1f:	00 
  7efd20:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  7efd25:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  7efd2a:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  7efd2f:	e8 7c 9c 01 00       	call   8099b0 <<parley::builder::RangedBuilder<()>>::build_into::<&str>>
  7efd34:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7efd3b:	00 
  7efd3c:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  7efd41:	e8 8a 93 01 00       	call   8090d0 <<parley::layout::line_break::BreakLines<()>>::new>
  7efd46:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7efd4d:	00 
  7efd4e:	f3 0f 10 84 24 9c 01 	movss  0x19c(%rsp),%xmm0
  7efd55:	00 00 
  7efd57:	e8 54 84 01 00       	call   8081b0 <<parley::layout::line_break::BreakLines<()>>::break_remaining>
  7efd5c:	80 bc 24 1c 02 00 00 	cmpb   $0x0,0x21c(%rsp)
  7efd63:	00 
  7efd64:	74 1a                	je     7efd80 <<gpui_canvas::text::planner::Planner>::shape+0xaf0>
  7efd66:	48 83 bc 24 38 01 00 	cmpq   $0xffffffffffffffff,0x138(%rsp)
  7efd6d:	00 ff 
  7efd6f:	0f 85 0e 02 00 00    	jne    7eff83 <<gpui_canvas::text::planner::Planner>::shape+0xcf3>
  7efd75:	31 c0                	xor    %eax,%eax
  7efd77:	e9 8a 01 00 00       	jmp    7eff06 <<gpui_canvas::text::planner::Planner>::shape+0xc76>
  7efd7c:	0f 1f 40 00          	nopl   0x0(%rax)
  7efd80:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
  7efd85:	0f 85 65 01 00 00    	jne    7efef0 <<gpui_canvas::text::planner::Planner>::shape+0xc60>
  7efd8b:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  7efd90:	48 3b 44 24 60       	cmp    0x60(%rsp),%rax
  7efd95:	0f 85 55 01 00 00    	jne    7efef0 <<gpui_canvas::text::planner::Planner>::shape+0xc60>
  7efd9b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7efda0:	48 83 b8 e0 09 00 00 	cmpq   $0x1,0x9e0(%rax)
  7efda7:	01 
  7efda8:	0f 85 42 01 00 00    	jne    7efef0 <<gpui_canvas::text::planner::Planner>::shape+0xc60>
  7efdae:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  7efdb3:	48 8b 82 d8 09 00 00 	mov    0x9d8(%rdx),%rax
  7efdba:	48 8d 48 70          	lea    0x70(%rax),%rcx
  7efdbe:	48 89 8c 24 d8 06 00 	mov    %rcx,0x6d8(%rsp)
  7efdc5:	00 
  7efdc6:	48 c7 84 24 e0 06 00 	movq   $0x0,0x6e0(%rsp)
  7efdcd:	00 00 00 00 00 
  7efdd2:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  7efdd7:	48 89 b4 24 e8 06 00 	mov    %rsi,0x6e8(%rsp)
  7efdde:	00 
  7efddf:	48 c7 84 24 18 07 00 	movq   $0x0,0x718(%rsp)
  7efde6:	00 00 00 00 00 
  7efdeb:	48 89 94 24 80 04 00 	mov    %rdx,0x480(%rsp)
  7efdf2:	00 
  7efdf3:	48 c7 84 24 f0 06 00 	movq   $0x0,0x6f0(%rsp)
  7efdfa:	00 00 00 00 00 
  7efdff:	48 89 8c 24 d0 06 00 	mov    %rcx,0x6d0(%rsp)
  7efe06:	00 
  7efe07:	48 8b 78 10          	mov    0x10(%rax),%rdi
  7efe0b:	48 8b 70 18          	mov    0x18(%rax),%rsi
  7efe0f:	48 8b 92 f8 09 00 00 	mov    0x9f8(%rdx),%rdx
  7efe16:	48 39 fe             	cmp    %rdi,%rsi
  7efe19:	0f 82 8c 26 00 00    	jb     7f24ab <<gpui_canvas::text::planner::Planner>::shape+0x321b>
  7efe1f:	48 39 d6             	cmp    %rdx,%rsi
  7efe22:	0f 87 83 26 00 00    	ja     7f24ab <<gpui_canvas::text::planner::Planner>::shape+0x321b>
  7efe28:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7efe2d:	48 8b 80 f0 09 00 00 	mov    0x9f0(%rax),%rax
  7efe34:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  7efe38:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
  7efe3c:	48 8d 14 b6          	lea    (%rsi,%rsi,4),%rdx
  7efe40:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
  7efe44:	48 89 8c 24 f0 06 00 	mov    %rcx,0x6f0(%rsp)
  7efe4b:	00 
  7efe4c:	48 89 84 24 f8 06 00 	mov    %rax,0x6f8(%rsp)
  7efe53:	00 
  7efe54:	48 c7 84 24 00 07 00 	movq   $0x0,0x700(%rsp)
  7efe5b:	00 00 00 00 00 
  7efe60:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  7efe65:	48 89 84 24 08 07 00 	mov    %rax,0x708(%rsp)
  7efe6c:	00 
  7efe6d:	c7 84 24 10 07 00 00 	movl   $0x0,0x710(%rsp)
  7efe74:	00 00 00 00 
  7efe78:	48 8d bc 24 f0 06 00 	lea    0x6f0(%rsp),%rdi
  7efe7f:	00 
  7efe80:	48 8d b4 24 18 07 00 	lea    0x718(%rsp),%rsi
  7efe87:	00 
  7efe88:	48 8d 94 24 80 04 00 	lea    0x480(%rsp),%rdx
  7efe8f:	00 
  7efe90:	e8 2b e7 00 00       	call   7fe5c0 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>>
  7efe95:	48 c7 84 24 e0 06 00 	movq   $0x1,0x6e0(%rsp)
  7efe9c:	00 01 00 00 00 
  7efea1:	84 c0                	test   %al,%al
  7efea3:	75 4b                	jne    7efef0 <<gpui_canvas::text::planner::Planner>::shape+0xc60>
  7efea5:	48 c7 84 24 f0 06 00 	movq   $0x0,0x6f0(%rsp)
  7efeac:	00 00 00 00 00 
  7efeb1:	48 83 bc 24 18 07 00 	cmpq   $0x0,0x718(%rsp)
  7efeb8:	00 00 
  7efeba:	0f 84 f3 1c 00 00    	je     7f1bb3 <<gpui_canvas::text::planner::Planner>::shape+0x2923>
  7efec0:	48 8d bc 24 18 07 00 	lea    0x718(%rsp),%rdi
  7efec7:	00 
  7efec8:	48 8d b4 24 40 07 00 	lea    0x740(%rsp),%rsi
  7efecf:	00 
  7efed0:	48 8d 94 24 80 04 00 	lea    0x480(%rsp),%rdx
  7efed7:	00 
  7efed8:	e8 e3 e6 00 00       	call   7fe5c0 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>>
  7efedd:	84 c0                	test   %al,%al
  7efedf:	0f 84 ce 1c 00 00    	je     7f1bb3 <<gpui_canvas::text::planner::Planner>::shape+0x2923>
  7efee5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  7efeec:	00 00 00 00 
  7efef0:	48 83 bc 24 38 01 00 	cmpq   $0xffffffffffffffff,0x138(%rsp)
  7efef7:	00 ff 
  7efef9:	0f 85 84 00 00 00    	jne    7eff83 <<gpui_canvas::text::planner::Planner>::shape+0xcf3>
  7efeff:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  7eff06:	48 c7 84 24 38 01 00 	movq   $0x0,0x138(%rsp)
  7eff0d:	00 00 00 00 00 
  7eff12:	48 c7 84 24 40 01 00 	movq   $0x4,0x140(%rsp)
  7eff19:	00 04 00 00 00 
  7eff1e:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  7eff25:	00 
  7eff26:	0f 57 c0             	xorps  %xmm0,%xmm0
  7eff29:	0f 11 41 08          	movups %xmm0,0x8(%rcx)
  7eff2d:	48 c7 84 24 58 01 00 	movq   $0x4,0x158(%rsp)
  7eff34:	00 04 00 00 00 
  7eff39:	48 c7 84 24 60 01 00 	movq   $0x0,0x160(%rsp)
  7eff40:	00 00 00 00 00 
  7eff45:	48 89 84 24 68 01 00 	mov    %rax,0x168(%rsp)
  7eff4c:	00 
  7eff4d:	48 c7 84 24 70 01 00 	movq   $0x4,0x170(%rsp)
  7eff54:	00 04 00 00 00 
  7eff59:	48 c7 84 24 78 01 00 	movq   $0x0,0x178(%rsp)
  7eff60:	00 00 00 00 00 
  7eff65:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  7eff6a:	89 84 24 80 01 00 00 	mov    %eax,0x180(%rsp)
  7eff71:	f3 0f 10 84 24 84 00 	movss  0x84(%rsp),%xmm0
  7eff78:	00 00 
  7eff7a:	f3 0f 11 84 24 84 01 	movss  %xmm0,0x184(%rsp)
  7eff81:	00 00 
  7eff83:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7eff88:	48 8b 98 e0 09 00 00 	mov    0x9e0(%rax),%rbx
  7eff8f:	48 85 db             	test   %rbx,%rbx
  7eff92:	0f 84 08 01 00 00    	je     7f00a0 <<gpui_canvas::text::planner::Planner>::shape+0xe10>
  7eff98:	48 8b a8 d8 09 00 00 	mov    0x9d8(%rax),%rbp
  7eff9f:	45 31 ff             	xor    %r15d,%r15d
  7effa2:	45 31 ed             	xor    %r13d,%r13d
  7effa5:	eb 15                	jmp    7effbc <<gpui_canvas::text::planner::Planner>::shape+0xd2c>
  7effa7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  7effae:	00 00 
  7effb0:	49 ff c7             	inc    %r15
  7effb3:	49 39 df             	cmp    %rbx,%r15
  7effb6:	0f 84 e7 00 00 00    	je     7f00a3 <<gpui_canvas::text::planner::Planner>::shape+0xe13>
  7effbc:	49 6b c7 70          	imul   $0x70,%r15,%rax
  7effc0:	48 01 e8             	add    %rbp,%rax
  7effc3:	4c 89 ac 24 d0 06 00 	mov    %r13,0x6d0(%rsp)
  7effca:	00 
  7effcb:	48 c7 84 24 d8 06 00 	movq   $0x0,0x6d8(%rsp)
  7effd2:	00 00 00 00 00 
  7effd7:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  7effdc:	48 89 8c 24 e0 06 00 	mov    %rcx,0x6e0(%rsp)
  7effe3:	00 
  7effe4:	48 89 84 24 e8 06 00 	mov    %rax,0x6e8(%rsp)
  7effeb:	00 
  7effec:	44 89 bc 24 f0 06 00 	mov    %r15d,0x6f0(%rsp)
  7efff3:	00 
  7efff4:	c6 84 24 98 07 00 00 	movb   $0x2,0x798(%rsp)
  7efffb:	02 
  7efffc:	c7 84 24 a0 07 00 00 	movl   $0x0,0x7a0(%rsp)
  7f0003:	00 00 00 00 
  7f0007:	48 8d bc 24 d0 02 00 	lea    0x2d0(%rsp),%rdi
  7f000e:	00 
  7f000f:	48 8d b4 24 d8 06 00 	lea    0x6d8(%rsp),%rsi
  7f0016:	00 
  7f0017:	e8 34 b3 00 00       	call   7fb350 <<parley::layout::line::GlyphRunIter<()> as core::iter::traits::iterator::Iterator>::next>
  7f001c:	83 bc 24 d0 02 00 00 	cmpl   $0x1,0x2d0(%rsp)
  7f0023:	01 
  7f0024:	75 8a                	jne    7effb0 <<gpui_canvas::text::planner::Planner>::shape+0xd20>
  7f0026:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  7f002d:	00 00 00 
  7f0030:	49 8b 46 38          	mov    0x38(%r14),%rax
  7f0034:	49 89 44 24 40       	mov    %rax,0x40(%r12)
  7f0039:	41 0f 10 46 f8       	movups -0x8(%r14),%xmm0
  7f003e:	41 0f 10 4e 08       	movups 0x8(%r14),%xmm1
  7f0043:	41 0f 10 56 18       	movups 0x18(%r14),%xmm2
  7f0048:	41 0f 10 5e 28       	movups 0x28(%r14),%xmm3
  7f004d:	41 0f 11 5c 24 30    	movups %xmm3,0x30(%r12)
  7f0053:	41 0f 11 54 24 20    	movups %xmm2,0x20(%r12)
  7f0059:	41 0f 11 4c 24 10    	movups %xmm1,0x10(%r12)
  7f005f:	41 0f 11 04 24       	movups %xmm0,(%r12)
  7f0064:	4c 89 ac 24 80 04 00 	mov    %r13,0x480(%rsp)
  7f006b:	00 
  7f006c:	4c 89 ee             	mov    %r13,%rsi
  7f006f:	4c 89 e2             	mov    %r12,%rdx
  7f0072:	e8 99 f2 00 00       	call   7ff310 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut>
  7f0077:	49 89 c5             	mov    %rax,%r13
  7f007a:	48 8d bc 24 d0 02 00 	lea    0x2d0(%rsp),%rdi
  7f0081:	00 
  7f0082:	48 8d b4 24 d8 06 00 	lea    0x6d8(%rsp),%rsi
  7f0089:	00 
  7f008a:	e8 c1 b2 00 00       	call   7fb350 <<parley::layout::line::GlyphRunIter<()> as core::iter::traits::iterator::Iterator>::next>
  7f008f:	80 bc 24 d0 02 00 00 	cmpb   $0x0,0x2d0(%rsp)
  7f0096:	00 
  7f0097:	75 97                	jne    7f0030 <<gpui_canvas::text::planner::Planner>::shape+0xda0>
  7f0099:	e9 12 ff ff ff       	jmp    7effb0 <<gpui_canvas::text::planner::Planner>::shape+0xd20>
  7f009e:	66 90                	xchg   %ax,%ax
  7f00a0:	45 31 ed             	xor    %r13d,%r13d
  7f00a3:	48 8b b4 24 f8 00 00 	mov    0xf8(%rsp),%rsi
  7f00aa:	00 
  7f00ab:	48 89 f0             	mov    %rsi,%rax
  7f00ae:	4c 01 e8             	add    %r13,%rax
  7f00b1:	0f 92 c1             	setb   %cl
  7f00b4:	48 3d 01 80 00 00    	cmp    $0x8001,%rax
  7f00ba:	0f 93 c0             	setae  %al
  7f00bd:	08 c8                	or     %cl,%al
  7f00bf:	0f 85 95 1c 00 00    	jne    7f1d5a <<gpui_canvas::text::planner::Planner>::shape+0x2aca>
  7f00c5:	48 8b 2c 24          	mov    (%rsp),%rbp
  7f00c9:	48 39 6c 24 50       	cmp    %rbp,0x50(%rsp)
  7f00ce:	74 14                	je     7f00e4 <<gpui_canvas::text::planner::Planner>::shape+0xe54>
  7f00d0:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  7f00d7:	00 
  7f00d8:	48 29 f0             	sub    %rsi,%rax
  7f00db:	49 39 c5             	cmp    %rax,%r13
  7f00de:	0f 87 10 1c 00 00    	ja     7f1cf4 <<gpui_canvas::text::planner::Planner>::shape+0x2a64>
  7f00e4:	48 85 ed             	test   %rbp,%rbp
  7f00e7:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
  7f00ec:	74 2b                	je     7f0119 <<gpui_canvas::text::planner::Planner>::shape+0xe89>
  7f00ee:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f00f1:	f3 0f 11 84 24 d8 00 	movss  %xmm0,0xd8(%rsp)
  7f00f8:	00 00 
  7f00fa:	48 39 eb             	cmp    %rbp,%rbx
  7f00fd:	75 51                	jne    7f0150 <<gpui_canvas::text::planner::Planner>::shape+0xec0>
  7f00ff:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  7f0104:	48 8b 81 e0 09 00 00 	mov    0x9e0(%rcx),%rax
  7f010b:	48 85 c0             	test   %rax,%rax
  7f010e:	0f 85 80 00 00 00    	jne    7f0194 <<gpui_canvas::text::planner::Planner>::shape+0xf04>
  7f0114:	e9 87 14 00 00       	jmp    7f15a0 <<gpui_canvas::text::planner::Planner>::shape+0x2310>
  7f0119:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7f011e:	48 83 b8 e0 09 00 00 	cmpq   $0x0,0x9e0(%rax)
  7f0125:	00 
  7f0126:	74 0e                	je     7f0136 <<gpui_canvas::text::planner::Planner>::shape+0xea6>
  7f0128:	48 8b 80 d8 09 00 00 	mov    0x9d8(%rax),%rax
  7f012f:	f3 0f 10 40 24       	movss  0x24(%rax),%xmm0
  7f0134:	eb 03                	jmp    7f0139 <<gpui_canvas::text::planner::Planner>::shape+0xea9>
  7f0136:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f0139:	f3 0f 11 44 24 7c    	movss  %xmm0,0x7c(%rsp)
  7f013f:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f0142:	f3 0f 11 84 24 d8 00 	movss  %xmm0,0xd8(%rsp)
  7f0149:	00 00 
  7f014b:	48 39 eb             	cmp    %rbp,%rbx
  7f014e:	74 af                	je     7f00ff <<gpui_canvas::text::planner::Planner>::shape+0xe6f>
  7f0150:	83 bc 24 98 01 00 00 	cmpl   $0x0,0x198(%rsp)
  7f0157:	00 
  7f0158:	74 0f                	je     7f0169 <<gpui_canvas::text::planner::Planner>::shape+0xed9>
  7f015a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7f015f:	f3 0f 10 80 28 0a 00 	movss  0xa28(%rax),%xmm0
  7f0166:	00 
  7f0167:	eb 0d                	jmp    7f0176 <<gpui_canvas::text::planner::Planner>::shape+0xee6>
  7f0169:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7f016e:	f3 0f 10 80 2c 0a 00 	movss  0xa2c(%rax),%xmm0
  7f0175:	00 
  7f0176:	f3 0f 11 84 24 d8 00 	movss  %xmm0,0xd8(%rsp)
  7f017d:	00 00 
  7f017f:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  7f0184:	48 8b 81 e0 09 00 00 	mov    0x9e0(%rcx),%rax
  7f018b:	48 85 c0             	test   %rax,%rax
  7f018e:	0f 84 0c 14 00 00    	je     7f15a0 <<gpui_canvas::text::planner::Planner>::shape+0x2310>
  7f0194:	48 8b 89 d8 09 00 00 	mov    0x9d8(%rcx),%rcx
  7f019b:	48 6b c0 70          	imul   $0x70,%rax,%rax
  7f019f:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  7f01a6:	00 
  7f01a7:	48 01 c8             	add    %rcx,%rax
  7f01aa:	48 89 84 24 40 03 00 	mov    %rax,0x340(%rsp)
  7f01b1:	00 
  7f01b2:	c7 44 24 78 00 00 00 	movl   $0x0,0x78(%rsp)
  7f01b9:	00 
  7f01ba:	48 83 bc 24 38 01 00 	cmpq   $0xffffffffffffffff,0x138(%rsp)
  7f01c1:	00 ff 
  7f01c3:	74 2e                	je     7f01f3 <<gpui_canvas::text::planner::Planner>::shape+0xf63>
  7f01c5:	48 39 eb             	cmp    %rbp,%rbx
  7f01c8:	75 3c                	jne    7f0206 <<gpui_canvas::text::planner::Planner>::shape+0xf76>
  7f01ca:	45 31 ed             	xor    %r13d,%r13d
  7f01cd:	45 31 ff             	xor    %r15d,%r15d
  7f01d0:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  7f01d7:	00 
  7f01d8:	48 8b 8c 24 60 01 00 	mov    0x160(%rsp),%rcx
  7f01df:	00 
  7f01e0:	48 89 8c 24 38 02 00 	mov    %rcx,0x238(%rsp)
  7f01e7:	00 
  7f01e8:	80 78 68 02          	cmpb   $0x2,0x68(%rax)
  7f01ec:	74 41                	je     7f022f <<gpui_canvas::text::planner::Planner>::shape+0xf9f>
  7f01ee:	e9 d6 01 00 00       	jmp    7f03c9 <<gpui_canvas::text::planner::Planner>::shape+0x1139>
  7f01f3:	8b 4c 24 78          	mov    0x78(%rsp),%ecx
  7f01f7:	89 c8                	mov    %ecx,%eax
  7f01f9:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
  7f0200:	00 
  7f0201:	e9 df 03 00 00       	jmp    7f05e5 <<gpui_canvas::text::planner::Planner>::shape+0x1355>
  7f0206:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  7f020d:	00 
  7f020e:	4c 8b 38             	mov    (%rax),%r15
  7f0211:	4c 8b 68 08          	mov    0x8(%rax),%r13
  7f0215:	48 8b 8c 24 60 01 00 	mov    0x160(%rsp),%rcx
  7f021c:	00 
  7f021d:	48 89 8c 24 38 02 00 	mov    %rcx,0x238(%rsp)
  7f0224:	00 
  7f0225:	80 78 68 02          	cmpb   $0x2,0x68(%rax)
  7f0229:	0f 85 9a 01 00 00    	jne    7f03c9 <<gpui_canvas::text::planner::Planner>::shape+0x1139>
  7f022f:	48 8b 78 10          	mov    0x10(%rax),%rdi
  7f0233:	48 8b 70 18          	mov    0x18(%rax),%rsi
  7f0237:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7f023c:	48 8b 90 f8 09 00 00 	mov    0x9f8(%rax),%rdx
  7f0243:	48 39 fe             	cmp    %rdi,%rsi
  7f0246:	0f 82 71 22 00 00    	jb     7f24bd <<gpui_canvas::text::planner::Planner>::shape+0x322d>
  7f024c:	48 39 d6             	cmp    %rdx,%rsi
  7f024f:	0f 87 68 22 00 00    	ja     7f24bd <<gpui_canvas::text::planner::Planner>::shape+0x322d>
  7f0255:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7f025a:	48 8b 80 f0 09 00 00 	mov    0x9f0(%rax),%rax
  7f0261:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  7f0265:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
  7f0269:	48 8d 14 b6          	lea    (%rsi,%rsi,4),%rdx
  7f026d:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
  7f0271:	48 89 8c 24 80 04 00 	mov    %rcx,0x480(%rsp)
  7f0278:	00 
  7f0279:	48 89 84 24 88 04 00 	mov    %rax,0x488(%rsp)
  7f0280:	00 
  7f0281:	48 c7 84 24 90 04 00 	movq   $0x0,0x490(%rsp)
  7f0288:	00 00 00 00 00 
  7f028d:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  7f0292:	48 89 84 24 98 04 00 	mov    %rax,0x498(%rsp)
  7f0299:	00 
  7f029a:	8b 44 24 78          	mov    0x78(%rsp),%eax
  7f029e:	89 84 24 a0 04 00 00 	mov    %eax,0x4a0(%rsp)
  7f02a5:	c6 84 24 c0 06 00 00 	movb   $0x2,0x6c0(%rsp)
  7f02ac:	02 
  7f02ad:	48 8d 84 24 c8 06 00 	lea    0x6c8(%rsp),%rax
  7f02b4:	00 
  7f02b5:	48 89 84 24 d0 02 00 	mov    %rax,0x2d0(%rsp)
  7f02bc:	00 
  7f02bd:	c6 84 24 b0 05 00 00 	movb   $0x2,0x5b0(%rsp)
  7f02c4:	02 
  7f02c5:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f02cc:	00 
  7f02cd:	48 8d b4 24 80 04 00 	lea    0x480(%rsp),%rsi
  7f02d4:	00 
  7f02d5:	48 8d 94 24 d0 02 00 	lea    0x2d0(%rsp),%rdx
  7f02dc:	00 
  7f02dd:	48 8d 8c 24 a8 04 00 	lea    0x4a8(%rsp),%rcx
  7f02e4:	00 
  7f02e5:	e8 56 da 00 00       	call   7fdd40 <<core::iter::adapters::map::Map<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>, gpui_canvas::text::planner::freeze_line::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::flatten::FlattenCompat<_, _>>::iter_try_fold::flatten<parley::layout::run::Clusters<()>, (), core::ops::control_flow::ControlFlow<parley::layout::cluster::Cluster<()>>, <core::iter::adapters::flatten::FlattenCompat<_, _> as core::iter::traits::iterator::Iterator>::try_fold::flatten<parley::layout::run::Clusters<()>, (), core::ops::control_flow::ControlFlow<parley::layout::cluster::Cluster<()>>, core::iter::traits::iterator::Iterator::find::check<parley::layout::cluster::Cluster<()>, &mut gpui_canvas::text::planner::freeze_line::{closure#1}>::{closure#0}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<parley::layout::cluster::Cluster<()>>>>
  7f02ea:	48 8b 8c 24 d0 06 00 	mov    0x6d0(%rsp),%rcx
  7f02f1:	00 
  7f02f2:	48 85 c9             	test   %rcx,%rcx
  7f02f5:	0f 84 b7 00 00 00    	je     7f03b2 <<gpui_canvas::text::planner::Planner>::shape+0x1122>
  7f02fb:	8b bc 24 f8 06 00 00 	mov    0x6f8(%rsp),%edi
  7f0302:	8b b4 24 50 07 00 00 	mov    0x750(%rsp),%esi
  7f0309:	8b 94 24 54 07 00 00 	mov    0x754(%rsp),%edx
  7f0310:	48 8b 41 58          	mov    0x58(%rcx),%rax
  7f0314:	48 39 f8             	cmp    %rdi,%rax
  7f0317:	0f 86 ca 25 00 00    	jbe    7f28e7 <<gpui_canvas::text::planner::Planner>::shape+0x3657>
  7f031d:	48 8b 41 50          	mov    0x50(%rcx),%rax
  7f0321:	48 8d 3c ff          	lea    (%rdi,%rdi,8),%rdi
  7f0325:	48 c1 e7 04          	shl    $0x4,%rdi
  7f0329:	0f 10 41 68          	movups 0x68(%rcx),%xmm0
  7f032d:	0f 10 89 80 00 00 00 	movups 0x80(%rcx),%xmm1
  7f0334:	0f 10 91 98 00 00 00 	movups 0x98(%rcx),%xmm2
  7f033b:	0f 11 84 24 d0 06 00 	movups %xmm0,0x6d0(%rsp)
  7f0342:	00 
  7f0343:	0f 11 8c 24 e0 06 00 	movups %xmm1,0x6e0(%rsp)
  7f034a:	00 
  7f034b:	0f 11 94 24 f0 06 00 	movups %xmm2,0x6f0(%rsp)
  7f0352:	00 
  7f0353:	48 8b 44 38 50       	mov    0x50(%rax,%rdi,1),%rax
  7f0358:	48 89 84 24 00 07 00 	mov    %rax,0x700(%rsp)
  7f035f:	00 
  7f0360:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f0367:	00 
  7f0368:	ff 15 02 e0 33 00    	call   *0x33e002(%rip)        # b2e370 <_DYNAMIC+0xe70>
  7f036e:	48 89 c3             	mov    %rax,%rbx
  7f0371:	ba 48 02 00 00       	mov    $0x248,%edx
  7f0376:	4c 89 7c 24 10       	mov    %r15,0x10(%rsp)
  7f037b:	4c 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%r15
  7f0382:	00 
  7f0383:	4c 89 ff             	mov    %r15,%rdi
  7f0386:	48 8d b4 24 80 04 00 	lea    0x480(%rsp),%rsi
  7f038d:	00 
  7f038e:	ff 15 dc d3 33 00    	call   *0x33d3dc(%rip)        # b2d770 <memcpy@GLIBC_2.14>
  7f0394:	4c 89 ff             	mov    %r15,%rdi
  7f0397:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  7f039c:	48 89 de             	mov    %rbx,%rsi
  7f039f:	e8 7c dc 00 00       	call   7fe020 <<core::iter::adapters::map::Map<core::iter::adapters::filter::Filter<core::iter::adapters::flatten::FlatMap<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>, parley::layout::run::Clusters<()>, gpui_canvas::text::planner::freeze_line::{closure#0}>, gpui_canvas::text::planner::freeze_line::{closure#1}>, gpui_canvas::text::planner::freeze_line::{closure#2}> as core::iter::traits::iterator::Iterator>::fold::<usize, core::iter::traits::iterator::Iterator::min_by::fold<usize, <usize as core::cmp::Ord>::cmp>::{closure#0}>>
  7f03a4:	4c 39 e8             	cmp    %r13,%rax
  7f03a7:	4c 0f 42 e8          	cmovb  %rax,%r13
  7f03ab:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
  7f03b0:	eb 17                	jmp    7f03c9 <<gpui_canvas::text::planner::Planner>::shape+0x1139>
  7f03b2:	80 bc 24 c0 06 00 00 	cmpb   $0x2,0x6c0(%rsp)
  7f03b9:	02 
  7f03ba:	c6 84 24 b0 05 00 00 	movb   $0x2,0x5b0(%rsp)
  7f03c1:	02 
  7f03c2:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
  7f03c7:	75 32                	jne    7f03fb <<gpui_canvas::text::planner::Planner>::shape+0x116b>
  7f03c9:	4d 39 ef             	cmp    %r13,%r15
  7f03cc:	0f 87 46 1b 00 00    	ja     7f1f18 <<gpui_canvas::text::planner::Planner>::shape+0x2c88>
  7f03d2:	4d 85 ff             	test   %r15,%r15
  7f03d5:	0f 84 b9 00 00 00    	je     7f0494 <<gpui_canvas::text::planner::Planner>::shape+0x1204>
  7f03db:	4c 3b 7c 24 20       	cmp    0x20(%rsp),%r15
  7f03e0:	0f 83 a8 00 00 00    	jae    7f048e <<gpui_canvas::text::planner::Planner>::shape+0x11fe>
  7f03e6:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7f03eb:	42 80 3c 38 bf       	cmpb   $0xbf,(%rax,%r15,1)
  7f03f0:	0f 8f 9e 00 00 00    	jg     7f0494 <<gpui_canvas::text::planner::Planner>::shape+0x1204>
  7f03f6:	e9 1d 1b 00 00       	jmp    7f1f18 <<gpui_canvas::text::planner::Planner>::shape+0x2c88>
  7f03fb:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f0402:	00 
  7f0403:	48 8d b4 24 b8 05 00 	lea    0x5b8(%rsp),%rsi
  7f040a:	00 
  7f040b:	e8 50 a8 00 00       	call   7fac60 <<parley::layout::run::Clusters<()>>::advance_cursor>
  7f0410:	83 bc 24 d0 06 00 00 	cmpl   $0x1,0x6d0(%rsp)
  7f0417:	01 
  7f0418:	75 af                	jne    7f03c9 <<gpui_canvas::text::planner::Planner>::shape+0x1139>
  7f041a:	48 83 bc 24 70 06 00 	cmpq   $0x0,0x670(%rsp)
  7f0421:	00 00 
  7f0423:	0f 84 a6 20 00 00    	je     7f24cf <<gpui_canvas::text::planner::Planner>::shape+0x323f>
  7f0429:	48 8b 8c 24 b8 05 00 	mov    0x5b8(%rsp),%rcx
  7f0430:	00 
  7f0431:	48 85 c9             	test   %rcx,%rcx
  7f0434:	74 93                	je     7f03c9 <<gpui_canvas::text::planner::Planner>::shape+0x1139>
  7f0436:	8b bc 24 e0 05 00 00 	mov    0x5e0(%rsp),%edi
  7f043d:	48 8b 41 58          	mov    0x58(%rcx),%rax
  7f0441:	48 39 f8             	cmp    %rdi,%rax
  7f0444:	0f 86 2d 24 00 00    	jbe    7f2877 <<gpui_canvas::text::planner::Planner>::shape+0x35e7>
  7f044a:	8b b4 24 d4 06 00 00 	mov    0x6d4(%rsp),%esi
  7f0451:	8b 94 24 d8 06 00 00 	mov    0x6d8(%rsp),%edx
  7f0458:	4c 8b 41 70          	mov    0x70(%rcx),%r8
  7f045c:	39 f2                	cmp    %esi,%edx
  7f045e:	0f 82 2c 20 00 00    	jb     7f2490 <<gpui_canvas::text::planner::Planner>::shape+0x3200>
  7f0464:	49 39 d0             	cmp    %rdx,%r8
  7f0467:	0f 82 23 20 00 00    	jb     7f2490 <<gpui_canvas::text::planner::Planner>::shape+0x3200>
  7f046d:	39 f2                	cmp    %esi,%edx
  7f046f:	0f 84 13 24 00 00    	je     7f2888 <<gpui_canvas::text::planner::Planner>::shape+0x35f8>
  7f0475:	4c 8b 41 68          	mov    0x68(%rcx),%r8
  7f0479:	4c 8d 0c 76          	lea    (%rsi,%rsi,2),%r9
  7f047d:	43 80 7c 88 07 06    	cmpb   $0x6,0x7(%r8,%r9,4)
  7f0483:	0f 85 72 ff ff ff    	jne    7f03fb <<gpui_canvas::text::planner::Planner>::shape+0x116b>
  7f0489:	e9 86 fe ff ff       	jmp    7f0314 <<gpui_canvas::text::planner::Planner>::shape+0x1084>
  7f048e:	0f 85 84 1a 00 00    	jne    7f1f18 <<gpui_canvas::text::planner::Planner>::shape+0x2c88>
  7f0494:	4d 85 ed             	test   %r13,%r13
  7f0497:	74 1e                	je     7f04b7 <<gpui_canvas::text::planner::Planner>::shape+0x1227>
  7f0499:	4c 3b 6c 24 20       	cmp    0x20(%rsp),%r13
  7f049e:	73 11                	jae    7f04b1 <<gpui_canvas::text::planner::Planner>::shape+0x1221>
  7f04a0:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7f04a5:	42 80 3c 28 c0       	cmpb   $0xc0,(%rax,%r13,1)
  7f04aa:	7d 0b                	jge    7f04b7 <<gpui_canvas::text::planner::Planner>::shape+0x1227>
  7f04ac:	e9 67 1a 00 00       	jmp    7f1f18 <<gpui_canvas::text::planner::Planner>::shape+0x2c88>
  7f04b1:	0f 85 61 1a 00 00    	jne    7f1f18 <<gpui_canvas::text::planner::Planner>::shape+0x2c88>
  7f04b7:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f04ba:	48 39 eb             	cmp    %rbp,%rbx
  7f04bd:	74 0d                	je     7f04cc <<gpui_canvas::text::planner::Planner>::shape+0x123c>
  7f04bf:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  7f04c6:	00 
  7f04c7:	f3 0f 10 40 30       	movss  0x30(%rax),%xmm0
  7f04cc:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
  7f04d2:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  7f04d9:	00 
  7f04da:	f3 0f 10 48 40       	movss  0x40(%rax),%xmm1
  7f04df:	f3 0f 10 40 44       	movss  0x44(%rax),%xmm0
  7f04e4:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  7f04eb:	00 
  7f04ec:	f3 0f 5d 48 48       	minss  0x48(%rax),%xmm1
  7f04f1:	0f 29 8c 24 70 02 00 	movaps %xmm1,0x270(%rsp)
  7f04f8:	00 
  7f04f9:	0f 29 84 24 b0 01 00 	movaps %xmm0,0x1b0(%rsp)
  7f0500:	00 
  7f0501:	f3 0f 5f 40 4c       	maxss  0x4c(%rax),%xmm0
  7f0506:	0f 29 84 24 d0 01 00 	movaps %xmm0,0x1d0(%rsp)
  7f050d:	00 
  7f050e:	f3 0f 10 40 24       	movss  0x24(%rax),%xmm0
  7f0513:	f3 0f 58 44 24 58    	addss  0x58(%rsp),%xmm0
  7f0519:	f3 0f 11 44 24 28    	movss  %xmm0,0x28(%rsp)
  7f051f:	48 8b 9c 24 60 01 00 	mov    0x160(%rsp),%rbx
  7f0526:	00 
  7f0527:	48 3b 9c 24 50 01 00 	cmp    0x150(%rsp),%rbx
  7f052e:	00 
  7f052f:	75 0e                	jne    7f053f <<gpui_canvas::text::planner::Planner>::shape+0x12af>
  7f0531:	48 8d bc 24 50 01 00 	lea    0x150(%rsp),%rdi
  7f0538:	00 
  7f0539:	ff 15 69 de 33 00    	call   *0x33de69(%rip)        # b2e3a8 <_DYNAMIC+0xea8>
  7f053f:	41 01 ef             	add    %ebp,%r15d
  7f0542:	41 01 ed             	add    %ebp,%r13d
  7f0545:	0f 28 94 24 70 02 00 	movaps 0x270(%rsp),%xmm2
  7f054c:	00 
  7f054d:	0f 28 c2             	movaps %xmm2,%xmm0
  7f0550:	f3 0f c2 c2 03       	cmpunordss %xmm2,%xmm0
  7f0555:	0f 28 c8             	movaps %xmm0,%xmm1
  7f0558:	0f 55 ca             	andnps %xmm2,%xmm1
  7f055b:	0f 54 84 24 00 01 00 	andps  0x100(%rsp),%xmm0
  7f0562:	00 
  7f0563:	0f 56 c1             	orps   %xmm1,%xmm0
  7f0566:	f3 0f 10 4c 24 58    	movss  0x58(%rsp),%xmm1
  7f056c:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  7f0570:	0f 28 a4 24 d0 01 00 	movaps 0x1d0(%rsp),%xmm4
  7f0577:	00 
  7f0578:	0f 28 d4             	movaps %xmm4,%xmm2
  7f057b:	f3 0f c2 d4 03       	cmpunordss %xmm4,%xmm2
  7f0580:	0f 28 da             	movaps %xmm2,%xmm3
  7f0583:	0f 55 dc             	andnps %xmm4,%xmm3
  7f0586:	0f 54 94 24 b0 01 00 	andps  0x1b0(%rsp),%xmm2
  7f058d:	00 
  7f058e:	0f 56 d3             	orps   %xmm3,%xmm2
  7f0591:	f3 0f 5c d0          	subss  %xmm0,%xmm2
  7f0595:	48 8b 84 24 58 01 00 	mov    0x158(%rsp),%rax
  7f059c:	00 
  7f059d:	48 8d 0c 5b          	lea    (%rbx,%rbx,2),%rcx
  7f05a1:	44 89 3c c8          	mov    %r15d,(%rax,%rcx,8)
  7f05a5:	44 89 6c c8 04       	mov    %r13d,0x4(%rax,%rcx,8)
  7f05aa:	f3 0f 11 4c c8 08    	movss  %xmm1,0x8(%rax,%rcx,8)
  7f05b0:	f3 0f 11 54 c8 0c    	movss  %xmm2,0xc(%rax,%rcx,8)
  7f05b6:	f3 0f 10 44 24 28    	movss  0x28(%rsp),%xmm0
  7f05bc:	f3 0f 11 44 c8 10    	movss  %xmm0,0x10(%rax,%rcx,8)
  7f05c2:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  7f05c8:	f3 0f 11 44 c8 14    	movss  %xmm0,0x14(%rax,%rcx,8)
  7f05ce:	48 ff c3             	inc    %rbx
  7f05d1:	48 89 9c 24 60 01 00 	mov    %rbx,0x160(%rsp)
  7f05d8:	00 
  7f05d9:	44 89 ac 24 04 02 00 	mov    %r13d,0x204(%rsp)
  7f05e0:	00 
  7f05e1:	8b 4c 24 78          	mov    0x78(%rsp),%ecx
  7f05e5:	48 c7 84 24 d0 06 00 	movq   $0x0,0x6d0(%rsp)
  7f05ec:	00 00 00 00 00 
  7f05f1:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  7f05f6:	48 89 84 24 d8 06 00 	mov    %rax,0x6d8(%rsp)
  7f05fd:	00 
  7f05fe:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  7f0605:	00 
  7f0606:	48 89 84 24 e0 06 00 	mov    %rax,0x6e0(%rsp)
  7f060d:	00 
  7f060e:	48 83 c0 70          	add    $0x70,%rax
  7f0612:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  7f0619:	00 
  7f061a:	89 8c 24 e8 06 00 00 	mov    %ecx,0x6e8(%rsp)
  7f0621:	ff c1                	inc    %ecx
  7f0623:	89 4c 24 78          	mov    %ecx,0x78(%rsp)
  7f0627:	c6 84 24 90 07 00 00 	movb   $0x2,0x790(%rsp)
  7f062e:	02 
  7f062f:	c7 84 24 98 07 00 00 	movl   $0x0,0x798(%rsp)
  7f0636:	00 00 00 00 
  7f063a:	48 8d bc 24 d0 02 00 	lea    0x2d0(%rsp),%rdi
  7f0641:	00 
  7f0642:	48 8d b4 24 d0 06 00 	lea    0x6d0(%rsp),%rsi
  7f0649:	00 
  7f064a:	e8 01 ad 00 00       	call   7fb350 <<parley::layout::line::GlyphRunIter<()> as core::iter::traits::iterator::Iterator>::next>
  7f064f:	83 bc 24 d0 02 00 00 	cmpl   $0x1,0x2d0(%rsp)
  7f0656:	01 
  7f0657:	0f 85 24 0f 00 00    	jne    7f1581 <<gpui_canvas::text::planner::Planner>::shape+0x22f1>
  7f065d:	48 8b 84 24 d8 02 00 	mov    0x2d8(%rsp),%rax
  7f0664:	00 
  7f0665:	48 85 c0             	test   %rax,%rax
  7f0668:	0f 84 7c 18 00 00    	je     7f1eea <<gpui_canvas::text::planner::Planner>::shape+0x2c5a>
  7f066e:	48 89 84 24 10 04 00 	mov    %rax,0x410(%rsp)
  7f0675:	00 
  7f0676:	41 0f 10 06          	movups (%r14),%xmm0
  7f067a:	41 0f 10 4e 10       	movups 0x10(%r14),%xmm1
  7f067f:	41 0f 10 56 20       	movups 0x20(%r14),%xmm2
  7f0684:	41 0f 10 5e 30       	movups 0x30(%r14),%xmm3
  7f0689:	48 8d 8c 24 18 04 00 	lea    0x418(%rsp),%rcx
  7f0690:	00 
  7f0691:	0f 11 59 30          	movups %xmm3,0x30(%rcx)
  7f0695:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  7f0699:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  7f069d:	0f 11 01             	movups %xmm0,(%rcx)
  7f06a0:	48 8b 8c 24 18 04 00 	mov    0x418(%rsp),%rcx
  7f06a7:	00 
  7f06a8:	48 8b 51 30          	mov    0x30(%rcx),%rdx
  7f06ac:	48 8b 79 38          	mov    0x38(%rcx),%rdi
  7f06b0:	48 89 fe             	mov    %rdi,%rsi
  7f06b3:	48 29 d6             	sub    %rdx,%rsi
  7f06b6:	41 0f 92 c0          	setb   %r8b
  7f06ba:	48 3b b8 d0 00 00 00 	cmp    0xd0(%rax),%rdi
  7f06c1:	40 0f 97 c7          	seta   %dil
  7f06c5:	48 01 d2             	add    %rdx,%rdx
  7f06c8:	48 03 90 c8 00 00 00 	add    0xc8(%rax),%rdx
  7f06cf:	44 08 c7             	or     %r8b,%dil
  7f06d2:	40 84 ff             	test   %dil,%dil
  7f06d5:	bf 00 00 00 00       	mov    $0x0,%edi
  7f06da:	48 0f 45 f7          	cmovne %rdi,%rsi
  7f06de:	bf 02 00 00 00       	mov    $0x2,%edi
  7f06e3:	48 0f 45 d7          	cmovne %rdi,%rdx
  7f06e7:	48 01 f6             	add    %rsi,%rsi
  7f06ea:	31 ff                	xor    %edi,%edi
  7f06ec:	0f 1f 40 00          	nopl   0x0(%rax)
  7f06f0:	48 39 fe             	cmp    %rdi,%rsi
  7f06f3:	74 10                	je     7f0705 <<gpui_canvas::text::planner::Planner>::shape+0x1475>
  7f06f5:	66 83 3c 3a 00       	cmpw   $0x0,(%rdx,%rdi,1)
  7f06fa:	48 8d 7f 02          	lea    0x2(%rdi),%rdi
  7f06fe:	74 f0                	je     7f06f0 <<gpui_canvas::text::planner::Planner>::shape+0x1460>
  7f0700:	e9 83 16 00 00       	jmp    7f1d88 <<gpui_canvas::text::planner::Planner>::shape+0x2af8>
  7f0705:	48 8b 51 40          	mov    0x40(%rcx),%rdx
  7f0709:	48 3b 90 b8 00 00 00 	cmp    0xb8(%rax),%rdx
  7f0710:	0f 83 d7 1d 00 00    	jae    7f24ed <<gpui_canvas::text::planner::Planner>::shape+0x325d>
  7f0716:	48 c1 e2 06          	shl    $0x6,%rdx
  7f071a:	48 03 90 b0 00 00 00 	add    0xb0(%rax),%rdx
  7f0721:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  7f0726:	83 3f 01             	cmpl   $0x1,(%rdi)
  7f0729:	75 0e                	jne    7f0739 <<gpui_canvas::text::planner::Planner>::shape+0x14a9>
  7f072b:	48 8b 77 08          	mov    0x8(%rdi),%rsi
  7f072f:	48 3b 72 10          	cmp    0x10(%rdx),%rsi
  7f0733:	75 04                	jne    7f0739 <<gpui_canvas::text::planner::Planner>::shape+0x14a9>
  7f0735:	31 ed                	xor    %ebp,%ebp
  7f0737:	eb 49                	jmp    7f0782 <<gpui_canvas::text::planner::Planner>::shape+0x14f2>
  7f0739:	83 7f 10 01          	cmpl   $0x1,0x10(%rdi)
  7f073d:	75 0f                	jne    7f074e <<gpui_canvas::text::planner::Planner>::shape+0x14be>
  7f073f:	48 8b 77 18          	mov    0x18(%rdi),%rsi
  7f0743:	bd 01 00 00 00       	mov    $0x1,%ebp
  7f0748:	48 3b 72 10          	cmp    0x10(%rdx),%rsi
  7f074c:	74 1d                	je     7f076b <<gpui_canvas::text::planner::Planner>::shape+0x14db>
  7f074e:	83 7f 20 01          	cmpl   $0x1,0x20(%rdi)
  7f0752:	0f 85 fc 17 00 00    	jne    7f1f54 <<gpui_canvas::text::planner::Planner>::shape+0x2cc4>
  7f0758:	48 8b 77 28          	mov    0x28(%rdi),%rsi
  7f075c:	bd 02 00 00 00       	mov    $0x2,%ebp
  7f0761:	48 3b 72 10          	cmp    0x10(%rdx),%rsi
  7f0765:	0f 85 e9 17 00 00    	jne    7f1f54 <<gpui_canvas::text::planner::Planner>::shape+0x2cc4>
  7f076b:	8d 55 ff             	lea    -0x1(%rbp),%edx
  7f076e:	48 8b b4 24 f0 01 00 	mov    0x1f0(%rsp),%rsi
  7f0775:	00 
  7f0776:	48 0f ab d6          	bts    %rdx,%rsi
  7f077a:	48 89 b4 24 f0 01 00 	mov    %rsi,0x1f0(%rsp)
  7f0781:	00 
  7f0782:	8b bc 24 38 04 00 00 	mov    0x438(%rsp),%edi
  7f0789:	48 8b 70 58          	mov    0x58(%rax),%rsi
  7f078d:	48 39 fe             	cmp    %rdi,%rsi
  7f0790:	0f 86 09 21 00 00    	jbe    7f289f <<gpui_canvas::text::planner::Planner>::shape+0x360f>
  7f0796:	48 8b 94 24 28 04 00 	mov    0x428(%rsp),%rdx
  7f079d:	00 
  7f079e:	48 85 d2             	test   %rdx,%rdx
  7f07a1:	48 89 ac 24 40 02 00 	mov    %rbp,0x240(%rsp)
  7f07a8:	00 
  7f07a9:	74 0a                	je     7f07b5 <<gpui_canvas::text::planner::Planner>::shape+0x1525>
  7f07ab:	48 8d 72 18          	lea    0x18(%rdx),%rsi
  7f07af:	48 83 c2 1c          	add    $0x1c,%rdx
  7f07b3:	eb 1b                	jmp    7f07d0 <<gpui_canvas::text::planner::Planner>::shape+0x1540>
  7f07b5:	48 8b 70 50          	mov    0x50(%rax),%rsi
  7f07b9:	48 8d 3c ff          	lea    (%rdi,%rdi,8),%rdi
  7f07bd:	48 c1 e7 04          	shl    $0x4,%rdi
  7f07c1:	48 8d 14 3e          	lea    (%rsi,%rdi,1),%rdx
  7f07c5:	48 83 c2 54          	add    $0x54,%rdx
  7f07c9:	48 01 fe             	add    %rdi,%rsi
  7f07cc:	48 83 c6 50          	add    $0x50,%rsi
  7f07d0:	48 8b bc 24 f8 00 00 	mov    0xf8(%rsp),%rdi
  7f07d7:	00 
  7f07d8:	48 89 bc 24 28 03 00 	mov    %rdi,0x328(%rsp)
  7f07df:	00 
  7f07e0:	48 8b 78 68          	mov    0x68(%rax),%rdi
  7f07e4:	4c 8b 40 70          	mov    0x70(%rax),%r8
  7f07e8:	4c 8b 88 80 00 00 00 	mov    0x80(%rax),%r9
  7f07ef:	4c 8b 90 88 00 00 00 	mov    0x88(%rax),%r10
  7f07f6:	4c 8b 98 98 00 00 00 	mov    0x98(%rax),%r11
  7f07fd:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
  7f0804:	8b 12                	mov    (%rdx),%edx
  7f0806:	8b 36                	mov    (%rsi),%esi
  7f0808:	0f b6 89 8c 00 00 00 	movzbl 0x8c(%rcx),%ecx
  7f080f:	80 e1 01             	and    $0x1,%cl
  7f0812:	89 d3                	mov    %edx,%ebx
  7f0814:	29 f3                	sub    %esi,%ebx
  7f0816:	48 c7 84 24 80 04 00 	movq   $0x0,0x480(%rsp)
  7f081d:	00 00 00 00 00 
  7f0822:	48 c7 84 24 a0 04 00 	movq   $0x0,0x4a0(%rsp)
  7f0829:	00 00 00 00 00 
  7f082e:	c7 84 24 c0 04 00 00 	movl   $0x0,0x4c0(%rsp)
  7f0835:	00 00 00 00 
  7f0839:	89 9c 24 c4 04 00 00 	mov    %ebx,0x4c4(%rsp)
  7f0840:	48 89 bc 24 c8 04 00 	mov    %rdi,0x4c8(%rsp)
  7f0847:	00 
  7f0848:	4c 89 84 24 d0 04 00 	mov    %r8,0x4d0(%rsp)
  7f084f:	00 
  7f0850:	4c 89 8c 24 d8 04 00 	mov    %r9,0x4d8(%rsp)
  7f0857:	00 
  7f0858:	4c 89 94 24 e0 04 00 	mov    %r10,0x4e0(%rsp)
  7f085f:	00 
  7f0860:	4c 89 9c 24 e8 04 00 	mov    %r11,0x4e8(%rsp)
  7f0867:	00 
  7f0868:	48 89 84 24 f0 04 00 	mov    %rax,0x4f0(%rsp)
  7f086f:	00 
  7f0870:	89 b4 24 f8 04 00 00 	mov    %esi,0x4f8(%rsp)
  7f0877:	89 94 24 fc 04 00 00 	mov    %edx,0x4fc(%rsp)
  7f087e:	89 b4 24 00 05 00 00 	mov    %esi,0x500(%rsp)
  7f0885:	89 94 24 04 05 00 00 	mov    %edx,0x504(%rsp)
  7f088c:	88 8c 24 08 05 00 00 	mov    %cl,0x508(%rsp)
  7f0893:	48 8d bc 24 70 03 00 	lea    0x370(%rsp),%rdi
  7f089a:	00 
  7f089b:	48 8d b4 24 10 04 00 	lea    0x410(%rsp),%rsi
  7f08a2:	00 
  7f08a3:	e8 f8 9d 00 00       	call   7fa6a0 <<parley::layout::line::GlyphRun<()>>::positioned_glyphs>
  7f08a8:	4c 8b ac 24 70 03 00 	mov    0x370(%rsp),%r13
  7f08af:	00 
  7f08b0:	48 8b 84 24 78 03 00 	mov    0x378(%rsp),%rax
  7f08b7:	00 
  7f08b8:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  7f08bf:	00 
  7f08c0:	0f b6 84 24 80 03 00 	movzbl 0x380(%rsp),%eax
  7f08c7:	00 
  7f08c8:	8b 8c 24 84 03 00 00 	mov    0x384(%rsp),%ecx
  7f08cf:	89 8c 24 8c 01 00 00 	mov    %ecx,0x18c(%rsp)
  7f08d6:	f2 0f 10 84 24 88 03 	movsd  0x388(%rsp),%xmm0
  7f08dd:	00 00 
  7f08df:	0f 29 84 24 20 02 00 	movaps %xmm0,0x220(%rsp)
  7f08e6:	00 
  7f08e7:	f3 0f 10 84 24 90 03 	movss  0x390(%rsp),%xmm0
  7f08ee:	00 00 
  7f08f0:	f3 0f 11 84 24 88 01 	movss  %xmm0,0x188(%rsp)
  7f08f7:	00 00 
  7f08f9:	48 8b 8c 24 98 03 00 	mov    0x398(%rsp),%rcx
  7f0900:	00 
  7f0901:	48 89 8c 24 48 02 00 	mov    %rcx,0x248(%rsp)
  7f0908:	00 
  7f0909:	48 8b 8c 24 a0 03 00 	mov    0x3a0(%rsp),%rcx
  7f0910:	00 
  7f0911:	48 89 8c 24 e8 01 00 	mov    %rcx,0x1e8(%rsp)
  7f0918:	00 
  7f0919:	48 8b 94 24 a8 03 00 	mov    0x3a8(%rsp),%rdx
  7f0920:	00 
  7f0921:	48 8b 8c 24 b0 03 00 	mov    0x3b0(%rsp),%rcx
  7f0928:	00 
  7f0929:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  7f092e:	48 8b 8c 24 b8 03 00 	mov    0x3b8(%rsp),%rcx
  7f0935:	00 
  7f0936:	48 89 8c 24 58 02 00 	mov    %rcx,0x258(%rsp)
  7f093d:	00 
  7f093e:	48 8b 8c 24 c0 03 00 	mov    0x3c0(%rsp),%rcx
  7f0945:	00 
  7f0946:	48 89 8c 24 20 01 00 	mov    %rcx,0x120(%rsp)
  7f094d:	00 
  7f094e:	8b 8c 24 c8 03 00 00 	mov    0x3c8(%rsp),%ecx
  7f0955:	48 89 8c 24 c8 01 00 	mov    %rcx,0x1c8(%rsp)
  7f095c:	00 
  7f095d:	8b 8c 24 cc 03 00 00 	mov    0x3cc(%rsp),%ecx
  7f0964:	48 89 8c 24 c0 01 00 	mov    %rcx,0x1c0(%rsp)
  7f096b:	00 
  7f096c:	8b 8c 24 d0 03 00 00 	mov    0x3d0(%rsp),%ecx
  7f0973:	48 89 8c 24 00 01 00 	mov    %rcx,0x100(%rsp)
  7f097a:	00 
  7f097b:	8b 8c 24 d4 03 00 00 	mov    0x3d4(%rsp),%ecx
  7f0982:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  7f0987:	f3 0f 10 84 24 d8 03 	movss  0x3d8(%rsp),%xmm0
  7f098e:	00 00 
  7f0990:	f3 0f 11 84 24 90 01 	movss  %xmm0,0x190(%rsp)
  7f0997:	00 00 
  7f0999:	f3 0f 10 84 24 dc 03 	movss  0x3dc(%rsp),%xmm0
  7f09a0:	00 00 
  7f09a2:	f3 0f 11 44 24 68    	movss  %xmm0,0x68(%rsp)
  7f09a8:	4c 8b bc 24 e0 03 00 	mov    0x3e0(%rsp),%r15
  7f09af:	00 
  7f09b0:	f3 0f 10 84 24 f8 03 	movss  0x3f8(%rsp),%xmm0
  7f09b7:	00 00 
  7f09b9:	f3 0f 10 94 24 08 04 	movss  0x408(%rsp),%xmm2
  7f09c0:	00 00 
  7f09c2:	f3 0f 10 8c 24 0c 04 	movss  0x40c(%rsp),%xmm1
  7f09c9:	00 00 
  7f09cb:	f3 0f 11 8c 24 18 02 	movss  %xmm1,0x218(%rsp)
  7f09d2:	00 00 
  7f09d4:	f3 0f 10 8c 24 f4 03 	movss  0x3f4(%rsp),%xmm1
  7f09db:	00 00 
  7f09dd:	f3 0f 11 84 24 14 02 	movss  %xmm0,0x214(%rsp)
  7f09e4:	00 00 
  7f09e6:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  7f09ea:	f3 0f 10 84 24 fc 03 	movss  0x3fc(%rsp),%xmm0
  7f09f1:	00 00 
  7f09f3:	f3 0f 11 8c 24 10 02 	movss  %xmm1,0x210(%rsp)
  7f09fa:	00 00 
  7f09fc:	f3 0f 58 c1          	addss  %xmm1,%xmm0
  7f0a00:	f3 0f 11 84 24 08 02 	movss  %xmm0,0x208(%rsp)
  7f0a07:	00 00 
  7f0a09:	0f b6 8c 24 04 04 00 	movzbl 0x404(%rsp),%ecx
  7f0a10:	00 
  7f0a11:	88 8c 24 70 02 00 00 	mov    %cl,0x270(%rsp)
  7f0a18:	48 8b 8c 24 e8 03 00 	mov    0x3e8(%rsp),%rcx
  7f0a1f:	00 
  7f0a20:	48 89 8c 24 18 01 00 	mov    %rcx,0x118(%rsp)
  7f0a27:	00 
  7f0a28:	8b 8c 24 f0 03 00 00 	mov    0x3f0(%rsp),%ecx
  7f0a2f:	89 8c 24 e0 00 00 00 	mov    %ecx,0xe0(%rsp)
  7f0a36:	8b 8c 24 00 04 00 00 	mov    0x400(%rsp),%ecx
  7f0a3d:	89 8c 24 0c 02 00 00 	mov    %ecx,0x20c(%rsp)
  7f0a44:	48 8d 4a 16          	lea    0x16(%rdx),%rcx
  7f0a48:	48 89 8c 24 30 02 00 	mov    %rcx,0x230(%rsp)
  7f0a4f:	00 
  7f0a50:	48 89 94 24 d0 01 00 	mov    %rdx,0x1d0(%rsp)
  7f0a57:	00 
  7f0a58:	48 8d 4a 2e          	lea    0x2e(%rdx),%rcx
  7f0a5c:	48 89 8c 24 38 03 00 	mov    %rcx,0x338(%rsp)
  7f0a63:	00 
  7f0a64:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
  7f0a69:	eb 6a                	jmp    7f0ad5 <<gpui_canvas::text::planner::Planner>::shape+0x1845>
  7f0a6b:	03 2c 24             	add    (%rsp),%ebp
  7f0a6e:	0f 28 8c 24 a0 01 00 	movaps 0x1a0(%rsp),%xmm1
  7f0a75:	00 
  7f0a76:	f3 0f 58 4c 24 58    	addss  0x58(%rsp),%xmm1
  7f0a7c:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  7f0a83:	00 
  7f0a84:	48 89 d9             	mov    %rbx,%rcx
  7f0a87:	48 c1 e1 04          	shl    $0x4,%rcx
  7f0a8b:	89 2c 08             	mov    %ebp,(%rax,%rcx,1)
  7f0a8e:	f3 0f 10 44 24 1c    	movss  0x1c(%rsp),%xmm0
  7f0a94:	f3 0f 11 44 08 04    	movss  %xmm0,0x4(%rax,%rcx,1)
  7f0a9a:	f3 0f 11 4c 08 08    	movss  %xmm1,0x8(%rax,%rcx,1)
  7f0aa0:	8b 54 24 6c          	mov    0x6c(%rsp),%edx
  7f0aa4:	66 89 54 08 0c       	mov    %dx,0xc(%rax,%rcx,1)
  7f0aa9:	48 8b 94 24 40 02 00 	mov    0x240(%rsp),%rdx
  7f0ab0:	00 
  7f0ab1:	88 54 08 0e          	mov    %dl,0xe(%rax,%rcx,1)
  7f0ab5:	c6 44 08 0f 00       	movb   $0x0,0xf(%rax,%rcx,1)
  7f0aba:	48 ff c3             	inc    %rbx
  7f0abd:	48 89 9c 24 f8 00 00 	mov    %rbx,0xf8(%rsp)
  7f0ac4:	00 
  7f0ac5:	31 c0                	xor    %eax,%eax
  7f0ac7:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
  7f0acc:	f3 0f 10 94 24 94 01 	movss  0x194(%rsp),%xmm2
  7f0ad3:	00 00 
  7f0ad5:	f3 0f 11 54 24 1c    	movss  %xmm2,0x1c(%rsp)
  7f0adb:	a8 01                	test   $0x1,%al
  7f0add:	74 61                	je     7f0b40 <<gpui_canvas::text::planner::Planner>::shape+0x18b0>
  7f0adf:	f3 0f 10 84 24 88 01 	movss  0x188(%rsp),%xmm0
  7f0ae6:	00 00 
  7f0ae8:	f3 0f 11 84 24 b0 01 	movss  %xmm0,0x1b0(%rsp)
  7f0aef:	00 00 
  7f0af1:	8b 84 24 8c 01 00 00 	mov    0x18c(%rsp),%eax
  7f0af8:	89 44 24 6c          	mov    %eax,0x6c(%rsp)
  7f0afc:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  7f0b03:	00 
  7f0b04:	0f 29 84 24 a0 01 00 	movaps %xmm0,0x1a0(%rsp)
  7f0b0b:	00 
  7f0b0c:	83 bc 24 e0 00 00 00 	cmpl   $0x0,0xe0(%rsp)
  7f0b13:	00 
  7f0b14:	74 71                	je     7f0b87 <<gpui_canvas::text::planner::Planner>::shape+0x18f7>
  7f0b16:	4d 85 ff             	test   %r15,%r15
  7f0b19:	74 7f                	je     7f0b9a <<gpui_canvas::text::planner::Planner>::shape+0x190a>
  7f0b1b:	0f 28 84 24 a0 01 00 	movaps 0x1a0(%rsp),%xmm0
  7f0b22:	00 
  7f0b23:	f3 0f 11 84 24 dc 00 	movss  %xmm0,0xdc(%rsp)
  7f0b2a:	00 00 
  7f0b2c:	e9 9d 00 00 00       	jmp    7f0bce <<gpui_canvas::text::planner::Planner>::shape+0x193e>
  7f0b31:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  7f0b38:	0f 1f 84 00 00 00 00 
  7f0b3f:	00 
  7f0b40:	4c 3b ac 24 88 00 00 	cmp    0x88(%rsp),%r13
  7f0b47:	00 
  7f0b48:	0f 84 3f 01 00 00    	je     7f0c8d <<gpui_canvas::text::planner::Planner>::shape+0x19fd>
  7f0b4e:	4c 89 fa             	mov    %r15,%rdx
  7f0b51:	41 8b 45 00          	mov    0x0(%r13),%eax
  7f0b55:	89 44 24 6c          	mov    %eax,0x6c(%rsp)
  7f0b59:	f2 41 0f 10 45 04    	movsd  0x4(%r13),%xmm0
  7f0b5f:	0f 29 84 24 a0 01 00 	movaps %xmm0,0x1a0(%rsp)
  7f0b66:	00 
  7f0b67:	f3 41 0f 10 45 0c    	movss  0xc(%r13),%xmm0
  7f0b6d:	f3 0f 11 84 24 b0 01 	movss  %xmm0,0x1b0(%rsp)
  7f0b74:	00 00 
  7f0b76:	49 83 c5 10          	add    $0x10,%r13
  7f0b7a:	49 89 d7             	mov    %rdx,%r15
  7f0b7d:	83 bc 24 e0 00 00 00 	cmpl   $0x0,0xe0(%rsp)
  7f0b84:	00 
  7f0b85:	75 8f                	jne    7f0b16 <<gpui_canvas::text::planner::Planner>::shape+0x1886>
  7f0b87:	0f 28 84 24 a0 01 00 	movaps 0x1a0(%rsp),%xmm0
  7f0b8e:	00 
  7f0b8f:	f3 0f 11 84 24 dc 00 	movss  %xmm0,0xdc(%rsp)
  7f0b96:	00 00 
  7f0b98:	eb 67                	jmp    7f0c01 <<gpui_canvas::text::planner::Planner>::shape+0x1971>
  7f0b9a:	f3 0f 10 84 24 90 01 	movss  0x190(%rsp),%xmm0
  7f0ba1:	00 00 
  7f0ba3:	0f 28 c8             	movaps %xmm0,%xmm1
  7f0ba6:	f3 0f 58 8c 24 a0 01 	addss  0x1a0(%rsp),%xmm1
  7f0bad:	00 00 
  7f0baf:	f3 0f 11 8c 24 dc 00 	movss  %xmm1,0xdc(%rsp)
  7f0bb6:	00 00 
  7f0bb8:	f3 0f 10 8c 24 b0 01 	movss  0x1b0(%rsp),%xmm1
  7f0bbf:	00 00 
  7f0bc1:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  7f0bc5:	f3 0f 11 8c 24 b0 01 	movss  %xmm1,0x1b0(%rsp)
  7f0bcc:	00 00 
  7f0bce:	4c 89 f9             	mov    %r15,%rcx
  7f0bd1:	48 ff c1             	inc    %rcx
  7f0bd4:	48 8b 84 24 18 01 00 	mov    0x118(%rsp),%rax
  7f0bdb:	00 
  7f0bdc:	48 39 c1             	cmp    %rax,%rcx
  7f0bdf:	75 1d                	jne    7f0bfe <<gpui_canvas::text::planner::Planner>::shape+0x196e>
  7f0be1:	f3 0f 10 84 24 b0 01 	movss  0x1b0(%rsp),%xmm0
  7f0be8:	00 00 
  7f0bea:	f3 0f 58 44 24 68    	addss  0x68(%rsp),%xmm0
  7f0bf0:	f3 0f 11 84 24 b0 01 	movss  %xmm0,0x1b0(%rsp)
  7f0bf7:	00 00 
  7f0bf9:	49 89 c7             	mov    %rax,%r15
  7f0bfc:	eb 03                	jmp    7f0c01 <<gpui_canvas::text::planner::Planner>::shape+0x1971>
  7f0bfe:	49 89 cf             	mov    %rcx,%r15
  7f0c01:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  7f0c08:	00 
  7f0c09:	48 8d b4 24 80 04 00 	lea    0x480(%rsp),%rsi
  7f0c10:	00 
  7f0c11:	e8 7a 2a 00 00       	call   7f3690 <<core::iter::adapters::flatten::FlattenCompat<core::iter::adapters::map::Map<core::ops::range::Range<u32>, <parley::layout::run::Run<()>>::glyph_source_ranges::{closure#0}>, core::iter::sources::repeat_n::RepeatN<core::ops::range::Range<usize>>> as core::iter::traits::iterator::Iterator>::next>
  7f0c16:	83 bc 24 a0 00 00 00 	cmpl   $0x1,0xa0(%rsp)
  7f0c1d:	01 
  7f0c1e:	0f 85 97 12 00 00    	jne    7f1ebb <<gpui_canvas::text::planner::Planner>::shape+0x2c2b>
  7f0c24:	f3 0f 10 54 24 1c    	movss  0x1c(%rsp),%xmm2
  7f0c2a:	f3 0f 58 94 24 b0 01 	addss  0x1b0(%rsp),%xmm2
  7f0c31:	00 00 
  7f0c33:	31 c0                	xor    %eax,%eax
  7f0c35:	48 3b 1c 24          	cmp    (%rsp),%rbx
  7f0c39:	0f 84 96 fe ff ff    	je     7f0ad5 <<gpui_canvas::text::planner::Planner>::shape+0x1845>
  7f0c3f:	f3 0f 11 94 24 94 01 	movss  %xmm2,0x194(%rsp)
  7f0c46:	00 00 
  7f0c48:	4c 8b 8c 24 a8 00 00 	mov    0xa8(%rsp),%r9
  7f0c4f:	00 
  7f0c50:	48 8b ac 24 b0 00 00 	mov    0xb0(%rsp),%rbp
  7f0c57:	00 
  7f0c58:	49 39 e9             	cmp    %rbp,%r9
  7f0c5b:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7f0c60:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  7f0c65:	0f 87 22 12 00 00    	ja     7f1e8d <<gpui_canvas::text::planner::Planner>::shape+0x2bfd>
  7f0c6b:	4d 85 c9             	test   %r9,%r9
  7f0c6e:	0f 84 0c 05 00 00    	je     7f1180 <<gpui_canvas::text::planner::Planner>::shape+0x1ef0>
  7f0c74:	49 39 c1             	cmp    %rax,%r9
  7f0c77:	0f 83 fd 04 00 00    	jae    7f117a <<gpui_canvas::text::planner::Planner>::shape+0x1eea>
  7f0c7d:	43 80 3c 08 bf       	cmpb   $0xbf,(%r8,%r9,1)
  7f0c82:	0f 8f f8 04 00 00    	jg     7f1180 <<gpui_canvas::text::planner::Planner>::shape+0x1ef0>
  7f0c88:	e9 00 12 00 00       	jmp    7f1e8d <<gpui_canvas::text::planner::Planner>::shape+0x2bfd>
  7f0c8d:	4c 89 ac 24 88 00 00 	mov    %r13,0x88(%rsp)
  7f0c94:	00 
  7f0c95:	f6 84 24 70 02 00 00 	testb  $0x1,0x270(%rsp)
  7f0c9c:	01 
  7f0c9d:	74 1e                	je     7f0cbd <<gpui_canvas::text::planner::Planner>::shape+0x1a2d>
  7f0c9f:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  7f0ca4:	48 8b 8c 24 00 01 00 	mov    0x100(%rsp),%rcx
  7f0cab:	00 
  7f0cac:	39 c1                	cmp    %eax,%ecx
  7f0cae:	0f 83 4e 01 00 00    	jae    7f0e02 <<gpui_canvas::text::planner::Planner>::shape+0x1b72>
  7f0cb4:	ff c8                	dec    %eax
  7f0cb6:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7f0cbb:	eb 18                	jmp    7f0cd5 <<gpui_canvas::text::planner::Planner>::shape+0x1a45>
  7f0cbd:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  7f0cc2:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  7f0cc9:	00 
  7f0cca:	39 d0                	cmp    %edx,%eax
  7f0ccc:	0f 83 4b 01 00 00    	jae    7f0e1d <<gpui_canvas::text::planner::Planner>::shape+0x1b8d>
  7f0cd2:	8d 48 01             	lea    0x1(%rax),%ecx
  7f0cd5:	89 c7                	mov    %eax,%edi
  7f0cd7:	48 39 7c 24 10       	cmp    %rdi,0x10(%rsp)
  7f0cdc:	48 8b 94 24 d0 01 00 	mov    0x1d0(%rsp),%rdx
  7f0ce3:	00 
  7f0ce4:	0f 86 39 1b 00 00    	jbe    7f2823 <<gpui_canvas::text::planner::Planner>::shape+0x3593>
  7f0cea:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  7f0cee:	44 8b 6c c2 08       	mov    0x8(%rdx,%rax,8),%r13d
  7f0cf3:	f6 44 c2 17 01       	testb  $0x1,0x17(%rdx,%rax,8)
  7f0cf8:	0f 85 71 05 00 00    	jne    7f126f <<gpui_canvas::text::planner::Planner>::shape+0x1fdf>
  7f0cfe:	48 8d 04 c2          	lea    (%rdx,%rax,8),%rax
  7f0d02:	8b 50 0c             	mov    0xc(%rax),%edx
  7f0d05:	4a 8d 34 2a          	lea    (%rdx,%r13,1),%rsi
  7f0d09:	48 3b b4 24 20 01 00 	cmp    0x120(%rsp),%rsi
  7f0d10:	00 
  7f0d11:	0f 87 31 14 00 00    	ja     7f2148 <<gpui_canvas::text::planner::Planner>::shape+0x2eb8>
  7f0d17:	49 c1 e5 04          	shl    $0x4,%r13
  7f0d1b:	4c 03 ac 24 58 02 00 	add    0x258(%rsp),%r13
  7f0d22:	00 
  7f0d23:	48 89 d0             	mov    %rdx,%rax
  7f0d26:	48 c1 e0 04          	shl    $0x4,%rax
  7f0d2a:	4c 01 e8             	add    %r13,%rax
  7f0d2d:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f0d30:	0f 29 84 24 20 02 00 	movaps %xmm0,0x220(%rsp)
  7f0d37:	00 
  7f0d38:	48 85 d2             	test   %rdx,%rdx
  7f0d3b:	0f 85 c9 06 00 00    	jne    7f140a <<gpui_canvas::text::planner::Planner>::shape+0x217a>
  7f0d41:	89 ca                	mov    %ecx,%edx
  7f0d43:	48 89 94 24 00 01 00 	mov    %rdx,0x100(%rsp)
  7f0d4a:	00 
  7f0d4b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  7f0d50:	f6 84 24 70 02 00 00 	testb  $0x1,0x270(%rsp)
  7f0d57:	01 
  7f0d58:	74 26                	je     7f0d80 <<gpui_canvas::text::planner::Planner>::shape+0x1af0>
  7f0d5a:	48 8b 6c 24 28       	mov    0x28(%rsp),%rbp
  7f0d5f:	39 e9                	cmp    %ebp,%ecx
  7f0d61:	0f 83 d5 00 00 00    	jae    7f0e3c <<gpui_canvas::text::planner::Planner>::shape+0x1bac>
  7f0d67:	ff cd                	dec    %ebp
  7f0d69:	48 89 e8             	mov    %rbp,%rax
  7f0d6c:	89 ca                	mov    %ecx,%edx
  7f0d6e:	48 89 6c 24 28       	mov    %rbp,0x28(%rsp)
  7f0d73:	89 c1                	mov    %eax,%ecx
  7f0d75:	eb 23                	jmp    7f0d9a <<gpui_canvas::text::planner::Planner>::shape+0x1b0a>
  7f0d77:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  7f0d7e:	00 00 
  7f0d80:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  7f0d85:	39 d1                	cmp    %edx,%ecx
  7f0d87:	0f 83 5c 01 00 00    	jae    7f0ee9 <<gpui_canvas::text::planner::Planner>::shape+0x1c59>
  7f0d8d:	8d 41 01             	lea    0x1(%rcx),%eax
  7f0d90:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
  7f0d97:	00 
  7f0d98:	89 c2                	mov    %eax,%edx
  7f0d9a:	89 cf                	mov    %ecx,%edi
  7f0d9c:	48 39 7c 24 10       	cmp    %rdi,0x10(%rsp)
  7f0da1:	48 8b 8c 24 d0 01 00 	mov    0x1d0(%rsp),%rcx
  7f0da8:	00 
  7f0da9:	0f 86 74 1a 00 00    	jbe    7f2823 <<gpui_canvas::text::planner::Planner>::shape+0x3593>
  7f0daf:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  7f0db3:	44 8b 6c c1 08       	mov    0x8(%rcx,%rax,8),%r13d
  7f0db8:	f6 44 c1 17 01       	testb  $0x1,0x17(%rcx,%rax,8)
  7f0dbd:	0f 85 a4 04 00 00    	jne    7f1267 <<gpui_canvas::text::planner::Planner>::shape+0x1fd7>
  7f0dc3:	48 8d 04 c1          	lea    (%rcx,%rax,8),%rax
  7f0dc7:	8b 78 0c             	mov    0xc(%rax),%edi
  7f0dca:	4a 8d 34 2f          	lea    (%rdi,%r13,1),%rsi
  7f0dce:	48 3b b4 24 20 01 00 	cmp    0x120(%rsp),%rsi
  7f0dd5:	00 
  7f0dd6:	0f 87 6c 13 00 00    	ja     7f2148 <<gpui_canvas::text::planner::Planner>::shape+0x2eb8>
  7f0ddc:	49 c1 e5 04          	shl    $0x4,%r13
  7f0de0:	4c 03 ac 24 58 02 00 	add    0x258(%rsp),%r13
  7f0de7:	00 
  7f0de8:	48 89 f8             	mov    %rdi,%rax
  7f0deb:	48 c1 e0 04          	shl    $0x4,%rax
  7f0def:	4c 01 e8             	add    %r13,%rax
  7f0df2:	89 d1                	mov    %edx,%ecx
  7f0df4:	48 85 ff             	test   %rdi,%rdi
  7f0df7:	0f 84 53 ff ff ff    	je     7f0d50 <<gpui_canvas::text::planner::Planner>::shape+0x1ac0>
  7f0dfd:	e9 e3 04 00 00       	jmp    7f12e5 <<gpui_canvas::text::planner::Planner>::shape+0x2055>
  7f0e02:	4c 89 e8             	mov    %r13,%rax
  7f0e05:	3b 8c 24 c8 01 00 00 	cmp    0x1c8(%rsp),%ecx
  7f0e0c:	0f 95 c2             	setne  %dl
  7f0e0f:	84 94 24 e0 00 00 00 	test   %dl,0xe0(%rsp)
  7f0e16:	75 4e                	jne    7f0e66 <<gpui_canvas::text::planner::Planner>::shape+0x1bd6>
  7f0e18:	e9 05 06 00 00       	jmp    7f1422 <<gpui_canvas::text::planner::Planner>::shape+0x2192>
  7f0e1d:	4c 89 e8             	mov    %r13,%rax
  7f0e20:	3b 94 24 c0 01 00 00 	cmp    0x1c0(%rsp),%edx
  7f0e27:	0f 95 c1             	setne  %cl
  7f0e2a:	84 8c 24 e0 00 00 00 	test   %cl,0xe0(%rsp)
  7f0e31:	0f 85 dc 00 00 00    	jne    7f0f13 <<gpui_canvas::text::planner::Planner>::shape+0x1c83>
  7f0e37:	e9 e6 05 00 00       	jmp    7f1422 <<gpui_canvas::text::planner::Planner>::shape+0x2192>
  7f0e3c:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f0e3f:	0f 29 84 24 20 02 00 	movaps %xmm0,0x220(%rsp)
  7f0e46:	00 
  7f0e47:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  7f0e4e:	00 
  7f0e4f:	3b 8c 24 c8 01 00 00 	cmp    0x1c8(%rsp),%ecx
  7f0e56:	0f 95 c2             	setne  %dl
  7f0e59:	84 94 24 e0 00 00 00 	test   %dl,0xe0(%rsp)
  7f0e60:	0f 84 bc 05 00 00    	je     7f1422 <<gpui_canvas::text::planner::Planner>::shape+0x2192>
  7f0e66:	8d 79 ff             	lea    -0x1(%rcx),%edi
  7f0e69:	48 39 7c 24 10       	cmp    %rdi,0x10(%rsp)
  7f0e6e:	0f 86 4f 1a 00 00    	jbe    7f28c3 <<gpui_canvas::text::planner::Planner>::shape+0x3633>
  7f0e74:	3b bc 24 c8 01 00 00 	cmp    0x1c8(%rsp),%edi
  7f0e7b:	76 41                	jbe    7f0ebe <<gpui_canvas::text::planner::Planner>::shape+0x1c2e>
  7f0e7d:	48 8d 14 7f          	lea    (%rdi,%rdi,2),%rdx
  7f0e81:	48 8b b4 24 30 02 00 	mov    0x230(%rsp),%rsi
  7f0e88:	00 
  7f0e89:	48 8d 14 d6          	lea    (%rsi,%rdx,8),%rdx
  7f0e8d:	0f 1f 00             	nopl   (%rax)
  7f0e90:	48 39 7c 24 10       	cmp    %rdi,0x10(%rsp)
  7f0e95:	0f 86 ae 19 00 00    	jbe    7f2849 <<gpui_canvas::text::planner::Planner>::shape+0x35b9>
  7f0e9b:	f6 42 01 02          	testb  $0x2,0x1(%rdx)
  7f0e9f:	75 1d                	jne    7f0ebe <<gpui_canvas::text::planner::Planner>::shape+0x1c2e>
  7f0ea1:	48 ff cf             	dec    %rdi
  7f0ea4:	48 83 c2 e8          	add    $0xffffffffffffffe8,%rdx
  7f0ea8:	39 bc 24 c8 01 00 00 	cmp    %edi,0x1c8(%rsp)
  7f0eaf:	72 df                	jb     7f0e90 <<gpui_canvas::text::planner::Planner>::shape+0x1c00>
  7f0eb1:	48 8b 94 24 c8 01 00 	mov    0x1c8(%rsp),%rdx
  7f0eb8:	00 
  7f0eb9:	48 89 d7             	mov    %rdx,%rdi
  7f0ebc:	eb 02                	jmp    7f0ec0 <<gpui_canvas::text::planner::Planner>::shape+0x1c30>
  7f0ebe:	89 fa                	mov    %edi,%edx
  7f0ec0:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  7f0ec5:	48 39 fe             	cmp    %rdi,%rsi
  7f0ec8:	0f 86 fe 19 00 00    	jbe    7f28cc <<gpui_canvas::text::planner::Planner>::shape+0x363c>
  7f0ece:	48 89 94 24 00 01 00 	mov    %rdx,0x100(%rsp)
  7f0ed5:	00 
  7f0ed6:	89 ca                	mov    %ecx,%edx
  7f0ed8:	48 ff ca             	dec    %rdx
  7f0edb:	48 39 f2             	cmp    %rsi,%rdx
  7f0ede:	0f 82 ae 00 00 00    	jb     7f0f92 <<gpui_canvas::text::planner::Planner>::shape+0x1d02>
  7f0ee4:	e9 ef 19 00 00       	jmp    7f28d8 <<gpui_canvas::text::planner::Planner>::shape+0x3648>
  7f0ee9:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f0eec:	0f 29 84 24 20 02 00 	movaps %xmm0,0x220(%rsp)
  7f0ef3:	00 
  7f0ef4:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  7f0efb:	00 
  7f0efc:	3b 94 24 c0 01 00 00 	cmp    0x1c0(%rsp),%edx
  7f0f03:	0f 95 c1             	setne  %cl
  7f0f06:	84 8c 24 e0 00 00 00 	test   %cl,0xe0(%rsp)
  7f0f0d:	0f 84 0f 05 00 00    	je     7f1422 <<gpui_canvas::text::planner::Planner>::shape+0x2192>
  7f0f13:	49 89 d0             	mov    %rdx,%r8
  7f0f16:	48 89 d1             	mov    %rdx,%rcx
  7f0f19:	89 cf                	mov    %ecx,%edi
  7f0f1b:	48 39 7c 24 10       	cmp    %rdi,0x10(%rsp)
  7f0f20:	0f 86 88 19 00 00    	jbe    7f28ae <<gpui_canvas::text::planner::Planner>::shape+0x361e>
  7f0f26:	ff c1                	inc    %ecx
  7f0f28:	3b 8c 24 c0 01 00 00 	cmp    0x1c0(%rsp),%ecx
  7f0f2f:	73 49                	jae    7f0f7a <<gpui_canvas::text::planner::Planner>::shape+0x1cea>
  7f0f31:	89 ca                	mov    %ecx,%edx
  7f0f33:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  7f0f37:	48 8b b4 24 30 02 00 	mov    0x230(%rsp),%rsi
  7f0f3e:	00 
  7f0f3f:	48 8d 34 ce          	lea    (%rsi,%rcx,8),%rsi
  7f0f43:	48 89 d1             	mov    %rdx,%rcx
  7f0f46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  7f0f4d:	00 00 00 
  7f0f50:	48 39 4c 24 10       	cmp    %rcx,0x10(%rsp)
  7f0f55:	0f 86 d1 18 00 00    	jbe    7f282c <<gpui_canvas::text::planner::Planner>::shape+0x359c>
  7f0f5b:	f6 46 01 02          	testb  $0x2,0x1(%rsi)
  7f0f5f:	75 19                	jne    7f0f7a <<gpui_canvas::text::planner::Planner>::shape+0x1cea>
  7f0f61:	48 ff c1             	inc    %rcx
  7f0f64:	48 83 c6 18          	add    $0x18,%rsi
  7f0f68:	48 39 8c 24 c0 01 00 	cmp    %rcx,0x1c0(%rsp)
  7f0f6f:	00 
  7f0f70:	75 de                	jne    7f0f50 <<gpui_canvas::text::planner::Planner>::shape+0x1cc0>
  7f0f72:	48 8b 8c 24 c0 01 00 	mov    0x1c0(%rsp),%rcx
  7f0f79:	00 
  7f0f7a:	89 ca                	mov    %ecx,%edx
  7f0f7c:	48 ff ca             	dec    %rdx
  7f0f7f:	48 3b 54 24 10       	cmp    0x10(%rsp),%rdx
  7f0f84:	0f 83 2d 19 00 00    	jae    7f28b7 <<gpui_canvas::text::planner::Planner>::shape+0x3627>
  7f0f8a:	4c 89 84 24 00 01 00 	mov    %r8,0x100(%rsp)
  7f0f91:	00 
  7f0f92:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  7f0f97:	48 83 bc 24 48 02 00 	cmpq   $0x0,0x248(%rsp)
  7f0f9e:	00 00 
  7f0fa0:	0f 84 7c 04 00 00    	je     7f1422 <<gpui_canvas::text::planner::Planner>::shape+0x2192>
  7f0fa6:	48 8d 0c 7f          	lea    (%rdi,%rdi,2),%rcx
  7f0faa:	48 8b b4 24 d0 01 00 	mov    0x1d0(%rsp),%rsi
  7f0fb1:	00 
  7f0fb2:	8b 0c ce             	mov    (%rsi,%rcx,8),%ecx
  7f0fb5:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  7f0fb9:	8b 74 d6 04          	mov    0x4(%rsi,%rdx,8),%esi
  7f0fbd:	39 ce                	cmp    %ecx,%esi
  7f0fbf:	0f 82 90 14 00 00    	jb     7f2455 <<gpui_canvas::text::planner::Planner>::shape+0x31c5>
  7f0fc5:	48 39 b4 24 e8 01 00 	cmp    %rsi,0x1e8(%rsp)
  7f0fcc:	00 
  7f0fcd:	0f 82 82 14 00 00    	jb     7f2455 <<gpui_canvas::text::planner::Planner>::shape+0x31c5>
  7f0fd3:	39 ce                	cmp    %ecx,%esi
  7f0fd5:	0f 84 8f 18 00 00    	je     7f286a <<gpui_canvas::text::planner::Planner>::shape+0x35da>
  7f0fdb:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  7f0fdf:	48 8b 94 24 48 02 00 	mov    0x248(%rsp),%rdx
  7f0fe6:	00 
  7f0fe7:	0f b6 4c 8a 07       	movzbl 0x7(%rdx,%rcx,4),%ecx
  7f0fec:	8d 51 ff             	lea    -0x1(%rcx),%edx
  7f0fef:	83 fa 02             	cmp    $0x2,%edx
  7f0ff2:	73 28                	jae    7f101c <<gpui_canvas::text::planner::Planner>::shape+0x1d8c>
  7f0ff4:	f3 0f 10 84 24 10 02 	movss  0x210(%rsp),%xmm0
  7f0ffb:	00 00 
  7f0ffd:	f3 0f 11 44 24 68    	movss  %xmm0,0x68(%rsp)
  7f1003:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  7f1008:	3b 94 24 0c 02 00 00 	cmp    0x20c(%rsp),%edx
  7f100f:	77 2d                	ja     7f103e <<gpui_canvas::text::planner::Planner>::shape+0x1dae>
  7f1011:	f3 0f 10 84 24 08 02 	movss  0x208(%rsp),%xmm0
  7f1018:	00 00 
  7f101a:	eb 1c                	jmp    7f1038 <<gpui_canvas::text::planner::Planner>::shape+0x1da8>
  7f101c:	f3 0f 10 84 24 14 02 	movss  0x214(%rsp),%xmm0
  7f1023:	00 00 
  7f1025:	f3 0f 11 44 24 68    	movss  %xmm0,0x68(%rsp)
  7f102b:	83 f9 06             	cmp    $0x6,%ecx
  7f102e:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  7f1033:	75 09                	jne    7f103e <<gpui_canvas::text::planner::Planner>::shape+0x1dae>
  7f1035:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f1038:	f3 0f 11 44 24 68    	movss  %xmm0,0x68(%rsp)
  7f103e:	89 d6                	mov    %edx,%esi
  7f1040:	48 39 74 24 10       	cmp    %rsi,0x10(%rsp)
  7f1045:	0f 92 c1             	setb   %cl
  7f1048:	3b 94 24 00 01 00 00 	cmp    0x100(%rsp),%edx
  7f104f:	0f 82 0c 01 00 00    	jb     7f1161 <<gpui_canvas::text::planner::Planner>::shape+0x1ed1>
  7f1055:	48 8b bc 24 00 01 00 	mov    0x100(%rsp),%rdi
  7f105c:	00 
  7f105d:	89 fa                	mov    %edi,%edx
  7f105f:	84 c9                	test   %cl,%cl
  7f1061:	0f 85 0d 14 00 00    	jne    7f2474 <<gpui_canvas::text::planner::Planner>::shape+0x31e4>
  7f1067:	3b 7c 24 28          	cmp    0x28(%rsp),%edi
  7f106b:	75 11                	jne    7f107e <<gpui_canvas::text::planner::Planner>::shape+0x1dee>
  7f106d:	48 c7 84 24 18 01 00 	movq   $0x0,0x118(%rsp)
  7f1074:	00 00 00 00 00 
  7f1079:	e9 be 00 00 00       	jmp    7f113c <<gpui_canvas::text::planner::Planner>::shape+0x1eac>
  7f107e:	48 8d 0c d5 00 00 00 	lea    0x0(,%rdx,8),%rcx
  7f1085:	00 
  7f1086:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  7f108a:	48 8d 7e ff          	lea    -0x1(%rsi),%rdi
  7f108e:	48 39 d7             	cmp    %rdx,%rdi
  7f1091:	75 10                	jne    7f10a3 <<gpui_canvas::text::planner::Planner>::shape+0x1e13>
  7f1093:	31 d2                	xor    %edx,%edx
  7f1095:	48 c7 84 24 18 01 00 	movq   $0x0,0x118(%rsp)
  7f109c:	00 00 00 00 00 
  7f10a1:	eb 68                	jmp    7f110b <<gpui_canvas::text::planner::Planner>::shape+0x1e7b>
  7f10a3:	48 29 d6             	sub    %rdx,%rsi
  7f10a6:	48 89 f7             	mov    %rsi,%rdi
  7f10a9:	48 83 e7 fe          	and    $0xfffffffffffffffe,%rdi
  7f10ad:	48 8b 94 24 38 03 00 	mov    0x338(%rsp),%rdx
  7f10b4:	00 
  7f10b5:	4c 8d 04 0a          	lea    (%rdx,%rcx,1),%r8
  7f10b9:	31 d2                	xor    %edx,%edx
  7f10bb:	45 31 d2             	xor    %r10d,%r10d
  7f10be:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  7f10c4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  7f10cb:	00 00 00 00 00 
  7f10d0:	45 8b 48 de          	mov    -0x22(%r8),%r9d
  7f10d4:	41 f6 40 e9 01       	testb  $0x1,-0x17(%r8)
  7f10d9:	4d 0f 45 cb          	cmovne %r11,%r9
  7f10dd:	4d 01 d1             	add    %r10,%r9
  7f10e0:	41 f6 40 01 01       	testb  $0x1,0x1(%r8)
  7f10e5:	45 8b 50 f6          	mov    -0xa(%r8),%r10d
  7f10e9:	4d 0f 45 d3          	cmovne %r11,%r10
  7f10ed:	4d 01 ca             	add    %r9,%r10
  7f10f0:	48 83 c2 02          	add    $0x2,%rdx
  7f10f4:	49 83 c0 30          	add    $0x30,%r8
  7f10f8:	48 39 d7             	cmp    %rdx,%rdi
  7f10fb:	75 d3                	jne    7f10d0 <<gpui_canvas::text::planner::Planner>::shape+0x1e40>
  7f10fd:	4c 89 94 24 18 01 00 	mov    %r10,0x118(%rsp)
  7f1104:	00 
  7f1105:	40 f6 c6 01          	test   $0x1,%sil
  7f1109:	74 31                	je     7f113c <<gpui_canvas::text::planner::Planner>::shape+0x1eac>
  7f110b:	48 8b b4 24 18 01 00 	mov    0x118(%rsp),%rsi
  7f1112:	00 
  7f1113:	48 03 8c 24 d0 01 00 	add    0x1d0(%rsp),%rcx
  7f111a:	00 
  7f111b:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  7f111f:	f6 44 d1 17 01       	testb  $0x1,0x17(%rcx,%rdx,8)
  7f1124:	8b 54 d1 0c          	mov    0xc(%rcx,%rdx,8),%edx
  7f1128:	b9 01 00 00 00       	mov    $0x1,%ecx
  7f112d:	48 0f 45 d1          	cmovne %rcx,%rdx
  7f1131:	48 01 f2             	add    %rsi,%rdx
  7f1134:	48 89 94 24 18 01 00 	mov    %rdx,0x118(%rsp)
  7f113b:	00 
  7f113c:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f113f:	f3 0f 11 84 24 90 01 	movss  %xmm0,0x190(%rsp)
  7f1146:	00 00 
  7f1148:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  7f114e:	ba 00 00 00 00       	mov    $0x0,%edx
  7f1153:	49 39 c5             	cmp    %rax,%r13
  7f1156:	0f 84 39 fb ff ff    	je     7f0c95 <<gpui_canvas::text::planner::Planner>::shape+0x1a05>
  7f115c:	e9 f0 f9 ff ff       	jmp    7f0b51 <<gpui_canvas::text::planner::Planner>::shape+0x18c1>
  7f1161:	b1 01                	mov    $0x1,%cl
  7f1163:	48 8b bc 24 00 01 00 	mov    0x100(%rsp),%rdi
  7f116a:	00 
  7f116b:	89 fa                	mov    %edi,%edx
  7f116d:	84 c9                	test   %cl,%cl
  7f116f:	0f 84 f2 fe ff ff    	je     7f1067 <<gpui_canvas::text::planner::Planner>::shape+0x1dd7>
  7f1175:	e9 fa 12 00 00       	jmp    7f2474 <<gpui_canvas::text::planner::Planner>::shape+0x31e4>
  7f117a:	0f 85 0d 0d 00 00    	jne    7f1e8d <<gpui_canvas::text::planner::Planner>::shape+0x2bfd>
  7f1180:	48 85 ed             	test   %rbp,%rbp
  7f1183:	0f 94 c1             	sete   %cl
  7f1186:	74 17                	je     7f119f <<gpui_canvas::text::planner::Planner>::shape+0x1f0f>
  7f1188:	48 39 c5             	cmp    %rax,%rbp
  7f118b:	73 0c                	jae    7f1199 <<gpui_canvas::text::planner::Planner>::shape+0x1f09>
  7f118d:	41 80 3c 28 c0       	cmpb   $0xc0,(%r8,%rbp,1)
  7f1192:	7d 0b                	jge    7f119f <<gpui_canvas::text::planner::Planner>::shape+0x1f0f>
  7f1194:	e9 f4 0c 00 00       	jmp    7f1e8d <<gpui_canvas::text::planner::Planner>::shape+0x2bfd>
  7f1199:	0f 85 ee 0c 00 00    	jne    7f1e8d <<gpui_canvas::text::planner::Planner>::shape+0x2bfd>
  7f119f:	83 7c 24 6c 00       	cmpl   $0x0,0x6c(%rsp)
  7f11a4:	0f 84 9b 00 00 00    	je     7f1245 <<gpui_canvas::text::planner::Planner>::shape+0x1fb5>
  7f11aa:	f3 0f 10 44 24 1c    	movss  0x1c(%rsp),%xmm0
  7f11b0:	f3 0f 58 84 24 dc 00 	addss  0xdc(%rsp),%xmm0
  7f11b7:	00 00 
  7f11b9:	f3 0f 11 44 24 1c    	movss  %xmm0,0x1c(%rsp)
  7f11bf:	66 0f 7e c1          	movd   %xmm0,%ecx
  7f11c3:	0f 28 84 24 a0 01 00 	movaps 0x1a0(%rsp),%xmm0
  7f11ca:	00 
  7f11cb:	0f c6 c0 55          	shufps $0x55,%xmm0,%xmm0
  7f11cf:	f3 0f 58 84 24 18 02 	addss  0x218(%rsp),%xmm0
  7f11d6:	00 00 
  7f11d8:	0f 29 84 24 a0 01 00 	movaps %xmm0,0x1a0(%rsp)
  7f11df:	00 
  7f11e0:	66 0f 7e c0          	movd   %xmm0,%eax
  7f11e4:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  7f11ea:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  7f11ef:	3d 00 00 80 7f       	cmp    $0x7f800000,%eax
  7f11f4:	0f 9d c0             	setge  %al
  7f11f7:	81 f9 ff ff 7f 7f    	cmp    $0x7f7fffff,%ecx
  7f11fd:	0f 8f e7 0c 00 00    	jg     7f1eea <<gpui_canvas::text::planner::Planner>::shape+0x2c5a>
  7f1203:	84 c0                	test   %al,%al
  7f1205:	0f 85 df 0c 00 00    	jne    7f1eea <<gpui_canvas::text::planner::Planner>::shape+0x2c5a>
  7f120b:	81 7c 24 6c ff ff 00 	cmpl   $0xffff,0x6c(%rsp)
  7f1212:	00 
  7f1213:	0f 87 74 0c 00 00    	ja     7f1e8d <<gpui_canvas::text::planner::Planner>::shape+0x2bfd>
  7f1219:	4c 89 cd             	mov    %r9,%rbp
  7f121c:	48 8b 9c 24 f8 00 00 	mov    0xf8(%rsp),%rbx
  7f1223:	00 
  7f1224:	48 3b 9c 24 e8 00 00 	cmp    0xe8(%rsp),%rbx
  7f122b:	00 
  7f122c:	0f 85 39 f8 ff ff    	jne    7f0a6b <<gpui_canvas::text::planner::Planner>::shape+0x17db>
  7f1232:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  7f1239:	00 
  7f123a:	ff 15 70 d1 33 00    	call   *0x33d170(%rip)        # b2e3b0 <_DYNAMIC+0xeb0>
  7f1240:	e9 26 f8 ff ff       	jmp    7f0a6b <<gpui_canvas::text::planner::Planner>::shape+0x17db>
  7f1245:	4d 85 c9             	test   %r9,%r9
  7f1248:	0f 84 ad 00 00 00    	je     7f12fb <<gpui_canvas::text::planner::Planner>::shape+0x206b>
  7f124e:	49 39 c1             	cmp    %rax,%r9
  7f1251:	0f 83 9e 00 00 00    	jae    7f12f5 <<gpui_canvas::text::planner::Planner>::shape+0x2065>
  7f1257:	43 80 3c 08 bf       	cmpb   $0xbf,(%r8,%r9,1)
  7f125c:	0f 8f 99 00 00 00    	jg     7f12fb <<gpui_canvas::text::planner::Planner>::shape+0x206b>
  7f1262:	e9 99 0d 00 00       	jmp    7f2000 <<gpui_canvas::text::planner::Planner>::shape+0x2d70>
  7f1267:	48 8b 8c 24 00 01 00 	mov    0x100(%rsp),%rcx
  7f126e:	00 
  7f126f:	44 89 ee             	mov    %r13d,%esi
  7f1272:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  7f1276:	48 8b 94 24 d0 01 00 	mov    0x1d0(%rsp),%rdx
  7f127d:	00 
  7f127e:	f3 0f 10 44 c2 10    	movss  0x10(%rdx,%rax,8),%xmm0
  7f1284:	0f 57 c9             	xorps  %xmm1,%xmm1
  7f1287:	0f 29 8c 24 a0 01 00 	movaps %xmm1,0x1a0(%rsp)
  7f128e:	00 
  7f128f:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  7f1295:	b8 04 00 00 00       	mov    $0x4,%eax
  7f129a:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  7f12a1:	00 
  7f12a2:	48 89 8c 24 00 01 00 	mov    %rcx,0x100(%rsp)
  7f12a9:	00 
  7f12aa:	f3 0f 11 84 24 88 01 	movss  %xmm0,0x188(%rsp)
  7f12b1:	00 00 
  7f12b3:	f3 0f 11 84 24 b0 01 	movss  %xmm0,0x1b0(%rsp)
  7f12ba:	00 00 
  7f12bc:	89 b4 24 8c 01 00 00 	mov    %esi,0x18c(%rsp)
  7f12c3:	89 74 24 6c          	mov    %esi,0x6c(%rsp)
  7f12c7:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f12ca:	0f 29 84 24 20 02 00 	movaps %xmm0,0x220(%rsp)
  7f12d1:	00 
  7f12d2:	83 bc 24 e0 00 00 00 	cmpl   $0x0,0xe0(%rsp)
  7f12d9:	00 
  7f12da:	0f 85 36 f8 ff ff    	jne    7f0b16 <<gpui_canvas::text::planner::Planner>::shape+0x1886>
  7f12e0:	e9 a2 f8 ff ff       	jmp    7f0b87 <<gpui_canvas::text::planner::Planner>::shape+0x18f7>
  7f12e5:	4c 89 fa             	mov    %r15,%rdx
  7f12e8:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  7f12ef:	00 
  7f12f0:	e9 5c f8 ff ff       	jmp    7f0b51 <<gpui_canvas::text::planner::Planner>::shape+0x18c1>
  7f12f5:	0f 85 05 0d 00 00    	jne    7f2000 <<gpui_canvas::text::planner::Planner>::shape+0x2d70>
  7f12fb:	48 85 ed             	test   %rbp,%rbp
  7f12fe:	4c 89 8c 24 30 03 00 	mov    %r9,0x330(%rsp)
  7f1305:	00 
  7f1306:	74 17                	je     7f131f <<gpui_canvas::text::planner::Planner>::shape+0x208f>
  7f1308:	48 39 c5             	cmp    %rax,%rbp
  7f130b:	73 0c                	jae    7f1319 <<gpui_canvas::text::planner::Planner>::shape+0x2089>
  7f130d:	41 80 3c 28 c0       	cmpb   $0xc0,(%r8,%rbp,1)
  7f1312:	7d 0b                	jge    7f131f <<gpui_canvas::text::planner::Planner>::shape+0x208f>
  7f1314:	e9 c4 0c 00 00       	jmp    7f1fdd <<gpui_canvas::text::planner::Planner>::shape+0x2d4d>
  7f1319:	0f 85 be 0c 00 00    	jne    7f1fdd <<gpui_canvas::text::planner::Planner>::shape+0x2d4d>
  7f131f:	89 4c 24 1c          	mov    %ecx,0x1c(%rsp)
  7f1323:	4b 8d 1c 08          	lea    (%r8,%r9,1),%rbx
  7f1327:	49 8d 04 28          	lea    (%r8,%rbp,1),%rax
  7f132b:	48 89 84 24 a0 01 00 	mov    %rax,0x1a0(%rsp)
  7f1332:	00 
  7f1333:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  7f133a:	84 00 00 00 00 00 
  7f1340:	48 3b 9c 24 a0 01 00 	cmp    0x1a0(%rsp),%rbx
  7f1347:	00 
  7f1348:	0f 84 8c 00 00 00    	je     7f13da <<gpui_canvas::text::planner::Planner>::shape+0x214a>
  7f134e:	0f b6 33             	movzbl (%rbx),%esi
  7f1351:	40 84 f6             	test   %sil,%sil
  7f1354:	78 0a                	js     7f1360 <<gpui_canvas::text::planner::Planner>::shape+0x20d0>
  7f1356:	48 ff c3             	inc    %rbx
  7f1359:	eb 65                	jmp    7f13c0 <<gpui_canvas::text::planner::Planner>::shape+0x2130>
  7f135b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  7f1360:	89 f0                	mov    %esi,%eax
  7f1362:	83 e0 1f             	and    $0x1f,%eax
  7f1365:	0f b6 53 01          	movzbl 0x1(%rbx),%edx
  7f1369:	83 e2 3f             	and    $0x3f,%edx
  7f136c:	40 80 fe df          	cmp    $0xdf,%sil
  7f1370:	76 2c                	jbe    7f139e <<gpui_canvas::text::planner::Planner>::shape+0x210e>
  7f1372:	0f b6 4b 02          	movzbl 0x2(%rbx),%ecx
  7f1376:	c1 e2 06             	shl    $0x6,%edx
  7f1379:	83 e1 3f             	and    $0x3f,%ecx
  7f137c:	09 d1                	or     %edx,%ecx
  7f137e:	40 80 fe f0          	cmp    $0xf0,%sil
  7f1382:	72 27                	jb     7f13ab <<gpui_canvas::text::planner::Planner>::shape+0x211b>
  7f1384:	0f b6 73 03          	movzbl 0x3(%rbx),%esi
  7f1388:	48 83 c3 04          	add    $0x4,%rbx
  7f138c:	83 e0 07             	and    $0x7,%eax
  7f138f:	c1 e0 12             	shl    $0x12,%eax
  7f1392:	c1 e1 06             	shl    $0x6,%ecx
  7f1395:	83 e6 3f             	and    $0x3f,%esi
  7f1398:	09 ce                	or     %ecx,%esi
  7f139a:	09 c6                	or     %eax,%esi
  7f139c:	eb 22                	jmp    7f13c0 <<gpui_canvas::text::planner::Planner>::shape+0x2130>
  7f139e:	48 83 c3 02          	add    $0x2,%rbx
  7f13a2:	c1 e0 06             	shl    $0x6,%eax
  7f13a5:	09 d0                	or     %edx,%eax
  7f13a7:	89 c6                	mov    %eax,%esi
  7f13a9:	eb 15                	jmp    7f13c0 <<gpui_canvas::text::planner::Planner>::shape+0x2130>
  7f13ab:	48 83 c3 03          	add    $0x3,%rbx
  7f13af:	c1 e0 0c             	shl    $0xc,%eax
  7f13b2:	09 c1                	or     %eax,%ecx
  7f13b4:	89 ce                	mov    %ecx,%esi
  7f13b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  7f13bd:	00 00 00 
  7f13c0:	48 8d 3d b9 63 31 00 	lea    0x3163b9(%rip),%rdi        # b07780 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x58>
  7f13c7:	ff 15 d3 cf 33 00    	call   *0x33cfd3(%rip)        # b2e3a0 <_DYNAMIC+0xea0>
  7f13cd:	84 c0                	test   %al,%al
  7f13cf:	0f 85 6b ff ff ff    	jne    7f1340 <<gpui_canvas::text::planner::Planner>::shape+0x20b0>
  7f13d5:	e9 0b 0c 00 00       	jmp    7f1fe5 <<gpui_canvas::text::planner::Planner>::shape+0x2d55>
  7f13da:	31 c0                	xor    %eax,%eax
  7f13dc:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f13df:	f3 0f 10 8c 24 b0 01 	movss  0x1b0(%rsp),%xmm1
  7f13e6:	00 00 
  7f13e8:	0f 2e c8             	ucomiss %xmm0,%xmm1
  7f13eb:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
  7f13f0:	f3 0f 10 94 24 94 01 	movss  0x194(%rsp),%xmm2
  7f13f7:	00 00 
  7f13f9:	0f 85 e6 0b 00 00    	jne    7f1fe5 <<gpui_canvas::text::planner::Planner>::shape+0x2d55>
  7f13ff:	0f 8b d0 f6 ff ff    	jnp    7f0ad5 <<gpui_canvas::text::planner::Planner>::shape+0x1845>
  7f1405:	e9 db 0b 00 00       	jmp    7f1fe5 <<gpui_canvas::text::planner::Planner>::shape+0x2d55>
  7f140a:	4c 89 fa             	mov    %r15,%rdx
  7f140d:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  7f1414:	00 
  7f1415:	48 89 8c 24 00 01 00 	mov    %rcx,0x100(%rsp)
  7f141c:	00 
  7f141d:	e9 2f f7 ff ff       	jmp    7f0b51 <<gpui_canvas::text::planner::Planner>::shape+0x18c1>
  7f1422:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  7f1429:	00 
  7f142a:	48 8d b4 24 80 04 00 	lea    0x480(%rsp),%rsi
  7f1431:	00 
  7f1432:	e8 59 22 00 00       	call   7f3690 <<core::iter::adapters::flatten::FlattenCompat<core::iter::adapters::map::Map<core::ops::range::Range<u32>, <parley::layout::run::Run<()>>::glyph_source_ranges::{closure#0}>, core::iter::sources::repeat_n::RepeatN<core::ops::range::Range<usize>>> as core::iter::traits::iterator::Iterator>::next>
  7f1437:	48 83 bc 24 a0 00 00 	cmpq   $0x0,0xa0(%rsp)
  7f143e:	00 00 
  7f1440:	0f 85 47 0a 00 00    	jne    7f1e8d <<gpui_canvas::text::planner::Planner>::shape+0x2bfd>
  7f1446:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  7f144d:	00 
  7f144e:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f1452:	0f 84 e2 f1 ff ff    	je     7f063a <<gpui_canvas::text::planner::Planner>::shape+0x13aa>
  7f1458:	48 8b 8c 24 18 04 00 	mov    0x418(%rsp),%rcx
  7f145f:	00 
  7f1460:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  7f1465:	48 3b 14 24          	cmp    (%rsp),%rdx
  7f1469:	75 07                	jne    7f1472 <<gpui_canvas::text::planner::Planner>::shape+0x21e2>
  7f146b:	31 db                	xor    %ebx,%ebx
  7f146d:	45 31 ff             	xor    %r15d,%r15d
  7f1470:	eb 79                	jmp    7f14eb <<gpui_canvas::text::planner::Planner>::shape+0x225b>
  7f1472:	48 8b 94 24 28 04 00 	mov    0x428(%rsp),%rdx
  7f1479:	00 
  7f147a:	48 85 d2             	test   %rdx,%rdx
  7f147d:	48 0f 44 d1          	cmove  %rcx,%rdx
  7f1481:	48 8b 1a             	mov    (%rdx),%rbx
  7f1484:	4c 8b 7a 08          	mov    0x8(%rdx),%r15
  7f1488:	4c 39 fb             	cmp    %r15,%rbx
  7f148b:	0f 87 fc 09 00 00    	ja     7f1e8d <<gpui_canvas::text::planner::Planner>::shape+0x2bfd>
  7f1491:	48 85 db             	test   %rbx,%rbx
  7f1494:	74 1a                	je     7f14b0 <<gpui_canvas::text::planner::Planner>::shape+0x2220>
  7f1496:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  7f149b:	48 39 d3             	cmp    %rdx,%rbx
  7f149e:	73 14                	jae    7f14b4 <<gpui_canvas::text::planner::Planner>::shape+0x2224>
  7f14a0:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  7f14a5:	80 3c 1a bf          	cmpb   $0xbf,(%rdx,%rbx,1)
  7f14a9:	7f 12                	jg     7f14bd <<gpui_canvas::text::planner::Planner>::shape+0x222d>
  7f14ab:	e9 dd 09 00 00       	jmp    7f1e8d <<gpui_canvas::text::planner::Planner>::shape+0x2bfd>
  7f14b0:	31 db                	xor    %ebx,%ebx
  7f14b2:	eb 09                	jmp    7f14bd <<gpui_canvas::text::planner::Planner>::shape+0x222d>
  7f14b4:	48 89 d3             	mov    %rdx,%rbx
  7f14b7:	0f 85 d0 09 00 00    	jne    7f1e8d <<gpui_canvas::text::planner::Planner>::shape+0x2bfd>
  7f14bd:	4d 85 ff             	test   %r15,%r15
  7f14c0:	74 1b                	je     7f14dd <<gpui_canvas::text::planner::Planner>::shape+0x224d>
  7f14c2:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  7f14c7:	49 39 d7             	cmp    %rdx,%r15
  7f14ca:	73 16                	jae    7f14e2 <<gpui_canvas::text::planner::Planner>::shape+0x2252>
  7f14cc:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  7f14d1:	42 80 3c 3a c0       	cmpb   $0xc0,(%rdx,%r15,1)
  7f14d6:	7d 13                	jge    7f14eb <<gpui_canvas::text::planner::Planner>::shape+0x225b>
  7f14d8:	e9 b0 09 00 00       	jmp    7f1e8d <<gpui_canvas::text::planner::Planner>::shape+0x2bfd>
  7f14dd:	45 31 ff             	xor    %r15d,%r15d
  7f14e0:	eb 09                	jmp    7f14eb <<gpui_canvas::text::planner::Planner>::shape+0x225b>
  7f14e2:	49 89 d7             	mov    %rdx,%r15
  7f14e5:	0f 85 a2 09 00 00    	jne    7f1e8d <<gpui_canvas::text::planner::Planner>::shape+0x2bfd>
  7f14eb:	8b 94 24 f8 00 00 00 	mov    0xf8(%rsp),%edx
  7f14f2:	89 54 24 10          	mov    %edx,0x10(%rsp)
  7f14f6:	0f b6 a9 8c 00 00 00 	movzbl 0x8c(%rcx),%ebp
  7f14fd:	4c 8b ac 24 48 01 00 	mov    0x148(%rsp),%r13
  7f1504:	00 
  7f1505:	49 39 c5             	cmp    %rax,%r13
  7f1508:	75 0e                	jne    7f1518 <<gpui_canvas::text::planner::Planner>::shape+0x2288>
  7f150a:	48 8d bc 24 38 01 00 	lea    0x138(%rsp),%rdi
  7f1511:	00 
  7f1512:	ff 15 a0 ce 33 00    	call   *0x33cea0(%rip)        # b2e3b8 <_DYNAMIC+0xeb8>
  7f1518:	48 8b 04 24          	mov    (%rsp),%rax
  7f151c:	01 c3                	add    %eax,%ebx
  7f151e:	41 01 c7             	add    %eax,%r15d
  7f1521:	40 80 e5 01          	and    $0x1,%bpl
  7f1525:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  7f152c:	00 
  7f152d:	4a 8d 0c 6d 00 00 00 	lea    0x0(,%r13,2),%rcx
  7f1534:	00 
  7f1535:	4c 01 e9             	add    %r13,%rcx
  7f1538:	89 1c c8             	mov    %ebx,(%rax,%rcx,8)
  7f153b:	44 89 7c c8 04       	mov    %r15d,0x4(%rax,%rcx,8)
  7f1540:	48 8b 94 24 28 03 00 	mov    0x328(%rsp),%rdx
  7f1547:	00 
  7f1548:	89 54 c8 08          	mov    %edx,0x8(%rax,%rcx,8)
  7f154c:	8b 54 24 10          	mov    0x10(%rsp),%edx
  7f1550:	89 54 c8 0c          	mov    %edx,0xc(%rax,%rcx,8)
  7f1554:	48 8b 94 24 38 02 00 	mov    0x238(%rsp),%rdx
  7f155b:	00 
  7f155c:	89 54 c8 10          	mov    %edx,0x10(%rax,%rcx,8)
  7f1560:	48 8b 94 24 40 02 00 	mov    0x240(%rsp),%rdx
  7f1567:	00 
  7f1568:	88 54 c8 14          	mov    %dl,0x14(%rax,%rcx,8)
  7f156c:	40 88 6c c8 15       	mov    %bpl,0x15(%rax,%rcx,8)
  7f1571:	49 ff c5             	inc    %r13
  7f1574:	4c 89 ac 24 48 01 00 	mov    %r13,0x148(%rsp)
  7f157b:	00 
  7f157c:	e9 b9 f0 ff ff       	jmp    7f063a <<gpui_canvas::text::planner::Planner>::shape+0x13aa>
  7f1581:	48 8b 84 24 40 03 00 	mov    0x340(%rsp),%rax
  7f1588:	00 
  7f1589:	48 39 84 24 98 00 00 	cmp    %rax,0x98(%rsp)
  7f1590:	00 
  7f1591:	48 8b 2c 24          	mov    (%rsp),%rbp
  7f1595:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
  7f159a:	0f 85 1a ec ff ff    	jne    7f01ba <<gpui_canvas::text::planner::Planner>::shape+0xf2a>
  7f15a0:	48 83 bc 24 38 01 00 	cmpq   $0xffffffffffffffff,0x138(%rsp)
  7f15a7:	00 ff 
  7f15a9:	0f 84 94 05 00 00    	je     7f1b43 <<gpui_canvas::text::planner::Planner>::shape+0x28b3>
  7f15af:	48 83 bc 24 68 01 00 	cmpq   $0xffffffffffffffff,0x168(%rsp)
  7f15b6:	00 ff 
  7f15b8:	0f 84 85 05 00 00    	je     7f1b43 <<gpui_canvas::text::planner::Planner>::shape+0x28b3>
  7f15be:	48 89 ac 24 10 04 00 	mov    %rbp,0x410(%rsp)
  7f15c5:	00 
  7f15c6:	f3 0f 10 44 24 58    	movss  0x58(%rsp),%xmm0
  7f15cc:	f3 0f 11 84 24 a0 00 	movss  %xmm0,0xa0(%rsp)
  7f15d3:	00 00 
  7f15d5:	48 03 9c 24 28 01 00 	add    0x128(%rsp),%rbx
  7f15dc:	00 
  7f15dd:	48 c7 84 24 d0 06 00 	movq   $0x0,0x6d0(%rsp)
  7f15e4:	00 00 00 00 00 
  7f15e9:	48 c7 84 24 d8 06 00 	movq   $0x8,0x6d8(%rsp)
  7f15f0:	00 08 00 00 00 
  7f15f5:	48 c7 84 24 e0 06 00 	movq   $0x0,0x6e0(%rsp)
  7f15fc:	00 00 00 00 00 
  7f1601:	c7 84 24 f0 06 00 00 	movl   $0xffffffff,0x6f0(%rsp)
  7f1608:	ff ff ff ff 
  7f160c:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7f1611:	48 89 84 24 f8 06 00 	mov    %rax,0x6f8(%rsp)
  7f1618:	00 
  7f1619:	48 89 9c 24 00 07 00 	mov    %rbx,0x700(%rsp)
  7f1620:	00 
  7f1621:	48 c7 84 24 08 07 00 	movq   $0x0,0x708(%rsp)
  7f1628:	00 00 00 00 00 
  7f162d:	48 8d 05 bc 62 31 00 	lea    0x3162bc(%rip),%rax        # b078f0 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x1c8>
  7f1634:	48 89 84 24 10 07 00 	mov    %rax,0x710(%rsp)
  7f163b:	00 
  7f163c:	48 8d 05 ed d6 ff ff 	lea    -0x2913(%rip),%rax        # 7eed30 <icu_segmenter::rule_segmenter_v1::empty_handle_complex::<icu_segmenter::scaffold::Utf8>>
  7f1643:	48 89 84 24 18 07 00 	mov    %rax,0x718(%rsp)
  7f164a:	00 
  7f164b:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7f1650:	48 89 84 24 20 07 00 	mov    %rax,0x720(%rsp)
  7f1657:	00 
  7f1658:	48 c7 84 24 28 07 00 	movq   $0x0,0x728(%rsp)
  7f165f:	00 00 00 00 00 
  7f1664:	48 c7 84 24 58 07 00 	movq   $0x0,0x758(%rsp)
  7f166b:	00 00 00 00 00 
  7f1670:	c6 84 24 60 07 00 00 	movb   $0x0,0x760(%rsp)
  7f1677:	00 
  7f1678:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f167f:	00 
  7f1680:	e8 1b c7 01 00       	call   80dda0 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  7f1685:	48 83 f8 01          	cmp    $0x1,%rax
  7f1689:	0f 85 76 03 00 00    	jne    7f1a05 <<gpui_canvas::text::planner::Planner>::shape+0x2775>
  7f168f:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f1696:	00 
  7f1697:	e8 04 c7 01 00       	call   80dda0 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  7f169c:	48 83 f8 01          	cmp    $0x1,%rax
  7f16a0:	0f 85 5f 03 00 00    	jne    7f1a05 <<gpui_canvas::text::planner::Planner>::shape+0x2775>
  7f16a6:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f16ad:	00 
  7f16ae:	e8 ed c6 01 00       	call   80dda0 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  7f16b3:	48 83 f8 01          	cmp    $0x1,%rax
  7f16b7:	0f 85 48 03 00 00    	jne    7f1a05 <<gpui_canvas::text::planner::Planner>::shape+0x2775>
  7f16bd:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f16c4:	00 
  7f16c5:	e8 d6 c6 01 00       	call   80dda0 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  7f16ca:	48 83 f8 01          	cmp    $0x1,%rax
  7f16ce:	0f 85 31 03 00 00    	jne    7f1a05 <<gpui_canvas::text::planner::Planner>::shape+0x2775>
  7f16d4:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f16db:	00 
  7f16dc:	e8 bf c6 01 00       	call   80dda0 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  7f16e1:	48 83 f8 01          	cmp    $0x1,%rax
  7f16e5:	0f 85 1a 03 00 00    	jne    7f1a05 <<gpui_canvas::text::planner::Planner>::shape+0x2775>
  7f16eb:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f16f2:	00 
  7f16f3:	e8 a8 c6 01 00       	call   80dda0 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  7f16f8:	48 83 f8 01          	cmp    $0x1,%rax
  7f16fc:	0f 85 03 03 00 00    	jne    7f1a05 <<gpui_canvas::text::planner::Planner>::shape+0x2775>
  7f1702:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f1709:	00 
  7f170a:	e8 91 c6 01 00       	call   80dda0 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  7f170f:	48 83 f8 01          	cmp    $0x1,%rax
  7f1713:	0f 85 ec 02 00 00    	jne    7f1a05 <<gpui_canvas::text::planner::Planner>::shape+0x2775>
  7f1719:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f1720:	00 
  7f1721:	e8 7a c6 01 00       	call   80dda0 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  7f1726:	a8 01                	test   $0x1,%al
  7f1728:	0f 84 d7 02 00 00    	je     7f1a05 <<gpui_canvas::text::planner::Planner>::shape+0x2775>
  7f172e:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f1735:	00 
  7f1736:	e8 65 c6 01 00       	call   80dda0 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  7f173b:	48 83 f8 01          	cmp    $0x1,%rax
  7f173f:	0f 85 c0 02 00 00    	jne    7f1a05 <<gpui_canvas::text::planner::Planner>::shape+0x2775>
  7f1745:	49 89 df             	mov    %rbx,%r15
  7f1748:	48 8b b4 24 d0 06 00 	mov    0x6d0(%rsp),%rsi
  7f174f:	00 
  7f1750:	48 85 f6             	test   %rsi,%rsi
  7f1753:	74 17                	je     7f176c <<gpui_canvas::text::planner::Planner>::shape+0x24dc>
  7f1755:	48 8b bc 24 d8 06 00 	mov    0x6d8(%rsp),%rdi
  7f175c:	00 
  7f175d:	48 c1 e6 03          	shl    $0x3,%rsi
  7f1761:	ba 08 00 00 00       	mov    $0x8,%edx
  7f1766:	ff 15 dc bf 33 00    	call   *0x33bfdc(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f176c:	48 8b 9c 24 78 01 00 	mov    0x178(%rsp),%rbx
  7f1773:	00 
  7f1774:	c6 44 24 1b 00       	movb   $0x0,0x1b(%rsp)
  7f1779:	48 c7 84 24 d0 06 00 	movq   $0x0,0x6d0(%rsp)
  7f1780:	00 00 00 00 00 
  7f1785:	48 c7 84 24 d8 06 00 	movq   $0x8,0x6d8(%rsp)
  7f178c:	00 08 00 00 00 
  7f1791:	48 c7 84 24 e0 06 00 	movq   $0x0,0x6e0(%rsp)
  7f1798:	00 00 00 00 00 
  7f179d:	c7 84 24 f0 06 00 00 	movl   $0xffffffff,0x6f0(%rsp)
  7f17a4:	ff ff ff ff 
  7f17a8:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7f17ad:	48 89 84 24 f8 06 00 	mov    %rax,0x6f8(%rsp)
  7f17b4:	00 
  7f17b5:	4c 89 bc 24 00 07 00 	mov    %r15,0x700(%rsp)
  7f17bc:	00 
  7f17bd:	48 c7 84 24 08 07 00 	movq   $0x0,0x708(%rsp)
  7f17c4:	00 00 00 00 00 
  7f17c9:	48 8d 05 20 61 31 00 	lea    0x316120(%rip),%rax        # b078f0 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x1c8>
  7f17d0:	48 89 84 24 10 07 00 	mov    %rax,0x710(%rsp)
  7f17d7:	00 
  7f17d8:	48 8d 05 51 d5 ff ff 	lea    -0x2aaf(%rip),%rax        # 7eed30 <icu_segmenter::rule_segmenter_v1::empty_handle_complex::<icu_segmenter::scaffold::Utf8>>
  7f17df:	48 89 84 24 18 07 00 	mov    %rax,0x718(%rsp)
  7f17e6:	00 
  7f17e7:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7f17ec:	48 89 84 24 20 07 00 	mov    %rax,0x720(%rsp)
  7f17f3:	00 
  7f17f4:	48 c7 84 24 28 07 00 	movq   $0x0,0x728(%rsp)
  7f17fb:	00 00 00 00 00 
  7f1800:	48 c7 84 24 58 07 00 	movq   $0x0,0x758(%rsp)
  7f1807:	00 00 00 00 00 
  7f180c:	c6 84 24 60 07 00 00 	movb   $0x0,0x760(%rsp)
  7f1813:	00 
  7f1814:	48 8d 44 24 1b       	lea    0x1b(%rsp),%rax
  7f1819:	48 89 84 24 80 04 00 	mov    %rax,0x480(%rsp)
  7f1820:	00 
  7f1821:	48 8d 84 24 68 01 00 	lea    0x168(%rsp),%rax
  7f1828:	00 
  7f1829:	48 89 84 24 88 04 00 	mov    %rax,0x488(%rsp)
  7f1830:	00 
  7f1831:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  7f1836:	48 89 bc 24 90 04 00 	mov    %rdi,0x490(%rsp)
  7f183d:	00 
  7f183e:	48 8d 84 24 10 04 00 	lea    0x410(%rsp),%rax
  7f1845:	00 
  7f1846:	48 89 84 24 98 04 00 	mov    %rax,0x498(%rsp)
  7f184d:	00 
  7f184e:	48 8d 84 24 a0 00 00 	lea    0xa0(%rsp),%rax
  7f1855:	00 
  7f1856:	48 89 84 24 a0 04 00 	mov    %rax,0x4a0(%rsp)
  7f185d:	00 
  7f185e:	48 8d b4 24 d0 06 00 	lea    0x6d0(%rsp),%rsi
  7f1865:	00 
  7f1866:	f3 0f 10 05 12 df 90 	movss  -0x6f20ee(%rip),%xmm0        # ff780 <anon.54edef65de96b8e67cbd7be652d99b9c.303.llvm.8229078508888877484+0x1c>
  7f186d:	ff 
  7f186e:	48 8d 94 24 80 04 00 	lea    0x480(%rsp),%rdx
  7f1875:	00 
  7f1876:	e8 d5 97 ff ff       	call   7eb050 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair_partial::<icu_segmenter::grapheme::GraphemeClusterBreakIterator<icu_segmenter::scaffold::Utf8>, gpui_canvas::text::planner::append_carets::{closure#0}>>
  7f187b:	84 c0                	test   %al,%al
  7f187d:	0f 84 91 04 00 00    	je     7f1d14 <<gpui_canvas::text::planner::Planner>::shape+0x2a84>
  7f1883:	48 3b 9c 24 78 01 00 	cmp    0x178(%rsp),%rbx
  7f188a:	00 
  7f188b:	77 08                	ja     7f1895 <<gpui_canvas::text::planner::Planner>::shape+0x2605>
  7f188d:	48 89 9c 24 78 01 00 	mov    %rbx,0x178(%rsp)
  7f1894:	00 
  7f1895:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f189c:	00 
  7f189d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  7f18a2:	e8 49 ac ff ff       	call   7ec4f0 <<parley::editing::geometry::CursorGeometry<()>>::new>
  7f18a7:	48 8b 84 24 d0 06 00 	mov    0x6d0(%rsp),%rax
  7f18ae:	00 
  7f18af:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f18b3:	0f 84 85 0c 00 00    	je     7f253e <<gpui_canvas::text::planner::Planner>::shape+0x32ae>
  7f18b9:	48 8d 94 24 f0 06 00 	lea    0x6f0(%rsp),%rdx
  7f18c0:	00 
  7f18c1:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  7f18c5:	49 89 4e 20          	mov    %rcx,0x20(%r14)
  7f18c9:	0f 10 42 f0          	movups -0x10(%rdx),%xmm0
  7f18cd:	0f 10 0a             	movups (%rdx),%xmm1
  7f18d0:	41 0f 11 4e 10       	movups %xmm1,0x10(%r14)
  7f18d5:	41 0f 11 06          	movups %xmm0,(%r14)
  7f18d9:	48 8b 8c 24 d8 06 00 	mov    0x6d8(%rsp),%rcx
  7f18e0:	00 
  7f18e1:	48 89 84 24 d0 02 00 	mov    %rax,0x2d0(%rsp)
  7f18e8:	00 
  7f18e9:	48 89 8c 24 d8 02 00 	mov    %rcx,0x2d8(%rsp)
  7f18f0:	00 
  7f18f1:	48 c7 84 24 d0 06 00 	movq   $0x0,0x6d0(%rsp)
  7f18f8:	00 00 00 00 00 
  7f18fd:	48 c7 84 24 d8 06 00 	movq   $0x8,0x6d8(%rsp)
  7f1904:	00 08 00 00 00 
  7f1909:	48 c7 84 24 e0 06 00 	movq   $0x0,0x6e0(%rsp)
  7f1910:	00 00 00 00 00 
  7f1915:	c7 84 24 f0 06 00 00 	movl   $0xffffffff,0x6f0(%rsp)
  7f191c:	ff ff ff ff 
  7f1920:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7f1925:	48 89 84 24 f8 06 00 	mov    %rax,0x6f8(%rsp)
  7f192c:	00 
  7f192d:	4c 89 bc 24 00 07 00 	mov    %r15,0x700(%rsp)
  7f1934:	00 
  7f1935:	48 c7 84 24 08 07 00 	movq   $0x0,0x708(%rsp)
  7f193c:	00 00 00 00 00 
  7f1941:	48 8d 05 a8 5f 31 00 	lea    0x315fa8(%rip),%rax        # b078f0 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x1c8>
  7f1948:	48 89 84 24 10 07 00 	mov    %rax,0x710(%rsp)
  7f194f:	00 
  7f1950:	48 8d 05 d9 d3 ff ff 	lea    -0x2c27(%rip),%rax        # 7eed30 <icu_segmenter::rule_segmenter_v1::empty_handle_complex::<icu_segmenter::scaffold::Utf8>>
  7f1957:	48 89 84 24 18 07 00 	mov    %rax,0x718(%rsp)
  7f195e:	00 
  7f195f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7f1964:	48 89 84 24 20 07 00 	mov    %rax,0x720(%rsp)
  7f196b:	00 
  7f196c:	48 c7 84 24 28 07 00 	movq   $0x0,0x728(%rsp)
  7f1973:	00 00 00 00 00 
  7f1978:	48 c7 84 24 58 07 00 	movq   $0x0,0x758(%rsp)
  7f197f:	00 00 00 00 00 
  7f1984:	c6 84 24 60 07 00 00 	movb   $0x0,0x760(%rsp)
  7f198b:	00 
  7f198c:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f1993:	00 
  7f1994:	e8 07 c4 01 00       	call   80dda0 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  7f1999:	48 83 f8 01          	cmp    $0x1,%rax
  7f199d:	0f 85 81 03 00 00    	jne    7f1d24 <<gpui_canvas::text::planner::Planner>::shape+0x2a94>
  7f19a3:	48 89 d3             	mov    %rdx,%rbx
  7f19a6:	48 8d bc 24 80 04 00 	lea    0x480(%rsp),%rdi
  7f19ad:	00 
  7f19ae:	48 8d b4 24 d0 02 00 	lea    0x2d0(%rsp),%rsi
  7f19b5:	00 
  7f19b6:	f3 0f 10 05 c2 dd 90 	movss  -0x6f223e(%rip),%xmm0        # ff780 <anon.54edef65de96b8e67cbd7be652d99b9c.303.llvm.8229078508888877484+0x1c>
  7f19bd:	ff 
  7f19be:	e8 bd a8 ff ff       	call   7ec280 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at>
  7f19c3:	83 bc 24 80 04 00 00 	cmpl   $0x1,0x480(%rsp)
  7f19ca:	01 
  7f19cb:	75 bf                	jne    7f198c <<gpui_canvas::text::planner::Planner>::shape+0x26fc>
  7f19cd:	48 8b 94 24 10 04 00 	mov    0x410(%rsp),%rdx
  7f19d4:	00 
  7f19d5:	f3 0f 10 84 24 a0 00 	movss  0xa0(%rsp),%xmm0
  7f19dc:	00 00 
  7f19de:	48 8d bc 24 68 01 00 	lea    0x168(%rsp),%rdi
  7f19e5:	00 
  7f19e6:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  7f19eb:	48 89 d9             	mov    %rbx,%rcx
  7f19ee:	4c 8d 84 24 80 04 00 	lea    0x480(%rsp),%r8
  7f19f5:	00 
  7f19f6:	e8 d5 18 00 00       	call   7f32d0 <gpui_canvas::text::planner::append_caret>
  7f19fb:	83 f8 ff             	cmp    $0xffffffff,%eax
  7f19fe:	74 8c                	je     7f198c <<gpui_canvas::text::planner::Planner>::shape+0x26fc>
  7f1a00:	e9 fa 0a 00 00       	jmp    7f24ff <<gpui_canvas::text::planner::Planner>::shape+0x326f>
  7f1a05:	48 8b b4 24 d0 06 00 	mov    0x6d0(%rsp),%rsi
  7f1a0c:	00 
  7f1a0d:	48 85 f6             	test   %rsi,%rsi
  7f1a10:	74 17                	je     7f1a29 <<gpui_canvas::text::planner::Planner>::shape+0x2799>
  7f1a12:	48 8b bc 24 d8 06 00 	mov    0x6d8(%rsp),%rdi
  7f1a19:	00 
  7f1a1a:	48 c1 e6 03          	shl    $0x3,%rsi
  7f1a1e:	ba 08 00 00 00       	mov    $0x8,%edx
  7f1a23:	ff 15 1f bd 33 00    	call   *0x33bd1f(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f1a29:	48 c7 84 24 d0 06 00 	movq   $0x0,0x6d0(%rsp)
  7f1a30:	00 00 00 00 00 
  7f1a35:	48 c7 84 24 d8 06 00 	movq   $0x8,0x6d8(%rsp)
  7f1a3c:	00 08 00 00 00 
  7f1a41:	48 c7 84 24 e0 06 00 	movq   $0x0,0x6e0(%rsp)
  7f1a48:	00 00 00 00 00 
  7f1a4d:	c7 84 24 f0 06 00 00 	movl   $0xffffffff,0x6f0(%rsp)
  7f1a54:	ff ff ff ff 
  7f1a58:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7f1a5d:	48 89 84 24 f8 06 00 	mov    %rax,0x6f8(%rsp)
  7f1a64:	00 
  7f1a65:	48 89 9c 24 00 07 00 	mov    %rbx,0x700(%rsp)
  7f1a6c:	00 
  7f1a6d:	48 c7 84 24 08 07 00 	movq   $0x0,0x708(%rsp)
  7f1a74:	00 00 00 00 00 
  7f1a79:	48 8d 05 70 5e 31 00 	lea    0x315e70(%rip),%rax        # b078f0 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x1c8>
  7f1a80:	48 89 84 24 10 07 00 	mov    %rax,0x710(%rsp)
  7f1a87:	00 
  7f1a88:	48 8d 05 a1 d2 ff ff 	lea    -0x2d5f(%rip),%rax        # 7eed30 <icu_segmenter::rule_segmenter_v1::empty_handle_complex::<icu_segmenter::scaffold::Utf8>>
  7f1a8f:	48 89 84 24 18 07 00 	mov    %rax,0x718(%rsp)
  7f1a96:	00 
  7f1a97:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7f1a9c:	48 89 84 24 20 07 00 	mov    %rax,0x720(%rsp)
  7f1aa3:	00 
  7f1aa4:	48 c7 84 24 28 07 00 	movq   $0x0,0x728(%rsp)
  7f1aab:	00 00 00 00 00 
  7f1ab0:	48 c7 84 24 58 07 00 	movq   $0x0,0x758(%rsp)
  7f1ab7:	00 00 00 00 00 
  7f1abc:	c6 84 24 60 07 00 00 	movb   $0x0,0x760(%rsp)
  7f1ac3:	00 
  7f1ac4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  7f1acb:	00 00 00 00 00 
  7f1ad0:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f1ad7:	00 
  7f1ad8:	e8 c3 c2 01 00       	call   80dda0 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  7f1add:	48 83 f8 01          	cmp    $0x1,%rax
  7f1ae1:	75 3c                	jne    7f1b1f <<gpui_canvas::text::planner::Planner>::shape+0x288f>
  7f1ae3:	48 89 d1             	mov    %rdx,%rcx
  7f1ae6:	48 c7 84 24 80 04 00 	movq   $0x0,0x480(%rsp)
  7f1aed:	00 00 00 00 00 
  7f1af2:	48 8d bc 24 68 01 00 	lea    0x168(%rsp),%rdi
  7f1af9:	00 
  7f1afa:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  7f1aff:	48 89 ea             	mov    %rbp,%rdx
  7f1b02:	f3 0f 10 44 24 58    	movss  0x58(%rsp),%xmm0
  7f1b08:	4c 8d 84 24 80 04 00 	lea    0x480(%rsp),%r8
  7f1b0f:	00 
  7f1b10:	e8 bb 17 00 00       	call   7f32d0 <gpui_canvas::text::planner::append_caret>
  7f1b15:	83 f8 ff             	cmp    $0xffffffff,%eax
  7f1b18:	74 b6                	je     7f1ad0 <<gpui_canvas::text::planner::Planner>::shape+0x2840>
  7f1b1a:	e9 1a 03 00 00       	jmp    7f1e39 <<gpui_canvas::text::planner::Planner>::shape+0x2ba9>
  7f1b1f:	48 8b b4 24 d0 06 00 	mov    0x6d0(%rsp),%rsi
  7f1b26:	00 
  7f1b27:	48 85 f6             	test   %rsi,%rsi
  7f1b2a:	74 17                	je     7f1b43 <<gpui_canvas::text::planner::Planner>::shape+0x28b3>
  7f1b2c:	48 8b bc 24 d8 06 00 	mov    0x6d8(%rsp),%rdi
  7f1b33:	00 
  7f1b34:	48 c1 e6 03          	shl    $0x3,%rsi
  7f1b38:	ba 08 00 00 00       	mov    $0x8,%edx
  7f1b3d:	ff 15 05 bc 33 00    	call   *0x33bc05(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f1b43:	0f 28 9c 24 60 02 00 	movaps 0x260(%rsp),%xmm3
  7f1b4a:	00 
  7f1b4b:	0f 28 c3             	movaps %xmm3,%xmm0
  7f1b4e:	f3 0f 5f 84 24 d8 00 	maxss  0xd8(%rsp),%xmm0
  7f1b55:	00 00 
  7f1b57:	0f 28 c8             	movaps %xmm0,%xmm1
  7f1b5a:	f3 0f c2 c8 03       	cmpunordss %xmm0,%xmm1
  7f1b5f:	0f 28 d1             	movaps %xmm1,%xmm2
  7f1b62:	0f 55 d0             	andnps %xmm0,%xmm2
  7f1b65:	0f 54 cb             	andps  %xmm3,%xmm1
  7f1b68:	0f 56 ca             	orps   %xmm2,%xmm1
  7f1b6b:	0f 29 8c 24 60 02 00 	movaps %xmm1,0x260(%rsp)
  7f1b72:	00 
  7f1b73:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7f1b78:	f3 0f 10 44 24 58    	movss  0x58(%rsp),%xmm0
  7f1b7e:	f3 0f 58 80 30 0a 00 	addss  0xa30(%rax),%xmm0
  7f1b85:	00 
  7f1b86:	f3 0f 11 44 24 58    	movss  %xmm0,0x58(%rsp)
  7f1b8c:	80 7c 24 4c 00       	cmpb   $0x0,0x4c(%rsp)
  7f1b91:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  7f1b98:	00 
  7f1b99:	8b b4 24 80 00 00 00 	mov    0x80(%rsp),%esi
  7f1ba0:	48 8b ac 24 90 00 00 	mov    0x90(%rsp),%rbp
  7f1ba7:	00 
  7f1ba8:	0f 84 37 dd ff ff    	je     7ef8e5 <<gpui_canvas::text::planner::Planner>::shape+0x655>
  7f1bae:	e9 d0 03 00 00       	jmp    7f1f83 <<gpui_canvas::text::planner::Planner>::shape+0x2cf3>
  7f1bb3:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  7f1bb8:	48 8b 81 d8 09 00 00 	mov    0x9d8(%rcx),%rax
  7f1bbf:	48 6b 89 e0 09 00 00 	imul   $0x70,0x9e0(%rcx),%rcx
  7f1bc6:	70 
  7f1bc7:	48 01 c1             	add    %rax,%rcx
  7f1bca:	48 89 84 24 d0 06 00 	mov    %rax,0x6d0(%rsp)
  7f1bd1:	00 
  7f1bd2:	48 89 8c 24 d8 06 00 	mov    %rcx,0x6d8(%rsp)
  7f1bd9:	00 
  7f1bda:	48 c7 84 24 e0 06 00 	movq   $0x0,0x6e0(%rsp)
  7f1be1:	00 00 00 00 00 
  7f1be6:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  7f1beb:	48 89 84 24 e8 06 00 	mov    %rax,0x6e8(%rsp)
  7f1bf2:	00 
  7f1bf3:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f1bfa:	00 
  7f1bfb:	31 f6                	xor    %esi,%esi
  7f1bfd:	48 8d 94 24 e7 00 00 	lea    0xe7(%rsp),%rdx
  7f1c04:	00 
  7f1c05:	e8 d6 bf 00 00       	call   7fdbe0 <<core::iter::adapters::map::Map<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#3}> as core::iter::traits::iterator::Iterator>::fold::<usize, <core::iter::adapters::flatten::FlattenCompat<_, _>>::iter_fold::flatten<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>, usize, <core::iter::adapters::flatten::FlattenCompat<_, _> as core::iter::traits::iterator::Iterator>::count::count<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>>>::{closure#0}>>
  7f1c0a:	48 83 f8 02          	cmp    $0x2,%rax
  7f1c0e:	0f 82 6f e3 ff ff    	jb     7eff83 <<gpui_canvas::text::planner::Planner>::shape+0xcf3>
  7f1c14:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  7f1c1b:	48 83 bc 24 38 01 00 	cmpq   $0xffffffffffffffff,0x138(%rsp)
  7f1c22:	00 ff 
  7f1c24:	0f 84 dc e2 ff ff    	je     7eff06 <<gpui_canvas::text::planner::Planner>::shape+0xc76>
  7f1c2a:	e9 54 e3 ff ff       	jmp    7eff83 <<gpui_canvas::text::planner::Planner>::shape+0xcf3>
  7f1c2f:	c7 84 24 80 00 00 00 	movl   $0xffffffff,0x80(%rsp)
  7f1c36:	ff ff ff ff 
  7f1c3a:	e9 10 df ff ff       	jmp    7efb4f <<gpui_canvas::text::planner::Planner>::shape+0x8bf>
  7f1c3f:	44 89 d2             	mov    %r10d,%edx
  7f1c42:	83 e2 1f             	and    $0x1f,%edx
  7f1c45:	41 0f b6 79 01       	movzbl 0x1(%r9),%edi
  7f1c4a:	83 e7 3f             	and    $0x3f,%edi
  7f1c4d:	41 80 fa df          	cmp    $0xdf,%r10b
  7f1c51:	76 31                	jbe    7f1c84 <<gpui_canvas::text::planner::Planner>::shape+0x29f4>
  7f1c53:	41 0f b6 71 02       	movzbl 0x2(%r9),%esi
  7f1c58:	c1 e7 06             	shl    $0x6,%edi
  7f1c5b:	83 e6 3f             	and    $0x3f,%esi
  7f1c5e:	09 fe                	or     %edi,%esi
  7f1c60:	41 80 fa f0          	cmp    $0xf0,%r10b
  7f1c64:	72 2c                	jb     7f1c92 <<gpui_canvas::text::planner::Planner>::shape+0x2a02>
  7f1c66:	4d 8d 59 04          	lea    0x4(%r9),%r11
  7f1c6a:	45 0f b6 51 03       	movzbl 0x3(%r9),%r10d
  7f1c6f:	83 e2 07             	and    $0x7,%edx
  7f1c72:	c1 e2 12             	shl    $0x12,%edx
  7f1c75:	c1 e6 06             	shl    $0x6,%esi
  7f1c78:	41 83 e2 3f          	and    $0x3f,%r10d
  7f1c7c:	41 09 f2             	or     %esi,%r10d
  7f1c7f:	41 09 d2             	or     %edx,%r10d
  7f1c82:	eb 1a                	jmp    7f1c9e <<gpui_canvas::text::planner::Planner>::shape+0x2a0e>
  7f1c84:	4d 8d 59 02          	lea    0x2(%r9),%r11
  7f1c88:	c1 e2 06             	shl    $0x6,%edx
  7f1c8b:	09 fa                	or     %edi,%edx
  7f1c8d:	41 89 d2             	mov    %edx,%r10d
  7f1c90:	eb 0c                	jmp    7f1c9e <<gpui_canvas::text::planner::Planner>::shape+0x2a0e>
  7f1c92:	4d 8d 59 03          	lea    0x3(%r9),%r11
  7f1c96:	c1 e2 0c             	shl    $0xc,%edx
  7f1c99:	09 d6                	or     %edx,%esi
  7f1c9b:	41 89 f2             	mov    %esi,%r10d
  7f1c9e:	49 8d 50 02          	lea    0x2(%r8),%rdx
  7f1ca2:	4c 89 c1             	mov    %r8,%rcx
  7f1ca5:	48 89 c6             	mov    %rax,%rsi
  7f1ca8:	4c 29 ce             	sub    %r9,%rsi
  7f1cab:	4c 01 de             	add    %r11,%rsi
  7f1cae:	41 83 fa 0a          	cmp    $0xa,%r10d
  7f1cb2:	bf fe ff ff ff       	mov    $0xfffffffe,%edi
  7f1cb7:	44 0f 44 d7          	cmove  %edi,%r10d
  7f1cbb:	44 89 94 24 80 00 00 	mov    %r10d,0x80(%rsp)
  7f1cc2:	00 
  7f1cc3:	48 8b bc 24 90 00 00 	mov    0x90(%rsp),%rdi
  7f1cca:	00 
  7f1ccb:	48 0f 44 fa          	cmove  %rdx,%rdi
  7f1ccf:	48 89 bc 24 90 00 00 	mov    %rdi,0x90(%rsp)
  7f1cd6:	00 
  7f1cd7:	c7 44 24 4c 00 00 00 	movl   $0x0,0x4c(%rsp)
  7f1cde:	00 
  7f1cdf:	48 89 84 24 48 03 00 	mov    %rax,0x348(%rsp)
  7f1ce6:	00 
  7f1ce7:	48 89 f0             	mov    %rsi,%rax
  7f1cea:	4c 89 5c 24 30       	mov    %r11,0x30(%rsp)
  7f1cef:	e9 66 de ff ff       	jmp    7efb5a <<gpui_canvas::text::planner::Planner>::shape+0x8ca>
  7f1cf4:	b9 04 00 00 00       	mov    $0x4,%ecx
  7f1cf9:	41 b8 10 00 00 00    	mov    $0x10,%r8d
  7f1cff:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  7f1d06:	00 
  7f1d07:	4c 89 ea             	mov    %r13,%rdx
  7f1d0a:	e8 b1 fd 00 00       	call   801ac0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  7f1d0f:	e9 d0 e3 ff ff       	jmp    7f00e4 <<gpui_canvas::text::planner::Planner>::shape+0xe54>
  7f1d14:	80 7c 24 1b 00       	cmpb   $0x0,0x1b(%rsp)
  7f1d19:	0f 84 24 fe ff ff    	je     7f1b43 <<gpui_canvas::text::planner::Planner>::shape+0x28b3>
  7f1d1f:	e9 13 08 00 00       	jmp    7f2537 <<gpui_canvas::text::planner::Planner>::shape+0x32a7>
  7f1d24:	48 8b b4 24 d0 06 00 	mov    0x6d0(%rsp),%rsi
  7f1d2b:	00 
  7f1d2c:	48 85 f6             	test   %rsi,%rsi
  7f1d2f:	74 17                	je     7f1d48 <<gpui_canvas::text::planner::Planner>::shape+0x2ab8>
  7f1d31:	48 8b bc 24 d8 06 00 	mov    0x6d8(%rsp),%rdi
  7f1d38:	00 
  7f1d39:	48 c1 e6 03          	shl    $0x3,%rsi
  7f1d3d:	ba 08 00 00 00       	mov    $0x8,%edx
  7f1d42:	ff 15 00 ba 33 00    	call   *0x33ba00(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f1d48:	48 8d bc 24 d0 02 00 	lea    0x2d0(%rsp),%rdi
  7f1d4f:	00 
  7f1d50:	e8 0b bd ff ff       	call   7eda60 <core::ptr::drop_glue::<parley::editing::geometry::CursorGeometry<()>>>
  7f1d55:	e9 e9 fd ff ff       	jmp    7f1b43 <<gpui_canvas::text::planner::Planner>::shape+0x28b3>
  7f1d5a:	c7 84 24 a8 00 00 00 	movl   $0x7,0xa8(%rsp)
  7f1d61:	07 00 00 00 
  7f1d65:	48 c7 84 24 a0 00 00 	movq   $0xffffffffffffffff,0xa0(%rsp)
  7f1d6c:	00 ff ff ff ff 
  7f1d71:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  7f1d78:	00 
  7f1d79:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f1d7d:	0f 85 e1 07 00 00    	jne    7f2564 <<gpui_canvas::text::planner::Planner>::shape+0x32d4>
  7f1d83:	e9 52 08 00 00       	jmp    7f25da <<gpui_canvas::text::planner::Planner>::shape+0x334a>
  7f1d88:	c7 84 24 a8 00 00 00 	movl   $0x4,0xa8(%rsp)
  7f1d8f:	04 00 00 00 
  7f1d93:	48 c7 84 24 a0 00 00 	movq   $0xffffffffffffffff,0xa0(%rsp)
  7f1d9a:	00 ff ff ff ff 
  7f1d9f:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  7f1da6:	00 
  7f1da7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f1dab:	0f 85 b3 07 00 00    	jne    7f2564 <<gpui_canvas::text::planner::Planner>::shape+0x32d4>
  7f1db1:	e9 24 08 00 00       	jmp    7f25da <<gpui_canvas::text::planner::Planner>::shape+0x334a>
  7f1db6:	48 8d 35 b3 f2 33 00 	lea    0x33f2b3(%rip),%rsi        # b31070 <gpui_canvas::text::HEBREW_FONT>
  7f1dbd:	48 8d 15 b4 20 95 ff 	lea    -0x6adf4c(%rip),%rdx        # 143e78 <gpui_canvas::text::HEBREW_BYTES>
  7f1dc4:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f1dcb:	00 
  7f1dcc:	b9 14 69 00 00       	mov    $0x6914,%ecx
  7f1dd1:	45 31 c0             	xor    %r8d,%r8d
  7f1dd4:	e8 77 fd 00 00       	call   801b50 <<gpui_canvas::text::FontFace>::shared_static>
  7f1dd9:	80 bc 24 d0 06 00 00 	cmpb   $0x0,0x6d0(%rsp)
  7f1de0:	00 
  7f1de1:	0f 85 93 d8 ff ff    	jne    7ef67a <<gpui_canvas::text::planner::Planner>::shape+0x3ea>
  7f1de7:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7f1dec:	4c 8d b8 50 0a 00 00 	lea    0xa50(%rax),%r15
  7f1df3:	4c 8b a4 24 d8 06 00 	mov    0x6d8(%rsp),%r12
  7f1dfa:	00 
  7f1dfb:	49 8b 07             	mov    (%r15),%rax
  7f1dfe:	48 85 c0             	test   %rax,%rax
  7f1e01:	74 0f                	je     7f1e12 <<gpui_canvas::text::planner::Planner>::shape+0x2b82>
  7f1e03:	f0 48 ff 08          	lock decq (%rax)
  7f1e07:	75 09                	jne    7f1e12 <<gpui_canvas::text::planner::Planner>::shape+0x2b82>
  7f1e09:	4c 89 ff             	mov    %r15,%rdi
  7f1e0c:	ff 15 e6 b9 33 00    	call   *0x33b9e6(%rip)        # b2d7f8 <_DYNAMIC+0x2f8>
  7f1e12:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  7f1e17:	4c 89 a7 50 0a 00 00 	mov    %r12,0xa50(%rdi)
  7f1e1e:	be 02 00 00 00       	mov    $0x2,%esi
  7f1e23:	e8 48 0f 00 00       	call   7f2d70 <<gpui_canvas::text::planner::Planner>::register>
  7f1e28:	83 f8 ff             	cmp    $0xffffffff,%eax
  7f1e2b:	8b 14 24             	mov    (%rsp),%edx
  7f1e2e:	0f 85 a8 d8 ff ff    	jne    7ef6dc <<gpui_canvas::text::planner::Planner>::shape+0x44c>
  7f1e34:	e9 e2 d8 ff ff       	jmp    7ef71b <<gpui_canvas::text::planner::Planner>::shape+0x48b>
  7f1e39:	48 8b b4 24 d0 06 00 	mov    0x6d0(%rsp),%rsi
  7f1e40:	00 
  7f1e41:	48 85 f6             	test   %rsi,%rsi
  7f1e44:	0f 84 f9 06 00 00    	je     7f2543 <<gpui_canvas::text::planner::Planner>::shape+0x32b3>
  7f1e4a:	48 8b bc 24 d8 06 00 	mov    0x6d8(%rsp),%rdi
  7f1e51:	00 
  7f1e52:	48 c1 e6 03          	shl    $0x3,%rsi
  7f1e56:	ba 08 00 00 00       	mov    $0x8,%edx
  7f1e5b:	89 c3                	mov    %eax,%ebx
  7f1e5d:	ff 15 e5 b8 33 00    	call   *0x33b8e5(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f1e63:	89 9c 24 a8 00 00 00 	mov    %ebx,0xa8(%rsp)
  7f1e6a:	48 c7 84 24 a0 00 00 	movq   $0xffffffffffffffff,0xa0(%rsp)
  7f1e71:	00 ff ff ff ff 
  7f1e76:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  7f1e7d:	00 
  7f1e7e:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f1e82:	0f 85 dc 06 00 00    	jne    7f2564 <<gpui_canvas::text::planner::Planner>::shape+0x32d4>
  7f1e88:	e9 4d 07 00 00       	jmp    7f25da <<gpui_canvas::text::planner::Planner>::shape+0x334a>
  7f1e8d:	c7 84 24 a8 00 00 00 	movl   $0x3,0xa8(%rsp)
  7f1e94:	03 00 00 00 
  7f1e98:	48 c7 84 24 a0 00 00 	movq   $0xffffffffffffffff,0xa0(%rsp)
  7f1e9f:	00 ff ff ff ff 
  7f1ea4:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  7f1eab:	00 
  7f1eac:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f1eb0:	0f 85 ae 06 00 00    	jne    7f2564 <<gpui_canvas::text::planner::Planner>::shape+0x32d4>
  7f1eb6:	e9 1f 07 00 00       	jmp    7f25da <<gpui_canvas::text::planner::Planner>::shape+0x334a>
  7f1ebb:	48 c7 84 24 a8 00 00 	movq   $0x3,0xa8(%rsp)
  7f1ec2:	00 03 00 00 00 
  7f1ec7:	48 c7 84 24 a0 00 00 	movq   $0xffffffffffffffff,0xa0(%rsp)
  7f1ece:	00 ff ff ff ff 
  7f1ed3:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  7f1eda:	00 
  7f1edb:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f1edf:	0f 85 7f 06 00 00    	jne    7f2564 <<gpui_canvas::text::planner::Planner>::shape+0x32d4>
  7f1ee5:	e9 f0 06 00 00       	jmp    7f25da <<gpui_canvas::text::planner::Planner>::shape+0x334a>
  7f1eea:	c7 84 24 a8 00 00 00 	movl   $0x1,0xa8(%rsp)
  7f1ef1:	01 00 00 00 
  7f1ef5:	48 c7 84 24 a0 00 00 	movq   $0xffffffffffffffff,0xa0(%rsp)
  7f1efc:	00 ff ff ff ff 
  7f1f01:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  7f1f08:	00 
  7f1f09:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f1f0d:	0f 85 51 06 00 00    	jne    7f2564 <<gpui_canvas::text::planner::Planner>::shape+0x32d4>
  7f1f13:	e9 c2 06 00 00       	jmp    7f25da <<gpui_canvas::text::planner::Planner>::shape+0x334a>
  7f1f18:	c7 84 24 a8 00 00 00 	movl   $0x3,0xa8(%rsp)
  7f1f1f:	03 00 00 00 
  7f1f23:	8b 84 24 04 02 00 00 	mov    0x204(%rsp),%eax
  7f1f2a:	89 84 24 ac 00 00 00 	mov    %eax,0xac(%rsp)
  7f1f31:	48 c7 84 24 a0 00 00 	movq   $0xffffffffffffffff,0xa0(%rsp)
  7f1f38:	00 ff ff ff ff 
  7f1f3d:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  7f1f44:	00 
  7f1f45:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f1f49:	0f 85 15 06 00 00    	jne    7f2564 <<gpui_canvas::text::planner::Planner>::shape+0x32d4>
  7f1f4f:	e9 86 06 00 00       	jmp    7f25da <<gpui_canvas::text::planner::Planner>::shape+0x334a>
  7f1f54:	48 c7 84 24 a8 00 00 	movq   $0xc,0xa8(%rsp)
  7f1f5b:	00 0c 00 00 00 
  7f1f60:	48 c7 84 24 a0 00 00 	movq   $0xffffffffffffffff,0xa0(%rsp)
  7f1f67:	00 ff ff ff ff 
  7f1f6c:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  7f1f73:	00 
  7f1f74:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f1f78:	0f 85 e6 05 00 00    	jne    7f2564 <<gpui_canvas::text::planner::Planner>::shape+0x32d4>
  7f1f7e:	e9 57 06 00 00       	jmp    7f25da <<gpui_canvas::text::planner::Planner>::shape+0x334a>
  7f1f83:	48 83 bc 24 38 01 00 	cmpq   $0xffffffffffffffff,0x138(%rsp)
  7f1f8a:	00 ff 
  7f1f8c:	0f 84 44 01 00 00    	je     7f20d6 <<gpui_canvas::text::planner::Planner>::shape+0x2e46>
  7f1f92:	48 8b 84 24 68 01 00 	mov    0x168(%rsp),%rax
  7f1f99:	00 
  7f1f9a:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f1f9e:	0f 84 06 03 00 00    	je     7f22aa <<gpui_canvas::text::planner::Planner>::shape+0x301a>
  7f1fa4:	48 8b b4 24 78 01 00 	mov    0x178(%rsp),%rsi
  7f1fab:	00 
  7f1fac:	48 39 f0             	cmp    %rsi,%rax
  7f1faf:	0f 86 f5 02 00 00    	jbe    7f22aa <<gpui_canvas::text::planner::Planner>::shape+0x301a>
  7f1fb5:	48 8d bc 24 68 01 00 	lea    0x168(%rsp),%rdi
  7f1fbc:	00 
  7f1fbd:	e8 fe 0f 00 00       	call   7f2fc0 <<alloc::raw_vec::RawVecInner>::shrink>
  7f1fc2:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f1fc6:	0f 84 de 02 00 00    	je     7f22aa <<gpui_canvas::text::planner::Planner>::shape+0x301a>
  7f1fcc:	48 89 c7             	mov    %rax,%rdi
  7f1fcf:	48 89 d6             	mov    %rdx,%rsi
  7f1fd2:	ff 15 00 b8 33 00    	call   *0x33b800(%rip)        # b2d7d8 <_DYNAMIC+0x2d8>
  7f1fd8:	e9 1a 09 00 00       	jmp    7f28f7 <<gpui_canvas::text::planner::Planner>::shape+0x3667>
  7f1fdd:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%rsp)
  7f1fe4:	00 
  7f1fe5:	4c 8b 8c 24 30 03 00 	mov    0x330(%rsp),%r9
  7f1fec:	00 
  7f1fed:	4d 85 c9             	test   %r9,%r9
  7f1ff0:	74 1c                	je     7f200e <<gpui_canvas::text::planner::Planner>::shape+0x2d7e>
  7f1ff2:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7f1ff7:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  7f1ffc:	8b 4c 24 1c          	mov    0x1c(%rsp),%ecx
  7f2000:	49 39 c1             	cmp    %rax,%r9
  7f2003:	73 1c                	jae    7f2021 <<gpui_canvas::text::planner::Planner>::shape+0x2d91>
  7f2005:	43 80 3c 08 bf       	cmpb   $0xbf,(%r8,%r9,1)
  7f200a:	7f 1a                	jg     7f2026 <<gpui_canvas::text::planner::Planner>::shape+0x2d96>
  7f200c:	eb 41                	jmp    7f204f <<gpui_canvas::text::planner::Planner>::shape+0x2dbf>
  7f200e:	45 31 c9             	xor    %r9d,%r9d
  7f2011:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7f2016:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  7f201b:	8b 4c 24 1c          	mov    0x1c(%rsp),%ecx
  7f201f:	eb 05                	jmp    7f2026 <<gpui_canvas::text::planner::Planner>::shape+0x2d96>
  7f2021:	49 89 c1             	mov    %rax,%r9
  7f2024:	75 29                	jne    7f204f <<gpui_canvas::text::planner::Planner>::shape+0x2dbf>
  7f2026:	84 c9                	test   %cl,%cl
  7f2028:	74 15                	je     7f203f <<gpui_canvas::text::planner::Planner>::shape+0x2daf>
  7f202a:	4c 39 cd             	cmp    %r9,%rbp
  7f202d:	74 20                	je     7f204f <<gpui_canvas::text::planner::Planner>::shape+0x2dbf>
  7f202f:	43 0f b6 0c 08       	movzbl (%r8,%r9,1),%ecx
  7f2034:	84 c9                	test   %cl,%cl
  7f2036:	78 52                	js     7f208a <<gpui_canvas::text::planner::Planner>::shape+0x2dfa>
  7f2038:	b8 0b 00 00 00       	mov    $0xb,%eax
  7f203d:	eb 1a                	jmp    7f2059 <<gpui_canvas::text::planner::Planner>::shape+0x2dc9>
  7f203f:	48 39 c5             	cmp    %rax,%rbp
  7f2042:	73 09                	jae    7f204d <<gpui_canvas::text::planner::Planner>::shape+0x2dbd>
  7f2044:	41 80 3c 28 bf       	cmpb   $0xbf,(%r8,%rbp,1)
  7f2049:	7f df                	jg     7f202a <<gpui_canvas::text::planner::Planner>::shape+0x2d9a>
  7f204b:	eb 02                	jmp    7f204f <<gpui_canvas::text::planner::Planner>::shape+0x2dbf>
  7f204d:	74 db                	je     7f202a <<gpui_canvas::text::planner::Planner>::shape+0x2d9a>
  7f204f:	b8 03 00 00 00       	mov    $0x3,%eax
  7f2054:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  7f2059:	89 84 24 a8 00 00 00 	mov    %eax,0xa8(%rsp)
  7f2060:	89 8c 24 ac 00 00 00 	mov    %ecx,0xac(%rsp)
  7f2067:	48 c7 84 24 a0 00 00 	movq   $0xffffffffffffffff,0xa0(%rsp)
  7f206e:	00 ff ff ff ff 
  7f2073:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  7f207a:	00 
  7f207b:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f207f:	0f 85 df 04 00 00    	jne    7f2564 <<gpui_canvas::text::planner::Planner>::shape+0x32d4>
  7f2085:	e9 50 05 00 00       	jmp    7f25da <<gpui_canvas::text::planner::Planner>::shape+0x334a>
  7f208a:	89 ca                	mov    %ecx,%edx
  7f208c:	83 e2 1f             	and    $0x1f,%edx
  7f208f:	43 0f b6 7c 08 01    	movzbl 0x1(%r8,%r9,1),%edi
  7f2095:	83 e7 3f             	and    $0x3f,%edi
  7f2098:	b8 0b 00 00 00       	mov    $0xb,%eax
  7f209d:	80 f9 df             	cmp    $0xdf,%cl
  7f20a0:	76 2b                	jbe    7f20cd <<gpui_canvas::text::planner::Planner>::shape+0x2e3d>
  7f20a2:	43 0f b6 74 08 02    	movzbl 0x2(%r8,%r9,1),%esi
  7f20a8:	c1 e7 06             	shl    $0x6,%edi
  7f20ab:	83 e6 3f             	and    $0x3f,%esi
  7f20ae:	09 fe                	or     %edi,%esi
  7f20b0:	80 f9 f0             	cmp    $0xf0,%cl
  7f20b3:	72 69                	jb     7f211e <<gpui_canvas::text::planner::Planner>::shape+0x2e8e>
  7f20b5:	43 0f b6 4c 08 03    	movzbl 0x3(%r8,%r9,1),%ecx
  7f20bb:	83 e2 07             	and    $0x7,%edx
  7f20be:	c1 e2 12             	shl    $0x12,%edx
  7f20c1:	c1 e6 06             	shl    $0x6,%esi
  7f20c4:	83 e1 3f             	and    $0x3f,%ecx
  7f20c7:	09 f1                	or     %esi,%ecx
  7f20c9:	09 d1                	or     %edx,%ecx
  7f20cb:	eb 8c                	jmp    7f2059 <<gpui_canvas::text::planner::Planner>::shape+0x2dc9>
  7f20cd:	c1 e2 06             	shl    $0x6,%edx
  7f20d0:	09 fa                	or     %edi,%edx
  7f20d2:	89 d1                	mov    %edx,%ecx
  7f20d4:	eb 83                	jmp    7f2059 <<gpui_canvas::text::planner::Planner>::shape+0x2dc9>
  7f20d6:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  7f20dd:	00 
  7f20de:	48 85 c0             	test   %rax,%rax
  7f20e1:	0f 84 a2 00 00 00    	je     7f2189 <<gpui_canvas::text::planner::Planner>::shape+0x2ef9>
  7f20e7:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  7f20ee:	00 
  7f20ef:	48 c1 e0 04          	shl    $0x4,%rax
  7f20f3:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  7f20f8:	2b 54 01 f0          	sub    -0x10(%rcx,%rax,1),%edx
  7f20fc:	0f 83 94 00 00 00    	jae    7f2196 <<gpui_canvas::text::planner::Planner>::shape+0x2f06>
  7f2102:	c7 84 24 a8 00 00 00 	movl   $0x3,0xa8(%rsp)
  7f2109:	03 00 00 00 
  7f210d:	48 c7 84 24 a0 00 00 	movq   $0xffffffffffffffff,0xa0(%rsp)
  7f2114:	00 ff ff ff ff 
  7f2119:	e9 bc 04 00 00       	jmp    7f25da <<gpui_canvas::text::planner::Planner>::shape+0x334a>
  7f211e:	c1 e2 0c             	shl    $0xc,%edx
  7f2121:	09 d6                	or     %edx,%esi
  7f2123:	89 f1                	mov    %esi,%ecx
  7f2125:	e9 2f ff ff ff       	jmp    7f2059 <<gpui_canvas::text::planner::Planner>::shape+0x2dc9>
  7f212a:	48 8d 3d c7 70 91 ff 	lea    -0x6e8f39(%rip),%rdi        # 1091f8 <anon.872511035938b47e5ff3fca4d5f52bd9.32.llvm.13397295954564461389>
  7f2131:	48 8d 15 d8 5a 31 00 	lea    0x315ad8(%rip),%rdx        # b07c10 <anon.872511035938b47e5ff3fca4d5f52bd9.33.llvm.13397295954564461389>
  7f2138:	be ad 00 00 00       	mov    $0xad,%esi
  7f213d:	ff 15 5d b6 33 00    	call   *0x33b65d(%rip)        # b2d7a0 <_DYNAMIC+0x2a0>
  7f2143:	e9 af 07 00 00       	jmp    7f28f7 <<gpui_canvas::text::planner::Planner>::shape+0x3667>
  7f2148:	48 8d 0d 81 56 31 00 	lea    0x315681(%rip),%rcx        # b077d0 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0xa8>
  7f214f:	4c 89 ef             	mov    %r13,%rdi
  7f2152:	48 8b 94 24 20 01 00 	mov    0x120(%rsp),%rdx
  7f2159:	00 
  7f215a:	ff 15 30 b6 33 00    	call   *0x33b630(%rip)        # b2d790 <_DYNAMIC+0x290>
  7f2160:	e9 92 07 00 00       	jmp    7f28f7 <<gpui_canvas::text::planner::Planner>::shape+0x3667>
  7f2165:	41 bc 03 00 00 00    	mov    $0x3,%r12d
  7f216b:	8b 44 24 20          	mov    0x20(%rsp),%eax
  7f216f:	41 89 c7             	mov    %eax,%r15d
  7f2172:	e9 6b d5 ff ff       	jmp    7ef6e2 <<gpui_canvas::text::planner::Planner>::shape+0x452>
  7f2177:	41 bc 03 00 00 00    	mov    $0x3,%r12d
  7f217d:	8b 44 24 38          	mov    0x38(%rsp),%eax
  7f2181:	41 89 c7             	mov    %eax,%r15d
  7f2184:	e9 59 d5 ff ff       	jmp    7ef6e2 <<gpui_canvas::text::planner::Planner>::shape+0x452>
  7f2189:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  7f218f:	75 11                	jne    7f21a2 <<gpui_canvas::text::planner::Planner>::shape+0x2f12>
  7f2191:	e9 14 01 00 00       	jmp    7f22aa <<gpui_canvas::text::planner::Planner>::shape+0x301a>
  7f2196:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  7f219c:	0f 86 99 02 00 00    	jbe    7f243b <<gpui_canvas::text::planner::Planner>::shape+0x31ab>
  7f21a2:	bf 04 00 00 00       	mov    $0x4,%edi
  7f21a7:	be 18 00 00 00       	mov    $0x18,%esi
  7f21ac:	e8 df 10 00 00       	call   7f3290 <alloc::boxed::box_new_uninit>
  7f21b1:	49 89 c7             	mov    %rax,%r15
  7f21b4:	8b 84 24 f8 00 00 00 	mov    0xf8(%rsp),%eax
  7f21bb:	41 c7 07 00 00 00 00 	movl   $0x0,(%r15)
  7f21c2:	4c 8b 74 24 60       	mov    0x60(%rsp),%r14
  7f21c7:	45 89 77 04          	mov    %r14d,0x4(%r15)
  7f21cb:	41 c7 47 08 00 00 00 	movl   $0x0,0x8(%r15)
  7f21d2:	00 
  7f21d3:	41 89 47 0c          	mov    %eax,0xc(%r15)
  7f21d7:	41 c7 47 10 00 00 00 	movl   $0x0,0x10(%r15)
  7f21de:	00 
  7f21df:	66 41 c7 47 14 00 00 	movw   $0x0,0x14(%r15)
  7f21e6:	bf 04 00 00 00       	mov    $0x4,%edi
  7f21eb:	be 18 00 00 00       	mov    $0x18,%esi
  7f21f0:	e8 9b 10 00 00       	call   7f3290 <alloc::boxed::box_new_uninit>
  7f21f5:	48 89 c3             	mov    %rax,%rbx
  7f21f8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  7f21fe:	44 89 70 04          	mov    %r14d,0x4(%rax)
  7f2202:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  7f2209:	f3 0f 10 44 24 58    	movss  0x58(%rsp),%xmm0
  7f220f:	f3 0f 11 40 0c       	movss  %xmm0,0xc(%rax)
  7f2214:	f3 0f 10 44 24 7c    	movss  0x7c(%rsp),%xmm0
  7f221a:	f3 0f 11 40 10       	movss  %xmm0,0x10(%rax)
  7f221f:	0f 28 84 24 60 02 00 	movaps 0x260(%rsp),%xmm0
  7f2226:	00 
  7f2227:	f3 0f 11 40 14       	movss  %xmm0,0x14(%rax)
  7f222c:	48 83 bc 24 38 01 00 	cmpq   $0xffffffffffffffff,0x138(%rsp)
  7f2233:	00 ff 
  7f2235:	74 0d                	je     7f2244 <<gpui_canvas::text::planner::Planner>::shape+0x2fb4>
  7f2237:	48 8d bc 24 38 01 00 	lea    0x138(%rsp),%rdi
  7f223e:	00 
  7f223f:	e8 4c c8 ff ff       	call   7eea90 <core::ptr::drop_glue::<gpui_canvas::text::layout::TextGeometry>>
  7f2244:	48 c7 84 24 38 01 00 	movq   $0x1,0x138(%rsp)
  7f224b:	00 01 00 00 00 
  7f2250:	4c 89 bc 24 40 01 00 	mov    %r15,0x140(%rsp)
  7f2257:	00 
  7f2258:	48 c7 84 24 48 01 00 	movq   $0x1,0x148(%rsp)
  7f225f:	00 01 00 00 00 
  7f2264:	48 c7 84 24 50 01 00 	movq   $0x1,0x150(%rsp)
  7f226b:	00 01 00 00 00 
  7f2270:	48 89 9c 24 58 01 00 	mov    %rbx,0x158(%rsp)
  7f2277:	00 
  7f2278:	48 c7 84 24 60 01 00 	movq   $0x1,0x160(%rsp)
  7f227f:	00 01 00 00 00 
  7f2284:	48 c7 84 24 68 01 00 	movq   $0xffffffffffffffff,0x168(%rsp)
  7f228b:	00 ff ff ff ff 
  7f2290:	44 89 b4 24 80 01 00 	mov    %r14d,0x180(%rsp)
  7f2297:	00 
  7f2298:	f3 0f 10 84 24 84 00 	movss  0x84(%rsp),%xmm0
  7f229f:	00 00 
  7f22a1:	f3 0f 11 84 24 84 01 	movss  %xmm0,0x184(%rsp)
  7f22a8:	00 00 
  7f22aa:	4c 8b bc 24 e8 00 00 	mov    0xe8(%rsp),%r15
  7f22b1:	00 
  7f22b2:	4c 8b a4 24 f0 00 00 	mov    0xf0(%rsp),%r12
  7f22b9:	00 
  7f22ba:	4c 8b b4 24 f8 00 00 	mov    0xf8(%rsp),%r14
  7f22c1:	00 
  7f22c2:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  7f22c7:	48 8b b4 24 f0 01 00 	mov    0x1f0(%rsp),%rsi
  7f22ce:	00 
  7f22cf:	e8 5c 09 00 00       	call   7f2c30 <<gpui_canvas::text::planner::Planner>::font_set>
  7f22d4:	49 89 c5             	mov    %rax,%r13
  7f22d7:	48 89 84 24 80 04 00 	mov    %rax,0x480(%rsp)
  7f22de:	00 
  7f22df:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  7f22e6:	00 
  7f22e7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f22eb:	0f 84 c3 00 00 00    	je     7f23b4 <<gpui_canvas::text::planner::Planner>::shape+0x3124>
  7f22f1:	48 8d 94 24 40 01 00 	lea    0x140(%rsp),%rdx
  7f22f8:	00 
  7f22f9:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
  7f22fd:	48 89 8c 24 28 07 00 	mov    %rcx,0x728(%rsp)
  7f2304:	00 
  7f2305:	0f 10 02             	movups (%rdx),%xmm0
  7f2308:	0f 10 4a 10          	movups 0x10(%rdx),%xmm1
  7f230c:	0f 10 52 20          	movups 0x20(%rdx),%xmm2
  7f2310:	0f 10 5a 30          	movups 0x30(%rdx),%xmm3
  7f2314:	0f 11 9c 24 18 07 00 	movups %xmm3,0x718(%rsp)
  7f231b:	00 
  7f231c:	0f 11 94 24 08 07 00 	movups %xmm2,0x708(%rsp)
  7f2323:	00 
  7f2324:	0f 11 8c 24 f8 06 00 	movups %xmm1,0x6f8(%rsp)
  7f232b:	00 
  7f232c:	0f 11 84 24 e8 06 00 	movups %xmm0,0x6e8(%rsp)
  7f2333:	00 
  7f2334:	48 c7 84 24 d0 06 00 	movq   $0x1,0x6d0(%rsp)
  7f233b:	00 01 00 00 00 
  7f2340:	48 c7 84 24 d8 06 00 	movq   $0x1,0x6d8(%rsp)
  7f2347:	00 01 00 00 00 
  7f234c:	48 8d 9c 24 e0 06 00 	lea    0x6e0(%rsp),%rbx
  7f2353:	00 
  7f2354:	48 89 84 24 e0 06 00 	mov    %rax,0x6e0(%rsp)
  7f235b:	00 
  7f235c:	bf 08 00 00 00       	mov    $0x8,%edi
  7f2361:	be 60 00 00 00       	mov    $0x60,%esi
  7f2366:	e8 25 0f 00 00       	call   7f3290 <alloc::boxed::box_new_uninit>
  7f236b:	0f 10 84 24 20 07 00 	movups 0x720(%rsp),%xmm0
  7f2372:	00 
  7f2373:	0f 11 40 50          	movups %xmm0,0x50(%rax)
  7f2377:	0f 10 84 24 10 07 00 	movups 0x710(%rsp),%xmm0
  7f237e:	00 
  7f237f:	0f 11 40 40          	movups %xmm0,0x40(%rax)
  7f2383:	0f 10 84 24 d0 06 00 	movups 0x6d0(%rsp),%xmm0
  7f238a:	00 
  7f238b:	0f 10 8c 24 e0 06 00 	movups 0x6e0(%rsp),%xmm1
  7f2392:	00 
  7f2393:	0f 10 94 24 f0 06 00 	movups 0x6f0(%rsp),%xmm2
  7f239a:	00 
  7f239b:	0f 10 9c 24 00 07 00 	movups 0x700(%rsp),%xmm3
  7f23a2:	00 
  7f23a3:	0f 11 58 30          	movups %xmm3,0x30(%rax)
  7f23a7:	0f 11 50 20          	movups %xmm2,0x20(%rax)
  7f23ab:	0f 11 48 10          	movups %xmm1,0x10(%rax)
  7f23af:	0f 11 00             	movups %xmm0,(%rax)
  7f23b2:	eb 02                	jmp    7f23b6 <<gpui_canvas::text::planner::Planner>::shape+0x3126>
  7f23b4:	31 c0                	xor    %eax,%eax
  7f23b6:	4c 89 bc 24 a0 00 00 	mov    %r15,0xa0(%rsp)
  7f23bd:	00 
  7f23be:	4c 89 a4 24 a8 00 00 	mov    %r12,0xa8(%rsp)
  7f23c5:	00 
  7f23c6:	4c 89 b4 24 b0 00 00 	mov    %r14,0xb0(%rsp)
  7f23cd:	00 
  7f23ce:	4c 89 ac 24 b8 00 00 	mov    %r13,0xb8(%rsp)
  7f23d5:	00 
  7f23d6:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  7f23dd:	00 
  7f23de:	0f 28 84 24 60 02 00 	movaps 0x260(%rsp),%xmm0
  7f23e5:	00 
  7f23e6:	f3 0f 11 84 24 c8 00 	movss  %xmm0,0xc8(%rsp)
  7f23ed:	00 00 
  7f23ef:	f3 0f 10 44 24 58    	movss  0x58(%rsp),%xmm0
  7f23f5:	f3 0f 11 84 24 cc 00 	movss  %xmm0,0xcc(%rsp)
  7f23fc:	00 00 
  7f23fe:	f3 0f 10 44 24 7c    	movss  0x7c(%rsp),%xmm0
  7f2404:	f3 0f 11 84 24 d0 00 	movss  %xmm0,0xd0(%rsp)
  7f240b:	00 00 
  7f240d:	f3 0f 10 84 24 84 00 	movss  0x84(%rsp),%xmm0
  7f2414:	00 00 
  7f2416:	f3 0f 11 84 24 d4 00 	movss  %xmm0,0xd4(%rsp)
  7f241d:	00 00 
  7f241f:	48 8d bc 24 88 02 00 	lea    0x288(%rsp),%rdi
  7f2426:	00 
  7f2427:	e8 34 ab ff ff       	call   7ecf60 <core::ptr::drop_glue::<[parlance::font_family::FontFamilyName; 3]>>
  7f242c:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  7f2430:	0f 85 81 03 00 00    	jne    7f27b7 <<gpui_canvas::text::planner::Planner>::shape+0x3527>
  7f2436:	e9 35 02 00 00       	jmp    7f2670 <<gpui_canvas::text::planner::Planner>::shape+0x33e0>
  7f243b:	48 01 c1             	add    %rax,%rcx
  7f243e:	88 51 ff             	mov    %dl,-0x1(%rcx)
  7f2441:	48 83 bc 24 38 01 00 	cmpq   $0xffffffffffffffff,0x138(%rsp)
  7f2448:	00 ff 
  7f244a:	0f 85 42 fb ff ff    	jne    7f1f92 <<gpui_canvas::text::planner::Planner>::shape+0x2d02>
  7f2450:	e9 55 fe ff ff       	jmp    7f22aa <<gpui_canvas::text::planner::Planner>::shape+0x301a>
  7f2455:	49 89 cd             	mov    %rcx,%r13
  7f2458:	48 8b 84 24 e8 01 00 	mov    0x1e8(%rsp),%rax
  7f245f:	00 
  7f2460:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  7f2467:	00 
  7f2468:	48 8d 0d 69 54 31 00 	lea    0x315469(%rip),%rcx        # b078d8 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x1b0>
  7f246f:	e9 db fc ff ff       	jmp    7f214f <<gpui_canvas::text::planner::Planner>::shape+0x2ebf>
  7f2474:	49 89 d5             	mov    %rdx,%r13
  7f2477:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7f247c:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  7f2483:	00 
  7f2484:	48 8d 0d 15 53 31 00 	lea    0x315315(%rip),%rcx        # b077a0 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x78>
  7f248b:	e9 bf fc ff ff       	jmp    7f214f <<gpui_canvas::text::planner::Planner>::shape+0x2ebf>
  7f2490:	48 8d 0d 89 5d 31 00 	lea    0x315d89(%rip),%rcx        # b08220 <anon.e1aed3256c0f336e2763058c1a348a1e.15.llvm.17407148579165845042>
  7f2497:	48 89 f7             	mov    %rsi,%rdi
  7f249a:	48 89 d6             	mov    %rdx,%rsi
  7f249d:	4c 89 c2             	mov    %r8,%rdx
  7f24a0:	ff 15 ea b2 33 00    	call   *0x33b2ea(%rip)        # b2d790 <_DYNAMIC+0x290>
  7f24a6:	e9 4c 04 00 00       	jmp    7f28f7 <<gpui_canvas::text::planner::Planner>::shape+0x3667>
  7f24ab:	48 8d 0d 86 5a 31 00 	lea    0x315a86(%rip),%rcx        # b07f38 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.37.llvm.14379316919819170204>
  7f24b2:	ff 15 d8 b2 33 00    	call   *0x33b2d8(%rip)        # b2d790 <_DYNAMIC+0x290>
  7f24b8:	e9 3a 04 00 00       	jmp    7f28f7 <<gpui_canvas::text::planner::Planner>::shape+0x3667>
  7f24bd:	48 8d 0d 74 5a 31 00 	lea    0x315a74(%rip),%rcx        # b07f38 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.37.llvm.14379316919819170204>
  7f24c4:	ff 15 c6 b2 33 00    	call   *0x33b2c6(%rip)        # b2d790 <_DYNAMIC+0x290>
  7f24ca:	e9 28 04 00 00       	jmp    7f28f7 <<gpui_canvas::text::planner::Planner>::shape+0x3667>
  7f24cf:	48 8d 3d aa 6d 91 ff 	lea    -0x6e9256(%rip),%rdi        # 109280 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.4.llvm.14379316919819170204>
  7f24d6:	48 8d 15 53 5c 31 00 	lea    0x315c53(%rip),%rdx        # b08130 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.60.llvm.14379316919819170204>
  7f24dd:	be 63 00 00 00       	mov    $0x63,%esi
  7f24e2:	ff 15 98 b3 33 00    	call   *0x33b398(%rip)        # b2d880 <_DYNAMIC+0x380>
  7f24e8:	e9 0a 04 00 00       	jmp    7f28f7 <<gpui_canvas::text::planner::Planner>::shape+0x3667>
  7f24ed:	48 8d 3d 5c 5a 31 00 	lea    0x315a5c(%rip),%rdi        # b07f50 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.38.llvm.14379316919819170204>
  7f24f4:	ff 15 8e b2 33 00    	call   *0x33b28e(%rip)        # b2d788 <_DYNAMIC+0x288>
  7f24fa:	e9 f8 03 00 00       	jmp    7f28f7 <<gpui_canvas::text::planner::Planner>::shape+0x3667>
  7f24ff:	89 c3                	mov    %eax,%ebx
  7f2501:	48 8b b4 24 d0 06 00 	mov    0x6d0(%rsp),%rsi
  7f2508:	00 
  7f2509:	48 85 f6             	test   %rsi,%rsi
  7f250c:	74 17                	je     7f2525 <<gpui_canvas::text::planner::Planner>::shape+0x3295>
  7f250e:	48 8b bc 24 d8 06 00 	mov    0x6d8(%rsp),%rdi
  7f2515:	00 
  7f2516:	48 c1 e6 03          	shl    $0x3,%rsi
  7f251a:	ba 08 00 00 00       	mov    $0x8,%edx
  7f251f:	ff 15 23 b2 33 00    	call   *0x33b223(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f2525:	48 8d bc 24 d0 02 00 	lea    0x2d0(%rsp),%rdi
  7f252c:	00 
  7f252d:	e8 2e b5 ff ff       	call   7eda60 <core::ptr::drop_glue::<parley::editing::geometry::CursorGeometry<()>>>
  7f2532:	e9 2c f9 ff ff       	jmp    7f1e63 <<gpui_canvas::text::planner::Planner>::shape+0x2bd3>
  7f2537:	b8 01 00 00 00       	mov    $0x1,%eax
  7f253c:	eb 05                	jmp    7f2543 <<gpui_canvas::text::planner::Planner>::shape+0x32b3>
  7f253e:	b8 03 00 00 00       	mov    $0x3,%eax
  7f2543:	89 84 24 a8 00 00 00 	mov    %eax,0xa8(%rsp)
  7f254a:	48 c7 84 24 a0 00 00 	movq   $0xffffffffffffffff,0xa0(%rsp)
  7f2551:	00 ff ff ff ff 
  7f2556:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  7f255d:	00 
  7f255e:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f2562:	74 76                	je     7f25da <<gpui_canvas::text::planner::Planner>::shape+0x334a>
  7f2564:	48 85 c0             	test   %rax,%rax
  7f2567:	74 1b                	je     7f2584 <<gpui_canvas::text::planner::Planner>::shape+0x32f4>
  7f2569:	48 8b bc 24 40 01 00 	mov    0x140(%rsp),%rdi
  7f2570:	00 
  7f2571:	48 c1 e0 03          	shl    $0x3,%rax
  7f2575:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  7f2579:	ba 04 00 00 00       	mov    $0x4,%edx
  7f257e:	ff 15 c4 b1 33 00    	call   *0x33b1c4(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f2584:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  7f258b:	00 
  7f258c:	48 85 c0             	test   %rax,%rax
  7f258f:	74 1b                	je     7f25ac <<gpui_canvas::text::planner::Planner>::shape+0x331c>
  7f2591:	48 8b bc 24 58 01 00 	mov    0x158(%rsp),%rdi
  7f2598:	00 
  7f2599:	48 c1 e0 03          	shl    $0x3,%rax
  7f259d:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  7f25a1:	ba 04 00 00 00       	mov    $0x4,%edx
  7f25a6:	ff 15 9c b1 33 00    	call   *0x33b19c(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f25ac:	48 8b 84 24 68 01 00 	mov    0x168(%rsp),%rax
  7f25b3:	00 
  7f25b4:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7f25b8:	74 20                	je     7f25da <<gpui_canvas::text::planner::Planner>::shape+0x334a>
  7f25ba:	48 85 c0             	test   %rax,%rax
  7f25bd:	74 1b                	je     7f25da <<gpui_canvas::text::planner::Planner>::shape+0x334a>
  7f25bf:	48 8b bc 24 70 01 00 	mov    0x170(%rsp),%rdi
  7f25c6:	00 
  7f25c7:	48 c1 e0 02          	shl    $0x2,%rax
  7f25cb:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  7f25cf:	ba 04 00 00 00       	mov    $0x4,%edx
  7f25d4:	ff 15 6e b1 33 00    	call   *0x33b16e(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f25da:	48 8b b4 24 e8 00 00 	mov    0xe8(%rsp),%rsi
  7f25e1:	00 
  7f25e2:	48 85 f6             	test   %rsi,%rsi
  7f25e5:	74 17                	je     7f25fe <<gpui_canvas::text::planner::Planner>::shape+0x336e>
  7f25e7:	48 8b bc 24 f0 00 00 	mov    0xf0(%rsp),%rdi
  7f25ee:	00 
  7f25ef:	48 c1 e6 04          	shl    $0x4,%rsi
  7f25f3:	ba 04 00 00 00       	mov    $0x4,%edx
  7f25f8:	ff 15 4a b1 33 00    	call   *0x33b14a(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f25fe:	48 8b b4 24 88 02 00 	mov    0x288(%rsp),%rsi
  7f2605:	00 
  7f2606:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  7f260a:	77 18                	ja     7f2624 <<gpui_canvas::text::planner::Planner>::shape+0x3394>
  7f260c:	48 85 f6             	test   %rsi,%rsi
  7f260f:	74 13                	je     7f2624 <<gpui_canvas::text::planner::Planner>::shape+0x3394>
  7f2611:	48 8b bc 24 90 02 00 	mov    0x290(%rsp),%rdi
  7f2618:	00 
  7f2619:	ba 01 00 00 00       	mov    $0x1,%edx
  7f261e:	ff 15 24 b1 33 00    	call   *0x33b124(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f2624:	48 8b b4 24 a0 02 00 	mov    0x2a0(%rsp),%rsi
  7f262b:	00 
  7f262c:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  7f2630:	77 18                	ja     7f264a <<gpui_canvas::text::planner::Planner>::shape+0x33ba>
  7f2632:	48 85 f6             	test   %rsi,%rsi
  7f2635:	74 13                	je     7f264a <<gpui_canvas::text::planner::Planner>::shape+0x33ba>
  7f2637:	48 8b bc 24 a8 02 00 	mov    0x2a8(%rsp),%rdi
  7f263e:	00 
  7f263f:	ba 01 00 00 00       	mov    $0x1,%edx
  7f2644:	ff 15 fe b0 33 00    	call   *0x33b0fe(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f264a:	48 8b b4 24 b8 02 00 	mov    0x2b8(%rsp),%rsi
  7f2651:	00 
  7f2652:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  7f2656:	77 18                	ja     7f2670 <<gpui_canvas::text::planner::Planner>::shape+0x33e0>
  7f2658:	48 85 f6             	test   %rsi,%rsi
  7f265b:	74 13                	je     7f2670 <<gpui_canvas::text::planner::Planner>::shape+0x33e0>
  7f265d:	48 8b bc 24 c0 02 00 	mov    0x2c0(%rsp),%rdi
  7f2664:	00 
  7f2665:	ba 01 00 00 00       	mov    $0x1,%edx
  7f266a:	ff 15 d8 b0 33 00    	call   *0x33b0d8(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f2670:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
  7f2675:	48 8d bb c8 08 00 00 	lea    0x8c8(%rbx),%rdi
  7f267c:	e8 cf af ff ff       	call   7ed650 <core::ptr::drop_glue::<parley::layout::layout::Layout<()>>>
  7f2681:	48 c7 83 c8 08 00 00 	movq   $0x0,0x8c8(%rbx)
  7f2688:	00 00 00 00 
  7f268c:	48 c7 83 d0 08 00 00 	movq   $0x4,0x8d0(%rbx)
  7f2693:	04 00 00 00 
  7f2697:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f269a:	0f 11 83 d8 08 00 00 	movups %xmm0,0x8d8(%rbx)
  7f26a1:	48 c7 83 e8 08 00 00 	movq   $0x4,0x8e8(%rbx)
  7f26a8:	04 00 00 00 
  7f26ac:	0f 11 83 f0 08 00 00 	movups %xmm0,0x8f0(%rbx)
  7f26b3:	48 c7 83 00 09 00 00 	movq   $0x8,0x900(%rbx)
  7f26ba:	08 00 00 00 
  7f26be:	0f 11 83 08 09 00 00 	movups %xmm0,0x908(%rbx)
  7f26c5:	48 c7 83 18 09 00 00 	movq   $0x8,0x918(%rbx)
  7f26cc:	08 00 00 00 
  7f26d0:	0f 11 83 20 09 00 00 	movups %xmm0,0x920(%rbx)
  7f26d7:	48 c7 83 30 09 00 00 	movq   $0x4,0x930(%rbx)
  7f26de:	04 00 00 00 
  7f26e2:	0f 11 83 38 09 00 00 	movups %xmm0,0x938(%rbx)
  7f26e9:	48 c7 83 48 09 00 00 	movq   $0x4,0x948(%rbx)
  7f26f0:	04 00 00 00 
  7f26f4:	0f 11 83 50 09 00 00 	movups %xmm0,0x950(%rbx)
  7f26fb:	48 c7 83 60 09 00 00 	movq   $0x4,0x960(%rbx)
  7f2702:	04 00 00 00 
  7f2706:	0f 11 83 68 09 00 00 	movups %xmm0,0x968(%rbx)
  7f270d:	48 c7 83 78 09 00 00 	movq   $0x8,0x978(%rbx)
  7f2714:	08 00 00 00 
  7f2718:	0f 11 83 80 09 00 00 	movups %xmm0,0x980(%rbx)
  7f271f:	48 c7 83 90 09 00 00 	movq   $0x2,0x990(%rbx)
  7f2726:	02 00 00 00 
  7f272a:	0f 11 83 98 09 00 00 	movups %xmm0,0x998(%rbx)
  7f2731:	48 c7 83 a8 09 00 00 	movq   $0x4,0x9a8(%rbx)
  7f2738:	04 00 00 00 
  7f273c:	0f 11 83 b0 09 00 00 	movups %xmm0,0x9b0(%rbx)
  7f2743:	48 c7 83 c0 09 00 00 	movq   $0x8,0x9c0(%rbx)
  7f274a:	08 00 00 00 
  7f274e:	0f 11 83 c8 09 00 00 	movups %xmm0,0x9c8(%rbx)
  7f2755:	48 c7 83 d8 09 00 00 	movq   $0x8,0x9d8(%rbx)
  7f275c:	08 00 00 00 
  7f2760:	0f 11 83 e0 09 00 00 	movups %xmm0,0x9e0(%rbx)
  7f2767:	48 c7 83 f0 09 00 00 	movq   $0x8,0x9f0(%rbx)
  7f276e:	08 00 00 00 
  7f2772:	0f 11 83 f8 09 00 00 	movups %xmm0,0x9f8(%rbx)
  7f2779:	48 c7 83 08 0a 00 00 	movq   $0x4,0xa08(%rbx)
  7f2780:	04 00 00 00 
  7f2784:	0f 11 83 10 0a 00 00 	movups %xmm0,0xa10(%rbx)
  7f278b:	c7 83 20 0a 00 00 00 	movl   $0x3f800000,0xa20(%rbx)
  7f2792:	00 80 3f 
  7f2795:	0f 11 83 24 0a 00 00 	movups %xmm0,0xa24(%rbx)
  7f279c:	48 c7 83 32 0a 00 00 	movq   $0x0,0xa32(%rbx)
  7f27a3:	00 00 00 00 
  7f27a7:	66 c7 83 3a 0a 00 00 	movw   $0xff01,0xa3a(%rbx)
  7f27ae:	01 ff 
  7f27b0:	c6 83 3c 0a 00 00 00 	movb   $0x0,0xa3c(%rbx)
  7f27b7:	48 8b 8c 24 d0 00 00 	mov    0xd0(%rsp),%rcx
  7f27be:	00 
  7f27bf:	48 8b 84 24 68 03 00 	mov    0x368(%rsp),%rax
  7f27c6:	00 
  7f27c7:	48 89 48 30          	mov    %rcx,0x30(%rax)
  7f27cb:	0f 10 84 24 a0 00 00 	movups 0xa0(%rsp),%xmm0
  7f27d2:	00 
  7f27d3:	0f 10 8c 24 b0 00 00 	movups 0xb0(%rsp),%xmm1
  7f27da:	00 
  7f27db:	0f 10 94 24 c0 00 00 	movups 0xc0(%rsp),%xmm2
  7f27e2:	00 
  7f27e3:	0f 11 50 20          	movups %xmm2,0x20(%rax)
  7f27e7:	0f 11 48 10          	movups %xmm1,0x10(%rax)
  7f27eb:	0f 11 00             	movups %xmm0,(%rax)
  7f27ee:	48 81 c4 a8 11 00 00 	add    $0x11a8,%rsp
  7f27f5:	5b                   	pop    %rbx
  7f27f6:	41 5c                	pop    %r12
  7f27f8:	41 5d                	pop    %r13
  7f27fa:	41 5e                	pop    %r14
  7f27fc:	41 5f                	pop    %r15
  7f27fe:	5d                   	pop    %rbp
  7f27ff:	c3                   	ret
  7f2800:	4c 8d 05 11 50 31 00 	lea    0x315011(%rip),%r8        # b07818 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0xf0>
  7f2807:	48 8b bc 24 28 01 00 	mov    0x128(%rsp),%rdi
  7f280e:	00 
  7f280f:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  7f2814:	48 8b 14 24          	mov    (%rsp),%rdx
  7f2818:	ff 15 9a b6 33 00    	call   *0x33b69a(%rip)        # b2deb8 <_DYNAMIC+0x9b8>
  7f281e:	e9 d4 00 00 00       	jmp    7f28f7 <<gpui_canvas::text::planner::Planner>::shape+0x3667>
  7f2823:	48 8d 05 8e 4f 31 00 	lea    0x314f8e(%rip),%rax        # b077b8 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x90>
  7f282a:	eb 24                	jmp    7f2850 <<gpui_canvas::text::planner::Planner>::shape+0x35c0>
  7f282c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7f2831:	48 39 d0             	cmp    %rdx,%rax
  7f2834:	48 0f 47 d0          	cmova  %rax,%rdx
  7f2838:	48 8d 05 69 51 31 00 	lea    0x315169(%rip),%rax        # b079a8 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x280>
  7f283f:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  7f2844:	48 89 d7             	mov    %rdx,%rdi
  7f2847:	eb 0c                	jmp    7f2855 <<gpui_canvas::text::planner::Planner>::shape+0x35c5>
  7f2849:	48 8d 05 28 50 31 00 	lea    0x315028(%rip),%rax        # b07878 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x150>
  7f2850:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  7f2855:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  7f285a:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  7f285f:	ff 15 6b af 33 00    	call   *0x33af6b(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7f2865:	e9 8d 00 00 00       	jmp    7f28f7 <<gpui_canvas::text::planner::Planner>::shape+0x3667>
  7f286a:	31 ff                	xor    %edi,%edi
  7f286c:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
  7f2873:	00 00 
  7f2875:	eb de                	jmp    7f2855 <<gpui_canvas::text::planner::Planner>::shape+0x35c5>
  7f2877:	48 8d 0d 62 5a 31 00 	lea    0x315a62(%rip),%rcx        # b082e0 <anon.e1aed3256c0f336e2763058c1a348a1e.26.llvm.17407148579165845042>
  7f287e:	48 89 8c 24 50 02 00 	mov    %rcx,0x250(%rsp)
  7f2885:	00 
  7f2886:	eb 04                	jmp    7f288c <<gpui_canvas::text::planner::Planner>::shape+0x35fc>
  7f2888:	31 ff                	xor    %edi,%edi
  7f288a:	31 c0                	xor    %eax,%eax
  7f288c:	48 89 c6             	mov    %rax,%rsi
  7f288f:	48 8b 94 24 50 02 00 	mov    0x250(%rsp),%rdx
  7f2896:	00 
  7f2897:	ff 15 33 af 33 00    	call   *0x33af33(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7f289d:	eb 58                	jmp    7f28f7 <<gpui_canvas::text::planner::Planner>::shape+0x3667>
  7f289f:	48 8d 15 fa 57 31 00 	lea    0x3157fa(%rip),%rdx        # b080a0 <anon.4ac0b2593bbfdddf27a4667e916b2ff1.54.llvm.14379316919819170204>
  7f28a6:	ff 15 24 af 33 00    	call   *0x33af24(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7f28ac:	eb 49                	jmp    7f28f7 <<gpui_canvas::text::planner::Planner>::shape+0x3667>
  7f28ae:	48 8d 05 db 50 31 00 	lea    0x3150db(%rip),%rax        # b07990 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x268>
  7f28b5:	eb 99                	jmp    7f2850 <<gpui_canvas::text::planner::Planner>::shape+0x35c0>
  7f28b7:	48 89 d7             	mov    %rdx,%rdi
  7f28ba:	48 8d 05 ff 50 31 00 	lea    0x3150ff(%rip),%rax        # b079c0 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x298>
  7f28c1:	eb 8d                	jmp    7f2850 <<gpui_canvas::text::planner::Planner>::shape+0x35c0>
  7f28c3:	48 8d 05 96 4f 31 00 	lea    0x314f96(%rip),%rax        # b07860 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x138>
  7f28ca:	eb 84                	jmp    7f2850 <<gpui_canvas::text::planner::Planner>::shape+0x35c0>
  7f28cc:	48 8d 05 bd 4f 31 00 	lea    0x314fbd(%rip),%rax        # b07890 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x168>
  7f28d3:	e9 78 ff ff ff       	jmp    7f2850 <<gpui_canvas::text::planner::Planner>::shape+0x35c0>
  7f28d8:	48 89 d7             	mov    %rdx,%rdi
  7f28db:	48 8d 05 c6 4f 31 00 	lea    0x314fc6(%rip),%rax        # b078a8 <anon.8b5fc042aaf44ecdb8851cb64b83294a.14.llvm.11756661080873179907+0x180>
  7f28e2:	e9 69 ff ff ff       	jmp    7f2850 <<gpui_canvas::text::planner::Planner>::shape+0x35c0>
  7f28e7:	48 8d 15 f2 59 31 00 	lea    0x3159f2(%rip),%rdx        # b082e0 <anon.e1aed3256c0f336e2763058c1a348a1e.26.llvm.17407148579165845042>
  7f28ee:	48 89 c6             	mov    %rax,%rsi
  7f28f1:	ff 15 d9 ae 33 00    	call   *0x33aed9(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  7f28f7:	0f 0b                	ud2
  7f28f9:	49 89 c6             	mov    %rax,%r14
  7f28fc:	be 18 00 00 00       	mov    $0x18,%esi
  7f2901:	ba 04 00 00 00       	mov    $0x4,%edx
  7f2906:	4c 89 ff             	mov    %r15,%rdi
  7f2909:	ff 15 39 ae 33 00    	call   *0x33ae39(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f290f:	e9 ba 02 00 00       	jmp    7f2bce <<gpui_canvas::text::planner::Planner>::shape+0x393e>
  7f2914:	49 89 c6             	mov    %rax,%r14
  7f2917:	48 89 df             	mov    %rbx,%rdi
  7f291a:	e8 71 c1 ff ff       	call   7eea90 <core::ptr::drop_glue::<gpui_canvas::text::layout::TextGeometry>>
  7f291f:	f0 49 ff 4d 00       	lock decq 0x0(%r13)
  7f2924:	75 0e                	jne    7f2934 <<gpui_canvas::text::planner::Planner>::shape+0x36a4>
  7f2926:	48 8d bc 24 80 04 00 	lea    0x480(%rsp),%rdi
  7f292d:	00 
  7f292e:	ff 15 bc ae 33 00    	call   *0x33aebc(%rip)        # b2d7f0 <_DYNAMIC+0x2f0>
  7f2934:	31 db                	xor    %ebx,%ebx
  7f2936:	eb 0b                	jmp    7f2943 <<gpui_canvas::text::planner::Planner>::shape+0x36b3>
  7f2938:	ff 15 5a ae 33 00    	call   *0x33ae5a(%rip)        # b2d798 <_DYNAMIC+0x298>
  7f293e:	49 89 c6             	mov    %rax,%r14
  7f2941:	b3 01                	mov    $0x1,%bl
  7f2943:	4d 85 ff             	test   %r15,%r15
  7f2946:	74 15                	je     7f295d <<gpui_canvas::text::planner::Planner>::shape+0x36cd>
  7f2948:	49 c1 e7 04          	shl    $0x4,%r15
  7f294c:	ba 04 00 00 00       	mov    $0x4,%edx
  7f2951:	4c 89 e7             	mov    %r12,%rdi
  7f2954:	4c 89 fe             	mov    %r15,%rsi
  7f2957:	ff 15 eb ad 33 00    	call   *0x33adeb(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f295d:	84 db                	test   %bl,%bl
  7f295f:	0f 84 ab 02 00 00    	je     7f2c10 <<gpui_canvas::text::planner::Planner>::shape+0x3980>
  7f2965:	31 db                	xor    %ebx,%ebx
  7f2967:	48 83 bc 24 38 01 00 	cmpq   $0xffffffffffffffff,0x138(%rsp)
  7f296e:	00 ff 
  7f2970:	0f 84 1d 02 00 00    	je     7f2b93 <<gpui_canvas::text::planner::Planner>::shape+0x3903>
  7f2976:	e9 60 02 00 00       	jmp    7f2bdb <<gpui_canvas::text::planner::Planner>::shape+0x394b>
  7f297b:	49 89 c6             	mov    %rax,%r14
  7f297e:	48 8b b4 24 d0 06 00 	mov    0x6d0(%rsp),%rsi
  7f2985:	00 
  7f2986:	48 85 f6             	test   %rsi,%rsi
  7f2989:	74 17                	je     7f29a2 <<gpui_canvas::text::planner::Planner>::shape+0x3712>
  7f298b:	48 8b bc 24 d8 06 00 	mov    0x6d8(%rsp),%rdi
  7f2992:	00 
  7f2993:	48 c1 e6 03          	shl    $0x3,%rsi
  7f2997:	ba 08 00 00 00       	mov    $0x8,%edx
  7f299c:	ff 15 a6 ad 33 00    	call   *0x33ada6(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f29a2:	48 8d bc 24 d0 02 00 	lea    0x2d0(%rsp),%rdi
  7f29a9:	00 
  7f29aa:	e8 b1 b0 ff ff       	call   7eda60 <core::ptr::drop_glue::<parley::editing::geometry::CursorGeometry<()>>>
  7f29af:	e9 1a 02 00 00       	jmp    7f2bce <<gpui_canvas::text::planner::Planner>::shape+0x393e>
  7f29b4:	49 89 c6             	mov    %rax,%r14
  7f29b7:	4d 89 27             	mov    %r12,(%r15)
  7f29ba:	4c 89 f7             	mov    %r14,%rdi
  7f29bd:	e8 6e 0b 31 00       	call   b03530 <_Unwind_Resume@plt>
  7f29c2:	e9 04 02 00 00       	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f29c7:	e9 ff 01 00 00       	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f29cc:	e9 fa 01 00 00       	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f29d1:	e9 a0 01 00 00       	jmp    7f2b76 <<gpui_canvas::text::planner::Planner>::shape+0x38e6>
  7f29d6:	e9 f0 01 00 00       	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f29db:	e9 eb 01 00 00       	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f29e0:	e9 e6 01 00 00       	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f29e5:	e9 e1 01 00 00       	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f29ea:	49 89 c6             	mov    %rax,%r14
  7f29ed:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f29f4:	00 
  7f29f5:	e8 16 a7 01 00       	call   80d110 <core::ptr::drop_glue::<parley::style::StyleProperty<()>>>
  7f29fa:	e9 cf 01 00 00       	jmp    7f2bce <<gpui_canvas::text::planner::Planner>::shape+0x393e>
  7f29ff:	ff 15 93 ad 33 00    	call   *0x33ad93(%rip)        # b2d798 <_DYNAMIC+0x298>
  7f2a05:	49 89 c6             	mov    %rax,%r14
  7f2a08:	48 8d bc 24 d0 06 00 	lea    0x6d0(%rsp),%rdi
  7f2a0f:	00 
  7f2a10:	e8 fb a6 01 00       	call   80d110 <core::ptr::drop_glue::<parley::style::StyleProperty<()>>>
  7f2a15:	e9 b4 01 00 00       	jmp    7f2bce <<gpui_canvas::text::planner::Planner>::shape+0x393e>
  7f2a1a:	ff 15 78 ad 33 00    	call   *0x33ad78(%rip)        # b2d798 <_DYNAMIC+0x298>
  7f2a20:	49 89 c6             	mov    %rax,%r14
  7f2a23:	48 c7 83 c8 08 00 00 	movq   $0x0,0x8c8(%rbx)
  7f2a2a:	00 00 00 00 
  7f2a2e:	48 c7 83 d0 08 00 00 	movq   $0x4,0x8d0(%rbx)
  7f2a35:	04 00 00 00 
  7f2a39:	0f 57 c0             	xorps  %xmm0,%xmm0
  7f2a3c:	0f 11 83 d8 08 00 00 	movups %xmm0,0x8d8(%rbx)
  7f2a43:	48 c7 83 e8 08 00 00 	movq   $0x4,0x8e8(%rbx)
  7f2a4a:	04 00 00 00 
  7f2a4e:	0f 11 83 f0 08 00 00 	movups %xmm0,0x8f0(%rbx)
  7f2a55:	48 c7 83 00 09 00 00 	movq   $0x8,0x900(%rbx)
  7f2a5c:	08 00 00 00 
  7f2a60:	0f 11 83 08 09 00 00 	movups %xmm0,0x908(%rbx)
  7f2a67:	48 c7 83 18 09 00 00 	movq   $0x8,0x918(%rbx)
  7f2a6e:	08 00 00 00 
  7f2a72:	0f 11 83 20 09 00 00 	movups %xmm0,0x920(%rbx)
  7f2a79:	48 c7 83 30 09 00 00 	movq   $0x4,0x930(%rbx)
  7f2a80:	04 00 00 00 
  7f2a84:	0f 11 83 38 09 00 00 	movups %xmm0,0x938(%rbx)
  7f2a8b:	48 c7 83 48 09 00 00 	movq   $0x4,0x948(%rbx)
  7f2a92:	04 00 00 00 
  7f2a96:	0f 11 83 50 09 00 00 	movups %xmm0,0x950(%rbx)
  7f2a9d:	48 c7 83 60 09 00 00 	movq   $0x4,0x960(%rbx)
  7f2aa4:	04 00 00 00 
  7f2aa8:	0f 11 83 68 09 00 00 	movups %xmm0,0x968(%rbx)
  7f2aaf:	48 c7 83 78 09 00 00 	movq   $0x8,0x978(%rbx)
  7f2ab6:	08 00 00 00 
  7f2aba:	0f 11 83 80 09 00 00 	movups %xmm0,0x980(%rbx)
  7f2ac1:	48 c7 83 90 09 00 00 	movq   $0x2,0x990(%rbx)
  7f2ac8:	02 00 00 00 
  7f2acc:	0f 11 83 98 09 00 00 	movups %xmm0,0x998(%rbx)
  7f2ad3:	48 c7 83 a8 09 00 00 	movq   $0x4,0x9a8(%rbx)
  7f2ada:	04 00 00 00 
  7f2ade:	0f 11 83 b0 09 00 00 	movups %xmm0,0x9b0(%rbx)
  7f2ae5:	48 c7 83 c0 09 00 00 	movq   $0x8,0x9c0(%rbx)
  7f2aec:	08 00 00 00 
  7f2af0:	0f 11 83 c8 09 00 00 	movups %xmm0,0x9c8(%rbx)
  7f2af7:	48 c7 83 d8 09 00 00 	movq   $0x8,0x9d8(%rbx)
  7f2afe:	08 00 00 00 
  7f2b02:	0f 11 83 e0 09 00 00 	movups %xmm0,0x9e0(%rbx)
  7f2b09:	48 c7 83 f0 09 00 00 	movq   $0x8,0x9f0(%rbx)
  7f2b10:	08 00 00 00 
  7f2b14:	0f 11 83 f8 09 00 00 	movups %xmm0,0x9f8(%rbx)
  7f2b1b:	48 c7 83 08 0a 00 00 	movq   $0x4,0xa08(%rbx)
  7f2b22:	04 00 00 00 
  7f2b26:	0f 11 83 10 0a 00 00 	movups %xmm0,0xa10(%rbx)
  7f2b2d:	c7 83 20 0a 00 00 00 	movl   $0x3f800000,0xa20(%rbx)
  7f2b34:	00 80 3f 
  7f2b37:	0f 11 83 24 0a 00 00 	movups %xmm0,0xa24(%rbx)
  7f2b3e:	48 c7 83 32 0a 00 00 	movq   $0x0,0xa32(%rbx)
  7f2b45:	00 00 00 00 
  7f2b49:	66 c7 83 3a 0a 00 00 	movw   $0xff01,0xa3a(%rbx)
  7f2b50:	01 ff 
  7f2b52:	c6 83 3c 0a 00 00 00 	movb   $0x0,0xa3c(%rbx)
  7f2b59:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  7f2b60:	00 
  7f2b61:	e8 0a a5 ff ff       	call   7ed070 <core::ptr::drop_glue::<core::result::Result<gpui_canvas::text::TextLayout, gpui_canvas::Error>>>
  7f2b66:	4c 89 f7             	mov    %r14,%rdi
  7f2b69:	e8 c2 09 31 00       	call   b03530 <_Unwind_Resume@plt>
  7f2b6e:	ff 15 24 ac 33 00    	call   *0x33ac24(%rip)        # b2d798 <_DYNAMIC+0x298>
  7f2b74:	eb 55                	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f2b76:	49 89 c6             	mov    %rax,%r14
  7f2b79:	48 8b b4 24 d0 06 00 	mov    0x6d0(%rsp),%rsi
  7f2b80:	00 
  7f2b81:	b3 01                	mov    $0x1,%bl
  7f2b83:	48 85 f6             	test   %rsi,%rsi
  7f2b86:	75 11                	jne    7f2b99 <<gpui_canvas::text::planner::Planner>::shape+0x3909>
  7f2b88:	48 83 bc 24 38 01 00 	cmpq   $0xffffffffffffffff,0x138(%rsp)
  7f2b8f:	00 ff 
  7f2b91:	75 48                	jne    7f2bdb <<gpui_canvas::text::planner::Planner>::shape+0x394b>
  7f2b93:	84 db                	test   %bl,%bl
  7f2b95:	75 55                	jne    7f2bec <<gpui_canvas::text::planner::Planner>::shape+0x395c>
  7f2b97:	eb 77                	jmp    7f2c10 <<gpui_canvas::text::planner::Planner>::shape+0x3980>
  7f2b99:	48 8b bc 24 d8 06 00 	mov    0x6d8(%rsp),%rdi
  7f2ba0:	00 
  7f2ba1:	48 c1 e6 03          	shl    $0x3,%rsi
  7f2ba5:	ba 08 00 00 00       	mov    $0x8,%edx
  7f2baa:	ff 15 98 ab 33 00    	call   *0x33ab98(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f2bb0:	48 83 bc 24 38 01 00 	cmpq   $0xffffffffffffffff,0x138(%rsp)
  7f2bb7:	00 ff 
  7f2bb9:	74 d8                	je     7f2b93 <<gpui_canvas::text::planner::Planner>::shape+0x3903>
  7f2bbb:	eb 1e                	jmp    7f2bdb <<gpui_canvas::text::planner::Planner>::shape+0x394b>
  7f2bbd:	eb 0c                	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f2bbf:	eb 0a                	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f2bc1:	eb 08                	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f2bc3:	eb 06                	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f2bc5:	eb 04                	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f2bc7:	eb 02                	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f2bc9:	eb 00                	jmp    7f2bcb <<gpui_canvas::text::planner::Planner>::shape+0x393b>
  7f2bcb:	49 89 c6             	mov    %rax,%r14
  7f2bce:	b3 01                	mov    $0x1,%bl
  7f2bd0:	48 83 bc 24 38 01 00 	cmpq   $0xffffffffffffffff,0x138(%rsp)
  7f2bd7:	00 ff 
  7f2bd9:	74 b8                	je     7f2b93 <<gpui_canvas::text::planner::Planner>::shape+0x3903>
  7f2bdb:	48 8d bc 24 38 01 00 	lea    0x138(%rsp),%rdi
  7f2be2:	00 
  7f2be3:	e8 a8 be ff ff       	call   7eea90 <core::ptr::drop_glue::<gpui_canvas::text::layout::TextGeometry>>
  7f2be8:	84 db                	test   %bl,%bl
  7f2bea:	74 24                	je     7f2c10 <<gpui_canvas::text::planner::Planner>::shape+0x3980>
  7f2bec:	48 8b b4 24 e8 00 00 	mov    0xe8(%rsp),%rsi
  7f2bf3:	00 
  7f2bf4:	48 85 f6             	test   %rsi,%rsi
  7f2bf7:	74 17                	je     7f2c10 <<gpui_canvas::text::planner::Planner>::shape+0x3980>
  7f2bf9:	48 8b bc 24 f0 00 00 	mov    0xf0(%rsp),%rdi
  7f2c00:	00 
  7f2c01:	48 c1 e6 04          	shl    $0x4,%rsi
  7f2c05:	ba 04 00 00 00       	mov    $0x4,%edx
  7f2c0a:	ff 15 38 ab 33 00    	call   *0x33ab38(%rip)        # b2d748 <_DYNAMIC+0x248>
  7f2c10:	48 8d bc 24 88 02 00 	lea    0x288(%rsp),%rdi
  7f2c17:	00 
  7f2c18:	e8 43 a3 ff ff       	call   7ecf60 <core::ptr::drop_glue::<[parlance::font_family::FontFamilyName; 3]>>
  7f2c1d:	4c 89 f7             	mov    %r14,%rdi
  7f2c20:	e8 0b 09 31 00       	call   b03530 <_Unwind_Resume@plt>
