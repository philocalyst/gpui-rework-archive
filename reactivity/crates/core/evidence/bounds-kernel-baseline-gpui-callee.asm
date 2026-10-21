
/tmp/gpui-bounds-baseline-gpui-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000006cf1e0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds>:
  6cf1e0:	mov    %rdi,%rax
  6cf1e3:	movsd  (%rdx),%xmm6
  6cf1e7:	movsd  0x8(%rdx),%xmm1
  6cf1ec:	movaps %xmm6,%xmm2
  6cf1ef:	addps  %xmm1,%xmm2
  6cf1f2:	movups (%rdx),%xmm0
  6cf1f5:	movaps -0x68a8cc(%rip),%xmm3        # 44930 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0xac0>
  6cf1fc:	andps  %xmm3,%xmm0
  6cf1ff:	andps  %xmm3,%xmm2
  6cf202:	movaps -0x68b169(%rip),%xmm3        # 440a0 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0x230>
  6cf209:	movlhps %xmm1,%xmm3
  6cf20c:	movaps -0x68aca3(%rip),%xmm4        # 44570 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0x700>
  6cf213:	movq   %xmm2,%xmm2
  6cf217:	movaps %xmm3,%xmm5
  6cf21a:	cmpneqps %xmm2,%xmm5
  6cf21e:	movaps %xmm3,%xmm7
  6cf221:	cmpordps %xmm2,%xmm7
  6cf225:	andps  %xmm5,%xmm7
  6cf228:	movaps %xmm4,%xmm5
  6cf22b:	cmpneqps %xmm0,%xmm5
  6cf22f:	cmpordps %xmm4,%xmm0
  6cf233:	andps  %xmm5,%xmm0
  6cf236:	packssdw %xmm7,%xmm0
  6cf23a:	cmpleps %xmm3,%xmm2
  6cf23e:	pshufhw $0x84,%xmm2,%xmm2
  6cf243:	shufps $0x23,%xmm0,%xmm2
  6cf247:	shufps $0x24,%xmm2,%xmm0
  6cf24b:	packsswb %xmm0,%xmm0
  6cf24f:	pmovmskb %xmm0,%ecx
  6cf253:	cmp    $0xff,%cl
  6cf256:	jne    6cf2fd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
  6cf25c:	cmpb   $0x0,0x30(%rsi)
  6cf260:	jne    6cf2fd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
  6cf266:	movq   (%rsi),%xmm2
  6cf26a:	movq   0x8(%rsi),%xmm0
  6cf26f:	movq   %xmm2,%rdx
  6cf274:	movq   %xmm0,%rdi
  6cf279:	movq   0x10(%rsi),%xmm4
  6cf27e:	movq   %xmm4,%r8
  6cf283:	movq   0x18(%rsi),%xmm7
  6cf288:	movq   %xmm7,%r9
  6cf28d:	movq   0x20(%rsi),%xmm5
  6cf292:	movq   %xmm5,%r10
  6cf297:	movq   0x28(%rsi),%xmm3
  6cf29c:	movq   %xmm3,%rcx
  6cf2a1:	movabs $0x7fffffffffffffff,%rsi
  6cf2ab:	and    %rsi,%rdx
  6cf2ae:	movabs $0x7fefffffffffffff,%r11
  6cf2b8:	cmp    %r11,%rdx
  6cf2bb:	setg   %dl
  6cf2be:	and    %rsi,%rdi
  6cf2c1:	cmp    %r11,%rdi
  6cf2c4:	setg   %dil
  6cf2c8:	or     %dl,%dil
  6cf2cb:	and    %rsi,%r8
  6cf2ce:	cmp    %r11,%r8
  6cf2d1:	setg   %dl
  6cf2d4:	and    %rsi,%r9
  6cf2d7:	cmp    %r11,%r9
  6cf2da:	setg   %r8b
  6cf2de:	or     %dl,%r8b
  6cf2e1:	or     %dil,%r8b
  6cf2e4:	and    %rsi,%r10
  6cf2e7:	cmp    %r11,%r10
  6cf2ea:	setg   %dl
  6cf2ed:	and    %rsi,%rcx
  6cf2f0:	cmp    %r11,%rcx
  6cf2f3:	setg   %cl
  6cf2f6:	or     %dl,%cl
  6cf2f8:	or     %r8b,%cl
  6cf2fb:	je     6cf305 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x125>
  6cf2fd:	mov    $0x2,%edx
  6cf302:	mov    %edx,(%rax)
  6cf304:	ret
  6cf305:	xor    %edx,%edx
  6cf307:	xorps  %xmm8,%xmm8
  6cf30b:	ucomiss %xmm8,%xmm1
  6cf30f:	jne    6cf313 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x133>
  6cf311:	jnp    6cf302 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
  6cf313:	movaps %xmm1,%xmm9
  6cf317:	shufps $0x55,%xmm1,%xmm9
  6cf31c:	ucomiss %xmm8,%xmm9
  6cf320:	jne    6cf324 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x144>
  6cf322:	jnp    6cf302 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
  6cf324:	movdqa %xmm2,%xmm8
  6cf329:	mulsd  %xmm7,%xmm8
  6cf32e:	movdqa %xmm0,%xmm9
  6cf333:	mulsd  %xmm4,%xmm9
  6cf338:	subsd  %xmm9,%xmm8
  6cf33d:	xorpd  %xmm9,%xmm9
  6cf342:	ucomisd %xmm9,%xmm8
  6cf347:	jne    6cf34b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x16b>
  6cf349:	jnp    6cf302 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
  6cf34b:	cvtps2pd %xmm6,%xmm9
  6cf34f:	movdqa %xmm4,%xmm10
  6cf354:	cvtps2pd %xmm1,%xmm1
  6cf357:	movdqa %xmm2,%xmm8
  6cf35c:	mulsd  %xmm9,%xmm8
  6cf361:	movdqa %xmm0,%xmm6
  6cf365:	mulsd  %xmm9,%xmm6
  6cf36a:	addpd  %xmm9,%xmm1
  6cf36f:	unpckhpd %xmm9,%xmm9
  6cf374:	mulsd  %xmm9,%xmm4
  6cf379:	movapd %xmm8,%xmm11
  6cf37e:	addsd  %xmm4,%xmm11
  6cf383:	addsd  %xmm5,%xmm11
  6cf388:	mulsd  %xmm7,%xmm9
  6cf38d:	movapd %xmm6,%xmm12
  6cf392:	addsd  %xmm9,%xmm12
  6cf397:	addsd  %xmm3,%xmm12
  6cf39c:	movsd  -0x689fcd(%rip),%xmm13        # 453d8 <anon.6012f703f76728adc1ab0e9d1e27dcb4.281.llvm.4097891651611014805+0x68>
  6cf3a5:	movapd %xmm11,%xmm14
  6cf3aa:	minsd  %xmm13,%xmm14
  6cf3af:	movapd %xmm12,%xmm15
  6cf3b4:	minsd  %xmm13,%xmm15
  6cf3b9:	movsd  -0x689f7a(%rip),%xmm13        # 45448 <anon.6012f703f76728adc1ab0e9d1e27dcb4.164.llvm.4097891651611014805+0x38>
  6cf3c2:	maxsd  %xmm13,%xmm11
  6cf3c7:	maxsd  %xmm13,%xmm12
  6cf3cc:	punpcklqdq %xmm10,%xmm2
  6cf3d1:	mulpd  %xmm1,%xmm2
  6cf3d5:	addsd  %xmm2,%xmm4
  6cf3d9:	addsd  %xmm5,%xmm4
  6cf3dd:	mulsd  %xmm1,%xmm0
  6cf3e1:	addsd  %xmm0,%xmm9
  6cf3e6:	addsd  %xmm3,%xmm9
  6cf3eb:	movapd %xmm4,%xmm13
  6cf3f0:	minsd  %xmm14,%xmm13
  6cf3f5:	movapd %xmm9,%xmm14
  6cf3fa:	minsd  %xmm15,%xmm14
  6cf3ff:	maxsd  %xmm11,%xmm4
  6cf404:	maxsd  %xmm12,%xmm9
  6cf409:	movapd %xmm2,%xmm10
  6cf40e:	unpckhpd %xmm2,%xmm10
  6cf413:	addsd  %xmm10,%xmm8
  6cf418:	addsd  %xmm5,%xmm8
  6cf41d:	unpckhpd %xmm1,%xmm1
  6cf421:	mulsd  %xmm7,%xmm1
  6cf425:	addsd  %xmm1,%xmm6
  6cf429:	addsd  %xmm3,%xmm6
  6cf42d:	movapd %xmm8,%xmm7
  6cf432:	minsd  %xmm13,%xmm7
  6cf437:	movapd %xmm6,%xmm11
  6cf43c:	minsd  %xmm14,%xmm11
  6cf441:	maxsd  %xmm4,%xmm8
  6cf446:	addsd  %xmm2,%xmm10
  6cf44b:	addsd  %xmm5,%xmm10
  6cf450:	addsd  %xmm0,%xmm1
  6cf454:	addsd  %xmm3,%xmm1
  6cf458:	movapd %xmm10,%xmm0
  6cf45d:	minsd  %xmm7,%xmm0
  6cf461:	movapd %xmm1,%xmm2
  6cf465:	minsd  %xmm11,%xmm2
  6cf46a:	cvtsd2ss %xmm0,%xmm0
  6cf46e:	movd   %xmm0,%ecx
  6cf472:	cmp    $0xff800000,%ecx
  6cf478:	je     6cf499 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b9>
  6cf47a:	mov    %ecx,%edx
  6cf47c:	and    $0x7fffffff,%edx
  6cf482:	je     6cf48c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2ac>
  6cf484:	cmp    %edx,%ecx
  6cf486:	jne    6cf493 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b3>
  6cf488:	dec    %ecx
  6cf48a:	jmp    6cf495 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b5>
  6cf48c:	mov    $0x80000001,%ecx
  6cf491:	jmp    6cf495 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b5>
  6cf493:	inc    %ecx
  6cf495:	movd   %ecx,%xmm0
  6cf499:	maxsd  %xmm9,%xmm6
  6cf49e:	cvtsd2ss %xmm2,%xmm2
  6cf4a2:	maxsd  %xmm8,%xmm10
  6cf4a7:	movd   %xmm2,%edx
  6cf4ab:	mov    $0xff800000,%ecx
  6cf4b0:	cmp    $0xff800000,%edx
  6cf4b6:	je     6cf4d5 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2f5>
  6cf4b8:	mov    %edx,%ecx
  6cf4ba:	and    $0x7fffffff,%ecx
  6cf4c0:	je     6cf4ca <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2ea>
  6cf4c2:	cmp    %ecx,%edx
  6cf4c4:	jne    6cf4d1 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2f1>
  6cf4c6:	dec    %edx
  6cf4c8:	jmp    6cf4d3 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2f3>
  6cf4ca:	mov    $0x80000001,%ecx
  6cf4cf:	jmp    6cf4d5 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2f5>
  6cf4d1:	inc    %edx
  6cf4d3:	mov    %edx,%ecx
  6cf4d5:	maxsd  %xmm6,%xmm1
  6cf4d9:	xorps  %xmm2,%xmm2
  6cf4dc:	cvtsd2ss %xmm10,%xmm2
  6cf4e1:	movd   %xmm2,%edx
  6cf4e5:	cmp    $0x7f800000,%edx
  6cf4eb:	je     6cf50c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x32c>
  6cf4ed:	mov    %edx,%esi
  6cf4ef:	and    $0x7fffffff,%esi
  6cf4f5:	je     6cf4ff <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x31f>
  6cf4f7:	cmp    %esi,%edx
  6cf4f9:	jne    6cf506 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x326>
  6cf4fb:	inc    %edx
  6cf4fd:	jmp    6cf508 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x328>
  6cf4ff:	mov    $0x1,%edx
  6cf504:	jmp    6cf508 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x328>
  6cf506:	dec    %edx
  6cf508:	movd   %edx,%xmm2
  6cf50c:	cvtsd2ss %xmm1,%xmm1
  6cf510:	movd   %xmm1,%edx
  6cf514:	mov    $0x7f800000,%esi
  6cf519:	cmp    $0x7f800000,%edx
  6cf51f:	je     6cf53e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x35e>
  6cf521:	mov    %edx,%esi
  6cf523:	and    $0x7fffffff,%esi
  6cf529:	je     6cf533 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x353>
  6cf52b:	cmp    %esi,%edx
  6cf52d:	jne    6cf53a <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x35a>
  6cf52f:	inc    %edx
  6cf531:	jmp    6cf53c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x35c>
  6cf533:	mov    $0x1,%esi
  6cf538:	jmp    6cf53e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x35e>
  6cf53a:	dec    %edx
  6cf53c:	mov    %edx,%esi
  6cf53e:	movd   %ecx,%xmm3
  6cf542:	movd   %esi,%xmm1
  6cf546:	subss  %xmm0,%xmm2
  6cf54a:	movd   %xmm2,%edx
  6cf54e:	ucomiss %xmm2,%xmm2
  6cf551:	setp   %sil
  6cf555:	cmp    $0x7f800000,%edx
  6cf55b:	sete   %dil
  6cf55f:	or     %sil,%dil
  6cf562:	jne    6cf583 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3a3>
  6cf564:	mov    %edx,%esi
  6cf566:	and    $0x7fffffff,%esi
  6cf56c:	je     6cf576 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x396>
  6cf56e:	cmp    %esi,%edx
  6cf570:	jne    6cf57d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x39d>
  6cf572:	inc    %edx
  6cf574:	jmp    6cf57f <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x39f>
  6cf576:	mov    $0x1,%edx
  6cf57b:	jmp    6cf57f <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x39f>
  6cf57d:	dec    %edx
  6cf57f:	movd   %edx,%xmm2
  6cf583:	subss  %xmm3,%xmm1
  6cf587:	movd   %xmm1,%edx
  6cf58b:	ucomiss %xmm1,%xmm1
  6cf58e:	setp   %sil
  6cf592:	cmp    $0x7f800000,%edx
  6cf598:	sete   %dil
  6cf59c:	or     %sil,%dil
  6cf59f:	jne    6cf5c0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3e0>
  6cf5a1:	mov    %edx,%esi
  6cf5a3:	and    $0x7fffffff,%esi
  6cf5a9:	je     6cf5b3 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3d3>
  6cf5ab:	cmp    %esi,%edx
  6cf5ad:	jne    6cf5ba <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3da>
  6cf5af:	inc    %edx
  6cf5b1:	jmp    6cf5bc <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3dc>
  6cf5b3:	mov    $0x1,%edx
  6cf5b8:	jmp    6cf5bc <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3dc>
  6cf5ba:	dec    %edx
  6cf5bc:	movd   %edx,%xmm1
  6cf5c0:	movaps %xmm0,%xmm4
  6cf5c3:	addss  %xmm2,%xmm4
  6cf5c7:	movd   %xmm4,%edx
  6cf5cb:	movaps %xmm1,%xmm4
  6cf5ce:	addss  %xmm3,%xmm4
  6cf5d2:	movd   %xmm4,%esi
  6cf5d6:	movdqa %xmm2,%xmm4
  6cf5da:	punpckldq %xmm1,%xmm4
  6cf5de:	movdqa %xmm0,%xmm5
  6cf5e2:	punpckldq %xmm3,%xmm5
  6cf5e6:	punpcklqdq %xmm4,%xmm5
  6cf5ea:	and    $0x7fffffff,%edx
  6cf5f0:	cmp    $0x7f800000,%edx
  6cf5f6:	setl   %dl
  6cf5f9:	and    $0x7fffffff,%esi
  6cf5ff:	cmp    $0x7f800000,%esi
  6cf605:	setl   %sil
  6cf609:	pand   -0x68ace1(%rip),%xmm5        # 44930 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0xac0>
  6cf611:	pcmpgtd -0x68b6b9(%rip),%xmm5        # 43f60 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0xf0>
  6cf619:	movmskps %xmm5,%edi
  6cf61c:	test   %edi,%edi
  6cf61e:	jne    6cf2fd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
  6cf624:	test   %dl,%dl
  6cf626:	je     6cf2fd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
  6cf62c:	test   %sil,%sil
  6cf62f:	je     6cf2fd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
  6cf635:	xorps  %xmm3,%xmm3
  6cf638:	ucomiss %xmm3,%xmm2
  6cf63b:	jb     6cf2fd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
  6cf641:	ucomiss %xmm3,%xmm1
  6cf644:	mov    $0x2,%edx
  6cf649:	jb     6cf302 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
  6cf64f:	movss  %xmm0,0x4(%rax)
  6cf654:	mov    %ecx,0x8(%rax)
  6cf657:	movss  %xmm2,0xc(%rax)
  6cf65c:	movss  %xmm1,0x10(%rax)
  6cf661:	mov    $0x1,%edx
  6cf666:	mov    %edx,(%rax)
  6cf668:	ret
