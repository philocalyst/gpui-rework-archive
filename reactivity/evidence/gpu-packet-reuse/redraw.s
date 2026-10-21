	.section	.text._RNvMs2_NtCskPEgommB4tQ_8gpui_gpu8rendererNtB5_8Renderer6redraw,"ax",@progbits
	.globl	_RNvMs2_NtCskPEgommB4tQ_8gpui_gpu8rendererNtB5_8Renderer6redraw
	.p2align	4
	.type	_RNvMs2_NtCskPEgommB4tQ_8gpui_gpu8rendererNtB5_8Renderer6redraw,@function
_RNvMs2_NtCskPEgommB4tQ_8gpui_gpu8rendererNtB5_8Renderer6redraw:
	.cfi_startproc
	movq	%rdi, %rax
	cmpq	$0, 840(%rsi)
	je	.LBB83_1
	movq	32(%rdx), %rdi
	movl	$3, %ecx
	cmpq	848(%rsi), %rdi
	jne	.LBB83_10
	movl	56(%rdx), %edi
	cmpl	856(%rsi), %edi
	jne	.LBB83_10
	cmpl	$76, %edi
	jne	.LBB83_6
	movq	60(%rdx), %xmm0
	movq	860(%rsi), %xmm1
	pcmpeqd	%xmm0, %xmm1
	pshufd	$80, %xmm1, %xmm0
	movmskpd	%xmm0, %edi
	cmpl	$3, %edi
	jne	.LBB83_10
.LBB83_6:
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	pushq	%rax
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	%rax, %rbx
	leaq	840(%rsi), %rax
	movq	%rsi, %rdi
	movq	%rsi, %r14
	movq	%rdx, %rsi
	movq	%rax, %rdx
	callq	_RNvMs2_NtCskPEgommB4tQ_8gpui_gpu8rendererNtB5_8Renderer6submit
	movq	%rax, %rcx
	movq	352(%r14), %rdx
	movq	832(%r14), %rax
	incq	%rdx
	movq	$-1, %rsi
	cmovneq	%rdx, %rsi
	movq	%rsi, 352(%r14)
	movb	$1, 544(%r14)
	movq	$0, 440(%r14)
	movq	$0, 480(%r14)
	xorpd	%xmm0, %xmm0
	movupd	%xmm0, 360(%r14)
	movq	$0, 376(%r14)
	testq	%rax, %rax
	je	.LBB83_8
	movq	$0, 96(%rax)
.LBB83_8:
	movq	%rbx, %rax
	movq	$1, 8(%rbx)
	movl	$16, %edx
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	.cfi_restore %rbx
	.cfi_restore %r14
	jmp	.LBB83_9
.LBB83_1:
	movl	$8, %edx
	xorl	%ecx, %ecx
.LBB83_9:
	movq	%rcx, (%rax,%rdx)
	movl	$-1, %ecx
.LBB83_10:
	movl	%ecx, (%rax)
	retq
.Lfunc_end83:
	.size	_RNvMs2_NtCskPEgommB4tQ_8gpui_gpu8rendererNtB5_8Renderer6redraw, .Lfunc_end83-_RNvMs2_NtCskPEgommB4tQ_8gpui_gpu8rendererNtB5_8Renderer6redraw
	.cfi_endproc
