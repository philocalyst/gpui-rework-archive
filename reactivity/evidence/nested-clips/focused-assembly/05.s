_RNvMsc_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB5_6Canvas17draw_text_working:
	.cfi_startproc
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
	subq	$376, %rsp
	.cfi_def_cfa_offset 432
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movd	%xmm0, 28(%rsp)
	movd	%xmm1, 32(%rsp)
	movd	%xmm2, 36(%rsp)
	movq	16(%rdx), %rax
	movq	16(%rax), %rax
	cmpq	(%rsi), %rax
	je	.LBB389_2
	movl	$13, %eax
	jmp	.LBB389_4
.LBB389_2:
	movd	%xmm2, %eax
	testl	%eax, %eax
	sets	%r10b
	andl	$2147483647, %eax
	leal	-8388608(%rax), %r11d
	cmpl	$2130706432, %r11d
	setb	%r11b
	andb	%r10b, %r11b
	leal	-1(%rax), %ebx
	cmpl	$8388607, %ebx
	setb	%bl
	andb	%r10b, %bl
	testl	%eax, %eax
	sete	%r10b
	cmpl	$2139095040, %eax
	sete	%bpl
	orb	%r10b, %bpl
	cmpl	$2139095041, %eax
	setge	%al
	orb	%bpl, %al
	orb	%bl, %al
	orb	%r11b, %al
	je	.LBB389_6
.LBB389_3:
	movl	$1, %eax
	jmp	.LBB389_4
.LBB389_6:
	mulss	44(%rdx), %xmm2
	movd	%xmm2, %eax
	movss	%xmm2, 40(%rsp)
	testl	%eax, %eax
	sets	%r10b
	andl	$2147483647, %eax
	leal	-8388608(%rax), %r11d
	cmpl	$2130706432, %r11d
	setb	%r11b
	andb	%r10b, %r11b
	leal	-1(%rax), %ebx
	cmpl	$8388607, %ebx
	setb	%bl
	andb	%r10b, %bl
	cmpl	$2139095040, %eax
	sete	%al
	setg	%r10b
	orb	%al, %r10b
	orb	%bl, %r10b
	orb	%r11b, %r10b
	movl	$6, %eax
	je	.LBB389_7
.LBB389_4:
.LBB389_5:
	movl	%ebp, %edx
	addq	$376, %rsp
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
.LBB389_7:
	.cfi_def_cfa_offset 432
	movss	.LCPI389_0(%rip), %xmm3
	ucomiss	%xmm2, %xmm3
	jb	.LBB389_4
	xorps	%xmm3, %xmm3
	ucomiss	%xmm3, %xmm2
	jne	.LBB389_9
	jnp	.LBB389_5
.LBB389_9:
	movd	%xmm0, %eax
	addl	%eax, %eax
	cmpl	$-16777216, %eax
	setae	%al
	movd	%xmm1, %r10d
	addl	%r10d, %r10d
	cmpl	$-16777216, %r10d
	setae	%r10b
	orb	%al, %r10b
	jne	.LBB389_3
	movq	%rdx, %r14
	movq	%rsi, %rbx
	movq	%rcx, %r12
	movq	%r9, 16(%rsp)
	movq	%rdi, 8(%rsp)
	movq	280(%rdi), %rsi
	leaq	64(%rsp), %rdi
	movq	%r8, %rdx
	callq	_RNvMs5_NtNtCs9S44gUqPSHd_11gpui_canvas6canvas5clipsNtB7_6Canvas12resolve_clip
	movl	68(%rsp), %eax
	movl	72(%rsp), %ebp
	cmpl	$1, 64(%rsp)
	je	.LBB389_5
	movl	%eax, %r15d
	movq	76(%rsp), %r13
	leaq	64(%rsp), %rdi
	movq	%r12, %rsi
	callq	_RNvMNtCs9S44gUqPSHd_11gpui_canvas6canvasNtB2_7Mapping3new
	cmpl	$1, 64(%rsp)
	jne	.LBB389_13
	movl	68(%rsp), %eax
	movl	72(%rsp), %ebp
	jmp	.LBB389_5
.LBB389_13:
	movq	432(%rsp), %rsi
	leaq	32(%rsp), %rcx
	movl	72(%rsp), %eax
	movups	76(%rsp), %xmm0
	movups	%xmm0, 228(%rsp)
	movups	92(%rsp), %xmm0
	movups	%xmm0, 244(%rsp)
	movups	104(%rsp), %xmm0
	movups	%xmm0, 256(%rsp)
	movl	%r15d, 208(%rsp)
	movl	%ebp, 212(%rsp)
	movq	%r13, 216(%rsp)
	movl	%eax, 224(%rsp)
	movq	16(%rsp), %rax
	movups	(%rax), %xmm0
	movups	%xmm0, 272(%rsp)
	movq	8(%rsp), %rax
	movq	248(%rax), %r15
	movq	272(%rax), %r13
	movdqu	(%rax), %xmm0
	movdqa	%xmm0, 352(%rsp)
	movl	176(%rax), %edx
	movl	%edx, 44(%rsp)
	movl	$0, 320(%rsp)
	movq	$0, 184(%rsp)
	movq	$0, 192(%rsp)
	movq	$0, 200(%rsp)
	movq	%r14, 64(%rsp)
	movq	%rbx, 72(%rsp)
	movq	%rsi, %rbx
	leaq	40(%rsp), %rdx
	movq	%rdx, 80(%rsp)
	movq	%rax, 88(%rsp)
	leaq	28(%rsp), %rax
	movq	%rax, 96(%rsp)
	movq	%rcx, 104(%rsp)
	leaq	36(%rsp), %rax
	movq	%rax, 112(%rsp)
	movq	%r12, 120(%rsp)
	leaq	208(%rsp), %rax
	movq	%rax, 128(%rsp)
	leaq	200(%rsp), %rax
	movq	%rax, 136(%rsp)
	leaq	184(%rsp), %rax
	movq	%rax, 144(%rsp)
	leaq	192(%rsp), %rax
	movq	%rax, 152(%rsp)
	leaq	320(%rsp), %rax
	movq	%rax, 160(%rsp)
	leaq	44(%rsp), %rax
	movq	%rax, 168(%rsp)
	movq	%rsi, 176(%rsp)
	leaq	64(%rsp), %rdi
	callq	_RNCNvMsc_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB7_6Canvas17draw_text_working0B9_
	cmpl	$-1, %eax
	je	.LBB389_55
	movl	%edx, %ebp
	movl	%eax, 24(%rsp)
	movq	8(%rsp), %rax
	leaq	256(%rax), %rsi
	cmpq	248(%rax), %r15
	ja	.LBB389_16
	movq	%r15, 248(%rax)
.LBB389_16:
	leaq	64(%rsp), %rdi
	movq	%r13, %rdx
	callq	_RINvMs_NtCse3dB2pZFcs1_5alloc3vecINtB5_3VecINtNtNtB7_3rcs3arc3ArcNtNtCs9S44gUqPSHd_11gpui_canvas4text6RasterEE5drainINtNtNtCsaifZ2emd9Uo_4core3ops5range9RangeFromjEEB15_
	movq	64(%rsp), %r13
	movq	72(%rsp), %rax
	movq	%rax, 16(%rsp)
	cmpq	%rax, %r13
	je	.LBB389_17
	movq	8(%rsp), %rcx
	jmp	.LBB389_19
.LBB389_45:
	addq	$8, %r13
	cmpq	16(%rsp), %r13
	je	.LBB389_46
.LBB389_19:
	movq	(%r13), %r14
	movq	%r14, 48(%rsp)
	movq	40(%r14), %rax
	movl	48(%r14), %r15d
	movzwl	52(%r14), %ebx
	movq	%r15, %r12
	shlq	$16, %r12
	orq	%rbx, %r12
	movq	%r12, 288(%rsp)
	cmpl	$1, (%rcx)
	jne	.LBB389_21
	cmpq	%rax, 8(%rcx)
	jne	.LBB389_21
	movq	48(%rcx), %rdi
	movq	56(%rcx), %rsi
	leaq	288(%rsp), %rdx
	callq	_RINvYNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateNtNtCsaifZ2emd9Uo_4core4hash11BuildHasher8hash_oneRNtNtCs9S44gUqPSHd_11gpui_canvas5image8ImageKeyEB1J_
	movq	8(%rsp), %rcx
	movq	%rax, %rdi
	shrq	$57, %rdi
	movq	16(%rcx), %rdx
	movq	24(%rcx), %rsi
	movd	%edi, %xmm0
	punpcklbw	%xmm0, %xmm0
	pshuflw	$0, %xmm0, %xmm0
	pshufd	$68, %xmm0, %xmm0
	xorl	%edi, %edi
.LBB389_34:
	andq	%rsi, %rax
	movdqu	(%rdx,%rax), %xmm1
	movdqa	%xmm1, %xmm2
	pcmpeqb	%xmm0, %xmm2
	pmovmskb	%xmm2, %r9d
	testl	%r9d, %r9d
	je	.LBB389_37
.LBB389_35:
	rep		bsfl	%r9d, %r8d
	addq	%rax, %r8
	andq	%rsi, %r8
	movq	%r8, %r10
	shlq	$4, %r10
	movq	%rdx, %r11
	subq	%r10, %r11
	cmpq	-16(%r11), %r12
	je	.LBB389_39
	leal	-1(%r9), %r8d
	andw	%r9w, %r8w
	movl	%r8d, %r9d
	jne	.LBB389_35
.LBB389_37:
	pcmpeqd	%xmm2, %xmm2
	pcmpeqb	%xmm2, %xmm1
	pmovmskb	%xmm1, %r8d
	testl	%r8d, %r8d
	jne	.LBB389_43
	addq	%rdi, %rax
	addq	$16, %rax
	addq	$16, %rdi
	jmp	.LBB389_34
.LBB389_21:
	movq	%rax, %r12
	leaq	40(%r14), %rdx
	movq	96(%rcx), %rdi
	movq	104(%rcx), %rsi
	callq	_RINvYNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateNtNtCsaifZ2emd9Uo_4core4hash11BuildHasher8hash_oneRNtNtCs9S44gUqPSHd_11gpui_canvas4text8GlyphKeyEB1J_
	movq	8(%rsp), %rcx
	movq	%rax, %rdi
	shrq	$57, %rdi
	movq	64(%rcx), %rdx
	movq	72(%rcx), %rsi
	movd	%edi, %xmm0
	punpcklbw	%xmm0, %xmm0
	pshuflw	$0, %xmm0, %xmm0
	pshufd	$68, %xmm0, %xmm0
	xorl	%edi, %edi
.LBB389_22:
	andq	%rsi, %rax
	movdqu	(%rdx,%rax), %xmm1
	movdqa	%xmm1, %xmm2
	pcmpeqb	%xmm0, %xmm2
	pmovmskb	%xmm2, %r8d
	testl	%r8d, %r8d
	je	.LBB389_28
	movq	%r12, %r11
.LBB389_24:
	rep		bsfl	%r8d, %r9d
	addq	%rax, %r9
	andq	%rsi, %r9
	movq	%r9, %r10
	negq	%r10
	leaq	(%r10,%r10,2), %r10
	cmpq	-24(%rdx,%r10,8), %r11
	jne	.LBB389_27
	leaq	(%rdx,%r10,8), %r10
	cmpw	-12(%r10), %bx
	jne	.LBB389_27
	cmpl	-16(%r10), %r15d
	je	.LBB389_30
.LBB389_27:
	leal	-1(%r8), %r9d
	andw	%r8w, %r9w
	movl	%r9d, %r8d
	jne	.LBB389_24
.LBB389_28:
	pcmpeqd	%xmm2, %xmm2
	pcmpeqb	%xmm2, %xmm1
	pmovmskb	%xmm1, %r8d
	testl	%r8d, %r8d
	jne	.LBB389_43
	addq	%rdi, %rax
	addq	$16, %rax
	addq	$16, %rdi
	jmp	.LBB389_22
.LBB389_39:
	leaq	-16(%r8), %rax
	andq	%rsi, %rax
	movdqu	(%rdx,%rax), %xmm0
	pcmpeqd	%xmm1, %xmm1
	pcmpeqb	%xmm1, %xmm0
	pmovmskb	%xmm0, %esi
	movdqu	(%rdx,%r8), %xmm0
	pcmpeqb	%xmm1, %xmm0
	pmovmskb	%xmm0, %edi
	movw	$31, %r9w
	bsrw	%si, %r9w
	xorl	$15, %r9d
	orl	$65536, %edi
	rep		bsfl	%edi, %edi
	addl	%r9d, %edi
	movb	$-128, %sil
	cmpw	$15, %di
	ja	.LBB389_41
	incq	32(%rcx)
	movb	$-1, %sil
.LBB389_41:
	addq	%rdx, %rax
	movb	%sil, (%rdx,%r8)
	movl	$40, %edx
	jmp	.LBB389_42
.LBB389_30:
	shlq	$3, %r9
	leaq	(%r9,%r9,2), %rdi
	sarq	$3, %rdi
	movabsq	$-6148914691236517205, %rax
	imulq	%rax, %rdi
	leaq	-16(%rdi), %rax
	andq	%rsi, %rax
	movdqu	(%rdx,%rax), %xmm0
	pcmpeqd	%xmm1, %xmm1
	pcmpeqb	%xmm1, %xmm0
	pmovmskb	%xmm0, %esi
	movdqu	(%rdx,%rdi), %xmm0
	pcmpeqb	%xmm1, %xmm0
	pmovmskb	%xmm0, %r8d
	movw	$31, %r9w
	bsrw	%si, %r9w
	xorl	$15, %r9d
	orl	$65536, %r8d
	rep		bsfl	%r8d, %r8d
	addl	%r9d, %r8d
	movb	$-128, %sil
	cmpw	$15, %r8w
	ja	.LBB389_32
	incq	80(%rcx)
	movb	$-1, %sil
.LBB389_32:
	addq	%rdx, %rax
	movb	%sil, (%rdx,%rdi)
	movl	$88, %edx
.LBB389_42:
	movb	%sil, 16(%rax)
	decq	(%rcx,%rdx)
.LBB389_43:
	lock		decq	(%r14)
	jne	.LBB389_45
	#MEMBARRIER
	leaq	48(%rsp), %rdi
	callq	*_RNvMsn_NtNtCse3dB2pZFcs1_5alloc3rcs3arcINtB5_3ArcNtNtCs9S44gUqPSHd_11gpui_canvas4text6RasterE9drop_slowBP_@GOTPCREL(%rip)
	movq	8(%rsp), %rcx
	jmp	.LBB389_45
.LBB389_55:
	cmpq	$0, 184(%rsp)
	je	.LBB389_56
	movq	8(%rsp), %rax
	movq	424(%rax), %rdx
	movq	432(%rax), %rcx
	testq	%rdx, %rdx
	js	.LBB389_48
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rdx, %xmm0
	jmp	.LBB389_50
.LBB389_17:
	movq	8(%rsp), %rcx
.LBB389_46:
	movq	%r13, 64(%rsp)
	leaq	64(%rsp), %rdi
	movq	%rcx, %rbx
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueINtNtNtCse3dB2pZFcs1_5alloc3vec5drain5DrainINtNtNtBI_3rcs3arc3ArcNtNtCs9S44gUqPSHd_11gpui_canvas4text6RasterEEEB1I_
	movdqa	352(%rsp), %xmm0
	movdqu	%xmm0, (%rbx)
	movl	24(%rsp), %eax
	jmp	.LBB389_5
.LBB389_56:
	movl	$-1, %eax
	jmp	.LBB389_4
.LBB389_48:
	movq	%rdx, %rsi
	shrq	%rsi
	andl	$1, %edx
	orq	%rsi, %rdx
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rdx, %xmm0
	addss	%xmm0, %xmm0
.LBB389_50:
	movq	16(%rsp), %rdx
	testq	%rcx, %rcx
	js	.LBB389_51
	cvtsi2ss	%rcx, %xmm1
	jmp	.LBB389_53
.LBB389_51:
	movq	%rcx, %rsi
	shrq	%rsi
	andl	$1, %ecx
	orq	%rsi, %rcx
	cvtsi2ss	%rcx, %xmm1
	addss	%xmm1, %xmm1
.LBB389_53:
	movq	$0, 48(%rsp)
	movss	%xmm0, 56(%rsp)
	movss	%xmm1, 60(%rsp)
	leaq	184(%rax), %r12
	movq	%rbx, %rdi
	movq	%r12, %rsi
	callq	_RNvMsa_NtNtCs9S44gUqPSHd_11gpui_canvas6canvas7columnsNtB5_8PaintUse6commit
	cmpb	$0, 320(%rsp)
	je	.LBB389_57
	movups	324(%rsp), %xmm0
	movups	336(%rsp), %xmm1
	movups	%xmm1, 300(%rsp)
	movaps	%xmm0, 288(%rsp)
	movups	272(%rsp), %xmm0
	movaps	%xmm0, 128(%rsp)
	movdqu	208(%rsp), %xmm0
	movdqu	224(%rsp), %xmm1
	movups	240(%rsp), %xmm2
	movups	256(%rsp), %xmm3
	movaps	%xmm3, 112(%rsp)
	movaps	%xmm2, 96(%rsp)
	movdqa	%xmm1, 80(%rsp)
	movdqa	%xmm0, 64(%rsp)
	leaq	64(%rsp), %rsi
	leaq	288(%rsp), %rdx
	leaq	48(%rsp), %rcx
	movq	8(%rsp), %rdi
	movl	%eax, %r8d
	callq	_RNvMs2_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB5_11DisplayList13append_inline
	jmp	.LBB389_58
.LBB389_57:
	movups	272(%rsp), %xmm0
	movaps	%xmm0, 128(%rsp)
	movdqu	208(%rsp), %xmm0
	movdqu	224(%rsp), %xmm1
	movups	240(%rsp), %xmm2
	movups	256(%rsp), %xmm3
	movaps	%xmm3, 112(%rsp)
	movaps	%xmm2, 96(%rsp)
	movdqa	%xmm1, 80(%rsp)
	movdqa	%xmm0, 64(%rsp)
	movq	%r15, %rbx
	leaq	288(%rsp), %r15
	leaq	64(%rsp), %rdx
	leaq	48(%rsp), %rcx
	movq	%r15, %rdi
	movq	%r12, %rsi
	movl	%eax, %r8d
	xorl	%r9d, %r9d
	callq	_RNvMs5_NtNtCs9S44gUqPSHd_11gpui_canvas6canvas7columnsNtB5_7Columns5store
	movq	8(%rsp), %rdi
	movq	%rbx, %rsi
	movq	%r15, %rdx
	callq	_RNvMs2_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB5_11DisplayList13publish_group
.LBB389_58:
	movq	192(%rsp), %rcx
	movq	8(%rsp), %rax
	addq	%rcx, 456(%rax)
	movq	200(%rsp), %rcx
	addq	%rcx, 464(%rax)
	movq	472(%rax), %rcx
	testq	%rcx, %rcx
	je	.LBB389_60
	movq	$0, 48(%rcx)
.LBB389_60:
	movb	$1, 480(%rax)
	movl	$-1, %eax
	jmp	.LBB389_4
.Lfunc_end389:
