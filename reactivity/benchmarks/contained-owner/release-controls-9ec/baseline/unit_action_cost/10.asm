
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

0000000000707250 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing>:
  707250:	55                   	push   %rbp
  707251:	41 57                	push   %r15
  707253:	41 56                	push   %r14
  707255:	41 55                	push   %r13
  707257:	41 54                	push   %r12
  707259:	53                   	push   %rbx
  70725a:	48 83 ec 78          	sub    $0x78,%rsp
  70725e:	48 89 fb             	mov    %rdi,%rbx
  707261:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  707268:	75 0c                	jne    707276 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x26>
  70726a:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  707271:	e9 c4 00 00 00       	jmp    70733a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707276:	48 3b 8e b0 05 00 00 	cmp    0x5b0(%rsi),%rcx
  70727d:	0f 85 90 00 00 00    	jne    707313 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xc3>
  707283:	4d 89 cd             	mov    %r9,%r13
  707286:	49 89 d4             	mov    %rdx,%r12
  707289:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  70728e:	49 89 f6             	mov    %rsi,%r14
  707291:	4c 89 c2             	mov    %r8,%rdx
  707294:	e8 e7 5f 01 00       	call   71d280 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  707299:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  70729e:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
  7072a3:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  7072a7:	75 6f                	jne    707318 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xc8>
  7072a9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  7072b0:	48 39 f7             	cmp    %rsi,%rdi
  7072b3:	0f 83 4f 02 00 00    	jae    707508 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x2b8>
  7072b9:	4c 89 f0             	mov    %r14,%rax
  7072bc:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  7072c3:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  7072c7:	8b 74 d1 20          	mov    0x20(%rcx,%rdx,8),%esi
  7072cb:	83 e6 07             	and    $0x7,%esi
  7072ce:	83 fe 02             	cmp    $0x2,%esi
  7072d1:	75 76                	jne    707349 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xf9>
  7072d3:	48 c7 80 08 07 00 00 	movq   $0x0,0x708(%rax)
  7072da:	00 00 00 00 
  7072de:	0f 10 80 60 06 00 00 	movups 0x660(%rax),%xmm0
  7072e5:	0f b6 88 20 07 00 00 	movzbl 0x720(%rax),%ecx
  7072ec:	48 83 b8 80 06 00 00 	cmpq   $0x0,0x680(%rax)
  7072f3:	00 
  7072f4:	74 16                	je     70730c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xbc>
  7072f6:	84 c9                	test   %cl,%cl
  7072f8:	0f 84 f5 00 00 00    	je     7073f3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1a3>
  7072fe:	48 83 b8 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rax)
  707305:	ff 
  707306:	0f 85 e7 00 00 00    	jne    7073f3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1a3>
  70730c:	31 c0                	xor    %eax,%eax
  70730e:	e9 ec 00 00 00       	jmp    7073ff <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1af>
  707313:	b8 11 00 00 00       	mov    $0x11,%eax
  707318:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  70731d:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  707321:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  707326:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  70732b:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  70732f:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  707333:	48 89 03             	mov    %rax,(%rbx)
  707336:	48 89 7b 08          	mov    %rdi,0x8(%rbx)
  70733a:	48 83 c4 78          	add    $0x78,%rsp
  70733e:	5b                   	pop    %rbx
  70733f:	41 5c                	pop    %r12
  707341:	41 5d                	pop    %r13
  707343:	41 5e                	pop    %r14
  707345:	41 5f                	pop    %r15
  707347:	5d                   	pop    %rbp
  707348:	c3                   	ret
  707349:	4c 8d 3c d1          	lea    (%rcx,%rdx,8),%r15
  70734d:	49 83 7f 08 00       	cmpq   $0x0,0x8(%r15)
  707352:	0f 84 8f 00 00 00    	je     7073e7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x197>
  707358:	49 83 c7 08          	add    $0x8,%r15
  70735c:	48 8d 90 10 07 00 00 	lea    0x710(%rax),%rdx
  707363:	4c 8d 80 28 02 00 00 	lea    0x228(%rax),%r8
  70736a:	48 8d 0d 77 ba 3c 00 	lea    0x3cba77(%rip),%rcx        # ad2de8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x1d0>
  707371:	4c 8d 0d 90 ba 3c 00 	lea    0x3cba90(%rip),%r9        # ad2e08 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x1f0>
  707378:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  70737d:	4c 89 fe             	mov    %r15,%rsi
  707380:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  707385:	ff 15 fd a0 3f 00    	call   *0x3fa0fd(%rip)        # b01488 <_DYNAMIC+0x398>
  70738b:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  707390:	48 8b 6c 24 38       	mov    0x38(%rsp),%rbp
  707395:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  70739a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70739f:	48 89 6c 24 18       	mov    %rbp,0x18(%rsp)
  7073a4:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  7073a9:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  7073ae:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  7073b2:	0f 84 d8 01 00 00    	je     707590 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x340>
  7073b8:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7073bc:	75 64                	jne    707422 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1d2>
  7073be:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7073c3:	e8 98 a4 ff ff       	call   701860 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  7073c8:	40 f6 c5 01          	test   $0x1,%bpl
  7073cc:	74 71                	je     70743f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1ef>
  7073ce:	48 c1 ed 10          	shr    $0x10,%rbp
  7073d2:	48 89 df             	mov    %rbx,%rdi
  7073d5:	4c 89 f6             	mov    %r14,%rsi
  7073d8:	4c 89 e2             	mov    %r12,%rdx
  7073db:	89 e9                	mov    %ebp,%ecx
  7073dd:	e8 fe 64 00 00       	call   70d8e0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action>
  7073e2:	e9 53 ff ff ff       	jmp    70733a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  7073e7:	48 c7 03 16 00 00 00 	movq   $0x16,(%rbx)
  7073ee:	e9 47 ff ff ff       	jmp    70733a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  7073f3:	48 8b 90 90 06 00 00 	mov    0x690(%rax),%rdx
  7073fa:	b8 01 00 00 00       	mov    $0x1,%eax
  7073ff:	48 89 43 08          	mov    %rax,0x8(%rbx)
  707403:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  707407:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70740b:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  707412:	00 
  707413:	88 4b 30             	mov    %cl,0x30(%rbx)
  707416:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70741d:	e9 18 ff ff ff       	jmp    70733a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707422:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  707429:	48 89 43 08          	mov    %rax,0x8(%rbx)
  70742d:	48 89 6b 10          	mov    %rbp,0x10(%rbx)
  707431:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  707436:	48 89 43 18          	mov    %rax,0x18(%rbx)
  70743a:	e9 fb fe ff ff       	jmp    70733a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  70743f:	49 8b ae 60 06 00 00 	mov    0x660(%r14),%rbp
  707446:	48 ff c5             	inc    %rbp
  707449:	0f 84 ad 00 00 00    	je     7074fc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x2ac>
  70744f:	48 c7 44 24 30 1f 00 	movq   $0x1f,0x30(%rsp)
  707456:	00 00 
  707458:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  70745d:	e8 0e cf ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  707462:	48 8d 0d 7f b9 3c 00 	lea    0x3cb97f(%rip),%rcx        # ad2de8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x1d0>
  707469:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  70746e:	4c 89 fe             	mov    %r15,%rsi
  707471:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  707476:	ff 15 14 a0 3f 00    	call   *0x3fa014(%rip)        # b01490 <_DYNAMIC+0x3a0>
  70747c:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  707481:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  707486:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  70748b:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  707490:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  707495:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  707499:	0f 84 92 00 00 00    	je     707531 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x2e1>
  70749f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7074a3:	75 3e                	jne    7074e3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x293>
  7074a5:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7074aa:	e8 b1 a3 ff ff       	call   701860 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  7074af:	49 89 ae 60 06 00 00 	mov    %rbp,0x660(%r14)
  7074b6:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  7074bd:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  7074c4:	00 00 00 00 
  7074c8:	48 89 df             	mov    %rbx,%rdi
  7074cb:	4c 89 f6             	mov    %r14,%rsi
  7074ce:	4c 89 e2             	mov    %r12,%rdx
  7074d1:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  7074d6:	4d 89 e8             	mov    %r13,%r8
  7074d9:	e8 42 01 00 00       	call   707620 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing>
  7074de:	e9 57 fe ff ff       	jmp    70733a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  7074e3:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  7074e8:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  7074ec:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  7074f3:	48 89 43 08          	mov    %rax,0x8(%rbx)
  7074f7:	e9 3e fe ff ff       	jmp    70733a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  7074fc:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  707503:	e9 32 fe ff ff       	jmp    70733a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707508:	48 8d 15 89 bc 3c 00 	lea    0x3cbc89(%rip),%rdx        # ad3198 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x580>
  70750f:	ff 15 53 9f 3f 00    	call   *0x3f9f53(%rip)        # b01468 <_DYNAMIC+0x378>
  707515:	48 89 c7             	mov    %rax,%rdi
  707518:	ff 15 5a 9f 3f 00    	call   *0x3f9f5a(%rip)        # b01478 <_DYNAMIC+0x388>
  70751e:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  707523:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  707528:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  70752f:	ff ff 
  707531:	4c 89 f7             	mov    %r14,%rdi
  707534:	e8 d7 63 01 00       	call   71d910 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  707539:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  707540:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  707545:	e8 16 a3 ff ff       	call   701860 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  70754a:	e9 eb fd ff ff       	jmp    70733a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  70754f:	ff 15 2b 9f 3f 00    	call   *0x3f9f2b(%rip)        # b01480 <_DYNAMIC+0x390>
  707555:	48 89 c3             	mov    %rax,%rbx
  707558:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70755d:	e8 fe a2 ff ff       	call   701860 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  707562:	e9 a2 00 00 00       	jmp    707609 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x3b9>
  707567:	48 89 c7             	mov    %rax,%rdi
  70756a:	ff 15 08 9f 3f 00    	call   *0x3f9f08(%rip)        # b01478 <_DYNAMIC+0x388>
  707570:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  707575:	48 89 c5             	mov    %rax,%rbp
  707578:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  70757d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  707582:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  707587:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  70758e:	ff ff 
  707590:	4c 89 f7             	mov    %r14,%rdi
  707593:	e8 78 63 01 00       	call   71d910 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  707598:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  70759d:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  7075a4:	49 8b 06             	mov    (%r14),%rax
  7075a7:	48 85 c0             	test   %rax,%rax
  7075aa:	74 05                	je     7075b1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x361>
  7075ac:	48 89 ef             	mov    %rbp,%rdi
  7075af:	ff d0                	call   *%rax
  7075b1:	49 8b 76 08          	mov    0x8(%r14),%rsi
  7075b5:	48 85 f6             	test   %rsi,%rsi
  7075b8:	0f 84 7c fd ff ff    	je     70733a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  7075be:	49 8b 56 10          	mov    0x10(%r14),%rdx
  7075c2:	48 89 ef             	mov    %rbp,%rdi
  7075c5:	ff 15 6d 9d 3f 00    	call   *0x3f9d6d(%rip)        # b01338 <_DYNAMIC+0x248>
  7075cb:	e9 6a fd ff ff       	jmp    70733a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  7075d0:	ff 15 aa 9e 3f 00    	call   *0x3f9eaa(%rip)        # b01480 <_DYNAMIC+0x390>
  7075d6:	48 89 c3             	mov    %rax,%rbx
  7075d9:	49 8b 76 08          	mov    0x8(%r14),%rsi
  7075dd:	48 85 f6             	test   %rsi,%rsi
  7075e0:	74 27                	je     707609 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x3b9>
  7075e2:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7075e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  7075eb:	48 89 ef             	mov    %rbp,%rdi
  7075ee:	ff 15 44 9d 3f 00    	call   *0x3f9d44(%rip)        # b01338 <_DYNAMIC+0x248>
  7075f4:	48 89 df             	mov    %rbx,%rdi
  7075f7:	e8 e4 a1 3c 00       	call   ad17e0 <_Unwind_Resume@plt>
  7075fc:	48 89 c3             	mov    %rax,%rbx
  7075ff:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  707604:	e8 57 a2 ff ff       	call   701860 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  707609:	48 89 df             	mov    %rbx,%rdi
  70760c:	e8 cf a1 3c 00       	call   ad17e0 <_Unwind_Resume@plt>
  707611:	ff 15 71 9d 3f 00    	call   *0x3f9d71(%rip)        # b01388 <_DYNAMIC+0x298>
