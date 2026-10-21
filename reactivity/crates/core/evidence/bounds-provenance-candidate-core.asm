
/tmp/gpui-bounds-provenance-candidate-consumer:     file format elf64-x86-64


Disassembly of section .text:

0000000000015f50 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds>:
   15f50:	mov    %rdi,%rax
   15f53:	movups (%rdx),%xmm1
   15f56:	movaps %xmm1,%xmm2
   15f59:	unpckhpd %xmm1,%xmm2
   15f5d:	movaps %xmm1,%xmm0
   15f60:	addps  %xmm2,%xmm0
   15f63:	movaps -0x10eea(%rip),%xmm3        # 5080 <__abi_tag+0x4d4c>
   15f6a:	movaps %xmm1,%xmm4
   15f6d:	andps  %xmm3,%xmm4
   15f70:	movaps %xmm1,%xmm5
   15f73:	movlps -0x1107a(%rip),%xmm5        # 4f00 <__abi_tag+0x4bcc>
   15f7a:	andps  %xmm3,%xmm0
   15f7d:	movaps -0x10fb4(%rip),%xmm3        # 4fd0 <__abi_tag+0x4c9c>
   15f84:	movq   %xmm0,%xmm0
   15f88:	movaps %xmm3,%xmm6
   15f8b:	cmpneqps %xmm4,%xmm6
   15f8f:	cmpordps %xmm3,%xmm4
   15f93:	andps  %xmm6,%xmm4
   15f96:	movaps %xmm5,%xmm3
   15f99:	cmpneqps %xmm0,%xmm3
   15f9d:	movaps %xmm5,%xmm6
   15fa0:	cmpordps %xmm0,%xmm6
   15fa4:	andps  %xmm3,%xmm6
   15fa7:	packssdw %xmm6,%xmm4
   15fab:	cmpleps %xmm5,%xmm0
   15faf:	pshufhw $0x84,%xmm0,%xmm0
   15fb4:	shufps $0x23,%xmm4,%xmm0
   15fb8:	shufps $0x24,%xmm0,%xmm4
   15fbc:	packsswb %xmm4,%xmm4
   15fc0:	pmovmskb %xmm4,%ecx
   15fc4:	cmp    $0xff,%cl
   15fc7:	jne    1603e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   15fc9:	movzbl 0x30(%rsi),%ecx
   15fcd:	cmp    $0x2,%cl
   15fd0:	je     1603e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   15fd2:	movups (%rsi),%xmm4
   15fd5:	movups 0x10(%rsi),%xmm3
   15fd9:	movdqu 0x20(%rsi),%xmm0
   15fde:	movq   %xmm0,%rdx
   15fe3:	movabs $0x7fffffffffffffff,%rsi
   15fed:	and    %rsi,%rdx
   15ff0:	movabs $0x7fefffffffffffff,%rdi
   15ffa:	cmp    %rdi,%rdx
   15ffd:	setg   %dl
   16000:	movdqa %xmm0,%xmm5
   16004:	punpckhqdq %xmm0,%xmm5
   16008:	movq   %xmm5,%r8
   1600d:	and    %rsi,%r8
   16010:	cmp    %rdi,%r8
   16013:	movaps %xmm4,%xmm5
   16016:	shufps $0xdd,%xmm3,%xmm5
   1601a:	andps  -0x10fa1(%rip),%xmm5        # 5080 <__abi_tag+0x4d4c>
   16021:	setg   %sil
   16025:	pcmpgtd -0x1100d(%rip),%xmm5        # 5020 <__abi_tag+0x4cec>
   1602d:	movmskps %xmm5,%edi
   16030:	test   %edi,%edi
   16032:	setne  %dil
   16036:	or     %dl,%sil
   16039:	or     %dil,%sil
   1603c:	je     16046 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf6>
   1603e:	mov    $0x2,%edx
   16043:	mov    %edx,(%rax)
   16045:	ret
   16046:	xor    %edx,%edx
   16048:	xorps  %xmm5,%xmm5
   1604b:	ucomiss %xmm5,%xmm2
   1604e:	jne    16052 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x102>
   16050:	jnp    16043 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf3>
   16052:	movaps %xmm1,%xmm7
   16055:	shufps $0xff,%xmm1,%xmm7
   16059:	ucomiss %xmm5,%xmm7
   1605c:	jne    16060 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x110>
   1605e:	jnp    16043 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf3>
   16060:	movaps %xmm3,%xmm5
   16063:	shufps $0x4e,%xmm3,%xmm5
   16067:	mulpd  %xmm4,%xmm5
   1606b:	movapd %xmm5,%xmm6
   1606f:	unpckhpd %xmm5,%xmm6
   16073:	subsd  %xmm6,%xmm5
   16077:	xorpd  %xmm6,%xmm6
   1607b:	ucomisd %xmm6,%xmm5
   1607f:	jne    16083 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x133>
   16081:	jnp    16043 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf3>
   16083:	xorps  %xmm5,%xmm5
   16086:	cvtss2sd %xmm1,%xmm5
   1608a:	shufps $0x55,%xmm1,%xmm1
   1608e:	cvtss2sd %xmm1,%xmm1
   16092:	xorps  %xmm6,%xmm6
   16095:	cvtss2sd %xmm2,%xmm6
   16099:	addsd  %xmm5,%xmm6
   1609d:	cvtss2sd %xmm7,%xmm2
   160a1:	addsd  %xmm1,%xmm2
   160a5:	test   %cl,%cl
   160a7:	je     161c0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x270>
   160ad:	unpcklpd %xmm5,%xmm5
   160b1:	mulpd  %xmm4,%xmm5
   160b5:	unpcklpd %xmm1,%xmm1
   160b9:	mulpd  %xmm3,%xmm1
   160bd:	unpcklpd %xmm6,%xmm6
   160c1:	mulpd  %xmm4,%xmm6
   160c5:	unpcklpd %xmm2,%xmm2
   160c9:	mulpd  %xmm3,%xmm2
   160cd:	movapd %xmm5,%xmm3
   160d1:	addpd  %xmm1,%xmm3
   160d5:	addpd  %xmm0,%xmm3
   160d9:	movapd %xmm3,%xmm4
   160dd:	minpd  -0x10fe5(%rip),%xmm4        # 5100 <__abi_tag+0x4dcc>
   160e5:	addpd  %xmm6,%xmm1
   160e9:	addpd  %xmm0,%xmm1
   160ed:	movapd %xmm4,%xmm7
   160f1:	minpd  %xmm1,%xmm7
   160f5:	movapd %xmm7,%xmm8
   160fa:	cmpunordpd %xmm7,%xmm8
   16100:	andpd  %xmm8,%xmm4
   16105:	andnpd %xmm7,%xmm8
   1610a:	orpd   %xmm4,%xmm8
   1610f:	addpd  %xmm2,%xmm5
   16113:	addpd  %xmm0,%xmm5
   16117:	movapd %xmm8,%xmm7
   1611c:	minpd  %xmm5,%xmm7
   16120:	movapd %xmm7,%xmm4
   16124:	cmpunordpd %xmm7,%xmm4
   16129:	andpd  %xmm4,%xmm8
   1612e:	andnpd %xmm7,%xmm4
   16132:	orpd   %xmm8,%xmm4
   16137:	maxpd  -0x1106f(%rip),%xmm3        # 50d0 <__abi_tag+0x4d9c>
   1613f:	movapd %xmm3,%xmm7
   16143:	maxpd  %xmm1,%xmm7
   16147:	movapd %xmm7,%xmm1
   1614b:	cmpunordpd %xmm7,%xmm1
   16150:	andpd  %xmm1,%xmm3
   16154:	andnpd %xmm7,%xmm1
   16158:	orpd   %xmm3,%xmm1
   1615c:	movapd %xmm1,%xmm3
   16160:	maxpd  %xmm5,%xmm3
   16164:	movapd %xmm3,%xmm5
   16168:	cmpunordpd %xmm3,%xmm5
   1616d:	andpd  %xmm5,%xmm1
   16171:	andnpd %xmm3,%xmm5
   16175:	orpd   %xmm1,%xmm5
   16179:	addpd  %xmm6,%xmm2
   1617d:	addpd  %xmm0,%xmm2
   16181:	movapd %xmm4,%xmm0
   16185:	minpd  %xmm2,%xmm0
   16189:	movapd %xmm0,%xmm3
   1618d:	cmpunordpd %xmm0,%xmm3
   16192:	andpd  %xmm3,%xmm4
   16196:	andnpd %xmm0,%xmm3
   1619a:	orpd   %xmm4,%xmm3
   1619e:	movapd %xmm5,%xmm0
   161a2:	maxpd  %xmm2,%xmm0
   161a6:	movapd %xmm0,%xmm1
   161aa:	cmpunordpd %xmm0,%xmm1
   161af:	andpd  %xmm1,%xmm5
   161b3:	andnpd %xmm0,%xmm1
   161b7:	orpd   %xmm5,%xmm1
   161bb:	jmp    1625c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x30c>
   161c0:	xorpd  %xmm9,%xmm9
   161c5:	movapd %xmm4,%xmm8
   161ca:	cmpltpd %xmm9,%xmm8
   161d0:	movapd %xmm3,%xmm7
   161d4:	cmpltpd %xmm9,%xmm7
   161da:	unpcklpd %xmm6,%xmm6
   161de:	unpcklpd %xmm5,%xmm5
   161e2:	movapd %xmm8,%xmm9
   161e7:	andnpd %xmm5,%xmm9
   161ec:	movapd %xmm8,%xmm10
   161f1:	andnpd %xmm6,%xmm10
   161f6:	andpd  %xmm8,%xmm6
   161fb:	orpd   %xmm9,%xmm6
   16200:	unpcklpd %xmm2,%xmm2
   16204:	unpcklpd %xmm1,%xmm1
   16208:	movapd %xmm7,%xmm9
   1620d:	andnpd %xmm1,%xmm9
   16212:	movapd %xmm7,%xmm11
   16217:	andnpd %xmm2,%xmm11
   1621c:	andpd  %xmm7,%xmm2
   16220:	orpd   %xmm9,%xmm2
   16225:	mulpd  %xmm4,%xmm6
   16229:	mulpd  %xmm3,%xmm2
   1622d:	addpd  %xmm6,%xmm2
   16231:	addpd  %xmm0,%xmm2
   16235:	andpd  %xmm8,%xmm5
   1623a:	orpd   %xmm10,%xmm5
   1623f:	andpd  %xmm7,%xmm1
   16243:	orpd   %xmm11,%xmm1
   16248:	mulpd  %xmm4,%xmm5
   1624c:	mulpd  %xmm3,%xmm1
   16250:	addpd  %xmm5,%xmm1
   16254:	addpd  %xmm0,%xmm1
   16258:	movapd %xmm2,%xmm3
   1625c:	xorps  %xmm0,%xmm0
   1625f:	cvtsd2ss %xmm3,%xmm0
   16263:	movd   %xmm0,%ecx
   16267:	ucomiss %xmm0,%xmm0
   1626a:	setp   %dl
   1626d:	cmp    $0xff800000,%ecx
   16273:	sete   %sil
   16277:	or     %dl,%sil
   1627a:	jne    1629b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x34b>
   1627c:	mov    %ecx,%edx
   1627e:	and    $0x7fffffff,%edx
   16284:	je     1628e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x33e>
   16286:	cmp    %edx,%ecx
   16288:	jne    16295 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x345>
   1628a:	dec    %ecx
   1628c:	jmp    16297 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x347>
   1628e:	mov    $0x80000001,%ecx
   16293:	jmp    16297 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x347>
   16295:	inc    %ecx
   16297:	movd   %ecx,%xmm0
   1629b:	movhlps %xmm3,%xmm3
   1629e:	xorps  %xmm2,%xmm2
   162a1:	cvtsd2ss %xmm3,%xmm2
   162a5:	movd   %xmm2,%ecx
   162a9:	ucomiss %xmm2,%xmm2
   162ac:	setp   %dl
   162af:	cmp    $0xff800000,%ecx
   162b5:	sete   %sil
   162b9:	or     %dl,%sil
   162bc:	jne    162dd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x38d>
   162be:	mov    %ecx,%edx
   162c0:	and    $0x7fffffff,%edx
   162c6:	je     162d0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x380>
   162c8:	cmp    %edx,%ecx
   162ca:	jne    162d7 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x387>
   162cc:	dec    %ecx
   162ce:	jmp    162d9 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x389>
   162d0:	mov    $0x80000001,%ecx
   162d5:	jmp    162d9 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x389>
   162d7:	inc    %ecx
   162d9:	movd   %ecx,%xmm2
   162dd:	xorps  %xmm3,%xmm3
   162e0:	cvtsd2ss %xmm1,%xmm3
   162e4:	movd   %xmm3,%ecx
   162e8:	ucomiss %xmm3,%xmm3
   162eb:	setp   %dl
   162ee:	cmp    $0x7f800000,%ecx
   162f4:	sete   %sil
   162f8:	or     %dl,%sil
   162fb:	jne    1631c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3cc>
   162fd:	mov    %ecx,%edx
   162ff:	and    $0x7fffffff,%edx
   16305:	je     1630f <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3bf>
   16307:	cmp    %edx,%ecx
   16309:	jne    16316 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3c6>
   1630b:	inc    %ecx
   1630d:	jmp    16318 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3c8>
   1630f:	mov    $0x1,%ecx
   16314:	jmp    16318 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3c8>
   16316:	dec    %ecx
   16318:	movd   %ecx,%xmm3
   1631c:	movhlps %xmm1,%xmm1
   1631f:	cvtsd2ss %xmm1,%xmm1
   16323:	movd   %xmm1,%ecx
   16327:	ucomiss %xmm1,%xmm1
   1632a:	setp   %dl
   1632d:	cmp    $0x7f800000,%ecx
   16333:	sete   %sil
   16337:	or     %dl,%sil
   1633a:	jne    1635b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x40b>
   1633c:	mov    %ecx,%edx
   1633e:	and    $0x7fffffff,%edx
   16344:	je     1634e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3fe>
   16346:	cmp    %edx,%ecx
   16348:	jne    16355 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x405>
   1634a:	inc    %ecx
   1634c:	jmp    16357 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x407>
   1634e:	mov    $0x1,%ecx
   16353:	jmp    16357 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x407>
   16355:	dec    %ecx
   16357:	movd   %ecx,%xmm1
   1635b:	subss  %xmm0,%xmm3
   1635f:	movd   %xmm3,%ecx
   16363:	ucomiss %xmm3,%xmm3
   16366:	setp   %dl
   16369:	cmp    $0x7f800000,%ecx
   1636f:	sete   %sil
   16373:	or     %dl,%sil
   16376:	jne    16397 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x447>
   16378:	mov    %ecx,%edx
   1637a:	and    $0x7fffffff,%edx
   16380:	je     1638a <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x43a>
   16382:	cmp    %edx,%ecx
   16384:	jne    16391 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x441>
   16386:	inc    %ecx
   16388:	jmp    16393 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x443>
   1638a:	mov    $0x1,%ecx
   1638f:	jmp    16393 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x443>
   16391:	dec    %ecx
   16393:	movd   %ecx,%xmm3
   16397:	subss  %xmm2,%xmm1
   1639b:	movd   %xmm1,%ecx
   1639f:	ucomiss %xmm1,%xmm1
   163a2:	setp   %dl
   163a5:	cmp    $0x7f800000,%ecx
   163ab:	sete   %sil
   163af:	or     %dl,%sil
   163b2:	jne    163d3 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x483>
   163b4:	mov    %ecx,%edx
   163b6:	and    $0x7fffffff,%edx
   163bc:	je     163c6 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x476>
   163be:	cmp    %edx,%ecx
   163c0:	jne    163cd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x47d>
   163c2:	inc    %ecx
   163c4:	jmp    163cf <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x47f>
   163c6:	mov    $0x1,%ecx
   163cb:	jmp    163cf <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x47f>
   163cd:	dec    %ecx
   163cf:	movd   %ecx,%xmm1
   163d3:	movaps %xmm0,%xmm4
   163d6:	addss  %xmm3,%xmm4
   163da:	movd   %xmm4,%ecx
   163de:	movaps %xmm2,%xmm4
   163e1:	addss  %xmm1,%xmm4
   163e5:	movd   %xmm4,%edx
   163e9:	movdqa %xmm3,%xmm4
   163ed:	punpckldq %xmm1,%xmm4
   163f1:	movdqa %xmm0,%xmm5
   163f5:	punpckldq %xmm2,%xmm5
   163f9:	punpcklqdq %xmm4,%xmm5
   163fd:	and    $0x7fffffff,%ecx
   16403:	cmp    $0x7f800000,%ecx
   16409:	setl   %cl
   1640c:	and    $0x7fffffff,%edx
   16412:	cmp    $0x7f800000,%edx
   16418:	setl   %dl
   1641b:	pand   -0x113a3(%rip),%xmm5        # 5080 <__abi_tag+0x4d4c>
   16423:	pcmpgtd -0x1153b(%rip),%xmm5        # 4ef0 <__abi_tag+0x4bbc>
   1642b:	movmskps %xmm5,%esi
   1642e:	test   %esi,%esi
   16430:	jne    1603e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   16436:	test   %cl,%cl
   16438:	je     1603e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   1643e:	test   %dl,%dl
   16440:	je     1603e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   16446:	pxor   %xmm4,%xmm4
   1644a:	ucomiss %xmm4,%xmm3
   1644d:	jb     1603e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   16453:	ucomiss %xmm4,%xmm1
   16456:	mov    $0x2,%edx
   1645b:	jb     16043 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf3>
   16461:	movss  %xmm0,0x4(%rax)
   16466:	movss  %xmm2,0x8(%rax)
   1646b:	movss  %xmm3,0xc(%rax)
   16470:	movss  %xmm1,0x10(%rax)
   16475:	mov    $0x1,%edx
   1647a:	mov    %edx,(%rax)
   1647c:	ret


/tmp/gpui-bounds-provenance-candidate-consumer:     file format elf64-x86-64


Disassembly of section .text:

0000000000015cf0 <bounds_provenance_consumer::inspect>:
   15cf0:	jmp    *0x42012(%rip)        # 57d08 <_DYNAMIC+0x2c8>
