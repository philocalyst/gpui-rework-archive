
/tmp/gpui-bounds-candidate-consumer:     file format elf64-x86-64


Disassembly of section .text:

0000000000015f40 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds>:
   15f40:	mov    %rdi,%rax
   15f43:	movups (%rdx),%xmm1
   15f46:	movaps %xmm1,%xmm2
   15f49:	unpckhpd %xmm1,%xmm2
   15f4d:	movaps %xmm1,%xmm0
   15f50:	addps  %xmm2,%xmm0
   15f53:	movaps -0x10eda(%rip),%xmm3        # 5080 <__abi_tag+0x4d4c>
   15f5a:	movaps %xmm1,%xmm4
   15f5d:	andps  %xmm3,%xmm4
   15f60:	movaps %xmm1,%xmm5
   15f63:	movlps -0x1106a(%rip),%xmm5        # 4f00 <__abi_tag+0x4bcc>
   15f6a:	andps  %xmm3,%xmm0
   15f6d:	movaps -0x10fa4(%rip),%xmm3        # 4fd0 <__abi_tag+0x4c9c>
   15f74:	movq   %xmm0,%xmm0
   15f78:	movaps %xmm3,%xmm6
   15f7b:	cmpneqps %xmm4,%xmm6
   15f7f:	cmpordps %xmm3,%xmm4
   15f83:	andps  %xmm6,%xmm4
   15f86:	movaps %xmm5,%xmm3
   15f89:	cmpneqps %xmm0,%xmm3
   15f8d:	movaps %xmm5,%xmm6
   15f90:	cmpordps %xmm0,%xmm6
   15f94:	andps  %xmm3,%xmm6
   15f97:	packssdw %xmm6,%xmm4
   15f9b:	cmpleps %xmm5,%xmm0
   15f9f:	pshufhw $0x84,%xmm0,%xmm0
   15fa4:	shufps $0x23,%xmm4,%xmm0
   15fa8:	shufps $0x24,%xmm0,%xmm4
   15fac:	packsswb %xmm4,%xmm4
   15fb0:	pmovmskb %xmm4,%ecx
   15fb4:	cmp    $0xff,%cl
   15fb7:	jne    16029 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe9>
   15fb9:	cmpb   $0x0,0x30(%rsi)
   15fbd:	jne    16029 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe9>
   15fbf:	movups (%rsi),%xmm4
   15fc2:	movups 0x10(%rsi),%xmm3
   15fc6:	movdqu 0x20(%rsi),%xmm0
   15fcb:	movq   %xmm0,%rcx
   15fd0:	movabs $0x7fffffffffffffff,%rdx
   15fda:	and    %rdx,%rcx
   15fdd:	movabs $0x7fefffffffffffff,%rsi
   15fe7:	cmp    %rsi,%rcx
   15fea:	setg   %cl
   15fed:	movdqa %xmm0,%xmm5
   15ff1:	punpckhqdq %xmm0,%xmm5
   15ff5:	movq   %xmm5,%rdi
   15ffa:	and    %rdx,%rdi
   15ffd:	cmp    %rsi,%rdi
   16000:	movaps %xmm4,%xmm5
   16003:	shufps $0xdd,%xmm3,%xmm5
   16007:	andps  -0x10f8e(%rip),%xmm5        # 5080 <__abi_tag+0x4d4c>
   1600e:	setg   %dl
   16011:	pcmpgtd -0x10ff9(%rip),%xmm5        # 5020 <__abi_tag+0x4cec>
   16019:	movmskps %xmm5,%esi
   1601c:	test   %esi,%esi
   1601e:	setne  %sil
   16022:	or     %cl,%dl
   16024:	or     %sil,%dl
   16027:	je     16031 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf1>
   16029:	mov    $0x2,%ecx
   1602e:	mov    %ecx,(%rax)
   16030:	ret
   16031:	xor    %ecx,%ecx
   16033:	xorps  %xmm5,%xmm5
   16036:	ucomiss %xmm5,%xmm2
   16039:	jne    1603d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xfd>
   1603b:	jnp    1602e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   1603d:	movaps %xmm1,%xmm8
   16041:	shufps $0xff,%xmm1,%xmm8
   16046:	ucomiss %xmm5,%xmm8
   1604a:	jne    1604e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x10e>
   1604c:	jnp    1602e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   1604e:	movaps %xmm3,%xmm5
   16051:	shufps $0x4e,%xmm3,%xmm5
   16055:	mulpd  %xmm4,%xmm5
   16059:	movapd %xmm5,%xmm6
   1605d:	unpckhpd %xmm5,%xmm6
   16061:	subsd  %xmm6,%xmm5
   16065:	xorpd  %xmm6,%xmm6
   16069:	ucomisd %xmm6,%xmm5
   1606d:	jne    16071 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x131>
   1606f:	jnp    1602e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   16071:	xorps  %xmm6,%xmm6
   16074:	cvtss2sd %xmm1,%xmm6
   16078:	shufps $0x55,%xmm1,%xmm1
   1607c:	cvtss2sd %xmm1,%xmm7
   16080:	xorps  %xmm5,%xmm5
   16083:	cvtss2sd %xmm2,%xmm5
   16087:	addsd  %xmm6,%xmm5
   1608b:	xorps  %xmm1,%xmm1
   1608e:	cvtss2sd %xmm8,%xmm1
   16093:	addsd  %xmm7,%xmm1
   16097:	xorps  %xmm8,%xmm8
   1609b:	movapd %xmm4,%xmm9
   160a0:	cmpltpd %xmm8,%xmm9
   160a6:	movaps %xmm3,%xmm2
   160a9:	cmpltpd %xmm8,%xmm2
   160af:	unpcklpd %xmm5,%xmm5
   160b3:	unpcklpd %xmm6,%xmm6
   160b7:	movapd %xmm5,%xmm8
   160bc:	andpd  %xmm9,%xmm8
   160c1:	movapd %xmm9,%xmm10
   160c6:	andnpd %xmm6,%xmm10
   160cb:	orpd   %xmm8,%xmm10
   160d0:	unpcklpd %xmm1,%xmm1
   160d4:	unpcklpd %xmm7,%xmm7
   160d8:	movapd %xmm1,%xmm11
   160dd:	andpd  %xmm2,%xmm11
   160e2:	movapd %xmm2,%xmm8
   160e7:	andnpd %xmm7,%xmm8
   160ec:	orpd   %xmm11,%xmm8
   160f1:	mulpd  %xmm4,%xmm10
   160f6:	mulpd  %xmm3,%xmm8
   160fb:	addpd  %xmm10,%xmm8
   16100:	addpd  %xmm0,%xmm8
   16105:	movapd %xmm6,%xmm10
   1610a:	andpd  %xmm9,%xmm10
   1610f:	andnpd %xmm5,%xmm9
   16114:	orpd   %xmm10,%xmm9
   16119:	movapd %xmm7,%xmm10
   1611e:	andpd  %xmm2,%xmm10
   16123:	andnpd %xmm1,%xmm2
   16127:	orpd   %xmm10,%xmm2
   1612c:	mulpd  %xmm4,%xmm9
   16131:	mulpd  %xmm3,%xmm2
   16135:	addpd  %xmm9,%xmm2
   1613a:	addpd  %xmm0,%xmm2
   1613e:	movapd %xmm8,%xmm9
   16143:	shufps $0xdd,%xmm2,%xmm9
   16148:	andps  -0x110d0(%rip),%xmm9        # 5080 <__abi_tag+0x4d4c>
   16150:	pcmpgtd -0x11139(%rip),%xmm9        # 5020 <__abi_tag+0x4cec>
   16159:	movmskps %xmm9,%ecx
   1615d:	test   %ecx,%ecx
   1615f:	je     16268 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x328>
   16165:	mulpd  %xmm4,%xmm6
   16169:	mulpd  %xmm3,%xmm7
   1616d:	mulpd  %xmm4,%xmm5
   16171:	mulpd  %xmm3,%xmm1
   16175:	movapd %xmm6,%xmm2
   16179:	addpd  %xmm7,%xmm2
   1617d:	addpd  %xmm0,%xmm2
   16181:	movapd %xmm2,%xmm3
   16185:	minpd  -0x1108d(%rip),%xmm3        # 5100 <__abi_tag+0x4dcc>
   1618d:	addpd  %xmm5,%xmm7
   16191:	addpd  %xmm0,%xmm7
   16195:	movapd %xmm3,%xmm4
   16199:	minpd  %xmm7,%xmm4
   1619d:	movapd %xmm4,%xmm8
   161a2:	cmpunordpd %xmm4,%xmm8
   161a8:	andpd  %xmm8,%xmm3
   161ad:	andnpd %xmm4,%xmm8
   161b2:	orpd   %xmm3,%xmm8
   161b7:	addpd  %xmm1,%xmm6
   161bb:	addpd  %xmm0,%xmm6
   161bf:	movapd %xmm8,%xmm4
   161c4:	minpd  %xmm6,%xmm4
   161c8:	movapd %xmm4,%xmm3
   161cc:	cmpunordpd %xmm4,%xmm3
   161d1:	andpd  %xmm3,%xmm8
   161d6:	andnpd %xmm4,%xmm3
   161da:	orpd   %xmm8,%xmm3
   161df:	maxpd  -0x11117(%rip),%xmm2        # 50d0 <__abi_tag+0x4d9c>
   161e7:	movapd %xmm2,%xmm4
   161eb:	maxpd  %xmm7,%xmm4
   161ef:	movapd %xmm4,%xmm7
   161f3:	cmpunordpd %xmm4,%xmm7
   161f8:	andpd  %xmm7,%xmm2
   161fc:	andnpd %xmm4,%xmm7
   16200:	orpd   %xmm2,%xmm7
   16204:	movapd %xmm7,%xmm2
   16208:	maxpd  %xmm6,%xmm2
   1620c:	movapd %xmm2,%xmm4
   16210:	cmpunordpd %xmm2,%xmm4
   16215:	andpd  %xmm4,%xmm7
   16219:	andnpd %xmm2,%xmm4
   1621d:	orpd   %xmm7,%xmm4
   16221:	addpd  %xmm5,%xmm1
   16225:	addpd  %xmm0,%xmm1
   16229:	movapd %xmm3,%xmm0
   1622d:	minpd  %xmm1,%xmm0
   16231:	movapd %xmm0,%xmm8
   16236:	cmpunordpd %xmm0,%xmm8
   1623c:	andpd  %xmm8,%xmm3
   16241:	andnpd %xmm0,%xmm8
   16246:	orpd   %xmm3,%xmm8
   1624b:	movapd %xmm4,%xmm0
   1624f:	maxpd  %xmm1,%xmm0
   16253:	movapd %xmm0,%xmm2
   16257:	cmpunordpd %xmm0,%xmm2
   1625c:	andpd  %xmm2,%xmm4
   16260:	andnpd %xmm0,%xmm2
   16264:	orpd   %xmm4,%xmm2
   16268:	xorps  %xmm0,%xmm0
   1626b:	cvtsd2ss %xmm8,%xmm0
   16270:	movd   %xmm0,%ecx
   16274:	ucomiss %xmm0,%xmm0
   16277:	setp   %dl
   1627a:	cmp    $0xff800000,%ecx
   16280:	sete   %sil
   16284:	or     %dl,%sil
   16287:	jne    162a8 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x368>
   16289:	mov    %ecx,%edx
   1628b:	and    $0x7fffffff,%edx
   16291:	je     1629b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x35b>
   16293:	cmp    %edx,%ecx
   16295:	jne    162a2 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x362>
   16297:	dec    %ecx
   16299:	jmp    162a4 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x364>
   1629b:	mov    $0x80000001,%ecx
   162a0:	jmp    162a4 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x364>
   162a2:	inc    %ecx
   162a4:	movd   %ecx,%xmm0
   162a8:	movhlps %xmm8,%xmm8
   162ac:	xorps  %xmm1,%xmm1
   162af:	cvtsd2ss %xmm8,%xmm1
   162b4:	movd   %xmm1,%ecx
   162b8:	ucomiss %xmm1,%xmm1
   162bb:	setp   %dl
   162be:	cmp    $0xff800000,%ecx
   162c4:	sete   %sil
   162c8:	or     %dl,%sil
   162cb:	jne    162ec <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3ac>
   162cd:	mov    %ecx,%edx
   162cf:	and    $0x7fffffff,%edx
   162d5:	je     162df <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x39f>
   162d7:	cmp    %edx,%ecx
   162d9:	jne    162e6 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3a6>
   162db:	dec    %ecx
   162dd:	jmp    162e8 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3a8>
   162df:	mov    $0x80000001,%ecx
   162e4:	jmp    162e8 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3a8>
   162e6:	inc    %ecx
   162e8:	movd   %ecx,%xmm1
   162ec:	xorps  %xmm3,%xmm3
   162ef:	cvtsd2ss %xmm2,%xmm3
   162f3:	movd   %xmm3,%ecx
   162f7:	ucomiss %xmm3,%xmm3
   162fa:	setp   %dl
   162fd:	cmp    $0x7f800000,%ecx
   16303:	sete   %sil
   16307:	or     %dl,%sil
   1630a:	jne    1632b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3eb>
   1630c:	mov    %ecx,%edx
   1630e:	and    $0x7fffffff,%edx
   16314:	je     1631e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3de>
   16316:	cmp    %edx,%ecx
   16318:	jne    16325 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3e5>
   1631a:	inc    %ecx
   1631c:	jmp    16327 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3e7>
   1631e:	mov    $0x1,%ecx
   16323:	jmp    16327 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3e7>
   16325:	dec    %ecx
   16327:	movd   %ecx,%xmm3
   1632b:	movhlps %xmm2,%xmm2
   1632e:	cvtsd2ss %xmm2,%xmm2
   16332:	movd   %xmm2,%ecx
   16336:	ucomiss %xmm2,%xmm2
   16339:	setp   %dl
   1633c:	cmp    $0x7f800000,%ecx
   16342:	sete   %sil
   16346:	or     %dl,%sil
   16349:	jne    1636a <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x42a>
   1634b:	mov    %ecx,%edx
   1634d:	and    $0x7fffffff,%edx
   16353:	je     1635d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x41d>
   16355:	cmp    %edx,%ecx
   16357:	jne    16364 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x424>
   16359:	inc    %ecx
   1635b:	jmp    16366 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x426>
   1635d:	mov    $0x1,%ecx
   16362:	jmp    16366 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x426>
   16364:	dec    %ecx
   16366:	movd   %ecx,%xmm2
   1636a:	subss  %xmm0,%xmm3
   1636e:	movd   %xmm3,%ecx
   16372:	ucomiss %xmm3,%xmm3
   16375:	setp   %dl
   16378:	cmp    $0x7f800000,%ecx
   1637e:	sete   %sil
   16382:	or     %dl,%sil
   16385:	jne    163a6 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x466>
   16387:	mov    %ecx,%edx
   16389:	and    $0x7fffffff,%edx
   1638f:	je     16399 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x459>
   16391:	cmp    %edx,%ecx
   16393:	jne    163a0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x460>
   16395:	inc    %ecx
   16397:	jmp    163a2 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x462>
   16399:	mov    $0x1,%ecx
   1639e:	jmp    163a2 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x462>
   163a0:	dec    %ecx
   163a2:	movd   %ecx,%xmm3
   163a6:	subss  %xmm1,%xmm2
   163aa:	movd   %xmm2,%ecx
   163ae:	ucomiss %xmm2,%xmm2
   163b1:	setp   %dl
   163b4:	cmp    $0x7f800000,%ecx
   163ba:	sete   %sil
   163be:	or     %dl,%sil
   163c1:	jne    163e2 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x4a2>
   163c3:	mov    %ecx,%edx
   163c5:	and    $0x7fffffff,%edx
   163cb:	je     163d5 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x495>
   163cd:	cmp    %edx,%ecx
   163cf:	jne    163dc <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x49c>
   163d1:	inc    %ecx
   163d3:	jmp    163de <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x49e>
   163d5:	mov    $0x1,%ecx
   163da:	jmp    163de <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x49e>
   163dc:	dec    %ecx
   163de:	movd   %ecx,%xmm2
   163e2:	movaps %xmm0,%xmm4
   163e5:	addss  %xmm3,%xmm4
   163e9:	movd   %xmm4,%ecx
   163ed:	movaps %xmm1,%xmm4
   163f0:	addss  %xmm2,%xmm4
   163f4:	movd   %xmm4,%edx
   163f8:	movdqa %xmm3,%xmm4
   163fc:	punpckldq %xmm2,%xmm4
   16400:	movdqa %xmm0,%xmm5
   16404:	punpckldq %xmm1,%xmm5
   16408:	punpcklqdq %xmm4,%xmm5
   1640c:	and    $0x7fffffff,%ecx
   16412:	cmp    $0x7f800000,%ecx
   16418:	setl   %cl
   1641b:	and    $0x7fffffff,%edx
   16421:	cmp    $0x7f800000,%edx
   16427:	setl   %dl
   1642a:	pand   -0x113b2(%rip),%xmm5        # 5080 <__abi_tag+0x4d4c>
   16432:	pcmpgtd -0x1154a(%rip),%xmm5        # 4ef0 <__abi_tag+0x4bbc>
   1643a:	movmskps %xmm5,%esi
   1643d:	test   %esi,%esi
   1643f:	jne    16029 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe9>
   16445:	test   %cl,%cl
   16447:	je     16029 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe9>
   1644d:	test   %dl,%dl
   1644f:	je     16029 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe9>
   16455:	pxor   %xmm4,%xmm4
   16459:	ucomiss %xmm4,%xmm3
   1645c:	jb     16029 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe9>
   16462:	ucomiss %xmm4,%xmm2
   16465:	mov    $0x2,%ecx
   1646a:	jb     1602e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   16470:	movss  %xmm0,0x4(%rax)
   16475:	movss  %xmm1,0x8(%rax)
   1647a:	movss  %xmm3,0xc(%rax)
   1647f:	movss  %xmm2,0x10(%rax)
   16484:	mov    $0x1,%ecx
   16489:	mov    %ecx,(%rax)
   1648b:	ret
