00000000004c7b00 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>>:
  4c7b00:	push   %r15
  4c7b02:	push   %r14
  4c7b04:	push   %rbx
  4c7b05:	sub    $0x40,%rsp
  4c7b09:	mov    %rdi,%rbx
  4c7b0c:	mov    (%rsi),%r14
  4c7b0f:	test   %r14,%r14
  4c7b12:	je     4c7b2a <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x2a>
  4c7b14:	cmpb   $0x0,0x926(%r14)
  4c7b1c:	je     4c7b36 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x36>
  4c7b1e:	movq   $0xe,(%rbx)
  4c7b25:	jmp    4c7c6f <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x16f>
  4c7b2a:	movq   $0xd,(%rbx)
  4c7b31:	jmp    4c7c6f <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x16f>
  4c7b36:	mov    %r8,%r15
  4c7b39:	lea    0x8(%rsp),%rdi
  4c7b3e:	mov    %r14,%rsi
  4c7b41:	call   4dedc0 <<gpui::runtime::Runtime<paint_slot_codegen::Paint>>::resolve>
  4c7b46:	mov    0x8(%rsp),%rax
  4c7b4b:	mov    0x10(%rsp),%rcx
  4c7b50:	cmp    $0xfffffffffffffffe,%rax
  4c7b54:	jne    4c7bd1 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0xd1>
  4c7b56:	mov    0x778(%r14),%rdx
  4c7b5d:	test   %rdx,%rdx
  4c7b60:	je     4c7c7c <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x17c>
  4c7b66:	mov    %r15,%rax
  4c7b69:	mov    0x780(%r14),%rsi
  4c7b70:	movzwl 0xba(%rdx),%r8d
  4c7b78:	mov    %r8d,%r9d
  4c7b7b:	shl    $0x3,%r9d
  4c7b7f:	mov    $0xffffffffffffffff,%rdi
  4c7b86:	cs nopw 0x0(%rax,%rax,1)
  4c7b90:	test   %r9,%r9
  4c7b93:	je     4c7bba <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0xba>
  4c7b95:	cmp    0x10(%rdx,%rdi,8),%rcx
  4c7b9a:	seta   %r10b
  4c7b9e:	sbb    $0x0,%r10b
  4c7ba2:	inc    %rdi
  4c7ba5:	add    $0xfffffffffffffff8,%r9
  4c7ba9:	cmp    $0x1,%r10b
  4c7bad:	je     4c7b90 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x90>
  4c7baf:	movzbl %r10b,%r8d
  4c7bb3:	test   %r8d,%r8d
  4c7bb6:	je     4c7bf5 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0xf5>
  4c7bb8:	jmp    4c7bbd <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0xbd>
  4c7bba:	mov    %r8,%rdi
  4c7bbd:	sub    $0x1,%rsi
  4c7bc1:	jb     4c7c7c <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x17c>
  4c7bc7:	mov    0xc0(%rdx,%rdi,8),%rdx
  4c7bcf:	jmp    4c7b70 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x70>
  4c7bd1:	mov    0x38(%rsp),%rdx
  4c7bd6:	mov    %rdx,0x30(%rbx)
  4c7bda:	movups 0x18(%rsp),%xmm0
  4c7bdf:	movups 0x28(%rsp),%xmm1
  4c7be4:	movups %xmm1,0x20(%rbx)
  4c7be8:	movups %xmm0,0x10(%rbx)
  4c7bec:	mov    %rax,(%rbx)
  4c7bef:	mov    %rcx,0x8(%rbx)
  4c7bf3:	jmp    4c7c6f <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x16f>
  4c7bf5:	mov    0x1e8(%r14),%rcx
  4c7bfc:	test   %rcx,%rcx
  4c7bff:	je     4c7c29 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x129>
  4c7c01:	mov    0x60(%rdx,%rdi,8),%rdi
  4c7c06:	cmp    $0x1,%ecx
  4c7c09:	jne    4c7c32 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x132>
  4c7c0b:	mov    0x200(%r14),%rsi
  4c7c12:	mov    $0x1f8,%ecx
  4c7c17:	cmp    %rsi,%rdi
  4c7c1a:	jb     4c7c5a <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x15a>
  4c7c1c:	lea    0x2cf1c5(%rip),%rdx        # 796de8 <anon.3198fbeb9761f97eba52a9dce8e9c72d.51.llvm.13428713964078981367>
  4c7c23:	call   *0x2f09a7(%rip)        # 7b85d0 <_DYNAMIC+0x2a0>
  4c7c29:	lea    -0x480808(%rip),%rsi        # 47428 <anon.3198fbeb9761f97eba52a9dce8e9c72d.49.llvm.13428713964078981367>
  4c7c30:	jmp    4c7c62 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x162>
  4c7c32:	mov    0x208(%r14),%rsi
  4c7c39:	cmp    %rsi,%rdi
  4c7c3c:	jae    4c7c95 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x195>
  4c7c3e:	mov    0x1f8(%r14),%rsi
  4c7c45:	mov    0x200(%r14),%rcx
  4c7c4c:	movzbl (%rcx,%rdi,1),%edi
  4c7c50:	mov    $0x1f0,%ecx
  4c7c55:	cmp    %rdi,%rsi
  4c7c58:	jbe    4c7ca2 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x1a2>
  4c7c5a:	imul   $0x58,%rdi,%rsi
  4c7c5e:	add    (%r14,%rcx,1),%rsi
  4c7c62:	lea    0x8(%rbx),%rdi
  4c7c66:	call   *(%rax)
  4c7c68:	movq   $0xfffffffffffffffe,(%rbx)
  4c7c6f:	mov    %rbx,%rax
  4c7c72:	add    $0x40,%rsp
  4c7c76:	pop    %rbx
  4c7c77:	pop    %r14
  4c7c79:	pop    %r15
  4c7c7b:	ret
  4c7c7c:	lea    -0x480943(%rip),%rdi        # 47340 <anon.3198fbeb9761f97eba52a9dce8e9c72d.0.llvm.13428713964078981367>
  4c7c83:	lea    0x2cedd6(%rip),%rdx        # 796a60 <anon.3198fbeb9761f97eba52a9dce8e9c72d.2.llvm.13428713964078981367>
  4c7c8a:	mov    $0x16,%esi
  4c7c8f:	call   *0x2f0943(%rip)        # 7b85d8 <_DYNAMIC+0x2a8>
  4c7c95:	lea    0x2cf164(%rip),%rdx        # 796e00 <anon.3198fbeb9761f97eba52a9dce8e9c72d.52.llvm.13428713964078981367>
  4c7c9c:	call   *0x2f092e(%rip)        # 7b85d0 <_DYNAMIC+0x2a0>
  4c7ca2:	lea    0x2cf16f(%rip),%rdx        # 796e18 <anon.3198fbeb9761f97eba52a9dce8e9c72d.53.llvm.13428713964078981367>
  4c7ca9:	call   *0x2f0921(%rip)        # 7b85d0 <_DYNAMIC+0x2a0>
  4c7caf:	int3

00000000004eff50 <paint_slot_codegen::background>:
  4eff50:	mov    0x2c86b9(%rip),%r8        # 7b8610 <_DYNAMIC+0x2e0>
  4eff57:	jmp    4c7b00 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>>
  4eff5c:	int3
  4eff5d:	int3
  4eff5e:	int3
  4eff5f:	int3
