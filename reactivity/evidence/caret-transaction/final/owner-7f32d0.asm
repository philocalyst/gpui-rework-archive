
/tmp/gpui-caret-transaction-bin/62e-native-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007f32d0 <gpui_canvas::text::planner::append_caret>:
  7f32d0:	55                   	push   %rbp
  7f32d1:	41 57                	push   %r15
  7f32d3:	41 56                	push   %r14
  7f32d5:	41 55                	push   %r13
  7f32d7:	41 54                	push   %r12
  7f32d9:	53                   	push   %rbx
  7f32da:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  7f32e1:	49 89 cf             	mov    %rcx,%r15
  7f32e4:	49 89 d6             	mov    %rdx,%r14
  7f32e7:	48 89 fb             	mov    %rdi,%rbx
  7f32ea:	f3 0f 5a e0          	cvtss2sd %xmm0,%xmm4
  7f32ee:	41 80 38 00          	cmpb   $0x0,(%r8)
  7f32f2:	0f 84 fb 00 00 00    	je     7f33f3 <gpui_canvas::text::planner::append_caret+0x123>
  7f32f8:	41 0f 10 40 08       	movups 0x8(%r8),%xmm0
  7f32fd:	41 0f 10 48 18       	movups 0x18(%r8),%xmm1
  7f3302:	0f 29 04 24          	movaps %xmm0,(%rsp)
  7f3306:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  7f330b:	66 0f 28 04 24       	movapd (%rsp),%xmm0
  7f3310:	f2 0f 10 4c 24 08    	movsd  0x8(%rsp),%xmm1
  7f3316:	f2 0f 58 cc          	addsd  %xmm4,%xmm1
  7f331a:	66 0f 28 54 24 10    	movapd 0x10(%rsp),%xmm2
  7f3320:	66 0f 5c d0          	subpd  %xmm0,%xmm2
  7f3324:	66 0f 14 c1          	unpcklpd %xmm1,%xmm0
  7f3328:	66 0f 5a ca          	cvtpd2ps %xmm2,%xmm1
  7f332c:	66 0f 5a d8          	cvtpd2ps %xmm0,%xmm3
  7f3330:	66 0f 14 d9          	unpcklpd %xmm1,%xmm3
  7f3334:	66 0f 28 05 24 d4 90 	movapd -0x6f2bdc(%rip),%xmm0        # 100760 <anon.54edef65de96b8e67cbd7be652d99b9c.388.llvm.8229078508888877484+0xb10>
  7f333b:	ff 
  7f333c:	66 0f 54 c3          	andpd  %xmm3,%xmm0
  7f3340:	66 0f 66 05 88 c9 90 	pcmpgtd -0x6f3678(%rip),%xmm0        # ffcd0 <anon.54edef65de96b8e67cbd7be652d99b9c.388.llvm.8229078508888877484+0x80>
  7f3347:	ff 
  7f3348:	0f 50 c0             	movmskps %xmm0,%eax
  7f334b:	85 c0                	test   %eax,%eax
  7f334d:	0f 85 d8 01 00 00    	jne    7f352b <gpui_canvas::text::planner::append_caret+0x25b>
  7f3353:	41 0f 10 40 28       	movups 0x28(%r8),%xmm0
  7f3358:	41 0f 10 48 38       	movups 0x38(%r8),%xmm1
  7f335d:	0f 29 04 24          	movaps %xmm0,(%rsp)
  7f3361:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  7f3366:	f2 0f 58 64 24 08    	addsd  0x8(%rsp),%xmm4
  7f336c:	66 0f 28 04 24       	movapd (%rsp),%xmm0
  7f3371:	66 0f 28 4c 24 10    	movapd 0x10(%rsp),%xmm1
  7f3377:	66 0f 5c c8          	subpd  %xmm0,%xmm1
  7f337b:	66 0f 14 c4          	unpcklpd %xmm4,%xmm0
  7f337f:	66 0f 5a c9          	cvtpd2ps %xmm1,%xmm1
  7f3383:	66 0f 5a e0          	cvtpd2ps %xmm0,%xmm4
  7f3387:	66 0f 14 e1          	unpcklpd %xmm1,%xmm4
  7f338b:	66 0f 28 05 cd d3 90 	movapd -0x6f2c33(%rip),%xmm0        # 100760 <anon.54edef65de96b8e67cbd7be652d99b9c.388.llvm.8229078508888877484+0xb10>
  7f3392:	ff 
  7f3393:	66 0f 54 c4          	andpd  %xmm4,%xmm0
  7f3397:	66 0f 66 05 31 c9 90 	pcmpgtd -0x6f36cf(%rip),%xmm0        # ffcd0 <anon.54edef65de96b8e67cbd7be652d99b9c.388.llvm.8229078508888877484+0x80>
  7f339e:	ff 
  7f339f:	0f 50 c0             	movmskps %xmm0,%eax
  7f33a2:	85 c0                	test   %eax,%eax
  7f33a4:	0f 85 81 01 00 00    	jne    7f352b <gpui_canvas::text::planner::append_caret+0x25b>
  7f33aa:	45 01 f7             	add    %r14d,%r15d
  7f33ad:	66 0f 28 c4          	movapd %xmm4,%xmm0
  7f33b1:	0f c6 c4 55          	shufps $0x55,%xmm4,%xmm0
  7f33b5:	0f 28 cc             	movaps %xmm4,%xmm1
  7f33b8:	66 0f 15 cc          	unpckhpd %xmm4,%xmm1
  7f33bc:	0f 28 d4             	movaps %xmm4,%xmm2
  7f33bf:	0f c6 d4 ff          	shufps $0xff,%xmm4,%xmm2
  7f33c3:	66 0f 28 fb          	movapd %xmm3,%xmm7
  7f33c7:	0f c6 fb 55          	shufps $0x55,%xmm3,%xmm7
  7f33cb:	0f 28 eb             	movaps %xmm3,%xmm5
  7f33ce:	66 0f 15 eb          	unpckhpd %xmm3,%xmm5
  7f33d2:	0f 28 f3             	movaps %xmm3,%xmm6
  7f33d5:	0f c6 f3 ff          	shufps $0xff,%xmm3,%xmm6
  7f33d9:	45 89 fe             	mov    %r15d,%r14d
  7f33dc:	0f 2e dc             	ucomiss %xmm4,%xmm3
  7f33df:	40 b5 01             	mov    $0x1,%bpl
  7f33e2:	0f 85 f9 01 00 00    	jne    7f35e1 <gpui_canvas::text::planner::append_caret+0x311>
  7f33e8:	0f 8b a6 01 00 00    	jnp    7f3594 <gpui_canvas::text::planner::append_caret+0x2c4>
  7f33ee:	e9 ee 01 00 00       	jmp    7f35e1 <gpui_canvas::text::planner::append_caret+0x311>
  7f33f3:	49 89 f5             	mov    %rsi,%r13
  7f33f6:	0f 29 64 24 30       	movaps %xmm4,0x30(%rsp)
  7f33fb:	48 89 f7             	mov    %rsi,%rdi
  7f33fe:	4c 89 fe             	mov    %r15,%rsi
  7f3401:	ba 01 00 00 00       	mov    $0x1,%edx
  7f3406:	e8 55 53 00 00       	call   7f8760 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
  7f340b:	49 89 c4             	mov    %rax,%r12
  7f340e:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  7f3413:	80 e2 01             	and    $0x1,%dl
  7f3416:	88 54 24 48          	mov    %dl,0x48(%rsp)
  7f341a:	4c 39 f8             	cmp    %r15,%rax
  7f341d:	0f 85 82 00 00 00    	jne    7f34a5 <gpui_canvas::text::planner::append_caret+0x1d5>
  7f3423:	48 89 e7             	mov    %rsp,%rdi
  7f3426:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  7f342b:	f3 0f 10 05 4d c3 90 	movss  -0x6f3cb3(%rip),%xmm0        # ff780 <anon.54edef65de96b8e67cbd7be652d99b9c.303.llvm.8229078508888877484+0x1c>
  7f3432:	ff 
  7f3433:	4c 89 ea             	mov    %r13,%rdx
  7f3436:	e8 e5 53 00 00       	call   7f8820 <<parley::editing::cursor::Cursor>::geometry::<()>>
  7f343b:	f2 0f 10 44 24 08    	movsd  0x8(%rsp),%xmm0
  7f3441:	f2 0f 58 44 24 30    	addsd  0x30(%rsp),%xmm0
  7f3447:	66 0f 28 0c 24       	movapd (%rsp),%xmm1
  7f344c:	66 0f 28 54 24 10    	movapd 0x10(%rsp),%xmm2
  7f3452:	66 0f 5c d1          	subpd  %xmm1,%xmm2
  7f3456:	66 0f 14 c8          	unpcklpd %xmm0,%xmm1
  7f345a:	66 0f 5a c9          	cvtpd2ps %xmm1,%xmm1
  7f345e:	66 0f 5a d2          	cvtpd2ps %xmm2,%xmm2
  7f3462:	66 0f 28 c1          	movapd %xmm1,%xmm0
  7f3466:	66 0f 14 c2          	unpcklpd %xmm2,%xmm0
  7f346a:	66 0f 54 05 ee d2 90 	andpd  -0x6f2d12(%rip),%xmm0        # 100760 <anon.54edef65de96b8e67cbd7be652d99b9c.388.llvm.8229078508888877484+0xb10>
  7f3471:	ff 
  7f3472:	66 0f 66 05 56 c8 90 	pcmpgtd -0x6f37aa(%rip),%xmm0        # ffcd0 <anon.54edef65de96b8e67cbd7be652d99b9c.388.llvm.8229078508888877484+0x80>
  7f3479:	ff 
  7f347a:	0f 50 c0             	movmskps %xmm0,%eax
  7f347d:	85 c0                	test   %eax,%eax
  7f347f:	0f 85 a6 00 00 00    	jne    7f352b <gpui_canvas::text::planner::append_caret+0x25b>
  7f3485:	66 0f 29 4c 24 20    	movapd %xmm1,0x20(%rsp)
  7f348b:	0f c6 c9 55          	shufps $0x55,%xmm1,%xmm1
  7f348f:	0f 29 4c 24 50       	movaps %xmm1,0x50(%rsp)
  7f3494:	66 0f 29 54 24 70    	movapd %xmm2,0x70(%rsp)
  7f349a:	0f c6 d2 55          	shufps $0x55,%xmm2,%xmm2
  7f349e:	0f 29 54 24 60       	movaps %xmm2,0x60(%rsp)
  7f34a3:	eb 00                	jmp    7f34a5 <gpui_canvas::text::planner::append_caret+0x1d5>
  7f34a5:	4c 89 ef             	mov    %r13,%rdi
  7f34a8:	4c 89 fe             	mov    %r15,%rsi
  7f34ab:	31 d2                	xor    %edx,%edx
  7f34ad:	e8 ae 52 00 00       	call   7f8760 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
  7f34b2:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  7f34b7:	80 e2 01             	and    $0x1,%dl
  7f34ba:	88 54 24 48          	mov    %dl,0x48(%rsp)
  7f34be:	4c 39 f8             	cmp    %r15,%rax
  7f34c1:	75 7f                	jne    7f3542 <gpui_canvas::text::planner::append_caret+0x272>
  7f34c3:	48 89 e7             	mov    %rsp,%rdi
  7f34c6:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  7f34cb:	f3 0f 10 05 ad c2 90 	movss  -0x6f3d53(%rip),%xmm0        # ff780 <anon.54edef65de96b8e67cbd7be652d99b9c.303.llvm.8229078508888877484+0x1c>
  7f34d2:	ff 
  7f34d3:	4c 89 ea             	mov    %r13,%rdx
  7f34d6:	e8 45 53 00 00       	call   7f8820 <<parley::editing::cursor::Cursor>::geometry::<()>>
  7f34db:	66 0f 28 54 24 30    	movapd 0x30(%rsp),%xmm2
  7f34e1:	f2 0f 58 54 24 08    	addsd  0x8(%rsp),%xmm2
  7f34e7:	66 0f 28 04 24       	movapd (%rsp),%xmm0
  7f34ec:	66 0f 28 4c 24 10    	movapd 0x10(%rsp),%xmm1
  7f34f2:	66 0f 5c c8          	subpd  %xmm0,%xmm1
  7f34f6:	66 0f 14 c2          	unpcklpd %xmm2,%xmm0
  7f34fa:	66 0f 5a e0          	cvtpd2ps %xmm0,%xmm4
  7f34fe:	66 0f 5a c1          	cvtpd2ps %xmm1,%xmm0
  7f3502:	66 0f 14 e0          	unpcklpd %xmm0,%xmm4
  7f3506:	66 0f 28 05 52 d2 90 	movapd -0x6f2dae(%rip),%xmm0        # 100760 <anon.54edef65de96b8e67cbd7be652d99b9c.388.llvm.8229078508888877484+0xb10>
  7f350d:	ff 
  7f350e:	66 0f 54 c4          	andpd  %xmm4,%xmm0
  7f3512:	66 0f 66 05 b6 c7 90 	pcmpgtd -0x6f384a(%rip),%xmm0        # ffcd0 <anon.54edef65de96b8e67cbd7be652d99b9c.388.llvm.8229078508888877484+0x80>
  7f3519:	ff 
  7f351a:	0f 50 c0             	movmskps %xmm0,%eax
  7f351d:	85 c0                	test   %eax,%eax
  7f351f:	0f 28 5c 24 20       	movaps 0x20(%rsp),%xmm3
  7f3524:	0f 28 6c 24 70       	movaps 0x70(%rsp),%xmm5
  7f3529:	74 33                	je     7f355e <gpui_canvas::text::planner::append_caret+0x28e>
  7f352b:	b8 01 00 00 00       	mov    $0x1,%eax
  7f3530:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  7f3537:	5b                   	pop    %rbx
  7f3538:	41 5c                	pop    %r12
  7f353a:	41 5d                	pop    %r13
  7f353c:	41 5e                	pop    %r14
  7f353e:	41 5f                	pop    %r15
  7f3540:	5d                   	pop    %rbp
  7f3541:	c3                   	ret
  7f3542:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  7f3547:	4d 39 fc             	cmp    %r15,%r12
  7f354a:	75 e4                	jne    7f3530 <gpui_canvas::text::planner::append_caret+0x260>
  7f354c:	45 01 f7             	add    %r14d,%r15d
  7f354f:	31 ed                	xor    %ebp,%ebp
  7f3551:	45 89 fe             	mov    %r15d,%r14d
  7f3554:	0f 28 5c 24 20       	movaps 0x20(%rsp),%xmm3
  7f3559:	e9 83 00 00 00       	jmp    7f35e1 <gpui_canvas::text::planner::append_caret+0x311>
  7f355e:	45 01 fe             	add    %r15d,%r14d
  7f3561:	4d 39 fc             	cmp    %r15,%r12
  7f3564:	0f 85 c9 00 00 00    	jne    7f3633 <gpui_canvas::text::planner::append_caret+0x363>
  7f356a:	66 0f 28 c4          	movapd %xmm4,%xmm0
  7f356e:	0f c6 c4 55          	shufps $0x55,%xmm4,%xmm0
  7f3572:	0f 28 cc             	movaps %xmm4,%xmm1
  7f3575:	66 0f 15 cc          	unpckhpd %xmm4,%xmm1
  7f3579:	0f 28 d4             	movaps %xmm4,%xmm2
  7f357c:	0f c6 d4 ff          	shufps $0xff,%xmm4,%xmm2
  7f3580:	0f 28 74 24 60       	movaps 0x60(%rsp),%xmm6
  7f3585:	0f 28 7c 24 50       	movaps 0x50(%rsp),%xmm7
  7f358a:	0f 2e dc             	ucomiss %xmm4,%xmm3
  7f358d:	40 b5 01             	mov    $0x1,%bpl
  7f3590:	75 4f                	jne    7f35e1 <gpui_canvas::text::planner::append_caret+0x311>
  7f3592:	7a 4d                	jp     7f35e1 <gpui_canvas::text::planner::append_caret+0x311>
  7f3594:	0f 2e f8             	ucomiss %xmm0,%xmm7
  7f3597:	75 48                	jne    7f35e1 <gpui_canvas::text::planner::append_caret+0x311>
  7f3599:	7a 46                	jp     7f35e1 <gpui_canvas::text::planner::append_caret+0x311>
  7f359b:	0f 2e e9             	ucomiss %xmm1,%xmm5
  7f359e:	75 41                	jne    7f35e1 <gpui_canvas::text::planner::append_caret+0x311>
  7f35a0:	7a 3f                	jp     7f35e1 <gpui_canvas::text::planner::append_caret+0x311>
  7f35a2:	0f 2e f2             	ucomiss %xmm2,%xmm6
  7f35a5:	75 3a                	jne    7f35e1 <gpui_canvas::text::planner::append_caret+0x311>
  7f35a7:	7a 38                	jp     7f35e1 <gpui_canvas::text::planner::append_caret+0x311>
  7f35a9:	4c 8b 7b 10          	mov    0x10(%rbx),%r15
  7f35ad:	4c 3b 3b             	cmp    (%rbx),%r15
  7f35b0:	75 13                	jne    7f35c5 <gpui_canvas::text::planner::append_caret+0x2f5>
  7f35b2:	48 89 df             	mov    %rbx,%rdi
  7f35b5:	0f 29 5c 24 20       	movaps %xmm3,0x20(%rsp)
  7f35ba:	ff 15 48 ae 33 00    	call   *0x33ae48(%rip)        # b2e408 <_DYNAMIC+0xf08>
  7f35c0:	0f 28 5c 24 20       	movaps 0x20(%rsp),%xmm3
  7f35c5:	48 8b 43 08          	mov    0x8(%rbx),%rax
  7f35c9:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  7f35cd:	44 89 34 88          	mov    %r14d,(%rax,%rcx,4)
  7f35d1:	f3 0f 11 5c 88 04    	movss  %xmm3,0x4(%rax,%rcx,4)
  7f35d7:	c6 44 88 08 03       	movb   $0x3,0x8(%rax,%rcx,4)
  7f35dc:	e9 85 00 00 00       	jmp    7f3666 <gpui_canvas::text::planner::append_caret+0x396>
  7f35e1:	4c 8b 7b 10          	mov    0x10(%rbx),%r15
  7f35e5:	4c 3b 3b             	cmp    (%rbx),%r15
  7f35e8:	75 1d                	jne    7f3607 <gpui_canvas::text::planner::append_caret+0x337>
  7f35ea:	48 89 df             	mov    %rbx,%rdi
  7f35ed:	0f 29 5c 24 20       	movaps %xmm3,0x20(%rsp)
  7f35f2:	0f 29 64 24 30       	movaps %xmm4,0x30(%rsp)
  7f35f7:	ff 15 0b ae 33 00    	call   *0x33ae0b(%rip)        # b2e408 <_DYNAMIC+0xf08>
  7f35fd:	0f 28 64 24 30       	movaps 0x30(%rsp),%xmm4
  7f3602:	0f 28 5c 24 20       	movaps 0x20(%rsp),%xmm3
  7f3607:	48 8b 43 08          	mov    0x8(%rbx),%rax
  7f360b:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  7f360f:	44 89 34 88          	mov    %r14d,(%rax,%rcx,4)
  7f3613:	f3 0f 11 5c 88 04    	movss  %xmm3,0x4(%rax,%rcx,4)
  7f3619:	c6 44 88 08 01       	movb   $0x1,0x8(%rax,%rcx,4)
  7f361e:	49 ff c7             	inc    %r15
  7f3621:	4c 89 7b 10          	mov    %r15,0x10(%rbx)
  7f3625:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  7f362a:	40 84 ed             	test   %bpl,%bpl
  7f362d:	0f 84 fd fe ff ff    	je     7f3530 <gpui_canvas::text::planner::append_caret+0x260>
  7f3633:	4c 8b 7b 10          	mov    0x10(%rbx),%r15
  7f3637:	4c 3b 3b             	cmp    (%rbx),%r15
  7f363a:	75 13                	jne    7f364f <gpui_canvas::text::planner::append_caret+0x37f>
  7f363c:	48 89 df             	mov    %rbx,%rdi
  7f363f:	0f 29 64 24 30       	movaps %xmm4,0x30(%rsp)
  7f3644:	ff 15 be ad 33 00    	call   *0x33adbe(%rip)        # b2e408 <_DYNAMIC+0xf08>
  7f364a:	0f 28 64 24 30       	movaps 0x30(%rsp),%xmm4
  7f364f:	48 8b 43 08          	mov    0x8(%rbx),%rax
  7f3653:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  7f3657:	44 89 34 88          	mov    %r14d,(%rax,%rcx,4)
  7f365b:	f3 0f 11 64 88 04    	movss  %xmm4,0x4(%rax,%rcx,4)
  7f3661:	c6 44 88 08 02       	movb   $0x2,0x8(%rax,%rcx,4)
  7f3666:	49 ff c7             	inc    %r15
  7f3669:	4c 89 7b 10          	mov    %r15,0x10(%rbx)
  7f366d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  7f3672:	e9 b9 fe ff ff       	jmp    7f3530 <gpui_canvas::text::planner::append_caret+0x260>
