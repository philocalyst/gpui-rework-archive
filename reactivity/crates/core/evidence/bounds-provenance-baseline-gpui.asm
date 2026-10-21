
/tmp/gpui-bounds-provenance-baseline-gpui-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000006cf1e0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds>:
  6cf1e0:	mov    %rdi,%rax
  6cf1e3:	movsd  (%rdx),%xmm6
  6cf1e7:	movsd  0x8(%rdx),%xmm1
  6cf1ec:	movaps %xmm6,%xmm2
  6cf1ef:	addps  %xmm1,%xmm2
  6cf1f2:	movups (%rdx),%xmm0
  6cf1f5:	movaps -0x68a8bc(%rip),%xmm3        # 44940 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0xad0>
  6cf1fc:	andps  %xmm3,%xmm0
  6cf1ff:	andps  %xmm3,%xmm2
  6cf202:	movaps -0x68b169(%rip),%xmm3        # 440a0 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0x230>
  6cf209:	movlhps %xmm1,%xmm3
  6cf20c:	movaps -0x68acb3(%rip),%xmm4        # 44560 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0x6f0>
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
  6cf39c:	movsd  -0x689f4d(%rip),%xmm13        # 45458 <anon.6012f703f76728adc1ab0e9d1e27dcb4.281.llvm.4097891651611014805+0x68>
  6cf3a5:	movapd %xmm11,%xmm14
  6cf3aa:	minsd  %xmm13,%xmm14
  6cf3af:	movapd %xmm12,%xmm15
  6cf3b4:	minsd  %xmm13,%xmm15
  6cf3b9:	movsd  -0x689efa(%rip),%xmm13        # 454c8 <anon.6012f703f76728adc1ab0e9d1e27dcb4.164.llvm.4097891651611014805+0x38>
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
  6cf609:	pand   -0x68acd1(%rip),%xmm5        # 44940 <anon.6012f703f76728adc1ab0e9d1e27dcb4.391.llvm.4097891651611014805+0xad0>
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


/tmp/gpui-bounds-provenance-baseline-gpui-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000004e9f90 <bounds_provenance_gpui_consumer::inspect>:
  4e9f90:	push   %rbp
  4e9f91:	push   %r15
  4e9f93:	push   %r14
  4e9f95:	push   %r13
  4e9f97:	push   %r12
  4e9f99:	push   %rbx
  4e9f9a:	sub    $0x98,%rsp
  4e9fa1:	test   %rdi,%rdi
  4e9fa4:	je     4ea0bc <bounds_provenance_gpui_consumer::inspect+0x12c>
  4e9faa:	cmpb   $0x0,0x94e(%rdi)
  4e9fb1:	jne    4ea0c3 <bounds_provenance_gpui_consumer::inspect+0x133>
  4e9fb7:	cmpb   $0x1,0x94c(%rdi)
  4e9fbe:	jne    4ea0ca <bounds_provenance_gpui_consumer::inspect+0x13a>
  4e9fc4:	lea    0x780(%rdi),%rcx
  4e9fcb:	mov    0x748(%rdi),%rbx
  4e9fd2:	mov    0x800(%rdi),%rdx
  4e9fd9:	lea    0x18(%rdx),%rax
  4e9fdd:	test   %rdx,%rdx
  4e9fe0:	cmovne %rax,%rdx
  4e9fe4:	mov    0x750(%rdi),%rax
  4e9feb:	mov    %rcx,0x28(%rsp)
  4e9ff0:	mov    %rbx,0x30(%rsp)
  4e9ff5:	mov    %rax,0x38(%rsp)
  4e9ffa:	movups 0x7d8(%rdi),%xmm0
  4ea001:	movups %xmm0,0x40(%rsp)
  4ea006:	mov    %rdx,0x50(%rsp)
  4ea00b:	test   %rax,%rax
  4ea00e:	je     4ea0a4 <bounds_provenance_gpui_consumer::inspect+0x114>
  4ea014:	shl    $0x4,%rax
  4ea018:	lea    (%rax,%rax,4),%r13
  4ea01c:	lea    0x84(%rsp),%r15
  4ea024:	xor    %r14d,%r14d
  4ea027:	lea    0x58(%rsp),%r12
  4ea02c:	nopl   0x0(%rax)
  4ea030:	movss  0x30(%rbx),%xmm0
  4ea035:	movss  %xmm0,0xc(%rsp)
  4ea03b:	ucomiss %xmm0,%xmm0
  4ea03e:	mov    $0x0,%ebp
  4ea043:	jp     4ea05a <bounds_provenance_gpui_consumer::inspect+0xca>
  4ea045:	mov    0x44(%rbx),%eax
  4ea048:	mov    %eax,0x20(%rsp)
  4ea04c:	movups 0x34(%rbx),%xmm0
  4ea050:	movaps %xmm0,0x10(%rsp)
  4ea055:	mov    $0x1,%ebp
  4ea05a:	mov    %r15,%rdi
  4ea05d:	mov    %rbx,%rsi
  4ea060:	lea    0x28(%rsp),%rdx
  4ea065:	call   *0x2b1d3d(%rip)        # 79bda8 <_DYNAMIC+0x2a0>
  4ea06b:	mov    %ebp,0x58(%rsp)
  4ea06f:	movss  0xc(%rsp),%xmm0
  4ea075:	movss  %xmm0,0x5c(%rsp)
  4ea07b:	mov    0x20(%rsp),%eax
  4ea07f:	mov    %eax,-0x14(%r15)
  4ea083:	movaps 0x10(%rsp),%xmm0
  4ea088:	movups %xmm0,-0x24(%r15)
  4ea08d:	movups (%rbx),%xmm0
  4ea090:	movups %xmm0,-0x10(%r15)
  4ea095:	inc    %r14
  4ea098:	add    $0x50,%rbx
  4ea09c:	add    $0xffffffffffffffb0,%r13
  4ea0a0:	jne    4ea030 <bounds_provenance_gpui_consumer::inspect+0xa0>
  4ea0a2:	jmp    4ea0a7 <bounds_provenance_gpui_consumer::inspect+0x117>
  4ea0a4:	xor    %r14d,%r14d
  4ea0a7:	mov    %r14,%rax
  4ea0aa:	add    $0x98,%rsp
  4ea0b1:	pop    %rbx
  4ea0b2:	pop    %r12
  4ea0b4:	pop    %r13
  4ea0b6:	pop    %r14
  4ea0b8:	pop    %r15
  4ea0ba:	pop    %rbp
  4ea0bb:	ret
  4ea0bc:	mov    $0xd,%eax
  4ea0c1:	jmp    4ea0cf <bounds_provenance_gpui_consumer::inspect+0x13f>
  4ea0c3:	mov    $0xe,%eax
  4ea0c8:	jmp    4ea0cf <bounds_provenance_gpui_consumer::inspect+0x13f>
  4ea0ca:	mov    $0x12,%eax
  4ea0cf:	mov    %rax,0x58(%rsp)
  4ea0d4:	lea    -0x4a46e7(%rip),%rdi        # 459f4 <anon.6012f703f76728adc1ab0e9d1e27dcb4.113.llvm.4097891651611014805+0x3b4>
  4ea0db:	lea    0x2916d6(%rip),%rcx        # 77b7b8 <anon.b19500d6d483e81e50c6c67b5010dbab.0.llvm.3008269221206016888+0x1f0>
  4ea0e2:	lea    0x2916b7(%rip),%r8        # 77b7a0 <anon.b19500d6d483e81e50c6c67b5010dbab.0.llvm.3008269221206016888+0x1d8>
  4ea0e9:	lea    0x58(%rsp),%rdx
  4ea0ee:	mov    $0x2b,%esi
  4ea0f3:	call   *0x2b1d37(%rip)        # 79be30 <_DYNAMIC+0x328>
  4ea0f9:	ud2
  4ea0fb:	mov    %rax,%rbx
  4ea0fe:	lea    0x58(%rsp),%rdi
  4ea103:	call   4e90a0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  4ea108:	mov    %rbx,%rdi
  4ea10b:	call   7799e0 <_Unwind_Resume@plt>


/tmp/gpui-bounds-provenance-baseline-gpui-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000004ecb20 <<gpui::runtime::query::Part>::unclipped_bounds>:
  4ecb20:	push   %rbx
  4ecb21:	sub    $0x50,%rsp
  4ecb25:	mov    %rdi,%rbx
  4ecb28:	movss  0x30(%rsi),%xmm0
  4ecb2d:	ucomiss %xmm0,%xmm0
  4ecb30:	jp     4ecb7a <<gpui::runtime::query::Part>::unclipped_bounds+0x5a>
  4ecb32:	movss  0x34(%rsi),%xmm1
  4ecb37:	unpcklps %xmm1,%xmm0
  4ecb3a:	cvtps2pd %xmm0,%xmm0
  4ecb3d:	cvtps2pd 0x38(%rsi),%xmm1
  4ecb41:	movaps %xmm0,0x10(%rsp)
  4ecb46:	movaps %xmm1,0x20(%rsp)
  4ecb4b:	cvtps2pd 0x40(%rsi),%xmm0
  4ecb4f:	movaps %xmm0,0x30(%rsp)
  4ecb54:	movb   $0x0,0x40(%rsp)
  4ecb59:	movups (%rsi),%xmm0
  4ecb5c:	movaps %xmm0,(%rsp)
  4ecb60:	lea    0x10(%rsp),%rsi
  4ecb65:	mov    %rsp,%rdx
  4ecb68:	mov    %rbx,%rdi
  4ecb6b:	call   *0x2af37f(%rip)        # 79bef0 <_DYNAMIC+0x3e8>
  4ecb71:	mov    %rbx,%rax
  4ecb74:	add    $0x50,%rsp
  4ecb78:	pop    %rbx
  4ecb79:	ret
  4ecb7a:	movl   $0x0,(%rbx)
  4ecb80:	mov    %rbx,%rax
  4ecb83:	add    $0x50,%rsp
  4ecb87:	pop    %rbx
  4ecb88:	ret
