
/tmp/gpui-caret-transaction-bin/matched-indexed-owner:     file format elf64-x86-64


Disassembly of section .text:

000000000080e0c0 <<gpui_canvas::text::planner::Planner>::shape>:
  80e0c0:	55                   	push   %rbp
  80e0c1:	41 57                	push   %r15
  80e0c3:	41 56                	push   %r14
  80e0c5:	41 55                	push   %r13
  80e0c7:	41 54                	push   %r12
  80e0c9:	53                   	push   %rbx
  80e0ca:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  80e0d1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80e0d8:	00 
  80e0d9:	48 81 ec d8 01 00 00 	sub    $0x1d8,%rsp
  80e0e0:	44 89 8c 24 2c 02 00 	mov    %r9d,0x22c(%rsp)
  80e0e7:	00 
  80e0e8:	f3 0f 11 8c 24 bc 01 	movss  %xmm1,0x1bc(%rsp)
  80e0ef:	00 00 
  80e0f1:	44 89 84 24 b8 01 00 	mov    %r8d,0x1b8(%rsp)
  80e0f8:	00 
  80e0f9:	f3 0f 11 44 24 7c    	movss  %xmm0,0x7c(%rsp)
  80e0ff:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  80e104:	49 89 f5             	mov    %rsi,%r13
  80e107:	48 89 bc 24 c8 03 00 	mov    %rdi,0x3c8(%rsp)
  80e10e:	00 
  80e10f:	48 8d 04 0a          	lea    (%rdx,%rcx,1),%rax
  80e113:	48 89 84 24 a0 01 00 	mov    %rax,0x1a0(%rsp)
  80e11a:	00 
  80e11b:	48 85 c9             	test   %rcx,%rcx
  80e11e:	48 89 34 24          	mov    %rsi,(%rsp)
  80e122:	48 89 94 24 38 01 00 	mov    %rdx,0x138(%rsp)
  80e129:	00 
  80e12a:	0f 84 8a 03 00 00    	je     80e4ba <<gpui_canvas::text::planner::Planner>::shape+0x3fa>
  80e130:	49 8d 85 78 0a 00 00 	lea    0xa78(%r13),%rax
  80e137:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  80e13c:	4c 8d a4 24 dc 0c 00 	lea    0xcdc(%rsp),%r12
  80e143:	00 
  80e144:	49 8d 45 38          	lea    0x38(%r13),%rax
  80e148:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  80e14d:	49 8d 45 3c          	lea    0x3c(%r13),%rax
  80e151:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  80e156:	49 8d 45 58          	lea    0x58(%r13),%rax
  80e15a:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  80e15f:	49 8d 45 5c          	lea    0x5c(%r13),%rax
  80e163:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  80e16a:	00 
  80e16b:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%rsp)
  80e172:	00 
  80e173:	48 8d b4 24 00 07 00 	lea    0x700(%rsp),%rsi
  80e17a:	00 
  80e17b:	4c 8b 05 56 dd 31 00 	mov    0x31dd56(%rip),%r8        # b2bed8 <_DYNAMIC+0x1208>
  80e182:	49 89 d6             	mov    %rdx,%r14
  80e185:	eb 27                	jmp    80e1ae <<gpui_canvas::text::planner::Planner>::shape+0xee>
  80e187:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  80e18e:	00 00 
  80e190:	41 8d 87 d8 df ff ff 	lea    -0x2028(%r15),%eax
  80e197:	83 f8 02             	cmp    $0x2,%eax
  80e19a:	0f 83 e1 00 00 00    	jae    80e281 <<gpui_canvas::text::planner::Planner>::shape+0x1c1>
  80e1a0:	4c 3b b4 24 a0 01 00 	cmp    0x1a0(%rsp),%r14
  80e1a7:	00 
  80e1a8:	0f 84 ae 02 00 00    	je     80e45c <<gpui_canvas::text::planner::Planner>::shape+0x39c>
  80e1ae:	45 0f b6 3e          	movzbl (%r14),%r15d
  80e1b2:	45 84 ff             	test   %r15b,%r15b
  80e1b5:	78 19                	js     80e1d0 <<gpui_canvas::text::planner::Planner>::shape+0x110>
  80e1b7:	49 ff c6             	inc    %r14
  80e1ba:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  80e1c1:	0f 8e 99 00 00 00    	jle    80e260 <<gpui_canvas::text::planner::Planner>::shape+0x1a0>
  80e1c7:	eb c7                	jmp    80e190 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  80e1c9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  80e1d0:	44 89 f8             	mov    %r15d,%eax
  80e1d3:	83 e0 1f             	and    $0x1f,%eax
  80e1d6:	41 0f b6 56 01       	movzbl 0x1(%r14),%edx
  80e1db:	83 e2 3f             	and    $0x3f,%edx
  80e1de:	41 80 ff df          	cmp    $0xdf,%r15b
  80e1e2:	76 3d                	jbe    80e221 <<gpui_canvas::text::planner::Planner>::shape+0x161>
  80e1e4:	41 0f b6 4e 02       	movzbl 0x2(%r14),%ecx
  80e1e9:	c1 e2 06             	shl    $0x6,%edx
  80e1ec:	83 e1 3f             	and    $0x3f,%ecx
  80e1ef:	09 d1                	or     %edx,%ecx
  80e1f1:	41 80 ff f0          	cmp    $0xf0,%r15b
  80e1f5:	72 44                	jb     80e23b <<gpui_canvas::text::planner::Planner>::shape+0x17b>
  80e1f7:	45 0f b6 7e 03       	movzbl 0x3(%r14),%r15d
  80e1fc:	49 83 c6 04          	add    $0x4,%r14
  80e200:	83 e0 07             	and    $0x7,%eax
  80e203:	c1 e0 12             	shl    $0x12,%eax
  80e206:	c1 e1 06             	shl    $0x6,%ecx
  80e209:	41 83 e7 3f          	and    $0x3f,%r15d
  80e20d:	41 09 cf             	or     %ecx,%r15d
  80e210:	41 09 c7             	or     %eax,%r15d
  80e213:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  80e21a:	7e 44                	jle    80e260 <<gpui_canvas::text::planner::Planner>::shape+0x1a0>
  80e21c:	e9 6f ff ff ff       	jmp    80e190 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  80e221:	49 83 c6 02          	add    $0x2,%r14
  80e225:	c1 e0 06             	shl    $0x6,%eax
  80e228:	09 d0                	or     %edx,%eax
  80e22a:	41 89 c7             	mov    %eax,%r15d
  80e22d:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  80e234:	7e 2a                	jle    80e260 <<gpui_canvas::text::planner::Planner>::shape+0x1a0>
  80e236:	e9 55 ff ff ff       	jmp    80e190 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  80e23b:	49 83 c6 03          	add    $0x3,%r14
  80e23f:	c1 e0 0c             	shl    $0xc,%eax
  80e242:	09 c1                	or     %eax,%ecx
  80e244:	41 89 cf             	mov    %ecx,%r15d
  80e247:	41 81 ff 27 20 00 00 	cmp    $0x2027,%r15d
  80e24e:	0f 8f 3c ff ff ff    	jg     80e190 <<gpui_canvas::text::planner::Planner>::shape+0xd0>
  80e254:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  80e25b:	00 00 00 00 00 
  80e260:	41 83 ff 0a          	cmp    $0xa,%r15d
  80e264:	0f 84 36 ff ff ff    	je     80e1a0 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  80e26a:	41 83 ff 0d          	cmp    $0xd,%r15d
  80e26e:	0f 84 2c ff ff ff    	je     80e1a0 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  80e274:	41 81 ff 85 00 00 00 	cmp    $0x85,%r15d
  80e27b:	0f 84 1f ff ff ff    	je     80e1a0 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  80e281:	49 89 f5             	mov    %rsi,%r13
  80e284:	48 8d 3d f5 7f 2f 00 	lea    0x2f7ff5(%rip),%rdi        # b06280 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x468>
  80e28b:	44 89 fe             	mov    %r15d,%esi
  80e28e:	4c 89 c3             	mov    %r8,%rbx
  80e291:	ff 15 a9 dc 31 00    	call   *0x31dca9(%rip)        # b2bf40 <_DYNAMIC+0x1270>
  80e297:	49 89 d8             	mov    %rbx,%r8
  80e29a:	4c 89 ee             	mov    %r13,%rsi
  80e29d:	84 c0                	test   %al,%al
  80e29f:	0f 85 fb fe ff ff    	jne    80e1a0 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  80e2a5:	4c 89 e5             	mov    %r12,%rbp
  80e2a8:	41 bc 0a 00 00 00    	mov    $0xa,%r12d
  80e2ae:	41 83 ff 20          	cmp    $0x20,%r15d
  80e2b2:	0f 82 52 02 00 00    	jb     80e50a <<gpui_canvas::text::planner::Planner>::shape+0x44a>
  80e2b8:	41 8d 47 81          	lea    -0x7f(%r15),%eax
  80e2bc:	83 f8 21             	cmp    $0x21,%eax
  80e2bf:	0f 82 45 02 00 00    	jb     80e50a <<gpui_canvas::text::planner::Planner>::shape+0x44a>
  80e2c5:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  80e2ca:	44 89 fe             	mov    %r15d,%esi
  80e2cd:	e8 5e 3c 00 00       	call   811f30 <<gpui_canvas::text::planner::Cmap>::glyph_index>
  80e2d2:	49 89 d8             	mov    %rbx,%r8
  80e2d5:	4c 89 ee             	mov    %r13,%rsi
  80e2d8:	a8 01                	test   $0x1,%al
  80e2da:	74 0c                	je     80e2e8 <<gpui_canvas::text::planner::Planner>::shape+0x228>
  80e2dc:	49 89 ec             	mov    %rbp,%r12
  80e2df:	66 85 d2             	test   %dx,%dx
  80e2e2:	0f 85 b8 fe ff ff    	jne    80e1a0 <<gpui_canvas::text::planner::Planner>::shape+0xe0>
  80e2e8:	48 8b 0c 24          	mov    (%rsp),%rcx
  80e2ec:	48 8b 81 40 0a 00 00 	mov    0xa40(%rcx),%rax
  80e2f3:	41 bc 0b 00 00 00    	mov    $0xb,%r12d
  80e2f9:	80 78 38 01          	cmpb   $0x1,0x38(%rax)
  80e2fd:	0f 85 07 02 00 00    	jne    80e50a <<gpui_canvas::text::planner::Planner>::shape+0x44a>
  80e303:	48 83 79 30 00       	cmpq   $0x0,0x30(%rcx)
  80e308:	0f 85 f3 00 00 00    	jne    80e401 <<gpui_canvas::text::planner::Planner>::shape+0x341>
  80e30e:	ba 48 ab 03 00       	mov    $0x3ab48,%edx
  80e313:	48 89 f7             	mov    %rsi,%rdi
  80e316:	48 8d 35 b8 89 8f ff 	lea    -0x707648(%rip),%rsi        # 106cd5 <gpui_canvas::text::ARABIC_BYTES>
  80e31d:	31 c9                	xor    %ecx,%ecx
  80e31f:	41 ff d0             	call   *%r8
  80e322:	83 bc 24 00 07 00 00 	cmpl   $0xffffffff,0x700(%rsp)
  80e329:	ff 
  80e32a:	0f 84 a7 32 00 00    	je     8115d7 <<gpui_canvas::text::planner::Planner>::shape+0x3517>
  80e330:	8b 84 24 d8 0c 00 00 	mov    0xcd8(%rsp),%eax
  80e337:	89 84 24 80 00 00 00 	mov    %eax,0x80(%rsp)
  80e33e:	0f 10 45 00          	movups 0x0(%rbp),%xmm0
  80e342:	0f 10 4d 0c          	movups 0xc(%rbp),%xmm1
  80e346:	0f 29 84 24 b0 04 00 	movaps %xmm0,0x4b0(%rsp)
  80e34d:	00 
  80e34e:	0f 11 8c 24 bc 04 00 	movups %xmm1,0x4bc(%rsp)
  80e355:	00 
  80e356:	ba 14 69 00 00       	mov    $0x6914,%edx
  80e35b:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  80e362:	00 
  80e363:	48 8d 35 b3 34 93 ff 	lea    -0x6ccb4d(%rip),%rsi        # 14181d <gpui_canvas::text::HEBREW_BYTES>
  80e36a:	31 c9                	xor    %ecx,%ecx
  80e36c:	ff 15 66 db 31 00    	call   *0x31db66(%rip)        # b2bed8 <_DYNAMIC+0x1208>
  80e372:	83 bc 24 00 07 00 00 	cmpl   $0xffffffff,0x700(%rsp)
  80e379:	ff 
  80e37a:	0f 84 6c 32 00 00    	je     8115ec <<gpui_canvas::text::planner::Planner>::shape+0x352c>
  80e380:	8b 94 24 d8 0c 00 00 	mov    0xcd8(%rsp),%edx
  80e387:	48 8d 84 24 dc 0c 00 	lea    0xcdc(%rsp),%rax
  80e38e:	00 
  80e38f:	0f 10 00             	movups (%rax),%xmm0
  80e392:	0f 10 48 0c          	movups 0xc(%rax),%xmm1
  80e396:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
  80e39d:	00 
  80e39e:	0f 11 8c 24 ac 02 00 	movups %xmm1,0x2ac(%rsp)
  80e3a5:	00 
  80e3a6:	48 8b 04 24          	mov    (%rsp),%rax
  80e3aa:	48 c7 40 30 01 00 00 	movq   $0x1,0x30(%rax)
  80e3b1:	00 
  80e3b2:	8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%ecx
  80e3b9:	89 48 38             	mov    %ecx,0x38(%rax)
  80e3bc:	0f 10 84 24 bc 04 00 	movups 0x4bc(%rsp),%xmm0
  80e3c3:	00 
  80e3c4:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  80e3c9:	0f 11 41 0c          	movups %xmm0,0xc(%rcx)
  80e3cd:	0f 28 84 24 b0 04 00 	movaps 0x4b0(%rsp),%xmm0
  80e3d4:	00 
  80e3d5:	0f 11 01             	movups %xmm0,(%rcx)
  80e3d8:	89 94 24 00 01 00 00 	mov    %edx,0x100(%rsp)
  80e3df:	89 50 58             	mov    %edx,0x58(%rax)
  80e3e2:	0f 10 84 24 ac 02 00 	movups 0x2ac(%rsp),%xmm0
  80e3e9:	00 
  80e3ea:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  80e3f1:	00 
  80e3f2:	0f 11 40 0c          	movups %xmm0,0xc(%rax)
  80e3f6:	0f 28 84 24 a0 02 00 	movaps 0x2a0(%rsp),%xmm0
  80e3fd:	00 
  80e3fe:	0f 11 00             	movups %xmm0,(%rax)
  80e401:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  80e406:	44 89 fe             	mov    %r15d,%esi
  80e409:	e8 22 3b 00 00       	call   811f30 <<gpui_canvas::text::planner::Cmap>::glyph_index>
  80e40e:	66 85 d2             	test   %dx,%dx
  80e411:	0f 95 c1             	setne  %cl
  80e414:	20 c1                	and    %al,%cl
  80e416:	88 4c 24 10          	mov    %cl,0x10(%rsp)
  80e41a:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  80e41f:	44 89 fe             	mov    %r15d,%esi
  80e422:	e8 09 3b 00 00       	call   811f30 <<gpui_canvas::text::planner::Cmap>::glyph_index>
  80e427:	66 85 d2             	test   %dx,%dx
  80e42a:	0f 95 c1             	setne  %cl
  80e42d:	20 c1                	and    %al,%cl
  80e42f:	00 c9                	add    %cl,%cl
  80e431:	0a 4c 24 10          	or     0x10(%rsp),%cl
  80e435:	0f 84 cf 00 00 00    	je     80e50a <<gpui_canvas::text::planner::Planner>::shape+0x44a>
  80e43b:	8b 44 24 18          	mov    0x18(%rsp),%eax
  80e43f:	08 c8                	or     %cl,%al
  80e441:	89 44 24 18          	mov    %eax,0x18(%rsp)
  80e445:	4c 3b b4 24 a0 01 00 	cmp    0x1a0(%rsp),%r14
  80e44c:	00 
  80e44d:	49 89 ec             	mov    %rbp,%r12
  80e450:	4c 89 ee             	mov    %r13,%rsi
  80e453:	49 89 d8             	mov    %rbx,%r8
  80e456:	0f 85 52 fd ff ff    	jne    80e1ae <<gpui_canvas::text::planner::Planner>::shape+0xee>
  80e45c:	8b 4c 24 18          	mov    0x18(%rsp),%ecx
  80e460:	f6 c1 01             	test   $0x1,%cl
  80e463:	4c 8b 2c 24          	mov    (%rsp),%r13
  80e467:	0f 84 c2 00 00 00    	je     80e52f <<gpui_canvas::text::planner::Planner>::shape+0x46f>
  80e46d:	49 83 bd 48 0a 00 00 	cmpq   $0x0,0xa48(%r13)
  80e474:	00 
  80e475:	0f 85 b4 00 00 00    	jne    80e52f <<gpui_canvas::text::planner::Planner>::shape+0x46f>
  80e47b:	48 8d 35 a6 13 32 00 	lea    0x3213a6(%rip),%rsi        # b2f828 <gpui_canvas::text::ARABIC_FONT>
  80e482:	48 8d 15 4c 88 8f ff 	lea    -0x7077b4(%rip),%rdx        # 106cd5 <gpui_canvas::text::ARABIC_BYTES>
  80e489:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  80e490:	00 
  80e491:	b9 48 ab 03 00       	mov    $0x3ab48,%ecx
  80e496:	45 31 c0             	xor    %r8d,%r8d
  80e499:	e8 72 b2 ff ff       	call   809710 <<gpui_canvas::text::FontFace>::shared_static>
  80e49e:	83 bc 24 00 07 00 00 	cmpl   $0x1,0x700(%rsp)
  80e4a5:	01 
  80e4a6:	75 19                	jne    80e4c1 <<gpui_canvas::text::planner::Planner>::shape+0x401>
  80e4a8:	44 8b a4 24 04 07 00 	mov    0x704(%rsp),%r12d
  80e4af:	00 
  80e4b0:	44 8b bc 24 08 07 00 	mov    0x708(%rsp),%r15d
  80e4b7:	00 
  80e4b8:	eb 50                	jmp    80e50a <<gpui_canvas::text::planner::Planner>::shape+0x44a>
  80e4ba:	31 c9                	xor    %ecx,%ecx
  80e4bc:	e9 81 00 00 00       	jmp    80e542 <<gpui_canvas::text::planner::Planner>::shape+0x482>
  80e4c1:	4d 8d bd 48 0a 00 00 	lea    0xa48(%r13),%r15
  80e4c8:	4c 8b a4 24 08 07 00 	mov    0x708(%rsp),%r12
  80e4cf:	00 
  80e4d0:	49 8b 07             	mov    (%r15),%rax
  80e4d3:	48 85 c0             	test   %rax,%rax
  80e4d6:	74 0f                	je     80e4e7 <<gpui_canvas::text::planner::Planner>::shape+0x427>
  80e4d8:	f0 48 ff 08          	lock decq (%rax)
  80e4dc:	75 09                	jne    80e4e7 <<gpui_canvas::text::planner::Planner>::shape+0x427>
  80e4de:	4c 89 ff             	mov    %r15,%rdi
  80e4e1:	ff 15 e1 ca 31 00    	call   *0x31cae1(%rip)        # b2afc8 <_DYNAMIC+0x2f8>
  80e4e7:	4d 89 a5 48 0a 00 00 	mov    %r12,0xa48(%r13)
  80e4ee:	be 01 00 00 00       	mov    $0x1,%esi
  80e4f3:	4c 89 ef             	mov    %r13,%rdi
  80e4f6:	e8 35 37 00 00       	call   811c30 <<gpui_canvas::text::planner::Planner>::register>
  80e4fb:	83 f8 ff             	cmp    $0xffffffff,%eax
  80e4fe:	8b 4c 24 18          	mov    0x18(%rsp),%ecx
  80e502:	74 2b                	je     80e52f <<gpui_canvas::text::planner::Planner>::shape+0x46f>
  80e504:	41 89 c4             	mov    %eax,%r12d
  80e507:	45 31 ff             	xor    %r15d,%r15d
  80e50a:	44 89 a4 24 98 00 00 	mov    %r12d,0x98(%rsp)
  80e511:	00 
  80e512:	44 89 bc 24 9c 00 00 	mov    %r15d,0x9c(%rsp)
  80e519:	00 
  80e51a:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  80e521:	00 ff ff ff ff 
  80e526:	48 8b 2c 24          	mov    (%rsp),%rbp
  80e52a:	e9 f6 28 00 00       	jmp    810e25 <<gpui_canvas::text::planner::Planner>::shape+0x2d65>
  80e52f:	f6 c1 02             	test   $0x2,%cl
  80e532:	74 0e                	je     80e542 <<gpui_canvas::text::planner::Planner>::shape+0x482>
  80e534:	49 83 bd 50 0a 00 00 	cmpq   $0x0,0xa50(%r13)
  80e53b:	00 
  80e53c:	0f 84 6e 2a 00 00    	je     810fb0 <<gpui_canvas::text::planner::Planner>::shape+0x2ef0>
  80e542:	48 c7 84 24 38 03 00 	movq   $0xffffffffffffffff,0x338(%rsp)
  80e549:	00 ff ff ff ff 
  80e54e:	48 8d 05 d5 e0 b2 ff 	lea    -0x4d1f2b(%rip),%rax        # 33c62a <gpui_canvas::text::PRIMARY_BYTES+0x1f44f9>
  80e555:	48 89 84 24 40 03 00 	mov    %rax,0x340(%rsp)
  80e55c:	00 
  80e55d:	48 c7 84 24 48 03 00 	movq   $0xc,0x348(%rsp)
  80e564:	00 0c 00 00 00 
  80e569:	48 c7 84 24 50 03 00 	movq   $0xffffffffffffffff,0x350(%rsp)
  80e570:	00 ff ff ff ff 
  80e575:	48 8d 05 ba e0 b2 ff 	lea    -0x4d1f46(%rip),%rax        # 33c636 <gpui_canvas::text::PRIMARY_BYTES+0x1f4505>
  80e57c:	48 89 84 24 58 03 00 	mov    %rax,0x358(%rsp)
  80e583:	00 
  80e584:	48 c7 84 24 60 03 00 	movq   $0x11,0x360(%rsp)
  80e58b:	00 11 00 00 00 
  80e590:	48 c7 84 24 68 03 00 	movq   $0xffffffffffffffff,0x368(%rsp)
  80e597:	00 ff ff ff ff 
  80e59c:	4c 8d 35 a4 e0 b2 ff 	lea    -0x4d1f5c(%rip),%r14        # 33c647 <gpui_canvas::text::PRIMARY_BYTES+0x1f4516>
  80e5a3:	4c 89 b4 24 70 03 00 	mov    %r14,0x370(%rsp)
  80e5aa:	00 
  80e5ab:	48 c7 84 24 78 03 00 	movq   $0x11,0x378(%rsp)
  80e5b2:	00 11 00 00 00 
  80e5b7:	f6 c1 01             	test   $0x1,%cl
  80e5ba:	75 1c                	jne    80e5d8 <<gpui_canvas::text::planner::Planner>::shape+0x518>
  80e5bc:	4c 8d bc 24 50 03 00 	lea    0x350(%rsp),%r15
  80e5c3:	00 
  80e5c4:	b8 01 00 00 00       	mov    $0x1,%eax
  80e5c9:	48 89 84 24 10 02 00 	mov    %rax,0x210(%rsp)
  80e5d0:	00 
  80e5d1:	f6 c1 02             	test   $0x2,%cl
  80e5d4:	75 24                	jne    80e5fa <<gpui_canvas::text::planner::Planner>::shape+0x53a>
  80e5d6:	eb 5a                	jmp    80e632 <<gpui_canvas::text::planner::Planner>::shape+0x572>
  80e5d8:	4c 8d bc 24 68 03 00 	lea    0x368(%rsp),%r15
  80e5df:	00 
  80e5e0:	48 89 84 24 58 03 00 	mov    %rax,0x358(%rsp)
  80e5e7:	00 
  80e5e8:	b8 02 00 00 00       	mov    $0x2,%eax
  80e5ed:	48 89 84 24 10 02 00 	mov    %rax,0x210(%rsp)
  80e5f4:	00 
  80e5f5:	f6 c1 02             	test   $0x2,%cl
  80e5f8:	74 38                	je     80e632 <<gpui_canvas::text::planner::Planner>::shape+0x572>
  80e5fa:	49 8b 37             	mov    (%r15),%rsi
  80e5fd:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  80e601:	77 14                	ja     80e617 <<gpui_canvas::text::planner::Planner>::shape+0x557>
  80e603:	48 85 f6             	test   %rsi,%rsi
  80e606:	74 0f                	je     80e617 <<gpui_canvas::text::planner::Planner>::shape+0x557>
  80e608:	49 8b 7f 08          	mov    0x8(%r15),%rdi
  80e60c:	ba 01 00 00 00       	mov    $0x1,%edx
  80e611:	ff 15 01 c9 31 00    	call   *0x31c901(%rip)        # b2af18 <_DYNAMIC+0x248>
  80e617:	49 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%r15)
  80e61e:	4d 89 77 08          	mov    %r14,0x8(%r15)
  80e622:	49 c7 47 10 11 00 00 	movq   $0x11,0x10(%r15)
  80e629:	00 
  80e62a:	48 ff 84 24 10 02 00 	incq   0x210(%rsp)
  80e631:	00 
  80e632:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  80e639:	00 00 00 00 00 
  80e63e:	48 c7 84 24 f0 00 00 	movq   $0x4,0xf0(%rsp)
  80e645:	00 04 00 00 00 
  80e64a:	48 c7 84 24 f8 00 00 	movq   $0x0,0xf8(%rsp)
  80e651:	00 00 00 00 00 
  80e656:	48 c7 84 24 40 01 00 	movq   $0xffffffffffffffff,0x140(%rsp)
  80e65d:	00 ff ff ff ff 
  80e662:	f6 84 24 b8 01 00 00 	testb  $0x1,0x1b8(%rsp)
  80e669:	01 
  80e66a:	75 11                	jne    80e67d <<gpui_canvas::text::planner::Planner>::shape+0x5bd>
  80e66c:	f3 0f 10 05 28 10 8f 	movss  -0x70efd8(%rip),%xmm0        # ff69c <anon.5923aa265a9ec0a4213c70985337b2b1.13.llvm.1364676386607977936+0x44>
  80e673:	ff 
  80e674:	f3 0f 11 84 24 bc 01 	movss  %xmm0,0x1bc(%rsp)
  80e67b:	00 00 
  80e67d:	49 8d 45 78          	lea    0x78(%r13),%rax
  80e681:	48 89 84 24 c0 03 00 	mov    %rax,0x3c0(%rsp)
  80e688:	00 
  80e689:	49 8d 85 38 06 00 00 	lea    0x638(%r13),%rax
  80e690:	48 89 84 24 b8 03 00 	mov    %rax,0x3b8(%rsp)
  80e697:	00 
  80e698:	49 8d 85 c8 08 00 00 	lea    0x8c8(%r13),%rax
  80e69f:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  80e6a4:	4c 8d bc 24 b0 02 00 	lea    0x2b0(%rsp),%r15
  80e6ab:	00 
  80e6ac:	48 8d ac 24 b8 04 00 	lea    0x4b8(%rsp),%rbp
  80e6b3:	00 
  80e6b4:	0f 57 c0             	xorps  %xmm0,%xmm0
  80e6b7:	0f 29 84 24 80 02 00 	movaps %xmm0,0x280(%rsp)
  80e6be:	00 
  80e6bf:	f3 0f 11 44 24 24    	movss  %xmm0,0x24(%rsp)
  80e6c5:	f3 0f 11 44 24 6c    	movss  %xmm0,0x6c(%rsp)
  80e6cb:	48 8d 05 ee 7c 2f 00 	lea    0x2f7cee(%rip),%rax        # b063c0 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x5a8>
  80e6d2:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  80e6d7:	48 8d 05 4a 6f 2f 00 	lea    0x2f6f4a(%rip),%rax        # b05628 <anon.e15953efb999cecb448192f678c23055.25.llvm.10952606936216045542>
  80e6de:	48 89 84 24 70 02 00 	mov    %rax,0x270(%rsp)
  80e6e5:	00 
  80e6e6:	48 c7 84 24 08 02 00 	movq   $0x0,0x208(%rsp)
  80e6ed:	00 00 00 00 00 
  80e6f2:	31 d2                	xor    %edx,%edx
  80e6f4:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  80e6fb:	00 
  80e6fc:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  80e701:	31 c0                	xor    %eax,%eax
  80e703:	be fe ff ff ff       	mov    $0xfffffffe,%esi
  80e708:	83 fe fe             	cmp    $0xfffffffe,%esi
  80e70b:	75 23                	jne    80e730 <<gpui_canvas::text::planner::Planner>::shape+0x670>
  80e70d:	4c 8b 54 24 18       	mov    0x18(%rsp),%r10
  80e712:	4c 3b 94 24 a0 01 00 	cmp    0x1a0(%rsp),%r10
  80e719:	00 
  80e71a:	74 34                	je     80e750 <<gpui_canvas::text::planner::Planner>::shape+0x690>
  80e71c:	41 0f b6 0a          	movzbl (%r10),%ecx
  80e720:	84 c9                	test   %cl,%cl
  80e722:	78 44                	js     80e768 <<gpui_canvas::text::planner::Planner>::shape+0x6a8>
  80e724:	4d 8d 4a 01          	lea    0x1(%r10),%r9
  80e728:	e9 98 00 00 00       	jmp    80e7c5 <<gpui_canvas::text::planner::Planner>::shape+0x705>
  80e72d:	0f 1f 00             	nopl   (%rax)
  80e730:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
  80e735:	89 f1                	mov    %esi,%ecx
  80e737:	4c 8b 84 24 a0 03 00 	mov    0x3a0(%rsp),%r8
  80e73e:	00 
  80e73f:	e9 8a 00 00 00       	jmp    80e7ce <<gpui_canvas::text::planner::Planner>::shape+0x70e>
  80e744:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  80e74b:	00 00 00 00 00 
  80e750:	c7 44 24 74 fe ff ff 	movl   $0xfffffffe,0x74(%rsp)
  80e757:	ff 
  80e758:	b1 01                	mov    $0x1,%cl
  80e75a:	89 4c 24 4c          	mov    %ecx,0x4c(%rsp)
  80e75e:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  80e763:	e9 ce 01 00 00       	jmp    80e936 <<gpui_canvas::text::planner::Planner>::shape+0x876>
  80e768:	49 89 c0             	mov    %rax,%r8
  80e76b:	89 c8                	mov    %ecx,%eax
  80e76d:	83 e0 1f             	and    $0x1f,%eax
  80e770:	41 0f b6 7a 01       	movzbl 0x1(%r10),%edi
  80e775:	83 e7 3f             	and    $0x3f,%edi
  80e778:	80 f9 e0             	cmp    $0xe0,%cl
  80e77b:	72 2d                	jb     80e7aa <<gpui_canvas::text::planner::Planner>::shape+0x6ea>
  80e77d:	41 0f b6 72 02       	movzbl 0x2(%r10),%esi
  80e782:	c1 e7 06             	shl    $0x6,%edi
  80e785:	83 e6 3f             	and    $0x3f,%esi
  80e788:	09 fe                	or     %edi,%esi
  80e78a:	80 f9 f0             	cmp    $0xf0,%cl
  80e78d:	72 28                	jb     80e7b7 <<gpui_canvas::text::planner::Planner>::shape+0x6f7>
  80e78f:	4d 8d 4a 04          	lea    0x4(%r10),%r9
  80e793:	41 0f b6 4a 03       	movzbl 0x3(%r10),%ecx
  80e798:	83 e0 07             	and    $0x7,%eax
  80e79b:	c1 e0 12             	shl    $0x12,%eax
  80e79e:	c1 e6 06             	shl    $0x6,%esi
  80e7a1:	83 e1 3f             	and    $0x3f,%ecx
  80e7a4:	09 f1                	or     %esi,%ecx
  80e7a6:	09 c1                	or     %eax,%ecx
  80e7a8:	eb 18                	jmp    80e7c2 <<gpui_canvas::text::planner::Planner>::shape+0x702>
  80e7aa:	4d 8d 4a 02          	lea    0x2(%r10),%r9
  80e7ae:	c1 e0 06             	shl    $0x6,%eax
  80e7b1:	09 f8                	or     %edi,%eax
  80e7b3:	89 c1                	mov    %eax,%ecx
  80e7b5:	eb 0b                	jmp    80e7c2 <<gpui_canvas::text::planner::Planner>::shape+0x702>
  80e7b7:	4d 8d 4a 03          	lea    0x3(%r10),%r9
  80e7bb:	c1 e0 0c             	shl    $0xc,%eax
  80e7be:	09 c6                	or     %eax,%esi
  80e7c0:	89 f1                	mov    %esi,%ecx
  80e7c2:	4c 89 c0             	mov    %r8,%rax
  80e7c5:	49 89 c0             	mov    %rax,%r8
  80e7c8:	4c 29 d0             	sub    %r10,%rax
  80e7cb:	4c 01 c8             	add    %r9,%rax
  80e7ce:	c7 44 24 74 fe ff ff 	movl   $0xfffffffe,0x74(%rsp)
  80e7d5:	ff 
  80e7d6:	40 b6 01             	mov    $0x1,%sil
  80e7d9:	89 74 24 4c          	mov    %esi,0x4c(%rsp)
  80e7dd:	83 f9 0c             	cmp    $0xc,%ecx
  80e7e0:	7e 1e                	jle    80e800 <<gpui_canvas::text::planner::Planner>::shape+0x740>
  80e7e2:	83 f9 0d             	cmp    $0xd,%ecx
  80e7e5:	0f 84 60 01 00 00    	je     80e94b <<gpui_canvas::text::planner::Planner>::shape+0x88b>
  80e7eb:	81 f9 85 00 00 00    	cmp    $0x85,%ecx
  80e7f1:	74 1b                	je     80e80e <<gpui_canvas::text::planner::Planner>::shape+0x74e>
  80e7f3:	81 f9 29 20 00 00    	cmp    $0x2029,%ecx
  80e7f9:	74 13                	je     80e80e <<gpui_canvas::text::planner::Planner>::shape+0x74e>
  80e7fb:	e9 7d 00 00 00       	jmp    80e87d <<gpui_canvas::text::planner::Planner>::shape+0x7bd>
  80e800:	83 f9 ff             	cmp    $0xffffffff,%ecx
  80e803:	0f 84 23 01 00 00    	je     80e92c <<gpui_canvas::text::planner::Planner>::shape+0x86c>
  80e809:	83 f9 0a             	cmp    $0xa,%ecx
  80e80c:	75 6f                	jne    80e87d <<gpui_canvas::text::planner::Planner>::shape+0x7bd>
  80e80e:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  80e813:	81 f9 80 00 00 00    	cmp    $0x80,%ecx
  80e819:	0f 83 3d 01 00 00    	jae    80e95c <<gpui_canvas::text::planner::Planner>::shape+0x89c>
  80e81f:	49 8d 58 01          	lea    0x1(%r8),%rbx
  80e823:	83 f9 0d             	cmp    $0xd,%ecx
  80e826:	0f 85 42 01 00 00    	jne    80e96e <<gpui_canvas::text::planner::Planner>::shape+0x8ae>
  80e82c:	4c 8b 54 24 18       	mov    0x18(%rsp),%r10
  80e831:	4c 3b 94 24 a0 01 00 	cmp    0x1a0(%rsp),%r10
  80e838:	00 
  80e839:	0f 84 bd 23 00 00    	je     810bfc <<gpui_canvas::text::planner::Planner>::shape+0x2b3c>
  80e83f:	45 0f b6 1a          	movzbl (%r10),%r11d
  80e843:	45 84 db             	test   %r11b,%r11b
  80e846:	0f 88 bd 23 00 00    	js     810c09 <<gpui_canvas::text::planner::Planner>::shape+0x2b49>
  80e84c:	4d 8d 72 01          	lea    0x1(%r10),%r14
  80e850:	e9 1a 24 00 00       	jmp    810c6f <<gpui_canvas::text::planner::Planner>::shape+0x2baf>
  80e855:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  80e85c:	00 00 00 00 
  80e860:	81 f9 29 20 00 00    	cmp    $0x2029,%ecx
  80e866:	0f 84 e4 00 00 00    	je     80e950 <<gpui_canvas::text::planner::Planner>::shape+0x890>
  80e86c:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
  80e871:	81 f9 85 00 00 00    	cmp    $0x85,%ecx
  80e877:	0f 84 d3 00 00 00    	je     80e950 <<gpui_canvas::text::planner::Planner>::shape+0x890>
  80e87d:	4c 3b 8c 24 a0 01 00 	cmp    0x1a0(%rsp),%r9
  80e884:	00 
  80e885:	0f 84 a1 00 00 00    	je     80e92c <<gpui_canvas::text::planner::Planner>::shape+0x86c>
  80e88b:	49 89 c0             	mov    %rax,%r8
  80e88e:	41 0f b6 09          	movzbl (%r9),%ecx
  80e892:	84 c9                	test   %cl,%cl
  80e894:	78 0a                	js     80e8a0 <<gpui_canvas::text::planner::Planner>::shape+0x7e0>
  80e896:	49 8d 41 01          	lea    0x1(%r9),%rax
  80e89a:	eb 64                	jmp    80e900 <<gpui_canvas::text::planner::Planner>::shape+0x840>
  80e89c:	0f 1f 40 00          	nopl   0x0(%rax)
  80e8a0:	89 c8                	mov    %ecx,%eax
  80e8a2:	83 e0 1f             	and    $0x1f,%eax
  80e8a5:	41 0f b6 79 01       	movzbl 0x1(%r9),%edi
  80e8aa:	83 e7 3f             	and    $0x3f,%edi
  80e8ad:	80 f9 df             	cmp    $0xdf,%cl
  80e8b0:	76 30                	jbe    80e8e2 <<gpui_canvas::text::planner::Planner>::shape+0x822>
  80e8b2:	41 0f b6 71 02       	movzbl 0x2(%r9),%esi
  80e8b7:	c1 e7 06             	shl    $0x6,%edi
  80e8ba:	83 e6 3f             	and    $0x3f,%esi
  80e8bd:	09 fe                	or     %edi,%esi
  80e8bf:	80 f9 f0             	cmp    $0xf0,%cl
  80e8c2:	72 2e                	jb     80e8f2 <<gpui_canvas::text::planner::Planner>::shape+0x832>
  80e8c4:	49 8d 79 04          	lea    0x4(%r9),%rdi
  80e8c8:	41 0f b6 49 03       	movzbl 0x3(%r9),%ecx
  80e8cd:	83 e0 07             	and    $0x7,%eax
  80e8d0:	c1 e0 12             	shl    $0x12,%eax
  80e8d3:	c1 e6 06             	shl    $0x6,%esi
  80e8d6:	83 e1 3f             	and    $0x3f,%ecx
  80e8d9:	09 f1                	or     %esi,%ecx
  80e8db:	09 c1                	or     %eax,%ecx
  80e8dd:	48 89 f8             	mov    %rdi,%rax
  80e8e0:	eb 1e                	jmp    80e900 <<gpui_canvas::text::planner::Planner>::shape+0x840>
  80e8e2:	49 8d 71 02          	lea    0x2(%r9),%rsi
  80e8e6:	c1 e0 06             	shl    $0x6,%eax
  80e8e9:	09 f8                	or     %edi,%eax
  80e8eb:	89 c1                	mov    %eax,%ecx
  80e8ed:	48 89 f0             	mov    %rsi,%rax
  80e8f0:	eb 0e                	jmp    80e900 <<gpui_canvas::text::planner::Planner>::shape+0x840>
  80e8f2:	49 8d 49 03          	lea    0x3(%r9),%rcx
  80e8f6:	c1 e0 0c             	shl    $0xc,%eax
  80e8f9:	09 c6                	or     %eax,%esi
  80e8fb:	48 89 c8             	mov    %rcx,%rax
  80e8fe:	89 f1                	mov    %esi,%ecx
  80e900:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  80e905:	4c 29 c8             	sub    %r9,%rax
  80e908:	4c 01 c0             	add    %r8,%rax
  80e90b:	81 f9 84 00 00 00    	cmp    $0x84,%ecx
  80e911:	0f 8f 49 ff ff ff    	jg     80e860 <<gpui_canvas::text::planner::Planner>::shape+0x7a0>
  80e917:	83 f9 0a             	cmp    $0xa,%ecx
  80e91a:	74 34                	je     80e950 <<gpui_canvas::text::planner::Planner>::shape+0x890>
  80e91c:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
  80e921:	83 f9 0d             	cmp    $0xd,%ecx
  80e924:	0f 85 53 ff ff ff    	jne    80e87d <<gpui_canvas::text::planner::Planner>::shape+0x7bd>
  80e92a:	eb 24                	jmp    80e950 <<gpui_canvas::text::planner::Planner>::shape+0x890>
  80e92c:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  80e931:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  80e936:	48 89 d3             	mov    %rdx,%rbx
  80e939:	48 89 ce             	mov    %rcx,%rsi
  80e93c:	48 29 d6             	sub    %rdx,%rsi
  80e93f:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  80e944:	73 44                	jae    80e98a <<gpui_canvas::text::planner::Planner>::shape+0x8ca>
  80e946:	e9 65 2d 00 00       	jmp    8116b0 <<gpui_canvas::text::planner::Planner>::shape+0x35f0>
  80e94b:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  80e950:	81 f9 80 00 00 00    	cmp    $0x80,%ecx
  80e956:	0f 82 c3 fe ff ff    	jb     80e81f <<gpui_canvas::text::planner::Planner>::shape+0x75f>
  80e95c:	81 f9 00 08 00 00    	cmp    $0x800,%ecx
  80e962:	bb 03 00 00 00       	mov    $0x3,%ebx
  80e967:	48 83 db 00          	sbb    $0x0,%rbx
  80e96b:	4c 01 c3             	add    %r8,%rbx
  80e96e:	c7 44 24 4c 00 00 00 	movl   $0x0,0x4c(%rsp)
  80e975:	00 
  80e976:	4c 89 c1             	mov    %r8,%rcx
  80e979:	48 89 ce             	mov    %rcx,%rsi
  80e97c:	48 29 d6             	sub    %rdx,%rsi
  80e97f:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  80e984:	0f 82 26 2d 00 00    	jb     8116b0 <<gpui_canvas::text::planner::Planner>::shape+0x35f0>
  80e98a:	48 85 d2             	test   %rdx,%rdx
  80e98d:	48 89 84 24 b0 03 00 	mov    %rax,0x3b0(%rsp)
  80e994:	00 
  80e995:	74 2f                	je     80e9c6 <<gpui_canvas::text::planner::Planner>::shape+0x906>
  80e997:	48 3b 54 24 50       	cmp    0x50(%rsp),%rdx
  80e99c:	73 22                	jae    80e9c0 <<gpui_canvas::text::planner::Planner>::shape+0x900>
  80e99e:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  80e9a5:	00 
  80e9a6:	80 3c 10 bf          	cmpb   $0xbf,(%rax,%rdx,1)
  80e9aa:	7f 1a                	jg     80e9c6 <<gpui_canvas::text::planner::Planner>::shape+0x906>
  80e9ac:	e9 ff 2c 00 00       	jmp    8116b0 <<gpui_canvas::text::planner::Planner>::shape+0x35f0>
  80e9b1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  80e9b8:	0f 1f 84 00 00 00 00 
  80e9bf:	00 
  80e9c0:	0f 85 ea 2c 00 00    	jne    8116b0 <<gpui_canvas::text::planner::Planner>::shape+0x35f0>
  80e9c6:	48 85 c9             	test   %rcx,%rcx
  80e9c9:	74 2b                	je     80e9f6 <<gpui_canvas::text::planner::Planner>::shape+0x936>
  80e9cb:	48 3b 4c 24 50       	cmp    0x50(%rsp),%rcx
  80e9d0:	73 1e                	jae    80e9f0 <<gpui_canvas::text::planner::Planner>::shape+0x930>
  80e9d2:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  80e9d9:	00 
  80e9da:	80 3c 08 c0          	cmpb   $0xc0,(%rax,%rcx,1)
  80e9de:	7d 16                	jge    80e9f6 <<gpui_canvas::text::planner::Planner>::shape+0x936>
  80e9e0:	e9 cb 2c 00 00       	jmp    8116b0 <<gpui_canvas::text::planner::Planner>::shape+0x35f0>
  80e9e5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  80e9ec:	00 00 00 00 
  80e9f0:	0f 85 ba 2c 00 00    	jne    8116b0 <<gpui_canvas::text::planner::Planner>::shape+0x35f0>
  80e9f6:	48 89 8c 24 90 01 00 	mov    %rcx,0x190(%rsp)
  80e9fd:	00 
  80e9fe:	48 89 9c 24 a8 03 00 	mov    %rbx,0x3a8(%rsp)
  80ea05:	00 
  80ea06:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  80ea0d:	00 
  80ea0e:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
  80ea13:	48 8d 0c 10          	lea    (%rax,%rdx,1),%rcx
  80ea17:	48 8d bc 24 88 04 00 	lea    0x488(%rsp),%rdi
  80ea1e:	00 
  80ea1f:	48 8b b4 24 c0 03 00 	mov    0x3c0(%rsp),%rsi
  80ea26:	00 
  80ea27:	48 8b 94 24 b8 03 00 	mov    0x3b8(%rsp),%rdx
  80ea2e:	00 
  80ea2f:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  80ea34:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  80ea39:	f3 0f 10 05 4f 0b 8f 	movss  -0x70f4b1(%rip),%xmm0        # ff590 <anon.54edef65de96b8e67cbd7be652d99b9c.303.llvm.8229078508888877484+0x1c>
  80ea40:	ff 
  80ea41:	45 31 c9             	xor    %r9d,%r9d
  80ea44:	e8 d7 b1 ff ff       	call   809c20 <<parley::context::LayoutContext<()>>::ranged_builder>
  80ea49:	48 8d bc 24 88 04 00 	lea    0x488(%rsp),%rdi
  80ea50:	00 
  80ea51:	48 8d b4 24 38 03 00 	lea    0x338(%rsp),%rsi
  80ea58:	00 
  80ea59:	48 8b 94 24 10 02 00 	mov    0x210(%rsp),%rdx
  80ea60:	00 
  80ea61:	e8 2a 6c ff ff       	call   805690 <<parley::builder::RangedBuilder<()>>::push_default::<&[parlance::font_family::FontFamilyName]>>
  80ea66:	4c 8b b4 24 88 04 00 	mov    0x488(%rsp),%r14
  80ea6d:	00 
  80ea6e:	4c 8b ac 24 90 04 00 	mov    0x490(%rsp),%r13
  80ea75:	00 
  80ea76:	4d 8d a6 30 02 00 00 	lea    0x230(%r14),%r12
  80ea7d:	c6 84 24 00 07 00 00 	movb   $0x1,0x700(%rsp)
  80ea84:	01 
  80ea85:	f3 0f 10 44 24 7c    	movss  0x7c(%rsp),%xmm0
  80ea8b:	f3 0f 11 84 24 04 07 	movss  %xmm0,0x704(%rsp)
  80ea92:	00 00 
  80ea94:	f3 0f 10 84 24 a8 04 	movss  0x4a8(%rsp),%xmm0
  80ea9b:	00 00 
  80ea9d:	48 8d bc 24 b0 04 00 	lea    0x4b0(%rsp),%rdi
  80eaa4:	00 
  80eaa5:	4c 89 e6             	mov    %r12,%rsi
  80eaa8:	4c 89 ea             	mov    %r13,%rdx
  80eaab:	48 8d 9c 24 00 07 00 	lea    0x700(%rsp),%rbx
  80eab2:	00 
  80eab3:	48 89 d9             	mov    %rbx,%rcx
  80eab6:	f3 0f 11 44 24 30    	movss  %xmm0,0x30(%rsp)
  80eabc:	e8 3f fe fd ff       	call   7ee900 <<parley::resolve::ResolveContext>::resolve_property::<()>>
  80eac1:	48 89 df             	mov    %rbx,%rdi
  80eac4:	e8 b7 6d ff ff       	call   805880 <core::ptr::drop_glue::<parley::style::StyleProperty<()>>>
  80eac9:	49 83 be 20 05 00 00 	cmpq   $0xffffffffffffffff,0x520(%r14)
  80ead0:	ff 
  80ead1:	0f 84 17 28 00 00    	je     8112ee <<gpui_canvas::text::planner::Planner>::shape+0x322e>
  80ead7:	49 8d 9e 98 04 00 00 	lea    0x498(%r14),%rbx
  80eade:	48 89 df             	mov    %rbx,%rdi
  80eae1:	48 8d b4 24 b0 04 00 	lea    0x4b0(%rsp),%rsi
  80eae8:	00 
  80eae9:	e8 42 20 fe ff       	call   7f0b30 <<parley::resolve::ResolvedStyle<()>>::apply>
  80eaee:	66 c7 84 24 00 07 00 	movw   $0x117,0x700(%rsp)
  80eaf5:	00 17 01 
  80eaf8:	48 8d bc 24 b0 04 00 	lea    0x4b0(%rsp),%rdi
  80eaff:	00 
  80eb00:	4c 89 e6             	mov    %r12,%rsi
  80eb03:	4c 89 ea             	mov    %r13,%rdx
  80eb06:	4c 8d a4 24 00 07 00 	lea    0x700(%rsp),%r12
  80eb0d:	00 
  80eb0e:	4c 89 e1             	mov    %r12,%rcx
  80eb11:	f3 0f 10 44 24 30    	movss  0x30(%rsp),%xmm0
  80eb17:	e8 e4 fd fd ff       	call   7ee900 <<parley::resolve::ResolveContext>::resolve_property::<()>>
  80eb1c:	4c 89 e7             	mov    %r12,%rdi
  80eb1f:	e8 5c 6d ff ff       	call   805880 <core::ptr::drop_glue::<parley::style::StyleProperty<()>>>
  80eb24:	49 83 be 20 05 00 00 	cmpq   $0xffffffffffffffff,0x520(%r14)
  80eb2b:	ff 
  80eb2c:	0f 84 bc 27 00 00    	je     8112ee <<gpui_canvas::text::planner::Planner>::shape+0x322e>
  80eb32:	48 89 df             	mov    %rbx,%rdi
  80eb35:	48 8d b4 24 b0 04 00 	lea    0x4b0(%rsp),%rsi
  80eb3c:	00 
  80eb3d:	e8 ee 1f fe ff       	call   7f0b30 <<parley::resolve::ResolvedStyle<()>>::apply>
  80eb42:	48 8d bc 24 88 04 00 	lea    0x488(%rsp),%rdi
  80eb49:	00 
  80eb4a:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  80eb4f:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  80eb54:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  80eb59:	e8 32 35 ff ff       	call   802090 <<parley::builder::RangedBuilder<()>>::build_into::<&str>>
  80eb5e:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  80eb65:	00 
  80eb66:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  80eb6b:	e8 c0 b6 fe ff       	call   7fa230 <<parley::layout::line_break::BreakLines<()>>::new>
  80eb70:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  80eb77:	00 
  80eb78:	f3 0f 10 84 24 bc 01 	movss  0x1bc(%rsp),%xmm0
  80eb7f:	00 00 
  80eb81:	e8 8a a7 fe ff       	call   7f9310 <<parley::layout::line_break::BreakLines<()>>::break_remaining>
  80eb86:	80 bc 24 2c 02 00 00 	cmpb   $0x0,0x22c(%rsp)
  80eb8d:	00 
  80eb8e:	74 20                	je     80ebb0 <<gpui_canvas::text::planner::Planner>::shape+0xaf0>
  80eb90:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  80eb97:	00 ff 
  80eb99:	0f 85 11 02 00 00    	jne    80edb0 <<gpui_canvas::text::planner::Planner>::shape+0xcf0>
  80eb9f:	31 c0                	xor    %eax,%eax
  80eba1:	e9 90 01 00 00       	jmp    80ed36 <<gpui_canvas::text::planner::Planner>::shape+0xc76>
  80eba6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80ebad:	00 00 00 
  80ebb0:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
  80ebb6:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  80ebbd:	00 
  80ebbe:	0f 85 5c 01 00 00    	jne    80ed20 <<gpui_canvas::text::planner::Planner>::shape+0xc60>
  80ebc4:	48 3b 44 24 50       	cmp    0x50(%rsp),%rax
  80ebc9:	0f 85 51 01 00 00    	jne    80ed20 <<gpui_canvas::text::planner::Planner>::shape+0xc60>
  80ebcf:	48 8b 04 24          	mov    (%rsp),%rax
  80ebd3:	48 83 b8 e0 09 00 00 	cmpq   $0x1,0x9e0(%rax)
  80ebda:	01 
  80ebdb:	0f 85 3f 01 00 00    	jne    80ed20 <<gpui_canvas::text::planner::Planner>::shape+0xc60>
  80ebe1:	48 8b 14 24          	mov    (%rsp),%rdx
  80ebe5:	48 8b 82 d8 09 00 00 	mov    0x9d8(%rdx),%rax
  80ebec:	48 8d 48 70          	lea    0x70(%rax),%rcx
  80ebf0:	48 89 8c 24 08 07 00 	mov    %rcx,0x708(%rsp)
  80ebf7:	00 
  80ebf8:	48 c7 84 24 10 07 00 	movq   $0x0,0x710(%rsp)
  80ebff:	00 00 00 00 00 
  80ec04:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  80ec09:	48 89 b4 24 18 07 00 	mov    %rsi,0x718(%rsp)
  80ec10:	00 
  80ec11:	48 c7 84 24 48 07 00 	movq   $0x0,0x748(%rsp)
  80ec18:	00 00 00 00 00 
  80ec1d:	48 89 94 24 b0 04 00 	mov    %rdx,0x4b0(%rsp)
  80ec24:	00 
  80ec25:	48 c7 84 24 20 07 00 	movq   $0x0,0x720(%rsp)
  80ec2c:	00 00 00 00 00 
  80ec31:	48 89 8c 24 00 07 00 	mov    %rcx,0x700(%rsp)
  80ec38:	00 
  80ec39:	48 8b 78 10          	mov    0x10(%rax),%rdi
  80ec3d:	48 8b 70 18          	mov    0x18(%rax),%rsi
  80ec41:	48 8b 92 f8 09 00 00 	mov    0x9f8(%rdx),%rdx
  80ec48:	48 39 fe             	cmp    %rdi,%rsi
  80ec4b:	0f 82 1b 2a 00 00    	jb     81166c <<gpui_canvas::text::planner::Planner>::shape+0x35ac>
  80ec51:	48 39 d6             	cmp    %rdx,%rsi
  80ec54:	0f 87 12 2a 00 00    	ja     81166c <<gpui_canvas::text::planner::Planner>::shape+0x35ac>
  80ec5a:	48 8b 04 24          	mov    (%rsp),%rax
  80ec5e:	48 8b 80 f0 09 00 00 	mov    0x9f0(%rax),%rax
  80ec65:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  80ec69:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
  80ec6d:	48 8d 14 b6          	lea    (%rsi,%rsi,4),%rdx
  80ec71:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
  80ec75:	48 89 8c 24 20 07 00 	mov    %rcx,0x720(%rsp)
  80ec7c:	00 
  80ec7d:	48 89 84 24 28 07 00 	mov    %rax,0x728(%rsp)
  80ec84:	00 
  80ec85:	48 c7 84 24 30 07 00 	movq   $0x0,0x730(%rsp)
  80ec8c:	00 00 00 00 00 
  80ec91:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  80ec96:	48 89 84 24 38 07 00 	mov    %rax,0x738(%rsp)
  80ec9d:	00 
  80ec9e:	c7 84 24 40 07 00 00 	movl   $0x0,0x740(%rsp)
  80eca5:	00 00 00 00 
  80eca9:	48 8d bc 24 20 07 00 	lea    0x720(%rsp),%rdi
  80ecb0:	00 
  80ecb1:	48 8d b4 24 48 07 00 	lea    0x748(%rsp),%rsi
  80ecb8:	00 
  80ecb9:	48 8d 94 24 b0 04 00 	lea    0x4b0(%rsp),%rdx
  80ecc0:	00 
  80ecc1:	e8 4a 0b fe ff       	call   7ef810 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>>
  80ecc6:	48 c7 84 24 10 07 00 	movq   $0x1,0x710(%rsp)
  80eccd:	00 01 00 00 00 
  80ecd2:	84 c0                	test   %al,%al
  80ecd4:	75 4a                	jne    80ed20 <<gpui_canvas::text::planner::Planner>::shape+0xc60>
  80ecd6:	48 c7 84 24 20 07 00 	movq   $0x0,0x720(%rsp)
  80ecdd:	00 00 00 00 00 
  80ece2:	48 83 bc 24 48 07 00 	cmpq   $0x0,0x748(%rsp)
  80ece9:	00 00 
  80eceb:	0f 84 90 1e 00 00    	je     810b81 <<gpui_canvas::text::planner::Planner>::shape+0x2ac1>
  80ecf1:	48 8d bc 24 48 07 00 	lea    0x748(%rsp),%rdi
  80ecf8:	00 
  80ecf9:	48 8d b4 24 70 07 00 	lea    0x770(%rsp),%rsi
  80ed00:	00 
  80ed01:	48 8d 94 24 b0 04 00 	lea    0x4b0(%rsp),%rdx
  80ed08:	00 
  80ed09:	e8 02 0b fe ff       	call   7ef810 <<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), core::iter::adapters::filter_map::filter_map_try_fold<parley::layout::line::LineItem<()>, parley::layout::run::Run<()>, (), core::ops::control_flow::ControlFlow<()>, <parley::layout::line::Line<()>>::runs::{closure#0}, &mut core::iter::traits::iterator::Iterator::all::check<parley::layout::run::Run<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#2}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<()>>>
  80ed0e:	84 c0                	test   %al,%al
  80ed10:	0f 84 6b 1e 00 00    	je     810b81 <<gpui_canvas::text::planner::Planner>::shape+0x2ac1>
  80ed16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80ed1d:	00 00 00 
  80ed20:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  80ed27:	00 ff 
  80ed29:	0f 85 81 00 00 00    	jne    80edb0 <<gpui_canvas::text::planner::Planner>::shape+0xcf0>
  80ed2f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  80ed36:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  80ed3d:	00 00 00 00 00 
  80ed42:	48 c7 84 24 48 01 00 	movq   $0x4,0x148(%rsp)
  80ed49:	00 04 00 00 00 
  80ed4e:	48 8d 8c 24 48 01 00 	lea    0x148(%rsp),%rcx
  80ed55:	00 
  80ed56:	0f 57 c0             	xorps  %xmm0,%xmm0
  80ed59:	0f 11 41 08          	movups %xmm0,0x8(%rcx)
  80ed5d:	48 c7 84 24 60 01 00 	movq   $0x4,0x160(%rsp)
  80ed64:	00 04 00 00 00 
  80ed69:	48 c7 84 24 68 01 00 	movq   $0x0,0x168(%rsp)
  80ed70:	00 00 00 00 00 
  80ed75:	48 89 84 24 70 01 00 	mov    %rax,0x170(%rsp)
  80ed7c:	00 
  80ed7d:	48 c7 84 24 78 01 00 	movq   $0x4,0x178(%rsp)
  80ed84:	00 04 00 00 00 
  80ed89:	48 c7 84 24 80 01 00 	movq   $0x0,0x180(%rsp)
  80ed90:	00 00 00 00 00 
  80ed95:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  80ed9a:	89 84 24 88 01 00 00 	mov    %eax,0x188(%rsp)
  80eda1:	f3 0f 10 44 24 7c    	movss  0x7c(%rsp),%xmm0
  80eda7:	f3 0f 11 84 24 8c 01 	movss  %xmm0,0x18c(%rsp)
  80edae:	00 00 
  80edb0:	48 8b 04 24          	mov    (%rsp),%rax
  80edb4:	48 8b 98 e0 09 00 00 	mov    0x9e0(%rax),%rbx
  80edbb:	48 85 db             	test   %rbx,%rbx
  80edbe:	0f 84 0c 01 00 00    	je     80eed0 <<gpui_canvas::text::planner::Planner>::shape+0xe10>
  80edc4:	4c 8b a0 d8 09 00 00 	mov    0x9d8(%rax),%r12
  80edcb:	45 31 f6             	xor    %r14d,%r14d
  80edce:	45 31 ed             	xor    %r13d,%r13d
  80edd1:	eb 19                	jmp    80edec <<gpui_canvas::text::planner::Planner>::shape+0xd2c>
  80edd3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  80edda:	84 00 00 00 00 00 
  80ede0:	49 ff c6             	inc    %r14
  80ede3:	49 39 de             	cmp    %rbx,%r14
  80ede6:	0f 84 e7 00 00 00    	je     80eed3 <<gpui_canvas::text::planner::Planner>::shape+0xe13>
  80edec:	49 6b c6 70          	imul   $0x70,%r14,%rax
  80edf0:	4c 01 e0             	add    %r12,%rax
  80edf3:	4c 89 ac 24 00 07 00 	mov    %r13,0x700(%rsp)
  80edfa:	00 
  80edfb:	48 c7 84 24 08 07 00 	movq   $0x0,0x708(%rsp)
  80ee02:	00 00 00 00 00 
  80ee07:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  80ee0c:	48 89 8c 24 10 07 00 	mov    %rcx,0x710(%rsp)
  80ee13:	00 
  80ee14:	48 89 84 24 18 07 00 	mov    %rax,0x718(%rsp)
  80ee1b:	00 
  80ee1c:	44 89 b4 24 20 07 00 	mov    %r14d,0x720(%rsp)
  80ee23:	00 
  80ee24:	c6 84 24 c8 07 00 00 	movb   $0x2,0x7c8(%rsp)
  80ee2b:	02 
  80ee2c:	c7 84 24 d0 07 00 00 	movl   $0x0,0x7d0(%rsp)
  80ee33:	00 00 00 00 
  80ee37:	48 8d bc 24 a0 02 00 	lea    0x2a0(%rsp),%rdi
  80ee3e:	00 
  80ee3f:	48 8d b4 24 08 07 00 	lea    0x708(%rsp),%rsi
  80ee46:	00 
  80ee47:	e8 f4 c6 fd ff       	call   7eb540 <<parley::layout::line::GlyphRunIter<()> as core::iter::traits::iterator::Iterator>::next>
  80ee4c:	83 bc 24 a0 02 00 00 	cmpl   $0x1,0x2a0(%rsp)
  80ee53:	01 
  80ee54:	75 8a                	jne    80ede0 <<gpui_canvas::text::planner::Planner>::shape+0xd20>
  80ee56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80ee5d:	00 00 00 
  80ee60:	49 8b 47 38          	mov    0x38(%r15),%rax
  80ee64:	48 89 45 40          	mov    %rax,0x40(%rbp)
  80ee68:	41 0f 10 47 f8       	movups -0x8(%r15),%xmm0
  80ee6d:	41 0f 10 4f 08       	movups 0x8(%r15),%xmm1
  80ee72:	41 0f 10 57 18       	movups 0x18(%r15),%xmm2
  80ee77:	41 0f 10 5f 28       	movups 0x28(%r15),%xmm3
  80ee7c:	0f 11 5d 30          	movups %xmm3,0x30(%rbp)
  80ee80:	0f 11 55 20          	movups %xmm2,0x20(%rbp)
  80ee84:	0f 11 4d 10          	movups %xmm1,0x10(%rbp)
  80ee88:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
  80ee8c:	4c 89 ac 24 b0 04 00 	mov    %r13,0x4b0(%rsp)
  80ee93:	00 
  80ee94:	4c 89 ee             	mov    %r13,%rsi
  80ee97:	48 89 ea             	mov    %rbp,%rdx
  80ee9a:	e8 71 23 fe ff       	call   7f1210 <<&mut core::iter::adapters::map::map_fold<parley::layout::line::PositionedLayoutItem<()>, usize, usize, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}, <usize as core::iter::traits::accum::Sum>::sum<core::iter::adapters::map::Map<core::iter::adapters::flatten::FlatMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, parley::layout::line::GlyphRunIter<()>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#4}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#5}>>::{closure#0}>::{closure#0} as core::ops::function::FnMut<(usize, parley::layout::line::PositionedLayoutItem<()>)>>::call_mut>
  80ee9f:	49 89 c5             	mov    %rax,%r13
  80eea2:	48 8d bc 24 a0 02 00 	lea    0x2a0(%rsp),%rdi
  80eea9:	00 
  80eeaa:	48 8d b4 24 08 07 00 	lea    0x708(%rsp),%rsi
  80eeb1:	00 
  80eeb2:	e8 89 c6 fd ff       	call   7eb540 <<parley::layout::line::GlyphRunIter<()> as core::iter::traits::iterator::Iterator>::next>
  80eeb7:	80 bc 24 a0 02 00 00 	cmpb   $0x0,0x2a0(%rsp)
  80eebe:	00 
  80eebf:	75 9f                	jne    80ee60 <<gpui_canvas::text::planner::Planner>::shape+0xda0>
  80eec1:	e9 1a ff ff ff       	jmp    80ede0 <<gpui_canvas::text::planner::Planner>::shape+0xd20>
  80eec6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80eecd:	00 00 00 
  80eed0:	45 31 ed             	xor    %r13d,%r13d
  80eed3:	48 8b b4 24 f8 00 00 	mov    0xf8(%rsp),%rsi
  80eeda:	00 
  80eedb:	48 89 f0             	mov    %rsi,%rax
  80eede:	4c 01 e8             	add    %r13,%rax
  80eee1:	0f 92 c1             	setb   %cl
  80eee4:	48 3d 01 80 00 00    	cmp    $0x8001,%rax
  80eeea:	0f 93 c0             	setae  %al
  80eeed:	08 c8                	or     %cl,%al
  80eeef:	0f 85 ee 1d 00 00    	jne    810ce3 <<gpui_canvas::text::planner::Planner>::shape+0x2c23>
  80eef5:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  80eefc:	00 
  80eefd:	48 3b 44 24 40       	cmp    0x40(%rsp),%rax
  80ef02:	74 14                	je     80ef18 <<gpui_canvas::text::planner::Planner>::shape+0xe58>
  80ef04:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  80ef0b:	00 
  80ef0c:	48 29 f0             	sub    %rsi,%rax
  80ef0f:	49 39 c5             	cmp    %rax,%r13
  80ef12:	0f 87 ab 1d 00 00    	ja     810cc3 <<gpui_canvas::text::planner::Planner>::shape+0x2c03>
  80ef18:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  80ef1d:	48 85 d2             	test   %rdx,%rdx
  80ef20:	48 8b 9c 24 90 01 00 	mov    0x190(%rsp),%rbx
  80ef27:	00 
  80ef28:	74 26                	je     80ef50 <<gpui_canvas::text::planner::Planner>::shape+0xe90>
  80ef2a:	0f 57 c0             	xorps  %xmm0,%xmm0
  80ef2d:	f3 0f 11 84 24 d8 00 	movss  %xmm0,0xd8(%rsp)
  80ef34:	00 00 
  80ef36:	48 39 d3             	cmp    %rdx,%rbx
  80ef39:	75 4b                	jne    80ef86 <<gpui_canvas::text::planner::Planner>::shape+0xec6>
  80ef3b:	48 8b 0c 24          	mov    (%rsp),%rcx
  80ef3f:	48 8b 81 e0 09 00 00 	mov    0x9e0(%rcx),%rax
  80ef46:	48 85 c0             	test   %rax,%rax
  80ef49:	75 7c                	jne    80efc7 <<gpui_canvas::text::planner::Planner>::shape+0xf07>
  80ef4b:	e9 d6 14 00 00       	jmp    810426 <<gpui_canvas::text::planner::Planner>::shape+0x2366>
  80ef50:	48 8b 04 24          	mov    (%rsp),%rax
  80ef54:	48 83 b8 e0 09 00 00 	cmpq   $0x0,0x9e0(%rax)
  80ef5b:	00 
  80ef5c:	74 0e                	je     80ef6c <<gpui_canvas::text::planner::Planner>::shape+0xeac>
  80ef5e:	48 8b 80 d8 09 00 00 	mov    0x9d8(%rax),%rax
  80ef65:	f3 0f 10 40 24       	movss  0x24(%rax),%xmm0
  80ef6a:	eb 03                	jmp    80ef6f <<gpui_canvas::text::planner::Planner>::shape+0xeaf>
  80ef6c:	0f 57 c0             	xorps  %xmm0,%xmm0
  80ef6f:	f3 0f 11 44 24 6c    	movss  %xmm0,0x6c(%rsp)
  80ef75:	0f 57 c0             	xorps  %xmm0,%xmm0
  80ef78:	f3 0f 11 84 24 d8 00 	movss  %xmm0,0xd8(%rsp)
  80ef7f:	00 00 
  80ef81:	48 39 d3             	cmp    %rdx,%rbx
  80ef84:	74 b5                	je     80ef3b <<gpui_canvas::text::planner::Planner>::shape+0xe7b>
  80ef86:	83 bc 24 b8 01 00 00 	cmpl   $0x0,0x1b8(%rsp)
  80ef8d:	00 
  80ef8e:	74 0e                	je     80ef9e <<gpui_canvas::text::planner::Planner>::shape+0xede>
  80ef90:	48 8b 04 24          	mov    (%rsp),%rax
  80ef94:	f3 0f 10 80 28 0a 00 	movss  0xa28(%rax),%xmm0
  80ef9b:	00 
  80ef9c:	eb 0c                	jmp    80efaa <<gpui_canvas::text::planner::Planner>::shape+0xeea>
  80ef9e:	48 8b 04 24          	mov    (%rsp),%rax
  80efa2:	f3 0f 10 80 2c 0a 00 	movss  0xa2c(%rax),%xmm0
  80efa9:	00 
  80efaa:	f3 0f 11 84 24 d8 00 	movss  %xmm0,0xd8(%rsp)
  80efb1:	00 00 
  80efb3:	48 8b 0c 24          	mov    (%rsp),%rcx
  80efb7:	48 8b 81 e0 09 00 00 	mov    0x9e0(%rcx),%rax
  80efbe:	48 85 c0             	test   %rax,%rax
  80efc1:	0f 84 5f 14 00 00    	je     810426 <<gpui_canvas::text::planner::Planner>::shape+0x2366>
  80efc7:	48 8b 89 d8 09 00 00 	mov    0x9d8(%rcx),%rcx
  80efce:	48 6b c0 70          	imul   $0x70,%rax,%rax
  80efd2:	48 89 8c 24 d0 00 00 	mov    %rcx,0xd0(%rsp)
  80efd9:	00 
  80efda:	48 01 c8             	add    %rcx,%rax
  80efdd:	48 89 84 24 98 03 00 	mov    %rax,0x398(%rsp)
  80efe4:	00 
  80efe5:	c7 44 24 70 00 00 00 	movl   $0x0,0x70(%rsp)
  80efec:	00 
  80efed:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  80eff4:	00 ff 
  80eff6:	74 2e                	je     80f026 <<gpui_canvas::text::planner::Planner>::shape+0xf66>
  80eff8:	48 39 d3             	cmp    %rdx,%rbx
  80effb:	75 3c                	jne    80f039 <<gpui_canvas::text::planner::Planner>::shape+0xf79>
  80effd:	45 31 ed             	xor    %r13d,%r13d
  80f000:	45 31 f6             	xor    %r14d,%r14d
  80f003:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  80f00a:	00 
  80f00b:	4c 8b a4 24 68 01 00 	mov    0x168(%rsp),%r12
  80f012:	00 
  80f013:	80 78 68 02          	cmpb   $0x2,0x68(%rax)
  80f017:	4c 89 a4 24 58 02 00 	mov    %r12,0x258(%rsp)
  80f01e:	00 
  80f01f:	74 41                	je     80f062 <<gpui_canvas::text::planner::Planner>::shape+0xfa2>
  80f021:	e9 c6 01 00 00       	jmp    80f1ec <<gpui_canvas::text::planner::Planner>::shape+0x112c>
  80f026:	8b 4c 24 70          	mov    0x70(%rsp),%ecx
  80f02a:	89 c8                	mov    %ecx,%eax
  80f02c:	48 89 84 24 58 02 00 	mov    %rax,0x258(%rsp)
  80f033:	00 
  80f034:	e9 c9 03 00 00       	jmp    80f402 <<gpui_canvas::text::planner::Planner>::shape+0x1342>
  80f039:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  80f040:	00 
  80f041:	4c 8b 30             	mov    (%rax),%r14
  80f044:	4c 8b 68 08          	mov    0x8(%rax),%r13
  80f048:	4c 8b a4 24 68 01 00 	mov    0x168(%rsp),%r12
  80f04f:	00 
  80f050:	80 78 68 02          	cmpb   $0x2,0x68(%rax)
  80f054:	4c 89 a4 24 58 02 00 	mov    %r12,0x258(%rsp)
  80f05b:	00 
  80f05c:	0f 85 8a 01 00 00    	jne    80f1ec <<gpui_canvas::text::planner::Planner>::shape+0x112c>
  80f062:	48 8b 78 10          	mov    0x10(%rax),%rdi
  80f066:	48 8b 70 18          	mov    0x18(%rax),%rsi
  80f06a:	48 8b 04 24          	mov    (%rsp),%rax
  80f06e:	48 8b 90 f8 09 00 00 	mov    0x9f8(%rax),%rdx
  80f075:	48 39 fe             	cmp    %rdi,%rsi
  80f078:	0f 82 00 26 00 00    	jb     81167e <<gpui_canvas::text::planner::Planner>::shape+0x35be>
  80f07e:	48 39 d6             	cmp    %rdx,%rsi
  80f081:	0f 87 f7 25 00 00    	ja     81167e <<gpui_canvas::text::planner::Planner>::shape+0x35be>
  80f087:	48 8b 04 24          	mov    (%rsp),%rax
  80f08b:	48 8b 80 f0 09 00 00 	mov    0x9f0(%rax),%rax
  80f092:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  80f096:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
  80f09a:	48 8d 14 b6          	lea    (%rsi,%rsi,4),%rdx
  80f09e:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
  80f0a2:	48 89 8c 24 b0 04 00 	mov    %rcx,0x4b0(%rsp)
  80f0a9:	00 
  80f0aa:	48 89 84 24 b8 04 00 	mov    %rax,0x4b8(%rsp)
  80f0b1:	00 
  80f0b2:	48 c7 84 24 c0 04 00 	movq   $0x0,0x4c0(%rsp)
  80f0b9:	00 00 00 00 00 
  80f0be:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  80f0c3:	48 89 84 24 c8 04 00 	mov    %rax,0x4c8(%rsp)
  80f0ca:	00 
  80f0cb:	8b 44 24 70          	mov    0x70(%rsp),%eax
  80f0cf:	89 84 24 d0 04 00 00 	mov    %eax,0x4d0(%rsp)
  80f0d6:	c6 84 24 f0 06 00 00 	movb   $0x2,0x6f0(%rsp)
  80f0dd:	02 
  80f0de:	48 8d 84 24 f8 06 00 	lea    0x6f8(%rsp),%rax
  80f0e5:	00 
  80f0e6:	48 89 84 24 a0 02 00 	mov    %rax,0x2a0(%rsp)
  80f0ed:	00 
  80f0ee:	c6 84 24 e0 05 00 00 	movb   $0x2,0x5e0(%rsp)
  80f0f5:	02 
  80f0f6:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  80f0fd:	00 
  80f0fe:	48 8d b4 24 b0 04 00 	lea    0x4b0(%rsp),%rsi
  80f105:	00 
  80f106:	48 8d 94 24 a0 02 00 	lea    0x2a0(%rsp),%rdx
  80f10d:	00 
  80f10e:	48 8d 8c 24 d8 04 00 	lea    0x4d8(%rsp),%rcx
  80f115:	00 
  80f116:	e8 f5 ff fd ff       	call   7ef110 <<core::iter::adapters::map::Map<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>, gpui_canvas::text::planner::freeze_line::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::flatten::FlattenCompat<_, _>>::iter_try_fold::flatten<parley::layout::run::Clusters<()>, (), core::ops::control_flow::ControlFlow<parley::layout::cluster::Cluster<()>>, <core::iter::adapters::flatten::FlattenCompat<_, _> as core::iter::traits::iterator::Iterator>::try_fold::flatten<parley::layout::run::Clusters<()>, (), core::ops::control_flow::ControlFlow<parley::layout::cluster::Cluster<()>>, core::iter::traits::iterator::Iterator::find::check<parley::layout::cluster::Cluster<()>, &mut gpui_canvas::text::planner::freeze_line::{closure#1}>::{closure#0}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<parley::layout::cluster::Cluster<()>>>>
  80f11b:	48 8b 8c 24 00 07 00 	mov    0x700(%rsp),%rcx
  80f122:	00 
  80f123:	48 85 c9             	test   %rcx,%rcx
  80f126:	0f 84 ae 00 00 00    	je     80f1da <<gpui_canvas::text::planner::Planner>::shape+0x111a>
  80f12c:	8b bc 24 28 07 00 00 	mov    0x728(%rsp),%edi
  80f133:	8b b4 24 80 07 00 00 	mov    0x780(%rsp),%esi
  80f13a:	8b 94 24 84 07 00 00 	mov    0x784(%rsp),%edx
  80f141:	48 8b 41 58          	mov    0x58(%rcx),%rax
  80f145:	48 39 f8             	cmp    %rdi,%rax
  80f148:	0f 86 49 26 00 00    	jbe    811797 <<gpui_canvas::text::planner::Planner>::shape+0x36d7>
  80f14e:	48 8b 41 50          	mov    0x50(%rcx),%rax
  80f152:	48 8d 3c ff          	lea    (%rdi,%rdi,8),%rdi
  80f156:	48 c1 e7 04          	shl    $0x4,%rdi
  80f15a:	0f 10 41 68          	movups 0x68(%rcx),%xmm0
  80f15e:	0f 10 89 80 00 00 00 	movups 0x80(%rcx),%xmm1
  80f165:	0f 10 91 98 00 00 00 	movups 0x98(%rcx),%xmm2
  80f16c:	0f 11 84 24 00 07 00 	movups %xmm0,0x700(%rsp)
  80f173:	00 
  80f174:	0f 11 8c 24 10 07 00 	movups %xmm1,0x710(%rsp)
  80f17b:	00 
  80f17c:	0f 11 94 24 20 07 00 	movups %xmm2,0x720(%rsp)
  80f183:	00 
  80f184:	48 8b 44 38 50       	mov    0x50(%rax,%rdi,1),%rax
  80f189:	48 89 84 24 30 07 00 	mov    %rax,0x730(%rsp)
  80f190:	00 
  80f191:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  80f198:	00 
  80f199:	ff 15 71 c9 31 00    	call   *0x31c971(%rip)        # b2bb10 <_DYNAMIC+0xe40>
  80f19f:	48 89 c3             	mov    %rax,%rbx
  80f1a2:	ba 48 02 00 00       	mov    $0x248,%edx
  80f1a7:	4d 89 f4             	mov    %r14,%r12
  80f1aa:	4c 8d b4 24 00 07 00 	lea    0x700(%rsp),%r14
  80f1b1:	00 
  80f1b2:	4c 89 f7             	mov    %r14,%rdi
  80f1b5:	48 8d b4 24 b0 04 00 	lea    0x4b0(%rsp),%rsi
  80f1bc:	00 
  80f1bd:	ff 15 7d bd 31 00    	call   *0x31bd7d(%rip)        # b2af40 <memcpy@GLIBC_2.14>
  80f1c3:	4c 89 f7             	mov    %r14,%rdi
  80f1c6:	4d 89 e6             	mov    %r12,%r14
  80f1c9:	48 89 de             	mov    %rbx,%rsi
  80f1cc:	e8 df 01 fe ff       	call   7ef3b0 <<core::iter::adapters::map::Map<core::iter::adapters::filter::Filter<core::iter::adapters::flatten::FlatMap<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>, parley::layout::run::Clusters<()>, gpui_canvas::text::planner::freeze_line::{closure#0}>, gpui_canvas::text::planner::freeze_line::{closure#1}>, gpui_canvas::text::planner::freeze_line::{closure#2}> as core::iter::traits::iterator::Iterator>::fold::<usize, core::iter::traits::iterator::Iterator::min_by::fold<usize, <usize as core::cmp::Ord>::cmp>::{closure#0}>>
  80f1d1:	4c 39 e8             	cmp    %r13,%rax
  80f1d4:	4c 0f 42 e8          	cmovb  %rax,%r13
  80f1d8:	eb 12                	jmp    80f1ec <<gpui_canvas::text::planner::Planner>::shape+0x112c>
  80f1da:	80 bc 24 f0 06 00 00 	cmpb   $0x2,0x6f0(%rsp)
  80f1e1:	02 
  80f1e2:	c6 84 24 e0 05 00 00 	movb   $0x2,0x5e0(%rsp)
  80f1e9:	02 
  80f1ea:	75 34                	jne    80f220 <<gpui_canvas::text::planner::Planner>::shape+0x1160>
  80f1ec:	4d 39 ee             	cmp    %r13,%r14
  80f1ef:	0f 87 69 1e 00 00    	ja     81105e <<gpui_canvas::text::planner::Planner>::shape+0x2f9e>
  80f1f5:	4d 85 f6             	test   %r14,%r14
  80f1f8:	0f 84 9e 00 00 00    	je     80f29c <<gpui_canvas::text::planner::Planner>::shape+0x11dc>
  80f1fe:	4c 3b 74 24 08       	cmp    0x8(%rsp),%r14
  80f203:	0f 83 8d 00 00 00    	jae    80f296 <<gpui_canvas::text::planner::Planner>::shape+0x11d6>
  80f209:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  80f20e:	42 80 3c 30 bf       	cmpb   $0xbf,(%rax,%r14,1)
  80f213:	0f 8f 83 00 00 00    	jg     80f29c <<gpui_canvas::text::planner::Planner>::shape+0x11dc>
  80f219:	e9 40 1e 00 00       	jmp    81105e <<gpui_canvas::text::planner::Planner>::shape+0x2f9e>
  80f21e:	66 90                	xchg   %ax,%ax
  80f220:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  80f227:	00 
  80f228:	48 8d b4 24 e8 05 00 	lea    0x5e8(%rsp),%rsi
  80f22f:	00 
  80f230:	e8 4b 24 fe ff       	call   7f1680 <<parley::layout::run::Clusters<()> as core::iter::traits::iterator::Iterator>::next>
  80f235:	48 8b 8c 24 00 07 00 	mov    0x700(%rsp),%rcx
  80f23c:	00 
  80f23d:	48 85 c9             	test   %rcx,%rcx
  80f240:	74 aa                	je     80f1ec <<gpui_canvas::text::planner::Planner>::shape+0x112c>
  80f242:	8b bc 24 28 07 00 00 	mov    0x728(%rsp),%edi
  80f249:	48 8b 41 58          	mov    0x58(%rcx),%rax
  80f24d:	48 39 f8             	cmp    %rdi,%rax
  80f250:	0f 86 be 24 00 00    	jbe    811714 <<gpui_canvas::text::planner::Planner>::shape+0x3654>
  80f256:	8b b4 24 80 07 00 00 	mov    0x780(%rsp),%esi
  80f25d:	8b 94 24 84 07 00 00 	mov    0x784(%rsp),%edx
  80f264:	4c 8b 41 70          	mov    0x70(%rcx),%r8
  80f268:	39 f2                	cmp    %esi,%edx
  80f26a:	0f 82 ab 23 00 00    	jb     81161b <<gpui_canvas::text::planner::Planner>::shape+0x355b>
  80f270:	49 39 d0             	cmp    %rdx,%r8
  80f273:	0f 82 a2 23 00 00    	jb     81161b <<gpui_canvas::text::planner::Planner>::shape+0x355b>
  80f279:	39 f2                	cmp    %esi,%edx
  80f27b:	0f 84 a4 24 00 00    	je     811725 <<gpui_canvas::text::planner::Planner>::shape+0x3665>
  80f281:	4c 8b 41 68          	mov    0x68(%rcx),%r8
  80f285:	4c 8d 0c 76          	lea    (%rsi,%rsi,2),%r9
  80f289:	43 80 7c 88 07 06    	cmpb   $0x6,0x7(%r8,%r9,4)
  80f28f:	75 8f                	jne    80f220 <<gpui_canvas::text::planner::Planner>::shape+0x1160>
  80f291:	e9 af fe ff ff       	jmp    80f145 <<gpui_canvas::text::planner::Planner>::shape+0x1085>
  80f296:	0f 85 c2 1d 00 00    	jne    81105e <<gpui_canvas::text::planner::Planner>::shape+0x2f9e>
  80f29c:	4d 85 ed             	test   %r13,%r13
  80f29f:	74 1e                	je     80f2bf <<gpui_canvas::text::planner::Planner>::shape+0x11ff>
  80f2a1:	4c 3b 6c 24 08       	cmp    0x8(%rsp),%r13
  80f2a6:	73 11                	jae    80f2b9 <<gpui_canvas::text::planner::Planner>::shape+0x11f9>
  80f2a8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  80f2ad:	42 80 3c 28 c0       	cmpb   $0xc0,(%rax,%r13,1)
  80f2b2:	7d 0b                	jge    80f2bf <<gpui_canvas::text::planner::Planner>::shape+0x11ff>
  80f2b4:	e9 a5 1d 00 00       	jmp    81105e <<gpui_canvas::text::planner::Planner>::shape+0x2f9e>
  80f2b9:	0f 85 9f 1d 00 00    	jne    81105e <<gpui_canvas::text::planner::Planner>::shape+0x2f9e>
  80f2bf:	0f 57 c0             	xorps  %xmm0,%xmm0
  80f2c2:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  80f2c9:	00 
  80f2ca:	48 3b 44 24 40       	cmp    0x40(%rsp),%rax
  80f2cf:	74 0d                	je     80f2de <<gpui_canvas::text::planner::Planner>::shape+0x121e>
  80f2d1:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  80f2d8:	00 
  80f2d9:	f3 0f 10 40 30       	movss  0x30(%rax),%xmm0
  80f2de:	f3 0f 11 44 24 30    	movss  %xmm0,0x30(%rsp)
  80f2e4:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  80f2eb:	00 
  80f2ec:	f3 0f 10 48 40       	movss  0x40(%rax),%xmm1
  80f2f1:	f3 0f 10 40 44       	movss  0x44(%rax),%xmm0
  80f2f6:	0f 29 8c 24 10 01 00 	movaps %xmm1,0x110(%rsp)
  80f2fd:	00 
  80f2fe:	f3 0f 5d 48 48       	minss  0x48(%rax),%xmm1
  80f303:	0f 29 8c 24 90 02 00 	movaps %xmm1,0x290(%rsp)
  80f30a:	00 
  80f30b:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  80f312:	00 
  80f313:	f3 0f 5f 40 4c       	maxss  0x4c(%rax),%xmm0
  80f318:	0f 29 84 24 f0 01 00 	movaps %xmm0,0x1f0(%rsp)
  80f31f:	00 
  80f320:	f3 0f 10 40 24       	movss  0x24(%rax),%xmm0
  80f325:	f3 0f 58 44 24 24    	addss  0x24(%rsp),%xmm0
  80f32b:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  80f332:	00 00 
  80f334:	48 8b 9c 24 68 01 00 	mov    0x168(%rsp),%rbx
  80f33b:	00 
  80f33c:	48 3b 9c 24 58 01 00 	cmp    0x158(%rsp),%rbx
  80f343:	00 
  80f344:	75 0e                	jne    80f354 <<gpui_canvas::text::planner::Planner>::shape+0x1294>
  80f346:	48 8d bc 24 58 01 00 	lea    0x158(%rsp),%rdi
  80f34d:	00 
  80f34e:	ff 15 b4 c8 31 00    	call   *0x31c8b4(%rip)        # b2bc08 <_DYNAMIC+0xf38>
  80f354:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  80f359:	41 01 c6             	add    %eax,%r14d
  80f35c:	41 01 c5             	add    %eax,%r13d
  80f35f:	0f 28 94 24 90 02 00 	movaps 0x290(%rsp),%xmm2
  80f366:	00 
  80f367:	0f 28 c2             	movaps %xmm2,%xmm0
  80f36a:	f3 0f c2 c2 03       	cmpunordss %xmm2,%xmm0
  80f36f:	0f 28 c8             	movaps %xmm0,%xmm1
  80f372:	0f 55 ca             	andnps %xmm2,%xmm1
  80f375:	0f 54 84 24 10 01 00 	andps  0x110(%rsp),%xmm0
  80f37c:	00 
  80f37d:	0f 56 c1             	orps   %xmm1,%xmm0
  80f380:	f3 0f 10 4c 24 24    	movss  0x24(%rsp),%xmm1
  80f386:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  80f38a:	0f 28 a4 24 f0 01 00 	movaps 0x1f0(%rsp),%xmm4
  80f391:	00 
  80f392:	0f 28 d4             	movaps %xmm4,%xmm2
  80f395:	f3 0f c2 d4 03       	cmpunordss %xmm4,%xmm2
  80f39a:	0f 28 da             	movaps %xmm2,%xmm3
  80f39d:	0f 55 dc             	andnps %xmm4,%xmm3
  80f3a0:	0f 54 94 24 00 01 00 	andps  0x100(%rsp),%xmm2
  80f3a7:	00 
  80f3a8:	0f 56 d3             	orps   %xmm3,%xmm2
  80f3ab:	f3 0f 5c d0          	subss  %xmm0,%xmm2
  80f3af:	48 8b 84 24 60 01 00 	mov    0x160(%rsp),%rax
  80f3b6:	00 
  80f3b7:	48 8d 0c 5b          	lea    (%rbx,%rbx,2),%rcx
  80f3bb:	44 89 34 c8          	mov    %r14d,(%rax,%rcx,8)
  80f3bf:	44 89 6c c8 04       	mov    %r13d,0x4(%rax,%rcx,8)
  80f3c4:	f3 0f 11 4c c8 08    	movss  %xmm1,0x8(%rax,%rcx,8)
  80f3ca:	f3 0f 11 54 c8 0c    	movss  %xmm2,0xc(%rax,%rcx,8)
  80f3d0:	f3 0f 10 84 24 80 00 	movss  0x80(%rsp),%xmm0
  80f3d7:	00 00 
  80f3d9:	f3 0f 11 44 c8 10    	movss  %xmm0,0x10(%rax,%rcx,8)
  80f3df:	f3 0f 10 44 24 30    	movss  0x30(%rsp),%xmm0
  80f3e5:	f3 0f 11 44 c8 14    	movss  %xmm0,0x14(%rax,%rcx,8)
  80f3eb:	48 ff c3             	inc    %rbx
  80f3ee:	48 89 9c 24 68 01 00 	mov    %rbx,0x168(%rsp)
  80f3f5:	00 
  80f3f6:	44 89 ac 24 18 02 00 	mov    %r13d,0x218(%rsp)
  80f3fd:	00 
  80f3fe:	8b 4c 24 70          	mov    0x70(%rsp),%ecx
  80f402:	48 c7 84 24 00 07 00 	movq   $0x0,0x700(%rsp)
  80f409:	00 00 00 00 00 
  80f40e:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  80f413:	48 89 84 24 08 07 00 	mov    %rax,0x708(%rsp)
  80f41a:	00 
  80f41b:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  80f422:	00 
  80f423:	48 89 84 24 10 07 00 	mov    %rax,0x710(%rsp)
  80f42a:	00 
  80f42b:	48 83 c0 70          	add    $0x70,%rax
  80f42f:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  80f436:	00 
  80f437:	89 8c 24 18 07 00 00 	mov    %ecx,0x718(%rsp)
  80f43e:	ff c1                	inc    %ecx
  80f440:	89 4c 24 70          	mov    %ecx,0x70(%rsp)
  80f444:	c6 84 24 c0 07 00 00 	movb   $0x2,0x7c0(%rsp)
  80f44b:	02 
  80f44c:	c7 84 24 c8 07 00 00 	movl   $0x0,0x7c8(%rsp)
  80f453:	00 00 00 00 
  80f457:	48 8d bc 24 a0 02 00 	lea    0x2a0(%rsp),%rdi
  80f45e:	00 
  80f45f:	48 8d b4 24 00 07 00 	lea    0x700(%rsp),%rsi
  80f466:	00 
  80f467:	e8 d4 c0 fd ff       	call   7eb540 <<parley::layout::line::GlyphRunIter<()> as core::iter::traits::iterator::Iterator>::next>
  80f46c:	83 bc 24 a0 02 00 00 	cmpl   $0x1,0x2a0(%rsp)
  80f473:	01 
  80f474:	0f 85 89 0f 00 00    	jne    810403 <<gpui_canvas::text::planner::Planner>::shape+0x2343>
  80f47a:	48 8b 84 24 a8 02 00 	mov    0x2a8(%rsp),%rax
  80f481:	00 
  80f482:	48 85 c0             	test   %rax,%rax
  80f485:	0f 84 c3 1b 00 00    	je     81104e <<gpui_canvas::text::planner::Planner>::shape+0x2f8e>
  80f48b:	48 89 84 24 f0 02 00 	mov    %rax,0x2f0(%rsp)
  80f492:	00 
  80f493:	41 0f 10 07          	movups (%r15),%xmm0
  80f497:	41 0f 10 4f 10       	movups 0x10(%r15),%xmm1
  80f49c:	41 0f 10 57 20       	movups 0x20(%r15),%xmm2
  80f4a1:	41 0f 10 5f 30       	movups 0x30(%r15),%xmm3
  80f4a6:	48 8d 8c 24 f8 02 00 	lea    0x2f8(%rsp),%rcx
  80f4ad:	00 
  80f4ae:	0f 11 59 30          	movups %xmm3,0x30(%rcx)
  80f4b2:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  80f4b6:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  80f4ba:	0f 11 01             	movups %xmm0,(%rcx)
  80f4bd:	4c 8b 9c 24 f8 02 00 	mov    0x2f8(%rsp),%r11
  80f4c4:	00 
  80f4c5:	49 8b 4b 30          	mov    0x30(%r11),%rcx
  80f4c9:	49 8b 73 38          	mov    0x38(%r11),%rsi
  80f4cd:	48 89 f2             	mov    %rsi,%rdx
  80f4d0:	48 29 ca             	sub    %rcx,%rdx
  80f4d3:	40 0f 92 c7          	setb   %dil
  80f4d7:	48 3b b0 d0 00 00 00 	cmp    0xd0(%rax),%rsi
  80f4de:	40 0f 97 c6          	seta   %sil
  80f4e2:	48 01 c9             	add    %rcx,%rcx
  80f4e5:	48 03 88 c8 00 00 00 	add    0xc8(%rax),%rcx
  80f4ec:	40 08 fe             	or     %dil,%sil
  80f4ef:	40 84 f6             	test   %sil,%sil
  80f4f2:	be 00 00 00 00       	mov    $0x0,%esi
  80f4f7:	48 0f 45 d6          	cmovne %rsi,%rdx
  80f4fb:	be 02 00 00 00       	mov    $0x2,%esi
  80f500:	48 0f 45 ce          	cmovne %rsi,%rcx
  80f504:	48 01 d2             	add    %rdx,%rdx
  80f507:	31 f6                	xor    %esi,%esi
  80f509:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  80f510:	48 39 f2             	cmp    %rsi,%rdx
  80f513:	74 10                	je     80f525 <<gpui_canvas::text::planner::Planner>::shape+0x1465>
  80f515:	66 83 3c 31 00       	cmpw   $0x0,(%rcx,%rsi,1)
  80f51a:	48 8d 76 02          	lea    0x2(%rsi),%rsi
  80f51e:	74 f0                	je     80f510 <<gpui_canvas::text::planner::Planner>::shape+0x1450>
  80f520:	e9 cb 17 00 00       	jmp    810cf0 <<gpui_canvas::text::planner::Planner>::shape+0x2c30>
  80f525:	49 8b 4b 40          	mov    0x40(%r11),%rcx
  80f529:	48 3b 88 b8 00 00 00 	cmp    0xb8(%rax),%rcx
  80f530:	0f 83 5a 21 00 00    	jae    811690 <<gpui_canvas::text::planner::Planner>::shape+0x35d0>
  80f536:	48 c1 e1 06          	shl    $0x6,%rcx
  80f53a:	48 03 88 b0 00 00 00 	add    0xb0(%rax),%rcx
  80f541:	48 8b 34 24          	mov    (%rsp),%rsi
  80f545:	83 3e 01             	cmpl   $0x1,(%rsi)
  80f548:	75 0f                	jne    80f559 <<gpui_canvas::text::planner::Planner>::shape+0x1499>
  80f54a:	48 8b 56 08          	mov    0x8(%rsi),%rdx
  80f54e:	48 3b 51 10          	cmp    0x10(%rcx),%rdx
  80f552:	75 05                	jne    80f559 <<gpui_canvas::text::planner::Planner>::shape+0x1499>
  80f554:	45 31 f6             	xor    %r14d,%r14d
  80f557:	eb 4c                	jmp    80f5a5 <<gpui_canvas::text::planner::Planner>::shape+0x14e5>
  80f559:	83 7e 10 01          	cmpl   $0x1,0x10(%rsi)
  80f55d:	75 10                	jne    80f56f <<gpui_canvas::text::planner::Planner>::shape+0x14af>
  80f55f:	48 8b 56 18          	mov    0x18(%rsi),%rdx
  80f563:	41 be 01 00 00 00    	mov    $0x1,%r14d
  80f569:	48 3b 51 10          	cmp    0x10(%rcx),%rdx
  80f56d:	74 1e                	je     80f58d <<gpui_canvas::text::planner::Planner>::shape+0x14cd>
  80f56f:	83 7e 20 01          	cmpl   $0x1,0x20(%rsi)
  80f573:	0f 85 61 1b 00 00    	jne    8110da <<gpui_canvas::text::planner::Planner>::shape+0x301a>
  80f579:	48 8b 56 28          	mov    0x28(%rsi),%rdx
  80f57d:	41 be 02 00 00 00    	mov    $0x2,%r14d
  80f583:	48 3b 51 10          	cmp    0x10(%rcx),%rdx
  80f587:	0f 85 4d 1b 00 00    	jne    8110da <<gpui_canvas::text::planner::Planner>::shape+0x301a>
  80f58d:	41 8d 4e ff          	lea    -0x1(%r14),%ecx
  80f591:	48 8b 94 24 08 02 00 	mov    0x208(%rsp),%rdx
  80f598:	00 
  80f599:	48 0f ab ca          	bts    %rcx,%rdx
  80f59d:	48 89 94 24 08 02 00 	mov    %rdx,0x208(%rsp)
  80f5a4:	00 
  80f5a5:	8b bc 24 18 03 00 00 	mov    0x318(%rsp),%edi
  80f5ac:	48 8b 70 58          	mov    0x58(%rax),%rsi
  80f5b0:	48 39 fe             	cmp    %rdi,%rsi
  80f5b3:	0f 86 93 21 00 00    	jbe    81174c <<gpui_canvas::text::planner::Planner>::shape+0x368c>
  80f5b9:	48 8b 94 24 08 03 00 	mov    0x308(%rsp),%rdx
  80f5c0:	00 
  80f5c1:	48 85 d2             	test   %rdx,%rdx
  80f5c4:	48 89 94 24 80 03 00 	mov    %rdx,0x380(%rsp)
  80f5cb:	00 
  80f5cc:	74 0a                	je     80f5d8 <<gpui_canvas::text::planner::Planner>::shape+0x1518>
  80f5ce:	48 8d 4a 18          	lea    0x18(%rdx),%rcx
  80f5d2:	48 83 c2 1c          	add    $0x1c,%rdx
  80f5d6:	eb 1b                	jmp    80f5f3 <<gpui_canvas::text::planner::Planner>::shape+0x1533>
  80f5d8:	48 8b 48 50          	mov    0x50(%rax),%rcx
  80f5dc:	48 8d 34 ff          	lea    (%rdi,%rdi,8),%rsi
  80f5e0:	48 c1 e6 04          	shl    $0x4,%rsi
  80f5e4:	48 8d 14 31          	lea    (%rcx,%rsi,1),%rdx
  80f5e8:	48 83 c2 54          	add    $0x54,%rdx
  80f5ec:	48 01 f1             	add    %rsi,%rcx
  80f5ef:	48 83 c1 50          	add    $0x50,%rcx
  80f5f3:	48 8b b4 24 f8 00 00 	mov    0xf8(%rsp),%rsi
  80f5fa:	00 
  80f5fb:	48 89 b4 24 88 03 00 	mov    %rsi,0x388(%rsp)
  80f602:	00 
  80f603:	48 8b 70 68          	mov    0x68(%rax),%rsi
  80f607:	48 8b 78 70          	mov    0x70(%rax),%rdi
  80f60b:	4c 8b 80 80 00 00 00 	mov    0x80(%rax),%r8
  80f612:	4c 8b 88 88 00 00 00 	mov    0x88(%rax),%r9
  80f619:	4c 8b 90 98 00 00 00 	mov    0x98(%rax),%r10
  80f620:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
  80f627:	8b 12                	mov    (%rdx),%edx
  80f629:	8b 09                	mov    (%rcx),%ecx
  80f62b:	4c 89 9c 24 40 02 00 	mov    %r11,0x240(%rsp)
  80f632:	00 
  80f633:	45 0f b6 9b 8c 00 00 	movzbl 0x8c(%r11),%r11d
  80f63a:	00 
  80f63b:	41 80 e3 01          	and    $0x1,%r11b
  80f63f:	89 d3                	mov    %edx,%ebx
  80f641:	29 cb                	sub    %ecx,%ebx
  80f643:	48 c7 84 24 b0 04 00 	movq   $0x0,0x4b0(%rsp)
  80f64a:	00 00 00 00 00 
  80f64f:	48 c7 84 24 d0 04 00 	movq   $0x0,0x4d0(%rsp)
  80f656:	00 00 00 00 00 
  80f65b:	c7 84 24 f0 04 00 00 	movl   $0x0,0x4f0(%rsp)
  80f662:	00 00 00 00 
  80f666:	89 9c 24 f4 04 00 00 	mov    %ebx,0x4f4(%rsp)
  80f66d:	48 89 b4 24 f8 04 00 	mov    %rsi,0x4f8(%rsp)
  80f674:	00 
  80f675:	48 89 bc 24 00 05 00 	mov    %rdi,0x500(%rsp)
  80f67c:	00 
  80f67d:	4c 89 84 24 08 05 00 	mov    %r8,0x508(%rsp)
  80f684:	00 
  80f685:	4c 89 8c 24 10 05 00 	mov    %r9,0x510(%rsp)
  80f68c:	00 
  80f68d:	4c 89 94 24 18 05 00 	mov    %r10,0x518(%rsp)
  80f694:	00 
  80f695:	48 89 84 24 20 05 00 	mov    %rax,0x520(%rsp)
  80f69c:	00 
  80f69d:	89 8c 24 28 05 00 00 	mov    %ecx,0x528(%rsp)
  80f6a4:	89 94 24 2c 05 00 00 	mov    %edx,0x52c(%rsp)
  80f6ab:	89 8c 24 30 05 00 00 	mov    %ecx,0x530(%rsp)
  80f6b2:	89 94 24 34 05 00 00 	mov    %edx,0x534(%rsp)
  80f6b9:	44 88 9c 24 38 05 00 	mov    %r11b,0x538(%rsp)
  80f6c0:	00 
  80f6c1:	f2 0f 10 84 24 28 03 	movsd  0x328(%rsp),%xmm0
  80f6c8:	00 00 
  80f6ca:	0f 29 84 24 d0 03 00 	movaps %xmm0,0x3d0(%rsp)
  80f6d1:	00 
  80f6d2:	8b 94 24 20 03 00 00 	mov    0x320(%rsp),%edx
  80f6d9:	8b 8c 24 24 03 00 00 	mov    0x324(%rsp),%ecx
  80f6e0:	48 8d bc 24 e8 03 00 	lea    0x3e8(%rsp),%rdi
  80f6e7:	00 
  80f6e8:	48 8d b4 24 f0 02 00 	lea    0x2f0(%rsp),%rsi
  80f6ef:	00 
  80f6f0:	e8 cb 12 fe ff       	call   7f09c0 <<parley::layout::run::Run<()>>::glyphs_in>
  80f6f5:	0f 28 94 24 d0 03 00 	movaps 0x3d0(%rsp),%xmm2
  80f6fc:	00 
  80f6fd:	0f 13 94 24 80 04 00 	movlps %xmm2,0x480(%rsp)
  80f704:	00 
  80f705:	4c 8b ac 24 e8 03 00 	mov    0x3e8(%rsp),%r13
  80f70c:	00 
  80f70d:	48 8b 84 24 f0 03 00 	mov    0x3f0(%rsp),%rax
  80f714:	00 
  80f715:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  80f71c:	00 
  80f71d:	0f b6 84 24 f8 03 00 	movzbl 0x3f8(%rsp),%eax
  80f724:	00 
  80f725:	8b 8c 24 fc 03 00 00 	mov    0x3fc(%rsp),%ecx
  80f72c:	89 8c 24 ac 01 00 00 	mov    %ecx,0x1ac(%rsp)
  80f733:	f2 0f 10 84 24 00 04 	movsd  0x400(%rsp),%xmm0
  80f73a:	00 00 
  80f73c:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  80f743:	00 
  80f744:	f3 0f 10 84 24 08 04 	movss  0x408(%rsp),%xmm0
  80f74b:	00 00 
  80f74d:	f3 0f 11 84 24 a8 01 	movss  %xmm0,0x1a8(%rsp)
  80f754:	00 00 
  80f756:	48 8b 8c 24 10 04 00 	mov    0x410(%rsp),%rcx
  80f75d:	00 
  80f75e:	48 89 8c 24 68 02 00 	mov    %rcx,0x268(%rsp)
  80f765:	00 
  80f766:	48 8b 8c 24 18 04 00 	mov    0x418(%rsp),%rcx
  80f76d:	00 
  80f76e:	48 89 8c 24 00 02 00 	mov    %rcx,0x200(%rsp)
  80f775:	00 
  80f776:	48 8b 94 24 20 04 00 	mov    0x420(%rsp),%rdx
  80f77d:	00 
  80f77e:	48 8b 9c 24 28 04 00 	mov    0x428(%rsp),%rbx
  80f785:	00 
  80f786:	48 8b 8c 24 30 04 00 	mov    0x430(%rsp),%rcx
  80f78d:	00 
  80f78e:	48 89 8c 24 78 02 00 	mov    %rcx,0x278(%rsp)
  80f795:	00 
  80f796:	48 8b 8c 24 38 04 00 	mov    0x438(%rsp),%rcx
  80f79d:	00 
  80f79e:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  80f7a5:	00 
  80f7a6:	8b 8c 24 40 04 00 00 	mov    0x440(%rsp),%ecx
  80f7ad:	48 89 8c 24 e8 01 00 	mov    %rcx,0x1e8(%rsp)
  80f7b4:	00 
  80f7b5:	8b 8c 24 44 04 00 00 	mov    0x444(%rsp),%ecx
  80f7bc:	48 89 8c 24 e0 01 00 	mov    %rcx,0x1e0(%rsp)
  80f7c3:	00 
  80f7c4:	8b 8c 24 48 04 00 00 	mov    0x448(%rsp),%ecx
  80f7cb:	48 89 8c 24 10 01 00 	mov    %rcx,0x110(%rsp)
  80f7d2:	00 
  80f7d3:	8b 8c 24 4c 04 00 00 	mov    0x44c(%rsp),%ecx
  80f7da:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  80f7df:	f3 0f 10 84 24 50 04 	movss  0x450(%rsp),%xmm0
  80f7e6:	00 00 
  80f7e8:	f3 0f 11 84 24 b0 01 	movss  %xmm0,0x1b0(%rsp)
  80f7ef:	00 00 
  80f7f1:	f3 0f 10 84 24 54 04 	movss  0x454(%rsp),%xmm0
  80f7f8:	00 00 
  80f7fa:	f3 0f 11 44 24 5c    	movss  %xmm0,0x5c(%rsp)
  80f800:	48 8b 8c 24 58 04 00 	mov    0x458(%rsp),%rcx
  80f807:	00 
  80f808:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
  80f80f:	00 
  80f810:	f3 0f 10 84 24 70 04 	movss  0x470(%rsp),%xmm0
  80f817:	00 00 
  80f819:	f3 0f 10 8c 24 6c 04 	movss  0x46c(%rsp),%xmm1
  80f820:	00 00 
  80f822:	f3 0f 11 84 24 28 02 	movss  %xmm0,0x228(%rsp)
  80f829:	00 00 
  80f82b:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  80f82f:	f3 0f 10 84 24 74 04 	movss  0x474(%rsp),%xmm0
  80f836:	00 00 
  80f838:	f3 0f 11 8c 24 24 02 	movss  %xmm1,0x224(%rsp)
  80f83f:	00 00 
  80f841:	f3 0f 58 c1          	addss  %xmm1,%xmm0
  80f845:	f3 0f 11 84 24 1c 02 	movss  %xmm0,0x21c(%rsp)
  80f84c:	00 00 
  80f84e:	0f 28 c2             	movaps %xmm2,%xmm0
  80f851:	0f b6 8c 24 7c 04 00 	movzbl 0x47c(%rsp),%ecx
  80f858:	00 
  80f859:	88 8c 24 90 02 00 00 	mov    %cl,0x290(%rsp)
  80f860:	48 8b 8c 24 60 04 00 	mov    0x460(%rsp),%rcx
  80f867:	00 
  80f868:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  80f86f:	00 
  80f870:	8b 8c 24 68 04 00 00 	mov    0x468(%rsp),%ecx
  80f877:	89 8c 24 e0 00 00 00 	mov    %ecx,0xe0(%rsp)
  80f87e:	8b 8c 24 78 04 00 00 	mov    0x478(%rsp),%ecx
  80f885:	89 8c 24 20 02 00 00 	mov    %ecx,0x220(%rsp)
  80f88c:	48 8d 4a 16          	lea    0x16(%rdx),%rcx
  80f890:	48 89 8c 24 50 02 00 	mov    %rcx,0x250(%rsp)
  80f897:	00 
  80f898:	48 89 94 24 f0 01 00 	mov    %rdx,0x1f0(%rsp)
  80f89f:	00 
  80f8a0:	48 8d 4a 2e          	lea    0x2e(%rdx),%rcx
  80f8a4:	48 89 8c 24 90 03 00 	mov    %rcx,0x390(%rsp)
  80f8ab:	00 
  80f8ac:	4c 89 b4 24 60 02 00 	mov    %r14,0x260(%rsp)
  80f8b3:	00 
  80f8b4:	48 89 9c 24 d8 01 00 	mov    %rbx,0x1d8(%rsp)
  80f8bb:	00 
  80f8bc:	eb 6d                	jmp    80f92b <<gpui_canvas::text::planner::Planner>::shape+0x186b>
  80f8be:	44 03 74 24 40       	add    0x40(%rsp),%r14d
  80f8c3:	0f 28 8c 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm1
  80f8ca:	00 
  80f8cb:	f3 0f 58 4c 24 24    	addss  0x24(%rsp),%xmm1
  80f8d1:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  80f8d8:	00 
  80f8d9:	48 89 d9             	mov    %rbx,%rcx
  80f8dc:	48 c1 e1 04          	shl    $0x4,%rcx
  80f8e0:	44 89 34 08          	mov    %r14d,(%rax,%rcx,1)
  80f8e4:	f3 0f 10 44 24 78    	movss  0x78(%rsp),%xmm0
  80f8ea:	f3 0f 11 44 08 04    	movss  %xmm0,0x4(%rax,%rcx,1)
  80f8f0:	f3 0f 11 4c 08 08    	movss  %xmm1,0x8(%rax,%rcx,1)
  80f8f6:	66 44 89 64 08 0c    	mov    %r12w,0xc(%rax,%rcx,1)
  80f8fc:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
  80f903:	00 
  80f904:	88 54 08 0e          	mov    %dl,0xe(%rax,%rcx,1)
  80f908:	c6 44 08 0f 00       	movb   $0x0,0xf(%rax,%rcx,1)
  80f90d:	48 ff c3             	inc    %rbx
  80f910:	48 89 9c 24 f8 00 00 	mov    %rbx,0xf8(%rsp)
  80f917:	00 
  80f918:	31 c0                	xor    %eax,%eax
  80f91a:	48 8b 9c 24 d8 01 00 	mov    0x1d8(%rsp),%rbx
  80f921:	00 
  80f922:	f3 0f 10 84 24 b4 01 	movss  0x1b4(%rsp),%xmm0
  80f929:	00 00 
  80f92b:	f3 0f 11 44 24 78    	movss  %xmm0,0x78(%rsp)
  80f931:	a8 01                	test   $0x1,%al
  80f933:	74 5b                	je     80f990 <<gpui_canvas::text::planner::Planner>::shape+0x18d0>
  80f935:	f3 0f 10 84 24 a8 01 	movss  0x1a8(%rsp),%xmm0
  80f93c:	00 00 
  80f93e:	f3 0f 11 84 24 00 01 	movss  %xmm0,0x100(%rsp)
  80f945:	00 00 
  80f947:	44 8b b4 24 ac 01 00 	mov    0x1ac(%rsp),%r14d
  80f94e:	00 
  80f94f:	0f 28 84 24 30 02 00 	movaps 0x230(%rsp),%xmm0
  80f956:	00 
  80f957:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  80f95e:	00 
  80f95f:	83 bc 24 e0 00 00 00 	cmpl   $0x0,0xe0(%rsp)
  80f966:	00 
  80f967:	74 74                	je     80f9dd <<gpui_canvas::text::planner::Planner>::shape+0x191d>
  80f969:	48 83 bc 24 80 00 00 	cmpq   $0x0,0x80(%rsp)
  80f970:	00 00 
  80f972:	74 7c                	je     80f9f0 <<gpui_canvas::text::planner::Planner>::shape+0x1930>
  80f974:	0f 28 84 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm0
  80f97b:	00 
  80f97c:	f3 0f 11 84 24 dc 00 	movss  %xmm0,0xdc(%rsp)
  80f983:	00 00 
  80f985:	e9 9a 00 00 00       	jmp    80fa24 <<gpui_canvas::text::planner::Planner>::shape+0x1964>
  80f98a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  80f990:	4c 3b ac 24 c8 00 00 	cmp    0xc8(%rsp),%r13
  80f997:	00 
  80f998:	0f 84 58 01 00 00    	je     80faf6 <<gpui_canvas::text::planner::Planner>::shape+0x1a36>
  80f99e:	48 8b 94 24 80 00 00 	mov    0x80(%rsp),%rdx
  80f9a5:	00 
  80f9a6:	45 8b 75 00          	mov    0x0(%r13),%r14d
  80f9aa:	f2 41 0f 10 45 04    	movsd  0x4(%r13),%xmm0
  80f9b0:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  80f9b7:	00 
  80f9b8:	f3 41 0f 10 45 0c    	movss  0xc(%r13),%xmm0
  80f9be:	f3 0f 11 84 24 00 01 	movss  %xmm0,0x100(%rsp)
  80f9c5:	00 00 
  80f9c7:	49 83 c5 10          	add    $0x10,%r13
  80f9cb:	48 89 94 24 80 00 00 	mov    %rdx,0x80(%rsp)
  80f9d2:	00 
  80f9d3:	83 bc 24 e0 00 00 00 	cmpl   $0x0,0xe0(%rsp)
  80f9da:	00 
  80f9db:	75 8c                	jne    80f969 <<gpui_canvas::text::planner::Planner>::shape+0x18a9>
  80f9dd:	0f 28 84 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm0
  80f9e4:	00 
  80f9e5:	f3 0f 11 84 24 dc 00 	movss  %xmm0,0xdc(%rsp)
  80f9ec:	00 00 
  80f9ee:	eb 74                	jmp    80fa64 <<gpui_canvas::text::planner::Planner>::shape+0x19a4>
  80f9f0:	f3 0f 10 84 24 b0 01 	movss  0x1b0(%rsp),%xmm0
  80f9f7:	00 00 
  80f9f9:	0f 28 c8             	movaps %xmm0,%xmm1
  80f9fc:	f3 0f 58 8c 24 c0 01 	addss  0x1c0(%rsp),%xmm1
  80fa03:	00 00 
  80fa05:	f3 0f 11 8c 24 dc 00 	movss  %xmm1,0xdc(%rsp)
  80fa0c:	00 00 
  80fa0e:	f3 0f 10 8c 24 00 01 	movss  0x100(%rsp),%xmm1
  80fa15:	00 00 
  80fa17:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  80fa1b:	f3 0f 11 8c 24 00 01 	movss  %xmm1,0x100(%rsp)
  80fa22:	00 00 
  80fa24:	48 8b 94 24 80 00 00 	mov    0x80(%rsp),%rdx
  80fa2b:	00 
  80fa2c:	48 ff c2             	inc    %rdx
  80fa2f:	48 8b 84 24 28 01 00 	mov    0x128(%rsp),%rax
  80fa36:	00 
  80fa37:	48 89 94 24 80 00 00 	mov    %rdx,0x80(%rsp)
  80fa3e:	00 
  80fa3f:	48 39 c2             	cmp    %rax,%rdx
  80fa42:	75 20                	jne    80fa64 <<gpui_canvas::text::planner::Planner>::shape+0x19a4>
  80fa44:	f3 0f 10 84 24 00 01 	movss  0x100(%rsp),%xmm0
  80fa4b:	00 00 
  80fa4d:	f3 0f 58 44 24 5c    	addss  0x5c(%rsp),%xmm0
  80fa53:	f3 0f 11 84 24 00 01 	movss  %xmm0,0x100(%rsp)
  80fa5a:	00 00 
  80fa5c:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  80fa63:	00 
  80fa64:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  80fa6b:	00 
  80fa6c:	48 8d b4 24 b0 04 00 	lea    0x4b0(%rsp),%rsi
  80fa73:	00 
  80fa74:	e8 27 27 00 00       	call   8121a0 <<core::iter::adapters::flatten::FlattenCompat<core::iter::adapters::map::Map<core::ops::range::Range<u32>, <parley::layout::run::Run<()>>::glyph_source_ranges::{closure#0}>, core::iter::sources::repeat_n::RepeatN<core::ops::range::Range<usize>>> as core::iter::traits::iterator::Iterator>::next>
  80fa79:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  80fa80:	01 
  80fa81:	0f 85 b6 15 00 00    	jne    81103d <<gpui_canvas::text::planner::Planner>::shape+0x2f7d>
  80fa87:	f3 0f 10 44 24 78    	movss  0x78(%rsp),%xmm0
  80fa8d:	f3 0f 58 84 24 00 01 	addss  0x100(%rsp),%xmm0
  80fa94:	00 00 
  80fa96:	31 c0                	xor    %eax,%eax
  80fa98:	48 8b 8c 24 90 01 00 	mov    0x190(%rsp),%rcx
  80fa9f:	00 
  80faa0:	48 3b 4c 24 40       	cmp    0x40(%rsp),%rcx
  80faa5:	0f 84 80 fe ff ff    	je     80f92b <<gpui_canvas::text::planner::Planner>::shape+0x186b>
  80faab:	f3 0f 11 84 24 b4 01 	movss  %xmm0,0x1b4(%rsp)
  80fab2:	00 00 
  80fab4:	4c 8b 8c 24 98 00 00 	mov    0x98(%rsp),%r9
  80fabb:	00 
  80fabc:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  80fac3:	00 
  80fac4:	49 39 c9             	cmp    %rcx,%r9
  80fac7:	0f 87 60 15 00 00    	ja     81102d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  80facd:	4d 85 c9             	test   %r9,%r9
  80fad0:	0f 84 01 05 00 00    	je     80ffd7 <<gpui_canvas::text::planner::Planner>::shape+0x1f17>
  80fad6:	4c 3b 4c 24 08       	cmp    0x8(%rsp),%r9
  80fadb:	0f 83 f0 04 00 00    	jae    80ffd1 <<gpui_canvas::text::planner::Planner>::shape+0x1f11>
  80fae1:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  80fae6:	42 80 3c 08 bf       	cmpb   $0xbf,(%rax,%r9,1)
  80faeb:	0f 8f e6 04 00 00    	jg     80ffd7 <<gpui_canvas::text::planner::Planner>::shape+0x1f17>
  80faf1:	e9 37 15 00 00       	jmp    81102d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  80faf6:	4c 89 ac 24 c8 00 00 	mov    %r13,0xc8(%rsp)
  80fafd:	00 
  80fafe:	f6 84 24 90 02 00 00 	testb  $0x1,0x290(%rsp)
  80fb05:	01 
  80fb06:	74 1e                	je     80fb26 <<gpui_canvas::text::planner::Planner>::shape+0x1a66>
  80fb08:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  80fb0d:	48 8b 8c 24 10 01 00 	mov    0x110(%rsp),%rcx
  80fb14:	00 
  80fb15:	39 c1                	cmp    %eax,%ecx
  80fb17:	0f 83 53 01 00 00    	jae    80fc70 <<gpui_canvas::text::planner::Planner>::shape+0x1bb0>
  80fb1d:	ff c8                	dec    %eax
  80fb1f:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  80fb24:	eb 18                	jmp    80fb3e <<gpui_canvas::text::planner::Planner>::shape+0x1a7e>
  80fb26:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  80fb2b:	48 8b 84 24 10 01 00 	mov    0x110(%rsp),%rax
  80fb32:	00 
  80fb33:	39 d0                	cmp    %edx,%eax
  80fb35:	0f 83 50 01 00 00    	jae    80fc8b <<gpui_canvas::text::planner::Planner>::shape+0x1bcb>
  80fb3b:	8d 48 01             	lea    0x1(%rax),%ecx
  80fb3e:	89 c7                	mov    %eax,%edi
  80fb40:	48 39 fb             	cmp    %rdi,%rbx
  80fb43:	48 8b 94 24 f0 01 00 	mov    0x1f0(%rsp),%rdx
  80fb4a:	00 
  80fb4b:	0f 86 7e 1b 00 00    	jbe    8116cf <<gpui_canvas::text::planner::Planner>::shape+0x360f>
  80fb51:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  80fb55:	44 8b 6c c2 08       	mov    0x8(%rdx,%rax,8),%r13d
  80fb5a:	f6 44 c2 17 01       	testb  $0x1,0x17(%rdx,%rax,8)
  80fb5f:	0f 85 6e 05 00 00    	jne    8100d3 <<gpui_canvas::text::planner::Planner>::shape+0x2013>
  80fb65:	48 8d 04 c2          	lea    (%rdx,%rax,8),%rax
  80fb69:	8b 50 0c             	mov    0xc(%rax),%edx
  80fb6c:	4a 8d 34 2a          	lea    (%rdx,%r13,1),%rsi
  80fb70:	48 3b b4 24 30 01 00 	cmp    0x130(%rsp),%rsi
  80fb77:	00 
  80fb78:	0f 87 8e 17 00 00    	ja     81130c <<gpui_canvas::text::planner::Planner>::shape+0x324c>
  80fb7e:	49 c1 e5 04          	shl    $0x4,%r13
  80fb82:	4c 03 ac 24 78 02 00 	add    0x278(%rsp),%r13
  80fb89:	00 
  80fb8a:	48 89 d0             	mov    %rdx,%rax
  80fb8d:	48 c1 e0 04          	shl    $0x4,%rax
  80fb91:	4c 01 e8             	add    %r13,%rax
  80fb94:	0f 57 c0             	xorps  %xmm0,%xmm0
  80fb97:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  80fb9e:	00 
  80fb9f:	48 85 d2             	test   %rdx,%rdx
  80fba2:	0f 85 d5 06 00 00    	jne    81027d <<gpui_canvas::text::planner::Planner>::shape+0x21bd>
  80fba8:	89 ca                	mov    %ecx,%edx
  80fbaa:	48 89 94 24 10 01 00 	mov    %rdx,0x110(%rsp)
  80fbb1:	00 
  80fbb2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  80fbb9:	1f 84 00 00 00 00 00 
  80fbc0:	f6 84 24 90 02 00 00 	testb  $0x1,0x290(%rsp)
  80fbc7:	01 
  80fbc8:	74 26                	je     80fbf0 <<gpui_canvas::text::planner::Planner>::shape+0x1b30>
  80fbca:	4c 8b 64 24 30       	mov    0x30(%rsp),%r12
  80fbcf:	44 39 e1             	cmp    %r12d,%ecx
  80fbd2:	0f 83 d2 00 00 00    	jae    80fcaa <<gpui_canvas::text::planner::Planner>::shape+0x1bea>
  80fbd8:	41 ff cc             	dec    %r12d
  80fbdb:	4c 89 e0             	mov    %r12,%rax
  80fbde:	89 ca                	mov    %ecx,%edx
  80fbe0:	4c 89 64 24 30       	mov    %r12,0x30(%rsp)
  80fbe5:	89 c1                	mov    %eax,%ecx
  80fbe7:	eb 21                	jmp    80fc0a <<gpui_canvas::text::planner::Planner>::shape+0x1b4a>
  80fbe9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  80fbf0:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  80fbf5:	39 d1                	cmp    %edx,%ecx
  80fbf7:	0f 83 55 01 00 00    	jae    80fd52 <<gpui_canvas::text::planner::Planner>::shape+0x1c92>
  80fbfd:	8d 41 01             	lea    0x1(%rcx),%eax
  80fc00:	48 89 84 24 10 01 00 	mov    %rax,0x110(%rsp)
  80fc07:	00 
  80fc08:	89 c2                	mov    %eax,%edx
  80fc0a:	89 cf                	mov    %ecx,%edi
  80fc0c:	48 39 fb             	cmp    %rdi,%rbx
  80fc0f:	48 8b 8c 24 f0 01 00 	mov    0x1f0(%rsp),%rcx
  80fc16:	00 
  80fc17:	0f 86 b2 1a 00 00    	jbe    8116cf <<gpui_canvas::text::planner::Planner>::shape+0x360f>
  80fc1d:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  80fc21:	44 8b 6c c1 08       	mov    0x8(%rcx,%rax,8),%r13d
  80fc26:	f6 44 c1 17 01       	testb  $0x1,0x17(%rcx,%rax,8)
  80fc2b:	0f 85 9a 04 00 00    	jne    8100cb <<gpui_canvas::text::planner::Planner>::shape+0x200b>
  80fc31:	48 8d 04 c1          	lea    (%rcx,%rax,8),%rax
  80fc35:	8b 78 0c             	mov    0xc(%rax),%edi
  80fc38:	4a 8d 34 2f          	lea    (%rdi,%r13,1),%rsi
  80fc3c:	48 3b b4 24 30 01 00 	cmp    0x130(%rsp),%rsi
  80fc43:	00 
  80fc44:	0f 87 c2 16 00 00    	ja     81130c <<gpui_canvas::text::planner::Planner>::shape+0x324c>
  80fc4a:	49 c1 e5 04          	shl    $0x4,%r13
  80fc4e:	4c 03 ac 24 78 02 00 	add    0x278(%rsp),%r13
  80fc55:	00 
  80fc56:	48 89 f8             	mov    %rdi,%rax
  80fc59:	48 c1 e0 04          	shl    $0x4,%rax
  80fc5d:	4c 01 e8             	add    %r13,%rax
  80fc60:	89 d1                	mov    %edx,%ecx
  80fc62:	48 85 ff             	test   %rdi,%rdi
  80fc65:	0f 84 55 ff ff ff    	je     80fbc0 <<gpui_canvas::text::planner::Planner>::shape+0x1b00>
  80fc6b:	e9 d8 04 00 00       	jmp    810148 <<gpui_canvas::text::planner::Planner>::shape+0x2088>
  80fc70:	4c 89 e8             	mov    %r13,%rax
  80fc73:	3b 8c 24 e8 01 00 00 	cmp    0x1e8(%rsp),%ecx
  80fc7a:	0f 95 c2             	setne  %dl
  80fc7d:	84 94 24 e0 00 00 00 	test   %dl,0xe0(%rsp)
  80fc84:	75 4e                	jne    80fcd4 <<gpui_canvas::text::planner::Planner>::shape+0x1c14>
  80fc86:	e9 0f 06 00 00       	jmp    81029a <<gpui_canvas::text::planner::Planner>::shape+0x21da>
  80fc8b:	4c 89 e8             	mov    %r13,%rax
  80fc8e:	3b 94 24 e0 01 00 00 	cmp    0x1e0(%rsp),%edx
  80fc95:	0f 95 c1             	setne  %cl
  80fc98:	84 8c 24 e0 00 00 00 	test   %cl,0xe0(%rsp)
  80fc9f:	0f 85 d7 00 00 00    	jne    80fd7c <<gpui_canvas::text::planner::Planner>::shape+0x1cbc>
  80fca5:	e9 f0 05 00 00       	jmp    81029a <<gpui_canvas::text::planner::Planner>::shape+0x21da>
  80fcaa:	0f 57 c0             	xorps  %xmm0,%xmm0
  80fcad:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  80fcb4:	00 
  80fcb5:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  80fcbc:	00 
  80fcbd:	3b 8c 24 e8 01 00 00 	cmp    0x1e8(%rsp),%ecx
  80fcc4:	0f 95 c2             	setne  %dl
  80fcc7:	84 94 24 e0 00 00 00 	test   %dl,0xe0(%rsp)
  80fcce:	0f 84 c6 05 00 00    	je     81029a <<gpui_canvas::text::planner::Planner>::shape+0x21da>
  80fcd4:	8d 79 ff             	lea    -0x1(%rcx),%edi
  80fcd7:	48 39 fb             	cmp    %rdi,%rbx
  80fcda:	0f 86 90 1a 00 00    	jbe    811770 <<gpui_canvas::text::planner::Planner>::shape+0x36b0>
  80fce0:	3b bc 24 e8 01 00 00 	cmp    0x1e8(%rsp),%edi
  80fce7:	76 43                	jbe    80fd2c <<gpui_canvas::text::planner::Planner>::shape+0x1c6c>
  80fce9:	48 8d 14 7f          	lea    (%rdi,%rdi,2),%rdx
  80fced:	48 8b b4 24 50 02 00 	mov    0x250(%rsp),%rsi
  80fcf4:	00 
  80fcf5:	48 8d 14 d6          	lea    (%rsi,%rdx,8),%rdx
  80fcf9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  80fd00:	48 39 fb             	cmp    %rdi,%rbx
  80fd03:	0f 86 e7 19 00 00    	jbe    8116f0 <<gpui_canvas::text::planner::Planner>::shape+0x3630>
  80fd09:	f6 42 01 02          	testb  $0x2,0x1(%rdx)
  80fd0d:	75 1d                	jne    80fd2c <<gpui_canvas::text::planner::Planner>::shape+0x1c6c>
  80fd0f:	48 ff cf             	dec    %rdi
  80fd12:	48 83 c2 e8          	add    $0xffffffffffffffe8,%rdx
  80fd16:	39 bc 24 e8 01 00 00 	cmp    %edi,0x1e8(%rsp)
  80fd1d:	72 e1                	jb     80fd00 <<gpui_canvas::text::planner::Planner>::shape+0x1c40>
  80fd1f:	48 8b 94 24 e8 01 00 	mov    0x1e8(%rsp),%rdx
  80fd26:	00 
  80fd27:	48 89 d7             	mov    %rdx,%rdi
  80fd2a:	eb 02                	jmp    80fd2e <<gpui_canvas::text::planner::Planner>::shape+0x1c6e>
  80fd2c:	89 fa                	mov    %edi,%edx
  80fd2e:	48 39 fb             	cmp    %rdi,%rbx
  80fd31:	0f 86 45 1a 00 00    	jbe    81177c <<gpui_canvas::text::planner::Planner>::shape+0x36bc>
  80fd37:	48 89 94 24 10 01 00 	mov    %rdx,0x110(%rsp)
  80fd3e:	00 
  80fd3f:	89 ca                	mov    %ecx,%edx
  80fd41:	48 ff ca             	dec    %rdx
  80fd44:	48 39 da             	cmp    %rbx,%rdx
  80fd47:	0f 82 a1 00 00 00    	jb     80fdee <<gpui_canvas::text::planner::Planner>::shape+0x1d2e>
  80fd4d:	e9 36 1a 00 00       	jmp    811788 <<gpui_canvas::text::planner::Planner>::shape+0x36c8>
  80fd52:	0f 57 c0             	xorps  %xmm0,%xmm0
  80fd55:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  80fd5c:	00 
  80fd5d:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  80fd64:	00 
  80fd65:	3b 94 24 e0 01 00 00 	cmp    0x1e0(%rsp),%edx
  80fd6c:	0f 95 c1             	setne  %cl
  80fd6f:	84 8c 24 e0 00 00 00 	test   %cl,0xe0(%rsp)
  80fd76:	0f 84 1e 05 00 00    	je     81029a <<gpui_canvas::text::planner::Planner>::shape+0x21da>
  80fd7c:	49 89 d0             	mov    %rdx,%r8
  80fd7f:	48 89 d1             	mov    %rdx,%rcx
  80fd82:	89 cf                	mov    %ecx,%edi
  80fd84:	48 39 fb             	cmp    %rdi,%rbx
  80fd87:	0f 86 ce 19 00 00    	jbe    81175b <<gpui_canvas::text::planner::Planner>::shape+0x369b>
  80fd8d:	ff c1                	inc    %ecx
  80fd8f:	3b 8c 24 e0 01 00 00 	cmp    0x1e0(%rsp),%ecx
  80fd96:	73 40                	jae    80fdd8 <<gpui_canvas::text::planner::Planner>::shape+0x1d18>
  80fd98:	89 ca                	mov    %ecx,%edx
  80fd9a:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  80fd9e:	48 8b b4 24 50 02 00 	mov    0x250(%rsp),%rsi
  80fda5:	00 
  80fda6:	48 8d 34 ce          	lea    (%rsi,%rcx,8),%rsi
  80fdaa:	48 89 d1             	mov    %rdx,%rcx
  80fdad:	0f 1f 00             	nopl   (%rax)
  80fdb0:	48 39 cb             	cmp    %rcx,%rbx
  80fdb3:	0f 86 1f 19 00 00    	jbe    8116d8 <<gpui_canvas::text::planner::Planner>::shape+0x3618>
  80fdb9:	f6 46 01 02          	testb  $0x2,0x1(%rsi)
  80fdbd:	75 19                	jne    80fdd8 <<gpui_canvas::text::planner::Planner>::shape+0x1d18>
  80fdbf:	48 ff c1             	inc    %rcx
  80fdc2:	48 83 c6 18          	add    $0x18,%rsi
  80fdc6:	48 39 8c 24 e0 01 00 	cmp    %rcx,0x1e0(%rsp)
  80fdcd:	00 
  80fdce:	75 e0                	jne    80fdb0 <<gpui_canvas::text::planner::Planner>::shape+0x1cf0>
  80fdd0:	48 8b 8c 24 e0 01 00 	mov    0x1e0(%rsp),%rcx
  80fdd7:	00 
  80fdd8:	89 ca                	mov    %ecx,%edx
  80fdda:	48 ff ca             	dec    %rdx
  80fddd:	48 39 da             	cmp    %rbx,%rdx
  80fde0:	0f 83 7e 19 00 00    	jae    811764 <<gpui_canvas::text::planner::Planner>::shape+0x36a4>
  80fde6:	4c 89 84 24 10 01 00 	mov    %r8,0x110(%rsp)
  80fded:	00 
  80fdee:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  80fdf3:	48 83 bc 24 68 02 00 	cmpq   $0x0,0x268(%rsp)
  80fdfa:	00 00 
  80fdfc:	0f 84 98 04 00 00    	je     81029a <<gpui_canvas::text::planner::Planner>::shape+0x21da>
  80fe02:	48 8d 0c 7f          	lea    (%rdi,%rdi,2),%rcx
  80fe06:	48 8b b4 24 f0 01 00 	mov    0x1f0(%rsp),%rsi
  80fe0d:	00 
  80fe0e:	8b 0c ce             	mov    (%rsi,%rcx,8),%ecx
  80fe11:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  80fe15:	8b 74 d6 04          	mov    0x4(%rsi,%rdx,8),%esi
  80fe19:	39 ce                	cmp    %ecx,%esi
  80fe1b:	0f 82 15 18 00 00    	jb     811636 <<gpui_canvas::text::planner::Planner>::shape+0x3576>
  80fe21:	48 39 b4 24 00 02 00 	cmp    %rsi,0x200(%rsp)
  80fe28:	00 
  80fe29:	0f 82 07 18 00 00    	jb     811636 <<gpui_canvas::text::planner::Planner>::shape+0x3576>
  80fe2f:	39 ce                	cmp    %ecx,%esi
  80fe31:	0f 84 05 19 00 00    	je     81173c <<gpui_canvas::text::planner::Planner>::shape+0x367c>
  80fe37:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  80fe3b:	48 8b 94 24 68 02 00 	mov    0x268(%rsp),%rdx
  80fe42:	00 
  80fe43:	0f b6 4c 8a 07       	movzbl 0x7(%rdx,%rcx,4),%ecx
  80fe48:	8d 51 ff             	lea    -0x1(%rcx),%edx
  80fe4b:	83 fa 02             	cmp    $0x2,%edx
  80fe4e:	73 28                	jae    80fe78 <<gpui_canvas::text::planner::Planner>::shape+0x1db8>
  80fe50:	f3 0f 10 84 24 24 02 	movss  0x224(%rsp),%xmm0
  80fe57:	00 00 
  80fe59:	f3 0f 11 44 24 5c    	movss  %xmm0,0x5c(%rsp)
  80fe5f:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  80fe64:	3b 94 24 20 02 00 00 	cmp    0x220(%rsp),%edx
  80fe6b:	77 2d                	ja     80fe9a <<gpui_canvas::text::planner::Planner>::shape+0x1dda>
  80fe6d:	f3 0f 10 84 24 1c 02 	movss  0x21c(%rsp),%xmm0
  80fe74:	00 00 
  80fe76:	eb 1c                	jmp    80fe94 <<gpui_canvas::text::planner::Planner>::shape+0x1dd4>
  80fe78:	f3 0f 10 84 24 28 02 	movss  0x228(%rsp),%xmm0
  80fe7f:	00 00 
  80fe81:	f3 0f 11 44 24 5c    	movss  %xmm0,0x5c(%rsp)
  80fe87:	83 f9 06             	cmp    $0x6,%ecx
  80fe8a:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  80fe8f:	75 09                	jne    80fe9a <<gpui_canvas::text::planner::Planner>::shape+0x1dda>
  80fe91:	0f 57 c0             	xorps  %xmm0,%xmm0
  80fe94:	f3 0f 11 44 24 5c    	movss  %xmm0,0x5c(%rsp)
  80fe9a:	89 d6                	mov    %edx,%esi
  80fe9c:	48 39 f3             	cmp    %rsi,%rbx
  80fe9f:	0f 92 c1             	setb   %cl
  80fea2:	3b 94 24 10 01 00 00 	cmp    0x110(%rsp),%edx
  80fea9:	0f 82 09 01 00 00    	jb     80ffb8 <<gpui_canvas::text::planner::Planner>::shape+0x1ef8>
  80feaf:	48 8b bc 24 10 01 00 	mov    0x110(%rsp),%rdi
  80feb6:	00 
  80feb7:	89 fa                	mov    %edi,%edx
  80feb9:	84 c9                	test   %cl,%cl
  80febb:	0f 85 94 17 00 00    	jne    811655 <<gpui_canvas::text::planner::Planner>::shape+0x3595>
  80fec1:	3b 7c 24 30          	cmp    0x30(%rsp),%edi
  80fec5:	75 11                	jne    80fed8 <<gpui_canvas::text::planner::Planner>::shape+0x1e18>
  80fec7:	48 c7 84 24 28 01 00 	movq   $0x0,0x128(%rsp)
  80fece:	00 00 00 00 00 
  80fed3:	e9 b4 00 00 00       	jmp    80ff8c <<gpui_canvas::text::planner::Planner>::shape+0x1ecc>
  80fed8:	48 8d 0c d5 00 00 00 	lea    0x0(,%rdx,8),%rcx
  80fedf:	00 
  80fee0:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  80fee4:	48 8d 7e ff          	lea    -0x1(%rsi),%rdi
  80fee8:	48 39 d7             	cmp    %rdx,%rdi
  80feeb:	75 10                	jne    80fefd <<gpui_canvas::text::planner::Planner>::shape+0x1e3d>
  80feed:	31 d2                	xor    %edx,%edx
  80feef:	48 c7 84 24 28 01 00 	movq   $0x0,0x128(%rsp)
  80fef6:	00 00 00 00 00 
  80fefb:	eb 5e                	jmp    80ff5b <<gpui_canvas::text::planner::Planner>::shape+0x1e9b>
  80fefd:	48 29 d6             	sub    %rdx,%rsi
  80ff00:	48 89 f7             	mov    %rsi,%rdi
  80ff03:	48 83 e7 fe          	and    $0xfffffffffffffffe,%rdi
  80ff07:	48 8b 94 24 90 03 00 	mov    0x390(%rsp),%rdx
  80ff0e:	00 
  80ff0f:	4c 8d 04 0a          	lea    (%rdx,%rcx,1),%r8
  80ff13:	31 d2                	xor    %edx,%edx
  80ff15:	45 31 d2             	xor    %r10d,%r10d
  80ff18:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  80ff1e:	66 90                	xchg   %ax,%ax
  80ff20:	45 8b 48 de          	mov    -0x22(%r8),%r9d
  80ff24:	41 f6 40 e9 01       	testb  $0x1,-0x17(%r8)
  80ff29:	4d 0f 45 cb          	cmovne %r11,%r9
  80ff2d:	4d 01 d1             	add    %r10,%r9
  80ff30:	41 f6 40 01 01       	testb  $0x1,0x1(%r8)
  80ff35:	45 8b 50 f6          	mov    -0xa(%r8),%r10d
  80ff39:	4d 0f 45 d3          	cmovne %r11,%r10
  80ff3d:	4d 01 ca             	add    %r9,%r10
  80ff40:	48 83 c2 02          	add    $0x2,%rdx
  80ff44:	49 83 c0 30          	add    $0x30,%r8
  80ff48:	48 39 d7             	cmp    %rdx,%rdi
  80ff4b:	75 d3                	jne    80ff20 <<gpui_canvas::text::planner::Planner>::shape+0x1e60>
  80ff4d:	4c 89 94 24 28 01 00 	mov    %r10,0x128(%rsp)
  80ff54:	00 
  80ff55:	40 f6 c6 01          	test   $0x1,%sil
  80ff59:	74 31                	je     80ff8c <<gpui_canvas::text::planner::Planner>::shape+0x1ecc>
  80ff5b:	48 8b b4 24 28 01 00 	mov    0x128(%rsp),%rsi
  80ff62:	00 
  80ff63:	48 03 8c 24 f0 01 00 	add    0x1f0(%rsp),%rcx
  80ff6a:	00 
  80ff6b:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  80ff6f:	f6 44 d1 17 01       	testb  $0x1,0x17(%rcx,%rdx,8)
  80ff74:	8b 54 d1 0c          	mov    0xc(%rcx,%rdx,8),%edx
  80ff78:	b9 01 00 00 00       	mov    $0x1,%ecx
  80ff7d:	48 0f 45 d1          	cmovne %rcx,%rdx
  80ff81:	48 01 f2             	add    %rsi,%rdx
  80ff84:	48 89 94 24 28 01 00 	mov    %rdx,0x128(%rsp)
  80ff8b:	00 
  80ff8c:	0f 57 c0             	xorps  %xmm0,%xmm0
  80ff8f:	f3 0f 11 84 24 b0 01 	movss  %xmm0,0x1b0(%rsp)
  80ff96:	00 00 
  80ff98:	b9 00 00 00 00       	mov    $0x0,%ecx
  80ff9d:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
  80ffa4:	00 
  80ffa5:	ba 00 00 00 00       	mov    $0x0,%edx
  80ffaa:	49 39 c5             	cmp    %rax,%r13
  80ffad:	0f 84 4b fb ff ff    	je     80fafe <<gpui_canvas::text::planner::Planner>::shape+0x1a3e>
  80ffb3:	e9 ee f9 ff ff       	jmp    80f9a6 <<gpui_canvas::text::planner::Planner>::shape+0x18e6>
  80ffb8:	b1 01                	mov    $0x1,%cl
  80ffba:	48 8b bc 24 10 01 00 	mov    0x110(%rsp),%rdi
  80ffc1:	00 
  80ffc2:	89 fa                	mov    %edi,%edx
  80ffc4:	84 c9                	test   %cl,%cl
  80ffc6:	0f 84 f5 fe ff ff    	je     80fec1 <<gpui_canvas::text::planner::Planner>::shape+0x1e01>
  80ffcc:	e9 84 16 00 00       	jmp    811655 <<gpui_canvas::text::planner::Planner>::shape+0x3595>
  80ffd1:	0f 85 56 10 00 00    	jne    81102d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  80ffd7:	48 85 c9             	test   %rcx,%rcx
  80ffda:	41 0f 94 c4          	sete   %r12b
  80ffde:	74 1d                	je     80fffd <<gpui_canvas::text::planner::Planner>::shape+0x1f3d>
  80ffe0:	48 3b 4c 24 08       	cmp    0x8(%rsp),%rcx
  80ffe5:	73 10                	jae    80fff7 <<gpui_canvas::text::planner::Planner>::shape+0x1f37>
  80ffe7:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  80ffec:	80 3c 08 c0          	cmpb   $0xc0,(%rax,%rcx,1)
  80fff0:	7d 0b                	jge    80fffd <<gpui_canvas::text::planner::Planner>::shape+0x1f3d>
  80fff2:	e9 36 10 00 00       	jmp    81102d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  80fff7:	0f 85 30 10 00 00    	jne    81102d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  80fffd:	45 85 f6             	test   %r14d,%r14d
  810000:	0f 84 9c 00 00 00    	je     8100a2 <<gpui_canvas::text::planner::Planner>::shape+0x1fe2>
  810006:	f3 0f 10 44 24 78    	movss  0x78(%rsp),%xmm0
  81000c:	f3 0f 58 84 24 dc 00 	addss  0xdc(%rsp),%xmm0
  810013:	00 00 
  810015:	f3 0f 11 44 24 78    	movss  %xmm0,0x78(%rsp)
  81001b:	66 0f 7e c1          	movd   %xmm0,%ecx
  81001f:	0f 28 84 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm0
  810026:	00 
  810027:	0f 58 84 24 d0 03 00 	addps  0x3d0(%rsp),%xmm0
  81002e:	00 
  81002f:	0f c6 c0 55          	shufps $0x55,%xmm0,%xmm0
  810033:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  81003a:	00 
  81003b:	66 0f 7e c0          	movd   %xmm0,%eax
  81003f:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  810045:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  81004a:	3d 00 00 80 7f       	cmp    $0x7f800000,%eax
  81004f:	0f 9d c0             	setge  %al
  810052:	81 f9 ff ff 7f 7f    	cmp    $0x7f7fffff,%ecx
  810058:	0f 8f f0 0f 00 00    	jg     81104e <<gpui_canvas::text::planner::Planner>::shape+0x2f8e>
  81005e:	84 c0                	test   %al,%al
  810060:	0f 85 e8 0f 00 00    	jne    81104e <<gpui_canvas::text::planner::Planner>::shape+0x2f8e>
  810066:	41 81 fe ff ff 00 00 	cmp    $0xffff,%r14d
  81006d:	0f 87 ba 0f 00 00    	ja     81102d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  810073:	45 89 f4             	mov    %r14d,%r12d
  810076:	4d 89 ce             	mov    %r9,%r14
  810079:	48 8b 9c 24 f8 00 00 	mov    0xf8(%rsp),%rbx
  810080:	00 
  810081:	48 3b 9c 24 e8 00 00 	cmp    0xe8(%rsp),%rbx
  810088:	00 
  810089:	0f 85 2f f8 ff ff    	jne    80f8be <<gpui_canvas::text::planner::Planner>::shape+0x17fe>
  81008f:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  810096:	00 
  810097:	ff 15 23 bb 31 00    	call   *0x31bb23(%rip)        # b2bbc0 <_DYNAMIC+0xef0>
  81009d:	e9 1c f8 ff ff       	jmp    80f8be <<gpui_canvas::text::planner::Planner>::shape+0x17fe>
  8100a2:	4d 85 c9             	test   %r9,%r9
  8100a5:	0f 84 b8 00 00 00    	je     810163 <<gpui_canvas::text::planner::Planner>::shape+0x20a3>
  8100ab:	4c 3b 4c 24 08       	cmp    0x8(%rsp),%r9
  8100b0:	0f 83 a7 00 00 00    	jae    81015d <<gpui_canvas::text::planner::Planner>::shape+0x209d>
  8100b6:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  8100bb:	42 80 3c 08 bf       	cmpb   $0xbf,(%rax,%r9,1)
  8100c0:	0f 8f 9d 00 00 00    	jg     810163 <<gpui_canvas::text::planner::Planner>::shape+0x20a3>
  8100c6:	e9 bd 10 00 00       	jmp    811188 <<gpui_canvas::text::planner::Planner>::shape+0x30c8>
  8100cb:	48 8b 8c 24 10 01 00 	mov    0x110(%rsp),%rcx
  8100d2:	00 
  8100d3:	44 89 ee             	mov    %r13d,%esi
  8100d6:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  8100da:	48 8b 94 24 f0 01 00 	mov    0x1f0(%rsp),%rdx
  8100e1:	00 
  8100e2:	f3 0f 10 44 c2 10    	movss  0x10(%rdx,%rax,8),%xmm0
  8100e8:	0f 57 c9             	xorps  %xmm1,%xmm1
  8100eb:	0f 29 8c 24 c0 01 00 	movaps %xmm1,0x1c0(%rsp)
  8100f2:	00 
  8100f3:	41 bd 04 00 00 00    	mov    $0x4,%r13d
  8100f9:	b8 04 00 00 00       	mov    $0x4,%eax
  8100fe:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  810105:	00 
  810106:	48 89 8c 24 10 01 00 	mov    %rcx,0x110(%rsp)
  81010d:	00 
  81010e:	f3 0f 11 84 24 a8 01 	movss  %xmm0,0x1a8(%rsp)
  810115:	00 00 
  810117:	f3 0f 11 84 24 00 01 	movss  %xmm0,0x100(%rsp)
  81011e:	00 00 
  810120:	89 b4 24 ac 01 00 00 	mov    %esi,0x1ac(%rsp)
  810127:	41 89 f6             	mov    %esi,%r14d
  81012a:	0f 57 c0             	xorps  %xmm0,%xmm0
  81012d:	0f 29 84 24 30 02 00 	movaps %xmm0,0x230(%rsp)
  810134:	00 
  810135:	83 bc 24 e0 00 00 00 	cmpl   $0x0,0xe0(%rsp)
  81013c:	00 
  81013d:	0f 85 26 f8 ff ff    	jne    80f969 <<gpui_canvas::text::planner::Planner>::shape+0x18a9>
  810143:	e9 95 f8 ff ff       	jmp    80f9dd <<gpui_canvas::text::planner::Planner>::shape+0x191d>
  810148:	48 8b 94 24 80 00 00 	mov    0x80(%rsp),%rdx
  81014f:	00 
  810150:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  810157:	00 
  810158:	e9 49 f8 ff ff       	jmp    80f9a6 <<gpui_canvas::text::planner::Planner>::shape+0x18e6>
  81015d:	0f 85 25 10 00 00    	jne    811188 <<gpui_canvas::text::planner::Planner>::shape+0x30c8>
  810163:	48 85 c9             	test   %rcx,%rcx
  810166:	48 89 8c 24 48 02 00 	mov    %rcx,0x248(%rsp)
  81016d:	00 
  81016e:	74 1d                	je     81018d <<gpui_canvas::text::planner::Planner>::shape+0x20cd>
  810170:	48 3b 4c 24 08       	cmp    0x8(%rsp),%rcx
  810175:	73 10                	jae    810187 <<gpui_canvas::text::planner::Planner>::shape+0x20c7>
  810177:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  81017c:	80 3c 08 c0          	cmpb   $0xc0,(%rax,%rcx,1)
  810180:	7d 0b                	jge    81018d <<gpui_canvas::text::planner::Planner>::shape+0x20cd>
  810182:	e9 11 10 00 00       	jmp    811198 <<gpui_canvas::text::planner::Planner>::shape+0x30d8>
  810187:	0f 85 0b 10 00 00    	jne    811198 <<gpui_canvas::text::planner::Planner>::shape+0x30d8>
  81018d:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  810192:	4d 89 ce             	mov    %r9,%r14
  810195:	4a 8d 1c 08          	lea    (%rax,%r9,1),%rbx
  810199:	48 01 c8             	add    %rcx,%rax
  81019c:	48 89 84 24 c0 01 00 	mov    %rax,0x1c0(%rsp)
  8101a3:	00 
  8101a4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8101ab:	00 00 00 00 00 
  8101b0:	48 3b 9c 24 c0 01 00 	cmp    0x1c0(%rsp),%rbx
  8101b7:	00 
  8101b8:	0f 84 8c 00 00 00    	je     81024a <<gpui_canvas::text::planner::Planner>::shape+0x218a>
  8101be:	0f b6 33             	movzbl (%rbx),%esi
  8101c1:	40 84 f6             	test   %sil,%sil
  8101c4:	78 0a                	js     8101d0 <<gpui_canvas::text::planner::Planner>::shape+0x2110>
  8101c6:	48 ff c3             	inc    %rbx
  8101c9:	eb 65                	jmp    810230 <<gpui_canvas::text::planner::Planner>::shape+0x2170>
  8101cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8101d0:	89 f0                	mov    %esi,%eax
  8101d2:	83 e0 1f             	and    $0x1f,%eax
  8101d5:	0f b6 53 01          	movzbl 0x1(%rbx),%edx
  8101d9:	83 e2 3f             	and    $0x3f,%edx
  8101dc:	40 80 fe df          	cmp    $0xdf,%sil
  8101e0:	76 2c                	jbe    81020e <<gpui_canvas::text::planner::Planner>::shape+0x214e>
  8101e2:	0f b6 4b 02          	movzbl 0x2(%rbx),%ecx
  8101e6:	c1 e2 06             	shl    $0x6,%edx
  8101e9:	83 e1 3f             	and    $0x3f,%ecx
  8101ec:	09 d1                	or     %edx,%ecx
  8101ee:	40 80 fe f0          	cmp    $0xf0,%sil
  8101f2:	72 27                	jb     81021b <<gpui_canvas::text::planner::Planner>::shape+0x215b>
  8101f4:	0f b6 73 03          	movzbl 0x3(%rbx),%esi
  8101f8:	48 83 c3 04          	add    $0x4,%rbx
  8101fc:	83 e0 07             	and    $0x7,%eax
  8101ff:	c1 e0 12             	shl    $0x12,%eax
  810202:	c1 e1 06             	shl    $0x6,%ecx
  810205:	83 e6 3f             	and    $0x3f,%esi
  810208:	09 ce                	or     %ecx,%esi
  81020a:	09 c6                	or     %eax,%esi
  81020c:	eb 22                	jmp    810230 <<gpui_canvas::text::planner::Planner>::shape+0x2170>
  81020e:	48 83 c3 02          	add    $0x2,%rbx
  810212:	c1 e0 06             	shl    $0x6,%eax
  810215:	09 d0                	or     %edx,%eax
  810217:	89 c6                	mov    %eax,%esi
  810219:	eb 15                	jmp    810230 <<gpui_canvas::text::planner::Planner>::shape+0x2170>
  81021b:	48 83 c3 03          	add    $0x3,%rbx
  81021f:	c1 e0 0c             	shl    $0xc,%eax
  810222:	09 c1                	or     %eax,%ecx
  810224:	89 ce                	mov    %ecx,%esi
  810226:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  81022d:	00 00 00 
  810230:	48 8d 3d 49 60 2f 00 	lea    0x2f6049(%rip),%rdi        # b06280 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x468>
  810237:	ff 15 03 bd 31 00    	call   *0x31bd03(%rip)        # b2bf40 <_DYNAMIC+0x1270>
  81023d:	84 c0                	test   %al,%al
  81023f:	0f 85 6b ff ff ff    	jne    8101b0 <<gpui_canvas::text::planner::Planner>::shape+0x20f0>
  810245:	e9 54 0f 00 00       	jmp    81119e <<gpui_canvas::text::planner::Planner>::shape+0x30de>
  81024a:	31 c0                	xor    %eax,%eax
  81024c:	0f 57 c0             	xorps  %xmm0,%xmm0
  81024f:	f3 0f 10 8c 24 00 01 	movss  0x100(%rsp),%xmm1
  810256:	00 00 
  810258:	0f 2e c8             	ucomiss %xmm0,%xmm1
  81025b:	48 8b 9c 24 d8 01 00 	mov    0x1d8(%rsp),%rbx
  810262:	00 
  810263:	f3 0f 10 84 24 b4 01 	movss  0x1b4(%rsp),%xmm0
  81026a:	00 00 
  81026c:	0f 85 2c 0f 00 00    	jne    81119e <<gpui_canvas::text::planner::Planner>::shape+0x30de>
  810272:	0f 8b b3 f6 ff ff    	jnp    80f92b <<gpui_canvas::text::planner::Planner>::shape+0x186b>
  810278:	e9 21 0f 00 00       	jmp    81119e <<gpui_canvas::text::planner::Planner>::shape+0x30de>
  81027d:	48 8b 94 24 80 00 00 	mov    0x80(%rsp),%rdx
  810284:	00 
  810285:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  81028c:	00 
  81028d:	48 89 8c 24 10 01 00 	mov    %rcx,0x110(%rsp)
  810294:	00 
  810295:	e9 0c f7 ff ff       	jmp    80f9a6 <<gpui_canvas::text::planner::Planner>::shape+0x18e6>
  81029a:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  8102a1:	00 
  8102a2:	48 8d b4 24 b0 04 00 	lea    0x4b0(%rsp),%rsi
  8102a9:	00 
  8102aa:	e8 f1 1e 00 00       	call   8121a0 <<core::iter::adapters::flatten::FlattenCompat<core::iter::adapters::map::Map<core::ops::range::Range<u32>, <parley::layout::run::Run<()>>::glyph_source_ranges::{closure#0}>, core::iter::sources::repeat_n::RepeatN<core::ops::range::Range<usize>>> as core::iter::traits::iterator::Iterator>::next>
  8102af:	48 83 bc 24 90 00 00 	cmpq   $0x0,0x90(%rsp)
  8102b6:	00 00 
  8102b8:	0f 85 6f 0d 00 00    	jne    81102d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  8102be:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  8102c5:	00 
  8102c6:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  8102ca:	0f 84 87 f1 ff ff    	je     80f457 <<gpui_canvas::text::planner::Planner>::shape+0x1397>
  8102d0:	48 8b 8c 24 90 01 00 	mov    0x190(%rsp),%rcx
  8102d7:	00 
  8102d8:	48 3b 4c 24 40       	cmp    0x40(%rsp),%rcx
  8102dd:	75 12                	jne    8102f1 <<gpui_canvas::text::planner::Planner>::shape+0x2231>
  8102df:	31 db                	xor    %ebx,%ebx
  8102e1:	45 31 f6             	xor    %r14d,%r14d
  8102e4:	48 8b 94 24 40 02 00 	mov    0x240(%rsp),%rdx
  8102eb:	00 
  8102ec:	e9 81 00 00 00       	jmp    810372 <<gpui_canvas::text::planner::Planner>::shape+0x22b2>
  8102f1:	48 8b 8c 24 80 03 00 	mov    0x380(%rsp),%rcx
  8102f8:	00 
  8102f9:	48 85 c9             	test   %rcx,%rcx
  8102fc:	48 8b 94 24 40 02 00 	mov    0x240(%rsp),%rdx
  810303:	00 
  810304:	48 0f 44 ca          	cmove  %rdx,%rcx
  810308:	48 8b 19             	mov    (%rcx),%rbx
  81030b:	4c 8b 71 08          	mov    0x8(%rcx),%r14
  81030f:	4c 39 f3             	cmp    %r14,%rbx
  810312:	0f 87 15 0d 00 00    	ja     81102d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  810318:	48 85 db             	test   %rbx,%rbx
  81031b:	74 1a                	je     810337 <<gpui_canvas::text::planner::Planner>::shape+0x2277>
  81031d:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  810322:	48 39 cb             	cmp    %rcx,%rbx
  810325:	73 14                	jae    81033b <<gpui_canvas::text::planner::Planner>::shape+0x227b>
  810327:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  81032c:	80 3c 19 bf          	cmpb   $0xbf,(%rcx,%rbx,1)
  810330:	7f 12                	jg     810344 <<gpui_canvas::text::planner::Planner>::shape+0x2284>
  810332:	e9 f6 0c 00 00       	jmp    81102d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  810337:	31 db                	xor    %ebx,%ebx
  810339:	eb 09                	jmp    810344 <<gpui_canvas::text::planner::Planner>::shape+0x2284>
  81033b:	48 89 cb             	mov    %rcx,%rbx
  81033e:	0f 85 e9 0c 00 00    	jne    81102d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  810344:	4d 85 f6             	test   %r14,%r14
  810347:	74 1b                	je     810364 <<gpui_canvas::text::planner::Planner>::shape+0x22a4>
  810349:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  81034e:	49 39 ce             	cmp    %rcx,%r14
  810351:	73 16                	jae    810369 <<gpui_canvas::text::planner::Planner>::shape+0x22a9>
  810353:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  810358:	42 80 3c 31 c0       	cmpb   $0xc0,(%rcx,%r14,1)
  81035d:	7d 13                	jge    810372 <<gpui_canvas::text::planner::Planner>::shape+0x22b2>
  81035f:	e9 c9 0c 00 00       	jmp    81102d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  810364:	45 31 f6             	xor    %r14d,%r14d
  810367:	eb 09                	jmp    810372 <<gpui_canvas::text::planner::Planner>::shape+0x22b2>
  810369:	49 89 ce             	mov    %rcx,%r14
  81036c:	0f 85 bb 0c 00 00    	jne    81102d <<gpui_canvas::text::planner::Planner>::shape+0x2f6d>
  810372:	8b 8c 24 f8 00 00 00 	mov    0xf8(%rsp),%ecx
  810379:	89 4c 24 30          	mov    %ecx,0x30(%rsp)
  81037d:	44 0f b6 aa 8c 00 00 	movzbl 0x8c(%rdx),%r13d
  810384:	00 
  810385:	4c 8b a4 24 50 01 00 	mov    0x150(%rsp),%r12
  81038c:	00 
  81038d:	49 39 c4             	cmp    %rax,%r12
  810390:	75 0e                	jne    8103a0 <<gpui_canvas::text::planner::Planner>::shape+0x22e0>
  810392:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  810399:	00 
  81039a:	ff 15 30 b8 31 00    	call   *0x31b830(%rip)        # b2bbd0 <_DYNAMIC+0xf00>
  8103a0:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  8103a5:	01 c3                	add    %eax,%ebx
  8103a7:	41 01 c6             	add    %eax,%r14d
  8103aa:	41 80 e5 01          	and    $0x1,%r13b
  8103ae:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  8103b5:	00 
  8103b6:	4b 8d 0c 64          	lea    (%r12,%r12,2),%rcx
  8103ba:	89 1c c8             	mov    %ebx,(%rax,%rcx,8)
  8103bd:	44 89 74 c8 04       	mov    %r14d,0x4(%rax,%rcx,8)
  8103c2:	48 8b 94 24 88 03 00 	mov    0x388(%rsp),%rdx
  8103c9:	00 
  8103ca:	89 54 c8 08          	mov    %edx,0x8(%rax,%rcx,8)
  8103ce:	8b 54 24 30          	mov    0x30(%rsp),%edx
  8103d2:	89 54 c8 0c          	mov    %edx,0xc(%rax,%rcx,8)
  8103d6:	48 8b 94 24 58 02 00 	mov    0x258(%rsp),%rdx
  8103dd:	00 
  8103de:	89 54 c8 10          	mov    %edx,0x10(%rax,%rcx,8)
  8103e2:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
  8103e9:	00 
  8103ea:	88 54 c8 14          	mov    %dl,0x14(%rax,%rcx,8)
  8103ee:	44 88 6c c8 15       	mov    %r13b,0x15(%rax,%rcx,8)
  8103f3:	49 ff c4             	inc    %r12
  8103f6:	4c 89 a4 24 50 01 00 	mov    %r12,0x150(%rsp)
  8103fd:	00 
  8103fe:	e9 54 f0 ff ff       	jmp    80f457 <<gpui_canvas::text::planner::Planner>::shape+0x1397>
  810403:	48 8b 84 24 98 03 00 	mov    0x398(%rsp),%rax
  81040a:	00 
  81040b:	48 39 84 24 d0 00 00 	cmp    %rax,0xd0(%rsp)
  810412:	00 
  810413:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  810418:	48 8b 9c 24 90 01 00 	mov    0x190(%rsp),%rbx
  81041f:	00 
  810420:	0f 85 c7 eb ff ff    	jne    80efed <<gpui_canvas::text::planner::Planner>::shape+0xf2d>
  810426:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  81042d:	00 ff 
  81042f:	0f 84 e0 06 00 00    	je     810b15 <<gpui_canvas::text::planner::Planner>::shape+0x2a55>
  810435:	48 83 bc 24 70 01 00 	cmpq   $0xffffffffffffffff,0x170(%rsp)
  81043c:	00 ff 
  81043e:	0f 84 d1 06 00 00    	je     810b15 <<gpui_canvas::text::planner::Planner>::shape+0x2a55>
  810444:	48 03 9c 24 38 01 00 	add    0x138(%rsp),%rbx
  81044b:	00 
  81044c:	48 c7 84 24 00 07 00 	movq   $0x0,0x700(%rsp)
  810453:	00 00 00 00 00 
  810458:	48 c7 84 24 08 07 00 	movq   $0x8,0x708(%rsp)
  81045f:	00 08 00 00 00 
  810464:	48 c7 84 24 10 07 00 	movq   $0x0,0x710(%rsp)
  81046b:	00 00 00 00 00 
  810470:	c7 84 24 20 07 00 00 	movl   $0xffffffff,0x720(%rsp)
  810477:	ff ff ff ff 
  81047b:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  810480:	48 89 84 24 28 07 00 	mov    %rax,0x728(%rsp)
  810487:	00 
  810488:	48 89 9c 24 30 07 00 	mov    %rbx,0x730(%rsp)
  81048f:	00 
  810490:	48 c7 84 24 38 07 00 	movq   $0x0,0x738(%rsp)
  810497:	00 00 00 00 00 
  81049c:	48 8d 05 4d 5f 2f 00 	lea    0x2f5f4d(%rip),%rax        # b063f0 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x5d8>
  8104a3:	48 89 84 24 40 07 00 	mov    %rax,0x740(%rsp)
  8104aa:	00 
  8104ab:	48 8d 05 ae d6 ff ff 	lea    -0x2952(%rip),%rax        # 80db60 <icu_segmenter::rule_segmenter_v1::empty_handle_complex::<icu_segmenter::scaffold::Utf8>>
  8104b2:	48 89 84 24 48 07 00 	mov    %rax,0x748(%rsp)
  8104b9:	00 
  8104ba:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8104bf:	48 89 84 24 50 07 00 	mov    %rax,0x750(%rsp)
  8104c6:	00 
  8104c7:	48 c7 84 24 58 07 00 	movq   $0x0,0x758(%rsp)
  8104ce:	00 00 00 00 00 
  8104d3:	48 c7 84 24 88 07 00 	movq   $0x0,0x788(%rsp)
  8104da:	00 00 00 00 00 
  8104df:	c6 84 24 90 07 00 00 	movb   $0x0,0x790(%rsp)
  8104e6:	00 
  8104e7:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  8104ee:	00 
  8104ef:	e8 0c 5f ff ff       	call   806400 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  8104f4:	48 83 f8 01          	cmp    $0x1,%rax
  8104f8:	0f 85 38 01 00 00    	jne    810636 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  8104fe:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  810505:	00 
  810506:	e8 f5 5e ff ff       	call   806400 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  81050b:	48 83 f8 01          	cmp    $0x1,%rax
  81050f:	0f 85 21 01 00 00    	jne    810636 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  810515:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  81051c:	00 
  81051d:	e8 de 5e ff ff       	call   806400 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  810522:	48 83 f8 01          	cmp    $0x1,%rax
  810526:	0f 85 0a 01 00 00    	jne    810636 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  81052c:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  810533:	00 
  810534:	e8 c7 5e ff ff       	call   806400 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  810539:	48 83 f8 01          	cmp    $0x1,%rax
  81053d:	0f 85 f3 00 00 00    	jne    810636 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  810543:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  81054a:	00 
  81054b:	e8 b0 5e ff ff       	call   806400 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  810550:	48 83 f8 01          	cmp    $0x1,%rax
  810554:	0f 85 dc 00 00 00    	jne    810636 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  81055a:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  810561:	00 
  810562:	e8 99 5e ff ff       	call   806400 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  810567:	48 83 f8 01          	cmp    $0x1,%rax
  81056b:	0f 85 c5 00 00 00    	jne    810636 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  810571:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  810578:	00 
  810579:	e8 82 5e ff ff       	call   806400 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  81057e:	48 83 f8 01          	cmp    $0x1,%rax
  810582:	0f 85 ae 00 00 00    	jne    810636 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  810588:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  81058f:	00 
  810590:	e8 6b 5e ff ff       	call   806400 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  810595:	a8 01                	test   $0x1,%al
  810597:	0f 84 99 00 00 00    	je     810636 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  81059d:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  8105a4:	00 
  8105a5:	e8 56 5e ff ff       	call   806400 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  8105aa:	48 83 f8 01          	cmp    $0x1,%rax
  8105ae:	0f 85 82 00 00 00    	jne    810636 <<gpui_canvas::text::planner::Planner>::shape+0x2576>
  8105b4:	48 8b b4 24 00 07 00 	mov    0x700(%rsp),%rsi
  8105bb:	00 
  8105bc:	48 85 f6             	test   %rsi,%rsi
  8105bf:	74 17                	je     8105d8 <<gpui_canvas::text::planner::Planner>::shape+0x2518>
  8105c1:	48 8b bc 24 08 07 00 	mov    0x708(%rsp),%rdi
  8105c8:	00 
  8105c9:	48 c1 e6 03          	shl    $0x3,%rsi
  8105cd:	ba 08 00 00 00       	mov    $0x8,%edx
  8105d2:	ff 15 40 a9 31 00    	call   *0x31a940(%rip)        # b2af18 <_DYNAMIC+0x248>
  8105d8:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  8105df:	00 
  8105e0:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  8105e5:	e8 f6 9d fd ff       	call   7ea3e0 <<parley::editing::geometry::CursorGeometry<()>>::new>
  8105ea:	4c 8b ac 24 00 07 00 	mov    0x700(%rsp),%r13
  8105f1:	00 
  8105f2:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  8105f6:	0f 84 a6 10 00 00    	je     8116a2 <<gpui_canvas::text::planner::Planner>::shape+0x35e2>
  8105fc:	48 8d 8c 24 20 07 00 	lea    0x720(%rsp),%rcx
  810603:	00 
  810604:	48 8b 41 10          	mov    0x10(%rcx),%rax
  810608:	49 89 47 20          	mov    %rax,0x20(%r15)
  81060c:	0f 10 41 f0          	movups -0x10(%rcx),%xmm0
  810610:	0f 10 09             	movups (%rcx),%xmm1
  810613:	41 0f 11 4f 10       	movups %xmm1,0x10(%r15)
  810618:	41 0f 11 07          	movups %xmm0,(%r15)
  81061c:	48 8b 84 24 08 07 00 	mov    0x708(%rsp),%rax
  810623:	00 
  810624:	4c 89 ac 24 a0 02 00 	mov    %r13,0x2a0(%rsp)
  81062b:	00 
  81062c:	48 89 84 24 a8 02 00 	mov    %rax,0x2a8(%rsp)
  810633:	00 
  810634:	eb 37                	jmp    81066d <<gpui_canvas::text::planner::Planner>::shape+0x25ad>
  810636:	48 8b b4 24 00 07 00 	mov    0x700(%rsp),%rsi
  81063d:	00 
  81063e:	48 85 f6             	test   %rsi,%rsi
  810641:	74 17                	je     81065a <<gpui_canvas::text::planner::Planner>::shape+0x259a>
  810643:	48 8b bc 24 08 07 00 	mov    0x708(%rsp),%rdi
  81064a:	00 
  81064b:	48 c1 e6 03          	shl    $0x3,%rsi
  81064f:	ba 08 00 00 00       	mov    $0x8,%edx
  810654:	ff 15 be a8 31 00    	call   *0x31a8be(%rip)        # b2af18 <_DYNAMIC+0x248>
  81065a:	48 c7 84 24 a0 02 00 	movq   $0xffffffffffffffff,0x2a0(%rsp)
  810661:	00 ff ff ff ff 
  810666:	49 c7 c5 ff ff ff ff 	mov    $0xffffffffffffffff,%r13
  81066d:	48 c7 84 24 00 07 00 	movq   $0x0,0x700(%rsp)
  810674:	00 00 00 00 00 
  810679:	48 c7 84 24 08 07 00 	movq   $0x8,0x708(%rsp)
  810680:	00 08 00 00 00 
  810685:	48 c7 84 24 10 07 00 	movq   $0x0,0x710(%rsp)
  81068c:	00 00 00 00 00 
  810691:	c7 84 24 20 07 00 00 	movl   $0xffffffff,0x720(%rsp)
  810698:	ff ff ff ff 
  81069c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  8106a1:	48 89 84 24 28 07 00 	mov    %rax,0x728(%rsp)
  8106a8:	00 
  8106a9:	48 89 9c 24 30 07 00 	mov    %rbx,0x730(%rsp)
  8106b0:	00 
  8106b1:	48 c7 84 24 38 07 00 	movq   $0x0,0x738(%rsp)
  8106b8:	00 00 00 00 00 
  8106bd:	48 8d 05 2c 5d 2f 00 	lea    0x2f5d2c(%rip),%rax        # b063f0 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x5d8>
  8106c4:	48 89 84 24 40 07 00 	mov    %rax,0x740(%rsp)
  8106cb:	00 
  8106cc:	48 8d 05 8d d4 ff ff 	lea    -0x2b73(%rip),%rax        # 80db60 <icu_segmenter::rule_segmenter_v1::empty_handle_complex::<icu_segmenter::scaffold::Utf8>>
  8106d3:	48 89 84 24 48 07 00 	mov    %rax,0x748(%rsp)
  8106da:	00 
  8106db:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8106e0:	48 89 84 24 50 07 00 	mov    %rax,0x750(%rsp)
  8106e7:	00 
  8106e8:	48 c7 84 24 58 07 00 	movq   $0x0,0x758(%rsp)
  8106ef:	00 00 00 00 00 
  8106f4:	48 c7 84 24 88 07 00 	movq   $0x0,0x788(%rsp)
  8106fb:	00 00 00 00 00 
  810700:	c6 84 24 90 07 00 00 	movb   $0x0,0x790(%rsp)
  810707:	00 
  810708:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  81070e:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  810712:	f2 0f 11 44 24 08    	movsd  %xmm0,0x8(%rsp)
  810718:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  81071f:	00 
  810720:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  810727:	00 
  810728:	e8 d3 5c ff ff       	call   806400 <<icu_segmenter::rule_segmenter_v1::RuleBreakIterator<icu_segmenter::scaffold::Utf8> as core::iter::traits::iterator::Iterator>::next>
  81072d:	48 83 f8 01          	cmp    $0x1,%rax
  810731:	0f 85 71 03 00 00    	jne    810aa8 <<gpui_canvas::text::planner::Planner>::shape+0x29e8>
  810737:	48 89 d3             	mov    %rdx,%rbx
  81073a:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  81073e:	74 44                	je     810784 <<gpui_canvas::text::planner::Planner>::shape+0x26c4>
  810740:	48 8d bc 24 b0 04 00 	lea    0x4b0(%rsp),%rdi
  810747:	00 
  810748:	48 8d b4 24 a0 02 00 	lea    0x2a0(%rsp),%rsi
  81074f:	00 
  810750:	48 89 da             	mov    %rbx,%rdx
  810753:	f3 0f 10 05 35 ee 8e 	movss  -0x7111cb(%rip),%xmm0        # ff590 <anon.54edef65de96b8e67cbd7be652d99b9c.303.llvm.8229078508888877484+0x1c>
  81075a:	ff 
  81075b:	e8 b0 95 fd ff       	call   7e9d10 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at>
  810760:	80 bc 24 b0 04 00 00 	cmpb   $0x0,0x4b0(%rsp)
  810767:	00 
  810768:	74 b6                	je     810720 <<gpui_canvas::text::planner::Planner>::shape+0x2660>
  81076a:	0f 10 45 00          	movups 0x0(%rbp),%xmm0
  81076e:	0f 10 4d 10          	movups 0x10(%rbp),%xmm1
  810772:	0f 29 8c 24 00 03 00 	movaps %xmm1,0x300(%rsp)
  810779:	00 
  81077a:	0f 29 84 24 f0 02 00 	movaps %xmm0,0x2f0(%rsp)
  810781:	00 
  810782:	eb 5b                	jmp    8107df <<gpui_canvas::text::planner::Planner>::shape+0x271f>
  810784:	48 c7 84 24 b0 04 00 	movq   $0x0,0x4b0(%rsp)
  81078b:	00 00 00 00 00 
  810790:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  810795:	48 89 de             	mov    %rbx,%rsi
  810798:	ba 01 00 00 00       	mov    $0x1,%edx
  81079d:	e8 8e 8b fd ff       	call   7e9330 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
  8107a2:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  8107a9:	00 
  8107aa:	80 e2 01             	and    $0x1,%dl
  8107ad:	88 94 24 98 00 00 00 	mov    %dl,0x98(%rsp)
  8107b4:	48 39 d8             	cmp    %rbx,%rax
  8107b7:	0f 85 bc 00 00 00    	jne    810879 <<gpui_canvas::text::planner::Planner>::shape+0x27b9>
  8107bd:	48 8d bc 24 f0 02 00 	lea    0x2f0(%rsp),%rdi
  8107c4:	00 
  8107c5:	48 8d b4 24 90 00 00 	lea    0x90(%rsp),%rsi
  8107cc:	00 
  8107cd:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8107d2:	f3 0f 10 05 b6 ed 8e 	movss  -0x71124a(%rip),%xmm0        # ff590 <anon.54edef65de96b8e67cbd7be652d99b9c.303.llvm.8229078508888877484+0x1c>
  8107d9:	ff 
  8107da:	e8 11 8c fd ff       	call   7e93f0 <<parley::editing::cursor::Cursor>::geometry::<()>>
  8107df:	f2 0f 10 84 24 f8 02 	movsd  0x2f8(%rsp),%xmm0
  8107e6:	00 00 
  8107e8:	f2 0f 58 44 24 08    	addsd  0x8(%rsp),%xmm0
  8107ee:	66 0f 28 8c 24 f0 02 	movapd 0x2f0(%rsp),%xmm1
  8107f5:	00 00 
  8107f7:	66 0f 28 94 24 00 03 	movapd 0x300(%rsp),%xmm2
  8107fe:	00 00 
  810800:	66 0f 5c d1          	subpd  %xmm1,%xmm2
  810804:	66 0f 14 c8          	unpcklpd %xmm0,%xmm1
  810808:	66 0f 5a d9          	cvtpd2ps %xmm1,%xmm3
  81080c:	66 0f 5a ca          	cvtpd2ps %xmm2,%xmm1
  810810:	66 0f 29 8c 24 90 01 	movapd %xmm1,0x190(%rsp)
  810817:	00 00 
  810819:	66 0f 14 d9          	unpcklpd %xmm1,%xmm3
  81081d:	66 0f 29 5c 24 30    	movapd %xmm3,0x30(%rsp)
  810823:	66 0f 28 cb          	movapd %xmm3,%xmm1
  810827:	66 0f 54 0d 41 fd 8e 	andpd  -0x7102bf(%rip),%xmm1        # 100570 <anon.54edef65de96b8e67cbd7be652d99b9c.388.llvm.8229078508888877484+0xb10>
  81082e:	ff 
  81082f:	66 0f 66 0d a9 f2 8e 	pcmpgtd -0x710d57(%rip),%xmm1        # ffae0 <anon.54edef65de96b8e67cbd7be652d99b9c.388.llvm.8229078508888877484+0x80>
  810836:	ff 
  810837:	0f 50 c1             	movmskps %xmm1,%eax
  81083a:	85 c0                	test   %eax,%eax
  81083c:	0f 85 b8 08 00 00    	jne    8110fa <<gpui_canvas::text::planner::Planner>::shape+0x303a>
  810842:	f2 0f 5a c0          	cvtsd2ss %xmm0,%xmm0
  810846:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
  81084c:	41 b6 01             	mov    $0x1,%r14b
  81084f:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  810853:	74 27                	je     81087c <<gpui_canvas::text::planner::Planner>::shape+0x27bc>
  810855:	48 8d 84 24 d8 04 00 	lea    0x4d8(%rsp),%rax
  81085c:	00 
  81085d:	0f 10 00             	movups (%rax),%xmm0
  810860:	0f 10 48 10          	movups 0x10(%rax),%xmm1
  810864:	0f 29 8c 24 00 03 00 	movaps %xmm1,0x300(%rsp)
  81086b:	00 
  81086c:	0f 29 84 24 f0 02 00 	movaps %xmm0,0x2f0(%rsp)
  810873:	00 
  810874:	41 b6 01             	mov    $0x1,%r14b
  810877:	eb 60                	jmp    8108d9 <<gpui_canvas::text::planner::Planner>::shape+0x2819>
  810879:	45 31 f6             	xor    %r14d,%r14d
  81087c:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  810881:	48 89 de             	mov    %rbx,%rsi
  810884:	31 d2                	xor    %edx,%edx
  810886:	e8 a5 8a fd ff       	call   7e9330 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
  81088b:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  810892:	00 
  810893:	80 e2 01             	and    $0x1,%dl
  810896:	88 94 24 98 00 00 00 	mov    %dl,0x98(%rsp)
  81089d:	48 39 d8             	cmp    %rbx,%rax
  8108a0:	74 15                	je     8108b7 <<gpui_canvas::text::planner::Planner>::shape+0x27f7>
  8108a2:	45 84 f6             	test   %r14b,%r14b
  8108a5:	0f 84 75 fe ff ff    	je     810720 <<gpui_canvas::text::planner::Planner>::shape+0x2660>
  8108ab:	03 5c 24 40          	add    0x40(%rsp),%ebx
  8108af:	45 31 f6             	xor    %r14d,%r14d
  8108b2:	e9 40 01 00 00       	jmp    8109f7 <<gpui_canvas::text::planner::Planner>::shape+0x2937>
  8108b7:	48 8d bc 24 f0 02 00 	lea    0x2f0(%rsp),%rdi
  8108be:	00 
  8108bf:	48 8d b4 24 90 00 00 	lea    0x90(%rsp),%rsi
  8108c6:	00 
  8108c7:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8108cc:	f3 0f 10 05 bc ec 8e 	movss  -0x711344(%rip),%xmm0        # ff590 <anon.54edef65de96b8e67cbd7be652d99b9c.303.llvm.8229078508888877484+0x1c>
  8108d3:	ff 
  8108d4:	e8 17 8b fd ff       	call   7e93f0 <<parley::editing::cursor::Cursor>::geometry::<()>>
  8108d9:	66 0f 28 5c 24 30    	movapd 0x30(%rsp),%xmm3
  8108df:	f2 0f 10 84 24 f8 02 	movsd  0x2f8(%rsp),%xmm0
  8108e6:	00 00 
  8108e8:	f2 0f 58 44 24 08    	addsd  0x8(%rsp),%xmm0
  8108ee:	66 0f 28 8c 24 f0 02 	movapd 0x2f0(%rsp),%xmm1
  8108f5:	00 00 
  8108f7:	66 0f 28 94 24 00 03 	movapd 0x300(%rsp),%xmm2
  8108fe:	00 00 
  810900:	66 0f 5c d1          	subpd  %xmm1,%xmm2
  810904:	66 0f 14 c8          	unpcklpd %xmm0,%xmm1
  810908:	66 0f 5a c9          	cvtpd2ps %xmm1,%xmm1
  81090c:	66 0f 5a c2          	cvtpd2ps %xmm2,%xmm0
  810910:	66 0f 14 c8          	unpcklpd %xmm0,%xmm1
  810914:	66 0f 29 8c 24 80 00 	movapd %xmm1,0x80(%rsp)
  81091b:	00 00 
  81091d:	66 0f 28 c1          	movapd %xmm1,%xmm0
  810921:	66 0f 54 05 47 fc 8e 	andpd  -0x7103b9(%rip),%xmm0        # 100570 <anon.54edef65de96b8e67cbd7be652d99b9c.388.llvm.8229078508888877484+0xb10>
  810928:	ff 
  810929:	66 0f 66 05 af f1 8e 	pcmpgtd -0x710e51(%rip),%xmm0        # ffae0 <anon.54edef65de96b8e67cbd7be652d99b9c.388.llvm.8229078508888877484+0x80>
  810930:	ff 
  810931:	0f 50 c0             	movmskps %xmm0,%eax
  810934:	85 c0                	test   %eax,%eax
  810936:	0f 85 be 07 00 00    	jne    8110fa <<gpui_canvas::text::planner::Planner>::shape+0x303a>
  81093c:	03 5c 24 40          	add    0x40(%rsp),%ebx
  810940:	45 84 f6             	test   %r14b,%r14b
  810943:	0f 84 99 00 00 00    	je     8109e2 <<gpui_canvas::text::planner::Planner>::shape+0x2922>
  810949:	0f 28 94 24 80 00 00 	movaps 0x80(%rsp),%xmm2
  810950:	00 
  810951:	0f 2e da             	ucomiss %xmm2,%xmm3
  810954:	41 b6 01             	mov    $0x1,%r14b
  810957:	0f 85 95 00 00 00    	jne    8109f2 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  81095d:	0f 8a 8f 00 00 00    	jp     8109f2 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  810963:	0f 28 c2             	movaps %xmm2,%xmm0
  810966:	0f c6 c2 55          	shufps $0x55,%xmm2,%xmm0
  81096a:	f3 0f 10 4c 24 10    	movss  0x10(%rsp),%xmm1
  810970:	0f 2e c8             	ucomiss %xmm0,%xmm1
  810973:	75 7d                	jne    8109f2 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  810975:	7a 7b                	jp     8109f2 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  810977:	0f 28 c2             	movaps %xmm2,%xmm0
  81097a:	66 0f 15 c2          	unpckhpd %xmm2,%xmm0
  81097e:	0f 28 8c 24 90 01 00 	movaps 0x190(%rsp),%xmm1
  810985:	00 
  810986:	0f 2e c8             	ucomiss %xmm0,%xmm1
  810989:	75 67                	jne    8109f2 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  81098b:	7a 65                	jp     8109f2 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  81098d:	0f 28 c2             	movaps %xmm2,%xmm0
  810990:	0f c6 c2 ff          	shufps $0xff,%xmm2,%xmm0
  810994:	0f c6 c9 55          	shufps $0x55,%xmm1,%xmm1
  810998:	0f 2e c8             	ucomiss %xmm0,%xmm1
  81099b:	75 55                	jne    8109f2 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  81099d:	7a 53                	jp     8109f2 <<gpui_canvas::text::planner::Planner>::shape+0x2932>
  81099f:	4c 8b a4 24 80 01 00 	mov    0x180(%rsp),%r12
  8109a6:	00 
  8109a7:	41 b6 03             	mov    $0x3,%r14b
  8109aa:	4c 3b a4 24 70 01 00 	cmp    0x170(%rsp),%r12
  8109b1:	00 
  8109b2:	0f 85 c1 00 00 00    	jne    810a79 <<gpui_canvas::text::planner::Planner>::shape+0x29b9>
  8109b8:	48 8d bc 24 70 01 00 	lea    0x170(%rsp),%rdi
  8109bf:	00 
  8109c0:	f3 0f 11 9c 24 00 01 	movss  %xmm3,0x100(%rsp)
  8109c7:	00 00 
  8109c9:	ff 15 09 b2 31 00    	call   *0x31b209(%rip)        # b2bbd8 <_DYNAMIC+0xf08>
  8109cf:	f3 0f 10 9c 24 00 01 	movss  0x100(%rsp),%xmm3
  8109d6:	00 00 
  8109d8:	0f 29 5c 24 30       	movaps %xmm3,0x30(%rsp)
  8109dd:	e9 9c 00 00 00       	jmp    810a7e <<gpui_canvas::text::planner::Planner>::shape+0x29be>
  8109e2:	4c 8b a4 24 80 01 00 	mov    0x180(%rsp),%r12
  8109e9:	00 
  8109ea:	66 0f 29 5c 24 30    	movapd %xmm3,0x30(%rsp)
  8109f0:	eb 58                	jmp    810a4a <<gpui_canvas::text::planner::Planner>::shape+0x298a>
  8109f2:	0f 29 5c 24 30       	movaps %xmm3,0x30(%rsp)
  8109f7:	4c 8b a4 24 80 01 00 	mov    0x180(%rsp),%r12
  8109fe:	00 
  8109ff:	4c 3b a4 24 70 01 00 	cmp    0x170(%rsp),%r12
  810a06:	00 
  810a07:	75 0e                	jne    810a17 <<gpui_canvas::text::planner::Planner>::shape+0x2957>
  810a09:	48 8d bc 24 70 01 00 	lea    0x170(%rsp),%rdi
  810a10:	00 
  810a11:	ff 15 c1 b1 31 00    	call   *0x31b1c1(%rip)        # b2bbd8 <_DYNAMIC+0xf08>
  810a17:	48 8b 84 24 78 01 00 	mov    0x178(%rsp),%rax
  810a1e:	00 
  810a1f:	4b 8d 0c 64          	lea    (%r12,%r12,2),%rcx
  810a23:	89 1c 88             	mov    %ebx,(%rax,%rcx,4)
  810a26:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  810a2b:	f3 0f 11 44 88 04    	movss  %xmm0,0x4(%rax,%rcx,4)
  810a31:	c6 44 88 08 01       	movb   $0x1,0x8(%rax,%rcx,4)
  810a36:	49 ff c4             	inc    %r12
  810a39:	4c 89 a4 24 80 01 00 	mov    %r12,0x180(%rsp)
  810a40:	00 
  810a41:	45 84 f6             	test   %r14b,%r14b
  810a44:	0f 84 d6 fc ff ff    	je     810720 <<gpui_canvas::text::planner::Planner>::shape+0x2660>
  810a4a:	41 b6 02             	mov    $0x2,%r14b
  810a4d:	4c 3b a4 24 70 01 00 	cmp    0x170(%rsp),%r12
  810a54:	00 
  810a55:	75 18                	jne    810a6f <<gpui_canvas::text::planner::Planner>::shape+0x29af>
  810a57:	48 8d bc 24 70 01 00 	lea    0x170(%rsp),%rdi
  810a5e:	00 
  810a5f:	ff 15 73 b1 31 00    	call   *0x31b173(%rip)        # b2bbd8 <_DYNAMIC+0xf08>
  810a65:	0f 28 9c 24 80 00 00 	movaps 0x80(%rsp),%xmm3
  810a6c:	00 
  810a6d:	eb 0f                	jmp    810a7e <<gpui_canvas::text::planner::Planner>::shape+0x29be>
  810a6f:	0f 28 9c 24 80 00 00 	movaps 0x80(%rsp),%xmm3
  810a76:	00 
  810a77:	eb 05                	jmp    810a7e <<gpui_canvas::text::planner::Planner>::shape+0x29be>
  810a79:	0f 29 5c 24 30       	movaps %xmm3,0x30(%rsp)
  810a7e:	48 8b 84 24 78 01 00 	mov    0x178(%rsp),%rax
  810a85:	00 
  810a86:	4b 8d 0c 64          	lea    (%r12,%r12,2),%rcx
  810a8a:	89 1c 88             	mov    %ebx,(%rax,%rcx,4)
  810a8d:	f3 0f 11 5c 88 04    	movss  %xmm3,0x4(%rax,%rcx,4)
  810a93:	44 88 74 88 08       	mov    %r14b,0x8(%rax,%rcx,4)
  810a98:	49 ff c4             	inc    %r12
  810a9b:	4c 89 a4 24 80 01 00 	mov    %r12,0x180(%rsp)
  810aa2:	00 
  810aa3:	e9 78 fc ff ff       	jmp    810720 <<gpui_canvas::text::planner::Planner>::shape+0x2660>
  810aa8:	48 8b b4 24 00 07 00 	mov    0x700(%rsp),%rsi
  810aaf:	00 
  810ab0:	48 85 f6             	test   %rsi,%rsi
  810ab3:	74 17                	je     810acc <<gpui_canvas::text::planner::Planner>::shape+0x2a0c>
  810ab5:	48 8b bc 24 08 07 00 	mov    0x708(%rsp),%rdi
  810abc:	00 
  810abd:	48 c1 e6 03          	shl    $0x3,%rsi
  810ac1:	ba 08 00 00 00       	mov    $0x8,%edx
  810ac6:	ff 15 4c a4 31 00    	call   *0x31a44c(%rip)        # b2af18 <_DYNAMIC+0x248>
  810acc:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  810ad0:	74 43                	je     810b15 <<gpui_canvas::text::planner::Planner>::shape+0x2a55>
  810ad2:	4d 85 ed             	test   %r13,%r13
  810ad5:	74 1a                	je     810af1 <<gpui_canvas::text::planner::Planner>::shape+0x2a31>
  810ad7:	48 8b bc 24 a8 02 00 	mov    0x2a8(%rsp),%rdi
  810ade:	00 
  810adf:	49 c1 e5 04          	shl    $0x4,%r13
  810ae3:	ba 04 00 00 00       	mov    $0x4,%edx
  810ae8:	4c 89 ee             	mov    %r13,%rsi
  810aeb:	ff 15 27 a4 31 00    	call   *0x31a427(%rip)        # b2af18 <_DYNAMIC+0x248>
  810af1:	48 8b b4 24 b8 02 00 	mov    0x2b8(%rsp),%rsi
  810af8:	00 
  810af9:	48 85 f6             	test   %rsi,%rsi
  810afc:	74 17                	je     810b15 <<gpui_canvas::text::planner::Planner>::shape+0x2a55>
  810afe:	48 8b bc 24 c0 02 00 	mov    0x2c0(%rsp),%rdi
  810b05:	00 
  810b06:	48 c1 e6 02          	shl    $0x2,%rsi
  810b0a:	ba 04 00 00 00       	mov    $0x4,%edx
  810b0f:	ff 15 03 a4 31 00    	call   *0x31a403(%rip)        # b2af18 <_DYNAMIC+0x248>
  810b15:	0f 28 9c 24 80 02 00 	movaps 0x280(%rsp),%xmm3
  810b1c:	00 
  810b1d:	0f 28 c3             	movaps %xmm3,%xmm0
  810b20:	f3 0f 5f 84 24 d8 00 	maxss  0xd8(%rsp),%xmm0
  810b27:	00 00 
  810b29:	0f 28 c8             	movaps %xmm0,%xmm1
  810b2c:	f3 0f c2 c8 03       	cmpunordss %xmm0,%xmm1
  810b31:	0f 28 d1             	movaps %xmm1,%xmm2
  810b34:	0f 55 d0             	andnps %xmm0,%xmm2
  810b37:	0f 54 cb             	andps  %xmm3,%xmm1
  810b3a:	0f 56 ca             	orps   %xmm2,%xmm1
  810b3d:	0f 29 8c 24 80 02 00 	movaps %xmm1,0x280(%rsp)
  810b44:	00 
  810b45:	48 8b 04 24          	mov    (%rsp),%rax
  810b49:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  810b4f:	f3 0f 58 80 30 0a 00 	addss  0xa30(%rax),%xmm0
  810b56:	00 
  810b57:	f3 0f 11 44 24 24    	movss  %xmm0,0x24(%rsp)
  810b5d:	80 7c 24 4c 00       	cmpb   $0x0,0x4c(%rsp)
  810b62:	48 8b 84 24 b0 03 00 	mov    0x3b0(%rsp),%rax
  810b69:	00 
  810b6a:	8b 74 24 74          	mov    0x74(%rsp),%esi
  810b6e:	48 8b 94 24 a8 03 00 	mov    0x3a8(%rsp),%rdx
  810b75:	00 
  810b76:	0f 84 8c db ff ff    	je     80e708 <<gpui_canvas::text::planner::Planner>::shape+0x648>
  810b7c:	e9 fb 04 00 00       	jmp    81107c <<gpui_canvas::text::planner::Planner>::shape+0x2fbc>
  810b81:	48 8b 0c 24          	mov    (%rsp),%rcx
  810b85:	48 8b 81 d8 09 00 00 	mov    0x9d8(%rcx),%rax
  810b8c:	48 6b 89 e0 09 00 00 	imul   $0x70,0x9e0(%rcx),%rcx
  810b93:	70 
  810b94:	48 01 c1             	add    %rax,%rcx
  810b97:	48 89 84 24 00 07 00 	mov    %rax,0x700(%rsp)
  810b9e:	00 
  810b9f:	48 89 8c 24 08 07 00 	mov    %rcx,0x708(%rsp)
  810ba6:	00 
  810ba7:	48 c7 84 24 10 07 00 	movq   $0x0,0x710(%rsp)
  810bae:	00 00 00 00 00 
  810bb3:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  810bb8:	48 89 84 24 18 07 00 	mov    %rax,0x718(%rsp)
  810bbf:	00 
  810bc0:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  810bc7:	00 
  810bc8:	31 f6                	xor    %esi,%esi
  810bca:	48 8d 94 24 e7 00 00 	lea    0xe7(%rsp),%rdx
  810bd1:	00 
  810bd2:	e8 d9 e3 fd ff       	call   7eefb0 <<core::iter::adapters::map::Map<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineData>>, <parley::layout::layout::Layout<()>>::lines::{closure#0}>, <gpui_canvas::text::planner::Planner>::shape_inner::{closure#3}> as core::iter::traits::iterator::Iterator>::fold::<usize, <core::iter::adapters::flatten::FlattenCompat<_, _>>::iter_fold::flatten<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>, usize, <core::iter::adapters::flatten::FlattenCompat<_, _> as core::iter::traits::iterator::Iterator>::count::count<core::iter::adapters::filter_map::FilterMap<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<parley::layout::data::LineItemData>>, <parley::layout::line::Line<()>>::items_nonpositioned::{closure#0}>, <parley::layout::line::Line<()>>::runs::{closure#0}>>>::{closure#0}>>
  810bd7:	48 83 f8 02          	cmp    $0x2,%rax
  810bdb:	0f 82 cf e1 ff ff    	jb     80edb0 <<gpui_canvas::text::planner::Planner>::shape+0xcf0>
  810be1:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  810be8:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  810bef:	00 ff 
  810bf1:	0f 84 3f e1 ff ff    	je     80ed36 <<gpui_canvas::text::planner::Planner>::shape+0xc76>
  810bf7:	e9 b4 e1 ff ff       	jmp    80edb0 <<gpui_canvas::text::planner::Planner>::shape+0xcf0>
  810bfc:	c7 44 24 74 ff ff ff 	movl   $0xffffffff,0x74(%rsp)
  810c03:	ff 
  810c04:	e9 65 dd ff ff       	jmp    80e96e <<gpui_canvas::text::planner::Planner>::shape+0x8ae>
  810c09:	45 89 d9             	mov    %r11d,%r9d
  810c0c:	41 83 e1 1f          	and    $0x1f,%r9d
  810c10:	41 0f b6 7a 01       	movzbl 0x1(%r10),%edi
  810c15:	83 e7 3f             	and    $0x3f,%edi
  810c18:	41 80 fb df          	cmp    $0xdf,%r11b
  810c1c:	76 33                	jbe    810c51 <<gpui_canvas::text::planner::Planner>::shape+0x2b91>
  810c1e:	41 0f b6 72 02       	movzbl 0x2(%r10),%esi
  810c23:	c1 e7 06             	shl    $0x6,%edi
  810c26:	83 e6 3f             	and    $0x3f,%esi
  810c29:	09 fe                	or     %edi,%esi
  810c2b:	41 80 fb f0          	cmp    $0xf0,%r11b
  810c2f:	72 30                	jb     810c61 <<gpui_canvas::text::planner::Planner>::shape+0x2ba1>
  810c31:	4d 8d 72 04          	lea    0x4(%r10),%r14
  810c35:	45 0f b6 5a 03       	movzbl 0x3(%r10),%r11d
  810c3a:	41 83 e1 07          	and    $0x7,%r9d
  810c3e:	41 c1 e1 12          	shl    $0x12,%r9d
  810c42:	c1 e6 06             	shl    $0x6,%esi
  810c45:	41 83 e3 3f          	and    $0x3f,%r11d
  810c49:	41 09 f3             	or     %esi,%r11d
  810c4c:	45 09 cb             	or     %r9d,%r11d
  810c4f:	eb 1e                	jmp    810c6f <<gpui_canvas::text::planner::Planner>::shape+0x2baf>
  810c51:	4d 8d 72 02          	lea    0x2(%r10),%r14
  810c55:	41 c1 e1 06          	shl    $0x6,%r9d
  810c59:	41 09 f9             	or     %edi,%r9d
  810c5c:	45 89 cb             	mov    %r9d,%r11d
  810c5f:	eb 0e                	jmp    810c6f <<gpui_canvas::text::planner::Planner>::shape+0x2baf>
  810c61:	4d 8d 72 03          	lea    0x3(%r10),%r14
  810c65:	41 c1 e1 0c          	shl    $0xc,%r9d
  810c69:	44 09 ce             	or     %r9d,%esi
  810c6c:	41 89 f3             	mov    %esi,%r11d
  810c6f:	4d 8d 48 02          	lea    0x2(%r8),%r9
  810c73:	4c 89 c1             	mov    %r8,%rcx
  810c76:	48 89 c6             	mov    %rax,%rsi
  810c79:	4c 29 d6             	sub    %r10,%rsi
  810c7c:	4c 01 f6             	add    %r14,%rsi
  810c7f:	41 83 fb 0a          	cmp    $0xa,%r11d
  810c83:	bf fe ff ff ff       	mov    $0xfffffffe,%edi
  810c88:	44 0f 44 df          	cmove  %edi,%r11d
  810c8c:	44 89 5c 24 74       	mov    %r11d,0x74(%rsp)
  810c91:	49 0f 44 d9          	cmove  %r9,%rbx
  810c95:	c7 44 24 4c 00 00 00 	movl   $0x0,0x4c(%rsp)
  810c9c:	00 
  810c9d:	48 89 84 24 a0 03 00 	mov    %rax,0x3a0(%rsp)
  810ca4:	00 
  810ca5:	48 89 f0             	mov    %rsi,%rax
  810ca8:	4c 89 74 24 18       	mov    %r14,0x18(%rsp)
  810cad:	48 89 ce             	mov    %rcx,%rsi
  810cb0:	48 29 d6             	sub    %rdx,%rsi
  810cb3:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  810cb8:	0f 83 cc dc ff ff    	jae    80e98a <<gpui_canvas::text::planner::Planner>::shape+0x8ca>
  810cbe:	e9 ed 09 00 00       	jmp    8116b0 <<gpui_canvas::text::planner::Planner>::shape+0x35f0>
  810cc3:	b9 04 00 00 00       	mov    $0x4,%ecx
  810cc8:	41 b8 10 00 00 00    	mov    $0x10,%r8d
  810cce:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  810cd5:	00 
  810cd6:	4c 89 ea             	mov    %r13,%rdx
  810cd9:	e8 f2 11 fe ff       	call   7f1ed0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  810cde:	e9 35 e2 ff ff       	jmp    80ef18 <<gpui_canvas::text::planner::Planner>::shape+0xe58>
  810ce3:	c7 84 24 98 00 00 00 	movl   $0x7,0x98(%rsp)
  810cea:	07 00 00 00 
  810cee:	eb 0b                	jmp    810cfb <<gpui_canvas::text::planner::Planner>::shape+0x2c3b>
  810cf0:	c7 84 24 98 00 00 00 	movl   $0x4,0x98(%rsp)
  810cf7:	04 00 00 00 
  810cfb:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  810d02:	00 ff ff ff ff 
  810d07:	48 8b 2c 24          	mov    (%rsp),%rbp
  810d0b:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  810d12:	00 
  810d13:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  810d17:	74 76                	je     810d8f <<gpui_canvas::text::planner::Planner>::shape+0x2ccf>
  810d19:	48 85 c0             	test   %rax,%rax
  810d1c:	74 1b                	je     810d39 <<gpui_canvas::text::planner::Planner>::shape+0x2c79>
  810d1e:	48 8b bc 24 48 01 00 	mov    0x148(%rsp),%rdi
  810d25:	00 
  810d26:	48 c1 e0 03          	shl    $0x3,%rax
  810d2a:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  810d2e:	ba 04 00 00 00       	mov    $0x4,%edx
  810d33:	ff 15 df a1 31 00    	call   *0x31a1df(%rip)        # b2af18 <_DYNAMIC+0x248>
  810d39:	48 8b 84 24 58 01 00 	mov    0x158(%rsp),%rax
  810d40:	00 
  810d41:	48 85 c0             	test   %rax,%rax
  810d44:	74 1b                	je     810d61 <<gpui_canvas::text::planner::Planner>::shape+0x2ca1>
  810d46:	48 8b bc 24 60 01 00 	mov    0x160(%rsp),%rdi
  810d4d:	00 
  810d4e:	48 c1 e0 03          	shl    $0x3,%rax
  810d52:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  810d56:	ba 04 00 00 00       	mov    $0x4,%edx
  810d5b:	ff 15 b7 a1 31 00    	call   *0x31a1b7(%rip)        # b2af18 <_DYNAMIC+0x248>
  810d61:	48 8b 84 24 70 01 00 	mov    0x170(%rsp),%rax
  810d68:	00 
  810d69:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  810d6d:	74 20                	je     810d8f <<gpui_canvas::text::planner::Planner>::shape+0x2ccf>
  810d6f:	48 85 c0             	test   %rax,%rax
  810d72:	74 1b                	je     810d8f <<gpui_canvas::text::planner::Planner>::shape+0x2ccf>
  810d74:	48 8b bc 24 78 01 00 	mov    0x178(%rsp),%rdi
  810d7b:	00 
  810d7c:	48 c1 e0 02          	shl    $0x2,%rax
  810d80:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  810d84:	ba 04 00 00 00       	mov    $0x4,%edx
  810d89:	ff 15 89 a1 31 00    	call   *0x31a189(%rip)        # b2af18 <_DYNAMIC+0x248>
  810d8f:	48 8b b4 24 e8 00 00 	mov    0xe8(%rsp),%rsi
  810d96:	00 
  810d97:	48 85 f6             	test   %rsi,%rsi
  810d9a:	74 17                	je     810db3 <<gpui_canvas::text::planner::Planner>::shape+0x2cf3>
  810d9c:	48 8b bc 24 f0 00 00 	mov    0xf0(%rsp),%rdi
  810da3:	00 
  810da4:	48 c1 e6 04          	shl    $0x4,%rsi
  810da8:	ba 04 00 00 00       	mov    $0x4,%edx
  810dad:	ff 15 65 a1 31 00    	call   *0x31a165(%rip)        # b2af18 <_DYNAMIC+0x248>
  810db3:	48 8b b4 24 38 03 00 	mov    0x338(%rsp),%rsi
  810dba:	00 
  810dbb:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  810dbf:	77 18                	ja     810dd9 <<gpui_canvas::text::planner::Planner>::shape+0x2d19>
  810dc1:	48 85 f6             	test   %rsi,%rsi
  810dc4:	74 13                	je     810dd9 <<gpui_canvas::text::planner::Planner>::shape+0x2d19>
  810dc6:	48 8b bc 24 40 03 00 	mov    0x340(%rsp),%rdi
  810dcd:	00 
  810dce:	ba 01 00 00 00       	mov    $0x1,%edx
  810dd3:	ff 15 3f a1 31 00    	call   *0x31a13f(%rip)        # b2af18 <_DYNAMIC+0x248>
  810dd9:	48 8b b4 24 50 03 00 	mov    0x350(%rsp),%rsi
  810de0:	00 
  810de1:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  810de5:	77 18                	ja     810dff <<gpui_canvas::text::planner::Planner>::shape+0x2d3f>
  810de7:	48 85 f6             	test   %rsi,%rsi
  810dea:	74 13                	je     810dff <<gpui_canvas::text::planner::Planner>::shape+0x2d3f>
  810dec:	48 8b bc 24 58 03 00 	mov    0x358(%rsp),%rdi
  810df3:	00 
  810df4:	ba 01 00 00 00       	mov    $0x1,%edx
  810df9:	ff 15 19 a1 31 00    	call   *0x31a119(%rip)        # b2af18 <_DYNAMIC+0x248>
  810dff:	48 8b b4 24 68 03 00 	mov    0x368(%rsp),%rsi
  810e06:	00 
  810e07:	48 83 fe fd          	cmp    $0xfffffffffffffffd,%rsi
  810e0b:	77 18                	ja     810e25 <<gpui_canvas::text::planner::Planner>::shape+0x2d65>
  810e0d:	48 85 f6             	test   %rsi,%rsi
  810e10:	74 13                	je     810e25 <<gpui_canvas::text::planner::Planner>::shape+0x2d65>
  810e12:	48 8b bc 24 70 03 00 	mov    0x370(%rsp),%rdi
  810e19:	00 
  810e1a:	ba 01 00 00 00       	mov    $0x1,%edx
  810e1f:	ff 15 f3 a0 31 00    	call   *0x31a0f3(%rip)        # b2af18 <_DYNAMIC+0x248>
  810e25:	48 8d bd c8 08 00 00 	lea    0x8c8(%rbp),%rdi
  810e2c:	e8 8f b6 ff ff       	call   80c4c0 <core::ptr::drop_glue::<parley::layout::layout::Layout<()>>>
  810e31:	48 c7 85 c8 08 00 00 	movq   $0x0,0x8c8(%rbp)
  810e38:	00 00 00 00 
  810e3c:	48 c7 85 d0 08 00 00 	movq   $0x4,0x8d0(%rbp)
  810e43:	04 00 00 00 
  810e47:	0f 57 c0             	xorps  %xmm0,%xmm0
  810e4a:	0f 11 85 d8 08 00 00 	movups %xmm0,0x8d8(%rbp)
  810e51:	48 c7 85 e8 08 00 00 	movq   $0x4,0x8e8(%rbp)
  810e58:	04 00 00 00 
  810e5c:	0f 11 85 f0 08 00 00 	movups %xmm0,0x8f0(%rbp)
  810e63:	48 c7 85 00 09 00 00 	movq   $0x8,0x900(%rbp)
  810e6a:	08 00 00 00 
  810e6e:	0f 11 85 08 09 00 00 	movups %xmm0,0x908(%rbp)
  810e75:	48 c7 85 18 09 00 00 	movq   $0x8,0x918(%rbp)
  810e7c:	08 00 00 00 
  810e80:	0f 11 85 20 09 00 00 	movups %xmm0,0x920(%rbp)
  810e87:	48 c7 85 30 09 00 00 	movq   $0x4,0x930(%rbp)
  810e8e:	04 00 00 00 
  810e92:	0f 11 85 38 09 00 00 	movups %xmm0,0x938(%rbp)
  810e99:	48 c7 85 48 09 00 00 	movq   $0x4,0x948(%rbp)
  810ea0:	04 00 00 00 
  810ea4:	0f 11 85 50 09 00 00 	movups %xmm0,0x950(%rbp)
  810eab:	48 c7 85 60 09 00 00 	movq   $0x4,0x960(%rbp)
  810eb2:	04 00 00 00 
  810eb6:	0f 11 85 68 09 00 00 	movups %xmm0,0x968(%rbp)
  810ebd:	48 c7 85 78 09 00 00 	movq   $0x8,0x978(%rbp)
  810ec4:	08 00 00 00 
  810ec8:	0f 11 85 80 09 00 00 	movups %xmm0,0x980(%rbp)
  810ecf:	48 c7 85 90 09 00 00 	movq   $0x2,0x990(%rbp)
  810ed6:	02 00 00 00 
  810eda:	0f 11 85 98 09 00 00 	movups %xmm0,0x998(%rbp)
  810ee1:	48 c7 85 a8 09 00 00 	movq   $0x4,0x9a8(%rbp)
  810ee8:	04 00 00 00 
  810eec:	0f 11 85 b0 09 00 00 	movups %xmm0,0x9b0(%rbp)
  810ef3:	48 c7 85 c0 09 00 00 	movq   $0x8,0x9c0(%rbp)
  810efa:	08 00 00 00 
  810efe:	0f 11 85 c8 09 00 00 	movups %xmm0,0x9c8(%rbp)
  810f05:	48 c7 85 d8 09 00 00 	movq   $0x8,0x9d8(%rbp)
  810f0c:	08 00 00 00 
  810f10:	0f 11 85 e0 09 00 00 	movups %xmm0,0x9e0(%rbp)
  810f17:	48 c7 85 f0 09 00 00 	movq   $0x8,0x9f0(%rbp)
  810f1e:	08 00 00 00 
  810f22:	0f 11 85 f8 09 00 00 	movups %xmm0,0x9f8(%rbp)
  810f29:	48 c7 85 08 0a 00 00 	movq   $0x4,0xa08(%rbp)
  810f30:	04 00 00 00 
  810f34:	0f 11 85 10 0a 00 00 	movups %xmm0,0xa10(%rbp)
  810f3b:	c7 85 20 0a 00 00 00 	movl   $0x3f800000,0xa20(%rbp)
  810f42:	00 80 3f 
  810f45:	0f 11 85 24 0a 00 00 	movups %xmm0,0xa24(%rbp)
  810f4c:	48 c7 85 32 0a 00 00 	movq   $0x0,0xa32(%rbp)
  810f53:	00 00 00 00 
  810f57:	66 c7 85 3a 0a 00 00 	movw   $0xff01,0xa3a(%rbp)
  810f5e:	01 ff 
  810f60:	c6 85 3c 0a 00 00 00 	movb   $0x0,0xa3c(%rbp)
  810f67:	48 8b 8c 24 c0 00 00 	mov    0xc0(%rsp),%rcx
  810f6e:	00 
  810f6f:	48 8b 84 24 c8 03 00 	mov    0x3c8(%rsp),%rax
  810f76:	00 
  810f77:	48 89 48 30          	mov    %rcx,0x30(%rax)
  810f7b:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  810f82:	00 
  810f83:	0f 10 8c 24 a0 00 00 	movups 0xa0(%rsp),%xmm1
  810f8a:	00 
  810f8b:	0f 10 94 24 b0 00 00 	movups 0xb0(%rsp),%xmm2
  810f92:	00 
  810f93:	0f 11 50 20          	movups %xmm2,0x20(%rax)
  810f97:	0f 11 48 10          	movups %xmm1,0x10(%rax)
  810f9b:	0f 11 00             	movups %xmm0,(%rax)
  810f9e:	48 81 c4 d8 11 00 00 	add    $0x11d8,%rsp
  810fa5:	5b                   	pop    %rbx
  810fa6:	41 5c                	pop    %r12
  810fa8:	41 5d                	pop    %r13
  810faa:	41 5e                	pop    %r14
  810fac:	41 5f                	pop    %r15
  810fae:	5d                   	pop    %rbp
  810faf:	c3                   	ret
  810fb0:	48 8d 35 81 e8 31 00 	lea    0x31e881(%rip),%rsi        # b2f838 <gpui_canvas::text::HEBREW_FONT>
  810fb7:	48 8d 15 5f 08 93 ff 	lea    -0x6cf7a1(%rip),%rdx        # 14181d <gpui_canvas::text::HEBREW_BYTES>
  810fbe:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  810fc5:	00 
  810fc6:	b9 14 69 00 00       	mov    $0x6914,%ecx
  810fcb:	45 31 c0             	xor    %r8d,%r8d
  810fce:	e8 3d 87 ff ff       	call   809710 <<gpui_canvas::text::FontFace>::shared_static>
  810fd3:	80 bc 24 00 07 00 00 	cmpb   $0x0,0x700(%rsp)
  810fda:	00 
  810fdb:	0f 85 c7 d4 ff ff    	jne    80e4a8 <<gpui_canvas::text::planner::Planner>::shape+0x3e8>
  810fe1:	4d 8d bd 50 0a 00 00 	lea    0xa50(%r13),%r15
  810fe8:	4c 8b a4 24 08 07 00 	mov    0x708(%rsp),%r12
  810fef:	00 
  810ff0:	49 8b 07             	mov    (%r15),%rax
  810ff3:	48 85 c0             	test   %rax,%rax
  810ff6:	74 0f                	je     811007 <<gpui_canvas::text::planner::Planner>::shape+0x2f47>
  810ff8:	f0 48 ff 08          	lock decq (%rax)
  810ffc:	75 09                	jne    811007 <<gpui_canvas::text::planner::Planner>::shape+0x2f47>
  810ffe:	4c 89 ff             	mov    %r15,%rdi
  811001:	ff 15 c1 9f 31 00    	call   *0x319fc1(%rip)        # b2afc8 <_DYNAMIC+0x2f8>
  811007:	4d 89 a5 50 0a 00 00 	mov    %r12,0xa50(%r13)
  81100e:	be 02 00 00 00       	mov    $0x2,%esi
  811013:	4c 89 ef             	mov    %r13,%rdi
  811016:	e8 15 0c 00 00       	call   811c30 <<gpui_canvas::text::planner::Planner>::register>
  81101b:	83 f8 ff             	cmp    $0xffffffff,%eax
  81101e:	8b 4c 24 18          	mov    0x18(%rsp),%ecx
  811022:	0f 85 dc d4 ff ff    	jne    80e504 <<gpui_canvas::text::planner::Planner>::shape+0x444>
  811028:	e9 15 d5 ff ff       	jmp    80e542 <<gpui_canvas::text::planner::Planner>::shape+0x482>
  81102d:	c7 84 24 98 00 00 00 	movl   $0x3,0x98(%rsp)
  811034:	03 00 00 00 
  811038:	e9 be fc ff ff       	jmp    810cfb <<gpui_canvas::text::planner::Planner>::shape+0x2c3b>
  81103d:	48 c7 84 24 98 00 00 	movq   $0x3,0x98(%rsp)
  811044:	00 03 00 00 00 
  811049:	e9 ad fc ff ff       	jmp    810cfb <<gpui_canvas::text::planner::Planner>::shape+0x2c3b>
  81104e:	c7 84 24 98 00 00 00 	movl   $0x1,0x98(%rsp)
  811055:	01 00 00 00 
  811059:	e9 9d fc ff ff       	jmp    810cfb <<gpui_canvas::text::planner::Planner>::shape+0x2c3b>
  81105e:	c7 84 24 98 00 00 00 	movl   $0x3,0x98(%rsp)
  811065:	03 00 00 00 
  811069:	8b 84 24 18 02 00 00 	mov    0x218(%rsp),%eax
  811070:	89 84 24 9c 00 00 00 	mov    %eax,0x9c(%rsp)
  811077:	e9 7f fc ff ff       	jmp    810cfb <<gpui_canvas::text::planner::Planner>::shape+0x2c3b>
  81107c:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  811083:	00 ff 
  811085:	48 8b 2c 24          	mov    (%rsp),%rbp
  811089:	0f 84 fa 01 00 00    	je     811289 <<gpui_canvas::text::planner::Planner>::shape+0x31c9>
  81108f:	48 8b 84 24 70 01 00 	mov    0x170(%rsp),%rax
  811096:	00 
  811097:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  81109b:	0f 84 aa 03 00 00    	je     81144b <<gpui_canvas::text::planner::Planner>::shape+0x338b>
  8110a1:	48 8b b4 24 80 01 00 	mov    0x180(%rsp),%rsi
  8110a8:	00 
  8110a9:	48 39 f0             	cmp    %rsi,%rax
  8110ac:	0f 86 99 03 00 00    	jbe    81144b <<gpui_canvas::text::planner::Planner>::shape+0x338b>
  8110b2:	48 8d bc 24 70 01 00 	lea    0x170(%rsp),%rdi
  8110b9:	00 
  8110ba:	e8 c1 0d 00 00       	call   811e80 <<alloc::raw_vec::RawVecInner>::shrink>
  8110bf:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  8110c3:	0f 84 82 03 00 00    	je     81144b <<gpui_canvas::text::planner::Planner>::shape+0x338b>
  8110c9:	48 89 c7             	mov    %rax,%rdi
  8110cc:	48 89 d6             	mov    %rdx,%rsi
  8110cf:	ff 15 d3 9e 31 00    	call   *0x319ed3(%rip)        # b2afa8 <_DYNAMIC+0x2d8>
  8110d5:	e9 cd 06 00 00       	jmp    8117a7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  8110da:	48 c7 84 24 98 00 00 	movq   $0xc,0x98(%rsp)
  8110e1:	00 0c 00 00 00 
  8110e6:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  8110ed:	00 ff ff ff ff 
  8110f2:	48 89 f5             	mov    %rsi,%rbp
  8110f5:	e9 11 fc ff ff       	jmp    810d0b <<gpui_canvas::text::planner::Planner>::shape+0x2c4b>
  8110fa:	48 8b b4 24 00 07 00 	mov    0x700(%rsp),%rsi
  811101:	00 
  811102:	48 85 f6             	test   %rsi,%rsi
  811105:	74 17                	je     81111e <<gpui_canvas::text::planner::Planner>::shape+0x305e>
  811107:	48 8b bc 24 08 07 00 	mov    0x708(%rsp),%rdi
  81110e:	00 
  81110f:	48 c1 e6 03          	shl    $0x3,%rsi
  811113:	ba 08 00 00 00       	mov    $0x8,%edx
  811118:	ff 15 fa 9d 31 00    	call   *0x319dfa(%rip)        # b2af18 <_DYNAMIC+0x248>
  81111e:	bb 01 00 00 00       	mov    $0x1,%ebx
  811123:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  811127:	48 8b 2c 24          	mov    (%rsp),%rbp
  81112b:	74 43                	je     811170 <<gpui_canvas::text::planner::Planner>::shape+0x30b0>
  81112d:	4d 85 ed             	test   %r13,%r13
  811130:	74 1a                	je     81114c <<gpui_canvas::text::planner::Planner>::shape+0x308c>
  811132:	48 8b bc 24 a8 02 00 	mov    0x2a8(%rsp),%rdi
  811139:	00 
  81113a:	49 c1 e5 04          	shl    $0x4,%r13
  81113e:	ba 04 00 00 00       	mov    $0x4,%edx
  811143:	4c 89 ee             	mov    %r13,%rsi
  811146:	ff 15 cc 9d 31 00    	call   *0x319dcc(%rip)        # b2af18 <_DYNAMIC+0x248>
  81114c:	48 8b b4 24 b8 02 00 	mov    0x2b8(%rsp),%rsi
  811153:	00 
  811154:	48 85 f6             	test   %rsi,%rsi
  811157:	74 17                	je     811170 <<gpui_canvas::text::planner::Planner>::shape+0x30b0>
  811159:	48 8b bc 24 c0 02 00 	mov    0x2c0(%rsp),%rdi
  811160:	00 
  811161:	48 c1 e6 02          	shl    $0x2,%rsi
  811165:	ba 04 00 00 00       	mov    $0x4,%edx
  81116a:	ff 15 a8 9d 31 00    	call   *0x319da8(%rip)        # b2af18 <_DYNAMIC+0x248>
  811170:	89 9c 24 98 00 00 00 	mov    %ebx,0x98(%rsp)
  811177:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  81117e:	00 ff ff ff ff 
  811183:	e9 83 fb ff ff       	jmp    810d0b <<gpui_canvas::text::planner::Planner>::shape+0x2c4b>
  811188:	48 8b 2c 24          	mov    (%rsp),%rbp
  81118c:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  811191:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  811196:	eb 24                	jmp    8111bc <<gpui_canvas::text::planner::Planner>::shape+0x30fc>
  811198:	4d 89 ce             	mov    %r9,%r14
  81119b:	45 31 e4             	xor    %r12d,%r12d
  81119e:	4d 85 f6             	test   %r14,%r14
  8111a1:	74 27                	je     8111ca <<gpui_canvas::text::planner::Planner>::shape+0x310a>
  8111a3:	4d 89 f1             	mov    %r14,%r9
  8111a6:	48 8b 2c 24          	mov    (%rsp),%rbp
  8111aa:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8111af:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  8111b4:	48 8b 8c 24 48 02 00 	mov    0x248(%rsp),%rcx
  8111bb:	00 
  8111bc:	49 39 c1             	cmp    %rax,%r9
  8111bf:	73 24                	jae    8111e5 <<gpui_canvas::text::planner::Planner>::shape+0x3125>
  8111c1:	43 80 3c 08 bf       	cmpb   $0xbf,(%r8,%r9,1)
  8111c6:	7f 22                	jg     8111ea <<gpui_canvas::text::planner::Planner>::shape+0x312a>
  8111c8:	eb 4a                	jmp    811214 <<gpui_canvas::text::planner::Planner>::shape+0x3154>
  8111ca:	45 31 c9             	xor    %r9d,%r9d
  8111cd:	48 8b 2c 24          	mov    (%rsp),%rbp
  8111d1:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8111d6:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  8111db:	48 8b 8c 24 48 02 00 	mov    0x248(%rsp),%rcx
  8111e2:	00 
  8111e3:	eb 05                	jmp    8111ea <<gpui_canvas::text::planner::Planner>::shape+0x312a>
  8111e5:	49 89 c1             	mov    %rax,%r9
  8111e8:	75 2a                	jne    811214 <<gpui_canvas::text::planner::Planner>::shape+0x3154>
  8111ea:	45 84 e4             	test   %r12b,%r12b
  8111ed:	74 15                	je     811204 <<gpui_canvas::text::planner::Planner>::shape+0x3144>
  8111ef:	4c 39 c9             	cmp    %r9,%rcx
  8111f2:	74 20                	je     811214 <<gpui_canvas::text::planner::Planner>::shape+0x3154>
  8111f4:	43 0f b6 0c 08       	movzbl (%r8,%r9,1),%ecx
  8111f9:	84 c9                	test   %cl,%cl
  8111fb:	78 40                	js     81123d <<gpui_canvas::text::planner::Planner>::shape+0x317d>
  8111fd:	b8 0b 00 00 00       	mov    $0xb,%eax
  811202:	eb 1a                	jmp    81121e <<gpui_canvas::text::planner::Planner>::shape+0x315e>
  811204:	48 39 c1             	cmp    %rax,%rcx
  811207:	73 09                	jae    811212 <<gpui_canvas::text::planner::Planner>::shape+0x3152>
  811209:	41 80 3c 08 bf       	cmpb   $0xbf,(%r8,%rcx,1)
  81120e:	7f df                	jg     8111ef <<gpui_canvas::text::planner::Planner>::shape+0x312f>
  811210:	eb 02                	jmp    811214 <<gpui_canvas::text::planner::Planner>::shape+0x3154>
  811212:	74 db                	je     8111ef <<gpui_canvas::text::planner::Planner>::shape+0x312f>
  811214:	b8 03 00 00 00       	mov    $0x3,%eax
  811219:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  81121e:	89 84 24 98 00 00 00 	mov    %eax,0x98(%rsp)
  811225:	89 8c 24 9c 00 00 00 	mov    %ecx,0x9c(%rsp)
  81122c:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  811233:	00 ff ff ff ff 
  811238:	e9 ce fa ff ff       	jmp    810d0b <<gpui_canvas::text::planner::Planner>::shape+0x2c4b>
  81123d:	89 ca                	mov    %ecx,%edx
  81123f:	83 e2 1f             	and    $0x1f,%edx
  811242:	43 0f b6 7c 08 01    	movzbl 0x1(%r8,%r9,1),%edi
  811248:	83 e7 3f             	and    $0x3f,%edi
  81124b:	b8 0b 00 00 00       	mov    $0xb,%eax
  811250:	80 f9 df             	cmp    $0xdf,%cl
  811253:	76 2b                	jbe    811280 <<gpui_canvas::text::planner::Planner>::shape+0x31c0>
  811255:	43 0f b6 74 08 02    	movzbl 0x2(%r8,%r9,1),%esi
  81125b:	c1 e7 06             	shl    $0x6,%edi
  81125e:	83 e6 3f             	and    $0x3f,%esi
  811261:	09 fe                	or     %edi,%esi
  811263:	80 f9 f0             	cmp    $0xf0,%cl
  811266:	72 7a                	jb     8112e2 <<gpui_canvas::text::planner::Planner>::shape+0x3222>
  811268:	43 0f b6 4c 08 03    	movzbl 0x3(%r8,%r9,1),%ecx
  81126e:	83 e2 07             	and    $0x7,%edx
  811271:	c1 e2 12             	shl    $0x12,%edx
  811274:	c1 e6 06             	shl    $0x6,%esi
  811277:	83 e1 3f             	and    $0x3f,%ecx
  81127a:	09 f1                	or     %esi,%ecx
  81127c:	09 d1                	or     %edx,%ecx
  81127e:	eb 9e                	jmp    81121e <<gpui_canvas::text::planner::Planner>::shape+0x315e>
  811280:	c1 e2 06             	shl    $0x6,%edx
  811283:	09 fa                	or     %edi,%edx
  811285:	89 d1                	mov    %edx,%ecx
  811287:	eb 95                	jmp    81121e <<gpui_canvas::text::planner::Planner>::shape+0x315e>
  811289:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  811290:	00 
  811291:	48 85 c0             	test   %rax,%rax
  811294:	0f 84 8f 00 00 00    	je     811329 <<gpui_canvas::text::planner::Planner>::shape+0x3269>
  81129a:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  8112a1:	00 
  8112a2:	48 c1 e0 04          	shl    $0x4,%rax
  8112a6:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  8112ab:	2b 54 01 f0          	sub    -0x10(%rcx,%rax,1),%edx
  8112af:	0f 83 81 00 00 00    	jae    811336 <<gpui_canvas::text::planner::Planner>::shape+0x3276>
  8112b5:	c7 84 24 98 00 00 00 	movl   $0x3,0x98(%rsp)
  8112bc:	03 00 00 00 
  8112c0:	48 c7 84 24 90 00 00 	movq   $0xffffffffffffffff,0x90(%rsp)
  8112c7:	00 ff ff ff ff 
  8112cc:	48 8b b4 24 e8 00 00 	mov    0xe8(%rsp),%rsi
  8112d3:	00 
  8112d4:	48 85 f6             	test   %rsi,%rsi
  8112d7:	0f 85 bf fa ff ff    	jne    810d9c <<gpui_canvas::text::planner::Planner>::shape+0x2cdc>
  8112dd:	e9 d1 fa ff ff       	jmp    810db3 <<gpui_canvas::text::planner::Planner>::shape+0x2cf3>
  8112e2:	c1 e2 0c             	shl    $0xc,%edx
  8112e5:	09 d6                	or     %edx,%esi
  8112e7:	89 f1                	mov    %esi,%ecx
  8112e9:	e9 30 ff ff ff       	jmp    81121e <<gpui_canvas::text::planner::Planner>::shape+0x315e>
  8112ee:	48 8d 3d 8f 52 8f ff 	lea    -0x70ad71(%rip),%rdi        # 106584 <anon.0f4a3ea25fad7523c9e915b1d5c7afe7.4.llvm.8484617875123403804>
  8112f5:	48 8d 15 44 3d 2f 00 	lea    0x2f3d44(%rip),%rdx        # b05040 <anon.0f4a3ea25fad7523c9e915b1d5c7afe7.5.llvm.8484617875123403804>
  8112fc:	be ad 00 00 00       	mov    $0xad,%esi
  811301:	ff 15 69 9c 31 00    	call   *0x319c69(%rip)        # b2af70 <_DYNAMIC+0x2a0>
  811307:	e9 9b 04 00 00       	jmp    8117a7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  81130c:	48 8d 0d bd 4f 2f 00 	lea    0x2f4fbd(%rip),%rcx        # b062d0 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x4b8>
  811313:	4c 89 ef             	mov    %r13,%rdi
  811316:	48 8b 94 24 30 01 00 	mov    0x130(%rsp),%rdx
  81131d:	00 
  81131e:	ff 15 3c 9c 31 00    	call   *0x319c3c(%rip)        # b2af60 <_DYNAMIC+0x290>
  811324:	e9 7e 04 00 00       	jmp    8117a7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  811329:	48 83 7c 24 50 00    	cmpq   $0x0,0x50(%rsp)
  81132f:	75 11                	jne    811342 <<gpui_canvas::text::planner::Planner>::shape+0x3282>
  811331:	e9 15 01 00 00       	jmp    81144b <<gpui_canvas::text::planner::Planner>::shape+0x338b>
  811336:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  81133c:	0f 86 bf 02 00 00    	jbe    811601 <<gpui_canvas::text::planner::Planner>::shape+0x3541>
  811342:	bf 04 00 00 00       	mov    $0x4,%edi
  811347:	be 18 00 00 00       	mov    $0x18,%esi
  81134c:	e8 ff 0d 00 00       	call   812150 <alloc::boxed::box_new_uninit>
  811351:	49 89 c7             	mov    %rax,%r15
  811354:	8b 84 24 f8 00 00 00 	mov    0xf8(%rsp),%eax
  81135b:	41 c7 07 00 00 00 00 	movl   $0x0,(%r15)
  811362:	4c 8b 74 24 50       	mov    0x50(%rsp),%r14
  811367:	45 89 77 04          	mov    %r14d,0x4(%r15)
  81136b:	41 c7 47 08 00 00 00 	movl   $0x0,0x8(%r15)
  811372:	00 
  811373:	41 89 47 0c          	mov    %eax,0xc(%r15)
  811377:	41 c7 47 10 00 00 00 	movl   $0x0,0x10(%r15)
  81137e:	00 
  81137f:	66 41 c7 47 14 00 00 	movw   $0x0,0x14(%r15)
  811386:	bf 04 00 00 00       	mov    $0x4,%edi
  81138b:	be 18 00 00 00       	mov    $0x18,%esi
  811390:	e8 bb 0d 00 00       	call   812150 <alloc::boxed::box_new_uninit>
  811395:	48 89 c3             	mov    %rax,%rbx
  811398:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  81139e:	44 89 70 04          	mov    %r14d,0x4(%rax)
  8113a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  8113a9:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  8113af:	f3 0f 11 40 0c       	movss  %xmm0,0xc(%rax)
  8113b4:	f3 0f 10 44 24 6c    	movss  0x6c(%rsp),%xmm0
  8113ba:	f3 0f 11 40 10       	movss  %xmm0,0x10(%rax)
  8113bf:	0f 28 84 24 80 02 00 	movaps 0x280(%rsp),%xmm0
  8113c6:	00 
  8113c7:	f3 0f 11 40 14       	movss  %xmm0,0x14(%rax)
  8113cc:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  8113d3:	00 ff 
  8113d5:	74 0d                	je     8113e4 <<gpui_canvas::text::planner::Planner>::shape+0x3324>
  8113d7:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  8113de:	00 
  8113df:	e8 dc c4 ff ff       	call   80d8c0 <core::ptr::drop_glue::<gpui_canvas::text::layout::TextGeometry>>
  8113e4:	48 c7 84 24 40 01 00 	movq   $0x1,0x140(%rsp)
  8113eb:	00 01 00 00 00 
  8113f0:	4c 89 bc 24 48 01 00 	mov    %r15,0x148(%rsp)
  8113f7:	00 
  8113f8:	48 c7 84 24 50 01 00 	movq   $0x1,0x150(%rsp)
  8113ff:	00 01 00 00 00 
  811404:	48 c7 84 24 58 01 00 	movq   $0x1,0x158(%rsp)
  81140b:	00 01 00 00 00 
  811410:	48 89 9c 24 60 01 00 	mov    %rbx,0x160(%rsp)
  811417:	00 
  811418:	48 c7 84 24 68 01 00 	movq   $0x1,0x168(%rsp)
  81141f:	00 01 00 00 00 
  811424:	48 c7 84 24 70 01 00 	movq   $0xffffffffffffffff,0x170(%rsp)
  81142b:	00 ff ff ff ff 
  811430:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  811435:	89 84 24 88 01 00 00 	mov    %eax,0x188(%rsp)
  81143c:	f3 0f 10 44 24 7c    	movss  0x7c(%rsp),%xmm0
  811442:	f3 0f 11 84 24 8c 01 	movss  %xmm0,0x18c(%rsp)
  811449:	00 00 
  81144b:	4c 8b bc 24 e8 00 00 	mov    0xe8(%rsp),%r15
  811452:	00 
  811453:	4c 8b a4 24 f0 00 00 	mov    0xf0(%rsp),%r12
  81145a:	00 
  81145b:	4c 8b b4 24 f8 00 00 	mov    0xf8(%rsp),%r14
  811462:	00 
  811463:	48 89 ef             	mov    %rbp,%rdi
  811466:	48 8b b4 24 08 02 00 	mov    0x208(%rsp),%rsi
  81146d:	00 
  81146e:	e8 7d 06 00 00       	call   811af0 <<gpui_canvas::text::planner::Planner>::font_set>
  811473:	49 89 c5             	mov    %rax,%r13
  811476:	48 89 84 24 b0 04 00 	mov    %rax,0x4b0(%rsp)
  81147d:	00 
  81147e:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
  811485:	00 
  811486:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  81148a:	0f 84 c3 00 00 00    	je     811553 <<gpui_canvas::text::planner::Planner>::shape+0x3493>
  811490:	48 8d 94 24 48 01 00 	lea    0x148(%rsp),%rdx
  811497:	00 
  811498:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
  81149c:	48 89 8c 24 58 07 00 	mov    %rcx,0x758(%rsp)
  8114a3:	00 
  8114a4:	0f 10 02             	movups (%rdx),%xmm0
  8114a7:	0f 10 4a 10          	movups 0x10(%rdx),%xmm1
  8114ab:	0f 10 52 20          	movups 0x20(%rdx),%xmm2
  8114af:	0f 10 5a 30          	movups 0x30(%rdx),%xmm3
  8114b3:	0f 11 9c 24 48 07 00 	movups %xmm3,0x748(%rsp)
  8114ba:	00 
  8114bb:	0f 11 94 24 38 07 00 	movups %xmm2,0x738(%rsp)
  8114c2:	00 
  8114c3:	0f 11 8c 24 28 07 00 	movups %xmm1,0x728(%rsp)
  8114ca:	00 
  8114cb:	0f 11 84 24 18 07 00 	movups %xmm0,0x718(%rsp)
  8114d2:	00 
  8114d3:	48 c7 84 24 00 07 00 	movq   $0x1,0x700(%rsp)
  8114da:	00 01 00 00 00 
  8114df:	48 c7 84 24 08 07 00 	movq   $0x1,0x708(%rsp)
  8114e6:	00 01 00 00 00 
  8114eb:	48 8d 9c 24 10 07 00 	lea    0x710(%rsp),%rbx
  8114f2:	00 
  8114f3:	48 89 84 24 10 07 00 	mov    %rax,0x710(%rsp)
  8114fa:	00 
  8114fb:	bf 08 00 00 00       	mov    $0x8,%edi
  811500:	be 60 00 00 00       	mov    $0x60,%esi
  811505:	e8 46 0c 00 00       	call   812150 <alloc::boxed::box_new_uninit>
  81150a:	0f 10 84 24 50 07 00 	movups 0x750(%rsp),%xmm0
  811511:	00 
  811512:	0f 11 40 50          	movups %xmm0,0x50(%rax)
  811516:	0f 10 84 24 40 07 00 	movups 0x740(%rsp),%xmm0
  81151d:	00 
  81151e:	0f 11 40 40          	movups %xmm0,0x40(%rax)
  811522:	0f 10 84 24 00 07 00 	movups 0x700(%rsp),%xmm0
  811529:	00 
  81152a:	0f 10 8c 24 10 07 00 	movups 0x710(%rsp),%xmm1
  811531:	00 
  811532:	0f 10 94 24 20 07 00 	movups 0x720(%rsp),%xmm2
  811539:	00 
  81153a:	0f 10 9c 24 30 07 00 	movups 0x730(%rsp),%xmm3
  811541:	00 
  811542:	0f 11 58 30          	movups %xmm3,0x30(%rax)
  811546:	0f 11 50 20          	movups %xmm2,0x20(%rax)
  81154a:	0f 11 48 10          	movups %xmm1,0x10(%rax)
  81154e:	0f 11 00             	movups %xmm0,(%rax)
  811551:	eb 02                	jmp    811555 <<gpui_canvas::text::planner::Planner>::shape+0x3495>
  811553:	31 c0                	xor    %eax,%eax
  811555:	4c 89 bc 24 90 00 00 	mov    %r15,0x90(%rsp)
  81155c:	00 
  81155d:	4c 89 a4 24 98 00 00 	mov    %r12,0x98(%rsp)
  811564:	00 
  811565:	4c 89 b4 24 a0 00 00 	mov    %r14,0xa0(%rsp)
  81156c:	00 
  81156d:	4c 89 ac 24 a8 00 00 	mov    %r13,0xa8(%rsp)
  811574:	00 
  811575:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  81157c:	00 
  81157d:	0f 28 84 24 80 02 00 	movaps 0x280(%rsp),%xmm0
  811584:	00 
  811585:	f3 0f 11 84 24 b8 00 	movss  %xmm0,0xb8(%rsp)
  81158c:	00 00 
  81158e:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  811594:	f3 0f 11 84 24 bc 00 	movss  %xmm0,0xbc(%rsp)
  81159b:	00 00 
  81159d:	f3 0f 10 44 24 6c    	movss  0x6c(%rsp),%xmm0
  8115a3:	f3 0f 11 84 24 c0 00 	movss  %xmm0,0xc0(%rsp)
  8115aa:	00 00 
  8115ac:	f3 0f 10 44 24 7c    	movss  0x7c(%rsp),%xmm0
  8115b2:	f3 0f 11 84 24 c4 00 	movss  %xmm0,0xc4(%rsp)
  8115b9:	00 00 
  8115bb:	48 8d bc 24 38 03 00 	lea    0x338(%rsp),%rdi
  8115c2:	00 
  8115c3:	e8 b8 a7 ff ff       	call   80bd80 <core::ptr::drop_glue::<[parlance::font_family::FontFamilyName; 3]>>
  8115c8:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  8115cc:	0f 85 95 f9 ff ff    	jne    810f67 <<gpui_canvas::text::planner::Planner>::shape+0x2ea7>
  8115d2:	e9 4e f8 ff ff       	jmp    810e25 <<gpui_canvas::text::planner::Planner>::shape+0x2d65>
  8115d7:	41 bc 03 00 00 00    	mov    $0x3,%r12d
  8115dd:	8b 84 24 80 00 00 00 	mov    0x80(%rsp),%eax
  8115e4:	41 89 c7             	mov    %eax,%r15d
  8115e7:	e9 1e cf ff ff       	jmp    80e50a <<gpui_canvas::text::planner::Planner>::shape+0x44a>
  8115ec:	41 bc 03 00 00 00    	mov    $0x3,%r12d
  8115f2:	8b 84 24 00 01 00 00 	mov    0x100(%rsp),%eax
  8115f9:	41 89 c7             	mov    %eax,%r15d
  8115fc:	e9 09 cf ff ff       	jmp    80e50a <<gpui_canvas::text::planner::Planner>::shape+0x44a>
  811601:	48 01 c1             	add    %rax,%rcx
  811604:	88 51 ff             	mov    %dl,-0x1(%rcx)
  811607:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  81160e:	00 ff 
  811610:	0f 85 79 fa ff ff    	jne    81108f <<gpui_canvas::text::planner::Planner>::shape+0x2fcf>
  811616:	e9 30 fe ff ff       	jmp    81144b <<gpui_canvas::text::planner::Planner>::shape+0x338b>
  81161b:	48 8d 0d 1e 40 2f 00 	lea    0x2f401e(%rip),%rcx        # b05640 <anon.e15953efb999cecb448192f678c23055.26.llvm.10952606936216045542>
  811622:	48 89 f7             	mov    %rsi,%rdi
  811625:	48 89 d6             	mov    %rdx,%rsi
  811628:	4c 89 c2             	mov    %r8,%rdx
  81162b:	ff 15 2f 99 31 00    	call   *0x31992f(%rip)        # b2af60 <_DYNAMIC+0x290>
  811631:	e9 71 01 00 00       	jmp    8117a7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  811636:	49 89 cd             	mov    %rcx,%r13
  811639:	48 8b 84 24 00 02 00 	mov    0x200(%rsp),%rax
  811640:	00 
  811641:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  811648:	00 
  811649:	48 8d 0d 88 4d 2f 00 	lea    0x2f4d88(%rip),%rcx        # b063d8 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x5c0>
  811650:	e9 be fc ff ff       	jmp    811313 <<gpui_canvas::text::planner::Planner>::shape+0x3253>
  811655:	49 89 d5             	mov    %rdx,%r13
  811658:	48 89 9c 24 30 01 00 	mov    %rbx,0x130(%rsp)
  81165f:	00 
  811660:	48 8d 0d 39 4c 2f 00 	lea    0x2f4c39(%rip),%rcx        # b062a0 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x488>
  811667:	e9 a7 fc ff ff       	jmp    811313 <<gpui_canvas::text::planner::Planner>::shape+0x3253>
  81166c:	48 8d 0d 0d 38 2f 00 	lea    0x2f380d(%rip),%rcx        # b04e80 <anon.eb50a12a9d8fd4acc3835e2fdeae5b5b.22.llvm.18322732550499639497>
  811673:	ff 15 e7 98 31 00    	call   *0x3198e7(%rip)        # b2af60 <_DYNAMIC+0x290>
  811679:	e9 29 01 00 00       	jmp    8117a7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  81167e:	48 8d 0d fb 37 2f 00 	lea    0x2f37fb(%rip),%rcx        # b04e80 <anon.eb50a12a9d8fd4acc3835e2fdeae5b5b.22.llvm.18322732550499639497>
  811685:	ff 15 d5 98 31 00    	call   *0x3198d5(%rip)        # b2af60 <_DYNAMIC+0x290>
  81168b:	e9 17 01 00 00       	jmp    8117a7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  811690:	48 8d 3d 01 3c 2f 00 	lea    0x2f3c01(%rip),%rdi        # b05298 <anon.6d4bed3e4a32d1777059b27187abe65d.21.llvm.10560691058145123337>
  811697:	ff 15 bb 98 31 00    	call   *0x3198bb(%rip)        # b2af58 <_DYNAMIC+0x288>
  81169d:	e9 05 01 00 00       	jmp    8117a7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  8116a2:	bb 03 00 00 00       	mov    $0x3,%ebx
  8116a7:	48 8b 2c 24          	mov    (%rsp),%rbp
  8116ab:	e9 c0 fa ff ff       	jmp    811170 <<gpui_canvas::text::planner::Planner>::shape+0x30b0>
  8116b0:	4c 8d 05 61 4c 2f 00 	lea    0x2f4c61(%rip),%r8        # b06318 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x500>
  8116b7:	48 8b bc 24 38 01 00 	mov    0x138(%rsp),%rdi
  8116be:	00 
  8116bf:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  8116c4:	ff 15 be 9f 31 00    	call   *0x319fbe(%rip)        # b2b688 <_DYNAMIC+0x9b8>
  8116ca:	e9 d8 00 00 00       	jmp    8117a7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  8116cf:	48 8d 05 e2 4b 2f 00 	lea    0x2f4be2(%rip),%rax        # b062b8 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x4a0>
  8116d6:	eb 1f                	jmp    8116f7 <<gpui_canvas::text::planner::Planner>::shape+0x3637>
  8116d8:	48 39 d3             	cmp    %rdx,%rbx
  8116db:	48 0f 47 d3          	cmova  %rbx,%rdx
  8116df:	48 8d 05 c2 4d 2f 00 	lea    0x2f4dc2(%rip),%rax        # b064a8 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x690>
  8116e6:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  8116eb:	48 89 d7             	mov    %rdx,%rdi
  8116ee:	eb 0c                	jmp    8116fc <<gpui_canvas::text::planner::Planner>::shape+0x363c>
  8116f0:	48 8d 05 81 4c 2f 00 	lea    0x2f4c81(%rip),%rax        # b06378 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x560>
  8116f7:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  8116fc:	48 8b b4 24 d8 01 00 	mov    0x1d8(%rsp),%rsi
  811703:	00 
  811704:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  811709:	ff 15 91 98 31 00    	call   *0x319891(%rip)        # b2afa0 <_DYNAMIC+0x2d0>
  81170f:	e9 93 00 00 00       	jmp    8117a7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  811714:	48 8d 0d 15 40 2f 00 	lea    0x2f4015(%rip),%rcx        # b05730 <anon.e15953efb999cecb448192f678c23055.38.llvm.10952606936216045542>
  81171b:	48 89 8c 24 70 02 00 	mov    %rcx,0x270(%rsp)
  811722:	00 
  811723:	eb 04                	jmp    811729 <<gpui_canvas::text::planner::Planner>::shape+0x3669>
  811725:	31 ff                	xor    %edi,%edi
  811727:	31 c0                	xor    %eax,%eax
  811729:	48 89 c6             	mov    %rax,%rsi
  81172c:	48 8b 94 24 70 02 00 	mov    0x270(%rsp),%rdx
  811733:	00 
  811734:	ff 15 66 98 31 00    	call   *0x319866(%rip)        # b2afa0 <_DYNAMIC+0x2d0>
  81173a:	eb 6b                	jmp    8117a7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  81173c:	31 ff                	xor    %edi,%edi
  81173e:	48 c7 84 24 d8 01 00 	movq   $0x0,0x1d8(%rsp)
  811745:	00 00 00 00 00 
  81174a:	eb b0                	jmp    8116fc <<gpui_canvas::text::planner::Planner>::shape+0x363c>
  81174c:	48 8d 15 ad 3c 2f 00 	lea    0x2f3cad(%rip),%rdx        # b05400 <anon.6d4bed3e4a32d1777059b27187abe65d.38.llvm.10560691058145123337>
  811753:	ff 15 47 98 31 00    	call   *0x319847(%rip)        # b2afa0 <_DYNAMIC+0x2d0>
  811759:	eb 4c                	jmp    8117a7 <<gpui_canvas::text::planner::Planner>::shape+0x36e7>
  81175b:	48 8d 05 2e 4d 2f 00 	lea    0x2f4d2e(%rip),%rax        # b06490 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x678>
  811762:	eb 93                	jmp    8116f7 <<gpui_canvas::text::planner::Planner>::shape+0x3637>
  811764:	48 89 d7             	mov    %rdx,%rdi
  811767:	48 8d 05 52 4d 2f 00 	lea    0x2f4d52(%rip),%rax        # b064c0 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x6a8>
  81176e:	eb 87                	jmp    8116f7 <<gpui_canvas::text::planner::Planner>::shape+0x3637>
  811770:	48 8d 05 e9 4b 2f 00 	lea    0x2f4be9(%rip),%rax        # b06360 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x548>
  811777:	e9 7b ff ff ff       	jmp    8116f7 <<gpui_canvas::text::planner::Planner>::shape+0x3637>
  81177c:	48 8d 05 0d 4c 2f 00 	lea    0x2f4c0d(%rip),%rax        # b06390 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x578>
  811783:	e9 6f ff ff ff       	jmp    8116f7 <<gpui_canvas::text::planner::Planner>::shape+0x3637>
  811788:	48 89 d7             	mov    %rdx,%rdi
  81178b:	48 8d 05 16 4c 2f 00 	lea    0x2f4c16(%rip),%rax        # b063a8 <anon.fea7a54a491fc44e68ed823e390a7032.4.llvm.3693154676369875592+0x590>
  811792:	e9 60 ff ff ff       	jmp    8116f7 <<gpui_canvas::text::planner::Planner>::shape+0x3637>
  811797:	48 8d 15 92 3f 2f 00 	lea    0x2f3f92(%rip),%rdx        # b05730 <anon.e15953efb999cecb448192f678c23055.38.llvm.10952606936216045542>
  81179e:	48 89 c6             	mov    %rax,%rsi
  8117a1:	ff 15 f9 97 31 00    	call   *0x3197f9(%rip)        # b2afa0 <_DYNAMIC+0x2d0>
  8117a7:	0f 0b                	ud2
  8117a9:	49 89 c6             	mov    %rax,%r14
  8117ac:	be 18 00 00 00       	mov    $0x18,%esi
  8117b1:	ba 04 00 00 00       	mov    $0x4,%edx
  8117b6:	4c 89 ff             	mov    %r15,%rdi
  8117b9:	ff 15 59 97 31 00    	call   *0x319759(%rip)        # b2af18 <_DYNAMIC+0x248>
  8117bf:	e9 d0 02 00 00       	jmp    811a94 <<gpui_canvas::text::planner::Planner>::shape+0x39d4>
  8117c4:	e9 84 02 00 00       	jmp    811a4d <<gpui_canvas::text::planner::Planner>::shape+0x398d>
  8117c9:	49 89 c6             	mov    %rax,%r14
  8117cc:	48 89 df             	mov    %rbx,%rdi
  8117cf:	e8 ec c0 ff ff       	call   80d8c0 <core::ptr::drop_glue::<gpui_canvas::text::layout::TextGeometry>>
  8117d4:	f0 49 ff 4d 00       	lock decq 0x0(%r13)
  8117d9:	75 0e                	jne    8117e9 <<gpui_canvas::text::planner::Planner>::shape+0x3729>
  8117db:	48 8d bc 24 b0 04 00 	lea    0x4b0(%rsp),%rdi
  8117e2:	00 
  8117e3:	ff 15 d7 97 31 00    	call   *0x3197d7(%rip)        # b2afc0 <_DYNAMIC+0x2f0>
  8117e9:	31 db                	xor    %ebx,%ebx
  8117eb:	eb 10                	jmp    8117fd <<gpui_canvas::text::planner::Planner>::shape+0x373d>
  8117ed:	ff 15 75 97 31 00    	call   *0x319775(%rip)        # b2af68 <_DYNAMIC+0x298>
  8117f3:	e9 55 02 00 00       	jmp    811a4d <<gpui_canvas::text::planner::Planner>::shape+0x398d>
  8117f8:	49 89 c6             	mov    %rax,%r14
  8117fb:	b3 01                	mov    $0x1,%bl
  8117fd:	4d 85 ff             	test   %r15,%r15
  811800:	74 15                	je     811817 <<gpui_canvas::text::planner::Planner>::shape+0x3757>
  811802:	49 c1 e7 04          	shl    $0x4,%r15
  811806:	ba 04 00 00 00       	mov    $0x4,%edx
  81180b:	4c 89 e7             	mov    %r12,%rdi
  81180e:	4c 89 fe             	mov    %r15,%rsi
  811811:	ff 15 01 97 31 00    	call   *0x319701(%rip)        # b2af18 <_DYNAMIC+0x248>
  811817:	84 db                	test   %bl,%bl
  811819:	0f 84 bb 02 00 00    	je     811ada <<gpui_canvas::text::planner::Planner>::shape+0x3a1a>
  81181f:	31 db                	xor    %ebx,%ebx
  811821:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  811828:	00 ff 
  81182a:	74 48                	je     811874 <<gpui_canvas::text::planner::Planner>::shape+0x37b4>
  81182c:	e9 74 02 00 00       	jmp    811aa5 <<gpui_canvas::text::planner::Planner>::shape+0x39e5>
  811831:	e9 17 02 00 00       	jmp    811a4d <<gpui_canvas::text::planner::Planner>::shape+0x398d>
  811836:	49 89 c6             	mov    %rax,%r14
  811839:	4d 89 27             	mov    %r12,(%r15)
  81183c:	4c 89 f7             	mov    %r14,%rdi
  81183f:	e8 4c f5 2e 00       	call   b00d90 <_Unwind_Resume@plt>
  811844:	e9 48 02 00 00       	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  811849:	e9 43 02 00 00       	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  81184e:	e9 3e 02 00 00       	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  811853:	49 89 c6             	mov    %rax,%r14
  811856:	48 8b b4 24 00 07 00 	mov    0x700(%rsp),%rsi
  81185d:	00 
  81185e:	b3 01                	mov    $0x1,%bl
  811860:	48 85 f6             	test   %rsi,%rsi
  811863:	75 1c                	jne    811881 <<gpui_canvas::text::planner::Planner>::shape+0x37c1>
  811865:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  81186c:	00 ff 
  81186e:	0f 85 31 02 00 00    	jne    811aa5 <<gpui_canvas::text::planner::Planner>::shape+0x39e5>
  811874:	84 db                	test   %bl,%bl
  811876:	0f 85 3a 02 00 00    	jne    811ab6 <<gpui_canvas::text::planner::Planner>::shape+0x39f6>
  81187c:	e9 59 02 00 00       	jmp    811ada <<gpui_canvas::text::planner::Planner>::shape+0x3a1a>
  811881:	48 8b bc 24 08 07 00 	mov    0x708(%rsp),%rdi
  811888:	00 
  811889:	48 c1 e6 03          	shl    $0x3,%rsi
  81188d:	ba 08 00 00 00       	mov    $0x8,%edx
  811892:	ff 15 80 96 31 00    	call   *0x319680(%rip)        # b2af18 <_DYNAMIC+0x248>
  811898:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  81189f:	00 ff 
  8118a1:	74 d1                	je     811874 <<gpui_canvas::text::planner::Planner>::shape+0x37b4>
  8118a3:	e9 fd 01 00 00       	jmp    811aa5 <<gpui_canvas::text::planner::Planner>::shape+0x39e5>
  8118a8:	e9 a0 01 00 00       	jmp    811a4d <<gpui_canvas::text::planner::Planner>::shape+0x398d>
  8118ad:	e9 df 01 00 00       	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  8118b2:	e9 da 01 00 00       	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  8118b7:	e9 d5 01 00 00       	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  8118bc:	e9 d0 01 00 00       	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  8118c1:	49 89 c6             	mov    %rax,%r14
  8118c4:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  8118cb:	00 
  8118cc:	e8 af 3f ff ff       	call   805880 <core::ptr::drop_glue::<parley::style::StyleProperty<()>>>
  8118d1:	e9 be 01 00 00       	jmp    811a94 <<gpui_canvas::text::planner::Planner>::shape+0x39d4>
  8118d6:	ff 15 8c 96 31 00    	call   *0x31968c(%rip)        # b2af68 <_DYNAMIC+0x298>
  8118dc:	49 89 c6             	mov    %rax,%r14
  8118df:	48 8d bc 24 00 07 00 	lea    0x700(%rsp),%rdi
  8118e6:	00 
  8118e7:	e8 94 3f ff ff       	call   805880 <core::ptr::drop_glue::<parley::style::StyleProperty<()>>>
  8118ec:	e9 a3 01 00 00       	jmp    811a94 <<gpui_canvas::text::planner::Planner>::shape+0x39d4>
  8118f1:	ff 15 71 96 31 00    	call   *0x319671(%rip)        # b2af68 <_DYNAMIC+0x298>
  8118f7:	49 89 c6             	mov    %rax,%r14
  8118fa:	48 c7 85 c8 08 00 00 	movq   $0x0,0x8c8(%rbp)
  811901:	00 00 00 00 
  811905:	48 c7 85 d0 08 00 00 	movq   $0x4,0x8d0(%rbp)
  81190c:	04 00 00 00 
  811910:	0f 57 c0             	xorps  %xmm0,%xmm0
  811913:	0f 11 85 d8 08 00 00 	movups %xmm0,0x8d8(%rbp)
  81191a:	48 c7 85 e8 08 00 00 	movq   $0x4,0x8e8(%rbp)
  811921:	04 00 00 00 
  811925:	0f 11 85 f0 08 00 00 	movups %xmm0,0x8f0(%rbp)
  81192c:	48 c7 85 00 09 00 00 	movq   $0x8,0x900(%rbp)
  811933:	08 00 00 00 
  811937:	0f 11 85 08 09 00 00 	movups %xmm0,0x908(%rbp)
  81193e:	48 c7 85 18 09 00 00 	movq   $0x8,0x918(%rbp)
  811945:	08 00 00 00 
  811949:	0f 11 85 20 09 00 00 	movups %xmm0,0x920(%rbp)
  811950:	48 c7 85 30 09 00 00 	movq   $0x4,0x930(%rbp)
  811957:	04 00 00 00 
  81195b:	0f 11 85 38 09 00 00 	movups %xmm0,0x938(%rbp)
  811962:	48 c7 85 48 09 00 00 	movq   $0x4,0x948(%rbp)
  811969:	04 00 00 00 
  81196d:	0f 11 85 50 09 00 00 	movups %xmm0,0x950(%rbp)
  811974:	48 c7 85 60 09 00 00 	movq   $0x4,0x960(%rbp)
  81197b:	04 00 00 00 
  81197f:	0f 11 85 68 09 00 00 	movups %xmm0,0x968(%rbp)
  811986:	48 c7 85 78 09 00 00 	movq   $0x8,0x978(%rbp)
  81198d:	08 00 00 00 
  811991:	0f 11 85 80 09 00 00 	movups %xmm0,0x980(%rbp)
  811998:	48 c7 85 90 09 00 00 	movq   $0x2,0x990(%rbp)
  81199f:	02 00 00 00 
  8119a3:	0f 11 85 98 09 00 00 	movups %xmm0,0x998(%rbp)
  8119aa:	48 c7 85 a8 09 00 00 	movq   $0x4,0x9a8(%rbp)
  8119b1:	04 00 00 00 
  8119b5:	0f 11 85 b0 09 00 00 	movups %xmm0,0x9b0(%rbp)
  8119bc:	48 c7 85 c0 09 00 00 	movq   $0x8,0x9c0(%rbp)
  8119c3:	08 00 00 00 
  8119c7:	0f 11 85 c8 09 00 00 	movups %xmm0,0x9c8(%rbp)
  8119ce:	48 c7 85 d8 09 00 00 	movq   $0x8,0x9d8(%rbp)
  8119d5:	08 00 00 00 
  8119d9:	0f 11 85 e0 09 00 00 	movups %xmm0,0x9e0(%rbp)
  8119e0:	48 c7 85 f0 09 00 00 	movq   $0x8,0x9f0(%rbp)
  8119e7:	08 00 00 00 
  8119eb:	0f 11 85 f8 09 00 00 	movups %xmm0,0x9f8(%rbp)
  8119f2:	48 c7 85 08 0a 00 00 	movq   $0x4,0xa08(%rbp)
  8119f9:	04 00 00 00 
  8119fd:	0f 11 85 10 0a 00 00 	movups %xmm0,0xa10(%rbp)
  811a04:	c7 85 20 0a 00 00 00 	movl   $0x3f800000,0xa20(%rbp)
  811a0b:	00 80 3f 
  811a0e:	0f 11 85 24 0a 00 00 	movups %xmm0,0xa24(%rbp)
  811a15:	48 c7 85 32 0a 00 00 	movq   $0x0,0xa32(%rbp)
  811a1c:	00 00 00 00 
  811a20:	66 c7 85 3a 0a 00 00 	movw   $0xff01,0xa3a(%rbp)
  811a27:	01 ff 
  811a29:	c6 85 3c 0a 00 00 00 	movb   $0x0,0xa3c(%rbp)
  811a30:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  811a37:	00 
  811a38:	e8 a3 a4 ff ff       	call   80bee0 <core::ptr::drop_glue::<core::result::Result<gpui_canvas::text::TextLayout, gpui_canvas::Error>>>
  811a3d:	4c 89 f7             	mov    %r14,%rdi
  811a40:	e8 4b f3 2e 00       	call   b00d90 <_Unwind_Resume@plt>
  811a45:	ff 15 1d 95 31 00    	call   *0x31951d(%rip)        # b2af68 <_DYNAMIC+0x298>
  811a4b:	eb 44                	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  811a4d:	49 89 c6             	mov    %rax,%r14
  811a50:	48 8b b4 24 00 07 00 	mov    0x700(%rsp),%rsi
  811a57:	00 
  811a58:	48 85 f6             	test   %rsi,%rsi
  811a5b:	74 17                	je     811a74 <<gpui_canvas::text::planner::Planner>::shape+0x39b4>
  811a5d:	48 8b bc 24 08 07 00 	mov    0x708(%rsp),%rdi
  811a64:	00 
  811a65:	48 c1 e6 03          	shl    $0x3,%rsi
  811a69:	ba 08 00 00 00       	mov    $0x8,%edx
  811a6e:	ff 15 a4 94 31 00    	call   *0x3194a4(%rip)        # b2af18 <_DYNAMIC+0x248>
  811a74:	48 8d bc 24 a0 02 00 	lea    0x2a0(%rsp),%rdi
  811a7b:	00 
  811a7c:	e8 5f a3 ff ff       	call   80bde0 <core::ptr::drop_glue::<core::option::Option<parley::editing::geometry::CursorGeometry<()>>>>
  811a81:	eb 11                	jmp    811a94 <<gpui_canvas::text::planner::Planner>::shape+0x39d4>
  811a83:	eb 0c                	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  811a85:	eb 0a                	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  811a87:	eb 08                	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  811a89:	eb 06                	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  811a8b:	eb 04                	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  811a8d:	eb 02                	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  811a8f:	eb 00                	jmp    811a91 <<gpui_canvas::text::planner::Planner>::shape+0x39d1>
  811a91:	49 89 c6             	mov    %rax,%r14
  811a94:	b3 01                	mov    $0x1,%bl
  811a96:	48 83 bc 24 40 01 00 	cmpq   $0xffffffffffffffff,0x140(%rsp)
  811a9d:	00 ff 
  811a9f:	0f 84 cf fd ff ff    	je     811874 <<gpui_canvas::text::planner::Planner>::shape+0x37b4>
  811aa5:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  811aac:	00 
  811aad:	e8 0e be ff ff       	call   80d8c0 <core::ptr::drop_glue::<gpui_canvas::text::layout::TextGeometry>>
  811ab2:	84 db                	test   %bl,%bl
  811ab4:	74 24                	je     811ada <<gpui_canvas::text::planner::Planner>::shape+0x3a1a>
  811ab6:	48 8b b4 24 e8 00 00 	mov    0xe8(%rsp),%rsi
  811abd:	00 
  811abe:	48 85 f6             	test   %rsi,%rsi
  811ac1:	74 17                	je     811ada <<gpui_canvas::text::planner::Planner>::shape+0x3a1a>
  811ac3:	48 8b bc 24 f0 00 00 	mov    0xf0(%rsp),%rdi
  811aca:	00 
  811acb:	48 c1 e6 04          	shl    $0x4,%rsi
  811acf:	ba 04 00 00 00       	mov    $0x4,%edx
  811ad4:	ff 15 3e 94 31 00    	call   *0x31943e(%rip)        # b2af18 <_DYNAMIC+0x248>
  811ada:	48 8d bc 24 38 03 00 	lea    0x338(%rsp),%rdi
  811ae1:	00 
  811ae2:	e8 99 a2 ff ff       	call   80bd80 <core::ptr::drop_glue::<[parlance::font_family::FontFamilyName; 3]>>
  811ae7:	4c 89 f7             	mov    %r14,%rdi
  811aea:	e8 a1 f2 2e 00       	call   b00d90 <_Unwind_Resume@plt>
