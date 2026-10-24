_RNvMs5_NtNtCs9S44gUqPSHd_11gpui_canvas6canvas5clipsNtB7_6Canvas11create_clip:
.Lfunc_begin40:
	.cfi_startproc
	.cfi_personality 155, DW.ref._RNvCseilXckri75C_7___rustc19rust_eh_personality
	.cfi_lsda 27, .Lexception40
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$344, %rsp
	.cfi_def_cfa_offset 400
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%r9, %r12
	movl	%ecx, %ebp
	movq	%rdx, %r14
	movq	%rsi, %r13
	movq	%rdi, %rbx
	cmpl	$1, (%r8)
	jne	.LBB316_2
	movups	8(%r8), %xmm0
	movaps	%xmm0, 48(%rsp)
	movss	4(%r8), %xmm0
	jmp	.LBB316_3
.LBB316_2:
	movups	4(%r8), %xmm0
	movaps	%xmm0, 48(%rsp)
	xorps	%xmm0, %xmm0
.LBB316_3:
	movss	%xmm0, 12(%rsp)
	movsd	52(%rsp), %xmm0
	movaps	%xmm0, 176(%rsp)
	movss	60(%rsp), %xmm0
	movaps	%xmm0, 192(%rsp)
	movss	48(%rsp), %xmm0
	movaps	%xmm0, 160(%rsp)
	leaq	48(%rsp), %rdi
	callq	*_RNvMNtCsdlEgFZ12e44_20gpui_reactivity_core8geometryNtB2_4Rect8is_valid@GOTPCREL(%rip)
	testb	%al, %al
	je	.LBB316_10
	movaps	160(%rsp), %xmm0
	andps	.LCPI316_0(%rip), %xmm0
	ucomiss	.LCPI316_1(%rip), %xmm0
	ja	.LBB316_10
	movaps	.LCPI316_0(%rip), %xmm0
	movaps	192(%rsp), %xmm1
	andps	%xmm0, %xmm1
	ucomiss	.LCPI316_1(%rip), %xmm1
	ja	.LBB316_10
	movaps	176(%rsp), %xmm1
	andps	%xmm0, %xmm1
	movaps	.LCPI316_2(%rip), %xmm0
	cmpltps	%xmm1, %xmm0
	unpcklps	%xmm0, %xmm0
	movmskpd	%xmm0, %eax
	testb	%al, %al
	jne	.LBB316_10
	movd	12(%rsp), %xmm0
	movd	%xmm0, %eax
	leal	-1(%rax), %ecx
	cmpl	$8388607, %ecx
	setb	%cl
	movl	%eax, %edx
	andl	$2147483647, %edx
	sete	%sil
	orb	%cl, %sil
	testl	%eax, %eax
	setns	%al
	addl	$-8388608, %edx
	cmpl	$2130706432, %edx
	setb	%cl
	andb	%al, %cl
	orb	%sil, %cl
	je	.LBB316_10
	leaq	64(%rsp), %rdi
	movq	%r12, %rsi
	callq	_RNvMNtCs9S44gUqPSHd_11gpui_canvas6canvasNtB2_7Mapping3new
	cmpl	$1, 64(%rsp)
	jne	.LBB316_13
	movq	68(%rsp), %rax
	movq	%rax, 8(%rbx)
	jmp	.LBB316_11
.LBB316_10:
	movl	$1, 8(%rbx)
.LBB316_11:
	movq	$0, (%rbx)
.LBB316_12:
	movq	%rbx, %rax
	addq	$344, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.LBB316_13:
	.cfi_def_cfa_offset 400
	movl	72(%rsp), %eax
	movl	%eax, 176(%rsp)
	movl	76(%rsp), %eax
	movl	%eax, 192(%rsp)
	movups	80(%rsp), %xmm0
	movaps	%xmm0, 160(%rsp)
	movups	96(%rsp), %xmm0
	movaps	%xmm0, 208(%rsp)
	movq	112(%rsp), %rax
	movq	%rax, 224(%rsp)
	movq	280(%r13), %rsi
	testq	%r14, %r14
	je	.LBB316_20
	testq	%rsi, %rsi
	je	.LBB316_19
	movq	72(%rsi), %r15
	testq	%r15, %r15
	je	.LBB316_19
	cmpq	24(%r15), %r14
	jne	.LBB316_19
	movl	%ebp, %eax
	cmpq	%rax, 16(%r15)
	jbe	.LBB316_19
	movq	8(%r15), %rcx
	imulq	$104, %rax, %rax
	movzbl	103(%rcx,%rax), %r9d
	incq	%r9
	leaq	280(%r13), %rdx
	jmp	.LBB316_21
.LBB316_19:
	movq	$2, 8(%rbx)
	jmp	.LBB316_11
.LBB316_20:
	leaq	280(%r13), %rdx
	movl	$1, %r9d
	xorl	%r15d, %r15d
	testq	%rsi, %rsi
	je	.LBB316_23
.LBB316_21:
	movq	72(%rsi), %rax
	testq	%rax, %rax
	je	.LBB316_24
	movq	16(%rax), %r8
	xorl	%eax, %eax
	jmp	.LBB316_26
.LBB316_23:
	movb	$1, %al
	xorl	%esi, %esi
	jmp	.LBB316_25
.LBB316_24:
	xorl	%eax, %eax
.LBB316_25:
	xorl	%r8d, %r8d
.LBB316_26:
	cmpl	$64, %r9d
	ja	.LBB316_56
	cmpq	$16384, %r8
	je	.LBB316_56
	movq	424(%r13), %r11
	movq	432(%r13), %r10
	testq	%r11, %r11
	movq	%rax, 32(%rsp)
	js	.LBB316_30
	xorps	%xmm0, %xmm0
	cvtsi2ss	%r11, %xmm0
	jmp	.LBB316_31
.LBB316_30:
	movq	%r11, %rax
	shrq	%rax
	movl	%r11d, %ecx
	andl	$1, %ecx
	orq	%rax, %rcx
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rcx, %xmm0
	addss	%xmm0, %xmm0
.LBB316_31:
	testq	%r10, %r10
	js	.LBB316_33
	cvtsi2ss	%r10, %xmm1
	jmp	.LBB316_34
.LBB316_33:
	movq	%r10, %rax
	shrq	%rax
	movl	%r10d, %ecx
	andl	$1, %ecx
	orq	%rax, %rcx
	cvtsi2ss	%rcx, %xmm1
	addss	%xmm1, %xmm1
.LBB316_34:
	movq	%rsi, 152(%rsp)
	movq	$0, 240(%rsp)
	movss	%xmm0, 248(%rsp)
	movss	%xmm1, 252(%rsp)
	testq	%r14, %r14
	movq	%rdx, 296(%rsp)
	movq	%r8, 288(%rsp)
	movq	%r9, 40(%rsp)
	movq	%r10, 312(%rsp)
	movq	%r11, 304(%rsp)
	movss	%xmm0, 24(%rsp)
	movss	%xmm1, 16(%rsp)
	je	.LBB316_37
	movq	16(%r15), %rsi
	movl	%ebp, %edi
	cmpq	%rdi, %rsi
	jbe	.LBB316_75
	movq	8(%r15), %rax
	imulq	$104, %rdi, %rcx
	addq	%rcx, %rax
	addq	$64, %rax
	jmp	.LBB316_38
.LBB316_37:
	leaq	240(%rsp), %rax
.LBB316_38:
	movups	(%rax), %xmm0
	movaps	%xmm0, 64(%rsp)
	movl	176(%rsp), %eax
	movl	%eax, 80(%rsp)
	movl	192(%rsp), %eax
	movl	%eax, 84(%rsp)
	movaps	160(%rsp), %xmm0
	movups	%xmm0, 88(%rsp)
	movaps	208(%rsp), %xmm0
	movups	%xmm0, 104(%rsp)
	movq	224(%rsp), %rax
	movq	%rax, 120(%rsp)
	movaps	.LCPI316_3(%rip), %xmm0
	movaps	%xmm0, 128(%rsp)
	leaq	240(%rsp), %rdi
	leaq	48(%rsp), %rdx
	leaq	64(%rsp), %r8
	movq	%r13, %rsi
	movq	%r12, %rcx
	movl	$-1, %r9d
	callq	_RNvMsc_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB5_6Canvas7prepare
	movl	240(%rsp), %eax
	cmpl	$2, %eax
	jne	.LBB316_40
	movq	244(%rsp), %rax
	movq	%rax, 8(%rbx)
	jmp	.LBB316_11
.LBB316_40:
	testb	$1, %al
	jne	.LBB316_42
	xorps	%xmm0, %xmm0
	jmp	.LBB316_43
.LBB316_42:
	pxor	%xmm3, %xmm3
	movq	260(%rsp), %xmm0
	movd	260(%rsp), %xmm1
	movd	264(%rsp), %xmm2
	psubw	%xmm1, %xmm2
	punpckldq	%xmm2, %xmm0
	punpcklwd	%xmm3, %xmm0
	cvtdq2ps	%xmm0, %xmm0
.LBB316_43:
	movaps	%xmm0, 272(%rsp)
	movss	16(%rsp), %xmm1
	movq	$0, 68(%rsp)
	movss	24(%rsp), %xmm0
	movss	%xmm0, 76(%rsp)
	movss	%xmm1, 80(%rsp)
	movl	$1, 64(%rsp)
	leaq	324(%rsp), %rdi
	leaq	64(%rsp), %rcx
	movq	%r15, %rsi
	movl	%ebp, %edx
	callq	_RINvMNtCsaifZ2emd9Uo_4core6optionINtB3_6OptionNtNtNtCs9S44gUqPSHd_11gpui_canvas6canvas5clips9ClipChainE6map_orIBw_NtNtCsdlEgFZ12e44_20gpui_reactivity_core8geometry4RectENCNvMs5_BK_NtBM_6Canvas11create_clips2_0EBO_
	xorl	%r15d, %r15d
	movl	$2143289344, %r13d
	xorps	%xmm0, %xmm0
	movss	12(%rsp), %xmm1
	ucomiss	%xmm0, %xmm1
	jne	.LBB316_49
	jp	.LBB316_49
	movq	$0, 24(%rsp)
	xorps	%xmm0, %xmm0
	movapd	160(%rsp), %xmm1
	ucomisd	%xmm0, %xmm1
	movq	40(%rsp), %rax
	jne	.LBB316_52
	jp	.LBB316_52
	unpckhpd	%xmm1, %xmm1
	ucomisd	%xmm0, %xmm1
	jne	.LBB316_52
	jp	.LBB316_52
	cmpb	$0, 324(%rsp)
	movl	$0, %ecx
	movq	%rcx, 16(%rsp)
	je	.LBB316_53
	movq	%rax, %r13
	leaq	328(%rsp), %rcx
	movq	312(%rsp), %rax
	shlq	$32, %rax
	movl	304(%rsp), %r8d
	orq	%rax, %r8
	leaq	64(%rsp), %rdi
	leaq	48(%rsp), %rdx
	movq	%r12, %rsi
	callq	*_RNvNtCs9S44gUqPSHd_11gpui_canvas6canvas17sampled_rect_clip@GOTPCREL(%rip)
	movl	68(%rsp), %ecx
	movl	72(%rsp), %eax
	testb	$1, 64(%rsp)
	je	.LBB316_50
	movl	%ecx, 8(%rbx)
	movl	%eax, 12(%rbx)
	jmp	.LBB316_11
.LBB316_49:
	movq	$0, 24(%rsp)
	movq	$0, 16(%rsp)
	movq	40(%rsp), %rax
	jmp	.LBB316_53
.LBB316_50:
	movq	%rax, 24(%rsp)
	movq	76(%rsp), %rax
	movq	%rax, 16(%rsp)
	movq	%r13, %rax
	movl	%ecx, %r13d
	jmp	.LBB316_53
.LBB316_52:
	movq	$0, 16(%rsp)
.LBB316_53:
	shll	$24, %eax
	incl	%ebp
	testq	%r14, %r14
	cmovel	%r15d, %ebp
	orl	%eax, %ebp
	cmpb	$0, 32(%rsp)
	jne	.LBB316_57
	movq	152(%rsp), %rax
	movq	72(%rax), %rdi
	testq	%rdi, %rdi
	je	.LBB316_57
	movq	16(%rdi), %rsi
	movl	$1, %edx
	movl	$8, %ecx
	movl	$104, %r8d
	callq	_RNvMs5_NtCse3dB2pZFcs1_5alloc7raw_vecNtB5_11RawVecInner11try_reserveCs9S44gUqPSHd_11gpui_canvas
	cmpq	$-1, %rax
	je	.LBB316_71
.LBB316_56:
	movl	$8, 8(%rbx)
	jmp	.LBB316_11
.LBB316_57:
	movq	_RNvNtNtCs9S44gUqPSHd_11gpui_canvas6canvas5clips10NEXT_OWNER(%rip), %rax
.LBB316_58:
	cmpq	$-1, %rax
	je	.LBB316_64
	leaq	1(%rax), %rcx
	lock		cmpxchgq	%rcx, _RNvNtNtCs9S44gUqPSHd_11gpui_canvas6canvas5clips10NEXT_OWNER(%rip)
	jne	.LBB316_58
	movq	%rax, 40(%rsp)
	testq	%rax, %rax
	je	.LBB316_74
	movq	$0, 64(%rsp)
	movq	$8, 72(%rsp)
	movq	$0, 80(%rsp)
	leaq	64(%rsp), %rdi
	movl	$1, %edx
	movl	$8, %ecx
	movl	$104, %r8d
	xorl	%esi, %esi
	callq	_RNvMs5_NtCse3dB2pZFcs1_5alloc7raw_vecNtB5_11RawVecInner11try_reserveCs9S44gUqPSHd_11gpui_canvas
	cmpq	$-1, %rax
	je	.LBB316_65
	movl	$8, 8(%rbx)
	movq	$0, (%rbx)
	movq	64(%rsp), %rax
	testq	%rax, %rax
	je	.LBB316_12
	movq	72(%rsp), %rdi
	imulq	$104, %rax, %rsi
	movl	$8, %edx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	jmp	.LBB316_12
.LBB316_64:
	movq	$8, 8(%rbx)
	jmp	.LBB316_11
.LBB316_65:
	movq	64(%rsp), %rax
	movq	80(%rsp), %r12
	cmpq	%rax, %r12
	jne	.LBB316_68
.Ltmp1771:
	leaq	64(%rsp), %rdi
	callq	*_RNvMs7_NtCse3dB2pZFcs1_5alloc7raw_vecINtB5_6RawVecNtNtNtCs9S44gUqPSHd_11gpui_canvas6canvas5clips4NodeE8grow_oneBS_@GOTPCREL(%rip)
.Ltmp1772:
	movq	64(%rsp), %rax
.LBB316_68:
	movq	%rax, 32(%rsp)
	movq	72(%rsp), %r14
	imulq	$104, %r12, %rax
	movaps	48(%rsp), %xmm0
	movups	%xmm0, (%r14,%rax)
	movl	176(%rsp), %ecx
	movl	%ecx, 16(%r14,%rax)
	movl	192(%rsp), %ecx
	movl	%ecx, 20(%r14,%rax)
	movaps	160(%rsp), %xmm0
	movups	%xmm0, 24(%r14,%rax)
	movaps	208(%rsp), %xmm0
	movups	%xmm0, 40(%r14,%rax)
	movq	224(%rsp), %rcx
	movq	%rcx, 56(%r14,%rax)
	movaps	272(%rsp), %xmm0
	movups	%xmm0, 64(%r14,%rax)
	movl	%r13d, 80(%r14,%rax)
	movq	24(%rsp), %rcx
	movl	%ecx, 84(%r14,%rax)
	movq	16(%rsp), %rcx
	movq	%rcx, 88(%r14,%rax)
	movss	12(%rsp), %xmm0
	movss	%xmm0, 96(%r14,%rax)
	movl	%ebp, 100(%r14,%rax)
	incq	%r12
	movq	%r12, 80(%rsp)
.Ltmp1774:
	movl	$32, %edi
	callq	_RNvNtCse3dB2pZFcs1_5alloc5boxed14box_new_uninit
.Ltmp1775:
	movq	%rax, %r15
	movq	32(%rsp), %rax
	movq	%rax, (%r15)
	movq	%r14, 8(%r15)
	movq	%r12, 16(%r15)
	movq	40(%rsp), %rax
	movq	%rax, 24(%r15)
.Ltmp1777:
	movq	296(%rsp), %r14
	movq	%r14, %rdi
	callq	_RINvMNtCsaifZ2emd9Uo_4core6optionINtB3_6OptionINtNtCse3dB2pZFcs1_5alloc5boxed3BoxNtNtCs9S44gUqPSHd_11gpui_canvas6canvas14ImageResourcesEE18get_or_insert_withNvYBI_NtNtB5_7default7Default7defaultEB1l_
.Ltmp1778:
	movq	(%r14), %r14
	movq	72(%r14), %rdi
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCse3dB2pZFcs1_5alloc5boxed3BoxNtNtNtCs9S44gUqPSHd_11gpui_canvas6canvas5clips9ClipArenaEEEB1C_
	movq	%r15, 72(%r14)
	movq	40(%rsp), %rax
	movq	%rax, (%rbx)
	movl	$0, 8(%rbx)
	jmp	.LBB316_12
.LBB316_71:
	movq	152(%rsp), %rsi
	movq	72(%rsi), %r14
	movq	16(%r14), %r15
	cmpq	(%r14), %r15
	je	.LBB316_73
.LBB316_72:
	movq	8(%r14), %rax
	imulq	$104, %r15, %rcx
	movaps	48(%rsp), %xmm0
	movups	%xmm0, (%rax,%rcx)
	movl	176(%rsp), %edx
	movl	%edx, 16(%rax,%rcx)
	movl	192(%rsp), %edx
	movl	%edx, 20(%rax,%rcx)
	movaps	160(%rsp), %xmm0
	movups	%xmm0, 24(%rax,%rcx)
	movaps	208(%rsp), %xmm0
	movups	%xmm0, 40(%rax,%rcx)
	movq	224(%rsp), %rdx
	movq	%rdx, 56(%rax,%rcx)
	movaps	272(%rsp), %xmm0
	movups	%xmm0, 64(%rax,%rcx)
	movl	%r13d, 80(%rax,%rcx)
	movq	24(%rsp), %rdx
	movl	%edx, 84(%rax,%rcx)
	movq	16(%rsp), %rdx
	movq	%rdx, 88(%rax,%rcx)
	movss	12(%rsp), %xmm0
	movss	%xmm0, 96(%rax,%rcx)
	movl	%ebp, 100(%rax,%rcx)
	incq	%r15
	movq	%r15, 16(%r14)
	movq	72(%rsi), %rax
	movq	24(%rax), %rax
	movq	%rax, (%rbx)
	movq	288(%rsp), %rax
	movl	%eax, 8(%rbx)
	jmp	.LBB316_12
.LBB316_73:
	movq	%r14, %rdi
	callq	*_RNvMs7_NtCse3dB2pZFcs1_5alloc7raw_vecINtB5_6RawVecNtNtNtCs9S44gUqPSHd_11gpui_canvas6canvas5clips4NodeE8grow_oneBS_@GOTPCREL(%rip)
	movq	152(%rsp), %rsi
	jmp	.LBB316_72
.LBB316_74:
	leaq	.Lalloc_0d39ba74600d124c3fd97dfecc8a8531(%rip), %rdi
	leaq	.Lalloc_da2e4f18b7d2cb2a5843972ca4a054e8(%rip), %rdx
	movl	$39, %esi
	callq	*_RNvNtCsaifZ2emd9Uo_4core6option13expect_failed@GOTPCREL(%rip)
.LBB316_75:
	leaq	.Lalloc_e99ff9bf08e18ce90d94b2797da3fed4(%rip), %rdx
	callq	*_RNvNtCsaifZ2emd9Uo_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB316_76:
.Ltmp1773:
	movq	%rax, %rbx
	movq	64(%rsp), %rax
	testq	%rax, %rax
	je	.LBB316_80
	movq	72(%rsp), %rdi
	imulq	$104, %rax, %rsi
	movl	$8, %edx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB316_78:
.Ltmp1779:
	movq	%rax, %rbx
	movq	%r15, %rdi
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCse3dB2pZFcs1_5alloc5boxed3BoxNtNtNtCs9S44gUqPSHd_11gpui_canvas6canvas5clips9ClipArenaEEEB1C_
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB316_79:
.Ltmp1776:
	movq	%rax, %rbx
	cmpq	$0, 32(%rsp)
	jne	.LBB316_81
.LBB316_80:
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB316_81:
	imulq	$104, 32(%rsp), %rsi
	movl	$8, %edx
	movq	%r14, %rdi
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.Lfunc_end316:
