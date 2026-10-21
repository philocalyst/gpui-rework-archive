	.section	.text._RNvMs2_NtCskPEgommB4tQ_8gpui_gpu8rendererNtB5_8Renderer6submit,"ax",@progbits
	.p2align	4
	.type	_RNvMs2_NtCskPEgommB4tQ_8gpui_gpu8rendererNtB5_8Renderer6submit,@function
_RNvMs2_NtCskPEgommB4tQ_8gpui_gpu8rendererNtB5_8Renderer6submit:
.Lfunc_begin45:
	.cfi_startproc
	.cfi_personality 155, DW.ref.rust_eh_personality
	.cfi_lsda 27, .Lexception45
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r12
	.cfi_def_cfa_offset 40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	subq	$1344, %rsp
	.cfi_def_cfa_offset 1392
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%rdx, %r14
	movq	%rsi, %r12
	movq	%rdi, %rbx
	leaq	552(%rdi), %rsi
	leaq	.Lanon.0c40a24c2d9fab0ced350737d2089aa2.36(%rip), %rdx
	leaq	224(%rsp), %r15
	movq	%r15, %rdi
	callq	*_RNvMNtNtCs8Uo9gldckSB_4wgpu3api6deviceNtB2_6Device22create_command_encoder@GOTPCREL(%rip)
	xorps	%xmm0, %xmm0
	movups	%xmm0, 192(%rsp)
	movups	%xmm0, 208(%rsp)
	movl	$0, 8(%rsp)
	movb	$0, 16(%rsp)
	movups	185(%rsp), %xmm0
	movups	%xmm0, 17(%rsp)
	movups	201(%rsp), %xmm0
	movups	%xmm0, 33(%rsp)
	movq	216(%rsp), %rax
	movq	%rax, 48(%rsp)
	movl	$0, 56(%rsp)
	movq	%r12, 64(%rsp)
	movq	$0, 72(%rsp)
	leaq	.Lanon.0c40a24c2d9fab0ced350737d2089aa2.35(%rip), %rax
	movq	%rax, 152(%rsp)
	movq	$10, 160(%rsp)
	leaq	8(%rsp), %r12
	movq	%r12, 136(%rsp)
	movq	$1, 144(%rsp)
	movl	$-1, 112(%rsp)
	movl	$2, 80(%rsp)
	movq	$0, 168(%rsp)
	movl	$0, 176(%rsp)
.Ltmp619:
	leaq	256(%rsp), %rdi
	leaq	80(%rsp), %rdx
	movq	%r15, %rsi
	callq	*_RNvMNtNtCs8Uo9gldckSB_4wgpu3api15command_encoderNtB2_14CommandEncoder17begin_render_pass@GOTPCREL(%rip)
.Ltmp620:
	leaq	568(%rbx), %rsi
.Ltmp621:
	leaq	256(%rsp), %rdi
	callq	*_RNvMNtNtCs8Uo9gldckSB_4wgpu3api11render_passNtB2_10RenderPass12set_pipeline@GOTPCREL(%rip)
.Ltmp622:
.Ltmp623:
	leaq	256(%rsp), %rdi
	movl	$4, %ecx
	xorl	%esi, %esi
	movq	%r14, %rdx
	xorl	%r8d, %r8d
	callq	*_RNvXsO_NtNtCs8Uo9gldckSB_4wgpu7backend9wgpu_coreNtB5_14CoreRenderPassNtNtB9_8dispatch19RenderPassInterface14set_bind_group@GOTPCREL(%rip)
.Ltmp624:
.Ltmp625:
	leaq	256(%rsp), %rdi
	xorl	%esi, %esi
	movl	$3, %edx
	xorl	%ecx, %ecx
	movl	$1, %r8d
	callq	*_RNvMNtNtCs8Uo9gldckSB_4wgpu3api11render_passNtB2_10RenderPass4draw@GOTPCREL(%rip)
.Ltmp626:
.Ltmp630:
	leaq	256(%rsp), %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs8Uo9gldckSB_4wgpu3api11render_pass10RenderPassECskPEgommB4tQ_8gpui_gpu
.Ltmp631:
	movups	224(%rsp), %xmm0
	movups	240(%rsp), %xmm1
	movaps	%xmm1, 272(%rsp)
	movaps	%xmm0, 256(%rsp)
	leaq	104(%rsp), %r14
	leaq	256(%rsp), %rsi
	movq	%r14, %rdi
	callq	*_RNvMNtNtCs8Uo9gldckSB_4wgpu3api15command_encoderNtB2_14CommandEncoder6finish@GOTPCREL(%rip)
	movq	$0, 8(%rsp)
	movq	$8, 16(%rsp)
	xorps	%xmm0, %xmm0
	movups	%xmm0, 24(%rsp)
	movq	$8, 40(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 88(%rsp)
	movq	$1, 96(%rsp)
	movq	%r12, 80(%rsp)
	movq	560(%rbx), %rdi
	addq	$16, %rdi
	movb	$1, %bpl
.Ltmp636:
	leaq	.Lanon.0c40a24c2d9fab0ced350737d2089aa2.3(%rip), %rdx
	leaq	80(%rsp), %rsi
	callq	*_RNvXsc_NtNtCs8Uo9gldckSB_4wgpu7backend9wgpu_coreNtB5_9CoreQueueNtNtB9_8dispatch14QueueInterface6submit@GOTPCREL(%rip)
.Ltmp637:
	movq	%rax, %r15
	addq	$560, %rbx
	movups	8(%rsp), %xmm0
	movups	24(%rsp), %xmm1
	movups	40(%rsp), %xmm2
	movaps	%xmm2, 288(%rsp)
	movaps	%xmm1, 272(%rsp)
	movaps	%xmm0, 256(%rsp)
	xorl	%ebp, %ebp
.Ltmp638:
	leaq	256(%rsp), %rdi
	movq	%rbx, %rsi
	callq	*_RNvMNtNtCs8Uo9gldckSB_4wgpu3api22command_buffer_actionsNtB2_28DeferredCommandBufferActions7execute@GOTPCREL(%rip)
.Ltmp639:
	movq	88(%rsp), %rax
	movq	96(%rsp), %r12
	subq	%rax, %r12
	jne	.LBB85_8
.LBB85_20:
	movq	%r15, %rax
	addq	$1344, %rsp
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.LBB85_8:
	.cfi_def_cfa_offset 1392
	leaq	(%rax,%rax,2), %rax
	leaq	(%r14,%rax,8), %rdi
	incq	%r12
	.p2align	4
.LBB85_9:
	cmpq	$1, %r12
	je	.LBB85_20
	leaq	24(%rdi), %r14
	decq	%r12
.Ltmp646:
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs8Uo9gldckSB_4wgpu3api14command_buffer13CommandBufferECskPEgommB4tQ_8gpui_gpu
.Ltmp647:
	movq	%r14, %rdi
	jmp	.LBB85_9
.LBB85_12:
.Ltmp640:
	movq	%rax, %rbx
.Ltmp641:
	leaq	80(%rsp), %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtNtNtB4_4iter8adapters3map3MapINtNtNtB4_5array4iter8IntoIterNtNtNtCs8Uo9gldckSB_4wgpu3api14command_buffer13CommandBufferKj1_ENCINvMs2_NtB1H_5queueNtB2P_5Queue6submitAB1D_B2C_E0EECskPEgommB4tQ_8gpui_gpu
.Ltmp642:
	testb	%bpl, %bpl
	je	.LBB85_24
.Ltmp643:
	leaq	8(%rsp), %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs8Uo9gldckSB_4wgpu3api22command_buffer_actions28DeferredCommandBufferActionsECskPEgommB4tQ_8gpui_gpu
.Ltmp644:
	jmp	.LBB85_24
.LBB85_19:
.Ltmp645:
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking16panic_in_cleanup@GOTPCREL(%rip)
.LBB85_22:
.Ltmp632:
	movq	%rax, %rbx
	jmp	.LBB85_23
.LBB85_11:
.Ltmp627:
	movq	%rax, %rbx
.Ltmp628:
	leaq	256(%rsp), %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs8Uo9gldckSB_4wgpu3api11render_pass10RenderPassECskPEgommB4tQ_8gpui_gpu
.Ltmp629:
.LBB85_23:
.Ltmp633:
	leaq	224(%rsp), %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs8Uo9gldckSB_4wgpu3api15command_encoder14CommandEncoderECskPEgommB4tQ_8gpui_gpu
.Ltmp634:
.LBB85_24:
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB85_21:
.Ltmp635:
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking16panic_in_cleanup@GOTPCREL(%rip)
.LBB85_15:
.Ltmp648:
	movq	%rax, %rbx
	.p2align	4
.LBB85_16:
	decq	%r12
	je	.LBB85_24
.Ltmp649:
	leaq	24(%r14), %r15
	movq	%r14, %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs8Uo9gldckSB_4wgpu3api14command_buffer13CommandBufferECskPEgommB4tQ_8gpui_gpu
.Ltmp650:
	movq	%r15, %r14
	jmp	.LBB85_16
.LBB85_18:
.Ltmp651:
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking16panic_in_cleanup@GOTPCREL(%rip)
.Lfunc_end85:
	.size	_RNvMs2_NtCskPEgommB4tQ_8gpui_gpu8rendererNtB5_8Renderer6submit, .Lfunc_end85-_RNvMs2_NtCskPEgommB4tQ_8gpui_gpu8rendererNtB5_8Renderer6submit
	.cfi_endproc
