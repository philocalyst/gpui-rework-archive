
/tmp/gpui-bounds-provenance-baseline-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000017da0 <bounds_provenance_copies::make>:
   17da0:	cvtps2pd (%rsi),%xmm0
   17da3:	movups %xmm0,(%rdi)
   17da6:	cvtps2pd 0x8(%rsi),%xmm0
   17daa:	movups %xmm0,0x10(%rdi)
   17dae:	cvtps2pd 0x10(%rsi),%xmm0
   17db2:	movups %xmm0,0x20(%rdi)
   17db6:	movb   $0x0,0x30(%rdi)
   17dba:	ret


/tmp/gpui-bounds-provenance-baseline-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000017e40 <bounds_provenance_copies::compose>:
   17e40:	jmp    *0x48ea2(%rip)        # 60ce8 <_DYNAMIC+0x2c8>


/tmp/gpui-bounds-provenance-baseline-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000017dc0 <bounds_provenance_copies::same>:
   17dc0:	movzbl 0x30(%rdi),%eax
   17dc4:	cmp    0x30(%rsi),%al
   17dc7:	jne    17e1e <bounds_provenance_copies::same+0x5e>
   17dc9:	movsd  (%rdi),%xmm0
   17dcd:	ucomisd (%rsi),%xmm0
   17dd1:	jne    17e1e <bounds_provenance_copies::same+0x5e>
   17dd3:	jp     17e1e <bounds_provenance_copies::same+0x5e>
   17dd5:	movsd  0x8(%rdi),%xmm0
   17dda:	ucomisd 0x8(%rsi),%xmm0
   17ddf:	jne    17e1e <bounds_provenance_copies::same+0x5e>
   17de1:	jp     17e1e <bounds_provenance_copies::same+0x5e>
   17de3:	movsd  0x10(%rdi),%xmm0
   17de8:	ucomisd 0x10(%rsi),%xmm0
   17ded:	jne    17e1e <bounds_provenance_copies::same+0x5e>
   17def:	jp     17e1e <bounds_provenance_copies::same+0x5e>
   17df1:	movsd  0x18(%rdi),%xmm0
   17df6:	ucomisd 0x18(%rsi),%xmm0
   17dfb:	jne    17e1e <bounds_provenance_copies::same+0x5e>
   17dfd:	jp     17e1e <bounds_provenance_copies::same+0x5e>
   17dff:	movsd  0x20(%rdi),%xmm0
   17e04:	ucomisd 0x20(%rsi),%xmm0
   17e09:	jne    17e1e <bounds_provenance_copies::same+0x5e>
   17e0b:	jp     17e1e <bounds_provenance_copies::same+0x5e>
   17e0d:	movsd  0x28(%rdi),%xmm0
   17e12:	ucomisd 0x28(%rsi),%xmm0
   17e17:	jne    17e1e <bounds_provenance_copies::same+0x5e>
   17e19:	jp     17e1e <bounds_provenance_copies::same+0x5e>
   17e1b:	mov    $0x1,%al
   17e1d:	ret
   17e1e:	xor    %eax,%eax
   17e20:	ret


/tmp/gpui-bounds-provenance-baseline-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000017030 <bounds_provenance_copies::copy>:
   17030:	mov    0x30(%rsi),%rax
   17034:	mov    %rax,0x30(%rdi)
   17038:	movups (%rsi),%xmm0
   1703b:	movups 0x10(%rsi),%xmm1
   1703f:	movups 0x20(%rsi),%xmm2
   17043:	movups %xmm2,0x20(%rdi)
   17047:	movups %xmm1,0x10(%rdi)
   1704b:	movups %xmm0,(%rdi)
   1704e:	ret


/tmp/gpui-bounds-provenance-baseline-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000017e30 <bounds_provenance_copies::bounds>:
   17e30:	jmp    *0x48eaa(%rip)        # 60ce0 <_DYNAMIC+0x2c0>


/tmp/gpui-bounds-provenance-baseline-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000019870 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose>:
   19870:	mov    %rdi,%rax
   19873:	movq   0x20(%rsi),%xmm0
   19878:	movss  0x10(%rdx),%xmm1
   1987d:	movss  0x14(%rdx),%xmm2
   19882:	cvtps2pd (%rdx),%xmm9
   19886:	cvtps2pd 0x8(%rdx),%xmm8
   1988b:	cvtss2sd %xmm1,%xmm5
   1988f:	cvtss2sd %xmm2,%xmm3
   19893:	movq   0x28(%rsi),%xmm1
   19898:	movupd (%rsi),%xmm4
   1989c:	movupd 0x10(%rsi),%xmm2
   198a1:	movapd %xmm9,%xmm7
   198a6:	unpcklpd %xmm9,%xmm7
   198ab:	mulpd  %xmm4,%xmm7
   198af:	movapd %xmm9,%xmm6
   198b4:	unpckhpd %xmm9,%xmm6
   198b9:	mulpd  %xmm2,%xmm6
   198bd:	addpd  %xmm7,%xmm6
   198c1:	movapd %xmm8,%xmm10
   198c6:	unpcklpd %xmm8,%xmm10
   198cb:	mulpd  %xmm4,%xmm10
   198d0:	movapd %xmm8,%xmm7
   198d5:	unpckhpd %xmm8,%xmm7
   198da:	mulpd  %xmm2,%xmm7
   198de:	addpd  %xmm10,%xmm7
   198e3:	mov    $0x1,%cl
   198e5:	cmpb   $0x0,0x30(%rsi)
   198e9:	jne    199ff <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x18f>
   198ef:	movapd %xmm6,%xmm11
   198f4:	unpckhpd %xmm6,%xmm11
   198f9:	mulsd  %xmm7,%xmm11
   198fe:	movapd %xmm7,%xmm10
   19903:	unpckhpd %xmm7,%xmm10
   19908:	mulsd  %xmm6,%xmm10
   1990d:	subsd  %xmm11,%xmm10
   19912:	movq   %xmm0,%rdi
   19917:	movabs $0x7fffffffffffffff,%rdx
   19921:	and    %rdx,%rdi
   19924:	movabs $0x7fefffffffffffff,%rsi
   1992e:	cmp    %rsi,%rdi
   19931:	setg   %dil
   19935:	movq   %xmm1,%r8
   1993a:	and    %rdx,%r8
   1993d:	cmp    %rsi,%r8
   19940:	movapd %xmm4,%xmm11
   19945:	shufps $0xdd,%xmm2,%xmm11
   1994a:	andps  -0x13f02(%rip),%xmm11        # 5a50 <__abi_tag+0x571c>
   19952:	setg   %r8b
   19956:	pcmpgtd -0x13f6f(%rip),%xmm11        # 59f0 <__abi_tag+0x56bc>
   1995f:	movmskps %xmm11,%r9d
   19963:	test   %r9d,%r9d
   19966:	setne  %r9b
   1996a:	or     %dil,%r8b
   1996d:	or     %r9b,%r8b
   19970:	jne    199f1 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x181>
   19972:	movapd %xmm2,%xmm11
   19977:	shufpd $0x1,%xmm2,%xmm11
   1997d:	mulpd  %xmm4,%xmm11
   19982:	movapd %xmm11,%xmm12
   19987:	unpckhpd %xmm11,%xmm12
   1998c:	subsd  %xmm12,%xmm11
   19991:	xorpd  %xmm12,%xmm12
   19996:	ucomisd %xmm12,%xmm11
   1999b:	jne    1999f <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x12f>
   1999d:	jnp    199f1 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x181>
   1999f:	shufpd $0x1,%xmm8,%xmm8
   199a5:	movq   %xmm5,%rdi
   199aa:	and    %rdx,%rdi
   199ad:	cmp    %rsi,%rdi
   199b0:	setg   %dil
   199b4:	movq   %xmm3,%r8
   199b9:	and    %rdx,%r8
   199bc:	cmp    %rsi,%r8
   199bf:	movapd %xmm9,%xmm11
   199c4:	shufps $0xdd,%xmm8,%xmm11
   199c9:	andps  -0x13f81(%rip),%xmm11        # 5a50 <__abi_tag+0x571c>
   199d1:	setg   %r8b
   199d5:	pcmpgtd -0x13fee(%rip),%xmm11        # 59f0 <__abi_tag+0x56bc>
   199de:	movmskps %xmm11,%r9d
   199e2:	test   %r9d,%r9d
   199e5:	setne  %r9b
   199e9:	or     %dil,%r8b
   199ec:	or     %r9b,%r8b
   199ef:	je     19a4e <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x1de>
   199f1:	movq   %xmm10,%rcx
   199f6:	and    %rdx,%rcx
   199f9:	cmp    %rsi,%rcx
   199fc:	setg   %cl
   199ff:	movapd %xmm4,%xmm8
   19a04:	unpckhpd %xmm4,%xmm8
   19a09:	mulsd  %xmm5,%xmm8
   19a0e:	movapd %xmm2,%xmm9
   19a13:	unpckhpd %xmm2,%xmm9
   19a18:	mulsd  %xmm3,%xmm9
   19a1d:	addsd  %xmm8,%xmm9
   19a22:	addsd  %xmm9,%xmm1
   19a27:	mulsd  %xmm5,%xmm4
   19a2b:	mulsd  %xmm3,%xmm2
   19a2f:	addsd  %xmm4,%xmm2
   19a33:	addsd  %xmm2,%xmm0
   19a37:	movupd %xmm6,(%rax)
   19a3b:	movupd %xmm7,0x10(%rax)
   19a40:	movsd  %xmm0,0x20(%rax)
   19a45:	movsd  %xmm1,0x28(%rax)
   19a4a:	mov    %cl,0x30(%rax)
   19a4d:	ret
   19a4e:	mulpd  %xmm9,%xmm8
   19a53:	movapd %xmm8,%xmm9
   19a58:	unpckhpd %xmm8,%xmm9
   19a5d:	subsd  %xmm9,%xmm8
   19a62:	xorpd  %xmm9,%xmm9
   19a67:	ucomisd %xmm9,%xmm8
   19a6c:	jne    19a70 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x200>
   19a6e:	jnp    199f1 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x181>
   19a70:	ucomisd %xmm9,%xmm10
   19a75:	jne    199f1 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x181>
   19a7b:	jnp    199ff <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x18f>
   19a7d:	jmp    199f1 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x181>


/tmp/gpui-bounds-provenance-baseline-copies:     file format elf64-x86-64


Disassembly of section .text:

00000000000193f0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds>:
   193f0:	mov    %rdi,%rax
   193f3:	movsd  (%rdx),%xmm3
   193f7:	movsd  0x8(%rdx),%xmm1
   193fc:	movaps %xmm3,%xmm2
   193ff:	addps  %xmm1,%xmm2
   19402:	movups (%rdx),%xmm0
   19405:	movaps -0x139bc(%rip),%xmm4        # 5a50 <__abi_tag+0x571c>
   1940c:	andps  %xmm4,%xmm0
   1940f:	andps  %xmm4,%xmm2
   19412:	movaps -0x13b39(%rip),%xmm4        # 58e0 <__abi_tag+0x55ac>
   19419:	movlhps %xmm1,%xmm4
   1941c:	movaps -0x13a83(%rip),%xmm5        # 59a0 <__abi_tag+0x566c>
   19423:	movq   %xmm2,%xmm2
   19427:	movaps %xmm4,%xmm6
   1942a:	cmpneqps %xmm2,%xmm6
   1942e:	movaps %xmm4,%xmm7
   19431:	cmpordps %xmm2,%xmm7
   19435:	andps  %xmm6,%xmm7
   19438:	movaps %xmm5,%xmm6
   1943b:	cmpneqps %xmm0,%xmm6
   1943f:	cmpordps %xmm5,%xmm0
   19443:	andps  %xmm6,%xmm0
   19446:	packssdw %xmm7,%xmm0
   1944a:	cmpleps %xmm4,%xmm2
   1944e:	pshufhw $0x84,%xmm2,%xmm2
   19453:	shufps $0x23,%xmm0,%xmm2
   19457:	shufps $0x24,%xmm2,%xmm0
   1945b:	packsswb %xmm0,%xmm0
   1945f:	pmovmskb %xmm0,%ecx
   19463:	cmp    $0xff,%cl
   19466:	jne    1950d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   1946c:	cmpb   $0x0,0x30(%rsi)
   19470:	jne    1950d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   19476:	movq   (%rsi),%xmm2
   1947a:	movq   0x8(%rsi),%xmm0
   1947f:	movq   %xmm2,%rdx
   19484:	movq   %xmm0,%rdi
   19489:	movq   0x10(%rsi),%xmm5
   1948e:	movq   %xmm5,%r8
   19493:	movq   0x18(%rsi),%xmm7
   19498:	movq   %xmm7,%r9
   1949d:	movq   0x20(%rsi),%xmm6
   194a2:	movq   %xmm6,%r10
   194a7:	movq   0x28(%rsi),%xmm4
   194ac:	movq   %xmm4,%rcx
   194b1:	movabs $0x7fffffffffffffff,%rsi
   194bb:	and    %rsi,%rdx
   194be:	movabs $0x7fefffffffffffff,%r11
   194c8:	cmp    %r11,%rdx
   194cb:	setg   %dl
   194ce:	and    %rsi,%rdi
   194d1:	cmp    %r11,%rdi
   194d4:	setg   %dil
   194d8:	or     %dl,%dil
   194db:	and    %rsi,%r8
   194de:	cmp    %r11,%r8
   194e1:	setg   %dl
   194e4:	and    %rsi,%r9
   194e7:	cmp    %r11,%r9
   194ea:	setg   %r8b
   194ee:	or     %dl,%r8b
   194f1:	or     %dil,%r8b
   194f4:	and    %rsi,%r10
   194f7:	cmp    %r11,%r10
   194fa:	setg   %dl
   194fd:	and    %rsi,%rcx
   19500:	cmp    %r11,%rcx
   19503:	setg   %cl
   19506:	or     %dl,%cl
   19508:	or     %r8b,%cl
   1950b:	je     19515 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x125>
   1950d:	mov    $0x2,%ecx
   19512:	mov    %ecx,(%rax)
   19514:	ret
   19515:	xor    %ecx,%ecx
   19517:	xorps  %xmm8,%xmm8
   1951b:	ucomiss %xmm8,%xmm1
   1951f:	jne    19523 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x133>
   19521:	jnp    19512 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
   19523:	movaps %xmm1,%xmm9
   19527:	shufps $0x55,%xmm1,%xmm9
   1952c:	ucomiss %xmm8,%xmm9
   19530:	jne    19534 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x144>
   19532:	jnp    19512 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
   19534:	movdqa %xmm2,%xmm8
   19539:	mulsd  %xmm7,%xmm8
   1953e:	movdqa %xmm0,%xmm9
   19543:	mulsd  %xmm5,%xmm9
   19548:	subsd  %xmm9,%xmm8
   1954d:	xorpd  %xmm9,%xmm9
   19552:	ucomisd %xmm9,%xmm8
   19557:	jne    1955b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x16b>
   19559:	jnp    19512 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
   1955b:	cvtps2pd %xmm3,%xmm10
   1955f:	movdqa %xmm5,%xmm9
   19564:	cvtps2pd %xmm1,%xmm1
   19567:	movdqa %xmm2,%xmm8
   1956c:	mulsd  %xmm10,%xmm8
   19571:	movdqa %xmm0,%xmm3
   19575:	mulsd  %xmm10,%xmm3
   1957a:	addpd  %xmm10,%xmm1
   1957f:	unpckhpd %xmm10,%xmm10
   19584:	mulsd  %xmm10,%xmm5
   19589:	movapd %xmm8,%xmm11
   1958e:	addsd  %xmm5,%xmm11
   19593:	addsd  %xmm6,%xmm11
   19598:	mulsd  %xmm7,%xmm10
   1959d:	movapd %xmm3,%xmm12
   195a2:	addsd  %xmm10,%xmm12
   195a7:	addsd  %xmm4,%xmm12
   195ac:	movsd  -0x11fcd(%rip),%xmm13        # 75e8 <anon.d96a9f9d48f7af40c29678fa3ce160fd.3.llvm.6126650354112633161+0x14ef>
   195b5:	movapd %xmm11,%xmm14
   195ba:	minsd  %xmm13,%xmm14
   195bf:	movapd %xmm12,%xmm15
   195c4:	minsd  %xmm13,%xmm15
   195c9:	movsd  -0x11fd2(%rip),%xmm13        # 7600 <anon.d96a9f9d48f7af40c29678fa3ce160fd.3.llvm.6126650354112633161+0x1507>
   195d2:	maxsd  %xmm13,%xmm11
   195d7:	maxsd  %xmm13,%xmm12
   195dc:	punpcklqdq %xmm9,%xmm2
   195e1:	mulpd  %xmm1,%xmm2
   195e5:	addsd  %xmm2,%xmm5
   195e9:	addsd  %xmm6,%xmm5
   195ed:	mulsd  %xmm1,%xmm0
   195f1:	addsd  %xmm0,%xmm10
   195f6:	addsd  %xmm4,%xmm10
   195fb:	movapd %xmm5,%xmm13
   19600:	minsd  %xmm14,%xmm13
   19605:	movapd %xmm10,%xmm14
   1960a:	minsd  %xmm15,%xmm14
   1960f:	maxsd  %xmm11,%xmm5
   19614:	maxsd  %xmm12,%xmm10
   19619:	movapd %xmm2,%xmm9
   1961e:	unpckhpd %xmm2,%xmm9
   19623:	addsd  %xmm9,%xmm8
   19628:	addsd  %xmm6,%xmm8
   1962d:	unpckhpd %xmm1,%xmm1
   19631:	mulsd  %xmm7,%xmm1
   19635:	addsd  %xmm1,%xmm3
   19639:	addsd  %xmm4,%xmm3
   1963d:	movapd %xmm8,%xmm7
   19642:	minsd  %xmm13,%xmm7
   19647:	movapd %xmm3,%xmm11
   1964c:	minsd  %xmm14,%xmm11
   19651:	maxsd  %xmm5,%xmm8
   19656:	addsd  %xmm2,%xmm9
   1965b:	addsd  %xmm6,%xmm9
   19660:	addsd  %xmm0,%xmm1
   19664:	addsd  %xmm4,%xmm1
   19668:	movapd %xmm9,%xmm0
   1966d:	minsd  %xmm7,%xmm0
   19671:	movapd %xmm1,%xmm2
   19675:	minsd  %xmm11,%xmm2
   1967a:	cvtsd2ss %xmm0,%xmm0
   1967e:	movd   %xmm0,%ecx
   19682:	cmp    $0xff800000,%ecx
   19688:	je     196a9 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b9>
   1968a:	mov    %ecx,%edx
   1968c:	and    $0x7fffffff,%edx
   19692:	je     1969c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2ac>
   19694:	cmp    %edx,%ecx
   19696:	jne    196a3 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b3>
   19698:	dec    %ecx
   1969a:	jmp    196a5 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b5>
   1969c:	mov    $0x80000001,%ecx
   196a1:	jmp    196a5 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2b5>
   196a3:	inc    %ecx
   196a5:	movd   %ecx,%xmm0
   196a9:	maxsd  %xmm10,%xmm3
   196ae:	maxsd  %xmm8,%xmm9
   196b3:	cvtsd2ss %xmm2,%xmm2
   196b7:	movd   %xmm2,%ecx
   196bb:	cmp    $0xff800000,%ecx
   196c1:	je     196e2 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2f2>
   196c3:	mov    %ecx,%edx
   196c5:	and    $0x7fffffff,%edx
   196cb:	je     196d5 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2e5>
   196cd:	cmp    %edx,%ecx
   196cf:	jne    196dc <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2ec>
   196d1:	dec    %ecx
   196d3:	jmp    196de <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2ee>
   196d5:	mov    $0x80000001,%ecx
   196da:	jmp    196de <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x2ee>
   196dc:	inc    %ecx
   196de:	movd   %ecx,%xmm2
   196e2:	maxsd  %xmm3,%xmm1
   196e6:	xorps  %xmm3,%xmm3
   196e9:	cvtsd2ss %xmm9,%xmm3
   196ee:	movd   %xmm3,%ecx
   196f2:	cmp    $0x7f800000,%ecx
   196f8:	je     19719 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x329>
   196fa:	mov    %ecx,%edx
   196fc:	and    $0x7fffffff,%edx
   19702:	je     1970c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x31c>
   19704:	cmp    %edx,%ecx
   19706:	jne    19713 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x323>
   19708:	inc    %ecx
   1970a:	jmp    19715 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x325>
   1970c:	mov    $0x1,%ecx
   19711:	jmp    19715 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x325>
   19713:	dec    %ecx
   19715:	movd   %ecx,%xmm3
   19719:	cvtsd2ss %xmm1,%xmm1
   1971d:	movd   %xmm1,%ecx
   19721:	cmp    $0x7f800000,%ecx
   19727:	je     19748 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x358>
   19729:	mov    %ecx,%edx
   1972b:	and    $0x7fffffff,%edx
   19731:	je     1973b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x34b>
   19733:	cmp    %edx,%ecx
   19735:	jne    19742 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x352>
   19737:	inc    %ecx
   19739:	jmp    19744 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x354>
   1973b:	mov    $0x1,%ecx
   19740:	jmp    19744 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x354>
   19742:	dec    %ecx
   19744:	movd   %ecx,%xmm1
   19748:	subss  %xmm0,%xmm3
   1974c:	movd   %xmm3,%ecx
   19750:	ucomiss %xmm3,%xmm3
   19753:	setp   %dl
   19756:	cmp    $0x7f800000,%ecx
   1975c:	sete   %sil
   19760:	or     %dl,%sil
   19763:	jne    19784 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x394>
   19765:	mov    %ecx,%edx
   19767:	and    $0x7fffffff,%edx
   1976d:	je     19777 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x387>
   1976f:	cmp    %edx,%ecx
   19771:	jne    1977e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x38e>
   19773:	inc    %ecx
   19775:	jmp    19780 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x390>
   19777:	mov    $0x1,%ecx
   1977c:	jmp    19780 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x390>
   1977e:	dec    %ecx
   19780:	movd   %ecx,%xmm3
   19784:	subss  %xmm2,%xmm1
   19788:	movd   %xmm1,%ecx
   1978c:	ucomiss %xmm1,%xmm1
   1978f:	setp   %dl
   19792:	cmp    $0x7f800000,%ecx
   19798:	sete   %sil
   1979c:	or     %dl,%sil
   1979f:	jne    197c0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3d0>
   197a1:	mov    %ecx,%edx
   197a3:	and    $0x7fffffff,%edx
   197a9:	je     197b3 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3c3>
   197ab:	cmp    %edx,%ecx
   197ad:	jne    197ba <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3ca>
   197af:	inc    %ecx
   197b1:	jmp    197bc <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3cc>
   197b3:	mov    $0x1,%ecx
   197b8:	jmp    197bc <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3cc>
   197ba:	dec    %ecx
   197bc:	movd   %ecx,%xmm1
   197c0:	movaps %xmm0,%xmm4
   197c3:	addss  %xmm3,%xmm4
   197c7:	movd   %xmm4,%ecx
   197cb:	movaps %xmm2,%xmm4
   197ce:	addss  %xmm1,%xmm4
   197d2:	movd   %xmm4,%edx
   197d6:	movdqa %xmm3,%xmm4
   197da:	punpckldq %xmm1,%xmm4
   197de:	movdqa %xmm0,%xmm5
   197e2:	punpckldq %xmm2,%xmm5
   197e6:	punpcklqdq %xmm4,%xmm5
   197ea:	and    $0x7fffffff,%ecx
   197f0:	cmp    $0x7f800000,%ecx
   197f6:	setl   %cl
   197f9:	and    $0x7fffffff,%edx
   197ff:	cmp    $0x7f800000,%edx
   19805:	setl   %dl
   19808:	pand   -0x13dc0(%rip),%xmm5        # 5a50 <__abi_tag+0x571c>
   19810:	pcmpgtd -0x13f48(%rip),%xmm5        # 58d0 <__abi_tag+0x559c>
   19818:	movmskps %xmm5,%esi
   1981b:	test   %esi,%esi
   1981d:	jne    1950d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   19823:	test   %cl,%cl
   19825:	je     1950d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   1982b:	test   %dl,%dl
   1982d:	je     1950d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   19833:	pxor   %xmm4,%xmm4
   19837:	ucomiss %xmm4,%xmm3
   1983a:	jb     1950d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x11d>
   19840:	ucomiss %xmm4,%xmm1
   19843:	mov    $0x2,%ecx
   19848:	jb     19512 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x122>
   1984e:	movss  %xmm0,0x4(%rax)
   19853:	movss  %xmm2,0x8(%rax)
   19858:	movss  %xmm3,0xc(%rax)
   1985d:	movss  %xmm1,0x10(%rax)
   19862:	mov    $0x1,%ecx
   19867:	mov    %ecx,(%rax)
   19869:	ret
