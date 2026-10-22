00000000004c9000 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>>:
  4c9000:	push   %r15
  4c9002:	push   %r14
  4c9004:	push   %rbx
  4c9005:	sub    $0x60,%rsp
  4c9009:	mov    %rdi,%rbx
  4c900c:	mov    (%rsi),%r14
  4c900f:	test   %r14,%r14
  4c9012:	je     4c902a <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x2a>
  4c9014:	cmpb   $0x0,0x926(%r14)
  4c901c:	je     4c9036 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x36>
  4c901e:	movq   $0xe,(%rbx)
  4c9025:	jmp    4c9215 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x215>
  4c902a:	movq   $0xd,(%rbx)
  4c9031:	jmp    4c9215 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x215>
  4c9036:	mov    %r8,%r15
  4c9039:	mov    %rsp,%rdi
  4c903c:	mov    %r14,%rsi
  4c903f:	call   4e0250 <<gpui::runtime::Runtime<paint_slot_codegen::Paint>>::resolve>
  4c9044:	mov    (%rsp),%rax
  4c9048:	mov    0x8(%rsp),%rcx
  4c904d:	cmp    $0xfffffffffffffffe,%rax
  4c9051:	jne    4c90d1 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0xd1>
  4c9053:	mov    0x778(%r14),%rdx
  4c905a:	test   %rdx,%rdx
  4c905d:	je     4c9222 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x222>
  4c9063:	mov    %r15,%rax
  4c9066:	mov    0x780(%r14),%rsi
  4c906d:	movzwl 0xba(%rdx),%r8d
  4c9075:	mov    %r8d,%r9d
  4c9078:	shl    $0x3,%r9d
  4c907c:	mov    $0xffffffffffffffff,%rdi
  4c9083:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  4c9090:	test   %r9,%r9
  4c9093:	je     4c90ba <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0xba>
  4c9095:	cmp    0x10(%rdx,%rdi,8),%rcx
  4c909a:	seta   %r10b
  4c909e:	sbb    $0x0,%r10b
  4c90a2:	inc    %rdi
  4c90a5:	add    $0xfffffffffffffff8,%r9
  4c90a9:	cmp    $0x1,%r10b
  4c90ad:	je     4c9090 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x90>
  4c90af:	movzbl %r10b,%r8d
  4c90b3:	test   %r8d,%r8d
  4c90b6:	je     4c90f8 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0xf8>
  4c90b8:	jmp    4c90bd <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0xbd>
  4c90ba:	mov    %r8,%rdi
  4c90bd:	sub    $0x1,%rsi
  4c90c1:	jb     4c9222 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x222>
  4c90c7:	mov    0xc0(%rdx,%rdi,8),%rdx
  4c90cf:	jmp    4c906d <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x6d>
  4c90d1:	mov    0x30(%rsp),%rdx
  4c90d6:	mov    %rdx,0x30(%rbx)
  4c90da:	movups 0x10(%rsp),%xmm0
  4c90df:	movups 0x20(%rsp),%xmm1
  4c90e4:	movups %xmm1,0x20(%rbx)
  4c90e8:	movups %xmm0,0x10(%rbx)
  4c90ec:	mov    %rax,(%rbx)
  4c90ef:	mov    %rcx,0x8(%rbx)
  4c90f3:	jmp    4c9215 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x215>
  4c90f8:	mov    0x60(%rdx,%rdi,8),%rdx
  4c90fd:	mov    0x1e8(%r14),%rcx
  4c9104:	lea    -0x482fa3(%rip),%rsi        # 46168 <anon.63ba51eba9abda1b547d21a2c777cba3.33.llvm.18151185593448465015+0x50>
  4c910b:	movslq (%rsi,%rcx,4),%rcx
  4c910f:	add    %rsi,%rcx
  4c9112:	jmp    *%rcx
  4c9114:	movups -0x4816b3(%rip),%xmm0        # 47a68 <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x2e8>
  4c911b:	movaps %xmm0,0x40(%rsp)
  4c9120:	movups -0x4816cf(%rip),%xmm0        # 47a58 <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x2d8>
  4c9127:	movaps %xmm0,0x30(%rsp)
  4c912c:	movups -0x4816eb(%rip),%xmm0        # 47a48 <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x2c8>
  4c9133:	movaps %xmm0,0x20(%rsp)
  4c9138:	movups -0x481707(%rip),%xmm0        # 47a38 <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x2b8>
  4c913f:	movaps %xmm0,0x10(%rsp)
  4c9144:	movups -0x481723(%rip),%xmm0        # 47a28 <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x2a8>
  4c914b:	movaps %xmm0,(%rsp)
  4c914f:	movabs $0x3000100000000,%rcx
  4c9159:	mov    %rcx,0x50(%rsp)
  4c915e:	jmp    4c9205 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x205>
  4c9163:	mov    0x208(%r14),%rsi
  4c916a:	cmp    %rsi,%rdx
  4c916d:	jae    4c923b <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x23b>
  4c9173:	mov    0x1f8(%r14),%rsi
  4c917a:	mov    0x200(%r14),%rcx
  4c9181:	movzbl (%rcx,%rdx,1),%edi
  4c9185:	cmp    %rdi,%rsi
  4c9188:	jbe    4c9261 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x261>
  4c918e:	mov    0x1f0(%r14),%rcx
  4c9195:	imul   $0x58,%rdi,%rdx
  4c9199:	jmp    4c91cb <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x1cb>
  4c919b:	mov    0x1f0(%r14),%rsi
  4c91a2:	mov    %rsp,%rdi
  4c91a5:	call   *0x2f4d3d(%rip)        # 7bdee8 <_DYNAMIC+0x2a0>
  4c91ab:	mov    %r15,%rax
  4c91ae:	jmp    4c9205 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x205>
  4c91b0:	mov    0x200(%r14),%rsi
  4c91b7:	cmp    %rsi,%rdx
  4c91ba:	jae    4c924e <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x24e>
  4c91c0:	mov    0x1f8(%r14),%rcx
  4c91c7:	imul   $0x58,%rdx,%rdx
  4c91cb:	mov    0x50(%rcx,%rdx,1),%rsi
  4c91d0:	mov    %rsi,0x50(%rsp)
  4c91d5:	movups 0x40(%rcx,%rdx,1),%xmm0
  4c91da:	movaps %xmm0,0x40(%rsp)
  4c91df:	movups (%rcx,%rdx,1),%xmm0
  4c91e3:	movups 0x10(%rcx,%rdx,1),%xmm1
  4c91e8:	movups 0x20(%rcx,%rdx,1),%xmm2
  4c91ed:	movups 0x30(%rcx,%rdx,1),%xmm3
  4c91f2:	movaps %xmm3,0x30(%rsp)
  4c91f7:	movaps %xmm2,0x20(%rsp)
  4c91fc:	movaps %xmm1,0x10(%rsp)
  4c9201:	movaps %xmm0,(%rsp)
  4c9205:	lea    0x8(%rbx),%rdi
  4c9209:	mov    %rsp,%rsi
  4c920c:	call   *(%rax)
  4c920e:	movq   $0xfffffffffffffffe,(%rbx)
  4c9215:	mov    %rbx,%rax
  4c9218:	add    $0x60,%rsp
  4c921c:	pop    %rbx
  4c921d:	pop    %r14
  4c921f:	pop    %r15
  4c9221:	ret
  4c9222:	lea    -0x4818e9(%rip),%rdi        # 47940 <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x1c0>
  4c9229:	lea    0x2d2f10(%rip),%rdx        # 79c140 <__frame_dummy_init_array_entry+0x1e8>
  4c9230:	mov    $0x16,%esi
  4c9235:	call   *0x2f4cb5(%rip)        # 7bdef0 <_DYNAMIC+0x2a8>
  4c923b:	lea    0x2d329e(%rip),%rax        # 79c4e0 <__frame_dummy_init_array_entry+0x588>
  4c9242:	mov    %rdx,%rdi
  4c9245:	mov    %rax,%rdx
  4c9248:	call   *0x2f4caa(%rip)        # 7bdef8 <_DYNAMIC+0x2b0>
  4c924e:	lea    0x2d3273(%rip),%rax        # 79c4c8 <__frame_dummy_init_array_entry+0x570>
  4c9255:	mov    %rdx,%rdi
  4c9258:	mov    %rax,%rdx
  4c925b:	call   *0x2f4c97(%rip)        # 7bdef8 <_DYNAMIC+0x2b0>
  4c9261:	lea    0x2d3290(%rip),%rdx        # 79c4f8 <__frame_dummy_init_array_entry+0x5a0>
  4c9268:	call   *0x2f4c8a(%rip)        # 7bdef8 <_DYNAMIC+0x2b0>
  4c926e:	int3
  4c926f:	int3

00000000004f3dc0 <paint_slot_codegen::background>:
  4f3dc0:	mov    0x2ca169(%rip),%r8        # 7bdf30 <_DYNAMIC+0x2e8>
  4f3dc7:	jmp    4c9000 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>>
  4f3dcc:	int3
  4f3dcd:	int3
  4f3dce:	int3
  4f3dcf:	int3

0000000000506f10 <<gpui::runtime::styles::colours::Bank>::colors>:
  506f10:	push   %rax
  506f11:	test   %edx,%edx
  506f13:	js     506f2d <<gpui::runtime::styles::colours::Bank>::colors+0x1d>
  506f15:	cmp    $0x5,%edx
  506f18:	jae    506f6b <<gpui::runtime::styles::colours::Bank>::colors+0x5b>
  506f1a:	mov    %edx,%eax
  506f1c:	lea    0x296b25(%rip),%rdx        # 79da48 <anon.ba4c4012a041fefd24db106f6150e4fd.26.llvm.6397527957884276752+0x18>
  506f23:	mov    (%rdx,%rax,8),%rdx
  506f27:	test   %ecx,%ecx
  506f29:	jns    506f57 <<gpui::runtime::styles::colours::Bank>::colors+0x47>
  506f2b:	jmp    506f83 <<gpui::runtime::styles::colours::Bank>::colors+0x73>
  506f2d:	and    $0x7fffffff,%edx
  506f33:	mov    0x10(%rsi),%rax
  506f37:	cmp    %rdx,%rax
  506f3a:	jbe    506fca <<gpui::runtime::styles::colours::Bank>::colors+0xba>
  506f40:	mov    0x8(%rsi),%rax
  506f44:	lea    (%rdx,%rdx,2),%rdx
  506f48:	shl    $0x4,%rdx
  506f4c:	add    %rax,%rdx
  506f4f:	add    $0x8,%rdx
  506f53:	test   %ecx,%ecx
  506f55:	js     506f83 <<gpui::runtime::styles::colours::Bank>::colors+0x73>
  506f57:	cmp    $0x5,%ecx
  506f5a:	jae    506fa7 <<gpui::runtime::styles::colours::Bank>::colors+0x97>
  506f5c:	mov    %ecx,%eax
  506f5e:	lea    0x296ae3(%rip),%rcx        # 79da48 <anon.ba4c4012a041fefd24db106f6150e4fd.26.llvm.6397527957884276752+0x18>
  506f65:	mov    (%rcx,%rax,8),%rcx
  506f69:	jmp    506fbb <<gpui::runtime::styles::colours::Bank>::colors+0xab>
  506f6b:	add    $0xfffffffb,%edx
  506f6e:	mov    0x28(%rsi),%rax
  506f72:	cmp    %rdx,%rax
  506f75:	jbe    506ff3 <<gpui::runtime::styles::colours::Bank>::colors+0xe3>
  506f77:	shl    $0x4,%rdx
  506f7b:	add    0x20(%rsi),%rdx
  506f7f:	test   %ecx,%ecx
  506f81:	jns    506f57 <<gpui::runtime::styles::colours::Bank>::colors+0x47>
  506f83:	and    $0x7fffffff,%ecx
  506f89:	mov    0x10(%rsi),%rax
  506f8d:	cmp    %rcx,%rax
  506f90:	jbe    506fe0 <<gpui::runtime::styles::colours::Bank>::colors+0xd0>
  506f92:	mov    0x8(%rsi),%rax
  506f96:	lea    (%rcx,%rcx,2),%rcx
  506f9a:	shl    $0x4,%rcx
  506f9e:	add    %rax,%rcx
  506fa1:	add    $0x8,%rcx
  506fa5:	jmp    506fbb <<gpui::runtime::styles::colours::Bank>::colors+0xab>
  506fa7:	add    $0xfffffffb,%ecx
  506faa:	mov    0x28(%rsi),%rax
  506fae:	cmp    %rcx,%rax
  506fb1:	jbe    507009 <<gpui::runtime::styles::colours::Bank>::colors+0xf9>
  506fb3:	shl    $0x4,%rcx
  506fb7:	add    0x20(%rsi),%rcx
  506fbb:	movups (%rcx),%xmm0
  506fbe:	movups %xmm0,0x10(%rdi)
  506fc2:	movups (%rdx),%xmm0
  506fc5:	movups %xmm0,(%rdi)
  506fc8:	pop    %rax
  506fc9:	ret
  506fca:	lea    0x29699f(%rip),%rcx        # 79d970 <anon.ba4c4012a041fefd24db106f6150e4fd.8.llvm.6397527957884276752+0x60>
  506fd1:	mov    %rdx,%rdi
  506fd4:	mov    %rax,%rsi
  506fd7:	mov    %rcx,%rdx
  506fda:	call   *0x2b6f18(%rip)        # 7bdef8 <_DYNAMIC+0x2b0>
  506fe0:	lea    0x296989(%rip),%rdx        # 79d970 <anon.ba4c4012a041fefd24db106f6150e4fd.8.llvm.6397527957884276752+0x60>
  506fe7:	mov    %rcx,%rdi
  506fea:	mov    %rax,%rsi
  506fed:	call   *0x2b6f05(%rip)        # 7bdef8 <_DYNAMIC+0x2b0>
  506ff3:	lea    0x29695e(%rip),%rcx        # 79d958 <anon.ba4c4012a041fefd24db106f6150e4fd.8.llvm.6397527957884276752+0x48>
  506ffa:	mov    %rdx,%rdi
  506ffd:	mov    %rax,%rsi
  507000:	mov    %rcx,%rdx
  507003:	call   *0x2b6eef(%rip)        # 7bdef8 <_DYNAMIC+0x2b0>
  507009:	lea    0x296948(%rip),%rdx        # 79d958 <anon.ba4c4012a041fefd24db106f6150e4fd.8.llvm.6397527957884276752+0x48>
  507010:	mov    %rcx,%rdi
  507013:	mov    %rax,%rsi
  507016:	call   *0x2b6edc(%rip)        # 7bdef8 <_DYNAMIC+0x2b0>
  50701c:	int3
  50701d:	int3
  50701e:	int3
  50701f:	int3

0000000000507380 <<gpui::runtime::styles::colours::Bound>::get>:
  507380:	push   %rbp
  507381:	push   %r15
  507383:	push   %r14
  507385:	push   %rbx
  507386:	sub    $0x48,%rsp
  50738a:	mov    %rdi,%rbx
  50738d:	mov    (%rsi),%rax
  507390:	test   %rax,%rax
  507393:	je     5073b5 <<gpui::runtime::styles::colours::Bound>::get+0x35>
  507395:	cmp    $0x1,%eax
  507398:	jne    5073be <<gpui::runtime::styles::colours::Bound>::get+0x3e>
  50739a:	mov    0x18(%rsi),%rax
  50739e:	cmp    %rax,%rdx
  5073a1:	jae    50746b <<gpui::runtime::styles::colours::Bound>::get+0xeb>
  5073a7:	lea    (%rdx,%rdx,8),%rax
  5073ab:	shl    $0x3,%rax
  5073af:	add    0x10(%rsi),%rax
  5073b3:	jmp    5073eb <<gpui::runtime::styles::colours::Bound>::get+0x6b>
  5073b5:	lea    -0x4be4a0(%rip),%rax        # 48f1c <anon.ba4c4012a041fefd24db106f6150e4fd.9.llvm.6397527957884276752>
  5073bc:	jmp    5073eb <<gpui::runtime::styles::colours::Bound>::get+0x6b>
  5073be:	mov    0x20(%rsi),%rax
  5073c2:	cmp    %rax,%rdx
  5073c5:	jae    507481 <<gpui::runtime::styles::colours::Bound>::get+0x101>
  5073cb:	mov    0x10(%rsi),%rax
  5073cf:	mov    0x18(%rsi),%rcx
  5073d3:	movzbl (%rcx,%rdx,1),%edi
  5073d7:	cmp    %rdi,%rax
  5073da:	jbe    507497 <<gpui::runtime::styles::colours::Bound>::get+0x117>
  5073e0:	lea    (%rdi,%rdi,8),%rax
  5073e4:	shl    $0x3,%eax
  5073e7:	add    0x8(%rsi),%rax
  5073eb:	mov    (%rax),%ebp
  5073ed:	movss  0x4(%rax),%xmm0
  5073f2:	movss  %xmm0,0xc(%rsp)
  5073f8:	mov    0x8(%rax),%r14d
  5073fc:	mov    0x2c(%rax),%rcx
  507400:	mov    %rcx,0x4c(%rbx)
  507404:	movups 0x1c(%rax),%xmm0
  507408:	movups %xmm0,0x3c(%rbx)
  50740c:	mov    0x40(%rax),%edx
  50740f:	mov    0x44(%rax),%ecx
  507412:	add    $0x28,%rsi
  507416:	movups 0xc(%rax),%xmm0
  50741a:	movaps %xmm0,0x10(%rsp)
  50741f:	mov    0x34(%rax),%r15d
  507423:	lea    0x28(%rsp),%rdi
  507428:	call   506f10 <<gpui::runtime::styles::colours::Bank>::colors>
  50742d:	movups 0x28(%rsp),%xmm0
  507432:	movups %xmm0,0x1c(%rbx)
  507436:	movups 0x38(%rsp),%xmm0
  50743b:	movups %xmm0,0x2c(%rbx)
  50743f:	mov    %ebp,(%rbx)
  507441:	movss  0xc(%rsp),%xmm0
  507447:	movss  %xmm0,0x4(%rbx)
  50744c:	mov    %r14d,0x8(%rbx)
  507450:	movaps 0x10(%rsp),%xmm0
  507455:	movups %xmm0,0xc(%rbx)
  507459:	mov    %r15d,0x54(%rbx)
  50745d:	mov    %rbx,%rax
  507460:	add    $0x48,%rsp
  507464:	pop    %rbx
  507465:	pop    %r14
  507467:	pop    %r15
  507469:	pop    %rbp
  50746a:	ret
  50746b:	lea    0x29658e(%rip),%rcx        # 79da00 <anon.ba4c4012a041fefd24db106f6150e4fd.24.llvm.6397527957884276752>
  507472:	mov    %rdx,%rdi
  507475:	mov    %rax,%rsi
  507478:	mov    %rcx,%rdx
  50747b:	call   *0x2b6a77(%rip)        # 7bdef8 <_DYNAMIC+0x2b0>
  507481:	lea    0x296590(%rip),%rcx        # 79da18 <anon.ba4c4012a041fefd24db106f6150e4fd.25.llvm.6397527957884276752>
  507488:	mov    %rdx,%rdi
  50748b:	mov    %rax,%rsi
  50748e:	mov    %rcx,%rdx
  507491:	call   *0x2b6a61(%rip)        # 7bdef8 <_DYNAMIC+0x2b0>
  507497:	lea    0x296592(%rip),%rdx        # 79da30 <anon.ba4c4012a041fefd24db106f6150e4fd.26.llvm.6397527957884276752>
  50749e:	mov    %rax,%rsi
  5074a1:	call   *0x2b6a51(%rip)        # 7bdef8 <_DYNAMIC+0x2b0>
  5074a7:	int3
  5074a8:	int3
  5074a9:	int3
  5074aa:	int3
  5074ab:	int3
  5074ac:	int3
  5074ad:	int3
  5074ae:	int3
  5074af:	int3
