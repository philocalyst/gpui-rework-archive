
/tmp/gpui-bounds-candidate-gpui-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000004e9fa0 <bounds_kernel_gpui_consumer::inspect>:
  4e9fa0:	push   %rbp
  4e9fa1:	push   %r15
  4e9fa3:	push   %r14
  4e9fa5:	push   %r13
  4e9fa7:	push   %r12
  4e9fa9:	push   %rbx
  4e9faa:	sub    $0x98,%rsp
  4e9fb1:	test   %rdi,%rdi
  4e9fb4:	je     4ea0cc <bounds_kernel_gpui_consumer::inspect+0x12c>
  4e9fba:	cmpb   $0x0,0x94e(%rdi)
  4e9fc1:	jne    4ea0d3 <bounds_kernel_gpui_consumer::inspect+0x133>
  4e9fc7:	cmpb   $0x1,0x94c(%rdi)
  4e9fce:	jne    4ea0da <bounds_kernel_gpui_consumer::inspect+0x13a>
  4e9fd4:	lea    0x780(%rdi),%rcx
  4e9fdb:	mov    0x748(%rdi),%rbx
  4e9fe2:	mov    0x800(%rdi),%rdx
  4e9fe9:	lea    0x18(%rdx),%rax
  4e9fed:	test   %rdx,%rdx
  4e9ff0:	cmovne %rax,%rdx
  4e9ff4:	mov    0x750(%rdi),%rax
  4e9ffb:	mov    %rcx,0x28(%rsp)
  4ea000:	mov    %rbx,0x30(%rsp)
  4ea005:	mov    %rax,0x38(%rsp)
  4ea00a:	movups 0x7d8(%rdi),%xmm0
  4ea011:	movups %xmm0,0x40(%rsp)
  4ea016:	mov    %rdx,0x50(%rsp)
  4ea01b:	test   %rax,%rax
  4ea01e:	je     4ea0b4 <bounds_kernel_gpui_consumer::inspect+0x114>
  4ea024:	shl    $0x4,%rax
  4ea028:	lea    (%rax,%rax,4),%r13
  4ea02c:	lea    0x84(%rsp),%r15
  4ea034:	xor    %r14d,%r14d
  4ea037:	lea    0x58(%rsp),%r12
  4ea03c:	nopl   0x0(%rax)
  4ea040:	movss  0x30(%rbx),%xmm0
  4ea045:	movss  %xmm0,0xc(%rsp)
  4ea04b:	ucomiss %xmm0,%xmm0
  4ea04e:	mov    $0x0,%ebp
  4ea053:	jp     4ea06a <bounds_kernel_gpui_consumer::inspect+0xca>
  4ea055:	mov    0x44(%rbx),%eax
  4ea058:	mov    %eax,0x20(%rsp)
  4ea05c:	movups 0x34(%rbx),%xmm0
  4ea060:	movaps %xmm0,0x10(%rsp)
  4ea065:	mov    $0x1,%ebp
  4ea06a:	mov    %r15,%rdi
  4ea06d:	mov    %rbx,%rsi
  4ea070:	lea    0x28(%rsp),%rdx
  4ea075:	call   *0x2b1e0d(%rip)        # 79be88 <_DYNAMIC+0x2a0>
  4ea07b:	mov    %ebp,0x58(%rsp)
  4ea07f:	movss  0xc(%rsp),%xmm0
  4ea085:	movss  %xmm0,0x5c(%rsp)
  4ea08b:	mov    0x20(%rsp),%eax
  4ea08f:	mov    %eax,-0x14(%r15)
  4ea093:	movaps 0x10(%rsp),%xmm0
  4ea098:	movups %xmm0,-0x24(%r15)
  4ea09d:	movups (%rbx),%xmm0
  4ea0a0:	movups %xmm0,-0x10(%r15)
  4ea0a5:	inc    %r14
  4ea0a8:	add    $0x50,%rbx
  4ea0ac:	add    $0xffffffffffffffb0,%r13
  4ea0b0:	jne    4ea040 <bounds_kernel_gpui_consumer::inspect+0xa0>
  4ea0b2:	jmp    4ea0b7 <bounds_kernel_gpui_consumer::inspect+0x117>
  4ea0b4:	xor    %r14d,%r14d
  4ea0b7:	mov    %r14,%rax
  4ea0ba:	add    $0x98,%rsp
  4ea0c1:	pop    %rbx
  4ea0c2:	pop    %r12
  4ea0c4:	pop    %r13
  4ea0c6:	pop    %r14
  4ea0c8:	pop    %r15
  4ea0ca:	pop    %rbp
  4ea0cb:	ret
  4ea0cc:	mov    $0xd,%eax
  4ea0d1:	jmp    4ea0df <bounds_kernel_gpui_consumer::inspect+0x13f>
  4ea0d3:	mov    $0xe,%eax
  4ea0d8:	jmp    4ea0df <bounds_kernel_gpui_consumer::inspect+0x13f>
  4ea0da:	mov    $0x12,%eax
  4ea0df:	mov    %rax,0x58(%rsp)
  4ea0e4:	lea    -0x4a46f7(%rip),%rdi        # 459f4 <anon.6012f703f76728adc1ab0e9d1e27dcb4.113.llvm.4097891651611014805+0x424>
  4ea0eb:	lea    0x2917a6(%rip),%rcx        # 77b898 <anon.cae4a28cda4ecf73fbbf18bd8cc38fde.0.llvm.3118891056594271729+0x1f0>
  4ea0f2:	lea    0x291787(%rip),%r8        # 77b880 <anon.cae4a28cda4ecf73fbbf18bd8cc38fde.0.llvm.3118891056594271729+0x1d8>
  4ea0f9:	lea    0x58(%rsp),%rdx
  4ea0fe:	mov    $0x2b,%esi
  4ea103:	call   *0x2b1e07(%rip)        # 79bf10 <_DYNAMIC+0x328>
  4ea109:	ud2
  4ea10b:	mov    %rax,%rbx
  4ea10e:	lea    0x58(%rsp),%rdi
  4ea113:	call   4e90b0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  4ea118:	mov    %rbx,%rdi
  4ea11b:	call   779ac0 <_Unwind_Resume@plt>
