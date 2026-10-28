_RNvMsc_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB5_6Canvas10fill_shape:
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
	subq	$200, %rsp
	.cfi_def_cfa_offset 256
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movl	%r9d, %r14d
	movq	%r8, %r12
	movq	%rdx, %r13
	movq	%rsi, %r15
	movq	%rdi, %rbx
	movq	280(%rdi), %rsi
	leaq	8(%rsp), %rdi
	movq	%rcx, %rdx
	callq	_RNvMs5_NtNtCs9S44gUqPSHd_11gpui_canvas6canvas5clipsNtB7_6Canvas12resolve_clip
	movl	12(%rsp), %eax
	movl	16(%rsp), %ebp
	cmpl	$1, 8(%rsp)
	je	.LBB385_28
	movl	%r14d, 68(%rsp)
	movl	%eax, %r14d
	movq	%rbx, 72(%rsp)
	movq	%r12, %rbx
	movq	20(%rsp), %r12
	leaq	8(%rsp), %rdi
	movq	%r13, %rsi
	callq	_RNvMNtCs9S44gUqPSHd_11gpui_canvas6canvasNtB2_7Mapping3new
	cmpl	$1, 8(%rsp)
	jne	.LBB385_3
	movl	12(%rsp), %eax
	movl	16(%rsp), %ebp
	jmp	.LBB385_28
.LBB385_3:
	movl	16(%rsp), %eax
	movups	20(%rsp), %xmm0
	movups	%xmm0, 140(%rsp)
	movups	36(%rsp), %xmm0
	movups	%xmm0, 156(%rsp)
	movups	48(%rsp), %xmm0
	movups	%xmm0, 168(%rsp)
	movl	%r14d, 120(%rsp)
	movl	%ebp, 124(%rsp)
	movq	%r12, 128(%rsp)
	movl	%eax, 136(%rsp)
	movq	%rbx, %r12
	movups	(%rbx), %xmm0
	movups	%xmm0, 184(%rsp)
	leaq	8(%rsp), %rdi
	leaq	120(%rsp), %r8
	movq	72(%rsp), %rbx
	movq	%rbx, %rsi
	movq	%r15, %rdx
	movq	%r13, %rcx
	movl	68(%rsp), %r14d
	movl	%r14d, %r9d
	callq	_RNvMsc_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB5_6Canvas7prepare
	movl	8(%rsp), %eax
	movl	12(%rsp), %r15d
	movl	16(%rsp), %ebp
	cmpl	$2, %eax
	jne	.LBB385_5
	movl	%r15d, %eax
	jmp	.LBB385_28
.LBB385_5:
	cmpl	$1, %eax
	jne	.LBB385_27
	movq	424(%rbx), %rcx
	movq	432(%rbx), %rax
	testq	%rcx, %rcx
	js	.LBB385_9
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rcx, %xmm0
	movq	256(%rsp), %rdx
	testq	%rax, %rax
	jns	.LBB385_10
.LBB385_8:
	movq	%rax, %rcx
	shrq	%rcx
	andl	$1, %eax
	orq	%rcx, %rax
	cvtsi2ss	%rax, %xmm1
	addss	%xmm1, %xmm1
	jmp	.LBB385_11
.LBB385_9:
	movq	%rcx, %rdx
	shrq	%rdx
	andl	$1, %ecx
	orq	%rdx, %rcx
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rcx, %xmm0
	addss	%xmm0, %xmm0
	movq	256(%rsp), %rdx
	testq	%rax, %rax
	js	.LBB385_8
.LBB385_10:
	cvtsi2ss	%rax, %xmm1
.LBB385_11:
	movq	28(%rsp), %r13
	movups	20(%rsp), %xmm2
	movl	36(%rsp), %eax
	leaq	184(%rbx), %rdi
	movq	$0, 8(%rsp)
	movss	%xmm0, 16(%rsp)
	movss	%xmm1, 20(%rsp)
	movl	(%rdx), %ecx
	testl	%ecx, %ecx
	movaps	%xmm2, 96(%rsp)
	movl	%eax, 4(%rsp)
	je	.LBB385_14
	cmpl	$1, %ecx
	jne	.LBB385_15
	movl	4(%rdx), %ecx
.LBB385_14:
	xorl	%eax, %eax
	jmp	.LBB385_16
.LBB385_15:
	movq	8(%rdx), %rax
	movl	(%rax), %ecx
	testl	%ecx, %ecx
	sete	%al
.LBB385_16:
	xorl	%r8d, %r8d
	cmpl	$1073741824, %r14d
	setge	%r8b
	movzbl	%al, %r9d
	leaq	120(%rsp), %rsi
	leaq	8(%rsp), %rdx
	movq	%rdi, %r14
	callq	_RNvMs5_NtNtCs9S44gUqPSHd_11gpui_canvas6canvas7columnsNtB5_7Columns5admit
	cmpl	$-1, %eax
	jne	.LBB385_17
	movq	%rbx, %rdi
	movq	%r13, %rsi
	callq	_RNvMsc_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB5_6Canvas5admit
	cmpl	$-1, %eax
	je	.LBB385_20
.LBB385_17:
	jmp	.LBB385_28
.LBB385_20:
	movq	256(%rsp), %rdi
	movq	%r14, %rsi
	movq	%r12, %rdx
	callq	_RNvMsa_NtNtCs9S44gUqPSHd_11gpui_canvas6canvas7columnsNtB5_8PaintUse6commit
	movq	424(%rbx), %rdx
	movq	432(%rbx), %rcx
	testq	%rdx, %rdx
	js	.LBB385_22
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rdx, %xmm0
	jmp	.LBB385_23
.LBB385_22:
	movq	%rdx, %rsi
	shrq	%rsi
	andl	$1, %edx
	orq	%rsi, %rdx
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rdx, %xmm0
	addss	%xmm0, %xmm0
.LBB385_23:
	movaps	96(%rsp), %xmm2
	testq	%rcx, %rcx
	js	.LBB385_25
	xorps	%xmm1, %xmm1
	cvtsi2ss	%rcx, %xmm1
	jmp	.LBB385_26
.LBB385_25:
	movq	%rcx, %rdx
	shrq	%rdx
	andl	$1, %ecx
	orq	%rdx, %rcx
	xorps	%xmm1, %xmm1
	cvtsi2ss	%rcx, %xmm1
	addss	%xmm1, %xmm1
.LBB385_26:
	movl	4(%rsp), %ecx
	movq	$0, 80(%rsp)
	movss	%xmm0, 88(%rsp)
	movss	%xmm1, 92(%rsp)
	movl	%r15d, 8(%rsp)
	movl	%ebp, 12(%rsp)
	movups	%xmm2, 16(%rsp)
	movl	%ecx, 32(%rsp)
	leaq	120(%rsp), %rsi
	leaq	8(%rsp), %rdx
	leaq	80(%rsp), %rcx
	movq	%rbx, %rdi
	movl	%eax, %r8d
	callq	_RNvMs2_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB5_11DisplayList13append_inline
	movb	$1, 480(%rbx)
.LBB385_27:
	movl	$-1, %eax
.LBB385_28:
	movl	%ebp, %edx
	addq	$200, %rsp
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
.Lfunc_end385:
