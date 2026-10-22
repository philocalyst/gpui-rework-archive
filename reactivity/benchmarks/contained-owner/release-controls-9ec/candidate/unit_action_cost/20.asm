
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

0000000000708190 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing>:
  708190:	55                   	push   %rbp
  708191:	41 57                	push   %r15
  708193:	41 56                	push   %r14
  708195:	41 55                	push   %r13
  708197:	41 54                	push   %r12
  708199:	53                   	push   %rbx
  70819a:	48 81 ec c8 03 00 00 	sub    $0x3c8,%rsp
  7081a1:	4d 89 c4             	mov    %r8,%r12
  7081a4:	49 89 cf             	mov    %rcx,%r15
  7081a7:	49 89 f6             	mov    %rsi,%r14
  7081aa:	48 89 fb             	mov    %rdi,%rbx
  7081ad:	41 83 38 02          	cmpl   $0x2,(%r8)
  7081b1:	75 08                	jne    7081bb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2b>
  7081b3:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  7081ba:	01 
  7081bb:	4d 85 ff             	test   %r15,%r15
  7081be:	0f 84 94 01 00 00    	je     708358 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c8>
  7081c4:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  7081cb:	01 
  7081cc:	0f 85 86 01 00 00    	jne    708358 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c8>
  7081d2:	49 8b 86 28 02 00 00 	mov    0x228(%r14),%rax
  7081d9:	49 8d 8e 30 02 00 00 	lea    0x230(%r14),%rcx
  7081e0:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  7081e4:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
  7081e9:	48 0f 44 ce          	cmove  %rsi,%rcx
  7081ed:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  7081f1:	66 0f 7f 84 24 60 01 	movdqa %xmm0,0x160(%rsp)
  7081f8:	00 00 
  7081fa:	74 45                	je     708241 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xb1>
  7081fc:	66 0f 6f 84 24 60 01 	movdqa 0x160(%rsp),%xmm0
  708203:	00 00 
  708205:	f3 0f 7f 84 24 c8 01 	movdqu %xmm0,0x1c8(%rsp)
  70820c:	00 00 
  70820e:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  708215:	00 
  708216:	48 8b 94 24 c9 01 00 	mov    0x1c9(%rsp),%rdx
  70821d:	00 
  70821e:	48 8b b4 24 d0 01 00 	mov    0x1d0(%rsp),%rsi
  708225:	00 
  708226:	48 89 73 18          	mov    %rsi,0x18(%rbx)
  70822a:	48 89 53 11          	mov    %rdx,0x11(%rbx)
  70822e:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  708235:	48 89 43 08          	mov    %rax,0x8(%rbx)
  708239:	88 4b 10             	mov    %cl,0x10(%rbx)
  70823c:	e9 5e 03 00 00       	jmp    70859f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  708241:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  708246:	41 83 ff 01          	cmp    $0x1,%r15d
  70824a:	0f 85 80 00 00 00    	jne    7082d0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x140>
  708250:	48 89 d5             	mov    %rdx,%rbp
  708253:	49 8b 8e 48 02 00 00 	mov    0x248(%r14),%rcx
  70825a:	4d 8b a6 50 02 00 00 	mov    0x250(%r14),%r12
  708261:	49 c1 e4 04          	shl    $0x4,%r12
  708265:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  70826c:	00 00 00 00 
  708270:	4d 85 e4             	test   %r12,%r12
  708273:	0f 84 7a 03 00 00    	je     7085f3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x463>
  708279:	4c 8d 69 10          	lea    0x10(%rcx),%r13
  70827d:	48 8b 39             	mov    (%rcx),%rdi
  708280:	48 8b 41 08          	mov    0x8(%rcx),%rax
  708284:	ff 50 18             	call   *0x18(%rax)
  708287:	49 83 c4 f0          	add    $0xfffffffffffffff0,%r12
  70828b:	4c 89 e9             	mov    %r13,%rcx
  70828e:	4c 39 f8             	cmp    %r15,%rax
  708291:	75 dd                	jne    708270 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xe0>
  708293:	49 8b 8e 60 02 00 00 	mov    0x260(%r14),%rcx
  70829a:	49 8b 86 68 02 00 00 	mov    0x268(%r14),%rax
  7082a1:	48 c1 e0 03          	shl    $0x3,%rax
  7082a5:	31 f6                	xor    %esi,%esi
  7082a7:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7082ac:	0f 1f 40 00          	nopl   0x0(%rax)
  7082b0:	48 89 f2             	mov    %rsi,%rdx
  7082b3:	48 39 f0             	cmp    %rsi,%rax
  7082b6:	74 0a                	je     7082c2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x132>
  7082b8:	48 8d 72 08          	lea    0x8(%rdx),%rsi
  7082bc:	4c 39 3c 11          	cmp    %r15,(%rcx,%rdx,1)
  7082c0:	75 ee                	jne    7082b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x120>
  7082c2:	48 39 d0             	cmp    %rdx,%rax
  7082c5:	0f 95 c1             	setne  %cl
  7082c8:	48 89 ea             	mov    %rbp,%rdx
  7082cb:	e9 7f 00 00 00       	jmp    70834f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1bf>
  7082d0:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  7082d7:	00 
  7082d8:	4d 8b a6 78 02 00 00 	mov    0x278(%r14),%r12
  7082df:	4d 8b ae 80 02 00 00 	mov    0x280(%r14),%r13
  7082e6:	49 c1 e5 04          	shl    $0x4,%r13
  7082ea:	31 ed                	xor    %ebp,%ebp
  7082ec:	0f 1f 40 00          	nopl   0x0(%rax)
  7082f0:	49 39 ed             	cmp    %rbp,%r13
  7082f3:	0f 84 0e 03 00 00    	je     708607 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x477>
  7082f9:	49 8b 3c 2c          	mov    (%r12,%rbp,1),%rdi
  7082fd:	49 8b 44 2c 08       	mov    0x8(%r12,%rbp,1),%rax
  708302:	4c 89 fe             	mov    %r15,%rsi
  708305:	ff 50 30             	call   *0x30(%rax)
  708308:	48 83 c5 10          	add    $0x10,%rbp
  70830c:	84 c0                	test   %al,%al
  70830e:	74 e0                	je     7082f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160>
  708310:	49 8b 74 2c f0       	mov    -0x10(%r12,%rbp,1),%rsi
  708315:	49 8b 44 2c f8       	mov    -0x8(%r12,%rbp,1),%rax
  70831a:	48 8d bc 24 c0 01 00 	lea    0x1c0(%rsp),%rdi
  708321:	00 
  708322:	4c 89 fa             	mov    %r15,%rdx
  708325:	ff 50 60             	call   *0x60(%rax)
  708328:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
  70832f:	00 
  708330:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  708337:	00 
  708338:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  70833c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  708341:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  708348:	00 
  708349:	0f 85 c7 fe ff ff    	jne    708216 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x86>
  70834f:	f6 c1 01             	test   $0x1,%cl
  708352:	0f 84 f4 02 00 00    	je     70864c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x4bc>
  708358:	49 ff 86 00 07 00 00 	incq   0x700(%r14)
  70835f:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  708364:	4c 89 f6             	mov    %r14,%rsi
  708367:	31 c9                	xor    %ecx,%ecx
  708369:	e8 92 ee ff ff       	call   707200 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>
  70836e:	83 7c 24 70 fe       	cmpl   $0xfffffffe,0x70(%rsp)
  708373:	75 16                	jne    70838b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1fb>
  708375:	c6 84 24 28 02 00 00 	movb   $0x0,0x228(%rsp)
  70837c:	00 
  70837d:	48 c7 84 24 20 02 00 	movq   $0xfffffffffffffffe,0x220(%rsp)
  708384:	00 fe ff ff ff 
  708389:	eb 41                	jmp    7083cc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x23c>
  70838b:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  708392:	00 
  708393:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  70839a:	00 
  70839b:	f3 0f 6f 44 24 70    	movdqu 0x70(%rsp),%xmm0
  7083a1:	f3 0f 6f 8c 24 80 00 	movdqu 0x80(%rsp),%xmm1
  7083a8:	00 00 
  7083aa:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  7083b1:	00 
  7083b2:	0f 29 94 24 40 02 00 	movaps %xmm2,0x240(%rsp)
  7083b9:	00 
  7083ba:	66 0f 7f 8c 24 30 02 	movdqa %xmm1,0x230(%rsp)
  7083c1:	00 00 
  7083c3:	66 0f 7f 84 24 20 02 	movdqa %xmm0,0x220(%rsp)
  7083ca:	00 00 
  7083cc:	40 b5 01             	mov    $0x1,%bpl
  7083cf:	45 31 ff             	xor    %r15d,%r15d
  7083d2:	48 83 bc 24 20 02 00 	cmpq   $0xfffffffffffffffe,0x220(%rsp)
  7083d9:	00 fe 
  7083db:	0f 85 ba 00 00 00    	jne    70849b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x30b>
  7083e1:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  7083e8:	00 
  7083e9:	4c 89 f6             	mov    %r14,%rsi
  7083ec:	4c 89 e2             	mov    %r12,%rdx
  7083ef:	e8 8c 29 00 00       	call   70ad80 <<gpui::runtime::Runtime<unit_action_cost::Model>>::reconcile_editing>
  7083f4:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  7083fb:	00 
  7083fc:	44 0f b6 a4 24 f8 00 	movzbl 0xf8(%rsp),%r12d
  708403:	00 00 
  708405:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708409:	0f 85 61 01 00 00    	jne    708570 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x3e0>
  70840f:	48 8d 35 02 e7 95 ff 	lea    -0x6a18fe(%rip),%rsi        # 66b18 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2f8>
  708416:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  70841d:	00 
  70841e:	e8 bd 7f 01 00       	call   7203e0 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  708423:	84 c0                	test   %al,%al
  708425:	74 26                	je     70844d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2bd>
  708427:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70842e:	48 85 c0             	test   %rax,%rax
  708431:	0f 84 7a 01 00 00    	je     7085b1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x421>
  708437:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70843e:	00 
  70843f:	0f 95 c0             	setne  %al
  708442:	44 08 e0             	or     %r12b,%al
  708445:	a8 01                	test   $0x1,%al
  708447:	0f 84 6e 01 00 00    	je     7085bb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x42b>
  70844d:	48 8d 35 fc e6 95 ff 	lea    -0x6a1904(%rip),%rsi        # 66b50 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x330>
  708454:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  70845b:	00 
  70845c:	e8 7f 7f 01 00       	call   7203e0 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  708461:	84 c0                	test   %al,%al
  708463:	74 26                	je     70848b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2fb>
  708465:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70846c:	48 85 c0             	test   %rax,%rax
  70846f:	0f 84 a7 01 00 00    	je     70861c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x48c>
  708475:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70847c:	00 
  70847d:	0f 95 c0             	setne  %al
  708480:	44 08 e0             	or     %r12b,%al
  708483:	a8 01                	test   $0x1,%al
  708485:	0f 84 9b 01 00 00    	je     708626 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x496>
  70848b:	48 89 df             	mov    %rbx,%rdi
  70848e:	4c 89 f6             	mov    %r14,%rsi
  708491:	e8 ca 61 01 00       	call   71e660 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  708496:	e9 04 01 00 00       	jmp    70859f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  70849b:	48 8b 84 24 50 02 00 	mov    0x250(%rsp),%rax
  7084a2:	00 
  7084a3:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  7084aa:	00 
  7084ab:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  7084b2:	00 
  7084b3:	0f 28 8c 24 30 02 00 	movaps 0x230(%rsp),%xmm1
  7084ba:	00 
  7084bb:	0f 28 94 24 40 02 00 	movaps 0x240(%rsp),%xmm2
  7084c2:	00 
  7084c3:	0f 29 94 24 10 01 00 	movaps %xmm2,0x110(%rsp)
  7084ca:	00 
  7084cb:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  7084d2:	00 
  7084d3:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  7084da:	00 
  7084db:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  7084e2:	48 85 c0             	test   %rax,%rax
  7084e5:	74 41                	je     708528 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x398>
  7084e7:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  7084ee:	48 85 c0             	test   %rax,%rax
  7084f1:	74 35                	je     708528 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x398>
  7084f3:	48 8b 78 10          	mov    0x10(%rax),%rdi
  7084f7:	0f b6 48 24          	movzbl 0x24(%rax),%ecx
  7084fb:	c6 40 24 02          	movb   $0x2,0x24(%rax)
  7084ff:	80 f9 02             	cmp    $0x2,%cl
  708502:	74 24                	je     708528 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x398>
  708504:	f6 07 01             	testb  $0x1,(%rdi)
  708507:	75 17                	jne    708520 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x390>
  708509:	48 8b 47 08          	mov    0x8(%rdi),%rax
  70850d:	a8 01                	test   $0x1,%al
  70850f:	75 0f                	jne    708520 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x390>
  708511:	48 8d 47 08          	lea    0x8(%rdi),%rax
  708515:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  70851a:	0f 84 31 19 00 00    	je     709e51 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cc1>
  708520:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  708527:	01 
  708528:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  70852f:	00 
  708530:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  708537:	00 00 00 00 
  70853b:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  708542:	00 
  708543:	48 89 43 30          	mov    %rax,0x30(%rbx)
  708547:	66 0f 6f 84 24 f0 00 	movdqa 0xf0(%rsp),%xmm0
  70854e:	00 00 
  708550:	66 0f 6f 8c 24 00 01 	movdqa 0x100(%rsp),%xmm1
  708557:	00 00 
  708559:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
  708560:	00 
  708561:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  708565:	f3 0f 7f 4b 10       	movdqu %xmm1,0x10(%rbx)
  70856a:	f3 0f 7f 03          	movdqu %xmm0,(%rbx)
  70856e:	eb 2f                	jmp    70859f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  708570:	f3 0f 6f 84 24 f9 00 	movdqu 0xf9(%rsp),%xmm0
  708577:	00 00 
  708579:	f3 0f 6f 8c 24 09 01 	movdqu 0x109(%rsp),%xmm1
  708580:	00 00 
  708582:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  708589:	00 
  70858a:	0f 11 53 28          	movups %xmm2,0x28(%rbx)
  70858e:	f3 0f 7f 4b 19       	movdqu %xmm1,0x19(%rbx)
  708593:	f3 0f 7f 43 09       	movdqu %xmm0,0x9(%rbx)
  708598:	48 89 03             	mov    %rax,(%rbx)
  70859b:	44 88 63 08          	mov    %r12b,0x8(%rbx)
  70859f:	48 81 c4 c8 03 00 00 	add    $0x3c8,%rsp
  7085a6:	5b                   	pop    %rbx
  7085a7:	41 5c                	pop    %r12
  7085a9:	41 5d                	pop    %r13
  7085ab:	41 5e                	pop    %r14
  7085ad:	41 5f                	pop    %r15
  7085af:	5d                   	pop    %rbp
  7085b0:	c3                   	ret
  7085b1:	41 80 fc 01          	cmp    $0x1,%r12b
  7085b5:	0f 84 92 fe ff ff    	je     70844d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2bd>
  7085bb:	f3 41 0f 6f 86 60 06 	movdqu 0x660(%r14),%xmm0
  7085c2:	00 00 
  7085c4:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  7085cb:	00 
  7085cc:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  7085d3:	00 
  7085d4:	74 16                	je     7085ec <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x45c>
  7085d6:	84 c0                	test   %al,%al
  7085d8:	0f 84 c7 00 00 00    	je     7086a5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x515>
  7085de:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  7085e5:	ff 
  7085e6:	0f 85 b9 00 00 00    	jne    7086a5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x515>
  7085ec:	31 c9                	xor    %ecx,%ecx
  7085ee:	e9 be 00 00 00       	jmp    7086b1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x521>
  7085f3:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  7085fa:	00 
  7085fb:	b8 0b 00 00 00       	mov    $0xb,%eax
  708600:	b1 01                	mov    $0x1,%cl
  708602:	e9 0f fc ff ff       	jmp    708216 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x86>
  708607:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  70860e:	00 
  70860f:	b8 0b 00 00 00       	mov    $0xb,%eax
  708614:	44 89 f9             	mov    %r15d,%ecx
  708617:	e9 fa fb ff ff       	jmp    708216 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x86>
  70861c:	41 80 fc 01          	cmp    $0x1,%r12b
  708620:	0f 84 65 fe ff ff    	je     70848b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2fb>
  708626:	40 84 ed             	test   %bpl,%bpl
  708629:	0f 85 15 18 00 00    	jne    709e44 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cb4>
  70862f:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  708633:	4c 89 f6             	mov    %r14,%rsi
  708636:	31 d2                	xor    %edx,%edx
  708638:	4c 89 f9             	mov    %r15,%rcx
  70863b:	e8 30 32 00 00       	call   70b870 <<gpui::runtime::Runtime<unit_action_cost::Model>>::publish_metadata>
  708640:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  708647:	e9 53 ff ff ff       	jmp    70859f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  70864c:	4c 89 bc 24 68 03 00 	mov    %r15,0x368(%rsp)
  708653:	00 
  708654:	49 ff 86 f8 06 00 00 	incq   0x6f8(%r14)
  70865b:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  708662:	48 85 c0             	test   %rax,%rax
  708665:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  70866c:	00 
  70866d:	0f 84 90 02 00 00    	je     708903 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  708673:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  70867a:	48 85 c9             	test   %rcx,%rcx
  70867d:	0f 84 9c 00 00 00    	je     70871f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x58f>
  708683:	48 89 ca             	mov    %rcx,%rdx
  708686:	48 83 e2 07          	and    $0x7,%rdx
  70868a:	74 4c                	je     7086d8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x548>
  70868c:	31 f6                	xor    %esi,%esi
  70868e:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  708695:	48 ff c6             	inc    %rsi
  708698:	48 39 f2             	cmp    %rsi,%rdx
  70869b:	75 f1                	jne    70868e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x4fe>
  70869d:	48 89 ca             	mov    %rcx,%rdx
  7086a0:	48 29 f2             	sub    %rsi,%rdx
  7086a3:	eb 36                	jmp    7086db <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x54b>
  7086a5:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  7086ac:	b9 01 00 00 00       	mov    $0x1,%ecx
  7086b1:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  7086b8:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  7086bc:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  7086c0:	f3 0f 7f 43 18       	movdqu %xmm0,0x18(%rbx)
  7086c5:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  7086c9:	88 43 30             	mov    %al,0x30(%rbx)
  7086cc:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  7086d3:	e9 c7 fe ff ff       	jmp    70859f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  7086d8:	48 89 ca             	mov    %rcx,%rdx
  7086db:	48 83 f9 08          	cmp    $0x8,%rcx
  7086df:	72 3e                	jb     70871f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x58f>
  7086e1:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  7086e8:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  7086ef:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  7086f6:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  7086fd:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  708704:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  70870b:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  708712:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  708719:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  70871d:	75 c2                	jne    7086e1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x551>
  70871f:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  708726:	00 
  708727:	0f 84 d6 01 00 00    	je     708903 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  70872d:	80 38 00             	cmpb   $0x0,(%rax)
  708730:	0f 85 cd 01 00 00    	jne    708903 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  708736:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  70873d:	48 8d b4 24 68 03 00 	lea    0x368(%rsp),%rsi
  708744:	00 
  708745:	e8 66 84 01 00       	call   720bb0 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout>>::get::<gpui::source::FieldId>>
  70874a:	48 85 c0             	test   %rax,%rax
  70874d:	0f 84 b0 01 00 00    	je     708903 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  708753:	48 8b 48 10          	mov    0x10(%rax),%rcx
  708757:	48 c1 e1 02          	shl    $0x2,%rcx
  70875b:	48 83 38 ff          	cmpq   $0xffffffffffffffff,(%rax)
  70875f:	ba 04 00 00 00       	mov    $0x4,%edx
  708764:	48 0f 45 50 08       	cmovne 0x8(%rax),%rdx
  708769:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70876e:	b8 00 00 00 00       	mov    $0x0,%eax
  708773:	48 0f 45 c1          	cmovne %rcx,%rax
  708777:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  70877c:	48 85 c0             	test   %rax,%rax
  70877f:	0f 84 7e 01 00 00    	je     708903 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  708785:	45 31 ed             	xor    %r13d,%r13d
  708788:	48 8b 05 41 9a 3f 00 	mov    0x3f9a41(%rip),%rax        # b021d0 <_DYNAMIC+0x3b8>
  70878f:	48 83 c0 20          	add    $0x20,%rax
  708793:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  708798:	48 8b 05 39 9a 3f 00 	mov    0x3f9a39(%rip),%rax        # b021d8 <_DYNAMIC+0x3c0>
  70879f:	48 83 c0 20          	add    $0x20,%rax
  7087a3:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7087a8:	48 8b 05 31 9a 3f 00 	mov    0x3f9a31(%rip),%rax        # b021e0 <_DYNAMIC+0x3c8>
  7087af:	48 83 c0 20          	add    $0x20,%rax
  7087b3:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  7087b8:	48 8b 05 29 9a 3f 00 	mov    0x3f9a29(%rip),%rax        # b021e8 <_DYNAMIC+0x3d0>
  7087bf:	48 83 c0 20          	add    $0x20,%rax
  7087c3:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  7087c8:	48 8b 05 21 9a 3f 00 	mov    0x3f9a21(%rip),%rax        # b021f0 <_DYNAMIC+0x3d8>
  7087cf:	48 83 c0 20          	add    $0x20,%rax
  7087d3:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  7087d8:	48 8b 05 19 9a 3f 00 	mov    0x3f9a19(%rip),%rax        # b021f8 <_DYNAMIC+0x3e0>
  7087df:	48 83 c0 20          	add    $0x20,%rax
  7087e3:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  7087ea:	00 
  7087eb:	48 8b 05 0e 9a 3f 00 	mov    0x3f9a0e(%rip),%rax        # b02200 <_DYNAMIC+0x3e8>
  7087f2:	48 83 c0 20          	add    $0x20,%rax
  7087f6:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  7087fd:	00 
  7087fe:	48 8b 05 03 9a 3f 00 	mov    0x3f9a03(%rip),%rax        # b02208 <_DYNAMIC+0x3f0>
  708805:	48 83 c0 20          	add    $0x20,%rax
  708809:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  70880e:	48 8b 05 fb 99 3f 00 	mov    0x3f99fb(%rip),%rax        # b02210 <_DYNAMIC+0x3f8>
  708815:	48 83 c0 20          	add    $0x20,%rax
  708819:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  708820:	00 
  708821:	48 8b 05 f0 99 3f 00 	mov    0x3f99f0(%rip),%rax        # b02218 <_DYNAMIC+0x400>
  708828:	48 83 c0 20          	add    $0x20,%rax
  70882c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  708831:	48 8b 05 e8 99 3f 00 	mov    0x3f99e8(%rip),%rax        # b02220 <_DYNAMIC+0x408>
  708838:	48 83 c0 20          	add    $0x20,%rax
  70883c:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  708843:	00 
  708844:	48 8b 05 dd 99 3f 00 	mov    0x3f99dd(%rip),%rax        # b02228 <_DYNAMIC+0x410>
  70884b:	48 83 c0 20          	add    $0x20,%rax
  70884f:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  708854:	48 8b 05 d5 99 3f 00 	mov    0x3f99d5(%rip),%rax        # b02230 <_DYNAMIC+0x418>
  70885b:	48 83 c0 20          	add    $0x20,%rax
  70885f:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  708864:	48 8d 2d 85 da 95 ff 	lea    -0x6a257b(%rip),%rbp        # 662f0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1450>
  70886b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708870:	42 8b 3c 28          	mov    (%rax,%r13,1),%edi
  708874:	ff 15 be 99 3f 00    	call   *0x3f99be(%rip)        # b02238 <_DYNAMIC+0x420>
  70887a:	0f b7 c0             	movzwl %ax,%eax
  70887d:	48 63 4c 85 00       	movslq 0x0(%rbp,%rax,4),%rcx
  708882:	48 01 e9             	add    %rbp,%rcx
  708885:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  70888a:	ff e1                	jmp    *%rcx
  70888c:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  708891:	eb 57                	jmp    7088ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  708893:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  70889a:	00 
  70889b:	eb 4d                	jmp    7088ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  70889d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7088a2:	eb 46                	jmp    7088ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088a4:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7088a9:	eb 3f                	jmp    7088ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088ab:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  7088b2:	00 
  7088b3:	eb 35                	jmp    7088ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088b5:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  7088ba:	eb 2e                	jmp    7088ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088bc:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  7088c3:	00 
  7088c4:	eb 24                	jmp    7088ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088c6:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  7088cb:	eb 1d                	jmp    7088ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088cd:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  7088d2:	eb 16                	jmp    7088ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088d4:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  7088db:	00 
  7088dc:	eb 0c                	jmp    7088ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088de:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  7088e3:	eb 05                	jmp    7088ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088e5:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7088ea:	80 78 13 00          	cmpb   $0x0,0x13(%rax)
  7088ee:	0f 85 03 11 00 00    	jne    7099f7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1867>
  7088f4:	49 83 c5 04          	add    $0x4,%r13
  7088f8:	4c 39 6c 24 18       	cmp    %r13,0x18(%rsp)
  7088fd:	0f 85 68 ff ff ff    	jne    70886b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x6db>
  708903:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  70890a:	00 00 
  70890c:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  708913:	48 85 ed             	test   %rbp,%rbp
  708916:	0f 84 f2 10 00 00    	je     709a0e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x187e>
  70891c:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  708923:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  70892a:	49 8b 86 d0 05 00 00 	mov    0x5d0(%r14),%rax
  708931:	48 89 c7             	mov    %rax,%rdi
  708934:	48 89 e9             	mov    %rbp,%rcx
  708937:	44 0f b7 91 c2 01 00 	movzwl 0x1c2(%rcx),%r10d
  70893e:	00 
  70893f:	45 89 d3             	mov    %r10d,%r11d
  708942:	41 c1 e3 05          	shl    $0x5,%r11d
  708946:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  70894d:	45 31 c9             	xor    %r9d,%r9d
  708950:	4d 39 cb             	cmp    %r9,%r11
  708953:	74 28                	je     70897d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7ed>
  708955:	4e 3b bc c1 70 01 00 	cmp    0x170(%rcx,%r8,8),%r15
  70895c:	00 
  70895d:	41 0f 97 c4          	seta   %r12b
  708961:	41 80 dc 00          	sbb    $0x0,%r12b
  708965:	49 83 c1 20          	add    $0x20,%r9
  708969:	49 ff c0             	inc    %r8
  70896c:	41 80 fc 01          	cmp    $0x1,%r12b
  708970:	74 de                	je     708950 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7c0>
  708972:	45 0f b6 d4          	movzbl %r12b,%r10d
  708976:	45 85 d2             	test   %r10d,%r10d
  708979:	75 05                	jne    708980 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7f0>
  70897b:	eb 1c                	jmp    708999 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x809>
  70897d:	4d 89 d0             	mov    %r10,%r8
  708980:	48 83 ef 01          	sub    $0x1,%rdi
  708984:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  708989:	0f 82 92 00 00 00    	jb     708a21 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x891>
  70898f:	4a 8b 8c c1 c8 01 00 	mov    0x1c8(%rcx,%r8,8),%rcx
  708996:	00 
  708997:	eb 9e                	jmp    708937 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7a7>
  708999:	4a 83 7c 09 e0 ff    	cmpq   $0xffffffffffffffff,-0x20(%rcx,%r9,1)
  70899f:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7089a4:	75 7b                	jne    708a21 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x891>
  7089a6:	42 8b 6c 09 e8       	mov    -0x18(%rcx,%r9,1),%ebp
  7089ab:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  7089b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  7089b9:	4c 8d 05 78 bc 3c 00 	lea    0x3cbc78(%rip),%r8        # ad4638 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xdc0>
  7089c0:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  7089c5:	4c 89 f9             	mov    %r15,%rcx
  7089c8:	45 31 c9             	xor    %r9d,%r9d
  7089cb:	e8 b0 a3 03 00       	call   742d80 <<gpui::source::Sources<unit_action_cost::Model>>::freeze>
  7089d0:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  7089d5:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  7089da:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  7089e1:	00 
  7089e2:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  7089e6:	0f 85 e6 00 00 00    	jne    708ad2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x942>
  7089ec:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  7089f3:	00 
  7089f4:	48 89 cd             	mov    %rcx,%rbp
  7089f7:	48 c1 ed 08          	shr    $0x8,%rbp
  7089fb:	b8 20 00 00 00       	mov    $0x20,%eax
  708a00:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  708a05:	89 cf                	mov    %ecx,%edi
  708a07:	e9 bb 12 00 00       	jmp    709cc7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  708a0c:	48 89 f9             	mov    %rdi,%rcx
  708a0f:	48 83 e8 01          	sub    $0x1,%rax
  708a13:	0f 82 f5 0f 00 00    	jb     709a0e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x187e>
  708a19:	48 8b ac cd c8 01 00 	mov    0x1c8(%rbp,%rcx,8),%rbp
  708a20:	00 
  708a21:	0f b7 bd c2 01 00 00 	movzwl 0x1c2(%rbp),%edi
  708a28:	41 89 f8             	mov    %edi,%r8d
  708a2b:	41 c1 e0 05          	shl    $0x5,%r8d
  708a2f:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  708a36:	45 31 ed             	xor    %r13d,%r13d
  708a39:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  708a40:	4d 39 e8             	cmp    %r13,%r8
  708a43:	74 c7                	je     708a0c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x87c>
  708a45:	4c 3b bc cd 70 01 00 	cmp    0x170(%rbp,%rcx,8),%r15
  708a4c:	00 
  708a4d:	41 0f 97 c1          	seta   %r9b
  708a51:	41 80 d9 00          	sbb    $0x0,%r9b
  708a55:	49 83 c5 20          	add    $0x20,%r13
  708a59:	48 ff c1             	inc    %rcx
  708a5c:	41 80 f9 01          	cmp    $0x1,%r9b
  708a60:	74 de                	je     708a40 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x8b0>
  708a62:	41 0f b6 f9          	movzbl %r9b,%edi
  708a66:	85 ff                	test   %edi,%edi
  708a68:	75 a5                	jne    708a0f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x87f>
  708a6a:	4a 8b 4c 2d e0       	mov    -0x20(%rbp,%r13,1),%rcx
  708a6f:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  708a73:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  708a78:	74 41                	je     708abb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x92b>
  708a7a:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  708a7f:	48 85 c0             	test   %rax,%rax
  708a82:	0f 84 46 01 00 00    	je     708bce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa3e>
  708a88:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  708a8d:	48 ff c8             	dec    %rax
  708a90:	48 bf ff ff ff ff ff 	movabs $0x3fffffffffffffff,%rdi
  708a97:	ff ff 3f 
  708a9a:	48 21 c7             	and    %rax,%rdi
  708a9d:	4c 8d 4f 01          	lea    0x1(%rdi),%r9
  708aa1:	45 89 c8             	mov    %r9d,%r8d
  708aa4:	41 83 e0 03          	and    $0x3,%r8d
  708aa8:	48 83 ff 03          	cmp    $0x3,%rdi
  708aac:	0f 83 25 01 00 00    	jae    708bd7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa47>
  708ab2:	31 c0                	xor    %eax,%eax
  708ab4:	31 ff                	xor    %edi,%edi
  708ab6:	e9 b0 01 00 00       	jmp    708c6b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xadb>
  708abb:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  708ac2:	4c 8d 05 6f bb 3c 00 	lea    0x3cbb6f(%rip),%r8        # ad4638 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xdc0>
  708ac9:	31 c0                	xor    %eax,%eax
  708acb:	31 ff                	xor    %edi,%edi
  708acd:	e9 d4 01 00 00       	jmp    708ca6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xb16>
  708ad2:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  708ad7:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  708adc:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  708ae3:	00 
  708ae4:	48 89 84 24 d0 02 00 	mov    %rax,0x2d0(%rsp)
  708aeb:	00 
  708aec:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  708af3:	00 
  708af4:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
  708afb:	00 
  708afc:	41 83 fd 02          	cmp    $0x2,%r13d
  708b00:	0f 84 bc 13 00 00    	je     709ec2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d32>
  708b06:	4c 89 6c 24 70       	mov    %r13,0x70(%rsp)
  708b0b:	0f 28 84 24 c0 02 00 	movaps 0x2c0(%rsp),%xmm0
  708b12:	00 
  708b13:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  708b18:	48 8b 84 24 d0 02 00 	mov    0x2d0(%rsp),%rax
  708b1f:	00 
  708b20:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  708b27:	00 
  708b28:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  708b2f:	00 
  708b30:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  708b35:	ba 06 00 00 00       	mov    $0x6,%edx
  708b3a:	ff 15 00 97 3f 00    	call   *0x3f9700(%rip)        # b02240 <_DYNAMIC+0x428>
  708b40:	0f b6 94 24 60 01 00 	movzbl 0x160(%rsp),%edx
  708b47:	00 
  708b48:	80 fa ff             	cmp    $0xff,%dl
  708b4b:	0f 84 79 0e 00 00    	je     7099ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x183a>
  708b51:	8b 8c 24 63 01 00 00 	mov    0x163(%rsp),%ecx
  708b58:	0f b6 84 24 67 01 00 	movzbl 0x167(%rsp),%eax
  708b5f:	00 
  708b60:	0f 10 84 24 68 01 00 	movups 0x168(%rsp),%xmm0
  708b67:	00 
  708b68:	0f 29 84 24 90 03 00 	movaps %xmm0,0x390(%rsp)
  708b6f:	00 
  708b70:	8b b4 24 78 01 00 00 	mov    0x178(%rsp),%esi
  708b77:	89 b4 24 a0 03 00 00 	mov    %esi,0x3a0(%rsp)
  708b7e:	80 fa 02             	cmp    $0x2,%dl
  708b81:	0f 85 35 0f 00 00    	jne    709abc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x192c>
  708b87:	89 ea                	mov    %ebp,%edx
  708b89:	48 c1 e0 20          	shl    $0x20,%rax
  708b8d:	48 09 c8             	or     %rcx,%rax
  708b90:	48 c1 e8 08          	shr    $0x8,%rax
  708b94:	89 84 24 60 02 00 00 	mov    %eax,0x260(%rsp)
  708b9b:	8b 84 24 98 03 00 00 	mov    0x398(%rsp),%eax
  708ba2:	89 84 24 6c 02 00 00 	mov    %eax,0x26c(%rsp)
  708ba9:	48 8b 84 24 90 03 00 	mov    0x390(%rsp),%rax
  708bb0:	00 
  708bb1:	48 89 84 24 64 02 00 	mov    %rax,0x264(%rsp)
  708bb8:	00 
  708bb9:	41 80 be 1f 07 00 00 	cmpb   $0x0,0x71f(%r14)
  708bc0:	00 
  708bc1:	0f 84 0c 0f 00 00    	je     709ad3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1943>
  708bc7:	31 ed                	xor    %ebp,%ebp
  708bc9:	e9 24 0f 00 00       	jmp    709af2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1962>
  708bce:	31 ff                	xor    %edi,%edi
  708bd0:	31 c0                	xor    %eax,%eax
  708bd2:	e9 b5 00 00 00       	jmp    708c8c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xafc>
  708bd7:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  708bdc:	48 b8 00 00 00 00 00 	movabs $0x8000000000000000,%rax
  708be3:	00 00 80 
  708be6:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  708bea:	49 21 c1             	and    %rax,%r9
  708bed:	31 c0                	xor    %eax,%eax
  708bef:	31 ff                	xor    %edi,%edi
  708bf1:	44 8b 11             	mov    (%rcx),%r10d
  708bf4:	44 8b 41 04          	mov    0x4(%rcx),%r8d
  708bf8:	45 89 d4             	mov    %r10d,%r12d
  708bfb:	41 f7 d4             	not    %r12d
  708bfe:	41 f6 c4 03          	test   $0x3,%r12b
  708c02:	41 0f 94 c4          	sete   %r12b
  708c06:	45 89 c3             	mov    %r8d,%r11d
  708c09:	41 f7 d3             	not    %r11d
  708c0c:	41 f6 c3 03          	test   $0x3,%r11b
  708c10:	41 0f 94 c3          	sete   %r11b
  708c14:	45 08 e3             	or     %r12b,%r11b
  708c17:	8b 51 08             	mov    0x8(%rcx),%edx
  708c1a:	41 89 d4             	mov    %edx,%r12d
  708c1d:	41 f7 d4             	not    %r12d
  708c20:	41 f6 c4 03          	test   $0x3,%r12b
  708c24:	41 0f 94 c4          	sete   %r12b
  708c28:	8b 71 0c             	mov    0xc(%rcx),%esi
  708c2b:	48 83 c1 10          	add    $0x10,%rcx
  708c2f:	21 f2                	and    %esi,%edx
  708c31:	f7 d6                	not    %esi
  708c33:	40 f6 c6 03          	test   $0x3,%sil
  708c37:	40 0f 94 c6          	sete   %sil
  708c3b:	44 08 e6             	or     %r12b,%sil
  708c3e:	44 08 de             	or     %r11b,%sil
  708c41:	40 08 f7             	or     %sil,%dil
  708c44:	45 21 c2             	and    %r8d,%r10d
  708c47:	41 21 d2             	and    %edx,%r10d
  708c4a:	41 f7 d2             	not    %r10d
  708c4d:	41 f6 c2 03          	test   $0x3,%r10b
  708c51:	0f 95 c2             	setne  %dl
  708c54:	08 d0                	or     %dl,%al
  708c56:	49 83 c1 fc          	add    $0xfffffffffffffffc,%r9
  708c5a:	75 95                	jne    708bf1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa61>
  708c5c:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  708c61:	4d 85 c0             	test   %r8,%r8
  708c64:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  708c69:	74 21                	je     708c8c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xafc>
  708c6b:	45 31 c9             	xor    %r9d,%r9d
  708c6e:	42 8b 14 89          	mov    (%rcx,%r9,4),%edx
  708c72:	83 e2 03             	and    $0x3,%edx
  708c75:	83 fa 03             	cmp    $0x3,%edx
  708c78:	0f 95 c2             	setne  %dl
  708c7b:	40 0f 94 c6          	sete   %sil
  708c7f:	40 08 f7             	or     %sil,%dil
  708c82:	08 d0                	or     %dl,%al
  708c84:	49 ff c1             	inc    %r9
  708c87:	4d 39 c8             	cmp    %r9,%r8
  708c8a:	75 e2                	jne    708c6e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xade>
  708c8c:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  708c93:	4e 8b 44 2d f8       	mov    -0x8(%rbp,%r13,1),%r8
  708c98:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  708c9f:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  708ca6:	40 0f b6 cf          	movzbl %dil,%ecx
  708caa:	83 e1 01             	and    $0x1,%ecx
  708cad:	89 0c 24             	mov    %ecx,(%rsp)
  708cb0:	44 0f b6 c8          	movzbl %al,%r9d
  708cb4:	41 83 e1 01          	and    $0x1,%r9d
  708cb8:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  708cbd:	4c 89 f9             	mov    %r15,%rcx
  708cc0:	e8 bb a0 03 00       	call   742d80 <<gpui::source::Sources<unit_action_cost::Model>>::freeze>
  708cc5:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  708cca:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  708ccf:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  708cd6:	00 
  708cd7:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  708cde:	00 
  708cdf:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  708ce4:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  708ce9:	48 83 f9 fd          	cmp    $0xfffffffffffffffd,%rcx
  708ced:	75 1d                	jne    708d0c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xb7c>
  708cef:	48 89 c5             	mov    %rax,%rbp
  708cf2:	48 c1 ed 08          	shr    $0x8,%rbp
  708cf6:	b9 20 00 00 00       	mov    $0x20,%ecx
  708cfb:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  708d00:	89 c7                	mov    %eax,%edi
  708d02:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  708d07:	e9 bb 0f 00 00       	jmp    709cc7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  708d0c:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  708d11:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  708d18:	00 
  708d19:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  708d20:	00 
  708d21:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  708d28:	00 00 
  708d2a:	66 0f 7f 84 24 40 03 	movdqa %xmm0,0x340(%rsp)
  708d31:	00 00 
  708d33:	48 83 7c 24 08 ff    	cmpq   $0xffffffffffffffff,0x8(%rsp)
  708d39:	0f 84 69 0c 00 00    	je     7099a8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1818>
  708d3f:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  708d44:	48 85 c0             	test   %rax,%rax
  708d47:	0f 84 5b 0c 00 00    	je     7099a8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1818>
  708d4d:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  708d52:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  708d57:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  708d5c:	48 c1 e0 02          	shl    $0x2,%rax
  708d60:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  708d65:	8b 44 24 18          	mov    0x18(%rsp),%eax
  708d69:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  708d70:	00 
  708d71:	45 31 e4             	xor    %r12d,%r12d
  708d74:	48 83 f8 02          	cmp    $0x2,%rax
  708d78:	0f 85 72 0b 00 00    	jne    7098f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1760>
  708d7e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708d83:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  708d87:	ff 15 ab 94 3f 00    	call   *0x3f94ab(%rip)        # b02238 <_DYNAMIC+0x420>
  708d8d:	66 85 c0             	test   %ax,%ax
  708d90:	0f 85 ba 12 00 00    	jne    70a050 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ec0>
  708d96:	49 83 c4 04          	add    $0x4,%r12
  708d9a:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  708d9f:	75 dd                	jne    708d7e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xbee>
  708da1:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  708da6:	48 85 c0             	test   %rax,%rax
  708da9:	0f 84 dd 0d 00 00    	je     709b8c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x19fc>
  708daf:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  708db4:	48 89 8c 24 48 01 00 	mov    %rcx,0x148(%rsp)
  708dbb:	00 
  708dbc:	48 c1 e0 02          	shl    $0x2,%rax
  708dc0:	f3 0f 7e 44 24 30    	movq   0x30(%rsp),%xmm0
  708dc6:	66 0f 6f 0d b2 ca 95 	movdqa -0x6a354e(%rip),%xmm1        # 65880 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x9e0>
  708dcd:	ff 
  708dce:	66 0f 6c c8          	punpcklqdq %xmm0,%xmm1
  708dd2:	66 0f 7f 8c 24 b0 03 	movdqa %xmm1,0x3b0(%rsp)
  708dd9:	00 00 
  708ddb:	48 c7 84 24 d0 00 00 	movq   $0x0,0xd0(%rsp)
  708de2:	00 00 00 00 00 
  708de7:	48 8d 0d 8a b8 3c 00 	lea    0x3cb88a(%rip),%rcx        # ad4678 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe00>
  708dee:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  708df3:	48 b9 00 00 00 00 00 	movabs $0x8000000000000000,%rcx
  708dfa:	00 00 80 
  708dfd:	48 ff c1             	inc    %rcx
  708e00:	48 89 8c 24 38 01 00 	mov    %rcx,0x138(%rsp)
  708e07:	00 
  708e08:	48 8d 0d 35 08 96 ff 	lea    -0x69f7cb(%rip),%rcx        # 69644 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e24>
  708e0f:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  708e16:	00 
  708e17:	48 8d 0d ea b8 3c 00 	lea    0x3cb8ea(%rip),%rcx        # ad4708 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe90>
  708e1e:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  708e25:	00 
  708e26:	48 8d 0d 63 b8 3c 00 	lea    0x3cb863(%rip),%rcx        # ad4690 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe18>
  708e2d:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  708e34:	00 
  708e35:	48 8d 0d df 07 96 ff 	lea    -0x69f821(%rip),%rcx        # 6961b <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2dfb>
  708e3c:	48 89 8c 24 e0 00 00 	mov    %rcx,0xe0(%rsp)
  708e43:	00 
  708e44:	48 8d 0d cd ac 3c 00 	lea    0x3caccd(%rip),%rcx        # ad3b18 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x2a0>
  708e4b:	48 89 8c 24 b8 01 00 	mov    %rcx,0x1b8(%rsp)
  708e52:	00 
  708e53:	31 c9                	xor    %ecx,%ecx
  708e55:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  708e5c:	00 00 00 00 00 
  708e61:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  708e68:	00 00 00 00 00 
  708e6d:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  708e74:	00 00 
  708e76:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  708e7b:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  708e82:	00 
  708e83:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  708e88:	8b 2c 08             	mov    (%rax,%rcx,1),%ebp
  708e8b:	49 ff 86 c0 06 00 00 	incq   0x6c0(%r14)
  708e92:	89 e8                	mov    %ebp,%eax
  708e94:	c1 e8 0f             	shr    $0xf,%eax
  708e97:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  708e9e:	48 39 c6             	cmp    %rax,%rsi
  708ea1:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  708ea6:	0f 86 7c 11 00 00    	jbe    70a028 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e98>
  708eac:	4d 8b a6 98 02 00 00 	mov    0x298(%r14),%r12
  708eb3:	4c 8d 2c 80          	lea    (%rax,%rax,4),%r13
  708eb7:	4b 8b 04 ec          	mov    (%r12,%r13,8),%rax
  708ebb:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  708ec0:	89 ef                	mov    %ebp,%edi
  708ec2:	ff 15 70 93 3f 00    	call   *0x3f9370(%rip)        # b02238 <_DYNAMIC+0x420>
  708ec8:	89 44 24 08          	mov    %eax,0x8(%rsp)
  708ecc:	4b 8d 04 ec          	lea    (%r12,%r13,8),%rax
  708ed0:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  708ed7:	00 
  708ed8:	8b 54 24 08          	mov    0x8(%rsp),%edx
  708edc:	66 85 d2             	test   %dx,%dx
  708edf:	0f 84 31 01 00 00    	je     709016 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xe86>
  708ee5:	83 bc 24 60 03 00 00 	cmpl   $0x2,0x360(%rsp)
  708eec:	02 
  708eed:	0f 84 6d 0f 00 00    	je     709e60 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cd0>
  708ef3:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  708ef8:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  708efd:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  708f04:	00 
  708f05:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  708f0a:	48 89 41 10          	mov    %rax,0x10(%rcx)
  708f0e:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  708f15:	00 00 
  708f17:	f3 0f 7f 01          	movdqu %xmm0,(%rcx)
  708f1b:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  708f22:	00 
  708f23:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  708f28:	ff 15 12 93 3f 00    	call   *0x3f9312(%rip)        # b02240 <_DYNAMIC+0x428>
  708f2e:	0f b6 84 24 60 01 00 	movzbl 0x160(%rsp),%eax
  708f35:	00 
  708f36:	3c ff                	cmp    $0xff,%al
  708f38:	0f 84 10 0d 00 00    	je     709c4e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1abe>
  708f3e:	0f b7 8c 24 61 01 00 	movzwl 0x161(%rsp),%ecx
  708f45:	00 
  708f46:	8b 94 24 63 01 00 00 	mov    0x163(%rsp),%edx
  708f4d:	0f b6 b4 24 67 01 00 	movzbl 0x167(%rsp),%esi
  708f54:	00 
  708f55:	4c 8d 84 24 68 01 00 	lea    0x168(%rsp),%r8
  708f5c:	00 
  708f5d:	41 8b 78 10          	mov    0x10(%r8),%edi
  708f61:	4c 8d 8c 24 7c 03 00 	lea    0x37c(%rsp),%r9
  708f68:	00 
  708f69:	41 89 79 10          	mov    %edi,0x10(%r9)
  708f6d:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
  708f72:	f3 41 0f 7f 01       	movdqu %xmm0,(%r9)
  708f77:	88 84 24 74 03 00 00 	mov    %al,0x374(%rsp)
  708f7e:	66 89 8c 24 75 03 00 	mov    %cx,0x375(%rsp)
  708f85:	00 
  708f86:	40 88 b4 24 7b 03 00 	mov    %sil,0x37b(%rsp)
  708f8d:	00 
  708f8e:	89 94 24 77 03 00 00 	mov    %edx,0x377(%rsp)
  708f95:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  708f99:	44 0f b7 e9          	movzwl %cx,%r13d
  708f9d:	48 8d 05 6c ba 3c 00 	lea    0x3cba6c(%rip),%rax        # ad4a10 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1198>
  708fa4:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  708fa9:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  708fad:	0f 84 c7 00 00 00    	je     70907a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xeea>
  708fb3:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  708fb8:	49 8d b6 10 06 00 00 	lea    0x610(%r14),%rsi
  708fbf:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  708fc4:	4c 8d 84 24 74 03 00 	lea    0x374(%rsp),%r8
  708fcb:	00 
  708fcc:	ff 15 76 92 3f 00    	call   *0x3f9276(%rip)        # b02248 <_DYNAMIC+0x430>
  708fd2:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  708fd7:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  708fdc:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708fe0:	0f 85 ab 0d 00 00    	jne    709d91 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c01>
  708fe6:	40 80 ff 01          	cmp    $0x1,%dil
  708fea:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  708fef:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  708ff4:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  708ff9:	0f 85 9e 08 00 00    	jne    70989d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x170d>
  708fff:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  709006:	01 
  709007:	b0 01                	mov    $0x1,%al
  709009:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  709010:	00 
  709011:	e9 4e 08 00 00       	jmp    709864 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16d4>
  709016:	48 83 7c 24 60 fe    	cmpq   $0xfffffffffffffffe,0x60(%rsp)
  70901c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709021:	0f 84 59 0e 00 00    	je     709e80 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cf0>
  709027:	83 e5 03             	and    $0x3,%ebp
  70902a:	8d 45 ff             	lea    -0x1(%rbp),%eax
  70902d:	83 f8 02             	cmp    $0x2,%eax
  709030:	0f 83 8a 00 00 00    	jae    7090c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf30>
  709036:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  70903d:	48 8b 38             	mov    (%rax),%rdi
  709040:	41 bc 2b 00 00 00    	mov    $0x2b,%r12d
  709046:	48 85 ff             	test   %rdi,%rdi
  709049:	0f 84 19 0e 00 00    	je     709e68 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cd8>
  70904f:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  709054:	ff 15 f6 91 3f 00    	call   *0x3f91f6(%rip)        # b02250 <_DYNAMIC+0x438>
  70905a:	48 85 c0             	test   %rax,%rax
  70905d:	0f 84 05 0e 00 00    	je     709e68 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cd8>
  709063:	83 fd 01             	cmp    $0x1,%ebp
  709066:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70906b:	0f 85 a6 00 00 00    	jne    709117 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf87>
  709071:	48 8b 78 08          	mov    0x8(%rax),%rdi
  709075:	e9 a1 00 00 00       	jmp    70911b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf8b>
  70907a:	49 8d 86 00 02 00 00 	lea    0x200(%r14),%rax
  709081:	48 8b 00             	mov    (%rax),%rax
  709084:	48 8d 15 9d d2 95 ff 	lea    -0x6a2d63(%rip),%rdx        # 66328 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1488>
  70908b:	48 63 0c 82          	movslq (%rdx,%rax,4),%rcx
  70908f:	48 01 d1             	add    %rdx,%rcx
  709092:	48 8d 05 8b d9 95 ff 	lea    -0x6a2675(%rip),%rax        # 66a24 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x204>
  709099:	ff e1                	jmp    *%rcx
  70909b:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  7090a2:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  7090a7:	48 39 c6             	cmp    %rax,%rsi
  7090aa:	0f 86 3a 0f 00 00    	jbe    709fea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e5a>
  7090b0:	48 6b c0 58          	imul   $0x58,%rax,%rax
  7090b4:	49 03 86 10 02 00 00 	add    0x210(%r14),%rax
  7090bb:	e9 4e 03 00 00       	jmp    70940e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x127e>
  7090c0:	85 ed                	test   %ebp,%ebp
  7090c2:	0f 85 18 0e 00 00    	jne    709ee0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d50>
  7090c8:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  7090cf:	00 
  7090d0:	8b 40 20             	mov    0x20(%rax),%eax
  7090d3:	89 c1                	mov    %eax,%ecx
  7090d5:	83 e1 07             	and    $0x7,%ecx
  7090d8:	83 f9 06             	cmp    $0x6,%ecx
  7090db:	74 74                	je     709151 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  7090dd:	c1 e8 03             	shr    $0x3,%eax
  7090e0:	74 6f                	je     709151 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  7090e2:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  7090e9:	ff c8                	dec    %eax
  7090eb:	48 39 c6             	cmp    %rax,%rsi
  7090ee:	0f 86 23 0f 00 00    	jbe    70a017 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e87>
  7090f4:	49 8b 8e b0 02 00 00 	mov    0x2b0(%r14),%rcx
  7090fb:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  7090ff:	48 c1 e0 04          	shl    $0x4,%rax
  709103:	48 83 3c 01 fe       	cmpq   $0xfffffffffffffffe,(%rcx,%rax,1)
  709108:	0f 84 59 0e 00 00    	je     709f67 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1dd7>
  70910e:	48 01 c1             	add    %rax,%rcx
  709111:	48 8b 79 40          	mov    0x40(%rcx),%rdi
  709115:	eb 13                	jmp    70912a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf9a>
  709117:	48 8b 78 10          	mov    0x10(%rax),%rdi
  70911b:	b0 01                	mov    $0x1,%al
  70911d:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  709124:	00 
  709125:	48 85 ff             	test   %rdi,%rdi
  709128:	74 27                	je     709151 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  70912a:	48 8b 07             	mov    (%rdi),%rax
  70912d:	48 d1 e8             	shr    $1,%rax
  709130:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  709135:	48 39 d0             	cmp    %rdx,%rax
  709138:	75 17                	jne    709151 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  70913a:	48 83 c7 10          	add    $0x10,%rdi
  70913e:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  709143:	ff 15 0f 91 3f 00    	call   *0x3f910f(%rip)        # b02258 <bcmp@GLIBC_2.2.5>
  709149:	85 c0                	test   %eax,%eax
  70914b:	0f 84 3a 06 00 00    	je     70978b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x15fb>
  709151:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  709156:	4d 85 e4             	test   %r12,%r12
  709159:	75 6d                	jne    7091c8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1038>
  70915b:	4c 8d 25 4e cf 95 ff 	lea    -0x6a30b2(%rip),%r12        # 660b0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1210>
  709162:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  709167:	48 85 f6             	test   %rsi,%rsi
  70916a:	74 41                	je     7091ad <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x101d>
  70916c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  709173:	00 00 
  709175:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  70917a:	31 d2                	xor    %edx,%edx
  70917c:	31 c9                	xor    %ecx,%ecx
  70917e:	ff 15 dc 90 3f 00    	call   *0x3f90dc(%rip)        # b02260 <_DYNAMIC+0x448>
  709184:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  709189:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  70918d:	0f 85 6e 0e 00 00    	jne    70a001 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e71>
  709193:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
  709198:	49 8d 7c 24 10       	lea    0x10(%r12),%rdi
  70919d:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  7091a2:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  7091a7:	ff 15 db 8e 3f 00    	call   *0x3f8edb(%rip)        # b02088 <memcpy@GLIBC_2.14>
  7091ad:	f3 41 0f 6f 86 c8 06 	movdqu 0x6c8(%r14),%xmm0
  7091b4:	00 00 
  7091b6:	66 0f d4 84 24 b0 03 	paddq  0x3b0(%rsp),%xmm0
  7091bd:	00 00 
  7091bf:	f3 41 0f 7f 86 c8 06 	movdqu %xmm0,0x6c8(%r14)
  7091c6:	00 00 
  7091c8:	85 ed                	test   %ebp,%ebp
  7091ca:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  7091cf:	0f 84 b1 00 00 00    	je     709286 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10f6>
  7091d5:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  7091dc:	48 8b 38             	mov    (%rax),%rdi
  7091df:	41 bd 2b 00 00 00    	mov    $0x2b,%r13d
  7091e5:	48 85 ff             	test   %rdi,%rdi
  7091e8:	0f 84 2e 0d 00 00    	je     709f1c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d8c>
  7091ee:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  7091f3:	ff 15 6f 90 3f 00    	call   *0x3f906f(%rip)        # b02268 <_DYNAMIC+0x450>
  7091f9:	48 85 c0             	test   %rax,%rax
  7091fc:	0f 84 1a 0d 00 00    	je     709f1c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d8c>
  709202:	83 fd 01             	cmp    $0x1,%ebp
  709205:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70920a:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  70920f:	0f 85 4d 01 00 00    	jne    709362 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11d2>
  709215:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  70921a:	48 85 c9             	test   %rcx,%rcx
  70921d:	74 2c                	je     70924b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  70921f:	f6 01 01             	testb  $0x1,(%rcx)
  709222:	75 27                	jne    70924b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  709224:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  709228:	f6 c2 01             	test   $0x1,%dl
  70922b:	75 1e                	jne    70924b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  70922d:	ba 02 00 00 00       	mov    $0x2,%edx
  709232:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  709238:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  70923f:	00 
  709240:	48 f7 da             	neg    %rdx
  709243:	71 06                	jno    70924b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  709245:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  70924b:	48 89 c5             	mov    %rax,%rbp
  70924e:	48 8b 78 08          	mov    0x8(%rax),%rdi
  709252:	48 85 ff             	test   %rdi,%rdi
  709255:	74 1c                	je     709273 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  709257:	f6 07 01             	testb  $0x1,(%rdi)
  70925a:	75 17                	jne    709273 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  70925c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709260:	a8 01                	test   $0x1,%al
  709262:	75 0f                	jne    709273 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  709264:	48 8d 47 08          	lea    0x8(%rdi),%rax
  709268:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  70926d:	0f 84 50 06 00 00    	je     7098c3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1733>
  709273:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709278:	48 89 45 08          	mov    %rax,0x8(%rbp)
  70927c:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  709281:	e9 de 05 00 00       	jmp    709864 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16d4>
  709286:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  70928d:	00 
  70928e:	8b 78 20             	mov    0x20(%rax),%edi
  709291:	89 f8                	mov    %edi,%eax
  709293:	83 e0 07             	and    $0x7,%eax
  709296:	41 bd 16 00 00 00    	mov    $0x16,%r13d
  70929c:	83 f8 06             	cmp    $0x6,%eax
  70929f:	0f 84 59 0c 00 00    	je     709efe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d6e>
  7092a5:	c1 ef 03             	shr    $0x3,%edi
  7092a8:	0f 84 50 0c 00 00    	je     709efe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d6e>
  7092ae:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  7092b5:	ff cf                	dec    %edi
  7092b7:	48 39 fe             	cmp    %rdi,%rsi
  7092ba:	0f 86 01 0d 00 00    	jbe    709fc1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e31>
  7092c0:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  7092c7:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  7092cb:	48 c1 e0 04          	shl    $0x4,%rax
  7092cf:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  7092d5:	0f 84 5f 0c 00 00    	je     709f3a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1daa>
  7092db:	4d 85 e4             	test   %r12,%r12
  7092de:	0f 84 68 0c 00 00    	je     709f4c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1dbc>
  7092e4:	41 f6 04 24 01       	testb  $0x1,(%r12)
  7092e9:	75 2a                	jne    709315 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1185>
  7092eb:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  7092f0:	f6 c1 01             	test   $0x1,%cl
  7092f3:	75 20                	jne    709315 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1185>
  7092f5:	b9 02 00 00 00       	mov    $0x2,%ecx
  7092fa:	f0 49 0f c1 4c 24 08 	lock xadd %rcx,0x8(%r12)
  709301:	48 23 8c 24 38 01 00 	and    0x138(%rsp),%rcx
  709308:	00 
  709309:	48 f7 d9             	neg    %rcx
  70930c:	71 07                	jno    709315 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1185>
  70930e:	f0 49 83 4c 24 08 01 	lock orq $0x1,0x8(%r12)
  709315:	48 01 c5             	add    %rax,%rbp
  709318:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  70931c:	f6 07 01             	testb  $0x1,(%rdi)
  70931f:	75 17                	jne    709338 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11a8>
  709321:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709325:	a8 01                	test   $0x1,%al
  709327:	75 0f                	jne    709338 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11a8>
  709329:	48 8d 47 08          	lea    0x8(%rdi),%rax
  70932d:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  709332:	0f 84 7c 05 00 00    	je     7098b4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1724>
  709338:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  70933c:	48 89 ef             	mov    %rbp,%rdi
  70933f:	e8 bc 85 ff ff       	call   701900 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  709344:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  70934b:	ff 
  70934c:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  709353:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  709358:	e8 d3 86 01 00       	call   721a30 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  70935d:	e9 e1 04 00 00       	jmp    709843 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16b3>
  709362:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  709367:	48 85 c9             	test   %rcx,%rcx
  70936a:	74 2c                	je     709398 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  70936c:	f6 01 01             	testb  $0x1,(%rcx)
  70936f:	75 27                	jne    709398 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  709371:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  709375:	f6 c2 01             	test   $0x1,%dl
  709378:	75 1e                	jne    709398 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  70937a:	ba 02 00 00 00       	mov    $0x2,%edx
  70937f:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  709385:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  70938c:	00 
  70938d:	48 f7 da             	neg    %rdx
  709390:	71 06                	jno    709398 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  709392:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  709398:	48 89 c5             	mov    %rax,%rbp
  70939b:	48 8b 78 10          	mov    0x10(%rax),%rdi
  70939f:	48 85 ff             	test   %rdi,%rdi
  7093a2:	74 1c                	je     7093c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  7093a4:	f6 07 01             	testb  $0x1,(%rdi)
  7093a7:	75 17                	jne    7093c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  7093a9:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7093ad:	a8 01                	test   $0x1,%al
  7093af:	75 0f                	jne    7093c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  7093b1:	48 8d 47 08          	lea    0x8(%rdi),%rax
  7093b5:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  7093ba:	0f 84 12 05 00 00    	je     7098d2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1742>
  7093c0:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7093c5:	48 89 45 10          	mov    %rax,0x10(%rbp)
  7093c9:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  7093ce:	e9 91 04 00 00       	jmp    709864 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16d4>
  7093d3:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  7093da:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  7093df:	48 39 ce             	cmp    %rcx,%rsi
  7093e2:	0f 86 eb 0b 00 00    	jbe    709fd3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e43>
  7093e8:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  7093ef:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  7093f6:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
  7093fa:	48 39 c6             	cmp    %rax,%rsi
  7093fd:	0f 86 d9 0b 00 00    	jbe    709fdc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e4c>
  709403:	48 6b c0 58          	imul   $0x58,%rax,%rax
  709407:	49 03 86 08 02 00 00 	add    0x208(%r14),%rax
  70940e:	48 8b 48 50          	mov    0x50(%rax),%rcx
  709412:	48 89 8c 24 b0 02 00 	mov    %rcx,0x2b0(%rsp)
  709419:	00 
  70941a:	0f 10 40 40          	movups 0x40(%rax),%xmm0
  70941e:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
  709425:	00 
  709426:	f3 0f 6f 00          	movdqu (%rax),%xmm0
  70942a:	f3 0f 6f 48 10       	movdqu 0x10(%rax),%xmm1
  70942f:	0f 10 50 20          	movups 0x20(%rax),%xmm2
  709433:	0f 10 58 30          	movups 0x30(%rax),%xmm3
  709437:	0f 29 9c 24 90 02 00 	movaps %xmm3,0x290(%rsp)
  70943e:	00 
  70943f:	0f 29 94 24 80 02 00 	movaps %xmm2,0x280(%rsp)
  709446:	00 
  709447:	66 0f 7f 8c 24 70 02 	movdqa %xmm1,0x270(%rsp)
  70944e:	00 00 
  709450:	66 0f 7f 84 24 60 02 	movdqa %xmm0,0x260(%rsp)
  709457:	00 00 
  709459:	eb 1a                	jmp    709475 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x12e5>
  70945b:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  709462:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
  709469:	00 
  70946a:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  70946f:	ff 15 fb 8c 3f 00    	call   *0x3f8cfb(%rip)        # b02170 <_DYNAMIC+0x358>
  709475:	48 8b 84 24 b0 02 00 	mov    0x2b0(%rsp),%rax
  70947c:	00 
  70947d:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  709484:	00 
  709485:	0f 28 84 24 a0 02 00 	movaps 0x2a0(%rsp),%xmm0
  70948c:	00 
  70948d:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  709494:	00 
  709495:	66 0f 6f 84 24 60 02 	movdqa 0x260(%rsp),%xmm0
  70949c:	00 00 
  70949e:	66 0f 6f 8c 24 70 02 	movdqa 0x270(%rsp),%xmm1
  7094a5:	00 00 
  7094a7:	0f 28 94 24 80 02 00 	movaps 0x280(%rsp),%xmm2
  7094ae:	00 
  7094af:	0f 28 9c 24 90 02 00 	movaps 0x290(%rsp),%xmm3
  7094b6:	00 
  7094b7:	0f 29 9c 24 a0 00 00 	movaps %xmm3,0xa0(%rsp)
  7094be:	00 
  7094bf:	0f 29 94 24 90 00 00 	movaps %xmm2,0x90(%rsp)
  7094c6:	00 
  7094c7:	66 0f 7f 8c 24 80 00 	movdqa %xmm1,0x80(%rsp)
  7094ce:	00 00 
  7094d0:	66 0f 7f 44 24 70    	movdqa %xmm0,0x70(%rsp)
  7094d6:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  7094dd:	00 
  7094de:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  7094e5:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  7094ea:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  7094ef:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  7094f4:	4c 8d 8c 24 74 03 00 	lea    0x374(%rsp),%r9
  7094fb:	00 
  7094fc:	e8 df 80 02 00       	call   7315e0 <<gpui::property::Overrides>::update_base>
  709501:	8b 84 24 60 01 00 00 	mov    0x160(%rsp),%eax
  709508:	8b 8c 24 65 01 00 00 	mov    0x165(%rsp),%ecx
  70950f:	0f b6 ac 24 69 01 00 	movzbl 0x169(%rsp),%ebp
  709516:	00 
  709517:	48 c1 e5 20          	shl    $0x20,%rbp
  70951b:	48 09 cd             	or     %rcx,%rbp
  70951e:	0f b6 bc 24 64 01 00 	movzbl 0x164(%rsp),%edi
  709525:	00 
  709526:	83 f8 02             	cmp    $0x2,%eax
  709529:	0f 84 ba 08 00 00    	je     709de9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c59>
  70952f:	48 8d 8c 24 68 01 00 	lea    0x168(%rsp),%rcx
  709536:	00 
  709537:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  70953b:	48 8d 94 24 ca 01 00 	lea    0x1ca(%rsp),%rdx
  709542:	00 
  709543:	0f 11 42 3e          	movups %xmm0,0x3e(%rdx)
  709547:	0f 10 41 02          	movups 0x2(%rcx),%xmm0
  70954b:	0f 10 49 12          	movups 0x12(%rcx),%xmm1
  70954f:	0f 10 51 22          	movups 0x22(%rcx),%xmm2
  709553:	0f 10 59 32          	movups 0x32(%rcx),%xmm3
  709557:	0f 11 5a 30          	movups %xmm3,0x30(%rdx)
  70955b:	0f 11 52 20          	movups %xmm2,0x20(%rdx)
  70955f:	0f 11 4a 10          	movups %xmm1,0x10(%rdx)
  709563:	0f 11 02             	movups %xmm0,(%rdx)
  709566:	89 84 24 c0 01 00 00 	mov    %eax,0x1c0(%rsp)
  70956d:	40 88 bc 24 c4 01 00 	mov    %dil,0x1c4(%rsp)
  709574:	00 
  709575:	48 89 e8             	mov    %rbp,%rax
  709578:	48 c1 e8 20          	shr    $0x20,%rax
  70957c:	88 84 24 c9 01 00 00 	mov    %al,0x1c9(%rsp)
  709583:	89 ac 24 c5 01 00 00 	mov    %ebp,0x1c5(%rsp)
  70958a:	f3 0f 6f 84 24 d0 01 	movdqu 0x1d0(%rsp),%xmm0
  709591:	00 00 
  709593:	f3 0f 6f 8c 24 e0 01 	movdqu 0x1e0(%rsp),%xmm1
  70959a:	00 00 
  70959c:	0f 10 94 24 f0 01 00 	movups 0x1f0(%rsp),%xmm2
  7095a3:	00 
  7095a4:	0f 10 9c 24 00 02 00 	movups 0x200(%rsp),%xmm3
  7095ab:	00 
  7095ac:	66 0f 7f 84 24 d0 02 	movdqa %xmm0,0x2d0(%rsp)
  7095b3:	00 00 
  7095b5:	66 0f 7f 8c 24 e0 02 	movdqa %xmm1,0x2e0(%rsp)
  7095bc:	00 00 
  7095be:	0f 29 94 24 f0 02 00 	movaps %xmm2,0x2f0(%rsp)
  7095c5:	00 
  7095c6:	0f 29 9c 24 00 03 00 	movaps %xmm3,0x300(%rsp)
  7095cd:	00 
  7095ce:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  7095d5:	00 
  7095d6:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  7095dd:	00 
  7095de:	8b 84 24 c0 01 00 00 	mov    0x1c0(%rsp),%eax
  7095e5:	89 84 24 c0 02 00 00 	mov    %eax,0x2c0(%rsp)
  7095ec:	0f b6 84 24 c4 01 00 	movzbl 0x1c4(%rsp),%eax
  7095f3:	00 
  7095f4:	88 84 24 c4 02 00 00 	mov    %al,0x2c4(%rsp)
  7095fb:	8b 84 24 c5 01 00 00 	mov    0x1c5(%rsp),%eax
  709602:	89 84 24 c5 02 00 00 	mov    %eax,0x2c5(%rsp)
  709609:	0f b6 84 24 c9 01 00 	movzbl 0x1c9(%rsp),%eax
  709610:	00 
  709611:	88 84 24 c9 02 00 00 	mov    %al,0x2c9(%rsp)
  709618:	8b 84 24 ca 01 00 00 	mov    0x1ca(%rsp),%eax
  70961f:	89 84 24 ca 02 00 00 	mov    %eax,0x2ca(%rsp)
  709626:	0f b7 84 24 ce 01 00 	movzwl 0x1ce(%rsp),%eax
  70962d:	00 
  70962e:	66 89 84 24 ce 02 00 	mov    %ax,0x2ce(%rsp)
  709635:	00 
  709636:	0f b6 84 24 c0 02 00 	movzbl 0x2c0(%rsp),%eax
  70963d:	00 
  70963e:	83 bc 24 60 02 00 00 	cmpl   $0x1,0x260(%rsp)
  709645:	01 
  709646:	75 1a                	jne    709662 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x14d2>
  709648:	8b 8c 24 c4 02 00 00 	mov    0x2c4(%rsp),%ecx
  70964f:	39 8c 24 64 02 00 00 	cmp    %ecx,0x264(%rsp)
  709656:	0f 94 c1             	sete   %cl
  709659:	84 c8                	test   %cl,%al
  70965b:	75 0d                	jne    70966a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x14da>
  70965d:	e9 38 01 00 00       	jmp    70979a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709662:	a8 01                	test   $0x1,%al
  709664:	0f 85 30 01 00 00    	jne    70979a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  70966a:	0f b6 84 24 c8 02 00 	movzbl 0x2c8(%rsp),%eax
  709671:	00 
  709672:	83 bc 24 68 02 00 00 	cmpl   $0x1,0x268(%rsp)
  709679:	01 
  70967a:	75 1b                	jne    709697 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1507>
  70967c:	8b 8c 24 cc 02 00 00 	mov    0x2cc(%rsp),%ecx
  709683:	39 8c 24 6c 02 00 00 	cmp    %ecx,0x26c(%rsp)
  70968a:	0f 94 c1             	sete   %cl
  70968d:	84 c8                	test   %cl,%al
  70968f:	0f 84 05 01 00 00    	je     70979a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709695:	eb 08                	jmp    70969f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x150f>
  709697:	a8 01                	test   $0x1,%al
  709699:	0f 85 fb 00 00 00    	jne    70979a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  70969f:	8b 84 24 70 02 00 00 	mov    0x270(%rsp),%eax
  7096a6:	3b 84 24 d0 02 00 00 	cmp    0x2d0(%rsp),%eax
  7096ad:	0f 85 e7 00 00 00    	jne    70979a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7096b3:	8b 84 24 74 02 00 00 	mov    0x274(%rsp),%eax
  7096ba:	3b 84 24 d4 02 00 00 	cmp    0x2d4(%rsp),%eax
  7096c1:	0f 85 d3 00 00 00    	jne    70979a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7096c7:	8b 84 24 78 02 00 00 	mov    0x278(%rsp),%eax
  7096ce:	3b 84 24 d8 02 00 00 	cmp    0x2d8(%rsp),%eax
  7096d5:	0f 85 bf 00 00 00    	jne    70979a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7096db:	0f b6 84 24 b4 02 00 	movzbl 0x2b4(%rsp),%eax
  7096e2:	00 
  7096e3:	3a 84 24 14 03 00 00 	cmp    0x314(%rsp),%al
  7096ea:	0f 85 aa 00 00 00    	jne    70979a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7096f0:	0f b6 84 24 b6 02 00 	movzbl 0x2b6(%rsp),%eax
  7096f7:	00 
  7096f8:	3a 84 24 16 03 00 00 	cmp    0x316(%rsp),%al
  7096ff:	0f 85 95 00 00 00    	jne    70979a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709705:	0f b6 84 24 b7 02 00 	movzbl 0x2b7(%rsp),%eax
  70970c:	00 
  70970d:	3a 84 24 17 03 00 00 	cmp    0x317(%rsp),%al
  709714:	0f 85 80 00 00 00    	jne    70979a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  70971a:	0f b6 84 24 b5 02 00 	movzbl 0x2b5(%rsp),%eax
  709721:	00 
  709722:	3a 84 24 15 03 00 00 	cmp    0x315(%rsp),%al
  709729:	75 6f                	jne    70979a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  70972b:	48 8d bc 24 9c 02 00 	lea    0x29c(%rsp),%rdi
  709732:	00 
  709733:	48 8d b4 24 fc 02 00 	lea    0x2fc(%rsp),%rsi
  70973a:	00 
  70973b:	e8 90 67 01 00       	call   71fed0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  709740:	84 c0                	test   %al,%al
  709742:	74 56                	je     70979a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709744:	f3 0f 6f 84 24 7c 02 	movdqu 0x27c(%rsp),%xmm0
  70974b:	00 00 
  70974d:	f3 0f 6f 8c 24 dc 02 	movdqu 0x2dc(%rsp),%xmm1
  709754:	00 00 
  709756:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  70975a:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  70975e:	3d ff ff 00 00       	cmp    $0xffff,%eax
  709763:	75 35                	jne    70979a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709765:	f3 0f 6f 84 24 8c 02 	movdqu 0x28c(%rsp),%xmm0
  70976c:	00 00 
  70976e:	f3 0f 6f 8c 24 ec 02 	movdqu 0x2ec(%rsp),%xmm1
  709775:	00 00 
  709777:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  70977b:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  70977f:	3d ff ff 00 00       	cmp    $0xffff,%eax
  709784:	75 14                	jne    70979a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709786:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70978b:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  709790:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  709795:	e9 08 01 00 00       	jmp    7098a2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1712>
  70979a:	48 8d 05 6f b2 3c 00 	lea    0x3cb26f(%rip),%rax        # ad4a10 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1198>
  7097a1:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  7097a6:	80 78 13 02          	cmpb   $0x2,0x13(%rax)
  7097aa:	75 11                	jne    7097bd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x162d>
  7097ac:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  7097b3:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  7097b8:	e8 73 82 01 00       	call   721a30 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  7097bd:	66 83 7c 24 08 05    	cmpw   $0x5,0x8(%rsp)
  7097c3:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  7097c8:	75 5a                	jne    709824 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1694>
  7097ca:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  7097d1:	00 
  7097d2:	8b 40 20             	mov    0x20(%rax),%eax
  7097d5:	89 c1                	mov    %eax,%ecx
  7097d7:	83 e1 07             	and    $0x7,%ecx
  7097da:	83 f9 06             	cmp    $0x6,%ecx
  7097dd:	74 45                	je     709824 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1694>
  7097df:	c1 e8 03             	shr    $0x3,%eax
  7097e2:	74 40                	je     709824 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1694>
  7097e4:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  7097eb:	ff c8                	dec    %eax
  7097ed:	48 39 c6             	cmp    %rax,%rsi
  7097f0:	0f 86 fd 07 00 00    	jbe    709ff3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e63>
  7097f6:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  7097fd:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  709801:	48 c1 e0 04          	shl    $0x4,%rax
  709805:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  70980b:	0f 84 65 07 00 00    	je     709f76 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1de6>
  709811:	48 01 c5             	add    %rax,%rbp
  709814:	48 89 ef             	mov    %rbp,%rdi
  709817:	e8 e4 80 ff ff       	call   701900 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  70981c:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  709823:	ff 
  709824:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  70982b:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  709832:	4c 89 e6             	mov    %r12,%rsi
  709835:	48 8d 94 24 c0 01 00 	lea    0x1c0(%rsp),%rdx
  70983c:	00 
  70983d:	ff 15 2d 8a 3f 00    	call   *0x3f8a2d(%rip)        # b02270 <_DYNAMIC+0x458>
  709843:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  70984a:	01 
  70984b:	b0 01                	mov    $0x1,%al
  70984d:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  709854:	00 
  709855:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70985a:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  70985f:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  709864:	4c 39 ac 24 50 01 00 	cmp    %r13,0x150(%rsp)
  70986b:	00 
  70986c:	0f 94 c0             	sete   %al
  70986f:	84 84 24 d0 00 00 00 	test   %al,0xd0(%rsp)
  709876:	74 0c                	je     709884 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16f4>
  709878:	b0 01                	mov    $0x1,%al
  70987a:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  709881:	00 
  709882:	eb 19                	jmp    70989d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x170d>
  709884:	49 ff 86 08 07 00 00 	incq   0x708(%r14)
  70988b:	b0 01                	mov    $0x1,%al
  70988d:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  709894:	00 
  709895:	4c 89 ac 24 50 01 00 	mov    %r13,0x150(%rsp)
  70989c:	00 
  70989d:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7098a2:	48 83 c1 04          	add    $0x4,%rcx
  7098a6:	48 39 c8             	cmp    %rcx,%rax
  7098a9:	0f 85 cc f5 ff ff    	jne    708e7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xceb>
  7098af:	e9 ee 02 00 00       	jmp    709ba2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a12>
  7098b4:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7098b8:	ff 15 02 88 3f 00    	call   *0x3f8802(%rip)        # b020c0 <_DYNAMIC+0x2a8>
  7098be:	e9 75 fa ff ff       	jmp    709338 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11a8>
  7098c3:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7098c7:	ff 15 f3 87 3f 00    	call   *0x3f87f3(%rip)        # b020c0 <_DYNAMIC+0x2a8>
  7098cd:	e9 a1 f9 ff ff       	jmp    709273 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  7098d2:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7098d6:	ff 15 e4 87 3f 00    	call   *0x3f87e4(%rip)        # b020c0 <_DYNAMIC+0x2a8>
  7098dc:	e9 df fa ff ff       	jmp    7093c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  7098e1:	49 83 c4 04          	add    $0x4,%r12
  7098e5:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  7098ea:	0f 84 b1 f4 ff ff    	je     708da1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xc11>
  7098f0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7098f5:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  7098f9:	ff 15 39 89 3f 00    	call   *0x3f8939(%rip)        # b02238 <_DYNAMIC+0x420>
  7098ff:	66 85 c0             	test   %ax,%ax
  709902:	74 dd                	je     7098e1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1751>
  709904:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  709909:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  70990e:	48 8b 8c 24 50 03 00 	mov    0x350(%rsp),%rcx
  709915:	00 
  709916:	48 8d 54 24 78       	lea    0x78(%rsp),%rdx
  70991b:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
  70991f:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  709926:	00 00 
  709928:	f3 0f 7f 02          	movdqu %xmm0,(%rdx)
  70992c:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  709933:	00 
  709934:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  709939:	89 c2                	mov    %eax,%edx
  70993b:	ff 15 ff 88 3f 00    	call   *0x3f88ff(%rip)        # b02240 <_DYNAMIC+0x428>
  709941:	80 bc 24 60 01 00 00 	cmpb   $0xff,0x160(%rsp)
  709948:	ff 
  709949:	75 96                	jne    7098e1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1751>
  70994b:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  709952:	00 
  709953:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  70995a:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  709961:	00 
  709962:	48 c1 e5 20          	shl    $0x20,%rbp
  709966:	48 09 c5             	or     %rax,%rbp
  709969:	b8 24 00 00 00       	mov    $0x24,%eax
  70996e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709973:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709978:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  70997d:	48 85 f6             	test   %rsi,%rsi
  709980:	0f 8e 12 02 00 00    	jle    709b98 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a08>
  709986:	ba 01 00 00 00       	mov    $0x1,%edx
  70998b:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  70998f:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  709994:	ff 15 c6 86 3f 00    	call   *0x3f86c6(%rip)        # b02060 <_DYNAMIC+0x248>
  70999a:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  70999e:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  7099a3:	e9 1f 03 00 00       	jmp    709cc7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  7099a8:	31 ff                	xor    %edi,%edi
  7099aa:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  7099af:	48 85 f6             	test   %rsi,%rsi
  7099b2:	7e 5c                	jle    709a10 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1880>
  7099b4:	ba 01 00 00 00       	mov    $0x1,%edx
  7099b9:	89 fd                	mov    %edi,%ebp
  7099bb:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  7099c0:	ff 15 9a 86 3f 00    	call   *0x3f869a(%rip)        # b02060 <_DYNAMIC+0x248>
  7099c6:	89 ef                	mov    %ebp,%edi
  7099c8:	eb 46                	jmp    709a10 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1880>
  7099ca:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  7099d1:	00 
  7099d2:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  7099d9:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  7099e0:	00 
  7099e1:	48 c1 e5 20          	shl    $0x20,%rbp
  7099e5:	48 09 c5             	or     %rax,%rbp
  7099e8:	b8 24 00 00 00       	mov    $0x24,%eax
  7099ed:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7099f2:	e9 99 02 00 00       	jmp    709c90 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  7099f7:	b0 01                	mov    $0x1,%al
  7099f9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  7099fe:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  709a05:	48 85 ed             	test   %rbp,%rbp
  709a08:	0f 85 0e ef ff ff    	jne    70891c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x78c>
  709a0e:	31 ff                	xor    %edi,%edi
  709a10:	80 7c 24 40 00       	cmpb   $0x0,0x40(%rsp)
  709a15:	74 3c                	je     709a53 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x18c3>
  709a17:	41 80 be 1f 07 00 00 	cmpb   $0x1,0x71f(%r14)
  709a1e:	01 
  709a1f:	75 32                	jne    709a53 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x18c3>
  709a21:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  709a26:	4c 89 f6             	mov    %r14,%rsi
  709a29:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  709a30:	00 
  709a31:	31 c9                	xor    %ecx,%ecx
  709a33:	e8 c8 d7 ff ff       	call   707200 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>
  709a38:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  709a3d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709a41:	75 1e                	jne    709a61 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x18d1>
  709a43:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  709a4a:	ff ff 
  709a4c:	31 ff                	xor    %edi,%edi
  709a4e:	e9 94 02 00 00       	jmp    709ce7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b57>
  709a53:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  709a5a:	ff ff 
  709a5c:	e9 86 02 00 00       	jmp    709ce7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b57>
  709a61:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  709a66:	0f b6 4c 24 7f       	movzbl 0x7f(%rsp),%ecx
  709a6b:	c1 e1 10             	shl    $0x10,%ecx
  709a6e:	0f b7 54 24 7d       	movzwl 0x7d(%rsp),%edx
  709a73:	09 ca                	or     %ecx,%edx
  709a75:	48 c1 e2 20          	shl    $0x20,%rdx
  709a79:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  709a7d:	48 09 d5             	or     %rdx,%rbp
  709a80:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  709a87:	00 
  709a88:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  709a8f:	00 
  709a90:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  709a97:	00 00 
  709a99:	66 0f 7f 84 24 c0 01 	movdqa %xmm0,0x1c0(%rsp)
  709aa0:	00 00 
  709aa2:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  709aa9:	00 
  709aaa:	48 89 8c 24 d0 01 00 	mov    %rcx,0x1d0(%rsp)
  709ab1:	00 
  709ab2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709ab7:	e9 2b 02 00 00       	jmp    709ce7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b57>
  709abc:	b8 20 00 00 00       	mov    $0x20,%eax
  709ac1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709ac6:	40 b7 0c             	mov    $0xc,%dil
  709ac9:	31 ed                	xor    %ebp,%ebp
  709acb:	4d 89 f8             	mov    %r15,%r8
  709ace:	e9 bd 01 00 00       	jmp    709c90 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  709ad3:	49 8b 86 90 06 00 00 	mov    0x690(%r14),%rax
  709ada:	48 8d 48 01          	lea    0x1(%rax),%rcx
  709ade:	49 3b 8e 60 06 00 00 	cmp    0x660(%r14),%rcx
  709ae5:	40 0f 94 c5          	sete   %bpl
  709ae9:	48 ff c0             	inc    %rax
  709aec:	0f 84 d5 f0 ff ff    	je     708bc7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa37>
  709af2:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  709af9:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  709b00:	00 
  709b01:	48 8d 8c 24 60 02 00 	lea    0x260(%rsp),%rcx
  709b08:	00 
  709b09:	ff 15 69 87 3f 00    	call   *0x3f8769(%rip)        # b02278 <_DYNAMIC+0x460>
  709b0f:	80 bc 24 60 01 00 00 	cmpb   $0x0,0x160(%rsp)
  709b16:	00 
  709b17:	74 21                	je     709b3a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x19aa>
  709b19:	8b 94 24 84 01 00 00 	mov    0x184(%rsp),%edx
  709b20:	49 89 96 08 07 00 00 	mov    %rdx,0x708(%r14)
  709b27:	40 84 ed             	test   %bpl,%bpl
  709b2a:	0f 84 48 01 00 00    	je     709c78 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ae8>
  709b30:	48 8d 94 24 64 01 00 	lea    0x164(%rsp),%rdx
  709b37:	00 
  709b38:	eb 16                	jmp    709b50 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x19c0>
  709b3a:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  709b41:	00 00 00 00 
  709b45:	31 d2                	xor    %edx,%edx
  709b47:	40 84 ed             	test   %bpl,%bpl
  709b4a:	0f 84 28 01 00 00    	je     709c78 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ae8>
  709b50:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  709b55:	4c 89 f6             	mov    %r14,%rsi
  709b58:	e8 f3 07 00 00       	call   70a350 <<gpui::runtime::Runtime<unit_action_cost::Model>>::finish_color_slot>
  709b5d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  709b62:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  709b67:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709b6b:	0f 85 8c 00 00 00    	jne    709bfd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a6d>
  709b71:	40 f6 c7 01          	test   $0x1,%dil
  709b75:	0f 84 f6 00 00 00    	je     709c71 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ae1>
  709b7b:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  709b82:	ff ff 
  709b84:	40 b7 02             	mov    $0x2,%dil
  709b87:	e9 04 01 00 00       	jmp    709c90 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  709b8c:	31 ff                	xor    %edi,%edi
  709b8e:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709b93:	e9 12 fe ff ff       	jmp    7099aa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709b98:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  709b9d:	e9 25 01 00 00       	jmp    709cc7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  709ba2:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  709ba9:	00 
  709baa:	34 01                	xor    $0x1,%al
  709bac:	0f b6 c0             	movzbl %al,%eax
  709baf:	31 ff                	xor    %edi,%edi
  709bb1:	f6 84 24 40 01 00 00 	testb  $0x1,0x140(%rsp)
  709bb8:	01 
  709bb9:	0f 45 f8             	cmovne %eax,%edi
  709bbc:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709bc1:	48 85 c0             	test   %rax,%rax
  709bc4:	0f 84 e0 fd ff ff    	je     7099aa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709bca:	f6 00 01             	testb  $0x1,(%rax)
  709bcd:	0f 85 d7 fd ff ff    	jne    7099aa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709bd3:	89 fd                	mov    %edi,%ebp
  709bd5:	48 8b 40 08          	mov    0x8(%rax),%rax
  709bd9:	a8 01                	test   $0x1,%al
  709bdb:	75 14                	jne    709bf1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a61>
  709bdd:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709be2:	48 83 c0 08          	add    $0x8,%rax
  709be6:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  709beb:	0f 84 b5 03 00 00    	je     709fa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e16>
  709bf1:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709bf6:	89 ef                	mov    %ebp,%edi
  709bf8:	e9 ad fd ff ff       	jmp    7099aa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709bfd:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709c02:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  709c07:	c1 e0 10             	shl    $0x10,%eax
  709c0a:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  709c0f:	09 c1                	or     %eax,%ecx
  709c11:	48 c1 e1 20          	shl    $0x20,%rcx
  709c15:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  709c19:	48 09 cd             	or     %rcx,%rbp
  709c1c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  709c23:	00 
  709c24:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  709c2b:	00 
  709c2c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  709c33:	00 
  709c34:	0f 29 84 24 20 03 00 	movaps %xmm0,0x320(%rsp)
  709c3b:	00 
  709c3c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  709c43:	00 
  709c44:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  709c4b:	00 
  709c4c:	eb 42                	jmp    709c90 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  709c4e:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  709c55:	00 
  709c56:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  709c5d:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  709c64:	00 
  709c65:	48 c1 e5 20          	shl    $0x20,%rbp
  709c69:	48 09 c5             	or     %rax,%rbp
  709c6c:	e9 85 01 00 00       	jmp    709df6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c66>
  709c71:	49 8b 96 08 07 00 00 	mov    0x708(%r14),%rdx
  709c78:	48 85 d2             	test   %rdx,%rdx
  709c7b:	0f 95 c0             	setne  %al
  709c7e:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  709c85:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  709c8c:	ff ff 
  709c8e:	31 ff                	xor    %edi,%edi
  709c90:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  709c95:	48 85 f6             	test   %rsi,%rsi
  709c98:	7e 22                	jle    709cbc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b2c>
  709c9a:	ba 01 00 00 00       	mov    $0x1,%edx
  709c9f:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  709ca4:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  709ca8:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  709cad:	ff 15 ad 83 3f 00    	call   *0x3f83ad(%rip)        # b02060 <_DYNAMIC+0x248>
  709cb3:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  709cb7:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  709cbc:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  709cc1:	0f 84 49 fd ff ff    	je     709a10 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1880>
  709cc7:	48 8b 84 24 30 03 00 	mov    0x330(%rsp),%rax
  709cce:	00 
  709ccf:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  709cd6:	00 
  709cd7:	0f 28 84 24 20 03 00 	movaps 0x320(%rsp),%xmm0
  709cde:	00 
  709cdf:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  709ce6:	00 
  709ce7:	40 0f b6 c7          	movzbl %dil,%eax
  709ceb:	48 c1 e5 08          	shl    $0x8,%rbp
  709cef:	48 09 c5             	or     %rax,%rbp
  709cf2:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  709cf9:	00 
  709cfa:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  709d01:	00 
  709d02:	66 0f 6f 84 24 c0 01 	movdqa 0x1c0(%rsp),%xmm0
  709d09:	00 00 
  709d0b:	f3 0f 7f 84 24 10 01 	movdqu %xmm0,0x110(%rsp)
  709d12:	00 00 
  709d14:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  709d19:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  709d20:	00 
  709d21:	48 89 ac 24 f8 00 00 	mov    %rbp,0xf8(%rsp)
  709d28:	00 
  709d29:	4c 89 84 24 00 01 00 	mov    %r8,0x100(%rsp)
  709d30:	00 
  709d31:	4c 89 ac 24 08 01 00 	mov    %r13,0x108(%rsp)
  709d38:	00 
  709d39:	66 0f 7f 84 24 40 02 	movdqa %xmm0,0x240(%rsp)
  709d40:	00 00 
  709d42:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  709d49:	00 
  709d4a:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  709d51:	00 
  709d52:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  709d59:	00 
  709d5a:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
  709d61:	00 
  709d62:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
  709d69:	00 
  709d6a:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  709d71:	00 
  709d72:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  709d79:	00 
  709d7a:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  709d81:	00 
  709d82:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  709d89:	00 
  709d8a:	31 ed                	xor    %ebp,%ebp
  709d8c:	e9 41 e6 ff ff       	jmp    7083d2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x242>
  709d91:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709d96:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  709d9b:	c1 e0 10             	shl    $0x10,%eax
  709d9e:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  709da3:	09 c1                	or     %eax,%ecx
  709da5:	48 c1 e1 20          	shl    $0x20,%rcx
  709da9:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  709dad:	48 09 cd             	or     %rcx,%rbp
  709db0:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  709db7:	00 
  709db8:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  709dbd:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  709dc4:	00 
  709dc5:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  709dcc:	00 00 
  709dce:	66 0f 7f 84 24 20 03 	movdqa %xmm0,0x320(%rsp)
  709dd5:	00 00 
  709dd7:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  709dde:	00 
  709ddf:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  709de6:	00 
  709de7:	eb 17                	jmp    709e00 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c70>
  709de9:	48 b8 ff ff ff ff ff 	movabs $0xffffffffff,%rax
  709df0:	00 00 00 
  709df3:	48 21 c5             	and    %rax,%rbp
  709df6:	b8 24 00 00 00       	mov    $0x24,%eax
  709dfb:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709e00:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  709e05:	48 85 c9             	test   %rcx,%rcx
  709e08:	0f 84 65 fb ff ff    	je     709973 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e3>
  709e0e:	f6 01 01             	testb  $0x1,(%rcx)
  709e11:	0f 85 5c fb ff ff    	jne    709973 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e3>
  709e17:	48 8b 41 08          	mov    0x8(%rcx),%rax
  709e1b:	a8 01                	test   $0x1,%al
  709e1d:	0f 85 50 fb ff ff    	jne    709973 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e3>
  709e23:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  709e27:	48 8d 41 08          	lea    0x8(%rcx),%rax
  709e2b:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  709e30:	0f 84 53 01 00 00    	je     709f89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1df9>
  709e36:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709e3b:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  709e3f:	e9 34 fb ff ff       	jmp    709978 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e8>
  709e44:	48 8d 3d 0d a0 3c 00 	lea    0x3ca00d(%rip),%rdi        # ad3e58 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x5e0>
  709e4b:	ff 15 4f 82 3f 00    	call   *0x3f824f(%rip)        # b020a0 <_DYNAMIC+0x288>
  709e51:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709e55:	ff 15 65 82 3f 00    	call   *0x3f8265(%rip)        # b020c0 <_DYNAMIC+0x2a8>
  709e5b:	e9 c0 e6 ff ff       	jmp    708520 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x390>
  709e60:	41 bc 15 00 00 00    	mov    $0x15,%r12d
  709e66:	eb 3c                	jmp    709ea4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d14>
  709e68:	48 8d 05 d5 f7 95 ff 	lea    -0x6a082b(%rip),%rax        # 69644 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e24>
  709e6f:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  709e76:	00 
  709e77:	48 8d 05 42 a8 3c 00 	lea    0x3ca842(%rip),%rax        # ad46c0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe48>
  709e7e:	eb 1c                	jmp    709e9c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d0c>
  709e80:	41 bc 14 00 00 00    	mov    $0x14,%r12d
  709e86:	48 8d 05 a3 f7 95 ff 	lea    -0x6a085d(%rip),%rax        # 69630 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e10>
  709e8d:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  709e94:	00 
  709e95:	48 8d 05 0c a8 3c 00 	lea    0x3ca80c(%rip),%rax        # ad46a8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe30>
  709e9c:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  709ea3:	00 
  709ea4:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  709eab:	00 
  709eac:	4c 89 e6             	mov    %r12,%rsi
  709eaf:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  709eb6:	00 
  709eb7:	ff 15 c3 82 3f 00    	call   *0x3f82c3(%rip)        # b02180 <_DYNAMIC+0x368>
  709ebd:	e9 a7 01 00 00       	jmp    70a069 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709ec2:	48 8d 3d 3f f7 95 ff 	lea    -0x6a08c1(%rip),%rdi        # 69608 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2de8>
  709ec9:	48 8d 15 78 a7 3c 00 	lea    0x3ca778(%rip),%rdx        # ad4648 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xdd0>
  709ed0:	be 13 00 00 00       	mov    $0x13,%esi
  709ed5:	ff 15 a5 82 3f 00    	call   *0x3f82a5(%rip)        # b02180 <_DYNAMIC+0x368>
  709edb:	e9 89 01 00 00       	jmp    70a069 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709ee0:	48 8d 3d 9e f7 95 ff 	lea    -0x6a0862(%rip),%rdi        # 69685 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e65>
  709ee7:	48 8d 15 32 a8 3c 00 	lea    0x3ca832(%rip),%rdx        # ad4720 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xea8>
  709eee:	be 93 00 00 00       	mov    $0x93,%esi
  709ef3:	ff 15 bf 81 3f 00    	call   *0x3f81bf(%rip)        # b020b8 <_DYNAMIC+0x2a0>
  709ef9:	e9 6b 01 00 00       	jmp    70a069 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709efe:	48 8d 05 6a f7 95 ff 	lea    -0x6a0896(%rip),%rax        # 6966f <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e4f>
  709f05:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  709f0c:	00 
  709f0d:	48 8d 05 c4 a7 3c 00 	lea    0x3ca7c4(%rip),%rax        # ad46d8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe60>
  709f14:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  709f1b:	00 
  709f1c:	48 8b bc 24 30 01 00 	mov    0x130(%rsp),%rdi
  709f23:	00 
  709f24:	4c 89 ee             	mov    %r13,%rsi
  709f27:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
  709f2e:	00 
  709f2f:	ff 15 4b 82 3f 00    	call   *0x3f824b(%rip)        # b02180 <_DYNAMIC+0x368>
  709f35:	e9 2f 01 00 00       	jmp    70a069 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709f3a:	48 8d 3d d7 9b 3c 00 	lea    0x3c9bd7(%rip),%rdi        # ad3b18 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x2a0>
  709f41:	ff 15 59 81 3f 00    	call   *0x3f8159(%rip)        # b020a0 <_DYNAMIC+0x288>
  709f47:	e9 1d 01 00 00       	jmp    70a069 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709f4c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  709f53:	00 00 
  709f55:	48 8d 3d 94 a7 3c 00 	lea    0x3ca794(%rip),%rdi        # ad46f0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe78>
  709f5c:	ff 15 3e 81 3f 00    	call   *0x3f813e(%rip)        # b020a0 <_DYNAMIC+0x288>
  709f62:	e9 02 01 00 00       	jmp    70a069 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709f67:	48 8d 05 7a 9b 3c 00 	lea    0x3c9b7a(%rip),%rax        # ad3ae8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x270>
  709f6e:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  709f75:	00 
  709f76:	48 8b bc 24 b8 01 00 	mov    0x1b8(%rsp),%rdi
  709f7d:	00 
  709f7e:	ff 15 1c 81 3f 00    	call   *0x3f811c(%rip)        # b020a0 <_DYNAMIC+0x288>
  709f84:	e9 e0 00 00 00       	jmp    70a069 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709f89:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  709f8e:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709f92:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709f97:	ff 15 23 81 3f 00    	call   *0x3f8123(%rip)        # b020c0 <_DYNAMIC+0x2a8>
  709f9d:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  709fa1:	e9 d2 f9 ff ff       	jmp    709978 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e8>
  709fa6:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  709fab:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709faf:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709fb4:	ff 15 06 81 3f 00    	call   *0x3f8106(%rip)        # b020c0 <_DYNAMIC+0x2a8>
  709fba:	89 ef                	mov    %ebp,%edi
  709fbc:	e9 e9 f9 ff ff       	jmp    7099aa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709fc1:	48 8d 15 38 9b 3c 00 	lea    0x3c9b38(%rip),%rdx        # ad3b00 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x288>
  709fc8:	ff 15 c2 81 3f 00    	call   *0x3f81c2(%rip)        # b02190 <_DYNAMIC+0x378>
  709fce:	e9 96 00 00 00       	jmp    70a069 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709fd3:	48 8d 05 c6 9e 3c 00 	lea    0x3c9ec6(%rip),%rax        # ad3ea0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x628>
  709fda:	eb 47                	jmp    70a023 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  709fdc:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  709fe1:	48 8d 05 d0 9e 3c 00 	lea    0x3c9ed0(%rip),%rax        # ad3eb8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x640>
  709fe8:	eb 39                	jmp    70a023 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  709fea:	48 8d 05 97 9e 3c 00 	lea    0x3c9e97(%rip),%rax        # ad3e88 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x610>
  709ff1:	eb 30                	jmp    70a023 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  709ff3:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  709ff8:	48 8d 05 01 9b 3c 00 	lea    0x3c9b01(%rip),%rax        # ad3b00 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x288>
  709fff:	eb 22                	jmp    70a023 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  70a001:	48 85 ff             	test   %rdi,%rdi
  70a004:	75 34                	jne    70a03a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1eaa>
  70a006:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  70a00d:	00 00 
  70a00f:	ff 15 6b 82 3f 00    	call   *0x3f826b(%rip)        # b02280 <_DYNAMIC+0x468>
  70a015:	eb 52                	jmp    70a069 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  70a017:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  70a01c:	48 8d 05 ad 9a 3c 00 	lea    0x3c9aad(%rip),%rax        # ad3ad0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x258>
  70a023:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  70a028:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  70a02d:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  70a032:	ff 15 58 81 3f 00    	call   *0x3f8158(%rip)        # b02190 <_DYNAMIC+0x378>
  70a038:	eb 2f                	jmp    70a069 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  70a03a:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  70a03f:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  70a046:	00 00 
  70a048:	ff 15 42 80 3f 00    	call   *0x3f8042(%rip)        # b02090 <_DYNAMIC+0x278>
  70a04e:	eb 19                	jmp    70a069 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  70a050:	48 8d 3d c4 f5 95 ff 	lea    -0x6a0a3c(%rip),%rdi        # 6961b <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2dfb>
  70a057:	48 8d 15 02 a6 3c 00 	lea    0x3ca602(%rip),%rdx        # ad4660 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xde8>
  70a05e:	be 15 00 00 00       	mov    $0x15,%esi
  70a063:	ff 15 17 81 3f 00    	call   *0x3f8117(%rip)        # b02180 <_DYNAMIC+0x368>
  70a069:	0f 0b                	ud2
  70a06b:	49 89 c5             	mov    %rax,%r13
  70a06e:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  70a073:	48 89 45 10          	mov    %rax,0x10(%rbp)
  70a077:	eb 6d                	jmp    70a0e6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  70a079:	49 89 c5             	mov    %rax,%r13
  70a07c:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  70a081:	48 89 45 08          	mov    %rax,0x8(%rbp)
  70a085:	eb 5f                	jmp    70a0e6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  70a087:	49 89 c5             	mov    %rax,%r13
  70a08a:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  70a08e:	eb 56                	jmp    70a0e6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  70a090:	48 89 c3             	mov    %rax,%rbx
  70a093:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  70a09a:	00 
  70a09b:	e8 40 a7 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a0a0:	48 89 df             	mov    %rbx,%rdi
  70a0a3:	e8 98 83 3c 00       	call   ad2440 <_Unwind_Resume@plt>
  70a0a8:	eb 18                	jmp    70a0c2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f32>
  70a0aa:	eb 16                	jmp    70a0c2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f32>
  70a0ac:	eb 00                	jmp    70a0ae <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f1e>
  70a0ae:	49 89 c5             	mov    %rax,%r13
  70a0b1:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  70a0b8:	ff 
  70a0b9:	eb 2b                	jmp    70a0e6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  70a0bb:	49 89 c5             	mov    %rax,%r13
  70a0be:	eb 4d                	jmp    70a10d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f7d>
  70a0c0:	eb 21                	jmp    70a0e3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f53>
  70a0c2:	49 89 c5             	mov    %rax,%r13
  70a0c5:	eb 29                	jmp    70a0f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f60>
  70a0c7:	49 89 c5             	mov    %rax,%r13
  70a0ca:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
  70a0d0:	7e 3b                	jle    70a10d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f7d>
  70a0d2:	ba 01 00 00 00       	mov    $0x1,%edx
  70a0d7:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  70a0dc:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  70a0e1:	eb 24                	jmp    70a107 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f77>
  70a0e3:	49 89 c5             	mov    %rax,%r13
  70a0e6:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  70a0eb:	e8 80 77 ff ff       	call   701870 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  70a0f0:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  70a0f6:	7e 15                	jle    70a10d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f7d>
  70a0f8:	ba 01 00 00 00       	mov    $0x1,%edx
  70a0fd:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  70a102:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  70a107:	ff 15 53 7f 3f 00    	call   *0x3f7f53(%rip)        # b02060 <_DYNAMIC+0x248>
  70a10d:	4c 89 ef             	mov    %r13,%rdi
  70a110:	ff 15 8a 80 3f 00    	call   *0x3f808a(%rip)        # b021a0 <_DYNAMIC+0x388>
  70a116:	49 89 c5             	mov    %rax,%r13
  70a119:	48 89 d5             	mov    %rdx,%rbp
  70a11c:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
  70a123:	00 
  70a124:	48 89 94 24 00 01 00 	mov    %rdx,0x100(%rsp)
  70a12b:	00 
  70a12c:	48 c7 84 24 f0 00 00 	movq   $0xfffffffffffffffd,0xf0(%rsp)
  70a133:	00 fd ff ff ff 
  70a138:	4c 89 f7             	mov    %r14,%rdi
  70a13b:	e8 40 43 01 00       	call   71e480 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  70a140:	48 c7 84 24 20 02 00 	movq   $0xf,0x220(%rsp)
  70a147:	00 0f 00 00 00 
  70a14c:	48 8b 45 00          	mov    0x0(%rbp),%rax
  70a150:	48 85 c0             	test   %rax,%rax
  70a153:	74 05                	je     70a15a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1fca>
  70a155:	4c 89 ef             	mov    %r13,%rdi
  70a158:	ff d0                	call   *%rax
  70a15a:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  70a15e:	48 85 f6             	test   %rsi,%rsi
  70a161:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70a166:	74 0d                	je     70a175 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1fe5>
  70a168:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  70a16c:	4c 89 ef             	mov    %r13,%rdi
  70a16f:	ff 15 eb 7e 3f 00    	call   *0x3f7eeb(%rip)        # b02060 <_DYNAMIC+0x248>
  70a175:	31 ed                	xor    %ebp,%ebp
  70a177:	e9 56 e2 ff ff       	jmp    7083d2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x242>
  70a17c:	48 89 c3             	mov    %rax,%rbx
  70a17f:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  70a183:	48 85 f6             	test   %rsi,%rsi
  70a186:	74 2b                	je     70a1b3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2023>
  70a188:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  70a18c:	4c 89 ef             	mov    %r13,%rdi
  70a18f:	ff 15 cb 7e 3f 00    	call   *0x3f7ecb(%rip)        # b02060 <_DYNAMIC+0x248>
  70a195:	48 89 df             	mov    %rbx,%rdi
  70a198:	e8 a3 82 3c 00       	call   ad2440 <_Unwind_Resume@plt>
  70a19d:	ff 15 0d 7f 3f 00    	call   *0x3f7f0d(%rip)        # b020b0 <_DYNAMIC+0x298>
  70a1a3:	48 89 c3             	mov    %rax,%rbx
  70a1a6:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  70a1ad:	00 
  70a1ae:	e8 8d 7b ff ff       	call   701d40 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  70a1b3:	48 89 df             	mov    %rbx,%rdi
  70a1b6:	e8 85 82 3c 00       	call   ad2440 <_Unwind_Resume@plt>
  70a1bb:	ff 15 ef 7e 3f 00    	call   *0x3f7eef(%rip)        # b020b0 <_DYNAMIC+0x298>
  70a1c1:	ff 15 e1 7f 3f 00    	call   *0x3f7fe1(%rip)        # b021a8 <_DYNAMIC+0x390>
