_RNvMs3_NtNtCs9S44gUqPSHd_11gpui_canvas6canvas5clipsNtB5_9ClipChain11contains_at:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%xmm1, %rax
	movq	%xmm0, %rcx
	shrq	$52, %rcx
	andl	$2047, %ecx
	cmpl	$2047, %ecx
	setae	%cl
	shrq	$52, %rax
	andl	$2047, %eax
	cmpl	$2047, %eax
	setae	%al
	orb	%cl, %al
	jne	.LBB296_1
	movl	%edx, %eax
	cmpq	%rax, %rsi
	jbe	.LBB296_13
	imulq	$104, %rax, %rax
	movss	64(%rdi,%rax), %xmm2
	cvtss2sd	%xmm2, %xmm2
	ucomisd	%xmm2, %xmm0
	jb	.LBB296_1
	leaq	(%rdi,%rax), %rcx
	movss	68(%rcx), %xmm3
	cvtss2sd	%xmm3, %xmm3
	ucomisd	%xmm3, %xmm1
	jb	.LBB296_1
	movss	72(%rdi,%rax), %xmm4
	cvtss2sd	%xmm4, %xmm4
	addsd	%xmm4, %xmm2
	ucomisd	%xmm0, %xmm2
	jbe	.LBB296_1
	movss	76(%rdi,%rax), %xmm2
	cvtss2sd	%xmm2, %xmm2
	addsd	%xmm3, %xmm2
	ucomisd	%xmm1, %xmm2
	jbe	.LBB296_1
	unpcklpd	%xmm0, %xmm0
	unpcklpd	%xmm1, %xmm1
	movsd	.LCPI296_0(%rip), %xmm2
	xorpd	%xmm3, %xmm3
	movl	$16777215, %ecx
	.p2align	4
.LBB296_8:
	movl	%edx, %eax
	cmpq	%rax, %rsi
	jbe	.LBB296_14
	imulq	$104, %rax, %rax
	movupd	16(%rdi,%rax), %xmm4
	mulpd	%xmm0, %xmm4
	movupd	32(%rdi,%rax), %xmm5
	mulpd	%xmm1, %xmm5
	addpd	%xmm4, %xmm5
	movupd	48(%rdi,%rax), %xmm4
	cvtps2pd	(%rdi,%rax), %xmm6
	addpd	%xmm5, %xmm4
	cvtps2pd	8(%rdi,%rax), %xmm5
	movapd	%xmm6, %xmm7
	addpd	%xmm5, %xmm7
	movapd	%xmm4, %xmm8
	cmpltpd	%xmm7, %xmm8
	movapd	%xmm6, %xmm7
	cmplepd	%xmm4, %xmm7
	shufps	$136, %xmm7, %xmm8
	movmskps	%xmm8, %edx
	cmpl	$15, %edx
	jne	.LBB296_1
	addq	%rdi, %rax
	movss	96(%rax), %xmm7
	subpd	%xmm6, %xmm4
	xorps	%xmm6, %xmm6
	cvtss2sd	%xmm7, %xmm6
	movapd	%xmm5, %xmm7
	mulsd	%xmm2, %xmm7
	movaps	%xmm6, %xmm8
	minsd	%xmm7, %xmm8
	cmpunordsd	%xmm7, %xmm7
	movapd	%xmm7, %xmm9
	andnpd	%xmm8, %xmm9
	andpd	%xmm6, %xmm7
	orpd	%xmm9, %xmm7
	movapd	%xmm5, %xmm8
	unpckhpd	%xmm5, %xmm8
	mulsd	%xmm2, %xmm8
	movapd	%xmm8, %xmm6
	cmpunordsd	%xmm8, %xmm6
	movapd	%xmm6, %xmm9
	andpd	%xmm7, %xmm9
	minsd	%xmm8, %xmm7
	andnpd	%xmm7, %xmm6
	orpd	%xmm9, %xmm6
	movapd	%xmm6, %xmm7
	unpcklpd	%xmm6, %xmm7
	subpd	%xmm7, %xmm5
	subpd	%xmm4, %xmm7
	subpd	%xmm5, %xmm4
	movapd	%xmm7, %xmm5
	maxpd	%xmm4, %xmm5
	cmpunordpd	%xmm4, %xmm4
	andpd	%xmm4, %xmm7
	andnpd	%xmm5, %xmm4
	orpd	%xmm7, %xmm4
	maxpd	%xmm3, %xmm4
	mulpd	%xmm4, %xmm4
	movapd	%xmm4, %xmm5
	unpckhpd	%xmm4, %xmm5
	addsd	%xmm4, %xmm5
	mulsd	%xmm6, %xmm6
	ucomisd	%xmm5, %xmm6
	jb	.LBB296_1
	movl	100(%rax), %edx
	andl	%ecx, %edx
	movb	$1, %al
	subl	$1, %edx
	jae	.LBB296_8
	jmp	.LBB296_2
.LBB296_1:
	xorl	%eax, %eax
.LBB296_2:
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.LBB296_13:
	.cfi_def_cfa_offset 16
	leaq	.Lalloc_e99ff9bf08e18ce90d94b2797da3fed4(%rip), %rdx
	movq	%rax, %rdi
	callq	*_RNvNtCsaifZ2emd9Uo_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB296_14:
	leaq	.Lalloc_1cfcf8c2761cd6502a230ad5285ae5c0(%rip), %rdx
	movq	%rax, %rdi
	callq	*_RNvNtCsaifZ2emd9Uo_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.Lfunc_end296:
