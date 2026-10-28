
/tmp/gpui-lazy-bins-target/release/deps/bin_phase-d773cf8873bbe22b:     file format elf64-x86-64


Disassembly of section .text:

00000000000930a0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare>:
   930a0:	55                   	push   %rbp
   930a1:	41 57                	push   %r15
   930a3:	41 56                	push   %r14
   930a5:	41 55                	push   %r13
   930a7:	41 54                	push   %r12
   930a9:	53                   	push   %rbx
   930aa:	48 81 ec e8 01 00 00 	sub    $0x1e8,%rsp
   930b1:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
   930b6:	48 8b 32             	mov    (%rdx),%rsi
   930b9:	48 8b 5a 08          	mov    0x8(%rdx),%rbx
   930bd:	4c 8b 42 10          	mov    0x10(%rdx),%r8
   930c1:	48 89 94 24 88 00 00 	mov    %rdx,0x88(%rsp)
   930c8:	00 
   930c9:	4c 8b 72 18          	mov    0x18(%rdx),%r14
   930cd:	4c 89 f0             	mov    %r14,%rax
   930d0:	48 c1 e0 30          	shl    $0x30,%rax
   930d4:	41 0f b7 c8          	movzwl %r8w,%ecx
   930d8:	48 c1 e1 20          	shl    $0x20,%rcx
   930dc:	48 09 c1             	or     %rax,%rcx
   930df:	89 d8                	mov    %ebx,%eax
   930e1:	c1 e0 10             	shl    $0x10,%eax
   930e4:	48 09 c8             	or     %rcx,%rax
   930e7:	0f b7 ce             	movzwl %si,%ecx
   930ea:	48 09 c1             	or     %rax,%rcx
   930ed:	48 8b 47 48          	mov    0x48(%rdi),%rax
   930f1:	48 39 c8             	cmp    %rcx,%rax
   930f4:	0f 84 93 05 00 00    	je     9368d <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x5ed>
   930fa:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
   930ff:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
   93104:	48 c7 47 48 00 00 00 	movq   $0x0,0x48(%rdi)
   9310b:	00 
   9310c:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
   93111:	4c 89 c5             	mov    %r8,%rbp
   93114:	48 29 f5             	sub    %rsi,%rbp
   93117:	4c 89 f2             	mov    %r14,%rdx
   9311a:	48 29 da             	sub    %rbx,%rdx
   9311d:	48 0f af d5          	imul   %rbp,%rdx
   93121:	48 c7 47 10 00 00 00 	movq   $0x0,0x10(%rdi)
   93128:	00 
   93129:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
   9312e:	48 ff c2             	inc    %rdx
   93131:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
   93136:	48 89 6c 24 48       	mov    %rbp,0x48(%rsp)
   9313b:	75 05                	jne    93142 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xa2>
   9313d:	45 31 ed             	xor    %r13d,%r13d
   93140:	eb 56                	jmp    93198 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xf8>
   93142:	4c 89 f5             	mov    %r14,%rbp
   93145:	48 3b 17             	cmp    (%rdi),%rdx
   93148:	49 89 fe             	mov    %rdi,%r14
   9314b:	49 89 dc             	mov    %rbx,%r12
   9314e:	0f 87 dd 05 00 00    	ja     93731 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x691>
   93154:	45 31 ed             	xor    %r13d,%r13d
   93157:	48 8b 5f 08          	mov    0x8(%rdi),%rbx
   9315b:	4a 8d 3c eb          	lea    (%rbx,%r13,8),%rdi
   9315f:	4c 8b 7c 24 28       	mov    0x28(%rsp),%r15
   93164:	4d 85 ff             	test   %r15,%r15
   93167:	74 17                	je     93180 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xe0>
   93169:	4a 8d 14 fd 00 00 00 	lea    0x0(,%r15,8),%rdx
   93170:	00 
   93171:	31 f6                	xor    %esi,%esi
   93173:	ff 15 7f f4 05 00    	call   *0x5f47f(%rip)        # f25f8 <memset@GLIBC_2.2.5>
   93179:	4d 01 fd             	add    %r15,%r13
   9317c:	4a 8d 3c eb          	lea    (%rbx,%r13,8),%rdi
   93180:	4c 89 e3             	mov    %r12,%rbx
   93183:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
   9318a:	49 ff c5             	inc    %r13
   9318d:	4c 89 f7             	mov    %r14,%rdi
   93190:	49 89 ee             	mov    %rbp,%r14
   93193:	48 8b 6c 24 48       	mov    0x48(%rsp),%rbp
   93198:	48 89 3c 24          	mov    %rdi,(%rsp)
   9319c:	4c 89 6f 10          	mov    %r13,0x10(%rdi)
   931a0:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
   931a5:	48 8b 48 78          	mov    0x78(%rax),%rcx
   931a9:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
   931ae:	48 8b 88 80 00 00 00 	mov    0x80(%rax),%rcx
   931b5:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
   931ba:	48 85 c9             	test   %rcx,%rcx
   931bd:	0f 84 d9 02 00 00    	je     9349c <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x3fc>
   931c3:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
   931c8:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   931cd:	48 8d 04 81          	lea    (%rcx,%rax,4),%rax
   931d1:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
   931d8:	00 
   931d9:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   931de:	48 89 d0             	mov    %rdx,%rax
   931e1:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
   931e6:	48 29 f0             	sub    %rsi,%rax
   931e9:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
   931ee:	48 8d 04 d5 00 00 00 	lea    0x0(,%rdx,8),%rax
   931f5:	00 
   931f6:	bf 18 00 00 00       	mov    $0x18,%edi
   931fb:	48 29 c7             	sub    %rax,%rdi
   931fe:	48 89 bc 24 80 00 00 	mov    %rdi,0x80(%rsp)
   93205:	00 
   93206:	48 8d 3c ed 00 00 00 	lea    0x0(,%rbp,8),%rdi
   9320d:	00 
   9320e:	48 89 7c 24 78       	mov    %rdi,0x78(%rsp)
   93213:	48 8d 34 f5 00 00 00 	lea    0x0(,%rsi,8),%rsi
   9321a:	00 
   9321b:	48 29 c6             	sub    %rax,%rsi
   9321e:	48 89 b4 24 a8 00 00 	mov    %rsi,0xa8(%rsp)
   93225:	00 
   93226:	b8 01 00 00 00       	mov    $0x1,%eax
   9322b:	48 29 d0             	sub    %rdx,%rax
   9322e:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
   93233:	48 8d 42 ff          	lea    -0x1(%rdx),%rax
   93237:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
   9323c:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
   93241:	4c 89 b4 24 98 00 00 	mov    %r14,0x98(%rsp)
   93248:	00 
   93249:	eb 2c                	jmp    93277 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x1d7>
   9324b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   93250:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
   93257:	00 
   93258:	48 83 c1 04          	add    $0x4,%rcx
   9325c:	48 3b 8c 24 90 00 00 	cmp    0x90(%rsp),%rcx
   93263:	00 
   93264:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
   93269:	4c 8b b4 24 98 00 00 	mov    0x98(%rsp),%r14
   93270:	00 
   93271:	0f 84 25 02 00 00    	je     9349c <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x3fc>
   93277:	48 89 8c 24 a0 00 00 	mov    %rcx,0xa0(%rsp)
   9327e:	00 
   9327f:	8b 11                	mov    (%rcx),%edx
   93281:	48 8d bc 24 c8 00 00 	lea    0xc8(%rsp),%rdi
   93288:	00 
   93289:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
   9328e:	e8 ed 04 00 00       	call   93780 <<gpui_canvas::canvas::DisplayList>::get>
   93293:	66 0f 76 d2          	pcmpeqd %xmm2,%xmm2
   93297:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
   9329e:	00 
   9329f:	48 c1 e8 04          	shr    $0x4,%rax
   932a3:	48 39 c3             	cmp    %rax,%rbx
   932a6:	48 0f 47 c3          	cmova  %rbx,%rax
   932aa:	48 8b 94 24 50 01 00 	mov    0x150(%rsp),%rdx
   932b1:	00 
   932b2:	48 89 d1             	mov    %rdx,%rcx
   932b5:	48 c1 e9 04          	shr    $0x4,%rcx
   932b9:	83 e2 0f             	and    $0xf,%edx
   932bc:	48 83 fa 01          	cmp    $0x1,%rdx
   932c0:	48 83 d9 ff          	sbb    $0xffffffffffffffff,%rcx
   932c4:	49 39 ce             	cmp    %rcx,%r14
   932c7:	49 0f 42 ce          	cmovb  %r14,%rcx
   932cb:	48 39 c8             	cmp    %rcx,%rax
   932ce:	73 80                	jae    93250 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x1b0>
   932d0:	48 8b 94 24 38 01 00 	mov    0x138(%rsp),%rdx
   932d7:	00 
   932d8:	48 c1 ea 04          	shr    $0x4,%rdx
   932dc:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
   932e1:	48 39 d6             	cmp    %rdx,%rsi
   932e4:	48 0f 47 d6          	cmova  %rsi,%rdx
   932e8:	48 8b b4 24 48 01 00 	mov    0x148(%rsp),%rsi
   932ef:	00 
   932f0:	48 89 f7             	mov    %rsi,%rdi
   932f3:	48 c1 ef 04          	shr    $0x4,%rdi
   932f7:	83 e6 0f             	and    $0xf,%esi
   932fa:	48 83 fe 01          	cmp    $0x1,%rsi
   932fe:	48 83 df ff          	sbb    $0xffffffffffffffff,%rdi
   93302:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
   93307:	48 39 fe             	cmp    %rdi,%rsi
   9330a:	48 0f 42 fe          	cmovb  %rsi,%rdi
   9330e:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
   93313:	48 39 fa             	cmp    %rdi,%rdx
   93316:	0f 83 34 ff ff ff    	jae    93250 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x1b0>
   9331c:	48 8b 34 24          	mov    (%rsp),%rsi
   93320:	4c 8b 46 08          	mov    0x8(%rsi),%r8
   93324:	49 89 d1             	mov    %rdx,%r9
   93327:	49 f7 d1             	not    %r9
   9332a:	4c 03 4c 24 10       	add    0x10(%rsp),%r9
   9332f:	48 89 d6             	mov    %rdx,%rsi
   93332:	4c 8b 5c 24 18       	mov    0x18(%rsp),%r11
   93337:	4c 29 de             	sub    %r11,%rsi
   9333a:	48 89 c7             	mov    %rax,%rdi
   9333d:	48 2b 7c 24 40       	sub    0x40(%rsp),%rdi
   93342:	49 89 ea             	mov    %rbp,%r10
   93345:	4c 0f af d7          	imul   %rdi,%r10
   93349:	4c 01 d6             	add    %r10,%rsi
   9334c:	48 ff c6             	inc    %rsi
   9334f:	48 89 b4 24 b8 00 00 	mov    %rsi,0xb8(%rsp)
   93356:	00 
   93357:	4c 89 d6             	mov    %r10,%rsi
   9335a:	48 f7 d6             	not    %rsi
   9335d:	4c 01 de             	add    %r11,%rsi
   93360:	48 29 d6             	sub    %rdx,%rsi
   93363:	48 89 b4 24 b0 00 00 	mov    %rsi,0xb0(%rsp)
   9336a:	00 
   9336b:	48 8b b4 24 80 00 00 	mov    0x80(%rsp),%rsi
   93372:	00 
   93373:	4c 01 c6             	add    %r8,%rsi
   93376:	48 0f af 7c 24 78    	imul   0x78(%rsp),%rdi
   9337c:	4c 8d 3c d7          	lea    (%rdi,%rdx,8),%r15
   93380:	49 01 f7             	add    %rsi,%r15
   93383:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
   93388:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
   9338d:	48 8d 1c 17          	lea    (%rdi,%rdx,1),%rbx
   93391:	4c 01 d3             	add    %r10,%rbx
   93394:	4c 8b 5c 24 68       	mov    0x68(%rsp),%r11
   93399:	4d 29 d3             	sub    %r10,%r11
   9339c:	49 29 d3             	sub    %rdx,%r11
   9339f:	49 01 fa             	add    %rdi,%r10
   933a2:	45 31 f6             	xor    %r14d,%r14d
   933a5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   933ac:	00 00 00 00 
   933b0:	49 39 dd             	cmp    %rbx,%r13
   933b3:	49 89 dc             	mov    %rbx,%r12
   933b6:	4d 0f 47 e5          	cmova  %r13,%r12
   933ba:	4d 01 dc             	add    %r11,%r12
   933bd:	4d 39 e1             	cmp    %r12,%r9
   933c0:	4d 0f 42 e1          	cmovb  %r9,%r12
   933c4:	48 89 ef             	mov    %rbp,%rdi
   933c7:	49 0f af fe          	imul   %r14,%rdi
   933cb:	48 03 bc 24 b8 00 00 	add    0xb8(%rsp),%rdi
   933d2:	00 
   933d3:	49 39 fd             	cmp    %rdi,%r13
   933d6:	49 0f 47 fd          	cmova  %r13,%rdi
   933da:	49 0f af f6          	imul   %r14,%rsi
   933de:	48 03 b4 24 b0 00 00 	add    0xb0(%rsp),%rsi
   933e5:	00 
   933e6:	48 01 fe             	add    %rdi,%rsi
   933e9:	49 39 f1             	cmp    %rsi,%r9
   933ec:	49 0f 42 f1          	cmovb  %r9,%rsi
   933f0:	48 ff c6             	inc    %rsi
   933f3:	48 89 d7             	mov    %rdx,%rdi
   933f6:	48 83 fe 05          	cmp    $0x5,%rsi
   933fa:	72 54                	jb     93450 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x3b0>
   933fc:	89 f5                	mov    %esi,%ebp
   933fe:	83 e5 03             	and    $0x3,%ebp
   93401:	bf 04 00 00 00       	mov    $0x4,%edi
   93406:	48 0f 44 ef          	cmove  %rdi,%rbp
   9340a:	48 29 ee             	sub    %rbp,%rsi
   9340d:	48 89 f7             	mov    %rsi,%rdi
   93410:	48 01 d7             	add    %rdx,%rdi
   93413:	49 29 ec             	sub    %rbp,%r12
   93416:	49 ff c4             	inc    %r12
   93419:	31 f6                	xor    %esi,%esi
   9341b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   93420:	f3 41 0f 6f 44 f7 f0 	movdqu -0x10(%r15,%rsi,8),%xmm0
   93427:	f3 41 0f 6f 0c f7    	movdqu (%r15,%rsi,8),%xmm1
   9342d:	66 0f fb c2          	psubq  %xmm2,%xmm0
   93431:	66 0f fb ca          	psubq  %xmm2,%xmm1
   93435:	f3 41 0f 7f 44 f7 f0 	movdqu %xmm0,-0x10(%r15,%rsi,8)
   9343c:	f3 41 0f 7f 0c f7    	movdqu %xmm1,(%r15,%rsi,8)
   93442:	48 83 c6 04          	add    $0x4,%rsi
   93446:	49 39 f4             	cmp    %rsi,%r12
   93449:	75 d5                	jne    93420 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x380>
   9344b:	48 8b 6c 24 48       	mov    0x48(%rsp),%rbp
   93450:	48 ff c0             	inc    %rax
   93453:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
   93458:	48 29 fe             	sub    %rdi,%rsi
   9345b:	4c 01 d7             	add    %r10,%rdi
   9345e:	66 90                	xchg   %ax,%ax
   93460:	4c 39 ef             	cmp    %r13,%rdi
   93463:	0f 83 3c 02 00 00    	jae    936a5 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x605>
   93469:	49 ff 04 f8          	incq   (%r8,%rdi,8)
   9346d:	48 ff c7             	inc    %rdi
   93470:	48 ff ce             	dec    %rsi
   93473:	75 eb                	jne    93460 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x3c0>
   93475:	49 ff c6             	inc    %r14
   93478:	4c 03 bc 24 a8 00 00 	add    0xa8(%rsp),%r15
   9347f:	00 
   93480:	48 01 eb             	add    %rbp,%rbx
   93483:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
   93488:	49 01 f3             	add    %rsi,%r11
   9348b:	49 01 ea             	add    %rbp,%r10
   9348e:	48 39 c8             	cmp    %rcx,%rax
   93491:	0f 85 19 ff ff ff    	jne    933b0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x310>
   93497:	e9 b4 fd ff ff       	jmp    93250 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x1b0>
   9349c:	49 83 fd 02          	cmp    $0x2,%r13
   934a0:	72 43                	jb     934e5 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x445>
   934a2:	4c 8b 3c 24          	mov    (%rsp),%r15
   934a6:	49 8b 4f 08          	mov    0x8(%r15),%rcx
   934aa:	bf 01 00 00 00       	mov    $0x1,%edi
   934af:	90                   	nop
   934b0:	48 8d 47 ff          	lea    -0x1(%rdi),%rax
   934b4:	4c 39 e8             	cmp    %r13,%rax
   934b7:	0f 83 95 02 00 00    	jae    93752 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6b2>
   934bd:	4c 39 ef             	cmp    %r13,%rdi
   934c0:	0f 83 9f 02 00 00    	jae    93765 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6c5>
   934c6:	48 8b 44 f9 f8       	mov    -0x8(%rcx,%rdi,8),%rax
   934cb:	48 01 04 f9          	add    %rax,(%rcx,%rdi,8)
   934cf:	48 ff c7             	inc    %rdi
   934d2:	49 39 fd             	cmp    %rdi,%r13
   934d5:	75 d9                	jne    934b0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x410>
   934d7:	4d 8d 77 28          	lea    0x28(%r15),%r14
   934db:	49 c7 47 28 00 00 00 	movq   $0x0,0x28(%r15)
   934e2:	00 
   934e3:	eb 19                	jmp    934fe <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x45e>
   934e5:	4c 8b 3c 24          	mov    (%rsp),%r15
   934e9:	49 c7 47 28 00 00 00 	movq   $0x0,0x28(%r15)
   934f0:	00 
   934f1:	4d 85 ed             	test   %r13,%r13
   934f4:	0f 84 d0 01 00 00    	je     936ca <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x62a>
   934fa:	4d 8d 77 28          	lea    0x28(%r15),%r14
   934fe:	4d 8d 67 18          	lea    0x18(%r15),%r12
   93502:	49 8b 47 08          	mov    0x8(%r15),%rax
   93506:	4a 8b 5c e8 f8       	mov    -0x8(%rax,%r13,8),%rbx
   9350b:	48 85 db             	test   %rbx,%rbx
   9350e:	74 50                	je     93560 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4c0>
   93510:	49 3b 1c 24          	cmp    (%r12),%rbx
   93514:	0f 87 e5 01 00 00    	ja     936ff <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x65f>
   9351a:	45 31 f6             	xor    %r14d,%r14d
   9351d:	4d 8b 7f 20          	mov    0x20(%r15),%r15
   93521:	4b 8d 3c b7          	lea    (%r15,%r14,4),%rdi
   93525:	48 83 fb 01          	cmp    $0x1,%rbx
   93529:	74 22                	je     9354d <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4ad>
   9352b:	48 8d 14 9d fc ff ff 	lea    -0x4(,%rbx,4),%rdx
   93532:	ff 
   93533:	31 f6                	xor    %esi,%esi
   93535:	ff 15 bd f0 05 00    	call   *0x5f0bd(%rip)        # f25f8 <memset@GLIBC_2.2.5>
   9353b:	49 8d 04 1e          	lea    (%r14,%rbx,1),%rax
   9353f:	49 8d 3c 87          	lea    (%r15,%rax,4),%rdi
   93543:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
   93547:	49 01 de             	add    %rbx,%r14
   9354a:	49 ff ce             	dec    %r14
   9354d:	c7 07 00 00 00 00    	movl   $0x0,(%rdi)
   93553:	49 ff c6             	inc    %r14
   93556:	4c 8b 3c 24          	mov    (%rsp),%r15
   9355a:	4d 8b 6f 10          	mov    0x10(%r15),%r13
   9355e:	eb 03                	jmp    93563 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4c3>
   93560:	45 31 f6             	xor    %r14d,%r14d
   93563:	4d 89 77 28          	mov    %r14,0x28(%r15)
   93567:	49 c7 47 40 00 00 00 	movq   $0x0,0x40(%r15)
   9356e:	00 
   9356f:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
   93574:	4d 39 ee             	cmp    %r13,%r14
   93577:	0f 87 38 01 00 00    	ja     936b5 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x615>
   9357d:	49 8d 47 30          	lea    0x30(%r15),%rax
   93581:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
   93586:	49 8b 77 08          	mov    0x8(%r15),%rsi
   9358a:	4d 3b 77 30          	cmp    0x30(%r15),%r14
   9358e:	0f 87 43 01 00 00    	ja     936d7 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x637>
   93594:	31 db                	xor    %ebx,%ebx
   93596:	4d 85 f6             	test   %r14,%r14
   93599:	74 1a                	je     935b5 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x515>
   9359b:	48 8d 3c dd 00 00 00 	lea    0x0(,%rbx,8),%rdi
   935a2:	00 
   935a3:	49 03 7f 38          	add    0x38(%r15),%rdi
   935a7:	4a 8d 14 f5 00 00 00 	lea    0x0(,%r14,8),%rdx
   935ae:	00 
   935af:	ff 15 b3 ef 05 00    	call   *0x5efb3(%rip)        # f2568 <memcpy@GLIBC_2.14>
   935b5:	4c 01 f3             	add    %r14,%rbx
   935b8:	49 89 5f 40          	mov    %rbx,0x40(%r15)
   935bc:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
   935c2:	0f 84 b3 00 00 00    	je     9367b <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x5db>
   935c8:	48 c1 64 24 08 02    	shlq   $0x2,0x8(%rsp)
   935ce:	45 31 f6             	xor    %r14d,%r14d
   935d1:	48 8d 9c 24 c8 00 00 	lea    0xc8(%rsp),%rbx
   935d8:	00 
   935d9:	4c 8d bc 24 c0 00 00 	lea    0xc0(%rsp),%r15
   935e0:	00 
   935e1:	4c 8d ac 24 58 01 00 	lea    0x158(%rsp),%r13
   935e8:	00 
   935e9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   935f0:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   935f5:	42 8b 14 b0          	mov    (%rax,%r14,4),%edx
   935f9:	48 89 df             	mov    %rbx,%rdi
   935fc:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
   93601:	e8 7a 01 00 00       	call   93780 <<gpui_canvas::canvas::DisplayList>::get>
   93606:	8b ac 24 c8 00 00 00 	mov    0xc8(%rsp),%ebp
   9360d:	83 fd ff             	cmp    $0xffffffff,%ebp
   93610:	74 69                	je     9367b <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x5db>
   93612:	ba 8c 00 00 00       	mov    $0x8c,%edx
   93617:	48 8d bc 24 5c 01 00 	lea    0x15c(%rsp),%rdi
   9361e:	00 
   9361f:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
   93626:	00 
   93627:	ff 15 3b ef 05 00    	call   *0x5ef3b(%rip)        # f2568 <memcpy@GLIBC_2.14>
   9362d:	4c 89 b4 24 c0 00 00 	mov    %r14,0xc0(%rsp)
   93634:	00 
   93635:	49 ff c6             	inc    %r14
   93638:	89 ac 24 58 01 00 00 	mov    %ebp,0x158(%rsp)
   9363f:	4c 89 a4 24 c8 00 00 	mov    %r12,0xc8(%rsp)
   93646:	00 
   93647:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   9364c:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
   93653:	00 
   93654:	4c 89 bc 24 d8 00 00 	mov    %r15,0xd8(%rsp)
   9365b:	00 
   9365c:	4c 89 ef             	mov    %r13,%rdi
   9365f:	48 8b b4 24 88 00 00 	mov    0x88(%rsp),%rsi
   93666:	00 
   93667:	48 89 da             	mov    %rbx,%rdx
   9366a:	e8 91 32 ff ff       	call   86900 <gpui_canvas::canvas::visit_tiles::<<gpui_canvas::canvas::bins::RasterScratch>::prepare::{closure#2}>>
   9366f:	48 83 44 24 08 fc    	addq   $0xfffffffffffffffc,0x8(%rsp)
   93675:	0f 85 75 ff ff ff    	jne    935f0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x550>
   9367b:	48 8b 04 24          	mov    (%rsp),%rax
   9367f:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
   93684:	48 89 48 48          	mov    %rcx,0x48(%rax)
   93688:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
   9368d:	48 39 c8             	cmp    %rcx,%rax
   93690:	0f 94 c0             	sete   %al
   93693:	48 81 c4 e8 01 00 00 	add    $0x1e8,%rsp
   9369a:	5b                   	pop    %rbx
   9369b:	41 5c                	pop    %r12
   9369d:	41 5d                	pop    %r13
   9369f:	41 5e                	pop    %r14
   936a1:	41 5f                	pop    %r15
   936a3:	5d                   	pop    %rbp
   936a4:	c3                   	ret
   936a5:	48 8d 15 c4 bd 05 00 	lea    0x5bdc4(%rip),%rdx        # ef470 <anon.3c511bf1c207598aac5aaa2c17116cb5.21.llvm.16457729305247153211>
   936ac:	4c 89 ee             	mov    %r13,%rsi
   936af:	ff 15 63 ee 05 00    	call   *0x5ee63(%rip)        # f2518 <_DYNAMIC+0x278>
   936b5:	48 8d 0d 7c c1 05 00 	lea    0x5c17c(%rip),%rcx        # ef838 <anon.67d140ac6be036ab2db5fc21edea6796.31.llvm.1829066623604410500+0x48>
   936bc:	31 ff                	xor    %edi,%edi
   936be:	4c 89 f6             	mov    %r14,%rsi
   936c1:	4c 89 ea             	mov    %r13,%rdx
   936c4:	ff 15 76 f1 05 00    	call   *0x5f176(%rip)        # f2840 <_DYNAMIC+0x5a0>
   936ca:	48 8d 3d 4f c1 05 00 	lea    0x5c14f(%rip),%rdi        # ef820 <anon.67d140ac6be036ab2db5fc21edea6796.31.llvm.1829066623604410500+0x30>
   936d1:	ff 15 a9 ee 05 00    	call   *0x5eea9(%rip)        # f2580 <_DYNAMIC+0x2e0>
   936d7:	b9 08 00 00 00       	mov    $0x8,%ecx
   936dc:	41 b8 08 00 00 00    	mov    $0x8,%r8d
   936e2:	49 8d 7f 30          	lea    0x30(%r15),%rdi
   936e6:	48 89 f3             	mov    %rsi,%rbx
   936e9:	31 f6                	xor    %esi,%esi
   936eb:	4c 89 f2             	mov    %r14,%rdx
   936ee:	e8 0d 8f ff ff       	call   8c600 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
   936f3:	48 89 de             	mov    %rbx,%rsi
   936f6:	49 8b 5f 40          	mov    0x40(%r15),%rbx
   936fa:	e9 9c fe ff ff       	jmp    9359b <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4fb>
   936ff:	b9 04 00 00 00       	mov    $0x4,%ecx
   93704:	41 b8 04 00 00 00    	mov    $0x4,%r8d
   9370a:	4c 89 e7             	mov    %r12,%rdi
   9370d:	31 f6                	xor    %esi,%esi
   9370f:	48 89 da             	mov    %rbx,%rdx
   93712:	e8 e9 8e ff ff       	call   8c600 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
   93717:	4d 8b 36             	mov    (%r14),%r14
   9371a:	4d 8b 7f 20          	mov    0x20(%r15),%r15
   9371e:	4b 8d 3c b7          	lea    (%r15,%r14,4),%rdi
   93722:	48 83 fb 01          	cmp    $0x1,%rbx
   93726:	0f 85 ff fd ff ff    	jne    9352b <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x48b>
   9372c:	e9 1c fe ff ff       	jmp    9354d <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4ad>
   93731:	b9 08 00 00 00       	mov    $0x8,%ecx
   93736:	41 b8 08 00 00 00    	mov    $0x8,%r8d
   9373c:	4c 89 f7             	mov    %r14,%rdi
   9373f:	31 f6                	xor    %esi,%esi
   93741:	e8 ba 8e ff ff       	call   8c600 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
   93746:	4c 89 f7             	mov    %r14,%rdi
   93749:	4d 8b 6e 10          	mov    0x10(%r14),%r13
   9374d:	e9 05 fa ff ff       	jmp    93157 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xb7>
   93752:	48 8d 15 f7 c0 05 00 	lea    0x5c0f7(%rip),%rdx        # ef850 <anon.67d140ac6be036ab2db5fc21edea6796.31.llvm.1829066623604410500+0x60>
   93759:	48 89 c7             	mov    %rax,%rdi
   9375c:	4c 89 ee             	mov    %r13,%rsi
   9375f:	ff 15 b3 ed 05 00    	call   *0x5edb3(%rip)        # f2518 <_DYNAMIC+0x278>
   93765:	48 8d 15 fc c0 05 00 	lea    0x5c0fc(%rip),%rdx        # ef868 <anon.67d140ac6be036ab2db5fc21edea6796.31.llvm.1829066623604410500+0x78>
   9376c:	4c 89 ee             	mov    %r13,%rsi
   9376f:	ff 15 a3 ed 05 00    	call   *0x5eda3(%rip)        # f2518 <_DYNAMIC+0x278>
