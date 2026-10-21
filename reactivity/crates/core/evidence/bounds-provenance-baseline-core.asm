
/tmp/gpui-bounds-provenance-baseline-consumer:     file format elf64-x86-64


Disassembly of section .text:

0000000000015f40 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds>:
   15f40:	mov    %rdi,%rax
   15f43:	movsd  (%rdx),%xmm3
   15f47:	movsd  0x8(%rdx),%xmm1
   15f4c:	movaps %xmm3,%xmm2
   15f4f:	addps  %xmm1,%xmm2
   15f52:	movups (%rdx),%xmm0
   15f55:	movaps -0x10edc(%rip),%xmm4        # 5080 <__abi_tag+0x4d4c>
   15f5c:	andps  %xmm4,%xmm0
   15f5f:	andps  %xmm4,%xmm2
   15f62:	movaps -0x11069(%rip),%xmm4        # 4f00 <__abi_tag+0x4bcc>
   15f69:	movlhps %xmm1,%xmm4
   15f6c:	movaps -0x10fa3(%rip),%xmm5        # 4fd0 <__abi_tag+0x4c9c>
   15f73:	movq   %xmm2,%xmm2
   15f77:	movaps %xmm4,%xmm6
   15f7a:	cmpneqps %xmm2,%xmm6
   15f7e:	movaps %xmm4,%xmm7
   15f81:	cmpordps %xmm2,%xmm7
   15f85:	andps  %xmm6,%xmm7
   15f88:	movaps %xmm5,%xmm6
   15f8b:	cmpneqps %xmm0,%xmm6
   15f8f:	cmpordps %xmm5,%xmm0
   15f93:	andps  %xmm6,%xmm0
   15f96:	packssdw %xmm7,%xmm0
   15f9a:	cmpleps %xmm4,%xmm2
   15f9e:	pshufhw $0x84,%xmm2,%xmm2
   15fa3:	shufps $0x23,%xmm0,%xmm2
   15fa7:	shufps $0x24,%xmm2,%xmm0
   15fab:	packsswb %xmm0,%xmm0
   15faf:	pmovmskb %xmm0,%ecx
   15fb3:	cmp    $0xff,%cl
   15fb6:	jne    1605d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   15fbc:	cmpb   $0x0,0x30(%rsi)
   15fc0:	jne    1605d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   15fc6:	movq   (%rsi),%xmm2
   15fca:	movq   0x8(%rsi),%xmm0
   15fcf:	movq   %xmm2,%rdx
   15fd4:	movq   %xmm0,%rdi
   15fd9:	movq   0x10(%rsi),%xmm5
   15fde:	movq   %xmm5,%r8
   15fe3:	movq   0x18(%rsi),%xmm7
   15fe8:	movq   %xmm7,%r9
   15fed:	movq   0x20(%rsi),%xmm6
   15ff2:	movq   %xmm6,%r10
   15ff7:	movq   0x28(%rsi),%xmm4
   15ffc:	movq   %xmm4,%rcx
   16001:	movabs $0x7fffffffffffffff,%rsi
   1600b:	and    %rsi,%rdx
   1600e:	movabs $0x7fefffffffffffff,%r11
   16018:	cmp    %r11,%rdx
   1601b:	setg   %dl
   1601e:	and    %rsi,%rdi
   16021:	cmp    %r11,%rdi
   16024:	setg   %dil
   16028:	or     %dl,%dil
   1602b:	and    %rsi,%r8
   1602e:	cmp    %r11,%r8
   16031:	setg   %dl
   16034:	and    %rsi,%r9
   16037:	cmp    %r11,%r9
   1603a:	setg   %r8b
   1603e:	or     %dl,%r8b
   16041:	or     %dil,%r8b
   16044:	and    %rsi,%r10
   16047:	cmp    %r11,%r10
   1604a:	setg   %dl
   1604d:	and    %rsi,%rcx
   16050:	cmp    %r11,%rcx
   16053:	setg   %cl
   16056:	or     %dl,%cl
   16058:	or     %r8b,%cl
   1605b:	je     16065 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x125>
   1605d:	mov    $0x2,%ecx
   16062:	mov    %ecx,(%rax)
   16064:	ret
   16065:	xor    %ecx,%ecx
   16067:	xorps  %xmm8,%xmm8
   1606b:	ucomiss %xmm8,%xmm1
   1606f:	jne    16073 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x133>
   16071:	jnp    16062 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
   16073:	movaps %xmm1,%xmm9
   16077:	shufps $0x55,%xmm1,%xmm9
   1607c:	ucomiss %xmm8,%xmm9
   16080:	jne    16084 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x144>
   16082:	jnp    16062 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
   16084:	movdqa %xmm2,%xmm8
   16089:	mulsd  %xmm7,%xmm8
   1608e:	movdqa %xmm0,%xmm9
   16093:	mulsd  %xmm5,%xmm9
   16098:	subsd  %xmm9,%xmm8
   1609d:	xorpd  %xmm9,%xmm9
   160a2:	ucomisd %xmm9,%xmm8
   160a7:	jne    160ab <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x16b>
   160a9:	jnp    16062 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
   160ab:	cvtps2pd %xmm3,%xmm10
   160af:	movdqa %xmm5,%xmm9
   160b4:	cvtps2pd %xmm1,%xmm1
   160b7:	movdqa %xmm2,%xmm8
   160bc:	mulsd  %xmm10,%xmm8
   160c1:	movdqa %xmm0,%xmm3
   160c5:	mulsd  %xmm10,%xmm3
   160ca:	addpd  %xmm10,%xmm1
   160cf:	unpckhpd %xmm10,%xmm10
   160d4:	mulsd  %xmm10,%xmm5
   160d9:	movapd %xmm8,%xmm11
   160de:	addsd  %xmm5,%xmm11
   160e3:	addsd  %xmm6,%xmm11
   160e8:	mulsd  %xmm7,%xmm10
   160ed:	movapd %xmm3,%xmm12
   160f2:	addsd  %xmm10,%xmm12
   160f7:	addsd  %xmm4,%xmm12
   160fc:	movsd  -0xf755(%rip),%xmm13        # 69b0 <__abi_tag+0x667c>
   16105:	movapd %xmm11,%xmm14
   1610a:	minsd  %xmm13,%xmm14
   1610f:	movapd %xmm12,%xmm15
   16114:	minsd  %xmm13,%xmm15
   16119:	movsd  -0xf762(%rip),%xmm13        # 69c0 <__abi_tag+0x668c>
   16122:	maxsd  %xmm13,%xmm11
   16127:	maxsd  %xmm13,%xmm12
   1612c:	punpcklqdq %xmm9,%xmm2
   16131:	mulpd  %xmm1,%xmm2
   16135:	addsd  %xmm2,%xmm5
   16139:	addsd  %xmm6,%xmm5
   1613d:	mulsd  %xmm1,%xmm0
   16141:	addsd  %xmm0,%xmm10
   16146:	addsd  %xmm4,%xmm10
   1614b:	movapd %xmm5,%xmm13
   16150:	minsd  %xmm14,%xmm13
   16155:	movapd %xmm10,%xmm14
   1615a:	minsd  %xmm15,%xmm14
   1615f:	maxsd  %xmm11,%xmm5
   16164:	maxsd  %xmm12,%xmm10
   16169:	movapd %xmm2,%xmm9
   1616e:	unpckhpd %xmm2,%xmm9
   16173:	addsd  %xmm9,%xmm8
   16178:	addsd  %xmm6,%xmm8
   1617d:	unpckhpd %xmm1,%xmm1
   16181:	mulsd  %xmm7,%xmm1
   16185:	addsd  %xmm1,%xmm3
   16189:	addsd  %xmm4,%xmm3
   1618d:	movapd %xmm8,%xmm7
   16192:	minsd  %xmm13,%xmm7
   16197:	movapd %xmm3,%xmm11
   1619c:	minsd  %xmm14,%xmm11
   161a1:	maxsd  %xmm5,%xmm8
   161a6:	addsd  %xmm2,%xmm9
   161ab:	addsd  %xmm6,%xmm9
   161b0:	addsd  %xmm0,%xmm1
   161b4:	addsd  %xmm4,%xmm1
   161b8:	movapd %xmm9,%xmm0
   161bd:	minsd  %xmm7,%xmm0
   161c1:	movapd %xmm1,%xmm2
   161c5:	minsd  %xmm11,%xmm2
   161ca:	cvtsd2ss %xmm0,%xmm0
   161ce:	movd   %xmm0,%ecx
   161d2:	cmp    $0xff800000,%ecx
   161d8:	je     161f9 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b9>
   161da:	mov    %ecx,%edx
   161dc:	and    $0x7fffffff,%edx
   161e2:	je     161ec <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2ac>
   161e4:	cmp    %edx,%ecx
   161e6:	jne    161f3 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b3>
   161e8:	dec    %ecx
   161ea:	jmp    161f5 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b5>
   161ec:	mov    $0x80000001,%ecx
   161f1:	jmp    161f5 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b5>
   161f3:	inc    %ecx
   161f5:	movd   %ecx,%xmm0
   161f9:	maxsd  %xmm10,%xmm3
   161fe:	maxsd  %xmm8,%xmm9
   16203:	cvtsd2ss %xmm2,%xmm2
   16207:	movd   %xmm2,%ecx
   1620b:	cmp    $0xff800000,%ecx
   16211:	je     16232 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2f2>
   16213:	mov    %ecx,%edx
   16215:	and    $0x7fffffff,%edx
   1621b:	je     16225 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2e5>
   1621d:	cmp    %edx,%ecx
   1621f:	jne    1622c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2ec>
   16221:	dec    %ecx
   16223:	jmp    1622e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2ee>
   16225:	mov    $0x80000001,%ecx
   1622a:	jmp    1622e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2ee>
   1622c:	inc    %ecx
   1622e:	movd   %ecx,%xmm2
   16232:	maxsd  %xmm3,%xmm1
   16236:	xorps  %xmm3,%xmm3
   16239:	cvtsd2ss %xmm9,%xmm3
   1623e:	movd   %xmm3,%ecx
   16242:	cmp    $0x7f800000,%ecx
   16248:	je     16269 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x329>
   1624a:	mov    %ecx,%edx
   1624c:	and    $0x7fffffff,%edx
   16252:	je     1625c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x31c>
   16254:	cmp    %edx,%ecx
   16256:	jne    16263 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x323>
   16258:	inc    %ecx
   1625a:	jmp    16265 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x325>
   1625c:	mov    $0x1,%ecx
   16261:	jmp    16265 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x325>
   16263:	dec    %ecx
   16265:	movd   %ecx,%xmm3
   16269:	cvtsd2ss %xmm1,%xmm1
   1626d:	movd   %xmm1,%ecx
   16271:	cmp    $0x7f800000,%ecx
   16277:	je     16298 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x358>
   16279:	mov    %ecx,%edx
   1627b:	and    $0x7fffffff,%edx
   16281:	je     1628b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x34b>
   16283:	cmp    %edx,%ecx
   16285:	jne    16292 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x352>
   16287:	inc    %ecx
   16289:	jmp    16294 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x354>
   1628b:	mov    $0x1,%ecx
   16290:	jmp    16294 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x354>
   16292:	dec    %ecx
   16294:	movd   %ecx,%xmm1
   16298:	subss  %xmm0,%xmm3
   1629c:	movd   %xmm3,%ecx
   162a0:	ucomiss %xmm3,%xmm3
   162a3:	setp   %dl
   162a6:	cmp    $0x7f800000,%ecx
   162ac:	sete   %sil
   162b0:	or     %dl,%sil
   162b3:	jne    162d4 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x394>
   162b5:	mov    %ecx,%edx
   162b7:	and    $0x7fffffff,%edx
   162bd:	je     162c7 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x387>
   162bf:	cmp    %edx,%ecx
   162c1:	jne    162ce <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x38e>
   162c3:	inc    %ecx
   162c5:	jmp    162d0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x390>
   162c7:	mov    $0x1,%ecx
   162cc:	jmp    162d0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x390>
   162ce:	dec    %ecx
   162d0:	movd   %ecx,%xmm3
   162d4:	subss  %xmm2,%xmm1
   162d8:	movd   %xmm1,%ecx
   162dc:	ucomiss %xmm1,%xmm1
   162df:	setp   %dl
   162e2:	cmp    $0x7f800000,%ecx
   162e8:	sete   %sil
   162ec:	or     %dl,%sil
   162ef:	jne    16310 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3d0>
   162f1:	mov    %ecx,%edx
   162f3:	and    $0x7fffffff,%edx
   162f9:	je     16303 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3c3>
   162fb:	cmp    %edx,%ecx
   162fd:	jne    1630a <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3ca>
   162ff:	inc    %ecx
   16301:	jmp    1630c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3cc>
   16303:	mov    $0x1,%ecx
   16308:	jmp    1630c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3cc>
   1630a:	dec    %ecx
   1630c:	movd   %ecx,%xmm1
   16310:	movaps %xmm0,%xmm4
   16313:	addss  %xmm3,%xmm4
   16317:	movd   %xmm4,%ecx
   1631b:	movaps %xmm2,%xmm4
   1631e:	addss  %xmm1,%xmm4
   16322:	movd   %xmm4,%edx
   16326:	movdqa %xmm3,%xmm4
   1632a:	punpckldq %xmm1,%xmm4
   1632e:	movdqa %xmm0,%xmm5
   16332:	punpckldq %xmm2,%xmm5
   16336:	punpcklqdq %xmm4,%xmm5
   1633a:	and    $0x7fffffff,%ecx
   16340:	cmp    $0x7f800000,%ecx
   16346:	setl   %cl
   16349:	and    $0x7fffffff,%edx
   1634f:	cmp    $0x7f800000,%edx
   16355:	setl   %dl
   16358:	pand   -0x112e0(%rip),%xmm5        # 5080 <__abi_tag+0x4d4c>
   16360:	pcmpgtd -0x11478(%rip),%xmm5        # 4ef0 <__abi_tag+0x4bbc>
   16368:	movmskps %xmm5,%esi
   1636b:	test   %esi,%esi
   1636d:	jne    1605d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   16373:	test   %cl,%cl
   16375:	je     1605d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   1637b:	test   %dl,%dl
   1637d:	je     1605d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   16383:	pxor   %xmm4,%xmm4
   16387:	ucomiss %xmm4,%xmm3
   1638a:	jb     1605d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   16390:	ucomiss %xmm4,%xmm1
   16393:	mov    $0x2,%ecx
   16398:	jb     16062 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
   1639e:	movss  %xmm0,0x4(%rax)
   163a3:	movss  %xmm2,0x8(%rax)
   163a8:	movss  %xmm3,0xc(%rax)
   163ad:	movss  %xmm1,0x10(%rax)
   163b2:	mov    $0x1,%ecx
   163b7:	mov    %ecx,(%rax)
   163b9:	ret


/tmp/gpui-bounds-provenance-baseline-consumer:     file format elf64-x86-64


Disassembly of section .text:

0000000000015ce0 <bounds_provenance_consumer::inspect>:
   15ce0:	jmp    *0x41f42(%rip)        # 57c28 <_DYNAMIC+0x2c8>
