_RNCNvMsc_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB7_6Canvas17draw_text_working0B9_:
.Lfunc_begin27:
	.cfi_startproc
	.cfi_personality 155, DW.ref._RNvCseilXckri75C_7___rustc19rust_eh_personality
	.cfi_lsda 27, .Lexception27
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
	subq	$4096, %rsp
	.cfi_adjust_cfa_offset 4096
	movq	$0, (%rsp)
	subq	$4096, %rsp
	.cfi_adjust_cfa_offset 4096
	movq	$0, (%rsp)
	subq	$4096, %rsp
	.cfi_adjust_cfa_offset 4096
	movq	$0, (%rsp)
	subq	$4096, %rsp
	.cfi_adjust_cfa_offset 4096
	movq	$0, (%rsp)
	subq	$3176, %rsp
	.cfi_def_cfa_offset 19616
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%rdi, 304(%rsp)
	movq	(%rdi), %r15
	movzwl	12(%r15), %eax
	testq	%rax, %rax
	je	.LBB165_805
	movq	(%r15), %r12
	leaq	(%rax,%rax,2), %rax
	leaq	(%r12,%rax,4), %rax
	movq	%rax, 792(%rsp)
	movq	304(%rsp), %rax
	movq	8(%rax), %r13
	movq	16(%rax), %rcx
	movq	%rcx, 512(%rsp)
	movq	24(%rax), %rcx
	leaq	64(%rcx), %rdx
	movq	%rdx, 456(%rsp)
	leaq	96(%rcx), %rdx
	movq	%rdx, 448(%rsp)
	leaq	16(%rcx), %rdx
	movq	%rdx, 472(%rsp)
	leaq	48(%rcx), %rdx
	movq	%rdx, 464(%rsp)
	leaq	8(%r13), %rdx
	movq	%rdx, 368(%rsp)
	leaq	40(%r13), %rdx
	movq	%rdx, 752(%rsp)
	movq	32(%rax), %rdx
	movq	%rdx, 832(%rsp)
	movq	48(%rax), %rdx
	movq	%rdx, 824(%rsp)
	movq	40(%rax), %rdx
	movq	%rdx, 816(%rsp)
	movq	56(%rax), %rdx
	movq	%rdx, 808(%rsp)
	movq	64(%rax), %rdx
	movq	%rdx, 800(%rsp)
	movq	72(%rax), %rdx
	movq	%rdx, 784(%rsp)
	movq	80(%rax), %rdx
	movq	%rdx, 496(%rsp)
	movq	88(%rax), %rdx
	movq	%rdx, 776(%rsp)
	leaq	256(%rcx), %rdx
	movq	%rdx, 768(%rsp)
	movq	%rcx, 104(%rsp)
	leaq	232(%rcx), %rcx
	movq	%rcx, 360(%rsp)
	movq	96(%rax), %rcx
	movq	%rcx, 488(%rsp)
	addq	$4, %rcx
	movq	%rcx, 760(%rsp)
	movq	104(%rax), %rax
	movq	%rax, 480(%rsp)
	movq	%r13, 72(%rsp)
	movq	%r15, 504(%rsp)
	jmp	.LBB165_2
	.p2align	4
.LBB165_729:
	addq	$12, %r12
	cmpq	792(%rsp), %r12
	je	.LBB165_805
.LBB165_2:
	movl	(%r12), %r10d
	movl	%r10d, %eax
	andl	$131071, %eax
	cmpl	$65535, %eax
	ja	.LBB165_4
	movq	4(%r12), %xmm1
	movq	512(%rsp), %rax
	movd	(%rax), %xmm0
	movq	16(%r15), %rbx
	xorl	%r14d, %r14d
	jmp	.LBB165_7
	.p2align	4
.LBB165_4:
	leal	16711680(,%rax,2), %ecx
	andl	$16711680, %ecx
	movq	4(%r12), %xmm1
	movq	512(%rsp), %rax
	movd	(%rax), %xmm0
	movq	16(%r15), %rbx
	andl	$32767, %r10d
	movl	%ecx, %r14d
	shrl	$16, %r14d
	testl	%ecx, %ecx
	je	.LBB165_7
	movl	$13, %eax
	cmpl	$196607, %ecx
	ja	.LBB165_821
	movq	16(%rbx,%r14,8), %rcx
	xorl	%ebp, %ebp
	testq	%rcx, %rcx
	jne	.LBB165_8
	jmp	.LBB165_851
	.p2align	4
.LBB165_7:
	movq	16(%rbx), %rcx
	movb	$1, %bpl
.LBB165_8:
	movdqa	%xmm1, 1024(%rsp)
	movq	%r12, 520(%rsp)
	movq	40(%rcx), %r15
	movq	%r15, 320(%rsp)
	movd	%xmm0, 328(%rsp)
	movw	%r10w, 332(%rsp)
	movd	%xmm0, %eax
	movq	%rax, 128(%rsp)
	shlq	$16, %rax
	movzwl	%r10w, %r12d
	orq	%rax, %r12
	movq	%r12, 1040(%rsp)
	movq	104(%rsp), %rax
	cmpl	$1, (%rax)
	movq	%r10, 232(%rsp)
	movd	%xmm0, 140(%rsp)
	jne	.LBB165_17
	cmpq	%r15, 8(%rax)
	jne	.LBB165_17
	cmpq	$0, 40(%rax)
	je	.LBB165_26
	movq	104(%rsp), %r15
	movq	48(%r15), %rdi
	movq	56(%r15), %rsi
	leaq	1040(%rsp), %rdx
	callq	_RINvYNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateNtNtCsaifZ2emd9Uo_4core4hash11BuildHasher8hash_oneRNtNtCs9S44gUqPSHd_11gpui_canvas5image8ImageKeyEB1J_
	movq	232(%rsp), %r10
	movq	%rax, %rsi
	shrq	$57, %rsi
	movq	16(%r15), %rcx
	movq	24(%r15), %rdx
	movd	%esi, %xmm0
	punpcklbw	%xmm0, %xmm0
	pshuflw	$0, %xmm0, %xmm0
	pshufd	$68, %xmm0, %xmm3
	xorl	%esi, %esi
.LBB165_12:
	andq	%rdx, %rax
	movdqu	(%rcx,%rax), %xmm1
	movdqa	%xmm1, %xmm2
	pcmpeqb	%xmm3, %xmm2
	pmovmskb	%xmm2, %edi
	testl	%edi, %edi
	je	.LBB165_15
.LBB165_13:
	rep		bsfl	%edi, %r9d
	addq	%rax, %r9
	andq	%rdx, %r9
	shlq	$4, %r9
	movq	%rcx, %r8
	subq	%r9, %r8
	cmpq	-16(%r8), %r12
	je	.LBB165_28
	leal	-1(%rdi), %r8d
	andw	%di, %r8w
	movl	%r8d, %edi
	jne	.LBB165_13
.LBB165_15:
	pcmpeqd	%xmm2, %xmm2
	pcmpeqb	%xmm2, %xmm1
	pmovmskb	%xmm1, %edi
	testl	%edi, %edi
	movd	140(%rsp), %xmm0
	jne	.LBB165_26
	addq	%rsi, %rax
	addq	$16, %rax
	addq	$16, %rsi
	jmp	.LBB165_12
	.p2align	4
.LBB165_17:
	cmpq	$0, 88(%rax)
	je	.LBB165_26
	movq	104(%rsp), %r12
	movq	96(%r12), %rdi
	movq	104(%r12), %rsi
	leaq	320(%rsp), %rdx
	callq	_RINvYNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateNtNtCsaifZ2emd9Uo_4core4hash11BuildHasher8hash_oneRNtNtCs9S44gUqPSHd_11gpui_canvas4text8GlyphKeyEB1J_
	movq	232(%rsp), %r10
	movq	%rax, %rsi
	shrq	$57, %rsi
	movq	64(%r12), %rcx
	movq	72(%r12), %rdx
	movd	%esi, %xmm0
	punpcklbw	%xmm0, %xmm0
	pshuflw	$0, %xmm0, %xmm0
	pshufd	$68, %xmm0, %xmm3
	xorl	%esi, %esi
.LBB165_19:
	andq	%rdx, %rax
	movdqu	(%rcx,%rax), %xmm1
	movdqa	%xmm1, %xmm2
	pcmpeqb	%xmm3, %xmm2
	pmovmskb	%xmm2, %edi
	testl	%edi, %edi
	je	.LBB165_24
.LBB165_20:
	rep		bsfl	%edi, %r8d
	addq	%rax, %r8
	andq	%rdx, %r8
	negq	%r8
	leaq	(%r8,%r8,2), %r8
	cmpq	-24(%rcx,%r8,8), %r15
	jne	.LBB165_23
	leaq	(%rcx,%r8,8), %r8
	cmpw	-12(%r8), %r10w
	jne	.LBB165_23
	movq	128(%rsp), %r9
	cmpl	%r9d, -16(%r8)
	je	.LBB165_28
.LBB165_23:
	leal	-1(%rdi), %r8d
	andw	%di, %r8w
	movl	%r8d, %edi
	jne	.LBB165_20
.LBB165_24:
	pcmpeqd	%xmm2, %xmm2
	pcmpeqb	%xmm2, %xmm1
	pmovmskb	%xmm1, %edi
	testl	%edi, %edi
	movd	140(%rsp), %xmm0
	jne	.LBB165_26
	addq	%rsi, %rax
	addq	$16, %rax
	addq	$16, %rsi
	jmp	.LBB165_19
	.p2align	4
.LBB165_26:
	testb	%bpl, %bpl
	je	.LBB165_32
	movq	16(%rbx), %r8
	jmp	.LBB165_33
	.p2align	4
.LBB165_28:
	movl	-8(%r8), %ebx
	movq	$0, 312(%rsp)
	movq	104(%rsp), %rax
	movq	272(%rax), %rsi
	cmpq	%rbx, %rsi
	jbe	.LBB165_896
	movq	264(%rax), %rax
	movq	(%rax,%rbx,8), %rax
	movb	$1, %r14b
	movq	$0, 24(%rsp)
	movq	64(%rax), %rcx
	testq	%rcx, %rcx
	js	.LBB165_712
.LBB165_30:
	xorps	%xmm2, %xmm2
	cvtsi2ss	%rcx, %xmm2
	movq	56(%rax), %rcx
	testq	%rcx, %rcx
	jns	.LBB165_713
.LBB165_31:
	movq	%rcx, %rdx
	shrq	%rdx
	andl	$1, %ecx
	orq	%rdx, %rcx
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rcx, %xmm0
	addss	%xmm0, %xmm0
	jmp	.LBB165_714
	.p2align	4
.LBB165_32:
	movq	16(%rbx,%r14,8), %r8
	testq	%r8, %r8
	je	.LBB165_822
.LBB165_33:
	movq	128(%rsp), %rcx
	testl	%ecx, %ecx
	sets	%al
	andl	$2147483647, %ecx
	leal	-8388608(%rcx), %edx
	cmpl	$2130706432, %edx
	setb	%dl
	andb	%al, %dl
	leal	-1(%rcx), %esi
	cmpl	$8388607, %esi
	setb	%sil
	andb	%al, %sil
	testl	%ecx, %ecx
	sete	%al
	cmpl	$2139095040, %ecx
	sete	%dil
	orb	%al, %dil
	cmpl	$2139095041, %ecx
	setge	%al
	orb	%dil, %al
	orb	%sil, %al
	xorl	%ebp, %ebp
	orb	%dl, %al
	movl	$6, %eax
	jne	.LBB165_851
	ucomiss	.LCPI165_0(%rip), %xmm0
	ja	.LBB165_851
	movq	%r8, 376(%rsp)
	movq	40(%r8), %rax
	movq	%rax, 384(%rsp)
	movq	%rax, 400(%rsp)
	movw	%r10w, 412(%rsp)
	movss	%xmm0, 408(%rsp)
	cmpq	$0, 32(%r13)
	je	.LBB165_44
	movq	40(%r13), %rbx
	movq	48(%r13), %r14
	movq	%rbx, %rdi
	movq	%r14, %rsi
	leaq	400(%rsp), %rdx
	callq	_RINvYNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateNtNtCsaifZ2emd9Uo_4core4hash11BuildHasher8hash_oneRNtNtCs9S44gUqPSHd_11gpui_canvas4text8GlyphKeyEB1J_
	movss	140(%rsp), %xmm0
	movq	232(%rsp), %r10
	movq	%rax, %rcx
	shrq	$57, %rcx
	movq	8(%r13), %r15
	movq	16(%r13), %r12
	movd	%ecx, %xmm1
	punpcklbw	%xmm1, %xmm1
	pshuflw	$0, %xmm1, %xmm1
	pshufd	$68, %xmm1, %xmm3
	xorl	%ecx, %ecx
.LBB165_37:
	andq	%r12, %rax
	movdqu	(%r15,%rax), %xmm1
	movdqa	%xmm1, %xmm2
	pcmpeqb	%xmm3, %xmm2
	pmovmskb	%xmm2, %edx
	testl	%edx, %edx
	je	.LBB165_42
.LBB165_38:
	rep		bsfl	%edx, %esi
	addq	%rax, %rsi
	andq	%r12, %rsi
	negq	%rsi
	leaq	(%rsi,%rsi,2), %rsi
	movq	384(%rsp), %rdi
	cmpq	-24(%r15,%rsi,8), %rdi
	jne	.LBB165_41
	leaq	(%r15,%rsi,8), %rsi
	cmpw	%r10w, -12(%rsi)
	jne	.LBB165_41
	movq	128(%rsp), %rdi
	cmpl	%edi, -16(%rsi)
	je	.LBB165_702
.LBB165_41:
	leal	-1(%rdx), %esi
	andw	%dx, %si
	movl	%esi, %edx
	jne	.LBB165_38
.LBB165_42:
	pcmpeqd	%xmm2, %xmm2
	pcmpeqb	%xmm2, %xmm1
	pmovmskb	%xmm1, %edx
	testl	%edx, %edx
	jne	.LBB165_44
	addq	%rcx, %rax
	addq	$16, %rax
	addq	$16, %rcx
	jmp	.LBB165_37
	.p2align	4
.LBB165_44:
	movq	$0, 840(%rsp)
	movq	$4, 848(%rsp)
	leaq	856(%rsp), %rax
	pxor	%xmm1, %xmm1
	movdqu	%xmm1, (%rax)
	movq	$1, 872(%rsp)
	movw	$0, 916(%rsp)
	movb	$0, 918(%rsp)
	movq	$0, 920(%rsp)
	leaq	880(%rsp), %rcx
	movdqu	%xmm1, 12(%rcx)
	movdqu	%xmm1, (%rcx)
	movq	$4, 928(%rsp)
	movdqu	%xmm1, 80(%rax)
	movq	$4, 952(%rsp)
	movdqu	%xmm1, 104(%rax)
	movq	$4, 976(%rsp)
	movdqu	%xmm1, 128(%rax)
	movq	$0, 144(%rax)
	movq	64(%r13), %r12
	leaq	40(%r12), %r14
	testq	%r12, %r12
	movq	%r12, %rbx
	leaq	840(%rsp), %rax
	cmoveq	%rax, %rbx
	cmoveq	%rcx, %r14
	movq	$0, 16(%rbx)
	movq	$0, 40(%rbx)
	movl	$0, 64(%rbx)
	movdqu	%xmm1, 48(%rbx)
	movw	$0, 76(%rbx)
	movb	$1, 78(%rbx)
	movq	376(%rsp), %rax
	movq	24(%rax), %rsi
	movq	32(%rax), %rdx
.Ltmp1010:
	leaq	1040(%rsp), %rdi
	movl	%r10d, %ecx
	movq	%rbx, %r8
	callq	_RNvNtCs9S44gUqPSHd_11gpui_canvas4text14decode_outline
.Ltmp1011:
	movl	1040(%rsp), %eax
	movsd	1044(%rsp), %xmm0
	movaps	%xmm0, 416(%rsp)
	cmpl	$2, %eax
	je	.LBB165_818
	movq	1052(%rsp), %r9
	movl	%r9d, %r10d
	shrq	$32, %r9
	movl	%eax, 24(%rsp)
	cmpl	$1, %eax
	jne	.LBB165_51
	movd	%r10d, %xmm7
	movdqa	%xmm7, %xmm0
	movaps	416(%rsp), %xmm6
	subss	%xmm6, %xmm0
	movss	.LCPI165_1(%rip), %xmm2
	addss	%xmm2, %xmm0
	cvttss2si	%xmm0, %rcx
	movq	%rcx, %rdx
	sarq	$63, %rdx
	movaps	%xmm0, %xmm1
	movss	.LCPI165_2(%rip), %xmm3
	subss	%xmm3, %xmm1
	cvttss2si	%xmm1, %rax
	andq	%rdx, %rax
	orq	%rcx, %rax
	xorl	%ecx, %ecx
	xorps	%xmm4, %xmm4
	ucomiss	%xmm4, %xmm0
	cmovbq	%rcx, %rax
	movss	.LCPI165_3(%rip), %xmm5
	ucomiss	%xmm5, %xmm0
	pshufd	$85, %xmm6, %xmm0
	movq	$-1, %r8
	cmovaq	%r8, %rax
	movd	%r9d, %xmm6
	movdqa	%xmm6, %xmm1
	subss	%xmm0, %xmm1
	addss	%xmm2, %xmm1
	cvttss2si	%xmm1, %rdx
	movq	%rdx, %rsi
	sarq	$63, %rsi
	movaps	%xmm1, %xmm0
	subss	%xmm3, %xmm0
	cvttss2si	%xmm0, %rdi
	andq	%rsi, %rdi
	orq	%rdx, %rdi
	ucomiss	%xmm4, %xmm1
	cmovbq	%rcx, %rdi
	ucomiss	%xmm5, %xmm1
	cmovaq	%r8, %rdi
	mulq	%rdi
	jo	.LBB165_870
	cmpq	$1048576, %rax
	ja	.LBB165_823
	addq	56(%r13), %rax
	cmpq	$8388609, %rax
	setae	%al
	movq	32(%r13), %r13
	cmpq	$4096, %r13
	setae	%cl
	orb	%al, %cl
	jne	.LBB165_52
	cmpb	$0, 77(%rbx)
	movq	72(%rsp), %r13
	jne	.LBB165_82
	jmp	.LBB165_100
.LBB165_51:
	movq	%r13, %rax
	movq	32(%r13), %r13
	cmpq	$8388609, 56(%rax)
	setae	%al
	cmpq	$4096, %r13
	setae	%cl
	orb	%al, %cl
	je	.LBB165_61
.LBB165_52:
	movq	%r14, 16(%rsp)
	testq	%r13, %r13
	movq	%r9, 48(%rsp)
	movl	%r10d, 88(%rsp)
	je	.LBB165_64
	movq	368(%rsp), %rax
	movq	(%rax), %r14
	movdqa	(%r14), %xmm0
	leaq	16(%r14), %r15
	pmovmskb	%xmm0, %ebp
	notl	%ebp
	movq	%r14, 40(%rsp)
	jmp	.LBB165_55
	.p2align	4
.LBB165_54:
	leal	-1(%rbp), %eax
	andl	%ebp, %eax
	movl	%eax, %ebp
	decq	%r13
	je	.LBB165_59
.LBB165_55:
	testw	%bp, %bp
	jne	.LBB165_57
	.p2align	4
.LBB165_56:
	movdqa	(%r15), %xmm0
	addq	$-384, %r14
	addq	$16, %r15
	pmovmskb	%xmm0, %ebp
	xorw	$-1, %bp
	je	.LBB165_56
.LBB165_57:
	rep		bsfl	%ebp, %eax
	negq	%rax
	leaq	(%rax,%rax,2), %rax
	movq	-8(%r14,%rax,8), %rcx
	lock		decq	(%rcx)
	jne	.LBB165_54
	leaq	(%r14,%rax,8), %rdi
	addq	$-8, %rdi
	#MEMBARRIER
	callq	*_RNvMsn_NtNtCse3dB2pZFcs1_5alloc3rcs3arcINtB5_3ArcNtNtCs9S44gUqPSHd_11gpui_canvas4text6RasterE9drop_slowBP_@GOTPCREL(%rip)
	jmp	.LBB165_54
.LBB165_59:
	movq	72(%rsp), %r15
	movq	16(%r15), %r14
	testq	%r14, %r14
	je	.LBB165_62
	leaq	17(%r14), %rdx
	movq	40(%rsp), %rdi
	movl	$255, %esi
	callq	*memset@GOTPCREL(%rip)
	leaq	1(%r14), %rax
	movq	%rax, %rcx
	shrq	$3, %rcx
	andq	$-8, %rax
	subq	%rcx, %rax
	cmpq	$8, %r14
	cmovbq	%r14, %rax
	jmp	.LBB165_63
.LBB165_61:
	movb	$1, %al
	movl	%eax, 24(%rsp)
	movl	$1, %eax
	movq	%rax, 88(%rsp)
	movq	$0, 296(%rsp)
	movq	$0, 288(%rsp)
	xorl	%ebx, %ebx
	xorl	%r14d, %r14d
	xorl	%ecx, %ecx
	movq	72(%rsp), %r13
	jmp	.LBB165_677
.LBB165_62:
	xorl	%eax, %eax
.LBB165_63:
	movq	$0, 32(%r15)
	movq	%rax, 24(%r15)
.LBB165_64:
	movq	72(%rsp), %rax
	movq	$0, 56(%rax)
	movq	(%rbx), %rsi
	movq	16(%rbx), %r14
	cmpq	%r14, %rsi
	leaq	840(%rsp), %r13
	jbe	.LBB165_69
	testq	%r12, %r12
	movq	%r12, %rax
	cmoveq	%r13, %rax
	movq	%rax, 40(%rsp)
	movq	8(%rax), %rdi
	shlq	$3, %rsi
	testq	%r14, %r14
	je	.LBB165_67
	leaq	(,%r14,8), %rbp
	movl	$4, %r13d
	movl	$4, %edx
	movq	%rbp, %rcx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_realloc@GOTPCREL(%rip)
	movq	%rax, %r15
	testq	%rax, %rax
	jne	.LBB165_68
	jmp	.LBB165_810
.LBB165_67:
	movl	$4, %r15d
	movl	$4, %edx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB165_68:
	movq	40(%rsp), %rax
	movq	%r15, 8(%rax)
	movq	%r14, (%rbx)
	leaq	840(%rsp), %r13
.LBB165_69:
	movq	24(%rbx), %rsi
	movq	40(%rbx), %rbp
	cmpq	%rbp, %rsi
	jbe	.LBB165_74
	testq	%r12, %r12
	movq	%r12, %r14
	cmoveq	%r13, %r14
	movq	32(%r14), %rdi
	testq	%rbp, %rbp
	je	.LBB165_72
	movl	$1, %r13d
	movl	$1, %edx
	movq	%rbp, %rcx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_realloc@GOTPCREL(%rip)
	movq	%rax, %r15
	testq	%rax, %rax
	jne	.LBB165_73
	jmp	.LBB165_810
.LBB165_72:
	movl	$1, %r15d
	movl	$1, %edx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB165_73:
	movq	%r15, 32(%r14)
	movq	%rbp, 24(%rbx)
	leaq	840(%rsp), %r13
.LBB165_74:
	testq	%r12, %r12
	movq	%r12, %r14
	cmoveq	%r13, %r14
	movq	80(%r14), %rax
	testq	%rax, %rax
	je	.LBB165_76
	testq	%r12, %r12
	movq	%r12, %rcx
	cmoveq	%r13, %rcx
	movq	88(%rcx), %rdi
	shlq	$2, %rax
	leaq	(%rax,%rax,8), %rsi
	movl	$4, %edx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB165_76:
	testq	%r12, %r12
	movq	%r12, %r15
	cmoveq	%r13, %r15
	movq	104(%r15), %rsi
	testq	%rsi, %rsi
	movq	%r13, %rbp
	je	.LBB165_78
	testq	%r12, %r12
	movq	%r12, %rax
	leaq	840(%rsp), %rcx
	cmoveq	%rcx, %rax
	movq	112(%rax), %rdi
	shlq	$4, %rsi
	movl	$4, %edx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	leaq	840(%rsp), %rbp
.LBB165_78:
	testq	%r12, %r12
	movq	%r12, %r13
	cmoveq	%rbp, %r13
	movq	128(%r13), %rsi
	testq	%rsi, %rsi
	je	.LBB165_80
	testq	%r12, %r12
	movq	%r12, %rax
	cmoveq	%rbp, %rax
	movq	136(%rax), %rdi
	shlq	$2, %rsi
	movl	$4, %edx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB165_80:
	testq	%r12, %r12
	movq	$0, 80(%r14)
	movq	%r12, %rax
	cmoveq	%rbp, %rax
	movq	$4, 88(%rax)
	movq	$0, 96(%rax)
	movq	$0, 104(%r15)
	movq	$4, 112(%rax)
	movq	$0, 120(%rax)
	movq	$0, 128(%r13)
	movq	$4, 136(%rax)
	movq	$0, 144(%rax)
	xorps	%xmm0, %xmm0
	movups	%xmm0, 152(%rax)
	testb	$1, 24(%rsp)
	je	.LBB165_86
	movd	88(%rsp), %xmm7
	movd	48(%rsp), %xmm6
	movq	16(%rsp), %r14
	cmpb	$0, 77(%rbx)
	movq	72(%rsp), %r13
	je	.LBB165_100
.LBB165_82:
	movq	48(%rbx), %r15
	leaq	(,%r15,8), %rbp
	movq	%r15, %rax
	shrq	$61, %rax
	setne	%al
	movabsq	$9223372036854775804, %rcx
	cmpq	%rcx, %rbp
	seta	%cl
	orb	%al, %cl
	jne	.LBB165_809
	movq	%r14, 16(%rsp)
	testq	%rbp, %rbp
	movd	%xmm7, 24(%rsp)
	movd	%xmm6, 48(%rsp)
	je	.LBB165_89
	callq	*_RNvCseilXckri75C_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$4, %r13d
	movl	$4, %esi
	movq	%rbp, %rdi
	callq	*_RNvCseilXckri75C_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB165_810
	movq	%rax, %rcx
	leaq	840(%rsp), %rax
	movq	%rcx, %rbp
	movq	56(%rbx), %r14
	testq	%r14, %r14
	js	.LBB165_816
	jmp	.LBB165_90
.LBB165_86:
	movq	72(%rsp), %r13
	movq	64(%r13), %rbx
	testq	%rbx, %rbx
	je	.LBB165_88
	movq	%rbx, %rdi
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueNtNtCs9S44gUqPSHd_11gpui_canvas4text13OutlineRasterEBF_
	movl	$168, %esi
	movl	$8, %edx
	movq	%rbx, %rdi
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB165_88:
	movq	$0, 64(%r13)
	movb	$1, %al
	movl	%eax, 24(%rsp)
	movl	$1, %eax
	movq	%rax, 88(%rsp)
	movq	$0, 296(%rsp)
	movq	$0, 288(%rsp)
	xorl	%ebx, %ebx
	xorl	%r14d, %r14d
	xorl	%ecx, %ecx
	jmp	.LBB165_677
.LBB165_89:
	movl	$4, %ebp
	xorl	%r15d, %r15d
	leaq	840(%rsp), %rax
	movq	56(%rbx), %r14
	testq	%r14, %r14
	js	.LBB165_816
.LBB165_90:
	je	.LBB165_93
	callq	*_RNvCseilXckri75C_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$1, %r13d
	movl	$1, %esi
	movq	%r14, %rdi
	callq	*_RNvCseilXckri75C_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB165_817
	movq	%rax, 88(%rsp)
	leaq	840(%rsp), %rax
	jmp	.LBB165_94
.LBB165_93:
	movl	$1, %ecx
	movq	%rcx, 88(%rsp)
.LBB165_94:
	testq	%r12, %r12
	movq	$0, 16(%rbx)
	movb	$0, 76(%rbx)
	movb	$0, 77(%rbx)
	xorps	%xmm0, %xmm0
	movq	16(%rsp), %rcx
	movups	%xmm0, 12(%rcx)
	movups	%xmm0, (%rcx)
	movb	$1, 78(%rbx)
	movq	(%rbx), %rsi
	movq	%r12, %r13
	cmoveq	%rax, %r13
	testq	%rsi, %rsi
	je	.LBB165_96
	movq	8(%r13), %rdi
	shlq	$3, %rsi
	movl	$4, %edx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	leaq	840(%rsp), %rax
.LBB165_96:
	testq	%r12, %r12
	movq	%r15, (%rbx)
	movq	%rbp, 8(%r13)
	movq	$0, 16(%rbx)
	movq	24(%rbx), %rsi
	movq	%r12, %r15
	cmoveq	%rax, %r15
	testq	%rsi, %rsi
	je	.LBB165_98
	movq	32(%r15), %rdi
	movl	$1, %edx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB165_98:
	movq	%r14, 24(%rbx)
	movq	88(%rsp), %rax
	movq	%rax, 32(%r15)
	movq	$0, 40(%rbx)
	movb	$0, 78(%rbx)
	movq	376(%rsp), %rax
	movq	24(%rax), %rsi
	movq	32(%rax), %rdx
.Ltmp1012:
	leaq	1040(%rsp), %rdi
	movq	232(%rsp), %rcx
	movss	140(%rsp), %xmm0
	movq	%rbx, %r8
	callq	_RNvNtCs9S44gUqPSHd_11gpui_canvas4text14decode_outline
.Ltmp1013:
	movq	72(%rsp), %r13
	cmpl	$2, 1040(%rsp)
	movd	24(%rsp), %xmm7
	movd	48(%rsp), %xmm6
	je	.LBB165_865
.LBB165_100:
	movaps	416(%rsp), %xmm2
	subss	%xmm2, %xmm7
	cvttss2si	%xmm7, %r14
	xorps	%xmm0, %xmm0
	ucomiss	%xmm0, %xmm7
	movl	$0, %eax
	cmovbl	%eax, %r14d
	movss	.LCPI165_4(%rip), %xmm1
	ucomiss	%xmm1, %xmm7
	movl	$-1, %ecx
	cmoval	%ecx, %r14d
	shufps	$85, %xmm2, %xmm2
	movaps	%xmm2, 1008(%rsp)
	subss	%xmm2, %xmm6
	cvttss2si	%xmm6, %rdx
	ucomiss	%xmm0, %xmm6
	cmovbl	%eax, %edx
	ucomiss	%xmm1, %xmm6
	cmoval	%ecx, %edx
	movq	%r14, 296(%rsp)
	movq	%rdx, 288(%rsp)
	imulq	%rdx, %r14
	cmpq	$1048576, %r14
	ja	.LBB165_823
	testq	%r14, %r14
	movq	%r14, 16(%rsp)
	je	.LBB165_104
	callq	*_RNvCseilXckri75C_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$1, %r13d
	movl	$1, %esi
	movq	%r14, %rdi
	callq	*_RNvCseilXckri75C_7___rustc19___rust_alloc_zeroed@GOTPCREL(%rip)
	movq	%rax, 88(%rsp)
	testq	%rax, %rax
	je	.LBB165_899
	movq	72(%rsp), %r13
	jmp	.LBB165_105
.LBB165_104:
	movl	$1, %eax
	movq	%rax, 88(%rsp)
.LBB165_105:
	leaq	80(%r12), %rax
	testq	%r12, %r12
	leaq	840(%rsp), %rcx
	cmoveq	%rcx, %r12
	movq	16(%rbx), %rcx
	movq	8(%r12), %rdx
	movq	32(%r12), %rsi
	movq	40(%rbx), %rdi
	leaq	920(%rsp), %r8
	cmoveq	%r8, %rax
	movq	%rdx, 592(%rsp)
	movq	%rcx, 600(%rsp)
	movq	%rsi, 608(%rsp)
	movq	%rdi, 616(%rsp)
	movb	$0, 624(%rsp)
	movb	$2, 655(%rsp)
	movq	$0, 656(%rsp)
	leaq	624(%rsp), %rcx
	xorps	%xmm0, %xmm0
	movups	%xmm0, 84(%rcx)
	movups	%xmm0, 72(%rcx)
	movq	%rax, 664(%rsp)
	movl	$0, 672(%rsp)
	movb	$1, 748(%rsp)
	movq	296(%rsp), %rax
	movl	%eax, 712(%rsp)
	movq	288(%rsp), %rax
	movl	%eax, 716(%rsp)
	movw	$257, 749(%rsp)
	movdqa	416(%rsp), %xmm0
	pxor	.LCPI165_5(%rip), %xmm0
	movq	%xmm0, 688(%rsp)
.Ltmp1015:
	leaq	1040(%rsp), %rdi
	leaq	592(%rsp), %rsi
	callq	_RNvMs0_NtCs89dqw0uHV7N_4zeno4maskINtB5_4MaskTRSNtNtB7_8geometry6VectorRSNtNtB7_7command4VerbEE9placementCs9S44gUqPSHd_11gpui_canvas
.Ltmp1016:
	movl	1056(%rsp), %edx
	movl	672(%rsp), %eax
	leaq	(,%rdx,4), %rcx
	pxor	%xmm0, %xmm0
	movd	%xmm0, 120(%rsp)
	testl	%eax, %eax
	movq	%rdx, 80(%rsp)
	cmoveq	%rdx, %rcx
	movq	%rcx, 240(%rsp)
	je	.LBB165_109
	cmpl	$1, %eax
	jne	.LBB165_110
	movb	$1, %bl
	movss	.LCPI165_7(%rip), %xmm0
	movaps	%xmm0, 48(%rsp)
	movd	.LCPI165_6(%rip), %xmm0
	jmp	.LBB165_111
.LBB165_109:
	xorl	%ebx, %ebx
	movdqa	%xmm0, 48(%rsp)
	jmp	.LBB165_111
.LBB165_110:
	movss	676(%rsp), %xmm0
	movaps	%xmm0, 48(%rsp)
	movss	680(%rsp), %xmm0
	movss	%xmm0, 120(%rsp)
	movb	$1, %bl
	movd	684(%rsp), %xmm0
.LBB165_111:
	movd	%xmm0, 116(%rsp)
	movsd	1040(%rsp), %xmm3
	movl	1060(%rsp), %eax
	movq	%rax, 40(%rsp)
	movzbl	748(%rsp), %eax
	movb	%al, 15(%rsp)
	movzbl	624(%rsp), %eax
	cmpb	$2, 655(%rsp)
	sete	%dl
	movsd	696(%rsp), %xmm0
	leaq	624(%rsp), %rcx
	movups	(%rcx), %xmm1
	movups	16(%rcx), %xmm2
	movaps	%xmm1, 560(%rsp)
	movaps	%xmm2, 576(%rsp)
	movups	96(%rcx), %xmm1
	movups	108(%rcx), %xmm2
	movaps	%xmm1, 528(%rsp)
	movups	%xmm2, 540(%rsp)
	cmpq	$0, 656(%rsp)
	jne	.LBB165_876
	andb	%al, %dl
	movb	%dl, 24(%rsp)
	addps	%xmm0, %xmm3
	movaps	%xmm3, 256(%rsp)
	movq	$-1, 656(%rsp)
	movq	664(%rsp), %r12
	testq	%r12, %r12
	je	.LBB165_127
	leaq	24(%r12), %rdi
	movq	%rdi, 1064(%rsp)
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 1040(%rsp)
	movq	$0, 1056(%rsp)
	leaq	1072(%rsp), %rax
	movups	%xmm0, 30(%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, (%rax)
	testb	%bl, %bl
	je	.LBB165_140
.Ltmp1029:
	xorl	%esi, %esi
	xorl	%edx, %edx
	movq	80(%rsp), %rcx
	movq	40(%rsp), %r8
	callq	*_RNvXs0_NtCs89dqw0uHV7N_4zeno6rasterNtB5_11HeapStorageNtB5_13RasterStorage5reset@GOTPCREL(%rip)
.Ltmp1030:
	xorps	%xmm0, %xmm0
	movaps	48(%rsp), %xmm1
	movss	%xmm1, %xmm0
	addps	256(%rsp), %xmm0
	movaps	%xmm0, 336(%rsp)
	movlps	%xmm0, 1040(%rsp)
	xorps	%xmm0, %xmm0
	movups	%xmm0, 1048(%rsp)
	movb	$1, 1116(%rsp)
	movl	$0, 1072(%rsp)
	movl	$0, 1080(%rsp)
	movq	80(%rsp), %rax
	movl	%eax, 1076(%rsp)
	movq	40(%rsp), %rax
	movl	%eax, 1084(%rsp)
	movl	%eax, 1088(%rsp)
	leaq	1072(%rsp), %rax
	movups	%xmm0, 20(%rax)
	movb	$1, 1117(%rsp)
.Ltmp1031:
	movq	%r12, %rdi
	leaq	592(%rsp), %rsi
	leaq	560(%rsp), %rdx
	leaq	528(%rsp), %rcx
	leaq	1040(%rsp), %r8
	callq	_RINvMs_NtCs89dqw0uHV7N_4zeno7scratchNtB5_5Inner5applyRTRSNtNtB7_8geometry6VectorRSNtNtB7_7command4VerbEINtNtB7_6raster10RasterizerNtB1G_11HeapStorageEECs9S44gUqPSHd_11gpui_canvas
.Ltmp1032:
	cmpb	$0, 1116(%rsp)
	jne	.LBB165_118
	movl	1048(%rsp), %esi
	movl	1052(%rsp), %edx
.Ltmp1033:
	leaq	1040(%rsp), %rdi
	callq	_RNvMNtCs89dqw0uHV7N_4zeno6rasterINtB2_10RasterizerNtB2_11HeapStorageE7line_toCs9S44gUqPSHd_11gpui_canvas
.Ltmp1034:
.LBB165_118:
	cmpb	$0, 1117(%rsp)
	jne	.LBB165_204
	movq	1064(%rsp), %rbx
	movl	1096(%rsp), %eax
	subl	52(%rbx), %eax
	movslq	%eax, %r13
	movq	40(%rbx), %r11
	cmpq	%r13, %r11
	jbe	.LBB165_901
	movl	1092(%rsp), %ebp
	movsd	1108(%rsp), %xmm0
	movaps	%xmm0, 48(%rsp)
	movq	16(%rbx), %r11
	movq	32(%rbx), %rax
	movl	(%rax,%r13,4), %edi
	cmpl	$-1, %edi
	je	.LBB165_165
	movl	$-1, %esi
.LBB165_122:
	movslq	%edi, %rcx
	cmpq	%rcx, %r11
	jbe	.LBB165_897
	movl	%edi, %r14d
	movq	8(%rbx), %rdx
	movq	%rcx, %rdi
	shlq	$4, %rdi
	movl	(%rdx,%rdi), %r8d
	cmpl	%ebp, %r8d
	jg	.LBB165_189
	addq	%rdx, %rdi
	cmpl	%r8d, %ebp
	je	.LBB165_203
	movl	12(%rdi), %edi
	movl	%r14d, %esi
	cmpl	$-1, %edi
	jne	.LBB165_122
	movl	$-1, %r14d
	jmp	.LBB165_191
.LBB165_127:
	movq	$0, 1040(%rsp)
	movl	$18464, %edx
	leaq	1088(%rsp), %rdi
	xorl	%esi, %esi
	callq	*memset@GOTPCREL(%rip)
	movq	$4, 1048(%rsp)
	xorps	%xmm0, %xmm0
	leaq	1072(%rsp), %rax
	movups	%xmm0, -16(%rax)
	movq	$4, 1072(%rsp)
	movq	$0, 1080(%rsp)
	leaq	1040(%rsp), %rdi
	movq	%rdi, 168(%rsp)
	movaps	%xmm0, 144(%rsp)
	movq	$0, 160(%rsp)
	leaq	176(%rsp), %rax
	movups	%xmm0, 30(%rax)
	movups	%xmm0, 16(%rax)
	movups	%xmm0, (%rax)
	testb	%bl, %bl
	je	.LBB165_153
.Ltmp1071:
	xorl	%esi, %esi
	xorl	%edx, %edx
	movq	80(%rsp), %rcx
	movq	40(%rsp), %r8
	callq	*_RNvXs2_NtCs89dqw0uHV7N_4zeno6rasterNtB5_15AdaptiveStorageNtB5_13RasterStorage5reset@GOTPCREL(%rip)
.Ltmp1072:
	xorps	%xmm0, %xmm0
	movaps	48(%rsp), %xmm1
	movss	%xmm1, %xmm0
	addps	256(%rsp), %xmm0
	movaps	%xmm0, 336(%rsp)
	movlps	%xmm0, 144(%rsp)
	xorps	%xmm0, %xmm0
	movups	%xmm0, 152(%rsp)
	movb	$1, 220(%rsp)
	movl	$0, 176(%rsp)
	movl	$0, 184(%rsp)
	movq	80(%rsp), %rax
	movl	%eax, 180(%rsp)
	movq	40(%rsp), %rax
	movl	%eax, 188(%rsp)
	movl	%eax, 192(%rsp)
	leaq	176(%rsp), %rax
	movups	%xmm0, 20(%rax)
	movb	$1, 221(%rsp)
.Ltmp1073:
	leaq	592(%rsp), %rdi
	leaq	560(%rsp), %rsi
	leaq	528(%rsp), %rdx
	leaq	144(%rsp), %rcx
	callq	_RINvNtCs89dqw0uHV7N_4zeno9path_data5applyRTRSNtNtB4_8geometry6VectorRSNtNtB4_7command4VerbENtNtB4_5style5StyleINtNtB4_6raster10RasterizerNtB1N_15AdaptiveStorageEECs9S44gUqPSHd_11gpui_canvas
.Ltmp1074:
	cmpb	$0, 220(%rsp)
	jne	.LBB165_132
	movl	152(%rsp), %esi
	movl	156(%rsp), %edx
.Ltmp1075:
	leaq	144(%rsp), %rdi
	callq	_RNvMNtCs89dqw0uHV7N_4zeno6rasterINtB2_10RasterizerNtB2_15AdaptiveStorageE7line_toCs9S44gUqPSHd_11gpui_canvas
.Ltmp1076:
.LBB165_132:
	cmpb	$0, 221(%rsp)
	jne	.LBB165_429
	movq	168(%rsp), %rbx
	movq	64(%rbx), %rsi
	movl	$512, %r11d
	cmpq	$513, %rsi
	jb	.LBB165_135
	movq	40(%rbx), %r11
.LBB165_135:
	movq	16(%rbx), %rax
	leaq	80(%rbx), %r12
	movl	$1024, %edx
	movq	%r12, %rcx
	testq	%rax, %rax
	je	.LBB165_137
	movq	8(%rbx), %rcx
	movq	%rax, %rdx
.LBB165_137:
	movl	200(%rsp), %edi
	subl	52(%rbx), %edi
	movslq	%edi, %r13
	cmpq	%r13, %r11
	jbe	.LBB165_907
	cmpq	$513, %rsi
	jb	.LBB165_169
	movq	32(%rbx), %rdi
	jmp	.LBB165_170
.LBB165_140:
.Ltmp1021:
	xorl	%esi, %esi
	xorl	%edx, %edx
	movq	80(%rsp), %rcx
	movq	40(%rsp), %r8
	callq	*_RNvXs0_NtCs89dqw0uHV7N_4zeno6rasterNtB5_11HeapStorageNtB5_13RasterStorage5reset@GOTPCREL(%rip)
.Ltmp1022:
	movdqa	256(%rsp), %xmm0
	movq	%xmm0, 1040(%rsp)
	pxor	%xmm0, %xmm0
	movdqu	%xmm0, 1048(%rsp)
	movb	$1, 1116(%rsp)
	movl	$0, 1072(%rsp)
	movl	$0, 1080(%rsp)
	movq	80(%rsp), %rax
	movl	%eax, 1076(%rsp)
	movq	40(%rsp), %rax
	movl	%eax, 1084(%rsp)
	movl	%eax, 1088(%rsp)
	leaq	1072(%rsp), %rax
	movdqu	%xmm0, 20(%rax)
	movb	$1, 1117(%rsp)
.Ltmp1023:
	movq	%r12, %rdi
	leaq	592(%rsp), %rsi
	leaq	560(%rsp), %rdx
	leaq	528(%rsp), %rcx
	leaq	1040(%rsp), %r8
	callq	_RINvMs_NtCs89dqw0uHV7N_4zeno7scratchNtB5_5Inner5applyRTRSNtNtB7_8geometry6VectorRSNtNtB7_7command4VerbEINtNtB7_6raster10RasterizerNtB1G_11HeapStorageEECs9S44gUqPSHd_11gpui_canvas
.Ltmp1024:
	cmpb	$0, 1116(%rsp)
	jne	.LBB165_144
	movl	1048(%rsp), %esi
	movl	1052(%rsp), %edx
.Ltmp1025:
	leaq	1040(%rsp), %rdi
	callq	_RNvMNtCs89dqw0uHV7N_4zeno6rasterINtB2_10RasterizerNtB2_11HeapStorageE7line_toCs9S44gUqPSHd_11gpui_canvas
.Ltmp1026:
.LBB165_144:
	cmpb	$0, 1117(%rsp)
	jne	.LBB165_258
	movq	1064(%rsp), %rbx
	movl	1096(%rsp), %eax
	subl	52(%rbx), %eax
	movslq	%eax, %r13
	movq	40(%rbx), %r11
	cmpq	%r13, %r11
	jbe	.LBB165_901
	movl	1092(%rsp), %ebp
	movsd	1108(%rsp), %xmm0
	movaps	%xmm0, 48(%rsp)
	movq	16(%rbx), %r11
	movq	32(%rbx), %rax
	movl	(%rax,%r13,4), %edi
	cmpl	$-1, %edi
	je	.LBB165_167
	movl	$-1, %esi
.LBB165_148:
	movslq	%edi, %rcx
	cmpq	%rcx, %r11
	jbe	.LBB165_897
	movl	%edi, %r14d
	movq	8(%rbx), %rdx
	movq	%rcx, %rdi
	shlq	$4, %rdi
	movl	(%rdx,%rdi), %r8d
	cmpl	%ebp, %r8d
	jg	.LBB165_196
	addq	%rdx, %rdi
	cmpl	%r8d, %ebp
	je	.LBB165_257
	movl	12(%rdi), %edi
	movl	%r14d, %esi
	cmpl	$-1, %edi
	jne	.LBB165_148
	movl	$-1, %r14d
	jmp	.LBB165_198
.LBB165_153:
.Ltmp1059:
	xorl	%esi, %esi
	xorl	%edx, %edx
	movq	80(%rsp), %rcx
	movq	40(%rsp), %r8
	callq	*_RNvXs2_NtCs89dqw0uHV7N_4zeno6rasterNtB5_15AdaptiveStorageNtB5_13RasterStorage5reset@GOTPCREL(%rip)
.Ltmp1060:
	movdqa	256(%rsp), %xmm0
	movq	%xmm0, 144(%rsp)
	pxor	%xmm0, %xmm0
	movdqu	%xmm0, 152(%rsp)
	movb	$1, 220(%rsp)
	movl	$0, 176(%rsp)
	movl	$0, 184(%rsp)
	movq	80(%rsp), %rax
	movl	%eax, 180(%rsp)
	movq	40(%rsp), %rax
	movl	%eax, 188(%rsp)
	movl	%eax, 192(%rsp)
	leaq	176(%rsp), %rax
	movdqu	%xmm0, 20(%rax)
	movb	$1, 221(%rsp)
.Ltmp1061:
	leaq	592(%rsp), %rdi
	leaq	560(%rsp), %rsi
	leaq	528(%rsp), %rdx
	leaq	144(%rsp), %rcx
	callq	_RINvNtCs89dqw0uHV7N_4zeno9path_data5applyRTRSNtNtB4_8geometry6VectorRSNtNtB4_7command4VerbENtNtB4_5style5StyleINtNtB4_6raster10RasterizerNtB1N_15AdaptiveStorageEECs9S44gUqPSHd_11gpui_canvas
.Ltmp1062:
	cmpb	$0, 220(%rsp)
	jne	.LBB165_157
	movl	152(%rsp), %esi
	movl	156(%rsp), %edx
.Ltmp1063:
	leaq	144(%rsp), %rdi
	callq	_RNvMNtCs89dqw0uHV7N_4zeno6rasterINtB2_10RasterizerNtB2_15AdaptiveStorageE7line_toCs9S44gUqPSHd_11gpui_canvas
.Ltmp1064:
.LBB165_157:
	cmpb	$0, 221(%rsp)
	jne	.LBB165_494
	movq	168(%rsp), %rbx
	movq	64(%rbx), %rsi
	movl	$512, %r11d
	cmpq	$513, %rsi
	jb	.LBB165_160
	movq	40(%rbx), %r11
.LBB165_160:
	movq	16(%rbx), %rax
	leaq	80(%rbx), %r12
	movl	$1024, %edx
	movq	%r12, %rcx
	testq	%rax, %rax
	je	.LBB165_162
	movq	8(%rbx), %rcx
	movq	%rax, %rdx
.LBB165_162:
	movl	200(%rsp), %edi
	subl	52(%rbx), %edi
	movslq	%edi, %r13
	cmpq	%r13, %r11
	jbe	.LBB165_907
	cmpq	$513, %rsi
	jb	.LBB165_177
	movq	32(%rbx), %rdi
	jmp	.LBB165_178
.LBB165_165:
	movl	$-1, %r14d
.LBB165_166:
	movl	%r11d, (%rax,%r13,4)
	jmp	.LBB165_193
.LBB165_167:
	movl	$-1, %r14d
.LBB165_168:
	movl	%r11d, (%rax,%r13,4)
	movq	72(%rsp), %r13
	jmp	.LBB165_200
.LBB165_169:
	leaq	16464(%rbx), %rdi
.LBB165_170:
	movl	196(%rsp), %ebp
	movsd	212(%rsp), %xmm0
	movaps	%xmm0, 48(%rsp)
	movl	(%rdi,%r13,4), %esi
	cmpl	$-1, %esi
	je	.LBB165_185
	movl	$-1, %r9d
.LBB165_172:
	movslq	%esi, %r8
	cmpq	%r8, %rdx
	jbe	.LBB165_898
	movl	%esi, %r14d
	movq	%r8, %rsi
	shlq	$4, %rsi
	movl	(%rcx,%rsi), %r10d
	cmpl	%ebp, %r10d
	jg	.LBB165_400
	addq	%rcx, %rsi
	cmpl	%r10d, %ebp
	je	.LBB165_428
	movl	12(%rsi), %esi
	movl	%r14d, %r9d
	cmpl	$-1, %esi
	jne	.LBB165_172
	movq	72(%rbx), %rsi
	leaq	1(%rsi), %rdi
	movq	%rdi, 72(%rbx)
	movl	$-1, %r14d
	jmp	.LBB165_402
.LBB165_177:
	leaq	16464(%rbx), %rdi
.LBB165_178:
	movl	196(%rsp), %ebp
	movsd	212(%rsp), %xmm0
	movaps	%xmm0, 48(%rsp)
	movl	(%rdi,%r13,4), %esi
	cmpl	$-1, %esi
	je	.LBB165_187
	movl	$-1, %r9d
.LBB165_180:
	movslq	%esi, %r8
	cmpq	%r8, %rdx
	jbe	.LBB165_898
	movl	%esi, %r14d
	movq	%r8, %rsi
	shlq	$4, %rsi
	movl	(%rcx,%rsi), %r10d
	cmpl	%ebp, %r10d
	jg	.LBB165_414
	addq	%rcx, %rsi
	cmpl	%r10d, %ebp
	je	.LBB165_493
	movl	12(%rsi), %esi
	movl	%r14d, %r9d
	cmpl	$-1, %esi
	jne	.LBB165_180
	movq	72(%rbx), %rsi
	leaq	1(%rsi), %rdi
	movq	%rdi, 72(%rbx)
	movl	$-1, %r14d
	jmp	.LBB165_416
.LBB165_185:
	movq	72(%rbx), %rsi
	leaq	1(%rsi), %r8
	movq	%r8, 72(%rbx)
	movl	$-1, %r14d
.LBB165_186:
	movl	%esi, (%rdi,%r13,4)
	jmp	.LBB165_404
.LBB165_187:
	movq	72(%rbx), %rsi
	leaq	1(%rsi), %r8
	movq	%r8, 72(%rbx)
	movl	$-1, %r14d
.LBB165_188:
	movl	%esi, (%rdi,%r13,4)
	movq	72(%rsp), %r13
	jmp	.LBB165_418
.LBB165_189:
	cmpl	$-1, %esi
	je	.LBB165_166
	movslq	%esi, %rcx
.LBB165_191:
	cmpq	%rcx, %r11
	jbe	.LBB165_900
	shlq	$4, %rcx
	movl	%r11d, 12(%rdx,%rcx)
.LBB165_193:
	movq	16(%rbx), %r15
	cmpq	(%rbx), %r15
	jne	.LBB165_195
.Ltmp1035:
	movq	%rbx, %rdi
	callq	*_RNvMs7_NtCse3dB2pZFcs1_5alloc7raw_vecINtB5_6RawVecNtNtCs89dqw0uHV7N_4zeno6raster4CellE8grow_oneCs9S44gUqPSHd_11gpui_canvas@GOTPCREL(%rip)
.Ltmp1036:
.LBB165_195:
	movq	8(%rbx), %rax
	movq	%r15, %rcx
	shlq	$4, %rcx
	movl	%ebp, (%rax,%rcx)
	movdqa	48(%rsp), %xmm0
	movd	%xmm0, 4(%rax,%rcx)
	pshufd	$85, %xmm0, %xmm0
	movd	%xmm0, 8(%rax,%rcx)
	movl	%r14d, 12(%rax,%rcx)
	incq	%r15
	movq	%r15, 16(%rbx)
	jmp	.LBB165_204
.LBB165_196:
	cmpl	$-1, %esi
	je	.LBB165_168
	movslq	%esi, %rcx
.LBB165_198:
	cmpq	%rcx, %r11
	movq	72(%rsp), %r13
	jbe	.LBB165_900
	shlq	$4, %rcx
	movl	%r11d, 12(%rdx,%rcx)
.LBB165_200:
	movq	16(%rbx), %r15
	cmpq	(%rbx), %r15
	jne	.LBB165_202
.Ltmp1027:
	movq	%rbx, %rdi
	callq	*_RNvMs7_NtCse3dB2pZFcs1_5alloc7raw_vecINtB5_6RawVecNtNtCs89dqw0uHV7N_4zeno6raster4CellE8grow_oneCs9S44gUqPSHd_11gpui_canvas@GOTPCREL(%rip)
.Ltmp1028:
.LBB165_202:
	movq	8(%rbx), %rax
	movq	%r15, %rcx
	shlq	$4, %rcx
	movl	%ebp, (%rax,%rcx)
	movdqa	48(%rsp), %xmm0
	movd	%xmm0, 4(%rax,%rcx)
	pshufd	$85, %xmm0, %xmm0
	movd	%xmm0, 8(%rax,%rcx)
	movl	%r14d, 12(%rax,%rcx)
	incq	%r15
	movq	%r15, 16(%rbx)
	jmp	.LBB165_258
.LBB165_203:
	movq	4(%rdi), %xmm0
	paddd	48(%rsp), %xmm0
	movq	%xmm0, 4(%rdi)
.LBB165_204:
	movq	%r12, 280(%rsp)
	movq	1064(%rsp), %rax
	movq	%rax, 440(%rsp)
	movq	40(%rax), %rdi
	testq	%rdi, %rdi
	je	.LBB165_242
	movq	440(%rsp), %rdx
	movq	32(%rdx), %rax
	movq	8(%rdx), %rcx
	movq	16(%rdx), %r9
	movl	1072(%rsp), %edx
	movl	1080(%rsp), %esi
	movl	%esi, 96(%rsp)
	movl	1076(%rsp), %esi
	movl	%esi, 36(%rsp)
	leaq	(%rax,%rdi,4), %rsi
	movq	%rsi, 48(%rsp)
	xorl	%r10d, %r10d
	jmp	.LBB165_207
	.p2align	4
.LBB165_206:
	addq	$4, %rax
	incl	%r10d
	cmpq	48(%rsp), %rax
	je	.LBB165_242
.LBB165_207:
	movl	(%rax), %edi
	cmpl	$-1, %edi
	je	.LBB165_206
	movl	%r10d, %r8d
	subl	96(%rsp), %r8d
	movslq	%r8d, %r8
	movq	%r8, %rbx
	notq	%rbx
	addq	40(%rsp), %rbx
	cmpb	$0, 15(%rsp)
	cmoveq	%r8, %rbx
	imulq	240(%rsp), %rbx
	movq	16(%rsp), %r11
	subq	%rbx, %r11
	movq	88(%rsp), %rsi
	leaq	(%rsi,%rbx), %r14
	xorl	%r12d, %r12d
	movl	%edx, %r15d
	jmp	.LBB165_211
	.p2align	4
.LBB165_209:
	movl	%ebp, %edi
.LBB165_210:
	movl	%edi, %r15d
	incl	%r15d
	movl	12(%r13), %edi
	cmpl	$-1, %edi
	je	.LBB165_233
.LBB165_211:
	movslq	%edi, %r13
	cmpq	%r13, %r9
	jbe	.LBB165_881
	movl	%r12d, %esi
	shlq	$4, %r13
	movl	(%rcx,%r13), %edi
	movl	%edi, %ebp
	testl	%r12d, %r12d
	je	.LBB165_224
	movl	%edi, %r12d
	movl	%edi, %ebp
	subl	%r15d, %r12d
	jle	.LBB165_224
	movl	%esi, %ebp
	sarl	$9, %ebp
	cmpb	$0, 24(%rsp)
	je	.LBB165_216
	andl	$511, %ebp
	movl	%ebp, %r8d
	xorl	$511, %r8d
	cmpl	$256, %ebp
	cmovael	%r8d, %ebp
	jmp	.LBB165_217
	.p2align	4
.LBB165_216:
	movl	%esi, %r8d
	sarl	$31, %r8d
	xorl	%r8d, %ebp
	cmpl	$255, %ebp
	movl	$255, %r8d
	cmovgel	%r8d, %ebp
.LBB165_217:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_829
	cmpl	%r15d, %edi
	jne	.LBB165_220
	movl	%r15d, %ebp
	jmp	.LBB165_224
	.p2align	4
.LBB165_220:
	movslq	%r12d, %r12
	movslq	%r15d, %r15
	shlq	$2, %r15
	.p2align	4
.LBB165_221:
	cmpq	%r11, %r15
	jae	.LBB165_871
	movb	%bpl, (%r14,%r15)
	addq	$4, %r15
	decq	%r12
	jne	.LBB165_221
	movl	%edi, %ebp
.LBB165_224:
	addq	%rcx, %r13
	movl	4(%r13), %r12d
	shll	$9, %r12d
	addl	%esi, %r12d
	movl	%r12d, %r15d
	subl	8(%r13), %r15d
	je	.LBB165_209
	cmpl	%edx, %ebp
	jl	.LBB165_209
	movl	%r15d, %r8d
	sarl	$9, %r8d
	cmpb	$0, 24(%rsp)
	je	.LBB165_229
	andl	$511, %r8d
	movl	%r8d, %esi
	xorl	$511, %esi
	cmpl	$256, %r8d
	cmovael	%esi, %r8d
	jmp	.LBB165_230
	.p2align	4
.LBB165_229:
	sarl	$31, %r15d
	xorl	%r15d, %r8d
	cmpl	$255, %r8d
	movl	$255, %esi
	cmovgel	%esi, %r8d
.LBB165_230:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_829
	movslq	%ebp, %r15
	shlq	$2, %r15
	cmpq	%r11, %r15
	jae	.LBB165_871
	movb	%r8b, (%r14,%r15)
	jmp	.LBB165_210
	.p2align	4
.LBB165_233:
	testl	%r12d, %r12d
	je	.LBB165_206
	movl	%r12d, %edi
	sarl	$9, %edi
	cmpb	$0, 24(%rsp)
	je	.LBB165_236
	andl	$511, %edi
	movl	%edi, %esi
	xorl	$511, %esi
	cmpl	$256, %edi
	cmovael	%esi, %edi
	jmp	.LBB165_237
.LBB165_236:
	sarl	$31, %r12d
	xorl	%r12d, %edi
	cmpl	$255, %edi
	movl	$255, %esi
	cmovgel	%esi, %edi
.LBB165_237:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_829
	cmpl	%r15d, 36(%rsp)
	je	.LBB165_206
	movl	36(%rsp), %esi
	subl	%r15d, %esi
	movslq	%esi, %r8
	movslq	%r15d, %r13
	shlq	$2, %r13
	.p2align	4
.LBB165_240:
	cmpq	%r11, %r13
	jae	.LBB165_888
	movb	%dil, (%r14,%r13)
	addq	$4, %r13
	decq	%r8
	jne	.LBB165_240
	jmp	.LBB165_206
.LBB165_242:
.Ltmp1037:
	movq	440(%rsp), %rdi
	xorl	%esi, %esi
	xorl	%edx, %edx
	movq	80(%rsp), %rcx
	movq	40(%rsp), %r8
	callq	*_RNvXs0_NtCs89dqw0uHV7N_4zeno6rasterNtB5_11HeapStorageNtB5_13RasterStorage5reset@GOTPCREL(%rip)
.Ltmp1038:
	movq	280(%rsp), %rdi
	movss	120(%rsp), %xmm0
	addss	256(%rsp), %xmm0
	movss	%xmm0, 1040(%rsp)
	movaps	336(%rsp), %xmm0
	shufps	$85, %xmm0, %xmm0
	movaps	%xmm0, 336(%rsp)
	movss	%xmm0, 1044(%rsp)
	xorps	%xmm0, %xmm0
	movups	%xmm0, 1048(%rsp)
	movb	$1, 1116(%rsp)
	movl	$0, 1072(%rsp)
	movl	$0, 1080(%rsp)
	movq	80(%rsp), %rax
	movl	%eax, 1076(%rsp)
	movq	40(%rsp), %rax
	movl	%eax, 1084(%rsp)
	movl	%eax, 1088(%rsp)
	leaq	1072(%rsp), %rax
	movups	%xmm0, 20(%rax)
	movb	$1, 1117(%rsp)
.Ltmp1039:
	leaq	592(%rsp), %rsi
	leaq	560(%rsp), %rdx
	leaq	528(%rsp), %rcx
	leaq	1040(%rsp), %r8
	callq	_RINvMs_NtCs89dqw0uHV7N_4zeno7scratchNtB5_5Inner5applyRTRSNtNtB7_8geometry6VectorRSNtNtB7_7command4VerbEINtNtB7_6raster10RasterizerNtB1G_11HeapStorageEECs9S44gUqPSHd_11gpui_canvas
.Ltmp1040:
	cmpb	$0, 1116(%rsp)
	jne	.LBB165_246
	movl	1048(%rsp), %esi
	movl	1052(%rsp), %edx
.Ltmp1041:
	leaq	1040(%rsp), %rdi
	callq	_RNvMNtCs89dqw0uHV7N_4zeno6rasterINtB2_10RasterizerNtB2_11HeapStorageE7line_toCs9S44gUqPSHd_11gpui_canvas
.Ltmp1042:
.LBB165_246:
	cmpb	$0, 1117(%rsp)
	jne	.LBB165_301
	movq	1064(%rsp), %rbx
	movl	1096(%rsp), %eax
	subl	52(%rbx), %eax
	movslq	%eax, %r13
	movq	40(%rbx), %r11
	cmpq	%r13, %r11
	jbe	.LBB165_901
	movl	1092(%rsp), %ebp
	movsd	1108(%rsp), %xmm0
	movaps	%xmm0, 48(%rsp)
	movq	16(%rbx), %r11
	movq	32(%rbx), %rax
	movl	(%rax,%r13,4), %edi
	cmpl	$-1, %edi
	je	.LBB165_255
	movl	$-1, %esi
.LBB165_250:
	movslq	%edi, %rcx
	cmpq	%rcx, %r11
	jbe	.LBB165_897
	movl	%edi, %r14d
	movq	8(%rbx), %rdx
	movq	%rcx, %rdi
	shlq	$4, %rdi
	movl	(%rdx,%rdi), %r8d
	cmpl	%ebp, %r8d
	jg	.LBB165_293
	addq	%rdx, %rdi
	cmpl	%r8d, %ebp
	je	.LBB165_300
	movl	12(%rdi), %edi
	movl	%r14d, %esi
	cmpl	$-1, %edi
	jne	.LBB165_250
	movl	$-1, %r14d
	jmp	.LBB165_295
.LBB165_255:
	movl	$-1, %r14d
.LBB165_256:
	movl	%r11d, (%rax,%r13,4)
	jmp	.LBB165_297
.LBB165_257:
	movq	4(%rdi), %xmm0
	paddd	48(%rsp), %xmm0
	movq	%xmm0, 4(%rdi)
	movq	72(%rsp), %r13
.LBB165_258:
	movq	1064(%rsp), %rcx
	movq	40(%rcx), %rax
	testq	%rax, %rax
	je	.LBB165_673
	movq	32(%rcx), %r8
	movq	8(%rcx), %rbp
	movq	16(%rcx), %rcx
	movq	%rcx, 48(%rsp)
	movl	1072(%rsp), %r9d
	movl	1080(%rsp), %ecx
	movl	%ecx, 116(%rsp)
	movl	1076(%rsp), %ecx
	movl	%ecx, 120(%rsp)
	leaq	(%r8,%rax,4), %rax
	movq	%rax, 256(%rsp)
	xorl	%r10d, %r10d
	movl	%r9d, 80(%rsp)
	jmp	.LBB165_261
	.p2align	4
.LBB165_260:
	addq	$4, %r8
	incl	%r10d
	cmpq	256(%rsp), %r8
	je	.LBB165_673
.LBB165_261:
	movl	(%r8), %ecx
	cmpl	$-1, %ecx
	je	.LBB165_260
	movl	%r10d, %eax
	subl	116(%rsp), %eax
	cltq
	movq	%rax, %rbx
	notq	%rbx
	addq	40(%rsp), %rbx
	cmpb	$0, 15(%rsp)
	cmoveq	%rax, %rbx
	imulq	240(%rsp), %rbx
	movq	16(%rsp), %r12
	subq	%rbx, %r12
	jb	.LBB165_867
	movl	%r10d, 36(%rsp)
	movq	%r8, 96(%rsp)
	addq	88(%rsp), %rbx
	xorl	%r14d, %r14d
	movl	%r9d, %eax
	movq	48(%rsp), %r11
	jmp	.LBB165_265
	.p2align	4
.LBB165_264:
	incl	%r15d
	movl	12(%r13), %ecx
	movl	%r15d, %eax
	cmpl	$-1, %ecx
	je	.LBB165_284
.LBB165_265:
	movslq	%ecx, %r13
	cmpq	%r13, %r11
	jbe	.LBB165_883
	shlq	$4, %r13
	movl	(%rbp,%r13), %r15d
	testl	%r14d, %r14d
	je	.LBB165_275
	movl	%r15d, %edx
	subl	%eax, %edx
	jle	.LBB165_275
	movl	%r14d, %ecx
	sarl	$9, %ecx
	cmpb	$0, 24(%rsp)
	je	.LBB165_270
	andl	$511, %ecx
	movl	%ecx, %esi
	xorl	$511, %esi
	cmpl	$256, %ecx
	cmovael	%esi, %ecx
	jmp	.LBB165_271
	.p2align	4
.LBB165_270:
	movl	%r14d, %esi
	sarl	$31, %esi
	xorl	%esi, %ecx
	cmpl	$255, %ecx
	movl	$255, %esi
	cmovgel	%esi, %ecx
.LBB165_271:
	movslq	%edx, %rdx
	movslq	%eax, %rdi
	leaq	(%rdx,%rdi), %rsi
	cmpq	%r12, %rsi
	seta	%r8b
	movq	%rdx, %rsi
	addq	%rdi, %rsi
	jb	.LBB165_282
	testb	%r8b, %r8b
	jne	.LBB165_855
.LBB165_273:
	cmpl	%eax, %r15d
	je	.LBB165_275
	addq	%rbx, %rdi
	movzbl	%cl, %esi
	callq	*memset@GOTPCREL(%rip)
	movl	80(%rsp), %r9d
	movq	48(%rsp), %r11
.LBB165_275:
	addq	%rbp, %r13
	movslq	%r15d, %rax
	movl	4(%r13), %ecx
	shll	$9, %ecx
	addl	%ecx, %r14d
	movl	%r14d, %edx
	subl	8(%r13), %edx
	sete	%cl
	cmpl	%r9d, %eax
	setl	%sil
	orb	%cl, %sil
	jne	.LBB165_264
	movl	%edx, %ecx
	sarl	$9, %ecx
	cmpb	$0, 24(%rsp)
	je	.LBB165_278
	andl	$511, %ecx
	movl	%ecx, %edx
	xorl	$511, %edx
	cmpl	$256, %ecx
	cmovael	%edx, %ecx
	jmp	.LBB165_279
	.p2align	4
.LBB165_278:
	sarl	$31, %edx
	xorl	%edx, %ecx
	cmpl	$255, %ecx
	movl	$255, %edx
	cmovgel	%edx, %ecx
.LBB165_279:
	leaq	1(%rax), %rsi
	cmpq	%r12, %rsi
	seta	%dl
	cmpl	$-1, %r15d
	je	.LBB165_283
	testb	%dl, %dl
	jne	.LBB165_856
.LBB165_281:
	movb	%cl, (%rbx,%rax)
	jmp	.LBB165_264
.LBB165_282:
	movb	$1, %r8b
	testb	%r8b, %r8b
	je	.LBB165_273
	jmp	.LBB165_855
.LBB165_283:
	movb	$1, %dl
	testb	%dl, %dl
	je	.LBB165_281
	jmp	.LBB165_856
	.p2align	4
.LBB165_284:
	testl	%r14d, %r14d
	movq	72(%rsp), %r13
	movq	96(%rsp), %r8
	movl	36(%rsp), %r10d
	je	.LBB165_260
	movl	%r14d, %eax
	sarl	$9, %eax
	cmpb	$0, 24(%rsp)
	je	.LBB165_287
	andl	$511, %eax
	movl	%eax, %ecx
	xorl	$511, %ecx
	cmpl	$256, %eax
	cmovael	%ecx, %eax
	jmp	.LBB165_288
.LBB165_287:
	sarl	$31, %r14d
	xorl	%r14d, %eax
	cmpl	$255, %eax
	movl	$255, %ecx
	cmovgel	%ecx, %eax
.LBB165_288:
	movl	120(%rsp), %ecx
	subl	%r15d, %ecx
	movslq	%ecx, %rdx
	movslq	%r15d, %rcx
	leaq	(%rdx,%rcx), %rsi
	cmpq	%r12, %rsi
	seta	%dil
	movq	%rdx, %rsi
	addq	%rcx, %rsi
	jb	.LBB165_292
	testb	%dil, %dil
	jne	.LBB165_866
.LBB165_290:
	cmpl	%r15d, 120(%rsp)
	je	.LBB165_260
	addq	%rcx, %rbx
	movzbl	%al, %esi
	movq	%rbx, %rdi
	callq	*memset@GOTPCREL(%rip)
	movl	36(%rsp), %r10d
	movl	80(%rsp), %r9d
	movq	96(%rsp), %r8
	jmp	.LBB165_260
.LBB165_292:
	movb	$1, %dil
	testb	%dil, %dil
	je	.LBB165_290
	jmp	.LBB165_866
.LBB165_293:
	cmpl	$-1, %esi
	je	.LBB165_256
	movslq	%esi, %rcx
.LBB165_295:
	cmpq	%rcx, %r11
	jbe	.LBB165_900
	shlq	$4, %rcx
	movl	%r11d, 12(%rdx,%rcx)
.LBB165_297:
	movq	16(%rbx), %r15
	cmpq	(%rbx), %r15
	jne	.LBB165_299
.Ltmp1043:
	movq	%rbx, %rdi
	callq	*_RNvMs7_NtCse3dB2pZFcs1_5alloc7raw_vecINtB5_6RawVecNtNtCs89dqw0uHV7N_4zeno6raster4CellE8grow_oneCs9S44gUqPSHd_11gpui_canvas@GOTPCREL(%rip)
.Ltmp1044:
.LBB165_299:
	movq	8(%rbx), %rax
	movq	%r15, %rcx
	shlq	$4, %rcx
	movl	%ebp, (%rax,%rcx)
	movdqa	48(%rsp), %xmm0
	movd	%xmm0, 4(%rax,%rcx)
	pshufd	$85, %xmm0, %xmm0
	movd	%xmm0, 8(%rax,%rcx)
	movl	%r14d, 12(%rax,%rcx)
	incq	%r15
	movq	%r15, 16(%rbx)
	jmp	.LBB165_301
.LBB165_300:
	movq	4(%rdi), %xmm0
	paddd	48(%rsp), %xmm0
	movq	%xmm0, 4(%rdi)
.LBB165_301:
	movq	1064(%rsp), %rax
	movq	%rax, 120(%rsp)
	movq	40(%rax), %rdi
	testq	%rdi, %rdi
	je	.LBB165_339
	movq	120(%rsp), %rdx
	movq	32(%rdx), %rax
	movq	8(%rdx), %rcx
	movq	16(%rdx), %r9
	movl	1072(%rsp), %edx
	movl	1080(%rsp), %esi
	movl	%esi, 96(%rsp)
	movl	1076(%rsp), %esi
	movl	%esi, 36(%rsp)
	leaq	(%rax,%rdi,4), %rsi
	movq	%rsi, 48(%rsp)
	xorl	%r10d, %r10d
	jmp	.LBB165_304
	.p2align	4
.LBB165_303:
	addq	$4, %rax
	incl	%r10d
	cmpq	48(%rsp), %rax
	je	.LBB165_339
.LBB165_304:
	movl	(%rax), %edi
	cmpl	$-1, %edi
	je	.LBB165_303
	movl	%r10d, %r8d
	subl	96(%rsp), %r8d
	movslq	%r8d, %r8
	movq	%r8, %rbx
	notq	%rbx
	addq	40(%rsp), %rbx
	cmpb	$0, 15(%rsp)
	cmoveq	%r8, %rbx
	imulq	240(%rsp), %rbx
	movq	16(%rsp), %r11
	subq	%rbx, %r11
	movq	88(%rsp), %rsi
	leaq	(%rsi,%rbx), %r14
	xorl	%r12d, %r12d
	movl	%edx, %r15d
	jmp	.LBB165_308
	.p2align	4
.LBB165_306:
	movl	%ebp, %edi
.LBB165_307:
	movl	%edi, %r15d
	incl	%r15d
	movl	12(%r13), %edi
	cmpl	$-1, %edi
	je	.LBB165_330
.LBB165_308:
	movslq	%edi, %r13
	cmpq	%r13, %r9
	jbe	.LBB165_881
	movl	%r12d, %esi
	shlq	$4, %r13
	movl	(%rcx,%r13), %edi
	movl	%edi, %ebp
	testl	%r12d, %r12d
	je	.LBB165_321
	movl	%edi, %r12d
	movl	%edi, %ebp
	subl	%r15d, %r12d
	jle	.LBB165_321
	movl	%esi, %ebp
	sarl	$9, %ebp
	cmpb	$0, 24(%rsp)
	je	.LBB165_313
	andl	$511, %ebp
	movl	%ebp, %r8d
	xorl	$511, %r8d
	cmpl	$256, %ebp
	cmovael	%r8d, %ebp
	jmp	.LBB165_314
	.p2align	4
.LBB165_313:
	movl	%esi, %r8d
	sarl	$31, %r8d
	xorl	%r8d, %ebp
	cmpl	$255, %ebp
	movl	$255, %r8d
	cmovgel	%r8d, %ebp
.LBB165_314:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_854
	cmpl	%r15d, %edi
	jne	.LBB165_317
	movl	%r15d, %ebp
	jmp	.LBB165_321
	.p2align	4
.LBB165_317:
	movslq	%r12d, %r12
	movslq	%r15d, %r8
	leaq	1(,%r8,4), %r15
	.p2align	4
.LBB165_318:
	cmpq	%r11, %r15
	jae	.LBB165_873
	movb	%bpl, (%r14,%r15)
	addq	$4, %r15
	decq	%r12
	jne	.LBB165_318
	movl	%edi, %ebp
.LBB165_321:
	addq	%rcx, %r13
	movl	4(%r13), %r12d
	shll	$9, %r12d
	addl	%esi, %r12d
	movl	%r12d, %r15d
	subl	8(%r13), %r15d
	je	.LBB165_306
	cmpl	%edx, %ebp
	jl	.LBB165_306
	movl	%r15d, %r8d
	sarl	$9, %r8d
	cmpb	$0, 24(%rsp)
	je	.LBB165_326
	andl	$511, %r8d
	movl	%r8d, %esi
	xorl	$511, %esi
	cmpl	$256, %r8d
	cmovael	%esi, %r8d
	jmp	.LBB165_327
	.p2align	4
.LBB165_326:
	sarl	$31, %r15d
	xorl	%r15d, %r8d
	cmpl	$255, %r8d
	movl	$255, %esi
	cmovgel	%esi, %r8d
.LBB165_327:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_854
	movslq	%ebp, %rsi
	leaq	1(,%rsi,4), %r15
	cmpq	%r11, %r15
	jae	.LBB165_873
	movb	%r8b, (%r14,%r15)
	jmp	.LBB165_307
	.p2align	4
.LBB165_330:
	testl	%r12d, %r12d
	je	.LBB165_303
	movl	%r12d, %edi
	sarl	$9, %edi
	cmpb	$0, 24(%rsp)
	je	.LBB165_333
	andl	$511, %edi
	movl	%edi, %esi
	xorl	$511, %esi
	cmpl	$256, %edi
	cmovael	%esi, %edi
	jmp	.LBB165_334
.LBB165_333:
	sarl	$31, %r12d
	xorl	%r12d, %edi
	cmpl	$255, %edi
	movl	$255, %esi
	cmovgel	%esi, %edi
.LBB165_334:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_854
	cmpl	%r15d, 36(%rsp)
	je	.LBB165_303
	movl	36(%rsp), %esi
	subl	%r15d, %esi
	movslq	%esi, %r8
	movslq	%r15d, %rsi
	leaq	1(,%rsi,4), %r13
	.p2align	4
.LBB165_337:
	cmpq	%r11, %r13
	jae	.LBB165_889
	movb	%dil, (%r14,%r13)
	addq	$4, %r13
	decq	%r8
	jne	.LBB165_337
	jmp	.LBB165_303
.LBB165_339:
.Ltmp1045:
	movq	120(%rsp), %rdi
	xorl	%esi, %esi
	xorl	%edx, %edx
	movq	80(%rsp), %rcx
	movq	40(%rsp), %r8
	callq	*_RNvXs0_NtCs89dqw0uHV7N_4zeno6rasterNtB5_11HeapStorageNtB5_13RasterStorage5reset@GOTPCREL(%rip)
.Ltmp1046:
	movq	72(%rsp), %r13
	movq	280(%rsp), %rdi
	movss	116(%rsp), %xmm0
	addss	256(%rsp), %xmm0
	movss	%xmm0, 1040(%rsp)
	movdqa	336(%rsp), %xmm0
	movd	%xmm0, 1044(%rsp)
	pxor	%xmm0, %xmm0
	movdqu	%xmm0, 1048(%rsp)
	movb	$1, 1116(%rsp)
	movl	$0, 1072(%rsp)
	movl	$0, 1080(%rsp)
	movq	80(%rsp), %rax
	movl	%eax, 1076(%rsp)
	movq	40(%rsp), %rax
	movl	%eax, 1084(%rsp)
	movl	%eax, 1088(%rsp)
	leaq	1072(%rsp), %rax
	movdqu	%xmm0, 20(%rax)
	movb	$1, 1117(%rsp)
.Ltmp1047:
	leaq	592(%rsp), %rsi
	leaq	560(%rsp), %rdx
	leaq	528(%rsp), %rcx
	leaq	1040(%rsp), %r8
	callq	_RINvMs_NtCs89dqw0uHV7N_4zeno7scratchNtB5_5Inner5applyRTRSNtNtB7_8geometry6VectorRSNtNtB7_7command4VerbEINtNtB7_6raster10RasterizerNtB1G_11HeapStorageEECs9S44gUqPSHd_11gpui_canvas
.Ltmp1048:
	cmpb	$0, 1116(%rsp)
	jne	.LBB165_343
	movl	1048(%rsp), %esi
	movl	1052(%rsp), %edx
.Ltmp1049:
	leaq	1040(%rsp), %rdi
	callq	_RNvMNtCs89dqw0uHV7N_4zeno6rasterINtB2_10RasterizerNtB2_11HeapStorageE7line_toCs9S44gUqPSHd_11gpui_canvas
.Ltmp1050:
.LBB165_343:
	cmpb	$0, 1117(%rsp)
	jne	.LBB165_362
	movq	1064(%rsp), %rbx
	movl	1096(%rsp), %eax
	subl	52(%rbx), %eax
	movslq	%eax, %r13
	movq	40(%rbx), %r11
	cmpq	%r13, %r11
	jbe	.LBB165_901
	movl	1092(%rsp), %ebp
	movsd	1108(%rsp), %xmm0
	movaps	%xmm0, 48(%rsp)
	movq	16(%rbx), %r11
	movq	32(%rbx), %rax
	movl	(%rax,%r13,4), %edi
	cmpl	$-1, %edi
	je	.LBB165_352
	movl	$-1, %esi
.LBB165_347:
	movslq	%edi, %rcx
	cmpq	%rcx, %r11
	jbe	.LBB165_897
	movl	%edi, %r14d
	movq	8(%rbx), %rdx
	movq	%rcx, %rdi
	shlq	$4, %rdi
	movl	(%rdx,%rdi), %r8d
	cmpl	%ebp, %r8d
	jg	.LBB165_354
	addq	%rdx, %rdi
	cmpl	%r8d, %ebp
	je	.LBB165_361
	movl	12(%rdi), %edi
	movl	%r14d, %esi
	cmpl	$-1, %edi
	jne	.LBB165_347
	movl	$-1, %r14d
	jmp	.LBB165_356
.LBB165_352:
	movl	$-1, %r14d
.LBB165_353:
	movl	%r11d, (%rax,%r13,4)
	movq	72(%rsp), %r13
	jmp	.LBB165_358
.LBB165_354:
	cmpl	$-1, %esi
	je	.LBB165_353
	movslq	%esi, %rcx
.LBB165_356:
	cmpq	%rcx, %r11
	movq	72(%rsp), %r13
	jbe	.LBB165_900
	shlq	$4, %rcx
	movl	%r11d, 12(%rdx,%rcx)
.LBB165_358:
	movq	16(%rbx), %r15
	cmpq	(%rbx), %r15
	jne	.LBB165_360
.Ltmp1051:
	movq	%rbx, %rdi
	callq	*_RNvMs7_NtCse3dB2pZFcs1_5alloc7raw_vecINtB5_6RawVecNtNtCs89dqw0uHV7N_4zeno6raster4CellE8grow_oneCs9S44gUqPSHd_11gpui_canvas@GOTPCREL(%rip)
.Ltmp1052:
.LBB165_360:
	movq	8(%rbx), %rax
	movq	%r15, %rcx
	shlq	$4, %rcx
	movl	%ebp, (%rax,%rcx)
	movdqa	48(%rsp), %xmm0
	movd	%xmm0, 4(%rax,%rcx)
	pshufd	$85, %xmm0, %xmm0
	movd	%xmm0, 8(%rax,%rcx)
	movl	%r14d, 12(%rax,%rcx)
	incq	%r15
	movq	%r15, 16(%rbx)
	jmp	.LBB165_362
.LBB165_361:
	movq	4(%rdi), %xmm0
	paddd	48(%rsp), %xmm0
	movq	%xmm0, 4(%rdi)
	movq	72(%rsp), %r13
.LBB165_362:
	movq	1064(%rsp), %rdx
	movq	40(%rdx), %rdi
	testq	%rdi, %rdi
	je	.LBB165_673
	movq	32(%rdx), %rax
	movq	8(%rdx), %rcx
	movq	16(%rdx), %r8
	movl	1072(%rsp), %edx
	movl	1080(%rsp), %esi
	movl	%esi, 80(%rsp)
	movl	1076(%rsp), %esi
	movl	%esi, 96(%rsp)
	leaq	(%rax,%rdi,4), %rsi
	movq	%rsi, 48(%rsp)
	xorl	%r9d, %r9d
	jmp	.LBB165_365
	.p2align	4
.LBB165_364:
	addq	$4, %rax
	incl	%r9d
	cmpq	48(%rsp), %rax
	movq	72(%rsp), %r13
	je	.LBB165_673
.LBB165_365:
	movl	(%rax), %edi
	cmpl	$-1, %edi
	je	.LBB165_364
	movl	%r9d, %r10d
	subl	80(%rsp), %r10d
	movslq	%r10d, %r10
	movq	%r10, %rbx
	notq	%rbx
	addq	40(%rsp), %rbx
	cmpb	$0, 15(%rsp)
	cmoveq	%r10, %rbx
	imulq	240(%rsp), %rbx
	movq	16(%rsp), %r10
	subq	%rbx, %r10
	movq	88(%rsp), %rsi
	leaq	(%rsi,%rbx), %r11
	xorl	%r12d, %r12d
	movl	%edx, %r14d
	jmp	.LBB165_369
	.p2align	4
.LBB165_367:
	movl	%ebp, %edi
.LBB165_368:
	movl	%edi, %r14d
	incl	%r14d
	movl	12(%r13), %edi
	cmpl	$-1, %edi
	je	.LBB165_391
.LBB165_369:
	movslq	%edi, %r13
	cmpq	%r13, %r8
	jbe	.LBB165_884
	movl	%r12d, %esi
	shlq	$4, %r13
	movl	(%rcx,%r13), %edi
	movl	%edi, %ebp
	testl	%r12d, %r12d
	je	.LBB165_382
	movl	%edi, %r12d
	movl	%edi, %ebp
	subl	%r14d, %r12d
	jle	.LBB165_382
	movl	%esi, %ebp
	sarl	$9, %ebp
	cmpb	$0, 24(%rsp)
	je	.LBB165_374
	andl	$511, %ebp
	movl	%ebp, %r15d
	xorl	$511, %r15d
	cmpl	$256, %ebp
	cmovael	%r15d, %ebp
	jmp	.LBB165_375
	.p2align	4
.LBB165_374:
	movl	%esi, %r15d
	sarl	$31, %r15d
	xorl	%r15d, %ebp
	cmpl	$255, %ebp
	movl	$255, %r15d
	cmovgel	%r15d, %ebp
.LBB165_375:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_857
	cmpl	%r14d, %edi
	jne	.LBB165_378
	movl	%r14d, %ebp
	jmp	.LBB165_382
	.p2align	4
.LBB165_378:
	movslq	%r12d, %r12
	movslq	%r14d, %r14
	leaq	2(,%r14,4), %r14
	.p2align	4
.LBB165_379:
	cmpq	%r10, %r14
	jae	.LBB165_874
	movb	%bpl, (%r11,%r14)
	addq	$4, %r14
	decq	%r12
	jne	.LBB165_379
	movl	%edi, %ebp
.LBB165_382:
	addq	%rcx, %r13
	movl	4(%r13), %r12d
	shll	$9, %r12d
	addl	%esi, %r12d
	movl	%r12d, %r15d
	subl	8(%r13), %r15d
	je	.LBB165_367
	cmpl	%edx, %ebp
	jl	.LBB165_367
	movl	%r15d, %r14d
	sarl	$9, %r14d
	cmpb	$0, 24(%rsp)
	je	.LBB165_387
	andl	$511, %r14d
	movl	%r14d, %esi
	xorl	$511, %esi
	cmpl	$256, %r14d
	cmovael	%esi, %r14d
	jmp	.LBB165_388
	.p2align	4
.LBB165_387:
	sarl	$31, %r15d
	xorl	%r15d, %r14d
	cmpl	$255, %r14d
	movl	$255, %esi
	cmovgel	%esi, %r14d
.LBB165_388:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_857
	movslq	%ebp, %rsi
	leaq	2(,%rsi,4), %r15
	cmpq	%r10, %r15
	jae	.LBB165_887
	movb	%r14b, (%r11,%r15)
	jmp	.LBB165_368
	.p2align	4
.LBB165_391:
	testl	%r12d, %r12d
	je	.LBB165_364
	movl	%r12d, %edi
	sarl	$9, %edi
	cmpb	$0, 24(%rsp)
	je	.LBB165_394
	andl	$511, %edi
	movl	%edi, %esi
	xorl	$511, %esi
	cmpl	$256, %edi
	cmovael	%esi, %edi
	jmp	.LBB165_395
.LBB165_394:
	sarl	$31, %r12d
	xorl	%r12d, %edi
	cmpl	$255, %edi
	movl	$255, %esi
	cmovgel	%esi, %edi
.LBB165_395:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_857
	cmpl	%r14d, 96(%rsp)
	je	.LBB165_364
	movl	96(%rsp), %esi
	subl	%r14d, %esi
	movslq	%esi, %rbx
	movslq	%r14d, %rsi
	leaq	2(,%rsi,4), %r13
	.p2align	4
.LBB165_398:
	cmpq	%r10, %r13
	jae	.LBB165_875
	movb	%dil, (%r11,%r13)
	addq	$4, %r13
	decq	%rbx
	jne	.LBB165_398
	jmp	.LBB165_364
.LBB165_400:
	movq	72(%rbx), %rsi
	leaq	1(%rsi), %r8
	movq	%r8, 72(%rbx)
	cmpl	$-1, %r9d
	je	.LBB165_186
	movslq	%r9d, %r8
.LBB165_402:
	cmpq	%r8, %rdx
	jbe	.LBB165_905
	shlq	$4, %r8
	movl	%esi, 12(%rcx,%r8)
.LBB165_404:
	cmpq	$1024, %rsi
	jae	.LBB165_407
	cmpq	%rdx, %rsi
	jae	.LBB165_903
	shlq	$4, %rsi
	movl	%ebp, (%rcx,%rsi)
	movdqa	48(%rsp), %xmm0
	movd	%xmm0, 4(%rcx,%rsi)
	pshufd	$85, %xmm0, %xmm0
	movd	%xmm0, 8(%rcx,%rsi)
	movl	%r14d, 12(%rcx,%rsi)
	jmp	.LBB165_429
.LBB165_407:
	movq	16(%rbx), %r15
	testq	%r15, %r15
	jne	.LBB165_411
	cmpq	$1023, (%rbx)
	jbe	.LBB165_797
	xorl	%r15d, %r15d
.LBB165_410:
	movq	%r15, %rdi
	shlq	$4, %rdi
	addq	8(%rbx), %rdi
	movl	$16384, %edx
	movq	%r12, %rsi
	callq	*memcpy@GOTPCREL(%rip)
	addq	$1024, %r15
	movq	%r15, 16(%rbx)
.LBB165_411:
	cmpq	(%rbx), %r15
	jne	.LBB165_413
.Ltmp1079:
	movq	%rbx, %rdi
	callq	*_RNvMs7_NtCse3dB2pZFcs1_5alloc7raw_vecINtB5_6RawVecNtNtCs89dqw0uHV7N_4zeno6raster4CellE8grow_oneCs9S44gUqPSHd_11gpui_canvas@GOTPCREL(%rip)
.Ltmp1080:
.LBB165_413:
	movq	8(%rbx), %rax
	movq	%r15, %rcx
	shlq	$4, %rcx
	movl	%ebp, (%rax,%rcx)
	movdqa	48(%rsp), %xmm0
	movd	%xmm0, 4(%rax,%rcx)
	pshufd	$85, %xmm0, %xmm0
	movd	%xmm0, 8(%rax,%rcx)
	movl	%r14d, 12(%rax,%rcx)
	incq	%r15
	movq	%r15, 16(%rbx)
	jmp	.LBB165_429
.LBB165_414:
	movq	72(%rbx), %rsi
	leaq	1(%rsi), %r8
	movq	%r8, 72(%rbx)
	cmpl	$-1, %r9d
	je	.LBB165_188
	movslq	%r9d, %r8
.LBB165_416:
	cmpq	%r8, %rdx
	movq	72(%rsp), %r13
	jbe	.LBB165_905
	shlq	$4, %r8
	movl	%esi, 12(%rcx,%r8)
.LBB165_418:
	cmpq	$1024, %rsi
	jae	.LBB165_421
	cmpq	%rdx, %rsi
	jae	.LBB165_903
	shlq	$4, %rsi
	movl	%ebp, (%rcx,%rsi)
	movdqa	48(%rsp), %xmm0
	movd	%xmm0, 4(%rcx,%rsi)
	pshufd	$85, %xmm0, %xmm0
	movd	%xmm0, 8(%rcx,%rsi)
	movl	%r14d, 12(%rcx,%rsi)
	jmp	.LBB165_494
.LBB165_421:
	movq	16(%rbx), %r15
	testq	%r15, %r15
	jne	.LBB165_425
	cmpq	$1023, (%rbx)
	jbe	.LBB165_799
	xorl	%r15d, %r15d
.LBB165_424:
	movq	%r15, %rdi
	shlq	$4, %rdi
	addq	8(%rbx), %rdi
	movl	$16384, %edx
	movq	%r12, %rsi
	callq	*memcpy@GOTPCREL(%rip)
	addq	$1024, %r15
	movq	%r15, 16(%rbx)
.LBB165_425:
	cmpq	(%rbx), %r15
	jne	.LBB165_427
.Ltmp1067:
	movq	%rbx, %rdi
	callq	*_RNvMs7_NtCse3dB2pZFcs1_5alloc7raw_vecINtB5_6RawVecNtNtCs89dqw0uHV7N_4zeno6raster4CellE8grow_oneCs9S44gUqPSHd_11gpui_canvas@GOTPCREL(%rip)
.Ltmp1068:
.LBB165_427:
	movq	8(%rbx), %rax
	movq	%r15, %rcx
	shlq	$4, %rcx
	movl	%ebp, (%rax,%rcx)
	movdqa	48(%rsp), %xmm0
	movd	%xmm0, 4(%rax,%rcx)
	pshufd	$85, %xmm0, %xmm0
	movd	%xmm0, 8(%rax,%rcx)
	movl	%r14d, 12(%rax,%rcx)
	incq	%r15
	movq	%r15, 16(%rbx)
	jmp	.LBB165_494
.LBB165_428:
	movq	4(%rsi), %xmm0
	paddd	48(%rsp), %xmm0
	movq	%xmm0, 4(%rsi)
.LBB165_429:
	movq	168(%rsp), %rdi
.Ltmp1081:
	callq	*_RNvXs2_NtCs89dqw0uHV7N_4zeno6rasterNtB5_15AdaptiveStorageNtB5_13RasterStorage7indices@GOTPCREL(%rip)
.Ltmp1082:
	movq	168(%rsp), %rcx
	cmpq	$1025, 72(%rcx)
	movq	%rcx, 280(%rsp)
	jb	.LBB165_432
	movq	16(%rcx), %r10
	movq	8(%rcx), %rcx
	jmp	.LBB165_433
.LBB165_432:
	addq	$80, %rcx
	movl	$1024, %r10d
.LBB165_433:
	testq	%rdx, %rdx
	je	.LBB165_471
	movl	176(%rsp), %esi
	movl	184(%rsp), %edi
	movl	%edi, 96(%rsp)
	movl	180(%rsp), %edi
	movl	%edi, 36(%rsp)
	leaq	(%rax,%rdx,4), %rdx
	movq	%rdx, 48(%rsp)
	xorl	%edx, %edx
	jmp	.LBB165_436
	.p2align	4
.LBB165_435:
	addq	$4, %rax
	incl	%edx
	cmpq	48(%rsp), %rax
	je	.LBB165_471
.LBB165_436:
	movl	(%rax), %edi
	cmpl	$-1, %edi
	je	.LBB165_435
	movl	%edx, %r9d
	subl	96(%rsp), %r9d
	movslq	%r9d, %r9
	movq	%r9, %rbx
	notq	%rbx
	addq	40(%rsp), %rbx
	cmpb	$0, 15(%rsp)
	cmoveq	%r9, %rbx
	imulq	240(%rsp), %rbx
	movq	16(%rsp), %r11
	subq	%rbx, %r11
	movq	88(%rsp), %r8
	leaq	(%r8,%rbx), %r14
	xorl	%r12d, %r12d
	movl	%esi, %r15d
	jmp	.LBB165_440
	.p2align	4
.LBB165_438:
	movl	%ebp, %edi
.LBB165_439:
	movl	%edi, %r15d
	incl	%r15d
	movl	12(%r13), %edi
	cmpl	$-1, %edi
	je	.LBB165_462
.LBB165_440:
	movslq	%edi, %r13
	cmpq	%r13, %r10
	jbe	.LBB165_882
	movl	%r12d, %r8d
	shlq	$4, %r13
	movl	(%rcx,%r13), %edi
	movl	%edi, %ebp
	testl	%r12d, %r12d
	je	.LBB165_453
	movl	%edi, %r12d
	movl	%edi, %ebp
	subl	%r15d, %r12d
	jle	.LBB165_453
	movl	%r8d, %ebp
	sarl	$9, %ebp
	cmpb	$0, 24(%rsp)
	je	.LBB165_445
	andl	$511, %ebp
	movl	%ebp, %r9d
	xorl	$511, %r9d
	cmpl	$256, %ebp
	cmovael	%r9d, %ebp
	jmp	.LBB165_446
	.p2align	4
.LBB165_445:
	movl	%r8d, %r9d
	sarl	$31, %r9d
	xorl	%r9d, %ebp
	cmpl	$255, %ebp
	movl	$255, %r9d
	cmovgel	%r9d, %ebp
.LBB165_446:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_859
	cmpl	%r15d, %edi
	jne	.LBB165_449
	movl	%r15d, %ebp
	jmp	.LBB165_453
	.p2align	4
.LBB165_449:
	movslq	%r12d, %r12
	movslq	%r15d, %r15
	shlq	$2, %r15
	.p2align	4
.LBB165_450:
	cmpq	%r11, %r15
	jae	.LBB165_877
	movb	%bpl, (%r14,%r15)
	addq	$4, %r15
	decq	%r12
	jne	.LBB165_450
	movl	%edi, %ebp
.LBB165_453:
	addq	%rcx, %r13
	movl	4(%r13), %r12d
	shll	$9, %r12d
	addl	%r8d, %r12d
	movl	%r12d, %r15d
	subl	8(%r13), %r15d
	je	.LBB165_438
	cmpl	%esi, %ebp
	jl	.LBB165_438
	movl	%r15d, %r9d
	sarl	$9, %r9d
	cmpb	$0, 24(%rsp)
	je	.LBB165_458
	andl	$511, %r9d
	movl	%r9d, %r8d
	xorl	$511, %r8d
	cmpl	$256, %r9d
	cmovael	%r8d, %r9d
	jmp	.LBB165_459
	.p2align	4
.LBB165_458:
	sarl	$31, %r15d
	xorl	%r15d, %r9d
	cmpl	$255, %r9d
	movl	$255, %r8d
	cmovgel	%r8d, %r9d
.LBB165_459:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_859
	movslq	%ebp, %r15
	shlq	$2, %r15
	cmpq	%r11, %r15
	jae	.LBB165_877
	movb	%r9b, (%r14,%r15)
	jmp	.LBB165_439
	.p2align	4
.LBB165_462:
	testl	%r12d, %r12d
	je	.LBB165_435
	movl	%r12d, %edi
	sarl	$9, %edi
	cmpb	$0, 24(%rsp)
	je	.LBB165_465
	andl	$511, %edi
	movl	%edi, %r8d
	xorl	$511, %r8d
	cmpl	$256, %edi
	cmovael	%r8d, %edi
	jmp	.LBB165_466
.LBB165_465:
	sarl	$31, %r12d
	xorl	%r12d, %edi
	cmpl	$255, %edi
	movl	$255, %r8d
	cmovgel	%r8d, %edi
.LBB165_466:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_859
	cmpl	%r15d, 36(%rsp)
	je	.LBB165_435
	movl	36(%rsp), %r8d
	subl	%r15d, %r8d
	movslq	%r8d, %r9
	movslq	%r15d, %r13
	shlq	$2, %r13
	.p2align	4
.LBB165_469:
	cmpq	%r11, %r13
	jae	.LBB165_892
	movb	%dil, (%r14,%r13)
	addq	$4, %r13
	decq	%r9
	jne	.LBB165_469
	jmp	.LBB165_435
.LBB165_471:
.Ltmp1083:
	movq	280(%rsp), %rdi
	xorl	%esi, %esi
	xorl	%edx, %edx
	movq	80(%rsp), %rcx
	movq	40(%rsp), %r8
	callq	*_RNvXs2_NtCs89dqw0uHV7N_4zeno6rasterNtB5_15AdaptiveStorageNtB5_13RasterStorage5reset@GOTPCREL(%rip)
.Ltmp1084:
	movss	120(%rsp), %xmm0
	addss	256(%rsp), %xmm0
	movss	%xmm0, 144(%rsp)
	movaps	336(%rsp), %xmm0
	shufps	$85, %xmm0, %xmm0
	movaps	%xmm0, 336(%rsp)
	movss	%xmm0, 148(%rsp)
	xorps	%xmm0, %xmm0
	movups	%xmm0, 152(%rsp)
	movb	$1, 220(%rsp)
	movl	$0, 176(%rsp)
	movl	$0, 184(%rsp)
	movq	80(%rsp), %rax
	movl	%eax, 180(%rsp)
	movq	40(%rsp), %rax
	movl	%eax, 188(%rsp)
	movl	%eax, 192(%rsp)
	leaq	176(%rsp), %rax
	movups	%xmm0, 20(%rax)
	movb	$1, 221(%rsp)
.Ltmp1085:
	leaq	592(%rsp), %rdi
	leaq	560(%rsp), %rsi
	leaq	528(%rsp), %rdx
	leaq	144(%rsp), %rcx
	callq	_RINvNtCs89dqw0uHV7N_4zeno9path_data5applyRTRSNtNtB4_8geometry6VectorRSNtNtB4_7command4VerbENtNtB4_5style5StyleINtNtB4_6raster10RasterizerNtB1N_15AdaptiveStorageEECs9S44gUqPSHd_11gpui_canvas
.Ltmp1086:
	cmpb	$0, 220(%rsp)
	jne	.LBB165_475
	movl	152(%rsp), %esi
	movl	156(%rsp), %edx
.Ltmp1087:
	leaq	144(%rsp), %rdi
	callq	_RNvMNtCs89dqw0uHV7N_4zeno6rasterINtB2_10RasterizerNtB2_15AdaptiveStorageE7line_toCs9S44gUqPSHd_11gpui_canvas
.Ltmp1088:
.LBB165_475:
	cmpb	$0, 221(%rsp)
	jne	.LBB165_548
	movq	168(%rsp), %rbx
	movq	64(%rbx), %rsi
	movl	$512, %r11d
	cmpq	$513, %rsi
	jb	.LBB165_478
	movq	40(%rbx), %r11
.LBB165_478:
	movq	16(%rbx), %rax
	leaq	80(%rbx), %r12
	movl	$1024, %edx
	movq	%r12, %rcx
	testq	%rax, %rax
	je	.LBB165_480
	movq	8(%rbx), %rcx
	movq	%rax, %rdx
.LBB165_480:
	movl	200(%rsp), %edi
	subl	52(%rbx), %edi
	movslq	%edi, %r13
	cmpq	%r13, %r11
	jbe	.LBB165_907
	cmpq	$513, %rsi
	jb	.LBB165_483
	movq	32(%rbx), %rdi
	jmp	.LBB165_484
.LBB165_483:
	leaq	16464(%rbx), %rdi
.LBB165_484:
	movl	196(%rsp), %ebp
	movsd	212(%rsp), %xmm0
	movaps	%xmm0, 48(%rsp)
	movl	(%rdi,%r13,4), %esi
	cmpl	$-1, %esi
	je	.LBB165_491
	movl	$-1, %r9d
.LBB165_486:
	movslq	%esi, %r8
	cmpq	%r8, %rdx
	jbe	.LBB165_898
	movl	%esi, %r14d
	movq	%r8, %rsi
	shlq	$4, %rsi
	movl	(%rcx,%rsi), %r10d
	cmpl	%ebp, %r10d
	jg	.LBB165_533
	addq	%rcx, %rsi
	cmpl	%r10d, %ebp
	je	.LBB165_547
	movl	12(%rsi), %esi
	movl	%r14d, %r9d
	cmpl	$-1, %esi
	jne	.LBB165_486
	movq	72(%rbx), %rsi
	leaq	1(%rsi), %rdi
	movq	%rdi, 72(%rbx)
	movl	$-1, %r14d
	jmp	.LBB165_535
.LBB165_491:
	movq	72(%rbx), %rsi
	leaq	1(%rsi), %r8
	movq	%r8, 72(%rbx)
	movl	$-1, %r14d
.LBB165_492:
	movl	%esi, (%rdi,%r13,4)
	jmp	.LBB165_537
.LBB165_493:
	movq	4(%rsi), %xmm0
	paddd	48(%rsp), %xmm0
	movq	%xmm0, 4(%rsi)
	movq	72(%rsp), %r13
.LBB165_494:
	movq	168(%rsp), %rdi
.Ltmp1069:
	callq	*_RNvXs2_NtCs89dqw0uHV7N_4zeno6rasterNtB5_15AdaptiveStorageNtB5_13RasterStorage7indices@GOTPCREL(%rip)
.Ltmp1070:
	movq	168(%rsp), %r12
	cmpq	$1025, 72(%r12)
	jb	.LBB165_497
	movq	16(%r12), %r11
	movq	8(%r12), %r12
	jmp	.LBB165_498
.LBB165_497:
	addq	$80, %r12
	movl	$1024, %r11d
.LBB165_498:
	testq	%rdx, %rdx
	je	.LBB165_669
	movl	176(%rsp), %r9d
	movl	184(%rsp), %ecx
	movl	%ecx, 116(%rsp)
	movl	180(%rsp), %ecx
	movl	%ecx, 120(%rsp)
	leaq	(%rax,%rdx,4), %rcx
	movq	%rcx, 256(%rsp)
	movl	$0, 36(%rsp)
	movq	%r11, 48(%rsp)
	movl	%r9d, 80(%rsp)
	jmp	.LBB165_501
	.p2align	4
.LBB165_500:
	movq	96(%rsp), %rax
	addq	$4, %rax
	incl	36(%rsp)
	cmpq	256(%rsp), %rax
	je	.LBB165_669
.LBB165_501:
	movq	%rax, 96(%rsp)
	movl	(%rax), %ecx
	cmpl	$-1, %ecx
	je	.LBB165_500
	movl	36(%rsp), %eax
	subl	116(%rsp), %eax
	cltq
	movq	%rax, %rbx
	notq	%rbx
	addq	40(%rsp), %rbx
	cmpb	$0, 15(%rsp)
	cmoveq	%rax, %rbx
	imulq	240(%rsp), %rbx
	movq	16(%rsp), %rbp
	subq	%rbx, %rbp
	jb	.LBB165_872
	addq	88(%rsp), %rbx
	xorl	%r14d, %r14d
	movl	%r9d, %eax
	jmp	.LBB165_506
.LBB165_523:
	movb	$1, %dl
	testb	%dl, %dl
	jne	.LBB165_862
	.p2align	4
.LBB165_504:
	movb	%cl, (%rbx,%rax)
.LBB165_505:
	incl	%r15d
	movl	12(%r13), %ecx
	movl	%r15d, %eax
	cmpl	$-1, %ecx
	je	.LBB165_524
.LBB165_506:
	movslq	%ecx, %r13
	cmpq	%r13, %r11
	jbe	.LBB165_885
	shlq	$4, %r13
	movl	(%r12,%r13), %r15d
	testl	%r14d, %r14d
	je	.LBB165_516
	movl	%r15d, %edx
	subl	%eax, %edx
	jle	.LBB165_516
	movl	%r14d, %ecx
	sarl	$9, %ecx
	cmpb	$0, 24(%rsp)
	je	.LBB165_511
	andl	$511, %ecx
	movl	%ecx, %esi
	xorl	$511, %esi
	cmpl	$256, %ecx
	cmovael	%esi, %ecx
	jmp	.LBB165_512
	.p2align	4
.LBB165_511:
	movl	%r14d, %esi
	sarl	$31, %esi
	xorl	%esi, %ecx
	cmpl	$255, %ecx
	movl	$255, %esi
	cmovgel	%esi, %ecx
.LBB165_512:
	movslq	%edx, %rdx
	movslq	%eax, %rdi
	leaq	(%rdx,%rdi), %rsi
	cmpq	%rbp, %rsi
	seta	%r8b
	movq	%rdx, %rsi
	addq	%rdi, %rsi
	jb	.LBB165_522
	testb	%r8b, %r8b
	jne	.LBB165_861
.LBB165_514:
	cmpl	%eax, %r15d
	je	.LBB165_516
	addq	%rbx, %rdi
	movzbl	%cl, %esi
	callq	*memset@GOTPCREL(%rip)
	movl	80(%rsp), %r9d
	movq	48(%rsp), %r11
.LBB165_516:
	addq	%r12, %r13
	movslq	%r15d, %rax
	movl	4(%r13), %ecx
	shll	$9, %ecx
	addl	%ecx, %r14d
	movl	%r14d, %edx
	subl	8(%r13), %edx
	sete	%cl
	cmpl	%r9d, %eax
	setl	%sil
	orb	%cl, %sil
	jne	.LBB165_505
	movl	%edx, %ecx
	sarl	$9, %ecx
	cmpb	$0, 24(%rsp)
	je	.LBB165_519
	andl	$511, %ecx
	movl	%ecx, %edx
	xorl	$511, %edx
	cmpl	$256, %ecx
	cmovael	%edx, %ecx
	jmp	.LBB165_520
	.p2align	4
.LBB165_519:
	sarl	$31, %edx
	xorl	%edx, %ecx
	cmpl	$255, %ecx
	movl	$255, %edx
	cmovgel	%edx, %ecx
.LBB165_520:
	leaq	1(%rax), %rsi
	cmpq	%rbp, %rsi
	seta	%dl
	cmpl	$-1, %r15d
	je	.LBB165_523
	testb	%dl, %dl
	je	.LBB165_504
	jmp	.LBB165_862
.LBB165_522:
	movb	$1, %r8b
	testb	%r8b, %r8b
	je	.LBB165_514
	jmp	.LBB165_861
	.p2align	4
.LBB165_524:
	testl	%r14d, %r14d
	movq	72(%rsp), %r13
	je	.LBB165_500
	movl	%r14d, %eax
	sarl	$9, %eax
	cmpb	$0, 24(%rsp)
	je	.LBB165_527
	andl	$511, %eax
	movl	%eax, %ecx
	xorl	$511, %ecx
	cmpl	$256, %eax
	cmovael	%ecx, %eax
	jmp	.LBB165_528
.LBB165_527:
	sarl	$31, %r14d
	xorl	%r14d, %eax
	cmpl	$255, %eax
	movl	$255, %ecx
	cmovgel	%ecx, %eax
.LBB165_528:
	movl	120(%rsp), %ecx
	subl	%r15d, %ecx
	movslq	%ecx, %rdx
	movslq	%r15d, %rcx
	leaq	(%rdx,%rcx), %rsi
	cmpq	%rbp, %rsi
	seta	%dil
	movq	%rdx, %rsi
	addq	%rcx, %rsi
	jb	.LBB165_532
	testb	%dil, %dil
	jne	.LBB165_869
.LBB165_530:
	cmpl	%r15d, 120(%rsp)
	je	.LBB165_500
	addq	%rcx, %rbx
	movzbl	%al, %esi
	movq	%rbx, %rdi
	callq	*memset@GOTPCREL(%rip)
	movl	80(%rsp), %r9d
	movq	48(%rsp), %r11
	jmp	.LBB165_500
.LBB165_532:
	movb	$1, %dil
	testb	%dil, %dil
	je	.LBB165_530
	jmp	.LBB165_869
.LBB165_533:
	movq	72(%rbx), %rsi
	leaq	1(%rsi), %r8
	movq	%r8, 72(%rbx)
	cmpl	$-1, %r9d
	je	.LBB165_492
	movslq	%r9d, %r8
.LBB165_535:
	cmpq	%r8, %rdx
	jbe	.LBB165_905
	shlq	$4, %r8
	movl	%esi, 12(%rcx,%r8)
.LBB165_537:
	cmpq	$1024, %rsi
	jae	.LBB165_540
	cmpq	%rdx, %rsi
	jae	.LBB165_903
	shlq	$4, %rsi
	movl	%ebp, (%rcx,%rsi)
	movdqa	48(%rsp), %xmm0
	movd	%xmm0, 4(%rcx,%rsi)
	pshufd	$85, %xmm0, %xmm0
	movd	%xmm0, 8(%rcx,%rsi)
	movl	%r14d, 12(%rcx,%rsi)
	jmp	.LBB165_548
.LBB165_540:
	movq	16(%rbx), %r15
	testq	%r15, %r15
	jne	.LBB165_544
	cmpq	$1023, (%rbx)
	jbe	.LBB165_801
	xorl	%r15d, %r15d
.LBB165_543:
	movq	%r15, %rdi
	shlq	$4, %rdi
	addq	8(%rbx), %rdi
	movl	$16384, %edx
	movq	%r12, %rsi
	callq	*memcpy@GOTPCREL(%rip)
	addq	$1024, %r15
	movq	%r15, 16(%rbx)
.LBB165_544:
	cmpq	(%rbx), %r15
	jne	.LBB165_546
.Ltmp1091:
	movq	%rbx, %rdi
	callq	*_RNvMs7_NtCse3dB2pZFcs1_5alloc7raw_vecINtB5_6RawVecNtNtCs89dqw0uHV7N_4zeno6raster4CellE8grow_oneCs9S44gUqPSHd_11gpui_canvas@GOTPCREL(%rip)
.Ltmp1092:
.LBB165_546:
	movq	8(%rbx), %rax
	movq	%r15, %rcx
	shlq	$4, %rcx
	movl	%ebp, (%rax,%rcx)
	movdqa	48(%rsp), %xmm0
	movd	%xmm0, 4(%rax,%rcx)
	pshufd	$85, %xmm0, %xmm0
	movd	%xmm0, 8(%rax,%rcx)
	movl	%r14d, 12(%rax,%rcx)
	incq	%r15
	movq	%r15, 16(%rbx)
	jmp	.LBB165_548
.LBB165_547:
	movq	4(%rsi), %xmm0
	paddd	48(%rsp), %xmm0
	movq	%xmm0, 4(%rsi)
.LBB165_548:
	movq	168(%rsp), %rdi
.Ltmp1093:
	callq	*_RNvXs2_NtCs89dqw0uHV7N_4zeno6rasterNtB5_15AdaptiveStorageNtB5_13RasterStorage7indices@GOTPCREL(%rip)
.Ltmp1094:
	movq	168(%rsp), %rcx
	cmpq	$1025, 72(%rcx)
	movq	%rcx, 120(%rsp)
	jb	.LBB165_551
	movq	16(%rcx), %r10
	movq	8(%rcx), %rcx
	jmp	.LBB165_552
.LBB165_551:
	addq	$80, %rcx
	movl	$1024, %r10d
.LBB165_552:
	testq	%rdx, %rdx
	je	.LBB165_590
	movl	176(%rsp), %esi
	movl	184(%rsp), %edi
	movl	%edi, 96(%rsp)
	movl	180(%rsp), %edi
	movl	%edi, 36(%rsp)
	leaq	(%rax,%rdx,4), %rdx
	movq	%rdx, 48(%rsp)
	xorl	%edx, %edx
	jmp	.LBB165_555
	.p2align	4
.LBB165_554:
	addq	$4, %rax
	incl	%edx
	cmpq	48(%rsp), %rax
	je	.LBB165_590
.LBB165_555:
	movl	(%rax), %edi
	cmpl	$-1, %edi
	je	.LBB165_554
	movl	%edx, %r9d
	subl	96(%rsp), %r9d
	movslq	%r9d, %r9
	movq	%r9, %rbx
	notq	%rbx
	addq	40(%rsp), %rbx
	cmpb	$0, 15(%rsp)
	cmoveq	%r9, %rbx
	imulq	240(%rsp), %rbx
	movq	16(%rsp), %r11
	subq	%rbx, %r11
	movq	88(%rsp), %r8
	leaq	(%r8,%rbx), %r14
	xorl	%r12d, %r12d
	movl	%esi, %r15d
	jmp	.LBB165_559
	.p2align	4
.LBB165_557:
	movl	%ebp, %edi
.LBB165_558:
	movl	%edi, %r15d
	incl	%r15d
	movl	12(%r13), %edi
	cmpl	$-1, %edi
	je	.LBB165_581
.LBB165_559:
	movslq	%edi, %r13
	cmpq	%r13, %r10
	jbe	.LBB165_882
	movl	%r12d, %r8d
	shlq	$4, %r13
	movl	(%rcx,%r13), %edi
	movl	%edi, %ebp
	testl	%r12d, %r12d
	je	.LBB165_572
	movl	%edi, %r12d
	movl	%edi, %ebp
	subl	%r15d, %r12d
	jle	.LBB165_572
	movl	%r8d, %ebp
	sarl	$9, %ebp
	cmpb	$0, 24(%rsp)
	je	.LBB165_564
	andl	$511, %ebp
	movl	%ebp, %r9d
	xorl	$511, %r9d
	cmpl	$256, %ebp
	cmovael	%r9d, %ebp
	jmp	.LBB165_565
	.p2align	4
.LBB165_564:
	movl	%r8d, %r9d
	sarl	$31, %r9d
	xorl	%r9d, %ebp
	cmpl	$255, %ebp
	movl	$255, %r9d
	cmovgel	%r9d, %ebp
.LBB165_565:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_860
	cmpl	%r15d, %edi
	jne	.LBB165_568
	movl	%r15d, %ebp
	jmp	.LBB165_572
	.p2align	4
.LBB165_568:
	movslq	%r12d, %r12
	movslq	%r15d, %r9
	leaq	1(,%r9,4), %r15
	.p2align	4
.LBB165_569:
	cmpq	%r11, %r15
	jae	.LBB165_878
	movb	%bpl, (%r14,%r15)
	addq	$4, %r15
	decq	%r12
	jne	.LBB165_569
	movl	%edi, %ebp
.LBB165_572:
	addq	%rcx, %r13
	movl	4(%r13), %r12d
	shll	$9, %r12d
	addl	%r8d, %r12d
	movl	%r12d, %r15d
	subl	8(%r13), %r15d
	je	.LBB165_557
	cmpl	%esi, %ebp
	jl	.LBB165_557
	movl	%r15d, %r9d
	sarl	$9, %r9d
	cmpb	$0, 24(%rsp)
	je	.LBB165_577
	andl	$511, %r9d
	movl	%r9d, %r8d
	xorl	$511, %r8d
	cmpl	$256, %r9d
	cmovael	%r8d, %r9d
	jmp	.LBB165_578
	.p2align	4
.LBB165_577:
	sarl	$31, %r15d
	xorl	%r15d, %r9d
	cmpl	$255, %r9d
	movl	$255, %r8d
	cmovgel	%r8d, %r9d
.LBB165_578:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_860
	movslq	%ebp, %r8
	leaq	1(,%r8,4), %r15
	cmpq	%r11, %r15
	jae	.LBB165_878
	movb	%r9b, (%r14,%r15)
	jmp	.LBB165_558
	.p2align	4
.LBB165_581:
	testl	%r12d, %r12d
	je	.LBB165_554
	movl	%r12d, %edi
	sarl	$9, %edi
	cmpb	$0, 24(%rsp)
	je	.LBB165_584
	andl	$511, %edi
	movl	%edi, %r8d
	xorl	$511, %r8d
	cmpl	$256, %edi
	cmovael	%r8d, %edi
	jmp	.LBB165_585
.LBB165_584:
	sarl	$31, %r12d
	xorl	%r12d, %edi
	cmpl	$255, %edi
	movl	$255, %r8d
	cmovgel	%r8d, %edi
.LBB165_585:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_860
	cmpl	%r15d, 36(%rsp)
	je	.LBB165_554
	movl	36(%rsp), %r8d
	subl	%r15d, %r8d
	movslq	%r8d, %r9
	movslq	%r15d, %r8
	leaq	1(,%r8,4), %r13
	.p2align	4
.LBB165_588:
	cmpq	%r11, %r13
	jae	.LBB165_893
	movb	%dil, (%r14,%r13)
	addq	$4, %r13
	decq	%r9
	jne	.LBB165_588
	jmp	.LBB165_554
.LBB165_590:
.Ltmp1095:
	movq	120(%rsp), %rdi
	xorl	%esi, %esi
	xorl	%edx, %edx
	movq	80(%rsp), %rcx
	movq	40(%rsp), %r8
	callq	*_RNvXs2_NtCs89dqw0uHV7N_4zeno6rasterNtB5_15AdaptiveStorageNtB5_13RasterStorage5reset@GOTPCREL(%rip)
.Ltmp1096:
	movq	72(%rsp), %r13
	movss	116(%rsp), %xmm0
	addss	256(%rsp), %xmm0
	movss	%xmm0, 144(%rsp)
	movdqa	336(%rsp), %xmm0
	movd	%xmm0, 148(%rsp)
	pxor	%xmm0, %xmm0
	movdqu	%xmm0, 152(%rsp)
	movb	$1, 220(%rsp)
	movl	$0, 176(%rsp)
	movl	$0, 184(%rsp)
	movq	80(%rsp), %rax
	movl	%eax, 180(%rsp)
	movq	40(%rsp), %rax
	movl	%eax, 188(%rsp)
	movl	%eax, 192(%rsp)
	leaq	176(%rsp), %rax
	movdqu	%xmm0, 20(%rax)
	movb	$1, 221(%rsp)
.Ltmp1097:
	leaq	592(%rsp), %rdi
	leaq	560(%rsp), %rsi
	leaq	528(%rsp), %rdx
	leaq	144(%rsp), %rcx
	callq	_RINvNtCs89dqw0uHV7N_4zeno9path_data5applyRTRSNtNtB4_8geometry6VectorRSNtNtB4_7command4VerbENtNtB4_5style5StyleINtNtB4_6raster10RasterizerNtB1N_15AdaptiveStorageEECs9S44gUqPSHd_11gpui_canvas
.Ltmp1098:
	cmpb	$0, 220(%rsp)
	jne	.LBB165_594
	movl	152(%rsp), %esi
	movl	156(%rsp), %edx
.Ltmp1099:
	leaq	144(%rsp), %rdi
	callq	_RNvMNtCs89dqw0uHV7N_4zeno6rasterINtB2_10RasterizerNtB2_15AdaptiveStorageE7line_toCs9S44gUqPSHd_11gpui_canvas
.Ltmp1100:
.LBB165_594:
	cmpb	$0, 221(%rsp)
	jne	.LBB165_627
	movq	168(%rsp), %rbx
	movq	64(%rbx), %rsi
	movl	$512, %r11d
	cmpq	$513, %rsi
	jb	.LBB165_597
	movq	40(%rbx), %r11
.LBB165_597:
	movq	16(%rbx), %rax
	leaq	80(%rbx), %r12
	movl	$1024, %edx
	movq	%r12, %rcx
	testq	%rax, %rax
	je	.LBB165_599
	movq	8(%rbx), %rcx
	movq	%rax, %rdx
.LBB165_599:
	movl	200(%rsp), %edi
	subl	52(%rbx), %edi
	movslq	%edi, %r13
	cmpq	%r13, %r11
	jbe	.LBB165_907
	cmpq	$513, %rsi
	jb	.LBB165_602
	movq	32(%rbx), %rdi
	jmp	.LBB165_603
.LBB165_602:
	leaq	16464(%rbx), %rdi
.LBB165_603:
	movl	196(%rsp), %ebp
	movsd	212(%rsp), %xmm0
	movaps	%xmm0, 48(%rsp)
	movl	(%rdi,%r13,4), %esi
	cmpl	$-1, %esi
	je	.LBB165_610
	movl	$-1, %r9d
.LBB165_605:
	movslq	%esi, %r8
	cmpq	%r8, %rdx
	jbe	.LBB165_898
	movl	%esi, %r14d
	movq	%r8, %rsi
	shlq	$4, %rsi
	movl	(%rcx,%rsi), %r10d
	cmpl	%ebp, %r10d
	jg	.LBB165_612
	addq	%rcx, %rsi
	cmpl	%r10d, %ebp
	je	.LBB165_626
	movl	12(%rsi), %esi
	movl	%r14d, %r9d
	cmpl	$-1, %esi
	jne	.LBB165_605
	movq	72(%rbx), %rsi
	leaq	1(%rsi), %rdi
	movq	%rdi, 72(%rbx)
	movl	$-1, %r14d
	jmp	.LBB165_614
.LBB165_610:
	movq	72(%rbx), %rsi
	leaq	1(%rsi), %r8
	movq	%r8, 72(%rbx)
	movl	$-1, %r14d
.LBB165_611:
	movl	%esi, (%rdi,%r13,4)
	movq	72(%rsp), %r13
	jmp	.LBB165_616
.LBB165_612:
	movq	72(%rbx), %rsi
	leaq	1(%rsi), %r8
	movq	%r8, 72(%rbx)
	cmpl	$-1, %r9d
	je	.LBB165_611
	movslq	%r9d, %r8
.LBB165_614:
	cmpq	%r8, %rdx
	movq	72(%rsp), %r13
	jbe	.LBB165_905
	shlq	$4, %r8
	movl	%esi, 12(%rcx,%r8)
.LBB165_616:
	cmpq	$1024, %rsi
	jae	.LBB165_619
	cmpq	%rdx, %rsi
	jae	.LBB165_903
	shlq	$4, %rsi
	movl	%ebp, (%rcx,%rsi)
	movdqa	48(%rsp), %xmm0
	movd	%xmm0, 4(%rcx,%rsi)
	pshufd	$85, %xmm0, %xmm0
	movd	%xmm0, 8(%rcx,%rsi)
	movl	%r14d, 12(%rcx,%rsi)
	jmp	.LBB165_627
.LBB165_619:
	movq	16(%rbx), %r15
	testq	%r15, %r15
	jne	.LBB165_623
	cmpq	$1023, (%rbx)
	jbe	.LBB165_803
	xorl	%r15d, %r15d
.LBB165_622:
	movq	%r15, %rdi
	shlq	$4, %rdi
	addq	8(%rbx), %rdi
	movl	$16384, %edx
	movq	%r12, %rsi
	callq	*memcpy@GOTPCREL(%rip)
	addq	$1024, %r15
	movq	%r15, 16(%rbx)
.LBB165_623:
	cmpq	(%rbx), %r15
	jne	.LBB165_625
.Ltmp1103:
	movq	%rbx, %rdi
	callq	*_RNvMs7_NtCse3dB2pZFcs1_5alloc7raw_vecINtB5_6RawVecNtNtCs89dqw0uHV7N_4zeno6raster4CellE8grow_oneCs9S44gUqPSHd_11gpui_canvas@GOTPCREL(%rip)
.Ltmp1104:
.LBB165_625:
	movq	8(%rbx), %rax
	movq	%r15, %rcx
	shlq	$4, %rcx
	movl	%ebp, (%rax,%rcx)
	movdqa	48(%rsp), %xmm0
	movd	%xmm0, 4(%rax,%rcx)
	pshufd	$85, %xmm0, %xmm0
	movd	%xmm0, 8(%rax,%rcx)
	movl	%r14d, 12(%rax,%rcx)
	incq	%r15
	movq	%r15, 16(%rbx)
	jmp	.LBB165_627
.LBB165_626:
	movq	4(%rsi), %xmm0
	paddd	48(%rsp), %xmm0
	movq	%xmm0, 4(%rsi)
	movq	72(%rsp), %r13
.LBB165_627:
	movq	168(%rsp), %rdi
.Ltmp1105:
	callq	*_RNvXs2_NtCs89dqw0uHV7N_4zeno6rasterNtB5_15AdaptiveStorageNtB5_13RasterStorage7indices@GOTPCREL(%rip)
.Ltmp1106:
	movq	168(%rsp), %rcx
	cmpq	$1025, 72(%rcx)
	jb	.LBB165_630
	movq	16(%rcx), %r9
	movq	8(%rcx), %rcx
	jmp	.LBB165_631
.LBB165_630:
	addq	$80, %rcx
	movl	$1024, %r9d
.LBB165_631:
	testq	%rdx, %rdx
	je	.LBB165_669
	movl	176(%rsp), %esi
	movl	184(%rsp), %edi
	movl	%edi, 80(%rsp)
	movl	180(%rsp), %edi
	movl	%edi, 96(%rsp)
	leaq	(%rax,%rdx,4), %rdx
	movq	%rdx, 48(%rsp)
	xorl	%edx, %edx
	jmp	.LBB165_634
	.p2align	4
.LBB165_633:
	addq	$4, %rax
	incl	%edx
	cmpq	48(%rsp), %rax
	movq	72(%rsp), %r13
	je	.LBB165_669
.LBB165_634:
	movl	(%rax), %r8d
	cmpl	$-1, %r8d
	je	.LBB165_633
	movl	%edx, %r10d
	subl	80(%rsp), %r10d
	movslq	%r10d, %r10
	movq	%r10, %rbx
	notq	%rbx
	addq	40(%rsp), %rbx
	cmpb	$0, 15(%rsp)
	cmoveq	%r10, %rbx
	imulq	240(%rsp), %rbx
	movq	16(%rsp), %r10
	subq	%rbx, %r10
	movq	88(%rsp), %rdi
	leaq	(%rdi,%rbx), %r11
	xorl	%r12d, %r12d
	movl	%esi, %r14d
	jmp	.LBB165_638
	.p2align	4
.LBB165_636:
	movl	%ebp, %r8d
.LBB165_637:
	movl	%r8d, %r14d
	incl	%r14d
	movl	12(%r13), %r8d
	cmpl	$-1, %r8d
	je	.LBB165_660
.LBB165_638:
	movslq	%r8d, %r13
	cmpq	%r13, %r9
	jbe	.LBB165_886
	movl	%r12d, %edi
	shlq	$4, %r13
	movl	(%rcx,%r13), %r8d
	movl	%r8d, %ebp
	testl	%r12d, %r12d
	je	.LBB165_651
	movl	%r8d, %r12d
	movl	%r8d, %ebp
	subl	%r14d, %r12d
	jle	.LBB165_651
	movl	%edi, %ebp
	sarl	$9, %ebp
	cmpb	$0, 24(%rsp)
	je	.LBB165_643
	andl	$511, %ebp
	movl	%ebp, %r15d
	xorl	$511, %r15d
	cmpl	$256, %ebp
	cmovael	%r15d, %ebp
	jmp	.LBB165_644
	.p2align	4
.LBB165_643:
	movl	%edi, %r15d
	sarl	$31, %r15d
	xorl	%r15d, %ebp
	cmpl	$255, %ebp
	movl	$255, %r15d
	cmovgel	%r15d, %ebp
.LBB165_644:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_863
	cmpl	%r14d, %r8d
	jne	.LBB165_647
	movl	%r14d, %ebp
	jmp	.LBB165_651
	.p2align	4
.LBB165_647:
	movslq	%r12d, %r12
	movslq	%r14d, %r14
	leaq	2(,%r14,4), %r14
	.p2align	4
.LBB165_648:
	cmpq	%r10, %r14
	jae	.LBB165_879
	movb	%bpl, (%r11,%r14)
	addq	$4, %r14
	decq	%r12
	jne	.LBB165_648
	movl	%r8d, %ebp
.LBB165_651:
	addq	%rcx, %r13
	movl	4(%r13), %r12d
	shll	$9, %r12d
	addl	%edi, %r12d
	movl	%r12d, %r15d
	subl	8(%r13), %r15d
	je	.LBB165_636
	cmpl	%esi, %ebp
	jl	.LBB165_636
	movl	%r15d, %r14d
	sarl	$9, %r14d
	cmpb	$0, 24(%rsp)
	je	.LBB165_656
	andl	$511, %r14d
	movl	%r14d, %edi
	xorl	$511, %edi
	cmpl	$256, %r14d
	cmovael	%edi, %r14d
	jmp	.LBB165_657
	.p2align	4
.LBB165_656:
	sarl	$31, %r15d
	xorl	%r15d, %r14d
	cmpl	$255, %r14d
	movl	$255, %edi
	cmovgel	%edi, %r14d
.LBB165_657:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_863
	movslq	%ebp, %rdi
	leaq	2(,%rdi,4), %r15
	cmpq	%r10, %r15
	jae	.LBB165_891
	movb	%r14b, (%r11,%r15)
	jmp	.LBB165_637
.LBB165_660:
	testl	%r12d, %r12d
	je	.LBB165_633
	movl	%r12d, %r8d
	sarl	$9, %r8d
	cmpb	$0, 24(%rsp)
	je	.LBB165_663
	andl	$511, %r8d
	movl	%r8d, %edi
	xorl	$511, %edi
	cmpl	$256, %r8d
	cmovael	%edi, %r8d
	jmp	.LBB165_664
.LBB165_663:
	sarl	$31, %r12d
	xorl	%r12d, %r8d
	cmpl	$255, %r8d
	movl	$255, %edi
	cmovgel	%edi, %r8d
.LBB165_664:
	cmpq	%rbx, 16(%rsp)
	jb	.LBB165_863
	cmpl	%r14d, 96(%rsp)
	je	.LBB165_633
	movl	96(%rsp), %edi
	subl	%r14d, %edi
	movslq	%edi, %rbx
	movslq	%r14d, %rdi
	leaq	2(,%rdi,4), %r13
	.p2align	4
.LBB165_667:
	cmpq	%r10, %r13
	jae	.LBB165_880
	movb	%r8b, (%r11,%r13)
	addq	$4, %r13
	decq	%rbx
	jne	.LBB165_667
	jmp	.LBB165_633
.LBB165_669:
	movq	1040(%rsp), %rsi
	testq	%rsi, %rsi
	je	.LBB165_671
	movq	1048(%rsp), %rdi
	shlq	$4, %rsi
	movl	$4, %edx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB165_671:
	movq	1064(%rsp), %rsi
	testq	%rsi, %rsi
	je	.LBB165_673
	movq	1072(%rsp), %rdi
	shlq	$2, %rsi
	movl	$4, %edx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB165_673:
	movb	$1, %al
	cmpq	$0, 64(%r13)
	jne	.LBB165_676
	movl	$168, %edx
	leaq	1040(%rsp), %r14
	movq	%r14, %rdi
	leaq	840(%rsp), %rsi
	movq	memcpy@GOTPCREL(%rip), %r15
	callq	*%r15
.Ltmp1113:
	movl	$168, %edi
	callq	_RNvNtCse3dB2pZFcs1_5alloc5boxed14box_new_uninit
.Ltmp1114:
	movq	%rax, %rbx
	movl	$168, %edx
	movq	%rax, %rdi
	movq	%r14, %rsi
	callq	*%r15
	movq	64(%r13), %rdi
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCse3dB2pZFcs1_5alloc5boxed3BoxNtNtCs9S44gUqPSHd_11gpui_canvas4text13OutlineRasterEEEB1A_
	movq	%rbx, 64(%r13)
	xorl	%eax, %eax
.LBB165_676:
	movl	%eax, 24(%rsp)
	movaps	416(%rsp), %xmm1
	cvttss2si	%xmm1, %ebx
	movss	.LCPI165_8(%rip), %xmm0
	ucomiss	%xmm0, %xmm1
	movl	$2147483647, %ecx
	cmoval	%ecx, %ebx
	ucomiss	%xmm1, %xmm1
	movl	$0, %eax
	cmovpl	%eax, %ebx
	movaps	1008(%rsp), %xmm1
	cvttss2si	%xmm1, %r14d
	ucomiss	%xmm0, %xmm1
	cmoval	%ecx, %r14d
	ucomiss	%xmm1, %xmm1
	cmovpl	%eax, %r14d
	movq	16(%rsp), %rcx
.LBB165_677:
	movq	56(%r13), %rax
	movq	%rcx, %rbp
	addq	%rcx, %rax
	cmpq	$8388608, %rax
	jbe	.LBB165_679
	movq	368(%rsp), %rdi
	callq	_RNvMs7_NtCs9S44gUqPSHd_11gpui_canvas4textNtB5_11RasterCache11clear_cache
	movq	56(%r13), %rax
	addq	%rbp, %rax
.LBB165_679:
	movq	%rax, 56(%r13)
	movq	376(%rsp), %rax
	movq	40(%rax), %r12
	callq	*_RNvCseilXckri75C_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$80, %edi
	movl	$8, %esi
	callq	*_RNvCseilXckri75C_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB165_868
	movq	%rax, %r15
	movq	$1, (%rax)
	movq	$1, 8(%rax)
	movq	%rbp, 16(%rax)
	movq	88(%rsp), %rax
	movq	%rax, 24(%r15)
	movq	%rbp, 32(%r15)
	movq	%r12, 40(%r15)
	movss	140(%rsp), %xmm0
	movss	%xmm0, 48(%r15)
	movq	232(%rsp), %rax
	movw	%ax, 52(%r15)
	movq	296(%rsp), %rax
	movq	%rax, 56(%r15)
	movq	288(%rsp), %rax
	movq	%rax, 64(%r15)
	movl	%ebx, 72(%r15)
	movl	%r14d, 76(%r15)
	movq	%r15, 1040(%rsp)
	movq	40(%r13), %rdi
	movq	48(%r13), %rsi
	leaq	400(%rsp), %rdx
	callq	_RINvYNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateNtNtCsaifZ2emd9Uo_4core4hash11BuildHasher8hash_oneRNtNtCs9S44gUqPSHd_11gpui_canvas4text8GlyphKeyEB1J_
	movq	%rax, %rbx
	cmpq	$0, 24(%r13)
	je	.LBB165_789
.LBB165_681:
	movq	8(%r13), %rax
	movq	16(%r13), %rdx
	movq	%rbx, %rcx
	shrq	$57, %rcx
	movd	%ecx, %xmm0
	punpcklbw	%xmm0, %xmm0
	pshuflw	$0, %xmm0, %xmm0
	pshufd	$68, %xmm0, %xmm0
	xorl	%r8d, %r8d
	xorl	%edi, %edi
	movl	24(%rsp), %ebp
.LBB165_682:
	andq	%rdx, %rbx
	movdqu	(%rax,%rbx), %xmm1
	movdqa	%xmm1, %xmm2
	pcmpeqb	%xmm0, %xmm2
	pmovmskb	%xmm2, %r9d
	testl	%r9d, %r9d
	je	.LBB165_687
.LBB165_683:
	rep		bsfl	%r9d, %r10d
	addq	%rbx, %r10
	andq	%rdx, %r10
	negq	%r10
	leaq	(%r10,%r10,2), %r10
	movq	384(%rsp), %r11
	cmpq	-24(%rax,%r10,8), %r11
	jne	.LBB165_686
	leaq	(%rax,%r10,8), %r10
	movq	232(%rsp), %r11
	cmpw	%r11w, -12(%r10)
	jne	.LBB165_686
	movq	128(%rsp), %r11
	cmpl	%r11d, -16(%r10)
	je	.LBB165_694
.LBB165_686:
	leal	-1(%r9), %r10d
	andw	%r9w, %r10w
	movl	%r10d, %r9d
	jne	.LBB165_683
.LBB165_687:
	cmpq	$1, %r8
	je	.LBB165_690
	pmovmskb	%xmm1, %esi
	testl	%esi, %esi
	je	.LBB165_692
	rep		bsfl	%esi, %esi
	addq	%rbx, %rsi
	andq	%rdx, %rsi
.LBB165_690:
	pcmpeqd	%xmm2, %xmm2
	pcmpeqb	%xmm2, %xmm1
	pmovmskb	%xmm1, %r8d
	testl	%r8d, %r8d
	jne	.LBB165_697
	movl	$1, %r8d
	jmp	.LBB165_693
.LBB165_692:
	xorl	%r8d, %r8d
.LBB165_693:
	addq	%rdi, %rbx
	addq	$16, %rbx
	addq	$16, %rdi
	jmp	.LBB165_682
.LBB165_694:
	movq	-8(%r10), %rax
	movq	%r15, -8(%r10)
	movq	%rax, 1040(%rsp)
	lock		decq	(%rax)
	jne	.LBB165_695
	#MEMBARRIER
	leaq	1040(%rsp), %rdi
	callq	*_RNvMsn_NtNtCse3dB2pZFcs1_5alloc3rcs3arcINtB5_3ArcNtNtCs9S44gUqPSHd_11gpui_canvas4text6RasterE9drop_slowBP_@GOTPCREL(%rip)
	testb	%bpl, %bpl
	je	.LBB165_696
	jmp	.LBB165_700
	.p2align	4
.LBB165_695:
	testb	%bpl, %bpl
	je	.LBB165_696
.LBB165_700:
	leaq	840(%rsp), %rdi
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueNtNtCs9S44gUqPSHd_11gpui_canvas4text13OutlineRasterEBF_
	cmpq	$0, 32(%r13)
	jne	.LBB165_701
	jmp	.LBB165_808
.LBB165_697:
	movzbl	(%rax,%rsi), %edi
	testb	%dil, %dil
	jns	.LBB165_791
.LBB165_698:
	andb	$1, %dil
	leaq	-16(%rsi), %r8
	andq	%rdx, %r8
	movb	%cl, (%rax,%rsi)
	movb	%cl, 16(%rax,%r8)
	movdqu	24(%r13), %xmm0
	movzbl	%dil, %ecx
	movd	%ecx, %xmm1
	shufpd	$2, .LCPI165_9(%rip), %xmm1
	psubq	%xmm1, %xmm0
	movdqu	%xmm0, 24(%r13)
	negq	%rsi
	leaq	(%rsi,%rsi,2), %rcx
	movdqu	400(%rsp), %xmm0
	movdqu	%xmm0, -24(%rax,%rcx,8)
	movq	%r15, -8(%rax,%rcx,8)
	testb	%bpl, %bpl
	jne	.LBB165_700
	.p2align	4
.LBB165_696:
	cmpq	$0, 32(%r13)
	je	.LBB165_808
.LBB165_701:
	movq	40(%r13), %rbx
	movq	48(%r13), %r14
	movq	8(%r13), %r15
	movq	16(%r13), %r12
.LBB165_702:
	movq	%rbx, %rdi
	movq	%r14, %rsi
	leaq	400(%rsp), %rdx
	callq	_RINvYNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateNtNtCsaifZ2emd9Uo_4core4hash11BuildHasher8hash_oneRNtNtCs9S44gUqPSHd_11gpui_canvas4text8GlyphKeyEB1J_
	movq	%rax, %rcx
	shrq	$57, %rcx
	movd	%ecx, %xmm0
	punpcklbw	%xmm0, %xmm0
	pshuflw	$0, %xmm0, %xmm0
	pshufd	$68, %xmm0, %xmm0
	xorl	%ecx, %ecx
.LBB165_703:
	andq	%r12, %rax
	movdqu	(%r15,%rax), %xmm1
	movdqa	%xmm1, %xmm2
	pcmpeqb	%xmm0, %xmm2
	pmovmskb	%xmm2, %edx
	testl	%edx, %edx
	movq	232(%rsp), %rdi
	je	.LBB165_708
.LBB165_704:
	rep		bsfl	%edx, %esi
	addq	%rax, %rsi
	andq	%r12, %rsi
	negq	%rsi
	leaq	(%rsi,%rsi,2), %rsi
	movq	384(%rsp), %r8
	cmpq	-24(%r15,%rsi,8), %r8
	jne	.LBB165_707
	leaq	(%r15,%rsi,8), %rsi
	cmpw	%di, -12(%rsi)
	jne	.LBB165_707
	movq	128(%rsp), %r8
	cmpl	%r8d, -16(%rsi)
	je	.LBB165_710
.LBB165_707:
	leal	-1(%rdx), %esi
	andw	%dx, %si
	movl	%esi, %edx
	jne	.LBB165_704
	.p2align	4
.LBB165_708:
	pcmpeqd	%xmm2, %xmm2
	pcmpeqb	%xmm2, %xmm1
	pmovmskb	%xmm1, %edx
	testl	%edx, %edx
	jne	.LBB165_808
	addq	%rcx, %rax
	addq	$16, %rax
	addq	$16, %rcx
	jmp	.LBB165_703
	.p2align	4
.LBB165_710:
	movq	-8(%rsi), %rax
	lock		incq	(%rax)
	jle	.LBB165_895
	movq	-8(%rsi), %rcx
	movq	%rcx, 312(%rsp)
	movq	104(%rsp), %rax
	movl	272(%rax), %ebx
	xorl	%r14d, %r14d
	movq	%rcx, %rax
	movq	%rcx, 24(%rsp)
	movq	64(%rax), %rcx
	testq	%rcx, %rcx
	jns	.LBB165_30
.LBB165_712:
	movq	%rcx, %rdx
	shrq	%rdx
	andl	$1, %ecx
	orq	%rdx, %rcx
	xorps	%xmm2, %xmm2
	cvtsi2ss	%rcx, %xmm2
	addss	%xmm2, %xmm2
	movq	56(%rax), %rcx
	testq	%rcx, %rcx
	js	.LBB165_31
.LBB165_713:
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rcx, %xmm0
.LBB165_714:
	xorps	%xmm1, %xmm1
	cvtsi2ssl	72(%rax), %xmm1
	unpcklps	%xmm2, %xmm1
	xorps	%xmm2, %xmm2
	cvtsi2ssl	76(%rax), %xmm2
	movq	824(%rsp), %rax
	movss	(%rax), %xmm3
	movaps	1024(%rsp), %xmm5
	movaps	%xmm5, %xmm4
	shufps	$85, %xmm5, %xmm4
	movq	816(%rsp), %rax
	addss	(%rax), %xmm4
	divss	%xmm3, %xmm2
	divss	%xmm3, %xmm0
	movq	832(%rsp), %rax
	addss	(%rax), %xmm5
	subss	%xmm2, %xmm4
	shufps	$0, %xmm3, %xmm3
	divps	%xmm3, %xmm1
	movaps	%xmm5, %xmm2
	unpcklps	%xmm4, %xmm2
	addps	%xmm1, %xmm5
	subps	%xmm1, %xmm2
	shufps	$1, %xmm5, %xmm2
	shufps	$226, %xmm5, %xmm2
	movlps	%xmm2, 144(%rsp)
	movss	%xmm0, 152(%rsp)
	shufps	$85, %xmm1, %xmm1
	movss	%xmm1, 156(%rsp)
	movq	808(%rsp), %rcx
	movq	16(%rcx), %rax
	movq	%rax, 608(%rsp)
	movups	(%rcx), %xmm0
	movaps	%xmm0, 592(%rsp)
	movq	800(%rsp), %rax
	movups	64(%rax), %xmm0
	movaps	%xmm0, 1104(%rsp)
	movdqu	(%rax), %xmm0
	movupd	16(%rax), %xmm1
	movdqu	32(%rax), %xmm2
	movdqu	48(%rax), %xmm3
	movdqa	%xmm3, 1088(%rsp)
	movdqa	%xmm2, 1072(%rsp)
	movapd	%xmm1, 1056(%rsp)
	movdqa	%xmm0, 1040(%rsp)
	movb	$1, %r15b
.Ltmp1119:
	leaq	840(%rsp), %rdi
	movq	104(%rsp), %rsi
	leaq	144(%rsp), %rdx
	leaq	592(%rsp), %rcx
	leaq	1040(%rsp), %r8
	movl	%ebx, %r9d
	callq	_RNvMsc_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB5_6Canvas7prepare
.Ltmp1120:
	movl	840(%rsp), %eax
	movl	844(%rsp), %r12d
	movl	848(%rsp), %ebp
	cmpl	$2, %eax
	je	.LBB165_812
	testb	$1, %al
	je	.LBB165_726
	movq	852(%rsp), %rax
	movq	%rax, 232(%rsp)
	movq	860(%rsp), %r13
	movl	868(%rsp), %eax
	movl	%eax, 16(%rsp)
	movq	%r13, %rcx
	shrq	$32, %rcx
	movq	%r13, %rax
	shrq	$48, %rax
	movzwl	%cx, %ecx
	decq	%rcx
	shrq	$4, %rcx
	movl	%r13d, %edx
	shrl	$4, %edx
	andl	$4095, %edx
	subq	%rdx, %rcx
	incq	%rcx
	decq	%rax
	shrq	$4, %rax
	movl	%r13d, %edx
	shrl	$20, %edx
	subq	%rdx, %rax
	incq	%rax
	imulq	%rcx, %rax
	movq	784(%rsp), %rdi
	addq	%rax, (%rdi)
	movq	496(%rsp), %rax
	movq	(%rax), %rcx
	incq	%rcx
	movq	%rcx, (%rax)
	movq	104(%rsp), %rsi
	movq	128(%rsi), %rdx
	addq	%rcx, %rdx
	movl	$8, %eax
	cmpq	$65536, %rdx
	ja	.LBB165_820
	movq	(%rdi), %rdx
	addq	464(%rsi), %rdx
	cmpq	$4194304, %rdx
	ja	.LBB165_813
	movb	$1, %r15b
	testb	%r14b, %r14b
	jne	.LBB165_771
	movq	24(%rsp), %rdx
	movq	%rdx, 840(%rsp)
	movq	776(%rsp), %rcx
	movq	(%rcx), %rax
	addq	32(%rdx), %rax
	movq	%rax, (%rcx)
	movq	104(%rsp), %r15
	addq	456(%r15), %rax
	cmpq	$33554432, %rax
	ja	.LBB165_827
	movq	272(%r15), %rsi
	cmpq	%rsi, 256(%r15)
	je	.LBB165_730
	movq	320(%rsp), %rdx
	cmpl	$1, (%r15)
	jne	.LBB165_732
.LBB165_723:
	cmpq	%rdx, 8(%r15)
	je	.LBB165_732
	cmpq	$0, 80(%r15)
	jne	.LBB165_733
.Ltmp1123:
	movq	%rdx, %r14
	movl	$1, %esi
	movq	456(%rsp), %rdi
	movq	448(%rsp), %rdx
	xorl	%ecx, %ecx
	callq	*_RINvMs6_NtCsj14fOODu5Wj_9hashbrown3rawINtB6_8RawTableTNtNtCs9S44gUqPSHd_11gpui_canvas4text8GlyphKeymEE14reserve_rehashNCINvNtB8_3map11make_hasherBQ_mNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateE0EBU_@GOTPCREL(%rip)
.Ltmp1124:
	jmp	.LBB165_793
	.p2align	4
.LBB165_726:
	testb	%r14b, %r14b
	movq	504(%rsp), %r15
	movq	520(%rsp), %r12
	movq	72(%rsp), %r13
	jne	.LBB165_729
	movq	24(%rsp), %rax
	lock		decq	(%rax)
	jne	.LBB165_729
	#MEMBARRIER
	leaq	312(%rsp), %rdi
	callq	*_RNvMsn_NtNtCse3dB2pZFcs1_5alloc3rcs3arcINtB5_3ArcNtNtCs9S44gUqPSHd_11gpui_canvas4text6RasterE9drop_slowBP_@GOTPCREL(%rip)
	jmp	.LBB165_729
.LBB165_730:
	leaq	(%rsi,%rsi), %r14
	cmpq	$5, %r14
	movl	$4, %eax
	cmovbq	%rax, %r14
	movq	264(%r15), %rdx
	movl	$8, %r8d
	movl	$8, %r9d
	leaq	1040(%rsp), %rdi
	movq	%r14, %rcx
	callq	_RNvMs8_NtCse3dB2pZFcs1_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs9S44gUqPSHd_11gpui_canvas
	cmpl	$1, 1040(%rsp)
	je	.LBB165_827
	movq	1048(%rsp), %rax
	movq	%rax, 264(%r15)
	movq	%r14, 256(%r15)
	movq	320(%rsp), %rdx
	cmpl	$1, (%r15)
	je	.LBB165_723
.LBB165_732:
	cmpq	$0, 32(%r15)
	je	.LBB165_792
.LBB165_733:
	movzwl	332(%rsp), %ecx
	movl	328(%rsp), %eax
	cmpb	$0, (%r15)
	je	.LBB165_750
	cmpq	%rdx, 8(%r15)
	je	.LBB165_751
	movq	%rdx, 48(%rsp)
	movq	%rcx, 88(%rsp)
	movq	%rax, 128(%rsp)
	movq	96(%r15), %rdi
	movq	104(%r15), %rsi
	leaq	320(%rsp), %rdx
	callq	_RINvYNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateNtNtCsaifZ2emd9Uo_4core4hash11BuildHasher8hash_oneRNtNtCs9S44gUqPSHd_11gpui_canvas4text8GlyphKeyEB1J_
	movq	%rax, %r14
	cmpq	$0, 80(%r15)
	je	.LBB165_795
.LBB165_736:
	movq	64(%r15), %rax
	movq	72(%r15), %rdx
	movq	%r14, %rcx
	shrq	$57, %rcx
	movd	%ecx, %xmm0
	punpcklbw	%xmm0, %xmm0
	pshuflw	$0, %xmm0, %xmm0
	pshufd	$68, %xmm0, %xmm0
	xorl	%r8d, %r8d
	xorl	%edi, %edi
.LBB165_737:
	andq	%rdx, %r14
	movdqu	(%rax,%r14), %xmm1
	movdqa	%xmm1, %xmm2
	pcmpeqb	%xmm0, %xmm2
	pmovmskb	%xmm2, %r9d
	testl	%r9d, %r9d
	movq	128(%rsp), %r11
	je	.LBB165_743
	movq	%rdi, 40(%rsp)
.LBB165_739:
	rep		bsfl	%r9d, %r10d
	movq	%r14, %rdi
	addq	%r14, %r10
	andq	%rdx, %r10
	negq	%r10
	leaq	(%r10,%r10,2), %r10
	movq	48(%rsp), %r14
	cmpq	-24(%rax,%r10,8), %r14
	jne	.LBB165_742
	leaq	(%rax,%r10,8), %r10
	movq	88(%rsp), %r15
	cmpw	-12(%r10), %r15w
	jne	.LBB165_742
	cmpl	-16(%r10), %r11d
	je	.LBB165_786
.LBB165_742:
	leal	-1(%r9), %r10d
	andw	%r9w, %r10w
	movl	%r10d, %r9d
	movq	%rdi, %r14
	movq	40(%rsp), %rdi
	jne	.LBB165_739
.LBB165_743:
	cmpq	$1, %r8
	je	.LBB165_746
	pmovmskb	%xmm1, %esi
	testl	%esi, %esi
	je	.LBB165_748
	rep		bsfl	%esi, %esi
	addq	%r14, %rsi
	andq	%rdx, %rsi
.LBB165_746:
	pcmpeqd	%xmm2, %xmm2
	pcmpeqb	%xmm2, %xmm1
	pmovmskb	%xmm1, %r8d
	testl	%r8d, %r8d
	jne	.LBB165_787
	movl	$1, %r8d
	jmp	.LBB165_749
.LBB165_748:
	xorl	%r8d, %r8d
.LBB165_749:
	addq	%rdi, %r14
	addq	$16, %r14
	addq	$16, %rdi
	jmp	.LBB165_737
.LBB165_750:
	movq	$1, (%r15)
	movq	%rdx, 8(%r15)
.LBB165_751:
	shlq	$16, %rax
	orq	%rcx, %rax
	movq	%rax, 128(%rsp)
	movq	%rax, 1040(%rsp)
	movq	48(%r15), %rdi
	movq	56(%r15), %rsi
	leaq	1040(%rsp), %rdx
	callq	_RINvYNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateNtNtCsaifZ2emd9Uo_4core4hash11BuildHasher8hash_oneRNtNtCs9S44gUqPSHd_11gpui_canvas5image8ImageKeyEB1J_
	movq	%rax, %r14
	cmpq	$0, 32(%r15)
	je	.LBB165_790
.LBB165_752:
	movq	16(%r15), %r8
	movq	24(%r15), %rdx
	movq	%r14, %rcx
	shrq	$57, %rcx
	movd	%ecx, %xmm0
	punpcklbw	%xmm0, %xmm0
	pshuflw	$0, %xmm0, %xmm0
	pshufd	$68, %xmm0, %xmm0
	xorl	%edi, %edi
	xorl	%r15d, %r15d
.LBB165_753:
	andq	%rdx, %r14
	movdqu	(%r8,%r14), %xmm1
	movdqa	%xmm1, %xmm2
	pcmpeqb	%xmm0, %xmm2
	pmovmskb	%xmm2, %r9d
	testl	%r9d, %r9d
	je	.LBB165_756
.LBB165_754:
	rep		bsfl	%r9d, %r10d
	addq	%r14, %r10
	andq	%rdx, %r10
	movq	%r10, %r11
	shlq	$4, %r11
	movq	%r8, %rax
	subq	%r11, %rax
	movq	128(%rsp), %r11
	cmpq	-16(%rax), %r11
	je	.LBB165_763
	leal	-1(%r9), %eax
	andw	%r9w, %ax
	movl	%eax, %r9d
	jne	.LBB165_754
.LBB165_756:
	cmpq	$1, %rdi
	movq	128(%rsp), %r9
	je	.LBB165_759
	pmovmskb	%xmm1, %esi
	testl	%esi, %esi
	je	.LBB165_761
	rep		bsfl	%esi, %esi
	addq	%r14, %rsi
	andq	%rdx, %rsi
.LBB165_759:
	pcmpeqd	%xmm2, %xmm2
	pcmpeqb	%xmm2, %xmm1
	pmovmskb	%xmm1, %eax
	testl	%eax, %eax
	jne	.LBB165_764
	movl	$1, %edi
	jmp	.LBB165_762
.LBB165_761:
	xorl	%edi, %edi
.LBB165_762:
	addq	%r15, %r14
	addq	$16, %r14
	addq	$16, %r15
	jmp	.LBB165_753
.LBB165_763:
	negq	%r10
	jmp	.LBB165_766
.LBB165_764:
	movzbl	(%r8,%rsi), %edi
	testb	%dil, %dil
	jns	.LBB165_794
.LBB165_765:
	andb	$1, %dil
	leaq	-16(%rsi), %rax
	andq	%rdx, %rax
	movb	%cl, (%r8,%rsi)
	movb	%cl, 16(%r8,%rax)
	movq	104(%rsp), %rcx
	movdqu	32(%rcx), %xmm0
	movzbl	%dil, %eax
	movd	%eax, %xmm1
	shufpd	$2, .LCPI165_9(%rip), %xmm1
	psubq	%xmm1, %xmm0
	movdqu	%xmm0, 32(%rcx)
	movq	%rsi, %r10
	negq	%r10
	shlq	$4, %rsi
	negq	%rsi
	movq	%r9, -16(%r8,%rsi)
.LBB165_766:
	shlq	$4, %r10
	movl	%ebx, -8(%r8,%r10)
.LBB165_767:
	movq	104(%rsp), %r14
.LBB165_768:
	movq	24(%rsp), %rax
	movq	%rax, 1040(%rsp)
	movq	272(%r14), %rbx
	cmpq	256(%r14), %rbx
	jne	.LBB165_770
.Ltmp1130:
	movq	768(%rsp), %rdi
	callq	*_RNvMs7_NtCse3dB2pZFcs1_5alloc7raw_vecINtB5_6RawVecINtNtNtB7_3rcs3arc3ArcNtNtCs9S44gUqPSHd_11gpui_canvas4text6RasterEE8grow_oneB1c_@GOTPCREL(%rip)
.Ltmp1131:
.LBB165_770:
	movq	264(%r14), %rax
	movq	24(%rsp), %rcx
	movq	%rcx, (%rax,%rbx,8)
	incq	%rbx
	movq	%rbx, 272(%r14)
	movq	496(%rsp), %rax
	movq	(%rax), %rcx
	xorl	%r15d, %r15d
.LBB165_771:
	cmpq	$1, %rcx
	jne	.LBB165_773
	movq	488(%rsp), %rax
	movl	$1, (%rax)
	movl	%r12d, 4(%rax)
	movl	%ebp, 8(%rax)
	movq	232(%rsp), %rcx
	movq	%rcx, 12(%rax)
	movq	%r13, 20(%rax)
	movl	16(%rsp), %ecx
	movl	%ecx, 28(%rax)
	jmp	.LBB165_785
.LBB165_773:
	xorl	%eax, %eax
	cmpq	$2, %rcx
	sete	%al
	incq	%rax
	movq	104(%rsp), %rcx
	movq	232(%rcx), %rsi
	movq	248(%rcx), %rbx
	movq	%rsi, %rcx
	subq	%rbx, %rcx
	cmpq	%rcx, %rax
	jbe	.LBB165_777
	addq	%rax, %rbx
	jb	.LBB165_811
	leaq	(%rsi,%rsi), %rax
	cmpq	%rbx, %rax
	cmovaq	%rax, %rbx
	cmpq	$5, %rbx
	movl	$4, %eax
	cmovbq	%rax, %rbx
	movq	104(%rsp), %r14
	movq	240(%r14), %rdx
	movl	$4, %r8d
	movl	$32, %r9d
	leaq	1040(%rsp), %rdi
	movq	%rbx, %rcx
	callq	_RNvMs8_NtCse3dB2pZFcs1_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs9S44gUqPSHd_11gpui_canvas
	cmpl	$1, 1040(%rsp)
	je	.LBB165_811
	movq	1048(%rsp), %rax
	movq	%rax, 240(%r14)
	movq	%rbx, 232(%r14)
.LBB165_777:
	movq	488(%rsp), %rax
	movl	28(%rax), %r14d
	testb	$1, (%rax)
	movl	$0, (%rax)
	je	.LBB165_781
	movq	760(%rsp), %rcx
	movq	16(%rcx), %rax
	movq	%rax, 1056(%rsp)
	movdqu	(%rcx), %xmm0
	movdqa	%xmm0, 1040(%rsp)
	movq	480(%rsp), %rax
	movl	(%rax), %eax
	movl	%eax, 128(%rsp)
	movq	104(%rsp), %rax
	movq	248(%rax), %rbx
	cmpq	232(%rax), %rbx
	jne	.LBB165_780
.Ltmp1133:
	movq	360(%rsp), %rdi
	callq	*_RNvMs7_NtCse3dB2pZFcs1_5alloc7raw_vecINtB5_6RawVecNtNtCs9S44gUqPSHd_11gpui_canvas6canvas9PlacementE8grow_oneBQ_@GOTPCREL(%rip)
.Ltmp1134:
.LBB165_780:
	movq	104(%rsp), %rsi
	movq	240(%rsi), %rax
	movq	%rbx, %rcx
	shlq	$5, %rcx
	movq	1056(%rsp), %rdx
	movq	%rdx, 16(%rax,%rcx)
	movdqa	1040(%rsp), %xmm0
	movdqu	%xmm0, (%rax,%rcx)
	movl	128(%rsp), %edx
	movl	%edx, 24(%rax,%rcx)
	movl	%r14d, 28(%rax,%rcx)
	incq	%rbx
	movq	%rbx, 248(%rsi)
	jmp	.LBB165_782
.LBB165_781:
	movq	104(%rsp), %rax
	movq	248(%rax), %rbx
.LBB165_782:
	movq	480(%rsp), %rax
	movl	(%rax), %r14d
	movq	360(%rsp), %rax
	cmpq	(%rax), %rbx
	jne	.LBB165_784
.Ltmp1135:
	movq	360(%rsp), %rdi
	callq	*_RNvMs7_NtCse3dB2pZFcs1_5alloc7raw_vecINtB5_6RawVecNtNtCs9S44gUqPSHd_11gpui_canvas6canvas9PlacementE8grow_oneBQ_@GOTPCREL(%rip)
.Ltmp1136:
.LBB165_784:
	movq	104(%rsp), %rdx
	movq	240(%rdx), %rax
	movq	%rbx, %rcx
	shlq	$5, %rcx
	movl	%r12d, (%rax,%rcx)
	movl	%ebp, 4(%rax,%rcx)
	movq	232(%rsp), %rsi
	movq	%rsi, 8(%rax,%rcx)
	movq	%r13, 16(%rax,%rcx)
	movl	%r14d, 24(%rax,%rcx)
	movl	16(%rsp), %esi
	movl	%esi, 28(%rax,%rcx)
	incq	%rbx
	movq	%rbx, 248(%rdx)
.LBB165_785:
	movq	504(%rsp), %r15
	movq	520(%rsp), %r12
	movq	72(%rsp), %r13
	addq	$12, %r12
	cmpq	792(%rsp), %r12
	jne	.LBB165_2
	jmp	.LBB165_805
.LBB165_786:
	movl	%ebx, -8(%r10)
	jmp	.LBB165_767
.LBB165_787:
	movzbl	(%rax,%rsi), %edi
	testb	%dil, %dil
	jns	.LBB165_796
.LBB165_788:
	andb	$1, %dil
	leaq	-16(%rsi), %r8
	andq	%rdx, %r8
	movb	%cl, (%rax,%rsi)
	movb	%cl, 16(%rax,%r8)
	movq	104(%rsp), %r14
	movdqu	80(%r14), %xmm0
	movzbl	%dil, %ecx
	movd	%ecx, %xmm1
	shufpd	$2, .LCPI165_9(%rip), %xmm1
	psubq	%xmm1, %xmm0
	movdqu	%xmm0, 80(%r14)
	negq	%rsi
	leaq	(%rsi,%rsi,2), %rcx
	movdqu	320(%rsp), %xmm0
	movdqu	%xmm0, -24(%rax,%rcx,8)
	movl	%ebx, -8(%rax,%rcx,8)
	jmp	.LBB165_768
.LBB165_789:
.Ltmp1116:
	movl	$1, %esi
	movq	368(%rsp), %rdi
	movq	752(%rsp), %rdx
	movl	$1, %ecx
	callq	*_RINvMs6_NtCsj14fOODu5Wj_9hashbrown3rawINtB6_8RawTableTNtNtCs9S44gUqPSHd_11gpui_canvas4text8GlyphKeyINtNtNtCse3dB2pZFcs1_5alloc3rcs3arc3ArcNtBS_6RasterEEE14reserve_rehashNCINvNtB8_3map11make_hasherBQ_B1z_NtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateE0EBU_@GOTPCREL(%rip)
.Ltmp1117:
	jmp	.LBB165_681
.LBB165_790:
.Ltmp1127:
	movl	$1, %esi
	movq	472(%rsp), %rdi
	movq	464(%rsp), %rdx
	movl	$1, %ecx
	callq	*_RINvMs6_NtCsj14fOODu5Wj_9hashbrown3rawINtB6_8RawTableTNtNtCs9S44gUqPSHd_11gpui_canvas5image8ImageKeymEE14reserve_rehashNCINvNtB8_3map11make_hasherBQ_mNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateE0EBU_@GOTPCREL(%rip)
.Ltmp1128:
	jmp	.LBB165_752
.LBB165_791:
	movdqa	(%rax), %xmm0
	pmovmskb	%xmm0, %esi
	rep		bsfl	%esi, %esi
	movzbl	(%rax,%rsi), %edi
	jmp	.LBB165_698
.LBB165_792:
.Ltmp1121:
	movq	%rdx, %r14
	movl	$1, %esi
	movq	472(%rsp), %rdi
	movq	464(%rsp), %rdx
	xorl	%ecx, %ecx
	callq	*_RINvMs6_NtCsj14fOODu5Wj_9hashbrown3rawINtB6_8RawTableTNtNtCs9S44gUqPSHd_11gpui_canvas5image8ImageKeymEE14reserve_rehashNCINvNtB8_3map11make_hasherBQ_mNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateE0EBU_@GOTPCREL(%rip)
.Ltmp1122:
.LBB165_793:
	cmpq	$-1, %rax
	movq	%r14, %rdx
	je	.LBB165_733
	jmp	.LBB165_827
.LBB165_794:
	movdqa	(%r8), %xmm0
	pmovmskb	%xmm0, %eax
	rep		bsfl	%eax, %esi
	movzbl	(%r8,%rsi), %edi
	jmp	.LBB165_765
.LBB165_795:
.Ltmp1125:
	movl	$1, %esi
	movq	456(%rsp), %rdi
	movq	448(%rsp), %rdx
	movl	$1, %ecx
	callq	*_RINvMs6_NtCsj14fOODu5Wj_9hashbrown3rawINtB6_8RawTableTNtNtCs9S44gUqPSHd_11gpui_canvas4text8GlyphKeymEE14reserve_rehashNCINvNtB8_3map11make_hasherBQ_mNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateE0EBU_@GOTPCREL(%rip)
.Ltmp1126:
	jmp	.LBB165_736
.LBB165_796:
	movdqa	(%rax), %xmm0
	pmovmskb	%xmm0, %esi
	rep		bsfl	%esi, %esi
	movzbl	(%rax,%rsi), %edi
	jmp	.LBB165_788
.LBB165_797:
.Ltmp1077:
	movl	$1024, %edx
	movl	$4, %ecx
	movl	$16, %r8d
	movq	%rbx, %rdi
	xorl	%esi, %esi
	callq	_RINvNvMs5_NtCse3dB2pZFcs1_5alloc7raw_vecINtB8_11RawVecInnerpE7reserve21do_reserve_and_handleNtNtBa_5alloc6GlobalECs9S44gUqPSHd_11gpui_canvas
.Ltmp1078:
	movq	16(%rbx), %r15
	jmp	.LBB165_410
.LBB165_799:
.Ltmp1065:
	movl	$1024, %edx
	movl	$4, %ecx
	movl	$16, %r8d
	movq	%rbx, %rdi
	xorl	%esi, %esi
	callq	_RINvNvMs5_NtCse3dB2pZFcs1_5alloc7raw_vecINtB8_11RawVecInnerpE7reserve21do_reserve_and_handleNtNtBa_5alloc6GlobalECs9S44gUqPSHd_11gpui_canvas
.Ltmp1066:
	movq	16(%rbx), %r15
	jmp	.LBB165_424
.LBB165_801:
.Ltmp1089:
	movl	$1024, %edx
	movl	$4, %ecx
	movl	$16, %r8d
	movq	%rbx, %rdi
	xorl	%esi, %esi
	callq	_RINvNvMs5_NtCse3dB2pZFcs1_5alloc7raw_vecINtB8_11RawVecInnerpE7reserve21do_reserve_and_handleNtNtBa_5alloc6GlobalECs9S44gUqPSHd_11gpui_canvas
.Ltmp1090:
	movq	16(%rbx), %r15
	jmp	.LBB165_543
.LBB165_803:
.Ltmp1101:
	movl	$1024, %edx
	movl	$4, %ecx
	movl	$16, %r8d
	movq	%rbx, %rdi
	xorl	%esi, %esi
	callq	_RINvNvMs5_NtCse3dB2pZFcs1_5alloc7raw_vecINtB8_11RawVecInnerpE7reserve21do_reserve_and_handleNtNtBa_5alloc6GlobalECs9S44gUqPSHd_11gpui_canvas
.Ltmp1102:
	movq	16(%rbx), %r15
	jmp	.LBB165_622
.LBB165_805:
	movq	304(%rsp), %rax
	movq	24(%rax), %rbx
	movq	80(%rax), %r15
	movq	(%r15), %rdx
	movq	112(%rbx), %rsi
	movq	128(%rbx), %rcx
	movq	%rsi, %rax
	subq	%rcx, %rax
	cmpq	%rax, %rdx
	jbe	.LBB165_831
	movl	$8, %eax
	addq	%rdx, %rcx
	jb	.LBB165_850
	leaq	(%rsi,%rsi), %rax
	cmpq	%rcx, %rax
	cmovaq	%rax, %rcx
	cmpq	$5, %rcx
	movl	$4, %r14d
	cmovaeq	%rcx, %r14
	movq	120(%rbx), %rdx
	leaq	1040(%rsp), %rdi
	movl	$4, %r8d
	movl	$4, %r9d
	movq	%r14, %rcx
	callq	_RNvMs8_NtCse3dB2pZFcs1_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs9S44gUqPSHd_11gpui_canvas
	cmpl	$1, 1040(%rsp)
	jne	.LBB165_830
	movl	$8, %eax
	jmp	.LBB165_851
.LBB165_808:
	leaq	.Lalloc_a7d7769291fb702cd4ca6ef64f027ff9(%rip), %rdi
	leaq	.Lalloc_570f6ebd6663ac75f6c399b554e3e08b(%rip), %rdx
	movl	$22, %esi
	callq	*_RNvNtCsaifZ2emd9Uo_4core6option13expect_failed@GOTPCREL(%rip)
.LBB165_809:
	xorl	%r13d, %r13d
.LBB165_810:
.Ltmp1144:
	movq	%r13, %rdi
	movq	%rbp, %rsi
	callq	*_RNvNtCse3dB2pZFcs1_5alloc7raw_vec12handle_error@GOTPCREL(%rip)
.Ltmp1145:
	jmp	.LBB165_895
.LBB165_811:
	cmpq	$0, 24(%rsp)
	setne	%cl
	movl	$8, %eax
	testb	%r15b, %cl
	jne	.LBB165_814
	jmp	.LBB165_851
.LBB165_812:
	movl	%r12d, %eax
.LBB165_813:
	testb	%r14b, %r14b
	jne	.LBB165_851
.LBB165_814:
	movq	24(%rsp), %rcx
	lock		decq	(%rcx)
	jne	.LBB165_851
	#MEMBARRIER
	leaq	312(%rsp), %rdi
	movl	%eax, %ebx
	callq	*_RNvMsn_NtNtCse3dB2pZFcs1_5alloc3rcs3arcINtB5_3ArcNtNtCs9S44gUqPSHd_11gpui_canvas4text6RasterE9drop_slowBP_@GOTPCREL(%rip)
	movl	%ebx, %eax
	jmp	.LBB165_851
.LBB165_816:
	xorl	%r13d, %r13d
.LBB165_817:
.Ltmp1141:
	movq	%r13, %rdi
	movq	%r14, %rsi
	callq	*_RNvNtCse3dB2pZFcs1_5alloc7raw_vec12handle_error@GOTPCREL(%rip)
.Ltmp1142:
	jmp	.LBB165_895
.LBB165_818:
	movdqa	416(%rsp), %xmm0
	movd	%xmm0, %eax
	pshufd	$85, %xmm0, %xmm0
	movd	%xmm0, %ecx
.LBB165_819:
	movl	%eax, 252(%rsp)
	leaq	392(%rsp), %rax
	jmp	.LBB165_824
.LBB165_820:
	testb	%r14b, %r14b
	je	.LBB165_814
	jmp	.LBB165_851
.LBB165_821:
	xorl	%ebp, %ebp
	jmp	.LBB165_851
.LBB165_822:
	movl	$13, %eax
	xorl	%ebp, %ebp
	jmp	.LBB165_851
.LBB165_823:
	movl	$8, %ecx
	leaq	252(%rsp), %rax
.LBB165_824:
	movl	%ecx, (%rax)
	leaq	840(%rsp), %rdi
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueNtNtCs9S44gUqPSHd_11gpui_canvas4text13OutlineRasterEBF_
	movl	252(%rsp), %eax
	movl	392(%rsp), %ebp
	jmp	.LBB165_851
.LBB165_827:
	movq	24(%rsp), %rax
	lock		decq	(%rax)
	jne	.LBB165_839
	#MEMBARRIER
	leaq	840(%rsp), %rdi
	callq	*_RNvMsn_NtNtCse3dB2pZFcs1_5alloc3rcs3arcINtB5_3ArcNtNtCs9S44gUqPSHd_11gpui_canvas4text6RasterE9drop_slowBP_@GOTPCREL(%rip)
	jmp	.LBB165_839
.LBB165_829:
	movq	16(%rsp), %r12
	movq	%r12, %rsi
	leaq	.Lalloc_459e54686c1c8ae121ba4bc1d61f30b0(%rip), %rcx
	jmp	.LBB165_858
.LBB165_830:
	movq	1048(%rsp), %rax
	movq	%rax, 120(%rbx)
	movq	%r14, 112(%rbx)
	movq	(%r15), %rdx
.LBB165_831:
	cmpq	$1, %rdx
	jbe	.LBB165_837
	movq	176(%rbx), %rsi
	cmpq	%rsi, 160(%rbx)
	je	.LBB165_852
.LBB165_833:
	cmpq	$0, (%r15)
	je	.LBB165_840
	movq	304(%rsp), %rax
	movq	64(%rax), %rax
	movups	64(%rax), %xmm0
	movaps	%xmm0, 1104(%rsp)
	movups	(%rax), %xmm0
	movups	16(%rax), %xmm1
	movdqu	32(%rax), %xmm2
	movdqu	48(%rax), %xmm3
	movdqa	%xmm3, 1088(%rsp)
	movdqa	%xmm2, 1072(%rsp)
	movaps	%xmm1, 1056(%rsp)
	movaps	%xmm0, 1040(%rsp)
	movq	424(%rbx), %rcx
	movq	432(%rbx), %rax
	testq	%rcx, %rcx
	js	.LBB165_841
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rcx, %xmm0
	testq	%rax, %rax
	jns	.LBB165_842
.LBB165_836:
	movq	%rax, %rcx
	shrq	%rcx
	andl	$1, %eax
	orq	%rcx, %rax
	xorps	%xmm1, %xmm1
	cvtsi2ss	%rax, %xmm1
	addss	%xmm1, %xmm1
	jmp	.LBB165_843
.LBB165_837:
	jne	.LBB165_840
	leaq	136(%rbx), %rdi
	movq	152(%rbx), %rsi
	movl	$1, %edx
	movl	$8, %ecx
	movl	$56, %r8d
	callq	_RNvMs5_NtCse3dB2pZFcs1_5alloc7raw_vecNtB5_11RawVecInner11try_reserveCs9S44gUqPSHd_11gpui_canvas
	cmpq	$-1, %rax
	je	.LBB165_833
.LBB165_839:
	movl	$8, %eax
	jmp	.LBB165_850
.LBB165_840:
	movl	$-1, %eax
	jmp	.LBB165_850
.LBB165_841:
	movq	%rcx, %rdx
	shrq	%rdx
	andl	$1, %ecx
	orq	%rdx, %rcx
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rcx, %xmm0
	addss	%xmm0, %xmm0
	testq	%rax, %rax
	js	.LBB165_836
.LBB165_842:
	xorps	%xmm1, %xmm1
	cvtsi2ss	%rax, %xmm1
.LBB165_843:
	addq	$184, %rbx
	movq	$0, 840(%rsp)
	movss	%xmm0, 848(%rsp)
	movss	%xmm1, 852(%rsp)
	movq	304(%rsp), %rax
	movq	112(%rax), %rax
	movl	(%rax), %ecx
	testl	%ecx, %ecx
	je	.LBB165_848
	cmpl	$2, %ecx
	jne	.LBB165_847
	movq	8(%rax), %rax
	movl	(%rax), %ecx
	testl	%ecx, %ecx
	sete	%al
	jmp	.LBB165_849
.LBB165_847:
	movl	4(%rax), %ecx
.LBB165_848:
	xorl	%eax, %eax
.LBB165_849:
	movzbl	%al, %r9d
	leaq	1040(%rsp), %rsi
	leaq	840(%rsp), %rdx
	movq	%rbx, %rdi
	xorl	%r8d, %r8d
	callq	_RNvMs5_NtNtCs9S44gUqPSHd_11gpui_canvas6canvas7columnsNtB5_7Columns5admit
.LBB165_850:
.LBB165_851:
	movl	%ebp, %edx
	addq	$19560, %rsp
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
.LBB165_852:
	.cfi_def_cfa_offset 19616
	leaq	(%rsi,%rsi), %rax
	cmpq	$5, %rax
	movl	$4, %r14d
	cmovaeq	%rax, %r14
	movq	168(%rbx), %rdx
	leaq	1040(%rsp), %rdi
	movl	$8, %r8d
	movl	$32, %r9d
	movq	%r14, %rcx
	callq	_RNvMs8_NtCse3dB2pZFcs1_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs9S44gUqPSHd_11gpui_canvas
	cmpl	$1, 1040(%rsp)
	je	.LBB165_839
	movq	1048(%rsp), %rax
	movq	%rax, 168(%rbx)
	movq	%r14, 160(%rbx)
	jmp	.LBB165_833
.LBB165_854:
	movq	16(%rsp), %r12
	movq	%r12, %rsi
	leaq	.Lalloc_05a7e8a7cf784e88097ffbb1db46698f(%rip), %rcx
	jmp	.LBB165_858
.LBB165_855:
	movq	%rdi, %rbx
	leaq	.Lalloc_4220bf9b203fd8e3fb220ce74576ea59(%rip), %rcx
	jmp	.LBB165_858
.LBB165_856:
	movq	%rax, %rbx
	leaq	.Lalloc_935501dd1369b4b22e261145dd49105b(%rip), %rcx
	jmp	.LBB165_858
.LBB165_857:
	movq	16(%rsp), %r12
	movq	%r12, %rsi
	leaq	.Lalloc_37337545486f23971abd8fd867518f3a(%rip), %rcx
.LBB165_858:
.Ltmp1056:
	movq	%rbx, %rdi
	movq	%r12, %rdx
	callq	*_RNvNtNtCsaifZ2emd9Uo_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.Ltmp1057:
	jmp	.LBB165_895
.LBB165_859:
	movq	16(%rsp), %rbp
	movq	%rbp, %rsi
	leaq	.Lalloc_bf2ea53e580a1168b47e4a8beb6639ce(%rip), %rcx
	jmp	.LBB165_864
.LBB165_860:
	movq	16(%rsp), %rbp
	movq	%rbp, %rsi
	leaq	.Lalloc_fa3a4ef73e5f57e8d8d16825be6ba33d(%rip), %rcx
	jmp	.LBB165_864
.LBB165_861:
	movq	%rdi, %rbx
	leaq	.Lalloc_4220bf9b203fd8e3fb220ce74576ea59(%rip), %rcx
	jmp	.LBB165_864
.LBB165_862:
	movq	%rax, %rbx
	leaq	.Lalloc_935501dd1369b4b22e261145dd49105b(%rip), %rcx
	jmp	.LBB165_864
.LBB165_863:
	movq	16(%rsp), %rbp
	movq	%rbp, %rsi
	leaq	.Lalloc_0998004db76dda667db4f607860d3ddc(%rip), %rcx
.LBB165_864:
.Ltmp1110:
	movq	%rbx, %rdi
	movq	%rbp, %rdx
	callq	*_RNvNtNtCsaifZ2emd9Uo_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.Ltmp1111:
	jmp	.LBB165_895
.LBB165_865:
	movl	1044(%rsp), %eax
	movl	1048(%rsp), %ecx
	jmp	.LBB165_819
.LBB165_866:
	movq	%rcx, %rbx
	leaq	.Lalloc_62bfafa645f1103febc3dfd6da611a13(%rip), %rcx
	jmp	.LBB165_858
.LBB165_867:
	movq	16(%rsp), %r12
	movq	%r12, %rsi
	leaq	.Lalloc_ca9c6a4d06dc288d2522565f8d5b0a42(%rip), %rcx
	jmp	.LBB165_858
.LBB165_868:
.Ltmp1138:
	movl	$8, %edi
	movl	$80, %esi
	callq	*_RNvNtCse3dB2pZFcs1_5alloc5alloc18handle_alloc_error@GOTPCREL(%rip)
.Ltmp1139:
	jmp	.LBB165_895
.LBB165_869:
	movq	%rcx, %rbx
	leaq	.Lalloc_62bfafa645f1103febc3dfd6da611a13(%rip), %rcx
	jmp	.LBB165_864
.LBB165_870:
	movl	$8, %eax
	jmp	.LBB165_819
.LBB165_871:
	movq	%r15, %r13
	leaq	.Lalloc_c40db21dd4278f5c903d8989871dbdb5(%rip), %rdx
	jmp	.LBB165_890
.LBB165_872:
	movq	16(%rsp), %rbp
	movq	%rbp, %rsi
	leaq	.Lalloc_ca9c6a4d06dc288d2522565f8d5b0a42(%rip), %rcx
	jmp	.LBB165_864
.LBB165_873:
	movq	%r15, %r13
.LBB165_889:
	leaq	.Lalloc_876b8c8b90a35043221ea76886b38b1e(%rip), %rdx
	jmp	.LBB165_890
.LBB165_874:
	movq	%r14, %r13
.LBB165_875:
	movq	%r10, %r11
	leaq	.Lalloc_3fe34a28100be6670f1d8d0bf8090d32(%rip), %rdx
	jmp	.LBB165_890
.LBB165_876:
.Ltmp1018:
	leaq	.Lalloc_5dc3956a0cda874765e12e381080742e(%rip), %rdi
	callq	*_RNvNtCsaifZ2emd9Uo_4core4cell22panic_already_borrowed@GOTPCREL(%rip)
.Ltmp1019:
	jmp	.LBB165_895
.LBB165_877:
	movq	%r15, %r13
	leaq	.Lalloc_8ae4c6811881ca251d7c7388b5745df9(%rip), %rdx
	jmp	.LBB165_894
.LBB165_878:
	movq	%r15, %r13
.LBB165_893:
	leaq	.Lalloc_42225d47c2f5989bd26b0e6e6c614e78(%rip), %rdx
	jmp	.LBB165_894
.LBB165_879:
	movq	%r14, %r13
.LBB165_880:
	movq	%r10, %r11
	leaq	.Lalloc_b3bb7f03f45de20f4c0a868a438e5dd8(%rip), %rdx
	jmp	.LBB165_894
.LBB165_881:
	leaq	.Lalloc_a4e9412444175fc2c719efd1596e4458(%rip), %rdx
	movq	%r9, %r11
	jmp	.LBB165_890
.LBB165_882:
	leaq	.Lalloc_a4e9412444175fc2c719efd1596e4458(%rip), %rdx
	movq	%r10, %r11
	jmp	.LBB165_894
.LBB165_883:
	leaq	.Lalloc_5258e0e3bcdab023d1ff7df8bf1850ec(%rip), %rdx
	jmp	.LBB165_890
.LBB165_884:
	leaq	.Lalloc_a4e9412444175fc2c719efd1596e4458(%rip), %rdx
	movq	%r8, %r11
	jmp	.LBB165_890
.LBB165_885:
	leaq	.Lalloc_5258e0e3bcdab023d1ff7df8bf1850ec(%rip), %rdx
	jmp	.LBB165_894
.LBB165_886:
	leaq	.Lalloc_a4e9412444175fc2c719efd1596e4458(%rip), %rdx
	movq	%r9, %r11
	jmp	.LBB165_894
.LBB165_887:
	movq	%r15, %r13
	jmp	.LBB165_875
.LBB165_888:
	leaq	.Lalloc_c40db21dd4278f5c903d8989871dbdb5(%rip), %rdx
.LBB165_890:
.Ltmp1054:
	movq	%r13, %rdi
	movq	%r11, %rsi
	callq	*_RNvNtCsaifZ2emd9Uo_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.Ltmp1055:
	jmp	.LBB165_895
.LBB165_891:
	movq	%r15, %r13
	jmp	.LBB165_880
.LBB165_892:
	leaq	.Lalloc_8ae4c6811881ca251d7c7388b5745df9(%rip), %rdx
.LBB165_894:
.Ltmp1108:
	movq	%r13, %rdi
	movq	%r11, %rsi
	callq	*_RNvNtCsaifZ2emd9Uo_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.Ltmp1109:
.LBB165_895:
	ud2
.LBB165_896:
	leaq	.Lalloc_77891715c05344cf7766531358e5c8a9(%rip), %rdx
	movq	%rbx, %rdi
	callq	*_RNvNtCsaifZ2emd9Uo_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB165_897:
	movq	%rcx, %r13
	leaq	.Lalloc_6658b839511db7aa47975f598d239460(%rip), %rdx
	jmp	.LBB165_890
.LBB165_898:
	movq	%r8, %r13
	movq	%rdx, %r11
	leaq	.Lalloc_0f853d3410a2f84023f9907087aa8467(%rip), %rdx
	jmp	.LBB165_894
.LBB165_899:
	movq	16(%rsp), %rbp
	jmp	.LBB165_810
.LBB165_901:
	leaq	.Lalloc_7f896b07df3e545f78e4efd492750864(%rip), %rdx
	jmp	.LBB165_890
.LBB165_907:
	leaq	.Lalloc_223040ecc938a75af28a008257f4d930(%rip), %rdx
	jmp	.LBB165_894
.LBB165_900:
	movq	%rcx, %r13
	leaq	.Lalloc_2dc13b2015ee665c82c77c81914f7e50(%rip), %rdx
	jmp	.LBB165_890
.LBB165_903:
	movq	%rsi, %r13
	movq	%rax, %r11
	leaq	.Lalloc_e4244704d442b80b0e95fa5522e040dc(%rip), %rdx
	jmp	.LBB165_894
.LBB165_905:
	movq	%r8, %r13
	movq	%rdx, %r11
	leaq	.Lalloc_13f1a15688f716353c95ec47061d94d1(%rip), %rdx
	jmp	.LBB165_894
.LBB165_911:
.Ltmp1118:
	movq	%rax, %rbx
	lock		decq	(%r15)
	jne	.LBB165_913
	#MEMBARRIER
	leaq	1040(%rsp), %rdi
	callq	*_RNvMsn_NtNtCse3dB2pZFcs1_5alloc3rcs3arcINtB5_3ArcNtNtCs9S44gUqPSHd_11gpui_canvas4text6RasterE9drop_slowBP_@GOTPCREL(%rip)
.LBB165_913:
	movl	24(%rsp), %ebp
	jmp	.LBB165_940
.LBB165_914:
.Ltmp1129:
	movq	%rax, %rbx
	movq	24(%rsp), %rax
	lock		decq	(%rax)
	jne	.LBB165_942
	#MEMBARRIER
	leaq	840(%rsp), %rdi
	jmp	.LBB165_926
.LBB165_916:
.Ltmp1115:
	movq	%rax, %rbx
	leaq	1040(%rsp), %rdi
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueNtNtCs9S44gUqPSHd_11gpui_canvas4text13OutlineRasterEBF_
	xorl	%ebp, %ebp
	jmp	.LBB165_938
.LBB165_917:
.Ltmp1132:
	movq	%rax, %rbx
	movq	24(%rsp), %rax
	lock		decq	(%rax)
	jne	.LBB165_942
	#MEMBARRIER
	leaq	1040(%rsp), %rdi
	jmp	.LBB165_926
.LBB165_919:
.Ltmp1017:
	movq	%rax, %rbx
	jmp	.LBB165_937
.LBB165_920:
.Ltmp1107:
	jmp	.LBB165_930
.LBB165_921:
.Ltmp1053:
	jmp	.LBB165_935
.LBB165_922:
.Ltmp1014:
	jmp	.LBB165_946
.LBB165_923:
.Ltmp1137:
	movq	%rax, %rbx
	cmpq	$0, 24(%rsp)
	setne	%al
	testb	%r15b, %al
	je	.LBB165_942
	movq	24(%rsp), %rax
	lock		decq	(%rax)
	jne	.LBB165_942
	#MEMBARRIER
	leaq	312(%rsp), %rdi
.LBB165_926:
	callq	*_RNvMsn_NtNtCse3dB2pZFcs1_5alloc3rcs3arcINtB5_3ArcNtNtCs9S44gUqPSHd_11gpui_canvas4text6RasterE9drop_slowBP_@GOTPCREL(%rip)
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB165_927:
.Ltmp1020:
	movq	%rax, %rbx
	jmp	.LBB165_937
.LBB165_928:
.Ltmp1140:
	movq	%rax, %rbx
	movq	%rbp, %rsi
	testq	%rbp, %rbp
	movl	24(%rsp), %ebp
	jne	.LBB165_939
	jmp	.LBB165_940
.LBB165_929:
.Ltmp1112:
.LBB165_930:
	movq	%rax, %rbx
	movq	1040(%rsp), %rsi
	testq	%rsi, %rsi
	je	.LBB165_932
	movq	1048(%rsp), %rdi
	shlq	$4, %rsi
	movl	$4, %edx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB165_932:
	movq	1064(%rsp), %rsi
	testq	%rsi, %rsi
	je	.LBB165_936
	movq	1072(%rsp), %rdi
	shlq	$2, %rsi
	movl	$4, %edx
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	jmp	.LBB165_936
.LBB165_934:
.Ltmp1058:
.LBB165_935:
	movq	%rax, %rbx
.LBB165_936:
	incq	656(%rsp)
.LBB165_937:
	movb	$1, %bpl
.LBB165_938:
	movq	16(%rsp), %rsi
	testq	%rsi, %rsi
	je	.LBB165_940
.LBB165_939:
	movl	$1, %edx
	movq	88(%rsp), %rdi
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB165_940:
	testb	%bpl, %bpl
	jne	.LBB165_941
	jmp	.LBB165_942
.LBB165_943:
.Ltmp1143:
	movq	%rax, %rbx
	testq	%r15, %r15
	jne	.LBB165_944
.LBB165_941:
	leaq	840(%rsp), %rdi
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueNtNtCs9S44gUqPSHd_11gpui_canvas4text13OutlineRasterEBF_
.LBB165_942:
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB165_944:
	shlq	$3, %r15
	movl	$4, %edx
	movq	%rbp, %rdi
	movq	%r15, %rsi
	callq	*_RNvCseilXckri75C_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	leaq	840(%rsp), %rdi
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueNtNtCs9S44gUqPSHd_11gpui_canvas4text13OutlineRasterEBF_
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB165_945:
.Ltmp1146:
.LBB165_946:
	movq	%rax, %rbx
	leaq	840(%rsp), %rdi
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueNtNtCs9S44gUqPSHd_11gpui_canvas4text13OutlineRasterEBF_
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.Lfunc_end165:
