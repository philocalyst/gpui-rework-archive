000000000051aa90 <<gpui_canvas::canvas::columns::Columns>::find_scope>:
  51aa90:	push   %rbp
  51aa91:	push   %r15
  51aa93:	push   %r14
  51aa95:	push   %r13
  51aa97:	push   %r12
  51aa99:	push   %rbx
  51aa9a:	mov    %rdx,%rax
  51aa9d:	mov    %rsi,%rdx
  51aaa0:	mov    (%rcx),%ebx
  51aaa2:	mov    0x4(%rcx),%r11d
  51aaa6:	mov    0x8(%rcx),%r10
  51aaaa:	movabs $0x3ff0000000000000,%rcx
  51aab4:	mov    %rcx,-0x28(%rsp)
  51aab9:	movabs $0x8000000000000000,%rsi
  51aac3:	mov    %rsi,-0x20(%rsp)
  51aac8:	mov    %rsi,-0x18(%rsp)
  51aacd:	mov    %rcx,-0x10(%rsp)
  51aad2:	mov    (%rax),%rcx
  51aad5:	mov    0x8(%rax),%rsi
  51aad9:	mov    0x10(%rax),%r8
  51aadd:	mov    0x18(%rax),%r9
  51aae1:	mov    %rcx,-0x48(%rsp)
  51aae6:	mov    %rsi,-0x40(%rsp)
  51aaeb:	mov    %r8,-0x38(%rsp)
  51aaf0:	mov    %r9,-0x30(%rsp)
  51aaf5:	movdqu -0x48(%rsp),%xmm0
  51aafb:	movdqu -0x18(%rsp),%xmm1
  51ab01:	movdqu -0x38(%rsp),%xmm2
  51ab07:	pcmpeqb -0x28(%rsp),%xmm0
  51ab0d:	pcmpeqb %xmm1,%xmm2
  51ab11:	pand   %xmm2,%xmm0
  51ab15:	pmovmskb %xmm0,%ebp
  51ab19:	cmp    $0xffff,%ebp
  51ab1f:	jne    51ab43 <<gpui_canvas::canvas::columns::Columns>::find_scope+0xb3>
  51ab21:	shl    $0x20,%r11
  51ab25:	mov    %ebx,%ebx
  51ab27:	xor    0x28(%rax),%r10
  51ab2b:	or     %r11,%rbx
  51ab2e:	xor    0x20(%rax),%rbx
  51ab32:	or     %r10,%rbx
  51ab35:	jne    51ab43 <<gpui_canvas::canvas::columns::Columns>::find_scope+0xb3>
  51ab37:	mov    $0x1,%eax
  51ab3c:	xor    %edx,%edx
  51ab3e:	jmp    51acb3 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x223>
  51ab43:	test   %rdx,%rdx
  51ab46:	je     51abd1 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x141>
  51ab4c:	lea    (%rdx,%rdx,2),%r10
  51ab50:	shl    $0x4,%r10
  51ab54:	movups -0x30(%rdi,%r10,1),%xmm0
  51ab5a:	movaps %xmm0,-0x28(%rsp)
  51ab5f:	movups -0x20(%rdi,%r10,1),%xmm0
  51ab65:	movaps %xmm0,-0x18(%rsp)
  51ab6a:	mov    %rcx,-0x48(%rsp)
  51ab6f:	mov    %rsi,-0x40(%rsp)
  51ab74:	mov    %r8,-0x38(%rsp)
  51ab79:	mov    %r9,-0x30(%rsp)
  51ab7e:	movdqu -0x48(%rsp),%xmm0
  51ab84:	movdqu -0x38(%rsp),%xmm1
  51ab8a:	pcmpeqb -0x18(%rsp),%xmm1
  51ab90:	pcmpeqb -0x28(%rsp),%xmm0
  51ab96:	pand   %xmm1,%xmm0
  51ab9a:	pmovmskb %xmm0,%ebx
  51ab9e:	mov    0x20(%rax),%r11d
  51aba2:	cmp    $0xffff,%ebx
  51aba8:	jne    51abd5 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x145>
  51abaa:	add    %rdi,%r10
  51abad:	mov    -0x8(%r10),%rbx
  51abb1:	mov    0x24(%rax),%r14d
  51abb5:	shl    $0x20,%r14
  51abb9:	mov    %r11d,%r15d
  51abbc:	xor    0x28(%rax),%rbx
  51abc0:	or     %r14,%r15
  51abc3:	xor    -0x10(%r10),%r15
  51abc7:	or     %rbx,%r15
  51abca:	jne    51abd5 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x145>
  51abcc:	jmp    51acaa <<gpui_canvas::canvas::columns::Columns>::find_scope+0x21a>
  51abd1:	mov    0x20(%rax),%r11d
  51abd5:	mov    0x24(%rax),%ebx
  51abd8:	mov    0x28(%rax),%rax
  51abdc:	shl    $0x20,%rbx
  51abe0:	mov    %r11d,%r11d
  51abe3:	or     %rbx,%r11
  51abe6:	shl    $0x4,%rdx
  51abea:	lea    (%rdx,%rdx,2),%rbx
  51abee:	mov    $0xffffffffffffffe1,%r14
  51abf5:	xor    %r15d,%r15d
  51abf8:	xor    %edx,%edx
  51abfa:	mov    %rdi,%r12
  51abfd:	nopl   (%rax)
  51ac00:	cmp    %r15,%rbx
  51ac03:	je     51acb1 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x221>
  51ac09:	movups (%r12),%xmm0
  51ac0e:	movaps %xmm0,-0x28(%rsp)
  51ac13:	movups 0x10(%r12),%xmm0
  51ac19:	movaps %xmm0,-0x18(%rsp)
  51ac1e:	mov    %rcx,-0x48(%rsp)
  51ac23:	mov    %rsi,-0x40(%rsp)
  51ac28:	mov    %r8,-0x38(%rsp)
  51ac2d:	mov    %r9,-0x30(%rsp)
  51ac32:	movdqu -0x48(%rsp),%xmm0
  51ac38:	movdqu -0x38(%rsp),%xmm1
  51ac3e:	pcmpeqb -0x18(%rsp),%xmm1
  51ac44:	pcmpeqb -0x28(%rsp),%xmm0
  51ac4a:	pand   %xmm1,%xmm0
  51ac4e:	pmovmskb %xmm0,%ebp
  51ac52:	cmp    $0xffff,%ebp
  51ac58:	jne    51ac75 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x1e5>
  51ac5a:	mov    0x20(%rdi,%r15,1),%rbp
  51ac5f:	xor    %r11,%rbp
  51ac62:	mov    0x28(%rdi,%r15,1),%r10
  51ac67:	xor    %rax,%r10
  51ac6a:	mov    $0x1,%r13d
  51ac70:	or     %rbp,%r10
  51ac73:	je     51ac7a <<gpui_canvas::canvas::columns::Columns>::find_scope+0x1ea>
  51ac75:	inc    %edx
  51ac77:	xor    %r13d,%r13d
  51ac7a:	add    $0x30,%r12
  51ac7e:	mov    $0x2,%ebp
  51ac83:	sub    %r13,%rbp
  51ac86:	test   %r14,%r14
  51ac89:	cmove  %r13,%rbp
  51ac8d:	inc    %r14
  51ac90:	add    $0x30,%r15
  51ac94:	cmp    $0x2,%rbp
  51ac98:	je     51ac00 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x170>
  51ac9e:	test   %rbp,%rbp
  51aca1:	mov    $0x0,%eax
  51aca6:	je     51acb3 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x223>
  51aca8:	inc    %edx
  51acaa:	mov    $0x1,%eax
  51acaf:	jmp    51acb3 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x223>
  51acb1:	xor    %eax,%eax
  51acb3:	pop    %rbx
  51acb4:	pop    %r12
  51acb6:	pop    %r13
  51acb8:	pop    %r14
  51acba:	pop    %r15
  51acbc:	pop    %rbp
  51acbd:	ret
  51acbe:	int3
  51acbf:	int3

000000000051acc0 <<gpui_canvas::canvas::columns::Columns>::admit>:
  51acc0:	push   %rbp
  51acc1:	push   %r15
  51acc3:	push   %r14
  51acc5:	push   %r13
  51acc7:	push   %r12
  51acc9:	push   %rbx
  51acca:	sub    $0x58,%rsp
  51acce:	mov    %r9d,%ebp
  51acd1:	mov    %r8d,%r14d
  51acd4:	mov    %ecx,%r12d
  51acd7:	mov    %rdx,%rcx
  51acda:	mov    %rsi,%r13
  51acdd:	mov    %rdi,%rbx
  51ace0:	movups 0x10(%rsi),%xmm0
  51ace4:	movaps %xmm0,0x20(%rsp)
  51ace9:	movups 0x20(%rsi),%xmm0
  51aced:	movaps %xmm0,0x30(%rsp)
  51acf2:	movups (%rsi),%xmm0
  51acf5:	movaps %xmm0,0x40(%rsp)
  51acfa:	mov    0x8(%rdi),%rdi
  51acfe:	mov    0x10(%rbx),%r15
  51ad02:	lea    0x20(%rsp),%rdx
  51ad07:	mov    %rdi,(%rsp)
  51ad0b:	mov    %r15,%rsi
  51ad0e:	call   51aa90 <<gpui_canvas::canvas::columns::Columns>::find_scope>
  51ad13:	or     %ebp,%r14d
  51ad16:	je     51ad46 <<gpui_canvas::canvas::columns::Columns>::admit+0x86>
  51ad18:	cmp    $0x1,%eax
  51ad1b:	jne    51ad93 <<gpui_canvas::canvas::columns::Columns>::admit+0xd3>
  51ad1d:	mov    $0xffffffff,%eax
  51ad22:	test   %bpl,%bpl
  51ad25:	je     51aea0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
  51ad2b:	mov    0x28(%rbx),%rsi
  51ad2f:	mov    $0x7,%eax
  51ad34:	cmp    $0x1ffff,%rsi
  51ad3b:	jbe    51adc8 <<gpui_canvas::canvas::columns::Columns>::admit+0x108>
  51ad41:	jmp    51aea0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
  51ad46:	test   %r12d,%r12d
  51ad49:	je     51ae23 <<gpui_canvas::canvas::columns::Columns>::admit+0x163>
  51ad4f:	mov    %eax,%ecx
  51ad51:	add    $0xfffffffd,%r12d
  51ad55:	mov    $0x1,%eax
  51ad5a:	cmp    %r12,0x28(%rbx)
  51ad5e:	jbe    51aea0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
  51ad64:	cmp    $0x1,%ecx
  51ad67:	sete   %dl
  51ad6a:	mov    0x20(%rbx),%rcx
  51ad6e:	lea    (%r12,%r12,2),%rsi
  51ad72:	xor    %eax,%eax
  51ad74:	cmpw   $0x0,0x10(%rcx,%rsi,8)
  51ad7a:	setns  %cl
  51ad7d:	or     %cl,%dl
  51ad7f:	je     51ae88 <<gpui_canvas::canvas::columns::Columns>::admit+0x1c8>
  51ad85:	mov    %cl,%al
  51ad87:	lea    -0x1(,%rax,2),%eax
  51ad8e:	jmp    51aea0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
  51ad93:	mov    $0x7,%eax
  51ad98:	cmp    $0x1ffff,%r15
  51ad9f:	ja     51aea0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
  51ada5:	test   %bpl,%bpl
  51ada8:	je     51ae96 <<gpui_canvas::canvas::columns::Columns>::admit+0x1d6>
  51adae:	mov    0x28(%rbx),%rsi
  51adb2:	cmp    $0x1ffff,%rsi
  51adb9:	ja     51aea0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
  51adbf:	cmp    %r15,(%rbx)
  51adc2:	je     51aefb <<gpui_canvas::canvas::columns::Columns>::admit+0x23b>
  51adc8:	mov    $0xffffffff,%eax
  51adcd:	cmp    %rsi,0x18(%rbx)
  51add1:	jne    51aea0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
  51add7:	lea    (%rsi,%rsi,1),%rax
  51addb:	cmp    $0x5,%rax
  51addf:	mov    $0x4,%r14d
  51ade5:	cmovae %rax,%r14
  51ade9:	mov    0x20(%rbx),%rdx
  51aded:	lea    0x8(%rsp),%rdi
  51adf2:	mov    $0x4,%r8d
  51adf8:	mov    $0x18,%r9d
  51adfe:	mov    %r14,%rcx
  51ae01:	call   55a280 <<alloc::raw_vec::RawVecInner>::finish_grow>
  51ae06:	cmpl   $0x1,0x8(%rsp)
  51ae0b:	je     51af37 <<gpui_canvas::canvas::columns::Columns>::admit+0x277>
  51ae11:	mov    0x10(%rsp),%rax
  51ae16:	mov    %rax,0x20(%rbx)
  51ae1a:	mov    %r14,0x18(%rbx)
  51ae1e:	jmp    51aef4 <<gpui_canvas::canvas::columns::Columns>::admit+0x234>
  51ae23:	mov    0x40(%r13),%rcx
  51ae27:	mov    0x48(%r13),%rdx
  51ae2b:	xor    %ebp,%ebp
  51ae2d:	mov    %rcx,%rsi
  51ae30:	or     %rdx,%rsi
  51ae33:	je     51ad18 <<gpui_canvas::canvas::columns::Columns>::admit+0x58>
  51ae39:	movabs $0x3f8000003f800000,%rsi
  51ae43:	mov    %rcx,%rdi
  51ae46:	xor    %rsi,%rdi
  51ae49:	xor    %rdx,%rsi
  51ae4c:	or     %rdi,%rsi
  51ae4f:	je     51ad18 <<gpui_canvas::canvas::columns::Columns>::admit+0x58>
  51ae55:	movabs $0x3f80000000000000,%rsi
  51ae5f:	xor    %rsi,%rdx
  51ae62:	or     %rdx,%rcx
  51ae65:	je     51ad18 <<gpui_canvas::canvas::columns::Columns>::admit+0x58>
  51ae6b:	cmp    $0x1,%eax
  51ae6e:	je     51ad2b <<gpui_canvas::canvas::columns::Columns>::admit+0x6b>
  51ae74:	mov    $0x7,%eax
  51ae79:	cmp    $0x1ffff,%r15
  51ae80:	jbe    51adae <<gpui_canvas::canvas::columns::Columns>::admit+0xee>
  51ae86:	jmp    51aea0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
  51ae88:	mov    $0x7,%eax
  51ae8d:	cmp    $0x1ffff,%r15
  51ae94:	ja     51aea0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
  51ae96:	mov    $0xffffffff,%eax
  51ae9b:	cmp    %r15,(%rbx)
  51ae9e:	je     51aeaf <<gpui_canvas::canvas::columns::Columns>::admit+0x1ef>
  51aea0:	add    $0x58,%rsp
  51aea4:	pop    %rbx
  51aea5:	pop    %r12
  51aea7:	pop    %r13
  51aea9:	pop    %r14
  51aeab:	pop    %r15
  51aead:	pop    %rbp
  51aeae:	ret
  51aeaf:	lea    (%r15,%r15,1),%rax
  51aeb3:	cmp    $0x5,%rax
  51aeb7:	mov    $0x4,%r12d
  51aebd:	cmovae %rax,%r12
  51aec1:	lea    0x8(%rsp),%rdi
  51aec6:	mov    $0x8,%r8d
  51aecc:	mov    $0x30,%r9d
  51aed2:	mov    %r15,%rsi
  51aed5:	mov    (%rsp),%rdx
  51aed9:	mov    %r12,%rcx
  51aedc:	call   55a280 <<alloc::raw_vec::RawVecInner>::finish_grow>
  51aee1:	cmpl   $0x1,0x8(%rsp)
  51aee6:	je     51af37 <<gpui_canvas::canvas::columns::Columns>::admit+0x277>
  51aee8:	mov    0x10(%rsp),%rax
  51aeed:	mov    %rax,0x8(%rbx)
  51aef1:	mov    %r12,(%rbx)
  51aef4:	mov    $0xffffffff,%eax
  51aef9:	jmp    51aea0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
  51aefb:	mov    %rsi,%r14
  51aefe:	lea    (%r15,%r15,1),%rax
  51af02:	cmp    $0x5,%rax
  51af06:	mov    $0x4,%r12d
  51af0c:	cmovae %rax,%r12
  51af10:	lea    0x8(%rsp),%rdi
  51af15:	mov    $0x8,%r8d
  51af1b:	mov    $0x30,%r9d
  51af21:	mov    %r15,%rsi
  51af24:	mov    (%rsp),%rdx
  51af28:	mov    %r12,%rcx
  51af2b:	call   55a280 <<alloc::raw_vec::RawVecInner>::finish_grow>
  51af30:	cmpl   $0x1,0x8(%rsp)
  51af35:	jne    51af41 <<gpui_canvas::canvas::columns::Columns>::admit+0x281>
  51af37:	mov    $0x7,%eax
  51af3c:	jmp    51aea0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
  51af41:	mov    0x10(%rsp),%rax
  51af46:	mov    %rax,0x8(%rbx)
  51af4a:	mov    %r12,(%rbx)
  51af4d:	mov    %r14,%rsi
  51af50:	mov    $0xffffffff,%eax
  51af55:	cmp    %rsi,0x18(%rbx)
  51af59:	jne    51aea0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
  51af5f:	jmp    51add7 <<gpui_canvas::canvas::columns::Columns>::admit+0x117>
  51af64:	int3
  51af65:	int3
  51af66:	int3
  51af67:	int3
  51af68:	int3
  51af69:	int3
  51af6a:	int3
  51af6b:	int3
  51af6c:	int3
  51af6d:	int3
  51af6e:	int3
  51af6f:	int3
