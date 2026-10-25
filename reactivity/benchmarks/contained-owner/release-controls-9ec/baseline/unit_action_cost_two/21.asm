
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fd230 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing>:
  6fd230:	55                   	push   %rbp
  6fd231:	41 57                	push   %r15
  6fd233:	41 56                	push   %r14
  6fd235:	41 55                	push   %r13
  6fd237:	41 54                	push   %r12
  6fd239:	53                   	push   %rbx
  6fd23a:	48 83 ec 78          	sub    $0x78,%rsp
  6fd23e:	48 89 fb             	mov    %rdi,%rbx
  6fd241:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  6fd248:	75 0c                	jne    6fd256 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x26>
  6fd24a:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  6fd251:	e9 c4 00 00 00       	jmp    6fd31a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fd256:	48 3b 8e b0 05 00 00 	cmp    0x5b0(%rsi),%rcx
  6fd25d:	0f 85 90 00 00 00    	jne    6fd2f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xc3>
  6fd263:	4d 89 cd             	mov    %r9,%r13
  6fd266:	49 89 d4             	mov    %rdx,%r12
  6fd269:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fd26e:	49 89 f6             	mov    %rsi,%r14
  6fd271:	4c 89 c2             	mov    %r8,%rdx
  6fd274:	e8 d7 a6 02 00       	call   727950 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  6fd279:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fd27e:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
  6fd283:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fd287:	75 6f                	jne    6fd2f8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xc8>
  6fd289:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fd290:	48 39 f7             	cmp    %rsi,%rdi
  6fd293:	0f 83 4f 02 00 00    	jae    6fd4e8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2b8>
  6fd299:	4c 89 f0             	mov    %r14,%rax
  6fd29c:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  6fd2a3:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  6fd2a7:	8b 74 d1 20          	mov    0x20(%rcx,%rdx,8),%esi
  6fd2ab:	83 e6 07             	and    $0x7,%esi
  6fd2ae:	83 fe 02             	cmp    $0x2,%esi
  6fd2b1:	75 76                	jne    6fd329 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xf9>
  6fd2b3:	48 c7 80 08 07 00 00 	movq   $0x0,0x708(%rax)
  6fd2ba:	00 00 00 00 
  6fd2be:	0f 10 80 60 06 00 00 	movups 0x660(%rax),%xmm0
  6fd2c5:	0f b6 88 20 07 00 00 	movzbl 0x720(%rax),%ecx
  6fd2cc:	48 83 b8 80 06 00 00 	cmpq   $0x0,0x680(%rax)
  6fd2d3:	00 
  6fd2d4:	74 16                	je     6fd2ec <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xbc>
  6fd2d6:	84 c9                	test   %cl,%cl
  6fd2d8:	0f 84 f5 00 00 00    	je     6fd3d3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1a3>
  6fd2de:	48 83 b8 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rax)
  6fd2e5:	ff 
  6fd2e6:	0f 85 e7 00 00 00    	jne    6fd3d3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1a3>
  6fd2ec:	31 c0                	xor    %eax,%eax
  6fd2ee:	e9 ec 00 00 00       	jmp    6fd3df <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1af>
  6fd2f3:	b8 11 00 00 00       	mov    $0x11,%eax
  6fd2f8:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fd2fd:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  6fd301:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  6fd306:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  6fd30b:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  6fd30f:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fd313:	48 89 03             	mov    %rax,(%rbx)
  6fd316:	48 89 7b 08          	mov    %rdi,0x8(%rbx)
  6fd31a:	48 83 c4 78          	add    $0x78,%rsp
  6fd31e:	5b                   	pop    %rbx
  6fd31f:	41 5c                	pop    %r12
  6fd321:	41 5d                	pop    %r13
  6fd323:	41 5e                	pop    %r14
  6fd325:	41 5f                	pop    %r15
  6fd327:	5d                   	pop    %rbp
  6fd328:	c3                   	ret
  6fd329:	4c 8d 3c d1          	lea    (%rcx,%rdx,8),%r15
  6fd32d:	49 83 7f 08 00       	cmpq   $0x0,0x8(%r15)
  6fd332:	0f 84 8f 00 00 00    	je     6fd3c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x197>
  6fd338:	49 83 c7 08          	add    $0x8,%r15
  6fd33c:	48 8d 90 10 07 00 00 	lea    0x710(%rax),%rdx
  6fd343:	4c 8d 80 28 02 00 00 	lea    0x228(%rax),%r8
  6fd34a:	48 8d 0d 87 c2 3f 00 	lea    0x3fc287(%rip),%rcx        # af95d8 <__frame_dummy_init_array_entry+0xb0>
  6fd351:	4c 8d 0d a0 c2 3f 00 	lea    0x3fc2a0(%rip),%r9        # af95f8 <__frame_dummy_init_array_entry+0xd0>
  6fd358:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fd35d:	4c 89 fe             	mov    %r15,%rsi
  6fd360:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  6fd365:	ff 15 c5 ac 42 00    	call   *0x42acc5(%rip)        # b28030 <_DYNAMIC+0x378>
  6fd36b:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fd370:	48 8b 6c 24 38       	mov    0x38(%rsp),%rbp
  6fd375:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fd37a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6fd37f:	48 89 6c 24 18       	mov    %rbp,0x18(%rsp)
  6fd384:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fd389:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6fd38e:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fd392:	0f 84 d8 01 00 00    	je     6fd570 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x340>
  6fd398:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fd39c:	75 64                	jne    6fd402 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1d2>
  6fd39e:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fd3a3:	e8 88 74 ff ff       	call   6f4830 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fd3a8:	40 f6 c5 01          	test   $0x1,%bpl
  6fd3ac:	74 71                	je     6fd41f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1ef>
  6fd3ae:	48 c1 ed 10          	shr    $0x10,%rbp
  6fd3b2:	48 89 df             	mov    %rbx,%rdi
  6fd3b5:	4c 89 f6             	mov    %r14,%rsi
  6fd3b8:	4c 89 e2             	mov    %r12,%rdx
  6fd3bb:	89 e9                	mov    %ebp,%ecx
  6fd3bd:	e8 fe b4 00 00       	call   7088c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action>
  6fd3c2:	e9 53 ff ff ff       	jmp    6fd31a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fd3c7:	48 c7 03 16 00 00 00 	movq   $0x16,(%rbx)
  6fd3ce:	e9 47 ff ff ff       	jmp    6fd31a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fd3d3:	48 8b 90 90 06 00 00 	mov    0x690(%rax),%rdx
  6fd3da:	b8 01 00 00 00       	mov    $0x1,%eax
  6fd3df:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fd3e3:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fd3e7:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  6fd3eb:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  6fd3f2:	00 
  6fd3f3:	88 4b 30             	mov    %cl,0x30(%rbx)
  6fd3f6:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fd3fd:	e9 18 ff ff ff       	jmp    6fd31a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fd402:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fd409:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fd40d:	48 89 6b 10          	mov    %rbp,0x10(%rbx)
  6fd411:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fd416:	48 89 43 18          	mov    %rax,0x18(%rbx)
  6fd41a:	e9 fb fe ff ff       	jmp    6fd31a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fd41f:	49 8b ae 60 06 00 00 	mov    0x660(%r14),%rbp
  6fd426:	48 ff c5             	inc    %rbp
  6fd429:	0f 84 ad 00 00 00    	je     6fd4dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2ac>
  6fd42f:	48 c7 44 24 30 1f 00 	movq   $0x1f,0x30(%rsp)
  6fd436:	00 00 
  6fd438:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fd43d:	e8 3e a6 ff ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fd442:	48 8d 0d 8f c1 3f 00 	lea    0x3fc18f(%rip),%rcx        # af95d8 <__frame_dummy_init_array_entry+0xb0>
  6fd449:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fd44e:	4c 89 fe             	mov    %r15,%rsi
  6fd451:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  6fd456:	ff 15 dc ab 42 00    	call   *0x42abdc(%rip)        # b28038 <_DYNAMIC+0x380>
  6fd45c:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fd461:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fd466:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  6fd46b:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fd470:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6fd475:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fd479:	0f 84 92 00 00 00    	je     6fd511 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2e1>
  6fd47f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fd483:	75 3e                	jne    6fd4c3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x293>
  6fd485:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fd48a:	e8 a1 73 ff ff       	call   6f4830 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fd48f:	49 89 ae 60 06 00 00 	mov    %rbp,0x660(%r14)
  6fd496:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fd49d:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fd4a4:	00 00 00 00 
  6fd4a8:	48 89 df             	mov    %rbx,%rdi
  6fd4ab:	4c 89 f6             	mov    %r14,%rsi
  6fd4ae:	4c 89 e2             	mov    %r12,%rdx
  6fd4b1:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fd4b6:	4d 89 e8             	mov    %r13,%r8
  6fd4b9:	e8 42 01 00 00       	call   6fd600 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing>
  6fd4be:	e9 57 fe ff ff       	jmp    6fd31a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fd4c3:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  6fd4c8:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fd4cc:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fd4d3:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fd4d7:	e9 3e fe ff ff       	jmp    6fd31a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fd4dc:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  6fd4e3:	e9 32 fe ff ff       	jmp    6fd31a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fd4e8:	48 8d 15 99 c4 3f 00 	lea    0x3fc499(%rip),%rdx        # af9988 <__frame_dummy_init_array_entry+0x460>
  6fd4ef:	ff 15 1b ab 42 00    	call   *0x42ab1b(%rip)        # b28010 <_DYNAMIC+0x358>
  6fd4f5:	48 89 c7             	mov    %rax,%rdi
  6fd4f8:	ff 15 22 ab 42 00    	call   *0x42ab22(%rip)        # b28020 <_DYNAMIC+0x368>
  6fd4fe:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fd503:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  6fd508:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fd50f:	ff ff 
  6fd511:	4c 89 f7             	mov    %r14,%rdi
  6fd514:	e8 c7 aa 02 00       	call   727fe0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fd519:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fd520:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fd525:	e8 06 73 ff ff       	call   6f4830 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fd52a:	e9 eb fd ff ff       	jmp    6fd31a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fd52f:	ff 15 f3 aa 42 00    	call   *0x42aaf3(%rip)        # b28028 <_DYNAMIC+0x370>
  6fd535:	48 89 c3             	mov    %rax,%rbx
  6fd538:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fd53d:	e8 ee 72 ff ff       	call   6f4830 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fd542:	e9 a2 00 00 00       	jmp    6fd5e9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x3b9>
  6fd547:	48 89 c7             	mov    %rax,%rdi
  6fd54a:	ff 15 d0 aa 42 00    	call   *0x42aad0(%rip)        # b28020 <_DYNAMIC+0x368>
  6fd550:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fd555:	48 89 c5             	mov    %rax,%rbp
  6fd558:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fd55d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fd562:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fd567:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fd56e:	ff ff 
  6fd570:	4c 89 f7             	mov    %r14,%rdi
  6fd573:	e8 68 aa 02 00       	call   727fe0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fd578:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  6fd57d:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fd584:	49 8b 06             	mov    (%r14),%rax
  6fd587:	48 85 c0             	test   %rax,%rax
  6fd58a:	74 05                	je     6fd591 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x361>
  6fd58c:	48 89 ef             	mov    %rbp,%rdi
  6fd58f:	ff d0                	call   *%rax
  6fd591:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6fd595:	48 85 f6             	test   %rsi,%rsi
  6fd598:	0f 84 7c fd ff ff    	je     6fd31a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fd59e:	49 8b 56 10          	mov    0x10(%r14),%rdx
  6fd5a2:	48 89 ef             	mov    %rbp,%rdi
  6fd5a5:	ff 15 55 a9 42 00    	call   *0x42a955(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fd5ab:	e9 6a fd ff ff       	jmp    6fd31a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fd5b0:	ff 15 72 aa 42 00    	call   *0x42aa72(%rip)        # b28028 <_DYNAMIC+0x370>
  6fd5b6:	48 89 c3             	mov    %rax,%rbx
  6fd5b9:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6fd5bd:	48 85 f6             	test   %rsi,%rsi
  6fd5c0:	74 27                	je     6fd5e9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x3b9>
  6fd5c2:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fd5c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  6fd5cb:	48 89 ef             	mov    %rbp,%rdi
  6fd5ce:	ff 15 2c a9 42 00    	call   *0x42a92c(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fd5d4:	48 89 df             	mov    %rbx,%rdi
  6fd5d7:	e8 94 ab 3f 00       	call   af8170 <_Unwind_Resume@plt>
  6fd5dc:	48 89 c3             	mov    %rax,%rbx
  6fd5df:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fd5e4:	e8 47 72 ff ff       	call   6f4830 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fd5e9:	48 89 df             	mov    %rbx,%rdi
  6fd5ec:	e8 7f ab 3f 00       	call   af8170 <_Unwind_Resume@plt>
  6fd5f1:	ff 15 39 a9 42 00    	call   *0x42a939(%rip)        # b27f30 <_DYNAMIC+0x278>
