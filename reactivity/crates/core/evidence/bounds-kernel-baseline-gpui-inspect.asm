
/tmp/gpui-bounds-baseline-gpui-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000004e9f90 <bounds_kernel_gpui_consumer::inspect>:
  4e9f90:	push   %rbp
  4e9f91:	push   %r15
  4e9f93:	push   %r14
  4e9f95:	push   %r13
  4e9f97:	push   %r12
  4e9f99:	push   %rbx
  4e9f9a:	sub    $0x98,%rsp
  4e9fa1:	test   %rdi,%rdi
  4e9fa4:	je     4ea0bc <bounds_kernel_gpui_consumer::inspect+0x12c>
  4e9faa:	cmpb   $0x0,0x94e(%rdi)
  4e9fb1:	jne    4ea0c3 <bounds_kernel_gpui_consumer::inspect+0x133>
  4e9fb7:	cmpb   $0x1,0x94c(%rdi)
  4e9fbe:	jne    4ea0ca <bounds_kernel_gpui_consumer::inspect+0x13a>
  4e9fc4:	lea    0x780(%rdi),%rcx
  4e9fcb:	mov    0x748(%rdi),%rbx
  4e9fd2:	mov    0x800(%rdi),%rdx
  4e9fd9:	lea    0x18(%rdx),%rax
  4e9fdd:	test   %rdx,%rdx
  4e9fe0:	cmovne %rax,%rdx
  4e9fe4:	mov    0x750(%rdi),%rax
  4e9feb:	mov    %rcx,0x28(%rsp)
  4e9ff0:	mov    %rbx,0x30(%rsp)
  4e9ff5:	mov    %rax,0x38(%rsp)
  4e9ffa:	movups 0x7d8(%rdi),%xmm0
  4ea001:	movups %xmm0,0x40(%rsp)
  4ea006:	mov    %rdx,0x50(%rsp)
  4ea00b:	test   %rax,%rax
  4ea00e:	je     4ea0a4 <bounds_kernel_gpui_consumer::inspect+0x114>
  4ea014:	shl    $0x4,%rax
  4ea018:	lea    (%rax,%rax,4),%r13
  4ea01c:	lea    0x84(%rsp),%r15
  4ea024:	xor    %r14d,%r14d
  4ea027:	lea    0x58(%rsp),%r12
  4ea02c:	nopl   0x0(%rax)
  4ea030:	movss  0x30(%rbx),%xmm0
  4ea035:	movss  %xmm0,0xc(%rsp)
  4ea03b:	ucomiss %xmm0,%xmm0
  4ea03e:	mov    $0x0,%ebp
  4ea043:	jp     4ea05a <bounds_kernel_gpui_consumer::inspect+0xca>
  4ea045:	mov    0x44(%rbx),%eax
  4ea048:	mov    %eax,0x20(%rsp)
  4ea04c:	movups 0x34(%rbx),%xmm0
  4ea050:	movaps %xmm0,0x10(%rsp)
  4ea055:	mov    $0x1,%ebp
  4ea05a:	mov    %r15,%rdi
  4ea05d:	mov    %rbx,%rsi
  4ea060:	lea    0x28(%rsp),%rdx
  4ea065:	call   *0x2b1d3d(%rip)        # 79bda8 <_DYNAMIC+0x2a0>
  4ea06b:	mov    %ebp,0x58(%rsp)
  4ea06f:	movss  0xc(%rsp),%xmm0
  4ea075:	movss  %xmm0,0x5c(%rsp)
  4ea07b:	mov    0x20(%rsp),%eax
  4ea07f:	mov    %eax,-0x14(%r15)
  4ea083:	movaps 0x10(%rsp),%xmm0
  4ea088:	movups %xmm0,-0x24(%r15)
  4ea08d:	movups (%rbx),%xmm0
  4ea090:	movups %xmm0,-0x10(%r15)
  4ea095:	inc    %r14
  4ea098:	add    $0x50,%rbx
  4ea09c:	add    $0xffffffffffffffb0,%r13
  4ea0a0:	jne    4ea030 <bounds_kernel_gpui_consumer::inspect+0xa0>
  4ea0a2:	jmp    4ea0a7 <bounds_kernel_gpui_consumer::inspect+0x117>
  4ea0a4:	xor    %r14d,%r14d
  4ea0a7:	mov    %r14,%rax
  4ea0aa:	add    $0x98,%rsp
  4ea0b1:	pop    %rbx
  4ea0b2:	pop    %r12
  4ea0b4:	pop    %r13
  4ea0b6:	pop    %r14
  4ea0b8:	pop    %r15
  4ea0ba:	pop    %rbp
  4ea0bb:	ret
  4ea0bc:	mov    $0xd,%eax
  4ea0c1:	jmp    4ea0cf <bounds_kernel_gpui_consumer::inspect+0x13f>
  4ea0c3:	mov    $0xe,%eax
  4ea0c8:	jmp    4ea0cf <bounds_kernel_gpui_consumer::inspect+0x13f>
  4ea0ca:	mov    $0x12,%eax
  4ea0cf:	mov    %rax,0x58(%rsp)
  4ea0d4:	lea    -0x4a46f7(%rip),%rdi        # 459e4 <anon.6012f703f76728adc1ab0e9d1e27dcb4.113.llvm.4097891651611014805+0x424>
  4ea0db:	lea    0x2916d6(%rip),%rcx        # 77b7b8 <anon.cae4a28cda4ecf73fbbf18bd8cc38fde.0.llvm.3118891056594271729+0x1f0>
  4ea0e2:	lea    0x2916b7(%rip),%r8        # 77b7a0 <anon.cae4a28cda4ecf73fbbf18bd8cc38fde.0.llvm.3118891056594271729+0x1d8>
  4ea0e9:	lea    0x58(%rsp),%rdx
  4ea0ee:	mov    $0x2b,%esi
  4ea0f3:	call   *0x2b1d37(%rip)        # 79be30 <_DYNAMIC+0x328>
  4ea0f9:	ud2
  4ea0fb:	mov    %rax,%rbx
  4ea0fe:	lea    0x58(%rsp),%rdi
  4ea103:	call   4e90a0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  4ea108:	mov    %rbx,%rdi
  4ea10b:	call   7799e0 <_Unwind_Resume@plt>
