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
	.section	.text._RNvMs2_NtCsdsK2Jbz6dnh_8gpui_gpu8rendererNtB5_8Renderer6render,"ax",@progbits
.Lsec_end119:
