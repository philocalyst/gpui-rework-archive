
/tmp/gpui-bounds-candidate-gpui-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000006cf1f0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds>:
  6cf1f0:	mov    %rdi,%rax
  6cf1f3:	movsd  (%rdx),%xmm2
  6cf1f7:	movsd  0x8(%rdx),%xmm5
  6cf1fc:	movaps %xmm2,%xmm1
  6cf1ff:	addps  %xmm5,%xmm1
  6cf202:	movups (%rdx),%xmm0
  6cf205:	movaps -0x68a8dc(%rip),%xmm3        # 44930 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0xac0>
  6cf20c:	andps  %xmm3,%xmm0
  6cf20f:	andps  %xmm3,%xmm1
  6cf212:	movaps -0x68b179(%rip),%xmm3        # 440a0 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0x230>
  6cf219:	movlhps %xmm5,%xmm3
  6cf21c:	movaps -0x68acb3(%rip),%xmm4        # 44570 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0x700>
  6cf223:	movq   %xmm1,%xmm1
  6cf227:	movaps %xmm3,%xmm6
  6cf22a:	cmpneqps %xmm1,%xmm6
  6cf22e:	movaps %xmm3,%xmm7
  6cf231:	cmpordps %xmm1,%xmm7
  6cf235:	andps  %xmm6,%xmm7
  6cf238:	movaps %xmm4,%xmm6
  6cf23b:	cmpneqps %xmm0,%xmm6
  6cf23f:	cmpordps %xmm4,%xmm0
  6cf243:	andps  %xmm6,%xmm0
  6cf246:	packssdw %xmm7,%xmm0
  6cf24a:	cmpleps %xmm3,%xmm1
  6cf24e:	pshufhw $0x84,%xmm1,%xmm1
  6cf253:	shufps $0x23,%xmm0,%xmm1
  6cf257:	shufps $0x24,%xmm1,%xmm0
  6cf25b:	packsswb %xmm0,%xmm0
  6cf25f:	pmovmskb %xmm0,%ecx
  6cf263:	cmp    $0xff,%cl
  6cf266:	jne    6cf2d8 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe8>
  6cf268:	cmpb   $0x0,0x30(%rsi)
  6cf26c:	jne    6cf2d8 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe8>
  6cf26e:	movups (%rsi),%xmm0
  6cf271:	movups 0x10(%rsi),%xmm3
  6cf275:	movdqu 0x20(%rsi),%xmm1
  6cf27a:	movq   %xmm1,%rcx
  6cf27f:	movabs $0x7fffffffffffffff,%rdx
  6cf289:	and    %rdx,%rcx
  6cf28c:	movabs $0x7fefffffffffffff,%rsi
  6cf296:	cmp    %rsi,%rcx
  6cf299:	setg   %cl
  6cf29c:	movdqa %xmm1,%xmm4
  6cf2a0:	punpckhqdq %xmm1,%xmm4
  6cf2a4:	movq   %xmm4,%rdi
  6cf2a9:	and    %rdx,%rdi
  6cf2ac:	cmp    %rsi,%rdi
  6cf2af:	movaps %xmm0,%xmm4
  6cf2b2:	shufps $0xdd,%xmm3,%xmm4
  6cf2b6:	andps  -0x68a98d(%rip),%xmm4        # 44930 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0xac0>
  6cf2bd:	setg   %dl
  6cf2c0:	pcmpgtd -0x68ab18(%rip),%xmm4        # 447b0 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0x940>
  6cf2c8:	movmskps %xmm4,%esi
  6cf2cb:	test   %esi,%esi
  6cf2cd:	setne  %sil
  6cf2d1:	or     %cl,%dl
  6cf2d3:	or     %sil,%dl
  6cf2d6:	je     6cf2e0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf0>
  6cf2d8:	mov    $0x2,%edx
  6cf2dd:	mov    %edx,(%rax)
  6cf2df:	ret
  6cf2e0:	xor    %edx,%edx
  6cf2e2:	xorps  %xmm4,%xmm4
  6cf2e5:	ucomiss %xmm4,%xmm5
  6cf2e8:	jne    6cf2ec <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xfc>
  6cf2ea:	jnp    6cf2dd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xed>
  6cf2ec:	movaps %xmm5,%xmm6
  6cf2ef:	shufps $0x55,%xmm5,%xmm6
  6cf2f3:	ucomiss %xmm4,%xmm6
  6cf2f6:	jne    6cf2fa <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x10a>
  6cf2f8:	jnp    6cf2dd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xed>
  6cf2fa:	movaps %xmm3,%xmm4
  6cf2fd:	shufps $0x4e,%xmm3,%xmm4
  6cf301:	mulpd  %xmm0,%xmm4
  6cf305:	movapd %xmm4,%xmm6
  6cf309:	unpckhpd %xmm4,%xmm6
  6cf30d:	subsd  %xmm6,%xmm4
  6cf311:	xorpd  %xmm6,%xmm6
  6cf315:	ucomisd %xmm6,%xmm4
  6cf319:	jne    6cf31d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x12d>
  6cf31b:	jnp    6cf2dd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xed>
  6cf31d:	cvtps2pd %xmm2,%xmm4
  6cf320:	cvtps2pd %xmm5,%xmm6
  6cf323:	addpd  %xmm4,%xmm6
  6cf327:	xorps  %xmm2,%xmm2
  6cf32a:	movapd %xmm0,%xmm7
  6cf32e:	cmpltpd %xmm2,%xmm7
  6cf333:	movaps %xmm3,%xmm9
  6cf337:	cmpltpd %xmm2,%xmm9
  6cf33d:	movapd %xmm6,%xmm2
  6cf341:	unpcklpd %xmm6,%xmm2
  6cf345:	movapd %xmm4,%xmm5
  6cf349:	unpcklpd %xmm4,%xmm5
  6cf34d:	movapd %xmm7,%xmm8
  6cf352:	andnpd %xmm2,%xmm8
  6cf357:	movapd %xmm5,%xmm10
  6cf35c:	andpd  %xmm7,%xmm10
  6cf361:	orpd   %xmm8,%xmm10
  6cf366:	andpd  %xmm7,%xmm2
  6cf36a:	andnpd %xmm5,%xmm7
  6cf36e:	orpd   %xmm2,%xmm7
  6cf372:	movapd %xmm6,%xmm5
  6cf376:	unpckhpd %xmm6,%xmm5
  6cf37a:	movapd %xmm4,%xmm8
  6cf37f:	unpckhpd %xmm4,%xmm8
  6cf384:	movapd %xmm9,%xmm11
  6cf389:	andnpd %xmm5,%xmm11
  6cf38e:	movapd %xmm8,%xmm2
  6cf393:	andpd  %xmm9,%xmm2
  6cf398:	orpd   %xmm11,%xmm2
  6cf39d:	movapd %xmm5,%xmm11
  6cf3a2:	andpd  %xmm9,%xmm11
  6cf3a7:	andnpd %xmm8,%xmm9
  6cf3ac:	orpd   %xmm11,%xmm9
  6cf3b1:	mulpd  %xmm0,%xmm7
  6cf3b5:	mulpd  %xmm0,%xmm10
  6cf3ba:	mulpd  %xmm3,%xmm9
  6cf3bf:	addpd  %xmm7,%xmm9
  6cf3c4:	mulpd  %xmm3,%xmm2
  6cf3c8:	addpd  %xmm10,%xmm2
  6cf3cd:	movdqa %xmm1,%xmm7
  6cf3d1:	addpd  %xmm9,%xmm7
  6cf3d6:	addpd  %xmm1,%xmm2
  6cf3da:	movapd %xmm2,%xmm9
  6cf3df:	shufps $0xdd,%xmm7,%xmm9
  6cf3e4:	andps  -0x68aabc(%rip),%xmm9        # 44930 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0xac0>
  6cf3ec:	pcmpgtd -0x68ac45(%rip),%xmm9        # 447b0 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0x940>
  6cf3f5:	movmskps %xmm9,%ecx
  6cf3f9:	test   %ecx,%ecx
  6cf3fb:	je     6cf527 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x337>
  6cf401:	movapd %xmm6,%xmm7
  6cf405:	mulsd  %xmm0,%xmm7
  6cf409:	movapd %xmm0,%xmm2
  6cf40d:	mulsd  %xmm4,%xmm2
  6cf411:	mulsd  %xmm3,%xmm8
  6cf416:	unpckhpd %xmm3,%xmm0
  6cf41a:	mulpd  %xmm0,%xmm4
  6cf41e:	mulsd  %xmm3,%xmm5
  6cf422:	mulpd  %xmm6,%xmm0
  6cf426:	unpcklpd %xmm4,%xmm2
  6cf42a:	movsd  %xmm8,%xmm4
  6cf42f:	movapd %xmm2,%xmm3
  6cf433:	addpd  %xmm4,%xmm3
  6cf437:	addpd  %xmm1,%xmm3
  6cf43b:	movapd %xmm3,%xmm6
  6cf43f:	maxpd  -0x68a897(%rip),%xmm6        # 44bb0 <anon.2536989412ea6200963a9c4c2065b948.3.llvm.12167116443941995919+0x120>
  6cf447:	unpcklpd %xmm0,%xmm7
  6cf44b:	addpd  %xmm7,%xmm4
  6cf44f:	addpd  %xmm1,%xmm4
  6cf453:	movapd %xmm6,%xmm8
  6cf458:	maxpd  %xmm4,%xmm8
  6cf45d:	movapd %xmm8,%xmm9
  6cf462:	cmpunordpd %xmm8,%xmm9
  6cf468:	andpd  %xmm9,%xmm6
  6cf46d:	andnpd %xmm8,%xmm9
  6cf472:	orpd   %xmm6,%xmm9
  6cf477:	movsd  %xmm5,%xmm0
  6cf47b:	addpd  %xmm0,%xmm2
  6cf47f:	addpd  %xmm1,%xmm2
  6cf483:	movapd %xmm9,%xmm6
  6cf488:	maxpd  %xmm2,%xmm6
  6cf48c:	movapd %xmm6,%xmm5
  6cf490:	cmpunordpd %xmm6,%xmm5
  6cf495:	andpd  %xmm5,%xmm9
  6cf49a:	andnpd %xmm6,%xmm5
  6cf49e:	orpd   %xmm9,%xmm5
  6cf4a3:	addpd  %xmm7,%xmm0
  6cf4a7:	addpd  %xmm1,%xmm0
  6cf4ab:	minpd  -0x68a863(%rip),%xmm3        # 44c50 <anon.2536989412ea6200963a9c4c2065b948.3.llvm.12167116443941995919+0x1c0>
  6cf4b3:	movapd %xmm3,%xmm1
  6cf4b7:	minpd  %xmm4,%xmm1
  6cf4bb:	movapd %xmm1,%xmm4
  6cf4bf:	cmpunordpd %xmm1,%xmm4
  6cf4c4:	andpd  %xmm4,%xmm3
  6cf4c8:	andnpd %xmm1,%xmm4
  6cf4cc:	orpd   %xmm3,%xmm4
  6cf4d0:	movapd %xmm4,%xmm1
  6cf4d4:	minpd  %xmm2,%xmm1
  6cf4d8:	movapd %xmm1,%xmm2
  6cf4dc:	cmpunordpd %xmm1,%xmm2
  6cf4e1:	andpd  %xmm2,%xmm4
  6cf4e5:	andnpd %xmm1,%xmm2
  6cf4e9:	orpd   %xmm4,%xmm2
  6cf4ed:	movapd %xmm2,%xmm1
  6cf4f1:	minpd  %xmm0,%xmm1
  6cf4f5:	movapd %xmm1,%xmm7
  6cf4f9:	cmpunordpd %xmm1,%xmm7
  6cf4fe:	andpd  %xmm7,%xmm2
  6cf502:	andnpd %xmm1,%xmm7
  6cf506:	orpd   %xmm2,%xmm7
  6cf50a:	movapd %xmm5,%xmm1
  6cf50e:	maxpd  %xmm0,%xmm1
  6cf512:	movapd %xmm1,%xmm2
  6cf516:	cmpunordpd %xmm1,%xmm2
  6cf51b:	andpd  %xmm2,%xmm5
  6cf51f:	andnpd %xmm1,%xmm2
  6cf523:	orpd   %xmm5,%xmm2
  6cf527:	xorps  %xmm0,%xmm0
  6cf52a:	cvtsd2ss %xmm7,%xmm0
  6cf52e:	movd   %xmm0,%ecx
  6cf532:	ucomiss %xmm0,%xmm0
  6cf535:	setp   %dl
  6cf538:	cmp    $0xff800000,%ecx
  6cf53e:	sete   %sil
  6cf542:	or     %dl,%sil
  6cf545:	jne    6cf566 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x376>
  6cf547:	mov    %ecx,%edx
  6cf549:	and    $0x7fffffff,%edx
  6cf54f:	je     6cf559 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x369>
  6cf551:	cmp    %edx,%ecx
  6cf553:	jne    6cf560 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x370>
  6cf555:	dec    %ecx
  6cf557:	jmp    6cf562 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x372>
  6cf559:	mov    $0x80000001,%ecx
  6cf55e:	jmp    6cf562 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x372>
  6cf560:	inc    %ecx
  6cf562:	movd   %ecx,%xmm0
  6cf566:	movhlps %xmm7,%xmm7
  6cf569:	xorps  %xmm1,%xmm1
  6cf56c:	cvtsd2ss %xmm7,%xmm1
  6cf570:	movd   %xmm1,%ecx
  6cf574:	ucomiss %xmm1,%xmm1
  6cf577:	setp   %dl
  6cf57a:	cmp    $0xff800000,%ecx
  6cf580:	sete   %sil
  6cf584:	or     %dl,%sil
  6cf587:	jne    6cf5a6 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3b6>
  6cf589:	movd   %xmm1,%edx
  6cf58d:	and    $0x7fffffff,%edx
  6cf593:	je     6cf59d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3ad>
  6cf595:	cmp    %edx,%ecx
  6cf597:	jne    6cf5a4 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3b4>
  6cf599:	dec    %ecx
  6cf59b:	jmp    6cf5a6 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3b6>
  6cf59d:	mov    $0x80000001,%ecx
  6cf5a2:	jmp    6cf5a6 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3b6>
  6cf5a4:	inc    %ecx
  6cf5a6:	xorps  %xmm1,%xmm1
  6cf5a9:	cvtsd2ss %xmm2,%xmm1
  6cf5ad:	movd   %xmm1,%edx
  6cf5b1:	ucomiss %xmm1,%xmm1
  6cf5b4:	setp   %sil
  6cf5b8:	cmp    $0x7f800000,%edx
  6cf5be:	sete   %dil
  6cf5c2:	or     %sil,%dil
  6cf5c5:	jne    6cf5e6 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3f6>
  6cf5c7:	mov    %edx,%esi
  6cf5c9:	and    $0x7fffffff,%esi
  6cf5cf:	je     6cf5d9 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3e9>
  6cf5d1:	cmp    %esi,%edx
  6cf5d3:	jne    6cf5e0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3f0>
  6cf5d5:	inc    %edx
  6cf5d7:	jmp    6cf5e2 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3f2>
  6cf5d9:	mov    $0x1,%edx
  6cf5de:	jmp    6cf5e2 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3f2>
  6cf5e0:	dec    %edx
  6cf5e2:	movd   %edx,%xmm1
  6cf5e6:	movhlps %xmm2,%xmm2
  6cf5e9:	cvtsd2ss %xmm2,%xmm2
  6cf5ed:	movd   %xmm2,%edx
  6cf5f1:	ucomiss %xmm2,%xmm2
  6cf5f4:	setp   %sil
  6cf5f8:	cmp    $0x7f800000,%edx
  6cf5fe:	sete   %dil
  6cf602:	or     %sil,%dil
  6cf605:	jne    6cf624 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x434>
  6cf607:	movd   %xmm2,%esi
  6cf60b:	and    $0x7fffffff,%esi
  6cf611:	je     6cf61b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x42b>
  6cf613:	cmp    %esi,%edx
  6cf615:	jne    6cf622 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x432>
  6cf617:	inc    %edx
  6cf619:	jmp    6cf624 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x434>
  6cf61b:	mov    $0x1,%edx
  6cf620:	jmp    6cf624 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x434>
  6cf622:	dec    %edx
  6cf624:	movd   %ecx,%xmm3
  6cf628:	movd   %edx,%xmm2
  6cf62c:	subss  %xmm0,%xmm1
  6cf630:	movd   %xmm1,%edx
  6cf634:	ucomiss %xmm1,%xmm1
  6cf637:	setp   %sil
  6cf63b:	cmp    $0x7f800000,%edx
  6cf641:	sete   %dil
  6cf645:	or     %sil,%dil
  6cf648:	jne    6cf669 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x479>
  6cf64a:	mov    %edx,%esi
  6cf64c:	and    $0x7fffffff,%esi
  6cf652:	je     6cf65c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x46c>
  6cf654:	cmp    %esi,%edx
  6cf656:	jne    6cf663 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x473>
  6cf658:	inc    %edx
  6cf65a:	jmp    6cf665 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x475>
  6cf65c:	mov    $0x1,%edx
  6cf661:	jmp    6cf665 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x475>
  6cf663:	dec    %edx
  6cf665:	movd   %edx,%xmm1
  6cf669:	subss  %xmm3,%xmm2
  6cf66d:	movd   %xmm2,%edx
  6cf671:	ucomiss %xmm2,%xmm2
  6cf674:	setp   %sil
  6cf678:	cmp    $0x7f800000,%edx
  6cf67e:	sete   %dil
  6cf682:	or     %sil,%dil
  6cf685:	jne    6cf6a6 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x4b6>
  6cf687:	mov    %edx,%esi
  6cf689:	and    $0x7fffffff,%esi
  6cf68f:	je     6cf699 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x4a9>
  6cf691:	cmp    %esi,%edx
  6cf693:	jne    6cf6a0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x4b0>
  6cf695:	inc    %edx
  6cf697:	jmp    6cf6a2 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x4b2>
  6cf699:	mov    $0x1,%edx
  6cf69e:	jmp    6cf6a2 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x4b2>
  6cf6a0:	dec    %edx
  6cf6a2:	movd   %edx,%xmm2
  6cf6a6:	movaps %xmm0,%xmm4
  6cf6a9:	addss  %xmm1,%xmm4
  6cf6ad:	movd   %xmm4,%edx
  6cf6b1:	movaps %xmm2,%xmm4
  6cf6b4:	addss  %xmm3,%xmm4
  6cf6b8:	movd   %xmm4,%esi
  6cf6bc:	movdqa %xmm1,%xmm4
  6cf6c0:	punpckldq %xmm2,%xmm4
  6cf6c4:	movdqa %xmm0,%xmm5
  6cf6c8:	punpckldq %xmm3,%xmm5
  6cf6cc:	punpcklqdq %xmm4,%xmm5
  6cf6d0:	and    $0x7fffffff,%edx
  6cf6d6:	cmp    $0x7f800000,%edx
  6cf6dc:	setl   %dl
  6cf6df:	and    $0x7fffffff,%esi
  6cf6e5:	cmp    $0x7f800000,%esi
  6cf6eb:	setl   %sil
  6cf6ef:	pand   -0x68adc7(%rip),%xmm5        # 44930 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0xac0>
  6cf6f7:	pcmpgtd -0x68b79f(%rip),%xmm5        # 43f60 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0xf0>
  6cf6ff:	movmskps %xmm5,%edi
  6cf702:	test   %edi,%edi
  6cf704:	jne    6cf2d8 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe8>
  6cf70a:	test   %dl,%dl
  6cf70c:	je     6cf2d8 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe8>
  6cf712:	test   %sil,%sil
  6cf715:	je     6cf2d8 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe8>
  6cf71b:	xorps  %xmm3,%xmm3
  6cf71e:	ucomiss %xmm3,%xmm1
  6cf721:	jb     6cf2d8 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe8>
  6cf727:	ucomiss %xmm3,%xmm2
  6cf72a:	mov    $0x2,%edx
  6cf72f:	jb     6cf2dd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xed>
  6cf735:	movss  %xmm0,0x4(%rax)
  6cf73a:	mov    %ecx,0x8(%rax)
  6cf73d:	movss  %xmm1,0xc(%rax)
  6cf742:	movss  %xmm2,0x10(%rax)
  6cf747:	mov    $0x1,%edx
  6cf74c:	mov    %edx,(%rax)
  6cf74e:	ret
