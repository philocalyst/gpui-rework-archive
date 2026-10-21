
/tmp/gpui-bounds-provenance-candidate-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000017db0 <bounds_provenance_copies::make>:
   17db0:	cvtps2pd (%rsi),%xmm0
   17db3:	movups %xmm0,(%rdi)
   17db6:	cvtps2pd 0x8(%rsi),%xmm0
   17dba:	movups %xmm0,0x10(%rdi)
   17dbe:	cvtps2pd 0x10(%rsi),%xmm0
   17dc2:	movups %xmm0,0x20(%rdi)
   17dc6:	movb   $0x0,0x30(%rdi)
   17dca:	ret


/tmp/gpui-bounds-provenance-candidate-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000017e50 <bounds_provenance_copies::compose>:
   17e50:	jmp    *0x48f72(%rip)        # 60dc8 <_DYNAMIC+0x2c8>


/tmp/gpui-bounds-provenance-candidate-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000017dd0 <bounds_provenance_copies::same>:
   17dd0:	movsd  (%rdi),%xmm0
   17dd4:	ucomisd (%rsi),%xmm0
   17dd8:	jne    17e33 <bounds_provenance_copies::same+0x63>
   17dda:	jp     17e33 <bounds_provenance_copies::same+0x63>
   17ddc:	movsd  0x8(%rdi),%xmm0
   17de1:	ucomisd 0x8(%rsi),%xmm0
   17de6:	jne    17e33 <bounds_provenance_copies::same+0x63>
   17de8:	jp     17e33 <bounds_provenance_copies::same+0x63>
   17dea:	movsd  0x10(%rdi),%xmm0
   17def:	ucomisd 0x10(%rsi),%xmm0
   17df4:	jne    17e33 <bounds_provenance_copies::same+0x63>
   17df6:	jp     17e33 <bounds_provenance_copies::same+0x63>
   17df8:	movsd  0x18(%rdi),%xmm0
   17dfd:	ucomisd 0x18(%rsi),%xmm0
   17e02:	jne    17e33 <bounds_provenance_copies::same+0x63>
   17e04:	jp     17e33 <bounds_provenance_copies::same+0x63>
   17e06:	movsd  0x20(%rdi),%xmm0
   17e0b:	ucomisd 0x20(%rsi),%xmm0
   17e10:	jne    17e33 <bounds_provenance_copies::same+0x63>
   17e12:	jp     17e33 <bounds_provenance_copies::same+0x63>
   17e14:	movsd  0x28(%rdi),%xmm0
   17e19:	ucomisd 0x28(%rsi),%xmm0
   17e1e:	jne    17e33 <bounds_provenance_copies::same+0x63>
   17e20:	jp     17e33 <bounds_provenance_copies::same+0x63>
   17e22:	cmpb   $0x2,0x30(%rdi)
   17e26:	sete   %cl
   17e29:	cmpb   $0x2,0x30(%rsi)
   17e2d:	setne  %al
   17e30:	xor    %cl,%al
   17e32:	ret
   17e33:	xor    %eax,%eax
   17e35:	ret


/tmp/gpui-bounds-provenance-candidate-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000017040 <bounds_provenance_copies::copy>:
   17040:	mov    0x30(%rsi),%rax
   17044:	mov    %rax,0x30(%rdi)
   17048:	movups (%rsi),%xmm0
   1704b:	movups 0x10(%rsi),%xmm1
   1704f:	movups 0x20(%rsi),%xmm2
   17053:	movups %xmm2,0x20(%rdi)
   17057:	movups %xmm1,0x10(%rdi)
   1705b:	movups %xmm0,(%rdi)
   1705e:	ret


/tmp/gpui-bounds-provenance-candidate-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000017e40 <bounds_provenance_copies::bounds>:
   17e40:	jmp    *0x48f7a(%rip)        # 60dc0 <_DYNAMIC+0x2c0>


/tmp/gpui-bounds-provenance-candidate-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000019930 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose>:
   19930:	mov    %rdi,%rax
   19933:	movq   0x20(%rsi),%xmm0
   19938:	movss  0x10(%rdx),%xmm1
   1993d:	movss  0x14(%rdx),%xmm2
   19942:	cvtps2pd (%rdx),%xmm9
   19946:	cvtps2pd 0x8(%rdx),%xmm8
   1994b:	cvtss2sd %xmm1,%xmm5
   1994f:	cvtss2sd %xmm2,%xmm3
   19953:	movq   0x28(%rsi),%xmm1
   19958:	movupd (%rsi),%xmm4
   1995c:	movupd 0x10(%rsi),%xmm2
   19961:	movapd %xmm9,%xmm7
   19966:	unpcklpd %xmm9,%xmm7
   1996b:	mulpd  %xmm4,%xmm7
   1996f:	movapd %xmm9,%xmm6
   19974:	unpckhpd %xmm9,%xmm6
   19979:	mulpd  %xmm2,%xmm6
   1997d:	addpd  %xmm7,%xmm6
   19981:	movapd %xmm8,%xmm10
   19986:	unpcklpd %xmm8,%xmm10
   1998b:	mulpd  %xmm4,%xmm10
   19990:	movapd %xmm8,%xmm7
   19995:	unpckhpd %xmm8,%xmm7
   1999a:	mulpd  %xmm2,%xmm7
   1999e:	addpd  %xmm10,%xmm7
   199a3:	mov    $0x2,%cl
   199a5:	cmpb   $0x2,0x30(%rsi)
   199a9:	je     19ac0 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x190>
   199af:	movapd %xmm6,%xmm11
   199b4:	unpckhpd %xmm6,%xmm11
   199b9:	mulsd  %xmm7,%xmm11
   199be:	movapd %xmm7,%xmm10
   199c3:	unpckhpd %xmm7,%xmm10
   199c8:	mulsd  %xmm6,%xmm10
   199cd:	subsd  %xmm11,%xmm10
   199d2:	movq   %xmm0,%rdi
   199d7:	movabs $0x7fffffffffffffff,%rdx
   199e1:	and    %rdx,%rdi
   199e4:	movabs $0x7fefffffffffffff,%rsi
   199ee:	cmp    %rsi,%rdi
   199f1:	setg   %dil
   199f5:	movq   %xmm1,%r8
   199fa:	and    %rdx,%r8
   199fd:	cmp    %rsi,%r8
   19a00:	movapd %xmm4,%xmm11
   19a05:	shufps $0xdd,%xmm2,%xmm11
   19a0a:	andps  -0x13fc2(%rip),%xmm11        # 5a50 <__abi_tag+0x571c>
   19a12:	setg   %r8b
   19a16:	pcmpgtd -0x1402f(%rip),%xmm11        # 59f0 <__abi_tag+0x56bc>
   19a1f:	movmskps %xmm11,%r9d
   19a23:	test   %r9d,%r9d
   19a26:	setne  %r9b
   19a2a:	or     %dil,%r8b
   19a2d:	or     %r9b,%r8b
   19a30:	jne    19ab1 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x181>
   19a32:	movapd %xmm2,%xmm11
   19a37:	shufpd $0x1,%xmm2,%xmm11
   19a3d:	mulpd  %xmm4,%xmm11
   19a42:	movapd %xmm11,%xmm12
   19a47:	unpckhpd %xmm11,%xmm12
   19a4c:	subsd  %xmm12,%xmm11
   19a51:	xorpd  %xmm12,%xmm12
   19a56:	ucomisd %xmm12,%xmm11
   19a5b:	jne    19a5f <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x12f>
   19a5d:	jnp    19ab1 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x181>
   19a5f:	shufpd $0x1,%xmm8,%xmm8
   19a65:	movq   %xmm5,%rdi
   19a6a:	and    %rdx,%rdi
   19a6d:	cmp    %rsi,%rdi
   19a70:	setg   %dil
   19a74:	movq   %xmm3,%r8
   19a79:	and    %rdx,%r8
   19a7c:	cmp    %rsi,%r8
   19a7f:	movapd %xmm9,%xmm11
   19a84:	shufps $0xdd,%xmm8,%xmm11
   19a89:	andps  -0x14041(%rip),%xmm11        # 5a50 <__abi_tag+0x571c>
   19a91:	setg   %r8b
   19a95:	pcmpgtd -0x140ae(%rip),%xmm11        # 59f0 <__abi_tag+0x56bc>
   19a9e:	movmskps %xmm11,%r9d
   19aa2:	test   %r9d,%r9d
   19aa5:	setne  %r9b
   19aa9:	or     %dil,%r8b
   19aac:	or     %r9b,%r8b
   19aaf:	je     19b0f <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x1df>
   19ab1:	movq   %xmm10,%rdi
   19ab6:	and    %rdx,%rdi
   19ab9:	cmp    %rsi,%rdi
   19abc:	jg     19ac0 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x190>
   19abe:	mov    $0x1,%cl
   19ac0:	movapd %xmm4,%xmm8
   19ac5:	unpckhpd %xmm4,%xmm8
   19aca:	mulsd  %xmm5,%xmm8
   19acf:	movapd %xmm2,%xmm9
   19ad4:	unpckhpd %xmm2,%xmm9
   19ad9:	mulsd  %xmm3,%xmm9
   19ade:	addsd  %xmm8,%xmm9
   19ae3:	addsd  %xmm9,%xmm1
   19ae8:	mulsd  %xmm5,%xmm4
   19aec:	mulsd  %xmm3,%xmm2
   19af0:	addsd  %xmm4,%xmm2
   19af4:	addsd  %xmm2,%xmm0
   19af8:	movupd %xmm6,(%rax)
   19afc:	movupd %xmm7,0x10(%rax)
   19b01:	movsd  %xmm0,0x20(%rax)
   19b06:	movsd  %xmm1,0x28(%rax)
   19b0b:	mov    %cl,0x30(%rax)
   19b0e:	ret
   19b0f:	mulpd  %xmm9,%xmm8
   19b14:	movapd %xmm8,%xmm9
   19b19:	unpckhpd %xmm8,%xmm9
   19b1e:	movq   %xmm10,%rdi
   19b23:	subsd  %xmm9,%xmm8
   19b28:	xorpd  %xmm9,%xmm9
   19b2d:	cmpneqsd %xmm9,%xmm8
   19b33:	cmpeqsd %xmm9,%xmm10
   19b39:	andpd  %xmm8,%xmm10
   19b3e:	movd   %xmm10,%r8d
   19b43:	and    %rdx,%rdi
   19b46:	cmp    %rsi,%rdi
   19b49:	setg   %dl
   19b4c:	test   $0x1,%r8b
   19b50:	jne    19ac0 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x190>
   19b56:	test   %dl,%dl
   19b58:	je     19abe <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x18e>
   19b5e:	jmp    19ac0 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x190>


/tmp/gpui-bounds-provenance-candidate-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000019400 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds>:
   19400:	mov    %rdi,%rax
   19403:	movups (%rdx),%xmm1
   19406:	movaps %xmm1,%xmm2
   19409:	unpckhpd %xmm1,%xmm2
   1940d:	movaps %xmm1,%xmm0
   19410:	addps  %xmm2,%xmm0
   19413:	movaps -0x139ca(%rip),%xmm3        # 5a50 <__abi_tag+0x571c>
   1941a:	movaps %xmm1,%xmm4
   1941d:	andps  %xmm3,%xmm4
   19420:	movaps %xmm1,%xmm5
   19423:	movlps -0x13b4a(%rip),%xmm5        # 58e0 <__abi_tag+0x55ac>
   1942a:	andps  %xmm3,%xmm0
   1942d:	movaps -0x13a94(%rip),%xmm3        # 59a0 <__abi_tag+0x566c>
   19434:	movq   %xmm0,%xmm0
   19438:	movaps %xmm3,%xmm6
   1943b:	cmpneqps %xmm4,%xmm6
   1943f:	cmpordps %xmm3,%xmm4
   19443:	andps  %xmm6,%xmm4
   19446:	movaps %xmm5,%xmm3
   19449:	cmpneqps %xmm0,%xmm3
   1944d:	movaps %xmm5,%xmm6
   19450:	cmpordps %xmm0,%xmm6
   19454:	andps  %xmm3,%xmm6
   19457:	packssdw %xmm6,%xmm4
   1945b:	cmpleps %xmm5,%xmm0
   1945f:	pshufhw $0x84,%xmm0,%xmm0
   19464:	shufps $0x23,%xmm4,%xmm0
   19468:	shufps $0x24,%xmm0,%xmm4
   1946c:	packsswb %xmm4,%xmm4
   19470:	pmovmskb %xmm4,%ecx
   19474:	cmp    $0xff,%cl
   19477:	jne    194ee <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   19479:	movzbl 0x30(%rsi),%ecx
   1947d:	cmp    $0x2,%cl
   19480:	je     194ee <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   19482:	movups (%rsi),%xmm4
   19485:	movups 0x10(%rsi),%xmm3
   19489:	movdqu 0x20(%rsi),%xmm0
   1948e:	movq   %xmm0,%rdx
   19493:	movabs $0x7fffffffffffffff,%rsi
   1949d:	and    %rsi,%rdx
   194a0:	movabs $0x7fefffffffffffff,%rdi
   194aa:	cmp    %rdi,%rdx
   194ad:	setg   %dl
   194b0:	movdqa %xmm0,%xmm5
   194b4:	punpckhqdq %xmm0,%xmm5
   194b8:	movq   %xmm5,%r8
   194bd:	and    %rsi,%r8
   194c0:	cmp    %rdi,%r8
   194c3:	movaps %xmm4,%xmm5
   194c6:	shufps $0xdd,%xmm3,%xmm5
   194ca:	andps  -0x13a81(%rip),%xmm5        # 5a50 <__abi_tag+0x571c>
   194d1:	setg   %sil
   194d5:	pcmpgtd -0x13aed(%rip),%xmm5        # 59f0 <__abi_tag+0x56bc>
   194dd:	movmskps %xmm5,%edi
   194e0:	test   %edi,%edi
   194e2:	setne  %dil
   194e6:	or     %dl,%sil
   194e9:	or     %dil,%sil
   194ec:	je     194f6 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf6>
   194ee:	mov    $0x2,%edx
   194f3:	mov    %edx,(%rax)
   194f5:	ret
   194f6:	xor    %edx,%edx
   194f8:	xorps  %xmm5,%xmm5
   194fb:	ucomiss %xmm5,%xmm2
   194fe:	jne    19502 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x102>
   19500:	jnp    194f3 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf3>
   19502:	movaps %xmm1,%xmm7
   19505:	shufps $0xff,%xmm1,%xmm7
   19509:	ucomiss %xmm5,%xmm7
   1950c:	jne    19510 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x110>
   1950e:	jnp    194f3 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf3>
   19510:	movaps %xmm3,%xmm5
   19513:	shufps $0x4e,%xmm3,%xmm5
   19517:	mulpd  %xmm4,%xmm5
   1951b:	movapd %xmm5,%xmm6
   1951f:	unpckhpd %xmm5,%xmm6
   19523:	subsd  %xmm6,%xmm5
   19527:	xorpd  %xmm6,%xmm6
   1952b:	ucomisd %xmm6,%xmm5
   1952f:	jne    19533 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x133>
   19531:	jnp    194f3 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf3>
   19533:	xorps  %xmm5,%xmm5
   19536:	cvtss2sd %xmm1,%xmm5
   1953a:	shufps $0x55,%xmm1,%xmm1
   1953e:	cvtss2sd %xmm1,%xmm1
   19542:	xorps  %xmm6,%xmm6
   19545:	cvtss2sd %xmm2,%xmm6
   19549:	addsd  %xmm5,%xmm6
   1954d:	cvtss2sd %xmm7,%xmm2
   19551:	addsd  %xmm1,%xmm2
   19555:	test   %cl,%cl
   19557:	je     19670 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x270>
   1955d:	unpcklpd %xmm5,%xmm5
   19561:	mulpd  %xmm4,%xmm5
   19565:	unpcklpd %xmm1,%xmm1
   19569:	mulpd  %xmm3,%xmm1
   1956d:	unpcklpd %xmm6,%xmm6
   19571:	mulpd  %xmm4,%xmm6
   19575:	unpcklpd %xmm2,%xmm2
   19579:	mulpd  %xmm3,%xmm2
   1957d:	movapd %xmm5,%xmm3
   19581:	addpd  %xmm1,%xmm3
   19585:	addpd  %xmm0,%xmm3
   19589:	movapd %xmm3,%xmm4
   1958d:	minpd  -0x13ad5(%rip),%xmm4        # 5ac0 <__abi_tag+0x578c>
   19595:	addpd  %xmm6,%xmm1
   19599:	addpd  %xmm0,%xmm1
   1959d:	movapd %xmm4,%xmm7
   195a1:	minpd  %xmm1,%xmm7
   195a5:	movapd %xmm7,%xmm8
   195aa:	cmpunordpd %xmm7,%xmm8
   195b0:	andpd  %xmm8,%xmm4
   195b5:	andnpd %xmm7,%xmm8
   195ba:	orpd   %xmm4,%xmm8
   195bf:	addpd  %xmm2,%xmm5
   195c3:	addpd  %xmm0,%xmm5
   195c7:	movapd %xmm8,%xmm7
   195cc:	minpd  %xmm5,%xmm7
   195d0:	movapd %xmm7,%xmm4
   195d4:	cmpunordpd %xmm7,%xmm4
   195d9:	andpd  %xmm4,%xmm8
   195de:	andnpd %xmm7,%xmm4
   195e2:	orpd   %xmm8,%xmm4
   195e7:	maxpd  -0x13b4f(%rip),%xmm3        # 5aa0 <__abi_tag+0x576c>
   195ef:	movapd %xmm3,%xmm7
   195f3:	maxpd  %xmm1,%xmm7
   195f7:	movapd %xmm7,%xmm1
   195fb:	cmpunordpd %xmm7,%xmm1
   19600:	andpd  %xmm1,%xmm3
   19604:	andnpd %xmm7,%xmm1
   19608:	orpd   %xmm3,%xmm1
   1960c:	movapd %xmm1,%xmm3
   19610:	maxpd  %xmm5,%xmm3
   19614:	movapd %xmm3,%xmm5
   19618:	cmpunordpd %xmm3,%xmm5
   1961d:	andpd  %xmm5,%xmm1
   19621:	andnpd %xmm3,%xmm5
   19625:	orpd   %xmm1,%xmm5
   19629:	addpd  %xmm6,%xmm2
   1962d:	addpd  %xmm0,%xmm2
   19631:	movapd %xmm4,%xmm0
   19635:	minpd  %xmm2,%xmm0
   19639:	movapd %xmm0,%xmm3
   1963d:	cmpunordpd %xmm0,%xmm3
   19642:	andpd  %xmm3,%xmm4
   19646:	andnpd %xmm0,%xmm3
   1964a:	orpd   %xmm4,%xmm3
   1964e:	movapd %xmm5,%xmm0
   19652:	maxpd  %xmm2,%xmm0
   19656:	movapd %xmm0,%xmm1
   1965a:	cmpunordpd %xmm0,%xmm1
   1965f:	andpd  %xmm1,%xmm5
   19663:	andnpd %xmm0,%xmm1
   19667:	orpd   %xmm5,%xmm1
   1966b:	jmp    1970c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x30c>
   19670:	xorpd  %xmm9,%xmm9
   19675:	movapd %xmm4,%xmm8
   1967a:	cmpltpd %xmm9,%xmm8
   19680:	movapd %xmm3,%xmm7
   19684:	cmpltpd %xmm9,%xmm7
   1968a:	unpcklpd %xmm6,%xmm6
   1968e:	unpcklpd %xmm5,%xmm5
   19692:	movapd %xmm8,%xmm9
   19697:	andnpd %xmm5,%xmm9
   1969c:	movapd %xmm8,%xmm10
   196a1:	andnpd %xmm6,%xmm10
   196a6:	andpd  %xmm8,%xmm6
   196ab:	orpd   %xmm9,%xmm6
   196b0:	unpcklpd %xmm2,%xmm2
   196b4:	unpcklpd %xmm1,%xmm1
   196b8:	movapd %xmm7,%xmm9
   196bd:	andnpd %xmm1,%xmm9
   196c2:	movapd %xmm7,%xmm11
   196c7:	andnpd %xmm2,%xmm11
   196cc:	andpd  %xmm7,%xmm2
   196d0:	orpd   %xmm9,%xmm2
   196d5:	mulpd  %xmm4,%xmm6
   196d9:	mulpd  %xmm3,%xmm2
   196dd:	addpd  %xmm6,%xmm2
   196e1:	addpd  %xmm0,%xmm2
   196e5:	andpd  %xmm8,%xmm5
   196ea:	orpd   %xmm10,%xmm5
   196ef:	andpd  %xmm7,%xmm1
   196f3:	orpd   %xmm11,%xmm1
   196f8:	mulpd  %xmm4,%xmm5
   196fc:	mulpd  %xmm3,%xmm1
   19700:	addpd  %xmm5,%xmm1
   19704:	addpd  %xmm0,%xmm1
   19708:	movapd %xmm2,%xmm3
   1970c:	xorps  %xmm0,%xmm0
   1970f:	cvtsd2ss %xmm3,%xmm0
   19713:	movd   %xmm0,%ecx
   19717:	ucomiss %xmm0,%xmm0
   1971a:	setp   %dl
   1971d:	cmp    $0xff800000,%ecx
   19723:	sete   %sil
   19727:	or     %dl,%sil
   1972a:	jne    1974b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x34b>
   1972c:	mov    %ecx,%edx
   1972e:	and    $0x7fffffff,%edx
   19734:	je     1973e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x33e>
   19736:	cmp    %edx,%ecx
   19738:	jne    19745 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x345>
   1973a:	dec    %ecx
   1973c:	jmp    19747 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x347>
   1973e:	mov    $0x80000001,%ecx
   19743:	jmp    19747 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x347>
   19745:	inc    %ecx
   19747:	movd   %ecx,%xmm0
   1974b:	movhlps %xmm3,%xmm3
   1974e:	xorps  %xmm2,%xmm2
   19751:	cvtsd2ss %xmm3,%xmm2
   19755:	movd   %xmm2,%ecx
   19759:	ucomiss %xmm2,%xmm2
   1975c:	setp   %dl
   1975f:	cmp    $0xff800000,%ecx
   19765:	sete   %sil
   19769:	or     %dl,%sil
   1976c:	jne    1978d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x38d>
   1976e:	mov    %ecx,%edx
   19770:	and    $0x7fffffff,%edx
   19776:	je     19780 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x380>
   19778:	cmp    %edx,%ecx
   1977a:	jne    19787 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x387>
   1977c:	dec    %ecx
   1977e:	jmp    19789 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x389>
   19780:	mov    $0x80000001,%ecx
   19785:	jmp    19789 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x389>
   19787:	inc    %ecx
   19789:	movd   %ecx,%xmm2
   1978d:	xorps  %xmm3,%xmm3
   19790:	cvtsd2ss %xmm1,%xmm3
   19794:	movd   %xmm3,%ecx
   19798:	ucomiss %xmm3,%xmm3
   1979b:	setp   %dl
   1979e:	cmp    $0x7f800000,%ecx
   197a4:	sete   %sil
   197a8:	or     %dl,%sil
   197ab:	jne    197cc <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3cc>
   197ad:	mov    %ecx,%edx
   197af:	and    $0x7fffffff,%edx
   197b5:	je     197bf <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3bf>
   197b7:	cmp    %edx,%ecx
   197b9:	jne    197c6 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3c6>
   197bb:	inc    %ecx
   197bd:	jmp    197c8 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3c8>
   197bf:	mov    $0x1,%ecx
   197c4:	jmp    197c8 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3c8>
   197c6:	dec    %ecx
   197c8:	movd   %ecx,%xmm3
   197cc:	movhlps %xmm1,%xmm1
   197cf:	cvtsd2ss %xmm1,%xmm1
   197d3:	movd   %xmm1,%ecx
   197d7:	ucomiss %xmm1,%xmm1
   197da:	setp   %dl
   197dd:	cmp    $0x7f800000,%ecx
   197e3:	sete   %sil
   197e7:	or     %dl,%sil
   197ea:	jne    1980b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x40b>
   197ec:	mov    %ecx,%edx
   197ee:	and    $0x7fffffff,%edx
   197f4:	je     197fe <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3fe>
   197f6:	cmp    %edx,%ecx
   197f8:	jne    19805 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x405>
   197fa:	inc    %ecx
   197fc:	jmp    19807 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x407>
   197fe:	mov    $0x1,%ecx
   19803:	jmp    19807 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x407>
   19805:	dec    %ecx
   19807:	movd   %ecx,%xmm1
   1980b:	subss  %xmm0,%xmm3
   1980f:	movd   %xmm3,%ecx
   19813:	ucomiss %xmm3,%xmm3
   19816:	setp   %dl
   19819:	cmp    $0x7f800000,%ecx
   1981f:	sete   %sil
   19823:	or     %dl,%sil
   19826:	jne    19847 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x447>
   19828:	mov    %ecx,%edx
   1982a:	and    $0x7fffffff,%edx
   19830:	je     1983a <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x43a>
   19832:	cmp    %edx,%ecx
   19834:	jne    19841 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x441>
   19836:	inc    %ecx
   19838:	jmp    19843 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x443>
   1983a:	mov    $0x1,%ecx
   1983f:	jmp    19843 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x443>
   19841:	dec    %ecx
   19843:	movd   %ecx,%xmm3
   19847:	subss  %xmm2,%xmm1
   1984b:	movd   %xmm1,%ecx
   1984f:	ucomiss %xmm1,%xmm1
   19852:	setp   %dl
   19855:	cmp    $0x7f800000,%ecx
   1985b:	sete   %sil
   1985f:	or     %dl,%sil
   19862:	jne    19883 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x483>
   19864:	mov    %ecx,%edx
   19866:	and    $0x7fffffff,%edx
   1986c:	je     19876 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x476>
   1986e:	cmp    %edx,%ecx
   19870:	jne    1987d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x47d>
   19872:	inc    %ecx
   19874:	jmp    1987f <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x47f>
   19876:	mov    $0x1,%ecx
   1987b:	jmp    1987f <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x47f>
   1987d:	dec    %ecx
   1987f:	movd   %ecx,%xmm1
   19883:	movaps %xmm0,%xmm4
   19886:	addss  %xmm3,%xmm4
   1988a:	movd   %xmm4,%ecx
   1988e:	movaps %xmm2,%xmm4
   19891:	addss  %xmm1,%xmm4
   19895:	movd   %xmm4,%edx
   19899:	movdqa %xmm3,%xmm4
   1989d:	punpckldq %xmm1,%xmm4
   198a1:	movdqa %xmm0,%xmm5
   198a5:	punpckldq %xmm2,%xmm5
   198a9:	punpcklqdq %xmm4,%xmm5
   198ad:	and    $0x7fffffff,%ecx
   198b3:	cmp    $0x7f800000,%ecx
   198b9:	setl   %cl
   198bc:	and    $0x7fffffff,%edx
   198c2:	cmp    $0x7f800000,%edx
   198c8:	setl   %dl
   198cb:	pand   -0x13e83(%rip),%xmm5        # 5a50 <__abi_tag+0x571c>
   198d3:	pcmpgtd -0x1400b(%rip),%xmm5        # 58d0 <__abi_tag+0x559c>
   198db:	movmskps %xmm5,%esi
   198de:	test   %esi,%esi
   198e0:	jne    194ee <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   198e6:	test   %cl,%cl
   198e8:	je     194ee <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   198ee:	test   %dl,%dl
   198f0:	je     194ee <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   198f6:	pxor   %xmm4,%xmm4
   198fa:	ucomiss %xmm4,%xmm3
   198fd:	jb     194ee <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   19903:	ucomiss %xmm4,%xmm1
   19906:	mov    $0x2,%edx
   1990b:	jb     194f3 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf3>
   19911:	movss  %xmm0,0x4(%rax)
   19916:	movss  %xmm2,0x8(%rax)
   1991b:	movss  %xmm3,0xc(%rax)
   19920:	movss  %xmm1,0x10(%rax)
   19925:	mov    $0x1,%edx
   1992a:	mov    %edx,(%rax)
   1992c:	ret
