
/tmp/gpui-bounds-baseline-consumer:     file format elf64-x86-64


Disassembly of section .text:

0000000000015f30 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds>:
   15f30:	mov    %rdi,%rax
   15f33:	movsd  (%rdx),%xmm3
   15f37:	movsd  0x8(%rdx),%xmm1
   15f3c:	movaps %xmm3,%xmm2
   15f3f:	addps  %xmm1,%xmm2
   15f42:	movups (%rdx),%xmm0
   15f45:	movaps -0x10ecc(%rip),%xmm4        # 5080 <__abi_tag+0x4d4c>
   15f4c:	andps  %xmm4,%xmm0
   15f4f:	andps  %xmm4,%xmm2
   15f52:	movaps -0x11059(%rip),%xmm4        # 4f00 <__abi_tag+0x4bcc>
   15f59:	movlhps %xmm1,%xmm4
   15f5c:	movaps -0x10f93(%rip),%xmm5        # 4fd0 <__abi_tag+0x4c9c>
   15f63:	movq   %xmm2,%xmm2
   15f67:	movaps %xmm4,%xmm6
   15f6a:	cmpneqps %xmm2,%xmm6
   15f6e:	movaps %xmm4,%xmm7
   15f71:	cmpordps %xmm2,%xmm7
   15f75:	andps  %xmm6,%xmm7
   15f78:	movaps %xmm5,%xmm6
   15f7b:	cmpneqps %xmm0,%xmm6
   15f7f:	cmpordps %xmm5,%xmm0
   15f83:	andps  %xmm6,%xmm0
   15f86:	packssdw %xmm7,%xmm0
   15f8a:	cmpleps %xmm4,%xmm2
   15f8e:	pshufhw $0x84,%xmm2,%xmm2
   15f93:	shufps $0x23,%xmm0,%xmm2
   15f97:	shufps $0x24,%xmm2,%xmm0
   15f9b:	packsswb %xmm0,%xmm0
   15f9f:	pmovmskb %xmm0,%ecx
   15fa3:	cmp    $0xff,%cl
   15fa6:	jne    1604d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   15fac:	cmpb   $0x0,0x30(%rsi)
   15fb0:	jne    1604d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   15fb6:	movq   (%rsi),%xmm2
   15fba:	movq   0x8(%rsi),%xmm0
   15fbf:	movq   %xmm2,%rdx
   15fc4:	movq   %xmm0,%rdi
   15fc9:	movq   0x10(%rsi),%xmm5
   15fce:	movq   %xmm5,%r8
   15fd3:	movq   0x18(%rsi),%xmm7
   15fd8:	movq   %xmm7,%r9
   15fdd:	movq   0x20(%rsi),%xmm6
   15fe2:	movq   %xmm6,%r10
   15fe7:	movq   0x28(%rsi),%xmm4
   15fec:	movq   %xmm4,%rcx
   15ff1:	movabs $0x7fffffffffffffff,%rsi
   15ffb:	and    %rsi,%rdx
   15ffe:	movabs $0x7fefffffffffffff,%r11
   16008:	cmp    %r11,%rdx
   1600b:	setg   %dl
   1600e:	and    %rsi,%rdi
   16011:	cmp    %r11,%rdi
   16014:	setg   %dil
   16018:	or     %dl,%dil
   1601b:	and    %rsi,%r8
   1601e:	cmp    %r11,%r8
   16021:	setg   %dl
   16024:	and    %rsi,%r9
   16027:	cmp    %r11,%r9
   1602a:	setg   %r8b
   1602e:	or     %dl,%r8b
   16031:	or     %dil,%r8b
   16034:	and    %rsi,%r10
   16037:	cmp    %r11,%r10
   1603a:	setg   %dl
   1603d:	and    %rsi,%rcx
   16040:	cmp    %r11,%rcx
   16043:	setg   %cl
   16046:	or     %dl,%cl
   16048:	or     %r8b,%cl
   1604b:	je     16055 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x125>
   1604d:	mov    $0x2,%ecx
   16052:	mov    %ecx,(%rax)
   16054:	ret
   16055:	xor    %ecx,%ecx
   16057:	xorps  %xmm8,%xmm8
   1605b:	ucomiss %xmm8,%xmm1
   1605f:	jne    16063 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x133>
   16061:	jnp    16052 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
   16063:	movaps %xmm1,%xmm9
   16067:	shufps $0x55,%xmm1,%xmm9
   1606c:	ucomiss %xmm8,%xmm9
   16070:	jne    16074 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x144>
   16072:	jnp    16052 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
   16074:	movdqa %xmm2,%xmm8
   16079:	mulsd  %xmm7,%xmm8
   1607e:	movdqa %xmm0,%xmm9
   16083:	mulsd  %xmm5,%xmm9
   16088:	subsd  %xmm9,%xmm8
   1608d:	xorpd  %xmm9,%xmm9
   16092:	ucomisd %xmm9,%xmm8
   16097:	jne    1609b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x16b>
   16099:	jnp    16052 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
   1609b:	cvtps2pd %xmm3,%xmm10
   1609f:	movdqa %xmm5,%xmm9
   160a4:	cvtps2pd %xmm1,%xmm1
   160a7:	movdqa %xmm2,%xmm8
   160ac:	mulsd  %xmm10,%xmm8
   160b1:	movdqa %xmm0,%xmm3
   160b5:	mulsd  %xmm10,%xmm3
   160ba:	addpd  %xmm10,%xmm1
   160bf:	unpckhpd %xmm10,%xmm10
   160c4:	mulsd  %xmm10,%xmm5
   160c9:	movapd %xmm8,%xmm11
   160ce:	addsd  %xmm5,%xmm11
   160d3:	addsd  %xmm6,%xmm11
   160d8:	mulsd  %xmm7,%xmm10
   160dd:	movapd %xmm3,%xmm12
   160e2:	addsd  %xmm10,%xmm12
   160e7:	addsd  %xmm4,%xmm12
   160ec:	movsd  -0xf765(%rip),%xmm13        # 6990 <__abi_tag+0x665c>
   160f5:	movapd %xmm11,%xmm14
   160fa:	minsd  %xmm13,%xmm14
   160ff:	movapd %xmm12,%xmm15
   16104:	minsd  %xmm13,%xmm15
   16109:	movsd  -0xf772(%rip),%xmm13        # 69a0 <__abi_tag+0x666c>
   16112:	maxsd  %xmm13,%xmm11
   16117:	maxsd  %xmm13,%xmm12
   1611c:	punpcklqdq %xmm9,%xmm2
   16121:	mulpd  %xmm1,%xmm2
   16125:	addsd  %xmm2,%xmm5
   16129:	addsd  %xmm6,%xmm5
   1612d:	mulsd  %xmm1,%xmm0
   16131:	addsd  %xmm0,%xmm10
   16136:	addsd  %xmm4,%xmm10
   1613b:	movapd %xmm5,%xmm13
   16140:	minsd  %xmm14,%xmm13
   16145:	movapd %xmm10,%xmm14
   1614a:	minsd  %xmm15,%xmm14
   1614f:	maxsd  %xmm11,%xmm5
   16154:	maxsd  %xmm12,%xmm10
   16159:	movapd %xmm2,%xmm9
   1615e:	unpckhpd %xmm2,%xmm9
   16163:	addsd  %xmm9,%xmm8
   16168:	addsd  %xmm6,%xmm8
   1616d:	unpckhpd %xmm1,%xmm1
   16171:	mulsd  %xmm7,%xmm1
   16175:	addsd  %xmm1,%xmm3
   16179:	addsd  %xmm4,%xmm3
   1617d:	movapd %xmm8,%xmm7
   16182:	minsd  %xmm13,%xmm7
   16187:	movapd %xmm3,%xmm11
   1618c:	minsd  %xmm14,%xmm11
   16191:	maxsd  %xmm5,%xmm8
   16196:	addsd  %xmm2,%xmm9
   1619b:	addsd  %xmm6,%xmm9
   161a0:	addsd  %xmm0,%xmm1
   161a4:	addsd  %xmm4,%xmm1
   161a8:	movapd %xmm9,%xmm0
   161ad:	minsd  %xmm7,%xmm0
   161b1:	movapd %xmm1,%xmm2
   161b5:	minsd  %xmm11,%xmm2
   161ba:	cvtsd2ss %xmm0,%xmm0
   161be:	movd   %xmm0,%ecx
   161c2:	cmp    $0xff800000,%ecx
   161c8:	je     161e9 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b9>
   161ca:	mov    %ecx,%edx
   161cc:	and    $0x7fffffff,%edx
   161d2:	je     161dc <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2ac>
   161d4:	cmp    %edx,%ecx
   161d6:	jne    161e3 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b3>
   161d8:	dec    %ecx
   161da:	jmp    161e5 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b5>
   161dc:	mov    $0x80000001,%ecx
   161e1:	jmp    161e5 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b5>
   161e3:	inc    %ecx
   161e5:	movd   %ecx,%xmm0
   161e9:	maxsd  %xmm10,%xmm3
   161ee:	maxsd  %xmm8,%xmm9
   161f3:	cvtsd2ss %xmm2,%xmm2
   161f7:	movd   %xmm2,%ecx
   161fb:	cmp    $0xff800000,%ecx
   16201:	je     16222 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2f2>
   16203:	mov    %ecx,%edx
   16205:	and    $0x7fffffff,%edx
   1620b:	je     16215 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2e5>
   1620d:	cmp    %edx,%ecx
   1620f:	jne    1621c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2ec>
   16211:	dec    %ecx
   16213:	jmp    1621e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2ee>
   16215:	mov    $0x80000001,%ecx
   1621a:	jmp    1621e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2ee>
   1621c:	inc    %ecx
   1621e:	movd   %ecx,%xmm2
   16222:	maxsd  %xmm3,%xmm1
   16226:	xorps  %xmm3,%xmm3
   16229:	cvtsd2ss %xmm9,%xmm3
   1622e:	movd   %xmm3,%ecx
   16232:	cmp    $0x7f800000,%ecx
   16238:	je     16259 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x329>
   1623a:	mov    %ecx,%edx
   1623c:	and    $0x7fffffff,%edx
   16242:	je     1624c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x31c>
   16244:	cmp    %edx,%ecx
   16246:	jne    16253 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x323>
   16248:	inc    %ecx
   1624a:	jmp    16255 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x325>
   1624c:	mov    $0x1,%ecx
   16251:	jmp    16255 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x325>
   16253:	dec    %ecx
   16255:	movd   %ecx,%xmm3
   16259:	cvtsd2ss %xmm1,%xmm1
   1625d:	movd   %xmm1,%ecx
   16261:	cmp    $0x7f800000,%ecx
   16267:	je     16288 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x358>
   16269:	mov    %ecx,%edx
   1626b:	and    $0x7fffffff,%edx
   16271:	je     1627b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x34b>
   16273:	cmp    %edx,%ecx
   16275:	jne    16282 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x352>
   16277:	inc    %ecx
   16279:	jmp    16284 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x354>
   1627b:	mov    $0x1,%ecx
   16280:	jmp    16284 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x354>
   16282:	dec    %ecx
   16284:	movd   %ecx,%xmm1
   16288:	subss  %xmm0,%xmm3
   1628c:	movd   %xmm3,%ecx
   16290:	ucomiss %xmm3,%xmm3
   16293:	setp   %dl
   16296:	cmp    $0x7f800000,%ecx
   1629c:	sete   %sil
   162a0:	or     %dl,%sil
   162a3:	jne    162c4 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x394>
   162a5:	mov    %ecx,%edx
   162a7:	and    $0x7fffffff,%edx
   162ad:	je     162b7 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x387>
   162af:	cmp    %edx,%ecx
   162b1:	jne    162be <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x38e>
   162b3:	inc    %ecx
   162b5:	jmp    162c0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x390>
   162b7:	mov    $0x1,%ecx
   162bc:	jmp    162c0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x390>
   162be:	dec    %ecx
   162c0:	movd   %ecx,%xmm3
   162c4:	subss  %xmm2,%xmm1
   162c8:	movd   %xmm1,%ecx
   162cc:	ucomiss %xmm1,%xmm1
   162cf:	setp   %dl
   162d2:	cmp    $0x7f800000,%ecx
   162d8:	sete   %sil
   162dc:	or     %dl,%sil
   162df:	jne    16300 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3d0>
   162e1:	mov    %ecx,%edx
   162e3:	and    $0x7fffffff,%edx
   162e9:	je     162f3 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3c3>
   162eb:	cmp    %edx,%ecx
   162ed:	jne    162fa <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3ca>
   162ef:	inc    %ecx
   162f1:	jmp    162fc <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3cc>
   162f3:	mov    $0x1,%ecx
   162f8:	jmp    162fc <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3cc>
   162fa:	dec    %ecx
   162fc:	movd   %ecx,%xmm1
   16300:	movaps %xmm0,%xmm4
   16303:	addss  %xmm3,%xmm4
   16307:	movd   %xmm4,%ecx
   1630b:	movaps %xmm2,%xmm4
   1630e:	addss  %xmm1,%xmm4
   16312:	movd   %xmm4,%edx
   16316:	movdqa %xmm3,%xmm4
   1631a:	punpckldq %xmm1,%xmm4
   1631e:	movdqa %xmm0,%xmm5
   16322:	punpckldq %xmm2,%xmm5
   16326:	punpcklqdq %xmm4,%xmm5
   1632a:	and    $0x7fffffff,%ecx
   16330:	cmp    $0x7f800000,%ecx
   16336:	setl   %cl
   16339:	and    $0x7fffffff,%edx
   1633f:	cmp    $0x7f800000,%edx
   16345:	setl   %dl
   16348:	pand   -0x112d0(%rip),%xmm5        # 5080 <__abi_tag+0x4d4c>
   16350:	pcmpgtd -0x11468(%rip),%xmm5        # 4ef0 <__abi_tag+0x4bbc>
   16358:	movmskps %xmm5,%esi
   1635b:	test   %esi,%esi
   1635d:	jne    1604d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   16363:	test   %cl,%cl
   16365:	je     1604d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   1636b:	test   %dl,%dl
   1636d:	je     1604d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   16373:	pxor   %xmm4,%xmm4
   16377:	ucomiss %xmm4,%xmm3
   1637a:	jb     1604d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   16380:	ucomiss %xmm4,%xmm1
   16383:	mov    $0x2,%ecx
   16388:	jb     16052 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
   1638e:	movss  %xmm0,0x4(%rax)
   16393:	movss  %xmm2,0x8(%rax)
   16398:	movss  %xmm3,0xc(%rax)
   1639d:	movss  %xmm1,0x10(%rax)
   163a2:	mov    $0x1,%ecx
   163a7:	mov    %ecx,(%rax)
   163a9:	ret
