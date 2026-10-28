# assembly line 102704
	testq	%rsi, %rsi
.Ltmp23930:
	.loc	136 177 9
	je	.LBB277_206
.Ltmp23931:
.Ltmp23203:
	.loc	136 0 9 is_stmt 0
	leaq	288(%rsp), %rdi
	movabsq	$4294967297, %rdx
	.loc	136 177 49
	callq	*_RNvMs_NtNtCsere7gZGiCG7_4gpui7runtime5paintNtB4_10PaintState5begin@GOTPCREL(%rip)
.Ltmp23932:
.Ltmp23204:
	.loc	25 633 18 is_stmt 1
	cmpq	$-1, 288(%rsp)
	setne	%r8b
.Ltmp23933:
	.loc	29 1991 40
	movq	1976(%r15), %r14
.Ltmp23934:
	.loc	25 742 15
	testq	%r14, %r14
# assembly line 108894
	testq	%rsi, %rsi
.Ltmp25273:
	.loc	136 177 9
	je	.LBB288_78
.Ltmp25274:
.Ltmp24984:
	.loc	136 0 9 is_stmt 0
	leaq	272(%rsp), %rdi
	.loc	136 177 49
	movq	%r15, %rdx
	callq	*_RNvMs_NtNtCsere7gZGiCG7_4gpui7runtime5paintNtB4_10PaintState5begin@GOTPCREL(%rip)
.Ltmp25275:
.Ltmp24985:
	.loc	25 633 18 is_stmt 1
	cmpq	$-1, 272(%rsp)
	setne	%al
	movl	%eax, 80(%rsp)
	jmp	.LBB288_79
.Ltmp25276:
.LBB288_60:
	.loc	25 661 24
	movq	-16(%rax,%rsi), %rbx
