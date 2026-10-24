_RNvMsc_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB5_6Canvas18draw_image_working:
.Lfunc_begin49:
	.cfi_startproc
	.cfi_personality 155, DW.ref._RNvCseilXckri75C_7___rustc19rust_eh_personality
	.cfi_lsda 27, .Lexception49
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
	subq	$216, %rsp
	.cfi_def_cfa_offset 272
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movl	%r9d, %ebx
	movq	%rcx, %r13
	movq	%rdx, %r15
	movd	%xmm0, %eax
	leal	-1(%rax), %ecx
	cmpl	$8388607, %ecx
	setb	%cl
	movl	%eax, %edx
	andl	$2147483647, %edx
	sete	%r9b
	orb	%cl, %r9b
	testl	%eax, %eax
	setns	%al
	addl	$-8388608, %edx
	cmpl	$2130706432, %edx
	setb	%cl
	andb	%al, %cl
	orb	%r9b, %cl
	cmpb	$1, %cl
	jne	.LBB391_10
	movd	%xmm0, 96(%rsp)
	movq	%rsi, 88(%rsp)
	movq	%rdi, 112(%rsp)
	movq	280(%rdi), %r12
	leaq	32(%rsp), %rdi
	movq	%r12, %rsi
	movq	%r8, %rdx
	callq	_RNvMs5_NtNtCs9S44gUqPSHd_11gpui_canvas6canvas5clipsNtB7_6Canvas12resolve_clip
	movl	36(%rsp), %r14d
	movl	40(%rsp), %ebp
	cmpl	$1, 32(%rsp)
	je	.LBB391_11
	movq	44(%rsp), %rax
	movq	%rax, 24(%rsp)
	movb	$1, %al
	movl	%eax, 12(%rsp)
	testq	%r12, %r12
	je	.LBB391_13
	movq	88(%rsp), %rax
	movq	(%rax), %rax
	movq	40(%rax), %rax
	movq	%rax, 32(%rsp)
	cmpq	$0, 48(%r12)
	je	.LBB391_12
	movq	%rax, 16(%rsp)
	movq	56(%r12), %rdi
	movq	64(%r12), %rsi
	leaq	32(%rsp), %rdx
	callq	_RINvYNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateNtNtCsaifZ2emd9Uo_4core4hash11BuildHasher8hash_oneRNtNtCs9S44gUqPSHd_11gpui_canvas5image8ImageKeyEB1J_
	movq	%rax, %rsi
	shrq	$57, %rsi
	movq	24(%r12), %rcx
	movq	32(%r12), %rdx
	movd	%esi, %xmm0
	punpcklbw	%xmm0, %xmm0
	pshuflw	$0, %xmm0, %xmm0
	pshufd	$68, %xmm0, %xmm0
	xorl	%esi, %esi
	pcmpeqd	%xmm1, %xmm1
	movq	16(%rsp), %r10
.LBB391_5:
	andq	%rdx, %rax
	movdqu	(%rcx,%rax), %xmm2
	movdqa	%xmm2, %xmm3
	pcmpeqb	%xmm0, %xmm3
	pmovmskb	%xmm3, %edi
	testl	%edi, %edi
	je	.LBB391_8
.LBB391_6:
	rep		bsfl	%edi, %r9d
	addq	%rax, %r9
	andq	%rdx, %r9
	shlq	$4, %r9
	movq	%rcx, %r8
	subq	%r9, %r8
	cmpq	-16(%r8), %r10
	je	.LBB391_14
	leal	-1(%rdi), %r8d
	andw	%di, %r8w
	movl	%r8d, %edi
	jne	.LBB391_6
.LBB391_8:
	pcmpeqb	%xmm1, %xmm2
	pmovmskb	%xmm2, %edi
	testl	%edi, %edi
	jne	.LBB391_12
	addq	%rsi, %rax
	addq	$16, %rax
	addq	$16, %rsi
	jmp	.LBB391_5
.LBB391_10:
	movl	$1, %r14d
.LBB391_11:
	movl	%r14d, %eax
	movl	%ebp, %edx
	addq	$216, %rsp
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
.LBB391_12:
	.cfi_def_cfa_offset 272
	movl	16(%r12), %eax
	movl	%eax, 16(%rsp)
	jmp	.LBB391_15
.LBB391_13:
	movl	$0, 16(%rsp)
	jmp	.LBB391_15
.LBB391_14:
	movl	-8(%r8), %eax
	movl	%eax, 16(%rsp)
	movl	$0, 12(%rsp)
.LBB391_15:
	leaq	32(%rsp), %rdi
	movq	%r13, %rsi
	callq	_RNvMNtCs9S44gUqPSHd_11gpui_canvas6canvasNtB2_7Mapping3new
	movl	40(%rsp), %eax
	cmpl	$1, 32(%rsp)
	jne	.LBB391_17
	movl	36(%rsp), %r14d
	movl	%eax, %ebp
	jmp	.LBB391_11
.LBB391_17:
	xorb	$1, %bl
	movzbl	%bl, %r9d
	shll	$29, %r9d
	orl	16(%rsp), %r9d
	orl	$1073741824, %r9d
	movups	44(%rsp), %xmm0
	movups	60(%rsp), %xmm1
	movdqu	72(%rsp), %xmm2
	movdqu	%xmm2, 184(%rsp)
	movups	%xmm1, 172(%rsp)
	movups	%xmm0, 156(%rsp)
	movl	%r14d, 136(%rsp)
	movl	%ebp, 140(%rsp)
	movq	24(%rsp), %rcx
	movq	%rcx, 144(%rsp)
	movl	%eax, 152(%rsp)
	movss	96(%rsp), %xmm0
	movss	%xmm0, 200(%rsp)
	movq	$0, 204(%rsp)
	movl	$1065353216, 212(%rsp)
	leaq	32(%rsp), %rdi
	leaq	136(%rsp), %r8
	movq	112(%rsp), %rsi
	movq	%r15, %rdx
	movq	%r13, %rcx
	callq	_RNvMsc_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB5_6Canvas7prepare
	movl	32(%rsp), %eax
	movl	36(%rsp), %r14d
	movl	40(%rsp), %ebp
	cmpl	$2, %eax
	je	.LBB391_11
	cmpl	$1, %eax
	jne	.LBB391_60
	movq	52(%rsp), %r15
	movups	44(%rsp), %xmm0
	movl	60(%rsp), %esi
	cmpb	$0, 12(%rsp)
	je	.LBB391_22
	testq	%r12, %r12
	je	.LBB391_33
	movq	80(%r12), %rax
	jmp	.LBB391_34
.LBB391_22:
	movl	%esi, 24(%rsp)
	xorl	%r13d, %r13d
.LBB391_23:
	movaps	%xmm0, 96(%rsp)
	movq	112(%rsp), %r12
	movq	424(%r12), %rcx
	movq	432(%r12), %rax
	testq	%rcx, %rcx
	js	.LBB391_25
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rcx, %xmm0
	jmp	.LBB391_26
.LBB391_25:
	movq	%rcx, %rdx
	shrq	%rdx
	andl	$1, %ecx
	orq	%rdx, %rcx
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rcx, %xmm0
	addss	%xmm0, %xmm0
.LBB391_26:
	leaq	184(%r12), %rdi
	testq	%rax, %rax
	js	.LBB391_28
	xorps	%xmm1, %xmm1
	cvtsi2ss	%rax, %xmm1
	jmp	.LBB391_29
.LBB391_28:
	movq	%rax, %rcx
	shrq	%rcx
	andl	$1, %eax
	orq	%rcx, %rax
	xorps	%xmm1, %xmm1
	cvtsi2ss	%rax, %xmm1
	addss	%xmm1, %xmm1
.LBB391_29:
	movq	$0, 32(%rsp)
	movss	%xmm0, 40(%rsp)
	movss	%xmm1, 44(%rsp)
	leaq	136(%rsp), %rsi
	leaq	32(%rsp), %rdx
	xorl	%ecx, %ecx
	movl	$1, %r8d
	xorl	%r9d, %r9d
	callq	_RNvMs5_NtNtCs9S44gUqPSHd_11gpui_canvas6canvas7columnsNtB5_7Columns5admit
	cmpl	$-1, %eax
	jne	.LBB391_30
	movq	%r12, %rdi
	movq	%r15, %rsi
	callq	_RNvMsc_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB5_6Canvas5admit
	cmpl	$-1, %eax
	je	.LBB391_43
.LBB391_30:
	movl	%eax, %ebx
	jmp	.LBB391_40
.LBB391_33:
	xorl	%eax, %eax
.LBB391_34:
	movq	88(%rsp), %rcx
	movq	(%rcx), %rdx
	movzbl	16(%rdx), %ecx
	shlb	$2, %cl
	movq	32(%rdx), %rdx
	shlq	%cl, %rdx
	addq	%rax, %rdx
	setb	%al
	cmpq	$67108865, %rdx
	setae	%cl
	orb	%al, %cl
	movl	$8, %ebx
	je	.LBB391_36
	xorl	%r13d, %r13d
	jmp	.LBB391_40
.LBB391_36:
	movl	%esi, 24(%rsp)
	movaps	%xmm0, 96(%rsp)
	xorl	%r13d, %r13d
	testq	%r12, %r12
	jne	.LBB391_39
.Ltmp1864:
	callq	_RNvXsi_NtCse3dB2pZFcs1_5alloc5boxedINtB5_3BoxNtNtCs9S44gUqPSHd_11gpui_canvas6canvas14ImageResourcesENtNtCsaifZ2emd9Uo_4core7default7Default7defaultBL_
.Ltmp1865:
	movq	%rax, %r12
	xorl	%edi, %edi
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCse3dB2pZFcs1_5alloc5boxed3BoxNtNtCs9S44gUqPSHd_11gpui_canvas6canvas14ImageResourcesEEEB1A_
	movq	%r12, %r13
.LBB391_39:
	movq	16(%r12), %rsi
	movl	$1, %edx
	movl	$8, %ecx
	movl	$8, %r8d
	movq	%r12, %rdi
	callq	_RNvMs5_NtCse3dB2pZFcs1_5alloc7raw_vecNtB5_11RawVecInner11try_reserveCs9S44gUqPSHd_11gpui_canvas
	cmpq	$-1, %rax
	je	.LBB391_41
.LBB391_40:
	movq	%r13, %rdi
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCse3dB2pZFcs1_5alloc5boxed3BoxNtNtCs9S44gUqPSHd_11gpui_canvas6canvas14ImageResourcesEEEB1A_
	xorl	%ebp, %ebp
	movl	%ebx, %r14d
	jmp	.LBB391_11
.LBB391_41:
	cmpq	$0, 40(%r12)
	je	.LBB391_61
	movaps	96(%rsp), %xmm0
	jmp	.LBB391_23
.LBB391_43:
	testq	%r13, %r13
	je	.LBB391_45
	movq	280(%r12), %rdi
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCse3dB2pZFcs1_5alloc5boxed3BoxNtNtCs9S44gUqPSHd_11gpui_canvas6canvas14ImageResourcesEEEB1A_
	movq	%r13, 280(%r12)
.LBB391_45:
	cmpb	$0, 12(%rsp)
	je	.LBB391_51
	movq	280(%r12), %rbx
	testq	%rbx, %rbx
	je	.LBB391_63
	movq	88(%rsp), %rax
	movq	(%rax), %r15
	lock		incq	(%r15)
	jle	.LBB391_64
.Ltmp1869:
	movq	%rbx, %rdi
	movq	%r15, %rsi
	callq	_RNvMsG_NtCse3dB2pZFcs1_5alloc3vecINtB5_3VecNtNtCs9S44gUqPSHd_11gpui_canvas5image5ImageE8push_mutBJ_
.Ltmp1870:
	movq	40(%r15), %rsi
	leaq	24(%rbx), %rdi
.Ltmp1871:
	movl	16(%rsp), %edx
	callq	_RNvMs1_NtCsj14fOODu5Wj_9hashbrown3mapINtB5_7HashMapNtNtCs9S44gUqPSHd_11gpui_canvas5image8ImageKeymNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateE6insertBR_
.Ltmp1872:
	movzbl	16(%r15), %ecx
	shlb	$2, %cl
	movq	32(%r15), %rax
	shlq	%cl, %rax
	addq	%rax, 80(%rbx)
.LBB391_51:
	movq	424(%r12), %rcx
	movq	432(%r12), %rax
	testq	%rcx, %rcx
	js	.LBB391_53
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rcx, %xmm0
	jmp	.LBB391_54
.LBB391_53:
	movq	%rcx, %rdx
	shrq	%rdx
	andl	$1, %ecx
	orq	%rdx, %rcx
	xorps	%xmm0, %xmm0
	cvtsi2ss	%rcx, %xmm0
	addss	%xmm0, %xmm0
.LBB391_54:
	testq	%rax, %rax
	js	.LBB391_56
	xorps	%xmm1, %xmm1
	cvtsi2ss	%rax, %xmm1
	jmp	.LBB391_57
.LBB391_56:
	movq	%rax, %rcx
	shrq	%rcx
	andl	$1, %eax
	orq	%rcx, %rax
	xorps	%xmm1, %xmm1
	cvtsi2ss	%rax, %xmm1
	addss	%xmm1, %xmm1
.LBB391_57:
	movq	$0, 120(%rsp)
	movss	%xmm0, 128(%rsp)
	movss	%xmm1, 132(%rsp)
	movl	%r14d, 32(%rsp)
	movl	%ebp, 36(%rsp)
	movaps	96(%rsp), %xmm0
	movups	%xmm0, 40(%rsp)
	movl	24(%rsp), %eax
	movl	%eax, 56(%rsp)
.Ltmp1873:
	leaq	136(%rsp), %rsi
	leaq	32(%rsp), %rdx
	leaq	120(%rsp), %rcx
	movq	%r12, %rdi
	xorl	%r8d, %r8d
	callq	_RNvMs2_NtCs9S44gUqPSHd_11gpui_canvas6canvasNtB5_11DisplayList13append_inline
.Ltmp1874:
	movb	$1, 480(%r12)
	testq	%r13, %r13
	jne	.LBB391_60
	xorl	%edi, %edi
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCse3dB2pZFcs1_5alloc5boxed3BoxNtNtCs9S44gUqPSHd_11gpui_canvas6canvas14ImageResourcesEEEB1A_
.LBB391_60:
	movl	$-1, %r14d
	jmp	.LBB391_11
.LBB391_61:
	leaq	24(%r12), %rdi
	addq	$56, %r12
.Ltmp1866:
	movl	$1, %esi
	movq	%r12, %rdx
	xorl	%ecx, %ecx
	callq	*_RINvMs6_NtCsj14fOODu5Wj_9hashbrown3rawINtB6_8RawTableTNtNtCs9S44gUqPSHd_11gpui_canvas5image8ImageKeymEE14reserve_rehashNCINvNtB8_3map11make_hasherBQ_mNtNtNtCsgiBO0YArCeQ_3std4hash6random11RandomStateE0EBU_@GOTPCREL(%rip)
.Ltmp1867:
	cmpq	$-1, %rax
	movaps	96(%rsp), %xmm0
	jne	.LBB391_40
	jmp	.LBB391_23
.LBB391_63:
.Ltmp1875:
	leaq	.Lalloc_3a49d62948393da86ee41961921e8e88(%rip), %rdi
	callq	*_RNvNtCsaifZ2emd9Uo_4core6option13unwrap_failed@GOTPCREL(%rip)
.Ltmp1876:
.LBB391_64:
	ud2
.LBB391_65:
.Ltmp1868:
	movq	%r13, %rdi
	movq	%rax, %rbx
	jmp	.LBB391_68
.LBB391_66:
.Ltmp1877:
	movq	%rax, %rbx
	testq	%r13, %r13
	jne	.LBB391_69
	xorl	%edi, %edi
.LBB391_68:
	callq	_RINvNtCsaifZ2emd9Uo_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCse3dB2pZFcs1_5alloc5boxed3BoxNtNtCs9S44gUqPSHd_11gpui_canvas6canvas14ImageResourcesEEEB1A_
.LBB391_69:
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.Lfunc_end391:
