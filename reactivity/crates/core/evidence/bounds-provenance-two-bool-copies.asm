
/tmp/gpui-bounds-provenance-bool-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000017db0 <bounds_provenance_copies::make>:
   17db0:	cvtps2pd (%rsi),%xmm0
   17db3:	movups %xmm0,(%rdi)
   17db6:	cvtps2pd 0x8(%rsi),%xmm0
   17dba:	movups %xmm0,0x10(%rdi)
   17dbe:	cvtps2pd 0x10(%rsi),%xmm0
   17dc2:	movups %xmm0,0x20(%rdi)
   17dc6:	movw   $0x100,0x30(%rdi)
   17dcc:	ret


/tmp/gpui-bounds-provenance-bool-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000017e50 <bounds_provenance_copies::compose>:
   17e50:	jmp    *0x48fa2(%rip)        # 60df8 <_DYNAMIC+0x2c8>


/tmp/gpui-bounds-provenance-bool-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000017dd0 <bounds_provenance_copies::same>:
   17dd0:	movsd  (%rdi),%xmm0
   17dd4:	ucomisd (%rsi),%xmm0
   17dd8:	jne    17e26 <bounds_provenance_copies::same+0x56>
   17dda:	jp     17e26 <bounds_provenance_copies::same+0x56>
   17ddc:	movsd  0x8(%rdi),%xmm0
   17de1:	ucomisd 0x8(%rsi),%xmm0
   17de6:	jne    17e26 <bounds_provenance_copies::same+0x56>
   17de8:	jp     17e26 <bounds_provenance_copies::same+0x56>
   17dea:	movsd  0x10(%rdi),%xmm0
   17def:	ucomisd 0x10(%rsi),%xmm0
   17df4:	jne    17e26 <bounds_provenance_copies::same+0x56>
   17df6:	jp     17e26 <bounds_provenance_copies::same+0x56>
   17df8:	movsd  0x18(%rdi),%xmm0
   17dfd:	ucomisd 0x18(%rsi),%xmm0
   17e02:	jne    17e26 <bounds_provenance_copies::same+0x56>
   17e04:	jp     17e26 <bounds_provenance_copies::same+0x56>
   17e06:	movsd  0x20(%rdi),%xmm0
   17e0b:	ucomisd 0x20(%rsi),%xmm0
   17e10:	jne    17e26 <bounds_provenance_copies::same+0x56>
   17e12:	jp     17e26 <bounds_provenance_copies::same+0x56>
   17e14:	movsd  0x28(%rdi),%xmm0
   17e19:	ucomisd 0x28(%rsi),%xmm0
   17e1e:	jne    17e26 <bounds_provenance_copies::same+0x56>
   17e20:	jp     17e26 <bounds_provenance_copies::same+0x56>
   17e22:	mov    $0x1,%cl
   17e24:	jmp    17e28 <bounds_provenance_copies::same+0x58>
   17e26:	xor    %ecx,%ecx
   17e28:	movzbl 0x30(%rsi),%eax
   17e2c:	cmp    %al,0x30(%rdi)
   17e2f:	sete   %al
   17e32:	and    %cl,%al
   17e34:	ret


/tmp/gpui-bounds-provenance-bool-copies:     file format elf64-x86-64


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


/tmp/gpui-bounds-provenance-bool-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000017e40 <bounds_provenance_copies::bounds>:
   17e40:	jmp    *0x48faa(%rip)        # 60df0 <_DYNAMIC+0x2c0>


/tmp/gpui-bounds-provenance-bool-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000019980 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose>:
   19980:	mov    %rdi,%rax
   19983:	movq   0x20(%rsi),%xmm0
   19988:	movss  0x10(%rdx),%xmm1
   1998d:	movss  0x14(%rdx),%xmm2
   19992:	cvtps2pd (%rdx),%xmm9
   19996:	cvtps2pd 0x8(%rdx),%xmm8
   1999b:	cvtss2sd %xmm1,%xmm5
   1999f:	cvtss2sd %xmm2,%xmm3
   199a3:	movq   0x28(%rsi),%xmm1
   199a8:	movupd (%rsi),%xmm4
   199ac:	movupd 0x10(%rsi),%xmm2
   199b1:	movapd %xmm9,%xmm7
   199b6:	unpcklpd %xmm9,%xmm7
   199bb:	mulpd  %xmm4,%xmm7
   199bf:	movapd %xmm9,%xmm6
   199c4:	unpckhpd %xmm9,%xmm6
   199c9:	mulpd  %xmm2,%xmm6
   199cd:	addpd  %xmm7,%xmm6
   199d1:	movapd %xmm8,%xmm10
   199d6:	unpcklpd %xmm8,%xmm10
   199db:	mulpd  %xmm4,%xmm10
   199e0:	movapd %xmm8,%xmm7
   199e5:	unpckhpd %xmm8,%xmm7
   199ea:	mulpd  %xmm2,%xmm7
   199ee:	addpd  %xmm10,%xmm7
   199f3:	mov    $0x1,%cl
   199f5:	cmpb   $0x0,0x30(%rsi)
   199f9:	jne    19b0f <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x18f>
   199ff:	movapd %xmm6,%xmm11
   19a04:	unpckhpd %xmm6,%xmm11
   19a09:	mulsd  %xmm7,%xmm11
   19a0e:	movapd %xmm7,%xmm10
   19a13:	unpckhpd %xmm7,%xmm10
   19a18:	mulsd  %xmm6,%xmm10
   19a1d:	subsd  %xmm11,%xmm10
   19a22:	movq   %xmm0,%rdi
   19a27:	movabs $0x7fffffffffffffff,%rdx
   19a31:	and    %rdx,%rdi
   19a34:	movabs $0x7fefffffffffffff,%rsi
   19a3e:	cmp    %rsi,%rdi
   19a41:	setg   %dil
   19a45:	movq   %xmm1,%r8
   19a4a:	and    %rdx,%r8
   19a4d:	cmp    %rsi,%r8
   19a50:	movapd %xmm4,%xmm11
   19a55:	shufps $0xdd,%xmm2,%xmm11
   19a5a:	andps  -0x14012(%rip),%xmm11        # 5a50 <__abi_tag+0x571c>
   19a62:	setg   %r8b
   19a66:	pcmpgtd -0x1407f(%rip),%xmm11        # 59f0 <__abi_tag+0x56bc>
   19a6f:	movmskps %xmm11,%r9d
   19a73:	test   %r9d,%r9d
   19a76:	setne  %r9b
   19a7a:	or     %dil,%r8b
   19a7d:	or     %r9b,%r8b
   19a80:	jne    19b01 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x181>
   19a82:	movapd %xmm2,%xmm11
   19a87:	shufpd $0x1,%xmm2,%xmm11
   19a8d:	mulpd  %xmm4,%xmm11
   19a92:	movapd %xmm11,%xmm12
   19a97:	unpckhpd %xmm11,%xmm12
   19a9c:	subsd  %xmm12,%xmm11
   19aa1:	xorpd  %xmm12,%xmm12
   19aa6:	ucomisd %xmm12,%xmm11
   19aab:	jne    19aaf <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x12f>
   19aad:	jnp    19b01 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x181>
   19aaf:	shufpd $0x1,%xmm8,%xmm8
   19ab5:	movq   %xmm5,%rdi
   19aba:	and    %rdx,%rdi
   19abd:	cmp    %rsi,%rdi
   19ac0:	setg   %dil
   19ac4:	movq   %xmm3,%r8
   19ac9:	and    %rdx,%r8
   19acc:	cmp    %rsi,%r8
   19acf:	movapd %xmm9,%xmm11
   19ad4:	shufps $0xdd,%xmm8,%xmm11
   19ad9:	andps  -0x14091(%rip),%xmm11        # 5a50 <__abi_tag+0x571c>
   19ae1:	setg   %r8b
   19ae5:	pcmpgtd -0x140fe(%rip),%xmm11        # 59f0 <__abi_tag+0x56bc>
   19aee:	movmskps %xmm11,%r9d
   19af2:	test   %r9d,%r9d
   19af5:	setne  %r9b
   19af9:	or     %dil,%r8b
   19afc:	or     %r9b,%r8b
   19aff:	je     19b62 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x1e2>
   19b01:	movq   %xmm10,%rcx
   19b06:	and    %rdx,%rcx
   19b09:	cmp    %rsi,%rcx
   19b0c:	setg   %cl
   19b0f:	movapd %xmm4,%xmm8
   19b14:	unpckhpd %xmm4,%xmm8
   19b19:	mulsd  %xmm5,%xmm8
   19b1e:	movapd %xmm2,%xmm9
   19b23:	unpckhpd %xmm2,%xmm9
   19b28:	mulsd  %xmm3,%xmm9
   19b2d:	addsd  %xmm8,%xmm9
   19b32:	addsd  %xmm9,%xmm1
   19b37:	mulsd  %xmm5,%xmm4
   19b3b:	mulsd  %xmm3,%xmm2
   19b3f:	addsd  %xmm4,%xmm2
   19b43:	addsd  %xmm2,%xmm0
   19b47:	movupd %xmm6,(%rax)
   19b4b:	movupd %xmm7,0x10(%rax)
   19b50:	movsd  %xmm0,0x20(%rax)
   19b55:	movsd  %xmm1,0x28(%rax)
   19b5a:	mov    %cl,0x30(%rax)
   19b5d:	movb   $0x0,0x31(%rax)
   19b61:	ret
   19b62:	mulpd  %xmm9,%xmm8
   19b67:	movapd %xmm8,%xmm9
   19b6c:	unpckhpd %xmm8,%xmm9
   19b71:	subsd  %xmm9,%xmm8
   19b76:	xorpd  %xmm9,%xmm9
   19b7b:	ucomisd %xmm9,%xmm8
   19b80:	jne    19b88 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x208>
   19b82:	jnp    19b01 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x181>
   19b88:	ucomisd %xmm9,%xmm10
   19b8d:	jne    19b01 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x181>
   19b93:	jnp    19b0f <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x18f>
   19b99:	jmp    19b01 <<gpui_reactivity_core::geometry::CoordinateSpace>::compose+0x181>


/tmp/gpui-bounds-provenance-bool-copies:     file format elf64-x86-64


Disassembly of section .text:

0000000000019450 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds>:
   19450:	mov    %rdi,%rax
   19453:	movups (%rdx),%xmm1
   19456:	movaps %xmm1,%xmm2
   19459:	unpckhpd %xmm1,%xmm2
   1945d:	movaps %xmm1,%xmm0
   19460:	addps  %xmm2,%xmm0
   19463:	movaps -0x13a1a(%rip),%xmm3        # 5a50 <__abi_tag+0x571c>
   1946a:	movaps %xmm1,%xmm4
   1946d:	andps  %xmm3,%xmm4
   19470:	movaps %xmm1,%xmm5
   19473:	movlps -0x13b9a(%rip),%xmm5        # 58e0 <__abi_tag+0x55ac>
   1947a:	andps  %xmm3,%xmm0
   1947d:	movaps -0x13ae4(%rip),%xmm3        # 59a0 <__abi_tag+0x566c>
   19484:	movq   %xmm0,%xmm0
   19488:	movaps %xmm3,%xmm6
   1948b:	cmpneqps %xmm4,%xmm6
   1948f:	cmpordps %xmm3,%xmm4
   19493:	andps  %xmm6,%xmm4
   19496:	movaps %xmm5,%xmm3
   19499:	cmpneqps %xmm0,%xmm3
   1949d:	movaps %xmm5,%xmm6
   194a0:	cmpordps %xmm0,%xmm6
   194a4:	andps  %xmm3,%xmm6
   194a7:	packssdw %xmm6,%xmm4
   194ab:	cmpleps %xmm5,%xmm0
   194af:	pshufhw $0x84,%xmm0,%xmm0
   194b4:	shufps $0x23,%xmm4,%xmm0
   194b8:	shufps $0x24,%xmm0,%xmm4
   194bc:	packsswb %xmm4,%xmm4
   194c0:	pmovmskb %xmm4,%ecx
   194c4:	cmp    $0xff,%cl
   194c7:	jne    19539 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe9>
   194c9:	cmpb   $0x0,0x30(%rsi)
   194cd:	jne    19539 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe9>
   194cf:	movups (%rsi),%xmm4
   194d2:	movups 0x10(%rsi),%xmm3
   194d6:	movdqu 0x20(%rsi),%xmm0
   194db:	movq   %xmm0,%rcx
   194e0:	movabs $0x7fffffffffffffff,%rdx
   194ea:	and    %rdx,%rcx
   194ed:	movabs $0x7fefffffffffffff,%rdi
   194f7:	cmp    %rdi,%rcx
   194fa:	setg   %cl
   194fd:	movdqa %xmm0,%xmm5
   19501:	punpckhqdq %xmm0,%xmm5
   19505:	movq   %xmm5,%r8
   1950a:	and    %rdx,%r8
   1950d:	cmp    %rdi,%r8
   19510:	movaps %xmm4,%xmm5
   19513:	shufps $0xdd,%xmm3,%xmm5
   19517:	andps  -0x13ace(%rip),%xmm5        # 5a50 <__abi_tag+0x571c>
   1951e:	setg   %dl
   19521:	pcmpgtd -0x13b39(%rip),%xmm5        # 59f0 <__abi_tag+0x56bc>
   19529:	movmskps %xmm5,%edi
   1952c:	test   %edi,%edi
   1952e:	setne  %dil
   19532:	or     %cl,%dl
   19534:	or     %dil,%dl
   19537:	je     19541 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xf1>
   19539:	mov    $0x2,%ecx
   1953e:	mov    %ecx,(%rax)
   19540:	ret
   19541:	xor    %ecx,%ecx
   19543:	xorps  %xmm5,%xmm5
   19546:	ucomiss %xmm5,%xmm2
   19549:	jne    1954d <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xfd>
   1954b:	jnp    1953e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   1954d:	movaps %xmm1,%xmm7
   19550:	shufps $0xff,%xmm1,%xmm7
   19554:	ucomiss %xmm5,%xmm7
   19557:	jne    1955b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x10b>
   19559:	jnp    1953e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   1955b:	movaps %xmm3,%xmm5
   1955e:	shufps $0x4e,%xmm3,%xmm5
   19562:	mulpd  %xmm4,%xmm5
   19566:	movapd %xmm5,%xmm6
   1956a:	unpckhpd %xmm5,%xmm6
   1956e:	subsd  %xmm6,%xmm5
   19572:	xorpd  %xmm6,%xmm6
   19576:	ucomisd %xmm6,%xmm5
   1957a:	jne    1957e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x12e>
   1957c:	jnp    1953e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   1957e:	xorps  %xmm5,%xmm5
   19581:	cvtss2sd %xmm1,%xmm5
   19585:	shufps $0x55,%xmm1,%xmm1
   19589:	cvtss2sd %xmm1,%xmm1
   1958d:	xorps  %xmm6,%xmm6
   19590:	cvtss2sd %xmm2,%xmm6
   19594:	cvtss2sd %xmm7,%xmm2
   19598:	addsd  %xmm5,%xmm6
   1959c:	addsd  %xmm1,%xmm2
   195a0:	cmpb   $0x0,0x31(%rsi)
   195a4:	je     1964b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x1fb>
   195aa:	xorpd  %xmm9,%xmm9
   195af:	movapd %xmm4,%xmm8
   195b4:	cmpltpd %xmm9,%xmm8
   195ba:	movapd %xmm3,%xmm7
   195be:	cmpltpd %xmm9,%xmm7
   195c4:	unpcklpd %xmm6,%xmm6
   195c8:	unpcklpd %xmm5,%xmm5
   195cc:	movapd %xmm8,%xmm9
   195d1:	andnpd %xmm5,%xmm9
   195d6:	movapd %xmm8,%xmm10
   195db:	andnpd %xmm6,%xmm10
   195e0:	andpd  %xmm8,%xmm6
   195e5:	orpd   %xmm9,%xmm6
   195ea:	unpcklpd %xmm2,%xmm2
   195ee:	unpcklpd %xmm1,%xmm1
   195f2:	movapd %xmm7,%xmm9
   195f7:	andnpd %xmm1,%xmm9
   195fc:	movapd %xmm7,%xmm11
   19601:	andnpd %xmm2,%xmm11
   19606:	andpd  %xmm7,%xmm2
   1960a:	orpd   %xmm9,%xmm2
   1960f:	mulpd  %xmm4,%xmm6
   19613:	mulpd  %xmm3,%xmm2
   19617:	addpd  %xmm6,%xmm2
   1961b:	addpd  %xmm0,%xmm2
   1961f:	andpd  %xmm8,%xmm5
   19624:	orpd   %xmm10,%xmm5
   19629:	andpd  %xmm7,%xmm1
   1962d:	orpd   %xmm11,%xmm1
   19632:	mulpd  %xmm4,%xmm5
   19636:	mulpd  %xmm3,%xmm1
   1963a:	addpd  %xmm5,%xmm1
   1963e:	addpd  %xmm0,%xmm1
   19642:	movapd %xmm2,%xmm3
   19646:	jmp    19759 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x309>
   1964b:	unpcklpd %xmm5,%xmm5
   1964f:	mulpd  %xmm4,%xmm5
   19653:	unpcklpd %xmm1,%xmm1
   19657:	mulpd  %xmm3,%xmm1
   1965b:	unpcklpd %xmm6,%xmm6
   1965f:	mulpd  %xmm4,%xmm6
   19663:	unpcklpd %xmm2,%xmm2
   19667:	mulpd  %xmm3,%xmm2
   1966b:	movapd %xmm5,%xmm3
   1966f:	addpd  %xmm1,%xmm3
   19673:	addpd  %xmm0,%xmm3
   19677:	movapd %xmm3,%xmm4
   1967b:	minpd  -0x13bc3(%rip),%xmm4        # 5ac0 <__abi_tag+0x578c>
   19683:	addpd  %xmm6,%xmm1
   19687:	addpd  %xmm0,%xmm1
   1968b:	movapd %xmm4,%xmm7
   1968f:	minpd  %xmm1,%xmm7
   19693:	movapd %xmm7,%xmm8
   19698:	cmpunordpd %xmm7,%xmm8
   1969e:	andpd  %xmm8,%xmm4
   196a3:	andnpd %xmm7,%xmm8
   196a8:	orpd   %xmm4,%xmm8
   196ad:	addpd  %xmm2,%xmm5
   196b1:	addpd  %xmm0,%xmm5
   196b5:	movapd %xmm8,%xmm7
   196ba:	minpd  %xmm5,%xmm7
   196be:	movapd %xmm7,%xmm4
   196c2:	cmpunordpd %xmm7,%xmm4
   196c7:	andpd  %xmm4,%xmm8
   196cc:	andnpd %xmm7,%xmm4
   196d0:	orpd   %xmm8,%xmm4
   196d5:	maxpd  -0x13c3d(%rip),%xmm3        # 5aa0 <__abi_tag+0x576c>
   196dd:	movapd %xmm3,%xmm7
   196e1:	maxpd  %xmm1,%xmm7
   196e5:	movapd %xmm7,%xmm1
   196e9:	cmpunordpd %xmm7,%xmm1
   196ee:	andpd  %xmm1,%xmm3
   196f2:	andnpd %xmm7,%xmm1
   196f6:	orpd   %xmm3,%xmm1
   196fa:	movapd %xmm1,%xmm3
   196fe:	maxpd  %xmm5,%xmm3
   19702:	movapd %xmm3,%xmm5
   19706:	cmpunordpd %xmm3,%xmm5
   1970b:	andpd  %xmm5,%xmm1
   1970f:	andnpd %xmm3,%xmm5
   19713:	orpd   %xmm1,%xmm5
   19717:	addpd  %xmm6,%xmm2
   1971b:	addpd  %xmm0,%xmm2
   1971f:	movapd %xmm4,%xmm0
   19723:	minpd  %xmm2,%xmm0
   19727:	movapd %xmm0,%xmm3
   1972b:	cmpunordpd %xmm0,%xmm3
   19730:	andpd  %xmm3,%xmm4
   19734:	andnpd %xmm0,%xmm3
   19738:	orpd   %xmm4,%xmm3
   1973c:	movapd %xmm5,%xmm0
   19740:	maxpd  %xmm2,%xmm0
   19744:	movapd %xmm0,%xmm1
   19748:	cmpunordpd %xmm0,%xmm1
   1974d:	andpd  %xmm1,%xmm5
   19751:	andnpd %xmm0,%xmm1
   19755:	orpd   %xmm5,%xmm1
   19759:	xorps  %xmm0,%xmm0
   1975c:	cvtsd2ss %xmm3,%xmm0
   19760:	movd   %xmm0,%ecx
   19764:	ucomiss %xmm0,%xmm0
   19767:	setp   %dl
   1976a:	cmp    $0xff800000,%ecx
   19770:	sete   %sil
   19774:	or     %dl,%sil
   19777:	jne    19798 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x348>
   19779:	mov    %ecx,%edx
   1977b:	and    $0x7fffffff,%edx
   19781:	je     1978b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x33b>
   19783:	cmp    %edx,%ecx
   19785:	jne    19792 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x342>
   19787:	dec    %ecx
   19789:	jmp    19794 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x344>
   1978b:	mov    $0x80000001,%ecx
   19790:	jmp    19794 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x344>
   19792:	inc    %ecx
   19794:	movd   %ecx,%xmm0
   19798:	movhlps %xmm3,%xmm3
   1979b:	xorps  %xmm2,%xmm2
   1979e:	cvtsd2ss %xmm3,%xmm2
   197a2:	movd   %xmm2,%ecx
   197a6:	ucomiss %xmm2,%xmm2
   197a9:	setp   %dl
   197ac:	cmp    $0xff800000,%ecx
   197b2:	sete   %sil
   197b6:	or     %dl,%sil
   197b9:	jne    197da <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x38a>
   197bb:	mov    %ecx,%edx
   197bd:	and    $0x7fffffff,%edx
   197c3:	je     197cd <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x37d>
   197c5:	cmp    %edx,%ecx
   197c7:	jne    197d4 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x384>
   197c9:	dec    %ecx
   197cb:	jmp    197d6 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x386>
   197cd:	mov    $0x80000001,%ecx
   197d2:	jmp    197d6 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x386>
   197d4:	inc    %ecx
   197d6:	movd   %ecx,%xmm2
   197da:	xorps  %xmm3,%xmm3
   197dd:	cvtsd2ss %xmm1,%xmm3
   197e1:	movd   %xmm3,%ecx
   197e5:	ucomiss %xmm3,%xmm3
   197e8:	setp   %dl
   197eb:	cmp    $0x7f800000,%ecx
   197f1:	sete   %sil
   197f5:	or     %dl,%sil
   197f8:	jne    19819 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3c9>
   197fa:	mov    %ecx,%edx
   197fc:	and    $0x7fffffff,%edx
   19802:	je     1980c <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3bc>
   19804:	cmp    %edx,%ecx
   19806:	jne    19813 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3c3>
   19808:	inc    %ecx
   1980a:	jmp    19815 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3c5>
   1980c:	mov    $0x1,%ecx
   19811:	jmp    19815 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3c5>
   19813:	dec    %ecx
   19815:	movd   %ecx,%xmm3
   19819:	movhlps %xmm1,%xmm1
   1981c:	cvtsd2ss %xmm1,%xmm1
   19820:	movd   %xmm1,%ecx
   19824:	ucomiss %xmm1,%xmm1
   19827:	setp   %dl
   1982a:	cmp    $0x7f800000,%ecx
   19830:	sete   %sil
   19834:	or     %dl,%sil
   19837:	jne    19858 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x408>
   19839:	mov    %ecx,%edx
   1983b:	and    $0x7fffffff,%edx
   19841:	je     1984b <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x3fb>
   19843:	cmp    %edx,%ecx
   19845:	jne    19852 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x402>
   19847:	inc    %ecx
   19849:	jmp    19854 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x404>
   1984b:	mov    $0x1,%ecx
   19850:	jmp    19854 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x404>
   19852:	dec    %ecx
   19854:	movd   %ecx,%xmm1
   19858:	subss  %xmm0,%xmm3
   1985c:	movd   %xmm3,%ecx
   19860:	ucomiss %xmm3,%xmm3
   19863:	setp   %dl
   19866:	cmp    $0x7f800000,%ecx
   1986c:	sete   %sil
   19870:	or     %dl,%sil
   19873:	jne    19894 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x444>
   19875:	mov    %ecx,%edx
   19877:	and    $0x7fffffff,%edx
   1987d:	je     19887 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x437>
   1987f:	cmp    %edx,%ecx
   19881:	jne    1988e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x43e>
   19883:	inc    %ecx
   19885:	jmp    19890 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x440>
   19887:	mov    $0x1,%ecx
   1988c:	jmp    19890 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x440>
   1988e:	dec    %ecx
   19890:	movd   %ecx,%xmm3
   19894:	subss  %xmm2,%xmm1
   19898:	movd   %xmm1,%ecx
   1989c:	ucomiss %xmm1,%xmm1
   1989f:	setp   %dl
   198a2:	cmp    $0x7f800000,%ecx
   198a8:	sete   %sil
   198ac:	or     %dl,%sil
   198af:	jne    198d0 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x480>
   198b1:	mov    %ecx,%edx
   198b3:	and    $0x7fffffff,%edx
   198b9:	je     198c3 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x473>
   198bb:	cmp    %edx,%ecx
   198bd:	jne    198ca <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x47a>
   198bf:	inc    %ecx
   198c1:	jmp    198cc <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x47c>
   198c3:	mov    $0x1,%ecx
   198c8:	jmp    198cc <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0x47c>
   198ca:	dec    %ecx
   198cc:	movd   %ecx,%xmm1
   198d0:	movaps %xmm0,%xmm4
   198d3:	addss  %xmm3,%xmm4
   198d7:	movd   %xmm4,%ecx
   198db:	movaps %xmm2,%xmm4
   198de:	addss  %xmm1,%xmm4
   198e2:	movd   %xmm4,%edx
   198e6:	movdqa %xmm3,%xmm4
   198ea:	punpckldq %xmm1,%xmm4
   198ee:	movdqa %xmm0,%xmm5
   198f2:	punpckldq %xmm2,%xmm5
   198f6:	punpcklqdq %xmm4,%xmm5
   198fa:	and    $0x7fffffff,%ecx
   19900:	cmp    $0x7f800000,%ecx
   19906:	setl   %cl
   19909:	and    $0x7fffffff,%edx
   1990f:	cmp    $0x7f800000,%edx
   19915:	setl   %dl
   19918:	pand   -0x13ed0(%rip),%xmm5        # 5a50 <__abi_tag+0x571c>
   19920:	pcmpgtd -0x14058(%rip),%xmm5        # 58d0 <__abi_tag+0x559c>
   19928:	movmskps %xmm5,%esi
   1992b:	test   %esi,%esi
   1992d:	jne    19539 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe9>
   19933:	test   %cl,%cl
   19935:	je     19539 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe9>
   1993b:	test   %dl,%dl
   1993d:	je     19539 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe9>
   19943:	pxor   %xmm4,%xmm4
   19947:	ucomiss %xmm4,%xmm3
   1994a:	jb     19539 <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xe9>
   19950:	ucomiss %xmm4,%xmm1
   19953:	mov    $0x2,%ecx
   19958:	jb     1953e <<gpui_reactivity_core::geometry::CoordinateSpace>::mapped_bounds+0xee>
   1995e:	movss  %xmm0,0x4(%rax)
   19963:	movss  %xmm2,0x8(%rax)
   19968:	movss  %xmm3,0xc(%rax)
   1996d:	movss  %xmm1,0x10(%rax)
   19972:	mov    $0x1,%ecx
   19977:	mov    %ecx,(%rax)
   19979:	ret
