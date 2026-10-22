00000000004c9220 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>>:
  4c9220:	push   %r15
  4c9222:	push   %r14
  4c9224:	push   %rbx
  4c9225:	sub    $0x70,%rsp
  4c9229:	mov    (%rsi),%rbx
  4c922c:	test   %rbx,%rbx
  4c922f:	je     4c9246 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x26>
  4c9231:	cmpb   $0x0,0x926(%rbx)
  4c9238:	je     4c9252 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x32>
  4c923a:	movq   $0xe,(%rdi)
  4c9241:	jmp    4c93d1 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x1b1>
  4c9246:	movq   $0xd,(%rdi)
  4c924d:	jmp    4c93d1 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x1b1>
  4c9252:	mov    %r8,%r15
  4c9255:	mov    %rdi,%r14
  4c9258:	lea    0x18(%rsp),%rdi
  4c925d:	mov    %rbx,%rsi
  4c9260:	call   4e0400 <<gpui::runtime::Runtime<paint_slot_codegen::Paint>>::resolve>
  4c9265:	mov    0x18(%rsp),%rax
  4c926a:	mov    0x20(%rsp),%rcx
  4c926f:	cmp    $0xfffffffffffffffe,%rax
  4c9273:	jne    4c92f1 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0xd1>
  4c9275:	mov    0x778(%rbx),%rdx
  4c927c:	test   %rdx,%rdx
  4c927f:	je     4c93de <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x1be>
  4c9285:	mov    %r15,%rax
  4c9288:	mov    0x780(%rbx),%rsi
  4c928f:	movzwl 0xba(%rdx),%r8d
  4c9297:	mov    %r8d,%r9d
  4c929a:	shl    $0x3,%r9d
  4c929e:	mov    $0xffffffffffffffff,%rdi
  4c92a5:	data16 cs nopw 0x0(%rax,%rax,1)
  4c92b0:	test   %r9,%r9
  4c92b3:	je     4c92da <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0xba>
  4c92b5:	cmp    0x10(%rdx,%rdi,8),%rcx
  4c92ba:	seta   %r10b
  4c92be:	sbb    $0x0,%r10b
  4c92c2:	inc    %rdi
  4c92c5:	add    $0xfffffffffffffff8,%r9
  4c92c9:	cmp    $0x1,%r10b
  4c92cd:	je     4c92b0 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x90>
  4c92cf:	movzbl %r10b,%r8d
  4c92d3:	test   %r8d,%r8d
  4c92d6:	je     4c931d <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0xfd>
  4c92d8:	jmp    4c92dd <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0xbd>
  4c92da:	mov    %r8,%rdi
  4c92dd:	sub    $0x1,%rsi
  4c92e1:	jb     4c93de <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x1be>
  4c92e7:	mov    0xc0(%rdx,%rdi,8),%rdx
  4c92ef:	jmp    4c928f <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x6f>
  4c92f1:	mov    0x48(%rsp),%rdx
  4c92f6:	mov    %r14,%rdi
  4c92f9:	mov    %rdx,0x30(%r14)
  4c92fd:	movups 0x28(%rsp),%xmm0
  4c9302:	movups 0x38(%rsp),%xmm1
  4c9307:	movups %xmm1,0x20(%r14)
  4c930c:	movups %xmm0,0x10(%r14)
  4c9311:	mov    %rax,(%r14)
  4c9314:	mov    %rcx,0x8(%r14)
  4c9318:	jmp    4c93d1 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x1b1>
  4c931d:	mov    0x60(%rdx,%rdi,8),%rdx
  4c9322:	mov    0x1e8(%rbx),%rcx
  4c9329:	lea    -0x4830d8(%rip),%rsi        # 46258 <anon.d25507b40663125b4657387c24fb9288.33.llvm.15430038915752457913+0x50>
  4c9330:	movslq (%rsi,%rcx,4),%rcx
  4c9334:	add    %rsi,%rcx
  4c9337:	jmp    *%rcx
  4c9339:	lea    -0x481910(%rip),%rsi        # 47a30 <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x1c0>
  4c9340:	jmp    4c93b6 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x196>
  4c9342:	mov    0x208(%rbx),%rsi
  4c9349:	cmp    %rsi,%rdx
  4c934c:	jae    4c93f7 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x1d7>
  4c9352:	mov    0x1f8(%rbx),%rsi
  4c9359:	mov    0x200(%rbx),%rcx
  4c9360:	movzbl (%rcx,%rdx,1),%edi
  4c9364:	cmp    %rdi,%rsi
  4c9367:	jbe    4c941d <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x1fd>
  4c936d:	imul   $0x58,%rdi,%rsi
  4c9371:	add    0x1f0(%rbx),%rsi
  4c9378:	jmp    4c93b6 <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x196>
  4c937a:	mov    0x1f0(%rbx),%rsi
  4c9381:	lea    0x18(%rsp),%rbx
  4c9386:	mov    %rbx,%rdi
  4c9389:	mov    %rax,%r15
  4c938c:	call   *0x2f52ee(%rip)        # 7be680 <_DYNAMIC+0x2a0>
  4c9392:	lea    0x8(%rsp),%rdi
  4c9397:	mov    %rbx,%rsi
  4c939a:	call   *(%r15)
  4c939d:	jmp    4c93bd <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x19d>
  4c939f:	mov    0x200(%rbx),%rsi
  4c93a6:	cmp    %rsi,%rdx
  4c93a9:	jae    4c940a <<gpui::runtime::Win<paint_slot_codegen::Paint>>::style_property::<gpui_canvas::color::Color>+0x1ea>
  4c93ab:	imul   $0x58,%rdx,%rsi
  4c93af:	add    0x1f8(%rbx),%rsi
  4c93b6:	lea    0x8(%rsp),%rdi
  4c93bb:	call   *(%rax)
  4c93bd:	movups 0x8(%rsp),%xmm0
  4c93c2:	mov    %r14,%rdi
  4c93c5:	movups %xmm0,0x8(%r14)
  4c93ca:	movq   $0xfffffffffffffffe,(%r14)
  4c93d1:	mov    %rdi,%rax
  4c93d4:	add    $0x70,%rsp
  4c93d8:	pop    %rbx
  4c93d9:	pop    %r14
  4c93db:	pop    %r15
  4c93dd:	ret
  4c93de:	lea    -0x48195d(%rip),%rdi        # 47a88 <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x218>
  4c93e5:	lea    0x2d342c(%rip),%rdx        # 79c818 <__frame_dummy_init_array_entry+0x230>
  4c93ec:	mov    $0x16,%esi
  4c93f1:	call   *0x2f5291(%rip)        # 7be688 <_DYNAMIC+0x2a8>
  4c93f7:	lea    0x2d33ea(%rip),%rax        # 79c7e8 <__frame_dummy_init_array_entry+0x200>
  4c93fe:	mov    %rdx,%rdi
  4c9401:	mov    %rax,%rdx
  4c9404:	call   *0x2f5286(%rip)        # 7be690 <_DYNAMIC+0x2b0>
  4c940a:	lea    0x2d33bf(%rip),%rax        # 79c7d0 <__frame_dummy_init_array_entry+0x1e8>
  4c9411:	mov    %rdx,%rdi
  4c9414:	mov    %rax,%rdx
  4c9417:	call   *0x2f5273(%rip)        # 7be690 <_DYNAMIC+0x2b0>
  4c941d:	lea    0x2d33dc(%rip),%rdx        # 79c800 <__frame_dummy_init_array_entry+0x218>
  4c9424:	call   *0x2f5266(%rip)        # 7be690 <_DYNAMIC+0x2b0>
  4c942a:	int3
  4c942b:	int3
  4c942c:	int3
  4c942d:	int3
  4c942e:	int3
  4c942f:	int3
