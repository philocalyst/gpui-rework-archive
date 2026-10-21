
/tmp/gpui-bounds-provenance-candidate-gpui-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000006cf1f0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds>:
  6cf1f0:	mov    %rdi,%rax
  6cf1f3:	movsd  (%rdx),%xmm1
  6cf1f7:	movsd  0x8(%rdx),%xmm5
  6cf1fc:	movaps %xmm1,%xmm2
  6cf1ff:	addps  %xmm5,%xmm2
  6cf202:	movups (%rdx),%xmm0
  6cf205:	movaps -0x68a8cc(%rip),%xmm3        # 44940 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0xad0>
  6cf20c:	andps  %xmm3,%xmm0
  6cf20f:	andps  %xmm3,%xmm2
  6cf212:	movaps -0x68b179(%rip),%xmm3        # 440a0 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0x230>
  6cf219:	movlhps %xmm5,%xmm3
  6cf21c:	movaps -0x68acc3(%rip),%xmm4        # 44560 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0x6f0>
  6cf223:	movq   %xmm2,%xmm2
  6cf227:	movaps %xmm3,%xmm6
  6cf22a:	cmpneqps %xmm2,%xmm6
  6cf22e:	movaps %xmm3,%xmm7
  6cf231:	cmpordps %xmm2,%xmm7
  6cf235:	andps  %xmm6,%xmm7
  6cf238:	movaps %xmm4,%xmm6
  6cf23b:	cmpneqps %xmm0,%xmm6
  6cf23f:	cmpordps %xmm4,%xmm0
  6cf243:	andps  %xmm6,%xmm0
  6cf246:	packssdw %xmm7,%xmm0
  6cf24a:	cmpleps %xmm3,%xmm2
  6cf24e:	pshufhw $0x84,%xmm2,%xmm2
  6cf253:	shufps $0x23,%xmm0,%xmm2
  6cf257:	shufps $0x24,%xmm2,%xmm0
  6cf25b:	packsswb %xmm0,%xmm0
  6cf25f:	pmovmskb %xmm0,%ecx
  6cf263:	cmp    $0xff,%cl
  6cf266:	jne    6cf2dd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xed>
  6cf268:	movzbl 0x30(%rsi),%ecx
  6cf26c:	cmp    $0x2,%cl
  6cf26f:	je     6cf2dd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xed>
  6cf271:	movups (%rsi),%xmm0
  6cf274:	movups 0x10(%rsi),%xmm3
  6cf278:	movdqu 0x20(%rsi),%xmm2
  6cf27d:	movq   %xmm2,%rdx
  6cf282:	movabs $0x7fffffffffffffff,%rsi
  6cf28c:	and    %rsi,%rdx
  6cf28f:	movabs $0x7fefffffffffffff,%rdi
  6cf299:	cmp    %rdi,%rdx
  6cf29c:	setg   %dl
  6cf29f:	movdqa %xmm2,%xmm4
  6cf2a3:	punpckhqdq %xmm2,%xmm4
  6cf2a7:	movq   %xmm4,%r8
  6cf2ac:	and    %rsi,%r8
  6cf2af:	cmp    %rdi,%r8
  6cf2b2:	movaps %xmm0,%xmm4
  6cf2b5:	shufps $0xdd,%xmm3,%xmm4
  6cf2b9:	andps  -0x68a980(%rip),%xmm4        # 44940 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0xad0>
  6cf2c0:	setg   %sil
  6cf2c4:	pcmpgtd -0x68ab1c(%rip),%xmm4        # 447b0 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0x940>
  6cf2cc:	movmskps %xmm4,%edi
  6cf2cf:	test   %edi,%edi
  6cf2d1:	setne  %dil
  6cf2d5:	or     %dl,%sil
  6cf2d8:	or     %dil,%sil
  6cf2db:	je     6cf2e5 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf5>
  6cf2dd:	mov    $0x2,%edx
  6cf2e2:	mov    %edx,(%rax)
  6cf2e4:	ret
  6cf2e5:	xor    %edx,%edx
  6cf2e7:	xorps  %xmm4,%xmm4
  6cf2ea:	ucomiss %xmm4,%xmm5
  6cf2ed:	jne    6cf2f1 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x101>
  6cf2ef:	jnp    6cf2e2 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf2>
  6cf2f1:	movaps %xmm5,%xmm6
  6cf2f4:	shufps $0x55,%xmm5,%xmm6
  6cf2f8:	ucomiss %xmm4,%xmm6
  6cf2fb:	jne    6cf2ff <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x10f>
  6cf2fd:	jnp    6cf2e2 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf2>
  6cf2ff:	movaps %xmm3,%xmm4
  6cf302:	shufps $0x4e,%xmm3,%xmm4
  6cf306:	mulpd  %xmm0,%xmm4
  6cf30a:	movapd %xmm4,%xmm6
  6cf30e:	unpckhpd %xmm4,%xmm6
  6cf312:	subsd  %xmm6,%xmm4
  6cf316:	xorpd  %xmm6,%xmm6
  6cf31a:	ucomisd %xmm6,%xmm4
  6cf31e:	jne    6cf322 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x132>
  6cf320:	jnp    6cf2e2 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf2>
  6cf322:	cvtps2pd %xmm1,%xmm4
  6cf325:	cvtps2pd %xmm5,%xmm7
  6cf328:	addpd  %xmm4,%xmm7
  6cf32c:	movapd %xmm4,%xmm1
  6cf330:	unpckhpd %xmm4,%xmm1
  6cf334:	movapd %xmm7,%xmm5
  6cf338:	unpckhpd %xmm7,%xmm5
  6cf33c:	test   %cl,%cl
  6cf33e:	je     6cf470 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x280>
  6cf344:	movapd %xmm7,%xmm8
  6cf349:	mulsd  %xmm0,%xmm8
  6cf34e:	movapd %xmm0,%xmm6
  6cf352:	mulsd  %xmm4,%xmm6
  6cf356:	mulsd  %xmm3,%xmm1
  6cf35a:	unpckhpd %xmm3,%xmm0
  6cf35e:	mulpd  %xmm0,%xmm4
  6cf362:	mulsd  %xmm3,%xmm5
  6cf366:	mulpd  %xmm7,%xmm0
  6cf36a:	unpcklpd %xmm4,%xmm6
  6cf36e:	movsd  %xmm1,%xmm4
  6cf372:	movapd %xmm6,%xmm1
  6cf376:	addpd  %xmm4,%xmm1
  6cf37a:	addpd  %xmm2,%xmm1
  6cf37e:	movapd %xmm1,%xmm3
  6cf382:	maxpd  -0x68a7ca(%rip),%xmm3        # 44bc0 <anon.1439d869536c372ac9ae5e9c2ae7b1d4.3.llvm.11976426317328370097+0x120>
  6cf38a:	unpcklpd %xmm0,%xmm8
  6cf38f:	addpd  %xmm8,%xmm4
  6cf394:	addpd  %xmm2,%xmm4
  6cf398:	movapd %xmm3,%xmm7
  6cf39c:	maxpd  %xmm4,%xmm7
  6cf3a0:	movapd %xmm7,%xmm9
  6cf3a5:	cmpunordpd %xmm7,%xmm9
  6cf3ab:	andpd  %xmm9,%xmm3
  6cf3b0:	andnpd %xmm7,%xmm9
  6cf3b5:	orpd   %xmm3,%xmm9
  6cf3ba:	movsd  %xmm5,%xmm0
  6cf3be:	addpd  %xmm0,%xmm6
  6cf3c2:	addpd  %xmm2,%xmm6
  6cf3c6:	movapd %xmm9,%xmm3
  6cf3cb:	maxpd  %xmm6,%xmm3
  6cf3cf:	movapd %xmm3,%xmm5
  6cf3d3:	cmpunordpd %xmm3,%xmm5
  6cf3d8:	andpd  %xmm5,%xmm9
  6cf3dd:	andnpd %xmm3,%xmm5
  6cf3e1:	orpd   %xmm9,%xmm5
  6cf3e6:	addpd  %xmm8,%xmm0
  6cf3eb:	addpd  %xmm2,%xmm0
  6cf3ef:	minpd  -0x68a797(%rip),%xmm1        # 44c60 <anon.1439d869536c372ac9ae5e9c2ae7b1d4.3.llvm.11976426317328370097+0x1c0>
  6cf3f7:	movapd %xmm1,%xmm2
  6cf3fb:	minpd  %xmm4,%xmm2
  6cf3ff:	movapd %xmm2,%xmm3
  6cf403:	cmpunordpd %xmm2,%xmm3
  6cf408:	andpd  %xmm3,%xmm1
  6cf40c:	andnpd %xmm2,%xmm3
  6cf410:	orpd   %xmm1,%xmm3
  6cf414:	movapd %xmm3,%xmm1
  6cf418:	minpd  %xmm6,%xmm1
  6cf41c:	movapd %xmm1,%xmm2
  6cf420:	cmpunordpd %xmm1,%xmm2
  6cf425:	andpd  %xmm2,%xmm3
  6cf429:	andnpd %xmm1,%xmm2
  6cf42d:	orpd   %xmm3,%xmm2
  6cf431:	movapd %xmm2,%xmm1
  6cf435:	minpd  %xmm0,%xmm1
  6cf439:	movapd %xmm1,%xmm3
  6cf43d:	cmpunordpd %xmm1,%xmm3
  6cf442:	andpd  %xmm3,%xmm2
  6cf446:	andnpd %xmm1,%xmm3
  6cf44a:	orpd   %xmm2,%xmm3
  6cf44e:	movapd %xmm5,%xmm2
  6cf452:	maxpd  %xmm0,%xmm2
  6cf456:	movapd %xmm2,%xmm1
  6cf45a:	cmpunordpd %xmm2,%xmm1
  6cf45f:	andpd  %xmm1,%xmm5
  6cf463:	andnpd %xmm2,%xmm1
  6cf467:	orpd   %xmm5,%xmm1
  6cf46b:	jmp    6cf504 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x314>
  6cf470:	xorpd  %xmm8,%xmm8
  6cf475:	movapd %xmm0,%xmm9
  6cf47a:	cmpltpd %xmm8,%xmm9
  6cf480:	movapd %xmm3,%xmm6
  6cf484:	cmpltpd %xmm8,%xmm6
  6cf48a:	unpcklpd %xmm4,%xmm4
  6cf48e:	unpcklpd %xmm7,%xmm7
  6cf492:	movapd %xmm9,%xmm8
  6cf497:	andnpd %xmm7,%xmm8
  6cf49c:	movapd %xmm9,%xmm10
  6cf4a1:	andnpd %xmm4,%xmm10
  6cf4a6:	andpd  %xmm9,%xmm4
  6cf4ab:	orpd   %xmm8,%xmm4
  6cf4b0:	andpd  %xmm9,%xmm7
  6cf4b5:	orpd   %xmm10,%xmm7
  6cf4ba:	movapd %xmm6,%xmm8
  6cf4bf:	andnpd %xmm5,%xmm8
  6cf4c4:	movapd %xmm6,%xmm9
  6cf4c9:	andnpd %xmm1,%xmm9
  6cf4ce:	andpd  %xmm6,%xmm1
  6cf4d2:	orpd   %xmm8,%xmm1
  6cf4d7:	andpd  %xmm5,%xmm6
  6cf4db:	orpd   %xmm9,%xmm6
  6cf4e0:	mulpd  %xmm0,%xmm7
  6cf4e4:	mulpd  %xmm0,%xmm4
  6cf4e8:	mulpd  %xmm3,%xmm6
  6cf4ec:	addpd  %xmm7,%xmm6
  6cf4f0:	mulpd  %xmm3,%xmm1
  6cf4f4:	addpd  %xmm4,%xmm1
  6cf4f8:	movapd %xmm2,%xmm3
  6cf4fc:	addpd  %xmm6,%xmm3
  6cf500:	addpd  %xmm2,%xmm1
  6cf504:	xorps  %xmm0,%xmm0
  6cf507:	cvtsd2ss %xmm3,%xmm0
  6cf50b:	movd   %xmm0,%ecx
  6cf50f:	ucomiss %xmm0,%xmm0
  6cf512:	setp   %dl
  6cf515:	cmp    $0xff800000,%ecx
  6cf51b:	sete   %sil
  6cf51f:	or     %dl,%sil
  6cf522:	jne    6cf543 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x353>
  6cf524:	mov    %ecx,%edx
  6cf526:	and    $0x7fffffff,%edx
  6cf52c:	je     6cf536 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x346>
  6cf52e:	cmp    %edx,%ecx
  6cf530:	jne    6cf53d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x34d>
  6cf532:	dec    %ecx
  6cf534:	jmp    6cf53f <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x34f>
  6cf536:	mov    $0x80000001,%ecx
  6cf53b:	jmp    6cf53f <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x34f>
  6cf53d:	inc    %ecx
  6cf53f:	movd   %ecx,%xmm0
  6cf543:	movhlps %xmm3,%xmm3
  6cf546:	xorps  %xmm2,%xmm2
  6cf549:	cvtsd2ss %xmm3,%xmm2
  6cf54d:	movd   %xmm2,%ecx
  6cf551:	ucomiss %xmm2,%xmm2
  6cf554:	setp   %dl
  6cf557:	cmp    $0xff800000,%ecx
  6cf55d:	sete   %sil
  6cf561:	or     %dl,%sil
  6cf564:	jne    6cf583 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x393>
  6cf566:	movd   %xmm2,%edx
  6cf56a:	and    $0x7fffffff,%edx
  6cf570:	je     6cf57a <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x38a>
  6cf572:	cmp    %edx,%ecx
  6cf574:	jne    6cf581 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x391>
  6cf576:	dec    %ecx
  6cf578:	jmp    6cf583 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x393>
  6cf57a:	mov    $0x80000001,%ecx
  6cf57f:	jmp    6cf583 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x393>
  6cf581:	inc    %ecx
  6cf583:	xorps  %xmm2,%xmm2
  6cf586:	cvtsd2ss %xmm1,%xmm2
  6cf58a:	movd   %xmm2,%edx
  6cf58e:	ucomiss %xmm2,%xmm2
  6cf591:	setp   %sil
  6cf595:	cmp    $0x7f800000,%edx
  6cf59b:	sete   %dil
  6cf59f:	or     %sil,%dil
  6cf5a2:	jne    6cf5c3 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3d3>
  6cf5a4:	mov    %edx,%esi
  6cf5a6:	and    $0x7fffffff,%esi
  6cf5ac:	je     6cf5b6 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3c6>
  6cf5ae:	cmp    %esi,%edx
  6cf5b0:	jne    6cf5bd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3cd>
  6cf5b2:	inc    %edx
  6cf5b4:	jmp    6cf5bf <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3cf>
  6cf5b6:	mov    $0x1,%edx
  6cf5bb:	jmp    6cf5bf <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3cf>
  6cf5bd:	dec    %edx
  6cf5bf:	movd   %edx,%xmm2
  6cf5c3:	movhlps %xmm1,%xmm1
  6cf5c6:	cvtsd2ss %xmm1,%xmm1
  6cf5ca:	movd   %xmm1,%edx
  6cf5ce:	ucomiss %xmm1,%xmm1
  6cf5d1:	setp   %sil
  6cf5d5:	cmp    $0x7f800000,%edx
  6cf5db:	sete   %dil
  6cf5df:	or     %sil,%dil
  6cf5e2:	jne    6cf601 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x411>
  6cf5e4:	movd   %xmm1,%esi
  6cf5e8:	and    $0x7fffffff,%esi
  6cf5ee:	je     6cf5f8 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x408>
  6cf5f0:	cmp    %esi,%edx
  6cf5f2:	jne    6cf5ff <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x40f>
  6cf5f4:	inc    %edx
  6cf5f6:	jmp    6cf601 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x411>
  6cf5f8:	mov    $0x1,%edx
  6cf5fd:	jmp    6cf601 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x411>
  6cf5ff:	dec    %edx
  6cf601:	movd   %ecx,%xmm3
  6cf605:	movd   %edx,%xmm1
  6cf609:	subss  %xmm0,%xmm2
  6cf60d:	movd   %xmm2,%edx
  6cf611:	ucomiss %xmm2,%xmm2
  6cf614:	setp   %sil
  6cf618:	cmp    $0x7f800000,%edx
  6cf61e:	sete   %dil
  6cf622:	or     %sil,%dil
  6cf625:	jne    6cf646 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x456>
  6cf627:	mov    %edx,%esi
  6cf629:	and    $0x7fffffff,%esi
  6cf62f:	je     6cf639 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x449>
  6cf631:	cmp    %esi,%edx
  6cf633:	jne    6cf640 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x450>
  6cf635:	inc    %edx
  6cf637:	jmp    6cf642 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x452>
  6cf639:	mov    $0x1,%edx
  6cf63e:	jmp    6cf642 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x452>
  6cf640:	dec    %edx
  6cf642:	movd   %edx,%xmm2
  6cf646:	subss  %xmm3,%xmm1
  6cf64a:	movd   %xmm1,%edx
  6cf64e:	ucomiss %xmm1,%xmm1
  6cf651:	setp   %sil
  6cf655:	cmp    $0x7f800000,%edx
  6cf65b:	sete   %dil
  6cf65f:	or     %sil,%dil
  6cf662:	jne    6cf683 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x493>
  6cf664:	mov    %edx,%esi
  6cf666:	and    $0x7fffffff,%esi
  6cf66c:	je     6cf676 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x486>
  6cf66e:	cmp    %esi,%edx
  6cf670:	jne    6cf67d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x48d>
  6cf672:	inc    %edx
  6cf674:	jmp    6cf67f <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x48f>
  6cf676:	mov    $0x1,%edx
  6cf67b:	jmp    6cf67f <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x48f>
  6cf67d:	dec    %edx
  6cf67f:	movd   %edx,%xmm1
  6cf683:	movaps %xmm0,%xmm4
  6cf686:	addss  %xmm2,%xmm4
  6cf68a:	movd   %xmm4,%edx
  6cf68e:	movaps %xmm1,%xmm4
  6cf691:	addss  %xmm3,%xmm4
  6cf695:	movd   %xmm4,%esi
  6cf699:	movdqa %xmm2,%xmm4
  6cf69d:	punpckldq %xmm1,%xmm4
  6cf6a1:	movdqa %xmm0,%xmm5
  6cf6a5:	punpckldq %xmm3,%xmm5
  6cf6a9:	punpcklqdq %xmm4,%xmm5
  6cf6ad:	and    $0x7fffffff,%edx
  6cf6b3:	cmp    $0x7f800000,%edx
  6cf6b9:	setl   %dl
  6cf6bc:	and    $0x7fffffff,%esi
  6cf6c2:	cmp    $0x7f800000,%esi
  6cf6c8:	setl   %sil
  6cf6cc:	pand   -0x68ad94(%rip),%xmm5        # 44940 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0xad0>
  6cf6d4:	pcmpgtd -0x68b77c(%rip),%xmm5        # 43f60 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0xf0>
  6cf6dc:	movmskps %xmm5,%edi
  6cf6df:	test   %edi,%edi
  6cf6e1:	jne    6cf2dd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xed>
  6cf6e7:	test   %dl,%dl
  6cf6e9:	je     6cf2dd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xed>
  6cf6ef:	test   %sil,%sil
  6cf6f2:	je     6cf2dd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xed>
  6cf6f8:	xorps  %xmm3,%xmm3
  6cf6fb:	ucomiss %xmm3,%xmm2
  6cf6fe:	jb     6cf2dd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xed>
  6cf704:	ucomiss %xmm3,%xmm1
  6cf707:	mov    $0x2,%edx
  6cf70c:	jb     6cf2e2 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf2>
  6cf712:	movss  %xmm0,0x4(%rax)
  6cf717:	mov    %ecx,0x8(%rax)
  6cf71a:	movss  %xmm2,0xc(%rax)
  6cf71f:	movss  %xmm1,0x10(%rax)
  6cf724:	mov    $0x1,%edx
  6cf729:	mov    %edx,(%rax)
  6cf72b:	ret


/tmp/gpui-bounds-provenance-candidate-gpui-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000004e9fa0 <bounds_provenance_gpui_consumer::inspect>:
  4e9fa0:	push   %rbp
  4e9fa1:	push   %r15
  4e9fa3:	push   %r14
  4e9fa5:	push   %r13
  4e9fa7:	push   %r12
  4e9fa9:	push   %rbx
  4e9faa:	sub    $0x98,%rsp
  4e9fb1:	test   %rdi,%rdi
  4e9fb4:	je     4ea0cc <bounds_provenance_gpui_consumer::inspect+0x12c>
  4e9fba:	cmpb   $0x0,0x94e(%rdi)
  4e9fc1:	jne    4ea0d3 <bounds_provenance_gpui_consumer::inspect+0x133>
  4e9fc7:	cmpb   $0x1,0x94c(%rdi)
  4e9fce:	jne    4ea0da <bounds_provenance_gpui_consumer::inspect+0x13a>
  4e9fd4:	lea    0x780(%rdi),%rcx
  4e9fdb:	mov    0x748(%rdi),%rbx
  4e9fe2:	mov    0x800(%rdi),%rdx
  4e9fe9:	lea    0x18(%rdx),%rax
  4e9fed:	test   %rdx,%rdx
  4e9ff0:	cmovne %rax,%rdx
  4e9ff4:	mov    0x750(%rdi),%rax
  4e9ffb:	mov    %rcx,0x28(%rsp)
  4ea000:	mov    %rbx,0x30(%rsp)
  4ea005:	mov    %rax,0x38(%rsp)
  4ea00a:	movups 0x7d8(%rdi),%xmm0
  4ea011:	movups %xmm0,0x40(%rsp)
  4ea016:	mov    %rdx,0x50(%rsp)
  4ea01b:	test   %rax,%rax
  4ea01e:	je     4ea0b4 <bounds_provenance_gpui_consumer::inspect+0x114>
  4ea024:	shl    $0x4,%rax
  4ea028:	lea    (%rax,%rax,4),%r13
  4ea02c:	lea    0x84(%rsp),%r15
  4ea034:	xor    %r14d,%r14d
  4ea037:	lea    0x58(%rsp),%r12
  4ea03c:	nopl   0x0(%rax)
  4ea040:	movss  0x30(%rbx),%xmm0
  4ea045:	movss  %xmm0,0xc(%rsp)
  4ea04b:	ucomiss %xmm0,%xmm0
  4ea04e:	mov    $0x0,%ebp
  4ea053:	jp     4ea06a <bounds_provenance_gpui_consumer::inspect+0xca>
  4ea055:	mov    0x44(%rbx),%eax
  4ea058:	mov    %eax,0x20(%rsp)
  4ea05c:	movups 0x34(%rbx),%xmm0
  4ea060:	movaps %xmm0,0x10(%rsp)
  4ea065:	mov    $0x1,%ebp
  4ea06a:	mov    %r15,%rdi
  4ea06d:	mov    %rbx,%rsi
  4ea070:	lea    0x28(%rsp),%rdx
  4ea075:	call   *0x2b1e0d(%rip)        # 79be88 <_DYNAMIC+0x2a0>
  4ea07b:	mov    %ebp,0x58(%rsp)
  4ea07f:	movss  0xc(%rsp),%xmm0
  4ea085:	movss  %xmm0,0x5c(%rsp)
  4ea08b:	mov    0x20(%rsp),%eax
  4ea08f:	mov    %eax,-0x14(%r15)
  4ea093:	movaps 0x10(%rsp),%xmm0
  4ea098:	movups %xmm0,-0x24(%r15)
  4ea09d:	movups (%rbx),%xmm0
  4ea0a0:	movups %xmm0,-0x10(%r15)
  4ea0a5:	inc    %r14
  4ea0a8:	add    $0x50,%rbx
  4ea0ac:	add    $0xffffffffffffffb0,%r13
  4ea0b0:	jne    4ea040 <bounds_provenance_gpui_consumer::inspect+0xa0>
  4ea0b2:	jmp    4ea0b7 <bounds_provenance_gpui_consumer::inspect+0x117>
  4ea0b4:	xor    %r14d,%r14d
  4ea0b7:	mov    %r14,%rax
  4ea0ba:	add    $0x98,%rsp
  4ea0c1:	pop    %rbx
  4ea0c2:	pop    %r12
  4ea0c4:	pop    %r13
  4ea0c6:	pop    %r14
  4ea0c8:	pop    %r15
  4ea0ca:	pop    %rbp
  4ea0cb:	ret
  4ea0cc:	mov    $0xd,%eax
  4ea0d1:	jmp    4ea0df <bounds_provenance_gpui_consumer::inspect+0x13f>
  4ea0d3:	mov    $0xe,%eax
  4ea0d8:	jmp    4ea0df <bounds_provenance_gpui_consumer::inspect+0x13f>
  4ea0da:	mov    $0x12,%eax
  4ea0df:	mov    %rax,0x58(%rsp)
  4ea0e4:	lea    -0x4a46e7(%rip),%rdi        # 45a04 <anon.6012f703f76728adc1ab0e9d1e27dcb4.113.llvm.4097891651611014805+0x3b4>
  4ea0eb:	lea    0x2917a6(%rip),%rcx        # 77b898 <anon.b19500d6d483e81e50c6c67b5010dbab.0.llvm.3008269221206016888+0x1f0>
  4ea0f2:	lea    0x291787(%rip),%r8        # 77b880 <anon.b19500d6d483e81e50c6c67b5010dbab.0.llvm.3008269221206016888+0x1d8>
  4ea0f9:	lea    0x58(%rsp),%rdx
  4ea0fe:	mov    $0x2b,%esi
  4ea103:	call   *0x2b1e07(%rip)        # 79bf10 <_DYNAMIC+0x328>
  4ea109:	ud2
  4ea10b:	mov    %rax,%rbx
  4ea10e:	lea    0x58(%rsp),%rdi
  4ea113:	call   4e90b0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  4ea118:	mov    %rbx,%rdi
  4ea11b:	call   779ac0 <_Unwind_Resume@plt>


/tmp/gpui-bounds-provenance-candidate-gpui-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000004ecb30 <<gpui::runtime::query::Part>::unclipped_bounds>:
  4ecb30:	push   %rbx
  4ecb31:	sub    $0x50,%rsp
  4ecb35:	mov    %rdi,%rbx
  4ecb38:	movss  0x30(%rsi),%xmm0
  4ecb3d:	ucomiss %xmm0,%xmm0
  4ecb40:	jp     4ecb8a <<gpui::runtime::query::Part>::unclipped_bounds+0x5a>
  4ecb42:	movss  0x34(%rsi),%xmm1
  4ecb47:	unpcklps %xmm1,%xmm0
  4ecb4a:	cvtps2pd %xmm0,%xmm0
  4ecb4d:	cvtps2pd 0x38(%rsi),%xmm1
  4ecb51:	movaps %xmm0,0x10(%rsp)
  4ecb56:	movaps %xmm1,0x20(%rsp)
  4ecb5b:	cvtps2pd 0x40(%rsi),%xmm0
  4ecb5f:	movaps %xmm0,0x30(%rsp)
  4ecb64:	movb   $0x0,0x40(%rsp)
  4ecb69:	movups (%rsi),%xmm0
  4ecb6c:	movaps %xmm0,(%rsp)
  4ecb70:	lea    0x10(%rsp),%rsi
  4ecb75:	mov    %rsp,%rdx
  4ecb78:	mov    %rbx,%rdi
  4ecb7b:	call   *0x2af44f(%rip)        # 79bfd0 <_DYNAMIC+0x3e8>
  4ecb81:	mov    %rbx,%rax
  4ecb84:	add    $0x50,%rsp
  4ecb88:	pop    %rbx
  4ecb89:	ret
  4ecb8a:	movl   $0x0,(%rbx)
  4ecb90:	mov    %rbx,%rax
  4ecb93:	add    $0x50,%rsp
  4ecb97:	pop    %rbx
  4ecb98:	ret
