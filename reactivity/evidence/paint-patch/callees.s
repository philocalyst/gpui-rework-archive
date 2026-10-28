	.section	.text._RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer6render,"ax",@progbits
	.globl	_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer6render
	.p2align	4
	.type	_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer6render,@function
_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer6render:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$1368, %rsp
	movq	%rcx, %rbp
	movq	%rdx, %r13
	movq	%rsi, %r14
	movq	%rdi, %rbx
	leaq	840(%rsi), %r15
	movq	840(%rsi), %rax
	testq	%rax, %rax
	je	.LBB105_3
	lock		decq	(%rax)
	jne	.LBB105_3
	#MEMBARRIER
	movq	%r15, %rdi
	callq	*_RNvMsn_NtCscdodAO9FK5_5alloc4syncINtB5_3ArcNtNtNtCs7GypIiIHh8y_4wgpu7backend9wgpu_core13CoreBindGroupE9drop_slowBL_@GOTPCREL(%rip)
.LBB105_3:
	movq	$0, 840(%r14)
	movl	(%r13), %r12d
	movd	4(%r13), %xmm0
	movq	8(%r13), %r15
	movl	%r12d, 224(%rsp)
	movd	%xmm0, 828(%rsp)
	movd	%xmm0, 228(%rsp)
	movq	%r15, 232(%rsp)
	leaq	224(%rsp), %rdi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas5colorNtB5_11ColorConfig8validate@GOTPCREL(%rip)
	cmpl	$-1, %eax
	jne	.LBB105_29
	movl	%r12d, 824(%rsp)
	movq	%rbx, (%rsp)
	movl	40(%r13), %ebx
	movl	44(%r13), %r12d
	movq	%rbp, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api12texture_viewNtB2_11TextureView7texture@GOTPCREL(%rip)
	movq	%rax, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api7textureNtB2_7Texture5width@GOTPCREL(%rip)
	movq	%rbx, 88(%rsp)
	cmpl	%ebx, %eax
	jne	.LBB105_28
	movq	%rbp, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api12texture_viewNtB2_11TextureView7texture@GOTPCREL(%rip)
	movq	%rax, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api7textureNtB2_7Texture6height@GOTPCREL(%rip)
	cmpl	%r12d, %eax
	jne	.LBB105_28
	movq	%r12, 56(%rsp)
	movq	%rbp, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api12texture_viewNtB2_11TextureView7texture@GOTPCREL(%rip)
	leaq	224(%rsp), %rdi
	movq	%rax, %rsi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api7textureNtB2_7Texture6format@GOTPCREL(%rip)
	movl	224(%rsp), %eax
	cmpl	856(%r14), %eax
	jne	.LBB105_28
	cmpl	$76, %eax
	jne	.LBB105_10
	movl	228(%rsp), %eax
	cmpl	860(%r14), %eax
	jne	.LBB105_28
	movl	232(%rsp), %eax
	cmpl	864(%r14), %eax
	jne	.LBB105_28
.LBB105_10:
	movq	56(%rsp), %rax
	cmpl	$16384, %eax
	movq	88(%rsp), %r12
	ja	.LBB105_14
	cmpl	$16384, %r12d
	ja	.LBB105_14
	imulq	%r12, %rax
	addq	$-16777217, %rax
	cmpq	$-16777216, %rax
	jb	.LBB105_14
	movdqu	(%r13), %xmm0
	movups	16(%r13), %xmm1
	movups	32(%r13), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movdqa	%xmm0, 224(%rsp)
	leaq	1200(%rsp), %rdi
	leaq	224(%rsp), %rsi
	callq	*_RNvMsa_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedScene5draws@GOTPCREL(%rip)
	movq	56(%rsp), %rcx
	movq	1208(%rsp), %rax
	subq	1200(%rsp), %rax
	cmpq	$262144, %rax
	jbe	.LBB105_15
.LBB105_14:
	movq	(%rsp), %rbx
	movl	$5, (%rbx)
	jmp	.LBB105_30
.LBB105_15:
	movd	24(%r13), %xmm0
	movd	%xmm0, %eax
	andl	$2147483647, %eax
	cmpl	$2139095039, %eax
	jg	.LBB105_28
	pand	.LCPI105_0(%rip), %xmm0
	ucomiss	.LCPI105_1(%rip), %xmm0
	ja	.LBB105_28
	movd	28(%r13), %xmm0
	movd	%xmm0, %eax
	andl	$2147483647, %eax
	cmpl	$2139095039, %eax
	jg	.LBB105_28
	pand	.LCPI105_0(%rip), %xmm0
	ucomiss	.LCPI105_1(%rip), %xmm0
	ja	.LBB105_28
	movd	32(%r13), %xmm0
	movd	%xmm0, %eax
	andl	$2147483647, %eax
	cmpl	$2139095039, %eax
	jg	.LBB105_28
	pand	.LCPI105_0(%rip), %xmm0
	ucomiss	.LCPI105_1(%rip), %xmm0
	ja	.LBB105_28
	movd	36(%r13), %xmm0
	movd	%xmm0, %eax
	andl	$2147483647, %eax
	cmpl	$2139095039, %eax
	jg	.LBB105_28
	movdqa	.LCPI105_0(%rip), %xmm1
	pand	%xmm0, %xmm1
	ucomiss	.LCPI105_1(%rip), %xmm1
	ja	.LBB105_28
	xorps	%xmm1, %xmm1
	ucomiss	%xmm1, %xmm0
	jb	.LBB105_28
	movss	.LCPI105_2(%rip), %xmm1
	ucomiss	%xmm0, %xmm1
	jb	.LBB105_28
	movl	856(%r14), %eax
	.file	92 "/root/gpui-paint-patch/reactivity" "crates/canvas/src/color.rs"
	shrq	$40, %r15
	cmpl	$40, %eax
	jne	.LBB105_27
	testb	%r15b, %r15b
	jne	.LBB105_32
	jmp	.LBB105_28
.LBB105_27:
	testb	%r15b, %r15b
	je	.LBB105_31
.LBB105_28:
	movq	(%rsp), %rbx
.LBB105_29:
	movl	$3, (%rbx)
.LBB105_30:
	movq	%rbx, %rax
	addq	$1368, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB105_31:
	ucomiss	.LCPI105_2(%rip), %xmm0
	jne	.LBB105_28
	jp	.LBB105_28
.LBB105_32:
	movl	%eax, 820(%rsp)
	movss	%xmm1, 484(%rsp)
	movq	%rbp, 1016(%rsp)
	leaq	15(%r12), %rax
	shrq	$4, %rax
	leal	15(%rcx), %ebx
	shrl	$4, %ebx
	leaq	24(%r14), %rdi
	movq	$0, 40(%r14)
	movq	%rax, 80(%rsp)
	imull	%eax, %ebx
	movq	%rbx, %rsi
	callq	_RNvMs1_NtCscdodAO9FK5_5alloc3vecINtB5_3VecAmj2_E6resizeCsdsK2Jbz6dnh_8gpui_gpu
	movq	$0, 16(%r14)
	movdqu	(%r13), %xmm0
	movups	16(%r13), %xmm1
	movups	32(%r13), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movdqa	%xmm0, 224(%rsp)
	leaq	1200(%rsp), %r15
	leaq	224(%rsp), %rsi
	movq	%r15, %rdi
	callq	*_RNvMsa_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedScene6groups@GOTPCREL(%rip)
	leaq	869(%r14), %rdx
	leaq	656(%rsp), %rdi
	movq	%r15, %rsi
	callq	_RINvYNtNtCslsgujwDfRn_11gpui_canvas6canvas6GroupsNtNtNtNtCs4NRVxsYgnAr_4core4iter6traits8iterator8Iterator8try_foldjNCINvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB1Z_8Renderer15render_observedNCNvB1V_6render0Es0_0INtNtBT_6result6ResultjNtB1Z_5ErrorEEB21_
	movl	656(%rsp), %eax
	cmpl	$-1, %eax
	je	.LBB105_35
	movl	660(%rsp), %ecx
	movq	664(%rsp), %rdx
	movups	672(%rsp), %xmm0
.LBB105_34:
	movq	(%rsp), %rbx
	movups	%xmm0, 16(%rbx)
	movl	%eax, (%rbx)
	movl	%ecx, 4(%rbx)
	movq	%rdx, 8(%rbx)
	jmp	.LBB105_30
.LBB105_35:
	movq	664(%rsp), %rsi
	movq	%r14, %rdi
	callq	_RNvMs_NtCscdodAO9FK5_5alloc3vecINtB4_3VecAmj4_E17try_reserve_exactCsdsK2Jbz6dnh_8gpui_gpu
	cmpq	$-1, %rax
	jne	.LBB105_14
	leaq	72(%r14), %rdi
	movq	$0, 88(%r14)
	movq	%rbx, %rsi
	callq	_RNvMs1_NtCscdodAO9FK5_5alloc3vecINtB5_3VecmE6resizeCsdsK2Jbz6dnh_8gpui_gpu
	movq	$0, 112(%r14)
	cmpq	$0, 96(%r14)
	je	.LBB105_70
.LBB105_37:
	movq	104(%r14), %rax
	pxor	%xmm0, %xmm0
	movdqu	%xmm0, 16(%rax)
	movdqu	%xmm0, (%rax)
	movq	$1, 112(%r14)
	leaq	784(%r14), %rdi
	callq	_RNvMs1_NtNtNtCs2AWtUsOyxgP_3std11collections4hash3mapINtB5_7HashMapAmj8_mE5clearCsdsK2Jbz6dnh_8gpui_gpu
	movups	(%r13), %xmm0
	movups	16(%r13), %xmm1
	movups	32(%r13), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	960(%rsp), %rdi
	leaq	224(%rsp), %rsi
	callq	*_RNvMsa_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedScene6groups@GOTPCREL(%rip)
	movups	960(%rsp), %xmm0
	movups	976(%rsp), %xmm1
	movaps	%xmm1, 512(%rsp)
	movaps	%xmm0, 496(%rsp)
	leaq	656(%rsp), %rdi
	leaq	496(%rsp), %rsi
	callq	*_RNvXs7_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_6GroupsNtNtNtNtCs4NRVxsYgnAr_4core4iter6traits8iterator8Iterator4next@GOTPCREL(%rip)
	cmpq	$0, 656(%rsp)
	je	.LBB105_62
	movq	$0, 8(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 792(%rsp)
	movq	$0, 800(%rsp)
	movq	$0, 152(%rsp)
.LBB105_39:
	movq	672(%rsp), %rax
	movq	%rax, 912(%rsp)
	movups	656(%rsp), %xmm0
	movaps	%xmm0, 896(%rsp)
	movups	680(%rsp), %xmm3
	movaps	%xmm3, 32(%rsp)
	movups	696(%rsp), %xmm4
	movaps	%xmm4, 16(%rsp)
	movups	712(%rsp), %xmm5
	movaps	%xmm5, 64(%rsp)
	movups	728(%rsp), %xmm2
	movaps	%xmm2, 112(%rsp)
	leaq	744(%rsp), %rcx
	movups	(%rcx), %xmm1
	movaps	%xmm1, 464(%rsp)
	movzbl	869(%r14), %esi
	movq	%rax, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	movups	%xmm3, 248(%rsp)
	movups	%xmm4, 264(%rsp)
	movups	%xmm5, 280(%rsp)
	movups	%xmm2, 296(%rsp)
	movups	(%rcx), %xmm0
	leaq	312(%rsp), %rax
	movups	%xmm0, (%rax)
	leaq	224(%rsp), %r15
	movq	%r15, %rdi
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer13compact_group
	movl	%eax, %ebx
	movaps	32(%rsp), %xmm0
	movaps	%xmm0, 224(%rsp)
	movaps	16(%rsp), %xmm0
	movaps	%xmm0, 240(%rsp)
	movaps	64(%rsp), %xmm0
	movaps	%xmm0, 256(%rsp)
	movaps	112(%rsp), %xmm0
	movaps	%xmm0, 544(%rsp)
	movq	%r14, %rdi
	movq	%r15, %rsi
	leaq	544(%rsp), %rdx
	callq	_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer10correction
	movl	%eax, 488(%rsp)
	movaps	112(%rsp), %xmm0
	movhlps	%xmm0, %xmm0
	movaps	%xmm0, 768(%rsp)
	testb	%bl, %bl
	je	.LBB105_45
	movq	672(%rsp), %rax
	movq	%rax, 240(%rsp)
	movups	656(%rsp), %xmm0
	movaps	%xmm0, 224(%rsp)
	movaps	32(%rsp), %xmm0
	movups	%xmm0, 248(%rsp)
	movaps	16(%rsp), %xmm0
	movups	%xmm0, 264(%rsp)
	movaps	64(%rsp), %xmm0
	movups	%xmm0, 280(%rsp)
	movaps	112(%rsp), %xmm0
	movups	%xmm0, 296(%rsp)
	leaq	744(%rsp), %rax
	movups	(%rax), %xmm0
	leaq	312(%rsp), %rax
	movups	%xmm0, (%rax)
	leaq	928(%rsp), %rdi
	leaq	224(%rsp), %rsi
	callq	*_RNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedGroup10placements@GOTPCREL(%rip)
	movq	944(%rsp), %rax
	movq	%rax, 848(%rsp)
	movups	928(%rsp), %xmm0
	movaps	%xmm0, 832(%rsp)
	movq	$0, 856(%rsp)
	leaq	544(%rsp), %rdi
	leaq	832(%rsp), %rsi
	callq	_RNvXs_NtNtNtCs4NRVxsYgnAr_4core4iter8adapters9enumerateINtB4_9EnumerateINtNtB6_3map3MapINtNtNtBa_5slice4iter4ItermENCNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB1X_13PreparedGroup10placements0EENtNtNtB8_6traits8iterator8Iterator4nextCsdsK2Jbz6dnh_8gpui_gpu
	cmpb	$-1, 552(%rsp)
	movaps	112(%rsp), %xmm0
	unpcklpd	768(%rsp), %xmm0
	movaps	%xmm0, 96(%rsp)
	je	.LBB105_52
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 128(%rsp)
.LBB105_42:
	movq	544(%rsp), %rdx
	addq	48(%rsp), %rdx
	leaq	744(%rsp), %rax
	movups	(%rax), %xmm0
	leaq	312(%rsp), %rax
	movups	%xmm0, 64(%rax)
	leaq	552(%rsp), %rcx
	movups	56(%rcx), %xmm0
	movups	%xmm0, -32(%rax)
	movaps	32(%rsp), %xmm0
	movups	%xmm0, 296(%rsp)
	movaps	16(%rsp), %xmm0
	movups	%xmm0, 312(%rsp)
	movaps	64(%rsp), %xmm0
	movups	%xmm0, 328(%rsp)
	movaps	96(%rsp), %xmm0
	movups	%xmm0, 344(%rsp)
	movups	72(%rcx), %xmm0
	movups	%xmm0, 48(%rax)
	movq	48(%rcx), %rax
	movq	%rax, 272(%rsp)
	movups	(%rcx), %xmm0
	movups	16(%rcx), %xmm1
	movups	32(%rcx), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	160(%rsp), %rdi
	leaq	224(%rsp), %rsi
	movq	88(%rsp), %rcx
	movq	56(%rsp), %r8
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer13validate_draw
	movl	160(%rsp), %eax
	cmpl	$-1, %eax
	jne	.LBB105_65
	movsd	164(%rsp), %xmm0
	movaps	128(%rsp), %xmm2
	movaps	%xmm2, %xmm1
	maxps	%xmm0, %xmm2
	movaps	%xmm2, %xmm0
	cmpunordps	%xmm2, %xmm0
	andps	%xmm0, %xmm1
	andnps	%xmm2, %xmm0
	orps	%xmm1, %xmm0
	movaps	%xmm0, 128(%rsp)
	leaq	544(%rsp), %rdi
	leaq	832(%rsp), %rsi
	callq	_RNvXs_NtNtNtCs4NRVxsYgnAr_4core4iter8adapters9enumerateINtB4_9EnumerateINtNtB6_3map3MapINtNtNtBa_5slice4iter4ItermENCNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB1X_13PreparedGroup10placements0EENtNtNtB8_6traits8iterator8Iterator4nextCsdsK2Jbz6dnh_8gpui_gpu
	cmpb	$-1, 552(%rsp)
	jne	.LBB105_42
	movdqa	128(%rsp), %xmm0
	movd	%xmm0, %ecx
	shufps	$85, %xmm0, %xmm0
	movd	%xmm0, %eax
	shlq	$32, %rax
	orq	%rax, %rcx
	movq	%rcx, 768(%rsp)
	jmp	.LBB105_53
.LBB105_45:
	movq	672(%rsp), %rax
	movq	%rax, 240(%rsp)
	movups	656(%rsp), %xmm0
	movaps	%xmm0, 224(%rsp)
	movaps	32(%rsp), %xmm0
	movups	%xmm0, 248(%rsp)
	movaps	16(%rsp), %xmm0
	movups	%xmm0, 264(%rsp)
	movaps	64(%rsp), %xmm0
	movups	%xmm0, 280(%rsp)
	movaps	112(%rsp), %xmm0
	movups	%xmm0, 296(%rsp)
	leaq	744(%rsp), %rax
	movups	(%rax), %xmm0
	leaq	312(%rsp), %rax
	movups	%xmm0, (%rax)
	leaq	544(%rsp), %rdi
	leaq	224(%rsp), %rsi
	callq	*_RNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedGroup10placements@GOTPCREL(%rip)
	.file	93 "/nix/store/lynmg3kdpdz41r84nafwzi2n5nss50pq-rust-1.97.1-with-components-2026-07-16/lib/rustlib/src/rust/library/core/src/iter/traits" "collect.rs"
	movq	544(%rsp), %rax
	movq	552(%rsp), %rcx
	movq	%rax, 128(%rsp)
	movq	%rcx, 1008(%rsp)
	cmpq	%rcx, %rax
	je	.LBB105_51
	movq	560(%rsp), %rax
	movq	%rax, 808(%rsp)
.LBB105_47:
	movq	128(%rsp), %rax
	movl	(%rax), %edx
	leaq	1112(%rsp), %rdi
	movq	808(%rsp), %rsi
	callq	_RNCNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB7_13PreparedGroup10placements0CsdsK2Jbz6dnh_8gpui_gpu
	cmpb	$-1, 1112(%rsp)
	je	.LBB105_61
	leaq	744(%rsp), %rax
	movups	(%rax), %xmm0
	leaq	1256(%rsp), %rax
	movups	%xmm0, 96(%rax)
	leaq	1168(%rsp), %rcx
	movups	(%rcx), %xmm0
	movups	%xmm0, (%rax)
	movaps	32(%rsp), %xmm0
	movups	%xmm0, 1272(%rsp)
	movaps	16(%rsp), %xmm0
	movups	%xmm0, 1288(%rsp)
	movaps	64(%rsp), %xmm0
	movups	%xmm0, 1304(%rsp)
	movaps	112(%rsp), %xmm0
	unpcklpd	768(%rsp), %xmm0
	movups	%xmm0, 1320(%rsp)
	movups	16(%rcx), %xmm0
	movups	%xmm0, 80(%rax)
	movq	1160(%rsp), %rax
	movq	%rax, 1248(%rsp)
	movups	1112(%rsp), %xmm0
	movups	1128(%rsp), %xmm1
	movups	1144(%rsp), %xmm2
	movaps	%xmm2, 1232(%rsp)
	movaps	%xmm1, 1216(%rsp)
	movaps	%xmm0, 1200(%rsp)
	leaq	224(%rsp), %rdi
	leaq	1200(%rsp), %rsi
	movq	48(%rsp), %rdx
	movq	88(%rsp), %rcx
	movq	56(%rsp), %r8
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer13validate_draw
	movl	224(%rsp), %eax
	movq	228(%rsp), %r15
	cmpl	$-1, %eax
	jne	.LBB105_68
	movq	1160(%rsp), %rax
	movq	%rax, 272(%rsp)
	movups	1112(%rsp), %xmm0
	movups	1128(%rsp), %xmm1
	movups	1144(%rsp), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	544(%rsp), %rdi
	leaq	224(%rsp), %rbx
	movq	%rbx, %rsi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_14PreparedSource4mask@GOTPCREL(%rip)
	movq	544(%rsp), %r12
	movl	16(%r14), %ecx
	movl	$-2147483648, %eax
	orl	%eax, %ecx
	movl	%ecx, 96(%rsp)
	movq	%rbx, %rdi
	leaq	1200(%rsp), %rbp
	movq	%rbp, %rsi
	movq	%r15, %rbx
	movq	%r15, %rdx
	movl	488(%rsp), %ecx
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer12inline_words
	movl	$6, %edx
	movq	%r14, %rdi
	leaq	224(%rsp), %r15
	movq	%r15, %rsi
	callq	_RNvMs1_NtCscdodAO9FK5_5alloc3vecINtB5_3VecAmj4_E17extend_from_sliceCsdsK2Jbz6dnh_8gpui_gpu
	movq	%r15, %rdi
	movq	%r14, %rsi
	movq	%rbp, %rdx
	movq	%rbx, %rcx
	movl	96(%rsp), %r8d
	movq	48(%rsp), %r9
	pushq	152(%rsp)
	pushq	64(%rsp)
	pushq	104(%rsp)
	pushq	104(%rsp)
	callq	_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer8bin_draw
	addq	$32, %rsp
	movl	224(%rsp), %eax
	cmpl	$-1, %eax
	jne	.LBB105_67
	movq	128(%rsp), %rcx
	addq	$4, %rcx
	testq	%r12, %r12
	setne	%al
	movq	8(%rsp), %rdx
	orb	%al, %dl
	andb	$1, %dl
	movq	%rdx, 8(%rsp)
	movq	232(%rsp), %rax
	movq	%rax, 152(%rsp)
	incq	48(%rsp)
	movq	%rcx, 128(%rsp)
	cmpq	1008(%rsp), %rcx
	jne	.LBB105_47
.LBB105_51:
	leaq	1112(%rsp), %rax
	jmp	.LBB105_60
.LBB105_52:
	movq	$0, 768(%rsp)
.LBB105_53:
	movaps	64(%rsp), %xmm1
	movaps	%xmm1, %xmm0
	movaps	%xmm1, %xmm4
	unpckhpd	%xmm1, %xmm0
	movl	16(%r14), %eax
	movl	%eax, 808(%rsp)
	movq	768(%rsp), %rdx
	movq	%rdx, %rax
	shrq	$32, %rax
	movapd	32(%rsp), %xmm2
	movapd	%xmm2, %xmm1
	movapd	16(%rsp), %xmm3
	unpcklpd	%xmm3, %xmm1
	cvtpd2ps	%xmm1, %xmm1
	unpckhpd	%xmm3, %xmm2
	cvtpd2ps	%xmm2, %xmm2
	xorps	%xmm3, %xmm3
	cvtsd2ss	%xmm4, %xmm3
	cvtsd2ss	%xmm0, %xmm0
	leaq	744(%rsp), %rcx
	movups	(%rcx), %xmm4
	leaq	312(%rsp), %rbx
	movups	%xmm4, -40(%rbx)
	movlpd	%xmm1, 224(%rsp)
	movss	%xmm3, 232(%rsp)
	movl	%edx, 236(%rsp)
	movlpd	%xmm2, 240(%rsp)
	movss	%xmm0, 248(%rsp)
	movl	%eax, 252(%rsp)
	movaps	112(%rsp), %xmm0
	movups	%xmm0, 256(%rsp)
	movl	488(%rsp), %eax
	movl	%eax, 288(%rsp)
	movq	$0, 292(%rsp)
	movl	$0, 300(%rsp)
	movl	$5, %edx
	movq	%r14, %rdi
	leaq	224(%rsp), %rbp
	movq	%rbp, %rsi
	callq	_RNvMs1_NtCscdodAO9FK5_5alloc3vecINtB5_3VecAmj4_E17extend_from_sliceCsdsK2Jbz6dnh_8gpui_gpu
	incq	792(%rsp)
	movq	672(%rsp), %rax
	movq	%rax, 240(%rsp)
	movups	656(%rsp), %xmm0
	movaps	%xmm0, 224(%rsp)
	movaps	32(%rsp), %xmm0
	movups	%xmm0, 248(%rsp)
	movaps	16(%rsp), %xmm0
	movups	%xmm0, 264(%rsp)
	movaps	64(%rsp), %xmm0
	movups	%xmm0, 280(%rsp)
	movaps	112(%rsp), %xmm0
	movups	%xmm0, 296(%rsp)
	movaps	464(%rsp), %xmm0
	movups	%xmm0, (%rbx)
	leaq	544(%rsp), %r12
	movq	%r12, %rdi
	movq	%rbp, %rsi
	movq	_RNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedGroup10placements@GOTPCREL(%rip), %r15
	callq	*%r15
	movq	552(%rsp), %rax
	subq	544(%rsp), %rax
	shrq	$2, %rax
	addq	%rax, 800(%rsp)
	movq	912(%rsp), %rax
	movq	%rax, 240(%rsp)
	movaps	896(%rsp), %xmm0
	movaps	%xmm0, 224(%rsp)
	movaps	32(%rsp), %xmm0
	movups	%xmm0, 248(%rsp)
	movaps	16(%rsp), %xmm0
	movups	%xmm0, 264(%rsp)
	movaps	64(%rsp), %xmm0
	movups	%xmm0, 280(%rsp)
	movaps	96(%rsp), %xmm0
	movups	%xmm0, 296(%rsp)
	movaps	464(%rsp), %xmm0
	movups	%xmm0, (%rbx)
	movq	%r12, %rdi
	movq	%rbp, %rsi
	callq	*%r15
	movq	544(%rsp), %rbx
	movq	552(%rsp), %rax
	cmpq	%rax, %rbx
	je	.LBB105_59
	movq	%rax, %rbp
	movq	560(%rsp), %rax
	movq	%rax, 96(%rsp)
.LBB105_55:
	movl	(%rbx), %edx
	leaq	1024(%rsp), %rdi
	movq	96(%rsp), %rsi
	callq	_RNCNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB7_13PreparedGroup10placements0CsdsK2Jbz6dnh_8gpui_gpu
	cmpb	$-1, 1024(%rsp)
	je	.LBB105_61
	movaps	464(%rsp), %xmm0
	leaq	312(%rsp), %rax
	movups	%xmm0, 64(%rax)
	leaq	1080(%rsp), %rcx
	movups	(%rcx), %xmm0
	movups	%xmm0, -32(%rax)
	movaps	32(%rsp), %xmm0
	movups	%xmm0, 296(%rsp)
	movaps	16(%rsp), %xmm0
	movups	%xmm0, 312(%rsp)
	movaps	64(%rsp), %xmm0
	movups	%xmm0, 328(%rsp)
	movaps	112(%rsp), %xmm0
	movups	%xmm0, 344(%rsp)
	movups	16(%rcx), %xmm0
	movups	%xmm0, 48(%rax)
	movq	1072(%rsp), %rax
	movq	%rax, 272(%rsp)
	movups	1024(%rsp), %xmm0
	movups	1040(%rsp), %xmm1
	movups	1056(%rsp), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	movq	1072(%rsp), %rax
	movq	%rax, 592(%rsp)
	movups	1024(%rsp), %xmm0
	movupd	1040(%rsp), %xmm1
	movupd	1056(%rsp), %xmm2
	movapd	%xmm2, 576(%rsp)
	movapd	%xmm1, 560(%rsp)
	movaps	%xmm0, 544(%rsp)
	leaq	160(%rsp), %rdi
	leaq	544(%rsp), %r12
	movq	%r12, %rsi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_14PreparedSource4mask@GOTPCREL(%rip)
	movq	160(%rsp), %r15
	movl	16(%r14), %eax
	movl	%eax, 128(%rsp)
	movups	280(%rsp), %xmm0
	movaps	%xmm0, 544(%rsp)
	movq	$0, 560(%rsp)
	movl	$0, 568(%rsp)
	movl	808(%rsp), %eax
	movl	%eax, 572(%rsp)
	movl	$2, %edx
	movq	%r14, %rdi
	movq	%r12, %rsi
	callq	_RNvMs1_NtCscdodAO9FK5_5alloc3vecINtB5_3VecAmj4_E17extend_from_sliceCsdsK2Jbz6dnh_8gpui_gpu
	movq	%r12, %rdi
	movq	%r14, %rsi
	leaq	224(%rsp), %rdx
	movq	768(%rsp), %rcx
	movl	128(%rsp), %r8d
	movq	48(%rsp), %r9
	pushq	152(%rsp)
	pushq	64(%rsp)
	pushq	104(%rsp)
	pushq	104(%rsp)
	callq	_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer8bin_draw
	addq	$32, %rsp
	movl	544(%rsp), %eax
	cmpl	$-1, %eax
	jne	.LBB105_69
	addq	$4, %rbx
	testq	%r15, %r15
	setne	%al
	movq	8(%rsp), %rcx
	orb	%al, %cl
	andb	$1, %cl
	movq	%rcx, 8(%rsp)
	movq	552(%rsp), %rax
	movq	%rax, 152(%rsp)
	incq	48(%rsp)
	cmpq	%rbp, %rbx
	jne	.LBB105_55
.LBB105_59:
	leaq	1024(%rsp), %rax
.LBB105_60:
	movb	$-1, (%rax)
.LBB105_61:
	leaq	656(%rsp), %rdi
	leaq	496(%rsp), %rsi
	callq	*_RNvXs7_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_6GroupsNtNtNtNtCs4NRVxsYgnAr_4core4iter6traits8iterator8Iterator4next@GOTPCREL(%rip)
	cmpq	$0, 656(%rsp)
	jne	.LBB105_39
	jmp	.LBB105_63
.LBB105_62:
	movq	$0, 152(%rsp)
	movq	$0, 800(%rsp)
	movq	$0, 792(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 8(%rsp)
.LBB105_63:
	leaq	552(%r14), %rsi
	leaq	560(%r14), %rdx
	leaq	624(%r14), %rcx
	leaq	832(%r14), %r8
	movq	16(%r14), %r9
	movups	(%r13), %xmm0
	movups	16(%r13), %xmm1
	movups	32(%r13), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	subq	$8, %rsp
	leaq	664(%rsp), %rdi
	leaq	232(%rsp), %rax
	pushq	%rax
	callq	_RNvNtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer6images7prepare
	addq	$16, %rsp
	movl	656(%rsp), %eax
	cmpl	$-1, %eax
	je	.LBB105_66
	movdqu	660(%rsp), %xmm0
	movups	672(%rsp), %xmm1
	movq	(%rsp), %rbx
	movups	%xmm1, 16(%rbx)
	movdqu	%xmm0, 4(%rbx)
	movl	%eax, (%rbx)
	jmp	.LBB105_30
.LBB105_65:
	movl	188(%rsp), %ecx
	movq	(%rsp), %rbx
	movl	%ecx, 28(%rbx)
	movups	172(%rsp), %xmm0
	movups	%xmm0, 12(%rbx)
	movq	164(%rsp), %rcx
	movl	%eax, (%rbx)
	movq	%rcx, 4(%rbx)
	jmp	.LBB105_30
.LBB105_66:
	movzbl	8(%rsp), %ecx
	andl	$1, %ecx
	leaq	224(%rsp), %rdi
	movq	%r14, %rsi
	movq	%r13, %rdx
	callq	_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer13prepare_atlas
	movl	224(%rsp), %eax
	cmpl	$-1, %eax
	je	.LBB105_71
.LBB105_67:
	movl	228(%rsp), %ecx
	movq	232(%rsp), %rdx
	movups	240(%rsp), %xmm0
	jmp	.LBB105_34
.LBB105_68:
	movl	252(%rsp), %ecx
	movq	(%rsp), %rbx
	movl	%ecx, 28(%rbx)
	movups	236(%rsp), %xmm0
	movups	%xmm0, 12(%rbx)
	movl	%eax, (%rbx)
	movq	%r15, 4(%rbx)
	jmp	.LBB105_30
.LBB105_69:
	movl	548(%rsp), %ecx
	movq	552(%rsp), %rdx
	movups	560(%rsp), %xmm0
	jmp	.LBB105_34
.LBB105_70:
	leaq	96(%r14), %rdi
	callq	*_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer10CorrectionE8grow_oneBP_@GOTPCREL(%rip)
	jmp	.LBB105_37
.LBB105_71:
	movq	232(%rsp), %rax
	movq	%rax, 488(%rsp)
	movups	(%r13), %xmm0
	movups	16(%r13), %xmm1
	movups	32(%r13), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	896(%rsp), %rdi
	leaq	224(%rsp), %rsi
	callq	*_RNvMsa_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedScene6groups@GOTPCREL(%rip)
	movups	896(%rsp), %xmm0
	movups	912(%rsp), %xmm1
	movaps	%xmm1, 944(%rsp)
	movaps	%xmm0, 928(%rsp)
	leaq	544(%rsp), %rdi
	leaq	928(%rsp), %rsi
	callq	*_RNvXs7_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_6GroupsNtNtNtNtCs4NRVxsYgnAr_4core4iter6traits8iterator8Iterator4next@GOTPCREL(%rip)
	cmpq	$0, 544(%rsp)
	je	.LBB105_85
	xorl	%ebp, %ebp
	jmp	.LBB105_74
.LBB105_73:
	leaq	544(%rsp), %rdi
	leaq	928(%rsp), %rsi
	callq	*_RNvXs7_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_6GroupsNtNtNtNtCs4NRVxsYgnAr_4core4iter6traits8iterator8Iterator4next@GOTPCREL(%rip)
	cmpq	$0, 544(%rsp)
	je	.LBB105_85
.LBB105_74:
	movq	%rbp, %r15
	movq	640(%rsp), %rax
	movq	%rax, 752(%rsp)
	movups	624(%rsp), %xmm0
	movaps	%xmm0, 736(%rsp)
	movups	608(%rsp), %xmm0
	movaps	%xmm0, 720(%rsp)
	movups	544(%rsp), %xmm0
	movups	560(%rsp), %xmm1
	movups	576(%rsp), %xmm2
	movups	592(%rsp), %xmm3
	movaps	%xmm3, 704(%rsp)
	movaps	%xmm2, 688(%rsp)
	movaps	%xmm1, 672(%rsp)
	movaps	%xmm0, 656(%rsp)
	leaq	869(%r14), %rax
	movzbl	(%rax), %esi
	movq	640(%rsp), %rax
	movq	%rax, 320(%rsp)
	movups	624(%rsp), %xmm0
	movaps	%xmm0, 304(%rsp)
	movups	608(%rsp), %xmm0
	movaps	%xmm0, 288(%rsp)
	movups	544(%rsp), %xmm0
	movups	560(%rsp), %xmm1
	movups	576(%rsp), %xmm2
	movups	592(%rsp), %xmm3
	movaps	%xmm3, 272(%rsp)
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	224(%rsp), %rbx
	movq	%rbx, %rdi
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer13compact_group
	movl	%eax, %r12d
	addq	$5, %rbp
	testb	%al, %al
	cmoveq	%r15, %rbp
	movq	%rbx, %rdi
	leaq	656(%rsp), %rsi
	callq	*_RNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedGroup10placements@GOTPCREL(%rip)
	movq	224(%rsp), %rcx
	movq	232(%rsp), %rdx
	movq	%rdx, 128(%rsp)
	cmpq	%rdx, %rcx
	je	.LBB105_73
	movq	%rcx, %rax
	movq	240(%rsp), %rcx
	movq	%rcx, 112(%rsp)
	xorb	$1, %r12b
	movzbl	%r12b, %ecx
	shll	$2, %ecx
	leaq	1(%rcx), %rdx
	movq	%rdx, 8(%rsp)
	leaq	(%rcx,%rbp), %rbx
	incq	%rbx
	orq	$2, %rcx
	shlq	$4, %rbx
	movq	%rcx, 96(%rsp)
	shll	$4, %ecx
	movq	%rcx, 768(%rsp)
	leaq	160(%rsp), %r15
	movq	%rax, %rdx
.LBB105_76:
	movq	%rdx, 32(%rsp)
	movl	(%rdx), %edx
	leaq	224(%rsp), %rdi
	movq	112(%rsp), %rsi
	callq	_RNCNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB7_13PreparedGroup10placements0CsdsK2Jbz6dnh_8gpui_gpu
	cmpb	$-1, 224(%rsp)
	je	.LBB105_73
	movss	288(%rsp), %xmm0
	movss	%xmm0, 16(%rsp)
	movss	292(%rsp), %xmm0
	movss	%xmm0, 64(%rsp)
	movups	224(%rsp), %xmm0
	movups	240(%rsp), %xmm1
	movups	256(%rsp), %xmm2
	movaps	%xmm0, 832(%rsp)
	movaps	%xmm1, 848(%rsp)
	movaps	%xmm2, 864(%rsp)
	movq	272(%rsp), %rax
	movq	%rax, 880(%rsp)
	movq	%rax, 208(%rsp)
	movaps	%xmm2, 192(%rsp)
	movaps	%xmm1, 176(%rsp)
	movaps	%xmm0, 160(%rsp)
	leaq	496(%rsp), %rdi
	movq	%r15, %rsi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_14PreparedSource5image@GOTPCREL(%rip)
	cmpb	$2, 496(%rsp)
	jne	.LBB105_80
	movq	272(%rsp), %rax
	movq	%rax, 208(%rsp)
	movups	224(%rsp), %xmm0
	movups	240(%rsp), %xmm1
	movups	256(%rsp), %xmm2
	movaps	%xmm2, 192(%rsp)
	movaps	%xmm1, 176(%rsp)
	movaps	%xmm0, 160(%rsp)
	movq	%r15, %rdi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_14PreparedSource13corner_radius@GOTPCREL(%rip)
	testl	%eax, %eax
	je	.LBB105_82
	movq	%r15, %rdi
	leaq	832(%rsp), %rsi
	movss	16(%rsp), %xmm0
	movss	64(%rsp), %xmm1
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer10shape_word
	movq	160(%rsp), %rax
	movl	$1073741824, 464(%rsp)
	movq	%rax, 468(%rsp)
	jmp	.LBB105_83
.LBB105_80:
	movq	528(%rsp), %rax
	movq	%rax, 992(%rsp)
	movups	496(%rsp), %xmm0
	movups	512(%rsp), %xmm1
	movaps	%xmm1, 976(%rsp)
	movaps	%xmm0, 960(%rsp)
	leaq	832(%r14), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.LBB105_127
	movq	%r15, %rdi
	movq	%rax, %r15
	movzbl	536(%rsp), %eax
	movl	%eax, 16(%rsp)
	movq	528(%rsp), %rax
	movq	%rax, 192(%rsp)
	movups	496(%rsp), %xmm0
	movups	512(%rsp), %xmm1
	movaps	%xmm1, 176(%rsp)
	movaps	%xmm0, 160(%rsp)
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas5imageNtB5_9ImageView3key@GOTPCREL(%rip)
	movq	%r15, %rdi
	movq	%rax, %rsi
	movl	16(%rsp), %edx
	callq	_RNvMNtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer6imagesNtB2_6Images8metadata
	movq	%rax, %r12
	movl	%eax, 16(%rsp)
	shrq	$32, %r12
	leaq	832(%rsp), %rdi
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer13rounded_image
	movl	%r12d, %r15d
	orl	$16, %r15d
	testb	%al, %al
	cmovel	%r12d, %r15d
	movq	528(%rsp), %rax
	movq	%rax, 192(%rsp)
	movups	496(%rsp), %xmm0
	movups	512(%rsp), %xmm1
	movaps	%xmm1, 176(%rsp)
	movaps	%xmm0, 160(%rsp)
	leaq	160(%rsp), %rdi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas5imageNtB5_9ImageView5width@GOTPCREL(%rip)
	movl	%eax, %r12d
	leaq	960(%rsp), %rdi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas5imageNtB5_9ImageView6height@GOTPCREL(%rip)
	shll	$16, %eax
	orl	%r12d, %eax
	movl	16(%rsp), %ecx
	movl	%ecx, 464(%rsp)
	movl	%r15d, 468(%rsp)
	leaq	160(%rsp), %r15
	movl	%eax, 472(%rsp)
	jmp	.LBB105_83
.LBB105_82:
	movq	%r15, %rdi
	leaq	832(%rsp), %rsi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_14PreparedSource4mask@GOTPCREL(%rip)
	movl	$0, 504(%rsp)
	movq	$0, 496(%rsp)
	leaq	464(%rsp), %rdi
	movq	%r15, %rsi
	leaq	496(%rsp), %rdx
	leaq	288(%r14), %rcx
	callq	_RINvMNtCs4NRVxsYgnAr_4core6optionINtB3_6OptionNtNtCslsgujwDfRn_11gpui_canvas6canvas9GlyphMaskE6map_orAmj3_NCINvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB1P_8Renderer15render_observedNCNvB1L_6render0Es2_0EB1R_
.LBB105_83:
	movq	8(%rsp), %rax
	leaq	(%rax,%rbp), %rdi
	movq	16(%r14), %rsi
	cmpq	%rsi, %rdi
	jae	.LBB105_128
	movq	32(%rsp), %rdx
	addq	$4, %rdx
	movq	8(%r14), %rax
	movl	472(%rsp), %ecx
	movl	%ecx, 8(%rax,%rbx)
	movq	464(%rsp), %rcx
	movq	%rcx, (%rax,%rbx)
	addq	96(%rsp), %rbp
	addq	768(%rsp), %rbx
	cmpq	128(%rsp), %rdx
	jne	.LBB105_76
	jmp	.LBB105_73
.LBB105_85:
	movq	40(%r14), %rax
	movq	$0, 96(%rsp)
	testq	%rax, %rax
	je	.LBB105_93
	movq	32(%r14), %rcx
	shlq	$3, %rax
	xorl	%edi, %edi
	jmp	.LBB105_89
.LBB105_87:
	movq	96(%rsp), %rdx
	addl	%esi, %edx
	movl	%edx, (%rcx,%rdi,8)
	movq	%rdx, 96(%rsp)
.LBB105_88:
	movl	%edx, 4(%rcx,%rdi,8)
	.file	94 "/nix/store/lynmg3kdpdz41r84nafwzi2n5nss50pq-rust-1.97.1-with-components-2026-07-16/lib/rustlib/src/rust/library/core/src/iter/adapters" "enumerate.rs"
	incq	%rdi
	addq	$-8, %rax
	je	.LBB105_92
.LBB105_89:
	movq	88(%r14), %rsi
	cmpq	%rsi, %rdi
	jae	.LBB105_129
	movl	4(%rcx,%rdi,8), %esi
	cmpl	$1, %esi
	jne	.LBB105_87
	movq	80(%r14), %r8
	movl	$-2147483648, %edx
	cmpl	$0, (%r8,%rdi,4)
	jne	.LBB105_88
	jmp	.LBB105_87
.LBB105_92:
	movq	96(%rsp), %rax
	movl	%eax, %eax
	movq	%rax, 96(%rsp)
.LBB105_93:
	leaq	48(%r14), %rdi
	movq	$0, 64(%r14)
	movq	96(%rsp), %rsi
	callq	_RNvMs1_NtCscdodAO9FK5_5alloc3vecINtB5_3VecmE6resizeCsdsK2Jbz6dnh_8gpui_gpu
	movq	16(%r14), %rax
	movq	%rax, 32(%rsp)
	movq	48(%rsp), %rax
	movq	%rax, 896(%rsp)
	movups	(%r13), %xmm0
	movups	16(%r13), %xmm1
	movups	32(%r13), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	496(%rsp), %rdi
	leaq	224(%rsp), %rsi
	callq	*_RNvMsa_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedScene6groups@GOTPCREL(%rip)
	movdqu	496(%rsp), %xmm0
	movups	512(%rsp), %xmm1
	movaps	%xmm1, 848(%rsp)
	movdqa	%xmm0, 832(%rsp)
	jmp	.LBB105_96
.LBB105_94:
	movb	$-1, 544(%rsp)
.LBB105_95:
	movq	32(%rsp), %rcx
	leaq	-5(%rcx), %rax
	cmpb	$0, 8(%rsp)
	cmovneq	%rax, %rcx
	movq	%rcx, 32(%rsp)
.LBB105_96:
	leaq	656(%rsp), %rdi
	leaq	832(%rsp), %rsi
	.file	95 "/nix/store/lynmg3kdpdz41r84nafwzi2n5nss50pq-rust-1.97.1-with-components-2026-07-16/lib/rustlib/src/rust/library/core/src/iter/adapters" "rev.rs"
	callq	*_RNvXs8_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_6GroupsNtNtNtNtCs4NRVxsYgnAr_4core4iter6traits12double_ended19DoubleEndedIterator9next_back@GOTPCREL(%rip)
	cmpq	$0, 656(%rsp)
	je	.LBB105_101
	leaq	869(%r14), %rax
	movzbl	(%rax), %esi
	movq	752(%rsp), %rax
	movq	%rax, 320(%rsp)
	movups	736(%rsp), %xmm0
	movaps	%xmm0, 304(%rsp)
	movups	720(%rsp), %xmm0
	movaps	%xmm0, 288(%rsp)
	movups	656(%rsp), %xmm0
	movups	672(%rsp), %xmm1
	movups	688(%rsp), %xmm2
	movups	704(%rsp), %xmm3
	movaps	%xmm3, 272(%rsp)
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	224(%rsp), %rbx
	movq	%rbx, %rdi
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer13compact_group
	movb	%al, 8(%rsp)
	movq	752(%rsp), %rax
	movq	%rax, 320(%rsp)
	movups	736(%rsp), %xmm0
	movaps	%xmm0, 304(%rsp)
	movups	720(%rsp), %xmm0
	movaps	%xmm0, 288(%rsp)
	movdqu	656(%rsp), %xmm0
	movups	672(%rsp), %xmm1
	movups	688(%rsp), %xmm2
	movups	704(%rsp), %xmm3
	movaps	%xmm3, 272(%rsp)
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movdqa	%xmm0, 224(%rsp)
	leaq	160(%rsp), %rdi
	movq	%rbx, %rsi
	callq	*_RNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedGroup10placements@GOTPCREL(%rip)
	movq	160(%rsp), %rax
	movq	168(%rsp), %rdx
	movq	%rax, 16(%rsp)
	cmpq	%rdx, %rax
	je	.LBB105_94
	movq	%rdx, %r12
	movq	176(%rsp), %rax
	movq	%rax, 64(%rsp)
	movzbl	8(%rsp), %eax
	leal	(,%rax,4), %edx
	orq	$-6, %rdx
	xorl	%esi, %esi
	testb	%al, %al
	sete	%sil
	shll	$31, %esi
	movl	%esi, 112(%rsp)
	movq	32(%rsp), %rax
	movq	%rdx, 128(%rsp)
	leal	(%rdx,%rax), %r15d
	movq	80(%rsp), %rbx
.LBB105_99:
	movl	-4(%r12), %edx
	leaq	544(%rsp), %rdi
	movq	64(%rsp), %rsi
	callq	_RNCNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB7_13PreparedGroup10placements0CsdsK2Jbz6dnh_8gpui_gpu
	cmpb	$-1, 544(%rsp)
	je	.LBB105_95
	decq	896(%rsp)
	addq	$-4, %r12
	movq	128(%rsp), %rbp
	addq	%rbp, 32(%rsp)
	movl	112(%rsp), %eax
	orl	%r15d, %eax
	movl	%eax, 960(%rsp)
	leaq	600(%rsp), %rcx
	movups	(%rcx), %xmm0
	leaq	280(%rsp), %rax
	movups	%xmm0, (%rax)
	leaq	680(%rsp), %rdx
	movups	(%rdx), %xmm0
	movups	16(%rdx), %xmm1
	movups	32(%rdx), %xmm2
	movups	%xmm2, 48(%rax)
	movups	%xmm1, 32(%rax)
	movups	%xmm0, 16(%rax)
	movups	48(%rdx), %xmm0
	movups	%xmm0, 64(%rax)
	movups	16(%rcx), %xmm0
	movups	%xmm0, 80(%rax)
	movups	64(%rdx), %xmm0
	movups	%xmm0, 96(%rax)
	movq	592(%rsp), %rax
	movq	%rax, 272(%rsp)
	movdqu	544(%rsp), %xmm0
	movups	560(%rsp), %xmm1
	movups	576(%rsp), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movdqa	%xmm0, 224(%rsp)
	leaq	24(%r14), %rax
	movq	%rax, 160(%rsp)
	leaq	48(%r14), %rax
	movq	%rax, 168(%rsp)
	leaq	72(%r14), %rax
	movq	%rax, 176(%rsp)
	leaq	896(%rsp), %rax
	movq	%rax, 184(%rsp)
	leaq	960(%rsp), %rax
	movq	%rax, 192(%rsp)
	leaq	224(%rsp), %rdi
	movq	%rbx, %rsi
	leaq	160(%rsp), %rdx
	callq	_RINvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5visitNCINvMs2_B2_NtB2_8Renderer15render_observedNCNvBL_6render0Es3_0EB4_
	addl	%ebp, %r15d
	cmpq	16(%rsp), %r12
	jne	.LBB105_99
	jmp	.LBB105_94
.LBB105_101:
	movq	40(%r14), %rdi
	xorl	%esi, %esi
	testq	%rdi, %rdi
	je	.LBB105_112
	movq	32(%r14), %r8
	shlq	$3, %rdi
	cmpl	$0, 80(%rsp)
	je	.LBB105_121
	movq	$0, 64(%rsp)
	movq	$0, 16(%rsp)
	movq	$0, 32(%rsp)
	xorl	%r9d, %r9d
	xorl	%ecx, %ecx
	movq	88(%rsp), %rbx
	movq	56(%rsp), %r12
	jmp	.LBB105_106
.LBB105_104:
	incq	32(%rsp)
.LBB105_105:
	incq	%r9
	cmpq	80(%rsp), %r9
	movl	$0, %eax
	cmoveq	%rax, %r9
	incq	%rcx
	addq	$-8, %rdi
	je	.LBB105_114
.LBB105_106:
	movl	4(%r8,%rcx,8), %r10d
	movl	%r10d, %eax
	negl	%eax
	jo	.LBB105_104
	subl	(%r8,%rcx,8), %r10d
	je	.LBB105_105
	movq	%rcx, %rax
	shrq	$32, %rax
	je	.LBB105_110
	movq	%rcx, %rax
	xorl	%edx, %edx
	divq	80(%rsp)
	movq	%r9, %rdx
	jmp	.LBB105_111
.LBB105_110:
	movl	%ecx, %eax
	xorl	%edx, %edx
	divl	80(%rsp)
.LBB105_111:
	shll	$4, %edx
	shll	$4, %eax
	leal	16(%rdx), %r11d
	cmpl	%r11d, %ebx
	cmovbl	%ebx, %r11d
	leal	16(%rax), %r15d
	cmpl	%r15d, %r12d
	cmovbl	%r12d, %r15d
	subl	%edx, %r11d
	subl	%eax, %r15d
	imull	%r11d, %r15d
	shlq	$4, %r15
	addq	%r15, 16(%rsp)
	imulq	%r10, %r15
	addq	%r15, 64(%rsp)
	jmp	.LBB105_105
.LBB105_112:
	movq	$0, 32(%rsp)
	movq	$0, 16(%rsp)
.LBB105_113:
	movq	$0, 64(%rsp)
.LBB105_114:
	testb	$1, 824(%rsp)
	je	.LBB105_116
	movd	828(%rsp), %xmm0
	movd	%xmm0, %eax
	testl	%eax, %eax
	sets	%cl
	movl	%eax, %edx
	andl	$2147483647, %edx
	addl	$-8388608, %edx
	cmpl	$2130706432, %edx
	setae	%dl
	orb	%cl, %dl
	decl	%eax
	cmpl	$8388607, %eax
	setae	%al
	movl	$2, %esi
	movd	%xmm0, 484(%rsp)
	testb	%dl, %al
	jne	.LBB105_28
.LBB105_116:
	leaq	24(%r13), %rax
	xorl	%ecx, %ecx
	cmpl	$40, 820(%rsp)
	sete	%cl
	movzbl	12(%r13), %edx
	leal	(%rsi,%rcx,4), %ecx
	orl	%edx, %ecx
	movups	(%rax), %xmm0
	movups	%xmm0, 176(%rsp)
	movq	88(%rsp), %rax
	movl	%eax, 160(%rsp)
	movq	56(%rsp), %rax
	movl	%eax, 164(%rsp)
	movq	80(%rsp), %rax
	movl	%eax, 168(%rsp)
	movl	%ecx, 172(%rsp)
	movss	484(%rsp), %xmm0
	movss	%xmm0, 192(%rsp)
	movq	$0, 196(%rsp)
	movl	$0, 204(%rsp)
	leaq	584(%r14), %rsi
	leaq	160(%rsp), %rcx
	movl	$48, %r8d
	leaq	560(%r14), %rbx
	movq	%rbx, %rdi
	xorl	%edx, %edx
	callq	*_RNvMs2_NtNtCs7GypIiIHh8y_4wgpu3api5queueNtB5_5Queue12write_buffer@GOTPCREL(%rip)
	movq	8(%r14), %rcx
	movq	16(%r14), %r8
	.file	96 "/root/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/bytemuck-1.25.2" "src/internal.rs"
	shlq	$4, %r8
	leaq	624(%r14), %r15
	movq	%r15, %rdi
	leaq	552(%r14), %r12
	movq	%r12, %rsi
	movq	%rbx, %rdx
	callq	_RNvMs0_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_6Buffer5write
	leaq	664(%r14), %rdi
	movq	32(%r14), %rcx
	movq	40(%r14), %r8
	shlq	$3, %r8
	movq	%r12, %rsi
	movq	%rbx, %rdx
	callq	_RNvMs0_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_6Buffer5write
	leaq	704(%r14), %rdi
	movq	56(%r14), %rcx
	movq	64(%r14), %r8
	shlq	$2, %r8
	movq	%r12, %rsi
	movq	%rbx, %rdx
	callq	_RNvMs0_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_6Buffer5write
	leaq	744(%r14), %r13
	movq	104(%r14), %rcx
	movq	112(%r14), %r8
	shlq	$5, %r8
	movq	%r13, %rdi
	movq	%r12, %rsi
	movq	%rbx, %rdx
	callq	_RNvMs0_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_6Buffer5write
	movq	_RNvMNtNtCs7GypIiIHh8y_4wgpu3api6bufferNtB2_6Buffer17as_entire_binding@GOTPCREL(%rip), %rbx
	leaq	224(%rsp), %rbp
	movq	%rbp, %rdi
	leaq	584(%r14), %rsi
	callq	*%rbx
	leaq	928(%rsp), %rdi
	movq	%r15, %rsi
	callq	*%rbx
	leaq	960(%rsp), %rdi
	leaq	664(%r14), %rsi
	callq	*%rbx
	leaq	496(%rsp), %rdi
	leaq	704(%r14), %rsi
	callq	*%rbx
	leaq	832(%rsp), %rdi
	movq	%r13, %rsi
	callq	*%rbx
	leaq	200(%r14), %rax
	movl	$0, 256(%rsp)
	movups	928(%rsp), %xmm0
	movups	944(%rsp), %xmm1
	movups	%xmm0, 264(%rsp)
	movups	%xmm1, 280(%rsp)
	movl	$1, 296(%rsp)
	movups	960(%rsp), %xmm0
	movups	976(%rsp), %xmm1
	movups	%xmm0, 304(%rsp)
	movups	%xmm1, 320(%rsp)
	movl	$2, 336(%rsp)
	movups	496(%rsp), %xmm0
	movups	512(%rsp), %xmm1
	movups	%xmm0, 344(%rsp)
	movups	%xmm1, 360(%rsp)
	movl	$3, 376(%rsp)
	movq	$4, 384(%rsp)
	movq	%rax, 392(%rsp)
	movl	$4, 416(%rsp)
	movdqu	832(%rsp), %xmm0
	movups	848(%rsp), %xmm1
	movups	%xmm1, 440(%rsp)
	movdqu	%xmm0, 424(%rsp)
	movl	$5, 456(%rsp)
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.10(%rip), %rax
	movq	%rax, 856(%rsp)
	movq	$10, 864(%rsp)
	leaq	576(%r14), %rax
	movq	%rax, 832(%rsp)
	movq	%rbp, 840(%rsp)
	movq	$6, 848(%rsp)
	leaq	832(%rsp), %rsi
	movq	%r12, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api6deviceNtB2_6Device17create_bind_group@GOTPCREL(%rip)
	movq	%rax, %r13
	movq	%rax, 496(%rsp)
	leaq	496(%rsp), %rdx
	movq	%r14, %rdi
	movq	1016(%rsp), %rsi
	callq	_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer6submit
	movq	%rax, %r12
	movq	56(%rsp), %r15
	shlq	$32, %r15
	addq	88(%rsp), %r15
	leaq	840(%r14), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.LBB105_120
	lock		decq	(%rax)
	jne	.LBB105_120
	#MEMBARRIER
	leaq	840(%r14), %rdi
	callq	*_RNvMsn_NtCscdodAO9FK5_5alloc4syncINtB5_3ArcNtNtNtCs7GypIiIHh8y_4wgpu7backend9wgpu_core13CoreBindGroupE9drop_slowBL_@GOTPCREL(%rip)
.LBB105_120:
	movq	%r13, 840(%r14)
	movq	%r15, 848(%r14)
	movq	352(%r14), %rax
	incq	%rax
	movq	$-1, %rdx
	cmovneq	%rax, %rdx
	movq	16(%r14), %rcx
	shlq	$4, %rcx
	movq	40(%r14), %rax
	movq	96(%rsp), %r13
	leaq	(%rcx,%r13,4), %rsi
	leaq	(%rsi,%rax,8), %rsi
	movq	112(%r14), %rax
	movq	%rax, %rdi
	shlq	$5, %rdi
	addq	%rdi, %rsi
	addq	$48, %rsi
	movq	(%r14), %rdi
	shlq	$4, %rdi
	movq	24(%r14), %r8
	leaq	(%rdi,%r8,8), %rdi
	movq	72(%r14), %r8
	addq	48(%r14), %r8
	leaq	(%rdi,%r8,4), %r10
	movq	808(%r14), %rdi
	addq	800(%r14), %rdi
	movq	656(%r14), %r9
	addq	616(%r14), %r9
	addq	696(%r14), %r9
	addq	736(%r14), %r9
	movq	96(%r14), %r8
	shlq	$5, %r8
	addq	%r10, %r8
	addq	776(%r14), %r9
	movl	336(%r14), %r10d
	movq	312(%r14), %r11
	movq	304(%r14), %r15
	movq	%rdx, 352(%r14)
	movq	48(%rsp), %rbp
	movq	%rbp, 360(%r14)
	movq	152(%rsp), %rbx
	leaq	(%rbx,%rbx), %rdx
	movq	%rdx, 368(%r14)
	movq	%rbx, %rdx
	subq	%r13, %rdx
	movq	$1, 376(%r14)
	movq	%rbp, 384(%r14)
	movq	%r13, 392(%r14)
	movq	%rbx, 400(%r14)
	movq	%rdx, 408(%r14)
	movq	32(%rsp), %rdx
	movq	%rdx, 416(%r14)
	movq	16(%rsp), %rdx
	movq	%rdx, 424(%r14)
	movq	64(%rsp), %rdx
	movq	%rdx, 432(%r14)
	movq	%rsi, 440(%r14)
	movq	%rcx, 448(%r14)
	movq	792(%rsp), %rcx
	movq	%rcx, 456(%r14)
	movq	%rbp, %rcx
	movq	800(%rsp), %rdx
	subq	%rdx, %rcx
	movq	%rdx, 464(%r14)
	movq	%rcx, 472(%r14)
	movq	488(%rsp), %rcx
	movq	%rcx, 480(%r14)
	movq	%r9, 488(%r14)
	imulq	%r10, %r10
	movq	%r10, 496(%r14)
	addq	%r11, %r15
	movq	%r11, 504(%r14)
	movq	%r15, 512(%r14)
	movq	%r8, 520(%r14)
	movq	%rax, 528(%r14)
	movq	%rdi, 536(%r14)
	movb	$0, 544(%r14)
	movq	(%rsp), %rbx
	movq	%r12, 8(%rbx)
	movl	$-1, (%rbx)
	jmp	.LBB105_30
.LBB105_121:
	movq	$0, 16(%rsp)
	xorl	%eax, %eax
	movq	$0, 32(%rsp)
	jmp	.LBB105_124
.LBB105_122:
	incq	32(%rsp)
.LBB105_123:
	addq	$8, %rax
	cmpq	%rax, %rdi
	je	.LBB105_113
.LBB105_124:
	movl	4(%r8,%rax), %ecx
	movl	%ecx, %edx
	negl	%edx
	jo	.LBB105_122
	cmpl	%ecx, (%r8,%rax)
	je	.LBB105_123
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.62(%rip), %rdi
	callq	*_RNvNtNtCs4NRVxsYgnAr_4core9panicking11panic_const23panic_const_rem_by_zero@GOTPCREL(%rip)
.LBB105_127:
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.12(%rip), %rdi
	callq	*_RNvNtCs4NRVxsYgnAr_4core6option13unwrap_failed@GOTPCREL(%rip)
.LBB105_128:
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.13(%rip), %rdx
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB105_129:
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.11(%rip), %rdx
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB105_130:
	movq	%r13, 840(%r14)
	movq	%r15, 848(%r14)
	movq	%rax, %rdi
	callq	_Unwind_Resume@PLT
.LBB105_131:
	movq	%rax, %rbx
	lock		decq	(%r13)
	jne	.LBB105_135
	#MEMBARRIER
	leaq	496(%rsp), %rdi
	callq	*_RNvMsn_NtCscdodAO9FK5_5alloc4syncINtB5_3ArcNtNtNtCs7GypIiIHh8y_4wgpu7backend9wgpu_core13CoreBindGroupE9drop_slowBL_@GOTPCREL(%rip)
	jmp	.LBB105_135
.LBB105_133:
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking16panic_in_cleanup@GOTPCREL(%rip)
.LBB105_134:
	movq	%rax, %rbx
	movq	$0, (%r15)
.LBB105_135:
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
	.size	_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer6render, .Lfunc_end105-_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer6render
	.section	.text._RNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_13PaintRenderer13prepare_paint,"ax",@progbits
	.globl	_RNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_13PaintRenderer13prepare_paint
	.p2align	4
	.type	_RNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_13PaintRenderer13prepare_paint,@function
_RNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_13PaintRenderer13prepare_paint:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$152, %rsp
	movq	%rdi, %rbx
	cmpq	$0, 840(%rsi)
	je	.LBB111_1
	movq	%r8, %r15
	movq	%rcx, %r12
	movq	%rsi, %r13
	movq	%rdx, 128(%rsp)
	movq	_RNvMNtNtCs7GypIiIHh8y_4wgpu3api12texture_viewNtB2_11TextureView7texture@GOTPCREL(%rip), %r14
	movq	%r8, %rdi
	callq	*%r14
	movq	%rax, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api7textureNtB2_7Texture5width@GOTPCREL(%rip)
	movl	%eax, %ebp
	movq	%r15, %rdi
	callq	*%r14
	movq	%rax, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api7textureNtB2_7Texture6height@GOTPCREL(%rip)
	shlq	$32, %rax
	movl	%ebp, %ecx
	orq	%rax, %rcx
	cmpq	848(%r13), %rcx
	jne	.LBB111_50
	movq	%r15, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api12texture_viewNtB2_11TextureView7texture@GOTPCREL(%rip)
	leaq	16(%rsp), %rdi
	movq	%rax, %rsi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api7textureNtB2_7Texture6format@GOTPCREL(%rip)
	movl	16(%rsp), %eax
	cmpl	856(%r13), %eax
	jne	.LBB111_50
	cmpl	$76, %eax
	jne	.LBB111_7
	movl	20(%rsp), %eax
	cmpl	860(%r13), %eax
	jne	.LBB111_50
	movl	24(%rsp), %eax
	cmpl	864(%r13), %eax
	jne	.LBB111_50
.LBB111_7:
	testq	%r12, %r12
	je	.LBB111_8
	leaq	(%r12,%r12,2), %rax
	movq	128(%rsp), %r9
	leaq	(%r9,%rax,8), %rax
	movq	%rax, 88(%rsp)
	movq	$0, 80(%rsp)
	xorl	%eax, %eax
	movq	$0, (%rsp)
	movq	%r12, 56(%rsp)
	movq	%rbx, 8(%rsp)
	movq	%r13, 104(%rsp)
.LBB111_32:
	movl	(%r9), %edx
	testb	$1, %al
	je	.LBB111_35
	cmpl	%edx, %ecx
	jae	.LBB111_34
.LBB111_35:
	movq	888(%r13), %rax
	movq	%rax, 144(%rsp)
	cmpq	%rdx, %rax
	jbe	.LBB111_36
	movq	880(%r13), %rax
	movq	%rax, 96(%rsp)
	movq	%rdx, 48(%rsp)
	leaq	(%rdx,%rdx,2), %r14
	movl	20(%r9), %eax
	movl	%eax, 32(%rsp)
	movq	%r9, %rbp
	movups	4(%r9), %xmm0
	movaps	%xmm0, 16(%rsp)
	leaq	16(%rsp), %rdi
	callq	*_RNvMs_NtNtCslsgujwDfRn_11gpui_canvas6canvas5paintNtB4_9PaintEdit5index@GOTPCREL(%rip)
	movq	96(%rsp), %rcx
	.file	103 "/root/gpui-paint-patch/reactivity" "crates/canvas/src/canvas/paint.rs"
	cmpl	%eax, (%rcx,%r14,4)
	jne	.LBB111_36
	leaq	(%rcx,%r14,4), %rax
	movl	4(%rax), %edi
	testq	%rdi, %rdi
	je	.LBB111_40
	movq	16(%r13), %rax
	movq	%rax, 120(%rsp)
	cmpq	%rdi, %rax
	jbe	.LBB111_53
	movq	%rbp, %rbx
	leaq	4(%rbp), %rax
	movq	8(%r13), %rcx
	shlq	$4, %rdi
	movq	(%rcx,%rdi), %r14
	movl	8(%rcx,%rdi), %r12d
	movq	%rcx, 136(%rsp)
	movl	12(%rcx,%rdi), %ebp
	movl	16(%rax), %ecx
	movl	%ecx, 32(%rsp)
	movups	(%rax), %xmm0
	movaps	%xmm0, 16(%rsp)
	leaq	64(%rsp), %rdi
	leaq	16(%rsp), %rsi
	callq	*_RNvMs_NtNtCslsgujwDfRn_11gpui_canvas6canvas5paintNtB4_9PaintEdit5color@GOTPCREL(%rip)
	movl	76(%rsp), %eax
	movd	%eax, %xmm0
	xorps	%xmm1, %xmm1
	ucomiss	%xmm1, %xmm0
	jne	.LBB111_45
	jnp	.LBB111_44
.LBB111_45:
	cmpl	%eax, %ebp
	jne	.LBB111_44
	leaq	24(%rbx), %rdi
	movq	(%rsp), %r8
	leaq	1(%r8), %rcx
	movl	72(%rsp), %eax
	movq	64(%rsp), %rdx
	xorq	%rdx, %r14
	movl	%r12d, %esi
	xorq	%rax, %rsi
	orq	%r14, %rsi
	jne	.LBB111_47
	movq	%rbx, %rbp
	cmpq	88(%rsp), %rdi
	movq	56(%rsp), %r12
	movq	8(%rsp), %rbx
	je	.LBB111_9
	addq	$48, %rbp
	movq	%rcx, %r13
	movq	48(%rsp), %rax
	movq	%r15, 112(%rsp)
	.p2align	4
.LBB111_11:
	movl	-24(%rbp), %ecx
	cmpl	%ecx, %eax
	jae	.LBB111_18
	cmpq	%rcx, 144(%rsp)
	jbe	.LBB111_37
	leaq	-24(%rbp), %r14
	movq	%rcx, 48(%rsp)
	leaq	(%rcx,%rcx,2), %r15
	movl	20(%r14), %eax
	movl	%eax, 32(%rsp)
	movups	4(%r14), %xmm0
	movaps	%xmm0, 16(%rsp)
	leaq	16(%rsp), %rdi
	callq	*_RNvMs_NtNtCslsgujwDfRn_11gpui_canvas6canvas5paintNtB4_9PaintEdit5index@GOTPCREL(%rip)
	movq	96(%rsp), %rcx
	cmpl	%eax, (%rcx,%r15,4)
	jne	.LBB111_37
	leaq	(%rcx,%r15,4), %rax
	movl	4(%rax), %edi
	testq	%rdi, %rdi
	je	.LBB111_41
	cmpq	%rdi, 120(%rsp)
	jbe	.LBB111_53
	movq	%rbp, %rbx
	shlq	$4, %rdi
	movq	136(%rsp), %rax
	movq	(%rax,%rdi), %rbp
	movl	8(%rax,%rdi), %r12d
	movl	12(%rax,%rdi), %r15d
	movl	20(%r14), %eax
	movl	%eax, 32(%rsp)
	movups	4(%r14), %xmm0
	movaps	%xmm0, 16(%rsp)
	leaq	64(%rsp), %rdi
	leaq	16(%rsp), %rsi
	callq	*_RNvMs_NtNtCslsgujwDfRn_11gpui_canvas6canvas5paintNtB4_9PaintEdit5color@GOTPCREL(%rip)
	movl	76(%rsp), %eax
	movd	%eax, %xmm0
	xorps	%xmm1, %xmm1
	ucomiss	%xmm1, %xmm0
	jne	.LBB111_20
	jnp	.LBB111_17
.LBB111_20:
	cmpl	%eax, %r15d
	jne	.LBB111_17
	movl	72(%rsp), %eax
	movq	64(%rsp), %rdx
	xorq	%rdx, %rbp
	xorl	%eax, %r12d
	orq	%rbp, %r12
	jne	.LBB111_22
	movq	%rbx, %rbp
	addq	$24, %rbp
	addq	$24, %r14
	incq	%r13
	cmpq	88(%rsp), %r14
	movq	112(%rsp), %r15
	movq	56(%rsp), %r12
	movq	8(%rsp), %rbx
	movq	48(%rsp), %rax
	jne	.LBB111_11
	jmp	.LBB111_30
.LBB111_47:
	movl	68(%rsp), %esi
	movq	%r8, %r13
	movq	%rdi, %r9
	movq	%rcx, (%rsp)
	movq	48(%rsp), %rdi
	movl	%edi, %ecx
	movq	56(%rsp), %r12
	movq	8(%rsp), %rbx
	ucomiss	.LCPI111_0(%rip), %xmm0
	jne	.LBB111_31
	jp	.LBB111_31
.LBB111_24:
	leaq	(%rdi,%rdi,2), %rdi
	movq	96(%rsp), %r8
	cmpb	$0, 8(%r8,%rdi,4)
	je	.LBB111_31
	testl	%edx, %edx
	sets	%dil
	andl	$2147483647, %edx
	addl	$-8388608, %edx
	cmpl	$2130706432, %edx
	setae	%dl
	movl	$6, %r8d
	testb	%dil, %dl
	jne	.LBB111_28
	testl	%esi, %esi
	sets	%dl
	andl	$2147483647, %esi
	addl	$-8388608, %esi
	cmpl	$2130706432, %esi
	setae	%sil
	testb	%dl, %sil
	jne	.LBB111_28
	testl	%eax, %eax
	setns	%dl
	andl	$2147483647, %eax
	addl	$-8388608, %eax
	cmpl	$2130706432, %eax
	setb	%al
	orb	%dl, %al
	je	.LBB111_28
.LBB111_31:
	incq	80(%rsp)
	movb	$1, %al
	cmpq	88(%rsp), %r9
	movq	104(%rsp), %r13
	jne	.LBB111_32
	jmp	.LBB111_9
.LBB111_22:
	movq	%rdx, %rsi
	shrq	$32, %rsi
	leaq	1(%r13), %rcx
	movq	%rcx, (%rsp)
	movq	48(%rsp), %rdi
	movl	%edi, %ecx
	movq	112(%rsp), %r15
	movq	56(%rsp), %r12
	movq	%rbx, %r9
	movq	8(%rsp), %rbx
	ucomiss	.LCPI111_0(%rip), %xmm0
	jne	.LBB111_31
	jnp	.LBB111_24
	jmp	.LBB111_31
.LBB111_50:
	movq	$1, 8(%rbx)
.LBB111_51:
	movq	$0, (%rbx)
	jmp	.LBB111_52
.LBB111_1:
	xorps	%xmm0, %xmm0
	movups	%xmm0, (%rbx)
	movq	$0, 16(%rbx)
.LBB111_52:
	movq	%rbx, %rax
	addq	$152, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB111_8:
	movq	$0, 80(%rsp)
.LBB111_9:
	movq	%r13, (%rbx)
	movq	128(%rsp), %rax
	movq	%rax, 8(%rbx)
	movq	%r12, 16(%rbx)
	movq	%r15, 24(%rbx)
	movq	80(%rsp), %rax
	movq	%rax, 32(%rbx)
	jmp	.LBB111_52
.LBB111_36:
	movq	(%rsp), %r13
.LBB111_37:
	movq	$2, 8(%rbx)
	movq	%r13, 16(%rbx)
	jmp	.LBB111_51
.LBB111_30:
	movq	104(%rsp), %r13
	jmp	.LBB111_9
.LBB111_34:
	movq	(%rsp), %r13
.LBB111_18:
	movq	$3, 8(%rbx)
	movq	%r13, 16(%rbx)
	jmp	.LBB111_51
.LBB111_40:
	movq	(%rsp), %r13
.LBB111_41:
	movq	$4, 8(%rbx)
	movq	%r13, 16(%rbx)
	jmp	.LBB111_51
.LBB111_44:
	movq	(%rsp), %r13
.LBB111_17:
	movq	8(%rsp), %rbx
	movl	$5, %r8d
.LBB111_28:
	movq	%r8, 8(%rbx)
	movq	%r13, 16(%rbx)
	jmp	.LBB111_51
.LBB111_53:
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.53(%rip), %rdx
	movq	120(%rsp), %rsi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
	.size	_RNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_13PaintRenderer13prepare_paint, .Lfunc_end111-_RNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_13PaintRenderer13prepare_paint
	.section	.text._RNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_13PaintRenderer6render,"ax",@progbits
	.globl	_RNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_13PaintRenderer6render
	.p2align	4
	.type	_RNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_13PaintRenderer6render,@function
_RNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_13PaintRenderer6render:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$1688, %rsp
	movq	%r8, 200(%rsp)
	movq	%rdx, 24(%rsp)
	movq	$0, 888(%rsi)
	leaq	840(%rsi), %r15
	movq	840(%rsi), %rax
	testq	%rax, %rax
	je	.LBB116_3
	lock		decq	(%rax)
	jne	.LBB116_3
	#MEMBARRIER
	movq	%rdi, %rbx
	movq	%r15, %rdi
	movq	%rsi, %r14
	movq	%rcx, %r12
	movq	%r9, %r13
	callq	*_RNvMsn_NtCscdodAO9FK5_5alloc4syncINtB5_3ArcNtNtNtCs7GypIiIHh8y_4wgpu7backend9wgpu_core13CoreBindGroupE9drop_slowBL_@GOTPCREL(%rip)
	movq	%r13, %r9
	movq	%r12, %rcx
	movq	%r14, %rsi
	movq	%rbx, %rdi
.LBB116_3:
	movq	%rcx, 872(%rsp)
	movq	%rdi, 16(%rsp)
	movq	%rsi, 8(%rsp)
	leaq	872(%rsi), %rax
	movq	%r15, 800(%rsp)
	movq	$0, (%r15)
	movq	%rax, 32(%rsp)
	movq	(%rax), %rax
	testq	%r9, %r9
	movq	%r9, 40(%rsp)
	je	.LBB116_5
	leaq	(,%r9,4), %rcx
	cmpq	%rcx, %rax
	ja	.LBB116_6
	jmp	.LBB116_7
.LBB116_5:
	testq	%rax, %rax
	je	.LBB116_14
.LBB116_6:
	movq	8(%rsp), %rbx
	movq	880(%rbx), %rdi
	shlq	$2, %rax
	leaq	(%rax,%rax,2), %rsi
	movl	$4, %edx
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	movq	$0, 872(%rbx)
	movq	$4, 880(%rbx)
	movq	$0, 888(%rbx)
	cmpq	$0, 40(%rsp)
	je	.LBB116_15
.LBB116_7:
	movq	200(%rsp), %rax
	movl	(%rax), %r14d
	movl	%r14d, %edi
	callq	*_RNvMNtNtCslsgujwDfRn_11gpui_canvas6canvas5paintNtB2_10PaintIndex5order@GOTPCREL(%rip)
	movq	24(%rsp), %rcx
	movups	(%rcx), %xmm0
	movups	16(%rcx), %xmm1
	movups	32(%rcx), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	224(%rsp), %rdi
	movl	%eax, %esi
	callq	*_RNvMs5_NtNtCslsgujwDfRn_11gpui_canvas6canvas5paintNtB7_13PreparedScene11paint_index@GOTPCREL(%rip)
	cmpl	%r14d, %edx
	sete	%cl
	andb	%al, %cl
	cmpb	$1, %cl
	jne	.LBB116_13
	movq	40(%rsp), %rax
	leaq	(,%rax,4), %r13
	movl	$4, %ebp
	leaq	224(%rsp), %rbx
	movq	_RNvMs5_NtNtCslsgujwDfRn_11gpui_canvas6canvas5paintNtB7_13PreparedScene11paint_index@GOTPCREL(%rip), %r12
	.p2align	4
.LBB116_9:
	cmpq	%rbp, %r13
	je	.LBB116_15
	movq	200(%rsp), %rax
	movl	(%rax,%rbp), %r15d
	cmpl	%r15d, %r14d
	jae	.LBB116_13
	movl	%r15d, %edi
	callq	*_RNvMNtNtCslsgujwDfRn_11gpui_canvas6canvas5paintNtB2_10PaintIndex5order@GOTPCREL(%rip)
	movq	24(%rsp), %rcx
	movups	(%rcx), %xmm0
	movups	16(%rcx), %xmm1
	movups	32(%rcx), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	movq	%rbx, %rdi
	movl	%eax, %esi
	callq	*%r12
	cmpl	$1, %eax
	jne	.LBB116_13
	addq	$4, %rbp
	movl	%r15d, %r14d
	cmpl	%r15d, %edx
	je	.LBB116_9
.LBB116_13:
	movq	16(%rsp), %rax
	movl	$3, (%rax)
	jmp	.LBB116_50
.LBB116_14:
	movq	8(%rsp), %rax
	movq	$4, 880(%rax)
	movq	$0, 888(%rax)
.LBB116_15:
	movq	8(%rsp), %r13
	movq	872(%r13), %rsi
	movq	888(%r13), %rbx
	movq	%rsi, %rax
	subq	%rbx, %rax
	movq	40(%rsp), %r15
	cmpq	%rax, %r15
	movq	800(%rsp), %r14
	jbe	.LBB116_20
	addq	%r15, %rbx
	jae	.LBB116_18
.LBB116_17:
	movq	16(%rsp), %rax
	movl	$5, (%rax)
	jmp	.LBB116_50
.LBB116_18:
	movq	880(%r13), %rdx
	leaq	224(%rsp), %rdi
	movl	$4, %r8d
	movl	$12, %r9d
	movq	%rbx, %rcx
	callq	_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner11finish_growCsdsK2Jbz6dnh_8gpui_gpu
	cmpl	$1, 224(%rsp)
	je	.LBB116_17
	movq	232(%rsp), %rax
	movq	%rax, 880(%r13)
	movq	%rbx, 872(%r13)
.LBB116_20:
	movq	$0, 1080(%rsp)
	movq	200(%rsp), %rax
	movq	%rax, 1224(%rsp)
	movq	%r15, 1232(%rsp)
	leaq	1080(%rsp), %rax
	movq	%rax, 1240(%rsp)
	movq	32(%rsp), %rax
	movq	%rax, 1248(%rsp)
	movq	(%r14), %rax
	testq	%rax, %rax
	je	.LBB116_23
	lock		decq	(%rax)
	jne	.LBB116_23
	#MEMBARRIER
	movq	%r14, %rdi
	callq	*_RNvMsn_NtCscdodAO9FK5_5alloc4syncINtB5_3ArcNtNtNtCs7GypIiIHh8y_4wgpu7backend9wgpu_core13CoreBindGroupE9drop_slowBL_@GOTPCREL(%rip)
.LBB116_23:
	movq	$0, 840(%r13)
	movq	24(%rsp), %r15
	movl	(%r15), %r14d
	movd	4(%r15), %xmm0
	movq	8(%r15), %rbx
	movl	%r14d, 224(%rsp)
	movd	%xmm0, 200(%rsp)
	movd	%xmm0, 228(%rsp)
	movq	%rbx, 232(%rsp)
	leaq	224(%rsp), %rdi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas5colorNtB5_11ColorConfig8validate@GOTPCREL(%rip)
	cmpl	$-1, %eax
	jne	.LBB116_46
	movl	40(%r15), %ebp
	movl	44(%r15), %r12d
	movq	872(%rsp), %r15
	movq	%r15, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api12texture_viewNtB2_11TextureView7texture@GOTPCREL(%rip)
	movq	%rax, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api7textureNtB2_7Texture5width@GOTPCREL(%rip)
	cmpl	%ebp, %eax
	jne	.LBB116_46
	movq	%r15, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api12texture_viewNtB2_11TextureView7texture@GOTPCREL(%rip)
	movq	%rax, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api7textureNtB2_7Texture6height@GOTPCREL(%rip)
	cmpl	%r12d, %eax
	jne	.LBB116_46
	movq	%r15, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api12texture_viewNtB2_11TextureView7texture@GOTPCREL(%rip)
	leaq	224(%rsp), %rdi
	movq	%rax, %rsi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api7textureNtB2_7Texture6format@GOTPCREL(%rip)
	movl	224(%rsp), %eax
	cmpl	856(%r13), %eax
	jne	.LBB116_46
	cmpl	$76, %eax
	jne	.LBB116_30
	movl	228(%rsp), %eax
	cmpl	860(%r13), %eax
	jne	.LBB116_46
	movl	232(%rsp), %eax
	cmpl	864(%r13), %eax
	jne	.LBB116_46
.LBB116_30:
	movl	$5, %r15d
	cmpl	$16384, %r12d
	ja	.LBB116_47
	cmpl	$16384, %ebp
	ja	.LBB116_47
	movq	%r12, %rax
	imulq	%rbp, %rax
	addq	$-16777217, %rax
	cmpq	$-16777216, %rax
	jb	.LBB116_47
	movq	%r12, 40(%rsp)
	movq	24(%rsp), %r12
	movdqu	(%r12), %xmm0
	movups	16(%r12), %xmm1
	movups	32(%r12), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movdqa	%xmm0, 224(%rsp)
	leaq	672(%rsp), %rdi
	leaq	224(%rsp), %rsi
	callq	*_RNvMsa_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedScene5draws@GOTPCREL(%rip)
	movq	680(%rsp), %rax
	subq	672(%rsp), %rax
	cmpq	$262144, %rax
	ja	.LBB116_47
	movd	24(%r12), %xmm0
	movd	%xmm0, %eax
	andl	$2147483647, %eax
	cmpl	$2139095039, %eax
	jg	.LBB116_46
	pand	.LCPI116_0(%rip), %xmm0
	ucomiss	.LCPI116_1(%rip), %xmm0
	ja	.LBB116_46
	movq	24(%rsp), %rax
	movd	28(%rax), %xmm0
	movd	%xmm0, %eax
	andl	$2147483647, %eax
	cmpl	$2139095039, %eax
	jg	.LBB116_46
	pand	.LCPI116_0(%rip), %xmm0
	ucomiss	.LCPI116_1(%rip), %xmm0
	ja	.LBB116_46
	movq	24(%rsp), %rax
	movd	32(%rax), %xmm0
	movd	%xmm0, %eax
	andl	$2147483647, %eax
	cmpl	$2139095039, %eax
	jg	.LBB116_46
	pand	.LCPI116_0(%rip), %xmm0
	ucomiss	.LCPI116_1(%rip), %xmm0
	ja	.LBB116_46
	movq	24(%rsp), %rax
	movd	36(%rax), %xmm0
	movd	%xmm0, %eax
	andl	$2147483647, %eax
	cmpl	$2139095039, %eax
	jg	.LBB116_46
	movdqa	.LCPI116_0(%rip), %xmm1
	pand	%xmm0, %xmm1
	ucomiss	.LCPI116_1(%rip), %xmm1
	ja	.LBB116_46
	xorps	%xmm1, %xmm1
	ucomiss	%xmm1, %xmm0
	jb	.LBB116_46
	movss	.LCPI116_2(%rip), %xmm1
	movss	%xmm1, 492(%rsp)
	ucomiss	%xmm0, %xmm1
	jb	.LBB116_46
	movl	856(%r13), %eax
	movl	%eax, 812(%rsp)
	shrq	$40, %rbx
	cmpl	$40, %eax
	jne	.LBB116_51
	testb	%bl, %bl
	jne	.LBB116_53
	jmp	.LBB116_142
.LBB116_46:
	movl	$3, %r15d
.LBB116_47:
	movq	16(%rsp), %rax
.LBB116_48:
	movq	$0, 888(%r13)
.LBB116_49:
	movl	%r15d, (%rax)
	movq	80(%rsp), %rcx
	movq	%rcx, 4(%rax)
	movl	88(%rsp), %ecx
	movl	%ecx, 12(%rax)
	movaps	176(%rsp), %xmm0
	movups	%xmm0, 16(%rax)
.LBB116_50:
	addq	$1688, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB116_51:
	testb	%bl, %bl
	jne	.LBB116_142
	ucomiss	.LCPI116_2(%rip), %xmm0
	jne	.LBB116_142
	jp	.LBB116_142
.LBB116_53:
	leaq	15(%rbp), %rcx
	shrq	$4, %rcx
	movq	40(%rsp), %rax
	leal	15(%rax), %r12d
	shrl	$4, %r12d
	movq	8(%rsp), %r13
	leaq	24(%r13), %rdi
	movq	$0, 40(%r13)
	movq	%rcx, 120(%rsp)
	imull	%ecx, %r12d
	movq	%rdi, 1072(%rsp)
	movq	%r12, %rsi
	callq	_RNvMs1_NtCscdodAO9FK5_5alloc3vecINtB5_3VecAmj2_E6resizeCsdsK2Jbz6dnh_8gpui_gpu
	movq	$0, 16(%r13)
	movq	24(%rsp), %rax
	movdqu	(%rax), %xmm0
	movups	16(%rax), %xmm1
	movups	32(%rax), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movdqa	%xmm0, 224(%rsp)
	leaq	672(%rsp), %rbx
	leaq	224(%rsp), %rsi
	movq	%rbx, %rdi
	callq	*_RNvMsa_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedScene6groups@GOTPCREL(%rip)
	leaq	869(%r13), %rdx
	leaq	496(%rsp), %rdi
	movq	%rbx, %rsi
	movq	%rdx, 864(%rsp)
	callq	_RINvYNtNtCslsgujwDfRn_11gpui_canvas6canvas6GroupsNtNtNtNtCs4NRVxsYgnAr_4core4iter6traits8iterator8Iterator8try_foldjNCINvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB1Z_8Renderer15render_observedNCNvB1V_6render0Es0_0INtNtBT_6result6ResultjNtB1Z_5ErrorEEB21_
	movl	496(%rsp), %eax
	cmpl	$-1, %eax
	je	.LBB116_55
	movq	500(%rsp), %rcx
	movl	508(%rsp), %edx
	movdqu	512(%rsp), %xmm0
	movdqa	%xmm0, 176(%rsp)
	movq	%rcx, 80(%rsp)
	movl	%edx, 88(%rsp)
	movl	%eax, %r15d
	jmp	.LBB116_143
.LBB116_55:
	movq	504(%rsp), %rsi
	movq	8(%rsp), %r13
	movq	%r13, %rdi
	callq	_RNvMs_NtCscdodAO9FK5_5alloc3vecINtB4_3VecAmj4_E17try_reserve_exactCsdsK2Jbz6dnh_8gpui_gpu
	cmpq	$-1, %rax
	movq	16(%rsp), %rax
	jne	.LBB116_48
	leaq	72(%r13), %rdi
	movq	$0, 88(%r13)
	movq	%rdi, 1064(%rsp)
	movq	%r12, %rsi
	callq	_RNvMs1_NtCscdodAO9FK5_5alloc3vecINtB5_3VecmE6resizeCsdsK2Jbz6dnh_8gpui_gpu
	movq	$0, 112(%r13)
	cmpq	$0, 96(%r13)
	je	.LBB116_91
.LBB116_57:
	movq	8(%rsp), %rcx
	movq	104(%rcx), %rax
	pxor	%xmm0, %xmm0
	movdqu	%xmm0, 16(%rax)
	movdqu	%xmm0, (%rax)
	movq	$1, 112(%rcx)
	leaq	784(%rcx), %rdi
	callq	_RNvMs1_NtNtNtCs2AWtUsOyxgP_3std11collections4hash3mapINtB5_7HashMapAmj8_mE5clearCsdsK2Jbz6dnh_8gpui_gpu
	movq	24(%rsp), %rax
	movups	(%rax), %xmm0
	movups	16(%rax), %xmm1
	movups	32(%rax), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	992(%rsp), %rdi
	leaq	224(%rsp), %rsi
	callq	*_RNvMsa_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedScene6groups@GOTPCREL(%rip)
	movups	992(%rsp), %xmm0
	movups	1008(%rsp), %xmm1
	movaps	%xmm1, 832(%rsp)
	movaps	%xmm0, 816(%rsp)
	leaq	672(%rsp), %rdi
	leaq	816(%rsp), %rsi
	callq	*_RNvXs7_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_6GroupsNtNtNtNtCs4NRVxsYgnAr_4core4iter6traits8iterator8Iterator4next@GOTPCREL(%rip)
	cmpq	$0, 672(%rsp)
	je	.LBB116_82
	movq	$0, 72(%rsp)
	movq	$0, 32(%rsp)
	movq	$0, 776(%rsp)
	movq	$0, 784(%rsp)
	movq	$0, 472(%rsp)
.LBB116_59:
	movq	688(%rsp), %rax
	movq	%rax, 960(%rsp)
	movups	672(%rsp), %xmm0
	movaps	%xmm0, 944(%rsp)
	movups	696(%rsp), %xmm3
	movaps	%xmm3, 48(%rsp)
	movups	712(%rsp), %xmm4
	movaps	%xmm4, 96(%rsp)
	movups	728(%rsp), %xmm5
	movaps	%xmm5, 208(%rsp)
	movups	744(%rsp), %xmm2
	movaps	%xmm2, 160(%rsp)
	leaq	760(%rsp), %r12
	movups	(%r12), %xmm1
	movaps	%xmm1, 976(%rsp)
	movq	8(%rsp), %r15
	movzbl	869(%r15), %esi
	movq	%rax, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	movups	%xmm3, 248(%rsp)
	movups	%xmm4, 264(%rsp)
	movups	%xmm5, 280(%rsp)
	movups	%xmm2, 296(%rsp)
	movups	(%r12), %xmm0
	leaq	312(%rsp), %rax
	movups	%xmm0, (%rax)
	leaq	224(%rsp), %r13
	movq	%r13, %rdi
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer13compact_group
	movl	%eax, %ebx
	movaps	48(%rsp), %xmm0
	movaps	%xmm0, 224(%rsp)
	movaps	96(%rsp), %xmm0
	movaps	%xmm0, 240(%rsp)
	movaps	208(%rsp), %xmm0
	movaps	%xmm0, 256(%rsp)
	movaps	160(%rsp), %xmm0
	movaps	%xmm0, 496(%rsp)
	movq	%r15, %rdi
	movq	%r13, %rsi
	leaq	496(%rsp), %rdx
	callq	_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer10correction
	movl	%eax, 464(%rsp)
	movq	16(%r15), %rcx
	movq	32(%rsp), %rsi
	movq	%rsi, 328(%rsp)
	movq	688(%rsp), %rax
	movq	%rax, 240(%rsp)
	movups	672(%rsp), %xmm0
	movaps	%xmm0, 224(%rsp)
	movaps	48(%rsp), %xmm0
	movups	%xmm0, 248(%rsp)
	movaps	96(%rsp), %xmm0
	movups	%xmm0, 264(%rsp)
	movaps	208(%rsp), %xmm0
	movups	%xmm0, 280(%rsp)
	movaps	160(%rsp), %xmm0
	movups	%xmm0, 296(%rsp)
	movups	(%r12), %xmm0
	leaq	312(%rsp), %rax
	movups	%xmm0, (%rax)
	movq	%rcx, 336(%rsp)
	movb	%bl, 344(%rsp)
	movzbl	%bl, %ebx
	leaq	1224(%rsp), %rdi
	movq	%r13, %rdx
	movl	%ebx, %r8d
	callq	_RNCNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB7_13PaintRenderer6renders0_0Bb_
	movaps	160(%rsp), %xmm0
	movhlps	%xmm0, %xmm0
	movaps	%xmm0, 128(%rsp)
	testb	%bl, %bl
	je	.LBB116_65
	movq	688(%rsp), %rax
	movq	%rax, 240(%rsp)
	movups	672(%rsp), %xmm0
	movaps	%xmm0, 224(%rsp)
	movaps	48(%rsp), %xmm0
	movups	%xmm0, 248(%rsp)
	movaps	96(%rsp), %xmm0
	movups	%xmm0, 264(%rsp)
	movaps	208(%rsp), %xmm0
	movups	%xmm0, 280(%rsp)
	movaps	160(%rsp), %xmm0
	movups	%xmm0, 296(%rsp)
	leaq	760(%rsp), %rax
	movups	(%rax), %xmm0
	leaq	312(%rsp), %rax
	movups	%xmm0, (%rax)
	leaq	1088(%rsp), %rdi
	leaq	224(%rsp), %rsi
	callq	*_RNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedGroup10placements@GOTPCREL(%rip)
	movq	1104(%rsp), %rax
	movq	%rax, 896(%rsp)
	movups	1088(%rsp), %xmm0
	movaps	%xmm0, 880(%rsp)
	movq	$0, 904(%rsp)
	leaq	496(%rsp), %rdi
	leaq	880(%rsp), %rsi
	callq	_RNvXs_NtNtNtCs4NRVxsYgnAr_4core4iter8adapters9enumerateINtB4_9EnumerateINtNtB6_3map3MapINtNtNtBa_5slice4iter4ItermENCNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB1X_13PreparedGroup10placements0EENtNtNtB8_6traits8iterator8Iterator4nextCsdsK2Jbz6dnh_8gpui_gpu
	cmpb	$-1, 504(%rsp)
	je	.LBB116_72
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 144(%rsp)
	movaps	160(%rsp), %xmm0
	unpcklpd	128(%rsp), %xmm0
	movaps	%xmm0, 128(%rsp)
.LBB116_62:
	movq	496(%rsp), %rdx
	addq	32(%rsp), %rdx
	leaq	760(%rsp), %rax
	movups	(%rax), %xmm0
	leaq	312(%rsp), %rax
	movups	%xmm0, 64(%rax)
	leaq	504(%rsp), %rcx
	movups	56(%rcx), %xmm0
	movups	%xmm0, -32(%rax)
	movaps	48(%rsp), %xmm0
	movups	%xmm0, 296(%rsp)
	movaps	96(%rsp), %xmm0
	movups	%xmm0, 312(%rsp)
	movaps	208(%rsp), %xmm0
	movups	%xmm0, 328(%rsp)
	movaps	128(%rsp), %xmm0
	movups	%xmm0, 344(%rsp)
	movups	72(%rcx), %xmm0
	movups	%xmm0, 48(%rax)
	movq	48(%rcx), %rax
	movq	%rax, 272(%rsp)
	movups	(%rcx), %xmm0
	movups	16(%rcx), %xmm1
	movups	32(%rcx), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	608(%rsp), %rdi
	leaq	224(%rsp), %rsi
	movl	%ebp, %ecx
	movq	40(%rsp), %r8
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer13validate_draw
	movl	608(%rsp), %r15d
	cmpl	$-1, %r15d
	jne	.LBB116_85
	movsd	612(%rsp), %xmm0
	movaps	144(%rsp), %xmm2
	movaps	%xmm2, %xmm1
	maxps	%xmm0, %xmm2
	movaps	%xmm2, %xmm0
	cmpunordps	%xmm2, %xmm0
	andps	%xmm0, %xmm1
	andnps	%xmm2, %xmm0
	orps	%xmm1, %xmm0
	movaps	%xmm0, 144(%rsp)
	leaq	496(%rsp), %rdi
	leaq	880(%rsp), %rsi
	callq	_RNvXs_NtNtNtCs4NRVxsYgnAr_4core4iter8adapters9enumerateINtB4_9EnumerateINtNtB6_3map3MapINtNtNtBa_5slice4iter4ItermENCNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB1X_13PreparedGroup10placements0EENtNtNtB8_6traits8iterator8Iterator4nextCsdsK2Jbz6dnh_8gpui_gpu
	cmpb	$-1, 504(%rsp)
	jne	.LBB116_62
	movdqa	144(%rsp), %xmm0
	movd	%xmm0, %ecx
	shufps	$85, %xmm0, %xmm0
	movd	%xmm0, %eax
	shlq	$32, %rax
	orq	%rax, %rcx
	movq	%rcx, 144(%rsp)
	jmp	.LBB116_73
.LBB116_65:
	movq	688(%rsp), %rax
	movq	%rax, 240(%rsp)
	movups	672(%rsp), %xmm0
	movaps	%xmm0, 224(%rsp)
	movaps	48(%rsp), %xmm0
	movups	%xmm0, 248(%rsp)
	movaps	96(%rsp), %xmm0
	movups	%xmm0, 264(%rsp)
	movaps	208(%rsp), %xmm0
	movups	%xmm0, 280(%rsp)
	movaps	160(%rsp), %xmm0
	movups	%xmm0, 296(%rsp)
	leaq	760(%rsp), %rax
	movups	(%rax), %xmm0
	leaq	312(%rsp), %rax
	movups	%xmm0, (%rax)
	leaq	496(%rsp), %rdi
	leaq	224(%rsp), %rsi
	callq	*_RNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedGroup10placements@GOTPCREL(%rip)
	movq	496(%rsp), %rax
	movq	504(%rsp), %rcx
	movq	%rax, 144(%rsp)
	movq	%rcx, 792(%rsp)
	cmpq	%rcx, %rax
	je	.LBB116_71
	movq	512(%rsp), %rax
	movq	%rax, 480(%rsp)
.LBB116_67:
	movq	144(%rsp), %rax
	movl	(%rax), %edx
	leaq	1344(%rsp), %rdi
	movq	480(%rsp), %rsi
	callq	_RNCNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB7_13PreparedGroup10placements0CsdsK2Jbz6dnh_8gpui_gpu
	cmpb	$-1, 1344(%rsp)
	je	.LBB116_81
	leaq	760(%rsp), %rax
	movups	(%rax), %xmm0
	leaq	1576(%rsp), %rax
	movups	%xmm0, 96(%rax)
	leaq	1400(%rsp), %rcx
	movups	(%rcx), %xmm0
	movups	%xmm0, (%rax)
	movaps	48(%rsp), %xmm0
	movups	%xmm0, 1592(%rsp)
	movaps	96(%rsp), %xmm0
	movups	%xmm0, 1608(%rsp)
	movaps	208(%rsp), %xmm0
	movups	%xmm0, 1624(%rsp)
	movaps	160(%rsp), %xmm0
	unpcklpd	128(%rsp), %xmm0
	movups	%xmm0, 1640(%rsp)
	movups	16(%rcx), %xmm0
	movups	%xmm0, 80(%rax)
	movq	1392(%rsp), %rax
	movq	%rax, 1568(%rsp)
	movups	1344(%rsp), %xmm0
	movups	1360(%rsp), %xmm1
	movups	1376(%rsp), %xmm2
	movaps	%xmm2, 1552(%rsp)
	movaps	%xmm1, 1536(%rsp)
	movaps	%xmm0, 1520(%rsp)
	leaq	224(%rsp), %rdi
	leaq	1520(%rsp), %rsi
	movq	32(%rsp), %rdx
	movl	%ebp, %ecx
	movq	40(%rsp), %r8
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer13validate_draw
	movl	224(%rsp), %r15d
	movq	228(%rsp), %r12
	cmpl	$-1, %r15d
	jne	.LBB116_88
	movq	1392(%rsp), %rax
	movq	%rax, 272(%rsp)
	movups	1344(%rsp), %xmm0
	movups	1360(%rsp), %xmm1
	movups	1376(%rsp), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	496(%rsp), %rdi
	leaq	224(%rsp), %rsi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_14PreparedSource4mask@GOTPCREL(%rip)
	movq	496(%rsp), %r13
	movq	8(%rsp), %r15
	movl	16(%r15), %ebx
	movl	$-2147483648, %eax
	orl	%eax, %ebx
	leaq	224(%rsp), %rdi
	leaq	1520(%rsp), %rsi
	movq	%r12, %rdx
	movl	464(%rsp), %ecx
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer12inline_words
	movl	$6, %edx
	movq	%r15, %rdi
	leaq	224(%rsp), %rsi
	callq	_RNvMs1_NtCscdodAO9FK5_5alloc3vecINtB5_3VecAmj4_E17extend_from_sliceCsdsK2Jbz6dnh_8gpui_gpu
	leaq	224(%rsp), %rdi
	movq	%r15, %rsi
	leaq	1520(%rsp), %rdx
	movq	%r12, %rcx
	movl	%ebx, %r8d
	movq	32(%rsp), %r9
	pushq	472(%rsp)
	pushq	48(%rsp)
	pushq	%rbp
	pushq	144(%rsp)
	callq	_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer8bin_draw
	addq	$32, %rsp
	movl	224(%rsp), %r15d
	cmpl	$-1, %r15d
	jne	.LBB116_87
	movq	144(%rsp), %rdx
	addq	$4, %rdx
	testq	%r13, %r13
	setne	%al
	movq	72(%rsp), %rcx
	orb	%al, %cl
	andb	$1, %cl
	movq	%rcx, 72(%rsp)
	movq	232(%rsp), %rax
	movq	%rax, 472(%rsp)
	incq	32(%rsp)
	movq	%rdx, 144(%rsp)
	cmpq	792(%rsp), %rdx
	jne	.LBB116_67
.LBB116_71:
	leaq	1344(%rsp), %rax
	jmp	.LBB116_80
.LBB116_72:
	movq	$0, 144(%rsp)
.LBB116_73:
	movaps	208(%rsp), %xmm1
	movaps	%xmm1, %xmm0
	movaps	%xmm1, %xmm4
	unpckhpd	%xmm1, %xmm0
	movq	8(%rsp), %rdi
	movl	16(%rdi), %eax
	movl	%eax, 128(%rsp)
	movq	144(%rsp), %rdx
	movq	%rdx, %rax
	shrq	$32, %rax
	movapd	48(%rsp), %xmm2
	movapd	%xmm2, %xmm1
	movapd	96(%rsp), %xmm3
	unpcklpd	%xmm3, %xmm1
	cvtpd2ps	%xmm1, %xmm1
	unpckhpd	%xmm3, %xmm2
	cvtpd2ps	%xmm2, %xmm2
	xorps	%xmm3, %xmm3
	cvtsd2ss	%xmm4, %xmm3
	cvtsd2ss	%xmm0, %xmm0
	leaq	760(%rsp), %rcx
	movups	(%rcx), %xmm4
	leaq	312(%rsp), %rbx
	movups	%xmm4, -40(%rbx)
	movlpd	%xmm1, 224(%rsp)
	movss	%xmm3, 232(%rsp)
	movl	%edx, 236(%rsp)
	movlpd	%xmm2, 240(%rsp)
	movss	%xmm0, 248(%rsp)
	movl	%eax, 252(%rsp)
	movaps	160(%rsp), %xmm0
	movups	%xmm0, 256(%rsp)
	movl	464(%rsp), %eax
	movl	%eax, 288(%rsp)
	movq	$0, 292(%rsp)
	movl	$0, 300(%rsp)
	movl	$5, %edx
	leaq	224(%rsp), %r15
	movq	%r15, %rsi
	callq	_RNvMs1_NtCscdodAO9FK5_5alloc3vecINtB5_3VecAmj4_E17extend_from_sliceCsdsK2Jbz6dnh_8gpui_gpu
	incq	776(%rsp)
	movq	960(%rsp), %rax
	movq	%rax, 240(%rsp)
	movaps	944(%rsp), %xmm0
	movaps	%xmm0, 224(%rsp)
	movaps	48(%rsp), %xmm0
	movups	%xmm0, 248(%rsp)
	movaps	96(%rsp), %xmm0
	movups	%xmm0, 264(%rsp)
	movaps	208(%rsp), %xmm0
	movups	%xmm0, 280(%rsp)
	movaps	160(%rsp), %xmm0
	movups	%xmm0, 296(%rsp)
	movaps	976(%rsp), %xmm0
	movups	%xmm0, (%rbx)
	leaq	496(%rsp), %r12
	movq	%r12, %rdi
	movq	%r15, %rsi
	movq	_RNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedGroup10placements@GOTPCREL(%rip), %r13
	callq	*%r13
	movq	504(%rsp), %rax
	subq	496(%rsp), %rax
	shrq	$2, %rax
	addq	%rax, 784(%rsp)
	movq	960(%rsp), %rax
	movq	%rax, 240(%rsp)
	movaps	944(%rsp), %xmm0
	movaps	%xmm0, 224(%rsp)
	movaps	48(%rsp), %xmm0
	movups	%xmm0, 248(%rsp)
	movaps	96(%rsp), %xmm0
	movups	%xmm0, 264(%rsp)
	movaps	208(%rsp), %xmm0
	movups	%xmm0, 280(%rsp)
	movaps	160(%rsp), %xmm0
	movups	%xmm0, 296(%rsp)
	movaps	976(%rsp), %xmm0
	movups	%xmm0, (%rbx)
	movq	%r12, %rdi
	movq	%r15, %rsi
	callq	*%r13
	movq	496(%rsp), %r12
	movq	504(%rsp), %rax
	movq	%rax, 480(%rsp)
	cmpq	%rax, %r12
	je	.LBB116_79
	movq	512(%rsp), %rax
	movq	%rax, 464(%rsp)
.LBB116_75:
	movl	(%r12), %edx
	leaq	1256(%rsp), %rdi
	movq	464(%rsp), %rsi
	callq	_RNCNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB7_13PreparedGroup10placements0CsdsK2Jbz6dnh_8gpui_gpu
	cmpb	$-1, 1256(%rsp)
	je	.LBB116_81
	movaps	976(%rsp), %xmm0
	leaq	312(%rsp), %rax
	movups	%xmm0, 64(%rax)
	leaq	1312(%rsp), %rcx
	movups	(%rcx), %xmm0
	movups	%xmm0, -32(%rax)
	movaps	48(%rsp), %xmm0
	movups	%xmm0, 296(%rsp)
	movaps	96(%rsp), %xmm0
	movups	%xmm0, 312(%rsp)
	movaps	208(%rsp), %xmm0
	movups	%xmm0, 328(%rsp)
	movaps	160(%rsp), %xmm0
	movups	%xmm0, 344(%rsp)
	movups	16(%rcx), %xmm0
	movups	%xmm0, 48(%rax)
	movq	1304(%rsp), %rax
	movq	%rax, 272(%rsp)
	movups	1256(%rsp), %xmm0
	movups	1272(%rsp), %xmm1
	movups	1288(%rsp), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	movq	1304(%rsp), %rax
	movq	%rax, 544(%rsp)
	movups	1256(%rsp), %xmm0
	movupd	1272(%rsp), %xmm1
	movupd	1288(%rsp), %xmm2
	movapd	%xmm2, 528(%rsp)
	movapd	%xmm1, 512(%rsp)
	movaps	%xmm0, 496(%rsp)
	leaq	608(%rsp), %rdi
	leaq	496(%rsp), %rsi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_14PreparedSource4mask@GOTPCREL(%rip)
	movq	608(%rsp), %r13
	movq	8(%rsp), %r15
	movl	16(%r15), %ebx
	movups	280(%rsp), %xmm0
	movaps	%xmm0, 496(%rsp)
	movq	$0, 512(%rsp)
	movl	$0, 520(%rsp)
	movl	128(%rsp), %eax
	movl	%eax, 524(%rsp)
	movl	$2, %edx
	movq	%r15, %rdi
	leaq	496(%rsp), %rsi
	callq	_RNvMs1_NtCscdodAO9FK5_5alloc3vecINtB5_3VecAmj4_E17extend_from_sliceCsdsK2Jbz6dnh_8gpui_gpu
	leaq	496(%rsp), %rdi
	movq	%r15, %rsi
	leaq	224(%rsp), %rdx
	movq	144(%rsp), %rcx
	movl	%ebx, %r8d
	movq	32(%rsp), %r9
	pushq	472(%rsp)
	pushq	48(%rsp)
	pushq	%rbp
	pushq	144(%rsp)
	callq	_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer8bin_draw
	addq	$32, %rsp
	movl	496(%rsp), %r15d
	cmpl	$-1, %r15d
	jne	.LBB116_89
	addq	$4, %r12
	testq	%r13, %r13
	setne	%al
	movq	72(%rsp), %rcx
	orb	%al, %cl
	andb	$1, %cl
	movq	%rcx, 72(%rsp)
	movq	504(%rsp), %rax
	movq	%rax, 472(%rsp)
	incq	32(%rsp)
	cmpq	480(%rsp), %r12
	jne	.LBB116_75
.LBB116_79:
	leaq	1256(%rsp), %rax
.LBB116_80:
	movb	$-1, (%rax)
.LBB116_81:
	leaq	672(%rsp), %rdi
	leaq	816(%rsp), %rsi
	callq	*_RNvXs7_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_6GroupsNtNtNtNtCs4NRVxsYgnAr_4core4iter6traits8iterator8Iterator4next@GOTPCREL(%rip)
	cmpq	$0, 672(%rsp)
	jne	.LBB116_59
	jmp	.LBB116_83
.LBB116_82:
	movq	$0, 472(%rsp)
	movq	$0, 784(%rsp)
	movq	$0, 776(%rsp)
	movq	$0, 32(%rsp)
	movq	$0, 72(%rsp)
.LBB116_83:
	movq	8(%rsp), %rax
	leaq	552(%rax), %rsi
	leaq	560(%rax), %rdx
	leaq	624(%rax), %rcx
	leaq	832(%rax), %r8
	movq	16(%rax), %r9
	movq	24(%rsp), %rax
	movups	(%rax), %xmm0
	movups	16(%rax), %xmm1
	movups	32(%rax), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	subq	$8, %rsp
	leaq	680(%rsp), %rdi
	movq	%rsi, 1064(%rsp)
	movq	%rdx, 1048(%rsp)
	movq	%rcx, 1056(%rsp)
	movq	%r8, 488(%rsp)
	leaq	232(%rsp), %rax
	pushq	%rax
	callq	_RNvNtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer6images7prepare
	addq	$16, %rsp
	movl	672(%rsp), %r15d
	cmpl	$-1, %r15d
	je	.LBB116_86
	movl	684(%rsp), %eax
	movl	%eax, 88(%rsp)
	movq	676(%rsp), %rax
	movq	%rax, 80(%rsp)
	movdqu	688(%rsp), %xmm0
	movdqa	%xmm0, 176(%rsp)
	jmp	.LBB116_143
.LBB116_85:
	movl	620(%rsp), %eax
	movl	%eax, 88(%rsp)
	movups	624(%rsp), %xmm0
	movaps	%xmm0, 176(%rsp)
	movq	612(%rsp), %rax
	movq	%rax, 80(%rsp)
	jmp	.LBB116_143
.LBB116_86:
	movzbl	72(%rsp), %ecx
	andl	$1, %ecx
	leaq	224(%rsp), %rdi
	movq	8(%rsp), %rsi
	movq	24(%rsp), %rdx
	callq	_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer13prepare_atlas
	movl	224(%rsp), %r15d
	cmpl	$-1, %r15d
	je	.LBB116_92
.LBB116_87:
	movq	228(%rsp), %rax
	movl	236(%rsp), %ecx
	movups	240(%rsp), %xmm0
	jmp	.LBB116_90
.LBB116_88:
	movl	236(%rsp), %eax
	movl	%eax, 88(%rsp)
	movups	240(%rsp), %xmm0
	movaps	%xmm0, 176(%rsp)
	movq	%r12, 80(%rsp)
	jmp	.LBB116_143
.LBB116_89:
	movq	500(%rsp), %rax
	movl	508(%rsp), %ecx
	movups	512(%rsp), %xmm0
.LBB116_90:
	movaps	%xmm0, 176(%rsp)
	movq	%rax, 80(%rsp)
	movl	%ecx, 88(%rsp)
	jmp	.LBB116_143
.LBB116_91:
	movq	8(%rsp), %rax
	leaq	96(%rax), %rdi
	callq	*_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer10CorrectionE8grow_oneBP_@GOTPCREL(%rip)
	jmp	.LBB116_57
.LBB116_92:
	movq	232(%rsp), %rax
	movq	%rax, 1032(%rsp)
	movq	24(%rsp), %rax
	movups	(%rax), %xmm0
	movups	16(%rax), %xmm1
	movups	32(%rax), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	944(%rsp), %rdi
	leaq	224(%rsp), %rsi
	callq	*_RNvMsa_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedScene6groups@GOTPCREL(%rip)
	movups	944(%rsp), %xmm0
	movups	960(%rsp), %xmm1
	movaps	%xmm1, 1104(%rsp)
	movaps	%xmm0, 1088(%rsp)
	leaq	496(%rsp), %rdi
	leaq	1088(%rsp), %rsi
	callq	*_RNvXs7_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_6GroupsNtNtNtNtCs4NRVxsYgnAr_4core4iter6traits8iterator8Iterator4next@GOTPCREL(%rip)
	cmpq	$0, 496(%rsp)
	je	.LBB116_106
	movq	8(%rsp), %rax
	addq	$288, %rax
	movq	%rax, 792(%rsp)
	movq	$0, 48(%rsp)
	jmp	.LBB116_95
.LBB116_94:
	leaq	496(%rsp), %rdi
	leaq	1088(%rsp), %rsi
	callq	*_RNvXs7_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_6GroupsNtNtNtNtCs4NRVxsYgnAr_4core4iter6traits8iterator8Iterator4next@GOTPCREL(%rip)
	cmpq	$0, 496(%rsp)
	je	.LBB116_106
.LBB116_95:
	movq	48(%rsp), %r15
	movq	592(%rsp), %rax
	movq	%rax, 768(%rsp)
	movups	576(%rsp), %xmm0
	movaps	%xmm0, 752(%rsp)
	movups	560(%rsp), %xmm0
	movaps	%xmm0, 736(%rsp)
	movups	496(%rsp), %xmm0
	movups	512(%rsp), %xmm1
	movups	528(%rsp), %xmm2
	movups	544(%rsp), %xmm3
	movaps	%xmm3, 720(%rsp)
	movaps	%xmm2, 704(%rsp)
	movaps	%xmm1, 688(%rsp)
	movaps	%xmm0, 672(%rsp)
	movq	864(%rsp), %rax
	movzbl	(%rax), %esi
	movq	592(%rsp), %rax
	movq	%rax, 320(%rsp)
	movups	576(%rsp), %xmm0
	movaps	%xmm0, 304(%rsp)
	movups	560(%rsp), %xmm0
	movaps	%xmm0, 288(%rsp)
	movups	496(%rsp), %xmm0
	movups	512(%rsp), %xmm1
	movups	528(%rsp), %xmm2
	movups	544(%rsp), %xmm3
	movaps	%xmm3, 272(%rsp)
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	224(%rsp), %r12
	movq	%r12, %rdi
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer13compact_group
	movl	%eax, %ebx
	leaq	5(%r15), %rax
	testb	%bl, %bl
	cmoveq	%r15, %rax
	movq	%rax, 48(%rsp)
	movq	%r12, %rdi
	leaq	672(%rsp), %rsi
	callq	*_RNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedGroup10placements@GOTPCREL(%rip)
	movq	224(%rsp), %r15
	movq	232(%rsp), %rax
	movq	%rax, 160(%rsp)
	cmpq	%rax, %r15
	je	.LBB116_94
	movq	240(%rsp), %rax
	movq	%rax, 144(%rsp)
	xorb	$1, %bl
	movzbl	%bl, %ecx
	shll	$2, %ecx
	leaq	1(%rcx), %rax
	movq	%rax, 72(%rsp)
	movq	48(%rsp), %rax
	leaq	(%rax,%rcx), %r12
	incq	%r12
	orq	$2, %rcx
	shlq	$4, %r12
	movq	%rcx, 128(%rsp)
	shll	$4, %ecx
	movq	%rcx, 464(%rsp)
.LBB116_97:
	movl	(%r15), %edx
	leaq	224(%rsp), %rdi
	movq	144(%rsp), %rsi
	callq	_RNCNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB7_13PreparedGroup10placements0CsdsK2Jbz6dnh_8gpui_gpu
	cmpb	$-1, 224(%rsp)
	je	.LBB116_94
	movss	288(%rsp), %xmm0
	movss	%xmm0, 96(%rsp)
	movss	292(%rsp), %xmm0
	movss	%xmm0, 208(%rsp)
	movups	224(%rsp), %xmm0
	movups	240(%rsp), %xmm1
	movups	256(%rsp), %xmm2
	movaps	%xmm0, 880(%rsp)
	movaps	%xmm1, 896(%rsp)
	movaps	%xmm2, 912(%rsp)
	movq	272(%rsp), %rax
	movq	%rax, 928(%rsp)
	movq	%rax, 656(%rsp)
	movaps	%xmm2, 640(%rsp)
	movaps	%xmm1, 624(%rsp)
	movaps	%xmm0, 608(%rsp)
	leaq	816(%rsp), %rdi
	leaq	608(%rsp), %rsi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_14PreparedSource5image@GOTPCREL(%rip)
	cmpb	$2, 816(%rsp)
	jne	.LBB116_101
	movq	272(%rsp), %rax
	movq	%rax, 656(%rsp)
	movups	224(%rsp), %xmm0
	movups	240(%rsp), %xmm1
	movups	256(%rsp), %xmm2
	movaps	%xmm2, 640(%rsp)
	movaps	%xmm1, 624(%rsp)
	movaps	%xmm0, 608(%rsp)
	leaq	608(%rsp), %rdi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_14PreparedSource13corner_radius@GOTPCREL(%rip)
	testl	%eax, %eax
	je	.LBB116_103
	leaq	608(%rsp), %rdi
	leaq	880(%rsp), %rsi
	movss	96(%rsp), %xmm0
	movss	208(%rsp), %xmm1
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer10shape_word
	movq	608(%rsp), %rax
	movl	$1073741824, 176(%rsp)
	movq	%rax, 180(%rsp)
	jmp	.LBB116_104
.LBB116_101:
	movq	848(%rsp), %rax
	movq	%rax, 1024(%rsp)
	movups	816(%rsp), %xmm0
	movups	832(%rsp), %xmm1
	movaps	%xmm1, 1008(%rsp)
	movaps	%xmm0, 992(%rsp)
	movq	480(%rsp), %rax
	movq	(%rax), %rbx
	testq	%rbx, %rbx
	je	.LBB116_151
	movzbl	856(%rsp), %r13d
	movq	848(%rsp), %rax
	movq	%rax, 640(%rsp)
	movups	816(%rsp), %xmm0
	movups	832(%rsp), %xmm1
	movaps	%xmm1, 624(%rsp)
	movaps	%xmm0, 608(%rsp)
	leaq	608(%rsp), %rdi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas5imageNtB5_9ImageView3key@GOTPCREL(%rip)
	movq	%rbx, %rdi
	movq	%rax, %rsi
	movl	%r13d, %edx
	callq	_RNvMNtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer6imagesNtB2_6Images8metadata
	movq	%rax, %rbx
	movl	%eax, 96(%rsp)
	shrq	$32, %rbx
	leaq	880(%rsp), %rdi
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer13rounded_image
	movl	%ebx, %r13d
	orl	$16, %r13d
	testb	%al, %al
	cmovel	%ebx, %r13d
	movq	848(%rsp), %rax
	movq	%rax, 640(%rsp)
	movups	816(%rsp), %xmm0
	movups	832(%rsp), %xmm1
	movaps	%xmm1, 624(%rsp)
	movaps	%xmm0, 608(%rsp)
	leaq	608(%rsp), %rdi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas5imageNtB5_9ImageView5width@GOTPCREL(%rip)
	movl	%eax, %ebx
	leaq	992(%rsp), %rdi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas5imageNtB5_9ImageView6height@GOTPCREL(%rip)
	shll	$16, %eax
	orl	%ebx, %eax
	movl	96(%rsp), %ecx
	movl	%ecx, 176(%rsp)
	movl	%r13d, 180(%rsp)
	movl	%eax, 184(%rsp)
	jmp	.LBB116_104
.LBB116_103:
	leaq	608(%rsp), %rbx
	movq	%rbx, %rdi
	leaq	880(%rsp), %rsi
	callq	*_RNvMs3_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_14PreparedSource4mask@GOTPCREL(%rip)
	movl	$0, 824(%rsp)
	movq	$0, 816(%rsp)
	leaq	176(%rsp), %rdi
	movq	%rbx, %rsi
	leaq	816(%rsp), %rdx
	movq	792(%rsp), %rcx
	callq	_RINvMNtCs4NRVxsYgnAr_4core6optionINtB3_6OptionNtNtCslsgujwDfRn_11gpui_canvas6canvas9GlyphMaskE6map_orAmj3_NCINvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB1P_8Renderer15render_observedNCNvB1L_6render0Es2_0EB1R_
.LBB116_104:
	movq	48(%rsp), %rax
	movq	72(%rsp), %rcx
	leaq	(%rcx,%rax), %rdi
	movq	8(%rsp), %rax
	movq	16(%rax), %rsi
	cmpq	%rsi, %rdi
	jae	.LBB116_152
	addq	$4, %r15
	movq	8(%rsp), %rax
	movq	8(%rax), %rax
	movl	184(%rsp), %ecx
	movl	%ecx, 8(%rax,%r12)
	movq	176(%rsp), %rcx
	movq	%rcx, (%rax,%r12)
	movq	128(%rsp), %rax
	addq	%rax, 48(%rsp)
	addq	464(%rsp), %r12
	cmpq	160(%rsp), %r15
	jne	.LBB116_97
	jmp	.LBB116_94
.LBB116_106:
	movq	8(%rsp), %rax
	movq	40(%rax), %rax
	movq	$0, 128(%rsp)
	testq	%rax, %rax
	je	.LBB116_114
	movq	8(%rsp), %rcx
	movq	32(%rcx), %rcx
	shlq	$3, %rax
	xorl	%edi, %edi
	jmp	.LBB116_110
.LBB116_108:
	movq	128(%rsp), %rdx
	addl	%esi, %edx
	movl	%edx, (%rcx,%rdi,8)
	movq	%rdx, 128(%rsp)
.LBB116_109:
	movl	%edx, 4(%rcx,%rdi,8)
	incq	%rdi
	addq	$-8, %rax
	je	.LBB116_113
.LBB116_110:
	movq	8(%rsp), %rdx
	movq	88(%rdx), %rsi
	cmpq	%rsi, %rdi
	jae	.LBB116_153
	movl	4(%rcx,%rdi,8), %esi
	cmpl	$1, %esi
	jne	.LBB116_108
	movq	8(%rsp), %rdx
	movq	80(%rdx), %r8
	movl	$-2147483648, %edx
	cmpl	$0, (%r8,%rdi,4)
	jne	.LBB116_109
	jmp	.LBB116_108
.LBB116_113:
	movq	128(%rsp), %rax
	movl	%eax, %eax
	movq	%rax, 128(%rsp)
.LBB116_114:
	movq	8(%rsp), %rbx
	leaq	48(%rbx), %rdi
	movq	$0, 64(%rbx)
	movq	%rdi, 144(%rsp)
	movq	128(%rsp), %rsi
	callq	_RNvMs1_NtCscdodAO9FK5_5alloc3vecINtB5_3VecmE6resizeCsdsK2Jbz6dnh_8gpui_gpu
	movq	16(%rbx), %rbx
	movq	32(%rsp), %rax
	movq	%rax, 992(%rsp)
	movq	24(%rsp), %rax
	movups	(%rax), %xmm0
	movups	16(%rax), %xmm1
	movups	32(%rax), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	608(%rsp), %rdi
	leaq	224(%rsp), %rsi
	callq	*_RNvMsa_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedScene6groups@GOTPCREL(%rip)
	movdqu	608(%rsp), %xmm0
	movups	624(%rsp), %xmm1
	movaps	%xmm1, 512(%rsp)
	movdqa	%xmm0, 496(%rsp)
	jmp	.LBB116_117
.LBB116_115:
	movb	$-1, 1432(%rsp)
.LBB116_116:
	leaq	-5(%rbx), %rax
	cmpb	$0, 72(%rsp)
	cmovneq	%rax, %rbx
.LBB116_117:
	leaq	1120(%rsp), %rdi
	leaq	496(%rsp), %rsi
	callq	*_RNvXs8_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_6GroupsNtNtNtNtCs4NRVxsYgnAr_4core4iter6traits12double_ended19DoubleEndedIterator9next_back@GOTPCREL(%rip)
	cmpq	$0, 1120(%rsp)
	je	.LBB116_122
	movq	864(%rsp), %rax
	movzbl	(%rax), %esi
	movq	1216(%rsp), %rax
	movq	%rax, 320(%rsp)
	movups	1200(%rsp), %xmm0
	movaps	%xmm0, 304(%rsp)
	movups	1184(%rsp), %xmm0
	movaps	%xmm0, 288(%rsp)
	movups	1120(%rsp), %xmm0
	movups	1136(%rsp), %xmm1
	movups	1152(%rsp), %xmm2
	movups	1168(%rsp), %xmm3
	movaps	%xmm3, 272(%rsp)
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movaps	%xmm0, 224(%rsp)
	leaq	224(%rsp), %r15
	movq	%r15, %rdi
	callq	_RNvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer13compact_group
	movb	%al, 72(%rsp)
	movq	1216(%rsp), %rax
	movq	%rax, 320(%rsp)
	movups	1200(%rsp), %xmm0
	movaps	%xmm0, 304(%rsp)
	movups	1184(%rsp), %xmm0
	movaps	%xmm0, 288(%rsp)
	movdqu	1120(%rsp), %xmm0
	movups	1136(%rsp), %xmm1
	movups	1152(%rsp), %xmm2
	movups	1168(%rsp), %xmm3
	movaps	%xmm3, 272(%rsp)
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movdqa	%xmm0, 224(%rsp)
	leaq	672(%rsp), %rdi
	movq	%r15, %rsi
	callq	*_RNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB5_13PreparedGroup10placements@GOTPCREL(%rip)
	movq	672(%rsp), %rax
	movq	680(%rsp), %r12
	movq	%rax, 48(%rsp)
	cmpq	%r12, %rax
	je	.LBB116_115
	movq	688(%rsp), %rax
	movq	%rax, 96(%rsp)
	movzbl	72(%rsp), %eax
	leal	(,%rax,4), %ecx
	orq	$-6, %rcx
	xorl	%edx, %edx
	testb	%al, %al
	sete	%dl
	shll	$31, %edx
	movl	%edx, 160(%rsp)
	movq	%rcx, 208(%rsp)
	leal	(%rcx,%rbx), %r15d
.LBB116_120:
	movl	-4(%r12), %edx
	leaq	1432(%rsp), %rdi
	movq	96(%rsp), %rsi
	callq	_RNCNvMs5_NtCslsgujwDfRn_11gpui_canvas6canvasNtB7_13PreparedGroup10placements0CsdsK2Jbz6dnh_8gpui_gpu
	cmpb	$-1, 1432(%rsp)
	je	.LBB116_116
	decq	992(%rsp)
	addq	$-4, %r12
	movq	208(%rsp), %r13
	addq	%r13, %rbx
	movl	160(%rsp), %eax
	orl	%r15d, %eax
	movl	%eax, 880(%rsp)
	leaq	1488(%rsp), %rcx
	movups	(%rcx), %xmm0
	leaq	280(%rsp), %rax
	movups	%xmm0, (%rax)
	leaq	1144(%rsp), %rdx
	movups	(%rdx), %xmm0
	movups	16(%rdx), %xmm1
	movups	32(%rdx), %xmm2
	movups	%xmm2, 48(%rax)
	movups	%xmm1, 32(%rax)
	movups	%xmm0, 16(%rax)
	movups	48(%rdx), %xmm0
	movups	%xmm0, 64(%rax)
	movups	16(%rcx), %xmm0
	movups	%xmm0, 80(%rax)
	movups	64(%rdx), %xmm0
	movups	%xmm0, 96(%rax)
	movq	1480(%rsp), %rax
	movq	%rax, 272(%rsp)
	movdqu	1432(%rsp), %xmm0
	movups	1448(%rsp), %xmm1
	movups	1464(%rsp), %xmm2
	movaps	%xmm2, 256(%rsp)
	movaps	%xmm1, 240(%rsp)
	movdqa	%xmm0, 224(%rsp)
	movq	1072(%rsp), %rax
	movq	%rax, 672(%rsp)
	movq	144(%rsp), %rax
	movq	%rax, 680(%rsp)
	movq	1064(%rsp), %rax
	movq	%rax, 688(%rsp)
	leaq	992(%rsp), %rax
	movq	%rax, 696(%rsp)
	leaq	880(%rsp), %rax
	movq	%rax, 704(%rsp)
	leaq	224(%rsp), %rdi
	movq	120(%rsp), %rsi
	leaq	672(%rsp), %rdx
	callq	_RINvNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5visitNCINvMs2_B2_NtB2_8Renderer15render_observedNCNvBL_6render0Es3_0EB4_
	addl	%r13d, %r15d
	cmpq	48(%rsp), %r12
	jne	.LBB116_120
	jmp	.LBB116_115
.LBB116_122:
	movq	8(%rsp), %rax
	movq	40(%rax), %rdi
	xorl	%esi, %esi
	testq	%rdi, %rdi
	je	.LBB116_133
	movq	8(%rsp), %rax
	movq	32(%rax), %r8
	shlq	$3, %rdi
	cmpl	$0, 120(%rsp)
	je	.LBB116_145
	movq	$0, 96(%rsp)
	movq	$0, 48(%rsp)
	xorl	%r12d, %r12d
	xorl	%r9d, %r9d
	xorl	%ecx, %ecx
	movq	40(%rsp), %r15
	jmp	.LBB116_127
.LBB116_125:
	incq	%r12
.LBB116_126:
	incq	%r9
	cmpq	120(%rsp), %r9
	movl	$0, %eax
	cmoveq	%rax, %r9
	incq	%rcx
	addq	$-8, %rdi
	je	.LBB116_135
.LBB116_127:
	movl	4(%r8,%rcx,8), %r10d
	movl	%r10d, %eax
	negl	%eax
	jo	.LBB116_125
	subl	(%r8,%rcx,8), %r10d
	je	.LBB116_126
	movq	%rcx, %rax
	shrq	$32, %rax
	je	.LBB116_131
	movq	%rcx, %rax
	xorl	%edx, %edx
	divq	120(%rsp)
	movq	%r9, %rdx
	jmp	.LBB116_132
.LBB116_131:
	movl	%ecx, %eax
	xorl	%edx, %edx
	divl	120(%rsp)
.LBB116_132:
	shll	$4, %edx
	shll	$4, %eax
	leal	16(%rdx), %r11d
	cmpl	%r11d, %ebp
	cmovbl	%ebp, %r11d
	leal	16(%rax), %ebx
	cmpl	%ebx, %r15d
	cmovbl	%r15d, %ebx
	subl	%edx, %r11d
	subl	%eax, %ebx
	imull	%r11d, %ebx
	shlq	$4, %rbx
	addq	%rbx, 48(%rsp)
	imulq	%r10, %rbx
	addq	%rbx, 96(%rsp)
	jmp	.LBB116_126
.LBB116_133:
	xorl	%r12d, %r12d
	movq	$0, 48(%rsp)
.LBB116_134:
	movq	$0, 96(%rsp)
.LBB116_135:
	testb	$1, %r14b
	je	.LBB116_137
	movd	200(%rsp), %xmm0
	movd	%xmm0, %eax
	testl	%eax, %eax
	sets	%cl
	movl	%eax, %edx
	andl	$2147483647, %edx
	addl	$-8388608, %edx
	cmpl	$2130706432, %edx
	setae	%dl
	orb	%cl, %dl
	decl	%eax
	cmpl	$8388607, %eax
	setae	%al
	movl	$2, %esi
	movd	%xmm0, 492(%rsp)
	testb	%dl, %al
	jne	.LBB116_142
.LBB116_137:
	movq	24(%rsp), %rdx
	leaq	24(%rdx), %rax
	xorl	%ecx, %ecx
	cmpl	$40, 812(%rsp)
	sete	%cl
	movzbl	12(%rdx), %edx
	leal	(%rsi,%rcx,4), %ecx
	orl	%edx, %ecx
	movups	(%rax), %xmm0
	movups	%xmm0, 688(%rsp)
	movl	%ebp, 672(%rsp)
	movq	40(%rsp), %rax
	movl	%eax, 676(%rsp)
	movq	120(%rsp), %rax
	movl	%eax, 680(%rsp)
	movl	%ecx, 684(%rsp)
	movss	492(%rsp), %xmm0
	movss	%xmm0, 704(%rsp)
	movq	$0, 708(%rsp)
	movl	$0, 716(%rsp)
	movq	8(%rsp), %r13
	leaq	584(%r13), %rsi
	leaq	672(%rsp), %rcx
	movl	$48, %r8d
	movq	1040(%rsp), %r14
	movq	%r14, %rdi
	xorl	%edx, %edx
	callq	*_RNvMs2_NtNtCs7GypIiIHh8y_4wgpu3api5queueNtB5_5Queue12write_buffer@GOTPCREL(%rip)
	movq	8(%r13), %rcx
	movq	16(%r13), %r8
	shlq	$4, %r8
	movq	1048(%rsp), %rbx
	movq	%rbx, %rdi
	movq	1056(%rsp), %r15
	movq	%r15, %rsi
	movq	%r14, %rdx
	callq	_RNvMs0_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_6Buffer5write
	leaq	664(%r13), %rdi
	movq	32(%r13), %rcx
	movq	40(%r13), %r8
	shlq	$3, %r8
	movq	%r15, %rsi
	movq	%r14, %rdx
	callq	_RNvMs0_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_6Buffer5write
	leaq	704(%r13), %rdi
	movq	56(%r13), %rcx
	movq	64(%r13), %r8
	shlq	$2, %r8
	movq	%r15, %rsi
	movq	%r14, %rdx
	callq	_RNvMs0_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_6Buffer5write
	leaq	744(%r13), %rdi
	movq	104(%r13), %rcx
	movq	112(%r13), %r8
	shlq	$5, %r8
	movq	%r15, %rsi
	movq	%r14, %rdx
	callq	_RNvMs0_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_6Buffer5write
	movq	_RNvMNtNtCs7GypIiIHh8y_4wgpu3api6bufferNtB2_6Buffer17as_entire_binding@GOTPCREL(%rip), %r14
	leaq	224(%rsp), %rdi
	leaq	584(%r13), %rsi
	callq	*%r14
	leaq	816(%rsp), %rdi
	movq	%rbx, %rsi
	callq	*%r14
	leaq	880(%rsp), %rdi
	leaq	664(%r13), %rsi
	callq	*%r14
	leaq	608(%rsp), %rdi
	leaq	704(%r13), %rsi
	callq	*%r14
	leaq	496(%rsp), %rdi
	leaq	744(%r13), %rsi
	callq	*%r14
	leaq	200(%r13), %rax
	movl	$0, 256(%rsp)
	movups	816(%rsp), %xmm0
	movups	832(%rsp), %xmm1
	movups	%xmm0, 264(%rsp)
	movups	%xmm1, 280(%rsp)
	movl	$1, 296(%rsp)
	movups	880(%rsp), %xmm0
	movups	896(%rsp), %xmm1
	movups	%xmm0, 304(%rsp)
	movups	%xmm1, 320(%rsp)
	movl	$2, 336(%rsp)
	movups	608(%rsp), %xmm0
	movups	624(%rsp), %xmm1
	movups	%xmm0, 344(%rsp)
	movups	%xmm1, 360(%rsp)
	movl	$3, 376(%rsp)
	movq	$4, 384(%rsp)
	movq	%rax, 392(%rsp)
	movl	$4, 416(%rsp)
	movdqu	496(%rsp), %xmm0
	movups	512(%rsp), %xmm1
	movups	%xmm1, 440(%rsp)
	movdqu	%xmm0, 424(%rsp)
	movl	$5, 456(%rsp)
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.10(%rip), %rax
	movq	%rax, 520(%rsp)
	movq	$10, 528(%rsp)
	leaq	576(%r13), %rax
	movq	%rax, 496(%rsp)
	leaq	224(%rsp), %rax
	movq	%rax, 504(%rsp)
	movq	$6, 512(%rsp)
	leaq	496(%rsp), %rsi
	movq	%r15, %rdi
	callq	*_RNvMNtNtCs7GypIiIHh8y_4wgpu3api6deviceNtB2_6Device17create_bind_group@GOTPCREL(%rip)
	movq	%rax, %r15
	movq	%rax, 608(%rsp)
	leaq	608(%rsp), %rdx
	movq	%r13, %rdi
	movq	872(%rsp), %rsi
	callq	_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer6submit
	movq	%rax, 200(%rsp)
	movq	40(%rsp), %r14
	shlq	$32, %r14
	orq	%rbp, %r14
	movq	800(%rsp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.LBB116_141
	lock		decq	(%rax)
	jne	.LBB116_141
	#MEMBARRIER
	movq	800(%rsp), %rdi
	callq	*_RNvMsn_NtCscdodAO9FK5_5alloc4syncINtB5_3ArcNtNtNtCs7GypIiIHh8y_4wgpu7backend9wgpu_core13CoreBindGroupE9drop_slowBL_@GOTPCREL(%rip)
.LBB116_141:
	movq	8(%rsp), %r13
	movq	%r15, 840(%r13)
	movq	%r14, 848(%r13)
	movq	352(%r13), %rax
	incq	%rax
	movq	$-1, %rdx
	cmovneq	%rax, %rdx
	movq	16(%r13), %rcx
	shlq	$4, %rcx
	movq	40(%r13), %rax
	movq	128(%rsp), %rbx
	leaq	(%rcx,%rbx,4), %rsi
	leaq	(%rsi,%rax,8), %rsi
	movq	112(%r13), %rax
	movq	%rax, %rdi
	shlq	$5, %rdi
	addq	%rdi, %rsi
	addq	$48, %rsi
	movq	(%r13), %rdi
	shlq	$4, %rdi
	movq	24(%r13), %r8
	leaq	(%rdi,%r8,8), %rdi
	movq	72(%r13), %r8
	addq	48(%r13), %r8
	leaq	(%rdi,%r8,4), %r10
	movq	808(%r13), %rdi
	addq	800(%r13), %rdi
	movq	656(%r13), %r9
	addq	616(%r13), %r9
	addq	696(%r13), %r9
	addq	736(%r13), %r9
	movq	96(%r13), %r8
	shlq	$5, %r8
	addq	%r10, %r8
	addq	776(%r13), %r9
	movl	336(%r13), %r10d
	movq	312(%r13), %r11
	movq	304(%r13), %r14
	movq	%rdx, 352(%r13)
	movq	32(%rsp), %r15
	movq	%r15, 360(%r13)
	movq	472(%rsp), %rbp
	leaq	(,%rbp,2), %rdx
	movq	%rdx, 368(%r13)
	movq	%rbp, %rdx
	subq	%rbx, %rdx
	movq	$1, 376(%r13)
	movq	%r15, 384(%r13)
	movq	%rbx, 392(%r13)
	movq	%rbp, 400(%r13)
	movq	%rdx, 408(%r13)
	movq	%r12, 416(%r13)
	movq	48(%rsp), %rdx
	movq	%rdx, 424(%r13)
	movq	96(%rsp), %rdx
	movq	%rdx, 432(%r13)
	movq	%rsi, 440(%r13)
	movq	%rcx, 448(%r13)
	movq	776(%rsp), %rcx
	movq	%rcx, 456(%r13)
	movq	%r15, %rcx
	movq	784(%rsp), %rdx
	subq	%rdx, %rcx
	movq	%rdx, 464(%r13)
	movq	%rcx, 472(%r13)
	movq	1032(%rsp), %rcx
	movq	%rcx, 480(%r13)
	movq	%r9, 488(%r13)
	imulq	%r10, %r10
	movq	%r10, 496(%r13)
	addq	%r11, %r14
	movq	%r11, 504(%r13)
	movq	%r14, 512(%r13)
	movq	%r8, 520(%r13)
	movq	%rax, 528(%r13)
	movq	%rdi, 536(%r13)
	movb	$0, 544(%r13)
	movq	200(%rsp), %rax
	movq	%rax, 84(%rsp)
	movl	$-1, %r15d
	movq	16(%rsp), %rax
	jmp	.LBB116_49
.LBB116_142:
	movl	$3, %r15d
.LBB116_143:
	movq	16(%rsp), %rax
	movq	8(%rsp), %r13
	jmp	.LBB116_48
.LBB116_145:
	movq	$0, 48(%rsp)
	xorl	%eax, %eax
	xorl	%r12d, %r12d
	jmp	.LBB116_148
.LBB116_146:
	incq	%r12
.LBB116_147:
	addq	$8, %rax
	cmpq	%rax, %rdi
	je	.LBB116_134
.LBB116_148:
	movl	4(%r8,%rax), %ecx
	movl	%ecx, %edx
	negl	%edx
	jo	.LBB116_146
	cmpl	%ecx, (%r8,%rax)
	je	.LBB116_147
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.62(%rip), %rdi
	callq	*_RNvNtNtCs4NRVxsYgnAr_4core9panicking11panic_const23panic_const_rem_by_zero@GOTPCREL(%rip)
.LBB116_151:
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.12(%rip), %rdi
	callq	*_RNvNtCs4NRVxsYgnAr_4core6option13unwrap_failed@GOTPCREL(%rip)
.LBB116_152:
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.13(%rip), %rdx
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB116_153:
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.11(%rip), %rdx
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB116_154:
	movq	%rax, %rbx
	movq	8(%rsp), %rax
	movq	%r15, 840(%rax)
	movq	%r14, 848(%rax)
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB116_155:
	movq	%rax, %rbx
	lock		decq	(%r15)
	jne	.LBB116_160
	#MEMBARRIER
	leaq	608(%rsp), %rdi
	callq	*_RNvMsn_NtCscdodAO9FK5_5alloc4syncINtB5_3ArcNtNtNtCs7GypIiIHh8y_4wgpu7backend9wgpu_core13CoreBindGroupE9drop_slowBL_@GOTPCREL(%rip)
	jmp	.LBB116_160
.LBB116_157:
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking16panic_in_cleanup@GOTPCREL(%rip)
.LBB116_158:
	movq	$0, (%r14)
	movq	%rax, %rdi
	callq	_Unwind_Resume@PLT
.LBB116_159:
	movq	%rax, %rbx
	movq	$0, (%r15)
.LBB116_160:
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
	.size	_RNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_13PaintRenderer6render, .Lfunc_end116-_RNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_13PaintRenderer6render
	.section	.text._RNvMs3_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_14GpuPaintCommit6commit,"ax",@progbits
	.globl	_RNvMs3_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_14GpuPaintCommit6commit
	.p2align	4
	.type	_RNvMs3_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_14GpuPaintCommit6commit,@function
_RNvMs3_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_14GpuPaintCommit6commit:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$72, %rsp
	movq	(%rdi), %rbx
	movq	840(%rbx), %rax
	movq	848(%rbx), %rcx
	movq	$0, 840(%rbx)
	testq	%rax, %rax
	je	.LBB123_28
	movq	%rax, 40(%rsp)
	movq	%rcx, 48(%rsp)
	movq	%rdi, 32(%rsp)
	movq	16(%rdi), %rax
	testq	%rax, %rax
	je	.LBB123_6
	movq	32(%rsp), %rcx
	movq	8(%rcx), %r12
	leaq	(%rax,%rax,2), %rax
	leaq	(%r12,%rax,8), %r13
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.56(%rip), %rax
	movq	%rax, 24(%rsp)
	movq	%rsp, %r15
	movq	_RNvMs_NtNtCslsgujwDfRn_11gpui_canvas6canvas5paintNtB4_9PaintEdit5color@GOTPCREL(%rip), %rbp
	jmp	.LBB123_3
	.p2align	4
.LBB123_20:
	addq	$24, %r12
	cmpq	%r13, %r12
	je	.LBB123_6
.LBB123_3:
	movl	(%r12), %r14d
	movq	888(%rbx), %rsi
	cmpq	%r14, %rsi
	jbe	.LBB123_4
	movq	880(%rbx), %rax
	leaq	(%r14,%r14,2), %rcx
	movl	4(%rax,%rcx,4), %r14d
	testq	%r14, %r14
	je	.LBB123_14
	movl	20(%r12), %eax
	movl	%eax, 16(%rsp)
	movdqu	4(%r12), %xmm0
	movdqa	%xmm0, (%rsp)
	leaq	56(%rsp), %rdi
	movq	%r15, %rsi
	callq	*%rbp
	movups	56(%rsp), %xmm0
	movaps	%xmm0, (%rsp)
	movq	16(%rbx), %rsi
	cmpq	%r14, %rsi
	jbe	.LBB123_17
	movq	8(%rbx), %rax
	shlq	$4, %r14
	movdqu	(%rax,%r14), %xmm0
	pcmpeqb	(%rsp), %xmm0
	pmovmskb	%xmm0, %ecx
	cmpl	$65535, %ecx
	je	.LBB123_20
	addq	%r14, %rax
	movdqa	(%rsp), %xmm0
	movdqu	%xmm0, (%rax)
	movl	$16, %r8d
	leaq	560(%rbx), %rdi
	leaq	624(%rbx), %rsi
	movq	%r14, %rdx
	movq	%r15, %rcx
	callq	*_RNvMs2_NtNtCs7GypIiIHh8y_4wgpu3api5queueNtB5_5Queue12write_buffer@GOTPCREL(%rip)
	jmp	.LBB123_20
.LBB123_6:
	movq	32(%rsp), %r12
	movq	24(%r12), %rsi
	leaq	40(%rsp), %rdx
	movq	%rbx, %rdi
	callq	_RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer6submit
	leaq	840(%rbx), %r14
	movups	40(%rsp), %xmm0
	movaps	%xmm0, (%rsp)
	movq	(%r14), %rcx
	testq	%rcx, %rcx
	je	.LBB123_10
	lock		decq	(%rcx)
	jne	.LBB123_10
	#MEMBARRIER
	movq	%r14, %rdi
	movq	%rax, %r15
	callq	*_RNvMsn_NtCscdodAO9FK5_5alloc4syncINtB5_3ArcNtNtNtCs7GypIiIHh8y_4wgpu7backend9wgpu_core13CoreBindGroupE9drop_slowBL_@GOTPCREL(%rip)
	movq	%r15, %rax
.LBB123_10:
	movaps	(%rsp), %xmm0
	movups	%xmm0, (%r14)
	movq	352(%rbx), %rdx
	movq	832(%rbx), %rcx
	incq	%rdx
	movq	$-1, %rsi
	cmovneq	%rdx, %rsi
	movq	%rsi, 352(%rbx)
	movb	$1, 544(%rbx)
	xorps	%xmm0, %xmm0
	movups	%xmm0, 360(%rbx)
	movq	$0, 376(%rbx)
	movq	32(%r12), %rdx
	shlq	$4, %rdx
	movq	%rdx, 440(%rbx)
	movq	$0, 480(%rbx)
	testq	%rcx, %rcx
	je	.LBB123_12
	movq	$0, 96(%rcx)
.LBB123_12:
	addq	$72, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB123_14:
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.57(%rip), %rdi
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.58(%rip), %rdx
	movl	$20, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core6option13expect_failed@GOTPCREL(%rip)
	jmp	.LBB123_5
.LBB123_28:
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.54(%rip), %rdi
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.55(%rip), %rdx
	movl	$31, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core6option13expect_failed@GOTPCREL(%rip)
.LBB123_17:
	leaq	.Lanon.010f1c5a99a60ec150d5685bcc6afdb8.59(%rip), %rax
	movq	%rax, 24(%rsp)
.LBB123_4:
	movq	%r14, %rdi
	movq	24(%rsp), %rdx
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB123_5:
	ud2
.LBB123_21:
	movq	%rax, %rbx
	movaps	(%rsp), %xmm0
	movups	%xmm0, (%r14)
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB123_23:
	jmp	.LBB123_25
.LBB123_24:
.LBB123_25:
	movq	%rax, %rbx
	movq	40(%rsp), %rax
	lock		decq	(%rax)
	jne	.LBB123_22
	#MEMBARRIER
	leaq	40(%rsp), %rdi
	callq	*_RNvMsn_NtCscdodAO9FK5_5alloc4syncINtB5_3ArcNtNtNtCs7GypIiIHh8y_4wgpu7backend9wgpu_core13CoreBindGroupE9drop_slowBL_@GOTPCREL(%rip)
.LBB123_22:
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB123_27:
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking16panic_in_cleanup@GOTPCREL(%rip)
	.size	_RNvMs3_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_14GpuPaintCommit6commit, .Lfunc_end123-_RNvMs3_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_14GpuPaintCommit6commit
	.section	.text._RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer6render,"ax",@progbits
.Lsec_end119:
	.section	.text._RNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_13PaintRenderer13prepare_paint,"ax",@progbits
.Lsec_end125:
	.section	.text._RNvMs2_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_13PaintRenderer6render,"ax",@progbits
.Lsec_end130:
	.section	.text._RNvMs3_NtNtCsdsK2Jbz6dnh_8gpui_gpu8renderer5paintNtB5_14GpuPaintCommit6commit,"ax",@progbits
.Lsec_end137:
