
/tmp/gpui-caret-transaction-bin/matched-indexed-caret_pair_measure:     file format elf64-x86-64


Disassembly of section .text:

000000000067e0f0 <<gpui_canvas::text::planner::Planner>::shape>:
  67e0f0:	55                   	push   %rbp
  67e0f1:	41 57                	push   %r15
  67e0f3:	41 56                	push   %r14
  67e0f5:	41 55                	push   %r13
  67e0f7:	41 54                	push   %r12
  67e0f9:	53                   	push   %rbx
  67e0fa:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  67e101:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  67e108:	00 
  67e109:	48 81 ec d8 01 00 00 	sub    $0x1d8,%rsp
  67e110:	44 89 8c 24 2c 02 00 	mov    %r9d,0x22c(%rsp)
  67e117:	00 
  67e118:	f3 0f 11 8c 24 bc 01 	movss  %xmm1,0x1bc(%rsp)
  67e11f:	00 00 
  67e121:	44 89 84 24 b8 01 00 	mov    %r8d,0x1b8(%rsp)
  67e128:	00 
  67e129:	f3 0f 11 44 24 7c    	movss  %xmm0,0x7c(%rsp)
  67e12f:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  67e134:	49 89 f5             	mov    %rsi,%r13
  67e137:	48 89 bc 24 c8 03 00 	mov    %rdi,0x3c8(%rsp)
  67e13e:	00 
  67e13f:	48 8d 04 0a          	lea    (%rdx,%rcx,1),%rax
  67e143:	48 89 84 24 a0 01 00 	mov    %rax,0x1a0(%rsp)
  67e14a:	00 
  67e14b:	48 85 c9             	test   %rcx,%rcx
  67e14e:	48 89 34 24          	mov    %rsi,(%rsp)
  67e152:	48 89 94 24 38 01 00 	mov    %rdx,0x138(%rsp)
  67e159:	00 
  67e15a:	0f 84 8a 03 00 00    	je     67e4ea <<gpui_canvas::text::planner::Planner>::shape+0x3fa>
  67e160:	49 8d 85 78 0a 00 00 	lea    0xa78(%r13),%rax
  67e167:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  67e16c:	4c 8d a4 24 dc 0c 00 	lea    0xcdc(%rsp),%r12
  67e173:	00 
  67e174:	49 8d 45 38          	lea    0x38(%r13),%rax
  67e178:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  67e17d:	49 8d 45 3c          	lea    0x3c(%r13),%rax
  67e181:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  67e186:	49 8d 45 58          	lea    0x58(%r13),%rax
  67e18a:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  67e18f:	49 8d 45 5c          	lea    0x5c(%r13),%rax
  67e193:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  67e19a:	00 
  67e19b:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%rsp)
  67e1a2:	00 
  67e1a3:	48 8d b4 24 00 07 00 	lea    0x700(%rsp),%rsi
  67e1aa:	00 
  67e1ab:	4c 8b 05 76 93 10 00 	mov    0x109376(%rip),%r8        # 787528 <_DYNAMIC+0x8a0>
  67e1b2:	49 89 d6             	mov    %rdx,%r14
  67e1b5:	eb 27                	jmp    67e1de <<gpui_canvas::text::planner::Planner>::shape+0xee>
  67e1b7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  67e1be:	00 00 
  67e1c0:	41 8d 87 d8 df ff ff 	lea    -0x2028(%r15),%eax
  67e1c7:	83 f8 02             	cmp    $0x2,%eax
  67e1ca:	0f 83 e1 00 00 00    	jae    67e2b1 <<gpui_canvas::text::planner::Planner>::shape+0x1c1>
  67e1d0:	4c 3b b4 24 a0 01 00 	cmp    0x1a0(%rsp),%r14
  67e1d7:	00 
  67e1d8:	0f 84 ae 02 00 00    	je     67e48c <<gpui_canvas::text::planner::Planner>::shape+0x39c>
  67e1de:	45 0f b6 3e          	movzbl (%r14),%r15d
  67e1e2:	45 84 ff             	test   %r15b,%r15b
  67e1e5:	78 19                	js     67e200 <<gpui_canvas::text::planner::Planner>::shape+0x110>
  67e1e7:	49 ff c6             	inc    %r14
  67e1ea:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  67e1f1:	0f 8e 99 00 00 00    	jle    67e290 <<gpui_canvas::text::planner::Planner>::shape+0x1a0>
  67e1f7:	eb c7                	jmp    67e1c0 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  67e1f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  67e200:	44 89 f8             	mov    %r15d,%eax
  67e203:	83 e0 1f             	and    $0x1f,%eax
  67e206:	41 0f b6 56 01       	movzbl 0x1(%r14),%edx
  67e20b:	83 e2 3f             	and    $0x3f,%edx
  67e20e:	41 80 ff df          	cmp    $0xdf,%r15b
  67e212:	76 3d                	jbe    67e251 <<gpui_canvas::text::planner::Planner>::shape+0x161>
  67e214:	41 0f b6 4e 02       	movzbl 0x2(%r14),%ecx
  67e219:	c1 e2 06             	shl    $0x6,%edx
  67e21c:	83 e1 3f             	and    $0x3f,%ecx
  67e21f:	09 d1                	or     %edx,%ecx
  67e221:	41 80 ff f0          	cmp    $0xf0,%r15b
  67e225:	72 44                	jb     67e26b <<gpui_canvas::text::planner::Planner>::shape+0x17b>
  67e227:	45 0f b6 7e 03       	movzbl 0x3(%r14),%r15d
  67e22c:	49 83 c6 04          	add    $0x4,%r14
  67e230:	83 e0 07             	and    $0x7,%eax
  67e233:	c1 e0 12             	shl    $0x12,%eax
  67e236:	c1 e1 06             	shl    $0x6,%ecx
  67e239:	41 83 e7 3f          	and    $0x3f,%r15d
  67e23d:	41 09 cf             	or     %ecx,%r15d
  67e240:	41 09 c7             	or     %eax,%r15d
  67e243:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  67e24a:	7e 44                	jle    67e290 <<gpui_canvas::text::planner::Planner>::shape+0x1a0>
  67e24c:	e9 6f ff ff ff       	jmp    67e1c0 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  67e251:	49 83 c6 02          	add    $0x2,%r14
  67e255:	c1 e0 06             	shl    $0x6,%eax
  67e258:	09 d0                	or     %edx,%eax
  67e25a:	41 89 c7             	mov    %eax,%r15d
  67e25d:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  67e264:	7e 2a                	jle    67e290 <<gpui_canvas::text::planner::Planner>::shape+0x1a0>
  67e266:	e9 55 ff ff ff       	jmp    67e1c0 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  67e26b:	49 83 c6 03          	add    $0x3,%r14
  67e26f:	c1 e0 0c             	shl    $0xc,%eax
  67e272:	09 c1                	or     %eax,%ecx
  67e274:	41 89 cf             	mov    %ecx,%r15d
  67e277:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  67e27e:	0f 8f 3c ff ff ff    	jg     67e1c0 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  67e284:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  67e28b:	00 00 00 00 00 
  67e290:	41 83 ff 0a          	cmp    $0xa,%r15d
  67e294:	0f 84 36 ff ff ff    	je     67e1d0 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  67e29a:	41 83 ff 0d          	cmp    $0xd,%r15d
  67e29e:	0f 84 2c ff ff ff    	je     67e1d0 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  67e2a4:	41 81 ff 85 00 00 00 	cmp    $0x85,%r15d
  67e2ab:	0f 84 1f ff ff ff    	je     67e1d0 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  67e2b1:	49 89 f5             	mov    %rsi,%r13
  67e2b4:	48 8d 3d bd ee 0f 00 	lea    0xfeebd(%rip),%rdi        # 77d178 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x38>
  67e2bb:	44 89 fe             	mov    %r15d,%esi
  67e2be:	4c 89 c3             	mov    %r8,%rbx
  67e2c1:	ff 15 f1 92 10 00    	call   *0x1092f1(%rip)        # 7875b8 <_DYNAMIC+0x930>
  67e2c7:	49 89 d8             	mov    %rbx,%r8
  67e2ca:	4c 89 ee             	mov    %r13,%rsi
  67e2cd:	84 c0                	test   %al,%al
  67e2cf:	0f 85 fb fe ff ff    	jne    67e1d0 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  67e2d5:	4c 89 e5             	mov    %r12,%rbp
  67e2d8:	41 bc 0a 00 00 00    	mov    $0xa,%r12d
  67e2de:	41 83 ff 20          	cmp    $0x20,%r15d
  67e2e2:	0f 82 52 02 00 00    	jb     67e53a <<gpui_canvas::text::planner::Planner>::shape+0x44a>
  67e2e8:	41 8d 47 81          	lea    -0x7f(%r15),%eax
  67e2ec:	83 f8 21             	cmp    $0x21,%eax
  67e2ef:	0f 82 45 02 00 00    	jb     67e53a <<gpui_canvas::text::planner::Planner>::shape+0x44a>
  67e2f5:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  67e2fa:	44 89 fe             	mov    %r15d,%esi
  67e2fd:	e8 5e 3c 00 00       	call   681f60 <<gpui_canvas::text::planner::Cmap>::glyph_index>
  67e302:	49 89 d8             	mov    %rbx,%r8
  67e305:	4c 89 ee             	mov    %r13,%rsi
  67e308:	a8 01                	test   $0x1,%al
  67e30a:	74 0c                	je     67e318 <<gpui_canvas::text::planner::Planner>::shape+0x228>
  67e30c:	49 89 ec             	mov    %rbp,%r12
  67e30f:	66 85 d2             	test   %dx,%dx
  67e312:	0f 85 b8 fe ff ff    	jne    67e1d0 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  67e318:	48 8b 0c 24          	mov    (%rsp),%rcx
  67e31c:	48 8b 81 40 0a 00 00 	mov    0xa40(%rcx),%rax
  67e323:	41 bc 0b 00 00 00    	mov    $0xb,%r12d
  67e329:	80 78 38 01          	cmpb   $0x1,0x38(%rax)
  67e32d:	0f 85 07 02 00 00    	jne    67e53a <<gpui_canvas::text::planner::Planner>::shape+0x44a>
  67e333:	48 83 79 30 00       	cmpq   $0x0,0x30(%rcx)
  67e338:	0f 85 f3 00 00 00    	jne    67e431 <<gpui_canvas::text::planner::Planner>::shape+0x341>
  67e33e:	ba 48 ab 03 00       	mov    $0x3ab48,%edx
  67e343:	48 89 f7             	mov    %rsi,%rdi
  67e346:	48 8d 35 79 7d 9a ff 	lea    -0x658287(%rip),%rsi        # 260c6 <gpui_canvas::text::ARABIC_BYTES>
  67e34d:	31 c9                	xor    %ecx,%ecx
  67e34f:	41 ff d0             	call   *%r8
  67e352:	83 bc 24 00 07 00 00 	cmpl   $0xffffffff,0x700(%rsp)
  67e359:	ff 
  67e35a:	0f 84 a7 32 00 00    	je     681607 <<gpui_canvas::text::planner::Planner>::shape+0x3517>
  67e360:	8b 84 24 d8 0c 00 00 	mov    0xcd8(%rsp),%eax
  67e367:	89 84 24 80 00 00 00 	mov    %eax,0x80(%rsp)
  67e36e:	0f 10 45 00          	movups 0x0(%rbp),%xmm0
  67e372:	0f 10 4d 0c          	movups 0xc(%rbp),%xmm1
  67e376:	0f 29 84 24 b0 04 00 	movaps %xmm0,0x4b0(%rsp)
  67e37d:	00 
  67e37e:	0f 11 8c 24 bc 04 00 	movups %xmm1,0x4bc(%rsp)
  67e385:	00 
  67e386:	ba 14 69 00 00       	mov    $0x6914,%edx
  67e38b:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  67e392:	00 
  67e393:	48 8d 35 74 28 9e ff 	lea    -0x61d78c(%rip),%rsi        # 60c0e <gpui_canvas::text::HEBREW_BYTES>
  67e39a:	31 c9                	xor    %ecx,%ecx
  67e39c:	ff 15 86 91 10 00    	call   *0x109186(%rip)        # 787528 <_DYNAMIC+0x8a0>
  67e3a2:	83 bc 24 00 07 00 00 	cmpl   $0xffffffff,0x700(%rsp)
  67e3a9:	ff 
  67e3aa:	0f 84 6c 32 00 00    	je     68161c <<gpui_canvas::text::planner::Planner>::shape+0x352c>
  67e3b0:	8b 94 24 d8 0c 00 00 	mov    0xcd8(%rsp),%edx
  67e3b7:	48 8d 84 24 dc 0c 00 	lea    0xcdc(%rsp),%rax
  67e3be:	00 
  67e3bf:	0f 10 00             	movups (%rax),%xmm0
  67e3c2:	0f 10 48 0c          	movups 0xc(%rax),%xmm1
  67e3c6:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
  67e3cd:	00 
  67e3ce:	0f 11 8c 24 ac 02 00 	movups %xmm1,0x2ac(%rsp)
  67e3d5:	00 
  67e3d6:	48 8b 04 24          	mov    (%rsp),%rax
  67e3da:	48 c7 40 30 01 00 00 	movq   $0x1,0x30(%rax)
  67e3e1:	00 
  67e3e2:	8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%ecx
  67e3e9:	89 48 38             	mov    %ecx,0x38(%rax)
  67e3ec:	0f 10 84 24 bc 04 00 	movups 0x4bc(%rsp),%xmm0
  67e3f3:	00 
  67e3f4:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  67e3f9:	0f 11 41 0c          	movups %xmm0,0xc(%rcx)
  67e3fd:	0f 28 84 24 b0 04 00 	movaps 0x4b0(%rsp),%xmm0
  67e404:	00 
  67e405:	0f 11 01             	movups %xmm0,(%rcx)
  67e408:	89 94 24 00 01 00 00 	mov    %edx,0x100(%rsp)
  67e40f:	89 50 58             	mov    %edx,0x58(%rax)
  67e412:	0f 10 84 24 ac 02 00 	movups 0x2ac(%rsp),%xmm0
  67e419:	00 
  67e41a:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  67e421:	00 
  67e422:	0f 11 40 0c          	movups %xmm0,0xc(%rax)
  67e426:	0f 28 84 24 a0 02 00 	movaps 0x2a0(%rsp),%xmm0
  67e42d:	00 
  67e42e:	0f 11 00             	movups %xmm0,(%rax)
  67e431:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  67e436:	44 89 fe             	mov    %r15d,%esi
  67e439:	e8 22 3b 00 00       	call   681f60 <<gpui_canvas::text::planner::Cmap>::glyph_index>
  67e43e:	66 85 d2             	test   %dx,%dx
  67e441:	0f 95 c1             	setne  %cl
  67e444:	20 c1                	and    %al,%cl
  67e446:	88 4c 24 10          	mov    %cl,0x10(%rsp)
  67e44a:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  67e44f:	44 89 fe             	mov    %r15d,%esi
  67e452:	e8 09 3b 00 00       	call   681f60 <<gpui_canvas::text::planner::Cmap>::glyph_index>
  67e457:	66 85 d2             	test   %dx,%dx
  67e45a:	0f 95 c1             	setne  %cl
  67e45d:	20 c1                	and    %al,%cl
  67e45f:	00 c9                	add    %cl,%cl
  67e461:	0a 4c 24 10          	or     0x10(%rsp),%cl
  67e465:	0f 84 cf 00 00 00    	je     67e53a <<gpui_canvas::text::planner::Planner>::shape+0x44a>
  67e46b:	8b 44 24 18          	mov    0x18(%rsp),%eax
  67e46f:	08 c8                	or     %cl,%al
  67e471:	89 44 24 18          	mov    %eax,0x18(%rsp)
  67e475:	4c 3b b4 24 a0 01 00 	cmp    0x1a0(%rsp),%r14
  67e47c:	00 
  67e47d:	49 89 ec             	mov    %rbp,%r12
  67e480:	4c 89 ee             	mov    %r13,%rsi
  67e483:	49 89 d8             	mov    %rbx,%r8
  67e486:	0f 85 52 fd ff ff    	jne    67e1de <<gpui_canvas::text::planner::Planner>::shape+0xee>
  67e48c:	8b 4c 24 18          	mov    0x18(%rsp),%ecx
  67e490:	f6 c1 01             	test   $0x1,%cl
  67e493:	4c 8b 2c 24          	mov    (%rsp),%r13
  67e497:	0f 84 c2 00 00 00    	je     67e55f <<gpui_canvas::text::planner::Planner>::shape+0x46f>
  67e49d:	49 83 bd 48 0a 00 00 	cmpq   $0x0,0xa48(%r13)
  67e4a4:	00 
  67e4a5:	0f 85 b4 00 00 00    	jne    67e55f <<gpui_canvas::text::planner::Planner>::shape+0x46f>
  67e4ab:	48 8d 35 46 ba 10 00 	lea    0x10ba46(%rip),%rsi        # 789ef8 <gpui_canvas::text::ARABIC_FONT>
  67e4b2:	48 8d 15 0d 7c 9a ff 	lea    -0x6583f3(%rip),%rdx        # 260c6 <gpui_canvas::text::ARABIC_BYTES>
  67e4b9:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  67e4c0:	00 
  67e4c1:	b9 48 ab 03 00       	mov    $0x3ab48,%ecx
  67e4c6:	45 31 c0             	xor    %r8d,%r8d
  67e4c9:	e8 02 c3 ff ff       	call   67a7d0 <<gpui_canvas::text::FontFace>::shared_static>
  67e4ce:	83 bc 24 00 07 00 00 	cmpl   $0x1,0x700(%rsp)
  67e4d5:	01 
  67e4d6:	75 19                	jne    67e4f1 <<gpui_canvas::text::planner::Planner>::shape+0x401>
  67e4d8:	44 8b a4 24 04 07 00 	mov    0x704(%rsp),%r12d
  67e4df:	00 
  67e4e0:	44 8b bc 24 08 07 00 	mov    0x708(%rsp),%r15d
  67e4e7:	00 
  67e4e8:	eb 50                	jmp    67e53a <<gpui_canvas::text::planner::Planner>::shape+0x44a>
  67e4ea:	31 c9                	xor    %ecx,%ecx
  67e4ec:	e9 81 00 00 00       	jmp    67e572 <<gpui_canvas::text::planner::Planner>::shape+0x482>
  67e4f1:	4d 8d bd 48 0a 00 00 	lea    0xa48(%r13),%r15
  67e4f8:	4c 8b a4 24 08 07 00 	mov    0x708(%rsp),%r12
  67e4ff:	00 
  67e500:	49 8b 07             	mov    (%r15),%rax
  67e503:	48 85 c0             	test   %rax,%rax
  67e506:	74 0f                	je     67e517 <<gpui_canvas::text::planner::Planner>::shape+0x427>
  67e508:	f0 48 ff 08          	lock decq (%rax)
  67e50c:	75 09                	jne    67e517 <<gpui_canvas::text::planner::Planner>::shape+0x427>
  67e50e:	4c 89 ff             	mov    %r15,%rdi
  67e511:	ff 15 d1 89 10 00    	call   *0x1089d1(%rip)        # 786ee8 <_DYNAMIC+0x260>
  67e517:	4d 89 a5 48 0a 00 00 	mov    %r12,0xa48(%r13)
  67e51e:	be 01 00 00 00       	mov    $0x1,%esi
  67e523:	4c 89 ef             	mov    %r13,%rdi
  67e526:	e8 35 37 00 00       	call   681c60 <<gpui_canvas::text::planner::Planner>::register>
  67e52b:	83 f8 ff             	cmp    $0xffffffff,%eax
  67e52e:	8b 4c 24 18          	mov    0x18(%rsp),%ecx
  67e532:	74 2b                	je     67e55f <<gpui_canvas::text::planner::Planner>::shape+0x46f>
  67e534:	41 89 c4             	mov    %eax,%r12d
  67e537:	45 31 ff             	xor    %r15d,%r15d
  67e53a:	44 89 a4 24 98 00 00 	mov    %r12d,0x98(%rsp)
  67e541:	00 
  67e542:	44 89 bc 24 9c 00 00 	mov    %r15d,0x9c(%rsp)
  67e549:	00 
  67e54a:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  67e551:	00 ff ff ff ff 
  67e556:	48 8b 2c 24          	mov    (%rsp),%rbp
  67e55a:	e9 f6 28 00 00       	jmp    680e55 <<gpui_canvas::text::planner::Planner>::shape+0x2d65>
  67e55f:	f6 c1 02             	test   $0x2,%cl
  67e562:	74 0e                	je     67e572 <<gpui_canvas::text::planner::Planner>::shape+0x482>
  67e564:	49 83 bd 50 0a 00 00 	cmpq   $0x0,0xa50(%r13)
  67e56b:	00 
  67e56c:	0f 84 6e 2a 00 00    	je     680fe0 <<gpui_canvas::text::planner::Planner>::shape+0x2ef0>
  67e572:	48 c7 84 24 38 03 00 	movq   $0xffffffffffffffff,0x338(%rsp)
  67e579:	00 ff ff ff ff 
  67e57e:	48 8d 05 71 d4 bd ff 	lea    -0x422b8f(%rip),%rax        # 25b9f6 <gpui_canvas::text::PRIMARY_BYTES+0x1f44d4>
  67e585:	48 89 84 24 40 03 00 	mov    %rax,0x340(%rsp)
  67e58c:	00 
  67e58d:	48 c7 84 24 48 03 00 	movq   $0xc,0x348(%rsp)
  67e594:	00 0c 00 00 00 
  67e599:	48 c7 84 24 50 03 00 	movq   $0xffffffffffffffff,0x350(%rsp)
  67e5a0:	00 ff ff ff ff 
  67e5a5:	48 8d 05 56 d4 bd ff 	lea    -0x422baa(%rip),%rax        # 25ba02 <gpui_canvas::text::PRIMARY_BYTES+0x1f44e0>
  67e5ac:	48 89 84 24 58 03 00 	mov    %rax,0x358(%rsp)
  67e5b3:	00 
  67e5b4:	48 c7 84 24 60 03 00 	movq   $0x11,0x360(%rsp)
  67e5bb:	00 11 00 00 00 
  67e5c0:	48 c7 84 24 68 03 00 	movq   $0xffffffffffffffff,0x368(%rsp)
  67e5c7:	00 ff ff ff ff 
  67e5cc:	4c 8d 35 40 d4 bd ff 	lea    -0x422bc0(%rip),%r14        # 25ba13 <gpui_canvas::text::PRIMARY_BYTES+0x1f44f1>
  67e5d3:	4c 89 b4 24 70 03 00 	mov    %r14,0x370(%rsp)
  67e5da:	00 
  67e5db:	48 c7 84 24 78 03 00 	movq   $0x11,0x378(%rsp)
  67e5e2:	00 11 00 00 00 
  67e5e7:	f6 c1 01             	test   $0x1,%cl
  67e5ea:	75 1c                	jne    67e608 <<gpui_canvas::text::planner::Planner>::shape+0x518>
  67e5ec:	4c 8d bc 24 50 03 00 	lea    0x350(%rsp),%r15
  67e5f3:	00 
  67e5f4:	b8 01 00 00 00       	mov    $0x1,%eax
  67e5f9:	48 89 84 24 10 02 00 	mov    %rax,0x210(%rsp)
  67e600:	00 
  67e601:	f6 c1 02             	test   $0x2,%cl
  67e604:	75 24                	jne    67e62a <<gpui_canvas::text::planner::Planner>::shape+0x53a>
  67e606:	eb 5a                	jmp    67e662 <<gpui_canvas::text::planner::Planner>::shape+0x572>
  67e608:	4c 8d bc 24 68 03 00 	lea    0x368(%rsp),%r15
  67e60f:	00 
  67e610:	48 89 84 24 58 03 00 	mov    %rax,0x358(%rsp)
  67e617:	00 
  67e618:	b8 02 00 00 00       	mov    $0x2,%eax
  67e61d:	48 89 84 24 10 02 00 	mov    %rax,0x210(%rsp)
  67e624:	00 
  67e625:	f6 c1 02             	test   $0x2,%cl
  67e628:	74 38                	je     67e662 <<gpui_canvas::text::planner::Planner>::shape+0x572>
  67e62a:	49 8b 37             	mov    (%r15),%rsi
  67e62d:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  67e631:	77 14                	ja     67e647 <<gpui_canvas::text::planner::Planner>::shape+0x557>
  67e633:	48 85 f6             	test   %rsi,%rsi
  67e636:	74 0f                	je     67e647 <<gpui_canvas::text::planner::Planner>::shape+0x557>
  67e638:	49 8b 7f 08          	mov    0x8(%r15),%rdi
  67e63c:	ba 01 00 00 00       	mov    $0x1,%edx
  67e641:	ff 15 79 88 10 00    	call   *0x108879(%rip)        # 786ec0 <_DYNAMIC+0x238>
  67e647:	49 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%r15)
  67e64e:	4d 89 77 08          	mov    %r14,0x8(%r15)
  67e652:	49 c7 47 10 11 00 00 	movq   $0x11,0x10(%r15)
  67e659:	00 
  67e65a:	48 ff 84 24 10 02 00 	incq   0x210(%rsp)
  67e661:	00 
  67e662:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  67e669:	00 00 00 00 00 
  67e66e:	48 c7 84 24 f0 00 00 	movq   $0x4,0xf0(%rsp)
  67e675:	00 04 00 00 00 
  67e67a:	48 c7 84 24 f8 00 00 	movq   $0x0,0xf8(%rsp)
  67e681:	00 00 00 00 00 
  67e686:	48 c7 84 24 40 01 00 	movq   $0xffffffffffffffff,0x140(%rsp)
  67e68d:	00 ff ff ff ff 
  67e692:	f6 84 24 b8 01 00 00 	testb  $0x1,0x1b8(%rsp)
  67e699:	01 
  67e69a:	75 11                	jne    67e6ad <<gpui_canvas::text::planner::Planner>::shape+0x5bd>
  67e69c:	f3 0f 10 05 18 f0 99 	movss  -0x660fe8(%rip),%xmm0        # 1d6bc <GCC_except_table0+0x98>
  67e6a3:	ff 
  67e6a4:	f3 0f 11 84 24 bc 01 	movss  %xmm0,0x1bc(%rsp)
  67e6ab:	00 00 
  67e6ad:	49 8d 45 78          	lea    0x78(%r13),%rax
  67e6b1:	48 89 84 24 c0 03 00 	mov    %rax,0x3c0(%rsp)
  67e6b8:	00 
  67e6b9:	49 8d 85 38 06 00 00 	lea    0x638(%r13),%rax
  67e6c0:	48 89 84 24 b8 03 00 	mov    %rax,0x3b8(%rsp)
  67e6c7:	00 
  67e6c8:	49 8d 85 c8 08 00 00 	lea    0x8c8(%r13),%rax
  67e6cf:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  67e6d4:	4c 8d bc 24 b0 02 00 	lea    0x2b0(%rsp),%r15
  67e6db:	00 
  67e6dc:	48 8d ac 24 b8 04 00 	lea    0x4b8(%rsp),%rbp
  67e6e3:	00 
  67e6e4:	0f 57 c0             	xorps  %xmm0,%xmm0
  67e6e7:	0f 29 84 24 80 02 00 	movaps %xmm0,0x280(%rsp)
  67e6ee:	00 
  67e6ef:	f3 0f 11 44 24 24    	movss  %xmm0,0x24(%rsp)
  67e6f5:	f3 0f 11 44 24 6c    	movss  %xmm0,0x6c(%rsp)
  67e6fb:	48 8d 05 b6 eb 0f 00 	lea    0xfebb6(%rip),%rax        # 77d2b8 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x178>
  67e702:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  67e707:	48 8d 05 02 ee 0f 00 	lea    0xfee02(%rip),%rax        # 77d510 <anon.1151abbc0aa39aee2edfb443bb148018.25.llvm.12564331471646380133>
  67e70e:	48 89 84 24 70 02 00 	mov    %rax,0x270(%rsp)
  67e715:	00 
  67e716:	48 c7 84 24 08 02 00 	movq   $0x0,0x208(%rsp)
  67e71d:	00 00 00 00 00 
  67e722:	31 d2                	xor    %edx,%edx
  67e724:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  67e72b:	00 
  67e72c:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  67e731:	31 c0                	xor    %eax,%eax
  67e733:	be fe ff ff ff       	mov    $0xfffffffe,%esi
  67e738:	83 fe fe             	cmp    $0xfffffffe,%esi
  67e73b:	75 23                	jne    67e760 <<gpui_canvas::text::planner::Planner>::shape+0x670>
  67e73d:	4c 8b 54 24 18       	mov    0x18(%rsp),%r10
  67e742:	4c 3b 94 24 a0 01 00 	cmp    0x1a0(%rsp),%r10
  67e749:	00 
  67e74a:	74 34                	je     67e780 <<gpui_canvas::text::planner::Planner>::shape+0x690>
  67e74c:	41 0f b6 0a          	movzbl (%r10),%ecx
  67e750:	84 c9                	test   %cl,%cl
  67e752:	78 44                	js     67e798 <<gpui_canvas::text::planner::Planner>::shape+0x6a8>
  67e754:	4d 8d 4a 01          	lea    0x1(%r10),%r9
  67e758:	e9 98 00 00 00       	jmp    67e7f5 <<gpui_canvas::text::planner::Planner>::shape+0x705>
  67e75d:	0f 1f 00             	nopl   (%rax)
  67e760:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
  67e765:	89 f1                	mov    %esi,%ecx
  67e767:	4c 8b 84 24 a0 03 00 	mov    0x3a0(%rsp),%r8
  67e76e:	00 
  67e76f:	e9 8a 00 00 00       	jmp    67e7fe <<gpui_canvas::text::planner::Planner>::shape+0x70e>
  67e774:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  67e77b:	00 00 00 00 00 
  67e780:	c7 44 24 74 fe ff ff 	movl   $0xfffffffe,0x74(%rsp)
  67e787:	ff 
  67e788:	b1 01                	mov    $0x1,%cl
  67e78a:	89 4c 24 4c          	mov    %ecx,0x4c(%rsp)
  67e78e:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  67e793:	e9 ce 01 00 00       	jmp    67e966 <<gpui_canvas::text::planner::Planner>::shape+0x876>
  67e798:	49 89 c0             	mov    %rax,%r8
  67e79b:	89 c8                	mov    %ecx,%eax
  67e79d:	83 e0 1f             	and    $0x1f,%eax
  67e7a0:	41 0f b6 7a 01       	movzbl 0x1(%r10),%edi
  67e7a5:	83 e7 3f             	and    $0x3f,%edi
  67e7a8:	80 f9 e0             	cmp    $0xe0,%cl
  67e7ab:	72 2d                	jb     67e7da <<gpui_canvas::text::planner::Planner>::shape+0x6ea>
  67e7ad:	41 0f b6 72 02       	movzbl 0x2(%r10),%esi
  67e7b2:	c1 e7 06             	shl    $0x6,%edi
  67e7b5:	83 e6 3f             	and    $0x3f,%esi
  67e7b8:	09 fe                	or     %edi,%esi
  67e7ba:	80 f9 f0             	cmp    $0xf0,%cl
  67e7bd:	72 28                	jb     67e7e7 <<gpui_canvas::text::planner::Planner>::shape+0x6f7>
  67e7bf:	4d 8d 4a 04          	lea    0x4(%r10),%r9
  67e7c3:	41 0f b6 4a 03       	movzbl 0x3(%r10),%ecx
  67e7c8:	83 e0 07             	and    $0x7,%eax
  67e7cb:	c1 e0 12             	shl    $0x12,%eax
  67e7ce:	c1 e6 06             	shl    $0x6,%esi
  67e7d1:	83 e1 3f             	and    $0x3f,%ecx
  67e7d4:	09 f1                	or     %esi,%ecx
  67e7d6:	09 c1                	or     %eax,%ecx
  67e7d8:	eb 18                	jmp    67e7f2 <<gpui_canvas::text::planner::Planner>::shape+0x702>
  67e7da:	4d 8d 4a 02          	lea    0x2(%r10),%r9
  67e7de:	c1 e0 06             	shl    $0x6,%eax
  67e7e1:	09 f8                	or     %edi,%eax
  67e7e3:	89 c1                	mov    %eax,%ecx
  67e7e5:	eb 0b                	jmp    67e7f2 <<gpui_canvas::text::planner::Planner>::shape+0x702>
  67e7e7:	4d 8d 4a 03          	lea    0x3(%r10),%r9
  67e7eb:	c1 e0 0c             	shl    $0xc,%eax
  67e7ee:	09 c6                	or     %eax,%esi
  67e7f0:	89 f1                	mov    %esi,%ecx
  67e7f2:	4c 89 c0             	mov    %r8,%rax
  67e7f5:	49 89 c0             	mov    %rax,%r8
  67e7f8:	4c 29 d0             	sub    %r10,%rax
  67e7fb:	4c 01 c8             	add    %r9,%rax
  67e7fe:	c7 44 24 74 fe ff ff 	movl   $0xfffffffe,0x74(%rsp)
  67e805:	ff 
  67e806:	40 b6 01             	mov    $0x1,%sil
  67e809:	89 74 24 4c          	mov    %esi,0x4c(%rsp)
  67e80d:	83 f9 0c             	cmp    $0xc,%ecx
  67e810:	7e 1e                	jle    67e830 <<gpui_canvas::text::planner::Planner>::shape+0x740>
  67e812:	83 f9 0d             	cmp    $0xd,%ecx
  67e815:	0f 84 60 01 00 00    	je     67e97b <<gpui_canvas::text::planner::Planner>::shape+0x88b>
  67e81b:	81 f9 85 00 00 00    	cmp    $0x85,%ecx
  67e821:	74 1b                	je     67e83e <<gpui_canvas::text::planner::Planner>::shape+0x74e>
  67e823:	81 f9 29 20 00 00    	cmp    $0x2029,%ecx
  67e829:	74 13                	je     67e83e <<gpui_canvas::text::planner::Planner>::shape+0x74e>
  67e82b:	e9 7d 00 00 00       	jmp    67e8ad <<gpui_canvas::text::planner::Planner>::shape+0x7bd>
  67e830:	83 f9 ff             	cmp    $0xffffffff,%ecx
  67e833:	0f 84 23 01 00 00    	je     67e95c <<gpui_canvas::text::planner::Planner>::shape+0x86c>
  67e839:	83 f9 0a             	cmp    $0xa,%ecx
  67e83c:	75 6f                	jne    67e8ad <<gpui_canvas::text::planner::Planner>::shape+0x7bd>
  67e83e:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  67e843:	81 f9 80 00 00 00    	cmp    $0x80,%ecx
  67e849:	0f 83 3d 01 00 00    	jae    67e98c <<gpui_canvas::text::planner::Planner>::shape+0x89c>
  67e84f:	49 8d 58 01          	lea    0x1(%r8),%rbx
  67e853:	83 f9 0d             	cmp    $0xd,%ecx
  67e856:	0f 85 42 01 00 00    	jne    67e99e <<gpui_canvas::text::planner::Planner>::shape+0x8ae>
  67e85c:	4c 8b 54 24 18       	mov    0x18(%rsp),%r10
  67e861:	4c 3b 94 24 a0 01 00 	cmp    0x1a0(%rsp),%r10
  67e868:	00 
  67e869:	0f 84 bd 23 00 00    	je     680c2c <<gpui_canvas::text::planner::Planner>::shape+0x2b3c>
  67e86f:	45 0f b6 1a          	movzbl (%r10),%r11d
  67e873:	45 84 db             	test   %r11b,%r11b
  67e876:	0f 88 bd 23 00 00    	js     680c39 <<gpui_canvas::text::planner::Planner>::shape+0x2b49>
  67e87c:	4d 8d 72 01          	lea    0x1(%r10),%r14
  67e880:	e9 1a 24 00 00       	jmp    680c9f <<gpui_canvas::text::planner::Planner>::shape+0x2baf>
  67e885:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  67e88c:	00 00 00 00 
  67e890:	81 f9 29 20 00 00    	cmp    $0x2029,%ecx
  67e896:	0f 84 e4 00 00 00    	je     67e980 <<gpui_canvas::text::planner::Planner>::shape+0x890>
  67e89c:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
  67e8a1:	81 f9 85 00 00 00    	cmp    $0x85,%ecx
  67e8a7:	0f 84 d3 00 00 00    	je     67e980 <<gpui_canvas::text::planner::Planner>::shape+0x890>
  67e8ad:	4c 3b 8c 24 a0 01 00 	cmp    0x1a0(%rsp),%r9
  67e8b4:	00 
  67e8b5:	0f 84 a1 00 00 00    	je     67e95c <<gpui_canvas::text::planner::Planner>::shape+0x86c>
  67e8bb:	49 89 c0             	mov    %rax,%r8
  67e8be:	41 0f b6 09          	movzbl (%r9),%ecx
  67e8c2:	84 c9                	test   %cl,%cl
  67e8c4:	78 0a                	js     67e8d0 <<gpui_canvas::text::planner::Planner>::shape+0x7e0>
  67e8c6:	49 8d 41 01          	lea    0x1(%r9),%rax
  67e8ca:	eb 64                	jmp    67e930 <<gpui_canvas::text::planner::Planner>::shape+0x840>
  67e8cc:	0f 1f 40 00          	nopl   0x0(%rax)
  67e8d0:	89 c8                	mov    %ecx,%eax
  67e8d2:	83 e0 1f             	and    $0x1f,%eax
  67e8d5:	41 0f b6 79 01       	movzbl 0x1(%r9),%edi
  67e8da:	83 e7 3f             	and    $0x3f,%edi
  67e8dd:	80 f9 df             	cmp    $0xdf,%cl
  67e8e0:	76 30                	jbe    67e912 <<gpui_canvas::text::planner::Planner>::shape+0x822>
  67e8e2:	41 0f b6 71 02       	movzbl 0x2(%r9),%esi
  67e8e7:	c1 e7 06             	shl    $0x6,%edi
  67e8ea:	83 e6 3f             	and    $0x3f,%esi
  67e8ed:	09 fe                	or     %edi,%esi
  67e8ef:	80 f9 f0             	cmp    $0xf0,%cl
  67e8f2:	72 2e                	jb     67e922 <<gpui_canvas::text::planner::Planner>::shape+0x832>
  67e8f4:	49 8d 79 04          	lea    0x4(%r9),%rdi
  67e8f8:	41 0f b6 49 03       	movzbl 0x3(%r9),%ecx
  67e8fd:	83 e0 07             	and    $0x7,%eax
  67e900:	c1 e0 12             	shl    $0x12,%eax
  67e903:	c1 e6 06             	shl    $0x6,%esi
  67e906:	83 e1 3f             	and    $0x3f,%ecx
  67e909:	09 f1                	or     %esi,%ecx
  67e90b:	09 c1                	or     %eax,%ecx
  67e90d:	48 89 f8             	mov    %rdi,%rax
  67e910:	eb 1e                	jmp    67e930 <<gpui_canvas::text::planner::Planner>::shape+0x840>
  67e912:	49 8d 71 02          	lea    0x2(%r9),%rsi
  67e916:	c1 e0 06             	shl    $0x6,%eax
  67e919:	09 f8                	or     %edi,%eax
  67e91b:	89 c1                	mov    %eax,%ecx
  67e91d:	48 89 f0             	mov    %rsi,%rax
  67e920:	eb 0e                	jmp    67e930 <<gpui_canvas::text::planner::Planner>::shape+0x840>
  67e922:	49 8d 49 03          	lea    0x3(%r9),%rcx
  67e926:	c1 e0 0c             	shl    $0xc,%eax
  67e929:	09 c6                	or     %eax,%esi
  67e92b:	48 89 c8             	mov    %rcx,%rax
  67e92e:	89 f1                	mov    %esi,%ecx
  67e930:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  67e935:	4c 29 c8             	sub    %r9,%rax
  67e938:	4c 01 c0             	add    %r8,%rax
  67e93b:	81 f9 84 00 00 00    	cmp    $0x84,%ecx
  67e941:	0f 8f 49 ff ff ff    	jg     67e890 <<gpui_canvas::text::planner::Planner>::shape+0x7a0>
  67e947:	83 f9 0a             	cmp    $0xa,%ecx
  67e94a:	74 34                	je     67e980 <<gpui_canvas::text::planner::Planner>::shape+0x890>
  67e94c:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
  67e951:	83 f9 0d             	cmp    $0xd,%ecx
  67e954:	0f 85 53 ff ff ff    	jne    67e8ad <<gpui_canvas::text::planner::Planner>::shape+0x7bd>
  67e95a:	eb 24                	jmp    67e980 <<gpui_canvas::text::planner::Planner>::shape+0x890>
  67e95c:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  67e961:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  67e966:	48 89 d3             	mov    %rdx,%rbx
  67e969:	48 89 ce             	mov    %rcx,%rsi
  67e96c:	48 29 d6             	sub    %rdx,%rsi
  67e96f:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  67e974:	73 44                	jae    67e9ba <<gpui_canvas::text::planner::Planner>::shape+0x8ca>
  67e976:	e9 65 2d 00 00       	jmp    6816e0 <<gpui_canvas::text::planner::Planner>::shape+0x35f0>
  67e97b:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  67e980:	81 f9 80 00 00 00    	cmp    $0x80,%ecx
  67e986:	0f 82 c3 fe ff ff    	jb     67e84f <<gpui_canvas::text::planner::Planner>::shape+0x75f>
  67e98c:	81 f9 00 08 00 00    	cmp    $0x800,%ecx
  67e992:	bb 03 00 00 00       	mov    $0x3,%ebx
  67e997:	48 83 db 00          	sbb    $0x0,%rbx
  67e99b:	4c 01 c3             	add    %r8,%rbx
  67e99e:	c7 44 24 4c 00 00 00 	movl   $0x0,0x4c(%rsp)
  67e9a5:	00 
  67e9a6:	4c 89 c1             	mov    %r8,%rcx
  67e9a9:	48 89 ce             	mov    %rcx,%rsi
  67e9ac:	48 29 d6             	sub    %rdx,%rsi
  67e9af:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  67e9b4:	0f 82 26 2d 00 00    	jb     6816e0 <<gpui_canvas::text::planner::Planner>::shape+0x35f0>
  67e9ba:	48 85 d2             	test   %rdx,%rdx
  67e9bd:	48 89 84 24 b0 03 00 	mov    %rax,0x3b0(%rsp)
  67e9c4:	00 
  67e9c5:	74 2f                	je     67e9f6 <<gpui_canvas::text::planner::Planner>::shape+0x906>
  67e9c7:	48 3b 54 24 50       	cmp    0x50(%rsp),%rdx
  67e9cc:	73 22                	jae    67e9f0 <<gpui_canvas::text::planner::Planner>::shape+0x900>
  67e9ce:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  67e9d5:	00 
  67e9d6:	80 3c 10 bf          	cmpb   $0xbf,(%rax,%rdx,1)
  67e9da:	7f 1a                	jg     67e9f6 <<gpui_canvas::text::planner::Planner>::shape+0x906>
  67e9dc:	e9 ff 2c 00 00       	jmp    6816e0 <<gpui_canvas::text::planner::Planner>::shape+0x35f0>
  67e9e1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  67e9e8:	0f 1f 84 00 00 00 00 
  67e9ef:	00 
  67e9f0:	0f 85 ea 2c 00 00    	jne    6816e0 <<gpui_canvas::text::planner::Planner>::shape+0x35f0>
  67e9f6:	48 85 c9             	test   %rcx,%rcx
  67e9f9:	74 2b                	je     67ea26 <<gpui_canvas::text::planner::Planner>::shape+0x936>
  67e9fb:	48 3b 4c 24 50       	cmp    0x50(%rsp),%rcx
  67ea00:	73 1e                	jae    67ea20 <<gpui_canvas::text::planner::Planner>::shape+0x930>
  67ea02:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  67ea09:	00 
  67ea0a:	80 3c 08 c0          	cmpb   $0xc0,(%rax,%rcx,1)
  67ea0e:	7d 16                	jge    67ea26 <<gpui_canvas::text::planner::Planner>::shape+0x936>
  67ea10:	e9 cb 2c 00 00       	jmp    6816e0 <<gpui_canvas::text::planner::Planner>::shape+0x35f0>
  67ea15:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  67ea1c:	00 00 00 00 
  67ea20:	0f 85 ba 2c 00 00    	jne    6816e0 <<gpui_canvas::text::planner::Planner>::shape+0x35f0>
  67ea26:	48 89 8c 24 90 01 00 	mov    %rcx,0x190(%rsp)
  67ea2d:	00 
  67ea2e:	48 89 9c 24 a8 03 00 	mov    %rbx,0x3a8(%rsp)
  67ea35:	00 
  67ea36:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  67ea3d:	00 
  67ea3e:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
  67ea43:	48 8d 0c 10          	lea    (%rax,%rdx,1),%rcx
  67ea47:	48 8d bc 24 88 04 00 	lea    0x488(%rsp),%rdi
  67ea4e:	00 
  67ea4f:	48 8b b4 24 c0 03 00 	mov    0x3c0(%rsp),%rsi
  67ea56:	00 
  67ea57:	48 8b 94 24 b8 03 00 	mov    0x3b8(%rsp),%rdx
  67ea5e:	00 
  67ea5f:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  67ea64:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  67ea69:	f3 0f 10 05 db eb 99 	movss  -0x661425(%rip),%xmm0        # 1d64c <GCC_except_table0+0x28>
  67ea70:	ff 
  67ea71:	45 31 c9             	xor    %r9d,%r9d
  67ea74:	e8 97 c2 ff ff       	call   67ad10 <<parley::context::LayoutContext<()>>::ranged_builder>
  67ea79:	48 8d bc 24 88 04 00 	lea    0x488(%rsp),%rdi
  67ea80:	00 
  67ea81:	48 8d b4 24 38 03 00 	lea    0x338(%rsp),%rsi
  67ea88:	00 
  67ea89:	48 8b 94 24 10 02 00 	mov    0x210(%rsp),%rdx
  67ea90:	00 
  67ea91:	e8 7a ff fe ff       	call   66ea10 <<parley::builder::RangedBuilder<()>>::push_default::<&[parlance::font_family::FontFamilyName]>>
  67ea96:	4c 8b b4 24 88 04 00 	mov    0x488(%rsp),%r14
  67ea9d:	00 
  67ea9e:	4c 8b ac 24 90 04 00 	mov    0x490(%rsp),%r13
  67eaa5:	00 
  67eaa6:	4d 8d a6 30 02 00 00 	lea    0x230(%r14),%r12
  67eaad:	c6 84 24 00 07 00 00 	movb   $0x1,0x700(%rsp)
  67eab4:	01 
  67eab5:	f3 0f 10 44 24 7c    	movss  0x7c(%rsp),%xmm0
  67eabb:	f3 0f 11 84 24 04 07 	movss  %xmm0,0x704(%rsp)
  67eac2:	00 00 
  67eac4:	f3 0f 10 84 24 a8 04 	movss  0x4a8(%rsp),%xmm0
  67eacb:	00 00 
  67eacd:	48 8d bc 24 b0 04 00 	lea    0x4b0(%rsp),%rdi
  67ead4:	00 
  67ead5:	4c 89 e6             	mov    %r12,%rsi
  67ead8:	4c 89 ea             	mov    %r13,%rdx
  67eadb:	48 8d 9c 24 00 07 00 	lea    0x700(%rsp),%rbx
  67eae2:	00 
  67eae3:	48 89 d9             	mov    %rbx,%rcx
  67eae6:	f3 0f 11 44 24 30    	movss  %xmm0,0x30(%rsp)
  67eaec:	e8 3f 5c fe ff       	call   664730 <<parley::resolve::ResolveContext>::resolve_property::<()>>
  67eaf1:	48 89 df             	mov    %rbx,%rdi
  67eaf4:	e8 f7 00 ff ff       	call   66ebf0 <core::ptr::drop_glue::<parley::style::StyleProperty<()>>>
  67eaf9:	49 83 be 20 05 00 00 	cmpq   $0xffffffffffffffff,0x520(%r14)
  67eb00:	ff 
  67eb01:	0f 84 17 28 00 00    	je     68131e <<gpui_canvas::text::planner::Planner>::shape+0x322e>
  67eb07:	49 8d 9e 98 04 00 00 	lea    0x498(%r14),%rbx
  67eb0e:	48 89 df             	mov    %rbx,%rdi
  67eb11:	48 8d b4 24 b0 04 00 	lea    0x4b0(%rsp),%rsi
  67eb18:	00 
  67eb19:	e8 42 7e fe ff       	call   666960 <<parley::resolve::ResolvedStyle<()>>::apply>
  67eb1e:	66 c7 84 24 00 07 00 	movw   $0x117,0x700(%rsp)
  67eb25:	00 17 01 
  67eb28:	48 8d bc 24 b0 04 00 	lea    0x4b0(%rsp),%rdi
  67eb2f:	00 
  67eb30:	4c 89 e6             	mov    %r12,%rsi
  67eb33:	4c 89 ea             	mov    %r13,%rdx
  67eb36:	4c 8d a4 24 00 07 00 	lea    0x700(%rsp),%r12
  67eb3d:	00 
  67eb3e:	4c 89 e1             	mov    %r12,%rcx
  67eb41:	f3 0f 10 44 24 30    	movss  0x30(%rsp),%xmm0
  67eb47:	e8 e4 5b fe ff       	call   664730 <<parley::resolve::ResolveContext>::resolve_property::<()>>
  67eb4c:	4c 89 e7             	mov    %r12,%rdi
  67eb4f:	e8 9c 00 ff ff       	call   66ebf0 <core::ptr::drop_glue::<parley::style::StyleProperty<()>>>
  67eb54:	49 83 be 20 05 00 00 	cmpq   $0xffffffffffffffff,0x520(%r14)
  67eb5b:	ff 
  67eb5c:	0f 84 bc 27 00 00    	je     68131e <<gpui_canvas::text::planner::Planner>::shape+0x322e>
  67eb62:	48 89 df             	mov    %rbx,%rdi
  67eb65:	48 8d b4 24 b0 04 00 	lea    0x4b0(%rsp),%rsi
  67eb6c:	00 
  67eb6d:	e8 ee 7d fe ff       	call   666960 <<parley::resolve::ResolvedStyle<()>>::apply>
  67eb72:	48 8d bc 24 88 04 00 	lea    0x488(%rsp),%rdi
  67eb79:	00 
  67eb7a:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  67eb7f:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  67eb84:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  67eb89:	e8 32 c8 fe ff       	call   66b3c0 <<parley::builder::RangedBuilder<()>>::build_into::<&str>>
  67eb8e:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  67eb95:	00 
  67eb96:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  67eb9b:	e8 c0 96 ff ff       	call   678260 <<parley::layout::line_break::BreakLines<()>>::new>
  67eba0:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  67eba7:	00 
  67eba8:	f3 0f 10 84 24 bc 01 	movss  0x1bc(%rsp),%xmm0
  67ebaf:	00 00 
  67ebb1:	e8 8a 87 ff ff       	call   677340 <<parley::layout::line_break::BreakLines<()>>::break_remaining>
  67ebb6:	80 bc 24 2c 02 00 00 	cmpb   $0x0,0x22c(%rsp)
  67ebbd:	00 
  67ebbe:	74 20                	je     67ebe0 <<gpui_canvas::text::planner::Planner>::shape+0xaf0>
  67ebc0:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  67ebc7:	00 ff 
  67ebc9:	0f 85 11 02 00 00    	jne    67ede0 <<gpui_canvas::text::planner::Planner>::shape+0xcf0>
  67ebcf:	31 c0                	xor    %eax,%eax
  67ebd1:	e9 90 01 00 00       	jmp    67ed66 <<gpui_canvas::text::planner::Planner>::shape+0xc76>
  67ebd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  67ebdd:	00 00 00 
  67ebe0:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
  67ebe6:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  67ebed:	00 
  67ebee:	0f 85 5c 01 00 00    	jne    67ed50 <<gpui_canvas::text::planner::Planner>::shape+0xc60>
  67ebf4:	48 3b 44 24 50       	cmp    0x50(%rsp),%rax
  67ebf9:	0f 85 51 01 00 00    	jne    67ed50 <<gpui_canvas::text::planner::Planner>::shape+0xc60>
  67ebff:	48 8b 04 24          	mov    (%rsp),%rax
  67ec03:	48 83 b8 e0 09 00 00 	cmpq   $0x1,0x9e0(%rax)
  67ec0a:	01 
  67ec0b:	0f 85 3f 01 00 00    	jne    67ed50 <<gpui_canvas::text::planner::Planner>::shape+0xc60>
  67ec11:	48 8b 14 24          	mov    (%rsp),%rdx
  67ec15:	48 8b 82 d8 09 00 00 	mov    0x9d8(%rdx),%rax
  67ec1c:	48 8d 48 70          	lea    0x70(%rax),%rcx
  67ec20:	48 89 8c 24 08 07 00 	mov    %rcx,0x708(%rsp)
  67ec27:	00 
  67ec28:	48 c7 84 24 10 07 00 	movq   $0x0,0x710(%rsp)
  67ec2f:	00 00 00 00 00 
  67ec34:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  67ec39:	48 89 b4 24 18 07 00 	mov    %rsi,0x718(%rsp)
  67ec40:	00 
  67ec41:	48 c7 84 24 48 07 00 	movq   $0x0,0x748(%rsp)
  67ec48:	00 00 00 00 00 
  67ec4d:	48 89 94 24 b0 04 00 	mov    %rdx,0x4b0(%rsp)
  67ec54:	00 
  67ec55:	48 c7 84 24 20 07 00 	movq   $0x0,0x720(%rsp)
  67ec5c:	00 00 00 00 00 
  67ec61:	48 89 8c 24 00 07 00 	mov    %rcx,0x700(%rsp)
  67ec68:	00 
  67ec69:	48 8b 78 10          	mov    0x10(%rax),%rdi
  67ec6d:	48 8b 70 18          	mov    0x18(%rax),%rsi
  67ec71:	48 8b 92 f8 09 00 00 	mov    0x9f8(%rdx),%rdx
  67ec78:	48 39 fe             	cmp    %rdi,%rsi
  67ec7b:	0f 82 1b 2a 00 00    	jb     68169c <<gpui_canvas::text::planner::Planner>::shape+0x35ac>
  67ec81:	48 39 d6             	cmp    %rdx,%rsi
  67ec84:	0f 87 12 2a 00 00    	ja     68169c <<gpui_canvas::text::planner::Planner>::shape+0x35ac>
  67ec8a:	48 8b 04 24          	mov    (%rsp),%rax
  67ec8e:	48 8b 80 f0 09 00 00 	mov    0x9f0(%rax),%rax
  67ec95:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  67ec99:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
  67ec9d:	48 8d 14 b6          	lea    (%rsi,%rsi,4),%rdx
  67eca1:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
  67eca5:	48 89 8c 24 20 07 00 	mov    %rcx,0x720(%rsp)
  67ecac:	00 
  67ecad:	48 89 84 24 28 07 00 	mov    %rax,0x728(%rsp)
  67ecb4:	00 
  67ecb5:	48 c7 84 24 30 07 00 	movq   $0x0,0x730(%rsp)
  67ecbc:	00 00 00 00 00 
  67ecc1:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  67ecc6:	48 89 84 24 38 07 00 	mov    %rax,0x738(%rsp)
  67eccd:	00 
  67ecce:	c7 84 24 40 07 00 00 	movl   $0x0,0x740(%rsp)
  67ecd5:	00 00 00 00 
  67ecd9:	48 8d bc 24 20 07 00 	lea    0x720(%rsp),%rdi
  67ece0:	00 
  67ece1:	48 8d b4 24 48 07 00 	lea    0x748(%rsp),%rsi
  67ece8:	00 
  67ece9:	48 8d 94 24 b0 04 00 	lea    0x4b0(%rsp),%rdx
  67ecf0:	00 
  67ecf1:	e8 4a 69 fe ff       	call   665640 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>>
  67ecf6:	48 c7 84 24 10 07 00 	movq   $0x1,0x710(%rsp)
  67ecfd:	00 01 00 00 00 
  67ed02:	84 c0                	test   %al,%al
  67ed04:	75 4a                	jne    67ed50 <<gpui_canvas::text::planner::Planner>::shape+0xc60>
  67ed06:	48 c7 84 24 20 07 00 	movq   $0x0,0x720(%rsp)
  67ed0d:	00 00 00 00 00 
  67ed12:	48 83 bc 24 48 07 00 	cmpq   $0x0,0x748(%rsp)
  67ed19:	00 00 
  67ed1b:	0f 84 90 1e 00 00    	je     680bb1 <<gpui_canvas::text::planner::Planner>::shape+0x2ac1>
  67ed21:	48 8d bc 24 48 07 00 	lea    0x748(%rsp),%rdi
  67ed28:	00 
  67ed29:	48 8d b4 24 70 07 00 	lea    0x770(%rsp),%rsi
  67ed30:	00 
  67ed31:	48 8d 94 24 b0 04 00 	lea    0x4b0(%rsp),%rdx
  67ed38:	00 
  67ed39:	e8 02 69 fe ff       	call   665640 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>>
  67ed3e:	84 c0                	test   %al,%al
  67ed40:	0f 84 6b 1e 00 00    	je     680bb1 <<gpui_canvas::text::planner::Planner>::shape+0x2ac1>
  67ed46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  67ed4d:	00 00 00 
  67ed50:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  67ed57:	00 ff 
  67ed59:	0f 85 81 00 00 00    	jne    67ede0 <<gpui_canvas::text::planner::Planner>::shape+0xcf0>
  67ed5f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  67ed66:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  67ed6d:	00 00 00 00 00 
  67ed72:	48 c7 84 24 48 01 00 	movq   $0x4,0x148(%rsp)
  67ed79:	00 04 00 00 00 
  67ed7e:	48 8d 8c 24 48 01 00 	lea    0x148(%rsp),%rcx
  67ed85:	00 
  67ed86:	0f 57 c0             	xorps  %xmm0,%xmm0
  67ed89:	0f 11 41 08          	movups %xmm0,0x8(%rcx)
  67ed8d:	48 c7 84 24 60 01 00 	movq   $0x4,0x160(%rsp)
  67ed94:	00 04 00 00 00 
  67ed99:	48 c7 84 24 68 01 00 	movq   $0x0,0x168(%rsp)
  67eda0:	00 00 00 00 00 
  67eda5:	48 89 84 24 70 01 00 	mov    %rax,0x170(%rsp)
  67edac:	00 
  67edad:	48 c7 84 24 78 01 00 	movq   $0x4,0x178(%rsp)
  67edb4:	00 04 00 00 00 
  67edb9:	48 c7 84 24 80 01 00 	movq   $0x0,0x180(%rsp)
  67edc0:	00 00 00 00 00 
  67edc5:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  67edca:	89 84 24 88 01 00 00 	mov    %eax,0x188(%rsp)
  67edd1:	f3 0f 10 44 24 7c    	movss  0x7c(%rsp),%xmm0
  67edd7:	f3 0f 11 84 24 8c 01 	movss  %xmm0,0x18c(%rsp)
  67edde:	00 00 
  67ede0:	48 8b 04 24          	mov    (%rsp),%rax
  67ede4:	48 8b 98 e0 09 00 00 	mov    0x9e0(%rax),%rbx
  67edeb:	48 85 db             	test   %rbx,%rbx
  67edee:	0f 84 0c 01 00 00    	je     67ef00 <<gpui_canvas::text::planner::Planner>::shape+0xe10>
  67edf4:	4c 8b a0 d8 09 00 00 	mov    0x9d8(%rax),%r12
  67edfb:	45 31 f6             	xor    %r14d,%r14d
  67edfe:	45 31 ed             	xor    %r13d,%r13d
  67ee01:	eb 19                	jmp    67ee1c <<gpui_canvas::text::planner::Planner>::shape+0xd2c>
  67ee03:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  67ee0a:	84 00 00 00 00 00 
  67ee10:	49 ff c6             	inc    %r14
  67ee13:	49 39 de             	cmp    %rbx,%r14
  67ee16:	0f 84 e7 00 00 00    	je     67ef03 <<gpui_canvas::text::planner::Planner>::shape+0xe13>
  67ee1c:	49 6b c6 70          	imul   $0x70,%r14,%rax
  67ee20:	4c 01 e0             	add    %r12,%rax
  67ee23:	4c 89 ac 24 00 07 00 	mov    %r13,0x700(%rsp)
  67ee2a:	00 
  67ee2b:	48 c7 84 24 08 07 00 	movq   $0x0,0x708(%rsp)
  67ee32:	00 00 00 00 00 
  67ee37:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  67ee3c:	48 89 8c 24 10 07 00 	mov    %rcx,0x710(%rsp)
  67ee43:	00 
  67ee44:	48 89 84 24 18 07 00 	mov    %rax,0x718(%rsp)
  67ee4b:	00 
  67ee4c:	44 89 b4 24 20 07 00 	mov    %r14d,0x720(%rsp)
  67ee53:	00 
  67ee54:	c6 84 24 c8 07 00 00 	movb   $0x2,0x7c8(%rsp)
  67ee5b:	02 
  67ee5c:	c7 84 24 d0 07 00 00 	movl   $0x0,0x7d0(%rsp)
  67ee63:	00 00 00 00 
  67ee67:	48 8d bc 24 a0 02 00 	lea    0x2a0(%rsp),%rdi
  67ee6e:	00 
  67ee6f:	48 8d b4 24 08 07 00 	lea    0x708(%rsp),%rsi
  67ee76:	00 
  67ee77:	e8 24 b4 fe ff       	call   66a2a0 <<parley::layout::line::GlyphRunIter<()> as core::iter::traits::iterator::Iterator>::next>
  67ee7c:	83 bc 24 a0 02 00 00 	cmpl   $0x1,0x2a0(%rsp)
  67ee83:	01 
  67ee84:	75 8a                	jne    67ee10 <<gpui_canvas::text::planner::Planner>::shape+0xd20>
  67ee86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  67ee8d:	00 00 00 
  67ee90:	49 8b 47 38          	mov    0x38(%r15),%rax
  67ee94:	48 89 45 40          	mov    %rax,0x40(%rbp)
  67ee98:	41 0f 10 47 f8       	movups -0x8(%r15),%xmm0
  67ee9d:	41 0f 10 4f 08       	movups 0x8(%r15),%xmm1
  67eea2:	41 0f 10 57 18       	movups 0x18(%r15),%xmm2
  67eea7:	41 0f 10 5f 28       	movups 0x28(%r15),%xmm3
  67eeac:	0f 11 5d 30          	movups %xmm3,0x30(%rbp)
  67eeb0:	0f 11 55 20          	movups %xmm2,0x20(%rbp)
  67eeb4:	0f 11 4d 10          	movups %xmm1,0x10(%rbp)
  67eeb8:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
  67eebc:	4c 89 ac 24 b0 04 00 	mov    %r13,0x4b0(%rsp)
  67eec3:	00 
  67eec4:	4c 89 ee             	mov    %r13,%rsi
  67eec7:	48 89 ea             	mov    %rbp,%rdx
  67eeca:	e8 71 81 fe ff       	call   667040 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut>
  67eecf:	49 89 c5             	mov    %rax,%r13
  67eed2:	48 8d bc 24 a0 02 00 	lea    0x2a0(%rsp),%rdi
  67eed9:	00 
  67eeda:	48 8d b4 24 08 07 00 	lea    0x708(%rsp),%rsi
  67eee1:	00 
  67eee2:	e8 b9 b3 fe ff       	call   66a2a0 <<parley::layout::line::GlyphRunIter<()> as core::iter::traits::iterator::Iterator>::next>
  67eee7:	80 bc 24 a0 02 00 00 	cmpb   $0x0,0x2a0(%rsp)
  67eeee:	00 
  67eeef:	75 9f                	jne    67ee90 <<gpui_canvas::text::planner::Planner>::shape+0xda0>
  67eef1:	e9 1a ff ff ff       	jmp    67ee10 <<gpui_canvas::text::planner::Planner>::shape+0xd20>
  67eef6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  67eefd:	00 00 00 
  67ef00:	45 31 ed             	xor    %r13d,%r13d
  67ef03:	48 8b b4 24 f8 00 00 	mov    0xf8(%rsp),%rsi
  67ef0a:	00 
  67ef0b:	48 89 f0             	mov    %rsi,%rax
  67ef0e:	4c 01 e8             	add    %r13,%rax
  67ef11:	0f 92 c1             	setb   %cl
  67ef14:	48 3d 01 80 00 00    	cmp    $0x8001,%rax
  67ef1a:	0f 93 c0             	setae  %al
  67ef1d:	08 c8                	or     %cl,%al
  67ef1f:	0f 85 ee 1d 00 00    	jne    680d13 <<gpui_canvas::text::planner::Planner>::shape+0x2c23>
  67ef25:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  67ef2c:	00 
  67ef2d:	48 3b 44 24 40       	cmp    0x40(%rsp),%rax
  67ef32:	74 14                	je     67ef48 <<gpui_canvas::text::planner::Planner>::shape+0xe58>
  67ef34:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  67ef3b:	00 
  67ef3c:	48 29 f0             	sub    %rsi,%rax
  67ef3f:	49 39 c5             	cmp    %rax,%r13
  67ef42:	0f 87 ab 1d 00 00    	ja     680cf3 <<gpui_canvas::text::planner::Planner>::shape+0x2c03>
  67ef48:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  67ef4d:	48 85 d2             	test   %rdx,%rdx
  67ef50:	48 8b 9c 24 90 01 00 	mov    0x190(%rsp),%rbx
  67ef57:	00 
  67ef58:	74 26                	je     67ef80 <<gpui_canvas::text::planner::Planner>::shape+0xe90>
  67ef5a:	0f 57 c0             	xorps  %xmm0,%xmm0
  67ef5d:	f3 0f 11 84 24 d8 00 	movss  %xmm0,0xd8(%rsp)
  67ef64:	00 00 
  67ef66:	48 39 d3             	cmp    %rdx,%rbx
  67ef69:	75 4b                	jne    67efb6 <<gpui_canvas::text::planner::Planner>::shape+0xec6>
  67ef6b:	48 8b 0c 24          	mov    (%rsp),%rcx
  67ef6f:	48 8b 81 e0 09 00 00 	mov    0x9e0(%rcx),%rax
  67ef76:	48 85 c0             	test   %rax,%rax
  67ef79:	75 7c                	jne    67eff7 <<gpui_canvas::text::planner::Planner>::shape+0xf07>
  67ef7b:	e9 d6 14 00 00       	jmp    680456 <<gpui_canvas::text::planner::Planner>::shape+0x2366>
  67ef80:	48 8b 04 24          	mov    (%rsp),%rax
  67ef84:	48 83 b8 e0 09 00 00 	cmpq   $0x0,0x9e0(%rax)
  67ef8b:	00 
  67ef8c:	74 0e                	je     67ef9c <<gpui_canvas::text::planner::Planner>::shape+0xeac>
  67ef8e:	48 8b 80 d8 09 00 00 	mov    0x9d8(%rax),%rax
  67ef95:	f3 0f 10 40 24       	movss  0x24(%rax),%xmm0
  67ef9a:	eb 03                	jmp    67ef9f <<gpui_canvas::text::planner::Planner>::shape+0xeaf>
  67ef9c:	0f 57 c0             	xorps  %xmm0,%xmm0
  67ef9f:	f3 0f 11 44 24 6c    	movss  %xmm0,0x6c(%rsp)
  67efa5:	0f 57 c0             	xorps  %xmm0,%xmm0
  67efa8:	f3 0f 11 84 24 d8 00 	movss  %xmm0,0xd8(%rsp)
  67efaf:	00 00 
  67efb1:	48 39 d3             	cmp    %rdx,%rbx
  67efb4:	74 b5                	je     67ef6b <<gpui_canvas::text::planner::Planner>::shape+0xe7b>
  67efb6:	83 bc 24 b8 01 00 00 	cmpl   $0x0,0x1b8(%rsp)
  67efbd:	00 
  67efbe:	74 0e                	je     67efce <<gpui_canvas::text::planner::Planner>::shape+0xede>
  67efc0:	48 8b 04 24          	mov    (%rsp),%rax
  67efc4:	f3 0f 10 80 28 0a 00 	movss  0xa28(%rax),%xmm0
  67efcb:	00 
  67efcc:	eb 0c                	jmp    67efda <<gpui_canvas::text::planner::Planner>::shape+0xeea>
  67efce:	48 8b 04 24          	mov    (%rsp),%rax
  67efd2:	f3 0f 10 80 2c 0a 00 	movss  0xa2c(%rax),%xmm0
  67efd9:	00 
  67efda:	f3 0f 11 84 24 d8 00 	movss  %xmm0,0xd8(%rsp)
  67efe1:	00 00 
  67efe3:	48 8b 0c 24          	mov    (%rsp),%rcx
  67efe7:	48 8b 81 e0 09 00 00 	mov    0x9e0(%rcx),%rax
  67efee:	48 85 c0             	test   %rax,%rax
  67eff1:	0f 84 5f 14 00 00    	je     680456 <<gpui_canvas::text::planner::Planner>::shape+0x2366>
  67eff7:	48 8b 89 d8 09 00 00 	mov    0x9d8(%rcx),%rcx
  67effe:	48 6b c0 70          	imul   $0x70,%rax,%rax
  67f002:	48 89 8c 24 d0 00 00 	mov    %rcx,0xd0(%rsp)
  67f009:	00 
  67f00a:	48 01 c8             	add    %rcx,%rax
  67f00d:	48 89 84 24 98 03 00 	mov    %rax,0x398(%rsp)
  67f014:	00 
  67f015:	c7 44 24 70 00 00 00 	movl   $0x0,0x70(%rsp)
  67f01c:	00 
  67f01d:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  67f024:	00 ff 
  67f026:	74 2e                	je     67f056 <<gpui_canvas::text::planner::Planner>::shape+0xf66>
  67f028:	48 39 d3             	cmp    %rdx,%rbx
  67f02b:	75 3c                	jne    67f069 <<gpui_canvas::text::planner::Planner>::shape+0xf79>
  67f02d:	45 31 ed             	xor    %r13d,%r13d
  67f030:	45 31 f6             	xor    %r14d,%r14d
  67f033:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  67f03a:	00 
  67f03b:	4c 8b a4 24 68 01 00 	mov    0x168(%rsp),%r12
  67f042:	00 
  67f043:	80 78 68 02          	cmpb   $0x2,0x68(%rax)
  67f047:	4c 89 a4 24 58 02 00 	mov    %r12,0x258(%rsp)
  67f04e:	00 
  67f04f:	74 41                	je     67f092 <<gpui_canvas::text::planner::Planner>::shape+0xfa2>
  67f051:	e9 c6 01 00 00       	jmp    67f21c <<gpui_canvas::text::planner::Planner>::shape+0x112c>
  67f056:	8b 4c 24 70          	mov    0x70(%rsp),%ecx
  67f05a:	89 c8                	mov    %ecx,%eax
  67f05c:	48 89 84 24 58 02 00 	mov    %rax,0x258(%rsp)
  67f063:	00 
  67f064:	e9 c9 03 00 00       	jmp    67f432 <<gpui_canvas::text::planner::Planner>::shape+0x1342>
  67f069:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  67f070:	00 
  67f071:	4c 8b 30             	mov    (%rax),%r14
  67f074:	4c 8b 68 08          	mov    0x8(%rax),%r13
  67f078:	4c 8b a4 24 68 01 00 	mov    0x168(%rsp),%r12
  67f07f:	00 
  67f080:	80 78 68 02          	cmpb   $0x2,0x68(%rax)
  67f084:	4c 89 a4 24 58 02 00 	mov    %r12,0x258(%rsp)
  67f08b:	00 
  67f08c:	0f 85 8a 01 00 00    	jne    67f21c <<gpui_canvas::text::planner::Planner>::shape+0x112c>
  67f092:	48 8b 78 10          	mov    0x10(%rax),%rdi
  67f096:	48 8b 70 18          	mov    0x18(%rax),%rsi
  67f09a:	48 8b 04 24          	mov    (%rsp),%rax
  67f09e:	48 8b 90 f8 09 00 00 	mov    0x9f8(%rax),%rdx
  67f0a5:	48 39 fe             	cmp    %rdi,%rsi
  67f0a8:	0f 82 00 26 00 00    	jb     6816ae <<gpui_canvas::text::planner::Planner>::shape+0x35be>
  67f0ae:	48 39 d6             	cmp    %rdx,%rsi
  67f0b1:	0f 87 f7 25 00 00    	ja     6816ae <<gpui_canvas::text::planner::Planner>::shape+0x35be>
  67f0b7:	48 8b 04 24          	mov    (%rsp),%rax
  67f0bb:	48 8b 80 f0 09 00 00 	mov    0x9f0(%rax),%rax
  67f0c2:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  67f0c6:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
  67f0ca:	48 8d 14 b6          	lea    (%rsi,%rsi,4),%rdx
  67f0ce:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
  67f0d2:	48 89 8c 24 b0 04 00 	mov    %rcx,0x4b0(%rsp)
  67f0d9:	00 
  67f0da:	48 89 84 24 b8 04 00 	mov    %rax,0x4b8(%rsp)
  67f0e1:	00 
  67f0e2:	48 c7 84 24 c0 04 00 	movq   $0x0,0x4c0(%rsp)
  67f0e9:	00 00 00 00 00 
  67f0ee:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  67f0f3:	48 89 84 24 c8 04 00 	mov    %rax,0x4c8(%rsp)
  67f0fa:	00 
  67f0fb:	8b 44 24 70          	mov    0x70(%rsp),%eax
  67f0ff:	89 84 24 d0 04 00 00 	mov    %eax,0x4d0(%rsp)
  67f106:	c6 84 24 f0 06 00 00 	movb   $0x2,0x6f0(%rsp)
  67f10d:	02 
  67f10e:	48 8d 84 24 f8 06 00 	lea    0x6f8(%rsp),%rax
  67f115:	00 
  67f116:	48 89 84 24 a0 02 00 	mov    %rax,0x2a0(%rsp)
  67f11d:	00 
  67f11e:	c6 84 24 e0 05 00 00 	movb   $0x2,0x5e0(%rsp)
  67f125:	02 
  67f126:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  67f12d:	00 
  67f12e:	48 8d b4 24 b0 04 00 	lea    0x4b0(%rsp),%rsi
  67f135:	00 
  67f136:	48 8d 94 24 a0 02 00 	lea    0x2a0(%rsp),%rdx
  67f13d:	00 
  67f13e:	48 8d 8c 24 d8 04 00 	lea    0x4d8(%rsp),%rcx
  67f145:	00 
  67f146:	e8 f5 5d fe ff       	call   664f40 <<core::iter::adapters::map::Map<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>, gpui_canvas::text::planner::freeze_line::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::flatten::FlattenCompat<_, _>>::iter_try_fold::flatten<parley::layout::run::Clusters<()>, (), core::ops::control_flow::ControlFlow<parley::layout::cluster::Cluster<()>>, <core::iter::adapters::flatten::FlattenCompat<_, _> as core::iter::traits::iterator::Iterator>::try_fold::flatten<parley::layout::run::Clusters<()>, (), core::ops::control_flow::ControlFlow<parley::layout::cluster::Cluster<()>>, core::iter::traits::iterator::Iterator::find::check<parley::layout::cluster::Cluster<()>, &mut gpui_canvas::text::planner::freeze_line::{closure#1}>::{closure#0}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<parley::layout::cluster::Cluster<()>>>>
  67f14b:	48 8b 8c 24 00 07 00 	mov    0x700(%rsp),%rcx
  67f152:	00 
  67f153:	48 85 c9             	test   %rcx,%rcx
  67f156:	0f 84 ae 00 00 00    	je     67f20a <<gpui_canvas::text::planner::Planner>::shape+0x111a>
  67f15c:	8b bc 24 28 07 00 00 	mov    0x728(%rsp),%edi
  67f163:	8b b4 24 80 07 00 00 	mov    0x780(%rsp),%esi
  67f16a:	8b 94 24 84 07 00 00 	mov    0x784(%rsp),%edx
  67f171:	48 8b 41 58          	mov    0x58(%rcx),%rax
  67f175:	48 39 f8             	cmp    %rdi,%rax
  67f178:	0f 86 49 26 00 00    	jbe    6817c7 <<gpui_canvas::text::planner::Planner>::shape+0x36d7>
  67f17e:	48 8b 41 50          	mov    0x50(%rcx),%rax
  67f182:	48 8d 3c ff          	lea    (%rdi,%rdi,8),%rdi
  67f186:	48 c1 e7 04          	shl    $0x4,%rdi
  67f18a:	0f 10 41 68          	movups 0x68(%rcx),%xmm0
  67f18e:	0f 10 89 80 00 00 00 	movups 0x80(%rcx),%xmm1
  67f195:	0f 10 91 98 00 00 00 	movups 0x98(%rcx),%xmm2
  67f19c:	0f 11 84 24 00 07 00 	movups %xmm0,0x700(%rsp)
  67f1a3:	00 
  67f1a4:	0f 11 8c 24 10 07 00 	movups %xmm1,0x710(%rsp)
  67f1ab:	00 
  67f1ac:	0f 11 94 24 20 07 00 	movups %xmm2,0x720(%rsp)
  67f1b3:	00 
  67f1b4:	48 8b 44 38 50       	mov    0x50(%rax,%rdi,1),%rax
  67f1b9:	48 89 84 24 30 07 00 	mov    %rax,0x730(%rsp)
  67f1c0:	00 
  67f1c1:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  67f1c8:	00 
  67f1c9:	ff 15 d1 7f 10 00    	call   *0x107fd1(%rip)        # 7871a0 <_DYNAMIC+0x518>
  67f1cf:	48 89 c3             	mov    %rax,%rbx
  67f1d2:	ba 48 02 00 00       	mov    $0x248,%edx
  67f1d7:	4d 89 f4             	mov    %r14,%r12
  67f1da:	4c 8d b4 24 00 07 00 	lea    0x700(%rsp),%r14
  67f1e1:	00 
  67f1e2:	4c 89 f7             	mov    %r14,%rdi
  67f1e5:	48 8d b4 24 b0 04 00 	lea    0x4b0(%rsp),%rsi
  67f1ec:	00 
  67f1ed:	ff 15 65 7d 10 00    	call   *0x107d65(%rip)        # 786f58 <memcpy@GLIBC_2.14>
  67f1f3:	4c 89 f7             	mov    %r14,%rdi
  67f1f6:	4d 89 e6             	mov    %r12,%r14
  67f1f9:	48 89 de             	mov    %rbx,%rsi
  67f1fc:	e8 df 5f fe ff       	call   6651e0 <<core::iter::adapters::map::Map<core::iter::adapters::filter::Filter<core::iter::adapters::flatten::FlatMap<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>, parley::layout::run::Clusters<()>, gpui_canvas::text::planner::freeze_line::{closure#0}>, gpui_canvas::text::planner::freeze_line::{closure#1}>, gpui_canvas::text::planner::freeze_line::{closure#2}> as core::iter::traits::iterator::Iterator>::fold::<usize, core::iter::traits::iterator::Iterator::min_by::fold<usize, <usize as core::cmp::Ord>::cmp>::{closure#0}>>
  67f201:	4c 39 e8             	cmp    %r13,%rax
  67f204:	4c 0f 42 e8          	cmovb  %rax,%r13
  67f208:	eb 12                	jmp    67f21c <<gpui_canvas::text::planner::Planner>::shape+0x112c>
  67f20a:	80 bc 24 f0 06 00 00 	cmpb   $0x2,0x6f0(%rsp)
  67f211:	02 
  67f212:	c6 84 24 e0 05 00 00 	movb   $0x2,0x5e0(%rsp)
  67f219:	02 
  67f21a:	75 34                	jne    67f250 <<gpui_canvas::text::planner::Planner>::shape+0x1160>
  67f21c:	4d 39 ee             	cmp    %r13,%r14
  67f21f:	0f 87 69 1e 00 00    	ja     68108e <<gpui_canvas::text::planner::Planner>::shape+0x2f9e>
  67f225:	4d 85 f6             	test   %r14,%r14
  67f228:	0f 84 9e 00 00 00    	je     67f2cc <<gpui_canvas::text::planner::Planner>::shape+0x11dc>
  67f22e:	4c 3b 74 24 08       	cmp    0x8(%rsp),%r14
  67f233:	0f 83 8d 00 00 00    	jae    67f2c6 <<gpui_canvas::text::planner::Planner>::shape+0x11d6>
  67f239:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67f23e:	42 80 3c 30 bf       	cmpb   $0xbf,(%rax,%r14,1)
  67f243:	0f 8f 83 00 00 00    	jg     67f2cc <<gpui_canvas::text::planner::Planner>::shape+0x11dc>
  67f249:	e9 40 1e 00 00       	jmp    68108e <<gpui_canvas::text::planner::Planner>::shape+0x2f9e>
  67f24e:	66 90                	xchg   %ax,%ax
  67f250:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  67f257:	00 
  67f258:	48 8d b4 24 e8 05 00 	lea    0x5e8(%rsp),%rsi
  67f25f:	00 
  67f260:	e8 4b 82 fe ff       	call   6674b0 <<parley::layout::run::Clusters<()> as core::iter::traits::iterator::Iterator>::next>
  67f265:	48 8b 8c 24 00 07 00 	mov    0x700(%rsp),%rcx
  67f26c:	00 
  67f26d:	48 85 c9             	test   %rcx,%rcx
  67f270:	74 aa                	je     67f21c <<gpui_canvas::text::planner::Planner>::shape+0x112c>
  67f272:	8b bc 24 28 07 00 00 	mov    0x728(%rsp),%edi
  67f279:	48 8b 41 58          	mov    0x58(%rcx),%rax
  67f27d:	48 39 f8             	cmp    %rdi,%rax
  67f280:	0f 86 be 24 00 00    	jbe    681744 <<gpui_canvas::text::planner::Planner>::shape+0x3654>
  67f286:	8b b4 24 80 07 00 00 	mov    0x780(%rsp),%esi
  67f28d:	8b 94 24 84 07 00 00 	mov    0x784(%rsp),%edx
  67f294:	4c 8b 41 70          	mov    0x70(%rcx),%r8
  67f298:	39 f2                	cmp    %esi,%edx
  67f29a:	0f 82 ab 23 00 00    	jb     68164b <<gpui_canvas::text::planner::Planner>::shape+0x355b>
  67f2a0:	49 39 d0             	cmp    %rdx,%r8
  67f2a3:	0f 82 a2 23 00 00    	jb     68164b <<gpui_canvas::text::planner::Planner>::shape+0x355b>
  67f2a9:	39 f2                	cmp    %esi,%edx
  67f2ab:	0f 84 a4 24 00 00    	je     681755 <<gpui_canvas::text::planner::Planner>::shape+0x3665>
  67f2b1:	4c 8b 41 68          	mov    0x68(%rcx),%r8
  67f2b5:	4c 8d 0c 76          	lea    (%rsi,%rsi,2),%r9
  67f2b9:	43 80 7c 88 07 06    	cmpb   $0x6,0x7(%r8,%r9,4)
  67f2bf:	75 8f                	jne    67f250 <<gpui_canvas::text::planner::Planner>::shape+0x1160>
  67f2c1:	e9 af fe ff ff       	jmp    67f175 <<gpui_canvas::text::planner::Planner>::shape+0x1085>
  67f2c6:	0f 85 c2 1d 00 00    	jne    68108e <<gpui_canvas::text::planner::Planner>::shape+0x2f9e>
  67f2cc:	4d 85 ed             	test   %r13,%r13
  67f2cf:	74 1e                	je     67f2ef <<gpui_canvas::text::planner::Planner>::shape+0x11ff>
  67f2d1:	4c 3b 6c 24 08       	cmp    0x8(%rsp),%r13
  67f2d6:	73 11                	jae    67f2e9 <<gpui_canvas::text::planner::Planner>::shape+0x11f9>
  67f2d8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67f2dd:	42 80 3c 28 c0       	cmpb   $0xc0,(%rax,%r13,1)
  67f2e2:	7d 0b                	jge    67f2ef <<gpui_canvas::text::planner::Planner>::shape+0x11ff>
  67f2e4:	e9 a5 1d 00 00       	jmp    68108e <<gpui_canvas::text::planner::Planner>::shape+0x2f9e>
  67f2e9:	0f 85 9f 1d 00 00    	jne    68108e <<gpui_canvas::text::planner::Planner>::shape+0x2f9e>
  67f2ef:	0f 57 c0             	xorps  %xmm0,%xmm0
  67f2f2:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  67f2f9:	00 
  67f2fa:	48 3b 44 24 40       	cmp    0x40(%rsp),%rax
  67f2ff:	74 0d                	je     67f30e <<gpui_canvas::text::planner::Planner>::shape+0x121e>
  67f301:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  67f308:	00 
  67f309:	f3 0f 10 40 30       	movss  0x30(%rax),%xmm0
  67f30e:	f3 0f 11 44 24 30    	movss  %xmm0,0x30(%rsp)
  67f314:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  67f31b:	00 
  67f31c:	f3 0f 10 48 40       	movss  0x40(%rax),%xmm1
  67f321:	f3 0f 10 40 44       	movss  0x44(%rax),%xmm0
  67f326:	0f 29 8c 24 10 01 00 	movaps %xmm1,0x110(%rsp)
  67f32d:	00 
  67f32e:	f3 0f 5d 48 48       	minss  0x48(%rax),%xmm1
  67f333:	0f 29 8c 24 90 02 00 	movaps %xmm1,0x290(%rsp)
  67f33a:	00 
  67f33b:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  67f342:	00 
  67f343:	f3 0f 5f 40 4c       	maxss  0x4c(%rax),%xmm0
  67f348:	0f 29 84 24 f0 01 00 	movaps %xmm0,0x1f0(%rsp)
  67f34f:	00 
  67f350:	f3 0f 10 40 24       	movss  0x24(%rax),%xmm0
  67f355:	f3 0f 58 44 24 24    	addss  0x24(%rsp),%xmm0
  67f35b:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  67f362:	00 00 
  67f364:	48 8b 9c 24 68 01 00 	mov    0x168(%rsp),%rbx
  67f36b:	00 
  67f36c:	48 3b 9c 24 58 01 00 	cmp    0x158(%rsp),%rbx
  67f373:	00 
  67f374:	75 0e                	jne    67f384 <<gpui_canvas::text::planner::Planner>::shape+0x1294>
  67f376:	48 8d bc 24 58 01 00 	lea    0x158(%rsp),%rdi
  67f37d:	00 
  67f37e:	ff 15 a4 7d 10 00    	call   *0x107da4(%rip)        # 787128 <_DYNAMIC+0x4a0>
  67f384:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  67f389:	41 01 c6             	add    %eax,%r14d
  67f38c:	41 01 c5             	add    %eax,%r13d
  67f38f:	0f 28 94 24 90 02 00 	movaps 0x290(%rsp),%xmm2
  67f396:	00 
  67f397:	0f 28 c2             	movaps %xmm2,%xmm0
  67f39a:	f3 0f c2 c2 03       	cmpunordss %xmm2,%xmm0
  67f39f:	0f 28 c8             	movaps %xmm0,%xmm1
  67f3a2:	0f 55 ca             	andnps %xmm2,%xmm1
  67f3a5:	0f 54 84 24 10 01 00 	andps  0x110(%rsp),%xmm0
  67f3ac:	00 
  67f3ad:	0f 56 c1             	orps   %xmm1,%xmm0
  67f3b0:	f3 0f 10 4c 24 24    	movss  0x24(%rsp),%xmm1
  67f3b6:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  67f3ba:	0f 28 a4 24 f0 01 00 	movaps 0x1f0(%rsp),%xmm4
  67f3c1:	00 
  67f3c2:	0f 28 d4             	movaps %xmm4,%xmm2
  67f3c5:	f3 0f c2 d4 03       	cmpunordss %xmm4,%xmm2
  67f3ca:	0f 28 da             	movaps %xmm2,%xmm3
  67f3cd:	0f 55 dc             	andnps %xmm4,%xmm3
  67f3d0:	0f 54 94 24 00 01 00 	andps  0x100(%rsp),%xmm2
  67f3d7:	00 
  67f3d8:	0f 56 d3             	orps   %xmm3,%xmm2
  67f3db:	f3 0f 5c d0          	subss  %xmm0,%xmm2
  67f3df:	48 8b 84 24 60 01 00 	mov    0x160(%rsp),%rax
  67f3e6:	00 
  67f3e7:	48 8d 0c 5b          	lea    (%rbx,%rbx,2),%rcx
  67f3eb:	44 89 34 c8          	mov    %r14d,(%rax,%rcx,8)
  67f3ef:	44 89 6c c8 04       	mov    %r13d,0x4(%rax,%rcx,8)
  67f3f4:	f3 0f 11 4c c8 08    	movss  %xmm1,0x8(%rax,%rcx,8)
  67f3fa:	f3 0f 11 54 c8 0c    	movss  %xmm2,0xc(%rax,%rcx,8)
  67f400:	f3 0f 10 84 24 80 00 	movss  0x80(%rsp),%xmm0
  67f407:	00 00 
  67f409:	f3 0f 11 44 c8 10    	movss  %xmm0,0x10(%rax,%rcx,8)
  67f40f:	f3 0f 10 44 24 30    	movss  0x30(%rsp),%xmm0
  67f415:	f3 0f 11 44 c8 14    	movss  %xmm0,0x14(%rax,%rcx,8)
  67f41b:	48 ff c3             	inc    %rbx
  67f41e:	48 89 9c 24 68 01 00 	mov    %rbx,0x168(%rsp)
  67f425:	00 
  67f426:	44 89 ac 24 18 02 00 	mov    %r13d,0x218(%rsp)
  67f42d:	00 
  67f42e:	8b 4c 24 70          	mov    0x70(%rsp),%ecx
  67f432:	48 c7 84 24 00 07 00 	movq   $0x0,0x700(%rsp)
  67f439:	00 00 00 00 00 
  67f43e:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  67f443:	48 89 84 24 08 07 00 	mov    %rax,0x708(%rsp)
  67f44a:	00 
  67f44b:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  67f452:	00 
  67f453:	48 89 84 24 10 07 00 	mov    %rax,0x710(%rsp)
  67f45a:	00 
  67f45b:	48 83 c0 70          	add    $0x70,%rax
  67f45f:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  67f466:	00 
  67f467:	89 8c 24 18 07 00 00 	mov    %ecx,0x718(%rsp)
  67f46e:	ff c1                	inc    %ecx
  67f470:	89 4c 24 70          	mov    %ecx,0x70(%rsp)
  67f474:	c6 84 24 c0 07 00 00 	movb   $0x2,0x7c0(%rsp)
  67f47b:	02 
  67f47c:	c7 84 24 c8 07 00 00 	movl   $0x0,0x7c8(%rsp)
  67f483:	00 00 00 00 
  67f487:	48 8d bc 24 a0 02 00 	lea    0x2a0(%rsp),%rdi
  67f48e:	00 
  67f48f:	48 8d b4 24 00 07 00 	lea    0x700(%rsp),%rsi
  67f496:	00 
  67f497:	e8 04 ae fe ff       	call   66a2a0 <<parley::layout::line::GlyphRunIter<()> as core::iter::traits::iterator::Iterator>::next>
  67f49c:	83 bc 24 a0 02 00 00 	cmpl   $0x1,0x2a0(%rsp)
  67f4a3:	01 
  67f4a4:	0f 85 89 0f 00 00    	jne    680433 <<gpui_canvas::text::planner::Planner>::shape+0x2343>
  67f4aa:	48 8b 84 24 a8 02 00 	mov    0x2a8(%rsp),%rax
  67f4b1:	00 
  67f4b2:	48 85 c0             	test   %rax,%rax
  67f4b5:	0f 84 c3 1b 00 00    	je     68107e <<gpui_canvas::text::planner::Planner>::shape+0x2f8e>
  67f4bb:	48 89 84 24 f0 02 00 	mov    %rax,0x2f0(%rsp)
  67f4c2:	00 
  67f4c3:	41 0f 10 07          	movups (%r15),%xmm0
  67f4c7:	41 0f 10 4f 10       	movups 0x10(%r15),%xmm1
  67f4cc:	41 0f 10 57 20       	movups 0x20(%r15),%xmm2
  67f4d1:	41 0f 10 5f 30       	movups 0x30(%r15),%xmm3
  67f4d6:	48 8d 8c 24 f8 02 00 	lea    0x2f8(%rsp),%rcx
  67f4dd:	00 
  67f4de:	0f 11 59 30          	movups %xmm3,0x30(%rcx)
  67f4e2:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  67f4e6:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  67f4ea:	0f 11 01             	movups %xmm0,(%rcx)
  67f4ed:	4c 8b 9c 24 f8 02 00 	mov    0x2f8(%rsp),%r11
  67f4f4:	00 
  67f4f5:	49 8b 4b 30          	mov    0x30(%r11),%rcx
  67f4f9:	49 8b 73 38          	mov    0x38(%r11),%rsi
  67f4fd:	48 89 f2             	mov    %rsi,%rdx
  67f500:	48 29 ca             	sub    %rcx,%rdx
  67f503:	40 0f 92 c7          	setb   %dil
  67f507:	48 3b b0 d0 00 00 00 	cmp    0xd0(%rax),%rsi
  67f50e:	40 0f 97 c6          	seta   %sil
  67f512:	48 01 c9             	add    %rcx,%rcx
  67f515:	48 03 88 c8 00 00 00 	add    0xc8(%rax),%rcx
  67f51c:	40 08 fe             	or     %dil,%sil
  67f51f:	40 84 f6             	test   %sil,%sil
  67f522:	be 00 00 00 00       	mov    $0x0,%esi
  67f527:	48 0f 45 d6          	cmovne %rsi,%rdx
  67f52b:	be 02 00 00 00       	mov    $0x2,%esi
  67f530:	48 0f 45 ce          	cmovne %rsi,%rcx
  67f534:	48 01 d2             	add    %rdx,%rdx
  67f537:	31 f6                	xor    %esi,%esi
  67f539:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  67f540:	48 39 f2             	cmp    %rsi,%rdx
  67f543:	74 10                	je     67f555 <<gpui_canvas::text::planner::Planner>::shape+0x1465>
  67f545:	66 83 3c 31 00       	cmpw   $0x0,(%rcx,%rsi,1)
  67f54a:	48 8d 76 02          	lea    0x2(%rsi),%rsi
  67f54e:	74 f0                	je     67f540 <<gpui_canvas::text::planner::Planner>::shape+0x1450>
  67f550:	e9 cb 17 00 00       	jmp    680d20 <<gpui_canvas::text::planner::Planner>::shape+0x2c30>
  67f555:	49 8b 4b 40          	mov    0x40(%r11),%rcx
  67f559:	48 3b 88 b8 00 00 00 	cmp    0xb8(%rax),%rcx
  67f560:	0f 83 5a 21 00 00    	jae    6816c0 <<gpui_canvas::text::planner::Planner>::shape+0x35d0>
  67f566:	48 c1 e1 06          	shl    $0x6,%rcx
  67f56a:	48 03 88 b0 00 00 00 	add    0xb0(%rax),%rcx
  67f571:	48 8b 34 24          	mov    (%rsp),%rsi
  67f575:	83 3e 01             	cmpl   $0x1,(%rsi)
  67f578:	75 0f                	jne    67f589 <<gpui_canvas::text::planner::Planner>::shape+0x1499>
  67f57a:	48 8b 56 08          	mov    0x8(%rsi),%rdx
  67f57e:	48 3b 51 10          	cmp    0x10(%rcx),%rdx
  67f582:	75 05                	jne    67f589 <<gpui_canvas::text::planner::Planner>::shape+0x1499>
  67f584:	45 31 f6             	xor    %r14d,%r14d
  67f587:	eb 4c                	jmp    67f5d5 <<gpui_canvas::text::planner::Planner>::shape+0x14e5>
  67f589:	83 7e 10 01          	cmpl   $0x1,0x10(%rsi)
  67f58d:	75 10                	jne    67f59f <<gpui_canvas::text::planner::Planner>::shape+0x14af>
  67f58f:	48 8b 56 18          	mov    0x18(%rsi),%rdx
  67f593:	41 be 01 00 00 00    	mov    $0x1,%r14d
  67f599:	48 3b 51 10          	cmp    0x10(%rcx),%rdx
  67f59d:	74 1e                	je     67f5bd <<gpui_canvas::text::planner::Planner>::shape+0x14cd>
  67f59f:	83 7e 20 01          	cmpl   $0x1,0x20(%rsi)
  67f5a3:	0f 85 61 1b 00 00    	jne    68110a <<gpui_canvas::text::planner::Planner>::shape+0x301a>
  67f5a9:	48 8b 56 28          	mov    0x28(%rsi),%rdx
  67f5ad:	41 be 02 00 00 00    	mov    $0x2,%r14d
  67f5b3:	48 3b 51 10          	cmp    0x10(%rcx),%rdx
  67f5b7:	0f 85 4d 1b 00 00    	jne    68110a <<gpui_canvas::text::planner::Planner>::shape+0x301a>
  67f5bd:	41 8d 4e ff          	lea    -0x1(%r14),%ecx
  67f5c1:	48 8b 94 24 08 02 00 	mov    0x208(%rsp),%rdx
  67f5c8:	00 
  67f5c9:	48 0f ab ca          	bts    %rcx,%rdx
  67f5cd:	48 89 94 24 08 02 00 	mov    %rdx,0x208(%rsp)
  67f5d4:	00 
  67f5d5:	8b bc 24 18 03 00 00 	mov    0x318(%rsp),%edi
  67f5dc:	48 8b 70 58          	mov    0x58(%rax),%rsi
  67f5e0:	48 39 fe             	cmp    %rdi,%rsi
  67f5e3:	0f 86 93 21 00 00    	jbe    68177c <<gpui_canvas::text::planner::Planner>::shape+0x368c>
  67f5e9:	48 8b 94 24 08 03 00 	mov    0x308(%rsp),%rdx
  67f5f0:	00 
  67f5f1:	48 85 d2             	test   %rdx,%rdx
  67f5f4:	48 89 94 24 80 03 00 	mov    %rdx,0x380(%rsp)
  67f5fb:	00 
  67f5fc:	74 0a                	je     67f608 <<gpui_canvas::text::planner::Planner>::shape+0x1518>
  67f5fe:	48 8d 4a 18          	lea    0x18(%rdx),%rcx
  67f602:	48 83 c2 1c          	add    $0x1c,%rdx
  67f606:	eb 1b                	jmp    67f623 <<gpui_canvas::text::planner::Planner>::shape+0x1533>
  67f608:	48 8b 48 50          	mov    0x50(%rax),%rcx
  67f60c:	48 8d 34 ff          	lea    (%rdi,%rdi,8),%rsi
  67f610:	48 c1 e6 04          	shl    $0x4,%rsi
  67f614:	48 8d 14 31          	lea    (%rcx,%rsi,1),%rdx
  67f618:	48 83 c2 54          	add    $0x54,%rdx
  67f61c:	48 01 f1             	add    %rsi,%rcx
  67f61f:	48 83 c1 50          	add    $0x50,%rcx
  67f623:	48 8b b4 24 f8 00 00 	mov    0xf8(%rsp),%rsi
  67f62a:	00 
  67f62b:	48 89 b4 24 88 03 00 	mov    %rsi,0x388(%rsp)
  67f632:	00 
  67f633:	48 8b 70 68          	mov    0x68(%rax),%rsi
  67f637:	48 8b 78 70          	mov    0x70(%rax),%rdi
  67f63b:	4c 8b 80 80 00 00 00 	mov    0x80(%rax),%r8
  67f642:	4c 8b 88 88 00 00 00 	mov    0x88(%rax),%r9
  67f649:	4c 8b 90 98 00 00 00 	mov    0x98(%rax),%r10
  67f650:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
  67f657:	8b 12                	mov    (%rdx),%edx
  67f659:	8b 09                	mov    (%rcx),%ecx
  67f65b:	4c 89 9c 24 40 02 00 	mov    %r11,0x240(%rsp)
  67f662:	00 
  67f663:	45 0f b6 9b 8c 00 00 	movzbl 0x8c(%r11),%r11d
  67f66a:	00 
  67f66b:	41 80 e3 01          	and    $0x1,%r11b
  67f66f:	89 d3                	mov    %edx,%ebx
  67f671:	29 cb                	sub    %ecx,%ebx
  67f673:	48 c7 84 24 b0 04 00 	movq   $0x0,0x4b0(%rsp)
  67f67a:	00 00 00 00 00 
  67f67f:	48 c7 84 24 d0 04 00 	movq   $0x0,0x4d0(%rsp)
  67f686:	00 00 00 00 00 
  67f68b:	c7 84 24 f0 04 00 00 	movl   $0x0,0x4f0(%rsp)
  67f692:	00 00 00 00 
  67f696:	89 9c 24 f4 04 00 00 	mov    %ebx,0x4f4(%rsp)
  67f69d:	48 89 b4 24 f8 04 00 	mov    %rsi,0x4f8(%rsp)
  67f6a4:	00 
  67f6a5:	48 89 bc 24 00 05 00 	mov    %rdi,0x500(%rsp)
  67f6ac:	00 
  67f6ad:	4c 89 84 24 08 05 00 	mov    %r8,0x508(%rsp)
  67f6b4:	00 
  67f6b5:	4c 89 8c 24 10 05 00 	mov    %r9,0x510(%rsp)
  67f6bc:	00 
  67f6bd:	4c 89 94 24 18 05 00 	mov    %r10,0x518(%rsp)
  67f6c4:	00 
  67f6c5:	48 89 84 24 20 05 00 	mov    %rax,0x520(%rsp)
  67f6cc:	00 
  67f6cd:	89 8c 24 28 05 00 00 	mov    %ecx,0x528(%rsp)
  67f6d4:	89 94 24 2c 05 00 00 	mov    %edx,0x52c(%rsp)
  67f6db:	89 8c 24 30 05 00 00 	mov    %ecx,0x530(%rsp)
  67f6e2:	89 94 24 34 05 00 00 	mov    %edx,0x534(%rsp)
  67f6e9:	44 88 9c 24 38 05 00 	mov    %r11b,0x538(%rsp)
  67f6f0:	00 
  67f6f1:	f2 0f 10 84 24 28 03 	movsd  0x328(%rsp),%xmm0
  67f6f8:	00 00 
  67f6fa:	0f 29 84 24 d0 03 00 	movaps %xmm0,0x3d0(%rsp)
  67f701:	00 
  67f702:	8b 94 24 20 03 00 00 	mov    0x320(%rsp),%edx
  67f709:	8b 8c 24 24 03 00 00 	mov    0x324(%rsp),%ecx
  67f710:	48 8d bc 24 e8 03 00 	lea    0x3e8(%rsp),%rdi
  67f717:	00 
  67f718:	48 8d b4 24 f0 02 00 	lea    0x2f0(%rsp),%rsi
  67f71f:	00 
  67f720:	e8 cb 70 fe ff       	call   6667f0 <<parley::layout::run::Run<()>>::glyphs_in>
  67f725:	0f 28 94 24 d0 03 00 	movaps 0x3d0(%rsp),%xmm2
  67f72c:	00 
  67f72d:	0f 13 94 24 80 04 00 	movlps %xmm2,0x480(%rsp)
  67f734:	00 
  67f735:	4c 8b ac 24 e8 03 00 	mov    0x3e8(%rsp),%r13
  67f73c:	00 
  67f73d:	48 8b 84 24 f0 03 00 	mov    0x3f0(%rsp),%rax
  67f744:	00 
  67f745:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  67f74c:	00 
  67f74d:	0f b6 84 24 f8 03 00 	movzbl 0x3f8(%rsp),%eax
  67f754:	00 
  67f755:	8b 8c 24 fc 03 00 00 	mov    0x3fc(%rsp),%ecx
  67f75c:	89 8c 24 ac 01 00 00 	mov    %ecx,0x1ac(%rsp)
  67f763:	f2 0f 10 84 24 00 04 	movsd  0x400(%rsp),%xmm0
  67f76a:	00 00 
  67f76c:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  67f773:	00 
  67f774:	f3 0f 10 84 24 08 04 	movss  0x408(%rsp),%xmm0
  67f77b:	00 00 
  67f77d:	f3 0f 11 84 24 a8 01 	movss  %xmm0,0x1a8(%rsp)
  67f784:	00 00 
  67f786:	48 8b 8c 24 10 04 00 	mov    0x410(%rsp),%rcx
  67f78d:	00 
  67f78e:	48 89 8c 24 68 02 00 	mov    %rcx,0x268(%rsp)
  67f795:	00 
  67f796:	48 8b 8c 24 18 04 00 	mov    0x418(%rsp),%rcx
  67f79d:	00 
  67f79e:	48 89 8c 24 00 02 00 	mov    %rcx,0x200(%rsp)
  67f7a5:	00 
  67f7a6:	48 8b 94 24 20 04 00 	mov    0x420(%rsp),%rdx
  67f7ad:	00 
  67f7ae:	48 8b 9c 24 28 04 00 	mov    0x428(%rsp),%rbx
  67f7b5:	00 
  67f7b6:	48 8b 8c 24 30 04 00 	mov    0x430(%rsp),%rcx
  67f7bd:	00 
  67f7be:	48 89 8c 24 78 02 00 	mov    %rcx,0x278(%rsp)
  67f7c5:	00 
  67f7c6:	48 8b 8c 24 38 04 00 	mov    0x438(%rsp),%rcx
  67f7cd:	00 
  67f7ce:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  67f7d5:	00 
  67f7d6:	8b 8c 24 40 04 00 00 	mov    0x440(%rsp),%ecx
  67f7dd:	48 89 8c 24 e8 01 00 	mov    %rcx,0x1e8(%rsp)
  67f7e4:	00 
  67f7e5:	8b 8c 24 44 04 00 00 	mov    0x444(%rsp),%ecx
  67f7ec:	48 89 8c 24 e0 01 00 	mov    %rcx,0x1e0(%rsp)
  67f7f3:	00 
  67f7f4:	8b 8c 24 48 04 00 00 	mov    0x448(%rsp),%ecx
  67f7fb:	48 89 8c 24 10 01 00 	mov    %rcx,0x110(%rsp)
  67f802:	00 
  67f803:	8b 8c 24 4c 04 00 00 	mov    0x44c(%rsp),%ecx
  67f80a:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  67f80f:	f3 0f 10 84 24 50 04 	movss  0x450(%rsp),%xmm0
  67f816:	00 00 
  67f818:	f3 0f 11 84 24 b0 01 	movss  %xmm0,0x1b0(%rsp)
  67f81f:	00 00 
  67f821:	f3 0f 10 84 24 54 04 	movss  0x454(%rsp),%xmm0
  67f828:	00 00 
  67f82a:	f3 0f 11 44 24 5c    	movss  %xmm0,0x5c(%rsp)
  67f830:	48 8b 8c 24 58 04 00 	mov    0x458(%rsp),%rcx
  67f837:	00 
  67f838:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
  67f83f:	00 
  67f840:	f3 0f 10 84 24 70 04 	movss  0x470(%rsp),%xmm0
  67f847:	00 00 
  67f849:	f3 0f 10 8c 24 6c 04 	movss  0x46c(%rsp),%xmm1
  67f850:	00 00 
  67f852:	f3 0f 11 84 24 28 02 	movss  %xmm0,0x228(%rsp)
  67f859:	00 00 
  67f85b:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  67f85f:	f3 0f 10 84 24 74 04 	movss  0x474(%rsp),%xmm0
  67f866:	00 00 
  67f868:	f3 0f 11 8c 24 24 02 	movss  %xmm1,0x224(%rsp)
  67f86f:	00 00 
  67f871:	f3 0f 58 c1          	addss  %xmm1,%xmm0
  67f875:	f3 0f 11 84 24 1c 02 	movss  %xmm0,0x21c(%rsp)
  67f87c:	00 00 
  67f87e:	0f 28 c2             	movaps %xmm2,%xmm0
  67f881:	0f b6 8c 24 7c 04 00 	movzbl 0x47c(%rsp),%ecx
  67f888:	00 
  67f889:	88 8c 24 90 02 00 00 	mov    %cl,0x290(%rsp)
  67f890:	48 8b 8c 24 60 04 00 	mov    0x460(%rsp),%rcx
  67f897:	00 
  67f898:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  67f89f:	00 
  67f8a0:	8b 8c 24 68 04 00 00 	mov    0x468(%rsp),%ecx
  67f8a7:	89 8c 24 e0 00 00 00 	mov    %ecx,0xe0(%rsp)
  67f8ae:	8b 8c 24 78 04 00 00 	mov    0x478(%rsp),%ecx
  67f8b5:	89 8c 24 20 02 00 00 	mov    %ecx,0x220(%rsp)
  67f8bc:	48 8d 4a 16          	lea    0x16(%rdx),%rcx
  67f8c0:	48 89 8c 24 50 02 00 	mov    %rcx,0x250(%rsp)
  67f8c7:	00 
  67f8c8:	48 89 94 24 f0 01 00 	mov    %rdx,0x1f0(%rsp)
  67f8cf:	00 
  67f8d0:	48 8d 4a 2e          	lea    0x2e(%rdx),%rcx
  67f8d4:	48 89 8c 24 90 03 00 	mov    %rcx,0x390(%rsp)
  67f8db:	00 
  67f8dc:	4c 89 b4 24 60 02 00 	mov    %r14,0x260(%rsp)
  67f8e3:	00 
  67f8e4:	48 89 9c 24 d8 01 00 	mov    %rbx,0x1d8(%rsp)
  67f8eb:	00 
  67f8ec:	eb 6d                	jmp    67f95b <<gpui_canvas::text::planner::Planner>::shape+0x186b>
  67f8ee:	44 03 74 24 40       	add    0x40(%rsp),%r14d
  67f8f3:	0f 28 8c 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm1
  67f8fa:	00 
  67f8fb:	f3 0f 58 4c 24 24    	addss  0x24(%rsp),%xmm1
  67f901:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  67f908:	00 
  67f909:	48 89 d9             	mov    %rbx,%rcx
  67f90c:	48 c1 e1 04          	shl    $0x4,%rcx
  67f910:	44 89 34 08          	mov    %r14d,(%rax,%rcx,1)
  67f914:	f3 0f 10 44 24 78    	movss  0x78(%rsp),%xmm0
  67f91a:	f3 0f 11 44 08 04    	movss  %xmm0,0x4(%rax,%rcx,1)
  67f920:	f3 0f 11 4c 08 08    	movss  %xmm1,0x8(%rax,%rcx,1)
  67f926:	66 44 89 64 08 0c    	mov    %r12w,0xc(%rax,%rcx,1)
  67f92c:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
  67f933:	00 
  67f934:	88 54 08 0e          	mov    %dl,0xe(%rax,%rcx,1)
  67f938:	c6 44 08 0f 00       	movb   $0x0,0xf(%rax,%rcx,1)
  67f93d:	48 ff c3             	inc    %rbx
  67f940:	48 89 9c 24 f8 00 00 	mov    %rbx,0xf8(%rsp)
  67f947:	00 
  67f948:	31 c0                	xor    %eax,%eax
  67f94a:	48 8b 9c 24 d8 01 00 	mov    0x1d8(%rsp),%rbx
  67f951:	00 
  67f952:	f3 0f 10 84 24 b4 01 	movss  0x1b4(%rsp),%xmm0
  67f959:	00 00 
  67f95b:	f3 0f 11 44 24 78    	movss  %xmm0,0x78(%rsp)
  67f961:	a8 01                	test   $0x1,%al
  67f963:	74 5b                	je     67f9c0 <<gpui_canvas::text::planner::Planner>::shape+0x18d0>
  67f965:	f3 0f 10 84 24 a8 01 	movss  0x1a8(%rsp),%xmm0
  67f96c:	00 00 
  67f96e:	f3 0f 11 84 24 00 01 	movss  %xmm0,0x100(%rsp)
  67f975:	00 00 
  67f977:	44 8b b4 24 ac 01 00 	mov    0x1ac(%rsp),%r14d
  67f97e:	00 
  67f97f:	0f 28 84 24 30 02 00 	movaps 0x230(%rsp),%xmm0
  67f986:	00 
  67f987:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  67f98e:	00 
  67f98f:	83 bc 24 e0 00 00 00 	cmpl   $0x0,0xe0(%rsp)
  67f996:	00 
  67f997:	74 74                	je     67fa0d <<gpui_canvas::text::planner::Planner>::shape+0x191d>
  67f999:	48 83 bc 24 80 00 00 	cmpq   $0x0,0x80(%rsp)
  67f9a0:	00 00 
  67f9a2:	74 7c                	je     67fa20 <<gpui_canvas::text::planner::Planner>::shape+0x1930>
  67f9a4:	0f 28 84 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm0
  67f9ab:	00 
  67f9ac:	f3 0f 11 84 24 dc 00 	movss  %xmm0,0xdc(%rsp)
  67f9b3:	00 00 
  67f9b5:	e9 9a 00 00 00       	jmp    67fa54 <<gpui_canvas::text::planner::Planner>::shape+0x1964>
  67f9ba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  67f9c0:	4c 3b ac 24 c8 00 00 	cmp    0xc8(%rsp),%r13
  67f9c7:	00 
  67f9c8:	0f 84 58 01 00 00    	je     67fb26 <<gpui_canvas::text::planner::Planner>::shape+0x1a36>
  67f9ce:	48 8b 94 24 80 00 00 	mov    0x80(%rsp),%rdx
  67f9d5:	00 
  67f9d6:	45 8b 75 00          	mov    0x0(%r13),%r14d
  67f9da:	f2 41 0f 10 45 04    	movsd  0x4(%r13),%xmm0
  67f9e0:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  67f9e7:	00 
  67f9e8:	f3 41 0f 10 45 0c    	movss  0xc(%r13),%xmm0
  67f9ee:	f3 0f 11 84 24 00 01 	movss  %xmm0,0x100(%rsp)
  67f9f5:	00 00 
  67f9f7:	49 83 c5 10          	add    $0x10,%r13
  67f9fb:	48 89 94 24 80 00 00 	mov    %rdx,0x80(%rsp)
  67fa02:	00 
  67fa03:	83 bc 24 e0 00 00 00 	cmpl   $0x0,0xe0(%rsp)
  67fa0a:	00 
  67fa0b:	75 8c                	jne    67f999 <<gpui_canvas::text::planner::Planner>::shape+0x18a9>
  67fa0d:	0f 28 84 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm0
  67fa14:	00 
  67fa15:	f3 0f 11 84 24 dc 00 	movss  %xmm0,0xdc(%rsp)
  67fa1c:	00 00 
  67fa1e:	eb 74                	jmp    67fa94 <<gpui_canvas::text::planner::Planner>::shape+0x19a4>
  67fa20:	f3 0f 10 84 24 b0 01 	movss  0x1b0(%rsp),%xmm0
  67fa27:	00 00 
  67fa29:	0f 28 c8             	movaps %xmm0,%xmm1
  67fa2c:	f3 0f 58 8c 24 c0 01 	addss  0x1c0(%rsp),%xmm1
  67fa33:	00 00 
  67fa35:	f3 0f 11 8c 24 dc 00 	movss  %xmm1,0xdc(%rsp)
  67fa3c:	00 00 
  67fa3e:	f3 0f 10 8c 24 00 01 	movss  0x100(%rsp),%xmm1
  67fa45:	00 00 
  67fa47:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  67fa4b:	f3 0f 11 8c 24 00 01 	movss  %xmm1,0x100(%rsp)
  67fa52:	00 00 
  67fa54:	48 8b 94 24 80 00 00 	mov    0x80(%rsp),%rdx
  67fa5b:	00 
  67fa5c:	48 ff c2             	inc    %rdx
  67fa5f:	48 8b 84 24 28 01 00 	mov    0x128(%rsp),%rax
  67fa66:	00 
  67fa67:	48 89 94 24 80 00 00 	mov    %rdx,0x80(%rsp)
  67fa6e:	00 
  67fa6f:	48 39 c2             	cmp    %rax,%rdx
  67fa72:	75 20                	jne    67fa94 <<gpui_canvas::text::planner::Planner>::shape+0x19a4>
  67fa74:	f3 0f 10 84 24 00 01 	movss  0x100(%rsp),%xmm0
  67fa7b:	00 00 
  67fa7d:	f3 0f 58 44 24 5c    	addss  0x5c(%rsp),%xmm0
  67fa83:	f3 0f 11 84 24 00 01 	movss  %xmm0,0x100(%rsp)
  67fa8a:	00 00 
  67fa8c:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  67fa93:	00 
  67fa94:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  67fa9b:	00 
  67fa9c:	48 8d b4 24 b0 04 00 	lea    0x4b0(%rsp),%rsi
  67faa3:	00 
  67faa4:	e8 27 27 00 00       	call   6821d0 <<core::iter::adapters::flatten::FlattenCompat<core::iter::adapters::map::Map<core::ops::range::Range<u32>, <parley::layout::run::Run<()>>::glyph_source_ranges::{closure#0}>, core::iter::sources::repeat_n::RepeatN<core::ops::range::Range<usize>>> as core::iter::traits::iterator::Iterator>::next>
  67faa9:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  67fab0:	01 
  67fab1:	0f 85 b6 15 00 00    	jne    68106d <<gpui_canvas::text::planner::Planner>::shape+0x2f7d>
  67fab7:	f3 0f 10 44 24 78    	movss  0x78(%rsp),%xmm0
  67fabd:	f3 0f 58 84 24 00 01 	addss  0x100(%rsp),%xmm0
  67fac4:	00 00 
  67fac6:	31 c0                	xor    %eax,%eax
  67fac8:	48 8b 8c 24 90 01 00 	mov    0x190(%rsp),%rcx
  67facf:	00 
  67fad0:	48 3b 4c 24 40       	cmp    0x40(%rsp),%rcx
  67fad5:	0f 84 80 fe ff ff    	je     67f95b <<gpui_canvas::text::planner::Planner>::shape+0x186b>
  67fadb:	f3 0f 11 84 24 b4 01 	movss  %xmm0,0x1b4(%rsp)
  67fae2:	00 00 
  67fae4:	4c 8b 8c 24 98 00 00 	mov    0x98(%rsp),%r9
  67faeb:	00 
  67faec:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  67faf3:	00 
  67faf4:	49 39 c9             	cmp    %rcx,%r9
  67faf7:	0f 87 60 15 00 00    	ja     68105d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  67fafd:	4d 85 c9             	test   %r9,%r9
  67fb00:	0f 84 01 05 00 00    	je     680007 <<gpui_canvas::text::planner::Planner>::shape+0x1f17>
  67fb06:	4c 3b 4c 24 08       	cmp    0x8(%rsp),%r9
  67fb0b:	0f 83 f0 04 00 00    	jae    680001 <<gpui_canvas::text::planner::Planner>::shape+0x1f11>
  67fb11:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67fb16:	42 80 3c 08 bf       	cmpb   $0xbf,(%rax,%r9,1)
  67fb1b:	0f 8f e6 04 00 00    	jg     680007 <<gpui_canvas::text::planner::Planner>::shape+0x1f17>
  67fb21:	e9 37 15 00 00       	jmp    68105d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  67fb26:	4c 89 ac 24 c8 00 00 	mov    %r13,0xc8(%rsp)
  67fb2d:	00 
  67fb2e:	f6 84 24 90 02 00 00 	testb  $0x1,0x290(%rsp)
  67fb35:	01 
  67fb36:	74 1e                	je     67fb56 <<gpui_canvas::text::planner::Planner>::shape+0x1a66>
  67fb38:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  67fb3d:	48 8b 8c 24 10 01 00 	mov    0x110(%rsp),%rcx
  67fb44:	00 
  67fb45:	39 c1                	cmp    %eax,%ecx
  67fb47:	0f 83 53 01 00 00    	jae    67fca0 <<gpui_canvas::text::planner::Planner>::shape+0x1bb0>
  67fb4d:	ff c8                	dec    %eax
  67fb4f:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  67fb54:	eb 18                	jmp    67fb6e <<gpui_canvas::text::planner::Planner>::shape+0x1a7e>
  67fb56:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  67fb5b:	48 8b 84 24 10 01 00 	mov    0x110(%rsp),%rax
  67fb62:	00 
  67fb63:	39 d0                	cmp    %edx,%eax
  67fb65:	0f 83 50 01 00 00    	jae    67fcbb <<gpui_canvas::text::planner::Planner>::shape+0x1bcb>
  67fb6b:	8d 48 01             	lea    0x1(%rax),%ecx
  67fb6e:	89 c7                	mov    %eax,%edi
  67fb70:	48 39 fb             	cmp    %rdi,%rbx
  67fb73:	48 8b 94 24 f0 01 00 	mov    0x1f0(%rsp),%rdx
  67fb7a:	00 
  67fb7b:	0f 86 7e 1b 00 00    	jbe    6816ff <<gpui_canvas::text::planner::Planner>::shape+0x360f>
  67fb81:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  67fb85:	44 8b 6c c2 08       	mov    0x8(%rdx,%rax,8),%r13d
  67fb8a:	f6 44 c2 17 01       	testb  $0x1,0x17(%rdx,%rax,8)
  67fb8f:	0f 85 6e 05 00 00    	jne    680103 <<gpui_canvas::text::planner::Planner>::shape+0x2013>
  67fb95:	48 8d 04 c2          	lea    (%rdx,%rax,8),%rax
  67fb99:	8b 50 0c             	mov    0xc(%rax),%edx
  67fb9c:	4a 8d 34 2a          	lea    (%rdx,%r13,1),%rsi
  67fba0:	48 3b b4 24 30 01 00 	cmp    0x130(%rsp),%rsi
  67fba7:	00 
  67fba8:	0f 87 8e 17 00 00    	ja     68133c <<gpui_canvas::text::planner::Planner>::shape+0x324c>
  67fbae:	49 c1 e5 04          	shl    $0x4,%r13
  67fbb2:	4c 03 ac 24 78 02 00 	add    0x278(%rsp),%r13
  67fbb9:	00 
  67fbba:	48 89 d0             	mov    %rdx,%rax
  67fbbd:	48 c1 e0 04          	shl    $0x4,%rax
  67fbc1:	4c 01 e8             	add    %r13,%rax
  67fbc4:	0f 57 c0             	xorps  %xmm0,%xmm0
  67fbc7:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  67fbce:	00 
  67fbcf:	48 85 d2             	test   %rdx,%rdx
  67fbd2:	0f 85 d5 06 00 00    	jne    6802ad <<gpui_canvas::text::planner::Planner>::shape+0x21bd>
  67fbd8:	89 ca                	mov    %ecx,%edx
  67fbda:	48 89 94 24 10 01 00 	mov    %rdx,0x110(%rsp)
  67fbe1:	00 
  67fbe2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  67fbe9:	1f 84 00 00 00 00 00 
  67fbf0:	f6 84 24 90 02 00 00 	testb  $0x1,0x290(%rsp)
  67fbf7:	01 
  67fbf8:	74 26                	je     67fc20 <<gpui_canvas::text::planner::Planner>::shape+0x1b30>
  67fbfa:	4c 8b 64 24 30       	mov    0x30(%rsp),%r12
  67fbff:	44 39 e1             	cmp    %r12d,%ecx
  67fc02:	0f 83 d2 00 00 00    	jae    67fcda <<gpui_canvas::text::planner::Planner>::shape+0x1bea>
  67fc08:	41 ff cc             	dec    %r12d
  67fc0b:	4c 89 e0             	mov    %r12,%rax
  67fc0e:	89 ca                	mov    %ecx,%edx
  67fc10:	4c 89 64 24 30       	mov    %r12,0x30(%rsp)
  67fc15:	89 c1                	mov    %eax,%ecx
  67fc17:	eb 21                	jmp    67fc3a <<gpui_canvas::text::planner::Planner>::shape+0x1b4a>
  67fc19:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  67fc20:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  67fc25:	39 d1                	cmp    %edx,%ecx
  67fc27:	0f 83 55 01 00 00    	jae    67fd82 <<gpui_canvas::text::planner::Planner>::shape+0x1c92>
  67fc2d:	8d 41 01             	lea    0x1(%rcx),%eax
  67fc30:	48 89 84 24 10 01 00 	mov    %rax,0x110(%rsp)
  67fc37:	00 
  67fc38:	89 c2                	mov    %eax,%edx
  67fc3a:	89 cf                	mov    %ecx,%edi
  67fc3c:	48 39 fb             	cmp    %rdi,%rbx
  67fc3f:	48 8b 8c 24 f0 01 00 	mov    0x1f0(%rsp),%rcx
  67fc46:	00 
  67fc47:	0f 86 b2 1a 00 00    	jbe    6816ff <<gpui_canvas::text::planner::Planner>::shape+0x360f>
  67fc4d:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  67fc51:	44 8b 6c c1 08       	mov    0x8(%rcx,%rax,8),%r13d
  67fc56:	f6 44 c1 17 01       	testb  $0x1,0x17(%rcx,%rax,8)
  67fc5b:	0f 85 9a 04 00 00    	jne    6800fb <<gpui_canvas::text::planner::Planner>::shape+0x200b>
  67fc61:	48 8d 04 c1          	lea    (%rcx,%rax,8),%rax
  67fc65:	8b 78 0c             	mov    0xc(%rax),%edi
  67fc68:	4a 8d 34 2f          	lea    (%rdi,%r13,1),%rsi
  67fc6c:	48 3b b4 24 30 01 00 	cmp    0x130(%rsp),%rsi
  67fc73:	00 
  67fc74:	0f 87 c2 16 00 00    	ja     68133c <<gpui_canvas::text::planner::Planner>::shape+0x324c>
  67fc7a:	49 c1 e5 04          	shl    $0x4,%r13
  67fc7e:	4c 03 ac 24 78 02 00 	add    0x278(%rsp),%r13
  67fc85:	00 
  67fc86:	48 89 f8             	mov    %rdi,%rax
  67fc89:	48 c1 e0 04          	shl    $0x4,%rax
  67fc8d:	4c 01 e8             	add    %r13,%rax
  67fc90:	89 d1                	mov    %edx,%ecx
  67fc92:	48 85 ff             	test   %rdi,%rdi
  67fc95:	0f 84 55 ff ff ff    	je     67fbf0 <<gpui_canvas::text::planner::Planner>::shape+0x1b00>
  67fc9b:	e9 d8 04 00 00       	jmp    680178 <<gpui_canvas::text::planner::Planner>::shape+0x2088>
  67fca0:	4c 89 e8             	mov    %r13,%rax
  67fca3:	3b 8c 24 e8 01 00 00 	cmp    0x1e8(%rsp),%ecx
  67fcaa:	0f 95 c2             	setne  %dl
  67fcad:	84 94 24 e0 00 00 00 	test   %dl,0xe0(%rsp)
  67fcb4:	75 4e                	jne    67fd04 <<gpui_canvas::text::planner::Planner>::shape+0x1c14>
  67fcb6:	e9 0f 06 00 00       	jmp    6802ca <<gpui_canvas::text::planner::Planner>::shape+0x21da>
  67fcbb:	4c 89 e8             	mov    %r13,%rax
  67fcbe:	3b 94 24 e0 01 00 00 	cmp    0x1e0(%rsp),%edx
  67fcc5:	0f 95 c1             	setne  %cl
  67fcc8:	84 8c 24 e0 00 00 00 	test   %cl,0xe0(%rsp)
  67fccf:	0f 85 d7 00 00 00    	jne    67fdac <<gpui_canvas::text::planner::Planner>::shape+0x1cbc>
  67fcd5:	e9 f0 05 00 00       	jmp    6802ca <<gpui_canvas::text::planner::Planner>::shape+0x21da>
  67fcda:	0f 57 c0             	xorps  %xmm0,%xmm0
  67fcdd:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  67fce4:	00 
  67fce5:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  67fcec:	00 
  67fced:	3b 8c 24 e8 01 00 00 	cmp    0x1e8(%rsp),%ecx
  67fcf4:	0f 95 c2             	setne  %dl
  67fcf7:	84 94 24 e0 00 00 00 	test   %dl,0xe0(%rsp)
  67fcfe:	0f 84 c6 05 00 00    	je     6802ca <<gpui_canvas::text::planner::Planner>::shape+0x21da>
  67fd04:	8d 79 ff             	lea    -0x1(%rcx),%edi
  67fd07:	48 39 fb             	cmp    %rdi,%rbx
  67fd0a:	0f 86 90 1a 00 00    	jbe    6817a0 <<gpui_canvas::text::planner::Planner>::shape+0x36b0>
  67fd10:	3b bc 24 e8 01 00 00 	cmp    0x1e8(%rsp),%edi
  67fd17:	76 43                	jbe    67fd5c <<gpui_canvas::text::planner::Planner>::shape+0x1c6c>
  67fd19:	48 8d 14 7f          	lea    (%rdi,%rdi,2),%rdx
  67fd1d:	48 8b b4 24 50 02 00 	mov    0x250(%rsp),%rsi
  67fd24:	00 
  67fd25:	48 8d 14 d6          	lea    (%rsi,%rdx,8),%rdx
  67fd29:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  67fd30:	48 39 fb             	cmp    %rdi,%rbx
  67fd33:	0f 86 e7 19 00 00    	jbe    681720 <<gpui_canvas::text::planner::Planner>::shape+0x3630>
  67fd39:	f6 42 01 02          	testb  $0x2,0x1(%rdx)
  67fd3d:	75 1d                	jne    67fd5c <<gpui_canvas::text::planner::Planner>::shape+0x1c6c>
  67fd3f:	48 ff cf             	dec    %rdi
  67fd42:	48 83 c2 e8          	add    $0xffffffffffffffe8,%rdx
  67fd46:	39 bc 24 e8 01 00 00 	cmp    %edi,0x1e8(%rsp)
  67fd4d:	72 e1                	jb     67fd30 <<gpui_canvas::text::planner::Planner>::shape+0x1c40>
  67fd4f:	48 8b 94 24 e8 01 00 	mov    0x1e8(%rsp),%rdx
  67fd56:	00 
  67fd57:	48 89 d7             	mov    %rdx,%rdi
  67fd5a:	eb 02                	jmp    67fd5e <<gpui_canvas::text::planner::Planner>::shape+0x1c6e>
  67fd5c:	89 fa                	mov    %edi,%edx
  67fd5e:	48 39 fb             	cmp    %rdi,%rbx
  67fd61:	0f 86 45 1a 00 00    	jbe    6817ac <<gpui_canvas::text::planner::Planner>::shape+0x36bc>
  67fd67:	48 89 94 24 10 01 00 	mov    %rdx,0x110(%rsp)
  67fd6e:	00 
  67fd6f:	89 ca                	mov    %ecx,%edx
  67fd71:	48 ff ca             	dec    %rdx
  67fd74:	48 39 da             	cmp    %rbx,%rdx
  67fd77:	0f 82 a1 00 00 00    	jb     67fe1e <<gpui_canvas::text::planner::Planner>::shape+0x1d2e>
  67fd7d:	e9 36 1a 00 00       	jmp    6817b8 <<gpui_canvas::text::planner::Planner>::shape+0x36c8>
  67fd82:	0f 57 c0             	xorps  %xmm0,%xmm0
  67fd85:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  67fd8c:	00 
  67fd8d:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  67fd94:	00 
  67fd95:	3b 94 24 e0 01 00 00 	cmp    0x1e0(%rsp),%edx
  67fd9c:	0f 95 c1             	setne  %cl
  67fd9f:	84 8c 24 e0 00 00 00 	test   %cl,0xe0(%rsp)
  67fda6:	0f 84 1e 05 00 00    	je     6802ca <<gpui_canvas::text::planner::Planner>::shape+0x21da>
  67fdac:	49 89 d0             	mov    %rdx,%r8
  67fdaf:	48 89 d1             	mov    %rdx,%rcx
  67fdb2:	89 cf                	mov    %ecx,%edi
  67fdb4:	48 39 fb             	cmp    %rdi,%rbx
  67fdb7:	0f 86 ce 19 00 00    	jbe    68178b <<gpui_canvas::text::planner::Planner>::shape+0x369b>
  67fdbd:	ff c1                	inc    %ecx
  67fdbf:	3b 8c 24 e0 01 00 00 	cmp    0x1e0(%rsp),%ecx
  67fdc6:	73 40                	jae    67fe08 <<gpui_canvas::text::planner::Planner>::shape+0x1d18>
  67fdc8:	89 ca                	mov    %ecx,%edx
  67fdca:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  67fdce:	48 8b b4 24 50 02 00 	mov    0x250(%rsp),%rsi
  67fdd5:	00 
  67fdd6:	48 8d 34 ce          	lea    (%rsi,%rcx,8),%rsi
  67fdda:	48 89 d1             	mov    %rdx,%rcx
  67fddd:	0f 1f 00             	nopl   (%rax)
  67fde0:	48 39 cb             	cmp    %rcx,%rbx
  67fde3:	0f 86 1f 19 00 00    	jbe    681708 <<gpui_canvas::text::planner::Planner>::shape+0x3618>
  67fde9:	f6 46 01 02          	testb  $0x2,0x1(%rsi)
  67fded:	75 19                	jne    67fe08 <<gpui_canvas::text::planner::Planner>::shape+0x1d18>
  67fdef:	48 ff c1             	inc    %rcx
  67fdf2:	48 83 c6 18          	add    $0x18,%rsi
  67fdf6:	48 39 8c 24 e0 01 00 	cmp    %rcx,0x1e0(%rsp)
  67fdfd:	00 
  67fdfe:	75 e0                	jne    67fde0 <<gpui_canvas::text::planner::Planner>::shape+0x1cf0>
  67fe00:	48 8b 8c 24 e0 01 00 	mov    0x1e0(%rsp),%rcx
  67fe07:	00 
  67fe08:	89 ca                	mov    %ecx,%edx
  67fe0a:	48 ff ca             	dec    %rdx
  67fe0d:	48 39 da             	cmp    %rbx,%rdx
  67fe10:	0f 83 7e 19 00 00    	jae    681794 <<gpui_canvas::text::planner::Planner>::shape+0x36a4>
  67fe16:	4c 89 84 24 10 01 00 	mov    %r8,0x110(%rsp)
  67fe1d:	00 
  67fe1e:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  67fe23:	48 83 bc 24 68 02 00 	cmpq   $0x0,0x268(%rsp)
  67fe2a:	00 00 
  67fe2c:	0f 84 98 04 00 00    	je     6802ca <<gpui_canvas::text::planner::Planner>::shape+0x21da>
  67fe32:	48 8d 0c 7f          	lea    (%rdi,%rdi,2),%rcx
  67fe36:	48 8b b4 24 f0 01 00 	mov    0x1f0(%rsp),%rsi
  67fe3d:	00 
  67fe3e:	8b 0c ce             	mov    (%rsi,%rcx,8),%ecx
  67fe41:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  67fe45:	8b 74 d6 04          	mov    0x4(%rsi,%rdx,8),%esi
  67fe49:	39 ce                	cmp    %ecx,%esi
  67fe4b:	0f 82 15 18 00 00    	jb     681666 <<gpui_canvas::text::planner::Planner>::shape+0x3576>
  67fe51:	48 39 b4 24 00 02 00 	cmp    %rsi,0x200(%rsp)
  67fe58:	00 
  67fe59:	0f 82 07 18 00 00    	jb     681666 <<gpui_canvas::text::planner::Planner>::shape+0x3576>
  67fe5f:	39 ce                	cmp    %ecx,%esi
  67fe61:	0f 84 05 19 00 00    	je     68176c <<gpui_canvas::text::planner::Planner>::shape+0x367c>
  67fe67:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  67fe6b:	48 8b 94 24 68 02 00 	mov    0x268(%rsp),%rdx
  67fe72:	00 
  67fe73:	0f b6 4c 8a 07       	movzbl 0x7(%rdx,%rcx,4),%ecx
  67fe78:	8d 51 ff             	lea    -0x1(%rcx),%edx
  67fe7b:	83 fa 02             	cmp    $0x2,%edx
  67fe7e:	73 28                	jae    67fea8 <<gpui_canvas::text::planner::Planner>::shape+0x1db8>
  67fe80:	f3 0f 10 84 24 24 02 	movss  0x224(%rsp),%xmm0
  67fe87:	00 00 
  67fe89:	f3 0f 11 44 24 5c    	movss  %xmm0,0x5c(%rsp)
  67fe8f:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  67fe94:	3b 94 24 20 02 00 00 	cmp    0x220(%rsp),%edx
  67fe9b:	77 2d                	ja     67feca <<gpui_canvas::text::planner::Planner>::shape+0x1dda>
  67fe9d:	f3 0f 10 84 24 1c 02 	movss  0x21c(%rsp),%xmm0
  67fea4:	00 00 
  67fea6:	eb 1c                	jmp    67fec4 <<gpui_canvas::text::planner::Planner>::shape+0x1dd4>
  67fea8:	f3 0f 10 84 24 28 02 	movss  0x228(%rsp),%xmm0
  67feaf:	00 00 
  67feb1:	f3 0f 11 44 24 5c    	movss  %xmm0,0x5c(%rsp)
  67feb7:	83 f9 06             	cmp    $0x6,%ecx
  67feba:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  67febf:	75 09                	jne    67feca <<gpui_canvas::text::planner::Planner>::shape+0x1dda>
  67fec1:	0f 57 c0             	xorps  %xmm0,%xmm0
  67fec4:	f3 0f 11 44 24 5c    	movss  %xmm0,0x5c(%rsp)
  67feca:	89 d6                	mov    %edx,%esi
  67fecc:	48 39 f3             	cmp    %rsi,%rbx
  67fecf:	0f 92 c1             	setb   %cl
  67fed2:	3b 94 24 10 01 00 00 	cmp    0x110(%rsp),%edx
  67fed9:	0f 82 09 01 00 00    	jb     67ffe8 <<gpui_canvas::text::planner::Planner>::shape+0x1ef8>
  67fedf:	48 8b bc 24 10 01 00 	mov    0x110(%rsp),%rdi
  67fee6:	00 
  67fee7:	89 fa                	mov    %edi,%edx
  67fee9:	84 c9                	test   %cl,%cl
  67feeb:	0f 85 94 17 00 00    	jne    681685 <<gpui_canvas::text::planner::Planner>::shape+0x3595>
  67fef1:	3b 7c 24 30          	cmp    0x30(%rsp),%edi
  67fef5:	75 11                	jne    67ff08 <<gpui_canvas::text::planner::Planner>::shape+0x1e18>
  67fef7:	48 c7 84 24 28 01 00 	movq   $0x0,0x128(%rsp)
  67fefe:	00 00 00 00 00 
  67ff03:	e9 b4 00 00 00       	jmp    67ffbc <<gpui_canvas::text::planner::Planner>::shape+0x1ecc>
  67ff08:	48 8d 0c d5 00 00 00 	lea    0x0(,%rdx,8),%rcx
  67ff0f:	00 
  67ff10:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  67ff14:	48 8d 7e ff          	lea    -0x1(%rsi),%rdi
  67ff18:	48 39 d7             	cmp    %rdx,%rdi
  67ff1b:	75 10                	jne    67ff2d <<gpui_canvas::text::planner::Planner>::shape+0x1e3d>
  67ff1d:	31 d2                	xor    %edx,%edx
  67ff1f:	48 c7 84 24 28 01 00 	movq   $0x0,0x128(%rsp)
  67ff26:	00 00 00 00 00 
  67ff2b:	eb 5e                	jmp    67ff8b <<gpui_canvas::text::planner::Planner>::shape+0x1e9b>
  67ff2d:	48 29 d6             	sub    %rdx,%rsi
  67ff30:	48 89 f7             	mov    %rsi,%rdi
  67ff33:	48 83 e7 fe          	and    $0xfffffffffffffffe,%rdi
  67ff37:	48 8b 94 24 90 03 00 	mov    0x390(%rsp),%rdx
  67ff3e:	00 
  67ff3f:	4c 8d 04 0a          	lea    (%rdx,%rcx,1),%r8
  67ff43:	31 d2                	xor    %edx,%edx
  67ff45:	45 31 d2             	xor    %r10d,%r10d
  67ff48:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  67ff4e:	66 90                	xchg   %ax,%ax
  67ff50:	45 8b 48 de          	mov    -0x22(%r8),%r9d
  67ff54:	41 f6 40 e9 01       	testb  $0x1,-0x17(%r8)
  67ff59:	4d 0f 45 cb          	cmovne %r11,%r9
  67ff5d:	4d 01 d1             	add    %r10,%r9
  67ff60:	41 f6 40 01 01       	testb  $0x1,0x1(%r8)
  67ff65:	45 8b 50 f6          	mov    -0xa(%r8),%r10d
  67ff69:	4d 0f 45 d3          	cmovne %r11,%r10
  67ff6d:	4d 01 ca             	add    %r9,%r10
  67ff70:	48 83 c2 02          	add    $0x2,%rdx
  67ff74:	49 83 c0 30          	add    $0x30,%r8
  67ff78:	48 39 d7             	cmp    %rdx,%rdi
  67ff7b:	75 d3                	jne    67ff50 <<gpui_canvas::text::planner::Planner>::shape+0x1e60>
  67ff7d:	4c 89 94 24 28 01 00 	mov    %r10,0x128(%rsp)
  67ff84:	00 
  67ff85:	40 f6 c6 01          	test   $0x1,%sil
  67ff89:	74 31                	je     67ffbc <<gpui_canvas::text::planner::Planner>::shape+0x1ecc>
  67ff8b:	48 8b b4 24 28 01 00 	mov    0x128(%rsp),%rsi
  67ff92:	00 
  67ff93:	48 03 8c 24 f0 01 00 	add    0x1f0(%rsp),%rcx
  67ff9a:	00 
  67ff9b:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  67ff9f:	f6 44 d1 17 01       	testb  $0x1,0x17(%rcx,%rdx,8)
  67ffa4:	8b 54 d1 0c          	mov    0xc(%rcx,%rdx,8),%edx
  67ffa8:	b9 01 00 00 00       	mov    $0x1,%ecx
  67ffad:	48 0f 45 d1          	cmovne %rcx,%rdx
  67ffb1:	48 01 f2             	add    %rsi,%rdx
  67ffb4:	48 89 94 24 28 01 00 	mov    %rdx,0x128(%rsp)
  67ffbb:	00 
  67ffbc:	0f 57 c0             	xorps  %xmm0,%xmm0
  67ffbf:	f3 0f 11 84 24 b0 01 	movss  %xmm0,0x1b0(%rsp)
  67ffc6:	00 00 
  67ffc8:	b9 00 00 00 00       	mov    $0x0,%ecx
  67ffcd:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
  67ffd4:	00 
  67ffd5:	ba 00 00 00 00       	mov    $0x0,%edx
  67ffda:	49 39 c5             	cmp    %rax,%r13
  67ffdd:	0f 84 4b fb ff ff    	je     67fb2e <<gpui_canvas::text::planner::Planner>::shape+0x1a3e>
  67ffe3:	e9 ee f9 ff ff       	jmp    67f9d6 <<gpui_canvas::text::planner::Planner>::shape+0x18e6>
  67ffe8:	b1 01                	mov    $0x1,%cl
  67ffea:	48 8b bc 24 10 01 00 	mov    0x110(%rsp),%rdi
  67fff1:	00 
  67fff2:	89 fa                	mov    %edi,%edx
  67fff4:	84 c9                	test   %cl,%cl
  67fff6:	0f 84 f5 fe ff ff    	je     67fef1 <<gpui_canvas::text::planner::Planner>::shape+0x1e01>
  67fffc:	e9 84 16 00 00       	jmp    681685 <<gpui_canvas::text::planner::Planner>::shape+0x3595>
  680001:	0f 85 56 10 00 00    	jne    68105d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  680007:	48 85 c9             	test   %rcx,%rcx
  68000a:	41 0f 94 c4          	sete   %r12b
  68000e:	74 1d                	je     68002d <<gpui_canvas::text::planner::Planner>::shape+0x1f3d>
  680010:	48 3b 4c 24 08       	cmp    0x8(%rsp),%rcx
  680015:	73 10                	jae    680027 <<gpui_canvas::text::planner::Planner>::shape+0x1f37>
  680017:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  68001c:	80 3c 08 c0          	cmpb   $0xc0,(%rax,%rcx,1)
  680020:	7d 0b                	jge    68002d <<gpui_canvas::text::planner::Planner>::shape+0x1f3d>
  680022:	e9 36 10 00 00       	jmp    68105d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  680027:	0f 85 30 10 00 00    	jne    68105d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  68002d:	45 85 f6             	test   %r14d,%r14d
  680030:	0f 84 9c 00 00 00    	je     6800d2 <<gpui_canvas::text::planner::Planner>::shape+0x1fe2>
  680036:	f3 0f 10 44 24 78    	movss  0x78(%rsp),%xmm0
  68003c:	f3 0f 58 84 24 dc 00 	addss  0xdc(%rsp),%xmm0
  680043:	00 00 
  680045:	f3 0f 11 44 24 78    	movss  %xmm0,0x78(%rsp)
  68004b:	66 0f 7e c1          	movd   %xmm0,%ecx
  68004f:	0f 28 84 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm0
  680056:	00 
  680057:	0f 58 84 24 d0 03 00 	addps  0x3d0(%rsp),%xmm0
  68005e:	00 
  68005f:	0f c6 c0 55          	shufps $0x55,%xmm0,%xmm0
  680063:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  68006a:	00 
  68006b:	66 0f 7e c0          	movd   %xmm0,%eax
  68006f:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  680075:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  68007a:	3d 00 00 80 7f       	cmp    $0x7f800000,%eax
  68007f:	0f 9d c0             	setge  %al
  680082:	81 f9 ff ff 7f 7f    	cmp    $0x7f7fffff,%ecx
  680088:	0f 8f f0 0f 00 00    	jg     68107e <<gpui_canvas::text::planner::Planner>::shape+0x2f8e>
  68008e:	84 c0                	test   %al,%al
  680090:	0f 85 e8 0f 00 00    	jne    68107e <<gpui_canvas::text::planner::Planner>::shape+0x2f8e>
  680096:	41 81 fe ff ff 00 00 	cmp    $0xffff,%r14d
  68009d:	0f 87 ba 0f 00 00    	ja     68105d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  6800a3:	45 89 f4             	mov    %r14d,%r12d
  6800a6:	4d 89 ce             	mov    %r9,%r14
  6800a9:	48 8b 9c 24 f8 00 00 	mov    0xf8(%rsp),%rbx
  6800b0:	00 
  6800b1:	48 3b 9c 24 e8 00 00 	cmp    0xe8(%rsp),%rbx
  6800b8:	00 
  6800b9:	0f 85 2f f8 ff ff    	jne    67f8ee <<gpui_canvas::text::planner::Planner>::shape+0x17fe>
  6800bf:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  6800c6:	00 
  6800c7:	ff 15 cb 6f 10 00    	call   *0x106fcb(%rip)        # 787098 <_DYNAMIC+0x410>
  6800cd:	e9 1c f8 ff ff       	jmp    67f8ee <<gpui_canvas::text::planner::Planner>::shape+0x17fe>
  6800d2:	4d 85 c9             	test   %r9,%r9
  6800d5:	0f 84 b8 00 00 00    	je     680193 <<gpui_canvas::text::planner::Planner>::shape+0x20a3>
  6800db:	4c 3b 4c 24 08       	cmp    0x8(%rsp),%r9
  6800e0:	0f 83 a7 00 00 00    	jae    68018d <<gpui_canvas::text::planner::Planner>::shape+0x209d>
  6800e6:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6800eb:	42 80 3c 08 bf       	cmpb   $0xbf,(%rax,%r9,1)
  6800f0:	0f 8f 9d 00 00 00    	jg     680193 <<gpui_canvas::text::planner::Planner>::shape+0x20a3>
  6800f6:	e9 bd 10 00 00       	jmp    6811b8 <<gpui_canvas::text::planner::Planner>::shape+0x30c8>
  6800fb:	48 8b 8c 24 10 01 00 	mov    0x110(%rsp),%rcx
  680102:	00 
  680103:	44 89 ee             	mov    %r13d,%esi
  680106:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  68010a:	48 8b 94 24 f0 01 00 	mov    0x1f0(%rsp),%rdx
  680111:	00 
  680112:	f3 0f 10 44 c2 10    	movss  0x10(%rdx,%rax,8),%xmm0
  680118:	0f 57 c9             	xorps  %xmm1,%xmm1
  68011b:	0f 29 8c 24 c0 01 00 	movaps %xmm1,0x1c0(%rsp)
  680122:	00 
  680123:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  680129:	b8 04 00 00 00       	mov    $0x4,%eax
  68012e:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  680135:	00 
  680136:	48 89 8c 24 10 01 00 	mov    %rcx,0x110(%rsp)
  68013d:	00 
  68013e:	f3 0f 11 84 24 a8 01 	movss  %xmm0,0x1a8(%rsp)
  680145:	00 00 
  680147:	f3 0f 11 84 24 00 01 	movss  %xmm0,0x100(%rsp)
  68014e:	00 00 
  680150:	89 b4 24 ac 01 00 00 	mov    %esi,0x1ac(%rsp)
  680157:	41 89 f6             	mov    %esi,%r14d
  68015a:	0f 57 c0             	xorps  %xmm0,%xmm0
  68015d:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  680164:	00 
  680165:	83 bc 24 e0 00 00 00 	cmpl   $0x0,0xe0(%rsp)
  68016c:	00 
  68016d:	0f 85 26 f8 ff ff    	jne    67f999 <<gpui_canvas::text::planner::Planner>::shape+0x18a9>
  680173:	e9 95 f8 ff ff       	jmp    67fa0d <<gpui_canvas::text::planner::Planner>::shape+0x191d>
  680178:	48 8b 94 24 80 00 00 	mov    0x80(%rsp),%rdx
  68017f:	00 
  680180:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  680187:	00 
  680188:	e9 49 f8 ff ff       	jmp    67f9d6 <<gpui_canvas::text::planner::Planner>::shape+0x18e6>
  68018d:	0f 85 25 10 00 00    	jne    6811b8 <<gpui_canvas::text::planner::Planner>::shape+0x30c8>
  680193:	48 85 c9             	test   %rcx,%rcx
  680196:	48 89 8c 24 48 02 00 	mov    %rcx,0x248(%rsp)
  68019d:	00 
  68019e:	74 1d                	je     6801bd <<gpui_canvas::text::planner::Planner>::shape+0x20cd>
  6801a0:	48 3b 4c 24 08       	cmp    0x8(%rsp),%rcx
  6801a5:	73 10                	jae    6801b7 <<gpui_canvas::text::planner::Planner>::shape+0x20c7>
  6801a7:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6801ac:	80 3c 08 c0          	cmpb   $0xc0,(%rax,%rcx,1)
  6801b0:	7d 0b                	jge    6801bd <<gpui_canvas::text::planner::Planner>::shape+0x20cd>
  6801b2:	e9 11 10 00 00       	jmp    6811c8 <<gpui_canvas::text::planner::Planner>::shape+0x30d8>
  6801b7:	0f 85 0b 10 00 00    	jne    6811c8 <<gpui_canvas::text::planner::Planner>::shape+0x30d8>
  6801bd:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6801c2:	4d 89 ce             	mov    %r9,%r14
  6801c5:	4a 8d 1c 08          	lea    (%rax,%r9,1),%rbx
  6801c9:	48 01 c8             	add    %rcx,%rax
  6801cc:	48 89 84 24 c0 01 00 	mov    %rax,0x1c0(%rsp)
  6801d3:	00 
  6801d4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  6801db:	00 00 00 00 00 
  6801e0:	48 3b 9c 24 c0 01 00 	cmp    0x1c0(%rsp),%rbx
  6801e7:	00 
  6801e8:	0f 84 8c 00 00 00    	je     68027a <<gpui_canvas::text::planner::Planner>::shape+0x218a>
  6801ee:	0f b6 33             	movzbl (%rbx),%esi
  6801f1:	40 84 f6             	test   %sil,%sil
  6801f4:	78 0a                	js     680200 <<gpui_canvas::text::planner::Planner>::shape+0x2110>
  6801f6:	48 ff c3             	inc    %rbx
  6801f9:	eb 65                	jmp    680260 <<gpui_canvas::text::planner::Planner>::shape+0x2170>
  6801fb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  680200:	89 f0                	mov    %esi,%eax
  680202:	83 e0 1f             	and    $0x1f,%eax
  680205:	0f b6 53 01          	movzbl 0x1(%rbx),%edx
  680209:	83 e2 3f             	and    $0x3f,%edx
  68020c:	40 80 fe df          	cmp    $0xdf,%sil
  680210:	76 2c                	jbe    68023e <<gpui_canvas::text::planner::Planner>::shape+0x214e>
  680212:	0f b6 4b 02          	movzbl 0x2(%rbx),%ecx
  680216:	c1 e2 06             	shl    $0x6,%edx
  680219:	83 e1 3f             	and    $0x3f,%ecx
  68021c:	09 d1                	or     %edx,%ecx
  68021e:	40 80 fe f0          	cmp    $0xf0,%sil
  680222:	72 27                	jb     68024b <<gpui_canvas::text::planner::Planner>::shape+0x215b>
  680224:	0f b6 73 03          	movzbl 0x3(%rbx),%esi
  680228:	48 83 c3 04          	add    $0x4,%rbx
  68022c:	83 e0 07             	and    $0x7,%eax
  68022f:	c1 e0 12             	shl    $0x12,%eax
  680232:	c1 e1 06             	shl    $0x6,%ecx
  680235:	83 e6 3f             	and    $0x3f,%esi
  680238:	09 ce                	or     %ecx,%esi
  68023a:	09 c6                	or     %eax,%esi
  68023c:	eb 22                	jmp    680260 <<gpui_canvas::text::planner::Planner>::shape+0x2170>
  68023e:	48 83 c3 02          	add    $0x2,%rbx
  680242:	c1 e0 06             	shl    $0x6,%eax
  680245:	09 d0                	or     %edx,%eax
  680247:	89 c6                	mov    %eax,%esi
  680249:	eb 15                	jmp    680260 <<gpui_canvas::text::planner::Planner>::shape+0x2170>
  68024b:	48 83 c3 03          	add    $0x3,%rbx
  68024f:	c1 e0 0c             	shl    $0xc,%eax
  680252:	09 c1                	or     %eax,%ecx
  680254:	89 ce                	mov    %ecx,%esi
  680256:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  68025d:	00 00 00 
  680260:	48 8d 3d 11 cf 0f 00 	lea    0xfcf11(%rip),%rdi        # 77d178 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x38>
  680267:	ff 15 4b 73 10 00    	call   *0x10734b(%rip)        # 7875b8 <_DYNAMIC+0x930>
  68026d:	84 c0                	test   %al,%al
  68026f:	0f 85 6b ff ff ff    	jne    6801e0 <<gpui_canvas::text::planner::Planner>::shape+0x20f0>
  680275:	e9 54 0f 00 00       	jmp    6811ce <<gpui_canvas::text::planner::Planner>::shape+0x30de>
  68027a:	31 c0                	xor    %eax,%eax
  68027c:	0f 57 c0             	xorps  %xmm0,%xmm0
  68027f:	f3 0f 10 8c 24 00 01 	movss  0x100(%rsp),%xmm1
  680286:	00 00 
  680288:	0f 2e c8             	ucomiss %xmm0,%xmm1
  68028b:	48 8b 9c 24 d8 01 00 	mov    0x1d8(%rsp),%rbx
  680292:	00 
  680293:	f3 0f 10 84 24 b4 01 	movss  0x1b4(%rsp),%xmm0
  68029a:	00 00 
  68029c:	0f 85 2c 0f 00 00    	jne    6811ce <<gpui_canvas::text::planner::Planner>::shape+0x30de>
  6802a2:	0f 8b b3 f6 ff ff    	jnp    67f95b <<gpui_canvas::text::planner::Planner>::shape+0x186b>
  6802a8:	e9 21 0f 00 00       	jmp    6811ce <<gpui_canvas::text::planner::Planner>::shape+0x30de>
  6802ad:	48 8b 94 24 80 00 00 	mov    0x80(%rsp),%rdx
  6802b4:	00 
  6802b5:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6802bc:	00 
  6802bd:	48 89 8c 24 10 01 00 	mov    %rcx,0x110(%rsp)
  6802c4:	00 
  6802c5:	e9 0c f7 ff ff       	jmp    67f9d6 <<gpui_canvas::text::planner::Planner>::shape+0x18e6>
  6802ca:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  6802d1:	00 
  6802d2:	48 8d b4 24 b0 04 00 	lea    0x4b0(%rsp),%rsi
  6802d9:	00 
  6802da:	e8 f1 1e 00 00       	call   6821d0 <<core::iter::adapters::flatten::FlattenCompat<core::iter::adapters::map::Map<core::ops::range::Range<u32>, <parley::layout::run::Run<()>>::glyph_source_ranges::{closure#0}>, core::iter::sources::repeat_n::RepeatN<core::ops::range::Range<usize>>> as core::iter::traits::iterator::Iterator>::next>
  6802df:	48 83 bc 24 90 00 00 	cmpq   $0x0,0x90(%rsp)
  6802e6:	00 00 
  6802e8:	0f 85 6f 0d 00 00    	jne    68105d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  6802ee:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  6802f5:	00 
  6802f6:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6802fa:	0f 84 87 f1 ff ff    	je     67f487 <<gpui_canvas::text::planner::Planner>::shape+0x1397>
  680300:	48 8b 8c 24 90 01 00 	mov    0x190(%rsp),%rcx
  680307:	00 
  680308:	48 3b 4c 24 40       	cmp    0x40(%rsp),%rcx
  68030d:	75 12                	jne    680321 <<gpui_canvas::text::planner::Planner>::shape+0x2231>
  68030f:	31 db                	xor    %ebx,%ebx
  680311:	45 31 f6             	xor    %r14d,%r14d
  680314:	48 8b 94 24 40 02 00 	mov    0x240(%rsp),%rdx
  68031b:	00 
  68031c:	e9 81 00 00 00       	jmp    6803a2 <<gpui_canvas::text::planner::Planner>::shape+0x22b2>
  680321:	48 8b 8c 24 80 03 00 	mov    0x380(%rsp),%rcx
  680328:	00 
  680329:	48 85 c9             	test   %rcx,%rcx
  68032c:	48 8b 94 24 40 02 00 	mov    0x240(%rsp),%rdx
  680333:	00 
  680334:	48 0f 44 ca          	cmove  %rdx,%rcx
  680338:	48 8b 19             	mov    (%rcx),%rbx
  68033b:	4c 8b 71 08          	mov    0x8(%rcx),%r14
  68033f:	4c 39 f3             	cmp    %r14,%rbx
  680342:	0f 87 15 0d 00 00    	ja     68105d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  680348:	48 85 db             	test   %rbx,%rbx
  68034b:	74 1a                	je     680367 <<gpui_canvas::text::planner::Planner>::shape+0x2277>
  68034d:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  680352:	48 39 cb             	cmp    %rcx,%rbx
  680355:	73 14                	jae    68036b <<gpui_canvas::text::planner::Planner>::shape+0x227b>
  680357:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  68035c:	80 3c 19 bf          	cmpb   $0xbf,(%rcx,%rbx,1)
  680360:	7f 12                	jg     680374 <<gpui_canvas::text::planner::Planner>::shape+0x2284>
  680362:	e9 f6 0c 00 00       	jmp    68105d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  680367:	31 db                	xor    %ebx,%ebx
  680369:	eb 09                	jmp    680374 <<gpui_canvas::text::planner::Planner>::shape+0x2284>
  68036b:	48 89 cb             	mov    %rcx,%rbx
  68036e:	0f 85 e9 0c 00 00    	jne    68105d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  680374:	4d 85 f6             	test   %r14,%r14
  680377:	74 1b                	je     680394 <<gpui_canvas::text::planner::Planner>::shape+0x22a4>
  680379:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  68037e:	49 39 ce             	cmp    %rcx,%r14
  680381:	73 16                	jae    680399 <<gpui_canvas::text::planner::Planner>::shape+0x22a9>
  680383:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  680388:	42 80 3c 31 c0       	cmpb   $0xc0,(%rcx,%r14,1)
  68038d:	7d 13                	jge    6803a2 <<gpui_canvas::text::planner::Planner>::shape+0x22b2>
  68038f:	e9 c9 0c 00 00       	jmp    68105d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  680394:	45 31 f6             	xor    %r14d,%r14d
  680397:	eb 09                	jmp    6803a2 <<gpui_canvas::text::planner::Planner>::shape+0x22b2>
  680399:	49 89 ce             	mov    %rcx,%r14
  68039c:	0f 85 bb 0c 00 00    	jne    68105d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  6803a2:	8b 8c 24 f8 00 00 00 	mov    0xf8(%rsp),%ecx
  6803a9:	89 4c 24 30          	mov    %ecx,0x30(%rsp)
  6803ad:	44 0f b6 aa 8c 00 00 	movzbl 0x8c(%rdx),%r13d
  6803b4:	00 
  6803b5:	4c 8b a4 24 50 01 00 	mov    0x150(%rsp),%r12
  6803bc:	00 
  6803bd:	49 39 c4             	cmp    %rax,%r12
  6803c0:	75 0e                	jne    6803d0 <<gpui_canvas::text::planner::Planner>::shape+0x22e0>
  6803c2:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  6803c9:	00 
  6803ca:	ff 15 d8 6c 10 00    	call   *0x106cd8(%rip)        # 7870a8 <_DYNAMIC+0x420>
  6803d0:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6803d5:	01 c3                	add    %eax,%ebx
  6803d7:	41 01 c6             	add    %eax,%r14d
  6803da:	41 80 e5 01          	and    $0x1,%r13b
  6803de:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  6803e5:	00 
  6803e6:	4b 8d 0c 64          	lea    (%r12,%r12,2),%rcx
  6803ea:	89 1c c8             	mov    %ebx,(%rax,%rcx,8)
  6803ed:	44 89 74 c8 04       	mov    %r14d,0x4(%rax,%rcx,8)
  6803f2:	48 8b 94 24 88 03 00 	mov    0x388(%rsp),%rdx
  6803f9:	00 
  6803fa:	89 54 c8 08          	mov    %edx,0x8(%rax,%rcx,8)
  6803fe:	8b 54 24 30          	mov    0x30(%rsp),%edx
  680402:	89 54 c8 0c          	mov    %edx,0xc(%rax,%rcx,8)
  680406:	48 8b 94 24 58 02 00 	mov    0x258(%rsp),%rdx
  68040d:	00 
  68040e:	89 54 c8 10          	mov    %edx,0x10(%rax,%rcx,8)
  680412:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
  680419:	00 
  68041a:	88 54 c8 14          	mov    %dl,0x14(%rax,%rcx,8)
  68041e:	44 88 6c c8 15       	mov    %r13b,0x15(%rax,%rcx,8)
  680423:	49 ff c4             	inc    %r12
  680426:	4c 89 a4 24 50 01 00 	mov    %r12,0x150(%rsp)
  68042d:	00 
  68042e:	e9 54 f0 ff ff       	jmp    67f487 <<gpui_canvas::text::planner::Planner>::shape+0x1397>
  680433:	48 8b 84 24 98 03 00 	mov    0x398(%rsp),%rax
  68043a:	00 
  68043b:	48 39 84 24 d0 00 00 	cmp    %rax,0xd0(%rsp)
  680442:	00 
  680443:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  680448:	48 8b 9c 24 90 01 00 	mov    0x190(%rsp),%rbx
  68044f:	00 
  680450:	0f 85 c7 eb ff ff    	jne    67f01d <<gpui_canvas::text::planner::Planner>::shape+0xf2d>
  680456:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  68045d:	00 ff 
  68045f:	0f 84 e0 06 00 00    	je     680b45 <<gpui_canvas::text::planner::Planner>::shape+0x2a55>
  680465:	48 83 bc 24 70 01 00 	cmpq   $0xffffffffffffffff,0x170(%rsp)
  68046c:	00 ff 
  68046e:	0f 84 d1 06 00 00    	je     680b45 <<gpui_canvas::text::planner::Planner>::shape+0x2a55>
  680474:	48 03 9c 24 38 01 00 	add    0x138(%rsp),%rbx
  68047b:	00 
  68047c:	48 c7 84 24 00 07 00 	movq   $0x0,0x700(%rsp)
  680483:	00 00 00 00 00 
  680488:	48 c7 84 24 08 07 00 	movq   $0x8,0x708(%rsp)
  68048f:	00 08 00 00 00 
  680494:	48 c7 84 24 10 07 00 	movq   $0x0,0x710(%rsp)
  68049b:	00 00 00 00 00 
  6804a0:	c7 84 24 20 07 00 00 	movl   $0xffffffff,0x720(%rsp)
  6804a7:	ff ff ff ff 
  6804ab:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6804b0:	48 89 84 24 28 07 00 	mov    %rax,0x728(%rsp)
  6804b7:	00 
  6804b8:	48 89 9c 24 30 07 00 	mov    %rbx,0x730(%rsp)
  6804bf:	00 
  6804c0:	48 c7 84 24 38 07 00 	movq   $0x0,0x738(%rsp)
  6804c7:	00 00 00 00 00 
  6804cc:	48 8d 05 15 ce 0f 00 	lea    0xfce15(%rip),%rax        # 77d2e8 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x1a8>
  6804d3:	48 89 84 24 40 07 00 	mov    %rax,0x740(%rsp)
  6804da:	00 
  6804db:	48 8d 05 be b7 ff ff 	lea    -0x4842(%rip),%rax        # 67bca0 <icu_segmenter::rule_segmenter_v1::empty_handle_complex::<icu_segmenter::scaffold::Utf8>>
  6804e2:	48 89 84 24 48 07 00 	mov    %rax,0x748(%rsp)
  6804e9:	00 
  6804ea:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6804ef:	48 89 84 24 50 07 00 	mov    %rax,0x750(%rsp)
  6804f6:	00 
  6804f7:	48 c7 84 24 58 07 00 	movq   $0x0,0x758(%rsp)
  6804fe:	00 00 00 00 00 
  680503:	48 c7 84 24 88 07 00 	movq   $0x0,0x788(%rsp)
  68050a:	00 00 00 00 00 
  68050f:	c6 84 24 90 07 00 00 	movb   $0x0,0x790(%rsp)
  680516:	00 
  680517:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  68051e:	00 
  68051f:	e8 4c f2 fe ff       	call   66f770 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  680524:	48 83 f8 01          	cmp    $0x1,%rax
  680528:	0f 85 38 01 00 00    	jne    680666 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  68052e:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  680535:	00 
  680536:	e8 35 f2 fe ff       	call   66f770 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  68053b:	48 83 f8 01          	cmp    $0x1,%rax
  68053f:	0f 85 21 01 00 00    	jne    680666 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  680545:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  68054c:	00 
  68054d:	e8 1e f2 fe ff       	call   66f770 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  680552:	48 83 f8 01          	cmp    $0x1,%rax
  680556:	0f 85 0a 01 00 00    	jne    680666 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  68055c:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  680563:	00 
  680564:	e8 07 f2 fe ff       	call   66f770 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  680569:	48 83 f8 01          	cmp    $0x1,%rax
  68056d:	0f 85 f3 00 00 00    	jne    680666 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  680573:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  68057a:	00 
  68057b:	e8 f0 f1 fe ff       	call   66f770 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  680580:	48 83 f8 01          	cmp    $0x1,%rax
  680584:	0f 85 dc 00 00 00    	jne    680666 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  68058a:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  680591:	00 
  680592:	e8 d9 f1 fe ff       	call   66f770 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  680597:	48 83 f8 01          	cmp    $0x1,%rax
  68059b:	0f 85 c5 00 00 00    	jne    680666 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  6805a1:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  6805a8:	00 
  6805a9:	e8 c2 f1 fe ff       	call   66f770 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  6805ae:	48 83 f8 01          	cmp    $0x1,%rax
  6805b2:	0f 85 ae 00 00 00    	jne    680666 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  6805b8:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  6805bf:	00 
  6805c0:	e8 ab f1 fe ff       	call   66f770 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  6805c5:	a8 01                	test   $0x1,%al
  6805c7:	0f 84 99 00 00 00    	je     680666 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  6805cd:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  6805d4:	00 
  6805d5:	e8 96 f1 fe ff       	call   66f770 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  6805da:	48 83 f8 01          	cmp    $0x1,%rax
  6805de:	0f 85 82 00 00 00    	jne    680666 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  6805e4:	48 8b b4 24 00 07 00 	mov    0x700(%rsp),%rsi
  6805eb:	00 
  6805ec:	48 85 f6             	test   %rsi,%rsi
  6805ef:	74 17                	je     680608 <<gpui_canvas::text::planner::Planner>::shape+0x2518>
  6805f1:	48 8b bc 24 08 07 00 	mov    0x708(%rsp),%rdi
  6805f8:	00 
  6805f9:	48 c1 e6 03          	shl    $0x3,%rsi
  6805fd:	ba 08 00 00 00       	mov    $0x8,%edx
  680602:	ff 15 b8 68 10 00    	call   *0x1068b8(%rip)        # 786ec0 <_DYNAMIC+0x238>
  680608:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  68060f:	00 
  680610:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  680615:	e8 06 94 fe ff       	call   669a20 <<parley::editing::geometry::CursorGeometry<()>>::new>
  68061a:	4c 8b ac 24 00 07 00 	mov    0x700(%rsp),%r13
  680621:	00 
  680622:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  680626:	0f 84 a6 10 00 00    	je     6816d2 <<gpui_canvas::text::planner::Planner>::shape+0x35e2>
  68062c:	48 8d 8c 24 20 07 00 	lea    0x720(%rsp),%rcx
  680633:	00 
  680634:	48 8b 41 10          	mov    0x10(%rcx),%rax
  680638:	49 89 47 20          	mov    %rax,0x20(%r15)
  68063c:	0f 10 41 f0          	movups -0x10(%rcx),%xmm0
  680640:	0f 10 09             	movups (%rcx),%xmm1
  680643:	41 0f 11 4f 10       	movups %xmm1,0x10(%r15)
  680648:	41 0f 11 07          	movups %xmm0,(%r15)
  68064c:	48 8b 84 24 08 07 00 	mov    0x708(%rsp),%rax
  680653:	00 
  680654:	4c 89 ac 24 a0 02 00 	mov    %r13,0x2a0(%rsp)
  68065b:	00 
  68065c:	48 89 84 24 a8 02 00 	mov    %rax,0x2a8(%rsp)
  680663:	00 
  680664:	eb 37                	jmp    68069d <<gpui_canvas::text::planner::Planner>::shape+0x25ad>
  680666:	48 8b b4 24 00 07 00 	mov    0x700(%rsp),%rsi
  68066d:	00 
  68066e:	48 85 f6             	test   %rsi,%rsi
  680671:	74 17                	je     68068a <<gpui_canvas::text::planner::Planner>::shape+0x259a>
  680673:	48 8b bc 24 08 07 00 	mov    0x708(%rsp),%rdi
  68067a:	00 
  68067b:	48 c1 e6 03          	shl    $0x3,%rsi
  68067f:	ba 08 00 00 00       	mov    $0x8,%edx
  680684:	ff 15 36 68 10 00    	call   *0x106836(%rip)        # 786ec0 <_DYNAMIC+0x238>
  68068a:	48 c7 84 24 a0 02 00 	movq   $0xffffffffffffffff,0x2a0(%rsp)
  680691:	00 ff ff ff ff 
  680696:	49 c7 c5 ff ff ff ff 	mov    $0xffffffffffffffff,%r13
  68069d:	48 c7 84 24 00 07 00 	movq   $0x0,0x700(%rsp)
  6806a4:	00 00 00 00 00 
  6806a9:	48 c7 84 24 08 07 00 	movq   $0x8,0x708(%rsp)
  6806b0:	00 08 00 00 00 
  6806b5:	48 c7 84 24 10 07 00 	movq   $0x0,0x710(%rsp)
  6806bc:	00 00 00 00 00 
  6806c1:	c7 84 24 20 07 00 00 	movl   $0xffffffff,0x720(%rsp)
  6806c8:	ff ff ff ff 
  6806cc:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6806d1:	48 89 84 24 28 07 00 	mov    %rax,0x728(%rsp)
  6806d8:	00 
  6806d9:	48 89 9c 24 30 07 00 	mov    %rbx,0x730(%rsp)
  6806e0:	00 
  6806e1:	48 c7 84 24 38 07 00 	movq   $0x0,0x738(%rsp)
  6806e8:	00 00 00 00 00 
  6806ed:	48 8d 05 f4 cb 0f 00 	lea    0xfcbf4(%rip),%rax        # 77d2e8 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x1a8>
  6806f4:	48 89 84 24 40 07 00 	mov    %rax,0x740(%rsp)
  6806fb:	00 
  6806fc:	48 8d 05 9d b5 ff ff 	lea    -0x4a63(%rip),%rax        # 67bca0 <icu_segmenter::rule_segmenter_v1::empty_handle_complex::<icu_segmenter::scaffold::Utf8>>
  680703:	48 89 84 24 48 07 00 	mov    %rax,0x748(%rsp)
  68070a:	00 
  68070b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  680710:	48 89 84 24 50 07 00 	mov    %rax,0x750(%rsp)
  680717:	00 
  680718:	48 c7 84 24 58 07 00 	movq   $0x0,0x758(%rsp)
  68071f:	00 00 00 00 00 
  680724:	48 c7 84 24 88 07 00 	movq   $0x0,0x788(%rsp)
  68072b:	00 00 00 00 00 
  680730:	c6 84 24 90 07 00 00 	movb   $0x0,0x790(%rsp)
  680737:	00 
  680738:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  68073e:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  680742:	f2 0f 11 44 24 08    	movsd  %xmm0,0x8(%rsp)
  680748:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  68074f:	00 
  680750:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  680757:	00 
  680758:	e8 13 f0 fe ff       	call   66f770 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  68075d:	48 83 f8 01          	cmp    $0x1,%rax
  680761:	0f 85 71 03 00 00    	jne    680ad8 <<gpui_canvas::text::planner::Planner>::shape+0x29e8>
  680767:	48 89 d3             	mov    %rdx,%rbx
  68076a:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  68076e:	74 44                	je     6807b4 <<gpui_canvas::text::planner::Planner>::shape+0x26c4>
  680770:	48 8d bc 24 b0 04 00 	lea    0x4b0(%rsp),%rdi
  680777:	00 
  680778:	48 8d b4 24 a0 02 00 	lea    0x2a0(%rsp),%rsi
  68077f:	00 
  680780:	48 89 da             	mov    %rbx,%rdx
  680783:	f3 0f 10 05 c1 ce 99 	movss  -0x66313f(%rip),%xmm0        # 1d64c <GCC_except_table0+0x28>
  68078a:	ff 
  68078b:	e8 c0 8b fe ff       	call   669350 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at>
  680790:	80 bc 24 b0 04 00 00 	cmpb   $0x0,0x4b0(%rsp)
  680797:	00 
  680798:	74 b6                	je     680750 <<gpui_canvas::text::planner::Planner>::shape+0x2660>
  68079a:	0f 10 45 00          	movups 0x0(%rbp),%xmm0
  68079e:	0f 10 4d 10          	movups 0x10(%rbp),%xmm1
  6807a2:	0f 29 8c 24 00 03 00 	movaps %xmm1,0x300(%rsp)
  6807a9:	00 
  6807aa:	0f 29 84 24 f0 02 00 	movaps %xmm0,0x2f0(%rsp)
  6807b1:	00 
  6807b2:	eb 5b                	jmp    68080f <<gpui_canvas::text::planner::Planner>::shape+0x271f>
  6807b4:	48 c7 84 24 b0 04 00 	movq   $0x0,0x4b0(%rsp)
  6807bb:	00 00 00 00 00 
  6807c0:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6807c5:	48 89 de             	mov    %rbx,%rsi
  6807c8:	ba 01 00 00 00       	mov    $0x1,%edx
  6807cd:	e8 9e 81 fe ff       	call   668970 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
  6807d2:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  6807d9:	00 
  6807da:	80 e2 01             	and    $0x1,%dl
  6807dd:	88 94 24 98 00 00 00 	mov    %dl,0x98(%rsp)
  6807e4:	48 39 d8             	cmp    %rbx,%rax
  6807e7:	0f 85 bc 00 00 00    	jne    6808a9 <<gpui_canvas::text::planner::Planner>::shape+0x27b9>
  6807ed:	48 8d bc 24 f0 02 00 	lea    0x2f0(%rsp),%rdi
  6807f4:	00 
  6807f5:	48 8d b4 24 90 00 00 	lea    0x90(%rsp),%rsi
  6807fc:	00 
  6807fd:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  680802:	f3 0f 10 05 42 ce 99 	movss  -0x6631be(%rip),%xmm0        # 1d64c <GCC_except_table0+0x28>
  680809:	ff 
  68080a:	e8 21 82 fe ff       	call   668a30 <<parley::editing::cursor::Cursor>::geometry::<()>>
  68080f:	f2 0f 10 84 24 f8 02 	movsd  0x2f8(%rsp),%xmm0
  680816:	00 00 
  680818:	f2 0f 58 44 24 08    	addsd  0x8(%rsp),%xmm0
  68081e:	66 0f 28 8c 24 f0 02 	movapd 0x2f0(%rsp),%xmm1
  680825:	00 00 
  680827:	66 0f 28 94 24 00 03 	movapd 0x300(%rsp),%xmm2
  68082e:	00 00 
  680830:	66 0f 5c d1          	subpd  %xmm1,%xmm2
  680834:	66 0f 14 c8          	unpcklpd %xmm0,%xmm1
  680838:	66 0f 5a d9          	cvtpd2ps %xmm1,%xmm3
  68083c:	66 0f 5a ca          	cvtpd2ps %xmm2,%xmm1
  680840:	66 0f 29 8c 24 90 01 	movapd %xmm1,0x190(%rsp)
  680847:	00 00 
  680849:	66 0f 14 d9          	unpcklpd %xmm1,%xmm3
  68084d:	66 0f 29 5c 24 30    	movapd %xmm3,0x30(%rsp)
  680853:	66 0f 28 cb          	movapd %xmm3,%xmm1
  680857:	66 0f 54 0d 21 4b 9a 	andpd  -0x65b4df(%rip),%xmm1        # 25380 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  68085e:	ff 
  68085f:	66 0f 66 0d e9 44 9a 	pcmpgtd -0x65bb17(%rip),%xmm1        # 24d50 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x1b0>
  680866:	ff 
  680867:	0f 50 c1             	movmskps %xmm1,%eax
  68086a:	85 c0                	test   %eax,%eax
  68086c:	0f 85 b8 08 00 00    	jne    68112a <<gpui_canvas::text::planner::Planner>::shape+0x303a>
  680872:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
  680876:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
  68087c:	41 b6 01             	mov    $0x1,%r14b
  68087f:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  680883:	74 27                	je     6808ac <<gpui_canvas::text::planner::Planner>::shape+0x27bc>
  680885:	48 8d 84 24 d8 04 00 	lea    0x4d8(%rsp),%rax
  68088c:	00 
  68088d:	0f 10 00             	movups (%rax),%xmm0
  680890:	0f 10 48 10          	movups 0x10(%rax),%xmm1
  680894:	0f 29 8c 24 00 03 00 	movaps %xmm1,0x300(%rsp)
  68089b:	00 
  68089c:	0f 29 84 24 f0 02 00 	movaps %xmm0,0x2f0(%rsp)
  6808a3:	00 
  6808a4:	41 b6 01             	mov    $0x1,%r14b
  6808a7:	eb 60                	jmp    680909 <<gpui_canvas::text::planner::Planner>::shape+0x2819>
  6808a9:	45 31 f6             	xor    %r14d,%r14d
  6808ac:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  6808b1:	48 89 de             	mov    %rbx,%rsi
  6808b4:	31 d2                	xor    %edx,%edx
  6808b6:	e8 b5 80 fe ff       	call   668970 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
  6808bb:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  6808c2:	00 
  6808c3:	80 e2 01             	and    $0x1,%dl
  6808c6:	88 94 24 98 00 00 00 	mov    %dl,0x98(%rsp)
  6808cd:	48 39 d8             	cmp    %rbx,%rax
  6808d0:	74 15                	je     6808e7 <<gpui_canvas::text::planner::Planner>::shape+0x27f7>
  6808d2:	45 84 f6             	test   %r14b,%r14b
  6808d5:	0f 84 75 fe ff ff    	je     680750 <<gpui_canvas::text::planner::Planner>::shape+0x2660>
  6808db:	03 5c 24 40          	add    0x40(%rsp),%ebx
  6808df:	45 31 f6             	xor    %r14d,%r14d
  6808e2:	e9 40 01 00 00       	jmp    680a27 <<gpui_canvas::text::planner::Planner>::shape+0x2937>
  6808e7:	48 8d bc 24 f0 02 00 	lea    0x2f0(%rsp),%rdi
  6808ee:	00 
  6808ef:	48 8d b4 24 90 00 00 	lea    0x90(%rsp),%rsi
  6808f6:	00 
  6808f7:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  6808fc:	f3 0f 10 05 48 cd 99 	movss  -0x6632b8(%rip),%xmm0        # 1d64c <GCC_except_table0+0x28>
  680903:	ff 
  680904:	e8 27 81 fe ff       	call   668a30 <<parley::editing::cursor::Cursor>::geometry::<()>>
  680909:	66 0f 28 5c 24 30    	movapd 0x30(%rsp),%xmm3
  68090f:	f2 0f 10 84 24 f8 02 	movsd  0x2f8(%rsp),%xmm0
  680916:	00 00 
  680918:	f2 0f 58 44 24 08    	addsd  0x8(%rsp),%xmm0
  68091e:	66 0f 28 8c 24 f0 02 	movapd 0x2f0(%rsp),%xmm1
  680925:	00 00 
  680927:	66 0f 28 94 24 00 03 	movapd 0x300(%rsp),%xmm2
  68092e:	00 00 
  680930:	66 0f 5c d1          	subpd  %xmm1,%xmm2
  680934:	66 0f 14 c8          	unpcklpd %xmm0,%xmm1
  680938:	66 0f 5a c9          	cvtpd2ps %xmm1,%xmm1
  68093c:	66 0f 5a c2          	cvtpd2ps %xmm2,%xmm0
  680940:	66 0f 14 c8          	unpcklpd %xmm0,%xmm1
  680944:	66 0f 29 8c 24 80 00 	movapd %xmm1,0x80(%rsp)
  68094b:	00 00 
  68094d:	66 0f 28 c1          	movapd %xmm1,%xmm0
  680951:	66 0f 54 05 27 4a 9a 	andpd  -0x65b5d9(%rip),%xmm0        # 25380 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  680958:	ff 
  680959:	66 0f 66 05 ef 43 9a 	pcmpgtd -0x65bc11(%rip),%xmm0        # 24d50 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x1b0>
  680960:	ff 
  680961:	0f 50 c0             	movmskps %xmm0,%eax
  680964:	85 c0                	test   %eax,%eax
  680966:	0f 85 be 07 00 00    	jne    68112a <<gpui_canvas::text::planner::Planner>::shape+0x303a>
  68096c:	03 5c 24 40          	add    0x40(%rsp),%ebx
  680970:	45 84 f6             	test   %r14b,%r14b
  680973:	0f 84 99 00 00 00    	je     680a12 <<gpui_canvas::text::planner::Planner>::shape+0x2922>
  680979:	0f 28 94 24 80 00 00 	movaps 0x80(%rsp),%xmm2
  680980:	00 
  680981:	0f 2e da             	ucomiss %xmm2,%xmm3
  680984:	41 b6 01             	mov    $0x1,%r14b
  680987:	0f 85 95 00 00 00    	jne    680a22 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  68098d:	0f 8a 8f 00 00 00    	jp     680a22 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  680993:	0f 28 c2             	movaps %xmm2,%xmm0
  680996:	0f c6 c2 55          	shufps $0x55,%xmm2,%xmm0
  68099a:	f3 0f 10 4c 24 10    	movss  0x10(%rsp),%xmm1
  6809a0:	0f 2e c8             	ucomiss %xmm0,%xmm1
  6809a3:	75 7d                	jne    680a22 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  6809a5:	7a 7b                	jp     680a22 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  6809a7:	0f 28 c2             	movaps %xmm2,%xmm0
  6809aa:	66 0f 15 c2          	unpckhpd %xmm2,%xmm0
  6809ae:	0f 28 8c 24 90 01 00 	movaps 0x190(%rsp),%xmm1
  6809b5:	00 
  6809b6:	0f 2e c8             	ucomiss %xmm0,%xmm1
  6809b9:	75 67                	jne    680a22 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  6809bb:	7a 65                	jp     680a22 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  6809bd:	0f 28 c2             	movaps %xmm2,%xmm0
  6809c0:	0f c6 c2 ff          	shufps $0xff,%xmm2,%xmm0
  6809c4:	0f c6 c9 55          	shufps $0x55,%xmm1,%xmm1
  6809c8:	0f 2e c8             	ucomiss %xmm0,%xmm1
  6809cb:	75 55                	jne    680a22 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  6809cd:	7a 53                	jp     680a22 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  6809cf:	4c 8b a4 24 80 01 00 	mov    0x180(%rsp),%r12
  6809d6:	00 
  6809d7:	41 b6 03             	mov    $0x3,%r14b
  6809da:	4c 3b a4 24 70 01 00 	cmp    0x170(%rsp),%r12
  6809e1:	00 
  6809e2:	0f 85 c1 00 00 00    	jne    680aa9 <<gpui_canvas::text::planner::Planner>::shape+0x29b9>
  6809e8:	48 8d bc 24 70 01 00 	lea    0x170(%rsp),%rdi
  6809ef:	00 
  6809f0:	f3 0f 11 9c 24 00 01 	movss  %xmm3,0x100(%rsp)
  6809f7:	00 00 
  6809f9:	ff 15 b1 66 10 00    	call   *0x1066b1(%rip)        # 7870b0 <_DYNAMIC+0x428>
  6809ff:	f3 0f 10 9c 24 00 01 	movss  0x100(%rsp),%xmm3
  680a06:	00 00 
  680a08:	0f 29 5c 24 30       	movaps %xmm3,0x30(%rsp)
  680a0d:	e9 9c 00 00 00       	jmp    680aae <<gpui_canvas::text::planner::Planner>::shape+0x29be>
  680a12:	4c 8b a4 24 80 01 00 	mov    0x180(%rsp),%r12
  680a19:	00 
  680a1a:	66 0f 29 5c 24 30    	movapd %xmm3,0x30(%rsp)
  680a20:	eb 58                	jmp    680a7a <<gpui_canvas::text::planner::Planner>::shape+0x298a>
  680a22:	0f 29 5c 24 30       	movaps %xmm3,0x30(%rsp)
  680a27:	4c 8b a4 24 80 01 00 	mov    0x180(%rsp),%r12
  680a2e:	00 
  680a2f:	4c 3b a4 24 70 01 00 	cmp    0x170(%rsp),%r12
  680a36:	00 
  680a37:	75 0e                	jne    680a47 <<gpui_canvas::text::planner::Planner>::shape+0x2957>
  680a39:	48 8d bc 24 70 01 00 	lea    0x170(%rsp),%rdi
  680a40:	00 
  680a41:	ff 15 69 66 10 00    	call   *0x106669(%rip)        # 7870b0 <_DYNAMIC+0x428>
  680a47:	48 8b 84 24 78 01 00 	mov    0x178(%rsp),%rax
  680a4e:	00 
  680a4f:	4b 8d 0c 64          	lea    (%r12,%r12,2),%rcx
  680a53:	89 1c 88             	mov    %ebx,(%rax,%rcx,4)
  680a56:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  680a5b:	f3 0f 11 44 88 04    	movss  %xmm0,0x4(%rax,%rcx,4)
  680a61:	c6 44 88 08 01       	movb   $0x1,0x8(%rax,%rcx,4)
  680a66:	49 ff c4             	inc    %r12
  680a69:	4c 89 a4 24 80 01 00 	mov    %r12,0x180(%rsp)
  680a70:	00 
  680a71:	45 84 f6             	test   %r14b,%r14b
  680a74:	0f 84 d6 fc ff ff    	je     680750 <<gpui_canvas::text::planner::Planner>::shape+0x2660>
  680a7a:	41 b6 02             	mov    $0x2,%r14b
  680a7d:	4c 3b a4 24 70 01 00 	cmp    0x170(%rsp),%r12
  680a84:	00 
  680a85:	75 18                	jne    680a9f <<gpui_canvas::text::planner::Planner>::shape+0x29af>
  680a87:	48 8d bc 24 70 01 00 	lea    0x170(%rsp),%rdi
  680a8e:	00 
  680a8f:	ff 15 1b 66 10 00    	call   *0x10661b(%rip)        # 7870b0 <_DYNAMIC+0x428>
  680a95:	0f 28 9c 24 80 00 00 	movaps 0x80(%rsp),%xmm3
  680a9c:	00 
  680a9d:	eb 0f                	jmp    680aae <<gpui_canvas::text::planner::Planner>::shape+0x29be>
  680a9f:	0f 28 9c 24 80 00 00 	movaps 0x80(%rsp),%xmm3
  680aa6:	00 
  680aa7:	eb 05                	jmp    680aae <<gpui_canvas::text::planner::Planner>::shape+0x29be>
  680aa9:	0f 29 5c 24 30       	movaps %xmm3,0x30(%rsp)
  680aae:	48 8b 84 24 78 01 00 	mov    0x178(%rsp),%rax
  680ab5:	00 
  680ab6:	4b 8d 0c 64          	lea    (%r12,%r12,2),%rcx
  680aba:	89 1c 88             	mov    %ebx,(%rax,%rcx,4)
  680abd:	f3 0f 11 5c 88 04    	movss  %xmm3,0x4(%rax,%rcx,4)
  680ac3:	44 88 74 88 08       	mov    %r14b,0x8(%rax,%rcx,4)
  680ac8:	49 ff c4             	inc    %r12
  680acb:	4c 89 a4 24 80 01 00 	mov    %r12,0x180(%rsp)
  680ad2:	00 
  680ad3:	e9 78 fc ff ff       	jmp    680750 <<gpui_canvas::text::planner::Planner>::shape+0x2660>
  680ad8:	48 8b b4 24 00 07 00 	mov    0x700(%rsp),%rsi
  680adf:	00 
  680ae0:	48 85 f6             	test   %rsi,%rsi
  680ae3:	74 17                	je     680afc <<gpui_canvas::text::planner::Planner>::shape+0x2a0c>
  680ae5:	48 8b bc 24 08 07 00 	mov    0x708(%rsp),%rdi
  680aec:	00 
  680aed:	48 c1 e6 03          	shl    $0x3,%rsi
  680af1:	ba 08 00 00 00       	mov    $0x8,%edx
  680af6:	ff 15 c4 63 10 00    	call   *0x1063c4(%rip)        # 786ec0 <_DYNAMIC+0x238>
  680afc:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  680b00:	74 43                	je     680b45 <<gpui_canvas::text::planner::Planner>::shape+0x2a55>
  680b02:	4d 85 ed             	test   %r13,%r13
  680b05:	74 1a                	je     680b21 <<gpui_canvas::text::planner::Planner>::shape+0x2a31>
  680b07:	48 8b bc 24 a8 02 00 	mov    0x2a8(%rsp),%rdi
  680b0e:	00 
  680b0f:	49 c1 e5 04          	shl    $0x4,%r13
  680b13:	ba 04 00 00 00       	mov    $0x4,%edx
  680b18:	4c 89 ee             	mov    %r13,%rsi
  680b1b:	ff 15 9f 63 10 00    	call   *0x10639f(%rip)        # 786ec0 <_DYNAMIC+0x238>
  680b21:	48 8b b4 24 b8 02 00 	mov    0x2b8(%rsp),%rsi
  680b28:	00 
  680b29:	48 85 f6             	test   %rsi,%rsi
  680b2c:	74 17                	je     680b45 <<gpui_canvas::text::planner::Planner>::shape+0x2a55>
  680b2e:	48 8b bc 24 c0 02 00 	mov    0x2c0(%rsp),%rdi
  680b35:	00 
  680b36:	48 c1 e6 02          	shl    $0x2,%rsi
  680b3a:	ba 04 00 00 00       	mov    $0x4,%edx
  680b3f:	ff 15 7b 63 10 00    	call   *0x10637b(%rip)        # 786ec0 <_DYNAMIC+0x238>
  680b45:	0f 28 9c 24 80 02 00 	movaps 0x280(%rsp),%xmm3
  680b4c:	00 
  680b4d:	0f 28 c3             	movaps %xmm3,%xmm0
  680b50:	f3 0f 5f 84 24 d8 00 	maxss  0xd8(%rsp),%xmm0
  680b57:	00 00 
  680b59:	0f 28 c8             	movaps %xmm0,%xmm1
  680b5c:	f3 0f c2 c8 03       	cmpunordss %xmm0,%xmm1
  680b61:	0f 28 d1             	movaps %xmm1,%xmm2
  680b64:	0f 55 d0             	andnps %xmm0,%xmm2
  680b67:	0f 54 cb             	andps  %xmm3,%xmm1
  680b6a:	0f 56 ca             	orps   %xmm2,%xmm1
  680b6d:	0f 29 8c 24 80 02 00 	movaps %xmm1,0x280(%rsp)
  680b74:	00 
  680b75:	48 8b 04 24          	mov    (%rsp),%rax
  680b79:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  680b7f:	f3 0f 58 80 30 0a 00 	addss  0xa30(%rax),%xmm0
  680b86:	00 
  680b87:	f3 0f 11 44 24 24    	movss  %xmm0,0x24(%rsp)
  680b8d:	80 7c 24 4c 00       	cmpb   $0x0,0x4c(%rsp)
  680b92:	48 8b 84 24 b0 03 00 	mov    0x3b0(%rsp),%rax
  680b99:	00 
  680b9a:	8b 74 24 74          	mov    0x74(%rsp),%esi
  680b9e:	48 8b 94 24 a8 03 00 	mov    0x3a8(%rsp),%rdx
  680ba5:	00 
  680ba6:	0f 84 8c db ff ff    	je     67e738 <<gpui_canvas::text::planner::Planner>::shape+0x648>
  680bac:	e9 fb 04 00 00       	jmp    6810ac <<gpui_canvas::text::planner::Planner>::shape+0x2fbc>
  680bb1:	48 8b 0c 24          	mov    (%rsp),%rcx
  680bb5:	48 8b 81 d8 09 00 00 	mov    0x9d8(%rcx),%rax
  680bbc:	48 6b 89 e0 09 00 00 	imul   $0x70,0x9e0(%rcx),%rcx
  680bc3:	70 
  680bc4:	48 01 c1             	add    %rax,%rcx
  680bc7:	48 89 84 24 00 07 00 	mov    %rax,0x700(%rsp)
  680bce:	00 
  680bcf:	48 89 8c 24 08 07 00 	mov    %rcx,0x708(%rsp)
  680bd6:	00 
  680bd7:	48 c7 84 24 10 07 00 	movq   $0x0,0x710(%rsp)
  680bde:	00 00 00 00 00 
  680be3:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  680be8:	48 89 84 24 18 07 00 	mov    %rax,0x718(%rsp)
  680bef:	00 
  680bf0:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  680bf7:	00 
  680bf8:	31 f6                	xor    %esi,%esi
  680bfa:	48 8d 94 24 e7 00 00 	lea    0xe7(%rsp),%rdx
  680c01:	00 
  680c02:	e8 d9 41 fe ff       	call   664de0 <<core::iter::adapters::map::Map<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#3}> as core::iter::traits::iterator::Iterator>::fold::<usize, <core::iter::adapters::flatten::FlattenCompat<_, _>>::iter_fold::flatten<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>, usize, <core::iter::adapters::flatten::FlattenCompat<_, _> as core::iter::traits::iterator::Iterator>::count::count<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>>>::{closure#0}>>
  680c07:	48 83 f8 02          	cmp    $0x2,%rax
  680c0b:	0f 82 cf e1 ff ff    	jb     67ede0 <<gpui_canvas::text::planner::Planner>::shape+0xcf0>
  680c11:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  680c18:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  680c1f:	00 ff 
  680c21:	0f 84 3f e1 ff ff    	je     67ed66 <<gpui_canvas::text::planner::Planner>::shape+0xc76>
  680c27:	e9 b4 e1 ff ff       	jmp    67ede0 <<gpui_canvas::text::planner::Planner>::shape+0xcf0>
  680c2c:	c7 44 24 74 ff ff ff 	movl   $0xffffffff,0x74(%rsp)
  680c33:	ff 
  680c34:	e9 65 dd ff ff       	jmp    67e99e <<gpui_canvas::text::planner::Planner>::shape+0x8ae>
  680c39:	45 89 d9             	mov    %r11d,%r9d
  680c3c:	41 83 e1 1f          	and    $0x1f,%r9d
  680c40:	41 0f b6 7a 01       	movzbl 0x1(%r10),%edi
  680c45:	83 e7 3f             	and    $0x3f,%edi
  680c48:	41 80 fb df          	cmp    $0xdf,%r11b
  680c4c:	76 33                	jbe    680c81 <<gpui_canvas::text::planner::Planner>::shape+0x2b91>
  680c4e:	41 0f b6 72 02       	movzbl 0x2(%r10),%esi
  680c53:	c1 e7 06             	shl    $0x6,%edi
  680c56:	83 e6 3f             	and    $0x3f,%esi
  680c59:	09 fe                	or     %edi,%esi
  680c5b:	41 80 fb f0          	cmp    $0xf0,%r11b
  680c5f:	72 30                	jb     680c91 <<gpui_canvas::text::planner::Planner>::shape+0x2ba1>
  680c61:	4d 8d 72 04          	lea    0x4(%r10),%r14
  680c65:	45 0f b6 5a 03       	movzbl 0x3(%r10),%r11d
  680c6a:	41 83 e1 07          	and    $0x7,%r9d
  680c6e:	41 c1 e1 12          	shl    $0x12,%r9d
  680c72:	c1 e6 06             	shl    $0x6,%esi
  680c75:	41 83 e3 3f          	and    $0x3f,%r11d
  680c79:	41 09 f3             	or     %esi,%r11d
  680c7c:	45 09 cb             	or     %r9d,%r11d
  680c7f:	eb 1e                	jmp    680c9f <<gpui_canvas::text::planner::Planner>::shape+0x2baf>
  680c81:	4d 8d 72 02          	lea    0x2(%r10),%r14
  680c85:	41 c1 e1 06          	shl    $0x6,%r9d
  680c89:	41 09 f9             	or     %edi,%r9d
  680c8c:	45 89 cb             	mov    %r9d,%r11d
  680c8f:	eb 0e                	jmp    680c9f <<gpui_canvas::text::planner::Planner>::shape+0x2baf>
  680c91:	4d 8d 72 03          	lea    0x3(%r10),%r14
  680c95:	41 c1 e1 0c          	shl    $0xc,%r9d
  680c99:	44 09 ce             	or     %r9d,%esi
  680c9c:	41 89 f3             	mov    %esi,%r11d
  680c9f:	4d 8d 48 02          	lea    0x2(%r8),%r9
  680ca3:	4c 89 c1             	mov    %r8,%rcx
  680ca6:	48 89 c6             	mov    %rax,%rsi
  680ca9:	4c 29 d6             	sub    %r10,%rsi
  680cac:	4c 01 f6             	add    %r14,%rsi
  680caf:	41 83 fb 0a          	cmp    $0xa,%r11d
  680cb3:	bf fe ff ff ff       	mov    $0xfffffffe,%edi
  680cb8:	44 0f 44 df          	cmove  %edi,%r11d
  680cbc:	44 89 5c 24 74       	mov    %r11d,0x74(%rsp)
  680cc1:	49 0f 44 d9          	cmove  %r9,%rbx
  680cc5:	c7 44 24 4c 00 00 00 	movl   $0x0,0x4c(%rsp)
  680ccc:	00 
  680ccd:	48 89 84 24 a0 03 00 	mov    %rax,0x3a0(%rsp)
  680cd4:	00 
  680cd5:	48 89 f0             	mov    %rsi,%rax
  680cd8:	4c 89 74 24 18       	mov    %r14,0x18(%rsp)
  680cdd:	48 89 ce             	mov    %rcx,%rsi
  680ce0:	48 29 d6             	sub    %rdx,%rsi
  680ce3:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  680ce8:	0f 83 cc dc ff ff    	jae    67e9ba <<gpui_canvas::text::planner::Planner>::shape+0x8ca>
  680cee:	e9 ed 09 00 00       	jmp    6816e0 <<gpui_canvas::text::planner::Planner>::shape+0x35f0>
  680cf3:	b9 04 00 00 00       	mov    $0x4,%ecx
  680cf8:	41 b8 10 00 00 00    	mov    $0x10,%r8d
  680cfe:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  680d05:	00 
  680d06:	4c 89 ea             	mov    %r13,%rdx
  680d09:	e8 22 0b fe ff       	call   661830 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  680d0e:	e9 35 e2 ff ff       	jmp    67ef48 <<gpui_canvas::text::planner::Planner>::shape+0xe58>
  680d13:	c7 84 24 98 00 00 00 	movl   $0x7,0x98(%rsp)
  680d1a:	07 00 00 00 
  680d1e:	eb 0b                	jmp    680d2b <<gpui_canvas::text::planner::Planner>::shape+0x2c3b>
  680d20:	c7 84 24 98 00 00 00 	movl   $0x4,0x98(%rsp)
  680d27:	04 00 00 00 
  680d2b:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  680d32:	00 ff ff ff ff 
  680d37:	48 8b 2c 24          	mov    (%rsp),%rbp
  680d3b:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  680d42:	00 
  680d43:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  680d47:	74 76                	je     680dbf <<gpui_canvas::text::planner::Planner>::shape+0x2ccf>
  680d49:	48 85 c0             	test   %rax,%rax
  680d4c:	74 1b                	je     680d69 <<gpui_canvas::text::planner::Planner>::shape+0x2c79>
  680d4e:	48 8b bc 24 48 01 00 	mov    0x148(%rsp),%rdi
  680d55:	00 
  680d56:	48 c1 e0 03          	shl    $0x3,%rax
  680d5a:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  680d5e:	ba 04 00 00 00       	mov    $0x4,%edx
  680d63:	ff 15 57 61 10 00    	call   *0x106157(%rip)        # 786ec0 <_DYNAMIC+0x238>
  680d69:	48 8b 84 24 58 01 00 	mov    0x158(%rsp),%rax
  680d70:	00 
  680d71:	48 85 c0             	test   %rax,%rax
  680d74:	74 1b                	je     680d91 <<gpui_canvas::text::planner::Planner>::shape+0x2ca1>
  680d76:	48 8b bc 24 60 01 00 	mov    0x160(%rsp),%rdi
  680d7d:	00 
  680d7e:	48 c1 e0 03          	shl    $0x3,%rax
  680d82:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  680d86:	ba 04 00 00 00       	mov    $0x4,%edx
  680d8b:	ff 15 2f 61 10 00    	call   *0x10612f(%rip)        # 786ec0 <_DYNAMIC+0x238>
  680d91:	48 8b 84 24 70 01 00 	mov    0x170(%rsp),%rax
  680d98:	00 
  680d99:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  680d9d:	74 20                	je     680dbf <<gpui_canvas::text::planner::Planner>::shape+0x2ccf>
  680d9f:	48 85 c0             	test   %rax,%rax
  680da2:	74 1b                	je     680dbf <<gpui_canvas::text::planner::Planner>::shape+0x2ccf>
  680da4:	48 8b bc 24 78 01 00 	mov    0x178(%rsp),%rdi
  680dab:	00 
  680dac:	48 c1 e0 02          	shl    $0x2,%rax
  680db0:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  680db4:	ba 04 00 00 00       	mov    $0x4,%edx
  680db9:	ff 15 01 61 10 00    	call   *0x106101(%rip)        # 786ec0 <_DYNAMIC+0x238>
  680dbf:	48 8b b4 24 e8 00 00 	mov    0xe8(%rsp),%rsi
  680dc6:	00 
  680dc7:	48 85 f6             	test   %rsi,%rsi
  680dca:	74 17                	je     680de3 <<gpui_canvas::text::planner::Planner>::shape+0x2cf3>
  680dcc:	48 8b bc 24 f0 00 00 	mov    0xf0(%rsp),%rdi
  680dd3:	00 
  680dd4:	48 c1 e6 04          	shl    $0x4,%rsi
  680dd8:	ba 04 00 00 00       	mov    $0x4,%edx
  680ddd:	ff 15 dd 60 10 00    	call   *0x1060dd(%rip)        # 786ec0 <_DYNAMIC+0x238>
  680de3:	48 8b b4 24 38 03 00 	mov    0x338(%rsp),%rsi
  680dea:	00 
  680deb:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  680def:	77 18                	ja     680e09 <<gpui_canvas::text::planner::Planner>::shape+0x2d19>
  680df1:	48 85 f6             	test   %rsi,%rsi
  680df4:	74 13                	je     680e09 <<gpui_canvas::text::planner::Planner>::shape+0x2d19>
  680df6:	48 8b bc 24 40 03 00 	mov    0x340(%rsp),%rdi
  680dfd:	00 
  680dfe:	ba 01 00 00 00       	mov    $0x1,%edx
  680e03:	ff 15 b7 60 10 00    	call   *0x1060b7(%rip)        # 786ec0 <_DYNAMIC+0x238>
  680e09:	48 8b b4 24 50 03 00 	mov    0x350(%rsp),%rsi
  680e10:	00 
  680e11:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  680e15:	77 18                	ja     680e2f <<gpui_canvas::text::planner::Planner>::shape+0x2d3f>
  680e17:	48 85 f6             	test   %rsi,%rsi
  680e1a:	74 13                	je     680e2f <<gpui_canvas::text::planner::Planner>::shape+0x2d3f>
  680e1c:	48 8b bc 24 58 03 00 	mov    0x358(%rsp),%rdi
  680e23:	00 
  680e24:	ba 01 00 00 00       	mov    $0x1,%edx
  680e29:	ff 15 91 60 10 00    	call   *0x106091(%rip)        # 786ec0 <_DYNAMIC+0x238>
  680e2f:	48 8b b4 24 68 03 00 	mov    0x368(%rsp),%rsi
  680e36:	00 
  680e37:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  680e3b:	77 18                	ja     680e55 <<gpui_canvas::text::planner::Planner>::shape+0x2d65>
  680e3d:	48 85 f6             	test   %rsi,%rsi
  680e40:	74 13                	je     680e55 <<gpui_canvas::text::planner::Planner>::shape+0x2d65>
  680e42:	48 8b bc 24 70 03 00 	mov    0x370(%rsp),%rdi
  680e49:	00 
  680e4a:	ba 01 00 00 00       	mov    $0x1,%edx
  680e4f:	ff 15 6b 60 10 00    	call   *0x10606b(%rip)        # 786ec0 <_DYNAMIC+0x238>
  680e55:	48 8d bd c8 08 00 00 	lea    0x8c8(%rbp),%rdi
  680e5c:	e8 ef b6 ff ff       	call   67c550 <core::ptr::drop_glue::<parley::layout::layout::Layout<()>>>
  680e61:	48 c7 85 c8 08 00 00 	movq   $0x0,0x8c8(%rbp)
  680e68:	00 00 00 00 
  680e6c:	48 c7 85 d0 08 00 00 	movq   $0x4,0x8d0(%rbp)
  680e73:	04 00 00 00 
  680e77:	0f 57 c0             	xorps  %xmm0,%xmm0
  680e7a:	0f 11 85 d8 08 00 00 	movups %xmm0,0x8d8(%rbp)
  680e81:	48 c7 85 e8 08 00 00 	movq   $0x4,0x8e8(%rbp)
  680e88:	04 00 00 00 
  680e8c:	0f 11 85 f0 08 00 00 	movups %xmm0,0x8f0(%rbp)
  680e93:	48 c7 85 00 09 00 00 	movq   $0x8,0x900(%rbp)
  680e9a:	08 00 00 00 
  680e9e:	0f 11 85 08 09 00 00 	movups %xmm0,0x908(%rbp)
  680ea5:	48 c7 85 18 09 00 00 	movq   $0x8,0x918(%rbp)
  680eac:	08 00 00 00 
  680eb0:	0f 11 85 20 09 00 00 	movups %xmm0,0x920(%rbp)
  680eb7:	48 c7 85 30 09 00 00 	movq   $0x4,0x930(%rbp)
  680ebe:	04 00 00 00 
  680ec2:	0f 11 85 38 09 00 00 	movups %xmm0,0x938(%rbp)
  680ec9:	48 c7 85 48 09 00 00 	movq   $0x4,0x948(%rbp)
  680ed0:	04 00 00 00 
  680ed4:	0f 11 85 50 09 00 00 	movups %xmm0,0x950(%rbp)
  680edb:	48 c7 85 60 09 00 00 	movq   $0x4,0x960(%rbp)
  680ee2:	04 00 00 00 
  680ee6:	0f 11 85 68 09 00 00 	movups %xmm0,0x968(%rbp)
  680eed:	48 c7 85 78 09 00 00 	movq   $0x8,0x978(%rbp)
  680ef4:	08 00 00 00 
  680ef8:	0f 11 85 80 09 00 00 	movups %xmm0,0x980(%rbp)
  680eff:	48 c7 85 90 09 00 00 	movq   $0x2,0x990(%rbp)
  680f06:	02 00 00 00 
  680f0a:	0f 11 85 98 09 00 00 	movups %xmm0,0x998(%rbp)
  680f11:	48 c7 85 a8 09 00 00 	movq   $0x4,0x9a8(%rbp)
  680f18:	04 00 00 00 
  680f1c:	0f 11 85 b0 09 00 00 	movups %xmm0,0x9b0(%rbp)
  680f23:	48 c7 85 c0 09 00 00 	movq   $0x8,0x9c0(%rbp)
  680f2a:	08 00 00 00 
  680f2e:	0f 11 85 c8 09 00 00 	movups %xmm0,0x9c8(%rbp)
  680f35:	48 c7 85 d8 09 00 00 	movq   $0x8,0x9d8(%rbp)
  680f3c:	08 00 00 00 
  680f40:	0f 11 85 e0 09 00 00 	movups %xmm0,0x9e0(%rbp)
  680f47:	48 c7 85 f0 09 00 00 	movq   $0x8,0x9f0(%rbp)
  680f4e:	08 00 00 00 
  680f52:	0f 11 85 f8 09 00 00 	movups %xmm0,0x9f8(%rbp)
  680f59:	48 c7 85 08 0a 00 00 	movq   $0x4,0xa08(%rbp)
  680f60:	04 00 00 00 
  680f64:	0f 11 85 10 0a 00 00 	movups %xmm0,0xa10(%rbp)
  680f6b:	c7 85 20 0a 00 00 00 	movl   $0x3f800000,0xa20(%rbp)
  680f72:	00 80 3f 
  680f75:	0f 11 85 24 0a 00 00 	movups %xmm0,0xa24(%rbp)
  680f7c:	48 c7 85 32 0a 00 00 	movq   $0x0,0xa32(%rbp)
  680f83:	00 00 00 00 
  680f87:	66 c7 85 3a 0a 00 00 	movw   $0xff01,0xa3a(%rbp)
  680f8e:	01 ff 
  680f90:	c6 85 3c 0a 00 00 00 	movb   $0x0,0xa3c(%rbp)
  680f97:	48 8b 8c 24 c0 00 00 	mov    0xc0(%rsp),%rcx
  680f9e:	00 
  680f9f:	48 8b 84 24 c8 03 00 	mov    0x3c8(%rsp),%rax
  680fa6:	00 
  680fa7:	48 89 48 30          	mov    %rcx,0x30(%rax)
  680fab:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  680fb2:	00 
  680fb3:	0f 10 8c 24 a0 00 00 	movups 0xa0(%rsp),%xmm1
  680fba:	00 
  680fbb:	0f 10 94 24 b0 00 00 	movups 0xb0(%rsp),%xmm2
  680fc2:	00 
  680fc3:	0f 11 50 20          	movups %xmm2,0x20(%rax)
  680fc7:	0f 11 48 10          	movups %xmm1,0x10(%rax)
  680fcb:	0f 11 00             	movups %xmm0,(%rax)
  680fce:	48 81 c4 d8 11 00 00 	add    $0x11d8,%rsp
  680fd5:	5b                   	pop    %rbx
  680fd6:	41 5c                	pop    %r12
  680fd8:	41 5d                	pop    %r13
  680fda:	41 5e                	pop    %r14
  680fdc:	41 5f                	pop    %r15
  680fde:	5d                   	pop    %rbp
  680fdf:	c3                   	ret
  680fe0:	48 8d 35 21 8f 10 00 	lea    0x108f21(%rip),%rsi        # 789f08 <gpui_canvas::text::HEBREW_FONT>
  680fe7:	48 8d 15 20 fc 9d ff 	lea    -0x6203e0(%rip),%rdx        # 60c0e <gpui_canvas::text::HEBREW_BYTES>
  680fee:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  680ff5:	00 
  680ff6:	b9 14 69 00 00       	mov    $0x6914,%ecx
  680ffb:	45 31 c0             	xor    %r8d,%r8d
  680ffe:	e8 cd 97 ff ff       	call   67a7d0 <<gpui_canvas::text::FontFace>::shared_static>
  681003:	80 bc 24 00 07 00 00 	cmpb   $0x0,0x700(%rsp)
  68100a:	00 
  68100b:	0f 85 c7 d4 ff ff    	jne    67e4d8 <<gpui_canvas::text::planner::Planner>::shape+0x3e8>
  681011:	4d 8d bd 50 0a 00 00 	lea    0xa50(%r13),%r15
  681018:	4c 8b a4 24 08 07 00 	mov    0x708(%rsp),%r12
  68101f:	00 
  681020:	49 8b 07             	mov    (%r15),%rax
  681023:	48 85 c0             	test   %rax,%rax
  681026:	74 0f                	je     681037 <<gpui_canvas::text::planner::Planner>::shape+0x2f47>
  681028:	f0 48 ff 08          	lock decq (%rax)
  68102c:	75 09                	jne    681037 <<gpui_canvas::text::planner::Planner>::shape+0x2f47>
  68102e:	4c 89 ff             	mov    %r15,%rdi
  681031:	ff 15 b1 5e 10 00    	call   *0x105eb1(%rip)        # 786ee8 <_DYNAMIC+0x260>
  681037:	4d 89 a5 50 0a 00 00 	mov    %r12,0xa50(%r13)
  68103e:	be 02 00 00 00       	mov    $0x2,%esi
  681043:	4c 89 ef             	mov    %r13,%rdi
  681046:	e8 15 0c 00 00       	call   681c60 <<gpui_canvas::text::planner::Planner>::register>
  68104b:	83 f8 ff             	cmp    $0xffffffff,%eax
  68104e:	8b 4c 24 18          	mov    0x18(%rsp),%ecx
  681052:	0f 85 dc d4 ff ff    	jne    67e534 <<gpui_canvas::text::planner::Planner>::shape+0x444>
  681058:	e9 15 d5 ff ff       	jmp    67e572 <<gpui_canvas::text::planner::Planner>::shape+0x482>
  68105d:	c7 84 24 98 00 00 00 	movl   $0x3,0x98(%rsp)
  681064:	03 00 00 00 
  681068:	e9 be fc ff ff       	jmp    680d2b <<gpui_canvas::text::planner::Planner>::shape+0x2c3b>
  68106d:	48 c7 84 24 98 00 00 	movq   $0x3,0x98(%rsp)
  681074:	00 03 00 00 00 
  681079:	e9 ad fc ff ff       	jmp    680d2b <<gpui_canvas::text::planner::Planner>::shape+0x2c3b>
  68107e:	c7 84 24 98 00 00 00 	movl   $0x1,0x98(%rsp)
  681085:	01 00 00 00 
  681089:	e9 9d fc ff ff       	jmp    680d2b <<gpui_canvas::text::planner::Planner>::shape+0x2c3b>
  68108e:	c7 84 24 98 00 00 00 	movl   $0x3,0x98(%rsp)
  681095:	03 00 00 00 
  681099:	8b 84 24 18 02 00 00 	mov    0x218(%rsp),%eax
  6810a0:	89 84 24 9c 00 00 00 	mov    %eax,0x9c(%rsp)
  6810a7:	e9 7f fc ff ff       	jmp    680d2b <<gpui_canvas::text::planner::Planner>::shape+0x2c3b>
  6810ac:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  6810b3:	00 ff 
  6810b5:	48 8b 2c 24          	mov    (%rsp),%rbp
  6810b9:	0f 84 fa 01 00 00    	je     6812b9 <<gpui_canvas::text::planner::Planner>::shape+0x31c9>
  6810bf:	48 8b 84 24 70 01 00 	mov    0x170(%rsp),%rax
  6810c6:	00 
  6810c7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6810cb:	0f 84 aa 03 00 00    	je     68147b <<gpui_canvas::text::planner::Planner>::shape+0x338b>
  6810d1:	48 8b b4 24 80 01 00 	mov    0x180(%rsp),%rsi
  6810d8:	00 
  6810d9:	48 39 f0             	cmp    %rsi,%rax
  6810dc:	0f 86 99 03 00 00    	jbe    68147b <<gpui_canvas::text::planner::Planner>::shape+0x338b>
  6810e2:	48 8d bc 24 70 01 00 	lea    0x170(%rsp),%rdi
  6810e9:	00 
  6810ea:	e8 c1 0d 00 00       	call   681eb0 <<alloc::raw_vec::RawVecInner>::shrink>
  6810ef:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6810f3:	0f 84 82 03 00 00    	je     68147b <<gpui_canvas::text::planner::Planner>::shape+0x338b>
  6810f9:	48 89 c7             	mov    %rax,%rdi
  6810fc:	48 89 d6             	mov    %rdx,%rsi
  6810ff:	ff 15 d3 5e 10 00    	call   *0x105ed3(%rip)        # 786fd8 <_DYNAMIC+0x350>
  681105:	e9 cd 06 00 00       	jmp    6817d7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  68110a:	48 c7 84 24 98 00 00 	movq   $0xc,0x98(%rsp)
  681111:	00 0c 00 00 00 
  681116:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  68111d:	00 ff ff ff ff 
  681122:	48 89 f5             	mov    %rsi,%rbp
  681125:	e9 11 fc ff ff       	jmp    680d3b <<gpui_canvas::text::planner::Planner>::shape+0x2c4b>
  68112a:	48 8b b4 24 00 07 00 	mov    0x700(%rsp),%rsi
  681131:	00 
  681132:	48 85 f6             	test   %rsi,%rsi
  681135:	74 17                	je     68114e <<gpui_canvas::text::planner::Planner>::shape+0x305e>
  681137:	48 8b bc 24 08 07 00 	mov    0x708(%rsp),%rdi
  68113e:	00 
  68113f:	48 c1 e6 03          	shl    $0x3,%rsi
  681143:	ba 08 00 00 00       	mov    $0x8,%edx
  681148:	ff 15 72 5d 10 00    	call   *0x105d72(%rip)        # 786ec0 <_DYNAMIC+0x238>
  68114e:	bb 01 00 00 00       	mov    $0x1,%ebx
  681153:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  681157:	48 8b 2c 24          	mov    (%rsp),%rbp
  68115b:	74 43                	je     6811a0 <<gpui_canvas::text::planner::Planner>::shape+0x30b0>
  68115d:	4d 85 ed             	test   %r13,%r13
  681160:	74 1a                	je     68117c <<gpui_canvas::text::planner::Planner>::shape+0x308c>
  681162:	48 8b bc 24 a8 02 00 	mov    0x2a8(%rsp),%rdi
  681169:	00 
  68116a:	49 c1 e5 04          	shl    $0x4,%r13
  68116e:	ba 04 00 00 00       	mov    $0x4,%edx
  681173:	4c 89 ee             	mov    %r13,%rsi
  681176:	ff 15 44 5d 10 00    	call   *0x105d44(%rip)        # 786ec0 <_DYNAMIC+0x238>
  68117c:	48 8b b4 24 b8 02 00 	mov    0x2b8(%rsp),%rsi
  681183:	00 
  681184:	48 85 f6             	test   %rsi,%rsi
  681187:	74 17                	je     6811a0 <<gpui_canvas::text::planner::Planner>::shape+0x30b0>
  681189:	48 8b bc 24 c0 02 00 	mov    0x2c0(%rsp),%rdi
  681190:	00 
  681191:	48 c1 e6 02          	shl    $0x2,%rsi
  681195:	ba 04 00 00 00       	mov    $0x4,%edx
  68119a:	ff 15 20 5d 10 00    	call   *0x105d20(%rip)        # 786ec0 <_DYNAMIC+0x238>
  6811a0:	89 9c 24 98 00 00 00 	mov    %ebx,0x98(%rsp)
  6811a7:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  6811ae:	00 ff ff ff ff 
  6811b3:	e9 83 fb ff ff       	jmp    680d3b <<gpui_canvas::text::planner::Planner>::shape+0x2c4b>
  6811b8:	48 8b 2c 24          	mov    (%rsp),%rbp
  6811bc:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6811c1:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  6811c6:	eb 24                	jmp    6811ec <<gpui_canvas::text::planner::Planner>::shape+0x30fc>
  6811c8:	4d 89 ce             	mov    %r9,%r14
  6811cb:	45 31 e4             	xor    %r12d,%r12d
  6811ce:	4d 85 f6             	test   %r14,%r14
  6811d1:	74 27                	je     6811fa <<gpui_canvas::text::planner::Planner>::shape+0x310a>
  6811d3:	4d 89 f1             	mov    %r14,%r9
  6811d6:	48 8b 2c 24          	mov    (%rsp),%rbp
  6811da:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6811df:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  6811e4:	48 8b 8c 24 48 02 00 	mov    0x248(%rsp),%rcx
  6811eb:	00 
  6811ec:	49 39 c1             	cmp    %rax,%r9
  6811ef:	73 24                	jae    681215 <<gpui_canvas::text::planner::Planner>::shape+0x3125>
  6811f1:	43 80 3c 08 bf       	cmpb   $0xbf,(%r8,%r9,1)
  6811f6:	7f 22                	jg     68121a <<gpui_canvas::text::planner::Planner>::shape+0x312a>
  6811f8:	eb 4a                	jmp    681244 <<gpui_canvas::text::planner::Planner>::shape+0x3154>
  6811fa:	45 31 c9             	xor    %r9d,%r9d
  6811fd:	48 8b 2c 24          	mov    (%rsp),%rbp
  681201:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  681206:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  68120b:	48 8b 8c 24 48 02 00 	mov    0x248(%rsp),%rcx
  681212:	00 
  681213:	eb 05                	jmp    68121a <<gpui_canvas::text::planner::Planner>::shape+0x312a>
  681215:	49 89 c1             	mov    %rax,%r9
  681218:	75 2a                	jne    681244 <<gpui_canvas::text::planner::Planner>::shape+0x3154>
  68121a:	45 84 e4             	test   %r12b,%r12b
  68121d:	74 15                	je     681234 <<gpui_canvas::text::planner::Planner>::shape+0x3144>
  68121f:	4c 39 c9             	cmp    %r9,%rcx
  681222:	74 20                	je     681244 <<gpui_canvas::text::planner::Planner>::shape+0x3154>
  681224:	43 0f b6 0c 08       	movzbl (%r8,%r9,1),%ecx
  681229:	84 c9                	test   %cl,%cl
  68122b:	78 40                	js     68126d <<gpui_canvas::text::planner::Planner>::shape+0x317d>
  68122d:	b8 0b 00 00 00       	mov    $0xb,%eax
  681232:	eb 1a                	jmp    68124e <<gpui_canvas::text::planner::Planner>::shape+0x315e>
  681234:	48 39 c1             	cmp    %rax,%rcx
  681237:	73 09                	jae    681242 <<gpui_canvas::text::planner::Planner>::shape+0x3152>
  681239:	41 80 3c 08 bf       	cmpb   $0xbf,(%r8,%rcx,1)
  68123e:	7f df                	jg     68121f <<gpui_canvas::text::planner::Planner>::shape+0x312f>
  681240:	eb 02                	jmp    681244 <<gpui_canvas::text::planner::Planner>::shape+0x3154>
  681242:	74 db                	je     68121f <<gpui_canvas::text::planner::Planner>::shape+0x312f>
  681244:	b8 03 00 00 00       	mov    $0x3,%eax
  681249:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  68124e:	89 84 24 98 00 00 00 	mov    %eax,0x98(%rsp)
  681255:	89 8c 24 9c 00 00 00 	mov    %ecx,0x9c(%rsp)
  68125c:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  681263:	00 ff ff ff ff 
  681268:	e9 ce fa ff ff       	jmp    680d3b <<gpui_canvas::text::planner::Planner>::shape+0x2c4b>
  68126d:	89 ca                	mov    %ecx,%edx
  68126f:	83 e2 1f             	and    $0x1f,%edx
  681272:	43 0f b6 7c 08 01    	movzbl 0x1(%r8,%r9,1),%edi
  681278:	83 e7 3f             	and    $0x3f,%edi
  68127b:	b8 0b 00 00 00       	mov    $0xb,%eax
  681280:	80 f9 df             	cmp    $0xdf,%cl
  681283:	76 2b                	jbe    6812b0 <<gpui_canvas::text::planner::Planner>::shape+0x31c0>
  681285:	43 0f b6 74 08 02    	movzbl 0x2(%r8,%r9,1),%esi
  68128b:	c1 e7 06             	shl    $0x6,%edi
  68128e:	83 e6 3f             	and    $0x3f,%esi
  681291:	09 fe                	or     %edi,%esi
  681293:	80 f9 f0             	cmp    $0xf0,%cl
  681296:	72 7a                	jb     681312 <<gpui_canvas::text::planner::Planner>::shape+0x3222>
  681298:	43 0f b6 4c 08 03    	movzbl 0x3(%r8,%r9,1),%ecx
  68129e:	83 e2 07             	and    $0x7,%edx
  6812a1:	c1 e2 12             	shl    $0x12,%edx
  6812a4:	c1 e6 06             	shl    $0x6,%esi
  6812a7:	83 e1 3f             	and    $0x3f,%ecx
  6812aa:	09 f1                	or     %esi,%ecx
  6812ac:	09 d1                	or     %edx,%ecx
  6812ae:	eb 9e                	jmp    68124e <<gpui_canvas::text::planner::Planner>::shape+0x315e>
  6812b0:	c1 e2 06             	shl    $0x6,%edx
  6812b3:	09 fa                	or     %edi,%edx
  6812b5:	89 d1                	mov    %edx,%ecx
  6812b7:	eb 95                	jmp    68124e <<gpui_canvas::text::planner::Planner>::shape+0x315e>
  6812b9:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  6812c0:	00 
  6812c1:	48 85 c0             	test   %rax,%rax
  6812c4:	0f 84 8f 00 00 00    	je     681359 <<gpui_canvas::text::planner::Planner>::shape+0x3269>
  6812ca:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  6812d1:	00 
  6812d2:	48 c1 e0 04          	shl    $0x4,%rax
  6812d6:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  6812db:	2b 54 01 f0          	sub    -0x10(%rcx,%rax,1),%edx
  6812df:	0f 83 81 00 00 00    	jae    681366 <<gpui_canvas::text::planner::Planner>::shape+0x3276>
  6812e5:	c7 84 24 98 00 00 00 	movl   $0x3,0x98(%rsp)
  6812ec:	03 00 00 00 
  6812f0:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  6812f7:	00 ff ff ff ff 
  6812fc:	48 8b b4 24 e8 00 00 	mov    0xe8(%rsp),%rsi
  681303:	00 
  681304:	48 85 f6             	test   %rsi,%rsi
  681307:	0f 85 bf fa ff ff    	jne    680dcc <<gpui_canvas::text::planner::Planner>::shape+0x2cdc>
  68130d:	e9 d1 fa ff ff       	jmp    680de3 <<gpui_canvas::text::planner::Planner>::shape+0x2cf3>
  681312:	c1 e2 0c             	shl    $0xc,%edx
  681315:	09 d6                	or     %edx,%esi
  681317:	89 f1                	mov    %esi,%ecx
  681319:	e9 30 ff ff ff       	jmp    68124e <<gpui_canvas::text::planner::Planner>::shape+0x315e>
  68131e:	48 8d 3d 93 47 9a ff 	lea    -0x65b86d(%rip),%rdi        # 25ab8 <anon.f4165e4923b64ff7e2de5584add5135c.4.llvm.8686550795488547836>
  681325:	48 8d 15 3c af 0f 00 	lea    0xfaf3c(%rip),%rdx        # 77c268 <anon.f4165e4923b64ff7e2de5584add5135c.5.llvm.8686550795488547836>
  68132c:	be ad 00 00 00       	mov    $0xad,%esi
  681331:	ff 15 81 5c 10 00    	call   *0x105c81(%rip)        # 786fb8 <_DYNAMIC+0x330>
  681337:	e9 9b 04 00 00       	jmp    6817d7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  68133c:	48 8d 0d 85 be 0f 00 	lea    0xfbe85(%rip),%rcx        # 77d1c8 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x88>
  681343:	4c 89 ef             	mov    %r13,%rdi
  681346:	48 8b 94 24 30 01 00 	mov    0x130(%rsp),%rdx
  68134d:	00 
  68134e:	ff 15 0c 5e 10 00    	call   *0x105e0c(%rip)        # 787160 <_DYNAMIC+0x4d8>
  681354:	e9 7e 04 00 00       	jmp    6817d7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  681359:	48 83 7c 24 50 00    	cmpq   $0x0,0x50(%rsp)
  68135f:	75 11                	jne    681372 <<gpui_canvas::text::planner::Planner>::shape+0x3282>
  681361:	e9 15 01 00 00       	jmp    68147b <<gpui_canvas::text::planner::Planner>::shape+0x338b>
  681366:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  68136c:	0f 86 bf 02 00 00    	jbe    681631 <<gpui_canvas::text::planner::Planner>::shape+0x3541>
  681372:	bf 04 00 00 00       	mov    $0x4,%edi
  681377:	be 18 00 00 00       	mov    $0x18,%esi
  68137c:	e8 ff 0d 00 00       	call   682180 <alloc::boxed::box_new_uninit>
  681381:	49 89 c7             	mov    %rax,%r15
  681384:	8b 84 24 f8 00 00 00 	mov    0xf8(%rsp),%eax
  68138b:	41 c7 07 00 00 00 00 	movl   $0x0,(%r15)
  681392:	4c 8b 74 24 50       	mov    0x50(%rsp),%r14
  681397:	45 89 77 04          	mov    %r14d,0x4(%r15)
  68139b:	41 c7 47 08 00 00 00 	movl   $0x0,0x8(%r15)
  6813a2:	00 
  6813a3:	41 89 47 0c          	mov    %eax,0xc(%r15)
  6813a7:	41 c7 47 10 00 00 00 	movl   $0x0,0x10(%r15)
  6813ae:	00 
  6813af:	66 41 c7 47 14 00 00 	movw   $0x0,0x14(%r15)
  6813b6:	bf 04 00 00 00       	mov    $0x4,%edi
  6813bb:	be 18 00 00 00       	mov    $0x18,%esi
  6813c0:	e8 bb 0d 00 00       	call   682180 <alloc::boxed::box_new_uninit>
  6813c5:	48 89 c3             	mov    %rax,%rbx
  6813c8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  6813ce:	44 89 70 04          	mov    %r14d,0x4(%rax)
  6813d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  6813d9:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  6813df:	f3 0f 11 40 0c       	movss  %xmm0,0xc(%rax)
  6813e4:	f3 0f 10 44 24 6c    	movss  0x6c(%rsp),%xmm0
  6813ea:	f3 0f 11 40 10       	movss  %xmm0,0x10(%rax)
  6813ef:	0f 28 84 24 80 02 00 	movaps 0x280(%rsp),%xmm0
  6813f6:	00 
  6813f7:	f3 0f 11 40 14       	movss  %xmm0,0x14(%rax)
  6813fc:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  681403:	00 ff 
  681405:	74 0d                	je     681414 <<gpui_canvas::text::planner::Planner>::shape+0x3324>
  681407:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  68140e:	00 
  68140f:	e8 6c c2 ff ff       	call   67d680 <core::ptr::drop_glue::<gpui_canvas::text::layout::TextGeometry>>
  681414:	48 c7 84 24 40 01 00 	movq   $0x1,0x140(%rsp)
  68141b:	00 01 00 00 00 
  681420:	4c 89 bc 24 48 01 00 	mov    %r15,0x148(%rsp)
  681427:	00 
  681428:	48 c7 84 24 50 01 00 	movq   $0x1,0x150(%rsp)
  68142f:	00 01 00 00 00 
  681434:	48 c7 84 24 58 01 00 	movq   $0x1,0x158(%rsp)
  68143b:	00 01 00 00 00 
  681440:	48 89 9c 24 60 01 00 	mov    %rbx,0x160(%rsp)
  681447:	00 
  681448:	48 c7 84 24 68 01 00 	movq   $0x1,0x168(%rsp)
  68144f:	00 01 00 00 00 
  681454:	48 c7 84 24 70 01 00 	movq   $0xffffffffffffffff,0x170(%rsp)
  68145b:	00 ff ff ff ff 
  681460:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  681465:	89 84 24 88 01 00 00 	mov    %eax,0x188(%rsp)
  68146c:	f3 0f 10 44 24 7c    	movss  0x7c(%rsp),%xmm0
  681472:	f3 0f 11 84 24 8c 01 	movss  %xmm0,0x18c(%rsp)
  681479:	00 00 
  68147b:	4c 8b bc 24 e8 00 00 	mov    0xe8(%rsp),%r15
  681482:	00 
  681483:	4c 8b a4 24 f0 00 00 	mov    0xf0(%rsp),%r12
  68148a:	00 
  68148b:	4c 8b b4 24 f8 00 00 	mov    0xf8(%rsp),%r14
  681492:	00 
  681493:	48 89 ef             	mov    %rbp,%rdi
  681496:	48 8b b4 24 08 02 00 	mov    0x208(%rsp),%rsi
  68149d:	00 
  68149e:	e8 7d 06 00 00       	call   681b20 <<gpui_canvas::text::planner::Planner>::font_set>
  6814a3:	49 89 c5             	mov    %rax,%r13
  6814a6:	48 89 84 24 b0 04 00 	mov    %rax,0x4b0(%rsp)
  6814ad:	00 
  6814ae:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  6814b5:	00 
  6814b6:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6814ba:	0f 84 c3 00 00 00    	je     681583 <<gpui_canvas::text::planner::Planner>::shape+0x3493>
  6814c0:	48 8d 94 24 48 01 00 	lea    0x148(%rsp),%rdx
  6814c7:	00 
  6814c8:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
  6814cc:	48 89 8c 24 58 07 00 	mov    %rcx,0x758(%rsp)
  6814d3:	00 
  6814d4:	0f 10 02             	movups (%rdx),%xmm0
  6814d7:	0f 10 4a 10          	movups 0x10(%rdx),%xmm1
  6814db:	0f 10 52 20          	movups 0x20(%rdx),%xmm2
  6814df:	0f 10 5a 30          	movups 0x30(%rdx),%xmm3
  6814e3:	0f 11 9c 24 48 07 00 	movups %xmm3,0x748(%rsp)
  6814ea:	00 
  6814eb:	0f 11 94 24 38 07 00 	movups %xmm2,0x738(%rsp)
  6814f2:	00 
  6814f3:	0f 11 8c 24 28 07 00 	movups %xmm1,0x728(%rsp)
  6814fa:	00 
  6814fb:	0f 11 84 24 18 07 00 	movups %xmm0,0x718(%rsp)
  681502:	00 
  681503:	48 c7 84 24 00 07 00 	movq   $0x1,0x700(%rsp)
  68150a:	00 01 00 00 00 
  68150f:	48 c7 84 24 08 07 00 	movq   $0x1,0x708(%rsp)
  681516:	00 01 00 00 00 
  68151b:	48 8d 9c 24 10 07 00 	lea    0x710(%rsp),%rbx
  681522:	00 
  681523:	48 89 84 24 10 07 00 	mov    %rax,0x710(%rsp)
  68152a:	00 
  68152b:	bf 08 00 00 00       	mov    $0x8,%edi
  681530:	be 60 00 00 00       	mov    $0x60,%esi
  681535:	e8 46 0c 00 00       	call   682180 <alloc::boxed::box_new_uninit>
  68153a:	0f 10 84 24 50 07 00 	movups 0x750(%rsp),%xmm0
  681541:	00 
  681542:	0f 11 40 50          	movups %xmm0,0x50(%rax)
  681546:	0f 10 84 24 40 07 00 	movups 0x740(%rsp),%xmm0
  68154d:	00 
  68154e:	0f 11 40 40          	movups %xmm0,0x40(%rax)
  681552:	0f 10 84 24 00 07 00 	movups 0x700(%rsp),%xmm0
  681559:	00 
  68155a:	0f 10 8c 24 10 07 00 	movups 0x710(%rsp),%xmm1
  681561:	00 
  681562:	0f 10 94 24 20 07 00 	movups 0x720(%rsp),%xmm2
  681569:	00 
  68156a:	0f 10 9c 24 30 07 00 	movups 0x730(%rsp),%xmm3
  681571:	00 
  681572:	0f 11 58 30          	movups %xmm3,0x30(%rax)
  681576:	0f 11 50 20          	movups %xmm2,0x20(%rax)
  68157a:	0f 11 48 10          	movups %xmm1,0x10(%rax)
  68157e:	0f 11 00             	movups %xmm0,(%rax)
  681581:	eb 02                	jmp    681585 <<gpui_canvas::text::planner::Planner>::shape+0x3495>
  681583:	31 c0                	xor    %eax,%eax
  681585:	4c 89 bc 24 90 00 00 	mov    %r15,0x90(%rsp)
  68158c:	00 
  68158d:	4c 89 a4 24 98 00 00 	mov    %r12,0x98(%rsp)
  681594:	00 
  681595:	4c 89 b4 24 a0 00 00 	mov    %r14,0xa0(%rsp)
  68159c:	00 
  68159d:	4c 89 ac 24 a8 00 00 	mov    %r13,0xa8(%rsp)
  6815a4:	00 
  6815a5:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  6815ac:	00 
  6815ad:	0f 28 84 24 80 02 00 	movaps 0x280(%rsp),%xmm0
  6815b4:	00 
  6815b5:	f3 0f 11 84 24 b8 00 	movss  %xmm0,0xb8(%rsp)
  6815bc:	00 00 
  6815be:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  6815c4:	f3 0f 11 84 24 bc 00 	movss  %xmm0,0xbc(%rsp)
  6815cb:	00 00 
  6815cd:	f3 0f 10 44 24 6c    	movss  0x6c(%rsp),%xmm0
  6815d3:	f3 0f 11 84 24 c0 00 	movss  %xmm0,0xc0(%rsp)
  6815da:	00 00 
  6815dc:	f3 0f 10 44 24 7c    	movss  0x7c(%rsp),%xmm0
  6815e2:	f3 0f 11 84 24 c4 00 	movss  %xmm0,0xc4(%rsp)
  6815e9:	00 00 
  6815eb:	48 8d bc 24 38 03 00 	lea    0x338(%rsp),%rdi
  6815f2:	00 
  6815f3:	e8 18 a8 ff ff       	call   67be10 <core::ptr::drop_glue::<[parlance::font_family::FontFamilyName; 3]>>
  6815f8:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  6815fc:	0f 85 95 f9 ff ff    	jne    680f97 <<gpui_canvas::text::planner::Planner>::shape+0x2ea7>
  681602:	e9 4e f8 ff ff       	jmp    680e55 <<gpui_canvas::text::planner::Planner>::shape+0x2d65>
  681607:	41 bc 03 00 00 00    	mov    $0x3,%r12d
  68160d:	8b 84 24 80 00 00 00 	mov    0x80(%rsp),%eax
  681614:	41 89 c7             	mov    %eax,%r15d
  681617:	e9 1e cf ff ff       	jmp    67e53a <<gpui_canvas::text::planner::Planner>::shape+0x44a>
  68161c:	41 bc 03 00 00 00    	mov    $0x3,%r12d
  681622:	8b 84 24 00 01 00 00 	mov    0x100(%rsp),%eax
  681629:	41 89 c7             	mov    %eax,%r15d
  68162c:	e9 09 cf ff ff       	jmp    67e53a <<gpui_canvas::text::planner::Planner>::shape+0x44a>
  681631:	48 01 c1             	add    %rax,%rcx
  681634:	88 51 ff             	mov    %dl,-0x1(%rcx)
  681637:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  68163e:	00 ff 
  681640:	0f 85 79 fa ff ff    	jne    6810bf <<gpui_canvas::text::planner::Planner>::shape+0x2fcf>
  681646:	e9 30 fe ff ff       	jmp    68147b <<gpui_canvas::text::planner::Planner>::shape+0x338b>
  68164b:	48 8d 0d d6 be 0f 00 	lea    0xfbed6(%rip),%rcx        # 77d528 <anon.1151abbc0aa39aee2edfb443bb148018.26.llvm.12564331471646380133>
  681652:	48 89 f7             	mov    %rsi,%rdi
  681655:	48 89 d6             	mov    %rdx,%rsi
  681658:	4c 89 c2             	mov    %r8,%rdx
  68165b:	ff 15 ff 5a 10 00    	call   *0x105aff(%rip)        # 787160 <_DYNAMIC+0x4d8>
  681661:	e9 71 01 00 00       	jmp    6817d7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  681666:	49 89 cd             	mov    %rcx,%r13
  681669:	48 8b 84 24 00 02 00 	mov    0x200(%rsp),%rax
  681670:	00 
  681671:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  681678:	00 
  681679:	48 8d 0d 50 bc 0f 00 	lea    0xfbc50(%rip),%rcx        # 77d2d0 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x190>
  681680:	e9 be fc ff ff       	jmp    681343 <<gpui_canvas::text::planner::Planner>::shape+0x3253>
  681685:	49 89 d5             	mov    %rdx,%r13
  681688:	48 89 9c 24 30 01 00 	mov    %rbx,0x130(%rsp)
  68168f:	00 
  681690:	48 8d 0d 01 bb 0f 00 	lea    0xfbb01(%rip),%rcx        # 77d198 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x58>
  681697:	e9 a7 fc ff ff       	jmp    681343 <<gpui_canvas::text::planner::Planner>::shape+0x3253>
  68169c:	48 8d 0d bd b0 0f 00 	lea    0xfb0bd(%rip),%rcx        # 77c760 <anon.4751b62d855c69562269c18746b5820c.22.llvm.11613928405728550318>
  6816a3:	ff 15 b7 5a 10 00    	call   *0x105ab7(%rip)        # 787160 <_DYNAMIC+0x4d8>
  6816a9:	e9 29 01 00 00       	jmp    6817d7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  6816ae:	48 8d 0d ab b0 0f 00 	lea    0xfb0ab(%rip),%rcx        # 77c760 <anon.4751b62d855c69562269c18746b5820c.22.llvm.11613928405728550318>
  6816b5:	ff 15 a5 5a 10 00    	call   *0x105aa5(%rip)        # 787160 <_DYNAMIC+0x4d8>
  6816bb:	e9 17 01 00 00       	jmp    6817d7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  6816c0:	48 8d 3d f9 ad 0f 00 	lea    0xfadf9(%rip),%rdi        # 77c4c0 <anon.d1c5e71728065e152e7afc2084c95a94.21.llvm.16205762496989061431>
  6816c7:	ff 15 f3 58 10 00    	call   *0x1058f3(%rip)        # 786fc0 <_DYNAMIC+0x338>
  6816cd:	e9 05 01 00 00       	jmp    6817d7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  6816d2:	bb 03 00 00 00       	mov    $0x3,%ebx
  6816d7:	48 8b 2c 24          	mov    (%rsp),%rbp
  6816db:	e9 c0 fa ff ff       	jmp    6811a0 <<gpui_canvas::text::planner::Planner>::shape+0x30b0>
  6816e0:	4c 8d 05 29 bb 0f 00 	lea    0xfbb29(%rip),%r8        # 77d210 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0xd0>
  6816e7:	48 8b bc 24 38 01 00 	mov    0x138(%rsp),%rdi
  6816ee:	00 
  6816ef:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6816f4:	ff 15 46 5c 10 00    	call   *0x105c46(%rip)        # 787340 <_DYNAMIC+0x6b8>
  6816fa:	e9 d8 00 00 00       	jmp    6817d7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  6816ff:	48 8d 05 aa ba 0f 00 	lea    0xfbaaa(%rip),%rax        # 77d1b0 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x70>
  681706:	eb 1f                	jmp    681727 <<gpui_canvas::text::planner::Planner>::shape+0x3637>
  681708:	48 39 d3             	cmp    %rdx,%rbx
  68170b:	48 0f 47 d3          	cmova  %rbx,%rdx
  68170f:	48 8d 05 8a bc 0f 00 	lea    0xfbc8a(%rip),%rax        # 77d3a0 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x260>
  681716:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  68171b:	48 89 d7             	mov    %rdx,%rdi
  68171e:	eb 0c                	jmp    68172c <<gpui_canvas::text::planner::Planner>::shape+0x363c>
  681720:	48 8d 05 49 bb 0f 00 	lea    0xfbb49(%rip),%rax        # 77d270 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x130>
  681727:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  68172c:	48 8b b4 24 d8 01 00 	mov    0x1d8(%rsp),%rsi
  681733:	00 
  681734:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  681739:	ff 15 a9 58 10 00    	call   *0x1058a9(%rip)        # 786fe8 <_DYNAMIC+0x360>
  68173f:	e9 93 00 00 00       	jmp    6817d7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  681744:	48 8d 0d cd be 0f 00 	lea    0xfbecd(%rip),%rcx        # 77d618 <anon.1151abbc0aa39aee2edfb443bb148018.38.llvm.12564331471646380133>
  68174b:	48 89 8c 24 70 02 00 	mov    %rcx,0x270(%rsp)
  681752:	00 
  681753:	eb 04                	jmp    681759 <<gpui_canvas::text::planner::Planner>::shape+0x3669>
  681755:	31 ff                	xor    %edi,%edi
  681757:	31 c0                	xor    %eax,%eax
  681759:	48 89 c6             	mov    %rax,%rsi
  68175c:	48 8b 94 24 70 02 00 	mov    0x270(%rsp),%rdx
  681763:	00 
  681764:	ff 15 7e 58 10 00    	call   *0x10587e(%rip)        # 786fe8 <_DYNAMIC+0x360>
  68176a:	eb 6b                	jmp    6817d7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  68176c:	31 ff                	xor    %edi,%edi
  68176e:	48 c7 84 24 d8 01 00 	movq   $0x0,0x1d8(%rsp)
  681775:	00 00 00 00 00 
  68177a:	eb b0                	jmp    68172c <<gpui_canvas::text::planner::Planner>::shape+0x363c>
  68177c:	48 8d 15 a5 ae 0f 00 	lea    0xfaea5(%rip),%rdx        # 77c628 <anon.d1c5e71728065e152e7afc2084c95a94.38.llvm.16205762496989061431>
  681783:	ff 15 5f 58 10 00    	call   *0x10585f(%rip)        # 786fe8 <_DYNAMIC+0x360>
  681789:	eb 4c                	jmp    6817d7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  68178b:	48 8d 05 f6 bb 0f 00 	lea    0xfbbf6(%rip),%rax        # 77d388 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x248>
  681792:	eb 93                	jmp    681727 <<gpui_canvas::text::planner::Planner>::shape+0x3637>
  681794:	48 89 d7             	mov    %rdx,%rdi
  681797:	48 8d 05 1a bc 0f 00 	lea    0xfbc1a(%rip),%rax        # 77d3b8 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x278>
  68179e:	eb 87                	jmp    681727 <<gpui_canvas::text::planner::Planner>::shape+0x3637>
  6817a0:	48 8d 05 b1 ba 0f 00 	lea    0xfbab1(%rip),%rax        # 77d258 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x118>
  6817a7:	e9 7b ff ff ff       	jmp    681727 <<gpui_canvas::text::planner::Planner>::shape+0x3637>
  6817ac:	48 8d 05 d5 ba 0f 00 	lea    0xfbad5(%rip),%rax        # 77d288 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x148>
  6817b3:	e9 6f ff ff ff       	jmp    681727 <<gpui_canvas::text::planner::Planner>::shape+0x3637>
  6817b8:	48 89 d7             	mov    %rdx,%rdi
  6817bb:	48 8d 05 de ba 0f 00 	lea    0xfbade(%rip),%rax        # 77d2a0 <anon.802d09ffbb264091142cda3ccd9ce6e9.25.llvm.7934801021181108053+0x160>
  6817c2:	e9 60 ff ff ff       	jmp    681727 <<gpui_canvas::text::planner::Planner>::shape+0x3637>
  6817c7:	48 8d 15 4a be 0f 00 	lea    0xfbe4a(%rip),%rdx        # 77d618 <anon.1151abbc0aa39aee2edfb443bb148018.38.llvm.12564331471646380133>
  6817ce:	48 89 c6             	mov    %rax,%rsi
  6817d1:	ff 15 11 58 10 00    	call   *0x105811(%rip)        # 786fe8 <_DYNAMIC+0x360>
  6817d7:	0f 0b                	ud2
  6817d9:	49 89 c6             	mov    %rax,%r14
  6817dc:	be 18 00 00 00       	mov    $0x18,%esi
  6817e1:	ba 04 00 00 00       	mov    $0x4,%edx
  6817e6:	4c 89 ff             	mov    %r15,%rdi
  6817e9:	ff 15 d1 56 10 00    	call   *0x1056d1(%rip)        # 786ec0 <_DYNAMIC+0x238>
  6817ef:	e9 d0 02 00 00       	jmp    681ac4 <<gpui_canvas::text::planner::Planner>::shape+0x39d4>
  6817f4:	e9 84 02 00 00       	jmp    681a7d <<gpui_canvas::text::planner::Planner>::shape+0x398d>
  6817f9:	49 89 c6             	mov    %rax,%r14
  6817fc:	48 89 df             	mov    %rbx,%rdi
  6817ff:	e8 7c be ff ff       	call   67d680 <core::ptr::drop_glue::<gpui_canvas::text::layout::TextGeometry>>
  681804:	f0 49 ff 4d 00       	lock decq 0x0(%r13)
  681809:	75 0e                	jne    681819 <<gpui_canvas::text::planner::Planner>::shape+0x3729>
  68180b:	48 8d bc 24 b0 04 00 	lea    0x4b0(%rsp),%rdi
  681812:	00 
  681813:	ff 15 bf 56 10 00    	call   *0x1056bf(%rip)        # 786ed8 <_DYNAMIC+0x250>
  681819:	31 db                	xor    %ebx,%ebx
  68181b:	eb 10                	jmp    68182d <<gpui_canvas::text::planner::Planner>::shape+0x373d>
  68181d:	ff 15 bd 56 10 00    	call   *0x1056bd(%rip)        # 786ee0 <_DYNAMIC+0x258>
  681823:	e9 55 02 00 00       	jmp    681a7d <<gpui_canvas::text::planner::Planner>::shape+0x398d>
  681828:	49 89 c6             	mov    %rax,%r14
  68182b:	b3 01                	mov    $0x1,%bl
  68182d:	4d 85 ff             	test   %r15,%r15
  681830:	74 15                	je     681847 <<gpui_canvas::text::planner::Planner>::shape+0x3757>
  681832:	49 c1 e7 04          	shl    $0x4,%r15
  681836:	ba 04 00 00 00       	mov    $0x4,%edx
  68183b:	4c 89 e7             	mov    %r12,%rdi
  68183e:	4c 89 fe             	mov    %r15,%rsi
  681841:	ff 15 79 56 10 00    	call   *0x105679(%rip)        # 786ec0 <_DYNAMIC+0x238>
  681847:	84 db                	test   %bl,%bl
  681849:	0f 84 bb 02 00 00    	je     681b0a <<gpui_canvas::text::planner::Planner>::shape+0x3a1a>
  68184f:	31 db                	xor    %ebx,%ebx
  681851:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  681858:	00 ff 
  68185a:	74 48                	je     6818a4 <<gpui_canvas::text::planner::Planner>::shape+0x37b4>
  68185c:	e9 74 02 00 00       	jmp    681ad5 <<gpui_canvas::text::planner::Planner>::shape+0x39e5>
  681861:	e9 17 02 00 00       	jmp    681a7d <<gpui_canvas::text::planner::Planner>::shape+0x398d>
  681866:	49 89 c6             	mov    %rax,%r14
  681869:	4d 89 27             	mov    %r12,(%r15)
  68186c:	4c 89 f7             	mov    %r14,%rdi
  68186f:	e8 ec 95 0f 00       	call   77ae60 <_Unwind_Resume@plt>
  681874:	e9 48 02 00 00       	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  681879:	e9 43 02 00 00       	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  68187e:	e9 3e 02 00 00       	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  681883:	49 89 c6             	mov    %rax,%r14
  681886:	48 8b b4 24 00 07 00 	mov    0x700(%rsp),%rsi
  68188d:	00 
  68188e:	b3 01                	mov    $0x1,%bl
  681890:	48 85 f6             	test   %rsi,%rsi
  681893:	75 1c                	jne    6818b1 <<gpui_canvas::text::planner::Planner>::shape+0x37c1>
  681895:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  68189c:	00 ff 
  68189e:	0f 85 31 02 00 00    	jne    681ad5 <<gpui_canvas::text::planner::Planner>::shape+0x39e5>
  6818a4:	84 db                	test   %bl,%bl
  6818a6:	0f 85 3a 02 00 00    	jne    681ae6 <<gpui_canvas::text::planner::Planner>::shape+0x39f6>
  6818ac:	e9 59 02 00 00       	jmp    681b0a <<gpui_canvas::text::planner::Planner>::shape+0x3a1a>
  6818b1:	48 8b bc 24 08 07 00 	mov    0x708(%rsp),%rdi
  6818b8:	00 
  6818b9:	48 c1 e6 03          	shl    $0x3,%rsi
  6818bd:	ba 08 00 00 00       	mov    $0x8,%edx
  6818c2:	ff 15 f8 55 10 00    	call   *0x1055f8(%rip)        # 786ec0 <_DYNAMIC+0x238>
  6818c8:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  6818cf:	00 ff 
  6818d1:	74 d1                	je     6818a4 <<gpui_canvas::text::planner::Planner>::shape+0x37b4>
  6818d3:	e9 fd 01 00 00       	jmp    681ad5 <<gpui_canvas::text::planner::Planner>::shape+0x39e5>
  6818d8:	e9 a0 01 00 00       	jmp    681a7d <<gpui_canvas::text::planner::Planner>::shape+0x398d>
  6818dd:	e9 df 01 00 00       	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  6818e2:	e9 da 01 00 00       	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  6818e7:	e9 d5 01 00 00       	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  6818ec:	e9 d0 01 00 00       	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  6818f1:	49 89 c6             	mov    %rax,%r14
  6818f4:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  6818fb:	00 
  6818fc:	e8 ef d2 fe ff       	call   66ebf0 <core::ptr::drop_glue::<parley::style::StyleProperty<()>>>
  681901:	e9 be 01 00 00       	jmp    681ac4 <<gpui_canvas::text::planner::Planner>::shape+0x39d4>
  681906:	ff 15 d4 55 10 00    	call   *0x1055d4(%rip)        # 786ee0 <_DYNAMIC+0x258>
  68190c:	49 89 c6             	mov    %rax,%r14
  68190f:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  681916:	00 
  681917:	e8 d4 d2 fe ff       	call   66ebf0 <core::ptr::drop_glue::<parley::style::StyleProperty<()>>>
  68191c:	e9 a3 01 00 00       	jmp    681ac4 <<gpui_canvas::text::planner::Planner>::shape+0x39d4>
  681921:	ff 15 b9 55 10 00    	call   *0x1055b9(%rip)        # 786ee0 <_DYNAMIC+0x258>
  681927:	49 89 c6             	mov    %rax,%r14
  68192a:	48 c7 85 c8 08 00 00 	movq   $0x0,0x8c8(%rbp)
  681931:	00 00 00 00 
  681935:	48 c7 85 d0 08 00 00 	movq   $0x4,0x8d0(%rbp)
  68193c:	04 00 00 00 
  681940:	0f 57 c0             	xorps  %xmm0,%xmm0
  681943:	0f 11 85 d8 08 00 00 	movups %xmm0,0x8d8(%rbp)
  68194a:	48 c7 85 e8 08 00 00 	movq   $0x4,0x8e8(%rbp)
  681951:	04 00 00 00 
  681955:	0f 11 85 f0 08 00 00 	movups %xmm0,0x8f0(%rbp)
  68195c:	48 c7 85 00 09 00 00 	movq   $0x8,0x900(%rbp)
  681963:	08 00 00 00 
  681967:	0f 11 85 08 09 00 00 	movups %xmm0,0x908(%rbp)
  68196e:	48 c7 85 18 09 00 00 	movq   $0x8,0x918(%rbp)
  681975:	08 00 00 00 
  681979:	0f 11 85 20 09 00 00 	movups %xmm0,0x920(%rbp)
  681980:	48 c7 85 30 09 00 00 	movq   $0x4,0x930(%rbp)
  681987:	04 00 00 00 
  68198b:	0f 11 85 38 09 00 00 	movups %xmm0,0x938(%rbp)
  681992:	48 c7 85 48 09 00 00 	movq   $0x4,0x948(%rbp)
  681999:	04 00 00 00 
  68199d:	0f 11 85 50 09 00 00 	movups %xmm0,0x950(%rbp)
  6819a4:	48 c7 85 60 09 00 00 	movq   $0x4,0x960(%rbp)
  6819ab:	04 00 00 00 
  6819af:	0f 11 85 68 09 00 00 	movups %xmm0,0x968(%rbp)
  6819b6:	48 c7 85 78 09 00 00 	movq   $0x8,0x978(%rbp)
  6819bd:	08 00 00 00 
  6819c1:	0f 11 85 80 09 00 00 	movups %xmm0,0x980(%rbp)
  6819c8:	48 c7 85 90 09 00 00 	movq   $0x2,0x990(%rbp)
  6819cf:	02 00 00 00 
  6819d3:	0f 11 85 98 09 00 00 	movups %xmm0,0x998(%rbp)
  6819da:	48 c7 85 a8 09 00 00 	movq   $0x4,0x9a8(%rbp)
  6819e1:	04 00 00 00 
  6819e5:	0f 11 85 b0 09 00 00 	movups %xmm0,0x9b0(%rbp)
  6819ec:	48 c7 85 c0 09 00 00 	movq   $0x8,0x9c0(%rbp)
  6819f3:	08 00 00 00 
  6819f7:	0f 11 85 c8 09 00 00 	movups %xmm0,0x9c8(%rbp)
  6819fe:	48 c7 85 d8 09 00 00 	movq   $0x8,0x9d8(%rbp)
  681a05:	08 00 00 00 
  681a09:	0f 11 85 e0 09 00 00 	movups %xmm0,0x9e0(%rbp)
  681a10:	48 c7 85 f0 09 00 00 	movq   $0x8,0x9f0(%rbp)
  681a17:	08 00 00 00 
  681a1b:	0f 11 85 f8 09 00 00 	movups %xmm0,0x9f8(%rbp)
  681a22:	48 c7 85 08 0a 00 00 	movq   $0x4,0xa08(%rbp)
  681a29:	04 00 00 00 
  681a2d:	0f 11 85 10 0a 00 00 	movups %xmm0,0xa10(%rbp)
  681a34:	c7 85 20 0a 00 00 00 	movl   $0x3f800000,0xa20(%rbp)
  681a3b:	00 80 3f 
  681a3e:	0f 11 85 24 0a 00 00 	movups %xmm0,0xa24(%rbp)
  681a45:	48 c7 85 32 0a 00 00 	movq   $0x0,0xa32(%rbp)
  681a4c:	00 00 00 00 
  681a50:	66 c7 85 3a 0a 00 00 	movw   $0xff01,0xa3a(%rbp)
  681a57:	01 ff 
  681a59:	c6 85 3c 0a 00 00 00 	movb   $0x0,0xa3c(%rbp)
  681a60:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  681a67:	00 
  681a68:	e8 03 a5 ff ff       	call   67bf70 <core::ptr::drop_glue::<core::result::Result<gpui_canvas::text::TextLayout, gpui_canvas::Error>>>
  681a6d:	4c 89 f7             	mov    %r14,%rdi
  681a70:	e8 eb 93 0f 00       	call   77ae60 <_Unwind_Resume@plt>
  681a75:	ff 15 65 54 10 00    	call   *0x105465(%rip)        # 786ee0 <_DYNAMIC+0x258>
  681a7b:	eb 44                	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  681a7d:	49 89 c6             	mov    %rax,%r14
  681a80:	48 8b b4 24 00 07 00 	mov    0x700(%rsp),%rsi
  681a87:	00 
  681a88:	48 85 f6             	test   %rsi,%rsi
  681a8b:	74 17                	je     681aa4 <<gpui_canvas::text::planner::Planner>::shape+0x39b4>
  681a8d:	48 8b bc 24 08 07 00 	mov    0x708(%rsp),%rdi
  681a94:	00 
  681a95:	48 c1 e6 03          	shl    $0x3,%rsi
  681a99:	ba 08 00 00 00       	mov    $0x8,%edx
  681a9e:	ff 15 1c 54 10 00    	call   *0x10541c(%rip)        # 786ec0 <_DYNAMIC+0x238>
  681aa4:	48 8d bc 24 a0 02 00 	lea    0x2a0(%rsp),%rdi
  681aab:	00 
  681aac:	e8 bf a3 ff ff       	call   67be70 <core::ptr::drop_glue::<core::option::Option<parley::editing::geometry::CursorGeometry<()>>>>
  681ab1:	eb 11                	jmp    681ac4 <<gpui_canvas::text::planner::Planner>::shape+0x39d4>
  681ab3:	eb 0c                	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  681ab5:	eb 0a                	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  681ab7:	eb 08                	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  681ab9:	eb 06                	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  681abb:	eb 04                	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  681abd:	eb 02                	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  681abf:	eb 00                	jmp    681ac1 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  681ac1:	49 89 c6             	mov    %rax,%r14
  681ac4:	b3 01                	mov    $0x1,%bl
  681ac6:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  681acd:	00 ff 
  681acf:	0f 84 cf fd ff ff    	je     6818a4 <<gpui_canvas::text::planner::Planner>::shape+0x37b4>
  681ad5:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  681adc:	00 
  681add:	e8 9e bb ff ff       	call   67d680 <core::ptr::drop_glue::<gpui_canvas::text::layout::TextGeometry>>
  681ae2:	84 db                	test   %bl,%bl
  681ae4:	74 24                	je     681b0a <<gpui_canvas::text::planner::Planner>::shape+0x3a1a>
  681ae6:	48 8b b4 24 e8 00 00 	mov    0xe8(%rsp),%rsi
  681aed:	00 
  681aee:	48 85 f6             	test   %rsi,%rsi
  681af1:	74 17                	je     681b0a <<gpui_canvas::text::planner::Planner>::shape+0x3a1a>
  681af3:	48 8b bc 24 f0 00 00 	mov    0xf0(%rsp),%rdi
  681afa:	00 
  681afb:	48 c1 e6 04          	shl    $0x4,%rsi
  681aff:	ba 04 00 00 00       	mov    $0x4,%edx
  681b04:	ff 15 b6 53 10 00    	call   *0x1053b6(%rip)        # 786ec0 <_DYNAMIC+0x238>
  681b0a:	48 8d bc 24 38 03 00 	lea    0x338(%rsp),%rdi
  681b11:	00 
  681b12:	e8 f9 a2 ff ff       	call   67be10 <core::ptr::drop_glue::<[parlance::font_family::FontFamilyName; 3]>>
  681b17:	4c 89 f7             	mov    %r14,%rdi
  681b1a:	e8 41 93 0f 00       	call   77ae60 <_Unwind_Resume@plt>
