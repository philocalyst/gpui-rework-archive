_RINvMNtCsaifZ2emd9Uo_4core6optionINtB3_6OptionNtNtNtCs9S44gUqPSHd_11gpui_canvas6canvas5clips9ClipChainE6map_orIBw_NtNtCsdlEgFZ12e44_20gpui_reactivity_core8geometry4RectENCNvMs5_BK_NtBM_6Canvas11create_clips2_0EBO_:
	.cfi_startproc
	testq	%rsi, %rsi
	je	.LBB1_5
	movq	16(%rsi), %rcx
	movl	%edx, %eax
	cmpq	%rax, %rcx
	jbe	.LBB1_6
	movq	8(%rsi), %rcx
	imulq	$104, %rax, %rax
	movd	80(%rcx,%rax), %xmm0
	movd	%xmm0, %esi
	addl	%esi, %esi
	xorl	%edx, %edx
	cmpl	$-16777217, %esi
	ja	.LBB1_4
	addq	%rax, %rcx
	movd	%xmm0, 4(%rdi)
	movq	84(%rcx), %rax
	movq	%rax, 8(%rdi)
	movl	92(%rcx), %eax
	movl	%eax, 16(%rdi)
	movl	$1, %edx
.LBB1_4:
	movl	%edx, (%rdi)
	retq
.LBB1_5:
	movl	16(%rcx), %eax
	movl	%eax, 16(%rdi)
	movups	(%rcx), %xmm0
	movups	%xmm0, (%rdi)
	retq
.LBB1_6:
	pushq	%rax
	.cfi_def_cfa_offset 16
	leaq	.Lalloc_0c705e1d716ee76a4b99c7e5fea8c134(%rip), %rdx
	movq	%rax, %rdi
	movq	%rcx, %rsi
	callq	*_RNvNtCsaifZ2emd9Uo_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.Lfunc_end1:
